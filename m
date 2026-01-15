Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D98AFD46621
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:29:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ED326B00ED; Thu, 15 Jan 2026 15:29:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BB096B00F3; Thu, 15 Jan 2026 15:29:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 199626B00F6; Thu, 15 Jan 2026 15:29:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 047C96B00ED
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:29:21 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC0DDB9AA5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:29:20 +0000 (UTC)
X-FDA: 84335338080.10.10FF6AF
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012007.outbound.protection.outlook.com [52.101.43.7])
	by imf09.hostedemail.com (Postfix) with ESMTP id C021514000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:29:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RkpZ5xAE;
	spf=pass (imf09.hostedemail.com: domain of ankita@nvidia.com designates 52.101.43.7 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768508957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iP+J5W1eea5ocG7hIf+K/EsJXXePeB1JgZNrvWejgtw=;
	b=0Tct2agyNq5woCssPS932A9pxvHhJsnkamSf7VKyucdo9hjmJpC5bqg9hzL8U6UZjL2pQo
	Jm4e4PdGLmpwoJHfKy7pnw2PoEu32++6Pk8M3t8SQJmHJdzQFf9k0ITmRDXapF0L6Ses5G
	vTfHQbKnb6PbwYq0mwTUe+z46S0qcRo=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RkpZ5xAE;
	spf=pass (imf09.hostedemail.com: domain of ankita@nvidia.com designates 52.101.43.7 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768508958; a=rsa-sha256;
	cv=pass;
	b=09+HD2zaj9vYlKRdFJfjLJ4HmDYOatD/Z7dJOxZLe1fZcbsHhQdI8YUQsz53SXEN+2ImYZ
	hrWki8H8EsXKp2w1M6cuOKIUkCcwO85Un12W3t6CeDFCGnRaZPOzSciuFWglpadBIY5lfy
	fETZO6rHrYUvu/q3AlBxZcWBBxVTMKg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hQKJC7DT2YD8M74siC2JS/NVc5t6avwT5I70PoLpyEa+gDdiR1s8TQmRxqV6kuZEcOorh6wdyFg3uw/jJ5YS2Yhl8XORxoMWbBJduzeZVg4grR98L1BE9l6VTIg3V5D0X0aq25R3qxiUx+l2nib0/SfEmbLJYfgvvNCVWwQw9v2ecpk3l3ak7359M9f6i05lpAFZoe+iFOT1J2Q3T3nW0j9MHKNuWlpzfn9sLW37nGOP9XvRPPPKZluNXE7HQP1ugX3Z9AlB1vRSa1x73YA+AXb+MEE4Pu50YWOlUhoCDTuhdiEl0qHjtfdgHhNqVobPy+DQ+cTdRyXQrMWxqgLyhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iP+J5W1eea5ocG7hIf+K/EsJXXePeB1JgZNrvWejgtw=;
 b=j90HqbcJrrwIOsmARFuBglcku5GcMFT2cRRRCzeUy75/sHlX7KOFoQiu8SiqkoELofCRvBNBMQ/GEOl58/EWtW2F5DmBS5i5fENLNHTt0GyqGka/jaYk/Qx+n5jvLRbiDCI5SH+VHBAs+VjMT1M6kL7IxXoI+mZBJuZdPkEK2gYfPJh8dSCZgEugXEqW3xgDE70DuuLJ0/1CLinbbLsjjd4dfgzgBHztX0nYaEipeiAbt7z9aipCa32U8PuXFAXrZa+lYTMA55K2w4fT1SRD+SlQUlmY9LQ8COuUiSsm1v0q1rs40SX8xlVeTnfO9X38otnzZ8mw7cSLRSc6PeFN/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iP+J5W1eea5ocG7hIf+K/EsJXXePeB1JgZNrvWejgtw=;
 b=RkpZ5xAExXLfEHUNszHyq2K1TygSUjTeeW/+FtgRYt6yXP/qH2IWkFW4Q2LnhnH2dx043boa+tBnS3I78ZDvYguuLpmvDquthpuDoT/j5vvduZmp/YRQ37bNWW+qG2SCQqeZX0kbRhcze/5UttyeNQOgGewIsYPgTlqdtAQkfAaA6BASKRPwO8fF6rGgyx44cf/KbSVvhmKMfVcNC+1n6mo8u2l1iZveSMY45PTn/EecGl1qstFC/9j0vOjnrbg686ee7u0vB3/b/0wKtSRyarmDodosNYxKyuB6shsE2zjQdol9Itdsxilw9P9okmbfWDN20VU0pOanqJlyEeuSgw==
Received: from MN2PR02CA0018.namprd02.prod.outlook.com (2603:10b6:208:fc::31)
 by CY1PR12MB9697.namprd12.prod.outlook.com (2603:10b6:930:107::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Thu, 15 Jan
 2026 20:29:12 +0000
Received: from BL6PEPF00020E66.namprd04.prod.outlook.com
 (2603:10b6:208:fc:cafe::29) by MN2PR02CA0018.outlook.office365.com
 (2603:10b6:208:fc::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.6 via Frontend Transport; Thu,
 15 Jan 2026 20:29:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF00020E66.mail.protection.outlook.com (10.167.249.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Thu, 15 Jan 2026 20:29:11 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 15 Jan
 2026 12:28:51 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 15 Jan
 2026 12:28:50 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 15 Jan 2026 12:28:50 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>, <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v2 0/2] Register device memory for poison handling
Date: Thu, 15 Jan 2026 20:28:47 +0000
Message-ID: <20260115202849.2921-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E66:EE_|CY1PR12MB9697:EE_
X-MS-Office365-Filtering-Correlation-Id: ca295ede-7161-4a23-7ab0-08de5474be6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GCb8W3FS4oaqTROvONUzN6FLF0NhxChfjR1upsRxU6nfG+9zg0T3K+ItC1iI?=
 =?us-ascii?Q?+MSnqD15yVy7NfKD26qN3jI9xe7AHtC/gdtGJAojgd+Gp2MPAM+9zaLuG6FC?=
 =?us-ascii?Q?ozJvEy/b1ENV7PmtNAmKKCSgKKxfHCL20wuk5EALfzO9ssSkxB7U0Yww32aB?=
 =?us-ascii?Q?vzcOLOkEOKKx8VVPp5hdAK9GNwgA4MnsBWC5aXd93Sxa6sD/lM1xcvvrbzDR?=
 =?us-ascii?Q?58E5NeBFeIiHaM9/+QfC2hDfiRAUhQlyF6ioGzGnzqEk8+CQrVDgLG0vePKP?=
 =?us-ascii?Q?SV90pLP81dI5R41AcgsTadzf+FH+L0SGv3DlB+f3amqGZpOh61Gk5DKWA7mS?=
 =?us-ascii?Q?LZzIzmKbv0rf5WNMstMEDI9WWjnK11Ij9b4Wv21kw8YvLTMfGfI9MlckpCwS?=
 =?us-ascii?Q?fGBXCZzY2+mYgXTcCskMoiTsH9Ag4L0ZSfxr2ow3zgrksGIqv576xPf8Ht5/?=
 =?us-ascii?Q?uqqG7pjf/7LioqGTHvK5PBv1MpHfsreFcd+3Ui9VB/6rljuy9vQbqpS1RbAF?=
 =?us-ascii?Q?k/kk5P0M3SYlqmy/ej/xeyj+3WK22u9+mlmctSFYEuo3pLgb49C67NDkslRg?=
 =?us-ascii?Q?RZZCBxILvS2divObybTnxOumfafYrT1XGyOyCwqvvG3vUvWmJ1GqvcOhsJ32?=
 =?us-ascii?Q?ouxh7iln5jO26jIxPFg6mMSDASIlpY0h1i+hSz5l7Bs8z/5EEL1KoRSgx0gF?=
 =?us-ascii?Q?g4qVv7xjInvphzYadrwij0gwR1vjKcBEhBNJO6QSG9bFxkgbKpigNgm5YCvI?=
 =?us-ascii?Q?VY9WkFhuglhpKWcR7E/VYNgJlmm7waE4HPZVEpXQwr+ighSi84R9SNkKBNNF?=
 =?us-ascii?Q?efzMvQwiZNNRupKPA4ynA8RS3lTuMs1F56evjy0glXn7pXw0tw17dYRYMIgu?=
 =?us-ascii?Q?OSCENa0l6o3y11LImMheDj0/95Lscow+n+4hQU8T3QOCzrC0JOu4RWVWTjNQ?=
 =?us-ascii?Q?IxajaoQPVO0R30kXzqErqOZMnxVcfW5vksZ25ffvZffAV+U4hp5MLHs3f8cy?=
 =?us-ascii?Q?VCQrA8veaPlmwENp9VvTHkYBj8kL1BrYxjRo5SHPdFPBqZPdCt4fY4uHXE8x?=
 =?us-ascii?Q?FQaSZ3UDoQYNPB7RFkBHfw8rc60F9fOANJ+Xhsm22VUhonlAnGYtx6Oz5dR4?=
 =?us-ascii?Q?8QslDfiMSHq4t+CQldlRdfWgu+QKA98R33AVJ2Fhg3lh2SNRlBwKCnyVzo4h?=
 =?us-ascii?Q?EsVrDLR8fMgeqH3/hXZP2OWISnw1rFg14Pt0R7fx4YTXachE3OY/SGb66XPd?=
 =?us-ascii?Q?B6xpaqMOX42V24zaTXeH4AF8/dMNFkxJ4P2ToUehJRLXb/uoIVL7oz0OPPgR?=
 =?us-ascii?Q?M8eEUyf8D0NQ54w2OoMbs9nxcdyJl++v/0vDz41t9cgbcvVJiWw3jwZ4wruk?=
 =?us-ascii?Q?1b7usIj4tVIvRsx7dVwVIxciN1zPK0xonJmNOC5W6fiY201PhQFF6ZU9Uj3t?=
 =?us-ascii?Q?MKp8AF8pDy8IKm8jmuqPHF37gCqzvxYjDJxlIlErEHmOQerYNfWRAJDoA8AI?=
 =?us-ascii?Q?ttuOSKMrXujeU12Iy68jg3P6d5IkPCJGvwp6J7sGBIHECg6Uq9jnp1AygJLE?=
 =?us-ascii?Q?hEcRVlyNkcW+95/WRcKR0d83Y9aWtGcgzAoSwU7AwyOnyliyuk7+DO6AF8Ub?=
 =?us-ascii?Q?HWQqk4YaPsf6dTwLVZA6fF54cCEgQ+Wkyn4uv87Zl5smyBE8V4tPPCeGyffv?=
 =?us-ascii?Q?8mPUdQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 20:29:11.8063
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca295ede-7161-4a23-7ab0-08de5474be6b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E66.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9697
X-Rspamd-Queue-Id: C021514000B
X-Stat-Signature: dx5uzrhcksb5eosajzpbhkqko9wrgazz
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768508957-551941
X-HE-Meta: U2FsdGVkX1+ScUgU5EvSNhRm3czbpZ9EV5/MBeUR70MW2AKfIWcJ56T940/sOE8lAEvhg1BI6cj8pluidItXZiIvaesfE/gnDY020AWBlboaCQs8rhzZ+rqETIhlLb4v2aa2VjCSY7jc7gwzraUxtP1Jr6QP8Sjc/C4CICSNs2zI16ErbRL5Xsd72YAlw/LvHkIKUKcwGh7RN+R6CHtlc4Q30F/IoRTpcrmQKH43+g8FsO8mOmMLB5Du6+whiDGPFdE9cj9+BJupBOOqEnGj0dc1zD907D/5PRX7/ShPfg4d6lGNLUiY8u14RhT9mce0mrUBjlClum5OvFVEhAIF6OBjRkeFTtwK5It5QiiAWtTkQKQrg3yVpyOqJtVqr0z683qQe1s9JYd3sjM0nTCDFnb80xbuz72x1KWabUSkD3uYvUY/KsK2pKQNmotzimyYYXT06eis1HjIhiXcO/FpcBrNs960Pe6F1ZC+dPIpTs/rwUsuZiBsDAMFFLCxQsMxRToHxYKXOlKvf1/0j54S7QQX2xkKBL3cssEXOfTY9BKHBovX32bfzdJ3oZBocaL8OIaR2ULRvA4Kp64ThctQw7ParAv04YJeJdzFbaM3BJiYRSXjEVFbx6lkhYum5hErAbbYA2tUCxepEwhmhAhnN3gdefRHzhjjWY22lZlDIhkOxcfBzCK011LuFGpafKLZYu2ORRbc5ifgPdxRaxtpGr74AbvorMPrMnkLw3MHqvi0xWFITAPy2Aa2YAOSctCMRP2049DOULG6JzOvorVt4z5+zGEVCU9MvUtUTORWA6xr20JmwfkHZJj2EHBpkTCvLcZqjOrnSSwF0cKdJv3t7NfxmZfK/hbcW746dE9GGJX3dEfW1XXsolVFDurts2AAEF/5pdXtEWGDJMO5d0DZGGBD9lXRBnzfjvVz/DhWat5WYIGNiRo+ncMyw/tFWodZ8o3fS3FuqTTxgjYjvWT
 9NN9NTNH
 xKrrWD2kiHw85FrSad88FpXyzOk0kjATS77iXQcjTK5sjVCRlhLpQRhFPDhmffhcLGOBm/FTgOn5CmfO43qs7/EP016lsSEJN9CSHEOmZ74eNsWDDjrS4NFePhbxuAaEXddqIvdT5B/19aRy7ST9pL2McdrhVsPvP+9n7yDsaT/sxKdeWY9+R/FNa/4bE6fOgcvpeQ3dj8C5DFx5SLAYsy/GyywHE50FCDxshGbFEFbs5qtcmf6h5zdVabvrT+9JFRXScIgC8VwCedbTJ16xjdQ5lkW/scJQeqWJPzPc+dp9fagonMECoxyTWeHsUG/+CNVe1AK5E4UHlhpE/eT04sZaHuUoVXOjr4vVbSeOt/E9/T30F7uHLT9GiAaI8uMASLlArAj4FdgWRSoCcysBPq3GvQpw8V1YxIxeqeVHWIxza5HiHQlRixyP5bEumozXdvNh13YopNvn8JtJLHrUM3cVdAuLiaN5MViDqSPBjoXepZz8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ankit Agrawal <ankita@nvidia.com>

Linux MM provides interfaces to allow a driver to [un]register device
memory not backed by struct page for poison handling through
memory_failure.

The device memory on NVIDIA Grace based systems are not added to the
kernel and are not backed by struct pages. So nvgrace-gpu module
which manages the device memory can make use of these interfaces to
get the benefit of poison handling. Make nvgrace-gpu register the device
memory with the MM on open.

Moreover, the stubs are added to accommodate for CONFIG_MEMORY_FAILURE
being disabled.

Patch 1/2 introduces stubs for CONFIG_MEMORY_FAILURE disabled.
Patch 2/2 registers the device memory at the time of open instead of mmap.

Note that this is a reposting of an earlier series [1] which is partly
(patch 1/3) merged to v6.19-rc4. This one addresses the leftover patching.
Many thanks to Jason Gunthorpe (jgg@nvidia.com) and Alex Williamson
(alex@shazbot.org) for valuable suggestions.

Link: https://lore.kernel.org/all/20251213044708.3610-1-ankita@nvidia.com/ [1]

Changelog:
v2:
- Fixed nit to cleanup nvgrace_gpu_vfio_pci_register_pfn_range
  (Thanks Jiaqi Yan)
Link: https://lore.kernel.org/all/20260108153548.7386-1-ankita@nvidia.com/ [v1]

Ankit Agrawal (2):
  mm: add stubs for PFNMAP memory failure registration functions
  vfio/nvgrace-gpu: register device memory for poison handling

 drivers/vfio/pci/nvgrace-gpu/main.c | 113 +++++++++++++++++++++++++++-
 include/linux/memory-failure.h      |  13 +++-
 2 files changed, 120 insertions(+), 6 deletions(-)

-- 
2.34.1


