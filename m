Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8939FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 03:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3AD86B0088; Mon, 27 Apr 2026 23:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF1696B008A; Mon, 27 Apr 2026 23:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDA7D6B008C; Mon, 27 Apr 2026 23:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB3F26B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:56:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 62A511203EB
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:56:03 +0000 (UTC)
X-FDA: 84706601406.12.F81CFDC
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013058.outbound.protection.outlook.com [40.107.201.58])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4D0704000B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:56:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=euUjN3Eo;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf07.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 40.107.201.58 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777348560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxrc6/rS33FsopVy0bGE4UTHhnpkSdwpDIXa2AV8gtE=;
	b=Mbd+7iaxsQFU4zevHsVloruiTUW0u9k+KVP3go1bvRbgx9FOObBKkzAJP+SHc1A5sBo0hO
	i2H1KFZLix8TthVhBb8/Bet0cy/qO+ujzgH9LSwO0hqCQpCYBTT7Hj02XJlIPoNvCMidjS
	85xuGpWwfkLlk8jGcbdh/3lY7TYzS5g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777348560; a=rsa-sha256;
	cv=pass;
	b=m1pYscm4/fTOr/ZBdUVNosakkLG0e+uQO8PD1mFUB8e2gWGhF+m2OY0zC6uFqEwfc7FSeK
	faNOoPujI/X5ItXewOWqELfu6BF+lrlxbnM9MXsKR3ux7AdGDtt0VGTvatOJOcRNLa/bjm
	534H/if2Fy5kut5B7ax+d70gkEObI0M=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=euUjN3Eo;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf07.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 40.107.201.58 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i6Pi0Salpa1hA9UHZQ8rojCuqnHFe5/TszH6X6a+2jJz/xwuoBafkzPBmi/rdyF0NYeRmnQovOkkesNMD0iL5A6ZZMCw7VkU3/swT5zRyBRUhrwGpFL7Vd4j+7+gb0blYgojzp/9OCMuC6dAJbI1p5K9qjArRHnW74/3THpW0MhnsOroRIdf7uG/R3un6GgBj+cLJwKab5lgTEfzv9IxiUvHDQc7WyFb0yzVWiZ55wWu51Pq/23IHX82HazuTRRUa8CnBThkk+Hkx+oN+b6KtfAtKFlU/odXXgafalJvl7RfHWVbanE4E+EVA/o4ZHNqnh/7Sb1zt5bZgME4A4QvMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sxrc6/rS33FsopVy0bGE4UTHhnpkSdwpDIXa2AV8gtE=;
 b=MtPP8mWKVWvachK9188p09qLkfj0RWrtp7Hoj+95Mbj7DMkAvb6tycw3mYrgNXfcGsmJrJlbte8taimzhoIKwdVsH0RQOu/jGh/TlJQDmcTCDb2M0BeDmqU/7wUH4d+L3bsbh2KlD2Pr02Km1hTaeosn4eg5kLK0yEHiVAIx4EnzP84b0A19XeU598BssRIkIsdGqs9BADgpgGALEXS0FyJdmkoOosJVjZwZ8GiqO1iL9+b2Ve6+uW6V1FgKoPhBow7Hz5Q4/dGfuD0ogQlHIFZfowYr/5ONhH8k7gbpqqF49hgXUxCAUBZvJjbzWKtPsgXGAKgHiy3dFDLalTkc8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sxrc6/rS33FsopVy0bGE4UTHhnpkSdwpDIXa2AV8gtE=;
 b=euUjN3EoHIz6SU+bGIDHLwu1zYqIUI6khx4nd/am4CSHt0ZhJA3AHs8ScDyQrR5rRknH8utep0xWWCC8YxokkRIcRiUSoCkV5qJauy80X2XyPFoIyaFVDZZqdi8JxJXK7UtOsrYCd9zIoJqELHPUZ6n7X4i7covUg5ClK8WqcIs=
