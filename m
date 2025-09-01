Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0177BCA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 10:56:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A6B08E0023; Mon,  1 Sep 2025 06:56:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 557298E000B; Mon,  1 Sep 2025 06:56:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46D7B8E0023; Mon,  1 Sep 2025 06:56:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3383C8E000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:56:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B6C1BB7A4
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:56:13 +0000 (UTC)
X-FDA: 83840377026.19.07FE9DA
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 706F84000D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:56:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=EsB4lakP;
	spf=pass (imf17.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.221.50 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756724171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=s51XmWZJp5DHxpHOLeJmnLNp4ozg3yH12eVI2vl1w5Y=;
	b=NbSzAZDjEEEELsMgAsnrDJ10euj0hFu+eED47BXZhRoVXeF00rPW+VpPictK57RvV5djX2
	8GsI7J0YStMHQ4vN5P8eT3Pc/dOzvZ/Fl5HJ9Qa5X8y4WmnwrIfJyfNVT2EJP5/VcgkPGA
	76lIZhRYz7ZLjXMz5Og9xFv7hKmZwXQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=EsB4lakP;
	spf=pass (imf17.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.221.50 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756724171; a=rsa-sha256;
	cv=none;
	b=TJ4sAQyscpPV+Pg6fsdSqRQrlfzYMdQgG8fqI/LcqhfXM89tUDPbVV51mT7mBAea2eq1rF
	tC7NFXlWXB/0GIPL+LrA2Om4hCnKz07gZm7gjUAtHQ4defVfNVHCAEygaNvwgvqs+N7ZHy
	HkFccf16PUoqoobtn1iZqPj6FLrKFsg=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3d17731ac0fso1991281f8f.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 03:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756724170; x=1757328970; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s51XmWZJp5DHxpHOLeJmnLNp4ozg3yH12eVI2vl1w5Y=;
        b=EsB4lakPm7eFFVTx8omTJGxEOOeb5/WNXeSkbK5nsSTy+X/ayCCKwTH+vf8lNxgyUW
         /tzCXvLG4NEvcPdUGmgBObofLIjk9N15fhJyILiQHbZFV5WpxqI3oLbyQC7Yv+O4znGx
         zRvoNAKEZw5glFDC6NZQ14CQg21CN2ptfZPdp8fsBjC79jZWqlMU7CyiSoG/up40Zwae
         S2lRuNvA4bAbdSqhefyLfsDGFaDqETcYigwXRlss5Xk0OSjc9n41TISdimBUews+xnwq
         y6bmTAO6v4MRllc1Y3fwYayPVBkuLaERz3mdjLgOtb5JLctnwZenvPi50/uv3K9TD53I
         d90Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756724170; x=1757328970;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s51XmWZJp5DHxpHOLeJmnLNp4ozg3yH12eVI2vl1w5Y=;
        b=sUFivA25AxWxD5vBUr3GLw6RYYr9Nodeox8MZWGlARocYlzO+fryV4+Z88tPw0B8In
         zuVXpfsGGajGQ5HE/ANOGKlLLJ0bCBraLjtFZn0Wm9nYdo7XpDxxeRNWysfZ+I5OgVWp
         JtKb3+C3qfeA1Knd8KJ35guCaD1yRLpMELGPkOAT7VStA5boWvl/3Y+NUNYXU0U21SQ6
         xgkwKOfnHc4E3YWPetmKMvKosOHz8UO5dCKgTh9L3T2RLz1lZaQBNHe4y6rTW5lr+3aY
         OTsIEOF/Lr83vYH2u6a+yPnuNnh90DgaE7u5XtGlVUAfZGcxrM6Az2MEqjB38+li3z3u
         NZaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEEvADQ3r1Yos5qcx0mUsx+LfWKlNPvfY+F2INhKIdWNoyrVF2KPPjYJfV9bj2QD40Cx6djG6fNQ==@kvack.org
X-Gm-Message-State: AOJu0YxIzxzHZGehOuWRbQvp+KW7rwr8lEFY2an1FT01Iq9cRIi/0sNn
	4BfCRG2guw5MDDRqPsl0MwGsXi6w/wmXmtWbErSgTK6a/Tnfz5roNDDoexpI0q3eUIQ=
X-Gm-Gg: ASbGnctCzubyDacf+tdh5PUMZs2wNrF4Z5x3agxzY7V0MdQUtZ5Y1ReXY22aJs9pYU6
	XNmmcEzjYuvoTBStpwSUlYBeaqSGv0SAL+nduLeXny4sQhFGWXs1Fx4eqGON3oyJtvhPfVWRPa4
	hWCMtWFrVG6Ij+vy5eD8BK2PqyuDb2hImVVygtoMZ+MA4yANgDv2yUBvpss4ikKRSAVEyKjyKuo
	EpsS/wZXXadPD3yDBWMFhcCPezGFVPZUqXej/AG41RpO97Wv3rOKDvYZEXynAybDUK7is//8oIZ
	AT41B4Qyg2L0G4P/i4jhJYzfaWc6y4aW3xaOpsejFio6Trs78G6RK3bXwG7HQ4LifB2Fb9eX0Pu
	gcJ8Vlxg2Ub2OXEAy6DWIdb08pm4fb9oH3JHu1A==
X-Google-Smtp-Source: AGHT+IFiaIyiVHKBvWcuJ7j9OGQvV5jS+bUEoZBiN7Wnh2kb+IM8kDKm5zixCaYx5Z385dGIbHqAEA==
X-Received: by 2002:a05:6000:26c6:b0:3c9:fc3c:3aa3 with SMTP id ffacd0b85a97d-3d1dfc07101mr7147467f8f.40.1756724169658;
        Mon, 01 Sep 2025 03:56:09 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3d3a7492001sm8737165f8f.42.2025.09.01.03.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 03:56:09 -0700 (PDT)
Date: Mon, 1 Sep 2025 13:56:05 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 4756/5283] kernel/fork.c:457
 account_kernel_stack() warn: we never enter this loop
Message-ID: <202508300929.TrRovUMu-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 706F84000D
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: n6mg8ze8gd7z59oszb5qqghj54wih3ko
X-HE-Tag: 1756724171-765756
X-HE-Meta: U2FsdGVkX1/qKVydHLt/1YQQd5Gyl6vEjdNrE730soSoVIZ2p3voS3wV8ssFmbTlwtYjDDR0PhPb5u3d/A/61Ku33QgiRjdc64NVsmOO6L32pe368tBRml6gH3oOBdPj7oWFDv2GdX5h0JsFjsqVCZhjsTnlwGp1MMBw4w3LjKogDqwmpZ1d/BCA9H0D0gGINa5TuNBtGV2jCkTl7ZALF2ezb1QwiJz4lNLMJpz6TkUrWB0MgLgqkQuCfrOaS6QQBOBBExdbVCOUjaCY3omSuO5g0uYRKz1dIb9uBH6DePoDX1KaAsJbFH+9zWizW+NmF6lGE30IVUAbdi6qoyHLdXiU/qbpTZCG6ur/Dh00ZhJyx/bOSA5AB3m5sYixlEyhE6bGlRrvi/fj9/MwW9gl9P8aY3LrcWZXSkSyY2X9T4bHA9ib527994/gyrhNG9K0rL6TBdmORcy3Ioo4LWViQIvSYsR0sO3gAK499yMOokts1PX+8Drnsx8tEqzMuSOGhoELnY/Cl0tnvRYO0Vb4MDXyyHF6Fo/UXFP18YMhOK8aDXR0MUzYj8XRtn9e8ZozAw2xGJXgSMqr/af8KT3VtDL+onJfj4wyBted5e43v7NjqVinWk+XJWjSqr+u/GSut7Mp1QhLLw5l77TIU7MIzWiaElcdduAIVEtMUvjFnwD72Rl80qzyWVrxrLf2OiJDeeLyp/+SFN0a+1UsFoGC+io33vDRcGfg7Os3M0v1g8BaOeDO4Llx8HLwIniqYmVVMoCxipSN1DQxusuNXE631AdztHHkndzizouCk3fSMRia03LAyCw4VAB+TxT+ioxjSzqSqWO6b/en9M5mUPA7cN6iSgv1BSd1mRE3DEPPBLl8vox/YEbU8qdPTbYYlk1hnGFW3NQV2FWeHs1DSGXh5AL3ehMk1ZXUrlUnPVXsFW8/oX2elG8f63+bTy3M3DcV7R/vkQSo9CE7ENxXvNU
 WZAGDWn3
 4ZNdob4y3PDi6D3oRodv/zr/5un4kJKT1WgLp9VdzIg0/UKaUMnCXCfJnZcuZ2Le7a5D5HnaUNCeqq4uoxV69MwSHr3XtY4WnhTfg2mUCwe3pFXiLE0sMyEj7EZ1mN1AWZYEUCJCMILXFd+s+igrgjPcPBsSBRLnDqa9KKn86TSFRozrD06nkAgTctQ67UBV+nJFNlVMZDrO/+VwOKEEZE+O+KfwnSUlgXtoHVHsnw/iBr+5nmFtTYy3hrzgD5KXjzIHHJCifdZcOW5ZNlmHPQx5DEDEgbz7YrD0qHURrrlO1LXzwhnmqNKgM8DqcHLEq3CARnWRPVzHrKr0TgnHVvC5M/N0KL/oLveIVbdZ7lpjX4je4HJrkPKzAjES6X9mmdveS2ZgD7x8+6z5QpOfpb6gIeTQnO0Z+87A3G04e1ms+VxlDMYgR/ocVSdsbqJG/WLEwf5Z3fb0LnUJVGyUG4XrQh0TE8vCul0gZJ7y8U0pVBchoR4UTJSBZIymNpM/CAp1CntMcF3Q/4AYyzHbPpNxai1YXQz/Vmm6/ZvtZALjwCrVCoEsa5ZLQlcm6lyTaTgVl5vJaKejy0nE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   3cace99d63192a7250461b058279a42d91075d0c
commit: e0aa7237ef4323a66ed06953225d9b07cf039530 [4756/5283] mm: tag kernel stack pages
config: hexagon-randconfig-r072-20250829 (https://download.01.org/0day-ci/archive/20250830/202508300929.TrRovUMu-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202508300929.TrRovUMu-lkp@intel.com/

smatch warnings:
kernel/fork.c:457 account_kernel_stack() warn: we never enter this loop
kernel/fork.c:457 account_kernel_stack() warn: unsigned 'i' is never less than zero.
kernel/fork.c:479 exit_task_stack_account() warn: we never enter this loop
kernel/fork.c:479 exit_task_stack_account() warn: unsigned 'i' is never less than zero.

vim +457 kernel/fork.c

ba14a194a434cc Andy Lutomirski           2016-08-11  437  static void account_kernel_stack(struct task_struct *tsk, int account)
c6a7f5728a1db4 KOSAKI Motohiro           2009-09-21  438  {
0ce055f85335e4 Sebastian Andrzej Siewior 2022-02-17  439  	if (IS_ENABLED(CONFIG_VMAP_STACK)) {
449e0b4ed5a16c Pasha Tatashin            2025-05-09  440  		struct vm_struct *vm_area = task_stack_vm_area(tsk);
27faca83a7e955 Muchun Song               2021-04-29  441  		int i;
efdc94907977d2 Andy Lutomirski           2016-07-28  442  
e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  443) 		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
449e0b4ed5a16c Pasha Tatashin            2025-05-09  444  			mod_lruvec_page_state(vm_area->pages[i], NR_KERNEL_STACK_KB,
27faca83a7e955 Muchun Song               2021-04-29  445  					      account * (PAGE_SIZE / 1024));
e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  446) 			__SetPageStack(vm_area->pages[i]);
e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  447) 		}
27faca83a7e955 Muchun Song               2021-04-29  448  	} else {
0ce055f85335e4 Sebastian Andrzej Siewior 2022-02-17  449  		void *stack = task_stack_page(tsk);
e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  450) 		struct page *page = virt_to_head_page(stack);
e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  451) 		int i;
0ce055f85335e4 Sebastian Andrzej Siewior 2022-02-17  452  
991e7673859ed4 Shakeel Butt              2020-08-06  453  		/* All stack pages are in the same node. */
da3ceeff923e3b Muchun Song               2020-12-14  454  		mod_lruvec_kmem_state(stack, NR_KERNEL_STACK_KB,
efdc94907977d2 Andy Lutomirski           2016-07-28  455  				      account * (THREAD_SIZE / 1024));
e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  456) 
e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20 @457) 		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++, page++)
e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  458) 			__SetPageStack(page);

