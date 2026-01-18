Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4AE7C98315
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 19:31:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F7BF6B00BF; Sun, 18 Jan 2026 14:31:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A1926B00C2; Sun, 18 Jan 2026 14:31:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 045A26B00C1; Sun, 18 Jan 2026 14:31:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E24276B00AA
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:31:06 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8024C1A05C1
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:31:06 +0000 (UTC)
X-FDA: 84346077732.28.186DA57
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010037.outbound.protection.outlook.com [52.101.46.37])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6D7B0180003
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:31:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="a/Y33uXM";
	spf=pass (imf16.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.37 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768764663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=75vKb2HAnO05miIZrAZYWDTsuKH2uNpe30vJLBcwzDw=;
	b=2YzYZ9b2RI978A+Rfwq/7WfMEgiHIAYhqKIA/af8pr6fZYZus5Pjw1DjFoMy/8G0JcDP+P
	J/Ym00dorqW8CWsDN0WRxXWhrHGDQZRiKDsguRuW4ajcZ8qsg+p3rlYsamq7058gDlS2BT
	ws+MPI5AkTuV/d+LugZ18lwSUipE0sw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="a/Y33uXM";
	spf=pass (imf16.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.37 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768764663; a=rsa-sha256;
	cv=pass;
	b=xa1cW3TuLibbJXLAFZ5TpeUI3KdbepZ7X2UfwZHOVaQyoLUy0pZQ2yiBQYyi5uPLG36wwU
	EWS6WzUcsRMKilmIMF6dXMTA41Bd09oOyTR8tTk5m7uP/u1EiWDE2A2xLU+C2lY4ByVTUH
	k3/Y7iG1oAirjplO3A3Y1L0MBXSqi0g=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j97Tx63N5OWaUiSM/eGqKIWxAejwrdIw7mQ6/8JqEW0d2lUJ7u9grLjPg/ojgcM5ilIKSV+eAyMCDxM4bpR6RvHgFFNg6B1umUaZDFYopXw7HwlmA5V3g1skkEBCxOrjpQTMB8nwmXLUxFDl3JHHfntEA/16OHqqkY8kP8T7UkpvquQXHB7Ohc0Z05PEEbTeWodSIn/oqusgZ2diWtdnG+3dsAnUGOenylUwh9x9qNVzFyXwqqojb3LjQvQm1cGtGdEKHwvjEaLXltmuj5srQN0N3zf77otQl4nYi2Ssn7AEKERMNFq3bNrL+HT/9zu/j/EinlaRXtyys3IwkS2FCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=75vKb2HAnO05miIZrAZYWDTsuKH2uNpe30vJLBcwzDw=;
 b=FQmNx1T9Eruo+Cvi5b8rY92AcNBXUUQRW0eL0cIxJlBLGrsE68W3Jc/nywo+kkk3qADtAcm6NSJJSzJocawMXho6JXvPbIfLLe1/gGwmyZnUA7b9lHexG7LXV/sLtW6s60uKFjbUZAG/M3bn2VeB8PWXWSDmFIxAMeaxrgceSMz9FNSD+gTzvr2B+/GsmexkzplzajLGVc+j9J6CdlWLkw4TgzJWjJcfqTWJL1VjzHWl93mmMKyOX5NuNa0Ie+PsT33X06Yvb8m79GB6tm0DMluYNB9u9qhsg2qyFw+SFD0mjaS5kwcTIQyhN528Pbo5PyrZGHpof1B+yRKlgnek+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75vKb2HAnO05miIZrAZYWDTsuKH2uNpe30vJLBcwzDw=;
 b=a/Y33uXMdQX7X6fMA0ukYFZjPXkG5CXmKHumJYGeEc6bQWCcDveQcCAy9CVesIuluU1LKnzKZE0zQaFJ6uC+74ChDXM9ArYa9c0uEmBAFAdDuaGOKdiFDNEbRvCdHs0pPYBQTNSG16T9301LIlLKwnEyS5PCHB9RhiVqZiT8V6I=
Received: from PH7P220CA0036.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32b::35)
 by MN2PR12MB4125.namprd12.prod.outlook.com (2603:10b6:208:1d9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Sun, 18 Jan
 2026 19:30:58 +0000
Received: from CY4PEPF0000FCBE.namprd03.prod.outlook.com
 (2603:10b6:510:32b:cafe::1c) by PH7P220CA0036.outlook.office365.com
 (2603:10b6:510:32b::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.11 via Frontend Transport; Sun,
 18 Jan 2026 19:30:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000FCBE.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Sun, 18 Jan 2026 19:30:57 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 18 Jan
 2026 13:30:52 -0600
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <shivankg@amd.com>
Subject: [PATCH V3 4/5] mm/khugepaged: use enum scan_result for result variables and return types
Date: Sun, 18 Jan 2026 19:22:59 +0000
Message-ID: <20260118192253.9263-12-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260118192253.9263-4-shivankg@amd.com>
References: <20260118192253.9263-4-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCBE:EE_|MN2PR12MB4125:EE_
X-MS-Office365-Filtering-Correlation-Id: dcd91452-72ab-472d-422d-08de56c81a94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VNa5zFidoCfuezz6QWwjYEo0nE/T3VpPzZQCdBz78qwrDBsy+MycSmFxBiaU?=
 =?us-ascii?Q?Q92sxQBCOkxHz77V8PhVCe+KbWRwO4qF1hKlG+pGLrrZEM0npviAEerNZUcs?=
 =?us-ascii?Q?skysF0T94rF+P62FJy1JRd1h5St3o3y/1sLh5Nv0Fv8RnUpxnDoVdcWAVhms?=
 =?us-ascii?Q?c+Fq8FNhpJ87Yq2iyR7zB8zHfnH/YPVNjEVukohMAEmni2n1Iq/4oH4l5O+s?=
 =?us-ascii?Q?uSUgPGyojPnDDh4g8RM5zPlQFHoN7WN1UbNDZjX0dGQW411RQw4wnhOZBoRZ?=
 =?us-ascii?Q?EILmz3DbHjRbA0u/hUlDuSDjFvuYNmbEtf81tZMr5a7AKPUH2A1/mQOjY9aT?=
 =?us-ascii?Q?3v8YlyDfLsuZ7mxxwQXeQuPehkEsECRiOauHWNYx67ER8pfIoXNS7yDIaDYc?=
 =?us-ascii?Q?1RdTugGcp56Fvwn8yxeMAQRRHnx+Gl6tdUoMLb4pdxWDuVreiW1FFL4fCYem?=
 =?us-ascii?Q?p5Xj8jSurPlnAw82XO05wXit69GDJikh2Dnp5lK1YsuhC4ZVK/SSV44GpIEF?=
 =?us-ascii?Q?u88rJmWt0ZrIRXAev1YRl5Q4gJP2UyqTRxCvcxjKeag14rPlFAlIMS/cqFCC?=
 =?us-ascii?Q?8r9QD/vzhAz1GevNhLF9x2oc97OdadW8gCd++obsKC3LLiSZIIX4BmEcamjg?=
 =?us-ascii?Q?KajfbBQ3IbVAIQql7O1fq0z2uYaUokntIDXtvEBXw+vuMS581kKZODfwKReM?=
 =?us-ascii?Q?7k2WrXS5s/+NUULSV9DcnEHOja2Fuw+3T58MpXvUzpzzWNqTg79NTolH8ju5?=
 =?us-ascii?Q?qwWkP9CeB/wW2v2RG+nhAxMl+cIe6mS1wyGMjDlkulDzs+Tv8lMIW32eLWjy?=
 =?us-ascii?Q?1TP5mZb+oR+wXmd+UP8KHFzqMhjVAGOWgIYrImq0k87/5Ft3y5FXPqWnrBbs?=
 =?us-ascii?Q?C+m2M1jiiVA4GiBopsHBPqU40vCh0cSBbCCGBiVQ1B0xbX+sIRGXnBbBUqP9?=
 =?us-ascii?Q?daezjY1nlKqUB7kcRlD59Z4FNZw3YQNNd510PPP1+yE1yrSSfXluEbYsIqTm?=
 =?us-ascii?Q?JNPQAes9A70KC4Mj++kqa9gmIdLLXeS08Q3uOaIqPV2GqzPcQUVNeY6PmvsS?=
 =?us-ascii?Q?4xb/aKDs5R5+i0UR9OIa6Jc3qNRLaBjUwB3Y0uucnGg2ueoZJLb8RvjRcbAD?=
 =?us-ascii?Q?mSRrFbtBjyyAgiutZTi6nfqvcfujyANGP+a6ShygvrffEtSykm8yKwz8IUZo?=
 =?us-ascii?Q?a/zzv27bckAofoT0uqD1xzvRUz/k7fxV1Cm/4LjimpwEMETEzKd8h4QbpJoZ?=
 =?us-ascii?Q?ntU2rv6UBo2Wu0wUs4qEieJnr9V8ciA/3qodC1ZL658QcuKd05Yu82sbWuRk?=
 =?us-ascii?Q?2xxZIh3ZJ68ivLpu/uPVLCfm3TFjXklLa2/OlwnDsu9Lye5Ylp+MJCX+hp1b?=
 =?us-ascii?Q?zTlsY/sIm0+gQF0uW4umhyddjSSHqFBg2oeY7TnkmrtiHoyxam2us8rzYdX3?=
 =?us-ascii?Q?mnTiWi19ApGdeIXAgGa1T/OnSK1zZ2pJwZRCJpPUSQXFm/hBLgkgeVrurxTL?=
 =?us-ascii?Q?kQzN+suKHOIPwfup4dhJfws3zz3aHScHMFbOn7bxSPaEcb0Tdj6ZJp6K5AwF?=
 =?us-ascii?Q?26NaOefRJEV0IWOwsFg5XVZoQLrvr6MxY5JVAyImaDkoGNBMwYhSfG5S+wmM?=
 =?us-ascii?Q?Wvf3miBridpmZ/bTWSR3WlLQQi20ACEuhEtSTSCRCLm9?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 19:30:57.1702
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dcd91452-72ab-472d-422d-08de56c81a94
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCBE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4125
X-Stat-Signature: pzq5ntotx9wmkbmunjararnci548c66j
X-Rspamd-Queue-Id: 6D7B0180003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768764663-226009
X-HE-Meta: U2FsdGVkX18Yq9eK4fgt5boiX+UgHfRmxv76lvsPmQM3tJmHYGBBCz3hdfZ5I4ia1CVhyn6UM/GRPccjwgdsijn9X1TZWtF/y/bHI787vm68KCP7IythD+gHaku/1AEYLCt+O+5+TyWXnjnuTKucfFYfI/tX6EXeGjEgsErDxq/Ke1HUAeke0qaH2ZJnftI2XhRbzuPrsBAfCZuRpzEhbV76oH5atsg9xFzicRus0egPxG1JGq0pStR3cF3WYEfG4Yvlf0umIymbtjDY1I3tPlyfD/tn6ztW9TwT4lB4Z0ui/6ykIpOWYOxuh6/kw5rbosBeQk+4s8wFi0wU4zUEveQ++NW0aE2DASmVPpgYdd/dilVtiuFXm7LiPsXMtd0u1wF3+kVJGIM9Ke8V1isb97qaFh4xeyu//cddUj9OHz3RN7thIo+ynqR/9M+DEPlimFxrT+qNdMVFx2RevIkVp5lD/Ag9dS2iiJuUMuznsI/oINSmGeA60VpjZraxsl4uqCLOZFPSWEe3DzAn1C5XaSPZlVkb/0gDw4h1kDFZ50+uembijqL+k6nOu5+SPkPTjVRoqIDD1LYKlwzLUJU0IZTr2EKUTLzgFImSrcTphD5RQjSAAddT8Mx/YaBs47JuW7iE/wAoV2nZGGDoaGTGbUwLYGXytmjTy7sfWvZynhPnWxzPujToAvrA4tG68JNZ/YiKh4xoKGtMEUX9/T7WR2elzKK4/YCokZpqb26sxe4fYgxEGNbNwe8bWZLtegGuQTspehg5gUg055khp3Acd3gCHmwMSlsu6IhPbaZJabtNaT6P1qQyXXLfkqJAy15PdRpddHz9YgkKU1fTv0szFQodNevxFct09nHy40u17DES+2CtGuwI+51cpzYGgrCgj4OmpEpb6fODQp2RzPtNdC33eUPfm1CULXucOS/oFJ9yugUYpU8G/X9z9klyzoICUE2NhFYTVRzrisyKzNC
 XuFom2K4
 4FLbvfWSbxjQb3De6b+7g897tJQWHioTwHinYRXOjBkAH1tmSwozifb/97IgtckGXRc5FGR5ta3dRI3WphFp9vi2AECElt9V4nfTnDK75cAgKEZsPn5xgfjgSDkXFu5uAodOglcmIOGzHsEJNPzurdbffFIu80JNKBVVf4238Gx9VLm7ew+wM4Ge4x4ig59mjE1N4s5d3a77QbkJycWuIGfLgiWxQmUkXW/NNSSnh+x6Udxp+Pf6hYoNkDIFLwI/qO6QRhER8Aw+1fceilLuPbZFqQ4pEw8O6lMciNA6MNjxih8fBHYhzvj5eENwDMAxeVekEHN4mUAs/J2gk9YaMWU8WRs/3XtqY4DUIt082607T8hJRDKPh+MtRZdX98bvAl/+WfSfNU2fS7M1R1LFrPXnsMkAT1E87oPvsp7hgR7DmGUlOYUa+iPW2s0Qn3CsGq11zA+1x/jtRb1LoKNZTUb20qSriKjks3QfSFR0SWe7K2e/H2ZLybXiepJPuC/IqpnxfZJ/KNnw+k5tfLVm+R//ecNg42fgcOSpTgVSm6nPMqEs4WVPHkuxmhw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert result variables and return types from int to enum scan_result
throughout khugepaged code. This improves type safety and code clarity
by making the intent explicit.

No functional change.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/khugepaged.c | 99 +++++++++++++++++++++++--------------------------
 1 file changed, 46 insertions(+), 53 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 17f3f0043368..1667abae6d8d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -537,17 +537,16 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 	}
 }
 
-static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
-					unsigned long start_addr,
-					pte_t *pte,
-					struct collapse_control *cc,
-					struct list_head *compound_pagelist)
+static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
+		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
+		struct list_head *compound_pagelist)
 {
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr = start_addr;
 	pte_t *_pte;
-	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
+	int none_or_zero = 0, shared = 0, referenced = 0;
+	enum scan_result result = SCAN_FAIL;
 
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
@@ -780,13 +779,13 @@ static void __collapse_huge_page_copy_failed(pte_t *pte,
  * @ptl: lock on raw pages' PTEs
  * @compound_pagelist: list that stores compound pages
  */
-static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
+static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
 		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
 		unsigned long address, spinlock_t *ptl,
 		struct list_head *compound_pagelist)
 {
 	unsigned int i;
-	int result = SCAN_SUCCEED;
+	enum scan_result result = SCAN_SUCCEED;
 
 	/*
 	 * Copying pages' contents is subject to memory poison at any iteration.
@@ -898,10 +897,8 @@ static int hpage_collapse_find_target_node(struct collapse_control *cc)
  * Returns enum scan_result value.
  */
 
-static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
-				   bool expect_anon,
-				   struct vm_area_struct **vmap,
-				   struct collapse_control *cc)
+static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
+		bool expect_anon, struct vm_area_struct **vmap, struct collapse_control *cc)
 {
 	struct vm_area_struct *vma;
 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
@@ -930,7 +927,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 	return SCAN_SUCCEED;
 }
 
