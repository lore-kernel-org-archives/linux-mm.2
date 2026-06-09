Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 869A4CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 00:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C52EB6B0088; Mon,  8 Jun 2026 20:02:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2A1E6B008A; Mon,  8 Jun 2026 20:02:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40046B008C; Mon,  8 Jun 2026 20:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A4D5A6B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:02:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6DA0FA0360
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:02:16 +0000 (UTC)
X-FDA: 84858421872.07.07AE167
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6854340011
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:02:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=THfENzi+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780963334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6jO2zMiYZmPq/b4X5RcKjPTxPt+Kc/3uxUKCr70yH0=;
	b=tFJv1Ocudf9AjWit/4HEKRPY+YM8WsfTu7KTUAwjcTxs2j1u+/KHIhSG168WNKGFd7I0tF
	71EkjKGl5eOh7FoGKRoVd+U+svkfJCgAEBN5IC3RXvTtEW1oeGx2QCdkJCeprsSa0ofTHL
	qCPfNwFM8sNOCprTpgkxUP/aqinAO60=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=THfENzi+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780963334;
	b=Nl/V3YnKfvMjqf0D1WEHkpyrjlaWxuXvkXKb/5Tm+IWLKas2c6zaDjJW/eKVy/CZkN4UoR
	HgTz66bvIsmvoVw2Ak323yjyr70eFhHCO/evDcWt2hBeusH0jmNIlmEYqVamZl6REaYmCf
	qVczqiRyK8XMWYFgQUe0dqcrbr1DsXc=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2bf2d865383so379335ad.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 17:02:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780963333; cv=none;
        d=google.com; s=arc-20240605;
        b=eqUcm4YsPryeobjPTHaWEC4dgUyVmjoTKFic4qJ5rTMbhPjuj97T5s+7u28JGfjTl2
         iBcKoHSc13CjYcQrVn9hm44D2RIwOSuFmvSmGXA0e641+V7zVUJR1dhaLWefNv6J97iA
         YieY3hjcb5OVivuKKma0koWtUG75kurCaX1qZ9V60NAUloxGkvFczj6OD+j7ORtWpxYd
         h7bVQPh+x8rxjAwSi+rCoflEkpJXVCPRycNn3fIkDCP3bpaI+eHE/3Q90qE88a87ia/E
         YKarGAIJsvBYLTUo0qKVCGbPd6e+jarMxbtwsOm7DMXvEtSiLq0B+5rAv1VgVWocajxB
         pHGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P6jO2zMiYZmPq/b4X5RcKjPTxPt+Kc/3uxUKCr70yH0=;
        fh=QRNiw+3DYu1N+ABB5LDghcqrr4lQkIJY0/HNpMhuZgU=;
        b=gweb6E22oYk4rdOTBatM1s/fDjZB+VDqJC2eTDoFNSYnYEYRSe37GYnCtRj0qNR7U+
         brsrb7JhQ3+qCnerw58Bd5KWV1j2Y4PkPL98qc3ySKRrBc6+IvCjQqp8464ntf4vFwys
         YQdYM6GA/J7JllxN1goZGrml1EH4LTPizD+d0wf1TjkGxDCMNBkwB4r1vIchGSlIB8XJ
         pTriN0SlFwy+qdE+Ylokc4j+nKhX7mNyK/BC3NOOOVEZXx3Bh2cQWeucuhu8uwjx/dBI
         XER4juymdMBMuSCHrq5PU/K1w330i04VJM1yNEXfF8m+vUTlSNGunmNHzTDyytI5ZBCV
         usxg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780963333; x=1781568133; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P6jO2zMiYZmPq/b4X5RcKjPTxPt+Kc/3uxUKCr70yH0=;
        b=THfENzi+ymWVRIBXIO66sg0vqMamOiFfjJszecGxNVA6kJUP76u4HYJtP0IxUvtdbX
         TWVvvIQ7/uSh/J5T3Zl05tpYJaiGF3ZZurU49hxP0btl7SWTGLwkdWfNr1R5aVRxLB34
         i5541kfspma7dyw+qHsFhxwzbRg3ibKFIzPNZ8Vj4h7v7RWau973LLcR9AVf3aliCfNg
         23SP9GOaGV82kfnW0aVU/kuSfBlz2AXqOaCShSHXh+0XQh/Ry4fLhBm0VId+MxK+vDGb
         /12PgZoTL0MRmroYoElas+qaJWF5lom3YO6HAYmshapXiA/YO0FiSJO4xw1P+kpCQT1J
         sQ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780963333; x=1781568133;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P6jO2zMiYZmPq/b4X5RcKjPTxPt+Kc/3uxUKCr70yH0=;
        b=gcz4QvmhLunoOD9kip7fLuQm5Q+OynIqfrpof1m5b8ymio7mU39xfFd8g5gdiuQlYK
         I2cSiawrv2+WzWQV5d6wTWtFZywx4rK7MYj3Y/RXWY/91Xq0a0P0XHpR3VYVIZ4m5J6o
         7GUtNpt2lgixh0ixIVL/E8Vb3M/P51kjxJx63Z8l7CqvZ/yySJMtYYFMOC25GL2/mj4c
         sR1u5zJKOQkslnrTxRneXsX/XZy62wVnJz82fURuTGL7hpMzUCx/RkVvps8GHrMBSbvq
         jO/8rxa3dVKU/gnMDHL7qQcMBrYQ0Yo7mMgw9jQwQubpvKZRet13LXjkaLPHhTvz7FjD
         gKGQ==
