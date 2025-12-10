Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C13AAD3C932
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 23:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0E36B0006; Wed, 10 Dec 2025 18:30:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 290AF6B0007; Wed, 10 Dec 2025 18:30:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 159816B0008; Wed, 10 Dec 2025 18:30:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02BAD6B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 18:30:59 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 945C78AF8B
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 23:30:58 +0000 (UTC)
X-FDA: 84205158996.28.87754C7
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id CC304120011
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 23:30:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VDzoWwfe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765409456; a=rsa-sha256;
	cv=none;
	b=YjiGt7D1UtEs6VgMG1W7xx9UZmL11FdXGVD5POBZ+g9dp00PDcLu/R1h3333Yu396ZQEts
	EKn1+pbh0dnity2sYazCRNUFqDNH0J4AJXFwyiIe3Sc6puRwK0oFSkpkkpFoGCk6lh5wFh
	0jyaPLBYCw8WNsSHjugay40FRrlTRYQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VDzoWwfe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765409456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vOlEqmVy+73U363CFognUBRa2K0i3PxWElxkDhZWjLk=;
	b=0QK1pXBOn4y2Q6qm8zXU2CJO5uQcMH/Z+j0wTQxri8dHEf8osEeVk2QyIZyAuWGZT2a7D2
	nTj8EjQNpC5MIRBq71UcEE9FMh/URKY1zR2dlIlbefuAa2NZQB9vysc5Zqt4gbjONGEVlN
	g86HZF0nHvmmsliDM/EYhJtytedpnaQ=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7bc248dc16aso292962b3a.0
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 15:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765409455; x=1766014255; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vOlEqmVy+73U363CFognUBRa2K0i3PxWElxkDhZWjLk=;
        b=VDzoWwfeBC+/d9qA8jStonzuyd2ADpe88+c28J/nLHGddNMvCV/Mgs4L5JlNyqldrh
         HPCKz4rxK+ucdeKq0JO84AF4TO1fa+Aw4GKcAl3ufbSh447OYcO2xzhRYtqQOvFPd796
         FZGIIqIa1RLcT77R/JaVUVHAQpxf21gU1VtyZ4jMa97acCsGMXzIZkZg9Qm+un3d5buJ
         854Plq3LaVh0pjVv9LPuXQaTCj7xShVFLoeyOBA7O0HMbQS4Cke5LPRoQdYCfztOVVWt
         PkHZMyY46jMwCucGhimIzR+8sukwCDbOLO5/GqBFhy36YAoreo6lPYpN1CN4nhpHbDf3
         NyVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765409455; x=1766014255;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vOlEqmVy+73U363CFognUBRa2K0i3PxWElxkDhZWjLk=;
        b=hnkaNpa1aalxsFNmpww5x4UE6C0kfSlLmpUp1tD+Khe0AtFhPc8VvpLZY9xxTG0Peq
         ARWzEe9sU/d/lIl+I7XGiwQRXW+py2KUmnXQKEo+/Xofn7B3XsUmaIMLI/frgtfxrUa9
         jvNmVuYoF+Tn2KiMf+OIv/S+Bi/6nCXqoQl0PVIF+CaD3uhGEuKlZzL/fMlxRJvd+Ati
         Ss7spYgbAU+QcEJ5rMxveKKHOSAqgenHST12FHgPSbdDnTJ6ooy9vJSmTBW9A6eJ1R9+
         vaCgY8GRgUMf+/CNREXbprPDoAaVvL0BSoegcVWchbwXtPXFc3//CZ1anhgPBtCQhTGb
         XPuw==
X-Forwarded-Encrypted: i=1; AJvYcCXB6b2T8d4Rp5l+GcAndyrPc9/c1J565gMz0MjgAuhTZiCQbA+wcDOZExp+GV3JhjHIoobnVKjO9A==@kvack.org
X-Gm-Message-State: AOJu0YxNj3LxK3sXerrq4XmzcR/v7EfNyOSJoAPGOF71x3FCeuZYLnbR
	m2rAHMhCZCYtUoy5lTLUxyZJhdZgqYdmfWx01FRR9MXDQAh2jvsyEVLo
