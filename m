Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 224F2CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 10:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787B28E0026; Tue, 21 Oct 2025 06:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EB778E0013; Tue, 21 Oct 2025 06:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58CD48E0026; Tue, 21 Oct 2025 06:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 425C28E0013
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:23:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1178C1DF5EA
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:23:54 +0000 (UTC)
X-FDA: 84021735588.10.A1D9A10
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010014.outbound.protection.outlook.com [52.101.201.14])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1800B8000D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:23:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OE9yzX6H;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ankita@nvidia.com designates 52.101.201.14 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761042231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9oKtb1iXwKRocnqdIx51ArX2eBBUyzUz7T8BWIx8k4Y=;
	b=hhNzakgASMgP6kcQFh4W2qIElarn/6K5pxVgSyrKhzN3i44PdED9eDgzaQ0i+keMYU+XBN
	agPtYljDOItWTgzXMP+kXFDSwaKue+DYSSNTydgSP1zjeTadubRqzyM9cgB1mmf1HVeOLl
	fBORbMMdUglz1OodCeQwe4tj1Yk2jEA=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OE9yzX6H;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ankita@nvidia.com designates 52.101.201.14 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761042231; a=rsa-sha256;
	cv=pass;
	b=QzqczWoczGcoWTTkdaeFYJOZgpbrib3ZFh55ZUilGtR/hc5cBwrCjTChqSmk9fIlgCVtv+
	nRsmIxHsqsnLovrPekhj/2x22IJyStbVb/Fpl7vthpfP3J4GrKAKc23l4W7vXmmKidfO2A
	3T0zJzGrleAK1X9rqnkcRMK+5EGiZ+E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tjUp9nhFTQjyOOsjhj3N9hNT+gmLTTLkcTMfwdpYiivMqy/eFf0qiiahdASaw7O+D04SCEJac+NZnyTzJ8mfm/FruGxmWKQYElldJTxz2lAqk2vO5jVxsvuxU5R9Z6BFxHm6kqGvvfuqvfPWCXxVFmJeSZtzswyFmuEqm+00/viSyUCJEBx/pBaWGuODsRcfrtwXBkEBIpsKnr0/CrEcNWFT2s3I8Bz7pID7OSpK35nd96+U+tb5nTGSLXSESd/cin2vBOwM7wNt1uFoXdBU0+G8sxHvZirSNePXV9KvoEFaNLL9yDZkpPwVhldSxBFWcFR4isvuenlzR7Ug5gSm2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9oKtb1iXwKRocnqdIx51ArX2eBBUyzUz7T8BWIx8k4Y=;
 b=Q6+S6407hRCKLGvcY8AhPujc3MvGJLqX9Ax+QovIxgqiShjxWqX+nu9m9Mjfbq3n/5HEklzqFGDa1ZeR0nUuE0o2IP5A0dmJnA3W2GoFX5nkH1X5AGhdz7bT4PJ+aG4KUddcPS20g3HNE6RfW1Xy+ZdGGe/GJjCRQTWQ61eC5VMB6Be66plkDlE4+LIPP/j4Jtjfd/IAR+enwpfA9WtGRRjNC95dkcJP6Y6hy0depEHhbbs3fZ1+GqJyEHd0iXGQ4/en5D9AOg03r/MQx7ccO5iQhNHp3bUCWx30LP2SPw1a7bBKdtOCW5ZnS7OiIzR5P7dSofk1yJbtsncA3MRXHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oKtb1iXwKRocnqdIx51ArX2eBBUyzUz7T8BWIx8k4Y=;
 b=OE9yzX6H45im90HomscAW9p0qFG5UYpFStdPJtdZLyI6u009Yqc9fx9LqbqVLt6Qn/DJzep46q/IU+m/IRCeUO/mcdrQZExdD+5+UUE+S9O1aJN4xLhNRghOztVSOm3GeFKrYo6ANB3IPiXcm0TuW5HY2VlXsP8BEbQO3VyPBsckmaB7zhglpMG+dlzaX5oUoChqUMvtM9w3wLSzinvGhMFbFX6qroyQINjvOHhcnMI6aK1EN56dXMTtyQvzRPSYik1u+zlP09MX2IMFD7/rBcy2oATph4wxI/V04HfACVaTZvZyHSKJxbMHY+TLFPqmMVqJnt2cayUY0L4M3Qw6DQ==
