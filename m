Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21596CD3427
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 03:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D73C6B0088; Tue,  5 May 2026 23:44:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AB4C6B0093; Tue,  5 May 2026 23:44:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1E26B0095; Tue,  5 May 2026 23:44:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3B7D46B0088
	for <linux-mm@kvack.org>; Tue,  5 May 2026 23:44:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B87038BB2C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 03:44:05 +0000 (UTC)
X-FDA: 84735601650.04.87FCE03
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012026.outbound.protection.outlook.com [40.107.200.26])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8FE5640008
	for <linux-mm@kvack.org>; Wed,  6 May 2026 03:44:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=uX6U7++h;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of bharata@amd.com designates 40.107.200.26 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778039042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pPTmQe+denm0Js6sbmuPxiand0WvyQuCmvVCiSeyhac=;
	b=3ic+42yVoyZibXHzK9vBWkNTUihuw82bFXC+evmIG4Hsw3msYounLSfOg31wJpAWxoxIYh
	Z8B/6lBTo7oixvMKIoZQ9gaO7e97tpnU4zeXAhO3x4QINO1kj7jFW2CrbOVm6KjcJp2Uby
	3YYylEGTz5U+mBnZFfN/7FrTYAHRWIU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778039042; a=rsa-sha256;
	cv=pass;
	b=elWlnB8h+nsBWQpiiVkk8GYnRFi0JkFwmPIA1Vz1fYRoLXFJX7iRTkD7nrdPswbD61axHb
	7BKJ/S95G8yHeDNkALbzmCVcQozLVb8/RSwAmFQweW+jkrfKjr5uDplwL7ZU0psa4vFeWc
	DMW3q1dj6ag0W/0JX+ROPOtxRm+Xxow=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=uX6U7++h;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of bharata@amd.com designates 40.107.200.26 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TNZ6hh7XbfOGv2zOO6Rmx10xzdOIsagZ2SlOpxYlQOGRN64xijq0oZeFcZCfnJ+kHyTiw84C8hJaQwVrH/68RNb8/wz/CQP8CbRX5aDvSv1yaXEpkve2yNS4ACqlf8fcVi8NlbjRspyPxMmndL6lH+YD//cmakf3g4UhWBiOLNT7bWnrTZ7kp8UR7lNsddrJeRX4QTs/OIMXC7QWIvu6ytlK4e/agggC3ASez+RsAuk95RMfHVBEap83aigsR+y2P/VNnH5W/NR49TfX0Fwl8EMKx0PQi+06aUHjVZ1QDP+Ux5A0bG7TCTtABaseESlv5w6XNwWW3L2Mx+UTJdDOzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pPTmQe+denm0Js6sbmuPxiand0WvyQuCmvVCiSeyhac=;
 b=vj9dPfWSpKU5ObneDn5GetMsDywrLxmCPmlKDQ6NydUIEF4zunXqNjZodhSt/SSiV3vUNW97Ni2Cw56NrSGnAfBGKm+QGeXu+Sehod+BjcGzARrA6K4XGKqVA6zllnLmUH7S2M/hCJMQCVbbcTGj0QzAsmHN6nPleWFS0BuVJbb1XWTjPXyCJCuoa8+SbtAo8Y5S2HKm3lOj2zZp4OvQW8gOjQaCDH/pKc9P69fUPx41KyAC6RKzdF6eUFSmvoHmImA3TAk1bzCQNqhvYh7kj85brKEB/Xz3m/YrOy0qBAviXMSmDEx2r94LM6+XSY+AlDBihF+I4emOCd3LIg0MuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nvidia.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPTmQe+denm0Js6sbmuPxiand0WvyQuCmvVCiSeyhac=;
 b=uX6U7++hMnQFx2nGrdvhMCfnbT7V1BO7Mk3pWmSNsjL2MGUi4O9W4ENvqbXSdL+djQtG5j9HSX7Yb81HOYUt5H7WrDbLYuylYeBrm5Cl/qU3q58nRSbU3AF7eroKK7Y8m9XftemOELgaj5mCZtGeanik6HC7li/5Uc6d8DkKnvc=
