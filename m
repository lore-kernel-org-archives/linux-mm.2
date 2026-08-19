Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00BE3C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 06:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16E746B0092; Wed, 19 Aug 2026 02:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1462B6B0093; Wed, 19 Aug 2026 02:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033C06B00A0; Wed, 19 Aug 2026 02:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA74A6B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:55:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5960B140459
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:55:55 +0000 (UTC)
X-FDA: 85117109070.30.5EE9176
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5A28F40006
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:55:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=S2qSPev+;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787122553;
	b=5p4fVHmy9XJcVVqRtCPsS6xY7gfkLGhPtU0YU6/INxA6sT8jmsLE6/V2mGpFK72gT5tqr7
	lauC8noiAa15KYfHFOtaN/Qtgs3kZh5OTuwVlmGaKnJXtFKARmzmmpalqGstnWZBkEQJFC
	zWZrQXYHdd6iA4ZgA0otvJJVK/2azJQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=S2qSPev+;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787122553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hYNBkArvM0Cl5ZB89avtYxazzho2TcwquWjPuU3Io9Y=;
	b=4ITJIdwymIqzJ63NCRrryYOvPheOdEJ8luAVSLhM5zS8Km2JL/8vpILc2XEPbmlMorzczz
	U3UnFFBLqOP6RgZp/uuWc+Ud701MjG3eaVxcORLjAO7TMUTm54b0TOffcBtUq/H5maCQuv
	uW0JjJkg2dzcjPSw1NYFb+j6I2o1Wzo=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4956869750eso3765675e9.2
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787122552; x=1787727352; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hYNBkArvM0Cl5ZB89avtYxazzho2TcwquWjPuU3Io9Y=;
        b=S2qSPev+CYzFVqy15SSfBAqCp8c2P1yt3QcgreypkTgXXsbCR/t/xdR9KzLdKQGISs
         jrredPshrF9NBwUCMjiQKsXZmCRBKs9kiAbfpGLF0E5QtN3j0xguQYFEe2wTva26eJgV
         ENr88yGnUWjjyqV4Ce06xiv8KCgpP0LGyBDF0+t88OV0ckS8xDtEzpaJoKzfOvfuScoP
         3II5h0JFd7eVS7WtvvKO9MGVWASbXRYELD0KT61eCLRqpcS6aUyLDGXaCs6sNmqnTe+w
         X/s72Gs4AGpP5WC6LRjyvU65AYppwpqV/7QVVDSwGo310/OtXhyxgXCTnm6dNC/axmGs
         zi4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787122552; x=1787727352;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hYNBkArvM0Cl5ZB89avtYxazzho2TcwquWjPuU3Io9Y=;
        b=fh5cw9rVW6ROA3a8yqIbsjL9RCIXSsV5PusOq5SY2ea0hS0NILV2eNRQ9AdA+P3SYr
         qbxFY+Gj9lMkE0kIPkVlgRNf5URNu6FwrI4e+3MNdVSw8rqr1+SpAiUUB0l7Eb63kKCT
         hjwE94FMLEmp2hwtul4v5OBA7Egy3YQcBJDOtjY791+qnYC/1cjW3G9XUMQQeVPlEhOh
         nrSynajBAXJYjs3JDeslqjEruX5ObFRuIWzBbI0U77rCHFiFK/rGu55G0WmQi05BhK9D
         ASOs/Ym8XnHMKT/uMNL1egND8AydTGcVOCUmSX9LitZdufbiy8XVF9oApATDCJDMrS7+
         LoRw==
X-Forwarded-Encrypted: i=1; AHgh+Rogv301/r4nGf650TGr4NJBNUR2emgcw+L+IzpGm+BMmhpIAIv59VBtCRHDQ2oQZ+eXBdVREAtWIA==@kvack.org
X-Gm-Message-State: AOJu0YyZiCLYbb0be0HBiy96lB71j/1jQsxQp/GibPSW5kuga8uC7kK0
	LDwioHr1SqxFgCcO1FGCWu36L7SCNfmgZV6OlFiF+rzynUpGjvBjHf4VuiUlbTfVuis=
