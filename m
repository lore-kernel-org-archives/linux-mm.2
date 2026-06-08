Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06A89CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 16:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 480356B0005; Mon,  8 Jun 2026 12:04:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431216B0088; Mon,  8 Jun 2026 12:04:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31FCA6B0092; Mon,  8 Jun 2026 12:04:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 216B66B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:04:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CC56F1A01E2
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:04:51 +0000 (UTC)
X-FDA: 84857218782.03.54C96FE
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf16.hostedemail.com (Postfix) with ESMTP id CD363180014
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:04:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TAzeAMsN;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780934689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CDdhbWCx9VsAlPpkbZ7T/pVekmt8/mWg3u3kSPoOV2c=;
	b=EcE7gZjoERQxoaSYqwuirQOPsKB78bWigqHLEZA4t/G3UomXJm3ORhyqvKAvI+/lspVoZX
	77rlW+lnf6ZEcTyrgYjjz5iw6Bzo8rWDS+ogjjtCglIZxqA0QTlgTgBzmQkosnuKqX6ir8
	tCYyRFRaMlC7sDG4N885BwBB85Msvgk=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TAzeAMsN;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780934689;
	b=SKR8KZVxb3zFcdG6x8lxbu80PGj5JKpDz+m9jEQUD+D0Q3kNLquWnWam26nnFSqPNzPs8b
	Ovlzya8WnQHiZyOUoup1uJOYZs7+Qg15YyBND3+EA4VFvX/QWb8jxk3dYlfqPuu9UMblRU
	WMMHohX3px0bL3ZvaXErr32kK+egXAw=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4891b4934ffso227675e9.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 09:04:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780934688; cv=none;
        d=google.com; s=arc-20240605;
        b=fNl18GOdl/DbyjzPm8zMKq+pL90Aht1VrMiGc4BlPjJyFq0PSuJ/7ylYfg7btxWbe4
         qlfhdXg4C18Z414SZi9n2DR50xHi3dem/TArakdvPC+GOc1hKzvyTSLqqQDC+sdOdbAG
         xn134KDmf2CjxYkrMCxeYY69Va8iGW/EBKqdNcS7RrDACbC6WKKS7DN/4tMl+PMVqDkj
         A4S4GsjJ+mvrwQyr5qCtH3ihROGqCRNr0mDH7ZauV+JaywU2cs0edH9Ip7e6/SW13r93
         auK5Q7esJz8H/Tp8g5Wd4O9rORZStUXoUZGQ6Vy5AhrscF8VFFl+3ZhAwSGN5nPkoz9s
         holw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CDdhbWCx9VsAlPpkbZ7T/pVekmt8/mWg3u3kSPoOV2c=;
        fh=UKCi+ExP15rrfvmLBZzHTVs1a3+to5Au15t4s7/GkDc=;
        b=iims38ib+6zb1KweN0ByzJgNBJcabQctot002SNlgfWtRwbVS9n//vOdeEXOXWecPF
         GJnwZFAQdxpb3liOFbBXjz6RcgTcmdVMcHcPJ+ckn8i50oLwgDKBd86fA29OKW8Y2jgj
         F+IMmIAsTuSGDftwm939tZjHRnM9fYU5qkxKZe0ndbAi3lkxX4oBEnLKLChP4i67tOLw
         jnA9CCI4QXFihntfHJpiZhIb/qZ+rpJtrbQD1cA1PhHH8CZc+8RYUg4PFH6tcXJHhws0
         XTblu1KBFbSaEayzMUvOQbrcuntJpTHKDc8tC1TOEItW4uMhCaZcLhVjbSOtOV6lHyJH
         Ndqg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780934688; x=1781539488; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CDdhbWCx9VsAlPpkbZ7T/pVekmt8/mWg3u3kSPoOV2c=;
        b=TAzeAMsNO+21xGGhCwilLnV/H58v/TUFtaekE2Cn6oNYZ9z/wxtN5fqQGSseLx8xcm
         LePpA7H5G8TNDiLDG0ZvKvpG0G+kOXhL7ODSOsN51Bp5v9IkLytwRK3kzYdaLFnKRgre
         0Nq/C9ej4D8vrlhRDtK8ZxzLps6D+4R2dGN6dlBX7pahfvxAhsfJodawPRugzcNF8FJC
         3fhfLwrnp03ajs4PQPSVBNQ8aB3K7NmdgpVRID4I6b6S10WLwsqFZxX8m329C8B+Cz1C
         ZRYB6N+M32w4TacpZ8Pd3R2Zv3iiUr7Ez7pgK24GzmbAzNgbgqnfb+yugEvhWQDQEKuz
         YYDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780934688; x=1781539488;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CDdhbWCx9VsAlPpkbZ7T/pVekmt8/mWg3u3kSPoOV2c=;
        b=IUXyoJ0hHAbiS3cMG8wHgarY/WLyLHXTHBcvJsKEVD+kVM1EuWQ6Y2OQoEBq9ZpFfw
         fPT24g1DY5L9xI0GTqGm5/SG5WLitrSZgnBHm66ZqAnGvwUglNykV4/MxPF4qHSktK3U
         fACLQ5FKhVmvGUc6GAcvza/8I6Bh9a6wlzvoWgKvptWM1N73b4HNYwzn6wxt/K7v8pXS
         E7pAtd00cCuDPfE/xA7nLo2E1IJP1KXEhpGXbSlsl4q+WcBKAAYNw24QJ2XrbOWitcqk
         oEYyab+1R/f871/ahAhyD0h/QToN3xaEDkKBgV7lM50GWB+ShFtNGE2+HN5Mb3Sw0UDd
         HmTw==
