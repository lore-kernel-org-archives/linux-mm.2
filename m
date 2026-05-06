Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95E21CD3424
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 05:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 647346B0005; Wed,  6 May 2026 01:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1286B0088; Wed,  6 May 2026 01:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471296B008A; Wed,  6 May 2026 01:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 31DC96B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 01:00:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B48EA068A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:00:24 +0000 (UTC)
X-FDA: 84735793968.17.85A11BB
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011048.outbound.protection.outlook.com [52.101.57.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id 79D411A000D
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:00:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=AhosznKB;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf19.hostedemail.com: domain of bharata@amd.com designates 52.101.57.48 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778043621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/NWe45GhOEjZEmaP6xMeissSWpVOuMAferAUtkzMjh4=;
	b=B5p5xYpkcYlyWVMtLd5xesfyVUlHcNsuFAXfP/6nUCd3TGq7jSEzEmJQ8ia37VvxGQuOdj
	ZrIRYNx6sIv/nnxbddfm+Mmsrzlhe+R19tKP1WKpWzoWvpt/JO1V+Muuiy4jvjh0959OiV
	dfqc57g4BjBBYywLuiwHPa4++LmPkDk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778043621; a=rsa-sha256;
	cv=pass;
	b=7e95htUSwolfMxfHShigDkE3tsENjX8W+xU9lst+65a69oADkIlyWt0dkPPlVuA3Mg1NoV
	jfWw7LMdNuLy75vokt+i2NTHg1dXOps6KJfB7R5O6Ihnu0w2vHolfOLSXP+FLVijAe3N0/
	TeJRnPyqzKIfj5H0wuwiHGhGPeJzO/g=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=AhosznKB;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf19.hostedemail.com: domain of bharata@amd.com designates 52.101.57.48 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uImrN2zRh+217FE0X7iGMoRpuaE2fhyCh8zY6Sv8G0JgE/0aQRU0NxgDxVR5coqrZlP4b1WXh8M7BkFh4631O/AmnUhfDAUYrx1Wcvl/Th18qm3b1gR8kGN3Su65KiocTj9CZjNsAcaPSieXIyb5wCRb2LdBvKJ3fxwUJzRePbBMJdlgkzR1v/Gc4xm1UzO3iDgVMAJyMQKZdMCDKNSk+MTrPjc/EiBMj0wHHnJ5ZaL5LLlFXLRdNQsxl2Z0Inuvv+LyUf7GfIDTRg5quvC5iz4LawdmbS9yGihEyJhxsDBvpWUdiwOpXIFYUhie8nurR74fcpxNRMq2yjmxdOKFKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/NWe45GhOEjZEmaP6xMeissSWpVOuMAferAUtkzMjh4=;
 b=vHypn1M79i8v/SslW8/ZjblKIAcELXe7GZ+YmZ0hgLMYm1tsM2y475V7KdBxMA9yyDxv2E0bGsG9QnJdqVnWiPqgGHbTX73ELu+J4cqje5xbHDnSHUfQgv0+8VYT3tb1hTyZns8MbRz/IqC6RxR6gLOsxgApW34850w+EykMotUBKWwj8EXangU6uX++2qXaBNFLH2pViSTvf3OEGNaiA3Orbp0rUf//PrafkjoK6Icx5vyiOh7YNA6q0PuACNvKINNnW+qzQ359uh6vGMDrhuNDgNp4ultv+OTl+njcSDiSXHmn8Bv0L371ZEbp0KVyfDRi3iOOngbj3De78NOKKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nvidia.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NWe45GhOEjZEmaP6xMeissSWpVOuMAferAUtkzMjh4=;
 b=AhosznKBRGsp+Pd/n0yZB1pBfRH6/CVVk8UOul+6qCYVwVfpmb+S1OjE4TcEmP+t3e629b9uRnBl9C+sNdPr+TyLy5RT1GWsHyBX9InpMUcS4spf60r/ALnauE2Z0u3qJYtA8AKCIca5me2/cKNiQyBCWtRik7xLU49/AzHxzG8=
Received: from MN2PR01CA0032.prod.exchangelabs.com (2603:10b6:208:10c::45) by
 CH3PR12MB7618.namprd12.prod.outlook.com (2603:10b6:610:14c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.27; Wed, 6 May
 2026 05:00:14 +0000
Received: from BL02EPF00021F6A.namprd02.prod.outlook.com
 (2603:10b6:208:10c:cafe::ab) by MN2PR01CA0032.outlook.office365.com
 (2603:10b6:208:10c::45) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.27 via Frontend Transport; Wed,
 6 May 2026 05:00:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF00021F6A.mail.protection.outlook.com (10.167.249.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.9 via Frontend Transport; Wed, 6 May 2026 05:00:14 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 6 May
 2026 00:00:11 -0500
Received: from [10.252.223.214] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 6 May 2026 00:00:04 -0500
Message-ID: <1270fc23-9c49-4b3c-bdb5-9c5704a3e212@amd.com>
Date: Wed, 6 May 2026 10:30:03 +0530
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
 <211a37f8-92a4-4e5a-9d55-b61b25f504a7@amd.com>
 <ec42f04b-a60c-4a1e-a7c4-cab12f94c5c5@nvidia.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <ec42f04b-a60c-4a1e-a7c4-cab12f94c5c5@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6A:EE_|CH3PR12MB7618:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e3bbcf2-93d1-408f-979c-08deab2c5c1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700016|376014|82310400026|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	HHTr6rVuFU9hH61EtE7BK7zHC0DbYy1Sh7/L7+6gEnM1+z2BoDfDaU0VKek7sAklAb6PM2fwEGXKd/PcgmuJBijpJ3XWpeE0ZWDvfoE8OmREHrZSql3LY6QBXe8rrVx7D14GObcLiI5KBnZoLHZVskDuM9goewayC7DJ4OQ4pytBF2CNbgdyt3vT/vBNOzczYfDqeLis/h8bC6yfLEsKkMqcu/Zv+5Eo57zliwPP5qfT/iIAth56iYSAjEBzXCR2lkrUdq0v/Qm+rnWak9wgTNrABLuvsEQw90VBtcOPIgHIvoGiCW9HECif0takgDEu5ntdzo3tbcVPdS8KIfeMZofgfEPHwWarrbnNO/cgwpP0peydcH9VpyjP3LP8w28JDYPVE4mJE8ovE1t/gpslJcnHnWF5IzQ2Dn4Nuf/OEkvqYmA1rcgPvHSzEsASI8ZSteHEHJhJ4r4iP4M37IhdutCQMQGqL/4wXkCm523Q2RWJi0VPcphyN3DuhFU4UWKoRQYCpzKtbJv/DlUy9OYrDAw9oPCJkOPFa/4rv06DGEbE0+6O81nDSwhvXapineyuGh3CofPI/MGkIItjd+jTD/6CRcNhNeg16p8AZ/fit9i5wtIBxzwNccvCE/c9k636l3L0F07qTgANsffStrOg0QKwSlUxU4bAbyA7UdYJOLN5O907Aq8xeVCNtUYNNUzqO2puNE7EUgGUo6rjpAUOKPmEwardOHOShy18RgkKxKw=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700016)(376014)(82310400026)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QdsZMllrsIRHe4u6ESQKlrKVBS3OnduErRJDnC8o3B9sZARi5Y7BBu5E+48hMUpdYgWIx4DdidRgy/gNbEWhnZ3d/xRRjfxFLH4hNH+OKbv39tFPIiNipkc20H1FOIQoioLIVBRYNNuTUqVojtMpzFBnU+2KnfbrGJvC+1WP8DGaNynNhK/jNWnPDQpZQuI8TFf+YOhRD6ecrcCljPtoy2a4YO4l0g/wi82HeTDEriAtBbn61f0o72x7DiTiI2oPT8N7jI5qw/nIfxFm9UIIOPczuVKYdcqWSekxiIC15lucsKvQZMA++64Nbp5bnuKhiL34wVTvTsWMB201fPrBHS4YwYIO+EDNafdMioXnb9C5z1hWYe25qSw0XVZbjtmpZfJQatlCpfvOol802DEC5Cuqn0IO6aHk+UGtXlE2w+owxrOu3iRvKDH2U19yw3Kl
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 05:00:14.5058
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e3bbcf2-93d1-408f-979c-08deab2c5c1b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7618
X-Rspam-User: 
X-Rspamd-Queue-Id: 79D411A000D
X-Rspamd-Server: rspam04
X-Stat-Signature: fimffs94saybeet79w9npsc1iiimibgc
X-HE-Tag: 1778043621-782659
X-HE-Meta: U2FsdGVkX18mk+JuPPJWV8qBZ2VtTbLUS/3EkSfnI83gkG1/UorS/SgGZ33+RjK6D0mN1djgs+IUOi28cqWzazhwbKtJcz2r++O+V8WpzLKPuNKbaoodVO2cz92GNy8mCAI1KKQZHUkFV0W7Qn1x3hUuzWH1Ttew+GcaaynzCQPVR0e6i8CRsv6ruYOLLDJseybyQuoKFeVGBIvyT42B/6qdW5+TC28B14UVmX5V7fLEZGsdTN0USpERERUjkp1k7ofAsNpMXd6wTFLQAUJQm0Jqa6SDjq+BzkkDxGceLUEzJg/D4ukDWdW8QE3pndccPiOYrwYW3j5vD4XnyifUrLujlyzqVKER3BDzNZjh/q3a/PVsd4P27LYX76FfmawlnN74niQ9T3G+WVxY0WzCVy921i+26Cn78lvvsstz/paPpBPf3qDOI1ZGESEkrLhRORGjWrCdgZa5aIMvOHSDL+CVzbI/U3br7WJPBijQSdRxFcCChDZAkISPJLsjDyRflncEWGWCr6BhCc2L+b0soMtIN7HL69JIB8c3hULA5bd9L8hNFcGkun9MAGV3z15nHPKc0XcuWEwxmQEYfcEhw1A63NocSlbgAmLl6hPeum/CBxUucL0bNwoeEDZyxVqf26oRq22qBhuzsZNHIIW2jbU6t7QK959+BGl6yBl/mfsEUPuVBtfoq59A43OfeglCWbY7DdBp62gfEbSlhB1zSZWUMtMwt1Idy687yWhwCgw6/DE/fINAwawpbNwif0tCg6abQs3CNxjHr4oCdJ/EIp9/M30RMfu3dC1L4KceU1hydrqu7A9SGsE8IvVYs9aGZIsig7IjnyQ+hEOsDCtda6VvNwbA3qkTQC2Lvirexjuxe5WKDak/osxYvKxfnELBkr5NPiDeenU6nWROuP32upjmPo2g0uEZJpeMel+DE+GQ6RgEuwpE097VTeYZMjPruLKkyiv1ODtxpv8tz95
 gRGGzBRe
 nEoD+7tYCGII56BrKx1+vM73WcJSbP6uMK5CkK9y5qMsDfSWS0wZHOhshiWEGbtxCCwi9OaH0m+UdPSsKxPOx+t6cQ0mi5n6KdbNlpQV6wv3OGe+SXZvsDyMfx7azX39snK4PUYz0va9KeI15sTJAR95QKfm9bIl2yZRmUZ7zdxRbi+GCP/c9oklFmyABPraY/jQkf8wkNnCSc8aYCHHusIg03NtcTC5ZUs3FA3BISvoK2vK4XrB3x1Mp5/R7q0Oa2O9+FLwOnahaF1viCMlnegRJ8/ud4kU+wNK4OZ8Pg4VSVzz1HiIb2cpDKqZXiZNlcJMRmHyxnk2s39AnptWof7yWobApBnbl3BIQsxL9ZLVL0d0YbjueCx9tzuyLX5tQwBLMnSqkeY6CYsWNol3ONx3roqHK6V/a7a4WHcV8LbPyK5dZPC0hM9gvfgoGsPzmnu+iQf2uZIziGACzrzFn5Ka2Qbq4xsTs1/oczr0FzJfMGYw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-May-26 9:32 AM, Balbir Singh wrote:
>>> I am unclear about the benefits of the patchset, I have not tested
>>> it or reviewed the latest revision. My big concern was that top-tier
>>> might not always be suitable.
>>
>> So you are saying that we should have a capability to promote accessed pages
>> from lower tier to an other tier that is not classified as top tier? Is that
>> non-top tier node the one which generates accesses?
>>
> 
> Yes, a top tier node could be CPU less for example.

Currently kmigrated thread in pghot doesn't explicitly prevent promotion to
non-toptier nodes. Here is how this works for the two modes of operation in pghot:

pghot-default: In this mode, the target NID isn't explicitly tracked and hence
kmigrated relies on the user-configurable pghot_target_nid. Though there is a
!node_is_toptier(nid) check in the helper routine that populates
pghot_target_nid, that can be relaxed if required.

pghot-precise: In this mode, the accessing CPU's node is tracked as the target
nid and promotion is done to that node. Note that pghot_target_nid isn't used here.

Hence I don't see any major issues in this patchset to cover your use case. Let
me know if I miss anything here.

BTW, does the existing hot page promotion cover the use case you are targeting?

> 
>>>
>>> I see that there are some numbers posted, but I find this weird
>>> "After the graph creation, the processes are stopped and data is migrated
>>> to CXL node 2 before continuing so that BFS phase starts accessing lower
>>> tier memory." Why not allocate everything on CXL node 2?
>>
>> In the ideal scenario, the benefit is to see if any pages that land up on lower
>> tier get identified as hot and get promoted. That means we need to create an
>> over-committed scenario where the pages get demoted first. I have provided
> 
> Why do the pages need to get demoted? Why not allocate them from the lower tier
> to show that promotion upwards is helpful

As you can see, these are controlled experiments to measure the effectiveness of
hot page detection and promotion and the benefits from promotion. It can be done
in the way you are suggesting; just that I found it a bit simpler to pause the
benchmark, migrate all pages to lower tier memory before the benchmark starts
accessing them rather than relying on setting memory policies to achieve the
same effect.

Regards,
Bharata.