X-Forwarded-Encrypted: i=1; AFNElJ/FrXzawX/m3RB+yU4kMIJx16ubmboBXvNk6VkSMySstV9Q0MP00lHtLnY8BTzYR0cK1soc+yUuvg==@kvack.org
X-Gm-Message-State: AOJu0Yy4gEFyojWCz7OfZILK/wQ6/DKidwA9A4ZIvyQOP51/bmb5rZSC
	IW/XxRpryTRU2iqAFxsvqfeI9pAJwsQSgw/30EYe4LPm0wWzasgshukTAH6DakrEYiHEP9Q1RCE
	b89g6cDdMzUcWlJxKOPzDeWhLdW39WQYUuZ2C6lXT
X-Gm-Gg: Acq92OH+gxM9YDezhDu/rEvRx4BZJczpUQd7wZiQi1kvRkiEABoDKe8ZYrwbP9OStnf
	vmYaxhYZ3yQzPq3KHoPIh9QfET0CzppLHYkeoR5OmgtmDN9vrQxwgyQHlg+Mn4AP9OErcLqCkk+
	xjLQ3WtICTy8NJxK9a3FaHKfYk5DHTO8nMVRb1OywN37wjpiPs4uSThR0pHrHNvOCUsJq3Q8Ebw
	lTZi76hO9WSYsM+QfF5t/VpqvwJoaSq7DFbhBm+8y4xTSplSmfeBAjNrDY8xQX6HmBmIOJEToSB
	BWX06uy00A92C18Q2JgodniQ6T+e75wMYDr4uBYNmFvfQ5p7
X-Received: by 2002:a17:902:f652:b0:2bf:1000:d3ac with SMTP id
 d9443c01a7336-2c1ebb60a69mr7515875ad.11.1780963332732; Mon, 08 Jun 2026
 17:02:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1780701922.git.abhishekbapat@google.com> <20260605170858.9ee9ca2181a041bb9a4c3098@linux-foundation.org>
