Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DEEDD6101A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 14:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E758F6B009B; Thu, 29 Jan 2026 09:45:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53AD6B009D; Thu, 29 Jan 2026 09:45:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D492F6B009E; Thu, 29 Jan 2026 09:45:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C1CB56B009B
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:45:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A1B191A01C2
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:45:38 +0000 (UTC)
X-FDA: 84385275156.20.80D5064
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010033.outbound.protection.outlook.com [40.93.198.33])
	by imf24.hostedemail.com (Postfix) with ESMTP id A3D4018000E
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:45:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=cnoy0QGr;
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 40.93.198.33 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769697935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jrhZvi5lUR5xhpRCQztNG0dMlnwfthGgJ82DPdnCgXY=;
	b=irLJTXGV0Uiey8R3/OrPpPrl59A39L85VM2V4w9rTs3mH1Eqn1YIOH9+8sdWfSnghY69qe
	GaXfXK7nV5HV6xnXSMmFHSZQ+kEZwQZoiue19GnjLgfZHI8rPnkQBABygTKEm3CsunLVWZ
	67OFWd+JH5qvt3iWJGeq3kSEn1m2PPQ=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=cnoy0QGr;
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 40.93.198.33 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769697935; a=rsa-sha256;
	cv=pass;
	b=YTzJIvFoekCKbUrA7z6KI/2n9KON97Ph46SYowUcUCXd/NV3PoHGGDDRf69k0se6Xq33Uu
	1nrZJ07BZqHp2aZIFLqjKqhVxSOdX/mTyfulTHb0wDI1ZvlwPcTZZM/v74UxblT2FmhGEL
	AIWJDkvvaJ48wR1Skhn9CWNH7JqJtwE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rLkqCZAnEZN8p77QOam2PsopKyX2aZcC9C2Df8QUBPXxqsRW0w8fLS4uhh4TglRUQo4As2Pmo127IwQ1OhcavF32WpoyKeCoyxcCbxtDce3xox1Fu1ZrCmwTMSLlem+4QSfn0q7gdW1YgLhk7BebpoUg4F4VjB9yAWWl/mtXQTK5HsJO0TXFqcMXLalov7g6OdTIHbHr1yx/al2tqdsJGUZKOgoWFpE+I3iQ5AZZT4JjBt9N9Sd7EHZw0vJK8deFM/lH/Mkptrk1g5AQrGn2wYNj6pfeSgwz2pY2DnK2+Pf3AXZpgOaIHgYaoQ7UZHup6hk6sr0PJFlZWlUZ59oArQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jrhZvi5lUR5xhpRCQztNG0dMlnwfthGgJ82DPdnCgXY=;
 b=a4v7kW4b+56pLytCFDIYg8H+2EaN4w74Zj4TdXubKwOxMEQkSpK1Ks3YtOrSf2l7VxbZ28nx2LNfGY1sg64JoVNhC/kV/0Sc6pQQL2yPQsiB4uSEAyZAWMOzTeAPmss+tQyeP2DriASWBB8XuMc9eqaJwSktwtVm4u/E2/bSimKq561a62n9oROgeCPQQgImoEV10BcHTcyzmXznM6YV0lFHQ0gwjvxQooEH6YndeoLy1khlEJbEGZeHTqe0QdtkCI3gFlgYR7ycMf0o+RvanNBjyXwAyEjcOsHh43IUNfXilsqFpCmV0eMTSIDizvz3mqRPAZ66AlLUg49Erjy9eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jrhZvi5lUR5xhpRCQztNG0dMlnwfthGgJ82DPdnCgXY=;
 b=cnoy0QGr7m7gin8mmUwez4aywKuD1RAFPv21dp8l2yl/+Zlz4akhmRsWlqE0gA7cSJVDDwQFe13+0ntmO6PllSe4R4yryBry3qctug1MA4KTusFGi2ImGWIYRUcAcQbMBWZJ1m0lYbLE1Ppb1VXy12g9wgM1blzOsJMjOm06+YE=
