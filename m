Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33AB6EF070F
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 06:11:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 536FE6B0099; Mon,  9 Feb 2026 01:11:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E4726B009B; Mon,  9 Feb 2026 01:11:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AF2C6B009D; Mon,  9 Feb 2026 01:11:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A3A76B0099
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 01:11:29 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC394BA9FE
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:11:28 +0000 (UTC)
X-FDA: 84423896256.10.1C1154D
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011021.outbound.protection.outlook.com [52.101.52.21])
	by imf28.hostedemail.com (Postfix) with ESMTP id B5F32C0006
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:11:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=h0zBe5ly;
	spf=pass (imf28.hostedemail.com: domain of Honglei1.Huang@amd.com designates 52.101.52.21 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770617485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p7sOCVtAr4Uhgj6aG/CyN+kX0pTSAJrcF5LYPU+vluU=;
	b=amaTYSXlUhoQb5iARWoNjUjAFiY2JfKuLnazhDhQmTfKgzSF5x7P7SKar4dOLkrYBjIa/w
	Cm7mdY4VlUymHMLX7C881eWl+hCZyffoxiPsH83cda5nVaFPSUh2OGWhkCyTD0/qzVXQQX
	nyKfAeyhOEp2jsBV6C+zS2qhw4kl2FI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=h0zBe5ly;
	spf=pass (imf28.hostedemail.com: domain of Honglei1.Huang@amd.com designates 52.101.52.21 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770617485; a=rsa-sha256;
	cv=pass;
	b=1kIqwdXpq8WwD1+FrJv1xqZ2J5+pzN9AhUF4QH8k7oS6d2vE7+3V+NcU1mYgAjiotiEGpk
	EF/OE1TalusBBLKxmTD2EAd8sIBH/v0GRGfhZDS1hTFFhB/ipDQbj75ZY3ifXhZac+gxL5
	5SncMk7f5vvImhMKwUguVC97hf5EhJ4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vq5NB8s/YR01H88FjnoYnOw9uaLMCyBqdnugqQBpOO0nZ7/97hCCA0yrZhFj0WspiO4iG2QgAhtTIdOcIVyI0ktjPfp1Y4eqif+Y8IcmSh2BoQFUN2/wp/yDQVKm+QJN/w9Odv5BqgOSvBTe95hBP8extvyTRpvVfYY1jvubn8ph3y7YJpxtga/QQ4hPSL0ZKlntxfnBPgZfX58eyeDBHlhueq7orNTnqExmoCDoQ7XVZDBobALg0nhzReF0bgrDgNSS06/61WSa5ubpb6KAZlCovHNqQAIcV+8t6GQyHA7d+beHthiBDJ6p3tO3odJOPctLQCkRd4iHEDpCGO2tVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p7sOCVtAr4Uhgj6aG/CyN+kX0pTSAJrcF5LYPU+vluU=;
 b=izbXqpkpA2Rh7YEaYLNJYKP/tshNRSy8z6xaK1mRzLoedwSCAQFIig2ipVMdAKwFDolKTDZbXZITgmbKyRF99cuwOoEtNcMXV6cPLjxp2wHwPcnBsQvU73x+Fxf0hrlqFhZPvUJWL5CtJBFKRPBw8yQDPoNHlrifsqeTzxEJjasg/0ZrVkWqw2zcOpU/ehTsP/VqozwxZH8v6zsl2zbxLQTyPM+lWPXekMbc4KzaOcFWWNURxK98dyc2RFs9aLI0mpEY+hHgQcaB4MJF4g6MXZg79rN9gEtMwoUaO21zLarSDd99cRL9LiwmVJGgHQhSbY7Fu/W87lD37UnW7ZS2Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p7sOCVtAr4Uhgj6aG/CyN+kX0pTSAJrcF5LYPU+vluU=;
 b=h0zBe5lyvB/c2ommfHIOxhc6ExGT5fknKovuLCqkOkSboU7QcEvC0/8YkP3OvaIfrHBVssrQybUkGipqZ87t9KcNrf9XqAJ02ws0wSsLabjynVcYuXtgiH8N80M0qb4UPQWXTcR3l4X+mZy++UelgLubNhwlmVBOLFbBcBBGSH0=
Received: from PH7P221CA0065.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:328::31)
 by CY8PR12MB7265.namprd12.prod.outlook.com (2603:10b6:930:57::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 06:11:18 +0000
Received: from SN1PEPF000397B0.namprd05.prod.outlook.com
 (2603:10b6:510:328:cafe::37) by PH7P221CA0065.outlook.office365.com
 (2603:10b6:510:328::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.18 via Frontend Transport; Mon,
 9 Feb 2026 06:11:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000397B0.mail.protection.outlook.com (10.167.248.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Mon, 9 Feb 2026 06:11:18 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Feb
 2026 00:11:13 -0600
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Philip.Yang@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<akpm@linux-foundation.org>, <honghuan@amd.com>
Subject: [PATCH v4 4/8] drm/amdkfd: Add batch MMU notifier support
Date: Mon, 9 Feb 2026 14:10:43 +0800
Message-ID: <20260209061047.3881808-5-honglei1.huang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260209061047.3881808-1-honglei1.huang@amd.com>
References: <20260209061047.3881808-1-honglei1.huang@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B0:EE_|CY8PR12MB7265:EE_
X-MS-Office365-Filtering-Correlation-Id: 53ec1d4b-bf9e-466d-1980-08de67a209fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HlkJMdgebmtf/FBdZXlLBKMRdQaHO0LrqbTCjzO3dvgTyTY77ftakCi66dDW?=
 =?us-ascii?Q?rtQvIyZYAMH9vf2oinynEvnWg7TMsMz5b3WVO5GTx3DmT7RP7KseQU8bP3FK?=
 =?us-ascii?Q?Wt6qt71W1uqAw6ideBtHV6AW5QP/sShHlEIw5v3Xk1fgSgKvC6X6pGWPxzcy?=
 =?us-ascii?Q?Wa6AM5iDTkd42tOkSma5R3mtHVUMnw6f3ebTYx1ts9+viI+EwziWuNo/Rqxk?=
 =?us-ascii?Q?E2TT9T9nKP5eEj3qP6aiJmYALD4CefPrUtTY6Go+nkZj3Xhgku+3+oprhnHt?=
 =?us-ascii?Q?tba6WvTnv2cKQ6IWL8LiQbbFdeAVQHZc06kEzFP64I9Q49ER/4XFyBHbuM+m?=
 =?us-ascii?Q?7fiZQ2Qukc0kzMgQnxrpEpmgVgzqePnvqNcDy2cqigkbtsGimEheRRr26NRD?=
 =?us-ascii?Q?0QPYdgAygc65wDzkiWjw6Uzz9kZJwNJhOEKGRc0iClj0XaWbo3jrU+iSrVtn?=
 =?us-ascii?Q?pc9+h62IZN7aXhQAXnXkJg3anqECcBTE52FVNhdiiXzLkqaoCldd63VCDrIs?=
 =?us-ascii?Q?trpsvmf95BymhaNmjZXjzCL8DQF++0RF/g7f5/TvibqZBUgk/M2IP9Ho6gRD?=
 =?us-ascii?Q?YrwMuGcQAUQ4xEeCCFg9wJZ0haQ6EI7gsMlcLy+8Jz/WFZRyYP1lQVUoY66m?=
 =?us-ascii?Q?/WkQKXbXQsPeXd2c3yMMBuugT0CCAnd4UfO8eeqSEcTZkOuj15XeBYPN3zmh?=
 =?us-ascii?Q?2VzJIUqAgZCItbVpsP7LdOwe1mQ/zJs4IAxw0l7frql6DDkZAP10vrAbBC4J?=
 =?us-ascii?Q?KjN6I5E2RZuN76cnDaLnplWDJwQ98FjEYzUIx6YRcN51ig7SEimQw36h6Vi7?=
 =?us-ascii?Q?82jJi2y8oJzcyHsGkektWxRDJxwofi1Q0XE5OQ42dobnFv0Fc3hgYPLMxxZt?=
 =?us-ascii?Q?/Zu3eY6U4hflu066AdYMNhOiXK53S7RCICgTXLGmZh8AFdlZR9EuDvaf/9VH?=
 =?us-ascii?Q?aWKATJqU7gUVezQch/rWac6dNZFMEEDIFI8OLpMRf2bBB2q3hVE5zfytevSW?=
 =?us-ascii?Q?gRy/qrGsphGyb7OboIsLgBepKgUlv9ABLhsW47N9FDa4MotkkxxM+KLMcSRM?=
 =?us-ascii?Q?2WdzdDaoVFmDEJlFARV7asKzRhUOOP0LZwj3NBaMZYQ+Fg8Xw0Tnm7pEAUtc?=
 =?us-ascii?Q?YWjE9ryU87WFuZJBY4Yjqvr/aFjNIv8D4fQrX70HOAG2/c1IhiTOQWQ22ri+?=
 =?us-ascii?Q?HyKFiPpXQ7QTtXkKvc150jbFvpwjiDcSwNQp5gGBVDpAx2vv5Ucgv+KuV9Of?=
 =?us-ascii?Q?+woESDmXYMAXsKGIob1MnScSqm2yVrqnYn+EIaMrhwWYJt18uyzQ+hMzpx40?=
 =?us-ascii?Q?jukA3ui+UI7Aqt6VwuuEOEIpHl4+/lw11Cb0QU0fzZFE7kgpYS/q3vMMxvZn?=
 =?us-ascii?Q?w1AM6eWXgCwj9If1yXut1Pg5v3+RgsOcU9dwI2VIuZlaZWWrUG6mo2qlMuRK?=
 =?us-ascii?Q?Ex+mCVRtVyfZfNs2ywY/UnzD6mCjr28eT95KVooOqvDLQ0wcBzrlJ6kpu287?=
 =?us-ascii?Q?0kwW8+vBp/EO+cCJRDui7jniOaXvnXlbyH0JfcUqnAK6Eg0fX0qpxEYFrCLk?=
 =?us-ascii?Q?Vwr8kYadxj1LjPRIDstvz4AtojwirFV+n7TxIOnhUVpzzZJ2CAL02ByktYiz?=
 =?us-ascii?Q?E6tlmkR4DI51Ug/Xu5L+wxtJTTAZX4cWssXtiZGKODN0EgRAkiTjEnFmCCQR?=
 =?us-ascii?Q?orJJlQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LEDuTC+cMHMFb6PgxfoVnkp+3fwEW1sKiySRY+YLqzt1435oEt0YGj0KLIurFVwecLI+tQqkQLIqB5ofnwPoZFYPtgbw8Bvfl1l0XzGB8bApQ5wLrrTIugXpnRKP5m+iAekTn+SsqJE7QKH6MoRV6/pyT/wGVbvzA+5bNbTIdpI+4EQV1maBeeo0IyWPXUO25QDRl8PCsIPgLs9br/IFanKIMjq4ukDz72W4A3PZv4BfMXqZfuOl2oBgPEv5iA50NcSl+2Jh5E3BpMwWfI6bkKEtcA9+9xUc2jK19wSbuLXwBum6NULTc/r8EAv4ens3D1gLXagftS0QyR7GVbDQ+S4gsmlCxwBMcZN4bC8OG5rb1vkpVcO8H51emqWIrxDSrlUZYKQ0e3RPJr1LqhJrUDplSLQ2caUJDps1nvyQ7CEK5lhNJIpD87S+HANhD3be
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 06:11:18.2488
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53ec1d4b-bf9e-466d-1980-08de67a209fe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7265
X-Rspamd-Server: rspam12
X-Stat-Signature: a1bd73s4nryixib7xodja8by3ofbbfd6
X-Rspamd-Queue-Id: B5F32C0006
X-Rspam-User: 
X-HE-Tag: 1770617485-730807
X-HE-Meta: U2FsdGVkX19eAzKvvKnqZ+mMZYqs25xv1KRH/rqioWHLw91aG3RUxlCxf5F3L7nRvcoRsmx0xDgytBMS88ALBph/1FyKmwpYTFCyj+LEmV8uRqLzbTMT+jwNylTIMzRLKOc2n3jCcfNvNysZKVnPecxxTPgGPo0w1M9uYoVoXcaovqvWIoSbyr7Wfb9hzpw9Q6yoXJkPbCqfemoQid/F+LILP7vT7b+sS5gjIbodNcF4bMj6Ojqb7ojNQaB3yR658doOCacEYKZwKmdS/DTR/Ad02sJ8nBnx4M3cDdFqti32dKhWmg9eltBo9GCh6iH1M1YSgLsjnTFs2V+yA3PQy4D97LLcdss3Nzhjim5JR1rVP4HciOQDj8jlFgKDADEpYz9Dzw3IL9TXILP5v1SO5bTNDTt/UOIidAygl4J/JgM2t5/N2aS26H1DYEAvKfBc4ufWK4foAOdfTZIDMTYfmCpz1wqIkTrtN3nbqjj5seLK2vRm9v0SzHufJccq23XQus1L5P/JYSyJ5/OqsEYz39Gwam/ZkGNmLoIrVByoLBMGA3mAKssc6TrpyGo+4X4NCl0D+PyY86lpdg5xFplJENchOZ6rHMK2GZ8gngkPMAGKECO7QlQktSWhSX3auq3wZ0gbadshd9qjg5l1o9cfSh/fgjB29/kNrCR82YunhJl3+cbKP44v+XVUSBPQnMSeK7fICeEdADaxaB6LIuLxoyCBqKzWBncKS2tA0HDCNLQ3hgIYgdlAH95euv1NS955rp8//gaZq0MzFPTCufzdg88Fx5hW4/myCbybzYpEtCyo2lQyUjZEyyqCN66Ggp6A8zP+HRZ0UUIRKPM0kfeAMi5NseiEy16RzoqwiXxLPDawtpwh41YayOJzWUcggDYOds9hNpmICGHKuWAkGexl/pWiEHwIPdshaExAHuEfhe9HUwpXLSIf5wtH0XFhxrkfh7jUFkvbv2gaA2CddMc
 Plb0ix3C
 Jl2BcgMwOgDnTv5cpYcsFPuOoc4WzM/tzypWena69KVWBH1gprxsib1Zegmb8gkA0pXe4y2WtauTWzQP6ZeXT9/AxWsozQtGN8nTAEcj5+o3vzMfcD5cRBnnHkro+lDw50v4jnwQ8MAlkiJe2KnTfI6RGIQPM780HIA7U26FSiN1xfUmtG+Px9BQm8Ixkyu6Nf/aBXV5lEM4Hu1hy8zG+U5A7Vc6Co5fOTH+/duLaotwB93/NkbVpU+PnCco0wUsER6HSZyJMXJ+1lopi9IuVYGzDcY/7WvldZbEK5mQfQp7tjEol39FqcXuJsz0nNAb+ahXXeyZ3gT+7JUsFHObCvC6B1Cf0G4owVVF64kgXQHtS7UhJZWL5KwbA/1ihRMke05xnZRIP0xCk2VAm4K6hZ6D4h9YUr8bViYfhZxQCe7EUhLVQi3ogsWI0QPop3deAXSN8rf6PwHLT7T0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Honglei Huang <honghuan@amd.com>

Implement MMU notifier callbacks for batch userptr allocations.

This adds:
- amdgpu_amdkfd_evict_userptr_batch(): handles MMU invalidation
  events for batch allocations, using interval tree to identify
  affected ranges

Signed-off-by: Honglei Huang <honghuan@amd.com>
---
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 59 +++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 6fe4ed22c..a22a99b8d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1143,6 +1143,65 @@ static bool discard_invalid_ranges(struct kgd_mem *mem,
 	return any_invalid;
 }
 
+static int amdgpu_amdkfd_evict_userptr_batch(struct mmu_interval_notifier *mni,
+					     const struct mmu_notifier_range *range,
+					     unsigned long cur_seq)
+{
+	struct kgd_mem *mem;
+	struct amdkfd_process_info *process_info;
+	int r = 0;
+
+	mem = container_of(mni, struct kgd_mem, batch_notifier);
+	process_info = mem->process_info;
+
+	if (READ_ONCE(process_info->block_mmu_notifications))
+		return 0;
+
+	mutex_lock(&process_info->notifier_lock);
+	mmu_interval_set_seq(mni, cur_seq);
+
+	/* Discard affected ranges under notifier_lock for atomicity */
+	if (!discard_invalid_ranges(mem, range->start, range->end)) {
+		mutex_unlock(&process_info->notifier_lock);
+		pr_debug("Batch userptr: invalidation [0x%lx-0x%lx) does not affect any range\n",
+			 range->start, range->end);
+		return 0;
+	}
+
+	mem->invalid++;
+
+	if (++process_info->evicted_bos == 1) {
+		r = kgd2kfd_quiesce_mm(mni->mm,
+				       KFD_QUEUE_EVICTION_TRIGGER_USERPTR);
+
+		if (r && r != -ESRCH)
+			pr_err("Failed to quiesce KFD\n");
+
+		if (r != -ESRCH)
+			queue_delayed_work(system_freezable_wq,
+				&process_info->restore_userptr_work,
+				msecs_to_jiffies(AMDGPU_USERPTR_RESTORE_DELAY_MS));
+	}
+	mutex_unlock(&process_info->notifier_lock);
+
+	pr_debug("Batch userptr evicted: va_min=0x%llx va_max=0x%llx, inv_range=[0x%lx-0x%lx)\n",
+		 mem->batch_va_min, mem->batch_va_max, range->start, range->end);
+
+	return r;
+}
+
+static bool amdgpu_amdkfd_invalidate_userptr_batch(struct mmu_interval_notifier *mni,
+						   const struct mmu_notifier_range *range,
+						   unsigned long cur_seq)
+{
+	amdgpu_amdkfd_evict_userptr_batch(mni, range, cur_seq);
+	return true;
+}
+
+static const struct mmu_interval_notifier_ops amdgpu_amdkfd_hsa_batch_ops = {
+	.invalidate = amdgpu_amdkfd_invalidate_userptr_batch,
+};
+
 /* Reserving a BO and its page table BOs must happen atomically to
  * avoid deadlocks. Some operations update multiple VMs at once. Track
  * all the reservation info in a context structure. Optionally a sync
-- 
2.34.1


