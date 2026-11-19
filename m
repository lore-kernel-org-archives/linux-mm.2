Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B41B60A263F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 06:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=W4uSz27O
Received: by kanga.kvack.org (Postfix)
	id 425C86B05B0; Thu, 19 Nov 2026 01:40:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6776B05B1; Thu, 19 Nov 2026 01:40:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29ED26B05B2; Thu, 19 Nov 2026 01:40:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00A516B05B0
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 01:40:54 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CFEEC80997
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:40:53 +0000 (UTC)
X-FDA: 85450920786.24.3D79122
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf13.hostedemail.com (Postfix) with ESMTP id A07A020003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:40:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=W4uSz27O;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=longwei27@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795070451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qmyNQOgDSlHi7bLgEAYFmsoW4l6Q4fZQE6fLWxCxItw=;
	b=OsZkR/ER3DPO9uamCgVXInFQIWmX96OtDhwKeXP/Y3d8Poarry4/dKQhaKrZHzMN6Q0yP5
	64Wx8XBMnNLmGo0nuMKkHvwjUqvlScM03i8lPlYkNESWuMhMkdxEQSg9QJWNensYVSRI0Z
	MGNoyQywq+CbvwhvDFacpuCvs7PSTZE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=W4uSz27O;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=longwei27@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795070451;
	b=nx7pl4ZxKBP7XPr2EMPttVc2cXLmmP9KqMKWGdVS4C7nzAEwmBoLLXunA701ARSs/tQKvW
	FgKNlI5HlqjxkLF93LXMI7OotWRIml42dpbns5mHx09eroDTdODvZ2T/L/Byd1sNGh8KxM
	EOZQxQZclMpsbzR0KP1yp4WG4v2s4uA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=qmyNQOgDSlHi7bLgEAYFmsoW4l6Q4fZQE6fLWxCxItw=;
	b=W4uSz27OCn1hv14o2GwFcqRRNsK4bkfn/keWtNk8SFs3aS5cQC/aXA8NrNCJBiXIS7NWYn3rB
	am2gUnQr+JiglTJSQs/cy4O9g0qu8V6w1mUYELJ9F3e5Cv95XWWdjExwCPEvZ/SLq7sPq+wHIT4
	7gVJPorGh8kEDTF1Bk3DywE=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4jVTNW2yFKzpSvH;
	Thu, 19 Nov 2026 14:39:55 +0800 (CST)
Received: from kwepemo200009.china.huawei.com (unknown [7.202.195.26])
	by mail.maildlp.com (Postfix) with ESMTPS id DFA844056E;
	Thu, 19 Nov 2026 14:40:46 +0800 (CST)