Received: from BL1PR13CA0305.namprd13.prod.outlook.com (2603:10b6:208:2c1::10)
 by DM4PR12MB5723.namprd12.prod.outlook.com (2603:10b6:8:5e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.27; Wed, 6 May 2026 03:43:56 +0000
Received: from BL6PEPF0001AB4F.namprd04.prod.outlook.com
 (2603:10b6:208:2c1:cafe::8c) by BL1PR13CA0305.outlook.office365.com
 (2603:10b6:208:2c1::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.14 via Frontend Transport; Wed,
 6 May 2026 03:43:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF0001AB4F.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.9 via Frontend Transport; Wed, 6 May 2026 03:43:55 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 5 May
 2026 22:43:55 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 5 May
 2026 22:43:55 -0500
Received: from [10.252.223.214] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 5 May 2026 22:43:48 -0500
Message-ID: <211a37f8-92a4-4e5a-9d55-b61b25f504a7@amd.com>
Date: Wed, 6 May 2026 09:13:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/7] mm: Hot page tracking and promotion infrastructure
To: Balbir Singh <balbirs@nvidia.com>, Matthew Wilcox <willy@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>, <gourry@gourry.net>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <nifan.cxl@gmail.com>,
	<xuezhengchu@huawei.com>, <yiannis@zptcorp.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <byungchul@sk.com>, <kinseyho@google.com>,
	<joshua.hahnjy@gmail.com>, <yuanchu@google.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, <donettom@linux.ibm.com>
References: <20260504060924.344313-1-bharata@amd.com>
 <afkDNR9yVRjire4T@casper.infradead.org>
 <e5246723-b910-418c-bed8-5222d63d90da@nvidia.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <e5246723-b910-418c-bed8-5222d63d90da@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4F:EE_|DM4PR12MB5723:EE_
X-MS-Office365-Filtering-Correlation-Id: ced88d0b-4dde-4213-eba0-08deab21b2ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700016|13003099007|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	WWfrK4OtAhxLP7ycnoJqcI1Fi0Jl8xUXCfcAetmuOOywXBXI35+0mmyBgwZ4SQIAWiwIbqCjkQe3RmogXhU70FYaSVISUUIWLVPRjLxtJt5DW1kGFwSKMu73k+dico11dXJsz7rGFcOdwBQ+WKUDiIR6wZJ6en7v8t8aFL8lvkZlCQ9Y94aOCGX8ZAeBJF55T+dKuryI+SAVahyKPEfHnziC7amH55LtdnOHKNNq/mzOBYVJ92TRKxtzaSE3j3T0P5gDcoiA7uila4ON2ezAIQEI+Yzd1N1er05drYXoIQPSYyPc5+uCfVt9Tf1xPV04BYVkcG69jjweTHp3gzmw8IJpfbQGZ/DQLhhjRPnRd06lkmMyJWY0YOAw/5ewBoK6mZ3gZiIM6V2pdgvs9rgu81ac+EUz473hydLmxr630hCxnMHhOMjJQwXoTsug8uJVrJ6qv5Xarc3iCm8V/0vKW0NG1Hg0fV04CmXO3pZ+ICZ4BoZvdMYDNHMowBbrTx3XPgRpI6LdYLykm7EiyHpRWil0OilBBnLOlKZbg0qoTWVI+0+Y2f/DqaSns2G/Va0WF6sMtSDk5bsGZLc15Ja6But1oL9XPKkLRR8lkOGHhrLebR1/I8WT1Lmh0apBi6fKkIzRhS4+ts4hp+5cDdGXXOCezIxlgOhrOGqiUBbSBtByGn/j8bPAb5FNvc01SZKvnTzjunV9TdHXWVTpxaNKtyGM05FwkUkZPC8XgvsA3kd5uAKsLco8fySC+sFCAtnS
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700016)(13003099007)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wSXnWURpAWuBBUFbgFifXli5x/Por5S30fhpkAfhdTcp0qGESE8MosC7AvcR76pXQzbOQetZARWzkB/4n8TLMecrWEigs4pQ+6HAXN6/QDyMSHm4TDN+XD/5zlYraby6aQQx4etIs3hJ/eEKmDTS2lKJ+okL2ap0SYt9bTWy/RAHjow1ajbCH6I2xYivYHotpwq9HbU4HfH+ycMTzC5lX5a1kuWTCb16tOsLgN5l4HMcmeGtlmOZwWExAkn8jOIstWi0Av5sYVgf0PDqq780g9vhxbsCWMHdpdrRel+1UaAPzveftrZ2daQnlrvtcytVQjSVeZkbH+bvOTNDA1MBs+fAPc0pL0PCkLi7Q+oTmE4tl2d24iNj1aTiurdN2Ry0/pt2rgji9sF6D4jpiTngwO7ZCWc5uiPVT4pdTg1g2t5MerPlP+C5N3l3xVIE0Yl5
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 03:43:55.6665
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ced88d0b-4dde-4213-eba0-08deab21b2ea
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5723
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8FE5640008
X-Stat-Signature: n1j8819jxwe5wx68xqbemxoizuqrnq7e
X-Rspam-User: 
X-HE-Tag: 1778039042-909835
X-HE-Meta: U2FsdGVkX1+wd71drrCLYWkPeiNE1Jh/WyatLJsx1Vi3m+gS1sVb0zW8cIg+VEa4tnQl+nkHYxNSccGeCK2JlT1BSPNq3aLOxXXGgs5EYhv/a0e4Zte1DVJDp/minYQNTBk6LWJ0wEjbU5aISxTrJ9MKUaKwxnYDe2SByC4JV/riCYSL4MqngldCksieCPgq12dz6DsigbP0+OglhbFVoD0SX9J5OFLw9iY8KIS3rnpCgk4gGdP7r5sBhvGu3AidDsDkfeTsQsag3YVGDkEDx/AbfPf9WLMT7H5wV/eWV6NgPZ/KU6BnDiePQtSa5bwmAsfm90yZv/4d2DZ3P3I6dPp27mz39wALC2V5In7JaFJuuz0wCYl3eVSTz84PEnUAxuIW3/wA8J5LD6rIOFOxQyJQmlebg8wf+RfMmSw3k26BEKNgBwUvLN/76lcdqzth/p8+Om7mms2NcRTvnoUFbd43P53i/aUj4/E7D4J/gxblbUM9ZN/E2hx/BByqArNoJfj2qYS1G0uFg6LrlAnewTQ8p9W6p4hydgKd/IwLa9/qlWpkHf2kKVUEuxJBKUBqa83m9tmEMbQDWNE8TLICt5Pi4Jnhci2o1dqhHMfGxvmOAgsmzrtAdeSX3eF2trSCqujK/5Awmgoz6eLqXn6gmeAILH4Fk3CkyWxM1918rqanvE1Dw/RS6h+5y7SqH6+lJO/QYzayAspdR0unRMTocotxIntYCqouy14ReUD7MFo+o8Ci2yz0tUJktAsTNDEw7RDGB3GF3reGDnGciYVSK1HjVqvWGMtHMVLWtHQUdfUMFiShSWp5R3KaO69w/5eWkUYy0Mdiu9pCQ6Crjv+lIbLBUVDNS/mXg6pPM+9Yb9XrqrvCHRASKE1M5fSG9ksxW1rnS8mXUB/cQKek9OHvjS5AlRxWMY+X67QAfztwHFC6inYBq3Ec6RH4mlV9oCGEGmdVOLXAy+wmi8fBxVN
 zh33m8dg
 hE4Y4sM7TrixK5XGDTgv/xs7ocFAqRmSUafqNw1JgV3PU793nCNt6FygQbSFFlfEuv6cE6RPO8H/7mbcM3PohEO3DKf0C09yuIWJ1eXvuFOo+Dgz1XcX5Rt3yRB9u1nSzV0kjLBfyxxkag37m756S9FC5IzXsAmPuSsBCpw1iS4H+pfYLt7F9XPBkXlbCorB9n1eEfjU/xcmssunNA2qFvSIo804eW36k+U+zEIXXD3QyUBn4Cw2Nr81N5TvdoKPRPzPfImE6z8LNiUIHSoBzcO7XoaV6IaJTbEAYhN2WnO4KFQn9hYxxKAfLkbEjG5IYZJR5GslFDPsCqkfxQyr86pNSR5XNVZeLGW3K1DEKKkxlZ48RSWSVk/YLtzQ+YjFzVolwSK/Jl0ubN11b3QcMbCzjPAZSCAa4FmCUidWi7bRi8kv9xTtZR/T+ZvF2xu6N+Lctc4aTEIP4DgNE6Z55c5cMq87S+yondQmKCzryJ3Q0GGB4qn7iv1BOww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-May-26 3:47 AM, Balbir Singh wrote:
