Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82818FD5F79
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 10:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC6B46B0088; Wed,  8 Apr 2026 06:44:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B777A6B0089; Wed,  8 Apr 2026 06:44:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66806B008A; Wed,  8 Apr 2026 06:44:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 933C96B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 06:44:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 40786C1F5D
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:44:21 +0000 (UTC)
X-FDA: 84635054322.26.E3AAD87
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012009.outbound.protection.outlook.com [40.107.200.9])
	by imf15.hostedemail.com (Postfix) with ESMTP id 00D25A0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:44:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=PkJ6PvAk;
	spf=pass (imf15.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 40.107.200.9 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775645058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EAxCuzFUAaeNYkLJx9r5cUQbK46o8FiZ3y4+3jZ1X40=;
	b=wt5ugZDY0DaVA+RgnEXeksmBqFjqS4wRUY6Sy0mujB0dPwNe8vvjheJvnp4K6k37km6gXg
	KPoCSUeR1fGqtiRlrSyuTFto+X1pVCROtyMe1uRwK1JzisWOsfSDIME2gGV8ueCS6qTFrx
	U729X84Z27GtgTOE4gO7R9K4oGjMELI=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=PkJ6PvAk;
	spf=pass (imf15.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 40.107.200.9 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775645058; a=rsa-sha256;
	cv=pass;
	b=w0YmFNm4lZlAx2CPCkxubIcJWX5T5nk61FvDhFWu5Vnbosj9j91CUODOlGgqaXm375qNCi
	OpG4c8CRrOR9JyNaIxkqYarRUiDXQTAsax3emxmqzuePv2ucirmsP92wLA6URVTMoQDcR7
	YgXzMfZ/rgBNNWQtiAa8z4Ex5XE5mqo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vn/y+gmzhQ5B5p1+h5f7PHssKmUVLmecUIc0sHrARsJmuR2WoU0w8991uc1mWqggUGZf8LbD+zMYDmasOFiBNqkWSjH9L3cu0hVyU+sq/9yKJoq9ir93dOmZ8Jcgc7/pCJcQaBDE9Aj/QjGA5Gj6eU9C4yTlYwmIe61rMhdyXvthG1ZF9lMvYstfUDyRJmKnPqLDubsdfUXsN9rWEi9KXWvhWavlU22Q/jKOPtIHRGHEd7f70kbYEA5qec5bNPHCBX2LX9O2q11d1x1LqWJdA9n0+NqR1Km9u16E1cZazArtGeQJIug5+1mTosBo66+vjWKY4/6eQR9WCGQz8on+6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EAxCuzFUAaeNYkLJx9r5cUQbK46o8FiZ3y4+3jZ1X40=;
 b=Mnft5KgRZRJnrTGuyiZ7uXd7N9VhmtrS/yz62Z5O2oa6QHJY/tHUbhjoDcbQ5pWPS9aIDaLtv2Bo0g+VLZjvWUkHSRPeKf60E/zkbsYePftd/w7ZfLCyw2sZLzdqIoluASNYQ+PgJl5j9rWvgZy5mRWkRXGNXIeLyFXqSGhnAbZ28YMsiyFq3TO38e5s9Ktp/j6Zhmp8a4nNqlx84FDBS6O9Okr3lX1IeBOqKOLybExb22qKK/OmSCf3jPPflWAx9b2+1xUaOa8LT4DScEvfeU8abKcUVAe5JzH1gvvAH7lzhDQpSwELfqzvaiutzellFCw1n+siBimtC8i+0nX5ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EAxCuzFUAaeNYkLJx9r5cUQbK46o8FiZ3y4+3jZ1X40=;
 b=PkJ6PvAkfDBHlZ/6WVuvQPELOi5yACwPTl00lJLGZU0y6MEeOaE1Q0er33R7zvc0G1gkzqV5MSCC3YQvHT4WRTTfr8b9pXKzj48acTbC7S0+KWYEyP1I8sXuqi6VeaBaHKjSYOHByKKK0UaK2DVCnliLuViAb8QxAlEz83LAgVI=
Received: from CH0PR03CA0245.namprd03.prod.outlook.com (2603:10b6:610:e5::10)
 by MN0PR12MB6245.namprd12.prod.outlook.com (2603:10b6:208:3c3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Wed, 8 Apr
 2026 10:44:13 +0000
Received: from DS3PEPF000099E1.namprd04.prod.outlook.com
 (2603:10b6:610:e5:cafe::38) by CH0PR03CA0245.outlook.office365.com
 (2603:10b6:610:e5::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.32 via Frontend Transport; Wed,
 8 Apr 2026 10:44:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 DS3PEPF000099E1.mail.protection.outlook.com (10.167.17.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Wed, 8 Apr 2026 10:44:12 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 8 Apr
 2026 05:44:12 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 8 Apr
 2026 05:44:12 -0500
Received: from [10.136.43.140] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 8 Apr 2026 05:44:08 -0500
Message-ID: <4e8c218b-ac5e-4674-9e1e-acf750f0a5c8@amd.com>
Date: Wed, 8 Apr 2026 16:14:03 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: use batch page clearing in
 kernel_init_pages()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, <akpm@linux-foundation.org>,
	<surenb@google.com>, <mhocko@suse.com>, <jackmanb@google.com>,
	<hannes@cmpxchg.org>, <ziy@nvidia.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <rkodsara@amd.com>,
	<bharata@amd.com>, <ankur.a.arora@oracle.com>, <shivankg@amd.com>, "David
 Hildenbrand" <david@redhat.com>, <hsalunke@amd.com>
References: <20260408092441.435133-1-hsalunke@amd.com>
 <22b6ff3c-9d41-4eb0-9beb-cb92f3ada89f@kernel.org>
Content-Language: en-US
From: "Salunke, Hrushikesh" <hsalunke@amd.com>
In-Reply-To: <22b6ff3c-9d41-4eb0-9beb-cb92f3ada89f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E1:EE_|MN0PR12MB6245:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b2531d7-3fe2-4c13-8f1b-08de955bc606
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|7416014|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	hW1LV2ZP3og//ts5W6pfT9hiTs9GeEXbmByBEj4JpVIxw800f4k/sJHi+qYGYjTWdI6yIdzVEMZsIQ73kKanhM6Jo9b1CsCUllqVBwyPVIocDdqgJoYzFkIPjpk8crA+NXFUjjxEnyXGnHhNGufF1BVWQi4//wIuhIX7ZMFwFq3x9GBNFTsJo+MLqIoPuBHl/q7MGvyDIv2DE1R/rTpInl0Gt85m8y5xP+e9Bpn16YehYqI09sQTyLr+9bOEdeJaNj1MO1w62FoDjeINjBJjk4vqCSxpG0qj8NbwNKUkV5U2k9B4b+I4FOsIDAh3E6KrYDYs1LNsyVcmz9ZCm5EajnOXa9cjYo5lZPcP8aQ6yxHZrza3h91XyaLlq094QCwTBv7JbgDtqL6UZSnDR/oIfgKVIwGRxTqY34S9AeNFwxSMudoJ7lYXRNKOTQ57JvulfCS9m4DJSC2bILkKY3MACj7QJ0AtHnBfKIppQPiQGtlqShuRmpn1NiDQsArI1IaKf7fEbDBT+etxOFPTjaVZ5ThGTjm2jeQNT6n2wmkA5M7VZK47/m3CodWh3Eb2sNfpTPmLYudQyoYm9iQIRFK+fWkG2I3h1dRXKfxU9fBHOr0XrLrdjmiBZNwsBwE/vabMOqF3M89Z6BHY+hLTWWn1YCTCnNA4MFFs1pvekdkwX4MSDdEeaLNPhtB1yOJa2Zdkqrx8Kcuw5CNpKz8+hXNNo7GhYa/tWIv5mQX3EOW1Qz9pG1/X3RaIeWEHI0qcpCowegMXwHMlLDvtyRO6esxG/k5p7GqcOSVOmhmk5nU6QW4=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(7416014)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UIekNHxHlgCqnGSxZQHmoL6FIHdi/dle5pHZSMjhXkRmW+CHdaqRtDcyfq6cFCexlbrIterY2eei8u5g0tCgot5nA3MWjbc7MSrgZzK7sTlE4wpzveehBP0ebxxwfIkaL3plHvNYtiLLMyMLBlVsJrJuNuzPJVmHx+S0LsEDSYh53bcEN0r5BypzoVeyB/8cjpQEbJm2hQCYB8aJuNdiweWaL0IklmD0uJOE/5kc8W+hH/gx50mlaq5Rslvr1HJ3kAuhb1bfrTwgYFJjJh5gAFlfz2QSccfQ4BPe7mO5QraLvQ/l4HL1o43jDsicGE8bGkj0NsXYMawDOQ9w2i20HFE3XErLJs7YOFiihOOaKNAppl8fT2a/I0GJDkOe5z8xpbdZ6vqjj7AggpF0ebXXeRgRvoh0si0nq+7M/G+T0MwOBFzUXKFBhnynaxzaCEWO
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 10:44:12.9478
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b2531d7-3fe2-4c13-8f1b-08de955bc606
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6245
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 00D25A0005
X-Stat-Signature: t4sg6fzbfgainb91766c64horuuneoe6
X-Rspam-User: 
X-HE-Tag: 1775645057-153141
X-HE-Meta: U2FsdGVkX18taaYO7d5Jezmq3YdhDJ8eLrLD3fqpxHM4gVQlZmnwkzUcqVIYNx/EkhZg9b7LqRNr6nyBu97nJ6Ds+ZjwXRMZrfsYdFbG8A0ZweKGVqxsWL1uot6LWQaTN87Q2FNu98Gn/G/i32aFLysdJvz/jADhEWYKrrDCviC6cY+S4zHlpCoi2Wgm+9uuT7+VgIp+4OIxGL7DQyWUydFsJiotCXAow7CuiU1exej46cuiM7jcvpxOIlsXIZxwUxqw8wrrbVJc07e9Om92fF3buA9GZ9n06t28pHULYkxTuN1T+kwJa/RTzf/mh9UL3UdM/uGIMQ9Xr1XYEBIPqWClLdrXITpnHcf7PDb7YuhGR+RwMlv3Sj3fj9IsXqDktVaOl8qUFKHjNkzasXrX6adR5C5z8Brb8nb9fL0byzkvnn68ZH9UmeSixiwc9ZjKyNoX6zYrxAkEip+CzZNW09mTK1mh/kNyiGSjXn23Fhfa6VDtPP7y5hIgqrxwZEGzqc2vPsauC3vo099/cmO2eqYK51zeh5AtoF8igA8BnE6doWmdx+Suk+mOZrFe/nnHwVz+mNTduCkXStx4VtOLS5vcPl2OsKsZsCF/ylUzpT2OQNpFdC8tfqGqnacsbP17eH7cbuz24BNqsdZ5kuEXikuvZikdnCdzjVXJBiK3wFZ+6ik9c7aJCEIVGSqAyHKBIMwrL0maBiMC8yUdtJShEOxnERHBIS+z9rEPyziMtemkzKasQbtoNKbGYM4WNJbOY3l0idTZAqUnYGKJ1fO/IzSEtE9Azm7wzk3kMKbMew/ipuKemWl/a5AED7Gp9Hf8q1ABw1L/5lxNkpn4SafHjk3cXoezIxogQuHyiNl8puPEd4A3u9UNh8ZTl6AmMJ1zELNHMZI6PY7PujSHnf0sKgxaf3jXd+NWbMbHyhqpkjrPEUSx6DtWpWpkdJ7c7sCk9egQz4xDVoWQ7EBLN2G
 hhL73p6V
 nhRmo22S/lHuEF4bgVHN/O4PXE02wPvdhKqmcnsl329YttssKCXC2Luts4UdQKT6u3B7zva2uYOwyuPUVJCQNU89vK+Hm6tnGhmNCYelzmsid76QeMU8+/XxhxpP+Pm0kmioffPlGXGgEOmaKZOSExf+SPF8H0wcVZf/bYCqY4cyuosDb77PG3qiqkfs0aDphqmbA9wbo6r7jQGrjF+H5v8u9mqRooQ12oRYLYDCFPqYX/HBxuFuId5ZUTWwzcL2rgkXr6tpco9rGzFYsNpIbqCbxd+KkVC+JpMDO9ykRaFFWObiwOvpak9b3xDXru5Fozb7o2mq1SeQX8ZZMl+fKifhjfION71cVewMUvVHTCs7bFLOtTVl9oIGTtJAKhpNVCCdvgmXfZCVa19fih60nCo/LiHqtIcPR4GqgZQo+NgUxZwf9oAncd7mNb3yssN+oJCKIi3QaFu7u2dYXHOQtiBS0iIfnk97+J+AYtOGz+benvLkg5bnUcf29ptPENQQMwOfwf83pLF/lIcYiGDZPzcn/HvRCNtekhyQ3tjUS4T0rbnk/lQpjAox4ahcakSrkWF6jAwzj/T5s/h2pIGEn8L1XyFFvJWb/2dPK9AMMT/IFh6z25YYlYoRx20WqJyvOEbfACekAHijMqpk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 08-04-2026 15:17, Vlastimil Babka (SUSE) wrote:

> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On 4/8/26 11:24, Hrushikesh Salunke wrote:
>> When init_on_alloc is enabled, kernel_init_pages() clears every page
>> one at a time, calling clear_page() per page.  This is unnecessarily
>> slow for large contiguous allocations (mTHPs, HugeTLB) that dominate
>> real workloads.
>>
>> On 64-bit (!HIGHMEM) systems, switch to clearing pages in batch via
>> clear_pages(), bypassing the per-page kmap_local_page()/kunmap_local()
>> overhead and allowing the arch clearing primitive to operate on the full
>> contiguous range in a single invocation.  The batch size is the full
>> allocation when the preempt model is preemptible (preemption points are
>> implicit), or PROCESS_PAGES_NON_PREEMPT_BATCH otherwise, with
>> cond_resched() between batches to limit scheduling latency under
>> cooperative preemption.
>>
>> The HIGHMEM path is kept as-is since those pages require kmap.
>>
>> Allocating 8192 x 2MB HugeTLB pages (16GB) with init_on_alloc=1:
>>
>>   Before: 0.445s
>>   After:  0.166s  (-62.7%, 2.68x faster)
>>
>> Kernel time (sys) reduction per workload with init_on_alloc=1:
>>
>>   Workload            Before       After       Change
>>   Graph500 64C128T    30m 41.8s    15m 14.8s   -50.3%
>>   Graph500 16C32T     15m 56.7s     9m 43.7s   -39.0%
>>   Pagerank 32T         1m 58.5s     1m 12.8s   -38.5%
>>   Pagerank 128T        2m 36.3s     1m 40.4s   -35.7%
>>
>> Signed-off-by: Hrushikesh Salunke <hsalunke@amd.com>
>> ---
>> base commit: 1a2fbbe3653f0ebb24af9b306a8a968287344a35
> Any way to reuse the code added by [1], e.g. clear_user_highpages()?
>
> [1]
> https://lore.kernel.org/linux-mm/20250917152418.4077386-1-ankur.a.arora@oracle.com/

Thanks for the review. Sure, I will check if code reuse is possible.
Meanwhile I found another issue with the current patch.

kernel_init_pages() runs inside the allocator (post_alloc_hook and
__free_pages_prepare), so it inherits whatever context the caller is in.
Testing with CONFIG_DEBUG_ATOMIC_SLEEP=y and CONFIG_PROVE_LOCKING=y, I
hit this during exit_group() -> exit_mmap() -> __zap_vma_range, where a
page allocation happens while the PTE lock and RCU read lock are held,
making the cond_resched() in the clearing loop illegal:

[ 1997.353228] BUG: sleeping function called from invalid context at mm/page_alloc.c:1235
[ 1997.353433] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 19725, name: bash
[ 1997.353572] preempt_count: 1, expected: 0
[ 1997.353706] RCU nest depth: 1, expected: 0
[ 1997.353837] 3 locks held by bash/19725:
[ 1997.353839]  #0: ff38cd415971e540 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x6e/0x430
[ 1997.353850]  #1: ffffffffb03d6f60 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2c/0x220
[ 1997.353855]  #2: ff38cd410deb4618 (ptlock_ptr(ptdesc)#2){+.+.}-{3:3}, at: pte_offset_map_lock+0x92/0x170
[ 1997.353868] Call Trace:
[ 1997.353870]  <TASK>
[ 1997.353873]  dump_stack_lvl+0x91/0xb0
[ 1997.353877]  __might_resched+0x15f/0x290
[ 1997.353882]  kernel_init_pages+0x4b/0xa0
[ 1997.353886]  get_page_from_freelist+0x406/0x1e60
[ 1997.353895]  __alloc_frozen_pages_noprof+0x1d8/0x1730
[ 1997.353912]  alloc_pages_mpol+0xa4/0x190
[ 1997.353917]  alloc_pages_noprof+0x59/0xd0
[ 1997.353919]  get_free_pages_noprof+0x11/0x40
[ 1997.353921]  __tlb_remove_folio_pages_size.isra.0+0x7f/0xe0
[ 1997.353923]  __zap_vma_range+0x1bbd/0x1f40
[ 1997.353931]  unmap_vmas+0xd9/0x1d0
[ 1997.353934]  exit_mmap+0x10a/0x430
[ 1997.353943]  __mmput+0x3d/0x130
[ 1997.353947]  do_exit+0x2a7/0xae0
[ 1997.353951]  do_group_exit+0x36/0xa0
[ 1997.353953]  __x64_sys_exit_group+0x18/0x20
[ 1997.353959]  do_syscall_64+0xe1/0x710
[ 1997.353990]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 1997.354003]  </TASK>

This also means clear_contig_highpages() can't be directly reused here
since it has an unconditional might_sleep() + cond_resched(). I'll look
into this. Any suggestions on the right way to handle cond_resched()
in a context that may or may not be atomic?

Thanks,
Hrushikesh

>>  mm/page_alloc.c | 19 +++++++++++++++++--
>>  1 file changed, 17 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index b1c5430cad4e..178cbebadd50 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1224,8 +1224,23 @@ static void kernel_init_pages(struct page *page, int numpages)
>>
>>       /* s390's use of memset() could override KASAN redzones. */
>>       kasan_disable_current();
>> -     for (i = 0; i < numpages; i++)
>> -             clear_highpage_kasan_tagged(page + i);
>> +
>> +     if (!IS_ENABLED(CONFIG_HIGHMEM)) {
>> +             void *addr = kasan_reset_tag(page_address(page));
>> +             unsigned int unit = preempt_model_preemptible() ?
>> +                                     numpages : PROCESS_PAGES_NON_PREEMPT_BATCH;
>> +             int count;
>> +
>> +             for (i = 0; i < numpages; i += count) {
>> +                     cond_resched();
>> +                     count = min_t(int, unit, numpages - i);
>> +                     clear_pages(addr + (i << PAGE_SHIFT), count);
>> +             }
>> +     } else {
>> +             for (i = 0; i < numpages; i++)
>> +                     clear_highpage_kasan_tagged(page + i);
>> +     }
>> +
>>       kasan_enable_current();
>>  }
>>

