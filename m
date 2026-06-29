Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 884B2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 09:25:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C8976B0005; Mon, 29 Jun 2026 05:25:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479A56B0088; Mon, 29 Jun 2026 05:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 342396B008A; Mon, 29 Jun 2026 05:25:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 032C86B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:25:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 601CF167FBD
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:25:21 +0000 (UTC)
X-FDA: 84932416842.09.DE901C1
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010029.outbound.protection.outlook.com [40.93.198.29])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2FA1F14000E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:25:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=icXu5QsR;
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.29 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782725118;
	b=2fD1OAV0zquGPF3Le7sv4PI3zNguOfx8S7YDGNIc/jaEmcXs1yjd1N6SBkkuzLpNGWLBfQ
	uXobX/vm7iPPYauzl5G85jnU038LrPmdXNlDie11zhnrGUdZWEFDd9Q4nzN7TasGlO89q/
	iwsD3gelI45/96CKk56QYJ80rwevvOU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782725118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9nFwbmP0/alm+paLOOk31r4Ih+5UNYoQskNpVC5z3Ag=;
	b=fVwY9g9vsnMYU7P2cQh9DOcV0TEwhX2QXOKB+ycS4Q2MPCgfluL1N/puGfUI6JBXGB8XYU
	QknlKJw+7mK11omFpfhJolByos57wiFdEPVEgaHcOsMCO/LPbhtU4hEazMIMcAtXS9g+1r
	AG3H153VVJxpL/CObIs+1fPJAxUYsgQ=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=icXu5QsR;
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.29 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ya4dJvP4GrqVLKGhaUlF+WF0vfjDmFAfAbsySqSjMSprH6bbpLv7nHWqd6uwUhqppOWZU9or01KIMeTyZQz4uLl/O6g5ZnB/VCVPzfyPz30VARxhdp1v1crlSsrg5SJcRRFKy7nbxOqRvYeXRO9DHG+YxqJEKUkEpeUnGJPe4v5j1p1akroXhumlrqgGOA8gOD0Sea6Pj+YE3rAgvFl0nCe/XSCizc7TR0/BE3MMn2fwdlRYqKZHep2UyhLmy+Jk9VsewOwlv5HBaemPHb1xTeI2MSnDZ8RkNAUM+aevUud6G8F0Qg16EW/ai3N+v+Lp/JfxOueuIw2JvCHKdmGc9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9nFwbmP0/alm+paLOOk31r4Ih+5UNYoQskNpVC5z3Ag=;
 b=BN55c9A/tbkCZ3XUivji7F1dkace5NkpSTqm24JWeZrrrRyv8LSuNpTL6xWZnrF0JGkrhEqyOSx7tn6TxtuUZfLHrv5KgIi/p28Z3i9g+5MTH7903ZCJ5BFmW2Grle1CYn6rctLZvA+aGIiWCgWU/2+HGyzhmNzh6co9fqH+aPUPkXeF5F/XUjdsTnJVkwplDIRBg75cW7ZuG8rsrfb+SUGCbwYBddAKhX4aXZPa9TLW8H2bhgTEtrzpp2nZ53C7VbkcISK7oT4jo10LBc/wmjN8a9C/E5gqjx2BnyYvTlPxxNDgOWrphJT5voTuIAQ19mitFBM0h5r0x0bmHMcRBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9nFwbmP0/alm+paLOOk31r4Ih+5UNYoQskNpVC5z3Ag=;
 b=icXu5QsRCntXKYLjDz3uy6+R89t6v+S5odAG7mTQPlfecwNnxH9mSFOAK3ahL5ySwmSx5S9PFeqT+D62lQcXlWCxu/QCqcO4bmmyywi4PQuuCgIVDr4E8HrhR1/TEQsUeVBda6yXdl/s1D3WqyNybF1QXZWKkNUnzZH9VlDUrio=
