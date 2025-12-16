Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98311D5E131
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 11:12:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E78D76B0005; Tue, 16 Dec 2025 06:12:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E22D76B0089; Tue, 16 Dec 2025 06:12:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25626B008A; Tue, 16 Dec 2025 06:12:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C15B16B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:12:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7298A135DFC
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:12:20 +0000 (UTC)
X-FDA: 84225070440.23.6AF4982
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010033.outbound.protection.outlook.com [52.101.193.33])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9017D4000A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:12:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Gobuy8df;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.33 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765883537; a=rsa-sha256;
	cv=pass;
	b=eISARuLngL7r6SKU9p1GHmSNsvpeI0Qu9s4xuHO2Je3IYw0bKZCJPF1Zf7dUiZVYOU9C6X
	nY8TyPzsMwjTWYhtC+5DJINO4Ov0s41ENgAQAVjBRBP1wudlH5i1q1PanwJhCVx9wKfB5+
	l5bY1Sa3ZJdSWkx+UkJkbTziQyAD/mo=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Gobuy8df;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.33 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765883537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QN6RuV8V+W4sF+c097o3V/jF1N50nb1n6Fo/bIeDCvI=;
	b=Cfw52XAld+haeUuv2dwFOW7QUmC0CqrgZTS8vrytC81t0IzcSOTmC04cMKoQHfkOqHEVGs
	4b4fdwiY7APvcM+IRQg9D63vtusQmgnQxXc+TAI/I8jF/W1HJb51gatgZM4eUYe1v87UOI
	sxDJJX3AFQiBxESxcHLbfFzG72P5FPQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wp7t9/tXdF7EMlgm1ycxHiriy/FCN62wpXU14EfiRpr+jmGNe0uGVPb7ZiZdfIrhO8CFPNjlN4e44NsyZ0krXNFrVJGvrkakiShBEkbFH9cKApn4LRaXcN9hAeEwZomjeCvteSs9NZ0tx9KO2fW9CLNmOcV5XbxRzrKOsE9eEt3HFTqRuNdYvvaIxSW0cOH9VUezgVR7pSypELHQdpFTziKYL0AFfiZnqR9NjD0t46P1QTaMy8oOiqWmy8m2PdHucVQt1P4LlWVPF6afbr0WEIAI7mkdaoOe0v7rB/vXHobyIsPtfFhvAhalZBA1TN/NN2uX660hRGJ6IK0jkUU9tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QN6RuV8V+W4sF+c097o3V/jF1N50nb1n6Fo/bIeDCvI=;
 b=jqQKbtmJaVzYKmJYETllgXfZIiuGrNe3fivz+1xS+Ks89rIs9d7/C2mIhr46nGMcYJorPwnuueouysrwBnx4UWOCA8sU8tCp1fy0W/aW51vA/kp/Fnr5C/tusipeP8jMJidmq2oUddZTvNJpIV62Omvrw0kvENMH5ZdOnh55jT/VwbWTOKtkJjZy9rUTbl7But9kwBIDfDCB9ue/WGSZrPWXTpaHkz7U1TP8Phw7MCkhbzqbLHq47KPR5VS+J62JEbL55YQOfRPbRp518wEHm430ZrEfTTGKWgljQ5H6BPXyreW7n17b8LSCr/GOXZcxoFLoEKi43FFhjfJt+oNxwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QN6RuV8V+W4sF+c097o3V/jF1N50nb1n6Fo/bIeDCvI=;
 b=Gobuy8df1NiQ75BsrzVijg2ukZG90ZC9eYochA0foI1ZgIEFGp9zzm8Ez5gq34GXJW7v1H4TCUdi4rt98GY5Y0ht0hB7sRtUWbUtOFzHTU4IW0LhixAB7H0Dwiw+n9ZSB2xqHPWx4cLxpObTKla0BOExBBrYvlpaLL1qPJ8L6yk=
