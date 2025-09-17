Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02033CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 04:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57D538E0006; Wed, 17 Sep 2025 00:15:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52D7B8E0001; Wed, 17 Sep 2025 00:15:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41C2B8E0006; Wed, 17 Sep 2025 00:15:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B42C8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 00:15:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A48C57266
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 04:15:52 +0000 (UTC)
X-FDA: 83897428944.22.5C6B862
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012023.outbound.protection.outlook.com [40.107.200.23])
	by imf05.hostedemail.com (Postfix) with ESMTP id B20B6100009
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 04:15:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=zyM+CO90;
	spf=pass (imf05.hostedemail.com: domain of bharata@amd.com designates 40.107.200.23 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758082549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S5JnkWsZ60K1+ZwFc7RPCShrCkEo5aFrBI4sAaHRVe8=;
	b=lZpzQcm/vol6iL7McQKN38Jp+fUqKls6Xhri7rsuHg2ECuqcW+OAD5dN7hEDlSOocondYu
	x60D2TFcxeCAbrSHoRHPc1br1h6Jwna2unM3Wrlpri1Xz3PSLjHsYPNYIqrUYZ1Q7cdBLb
	/XWtxm6nNrOmqUHGS/TRQO5HqQ+Dx6k=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=zyM+CO90;
	spf=pass (imf05.hostedemail.com: domain of bharata@amd.com designates 40.107.200.23 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758082549; a=rsa-sha256;
	cv=pass;
	b=W65X3BoNizPzFs2wf79gHLU39VVhw5jIDorsVAfJlTzhMu5eKWRM44qlU/Fu2+Vqqopd5s
	SMroijhOit2TjO32xhZ9HT8EnAoerMYc7AzZpHMDL7dmFNZehOCzdO18aoB0iZFL6Hh5uz
	gDEhdFDxyAAYaSv2oY5F8aeBWXYi0ys=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a7vCXQrcrqmTmctd/N4wpvTgLaBDcJrxyx8IQ/dcpmo7zO1J2I1BCNLxSQMXMmI4aylRC5CTFRFX38RkIIrFuVCc7WPEm1f+qjWEHFKEn8cPypNxbiNlogEYoC8KmtgMkYgrj529yYZ3kErHNFoM4HA89F1RqPJaDTVR9hLwERXouZmsKyJLnlNamVhD+NUCwOcY1La1kwNxYZtFmzwJb7IvbE2ZacIOiCNsUta8OiTyPFQZq5cE2W60Kce0SC56n/ngqUyTQnZtg1tUePMZIjYdnolUXdP3JYfzXlkXIpO62g4YUJ0UPaM2xjSOB1T2k2iDyvGm0OLkkmea+aq7BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S5JnkWsZ60K1+ZwFc7RPCShrCkEo5aFrBI4sAaHRVe8=;
 b=c8zHWGDkEOKfZxNrdUxlGWLEzcLosCT/fyD+bD+OdVA0Ke/DvVAwZ6At29lUafQRX8v98NKPwf9A88wcfNhCxGFvl0QDIUKY+H8c7M61EUcnc9hix/pR2OXLlKKPbKpyRUFloqVzCOEwrBajE0dn8YZO6eXFxKwfOAzlnFCL9q+snPLv9EdJ4qqeQB8jsBkKn1IqFYH3Q0DVUOakUEvajf8ak+FrnGmF+61BLKiHig2WXLP6cKGRaPPBq0jfoB7zw+ktcLeRDBH99LQItfk6u9Afvzo/a7P/+FH64pWHpN4zC20yfyQ5LXY37Sg2NWIY5h0vYuu+dhqgMp6TnS72zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nvidia.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5JnkWsZ60K1+ZwFc7RPCShrCkEo5aFrBI4sAaHRVe8=;
 b=zyM+CO90ABDFH3zsQ7Os0V4s6hJPesHJSKxFUIkokcKUyLdP0Oxx7QIticnEjoIV/m7pcRNY4VksUZOR1FtKiwiqvZ0MCnXmw4oUzdDjhgCR6m06UxQK2NyF6u9rVWiZaRN2ZXtz3JN3UrlLaEySWjIcHIwPXnszscLPlH36YnE=
Received: from BYAPR08CA0067.namprd08.prod.outlook.com (2603:10b6:a03:117::44)
 by CH1PR12MB9718.namprd12.prod.outlook.com (2603:10b6:610:2b2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Wed, 17 Sep
 2025 04:15:45 +0000
Received: from SJ5PEPF000001F1.namprd05.prod.outlook.com
 (2603:10b6:a03:117:cafe::2d) by BYAPR08CA0067.outlook.office365.com
 (2603:10b6:a03:117::44) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.13 via Frontend Transport; Wed,
 17 Sep 2025 04:15:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ5PEPF000001F1.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Wed, 17 Sep 2025 04:15:44 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Tue, 16 Sep
 2025 21:15:15 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 16 Sep
 2025 23:15:15 -0500
Received: from [10.252.223.214] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 16 Sep 2025 21:15:07 -0700
Message-ID: <332e842b-a3c9-41f0-af5c-c147661d7997@amd.com>
Date: Wed, 17 Sep 2025 09:45:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
To: Balbir Singh <balbirs@nvidia.com>, Wei Xu <weixugc@google.com>, "David
 Rientjes" <rientjes@google.com>
CC: Gregory Price <gourry@gourry.net>, Matthew Wilcox <willy@infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>, <hannes@cmpxchg.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <sj@kernel.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<alok.rathore@samsung.com>
References: <20250910144653.212066-1-bharata@amd.com>
 <aMGbpDJhOx7wHqpo@casper.infradead.org>
 <aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F>
 <7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
 <CAAPL-u-d6taxKZuhTe=T-0i2gdoDYSSqOeSVi3JmFt_dDbU4cQ@mail.gmail.com>
 <71ac5779-d535-4b0f-bf8d-7a60bf6a6ecf@nvidia.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <71ac5779-d535-4b0f-bf8d-7a60bf6a6ecf@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Received-SPF: None (SATLEXMB05.amd.com: bharata@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F1:EE_|CH1PR12MB9718:EE_
X-MS-Office365-Filtering-Correlation-Id: 115fbfba-1791-42e3-fb29-08ddf5a0df51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SVk0Mjloa2RTOVJEZzRVbXNXN0daK2ZoNkdCL0pQaWxQNUxHaTVsTVR3YnJE?=
 =?utf-8?B?N3lOdUtibG1aNmUwK3ZCVVo5WTNsV21oWlNOcVhmMjFxbjV6TitYT3ZmN3J4?=
 =?utf-8?B?cGJpZ2dXZWNZdkZQNTBzZFUwY2xHV2lVaHdxQ0VFc2dKRGUvM3hpdFFIdnE5?=
 =?utf-8?B?M0ZhUUtQMUEwSFM0RnRGTjFPVVZ0K2FXQXNlQlg5eXdVbUl4aHlhRWlaNld4?=
 =?utf-8?B?OGFnTUFiTUIvTi85Nk12eS9UM0FSNEVNOUkrTWtTeGw3U3NZMXRMM2RQMmVv?=
 =?utf-8?B?YytaU1NRTEdqSVlmaWRTbTY4Yy92TVNmWjR1Yk80OXpHV1gvelpHR0N0Qm9w?=
 =?utf-8?B?UTNkSnBMRmwzQU9QWkpoS3dzQjdCcTh6TnJxcWtITzB5U05meEkydlIyNTVj?=
 =?utf-8?B?WEUxUjEzTjFMVC9lY2tUMUZjWXZOYmtYR2lHbFhSek5WVGNSWjEzY0NSbXhX?=
 =?utf-8?B?OGZZZzgrbDNQM0p1ZE5OWFJKeVliSFdMK3UxeE1KRHlaSnB0alpuZDl6RDN4?=
 =?utf-8?B?VVhWNWRneGg2ZnZObXBDNGQ1a1lQQWJYZCtiOUp1K2FzOGxvNTRLOUtzQ280?=
 =?utf-8?B?WFFDQjRRbnltODRxM0RUZ0R1RzliR3lXVUNwSjlENlhzWUNnOEtCbkp1YUg3?=
 =?utf-8?B?OUZnTVprajhrSjdsbkRsN1dvU2M4eVNIbmhvOXVsN3FEUHRPcnk3TmxNaE9T?=
 =?utf-8?B?eHdRWXduWDlNcWtzY2QxU0lha1VWNXI4a2VDVUlLdVhuYmpPTDFtVmRMT3Bi?=
 =?utf-8?B?aFlxcG5kMWVMZENhMlJiT2R2d2lnRHRuaUdWL2JqOUNPZ0xaQXlncVdvb3Zk?=
 =?utf-8?B?RGxzb3hxVjlIa09uby9rRUpaa3pTRGxneTBUVHZvVkdwbDQ2aHFrWXJUTTRQ?=
 =?utf-8?B?bWJKbXhHN3pMcTFkelcwcUp3ZzdHaEpmQkFLQ1h1UVFiQWJhNUZKRUZZS2Fy?=
 =?utf-8?B?TGdGRDZlOGw1RURSYUd0cE5CamZiUHI2bkxUNHQ0VEJ5dG05UE9Nb2tlYkNG?=
 =?utf-8?B?Y2tEZ21sbmdkaHFIRHJmRllyN2J6dXlpRXdWRTZmYWh6M3RpN1ZkVWFRZG8y?=
 =?utf-8?B?NGpzNUpLYlVta1BxbWdPVTRKcFNlWWFHcEJEV3ZjYkF4Q0htN3FhSVJqR051?=
 =?utf-8?B?Y3NoSmd1bEtnQ1VxMyt4L3BmN2h4RStzWmFrUjhydmdKd2RqTlhXVFdORmN0?=
 =?utf-8?B?K0JrS2ExWm5Xd2hmbUY0SlJkY0Z2amd4aGRzb0xKWW9lUzFaYUF5VGVmVUtU?=
 =?utf-8?B?QTF4TFZaVDNYbnVBdzRQdER2WjRkUHRJRmxpVEpQeithRFVIVXNhS1pSK3lX?=
 =?utf-8?B?R0NIYkt6R294M2xQSkVqZVRJSzczT2NESDRobXZDdFEyNnJXeTV0QWd5R0Nn?=
 =?utf-8?B?aWVoeGR6OE5ySnljbkNoVDVZaWhudjFmd2d4b2lpVThNZDNjRDBpTlFDd2lZ?=
 =?utf-8?B?LysrK2RDSllxeU5pSmJDMTUxbkVvME9WeG9sS01kKzVGTU8wSE43SkU4MThO?=
 =?utf-8?B?MTRFZlFhWEpVc1BYNlJQNm05UGVFdWdrZUxWL0FDbTZ4MXQ2bVEybWRPVGM3?=
 =?utf-8?B?dDVYY1ZpbCswTmVzQ3lnUVNoaUEwaWJJOXpBd3lQTyt6TElZT2FVOFZWN24x?=
 =?utf-8?B?bXpueitQUVdGOWZjNUpmVk9ITWNsUkdlbFNZeGxvT2gzc3Y0ZXc2TXhMa09N?=
 =?utf-8?B?RTNVMlZKd3hiWGY3NzV2Q1p0Zys5ZVFDRWFNdXFXVm85WU1DN29HMXh4NFlV?=
 =?utf-8?B?S0xLT1hmKy84YVFhSGd2b3hyTzE2NEFYZDRmVVBYNXRnMnlmSExpOHhQa0dU?=
 =?utf-8?B?b2ZFZS8rcmsyNG1HOWNwUUk4amVsdU8yc0xrdzV2NzdYV2NQZUZqc0xMaGQr?=
 =?utf-8?B?cjVrVmxpTis3c2haOHpaWk5WbmZGeXVoVlJKQlhXWXA1M1p3c2lEN1dDSTNs?=
 =?utf-8?B?K3d3eVNtelYyMW9yWmo4bWREcmlNdS9rZzhTWm0yaXRLUzBxR2Vnc0g1dCtO?=
 =?utf-8?B?VVZmS3p3M2tpYXozVldvaTZ3NWxZSk14dmlQeEwwdjlZckpud1FyWDJzR0gz?=
 =?utf-8?Q?2no1uM?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 04:15:44.5404
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 115fbfba-1791-42e3-fb29-08ddf5a0df51
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9718
X-Rspamd-Queue-Id: B20B6100009
X-Stat-Signature: pied36cz9b5s31o1yqsofn61p4y44euw
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758082549-656230
X-HE-Meta: U2FsdGVkX19VrjA+K20h7noLBbQtVN2mZ1huErOvzvsPz7uVG7Xc3M7b5rhzxCAmhsMrsgIsqfAFJGLyQToeVgfPfOq8y0VoW6zZcJpLZ8EsXf24kVE9PbZ924pQg38hBQUQqB3aYiIe4DbqGTRU2vmH12iK8+s+4oScYlPbop6ZUWgjDb6OOr3NJsrSPKnGCVRVhYAT2CdUsDl7J7DDd9Hdc4qUAuO36DDD+WShq7c/zJlScdpQ/NTbgzcDl7rKhrwyWKMJQ4XBzjFnDQcq251NEcRILj6p6RSuEF8XrUZOzwQDz4+hOg/wiXP46kyswWiiJjVlt7/GZcqgn6FT/Gu8YVFlywTvXBjGUtR/+/axd9+LxBFngnFv76e8liF38TGVfMdPVvY12u3aNxjUxMmSMh9FaM8Tvfu0UBbzkfuHBdrncHnr2X3wVme3FBT3+ckvbxhxRIcWO+Y3YCM9PI1vD2OYStnzsXyRh/YSlkEBLAs6vp0Bt88OUL2rSDp8ei8Ln4o9/tWSf++tmdBunwN1Qk2HMQonh1ZPhqZ9fYHPvscfwAOMeMJaXsAbMPN3aKqGYZeYenXX6TkkmeUq//QPBB0TRF2DQP2Zb8/zOhZ6Ow/W4NYztu9zUmx06K+elq4F7ccGPwLItbShmFz+qdoB+J/sM+J+O3GeRxtGsAMWoch/0C/eISzlIPvjES4PkPOTWrA3nk6I5jZ/k9MTx1ljygLeXNBUzNhE0mJryOgDPZc+25lBNfY7AE67+TR9w1WUgZRTYmxEi+q5D9bljcAo+VYi0eqsg/OwKv2SCeDj7t7gdDPXA0ehb/aAFic8Fwa5FS6PawGTWEoGWt2FKP5driN7hdgjUTt7MyFMo38S7wGtzJRSvVfV3wr6bGPcLTBEzdg5/B/bwSU2M4P3IuhSeBkv62B0AVuHDXh2n0lij9X/c8Dl6hPR7pv9amCiYSQSlO0CMypZIrnkKfu
 FOAUyIUe
 chWuZny6WQ/4huknw/AGckOZU9ml1x03OOf4C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 17-Sep-25 8:50 AM, Balbir Singh wrote:
> On 9/17/25 10:30, Wei Xu wrote:
>> On Tue, Sep 16, 2025 at 12:45 PM David Rientjes <rientjes@google.com> wrote:
>>>
>>> On Wed, 10 Sep 2025, Gregory Price wrote:
>>>
>>>> On Wed, Sep 10, 2025 at 04:39:16PM +0100, Matthew Wilcox wrote:
>>>>> On Wed, Sep 10, 2025 at 08:16:45PM +0530, Bharata B Rao wrote:
>>>>>> This patchset introduces a new subsystem for hot page tracking
>>>>>> and promotion (pghot) that consolidates memory access information
>>>>>> from various sources and enables centralized promotion of hot
>>>>>> pages across memory tiers.
>>>>>
>>>>> Just to be clear, I continue to believe this is a terrible idea and we
>>>>> should not do this.  If systems will be built with CXL (and given the
>>>>> horrendous performance, I cannot see why they would be), the kernel
>>>>> should not be migrating memory around like this.
>>>>
>>>> I've been considered this problem from the opposite approach since LSFMM.
>>>>
>>>> Rather than decide how to move stuff around, what if instead we just
>>>> decide not to ever put certain classes of memory on CXL.  Right now, so
>>>> long as CXL is in the page allocator, it's the wild west - any page can
>>>> end up anywhere.
>>>>
>>>> I have enough data now from ZONE_MOVABLE-only CXL deployments on real
>>>> workloads to show local CXL expansion is valuable and performant enough
>>>> to be worth deploying - but the key piece for me is that ZONE_MOVABLE
>>>> disallows GFP_KERNEL.  For example: this keeps SLAB meta-data out of
>>>> CXL, but allows any given user-driven page allocation (including page
>>>> cache, file, and anon mappings) to land there.
>>>>
>>>
>>> This is similar to our use case, although the direct allocation can be
>>> controlled by cpusets or mempolicies as needed depending on the memory
>>> access latency required for the workload; nothing new there, though, it's
>>> the same argument as NUMA in general and the abstraction of these far
>>> memory nodes as separate NUMA nodes makes this very straightforward.
>>>
>>>> I'm hoping to share some of this data in the coming months.
>>>>
>>>> I've yet to see any strong indication that a complex hotness/movement
>>>> system is warranted (yet) - but that may simply be because we have
>>>> local cards with no switching involved. So far LRU-based promotion and
>>>> demotion has been sufficient.
>>>>
>>>
>>> To me, this is a key point.  As we've discussed in meetings, we're in the
>>> early days here.  The CHMU does provide a lot of flexibility, both to
>>> create very good and very bad hotness trackers.  But I think the key point
>>> is that we have multiple sources of hotness information depending on the
>>> platform and some of these sources only make sense for the kernel (or a
>>> BPF offload) to maintain as the source of truth.  Some of these sources
>>> will be clear-on-read so only one entity would be possible to have as the
>>> source of truth of page hotness.
>>>
>>> I've been pretty focused on the promotion story here rather than demotion
>>> because of how responsive it needs to be.  Harvesting the page table
>>> accessed bits or waiting on a sliding window through NUMA Balancing (even
>>> NUMAB=2) is not as responsive as needed for very fast promotion to top
>>> tier memory, hence things like the CHMU (or PEBS or IBS etc).
>>>
>>> A few things that I think we need to discuss and align on:
>>>
>>>  - the kernel as the source of truth for all memory hotness information,
>>>    which can then be abstracted and used for multiple downstream purposes,
>>>    memory tiering only being one of them
>>>
>>>  - the long-term plan for NUMAB=2 and memory tiering support in the kernel
>>>    in general, are we planning on supporting this through NUMA hint faults
>>>    forever despite their drawbacks (too slow, too much overhead for KVM)
>>>
>>>  - the role of the kernel vs userspace in driving the memory migration;
>>>    lots of discussion on hardware assists that can be leveraged for memory
>>>    migration but today the balancing is driven in process context.  The
>>>    kthread as the driver of migration is yet to be a sold argument, but
>>>    are where a number of companies are currently looking
>>>
>>> There's also some feature support that is possible with these CXL memory
>>> expansion devices that have started to pop up in labs that can also
>>> drastically reduce overall TCO.  Perhaps Wei Xu, cc'd, will be able to
>>> chime in as well.
>>>
>>> This topic seems due for an alignment session as well, so will look to get
>>> that scheduled in the coming weeks if people are up for it.
>>
>> Our experience is that workloads in hyper-scalar data centers such as
>> Google often have significant cold memory. Offloading this to CXL memory
>> devices, backed by cheaper, lower-performance media (e.g. DRAM with
>> hardware compression), can be a practical approach to reduce overall
>> TCO. Page promotion and demotion are then critical for such a tiered
>> memory system.
>>
>> A kernel thread to drive hot page collection and promotion seems
>> logical, especially since hot page data from new sources (e.g. CHMU)
>> are collected outside the process execution context and in the form of
>> physical addresses.
>>
>> I do agree that we need to balance the complexity and benefits of any
>> new data structures for hotness tracking.
> 
> 
> I think there is a mismatch in the tiering structure and
> the patches. If you see the example in memory tiering
> 
> /*
>  * ...
>  * Example 3:
>  *
>  * Node 0 is CPU + DRAM nodes, Node 1 is HBM node, node 2 is PMEM node.
>  *
>  * node distances:
>  * node   0    1    2
>  *    0  10   20   30
>  *    1  20   10   40
>  *    2  30   40   10
>  *
>  * memory_tiers0 = 1
>  * memory_tiers1 = 0
>  * memory_tiers2 = 2
>  *..
>  */
> 
> The topmost tier need not be DRAM, patch 3 states
> 
> "
> [..]
>  * kpromoted is a kernel thread that runs on each toptier node and
>  * promotes pages from max_heap.

That comment is not accurate, will reword it next time.

Currently I am using kthread_create_on_node() to create one kernel thread
for each toptier node. I haven't tried this patchset with HBM but it should
end up creating a kthread for HBM node too.

However unlike for regular DRAM nodes, the kthread for HBM node can't be
bound to any CPU.

> 
> Also, there is no data in the cover letter to indicate what workloads benefit from
> migration to top-tier and by how much?

I have been trying to get the tracking infrastructure up and hoping to
get some review on that. I will start including numbers from the next iteration.

Regards,
Bharata.