Received: from SA9PR13CA0017.namprd13.prod.outlook.com (2603:10b6:806:21::22)
 by DM4PR12MB6112.namprd12.prod.outlook.com (2603:10b6:8:aa::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.12; Tue, 21 Oct 2025 10:23:45 +0000
Received: from SA2PEPF00003F62.namprd04.prod.outlook.com
 (2603:10b6:806:21:cafe::f7) by SA9PR13CA0017.outlook.office365.com
 (2603:10b6:806:21::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.10 via Frontend Transport; Tue,
 21 Oct 2025 10:23:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SA2PEPF00003F62.mail.protection.outlook.com (10.167.248.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Tue, 21 Oct 2025 10:23:45 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 21 Oct
 2025 03:23:34 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 21 Oct 2025 03:23:33 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 21 Oct 2025 03:23:33 -0700
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
	<linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v3 3/3] vfio/nvgrace-gpu: register device memory for poison handling
Date: Tue, 21 Oct 2025 10:23:27 +0000
Message-ID: <20251021102327.199099-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251021102327.199099-1-ankita@nvidia.com>
References: <20251021102327.199099-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F62:EE_|DM4PR12MB6112:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cfb499c-64ff-4ed0-73e0-08de108beac8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j/dneHJWhhoGuK4Mckfd6RboyCWwshlGXcZY0aLGhS9KcX49qNSrgsdJYlBP?=
 =?us-ascii?Q?RGbh3e6mxJcF95/pCkGi98aRJ4UHdBk8KgFLcnplmH8f82zeQ+GXSPyiBqCc?=
 =?us-ascii?Q?2jA3UasyWJgfgMKS4iCqouIrB0ksCIZ/BJWud6YXWjBVDl1xFgZ2cPyCEs4r?=
 =?us-ascii?Q?Ai8kTHNsN/xNeOXasVG2wtfewTi8ZG2jOTcOtVeTxuaSRCoc1x9ciFWzn3ux?=
 =?us-ascii?Q?Q5tUIw7oLVQMbnSEB6X3jPzW5pS+a/PCmvElzJ4PI1GnQ87ubVjP7rf4RqZt?=
 =?us-ascii?Q?6sPPw2T57zq+9VAtZzKWYgrekIMVOs6coVJr4wKaNVyzweCoiqjMExtAxXcK?=
 =?us-ascii?Q?6OcL52GUvj4U6ToahOmDRy/iID7B+MNniWIM5c6xl3HNVcalabfXzY2WDd+A?=
 =?us-ascii?Q?clqJgTc4KbuADax/rnZC3MzISHfY79ucaJQh9+d6Q8zRGIIr0bjXxAsFXzV+?=
 =?us-ascii?Q?XE13m8zIhj9fpRm/sV4StI5SHhxA9iNf4+wRCFAuLd7T9ynvX0rd5Rlx4VFr?=
 =?us-ascii?Q?ghy5xWpCKHgfR4XWOAZXIm4XEbogmbqHpv7f6zXMmxKjnuHsLBHDI6mL2svO?=
 =?us-ascii?Q?o5h05jDVNfrZ27EK9qQrQxwRge2ZN1MgTQO7sDaWbBT0gRVXEenWULnlrbUO?=
 =?us-ascii?Q?klU2ZCMbIJiLE8sTr8miro78KuPRBDJDiKi1FyxAf0UfDNzEKvfVfeW4Lpyi?=
 =?us-ascii?Q?pKoJhFUNskR0Y5DI70ODBsH1xrN1ltdoS0lvXlgMP6e0m9DATHmA1ue9HYHH?=
 =?us-ascii?Q?Wabgu/Ea9EBnfMna1BbKnB0WYJ+3Ui79iNqgIfm9vZxX2yyMin548Sb6p7nx?=
 =?us-ascii?Q?WEEE1vHfqY6tzCffDPlggBQ8CGDELWFwnp1/b90uhvzqvmOpqr+xUU5cwR89?=
 =?us-ascii?Q?uQqBDZ5IPD1AqX+NIE0W6tTV3CaZm3CVXd7M2qsw0wH4sP/xgon4nDSx+zep?=
 =?us-ascii?Q?ekoNkIbW2ArOvuM3aHLGI+f3rPRncooPfdHtuwKVvB+ncy9XO3RNkUfhua5Y?=
 =?us-ascii?Q?awLVARu/lmKpvXTefKSevOvVCC17rW1CfJCEv+dQGTTouKVXuONVBpcP8TjN?=
 =?us-ascii?Q?w015zlo2xhcv7Xdk0bJYVSOhtvVPUtQpZPBwCXLCr2fUKJXMvvoKVGxNq4ju?=
 =?us-ascii?Q?IoB2R1PdXqd9TgCPzeBdSSwV2a2qTJK8/R7SWULMiixFdHb3yxwSC4bw2zfd?=
 =?us-ascii?Q?50XXsDIziiz1f49seCCL9p5kdsmPkN/snoQVCAQu9SZHhl9+hwUbSt8qqDfr?=
 =?us-ascii?Q?azAZXPEUu3BsocUb+7/+tNhZJVI8hPBKS/ab9ewbs2CzStGu/uSaarhYXINA?=
 =?us-ascii?Q?sN62vb/6sEcuz39ac55VG4eDYFcI0GE1Hg7haDaDIgQfYkuuex+LUe8eyQmo?=
 =?us-ascii?Q?H2i5ahNki3Fpk8Cjn9crpXK1DvyuKsCAQdo8Cx0wmoKJg/CtnGI8rLWvgB52?=
 =?us-ascii?Q?Ne7v3HwU9Zyf1kkRsQ+PvMlvG4zFHRV4WUcm7uWnIpUFe2faGO15gBxlcPGE?=
 =?us-ascii?Q?LhnI5Q/yyDuLW4lyR6cp5wDVAQaaTYpCFCRcM8G4FC5h43GTLUDATbjiuPMG?=
 =?us-ascii?Q?BU90w0Hf2KCEEdiT5kik4ogMTX6f7zak4egi7Fye?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 10:23:45.8158
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cfb499c-64ff-4ed0-73e0-08de108beac8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6112
X-Rspam-User: 
X-Rspamd-Queue-Id: 1800B8000D
X-Rspamd-Server: rspam03
X-Stat-Signature: gg8gp8j1uc7sq76bp9xajfd55yz3sjip
X-HE-Tag: 1761042230-512115
X-HE-Meta: U2FsdGVkX18EkRyvClSgiXOZERJlQ0MqzzOH2vle6AsBCs9vehYo3tCbrS4y263aZkY1OYSJmhKWpU2Ws8jzyFfDbjIE054YOH5v8NFTRaJMygF1bG7C7rPT4rWLea1Qw1/gg1tQArBTofwbF96J9dEFzhROT/qM0pziSVr2UCLTXP3bRrNzflCYaG4ORE86v5KyxSeL9v2SHzfFeQUkOlmc5AszU64n5cjLZZLZC4lUs4nBB3WwpP4OVXF46nibKAOXkvUJAAWi+c4TV4RsI3zYX6KXg4E2M6ISyByx/9cSMRigyZj+t2ALTwcq5kw76LVn0j92sKfOWNLSX4GtTFvmxCHELzWdQg4ZfGrCoNaDwiJTUxsYzVCwidcLUMip/RK87HvD8J1dUaQccSGaldhYgTmA9OfjUb2XN3PbvDnOTo0WUJ0S1YOvFVExyj1tyzq7Cg67zZXaik5C+DtKHZdCNGW/wHj4Yb2BPoMaic+SkN+UU2qChfFgZ+aFjVuL1uai2diLBFrAJ6Xgo4slyrcOxXr6uCef66YhVbUDi/kYL2I92nk2m2h/2edLVVWJOViWQ6z2GHjCKzkikQyd614VzAnDYIIcO8eUTxiivaVtqF2Q1kUuxp5ODTsP8pDAesD24MhcIdAvxnq2fRPXWCZsv0k16H9KLhWs2GnQBmzzWe4b3fgyCHQZqPnXb8+KS4JtZu03u12iuhRGSCACRlnABZmS8kr4G+N6BzN4dypX1LiJp5H2JogCmvnfGN9idWkSFizF7wYamx0+Lh2mD8DSBwBfbfiGxXA9inmPlSOZ2ziQ1UPRLBcCyLrkWKZrSsikjF/8G8aEX5k62oNrfr50gXb/mFUuFDPfcj6pcqlNzU51t1nZr2aMRwWcf4LYu7wH/q6RAfTgyYL5LyQTpBi+BETndAL4rPQ4vWXSCSEP5ma1FqSh9rZX2FzNEFO4jJ+61enMVJ+8ZAiBzNz
 VsHEJGkU
 OiE9zhkBErxM96Az0wN8YWbop8XV9x5L/a5Yl9Pb68V0vvuGEyzqTk8hWQIt9rq5oR/s8D3iQMA6CqzkzaO1/VJ4iuCkV8GJi9EMWeM6/ycWY2RhAlHNozWsLmtcwMkkRj+wQv1ADESktfLgwrM4ciRp9cASy/u5FZX1Lt1GVTJizMuRo4M/XVy7r0bcjy2fgSzbdE6BMbfYj1WnyRb2TotfE17CrKL+l7Hyc1YpP2URVP7TjmaoYEIx4TqCB6Lc2y6kHUc+GaeWuMri68MfJXxgLOuJzHt7lgYkbff5I3wFsyITza5Vb2Od/QQaZSpc4iasaivbnSg3AtHGbKGYxPwTQOE+nJnoG4x4cn+KfaJq3XieugAUOIFPyr2DFo2hXeGIwGSJssXvm7Xs4JoWA3QKniJaALZ5aXo29Cz242n9hRhE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ankit Agrawal <ankita@nvidia.com>

The nvgrace-gpu-vfio-pci module [1] maps the device memory to the user VA
(Qemu) using remap_pfn_range() without adding the memory to the kernel.
The device memory pages are not backed by struct page. Patches 1-2
implements the mechanism to handle ECC/poison on memory page without
struct page. This new mechanism is being used here.

The module registers its memory region and the address_space with the
kernel MM for ECC handling using the register_pfn_address_space()
registration API exposed by the kernel.

Link: https://lore.kernel.org/all/20240220115055.23546-1-ankita@nvidia.com/ [1]

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 45 ++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index d95761dcdd58..80b3ed63c682 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -8,6 +8,10 @@
 #include <linux/delay.h>
 #include <linux/jiffies.h>
 
+#ifdef CONFIG_MEMORY_FAILURE
+#include <linux/memory-failure.h>
+#endif
+
 /*
  * The device memory usable to the workloads running in the VM is cached
  * and showcased as a 64b device BAR (comprising of BAR4 and BAR5 region)
@@ -47,6 +51,9 @@ struct mem_region {
 		void *memaddr;
 		void __iomem *ioaddr;
 	};                      /* Base virtual address of the region */
+#ifdef CONFIG_MEMORY_FAILURE
+	struct pfn_address_space pfn_address_space;
+#endif
 };
 
 struct nvgrace_gpu_pci_core_device {
@@ -60,6 +67,28 @@ struct nvgrace_gpu_pci_core_device {
 	bool has_mig_hw_bug;
 };
 
+#ifdef CONFIG_MEMORY_FAILURE
+
+static int
+nvgrace_gpu_vfio_pci_register_pfn_range(struct mem_region *region,
+					struct vm_area_struct *vma)
+{
+	unsigned long nr_pages;
+	int ret = 0;
+
+	nr_pages = region->memlength >> PAGE_SHIFT;
+
+	region->pfn_address_space.node.start = vma->vm_pgoff;
+	region->pfn_address_space.node.last = vma->vm_pgoff + nr_pages - 1;
+	region->pfn_address_space.mapping = vma->vm_file->f_mapping;
+
+	ret = register_pfn_address_space(&region->pfn_address_space);
+
+	return ret;
+}
+
+#endif
+
 static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
 {
 	struct nvgrace_gpu_pci_core_device *nvdev =
@@ -127,6 +156,13 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
 
 	mutex_destroy(&nvdev->remap_lock);
 
+#ifdef CONFIG_MEMORY_FAILURE
+	if (nvdev->resmem.memlength)
+		unregister_pfn_address_space(&nvdev->resmem.pfn_address_space);
+
+	unregister_pfn_address_space(&nvdev->usemem.pfn_address_space);
+#endif
+
 	vfio_pci_core_close_device(core_vdev);
 }
 
@@ -202,7 +238,14 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
 
 	vma->vm_pgoff = start_pfn;
 
-	return 0;
+#ifdef CONFIG_MEMORY_FAILURE
+	if (nvdev->resmem.memlength && index == VFIO_PCI_BAR2_REGION_INDEX)
+		ret = nvgrace_gpu_vfio_pci_register_pfn_range(&nvdev->resmem, vma);
+	else if (index == VFIO_PCI_BAR4_REGION_INDEX)
+		ret = nvgrace_gpu_vfio_pci_register_pfn_range(&nvdev->usemem, vma);
+#endif
+
+	return ret;
 }
 
 static long
-- 
2.34.1


