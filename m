Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97196CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 13:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39728E0093; Fri, 24 Oct 2025 09:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2C28E0042; Fri, 24 Oct 2025 09:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D64288E0093; Fri, 24 Oct 2025 09:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BC0E38E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:29:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A269140B01
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:29:14 +0000 (UTC)
X-FDA: 84033089028.18.C859626
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7790C180009
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:29:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PMvn0Z1P;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761312552; a=rsa-sha256;
	cv=none;
	b=YUXA+vVJ5bQs6kDmNkSeyAZB4qT9avisevyGq++h9gXbGq4kkdOYNHUeTYk7mUGLiHodjI
	2Rn6BLjwS1zT88vMMlinYjQTAF/cHEpq6AsgolDTaVO1loMourH618GcRNhZLZei5KRy6x
	6ceQoLc1Fs4Iaz39xdPJIAucEf2s9jM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PMvn0Z1P;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761312552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UXdtgGSy67AXQ/JN+KMrNawdFYDZClThA2tajsuhr2k=;
	b=DzrtoFXVKvCxzeq1QqWZuys4g0wZA3pnSXrxFpSNwj8RLxcOH8sgP9T1Rzrlvelt2kmD79
	GjpVEdGwkaen1BSnWh0ElnqNYmZtJFACbSS3AJoS5bZLckwbQB2Ae692NDrtRuO0ZwrA7v
	PZX0GWiPt6TEQFyj4nHRf1IiMNyz9l4=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-63c12ff0c5eso4301727a12.0
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761312551; x=1761917351; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UXdtgGSy67AXQ/JN+KMrNawdFYDZClThA2tajsuhr2k=;
        b=PMvn0Z1PBRvdrceu/7XgF7fszSY8T7cYedKJD+QS3hRVPrDkEuHWZnglk3y7RKdCtg
         fY1lmPEMs7HXQYGtDqXqr1KxMmLC0bxH21Wz1r5TGcLi3uUZFeTVtOuAIrglJxcxljih
         91wMZxqUQyJnpE0gquMX+yYpEJ1PB6LkVJedSG9+GL7tqpiIsVsoRsleFJOjL1a6o0Yp
         YPEOCkw7EpOgARwTd6y4nEV9COiXLyLTa7Fs6Q4tk56XiepxkfhEk8HxffsokxpoEmg6
         2KUXkNtVB9dbGbTVXdrIy2VK699on5+9SgyyrDTYHrW3HpQRxRwAOyQ979hDdL7ea1Fn
         9Wug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761312551; x=1761917351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UXdtgGSy67AXQ/JN+KMrNawdFYDZClThA2tajsuhr2k=;
        b=V08whOxpLSTHXugUAMPwGqE53ZMh8rivUpgr72ZWHsu6K0kRlDT+tpEy5+NVZe1nck
         ZFseyRkgX6BBoPJk+unx28Aouu63V1PFvLG/cwEDq7NmVXXmzPG+HXYNw62gKwpffYRy
         zHUFCF99HisSWVVXLcvrP7JL67irSPrWGeY1ri6Hj8ykC7BVfZM4RuSa7IM3NbQTNl8W
         dPB2mQwZShhrnF9t1gUo3N89YWk4R01bBh39ccuvWhefwhJi+kr3v53zFE7y/oEYjj7Z
         KWTQnmqNGHvtjcPaGRnMAeDPVfHrfmZay6gvmbgsQ/2chbwBHR1CtztZkygGItYTavRp
         4cow==
X-Forwarded-Encrypted: i=1; AJvYcCUqM5SQT2DoEz2CL4MaY5cU92uP0FNj8R/wxz813S3GBLT/SHFBKYuWFh5VSOwG40AJLco3cvID2Q==@kvack.org
X-Gm-Message-State: AOJu0YxDqOy/wRghCHSzC5dgNjuh8nn3iOnO3JAweCQ9+d3PlzEnkKjQ
	YaBvWs0Z2EHULaLYdx3bgfHUYMKmiz7pWyYK4EdGSiixgCodHRtfL4DMmepJLi2SvzH0nBp+SrP
	0Sar1nXqNfruslyWffOmU+gfT9KRFcoPHwFYNKAxryQ==
X-Gm-Gg: ASbGnctOBfomKrcmTlTrLMQ086hiFmi50GZtxFcoYYRZM9VFqbUclMyDY/1+JRsSOaQ
	Iun7nEOItUSbCIKa5bu6fPPA/bB0LXTKF/E0kHR71CHSxq3b6ZzuzXpyBqH9TWXd41HxPDSLzo0
	w3Fa/shCSIk3EBhe+JLYGssq1GGnaYK1LL8w39fscLVy93eH1pRulhu7heaWoFpr6fhqByGZFbD
	2Sdau5UQQ2K4IX9qqjeEpfOxlH3BSpIQP+fmVWZdtF2oJeWBOvdyTmKTA==
X-Google-Smtp-Source: AGHT+IF9MiMCR+Z3JtT4KSFyjBh3HzN8cHN6uyk2vE6IyQ6AKjCXbGpL+3ybW4eaSvJVFraK7LGXZ7DDpV/DAUCWP3Y=
X-Received: by 2002:a05:6402:177c:b0:63c:f79:91f6 with SMTP id
 4fb4d7f45d1cf-63e5e905089mr1789898a12.6.1761312550105; Fri, 24 Oct 2025
 06:29:10 -0700 (PDT)
MIME-Version: 1.0
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
 <20251022005719.3670224-6-pasha.tatashin@soleen.com> <mafs0a51jfar1.fsf@kernel.org>
 <aPnXVmD3cNmYNRF_@kernel.org>