X-Gm-Gg: ASbGncsMhclmJxNqHz2GJ2umvfU5LwSFSNDCMkraIXaFrzkQ9EgzIsJOVBimz+n8Dpt
	Axze152EAkmyTX4xcUVBzp4af70Tv5LQ8CAVWrItbdJKL3dWJAF1Mc8UrbS4Gkxs4mkzgYpD8An
	Rti8AUD63lViYWmyZCAJuVcAfQ/2DyqudJg31ay7ddQbQlz3LVv+BLzrLCaNA07IznjVKskkkO7
	AfdbjFIA83hpnd1xQ7oYmeS2YVU2S6oyQQqmpvFQgDi5PBbzH6BmAafC6JuxljorEAEvzLdpt10
	sm4UUwOUWf9qWzu5MppC40x7pp6HnLVJch4QtnGID+b5SrTgL3ec6Z0vlTl5cSiQ5W/MPxztH+L
	evH2JfDyR/jTt8b1vrYcrYcr7ipLKhjdWdB20jbLpVwyW9jiEW3kwgwlsDfGLXrmkGNl6xBEhho
	kBHd+pNfpiQn4BYyfhClCG6frKxT6ItVjsKNt9nUNkH4s=
X-Google-Smtp-Source: AGHT+IFCB72B0o/sQmDTGIyPzZQLIGJRF1ZYB+3n5K7iLoBLsX+2QIXcCLgHbcUIqgdJt6uXdprH3Q==
X-Received: by 2002:a05:7022:ec09:b0:11a:335d:80d2 with SMTP id a92af1059eb24-11f296d74d6mr2913960c88.35.1765409455190;
        Wed, 10 Dec 2025 15:30:55 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f2e2ffac2sm2541353c88.11.2025.12.10.15.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 15:30:54 -0800 (PST)
Date: Wed, 10 Dec 2025 15:30:51 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org
Subject: Re: [linus:master] [mm/vmalloc]  a061578043:
 BUG:spinlock_trylock_failure_on_UP_on_CPU
Message-ID: <aToCq6XBybxAFopN@fedora>
References: <202512101320.e2f2dd6f-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202512101320.e2f2dd6f-lkp@intel.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: CC304120011
X-Rspamd-Server: rspam10
X-Stat-Signature: apykjt76x1i9hj78qs16bysdniqunih8
X-HE-Tag: 1765409456-52594
X-HE-Meta: U2FsdGVkX1//H4jjwGmVD8o/sZDvO0eBOvEHb+NiBEbo4TXrr1KvxZgNHrWIRBxaQkGLbn/XQGtVx8DYZ1nYLG2jRsC2IrWu9bOAu2LexrcWR2akQkwP3v/gbYaY2A/bdr2TjcNBemYZPrOQJNQ41fizzLIo8JldnYIQHzuKWSgucDVKPT1bUJ/sRGbEF7sANnCpaJtZ01j7tvebiXdZ/GtkTdDre1bJVvEl0ZjVJHgOqO2GKk0QQ2nJ72DqWBbDiNoDoOj7m6Sx1ADDoSK4CevL0ML3xTUK0L2VStvXFSpfHxA6FSx/YjA61RYdlVUeRA+IrTCZGYkbzw5ZgKpcxdwcqHjvIiLp833zDAPF/1hnRXa9FbLNb83nopiGSzTbVsIkmqxFjZ6+L832WkTNGtoJbt0zxP0yh7b1cCfKQ+rElM7WoHjKu07nFIEL5yX4n0pJ6IkvOrSpdNih5HnoRYd4xHQzdDNoazaWIJzYo6jb7FJL/sU+0iIf5EJRgx1UWejLv7nbMqs9hAks8GdNwSlSQ2nqRsnBwnatgveglrkaI4prYe4mFacWZzPoukmQ/N11a2Gkk7+kekmwRb/Fa7elxcmexgRgKu62heuTHTR0RQyqwXG8WAIPgLyHJLYiaNIs8AxSzD9O1yNySZ//Ug5yzmQ98bAnD5F6sD03nAHNj2cKh7kQaK3zQhFjK4xOuQm1hCAGGiSuGl+W3Qud0QQVQMidNDYmEkf9LHuUmlquI7jlmBHowCOL/+yWfO8BU4Ft/o14QXAYrbBKtkyXF8hqCcP0gzGt0OIuhSkDBnm3NmTICqOte56qL62lItFUPz/Zfkf21vMNhGLQegrULIemdZfO/Er/n1ovKtJqqpL4W4wa6CLIJOIjLb8aj0dXGYG6mSxm6Nc3+4pBBq5qIhfE3KqhjiDLxIv9is5F1IHkCU9/MXIpBP6BQ24AfnxsW24YwCqPMQXQLxzLawo
 CSx14Y++
 lKdjy8ARD3Kt1Hm95I47pTQecLNFK3gbHmWrC9VuaUNn9sFQubXCN3lZTXbDU0upE9+FiPtKwmY8JU3XCX57WnXa/WD7ABGwhbXXu7HtVSSPuXamJ4AoBwe/Q+swzBzWRc9Fq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 10, 2025 at 02:10:28PM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed "BUG:spinlock_trylock_failure_on_UP_on_CPU" on:
> 
> commit: a0615780439938e8e61343f1f92a4c54a71dc6a5 ("mm/vmalloc: request large order pages from buddy allocator")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> 
> [test failed on linus/master      cb015814f8b6eebcbb8e46e111d108892c5e6821]
> [test failed on linux-next/master c75caf76ed86bbc15a72808f48f8df1608a0886c]
> 
> in testcase: trinity
> version: 
> with following parameters:
> 
> 	runtime: 300s
> 	group: group-03
> 	nr_groups: 5
> 
> 
> 
> config: x86_64-randconfig-011-20251207
> compiler: clang-20
> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> the issue show randomly (~50%) in tests.
> 
> 645a3c4243473d5c a0615780439938e8e61343f1f92
> ---------------- ---------------------------
>        fail:runs  %reproduction    fail:runs
>            |             |             |
>            :60         50%           29:60   dmesg.BUG:spinlock_trylock_failure_on_UP_on_CPU
>            :60         50%           29:60   dmesg.RIP:_raw_spin_unlock_irqrestore
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202512101320.e2f2dd6f-lkp@intel.com
> 
> 
> [ 1046.632156][    C0] BUG: spinlock trylock failure on UP on CPU#0, kcompactd0/28
> [ 1046.633368][    C0]  lock: 0xffff888807e35ef0, .magic: dead4ead, .owner: kcompactd0/28, .owner_cpu: 0
> [ 1046.634872][    C0] CPU: 0 UID: 0 PID: 28 Comm: kcompactd0 Not tainted 6.18.0-rc5-00127-ga06157804399 #1 PREEMPT  8cc09ef94dcec767faa911515ce9e609c45db470
> [ 1046.637019][    C0] Call Trace:
> [ 1046.637563][    C0]  <IRQ>
> [ 1046.638038][    C0]  __dump_stack (lib/dump_stack.c:95)
> [ 1046.638781][    C0]  dump_stack_lvl (lib/dump_stack.c:123)
> [ 1046.639512][    C0]  dump_stack (lib/dump_stack.c:130)
> [ 1046.640168][    C0]  spin_dump (kernel/locking/spinlock_debug.c:71)
> [ 1046.640853][    C0]  do_raw_spin_trylock (kernel/locking/spinlock_debug.c:?)
> [ 1046.641678][    C0]  _raw_spin_trylock (include/linux/spinlock_api_smp.h:89 kernel/locking/spinlock.c:138)
> [ 1046.642473][    C0]  __free_frozen_pages (mm/page_alloc.c:2973)
> [ 1046.643279][    C0]  ___free_pages (mm/page_alloc.c:5295)
> [ 1046.643956][    C0]  __free_pages (mm/page_alloc.c:5334)
> [ 1046.644624][    C0]  tlb_remove_table_rcu (include/linux/mm.h:? include/linux/mm.h:3122 include/asm-generic/tlb.h:220 mm/mmu_gather.c:227 mm/mmu_gather.c:290)
> [ 1046.645520][    C0]  ? __cfi_tlb_remove_table_rcu (mm/mmu_gather.c:289)
> [ 1046.646384][    C0]  ? rcu_core (kernel/rcu/tree.c:?)
> [ 1046.647092][    C0]  rcu_core (include/linux/rcupdate.h:341 kernel/rcu/tree.c:2607 kernel/rcu/tree.c:2861)
> [ 1046.647774][    C0]  rcu_core_si (kernel/rcu/tree.c:2879)
> [ 1046.648439][    C0]  handle_softirqs (arch/x86/include/asm/jump_label.h:36 include/trace/events/irq.h:142 kernel/softirq.c:623)
> [ 1046.649202][    C0]  __irq_exit_rcu (arch/x86/include/asm/jump_label.h:36 kernel/softirq.c:725)
> [ 1046.649919][    C0]  irq_exit_rcu (kernel/softirq.c:741)
> [ 1046.650593][    C0]  sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1052)
> [ 1046.651520][    C0]  </IRQ>
> [ 1046.651984][    C0]  <TASK>
> [ 1046.652466][    C0]  asm_sysvec_apic_timer_interrupt (arch/x86/include/asm/idtentry.h:697)
> [ 1046.653389][    C0] RIP: 0010:_raw_spin_unlock_irqrestore (arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:194)
> [ 1046.654391][    C0] Code: 00 44 89 f6 c1 ee 09 48 c7 c7 e0 f2 7e 86 31 d2 31 c9 e8 e8 dd 80 fd 4d 85 f6 74 05 e8 de e5 fd ff 0f ba e3 09 73 01 fb 31 f6 <ff> 0d 2f dc 6f 01 0f 95 c3 40 0f 94 c6 48 c7 c7 10 f3 7e 86 31 d2
> All code
> ========
>    0:	00 44 89 f6          	add    %al,-0xa(%rcx,%rcx,4)
>    4:	c1 ee 09             	shr    $0x9,%esi
>    7:	48 c7 c7 e0 f2 7e 86 	mov    $0xffffffff867ef2e0,%rdi
>    e:	31 d2                	xor    %edx,%edx
>   10:	31 c9                	xor    %ecx,%ecx
>   12:	e8 e8 dd 80 fd       	call   0xfffffffffd80ddff
>   17:	4d 85 f6             	test   %r14,%r14
>   1a:	74 05                	je     0x21
>   1c:	e8 de e5 fd ff       	call   0xfffffffffffde5ff
>   21:	0f ba e3 09          	bt     $0x9,%ebx
>   25:	73 01                	jae    0x28
>   27:	fb                   	sti
>   28:	31 f6                	xor    %esi,%esi
>   2a:*	ff 0d 2f dc 6f 01    	decl   0x16fdc2f(%rip)        # 0x16fdc5f		<-- trapping instruction
>   30:	0f 95 c3             	setne  %bl
>   33:	40 0f 94 c6          	sete   %sil
>   37:	48 c7 c7 10 f3 7e 86 	mov    $0xffffffff867ef310,%rdi
>   3e:	31 d2                	xor    %edx,%edx
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	ff 0d 2f dc 6f 01    	decl   0x16fdc2f(%rip)        # 0x16fdc35
>    6:	0f 95 c3             	setne  %bl
>    9:	40 0f 94 c6          	sete   %sil
>    d:	48 c7 c7 10 f3 7e 86 	mov    $0xffffffff867ef310,%rdi
>   14:	31 d2                	xor    %edx,%edx
> [ 1046.657511][    C0] RSP: 0000:ffffc900001cfb50 EFLAGS: 00000246
> [ 1046.658482][    C0] RAX: 0000000000000000 RBX: 0000000000000206 RCX: 0000000000000000
> [ 1046.659740][    C0] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [ 1046.660979][    C0] RBP: ffffc900001cfb68 R08: 0000000000000000 R09: 0000000000000000
> [ 1046.662239][    C0] R10: 0000000000000000 R11: 0000000000000000 R12: ffff888807e35f50
> [ 1046.663505][    C0] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [ 1046.664741][    C0]  free_pcppages_bulk (mm/page_alloc.c:1494)
> [ 1046.665618][    C0]  drain_pages_zone (include/linux/spinlock.h:391 mm/page_alloc.c:2632)
> [ 1046.666374][    C0]  __drain_all_pages (mm/page_alloc.c:2731)
> [ 1046.667171][    C0]  drain_all_pages (mm/page_alloc.c:2747)
> [ 1046.667908][    C0]  kcompactd (mm/compaction.c:3115)
> [ 1046.668625][    C0]  kthread (kernel/kthread.c:465)
> [ 1046.669299][    C0]  ? __cfi_kcompactd (mm/compaction.c:3166)
> [ 1046.670046][    C0]  ? __cfi_kthread (kernel/kthread.c:412)
> [ 1046.670764][    C0]  ret_from_fork (arch/x86/kernel/process.c:164)
> [ 1046.671483][    C0]  ? __cfi_kthread (kernel/kthread.c:412)
> [ 1046.672174][    C0]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
> [ 1046.672936][    C0]  </TASK>
> 
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20251210/202512101320.e2f2dd6f-lkp@intel.com
> 

Hmmm. This looks like a race condition tied to reclaim. I'm assuming
we fail to allocate a page and kick off kswapd. Then when we fall back
to the bulk allocator which tries to remove a pcp page at the same time as
kswapd tries to reclaim it. Maybe?

Does something like this fix it?

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ecbac900c35f..0d1480723ddc 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3634,7 +3634,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	struct page *page;
 	int i;
 	unsigned int large_order = ilog2(nr_remaining);
-	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_DIRECT_RECLAIM;
+	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_RECLAIM;
 
 	large_order = min(max_attempt_order, large_order);

