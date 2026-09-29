Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BCA2CA5FB1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 10:27:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 189F96B0096; Tue, 29 Sep 2026 06:27:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1611A6B0098; Tue, 29 Sep 2026 06:27:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09ED46B0099; Tue, 29 Sep 2026 06:27:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFB446B0096
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:27:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 458181C30EA
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:27:34 +0000 (UTC)
X-FDA: 85266423228.14.1F48359
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 794F2A000A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:27:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ANSMJgtv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of smostafa@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790677652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f5Y1Bj47kFdGtgtMUGRUSsPhxIRB2mIpZUPvY4e79ZM=;
	b=zMcznn2bw4wX5z3ptXA+6GGybv8XRBmg1z+kl87FAE5MZ1fI132thyUSD8KJ1z3GAD/C0E
	ojyXnLd2WgdHfJ4o4V0Cq1GjMGJck+jRFGWo8ovZCDVeCBZAr0qWk471JYW5fC67ofb8TN
	+0WO+tD5kYUZOw2A2s74mIl9LurHSUg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ANSMJgtv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of smostafa@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790677652;
	b=VbkyGeJcuvy2ShFbLbd6LvTUGAdc3Y2o7ebgK/hzmZH59n2ReTpkNLQU1+6JuOR0r/DiXs
	VzE+5np8zw7oNDJEk6vfClpzbRZIze1qyslN06j0jC0zJUoncA/PNhrn/wrvTy9VUf8BIi
	gXWuDA3vPmlUFsBtJz0Sd9kEPzZGfMw=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a0061bf0d3so33495e9.1
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790677651; x=1791282451; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f5Y1Bj47kFdGtgtMUGRUSsPhxIRB2mIpZUPvY4e79ZM=;
        b=ANSMJgtvihsr3lZ736V17mlv3mzVT5OEH2JyaINPo8Rdy/HEdDAEyU4ojDAT1VQjoF
         WYwDJBPA7EMd9NI8NVCNBSSVw7LQnq/prqOtQvHeeT82QhvQsuGrjrtHk7CuDsDdvn7X
         36C85yo1/wKYRFPo721s3kgf15TdrcOoJGcP8qz57U6DUnzPuZmPJvzyjnx1Atg3RZfA
         uwR1CoZb6loyxFo9/rMNDJI3n5ojVGGIB/i3s6WksFxmLxtVtgSoRxYL59pEW6H8b+9T
         rRYLUHIOiturmD7C+yBPk/7gSaYR1lguXsdPk9ayOZwUScE9tzjMU6UOQBqChMzXiIuZ
         EZ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790677651; x=1791282451;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f5Y1Bj47kFdGtgtMUGRUSsPhxIRB2mIpZUPvY4e79ZM=;
        b=ODtdDS9UVWJwuJR4Ftzf36KF+7dGnzje4hsF5FSQCuzmm3NTvOVz04sEvMJJcY9OFc
         9v/lPsk+hBLwic5pVPbpr/PBifb3gqKW1bLOOxISZGrw0AAxhvog9guHD/0e1aLez4Ac
         6gppaiWJ+dE/UGa0I4iPIQd2W2p0Q9mkbhS5+7aVcNdA4phVqEgiBZXRsjo7vLjHhreO
         WJ+GLiIk/qSrPsuRAHMB4GUYCkN4F8JE7GMK01Z+4qeXc39fwbhhupTh9o/5HnjVadoK
         KlkLtAL2d21H2oKyxf64+RPVZQ4Isxgu5Ag426vU+0Pzs0dEn1YtlqJvxxqqZ1V0ODCL
         jygw==
X-Forwarded-Encrypted: i=1; AKwUvBzAzz5teGUcydMhdrUjSAQ1oSyzbWOdgdlO3lJUIA0tNWT3I/D86rubrhiGE/KKvWaodjEdXVSzjg==@kvack.org
X-Gm-Message-State: AFuF++mCXHuklSoufSqXel9kHrVhkoq73QTbVfNf+mbfxplz7GIn3fOX
	0/4UgFzYgt/0t9Qlgz313g5naM7cH7Tul5sgykGaELZ4MuedDaSQMIn6ge/xN/s6IA==