Received: from SJ0PR05CA0181.namprd05.prod.outlook.com (2603:10b6:a03:330::6)
 by CH2PR12MB4136.namprd12.prod.outlook.com (2603:10b6:610:a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Thu, 29 Jan
 2026 14:45:30 +0000
Received: from SJ5PEPF000001C9.namprd05.prod.outlook.com
 (2603:10b6:a03:330:cafe::ef) by SJ0PR05CA0181.outlook.office365.com
 (2603:10b6:a03:330::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Thu,
 29 Jan 2026 14:45:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001C9.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 29 Jan 2026 14:45:29 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 08:45:22 -0600
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
Subject: [RFC PATCH v5 09/10] mm: klruscand: use mglru scanning for page promotion
Date: Thu, 29 Jan 2026 20:10:42 +0530
Message-ID: <20260129144043.231636-10-bharata@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C9:EE_|CH2PR12MB4136:EE_
X-MS-Office365-Filtering-Correlation-Id: a61017e7-f960-49fb-d3e5-08de5f450c85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cwnqM4I2Oo0fkFmju+yD9koMiT999G1yqkBqVE5OSyxdO7ECR9KuQZVade4W?=
 =?us-ascii?Q?KDF3OIX/wsJ2inA8rSZqJglVE4sAS/YYJhb3BYiKOKoIMVO6BXV9qTpxxnxs?=
 =?us-ascii?Q?44nqAiltDYOeZYn/2qo/4A2LcTfwnF1lxDiMD8Nr/ChVKBQIA3oI0l5sqVo3?=
 =?us-ascii?Q?VfnskA1EPTNG7aFLIb87DnT71HZ/doOpynubE4beOyEQXqc2S+lHt1QTgTlF?=
 =?us-ascii?Q?s0INPbOcv0y6QJNHP27HiZM9hEl8DrGZicKuIRe38MV7JnHovujIvrvqP47H?=
 =?us-ascii?Q?3K5L533zJSkDU1HoZBCri8xLDDRkhj9wU589E3CvXjb6yJp+P4mHnZEmNiYK?=
 =?us-ascii?Q?l/YdTKce9eHNUWavk92fE6NvGZCn5iPUmcwz0jLPRrTjrD4vCV+9JRuQhoDQ?=
 =?us-ascii?Q?vbD/OsXpgbe+n9k4fjdaIECaMrrlen3DtZemMzL41SXfJjzybNdUJ2rnnU6M?=
 =?us-ascii?Q?gu34UVzGWNf0LkfP8m7+2d5jeVgk1sBNmg9tCo+BdnDDfxiY1MUh0SsR0FWq?=
 =?us-ascii?Q?3uPRgIuXn8QeGicwSBvC7htgeNyz/0w/grpeNSTfGzNxdPP+MeK6hd0B+sUw?=
 =?us-ascii?Q?Ku87ZvWhYyqh40NZa+mv2zLcaHpDxskmrgt9aRYQge15FjmT0r8MuNbPHr4v?=
 =?us-ascii?Q?y4CizfpGT/Qf9ETRs5mvuH3TjRUpa9bjOcuduRRquNHJcU0dah5U/pPjMN6G?=
 =?us-ascii?Q?y6SNbuUt/8WU3akPrKXVXe5JJ3XXofMdb12AQ4rxwkacv3FLfVAiygGJFHBR?=
 =?us-ascii?Q?Ex5rnXGGB7TjgD692oXIsJlijTDQGonY29JwLnAn749oyuJBSjAPf3dJsRcI?=
 =?us-ascii?Q?XJdpkS8j8suMccHiOS8rrRmsuqxXaqXQR3Ty6laGOAe2IU3l5YhtXQfmz5bN?=
 =?us-ascii?Q?A4YntRzH+4b7k/ZPRQGAl18ItsISFtSxI9g5cLbExjatEpm8Zxrbbfb+MxyN?=
 =?us-ascii?Q?+rcxe4v9Zs8uP4G/6XizCQYJgpZXETXyBnvRocbsAwIEKmtILaOdmRCiIUzD?=
 =?us-ascii?Q?8H7TkOs6pHx1865jJ8iZ5+025l/I0lkOAZC4koMeHfIileCNAUPY2VRFGq9J?=
 =?us-ascii?Q?pdx0pWv/CVeGeN6NK1HCX4dHE5IuneM+l4Rv9buGZTSLuhH41Nqm/Pr0ZDL4?=
 =?us-ascii?Q?9UYydVyr7SiUMVyAjviilN7WENDA+4SoigOwPMzW1OWggNQhwsE4UMhiYR7V?=
 =?us-ascii?Q?o2fXIozl5VW10I0H1OSB6NQ4YBbAE5/I3V7XVOHhFINzGllOqi0MrGOgfnMw?=
 =?us-ascii?Q?q9TiLheH+L77mmJaeOq0Qte46ix4GNjBDW/v+njsl7vF4v5g0qxUniPDcxZD?=
 =?us-ascii?Q?ESX7qBg5GHSAVpV8uhVJqbq76hwQ+IOg91lWh+z0AAUCifQsGlPcKJxzV/O2?=
 =?us-ascii?Q?JCiPHE36A0IVBNyrRsqp8OqnR+mg0yS0HSgTskeSQVYw8Ga7mNdJL1jnV7HU?=
 =?us-ascii?Q?4dAVb57hW3n+tHJ6XY31skEU/TixN4cZGCc0EXCkmvVZklFjU2hcJIGgnJQk?=
 =?us-ascii?Q?6x94qonikCecSidk78UmtFym+/XWTrJeqQ8Vigv5pdJsfAOD+OGpA0qFXITA?=
 =?us-ascii?Q?jJlUXbZuCxlkzcFNOox7eVBkV6FdkRMwoI2RRFYJ9f1qBxoM6zDk7ZhRVKNB?=
 =?us-ascii?Q?XbPvLDN9W7SSy/0kuRzsr8yrFsnktaUUG+ecS5jF2s16ilvewas1ur9utngA?=
 =?us-ascii?Q?JDe6uw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 14:45:29.9321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a61017e7-f960-49fb-d3e5-08de5f450c85
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4136
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A3D4018000E
X-Stat-Signature: jxx1fyh4harydnu5qcn5azd7gmdz515k
X-Rspam-User: 
X-HE-Tag: 1769697935-148984
X-HE-Meta: U2FsdGVkX194GGOUaAZFJGzXe9jzH8FpRf7izlFm/nA0/bz7eSce9HAy2asP581TKsb20ldWD5cCa62tMoZl/H5LPBNFhBfB1dgGsmnBRzyHxl6GKs7hvCecwWOwBrSaZqGJiFWIWnxSQwXfC2Aq7v2bgxYgUe9Qd1CAmHtWrtZAPQk3i73LgnJKkrCdZAgIxqIq5z0gJwBqTOuhlp6MOCwF8g9qeUjK+zsb2j24BwkvrX+P7/DxVCMaJF7O7i/uD7YGxFImUlAWmrvjwFkTMx0BURfBBpFbXjmt+ASAD5AtcJS6pk30UOmcIKBoQSwZpVR3CNLDV97cERaWJZGGaCnh+1NX8dcB7xF1Yc+Mk0JqvGRT1WDaP4qMlhLoAJGGB4bqP0qMjbfDTxk691rChm87VWI7apXoVOSMmOs8vlhK4n6rW6pMktR2MANJcvBX8MzTAveBcQ0rdCY3RmS2daVJG6LwAm/l+DT58ysdadvYFA0kKtYX4Q10EumGwH27z1pT7176HmtOSjKjngR8cNkHJv7r10BFjpTjQXPRQFCRIiqK5GMrBBKZK+C6O4doWId84+fPU2RvP8PHXN0xbnb2R335fX0v8u4/y9E6tC95+j9EkGTtYSi5x0WavS8dQHXY9Qq+9WH5qXTyL5m6EDRwKQ8Iu0h8oeVeciuaYVoaIvTLdAdvv8EIxZyfyPQewn147jwvEfpxqCE8GK73uB9SrVn+KEOXcDpsrMY3Yu7ylFjBw0s4IgTNm8Zu/CPRQ81wIQCCz0M+gvDNRmOeOjrWr3jmiMUp4J3tM75W35cZkEV4rOwbHrj9cGjZBZAfxISi/hDbOXogoBnbOldO5zq1FYJSz4kZdkeXM06bqOvVPsAp9T7TbQSXJZH0vfjTs3w4grSwuq8fuM5wmv8dpzGDAp19cwqdKNjE10/KOqZPIEV3JCm1o7EL8VKtcL8XAulXajlaunP+EVCn92t
 3zJZ3OXP
 WcZTYmuxZkwTgqocfC8VOdiLD9u/FTBrUZbWfc/409K5P/p2nGE99ZsJCRasP6VUSSp1ryBcqVqcnUIiLM4n0pgSmZglokD/6OkqmB2+VRluoREV7iEHLRVN78U25Rt720m8YsTB0Ilfvo8IWvXhO/LqPjv3P6vFzFZsc1MXeO6r00tCSBBAwNuOBewW9aCTv3vPyYEY7b0JugxohjnJ1pYp3h4iJ+H8jCV5hBzaT9XV4mrIxAaDWjv5XfJ4OLeFrctvXngG97XH4IazMW/AcYiNJDBlK9CE9PVSaEMF4ye+kYrFiqZ54+9x58yO3Zuam+DRGVCD1v3/X2vbiZtrDsLINpU6WKha1Cf7sdhs23hJAuNEEYwSZS4g7x3JMH0+ICp6XB0i9zQnbBrWar245lYmA4F3SZoCe3sA2W+jT5QUFCUwJntHVBzYLTxQw++GOwG6I5mq5kM1K3Kdro00IjvcnfBew0ylJ3Zd2pbIaFG/AeqEPCF/6Gm0OPhSWSeuG62nnKZv3bRn1e1qonaUnUlTKa6jZ2k5cAYXqQ73IObZrfV9nZ15yBlHzNHIsYzPp8JE3xhXJV/v7ySs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kinsey Ho <kinseyho@google.com>

Introduce a new kernel daemon, klruscand, that periodically invokes the
MGLRU page table walk. It leverages the new callbacks to gather access
information and forwards it to pghot sub-system for promotion decisions.

This benefits from reusing the existing MGLRU page table walk
infrastructure, which is optimized with features such as hierarchical
scanning and bloom filters to reduce CPU overhead.

As an additional optimization to be added in the future, we can tune
the scan intervals for each memcg.

Signed-off-by: Kinsey Ho <kinseyho@google.com>
Signed-off-by: Yuanchu Xie <yuanchu@google.com>
[Reduced the scan interval to 500ms, KLRUSCAND to default n in config]
Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 mm/Kconfig     |   8 ++++
 mm/Makefile    |   1 +
 mm/klruscand.c | 110 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 119 insertions(+)
 create mode 100644 mm/klruscand.c

diff --git a/mm/Kconfig b/mm/Kconfig
index 07b16aece877..9e9eca8db8bf 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1502,6 +1502,14 @@ config HWMEM_PROFILER
 	  rolled up to PGHOT sub-system for further action like hot page
 	  promotion or NUMA Balancing
 
+config KLRUSCAND
+	bool "Kernel lower tier access scan daemon"
+	default n
+	depends on PGHOT && LRU_GEN_WALKS_MMU
+	help
+	  Scan for accesses from lower tiers by invoking MGLRU to perform
+	  page table walks.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 89f999647752..c68df497a063 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -153,3 +153,4 @@ obj-$(CONFIG_PGHOT) += pghot-precise.o
 else
 obj-$(CONFIG_PGHOT) += pghot-default.o
 endif
+obj-$(CONFIG_KLRUSCAND) += klruscand.o
diff --git a/mm/klruscand.c b/mm/klruscand.c
new file mode 100644
index 000000000000..13a41b38d67d
--- /dev/null
+++ b/mm/klruscand.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/memcontrol.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+#include <linux/memory-tiers.h>
+#include <linux/pghot.h>
+
+#include "internal.h"
+
+#define KLRUSCAND_INTERVAL 500
+#define BATCH_SIZE (2 << 16)
+
+static struct task_struct *scan_thread;
+static unsigned long pfn_batch[BATCH_SIZE];
+static int batch_index;
+
+static void flush_cb(void)
+{
+	int i;
+
+	for (i = 0; i < batch_index; i++) {
+		unsigned long pfn = pfn_batch[i];
+
+		pghot_record_access(pfn, NUMA_NO_NODE, PGHOT_PGTABLE_SCAN, jiffies);
+
+		if (i % 16 == 0)
+			cond_resched();
+	}
+	batch_index = 0;
+}
+
+static bool accessed_cb(unsigned long pfn)
+{
+	WARN_ON_ONCE(batch_index == BATCH_SIZE);
+
+	if (batch_index < BATCH_SIZE)
+		pfn_batch[batch_index++] = pfn;
+
+	return batch_index == BATCH_SIZE;
+}
+
+static int klruscand_run(void *unused)
+{
+	struct lru_gen_mm_walk *walk;
+
+	walk = kzalloc(sizeof(*walk),
+		       __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
+	if (!walk)
+		return -ENOMEM;
+
+	while (!kthread_should_stop()) {
+		unsigned long next_wake_time;
+		long sleep_time;
+		struct mem_cgroup *memcg;
+		int flags;
+		int nid;
+
+		next_wake_time = jiffies + msecs_to_jiffies(KLRUSCAND_INTERVAL);
+
+		for_each_node_state(nid, N_MEMORY) {
+			pg_data_t *pgdat = NODE_DATA(nid);
+			struct reclaim_state rs = { 0 };
+
+			if (node_is_toptier(nid))
+				continue;
+
+			rs.mm_walk = walk;
+			set_task_reclaim_state(current, &rs);
+			flags = memalloc_noreclaim_save();
+
+			memcg = mem_cgroup_iter(NULL, NULL, NULL);
+			do {
+				struct lruvec *lruvec =
+					mem_cgroup_lruvec(memcg, pgdat);
+				unsigned long max_seq =
+					READ_ONCE((lruvec)->lrugen.max_seq);
+
+				lru_gen_scan_lruvec(lruvec, max_seq, accessed_cb, flush_cb);
+				cond_resched();
+			} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
+
+			memalloc_noreclaim_restore(flags);
+			set_task_reclaim_state(current, NULL);
+			memset(walk, 0, sizeof(*walk));
+		}
+
+		sleep_time = next_wake_time - jiffies;
+		if (sleep_time > 0 && sleep_time != MAX_SCHEDULE_TIMEOUT)
+			schedule_timeout_idle(sleep_time);
+	}
+	kfree(walk);
+	return 0;
+}
+
+static int __init klruscand_init(void)
+{
+	struct task_struct *task;
+
+	task = kthread_run(klruscand_run, NULL, "klruscand");
+
+	if (IS_ERR(task)) {
+		pr_err("Failed to create klruscand kthread\n");
+		return PTR_ERR(task);
+	}
+
+	scan_thread = task;
+	return 0;
+}
+module_init(klruscand_init);
-- 
2.34.1


