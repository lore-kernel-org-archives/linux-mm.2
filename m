Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 930BBD6ACEA
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 11:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 065656B008A; Thu, 18 Dec 2025 06:46:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0124B6B008C; Thu, 18 Dec 2025 06:46:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7DBA6B0092; Thu, 18 Dec 2025 06:46:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D736F6B008A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:46:03 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 87BF6140E88
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:46:03 +0000 (UTC)
X-FDA: 84232413006.27.459D741
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf10.hostedemail.com (Postfix) with ESMTP id 19A73C0012
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:45:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=LBe6fnZv;
	spf=pass (imf10.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766058361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CpAStHn7JZSnDr8vJLXdNCUTlpmuEqTzxHxKyFF1tCo=;
	b=S2pr1da5dJ4vlpNGcdvEADOqb3ZVByl2S07+T+V20r0BUwPt2qIsoZI/vfpRNxooWZjTGG
	LjHpqHsqQhOjD5cF2FU54Y5RhwXt6jEYhQeYdMS5AY/urOvqnjQ/pHBbgC0I3D3xWbiXHT
	f888tMf13d+f9Y7YFvi50vBacc1HB0c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=LBe6fnZv;
	spf=pass (imf10.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766058361; a=rsa-sha256;
	cv=none;
	b=YxidBhUOkNg5B6VhpVvX9AV1AAQg+FDhu5Z77xuHjRP8iC/GOzDsU/NSzW97kuiaY+Kntm
	4dNCnVgR0JyCj8aGZw86BaiiZIKHOlW7Ll11fy1M21XtP6K0Z6N4R4EtJ5w8q76bq+RdIi
	3jnj5dzGHE9WOhmeAftGeiSrT3bC6r4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=CpAStHn7JZSnDr8vJLXdNCUTlpmuEqTzxHxKyFF1tCo=;
	b=LBe6fnZvbVt0X3DqGRT4dUeMi5GPkdtPtZLX8TvdUonQrPNnZgIISDWKF/NzJ/G+vu10JhM5w
	7urW6XcnuX5fKJYeTa51kCfrJkjg/cT0KyDMuQUn5sttONECh18wF8pIaEAuXIGf9A2PZn6f+rt
	Hmt8uwzFhRlNrk2/n1keAd4=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4dX8125TyNzRhRm;
	Thu, 18 Dec 2025 19:42:46 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 6E39D14027D;
	Thu, 18 Dec 2025 19:45:50 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 19:45:49 +0800
Message-ID: <86834731-02ba-43ea-9def-8b8ca156ec4a@huawei.com>
Date: Thu, 18 Dec 2025 19:45:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jinjiang Tu <tujinjiang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox
	<willy@infradead.org>, <ziy@nvidia.com>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <baolin.wang@linux.alibaba.com>,
	<Liam.Howlett@oracle.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>
Subject: [bug report] memory leak of xa_node in collapse_file() when rollbacks
CC: Kefeng Wang <wangkefeng.wang@huawei.com>, <tujinjiang@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 19A73C0012
X-Stat-Signature: hq9pcnof4crog8m7trrfgdrqnqxd68q4
X-Rspam-User: 
X-HE-Tag: 1766058358-600046
X-HE-Meta: U2FsdGVkX1+AEDkndAvXNSkKWk8NkW3crMZDl3pgap57BGFSedanzMJmjNmlr/HdbO5vN1XdtMlDY2hfdzbl5EBLONJU5FKK23UjMQh/bGWrUPb7o+BehIsYKZKLcMzWd0I+ECYLhuH9W36Vqchl7gjGhihejAPfKkch1FpELK9oWYNRtVHY6cYKL5sobbekKJnca8kCTadpZZST5snZa7/Ma6TZa0L1RX0aCCy/leop0faFWFp4tZH/9uclNEcWh30LxxUEy3tPnEJxBNTnuwQf5vsXPMPFmlUiWPvDZtRCtv3Hwe+v2OimRgZpJTNRgMojgWH85IgvAOb+NCedHLge3fUo1ariJDeGt65TppuvaaZ869IEiAea10/Ayaoh2PJrWnvyznX9ZVngA9CVi2kafLcLHl3oOEksHWwyOZrT5a3b/AYeY1lvIxDRErLJSBDQwCL9DTF5puGGXjOQt30f1bgXWPTLm3THSSb5334DHwQnjogmZuk3piekvWhGo0Hc+kKq9nJBPlANQDUz1KMO57X4chrSck4OY0xy98Vk7XseMuqc1dA70xdSmlGQvEqH67XIeXRRPY9MJZ19QZzT71Bob/Cb64Op3daN4euNAYfAIMzFaOyuCYIQSxUQbn60iW0zu3RUK8njhzYPoNEsN1gC+qyJNBdnUPQ3bsFozSh1iaQttDWmxQhV6i2S1IQJ5Snx3ZAKXKyjJXbDlJpSLlP/lLQ38z4jPQObaiTgnYAFeYy2CntOmmSCD6mcVwX2eFy3PzLR4yqz/NQmwlt8yEd/l8qzAW3n0HPEXHPGULNmhlNIE6K6uLYedFmnGjmg0Uf/MfhMWN/0CWHPmDziroyq8cwQ/c47K1TEe/XqL25XwK8tvHV9z5I7uAboEjxnPYOUM7xpfgOM4O2jpttE00KZugzQPjP17o9aZXHz1BEmyffE/uppuc6XpXacOARkkyCR+0obsqqe3S1
 AWBh4F3R
 uKCWWYuYUKKQaRyLQf/Kmh9DOu8lrNdrQ4AjCmir0BNmU9sfH2xaey/cv8mkUDFVKNanKfex1y7VkUMNzwOVu0EH+HB6KbVWLe0pibbbUmYXCsg/AaIzmBZ31w1NBw8n2aXDZ3Owso/srrTaBp/Tm6xRbiT6vKMu1lPjoMxNnGuRQX0TOyHVTQaxhuelmct4V/CDXdBh/yK0FTvubvc50uEDjitKHj3Nf7w6HjtKVV1jlF/n4uA0grPWczKQCtxLUQ4I0wS52KeDnzVCBSNmO4+bGft8MZg1l+SMru+H5GipQ1TQO8nqHZWH6wYe8xdMBS7dROEFR7cJoHcznTkgNvqRcEzy39VyfoOgiKQnE5Il5h+0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I encountered a memory leak issue caused by xas_create_range().

collapse_file() calls xas_create_range() to pre-create all slots needed.
If collapse_file() finally fails, these pre-created slots are empty nodes
and aren't destroyed.

I can reproduce it with following steps.
1) create file /tmp/test_madvise_collapse and ftruncate to 4MB size, and then mmap the file
2) memset for the first 2MB
3) madvise(MADV_COLLAPSE) for the second 2MB
4) unlink the file

