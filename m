Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA735F4645C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 12:10:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 439B76B024F; Mon, 16 Mar 2026 08:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411A66B0250; Mon, 16 Mar 2026 08:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33AC56B0251; Mon, 16 Mar 2026 08:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 249EB6B024F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:10:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B77C8B6FE2
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:10:56 +0000 (UTC)
X-FDA: 84551810112.20.A31869D
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9E7451C0011
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:10:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=THijrbDZ;
	spf=pass (imf21.hostedemail.com: domain of linruifeng4@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linruifeng4@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773663054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FqwcAxOJCbhiZeuFzL04Msz0qZf3BQQOe/PDfE7dioc=;
	b=17N9CS2DtxBIMe6vK9KE8jwjOV8ClTU+dYXA6MXJ50z+ZZ3vQBh0kOgzt43lM92hXjm/VW
	aupx9TMe3SLWC2Rd2MLMemXmTzR1vzNtcdONAPix9bC0E5BEdKytrmoyidH/5t2VC/6Bio
	T0mm6VU4SQGPzmg90cB8ahZiwzsJ7jU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=THijrbDZ;
	spf=pass (imf21.hostedemail.com: domain of linruifeng4@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linruifeng4@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773663054; a=rsa-sha256;
	cv=none;
	b=2ItrNW0tjWNcsZvfUK8ztHZucCcze931cYKCP5SkLCmLjpO7RjQG3J0sMtDnbANsyzsxoW
	R+UNVJ4IBbnGRWs49SCCyv6ryWfUO3Od6y1M7xwxxIZIwS8u3BWpUrXyODW1d7I8GwGqaf
	Yre7yjG0Q08/zvjkNBa7YsDFjRV+NCA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FqwcAxOJCbhiZeuFzL04Msz0qZf3BQQOe/PDfE7dioc=;
	b=THijrbDZdCGyGhrRRLCS821D0s6pyScm/Ffm6mjNo5y15g+8tQMYJopPEWaf0bRzM7q2Wy9t3
	uapbLli0ceFZ1D7gMbOeSBlyXD5MkrEVdDZ7VYnS9zw4IVlvpe7oOYHu3houTABfRjdTq/Zd0gF
	Sp4KyBLMd6AzBLdI4BT0MVI=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4fZDLY3kLHzpStq;
	Mon, 16 Mar 2026 20:05:25 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (unknown [7.185.36.8])
	by mail.maildlp.com (Postfix) with ESMTPS id E7E7A40538;
	Mon, 16 Mar 2026 20:10:45 +0800 (CST)
Received: from huawei.com (10.50.87.63) by dggpemf500012.china.huawei.com
 (7.185.36.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 16 Mar
 2026 20:10:45 +0800
From: Lin Ruifeng <linruifeng4@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <joro@8bytes.org>, <will@kernel.org>,
	<robin.murphy@arm.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] mm/mempolicy: NUMA mempolicy mismatch during remote access
Date: Mon, 16 Mar 2026 20:04:24 +0800
Message-ID: <20260316120424.1535575-1-linruifeng4@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.63]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500012.china.huawei.com (7.185.36.8)
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E7451C0011
X-Rspamd-Server: rspam08
X-Stat-Signature: y19o55szednm7eg5khpdpjuwahw64y1h
X-HE-Tag: 1773663053-72422
X-HE-Meta: U2FsdGVkX1+lV+ObCBB8Ilj8+TJkzLH06xC3/e+0cNkyil3gG2LVYiwl8YvpPQWldt6TVyrwIHTalGOB9+BabLIX+Vy6POIiezBQ9lFQOXkMeSwlh7eEI4wd7M/y5wVL3QSuyz1AK6RowmAy2pHa0wMbcE4JOUa0F9D1E+aQOL4yGGrtve3YcUHIDkLi6OMjZ8Cib07RnjgR9mWTZncuhrJpfwzAafs93a76Ks7UObTd8vaLT6as7TD+p+W1UG8voj71H84OVJ6yeiduceNvNO6/Eh5Fd2zH4CTLUOGJIRWWssDlRdjNU5T39k3GM+15TGpdT+3inbphOmpm+5JNVHYjIqimpgiKrgDAZ6FLu1WkDsCShYPEB+nqNYARgZEa02abZy51y2vj6GPlzUQm5V8SO9al+IKWIvA5xF9L+RODLXMg1mm+N5AaMmmmi+WLpeUDIV1m1QSx8guogzsruwOlHUMVc0r+F1G8u4TxWgr0Xe2XXipHfCtkRAZF4Or/egVCLiT1laNucow4w/SY2oon+cP/Rq1WgdmNmhoT2S0CHqm8mz6GAYB8pJwiUAIXXn7XVHwbMOYp74S2D3QoY2CXzNhh5XPIdk8n6OG2vjNI60yE8ZogfBYdBekHSx4PUTvL0HXuGF3bh/mqtlyIhClbH0jSuo5z1Tj7m35OMlHfY/S3TVPviP6pA9hAHG97CVC9DXOQb/SKqobrtsPxJ8u65DbbGFuxKxD4RKf7UpUUDljCwnR13c0CkM48TqSE+VttMjgXbA+1CatBgYxPcSVX7Wl23PfesjYV2GwpesIn5Eq9yMmUpIusWWDpQtiN0sR5o8UAbs41iOmziPRHg7f6Adk9pOhl3ECvgxR3pYk4gBuQFEuLnnVp18I07LshwdimKwf9fF9ig/EX5Vp6g6nlNGSQkik2TOfgq1RBERdTNdUoQ4HAXn3A2hXyucb730K8SHNiHHciPbRsprk
 OOAwpEpa
 QuWJ3YXW66iD8Mf8jI4j7viP6AFwLV2hlXiVMoD3kyjmthszHHgzeI7tKcuSlk5RVAWnU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I'd like to report an issue in the SVA I/O Page Fault (IOPF) handling path:
a NUMA memory policy mismatch caused by deferred workqueue processing.

When hardware triggers a page fault via the IOMMU SVA mechanism, it's handled
asynchronously by a kworker thread. Although the fault handler correctly uses
the original process's mm_struct for address space mapping, the physical page
allocation (e.g., in do_anonymous_page()) still depends on current->mempolicy.

Since current here is the kworker, not the original user process, any
task-level NUMA policy (e.g., set_mempolicy() or numactl --membind) is
completely ignored. Instead, allocation follows the kworker's default policy,
which may run on a different NUMA node.

A similar issue was also discussed in [1]. I was wondering if you might have
any suggestions on how to address this issue.

Link: https://lore.kernel.org/linux-mm/e2d5f3a5-f6f1-4567-a162-a0e814292738@asahilina.net/
Signed-off-by: Lin Ruifeng <linruifeng4@huawei.com>
2.43.0


