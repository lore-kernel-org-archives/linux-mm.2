Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B9BDEB28D3
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 06:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FB326B009F; Fri,  6 Feb 2026 01:26:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B2186B00A0; Fri,  6 Feb 2026 01:26:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 652FE6B00A1; Fri,  6 Feb 2026 01:26:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5162A6B009F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 01:26:55 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 13D205ACC6
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:26:55 +0000 (UTC)
X-FDA: 84413048790.12.34B2D43
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012005.outbound.protection.outlook.com [40.107.200.5])
	by imf15.hostedemail.com (Postfix) with ESMTP id 08749A0002
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:26:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="EZ4B/QnD";
	spf=pass (imf15.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.107.200.5 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770359212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VJTtTawA2Hmf4olaQXrPFzgodT38XQ6lbiOfeh8E2SQ=;
	b=gW0aiziXurouygouZVZ1+DLYjSZMXfoRk2b1TGiKsZ873O3wgL0f8k3HEKzb1/Hz53GJOr
	Loyg+7eSMcYdy8RSMcnCpGuqZxt0wL0VIvfieJmbW+INzF6VhLGKMAMMFQIvJwXgOhJopP
	t0+qU/jPVGFSi4eqysNSRil/L19Srhg=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="EZ4B/QnD";
	spf=pass (imf15.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.107.200.5 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770359212; a=rsa-sha256;
	cv=pass;
	b=M4spu+saPT2bnWeS+/raC51USTBJ1nRwO05ag+zyyeNq19bpcW9fUoSVlQ3dxO+USnQHAE
	3yZpiywulgR2A2hVhQMhwG+SGfFsMBtyknTzvuH41TFwdijNwnbswK1hER2cN5LdR4Sz3+
	hMyJZ6zmARXbNl9kywwYvmBv8goKgOc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IGD8826yedZP3G9U4dBJbsBRYp4IiwcJUMIpoNuEa9f3tYCGyvlmwwWSgv050KwcvZ16z+I4r9dj4Cnu6wbjgHBhhk5Wx87h1yMdyy3Rwv8KGPC88myXHtMp9djiXYfE5mSpkkxrdFldfniIoir9MrLRriycVtSALSZ0+dEUK3r5xeHYQKri3emZdX1UDZQHOzP0kIJL8yT6q1w6TDMxarLrTDJLcn+VirkRx3btO9rZk18hdvrlT5d0cJYWz4sn1SA68qV2H7jEBzkBnXdMCwDJkBsgPG8Z//Y0S4n8GMs/0WA/aXSLAZqbXbsYKZXkOeMY2dtOenjrOeY9HxmG8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VJTtTawA2Hmf4olaQXrPFzgodT38XQ6lbiOfeh8E2SQ=;
 b=FS29aNbAgI2QIWqSeAmAPu5j8XiH6GK2fI3iDeomUvSFep+SkHZUlHhHa4sRGtyWvpUh+leB0vnQUCag6XoADRa1EaqaGjdGjIK1cHL5eyiSERwrFJIXwYEHTR7oPbl8+IdJxuFih0B8iuVKIpAH451FuGPyXg1d4M1o6wn3QC8mbjCjOQGWLCvKuZTLHrpJr4CItVjk4zJky90KKs2YrcrGwnpI1Bg+eVlLfBO5JiVUIlqEg/TzEoP97blAVwXvybgyz9tdI3A7u0ppfl4AUg0FtNE2NOiRPjx2vktQUG07GTdSwD/Jb4+musnAdyTTotYX33wl+VkI2/f35HIHpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJTtTawA2Hmf4olaQXrPFzgodT38XQ6lbiOfeh8E2SQ=;
 b=EZ4B/QnDVZPRV5Y1OYBxRoymrGUa17oIY/WpAGL3xNqbyQmHznaDhd7k2iMbcwdef2voNgXD5QDMWoY5N3KmxGTREbCUJMQv3l8Qgq7YOQQeCUuWRPJ7+Bn/TCEj2T/bWgKVRJAvbaJbe7jlLiA6o+MCjTIPAhnZL5MzGpPPc2Y=
Received: from MN0PR03CA0003.namprd03.prod.outlook.com (2603:10b6:208:52f::8)
 by BL1PR12MB5708.namprd12.prod.outlook.com (2603:10b6:208:387::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Fri, 6 Feb
 2026 06:26:47 +0000
Received: from BL6PEPF0002256E.namprd02.prod.outlook.com
 (2603:10b6:208:52f:cafe::75) by MN0PR03CA0003.outlook.office365.com
 (2603:10b6:208:52f::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.15 via Frontend Transport; Fri,
 6 Feb 2026 06:26:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0002256E.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 06:26:47 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Feb
 2026 00:26:44 -0600
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <Xinhui.Pan@amd.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <akpm@linux-foundation.org>, <honghuan@amd.com>
Subject: [PATCH v3 8/8] drm/amdkfd: Wire up batch allocation in ioctl handler
Date: Fri, 6 Feb 2026 14:25:57 +0800
Message-ID: <20260206062557.3718801-9-honglei1.huang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260206062557.3718801-1-honglei1.huang@amd.com>
References: <20260206062557.3718801-1-honglei1.huang@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256E:EE_|BL1PR12MB5708:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d63158a-ba1e-48e1-d373-08de6548b4c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a7MVteIVpH26UczuMPT2fcAHfF+lTgSbRT+EK1lj7J4Qj4SZDYn2Dii2GDtl?=
 =?us-ascii?Q?OG6hn54R+ncm/LuRdP4W9bh0JKVMfnk5o8wyvi2bhv9OSEage9VeWALZl4AQ?=
 =?us-ascii?Q?V4jW+fDGiAkyfjKamU0UXE8kSaGWatMeedXfqZHe6gyYgnVdFzHaq9U/wIxY?=
 =?us-ascii?Q?vnx5tHo35CVBidEQB/x8ku2g0YSHx7Cu6Hv1mHPSlFbgx4vmPN7jYwCJP30o?=
 =?us-ascii?Q?JTCYAIYrBce5/kkyQT4SOkuLV2uOIr/KeNo8DbzraiX2Db1EhMQl0jAMqqdF?=
 =?us-ascii?Q?y2mdo/wKQDEu5IOBkz8mNWzreF0tQRjmZDP66zdg2ead5uIsmDLDcUTMbCOI?=
 =?us-ascii?Q?T2f2L2UIC7okrwaHAWImLlMitDoKxj7Ukxs0LmLv+M6rx8S1wB/8M6+WtnxZ?=
 =?us-ascii?Q?piLiFFC6E425XA5iEEN1Cn2FWq5kchehX2FJi+IRmI1gZpDD2FpPDprO89fA?=
 =?us-ascii?Q?ELrPjeHTCArEN/dgEymgTQ7J1hee4WmtydO5C17qh6+B21Hlxr+zGoMbLHkO?=
 =?us-ascii?Q?mT9FKjffbjSAkt0S0o35f01LgMaoDohrw+kpcuVbpnP2mFIDj2hwc54c/+oN?=
 =?us-ascii?Q?UrbRQvqfrAiUhUFANkDb1kjrSovFQtKTdNSEBh56NBrXoeqAfY5m2FS5+myp?=
 =?us-ascii?Q?hEkr8+Svf/bW+bnKjIuaGHtDZZae8cBZp7djknar6r7/aqpSEcT5+V31fw0l?=
 =?us-ascii?Q?VLZYH0OBvoA0r91VMl/tWs6HhbPpzuFiai2/YSV57FXfnpOlQFeS5/ttXD/F?=
 =?us-ascii?Q?HahKgjF+sDpP+/PVK2VIC5iB0OThpsXaJrJQHOweN5c0UD8aE6X3dIoL+PPq?=
 =?us-ascii?Q?g52an0xbfC1erIKLrou2jaiwZA3peuhMy8+dachsBbECmeQbcX+aXmJApAkj?=
 =?us-ascii?Q?Kr4jPeMLVSiM5Jz1RTHUWPEYDXUIn6PtmZthKnn+H9u9cBRhp9+HkVT98OfJ?=
 =?us-ascii?Q?8BKZZt4le4E3aVmPW4XhtDc6Yi97BNVzZ/M4hJDrkICA5mdcZwx6pQVxBc3T?=
 =?us-ascii?Q?0HPWkkX9bRVzQSNse1fspa5AIjUiq+vhWJrIo0soEkhMmZX+dm6rU05SQw1V?=
 =?us-ascii?Q?H2QHbhTEjOKiQH6jEvVemRHygoxvgMJSiml5WwNE+fx0F1nqds8zy+480csG?=
 =?us-ascii?Q?SejR7L55aXORJbRC47NcXfU57xdBvY8xwDWeerhfmIzukHjm2uTsOaUc+3Rm?=
 =?us-ascii?Q?xPVAnME9ITfabuL9XMCn45f1p3uNqVaCWpsA9E6dd5EsAPSazcHF6jvPfFtg?=
 =?us-ascii?Q?5P5IIWEG3bCHKbMLUgZ5uNYx/vrvVjKBw/jAl4Qsv0MGmx5Oqst3GUPANyXw?=
 =?us-ascii?Q?lcGcIugbb+sIqNkypLsPtr528QNIz9gZ74ViB4dpdwb0amCoTviCXQYburN2?=
 =?us-ascii?Q?IjLFi2RkzqDzuPABVlM9UZfA/5R+zq07uFONiNo8AN+LCfzdsCyhEcDsz+tZ?=
 =?us-ascii?Q?MAMp4M40grwFt80w7sfungu+oG1wEzruP7xEOC3OB9o/ulB3HgOqQwLppkRj?=
 =?us-ascii?Q?RAmFI1H2PV6Oh2P4HQwff1XDXJldVtHqdCq2gBAlbtT+iuRtm+N9AJL6gNGd?=
 =?us-ascii?Q?hMUb9mSjU7YwoKYQkThgzoXweeTBSP3AUkJVFF3b8aSfEkgLOeUe3G5ScvWw?=
 =?us-ascii?Q?6mtLh6i1bdKhBPRZZsdQqNLbiQHLAdmWiIRKS7XMwmsm5Ns6In4GwD1H7YzQ?=
 =?us-ascii?Q?Od0dCw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/wlwgGgIODKgPF93/DkBO5txWHpsHvcfgQwlKuC6G3Ts99cIHiPUWVL0MnVNCJlagJFdBPbVIVz347ZMwRdd0VuKD7ZhyrKhSvFOyDR81v6ZoxwmWyGAE+YGUDdXTPzoJdjhIJKKZX6rOKoFgNtcQq2fmY3ShmTlEGwJH2yw2c4H2Ttb1/OsIPsbXnBg+aS5JzW0eWl4eTepFN0rdmSLIkywwdDbQtDDlL4U/6sWfsRLytgq4eyvphBnBlnmyrvOOcypeMc9at6aZGEdKfiTjdNYaLLleeeuBnBWP06nJo1L00FCVFgXfqqmhlXLXnNLt9F4KT15M1BzhC63ecbI1bJOWvG+s/ZMYDCYd/63cLTFpeeZu49GcmahahuIcAGgPRKpQDK76POvXKjzrDVas2diUcIKs01hjRDsIwKN7MtelFz+a0KCJHOFU+E5qhLk
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 06:26:47.7797
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d63158a-ba1e-48e1-d373-08de6548b4c7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5708
X-Stat-Signature: af5ic8sjn1zarkzhi9ayw5pd4hzf4736
X-Rspamd-Queue-Id: 08749A0002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770359211-50969
X-HE-Meta: U2FsdGVkX19lnHKrO3i0C4bbf5H5lH3WBzxwDXT3qXl6wgZ6ZIWyhESpnkYuOwZrhgCj1259E5u7rVG/3HV/T6CnDlZqNPT0g9+ZwHiLjDaMh0TOR16upGG8YyRmF+geCXp+Je8hUCd9HhRRo9kQ3Hpxbym6L+0SINNMIeBx/YE6ezT5gHZ0L0kqYECmNSTiN/uc/boJTthRkOQi/qiehf59W0Xz3tlloMEwnqf7PH2UqbABQJH3zrxtiIXlMBXRW27wEzCwBEiMUAw1BSahp0gRAa3OtZDoulHloD3LWQFUBCG7BFvZ3OvMmGI6IFtDIEKIYHNVz6i/bYBV9AvtkY/0FwYJ3zW5LWfR+pi8ayHbJNJEQhcGdAwEMb6jiIdBIl/6bZevvaV+iSWQGF94kcEC/Jg5LREq+B7OUbopwJU/DBQyjUJ69nOssdFX5nuOAkqlBrkaMKmwN5FVEz+WHTc22OD3kuIc4N/DgGPqf0XX63EM5sUavJP4VvG//8LxJe3V4xGSGduEx1qZ5ZBfVQsb0fsusEoRgaU5En4V5Xkssksrz8iXrEUe9Th6ZVdScKYRBSvQY8DyicrNBDzoch32+9Xyi22k5zhqoyZMinAMoNNUen77k8oh9Msa4QksTEdGlpWVohZc4JAJmoaWmy1/AvFM30RZhMw/ujDhIR1P2osZL8ID+DTAgViu/eUyMr1Zq70BG7HchWB+ASkBfZAeyr/T6ILeuAs2XFjRux4ISI+JUs5I4WpGxQaiF/wwyoOpQEMUCWo4sJ3+Bm6W9pgoqQPaOzBsQFgrvVETs3nqSCWXPNyinxdxBTQJReFV78gLdydGdW2svgKU0bcMz1aN9LIegaZc6xlkjDLVCfF0PUlY/xi+vHakHZpsbMR1YL6/346KgX4UlzuRXOcWcAyRgoGzCHIBZFZC++pYsNyuNY6ig2gm6C2mPgfvyufC56ka0xB7GTUK31EdSRL
 CnTKmGB9
 JAgVODvo0wFuBagkq2xeusXTI6i1Nc2yTgoS3LbMYgp8bujLnnMRPHy+oIRxqExWu1IxPqmydJ4nGpHkY1QAzrTObBSpfGlW9FPmx3Tse84C9r/lJ21GEg8pIqOqtFdK2cHnWMU8efX6B4X9yE4lAEEzytlusgy5eUBiOnSH3ZHfPXIWydzHR2M9I9Z5OHjRmtXzKPHU5vSfa/VqNpxnkgJp7e0cFyBT2st8fPyEPivu1KNACV8uwOCvU3iscVH4nfep+sU5CJIvyW9GGBsSeVWQcf5vGz6QknnySYcdqnyKp8QgeCCig7dXffumzxc4DoD82G6BJQUlFZIhIqLkkVQ2NV7SrT09zdSw281Od4xFsSBM5zwgOrOW5ruDWwBl3aBXviKPIvE5nOJuoBWUK4b41/BoHqBezGxi9nkTj+r0S5kmntOckMtJvls0ghFtiIO/h9cz6ll33Jj0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Honglei Huang <honghuan@amd.com>

Integrate batch userptr allocation into the KFD ioctl interface.

This adds:
- kfd_copy_userptr_ranges(): validates and copies batch range data
  from userspace, checking alignment, sizes, and total size match
- Modifications to kfd_ioctl_alloc_memory_of_gpu() to detect batch
  mode and route to appropriate allocation function
- SVM conflict checking extended for batch ranges

Signed-off-by: Honglei Huang <honghuan@amd.com>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 128 +++++++++++++++++++++--
 1 file changed, 122 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index a72cc980a..d0b56d5cc 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1047,10 +1047,79 @@ static int kfd_ioctl_get_available_memory(struct file *filep,
 	return 0;
 }
 
+static int kfd_copy_userptr_ranges(void __user *user_data, uint64_t expected_size,
+				   struct kfd_ioctl_userptr_range **ranges_out,
+				   uint32_t *num_ranges_out)
+{
+	struct kfd_ioctl_userptr_ranges_data ranges_header;
+	struct kfd_ioctl_userptr_range *ranges;
+	uint64_t total_size = 0;
+	uint32_t num_ranges;
+	size_t header_size;
+	uint32_t i;
+
+	if (!user_data) {
+		pr_err("Batch allocation: ranges pointer is NULL\n");
+		return -EINVAL;
+	}
+
+	header_size = offsetof(struct kfd_ioctl_userptr_ranges_data, ranges);
+	if (copy_from_user(&ranges_header, user_data, header_size)) {
+		pr_err("Failed to copy ranges data header from user space\n");
+		return -EFAULT;
+	}
+
+	num_ranges = ranges_header.num_ranges;
+	if (num_ranges == 0) {
+		pr_err("Batch allocation: invalid number of ranges %u\n", num_ranges);
+		return -EINVAL;
+	}
+
+	if (ranges_header.reserved != 0) {
+		pr_err("Batch allocation: reserved field must be 0\n");
+		return -EINVAL;
+	}
+
+	ranges = kvmalloc_array(num_ranges, sizeof(*ranges), GFP_KERNEL);
+	if (!ranges)
+		return -ENOMEM;
+
+	if (copy_from_user(ranges, user_data + header_size,
+			   num_ranges * sizeof(*ranges))) {
+		pr_err("Failed to copy ranges from user space\n");
+		kvfree(ranges);
+		return -EFAULT;
+	}
+
+	for (i = 0; i < num_ranges; i++) {
+		if (!ranges[i].start || !ranges[i].size ||
+		    (ranges[i].start & ~PAGE_MASK) ||
+		    (ranges[i].size & ~PAGE_MASK)) {
+			pr_err("Invalid range %u: start=0x%llx size=0x%llx\n",
+			       i, ranges[i].start, ranges[i].size);
+			kvfree(ranges);
+			return -EINVAL;
+		}
+		total_size += ranges[i].size;
+	}
+
+	if (total_size != expected_size) {
+		pr_err("Size mismatch: provided %llu != calculated %llu\n",
+		       expected_size, total_size);
+		kvfree(ranges);
+		return -EINVAL;
+	}
+
+	*ranges_out = ranges;
+	*num_ranges_out = num_ranges;
+	return 0;
+}
+
 static int kfd_ioctl_alloc_memory_of_gpu(struct file *filep,
 					struct kfd_process *p, void *data)
 {
 	struct kfd_ioctl_alloc_memory_of_gpu_args *args = data;
+	struct kfd_ioctl_userptr_range *ranges = NULL;
 	struct kfd_process_device *pdd;
 	void *mem;
 	struct kfd_node *dev;
@@ -1058,16 +1127,32 @@ static int kfd_ioctl_alloc_memory_of_gpu(struct file *filep,
 	long err;
 	uint64_t offset = args->mmap_offset;
 	uint32_t flags = args->flags;
+	uint32_t num_ranges = 0;
+	bool is_batch = false;
 
 	if (args->size == 0)
 		return -EINVAL;
 
+	if ((flags & KFD_IOC_ALLOC_MEM_FLAGS_USERPTR) &&
+	    (flags & KFD_IOC_ALLOC_MEM_FLAGS_USERPTR_BATCH)) {
+		is_batch = true;
+	}
+
 	if (p->context_id != KFD_CONTEXT_ID_PRIMARY && (flags & KFD_IOC_ALLOC_MEM_FLAGS_USERPTR)) {
 		pr_debug("USERPTR is not supported on non-primary kfd_process\n");
 
 		return -EOPNOTSUPP;
 	}
 
+	if (is_batch) {
+		err = kfd_copy_userptr_ranges((void __user *)args->mmap_offset,
+					      args->size, &ranges, &num_ranges);
+		if (err)
+			return err;
+
+		offset = 0;
+	}
+
 #if IS_ENABLED(CONFIG_HSA_AMD_SVM)
 	/* Flush pending deferred work to avoid racing with deferred actions
 	 * from previous memory map changes (e.g. munmap).
@@ -1086,13 +1171,15 @@ static int kfd_ioctl_alloc_memory_of_gpu(struct file *filep,
 		pr_err("Address: 0x%llx already allocated by SVM\n",
 			args->va_addr);
 		mutex_unlock(&p->svms.lock);
-		return -EADDRINUSE;
+		err = -EADDRINUSE;
+		goto err_free_ranges;
 	}
 
 	/* When register user buffer check if it has been registered by svm by
 	 * buffer cpu virtual address.
+	 * For batch mode, check each range individually below.
 	 */
-	if ((flags & KFD_IOC_ALLOC_MEM_FLAGS_USERPTR) &&
+	if ((flags & KFD_IOC_ALLOC_MEM_FLAGS_USERPTR) && !is_batch &&
 	    interval_tree_iter_first(&p->svms.objects,
 				     args->mmap_offset >> PAGE_SHIFT,
 				     (args->mmap_offset  + args->size - 1) >> PAGE_SHIFT)) {
@@ -1102,6 +1189,22 @@ static int kfd_ioctl_alloc_memory_of_gpu(struct file *filep,
 		return -EADDRINUSE;
 	}
 
+	/* Check each userptr range for SVM conflicts in batch mode */
+	if (is_batch) {
+		uint32_t i;
+		for (i = 0; i < num_ranges; i++) {
+			if (interval_tree_iter_first(&p->svms.objects,
+						     ranges[i].start >> PAGE_SHIFT,
+						     (ranges[i].start + ranges[i].size - 1) >> PAGE_SHIFT)) {
+				pr_err("Userptr range %u (0x%llx) already allocated by SVM\n",
+				       i, ranges[i].start);
+				mutex_unlock(&p->svms.lock);
+				err = -EADDRINUSE;
+				goto err_free_ranges;
+			}
+		}
+	}
+
 	mutex_unlock(&p->svms.lock);
 #endif
 	mutex_lock(&p->mutex);
@@ -1149,10 +1252,17 @@ static int kfd_ioctl_alloc_memory_of_gpu(struct file *filep,
 		}
 	}
 
-	err = amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
-		dev->adev, args->va_addr, args->size,
-		pdd->drm_priv, (struct kgd_mem **) &mem, &offset,
-		flags, false);
+	if (is_batch) {
+		err = amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu_batch(
+			dev->adev, args->va_addr, args->size, pdd->drm_priv,
+			(struct kgd_mem **)&mem, &offset, ranges, num_ranges,
+			flags, false);
+	} else {
+		err = amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
+			dev->adev, args->va_addr, args->size,
+			pdd->drm_priv, (struct kgd_mem **) &mem, &offset,
+			flags, false);
+	}
 
 	if (err)
 		goto err_unlock;
@@ -1184,6 +1294,9 @@ static int kfd_ioctl_alloc_memory_of_gpu(struct file *filep,
 		args->mmap_offset = KFD_MMAP_TYPE_MMIO
 					| KFD_MMAP_GPU_ID(args->gpu_id);
 
+	if (is_batch)
+		kvfree(ranges);
+
 	return 0;
 
 err_free:
@@ -1193,6 +1306,9 @@ static int kfd_ioctl_alloc_memory_of_gpu(struct file *filep,
 err_pdd:
 err_large_bar:
 	mutex_unlock(&p->mutex);
+err_free_ranges:
+	if (ranges)
+		kvfree(ranges);
 	return err;
 }
 
-- 
2.34.1


