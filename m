Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 267C0606A32E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qZ+xl9lW
Received: by kanga.kvack.org (Postfix)
	id ECC496B05B4; Fri, 27 Nov 2026 17:50:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4656B05B6; Fri, 27 Nov 2026 17:50:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9656B05B8; Fri, 27 Nov 2026 17:50:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86BCB6B05B4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:50:12 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0EBDAA7FB1
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:50:12 +0000 (UTC)
X-FDA: 85482393864.11.69E5F94
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011055.outbound.protection.outlook.com [40.93.194.55])
	by imf07.hostedemail.com (Postfix) with ESMTP id 08F1440005
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:50:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=qZ+xl9lW;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf07.hostedemail.com: domain of xinmengs@nvidia.com designates 40.93.194.55 as permitted sender) smtp.mailfrom=xinmengs@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795819809;
	b=HzB7CQis5n7uXUQLrcN0rUgcPhb9eCk94Rov7Wg6pqb3G08V/LRgD3KTw3NdGD88Lruzhg
	ds2wfoRMw2BKQ8Q0GYYjiil2dT0xe5yuU5o/q00Z1fGM57axUUzfT9LlixTjFOISb9jIro
	E9Ed1f9+FHzB3L4p2mkrN4/AT7szYxQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795819809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EkzZBW8NCYV5+Fkff5Sd6e6XoFoE2qC/1bNAaz8mr3w=;
	b=EVYRWV0DlEFL1PKF+s+932QphfArYZgalnPGn9UZ/G+tTTlcxNX2rg6wfZuKVuAkvD9JPR
	HyRYpEDDWPG3krCvmpqzKzLUjR3MYVXHSjq+XRAwbKw39auHmvb/FNjt3vVcFFIs4I8xO1
	Q7C3nyHG/raTOxJA6O7WpIXXxeuu0GU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=qZ+xl9lW;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf07.hostedemail.com: domain of xinmengs@nvidia.com designates 40.93.194.55 as permitted sender) smtp.mailfrom=xinmengs@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dMAXdpgQrGkTk4HBAvMMnD+/xESe9LCA5fnEzAac87Nma2lOItu3O+tMNg7DI/BOqPKE1/hKwZhyE8WBqtL+XhpZ6kog1z6hvskIn4BSoC3P/U6k3LXHTx5pD0qvc1oDwAAPZowQ/2d/eKyh7MYkV152qg5wNNVUyAcdflYLlEtIHHVQT9sAUK6ZlXwsmT3NPV2gD9+3HfpjTywwxXRTgSHboDcPVPxxBf31r8J7QyvjWVv0EJeUXTu9EjsYEGk5VdvfRElKbN5AAb8aarGJD10cFDFk4Jrk1PRKtg1dT3Pa9GJVZ+nvfAwwSXHQdjXNjKyW3BzcgfIZYaBwjteqpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EkzZBW8NCYV5+Fkff5Sd6e6XoFoE2qC/1bNAaz8mr3w=;
 b=C9HvUqRd5xsH4Fg9DxaVtZVT7MWOXLyRu+1zTHBVYnFluQNUgrmos+JKp1BfEO58foONZGgP4CmShfEHsNcHTWyVD6qalosvQi5FgFXat/6Ou1qsWn7u76BYMzWpABE9s3Fd2YElpkZ+LCQLc3Li5tMGUppD9rpgQuCg+7T9lWl/YOVQgb2+mahaWozOsnLzqWpE2tFpwRQkvCNKEJjkI6YFsLlkM9bdyrtbGGz8n6+Axili6HOyCkxfhxwDUFYLE0g1bq9GqbZqUs4GghOafiDIO8g4odmUEO4U766gRZIdHc5ab4rmIQGiFEpKXt7yA6QVtDYapsqHCiCuNQnalg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkzZBW8NCYV5+Fkff5Sd6e6XoFoE2qC/1bNAaz8mr3w=;
 b=qZ+xl9lWVpgrmg8VfTeD1kfB/noq33z3nl6Ho/q4FXPAhxmwEGiyYSjLQGtr/RWm+DetptUuwCEbTvHNGxyLvXSAHifVsZlKKfWpuk7mpl3YTnsj+yDQJjrqTlovSrMogpxrVI9Lj1xbPKIxvOdqGe97hKiG+C13Dw8NXp7MtD+KtfEd0cg8LOcGJIYFXwRg7bFODwbE42Opo1IrLBDABNnX/R3aAG8tU8Ph62L3Ggc/r81Il5sPJJ8qI/+Linnh3lRnEPpZ/BzXrgIGm/07fC3dvSUjasKnJrAEemqHj/RG8urjbWsvdT6xgtjGe7MAAdEHh6CR1DrTUa9zPKyTeQ==