in 3), collapse_file() calls xas_create_range() to expand xarray depth, and fails to collapse
due to the whole 2M region is empty, the code is as following:

collapse_file()
	for (index = start; index < end;) {
		xas_set(&xas, index);
		folio = xas_load(&xas);

		VM_BUG_ON(index != xas.xa_index);
		if (is_shmem) {
			if (!folio) {
				/*
				 * Stop if extent has been truncated or
				 * hole-punched, and is now completely
				 * empty.
				 */
				if (index == start) {
					if (!xas_next_entry(&xas, end - 1)) {
						result = SCAN_TRUNCATED;
						goto xa_locked;
					}
				}
				...
			}


collapse_file() rollback path doesn't destroy the pre-created empty nodes.

When the file is deleted, shmem_evict_inode()->shmem_truncate_range() traverses
all entries and calls xas_store(xas, NULL) to delete, if the leaf xa_node that
stores deleted entry becomes emtry, xas_store() will automatically delete the empty
node and delete it's  parent is empty too, until parent node isn't empty. shmem_evict_inode()
won't traverse the empty nodes created by xas_create_range() due to these nodes doesn't store
any entries. As a result, these empty nodes are leaked.

At first, I tried to destory the empty nodes when collapse_file() goes to rollback path. However,
collapse_file() only holds xarray lock and may release the lock, so we couldn't prevent concurrent
call of collapse_file(), so the deleted empty nodes may be needed by other collapse_file() calls.

IIUC, xas_create_range() is used to guarantee the xas_store(&xas, new_folio); succeeds. Could we
remove xas_create_range() call and just rollback when we fail to xas_store?



