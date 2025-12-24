Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5234EE75448
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 11:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93DEC6B0005; Wed, 24 Dec 2025 06:17:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EBDB6B0088; Wed, 24 Dec 2025 06:17:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3186B008A; Wed, 24 Dec 2025 06:17:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BE7D6B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 06:17:39 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3835F136B51
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 11:17:39 +0000 (UTC)
X-FDA: 84254114238.18.3262AF8
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010017.outbound.protection.outlook.com [52.101.46.17])
	by imf06.hostedemail.com (Postfix) with ESMTP id 456CE180005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 11:17:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=dwM4QIAy;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.17 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766575056; a=rsa-sha256;
	cv=pass;
	b=uPkDFU30RNVzTC3CKRO6qUInVc9v8DrvMf9R2YE0qzHXOYSkqL1HG6U8uquKuJWOYR6zlr
	0dx4dUxtAHOk7T2C8NT0uMQBoSxW8IUNv7EoQCw970kDod88ig9yjehvUM9Hs796OM7j7/
	XS2FutZX7efTL3q/UccJ17oUKj9jkl0=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=dwM4QIAy;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.17 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766575056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4p4M65WNV3MGQ/hdJ44kNFLUHDXDMxnmZb+UKaKV+uA=;
	b=7rT6hm8qjr07g1KzRIKE6rwh/OKOcPIIpd1QVKj4vP1tkn4PAxRiwCyyC6pUglMF5eSIWG
	VwLx4y0cHPnEI8v1F4w6YtoFlZ1rnj/vGZCYkcq5HHoEdXxduZJq0I8BwkhikayjLQ7T1F
	qskcadePE7fyZmIuetvDs+8pIVGvpu0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gZhCjoCdsiaT29h0vt0xpfABytd1xexGnVEQ+I88pB2gBRgBHgCUAudrmq5E29yfGgclEJfs2xVno24xscmQQ/ZgOkdLsVzxI4turySW7SGN6EVW9+VFS1Jr95tv2X9A34uQspplW9DxZUf8ghFYb4SjgpZG7gCwqQh6Rw3MrGaQXF86NI5CoEq0jwLqr/ViwVGCRcI2QiQWWrGSOtV7t/sbeqmWO+TnwF03Q1mO5kmKVkd+81NZE5RzWjCf3RC0yXyyRLoS4/vxYWkmAKZipZOKOGl7Peg0CaE30U8IlQ84gz5b8SjhZg7c5qUzW6goDDCto2PyWPc4njGMkgaohA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4p4M65WNV3MGQ/hdJ44kNFLUHDXDMxnmZb+UKaKV+uA=;
 b=kkCfng5MW1x2AjM2rG2CiSbTbuKz60TJcuGwIfTY+7TChxbr9jLDna49faZTYsv9ItpyUR9wrEj4FxSzv/PL6shk2OHJDbttHUrGAbaRbqSfuxf+ILm7zh/rfzeEZJjp+NdH9bw5GAf0wvpsNQfZ6hfJBHe6KO+qAXEQlU3LQmCpsYNAVpZWvNtkEzZ4zRHlaVZDNaNpxz2JNHwCf3aU8TU0KRHK1XJm0NE+rdtn13jy+sh3JNjUOd/t4Sxcp4O+1xFAOM7RnpIXWZ2bD//BlN1nhnc/I4ZuNiVlquTN45gjSMKKW8boYurz1Vn3EBl0Nwn0J3Kf3mg+aLUI0/3ysg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4p4M65WNV3MGQ/hdJ44kNFLUHDXDMxnmZb+UKaKV+uA=;
 b=dwM4QIAyRpTfrgsDlH2tY9GAQ7UCotklcKJHrdVMtdvgiRT2MayrGxxNQ7f74s+blpXz7AdUhELUpE8tp/owjK+vJRvG5j/alptTHB1Xxw//jCF1DvtjFnasQt9QnFX94808Kh1eHh+Yt71e7tkicNHKUutbTNG4NMIso7DqyS4=
