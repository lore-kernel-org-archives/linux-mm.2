Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C987BEF06EF
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 03:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1475F6B0089; Sun,  8 Feb 2026 22:31:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F5A56B0092; Sun,  8 Feb 2026 22:31:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE6F56B0093; Sun,  8 Feb 2026 22:31:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6EDD6B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 22:31:15 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 864D31A0688
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 03:31:15 +0000 (UTC)
X-FDA: 84423492510.05.98FBD0D
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012056.outbound.protection.outlook.com [52.101.53.56])
	by imf10.hostedemail.com (Postfix) with ESMTP id 38EE1C0006
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 03:31:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=1T0ZAftk;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf10.hostedemail.com: domain of bharata@amd.com designates 52.101.53.56 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770607872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bQmpYtMGx7jRQYJW10nTkabDIa7IUvryryQHBJwgtbU=;
	b=jItrAn7pZNu3DBDNmp4ynp+zRMeS3wXHXqQLgMNSrvjYem/+k0+NoRhieLCQhVe57cxHvl
	Y8Hhhypq9jmcF+4ecCAaYWKLlQe0gKV1YUO+WuyQ1Kpfkr6OrTaTjT4WYTBytbn7QTr/+p
	lwMi8ROiYQ6GZY4NXjwSbX5Sj9+AchY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770607872; a=rsa-sha256;
	cv=pass;
	b=3bhz794JaJ5jb4h1Gy/Rat6ulq96jeqRx+unGTYsNFFomiP3CkkSN3UcmYolTsgHuYRiNo
	4xWU1tYKdAM5t9ADlYP1JF0MrjgAGk+RQ8m87wpifLwymJyPb66vhZlAOC3Zp6acyxT5bX
	2s2qrnPdkWZyT8Jw0H/DXTpnpr8unOQ=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=1T0ZAftk;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf10.hostedemail.com: domain of bharata@amd.com designates 52.101.53.56 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hHhIzyyxt0IksdaQmyHf3U18LWyUXR2j6tGrxl5+zuBQDvgzCuimCtT3xVJZyuhQIK9ggkzjuh001mSMeBw/d2BMfQNmQXAW+cUEtOYO1Z0SooYKXZzj9Fc/ZXUsvuwLYc2/3C2NLNgxQ2AJOY8WObQxWrdtZtawCna7eCUvQmt0j/idgMVRAQbTOZYmvG0xVFHkyhAd9Wj54jOb4iUsMsGGT2b2Vf+8x/1kOAb6GjnQsiRylTQMrfQqMFmfmKhTEFk8dmRPAV9GBqvtfy7rfl8JfLEX4xRa7fBNmc/g2p7wI/Sb3+iyMnqjpKQz6qZpXuuc2uN4pOKR69SA/hJMgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQmpYtMGx7jRQYJW10nTkabDIa7IUvryryQHBJwgtbU=;
 b=Bbcud9fYY52lmWKhoFHJEzIcwqPhba4OqY1JdFapayKTxpAzL8Ux0ZJKLY/fuACsuQgQ6zVgcRkZf35nOxiRiObnCxYMol5X0VTDELasLJ6KlmGwUOyWd8iKUe+PckC8w99auvk2rs85PISgnBINaVS/UkKD+AmWgczvc4pO2YAGekv30V5lfwyhJV3+5ZDNEFTn4UodoFGib/SplN8kAaLfZ5XD4Yb/K0Ianu+qy4M81jHndc7Hp+1gFuDWrgH4MFQYCpiaGBmlYTtMp37KXxkxeQx78S8DwKmMxDVRxyLcocqsOujf6N2meZSix2+794PFqsqqZsk5HzdvsEZr7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQmpYtMGx7jRQYJW10nTkabDIa7IUvryryQHBJwgtbU=;
 b=1T0ZAftkZAdR2jt2TswakaRuXaFeHTKzBviTGL45a9G/WfkTulD4LBFhsxKJWIpVjBfYeutgCmi7DaDmtoeubZ5H/1VCehtGlS0rQE/86BfpjnCr7eWjSfMQSkoqgFG28QhZOxUgY/IL/AYMdBmHOyc7l2Hk8peVW/2Gomqgdpo=
