Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40AF8C44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 13:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 352CE6B0093; Tue, 21 Jul 2026 09:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3039B6B0095; Tue, 21 Jul 2026 09:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5A56B0096; Tue, 21 Jul 2026 09:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA9756B0093
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:26:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75A1612015C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:26:25 +0000 (UTC)
X-FDA: 85012857930.01.BDF82AC
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf28.hostedemail.com (Postfix) with ESMTP id 637D4C0007
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:26:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Uj1oBLm2;
	spf=pass (imf28.hostedemail.com: domain of yuzenghui@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yuzenghui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784640383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9hgq2bOlQdWO8j42MpZzQv278XodO4khDw3hgg8g+EE=;
	b=iSdgWuHOw143mU4pCnXM8TvrV4W6FGGd+g3RJgmiV1ObviUVMycNp1xEitpHCvuqHK2NxY
	5c992VtIzUAPRcyDBxGQ/89G+1igoWENiUXVhIPzkoYzPq/xgOLt3vfRgpDOW73ClPhYDA
	LPWlwQlCYGZVbs4hLIaibEczOlILORE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Uj1oBLm2;
	spf=pass (imf28.hostedemail.com: domain of yuzenghui@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yuzenghui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784640383;
	b=QZa66dIeQ7ZlUTIXRvnTtoLKaZ9atlceKJcePZlgzWje6Su8DvMmzygBXXeT2cArupHnxU
	Ht3Oq2oIRx9nkVg+1foYzK7+zUQjnDJMhjAu47uEIr31SqvcNlIYDcSXlR8IrFWNeOv3LC
	SPZlLsYAphOZxL2iMIJXvQVbNRKQ0Yc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9hgq2bOlQdWO8j42MpZzQv278XodO4khDw3hgg8g+EE=;
	b=Uj1oBLm2piRS2jcNrVUUdAj64NR7QB2AifXV29XsiXtXTCt8/PmMpEq+nwr+s8iX+TO4SVXy8
	IusYOu5A+t3ilK/5m8l2t6qY1s1aIGuzFz4Xh3ZFK7Gj4qZgTf2WIrFuLXxQw3LkIeDfDM4c4Ja
	qOFsHfRNHFyUbXAQwQgO+MU=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4h4HwR2B42zLlX5;
	Tue, 21 Jul 2026 21:16:55 +0800 (CST)
Received: from whupemo200006.china.huawei.com (unknown [7.152.185.252])
	by mail.maildlp.com (Postfix) with ESMTPS id 668704056C;
	Tue, 21 Jul 2026 21:26:17 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 whupemo200006.china.huawei.com (7.152.185.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 21 Jul 2026 21:26:10 +0800
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
To: Gregory Price <gourry@gourry.net>
CC: <linux-mm@kvack.org>, <Zhigang.Luo@amd.com>, <arun.george@samsung.com>,
	<balbirs@nvidia.com>, <brendan.jackman@linux.dev>, <apopple@nvidia.com>,
	<alucerop@amd.com>, <matthew.brost@intel.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <corbet@lwn.net>, <skhan@linuxfoundation.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <dakr@kernel.org>,
	<djbw@kernel.org>, <vishal.l.verma@intel.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <osandov@osandov.com>, <jannh@google.com>,
	<pfalcato@suse.de>, <jackmanb@google.com>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <pbonzini@redhat.com>, <osalvador@suse.de>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<ying.huang@linux.alibaba.com>, <kasong@tencent.com>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <baohua@kernel.org>, <axelrasmussen@google.com>,
	<yuanchu@google.com>, <weixugc@google.com>, <yury.norov@gmail.com>,
	<linux@rasmusvillemoes.dk>, <longman@redhat.com>, <ridong.chen@linux.dev>,
	<tj@kernel.org>, <mkoutny@suse.com>, <sj@kernel.org>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <baolin.wang@linux.alibaba.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<lance.yang@linux.dev>, <usama.arif@linux.dev>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <roman.gushchin@linux.dev>,
	<muchun.song@linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <driver-core@lists.linux.dev>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<linux-debuggers@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <cgroups@vger.kernel.org>, <damon@lists.linux.dev>,
	<linux-kselftest@vger.kernel.org>, <kernel-team@meta.com>
References: <20260720193431.3841992-1-gourry@gourry.net>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <a9c52bb6-5e04-1d41-913a-685a7be3fad4@huawei.com>
Date: Tue, 21 Jul 2026 21:26:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.219]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemo200006.china.huawei.com (7.152.185.252)
X-Rspam-User: 
X-Rspamd-Queue-Id: 637D4C0007
X-Rspamd-Server: rspam01
X-Stat-Signature: h1h8i5r6fg451xqn1qhx71mztoihwbq8
X-HE-Tag: 1784640382-301829
X-HE-Meta: U2FsdGVkX19+S1BUaxnnaN2xYb0IL6DPYaqp5kLRhQ9BtIibaxdlO/onZLymVrhEkq+M1oEHO5tnZSlttbSibPg1k1cex0DqradCfeiBXcJshvRjZAPQxHZBeEfM0cyCcU47K9hdGLxL4q7AoiI07OxMKg6g0AMM3aAKA9SK2SMuWfd6bdPWC3imBHPnp52BDFlVQpH1sdaVKZUAZwA2MWAtbCHS7P+zySgyzAmuc7JqX5OgWaPXHxxKIT9wHPPreuJgTxc880xJh6QjRVaeHh2nTo22osc+BAFQxQRc4lgpszOx54osDK5pI/Rb19m2uuAY6VZ8TT3Pu6+Z78Dq/MmfLXx7luAR5X/1OSPS+mXSSe2SURAk83Vn/32YlIHcW9PvzbOyUtgZU+O3DjH3FaRVjTcNGEGKHHKlU+qzY2D+efPq7+RZ6a6c2mm7KEbf9p4RJ+bGxUJIr28DG18sMPwiST287XinjubFrU3CrVWzZCT/LvrSy70a61Oa2R2/WhkGSM1KT3A9krXgXYqf70u+NxEDJDHqc48t0fE14CtFrKHy2KNrxw6p/WXv7d5O8pQPHaLhpSNN8DlcaDtqeJ6vKa/HWunWB8+yG9cWgq6ogHwpUE1khIR7yFuo/koXpImZBeD01OrbrSaAT0aGjJbfredi2t8/Qxkrphz5Mxaf7ZqrH7Y668yBvWn4ijCgOhGbgFNxRuqbQKUetGwHe4JNNvl+lQHywgaCdvP+3mES0RJ3bvLP5pyvX1c8m6WpTwuu3eRLd7oicCIws0v6njVkRiTN8t46yTsAMQOHuUumZoJy8r4aPJSGr9r49HzuGH5WbviDnaxjpZPJrN7rA1JKm4tTsMGBVxWFdE4HJrSz9AFE8UHbF7sBA/ae97pTjNSviMB96kGsWfmDmDPIG4v6w0IUo1wlsd6kNs9MVcl/qbMFfGEJ8oW2l3yUDLEzoUXkaMv9ukh1PwPM4RS
 DlWFs3XG
 PU8MVEfaxpLWN1cCuP0+nJVnnRrSC0reBaEHubwW6CjYQjvxsKgtZW7Ckx8kZOqiN04Yad3O+PG5eVpVwC+JXrt0Rrm8sMgUrHmiNvCvHcheC5u5gIQDJ01sGyMl6o2UvslfdNAgCOCQ4ZwuEcrQYRDEmqtfukCTxuTRI73kQMqT5DpBhWucJZywpSv9HQUrvMpjJikH6OiKLFQi7mCM5j5LIWHOe29TPy3sw/EFwPs0kvgGZzzKsIBF4JGOXdD2kPWT7ttwEpSErQVD3AQ5e4oXburSeJeX3sBX5Zw5IsLp+rCJpt2BCFHUcoqW9DDtUrQ5aHnIHEOY0T+oJaNs4yfj+KH5t/jQeZ0a8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/21 3:33, Gregory Price wrote:
>   KVM: guest_memfd: bind backing memory to a NUMA node at creation
>   KVM: selftests: add a guest_memfd FLAG_BIND_NODE test

I can't find the last patch in my inbox or on the lore. Not sure what went
wrong.

Thanks,
Zenghui

