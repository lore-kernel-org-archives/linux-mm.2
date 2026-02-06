Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95A0CEB28CB
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 06:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0935E6B0093; Fri,  6 Feb 2026 01:26:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07E9D6B0096; Fri,  6 Feb 2026 01:26:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAC4D6B0098; Fri,  6 Feb 2026 01:26:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D53536B0093
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 01:26:28 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78339C2303
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:26:28 +0000 (UTC)
X-FDA: 84413047656.22.357E6E0
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011028.outbound.protection.outlook.com [40.107.208.28])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5BEDE100008
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:26:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="ghknD/qG";
	spf=pass (imf14.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.107.208.28 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770359185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=C46sjLncXjXV2jBMVTHWgsbDg+XtoYV1Y+crPTkvLzI=;
	b=L0EU0w6l/sDc+WG7lssqtHSoE21VBZoe1atU/j7mfTxPzQPhfA76Ot+CxC4OOlDDmoGoMv
	o4+PVDvbLsD/FHjpEIZl+xs7lVu4WnnVRbn+DYnI4Q2VeXrn2ZdM7/jN9N9oltrs65AG7V
	7HDclW3z16B0S7pPYs7vx/N1lzPwFqc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="ghknD/qG";
	spf=pass (imf14.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.107.208.28 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770359185; a=rsa-sha256;
	cv=pass;
	b=aMy35dURhzBUzkeDU5PYyqSKdTL2S2FwS5tZLwW7zmbc5QMwQocieBE8+SIia20Pw6Faxd
	Moz7a2nqoiHyzx9nVU2MNN3F5CZLLjWLWP1poL5b9FhnZvXo1BuawJWGJCl9TScAsbc/2/
	SGyxAku1ZeN36KbR+Wv8KTAYAwnliDo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iVVoQO2KB/NS1TIM/k3leMwk9fVBL1kuP4xXk/8mn6pVDVZls+uvjJPHkiN51mQTAyEcsQ1ZKOPBmmqXNi1ssDzdcec7etj1Q16nsLtgVipKNZ6Fht9IN8AY0L7bF7gp7JjctUE2nQxzYqvh9abo2mmzflDtjCaMI41ClGtRkkNam9/owrDdlNaW9+5XWl48Y+pSaskvwgxATB47HvUTfUBQBKxyA1wSkWR1cgjOWWfPgpBR4QQR0MFIAR8rhHpQgPt2b0UQcQsZJkWpoOA+Z0HJgzZAWgB7NlARJK9QJajkjygeiRaZabPnMaoAtcftomFWcWYCb+/GJTipTpTI8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C46sjLncXjXV2jBMVTHWgsbDg+XtoYV1Y+crPTkvLzI=;
 b=KTAM4/s5kcJgbYf53I13Gx9lVe/bytWx/s+hy6dI3Tx01Frg8lCTdopo337h5x+/7CrI/b1Ap/z63dlr6V6wwwkYRFhV/6pW2jfEtm5FWiNz/zmM3UZVVFGweWNka7mWCsqEh2PdGitVVTmcYVKu49C9MVdbYZQ4cxapjPs8+d3AW7YHbdFHd4aLg4+S+i+F5/mJRIKG3DKIx4CjaYLa6fBLOugeAEz4Nf93MVKWoPh9+p7+YkWxF7eGENJ5KflidknXH68PdPRPVYkoclgqnFg6fOidYGRS076RIL4YJwEL17JlmvYAAH2qJFCPe+YU6KwvuBdZShRVR0aftdVzTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C46sjLncXjXV2jBMVTHWgsbDg+XtoYV1Y+crPTkvLzI=;
 b=ghknD/qGiDA5TtYXe6Bnmuw0qKrCWmWmWXWGr18Jy5whbApihq9VjXfMYWEpLd2tJgpwA/lAZ5BjG+hlVDWFzQZE5QnreL6fxYMmLjz58wOOvbebcMbGI0c68HFNoRjwAdIQvNYgZD3aFju5f+5opoFOzuejSAu5rCAxI2nVEY4=
Received: from MN0PR03CA0008.namprd03.prod.outlook.com (2603:10b6:208:52f::15)
 by SN7PR12MB6838.namprd12.prod.outlook.com (2603:10b6:806:266::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Fri, 6 Feb
 2026 06:26:20 +0000
Received: from BL6PEPF0002256E.namprd02.prod.outlook.com
 (2603:10b6:208:52f:cafe::bd) by MN0PR03CA0008.outlook.office365.com
 (2603:10b6:208:52f::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.16 via Frontend Transport; Fri,
 6 Feb 2026 06:26:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0002256E.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 06:26:19 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Feb
 2026 00:26:16 -0600
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <Xinhui.Pan@amd.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <akpm@linux-foundation.org>, <honghuan@amd.com>
Subject: [PATCH v3 0/8] drm/amdkfd: Add batch userptr allocation support
Date: Fri, 6 Feb 2026 14:25:49 +0800
Message-ID: <20260206062557.3718801-1-honglei1.huang@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256E:EE_|SN7PR12MB6838:EE_
X-MS-Office365-Filtering-Correlation-Id: 50306c3c-3e97-41ac-7937-08de6548a435
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4a/xuwNdTMjLvptWl1b2+beXR1fA8SWg3sZmQF++NVEcQzIKQNow9jlHrY9Z?=
 =?us-ascii?Q?XIhWohX4C3+Gxnng7Q+fC250voCmzEBu4Pb52vo8E477U4qRYICxsTIjGoG8?=
 =?us-ascii?Q?DAM7IJ1onZuvh0YBFSgbOP6w3qOessYusuG+zKrORqNYy1ISnUyMcW4luun+?=
 =?us-ascii?Q?nNOX9k8ZS/iKTWTd4F+/zXS1VaB6EpZ6rhCBBlFMgs8oCrlG/cq5CSFewWnY?=
 =?us-ascii?Q?0KznTWEJcUenjMNGgS5uRmvuBC9bGS575im4DXqHVX6DUci15j0BkPHQW0gi?=
 =?us-ascii?Q?zRDSVVIc6epJalHpWZO2Xe+6TLX9C/vPJh2J+AuPrcSxTDigE06c39j1ZtAB?=
 =?us-ascii?Q?TVwQ/Q9pOTWNEZWt7fchPSC0fAEPk7GotCFd5nB5myAJS79PUf0EbVNkxihs?=
 =?us-ascii?Q?A9UGaQPwwzh6J92hvYxeMVRavb+np+QqhuosrBi3QeQ6S09SWkbqRXacgDFE?=
 =?us-ascii?Q?R4PADLY8xCjXzXGA5EWoSn1iAUN8u1aaK2tv3l4XlKDZ9j8blZeQlC+bwheZ?=
 =?us-ascii?Q?E2THqmu7C6UOOXWyl+t6zykbgW+37xfgte97V9arFpblMdkV5cFb+NI0e7Vu?=
 =?us-ascii?Q?2OwL73cWsqKGySQnRZLlAaeUvS0Z1+Kj4r6+M2A+roOaJYXPQb/9LxgSHRoS?=
 =?us-ascii?Q?uxIBLqcegYdcfxOgaJhw5ssCoTw2hzpmgSTiT/93bffyk5DVlBycFdUaWSwh?=
 =?us-ascii?Q?haUio1ZEJJamDAx2D0e6GnWIDdjs7HGtMrGLUd45H+aDVvEXAHSpIO4YuQjA?=
 =?us-ascii?Q?CSBAIxslpohUny1wwbWwgVs17+/JA92BltLM2e4//U+u83NcY428qupXxIGC?=
 =?us-ascii?Q?f0E1nT8DjP4TFTOjZJuk/nYJI7RDSZuJ5ThR6324UnF4rkhrZO0FdkfuU1ho?=
 =?us-ascii?Q?DiGf5zJ3Pqxd1yZsIQpQhJkBZG1qceN8xipMvlpM2rYVgwWjAtUxXol3Hycq?=
 =?us-ascii?Q?4S3Z2pD9xt+yafbSnskT4vb3seXNhsMjvoH71yFS5diiIlSEVdufoR7wOV61?=
 =?us-ascii?Q?pHpSOGBfrwle2BTGICGipfKxdtRZfv1bwPqgrdmL7S9IWCThdKwTHUdir3Fo?=
 =?us-ascii?Q?7P4tnfbw+Nvdf012rq5IbtfP1tJtSyH5SA9lkJZk6OgDHtZyLEQEEIJLq3xw?=
 =?us-ascii?Q?HgtP/iJtQDGRIQOLz1cPV4hIEp4g5Co77VZZAWiY2c/Ye/RDc+ulIygGXmBB?=
 =?us-ascii?Q?v3k0zDaPf7dYBTvfk3sAbRBwL2S8v97qpqYag8qLJzt8D3M7rzSsmn+a2sRy?=
 =?us-ascii?Q?LazUoOzC29zPhVJ4tObvgLAwWaJYuwCvC/+6KvMrOGQ8DjbCLiv+K1E/bnSN?=
 =?us-ascii?Q?kiH1mdAE5qG84Tx93G4hgciOndMAnGgSm4PbpUiwBjXf2M0W8I3zbwA89tP/?=
 =?us-ascii?Q?XSOhqvE1350685WFsMz9qiAsTfDRfl5dxmPM5sy9+Dr6lRyPyNQNKUg123eo?=
 =?us-ascii?Q?p7vEC8G6oNsYAISDy0inJD+Zr+6aC3jG+UhwyiSU2oTVO/Pff4d1YX48Qd/I?=
 =?us-ascii?Q?c+6WrQrva5tiiOJ5/KCbkpQiPaGe1OkF5NVSEbEUP9dpH/RxsqteBYUOwHRb?=
 =?us-ascii?Q?ro3RxGBkQWvakLo2tLFYr5xwGlT4eba0iMNiZEJH6e+sgq66lUO1idA0citS?=
 =?us-ascii?Q?ULoZJdr4crrT2/FM+Y0ATv4szeGP9Rg923ekMne3C+dF9XYmnVuN3jBgk1kA?=
 =?us-ascii?Q?CvQSHw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ig4fPhB//BK1C7PQMjMdKtPQJcylQAcI0iax5KTejuIIx78n4FgUH+UxvUPW+wpHnnGEFUQSpEKDUzc8p5DbW+87KrvgotepBhgsD+XhAxEUZQjYbSXK5Qrm785mZo10YYQHvPbdpf1DRRzHdx6fMK04w3tVgaNIu31KXXRfOgMDRObSlk/MMjSyQTH/Ca1mGU7LHria1Nlm+lzaojoF7L6t4b8WCrhhtOTx0qP6/cLh7ZmQGtsr1lmIrp2KpByB5bvg0wsbL2t5epLIKDZAuZ9sXVYDrbSjuNgWEZZVlEJsRmYZwUk1DoxbCU+SXOHhLXiOu0iozb6eFWYfr/h3suNR1yVA3afZQ/5PhwosUIjbthPYWQY1yu8N0Y9G2BiMdfqFG/wSQCtpD+/1GsNHushyNIkSgJq2IM98Gw7jTzdIcJAktILDP4vBFsg46Gjc
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 06:26:19.9778
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50306c3c-3e97-41ac-7937-08de6548a435
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6838
X-Stat-Signature: fsuacm7zjhnbtyohc1kyi47qpxasqkh6
X-Rspamd-Queue-Id: 5BEDE100008
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770359185-285099
X-HE-Meta: U2FsdGVkX1+AeKl6a3EelPwEgDyuz/pARR1dNVYzXcCk+xCCq9M4BnPChKocvT0A9EZTg4gNRBGiXO8CO1K1Owg/8sro0WcLCl6mCoqsMLx3RkXlcgjx1lr8ccKZUdu/TxCIwwwhfspnDC7YxnqqCYYlaK1sby81uACs/y8r4OclFHTaVecQtyJA3i95j7cRs0N3tCG6zr63Es07ex/JO/rbnlbynclfOtgjm3gaHbmiWnjOye5nXhnEjCGLVfL79lBz9C4ODhYy6HfP3MVIjvASAcgoFvASkSDeRSsoVJ7Fthh+tkEyLmaNbkrrG4DNExiKIvM/C3HWUP8eyAZaFJ4yU0TFxAke6A4NxQoEX9Lj13p+YusJIoT/PDEcGAozRa+C8HqLlz7QY+rQzJD51TdHlz/n/BgTGCZHpGFcxk3kBGI4y7JsfgOt5nEfNGZYbx/vtnGBc/hjX1zR+Mjk/sR0zQvnhVV4308pYreqxFmmlIEmxpVy6OoHr5rEVcWCK7BqwYTSFdruINODHfA0fleobzyD8/c8rMzCn6D5BpJ4aLG4sSWaU7rIrSNnJN2kV+hA2SGtpqTHUFDCJy3tTeGU0SrwLEqSBUHyB5D/mgVL+f+wLRdRos/GEIPKeP+0N40HdGq4RBHWTNEBhcNWoxRQC4oa/F4/eqoxhEXqGjb6o/n/yx5o9mw4YwhH3JfV9Rn9YCiFp3RABmxSTLg0voJwvL9bq4/IeGHy3fa3MFb8Xq2e/Z42sHnSMWFPwWrtuZniNgaP/dfGA2s6PRwLrcFZmuCGE2S87WFeNl6hOm82SSYJi0IdvwfcYfsKJVHMFG+x5OR++j2c1gDbYtee8Lmcpn/6fRdNk9gdtOgnrYUaYRZGMjb1yr/K2wwSsPJR9l5NZOTOQtVtoj8SihR/2cuiKM1QVmqNaKYuw9vJs7oYMQ7tFvB7Gz63nXhBhf5YlDMvd20bbCCl17SsVXM
 HD9IFKWz
 n2lwqCB4enkR7pGzZU6Tkz4JGdi9xwade9ZYqeh+4q9zk4KURbRsZzY73fs/SgPE+usL+XVf6zjKTF6JC5k17OG+8tGKuNmEV6VM1ntuuefUQbVNn/sz3CMWmV0Ut3KQSEG6LCqQHSz0J3JbMZ1zJrUXgsd2EwKi98W755YYQTbcII0r52faVBhMMfl53eqki6zJleUEI33cB8/BaXsEQJAg/Fk0de7jXSoX7g3U7VD02HnvsIPembSSQyKXHqna1ZZJTgYsVpH71+FBT/1q/u5P8CadUsH4dSRSZ+LS8Rq5myG0bo5DFfpSHg6Uz4F8NpI9LlOC+sR1wYnIEtAtMn8Ch99incIc+y7sH35pVYMY7vhXxUJoU2eZnq4CADSIl4U0cCAM5g8zdAus+C4CgBBoLONV6H9CpemWvcL9NsHc+O49vO2Q/FjyZv5k2oky8mL93mLNaNZJAmck=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Honglei Huang <honghuan@amd.com>

Hi all,

This is v3 of the patch series to support allocating multiple non-contiguous
CPU virtual address ranges that map to a single contiguous GPU virtual address.

v3:
1. No new ioctl: Reuses existing AMDKFD_IOC_ALLOC_MEMORY_OF_GPU
   - Adds only one flag: KFD_IOC_ALLOC_MEM_FLAGS_USERPTR_BATCH
   - When flag is set, mmap_offset field points to range array
   - Minimal API surface change

2. Improved MMU notifier handling:
   - Single mmu_interval_notifier covering the VA span [va_min, va_max]
   - Interval tree for efficient lookup of affected ranges during invalidation
   - Avoids per-range notifier overhead mentioned in v2 review

3. Better code organization: Split into 8 focused patches for easier review

v2:
   - Each CPU VA range gets its own mmu_interval_notifier for invalidation
   - All ranges validated together and mapped to contiguous GPU VA
   - Single kgd_mem object with array of user_range_info structures
   - Unified eviction/restore path for all ranges in a batch

Current Implementation Approach
===============================

This series implements a practical solution within existing kernel constraints:

1. Single MMU notifier for VA span: Register one notifier covering the
   entire range from lowest to highest address in the batch

2. Interval tree filtering: Use interval tree to efficiently identify
   which specific ranges are affected during invalidation callbacks,
   avoiding unnecessary processing for unrelated address changes

3. Unified eviction/restore: All ranges in a batch share eviction and
   restore paths, maintaining consistency with existing userptr handling

Patch Series Overview
=====================

Patch 1/8: Add userptr batch allocation UAPI structures
    - KFD_IOC_ALLOC_MEM_FLAGS_USERPTR_BATCH flag
    - kfd_ioctl_userptr_range and kfd_ioctl_userptr_ranges_data structures

Patch 2/8: Add user_range_info infrastructure to kgd_mem
    - user_range_info structure for per-range tracking
    - Fields for batch allocation in kgd_mem

Patch 3/8: Implement interval tree for userptr ranges
    - Interval tree for efficient range lookup during invalidation
    - mark_invalid_ranges() function

Patch 4/8: Add batch MMU notifier support
    - Single notifier for entire VA span
    - Invalidation callback using interval tree filtering

Patch 5/8: Implement batch userptr page management
    - get_user_pages_batch() and set_user_pages_batch()
    - Per-range page array management

Patch 6/8: Add batch allocation function and export API
    - init_user_pages_batch() main initialization
    - amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu_batch() entry point

Patch 7/8: Unify userptr cleanup and update paths
    - Shared eviction/restore handling for batch allocations
    - Integration with existing userptr validation flows

Patch 8/8: Wire up batch allocation in ioctl handler
    - Input validation and range array parsing
    - Integration with existing alloc_memory_of_gpu path

Testing
=======

- Multiple scattered malloc() allocations (2-4000+ ranges)
- Various allocation sizes (4KB to 1G+ per range)
- Memory pressure scenarios and eviction/restore cycles
- OpenCL CTS and HIP catch tests in KVM guest environment
- AI workloads: Stable Diffusion, ComfyUI in virtualized environments
- Small LLM inference (3B-7B models)
- Benchmark score: 160,000 - 190,000 (80%-95% of bare metal)
- Performance improvement: 2x-2.4x faster than userspace approach

Thank you for your review and feedback.

Best regards,
Honglei Huang

Honglei Huang (8):
  drm/amdkfd: Add userptr batch allocation UAPI structures
  drm/amdkfd: Add user_range_info infrastructure to kgd_mem
  drm/amdkfd: Implement interval tree for userptr ranges
  drm/amdkfd: Add batch MMU notifier support
  drm/amdkfd: Implement batch userptr page management
  drm/amdkfd: Add batch allocation function and export API
  drm/amdkfd: Unify userptr cleanup and update paths
  drm/amdkfd: Wire up batch allocation in ioctl handler

 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h    |  23 +
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 539 +++++++++++++++++-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c      | 128 ++++-
 include/uapi/linux/kfd_ioctl.h                |  31 +-
 4 files changed, 697 insertions(+), 24 deletions(-)

-- 
2.34.1


