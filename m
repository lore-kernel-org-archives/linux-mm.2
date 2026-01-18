Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96371C9830C
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 19:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BBD26B00B3; Sun, 18 Jan 2026 14:18:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0936F6B00B5; Sun, 18 Jan 2026 14:18:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB636B00B6; Sun, 18 Jan 2026 14:18:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6BEF6B00B3
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:18:27 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C3311A05CD
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:18:27 +0000 (UTC)
X-FDA: 84346045854.29.9D4AD1A
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011047.outbound.protection.outlook.com [40.93.194.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7213840006
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:18:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=LdU0jWwp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of shivankg@amd.com designates 40.93.194.47 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768763904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qfbBlfzfN4NyNLKb0xZp6FOhjvRnxt9NMOAUspvblzw=;
	b=vVUV76d5klc11EoUkEsNvXsJheiUQbyigO318j6ceZPedWZo9E3zQVo2+fVLGqUA0Tlk/X
	NxY5fWvTYtxeAqCaATEaNpvqbWVAUFLOgbOmvDD7fowrks9eUcJIBnPf/ZR95ESaR963t0
	7WCovJmZx2CHKBNBqII6A5qxbm9n2uU=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=LdU0jWwp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of shivankg@amd.com designates 40.93.194.47 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768763904; a=rsa-sha256;
	cv=pass;
	b=v+8BQzgAIQdi6ClfyxDGR6b5rW3oIRc/0Rj9cuyr7vxxkk5wAp2eDyy06TipZkahpWlbSU
	V2/XMOCsQyEJlkrlIfqUkfeEvJtUtm5G4udxpNVY+rgLpXRKMsGg+CjI1kGzjbUEm2ZLZG
	4+iGIprZ6Q57r3SiJGs8quA6r0OUB5s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rfdwfPtdaimNE3+r/wlybx3RuWZP9oegS2rVDanECwIQ4vSB2Af4mwtUIOCICE3EO8qkfCgPD6jkvbBlHBRdRWVjSCOg8DJjr91QBI0hk9uHL85aQe5XDrstz20VmfENoNbDo4bb+UoIk+m7bHx57CRs+OXv66qCxp5Ri7mih1QcSzjODgRj3cmTxMZ9BzcrIKpmklRvOYa7+8oMKVmqL85uqf1+NPDmqs4sZc1poXFUv5IUMlhm52sXjyHF+PzcBtBBXNX82XNz+efvlP4uTQ3fKoeFl6/Smyw7jgVcQFozMNZoGCc8FTqkU6K7Ac6fFFzwQSqQwLQ5X8OfoGg0Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qfbBlfzfN4NyNLKb0xZp6FOhjvRnxt9NMOAUspvblzw=;
 b=g79sxzD5iUaU4shm+i93TdTTq/7bnw+AkA6j3Xik1JV/XRG8Ldv/cvL4u48PZUUS+5uFHtoZrC+Bk1H+kuQbctSc5AArhstkFJr/kq8mEVYuhq3uaBHe/KyqTvq48JmW2yyeN9zlmtFF5Yc3eH/R9mEsb5HnuoycaISV8eU2i8dHuPo7C65V2M83FBTqjx8bwjPJ9hZoNi4QrHJrMF3VvDwfZpJb26Oi5YHqJM7OLuNaXEDt6fGaRW3tdsyDAEaelCytUErM9UOt5spGxTV1Z0AWHfYVckkho8D9oWFYwA+ixxxfZeiWP7o/mBPxIi5scdPdJy3RdrWcwHJapSdu+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qfbBlfzfN4NyNLKb0xZp6FOhjvRnxt9NMOAUspvblzw=;
 b=LdU0jWwp/uT1eATl5XsYE/7IxjLy4zljleHDBK8vTCFvETZ9yIxX/x1RDhEozmKjoDugG8D78JK2j9dWcQHbr5AizyamOVkG89rmJZZQGsRgVioUY4/hPCn9irAKBLu3geiLAQQ6LoLv2PXpYMT+2NlXfNJMSccxNHHDCAHHPUw=
Received: from BN9PR03CA0945.namprd03.prod.outlook.com (2603:10b6:408:108::20)
 by DM6PR12MB4251.namprd12.prod.outlook.com (2603:10b6:5:21e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Sun, 18 Jan
 2026 19:18:20 +0000
Received: from BN3PEPF0000B06C.namprd21.prod.outlook.com
 (2603:10b6:408:108:cafe::b6) by BN9PR03CA0945.outlook.office365.com
 (2603:10b6:408:108::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.10 via Frontend Transport; Sun,
 18 Jan 2026 19:18:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B06C.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.0 via Frontend Transport; Sun, 18 Jan 2026 19:18:19 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 18 Jan
 2026 13:18:14 -0600
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Masami Hiramatsu
	<mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	<linux-trace-kernel@vger.kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Zach O'Keefe <zokeefe@google.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Stephen Rothwell
	<sfr@canb.auug.org.au>, <shivankg@amd.com>, Branden Moore
	<Branden.Moore@amd.com>, wang lian <lianux.mm@gmail.com>
Subject: [PATCH V5 1/2] mm/khugepaged: map dirty/writeback pages failures to EAGAIN
Date: Sun, 18 Jan 2026 19:09:40 +0000
Message-ID: <20260118190939.8986-4-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260118190939.8986-2-shivankg@amd.com>
References: <20260118190939.8986-2-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06C:EE_|DM6PR12MB4251:EE_
X-MS-Office365-Filtering-Correlation-Id: 6240e70b-6296-42cd-edb5-08de56c65733
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/2a+yrzQkm/CeFzitHCGndqpT+71OD2qBwkEpgzBRJAey/DVHtCXYdbKaV2Y?=
 =?us-ascii?Q?YbM/tp4YC1CoRUblwKc2WVgXhBQYOexorM6XnOaWJj0rb8q7DG+3x4py+y1/?=
 =?us-ascii?Q?iDL4PYNtnOdtZG5GcAiq/+AXlajKALlBh6nuZn3B3rUfl4VBYVNB4kuTg3y1?=
 =?us-ascii?Q?RVUnPVPVpjdAqf+xxvLip+vYAeWskTKTvPmZ4c557q/GuWdBiAgY415AKX49?=
 =?us-ascii?Q?+jP6A/TScCUIJHkAuGXOyVDz/uLBFM3lWZmkyWeOI2QzQt83PRI1fHqu+NOd?=
 =?us-ascii?Q?b+RSGHN0wUhLCJpYGUfknZhC0RU5HD72KLWrI8BBNaqU40KcMRwMRf+l5OGg?=
 =?us-ascii?Q?iwpm1wx7+rlpp/wOUfaYAFItUy5y5g8y4/oM3H9KXKurDsC3UlN0HmldCWF5?=
 =?us-ascii?Q?Y/Wq6ptXX0zeE6Sx8oiT7OtZzmOHjVeulyfpwBUt7OrbZNyn0A3c71i16SXH?=
 =?us-ascii?Q?Gel3M2lVGuutF56lpdd5a6OHFYWvIVgMdMqN7m3ehHnD+VvpS+Hk5xyU1dRS?=
 =?us-ascii?Q?pWY60GIN5beKYyPfVQohYY6byHLvh2PRR/qtmlys7rF01eoVCwDPyWegyFuW?=
 =?us-ascii?Q?nFJSgEgC/xjI5/tRTo0gXhLvOQ2cdyiqszdAco3yJFjSv58V97OmWR4QgUwD?=
 =?us-ascii?Q?WsxETDRYwR5FSF6UQ/2sqPJk2nEA8koZNe8nRWPK5J6gwzEB4qyBDE0B0jld?=
 =?us-ascii?Q?Y08e61etEqOsXx3kYtTujwQK2eMrEuBn8xeqHrf7MSgnc6LHRhx6qja72El8?=
 =?us-ascii?Q?fVgfn0BYSOmJsC5FEf9aBKXnLFltJWxRRpylkbpTSwQJXrOPffwKjo3thuiL?=
 =?us-ascii?Q?egNNpUlTZJ1B/E+EgFli2IcgTrAMxucXgMDccOhzv2XoqT4QSs07rHB/AARQ?=
 =?us-ascii?Q?H3q/iajSNFIUa3GicvlJtKwTJZe/lRFkhE8gXffS5XCp5iXkl969EIMOSdVV?=
 =?us-ascii?Q?zW1F+TCASbnlI1x4TZHDRzFdR+8gCyLhanOX3198dbFCvKxbeZbyWW0Q11hZ?=
 =?us-ascii?Q?oSfrtMAHTbti8oPYZ6r8swfNo8Wj7KLcsKdMBnCc66fzvvwrXpX7cg3Q3RzE?=
 =?us-ascii?Q?B5YVDXYLrM6bnmwOLEfVW/sX3wCFsWIeEnvuHWTX+l6IzFjK4VhgpC89ZFoW?=
 =?us-ascii?Q?LbLQdHsQ9cKUVL9iqWEGgVJ3HX0P1kfYx4kpuZ2kCXEXxuDFUGLh0vnwv/zb?=
 =?us-ascii?Q?b8urd/AKGZhzYrp1tTdOf+FpioJuhPUwHXYjve8e26BQwDei/6ZN25iTv9pv?=
 =?us-ascii?Q?AaNGmF4RZ//5L1GHtmcWBoMHmSDiq/hoANP4O43XyUZMk7AbxGf8eueFfQOD?=
 =?us-ascii?Q?3ox3FyGBnO0/DsQk6XrWAAl7Lqq8mPJLULhLqF0G/GmkPrrbKOpV9M/lmOUU?=
 =?us-ascii?Q?sUetNED1vs7g5a8CnnORyVBNxPUGILAk8BNxnAzg+Z+D1ks553n2qXfzre2y?=
 =?us-ascii?Q?mP4HoiVTodJYwKBNPsViBj9u4lcOpqTqegOi7iqlR+Nb+nQvcaIU9rnSX2Fn?=
 =?us-ascii?Q?rNp8vypZGviDBWtNP7aUghB/YkWUeXXq6j8tHkp/vMxMEWghYmCpZm2lzJfh?=
 =?us-ascii?Q?+EpGtYvF8GSghHnNdMMOJQGvJydXg3RTj032mSc/8Ud5t/aKbhAZfGYkIDYN?=
 =?us-ascii?Q?AyQSxNJEXWjcvEnm0/XYs3c=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 19:18:19.9292
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6240e70b-6296-42cd-edb5-08de56c65733
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06C.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4251
X-Rspam-User: 
X-Stat-Signature: 8ijbctokoujarejbazzxj8gjuicuag98
X-Rspamd-Queue-Id: 7213840006
X-Rspamd-Server: rspam04
X-HE-Tag: 1768763904-419672
X-HE-Meta: U2FsdGVkX18KpZONg72StEXt8AvaSfuKEA8Ax1bjUvhY8mdr/9t5R/Tpvq56JbXzLscmm/jfdsDTx3M7wmL0FmHnwwRxxDRIH6+njcAEEwG2uCeHdP1j9KVg/RCr1E2T6OI7zKUgdhGhdYaTdHmlWke+usJdalm0uGeYWW3VtYZTeHkLp4fWbwLm73UVaQ2RDOjO5nWZh2Vb8vLZvhyGcUJG2/ru2ZyWoaSsdiIMxbv6hgP5I3HZ/OKlEtJko0VGRyBxW6WSmrtUQKEt3q125TM65uS6L9hLYjTCMVCtg9Xx/uaOjOT24Qgos98ZQm/dVdqXwP0EwYnyyKx9iCBBnG/pl7AgRkgtExZsFEW1weZZUPOi6qBf7d8Fyz2AZ3kzBAe1yOcIAdXnTLaRL8ydzHzBWgPDPAMRnRHZGBM/oLSrLUtHXfwGGjrbz8uvhLPZfGfvS1EgzNJxa90yYuHUlBJNRD8JEG/nHO8QEYeu8fz87x1+qiCS6xnZ0qJhrFo1FEqA/yDBCORu3aJmurOhIgqKVDFKz+xn8CcyoZEQTS5PcIpBtgfSdHG1XU4sRGD/url1Mv3wutQ04Q8dHJrdUdY2Gu+mIjMjTbYhiOe6/cprAIqmAWkLrGDeT8VDm4T8+6+SMPcqb8FDdYAU3Q7I6SM8gXTC1mI8O/w+XB8jEm6w12+qrzvc/zOWkZ5sf4kIdvQr3Ne0rFk+4/j553fppOHqGCnYcO97RUe3CBEgp6pPlJnYzmNUznkFxLtQ/9M5cyBLp+JOwQI/7zIdTbdSD2vQOBDqptpZM1kyUE0VpfmOeYmTE/rfAHzajRm2Ffh1obsg8nT/1LjtP/ntpAY7bMxzbjboe+WtwwqDPYUUfJsfwbylfv0ls+ACRMBLgR/oH4rDnRlNaI6+eMC9iPWJYfkUxRjaz34SU5YIYBWVhOJTDFq80RP+MuQX5Wtj+k01J7ML8r4sAJSB7QsTiKi
 pmgbo7Gz
 WbEEnitYY3Ltm5shbEZ1b/NhuxJuNfbiykN/sULP/TXbH6tWa7IxFyHTME1PaNwBBmBlu5FYkE/RGsqhNXuMF0yDOoSul6DDWh3anYsQ2ll0MNlsJQ5bqGAYVz+GIm3CM6iqKPXFyNWfvWeJQWDbOAHi3J6Pi4aCB9bXW75u4gi0ud7XNmqi3gm+SqtKYBuvSdlNwRpMlg82yHR5AIBhVFZuv+iOKs295dsToDQCXlWdShR2HFbsr+XovFyZa8zxsDxutwN5gMqAcPsDLgOzqQO4rRVWqBHp1o18mEnPMX0AkYTLea9lRXVu21qWmQypsSkeSFIBwuf9vKOEzCP6tLHXnfyr09iZwHLNtSVDu8R92mvU2u6UL4G9fanuu9HMdpyCC/4LRU/0KAxJWMCz+3TFQwELDBZcvfZTnFKKNGo58tccp++W9w1QS46Quz+tTpKd9EUkGtP5RwfWLj2q1dy6S2n/V6sZh9iFFcRxZnOKpGJIGLbYnYH35WZpxxd8lz5//Pqq6IOegsdI0VuHpCywwXWqWBjygZ18lM5b0XLQWmAb7dkCj1wzN9JD73UOUuVKKl4H0NY5PYAIqjKLhHo12VqFxT1toEeQ6MMwJMK57LCU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When collapse_file encounters dirty or writeback pages in file-backed
mappings, it currently returns SCAN_FAIL which maps to -EINVAL.  This is
misleading as EINVAL suggests invalid arguments, whereas dirty/writeback
pages represent transient conditions that may resolve on retry.

Introduce SCAN_PAGE_DIRTY_OR_WRITEBACK to cover both dirty and writeback
states, mapping it to -EAGAIN.  For MADV_COLLAPSE, this provides userspace
with a clear signal that retry may succeed after writeback completes.  For
khugepaged, this is harmless as it will naturally revisit the range during
periodic scans after async writeback completes.

Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
Reported-by: Branden Moore <Branden.Moore@amd.com>
Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/trace/events/huge_memory.h | 3 ++-
 mm/khugepaged.c                    | 8 +++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 4cde53b45a85..4e41bff31888 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -37,7 +37,8 @@
 	EM( SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
 	EM( SCAN_STORE_FAILED,		"store_failed")			\
 	EM( SCAN_COPY_MC,		"copy_poisoned_page")		\
-	EMe(SCAN_PAGE_FILLED,		"page_filled")
+	EM( SCAN_PAGE_FILLED,		"page_filled")			\
+	EMe(SCAN_PAGE_DIRTY_OR_WRITEBACK, "page_dirty_or_writeback")
 
 #undef EM
 #undef EMe
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 97d1b2824386..219dfa2e523c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -58,6 +58,7 @@ enum scan_result {
 	SCAN_STORE_FAILED,
 	SCAN_COPY_MC,
 	SCAN_PAGE_FILLED,
+	SCAN_PAGE_DIRTY_OR_WRITEBACK,
 };
 
 #define CREATE_TRACE_POINTS
@@ -1967,11 +1968,11 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 				 */
 				xas_unlock_irq(&xas);
 				filemap_flush(mapping);
-				result = SCAN_FAIL;
+				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
 				goto xa_unlocked;
 			} else if (folio_test_writeback(folio)) {
 				xas_unlock_irq(&xas);
-				result = SCAN_FAIL;
+				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
 				goto xa_unlocked;
 			} else if (folio_trylock(folio)) {
 				folio_get(folio);
@@ -2018,7 +2019,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 			 * folio is dirty because it hasn't been flushed
 			 * since first write.
 			 */
-			result = SCAN_FAIL;
+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
 			goto out_unlock;
 		}
 
@@ -2747,6 +2748,7 @@ static int madvise_collapse_errno(enum scan_result r)
 	case SCAN_PAGE_LRU:
 	case SCAN_DEL_PAGE_LRU:
 	case SCAN_PAGE_FILLED:
+	case SCAN_PAGE_DIRTY_OR_WRITEBACK:
 		return -EAGAIN;
 	/*
 	 * Other: Trying again likely not to succeed / error intrinsic to
-- 
2.43.0