> On 5/5/26 06:36, Matthew Wilcox wrote:
>> On Mon, May 04, 2026 at 11:39:17AM +0530, Bharata B Rao wrote:
>>> This is v7 of pghot, a hot-page tracking and promotion subsystem. The
>>
>> I continue to think we should not do this.
>>
> 
> I am unclear about the benefits of the patchset, I have not tested
> it or reviewed the latest revision. My big concern was that top-tier
> might not always be suitable.

So you are saying that we should have a capability to promote accessed pages
from lower tier to an other tier that is not classified as top tier? Is that
non-top tier node the one which generates accesses?

> 
> I see that there are some numbers posted, but I find this weird
> "After the graph creation, the processes are stopped and data is migrated
> to CXL node 2 before continuing so that BFS phase starts accessing lower
> tier memory." Why not allocate everything on CXL node 2?

In the ideal scenario, the benefit is to see if any pages that land up on lower
tier get identified as hot and get promoted. That means we need to create an
over-committed scenario where the pages get demoted first. I have provided
numbers from such cases in my previous versions. The problem with this case is
that the base hot page promotion (NUMAB2) hasn't shown any benefit at all with
my micro-benchmark - Ref:
https://lore.kernel.org/linux-mm/868004d8-bb8e-4800-9fdd-ade48e95fe3b@amd.com/

Same has been observed with redis-memtier benchmark -
https://lore.kernel.org/linux-mm/957f2242-56d4-4bf0-8aeb-9d60fbea8c8c@amd.com/

Instead what I am doing here is to take out demotion from the scenario but still
retain the access pattern of the benchmark by pushing out the data to lower tier
when the benchmark reaches steady allocation state.

Regards,
Bharata.



