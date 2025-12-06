Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33944D3B7D1
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 10:15:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 671466B0361; Sat,  6 Dec 2025 05:15:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 648356B0363; Sat,  6 Dec 2025 05:15:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 510486B0364; Sat,  6 Dec 2025 05:15:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 38EDA6B0361
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 05:15:56 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C0B801A03BE
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:15:55 +0000 (UTC)
X-FDA: 84188640270.28.31F5D01
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010039.outbound.protection.outlook.com [52.101.46.39])
	by imf15.hostedemail.com (Postfix) with ESMTP id D0901A0006
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:15:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=tV6HrGwH;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of bharata@amd.com designates 52.101.46.39 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765016153; a=rsa-sha256;
	cv=pass;
	b=gQfPlC9WOhuVjPp03mEBIxq9ioydd7OojfaBOYI7DZabHojjI8NJ62KMLefZncDgdpmMe3
	csnm0G0p931Bay6hI7T6FtKFpSQStwG2lyFVsMlX05Ji+Td9MbnP6O4gIl2x3+fmjsLEmZ
	GMg1S2ovI/m3IzA0irwpZNRj/8I78dY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=tV6HrGwH;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of bharata@amd.com designates 52.101.46.39 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765016152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=APJ2OXax1hQPassOHE0tcpLEA8Zqjjba4D4+g0pB+l4=;
	b=N1PpcHCICQwmldPeK0kAG2JpB99t0InCqdFhgIzXO5hah/UYDmyyy/0d6NWktoyWdL4TWM
	yzjmqDdVD8LfauthV0miZZ0+arncM7asFfssCGKm1BYjTMa7rF4NssUM4OtSNZIgP31o3m
	VATxe78mUvC69leQ3JXT6upht+SxI8U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sn6L6D7Xm98jWPVaTdcFeJRnFQSWWI32PJ9PFg4nLOFxTi2ezJ/nIjIbQVfIqj1hBhOTPc+UD+qe0brCwUFQRjZPoQMmMxtE7XRsvM+BcEKMpjEvaj0ehA6qcdknfKRPzEYjujw9W20j7s4MRzO6I0MpGA3JOj8ax99CaFF0IdO4qGhPgWcqt0TNTNhowKP674hmwBAK80brYwel2h0PfgtCKh2O+xCWm3uaxsbGWRatIUQeezljujj0ZXlteJm2VVWqEP8FBaknfUQlzbj28F0Hq+A98OBLs/e/sXkg9T3N4uCHtcZbAclK9bH2VXo01SU3/j0cU0ZBAUHm/sMtDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=APJ2OXax1hQPassOHE0tcpLEA8Zqjjba4D4+g0pB+l4=;
 b=TtPKVCRs0WTJV5BVBPiAuWscFsoUAJvxPX2uwv1YorlOL5nLQhKUI1+5COFS6kvkiwbl34HqPNovRuGYmieIj2g1RG/+/0AucGrGxcXg+piCfKif9LTvZi9ONIVuv8qMWO8F41+3mxCECt1NFMr+/PYykMeJJM0J4Sd/4EuxuYoU0eUx8aorSAoZXXEshPsnL3im02Ufqkb7b8v4+IYPIfqbAvmDgj0zpUd9A4UhMSmZMG6iriLn0xReNsHrNeY2SA/+ZnAdQxxxw8gY8WKMMEwKEd518xIDzbMdybFMUndVhwLqo/qu8qCn/XNRrEBzlQPECMyOPsr1Qj03DnISUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=APJ2OXax1hQPassOHE0tcpLEA8Zqjjba4D4+g0pB+l4=;
 b=tV6HrGwHo8O1HKSC+C6dLukZ91K4nMTt0j8mDF5MFsYTvwTg1lzggi+o6TE4Wav4nBEjHez05Wlx3+J64EXOtrGRJNOSCkN8ACYwmSGQOjFZwcBU79FzCitVJEIC49S+pLP1elYeC+RT8B3Vkb99/cJwHx/q5XyZsyK9nFuwuxQ=
