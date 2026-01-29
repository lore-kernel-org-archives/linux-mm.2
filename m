Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0339D6101C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 14:44:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 308546B0096; Thu, 29 Jan 2026 09:44:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DD076B0098; Thu, 29 Jan 2026 09:44:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AB6A6B0099; Thu, 29 Jan 2026 09:44:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 087066B0096
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:44:46 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D460C1A012D
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:44:45 +0000 (UTC)
X-FDA: 84385272930.02.05BBB13
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012062.outbound.protection.outlook.com [40.107.209.62])
	by imf11.hostedemail.com (Postfix) with ESMTP id D19D940014
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:44:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="07Kvx/dz";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf11.hostedemail.com: domain of bharata@amd.com designates 40.107.209.62 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769697883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u2OkrMC7qdJVfZLoWONgXxDemyug/hm/5RsPwgSfGz0=;
	b=hsqlP2Y8pTdWf5Le90KfWpqRgW+VRnDHV1xoee+qpvTBVVo9LpxStMKkVV5H5pMczJ8ZoJ
	W3eEwqGCtx+bcavIq47ZrngaY0kyre3xh3ZUP6Gq5HQvgS/SAfVGmZliIleBvHBPxmPnM4
	Xg5KRvaBDjfhnUYkPNCoFxngIacxhoA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769697883; a=rsa-sha256;
	cv=pass;
	b=kPJnMql72IYGPTgrLzBUESJmSkD+OjEl1gINfCti/M8D/UzqXVM1jjsWdw1XYc87vlcbHZ
	lBEwKb4rzHeTk065DPGnesRD7tBbhPw9yDWCfzcSYxIalH4I+NQGUaUMC4j0uX/lnzj8v4
	x8Ps0AAoJCx0sHxkwv9YEHksj9Z9sNU=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="07Kvx/dz";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf11.hostedemail.com: domain of bharata@amd.com designates 40.107.209.62 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IWNZcQxJoVIRE50jAhDJCW2YA529dGC4J1kTBuwNO0iFkeAHWUXSXIp647VBVQtledjVddI4/3sBAjcybuNE3uJ123aInut3aLonv+Ufve8MMrDbKpak3xZ2pX5i41n0IAaxdTXtcLwvsQl+P5s9hBj6moFMTVCA+vcePCMtWDN4bGuU97AEKJlLSd1X8to64y6Nz9BFe8yWrFkrW83qpZYx+/b4o6vT7ClM1dHeKQf6mVHzNPrZs5syxQYWN7uzNlmesksIUDJdRw74FMwPEK8OYHCPhva6VQ6+Sm770Flw2RV9J0jzeFHrdjyLFJNB8aYpSQe75b9NygQSWtpViA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u2OkrMC7qdJVfZLoWONgXxDemyug/hm/5RsPwgSfGz0=;
 b=whRzcZ9cqX38VhbvicEbtCzhRWhYVbnh+857BssNdmpACO8/rU7vP9603izV2Bi0WF6oDMooHZjX8QksbxHa3TQf9fKTpdbYMxTIehT5hFTBIqQY5sg955fdY45VDgoKtW16ITPMHR/PjZQCpahtOXNyowB3kNHyuwvNHKMVRIZDDOrSkfw3A6mBuQCNsFRMDcyZuhKWaYXP0dTFkgFR8EYn5GFtl0S5/FTZjenkOGfK7m0urcTDRK6SA0ooqkHY/0ibZlZQI+42Ok8ivXeoCFXm7N4SqTOHAGp1iSlWlemgPfIGK4LeDAG1dkKZaRZpUrB5VCPPGqWa/Feeg46ASg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u2OkrMC7qdJVfZLoWONgXxDemyug/hm/5RsPwgSfGz0=;
 b=07Kvx/dz90m+bYsYGDsLK2E0v+SSXnDaBKsy7a/tCdfeu69IbZ/s9a1G6X7DgNrGYTAzn1965jSE+A4icWKh0ec/4prxAs9f+gFxbEtTTaL5w2fm/VBm/Yvorpyk2RWzQlSUNdpDB4n/qrOlvAT0v6FwZZEx0OPY1cZnYsJcLY4=
