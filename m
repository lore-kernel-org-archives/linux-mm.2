Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9E2AFF885A
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 07:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07F926B0005; Sun,  3 May 2026 03:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0308B6B008A; Sun,  3 May 2026 03:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAF4A6B008C; Sun,  3 May 2026 03:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA3746B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 03:17:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 792391C0681
	for <linux-mm@kvack.org>; Sun,  3 May 2026 07:17:04 +0000 (UTC)
X-FDA: 84725251968.13.BD60D39
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	by imf17.hostedemail.com (Postfix) with ESMTP id C428C4000C
	for <linux-mm@kvack.org>; Sun,  3 May 2026 07:17:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of 3bfb2aQkbAIw8EF0q11u7q55yt.w44w1uA8u7s439u39.s42@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3bfb2aQkbAIw8EF0q11u7q55yt.w44w1uA8u7s439u39.s42@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777792622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=wBJ+nqiJeCAh7ANanxHfUmzC7i4o2jYq4KYC2pamiXg=;
	b=KxEiD3kps3cFrG+25Ru1FdfQa3w5SqFe91+Xexlbe8/UKQ9UFQz0jYryD+JW0YNBEdzBr/
	o+O1lWxr4ApZmBP7sUT7It78yM1e8pg0lb5KxdwecyrWCGcCtxwx930Djqxu631BvLYC4/
	EhdXjfMiFG5/RIQazSverGu1z77cfVk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of 3bfb2aQkbAIw8EF0q11u7q55yt.w44w1uA8u7s439u39.s42@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.70 as permitted sender) smtp.mailfrom=3bfb2aQkbAIw8EF0q11u7q55yt.w44w1uA8u7s439u39.s42@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777792622; a=rsa-sha256;
	cv=none;
	b=OwIkcWiUUyk499P2VTjMrHKgiJvodYET/2ipdYc6VowjPRRwfmle1abbjKKE3HHwkW+cR8
	oS+o9nW2yRqu0Ry14jJVLWazLb+ce48taKx4O5JeUsaLvZ4Tev/Lq7QW+t65mMLYdIMHCQ
	bS44EYe7B6ynmANWXmLQaXyjpvPRkzI=
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6967b799acdso5803068eaf.3
        for <linux-mm@kvack.org>; Sun, 03 May 2026 00:17:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777792622; x=1778397422;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wBJ+nqiJeCAh7ANanxHfUmzC7i4o2jYq4KYC2pamiXg=;
        b=Syo6x2AtpraagZAg2IRi/xiGKjRcMsyxZAuMhB6+jUsHBBybw7I9YW/ldfO0PLZRwn
         QqaQKOOP6lBImn2RNQvOELtBNeroWmCN+qwInyLwmNK35IufyRMrWB9XNWKn3TM7ywnP
         QzcRgXO78zQ5ojRdIhWYbqhWkdFsBamSbm0/5xhi+SLJX8BWQglxk7EV9HyFXur2GLQ1
         Lnd70uPAgt/WQpfYMnxKuoHcRVuA6DT0LEmzTPBIgdEgrAuMVSs8elxLrLRLAz6wOzYO
         /3muMNfvTQvEOVSU0WHiGvwqepnTvpTdZBdHYQjJCoJt0upskz5JHwvvDncRvHO0zdmq
         +YTg==
X-Forwarded-Encrypted: i=1; AFNElJ9A8PMOYMBxRyB7trKVv4ccbepyBIvQQA7UqmUwkieNnvFoUzbe9DksVG8kYuVrg0edRHLXctRc1g==@kvack.org
X-Gm-Message-State: AOJu0YxQcHD/osT0EUDgQEWs0FNXlpezZWDrBdGJDen2obbIqqY475z4
	oSokaMj/WkHRZSZm8DZW2MLpWXgFW39zvytTgBDCg6IAO5s7sJklGS99EgcH/wJ79/GIkn+w3tw
	gqD55ASO62WtawxLwvi6lFaXHI1ApAwX+Yo0dE5DZ+bgc0zy5yaaCg5arDX0=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:210e:b0:696:2674:8a18 with SMTP id
 006d021491bc7-69697c50cbcmr2729750eaf.35.1777792621895; Sun, 03 May 2026
 00:17:01 -0700 (PDT)
