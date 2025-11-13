Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF13CD5BB8
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 10:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D88298E0007; Thu, 13 Nov 2025 05:32:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D384E8E0003; Thu, 13 Nov 2025 05:32:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD8F38E0007; Thu, 13 Nov 2025 05:32:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A59A88E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:32:13 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 44E42160945
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 10:32:13 +0000 (UTC)
X-FDA: 84105218946.30.852CFC1
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012044.outbound.protection.outlook.com [52.101.48.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 52417140003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 10:32:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iO21QRjT;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.44 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763029930; a=rsa-sha256;
	cv=pass;
	b=25KGg3rCyCQxjN+7CqIROFqtdigvxKk+KYuzt1fdAAhhsrKaacWXwKlS8PBB9Lu6xM7M/Y
	12XhpwOss/MUhw2BEkusv3mjfbu0eNqKrntNwmh8JEhGeVhLCqgu6F6+E2GLpaVsHq964O
	prS4XcXR9spcL1H0q4np4l+NanVnwQU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iO21QRjT;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.44 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763029930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BLJVm1mIaO+NnTTIgm8yKQDsGlYxaZqbm0N3RfvFhDY=;
	b=ejYvSMlnqmqehxkeixZMZHJTpNNi5sJv1XLfd8F4Cbn2I/1sJTl2t3DuB6RjibmnXx86yF
	LmQ0YRS/FgUpHoSGSoa2MQB7HXCPz/QJHpdoZ0xfqoc8CQXIi+fsdqhSwYc6YoqPoTOlKq
	a8iwbHUl0SGNB/vz6UEtrtlzhAqfowc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d/z8/bRxRNurnlG35+QzCqUdckVeqqF6gUzMXSGVGmiw/8Jf0AsRq/iW0BziZxHOX1OZ4bOJZaZO+/iGOHm/iyOOpjicEFqX9RJCiJy+eO5966wybzQOvWmooeF2op6xtWz65zS/jrbOiwINIp5FQT0UlJQRX6Y++DaYZbzdwV0kJ0P6qzQnjnRzZcnughthrz6S4F0I5nmFx8kWLxTOTp065LwczycpJmo0r2upJb0Z0C+Sb14/LbxSEOGbU0E9EOllRxcR7B/BOPfKqd10zXq3OigDK8+KlaBzV/c83i1DminxKPkvAQekBOCizDPCv5SeupddvB3uu7DQkhm38Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BLJVm1mIaO+NnTTIgm8yKQDsGlYxaZqbm0N3RfvFhDY=;
 b=gbyLAQnfaZG1Y/t5CK0TW5V7GdjJ9DXxNuxzj2325uxayf5bihK1bvgb4/EhVuf3uE3Cp53bPwLDLeUk7Gz5Rt6WvgVaMjeOa7sdt8zPPyl7rL3R1QKc+oNSTStmlwUOYGCjO7dgxQFis8vuyUx+6a97U9bDjFZ3qZ0a6YeZusMeuzaNihopYQZnaOqmK6wkvv1S/Zl1vP9N/lNAG7OUDUjXZ6hW4eILOmHf+3i90rtlPD8mGYeNfg2Kt16fxSKNC3F8a/Pxyqz66mcz449fOFS615YnX3zYXxEFNCHmNYwnvgPmaY0+WFsPGIktSdkkkV5jZFxE5zDqFRUz8XHuoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLJVm1mIaO+NnTTIgm8yKQDsGlYxaZqbm0N3RfvFhDY=;
 b=iO21QRjT4BTxCJnxspmtduutkjMuKwz5j/Zb0VK/jVcjfA33Rz/qepptIbHGwV3fKn8zA8AAj4Df/OJFRJP3F0PTAV1/OJF4aeOtBl8wMMdFMrYPSyNzFiUarVpLnRUYS68PEma9R4CJQLvxVMQQnhDfNKYZlhXl6KJACz0l9XU/wA5JWCXsy2SbdbaDxDjDPd7P8fqshMDLRBcmFVCWrCvhDCVVJvYmi6kMoQ6+AoyqrBZVh33+c1qyoJtd9mvukABCsDO97/N5mgLKZH4dqeRBVlPpY66CJB9ey9/zoaUMgRs6GuQgk3MgmH3yuFNWVvXtY4BJ028DguWqhNCxag==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SA1PR12MB5657.namprd12.prod.outlook.com (2603:10b6:806:234::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 10:32:04 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 10:32:04 +0000
Message-ID: <7d5ff6bf-9e44-41da-a9b9-c5424c569e98@nvidia.com>
Date: Thu, 13 Nov 2025 21:31:56 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fix gpu/drm/nouveau: fix return type in
 nouveau_dmem_migrate_to_ram()
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org
Cc: kernel test robot <lkp@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251113051322.1753532-1-balbirs@nvidia.com>
 <5bdd8b10-171e-4171-a1f2-43c029dfd8e4@kernel.org>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <5bdd8b10-171e-4171-a1f2-43c029dfd8e4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::18) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SA1PR12MB5657:EE_
X-MS-Office365-Filtering-Correlation-Id: 02dd82f6-6655-401d-d20c-08de229fe358
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ckFDRk5ZOXZTQURoYm5vK1BSTWc4MzJTK09UUHFMM1ZOcGhidGJPcE9PK3A1?=
 =?utf-8?B?QkEzNXhMbHQwVkE2TkcwSlg3V0R3N0d4NnhOemtBWkRUaXJqN3hadzQ2clkv?=
 =?utf-8?B?MXNDRWR6dDZrRUZrSDA2WnJ5d3R6K0RFOGU0Nkc5WnJ5dGR0UmxaZU1XLzd0?=
 =?utf-8?B?YWZvRC9IVjQySzY1Z2xJWGhUUDFva3hoU2RSYzdlWEhKeFI5TEE5KzNPOE9J?=
 =?utf-8?B?amdoTUVrcHhpT201M1BFbVFGdDlnNVQxWWV5QU9IOXhXaTh4bGU2VktXdHI4?=
 =?utf-8?B?eHozTEk1RVJ2R1RhZkZwdG02UmJUZ0hLcFlOdFRheXdQSmlBWnNKUU1zeW95?=
 =?utf-8?B?TExLcFFNcEszNDF3UnMrUWtFVVFJZUhtalhWMTZSRldiVU56cm5pQTMyQlZM?=
 =?utf-8?B?Z3M1U2s1OTBPdC9uaDNkcXlHUjJoR3JVM2tPdDlJTG5URmQ2MzgyaitxMW82?=
 =?utf-8?B?MEhzWXY4U1RDL3ZMbWFQbDM2azRuUjRPQjdURWNyemFRckZyeUppVjVSWnRP?=
 =?utf-8?B?MS9Xc2VTdVJxQWxOZDI4UHl1YWE2WjlDQnBSWkQwM0NtdUZaU3J2Y0sxNHBa?=
 =?utf-8?B?VWJWU2xlcmgvdzRQeGpCTnFTSDBiYXAwTHJ5cmJUSElWRUVxNm40bkFLYUs5?=
 =?utf-8?B?dGJmRVY1Z1dDN2Z6aFVoZmdoR21YdFFWREVjZFlvWnZZNTNZdjRHcmpJc3ZV?=
 =?utf-8?B?UmZ1SThyK1g2eXphQnU2RGc2aTIyZEtld1FmaFM3SWVzR2lTV284N0xZeWhs?=
 =?utf-8?B?NmFQelJ0OWg2TkxJL2syRHdnZGgyWFhaWitpZm1raG9abkdUbHlnbVl1YStx?=
 =?utf-8?B?M29sYkE4Sk9KRFZhTkRTWFJKbW42V3paVjd3SVVJaVBTTmhDUVpucFJxTlNv?=
 =?utf-8?B?TlNyc3l2enpxeUZtUkUrNXdHcUh4K0Nrd3dSeDVTdmI4Yk41YTd4V3VObG9m?=
 =?utf-8?B?d3c0ZFYrSTQ5TUpJU3ppRFhlREtxdVJNTTBGeVFkRDBjbVIwRUpKeEZpOEVS?=
 =?utf-8?B?OW0zU1BPU0pkaDRSWXhQU1lXR0xIdE1lQ3dOWmd6M1NleHprQlhydTcxUHoy?=
 =?utf-8?B?VEZCcDZjU3QvOW9kN3RvV2ZPYlhxSE9laU5DaFAxNHA5YnRBWXM4VjBrRjJm?=
 =?utf-8?B?RDVpOXpvblVIK0FCV2ljb3ZPakZ4eWd2bUpBNUFqaVhMRWJUSjJZMEFPRm9u?=
 =?utf-8?B?bHVpT0UwLy9TT040QXJRV0dmZ3RXZXlkV1NTVUJQOXBIYll4TXhMZGpVTWdv?=
 =?utf-8?B?TUZva2tkTkZ1Nm1qa1dNMzVQcytpVHFiNTRPMzhLQ3VUc1ZXbHRiZ0U5cW85?=
 =?utf-8?B?MG1WdjF2dm5xOVV2QUM4K3hVN0lLSnIzZC84Y21sY1drbzdZZEtvUm8wRUZX?=
 =?utf-8?B?eUFhL0VGVGZPTUk0NC9HV0xmQ0tFYmJVMTd0NHZ4MzJGL1AxUlhSc095WjBQ?=
 =?utf-8?B?amRpa2ZUbFoyRGZDemZOR0hzckxxeHhuRU9iKzVhUXNpYXVEQTBXbFRCdlAv?=
 =?utf-8?B?bFNnaXBnbFBlT1NaZkN4M1FsLzJLZzQzTkpzaGxpVXZ6UEJWL1FTSVJLd2Q1?=
 =?utf-8?B?MkRoc3k2TFhhNnJOcWU2c0RVK0J4OTMyRmNuK0Yyc3F5KytDeWFhamxQK0lJ?=
 =?utf-8?B?dGZQcG9ydkE0QWlrYWVPaWtZZW9WNlpNbGczbHpjQnVzT0E2VEttd3k2N1RO?=
 =?utf-8?B?eUM4S3lPM1JrTE4vWEl6UnRKbnYwa0s3YjFlOHdPTlc3VitwcXg1cGgrSWFK?=
 =?utf-8?B?eDNOOGpnckhOT2lGYlFINFZpaHVDU0xpcnk2NVJheFhTZHpyUEtBMkUweEJT?=
 =?utf-8?B?eS9GK3NueUFnb3dOcDNtaHJVelM1NnZMUXUzQUdrZDlqZnF1Y2FVWi93MXNs?=
 =?utf-8?B?d0FDYnNLa1B0anBHMG9WOWZ6ODVSVjZ0Q1RlQ3hheUd0R3d3S1hiZ3paMHlm?=
 =?utf-8?Q?v0m2bsiY3mw0HsgbQp/QaBFRXq4aEAss?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WmF2NVNaR2tvZHJEdmJFZkFQWVJTZmlQTjJhYVRHb1ZXbVpEVndsbDBQeDZ1?=
 =?utf-8?B?SUFGUXRCbjJRWlNnRE5GRW1ob3ZPQndoYWNMays1aWNIYzhNWEovNm0wQmdk?=
 =?utf-8?B?VkRhbEJ1bXBvaWhzaUdNUGU3ckcwWlJrMWEzZDNNMUNpd2Q2bXI4R29DY0Y3?=
 =?utf-8?B?S2NEZ04xZWkyUzJIVnJHSDJBL2x4Sk1sb0VZRUYwUEFuR2RnQ090eEZnWStY?=
 =?utf-8?B?YUJxN3Z4OWhQanU3NWtQVjZDRDdzUWlKcytpVkErVko0QWJHaXVLOHBKNFZk?=
 =?utf-8?B?M2JYOHpvRFFNM2dkSHZUU0Q4Zkp5VjBSSG5OYnl3Ly9udFBrWkhpUG1MY3VU?=
 =?utf-8?B?alNQbHJSWmJsbDdseUJBSHVhYTljekUzQ3BwL2tjb3YzeFVzMXhxUmV2VWJJ?=
 =?utf-8?B?MmZlM2FyR3JDRU9zMlByMDZETEpXbmRRTjl6L2c4cEVLWXJWcDBhNXhacjdW?=
 =?utf-8?B?eHRnaktzZ1hhR3dTeFFYNGFDY2NrenRXcXRRdXZDcUZYenFLMlRBamV4b05t?=
 =?utf-8?B?UjFxNm1vallaVHdaZzBEYW5lWUJUWHNaMno5aXFWRzkrMzA4ODh0WGM3OGhI?=
 =?utf-8?B?WVhMRHA0c0wzSDUwSFJTOHlxbFBvNTkxOTg0UnZQWlNxblgrN3djZnFLVzV4?=
 =?utf-8?B?ZitXcUlrZ1FQMG9SaDFkWEpuVmw1alJVS3RiRURVZnowUDRnSEh0c3p1OEl5?=
 =?utf-8?B?TnViWW9jcC9OUG5WbXhuR2FvNElTRTRXUXRLZUREK1FxODFnbGhyQ0VZOENm?=
 =?utf-8?B?U0pSY3hzUTVCb3oxQk1ocHBENWh1dVNtODNYNXZqRmdlS1E5Z2JGdXA5ZzRM?=
 =?utf-8?B?TXNuNGxYSldQWklBVk5IV0pLQzRBeDJqMS9QYkhNRTRQOTVIUHZwclNtdU9t?=
 =?utf-8?B?dkhQRnUvUWd4cnZmb2FBZDRvNVR0Qnp0QURSTUhDUDZWMlZlRVRyMUpTK05w?=
 =?utf-8?B?UytQQkxncGFoTGdYaGdEbU1UUHJUZTFZR1hBTi8wcVlxTTBWNTA5Nk9nWkFJ?=
 =?utf-8?B?aVNYTDM4M25XaXpHbWViTFNzZFg5eDF2NXJXRFhVNXlQdGg1SHFPTFErUGNa?=
 =?utf-8?B?UVp6U1p2RlpkS294M210d3ZVTXRudWc4Z3o5MnllM1JoRGQ5MjlNNnV2cFNE?=
 =?utf-8?B?eWlMK0FXWjJWQml2WTlZd3llZlBJQndIdG1KRTlaZkkyVEhzMHhyRXhlekVI?=
 =?utf-8?B?cEV6dVJtbjQyS2xLS1ZGMDZ3OThZalJibDZlcDNzZEd1VVI5a1lySGRFem1p?=
 =?utf-8?B?bDI2MWFhY1hMeXZ3RVFEQlV4amNSRGNRZ1E5dGZZa3JaTGZwMkk5SGJrZll6?=
 =?utf-8?B?WDMyZGJUQ0VBZGZDQzZLTmRteFNhOWdtN28zT3VGelE4RE4rMCtiVVdpWTJY?=
 =?utf-8?B?SC9DTldRMjRSU0M1T080SFFoMGNHOXIzeXVhekQxNHhWQ0w0ei8wTFoxbkFE?=
 =?utf-8?B?L0RDSXBlSjFMVTM2dmJUcFgra2tzWW54dGpkTkxrazlTaWVhbXFJU054dkIz?=
 =?utf-8?B?TFVJTnZxRmpXa1hwWEtHYlRJMGNIWTNQMmpBTWUxU0N4cGVoOS9YbCtnNDdW?=
 =?utf-8?B?QXE4cmF1RG12Smx1WTg5VVQ0TGhHbnRLSFRYZE1ETWhqbnJmSWphMnhoV2ZD?=
 =?utf-8?B?RVRQTkk5NHBHQk9ob2ZHNUNkSkU4ZUNnb1h0VFkzdElMS0FaU05rYnhUb3k2?=
 =?utf-8?B?SkEwZWJUOG9lZ1VpRldJRlpCWk41TThEUDBrSjA0aUJMS1Vud3BKalFGdEs3?=
 =?utf-8?B?bjRhcHVLZ3Y5UG9HeFdTY3pVTFgyZ0hsaVp4YXVaOEZBYkJxRXZjcGh3OGUz?=
 =?utf-8?B?SHI5MTFlb0NqcEtDV0xNZXE3a2drVUVqMlJjR2ZIMkJrRlVpWDZLb2lXN0RY?=
 =?utf-8?B?YW1ZRzRmWll5UFNia2JhUVJVWGpoVjFXSkx4dWZ1Z1dycGJUTm5qMy9LUktO?=
 =?utf-8?B?YjZ6ZzJjUW5UMGZFdmdkOXRqbEVJVXFzbG4vNWU4Q3ZQMFc3ZTl5d2RKMzg2?=
 =?utf-8?B?NlNXZXRGK0RiZmJXNGVqMW9UbGJsOFFiWVR5Qy9pb2ZHVkw1U0lna1d3cmdz?=
 =?utf-8?B?R2tPOVpDZjFVREtkSS9QMWFzamhabCtuaTdPSlk5Uk01YXlYRVhmUWJVRmFt?=
 =?utf-8?B?V1RleUhnWHdZUExmNkY3QUJsMk94MkoybHpnNGI5ZFhIU0o2TEw5c0J6NmV4?=
 =?utf-8?Q?YjR3OP18rf4tmJP+fTyYcSO/3KDsDWwd+K8ck6+2k+Ac?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02dd82f6-6655-401d-d20c-08de229fe358
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 10:32:04.4209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jAY16zqG0FNt7c/QZGMy79ofjwVtP0FO/LRIFFzY1W2aL3UT29GpTNZI4hvRvjeh2/2fOydJDfMLKUADph0KMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5657
X-Rspamd-Queue-Id: 52417140003
X-Rspamd-Server: rspam07
X-Stat-Signature: i34cgyf65yttizpnjz4qe4kod6y3ezfs
X-Rspam-User: 
X-HE-Tag: 1763029930-259245
X-HE-Meta: U2FsdGVkX1/IjGvyZe19lcJKP2lhxYqeRHSYufBUSFF7ShlMc3WIl0d82zRObzhKi2wxj+hpd6XNiMlHZJ7tZRH1P7XDmJKnhEA8ttUFHT8XCjUIUkaVjPq2f0xQlRJIOQ5ftY1EQuXlmNLPpUT+nTwSNR+jOPV9O1tHMQ0qCwtIx5O5KwMvJafI4SorFescSC6aqdFa7KO0uXjZJH7/RkiH08XNZq9gvRoT0GWbAiR/5wpbZ75s6u+iFPpqllvOJbuEq8pOTdVL4YICrhGA1tighUCGrnNTIQZhTzmmn8lTSrRndZ7AgzfYukLJZh93oseWoqBB1mxwan/Iwfox8LK8qQKi8Jys/TOHttlfOBqK92RuA4YGb+w8+3u5EPNeHFMSfi6YADX36guneAhwBHaMhiN/hULyvLZIDZHI/LNvij9x6lrHO2nfAfDq+MZH31JjE/qI6n4qjfFElAbEAt1LAovnMDE9L+P3xXRmuR8lisvFuDF+LqDfICs1v0kS5H4E0Iv/H5DOBb4NEJvIBRu401MTD8ej94bHFu03Hbp7bsyeclywteZJzk+GrEOv86QrTkjlHNP4/AAHhP110MHnL6XXgZy3/bzP54Dk3l/a8qvIW5WiWdXjdve9HOfOzNod2yj2TUOEjnu7AVCGgCypNri3jUmml/3u8ayeRs++pLevOcjuZOqhZXhQytBCxWJIRpAQ6+98aDdrjv+dhOLNvxbS7MEXMFzO+r87AUrkkCYjNBtbE47GvYOE1dH89v8rIvk7K90j2Vgz6byoJyX2yJa74Z+Y6wtp/i2yvgiPqaqnmDbPbQloGcEvQAwQrKfFahv/Ym/4b/7c0Pp/tD0FTHKeCnNUp1B+HSxDUGgz6DQsubFicu81KX0mCVRGsFV0kfVXhrNDGaCeMxaf/FwE+KAgES7VLlPnaZrd84LtlCAuoMv2n5vVDTeR4UQskXvQ/tRhyBryVDErZyY
 CbJOI7ob
 Zz86DOFB2UIFGzbLoN0RJz41FWVengKE0A4/0nxXoYirVzCsJPjEMkYWZTtbsTjbGn6tW0OKOzOfcdiEG68+O8ZMeOTjhAPiZyIZwDuJoefwSigplL0KqkffE8KZxyba74/4AXEzJt2TfI9COg3OmO45/cxmoIXky6cUq0i7T41jb8K30byQ/xMcRA5Q2tZ6+7RdmUUsR9HfihsEYnC7ZfZaSApfvL6ct35ELnz/k61/LiZy1EmWWMlsU/34hFBHD7adIIjipdXN4BPg1yzY3sL4E7yGgbbCLa8aWY3B69HJWKabJ/f2j60JMFgRVGXkdGp3Xuib3pzcM0gQUH0SckWV5H3VVwpPMdH4Wgw64tRinzw+x6ab9ReEIvhT99WMsNmziJNJUmSc9JRBkXZ0EX9To+sHPfVxHpHoN5bqtcWYLFSdkD+RD0y+CYlTAc4AejHKriKZcjnSmJhJOHRJHZW/SoPEdNdek2XQR+4+FUA59jYAFaSorIXp3GgvbAMlj9xLli1h3Q4UwT+bFT+uKu1ZEh/HNJAbVQAe0kr0CxKh9/h9vUmCH+QtOiuD1+kRZnkvxRUZBjRUMv131rU98eDOiPb4aVAOnSv6bTRtN4Gbmd+qL/H1KFUQZjTXsPrb0zVwsfK5gsHt9mjf6Ih4BE/miMymNktxcs1y90L0H57lebgJymasDZa0IPIwY6YvxKy1ffm+gE6xmMBcudZaKISq2uzSfurXPK63lBGmVbUAWjIccP47ULVGP60Auo0wI/B+rfIdfG3fdxSQkQpwgzOHYsMiwdpRk61S7BxldueRacKH9vCSTdzdguL44TA09KUv8Y4XexGYUvK2oowkuY3VczKqYJtPNTF8WUBvJvaMyw0W8yeOaFLMi+51po6kD9L9TVo2j2mGqSPv0qO6XJvFsvvBDiX5r2Q70zzs9Ht+ocyoUsetXhQHFBGy3oRengMyH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/13/25 20:09, David Hildenbrand (Red Hat) wrote:
> On 13.11.25 06:13, Balbir Singh wrote:
>> ret of type vm_fault_t is reused to capture the return value of
>> nouveau_dmem_copy_folio(), which returns an int. Use a new copy_ret
>> to fix the issue. The issue is not new, prior to this the function
>> called was called nouveau_dmem_copy_one() and ret was used to capture
>> it's value.
>>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Closes: https://lore.kernel.org/oe-kbuild-all/202511121922.oP20Lzb8-lkp@intel.com/
> 
> It's a sparse warning, is there any runtime effect?
> 

No impact really, it's just a sparse warning

>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>> Cc: Rakie Kim <rakie.kim@sk.com>
>> Cc: Byungchul Park <byungchul@sk.com>
>> Cc: Gregory Price <gourry@gourry.net>
>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Oscar Salvador <osalvador@suse.de>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> Cc: Nico Pache <npache@redhat.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Lyude Paul <lyude@redhat.com>
>> Cc: Danilo Krummrich <dakr@kernel.org>
>> Cc: David Airlie <airlied@gmail.com>
>> Cc: Simona Vetter <simona@ffwll.ch>
>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>> Cc: Mika Penttilä <mpenttil@redhat.com>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>> Cc: Francois Dugast <francois.dugast@intel.com>
>>
> 
> Fixes: ? Or is does this just fix a sparse warning and nothing "real" we could run into and cause problems?
> 
> 


There is no "real" impact, it's a warning about the type mismatch.
The return value is checked as a boolean. There is no need to backport
to stable, IMHO

Balbir