Received: from BY3PR03CA0009.namprd03.prod.outlook.com (2603:10b6:a03:39a::14)
 by CYXPR12MB9277.namprd12.prod.outlook.com (2603:10b6:930:d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Wed, 24 Dec
 2025 11:16:11 +0000
Received: from SJ1PEPF0000231F.namprd03.prod.outlook.com
 (2603:10b6:a03:39a:cafe::7e) by BY3PR03CA0009.outlook.office365.com
 (2603:10b6:a03:39a::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.11 via Frontend Transport; Wed,
 24 Dec 2025 11:16:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF0000231F.mail.protection.outlook.com (10.167.242.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9456.9 via Frontend Transport; Wed, 24 Dec 2025 11:16:11 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 24 Dec
 2025 05:16:07 -0600
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <shivankg@amd.com>
Subject: [PATCH V2 1/5] mm/khugepaged: remove unnecessary goto 'skip' label
Date: Wed, 24 Dec 2025 11:13:51 +0000
Message-ID: <20251224111351.41042-6-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251224111351.41042-4-shivankg@amd.com>
References: <20251224111351.41042-4-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231F:EE_|CYXPR12MB9277:EE_
X-MS-Office365-Filtering-Correlation-Id: 8294ba60-7d2a-42a9-35c7-08de42ddd83d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SzB7ZcCEY7g3IAbz/Gbubz2o0EZUEOXHZeYz8L1hgbAl1YUgEaroy2RxQUAI?=
 =?us-ascii?Q?H9m7kXGNWmkfn9NGJLRP4uFHcs7xNrOpufychN7Mnn6IJyj/we8ugsaft8Kw?=
 =?us-ascii?Q?POXGz1Ud8LdLF/GVwR1Debs/GYD3lcQYNdZvkpY7jnI4bjOaa/aIjBitAM4v?=
 =?us-ascii?Q?CIW+GhmBRZ1esmiBwqIuTC4BVq3AEop1fD5KReMAxUHcXZeAes/kNPo7rnxh?=
 =?us-ascii?Q?UMa0a0G5i5tl31OW2TXu/E/XvZtOUyzJnCu+CrEUBBCJ1teC54cq3KtL2juU?=
 =?us-ascii?Q?LhepjOyOCrftbCwWrBVHcWAlLFv05z4XZ+zCDI9FUe9MBbB7UWsfFFkiqTcQ?=
 =?us-ascii?Q?554Es9LP4UFvqaf3ZmTYYh4c7dBHwQ5nOeJfwT8Zn3wejdzscN8PDnx6NMVa?=
 =?us-ascii?Q?n/iEVe9W563J9It3vVAk61ZrzdCqVgYpnJKGs8j9eWvjY0YZHVtKoewQrtuf?=
 =?us-ascii?Q?7ughCiWi+xrEDugeZ+LoDPkhgm7GnkbdLpH+VQGnFaqhX8UBrv9It9MGaaXe?=
 =?us-ascii?Q?DKTiZlcKoh4gUukDcxorVKEtp74OdvLEGII9qFRE8cHXd3gQWYTLtspxKDxi?=
 =?us-ascii?Q?L1McgArOT1SjZDRJbK0A4ZZVUQuYTcKTRso4CGlUD7t2xsMusxLA4zuPJLkt?=
 =?us-ascii?Q?rim19tj1KkRQUEFifubIg7k7yQMhOUyQ3yipXTrts66kUeyUaVryyO4MFZpe?=
 =?us-ascii?Q?QZAnMI3yUoEvXIF2PBsEC2CwpJrXKAFkH8BFgUNE/afT9aOxKCFQDDdA7njD?=
 =?us-ascii?Q?/2T7e17WVYWKko39V6lso0v5+pETwsEJ+jRUL9S8iiC92d09V2DSmahL9clp?=
 =?us-ascii?Q?Q9Qma3qIUCoWRiCF7+6KPS+64JAv2yCHxBy85SX2pXgWO8ZWm2b/IIrB88XL?=
 =?us-ascii?Q?Q2+fXN8KlKUT6SYbqDEHrWSSGTYWUvPp7tHdu1kDKHKyNjDU6CYUejcdLQQ0?=
 =?us-ascii?Q?6Jr8RCyFjauGuwanca9sMZibNszBEb2seVxX8SioCKmaty7j/QQyIJIklD4E?=
 =?us-ascii?Q?8jLD+kUyw1hdRRqUNAyPG0N0VDdcK6uCAx3MYl3Ar6DEzZmsuhpj6z3Tidvk?=
 =?us-ascii?Q?Ve9kALE6IpP3BWkiopyHORENahN2wymNwDpvm+mzDgtcWickWDwdh/acXAD/?=
 =?us-ascii?Q?EdjoHWy9G5ZZwdMhqd0GwRqiXfGW0Xg+o+2LYf8OBHdwMNBICtR2Dqp/ifz3?=
 =?us-ascii?Q?QTpyIIclpxMTctpAxnuzV/CI8uT2bp+VR9KBXMybB1aGbKOBxwFk+22tNOBI?=
 =?us-ascii?Q?b9b7q/+EvSVjftXowfC2+2f/2Cr93fAGB9fMGR8THE6fEqCIP/lkmoNNBFT7?=
 =?us-ascii?Q?EO9am837XzS6WPkmVmR/oFVtWP2/Sjm2od1lOFhGWvx4hUgV+JK+Mma8sFuK?=
 =?us-ascii?Q?ifAfxw77lWrwby2zRo1T0ZMw9UKbkLe+IKwKzhSh+V8B3b97AG5m4qCRukZ6?=
 =?us-ascii?Q?R+6VdbgYncsfpHmofpSQ/NNvIepDPylR3M8diw7tH478cM8gv85+0QMVWmgi?=
 =?us-ascii?Q?F+rNyqAgGJG5RjzlztRwyNTeA31WkXw3NrAH8Ye/V3odd0DHB1lwFz3LlaPk?=
 =?us-ascii?Q?+SS/I0UeMvOenYHdkY0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2025 11:16:11.5555
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8294ba60-7d2a-42a9-35c7-08de42ddd83d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9277
X-Rspamd-Queue-Id: 456CE180005
X-Rspamd-Server: rspam03
X-Stat-Signature: 8ge1jiqiontur7ezuxg39bpexxwpzt67
X-Rspam-User: 
X-HE-Tag: 1766575055-207621
X-HE-Meta: U2FsdGVkX1/mmVKOS12uKJV9eN+SVKVwKP14BLOSF1bqWUom5zVWQFJYT5Eq3DIibLy/p12g052A/ygBirVG3weEleQNGfXVCAat3/xiW0ZWDZ/Kn+LX1tJ9X7mSDBZ8HmxJeSS5I/laL3c4o9t79hbYmrTyrgfWDNluLy7h2We/G2oA4YXN6BonEVm/4IwkrIUt2h0JcjpGnIPIU/OVCOcJ4D2TgKkHyxDfIppNnuzvj2UyT+3IFOfmsjqw4odazNs9uEBpByVuJ3jKfOFsM6B/aCFI8PSPtd+VNdiZn7DvN1gSW/Fzx0+7GMMA8ZV5RJPLuuCN+1x0nzm9wv3n5+wTAUDM2XskPhB67obzUG2zU89hd2u6uy2iHMQ78StAOwi3BegnRSQmLMZpf4iIWdSbR/pCr4YUsWT/1D2OvVn5ekP4BjavtEl8jh+WZUkglzjCUOr/Gjsc2CA+ts0YhW4AUVI4tVyYjPFxEp38EmYEtFD9LjONby4JEC6enrOOGmLwf4VopZjnM1VAzUzAVbDAsIctGc4GPPMd1dfFa9Gfm636syTqj/Oausb99TxpSOA/Eno5xfwZ5EUdVdfVBK1WdJYiAZV3l+5VAIbAHQT10v2LzUJ3U/p0Nc/++x+fy2VUMIv5yh7lVSREVVU7BTtdgIReOlfGp+Z8wpWFECXqvds3pWtT3aM3Tn0X60WlfR3b5E1wfpJ1hEuCvNM1K2Z0a7+/XAgnMixhE40Xpr/SJfvFY4geCmG8gA5gY6v6rpFVi3cZWar/Ay0UCJSgdQJ31gyR9Nxy/J6haVOHa45zy+HUZy/QZNqYZ9OMnbtPzvHovHqFhgpvE5JG7bq/9A5CFJlnW1fwLFUBbG0N5Mhf6yVjqV30c9Amjf5GlKU+hjNqxZJTMlKpyY0iLdM5Jr7sqq6gyo3MH4t93VTaQ06m/niGPTUQSDveFzOzJEIv4lOPc6xN+MLcQM8Pwyk
 JMGMcnUf
 H6ugADkOmr0s/gL/1ktwyBhaG0z/jZb+5OD0XxuZClhtujt2wnaC49jPxZlX6lRK1U0m87FqKqLrv4nkavrCqnSfnK1qPOM+ceJMiIqi2bkYZHOW0MD7qz7qbJYaoYTVtJYnSo1onmHIjTjdPpiMxKdj8e1NvY0mJqvqHCUmD3iJSeAOxmBnMrh/Lz+D4ftxdYv5eFs62tBHMMxApqTAITsexIVfux9QVmSGU2s5hr9KsJNGVkblPSPd9fwG3pSozi6cI1EgdREowsjpOF081E5lXPa+es7crmZ0CaXHAc2JSH+8kvzEE3P163TG5Jn4favFsQ4zlI90Ln/HfQjxWJ77ce1DjPPDuHmZFdrsavOlU19ZlPcE6iT6j2skKrxbkpq4aKSoXGA+QrJ8wGB7kzLC0bXBGqKGLoqMA7P7X4WKzux4cR7hv5pFLZjTiBTb3vUm1LxvK3BIvVCQcPR2mOD3kMUiVtmw+h+aXGG79ikryHDb/Msxwxd0jr9o2BHNtRfeFSloofUdX03U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace goto skip with actual logic for better code readability.

No functional change.

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/khugepaged.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6c8c35d3e0c9..107146f012b1 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2442,14 +2442,15 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			break;
 		}
 		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
-skip:
 			progress++;
 			continue;
 		}
 		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
 		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
-		if (khugepaged_scan.address > hend)
-			goto skip;
+		if (khugepaged_scan.address > hend) {
+			progress++;
+			continue;
+		}
 		if (khugepaged_scan.address < hstart)
 			khugepaged_scan.address = hstart;
 		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
-- 
2.43.0