Date: Sun, 03 May 2026 00:17:01 -0700
In-Reply-To: <4b30ba28-6f75-43a1-a108-5c0288ab021a@dev.snart.me>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f6f66d.050a0220.312cd3.002c.GAE@google.com>
Subject: Re: [syzbot] [mm?] [exfat?] [f2fs?] memory leak in __kfree_rcu_sheaf
From: syzbot <syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com>
To: dxdt@dev.snart.me, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: C428C4000C
X-Rspamd-Server: rspam06
X-Stat-Signature: ky3sx9bwcyct54pn3ox5p7otyu37sqr9
X-HE-Tag: 1777792622-244716
X-HE-Meta: U2FsdGVkX1+usjHNh6VwyoPbK3ppk+lbrTMY+KlqRiVPeqEMvJmWKUgfDgRe5Tatqzk4MetQ1U4+vpYpsUm2Wjt9yYUqTBuEqFyB0QUSWl4mYDcHcMnfEsqVNrU3L8ou6knqnEEg5VRcS5iBu9LERIyzKudPrnFYfIXqJmFeszgF0mMt1HUoQBj1vOARTRzybEhY2IPAcaVmrEnkCWM/91fvyuzrfAVRIPgMnCPS5QuwGWHPw/x+l+kEGXzL3kU5tG0mcs58enermo/0XaTUBDZNXcvtR5OfZMt//fjOmDEBReZsIV82DVyBVtgXQuTMYix5DlKNZkFQV2Cl2fZsLNsYmu4C48wuA+kBYCUi+lodYqqqw/usRbRIt7Av+LM7IcH/lMlO1bPZpseSj3zUqDn+UNdTBue3cIdKtY3omQtPuwPz0bRccFHktvlVTz3f9L7bqL2/8S1ioDdFaQoIw8+jtBcYy/iJlVMtDjNyGc9+OqEf9AdbFy+4R0wlpZ6Yz6sTDgE/5y6Czjcn68fmqGwf0Pe57EOukjschHNESdTWz7lbfc/bjAddNug0T9PH6AphFknaU857oaAQupl/lgtu3E+5gj0CGebZz5tSR74UAMkrFCnEOPpKNfLZWGJfYdo+F974h6gQF3vy/UZdrgznPGOoUYDZBcQF8dsiOYLYhVTfuXwfSqaFv4M/QSf7ByzsMldLKJFODCD5/6yxUgRxo1mJK8D9VQ7xTu7ZpGou36AQcr3SH2aN28PRyLikCySvoT+FsLJOfHsGO0oniErbW5t4L4HNatMJzBWMHFPJfj+8wafj0slgJSmhaWWTHjtpV5yJF7uOEj67Kz03mvvf0iYds+Hfmb9ANuqCF9Dsxo9bTdvik3CHQvG1ESFwOvSOR/u9Vz9KVq/RptKfkv4lKKH2LUNJPckHpiYwKO2vEFyzp6gWH+RlPGsdZoR1e/GcO4ZsjQhCiKgzWY0
 uv7UxSnM
 bz89AceEAoXd6mO+gplwmi1W8I9NmH/31q8NkGKI8Q0Ca3CFcl630RWsetTsVwPqntAarRIJTda6oVLlZ80Fe6MZmcYzy9N/LcFCBCOBDkp29KcDNvCAuDGjFZUJx9yVcqEVesfqpjJjfRHH/H97wuaGarvMlz3AtpAR/wZiFphY2DITpQmWcOqPbvGW82FHbDevlM2MchaYGnU/X54EHzbk9YGPA0kUDskznSGmQYIp09K/AEYWpdCwfmFM0J2uv3wfwv/u3zVvnLC7IvrJNplB0vmSZqO9DskE7h+e3BS+V4KRiSTSHvvOLSdaUeCIU7LFK8q5wwLlf3OoVuN9DHvsifixKZZQJ20zYF/jO5B0VRBplJTgom9Ya7be/ztzce1d1L3KmusmnaI/H2DVtHzPdAyO+Zv+4qtHAB0x3DlFQJjs6+JttztO7yY9uN0ofwK6MmI4Nc9VnCB/wxYeH+BvwtjUlEPTnVlEM+txGGNEVdEsxGrDXn6QL1cXcppmLaACVEbuVZDictK2LjVHN+WeHFQdBR5NDEhD1K3cMnv5QeRwvBFa49JMyz+pkcf1S4Set1QhkWoyXk5hyURmB5hSAzDQbXQEbSTFifZFjzbeWec5jD7RdmAfsedfw6dthDj4QiUq/+7S1NNnT5lBbs2qMsJbtfbvAlxvvBPsPhg0TdsdF1oiyJBWifSIrD58b9elgyIFtvDjmo3A20trZvAhygAB1zkELYVIKuYv8xSF0lqaYpWBZwu8DvjBbYNd7SDVfWT0qLsGCfWFxxL4YNselodXfIkL7bYBpRjhuHC0a5ePScg+kX2lk73272lj/lmzEW7xxU1hWco8iTob5McapHVlZr8BxSRd4SoL+SBgVezfPk+N9+6hDA6FlPtrMiWlcnDV70+PM0nap0ZY8SsGL2yUGSWlx7gBEcG79Nt0a1Str492PbtbnhKC8UhL0mqKSGiEAbBzIfLiitjKuwl62oKwK
 9FEX4Vv/
 WJtaRWeUfHd5NN/xtMH4ZFkLpGUpKNe7u6QaC9pidvZJd7bE56mxbtwvs6d4lmoE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
