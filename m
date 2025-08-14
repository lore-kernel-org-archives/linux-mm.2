Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 703B1CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 13:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07FE3900170; Thu, 14 Aug 2025 09:51:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0305F900023; Thu, 14 Aug 2025 09:51:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1481900170; Thu, 14 Aug 2025 09:51:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6EA7900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:51:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 927F91DABEC
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:51:37 +0000 (UTC)
X-FDA: 83775500634.09.A0D2E56
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2041.outbound.protection.outlook.com [40.107.95.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9F9A280011
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:51:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Lipka6EE;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of bharata@amd.com designates 40.107.95.41 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755179494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=En4DH7fO2JySYtzsyijxzDN2SB5CfkOTNNwCnytukWU=;
	b=D15WA/NGGM2ztpu4iEkrMNbkeJPTmaNnSKn7l8Fn5IGkViKGDENJfOcNZqISk4GxPXbgZG
	DPuG941+ykXxN/EygaAFOwO7N8dJ5oQ1omsfwmiQ9Rff9Xm4I/KfHES4zSAwVcT8EyZA93
	qVGubH3H2N9TkaLzmVkp9nStqVMvAaw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Lipka6EE;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of bharata@amd.com designates 40.107.95.41 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755179494; a=rsa-sha256;
	cv=pass;
	b=A8NupEWyANZMUodID3hihPY+RUGcU8ux74NtgshxTHmyJmWdz5ngjAJpJQ6bdRXGkedB3v
	IM69hC/+wukYIY9Y3M3uIJL6/yazjCB2Kx6kIDcJDRKbJUn9IdIcRQ1V65vqFH/OY4YjLT
	OEky/XtPVofyT8TFkYYFwMIfxoHYSpI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EszpO1Vu8ZhM+dnzArBVcVtDcBzKRewMo2zGfmGkntLoSZ2qFSORmpQNc2Zk/fEKdnApApzFjvLJUgfC37LvkyNVfkFoEePxDFlui3bqbovZrroVMoMU0UKx4OKyVqOylxzR1QsFtiGvISM506PIyslGHh36bQj3De/QzFF9BMn3wpJbb4JOTc2rrDLU0j8vZZO7MWUL6gIR9csyDTQw3F6bDfWu/biwJkydp1nPnuAkq7xV1J/NmA9fSW/Ry1OE8syuaqVEjpwLgjxK+70a2qDe7fhB8gy+/QCf3KR6xqKYdZA1odPnWbb/xYpD1CbubXij6N3MMaPjFa3r1Hh56w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=En4DH7fO2JySYtzsyijxzDN2SB5CfkOTNNwCnytukWU=;
 b=AKCPniAIreVE2Pboot8JllrVEsLolG9YB3YzWCq4HxF03W6AeN5Bz0OPvPFzYQoogQrgGKPUftDJPxnbjpeG+qEq+Q+X33bfUZcE5eZiq+Z9j0afT/fG5zF2tRaS0B07Niu29FVNgiKKGtv1HkPE31AduDoxRwXj3jtYAgME8RvGfq3XgisaaeV11+Wigo4PZZdmd7VKjeeumSFxu66C3qXzMbRA4BlWey+7kjLSgNEpMcfhKV4EgIZdBM5KRGzpcg1P6vJgWdIKgdTPkDzrSGpt7WHa65SLbAwQrtiPKQ8VoB4r0hQ+VfO7v7yUgzcudmIASaQ8mYKKBIjc/fNibA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=En4DH7fO2JySYtzsyijxzDN2SB5CfkOTNNwCnytukWU=;
 b=Lipka6EE30bE8DwlS1vFpBIHSWcS0PzlfJSW40DvGjcq0QdUvRbYuo1m5CpqJH9wSKw5jbrAqZLRoty/SkoBHmaJsroL5Kw2Vxm9ZLkTYIGQGhb/BZ37qeLonQyW19U8BPZSbTSyjjsg5AxYuh+w7uV1L61uhHw7bRN5oHqBkGg=
Received: from DS7PR05CA0085.namprd05.prod.outlook.com (2603:10b6:8:56::15) by
 SA1PR12MB7246.namprd12.prod.outlook.com (2603:10b6:806:2bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Thu, 14 Aug
 2025 13:51:31 +0000
Received: from DS1PEPF0001708E.namprd03.prod.outlook.com
 (2603:10b6:8:56:cafe::23) by DS7PR05CA0085.outlook.office365.com
 (2603:10b6:8:56::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.11 via Frontend Transport; Thu,
 14 Aug 2025 13:51:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0001708E.mail.protection.outlook.com (10.167.17.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 13:51:31 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Aug
 2025 08:51:23 -0500
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <mgorman@techsingularity.net>,
	<mingo@redhat.com>, <peterz@infradead.org>, <raghavendra.kt@amd.com>,
	<riel@surriel.com>, <rientjes@google.com>, <sj@kernel.org>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <nifan.cxl@gmail.com>,
	<xuezhengchu@huawei.com>, <yiannis@zptcorp.com>, <akpm@linux-foundation.org>,
	<david@redhat.com>, <byungchul@sk.com>, <kinseyho@google.com>,
	<joshua.hahnjy@gmail.com>, <yuanchu@google.com>, <balbirs@nvidia.com>,
	Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v1 6/7] mm: mglru: generalize page table walk
Date: Thu, 14 Aug 2025 19:18:25 +0530
Message-ID: <20250814134826.154003-7-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250814134826.154003-1-bharata@amd.com>
References: <20250814134826.154003-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708E:EE_|SA1PR12MB7246:EE_
X-MS-Office365-Filtering-Correlation-Id: 98051eb1-f73d-4a8e-184b-08dddb39acf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iNLI0aa2Ld1cVSUUvhymNUfMBsj8txAH49ik4NDp4CeiLBAn6h4odoJQPFvx?=
 =?us-ascii?Q?UQxrTKqo0hf5X02HzfPdiGuPsvvmylxI1YsqB0okxkBI/UwiK1OV8hAQtw+3?=
 =?us-ascii?Q?iKv8yugzkl5jVBxuUBFDNykc628vionOv6GDzOaHdDP1pcQb5DSXxvlnAYIr?=
 =?us-ascii?Q?i5tQ5RG0v+Uv1Bx75Fki8z6h2UTEi4N1rd2oZ1hg++/TRm4JU/jPe8vCWMWZ?=
 =?us-ascii?Q?wJHhdZ2stgclb6+2VHoEz1ER/8ne79un9X6rM7WCLKdWiFOlTQkg6+83zPf0?=
 =?us-ascii?Q?qtUZjIAw3P6tQPofKc36i3o+LVYrr00xalqcbVxDaVF+xWIKnnVjvAPn5odf?=
 =?us-ascii?Q?3gT/7JAmj98yiItg35BX55bJ7ZN00IUM/aIa4lZUPaCyDSaGZPmnfKtiZDG4?=
 =?us-ascii?Q?XcHpEi5TWQhVJ00Btp2bbNDTuS+LksVDaeZObPtoNqCtyvEByJFOOWj7tPwg?=
 =?us-ascii?Q?/C39+GsqS7XZE0m2tqki3oogzigX6FTRZXxwgLUpq0DIM8CIXTbz8Cb3WVqG?=
 =?us-ascii?Q?A6hrqJxX6gpWaY4/EiTOvheODwJK8Y7UEtaQiNg2TemtDy//lNjGhbNar0VW?=
 =?us-ascii?Q?U1jhSJ8NT5d99yJg4c39vEpLu+xInIT7KU761I4DudRsmMqHnYGVQ/asqBfx?=
 =?us-ascii?Q?w+7jixgR9ZttEt9Be7cRI5xq+aXwnChPqxL1vLmYHRxhoqOFJsNzEndfDgDP?=
 =?us-ascii?Q?XnsIU4Yrj8cG5Gl7/njRH4CB3NZDMXcuW0H/gjsnLIOVbUXs2o0UCj12mJyt?=
 =?us-ascii?Q?Vx49ArfPWOeOc5eLwAWzQ41/0wHXjKzPQnkINbFPmPep/D46IlG7yOglgG0t?=
 =?us-ascii?Q?D7nh9QiFpLD0LnPHakiBhfl64ncEyrytGnGWSGUJRIeqc4wkj55CriwXQObq?=
 =?us-ascii?Q?L6l8Nvi53zIGSJK97mecSYZOfsf6w1FERo+MgtGf3wMk1K5oi1UwAtvYJAJB?=
 =?us-ascii?Q?dzjLGLC1wRpRy130IcfSXkqazuSs2nI57mhQ69brQpNuES9XlyJp8T0KPkdG?=
 =?us-ascii?Q?5NWDZeQ2YvtHnj9jXK/zBm66/QYZBbtz5kRz2gqGg8Rhx1FdsBLq9e8qxifC?=
 =?us-ascii?Q?ecJCHAI2QlVur9xW7JntRCIZRZntLi5QrT/9YTpeG4Ty+210GZIAVuvjtYA1?=
 =?us-ascii?Q?gneJZHxZw9vtGrbn7tz+ifAFLd7b5KmxQj2SH+0Cbr3nrvnZZCZ/iC4g/+bt?=
 =?us-ascii?Q?uEvGo123M4lwFGuvrmb5Rjn913UaKGzoocXDFKyEh8bjLa6M2qa7ssOU+5aY?=
 =?us-ascii?Q?d3x0olOFabC4LCTNQXMtiyPaZtmHSW8iG4Ar4HOR9WB/Q0URJ5AbjnZFibN+?=
 =?us-ascii?Q?kMahYYCOk1vqj3Sq+OKn4elvIw40Dqq/HWwmly0iXey0UPSibEVGTt9p2LCe?=
 =?us-ascii?Q?TPplO6/1Q7ggU8aEmqrQCvNJGYIGjyhHsezvvPdTg5GK4g6GtZnSQCoIskcx?=
 =?us-ascii?Q?TkE5pAXIp82hmISkCdQcXMRhLzEGybojTIyB/rZLRTbUnKvtw6egomFuK7WU?=
 =?us-ascii?Q?GnKBvNDfzfiqBYqZXqmOvW93foC5zfK4Jy/g?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 13:51:31.7021
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98051eb1-f73d-4a8e-184b-08dddb39acf5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001708E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7246
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9F9A280011
X-Stat-Signature: bqj5t4hhot1f5snwhraaqd3hmtdycuxa
X-Rspam-User: 
X-HE-Tag: 1755179494-899412
X-HE-Meta: U2FsdGVkX19tP/plklQiN5j9OtyuPff5Wxj9Ej7R6he7Lo1RxtvAGMVP3Bgi3q0fJlJXy7ob+T63Z3rCiP8Pq38JxB5mEBMI4l9DdWeZWb/Cj4SKJklFgI0ZUyCeTxMuyNI/UUPNwvRLfcFqlW3nUAfpt7P/6PpRjC585/qoS0NQuyCqFohsDQqw+i3/RCLHM62m9eudyd5HzKjDI0i63cY0O/PZzU3lN7Y0u/9BszP7nWYTYlT0tvl7HOm//J5SqtI4/rMd8AGaKklbT1nAwBgN27gBvpatqlfGNq8KKOzNzWp/X+15xc3cnGvWqzguvXcD5yu2hvONk3l4ERZ8LIMZ0DPAG/DNwYPRcjgcIoD2NyUyuNqP5otS9c1PjtAKOIeud55zOL+Tl3PicphqkDhT0G/AVRbvr7za0PgAd/qFIR18UehDzdLgpbrfU/KqXCad6uPj9DWjBCuz1ykf8MtboKYGwbPx+sUbVJJJYDPG1lRVq4k4YRxL4AW/UhdpiyCJvJo2ZFOMiEHW8J7CWJtTYoNBz90Bm8EO3QVtFo8mrKtTRcdSWjQoNcpAcE77EdKsalq2Q6xD7DdF5MKTXCrd8CzDeIt5kDpPT4E5NLMg+oShxT0UEVQl+na6Y00Nq/cMyLGQ70ZPYP57F666bLelBRvlFISEyp7wt/t6eBBckuXVMAy8kIMp44mHtz7df4X0BIlQOMPqFY9QNgZDAjPWW6CaEQN0Sk1mKRucg95B72gIDmQfZ4/jrtHdgPEMRMImceRs8QHERCKsGdpbJ1L9yOOXDK2AFefO0uhk3nwhw/AXpLzWFm+B/ICU7YsNSdcuF/w35kxiBNa3hcAmGVEwH0obc344oxvxekHuImBujwqXsxT6K6MIcn7xjanA80qLb+zISytUKvRNecZ/gFPG7Up1NlrKERvlVU7tlbWt1ZNQpjklF7Aox2S6Fq33afp2Ghl7L1N6N5f2Hbr
 KOSKD3Tk
 z730PkUKDjf3G4DRnR5WCt9dxgc4IWe9376G3qIFOdKkTGHTRKA3IEjq5OvBIqksY0rGEDfXE7m/acNsNybez988NPTZmKPdZx9eV/hLtCQBa6gxr3K6bKIkMpsaPE7lfKvV1B5UEOE29f+lBHl9R36+eHEDNOq5WALGLGtsMbwOq9NMqSUxaAVNsuV68fVhkbID0cLl9wARZFBaLljh8rrnCmGLCKaESLVizW9JPpuSRxziQx0uAln+8xaOIeyQLDcpsimIUM0Q13oxFbBEoxbYZy8CYNlzfqVsb9C0dl9qEd/lOLi2UGL1Hd80nrTeEDPCVfxwSP9tzMrtOsZdqyZMOPWOxh74//jPyCsSBpegc0s4fIvixG/CmyNTtB5RqVZ5JXQ2XQXV5+DyzqfvpkrLAhzqsHqK8fQ2BRklhakNdr1f3LgxNtyJdjVTQ4KV909AFAvw6EHG12yjLHuU3Z+HOm7SadvHDi/9sIcOK4mn/NlXwYzSKCQ1pCEsp4pghV4DWScpZlAVO3xKimJAVRuyoko4S+j9a/8I88finap8wMnFSNNIdhzuECzZAlp4pfS8hkLtFnGKA2Z/v0BGLk5TWUVxoSmHznKscKHrCMmQpdcMizaj6zs9m+ZgabvR92+8wWJUyRK9DjVxhBdHjRPQ+kw2JLzuoUfe6OIz3h3oX6oYdRyigXL5T2ohc/rDUX9FJaZqTcL3CNVQtk2l3jRDhAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kinsey Ho <kinseyho@google.com>

Refactor the existing MGLRU page table walking logic to make it
resumable.

Additionally, introduce two hooks into the MGLRU page table walk:
accessed callback and flush callback. The accessed callback is called
for each accessed page detected via the scanned accessed bit. The flush
callback is called when the accessed callback reports an out of space
error. This allows for processing pages in batches for efficiency.

With a generalised page table walk, introduce a new scan function which
repeatedly scans on the same young generation and does not add a new
young generation.

Signed-off-by: Kinsey Ho <kinseyho@google.com>
Signed-off-by: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 include/linux/mmzone.h |   5 ++
 mm/internal.h          |   4 +
 mm/vmscan.c            | 176 ++++++++++++++++++++++++++++++-----------
 3 files changed, 139 insertions(+), 46 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index f7094babed10..4ad15490aff6 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -533,6 +533,8 @@ struct lru_gen_mm_walk {
 	unsigned long seq;
 	/* the next address within an mm to scan */
 	unsigned long next_addr;
+	/* called for each accessed pte/pmd */
+	int (*accessed_cb)(unsigned long pfn);
 	/* to batch promoted pages */
 	int nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* to batch the mm stats */
@@ -540,6 +542,9 @@ struct lru_gen_mm_walk {
 	/* total batched items */
 	int batched;
 	int swappiness;
+	/* for the pmd under scanning */
+	int nr_young_pte;
+	int nr_total_pte;
 	bool force_scan;
 };
 
diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc03..6c2c86abfde2 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -548,6 +548,10 @@ static inline int user_proactive_reclaim(char *buf,
 	return 0;
 }
 #endif
+void set_task_reclaim_state(struct task_struct *task,
+				   struct reclaim_state *rs);
+void lru_gen_scan_lruvec(struct lruvec *lruvec, unsigned long seq,
+			 int (*accessed_cb)(unsigned long), void (*flush_cb)(void));
 
 /*
  * in mm/rmap.c:
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7de11524a936..4146e17f90ae 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -289,7 +289,7 @@ static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
 			continue;				\
 		else
 
-static void set_task_reclaim_state(struct task_struct *task,
+void set_task_reclaim_state(struct task_struct *task,
 				   struct reclaim_state *rs)
 {
 	/* Check for an overwrite */
@@ -3092,7 +3092,7 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
 
 	VM_WARN_ON_ONCE(mm_state->seq + 1 < walk->seq);
 
-	if (walk->seq <= mm_state->seq)
+	if (!walk->accessed_cb && walk->seq <= mm_state->seq)
 		goto done;
 
 	if (!mm_state->head)
@@ -3518,16 +3518,14 @@ static void walk_update_folio(struct lru_gen_mm_walk *walk, struct folio *folio,
 	}
 }
 
-static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
-			   struct mm_walk *args)
+static int walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
+			   struct mm_walk *args, bool *suitable)
 {
-	int i;
+	int i, err = 0;
 	bool dirty;
 	pte_t *pte;
 	spinlock_t *ptl;
 	unsigned long addr;
-	int total = 0;
-	int young = 0;
 	struct folio *last = NULL;
 	struct lru_gen_mm_walk *walk = args->private;
 	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
@@ -3537,17 +3535,21 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 	pmd_t pmdval;
 
 	pte = pte_offset_map_rw_nolock(args->mm, pmd, start & PMD_MASK, &pmdval, &ptl);
-	if (!pte)
-		return false;
+	if (!pte) {
+		*suitable = false;
+		return 0;
+	}
 
 	if (!spin_trylock(ptl)) {
 		pte_unmap(pte);
-		return true;
+		*suitable = true;
+		return 0;
 	}
 
 	if (unlikely(!pmd_same(pmdval, pmdp_get_lockless(pmd)))) {
 		pte_unmap_unlock(pte, ptl);
-		return false;
+		*suitable = false;
+		return 0;
 	}
 
 	arch_enter_lazy_mmu_mode();
@@ -3557,7 +3559,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		struct folio *folio;
 		pte_t ptent = ptep_get(pte + i);
 
-		total++;
+		walk->nr_total_pte++;
 		walk->mm_stats[MM_LEAF_TOTAL]++;
 
 		pfn = get_pte_pfn(ptent, args->vma, addr, pgdat);
@@ -3581,23 +3583,34 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		if (pte_dirty(ptent))
 			dirty = true;
 
-		young++;
+		walk->nr_young_pte++;
 		walk->mm_stats[MM_LEAF_YOUNG]++;
+
+		if (!walk->accessed_cb)
+			continue;
+
+		err = walk->accessed_cb(pfn);
+		if (err) {
+			walk->next_addr = addr + PAGE_SIZE;
+			break;
+		}
 	}
 
 	walk_update_folio(walk, last, gen, dirty);
 	last = NULL;
 
-	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
+	if (!err && i < PTRS_PER_PTE &&
+	    get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
 		goto restart;
 
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(pte, ptl);
 
-	return suitable_to_scan(total, young);
+	*suitable = suitable_to_scan(walk->nr_total_pte, walk->nr_young_pte);
+	return err;
 }
 
-static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area_struct *vma,
+static int walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area_struct *vma,
 				  struct mm_walk *args, unsigned long *bitmap, unsigned long *first)
 {
 	int i;
@@ -3610,6 +3623,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
 	DEFINE_MAX_SEQ(walk->lruvec);
 	int gen = lru_gen_from_seq(max_seq);
+	int err = 0;
 
 	VM_WARN_ON_ONCE(pud_leaf(*pud));
 
@@ -3617,13 +3631,13 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	if (*first == -1) {
 		*first = addr;
 		bitmap_zero(bitmap, MIN_LRU_BATCH);
-		return;
+		return 0;
 	}
 
 	i = addr == -1 ? 0 : pmd_index(addr) - pmd_index(*first);
 	if (i && i <= MIN_LRU_BATCH) {
 		__set_bit(i - 1, bitmap);
-		return;
+		return 0;
 	}
 
 	pmd = pmd_offset(pud, *first);
@@ -3673,6 +3687,16 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 			dirty = true;
 
 		walk->mm_stats[MM_LEAF_YOUNG]++;
+		if (!walk->accessed_cb)
+			goto next;
+
+		err = walk->accessed_cb(pfn);
+		if (err) {
+			i = find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
+
+			walk->next_addr = (*first & PMD_MASK) + i * PMD_SIZE;
+			break;
+		}
 next:
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
@@ -3683,9 +3707,10 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	spin_unlock(ptl);
 done:
 	*first = -1;
+	return err;
 }
 