Received: from BN9PR03CA0219.namprd03.prod.outlook.com (2603:10b6:408:f8::14)
 by CH3PR12MB7499.namprd12.prod.outlook.com (2603:10b6:610:142::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 09:25:10 +0000
Received: from BN1PEPF00006003.namprd05.prod.outlook.com
 (2603:10b6:408:f8:cafe::2b) by BN9PR03CA0219.outlook.office365.com
 (2603:10b6:408:f8::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.19 via Frontend Transport; Mon,
 29 Jun 2026 09:25:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00006003.mail.protection.outlook.com (10.167.243.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Mon, 29 Jun 2026 09:25:10 +0000
Received: from [10.128.121.109] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 29 Jun
 2026 04:25:04 -0500
Message-ID: <8c9f56db-88ef-4c53-a488-1178569760f4@amd.com>
Date: Mon, 29 Jun 2026 14:55:02 +0530
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
 <6d477d0b-1f14-4e33-958d-e6a66c647963@amd.com>
 <6da834ec-e62a-467a-9951-b591cf9c508d@kernel.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <6da834ec-e62a-467a-9951-b591cf9c508d@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00006003:EE_|CH3PR12MB7499:EE_
X-MS-Office365-Filtering-Correlation-Id: fa9290d2-6851-42d5-e027-08ded5c05129
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|7416014|82310400026|376014|18002099003|921020|22082099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	Z1WqVbLJ0At3OAZVTEME3h4qiKZXkBOe+CsJBXZoZgMtcGCd73TGHah2Nsx/Jg2Gb160OM+QwWFA04EqAPPM6nIobtTuYKfNfFKh2hCSHn5dL+btynagVK5WGiPgp8mdPeoWEDT4yQBS9xs4QFWNAOtmfRFhLj+b77D1l5DzBndRCMNizaXCf4EiocUHfnrMe7y4VGWeajKqAcqWcC8p1ChLTTq5+CK9P2NnJj6k1wbHkGtUbaasA82qQZtMx4X0XkcQsobU9bLLUHveT1J0aUz+c47ZIch+3EjXlOHVhf/U52QTV9lbKT5Cx3giuleoFHsERcRdnEuHNQ7U400AIvKUl0QqTt99BMVJfa1ib8eV1XYoUJbK52co3f2fF1UF7o1cF+Un/kgGA8/Tsow4K8uOUeljmQvS6CAVeSLK4WNlIYjz1q5LAP4gUpa+vjJvxlU4TVA3YCgpVVaIKcwFrK5THXOW6CUWLBlQbt0eUJplJ6+7ZxtZZ9ox0whM+0/EgZF6THeYDzMXZs7J5/3C+nL2Ku7opJVg2E6EVEBnEHNk+ikRGr3xXJkpIET1wewXPSLBtV1cZ4yn/pDak/o7AryexINoYjm+qdWEa8VdIaeiQngdWh3kib2wtVpEY+YxgPkOkzo4cUJxko/+XpdQURiD4hSxPHxCrUHCGFkKSX6/QUSEOzBorDJLwaW24D7wyXIA2z45cP7fvBjhvIHRDDdcDmfTwaIjAgC/PtLhx1Shkbresulz59DD7Yp7f1qN
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(7416014)(82310400026)(376014)(18002099003)(921020)(22082099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Fs9VEYS5ecnyhiSjcfJyOwi6DTIVS4sCqurp1dwGDcWPfNCqDYS9uNpOIBYDd5+n9vfMQt6HoVB9ktpY5C8RLC96Yy2W39nzFRePYoCiF2J8+WuEWbULwWTxRzz8tNiFQtOOkqinOZxdlaBrNh62dj/bI/EkUtKpxS2ipRFm7q7yDZiLQDFh6874o6xnHQhCr7LJiuShlv91/BimVEc74Ga9+eZENg9DHg3d0JDTJf78QnAMhtfWCxPHis5TH0M566XEkAG34Gd6tU6mr0vfePHqvowvZ+4w7Ls6UP0MokY5RxCS56VuMO88KBzIrMyPk3j3LEWLXTjh5mzJrj8prmMsSpa4u4mWWAWlMxxEk1WcNxWwZJwWcf73XYLkmox/BmOCb3mwTwTE+e4+mnQjo6ee+SLHoUo8KmGTx1DO4AZwZwgkfM9XYTA1KlIXFoFO
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 09:25:10.4934
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa9290d2-6851-42d5-e027-08ded5c05129
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006003.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7499
X-Rspam-User: 
X-Stat-Signature: kgqey4gn3b39y3n7hdwkgxzfkcwcx8y1
X-Rspamd-Queue-Id: 2FA1F14000E
X-Rspamd-Server: rspam06
X-HE-Tag: 1782725118-712737
X-HE-Meta: U2FsdGVkX19o5eSU68hasgVhA4sOGH/wxYj+mNulOGzpw2fnlZm0lAB3W9fFh66Y+aRSngcDJs+2T/plqutiONQDS3mfstZI+MSzX542M3Bm4q5ObYLFFOuI4rz3tyfTAv9utv0uILziw3V+nJDjfSLEtb/QM6aOyJ2+f6IeM74Sn4VmbYrgY2cQNnzRFdFm8o8Zzv2zma5s5j1H/g8jSg42G54LJdtPTOvwWvjAulzIWJczHEJF3ZuEus2n0KMvYdaeUbGPXMlv1FebA6tIkMryPdGpJJ9ue9zGuqQer5LEW+pYfH9k8HQI8vmQjP5/v5i8Ju6u7iBPFDYR0VOkxiuQGWCDw22yxIJVF/Xgcko0xpYSYEewx/zx7Q//EQYs1I6bi4t7vpQp8/dSGhft70ctzApmjaOwPB/GnhMMthMXyxcY2/CGx61+vW9JD7EzozwOhtch8ljveA6EyxBQJUyIeN9KqNckhU6SesXLgzM/IE7pOYoBdVG+Ac6SoNGQ81zJrLLVSYaqPN4OE2eTB07Rbr55j5NOOh9/K+c8Rb26SUFQXeZM4132u7ArgzaFVYIKN8l34y3B4qle8U7BAr1MbpXyN+yvVd/tu/eV6wIrz238Lit3v0coezj913i8f9UiCJGhnFXMv0pzUBCu3RbC9hp+U/j7ydRis+nUn6AyUYGuZhgb6Swn0cA6pmqwyly0x0qpWhkH1IVY9nIYs58tLbHbkVfNSRwQq/1hxpSOh2fGg9DWeXO1sII+wdXe5eyQnyPzueO/BnZ7i7nZVidYsi8fnhX44MxXouixI3au82rnSQhJ7KBoZVG52Zx2lGi2NJxkBfkWKo0vu1j/coLg+YKBVRF60hQyI5uxdAWTIOuZoiUkR/jHDc32grbVMtgAIPcegM8fRi2zsQRYX6LYYWvCHzowXatiLXdsdL6JY8eK4mHaZwpQ60G/ckL+8qjIe4zoFQCpDs8U1t1
 dKU0JcCB
 i790No5nmBLww7SoymFZn5cblifNasHpBJ/bv9qdsP55vrtuGQ+ETZP6+w7jva26EhpmMwa+BGgLAqe9hivgJDI4dBm0lL7DaQo1UBX3KOkmUkpEyFOghxU0mXdWof02a63uINOoeXCvFd5jbCZ6d/1XBDLpRxdqdic6cdTlWVzp+SX/AVlhCQ4+pqhDb9G97uE6LMcZAueYUTMnqGHV+rQet4e7LxZc0zNGkqGJ+/f/xSXXOkCOeotsrOfNOSKC4+PcRbde+is5tHB1Fv3snuQEoQ+oss6aQ9vK7rgVqHPHjoAxHyZpJZE632CvQMraxSf9QeOrDqGnbQ8pag816yW2W/Pvm5Wq5T/Lm4V6qNXCqLnN1qaBcPAuMkI7O4oCQNGE0ScQp4IcXJOpm1aGBOn17xJz6uIp7os89qn1ea/Cs91BLd7Z69Ow4qvXuhxzQMtc5xtyUUdYSK3XfhGAORGuttgXwpL+ueftMMHWRLQKUwy7uOZKSKyoXw0IKzeEHJxVEQjd47G/Q9wHp+eSup4R/7l+V7tEDO0n6CX9dvRL+gVpCHkmYvt7Bo/Yp8uQ/pjfg5ssbgTC2tyGYJ69bWSCRN/1cNoqSbfhEl03duux4B/6AXJDCfS2oHn0NZ6C2FyWI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/26/2026 10:31 PM, David Hildenbrand (Arm) wrote:
> On 6/26/26 18:42, Garg, Shivank wrote:
>>
>>
>> On 6/26/2026 9:40 PM, David Hildenbrand (Arm) wrote:
>>> On 6/26/26 11:37, Shivank Garg wrote:
>>>> Rename migrate_folio_undo_src()'s page_was_mapped parameter to
>>>> folio_was_mapped, matching FOLIO_WAS_MAPPED naming.
>>>>
>>>> Also fix migrate_folio() kerneldoc to say "folio" instead of "page".
>>>>
>>>> Suggested-by: Dev Jain <dev.jain@arm.com>
>>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>>> ---
>>>>  mm/migrate.c | 11 ++++-------
>>>>  1 file changed, 4 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>>> index d9b23909d716..dd7dbd8d84a0 100644
>>>> --- a/mm/migrate.c
>>>> +++ b/mm/migrate.c
>>>> @@ -884,7 +884,7 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
>>>>   * @mapping: The address_space containing the folio.
>>>>   * @dst: The folio to migrate the data to.
>>>>   * @src: The folio containing the current data.
>>>> - * @mode: How to migrate the page.
>>>> + * @mode: How to migrate the folio.
>>>>   *
>>>>   * Common logic to directly migrate a single LRU folio suitable for
>>>>   * folios that do not have private data.
>>>> @@ -1157,13 +1157,10 @@ static void __migrate_folio_extract(struct folio *dst,
>>>>  }
>>>>  
>>>>  /* Restore the source folio to the original state upon failure */
>>>> -static void migrate_folio_undo_src(struct folio *src,
>>>> -				   int page_was_mapped,
>>>> -				   struct anon_vma *anon_vma,
>>>> -				   bool locked,
>>>> -				   struct list_head *ret)
>>>> +static void migrate_folio_undo_src(struct folio *src, int folio_was_mapped,
>>>> +		struct anon_vma *anon_vma, bool locked, struct list_head *ret)
>>>>  {
>>>> -	if (page_was_mapped)
>>>> +	if (folio_was_mapped)
>>>
>>> Why not "was_mapped" given that folio is part of the function name?
>>>
>>> (it's also not "folio_locked") :)
>>>
>>
>> yes, makes sense. I'll use was_mapped.
>>
>> While here, what's your opinion on unmap_and_move_huge_page()?
>> It also has local variable named page_was_mapped even though the function
>> is fully folio-based. The function name and comments still have "page".
> 
> Ah, yeah ... please fix that.
> 
> And while at it, rename it to "unmap_and_move_hugetlb_folio". Thx :)
> 

Sure, will do.

Thanks,
Shivank

