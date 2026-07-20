Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DCF6C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 15:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AD776B00A7; Mon, 20 Jul 2026 11:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85EE16B00A9; Mon, 20 Jul 2026 11:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74D3D6B00AA; Mon, 20 Jul 2026 11:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 414806B00A7
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:32:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 39638A0163
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:32:53 +0000 (UTC)
X-FDA: 85009547826.03.1E7AEC3
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010039.outbound.protection.outlook.com [52.101.85.39])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0DF9D180007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:32:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ldSqYGeR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.39 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784561570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iOZYO62EUgVmspDdq27efbPv2Li8Mj/hsJLpwNyO1kM=;
	b=cCar0D2IM7XsnMiUdBYtCyTSLmOkfETx8jjR7+ftEme/Ahnx+p+8K23+yR3p1Y1KCHpcxV
	RWocm3uXNg4CcVrVCFrBATx/oQENzzIdF24sDkXVfSlukGW4jVxYWF0Z/KPOGpVWTxKHJz
	Gu6OoPwV6pAqoh+zEvGEqq7OgDVe//E=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ldSqYGeR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.39 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784561570;
	b=OTQlEl98EOkFQ1cLeifYibebvWYIKP2VT88BWzyBOTkoV5MMMpbvpMG3D58md4QGARCky3
	D7Tg9rVTO+/0iHx5Lzmm9xDgy2K/LeZGocbm1QQ+g1xFRtvU3B4JFE4bF7hx3FSowm5Db0
	0ox1Ji4CtvBLyYsdOEOPDkpdR2d9JSU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T0Ig5nUd7Og3+nDo/tB4tm/1xFkFjezRqoz5eRtb/yxYz4DhQ23MpLfKBCmLZ8DWcfI5FZajAOI8spuLEphEowQS56T64eZvqnu3oKG+9LFoqKDP+GbMoXa8VaaDziQoyu+FNw9vmZ+2e+qoC1mr0Y1JJNCHZCC0dMbM0HfhRwMjDppMAWtep0ZCVBpfZzu2t6YmuSSsU676Mi2U3ksfKbpe+7hDUvxjYRGjayKsw+SB+qJQHZtWo0cLRXIZ2VVJWNXuo4WsmymkH+4ELftvh79UtoSNjNKQakXARWLPk3P98yi0Doqk+CkkXKKR0TRSpExpPb/z2w/UoXNfNNvjnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iOZYO62EUgVmspDdq27efbPv2Li8Mj/hsJLpwNyO1kM=;
 b=jbPjJFimdC3XnGI+iU/sz+MwJmJhwoNvkyFPkfLhBPdWQDGwVYeaJTkzg6U/dnX3FXTAqMjD/gEFTcfsjn8wSOV60Tj7pDlppskp6iDNoufp5ZcZsO8yuCAf/5RLFcgAquIZNoelBNJYAxRmWmHqapKolsuo9ms3XKNWo5kK8FGUb5BiJiK9jkDeaTBMuP7tASNsudenPy8nGfDVxD2OLH+JiLvej/8yEBgyC2d/vtXE6P3pdbm/uEBf0vEInCmuwdjzKrE07qat7l0kvVCI7Xs4yqIy3sXb2w3gGQ+z0sFNfZv3dycCFyRPZBFZm1qMAerM+8dd0xXypZ1i4EB1Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nvidia.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iOZYO62EUgVmspDdq27efbPv2Li8Mj/hsJLpwNyO1kM=;
 b=ldSqYGeRvz4EArQfXKDOk+rFagEOI9o/mKmQ25+JgK52Z41gxAYDg4QbLuK/tbl0WCOopj5iAeex9CGr0Vz7hNSuvmdyztYjsTQb5JsW1KatWXUUMto+CPULeOTlWVNlZVvKzXbrRpUboNVpuhp7oVRRbTSkiNIcXxRi3JKQI7k=