Received: from CY8P220CA0014.NAMP220.PROD.OUTLOOK.COM (2603:10b6:930:46::25)
 by MW4PR12MB6976.namprd12.prod.outlook.com (2603:10b6:303:20a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Sat, 6 Dec
 2025 10:15:49 +0000
Received: from CY4PEPF0000EE33.namprd05.prod.outlook.com
 (2603:10b6:930:46:cafe::eb) by CY8P220CA0014.outlook.office365.com
 (2603:10b6:930:46::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.13 via Frontend Transport; Sat,
 6 Dec 2025 10:15:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE33.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Sat, 6 Dec 2025 10:15:48 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 6 Dec
 2025 04:15:41 -0600
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
Subject: [RFC PATCH v4 2/9] migrate: implement migrate_misplaced_folios_batch
Date: Sat, 6 Dec 2025 15:44:16 +0530
Message-ID: <20251206101423.5004-3-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251206101423.5004-1-bharata@amd.com>
References: <20251206101423.5004-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE33:EE_|MW4PR12MB6976:EE_
X-MS-Office365-Filtering-Correlation-Id: a27b8b1e-c0a9-435c-1eb9-08de34b06d6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h9MXT82cnYWeN7sve2GDoxga+QXZelZ7XpIQTrLf+Wjkwmlfu8g+V9LCOgHR?=
 =?us-ascii?Q?6a8ikfbOnvDjpCQsJXFoAOLe3pY8Gq8PM6QLh8uO7G1F8u4nayPKnKZXTGMN?=
 =?us-ascii?Q?0BBv1aGyAYgHwZg8rQ6Jjt/j8jpZdozHmsAhph3eKo+PZVeBg3hIe4ehwRww?=
 =?us-ascii?Q?mApO9Q8tKZI1Iwq+/Jtat8P/Gq3jhZbgM3jY+2ZcDwgJF7wfjjyYGeBCJsap?=
 =?us-ascii?Q?QRdVzTjFjA0FsX2VrHXp6Ck6Tr14t++CNWZ5qaCcyjbdDiZo0cLNUFygvIap?=
 =?us-ascii?Q?ZyXnbbsggw4JfGN6jeYjDEfXn7037JgHk7Vvvpdds7v5ZjfeSP/iyeYtT577?=
 =?us-ascii?Q?A2A/7sYqdEFPTvR8GaiqYxfkoIYkxUE3QYWWzE3SXWvDMwskPEZbdTEhG/p/?=
 =?us-ascii?Q?2HYJ3o1Ldz9Hkz4OxeLo5XSH1umfcBo0v4Pcr3tsuTJyav8YHeTt+bw4XFxP?=
 =?us-ascii?Q?lmd/0Xlk2NPXJQ0NBTkiQgZnHno8XSCsmgouxJaipfqDPBochuuD/bDNDHAL?=
 =?us-ascii?Q?Z/1fickpWocMpwigMriWTu+nDSZEMA0hLYjFhTiNXPrdOwGLmKSJVJtl39Pg?=
 =?us-ascii?Q?b411ipJh59Z888D5YhER6C5UOSj32VA1qYjBJ8cMU3XJhCbPavEsIiOg3Hea?=
 =?us-ascii?Q?qKeTyUWY6L2RnjwKKoIAZpliPJQtyOmx7SOCuSGc0JjarYVUimTMmAHC8iWr?=
 =?us-ascii?Q?Ni1rY7R6e9AzCraqahrNeOKjlAeKHAd0CuUtzm55F8tL8neTuJcRONApAQNK?=
 =?us-ascii?Q?9DWNFxkq/Kdq8jMMG9SUsEll6YerEnYC0GhEjKc2EM36ebsm4ltP0Ehhqf6P?=
 =?us-ascii?Q?Y7WIixTYX9lmLxf+cumfhXk8S/SCmhXmoKx/35kj4ge1AclvkVqddpkODzyP?=
 =?us-ascii?Q?QfxgWw8lLZ9X+9mQLY42VkNXMNaTL+X7mg3vw4k6hmr1Q/eotdkmiQcFJIZv?=
 =?us-ascii?Q?DaNK8Pj4aGP/ry8CK2pzAafx0BhSGcwv0M4ORZJ9tqMLml9SPbW99ewegSd7?=
 =?us-ascii?Q?UQ5SrvQhzvYjNoj8cLMq1vUcQDDjUaoo2j+zvHkR3sUdLmtfmAOuZwl37hhP?=
 =?us-ascii?Q?5OXwBe++eiGcoabI2UygjxW9Z2NKukw19kk2ru+p5MROhT+JI264NOylyNuV?=
 =?us-ascii?Q?7tdivn+/XJUHDkwsiFvz9cL4EC6GHXGUooIt0fFdRxpuywjYzUP+rHFfRw4q?=
 =?us-ascii?Q?Hm93rLSxDhwWrWWcgurdi6kNb33DDf/kC64usv03EeiUkCc/6DEJSgULZr2C?=
 =?us-ascii?Q?ArzrsA+7qURKGTQGFm2C5B0w/Rm3Oa9ZgPZdwDSuTRjwEMpAs0zdzde1vi8u?=
 =?us-ascii?Q?7yAeCFsYF8dQq0k4d7jVA6oPH4EXQQaDxs0PVMAWG4AQXkN4qL4h3pgAzX1r?=
 =?us-ascii?Q?P2BHvz69M2TYa+mPHDhv0AYkOY7chW+nDl8u7CaG+BQYqjL08+EIuKqd/eOu?=
 =?us-ascii?Q?8BjQqQwfZaxaTj+ltrfKl2OdcbGOuGkjzWAN9Ja7NwRw6BcrGw/0kUqFIeWF?=
 =?us-ascii?Q?P7QnahAsjwDKbeZSaJ+Fd6NBrvUxV0UvY5uX0QIpHbooygSKX1bBPhTCJsqy?=
 =?us-ascii?Q?myBa3BLvmfSY7NKBbJU=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2025 10:15:48.6880
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a27b8b1e-c0a9-435c-1eb9-08de34b06d6a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE33.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6976
X-Rspam-User: 
X-Rspamd-Queue-Id: D0901A0006
X-Rspamd-Server: rspam10
X-Stat-Signature: jw5mg9z5hqxmrgodk8mxgtq6roeppqqi
X-HE-Tag: 1765016152-17983
X-HE-Meta: U2FsdGVkX181DPAa/+GMTyXidjIaEe9iqvAZM68M5dI4GX+B8+EYyTv3pucDiAWydYVVVbcoN2DpqWtlaHCtpYqf6/xcH5TjVp+tokCBqRlVnn8CifT/unllo9j4IpTEJR6QoF0u4PvTqp131x9Qcg+Dk8TWfjfLFRsBnDKvlRbrpQ+6NgKo7ADA5SwuOWcQSpwP2Lvl5b/agDNmlbfe2GO7TJZlxc7jDScpQE2VUVt3f/M9UA7MsidARwCkyL8D05JG7NJNt02kVi7aC8qKeULmYxliGzcrrfS8phHUlCou6NWS8ulmeFEPNtYOssdbnDeN7q0tHCRks/kB0lKGOF0GoTN0Gy1JvF8kR+26Cpe2ascdBByR4AZVaALzI3eMpq12c0f1imsmE3VVgkprs0Zz7S6yY1hapq9+YRT5A19hwct1aBGkqfkCBgOt9jDGu5JTmBjj+3fTO9zG+3xYoEjJqni9WZU/spabrWlyhTTD+CfxfrgBOMUNhK+iSv77LcyahTppbqzt3Gja/CEDIMxj1qfV/Ipvs+5b4UzCNrXVu5prJlcYMVnDoFuE33jSmMzj38XW8m5hLtViY/YuNieEvx6iLjTncJdj3ONlt8ySuumoQ7li32LVs6ZKb5wsw6o2GROItQsHvn1KI7jas8uqLGo3iZrL1ujFZ7crD0zIKIEKFhyxfZv512G1NtEF3ye85A/KNONR5DDy8umztpwW3dY7Y5Obbhwu8Rmwo/sXQVgINQHaSkoU2nO6QTbou/3oy1Bn5ncD5pOB7UsuZZXg/5UgDQatrDDG749q6kefPxbhlSbpQz2eaeuF2WxFNPIJ7vCCJZA9+4jWfyxZuIpL3vHnF6Fgs/a+VnYWIX9FrRS/gJ5V6QanTTJtNoCj2E80M6M9jPh4YpkRDg389WbotFr9WEXrVQ9haa490B5/AYpxUkuFufK7NaKDXbSbBbbOORfWMgSSa0+hTKJ
 d4q5y9J6
 97IdIvDu2h5zdH2O+k4usxQJKR05Ky+/+vgnOUI7A827NCtPoaSv0Ewt3fD+OxVfZxXsrggFLcpfTjv0DlNLFqvr/Fi6G0smp2MMW2+djbMAvKnPZ9xxTBrhSmKHGQe8BKVMdrmJSloYL7hNTQv17FSjZMKCE6wsf6/X5Yv9j8KAAVqMWs2ziuC2jH2ADv8WUIckpXLgt2Kjs322Rj/3ujnXO9fHR7dT4u1CMsN7hE/IakPXEFCtKZPtM06VAmCdhJjuC4UT/1hDNN/bi6O3Yq1zUx+0KaXcEhgnZnGCQBvtjVgx2lXotqUY8g5X/r1Yz+WzTfQnQgNF9AmTSdBETpDqYX+JUAhHicn/+hSB2XKHcRV+JjiW1PNbPT0LgwivoKfiFcBHf8Ov8AJ6dmtPq0JOYXnGBf9qI7mg3Bw5glcnzKDV9FYh6ByaJ60SiMH5obEhwKUlvRVC0dqsRaMBcsKoW35iuZqEtPrbfrjfJ0LZYYCVbBleBB1GP+OOvJLKuDuRc7Cgu70f90gF81JuN6MkKgEGDgINfGHfM7V4ZB5yxSOwNJnyN2ezGfutEVgNi/J2VUJ6JTzvpJ8GiMrUmHQNsAVM8plLFnsBXGjraNP+XdJ2PmaQMXIvfcaS8rQhPqSYePzxXCSGVQxWGDJTqa+0kSq2Dqeu2Xn/1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Gregory Price <gourry@gourry.net>

Tiered memory systems often require migrating multiple folios at once.
Currently, migrate_misplaced_folio() handles only one folio per call,
which is inefficient for batch operations. This patch introduces
migrate_misplaced_folios_batch(), a batch variant that leverages
migrate_pages() internally for improved performance.

The caller must isolate folios beforehand using
migrate_misplaced_folio_prepare(). On return, the folio list will be
empty regardless of success or failure.

Signed-off-by: Gregory Price <gourry@gourry.net>
[Rewrote commit description]
Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 include/linux/migrate.h |  6 ++++++
 mm/migrate.c            | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 1f0ac122c3bf..2ace66772c16 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -103,6 +103,7 @@ static inline int set_movable_ops(const struct movable_operations *ops, enum pag
 int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node);
 int migrate_misplaced_folio(struct folio *folio, int node);
+int migrate_misplaced_folios_batch(struct list_head *foliolist, int node);
 #else
 static inline int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node)
@@ -113,6 +114,11 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
 {
 	return -EAGAIN; /* can't migrate now */
 }
+static inline int migrate_misplaced_folios_batch(struct list_head *foliolist,
+						 int node)
+{
+	return -EAGAIN; /* can't migrate now */
+}
 #endif /* CONFIG_NUMA_BALANCING */
 
 #ifdef CONFIG_MIGRATION
diff --git a/mm/migrate.c b/mm/migrate.c
index 189d0548d4ce..2bf756123d55 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2739,5 +2739,41 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 	BUG_ON(!list_empty(&migratepages));
 	return nr_remaining ? -EAGAIN : 0;
 }