X-Gm-Gg: AR+sD12mfrN/JqsMIm6BFYDfOlL/cEBuEdrtIx+8I3JhZTZP573TnyLMRfcC88RfMFz
	6k1V/SyBnXVIysfRO/0heCO1JP1OadHk7B8bxl35vJF81J612Ww5YzLWpA0PZgdKmVsjqyxBiF7
	DerwOq1LmspRgtT+RseaN74j2o5WwSYk0q1Iro+IhHDlsL6e2hcb0x3U8kCKtEWjiqKh2n6g+P3
	ViGPAJFBDUg38pEk//lsGD1Y2MRlL1p7Ddq83xZJ4S5nmM9/eo+oY6zx95565hLuegXTC2Cq8me
	xMcVW1LkCSVceUpBrtz/SvJ+Vu0IOjyHZBFpiFk/wgvb+wAwJQgAxIlpAFvp/0rK7mY4m+Ydorj
	MRsHPD/cQmdJtIvkN9ahCGu0+LePEqeDIZMlC4tqFLaNZ6DmSyyX6bSps/Oa+9kGya6L5vbIRnA
	xMpaKYb72l+TpVXGSJTO/3HUsMEO71Orp2qZYnhhdNLDu8KuDTfLRxOztLiJNobJ1qvcnPkZbhr
	AfWEWMnybmL
X-Received: by 2002:a05:600c:4e8e:b0:493:aa0a:45ad with SMTP id 5b1f17b1804b1-499aa17dd15mr37042295e9.2.1787122552092;
        Tue, 18 Aug 2026 23:55:52 -0700 (PDT)
