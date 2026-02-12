Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB3D0EB270C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 02:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C41766B0005; Wed, 11 Feb 2026 21:16:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEF5D6B0089; Wed, 11 Feb 2026 21:16:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD12F6B008A; Wed, 11 Feb 2026 21:16:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95FCC6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:16:51 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C08C5A422
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:16:51 +0000 (UTC)
X-FDA: 84434191422.04.FDC8150
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010065.outbound.protection.outlook.com [52.101.61.65])
	by imf19.hostedemail.com (Postfix) with ESMTP id 27E311A000A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:16:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=CiWBI4Ak;
	spf=pass (imf19.hostedemail.com: domain of bharata@amd.com designates 52.101.61.65 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770862608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SwpvG24d3uViPOCuFo4GhJLa2GcyiHeXA9ALD1+02Cg=;
	b=Utsjp03xAAjNfwAzYJIEo3C6oH83O9Nz1MSZwZX6nqLS/mx3tG3XxurH9m+eUzvm/S/wOK
	CRPsTJZBrWm//PkFG3z8h+cJxBwQea9NMlyYlelgq6iJwPBMjsU+B/nGKm0V+EbPbm0EGE
	tzH6BdTBgzkiBVzETYrAgZiWhGFDvNo=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=CiWBI4Ak;
	spf=pass (imf19.hostedemail.com: domain of bharata@amd.com designates 52.101.61.65 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770862608; a=rsa-sha256;
	cv=pass;
	b=5L52UvksgWPbn28nh0PQvTzaahuVxVAfRoa2YUOLWuCAdFrE6JUswWnRDxclZQL+7II3SP
	FoXnCbaBqu+nNn53MiTP9Lenmcn4UGUDCNhgVp0AcDtj/eQ5PBvmXhOdSBgxPAit0I/sJf
	0VK4dLqNYm0THd8Q3s6JZubdv08OgE0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p/URLj9V9hMT6gnFsfdekOTVmceS2/WttJJKEBH7DpWsFXBxb1Er8NXFxuvNE5LIXmLKyTr7ZOZ1hppYYqP3nUcqkf1CO+b/4UjYfnc86aLIoapMz4LWYJJ1PZB5Uu5AuayszRc+L+tq4oTRfwciBbEfaIZlwQAuQthwvLj+uuMsAC2zHjUxY87O9YFxJI/5+gCCB9SFAqM7yO/JXHWrr/jbaEnxDvvQ5hz7649b5tfBSXScnEohVBbxDL1tbwwWlVI+xgCxYKmc6raUAjxFMXjM7iwm+T1OeCnr5CRNHaaGNn+bRp4MNw/HwFT3aPG2uQ7BdZMyHP3AqzeF+3Q3Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SwpvG24d3uViPOCuFo4GhJLa2GcyiHeXA9ALD1+02Cg=;
 b=mA+NNdv7SzE4fOEX2FPuoadVAwPmMXFjSE+VljavqjEXIpZoexl4IlO75tkPjdxJKJISksz4RUDCTIrJJhIyGKjaxAPrnvCYkNoI0PltHCviAK0eA5D55esxyNtSW43Z+6vmupgHAFNovtJWVYU9s3WqZgqYr5vj+r/rm34XbNIqxLzHHtqXhoJEmtl+qL7W9K1U6vQ9rsr7CQ+KmGDnAh5p5Q9HIhxJOJ6PJlHoUmnaSyP4ntj/hF1Tng9o54GlUjVtEXwPQJ6ldgabigTIQ8noQron2ucwG/8ymUia5UJLHzRcddJCpiklptI6yLjqrp5nhSceltUYN9PeUgB3uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gourry.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SwpvG24d3uViPOCuFo4GhJLa2GcyiHeXA9ALD1+02Cg=;
 b=CiWBI4AkuOVLPjb0Ne7jBIRPVeR/V7K8KSpDLgYrGuVgKKGdJfv0wW6nwPi3fIPwxLS0Wme0AUPtFeQjAD4amSudTTq3flQrbvo0WoGa9LlFD2KyVWNLpIBmzG4zDVnyryIA4vU9PjCVgjF+JI0BpQHol+9vJP0P0iU7yeAyVKw=
Received: from BYAPR21CA0024.namprd21.prod.outlook.com (2603:10b6:a03:114::34)
 by MN6PR12MB8514.namprd12.prod.outlook.com (2603:10b6:208:474::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Thu, 12 Feb
 2026 02:16:43 +0000
Received: from SJ5PEPF00000207.namprd05.prod.outlook.com
 (2603:10b6:a03:114:cafe::b9) by BYAPR21CA0024.outlook.office365.com
 (2603:10b6:a03:114::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.6 via Frontend Transport; Thu,
 12 Feb 2026 02:16:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF00000207.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Thu, 12 Feb 2026 02:16:43 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 11 Feb
 2026 20:16:42 -0600
Received: from [10.252.192.21] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 11 Feb 2026 20:16:35 -0600
Message-ID: <0b03e16d-ca4a-4a70-b530-14bbe42bb7ad@amd.com>
Date: Thu, 12 Feb 2026 07:46:34 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 00/10] mm: Hot page tracking and promotion
 infrastructure
To: Gregory Price <gourry@gourry.net>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<balbirs@nvidia.com>, <alok.rathore@samsung.com>, <shivankg@amd.com>
References: <20260129144043.231636-1-bharata@amd.com>
 <911f316b-87cf-45eb-8d9e-412473d7176a@amd.com>
 <aYyomjsBpZ2KFxKG@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <aYyomjsBpZ2KFxKG@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000207:EE_|MN6PR12MB8514:EE_
X-MS-Office365-Filtering-Correlation-Id: 104ca46b-98ac-4989-a22b-08de69dcc3c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MnVsZGRTejVEM212L2dvcGdjMVJwaVZZOVAzcmxFZ3hYNzJqQklNdXAzdkRq?=
 =?utf-8?B?ZXhqZzNKRThWb3pUN0FMU3VXQ3NMVTN4UEhjUHVVWGI0UHVTNzg3NVAzYWV2?=
 =?utf-8?B?eUU2Mnd0Q3crTTRBV1NpTXF5TlVrR0R1bXVaOU5MUHZTMFlMWk9jZHRjc215?=
 =?utf-8?B?aFlaWEJJN1lVZ1JpN2VBbXRmWndPcWRONWhMNjZnamVlRHI2cSt6Sk9UOW9p?=
 =?utf-8?B?NUk1RGpHblhrcmtEUzkxcE9pcm1NcnJnYmg3ZmJLWTdPMjNwWGtTb3ozZUg2?=
 =?utf-8?B?UjZmNFQ3U3UvTE9sUkxleEJBT3o2Z2lreUNvSXVIOFFQYU5INWN2NENSbkhn?=
 =?utf-8?B?bGxrSFJEYUhuT29GTzVIb1JNUVBVOU9qUDJieGxXWEZ5blJGYVpGeVZFMXhi?=
 =?utf-8?B?eVhRSGZwd1JYdkd1VVIwc0lVR2pKcWtPT3RoOXhqUGo4NXhnQkVCcHJLT1Nw?=
 =?utf-8?B?M0ZLSUVqNjB1Y0IxS3RVcTlWc0tIV3hZaUljcFRkdldNVzRSNUZDdE9RM0FR?=
 =?utf-8?B?MkZ6TXVLaHVJRHI2ZkZBSHFEUEJtYXFOaVhGeHVOcERKRmxSTWMzQUtEU1Aw?=
 =?utf-8?B?ZlQzZ251dmlMYTFEb0txSGFWZEZzYVVhYi9FdzZBWTBkaDkycldFL2lzZm0z?=
 =?utf-8?B?aDN4SFZqS3phaEkzb2szODVwTzZyNldhY1Z2YWJPbmdCMERjOU5kblQ3am5a?=
 =?utf-8?B?blJJSytwZktjUDlRcHZwOGh4ZTZKTFlCU3RBS3ZRNE1nUHU2UWJGZ25lMi9R?=
 =?utf-8?B?bmxKSzBnVWRGNEl1T25renRZL1JySlFoR1JlaGs3dnFKQngwZXp1ODByZjNi?=
 =?utf-8?B?eUpya3krSTZJL2NNY2FvUTAzL2Jrcm8wSnMvK0lrMkphaGliRGtYdmpsOVlj?=
 =?utf-8?B?Zk1wOHg1ZTkzYktrYkhydk9kajBSd1hTeE4wVUYxdzBpWWhlVElCejNYdGxQ?=
 =?utf-8?B?S1BRQm10bzFUTUFLcnZIeVBJa1JMcjNXUU43VVRlTWg2MHNZRXNYdFZRMjg0?=
 =?utf-8?B?Z1FFVUVSZlZsNDhxOWhBbUhQY3hvK0xjam9mMzkwcDZqNWFkQTYwNUpNeUI4?=
 =?utf-8?B?aTVBQ0dRWk9VZHVqMWY1N1FNNlFQK1RwQm4vWjhmQklKYnhOK2h6RG1aakox?=
 =?utf-8?B?aDdlMS9DTmdJTWw0UWIza2J1S2oycWhEMGNXRkJUMG5TM05PaEdwNlZVVThn?=
 =?utf-8?B?WnpqN2s0U0JyaGRMTTZTdURudEplY0EwZFdCb3JTQ0N5OWVWVjEraUl6MUM4?=
 =?utf-8?B?MXZwaU1jNWNnM3RZUTVwWVFTeDlEYzZ6eEdvbFdjYnNoOW52eWVxaXpyOHhS?=
 =?utf-8?B?MXREcEg0ZlBCbVdpRmhRRDE2QVVHUVhUTVIvMlpFWnY1RWgycE9CZVZtVzJ2?=
 =?utf-8?B?dVNoMnFxY0lFcFdGRE0ramZRcHRsMlZOc1BYZDkyZEorYUI4am5OVXk2d2lD?=
 =?utf-8?B?QWVZL1VSa1B6cXQxT0hwNkFRVEM2U3NOTk5sMkczMy83V3NrYi9acGNBYUlh?=
 =?utf-8?B?K1o5a3IyNk1OdlY1dzNWSnk0UWJLUjRGUzhZQXpFaEZxMGNEWFpLWDNLc0tp?=
 =?utf-8?B?U2VjV2VLTU5hZTl5eGdsUjN6UXBRcXRVbm5tVUwzczQrWGhKUWpKcGM1UXRM?=
 =?utf-8?B?T3o2ZjNPRjRpY3RhMHpHNGNlQ1ZGcjVoTXF6K3ZRV0xoRUY1dXNxWVl1RzRa?=
 =?utf-8?B?QW1OYTRiM3N6V2RmeDQ4b1NuVXAyWU95MWJ4MjhWTnN3TnQvNzhVNWZEZE43?=
 =?utf-8?B?RmRkYy9BWkpmVnNwZ0Z0Vi9mM0xlNThCS2pFekxIdFN3ZWhsYXJFeGdObUJq?=
 =?utf-8?B?LzRLdDFpUG96Q2JpK2RiTGdXaFE5eEVadDUwaE82VFYyckZJUTQyY080TDFo?=
 =?utf-8?B?RTl1YjlOUTdORzBxSXVSTnFHaUhjOE41SWhPaVlRZzRqMy9hbThzdXlCRVVj?=
 =?utf-8?B?bGk0Z29qZ1BvSFgwYTBjWjJHcFg4TnZrK29UN2pFckhuRmI1Y0VNUGVrdGlQ?=
 =?utf-8?B?dmRiM2hCc0lHTDVLcDk3VDczZUphQ1ZSTU9oYU41RWwyMG1LaG1QWFhNV3o5?=
 =?utf-8?B?Y3lGeGVIbkFRSDJxOTcrQ1o0MTg3YkE4RVBUU2dKRXVtUEpPNDBNYUVTZzBO?=
 =?utf-8?B?SG8vd01WOTJuQkpSZDVCSkFRcDZRKzdqNlN2ZDR1UlJhcnJRNXJ0NTJ4c0h6?=
 =?utf-8?B?Y1lET1pSWFFybGd1RnhXeUJmdXhaSEVDeVpUTmNmV3pTcDl4VjNmYjZsVVhn?=
 =?utf-8?B?NWdQd1d0K1NLOUIzc2ZvYTk0Z1B3PT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(82310400026)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RpDQYTAwqdrFguieZVuG34cn4GZr1t36WLpIIWx6KB0/RD5E1rrK9sgOtx+glU6adaGrXZYW5JYRH8vOWMrKA3Eye4OIQqRmSgr4eCmEO7rf5VWvrYGBNUjAWote3FZEwRvUyOwBoAkhslAwJsuZswU7wpYipGE1HxiO1ou5MveIikYULXVBNAYCSjxtkER4HDvrSI8w1Qo4Tad1azM6zi3k9YyIRafNfw/UtaiwxC5BcyoIDpRowxPB9hdEXahnOOMcFZ3j77qrJC4a9fAizm0k1HkFia9d02OBEGPtcUkG8614/FNhHROmYISTlp15QTmx2xw+tDiiYua+1j+L+PzXeWpZ+GE8BHYTe6NP5d1VjCs2e7F+GO2DULygVIMsBzbbAuq60i2YqShMyRYnAsR72ZjIOM7+hc8SpSoZ/4cw9Q3ytwDbTveo26kiQbVv
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 02:16:43.0433
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 104ca46b-98ac-4989-a22b-08de69dcc3c9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000207.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8514
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 27E311A000A
X-Stat-Signature: jdh6ndhw6dot1qotdm5x7m15g3osn4qh
X-Rspam-User: 
X-HE-Tag: 1770862607-909253
X-HE-Meta: U2FsdGVkX18tt4y0xzToHPAtOZEbkpi83tYDtSCtFlAlW+1TeyTRNpTYKwGn8me7jQF6k/USvxhm/R6aIRSe8l9NW5KZdgIK8gNBEdVxhdfi0vHTyBmMywEtodDwKHMB5AFWLug1HV/mOxaDQ+LCVoNQAOvYveRV77Na5dL1HHz83PFJVk2jLaQJMNQ1HTCdYjx6m/ZrZ50+hItoJpNs0yVTHLx4jBzRXYa5VWe8/UnHVqh3PBTuLS3yK+zMRXaUgAL5VBjBGvuQyZHy/MJe8zs11+8HwSga8Is4WMD4mol8Y3iwhTNKWDnOxmf8gHEr4g3L7iMYJ9ZcaTerSHaiuuRkilmsyFU4clCILjUBZLHMFioAMpNp7NAgt7rrZqh1Jo8JOQplfOKQJyYgsyFFDepUCNrFAk35jPpM9pmaAZm1lHpFstjIFfDTgwV3pDdIE+Ik99Ss2LEHk/QenhaPTi1PehWSGkPyIt3xqjdspjNKlr2GOVFmB30ubAM7Fj5Q6caZghPN2Ev8wb2qShx3USFmaXpX9kQwQ04eyez3gw53LoULEOqf4fsKL/guAEyGtaeMBlUStOtcGRlEhVmuM8G8VqBjubOgAAZPuexBxC7TSw18jqzwjNmTCj8bwUQyHpx5Ylyjmw1zDINiVf/CJy+lnOXTNkbclhVVZscpyV0RqVUV3ONmb3InOSTEpmVV2X55bG95eaLZ2vtoySOpf7wfYelznNLOBDAJ1x2UEXrilMoOJa8cIQqZ/bMIh3t41IE26KKROQ76XWeL1QyLp9TbxhT69wM4n4rnZQEXIOt8vJyqBvKn+wnL2KKhfF85QOzbaFvo7NLjGdRhk78vfY4U5bFEbPo+cR+oJXKrQteC5yTb61kEL4Sbs6BAPfDIbI5q4w/R6vPiBF+7sizfyPi2ucMdHzfWSw25yYQsoXzEDuQGEu8RzVduqkdhYVG/ZXTs8mUkPDRwNHbT9RU
 7w6S2/XB
 s+yuCgvoE3aIscZXy4182gknLpoodjAjLwoiSVdzFt5BkEwAhEPc89/K+1NWkKgMBDpRa2DI9pO4lJN+aVUVUQkEeFcgg36qOqGTRml+BF2bliBBP1m0NBdAcxrTbATKa29dRfLVhuOo0jHkdUc9g7B5L/xMasJIJgHvQagEA+kOwbh5wvFx4k8hAPnFzQHb2fWE6B7oh4iK3eQLsTaqc7s1Il8LUTwFjDGoFvfWCx3R7//gmQHV6ePnAeF9jvdLxMr41XKUQtM/8Y4xcmuvi2JeY/bDc+mVGGA9srnB9mLI77Ndev6HpcSxIE+yhainUKVFG47XC4OeQlGgqK/ckc4U3JH/eiCQApLZa/TM5o+DUfoASUQZBD0C8ewMyrik9MpCh+5XFqpjlAy/bnLre260Po57cLCS9RYBml4CHSIzHoxaSK2OkiDDQZ+EBSoEdMzOD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11-Feb-26 9:34 PM, Gregory Price wrote:
> On Wed, Feb 11, 2026 at 09:00:26PM +0530, Bharata B Rao wrote:
>> =====================================================================================
>>                         Base            Base            pghot-default
>> pghot-precise
>>                         NUMAB0          NUMAB2          NUMAB2          NUMAB2
>> =====================================================================================
>> harmonic_mean_TEPS      5.10676e+08     7.56804e+08     5.92473e+08     7.47091e+08
>> mean_time               8.41027         5.67508         7.24915         5.74886
>> median_TEPS             5.11535e+08     7.24252e+08     5.63155e+08     7.71638e+08
>> max_TEPS                5.1785e+08      1.06051e+09     7.88018e+08     1.0504e+09
>>
>> pgpromote_success       0               13557718        13737730        13734469
>> numa_pte_updates        0               26491591        26848847        26726856
>> numa_hint_faults        0               13558077        13882743        13798024
>> =====================================================================================
>>
> 
> Can you contextualize TEPS?  Higher better? Higher worse? etc.

In the Graph500 benchmark, higher TEPS (Traversed Edges Per Second) values are
better.

Regards,
Bharata.