X-Gm-Gg: AYBFou2uBTMqIzSBx8DPXGT6kfiB+La6uyGZfKgy7W1EqWDGzugmUoImR6202p1ZLkH
	gRvh3NTQQh049OLlJ/ie0DepZllWcBA/0/rXBaqOn5FAmcdT+OjyPiimnh9r8LrM9QZUWJjSHzP
	jU0OHhKfd7uPvpzDc1b4K34a7Au3UDRuyyz4XxCR/0aJmeakPHaVCCbE3r2Run1MRsvpkQX5QtO
	eQ4722wwSu2IOze679SmkrmKTCxvV9PWLuQKd5n0x7v19hcBBjU5YlGx8IvPrOIyfdiyqEHHVzq
	RFRytZ3tSaHeherdgNobCYDoQvKXRlVp+dvBbT6tlVbTqEAkf/rblu0PG1u8duxHXyWSCT+tecY
	q09+WTp81+X55cjd1hMDG+fR9DMkxXCuECxBsv6Yjvx1y4ARISdK94gsU5jSZOC2q1GLqAWbcCk
	+TMVjllmUoGY2qQtT0e2Xr6hjFI8z5B+4eGXkX8HWGAoMv1kqea+aE1MSr09e2a5BzrExFAnHuZ
	eeuUKGYy843XksFa6IvaRpEMyBVTez1JeAIbs3u
X-Received: by 2002:a7b:c7d0:0:b0:49f:e312:54ea with SMTP id 5b1f17b1804b1-4a00f46d761mr379975e9.12.1790677650115;
        Tue, 29 Sep 2026 03:27:30 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00c10c656sm103565205e9.2.2026.09.29.03.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 03:27:29 -0700 (PDT)
Date: Tue, 29 Sep 2026 10:27:19 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	corbet@lwn.net, skhan@linuxfoundation.org, catalin.marinas@arm.com,
	will@kernel.org, mark.rutland@arm.com, akpm@linux-foundation.org,
	urezki@gmail.com, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
	kees@kernel.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, gustavoars@kernel.org,
	bigeasy@linutronix.de, clrkwllms@kernel.org
Subject: Re: [RFC PATCH 12/15] sched/task_stack: Introduce
 ARCH_HAS_VARIABLE_STACK_SIZE
Message-ID: <aruShxHCUWEHr4i1@google.com>
References: <20260928174122.3380703-1-smostafa@google.com>
 <20260928174122.3380703-13-smostafa@google.com>
 <5c6edcfe-8332-4db6-b0fa-ca5d137a2075@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c6edcfe-8332-4db6-b0fa-ca5d137a2075@infradead.org>
X-Rspamd-Queue-Id: 794F2A000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: m4gtwrtgks4wr1k5od68c9hz8qn4cqjy
X-HE-Tag: 1790677652-596656
X-HE-Meta: U2FsdGVkX18RyNVsvdnkQE91vCRZHdfAt6jW7OH3ABUOgWio2FBXMtEPCa1vbuS7cVskNoT+5kFhL1KcZPd9spunf5Fqx/bm0ToV39rpYRsP2LYhq6bHvvrvDLpKMK/TVDjeLmrrKbqr2GveyFdaszBPyHdWqqsAeVgQ/MDP68oIlgAhlme20ePYJuKt5VzKp5Q/e7hPIHqSHH6F7bjURyicJ7UfiI9SfG5r3m5J5OXF3YNcG/bm8zC9x3E0MCAj0WTiSy9WU0+jVvCmAOqLCmKbt2mM6FgdEdtd2PjvwHysRVPolWdCBOqqGSn8f+GL8fMfWtMQ32EBhQqfH0D4CgDdotpvghVvJHQJ4/f9hu6V5pKhIVZhhRwhMDuYqwfnuMc3lxo18ImLPfNdo7p/VpLHWSFw+pCC3QaUg4G78ngkNdn/HWO8yaV3X+X2/46nop6YrQ+zJop21o5GJU9LDolmBqe5N+HsDnGcM5S8XDT0a9u/t4aZoGl2gIvQBvGEZDKStIBAbqNeUbEMDV/4MGl2uvgkey3L+3D8pObG8RRYqyBogAVByA+M/uA1tHTpHpIrjMvbxtHdDqvZObktwKFA+vUHuDgcdIFye5XWMS98wqORtjYRwpAPEQjAIOM4hH6N0ctGTYaBGa9crI2t+/o7jGKXXNv/7xR0+UvFvEMmGuN5KKHth5rIKglxCPBrEtlUsroAnUTSX6k7EE7h8c1yuoeGg5gB/xxtrRuvmCwsu08BT0I3avEnos9xKFuQgOP4At9KkZxce82ZOthsUy3JkZIXo0qbZLsGph/C8FPhG9HqXR3h8t7hdBQn1S1ymOyVSBSFbr8RD550CXttdE8wduzNKkKF5oy+FQ38iaQtvTQE9Sb18HeSVc6TNoUVbW2qcisTKR/UsthCMTAxWvEVkkfUYj6vn9H5a9SKMdIpEt0oL8lvK42GCixPgOaxiKy/bpdWTRUFh9qjG4q
 3lOUH47D
 KxXO6tkZUCMmcCS0YZhnbv3S140NMZUb1hpvZVr9TqN9nRH1CkwwU9+EBNb/nS5drroal39Jigdn0RbPsM+mZOCbrhN/znVwMxFPN7K4EKN9oqctZ8z8++bwhLvKQVFHuF/GLLXQdBVmMeAC+qc2tRTqV09zd9eh+jY3kjwR5scwiqOCPBKkFrFo5nz6LlYUNrZTd7MZEU3GRam0I8pygBlW5qEXyA9wkOF9a+DkZ9O+LwuG/EOWfeBD8uKg7kNZiDZJ58NTwIwwss46aihHYvI7cNkvZrC1BNMr96oxNwcvuwSvgFrE8IMGp5uyxknkwSOBJtlAIdm3hm74Xm7r5Ju5kCr7QNkSavBYImje0fBWTG4EYMeswkAdsbaH1RFBB1LSLUHfhHO/ZlYDhSwj/uZJFvBw2zWYKIr7N85t0b3Lm90BptWvH96N5/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 01:37:37PM -0700, Randy Dunlap wrote:
> 
> 
> On 9/28/26 10:41 AM, Mostafa Saleh wrote:
> > When CONFIG_ARCH_HAS_VARIABLE_STACK_SIZE is enabled, the kernel stack
> > may not be fully populated with the THREAD_SIZE virtual area.
> > 
> > Teach task_stack_size() to return the size of the vm area and not a
> > fixed size.
> > 
> > This propagates to end_of_stack() which makes functions like
> > stack_not_used() and set_task_stack_end_magic() to use the lowest
> > valid stack address instead of THREAD_SIZE which would cause data
> > aborts.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  arch/Kconfig                     | 10 ++++++++++
> >  include/linux/sched/task_stack.h |  5 +++++
> >  2 files changed, 15 insertions(+)
> > 
> > diff --git a/arch/Kconfig b/arch/Kconfig
> > index 45c657772362..d6fa2ccb0599 100644
> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -431,6 +431,16 @@ config HAVE_ASM_MODVERSIONS
> >  	  <asm/asm-prototypes.h> to support the module versioning for symbols
> >  	  exported from assembly code.
> >  
> > +config ARCH_HAS_VARIABLE_STACK_SIZE
> > +	bool
> > +	depends on VMAP_STACK
> > +	depends on !STACK_GROWSUP
> > +	depends on THREAD_INFO_IN_TASK
> > +	help
> > +	  An arch should select this if it supports dynamically configuring the
> > +	  kernel stack size.
> > +	  For example the kernel stack size can be from the command line.
> 
> 	                                    can be set from the command line.
> ?
> 

I will fix it in v2.

Thanks,
Mostafa

> > +
> >  config HAVE_REGS_AND_STACK_ACCESS_API
> >  	bool
> >  	help
> > diff --git a/include/linux/sched/task_stack.h b/include/linux/sched/task_stack.h
> > index 4a808f9c4631..07d73adaecd1 100644
> > --- a/include/linux/sched/task_stack.h
> > +++ b/include/linux/sched/task_stack.h
> > @@ -10,6 +10,7 @@
> >  #include <linux/magic.h>
> >  #include <linux/refcount.h>
> >  #include <linux/kasan.h>
> > +#include <linux/vmalloc.h>
> >  
> >  #ifdef CONFIG_THREAD_INFO_IN_TASK
> >  
> > @@ -96,6 +97,10 @@ static inline unsigned long *end_of_stack(const struct task_struct *p)
> >   */
> >  static __always_inline unsigned long task_stack_size(const struct task_struct *task)
> >  {
> > +#ifdef CONFIG_ARCH_HAS_VARIABLE_STACK_SIZE
> > +	if (task->stack_vm_area)
> > +		return task->stack_vm_area->nr_pages * PAGE_SIZE;
> > +#endif
> >  	return THREAD_SIZE;
> >  }
> >  
> 
> -- 
> ~Randy
> 

