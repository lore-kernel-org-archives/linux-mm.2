Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DBF8CA100B
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 17:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D21B48E0024; Tue,  2 Sep 2025 13:01:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD12B8E0001; Tue,  2 Sep 2025 13:01:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B99328E0024; Tue,  2 Sep 2025 13:01:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A3F8D8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:01:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4931458269
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:01:46 +0000 (UTC)
X-FDA: 83844927012.28.8AAD33F
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 47019140014
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:01:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JsyD0J+3;
	spf=pass (imf23.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756832504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gr4dtH+6wLw/9TmFABy0WOLeS+YAxNvGpmwDvxx0NyI=;
	b=vNXVVdxqs4XawVKDW9r9Pfov1Hp67PWWXupIW1pcyJS5JhoimMZQif02khYvl3tjdga9wk
	eZcIIJcQBNGuBLkosTzchFx96+Gh437zuYwASqfz+wM3iHSFnWMTJML5NTAtuuLN8jhEqY
	5WM5VcOu1PqNX/v3W7v90ww7lylM9kc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JsyD0J+3;
	spf=pass (imf23.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756832504; a=rsa-sha256;
	cv=none;
	b=VZcSNG2xG/En3AoXgQG7Qr76IpdicA86DC4pG5224FEHLkGx3lc5XWct//kv7Y+2a8rs4j
	48Shsw/1UjAfEUqoPu+LAXlx9t88dSPM9bG6rnx6R5gimy9ssPN3L4C6TQBRV4JUWWcwOt
	kt3rx85+pdWw4I2dqwHq25ja/8oaeWM=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-76e4f2e4c40so4660741b3a.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 10:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756832503; x=1757437303; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gr4dtH+6wLw/9TmFABy0WOLeS+YAxNvGpmwDvxx0NyI=;
        b=JsyD0J+3ELvObJe/l0PA7wgGJEdLwet/RqbtwfI9E0nYgr7jlUG9M3pm3v9X+gELjQ
         NJsJwRdjNia8IlTKcNx7XVkqH/+D9McAW0UZY+x+3DP1wkRsHeKc/p7FwAt/wSEms3n+
         ywiiIAs6grpBr7zpweQgdG9rZPx4SWFwqv7jJVDx3/gNmNejj5qFUy3XrIq1ltzCwGre
         1seuVUtBIfi0e58Dmz1bq/R1YadCY6XjIsBZfsll5s3ZjOHmli4dHzL0Tc66MgTtKy7z
         vWC99KhKPwWTfVke+viGn2rH36Qw5+AKJ0u4u2Pbfmki8eksnfTy8g8GMzQWglu1YrjR
         nJaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756832503; x=1757437303;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gr4dtH+6wLw/9TmFABy0WOLeS+YAxNvGpmwDvxx0NyI=;
        b=TIBOe0Fy74Ib4bd/L6Ic835bBKvyXfMCsx/TPGohTu6F0nGKDyBF7rvJAnrqT9ZVwk
         YlYvgwhj9Plcx90wwiGcKiDK7dCxDT6Y3z00Fcxv2UJ58ggYf/v2nqOzLHxSzOHK2w+r
         6FJWYOLPyoG6vO4L0pBNZ91Brufs5XleDsmD+ePUrCdvCwLAiy83LqD0qYmNhLqJdIKC
         wpOpjFQVlLt2QTq/Kp3gt+UsfkAbYtCq3rm3KRDgC4Vus66yNyVgw7Gd6UJ/Rd2/ouWH
         OnwgAEDScAtsHOWam/vrHs16f2F+YF6QO6Sqx+bZxgW+XdVCT3rIeCZ0qKeAj6yEmdR0
         LWgA==
X-Forwarded-Encrypted: i=1; AJvYcCVB5CG4zhcxKDkPv5a+v2be2C+C5it7nIDMQ91DShJrGjVt9NP0gDXcw/YlLQcKE7nUB+Np9CWj+g==@kvack.org
X-Gm-Message-State: AOJu0YxSZ4HLXSRtBWmqOx7T4ipOdMVs+UMg1jemjfo/594nbS0mI/e3
	TLvrZSK3yp3TT92p3k7nIKOcsXDTp23dxgKWvZcKmVr+p+BLJQ+qkDSp
X-Gm-Gg: ASbGncvQQoVRHUDSBmo4Nzyw0CzJAbVo6isNsuuCQLlDe6Li9OdfUHD4+2N0W0tgf3v
	VW2q+9Zjpp3T9ZrieLMrJJMsUhqeWiuDJI2BVP6zthI70MnxrqFTC1x8hSAtcr/2go6kUR7sIn3
	EUtMownAfaJJxhrN4o2qzxtayLS/MUHK5naVebiZrkvLQILDBjTIzWi5+kVUF2UFzCBCLiN30II
	MJZKBcqu1yowzMpPU/YvRGwK1YkNdMlL6iyNuXKdsgBqivPioOymsY6kFx38udr5HVXGgGs39Kk
	4FTsmgDjui4xlSWbdsUqKFTgedaLsnEFvktvisi7rmjM6XHdNpEr+ZvJvx5OTDE8LXTCT78yCG+
	5pVXFA8j5xRDuSPZ4WTcg6xsax2zzlBBvA33QXXyCjHNXGXowjgubEg==
X-Google-Smtp-Source: AGHT+IHAqr9Rp7SVP8poB9eOiwc3M4jdskDGajj5qU9Zr/pStUC9iKTqRvLJFvomPILr/qg3w8tRVg==
X-Received: by 2002:a05:6a00:1495:b0:771:f951:16c6 with SMTP id d2e1a72fcca58-7723e308bbbmr15873113b3a.15.1756832502675;
        Tue, 02 Sep 2025 10:01:42 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bd1ccsm13897224b3a.47.2025.09.02.10.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 10:01:41 -0700 (PDT)
Date: Tue, 2 Sep 2025 10:01:39 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev, lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [linux-next:master 4756/5283] kernel/fork.c:457
 account_kernel_stack() warn: we never enter this loop
Message-ID: <aLci857GmuP2tMV9@fedora>
References: <202508300929.TrRovUMu-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202508300929.TrRovUMu-lkp@intel.com>
X-Rspamd-Queue-Id: 47019140014
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ghfayaogmrpans645wieht33pd5mkamd
X-HE-Tag: 1756832504-730542
X-HE-Meta: U2FsdGVkX1+VopurcflqZhLCMNT27ir2F5mt/F+r4M8farKCiCsUP/6QyWfDdsp6dgv2qmacO1nTDczfv2pv5GBNqme2DdNb2rhrvJ1SOglhy0br6wzL8/miYeqkqkfvLDrpHWmsU5t5ZFvjFp8QaVTO5rtAE1oygqUKjpDM72ndZT6LNzLX550O69aUtyQjZRfTmmwKbxNIqjHUmhZhTCJI75c7lm/NyqmJwRK/jwDgdDV4Yfk215S1Tduty4WHQdsSUbK3HjEqgqfCj++9ol85TNN8c0rn2fhDew3Bx4XwIE2VEusxKgtgIN/WyrfrmZtryK/DApNfOkZLJHtIZi5hbT2hqjevJ0XHNGDr/zUWKx8PugFbRRYV0KoCqJSByWQi2y6HPZLK53tGspPafofrfp/3QoSOK0bdtqgNMXXQ7S/NgmL4L54tCrN9hlTj2kcFOaPOsqtX//FsJ6GK5yudEksNhD5VoVPVKGtaJvLnIU/PiySd9Ov+eJ/URpPgQ4MCNM1jgO0UStrC24kkhPBpzKOCMhW0Wh8h8MPbx8Sbdngd3hesUeVPitj0m0/lkn4hXMHhk5ZIkcXoijVUoi+gNuX5/qwy5XTK/Ai4YtCUMntf7I3jaBooPDcrRvZtPwRVPelASEMLQuD1oLHY+HA349sRQlGjPT51RLyu3wARUfrScd/fE8L3MMNL1v+uXEkUxyjg5KbdeDYpqsi9yhvjyDULlqaL78I1ysiIFR/WSpkTZMyt1NxrIcMZTsbRk5U7u5obhG1RGLZxqFbTw6w2BeHbUoKl0m4xyRmFB5+/wO6bLwWqomepdFT69BuBGGnO8BUQHrwSptVQ9D0lPXwslfHDfADpuV+iBAry7W0VYsBSioiD+Hw+PE/ZDD2Z3Nu3woaJQ8XSIHDSSxzp7aV9KrN5YEJ9IncG32tv+I9l3coS4vcPGS34VS2W7T7mJ/nuwraXWAsYpIkUkNu
 oWQXP0O9
 oCsktJTWcT+FQENui+jODsh+zRgALDtBMJdluowxjlpAqflQxbSXyDt34I3DRPu9T+C39Ladbvqk49ujb1uEwl4WwX5vFjwUo0zoBebS7UKrJBxC0t/3fg4YY/RM0e6RosErRIARVBKjEgv0qHtlvLNN1gNO+77o/x4dFebXqXQ7qFn3H+WUob2hVG5c0gxcgaLJyqIK2ho5iRHe4OFgFYGwDETaOMMtT4klIuxatv78OwSgFyRax8OkMa73SOLJGEqnjG2BGh5LGC+CLPJEa5pYMe/uuMuGj6TV1c5Fy8kDyKSHTnszrIpPqATY94Gh0S1ZXsOkynnupfnJQ5IN1k8+yHWNarx+zUFlpWbWA1slUDNXFpgFWKmMVht4Lhq6lAX65Q2CISGrbX6KPounP1SX1w6yXVdyKOifmEQzQgkRi6dOinFMj3pyh8DZMn7CodBhdLz4CymNGZda9zYktYR0ngWnzvDIF7VZvSeFqrxiKC2Pw5URWPi05iiv6eLJyqxyrFjaJZGKKs0cl77nIRoE7ok3sOkmjopwiT0gmZIEO/tmTuLrXDImPF2R0G6VVDAVO6bpxpimb8N7ALoC0hqewgs8aC50HlKv99xiEy4N2Id1wyeBE784lEHK9YLxpSS4sEpgwevsEvcpBZ7kyBi8nWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 01:56:05PM +0300, Dan Carpenter wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   3cace99d63192a7250461b058279a42d91075d0c
> commit: e0aa7237ef4323a66ed06953225d9b07cf039530 [4756/5283] mm: tag kernel stack pages
> config: hexagon-randconfig-r072-20250829 (https://download.01.org/0day-ci/archive/20250830/202508300929.TrRovUMu-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202508300929.TrRovUMu-lkp@intel.com/
> 
> smatch warnings:
> kernel/fork.c:457 account_kernel_stack() warn: we never enter this loop
> kernel/fork.c:457 account_kernel_stack() warn: unsigned 'i' is never less than zero.
> kernel/fork.c:479 exit_task_stack_account() warn: we never enter this loop
> kernel/fork.c:479 exit_task_stack_account() warn: unsigned 'i' is never less than zero.

Thanks for catching this!

> vim +457 kernel/fork.c
> 
> ba14a194a434cc Andy Lutomirski           2016-08-11  437  static void account_kernel_stack(struct task_struct *tsk, int account)
> c6a7f5728a1db4 KOSAKI Motohiro           2009-09-21  438  {
> 0ce055f85335e4 Sebastian Andrzej Siewior 2022-02-17  439  	if (IS_ENABLED(CONFIG_VMAP_STACK)) {
> 449e0b4ed5a16c Pasha Tatashin            2025-05-09  440  		struct vm_struct *vm_area = task_stack_vm_area(tsk);
> 27faca83a7e955 Muchun Song               2021-04-29  441  		int i;
> efdc94907977d2 Andy Lutomirski           2016-07-28  442  
> e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  443) 		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
> 449e0b4ed5a16c Pasha Tatashin            2025-05-09  444  			mod_lruvec_page_state(vm_area->pages[i], NR_KERNEL_STACK_KB,
> 27faca83a7e955 Muchun Song               2021-04-29  445  					      account * (PAGE_SIZE / 1024));
> e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  446) 			__SetPageStack(vm_area->pages[i]);
> e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  447) 		}
> 27faca83a7e955 Muchun Song               2021-04-29  448  	} else {
> 0ce055f85335e4 Sebastian Andrzej Siewior 2022-02-17  449  		void *stack = task_stack_page(tsk);
> e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  450) 		struct page *page = virt_to_head_page(stack);
> e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  451) 		int i;
> 0ce055f85335e4 Sebastian Andrzej Siewior 2022-02-17  452  
> 991e7673859ed4 Shakeel Butt              2020-08-06  453  		/* All stack pages are in the same node. */
> da3ceeff923e3b Muchun Song               2020-12-14  454  		mod_lruvec_kmem_state(stack, NR_KERNEL_STACK_KB,
> efdc94907977d2 Andy Lutomirski           2016-07-28  455  				      account * (THREAD_SIZE / 1024));
> e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  456) 
> e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20 @457) 		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++, page++)
> e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  458) 			__SetPageStack(page);
> 
> Apparently in the linked config the THREAD_SIZE / PAGE_SIZE is zero.
> Is this the expected behavior?  I don't know mm enough to say the
> answer...

THREAD_SIZE and PAGE_SIZE are very architecture dependent. This behavior
is expected in some configs. This can't happen in the VMAP_STACK case,
only !VMAP_STACK, so looks like my patch is wrong in handling that case.
I'll send a fix shortly.

