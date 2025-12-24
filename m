Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 963C3E75448
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 11:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E21B86B0092; Wed, 24 Dec 2025 06:22:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDF7D6B0093; Wed, 24 Dec 2025 06:22:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7846B0095; Wed, 24 Dec 2025 06:22:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC2816B0092
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 06:22:03 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7AAFB1A0116
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 11:22:03 +0000 (UTC)
X-FDA: 84254125326.29.5C48360
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010027.outbound.protection.outlook.com [52.101.56.27])
	by imf14.hostedemail.com (Postfix) with ESMTP id 88ED1100006
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 11:22:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=SaG2NdiT;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of shivankg@amd.com designates 52.101.56.27 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766575320; a=rsa-sha256;
	cv=pass;
	b=uoSUpXpDdvNSnTeJUD9W43gR4zRKMChaUOJkJQM2AuPgR9RMX5AgAMRVqkSP8OhpYbEryg
	WBesNwIpslq5Vif3q8PeYLB1UYRc6rYcacnG1AvFqgvwjNgUa/16AzZ7T1/AczGa1+ttTG
	c/MDzRgnVyDu4LAGdfZPjMmkKti6Vd8=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=SaG2NdiT;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of shivankg@amd.com designates 52.101.56.27 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766575320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5bp/4n3puD63bteY1+XLaL+c/x969GrvD6TMhLh3B0=;
	b=aDrUuYxl6GyFtoA2NQ5LWyvwd3tOXy7uw3jBbxE1BMsaMhN2VYVAUZeCnuaSyCP98uQ94B
	fte8R8rwYihithct7GgtVoZcKp6KO1ml3NnPyVrGaSRZFYEIFOahZKDXp58Wl3ep4d73R/
	vO4gUv00u2Qs9FAqrRkHzF4q82gRoPo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wDx6oePvt1Bdb+JNpgaB8zXF/ck/NU56incSEngUwVnUqcFfyYlL8EIpuApeaNQjew7N+mT2RcICGfWyH5nFKwWBCfMpMXKNEAvaJlUTCxl/9/aOTl27j/e6pjhZulrUmV0nOsXcWQzfHuq8O02th2SnSq+y9CANthxG01tDgT2ctu56x/sfQlzcYWqEiBuXKnUfypG7hspodu8kw7ASQO+MtAyTJ95Dx7UQTqgWhDppJd79CvzO/j9dMx96pwoGv9REckUabytJE9BF1ECtf17s1YDygZf+SlHN33ti5ifgCwSgJiq0sUWAYmOoXgeJSYRxbF3Ius2VgfFl7/edWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y5bp/4n3puD63bteY1+XLaL+c/x969GrvD6TMhLh3B0=;
 b=Q9Lsa44fzZUdkkorD4l5WADvjRGuBAbT66BB7qyJFoWljCSiyy/OcC0G8ljBbGJm8Zv6bEd+LDI9tm9/1bMMLd9ihlvwE0IJRdESl9BC8lvIo5M8ovqIFfPtoqPBUUCTe3rNXh38bnTXvp2+3//BNAaDCRwtbMso7ThfcHsT7zHhJcnZFWBIH8EyO+1X8RLHXUq5Xl0twOMSgFOCERhQiZl33o0QjinwCtnUQHZ20ft9KOKtDjxYug32+kKbBIkbeGUN3WPJvls7ABROBbnIJYMBweZXqL2330bxz3y30VPtyJKC1U2sag7qwfM4Ceh9txzkPXy24D5EWdfwEyYH2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y5bp/4n3puD63bteY1+XLaL+c/x969GrvD6TMhLh3B0=;
 b=SaG2NdiTfZD/7Wq9XiLII8lMM3GWBjEx6ymDyhM4JW0p1bFPs+l1s+9+Pqq5EJI0sFMkt4T5RfpmLF0N4atVODjD0mGcHhEIpe2DuV3z9To4cmNW7BR4R86rAuyC4M4Y7OJEclfeCujkjERyljVySGSQ6mcdoR+Q9/v5j9gYtYI=