X-Forwarded-Encrypted: i=1; AFNElJ/h2DE10c6Vb5r+GYOEs9Ss1a+1QquIh7pe+wsG2aSqxdnpnJ8vNJPuA1RLAZl2IkN0D7SP0lIgkg==@kvack.org
X-Gm-Message-State: AOJu0Ywj+Km3L+JedvATBV8NXYqTzQOeXBJsPsssMlNXRs8QeRrv8Qsp
	vUDPnqftknfAXeKhceJTos0iX5qpE4Q58f64ThrK5RovHJVa9WRpaYcCxWNf6Yhws8VeA/e/A2w
	U8Wmgd1e7mvZuR9HwlV8cSbzfNuTx9EHKuhRWytsm
X-Gm-Gg: Acq92OGLyfxvI8PPNlvdk05A3l5OMawH3c9K0w0V3yhyMG+VcK8NUxyoewHnsL2hDsB
	okv3Q9/OmkyPrXIjzt82YvE5cCsuWSPevPKElWcwk6hfxnTqoRdod0a/Rtfj03BPcme7byCf+Q7
	qU54st5MQM2W4Ds1WjuPN+BS2THDYRs2L7lVm+XrdsoZ1OVWDf3dWsbhAlxF12nrF2oelmW7q6r
	jkRq+gMvwdKnaXX6sW4BkcEe0caECeh/z2F80dJdmyfigUCmHOgq6uBGQOTp9/zaZmx13Mc6QJW
	K1hQv/31t5i92MrtgWmIK/ukAgo/Rbm+MIUzepfXaE6D+SUj
X-Received: by 2002:a05:600c:3495:b0:490:b0f1:3422 with SMTP id
 5b1f17b1804b1-490c2ca21f1mr5078185e9.10.1780934688036; Mon, 08 Jun 2026
 09:04:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260522225853.878411-1-tjmercier@google.com> <ahPqbfH54R3JJyaV@infradead.org>
 <20260527160716.GN2487554@ziepe.ca> <20260604-dangerous-tuatara-of-sympathy-28e05e@houat>
 <CAO_48GEJsg4X7++zg-ztQgVibY_FjjManaA5_W3usjicGUQPdg@mail.gmail.com>
 <20260604135712.GV2487554@ziepe.ca> <CAO_48GH3NP09U6TdB5drbKY0TpwvtBXwrf=Jajsr5ttNbC_u9g@mail.gmail.com>
 <20260608152743.GD2764304@ziepe.ca>
In-Reply-To: <20260608152743.GD2764304@ziepe.ca>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 8 Jun 2026 09:04:35 -0700
X-Gm-Features: AVVi8CdkX2dlLd8iv_kbStMI93TXdDT01BqcU1-TGKHekXSJtH26ENHtm_IhVVA
Message-ID: <CABdmKX18EXsL48Cv1Kxrp0g6bVndZfU9b5pfeGgQyvMREk5PSA@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Export set_memory_encrypted and set_memory_decrypted
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, Jiri Pirko <jiri@resnulli.us>, 
	Maxime Ripard <mripard@kernel.org>, Christoph Hellwig <hch@infradead.org>, maddy@linux.ibm.com, 
	mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org, 
	linuxppc-dev@lists.ozlabs.org, lkp@intel.com, linux-kernel@vger.kernel.org, 
	iommu@lists.linux.dev, linux-mm@kvack.org, agordeev@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org, 
	Dan Williams <djbw@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, 
	Arnd Bergmann <arnd@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CD363180014
