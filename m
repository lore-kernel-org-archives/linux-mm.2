Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8740CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 13:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781D890016D; Thu, 14 Aug 2025 09:50:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70B37900023; Thu, 14 Aug 2025 09:50:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ABFB90016D; Thu, 14 Aug 2025 09:50:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B1C4900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:50:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB8C583456
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:50:25 +0000 (UTC)
X-FDA: 83775497610.24.EEEF447
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id ECB8FA000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:50:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=sIfdKU13;
	spf=pass (imf25.hostedemail.com: domain of bharata@amd.com designates 40.107.93.42 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755179423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s9+5mRB6bgvZIabzF/2Xq6EpKmpwKwOpZSLTl4DSVMY=;
	b=s8carSDjji+ISrVQmghbovUf9xhh5XN38t/mF2BrB3kUGc2MvCCDkO+Ryv/Fry0YoJ2hZG
	wGc1ZxH/PvTOrhe8E1v6Yo/+1zxK493PcOcfG+VTLpClZlbB1zG5GF24+W/Ji0yxpYSh9W
	Pu/A0AywtLDbMBdrah2KYIiPUopi7EA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=sIfdKU13;
	spf=pass (imf25.hostedemail.com: domain of bharata@amd.com designates 40.107.93.42 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755179423; a=rsa-sha256;
	cv=pass;
	b=SLebzlzD7J4w/Gz6rH0txe5Vts2qD/+9wfcOeZb0EYNLuZrLo3XSexz0aELSBhTqojsNI2
	jYEgixCqzk2r5xywXyuXifkKvigUWD2ZqfAcWDjI7mwsOxvAWEpsJ/uG/Uyicaexk5podu
	4C9K9+fTLBTmnViO/hcDan9wjhwggfk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I0EDHHH0X1nDmj0O7KTRRGNMdme//GIDw7P7DsY2J2zb7xKcKYTIUsv5DSu2Rjp6n2ljjTrbZw34S/mbaIkVyMe5IR/9fykzM+6+M5qHcksUyXy2AswCe3q1g67faEBc3efNtHouX20imXFHWYPe4e5W63GfGW0x7OwBdv3xwoHoljdHKGfk2ZKc5AkR/m05L+Yfei6LT4dekJHUP2CC8ZX828a50fO8OSZ4uS/y1OmWx8VSQHD9dMMF9jWEv8qUG8Goyh8yVTfvmm8874CpdOkQRjLMJBHBT0fjaheIQpdLyrpfCLtOCfjl7qvsFtUX4PPPlemNx0Z2D65Bgsraug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s9+5mRB6bgvZIabzF/2Xq6EpKmpwKwOpZSLTl4DSVMY=;
 b=nkg74XE1kZEuMsIEhQ1ZLJZgMKseq+rN3ty8ywZJ6D0ssy8WyPwYalvaspc+Z6NQ130iYOHLwPNI7LiLBclZCC/xxDPWtQ3vS+F1pMDMAnou25kAWgNDMIfQzQOBhGMxrDYfZ1KhrF3uS81Fm8J0X3S3Y3JkOK+IgjVfyQOJw7IaUTtYwpzh5dePtFw8TCkyPa6a1vqamxU7VVBypPpiqZ2nXtwmKw49jqMdc6MOLGjqMTHOyKxRhKttowvcZaNCXFvWNBg6jtUL4g8p8D/9XfCLsLHrVPjTstnIX50xBqnKQx+xq4y2LsmBsUTAHjTEoRbeThrcL6A72Cth6yZo4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9+5mRB6bgvZIabzF/2Xq6EpKmpwKwOpZSLTl4DSVMY=;
 b=sIfdKU13bz9iIQ7pADMPXu3x4xkudzkvccZj6Sfv+cEhqooKwV6aBGPsEZQh4Z+KY0e4kk0yBoaB8C2SISBXvAVzPdHiSHdzSytIBe1yXJI2amcLPQev1Il5ox0a6bxErttMqQapZZka5SZ+rPDZT9npZl/8L8tGr5kUuRSHgEI=
Received: from SA9PR13CA0152.namprd13.prod.outlook.com (2603:10b6:806:28::7)
 by CYYPR12MB8752.namprd12.prod.outlook.com (2603:10b6:930:b9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Thu, 14 Aug
 2025 13:50:17 +0000
Received: from SN1PEPF00036F3F.namprd05.prod.outlook.com
 (2603:10b6:806:28:cafe::ed) by SA9PR13CA0152.outlook.office365.com
 (2603:10b6:806:28::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.6 via Frontend Transport; Thu,
 14 Aug 2025 13:50:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3F.mail.protection.outlook.com (10.167.248.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 13:50:16 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Aug
 2025 08:50:09 -0500
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
Subject: [RFC PATCH v1 3/7] mm: Hot page tracking and promotion
Date: Thu, 14 Aug 2025 19:18:22 +0530
Message-ID: <20250814134826.154003-4-bharata@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3F:EE_|CYYPR12MB8752:EE_
X-MS-Office365-Filtering-Correlation-Id: a839ed29-3af7-4409-81d0-08dddb398056
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PqHenLXb6TMdoGiL4TuGc9TeqiXB+nX83eJ4UksHUBhKETNavBtziGGQVG2B?=
 =?us-ascii?Q?1BUXl7E54yZXhqZ+iORNiX26MamqU7me90SRJ9s0SL2iQ3GbTA8UYd2dZ4Pt?=
 =?us-ascii?Q?96Gu6sT0es/Yud9e/SfBDFGJ6qW45CxlZvKW+CJOxUKWLXrbNC/Yr7JR7dzt?=
 =?us-ascii?Q?K9+zVRqV5Yijri5F2n3ftvUbS6h0YP+cQFcxqbuNwr4JZq9FOj1l1wulmpnL?=
 =?us-ascii?Q?h3qAm0i0GdjUUJVzCUm8Ezj/2/7Aucv3fYZ7COv6tbD8E+lA0NDBpXoeykR1?=
 =?us-ascii?Q?fiN9BwwyClbZRHxSYXbag8e11nFBk9kI3W9eZDJXh66JQsmhrgJmvOoswEzR?=
 =?us-ascii?Q?p/IU8NQZxjKlvcrUz1YrzC59UeXl0JCxr354yo+V5kyTJ9ybcdN9GT6VTez6?=
 =?us-ascii?Q?YUFWzeaRwoqXsnhRPz4w2g8P2rfE0+maO6OHbwBL/FllOPrsqGaz8DiqNyFf?=
 =?us-ascii?Q?cs+uvlfVLSPPKb+jqVEzVNprJbQVuIhL5vFgCQyUD5TPFvEgeypk66EuMOlK?=
 =?us-ascii?Q?WTTQ6VTff/0NK3+PFpS5ejG8lUO5bb4Y+b29O9HSzCRCf7+DBSRAk0bU7jV2?=
 =?us-ascii?Q?EGv08cqSID3Htikp5fVaQ3BuPELyFRcNbyY2PQQqg6WvDa2snoiFe/icOe3D?=
 =?us-ascii?Q?B1rd3LPxS7gd+oZvSRjKi6oAVLKOZUxwBGZmAcY65lWr0DdVjEsQBezNcw9u?=
 =?us-ascii?Q?WNZhApyJMFpQX75PDJo1u083ilW+PLTQRh6OpC7anA0p4ZSdwChVVHqNi7m1?=
 =?us-ascii?Q?Cb8t3TcSpT7NeOLf7y2PdIr3lBdsIch1nJ0hN5a5xFCbg26w8x5AIqI+p0py?=
 =?us-ascii?Q?4u/EEYffhh3JAMd7GEsQlf+ocg8opS4vXVqFLNrpcW8i6fjGeC3rooXazv27?=
 =?us-ascii?Q?auYeG8cZcY3wbUcxgaNE00RROp5e8inDntOmu4/d/1T4Y928kOuVvnzBuKpv?=
 =?us-ascii?Q?Jm2F+VzGXgaGlFg5Rzzn+S4rtYUvILZjYP+XhIMN3gbaOuT7+8/uo086Y5k3?=
 =?us-ascii?Q?lARtQnYwzsdUcwNzFI8mlT84h6as+pdDiCXf12s4GUfAQFwJFXE6LHIf6M/u?=
 =?us-ascii?Q?RzaoKAa3/rK0nBN95XOJFqu3wG3DZzGxd/UCLWG962jle/i1ZchwYXe+dMWW?=
 =?us-ascii?Q?cYd4URznt1m14SoYMui9uLychpC1TRa7y+weXaBu4d7aY3g5m2X20XSv3FUl?=
 =?us-ascii?Q?F3Hl6NLHUMcnmNVDrwfh3cAYdkyoXhwGXF3O8dWGMBfJ9e8q7xNyxCLd8qXN?=
 =?us-ascii?Q?xP2STWggRuF8Hjm86KtrFOMqTXaUrhNBzcXZZxfs7ljW9LkE68uwIpknN8GJ?=
 =?us-ascii?Q?XmeHPdvUUHZQ/n0Y3l0GsxmotgRBQdVBC+AnWc78elPwyaAWDCcxo3LQlx4y?=
 =?us-ascii?Q?5WTd+jW+KJQ915/yC9RC9I71Bzv3GTtyXpY5MieBqvIZqNfzKyESVFNNtLMX?=
 =?us-ascii?Q?btDZxJXp5Ot9Q6sGsx19Y5Yy7klWWOb9PMYMvUY44xdKRiGPo/hiQ6TV4H2C?=
 =?us-ascii?Q?O5hUDLEEDG0f/bLDb7j65Rl9/DCefY2jZTs5?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 13:50:16.8544
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a839ed29-3af7-4409-81d0-08dddb398056
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8752
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ECB8FA000D
X-Stat-Signature: bqhen1ng53abhhjr84q6sfm3p5suyq81
X-Rspam-User: 
X-HE-Tag: 1755179422-657161
X-HE-Meta: U2FsdGVkX19ShTbLbYh4smSanl2J52z5McBr2ThBJR3IMqh4BGvnGeXmUoYBz9IAg6Gu1EOZtZQWNxoCQ2XRU+OKItdpq74zhAU5wjocdQV/oMqErNmn9qvbeONhwKVO2UJD8cc2b+DW0F8//qo0PDEQdauHLFc230xqr++9n/G3pqEMxn9bIa/duiMlcqlRStOE+iGnJ2Xqn9tc+rZ6DCdCmFf53wIYV7RNH9v1MwlHOjnU69dNN4mLeUTsFE5r0YhD5Je2ZR8OGlT1/4LcBy7QsBR7y2N8F7QPCya2/BpGlklumJIljn0rEChEf3Y7qiOyPv3Ptm/GtQdWdFFlBKZb3gfmnbtyQqxCfoDwOJ6SHlzD20KoeSD5xMtINfQaFpweijIijmMBbsUMzR+daV3wsLdknf3Fd3rg39bG5oGfAbTpoD96DG4aVYmofCMscztj7AdglHP7XyVwa6DKHKhW2zuTvrf4qC30hfLnk+CZ8oSNK/wGyNq0E2WLXlYhldncoud2o3HWr7fEkLzjtc/JIFCFCWKZWL4VquBmiCrAxQYMDRFzsTyvnFc03KgE8KfeoP8NaMI88zwRnJQyuz/46iL/8F2wxyR4fpeT7vHCw49FBW2Mhe8TEe8tUos1iUB/Jr4xQUCfjAcH3tA8zQkDi14ue6/LA4qjEvp5ICYkiWb+bPPrfEFB1lVCg0iRlQR4yWwLgQfrmNTsXgllGbdnYSzPwl/c5mLEZSPnN3YAFXZF3vrOJUFgHKiEKyvX7vW/NOJYqn/BUdNZ6ocan4bVfxm6/zlKkPg3R/x7OyTjwANZSuYTNiaCHA919g1/c1Q2e+ePlqWCYPIJ74/8R4xY6iCCmgVqhB2wFuSIWhj4XTg6q9y0qiJEx3xz1oOXehj6Z9eUJkr/g2NLNpGkqFGF6M2ZfXqaIopxA49JnDlUbuSU8dyRHp2RUaV/8N4EZ6VqlyVJ6zpW0sLP9q6
 4h4xdGM+
 nXSl2RNvQysCyMfQekIxX4p/nmezJr1LP1iVdVlWJh+sNFpsoG8hMWL/kFhVI2pnHVbGDCZ3nOszceWSmXXBJHp16MbLvNZh8d+vW1aGhpegqvP+s5DHGvBwYD9jrk42VFWlj7eiXyXGoNZ+7uwSJxIfM9idQucs6839/o3p7kLrbtX0F7qZiirKvk/LHoLzUa8KHGw18++koVm+5U3DoduddCx6/h44tURJMRr6g+fcsIxXGOGDa7i5q4/6W/NCoFmv98sgy+0xNiXaIt/ewEtKdXxYa9itXw3WpA3TIEsGlJsMaD2Gf1yXaLV3cOcN+wNOmcashS/CCM/7mazoFQykZmpwykux0oZx6tYgYWUYfcOTtCziL4gL0XsHmFOAaO00SlU1Y+A/7xxlavtKTZKsqhPg8CnIKosJ1hsyGfCj6nI4e59nTbJGFy8aOj/gCU7cvKeq9pcs+8OG1bWye+YJdUnuLO2NtPRYbY9DpjhxZulk2h9E2fnz6vm0iYLR+tTCbs3i63qz2wsrbv4XRwt2LP3kg6C7zwmlKjhNEIEJu1khsam7iRv6wHmUj+VdG2YVGjqCf4pGVXNbiT6otqRveLIkGCBPBUuB4tNvnOSTKvWfV2sKEdU0DxG+pzlQZ3CWdXhPcOSertI1XDZ7TuOcseP30OR7uryNVYD3f3QYYL5EEwla2kdNc5dRTIurBSme8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This introduces a sub-system for collecting memory access
information from different sources. It maintains the hotness
information based on the access history and time of access.

Additionally, it provides per-lowertier-node kernel threads
(named kpromoted) that periodically promote the pages that
are eligible for promotion.

Sub-systems that generate hot page access info can report that
using this API:

int pghot_record_access(u64 pfn, int nid, int src,
			unsigned long time)

@pfn: The PFN of the memory accessed
@nid: The accessing NUMA node ID
@src: The temperature source (sub-system) that generated the
      access info
@time: The access time in jiffies

Some temperature sources may not provide the nid from which
the page was accessed. This is true for sources that use
page table scanning for PTE Accessed bit. For such sources,
the default toptier node to which such pages should be promoted
is hard coded.

Also, the access time provided some sources may at best be
considered approximate. This is especially true for hot pages
detected by PTE A bit scanning.

The hot PFN records are stored in hash lists hashed by PFN value.
The PFN records that are categorized as hot enough to be promoted
are maintained in a per-lowertier-node max heap from which
kpromoted extracts and promotes them.

Each record stores the following info:

struct pghot_info {
	unsigned long pfn;

	unsigned long last_update; /* Most recent access time */
	int frequency; /* Number of accesses within current window */
	int nid; /* Most recent access from this node */

	struct hlist_node hnode;
	size_t heap_idx; /* Position in max heap for quick retreival */
};

The way in which a page is categorized as hot enough to be
promoted is pretty primitive now.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 include/linux/mmzone.h        |  11 +
 include/linux/pghot.h         |  87 ++++++
 include/linux/vm_event_item.h |   9 +
 mm/Kconfig                    |  11 +
 mm/Makefile                   |   1 +
 mm/mm_init.c                  |  10 +
 mm/pghot.c                    | 501 ++++++++++++++++++++++++++++++++++
 mm/vmstat.c                   |   9 +
 8 files changed, 639 insertions(+)
 create mode 100644 include/linux/pghot.h
 create mode 100644 mm/pghot.c

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 0c5da9141983..f7094babed10 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1349,6 +1349,10 @@ struct memory_failure_stats {
 };
 #endif
 
+#ifdef CONFIG_PGHOT
+#include <linux/pghot.h>
+#endif
+
 /*
  * On NUMA machines, each NUMA node would have a pg_data_t to describe
  * it's memory layout. On UMA machines there is a single pglist_data which
@@ -1497,6 +1501,13 @@ typedef struct pglist_data {
 #ifdef CONFIG_MEMORY_FAILURE
 	struct memory_failure_stats mf_stats;
 #endif
+#ifdef CONFIG_PGHOT
+	struct task_struct *kpromoted;
+	wait_queue_head_t kpromoted_wait;
+	struct pghot_info **phi_buf;
+	struct max_heap heap;
+	spinlock_t heap_lock;
+#endif
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
diff --git a/include/linux/pghot.h b/include/linux/pghot.h
new file mode 100644
index 000000000000..6b8496944e7f
--- /dev/null
+++ b/include/linux/pghot.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_KPROMOTED_H
+#define _LINUX_KPROMOTED_H
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/workqueue_types.h>
+
+/* Page hotness temperature sources */
+enum pghot_src {
+	PGHOT_HW_HINTS,
+	PGHOT_PGTABLE_SCAN,
+};
+
+#ifdef CONFIG_PGHOT
+
+#define KPROMOTED_FREQ_WINDOW	(5 * MSEC_PER_SEC)
+
+/* 2 accesses within a window will make the page a promotion candidate */
+#define KPRMOTED_FREQ_THRESHOLD	2
+
+/*
+ * The following two defines control the number of hash lists
+ * that are maintained for tracking PFN accesses.
+ */
+#define PGHOT_HASH_PCT		50	/* % of lower tier memory pages to track */
+#define PGHOT_HASH_ENTRIES	1024	/* Number of entries per list, ideal case */
+
+/*
+ * Percentage of hash entries that can reside in heap as migrate-ready
+ * candidates
+ */
+#define PGHOT_HEAP_PCT		25
+
+#define KPRMOTED_MIGRATE_BATCH	1024
+
+/*
+ * If target NID isn't available, kpromoted promotes to node 0
+ * by default.
+ *
+ * TODO: Need checks to validate that default node is indeed
+ * present and is a toptier node.
+ */
+#define KPROMOTED_DEFAULT_NODE	0
+
+struct pghot_info {
+	unsigned long pfn;
+
+	/*
+	 * The following are the three fundamental parameters
+	 * required to track the hotness of page/PFN.
+	 *
+	 * TODO:
+	 * Check if these three can fit into a u32.
+	 * With 3 bits for frequency (8 most recent accesses),
+	 * 10 bits for nid (1024 nodes), the remaining 19 bits
+	 * are available for timestamp.
+	 */
+	unsigned long last_update; /* Most recent access time */
+	int frequency; /* Number of accesses within current window */
+	int nid; /* Most recent access from this node */
+
+	struct hlist_node hnode;
+	size_t heap_idx; /* Position in max heap for quick retreival */
+};
+
+struct max_heap {
+	size_t nr;
+	size_t size;
+	struct pghot_info **data;
+	DECLARE_FLEX_ARRAY(struct pghot_info *, preallocated);
+};
+
+/*
+ * The wakeup interval of kpromoted threads
+ */
+#define KPROMOTE_DELAY	20	/* 20ms */
+
+int pghot_record_access(u64 pfn, int nid, int src, unsigned long now);
+#else
+static inline int pghot_record_access(u64 pfn, int nid, int src,
+				      unsigned long now)
+{
+	return 0;
+}
+#endif /* CONFIG_PGHOT */
+#endif /* _LINUX_KPROMOTED_H */
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 9e15a088ba38..9085e5c2d4aa 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -186,6 +186,15 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		KSTACK_REST,
 #endif
 #endif /* CONFIG_DEBUG_STACK_USAGE */
+		PGHOT_RECORDED_ACCESSES,
+		PGHOT_RECORD_HWHINTS,
+		PGHOT_RECORD_PGTSCANS,
+		PGHOT_RECORDS_HASH,
+		PGHOT_RECORDS_HEAP,
+		KPROMOTED_RIGHT_NODE,
+		KPROMOTED_NON_LRU,
+		KPROMOTED_COLD_OLD,
+		KPROMOTED_DROPPED,
 		NR_VM_EVENT_ITEMS
 };
 
diff --git a/mm/Kconfig b/mm/Kconfig
index e443fe8cd6cf..8b236eb874cf 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1381,6 +1381,17 @@ config PT_RECLAIM
 
 	  Note: now only empty user PTE page table pages will be reclaimed.
 
+config PGHOT
+	bool "Hot page tracking and promotion"
+	def_bool y
+	depends on NUMA && MIGRATION && MMU
+	select MIN_HEAP
+	help
+	  A sub-system to track page accesses in lower tier memory and
+	  maintain hot page information. Promotes hot pages from lower
+	  tiers to top tier by using the memory access information provided
+	  by various sources. Asynchronous promotion is done by per-node
+	  kernel threads.
 
 source "mm/damon/Kconfig"
 
diff --git a/mm/Makefile b/mm/Makefile
index ef54aa615d9d..8799bd0c68ed 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -147,3 +147,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
+obj-$(CONFIG_PGHOT) += kpromoted.o
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 5c21b3af216b..f7992be3ff7f 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1402,6 +1402,15 @@ static void pgdat_init_kcompactd(struct pglist_data *pgdat)
 static void pgdat_init_kcompactd(struct pglist_data *pgdat) {}
 #endif
 
+#ifdef CONFIG_PGHOT
+static void pgdat_init_kpromoted(struct pglist_data *pgdat)
+{
+	init_waitqueue_head(&pgdat->kpromoted_wait);
+}
+#else
+static void pgdat_init_kpromoted(struct pglist_data *pgdat) {}
+#endif
+
 static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 {
 	int i;
@@ -1411,6 +1420,7 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 
 	pgdat_init_split_queue(pgdat);
 	pgdat_init_kcompactd(pgdat);
+	pgdat_init_kpromoted(pgdat);
 
 	init_waitqueue_head(&pgdat->kswapd_wait);
 	init_waitqueue_head(&pgdat->pfmemalloc_wait);
diff --git a/mm/pghot.c b/mm/pghot.c
new file mode 100644
index 000000000000..eadcf970c3ef
--- /dev/null
+++ b/mm/pghot.c
@@ -0,0 +1,501 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Maintains information about hot pages from slower tier nodes and
+ * promotes them.
+ *
+ * Info about accessed pages are stored in hash lists indexed by PFN.
+ * Info about pages that are hot enough to be promoted are stored in
+ * a per-toptier-node max_heap.
+ *
+ * kpromoted is a kernel thread that runs on each toptier node and
+ * promotes pages from max_heap.
+ *
+ * TODO:
+ * - Compact pghot_info so that nid, time and frequency can fit
+ * - Scalar hotness value as a function frequency and recency
+ * - Possibility of moving migration rate limiting to kpromoted
+ */
+#include <linux/pghot.h>
+#include <linux/kthread.h>
+#include <linux/mmzone.h>
+#include <linux/migrate.h>
+#include <linux/memory-tiers.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/vmalloc.h>
+#include <linux/hashtable.h>
+#include <linux/min_heap.h>
+
+struct pghot_hash {
+	struct hlist_head hash;
+	spinlock_t lock;
+};
+
+static struct pghot_hash *phi_hash;
+static int phi_hash_order;
+static int phi_heap_entries;
+static struct kmem_cache *phi_cache __ro_after_init;
+static bool kpromoted_started __ro_after_init;
+
+static bool phi_heap_less(const void *lhs, const void *rhs, void *args)
+{
+	return (*(struct pghot_info **)lhs)->frequency >
+		(*(struct pghot_info **)rhs)->frequency;
+}
+
+static void phi_heap_swp(void *lhs, void *rhs, void *args)
+{
+	struct pghot_info **l = (struct pghot_info **)lhs;
+	struct pghot_info **r = (struct pghot_info **)rhs;
+	int lindex = l - (struct pghot_info **)args;
+	int rindex = r - (struct pghot_info **)args;
+	struct pghot_info *tmp = *l;
+
+	*l = *r;
+	*r = tmp;
+
+	(*l)->heap_idx = lindex;
+	(*r)->heap_idx = rindex;
+}
+
+static const struct min_heap_callbacks phi_heap_cb = {
+	.less = phi_heap_less,
+	.swp = phi_heap_swp,
+};
+
+static void phi_heap_update_entry(struct max_heap *phi_heap, struct pghot_info *phi)
+{
+	int orig_idx = phi->heap_idx;
+
+	min_heap_sift_up(phi_heap, phi->heap_idx, &phi_heap_cb,
+			 phi_heap->data);
+	if (phi_heap->data[phi->heap_idx]->heap_idx == orig_idx)
+		min_heap_sift_down(phi_heap, phi->heap_idx,
+				   &phi_heap_cb, phi_heap->data);
+}
+
+static bool phi_heap_insert(struct max_heap *phi_heap, struct pghot_info *phi)
+{
+	if (phi_heap->nr >= phi_heap_entries)
+		return false;
+
+	phi->heap_idx = phi_heap->nr;
+	min_heap_push(phi_heap, &phi, &phi_heap_cb, phi_heap->data);
+
+	return true;
+}
+
+static bool phi_is_pfn_hot(struct pghot_info *phi)
+{
+	struct page *page = pfn_to_online_page(phi->pfn);
+	unsigned long now = jiffies;
+	struct folio *folio;
+
+	if (!page || is_zone_device_page(page))
+		return false;
+
+	folio = page_folio(page);
+	if (!folio_test_lru(folio)) {
+		count_vm_event(KPROMOTED_NON_LRU);
+		return false;
+	}
+	if (folio_nid(folio) == phi->nid) {
+		count_vm_event(KPROMOTED_RIGHT_NODE);
+		return false;
+	}
+
+	/* If the page was hot a while ago, don't promote */
+	if ((now - phi->last_update) > 2 * msecs_to_jiffies(KPROMOTED_FREQ_WINDOW)) {
+		count_vm_event(KPROMOTED_COLD_OLD);
+		return false;
+	}
+	return true;
+}
+
+static struct folio *kpromoted_isolate_folio(struct pghot_info *phi)
+{
+	struct page *page = pfn_to_page(phi->pfn);
+	struct folio *folio;
+
+	if (!page)
+		return NULL;
+
+	folio = page_folio(page);
+	if (migrate_misplaced_folio_prepare(folio, NULL, phi->nid))
+		return NULL;
+	else
+		return folio;
+}
+
+static struct pghot_info *phi_alloc(unsigned long pfn)
+{
+	struct pghot_info *phi;
+
+	phi = kmem_cache_zalloc(phi_cache, GFP_NOWAIT);
+	if (!phi)
+		return NULL;
+
+	phi->pfn = pfn;
+	phi->heap_idx = -1;
+	return phi;
+}
+
+static inline void phi_free(struct pghot_info *phi)
+{
+	kmem_cache_free(phi_cache, phi);
+}
+
+static int phi_heap_extract(pg_data_t *pgdat, int batch_count, int freq_th,
+			    struct list_head *migrate_list, int *count)
+{
+	spinlock_t *phi_heap_lock = &pgdat->heap_lock;
+	struct max_heap *phi_heap = &pgdat->heap;
+	int max_retries = 10;
+	int bkt, i = 0;
+
+	if (batch_count < 0 || !migrate_list || !count || freq_th < 1 ||
+	    freq_th > KPRMOTED_FREQ_THRESHOLD)
+		return -EINVAL;
+
+	*count = 0;
+	for (i = 0; i < batch_count; i++) {
+		struct pghot_info *top = NULL;
+		bool should_continue = false;
+		struct folio *folio;
+		int retries = 0;
+
+		while (retries < max_retries) {
+			spin_lock(phi_heap_lock);
+			if (phi_heap->nr > 0 && phi_heap->data[0]->frequency >= freq_th) {
+				should_continue = true;
+				bkt = hash_min(phi_heap->data[0]->pfn, phi_hash_order);
+				top = phi_heap->data[0];
+			}
+			spin_unlock(phi_heap_lock);
+
+			if (!should_continue)
+				goto done;
+
+			spin_lock(&phi_hash[bkt].lock);
+			spin_lock(phi_heap_lock);
+			if (phi_heap->nr == 0 || phi_heap->data[0] != top ||
+			    phi_heap->data[0]->frequency < freq_th) {
+				spin_unlock(phi_heap_lock);
+				spin_unlock(&phi_hash[bkt].lock);
+				retries++;
+				continue;
+			}
+
+			top = phi_heap->data[0];
+			hlist_del_init(&top->hnode);
+
+			phi_heap->nr--;
+			if (phi_heap->nr > 0) {
+				phi_heap->data[0] = phi_heap->data[phi_heap->nr];
+				phi_heap->data[0]->heap_idx = 0;
+				min_heap_sift_down(phi_heap, 0, &phi_heap_cb,
+						   phi_heap->data);
+			}
+
+			spin_unlock(phi_heap_lock);
+			spin_unlock(&phi_hash[bkt].lock);
+
+			if (!phi_is_pfn_hot(top)) {
+				count_vm_event(KPROMOTED_DROPPED);
+				goto skip;
+			}
+
+			folio = kpromoted_isolate_folio(top);
+			if (folio) {
+				list_add(&folio->lru, migrate_list);
+				(*count)++;
+			}
+skip:
+			phi_free(top);
+			break;
+		}
+		if (retries >= max_retries) {
+			pr_warn("%s: Too many retries\n", __func__);
+			break;
+		}
+
+	}
+done:
+	return 0;
+}
+
+static void phi_heap_add_or_adjust(struct pghot_info *phi)
+{
+	pg_data_t *pgdat = NODE_DATA(phi->nid);
+	struct max_heap *phi_heap = &pgdat->heap;
+
+	spin_lock(&pgdat->heap_lock);
+	if (phi->heap_idx >= 0 && phi->heap_idx < phi_heap->nr &&
+	    phi_heap->data[phi->heap_idx] == phi) {
+		/* Entry exists in heap */
+		if (phi->frequency < KPRMOTED_FREQ_THRESHOLD) {
+			/* Below threshold, remove from the heap */
+			phi_heap->nr--;
+			if (phi->heap_idx < phi_heap->nr) {
+				phi_heap->data[phi->heap_idx] =
+					phi_heap->data[phi_heap->nr];
+				phi_heap->data[phi->heap_idx]->heap_idx =
+					phi->heap_idx;
+				min_heap_sift_down(phi_heap, phi->heap_idx,
+						   &phi_heap_cb, phi_heap->data);
+			}
+			phi->heap_idx = -1;
+
+		} else {
+			/* Update position in heap */
+			phi_heap_update_entry(phi_heap, phi);
+		}
+	} else if (phi->frequency >= KPRMOTED_FREQ_THRESHOLD) {
+		/* Add to the heap */
+		if (phi_heap_insert(phi_heap, phi))
+			count_vm_event(PGHOT_RECORDS_HEAP);
+	}
+	spin_unlock(&pgdat->heap_lock);
+}
+
+static struct pghot_info *phi_lookup(unsigned long pfn, int bkt)
+{
+	struct pghot_info *phi;
+
+	hlist_for_each_entry(phi, &phi_hash[bkt].hash, hnode) {
+		if (phi->pfn == pfn)
+			return phi;
+	}
+	return NULL;
+}
+
+/*
+ * Called by subsystems that generate page hotness/access information.
+ *
+ *  @pfn: The PFN of the memory accessed
+ *  @nid: The accessing NUMA node ID
+ *  @src: The temperature source (sub-system) that generated the
+ *        access info
+ *  @time: The access time in jiffies
+ *
+ * Maintains the access records per PFN, classifies them as
+ * hot based on subsequent accesses and finally hands over
+ * them to kpromoted for migration.
+ */
+int pghot_record_access(u64 pfn, int nid, int src, unsigned long now)
+{
+	struct pghot_info *phi;
+	struct page *page;
+	struct folio *folio;
+	int bkt;
+	bool new_entry = false, new_window = false;
+
+	if (!kpromoted_started)
+		return -EINVAL;
+
+	count_vm_event(PGHOT_RECORDED_ACCESSES);
+
+	switch (src) {
+	case PGHOT_HW_HINTS:
+		count_vm_event(PGHOT_RECORD_HWHINTS);
+		break;
+	case PGHOT_PGTABLE_SCAN:
+		count_vm_event(PGHOT_RECORD_PGTSCANS);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/*
+	 * Record only accesses from lower tiers.
+	 */
+	if (node_is_toptier(pfn_to_nid(pfn)))
+		return 0;
+
+	/*
+	 * Reject the non-migratable pages right away.
+	 */
+	page = pfn_to_online_page(pfn);
+	if (!page || is_zone_device_page(page))
+		return 0;
+
+	folio = page_folio(page);
+	if (!folio_test_lru(folio))
+		return 0;
+
+	bkt = hash_min(pfn, phi_hash_order);
+	spin_lock(&phi_hash[bkt].lock);
+	phi = phi_lookup(pfn, bkt);
+	if (!phi) {
+		phi = phi_alloc(pfn);
+		if (!phi)
+			goto out;
+		new_entry = true;
+	}
+
+	if (((now - phi->last_update) > msecs_to_jiffies(KPROMOTED_FREQ_WINDOW)) ||
+	    (nid != NUMA_NO_NODE && phi->nid != nid))
+		new_window = true;
+
+	if (new_entry || new_window) {
+		/* New window */
+		phi->frequency = 1; /* TODO: Factor in the history */
+	} else
+		phi->frequency++;
+	phi->last_update = now;
+	phi->nid = (nid == NUMA_NO_NODE) ? KPROMOTED_DEFAULT_NODE : nid;
+
+	if (new_entry) {
+		/* Insert the new entry into hash table */
+		hlist_add_head(&phi->hnode, &phi_hash[bkt].hash);
+		count_vm_event(PGHOT_RECORDS_HASH);
+	} else {
+		/* Add/update the position in heap */
+		phi_heap_add_or_adjust(phi);
+	}
+out:
+	spin_unlock(&phi_hash[bkt].lock);
+	return 0;
+}
+
+/*
+ * Extract the hot page records and batch-migrate the
+ * hot pages.
+ */
+static void kpromoted_migrate(pg_data_t *pgdat)
+{
+	int count, ret;
+	LIST_HEAD(migrate_list);
+
+	/*
+	 * Extract the top N elements from the heap that match
+	 * the requested hotness threshold.
+	 *
+	 * PFNs ineligible from migration standpoint are removed
+	 * from the heap and hash.
+	 *
+	 * Folios eligible for migration are isolated and returned
+	 * in @migrate_list.
+	 */
+	ret = phi_heap_extract(pgdat, KPRMOTED_MIGRATE_BATCH,
+			       KPRMOTED_FREQ_THRESHOLD, &migrate_list, &count);
+	if (ret)
+		return;
+
+	if (!list_empty(&migrate_list))
+		migrate_misplaced_folios_batch(&migrate_list, pgdat->node_id);
+}
+
+static int kpromoted(void *p)
+{
+	pg_data_t *pgdat = (pg_data_t *)p;
+
+	while (!kthread_should_stop()) {
+		wait_event_timeout(pgdat->kpromoted_wait, false,
+				   msecs_to_jiffies(KPROMOTE_DELAY));
+		kpromoted_migrate(pgdat);
+	}
+	return 0;
+}
+
+static int kpromoted_run(int nid)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+	int ret = 0;
+
+	if (!node_is_toptier(nid))
+		return 0;
+
+	if (!pgdat->phi_buf) {
+		pgdat->phi_buf = vzalloc_node(phi_heap_entries * sizeof(struct pghot_info *),
+					      nid);
+		if (!pgdat->phi_buf)
+			return -ENOMEM;
+
+		min_heap_init(&pgdat->heap, pgdat->phi_buf, phi_heap_entries);
+		spin_lock_init(&pgdat->heap_lock);
+	}
+
+	if (!pgdat->kpromoted)
+		pgdat->kpromoted = kthread_create_on_node(kpromoted, pgdat, nid,
+							  "kpromoted%d", nid);
+	if (IS_ERR(pgdat->kpromoted)) {
+		ret = PTR_ERR(pgdat->kpromoted);
+		pgdat->kpromoted = NULL;
+		pr_info("Failed to start kpromoted%d, ret %d\n", nid, ret);
+	} else {
+		wake_up_process(pgdat->kpromoted);
+	}
+	return ret;
+}
+
+static int __init pghot_init(void)
+{
+	unsigned int hash_size;
+	size_t hash_entries;
+	size_t nr_pages = 0;
+	pg_data_t *pgdat;
+	int i, nid, ret;
+
+	/*
+	 * Arrive at the hash and heap sizes based on the
+	 * number of pages present in the lower tier nodes.
+	 */
+	for_each_node_state(nid, N_MEMORY) {
+		if (!node_is_toptier(nid))
+			nr_pages += NODE_DATA(nid)->node_present_pages;
+	}
+
+	if (!nr_pages)
+		return 0;
+
+	hash_entries = nr_pages * PGHOT_HASH_PCT / 100;
+	hash_size = hash_entries / PGHOT_HASH_ENTRIES;
+	phi_hash_order = ilog2(hash_size);
+
+	phi_hash = vmalloc(sizeof(struct pghot_hash) * hash_size);
+	if (!phi_hash) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < hash_size; i++) {
+		INIT_HLIST_HEAD(&phi_hash[i].hash);
+		spin_lock_init(&phi_hash[i].lock);
+	}
+
+	phi_cache = KMEM_CACHE(pghot_info, 0);
+	if (unlikely(!phi_cache)) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	phi_heap_entries = hash_entries * PGHOT_HEAP_PCT / 100;
+	for_each_node_state(nid, N_CPU) {
+		ret = kpromoted_run(nid);
+		if (ret)
+			goto out_stop_kthread;
+	}
+
+	kpromoted_started = true;
+	pr_info("pghot: Started page hotness monitoring and promotion thread\n");
+	pr_info("pghot: nr_pages %ld hash_size %d hash_entries %ld hash_order %d heap_entries %d\n",
+	       nr_pages, hash_size, hash_entries, phi_hash_order, phi_heap_entries);
+	return 0;
+
+out_stop_kthread:
+	for_each_node_state(nid, N_CPU) {
+		pgdat = NODE_DATA(nid);
+		if (pgdat->kpromoted) {
+			kthread_stop(pgdat->kpromoted);
+			pgdat->kpromoted = NULL;
+			vfree(pgdat->phi_buf);
+		}
+	}
+out:
+	kmem_cache_destroy(phi_cache);
+	vfree(phi_hash);
+	return ret;
+}
+
+late_initcall(pghot_init)
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 71cd1ceba191..9edbdd71c6f7 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1496,6 +1496,15 @@ const char * const vmstat_text[] = {
 #endif
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */
+	"pghot_recorded_accesses",
+	"pghot_recorded_hwhints",
+	"pghot_recorded_pgtscans",
+	"pghot_records_hash",
+	"pghot_records_heap",
+	"kpromoted_right_node",
+	"kpromoted_non_lru",
+	"kpromoted_cold_old",
+	"kpromoted_dropped",
 };
 #endif /* CONFIG_PROC_FS || CONFIG_SYSFS || CONFIG_NUMA || CONFIG_MEMCG */
 
-- 
2.34.1


