Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2A8EF8FA6E
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 12:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2BFF6B0088; Tue, 21 Apr 2026 08:36:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDBE16B0089; Tue, 21 Apr 2026 08:36:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCBCB6B008A; Tue, 21 Apr 2026 08:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A78236B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:36:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05A36C3F41
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:36:33 +0000 (UTC)
X-FDA: 84682511466.11.67EA338
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id EE95E1C0003
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:36:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qQCw2bCn;
	spf=pass (imf18.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776774991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K2umFNIY/BLyJ91U8ESVwZ5+480SIvdek4DpKYYkBZU=;
	b=xmMB4OdCx43Pl0WkyI1ijWcgxwRflVkXtXXwtigFyy/N68yYIknHSFOMdBybafBaLScEHc
	rlpr95YEAbupsplJKlnq+s9TTam5v2MJvP8CqywtUumkhesckxFmv9kRMfofxSOlMktot4
	+mVgvaTGrLLYvTSvJvzycsMgIpcTvJ0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qQCw2bCn;
	spf=pass (imf18.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776774991; a=rsa-sha256;
	cv=none;
	b=7iGApkfem0o6TXgs4jTYcVM99sxbpg1ykRq0X4YB3EHB1Q5Tq5ET7TT066vlz1BTob6gqS
	C6ap+FMrlejqYDUMG1+W6id6AvBUC/AEpcJ1ONuh2A3gtW0RC4qCPjNrn1CC1v/yiuIAbA
	Igtn4t8Su55TzbN0Kiv+WILRzCrmPRQ=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5a40cfab24dso4439973e87.2
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776774989; x=1777379789; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=K2umFNIY/BLyJ91U8ESVwZ5+480SIvdek4DpKYYkBZU=;
        b=qQCw2bCnvTkWNXMyUoBfDw/RdUPTWV5BzzcZZ1HbIKULZHZaQpnMrGJ5gyLQgSLX3w
         AA8jGcKNnFu2URL/G+uoI6/DgF+aB7TMmUMbygd20LACmaWXbS5KNosF+2nsNhUaVRwa
         +l+HjtO2gnIJO7pUwQzz4AWM0nq2hhNF7/XZfJGtaEmQuFMIUcC24RVP8kK7d7F6vqlk
         9QYm9V57LoH608ZtDeSUTlZXXHIhY9Dpfdi37N0XifFBVgbNg/McidrD8LeEptbWu32B
         2lA/zOuWt2CYemcRyqQHakNSQYokv2H4Ii4AkZxWUJ7DA6Q4aNZppYUbZtZHk58qluSq
         rdMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776774989; x=1777379789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K2umFNIY/BLyJ91U8ESVwZ5+480SIvdek4DpKYYkBZU=;
        b=Ox4t7g07jjsc5Pf8pN6T9oRZ+/os5fK5KPs4jhjGvi0DRxKi4G+ERk0NadwW9Vwcpx
         m1iT0IyJXeTVZ2uaY6wpVgaUwIL23cAF5EJ/ch/PTpABvAADI1F0+M0ddH1war5CuCr5
         F4voPYLVr+d8dKcnT8XJItDmnxtxAoVm5SZQq/edS2uAsLX0VblXCGMkmKPgCckRdFbE
         1maeRHUkV8WVqvmv3NkRpIDfR5O7Wi29rY1PYrKLt5JYVtI1hP63eT0ojP6gfMeTQq2Y
         bisLxymHsHUBEtKCWbieNKpu2aw4C9KYyg6l7rJHURhIJx8yvpe54Yf1xYXNeN76ktm+
         BizA==
X-Forwarded-Encrypted: i=1; AFNElJ9LmI7KOJxcZZjFpJx7lDNSSfntZFnM7qmP5QrarBmYTcOrireUoOCoNgJ5fPlsPzXIO1LhsgsLyQ==@kvack.org
X-Gm-Message-State: AOJu0Yx1BNUWXWe8Hzs8FetADPqc92wUHip0nNI5wrhH0FVAOcf76kfY
	YKp3epeiNwB3g6s1Ox+DrtayOMaCwsxqVtaQ3PexI4ABeRN7NdpWFr1D
X-Gm-Gg: AeBDiesm9XhF2hkyJWuzOYEqnMYSSO9E2QI4Ue93lD3HH6mT1JJ54pkmmJHAv0vn3Tg
	YyzCfWYqkpkd89O3ym97FBcAslcqYi4M7ASjZlgYf67EjhUOAmJdmfno0fp6pHM59nnEHGJnK/x
	9Jf4TTKRZfZgEtLxDCwaQg16aNvvVKgc1zfMFvxhvo1amd6Z0entw0WjdPJBnw79Mv1sYAp34Hm
	AQOuu7bppg5dv6H3D1FMY4irCp6SNJOYRF/wR1GEWZhk71lYrC4MPI91ViUfM8M+VYsDxkP7BqU
	OT4lgpxHJja3/ij4njtkgPkLXIYAKAzuko0EHrHq1y4/YNc1zS/g4uhp3eBbuqp6sp/UnR9SGE0
	RzXhHDqgplTg/T25SOMK6sugb7/CQ51m4WDeoKdoO0KD9Oj/ZefkxERcj5Pwgoxuv0iSzArMEcn
	tLiYiFuG1alA==
X-Received: by 2002:ac2:5b05:0:b0:5a4:175d:21a with SMTP id 2adb3069b0e04-5a4175d0239mr4423230e87.2.1776774988560;
        Tue, 21 Apr 2026 05:36:28 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38ecb6f0bfdsm30395521fa.26.2026.04.21.05.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 05:36:28 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 21 Apr 2026 14:36:26 +0200
To: Thomas Graf <tgraf@suug.ch>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: Uladzislau Rezki <urezki@gmail.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	linux-mm@kvack.org
Subject: Re: [linus:master] [mm]  c6307674ed:
 BUG:sleeping_function_called_from_invalid_context_at_mm/vmalloc.c
Message-ID: <aedvSnhOGM_mauYP@milan>
References: <202604211323.fac1b29e-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202604211323.fac1b29e-lkp@intel.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EE95E1C0003
X-Stat-Signature: gu64mkmg4mns14mg4qktxxwkxzwarg44
X-Rspam-User: 
X-HE-Tag: 1776774990-107860
X-HE-Meta: U2FsdGVkX19773T56XvsWGDG86o3JUsqGMx8soLnEKK544nhOc6f7mFjNbRejHyUNhKnLiAs4xotTpv3lqtlVdvPK/9oPNv+dZkGC9lbfagWTLVjHdlDdmrLmXvwCGFPWmseZCXE/TJaKn3zrRW+JEBJUEdroVI8lpvPfkaCYno0SqXkmnrcmD75r1MQ5Y9+oRduE8Fd5Oxpo5A2WxaFYr8Mxq4689nBMMQb/TJNrYuoENEtcAxhSDReQgqvBBET6cLtJQ2Q9Pf7iKV7dwLVmrjN/d3y7J4qyfqlgovcFf3UCmJjo1BdZH5XDAagBHS9+/fcVDHajYUxBnFb4aA4gKtHdBtGby6szz6/tYIKjhaO6LK3ktMPL/lBeYZJF2TZsrg/oIygSq+traH0m7Fc9ussPDNvDvmU/fLFDAS5nZLR3LTtDOc7BUfY5HTtBJ4kBUgKo7iGZLnreJ0MN8Opr1sn/4ebCVdi1WXRRSQ3bskYY4bg1/cIhah3Z8WoAExoi+2iooniPD+3ODDzkuXAG+JfZ6UJHqrD0+xn4uFHaD1hSj1TlE+Ya2Z17JgYsFmVyk8iRySddG1Hklv6MRUwJkrf2o/m44sRhWBg40ozbtIqk5iFvnOG1+ROdsbOy9hQCFQkzrwPYhpO5D6/sSastkL86gzRjFHEZEohfqHXZxWuJEFzW9yP7V/l9GEylEUEWXUhH6/HkzqjT+XIyekePrqFafA0CpcSCUbEhAP04SfAxMfSmmogWHB6zZ1/vNK5h4PM0AOfIyIs2g4erN7NIWOS1eIYimqed5kR+69I2gazXkqK8BFvV5rElZ5JWIGQJ6zvrB/7Rq7c6nEOJH7q4U79VKI6AGx3wkbn8O0Vm+h1TToiZTyzmK7eMDpu89THmuQnoOJplj0U65mBriHRNBGcq4FRIcE9vZwKzPPXThsXKR9KgEwN4dSB8FhcvbAbfDz8AxnQf2qP+bVy6Zn
 qx2/fh7E
 wz5/nIIbA8cf3lz57Mse5a0Zb6tWsXMn2CiCEmfbvoHxZ8b2ZiUqz7nowlY+WaX2K2KfGMaeDI7PybX3dFlmF2e6xoqiQcejmoer1Esvvw1zaNbelHaPoQ0zWwuK+xujc6dDgPN0Q7UnWzMdNwqHEYHR8RUoY5YBPcYbqTfcQkZ7aDOBxu9dOwXXsyVOt71fj73PdhbsGDkTOJYblxBedXjK549qH/U3wh402D4I9yu5R3gdnC5SmqqjU6tJQRyB5lsRSj6Y8Ll7/8NcXcTgGZYDKhT4C2ch7jljytvxab44HLCawO1CoQVbO6ViJO6nGTFtJ+tmagFF12UlMBF5LKExcPKOx+Yhc11Xhl6SEIxMNOXHrzSQAuEF04OS16RqYZpldCloDOe05qQTpieBhcOcmQzS34tkyAvON3uN2WYsmbZFKBraXwUSCFqkSc2DpJch3/+gFakkWgkoHcJmzz78B50sLduKjSLZZlAze0oUvzDNd8fUkyul/VBD22DPGGJrd0nNzqz8hXGB2nJhHGbxPHpb+Exmc0IfiSlGgGGONCJ8dsNBXeO9aI8TbP++MW8TrALNkU0ltJkig3hBct6r9hAkH9H3iDJZNwMwptwdmNHV3rW8Etflzp8zLCtmkWYVACi+7UNlrb/ZApStSfqMqBJWD2hmo1QMzhotLcTHejqQMDqKCv5gOEi8SVW2mRXxLoDHzqt0bM18=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Thomas, Herbert Xu!

> 
> kernel test robot noticed "BUG:sleeping_function_called_from_invalid_context_at_mm/vmalloc.c" on:
> 
> commit: c6307674ed82c0c57d6e1e3408e84ac449ab8e94 ("mm: kvmalloc: add non-blocking support for vmalloc")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> 
> [test failed on linus/master      40286d6379aacfcc053253ef78dc78b09addffda]
> [test failed on linux-next/master 936c21068d7ade00325e40d82bfd2f3f29d9f659]
> 
> in testcase: kunit
> version: 
> with following parameters:
> 
> 	group: group-01
> 
> 
> 
> config: x86_64-rhel-9.4-kunit
> compiler: gcc-14
> test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz (Haswell) with 16G memory
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202604211323.fac1b29e-lkp@intel.com
> 
> 
> 
> [  149.217862][ T4054] BUG: sleeping function called from invalid context at mm/vmalloc.c:3435
> [  149.226291][ T4054] in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 4054, name: rhashtable_thra
> [  149.235634][ T4054] preempt_count: 0, expected: 0
> [  149.240353][ T4054] RCU nest depth: 1, expected: 0
> [  149.245166][ T4054] CPU: 1 UID: 0 PID: 4054 Comm: rhashtable_thra Tainted: G S  B            N  6.18.0-rc5-00047-gc6307674ed82 #1 PREEMPT(voluntary)
> [  149.245176][ T4054] Tainted: [S]=CPU_OUT_OF_SPEC, [B]=BAD_PAGE, [N]=TEST
> [  149.245178][ T4054] Hardware name: Dell Inc. OptiPlex 9020/0DNKMN, BIOS A05 12/05/2013
> [  149.245181][ T4054] Call Trace:
> [  149.245185][ T4054]  <TASK>
> [  149.245189][ T4054]  dump_stack_lvl (lib/dump_stack.c:122)
> [  149.245200][ T4054]  __might_resched.cold (kernel/sched/core.c:8928)
> [  149.245209][ T4054]  vfree (include/linux/kernel.h:61 mm/vmalloc.c:3435)
> [  149.245215][ T4054]  rhashtable_try_insert (lib/rhashtable.c:476 lib/rhashtable.c:635)
> [  149.245223][ T4054]  ? sysvec_apic_timer_interrupt (arch/x86/include/asm/hardirq.h:78 (discriminator 2) arch/x86/kernel/apic/apic.c:1052 (discriminator 2))
> [  149.245229][ T4054]  ? sysvec_apic_timer_interrupt (arch/x86/include/asm/hardirq.h:78 (discriminator 2) arch/x86/kernel/apic/apic.c:1052 (discriminator 2))
> [  149.245235][ T4054]  ? __pfx_rhashtable_try_insert (lib/rhashtable.c:592)
> [  149.245242][ T4054]  rhashtable_insert_slow (lib/rhashtable.c:648)
> [  149.245247][ T4054] insert_retry+0x257/0x630 test_rhashtable
> [  149.245260][ T4054] threadfunc (lib/test_rhashtable.c:633) test_rhashtable
> [  149.245269][ T4054]  ? try_to_wake_up (kernel/sched/core.c:4297)
> [  149.245275][ T4054]  ? _raw_spin_lock_irqsave (arch/x86/include/asm/atomic.h:107 (discriminator 4) include/linux/atomic/atomic-arch-fallback.h:2170 (discriminator 4) include/linux/atomic/atomic-instrumented.h:1302 (discriminator 4) include/asm-generic/qspinlock.h:111 (discriminator 4) include/linux/spinlock.h:187 (discriminator 4) include/linux/spinlock_api_smp.h:111 (discriminator 4) kernel/locking/spinlock.c:162 (discriminator 4))
> [  149.245281][ T4054]  ? __pfx_threadfunc (lib/test_rhashtable.c:618) test_rhashtable
> [  149.245289][ T4054]  ? __pfx_autoremove_wake_function (kernel/sched/wait.c:402)
> [  149.245295][ T4054]  ? __kthread_parkme (arch/x86/include/asm/bitops.h:202 (discriminator 1) arch/x86/include/asm/bitops.h:232 (discriminator 1) include/asm-generic/bitops/instrumented-non-atomic.h:142 (discriminator 1) kernel/kthread.c:290 (discriminator 1))
> [  149.245301][ T4054]  ? __pfx_threadfunc (lib/test_rhashtable.c:618) test_rhashtable
> [  149.245309][ T4054]  ? __pfx_threadfunc (lib/test_rhashtable.c:618) test_rhashtable
> [  149.245317][ T4054]  kthread (kernel/kthread.c:463)
> [  149.245322][ T4054]  ? __pfx_kthread (kernel/kthread.c:412)
> [  149.245326][ T4054]  ? __pfx__raw_spin_lock_irq (kernel/locking/spinlock.c:169)
> [  149.245331][ T4054]  ? __pfx_kthread (kernel/kthread.c:412)
> [  149.245335][ T4054]  ? __pfx_kthread (kernel/kthread.c:412)
> [  149.245339][ T4054]  ret_from_fork (arch/x86/kernel/process.c:164)
> [  149.245344][ T4054]  ? __pfx_kthread (kernel/kthread.c:412)
> [  149.245348][ T4054]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
> [  149.245356][ T4054]  </TASK>
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20260421/202604211323.fac1b29e-lkp@intel.com
> 
> 
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
> 
<snip>
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 6074ed5f66f3..a892766dcedd 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -473,7 +473,7 @@ static int rhashtable_insert_rehash(struct rhashtable *ht,
 
 	err = rhashtable_rehash_attach(ht, tbl, new_tbl);
 	if (err) {
-		bucket_table_free(new_tbl);
+		call_rcu(&new_tbl->rcu, bucket_table_free_rcu);
 		if (err == -EEXIST)
 			err = 0;
 	} else
<snip>

Could you please check? The problem here is

rcu_read_lock()
    rhashtable_insert_rehash()
        vfree();
rcu_read_unlokc();

we can just defer freeing via call_rcu().

--
Uladzislau Rezki