Received: from MN2PR08CA0028.namprd08.prod.outlook.com (2603:10b6:208:239::33)
 by MW4PR12MB6899.namprd12.prod.outlook.com (2603:10b6:303:208::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Wed, 24 Dec
 2025 11:21:56 +0000
Received: from BL6PEPF0001AB58.namprd02.prod.outlook.com
 (2603:10b6:208:239:cafe::cc) by MN2PR08CA0028.outlook.office365.com
 (2603:10b6:208:239::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9456.11 via Frontend Transport; Wed,
 24 Dec 2025 11:21:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB58.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9456.9 via Frontend Transport; Wed, 24 Dec 2025 11:21:56 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 24 Dec
 2025 05:21:51 -0600
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <shivankg@amd.com>, Wei Yang
	<richard.weiyang@gmail.com>
Subject: [PATCH V2 5/5] mm/khugepaged: make khugepaged_collapse_control static
Date: Wed, 24 Dec 2025 11:13:59 +0000
Message-ID: <20251224111351.41042-14-shivankg@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB58:EE_|MW4PR12MB6899:EE_
X-MS-Office365-Filtering-Correlation-Id: 111818ff-ee15-4e91-3523-08de42dea599
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yplQsdY6bGhkrAWtqhdRYbrH3PkcF7KVC8ogTHeIVNa6UJCTUfNrE6lITfX+?=
 =?us-ascii?Q?HcuNgOMxWrytDdhBiQjajQnApOIep1/7smV51JVl2x/dx/B3Kz/ef8kwOzkl?=
 =?us-ascii?Q?uxBFUiEttrAqqOwu+p5cDHyx1L6AzbPt7lcvMJUTJP7MptuqmVuNAs9wFEOs?=
 =?us-ascii?Q?iLRoiD2Yw2/srJZuY2ukqMD21YxvaqM30jHGLrOpbqJwVetvmXXY2tkypHNk?=
 =?us-ascii?Q?J4BfIqFrESzya7VLEORog+/7z0Wpi/e0YAwXckw/KPtW4wVBFbQPm7bqsBIX?=
 =?us-ascii?Q?X+b4Hk1BWCUpZCi21g16u9N4VTwNVJOKaRbasx4pU2EFN075YRdtFx8fO0ir?=
 =?us-ascii?Q?i+0JPW8R4Afpf5GFR5+TWYvthf2lSuxSXuEBPhjcmLrBC4zdL9z2uBRhmC60?=
 =?us-ascii?Q?Wb7g3kvQPGg9hyAFt0VZFNtnKZuxo/kvObo9Exb/e+1jyFUfuHq++0pHJGuy?=
 =?us-ascii?Q?8Iyt9knKUPswmXyMo/J0WdSpA+2dn/xbxHKAb+rP1jvmEgNfnRvPnByM/jDS?=
 =?us-ascii?Q?JBGtqI1dw9YLMlmQ00z2eC2nSvEB34thMCluZO1DLZZYn7pTO+D9bBjlSC/6?=
 =?us-ascii?Q?jkz8fEWBzKgwhEuqQHFgBLXg4hik2T9OcXqve6kXb5p5yxIaG6dxxq287ZiH?=
 =?us-ascii?Q?gQzkOXn1FtiKCz2NXhKYl4ZPwxl3c5WlGsi2CGHeeOXi9ZyNP6mG6fOI5kw1?=
 =?us-ascii?Q?lwzPIA9r7j08FmfBNnLIJ+VSbgr8xX8hZxuWU7sAAaq9Irz4H3e930KjvK/z?=
 =?us-ascii?Q?PDSDHvwDJKsFqtd8nYnwgid/r6Fsgnmu4QCCTM9yExCNPvQBK8vhYbYTnfbh?=
 =?us-ascii?Q?C7RmAwFgCks+Cj7X51TNwF3ycDxRXXrf4DdWV6rTv9gb8mqzdcCH2bgbqsaZ?=
 =?us-ascii?Q?/4JUf/ecVDdRy8YnSNSH6NnCAxqdIAa+J1njuyuEmw9MHAo4SB1yUlWYndKa?=
 =?us-ascii?Q?Pmni9G5KGEoq8oFQj8I5ulcrcVgZLwrre3rB8qzEDXBMMQ3bLJpTkOhidRmL?=
 =?us-ascii?Q?a2RaujPzd94QwNWO+MzO3WYzEbLCRKstZyIO4Z8h1HA/F5hPY/RQTBCaMtbu?=
 =?us-ascii?Q?RVedtGSXEd9zultHU5JB0l0P828TT++nARzwg/xws3JeId/NELQvGTAU18Up?=
 =?us-ascii?Q?S7ySH02QZJdcIauyyBHDeHB3WTQArsyVwL5vYMMIMf7uTGnbwrroRadI4bIb?=
 =?us-ascii?Q?3TqKsDetWaox/3uBa6m3vcCFVJZvtSkrdxIgO41oQv8ZE4LyVvIq66X48O56?=
 =?us-ascii?Q?/0AXnkynUlsGhOygV1ls0Sxit27bCGOcJyqrOZta5jNYfZiOwk7D3jqwIvr5?=
 =?us-ascii?Q?1ORn2XsZmdXzWe66OrSHJtQa7tN1P8v4jMeED/D7M0MkGs2D73lx0WOdnUqW?=
 =?us-ascii?Q?s95XuOYmzwZoT++gyHfURiFmUXQw0pHErL5OWMKfuZ7dhpF2Yyc6HrggYM7c?=
 =?us-ascii?Q?4bBJOKWbXZFoIzqhCDOwyDRAwczGzjn22WAXnu3rOlJKI72BJyNGA+vC9ro0?=
 =?us-ascii?Q?H8FeEY1mlq2FGujWWUmZEdWAbF0tDMvVCI00x6Qtg3mC7ErDLzKncV3YeLdP?=
 =?us-ascii?Q?BS4J2nIZWDGGZAfH88U=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2025 11:21:56.1211
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 111818ff-ee15-4e91-3523-08de42dea599
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB58.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6899
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 88ED1100006
X-Stat-Signature: 6p37trf37e1an4menq7rd5brk9cm5aa8
X-HE-Tag: 1766575320-79947
X-HE-Meta: U2FsdGVkX184JtnJ7MJg6+BhPFs0wh1wOZ1vDRrJEAtLj6tfzmiaPGDeHVOa+p2DUQx69wPY8ghPpRu/mOSbx9Pvag5MlmksstQrFns4im4JTd9NCyYKl0Wmrsyw6G9y8JfPkGrZkGiTQ1PYc77inHQGjTDh/Uqao5hQsdDD3hup23Rmn4Jg86BVrazyuHG6mOBthamGS+/ZRD9IiVrsvcBxQAXejHRrBSk08d39HQQlzqEJQIxRBcuaQg/tmHW7fAbhMnYKx52N3WIu2HetD89zAcMyynRJza0ZoO9zKfa/q9YNVm765Xssm5y0OaA2t8gJzwK+rUzUoEdqp1NNmRT4Kfi8+CbuTrDDIqcFbzp8EX3xscVEmHIIccaIcDWOrE/TInFiJuEZjHc0hxO0TH8k008sKVcVUfssQBCAum9CSMCU3aIJZwvmRxHIXtnZkunrcsHWJN7KAVJjp0i5h6Osc73bJ06VeA4X8mVHXxY3BWJ/amkiN6Cb9Duy8Di5Ar7gQZoUTFIS3aZWhy240Xs1iWXZj36mpsVuDSwXGuSh7SJh5bk5a/r8yJnsSlIhNw+7gKt11PkNf69dJFlG0Bee1hNI/ruio+AhXcIviV0GHTvuEmTRu7UL9tynsK4vQlf5aNvZuMuoRb/9vlB7T7/JRDze+DDa5Q1NIzM3veEKkOoJ9ABqTbsPs1rhZFHBi6Gt2Ughfl9mbMmogCxhQR+XBbLG4Jv4Vb4Yph4OgYHiGxJNwBCunC+Y1fYIef2OfoNw9xcsMtypkzGAIm4hCBPF/oHFlKsmtyqfRtDrSoJlB/ERaC3PvHa+8YxODrHShs6rl1iej/Ek/bw7Y4Be/dY3tLh6ifB7aOkEgkvwDxAX1Oca0rc//NN4qW4raB4ijhs/wGow2j/kqSDMfKvL8bq2DdM/MHOZhB9UgaaXfKea0XD5qGrsHHG4d+q6hi6i/S66wUQTeOfqAZAJga4
 TJkcchCk
 m2+EA5FyhRQ+Wmnn/My2pRaEt6gOojm2YWbDROSVI5oChNGGUIcFEFFcmrnGWAaQteFVlDke0ODstM+ySWgWKdTuFERTYOK1TtFiqWNGfPMwBICzgile23M/Qb1Wq5wbNqfB/puq3p1wnYd81i4YPrrrhoa7Om+ksYSxuS6wW/g7YGjsn04ftSyO9oslqjBMaFvcD1osOFmnSiUZeSC/r0/rAZMgq3u1PKjN0WbwoUT3xOEm9Mg5fK01Ys683eByhsVLGc9tHavjFOZI4SAHbTEkRqBCODss6M7dRSrhQiTv4FcgOb1yHg2aMyOpaP5SIlgAptB5Kef0fhJ7lqxeduXmfN1E5yOtyy3ogHQPcR2nvjgKara6FFeF2qcFmAx96wxpsxU7qDmiBDPXmqzR2rLwFADNrSkajtEPcMaLwxdAj53JHD6Zwyh8sArEn/NBaM1l35ERitGjTjdobgCRQ0l3vDF4fWPGdRf3XKOXA+4PwGwNrKvzaq1gsfh5Xj43S/fusZZw50cHcGZo/3CDuwJdBc43fbYcfT2XD41xzWpyaj4HWhzAprtXNmFbv6SVczXc/uH5FdXsiSAIf6+KV8Pgo4FErPPjFnije
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The global variable 'khugepaged_collapse_control' is not used outside of
mm/khugepaged.c. Make it static to limit its scope.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/khugepaged.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6892b23d6fc4..4df480a87a74 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -829,7 +829,7 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-struct collapse_control khugepaged_collapse_control = {
+static struct collapse_control khugepaged_collapse_control = {
 	.is_khugepaged = true,
 };
 
-- 
2.43.0


