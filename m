Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D182D59F6B
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 04:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD8A86B000A; Fri, 12 Dec 2025 23:47:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A894A6B000C; Fri, 12 Dec 2025 23:47:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978276B000D; Fri, 12 Dec 2025 23:47:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8196B000A
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 23:47:33 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A2E913551C
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 04:47:33 +0000 (UTC)
X-FDA: 84213214386.14.F237A84
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010062.outbound.protection.outlook.com [52.101.56.62])
	by imf24.hostedemail.com (Postfix) with ESMTP id 59D21180003
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 04:47:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nhbKvPhY;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of ankita@nvidia.com designates 52.101.56.62 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765601250; a=rsa-sha256;
	cv=pass;
	b=bZvg90la9W4eu4GvON8TxQOxXM2/5glTwy7WbMA7NeYU0bNWj05/x3rnqgADARd16mK+S3
	IRf57/xoWWtCVWDWJ5KLyXm+E2z3rDK4PJX0WlKu/kmDIfyce2Hl1atMtvnXm7SxnGobh/
	mJe24rCpLLW4flgB/+GCLzPnD56wMlM=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nhbKvPhY;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of ankita@nvidia.com designates 52.101.56.62 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765601250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+9X97v8oLGLYonIialThNeDaSCMrIwHdgiUJqYKE3k=;
	b=p2XHVBpOflKeNrstKqM/YwYZbJuEXtO0MT9s2lbvQk8PqL6nJQK5itSafLnBDYyB6sFRMS
	k6G7nLX3RRlfMpCJmVN9N6Y/JJynQAA1Ct4RBmTJoDUUnRrm7u2riFs/b/mUeYzEx1EedZ
	cFatBnayPMuKNRAb5356so6YkiJUlkA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IMwECVDoKIbOm+ZnaqQYIT8Wlc2Wz+c+I0+C/aCiCyvtydaMzxDZBcMQdAx70IATTu/syMquJpmh2tO2RzAylW8ZpJjSwjikBqw1j+3IJglpmKoVwx56TbGKKXdGrKsCwUtsOsjd5AQViHZoZEy3n50QpZfpW8t9n6BxuY3NZ3jGgcYA1ner93MAiXesQxQMT1I70PqUurpmuscwWgKjXmifOD8cxbdD3f8/JDXmDE+mbUI942Rl1y/tsAcgkZyv2JINMHKYkREBMms4xXZP/hMSOFdH7Vfh0d76nZkuaHeXQNJXaDbwnBI1wxgM6AkmUpnCyouQQI9UL2iqXdQfQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P+9X97v8oLGLYonIialThNeDaSCMrIwHdgiUJqYKE3k=;
 b=EMn2rdquEdXwhPojWVn5hcL8ra4l+xRTE8BHjbq+lwIendrmsE6/EXckDuNsXFQRLwz3N2CfFnWU+7/nQCIi+zXpIp9nZ1IDfQtnwA4NlnpkfZqLLGNdIpCK8IO5jKPsPdZ95WVpAKMUhpDRXZkWzP4BMslY3TrJE6N/15b0t0OJSUCI5Ad2smLr7PA5976O7HxvUB9ioCBk9PXN+RzFZ1Sp0nvnEwjdtlOArLzUHIhTyny0QCukWuTEQ9sCVIZkDD1mbdaEgj6xMfvZhx8UzGYqNiNg44Oj8Xip0/XT7ArDCIJvX7QzBorVwWfWeTa0JQ81+tKJ9Kj75z6GtlRcEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P+9X97v8oLGLYonIialThNeDaSCMrIwHdgiUJqYKE3k=;
 b=nhbKvPhY3zZbmancTciemnBMGBAza5c7pKc0j6eifTa2WP8qU8naikMHyhtpd18m5Sfao2w7ewX+8acr/wJttUcGCa34bDu9skMM4VabRRi7f8fcxRlLNGbLlAx+LK03BM3Qq6e+cN4yYYO5AeM5xdUsfVp1Fb4DnjINLXCNiixlizKrrI7LDHeLZ0ZEmtlgTJcyUZoXrKsUL5h41cLLIISIf2oCo6WOvwF1BResx1evifK0O8sxI9fKwrpDE0glNGevHfaYd0mGZTnilKr4pyDn+Hg0niskKQ55ll1XsiyKwFOc7Q+khXwF87a8Av6KJSi78j8cj7PNvfJ9AzxGOA==
