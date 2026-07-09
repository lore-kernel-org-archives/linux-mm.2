Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52D1CC44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 09:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C79A6B008A; Thu,  9 Jul 2026 05:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49F966B008C; Thu,  9 Jul 2026 05:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38DE96B0093; Thu,  9 Jul 2026 05:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA276B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:21:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 830671691A7
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:21:08 +0000 (UTC)
X-FDA: 84968694216.15.B3204AA
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011032.outbound.protection.outlook.com [40.107.208.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5C7FB12000A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:21:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=GsQAhi5V;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 40.107.208.32 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783588865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DUVap5NhSg/ZziqaxqjwTzKIsBO98pMLCFUpz9QDd5w=;
	b=WmU3Hwd4WRFfd80spNDQpVDyhAVUT0eD3afn1FcGPs+YZCvY/qiF8tvDC/HB8BAOBzSehr
	TgNJMhZuFZJNs5+IN2fMiKFj2gnIkHFuEeow4adrpMzhmLs/yBPwqpsChmv2WiUarbogdv
	0k7Db37jCHeJ7vwspWb3LO9YifWktWg=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=GsQAhi5V;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 40.107.208.32 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783588865;
	b=1Q9A4UBeM3jA9a8UJKSxTIqJZG0SX6fbtY3oC0iz62t3H/pjTnRZtQbgjnh+M+fG3HAkMO
	3IHQVW7y5hm3Qh9baIzCkisTgt2Jzw6NweUGzuYVFIJwhDVkdddVNoBHo+QQDYbPM1n11p
	6NY5j0HeQthwsYryxKHNTlfEOMQPF14=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uEliN25ceHX9LRcWhD5yETE9rrDKUvPjOzpGbS/KtxbDSEPP4tVaCaMybCH3l6501D/oIKD3YtwEre7i2GN/EYlElhYQoI8aG75iI0rldcCCdEsRfQlJnp3/czzf1jMgCIgVLALupjr+o1NXGsJzCefTCv8FdfwdceL2fZQoFzBmgjQ0b3fwiwsmKLtzehoo8IhUlIRYsLoSn48qCOtgG2R2UjKsXzRrLuGB7tZtiADPoZOTuEBNKiXuxc2abIKNkqrrW+6l6w2tMuZlimw03PFDYSHcSVQBe7NnywxMyJpOnHWL4SdUPubXSceZQ1bGLea1HlSiLkWHHm/B06LpZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DUVap5NhSg/ZziqaxqjwTzKIsBO98pMLCFUpz9QDd5w=;
 b=MbfbwbXllt1eRs+e4i5+IfhsjLc1EaiyYv0tcGZ6ju/xnCBh6qVIoMbL1koFs9Qyw4qoPnjA1rkJArG0t+djMKLtO7G2a6vvgm5aXSCrWsJOmfabK2aoCzZ+Xib4scIAGDdOE5aTcyK95UfvRMpPrXfXCKNI96u8eFE89D83VH0dTtArH2fidmjxeJ7pIF//SoTrSTjLpUH9O6w4RegLDeYRTPNzscLTirqFK6ivCAtyzMh6A0w1/lCjSKN7TqsxMKNC243IQs5zya+7pJUrk6atxFWDQK9cMedSOlf3itVJap9ZK83fnFkGIQwxvW+DmUwIE82q5Ee96waOHh27RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arm.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUVap5NhSg/ZziqaxqjwTzKIsBO98pMLCFUpz9QDd5w=;
 b=GsQAhi5VJSHGALYi6Fu+SQo3Tj8s0KXF9LsoVyULNqE/QaKIJtvXXfPoUoRpaft1Gvu206kai8m+u+KEUwPw5nz5FOSfphv+8k0HD/Mzd6NPbScqkZSKgKAblCQ9neAf8C7vIOkGBqd+ogey2pfMllY1M4YO45ws7mWTWRjn4wY=
Received: from SJ0P220CA0026.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:41b::30)
 by PH0PR12MB7078.namprd12.prod.outlook.com (2603:10b6:510:21d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.16; Thu, 9 Jul
 2026 09:20:59 +0000
Received: from MWH0EPF000C6191.namprd02.prod.outlook.com
 (2603:10b6:a03:41b::4) by SJ0P220CA0026.outlook.office365.com
 (2603:10b6:a03:41b::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.11 via Frontend Transport; Thu, 9
 Jul 2026 09:20:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C6191.mail.protection.outlook.com (10.167.249.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Thu, 9 Jul 2026 09:20:59 +0000
Received: from [10.128.115.58] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 9 Jul
 2026 04:20:50 -0500
Message-ID: <9a486b16-e4ee-4f1d-8686-022ef34a186f@amd.com>
Date: Thu, 9 Jul 2026 14:50:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/12] mm/rmap: Add try_to_unmap_hugetlb_one
To: Dev Jain <dev.jain@arm.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <chrisl@kernel.org>,
	<kasong@tencent.com>, <hughd@google.com>, <liam@infradead.org>
CC: <riel@surriel.com>, <vbabka@kernel.org>, <harry@kernel.org>,
	<jannh@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<qi.zheng@linux.dev>, <shakeel.butt@linux.dev>, <baohua@kernel.org>,
	<axelrasmussen@google.com>, <yuanchu@google.com>, <weixugc@google.com>,
	<shikemeng@huaweicloud.com>, <nphamcs@gmail.com>, <bhe@redhat.com>,
	<youngjun.park@lge.com>, <baolin.wang@linux.alibaba.com>, <pfalcato@suse.de>,
	<ryan.roberts@arm.com>, <anshuman.khandual@arm.com>
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-3-dev.jain@arm.com>
 <d7cac057-c270-4b3d-bc9b-c3503c5b6f50@amd.com>
 <d3f79924-6ad9-4b08-9669-c6acea584147@arm.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <d3f79924-6ad9-4b08-9669-c6acea584147@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6191:EE_|PH0PR12MB7078:EE_
X-MS-Office365-Filtering-Correlation-Id: e35ddaf6-4717-49c8-0210-08dedd9b6382
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|23010399003|7416014|376014|82310400026|4143699003|56012099006|11063799006|22082099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	krJQYhqqR8xJet59ySVoz8JnjCXl2Ih4N0CyaWh4cKbLghninolSzr8R62dz4r06TYhCcHsZgM5KnT6QYlNDK1IY26IfalurPJBA7/ogxNGMOcU35FEdZiGFy2erPKvSJX8eqkno2j6Te1fLfsjDLRC/8DXYcUXKXASl+aYM+IbyWJ8QQFICLoYT6P8UZR7GIjLy40d6vjIBKOlrbbb67CxdfYgY88PpAwuBaRF4y/RRP/tjImc+vGNzu0Yg/UJ/ApBu2kRF1lpnDksSzsPV31fQQ6SOaj+LAfLDEECuP235MveeQ1ZB/SvPaIY8YlA+SJv8Qx9cNQJ47w53Nf/QQ1cYt159w6Y3fx84Rl1TP/3euH7Jdu3n/OoTlrGgy649R6SGnOcDRZRYs7VWVFeSQXDvpkq79OB829VtjORC+gE6RbI7uTfqjpexrjxNzhYhkRrp8zEst9fialoR12BBJZGC/VH43NuNL1HZa9iW5pdyDdx9QMyh7vdvv1A5NYOX5Sa9aOLjbeXFfem1pOfvyzA+ORoMLHvHzy6m29W8S/a70lzDdY72vK5jljwmsDT1KYiu2JIRByjHyODM0DuCcS5vVgz3Q5vxf/JrvbezpagVPn1Rdu8vwQuVKZhCbCMcGZ+tcT0KwOHYSYqEdhcoYr3zZgc4rvanSD5PRacwXEsKBOmSKXBKSyV7j3wD3z4R4pGuGLL0EAQzp4ouT14F/g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(23010399003)(7416014)(376014)(82310400026)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vatmr7VsKRGPq+QZmjS2Tc85hSICBjDFOhd2RgYnlX0YugEL2q02YVutVm3qw6pF+MbOxWbNd939mNR9o+GZtPvtKrCm4hunEUU7AWpE1IyZgeUc8japF+zCt1W/kgN6OAiZZnIbsjiwjHsXLq70OB5fQjqt2D6vxIB5CIHy6EeEThj5dFv4G4KwNxCqaooFU2MC2m8RUt/NMTQVS4BSrEmFb8/STOxHaYv+s5Bd4GMdv6e/7Yt2YC20T9H00GxXrTD4fAwIAN74eenq2wUFd3CFVE1rwbFPj4w58Cww8ScJKs9Cn8a5ILZO8dQBXtSb/huyc51yPOz2jgRF0GauFJvqVjK++fDJblWvifQbMFT/CnQkfGN2OLjw6psAEj39lK42bjcsOsMQBIanJSakfaGD/vJgw7+3Sf4jd2E/z5Jl3UYaTYuiH8P55dg8GJu4
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 09:20:59.0988
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e35ddaf6-4717-49c8-0210-08dedd9b6382
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6191.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7078
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5C7FB12000A
X-Stat-Signature: 11d8htqinramixwtezybjskcw5fi5s3r
X-Rspam-User: 
X-HE-Tag: 1783588865-343383
X-HE-Meta: U2FsdGVkX1/YEDfb4s7lNeNi1H56784BJuecSus0S1pVIY8EaJUZxtFYE6Vz/NZf2P8xaRELUDMZKjGK9UEdhLwpExj3+YAOkE/NDWNcEHWXnzXsQaEbrMXhaFV4KsQbexoB/wIBGZ1irM7yvLeXYVXkFPGKCPOS87yb1JbgjOun85+V9XfsOpscbqrfnx1EpnyYzvaVOHZ1qOrWYv/LW7DbjDbyQ1YmYGx0EQQmN8TI8LF1sX7u4uBpvK+bbvFAIkUATC53jeYJUIFGJzjbbtpHVIYGul6yMu0R/VWebBWMqR6MOv9ZgC3rvClSnQX/fXzrEHZimpfzSSGMFJUxylxrTbE7cDq6UI22NTiAuR3xhLi1rp3fiMEb0bcXCkhsSnGtv/6Wy/rJUuiRLwmVfBul6JBX2qNP9Fhi2KVBobZWD0tPi72lV+L05hCjSSrla7vCQlQ345LpH2JIuXvAsV3Pin+MTqXzpfbqXOMWx+DfjqZ7Up7T3FgIemmTojZbPAAHa5YKdyttb6D1HJKd5j2wFCo09Kjk/mijZ005tDuGknFo8YIEiIg5TIDcPI0npgJTt0ThmtUBcRRSWGMoDnFTN2mRv6KeGNlyytn1ZfPHqTM1sLL2etebVQ7MPfQZlC00b+FgK7F83lWKRgVDK21RI+cGrbfBr4qFmawV2hqFHRTfbllYmrKSheeRNuSYVuXJEAW0OKJ4MxWuideEzfnQckwhtj0jrAkPeuo64jOTERs043oxoZXRZ70SKVMOcbUP899LvM7ErErJkZaoeb6B26/9DY+iOXXdh4RGbi9jW6aRax38wbXCMk2LrSKF1AOPLGwAe3SkHUAWCHDvAQ+QO4JruhqMK80GfO4tJ+O6e3IdvyShQlliczLjV4SQZxHx+BpVCSNDMd9MOnVkRE5tB2uKT4vyfYU03twwqAazQ+aj+0kem07qr4vJsrUZLz8rrw2EXqGt7ep8pzO
 TIEggaNd
 vB9TICIaHz/XXwQqxeqKTIo71Sjb8JMxYiWgcKv9e2aUid03lhCaQ++RWdhpAkmpnkOGjpN3LTw5vmLNxmaQ17kJCfkjKtWvz27idEykgbi4v32fncuKx4wYFPMrdJoWqwdcQFnBVuAqYadJSQMiPVUPuZ21NMnNt+ga8dLoy871ZdU/vqzIlERr//khO8EhynJ5l0rwpWuXT92nSqpGcEMwqZgASP04ENbBn3k3Ln5TIa+XQQoqOx36fLwOfp5T8zsZatpq1XjYbO42AjOKcr40NEc1W+7sWgWAc+1gmoIPT/BY2d+r9Y2lQTkeqxEFzttWhRRV6lTvhSyeKxmJiE7vrJIornkhZ5omsv9UYMgPNF0hQ0TFVM9zAR4RY1rjBuV950jn1mtZghCpxPmkpWJGPe7WJDenR+DRiw2xT2LEiR/busIrdM+4z2mkhoGJPyJyvhWVY0ytipirZGP6pJlA0qCSm5NJhwnRwM2kHBMD+4eQ1mQ1b/heAAm9ORHqYCIEcDSGheRDye/stx79vUpkF0SJ+qSGchndcJhKI6/8TR+beecYwT9fKYLSECOsMuea/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/9/2026 2:28 PM, Dev Jain wrote:
> 
> 
> On 09/07/26 12:46 pm, Garg, Shivank wrote:
>>
>>
>> On 5/26/2026 12:06 PM, Dev Jain wrote:
>>> Simplify try_to_unmap_one by separating out the hugetlb parts into
>>> try_to_unmap_hugetlb_one.
>>
>> [snip]
>>
>>> @@ -2393,7 +2431,8 @@ static int folio_not_mapped(struct folio *folio)
>>>  void try_to_unmap(struct folio *folio, enum ttu_flags flags)
>>>  {
>>>  	struct rmap_walk_control rwc = {
>>> -		.rmap_one = try_to_unmap_one,
>>> +		.rmap_one = folio_test_hugetlb(folio) ?
>>> +				try_to_unmap_hugetlb_one : try_to_unmap_one,
>>>  		.arg = (void *)flags,
>>>  		.done = folio_not_mapped,
>>>  		.anon_lock = folio_lock_anon_vma_read,
>>
>> Now that try_to_unmap_hugetlb_one() is split out, should we wrap it in
>> #ifdef CONFIG_HUGETLB_PAGE and a stub function for !HUGETLB case?
> 
> I'd rather not, if everything builds correctly?
> 
> 
>>
>> I'm working on similar change for try_to_migrate() and had this thought.
> 
> Wait, are you doing the batching work for try_to_migrate()? I had
> that as an obvious follow up to this series so if you are already on it
> then great!
> 

Yes,
I'm seeing significant throughput boost when combining it with my batch copy offloading series [1]
Once batch copying removes the copy bottleneck, the rmap walk becomes the dominant cost for PTE-mapped
large folios.

My experiment with move_pages() on two-socket EPYC Zen 3 to move 1GB anon memory from node 0 -> node 1:

  folio   vanilla     DMA (dcbm, 16 chan)
  -----   --------    -------------------
  2MB     10.7 GB/s   64.3  (6.0x) -> no change for PMD mapped
  1MB      7.0 GB/s   14.3  (2.0x) copy offlaod
                      39.0  (5.6x) + rmap batching
  256KB    6.7 GB/s   13.0  (1.9x) copy offload
                      32.3  (4.8x) + rmap batching

[1] https://lore.kernel.org/linux-mm/20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com
 
> One other function to batch is page_vma_mkclean_one, but we do not already
> have the folio there, so have to be careful.


Thanks,
Shivank

