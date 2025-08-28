Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 275E4CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 08:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 747D08E0017; Thu, 28 Aug 2025 04:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F8308E0016; Thu, 28 Aug 2025 04:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E7108E0017; Thu, 28 Aug 2025 04:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD2F8E0016
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:47:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D898140A7B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:47:53 +0000 (UTC)
X-FDA: 83825538426.03.8941E6B
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2718C180009
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:47:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kEe3C261;
	spf=pass (imf24.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756370871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Hsk9DOGTHIa16VTkxnpvVMx5QHHrFZueYddM6GSS74=;
	b=c/M3Q6+Y0V1Lc9w+zHffthd85FnY3CtE3cEf54kQgnhLs3Msogrq7gwsTqqZW9Hg1v8FuE
	nh/sx/lm8C1GXMqFYBrXVL3Gw2ToBR4Qlh+BKXkkK1Oar9YGcreqCWRQWkGrytA8P3P6rX
	tDJnxUVKKnPWAvkZ90bKNvNOCDphIqI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kEe3C261;
	spf=pass (imf24.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756370871; a=rsa-sha256;
	cv=none;
	b=MQIO8FupgV203M4cjYVgzmQCphc/vZmXxV2j7MYTbZxUlUv51VacJYFtOqhWNlsFBtWVmd
	Y4It/662RtEJWFqnpRc7ueO7QoDfNs+BsC6i9zy2Mxgsw5As/7Dd3rgJNhxDzA/53oOer3
	7Oc3r1gnhfCY51lRr3VE4MbYwgVWn9c=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45a1b00f23eso4010695e9.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756370870; x=1756975670; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Hsk9DOGTHIa16VTkxnpvVMx5QHHrFZueYddM6GSS74=;
        b=kEe3C261vVULCxyJps/b5AOxV/+eu8PPnBZ+Fdxpqqg4roO5BCG/U0+oSf1sTjmlyw
         gR6EX/vojc4HG9SFBLWMeew0eXJoHLFJzws3VRK1oSRmQF+7WIbKTTk1wc8fekUWZK+0
         IDFxwEWSJ9KVzB7UmXSjcOcgvYSaLh0tMwgHzrwUVSv6iRMAQ5MzwJtGsN/iM65b7c3L
         ecSbm3j74aZpr8++X4X4fjrIPv9bQAMjdvRcX/CUmbjcd574/x8mTz83SZfkt3w/EybP
         7P3EaeSC4fqbsm7tDtaZZP0Z+Gz+VM0QIWFHlkCJ6Sf00GNEu2MiqrPPyFV2jhJU4Vc3
         Nr1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756370870; x=1756975670;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Hsk9DOGTHIa16VTkxnpvVMx5QHHrFZueYddM6GSS74=;
        b=QZYmggm3C3Q1K7s/zo8o2YXaaMuBjURsmB6ocl1cVDGitNbRoZmxQISllOjBKGVJ4O
         Kks9JjA80ugtISK8KCu+gd4Tl4vFeSyqwcVAS5krjpJX+0mKtE7UJURwGruGZ+XgL5Gl
         5z+k9YQbs4YLBjB79sOo+nHq3UMBGZ6GE0xY27aOUsMiCb+SLE/lJffRi1r4Z8wyilxq
         Rt5jFUkrnjIG86hwQHICI6goTRtVIoxM88nXMnwjKAo8MAAdBCvU5o/jKCU3DMRy24wL
         w47vbeNv3onwLlCXkL68Btj8tOUCeMh6OK3XDINDR8HbjntKmhB3DZ0RzBg5G9k/+3sn
         31VA==
X-Forwarded-Encrypted: i=1; AJvYcCX84zT59zvtJD/D0umv4vUpEOuQJlHNTkzaNmNKmHoaWWRXtOoqVUnv9YkVAMMAxCS0JRxqZsfQrQ==@kvack.org
X-Gm-Message-State: AOJu0YyKoQV9P+Ueoc7o0hNAPN5qohGHitCybbcfkL/RfnjFcNmI1jd0
	auFBmGIK4L5Ha07Rs25vIwPbhiU3qQ683sLb+4XFTWFM0VvLF+7kRiq6
X-Gm-Gg: ASbGncvw6B8qgwLXuslLAoUVOVG0T+3o7l3KWVTNWpw0X+3JbIYO+WT7Lm1XmEAR8S1
	Ts7DzMGQIh3ciACDChrSiaikwHO4t2A2OZARNqavOO3s7w4DGNGNQ5un4Kp4gm5xZOOPaEQSx1P
	hGIzCYPIgiP8ShIJlUyH+TbSM3z6n8iBFjckr922q2/l0vmGsO0Ck+S+GketYYuzFeRKSyc+iOx
	qRS9Pz1SjKPJC4SHtKrNWrQH4JAb1zw3aPiV/aPe8a2FYRQvUUk5xhURcVKPNH76iDsft484Nj7
	+Dz5yPr8oguq9+laG6SICS8bH8cZelohHQxu4WbJtE6Ww+tmZvqlYb2PhNndIJHIlFIUAAn20w0
	UeeDDx6FeqOtfNzf/Ni8nDFWAXmpIrrY7XSHegls=
X-Google-Smtp-Source: AGHT+IFO8pLgjWSH39ZyRRQGsELfg8fZ4fAArTXSmMVZY3KOq7DLC8ULZtj3zAJ1AzMGuiKNKnJXcw==
X-Received: by 2002:a05:600c:5490:b0:45b:4a98:91cf with SMTP id 5b1f17b1804b1-45b5179cfe3mr193278165e9.15.1756370869196;
        Thu, 28 Aug 2025 01:47:49 -0700 (PDT)
Received: from devbig569.cln6.facebook.com ([2a03:2880:31ff:74::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cbc6a5da6dsm9463817f8f.63.2025.08.28.01.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 01:47:48 -0700 (PDT)
Date: Thu, 28 Aug 2025 01:47:46 -0700
From: Yueyang Pan <pyyjason@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org,
	kernel-team@meta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] mm/show_mem: Add trylock while printing alloc info
Message-ID: <aLAXsptN4cw05IoZ@devbig569.cln6.facebook.com>
References: <cover.1756318426.git.pyyjason@gmail.com>
 <7e2bc96faab1a338829e549246189ad96e6c866b.1756318426.git.pyyjason@gmail.com>
 <20250827150619.4e468e68988f224f9f9bea6f@linux-foundation.org>
 <aLAUhXeRVWzLCNNd@devbig569.cln6.facebook.com>
 <c8db3486-4f13-4922-a270-1fbf61e2d782@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8db3486-4f13-4922-a270-1fbf61e2d782@suse.cz>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2718C180009
X-Stat-Signature: md8yq3rig4g87qe899r15cqoj5yycr9m
X-Rspam-User: 
X-HE-Tag: 1756370870-128884
X-HE-Meta: U2FsdGVkX19cN2pVsHu7tKGhFn3e8SJ9HhL3BXkF3ytp4GqeucnSo/Xz4W2xN0RU6ipnyYDqGkqeQ40gf2j2b29+ZCm9DcWHsetkxoTvPXWrcvnI8meN1vCyVM/YK0+g3AjuE9MMbkrNgLgNVYVd1pKxPIOGHBJE0f3LAZcERi/tvF/VQ9uMvDgfLt0Zk8f71BMo4nrDcD0afhIfJzswMOO3B8CGC3cb2Qy2gdAEambjG7Uw3GYtxB4usMeWJNo9dAbNTGeBwBfgjHdjEBU7CteuG3L1QDPxIRPGyPiiRCd1CjxOdjM9DFy30lc/TXMoGoEDhVZxZ7aXH87Gv2AG1PgS2ucjheoeSuv9n8mIM5NvWk7FAzBMW+5QaNgG1yr9iE7aBnuawQLxJHTl+P8WOtmlNk52h1tIAevSXLPFJILbU4ERh30PuFZfr69Sh4RyvIIC8pcniyFRJOH3NWLs7Ae69M8lTXPY9X5HuVVwQm6QtYAbtRRcOAtXy5ukv2QV1Byb6sze3iT6Ygprz7pPwE8ZayYO2p1xoyvzDdBaMkfIRdNoTYXPDNZ4N/5jnAQ9lmohJ0ZDw9B92jB5li33qWZY6xvGp2ysul5FyqoWTv6DckNjv/IKhsfbM6j8M/7eu3fn/0cOfaD1vQbj0oDgHQiVBKRfidU5zQSq//N1gKU7jex2SMxsKi+mSgxooEfxBBleSJKFh6tGErhb5rEGz0XVbFinaHFhOJ4+hSn+6UmJJwOaSysBfch1Bswt4PJF6agmQphTYHDF8tfbFD6N7ioNkssIFTVuLeltSuD4u0COxwiyLbePEj7U86+NTIK5PkU9whqThwdogKbbok1nYEKUPT5fSr4qU2JCRhCHv4oKd/7znleGvbdpqX2BrtpJ6jOTPPyu1Fy30FiIXLBwnUu/dRCGuqLb8PLMa+oOA56kZsFNvmbZizLWlVKZQ9r3QZZsbZmwL4d/KvJi0oH
 I/wXln5W
 BIi5No/1g3mZ+YmKnVNaYghim+xgmtqQqmlMjQkcdSfzJ2iKzZkwZiPfLK2AOpcMBtJdLPEwgfPyXbY0flCjtsi15Z37TyJEAkGd26hjyGDpIVoASzTXyxB7OzShcHgCEDGCva0aWoyu8+8Rllhppah2fr+MVsY9VflLlKZGVQOC2EIaYHf2y/59bfQFtDaucqmxU2GSMFG3wee20fouQI03GULLherEze9QtbHMrJfEurW7xNIGIllEI12mCljW3dGthx+qqGZtYFn6ajGS1VDQEW26MlGuCRYXafnydsfjLydkU7Q/UyYcgiGyQFVvUzeR29BiOXB2i+UlP8DZBkAGFSUw5MhgQILlf13vNOXj/AAjqax08q/g1PBk0hgvWkxLE+dQrWz6LBldN8CaYGxbdpDGVwxwHvO+pzRJodoBNrC3zP5moE8XLRNQGfs48ymu2Bt5FQOOhG/RVsybdjKLEAsiWBvBgPZfn3LJD0X1RmSxZr5k4VARTbx09ezm8Hi6N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 10:41:23AM +0200, Vlastimil Babka wrote:
> On 8/28/25 10:34, Yueyang Pan wrote:
> > On Wed, Aug 27, 2025 at 03:06:19PM -0700, Andrew Morton wrote:
> >> On Wed, 27 Aug 2025 11:34:23 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:
> >> 
> >> > In production, show_mem() can be called concurrently from two
> >> > different entities, for example one from oom_kill_process()
> >> > another from __alloc_pages_slowpath from another kthread. This
> >> > patch adds a mutex and invokes trylock before printing out the
> >> > kernel alloc info in show_mem(). This way two alloc info won't
> >> > interleave with each other, which then makes parsing easier.
> 
> What about the rest of the information printed by show_mem() being interleaved?

Thanks for your feedback, Vlastimil. We cannot use trylock for the rest 
part as node filter can be different.
Do you think we need a lock to prevent the whole show_mem() from being 
interleaved and to acquire it at the very beginning? Will it be too 
heavy?

> 
> >> > 
> >> 
> >> Fair enough, I guess.
> >> 
> >> > --- a/mm/show_mem.c
> >> > +++ b/mm/show_mem.c
> >> > @@ -23,6 +23,8 @@ EXPORT_SYMBOL(_totalram_pages);
> >> >  unsigned long totalreserve_pages __read_mostly;
> >> >  unsigned long totalcma_pages __read_mostly;
> >> >  
> >> > +static DEFINE_MUTEX(mem_alloc_profiling_mutex);
> >> 
> >> It would be a bit neater to make this local to __show_mem() - it didn't
> >> need file scope.
> > 
> > Thanks for your feedback, Andrew. I will move it the next version.
> > 
> >> 
> >> Also, mutex_unlock() isn't to be used from interrupt context, so
> >> problem.
> >> 
> >> Something like atomic cmpxchg or test_and_set_bit could be used and
> >> wouldn't involve mutex_unlock()'s wakeup logic, which isn't needed
> >> here.
> > 
> > I was not aware of interrupt context before. I will change to test-and-set 
> > lock in the next version.
> 
> Perhaps simply spinlock_t with spin_trylock()?
> 

Agreed.

Thanks
Pan