Received: from CH0PR03CA0031.namprd03.prod.outlook.com (2603:10b6:610:b3::6)
 by CH1PR12MB9696.namprd12.prod.outlook.com (2603:10b6:610:2b0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 03:31:02 +0000
Received: from CH1PEPF0000A346.namprd04.prod.outlook.com
 (2603:10b6:610:b3:cafe::56) by CH0PR03CA0031.outlook.office365.com
 (2603:10b6:610:b3::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15 via Frontend
 Transport; Mon, 9 Feb 2026 03:31:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH1PEPF0000A346.mail.protection.outlook.com (10.167.244.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Mon, 9 Feb 2026 03:31:02 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 8 Feb
 2026 21:31:01 -0600
Received: from [10.252.192.21] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sun, 8 Feb 2026 21:30:54 -0600
Message-ID: <4df58408-58d7-41ad-afa7-c42a64689ec8@amd.com>
Date: Mon, 9 Feb 2026 09:00:48 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 00/10] mm: Hot page tracking and promotion
 infrastructure
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
References: <20260129144043.231636-1-bharata@amd.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260129144043.231636-1-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A346:EE_|CH1PR12MB9696:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aa03b6d-a37c-4ae0-07f8-08de678ba644
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T0lmblYwQjVTOUJQOWlSQW5ZcVVobVRBS0FITlVkVFg4RFdTRjhENFRCaFZV?=
 =?utf-8?B?MkdUdG9lZldBVzhxanVqZThXMTRKeWxoSitLQW01eWY2QjgxdkovazRaallX?=
 =?utf-8?B?YkVQSUtIV1JZa1VNRWl3VjE2cjk4K01zTmg0b1BGN0RBUFk3Vkh6T2dmSnRP?=
 =?utf-8?B?b2xiVlRFZUdCV1R1cDJ3SVJCbUpFb3lxRmc3cEFycXUxMlZqZyszU3JVN1kx?=
 =?utf-8?B?bkNQdTBYb3graUV1SjFkU3dmbUxsYlh3S1RLVXpqTTFVMjh4RmNXc1haSWow?=
 =?utf-8?B?VTVxaTAxUnNNQVZwZG1ORWFnQ3RDdUZUc1Y5d0t1SThXb2NrRXVPdWJFUG9V?=
 =?utf-8?B?akg2UFU1ODl2cnIvU2xGMmZLRVV2Ukg3VzdlZjhnVkJFQ1g1KzlDZitYSXRa?=
 =?utf-8?B?aXpMVlNDc2V4dndmbW5taSs1a0pHR3FWWS9jNUdqdEJqc3VDNDBjNG9MOVdm?=
 =?utf-8?B?ZmlvK2c2TGJnWXIxUVNtVnpJL2poRDlwWkRmN1p6RnlOanRCS0oyV09aTkFv?=
 =?utf-8?B?QzZPU0l6ZkJFSjlwUVdJMWVQcnVDZHRnQ3EyVVlsTWZ3d05tVThLYmR5WkRS?=
 =?utf-8?B?MU5vRHdHdXRNRStYSjg2bVovdnBRTDBTNnBwZTRLZEhhNnRGWXdndzV6MWo3?=
 =?utf-8?B?WHd0QS8zQ3NlUzUzRHQzdFlMQnpwYjg0N3ZMZ3p6b3JIWVlFbnN6MlNwRkVv?=
 =?utf-8?B?MTJiblVhYVRnK2xzaDI1djJXUzFXOUxyRjRnUjNjNUNCUzQ4NWlORW9CNUUz?=
 =?utf-8?B?VTZDb0cxb3EwYWpxVTcyLzdUM1NwMXo4MkNmZC9xVENHNGhyenNITGdKSXI2?=
 =?utf-8?B?TTNtelcxOVVuc0NBVEo4SzRGNWZscjV0WEVZaTFhREhCcmZlMG9MNzJmVkdO?=
 =?utf-8?B?cXRqdFFjZU9wd1A0NEZERlNWOG9Zb08wdVQ2Z3lSTjhxR2k2SXpPdTRDd01x?=
 =?utf-8?B?WEpRNjNlTTkzS1NVRnRtM3Q3dUdHSWVSQ1V2M2s5YVdmUytxSEpVdnpUWllI?=
 =?utf-8?B?Mjl4NVlUNnNsMktyZlAxWUNrTlJoZDdMbFZTK3l4eWtsbHFjTUFXKzZmYVZW?=
 =?utf-8?B?Y1N2Q05lQXlzT2d2d1NmeXpEbDU0UzYrZ2FTUjdDVVJkcWFMdVJUNEFINlN2?=
 =?utf-8?B?NnJuN3JyODlzY3BjYnFLUGZBZDdoUHBKMi9Qbjc1QUZkZEowaTl0endMUHVY?=
 =?utf-8?B?clc2a0hZeTFGb3ZIcnNZSWlob3kwcTV2MDBTakZPUldiUHVUdVJmaU1rM0lt?=
 =?utf-8?B?M3B6QVlMWWhwKzdYWGpxL2ZOckc3WnJjK2daZ0dUZmJrRDRidjl3ZWpIU3BG?=
 =?utf-8?B?N3Myd0pGVU1rYnJrdUJ3Q05WeGJJbGRJc0l6VWFvZmI3SHpaZmE5RjRqc2hO?=
 =?utf-8?B?U1MyYWM2V29vcENiamN3dG9xZEZDN0xxaTY4NHhYMVBENFRsYlIyNk1DbzF3?=
 =?utf-8?B?Y2xwWm1NdFB3ajM4ejlCRVVFdDdodnBjSEM3N3RCUHkxZ1BJZndXVUpCSFc1?=
 =?utf-8?B?cjN0dWtZZkVsSm5hdDEwYzZSczBPY2h2RFpCa0s5RzlZeVhwT25wdjUvanY4?=
 =?utf-8?B?QTRsNWJuSUE4L29ja0F3QXIzc0prQThsS0oxQTFBZkRiODczTmNhcHBYaG1t?=
 =?utf-8?B?aFNkWUVXVE1LSTZFNE5nRXIzUzh5dVZZdkFncFp4dFZvN2dySlJPWDNGN0Nq?=
 =?utf-8?B?L2lRNTlneUhnTytBV1RkSWtJMzErNnQvOGVLQXZBN2RTQWNvaDgrcnBlSFo3?=
 =?utf-8?B?a3l2bGFTMGdqTEQrd0ZOT2EzUVRSaHVJajlSUk1SOXJrOGVxbmpwV09iQzMr?=
 =?utf-8?B?cWxIZEo5UkZjZ2NEU0xRM1k5Sk5QUGd5cnZEMnMwNXZPSW4wM0dLaEZFMlg4?=
 =?utf-8?B?RHJYaWpoV0hNZFd0YnNkUmZuUmU5RVdZeFBVL3Q1Y0FTcG9YVWpQL3RtUnpk?=
 =?utf-8?B?Rnc0eVBNMGdsWEJPSXZLMGR3YmdWWVJtRmR5cEE3KzhzdUFGaGxVNnZheVpq?=
 =?utf-8?B?Wm9wWGl0WXlOQkdJQkkwbzY4L21RMGE1RDB3d0pQU3M0Qm41YU82SHkrdCt3?=
 =?utf-8?B?VFJBQTdHcGQ4N0xRcU1iaGZRbkRxVjEweU9GS2hFRlgrc0RFMXBEMlUwd2Y4?=
 =?utf-8?B?U3FTV0s2MnpZUUNuYUQyQ0pHWFordGhRUjJ2MjZ6TVNGWm5SZFRHVDBaU2d6?=
 =?utf-8?B?dW5iWmxhNEJxdlF5bDl6cVRaeElZVjh3NEtMVUNQOXd4dE02WWpRRTZpRndJ?=
 =?utf-8?B?bWpUaWhlNGRRU2VBcDVyU0t2SUpnPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	X5SVmtB/4yF2n0aRcVOa6ZVx7E7FU3SzF1ZJfTyN53M5pMfM4TwXRC4HsLtfdxvMRGF1Ubo7zQVqcIQhQI2T/HVFBQhMJix0v8JrLOSJQCYDuIwM0dB1EH6Z/AaWSeZiVkDsaoqYXxeVdEN7liJ4eETCPACDreN60DG461ePGZ64YfcsmXSHpTjD5NyRtmKcPrW2WQDRntOjlnp9iJvh1AXQ3CMorq4CVlz5WhrTmLNV6+GHu4Fv9fLmZTmFc0OyEkwVj+vyVDiC6RtbzMDpJxO/5IF0GzilgM8vYJJL20DtVl9GB2agLs0Mnc6Wy+06S/x78J6qfpHv/duwXDxuoNYWguM5l+uq7u4sYCqVubNbB3KETBtwa+ppGM/zcsrHvODXjGVLCsPyk2ipw/vMJ7FiT13koaEiqIMBNT6IrzRnnBkzDWYRWy+/lkNiiCq5
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 03:31:02.0245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aa03b6d-a37c-4ae0-07f8-08de678ba644
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A346.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9696
X-Rspamd-Queue-Id: 38EE1C0006
X-Stat-Signature: hmm8yisme8j7rguapayxzjbb5jpr5ttk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770607872-80538
X-HE-Meta: U2FsdGVkX18FuEkQzla8HYzhhMtU6CiXrLnWiy34X1qffGfEjyUE60RfUm2HmYHrlhzKL6pWgPYM9TlmJ1kYbBRApN3pYAFtiovOWFmORvM7boMVdP/f/nHHYFjMq7duoPsp5qmBlJFxuBiwI4XwTOc5Y9/WH1meK0crU4fWWHTpgidoiohzqAp5BlTlzlQ2dStj2modrfz0LPWjdKHgSj4ApiwPQuedoJYEAF3fus+zZ2G5md6xc3Xq/ZvL7uL92uwLAQUjRM0IzC87JtixtnwFRvtuqTO6RfVuVsqhugke0lK1mv0Bt/PZxmgv1KR4xE1rmK2C0rFp6G5cKhfJSUmmYB68Gd/YVVHPwfYcirt0UrO/JfN1m2k0dzYhpfjj5HGP1H4Zdh9uY7A+OzQoZj56KN/KSWuNfJ7vS+RcQ8dTge+rkt4SYOOGpNyCbomoJakG56r4OeMFI+hwZViUG1zfJsgW0h0FFJiFLUlmuNDB8CIyXee1FyknV7l4Haibk9arM9+qjcelsWbT1qWxHLYr6TcBfSGH9aGZ5m7sn4p6ut3bGCLpnIoUCBMDJvWEgUXGMKs2Pw5Fvr8qtYif2T3iF9sqRmBmB/O1tOB/JhMkL4/HJFOaxwwRcRnIXTh+Fj+Sc+EALROb/n/oODN3OUbua8xklsWcXcwbrEAexoMMuc1bRmRdyETU2wAa5tDEDHru2EqOw31dZft2CcRYe1PNozz3BPUSz5yG1iHusLn8Gje1eFZyGqkZH0cVhnU4ySADxL9FGuW06PBSAJKnC8wypdTA3cimIy6xmZtQzFVmfarQWtMiCnkcgNxzRiZPYEzDKn328owxy4Qxe7jiWwmbZxi1j6Gy/7BLTafIEg/40Vln8a2a2bt987BYURKnAC8157o6+pZB8vot6QlKNsXgjkd7uEpNTDdqJcjgP+UUD8rZ8uR/QVJDupHvqjdidBmrk19GNdwJd5Kmcg2
 RjTS1Xa4
 ULXDcZSSnsn/kDZMhnqJvnyqegCrYXI8LzSjXpJi+pInA8NRQiGkb/lMEeVLcaOgxpu9fdvFIHfawJHxX0MRHOl+5zgw/nM0jalj7dV8SCNM5wVe8wG+38YLGEbvRmFcRmT85oQING/GiSuZzKDWFnbjeE2GMJ+OwFA9sOS7DL7G/HFw6eq17pGw0pbNJ7zwwmJaq0CnkdI6H794qlcnVnOAJtWT8taZNSuUcmx9Qxur4h5M4GMDyXKAlHp/Ur+NzUVsBbdYGOkqi/arIMQc9MWJMA+M2J2ixZAZ5LBoNI5FjPy0e4ic2OjE/FYykjys4s5YS69nrDx+wlLhuEWtNHCG5FGaf/VQDu/tk3oHy2pTT+3txvWNmBjV1s+pyzLOLha0iPLXrdaSzED75fa+IDXiOptXcCzw3AMTqOqWOaLzZIcagHRHVNBa+/NpThdDrXxhA7QsdmRyltY6oKOHH3N8srN3QHSYRe8ukIyhcS39tCjA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29-Jan-26 8:10 PM, Bharata B Rao wrote:
> Results
> =======
> TODO: Will post benchmark nubmers as reply to this patchset soon.

Numbers from redis-memtier benchmark:

Test system details
-------------------
3 node AMD Zen5 system with 2 regular NUMA nodes (0, 1) and a CXL node (2)

$ numactl -H
available: 3 nodes (0-2)
node 0 cpus: 0-95,192-287
node 0 size: 128460 MB
node 1 cpus: 96-191,288-383
node 1 size: 128893 MB
node 2 cpus:
node 2 size: 257993 MB
node distances:
node   0   1   2
  0:  10  32  50
  1:  32  10  60
  2:  255  255  10

Hotness sources
---------------
NUMAB0 - Without NUMA Balancing in base case and with no source enabled
         in the patched case. No migrations occur.
NUMAB2 - Existing hot page promotion for the base case and
         use of hint faults as source in the patched case.

Pghot by default promotes after two accesses but for NUMAB2 source,
promotion is done after one access to match the base behaviour.
(/sys/kernel/debug/pghot/freq_threshold=1)

==============================================================
Scenario 1 - Enough memory in toptier and hence only promotion
==============================================================
In the setup phase, 64GB database is provisioned and explicitly moved
to Node 2 by migrating redis-server's memory to Node 2.
Memtier is run on Node 1.

Parallel distribution, 50% of the keys accessed, each 4 times.
16        Threads
100       Connections per thread
77808     Requests per client

==================================================================================================
Type         Ops/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9
Latency       KB/sec
--------------------------------------------------------------------------------------------------
Base, NUMAB0
Totals     225827.75       226.49746       225.27900       425.98300
454.65500    513106.09
--------------------------------------------------------------------------------------------------
Base, NUMAB2
Totals     254869.29       205.61759       216.06300       399.35900
454.65500    579091.74
--------------------------------------------------------------------------------------------------
pghot-default, NUMAB2
Totals     264229.35       202.81411       215.03900       393.21500
446.46300    600358.86
--------------------------------------------------------------------------------------------------
pghot-precise, NUMAB2
Totals     261136.17       203.32692       215.03900       391.16700
446.46300    593330.81
==================================================================================================

pgpromote_success
==================================
Base, NUMAB0            0
Base, NUMAB2            10,435,178
pghot-default, NUMAB2   10,435,031
pghot-precise, NUMAB2   10,435,245
==================================

- There is a clear benefit of hot page promotion seen. Both
  base and pghot show similar benefits.
- The number of pages promoted in both cases are more or less
  same.

==============================================================
Scenario 2 - Toptier memory overcommited, promotion + demotion
==============================================================
In the setup phase, 192GB database is provisioned. The database occupies
Node 1 entirely(~128GB) and spills over to Node 2 (~64GB).
Memtier is run on Node 1.

Parallel distribution, 50% of the keys accessed, each 4 times.
16        Threads
100       Connections per thread
233424    Requests per client

==================================================================================================
Type         Ops/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9
Latency       KB/sec
--------------------------------------------------------------------------------------------------
Base, NUMAB0
Totals     246474.55       211.90623       192.51100       370.68700
448.51100    560235.63
--------------------------------------------------------------------------------------------------
Base, NUMAB2
Totals     232790.88       221.18604       214.01500       419.83900
509.95100    529132.72
--------------------------------------------------------------------------------------------------
pghot-default, NUMAB2
Totals     241615.60       216.12761       210.94300       391.16700
475.13500    549191.27
--------------------------------------------------------------------------------------------------
pghot-precise, NUMAB2
Totals     238557.37       217.57630       207.87100       395.26300
471.03900    542239.92
==================================================================================================
                        pgpromote_success       pgdemote_kswapd
===============================================================
Base, NUMAB0            0                       832,494
Base, NUMAB2            352,075                 720,409
pghot-default, NUMAB2   25,865,321              26,154,984
pghot-precise, NUMAB2   25,525,429              25,838,095
===============================================================

- No clear benefit is seen with hot page promotion both in base and pghot case.
- Most promotion attempts in base case fail because the NUMA hint fault latency
  is found to exceed the threshold value (default threshold of 1000ms) in
  majority of the promotion attempts.
- Unlike base NUMAB2 where the hint fault latency is the difference between the
  PTE update time (during scanning) and the access time (hint fault), pghot uses
  a single latency threshold (4000ms in pghot-default and 5000ms in
  pghot-precise) for two purposes.
        1. If the time difference between successive accesses are within the
           threshold, the page is marked as hot.
        2. Later when kmigrated picks up the page for migration, it will migrate
           only if the difference between the current time and the time when the
          page was marked hot is with the threshold.
  Because of the above difference in behaviour, more number of pages get
  qualified for promotion compared to base NUMAB2.

