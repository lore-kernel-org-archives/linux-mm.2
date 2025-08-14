Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A4FCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 15:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED60190019B; Thu, 14 Aug 2025 11:36:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E85BB900172; Thu, 14 Aug 2025 11:36:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD9CF90019B; Thu, 14 Aug 2025 11:36:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B5B9B900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:36:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 881C9138761
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:36:19 +0000 (UTC)
X-FDA: 83775764478.24.A5F7053
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id 96EDB18000B
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:36:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=RpCTePc+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.243.48 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755185776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tH6WDjy9Gx73HB03x6/iHMIinsfhhhAxSTl2toAIzd0=;
	b=wgteu6mVHTBIO0f0aUEO5TMoxmGWsGzJfL/pU4IX+sju5n9QsKcZVP7ekdQ3zPkbWRvai3
	RPbdPdbV5KoZpuQ1cQud8I4MKFUBT7aVJrTQbcSWcl4BULz5jvprh2no0pODHBgQE6IiyV
	dXHa3O6ODkf84Kc6JQUi5RLzd1S4AzA=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=RpCTePc+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.243.48 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755185776; a=rsa-sha256;
	cv=pass;
	b=5qoWaMyuIcqGpJzHaFG56X00fDO5G+PimOTKi5ftDDP95rVFQfgakzjLaGlX/wXZ/lX1/8
	D81k05j8g57DetrHEPxPT+2iEP6cpiZhV2OrxiyRq80rD1WFRFcjD08FS1uKify3uaLNxe
	10OMbSnMLTmy85K7OcOmdIunoZnGKO0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ibiof957zINn5uoM5E9B/vDUdCdXXjjP4V9HuOPc8dT0WZXqXZrNaqvfziZj7rtwegIqfzufTP0ohbpdBhAPxyGs4cZY0wGjzpCoh2SNLOKj4liLiW+cWHNZKbhyrz4p5icBVbzCrqfOIqtZEYNSx00x5ObzGenYTyx5hVD5JFdQWzPCBlTWz5J2MysiyKza2US+Xqj/lwt80U7G1m8jbh+s/+S9WCHbgLyWFa/R4oVcCY2hV/NN7qLLJGNNHLrn8ObwpUuLeEs5o8KsFwEzVjPzo+51m55idTnklqrUea3nhF+AYyql240IAhsTaZkA1H22EAmxtl4Rsg8cDC2isA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tH6WDjy9Gx73HB03x6/iHMIinsfhhhAxSTl2toAIzd0=;
 b=aqt2iCANuvtX234/Z407lYgGNrnS0ZBa+AgKGWbiMSmEYT4bGgWT+2SSKx0A1DBTUuVg8yU24nTVOaXR71xb4d73/mYANFeC50s1DFn10vaNBM1NTOcE6dmT2+dXWqAMtsoN0FGd3PzP3To8vs2+F/Z1v4zratn0rMx5XHRAtPpYTdclUtaQxNk3fiAANPMLzFMk0AMP5w6AL/NMoJJj/oDNPgTUt5MZVqLZ27dQO9/UhTKm19ki5m0Clx07gPWJdWllMBDYwAIZSlf4QxbTLD2uLdJbCvSbR8fjMZxLH0JR2UnZ4Z3H4nhVVSAwqw2jDyYlzWh5p15/G50ZTgx1Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arm.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tH6WDjy9Gx73HB03x6/iHMIinsfhhhAxSTl2toAIzd0=;
 b=RpCTePc+sCJ9y+6HCyWoZWQPDboHNowAkeihTLEJ0iYZEa+3GtM4Dw1oGabhSRGc8bjWBhrXkqva1AfjzuSNiDZr7p1qp/vt7lLJ+vgCrWf1Y19iOL22tTyP30BkhUscHj5Nyb6MGIxssbSK/ltrc6msn1mkcaRRuzLanBCNp9Q=
