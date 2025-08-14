Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E9D5CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 15:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31FB9900191; Thu, 14 Aug 2025 11:34:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C298900172; Thu, 14 Aug 2025 11:34:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 189FE900191; Thu, 14 Aug 2025 11:34:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 03261900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:34:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B77F8BA7B8
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:34:34 +0000 (UTC)
X-FDA: 83775760068.27.6527083
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2070.outbound.protection.outlook.com [40.107.236.70])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9C7F1180011
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:34:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="YgA16R4/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.236.70 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755185671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6yUiVOmVxuU72JxpsJZhSRgH6o0kl8/xMLa+WIVrPk=;
	b=ISFi2nZ8ZrTpa9K5tbDJTazNkla3hDAxdAv225tvstXuUv2ohzksYpaqTbSxa0eEVHaJkW
	pZM7kcodlUEGiVGFZoF3osXasZXDVgIzNwXb5y80p5J0AeAlWRDbN7B94h5JOTY7Pa6DC2
	pWaMC+8JRtFfnCIYNeNhaQAB+azyz24=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755185671; a=rsa-sha256;
	cv=pass;
	b=7k6XVT+LmH31VUfXy98DyNRQR5gnpGbBEqjqD98D6lVT41kBukEhqI7bSmKr7skuJMyGui
	DMM3is8CNBtxgg/bDL4EUoM/FFPVlJF8UJ02TGyOjKL5oR5JUtVy3Tk9cAj1TEI4wvlIyx
	UBCZjr/VFRHp/6GolGfBoCuTWAfkgus=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="YgA16R4/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.236.70 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H9Ey9ore+VT8m/tiRLdr9s9RjnR+NuNvTofr4/ti2lm2Q8op4LtHg6pt47S0wbirTdJfU8XogSmOyquZm8RLoadrffkMA7BSEdc6uLEod07s7k4cIxHi5qJE3krLUI4arpM9sJY6VLtrtPvpNBn+H+lQES8hshpcb8WNIyTdTXXmaJCwadxY4tdzpIXCgyetgW6wgPWmc3AAA9YrUQ/bhH3KLVvklEmBTZjH6RR/P9WDvxidzX2YNCqMUDk1hJfOzOxSl6h2ePcqubm8+dpDcEJ2xi5jPmmIo61RUlZeIuQAK7MKoQQjA7UftTdVhz4DdGIUTjsKpq3MkzoXmhKZbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/6yUiVOmVxuU72JxpsJZhSRgH6o0kl8/xMLa+WIVrPk=;
 b=nBCUIfIrymmXSYygrDNuwMAKp12HR5QuDjCKUnUxDT5X9tTFA7cjRBhPMtltkdpR3cwrz/mtgT+o5U0HbPFdIe3cyGZ/2LBNJ5XYpM1N5vSjir8yYxVPTar6T0hhkm9/pURWxWzw2bYhVhocmOxSHbWjDayel3vkvLHyHijTyQmZKd5Q15eG9ndrHUMnyYJjJtIvGg4ZkWCJ0VOBv8K8pV1KdRjTRg42CSSEBP2u3+dC+ZYR3hB773+WgPgpMYPVt9HRe0juOpFfXMX/D3Svy6ywlB7ligyuwPBJJLLcepLO1isFrnp1+Bzj0HHa0MKajsvVoPm8q2aMjzCtG3ATZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arm.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6yUiVOmVxuU72JxpsJZhSRgH6o0kl8/xMLa+WIVrPk=;
 b=YgA16R4/mFSD+z0Vn0U3EaQ0aJmWod5efqhDPWiK8Jjmi5Yfa48AycQX9wtV68Nga6Ji9g1MAAtlNVFVC+VnOmZUdkRjrLpFm8RgbsKMxnVY+p49cLyLDlznKgMlrhoQ28kwkqvJ1ojbOIV0BT2Sx7r8gq3Mw0qNh0Jj1JQd1xo=
