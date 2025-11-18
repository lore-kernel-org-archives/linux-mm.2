Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54E13CEBF61
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 00:44:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C72D8E0013; Mon, 17 Nov 2025 19:44:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877538E0002; Mon, 17 Nov 2025 19:44:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B3CB8E0013; Mon, 17 Nov 2025 19:44:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5378E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:44:36 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0405C86E70
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:44:35 +0000 (UTC)
X-FDA: 84121882152.03.5137591
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0C924C000B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:44:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VM8t5+0w;
	spf=pass (imf10.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763426674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Rw6N3DfQLTWZubv1tCO5tCu5Q2UsmjpxOpe9crG0Mk=;
	b=xIEYh/7oUTlY3t8bYa5VBSBoD3hVAR0IDFaL6dt6luNuiNxIuShgcH1sibgUKg94p+P+/I
	rVkfaeoI9wRN2ihUaa9MIFkuFgQxMOs6yQxzuJCfX1fuVayGQ7whHUDSHOfn75CE0faWob
	j6ZQEwTddu3bJu0eH7eToVGZGc3p7bw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VM8t5+0w;
	spf=pass (imf10.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763426674; a=rsa-sha256;
	cv=none;
	b=DrJwcOJRpWvtft/mlORNpWhvXEwuoFKxy2q/kqZ2W9KwSTHpdqhoItu57e3YnJZwrN+8nV
	wVVxvgg5CN/WCKq2yWiPC5XYa8vfCgs8dxAw/M5VXZYsXZFRE/LRXaqZ/I9tJIYDX0xPoY
	dZoUWuVRjiKNjA12wxmsc8vbhlyO+yI=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b8c0c0cdd61so4365710a12.2
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763426673; x=1764031473; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Rw6N3DfQLTWZubv1tCO5tCu5Q2UsmjpxOpe9crG0Mk=;
        b=VM8t5+0wcW3Ogwm23aljAG7g4wbUBToPbKB5hnqRCynU5cCgi6naduy6yAaqpv/L8p
         3bteYhqQtlyoGF44llvpX3etcb36Yso50SF5KpQIvuAG/jyM/pj/4v5eD642aOALUX0k
         W00t8+GIz9RrfGOPlYX8fvRSqW5pF0gEyiqvE09v9v61XaOEjovYuZM1lrDJvjOXQIGZ
         2Czfbhz/whQXfo+WQXVtf5PliuvEOpT5FIbbwMBTsa501o+uWsl8dtiZnKrLT2zbeG/N
         IQYBNxMmjSkPanelFfo8mYn3ootHGuX3hlH5Z/s/ShbtWclRR3Fk5VZ9Bw0kSCnqgP0q
         YfPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763426673; x=1764031473;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Rw6N3DfQLTWZubv1tCO5tCu5Q2UsmjpxOpe9crG0Mk=;
        b=aboDuDVjmRbIWiIgKnnAhTcbxLPMJ65jZVbnjOX1dLH9/L5jrAVGFHMFwBrIw8Mfn0
         JVd9aZDz09CFfBwep082sLWTvwEljGs99HJXmt1xQnso3ePWrAQDo1mOR6kIvLD0B9JP
         z4rDXphZTS6klaMX6wCyN4L3BT7iX4KkEo9YcRdMbJDVRO1+/f8kxHAnQGhbjz9NBqfD
         dZCBssGwk77yHi/V2tCmwe1bhXzTNh5am77Nq6tZJ88txYSeNVy7Lx1Gm/ammN74/RD4
         O9PRA6tPhFPzMzdNCZIf5ME0LKVvTLBF7vBxac+WBlKNmInK8g9BE8xlPq2a2N5JZ66u
         MMSA==
X-Forwarded-Encrypted: i=1; AJvYcCX//AMGtO2lfbUWNtYeEpWnJNSyOk8wLk6ahNzYNF9bAwN6qbiugc7Zbal3N0n/9fDvZ2Z00TrKYA==@kvack.org
X-Gm-Message-State: AOJu0Yw6p9Emx6GF7msbpjteDbwMXXCCOA9z6FHXs3SXfzJ4jL87peZJ
	AW8WqaBJzqJdtpvXaXqCbmZuh35J04AtzOxTinA4B5Hs7c6B4PLoSwqT
X-Gm-Gg: ASbGncuULuaQZ05X0XOc6UMLm/38RiXL3xL4M/144wAlvbXnsJwzk+9bJ+xOAoKVS1i
	4NqKDwwWYYT/1DGbSlw+2ERCNBflj0ysEZQAsjf1UNBNHwzgVh5sKO952LmIYDao+H1hZgUVp1T
	upfxLsxTKt4CxR5TgYtGUxrQoBAK6VYNWYw8hr9kqjkkknHzwslq1IMY639FzpXGbw5JeEQzkBn
	aWTPswE4pwRX6m1K98LJ/ujug7AtRwAkiiITvoNqGEBRCLgn+xVsvcr1v9EII57/7zLbIrIpFOh
	ZgtaFRLeUvza//kKUliYflUVypm0os8zM6d4W5h98f7CxRVHXYGSWMgLfEtksxf8D9zApJr4gip
	WeX8RkqS+GNwModufXXKx0+eDZGptsTkPuUvGBHh4g59qCTnVpqF7yvrRUVGICcTyWFwktVtcQe
	abGMvYQjiLEinmFxQ0lwwXSHXFBZxnliDFWurGOawTcxPzth2gchXPuPsu3yfHxUsn
X-Google-Smtp-Source: AGHT+IEekRbfTH74TjieJsque9jyjHlXoUp37pzLLs9wNbsnzKJwOhoYGxIwMI9SmC+dj3O50BjpBA==
X-Received: by 2002:a05:7301:4381:b0:2a4:3592:cf6a with SMTP id 5a478bee46e88-2a4ab87fc86mr4252416eec.14.1763426672717;
        Mon, 17 Nov 2025 16:44:32 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a49db4a36asm39962611eec.5.2025.11.17.16.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 16:44:31 -0800 (PST)
Date: Mon, 17 Nov 2025 16:44:29 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: kernel test robot <oliver.sang@intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH 1/4] mm: Use frozen pages for page tables
Message-ID: <aRvBbYmCz-jkIzo1@fedora>
References: <20251113140448.1814860-2-willy@infradead.org>
 <202511172257.ffd96dab-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202511172257.ffd96dab-lkp@intel.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0C924C000B
X-Stat-Signature: mgyqjpju4tdtdj6dxsyw1rjafdg4n4qg
X-Rspam-User: 
X-HE-Tag: 1763426673-541787
X-HE-Meta: U2FsdGVkX19h/ATQx3TT1frQpv+TTMBmwQyah0Q7COFW4heOnHvxijefwLAPeA1uCMqwfTLXRKyY81Ty1uKlxWwm/66XcvL9CwU6umTAFiGFriHaallmOqDwyGHiOOULJNqMKUd7CqjKW4BjvasBtCcVqynJQRQtEPASM2bGSzUxv88OfJI1POBNltdrHv/m8L2A9FB8xxwT8iL2LjvcCRsRYPY+yNncNTOcJC2PnqaUEbdzAgGHf68gHp2fqD44OxAuyTEi8G/Q5KyR8axpZr9CwLRjmq7tbCSNBzF5cgnrH0K7SGGDwd4lRD0g4m/F1GBe1mDHFavI7udrbdtqGJEBoq/R3dbsGpGXX4yvXUO7Vumc+FtIcIC5TFYnXzPHRyQuhCQtvqjjeYjI0pk5hWTlgrdAt19HQIVGTC10CCtDcXU6zyklPDo4MwIU9oW+pLUZ3G20DNtmK/+ZpGzjbEc8XBKno+QIMyAvDJdN3PmnKx8ixP+wE2x734Xgv8UnYZKe16NofweMAwxgHed1fK8PbSNCv2s2ZYj58p+BLe8/ZH4Wwi/lDpmFbFKH8YMA24wx0oouuymnyZ5fymurnlkhJK0ksEmbeWf0o/AIhsDVRbZCALs8oqaDyfRX90xBr+kTnbBNjk9IRkaFK3Ex8mSpccYHe+CYgw/JvIdv5J6pjSFtEInLIL/1O2SefFaOhZDPUNMQt4XxUMCwx4P4VFO5Nfm07nvD4OLTz0iTicmddy9/l+e3h7ElZZaSC/O2U7RFiiJPG4u3BTNxm1Q3oUmeo/JltZqW7uk960r55pyLeArNQAiVoAmVDjDr8+CRV9qFdyKCbq4h2Z5TCSwRSxybXeMpkc3cjQ4sfc1cWE+BXD/72zIVrJf372q7DE7vhfxyxLVsX5FBIvBva7o6G7QYV7KK2kPgGYPbgN4tE9NGn7eNOwdPj02WV1zGb7JndsJxX6lDReLQHMGFi+S
 rLQ+X32w
 xwEi1yXU3jiy21jnJNmthHVyURQumRF69YhxB7A2U7uK4EmaBKif6KGRnrv+m7PBpfYI1b8yz2z7GFiP0e8C43YgrkXBrGyosk+kOMHBtS+qhCGHYz3w4Dch9YDlUCLBsVpY/PDampPuU6VZzr3TJDEfq+alAbhU+QwLqGvSMx9fQO05cnup+x5jH3HZjJNXOIoEE7ajvpQ2o7CopXzlIFXNqocSvJof3CuI/mQgZ4W9/hk18os+H1ixDVwYSxS7H9QUn3Au7jkQGbGc6StR0drQNX2jQofIpqSI5CYfwypU7vCEREXQpA/P/gmw8ON6vCAcUKxJ6/lcnrL8le1COhI6Waf9iUrUjW6IvH6jPFAiFrkHFFfHEuIwzfcwi7p2TcAdTWnDkTjpbC9KMDC5804sTCcDNE4wzVkw0gienIIqEAY4TtKeiCZAbxtm7ec7hj12ueFtNC7Wcl1nUnJU5hhG/RHr67Nb+PMPVG4Hg3vTmK50CDrGIqu3EjKpJ2A9TJXyfJp/y8geiiFF82lYhy3NO61xS/qO6dfElVPaRsCD6T383Iz9R7Qm0Jw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 10:38:09PM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed "BUG:Bad_page_state_in_process" on:
> 
> commit: ffb870b766822062b6c71211c80342c85a7ffcd8 ("[PATCH 1/4] mm: Use frozen pages for page tables")
> url: https://github.com/intel-lab-lkp/linux/commits/Matthew-Wilcox-Oracle/mm-Use-frozen-pages-for-page-tables/20251113-222907
> base: https://git.kernel.org/cgit/linux/kernel/git/akpm/mm.git mm-everything
> patch link: https://lore.kernel.org/all/20251113140448.1814860-2-willy@infradead.org/
> patch subject: [PATCH 1/4] mm: Use frozen pages for page tables
> 
> in testcase: rcutorture
> version: 
> with following parameters:
> 
> 	runtime: 300s
> 	test: cpuhotplug
> 	torture_type: trivial
> 
> 
> 
> config: x86_64-randconfig-101-20251114
> compiler: clang-20
> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202511172257.ffd96dab-lkp@intel.com
> 
> 
> [   19.289760][  T422] BUG: Bad page state in process modprobe  pfn:1618b2
> [   19.290414][  T422] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1618b2
> [   19.291313][  T422] flags: 0x8000000000000000(zone=2)
> [   19.291714][  T422] raw: 8000000000000000 dead000000000100 dead000000000122 0000000000000000
> [   19.292382][  T422] raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
> [   19.293020][  T422] page dumped because: nonzero _refcount
> [   19.293444][  T422] Modules linked in:
> [   19.293804][  T422] CPU: 0 UID: 0 PID: 422 Comm: modprobe Not tainted 6.18.0-rc5-00422-gffb870b76682 #1 PREEMPT(none)  65c9d11eede624b36533d4efe2c3c7798fc76b60
> [   19.293811][  T422] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [   19.293814][  T422] Call Trace:
> [   19.293817][  T422]  <TASK>
> [   19.293820][  T422]  dump_stack_lvl (lib/dump_stack.c:123)
> [   19.293834][  T422]  ? show_regs_print_info (lib/dump_stack.c:104)
> [   19.293842][  T422]  ? smp_call_function_many (kernel/smp.c:784)
> [   19.293847][  T422]  ? find_held_lock (kernel/locking/lockdep.c:5350)
> [   19.293854][  T422]  bad_page (mm/page_alloc.c:?)
> [   19.293860][  T422]  __free_frozen_pages (mm/page_alloc.c:?)
> [   19.293870][  T422]  change_page_attr_set_clr (include/linux/list.h:372)
> [   19.293878][  T422]  ? __set_memory_prot (arch/x86/mm/pat/set_memory.c:2041)
> [   19.293884][  T422]  ? __set_memory_prot (arch/x86/mm/pat/set_memory.c:2041)
> [   19.293889][  T422]  ? trace_contention_end (include/trace/events/lock.h:122)
> [   19.293897][  T422]  ? do_raw_spin_lock (arch/x86/include/asm/atomic.h:107)
> [   19.293904][  T422]  set_memory_rox (arch/x86/mm/pat/set_memory.c:2327)
> [   19.293910][  T422]  ? set_memory_nx (arch/x86/mm/pat/set_memory.c:2123 arch/x86/mm/pat/set_memory.c:2312)
> [   19.293915][  T422]  ? set_memory_ro (arch/x86/mm/pat/set_memory.c:2321)
> [   19.293921][  T422]  ? _raw_spin_unlock (arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:186)
> [   19.293929][  T422]  ? find_vmap_area (mm/vmalloc.c:2507)
> [   19.293935][  T422]  module_enable_text_rox (kernel/module/strict_rwx.c:40)
> [   19.293943][  T422]  complete_formation (kernel/module/main.c:3258)
> [   19.293952][  T422]  ? post_relocation (kernel/module/main.c:3237)
> [   19.293959][  T422]  ? init_build_id (kernel/module/kallsyms.c:?)
> [   19.293967][  T422]  load_module (kernel/module/main.c:3468)
> [   19.293979][  T422]  __se_sys_finit_module (kernel/module/main.c:? kernel/module/main.c:3713 kernel/module/main.c:3739 kernel/module/main.c:3723)
> [   19.293987][  T422]  ? __x64_sys_finit_module (kernel/module/main.c:3723)
> [   19.293998][  T422]  ? exc_page_fault (arch/x86/mm/fault.c:?)
> [   19.294007][  T422]  ? __ia32_sys_write (fs/read_write.c:754)
> [   19.294015][  T422]  ? do_sys_open (fs/open.c:1452)
> [   19.294022][  T422]  ? entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
> [   19.294026][  T422]  do_syscall_64 (arch/x86/entry/syscall_64.c:?)
> [   19.294034][  T422]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
> [   19.294038][  T422] RIP: 0033:0x7f8d36fda779
> [   19.294042][  T422] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 4f 86 0d 00 f7 d8 64 89 01 48
> All code
> ========
>    0:	ff c3                	inc    %ebx
>    2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
>    9:	00 00 00 
>    c:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
>   11:	48 89 f8             	mov    %rdi,%rax
>   14:	48 89 f7             	mov    %rsi,%rdi
>   17:	48 89 d6             	mov    %rdx,%rsi
>   1a:	48 89 ca             	mov    %rcx,%rdx
>   1d:	4d 89 c2             	mov    %r8,%r10
>   20:	4d 89 c8             	mov    %r9,%r8
>   23:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
>   28:	0f 05                	syscall
>   2a:*	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax		<-- trapping instruction
>   30:	73 01                	jae    0x33
>   32:	c3                   	ret
>   33:	48 8b 0d 4f 86 0d 00 	mov    0xd864f(%rip),%rcx        # 0xd8689
>   3a:	f7 d8                	neg    %eax
>   3c:	64 89 01             	mov    %eax,%fs:(%rcx)
>   3f:	48                   	rex.W
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax
>    6:	73 01                	jae    0x9
>    8:	c3                   	ret
>    9:	48 8b 0d 4f 86 0d 00 	mov    0xd864f(%rip),%rcx        # 0xd865f
>   10:	f7 d8                	neg    %eax
>   12:	64 89 01             	mov    %eax,%fs:(%rcx)
>   15:	48                   	rex.W
> [   19.294046][  T422] RSP: 002b:00007ffe07ac3298 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
> [   19.294051][  T422] RAX: ffffffffffffffda RBX: 000055b5fb23ae30 RCX: 00007f8d36fda779
> [   19.294054][  T422] RDX: 0000000000000000 RSI: 000055b5e55e332b RDI: 0000000000000004
> [   19.294056][  T422] RBP: 0000000000000000 R08: 0000000000000000 R09: 000055b5fb23c020
> [   19.294059][  T422] R10: 0000000000000000 R11: 0000000000000246 R12: 000055b5e55e332b
> [   19.294061][  T422] R13: 0000000000040000 R14: 000055b5fb23ade0 R15: 0000000000000000
> [   19.294069][  T422]  </TASK>
> [   19.294071][  T422] Disabling lock debugging due to kernel taint
> [   19.373082][  T422] BUG: Bad page state in process modprobe  pfn:163532
> [   19.373680][  T422] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x163532
> [   19.374387][  T422] flags: 0x8000000000000000(zone=2)
> [   19.374795][  T422] raw: 8000000000000000 dead000000000100 dead000000000122 0000000000000000
> [   19.375424][  T422] raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
> [   19.376107][  T422] page dumped because: nonzero _refcount
> [   19.376525][  T422] Modules linked in: torture
> [   19.376917][  T422] CPU: 0 UID: 0 PID: 422 Comm: modprobe Tainted: G    B               6.18.0-rc5-00422-gffb870b76682 #1 PREEMPT(none)  65c9d11eede624b36533d4efe2c3c7798fc76b60
> [   19.376925][  T422] Tainted: [B]=BAD_PAGE
> [   19.376927][  T422] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [   19.376930][  T422] Call Trace:
> [   19.376933][  T422]  <TASK>
> [   19.376936][  T422]  dump_stack_lvl (lib/dump_stack.c:123)
> [   19.376946][  T422]  ? show_regs_print_info (lib/dump_stack.c:104)
> [   19.376952][  T422]  ? smp_call_function_many (kernel/smp.c:784)
> [   19.376959][  T422]  bad_page (mm/page_alloc.c:?)
> [   19.376964][  T422]  __free_frozen_pages (mm/page_alloc.c:?)
> [   19.376972][  T422]  change_page_attr_set_clr (include/linux/list.h:372)
> [   19.376979][  T422]  ? __set_memory_prot (arch/x86/mm/pat/set_memory.c:2041)
> [   19.376984][  T422]  ? __set_memory_prot (arch/x86/mm/pat/set_memory.c:2041)
> [   19.376989][  T422]  ? trace_contention_end (include/trace/events/lock.h:122)
> [   19.376995][  T422]  ? do_raw_spin_lock (arch/x86/include/asm/atomic.h:107)
> [   19.377001][  T422]  set_memory_rox (arch/x86/mm/pat/set_memory.c:2327)
> [   19.377006][  T422]  ? set_memory_nx (arch/x86/mm/pat/set_memory.c:2123 arch/x86/mm/pat/set_memory.c:2312)
> [   19.377010][  T422]  ? set_memory_ro (arch/x86/mm/pat/set_memory.c:2321)
> [   19.377016][  T422]  ? _raw_spin_unlock (arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:186)
> [   19.377023][  T422]  ? find_vmap_area (mm/vmalloc.c:2507)
> [   19.377028][  T422]  module_enable_text_rox (kernel/module/strict_rwx.c:40)
> [   19.377036][  T422]  complete_formation (kernel/module/main.c:3258)
> [   19.377042][  T422]  ? __might_fault (mm/memory.c:7142)
> [   19.377046][  T422]  ? post_relocation (kernel/module/main.c:3237)
> [   19.377051][  T422]  ? __might_fault (mm/memory.c:7142)
> [   19.377054][  T422]  ? init_build_id (kernel/module/kallsyms.c:?)
> [   19.377061][  T422]  load_module (kernel/module/main.c:3468)
> [   19.377069][  T422]  __se_sys_finit_module (kernel/module/main.c:? kernel/module/main.c:3713 kernel/module/main.c:3739 kernel/module/main.c:3723)
> [   19.377074][  T422]  ? __x64_sys_finit_module (kernel/module/main.c:3723)
> [   19.377081][  T422]  ? do_sys_openat2 (fs/open.c:1447)
> [   19.377089][  T422]  ? __ia32_sys_write (fs/read_write.c:754)
> [   19.377095][  T422]  ? do_sys_open (fs/open.c:1452)
> [   19.377100][  T422]  ? entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
> [   19.377104][  T422]  do_syscall_64 (arch/x86/entry/syscall_64.c:?)
> [   19.377111][  T422]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
> [   19.377115][  T422] RIP: 0033:0x7f8d36fda779
> [   19.377120][  T422] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 4f 86 0d 00 f7 d8 64 89 01 48

This is not a problem with this patch. It's actually a symptom of commit
bf9e4e30f3538 ("x86/mm: use pagetable_free()"). We're freeing ptdescs
that haven't been allocated from the ptdesc allocator - aka
pagetable_alloc().