Received: from localhost.localdomain (10.50.159.234) by
 kwepemo200009.china.huawei.com (7.202.195.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 19 Nov 2026 14:40:46 +0800
From: Long Wei <longwei27@huawei.com>
To: <rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<akpm@linux-foundation.org>
CC: <graf@amazon.com>, <leitao@debian.org>, <corbet@lwn.net>,
	<rdunlap@infradead.org>, <linux-mm@kvack.org>, <kexec@lists.infradead.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<hewenliang4@huawei.com>, Long Wei <longwei27@huawei.com>
Subject: [PATCH v2 0/2] kho: drop the incoming sub-blob debugfs view
Date: Thu, 19 Nov 2026 14:37:58 +0800
Message-ID: <20261119063800.698863-1-longwei27@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117092951.4017931-1-longwei27@huawei.com>
References: <20261117092951.4017931-1-longwei27@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemo200009.china.huawei.com (7.202.195.26)
X-Rspamd-Queue-Id: A07A020003
X-Stat-Signature: 6o4nmfcu8c9x6txiyks4yz4ud7nkqcoc
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795070450-78723
X-HE-Meta: U2FsdGVkX18B/HqDTe7FbUf0B4XRepjfr5cU/stBdP7v0om7n/+awuRarMOawtE2tOlbj4fm53WkR7F9vZELU5qpL2teuiwLwl8n3cvxKn75mqXhBL0CjFL3R9Lkw8iNanU733J37N5jO6rb1j/WPztyvHCyAZEf8A1SZ5DeEqDnO3h9i73F8ppzErmlftJOWWmvx5zfW7Cij6r/PlKXGcUCKJ9Lp+9oWttO0QOajQxgTN5vAaEreoJafTIMkCQOlT/M9hTDf+34T408AEC/a22Q/1f1zqhPZSqiYldor4hHa+Gn3pXal4zeAzQkE+BaDuHPx83oLfeaiYXTxI2AiH1MNIyAY5w/mzvJtKgQ04S2dgh3N+qhRzawCG6ltgF68/f/g+E/ukxIbnLl4nSEM/bhzND9Anwzq7BtsdEFaK2GNH1MgwzNm84eogJi4m8QdB4w4mZAgRcSyWlcl340e7Vrl/S+o448HqTaPos9So0icZCTjaofKhDJZzmkki/P2CQHYFzePsSQIfjSnS2pjFDfNmOPmrqPGkqjFBHqWP57wHtCQm9ebQgukx4kTi680IgT0dPJX6QebukMuL6EkXclEn/JmD7MitQSlDQlC18asombxCAlBEVgUmGSas1Eky/6nbJb/4kw+/+j+iKVqRlt1i224LbUqJgOq+MBWYSjiZzrZpYhOd1K54akecYCFPSXIxD6vXC16ReMBSIKXluVLVP03LcJbAXU165tWVJ+1boAbUI+ZzgpvCNjQt4A+JOhl4VE6VopsTcgksaH8ea7iqyrSzfKncjprhTqLz7fwqTqOk+Ldw72x76CYyNKBcVd55ua+P6RzssgGsKEh+OfJlYxdIboPE1lg1GREBtzv9OGvkT4HESCy8TN8s0VwJWI7NUvpKhQkiLRuMJ8HYoNXY99e1PLLjauRSvtaROn3KdkrqfYCUKVbYjUNGKkYwo5YdHAxYyipWhlwC+
 ZWE/zjfe
 DwU4WNwoWT3vmBT/7D2zn2YdQMx+Q144uqSuzX2tQ/ZoJ761yi2rg1bKVXy84tG8KGWn/lU8VEWXzevIgLGzaTkGlbxMoM7Qu77GHwEa1lVCgCKoPRb0AoAZUbqsqk9J3v3entcfwp5Mq9Ls7MdTocHfLBeY/bLEifW2C0xDAEuVl8OXoy0CKFgnSL5zVaRUNBlycT9nsQKYHYBz0NPqSyEsKcovDE39TfJng9SlC/o55egHqoITo/URpMIRIfNcfD3hwaxBY9hLBy9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kho/in/sub_fdts exposes the raw contents of the sub-blobs described by
the incoming KHO FDT.  KHO does not own those pages: they belong to the
producers' consumers and have independent lifetimes.  LUO, for example,
restores and frees its state in early_initcall, before kho_init()
(fs_initcall) creates the debugfs view, so the blobs point at pages that
are already back in the buddy allocator.  Reading them triggers a KASAN
use-after-free in _copy_to_user().

The same information is already available to user space from in/fdt,
which KHO does own and which stays reserved.  Drop the directory rather
than adding another interface to describe it, keeping the -rc fix small.

Patch 1 removes the interface, patch 2 drops its documentation.

Changes in v2:
- Drop the in/blobs metadata file entirely
- Just remove in/sub_fdts to fix the UAF, no replacement interface
- Update Fixes tag to c609c144b0e8 (the commit that first added sub_fdts)
- Remove the now-unused #include <linux/io.h>

Long Wei (2):
  kho: do not expose incoming sub-blob contents in debugfs
  docs: kho: drop kho/in/sub_fdts description

 Documentation/admin-guide/mm/kho.rst       |  4 --
 kernel/liveupdate/kexec_handover_debugfs.c | 47 +---------------------
 2 files changed, 2 insertions(+), 49 deletions(-)

-- 
2.43.0


