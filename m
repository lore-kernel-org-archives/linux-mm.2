Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4666D41C14
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 10:09:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAEF86B0005; Thu, 11 Dec 2025 05:09:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5F7B6B0007; Thu, 11 Dec 2025 05:09:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4DF66B0008; Thu, 11 Dec 2025 05:09:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0CA76B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:09:50 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7269513519E
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:09:50 +0000 (UTC)
X-FDA: 84206768940.17.F550B4B
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6972E8000B
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:09:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V+spISU0;
	spf=pass (imf30.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765447788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1VYdT8hGFnnriukr/ws8dpb4JnnXunRZTQ/JzgeztOI=;
	b=RBCDX/9hjFB7p4aC98aomoW5UbfSaBRTVKhxmc0mPYL5gk28SiKhQlctXydwAMEGNRPKXa
	vvCGJMSWydC7EF0FQT6E+Olwi5nwcJsJP8TPPnG0p+GC8JK+xiaizhRpeBTeC9e27ScNsB
	Z1MNiprMTajaRn61XpHTyD9SW2JzOC0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V+spISU0;
	spf=pass (imf30.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765447788; a=rsa-sha256;
	cv=none;
	b=vCo0qLMDHS87Qf2W0vTs1q1qfbENkFIZfuJClMuuiFPjmMxYHbZ7LFs97R9nIIkSda9rIQ
	MdeqV5+irF2N4YSYcHtVPFnSaxDmYXDN20t72aqzbOVAl8l+LkauRDTs7BRrCfBFQ9NFqN
	8QpY6+LWx3Ni7peYNcbN6gGHs1ZKk+o=
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-37d056f5703so5782831fa.0
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 02:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765447786; x=1766052586; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1VYdT8hGFnnriukr/ws8dpb4JnnXunRZTQ/JzgeztOI=;
        b=V+spISU0jveTpY4WzMCG5BeSHU66Pfj9Co/iKBvLrhpyoCp3fh8bM9cJExD2Sxvwse
         Zy7OLsLhRigITX+rA3l7oD0Z9We5P8QOy1SEJWgWKUrIdgVXql4WtIJE5AMbPZ6GIoTk
         KZ9fD/y64Sgs5qi4hbq1CnT4mtJSjsNKQ9wF//xpYLSdHw1GcTVHiVqvqsay/C+kOi0c
         CS8jzcc7mWyynKd2kpFOpiQt9a8PMn1L0iI16JgElMnICARgcAjbrJGUQwvGelyDPQH7
         k/dRjcttbOQSXg06sRAJhE9G4PJf7cpaAGNR5nZKLTkGFgULpjeB9IRp1Hvy1aiUzwgN
         seaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765447786; x=1766052586;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1VYdT8hGFnnriukr/ws8dpb4JnnXunRZTQ/JzgeztOI=;
        b=T3rK/7pc0u0S56K5ABn06eZsGrkEwhOIFSf6VaziCLmGZsCkGBMmC9ZbZ3lZiFtqV4
         M8N15iNrHKXbTSwELeO3DBGP8eeJz8zIHhu2XibqTu0Tl0aEnfVPzWhZC73Jv+nj/Hm2
         jk/D0nP7Q3JbHJZBAYMdl2zW5Y9/6QMu2sCnFjNtPzDFb1qFri/TX0G5AjhgpSw68L7z
         zOzZd7dCcGjTCxSt7eK86Gd2rChxeXQfKoEO6m5pGWx5e9NpVLTWFkrs60T5/r/tHWKs
         MCqjKjGQOank5ZjMQR5FpGwUNWySIUUZaJbzhXVDdmBpxtDXp5ZWozvmrHkh+9PDSMOS
         LaXw==
X-Forwarded-Encrypted: i=1; AJvYcCU6yT4u0vkjCcUMNT7wzDFVkcaMeIyCVBqLE3OHfaCxYe8tnK+8YRJRxWDiM6VvRqma86nPARUkjQ==@kvack.org
X-Gm-Message-State: AOJu0YxFn3mh/7mKPEDOTZ13eraVwR95w5ibdNavTh28phB12ZY1BXQP
	whJOcIGD3dJWEGp79t5ApCJlbp+kPzB8bmeIH6LJ73Evb2l62/35u4Ta
X-Gm-Gg: AY/fxX5RkynFXZLVK/sLrQNin6oJcDWZ3uDOQrszcq1JHJwjanZhJpo9LfDvF9BW28o
	YCW7z/UUu/Msiw+HuBix1qrmMoyWYP24Xnyz+vRIu07T6Uin0b2U1/RCAwgk/PYwI819biYAnWm
	U8QYTKNubYOJjFg/Gs5ijyzNJWzakUlQdo05eTlO28j7qzoqB7LbI8HCkALDieuMSPytK1SNdOQ
	+afGhT8qP/kBkqTIDEbEvCEOeqd2JGDqBQEny6gnKROWM9V6pxii6Ymt2fSoRREQmOWPC8+lg8N
	5fLO77E3ZHFXec4zjAfLnZ42PTmmpFl1qkUXKP7Ny60G06egArBpoo6rNED5dPJsIJg0YqTF+XW
	Tq6Usdg5MzA5nHibW6RIWLIy/n7anVxloGRB+IaJf173Ex4Z6jIa4Z6VEORQPJmkzY7XfDKIdOn
	8xmeeRx0SlKdao89wTRo0i44Zv6nIost87YFt39g==
X-Google-Smtp-Source: AGHT+IEQjLY+osX45Ymfh7gCi2D3TDyaFVdPSReW2Aj3EiksymKNTdDIl5TREk2+/LT/qOy9A4moew==
X-Received: by 2002:a05:6512:2216:b0:594:36b3:d1fa with SMTP id 2adb3069b0e04-598ee4dbeabmr1950373e87.29.1765447785847;
        Thu, 11 Dec 2025 02:09:45 -0800 (PST)
Received: from pc636 (host-90-233-204-39.mobileonline.telia.com. [90.233.204.39])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37fbca9435csm5770731fa.44.2025.12.11.02.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 02:09:45 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Thu, 11 Dec 2025 11:09:43 +0100
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org
Subject: Re: [linus:master] [mm/vmalloc]  a061578043:
 BUG:spinlock_trylock_failure_on_UP_on_CPU
Message-ID: <aTqYZ7hearly5H6c@pc636>
References: <202512101320.e2f2dd6f-lkp@intel.com>
 <aToCq6XBybxAFopN@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aToCq6XBybxAFopN@fedora>
X-Stat-Signature: 8eu57gsfaq9g8kjg65ce8hxuyf6fw77y
X-Rspamd-Queue-Id: 6972E8000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765447788-819530
X-HE-Meta: U2FsdGVkX18V0FCLSbterxCForzPZlj2zv7IokRfP8f/UC/IEM971r4Gi5yteYfPa39IwABAcKnK6x5htnI1ZO0GoylnnEixEZuV+lHeffEi+rUZnkD6SM5x7RywwSCschQP7wG+AxP+W8zucuoxZAzw3FgEdGHtzXxj8rOH5y2ZBi79zqou4hm7+0ZafuLNNa6Pss6+KVOXMw2n/Z6Djxw8ZSOWoTOb3iRujlus6sWrketH+celEZsMftPFGyRK8I58/0rU04xTmIQNRmT4EJTBU+2iUhBy8n+NyM0QMou2cGaGZJl9Hpxj7JF3p1iNHikiwMSNtXYv+E0ClBhCKufCot/hL4LDohHuLq776j6tHXrPhe7db9QgH/jFP4fTIiQWNQK+DgjKJRDzuBJuv7wpDIr/lbE2oxSjkWQm+XkfAUhLFFz5l3mX99L3kqUpadaNaTmCrwUSZZpDZqt15VlMNLxG03s6THSg0pQ3jmJs335jHiT7uvpS9C1/GCCRv9IN174+Zxzs2VlwIKArL/YOhdtyfSi/4uqeP89lyqrfXUXQWkPGN9c+UG8ULozgG+ZPTREsGL6qhyT/HbFvDGQXsWZKOZJfHmkfbRYCg+SnwV1HUqqQJJxRerpkn+5EhDnT19gKoTgQskxRzyETlwvVxjusrDBvqqUSoZdGNr8Tci99JrW+5f4JDrC1H0AOeoPTw3WtXumxl9fV7S6yR7WVNluvGCPGwUCXPAA6D+l/Ft8o2LhURsAN8CXDazXG+r7FfnnEB1AC7mbfZ4qSJ8yjlCKxj4KCxBC/SYHRFF86Dr9bk7GJ/JX/DNU775V0gPu/gjbUGeq0jaJ/syyxcVW0NYShQ5nhth2q/kIrxV5nNgjomXFy3oOode79IdrON8QZep74Ni53TmdJPhxiqapxWk2Bbi+LVNJ4zhE1wLFy4JYbya7fhpQxqrUCtIShAE5/LoIBTA4oCPV2BFI
 HgSIXq6t
 8KOqgI0e3xBJD/02XS6nli0NrDUlHlIj14r0ZqzTNS6lqadcjEi1quZu4NWnvXXSMQ7qnPDUEAoLt8u18z1dvX2kw71cQn4QEm0MMq7jYvMulcFIExf8ARRVI1WbhlN1B27ZWXj9WEvOeNCjcyUTzsfzm+83n35Ed5+FgNfZf02YUkRpmYAmEiQMl3H4PNXQu610447/3gXVeWM66A2+YZP+9Nii9ljPQk28EripfwKVBJUE/d80+Acx5m2hbKx/8b2CKS1a5CSkVKILhx83lzxXj56p+Vrs8sQPHJ0Jv7pr7IGIdps/u/b1mGVdwKKjiI0tcvUt3Y+bdRdDV1QLcx0Vy0E5R+zcajSdpZnh5jsjkAge5fKkltK3zcbf34Jfbc7Ma/rUW1w5lmwE8J7Pfolq2VVN3cd6AxVtAZosCpoL9NirHcYStLwk23ZW/FNIHvz5Jedwfj/2669L8S62jOcsNa7XERncvVJkOX6d0+Et/mFxdwPxHCQqCBpBJhLoYQtU/C0DazlGJWNQsvDDMrSx/E6zRhUdJc8TW9TmipluUw8jwIFH3TU7rNkUBR1SqF3qxnyS3ZKIEvOC7PtdFHVhp8WleRfSUmPA+t7Zw0nKX2Dk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 10, 2025 at 03:30:51PM -0800, Vishal Moola (Oracle) wrote:
> On Wed, Dec 10, 2025 at 02:10:28PM +0800, kernel test robot wrote:
> > 
> > 
> > Hello,
> > 
> > kernel test robot noticed "BUG:spinlock_trylock_failure_on_UP_on_CPU" on:
> > 
> > commit: a0615780439938e8e61343f1f92a4c54a71dc6a5 ("mm/vmalloc: request large order pages from buddy allocator")
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > 
> > [test failed on linus/master      cb015814f8b6eebcbb8e46e111d108892c5e6821]
> > [test failed on linux-next/master c75caf76ed86bbc15a72808f48f8df1608a0886c]
> > 
> > in testcase: trinity
> > version: 
> > with following parameters:
> > 
> > 	runtime: 300s
> > 	group: group-03
> > 	nr_groups: 5
> > 
> > 
> > 
> > config: x86_64-randconfig-011-20251207
> > compiler: clang-20
> > test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G
> > 
> > (please refer to attached dmesg/kmsg for entire log/backtrace)
> > 
> > 
> > the issue show randomly (~50%) in tests.
> > 
> > 645a3c4243473d5c a0615780439938e8e61343f1f92
> > ---------------- ---------------------------
> >        fail:runs  %reproduction    fail:runs
> >            |             |             |
> >            :60         50%           29:60   dmesg.BUG:spinlock_trylock_failure_on_UP_on_CPU
> >            :60         50%           29:60   dmesg.RIP:_raw_spin_unlock_irqrestore
> > 
> > 
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > | Closes: https://lore.kernel.org/oe-lkp/202512101320.e2f2dd6f-lkp@intel.com
> > 
> > 
> > [ 1046.632156][    C0] BUG: spinlock trylock failure on UP on CPU#0, kcompactd0/28
> > [ 1046.633368][    C0]  lock: 0xffff888807e35ef0, .magic: dead4ead, .owner: kcompactd0/28, .owner_cpu: 0
> > [ 1046.634872][    C0] CPU: 0 UID: 0 PID: 28 Comm: kcompactd0 Not tainted 6.18.0-rc5-00127-ga06157804399 #1 PREEMPT  8cc09ef94dcec767faa911515ce9e609c45db470
> > [ 1046.637019][    C0] Call Trace:
> > [ 1046.637563][    C0]  <IRQ>
> > [ 1046.638038][    C0]  __dump_stack (lib/dump_stack.c:95)
> > [ 1046.638781][    C0]  dump_stack_lvl (lib/dump_stack.c:123)
> > [ 1046.639512][    C0]  dump_stack (lib/dump_stack.c:130)
> > [ 1046.640168][    C0]  spin_dump (kernel/locking/spinlock_debug.c:71)
> > [ 1046.640853][    C0]  do_raw_spin_trylock (kernel/locking/spinlock_debug.c:?)
> > [ 1046.641678][    C0]  _raw_spin_trylock (include/linux/spinlock_api_smp.h:89 kernel/locking/spinlock.c:138)
> > [ 1046.642473][    C0]  __free_frozen_pages (mm/page_alloc.c:2973)
> > [ 1046.643279][    C0]  ___free_pages (mm/page_alloc.c:5295)
> > [ 1046.643956][    C0]  __free_pages (mm/page_alloc.c:5334)
> > [ 1046.644624][    C0]  tlb_remove_table_rcu (include/linux/mm.h:? include/linux/mm.h:3122 include/asm-generic/tlb.h:220 mm/mmu_gather.c:227 mm/mmu_gather.c:290)
> > [ 1046.645520][    C0]  ? __cfi_tlb_remove_table_rcu (mm/mmu_gather.c:289)
> > [ 1046.646384][    C0]  ? rcu_core (kernel/rcu/tree.c:?)
> > [ 1046.647092][    C0]  rcu_core (include/linux/rcupdate.h:341 kernel/rcu/tree.c:2607 kernel/rcu/tree.c:2861)
> > [ 1046.647774][    C0]  rcu_core_si (kernel/rcu/tree.c:2879)
> > [ 1046.648439][    C0]  handle_softirqs (arch/x86/include/asm/jump_label.h:36 include/trace/events/irq.h:142 kernel/softirq.c:623)
> > [ 1046.649202][    C0]  __irq_exit_rcu (arch/x86/include/asm/jump_label.h:36 kernel/softirq.c:725)
> > [ 1046.649919][    C0]  irq_exit_rcu (kernel/softirq.c:741)
> > [ 1046.650593][    C0]  sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1052)
> > [ 1046.651520][    C0]  </IRQ>
> > [ 1046.651984][    C0]  <TASK>
> > [ 1046.652466][    C0]  asm_sysvec_apic_timer_interrupt (arch/x86/include/asm/idtentry.h:697)
> > [ 1046.653389][    C0] RIP: 0010:_raw_spin_unlock_irqrestore (arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:194)
> > [ 1046.654391][    C0] Code: 00 44 89 f6 c1 ee 09 48 c7 c7 e0 f2 7e 86 31 d2 31 c9 e8 e8 dd 80 fd 4d 85 f6 74 05 e8 de e5 fd ff 0f ba e3 09 73 01 fb 31 f6 <ff> 0d 2f dc 6f 01 0f 95 c3 40 0f 94 c6 48 c7 c7 10 f3 7e 86 31 d2
> > All code
> > ========
> >    0:	00 44 89 f6          	add    %al,-0xa(%rcx,%rcx,4)
> >    4:	c1 ee 09             	shr    $0x9,%esi
> >    7:	48 c7 c7 e0 f2 7e 86 	mov    $0xffffffff867ef2e0,%rdi
> >    e:	31 d2                	xor    %edx,%edx
> >   10:	31 c9                	xor    %ecx,%ecx
> >   12:	e8 e8 dd 80 fd       	call   0xfffffffffd80ddff
> >   17:	4d 85 f6             	test   %r14,%r14
> >   1a:	74 05                	je     0x21
> >   1c:	e8 de e5 fd ff       	call   0xfffffffffffde5ff
> >   21:	0f ba e3 09          	bt     $0x9,%ebx
> >   25:	73 01                	jae    0x28
> >   27:	fb                   	sti
> >   28:	31 f6                	xor    %esi,%esi
> >   2a:*	ff 0d 2f dc 6f 01    	decl   0x16fdc2f(%rip)        # 0x16fdc5f		<-- trapping instruction
> >   30:	0f 95 c3             	setne  %bl
> >   33:	40 0f 94 c6          	sete   %sil
> >   37:	48 c7 c7 10 f3 7e 86 	mov    $0xffffffff867ef310,%rdi
> >   3e:	31 d2                	xor    %edx,%edx
> > 
> > Code starting with the faulting instruction
> > ===========================================
> >    0:	ff 0d 2f dc 6f 01    	decl   0x16fdc2f(%rip)        # 0x16fdc35
> >    6:	0f 95 c3             	setne  %bl
> >    9:	40 0f 94 c6          	sete   %sil
> >    d:	48 c7 c7 10 f3 7e 86 	mov    $0xffffffff867ef310,%rdi
> >   14:	31 d2                	xor    %edx,%edx
> > [ 1046.657511][    C0] RSP: 0000:ffffc900001cfb50 EFLAGS: 00000246
> > [ 1046.658482][    C0] RAX: 0000000000000000 RBX: 0000000000000206 RCX: 0000000000000000
> > [ 1046.659740][    C0] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > [ 1046.660979][    C0] RBP: ffffc900001cfb68 R08: 0000000000000000 R09: 0000000000000000
> > [ 1046.662239][    C0] R10: 0000000000000000 R11: 0000000000000000 R12: ffff888807e35f50
> > [ 1046.663505][    C0] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> > [ 1046.664741][    C0]  free_pcppages_bulk (mm/page_alloc.c:1494)
> > [ 1046.665618][    C0]  drain_pages_zone (include/linux/spinlock.h:391 mm/page_alloc.c:2632)
> > [ 1046.666374][    C0]  __drain_all_pages (mm/page_alloc.c:2731)
> > [ 1046.667171][    C0]  drain_all_pages (mm/page_alloc.c:2747)
> > [ 1046.667908][    C0]  kcompactd (mm/compaction.c:3115)
> > [ 1046.668625][    C0]  kthread (kernel/kthread.c:465)
> > [ 1046.669299][    C0]  ? __cfi_kcompactd (mm/compaction.c:3166)
> > [ 1046.670046][    C0]  ? __cfi_kthread (kernel/kthread.c:412)
> > [ 1046.670764][    C0]  ret_from_fork (arch/x86/kernel/process.c:164)
> > [ 1046.671483][    C0]  ? __cfi_kthread (kernel/kthread.c:412)
> > [ 1046.672174][    C0]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
> > [ 1046.672936][    C0]  </TASK>
> > 
> > 
> > 
> > The kernel config and materials to reproduce are available at:
> > https://download.01.org/0day-ci/archive/20251210/202512101320.e2f2dd6f-lkp@intel.com
> > 
> 
> Hmmm. This looks like a race condition tied to reclaim. I'm assuming
> we fail to allocate a page and kick off kswapd. Then when we fall back
> to the bulk allocator which tries to remove a pcp page at the same time as
> kswapd tries to reclaim it. Maybe?
> 
> Does something like this fix it?
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index ecbac900c35f..0d1480723ddc 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3634,7 +3634,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  	struct page *page;
>  	int i;
>  	unsigned int large_order = ilog2(nr_remaining);
> -	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_DIRECT_RECLAIM;
> +	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_RECLAIM;
>  
>  	large_order = min(max_attempt_order, large_order);
>
Some thoughts.

That trace is not easy to follow. As for this change, probably it
is worth to go with anyway. Because, if we are under a low memory
condition, it is quite common for Android devices, we do not want
to kick frequently kswapd without good reason. We have a fallback
to single page allocator.

--
Uladzislau Rezki