-static inline int check_pmd_state(pmd_t *pmd)
+static inline enum scan_result check_pmd_state(pmd_t *pmd)
 {
 	pmd_t pmde = pmdp_get_lockless(pmd);
 
@@ -953,9 +950,8 @@ static inline int check_pmd_state(pmd_t *pmd)
 	return SCAN_SUCCEED;
 }
 
-static int find_pmd_or_thp_or_none(struct mm_struct *mm,
-				   unsigned long address,
-				   pmd_t **pmd)
+static enum scan_result find_pmd_or_thp_or_none(struct mm_struct *mm,
+		unsigned long address, pmd_t **pmd)
 {
 	*pmd = mm_find_pmd(mm, address);
 	if (!*pmd)
@@ -964,12 +960,11 @@ static int find_pmd_or_thp_or_none(struct mm_struct *mm,
 	return check_pmd_state(*pmd);
 }
 
-static int check_pmd_still_valid(struct mm_struct *mm,
-				 unsigned long address,
-				 pmd_t *pmd)
+static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
+		unsigned long address, pmd_t *pmd)
 {
 	pmd_t *new_pmd;
-	int result = find_pmd_or_thp_or_none(mm, address, &new_pmd);
+	enum scan_result result = find_pmd_or_thp_or_none(mm, address, &new_pmd);
 
 	if (result != SCAN_SUCCEED)
 		return result;
@@ -985,15 +980,14 @@ static int check_pmd_still_valid(struct mm_struct *mm,
  * Called and returns without pte mapped or spinlocks held.
  * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
  */
-static int __collapse_huge_page_swapin(struct mm_struct *mm,
-				       struct vm_area_struct *vma,
-				       unsigned long start_addr, pmd_t *pmd,
-				       int referenced)
+static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long start_addr, pmd_t *pmd,
+		int referenced)
 {
 	int swapped_in = 0;
 	vm_fault_t ret = 0;
 	unsigned long addr, end = start_addr + (HPAGE_PMD_NR * PAGE_SIZE);
-	int result;
+	enum scan_result result;
 	pte_t *pte = NULL;
 	spinlock_t *ptl;
 
@@ -1062,8 +1056,8 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 	return result;
 }
 
-static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
-			      struct collapse_control *cc)
+static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
+		struct collapse_control *cc)
 {
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
 		     GFP_TRANSHUGE);