In-Reply-To: <aPnXVmD3cNmYNRF_@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 24 Oct 2025 09:28:33 -0400
X-Gm-Features: AWmQ_blGhDYvfV9psBHWFmiE2E4dNn6kiGgtaPdxw9qpGoO8Tm-jcSBJExmJsMY
Message-ID: <CA+CK2bAvKrfuOXTa-RWtcuSR8rkPMhurwCn41NcUm44_vT63rA@mail.gmail.com>
Subject: Re: [PATCHv7 5/7] kho: don't unpreserve memory during abort
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>, akpm@linux-foundation.org, brauner@kernel.org, 
	corbet@lwn.net, graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, rdunlap@infradead.org, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 7sznhgmz6gx19nx9syai4k5jq63q5sx7
X-Rspamd-Queue-Id: 7790C180009
X-Rspamd-Server: rspam09
X-HE-Tag: 1761312552-688079
X-HE-Meta: U2FsdGVkX19G5jcz0sJnO3i4oQOu/MRGh3/hKreUk08A4yHGen5kw5JzCy2srahM6/zrxtiXPT62xB2wjJso5u4zQtESyP6iT0mklUhbOBtZ/NZvQAw3Mq3JRf116rrRaEt9/QcKSjsZoZo+oHVtYUrjiaBB+R+Ic6F1BHrxx87N4ft90mwNGiEfV+fifvJxgYyXgaEkf/kjuiL+89E4210dA4fbtlCcrpHUsWPWqS5pm7zV6BiBeigTXbkbbCIjlZJakokOeS8d6RexNb5PnaQ82I0+F9wq/0uC7QEtfqZaLdMhltsTw1xTfAq/CPS88r689qODEvgrxpS1oAWD7LcH9LEsSscYg+pSBnRlDIXtisr8/CGPQ/JSdQwNUZf9/z7wF4iqqyFKuE4/5/rWt983FTNdTZZV+lcyZ2fJ7AJMrfrZa+APzrBnEOLqOM0lhWFeA4LmjGbgfvIJZCzRjHdN4SeO9mG2lmd2+BjYjAGkxTGeB9PF6RWZhe1SUV/pjaLwZcVWeNzN9VpHF1tOff6eSn/eNaP7ec/H0xApQjIPwENRfRxmg26qio8UHpcs0+xN67R7xqTUjZjWQiNrJlNpxYoihsO+NYSS3nLhoBPi/ih9hpvtvaYnJeekHbhiVmN0FNr3wA2cHsTmCuNk0v7ga8dNrfoLHJwyBeepLopB3X3pAfzA6/JYfRobW/Op3q4hqkWjGxvjL0K78f/WXK/y+NKDUAxZfyFK3t9+8hwGbcEC6Lhl1Wkr0sknU6FUWH9LU/z2eAfg2dNmIaVMi81WSkw/w4LKWtajNDCyP5MMFj171BDW501NJWwZxoYaT1XYEd/wioy/5t2MDPnZ1/C9VE+QzwhXpYEkyzHWGV9MkyP91QRlDi4OjDC4fk1GrPU9qKxINDlmbFIXuL4za5MsjM8vkZjIWX0XXYN/ksQOhRb4wYej4xmIVK2nxf9g/N2EdTGbeoVsAVna1kk
 5Dq1ErGB
 frkj0tN0OIlmzGo/TxFlUczBGPfSrOmtTmUbWfEFBbZosnmR4kpmkd6jw7jCCG/82o6tKXYv4dol2rbg7xbOKJ5d31mc8ZMoejypS49fvMGRnfXLeGOozEQAPkxHluyi59f/Dikbfgd0u9esYJAKx1IXO6A26MbvG3FciE8Lk791XJ7aIqT3xYORUbecgvE8FHcXwOLKnrkaCgkFp7AOqITuMyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 3:21=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Wed, Oct 22, 2025 at 01:15:30PM +0200, Pratyush Yadav wrote:
> > On Tue, Oct 21 2025, Pasha Tatashin wrote:
> >
> > > KHO allows clients to preserve memory regions at any point before the
> > > KHO state is finalized. The finalization process itself involves KHO
> > > performing its own actions, such as serializing the overall
> > > preserved memory map.
> > >
> > > If this finalization process is aborted, the current implementation
> > > destroys KHO's internal memory tracking structures
> > > (`kho_out.ser.track.orders`). This behavior effectively unpreserves
> > > all memory from KHO's perspective, regardless of whether those
> > > preservations were made by clients before the finalization attempt
> > > or by KHO itself during finalization.
> > >
> > > This premature unpreservation is incorrect. An abort of the
> > > finalization process should only undo actions taken by KHO as part of
> > > that specific finalization attempt. Individual memory regions
> > > preserved by clients prior to finalization should remain preserved,
> > > as their lifecycle is managed by the clients themselves. These
> > > clients might still need to call kho_unpreserve_folio() or
> > > kho_unpreserve_phys() based on their own logic, even after a KHO
> > > finalization attempt is aborted.
> >
> > I think you also need to update test_kho and reserve_mem to do this
> > since right now they assume all memory gets unpreserved on failure.
>
> I agree.

Hm, this makes no sense to me. So, KHO tried to finalize (i.e.,
convert xarray to sparse bitmap) and failed (e.g. due to OOM) or
aborted, so we aborted the finalization. But the preserved memory
stays preserved, and if user/caller retries finalization and it
succeeds, the preserved memory will still be passed to the next
kernel. Why would reserve_mem and test_kho depend on whether KHO
finalization succeeded or was canceled? It is possible that user
cancel only to add something else to preservation.

Pasha

