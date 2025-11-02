Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FA1DCCFA02
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 18:44:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E78678E0003; Sun,  2 Nov 2025 13:44:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E29B48E0002; Sun,  2 Nov 2025 13:44:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF10E8E0003; Sun,  2 Nov 2025 13:44:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BBA798E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 13:44:57 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A69F1606B7
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 18:44:57 +0000 (UTC)
X-FDA: 84066543834.25.A1AB112
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010052.outbound.protection.outlook.com [52.101.85.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id 732A0C0008
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 18:44:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mTShJ5oM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ankita@nvidia.com designates 52.101.85.52 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762109094; a=rsa-sha256;
	cv=pass;
	b=IOoA9m7CMGvh1GQAyq9YWxv9mUHflKodLpi9iNpk63Ol7KHVd1LR3nI+vBlR/bWt4XvG5v
	KYtd1QbOPiJNmUWa3/IwRygw0rq5K0FCG4t1zR4FWlSUdp2CNBKRXnIL9LhihF3hRgTOS/
	lsuhWyTfHNXLQ5fHZI8Xncqgn92+Uvg=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mTShJ5oM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ankita@nvidia.com designates 52.101.85.52 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762109094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KNIVFlRtuevk6wMRAs3kl7QZj2pt5+QR4uhVt4OoXqQ=;
	b=FQXfdusIkF0LnU4Qdml9+A+d5uPgUVLi7sNS/IHS5hQ2YSC2ESWGTMRgQlpwce03rRhOVJ
	boe1thJl+RVq8MjohntfhtMcibM++z2zwjH2ebH+Mxa26/4AGeQzFC3nFEJ1/fwbDOx3eZ
	Ro0kQf4gq8D0E9aZfLGWBp0s69rbkNc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P0L9zc9SvwqfN2KJt+E4wiX3DONDIj4qeTajD+LkYG2SDTZdidz5f81T4gDTSbaUSPwULqErlAC+NXdGnWevQnGACnzpJhqZljfoS+jVyy1BTpWzOAK5O//89KUI7KL98kj+DoSCYDxsrAd+yrY0/GIH8FGISozPMdXNJKRQlgkgvyu2A2AjDgSP6rVfnqSojdFA+Kdy/fIz1hW7gqjnLjNKAG15CBRh1+IRWmZR1VwD5yCMftwSonHkWbKTl+mysIGsxVvt6oxPwo8WV8ayFW4tHEjKXApS+KGnORBNPtEV3u5IjpePlAEozLRJ8piPZ13h36ZSzZzFO/YRUAK4sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KNIVFlRtuevk6wMRAs3kl7QZj2pt5+QR4uhVt4OoXqQ=;
 b=XD+8Y9QNObCMWeu4WhQX1iYmq3V8eGGsar68ezytNRWOO1/o7GsZc8LxUUiYQ68uWxQoT8b4NTzwV6WDghBnEJANybMl6bQCYmK1a+qroRK2/xX6Q7vsyLJr5nKp52xXa6iUSRlGVUfDi2AC62BPmqwBHmJpsERm+57GF9gh+bEfL7rQbxC361roGukYdS45VHXqd9ciLh6cp/tmvycfwBOLQkxkdciyz++NOTdFk6eY77kG5tkpyO2Dicam6/9rD8xyVvvGlSuGogmYpU6Rda6HchEjUQ+JD0uFAIBf/NgMEgqaZudyI3EmEVxNPv+x7uEyyiISq06QPRpAauFdTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNIVFlRtuevk6wMRAs3kl7QZj2pt5+QR4uhVt4OoXqQ=;
 b=mTShJ5oMHe76l9g5/kU4NYAtZo1j8ZSWsgH3d0cZlxEUNDdgdWFyyrOTu+DpVVGpl6URA9exCqQZP8EYLsFKDoKBM/hmCSGs87BVVc9571jbVlEJqG1I5nq0g97T9a9ItnrxbSXcuv3iAEO3quFGS6wN2unN9cYBMZY2bcHuwyoqHIs0D7S6B6GGSGJnbMZ04+IrB6c7LO9cUIja8shHlt7rpQmSJuZAqC8lWY+RCstBVBcSZLG+xc7YnJxaCwcjnUG+/MMVJf3xQPlqn2llALo6hmxu885JhanF7a5YDk9Kn1sDsgltEt8j54NfwklLHXv4NkoklKzokQWhJpz1Dw==
Received: from CH0PR03CA0050.namprd03.prod.outlook.com (2603:10b6:610:b3::25)
 by CH2PR12MB4247.namprd12.prod.outlook.com (2603:10b6:610:7c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Sun, 2 Nov
 2025 18:44:47 +0000
Received: from CH1PEPF0000AD82.namprd04.prod.outlook.com
 (2603:10b6:610:b3:cafe::ce) by CH0PR03CA0050.outlook.office365.com
 (2603:10b6:610:b3::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.16 via Frontend Transport; Sun,
 2 Nov 2025 18:44:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD82.mail.protection.outlook.com (10.167.244.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.6 via Frontend Transport; Sun, 2 Nov 2025 18:44:47 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 2 Nov
 2025 10:44:39 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 2 Nov
 2025 10:44:38 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Sun, 2 Nov 2025 10:44:38 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <aniketa@nvidia.com>, <vsethi@nvidia.com>,
	<jgg@nvidia.com>, <mochs@nvidia.com>, <skolothumtho@nvidia.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<tony.luck@intel.com>, <bp@alien8.de>, <rafael@kernel.org>,
	<guohanjun@huawei.com>, <mchehab@kernel.org>, <lenb@kernel.org>,
	<kevin.tian@intel.com>, <alex@shazbot.org>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <dnigam@nvidia.com>, <kjaju@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-edac@vger.kernel.org>, <Jonathan.Cameron@huawei.com>,
	<ira.weiny@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>,
	<u.kleine-koenig@baylibre.com>, <peterz@infradead.org>,
	<linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>, Shuai Xue
	<xueshuai@linux.alibaba.com>
Subject: [PATCH v5 1/3] mm: Change ghes code to allow poison of non-struct pfn
Date: Sun, 2 Nov 2025 18:44:32 +0000
Message-ID: <20251102184434.2406-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251102184434.2406-1-ankita@nvidia.com>
References: <20251102184434.2406-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD82:EE_|CH2PR12MB4247:EE_
X-MS-Office365-Filtering-Correlation-Id: 333c9e97-a8c5-48dd-f1af-08de1a3fe60c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U1FoCGEBJseNO04u1ocjhmz3ke/jxtZ4cjTYiprII8hdX2I1L2jrm+8cwIeZ?=
 =?us-ascii?Q?/iRuc/5ZShfyMOTfFvdI8Z4jAa8bfLuRLATZSIO9a9iRy/W97Emn+EAOJRQC?=
 =?us-ascii?Q?1PXwaqzzK8YKb80aZWYI+4i60D0obV+xSwS6QpHB3QFyi1rm9axcV5Y4KKTY?=
 =?us-ascii?Q?iRPoK6yL6bTgdSySPhAj/mwDZOpEqCqEuqmhEhhtVp7R1uxkdI8kRbMHRCsn?=
 =?us-ascii?Q?mCREF6UmBZKZwpigDQyct3yyIwUGWMBi5L+by7qc4uhWdGHjrMqEodkjNE57?=
 =?us-ascii?Q?in3CHqrGhUpAQZ+tzAUR5XzRyWStUz8gJLiDFolLfgzs+SLDgSkvtfrPhxK5?=
 =?us-ascii?Q?21zAi9E0dvWZJHZaVx75a7t5COZSS0c1o0b45J9TAjdjhsvuO9PTVjLJvHKV?=
 =?us-ascii?Q?HciYUfEsO9cRAYFgH8xJF2B6EYBHPQRzC0+JP92trAPe/u+2i+ao7yDErn0o?=
 =?us-ascii?Q?rLBUFeonAEtlHKanAdgwZHIrVnqAJRhrgHTMxDyiE3fsHuTROGTBoFfnEbUL?=
 =?us-ascii?Q?g48q/R4LCN+bl3LUpI2ZbhLARYnlj5G/pf1mYqtpitN5hJoSq08UEXQY6QNG?=
 =?us-ascii?Q?AL4h7TbO50A7YfwkAiXfh0OBrXChxETHH1wSbYNYCX+0o1MFdDefzDQVgWyj?=
 =?us-ascii?Q?iOgBl6QY82VawQ7ThAL9/BAAHieqJPIZXMIMMGjoZ7rVj1eXvKrEnRWRi7lF?=
 =?us-ascii?Q?rRTor9zb7xWdGCzNUBjGfvX1nKBj0vOIuyP/Np2a7ZyYCLnrgTqPciwg570V?=
 =?us-ascii?Q?hrlGgcrWYxXD614c/y+vgH17xEd+/fFi89aCssBsSM0q7vfeNpcSiM7oNzao?=
 =?us-ascii?Q?hBda/HuMO1dRlRtyxBGXWfdwjGyO1Mt19EeQMoHx57iAJ4+lVasivsvcaOi9?=
 =?us-ascii?Q?tJWdWHYMsc3H5WAZ8dVmJxhjO8diNMMLVTZT7u8VPq8S0IGuX+AStjewu01i?=
 =?us-ascii?Q?XYHhQI9zc/gbVCfY90i/y7BhcG1SpVTQnxBo4CrtyzDZ4+ddiPGZTYYef+m3?=
 =?us-ascii?Q?bYZMUzTL5HVEKMvwwGJhFkugIDktxDshGCIAuRXanLfsBaJcWkYsiF3lYZqa?=
 =?us-ascii?Q?hXxtGZW3JFZBuQpSwGdCOozxWbj9rKBtuZ5roTFB/QFyvG2PBsXoou+YjuPW?=
 =?us-ascii?Q?zf96elVPE8twCYxxUjnHlCJdc1V9xIfPInC11qN4FKEjC5kpq2JjueXk2YSH?=
 =?us-ascii?Q?YWPvWsaP5xii2dVsejFnd0DY808sQDiUwMKCWYiFlIk2GyypaFYx6blRYM8m?=
 =?us-ascii?Q?8E0KFNxh39egjUgPIF1fb/qQdKGyRqTUvRnpPrtF6pB2VFRJRizha6rELiRm?=
 =?us-ascii?Q?628i2y3AxlX1AAZSExbM23T8m0X4k28gGVAKNH1fAfzGuoCU4yUOOJJFzBVb?=
 =?us-ascii?Q?XS21skx6rTRsXr/DS1nd4VE6GzaNeyf0WocBoZJ+yK0FnHbMnrk++xSRwt5L?=
 =?us-ascii?Q?GfSESfUGMsrAZMAUGy+rKeZ8BVGWrN+qleYJ2gqQ2b9T/WCRK6I98w3KV9rQ?=
 =?us-ascii?Q?8xgAmp5x0sYvMg31DLqsMJUAXQJISffShV2lLgaLTascssE0A9Kz1xTUcDhl?=
 =?us-ascii?Q?McUa8f/77TWXLJP/1x+mSmmjuERIo0VZ267XxdyX?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2025 18:44:47.6686
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 333c9e97-a8c5-48dd-f1af-08de1a3fe60c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD82.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4247
X-Rspam-User: 
X-Stat-Signature: ufsp54wea79yxyxd463rauggm6p95sb8
X-Rspamd-Queue-Id: 732A0C0008
X-Rspamd-Server: rspam09
X-HE-Tag: 1762109094-796778
X-HE-Meta: U2FsdGVkX19M40NoKhLFTIWyi9uoEdQdupd8AS9o4fY4NOUyosJ1FcBc/5++Xv+oxffJ+KV1S4c6wzRiH8IsahN3ja+8Ug1sy5LsLWbdDO9OGX+Ua3FIsR7/nnTigaxIi98o8WE3NL5y3vCBjJbMr0Crp6h3sROytNi0080+ZAEM0nHNjOfqkzhPQJDKVUVzgiW8W+WxVdGzfjVHHPW9B6IMqRrAwibS/FaMTB7yMWzQzDK8GlxF622eO7RLaIMFL5vGufvuXbQJl0yliNT7F5M9/IRHlCC6rbjoKx9JkkQoOYU6RGskJc0jbBGxasCDRfFhADX8KTEfz5ek8WqPIZiXeR0P85w2C9pH7dfkAj5RRRuKG9Omb3oA1oqsm0vqBdr/VwiKv2eAVeGIg8ZHjoZJpg2F3neDH2CYGVE1lclvZ2fHVwRsnWzFEv40ktQwuv0CjEHP38VB+DRdstAtscWG8O9nQU+HuhSjI71kIa9Xy6Xj+zsu//u8RfncUo5Jt3+Im8/9oKdY8O84Ml7T22n1+2wr0lZ2xjEmtdW6NGAPoCxOpwHQTO3u2Xy1R2ZGdfY3IdCHCwrmNhYSR+kldORVm9nWAVKaE8CUAXeCmn+axCIT2xHNJtZIsBfvRl+H+mw1H62ySPak1SMrOaUM/tzOfhO4a+gBiML885VyNz6ExmU7bSJ1ApQ5m0vR5Zxnj5G+YAd0xFel/s7a61PDzDv1T8Y1rKWdHRuxoe18LVeU8Jl8ioyqerQEuLUd4bA67lu9mYJuYpKu1/TrkIT6/euMWNYTADYB2yXbOKTMdr1LZVLluzHiOz+1rFWjH9jcDxv1R6xWEAsRSJAj9SULIqpoxaEXBsmfTjBSAsvSkyqzyjqpD7N/2XHTeMcrMXh5c4bXXmUPsX3x5yBo3BHIAxHPtt8Gw6T3PXLAwVBStE63rSuTzeHtDvEx4A0VqK/OXROZ/Emmu87AlfCsgcX
 k7/+9NTo
 kgs6yhH33uGXa6xaZ/PDA7Rsuc7bltTkZ+LN3cyZ1XfwygYHSDNTlSwlwHeHsNVXLQJp27n3pERSV1rPJe59B1MtWuuRapIh7ii2F4bACLn3jOZgKHmNJLKqVMZ673GqJkgAcfG3Dl8UGes2WvamEPlydMIJ/Bzli1nTtCn4Y4PBp7AGLiYaPHshNuSWXDDRhLZ/XKktSFrbMSB9uod/i/4LB3YTR/6VZ+tAJEDgjlZgafqNbvlIOCgO8S6kwLlepXduvYLDtzoFCag4NM0KYwFwqh4uo9ZeBozsid1iTyh8r1Nng3nt/eiyV9ST532nzSQqzBXjozboHm1W5Rb92VNZM8uYutc+7ngr5bM+A6EOg8aPiIzGN8xftYqA9T+CVZd4ys8OhkF1e0MovAg1fIeUtY6K4N4oqSkzq88tzhgy/1lU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ankit Agrawal <ankita@nvidia.com>

The GHES code allows calling of memory_failure() on the PFNs that pass the
pfn_valid() check. This contract is broken for the remapped PFNs which
fails the check and ghes_do_memory_failure() returns without triggering
memory_failure().

Update code to allow memory_failure() call on PFNs failing pfn_valid().

Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/acpi/apei/ghes.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index a0d54993edb3..bc4d0f2b3e9d 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -505,12 +505,6 @@ static bool ghes_do_memory_failure(u64 physical_addr, int flags)
 		return false;
 
 	pfn = PHYS_PFN(physical_addr);
-	if (!pfn_valid(pfn) && !arch_is_platform_page(physical_addr)) {
-		pr_warn_ratelimited(FW_WARN GHES_PFX
-		"Invalid address in generic error data: %#llx\n",
-		physical_addr);
-		return false;
-	}
 
 	if (flags == MF_ACTION_REQUIRED && current->mm) {
 		twcb = (void *)gen_pool_alloc(ghes_estatus_pool, sizeof(*twcb));
-- 
2.34.1


