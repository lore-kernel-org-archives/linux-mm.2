Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0A6FD3B7D2
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 10:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED3C06B0360; Sat,  6 Dec 2025 05:15:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAB716B0361; Sat,  6 Dec 2025 05:15:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7AEB6B0362; Sat,  6 Dec 2025 05:15:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C240E6B0360
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 05:15:25 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 68EBB1A0413
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:15:25 +0000 (UTC)
X-FDA: 84188639010.11.81F7546
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012026.outbound.protection.outlook.com [52.101.48.26])
	by imf01.hostedemail.com (Postfix) with ESMTP id 681D140003
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:15:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=MVnIu3L4;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf01.hostedemail.com: domain of bharata@amd.com designates 52.101.48.26 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765016122; a=rsa-sha256;
	cv=pass;
	b=mA1+bQvEGJmZdiERCdxOCaxBa0/MwWgAA31JvrODwc/nOdddBXmbBmygb1E/JLO34AALlO
	5b01VzIGs0QOG0uXTusCYR+qY7dS3wyD207r7HOK8pMF24lErjE45kfKzQ6fOOECDa3tI4
	v2A3otOPlRn+u+tTU6aLtSKgwugcUkE=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=MVnIu3L4;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf01.hostedemail.com: domain of bharata@amd.com designates 52.101.48.26 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765016122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Csunv4ay0ersKu9D+/xbcPqUb4eanrv3W4tEcydndrs=;
	b=tROYS5LbywNPYmMxWuOSdlCprtuDtvU69EMC3C7MzofiEHyOK5OI1qkumt+XZWbIpNjQUG
	pXhY3F463bZhIrmcBbgwQiaObtp++zmt23LvALkTMlh5S9iobXskoTwtOrr9BnyNmx+0hc
	rYtSxPLTIvEL1dk99P/K5kl0hkdDoss=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DaNjvorKuKqv1mqX1+UPBqPDqrrEuyh1x/9lV1olv4Fhc16w+vPHJglVy/L6zgTKPv3WTSWvWmC32dsoaMmOksJO36usv/wmJ1tHkdJEE4WV5OzVunT2r6bGJRiZsI1LRKGzE4I00fbkXTFIpJyuqoSgtkkjvQdp0WloSb16ELKAwXNH87QhQjGbwsSC5bBw35iw+Jh/OGOJOW1pROLXFLLknqCq7tIiHVKoeTOJyjH+in7nAbAdrRwA2aiWuqMMjp4Q9AQkFp1mtPN/jh5A5dY4pVuqsWhoOylyz+ceAXCBfMdXC4RRReqWLEMJxsLslN6xLi1+kM+2A48l+Y+ebg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Csunv4ay0ersKu9D+/xbcPqUb4eanrv3W4tEcydndrs=;
 b=yYwPfjOEv2StYuSyWiNy5N9ksM0z3BHmHcuCUArcSFJCT15yotXqBvH2XCyF0E511r4KurGv8gOkVSH5hXJcu19r1b4Lrdt7LhoO0HEnlZJNmYsol2E4nPT5WmCkiRRg7F9xnjexFYJp7/kgg1rVR1LSpcxorYPYpHrgoTR4X8JufhoG4xz4xZKNLPSemQO/l4B+15ls5OpCz81RGknND26wWczD13kRFOd63GPnBY3tDBQ71h5IOQjDDK4lruZtEPoemfVq/CvD646YYqeXcRHvN04F+K3i2h13TiGaLJNBi0K9MI5kxx4gDK/XmJwQhOGhnT0LKcQkedgrCe5XIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Csunv4ay0ersKu9D+/xbcPqUb4eanrv3W4tEcydndrs=;
 b=MVnIu3L4750LNJGDAZy7+Xw11rS/Xyj/1J5DzXlhQ+KeIEsCtHcKjrDi9KKC4eIdt14dC2iF+JVSg1jo6FOpIDsVnMemDH/FchazwUdnDbd6uO7M4K0/TY0ds+2m5kiorfOxpvsoIbITWkoVWZ/7vQ/GHTfvnrpgyxoP5BM4M4g=
