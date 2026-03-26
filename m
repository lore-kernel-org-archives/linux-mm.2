Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0E0E109E54B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 05:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581AC6B0088; Thu, 26 Mar 2026 01:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5573C6B0089; Thu, 26 Mar 2026 01:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446DA6B008C; Thu, 26 Mar 2026 01:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 380B06B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:50:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1A401604D6
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:50:46 +0000 (UTC)
X-FDA: 84587140092.24.00CE45F
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012004.outbound.protection.outlook.com [52.101.53.4])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9C189160004
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:50:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=b+qCJDFD;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf08.hostedemail.com: domain of bharata@amd.com designates 52.101.53.4 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774504243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNB5padoOWlvjYbphTaRwuf+94RYO5+C5D/RNAPni58=;
	b=KsIFkzhY/tC380n1+Zv0b3Kt1kMWLnBWXoYaeGrJPXmogpQsSr15Kra7xvc+e+9XXDUJRM
	0g2I9drPbRyDbXMsY4kjg2wrDABhRiCt0qteqUKoBDS9mJc/QZs0+ETvTNmLoc7N21OVcy
	uGyeYtX1XeW5Hr8kWYk0Y65HlsuZlLE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774504243; a=rsa-sha256;
	cv=pass;
	b=bv/g5+kBHxFzRtnbo7pIMj6dKIHXApcZR00CEE/uLFrGs1xR7FWyPJrQfCq84akeXlJ2Im
	/0xaPVeZvSjhbTMSq0k0FJFxNFDqmMjhb94FnlDQFGrUX1rvWPmZefFSfogTeTUR1uWgPP
	8OLXkk8rkkODxur+eCloJ6pHhnCWVcA=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=b+qCJDFD;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf08.hostedemail.com: domain of bharata@amd.com designates 52.101.53.4 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NYMFbKMp8g2eGfcnQ/ISZgQhWEzAj6hiLGgB7Km0WijpqArpR6D7o//MjEdxYHwi9chcdXK4pUx8dlE5GPiJwGlTUjFNDLLZV7SI45vTyRqkua2SJQTnX63D7Y1GRDEbTDQxl6RQzc2PwYkMAVx3Fc4axQ7/R1ebiM82UIniOmP05YfhbbHLzyI4nfti7kOgZ5xqTYC6T8qXAGph74LuptIZtYv4UwUBlKQemTMs4+Pxaco+VwUwU+xs6bf7FIo6/GL0WYFa7xxqaFzquNWMBizWjov7ef+bFFlvh1NJzXjXprvxLN7mFCHmtZve3Q9L3xy/yOfG6VlKomvpC1bHDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pNB5padoOWlvjYbphTaRwuf+94RYO5+C5D/RNAPni58=;
 b=iXhVckKagsJnMRhj9+PPh2N5zAszJMf8N6PlxWFTpiAYLmglX3bp9L6b1ut+fTBqhND4CnI6vZuEuBEi2UG3JCksX5Dk7wEhBtvSVVGQf2K69DMNAhNPT6DcmsOFgVflJBIavwUReWa7QnUpP3y9sUfEMxtNNtqvUFf6Pv68rJ1CNZ4Vy6f7EVgub3w6nzjUp2tehlDVgK9n9ZsghnwJeBo24vY3SldU5hqPEiiV5j2tzzrgb28Utg4NXyYSgSrHaqQAQD76JXCXSZ89dUzpIUJe1kV4RN9QUiKGFMWFpXEZ067H/SJfO7ejabGPgl6aGDnDOCXGl4gvSOp8Pv4kog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNB5padoOWlvjYbphTaRwuf+94RYO5+C5D/RNAPni58=;
 b=b+qCJDFDWGaBN1EBYpNdFtlFp/N26Sf8BpCEpJAj7Q6ee+B0Rya/sPZlBl2aBe5KcYnxi9vYVu+y6EfOT+LS/ARsKXyDq9hfy34l5x93ICCQs0G9b50cWa6AAZJ7/KxIH9RzMG0vnSqZ9NA8UTwkcSXZbZzDofUg/CBSHhvxnVk=
