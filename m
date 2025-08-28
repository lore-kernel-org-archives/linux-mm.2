Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04A0DCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 08:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B0038E0010; Thu, 28 Aug 2025 04:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 160AC8E0006; Thu, 28 Aug 2025 04:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027D98E0010; Thu, 28 Aug 2025 04:36:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E10188E0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:36:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1CC9D13A567
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:36:24 +0000 (UTC)
X-FDA: 83825509488.14.5F9641C
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1502B180007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:36:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fYQTQdra;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756370182; a=rsa-sha256;
	cv=none;
	b=ZlUEXTUMxskjkNZsnaP48xfyDM0l+bzL6rOx7wxNpf5KPL7jZNA7pVhKj8LLYTrBvK/6VA
	xDq6l+FdE+KLm0IG3EVzq0MP8aphFgD8ZYq82Q/I2PXIj1G/JMQvoBWNywYcH2uijKtp/f
	PuqEjOJe3/cwVQCompf9devXhLhHVZs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fYQTQdra;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756370182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0JaUseZ6CWu1EJ1U3qBAV9Lj7Z4bwfj9ev3APaGuRbI=;
	b=WvMNT9F12HE8zn0ABVz71kdFaPCRZCA5K3AM1Mq72RY5i9v1pH/fsfw0aIpYGtyadZP/E+
	U57RpHpj9e/5Tuje5228IAKtup8f3iPV2Xjike4JkEHLEjOASZ/wATIbLUbFUmamGBp3sD
	mQNACxWNsnQKitWXVtIa5aunEG6p1EA=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3ce4ed7a73fso161497f8f.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756370180; x=1756974980; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0JaUseZ6CWu1EJ1U3qBAV9Lj7Z4bwfj9ev3APaGuRbI=;
        b=fYQTQdratLT9hA+EjIlAqg+VjUZmQsgPlqbKNLU0dawXDrKg2N6auP3JQ9/SlgPajJ
         Oip8GHajYjTsdtPKn5fDm/+oMyMjeZu32V78GfVqnHZ3kCMv4f0Xm3UI293LX1ZFq31L
         U2yie7vALIaKAMyGr4GWiARK+A8vgIhsE5XW6LZeJg0rnXZ7rTqMD74438PcvHvhGGT7
         TSYUryr9WZhT5Ii+k67TvtN1AuABFmF0UgxA1eQOO49VxXqhPjaMJYG0PbnY09n+wvcd
         oPvPUTNssrqLMik26QbluNKS7Lk9G2N6WlR4d6HUC+O1cX8TiuRc/ZH5r9+PsCQx+3rR
         WH9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756370180; x=1756974980;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0JaUseZ6CWu1EJ1U3qBAV9Lj7Z4bwfj9ev3APaGuRbI=;
        b=GQdmddkxSr4h08LlKxWN63cbiE6JbTpIoau06xx4hUp2bLCpNi86ErZfHKENHxqXOb
         e4+HwZ2CqY/rJZ0aPWLsDqLply94qwmt4jvx8UVA5DkbqPcSV7DG0gRI/pR4DEBsu72O
         Nrs7wlbYqgZQTmAkEtA5ryeouTgdQrJF7UgxX1nLloUNc3wGpeinC37xCs0WCvDzp+PC
         mH4PZsq8yUF7BzhmDyND6dCgiVu9zds5+T26Whr7PE1rRV4uow2m7MGpSU5Mlrpo1Nok
         8Dm9HfpPwpFkvMWFAXlSYyTJnPMIOe9+TrHFyBMY7Oy2dTqnZAXfnzMTbIpAXbwekitc
         LCgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZJdlnszOzPa53ePf/wHhNvZzZZOgUvFhFRnEgpMoY9UAmceFmuRfiNunW7gH9edLRj8t+bofZlw==@kvack.org
X-Gm-Message-State: AOJu0Yxja5kVkFhlbq717h/LNweoBU62mULIk+Cc8XrGV5EElpub2tKj
	iK+FQRos2Aa60GeNXgq8RlzQucmE/HnFg6ntSnZZXBOgarUZTABXq9Kb