Received: from localhost (109-81-87-166.rct.o2.cz. [109.81.87.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499a9aa1594sm36622845e9.0.2026.08.18.23.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 23:55:51 -0700 (PDT)
Date: Wed, 19 Aug 2026 08:55:50 +0200
From: Michal Hocko <mhocko@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, Lance Yang <lance.yang@linux.dev>,
	david@kernel.org, leon.hwang@linux.dev, linux-mm@kvack.org,
	muchun.song@linux.dev, osalvador@suse.de,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlb: add cond_resched() to __unmap_hugepage_range()
Message-ID: <aoVTdhq3UJKn-7_W@tiehlicka>
References: <20260818115526.654d7311366b66cd031c67e4@linux-foundation.org>
 <20260818221858.86452-1-lance.yang@linux.dev>
 <20260818162430.0a51522ac9bd671cce62650f@linux-foundation.org>
 <aoTuwV76Sd0ahBEC@casper.infradead.org>
 <20260818165938.243ead051f792ee1519a5c79@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818165938.243ead051f792ee1519a5c79@linux-foundation.org>
X-Rspamd-Queue-Id: 5A28F40006
X-Rspam-User: 
X-Stat-Signature: zan394h5iqup65cf6gjtxmq1xwj9pged
X-Rspamd-Server: rspam06
X-HE-Tag: 1787122553-458339
X-HE-Meta: U2FsdGVkX192meoG/G8cEZaLnycofrQ0hcYFpB59UD/RaygwElsG4AXNQlUXPpqbucWc6RwudSXcrIxqotAK2Hab0Ff1WayZtFQhxC2BFZEQQ/oWVJRC1iNc9rFw8GeYD36RXdY0T9j7OlUQnDAUA/xTpOtzjYCPSo32PQ5bppj65upzbOdobtKwO9UATAqXUXKRWW1nQdhXfBwJSx0BoPtJVchTcAkrlCajf7qXv6eCL16MFrPioiqgDCkQtojY3fExwL3zbdOsw9+9eGholNHAoyeZe+ImpCTRWbXnU+y5uTbNF0fQTc5JVKrv3RGUFTOmICQl9+M9fnoZj9N4fdALRD898DXmNjlu/QBotct+kxyiGBUF7OlLEqG8ywpVbM+Oze6FD/9ZWQ7B8ouh8SGDvxzR/NtLNfa+F/VVi21sLsHrn6q/7Lef9q2Ri5idSLxVqKzM5luX6H/gXAkOA9QtddOanWJHOydSN38r7FtLR+E4dKatuxAcldTTCQjLJEAEZnE/ONu74jZueNr7e6b7bB3yaPOH/Kpr5ZXxOKVFp9v9PRhYsx+46Zc1cPHv6cIas3RVB39tpXsTzV9J4lI1F7w/OtRIK3tCFURVIrqMLvfDBYxCowwc6Cfjr2v0LYwaJvZL6QY077qXXCk203mHd+6TXVNCYEmVQBPugWTH63VqvHTTNq2PABYio+NgH26gZBo1DOLta5iEkinWHU071iH3sxPaoSgH+vZhWmPF2uJCI63OwBX35JbcL983VrQTWM6iZ30lrpGuHrysKtH6XFRGUMFKWkzrBVBxmW0x0AsdbmCquQh/UbdP2X1GWwBMSvY4g4zzRM5qJXaq5FAn/En6tod6HU+0+QTF31pKMRnikm6a6/aRgRh7ZJg5FVpddhwHnv3zm/t8JxLiHcWkrcvYN9oM1BYSDqSv51uGKGI9688WNFpSsE+vltxaiirj9glXgVwqPZcBUBd
 XUDFzGE6
 JJhY3ES+kI/sG5LplV43aLUQsQXPCRE3d7RnBKjTy2JcBw3PDgUApcWmNaWbQGeuUsw2/0nSaSCgjixfZzXTn96WrHDrYV6886E5tlJJMYUoPLHiiIjQ7rjD4pNwvxbXbMadVolf8Bb9IVDnHSl8NDJ+NjSMRusUhLk5EuV3GXavUngk25uV8EN0VI0hRtVpUza1AFWay1nfoTKPq/PkWIbBwizfNLal8MWC8hr015+HnqFaseZX8gqBBV/ADgfQBJCBeneZv70/aBpjrlcRSpJZCK6lSBPYipX5yStf9tIFXHIU0jMnn1rcAGlyhq8gmUbU+/7nXU4xoJF6unuPfg1hM6thSjs6FDYK1EwVGlnehCxZ3If4GwxYEErvDamLlvGF9H+IDjnah9SBZrUhMmE5LluNV6YoMDCn5AxNsw8Wekgv15Hj2pXgSyT6NMRESBK0VQ3gqJlKb+6k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 18-08-26 16:59:38, Andrew Morton wrote:
> On Wed, 19 Aug 2026 00:46:09 +0100 Matthew Wilcox <willy@infradead.org> wrote:
> 
> > On Tue, Aug 18, 2026 at 04:24:30PM -0700, Andrew Morton wrote:
> > > On Wed, 19 Aug 2026 06:18:58 +0800 Lance Yang <lance.yang@linux.dev> wrote:
> > > 
> > > > >> > 
> > > > >> > That's pretty bad behavior and we might want to fix it in earlier
> > > > >> > kernels.  Is PREEMPT_NONE effectively dead in 6.18.x and its
> > > > >> > existing users?
> > > > >> > 
> > > > >> > If yes, we do want to fix older kernels then we should merge this.
> > > > >> > 
> > > > >> 
> > > > >> Okay, but that would be stable-only fixes?
> > > > >
> > > > >Not understanding.
> > > > >
> > > > >Maybe you refer to adding a patch to -stable but not to -linus?  That's
> > > > >against the -stable rules
> > > > >(Documentation/process/stable-kernel-rules.rst).
> > > > 
> > > > Since cond_resched() is a scheduling no-op under LAZY/FULL anyway (only
> > > > the __might_resched() debug check remains), why not take this upstream
> > > > with Cc: stable?
> > > 
> > > I think so - as long as PREEPMT_NONE exists we should support it as
> > > well as we can.  If the day comes that PREEMPT_NONE is removed, then we
> > > get to remove lots of cond_resched()s.  mm/ has 200 of the things.
> > > 
> > > > Mainline scheduling stays unchanged, and stable can pick it up for old
> > > > PREEMPT_NONE kernels. wdyt?
> > > 
> > > Addressing this issue in older kernels is another reason.
> > 
> > That is not the direction that the scheduler developers wish us to take.
> 
> Well back luck.
> 
> "Packet receive timeouts were traced to sparse HugeTLB unmapping in
> production".  Do sched developers have a proposal to fix that in
> year-old kernels?

Yes, do not use PREEMPT_NONE in anything that is latency sensitive.
It makes very little sense to add more cond_resched, just to be
removed later.
-- 
Michal Hocko
SUSE Labs