Received: from SA9PR13CA0013.namprd13.prod.outlook.com (2603:10b6:806:21::18)
 by MW4PR12MB7166.namprd12.prod.outlook.com (2603:10b6:303:224::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Thu, 26 Mar
 2026 05:50:39 +0000
Received: from SN1PEPF00026367.namprd02.prod.outlook.com
 (2603:10b6:806:21:cafe::e5) by SA9PR13CA0013.outlook.office365.com
 (2603:10b6:806:21::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.20 via Frontend Transport; Thu,
 26 Mar 2026 05:50:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SN1PEPF00026367.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.21 via Frontend Transport; Thu, 26 Mar 2026 05:50:38 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Thu, 26 Mar
 2026 00:50:38 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 26 Mar
 2026 00:50:38 -0500
Received: from [10.252.223.214] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 26 Mar 2026 00:50:30 -0500
Message-ID: <df23458d-199a-476e-aa81-9aa2e40bafe9@amd.com>
Date: Thu, 26 Mar 2026 11:20:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 2/5] mm: migrate: Add
 migrate_misplaced_folios_batch()
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>
References: <20260323095104.238982-1-bharata@amd.com>
 <20260323095104.238982-3-bharata@amd.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260323095104.238982-3-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: bharata@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026367:EE_|MW4PR12MB7166:EE_
X-MS-Office365-Filtering-Correlation-Id: fbd925df-5f31-4fbe-d687-08de8afb9bd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|36860700016|376014|1800799024|13003099007|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	RcSV04LhffDHb0ext0PyFmHR9wgCr9HoG9teo+jtbC8bMNMqZXg91qLA3cnt+1ITLv0jQr5acq4Y8EgkS/NOPX16qiFaMnqEJL6jnGjCHiBHsjDgM9BuwgQrpkQ+ITHnI5ZN1knvSeZ44bQ3U1fijNuv7UivTIhjAGoyVcqx5Smn7kulqGeYlkp7cOCgXPnwhimF2NpidG5Zeg94bcflDU4YfE1jBzAo2IfVk+1OFl1xOdMOfdzlBOYZQXG+UfGaxzNmbNk684F3iDHUtwWsAv5c2cXlUjppd2B3JTAFFma75I6RCkeDKG9szqDnJu5GVNkTe/2by4VPHCHaGwkG+vlXDp8F8tgYHTzjhaqsNEhcb+wjHNkKXs9AXyP+DBbA/AmwsMFZOxezO0YJq5r/7UquFZjFCuTcjna/58Yasvy56mbw7JZvux20txVTdLTvAeExAROte9uo3BQf82++2AD1/vJPAchLNj3/eR6mHtk/Ha2eFayHNKGKABvkIcKI3OXrwkZ7q6wZRwVNrByPlbx5Xbg7HxW+YsDShO88b4ABm7ZqVSQMRvM3I0xVKrxf5CIjtFKpTCUyjVCjwTCAKbGOKr4RymBdzAHd/zEG4SIkcL2IiKJizRGuHQsWbQS0CJh7sVAQmZOFubftDqW6r2qaJyUki6dj95CUOGzQGcaCMtFzAnD9UVn80BDQ8gtEXrYa5Pwh3ztIqkSRCUbsJg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(36860700016)(376014)(1800799024)(13003099007)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dU1MuG4VAQaIrQNsh84IzmVS9o7UXzIQ8Di/rQXlW13Un4OiV3W0m+8U5jl0vVzWacWaAriCTNYG8kswyyn0Uapn1LCaYJBGQISRyVy0/VP3ZDuv5huwhGxLryh2BxxntI7fTizTmaIcG94nqcO4T3PyisnT1aQ/riVQxmtoIdJEEfW9wMhbUUEffLPCYXWLv9iPMRT45K/LaVXPhQkrj1/Qggpzi3TiMo80WNAFScuyVx/6Gimixmr3L8vVgSTMQ22oF9XvBtqgmJwseDYYIou16WsYdUqtLD2X5Vff6kefCXKli8pgsWPrTUrPjiEeoOJl+wUvx8404QbjQGSG1vND8plvztBWzrjUtE7Zh+j7RV77YKEWTDtzou/+JgMwnmSJJieFaljcSeAcvX+KbcXQ23wv27tU7oYYt8cW1A9ew+S7S8YqwKadPpW7WuV4
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2026 05:50:38.8218
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fbd925df-5f31-4fbe-d687-08de8afb9bd1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026367.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7166
X-Rspamd-Queue-Id: 9C189160004
X-Stat-Signature: hx85oisjanub5wpew1iq717y7r8adky9
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774504243-271941
X-HE-Meta: U2FsdGVkX19dPpX1h3fNTuP5VAm6sRGVLjwrtxHIHtI7pccHf5nXc/MHH7ue1vnHwMcjQD8QzdUjlPKcTjtV7mvnkEOcLft7dtuDQPcl/8CCBu2B/apP0Z5e+smcfKzqQFCh+ZWIOyT8TW0xZCr1tb2xqNaKeUXCcM5dOiGvBAvlapRxPpdwdBf+bD3wla35KPWjnybiZvMPb9GqXR4r+2X4a8YoFPO4Tu4NcPVg6nJ8Yim4faE8JU0R98pRSzCo4HbZElpitm98VbyK1I7L4tOHcwheedEdWT8Gas6f7XqNWpLLanXTU9M4MBoWLcm/KDQb8s8/QvgwCyWmAID7jjlfKcKQTpHF6TlFfGqydfAzZiR82jchoS6p1mTJq93kDTonB3ydmrZkIskyaYtgVrUbd3O0REmf1XiX0/8inscF9WR78HBmRE0qbA7MY7z2fVnP6Au3ulCpdVYw0KcQcPv0tEftGVtVMmSkyvxK3snDkG2aTWtIYjWJ6tgwzWTmsigSR2+GgELRXEw0Jzjp/vMxACX7azMm4IwPPh1mnclihByug4XDDEqsl0m6A9MwqqBtsq8vShOwISj5t1SBdcnHC6X2t3booBmfMRx0gW+jLrekrtuTia/Bw3aXoqkHm/7+XyI19arGR5T/QhkYZ+DGswJRTLiTInxx47wm3/4y1eEVhBrmw+3TJZr3skij0ylMTovZ1kLBSWH9BwpG/WyCdCAZdcfjZQ2ORlPwhnvMygouUucUoXa/WSeB6/n9Eh39vymMY3+K0uW8XM3mybqAVZ+Wp0uI83LyhKIfoBwqj/yJEncRl0qpzHEXSI5K9grPyCMx8WothjTHiwaNfArWmjL5md2K3Bwonr8PLAKZe+SnHMP7Uvtklj8W0YMuoBLCufZyVlESshESTS7ac+CIEdh43RYRsKmLZrJ8Ys4wxOMX5CoCeV7st1gv1Ug3JpWUPMNKyeN2NZToAuf
 AFSYJgQS
 tZ97Tx3/QGbb+K0obW0bdbH/OqmoxONtObEJD5I9Kf/TEC/KNWky8e8KTjcEYwF9SV9bKpysrT/LJcMXqaK3vtaHo7cjhbvHkhyVC0Cn5knRDQn3J2PH22Z2qKGDnQS3154NDKUkXv4RcW3xwU4evfjY21n6ChO5qeeP9gTpbbY0lei/VXjjWbuUufP6w8uPcd7pUpuK8Qk1mSdpcOixWxOS2+KzDVr0ttOiHBc/Yn+2cDge/xufMONHBy30UBwuC9MzIIWTfoSYsnNdHz1UbMZWtdH0sACOYHL4dUad1XLVB7oTSiy+ARpISAjPu9HntJrTKowH4vKuV6+1rve+xt4uIMPTsBYsQDxfrFJ2OK68PbkS9keavcfhVQIA5GUeT7BvAga2ub+Ku+b2T2nZmsRC8AXucNAqZ9bMVyV+KV1cxKcQbcdb0PHiW3UoqtYWjx/3eOu+fmFVadCQl80n2mJviWkhMo6Uk7LMJe7VP5R/Qc75D0jvhbRP6Ss6CBqTaCkt6MLpeBPmYd+BMrYXc6MIGByNry/tmTNEf2PT9R8XChIYE5dysBofVThH8EDzGkFsoldNf4MPMtk0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replies to review from Shashiko
[https://sashiko.dev/#/patchset/20260323095104.238982-1-bharata%40amd.com]

>> diff --git a/mm/migrate.c b/mm/migrate.c
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>[ ... ]
>> @@ -2751,5 +2751,53 @@ int migrate_misplaced_folio(struct folio *folio, int node)
>[ ... ]
>> +	if (nr_remaining)
>> +		putback_movable_pages(folio_list);
>> +
>> +	if (nr_succeeded) {
>> +		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
>> +		mod_node_page_state(pgdat, PGPROMOTE_SUCCESS, nr_succeeded);
>
>Should this use mod_lruvec_state() instead of mod_node_page_state()?
>Using mod_node_page_state() updates the global NUMA node statistic but bypasses
>the memcg-specific lruvec statistic. This can cause the pgpromote_success
>metric in memory.stat to undercount for batched promotions.

That's correct. Earlier, memcg wasn't available in this routine but that
is no longer the case in v6. Hence I can get lruvec and should be able
to use mod_lruvec_state() itself for PGPROMOTE_SUCCESS accounting. This will
be part of next iteration.

>
>Are there missing topology and sysctl checks before incrementing
>PGPROMOTE_SUCCESS here?
>
>In the single-folio variant, this statistic is only incremented when:
> if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
>	    && !node_is_toptier(folio_nid(folio))
>	    && node_is_toptier(node))
>		mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS, nr_succeeded);
>Unconditionally recording the stat inside the migration helper could
>corrupt promotion statistics if the function is ever used for lateral NUMA
>migrations in the future.

This routine is called only for hot page promotion by pghot kmigrated thread
and has been documented as such. So unconditional call should be fine.

Regards,
Bharata.