X-Gm-Gg: ASbGncs/LSQ30llTlpXXWP6hjW5ZIT+tAmOp+U8e2giNEfyykx3ss8uqGjEKXSEYF8Z
	nEd1OKH8Bi11+3TshzeYub3bchh0D8O7bDcqlelD47JmpfvYFCfKnTgC150x2bXVBQhblOf79VA
	6YDFk49qwlgC5MXhR/04YCgxBpBiEiX076+bwSYE3TCK79hOhWPh2VMiC9hDMDuoNbC9+uFYPaY
	lsrhhk0+dwgkpbNPXw+BPia5XzL7qNT6umkvxs+ZWyWaTZ+jmTTb85Rdq1QC9Bfi62fJCA3TovF
	IcTCUF74ixDmB62DMKj+/UbXXsaTeA1NOpVnoUDYTJLpCls10LvHknSrlPgZySKHzSRBfjOPfkS
	wLUfB6KRBEwE12YhnHaAAvdCLr05a1QruSYGRoGHJeqK5qaCkBA==
X-Google-Smtp-Source: AGHT+IEnj8J0hKFzOYm2Zneg64WLFXqCWW8vLEJTC0ZvD0mC2gMD3pC9v85qzqJuH1pUr23Byo29aw==
X-Received: by 2002:a5d:5f55:0:b0:3c8:2667:4e3c with SMTP id ffacd0b85a97d-3c8266757d8mr13284619f8f.44.1756370180366;
        Thu, 28 Aug 2025 01:36:20 -0700 (PDT)