Received: from DS7P220CA0011.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:1ca::16) by
 DM4PR12MB5820.namprd12.prod.outlook.com (2603:10b6:8:64::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.21; Thu, 14 Aug 2025 15:36:11 +0000
Received: from DS1PEPF00017097.namprd05.prod.outlook.com
 (2603:10b6:8:1ca:cafe::b) by DS7P220CA0011.outlook.office365.com
 (2603:10b6:8:1ca::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.18 via Frontend Transport; Thu,
 14 Aug 2025 15:36:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017097.mail.protection.outlook.com (10.167.18.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 15:36:11 +0000
Received: from tunga.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Aug
 2025 10:36:00 -0500
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
Subject: [RFC PATCH V3 15/17] prctl: Introduce new prctl to control scanning
Date: Thu, 14 Aug 2025 15:33:05 +0000
Message-ID: <20250814153307.1553061-16-raghavendra.kt@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017097:EE_|DM4PR12MB5820:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a9c6325-3791-4215-d5cc-08dddb484bb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Dn3vY73JARjYDEzuJ3z93MctRJg3ikfy7I8wI+I22KL7Ji3rOHlpzbimW2X4?=
 =?us-ascii?Q?39nikR0jaBiJFUf4Rt7sRb0+DqujXnbiry/0pElvkxozX+CWhlOr7TkxlSNZ?=
 =?us-ascii?Q?4Y++zwkuhD5YMUbAJjWvGgLoAt8fZF2184HHErNdF9koBW8VuRguOkC3O+hz?=
 =?us-ascii?Q?rEnQWuW3vjfbycX6ZMRr4jYvdngku4rZR8e5MBMcIO5krMC393qvTzzpiwBX?=
 =?us-ascii?Q?SSXwUcJzBfCs6Jck2eU5+7gNyL7UDs8iB4mzCVzk2N47Fg5VU6JU6mlRHMs+?=
 =?us-ascii?Q?YRXGt7ntESGrj+tdLrCnG9hIEVFDMiQ2lSdEHK/WwGz7X0xOatRJyeCc6Sak?=
 =?us-ascii?Q?5XomUWRKprZL6yxryWuoVM89+O2h63jH0mET6X0vEJc9h0xwBS/ktY7IdlgJ?=
 =?us-ascii?Q?QeGPp7mOlrDmig2DccqoQwvRwjpulJHjHtzkwhIVvDpBfci0rI1owiMB3JRU?=
 =?us-ascii?Q?JF6mplAimzL9ea2LBVzDpPvxbwTpvBNmn40ya3LZCjdDscgErtsAvs1xRPnI?=
 =?us-ascii?Q?JHKx+X76eKFCj8yMpIrd7sWhtQA8U9a+iGEPj8hi2+3tAqRFxcwxMi3B3ZZg?=
 =?us-ascii?Q?RFk9WaTF5JptYK3+OIQqNiMKOT5FjfPgOnx/y7h3/mbb2781uzpm59SgeafR?=
 =?us-ascii?Q?PIi9jy2kPSCj8rqgT1tn2Qgnxxqf0OSS9Pj2FRvySSIv1bhfSqyzbtGwgzyJ?=
 =?us-ascii?Q?AjSnVkn6JhbOCUpgyGO3n6Proio9fr3OM9oPQnw90pwD3dj1Ukr3vhcg2TcT?=
 =?us-ascii?Q?z/3cLOTHBILSMNx9ZIQQzM9qyFgpwiK0QiF3mMh4ppMDnOz8IC+HGlmWeDgc?=
 =?us-ascii?Q?+K9e6R2GUdHpTY2BGWrhy1kT01EZvhaUOLO5YH1TkWWIwyfM2HgOespYN4OH?=
 =?us-ascii?Q?NeSrzQYByUYDF2I+mop/nbQFXMHcc2rhOVXTf6CmzKyqc2PlyJngtS+1ByZe?=
 =?us-ascii?Q?N5inoEo7ZCEh6UeEZjexQGUTKc7/tiMs6xjHZreGnIoBHGndJj2aEc7mJIPA?=
 =?us-ascii?Q?AkHtS8oKVrHtGYpzn8cLYk1IsUHnQ+re0SWUgCbyweYF5U5STa493pZ3AkRP?=
 =?us-ascii?Q?kCBeHJXH6dWuwyDlA/3v2lay3R6JBKWG8zlA96SP5VpzLdEnQsQZMlrtFmgG?=
 =?us-ascii?Q?jiAhJjvOLtw603ftkv1QgAZKYBXybZORTHk2VuudSp0u6ozXpm/L6H94m7o5?=
 =?us-ascii?Q?wD1EHAfLOf5giIyHjzRdlY1udGgbjoNjM1HxEdlvmjM4dAlT/ztf4e0MZiKZ?=
 =?us-ascii?Q?tcSg2+cHhibGRREmaPDrER0oIuEkBCr49mfmi4HWPMpmU2JxEAILeQdY4q5q?=
 =?us-ascii?Q?rdRoUtgNsud5+tTxCSc+PGINBwETT9T7bBTZ23K5CSz0fFa03kN5EcN3sId7?=
 =?us-ascii?Q?BjFcAycoJp0DScuaYXXH6CuuIN4cON/cMFFAHEr7VR3SWP1cNaAJ02SP316X?=
 =?us-ascii?Q?8xhRScxMs0PXlO0lxWwdP4uhhplBKvkbUb6xmBH8jYpP2cMWou+jxxciQubg?=
 =?us-ascii?Q?dxHoTWv01Fpm1opEsKNEFthzfqfS68Pe5wb2?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 15:36:11.0205
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a9c6325-3791-4215-d5cc-08dddb484bb8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017097.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5820
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 96EDB18000B
X-Stat-Signature: a4hi56b3by3pxm19wy7erc8zot7r44d7
X-Rspam-User: 
X-HE-Tag: 1755185776-1563
X-HE-Meta: U2FsdGVkX1/F6c0nxmych4dmXZlX38HOfJpgzA4uc6oLYOdg9wv+aRqa2divCWsxEGvoLOLK0j/JqcoWi1AIP3XWJqXhWTqHn/faXwHAfQV5clW59anEJkkyIk/he6NMBDwuEWlQ9ClE0WdxGXwZEnu7+3OP39srBq9taFNHvHPTGYuqz3AwT2MS+XlxzkD5aO9YhUSEJ0MpFzcfD+sL9azkr1EKkP6BzrilT9OGSYB7HMpk94Dk59NHG8Z3fp/KOfCEZBEXk65UcA2XtizY654tSH0x0nk8oBFM6CYQIoDqQXXwCgyeGLDJWxcQaQy4Xc9cuGQEHPnWKuP3MDkkVNldCfcat6J4JaOUmi99kL8FbZoRbY4erglNKF7ZJrEVBOn9gjTVegH5S9GCPAftKi27DlUp3nNHKEnVYLSwjdHbMGCw/p1wa0CQrZvS0qgE6TSMQTKF9bbTRvXgYDJa3uQHnse2KCowRozooPYfEsSMVGaWntQejVbRFQJYngZh9r6gh80EMwd3rFT4wTYObimkK76JE3v/RA7EBInilEKk1m+9Jjp2aYBYYAO+8LBKIdMtGWKXtqL50UDhVK+ptkp6RwjUpiyD6tAxmzDGrGy27URMjDEr1lFR+1iUvpIc3qGwN2MinDCvTcOCQYUN0pmSmevg/ci4WxMXY9ym8/9Ekigz5dJEJOud7g9OdI6lciPVJMIFypq6gw9wO98JtqXqQVHqWjY4geoocKgxRE9n1ZzpOXJjtPB1lu9f/ZCT7KDThI7xH9a4HfhTUc5C5VqpKzPc1bGma6dWNFBWlQxbhiJoS63Qe/HsJ2xgD+fFQ01SzMYEmvS19X4a3Txxog+x1di8oDdiXA9TKEqdE7I9qkmVlWYxfhIBiSTFuIjARTuvVn8bQFsBXUOfQZFd+/OdkFbF4HDZmrMIJh8HPu5sXr8foamJ3n7iHui9TWCc0EswJry3p/D4hGnVANR
 y7S1RBg5
 bPsuPBeTvLw8cBLsaiYhLgVHt8kVgWUK+8AEQVn0yHRX/fDepHKBQWlF5pEgMyLIDq9RIH8Vv6H1rAQ6hw+yRLqef9Z+BzYbHKEyOXfJXovW08Z6bPrUUW6J/ufdWMEUtRtuxVrgCihK6g0cf8slNYPqSHoviZy7LoWVUGlle8ppAqLz1/WPF0eqc51iLQhijhliWNNtZGChUUv68wvsliRZt5C+ckqHbw9EdCUQ0n4CKzsN1/Jqj64/VWA8t9a8nhMyBFQppZrQ1w86Mx0zxwUFsOspriKJJALf4y9bp0HHbr7K3DL8CwluPydI6Bkck3tm28gL1CvQJyYG7XePMNcqXSExnGhHPBhXLi+tgIZiTg5UsZoZzL9ZW0H/NfRXC08+ay9Ac4mhoFa67X4tE/ieRDBZKU0BaBLqo7bMPbRyacYc7CF5G9Ny6GIsLhTiK0Dx49Xqr61bAgTOl8V7/n+LPOD6tTipuWvS2snFo4x5iD+anTHcgMP3XIJ2ICcLjFuabJHAx0Q+K0xFsX1hN8Zr6mBf8H2AYWJIx6kNNZFpLnhi0fV2JFE3lwhl71G6Pwtga2BOeVkG6CT3DmvJ45msDoKDqJALMy3R2M4YHLQhGDgeLYzZIfpmY2z9grrU5hxvsp/HgZgnH6zIGYrP6+N2wKQ7xWTbrw3zV6RoOwNMn6qm0G10zSq1vEU8omKbsPsLC6LRfoLUn7pMo6Z3kmyUJNysPNimq5KQxxfp+ZjpUSjUmGzq9P6D0brun9Uqm0JFs8X+dqxEwfbfv8TaP3EyHPwUAZ5hHEbozyb6IcQ/rqBFkbzU28YpsM5JyU5oV3T6+wTdNOyJrk7brGFesbMCYDA/SrY/9sTqo1Hbo3zzorVSPgd7mzqVEeEEuBkm/6cWsWR38HQRNtryeYvgSPFcfgo6Av96TBVnHW0VYYM1XcTbeOZ9lM+Xe5c3hwlimn194wzxKYGkJGvYkVSQvYz7HnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

 A new scalar value (PTEAScanScale) to control per task PTE A bit scanning
is introduced.

0    : scanning disabled
1-10 : scanning enabled.

In future PTEAScanScale could be used to control aggressiveness of
scanning.

CC: linux-doc@vger.kernel.org
CC: Jonathan Corbet <corbet@lwn.net>
CC: linux-fsdevel@vger.kernel.org

Suggested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 Documentation/filesystems/proc.rst |  2 ++
 fs/proc/task_mmu.c                 |  4 ++++
 include/linux/mm_types.h           |  3 +++
 include/uapi/linux/prctl.h         |  7 +++++++
 kernel/fork.c                      |  4 ++++
 kernel/sys.c                       | 25 +++++++++++++++++++++++++
 mm/kscand.c                        |  5 +++++
 7 files changed, 50 insertions(+)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 5236cb52e357..0e99d1ca229a 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -205,6 +205,7 @@ read the file /proc/PID/status::
   VmLib:      1412 kB
   VmPTE:        20 kb
   VmSwap:        0 kB
+  PTEAScanScale: 0
   HugetlbPages:          0 kB
   CoreDumping:    0
   THP_enabled:	  1
@@ -288,6 +289,7 @@ It's slow but very precise.
  VmPTE                       size of page table entries
  VmSwap                      amount of swap used by anonymous private data
                              (shmem swap usage is not included)
+ PTEAScanScale               Integer representing async PTE A bit scan agrression
  HugetlbPages                size of hugetlb memory portions
  CoreDumping                 process's memory is currently being dumped
                              (killing the process may lead to a corrupted core)
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 751479eb128f..05be24e4bc4f 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -79,6 +79,10 @@ void task_mem(struct seq_file *m, struct mm_struct *mm)
 		    " kB\nVmPTE:\t", mm_pgtables_bytes(mm) >> 10, 8);
 	SEQ_PUT_DEC(" kB\nVmSwap:\t", swap);
 	seq_puts(m, " kB\n");
+#ifdef CONFIG_KSCAND
+	seq_put_decimal_ull_width(m, "PTEAScanScale:\t", mm->pte_scan_scale, 8);
+	seq_puts(m, "\n");
+#endif
 	hugetlb_report_usage(m, mm);
 }
 #undef SEQ_PUT_DEC
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index e3d8f11a5a04..798e6053eebe 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1151,6 +1151,9 @@ struct mm_struct {
 #ifdef CONFIG_KSCAND
 		/* Tracks promotion node. XXX: use nodemask */
 		int target_node;
+
+		/* Integer representing PTE A bit scan aggression (0-10) */
+		unsigned int pte_scan_scale;
  #endif
 		/*
 		 * An operation with batched TLB flushing is going on. Anything
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 43dec6eed559..6b5877865e08 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -371,4 +371,11 @@ struct prctl_mm_map {
 # define PR_FUTEX_HASH_GET_SLOTS	2
 # define PR_FUTEX_HASH_GET_IMMUTABLE	3
 
+/* Set/get PTE A bit scan scale */
+#define PR_SET_PTE_A_SCAN_SCALE		79
+#define PR_GET_PTE_A_SCAN_SCALE		80
+# define PR_PTE_A_SCAN_SCALE_MIN	0
+# define PR_PTE_A_SCAN_SCALE_MAX	10
+# define PR_PTE_A_SCAN_SCALE_DEFAULT	8
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index a13043de91b0..bb780215024c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -106,6 +106,7 @@
 #include <uapi/linux/pidfd.h>
 #include <linux/pidfs.h>
 #include <linux/tick.h>
+#include <linux/prctl.h>
 
 #include <asm/pgalloc.h>
 #include <linux/uaccess.h>
@@ -1050,6 +1051,9 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	futex_mm_init(mm);
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !defined(CONFIG_SPLIT_PMD_PTLOCKS)
 	mm->pmd_huge_pte = NULL;
+#endif
+#ifdef CONFIG_KSCAND
+	mm->pte_scan_scale = PR_PTE_A_SCAN_SCALE_DEFAULT;
 #endif
 	mm_init_uprobes_state(mm);
 	hugetlb_count_init(mm);
diff --git a/kernel/sys.c b/kernel/sys.c
index adc0de0aa364..f6c893b22bc6 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2147,6 +2147,19 @@ static int prctl_set_auxv(struct mm_struct *mm, unsigned long addr,
 
 	return 0;
 }
+#ifdef CONFIG_KSCAND
+static int prctl_pte_scan_scale_write(unsigned int scale)
+{
+	scale = clamp(scale, PR_PTE_A_SCAN_SCALE_MIN, PR_PTE_A_SCAN_SCALE_MAX);
+	current->mm->pte_scan_scale = scale;
+	return 0;
+}
+
+static unsigned int prctl_pte_scan_scale_read(void)
+{
+	return current->mm->pte_scan_scale;
+}
+#endif
 
 static int prctl_set_mm(int opt, unsigned long addr,
 			unsigned long arg4, unsigned long arg5)
@@ -2824,6 +2837,18 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 	case PR_FUTEX_HASH:
 		error = futex_hash_prctl(arg2, arg3, arg4);
 		break;
+#ifdef CONFIG_KSCAND
+	case PR_SET_PTE_A_SCAN_SCALE:
+		if (arg3 || arg4 || arg5)
+			return -EINVAL;
+		error = prctl_pte_scan_scale_write((unsigned int) arg2);
+		break;
+	case PR_GET_PTE_A_SCAN_SCALE:
+		if (arg2 || arg3 || arg4 || arg5)
+			return -EINVAL;
+		error = prctl_pte_scan_scale_read();
+		break;
+#endif
 	default:
 		trace_task_prctl_unknown(option, arg2, arg3, arg4, arg5);
 		error = -EINVAL;
diff --git a/mm/kscand.c b/mm/kscand.c
index 273306f47553..8aef6021c6ba 100644
--- a/mm/kscand.c
+++ b/mm/kscand.c
@@ -1306,6 +1306,11 @@ static unsigned long kscand_scan_mm_slot(void)
 		goto outerloop;
 	}
 
+	if (!mm->pte_scan_scale) {
+		next_mm = true;
+		goto outerloop;
+	}
+
 	mm_target_node = READ_ONCE(mm->target_node);
 	if (mm_target_node != mm_slot_target_node)
 		WRITE_ONCE(mm->target_node, mm_slot_target_node);
-- 
2.34.1