@@ -1090,9 +1084,8 @@ static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
 	return SCAN_SUCCEED;
 }
 
-static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
-			      int referenced, int unmapped,
-			      struct collapse_control *cc)
+static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
+		int referenced, int unmapped, struct collapse_control *cc)
 {
 	LIST_HEAD(compound_pagelist);
 	pmd_t *pmd, _pmd;
@@ -1100,7 +1093,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	pgtable_t pgtable;
 	struct folio *folio;
 	spinlock_t *pmd_ptl, *pte_ptl;
-	int result = SCAN_FAIL;
+	enum scan_result result = SCAN_FAIL;
 	struct vm_area_struct *vma;
 	struct mmu_notifier_range range;
 
@@ -1246,15 +1239,14 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	return result;
 }
 
-static int hpage_collapse_scan_pmd(struct mm_struct *mm,
-				   struct vm_area_struct *vma,
-				   unsigned long start_addr, bool *mmap_locked,
-				   struct collapse_control *cc)
+static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
+		struct collapse_control *cc)
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
-	int result = SCAN_FAIL, referenced = 0;
-	int none_or_zero = 0, shared = 0;
+	int none_or_zero = 0, shared = 0, referenced = 0;
+	enum scan_result result = SCAN_FAIL;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
 	unsigned long addr;