-static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
+static int walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			   struct mm_walk *args)
 {
 	int i;
@@ -3697,6 +3722,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 	unsigned long first = -1;
 	struct lru_gen_mm_walk *walk = args->private;
 	struct lru_gen_mm_state *mm_state = get_mm_state(walk->lruvec);
+	int err = 0;
 
 	VM_WARN_ON_ONCE(pud_leaf(*pud));
 
@@ -3710,6 +3736,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 	/* walk_pte_range() may call get_next_vma() */
 	vma = args->vma;
 	for (i = pmd_index(start), addr = start; addr != end; i++, addr = next) {
+		bool suitable;
 		pmd_t val = pmdp_get_lockless(pmd + i);
 
 		next = pmd_addr_end(addr, end);
@@ -3726,7 +3753,10 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			walk->mm_stats[MM_LEAF_TOTAL]++;
 
 			if (pfn != -1)
-				walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+				err = walk_pmd_range_locked(pud, addr, vma, args,
+						bitmap, &first);
+			if (err)
+				return err;
 			continue;
 		}
 
@@ -3735,33 +3765,50 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			if (!pmd_young(val))
 				continue;
 
-			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+			err = walk_pmd_range_locked(pud, addr, vma, args,
+						bitmap, &first);
+			if (err)
+				return err;
 		}
 
 		if (!walk->force_scan && !test_bloom_filter(mm_state, walk->seq, pmd + i))
 			continue;
 