Received: from BN9PR03CA0475.namprd03.prod.outlook.com (2603:10b6:408:139::30)
 by DS0PR12MB7748.namprd12.prod.outlook.com (2603:10b6:8:130::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 15:34:27 +0000
Received: from BN3PEPF0000B072.namprd04.prod.outlook.com
 (2603:10b6:408:139:cafe::84) by BN9PR03CA0475.outlook.office365.com
 (2603:10b6:408:139::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.18 via Frontend Transport; Thu,
 14 Aug 2025 15:34:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B072.mail.protection.outlook.com (10.167.243.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 15:34:26 +0000
Received: from tunga.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Aug
 2025 10:34:14 -0500
From: Raghavendra K T <raghavendra.kt@amd.com>
To: <raghavendra.kt@amd.com>
CC: <AneeshKumar.KizhakeVeetil@arm.com>, <Michael.Day@amd.com>,
	<akpm@linux-foundation.org>, <bharata@amd.com>, <dave.hansen@intel.com>,
	<david@redhat.com>, <dongjoo.linux.dev@gmail.com>, <feng.tang@intel.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <honggyu.kim@sk.com>,
	<hughd@google.com>, <jhubbard@nvidia.com>, <jon.grimm@amd.com>,
	<k.shutemov@gmail.com>, <kbusch@meta.com>, <kmanaouil.dev@gmail.com>,
	<leesuyeon0506@gmail.com>, <leillc@google.com>, <liam.howlett@oracle.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <nadav.amit@gmail.com>,
	<nphamcs@gmail.com>, <peterz@infradead.org>, <riel@surriel.com>,
	<rientjes@google.com>, <rppt@kernel.org>, <santosh.shukla@amd.com>,
	<shivankg@amd.com>, <shy828301@gmail.com>, <sj@kernel.org>, <vbabka@suse.cz>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <Jonathan.Cameron@huawei.com>, <dave@stgolabs.net>,
	<yuanchu@google.com>, <kinseyho@google.com>, <hdanton@sina.com>,
	<harry.yoo@oracle.com>
Subject: [RFC PATCH V3 05/17] mm: Create a separate kthread for migration
Date: Thu, 14 Aug 2025 15:32:55 +0000
Message-ID: <20250814153307.1553061-6-raghavendra.kt@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250814153307.1553061-1-raghavendra.kt@amd.com>
References: <20250814153307.1553061-1-raghavendra.kt@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B072:EE_|DS0PR12MB7748:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ecad30c-670c-40ac-5238-08dddb480db2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Py1TkQi0/UjwyEVgoUhf3vHIx0vjwvzOW5sVwZAmRiVxQyrawxkHrAytR5d5?=
 =?us-ascii?Q?KfGLd2kPDyXQKZR5DFJ2cHXmfrwaC4RrFe9EGYV82enaY6SFTpvGjko1G4nl?=
 =?us-ascii?Q?o/X+2rhw/9Xhgm0dibSEL5FXN/BjVR17LdGy7Huc1RJVpFviFkRlOWnHJvlA?=
 =?us-ascii?Q?KZ0yEiwbHJGkdO83NR1LIj9AKGQnBR6LGvJ8g7tEZ6sqoCMB/qAjqpkJv7lV?=
 =?us-ascii?Q?XDvGLeqBJXjbbvMwdUTT3XqALW7Egy8zyUG8TvDs9wMKYMDQ7cx3TXQ3G2Gg?=
 =?us-ascii?Q?6gKd4sUabzB54q59VAZ7MiQY2ecLIRvz+IKpg3fmHz1CYToLfBu48O8qIdVE?=
 =?us-ascii?Q?cgI+VTwhgRqG3xojfI8/M5xB/Q+d1fMo747sjTn4jsB6KBMsJ50Lc/nAza5S?=
 =?us-ascii?Q?WCXOrv0n0cCkwg0Nzz7ZDi8jfiWGoZke18UOiMtuZR0vZLA1/hFKztA4TNq8?=
 =?us-ascii?Q?1MGHRVppG0zCqWLPjGhken5ke75AZmysJasyRL/thLEMwx3lWgg1zKHHJZro?=
 =?us-ascii?Q?ep3EzpmFeOVr0P3w5iwCxdP+n7K7Nv89uihw6QoCl16jPxSqA63yJ7se7+CK?=
 =?us-ascii?Q?wjE1spFHZPcmXWjUMA2//zUhPTiOlkiE+r7DXg+xmIniy9AflkqKNfLYvbHH?=
 =?us-ascii?Q?vPTFn2DQlJtA+Av7dFny9fkt0uC7xC/023M5eOawJ53JkD/VTrXiiwQzTQ4W?=
 =?us-ascii?Q?v4pe9PLb6DhFPV29H+V1n+oDqp1/yN16Rk5cGC/F1hYu4txNKGSOoKzLTVc6?=
 =?us-ascii?Q?WbeQxMP+Y6CFd9rBH13vNHxtlCu8657ipn/D1ssbUIo0N81oIpPGf5BSsHPo?=
 =?us-ascii?Q?D3oQGzdBmXGBAzHWY9YX6KC5HA1ZcuUIWxsULM56Y+kUkFmaLjcsHlR3F0L4?=
 =?us-ascii?Q?vuJzNNbVW9sRwyVIyxPm6ROEVbpd6bv7rnxSFRebXejyCsPnVeebE5j1uQhl?=
 =?us-ascii?Q?ABLr+2NNcDdOlIub5jtOjgUOwlS5MEUin1QtTmFo54PlZxk8QY7LMqBR/6Cj?=
 =?us-ascii?Q?uStOqulQc+UgexNIfZK65DXeZyNt9DjkGKRwBgsCMWyELeDgnrEo6lZ/xLq4?=
 =?us-ascii?Q?8Rd02PCFEeGlK0ei2NYxKZbQTQK7PzhXuqUorka6/qkdCxn/kwYtL74cLE1E?=
 =?us-ascii?Q?hk3GOsr/LauwrugO8DQE4VntyaNph7OdBVHI622u8qXicfOcIDEh0FM41nl7?=
 =?us-ascii?Q?YSzbw0+EtgCBDNv1yhJOjh0Cgzr851DXR5QlwqMNkJctZ/3S1Sk9BAK2YnK2?=
 =?us-ascii?Q?g89nlWhHMBZfsgVkSvYWrlDQk437zsMqS8DfHgM5DL0fiMSGa9w+AS0L35Ny?=
 =?us-ascii?Q?nreHpTkiHx04xgeSQ9eU1whnC0vSf0ky5YDp6Qgqtx44RwyHNsBk1mmBx+BN?=
 =?us-ascii?Q?UcZrdq34JXBC4FHuvf7M8FkoMiGuHaiTZ3ColrF3np3QiuP3Rz/vopOzoRAI?=
 =?us-ascii?Q?1qeXGvaqFJ5RsUEUW6NNmsj5Sossa/nO1iEol2Y5bz8NoU0/uKdR3lyVZ/T6?=
 =?us-ascii?Q?e70ZensNJYXuO7gj5kTR9v1wJKxd+njdPqXb?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 15:34:26.9960
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ecad30c-670c-40ac-5238-08dddb480db2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B072.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7748
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9C7F1180011
X-Stat-Signature: sd7ze3o3i3m4oir1axjo3uihria9h74o
X-Rspam-User: 
X-HE-Tag: 1755185671-36922
X-HE-Meta: U2FsdGVkX181cZpivqiKawSIQDaqjVTUqGhdPYATP083Pu7AyfPaphD337XnoeGAfrqTI2g2ne3lVhwOH6Bt13P15/i6oyLwW4owu4t/TNBD09tE5EJkeqZDuXWW+RBHeb72WR1t5VfAMeohWXwL1177iomWxw7h5sREh3j1O5lCk12GbiG1KkNI3lppM9cY4HX94ryeKUnoPqw+Ym0jjZ60ds3Bg9LdJJ2WTVsBp0N5RwmREOo9gfCPnwD9BsKEWd3IlHPGA8g4SWZHiMb1r9KPtP7WgEP/k2qXzh6JfeAXo/andW8TlkRDZrmiThk6DFOqJJhlwhLzyRACukwm91ljVp8ZWFKMiF7yY5DVJOEVuLQkyQdB86VHApUz4PaZJyU99HYgpZeeSwvpgOyn1CgCP78cPic4jdxn760ExgFr0Ev65pc5Hdm9A285o+tihlOOo161Z3d9Za95/xHcsTxkWiXKriiVULnWW462NE8g+lt5N/gnqKz31HPCZ+0mlH7Swk7L2DefryVXa6kuU9ndZ1Ni2VMP7CqTBvPelInqIyIWBx1F4YiQY7BkCWBwUR2xe7LcI1cPRJ8nurI3xfuaSg5Pl0Sc7auNJiAzPIqh+v4D9HyQfScsoKge8UeF/O/mkuZTyo6WtVInmzsRZrLNdIB5HVxBvuwoYZ+/q5aD7uUk4FSbdgeloD57yjjhPgmNNttjXj0oyzkFFcj8lM3PwNf+WtGW7EugA81C4dJctTgxB2Q1E8AksUOVsDxkzB3j78d+n62Qa9Fbjk5EW1rSIht+2ktDD4L251NnqtIZ2Ca7wW9QZqT0M83MxtiFap2aytIFKYuQMqjuoxtL9E1h/om6FcgPG8qVQQzu01yd6991QSwvcqzbugFkgdpWVfgx626fSIJ+C3323/76407HnwCLn3oOBjL/1Guz48IC8HFxQOT1HEjyenaGSSwgdIypQTElX3A3Agc+cRh
 uPl8vwVy
 322KjHiy+qbvTVwIZaR/znJj6gGU1qhxIYSfyWydEVCnE9VIlHKsbQaGFdT/I7lfZ9h2YOKg5WBNqtpWqSci8cKwCnTq7zyvYiKG46UZByISr8BOnQkoMbV95nHuRt6YM2XCIgfyRTv/541FkSoKWPkz9IpyGE5/TvwZrrqxlXhV5XD4jvNYkIiNvwk8qK3ovBrh2lYVY8V3+Y/ZArzrSTuvaIvIwgflZHgKmNQ6Zavv+M+yOCLnPAUqTopl55mjDFbe2XVfr4LO0VLwmIzQ+gqaNeNlyHuhsTq0V9B4z9fY/tUZ934KknfFEVXkQ0I0CdHrYZyOWaK3LNWA4hLbTzxftQMguv4FVKkw7BMbJLMzO+U/QNvtn6YKh0UAEsotz0yT7PBl2uuV3a9eCacaMcLMweDnB2D4AFz54lA5vRV/xKS3RW0c1+sdNa8JW1UVcv89W9ShS/w/sVQ+7XwgapOpqcL49KFCshekDK7LeOGh9VJ/RA22KAZMxmbPnnZc/IS5BNIhWWhlgesyf0KV2NE+ptS2+a1Msjej+x5R1liaw7Sk9E1TyakTlh2VwdevadLRIakhZuAjEpvZBPo4V8E81m5Aetit1o3Z39mR0ZkVS4T9Y+R4ptv0glGg2rWZcfjxdsWlQyundZR644V5o1/GzeCGZ/qXnS/ieQWffzg/dWwgwwelJ58hACZs9t/z7Zp97W49aagkjaDBFD7DXqdUSP5OkgHJ5CkFUoVpeGY0NqHDLqjYU9G6kT18whMPr5wyaHa89ieQCg4fSdhqXoVwHvqJzHo3ATG+o4B45a5cnea73/qLCJxvVvvj70FAixt9G0PAM8iSkecpSobnrrDgbv+R4/onKYd8TcVVL14Yp9UPi3StzaJscyqOyiAupIGuNG549rX2KPD8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Having independent thread helps in:
 - Alleviating the need for multiple scanning threads
 - Aids to control batch migration (TBD)
 - Migration throttling (TBD)

Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 mm/kscand.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/mm/kscand.c b/mm/kscand.c
index 7552ce32beea..55efd0a6e5ba 100644
--- a/mm/kscand.c
+++ b/mm/kscand.c
@@ -4,6 +4,7 @@
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
 #include <linux/mmu_notifier.h>
+#include <linux/migrate.h>
 #include <linux/rmap.h>
 #include <linux/pagewalk.h>
 #include <linux/page_ext.h>
@@ -41,6 +42,15 @@ static unsigned long kscand_mms_to_scan __read_mostly = KSCAND_MMS_TO_SCAN;
 
 bool kscand_scan_enabled = true;
 static bool need_wakeup;
+static bool migrated_need_wakeup;
+
+/* How long to pause between two migration cycles */
+static unsigned int kmigrate_sleep_ms __read_mostly = 20;
+
+static struct task_struct *kmigrated_thread __read_mostly;
+static DEFINE_MUTEX(kmigrated_mutex);
+static DECLARE_WAIT_QUEUE_HEAD(kmigrated_wait);
+static unsigned long kmigrated_sleep_expire;
 
 static unsigned long kscand_sleep_expire;
 
@@ -79,6 +89,7 @@ struct kscand_scanctrl {
 };
 
 struct kscand_scanctrl kscand_scanctrl;
+
 /* Per folio information used for migration */
 struct kscand_migrate_info {
 	struct list_head migrate_node;
@@ -134,6 +145,19 @@ static inline bool is_valid_folio(struct folio *folio)
 	return true;
 }
 
+static inline void kmigrated_wait_work(void)
+{
+	const unsigned long migrate_sleep_jiffies =
+		msecs_to_jiffies(kmigrate_sleep_ms);
+
+	if (!migrate_sleep_jiffies)
+		return;
+
+	kmigrated_sleep_expire = jiffies + migrate_sleep_jiffies;
+	wait_event_timeout(kmigrated_wait,
+			true,
+			migrate_sleep_jiffies);
+}
 
 static bool folio_idle_clear_pte_refs_one(struct folio *folio,
 					 struct vm_area_struct *vma,
@@ -537,6 +561,49 @@ static int stop_kscand(void)
 	return 0;
 }
 
+static int kmigrated(void *arg)
+{
+	while (true) {
+		WRITE_ONCE(migrated_need_wakeup, false);
+		if (unlikely(kthread_should_stop()))
+			break;
+		msleep(20);
+		kmigrated_wait_work();
+	}
+	return 0;
+}
+
+static int start_kmigrated(void)
+{
+	struct task_struct *kthread;
+
+	guard(mutex)(&kmigrated_mutex);
+
+	/* Someone already succeeded in starting daemon */
+	if (kmigrated_thread)
+		return 0;
+
+	kthread = kthread_run(kmigrated, NULL, "kmigrated");
+	if (IS_ERR(kmigrated_thread)) {
+		pr_err("kmigrated: kthread_run(kmigrated)  failed\n");
+		return PTR_ERR(kthread);
+	}
+
+	kmigrated_thread = kthread;
+	pr_info("kmigrated: Successfully started kmigrated");
+
+	wake_up_interruptible(&kmigrated_wait);
+
+	return 0;
+}
+
+static int stop_kmigrated(void)
+{
+	guard(mutex)(&kmigrated_mutex);
+	kthread_stop(kmigrated_thread);
+	return 0;
+}
+
 static inline void init_list(void)
 {
 	INIT_LIST_HEAD(&kscand_scanctrl.scan_list);
@@ -559,8 +626,15 @@ static int __init kscand_init(void)
 	if (err)
 		goto err_kscand;
 
+	err = start_kmigrated();
+	if (err)
+		goto err_kmigrated;
+
 	return 0;
 
+err_kmigrated:
+	stop_kmigrated();
+
 err_kscand:
 	stop_kscand();
 	kscand_destroy();
-- 
2.34.1


