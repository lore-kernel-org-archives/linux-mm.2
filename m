Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17D8BCAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 17:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 769F98E000C; Tue, 23 Sep 2025 13:48:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741488E0001; Tue, 23 Sep 2025 13:48:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630628E000C; Tue, 23 Sep 2025 13:48:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 50AE88E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:48:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F1D081A05D7
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:48:57 +0000 (UTC)
X-FDA: 83921250714.03.4AEB9F5
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011027.outbound.protection.outlook.com [40.107.208.27])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3C1A1180006
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:48:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=N7zs602E;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of shivankg@amd.com designates 40.107.208.27 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758649735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=juCl6Q7IDVVaEwDIPOfsLFRmleBkegBnFU+fvOlhQWI=;
	b=FBwEaYsnhn8hXtMjT8UIWlrbMSFYiifqML+tgdzX6+cr7Zx4JKCqw1bKiVpScEHjPhcqF9
	z0CqkYpWKG2PQKKIReTIOXMEsRuY1lvG/qekY50StyP+oGtGy1x6Sr5RR4WKWbd/FHDIhS
	ezT3QE2shIQCTS4UbTdtO6wG8Fnqh/4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758649735; a=rsa-sha256;
	cv=pass;
	b=lNWD6rlqFXdfoPGuK1r3qb6sdHj4mAg/QxrCjvsGj58FPusc7GTuEdjAB87ct3IjQ2C+kJ
	8/JaOL7VBmVL2wYvBOc2IUsw5AmUhGPSbBSowLwhntBLCmQJh+2bnp7FXmW7EVv9iHGFnz
	s/ueJum2Pou1Dj28hc2VGpyXZQyi3y8=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=N7zs602E;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of shivankg@amd.com designates 40.107.208.27 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ichqhSRUk/9jgrTaaO+EsSETkHxI4I0ekmQTFLO5KfLHPX0A3QszGQ59hDqnUK0utyrqJMcj9UC+0RktqgdnspCi3tkrKeZ+Rl/TS4mJzLsi3PpXgIxNU74FkZIxal9pmxcSrDiFTAKXBch9jL1+I6FoTL0fUCfNvrUcY9BRjgPj6HO6coQND/AMEAFBRHKjUglpRaGqVLSXx3mY7RngGkACRWQydTprP3h4ASKLjHYvTdBJGP0lCDUkfFbQdRDtKyDKjxgNn+e7QuunFQePKpBge7hoekg9hUmx3RA4le0e0cBPyv3gUDqNqtByOhSNGoBL0fut/wd6vitAywl/dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=juCl6Q7IDVVaEwDIPOfsLFRmleBkegBnFU+fvOlhQWI=;
 b=LGkWTB6hE6bbBz5WH/wg7U7iN9zHbf01LyVV6Yj6c8u++flgNsxpddUDUxzEu5b2+Sn0hYGEXeMqKlwIzYfQNmeSXkreVnFUTFY4qTBlAM9qtBYNpurRlvGn/b5PE73oNOxILKT28mO3d3VUoWEN5n/fW+UmeVLHhCx+p1se4aQTNz5CaedmLW0XzStSnuxMpdzHhIdt/RUorNi9uz2nyzMUc3NF2fcPi+MjmDkUVqTWGuB85goA9LBlG/FdjWNd74lMfI3GHy3HZgSx1AeJURyj6r59iI7566QhrR6bB1sfr8I3NoKUi6TOQ/GuqTod8k6zHB9fnen8zbPHMYDaIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=juCl6Q7IDVVaEwDIPOfsLFRmleBkegBnFU+fvOlhQWI=;
 b=N7zs602EzuuGAFYsykzECl0u7WOQ3fR9RqfAKqDWKrGIct/wKmUeMQHIwLXJoVRpLaMgiQTh8q+0ugcukAtixdS308kI3VB6QH4nzzhQI0RHmi7Al1PwPbQNEKeYAKFfMJt8d4WeS6noa+VK2GtJD/pLbRpYUBVwoqA4rCCpsnY=