+		err = walk_pte_range(&val, addr, next, args, &suitable);
+		if (err && walk->next_addr < next && first == -1)
+			return err;
+
+		walk->nr_total_pte = 0;
+		walk->nr_young_pte = 0;
+
 		walk->mm_stats[MM_NONLEAF_FOUND]++;
 
-		if (!walk_pte_range(&val, addr, next, args))
-			continue;
+		if (!suitable)
+			goto next;
 
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
 
 		/* carry over to the next generation */
 		update_bloom_filter(mm_state, walk->seq + 1, pmd + i);
+next:
+		if (err) {
+			walk->next_addr = first;
+			return err;
+		}
 	}
 
-	walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
+	err = walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
 
-	if (i < PTRS_PER_PMD && get_next_vma(PUD_MASK, PMD_SIZE, args, &start, &end))
+	if (!err && i < PTRS_PER_PMD && get_next_vma(PUD_MASK, PMD_SIZE, args, &start, &end))
 		goto restart;
+
+	return err;
 }
 
 static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 			  struct mm_walk *args)
 {
-	int i;
+	int i, err;
 	pud_t *pud;
 	unsigned long addr;
 	unsigned long next;
@@ -3779,7 +3826,9 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
 			continue;
 
-		walk_pmd_range(&val, addr, next, args);
+		err = walk_pmd_range(&val, addr, next, args);
+		if (err)
+			return err;
 
 		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
 			end = (addr | ~PUD_MASK) + 1;
@@ -3800,40 +3849,48 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 	return -EAGAIN;
 }
 