+
+/**
+ * migrate_misplaced_folios_batch - Batch variant of migrate_misplaced_folio.
+ * Attempts to migrate a folio list to the specified destination.
+ * @folio_list - Isolated list of folios to be batch-migrated.
+ * @node - The NUMA node ID to where the folios should be migrated.
+ *
+ * Caller is expected to have isolated the folios by calling
+ * migrate_misplaced_folio_prepare(), which will result in an
+ * elevated reference count on the folio.
+ *
+ * This function will un-isolate the folios, dereference them, and
+ * remove them from the list before returning.
+ *
+ * Return: 0 on success and -EAGAIN on failure or partial migration.
+ *         On return, @folio_list will be empty regardless of success/failure.
+ */
+int migrate_misplaced_folios_batch(struct list_head *folio_list, int node)
+{
+	pg_data_t *pgdat = NODE_DATA(node);
+	unsigned int nr_succeeded;
+	int nr_remaining;
+
+	nr_remaining = migrate_pages(folio_list, alloc_misplaced_dst_folio,
+				     NULL, node, MIGRATE_ASYNC,
+				     MR_NUMA_MISPLACED, &nr_succeeded);
+	if (nr_remaining)
+		putback_movable_pages(folio_list);
+
+	if (nr_succeeded) {
+		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
+		mod_node_page_state(pgdat, PGPROMOTE_SUCCESS, nr_succeeded);
+	}
+	BUG_ON(!list_empty(folio_list));
+	return nr_remaining ? -EAGAIN : 0;
+}
 #endif /* CONFIG_NUMA_BALANCING */
 #endif /* CONFIG_NUMA */
-- 
2.34.1