Received: from BN0PR04CA0200.namprd04.prod.outlook.com (2603:10b6:408:e9::25)
 by MW4PR12MB7120.namprd12.prod.outlook.com (2603:10b6:303:222::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 17:48:49 +0000
Received: from MN1PEPF0000F0E4.namprd04.prod.outlook.com
 (2603:10b6:408:e9:cafe::9a) by BN0PR04CA0200.outlook.office365.com
 (2603:10b6:408:e9::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.21 via Frontend Transport; Tue,
 23 Sep 2025 17:48:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0E4.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 17:48:47 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 23 Sep
 2025 10:48:38 -0700
From: Shivank Garg <shivankg@amd.com>
To: <akpm@linux-foundation.org>, <david@redhat.com>
CC: <ziy@nvidia.com>, <willy@infradead.org>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<vkoul@kernel.org>, <lucas.demarchi@intel.com>, <rdunlap@infradead.org>,
	<jgg@ziepe.ca>, <kuba@kernel.org>, <justonli@chromium.org>,
	<ivecera@redhat.com>, <dave.jiang@intel.com>, <Jonathan.Cameron@huawei.com>,
	<dan.j.williams@intel.com>, <rientjes@google.com>,
	<Raghavendra.KodsaraThimmappa@amd.com>, <bharata@amd.com>,
	<shivankg@amd.com>, <alirad.malek@zptcorp.com>, <yiannis@zptcorp.com>,
	<weixugc@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [RFC V3 2/9] mm/migrate: revive MIGRATE_NO_COPY in migrate_mode
Date: Tue, 23 Sep 2025 17:47:37 +0000
Message-ID: <20250923174752.35701-3-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250923174752.35701-1-shivankg@amd.com>
References: <20250923174752.35701-1-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E4:EE_|MW4PR12MB7120:EE_
X-MS-Office365-Filtering-Correlation-Id: f9018db0-0233-4c05-ad8d-08ddfac972bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kYDyYId8ciugnAHuyfe+TRfbG2RWK8Hj/BCha2RFo6vjZpRD/9NLvGo1lCJ6?=
 =?us-ascii?Q?PcobJtxMKRYb4o1Ng7ZiC/rXwlef+K//3+P5Z6/HjDhzow/IdV/smfOvn/tE?=
 =?us-ascii?Q?8xCqyll/K8j2wVDDTnACOlv51fNVJTI3/S3aePvUOIrPVG5ckENjVHVzuIr1?=
 =?us-ascii?Q?kgiimBYMyBpgUIUhW/vGQQAeAE1qFNCZLmpUEW280QGzkYFo0SSSDFFxf2rT?=
 =?us-ascii?Q?H2iWfEUVA5/Bi9t4Ycov3Q55uaiXUkGMxjTFzL9iZSigzWTwu6slYl3IpDnT?=
 =?us-ascii?Q?cqh50bP++fH1LfMDF2kT2R+m6tL82MWNfwlF2N4xJb673rZlEA9c13mTiUDQ?=
 =?us-ascii?Q?NRJQCdcnTi+1GB8a6rdI6AvmChvK35MLtaCMz7d/zh6r328g2MOreTVcvotb?=
 =?us-ascii?Q?9tnxEyuWPybDvREDSvshX3IcYzIUFScPYpxMyuSXz89/RPLOz/VgxT4Dlibk?=
 =?us-ascii?Q?QSMLWSkZBEOh8P8XB8YV4myZ/8SjNhCa8hlr9IRFKfZ68YGhD9+ecRW26dJ1?=
 =?us-ascii?Q?Y1n4VZ15HfLYQVw8VQZfBV5WKF+s27BanofHRUfwusJlFwsLgIfgR+R9l97g?=
 =?us-ascii?Q?9JFNS/IBR4m25BffNlYlF076RqcsCWFlwYtL8O/5AkBiFTRujdl5ecWnrs2L?=
 =?us-ascii?Q?hxjh/KVNVcs7SNLbt9GhGaFelWDL4TV9RBTgi5I76VzRiFaI5ErrQBrIZLXV?=
 =?us-ascii?Q?h3pQQ9S7J4mQNGjxVv7MJFhCbLNpdaW6riEDwwf0107hFRrtu+1j3ScrclDc?=
 =?us-ascii?Q?35w+9qaxtsye7vTIVPHNBlK6mIFMZBGKzy3mw4DbRzel/cYwi9kBdgBWZNN2?=
 =?us-ascii?Q?4D44g/LTUGI3359us0yooQu9lGyxzvcppwR0Nyg5x6gUYGWyzpgPIJFngwI+?=
 =?us-ascii?Q?OlW1LwX3I6wgs62qeG06VOK+WLaN/mg3EqGsA9w0Li/Isl0/fLWeAGpdu+9+?=
 =?us-ascii?Q?GuD0e09lVTlYl6FSqgLzQzhe34EaNqlb+B/G2Bj1saM3Bt5T43MXSGZr4SGb?=
 =?us-ascii?Q?irtgNBQ28IJbH9RmOMJ4dN0jVGyZ1gYOG7A4H6zlHluNiOTv24o71T6HrqNS?=
 =?us-ascii?Q?a0q08lrAIDQ3t1xuixSE2AKmbhM68v9vVI2G3WAhI1ibVo7L1S9zcplw5im2?=
 =?us-ascii?Q?lWqg5uvw4VqXlgASFxZkZ7hPzeSnOVVRw3jGToOUHuLtTE0Yva3+aoQviBcA?=
 =?us-ascii?Q?k5WcjNLohfQmwciOih+YqDLDhZGB/X00J8BXaQarRoFQy/lComgcfMDUy9ig?=
 =?us-ascii?Q?2SNzswggzF3JAG5b9SyBaPF9BJ2OuQcPWPuQBs3oGmhZvqFllNmWKr9mfmBj?=
 =?us-ascii?Q?XDm7W6B/FhLAUfJ2hACodwfFZnoPxxbTY9rg/TNTKCIzMqlBUU/OYqrqf8NZ?=
 =?us-ascii?Q?q65CyxnIKBnlDLTDHdvruAPqVQOszyKd0xGwuBURRQ+aoZ5NYTr9gRkXA4Yd?=
 =?us-ascii?Q?XL/TzJDOo/eySCsQP94+SO0qGxdd3SCgZ3vwhlVOvwiuuO79ORtF+uCCgmrS?=
 =?us-ascii?Q?XPKG4cOp6U61ck3eBuOli9nunLM+VWrlmc88?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 17:48:47.6388
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9018db0-0233-4c05-ad8d-08ddfac972bc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7120
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3C1A1180006
X-Stat-Signature: sxy7cc5znj3adixikqtcdqxhihwbmuqt
X-Rspam-User: 
X-HE-Tag: 1758649734-807489
X-HE-Meta: U2FsdGVkX181SdvdRgOM17XOWnWdOztbVNozdONP5VlhoXq1PYDl9OQ7VSiLGekTSRdp/yl0/RtDfrZqMaAfqLD++NWbpNImb27pAEu7oie7qxrXCx43ISP2znGcgDyUJlfYXypx3AYHWGIeyazfJzCWCAWPs6elL+gliKlTg7nHJoyAQ/LNq5Fg4yse1mQYw1+KEjlY2Jjb1dX1ON0ctoDK1Y0+z0KoWHcsD8qBghnIqb9YUoy4+Bz8WCdF2+TrojUAoaLBsrK7ataSkgwelRzQAMNUcjP7/R/2iUKvPvSScNBsnpLGSUJzHZ23M+SCkR+hVQfqHCX7gntRzoU3Z6SIiJhdm49M1QVZ9lYbMQdrED4dRBAar4jEsBwGvLeQ9skpHKZBVdNJZsTAcGD00bvlZf/L46YT7fgEZ9ww/3rZ6GMQkJVElfkMobXAF69jYDX7d027EouiT1/TmjSh0ryGRqY763Jl99x06/ozN6VsrFzw6vPZS3A8MlZCBUOxX+a5XkMI06B9br73wpMzehpTebCLHiUtZqKxcDcZY+Wpp+Aiz+FEFJhjWrzqmLng4Yv5Zik8+NWMTr7T29YETAMYNya5n+R2KKjnAueXLBU1Fo8eNL5iTA7xRPLzsxSuqENWr+dHnULrKXyETJlUN/+pEbUPsYv54iHSfS4tWZlyotSFXq7kuRxrpZ9Une+13WdVpBsjUl8bsu95pMGTSMuI1E/hG5ZqmXUiVL93BWDfJTC4gSs7ZnUHn32UIwQejiqvgozI5AWlbXmMGJYnqdMcVEMk98028fv0eb7I3ciMZyJ504zZJNUQi+B1kLFNEmZ33hfWe4Mawo7u7zfcy6evr7m0fw8mFf8OsWpgPlWSEP59h4jE4L/xwNnZSSUt2mC3P4U8yHJYL5Qf4ft5KvOLcnI8C5wGd0ZlmR2QlTgiRdWnF1Wt6bbHZMR5CjZftj64PpV95iYDLGloI6P
 0YKcp/us
 TmurJtjyWvfnPsEtbkAwwTm0OiCWP2akDQTsR0dv/kVZgaA3ID3lvCaAK7FzEhhjTQ9ByAGQCebq3sJZWKAZgC5J5D6Ub8yB9D+A253QAbabVzmV2eS8btyAmsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zi Yan <ziy@nvidia.com>

It is a preparation patch. The added MIGRATE_NO_COPY will be used by the
following patches to implement batched page copy functions by skipping
folio copy process in __migrate_folio() and copying folios in one shot
at the end.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/migrate_mode.h | 2 ++
 mm/migrate.c                 | 8 +++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/migrate_mode.h b/include/linux/migrate_mode.h
index 265c4328b36a..9af6c949a057 100644
--- a/include/linux/migrate_mode.h
+++ b/include/linux/migrate_mode.h
@@ -7,11 +7,13 @@
  *	on most operations but not ->writepage as the potential stall time
  *	is too significant
  * MIGRATE_SYNC will block when migrating pages
+ * MIGRATE_NO_COPY will not copy page content
  */
 enum migrate_mode {
 	MIGRATE_ASYNC,
 	MIGRATE_SYNC_LIGHT,
 	MIGRATE_SYNC,
+	MIGRATE_NO_COPY,
 };
 
 enum migrate_reason {
diff --git a/mm/migrate.c b/mm/migrate.c
index ad03e7257847..3fe78ecb146a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -848,9 +848,11 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
 	if (folio_ref_count(src) != expected_count)
 		return -EAGAIN;
 
-	rc = folio_mc_copy(dst, src);
-	if (unlikely(rc))
-		return rc;
+	if (mode != MIGRATE_NO_COPY) {
+		rc = folio_mc_copy(dst, src);
+		if (unlikely(rc))
+			return rc;
+	}
 
 	rc = __folio_migrate_mapping(mapping, dst, src, expected_count);
 	if (rc != MIGRATEPAGE_SUCCESS)
-- 
2.43.0


