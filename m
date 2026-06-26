Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7433BC43211
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 16:43:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34CCF6B0100; Fri, 26 Jun 2026 12:43:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 324336B0102; Fri, 26 Jun 2026 12:43:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23B796B0103; Fri, 26 Jun 2026 12:43:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F06DA6B0100
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:43:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68BF6A0514
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:43:18 +0000 (UTC)
X-FDA: 84922634076.28.0730CAF
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012010.outbound.protection.outlook.com [52.101.53.10])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4298420006
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:43:15 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=mmHFA1N+;
	spf=pass (imf31.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.10 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782492195;
	b=aMXIqdlOEOTnV376T2GcvOOubljskTjVu4r4WGZAp09jLJLXpjQHiw4wyzskPFAdUGtQwa
	ZgSI1/yUJgPBYlfo8tg257JpxiKIiT3dXWso5thpjEvB7CyrAGlF7shD1Jl/vcVSPiz4f5
	wx+7KI2ufNJSvlj617EEe6/8cd2qGsk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782492195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9gY2+6VR2V7S4I9bmKDsSE5Y4LXytlAuGMhaBiyK6Hk=;
	b=u5BiVQq7F6hIUsrc8PXf4kZdLyFhDMCCvq81tFUWGFZFoO5Kr3kNMzuxoZMm/cB3fXh5HM
	z/7VWcxrtMvpuTbw8B3VyFcQlqbowoMOUYmFATuiZgpanhgHCWSBbt80AT6BDolLiXMfb0
	ZxIcEtZMy4wVwC8j4DBEP/ArUtu4mrU=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=mmHFA1N+;
	spf=pass (imf31.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.10 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qMwODhPpSxKcaYTIfiTaNP7LA0kSSAmLshJ0o6ZRdWWf1NL0nFRCeAtU7VgjteAs8huyAWlHwdDq6oxfQhmS1GNE2d9zFX9in2kjPqyUNMzgpM2Bd/DXAzxemqqrtbf9xopwzpPF3gsVMUr5ZsTkpigcGOwaqvbxOMzE9g/UIcMQ6C20ByJgB5mBAKwwm+puPPDPhh/OV6+rOlC6CxMjZClm11dwiExARWMq2rYTZUP3dXb61lU10ndT3sxfehvc2jeA0aERYeNq2QPbJKK+WwAGKWiolCuipCiVMRBLHlsMKmuAEmLTzRyGnJ8nqmlfMNjd4nGjnmBpzPzlgFuTMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9gY2+6VR2V7S4I9bmKDsSE5Y4LXytlAuGMhaBiyK6Hk=;
 b=kt8k3mzQog5oU4mSZvvBov+FSJnvKUEPOxRjn8yVO04Pc7l2ojnDVgm1tqr4Eoc0MOelUuAc6SJ1WzACd+Ul/cv2OLU9P1qSn2hZOkrHKNpkgbAJ2AOZv+jrWBq/tXrSFQn4efYaC+b9rSH4lOPTztiIPmOIQ0Dbt9cIqfJFW9IHINYeeI0JbkFoRAAfXDsF3Nynv1HWF0eraFZcdaYMtN8NmKgTxu9lmq+YG+mkJWH/1oaEVEO9bzhpF8zztOf51ZSQqBJ/NWK3pD/5b/IVV6fFLhutD2LlwRQA7BfdjU8KW7Zvn/jzSKiskU6uOAltPEsqNVmkuNnm30SYtgmy6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gY2+6VR2V7S4I9bmKDsSE5Y4LXytlAuGMhaBiyK6Hk=;
 b=mmHFA1N+pTEW+7oq8Z5XtOa0vQ1vTgMTeRoSl5tkFLLEp1UiI419IVoMY/IDWXEMZ2pxsk2jmugY/ueQtf1QVQWPqIS0zjI9ERT+6HmOnSATHbZcvd5l3b60dwh5CPbCirveSKmziU+/un/SbfiK1swN4D6+2A8q2E4Xb82MacE=
Received: from MN0PR04CA0011.namprd04.prod.outlook.com (2603:10b6:208:52d::7)
 by PH7PR12MB7019.namprd12.prod.outlook.com (2603:10b6:510:1b9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.15; Fri, 26 Jun
 2026 16:43:07 +0000
Received: from BL6PEPF00022574.namprd02.prod.outlook.com
 (2603:10b6:208:52d:cafe::77) by MN0PR04CA0011.outlook.office365.com
 (2603:10b6:208:52d::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.18 via Frontend Transport; Fri,
 26 Jun 2026 16:43:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00022574.mail.protection.outlook.com (10.167.249.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Fri, 26 Jun 2026 16:43:06 +0000
Received: from [10.252.220.114] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Fri, 26 Jun
 2026 11:43:01 -0500
Message-ID: <6d477d0b-1f14-4e33-958d-e6a66c647963@amd.com>
Date: Fri, 26 Jun 2026 22:12:58 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm/migrate: rename page to folio leftovers
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Dev Jain
	<dev.jain@arm.com>
References: <20260626-migrate-cleanups-prep-v1-0-a95933af7619@amd.com>
 <20260626-migrate-cleanups-prep-v1-1-a95933af7619@amd.com>
 <53e834e9-2cb1-49c1-ab27-2d6b51d50fc0@kernel.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <53e834e9-2cb1-49c1-ab27-2d6b51d50fc0@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022574:EE_|PH7PR12MB7019:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d6a214e-d3d7-426c-33bd-08ded3a1ffed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|82310400026|36860700016|921020|56012099006|18002099003|22082099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	nXp6nWDJBGA7cXb5E0WW3E3ifmS9nbe+2cqyM9XE4NlihGB9qxlR3Sir+sGLCH68dW2M/EznB+uug6JH1DmszrWdHwHfGHd1fbg2buVWyYnM9/QTjhCu7bNmaSCzI5ycqCZpOyiT8VZsEqAV63e+4rJZggOd+3Al8XrzBbvtDGC2ScNYXBqUQ/TfRyNcY3BP/pWYl4pWPAA+nAdupOCzyBGcIIujdCN9CW2X8hvUTATJWEfuEAKlNP4xd/6ByqUqTP6bEP9dUChOcsxYATm/lRkyNTxZE9c81z9rFv2SnROhqm97PzOwLGBzJR/jqDxAG54OGivbBqjGGbzybNg3s2aSdYWdkxMwnbIhnPTI4QJEAYe0/9tdkxzS/kS0gicDoBQ0dUIBFZeAPCXRneIjc0nLCDJYCQfZ9RBo7IrLCAYPDI+qu3inpf47+9dqVk1QJi9gv4Va8GqvLKiyWLOPYi/oCAOjopxBrxZ07D6s09LlDvpWKycJeCeCqRGDITcnlYv7qnmxMjHp+frmEv7W6jqHk1zyXtg+P4IkkVms/lur4IM7ZcVh4AtItET73Ueoullshz12E5eWLcBkwoUAKaBM5C/59STMMgyKx6VlB8GULRaxkPmvIhfDARmGFwRJzC0an8G6kr0koiAjxZjvdhibbkiFwy2HzGD6s2+lcnkjCQaIMshSANDupII+V9lGvEEBx744jImJrywk3soDZ/S81AKLMqi3w/6kWI+5/unWOnbs2nhkbpDFqpnRMl5l
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(82310400026)(36860700016)(921020)(56012099006)(18002099003)(22082099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nSYpHncaXQEP4hU8loCQrfPY7M57+c4XoYhyrAY1Rqvt0SFaXBTjh5718bb9PSj4guH5sx4JXfrUiYrHsIFYo3v1QarNEKtirMVJIGrA8GP5GYiDsBGGIHmMH3mTNNVvJUTU5HTn5/STEVWVPrQZTGrMRxOqyV0EJEBlPR3/GFxiUuvCig+4h2Qf4Dwgn3Kx7wE15ro7loyHZVtFV2Mrn7c0GxxspCPjuGSWB+3P7UHiJsmZYNQosqxroq4AFQTmDaudvFN0kLesdY6VmFlsS3sIesVdg4RzXXFSiKiME+wOmglWAPoyAe7TYSA1ryBYG3i0DZCBTrKb0VPP8+lMRrlaC2PefcQEgFKbkAalpsg8+rjpZCpdaMOnfn7EN3z176IxrLdpSx0XqcoYs1NY9FuD9Pbuz3iqxJDDtCN+9BNF+NDx1i087LVeJSfUUxDi
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 16:43:06.9686
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d6a214e-d3d7-426c-33bd-08ded3a1ffed
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022574.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7019
X-Rspam-User: 
X-Stat-Signature: zg4pm458ipas68mjmrpcr9zugxymwjpk
X-Rspamd-Queue-Id: 4298420006
X-Rspamd-Server: rspam06
X-HE-Tag: 1782492195-353338
X-HE-Meta: U2FsdGVkX1+GbuW8FIIEfUVBk36ehXoxlkjiRRQuoZTlysF0mKAB1q35L3Lq89RB3ud/UTO2j4kwGUFnkiuoXhm5gbY9eLsiSxH/ywof2o720ZQk1TLO6jU3Lq5JkCvs5I6zdM8/eQv03HvlYDBlj34j1Z8o2uvhFh64/VkFzJrcBSAHfWojVNklaNe3Qcni80NoT3Lmd/e9LIGQZJ/GaLDq8ZyHE276DkFauLnLjW4+5K+IpN7hZeME5OGiBhTS3zxA5tnkRq7sg6dNtvTZo68O62UNiW5/KDS1tk8ZFOAGObf9TCTVrZnQW/V5GrETFgrv/cXqbNRlnr7Y0j8Cvhfe/HrGKqKNaygglSg2FLWZdCKTGdCRrWv+jPhh1uvSV/MqDl8PWSJjpucMYF2X4OaFTE2f6ZpihOlYfP3562qsIgyVSn3I5A0AD18MBE0bZqcDJj50QZEdIuw0Qe2YWhK5fmrQ3W1hOWeQoXfAJH/6VIWSL1GeAnWGkRJNRkHT26HT/pMKCXGSppz6Ty5nhoFvIR0QrWFpmmeGs7YgnF08D6E8y6ekwtwfeBkaix1qcfblAn1Tdr/XN1cbaoXxBD9qGWffv20skkQTUjNevXSdQS1Jc/CsT6EDsQqsV46wanI6mAjQl3+m4aU9mEQNB/FPLBInfJuIZKfdTYaQSesmlSkrUfOzVISeLWoIwpIsdTB5wJHQethzRXQDmi6+bVH5rJxI7Mi8Oij951ouxOMEXP4j7ENIgSM/VlVb7GlkcpuFCC578EndrgnhOL/+YX+Y80ks0Ni0p20cR6E1LisyrSl/ZIA+Df+Jiosu0nSGrVHIYFwS9A6sBHFTnxC0E+ulTjIj6GRtZOATARgbuTJ7mn74TMCqTtLGbsif4SMA/OIkTFr4rcFY/K63On79FYvhZDO1OdGCbDI9JPXaXBUsQ+CY6tJG1ihJIkAFAunHGV1ZALbNUpitGt8uRUj
 0EFpvBVE
 TUEvb7xYkiLy11feyFLFQ1wow+aTYHUE7nSXWpW1VpAxdAcxjwiF6WtA3cq5PUUQf0HKmrwxM8//hLw3Y7Ign3DOEIRyStn1PeU+KmpuFIvH1cz47mlza5zHDT6W56Ooa427f/IJtxljAsgwkOq56rGcdq2p6/KFY9KYi2/67H/zmYZquCkJ5EYHMHfqZmYt1/lcSqZA2QPNq8mO3mV5tpi7MMjQOAZ75sai/GM4c4ItZMOfDAWxeMxREE3GHIA2P69JcSbWqN1qVjDdsgtwaTdUf26Vkd6h3Xlwd38M3oBbps1oJjQefpCZ7Nxtd2T3pjFhQv8BBPm7U5KYyeqibR3pQmssDItGe1ypQuUztFmNEMlMil0grZoTipQdLgbn2YD59J1YTnGEJFJZvXq60bND33BkcLmmJNgXjM46fbUVGdAnGE0pwcIF5F6wWXL7T+fcY4zQyJJITW4tQixnqxHl7XuSjI9lajFCw830ufAV20G+QfHx10xNZ9D4Sa73tkMGMgwxbP9l4Rue+u5qy3HNwpI24t/THB5dVERVXh3cAyeLeSuMsa3CRfH+9iI/D/f06TjDVEfc19aEyORXBgRC3PpIfs2XMWe4lk4x4Ui9dQLq0aIzNVBLk7rtFVMvm4oOc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/26/2026 9:40 PM, David Hildenbrand (Arm) wrote:
> On 6/26/26 11:37, Shivank Garg wrote:
>> Rename migrate_folio_undo_src()'s page_was_mapped parameter to
>> folio_was_mapped, matching FOLIO_WAS_MAPPED naming.
>>
>> Also fix migrate_folio() kerneldoc to say "folio" instead of "page".
>>
>> Suggested-by: Dev Jain <dev.jain@arm.com>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>>  mm/migrate.c | 11 ++++-------
>>  1 file changed, 4 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index d9b23909d716..dd7dbd8d84a0 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -884,7 +884,7 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
>>   * @mapping: The address_space containing the folio.
>>   * @dst: The folio to migrate the data to.
>>   * @src: The folio containing the current data.
>> - * @mode: How to migrate the page.
>> + * @mode: How to migrate the folio.
>>   *
>>   * Common logic to directly migrate a single LRU folio suitable for
>>   * folios that do not have private data.
>> @@ -1157,13 +1157,10 @@ static void __migrate_folio_extract(struct folio *dst,
>>  }
>>  
>>  /* Restore the source folio to the original state upon failure */
>> -static void migrate_folio_undo_src(struct folio *src,
>> -				   int page_was_mapped,
>> -				   struct anon_vma *anon_vma,
>> -				   bool locked,
>> -				   struct list_head *ret)
>> +static void migrate_folio_undo_src(struct folio *src, int folio_was_mapped,
>> +		struct anon_vma *anon_vma, bool locked, struct list_head *ret)
>>  {
>> -	if (page_was_mapped)
>> +	if (folio_was_mapped)
> 
> Why not "was_mapped" given that folio is part of the function name?
> 
> (it's also not "folio_locked") :)
> 

yes, makes sense. I'll use was_mapped.

While here, what's your opinion on unmap_and_move_huge_page()?
It also has local variable named page_was_mapped even though the function
is fully folio-based. The function name and comments still have "page".

Thanks,
Shivank







