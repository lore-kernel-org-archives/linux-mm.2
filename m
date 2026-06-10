Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7A86CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 16:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAB756B0093; Wed, 10 Jun 2026 12:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5BE36B0099; Wed, 10 Jun 2026 12:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71F56B009D; Wed, 10 Jun 2026 12:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8D796B0093
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:05:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 41140401CF
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:05:47 +0000 (UTC)
X-FDA: 84864478734.14.26B3F62
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7449040016
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:05:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nrWIoDKy;
	spf=pass (imf11.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781107545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2V2RUhrXPIimR4T40VXauLQZeNDjNsD8HdjcYMWnYS0=;
	b=Yx394MWTUV+mF/WnBpMt9k2WmYcWDpNSLTHRt28SNsypNHV8wdplHsWc50aHdBCGbYW+oq
	mRWnN+eOj5xXweG8ZjnhP+d4T0vrNofloxvSsGJUsqqv1IntnncGrgwRLYtZe3YhCmFLX+
	7fIlR8NVA/bzvSllO/7nnLr4YfbK3jY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781107545;
	b=5rVd3IycTE7R8oAft4XrMV8duxF3dcfAA0LITG/08pcY8JTiYo2SQxw9WGIbdyXa2aewXD
	v8xuyLiJyzn+CMJ+kylMGsnHDuSeL51kOwAwjNoNETWpeMG44Wxxv3yDD33hzD5KEGufiF
	dMORWH6vvkqDL2EDK7oVGL4YxhSE+28=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nrWIoDKy;
	spf=pass (imf11.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781107541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2V2RUhrXPIimR4T40VXauLQZeNDjNsD8HdjcYMWnYS0=;
	b=nrWIoDKy0MbkFSu8sLo1UUHy34gIckHVi2ISYgpbq9jHBNeMQGaRRbilRslDJNGlEdAdZ8
	/PQl6FvJcpXAaHsDMQxYlHiqLMZiTCcdIIEUaL+brL3NLhVlCdZp4g7i4u6+JQ+yCLdfPr
	FxCcT74FgD4Of9hYEO/tg+ZKI+zdexk=
Date: Thu, 11 Jun 2026 00:05:31 +0800
MIME-Version: 1.0
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
Subject: [zswap?] BUG: sleeping function called from invalid context at
 kernel/cgroup/rstat.c:421
To: linux-mm@kvack.org
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com,
 chengming.zhou@linux.dev
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7449040016
X-Stat-Signature: bmx3owxxyrar6st39o34rae8mmn13p1k
X-HE-Tag: 1781107543-590708
X-HE-Meta: U2FsdGVkX1/4R2SRDnpg9JEA7eAjThuq7TmDT1zfJ3ntwT3Mrpq0mCJQRP9FlmaAmua14UTV3jH3l2sVVMGaERfCjnhCVweB1AGyDpH4eGRJudOBBMW3w3qnly+ZOcsnJqZyGKMzfScxYCY5nFbzhboCvRSd1vGzVmxN4XNut/zNU0pkqGMQRqMPfAOHXBmDC+xdT28hnZ3rCUHNv3l3qUh5rupX/idMLe7CKwlinLUMaiFZOj6H3kksZ+088jwVT4/U+DYd2vzeIdWy3H42UtS2oNq0gIQDHXiZbGaiowkzS3roonyVWbleEONFOtkzyZNaDB2I+VBGLRC4lVyF4xM+kFebjjLYesNQ2WlMRYESXRRj/qpN9Er/i9fp/zoxQPjNwBHCMsV9GtC0Bgv2kvPKItd2/aOo6AiR+roRWkK529XnJFrHoYwLG0/QJVJM7zdqirNZSk31QrBQBSXokeXzAIVywymsCM7LOBUZMd9wB5OrZUmZGGruiaZEsF8pAIwa0NBNzz9ENjj3ZaEpTCFrJT191AgBn4vm1KN2E4ni0VFcRHJurv/cWYCMC09HAdi19tnhuVM4mfFqrJP+GNypV/O2VjgW+9CaPeiUit/RH3PLZuCPpK132QgxFJEBL4sNQKMT3RqEgn9JD+xFqWn18k/tKB05QfApiFBHjN0sJ+wHNmMcBED37FGwflV3tEpH9RYlGMYxccBT992PUkdoYfg0Pqj+ogDFlW10a2wfx7FkrPduq2Gz1CIkZL93a8sr+kfRA8+ejH/mwiykRQC1+eegB3oi28FUvR2sj5i/GvGZxxfrqjOjUDOD26WR1pVgkl9zFJ0onJ20pwu8Q6yV1Y8VTZg4b3nvXgonYT09yofAQIN+qeP0LlXGrMprnDew/ym07GSQHI/b6yQHgyIS1zQtDBAEdaDOrGOZ1KrCQ3BLvJ1OEk/ru740dzGlTtXACyh0GC+qhV/GUoa
 LkOebg0v
 PPPEHrsC2Ug931ZQ+oCQb60o+yaqN1phclddwxRQuf6iohPcUoMmCN/lviCFRv+XfKA3xoaWfrHBIl2ZXi8TAtdKOP0voUghMKu5O34BGZXGQPa2O7vf7eL+ZoGgGFPOSKVjueNIa2XcMfveR/uQmUWSnRKhgI/4iAhxgoTTUyQNzrhe3iyNo2gmtshdca58BXRVn1aSpgedSm1ycsdeRMevAzVl6YDY00WzPWWpHqaBc8wUqouqFQnAjvmGPhtcalLnRhT12HtYBXbjgZfZsh4RWHqb4zUSJ9MmNWCbN9eSTRf+5AcbmfZTXPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

The following splat was triggered on the mainline kernel:

 BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
 in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1126, name: cat
 preempt_count: 0, expected: 0
 RCU nest depth: 1, expected: 0
 CPU: 7 UID: 0 PID: 1126 Comm: cat Kdump: loaded Not tainted 7.1.0-rc7-00056-gacb7500801e9-dirty #304 PREEMPT 
 Hardware name: QEMU QEMU Virtual Machine, BIOS edk2-stable202408-prebuilt.qemu.org 08/13/2024
 Call trace:
  show_stack+0x18/0x24 (C)
  dump_stack_lvl+0x78/0x90
  dump_stack+0x18/0x24
  __might_resched+0x114/0x170
  __might_sleep+0x48/0x98
  css_rstat_flush+0x54/0x564
  mem_cgroup_flush_stats+0x9c/0xb0
  zswap_shrinker_count+0xe4/0x1e4
  shrinker_debugfs_count_show+0xd8/0x268
  seq_read_iter+0x1b8/0x4ac
  seq_read+0xe0/0x11c
  full_proxy_read+0x6c/0xa8
  vfs_read+0xc0/0x2fc
  ksys_read+0x68/0xfc
  __arm64_sys_read+0x1c/0x28
  invoke_syscall+0x54/0x110
  el0_svc_common.constprop.0+0x40/0xe0
  do_el0_svc+0x1c/0x28
  el0_svc+0x38/0x128
  el0t_64_sync_handler+0xa0/0xe4
  el0t_64_sync+0x198/0x19c

The kernel is built with arm64's virt.config plus

+CONFIG_DEBUG_ATOMIC_SLEEP=y
+CONFIG_SHRINKER_DEBUG=y
+CONFIG_ZSWAP=y

I can reproduce the issue with the following steps:

    $ echo Y > /sys/module/zswap/parameters/enabled
    $ echo Y > /sys/module/zswap/parameters/shrinker_enabled
    $ cat /sys/kernel/debug/shrinker/mm-zswap-60/count

Please have a look.

Thanks,
Zenghui

