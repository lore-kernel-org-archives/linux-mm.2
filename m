Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A753DF4385A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 16:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8918D6B0098; Wed, 15 Apr 2026 12:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A546B0099; Wed, 15 Apr 2026 12:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A6C66B009B; Wed, 15 Apr 2026 12:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 678356B0098
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:47:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04C18B9C00
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:47:35 +0000 (UTC)
X-FDA: 84661371312.24.5C684CB
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2F0361A0007
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:47:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of fedorov.nikita@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=fedorov.nikita@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776271654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5JOeBNkxu4emZ1xR2H2OG6CLtF/UNlFtnq0p1aEYiSE=;
	b=g5MQn43f6bJz6QPjvE29Wg3Id+O4H56bUdPD8ALpgrjbPtjGvx2l4kSxQv9E6Nu7KBGfUK
	xhXETNlwUvtBim+YmUfmkoEyP/zjnpLyTQLQyE8GfGsrUq4naueJtoKdvtGFAYRL9dLUFc
	ErGB+Lmr8epJ/7FiSi8THQFJmSUAKmU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776271654; a=rsa-sha256;
	cv=none;
	b=mTi+p0tar0XyIWUtlWNwas4N3tL5aa/qF7jju97qG2gjQvOgp158bpjUu8X35tPadBn2Q+
	VN3kKguve3sCAh8/ZUciEJGB7x0/7gKL2B4KC4lH17y5tEGmSR3jOIc88HyYTw8edSBZbi
	ByeBpXt0q5nTiqYf6IxgiBYtlGMpj/4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of fedorov.nikita@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=fedorov.nikita@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fwn9v082YzHnGjb;
	Thu, 16 Apr 2026 00:47:15 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 6482A40584;
	Thu, 16 Apr 2026 00:47:31 +0800 (CST)
Received: from localhost.localdomain (10.123.66.205) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Apr 2026 19:47:30 +0300
From: Fedorov Nikita <fedorov.nikita@h-partners.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, Juergen Gross <jgross@suse.com>, Ajay
 Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov
	<alexey.makhalov@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>, Arnd
 Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>, Boqun Feng
	<boqun@kernel.org>, Waiman Long <longman@redhat.com>, Darren Hart
	<dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>,
	<andrealmeid@igalia.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple
	<apopple@nvidia.com>, Anatoly Stepanov <stepanov.anatoly@huawei.com>
CC: Nikita Fedorov <fedorov.nikita@h-partners.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, <guohanjun@huawei.com>, <wangkefeng.wang@huawei.com>,
	<weiyongjun1@huawei.com>, <yusongping@huawei.com>, <leijitang@huawei.com>,
	<artem.kuzin@huawei.com>, <kang.sun@huawei.com>, <chenjieping3@huawei.com>
Subject: [RFC PATCH v3 7/7] futex: use hq-spinlock for hash buckets
Date: Thu, 16 Apr 2026 00:44:59 +0800
Message-ID: <20260415164459.2904963-8-fedorov.nikita@h-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260415164459.2904963-1-fedorov.nikita@h-partners.com>
References: <20260415164459.2904963-1-fedorov.nikita@h-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.205]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: 2F0361A0007
X-Rspamd-Server: rspam07
X-Stat-Signature: 16n8s7ubbjj8q956d4uaacc65w3hbduy
X-Rspam-User: 
X-HE-Tag: 1776271653-562969
X-HE-Meta: U2FsdGVkX1/RoHtc+xQEv0Q/NnojEWxAaibXRiD7oCGLJW5XYTrshkO0BKDdGvzz7hkV8zld6OxNkRDtz34B5XQhH7if1i/DoEbcjjdtxnEtOMn7plATamL6TjoRlfUUUJEZb34O3Tc0zuyFt4cROQd2eaM7Rwvj4+UQbinIIPCLDiOPLEchTC5RDica3EWG8SznBSP6q1wdY4J2zSUAhdoVyPY1cXl8GiSRcFU1WlbfVEw7X1cu1oTMH1Sx4em+8a6k83TyTy2L9KEUfYHOF77EQNduJkCxBpKnpbyhepiETd1a6wp7fsInkZ+DFnSovwYV0iRIHN34FgIIyOQCsACAtkZjWztmLtcqP7sT/suAfRAbTpZKVTj42UsCpE+ztTKxnr1fIBe2HGjvCeBmJJpGZ7fUpFrbYKJD0MUb8JZR8cpkNem/A2qlItl/lT0fWolt963ZGwbhmkqALM7GddTVzCy8ZrJ0ZkCPfTDz094mzIbTisO3psMCmV29QjLZ1x5WmfQBjiM7EFJIBhZx8PzMqQRc96G4AoecciqPTZg0i+K7YfDom76aHJlaqGIV1DZ6Oq/QMnj6NPx9VrPtrbU2dQJDNVj0myE/Xngd/UE6qNrDuB9gIHOJF5cUoqhxK4VHeaxJuwWMphi5IRadEDpQvQIDeQilCs/vsD94T9Wfbs4Ld1VscQhWC9EOFDvau7BozgSB5AAUR1x+JN/mqYBqMBic+C1HasVZbscxtiOpF6lqItiBMclUbBBQWVyECB2d2mtAeJDbMkYiFvHh9bqDbQrG9vmuMXrwlWLj1iMXUxAYPGUZqLCn/zMyvGGV/WFC0GXVolGyUyNFY7IUNFMAfzbjdPNGJPjZhNXf91EIoZ9edCO9bCBoVoTH0jRvKfWJu01EZNTV7XSQsJcBP91v+h0NK4xxNS2KtUqaTU1vZz73OojNmsHb7i004CmiJ1Yi0+vSJf2fieZ+ZFQ
 F4IGlJ5l
 r9v/42uOvqVubKyBL9/S4DGE47WDbGRwS8dasle5uUd721DdPGbbvGRU/XzCPBjNVptYJCN7uIxVyCIsFPt/O1GDnZA4bHwCUJo4ertSWCKGzMCTXVg3Q22ItDGc5Ft7cMlkLhxyy2WtxeeRolfxmZyMbzCmA7zQArmYCHEUAfsW2XtecikBnVHlIGLCOjBZLfpOJ1D2w1V8X09VIxEMnKApC7WDGgTrCo8IjuBLq82HH0pvfqUTHdhYxA+kVzW/SLSgIO+TjgQghLdLMTIEfgYre/MDF2wHZp/cdRsoLG1yYCj7MQLzb503qlwOPz2g/QD42
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Example of hq-spinlock enabled for futex hash-table bucket locks
(used in memcached testing scenario)

In the evaluated memcached workloads, this improved throughput by up to
10% on AMD EPYC 9654 and by up to 8% on Kunpeng 920, with corresponding
latency reductions.

Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
Signed-off-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
Co-developed-by: Nikita Fedorov <fedorov.nikita@h-partners.com>
Signed-off-by: Nikita Fedorov <fedorov.nikita@h-partners.com>
---
 kernel/futex/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index 31e83a0978..042cdc7f75 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -1521,7 +1521,7 @@ static void futex_hash_bucket_init(struct futex_hash_bucket *fhb,
 #endif
 	atomic_set(&fhb->waiters, 0);
 	plist_head_init(&fhb->chain);
-	spin_lock_init(&fhb->lock);
+	spin_lock_init_hq(&fhb->lock);
 }
 
 #define FH_CUSTOM	0x01
-- 
2.34.1


