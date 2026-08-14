Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD3B5C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 08:41:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B0896B065A; Fri, 14 Aug 2026 04:41:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769296B065B; Fri, 14 Aug 2026 04:41:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681CD6B065C; Fri, 14 Aug 2026 04:41:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4479D6B065A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 04:41:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF7BE1403DC
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:41:46 +0000 (UTC)
X-FDA: 85099231812.08.4583E9B
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf06.hostedemail.com (Postfix) with ESMTP id A4350180004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:41:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=byolz25j;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786696904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmBTxvXk2uM+Jy9SERybidwxfN4RThE8kHyyWABO2k0=;
	b=34Nj05PNdKMBqKlh5GZZDucMz7Dk4RLa7wABAI1FFWjLxcIPp/n0nT66pDP0nboUa98vOU
	HxFs/7Pxv1j6faYdS4sN+xlxPMXQsYqANSsRyyZdtmt9CLSEq4vp6E3JxOv1H64KxWmNPg
	IIbpZhKELsQATFDCIcSwMMdwUJrPRJA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=byolz25j;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786696904;
	b=kFvD5d24940LY54ezA4nT3G940jGFFkXdRoDFf+ma17Z36hPw60ZfGeY0laTyAeCr29gju
	9KNIphF5QpkDjMthXA61AQGOXhEItjlypV9CprcqGAcZpO046YMdMMcFjNLcct+3ySB1i5
	XVTba7q+Jd/MtYYuQ0qJlQLwxzqktMo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kmBTxvXk2uM+Jy9SERybidwxfN4RThE8kHyyWABO2k0=;
	b=byolz25jrt5vYjOAub+vk/9I5KgD/HjZaDJFz0f/a1zhJfTlR0gXCmHJ3fmKkyARoKcQpxJWt
	6LAIkabqTk/L9oEYEQYfjCA1PB/7qFcPS/wg4WS67daP27yJHdwfhdAYVJgobDLrTkfedcUSBDe
	m0SfUChT6ix32sPFEasIhNM=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hLwRT4P8BzRhR0;
	Fri, 14 Aug 2026 16:31:01 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 11FBC203C8;
	Fri, 14 Aug 2026 16:41:38 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Aug 2026 16:41:37 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Aug 2026 16:41:36 +0800
Subject: Re: [PATCH v2] mm/Kconfig: make MEMORY_FAILURE select MIGRATION
To: Xie Yuanbin <xieyuanbin1@huawei.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<liaohua4@huawei.com>, <lilinjie8@huawei.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ziy@nvidia.com>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<nao.horiguchi@gmail.com>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <gourry@gourry.net>, <tony.luck@intel.com>, <bp@alien8.de>
References: <20260813134916.292733-1-xieyuanbin1@huawei.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <827fab66-1678-dc37-7b3f-e7b0a2987427@huawei.com>
Date: Fri, 14 Aug 2026 16:41:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260813134916.292733-1-xieyuanbin1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A4350180004
X-Stat-Signature: wuesprcptkzice87yppwxpo98ryfoqqn
X-Rspam-User: 
X-HE-Tag: 1786696902-72797
X-HE-Meta: U2FsdGVkX190HHMbP0qDrIMwQcIgP6QHv5EzPmTpZLIHUxsQHviG2ncYWzP2Jcc98Se27Fzdrb8AmV59vknjiIrpM5GfwabS5XCHQ5cVDnoQ805eTxnrxccCtZg7wSHPa2NYiY/K1pObdfvB2d6KQd4REqQfpyGDHXq4MdPlKzqGwZ72RcPJpv+5/6xCt2WVAIcy+AtkaZ6W7c6uPcTvtd7SxEHO+9/TPQ1lFs25n34t7om9YUNa9PSDz3f1K3NaKupBYbOZ2QNZSPtKRDQ4Pcv2d70xGHIswoxNqD0w7+xzJCT6BHsmFBTxa/+vc7fyD8oyVSY78KxZpXUMkV7zTQwUdhf6cGxiko6Jnr/b+rFCt1u56URZBgqk2RjoVTJzDPI9C2PSr1UI6vudACZBGLKVLxjO57JO/zgjMDe0oSMEScHWCTq9GHM9rHxlyVjC4U11ZrJJAqgVHqXbCiPq1hVzzzC04Q07kaMwwzlH8lCpxeIo7V/t+YoElFxEiMWbfMsVD/Tsy/LwIQ8FqDea3x4ACWle9vshBZmjm8mIK/Y5bmLxGqoF0yIrkE92M85xdjz65c59PB1K176Yuzh+HKcBFuK9xBiBt5AVWjJgWC7y2rnzpti/JAs95zbYF4w9Hxv+AXLBNi3xiy0bqqXOsHg6+B6WU5iIk7ITpvKyUeJjJq2OCUsho4DFdnQOjjiSdRA6nxmbqOHX0c8qJwcc59M6Jj3A0Q3pTCusoRQ7OFD3ejWbCpQDPx1GXgMTn+ZF3i3WB1YeHTrfYJtYaTZ0/q+illQUeq3wOseIioSsXdvRQ2cY0Vapf8uTORtpJi9q1wyzrRrLmE2ZBRBpX7lO3vJMGaC6q3mMPQDGPqRgKjXmIeRkptEmun5Tq3k2qSImi1URkfTS5Kj9zEMBvxNtQwO6DGsuH/BFpMkmsd2r6z1S4u58TxuQF64MS23QJ+r8ODZLOsu9sj6MXIABR+9
 kA0O2uGV
 R1DHsKy7ozTC0B7I2Jnz4SZvp9IL3EFamZteGUaHHthGUpmwFc9iUsFoqDAeDfN5Nfrqp4RW0Q+DADb6st5tXqhDQNXq8Mn4pBjxV0LLRqAEq8lDsr+IelFjWBUJk9Oz9nxEVIGa4PV1C+59iSDfB0qdLSzTDhitkAYD1g5IIGEcpLknSXIUbx6laalS8vZTp9M8jXj1z6n+kUutsSyQI9GEkefgWmKx6TRAKKua3CcrjCGmo9M4+mLSiHH8ctVDbhOnUeUmrYOqvnbg19QVRMwwTjk6SLTw+SSJMEd3ppr0S/aMuxZND/BiBUSBgW8F8wSv58bns4M8OTLsFQIyxX0a+Dn+q68FPWVC3y3FCPZbDaHkfSaxrp2o0gyhpjcpXNFN5Rrind7TYkhPUaNu/T8/eTI5sxz8pamDX+Ayyvm7EerzEg7eNG6wxxL77m5q3GCmS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/8/13 21:49, Xie Yuanbin wrote:
> For embedded devices, lacking support for NUMA, memory hotplug/hotremove,
> CMA and huge pages is a quite common scenario. In this scenario, the
> demand for contiguous physical memory allocation is very low. To reduce
> the kernel image size, some devices disable the compaction. However,
> their SoCs do support DDR ECC, meaning that memory-failure may be needed.
> 
> Migration is very useful for soft_offline_page() in memory-failure, which
> may be triggered by correctable memory errors. Most anonymous and
> file-mapped faulty pages can be migrated to other healthy pages.
> 
> Currently, MEMORY_FAILURE does not explicitly select MIGRATION. When
> COMPACTION, MEMORY_HOTREMOVE, NUMA_MIGRATION and CMA are all disabled,
> MEMORY_FAILURE can be enabled, but MIGRATION cannot be selected.
> 
> Make MEMORY_FAILURE select MIGRATION to handle this situation.
> 
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Cc: David Hildenbrand (Arm) <david@kernel.org>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

