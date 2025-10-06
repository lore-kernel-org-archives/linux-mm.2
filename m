Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2717CCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 04:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E505F8E0005; Mon,  6 Oct 2025 00:28:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E28398E0002; Mon,  6 Oct 2025 00:28:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEF748E0005; Mon,  6 Oct 2025 00:28:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDD278E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 00:28:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 530208764B
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 04:28:36 +0000 (UTC)
X-FDA: 83966408232.01.38B36DE
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010056.outbound.protection.outlook.com [52.101.56.56])
	by imf19.hostedemail.com (Postfix) with ESMTP id 620481A0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 04:28:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ChAKt1dM;
	spf=pass (imf19.hostedemail.com: domain of bharata@amd.com designates 52.101.56.56 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759724913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ltmpp+NXPiFJS3oppF9pA9poDIWrmXc5XFxJm8T6W3w=;
	b=rnHTadzRzLg963jXn2m+MAh7OlTrm2wD7GENJ5bCUt5uRMfLqUwQcl/kUptOKVKgzWRk8t
	Hz7lYYOOraxZhFGY5U+37rvQD89XOC3qDbLPDvpZy8I+N7tzQygXah+FY7XtSsdUTstAHT
	nA/N5uOgUW8pR4S72CmcBkn4Ea7FABw=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ChAKt1dM;
	spf=pass (imf19.hostedemail.com: domain of bharata@amd.com designates 52.101.56.56 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759724913; a=rsa-sha256;
	cv=pass;
	b=v0SWz/1Zq2S8ePQXglhJ7ESNN6jCPdnr2hJYPaGwpYxDL+fa0lfjALrlwE7trzKGO/pdJs
	nJPluKPzLctObZJv6Wf1oPD14u4oALyx0Xh9YUQofINhfiO85DglHyE+MwNkDB2iskWIS8
	mweTw5v3eOJRmxnafFogBmA1GUCyRVw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TvqtsysaOm+rNqWKZUbQ1jnPJNZC6ocmtXMoq4yLOkWMQegnkKedG80ydSGu5cJtdadHB/jMTrrbSNwZhmY6w9HVaYWeEp6Obf4oMtvgJmtywOc7tgEMUz6RQKaI8CF9wuQ0R5EQLVRwWr0ukdSa8YOw0KnTBkHM8VKw8Tt536mHHg50v/MtypFG0oPUMoj25Pv7VumWcn/U+mgKSpYgCCMrdhlrbWyPWQaJfVUN6/BKl29oFoyRmlbjDvyDgxz2LjvoT0WgM32QEVOpkIA4IyfjGexkgdSxNqm646bylHQN3a37VLMOk26ylLJD7uN/ArWh3k/xTKFcpHdTccBO1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ltmpp+NXPiFJS3oppF9pA9poDIWrmXc5XFxJm8T6W3w=;
 b=bbn1atQv5CPJKESkm/Ta5LH4rEoL3o0XxAbR0fWUCCg3xFCMet40U84D2BXVYogr6QNyWVvPlEUjGO13S4KP4F2DGgsJ97AkjPs+y/kivDd+tBnJLYXQFqnSHC7e8YVrRKF18i3mFIO+r59JEIlmZhzsqxkaunGLngEdqlOIArPU0qO+y3iI0GYkZogws0jelI7gMD6pvrhxHJnEuaSlf3FGZemo0+jujwvG+FXWqKmtnIaoe6lRArt91fTspFXKEpGzedZ4yZb4Xb2n7vNI56wltJvc9G4hs/0Z1RwHd/582EiJS9lEC8GXuhatu77gHwRfj2GE1MUd7/HWcez0AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=huawei.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ltmpp+NXPiFJS3oppF9pA9poDIWrmXc5XFxJm8T6W3w=;
 b=ChAKt1dMZjEDF3QRjves3u5cWgOtetYSQpe7+p+p7it3ey98gLGLKOb6mMUwQVKNKPfHqrpiesQch+64EU24aMKRtObO1ehuuWPzJc4JqpU8Zdi6kayx6kLgT9cptIlmNIWPsh24a1IXXmjH9vRFWxsrI3sDnhchy0xkVPy5YgY=
Received: from DS2PEPF00004567.namprd21.prod.outlook.com
 (2603:10b6:f:fc00::509) by DM4PR12MB6424.namprd12.prod.outlook.com
 (2603:10b6:8:be::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 04:28:23 +0000
Received: from CY4PEPF0000EE38.namprd03.prod.outlook.com
 (2603:10b6:92f::1004:0:4) by DS2PEPF00004567.outlook.office365.com
 (2603:10b6:f:fc00::509) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.9 via Frontend Transport; Mon, 6
 Oct 2025 04:28:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CY4PEPF0000EE38.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.9 via Frontend Transport; Mon, 6 Oct 2025 04:28:21 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Sun, 5 Oct
 2025 21:28:20 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 5 Oct
 2025 23:28:20 -0500
Received: from [10.252.192.21] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sun, 5 Oct 2025 21:28:13 -0700
Message-ID: <531fea9f-a9c1-40d3-89a3-7b90d6b3c1d4@amd.com>
Date: Mon, 6 Oct 2025 09:58:13 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 4/8] x86: ibs: In-kernel IBS driver for memory
 access profiling
To: Jonathan Cameron <jonathan.cameron@huawei.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<dave.hansen@intel.com>, <gourry@gourry.net>, <hannes@cmpxchg.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<balbirs@nvidia.com>, <alok.rathore@samsung.com>
References: <20250910144653.212066-1-bharata@amd.com>
 <20250910144653.212066-5-bharata@amd.com>
 <20251003131926.0000363f@huawei.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20251003131926.0000363f@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE38:EE_|DM4PR12MB6424:EE_
X-MS-Office365-Filtering-Correlation-Id: 81cc40ac-bb5c-4dda-de0e-08de0490c87e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Zzh4eTlUUy9vbm1KdGxYdGIraFNYQ3JvRkxLaEVtL0V1OGh3bGh1UHA5eWdl?=
 =?utf-8?B?N0pwZGgzcjEybWNjZ1FEVWNENCtIMGdHMCtEWW43WEtKUldCWVJNNVlCVzVx?=
 =?utf-8?B?SkhIUU5kcko0Zkt3TW5sMWNpcUhKZEZGYkxqSWY2a21QbWtuQWFqL2ZZMjM3?=
 =?utf-8?B?WDIvTFFVcW1lVXc5cVV1Um02bWZUNzdROUUrV05qQ2dJRXczaTVwMnE5QXcy?=
 =?utf-8?B?OERNdTUxZlVuSGlKRmg5dnh6dnU1ZGlRYjFaQnRxQ2VCYUR3VkczQXZwdzUw?=
 =?utf-8?B?ZFNaelZqV0ZDbDhDVmc2RHRMdHBaNEZhUk9aWS8zYU1TZ2tnd0pWVDNZMW9v?=
 =?utf-8?B?UTNTaHZDZXVyN2JzSC8zeDBZV1c4STdCOVFrcFZ6UndzQmlFdy9iQWVSaXRs?=
 =?utf-8?B?cGdJNW1Jc05nRHR6WlZUeVp3MC9Jc0QvZU9wUk1yYXkydytNVVVGSFRvdFkw?=
 =?utf-8?B?OWwxcG1tOS9nc3VqOFF2a3RrM0xDUU12NXBwM1EwQm9BYmwySmdVajUvVFht?=
 =?utf-8?B?eUE0QnFOZXhUQlRKQnU5Q0lCOXAwZEhqa1M5TFJuNDlteFpvZWVyQ0xNMnZu?=
 =?utf-8?B?dEo2c2Q4cTB6RVVHMm9CM3M2OFZrQk9xSm5RWVdaYmpRaGU4QnhxclBpK202?=
 =?utf-8?B?RzVISEZadjNoYXJyL0JjUWVaU2lhN2J3Uzg2T2pXZFpXaXZ2Z2VRenVNdVRq?=
 =?utf-8?B?Z3k2aTJkdk9FdnNaZHdJWkFGUlVBUFFMQXFCMjZiWkVXYmZEdGFURnhPUnlD?=
 =?utf-8?B?eHJEM0grWWlqckJUNVBCVEVObi8wWkdITjNPUTFuYVExelBPWE4vYkU3S3Q0?=
 =?utf-8?B?ZGNya2Y1U09yclFJejFJNW1RS2J5ZTUrK08weG5ZYUNRM1dhbzQxMWVGdWJN?=
 =?utf-8?B?Y0NpZ25oS1V3TExWbGFoR2Izd2pxZW5vdnhTZmNSSGJrNWd1QlRGUllsdDEv?=
 =?utf-8?B?akErdlhibnc3R0d5dys0eXFPSnF3LzdmczNDb3h1MUxjSW42ditvNmVpL3BL?=
 =?utf-8?B?NFhGc1RvRXJNTERZckZMNy9WN04rRWI4U2Jud0tYMEg4UWdtczFoNGQ2RlhG?=
 =?utf-8?B?ZExNL0lkR05Vd1hGNzBSektmZFpTTExXdTBJSFdSZkZmM1ZWVDR6UDNGdWk5?=
 =?utf-8?B?RnJHQmpuTEUrM2Z4Y0tIUUhkWGM4ZkYyUVM1VUdUQXZMTkRSVjltMHZ3bTBo?=
 =?utf-8?B?QXBrQUJpcHVyL01VaWc1NUQ5M1VZTGJGT3FiMSs2c2ppS2RZRktvK29QUGVl?=
 =?utf-8?B?cWd0dGdIbTJ0V1owM1hTODZZMk5ZNW5GUVY1VWFRSXBPV0xnU2Q2MnduRWxt?=
 =?utf-8?B?YjdrblV3VFpyZW8wK252ZGp1RjV0N25TeUIzMktRbGg2RmFpYmp3TGtya2FU?=
 =?utf-8?B?VDgvbE5LUWJac3FQUnU1NEdIWWJMcVdjcnZ4VEFDcFZweEtxSVMyUnZmOTRL?=
 =?utf-8?B?a0RIMk54MDM0VDFaUmZyQlptV1pGdW5ja2EvS2Q2SUdsMW01UFVFYlNFUVQy?=
 =?utf-8?B?QmovcjJNSHNmbXFNeEx2ZTVYbEZRNkVzMEpwRVAvOFVIKzlqeXg4OXlOK216?=
 =?utf-8?B?RmQ4Zk5OdTduZ1pYQzRUS0YxK3RCTzcyNG1uTmVhZSt3Z1ByM2dDT2hRN3Vn?=
 =?utf-8?B?aW1qeTYxMXFWQmNxM0tna0RRd0tsemc4bk0rMDhETWVRNXNrbHVwQmhrWHdQ?=
 =?utf-8?B?STN4cTJGUThpZDI3K0wzYmdrU3FGWlJ6RERMcjJvT0k5M2NDZnlZVGtSbDhi?=
 =?utf-8?B?dFVjTWtMQjNXMDhFSTd0SGF5Vkh2Nnc5ZzVVODFpUUlDakJVVEIreFZoWEsz?=
 =?utf-8?B?QTdjWE41aTVOc3RLYWVKbElhWUhvU255QVhJSW9ZSEl3YXQrSUMxWkZIaktx?=
 =?utf-8?B?dVFJSGloZEpWUkVOeFpvQlltWUp5bGhnTm5CdU0yT1JsMTc4Z0U4Qk9RQzdY?=
 =?utf-8?B?YXdmS1BZS2JCWXVhTnNWS3djcmZZZk15WWlzV3hPd1ZwcXJXMG43cnpHcDRl?=
 =?utf-8?B?aFJUMkM3ZEJ3cFNBbXI0U3ZzRXVFNmFpdHNaMFd3ZFR4T0FVaE5TQWtVN1hl?=
 =?utf-8?B?cDVEcU5ISWozckRqODN6aUZUSk1SODJHV1NJNHJZZkc3alVMcUF0UzFCZitz?=
 =?utf-8?Q?XHmw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 04:28:21.7879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81cc40ac-bb5c-4dda-de0e-08de0490c87e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE38.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6424
X-Stat-Signature: m3b9ufwr7z6j7eh1u6bsm1tdqmocmsue
X-Rspam-User: 
X-Rspamd-Queue-Id: 620481A0002
X-Rspamd-Server: rspam04
X-HE-Tag: 1759724913-650319
X-HE-Meta: U2FsdGVkX1957+eTWMy+7GDsc1MSFczEbZk/XiK3Eg2WwhvsA2Dxhe4alZCrPQmm/AejwIKmMNeTT+51HcJ5Tw1Mzi1lqRcLdQKAeQ+B31psY4ooSsAtH2c4Dc51CPF5qN1i0snlKtSqKToE4QFY2Ox84h6N6A5YcwdAIOXanr8u68oFkwKglRS6PMjdp/1drBZRrjaD9omNJqZWjnpSTAgBJtQY0SClJZURj/j6D7pAHwc3MNGICjbjfK5UvK/+lVt7AaMRZYwacyZjL3DgfBDmqgQ7S77osz1d+75oYvhaQZeZqgGYqiR7j++vVOUGkHh2nsdqxyDUOepDNTGxDYS6Mu9V8sAoq2MLpmtrFCMfHjJxKwsDO9D/ECdDJlMHWsb4oeVgs0jlg8KcN0rjd4itwbcIVM5dwlTdptwOthgp/FRCgyJGGXwIwg+MSC/ZfhP0wflDiX8m/h6aE983MuwTSAysWpKgeWTIkIcQ1/yC/QUaI+49oQw4Z3F5BaRAki4hQsJcpldIsRvKHcuS/OM3jCcSzb8OmelxSNLjUrqE0MczbtQwn/In1pWitiQ2SHyfvmoskTFDLjkwCA5xKV+2T0KtfIzn/Xc+nAibF7eb6SPmaoofQi/jJm5FVM+7ZMo7uqyWjCMPkpJYUEFl0ZYu43TWiwLHs2+gbghqZgY6xAr1L4ycRpFCVZiI6ndLXchHNDljcjA8UVqli+XbtXQD98pELM93/jHivJrdokMTSkV0rZut1qTRcpC/VycQg+0PdCMXSgoHGXS1ekF2zd5rZw9RvIXq5J9W4Z0R6q54a9cAQeBc/WkUNe4Wud0aHwc9TAQu5fMxHQ6pOewZZVvYt0a1bF02KeC5FG8s/khLB6JW+O1LY9tHdPI9JxQx6oXx8O2+lImlYHMZEBd5AaGUMxQbkMt3bFxFCMQsTu450MBMyntPEyTvFzd8OaCbzkJi+y5vJdGGrETjx5R
 6elxcS+m
 dFr/NGOQBcVdC7NtizAKj9d53k0lA3+zCTpO8sXvAQZAzdgUkxZZk0K5aMe60+gGVPszxUqNUy992WqCNejAyAW84p1FzKR6CLsTS1vkU6YbG3OE5aSfj5pqvEE73E6LGmD5tFLbkdOo9pkKeWNsEmXyfHM4V/1bu6QH+Dobci11XYqYQ95SgqE8qvVRX0LRF/tk068Gz87iaYZQ5VdEkE+BuPRSHVB/0bFkTUTAXI5Oc8P3uV9MtxOl6qWzs58G3ezgsxSg+2p0NlYJxTIri+fPkWBSV5kjhnRHghTAz2E4uCXGCYAcqmatUf/t9lxlInK34tXqfmARSAVgRgYEZ9iNJqwuyUW+I0nz8ud+D1KVPgXxXHCD/YB17ZyrMggLGBORO9YCmUKvbwnJGzl9ehwMmNLRCLZ9y1juHVXBcXX0yrlMqEDdIoLz6YyWsXp+zAzf1DTMSlTyvPhQtyhSnkQOjJ7c0KZmHXZKR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03-Oct-25 5:49 PM, Jonathan Cameron wrote:
> On Wed, 10 Sep 2025 20:16:49 +0530
> Bharata B Rao <bharata@amd.com> wrote:
>>  
>> @@ -1756,6 +1758,15 @@ static __init int amd_ibs_init(void)
>>  {
>>  	u32 caps;
>>  
>> +	/*
>> +	 * TODO: Find a clean way to disable perf IBS so that IBS
>> +	 * can be used for memory access profiling.
> 
> Agreed on this being a key thing.  This applies to quite a few
> other sources of data so finding a generally acceptable solution to this
> would be great.  Davidlohr mentioned on the CXL sync that he has
> something tackling this for the CHMU driver around this.

Okay, will wait to check that.

> 
> 
>> +	 */
>> +	if (arch_hw_access_profiling) {
>> +		pr_info("IBS isn't available for perf use\n");
>> +		return 0;
>> +	}
>> +
>>  	caps = __get_ibs_caps();
>>  	if (!caps)
>>  		return -ENODEV;	/* ibs not supported by the cpu */
> 
>> diff --git a/arch/x86/mm/ibs.c b/arch/x86/mm/ibs.c
>> new file mode 100644
>> index 000000000000..6669710dd35b
>> --- /dev/null
>> +++ b/arch/x86/mm/ibs.c
>> @@ -0,0 +1,311 @@
> 
> ...
> 
>> +
>> +static int ibs_pop_sample(struct ibs_sample *s)
>> +{
>> +	struct ibs_sample_pcpu *ibs_pcpu = raw_cpu_ptr(ibs_s);
>> +
>> +	int next = ibs_pcpu->tail + 1;
>> +
>> +	if (ibs_pcpu->head == ibs_pcpu->tail)
>> +		return 0;
>> +
>> +	if (next >= IBS_NR_SAMPLES)
> 
> == seems more appropriate to me.  If it's > then something went wrong
> and we lost data.

Makes sense, will try that.

> 
>> +		next = 0;
>> +
>> +	*s = ibs_pcpu->samples[ibs_pcpu->tail];
>> +	ibs_pcpu->tail = next;
>> +	return 1;
>> +}
> 
> 
>> +static void setup_APIC_ibs(void)
>> +{
>> +	int offset;
>> +
>> +	offset = get_ibs_lvt_offset();
>> +	if (offset < 0)
>> +		goto failed;
>> +
>> +	if (!setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_NMI, 0))
>> +		return;
>> +failed:
>> +	pr_warn("IBS APIC setup failed on cpu #%d\n",
>> +		smp_processor_id());
> 
> Unless this is going to get more complex, move that up to the if () block
> above and return directly there.

I want to print a warning for both the cases: when LVT offset couldn't
be obtained and also when LVT entry couldn't be setup.

Regards,
Bharata.