Received: from BL1PR13CA0367.namprd13.prod.outlook.com (2603:10b6:208:2c0::12)
 by CY3PR12MB9556.namprd12.prod.outlook.com (2603:10b6:930:10a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.10; Thu, 29 Jan
 2026 14:44:35 +0000
Received: from BN2PEPF000055DC.namprd21.prod.outlook.com
 (2603:10b6:208:2c0:cafe::8d) by BL1PR13CA0367.outlook.office365.com
 (2603:10b6:208:2c0::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.2 via Frontend Transport; Thu,
 29 Jan 2026 14:44:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000055DC.mail.protection.outlook.com (10.167.245.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.0 via Frontend Transport; Thu, 29 Jan 2026 14:44:35 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 08:44:27 -0600
From: Bharata B Rao <bharata@amd.com>
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
	<shivankg@amd.com>, Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v5 07/10] x86: ibs: Enable IBS profiling for memory accesses
Date: Thu, 29 Jan 2026 20:10:40 +0530
Message-ID: <20260129144043.231636-8-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260129144043.231636-1-bharata@amd.com>
References: <20260129144043.231636-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DC:EE_|CY3PR12MB9556:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ede1100-8178-45d7-a409-08de5f44ec02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/ytA+7EjjwUGJxmAfncte2N8PLj2VpJ/O8x8Nb2aeuE++8Vjecnx0+VPg2vV?=
 =?us-ascii?Q?d9EePBdiHk1Zs5F5ua67rNV0qEdLzI4DjOzBW/2h1Hvq11hEWT4EuNvt8M/G?=
 =?us-ascii?Q?Aw6NANIr/7XA/POa8OtQPR3XW9eWCSi7WC6Tg/vfAiZ6gQ2at4HF1UdO0WJ1?=
 =?us-ascii?Q?af8VRtHM0MOz870HqhrR1VpvIGf7/aV/m5EvKPBrDgbpmy77Mb4uvFbvCcsF?=
 =?us-ascii?Q?dk4QElNdCVvfqUcrzGudc97tvzZs0Ifx90oWhFH7+v/fBh/LXWZkGgnUFZnW?=
 =?us-ascii?Q?ZgiveR7WawMz8t2ME1aUS5S1G9lCi6KkyMQPyu+/RTpo6eEpium4kL7GlHzq?=
 =?us-ascii?Q?v77goYeVuQoLLXb2NFI4PBX9ezkntpD2FEFJSpO+gPV/93KS3qmaAWaBa/nQ?=
 =?us-ascii?Q?lw/dmih0LkHEwE2yZat2AAXohEoHnwjgn01VzY/eIez501/08I9K1Enpig2X?=
 =?us-ascii?Q?xWA+wfX4el9mcntD+/KeVnmD8ZfcHEX7ap5CJKo+VNwyiT71nRpP4LAGzH5Q?=
 =?us-ascii?Q?lu0YTEmWcTuHvedvSEnBfJZf1gRdaaOr/nN3HcGtcuCFF6UMGHlZbLTmDYdx?=
 =?us-ascii?Q?29lidOZu4l7A3/u2lzkH7s0KHRbHSnRMBimYLMLPBhHNPxE6ddAeWN3Ptl5i?=
 =?us-ascii?Q?hNN3xNk0P5niO6v8rbkUDvbWZERJ+ppXvnyd15cgkeTS66Zwy2PKouimqdk6?=
 =?us-ascii?Q?LcPQygqufR5UIl650xHbjpxasmlRMW1+wye/Cvhuuy16XZ3Vggx/SFNd6Kr/?=
 =?us-ascii?Q?1o1zZIFchMw3IifiuRVRJnDCWhqkqY8q7UdAezgddLtVVk3KZKSZM5wUzTn7?=
 =?us-ascii?Q?M9QR/VHuoELt4fwnWD2aVKstv1He7X9phppTfv2p3gzj/5WXQn7NGhII/Sxs?=
 =?us-ascii?Q?3FErlMCZmu+CJUfjA2aNJfW5Zdo+UJFlEkYc5+XawlLquxi7nEoyZNLG1tTv?=
 =?us-ascii?Q?DBa7uw6YI3AAhRewQ9qsFpX/63ZKOzjZKUCZnfkiN6bpoa5STisflehW5Hcc?=
 =?us-ascii?Q?a5wM9PMnX5deSoZ9PgONRUM9VnXueurMJjgg2bU7o2FRgbZ00eEsPzvtABWS?=
 =?us-ascii?Q?uyyJ48uZPSSHYOXLUdweXBIEBMF9PJ6B37CAhyi3df7hCJHoF+WfxaAijUrr?=
 =?us-ascii?Q?iEqdek9dvDv8s3xYkkfZjmbWUCv7i3Deea+tfw4sY+lGzQM7EoQvmtpZ/+T+?=
 =?us-ascii?Q?3qgkcDC4crrV99x/tX4uVwZfnbaPFzYsPukJHvRDRB1XpG98R0Iho1pdGxXT?=
 =?us-ascii?Q?x89vjWEjRwV9VuR7Ii12/V1k3zIWHUdSGNmXzKv5UNlJJg8JwOAvqs3obHsx?=
 =?us-ascii?Q?BDzlJosqv7n7DW9Abpab3je3/YUBLvhQ6gJEZA8ZQzV1Hk+OTfoEhTHYYPUt?=
 =?us-ascii?Q?1CctduQCgUN2ZY6g/pPkWLI22cbhvluY+nXB835bkm9KUFg0Qje09Xbo2EUg?=
 =?us-ascii?Q?Glacfz5LBp1Fa1lwTL/LV8aLA6PwNHuGj6F++/WULKQMbUQUgysGKBHWvWjo?=
 =?us-ascii?Q?YIdj7c/yLAWXiMljhW1lg6V2WKlXqdYgSDJv5dfpxp7GyzBA4GbAxaeTnBpw?=
 =?us-ascii?Q?Q/aavlAdzLNDQ+YT31giYI/pFqmGev/coXBi33W1YOhE86jOPCnxhU0vJ0I9?=
 =?us-ascii?Q?CRlHTKYB3AMtIdioSWmH1THLnGnbaDeRTz7+r/yC1HlmoSnHgyUgVgkMqe1i?=
 =?us-ascii?Q?gc3vjA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 14:44:35.4772
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ede1100-8178-45d7-a409-08de5f44ec02
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DC.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9556
X-Rspamd-Queue-Id: D19D940014
X-Stat-Signature: rwjyiochjcs6umjxsh4k8kwmtwzwagjk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769697882-434674
X-HE-Meta: U2FsdGVkX1/PoH6JaHXcJrKNhVqXWq7W3FIWr3cexnmDKpW86FHt+WCWZfnBKPylBmT+/4Dpw4QqAITIHus85ltgLRGeVDGZU/zwCdhgl9PxvXdpdWIzfU8DRMGwlE9cHG5ZdTptEgiRTyLmKkeoC5CUWyBcBOuUHZfpJgzAI3uvthBYcx1uIg7BSuDtMtRYU2sjhttB6kqEJtUPZN3qBtnu5rTjpTZ4l2gXIIm5fmDOJvdv1jajAz54wl4zzYp1FAvQg/BEjNA/572yzW93pKC/nTy1RLGg9vF8q9cTb5Mm+gNpRWT4nQZPJmrJkNuI72uVI5VW9u+8qcVqeDIimXAIB5ItjjdLooNAOGiJtipyyZVukrh3Kbnzg9BR1oyASW+F6X7+Pk25oWvbUI+OkpHJcnMNneUDk22W03K+FT+DYL7rOL7kv85JUErCK7qaNVZ1PfRf0iriEytgbQAdd9+T8x4XwHISbpsZlcU+oYi7XS/ZwS1c68jkQ1A+df+visIPJVha+hMDQX1zQsdcpWrMQBrMOybdu3j8TgzGAXaj2hI/bDlMaZ7QeMdCJvW9MvMRYGLBUw49/8mqmxOLTjSzJIDsnlt9SmJNNeELYcWWHu2rGdfVVFP5UqTORgsSPXwuLEWvAAe8UVNedVo6ZprPs6HEjbNU6CYHl/adNsdnwCh11iHdXMaf+SA9imCFOoMMK+dQinfzJ3rQBf6XEUJ7OL/pHlki/3y938hNXRGBFFuI7teLH2CTN6Gvnb7c4XPfIa3gIv9py7aIZE5US8bjl6imVjkq29WTham8kUVsZsP0yqzc8LF2X/8VCpABR3vQUyVQdUrjNwtdp7gROAJThmEg1K4zq3OOJO0FFpy9l/sUnJVxY7CX2KCy/Mn9SaYJ27jx87XW38jx7iHmHPA/sdVtryuGEKH4yde+m8Szq9gwlH0w/aMjIbnhTUQxFswXhlm8jtPO9qkdIGV
 dux7J6wm
 4ipAw7Kljl6t1jJEyuheJ2pbsdFL2JV9fG9jpSD3rfR6AKcLC5FFQUyeb+vqDX7s1IR6vTPHLFMFJyemU98X6Jl2DZdqdHYqp5XTwHDeMig3+z0twXUs5ETBO9xAaARUJOO8L4rk1uN86ouN2w2n0J7EciwrK/xZCLV+4s8wdl/6+hOLqkiZwOKs0VJmRwBC7MPd7PXnXk1QmqMNnUgpUy9EyX3hAs9VngkIAY7MIvGKRgBEfcrutH6lamUDKN2KpUxaiU73ynRisKOUsHbeJwzxn+OpQa1clZFEQT8gNafATLREVo5kgry3d6xpmRmFOJ/GxmdSA8V4UNDirwRH1UMiMTfUvvV6WVv4xGzTtCytWMoYVyaKCaBF7kJJmxuaYZccrrAXe8DooiKgl0XfzlXYF8vivMlhKbWkQ20TakLFTtoTNWI0Maccq1ur66lTVpoITJLR2B7gm9GJL5RWhM6/hB50IzYVPqtErVmSU8IH7Zm1DL1yrBNeBZ5oudIr25lLCpLsfnGp6XlI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable IBS memory access data collection for user memory
accesses by programming the required MSRs. The profiling
is turned ON only for user mode execution and turned OFF
for kernel mode execution. Profiling is explicitly disabled
for NMI handler too.

TODOs:

- IBS sampling rate is kept fixed for now.
- Arch/vendor separation/isolation of the code needs relook.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 arch/x86/include/asm/entry-common.h |  3 +++
 arch/x86/include/asm/hardirq.h      |  2 ++
 arch/x86/mm/ibs.c                   | 32 +++++++++++++++++++++++++++++
 include/linux/pghot.h               |  4 ++++
 4 files changed, 41 insertions(+)

diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
index ce3eb6d5fdf9..0f381a63669e 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -4,6 +4,7 @@
 
 #include <linux/randomize_kstack.h>
 #include <linux/user-return-notifier.h>
+#include <linux/pghot.h>
 
 #include <asm/nospec-branch.h>
 #include <asm/io_bitmap.h>
@@ -13,6 +14,7 @@
 /* Check that the stack and regs on entry from user mode are sane. */
 static __always_inline void arch_enter_from_user_mode(struct pt_regs *regs)
 {
+	hwmem_access_profiling_stop();
 	if (IS_ENABLED(CONFIG_DEBUG_ENTRY)) {
 		/*
 		 * Make sure that the entry code gave us a sensible EFLAGS
@@ -106,6 +108,7 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
 static __always_inline void arch_exit_to_user_mode(void)
 {
 	amd_clear_divider();
+	hwmem_access_profiling_start();
 }
 #define arch_exit_to_user_mode arch_exit_to_user_mode
 
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 6b6d472baa0b..e80c305c17d1 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -91,4 +91,6 @@ static __always_inline bool kvm_get_cpu_l1tf_flush_l1d(void)
 static __always_inline void kvm_set_cpu_l1tf_flush_l1d(void) { }
 #endif /* IS_ENABLED(CONFIG_KVM_INTEL) */
 
+#define arch_nmi_enter()	hwmem_access_profiling_stop()
+#define arch_nmi_exit()		hwmem_access_profiling_start()
 #endif /* _ASM_X86_HARDIRQ_H */
diff --git a/arch/x86/mm/ibs.c b/arch/x86/mm/ibs.c
index 752f688375f9..d0d93f09432d 100644
--- a/arch/x86/mm/ibs.c
+++ b/arch/x86/mm/ibs.c
@@ -16,6 +16,7 @@ static u64 ibs_config __read_mostly;
 static u32 ibs_caps;
 
 #define IBS_NR_SAMPLES	150
+#define IBS_SAMPLE_PERIOD      10000
 
 /*
  * Basic access info captured for each memory access.
@@ -43,6 +44,36 @@ struct ibs_sample_pcpu __percpu *ibs_s;
 static struct work_struct ibs_work;
 static struct irq_work ibs_irq_work;
 
+void hwmem_access_profiling_stop(void)
+{
+	u64 ops_ctl;
+
+	if (!hwmem_access_profiling)
+		return;
+
+	rdmsrl(MSR_AMD64_IBSOPCTL, ops_ctl);
+	wrmsrl(MSR_AMD64_IBSOPCTL, ops_ctl & ~IBS_OP_ENABLE);
+}
+
+void hwmem_access_profiling_start(void)
+{
+	u64 config = 0;
+	unsigned int period = IBS_SAMPLE_PERIOD;
+
+	if (!hwmem_access_profiling)
+		return;
+
+	/* Disable IBS for kernel thread */
+	if (!current->mm)
+		goto out;
+
+	config = (period >> 4) & IBS_OP_MAX_CNT;
+	config |= (period & IBS_OP_MAX_CNT_EXT_MASK);
+	config |= ibs_config;
+out:
+	wrmsrl(MSR_AMD64_IBSOPCTL, config);
+}
+
 bool hwmem_access_profiler_inuse(void)
 {
 	return hwmem_access_profiling;
@@ -310,6 +341,7 @@ static int __init ibs_access_profiling_init(void)
 			  x86_amd_ibs_access_profile_startup,
 			  x86_amd_ibs_access_profile_teardown);
 
+	hwmem_access_profiling = true;
 	pr_info("IBS setup for memory access profiling\n");
 	return 0;
 }
diff --git a/include/linux/pghot.h b/include/linux/pghot.h
index 20ea9767dbdd..603791183102 100644
--- a/include/linux/pghot.h
+++ b/include/linux/pghot.h
@@ -6,8 +6,12 @@
 
 #ifdef CONFIG_HWMEM_PROFILER
 bool hwmem_access_profiler_inuse(void);
+void hwmem_access_profiling_start(void);
+void hwmem_access_profiling_stop(void);
 #else
 static inline bool hwmem_access_profiler_inuse(void) { return false; }
+static inline void hwmem_access_profiling_start(void) {}
+static inline void hwmem_access_profiling_stop(void) {}
 #endif
 
 /* Page hotness temperature sources */
-- 
2.34.1