In-Reply-To: <20260605170858.9ee9ca2181a041bb9a4c3098@linux-foundation.org>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Mon, 8 Jun 2026 17:02:01 -0700
X-Gm-Features: AVVi8CdAZnO7oMC5nuRHod0ve_zQgj1Rg5Mp6_fS9vI7HTlue0BbM9sWn_cAJH8
Message-ID: <CAL41Mv6pZOVacLdUGta7UnxmFryumBbN6=Po50KfzgLzMs2PQg@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] alloc_tag: introduce IOCTL-based filtering for MAP
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6854340011
X-Rspam-User: 
X-Stat-Signature: gy7t99siskd5hug5tn767azsaertg8m6
X-Rspamd-Server: rspam09
X-HE-Tag: 1780963334-446393
X-HE-Meta: U2FsdGVkX18nQSVcLSK/ojRhtwNcwNRNCrhCZm/x7S7s8UTn49eXZ8HbDl2Tj/mE06DtNTYNFhraMjL5PcuwzhCKWGDXSMyuyV7/wlJISpmfNfw14RhI4bzHHZ6/0OlkFICaX4d9IWhZvkde0XF869Pt028vDBbjngWY6E0xTwSywSsZ/Mr/9mP+4vQLh760NH8+DbJxOg5oTYIN5LN1Gkz0/WpATaRFz1FxsL7QFYDYRajaoiOAhZbtApxLSlIu3/WUOg0BgxAIE9Zm0tS7djOIX/t2Fx2y2i3Ov2a7eAa4CNPCL2Pp6O2kZxVsi0OX4elETRKAJaroBcR+dm6G4nOA00vIBwembp4BhYV1bKak+L+RspoME27nLvPNZrsqn1u7yZo/H5i5zGv4hEF3WiCGJM6LehJY7F94mCbiEYxRijCg/mbpHD6Nnt2ifFKcPpiNnQc5xz+t4OdEwpW2gG/5/RS+Up875xoRWJYXuFzDSgkAqE5Ba3w0ugG0mwGz6IvlFAei6Aw1czwo+Is3xLuiV8hT0tfxtLus3a42VYcQf21R4YdlBOUcONzvntBQ3vuwxH+UoTmRceiaeuGxr1OhmmMSUTZ0CJR3WigA8aOdkDvBr65/MNc042nOsjQl18DpbmTGrs+ZaFhCQ7In8VFRkLh07ovjlF23nLGMPMNh51miIqtviIO6g5m/my6YEHNZHLmENMdOyiJMxZOj0v4y2f7o7pC/Rsj4DgPukFzEGtcU41ILPizHt9oeMsBaCGPVmRG/eR3mcp21shrI5IP7JGzJXDCwXqAX0vbVGlqdvCDGeWEJ92GwxLZd8J+ZBkX8pc4HsWAIwH+BX7GEKHmN0vZgacYss2BBzjbJUHiSjpRVeGwgQTTDCxm5GmmYg2T1fvWCCeJLWrFOOU4BbdIqKr9EB3LNjJJ3zuuOU4Br+OVJf3e9Sj80Ickk0n31FmRu2k5avLdToXusQ7P
 xIPq4hNy
 5KrBh0DEFiQ5KpGuiD8s8sI1PJuUD6Zeztc5P/YKKDgHYeSZOMD5rNiqtt7QI8s74ZIPWnwMpW0k4VyJCoJoeUbmr3dhzRVGovTNY6RjaW9q9EvYAk43kofsUz0Vu1PJvOfcoy3O75gaPDQDiAcAlUWN/1KrIsNDA1gUTLIgBE91cXSkWXc9cr5Dn+U4B6xx4avLzxfkuze1jJKP9gFPZU7IfyyfTvjHaz8nCrbKU/OfBeVU6kwuXS0tEAyoiDEwfsljsu3ea+/KOptnXvfCwEbDdP00OFvTWCwUfjS3nnp2mwTcD6oONTIEmy6KhT5JaUCyL4R7oyHgxIeQF/KiprOhQnoKlo4WhjLG23/9liFDFQ/0NMs40ikX+1+u7q51yJRKhH8mL/O5fFqXN5ItO3iEp720UPUNH4jzcHvdD8Ye8Ohs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 5, 2026 at 5:09=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Fri,  5 Jun 2026 23:36:45 +0000 Abhishek Bapat <abhishekbapat@google.c=
om> wrote:
>
> > Currently, memory allocation profiling data is primarily exposed throug=
h
> > /proc/allocinfo. While useful for manual inspection, this text-based
> > interface poses challenges for production monitoring and large-scale
> > analysis:
> >
> > 1. Userspace must parse large amounts of text to extract specific
> > fields.
> > 2. To find specific tags, userspace must read the entire dataset,
> > requiring many context switches and high data copying.
> > 3. The kernel currently aggregates per-CPU counters for every allocatio=
n
> > size, even those the user intends to filter out immediately.
> >
> > This series introduces a new IOCTL-based binary interface for allocinfo
> > that supports kernel-side filtering. By allowing the user to specify a
> > filter mask, we significantly reduce the work performed in-kernel and
> > the amount of data transferred to userspace.
>
> Thanks.  AI review found several things - you'll want to address at
> least the first few.
>
>         https://sashiko.dev/#/patchset/cover.1780701922.git.abhishekbapat=
@google.com

All, please note I missed attaching the reason for choosing the IOCTL
mechanism to this cover letter, but I will attach it to the v4
patchset cover letter along with other changes. Thanks!