Received: from BN9PR03CA0478.namprd03.prod.outlook.com (2603:10b6:408:139::33)
 by DM4PR12MB7504.namprd12.prod.outlook.com (2603:10b6:8:110::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.10; Fri, 27 Nov
 2026 22:50:00 +0000
Received: from BN7PEPF00000092.namprd03.prod.outlook.com
 (2603:10b6:408:139:cafe::85) by BN9PR03CA0478.outlook.office365.com
 (2603:10b6:408:139::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.10 via Frontend Transport; Fri,
 27 Nov 2026 22:49:59 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN7PEPF00000092.mail.protection.outlook.com (10.167.245.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Fri, 27 Nov 2026 22:49:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 27 Nov
 2026 14:49:49 -0800
Received: from xinmengs-dev-vm-linux.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Fri, 27 Nov 2026 14:49:47 -0800
From: Simon Song <xinmengs@nvidia.com>
To: <dakr@kernel.org>, <acourbot@nvidia.com>, <kvm@vger.kernel.org>,
	<rust-for-linux@vger.kernel.org>, <nova-gpu@lists.linux.dev>,
	<linux-pci@vger.kernel.org>
CC: Simon Song <xinmengs@nvidia.com>, <alex@shazbot.org>, <jgg@nvidia.com>,
	<yishaih@nvidia.com>, <skolothumtho@nvidia.com>, <kevin.tian@intel.com>,
	<airlied@gmail.com>, <simona@ffwll.ch>, <ojeda@kernel.org>,
	<alex.gaynor@gmail.com>, <boqun.feng@gmail.com>, <gary@garyguo.net>,
	<bjorn3_gh@protonmail.com>, <lossin@kernel.org>, <a.hindborg@kernel.org>,
	<aliceryhl@google.com>, <tmgross@umich.edu>, <jhubbard@nvidia.com>,
	<ecourtney@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<kjaju@nvidia.com>, <alkumar@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <zhiwang@kernel.org>, <zhiw@nvidia.com>,
	<boqun@kernel.org>, <daniel.almeida@collabora.com>, <tamird@kernel.org>,
	<work@onurozkan.dev>, <jgg@ziepe.ca>, <bhelgaas@google.com>,
	<kwilczynski@kernel.org>, <dri-devel@lists.freedesktop.org>,
	<peter@colberg.org>, "Liam R. Howlett" <liam@infradead.org>,
	<linux-mm@kvack.org>, Lorenzo Stoakes <ljs@kernel.org>
Subject: [PATCH v4 0/5] Rust VFIO PCI support and NVIDIA vGPU driver
Date: Fri, 27 Nov 2026 14:49:12 -0800
Message-ID: <20261127224928.1511382-1-xinmengs@nvidia.com>
X-Mailer: git-send-email 2.43.7
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PEPF00000092:EE_|DM4PR12MB7504:EE_
X-MS-Office365-Filtering-Correlation-Id: 480e2d1b-e352-4823-d87d-08df4cd8c442
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|82310400026|23010399003|1800799024|11063799006|6133799003|5023799004|261009223027099003|18002099003|3023799007|13003099007|10067099003|56012099006|261102130727099003|261026140227099003|261102123227099003|261021135927099003|261022115727099003|261022105027099003|261028144727099003|261022113327099003|261022075727099003|261026121527099003|261026130827099003|261021123027099003|261021121427099003|261021130227099003;
X-Microsoft-Antispam-Message-Info:
	EG6S/P8ZU2ToHLcsBgpAYmRoKjYi1Bw6xzHix/WTU0X7xD3Sa15C3FDang+HTfo1C6q/WtdqJ3cVyqjdqs8HS2YP8jvxhtmbE8syLRwLLooiHRofE9e+s/kBMimOSZOmesssiZvF9CtnHJqBQ9xyHc6pPIUV0whM0rF/UdtVTM/W+2Eg1nyX2aUa0QZ6vNPm1/KYCwnNwyznPmg9GYxV03uCvcYm7YNsrqClRNwNrC6pWfjhLnUaRZCtZJBpmgY5e/lSjHe1E3/uXgPeWaUIK6XPF2VRW+IlOOhmMvQgwVSOmgpSA+jbrszXlzxWu0wrtisP5engVBB8QxdMdQxqciDWFul+7hNF7P0OoXleDACGrAD8+SdUVSCHwRdRqsm1naOJuP4wfpKf3N173Qo5uhrlWcpfmvFx6Mb/OpVkbwtD4FEpUVHE0vIhEKep+tnLj4xlxicrsKbmNlD7eK8KIVqRHv5V08eaSc1Q9GGjc2SRCKE+mr5AyxrqcvmDhYuauLoUvDfRUG9qErrEApZCEIuyEUB/vaYXepdXn4FwBzL9HB/RWtbFzvZwsHFpcK8bzCiUaHOGZtcENLnH2cUfN2UnYm9gYMzrgSYUmIFu8aUV4kcKqJHUm067S61xC7GxPiShXycLIb1MvW9KmeQQllJJRW16/XOscwOlVzhIPwXHlpkcvSTDaXYE4GmW/sQqkfiiaUNF7XgT3QVbaY0jTg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(82310400026)(23010399003)(1800799024)(11063799006)(6133799003)(5023799004)(261009223027099003)(18002099003)(3023799007)(13003099007)(10067099003)(56012099006)(261102130727099003)(261026140227099003)(261102123227099003)(261021135927099003)(261022115727099003)(261022105027099003)(261028144727099003)(261022113327099003)(261022075727099003)(261026121527099003)(261026130827099003)(261021123027099003)(261021121427099003)(261021130227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wNa4NidzxyLdQmG8sfJIqO0Fjw1ErSQivSu22d+nU9sYXZsa2npMWY5T6W3j0xPNHy2qB0NPTdgBVtwjgEzBDV+tSuCOokvpFc0ozZwpiTiI+L5Rs2hKegwvTKCjmaarXO/tKXALBf9FjmEfcr5CF1ujX/J7yi/VQS8NWZHaF7qREcU2/qZFUafm/H/lSBbLtZScflQkC3K5Visd6+EqaF7i8SPCDJQ8Rbkny3varQi1O4WXqnVpYOgM3PRqjPbINqXMT7PQySZyDQwKJckmRMZHHXeelORAp8p5h4ixXPo+D8vqTygc+BzYx+cgqh3JvWDuiKP2IUPoarShlZO+EXb/hVmPuVM276e+lNJ0H1CJLcFyrpgPixjGFKx/cCkINW/hd/LlJkpGhIq3U5LLQlgXheCTTLjrisloJ7ycJdP3444fxH0SVsW0Hi+GKasM
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 22:49:59.7899
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 480e2d1b-e352-4823-d87d-08df4cd8c442
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF00000092.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7504
X-Rspamd-Queue-Id: 08F1440005
X-Stat-Signature: yieoyi3x9r4e5picy7xiweexwr4te649
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795819808-17591
X-HE-Meta: U2FsdGVkX1+SjX0p5WYVPYMvtGAzu+xvZ0q4lPqD2BkRIcdBMMXOEIAhjXqbTKhdZ59ZK9k8ZjgdTAu1AomtPE+UiHbcT7ot8lpKKXG7CbJzIziECcln8Za5VPf1RC67s7Cr2ADwkVaXXr5d/KEoaeZiXz5CrF1sz5CbkKGeAVObpfPsp3EAxeg3cRafHG7hSsY7j8DjVRq2tTk25YyVduDAr+WnRepIVX68xP+D01rilHD/zd+gnKkwWFpUUyTtOE2ZTYIOmvAnpg1//YCAiECdX9MBdsjIn+d1wlJx1N87/fn5tK8+b5n3TKu/zrRxfhCes/mpKTlS81kvZ2xrJiXlsVB8dK3xKmEtv0H31FDEQa0qaLK36LJanAij6BJU+Ih1ze3DUgXwu58f9KtbP2Nc2HI/GB4f7i3gBW05rqDszGV5yOxoUtHP8fpA8x4KhS0TDVe8JLLo4JmLTPggjjwlMcYmymFipW93H73j/ZAqXk06fKRi+m061x2f4k84HGiudNSYY2G+1DtrhT6UDM0fgSvtBq/tHVg3y0HzeKbvVQe2qDDD9Q9tKghDC7GaIZb0eMeOEFvBb0sQqftLhILreVCi3XH1y0UuiqIrQWlKU3Oo4ZNJJlvsngdHG+FfdTO8gul2xNv7T9SG1DaHmjVd/nWleH75Z+P8TQOda/bGqyVFl+ujRCit3NU0uW2lTmCiVsZKIs/XG2FO2330/aa8rmDwyIXxr2J4AB1Fmf4piCVeVyZziSDQRlS7KL1Gdarn0UykHsLUiEFj/5ZkiIhCAn080KZw1+2q1AkSV4ztKdl5baXI8WpGCt9DZh4Lbg8KIA/HGbb0Yb9RfYJgW1MBNu96XSdtX4Yno7Jo/pP5l0LeP1w3dyE5Cem8kAUDhPr147Px3NboQj64gXI5w9RgEXA3Vo69UPGaEnbXRWETCS4r37dVJi6zP0cw8XDdi162AO0xhGOfa/kxaG4
 AopD6h6m
 k2h0Zic3+PfEUA7UwN5uooym1jEUI0J02sRxZ+xoXRLucGpn9k8Dv/b8CaF+ZB1ykif9nSmwNMknNoWTwQvzCTvBOGJBhN1IDh4pDB9G+1fVng8E03N6mv6zaLFnIGV1wyV030wYMng9RX6EOfSwu4vty6sQE0LBlp71DmTnl22EpWtn7QXSY51LNdHFOSubOlxkeBQkFkHFWTd/G0l6X0tl0UbUNov4/G4+nGeUQIPQqpU3GEFOGByu1DkCjUT5wttTfLOabuMg7dPMG8VGdItfT2TYTFTbswGLBJsxVFM/sshEHzzt5nTsmz2XQwpJJbalw3E+RmIYhWSNMbSQxXOdyfZonlcLYEIl4fysz+H3CibsJQ77SAT0oojC7YkSv36y81opZJ32O1N31aIPDh8VTzUd0XrxW1igVoPd1iID+pGbOLBAyy8iWzC41WfkADfKufHt3loB9IHcN+Hyes8WhbEvYsPRC1b9aPySFVOWWNG+Lvvj9GdD+kL/JEv/MymSmkUcNWNBxmfF87LKgD/zsmA4MVKtjPLuEWipVRzGauaIrm1zuwSb+G+vReWrTDf/Wyjp8l4VrZRwJXD7+wW5sL9vNZKcJtUxBDDWMCmDu90g5+JYpW5m6dJaFzVBj0w9Et8u316nbbfZW+O1Bi+F3wo0JhKBd48b0e1b9Pk81Miv1ZZ2KdGVSIk9zx+BcZz2m97ZSw9d7CrPDOfXxCMvWXerf5VgBhQp/rX44JnDoZs0WM1UBKWG8P0ZAqwm0W4vKnpyyt5FxNfeT6NXq5EwREPfTZIZnC0/RmY656qDtLQzuYxqj3L8usHzZoHYJj6ejHymg9sSVS4o4j9u1W6o7kigK6jkKYba/6p26hjYgOF9pvKHN7dU1dNB46P31gwk4qcogjhat1fPRGoC4M5jjrbPIRay8BP7P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is v4 of the Rust VFIO PCI abstractions and the NVIDIA VFIO variant
driver [1]. The driver uses nova-core's typed SR-IOV PF interface to
create, reset and release vGPU instances while VFIO provides userspace
access to the PCI device.

Patches 1-5 of v3 were applied to driver-core-next, so this version
carries the remaining patches. Patch 1 adds the VFIO device handling
common to all buses. Patch 2 adds two VmaRef accessors for patch 3, the
VFIO PCI abstractions. Patch 4 publishes the typed Nova PF interface,
and patch 5 adds the NVIDIA VFIO variant driver.

This series is based on driver-core-next. Patches 1-3 need nothing else.
Patches 4 and 5 also depend on v5 of Alok's vGPU manager series [2] and
can follow once it has landed.

Runtime PM is still not part of this series. It will follow once the
generic Rust runtime PM support [3] and the PCI bus handling for it are
available. Until then, vfio::pci::Registration keeps the device runtime
active while it is registered.

Changes since v3:
- Drop v3 patches 1-5, which were applied (Danilo).
- New patch 2: add VmaRef::size() and VmaRef::pgoff(), split out of the
  VFIO PCI abstractions (Danilo).
- Patches 1 and 3: build the abstractions only if VFIO and the VFIO PCI
  core are built in, until the new build system is available (Danilo).
- Patch 1 (v3 patch 6):
  - Remove RawDevice and make the layout a type invariant of DeviceBase
    (Danilo).
  - Add vfio::Operations with the RegistrationData and OpenData types,
    and drop the R and O parameters of DeviceBase (Danilo).
  - Use Option<NonNull<_>> for the open data, expect() instead of
    unwrap_unchecked(), KBox::pin_init(), and one unsafe block per
    operation (Danilo).
  - Reword the type invariants, justify them with INVARIANT comments,
    and hide DeviceBase from the documentation (Danilo).
- Patch 3 (v3 patch 7):
  - Let vfio::pci::Operations extend vfio::Operations, and name the
    lifetimes 'reg and 'open (Danilo).
  - Make the I/O callbacks optional with #[vtable]. An unimplemented
    callback leaves the VFIO hook unset (Danilo).
  - Use the VmaRef accessors of patch 2 (Danilo), and let Mapping wrap a
    VmaNew (Alice).
  - Use from_result() in the callbacks and const_assert!() in
    Registration::new() (Danilo).
  - Remove RuntimeActive and call the runtime PM functions from
    Registration (Danilo).
  - Add the optional dmabuf_len() callback, which lets a driver limit
    how much of a region can be exported as a DMA buffer, and remove
    Device::new_passthrough() (Alex).
- Patch 4 (v3 patch 8): rebase onto v5 of the vGPU manager series [2].
- Patch 5 (v3 patch 9):
  - Match the two supported device IDs instead of every NVIDIA device
    (Alex).
  - Reject a BAR1 size that is not a power of two, and report the
    virtual BAR1 size when the BAR is sized through config space
    (Alex).
  - Clear a reset error at the next reset, and do not treat hot reset
    specially (Alex).
  - Reset the vGPU instance in reset_done(), after the PCI reset,
    instead of in reset_prepare() (Alex).
  - Support DMA buffer export, limited to the BAR1 aperture of the vGPU.
    The VFIO PCI core revokes the exports at the last close, after the
    driver has destroyed the instance (Alex).
  - Do no vGPU setup for a passthrough device, do not signal the VFIO
    error eventfd from reset_done(), and name the module authors
    (Alex).
  - Depend on VFIO_PCI_CORE=y, following patch 3.

v3 patches 6, 7, 8 and 9 are now patches 1, 3, 4 and 5.

Link: https://lore.kernel.org/nova-gpu/20261119215046.2892839-1-xinmengs@nvidia.com/ [1]
Link: https://lore.kernel.org/nova-gpu/20261124135937.18583-1-alkumar@nvidia.com/ [2]
Link: https://lore.kernel.org/all/20261124113555.2480381-1-beata.michalska@arm.com/ [3]

Danilo Krummrich (2):
  rust: vfio: add PCI variant driver abstractions
  vfio/nova-vgpu: add the Rust VFIO variant driver

Simon Song (1):
  rust: mm: add VmaRef::size() and VmaRef::pgoff()

Zhi Wang (2):
  rust: vfio: add common VFIO device handling
  gpu: nova-core: publish typed SR-IOV PF APIs

 drivers/gpu/Makefile                    |  15 +-
 drivers/gpu/nova-core/driver.rs         |  34 +-
 drivers/gpu/nova-core/nova_core.rs      |   3 +-
 drivers/gpu/nova-core/vgpu.rs           |   1 -
 drivers/gpu/nova-core/vgpu/vgpu_api.rs  | 171 +++--
 drivers/vfio/pci/Kconfig                |   2 +
 drivers/vfio/pci/Makefile               |   2 +
 drivers/vfio/pci/nova-vgpu/Kconfig      |  20 +
 drivers/vfio/pci/nova-vgpu/Makefile     |   3 +
 drivers/vfio/pci/nova-vgpu/nova_vgpu.rs | 418 ++++++++++++
 rust/bindings/bindings_helper.h         |   4 +
 rust/kernel/lib.rs                      |   2 +
 rust/kernel/mm/virt.rs                  |  14 +
 rust/kernel/pci.rs                      |  12 +
 rust/kernel/vfio.rs                     | 462 ++++++++++++++
 rust/kernel/vfio/pci.rs                 | 812 ++++++++++++++++++++++++
 16 files changed, 1930 insertions(+), 45 deletions(-)
 create mode 100644 drivers/vfio/pci/nova-vgpu/Kconfig
 create mode 100644 drivers/vfio/pci/nova-vgpu/Makefile
 create mode 100644 drivers/vfio/pci/nova-vgpu/nova_vgpu.rs
 create mode 100644 rust/kernel/vfio.rs
 create mode 100644 rust/kernel/vfio/pci.rs

-- 
2.43.7


