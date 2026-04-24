Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56330F589DF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 08:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A9BE6B0005; Fri, 24 Apr 2026 04:42:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75A5C6B008A; Fri, 24 Apr 2026 04:42:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649086B008C; Fri, 24 Apr 2026 04:42:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 52A106B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:42:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89642120864
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:42:18 +0000 (UTC)
X-FDA: 84692807556.20.C3ED5F8
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013052.outbound.protection.outlook.com [40.93.201.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id 39ACE4000D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:42:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="yV/ajaiH";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf01.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 40.93.201.52 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777020135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0rZkdIXmGvmGznJKbDGCrFxZNIrwkQ+011eC7Mgq8a0=;
	b=rSZIxcA7kvtZC+XOP+JIcICs6l5Rf8f3ac1FWu5Namz480vZO/hF3b6bfx9Em1ByJmUmGD
	WIWGRGLnhUHGb19lU2nnAEj/TwvFv0vxKLPaSr/wxykBQT5lfcqanhou4w18k+ozFMCUVH
	QPfIE+Lb04dxq2V8YGHrVCUHb3+da9Q=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="yV/ajaiH";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf01.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 40.93.201.52 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777020135; a=rsa-sha256;
	cv=pass;
	b=8VO6otifz24YmGdDD33BVBSp9i3D02ctL0KGjWtbacaW5LVPygPEsJGb8nydm9nO8J1V9S
	uvjzlDB/OShtOTa/zRTSiMHAXC6qCl+lSLvulnZuLQCwsft87VG6e5JCpudwzCxnSVXlU9
	9IhH+P4kxjb9ikFkxlAzuYHWHgYoK8M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bKWI8KLB/LWtHhTbtB4BPMo1K6smiri8rK8kUB2LRXBSXocpzFzjYTfLxpjqioEzozu7G4/yyDkBHBEG2+wodi9KyoJZrngyPMYx7wxtI1hbIU0/X2BG3JFw5Xi3ktmLQcrJaAU+A0Gl4zOkICcvcEpBdJCrAupLmNlETynLLIda6fNSZ1X9ApD78xzx9n2zUfRPnLOOySxuJt9xJ49xowFoAjlQIXf5JhdPmoGbH2UCqtio68MXaWLt7BoYaTjHn2IClXvyxL95I8K99D/grYGyIpEsSoId9zI5oucuIU/AT7Sjp+PSgfj+tZOaIIBBk8Q9jsYu92kyce5aGZJAqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0rZkdIXmGvmGznJKbDGCrFxZNIrwkQ+011eC7Mgq8a0=;
 b=gODr31uF3+UKeY8iyxzCAdZ+NeZmwVjbmBdGoUAkFKeykA4ij65fcN/lUB/D9GXtqxRuLdduFxg68te50yGdIuBoFkqTGnlbNVTPnaTEau+uMMWQSm0wtSWRNgisZsLfWcRKeniuTMW1f93TB/Wbr7OJ4w6JtPvnrRM8tQA/BHhIFxal32jvNNb5JKZioSrhvBCWlc9vEL8P42v9DeLqpIJOcp2g1VKd+6V5KZoSpxLYa9ucn62R1mgDOdaNH+OsKNgOLO5jKwshaPmsZqoE81wogAKWwL0802QRWr44ENpbM2cwlhEZbs7vO4dRkQPt9t6sZIw0Zbl2nMHlnTZhQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0rZkdIXmGvmGznJKbDGCrFxZNIrwkQ+011eC7Mgq8a0=;
 b=yV/ajaiH2R8+py0MPOP1J6qgSwNNTvBNKH8PhqjwmAQcLwZh7d+ZnXLgW3JdwKsmpyMAB/J4h6Wh1Dz6nUHhTv/nM5ReLLU5VGBqUClcPUYikbIfxSa64dfo8WzbTmHxu1Dtg6kga494pEqIf46W44pclKOQlFuiOBvogxrnCD4=
Received: from BL1P221CA0011.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:2c5::23)
 by CH1PR12MB9647.namprd12.prod.outlook.com (2603:10b6:610:2b0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.20; Fri, 24 Apr
 2026 08:42:08 +0000
Received: from BL02EPF0002992D.namprd02.prod.outlook.com
 (2603:10b6:208:2c5:cafe::11) by BL1P221CA0011.outlook.office365.com
 (2603:10b6:208:2c5::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.22 via Frontend Transport; Fri,
 24 Apr 2026 08:42:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0002992D.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Fri, 24 Apr 2026 08:42:08 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Fri, 24 Apr
 2026 03:42:07 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 24 Apr
 2026 03:42:07 -0500
Received: from [10.136.43.140] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Apr 2026 03:42:03 -0500
Message-ID: <ef5ad58f-0641-4017-a199-defd25430bed@amd.com>
Date: Fri, 24 Apr 2026 14:12:02 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: replace kernel_init_pages() with batch
 page clearing
To: Andrew Morton <akpm@linux-foundation.org>
CC: <david@kernel.org>, <ljs@kernel.org>, <Liam.Howlett@oracle.com>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <jackmanb@google.com>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<rkodsara@amd.com>, <bharata@amd.com>, <ankur.a.arora@oracle.com>,
	<shivankg@amd.com>, <hsalunke@amd.com>
References: <20260422102729.166599-1-hsalunke@amd.com>
 <20260423041249.156eb95889696ccfaf23dca1@linux-foundation.org>
Content-Language: en-US
From: "Salunke, Hrushikesh" <hsalunke@amd.com>
In-Reply-To: <20260423041249.156eb95889696ccfaf23dca1@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB03.amd.com: hsalunke@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992D:EE_|CH1PR12MB9647:EE_
X-MS-Office365-Filtering-Correlation-Id: fb683f92-43e7-4ac8-0a1a-08dea1dd5eb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	DwLTMu0JaoBarUJnaGcPKLXOJqUmmrMNahrQDlV2Q4NScIA0k+V/e6tolT/SPEJP3TWHrGhSidGUD8D20AiABgZJj2ZdPDdza+8LoNdUjaVuABwcA0CwhUJYM61x60YR1pDhbAYpl1VUBlVQYcZm1gnmKoKSIdP4069+RFre5gWZj7GF1k9D9PUVyFLOU9YruoaYkCPh0Grpco/lvdXUkKnkSZmg6iF2UHs2AUSyZrMqRfkud8xOzxq9ASYR+7UAwcRpKDsgK4bo8r5I4FWpReCuAQJ7//LEdcpOHux7xLXKNGv3PrD6Fs026h4QD3kE/XOm0y5M9267glyfGx9DPHH83Tmj+7OMieAPIocp4UPYaRoDqLQeTpy8+zj5QkY4gt1oeydyjLcgBnUh89hjRX8P4/gVrvO6PYB1qznSbs2Z+L/zv5kA8+6b2kWhZ9TBu5DJOJSwcG6CbayJP+u3NuwqelOFjKNh32kNVAp8tQTs/43pI9NFMDs3gLCJ925eqHnEZ59TEHd590LD7gcxyc1xqUWMHlh8oEbR1r3iuGNb1ckrhYucfLQuvzdRwcu/4P5F3SLP8tVrnqJ6SRAB0vP4MgoWqXpYB7VZHIBYy9M9FSNbooQ6NHnw3NSODMZn8ea0H7rAZH5QHERuKCztb2OeGFZtOZmHMzq5SgMqY9CiGh9xo9GwhF62fRsXDSsYeIb2xrI5QbU/+MpQqZxSyd83NGr0LEFC1HuhBGe2IrLiw8BBXMVpxzR0QSXpHchK7n3zWEI04QYvTeQDfphmgA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kXEVcrN+Qy6GmC7xtxemTXWq6hZvdUNDFdX4P15GeZzZJrWjFcMEcOwBCGATXz7DMWKiFmwNngdkBWnUABT0x3g+7nq9IZXlBTXI0IQyA24ImFm1Ss3IMb3nXkPJ+OsmGKaRtHGreS81gMmSDrArO6rrkpVuIBGMlBXsatfOPbRcAa8iKm7KKxK8/n9ULKXHOICoQzfzgiw+JvTDRl+JPQHPAY54CU9boHGZA5pAlIz3JOveh9ntHNsuPQKb9yaw6rpiy+QgW/exoNlLiO0R9QtO4h+nc92VfbxUgqxfqUxc/v0tPLZ+V7BRlFmJJcdDmo3ruhrNE81mfrcfUZq7PnP4zAniBl2Uc9x1pJ+hw/7AnpOOgwpmRUWzRbevs2jkw+z2VZfR2fRov+B/bqCRVkszuLc/WyXUNqwMl+fwE1W362eghYtzwJNGAMUSJOPu
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 08:42:08.1359
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb683f92-43e7-4ac8-0a1a-08dea1dd5eb3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9647
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 39ACE4000D
X-Stat-Signature: iu7aym7czekdi57qxfccj4jsdhbxikdk
X-Rspam-User: 
X-HE-Tag: 1777020133-162647
X-HE-Meta: U2FsdGVkX19pKdE1ajH8KKgutCQ7rEyX9nuTyFWnVsCiZDYytBiCbxAIFznrGh9Bqf3TBKs+AmJPuaIAmEaOyu+NYZqjWTXHh87j3aJ5eQc3WJMonRL8L59ctiU2Zw1/l6ot8/oaVAEKsoH/MIPoay2rUr/gmpqhz1mPz8HUtfukPyfRNPuxu3eKuCgicgGAleCs4umUmdnsje2wKvomvlR1Hm2FiQQVtp020F3pEYa8FKCOPnZ3KBM0cL1s7VDB+PcFKfGD53InwVkQhM2e50q7AmdH4xzwiAKlcAl3n1yxTCIAHxSqBrmRa9AeQmq7EKwIfuC5dcbmGPYhIFhR47UnSwEAOuiMbS1QyXF5BmQe/a7kZQyBIkzYfpP0/Z8tldIj4M/EE/mtuyELvjDOt/ZeTzFVUdmp3yIS5Dq/Z5+79sC299HYI+BXs74DsxHznqoh1mLTV4oKym8UAj07wowm4DolT6YyX63RmjbFGg9bIUGkasUykYC53WlFmj1V77ONcdF2IEVWEXxc1zXRK3jIPUnOtepEeRLq0vSu5mLJ9yf9/mBoVqy8XgNDLh2uB024TTHFmzzkwTlaa+q1wpyKxCfijqAsA43F5nHj0aGhlcoqHt1KNVSVIB7mLtZUEKmyVViBoROOAK4TrDFCPaxT1BfGbE62zxt1dtXhwsGiTLMpMqOmVUDos4QDFG0JwHEQw6LCz99JTexL1l/agdTV87Hl+rk+thP6IYZMkT7zxww3IkknVB2qG39Mo2wKZGxxoAf7U9S33wad7YV6QiuFPrJAgSNU3BrxegRjOU7Ptd78shEf4k9RS8f0WJUovHDdEt9WdL/5zpZATJuzdIdj+RABHsq36pESKLGRgQl+SQ+3jhKVE3Df9D4Zqt9VWRiw0rV32vTr2GBojAgFk2N5dPnZzW5U3LJzwF6RlmE+JGdWm9f29StPIWmeRFcF85BQBKkGH062Tj3+fCP
 B/4awgCk
 W09gGX+XyjkS0loTjQ2cNOK2PqmxbgB2l8g4pp0D7iRTLfxrptwN0BJl2Mo9S5JZbC9b083Kx/g+jFwZ6cYyvINv9/sEZqh7+QGcJjDoxBkkcXPf02zsSGoRstdDh3CyB/KL1mh+YNhWToYxjOT4W4KHfIlpTg55ziQGkVlsRPyBHLfGQO/pIrpst5He2Y6C4CWWK/lR1OJqLVUskTDhMHKoajD3fmBJmlLoF1PJ5mJZJoLdWt2adT/3Z2uCsGylqNSl9egWRXpNfeRBaTTlk8NcVZKtqsg7iNUCdaQCbADlskq+kKU12UrjYC/FlotDFHFQgbYKem7efDekidwBVw6IlSKy4MnRj/sG3CP2dYdjPAYc3etj1CHcWv9A4rmuiy81bCU3a0mV/GTvUl+H6KLsVCTkXdb4ww5VtwadDALWIJyJIoPhMsp1C3GJ5+Mv7qEaIbPDaJiWfKrWKM+iP9iPfIvTbf4+FKlN+HJ2XNDYSXUOte6BHe7Zh1hDIvK35/dBxtzO1k7S8I9VDEWW9GY2FvkTCE4wikiKtpcSQDUMNT4wMZTneJMducQ+ZNTDINoLW9LuzGLNkjMjCPnF8RgckFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 23-04-2026 16:42, Andrew Morton wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On Wed, 22 Apr 2026 10:26:58 +0000 Hrushikesh Salunke <hsalunke@amd.com> wrote:
>
>> When init_on_alloc is enabled, kernel_init_pages() clears every page
>> one at a time via clear_highpage_kasan_tagged(), which incurs per-page
>> kmap_local_page()/kunmap_local() overhead and prevents the architecture
>> clearing primitive from operating on contiguous ranges.
>>
>> Introduce clear_highpages_kasan_tagged() in highmem.h, a batch
>> clearing helper that calls clear_pages() for the full contiguous range
>> on !HIGHMEM systems, bypassing the per-page kmap overhead and allowing
>> a single invocation of the arch clearing primitive across the entire
>> allocation. The HIGHMEM path falls back to per-page clearing since
>> those pages require kmap.
>>
>> Replace kernel_init_pages() with direct calls to the new helper, as it
>> becomes a trivial wrapper.
>>
>> Allocating 8192 x 2MB HugeTLB pages (16GB) with init_on_alloc=1:
>>
>>   Before: 0.445s
>>   After:  0.166s  (-62.7%, 2.68x faster)
> Nice.
>
>> Kernel time (sys) reduction per workload with init_on_alloc=1:
>>
>>   Workload            Before       After       Change
>>   Graph500 64C128T    30m 41.8s    15m 14.8s   -50.3%
>>   Graph500 16C32T     15m 56.7s     9m 43.7s   -39.0%
>>   Pagerank 32T         1m 58.5s     1m 12.8s   -38.5%
>>   Pagerank 128T        2m 36.3s     1m 40.4s   -35.7%
>>
>> ...
>>
>> --- a/include/linux/highmem.h
>> +++ b/include/linux/highmem.h
>> @@ -345,6 +345,21 @@ static inline void clear_highpage_kasan_tagged(struct page *page)
>>       kunmap_local(kaddr);
>>  }
>>
>> +static inline void clear_highpages_kasan_tagged(struct page *page, int numpages)
>> +{
>> +     /* s390's use of memset() could override KASAN redzones. */
>> +     kasan_disable_current();
>> +     if (!IS_ENABLED(CONFIG_HIGHMEM)) {
>> +             clear_pages(kasan_reset_tag(page_address(page)), numpages);
>> +     } else {
>> +             int i;
>> +
>> +             for (i = 0; i < numpages; i++)
>> +                     clear_highpage_kasan_tagged(page + i);
>> +     }
>> +     kasan_enable_current();
>> +}
> Why was it globally published and inlined?  Is there any expectation
> that this will be used outside of page_alloc.c?
>
> Both of the callsites are themselves inlined.  The patch adds 330 bytes
> to my arm allmodcnfig page_alloc.o - did we gain anything from that?
>
Hi Andrew,

The idea was to keep it alongside clear_highpage_kasan_tagged() as its
batch counterpart, but currently it is only used by page_alloc.c.

Your concern about the code size increase is valid. Would you prefer if
I move it to page_alloc.c as a static function and drop the inline
in v4? If an external user comes along later it can always be moved
back to the header.

regards,
Hrushikesh