Received: from SJ0PR13CA0039.namprd13.prod.outlook.com (2603:10b6:a03:2c2::14)
 by PH8PR12MB6985.namprd12.prod.outlook.com (2603:10b6:510:1bc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Mon, 20 Jul
 2026 15:32:41 +0000
Received: from SJ1PEPF00002312.namprd03.prod.outlook.com
 (2603:10b6:a03:2c2:cafe::d) by SJ0PR13CA0039.outlook.office365.com
 (2603:10b6:a03:2c2::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.9 via Frontend Transport; Mon, 20
 Jul 2026 15:32:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002312.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Mon, 20 Jul 2026 15:32:40 +0000
Received: from [172.31.152.59] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 20 Jul
 2026 10:32:27 -0500
Message-ID: <56468737-471c-4d92-af01-a0c93cafdb1d@amd.com>
Date: Mon, 20 Jul 2026 21:02:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v6 3/5] mm/migrate: add copy offload registration
 infrastructure
To: Zi Yan <ziy@nvidia.com>, "Huang, Ying" <ying.huang@linux.alibaba.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Alistair Popple
	<apopple@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Karim Manaouil <kmanaouil.dev@gmail.com>, "Frank van der
 Linden" <fvdl@google.com>, Teja Vojjala <tejavojjala@google.com>, "Pravin
 Tamkhane" <pravintamkhane@google.com>, Kinsey Ho <kinseyho@google.com>, Wei
 Xu <weixugc@google.com>, Matthew Wilcox <willy@infradead.org>, Davidlohr
 Bueso <dave@stgolabs.net>, Vinod Koul <vkoul@kernel.org>, Bharata B Rao
	<bharata@amd.com>, SeongJae Park <sj@kernel.org>, David Rientjes
	<rientjes@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, "Yiannis
 Nikolakopoulos" <yiannis@zptcorp.com>, Dave Hansen <dave.hansen@intel.com>,
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Rik van Riel <riel@surriel.com>, Shakeel Butt
	<shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Fan Ni
	<nifan.cxl@gmail.com>, Jonathan Cameron <jic23@kernel.org>, Aneesh Kumar K.V
	<aneesh.kumar@kernel.org>, Nathan Lynch <nathan.lynch@amd.com>, Frank Li
	<Frank.li@nxp.com>, Dan Williams <djbw@kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Mike Day <michael.day@amd.com>
References: <20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com>
 <20260630-shivank-batch-migrate-offload-v6-3-da95d7e8b8a2@amd.com>
 <87wlupx60s.fsf@DESKTOP-5N7EMDA>
 <19F47514-EBC4-4659-8252-EC3765D9B601@nvidia.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <19F47514-EBC4-4659-8252-EC3765D9B601@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002312:EE_|PH8PR12MB6985:EE_
X-MS-Office365-Filtering-Correlation-Id: 40150632-5f93-4a7c-3b8c-08dee67422ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|7416014|376014|1800799024|56012099006|4143699003|11063799006|10067099003|13003099007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Y515NkNqzZSkgzkrTgovFWRC6DFQIlVMQEMzl1QwOjerHEGtIc62BNpw9Rnr6CG0+A5mn/WZwr6HmaEXmH31SeF0/4YFtgNIw34kr6QmeoKTHsPFI2Ak4A1d+e5o4kAoEdMgoObVpOxs0qlzsnOezY++ey0z678s6xHxCo0Tu/Njbv/aslo7/NWunL1dti4btT3Ob2qutC3RAaW5E3U2oNfq9HkDQoxCFUH9Td99f8llSgj/oxQO7RVvENfIgk8BX3fgr3VphRUjreFPgxtJEg6ISsaIN9Jj/eUpMj89LbRkrLNc4SymYP7CL5Tk4zE6uQlu5dDDcefFPltIc+Fw4tGoaF+KUJ/d/LUvoNOme5kE7oc8UbMAzv/I/8uyqcyl0wBMNEJ7Z6GYkAm09GiyHCLv5lzHqncGhWDgY8FQjIxQxrw0Uy4hnf15t6nXYaIFUyqutmsl2DKNAVm0SEE6xVAAMNuuWBmnggIM42ceFgD9cTpmEyZQq/rsOxxEcSoJrYwxd/v8D4ef6+/B3jiB6oEMT4symOAGmP/x1uUK7bS8fLmsh9mr+ooMY997CQ0rn+kLYjkTcKRFKDkmpN7t84Trnpr3wyaGCUwB6YOsEiz9SIIj/w5mlk14llI4NkSN5260s8dacEofyzMUG6b+mAfl/snSPXRTvkH/TKf4QipieDaNhH1/KVBxeCbv9QvcZNeplbaDB/EW6l1G5IOpbQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(7416014)(376014)(1800799024)(56012099006)(4143699003)(11063799006)(10067099003)(13003099007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Oknhs7e/BQKtJAegSOag5C8YauseMTVmS2t37z+su29QfnMES01pFO/ZCTZITDBF7QdKR041VSM66CW/B9B2ulkN4PZ2Vq7xmxQ+TZhmptzEpJpmM4T0uqj8OQrUmfjFORRB6c1Aexj17LvuaOfmJ04Fcs/CNizf+8etq1oSda7KB/ZyguwDdzd+v1RPMwuQQ1ayUZIO/xKnecCbgNTryyLVyUY4eZ2B5xOV/CIWpQbfOw2PfE1H1LiXKs/MfKa0+GKWOfyJdnH5KLhTXLgm5Vj14d0G0zq6nIu7P47pVctBDrUewmL9wMkOYw0q10Np91RtHN7MLADe9TarFIiYZebKeg+qcWXNIKYPViUsG7DXGq4tZMu5YRhbvQoUY/H6kYXI7zuRBElGkSHDRmHgFqnZ4xeegmY+KgusA0HzJLi7vGvJ0GgKVXBT7lCox5yT
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 15:32:40.4290
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40150632-5f93-4a7c-3b8c-08dee67422ad
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002312.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6985
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0DF9D180007
X-Stat-Signature: brksbyy98yfsi9xxpnu37o7pdj6jsjc6
X-HE-Tag: 1784561569-696129
X-HE-Meta: U2FsdGVkX1+/LD3b60ZsNnwLJUqkxGyj29TQNHvUR8xCzDxVM/zdABUpN2lQFsLtFItKrqnpe/tIwbp3m9ALusOAPcCmIqqQ9GZZx+gJUHYFhFTIl98UlK+B8vEVJ+rdwJAMycIgbxUhBX4dLAxmZiF8nZo1KkDQqH/WKbDPpQJJFTFfDwM55q9Fqvmprh2vMqCPMjtNQJM4eBbcnz+o1405WXzfyQFil39URMupe1qoQnd/swbeezd9AZIeEl/E7loXy/QnsqKzvAaVfBN/Hi55FzXakPAVDsaMOQln/c0QMw+2uaMEBz0YOd/LmTUEeWBri2lm/SvFbO8dSYZFpBZvZY/WetxMyWIFFscLKmE5LPhkzfBO3Om0ZCjyMFacZq2CzIY7BYvPe8j2ui6SaAu9POwqFRlFPzQze7/8yiA4yvUYkDWTElJZgSqsx+c5SpLpitXcd9m+vtvyZJS4WicfIi9uVpCGi5YrXuPhT2WtK0qZiApV70BZR2Qcdg8kxKIJK9L+al4VKnxblzL84mAeu07YvhlRbOo5vWQYNgQWm209OyVEVRmA+9OtTYHX5ICm73ZVcTz5ZjeXUOT7Hm0uJmgz+sG53g1w+QWCpgopX5FvURrN26DgaI+iI1hxMXWLmtcTmzbIPbwP13ofreB7/3y+CZSDUy2d+QdA8i3Q/IUKVpHLDKJSw/1ocYk2E/TzWGA75ZdnGUFTkRVpnzw6KRPGZ9j3Ab052OfnO+GXEnR9E5kLdkKBwldrn/JzBKHUePb+//5P9Ttn/s+GwStIuwAhL6fegbF+vsq8mh+BOEUaqiPJykWExJTkNDFUSbai6ku95hdudygyvnZC6dzwFRGFfxGH+/QAIo+jZSZaFuG+aBHZjwZcSAeOeQzM9RWYrELUMupQIgGFZfg4DnBmWAVfv7Frn1cNm/D2ejEWlMuwohhL4hEDeYWkswhJEnntQ6WvNDHj4F7Qzrs
 mblYxobK
 qMD5jZTNgi1Fa7h1y0OARJgGVFKHWgL213bKf/fMfQStxVwJcCQw2n2lSDVqI0ZPdHfWLduhPKYhajS9+duYOb6pwFToxRFx9TrVmwGBeNjFjx1LZu98Ym26IMcZ5v9RYWZ/elUyOfEtZ4O/ZEBIx/Pvn5739zV9AiA7hG8YuxrzBcLfYyHsaZDvrAbXI1ZuK+GAhiehNLOsJuBw8+gAd4zvWy3J7x/9ztTRRxbTZ9tIyiH+YWuDHSfv6dxP7jJIOlCAB/twV+UnHZ0TTj8svLAe+20WdPfcxZBj6JY2QMPe3JwHf6Pyx6+ZXbfS3VNthStKdqSfoaOb06JVA8+PdnKDLgi3GOYu2kF+GiD0aHoeVx4swuAuf75mTHy9/i9BlnUo27JUOF9KlodW93jsAKt8iklYu/H5yQ0hOIpi+4lCHUvKAN2glF38L+C1MLA8mUQxKZBjKynK3aC+yPHgHU3mkszyMt+1S6KMf0p1InaZruZ4iw5UY3PguQHYlYGXq5C4dvRvhPHGdyz0d6gg0G6bHryOx6FZXceHIdwbpllGE0bIQMQDQZ1SL1EFJAK/MhuLZs0w4DtO+MvA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/20/2026 8:14 PM, Zi Yan wrote:
> On 20 Jul 2026, at 7:19, Huang, Ying wrote:
> 
>> Shivank Garg <shivankg@amd.com> writes:
>>
>> [snip]
>>
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index 41b732e78a67..4fed3110ca0a 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -43,6 +43,7 @@
>>>  #include <linux/sched/sysctl.h>
>>>  #include <linux/memory-tiers.h>
>>>  #include <linux/pagewalk.h>
>>> +#include <linux/migrate_copy_offload.h>
>>>
>>>  #include <asm/tlbflush.h>
>>>
>>> @@ -51,12 +52,6 @@
>>>  #include "internal.h"
>>>  #include "swap.h"
>>>
>>> -/* For now, never offload. Wired up in later patch. */
>>> -static bool migrate_should_offload(int reason)
>>> -{
>>> -	return false;
>>> -}
>>> -
>>>  static const struct movable_operations *offline_movable_ops;
>>>  static const struct movable_operations *zsmalloc_movable_ops;
>>>
>>> @@ -2050,7 +2045,7 @@ static int migrate_pages_batch(struct list_head *from,
>>>
>>>  	/* Batch-copy eligible folios before the move phase */
>>>  	if (!list_empty(&unmap_batch))
>>> -		migrate_folios_mc_copy(&dst_batch, &unmap_batch, nr_batch);
>>> +		migrate_offload_batch_copy(&dst_batch, &unmap_batch, nr_batch);
>>>
>>>  	retry = 1;
>>>  	for (pass = 0; pass < nr_pass && retry; pass++) {
>>
>> Found a difference between v5 and v6 here.  In v5, migrate_pages_batch()
>> checks the return value of migrate_offload_batch_copy() and acts
>> accordingly. While in v6, it does not.  Why was this changed?
>>
>> IIUC, FOLIO_CONTENT_COPIED is now used to indicate a copy failure.  Is
>> this necessary?  Is it possible that some (but not all) folios fail to
>> be copied?
> 
> Based on the discussion[1], FOLIO_CONTENT_COPIED is used to indicate both
> 1. folio is copied via offloading, and 2. MC copy failure. So the code
> no longer needs to store the return value of migrate_offload_batch_copy()
> and can just check dst->migrate_info & FOLIO_CONTENT_COPIED.
> 
> For 32bit, FOLIO_CONTENT_COPIED is always 0, so all folios are always
> copied in the serialized path. Hmm, that might be causing double copying,
> since migrate_folios_mc_copy() copies batched folios and later
> migrate_folios_move() copies them again since
> dst->migrate_info & FOLIO_CONTENT_COPIED is always false. Maybe we could
> make migrate_folios_mc_copy() return immediately in 32bit, otherwise,
> we will need to find somewhere else to store FOLIO_CONTENT_COPIED.
> 
> [1] https://lore.kernel.org/all/c2bfdf39-8caa-43bd-b1ad-2285b4cc767a@amd.com/
> 
>>
It is not cause double copying.
migrate_should_offload() /and migrate_offload_enabled
gate if folio can be added to unmap_batch/dst_batch.

migrate_offload_enabled branch is enabled from the offload driver like DCBM (which
again depends on 64_BIT) will call migrate_offload_register().

I think I can add a defensive 64_BIT check in migrate_should_offload() to prevent
any potential bugs.

Thanks,
Shivank










>> [snip]
>>
>> ---
>> Best Regards,
>> Huang, Ying
> 
> 
> Best Regards,
> Yan, Zi