memory leak in __pcs_replace_empty_main

BUG: memory leak
unreferenced object 0xffff88810005f600 (size 512):
  comm "swapper/0", pid 0, jiffies 4294937296
  hex dump (first 32 bytes):
    e0 e2 ee 2c 81 88 ff ff a0 13 ad 81 ff ff ff ff  ...,............
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 2486057c):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4574 [inline]
    slab_alloc_node mm/slub.c:4898 [inline]
    __do_kmalloc_node mm/slub.c:5294 [inline]
    __kmalloc_noprof+0x3b7/0x550 mm/slub.c:5307
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2768
    alloc_empty_sheaf mm/slub.c:2783 [inline]
    __pcs_replace_empty_main+0x22a/0x2a0 mm/slub.c:4646
    alloc_from_pcs mm/slub.c:4749 [inline]
    slab_alloc_node mm/slub.c:4883 [inline]
    __kmalloc_cache_noprof+0x3a6/0x480 mm/slub.c:5410
    kmalloc_noprof include/linux/slab.h:950 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __irq_domain_alloc_fwnode+0x37/0x140 kernel/irq/irqdomain.c:95
    irq_domain_alloc_named_fwnode include/linux/irqdomain.h:271 [inline]
    arch_early_irq_init+0x1c/0x70 arch/x86/kernel/apic/vector.c:803
    start_kernel+0x931/0xb80 init/main.c:1123
    x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
    x86_64_start_kernel+0xce/0xd0 arch/x86/kernel/head64.c:291
    common_startup_64+0x13e/0x148

