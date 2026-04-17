Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEDB3F8E4A0
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 02:52:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94246B0005; Thu, 16 Apr 2026 22:52:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E44FF6B0089; Thu, 16 Apr 2026 22:52:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D335E6B008A; Thu, 16 Apr 2026 22:52:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF26F6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 22:52:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 55F2013BF29
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:52:19 +0000 (UTC)
X-FDA: 84666523998.22.6018C32
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf01.hostedemail.com (Postfix) with ESMTP id ACE7440008
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:52:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=F4s+zDqb;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf01.hostedemail.com: domain of wxy2009nrrr@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=wxy2009nrrr@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776394337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H6TmoV2gE3VJEa3D5yOVGAWVcsd1rYCp2oHb5lwVG74=;
	b=HeownR7Wv4/78BtL/awNMy+kmHgML1HvPB/qvE38X2mDO9Ur+iFV7PO/6eY86NN3h5jfJn
	DekzB6uyEGcnXMUVO43LKbBr/xSOmbAFMO4OI6G12L5r6N5p0denrN9+X47B3od/Bz9j0n
	QaNANVMzRzTLclsrTxQxK7LwH0fG+4w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=F4s+zDqb;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf01.hostedemail.com: domain of wxy2009nrrr@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=wxy2009nrrr@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776394337; a=rsa-sha256;
	cv=none;
	b=YjFdqubfjcxB31t9/7Mi3Zy/hZey91apvZcsGw/zjz1RoMiUNZ8y4a0HLe4PgJhXot2xPK
	UsMsLi0jKalgiUoTLl2wWFVm8FC9A5ny/3p1FbTS9YUIZMkWiTsW0WTkmO4FIP1ckHqDrU
	22syeE1W6sfry9Ma0mtMgTcyzzVlQFs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=H6
	TmoV2gE3VJEa3D5yOVGAWVcsd1rYCp2oHb5lwVG74=; b=F4s+zDqbHvLNCPA4lv
	47jYA/KdWwywMj7jvd9pWqL/rjKozG/6vp//Q89xwvLMxAwrF6V2MdsQmXSzQDUl
	GnGQPpzcedS7t/fq2UfpPyVTekZRP18HW10TkideCWih/AzO8UjRgwrozDOWuC6q
	rADvGULacxNt+e4g6L9nnrYqQ=