Received: from BYAPR01CA0043.prod.exchangelabs.com (2603:10b6:a03:94::20) by
 DS0PR12MB6533.namprd12.prod.outlook.com (2603:10b6:8:c2::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.13; Tue, 16 Dec 2025 11:12:09 +0000
Received: from SJ1PEPF00002312.namprd03.prod.outlook.com
 (2603:10b6:a03:94:cafe::b7) by BYAPR01CA0043.outlook.office365.com
 (2603:10b6:a03:94::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Tue,
 16 Dec 2025 11:12:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002312.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Tue, 16 Dec 2025 11:12:09 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 16 Dec
 2025 05:12:05 -0600
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<shivankg@amd.com>
Subject: [PATCH 0/3] mm/khugepaged: minor cleanups
Date: Tue, 16 Dec 2025 11:11:36 +0000
Message-ID: <20251216111139.95438-2-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002312:EE_|DS0PR12MB6533:EE_
X-MS-Office365-Filtering-Correlation-Id: c224c89f-7943-498c-75b8-08de3c93f4ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1MfoURxQEDZjKzCi1AEiXzZE7oaSdsUl7MDTJAJTfJI9wZgbwV6tXd6L730c?=
 =?us-ascii?Q?ea04YeeLVxa0Q23diIeWvDQA7JXyCV0QDFyQSuOwjxReEoir+ML7G00LBd4e?=
 =?us-ascii?Q?K6+JI3wARQCJzPcz7uPuGQK8suec0OD+t7kuo+bCoTWGyNHLntiJxlfHB5Op?=
 =?us-ascii?Q?plbDY/Ywks18ejaFk/IkU2IqDRQ/9ST13CMRmNFkNBff1Fl0BQe3ox+KtMZX?=
 =?us-ascii?Q?KqHGZDpK3yl2vV8JMUNHa8Gp1gG+6KnEjpSwAP4pQ4WsQXfW1Yjkcyb1ZqcK?=
 =?us-ascii?Q?1A3aRu7tWNr1ov4hTdJuXa+sc7RC3rhCx7vo1DeoUgBi41bacpORN+2NlW3e?=
 =?us-ascii?Q?rRqVxUWvorYAZ05oYhUSCiVrP/RUj+3CZdG6elgkIRe+OTRyQMHqx1Iz1QQ+?=
 =?us-ascii?Q?65IGbWHMbu20sOC7KrCmWYcq3YgPjg7vDlPTL95FHns/NrmVABbemmCdVfnD?=
 =?us-ascii?Q?FPYGoTU0esrdLCHKPmOLuTZZIbpu3ca2kY37V9dpcUU2/1rIMmubYHnkjWoZ?=
 =?us-ascii?Q?w8ZVI9lGHxKgpbogdsGy6PHLLWHXvo89Z6jQa8rg7Wk3uPKo9WTkATljtUYf?=
 =?us-ascii?Q?dWXybUhI5pFQgzyt1V23680ULJPSsbOjylk/13b7uqvz0khITEVSFzaZ2oiB?=
 =?us-ascii?Q?l+Knw80cdQoC5KF416lNKVQVWbTVNrlLNl/SispF+HncSt7CJNYl5gogQAeN?=
 =?us-ascii?Q?64Gn8epbJ/3p0SVORYh0oWiCzpMmflqBOCe9KNgXA0DyILNXFFhnIftg4Ttq?=
 =?us-ascii?Q?PxqzGPssgrpMaNA3CCpMSU4Nc+V3dLMDEZ+D7DiJpJi5fWSnPn+ggIrCIBOa?=
 =?us-ascii?Q?SlSg2nf6D/oJr76aZ793+e+QYbdZ4GcD7FxvxK5xVj6Woi08ojZ/cGcgqozm?=
 =?us-ascii?Q?aBECr/Z8OGKmtjU9FSaDG7U0KJKaQ5M/N7EVRqEhNFSAW/E5Dw7Q0ZFTeCl6?=
 =?us-ascii?Q?H/Q4pF3+TJVWc+n6OJBYZG6ftalF2NpGPGNmB+A8SWQTLOrVaJgcL1By0aWP?=
 =?us-ascii?Q?tQvIpRvX200Nr7L3y0ztNR43rRKqGeTFnRH2UF2VO+FMhlerqWwGZ89UDdLS?=
 =?us-ascii?Q?IM5IloQkl3LmaXbSeTY6NaHKe8WZAITHQDakGGN8pvwKZ8tt0LrdeYZiS+cw?=
 =?us-ascii?Q?MDUGeKP4ngaKHknS0/IUoTKuv/BJERjgf8Zq6UruExdnuUNU2P+nDhlOHvi1?=
 =?us-ascii?Q?wZ8yeaEjyIM6nvAZeTgyW8jCaq/jNNN/tPaua+yT9iEqJUa526NXBOTMNKW/?=
 =?us-ascii?Q?tbrfq7/L5+yW7wpPprGknaAWKIJ6RCOcHkPlUq2vqB5EPwrkxNWakU9geuPF?=
 =?us-ascii?Q?ev0fCE7yS4IdhbcWZPg+ZSlk84UlnEem1cyeF7YQazjhbP6fdRKc4D3bxptC?=
 =?us-ascii?Q?tOEn+26E/KVee0OggifN9TZCEyV6WEt2v2PEOOHVdt9KXtrrl8qpu3g5ijqQ?=
 =?us-ascii?Q?FOXhs6c0Fhu/+IrFaoekkxdpC2EQJnM3bLySHukZ+uh2yCDYFHlgCE06qrVG?=
 =?us-ascii?Q?4sXB49HyRV2f/six5zfBGLjSLom8qfInGeQqjd+TvcDmhaSh5DEbGr2Tz4ZL?=
 =?us-ascii?Q?EGiqrSvMcYu0krXH32A=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 11:12:09.4828
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c224c89f-7943-498c-75b8-08de3c93f4ac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002312.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6533
X-Rspamd-Queue-Id: 9017D4000A
X-Stat-Signature: hyzk8wtxoa77ywcepfhdrupptpecsdxn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765883537-759661
X-HE-Meta: U2FsdGVkX1/gmI6siU6yG1CvA03kfEVs3ghzh5NjcDn0YParMZpPcZ4MENB4WWJcL6nN94D19D6yG6COmKvWhHUExaYxIbOSKecyNRFhYic6iHtss+8XDHntMUWK18rqWMKBN/b1z4VCu2dh4dpCMEhjylkZamTdI2vDa0kZYxZ+KzsuHbc0fj+pYgfVZ7U/6ZVtEJHEDLySOCnSS7LsnglFARGPj9iDkpg43FQ3r/Y1FXzfCp3o5JnDy2a4gA9olUEEIoYhTbRxMbU/hWYLo1pgIWRD4rmRmmPI0ymr/3bVnk9MlOyCNpNwMznUffCO55UQtF2ntuDrlPWOn+50ctz3JfsjR9Vt5xs5VA0U6FfwyXCSrZ+LShAayGg6r2s0vqD8XZiHAXKdtAg3SpCzt5KhySIvkXlGR8d2PgHLiY8Emn+jqzrZLPcN7RYHU1l1/nGJULFCyOJmuSpWm9tS3mRW6DGXVyioxNq3rvQlid6n3+tMGfAg2WslKu47FFumXCouBaDyrijcKPDEjrPPs2uSthx3DMiAkUY2vBefYiorQYqDHGt7ooC4D0Wy7WTJkRMWJUk3y7DsSIGNV5o6n7p0z1I1Rnc6zRr2fr+egKtv6JV9zX+Ju5lJ4KCYNl5jQ2SpgQGIubkcWhY+1MGz3keH0+PW5JEaL7AvdJMkvuiNZVr1w1oFDTwwwa7fibadVqV5M4Ba6Kwclu85mKsem+adp1xMdDoUR9P9AWjndna7+IZfEFE72r2ZpZ1UKLZrOcBhaQ6sSaxOy7paiHzcGZm7MZgd+s1fqC0sIlXgZGQg5Cizq52AfNMxSc6O9MtR7V2SdxflFvNUL7Sno3mvmvNebZtdrDXvZVMZ2bZyQa12l/4z7dDk+82wJmVzfyIkF02KQ5VwK6QWAiimfA08Pbw5SKZ+/pDt4TJAeGINultQ8mZeSLp5wX0qr60vVtootO58osjlpYpKPU2hKgT
 aXRusdRS
 7Toeanrvf+aAN/3e6OVWttIboOVRk6JWfMrXxpfi+mwD2th1/nmSKOwi7Lr+2WYaWN1RbTFeR1IXjV6Xq1ECwBLniM34To93AwT+bHbGQxHNCPzTTrI/iP8UDfiMK0JQRnouXuYReMzfzX6VvvwGZHkH1IQpBnICSxrNk9ClSE7VOe7/DG3x7FWlG5L2JEOD5NaJk/TAGMtkOpNmrXyMJa4zZ/fuJSuN5R3+Srcz4vc7fIw4VzvUxzD7wjLEPS50B9w4EXmqMannabps+LGeguzsMg69hJJdZVQdNh2SFSmMYeRYOInqiCVDmijW6YgW2HRDL6489oqDexzhfxj3FPLgIjtpzYz7zG7IkApjuFKDTDhflpGSAJpgSNpVgvbD9nTJtuW6LIFdsQx3xmjfwMzy5Mvb44XfeVbUF+MNRnWIeCMMk7C9OAUk4t7u2luI7ctWSr6rdiAcefmeSg3382yFXWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This small series contains minor cleanups in mm/khugepaged and
no functional changes are intended.

Thanks,

Shivank Garg (3):
  mm/khugepaged: remove unnecessary goto 'skip' label
  mm/khugepaged: use enum scan_result for result variables
  mm/khugepaged: make khugepaged_collapse_control static

 mm/khugepaged.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)


base-commit: c642ecda5b136882e518d8303863473c0d21ab2f
-- 
2.43.0


