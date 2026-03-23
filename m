Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B704F483DB
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1B826B0095; Mon, 23 Mar 2026 19:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCCE56B0098; Mon, 23 Mar 2026 19:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09926B0099; Mon, 23 Mar 2026 19:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A39746B0095
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:46:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6DEA11F07F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:46:24 +0000 (UTC)
X-FDA: 84578964288.23.9902FE2
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7F82C140009
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:46:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bBXF9EtQ;
	spf=pass (imf23.hostedemail.com: domain of naup96721@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=naup96721@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774309582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Yh4+m9w0E7Q7phDH+oVMFKEtBHte8E5GSUxHvgsU7g=;
	b=P6rLFlX/5f5VGv4PW0mFmXDHXpNI3Wq9qTGy1UH0N4S+MwY+/5I2fhKUc3zor9vf+ID0ZI
	R+GV8sAaILGPM885fR/YY4g2AlMh3VApTcnIjNX+eikYe8zazi0raX+N0HqXH5Ut6wwzC+
	kC21N196Ftf90/dRDYtDHJdC6T5kxqY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bBXF9EtQ;
	spf=pass (imf23.hostedemail.com: domain of naup96721@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=naup96721@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774309582; a=rsa-sha256;
	cv=none;
	b=tgFm2/L/Ko24A88QdJLiWB0b8fV/r9oNzZmFHDpDfNiDoZ2zbIbRsuHnoB1TpRRLKJqc37
	XgsIHAI2PpvvPLxl445ySkuE0ksAM3FhoC0DnCx4SKGToQzq8fgNvbh/OcqxhYI25m1QI9
	CAwHNMzedbeynFADs/5o+JdVJgCeWz4=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3591cc98871so2015078a91.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774309581; x=1774914381; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/Yh4+m9w0E7Q7phDH+oVMFKEtBHte8E5GSUxHvgsU7g=;
        b=bBXF9EtQ6WOWaFQRGoZ8YkTWx1HSOQp9maF3biGvEkssMZuWOooyFjjN3mWgUp5v6t
         h6ycLRk54t3Q329TiUYimIZUmuTx6AsWU4E3dS1KBFBCsd7xQK58iPhRP4ghMF7AweYD
         1ZN2dW9y4kU8InxDOrLGTINTsT16k1vE72FFBKhKhNKJLRUApT8ADktIJfcVRbSSh1s+
         Si1/VFwhYhRAkV3CL8KHtaDlQ1C3cZ/TuF1Vbfa1eTxdfV34gmfJtHbV10V8qvwXwGQy
         usqSUSFeTkfdK60nEYSQvOd9cq3Z4NicrWK88GEZvErxNu6CsyptBQ0OLxKNgLH6NqBH
         +/qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774309581; x=1774914381;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Yh4+m9w0E7Q7phDH+oVMFKEtBHte8E5GSUxHvgsU7g=;
        b=TMiTDdYWNgJdrHRqjUb20WecSQlCSrm+2EBpjozQhtNu0scoJxYdmRigY+Hw0Mhjd/
         65ZIAixQA/r3p3uyFL73rCZD8rm5UAGh4WYgHtnThnf9Xbq2LUMrSjHarao0po04OkOW
         9H24Ueq0xNNibJh0B67m2eHOz2jtSwtbF/UD9Y4DCtI70cCFhOdrqRJcUGCaLoA7qD2y
         uliKIeQ/UuzeMc3Y3Q1Na68wbQ614GKUR2hDZjhFgnoqo66qtBnGJ/LGlOYPm7AWl7s7
         8Rch7+OKZVaPoglrc8bRs+tJJDBLMVTOO9Emdse5QwVSYPR50ZwoVtvYuFCOXyKYN6jU
         PCUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPqbrh2avRDKjhaJOlPiA91PNlv2rbR4LtL10DVOfTxGumci1HOZhzZRFHBYtSPT8t9aT9h3TOlw==@kvack.org
X-Gm-Message-State: AOJu0YxRztTUMh/sYq73tQH28j7nF5Ip8IluqgVbXSf7JhrIiA4KbStU
	954XhGVLGbbq7XtZP4i4pYgxC/PThZRTEgdRKLY9kMbKSVLsPWfZm0qS
X-Gm-Gg: ATEYQzyrxfK6/+6F+28Ig2gon+5V4n8Lp3oEBhqLcFkgvX0YEGujc583V7qL58dd5/C
	8JpWE8IILeV/KXpBgkBDMR0b8Inctx+yNJvMGKEdIdS2kgQjbN4u28CkKwcTraolIQx7qamR+yI
	Nqh7h3ceyThms3q94K2tCgjL03nFea9j3eSDNGaYGkvMT1NZu9S9bAN5dcVyELZSfdGrb1tj0oU
	N6etw5M4QNCRSkHNvRq3SwYEMeA7XNlon37W/V/LLYW4SQAcwW8VPrIjxUOlt6+DNdxSrIkvOnz
	MxqeSWMJH9DvZtahwmMQdXgvw8CuVC7K7hdCdqrP6CcqTgB2pU4zsxDdYuZ+3JzvDU/kh5IxH0x
	/EOebnvt17mlqZ7ntkzaG+eVWirRFHpUNhCHuvk/k7PwWXImMvUa8f+Yb9qgLZ2ibY0xkA1+P/Q
	XzVKLnfL16BKQ11WAcrol6vjUnvt+cpOtLAsy9/g2FM196NEza
X-Received: by 2002:a17:90b:4ccb:b0:359:f0e1:f8c9 with SMTP id 98e67ed59e1d1-35bd2b97290mr11344524a91.6.1774309581298;
        Mon, 23 Mar 2026 16:46:21 -0700 (PDT)
Received: from naup-virtual-machine ([140.113.92.221])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c03124a94sm220036a91.2.2026.03.23.16.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 16:46:20 -0700 (PDT)
Date: Tue, 24 Mar 2026 07:46:17 +0800
From: Hao-Yu Yang <naup96721@gmail.com>
To: Thomas Gleixner <tglx@kernel.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hillenbrand <david@kernel.org>,
	Eric Dumazet <edumazet@google.com>, linux-mm@kvack.org,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] futex: Use-after-free between futex_key_to_node_opt
 and vma_replace_policy
Message-ID: <acHQyT8HubSKT4iV@naup-virtual-machine>
References: <20260313124756.52461-1-naup96721@gmail.com>
 <87a4vyihlx.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a4vyihlx.ffs@tglx>
X-Rspamd-Queue-Id: 7F82C140009
X-Stat-Signature: m7osg7qcsizcjiw5q5rttmutq94sdho5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774309582-202236
X-HE-Meta: U2FsdGVkX18SKAlSN7Up3tiPwZ6CmY9pLzCjfNtDF6w55jIZdXcV1WqYN7QMNK9vy1vtSdtP701dknrYFby9h4/mldgi2ZbFjFRNGG0IUovQEVclZA3ZgwtwOzd5XJg3Z9Yv55F6kOdFLkeci4msgsOMon82L0jQtyb5RuCxxvcyHzUdkjDcS1vb6I/lcq5vACgi0iaEKqz0d27rQZTDezUo23CAFX4wV4nIFBNtV4BnwH6snx4taxyZYjbCS/C6atmn2X33f3deFQ2M78oAkfR0JFazpwNMf1kkTNncgCnG4x/fRP1agSPZfeEYNJAMhcj0ktcJIp9hqTBm4Ci+badSkWXIyp3GMT+CXskHLECIBcYBr1PKcoVJM0uk2qk1bvbNdHA6disPRAG6yYoCn+hg1SsjAv853QV6LYUv46JNpgtA7WQbGhxtJemw1pL38i75b3shz9mIAXvwk0QEQfQAWOoaoHYFSTyh5wixzk12VFexmNCsjwn58bHa3wp01E+/jpR9AxQKp1YpQGw4dIyYGctG/dCwZbuYENcrHK5w3R1MGrTJBuqlGejohTinpCjJ6wGhL1wlvtNO4OwX2Km2IkpEXOTDWofnfrYkq54li2vq9OYHKud/6H1q3jM+O7q+r/M+eq1gE9zsbxTGHKwgMx6vfTDQmOq3HE3DCAC9W1BVFrYH91k5ayU5xP8xVJOZ0RQ54Fz1IYjT1fTlLjdh1uL3PaH3zKZ3JhxpOW8+N2RUMimY79JL/DI2Vs2gHD5svqGw5m0k2YcLkQ8EjDZaC+9vqRZrnG6ZVz7H4mcjFZ0V74khcp89gsQoR8uh5hpxdoJqeqjGM50uFMg6GPMhDcEmsfe/9dJlVHZ58g/5r8nIkjSoiCSQSav9gZJDfmrh08jjAtyzkdz2IpL/OKBsvQBa4D1aWE77/sx6JjI/RXvsdutPo0N8nogxyLsXYzWn/x0vo8da3DSU+rq
 DF2SNVAc
 uH318bGfGLpPIsr9Rql9QMTpi9x51tBgbd9qclfgYwk/j98NRbaktzjBknVathWtxQqNU863P04KgY2rnIEXIbPRD5EtvdyA0W4cnvRKfHKitq1nf867GxOsCLVhCNU35R1gMTDwVakU+0c1YqzinM2O5Wwh0XISeiZZNp55Ao21F2MvgcqRnfIhQwOzEWQYX8RtSEDuaTVWkYtMILUiGSD/14zrxBaYaVRYVfyVHf65PtsKghlZ8JtgBRWXXfvimdh8biQA+3UsyQQVV485OoupBgpHXXX5Lk90Zop+gtYVVSXaM/A7s/Rot+it1Ofcx43CSD2Pnnsm4JTLDWAw8Q7zu/arewlxPDeilIjytlAFeHufuepvSYDnp/fh35q9ePoYC2UkS9j3zjbjj2yVZnOirxt1O3+Jrkhmk1zE+AhCX+xQYqPZ4XIoKvJR5yO0GXhYcGSnO8vhYnIESApXpCcVSpUWwR0usHObk9zrrONNa4yRMqWkHGCYoP7yTcVRRK4alCpBPqQFZ3k8j1wu78GK+djEiXd69dMp/LQ8Op0e1m79NRZP4cS132pJGYYMx78AI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry, I'm not familier RCU and mempolicy. I don't know how to patch this part correctly.

On Mon, Mar 23, 2026 at 06:24:42PM +0100, Thomas Gleixner wrote:
> Hao-Yu!
> 
> On Fri, Mar 13 2026 at 20:47, Hao-Yu Yang wrote:
> 
> I've removed the security list as this is public already.
> Also added the mm list and the maintainers. While it fixes the futex
> problem it is a change to the MM subsystem, so those people need to be
> involved.
> 
> > During futex_key_to_node_opt() execution, vma->vm_policy is read under
> > speculative mmap lock and RCU. Concurrently, mbind() may call
> > vma_replace_policy() which frees the old mempolicy immediately via
> > kmem_cache_free().
> >
> > This creates a race where __futex_key_to_node() dereferences a freed
> > mempolicy pointer, causing a use-after-free read of mpol->mode.
> 
> > [  151.412631] BUG: KASAN: slab-use-after-free in __futex_key_to_node (kernel/futex/core.c:349)
> > [  151.414046] Read of size 2 at addr ffff888001c49634 by task e/87
> > [  151.414476]
> > [  151.415431] CPU: 1 UID: 1000 PID: 87 Comm: e Not tainted 7.0.0-rc3-g0257f64bdac7 #1 PREEMPT(lazy)
> > [  151.415758] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> > [  151.415969] Call Trace:
> > [  151.416059]  <TASK>
> > [  151.416161]  dump_stack_lvl (lib/dump_stack.c:123)
> > [  151.416299]  print_report (mm/kasan/report.c:379 mm/kasan/report.c:482)
> > [  151.416359]  ? __virt_addr_valid (./include/linux/mmzone.h:2046 ./include/linux/mmzone.h:2198 arch/x86/mm/physaddr.c:54)
> > [  151.416412]  ? __futex_key_to_node (kernel/futex/core.c:349)
> > [  151.416517]  ? kasan_complete_mode_report_info (mm/kasan/report_generic.c:182)
> > [  151.416583]  ? __futex_key_to_node (kernel/futex/core.c:349)
> > [  151.416631]  kasan_report (mm/kasan/report.c:597)
> > [  151.416677]  ? __futex_key_to_node (kernel/futex/core.c:349)
> > [  151.416732]  __asan_load2 (mm/kasan/generic.c:271)
> > [  151.416777]  __futex_key_to_node (kernel/futex/core.c:349)
> > [  151.416822]  get_futex_key (kernel/futex/core.c:374 kernel/futex/core.c:386 kernel/futex/core.c:593)
> > [  151.416871]  ? __pfx_get_futex_key (kernel/futex/core.c:550)
> > [  151.416927]  futex_wake (kernel/futex/waitwake.c:165)
> > [  151.416976]  ? __pfx_futex_wake (kernel/futex/waitwake.c:156)
> > [  151.417022]  ? __pfx___x64_sys_futex_wait (kernel/futex/syscalls.c:398)
> > [  151.417081]  __x64_sys_futex_wake (kernel/futex/syscalls.c:382 kernel/futex/syscalls.c:366 kernel/futex/syscalls.c:366)
> > [  151.417129]  x64_sys_call (arch/x86/entry/syscall_64.c:41)
> > [  151.417236]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
> > [  151.417342]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
> > [  151.418312]  </TASK>
> 
> Please trim the backtrace so it only contains the real important
> information.
> 
>   https://docs.kernel.org/process/submitting-patches.html#backtraces-in-commit-messages
> 
> > Fix by adding rcu to __mpol_put().
> >
> > change-log:
> >  v2-v1: add rcu to __mpol_put
> 
> The change history is not part of the change log, it want's to be placed
> after the --- separator.
> 
> > Fixes: c042c505210d ("futex: Implement FUTEX2_MPOL")
> > Reported-by: Hao-Yu Yang <naup96721@gmail.com>
> > Signed-off-by: Hao-Yu Yang <naup96721@gmail.com>
> 
> This should have a
> 
>      Suggested-by: Eric Dumazet <edumazet@google.com>
> 
> tag.
> 
> > ---
> >  include/linux/mempolicy.h | 1 +
> >  mm/mempolicy.c            | 2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
> > index 0fe96f3ab3ef..65c732d440d2 100644
> > --- a/include/linux/mempolicy.h
> > +++ b/include/linux/mempolicy.h
> > @@ -55,6 +55,7 @@ struct mempolicy {
> >  		nodemask_t cpuset_mems_allowed;	/* relative to these nodes */
> >  		nodemask_t user_nodemask;	/* nodemask passed by user */
> >  	} w;
> > +	struct rcu_head rcu;
> >  };
> >  
> >  /*
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 0e5175f1c767..6dc61a3d4a32 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -487,7 +487,7 @@ void __mpol_put(struct mempolicy *pol)
> >  {
> >  	if (!atomic_dec_and_test(&pol->refcnt))
> >  		return;
> > -	kmem_cache_free(policy_cache, pol);
> > +	kfree_rcu(pol, rcu);
> >  }
> >  EXPORT_SYMBOL_FOR_MODULES(__mpol_put, "kvm");
> 
> While this looks functionally correct it is incomplete in terms of RCU.
> 
> The vma->vm_policy pointer needs to be marked __rcu. That then requires
> to use rcu_dereference_check() at the reader side and
> rcu_assign_pointer() and rcu_replace_pointer() on the writer side.
> 
> Especially the writer side is required so that the proper memory
> barriers are inserted for architectures with a weakly ordered memory
> model.
> 
> Thanks,
> 
>         tglx