Received: from PH0PR07CA0103.namprd07.prod.outlook.com (2603:10b6:510:4::18)
 by PH7PR12MB5975.namprd12.prod.outlook.com (2603:10b6:510:1da::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.12; Sat, 6 Dec
 2025 10:15:18 +0000
Received: from CY4PEPF0000EE37.namprd05.prod.outlook.com
 (2603:10b6:510:4:cafe::fe) by PH0PR07CA0103.outlook.office365.com
 (2603:10b6:510:4::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.12 via Frontend Transport; Sat,
 6 Dec 2025 10:15:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE37.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Sat, 6 Dec 2025 10:15:17 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 6 Dec
 2025 04:15:10 -0600
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
Subject: [RFC PATCH v4 1/9] mm: migrate: Allow misplaced migration without VMA too
Date: Sat, 6 Dec 2025 15:44:15 +0530
Message-ID: <20251206101423.5004-2-bharata@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE37:EE_|PH7PR12MB5975:EE_
X-MS-Office365-Filtering-Correlation-Id: eee0e76f-8f70-4023-631e-08de34b05b05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?49QlquUi8ou4X057+H1TnfXZXvfIjXTbyp4yCfOrzDowdBrwdAQJD0eMdTW3?=
 =?us-ascii?Q?etad2v5mMxmYYIv3sqCZyx4yuGAVbhaDObuu7a2t/kpCu3icszujS7zesKmZ?=
 =?us-ascii?Q?mhQUO4p5EGNJ6r4jj/OitYuikRVo1g/d7ckV0A0RDAz0LHHAb4BJM7LqW7Oh?=
 =?us-ascii?Q?8VWlx/hvL+b/vw66z+bzor2SrPyx3mrAd6VTATxi6l9W3iuYFHgKMXWw0Gsu?=
 =?us-ascii?Q?AJeR1hSg70GgCXxOJm1v23FRrGplcJd+xjSElgoT959t9sjgED3WZ3NIH1bT?=
 =?us-ascii?Q?z+deIGRiYctKSVLrmDavyNUpjBvy0CAXJZ8N/0D0phQSg6z5s+KYxiotHaVZ?=
 =?us-ascii?Q?5fgtTgn+rERRSxdM02t5Ark0THLQG6zQzOABMCNl+e4zYZaVo2bxflLhaDyf?=
 =?us-ascii?Q?OH/pfx9it5hVZC8hJyBGlw5xFMPVd8TiuNgiGEEje0sTNcbHfCmd5x+wgyu9?=
 =?us-ascii?Q?Me/uG1DiLSmCfthE7Dov9LsJAgnK8AiC55bEiTZgOtV266ZPnd8yQOvr6MsI?=
 =?us-ascii?Q?bulvqD+FgxAXwLrecOXsDqB5bespQLBWvZ3WGjyLJC23VqG1EoQb3aDo7Hk+?=
 =?us-ascii?Q?Ki8roBfRfVPyU8drMBRJ9PLCNorIaxDA5n5OMLTHqT4EZIu8KYEIxZ6e5M7S?=
 =?us-ascii?Q?92aUL/W7gEa1bUDov75RH52947KyleEy5bykWeMHrWeIqUTi5g2VMJZUKwuL?=
 =?us-ascii?Q?NbI2svOdzd19pax2cQElw92oXOncjTddbyNwwo7LG3uD2E49rIR7vXgQTm3g?=
 =?us-ascii?Q?dggwNGNiTP8o7yhA8iBCOfDsmzXgYzcQle0xstsckfNg4jTwdV0rBmlpAOvK?=
 =?us-ascii?Q?JKGTc+7mAW65dm7AgVkAukkWOhNheJIPIj5t7LKvPdBp79z1YZV7NXTvFE9U?=
 =?us-ascii?Q?rV7Ty5Cwf4m9FchReXEwkF4X4dEhJXK/lvz2X0o44gYp8AjJWIqtmddfpG39?=
 =?us-ascii?Q?ZsrX1Mx6zhRCg3IZ//vLxvOPDFIxBG/2p3fOTo7HM5eri6chv/j02mdpOrp7?=
 =?us-ascii?Q?cmzbDi9LMuZWI23kaN66njuWVHo/3n8UYQaqlw0bQt+VZ/X91TUUsSDQLyFb?=
 =?us-ascii?Q?7XsUcRxF6yVP6SGz5HwwOqW0pwI4OJRTCNtT5cbWkpNUeFVcwlOZdKhERtaV?=
 =?us-ascii?Q?6nXVY87+DG9E7EU1bbc9GdGyXTuj2DuQR+ydGZbsULs7gHaCUwTy0BpKGStS?=
 =?us-ascii?Q?waEB2WNUZQmt0J7R2h/INhOSdVtoOvc9W3pQIhSfAl7/jrgxW81V92S5GsFC?=
 =?us-ascii?Q?EiXTfAS1F0lcAA2j5PlymX3ONEy7KxBlsG0vpR22TkQqwop2woizqcajGwvz?=
 =?us-ascii?Q?0S0EThPV1HwtF37+Ao59SmPyxv1yZ5U/8LvnzLuwanOfA5bEQ7UArbe698zf?=
 =?us-ascii?Q?gnmr5pAioy0vojbbCzPF9guzL/9QCzfZK+P50KSXlP5ezBP20IhMQu98kKE1?=
 =?us-ascii?Q?UP0/RA2suGzRiPHt8589O9a/5t/Icnj6+kDyyTSvxDUVmwrZDydfZd9ZY8f1?=
 =?us-ascii?Q?zb1xd2H8Ttc4Viy7u8jeVmyoxRDeXA+lRfH4A7mBxQXfCiR1e374KkK9dJjG?=
 =?us-ascii?Q?5l2YIMWUaz6b/Cz5iyU=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2025 10:15:17.8264
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eee0e76f-8f70-4023-631e-08de34b05b05
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE37.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5975
X-Rspamd-Queue-Id: 681D140003
X-Stat-Signature: 9tbpe9zzd3twasna7u6s4is56myqi6o4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765016122-593070
X-HE-Meta: U2FsdGVkX1+UpVgMH2kzfnXCMph8bGhxOwCYt5Frjr4h2Gjh+qfq0YDrzj0CLdnnA8jMhdGvq+noHgr0s3oCHXhx2qT2n2HUJhs0iBsArFCSsAurhnmeE/GdjPkDPmw2e7JND3gOErIWiIOGqek49vlqKojOxaFTyn/Jg08iGA/IBcqgqsLdRVMXOoPzYJslJA2Up3Trk4oXCgLbKZcCpvyrKZfK0o0o7Z6g3PHH4m+HnLFoxj7lrt93kgmdbiNni6J0TxwKVI2wvCYDy2l830LWRBXjjE5C6r6mKTlkerz0Elh4Nn90A/dlhxeXRa4mN7kNPrBBCDcRw04awTrTCq3ZYY5wprmS+GTA+7emLOH9sJrxPAS6NsbAN4Bh7UtWLQQXWnL2IgvwceaZjyppCuyqIoYTmBUR8p/oCiVgHUOTy/xj79o88SGCLolsoGNotDjVLri/cnwiD6+cuDYv1q82q7NM/r/wqhZsuaZC0tEKpBoEHFG/sYgIqqqJHij0zEf0loBrgDqGrVpMrI2q0KsrJ9Qtsok6wri0JUnt3bFwGAPnwSNDSlJf2A3fkADg77eKdwMSJlSKSboawhq6uQRBjxVoX79HdkFf9eHx10jAaW9MVl2v4RLupimfY6NsFi9jtYkEloIPFiOiKbooTFF2oiGcSiAM/6pEHbOH/DcNxdm7FD7DghCCN3L4p/52L3LCDmza8tJOxYFqqLglvBK82MDByS9xs5xyZ8YFfCaiJq1b2z0BQ15YkYBFjwUNHmjimEemrl6GtjAJNoR7nhfbV+kOUzyCLVPmL/xs05gCFJEPTTNdg4Qeq18QnC53bKgOlpKS7sDMg6NgBxVbeLUle7WyFYn0SkTBBAIsM5vZY6aDJDBOWG7rql4PWFSUcvLBzCiDTyMmsI+ikwFsitnJeT9L0ICBFDn6GrlbNmP6cXCsbdbZTSNIo64ufvcfXcAkTEjubdQTZbn4NPY
 lsYH5/Cc
 X7YugvP2fUnOdkEp5VZPGRiakqZnjwHcQxeNdrWouU+t1VXg/CuGy+7qz8RBPw+fOqR85TIrMcTiaBz+mZEJEw23n8qfG+sfmFjHaVRSXZ0IYWCSuzsCHA3+i2jzjuEGIN9U1Cs9HvqHPh5Qxg2dd1CeGlrwggzG6T/QeeJFzvx6Om8XjpWwKFOPpNMXCHC0E1ufoCjGFw8cKbB7lUtzIWrGmxSfEVjrI5dyuRnCwfCs0YlT7rnf5XrWCyOYMUksUK9/f08ntVnet/XH36IVhD1jd2YEp4VuUZiERq6FZ7wz2ZM9/zuOHWfeHT7FAxlMqPoAlQ8hOEnt7nYkaZwDJa6vHiOhHeQ0h4ynzzmJfSWuDwW/1Glu0hcXVtYPPLerCu28PdbTuEnhEI/2yykWjxBwO9jfdvYpxgglhbLJqUrt1EhOsSwqe2CekiqQQ554KC1b7RglmFptkAtOzttuph9MKfIE7IZaLXIUznuaSk6+mLBb0Fb5KkfXwI89xoFnlhb7vxImnHO6um8Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want isolation of misplaced folios to work in contexts
where VMA isn't available, typically when performing migrations
from a kernel thread context. In order to prepare for that
allow migrate_misplaced_folio_prepare() to be called with
a NULL VMA.

When migrate_misplaced_folio_prepare() is called with non-NULL
VMA, it will check if the folio is mapped shared and that requires
holding PTL lock. This path isn't taken when the function is
invoked with NULL VMA (migration outside of process context).
Hence for such cases, it is not necessary this function be
called with PTL lock held.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 mm/migrate.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index c0e9f15be2a2..189d0548d4ce 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2644,7 +2644,8 @@ static struct folio *alloc_misplaced_dst_folio(struct folio *src,
 
 /*
  * Prepare for calling migrate_misplaced_folio() by isolating the folio if
- * permitted. Must be called with the PTL still held.
+ * permitted. Must be called with the PTL still held if called with a non-NULL
+ * vma.
  */
 int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node)
@@ -2661,7 +2662,7 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 		 * See folio_maybe_mapped_shared() on possible imprecision
 		 * when we cannot easily detect if a folio is shared.
 		 */
-		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
+		if (vma && (vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
 			return -EACCES;
 
 		/*
-- 
2.34.1


