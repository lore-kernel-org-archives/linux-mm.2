Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AD37CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 20:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CBBB6B0005; Wed, 13 May 2026 16:45:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2C36B0088; Wed, 13 May 2026 16:45:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B8A06B008A; Wed, 13 May 2026 16:45:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0B86B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:45:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD1051C06BD
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:45:55 +0000 (UTC)
X-FDA: 84763578270.16.01AADDF
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id DA22E4000E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:45:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LQIcMeMO;
	spf=pass (imf01.hostedemail.com: domain of fmayle@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=fmayle@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778705153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m53iicsreE21DbPts4Cr9sEZPT34XWA0tD1193/bxy4=;
	b=B7IvcjZ93gEd2NJHG/QTbpO6uSZ+NxTgIkmss5dx/vzMPd4Pisu33wUxhAjG0Zi4fXgs9u
	gyFnaoAtiyCam4n6LnHJuJ9BO4Pij+oaiNojDWx7zsuafq8E9NX5RUc2RzzXtXscQP1PDh
	dlD3TQ83x9GqKL0iw9LfTP4grJbZT3g=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LQIcMeMO;
	spf=pass (imf01.hostedemail.com: domain of fmayle@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=fmayle@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778705153; a=rsa-sha256;
	cv=pass;
	b=V6zxTJZ47C+UyJjkuBFGv/VulWrBmFEe9ki80n6cBybYuIySBcIsje1er38TNx88dsicge
	6uuhDnOWpGRnykXN9w7Ufl1lJSeF2DS5EzL86Z5x34JocoFVrzV8XX77htGFCv7jwLUti1
	P3k8FE9UK+RYf0obLwRN0HFL/7Xf/D0=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-132cccd3d77so381c88.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 13:45:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778705152; cv=none;
        d=google.com; s=arc-20240605;
        b=CYJN23UmM76NTxBvyKn6CCJpLjwXhYcXIa4PVUMuxeRZubO3OHEXVvF5ye0qs/ekDt
         ggzBi55ofs7Tb7QdVJEyd14tSvWICVHvKS7X3Adg0mZJ6oC7KP7/fqB5aKidfMTV45UR
         YvA1goF+FLFFlR6lqfz6M3nvX3d0PeyESsgCMDz2UNHTTQrTNaIPu9+ssAq/mShvHWUl
         yhIHmfk0HX9mO8wzHEg4YIKbjcKsqRRdDwBcukbN8s6kDKEmqZ+Ih8etsshYiZHVWyBQ
         RcRe98CWnGGQrWevyUGleznf4/94bC5VPJpSZQ9ajRQ92Gy3LOLDsI3uPGXGK/bzNzzz
         B4Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m53iicsreE21DbPts4Cr9sEZPT34XWA0tD1193/bxy4=;
        fh=Mkyyjh+qL3HKfwonjVpjhLAIpF7fabGzWNOKk3gBdWs=;
        b=AM5ujZUeI2EduO6vW40hbhNWHH5EW8rHBrmaE+NIKL+pTd1t4bJHv22ix0/JCfuRQR
         rPDjf1e+uP7u6Kn2M5uNV/qN6iQRi94ZKpwwOKyFfPmDWoaVWGTDYygSMcS/9ynzkWVC
         LcW8c5HO/l4Y/pYkZMyBs2EDQ8Ty6B2rlHQa+n4pJ8yf14DsDYmB+IosJloGHB+7FN32
         dgycsQ1AcGgqQXl3K44LZztus6q4VpClD3D3ezzaV2RB+2OJRvOYPcaSrWjE4rk1xLPB
         7xV9O2jbF9AwU9xOaa4NWdrAdVq+wf0Q/XxT1bUp5ZiPn/zeuaGmuvhQB/lLFNkenhIA
         zW2w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778705152; x=1779309952; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m53iicsreE21DbPts4Cr9sEZPT34XWA0tD1193/bxy4=;
        b=LQIcMeMOtHiceOPhmKxmQey7d2ySfgEV3stBqJhW34QrA1hiTeOC3Du9TfoVcMzRhJ
         uT+uZWGQsdW7KRiO8+WBjWuHPMw57GJnblRe0ZPzQMMj8Pi3pOXAkTYp3fubtpxBwMFc
         G3+JJ8tVOcGDp1kAKY95uTExEez2Q5Yntu9KPtHERx4a2I7Hg/R+JENGL1oMwo3YvLUT
         V6VQjXOcwewDEooFccJEFSuoc8lUhwYK054SkgH3OCf2UZIOuTqS1dmytWJiZECJaI0H
         X3+3YIFd97QEJlf04A1gyTnPRGrzQPW3gxsHHaz2+owKl4hXuSq9JltNTvcftoON4wyb
         tD1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778705152; x=1779309952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m53iicsreE21DbPts4Cr9sEZPT34XWA0tD1193/bxy4=;
        b=KB+roHx81ey3lfQ0wRj4vkEXHigoOLR5rYH9lPUBizqPaTtQX4Q5uKb/gXIn8JOyft
         s22oc8AI0xtaJ7v4C07nIX9EcH6D0VPDaL7J4SAMWrIeNeWKZJ7vWztKKuMD6zzmze5v
         M7fcFa04JUECmP73bme1dVQBgUXIJ6EkBSNZZsA42sjaHvk73tltwvx14/+khWMYY1cH
         EliofyHrHf+0tkC6whoP4WinFbJvYqBLUy0ynJS565lrZ9Z+RWjhxcTiIrVcr4obSjLt
         BPVcayvy64VX3xd1VI19/R7gr6RPH1jE34/EipnWKM4n0srY/u6nAu1ONNBflGgtLjrd
         gLvQ==
X-Forwarded-Encrypted: i=1; AFNElJ81lr7fxlMDoJGuEuZRmKRdB1EOPG+pWYCcDOEz4x6BRnPei3L3ohOKCh7E1Nrlrhr8FSCv0ZuO6g==@kvack.org
X-Gm-Message-State: AOJu0YymtGYQTWENA6r6dsPisL2Dl5iRgh/47z7/GKwprabz+uzlVdaM
	782bkhi3kZbz+37yH8NnFVS0tYNL4Uu2UHgCiNaWRebSq/PD1AWlkkL7JUg+OShUlndGbRL0VCv
	Re0IyFHTlAESzhAvjvwoVBM9+2Ao4JcM5Ik+kcmWY
X-Gm-Gg: Acq92OEkqJGspO19o37kJHRG/bQnllTYQNiF9Ar38tv1kpS4yP/dFLWWsA+I8Yjm7lo
	JJP8jaBylmqk30XX/7MZRiBez063HITT+UVPraQBhULDP3qFGdtlzrhD4WWSRfXHHY96Ta+K/BP
	7P3Ac/omdMNMpswPyD8H7eDkAjirTwZBm90KrMMgQitr+L5bnPSgcTF6vj3shtoKaxAKh5kQL7d
	392tZJ55KffixME/o8OaU7fHjA+/ziReVz6ulxIErHRn70Cdwp54u/iIHD7nA0afV7++Fb1Sete
	PE3kC2APxRkzrgS58suqmE9nHEpXkf1DFdd4cmiLWcXyhHpLm8gT
X-Received: by 2002:a05:7022:b87:b0:132:83e6:1d3 with SMTP id
 a92af1059eb24-134d2ed3806mr7612c88.9.1778705151850; Wed, 13 May 2026 13:45:51
 -0700 (PDT)
MIME-Version: 1.0
References: <20260512203154.754075-1-fmayle@google.com> <20260512203154.754075-2-fmayle@google.com>
 <agOWHm00w2vlh1_o@casper.infradead.org>
In-Reply-To: <agOWHm00w2vlh1_o@casper.infradead.org>
From: Frederick Mayle <fmayle@google.com>
Date: Wed, 13 May 2026 13:45:40 -0700
X-Gm-Features: AVHnY4JoNUxWMLfHqvAswksszrjv1afld6NLcRmBaT5S7_uKAQt-Obem70l4o8Y
Message-ID: <CAHCxdc41Zga60eZ+L-=6rizr1DSduaM12kGL9brxaZNPMpgKXQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/readahead: add kerneldoc for read_pages
To: Matthew Wilcox <willy@infradead.org>
Cc: android-mm@google.com, kernel-team@android.com, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jfh9wi174qg8fsicnzt3u4raxoh6yynf
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DA22E4000E
X-Rspam-User: 
X-HE-Tag: 1778705153-348820
X-HE-Meta: U2FsdGVkX19/K8mR2rrTiRvHylGVk5I6GSm8TDNj8pc/sao3S6/ru/pEgDLaWYaCFMTb9d5GspB43/JaaBkQyZqve9C6hKjuBqUMIpX61RzKH0DFclhmvaL0rxiyGeT8/PW5uXvYCHzVSNp0KqFkwYPhEfZW0tIe1m9dhZ7+fXn65UaJ/qwPGdcIWD1RQF6oDMQpfSqlLY1kSyyxDZeHu8Z9ao+HmwANJVU4XdVXxlAem53z0Pg7Qd8eyNZhTejxL2QhA4z/HWSJEnbz8OgXPg5vIINIGbBBljZSzJj4bjU89GMC9vUCXC1DM3b16v5cp4NX5aV1x3aGPC6tYzMCIpRGeb4mMPl5wijJQgfDBVXUiE07yPkZs/pt25aDZ0QB86Kc43HfBGX4cAtM5YTDkpzpMx9k3gobfGYwAFdO/i/cvyCjvMiaX8w7b4goBg2Ojyv650x0hqjq3I28bKHvq7F9PN6nqUmQU3rxgY5xCuLQ8L07ZzK0hgCTERBXpqo1roMp64b3pFskGAB8+FgiZxXeYxyn2br8kfFiS4a33cGJrMK14PPo55VIV+V7G9eVWSP0fT4L+Rop4FFqm4+udVKt0n7wh6CJB3xXriVDd+q/S6PEnHZAB45LldzSuubz6dPsRvVuGqdlEYn6qqlZn+ihMhK0KbsOgTcQ6Q//9HS5cxsbID+BlE7rlZIVUEho0Y+r+P3jDzRCDXs4xR1ZzCqbrCuzvdSa5TyUIBRLD7Lp94nTrq30gyTHtNcDdERNLJfYnRzBMa7MriyW3f5YTg02HJuBNq4UabZIDUj6XNXkequYzKOnSnQ0Eh8igIsfv6DuUaARRkoUlrYqMk9SnOsZNju+vKULlTkHJrsZ6yo/a41taLO3L0jHquUosnnw4maHV1Z9z/tUfvYxRKy9cRhF9wcQ3Y8xEw0q7BFqFDNP5sOIhFMuQtMREvytN3xAmC9Lpu4REUdDxZp8f4/
 HKmFJVxp
 aT9n/ppslSpwl2pr4gUAebrbzRdTEIypvPYds5kFkWo7i60VsPS5FTAkhoyfdS96gAXSRg/q3jwKvSsR2ZxXEBWlvVm7i0eZ2b8l2fIzeQEd5sFC+tBNQm2WsVEBu5ehYuKllZfthp4Rd1H5Tc/pn/tjUrvMwhF1iEw4uGi868zlDBpBHMTGP4gdAd+B20G8oNB4u1X1iD+Pz5n/K1fU+/nmjPeU0rF8+LiaHdLinCE0gUSri6VOEk8Y8U0Au7cVKQErh5MYNhFHjeauoDMZb/OFeuFan0HLtax+I6hKoiia5cOGS+LxM4cU2ECWOpU3/woz1Nq0byfcTU3ivHM8YL9bbbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 2:05=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Tue, May 12, 2026 at 01:31:35PM -0700, Frederick Mayle wrote:
> > Formalize one of the invariants provided by the current implementation
> > so that callers can depend on it, as discussed in [1].
>
> We don't normally write kerneldoc for static functions.  I'm not sure
> why Andrew told you to do this.  I have no objection to adding
> documentation, but I don't think it should be marked as kerneldoc.
> And if it's not kerneldoc, it doesn't have to be written in such a
> stifling style.

If it isn't a kerneldoc, I can delete the essentially redundant argument
line. Besides that, I think the stifling style might just be me. Let me
know if there is something specific you don't like.