Apparently in the linked config the THREAD_SIZE / PAGE_SIZE is zero.
Is this the expected behavior?  I don't know mm enough to say the
answer...

ba14a194a434cc Andy Lutomirski           2016-08-11  459  	}
27faca83a7e955 Muchun Song               2021-04-29  460  }
c6a7f5728a1db4 KOSAKI Motohiro           2009-09-21  461  
1a03d3f13ffe5d Sebastian Andrzej Siewior 2022-02-17  462  void exit_task_stack_account(struct task_struct *tsk)
9b6f7e163cd0f4 Roman Gushchin            2018-10-26  463  {
1a03d3f13ffe5d Sebastian Andrzej Siewior 2022-02-17  464  	account_kernel_stack(tsk, -1);
991e7673859ed4 Shakeel Butt              2020-08-06  465  
1a03d3f13ffe5d Sebastian Andrzej Siewior 2022-02-17  466  	if (IS_ENABLED(CONFIG_VMAP_STACK)) {
449e0b4ed5a16c Pasha Tatashin            2025-05-09  467  		struct vm_struct *vm_area;
9b6f7e163cd0f4 Roman Gushchin            2018-10-26  468  		int i;
9b6f7e163cd0f4 Roman Gushchin            2018-10-26  469  
449e0b4ed5a16c Pasha Tatashin            2025-05-09  470  		vm_area = task_stack_vm_area(tsk);
e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  471) 		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
449e0b4ed5a16c Pasha Tatashin            2025-05-09  472  			memcg_kmem_uncharge_page(vm_area->pages[i], 0);
e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  473) 			__ClearPageStack(vm_area->pages[i]);
e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  474) 		}
e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  475) 	} else {
e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  476) 		struct page *page = virt_to_head_page(task_stack_page(tsk));
e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  477) 		int i;
e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  478) 
e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20 @479) 		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++, page++)
e0aa7237ef4323 Vishal Moola (Oracle      2025-08-20  480) 			__ClearPageStack(page);
9b6f7e163cd0f4 Roman Gushchin            2018-10-26  481  	}
9b6f7e163cd0f4 Roman Gushchin            2018-10-26  482  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