BUG: memory leak
unreferenced object 0xffff888101d04e00 (size 512):
  comm "kworker/u8:5", pid 311, jiffies 4294937428
  hex dump (first 32 bytes):
    b8 1c b8 28 81 88 ff ff a0 13 ad 81 ff ff ff ff  ...(............
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 1d48d83d):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4574 [inline]
    slab_alloc_node mm/slub.c:4898 [inline]
    __do_kmalloc_node mm/slub.c:5294 [inline]
    __kmalloc_noprof+0x3b7/0x550 mm/slub.c:5307
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2768
    alloc_empty_sheaf mm/slub.c:2783 [inline]
    __pcs_replace_full_main+0xdf/0x300 mm/slub.c:5757
    free_to_pcs mm/slub.c:5810 [inline]
    slab_free mm/slub.c:6249 [inline]
    kfree+0x361/0x3a0 mm/slub.c:6561
    call_usermodehelper_freeinfo kernel/umh.c:43 [inline]
    umh_complete kernel/umh.c:57 [inline]
    call_usermodehelper_exec_async+0x1c7/0x1f0 kernel/umh.c:119
    ret_from_fork+0x219/0x490 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888101d18800 (size 512):
  comm "kworker/0:1", pid 10, jiffies 4294937813
  hex dump (first 32 bytes):
    00 c8 ec 0b 81 88 ff ff 00 18 d3 0b 81 88 ff ff  ................
    00 12 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc 307f46be):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4574 [inline]
    slab_alloc_node mm/slub.c:4898 [inline]
    __do_kmalloc_node mm/slub.c:5294 [inline]
    __kmalloc_noprof+0x3b7/0x550 mm/slub.c:5307
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2768
    alloc_empty_sheaf mm/slub.c:2783 [inline]
    __pcs_replace_full_main+0xdf/0x300 mm/slub.c:5757
    free_to_pcs mm/slub.c:5810 [inline]
    slab_free mm/slub.c:6249 [inline]
    kfree+0x361/0x3a0 mm/slub.c:6561
    vfree mm/vmalloc.c:3476 [inline]
    vfree+0x14d/0x3d0 mm/vmalloc.c:3436
    delayed_vfree_work+0x29/0x40 mm/vmalloc.c:3392
    process_one_work+0x277/0x5b0 kernel/workqueue.c:3302
    process_scheduled_works kernel/workqueue.c:3385 [inline]
    worker_thread+0x255/0x4a0 kernel/workqueue.c:3466
    kthread+0x14e/0x1a0 kernel/kthread.c:436
    ret_from_fork+0x219/0x490 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888101d2be00 (size 512):
  comm "kworker/0:1", pid 10, jiffies 4294937856
  hex dump (first 32 bytes):
    c8 2c 04 00 81 88 ff ff 00 90 b7 2a 81 88 ff ff  .,.........*....
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc 9ff75ca2):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4574 [inline]
    slab_alloc_node mm/slub.c:4898 [inline]
    __do_kmalloc_node mm/slub.c:5294 [inline]
    __kmalloc_noprof+0x3b7/0x550 mm/slub.c:5307
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2768
    alloc_empty_sheaf mm/slub.c:2783 [inline]
    __pcs_replace_full_main+0xdf/0x300 mm/slub.c:5757
    free_to_pcs mm/slub.c:5810 [inline]
    slab_free mm/slub.c:6249 [inline]
    kfree+0x361/0x3a0 mm/slub.c:6561
    vfree mm/vmalloc.c:3476 [inline]
    vfree+0x14d/0x3d0 mm/vmalloc.c:3436
    delayed_vfree_work+0x29/0x40 mm/vmalloc.c:3392
    process_one_work+0x277/0x5b0 kernel/workqueue.c:3302
    process_scheduled_works kernel/workqueue.c:3385 [inline]
    worker_thread+0x255/0x4a0 kernel/workqueue.c:3466
    kthread+0x14e/0x1a0 kernel/kthread.c:436
    ret_from_fork+0x219/0x490 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff888101d2b000 (size 512):
  comm "kworker/u8:9", pid 4643, jiffies 4294937873
  hex dump (first 32 bytes):
    00 72 5a 03 81 88 ff ff c8 2c 04 00 81 88 ff ff  .rZ......,......
    00 12 04 00 81 88 ff ff 3c 00 00 00 00 00 00 00  ........<.......
  backtrace (crc bcccad5b):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4574 [inline]
    slab_alloc_node mm/slub.c:4898 [inline]
    __do_kmalloc_node mm/slub.c:5294 [inline]
    __kmalloc_noprof+0x3b7/0x550 mm/slub.c:5307
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2768
    alloc_empty_sheaf mm/slub.c:2783 [inline]
    __pcs_replace_full_main+0xdf/0x300 mm/slub.c:5757
    free_to_pcs mm/slub.c:5810 [inline]
    slab_free mm/slub.c:6249 [inline]
    kfree+0x361/0x3a0 mm/slub.c:6561
    call_usermodehelper_freeinfo kernel/umh.c:43 [inline]
    umh_complete kernel/umh.c:57 [inline]
    call_usermodehelper_exec_async+0x1c7/0x1f0 kernel/umh.c:119
    ret_from_fork+0x219/0x490 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff8881035a7400 (size 512):
  comm "udevadm", pid 4981, jiffies 4294938333
  hex dump (first 32 bytes):
    00 88 b7 2a 81 88 ff ff 00 4e d0 01 81 88 ff ff  ...*.....N......
    00 12 04 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc 82d289ee):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4574 [inline]
    slab_alloc_node mm/slub.c:4898 [inline]
    __do_kmalloc_node mm/slub.c:5294 [inline]
    __kmalloc_noprof+0x3b7/0x550 mm/slub.c:5307
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    __alloc_empty_sheaf+0x35/0x50 mm/slub.c:2768
    alloc_empty_sheaf mm/slub.c:2783 [inline]
    __pcs_replace_empty_main+0x22a/0x2a0 mm/slub.c:4646
    alloc_from_pcs mm/slub.c:4749 [inline]
    slab_alloc_node mm/slub.c:4883 [inline]
    __kmalloc_cache_noprof+0x3a6/0x480 mm/slub.c:5410
    kmalloc_noprof include/linux/slab.h:950 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    kernfs_get_open_node fs/kernfs/file.c:543 [inline]
    kernfs_fop_open+0x4f4/0x580 fs/kernfs/file.c:718
    do_dentry_open+0x1fc/0x8c0 fs/open.c:947
    vfs_open+0x3d/0x1b0 fs/open.c:1079
    do_open fs/namei.c:4699 [inline]
    path_openat+0x154d/0x1e20 fs/namei.c:4858
    do_file_open+0x121/0x200 fs/namei.c:4887
    do_sys_openat2+0xa5/0x140 fs/open.c:1364
    do_sys_open fs/open.c:1370 [inline]
    __do_sys_openat fs/open.c:1386 [inline]
    __se_sys_openat fs/open.c:1381 [inline]
    __x64_sys_openat+0x82/0xf0 fs/open.c:1381
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xee/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF


Tested on:

commit:         66edb901 Merge tag 'v7.1-p3' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13db0ad2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9645c21cfd1d3e8f
dashboard link: https://syzkaller.appspot.com/bug?extid=cae7809e9dc1459e4e63
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=153b7ece580000