Received: from SJ2PR07CA0001.namprd07.prod.outlook.com (2603:10b6:a03:505::11)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.12; Sat, 13 Dec
 2025 04:47:19 +0000
Received: from CO1PEPF000066E9.namprd05.prod.outlook.com
 (2603:10b6:a03:505:cafe::3b) by SJ2PR07CA0001.outlook.office365.com
 (2603:10b6:a03:505::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.11 via Frontend Transport; Sat,
 13 Dec 2025 04:47:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1PEPF000066E9.mail.protection.outlook.com (10.167.249.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Sat, 13 Dec 2025 04:47:19 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 12 Dec
 2025 20:47:10 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 12 Dec 2025 20:47:09 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 12 Dec 2025 20:47:09 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>, <akpm@linux-foundation.org>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v2 2/3] mm: add stubs for PFNMAP memory failure registration functions
Date: Sat, 13 Dec 2025 04:47:07 +0000
Message-ID: <20251213044708.3610-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251213044708.3610-1-ankita@nvidia.com>
References: <20251213044708.3610-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066E9:EE_|MN2PR12MB4270:EE_
X-MS-Office365-Filtering-Correlation-Id: f9f51cf5-446f-48c9-4437-08de3a02b2ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?48KvNHV7ZU/jNiiuZMtW8FpeAXWbAg+8x4TqSVncfpjMVn/bay7eqXL+oDBL?=
 =?us-ascii?Q?LvGdr76BCU3GrIzXOwBVEOq92WHLVo78xK/IaCnPkLEzXTLyXGsxlHXueuK+?=
 =?us-ascii?Q?08TYA5AuYEUync70SR6oQQHp0E2MGtCCoakxq4atov7I9RfNQgLYqeJAlcEZ?=
 =?us-ascii?Q?UqgP4yQtY+UwKPqhioYOSEyze6Rx/jiI6S567ziB1YRcThKwnw7R48abXHha?=
 =?us-ascii?Q?iclcwYk8syoboEW3fgQ2j2G/6LCI7nh0P1a/9d+/FJlIZNWU9rkamzjHBcpV?=
 =?us-ascii?Q?lwJ/hz7ou7Hu3zYpFlko4DCy8Z2fzjEJC1FGCooveEcpPMTCHW+PvhRYhKGR?=
 =?us-ascii?Q?GgjMJopf9Nkewm1Ve2b2oskqqY6x2hH5DeziDMrtjeQlZ1tr/W4NuChlj+3H?=
 =?us-ascii?Q?Bb5FLpqZR93ykMSwbMNt3J6SVf8anmVKbS7F45J4ZXaVK5ugyQOzJGBozmW4?=
 =?us-ascii?Q?Cp5KJRHosGSWAe4KQnykOfyba2eXi8AIxGrR3NOAlXp5Bs8dGhMcuF/2rTHx?=
 =?us-ascii?Q?HEMe7SsMRaZpCQrau+hwm7SJNL1/O+HOnzqlqtIoToaMBYIWy75/lxNptTh0?=
 =?us-ascii?Q?GAVq9vMJr+VfTgEGfISztZl917fNmrGlXS+Tmorw3/ofxPn6gbdvtWsfpLyZ?=
 =?us-ascii?Q?+QsvO3NEJGNoVwk36Jjtz+NR2rZe3CQ/0OWT4Z2jgZnVfeEEq1htNSKA0HJg?=
 =?us-ascii?Q?jIiLgU5s00UT3hiUAQhvdEtAqFX7ElgE277ZT29GqrzFjOLUwBontOuJ5ZJ3?=
 =?us-ascii?Q?O5btG5sZjCjsJGAEfbtgCQXg0CsgdrnTvLOeIX0dm8IKvKj6BduWhTK1fdtA?=
 =?us-ascii?Q?fgOFycn2J3Ftp8ixtbQQ4Cvp6hq+S6KUoqFluKw1bFWhe2dFLmo1ocU06BF3?=
 =?us-ascii?Q?Slxu+aSnO10bIQvhebyyxJNKdro4OElmGNbtwEeFI0Gr04kFvhYP8isa9oWX?=
 =?us-ascii?Q?HzxIzkXIEgTpXI4AjM9PaXc2isG4nTMo9NtDboWPiypww9IxCNTzfBgGA5Qb?=
 =?us-ascii?Q?yPRQuI8MV4tPkYnJkCwFvhrQKNv1qA54aESgX/HO+yygsnwwPKMIbcn3+Cr3?=
 =?us-ascii?Q?MkxrZtkJeAnIXWQDM7BaxLRQX66vqOEzrg29eSFe9zfzN1AmsYgDK1rB6PJd?=
 =?us-ascii?Q?/vgjOvBWtOa0X40Q5LIcGGXfc5uJ9vfTqkAIplHEbHhkIWknBmMk9jKny3Vf?=
 =?us-ascii?Q?2uJvZo05uYJhjd0tP03ZXFcmCiGp1w4TqxrcXhSmKqQSuA0z9r/irU8Z/RFF?=
 =?us-ascii?Q?cJ+vyLEb+3mH+NcxMgykYmIxQ31vMEp0OWRfW5ANHvev3+bWNjiukX6SR8sK?=
 =?us-ascii?Q?JVawmFfyDJ/HxKTpSGbIEmWbbM5e0MEoNuN8JbmsuKVn5BqdxHLv2hUwVdRM?=
 =?us-ascii?Q?1Qbp6UMiB2lBJeAtOTnlswQ4zS3IW/MNcoUXb3OaLCj9YeK3skkPNCzRaSGA?=
 =?us-ascii?Q?IUoCvYLZGKxdN+Z70bz0O5pmw6BEO8uHTB4xzX62teJr4l2EyMHJoZzhuoXQ?=
 =?us-ascii?Q?TSQ04T6gzMNsjd5jtKdGbZqztiTj4ZECJuugyGNANS/+HYkuQNqckxT8ODtJ?=
 =?us-ascii?Q?nuM6sJw5RACJkgiQ1JW7/vdTV0cGUniK6+oSi/Pv?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2025 04:47:19.4222
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9f51cf5-446f-48c9-4437-08de3a02b2ab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 59D21180003
X-Stat-Signature: tamsyojrii7o5w1797ijs3kk7umndz8o
X-Rspam-User: 
X-HE-Tag: 1765601250-324668
X-HE-Meta: U2FsdGVkX1887fkRdC+J3f0shEUj4pc8AVKFBApW8sF897LA2afzgOYT70AiRV/9M7ZhrF2UGUJ2jJrxkMenXH5l5W6RN7LtDGCEUWD07KeSzGDUOzTdUhA8LgBvlwhadgLchzscefBN+zafkcEgTYqXTUs01Gh3anerl49awILIE+jhzry7Wcw5ekXTDHJaQ1VnrAkL+Ws8xac0uQW2GcGol/XKRHlvOICTIRb8b5VXElPAdJdK7M3yBlgtVFShItevuTWaPGsMp5UBQBwFaIEVgHu0XQkQYl0RakAYCZ3Ax7WmX0k4FegLRJVdBWNfWfyHnQHtKJtyN5+jI4llX4MEFac1qwQgbWv78i6JMZz0p9lja2YQZ7/9eK7zrbfdyQpfuCyp1QphDFFV3gCc+BRWaM64KcjM29Hg5L94U/Clc+RLRYJHn9008mQ3VeoRteAaDNY3Adt0BAmjEudeyAgyVV4UC0ZNQb53HIWpH2OMQvExoF22xJCzGZ2ZKmHXbxMWgaDbJinYtCz4zDkNfNFypGtyMXHZd2FnMoW6JcYQgXSfTIRpLSaJazG2CRia1NjS314hYGr/UX/W9qHx3KX5TGcH0ksyIZNuu9rx4GvH9xxPCCZOgGV5/CVkr35xGITOHRKyI4LQqJxdCh+gH3LpcmEroLOTIQKqencyVuM2gBMG9a2ZM2baVjNeXHnLVwar2bEYCEQRV8p2tW+ecGVnuKnkNen2PjBeaJjyRDiqmascvj+iXb810k6AXMVfXk4nxvX09pb3sekj0WOwDdh2EYfbBuT2hjFtcbT0GqG8y4v0PqlyzLOaciwDNHJvQ7bQyAwzvY7dXq41cPMSn8/xHK8p0OKKUM8IDXYZSDn3D080bCnE/X9I7uUxnE4vPjrJhj8ha4sVY5mUe+mmysPgYOdo2i7SnRywOr5BfZrDnNkxzw2QrvY/iGVZyF65fvgJMHmzbHurlPAWGEQ
 3HEXhtgB
 pq6eEu4m0sr3FwACPQCWhb9L662pPefeniFxzdj4QcJ91TxCXHmH+hdyDMDLex9BN+A8Dn63UIpMakHpJmJbCQPowLfXnLqbipQcLAuL7xXW/NJ/+c3xuWpLMpuqvj8aVIWtefLY+pgG9GCBeyRmxy1dxhLtP4N2JqFrdKzSQY13zHBz4Bb3KPxPXAHSHKBwqIGzRz5hOiaTLsjfgN+zGkOyCl8677FNd1xJ4Qq0Ot0gGwfLAdD7wNl/Rxcv3ebfsZKTvfDXgNtxbNup9FUTtnm5lF+Tqfu9Z8xoePBQFBD7LuQzWjFtCYkdz2EGsONtpHysR6+xSylICeC9gLCE3Av9O5qSOSivoV6sXutvB7glaroQ41OgHXzS5jVA8imC2XipsE/ewwkfayu9KF/Jy8IrF5zZPT7ZYagNS3T8SeU6Nb0oI8Pth7HN3Rec9io7OYbr8zYWg2MyI+uuDMsR61I/92g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ankit Agrawal <ankita@nvidia.com>

Add stubs to address CONFIG_MEMORY_FAILURE disabled.

Suggested-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 include/linux/memory-failure.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/memory-failure.h b/include/linux/memory-failure.h
index 7b5e11cf905f..d333dcdbeae7 100644
--- a/include/linux/memory-failure.h
+++ b/include/linux/memory-failure.h
@@ -4,8 +4,6 @@
 
 #include <linux/interval_tree.h>
 
-struct pfn_address_space;
-
 struct pfn_address_space {
 	struct interval_tree_node node;
 	struct address_space *mapping;
@@ -13,7 +11,18 @@ struct pfn_address_space {
 				unsigned long pfn, pgoff_t *pgoff);
 };
 
+#ifdef CONFIG_MEMORY_FAILURE
 int register_pfn_address_space(struct pfn_address_space *pfn_space);
 void unregister_pfn_address_space(struct pfn_address_space *pfn_space);
+#else
+static inline int register_pfn_address_space(struct pfn_address_space *pfn_space)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
+{
+}
+#endif /* CONFIG_MEMORY_FAILURE */
 
 #endif /* _LINUX_MEMORY_FAILURE_H */
-- 
2.34.1