X-Stat-Signature: 45ou1bkbfipyq6kbsgknakh4q3a6rwqa
X-Rspam-User: 
X-HE-Tag: 1780934689-361827
X-HE-Meta: U2FsdGVkX1/H79Kvuvaw/CdXO8CdhD+KAsPA/Kz9YDZR4XaEoIdmQw4P6UQpmolTrcdCJWe9pUuTqVF1UQEgzKR2KUuin8qbsdnb5IfKdR9d/Y0agWk7P9crfRa2YMlon0Mozg6SGe4e+GDL3F6muhyJqkhWd3gFe01Z7qHadNnCbt9f+8r0aU+0088XQ1MxKnw8Lq7hncSh6/tKvgCeVh8/w8SaUU7wLT75f32rb5hU4IV3EMmlnkjCQ2e7Xr/ptJZhSmOAm/ZCC0kkqB7EO5JQcqPR2CQBVPs6j5T/XcpWO/wsEPfXIn3IDOl0ZUQ2A/gNSCrqgSkHHUG5MdLXT56GImJojxoOFZgg0/4dfjugkUJ8F6MAZeZKrjxwn+i+yDKK03MkpHEAIeAKKwcWVpzkMCA7TOliJYXx7YnBMjkiYLAmA6VSTiXAu3goi3XSIHZuZBL/lWFil6L9MjMEGkI0AMhvQ82O35R0+iLcNoaeWbFcTGZ+yBdQ2OKq1fsXM5SN4lSV02Q/oluoiFnswOQgAWOVh35958XJlmEDU62MC0h/Lp0VZW8nChn61d0xfmBQKTTk+vCBg/ivwJEvMcfBU6ajfb79CbjWXQ3iF0XNlmMGe1gCMkLHqvjVderqj3xMubpY77CUL+kB3DAuNQaeHHyjSnJXG+LVJrdxS7YKCFJvifv2+NQAvTO5LsX2sq8FrJsrINL60eLe8QnumZMdoeg49xL7JGZN8oXTOq0jCiXO1iLsXFkjueU1RL2GahZ0tOvlG2xk+jr5nLP0poyRbYBUIek6UfVGJFIokFqnu9gCfSsqE5dMy2ZF9E7L5TcBxU0RLPlTuRfo7xqYX/fVykbWkfJt7oXz8CWLLWH4SvyFVrBBG4ZISNGuBbJYoR8wr3TznSClnIwz9hZEuODPHZJgM/zVvGwbI4m9zr/esDrBj1LZx1nHi/8JYtqSQLe/OmI5Z5QGPhuKuCc
 VurYmglc
 7n5UTq3/84WFQPFNlkhy8maQlY4FBwWJ6Wmrk/Yujuq6LXPg2Ekt8KD4N864tnBqjWCzUYOedOy/4JqRDCnTLWppfO5iFyk7BYjtzzKvNZTZdTAB5Y97ZSBa7c9okneForP2GWbJn2P1jUl0eKd2FuYwiABGXNSdR3l1N3W4tPUQLRUFAOHvi9CmUGn7LUZWv3i9W3/n4Fl60RtnUSsc+Ue7FiNXXQpoCjAMn+kt6XK5h0ekz1tHUfkIJh59Vr3eRB5L3BBsgFq6/YHtPTZb8NUJMuqvFdcBJvfHxVgZyBvRsZZJOqpOpHd2ASTp9C9y5WUoH+9PLYkKwWHWCunvCe4Revw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 8, 2026 at 8:27=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> wrote=
:
>
> On Mon, Jun 08, 2026 at 08:47:15PM +0530, Sumit Semwal wrote:
> > Hi Jason,
> >
> > On Thu, 4 Jun 2026 at 19:27, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > >
> > > On Thu, Jun 04, 2026 at 12:51:49PM +0530, Sumit Semwal wrote:
> > >
> > > > Given that Christoph's objection is not really about the modules pa=
rt,
> > > > but that the set_memory_{encrypted,decrypted} should not be used he=
re,
> > > > one option is to revert 78b30c50a7ac until that issue is sorted out=
?
> > >
> > > Please no, we have stuff already using this so it would be a
> > > functional regression. Revert making heaps into a module since that
> > > doesn't have a functional regression.
> >
> > Thanks for your comments.
> >
> > To me, it looks like while system and system_cc_shared heaps share a
> > lot of code, their user bases have different needs. It's apparent that
> > system_cc_heap users don't care about it being a module while system
> > heap users would very much like so.
> >
> > I also discussed this with Arnd, and he suggested we could rearrange
> > the code so that system_heap_cc_shared_priv depends on a new Kconfig
> > symbol like
> >
> > config DMABUF_HEAPS_CC_SYSTEM
> >         bool "DMA-BUF System Heap for memory encryption"
> >         depends on ARCH_HAS_MEM_ENCRYPT && DMABUF_HEAPS_SYSTEM=3Dy
> >
> > This allows building both into the kernel or leave encryption choice
> > up to the consumers of the system heap.
> >
> > If this is agreeable to everyone, I can post Arnd's patch.
>
> Yeah, that's fine for me for now
>
> Jason

+1 SGTM

Thanks,
T.J.