Received: from BL1PR13CA0187.namprd13.prod.outlook.com (2603:10b6:208:2be::12)
 by BN5PR12MB9539.namprd12.prod.outlook.com (2603:10b6:408:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.16; Tue, 28 Apr
 2026 03:55:56 +0000
Received: from BL6PEPF0001AB4F.namprd04.prod.outlook.com
 (2603:10b6:208:2be:cafe::7b) by BL1PR13CA0187.outlook.office365.com
 (2603:10b6:208:2be::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Tue,
 28 Apr 2026 03:55:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB4F.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Tue, 28 Apr 2026 03:55:56 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 27 Apr
 2026 22:55:55 -0500
Received: from [10.136.43.140] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 27 Apr 2026 22:55:51 -0500
Message-ID: <f75e03ce-68d1-474a-9b85-157f73af48dc@amd.com>
Date: Tue, 28 Apr 2026 09:25:50 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: replace kernel_init_pages() with batch
 page clearing
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <ljs@kernel.org>, <Liam.Howlett@oracle.com>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<jackmanb@google.com>, <hannes@cmpxchg.org>, <ziy@nvidia.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <rkodsara@amd.com>,
	<bharata@amd.com>, <ankur.a.arora@oracle.com>, <shivankg@amd.com>,
	<hsalunke@amd.com>
References: <20260422102729.166599-1-hsalunke@amd.com>
 <20260423041249.156eb95889696ccfaf23dca1@linux-foundation.org>
 <ef5ad58f-0641-4017-a199-defd25430bed@amd.com>
 <1253ca14-69de-418f-8f94-b08e8105e924@kernel.org>
Content-Language: en-US
From: "Salunke, Hrushikesh" <hsalunke@amd.com>
In-Reply-To: <1253ca14-69de-418f-8f94-b08e8105e924@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4F:EE_|BN5PR12MB9539:EE_
X-MS-Office365-Filtering-Correlation-Id: ac458d94-3411-4682-a06a-08dea4da0cfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	dOq4mqwW+M8bspRZ/1rSZRdpNhfFpTIcxLfqgIxjBOVjaPd61nRcbV6sWVJvZc+b5M8/cha9S8SO8mCJE3V/ypfIPHeH42ooaycJWpmmey1q7Bv0utmNEt12k0rEDn5PlQFeeo465FJZGuH/k1lPx0h3pEFHt71LoIpPr5ztb4VxSjsEv7FPV2/bn+y9mEYDO4vGM6wlCrlmaKZdXOtXmMplYQvQrwIUxf/+uExj0kNHC9c5fPhrm+bzBTyB1PNPLQmUTbGf4dz4z3Et5PkyfkOpti8CLwhlQoejzDm3lbiTwHqb71BltqtNYDtHfbA+9HnegvQoOf+tawjRjZEB0QBj5DAMISNFeDkFR2EtuI2MOG+rsf4vQ0DN3PT6z5RAZVHb/lk3lvxfYaBoem+tM4Zh+rFAUXN4TfYL5xk49ScMdKrnY9TsgJ0drVj8wWiVf2JIL12gnNAtNvaJcmNABrk1ZJU6u2y6URxYaB8K7ICbkSxdijHkSiowYBacj6m/VX1zJ4JYrDVz1E73N627XfDMSzCqDcZ0agfjb3Cgq3v/rp7XKA3rYPKnh8vAzCelZeM96Ld2uu2RSCWLN9OlyEegfru4mWvC0WnVv3wfvD6XizcRzrgMNE0jpkaiVl4j59b/dqtdqs1u6pah/fYR4jkJDdkJwA8gfjTsjPu3YmPYYgnIoZZHEmBmvYw4IW2AG5KMzlM0mIoOdS4cG/inulX3ms1H2ZPqWjReEbhD07Oaqtcd56x/may8O9VDA3qoLpjdfnYO4tKGDThgf5X1fA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8AkMsxuucSLWPoKh2J5rpXTwIKvppWTETWyph4dVVeDx+QCCe0oHtYiZIU3I/ER+39JWl9GmWLunHas2R5AdhVrMUTB2zV/i9mqmF6fTs1fdhbPJ470TczA76IPaQ9S4E9Mw6dgn4e1y5INxxYOjMWYfBhyKx9Xwpbzk6PXyVoCoENGjqqYBMJpwCRQIJk3wk4FRYCIUdLW74AsZbyWy167CBcSq+pcdv8EYlOQNQAZ4+nbIbIkqDzZeVYD/eHb5agr0x6A3YF+EO0aJS7X8xAGvVhEvvfgrVIcc9/sXA5nAZ8SpB4S4jHnKR063jI7nXRbv2M+O0P5ipP9VLoSBLiiWsctQrMhWpxdRljy8ODE6q4TTFtLBlnQlsP5lSwyjihAPNCylKZFg7L4WY0ZYFE0WK0kugjf0AR+Ht9DM88C6Pn9L45Xn565SXavpip/C
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 03:55:56.0413
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac458d94-3411-4682-a06a-08dea4da0cfa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9539
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D0704000B
X-Rspamd-Server: rspam04
X-Stat-Signature: sgxq8tt1mimrh739hz3yrs7m7jjut5zw
X-HE-Tag: 1777348560-593679
X-HE-Meta: U2FsdGVkX183H6eMUFS6qY8llO4d+M2QdKX1ZL5LttvNxQJsY8mBTbouxsMnn9/1nrQnaApGWayMVXmZV0Kb5D0PJwhSkUq0dEXSxMq50Q2KOw/W+hn+3BhLKHYq4rWAUIdc+upVbO6HotEBEKM9iK7kcDS8fYqxr1z7N8rawK/+SXy8H5YxlCWDtpEj74d1B9zJtsoWjb/gr/RcTGC5bkZFtIiYo1d3ULELl1g8r5u7Ptp9B6kJh0aKNZgDD3T1vEx/+G88ry++PFq7ZuSmCM27Iw+m/9U1iZd9Vdxjl1rCirqtB2mpax0QemXMFAimDNymKqSW0qNA6/NGGeQkVSVfyMOOF+2gWqY8hVr3ydbGw7ziJczA5hwuzt/07O93I5fAZtP19XZ8630IBKhfwS90OJqoM7uwx5dKa+aOLXBtA/+Ph8hevYPEwxDIDzwUzDF0dKpKG5jcSzh9KCC9iDZHrj6rufBhTao2wQjf3dlGFzWSAVuXbpwrtkuT4YSm7bs3pTntkAxNFkPTdthAqfvCuapLBILdnMlDg6MuoOKm4EYZmrc8hjsiJKmIuyz4248+txMeD26vWeB/NEE9S9p1p6cOzv5NDd1KotYZQBAaUDIWw2CyyPYlSsu/ciZYQ1V4KjDGwTM7K1xCjoAa6dN+EqFJToAmikFDhSHxrwkqCJNRleHgoCr5HdEqwnhyPAa3jwWVUBl0ClEEtmjl6WhrgsB7V4AVxApM82m6ymOR3ZPAqxcH9buoNieA+ltPfxoInWfRUyYbNzE2DVjX9g2G/4Cr/udxnOZac1owQ4EUZs9VaSpM34nuzwB5oslWE0Kd0kEoRGOiCsKtZSaApS6Jvg8i81myMVwXvJmmCecoX8Qrs9MYfL+wntFSR/vqn7gu1YtzbIEBsUrq/dfpwqDPaXxWEmn/MNpGhqq7EG3yR7kazPiAw4kQP4xEVdqNNbfpBhu+cvhZ/cfoYKb
 H5spDEZS
 9+lxNC4Z6WMjtW4+XbmSYPPKZrw/RZ272mGujcx3W5obOIOmW+yOpIma7NR9I1aukq9egNwGw/bHISeipOkrPYgeLgZskpeNDXVipu9GJQPQ0KR43OtZ4T/u4I/0K/4RbiSeEMtk+VPtJBcMYtvkcjjIyJVpDk6Nfq8g6Dyd+DiQ/bpofX8oDoUQHMsRla0IL8LbVlJH58TaF7jrFrHQVB1HgrGSpusqgmC71z/rf4dggDRB69ua2HrS/Nz5G42uYUuF6fraOpZt7JB6f62wfgWGjSBg2iGgdgFavdxH5esuVUSgS6V5lupBCmqbsnHycbXYAThmZ3Pzw8Wnaqa748BkSb6ceCuZjQOe0IRwBd1KFENpJuQwyeKTWx+0kWmzKJ97gHA1ZiVh4n7WIX5IkFHMUXPxshDB4IEAbixuO4EX4yjMo6M01BBeBl6ZyGaxX/XCk5fA0zBs6F7MpjfY+Jtwcr6Nj5GheeORYMj7XtseViBGsJ4R7+m328ZegZbj/IhBV9WGPBaIzwuELYWL/mgNzMkHucAcYia/dG91qT/i1asX6Tzu0QQnVvCVa+uQEMXQkGfHkwcz7jV5iRr97PfTsOY8WW3dijMh2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 24-04-2026 14:22, David Hildenbrand (Arm) wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On 4/24/26 10:42, Salunke, Hrushikesh wrote:
>> On 23-04-2026 16:42, Andrew Morton wrote:
>>> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>>>
>>>
>>> On Wed, 22 Apr 2026 10:26:58 +0000 Hrushikesh Salunke <hsalunke@amd.com> wrote:
>>>
>>>> When init_on_alloc is enabled, kernel_init_pages() clears every page
>>>> one at a time via clear_highpage_kasan_tagged(), which incurs per-page
>>>> kmap_local_page()/kunmap_local() overhead and prevents the architecture
>>>> clearing primitive from operating on contiguous ranges.
>>>>
>>>> Introduce clear_highpages_kasan_tagged() in highmem.h, a batch
>>>> clearing helper that calls clear_pages() for the full contiguous range
>>>> on !HIGHMEM systems, bypassing the per-page kmap overhead and allowing
>>>> a single invocation of the arch clearing primitive across the entire
>>>> allocation. The HIGHMEM path falls back to per-page clearing since
>>>> those pages require kmap.
>>>>
>>>> Replace kernel_init_pages() with direct calls to the new helper, as it
>>>> becomes a trivial wrapper.
>>>>
>>>> Allocating 8192 x 2MB HugeTLB pages (16GB) with init_on_alloc=1:
>>>>
>>>>   Before: 0.445s
>>>>   After:  0.166s  (-62.7%, 2.68x faster)
>>> Nice.
>>>
>>>> Kernel time (sys) reduction per workload with init_on_alloc=1:
>>>>
>>>>   Workload            Before       After       Change
>>>>   Graph500 64C128T    30m 41.8s    15m 14.8s   -50.3%
>>>>   Graph500 16C32T     15m 56.7s     9m 43.7s   -39.0%
>>>>   Pagerank 32T         1m 58.5s     1m 12.8s   -38.5%
>>>>   Pagerank 128T        2m 36.3s     1m 40.4s   -35.7%
>>>>
>>>> ...
>>>>
>>>> --- a/include/linux/highmem.h
>>>> +++ b/include/linux/highmem.h
>>>> @@ -345,6 +345,21 @@ static inline void clear_highpage_kasan_tagged(struct page *page)
>>>>       kunmap_local(kaddr);
>>>>  }
>>>>
>>>> +static inline void clear_highpages_kasan_tagged(struct page *page, int numpages)
>>>> +{
>>>> +     /* s390's use of memset() could override KASAN redzones. */
>>>> +     kasan_disable_current();
>>>> +     if (!IS_ENABLED(CONFIG_HIGHMEM)) {
>>>> +             clear_pages(kasan_reset_tag(page_address(page)), numpages);
>>>> +     } else {
>>>> +             int i;
>>>> +
>>>> +             for (i = 0; i < numpages; i++)
>>>> +                     clear_highpage_kasan_tagged(page + i);
>>>> +     }
>>>> +     kasan_enable_current();
>>>> +}
>>> Why was it globally published and inlined?  Is there any expectation
>>> that this will be used outside of page_alloc.c?
>>>
>>> Both of the callsites are themselves inlined.  The patch adds 330 bytes
>>> to my arm allmodcnfig page_alloc.o - did we gain anything from that?
>>>
>> Hi Andrew,
>>
>> The idea was to keep it alongside clear_highpage_kasan_tagged() as its
>> batch counterpart, but currently it is only used by page_alloc.c.
> Right.
>
> Looking at init_vmalloc_pages(), I wonder if it could also benefit from batching
> if we find that pages are actually contiguous.
>
> That would require looking up multiple pages at once. vmalloc_to_pages() or sth
> like that. Surely, doing such an optimized page table walk could be beneficial
> by itself.

Interesting idea. For the general case where we only have struct page
pointers, we'd need physical contiguity detection and a batched page
table walk as you described. But looking at init_vmalloc_pages() 
specifically, it already has the vmalloc virtual address which is 
contiguous, so can we just do following and potentially skip the 
vmalloc_to_page() walk entirely:

clear_pages(kasan_reset_tag((void *)start), size >> PAGE_SHIFT);

What do you think? would this simpler approach work
, or am I missing something?

>
>> Your concern about the code size increase is valid. Would you prefer if
>> I move it to page_alloc.c as a static function and drop the inline
>> in v4? If an external user comes along later it can always be moved
>> back to the header.
> What is exactly is responsible for the code increase? Two calls in
> clear_highpages_kasan_tagged()?
>
> Surely the compiler would just inline kernel_init_pages() already?
>
> So my best guess that the 330 bytes are just clear_pages() overhead or some code
> layout changes?

You're right, it's essentially the clear_pages() overhead being
duplicated at each call site. The compiler was actually not inlining
kernel_init_pages(), it was a standalone function. But it was inlining
post_alloc_hook() and free_pages_prepare() into their callers, so with
the patch each of those inlined copies now carries the full 
clear_highpages_kasan_tagged() code instead of a small call instruction.

I ran bloat-o-meter on arm allmodconfig and confirmed this. I also
tested moving clear_highpages_kasan_tagged() into page_alloc.c as 
a static (non-inline) function, and the bloat disappears entirely. As
currently there are no other users of this function so I will move it
in page_alloc.c. I will make this change in v4.

Regards,
Hrushikesh.