-static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
+static int try_walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
 {
+	int err;
 	static const struct mm_walk_ops mm_walk_ops = {
 		.test_walk = should_skip_vma,
 		.p4d_entry = walk_pud_range,
 		.walk_lock = PGWALK_RDLOCK,
 	};
-	int err;
 	struct lruvec *lruvec = walk->lruvec;
 
-	walk->next_addr = FIRST_USER_ADDRESS;
+	DEFINE_MAX_SEQ(lruvec);
 
-	do {
-		DEFINE_MAX_SEQ(lruvec);
+	err = -EBUSY;
 
-		err = -EBUSY;
+	/* another thread might have called inc_max_seq() */
+	if (walk->seq != max_seq)
+		return err;
 
-		/* another thread might have called inc_max_seq() */
-		if (walk->seq != max_seq)
-			break;
+	/* the caller might be holding the lock for write */
+	if (mmap_read_trylock(mm)) {
+		err = walk_page_range(mm, walk->next_addr, ULONG_MAX,
+				      &mm_walk_ops, walk);
 
-		/* the caller might be holding the lock for write */
-		if (mmap_read_trylock(mm)) {
-			err = walk_page_range(mm, walk->next_addr, ULONG_MAX, &mm_walk_ops, walk);
+		mmap_read_unlock(mm);
+	}
 
-			mmap_read_unlock(mm);
-		}
+	if (walk->batched) {
+		spin_lock_irq(&lruvec->lru_lock);
+		reset_batch_size(walk);
+		spin_unlock_irq(&lruvec->lru_lock);
+	}
 
-		if (walk->batched) {
-			spin_lock_irq(&lruvec->lru_lock);
-			reset_batch_size(walk);
-			spin_unlock_irq(&lruvec->lru_lock);
-		}
+	return err;
+}
 
+static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
+{
+	int err;
+
+	walk->next_addr = FIRST_USER_ADDRESS;
+	do {
+		err = try_walk_mm(mm, walk);
 		cond_resched();
 	} while (err == -EAGAIN);
 }
@@ -4045,6 +4102,33 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	return success;
 }
 
+void lru_gen_scan_lruvec(struct lruvec *lruvec, unsigned long seq,
+			 int (*accessed_cb)(unsigned long), void (*flush_cb)(void))
+{
+	struct lru_gen_mm_walk *walk = current->reclaim_state->mm_walk;
+	struct mm_struct *mm = NULL;
+
+	walk->lruvec = lruvec;
+	walk->seq = seq;
+	walk->accessed_cb = accessed_cb;
+	walk->swappiness = MAX_SWAPPINESS;
+
+	do {
+		int err = -EBUSY;
+
+		iterate_mm_list(walk, &mm);
+		if (!mm)
+			break;
+
+		walk->next_addr = FIRST_USER_ADDRESS;
+		do {
+			err = try_walk_mm(mm, walk);
+			cond_resched();
+			flush_cb();
+		} while (err == -EAGAIN);
+	} while (mm);
+}
+
 static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 			       int swappiness, bool force_scan)
 {
-- 
2.34.1