Received: from devbig569.cln6.facebook.com ([2a03:2880:31ff:58::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70e4ba44fsm23655189f8f.5.2025.08.28.01.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 01:36:19 -0700 (PDT)
Date: Thu, 28 Aug 2025 01:36:17 -0700
From: Yueyang Pan <pyyjason@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org,
	kernel-team@meta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] mm/show_mem: Add trylock while printing alloc info
Message-ID: <aLAVAZMKwYueL+5I@devbig569.cln6.facebook.com>
References: <cover.1756318426.git.pyyjason@gmail.com>
 <7e2bc96faab1a338829e549246189ad96e6c866b.1756318426.git.pyyjason@gmail.com>
 <20250827150619.4e468e68988f224f9f9bea6f@linux-foundation.org>
 <aouiudhvbuwegvkdqwtkp7bk6gvrsxkqe7us5uj6ylg3pivjin@nl4ri6fbh2zd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aouiudhvbuwegvkdqwtkp7bk6gvrsxkqe7us5uj6ylg3pivjin@nl4ri6fbh2zd>
X-Rspamd-Queue-Id: 1502B180007
X-Stat-Signature: gn1fd4wdhuyxnmr3sdf5edizk8hzr4rb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756370181-879230
X-HE-Meta: U2FsdGVkX19rTVf1cbf80Ghv/DP52ZkWjDE675EeEbk15mNH8722gKJD+ZGRWSWVbZPDivOwnR3aj0F7YZZB7xm93b2Fq+Dd1K2tl46r2TW+WShrGLloTBjpUFUiC1EbQ0TcmZ7aAENqpUTPVufJJ5lQCM7lYd9gFZU3rkhq5rMvl9pChHiwC+GTXUyLY3GNSp7pckvOX4em0kBnFh0NJIr7NbrQMlI6rAZPoIrtIs9LV1QzJmtvpGunSHgtUzygs4G40sIBB1vhSjXiZ8Meo6SXhejF4uRNsl1RcjMAKeweaClC9QtL/KQXNJty/zO87sz7w4gvOm6uSduV0zgB1f9BCk1omO4zSBdBEaGQBIOPjZSN4eH/3hr2/4i8KTk+QnpkbNqZyfna3XmycGKBG3oPq3wz5uJeDBZ6ZrPNAE95xYf/G0vrdMYtIeJI0OeC0yxhKcdivJw3tqIugW8UQtStMBN++wrzQcBB5w4ApHrpx+E4E9NVIlVZaCg2ngntMl2j1l/hhv8wG+420USGBcIuoqj9JR5uYOv6gmHHPArWQnFRLzgKRMy/CpZgmL48FeADzXjP3V4w7pqmW0nqkursYuaF97M8f3LLz3Otj/RpDiWEe0RoR7I+gGy2gdiGu+p55OjYBayNKivwAx1y3p8cSSd/5veofYHYGcBoi0/AtHCJCTcbs0pInw/h/f53zgv4gccJIs7nl8SScpJHYyfo+hwBI1+ypoKvgeahL4TfxoNcCzl9vjzyYxV/g2Gkxlk98iC+KCeKZv9x1hECFNOKNH0NiWdFOOQaEyTsfftswuabLINUMyH2wAKpaghWG6MyC4JIsgxQLLG86XVzUkRArdMJhcafQ66XyDmH2oNKbnJDmfEeTqsZA81/N7lu+wS0ByrCHDD9vsRRnX2evht2FNkCIgXXqtXtCs2usuZ8fOF52wXdLKZH6KHCZKOwjwJLSP1dxOCZ+1k1d3t
 ubCYM8Qi
 yhqlDtEvwlHDqpxNHCHFJi+UYeHzZsMv2nOEmwNse4j4Lc7hWeO8Egghw52fZn1p8N0MDyrR+9XGzDlg43+VIA1nuix7HKGS+hT0eDPrCevhWfUr+QTCBlFi1Ohg7wOJcd7qjBR3FSPpJ+k4BO8AEBwNNnoN34q+E1d8Q/x2K8RM/uugXOxU6UhEYewKzrugcu4MDmgq4lnzaO61d9NvXqnoiGnKt6tJYWpTn7z/8KHrSMZwMMN4B5b/MHJwlNat1pEq8f1reZX6mRDeKXLrCBsG1Dgf4/WOXEMduZuvG0Gfkpg0/nDAuGVMijQz60LqeFATCkoRT/ctCYjmGK1d9vQsI/AaBdVpOV98N0D+zm+GZuvn2PP9Bng2ypDm/JAfTPU5/9ZaTPuKQgNsNyhhZgumH1D5lDAEjjsaeMWJDxzL3MVTvzR+cZNNv4ekQOSxaHagCOtZZV3xYWurf5fCYidBERiQLlLsUnE6xqRlK2/Oo6ijS62GyWhnlgA3QBusnDrEe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 03:28:41PM -0700, Shakeel Butt wrote:
> On Wed, Aug 27, 2025 at 03:06:19PM -0700, Andrew Morton wrote:
> > On Wed, 27 Aug 2025 11:34:23 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:
> > 
> > > In production, show_mem() can be called concurrently from two
> > > different entities, for example one from oom_kill_process()
> > > another from __alloc_pages_slowpath from another kthread. This
> > > patch adds a mutex and invokes trylock before printing out the
> > > kernel alloc info in show_mem(). This way two alloc info won't
> > > interleave with each other, which then makes parsing easier.
> > > 
> > 
> > Fair enough, I guess.
> > 
> > > --- a/mm/show_mem.c
> > > +++ b/mm/show_mem.c
> > > @@ -23,6 +23,8 @@ EXPORT_SYMBOL(_totalram_pages);
> > >  unsigned long totalreserve_pages __read_mostly;
> > >  unsigned long totalcma_pages __read_mostly;
> > >  
> > > +static DEFINE_MUTEX(mem_alloc_profiling_mutex);
> > 
> > It would be a bit neater to make this local to __show_mem() - it didn't
> > need file scope.
> 
> +1, something static to __show_mem().

Thanks for your feedback, Shakeel. See my reply to Andrew for this.

> 
> > 
> > Also, mutex_unlock() isn't to be used from interrupt context, so
> > problem.
> > 
> > Something like atomic cmpxchg or test_and_set_bit could be used and
> > wouldn't involve mutex_unlock()'s wakeup logic, which isn't needed
> > here.
> 
> +1

Again, see my reply to Andrew.

> 
> > 
> > >  static inline void show_node(struct zone *zone)
> > >  {
> > >  	if (IS_ENABLED(CONFIG_NUMA))
> > > @@ -419,7 +421,7 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
> > >  	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
> > >  #endif
> > >  #ifdef CONFIG_MEM_ALLOC_PROFILING
> > > -	if (mem_alloc_profiling_enabled()) {
> > > +	if (mem_alloc_profiling_enabled() && mutex_trylock(&mem_alloc_profiling_mutex)) {
> > >  		struct codetag_bytes tags[10];
> > >  		size_t i, nr;
> > >  
> > > @@ -445,6 +447,7 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
> > >  						  ct->lineno, ct->function);
> > >  			}
> > >  		}
> > > +		mutex_unlock(&mem_alloc_profiling_mutex);
> > >  	}
> > 
> > If we're going to suppress the usual output then how about we let
> > people know this happened, rather than silently dropping it?
> > 
> > pr_notice("memory allocation output suppressed due to show_mem() contention\n")
> > 
> > or something like that?
> 
> Personally I think this is not needed as this patch is suppressing only
> the memory allocation profiling output which is global, will be same
> for all the consumers and context does not matter. All consumers will
> get the memory allocation profiling data eventually.

For this point, I sort of agree with you. Wait for others' opinions?

Thanks
Pan