@@ -1441,8 +1433,8 @@ static void collect_mm_slot(struct mm_slot *slot)
 }
 
 /* folio must be locked, and mmap_lock must be held */
-static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
-			pmd_t *pmdp, struct folio *folio, struct page *page)
+static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
+		pmd_t *pmdp, struct folio *folio, struct page *page)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_fault vmf = {
@@ -1477,10 +1469,11 @@ static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
 	return SCAN_SUCCEED;
 }
 
-static int try_collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
+static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 		bool install_pmd)
 {
-	int nr_mapped_ptes = 0, result = SCAN_FAIL;
+	enum scan_result result = SCAN_FAIL;
+	int nr_mapped_ptes = 0;
 	unsigned int nr_batch_ptes;
 	struct mmu_notifier_range range;
 	bool notified = false;
@@ -1862,9 +1855,8 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
  *    + unlock old pages
  *    + unlock and free huge page;
  */
-static int collapse_file(struct mm_struct *mm, unsigned long addr,
-			 struct file *file, pgoff_t start,
-			 struct collapse_control *cc)
+static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
+		struct file *file, pgoff_t start, struct collapse_control *cc)
 {
 	struct address_space *mapping = file->f_mapping;
 	struct page *dst;
@@ -1872,7 +1864,8 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
-	int nr_none = 0, result = SCAN_SUCCEED;
+	enum scan_result result = SCAN_SUCCEED;
+	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
 
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
@@ -2293,16 +2286,15 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
-static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
-				    struct file *file, pgoff_t start,
-				    struct collapse_control *cc)
+static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
+		struct file *file, pgoff_t start, struct collapse_control *cc)
 {
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
 	XA_STATE(xas, &mapping->i_pages, start);
 	int present, swap;
 	int node = NUMA_NO_NODE;
-	int result = SCAN_SUCCEED;
+	enum scan_result result = SCAN_SUCCEED;
 
 	present = 0;
 	swap = 0;
@@ -2400,7 +2392,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
-static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
+static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result *result,
 					    struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
 	__acquires(&khugepaged_mm_lock)
@@ -2562,7 +2554,7 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 	unsigned int progress = 0, pass_through_head = 0;
 	unsigned int pages = READ_ONCE(khugepaged_pages_to_scan);
 	bool wait = true;
-	int result = SCAN_SUCCEED;
+	enum scan_result result = SCAN_SUCCEED;
 
 	lru_add_drain_all();
 
@@ -2775,7 +2767,8 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	struct collapse_control *cc;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long hstart, hend, addr;
-	int thps = 0, last_fail = SCAN_FAIL;
+	enum scan_result last_fail = SCAN_FAIL;
+	int thps = 0;
 	bool mmap_locked = true;
 
 	BUG_ON(vma->vm_start > start);
@@ -2796,7 +2789,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	hend = end & HPAGE_PMD_MASK;
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
-		int result = SCAN_FAIL;
+		enum scan_result result = SCAN_FAIL;
 		bool triggered_wb = false;
 
 retry:
-- 
2.43.0