Received: from PC-4CV553FH2H.company.local (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgA3ircroOFpEJpeAQ--.145S2;
	Fri, 17 Apr 2026 10:51:27 +0800 (CST)
From: wangxinyu19 <wxy2009nrrr@163.com>
To: devnull+kasong.tencent.com@kernel.org
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	chenridong@huaweicloud.com,
	chrisl@kernel.org,
	david@kernel.org,
	hannes@cmpxchg.org,
	kaleshsingh@google.com,
	kasong@tencent.com,
	laoar.shao@gmail.com,
	lenohou@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@google.com,
	surenb@google.com,
	vernon2gm@gmail.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	yuzhao@google.com,
	zhengqi.arch@bytedance.com
Subject: Re: [PATCH v5 00/14] mm/mglru: improve reclaim loop and dirty folio handling
Date: Fri, 17 Apr 2026 10:51:23 +0800
Message-Id: <20260417025123.2971253-1-wxy2009nrrr@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgA3ircroOFpEJpeAQ--.145S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCry7tw4kJFy8Zw1rJr1DJrb_yoW5GrW5pF
	Wftrs8AFs7XFna93929w10gryfAw4rGr45Xry5KrW7Aan8Cr92vr4fJ3yUZ34DArn3KFyY
	vFWqgFykua4DAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UMBTOUUUUU=
X-Originating-IP: [219.143.13.73]
X-CM-SenderInfo: hz01jieqzq22ru6rljoofrz/xtbC0A8GRWnhoC-fxwAA3D
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ACE7440008
X-Stat-Signature: gc4ug9wrrxnwu8fo7m91ybqdyyae1wzs
X-HE-Tag: 1776394336-85870
X-HE-Meta: U2FsdGVkX1+iKm+yFiJn2xvTU0B0QXCSipbep4BQsrXAZ01e0YH2TAAcq2bzVvURgrrWSu3tpNMDIEckJUbvpmeauLzMxCff5AHsrYkLDi6YHEaf0Hv43Aq98vvXvSht3YZq+qBjiNIJroHFDq6ktQ9zZCGmswzSP0aY0yHnzaymxUxY8PnD9YeUg3Sv/r5UhSl+NzG2GRPqYTMcxVxoKgliKsm/vUOUqISICMTOKXWzM9egv2XASWYXZhMsY5OwRao3Qgo4or+NPRxEKuCghxJBlNaK6V6UUqHl069TstG+BKrnSWGVhMduzO/2b84jYwqxK3SCqPmvuT/ieAc5PubRhPaPfXjnR9tNPLP5kmQqFn5iwxS8+Eox4pdDshrlEe7ZCetoHVtFdYFDMQB2fIRSk/o9M7CCtW/LbDfEnDW4K+6FCr+7MmN13jpIi2HUc1gIn8rSwT5jX3mv9O0+lGNlAYPOL+8dhSTYzpQN2O756F1N1ek8XL9nrC0zg0ZjqAvIjzo7rqg93d6lKpnl8N8rU5bzWgf2+wDznLE0Tor6ieZ5P2Rf1dZYTiL7X23Rax/QYhMx0OFYYm4t9OEVczM08CxPoR4/WnOgt/Me1MeFYP9VWHzZ1SRprG+K3izWZ2cT5/V49k5FjMDBDEx+nN9vFJpdf9sDf/StzIsTktnxJC8s3eRdoB85rVlfr3jEwFO1iN1f7vDVj4U5ozepOjK+1AJUWjTGvDKfbkVUqvMbMERoKLFpCR0fauXJAW4hC8L3KtQwX2SyQPMQIv3hw8q0NCLc1pyzb5z8p+jOurCK2YuN1iXVNSLUujAN5A8BFbWvEFIlKzlzRWb9J5OwGaiYdudiutVDAwpMT7EsZm7lktjceRR/6jmv2biepXUmZSmwol9jP4KUZ8mnX3wyYN51T1zvXVI7j7DALNFusl3r3ZoChq2m/RlgpJA3oDLsFgj9xVSwMv3ZI4eog22
 xDX7VyAo
 n5yucGIGYswHXPQhQ0xEknLxYQxCpdCL5Kl5pAP6uwtc11fmwaXTS8P+oXONLFC5a7a+6vyCeUlVcG2D6ZmcrH1BBRQK2k+htW5W1XvfY2lNj3RvzoUb1LSpK6Tn92pXWcGLYYmXR72tQ6rEun9W/ruejbCqZPIYWZH8bBxaB1nD40cj/oHRG8++iL0X9jVmKMg3x27swgTVBwYp1a2Rn8Y4IWcM3RN0iAqxa0wJ7zoKqLK/foseK0v4I4XEJdJtMujfizgfSZEAUrssM1UAkUfgQj5O6QkfGruhqr3hm9Lg62jUoO6D53hK+YbC3agJ24OOw45/aZYBjz7UHRcSdUWzZd1i8aaMCSrBkj5Mcbx5IF+Uzf7h06Er1tU0ALBHEx7uQdvsK78NHQI1nwDkB3Vl31K45462T4CtIfayiZizj5s8SK2eKJ7gJdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Apr 2026 00:48:14 +0800, Kairui Song wrote:
> This series is based on mm-unstable, also applies to mm-new.
> 
> This series cleans up and slightly improves MGLRU's reclaim loop and
> dirty writeback handling. As a result, we can see an up to ~30% increase
> in some workloads like MongoDB with YCSB and a huge decrease in file
> refault, no swap involved. Other common benchmarks have no regression,
> and LOC is reduced, with less unexpected OOM, too.
> 
> Some of the problems were found in our production environment, and
> others were mostly exposed while stress testing during the development
> of the LSM/MM/BPF topic on improving MGLRU [1]. This series cleans up
> the code base and fixes several performance issues, preparing for
> further work.
> 
> MGLRU's reclaim loop is a bit complex, and hence these problems are
> somehow related to each other. The aging, scan number calculation, and
> reclaim loop are coupled together, and the dirty folio handling logic is
> quite different, making the reclaim loop hard to follow and the dirty
> flush ineffective.

> This series slightly cleans up and improves these issues using a scan
> budget by calculating the number of folios to scan at the beginning of
> the loop, and decouples aging from the reclaim calculation helpers.
> Then, move the dirty flush logic inside the reclaim loop so it can kick
> in more effectively. These issues are somehow related, and this series
> handles them and improves MGLRU reclaim in many ways.
> 
> Test results: All tests are done on a 48c96t NUMA machine with 2 nodes
> and a 128G memory machine using NVME as storage.

Hi Kairui,

We have tested this patch series on Android device under a typical scenario.

The test consisted of cold-starting multiple applications sequentially
under moderate system load (some services running on the background, 
such as map navigating, AI voice-assistant). Each test round cold-starts
a fixed set of apps one by one and records the cold start latency.
A total of 100 rounds were conducted to ensure statistical significance.

Before:
  /proc/vmstat info:
    pgpgin 269,224
    pgpgout 226,078
    workingset_refault_anon 237
    workingset_refault_file 27689

  Launch Time Summary (all apps, all runs)
    Mean 868.0ms
    P50 888.0ms
    P90 1274.2ms
    P95 1399.0ms

After:
  /proc/vmstat info:
    pgpgin 223,801                (-16.9%)
    pgpgout 308,873
    workingset_refault_anon 498
    workingset_refault_file 17075 (-38.3%)

  Launch Time Summary (all apps, all runs)
    Mean 850.5ms (-2.07%)
    P50 861.5ms  (-3.04%)
    P90 1179.0ms (-8.05%)
    P95 1228.0ms (-12.2%)
    
--
Best regards,
Xinyu



