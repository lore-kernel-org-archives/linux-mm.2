Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C47E6EF070A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 06:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE31F6B0092; Mon,  9 Feb 2026 01:11:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A990C6B0093; Mon,  9 Feb 2026 01:11:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 991FE6B0096; Mon,  9 Feb 2026 01:11:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 88B686B0092
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 01:11:15 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3DD5ED60BB
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:11:15 +0000 (UTC)
X-FDA: 84423895710.11.655217E
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013058.outbound.protection.outlook.com [40.93.201.58])
	by imf15.hostedemail.com (Postfix) with ESMTP id 51608A000B
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:11:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=m097PCDZ;
	spf=pass (imf15.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.93.201.58 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770617472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZShbmeMlslXZ/K+6rnpVyS8Q4bnNNBaJoaALjABXPG8=;
	b=WcY4sutsHcR84Lz5RNZ7DTd9eWVXZENMboI7gSzPzJvlsMoXvZfrfI7WhUBFMcZH3AEeK6
	KLifc/iZ2OnwcDFKxFtxalGKhRT22GajKeUcydRX6KYb60NIHn6vAnmD1IhWMI8h4U3mg7
	vQ9suNGiNkBtbgEl3SlbR+fBUcYIYQ4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=m097PCDZ;
	spf=pass (imf15.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.93.201.58 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770617472; a=rsa-sha256;
	cv=pass;
	b=eICtZ8OeiY4xl8Sw7bvPgM7IdUi5zR/L4cNISrO7tCvcDxfthdJlbvRb9laSzPsc78IhJh
	GA19dAEuS/8a/I9F13YsNR6muyEoH9NE2ms0PMdh5hQ7Q/rrUI46qV3PdSYPaZafzCvJ5r
	W9S1exPskrQkQWZQY91sV5TMG1OGnqE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PbcbxRjzycp/sPFNWc9GXBSlkCdIU/mt/S6uCTNrXVbqmNMaJ6SwV+2EIYdh9ujrxWTsXJByQTeDfdvvBJJS7kJZhuJ5FfyMfZCUc/7Ev6B0MDQdx8L3MnPwHN7rkoLlVs4p44SffJXfS+mYS57R5phRieJJOP7LazUihBDnS/4VtSbMOrX9ZxqRdeHCf5cYKOL5QPgBfNMMFNsVKQ4bUPy8WYAJDWByEZjEmOFzzNG9XBvOYTL69FP9sSr8zkp2iN7bJVe3arEZF3SHd5xPv6UuTf4kv86ygKguCgzkq0bVlN/T400yjZuwf88DT/apKkzhelRJOw6B5OcVLXs4fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZShbmeMlslXZ/K+6rnpVyS8Q4bnNNBaJoaALjABXPG8=;
 b=g1AglrtKfW47CQjG65qMD6mvofnE9sX1EbVXS1pA8zqRf/DavbBqrBzqGvJNkwxUi7n0KlEyIgsN4hoXQ7hgHMuT3efDumBd5NF+UT38euGjUjwVQ1Cteaa90z8ETHfUyp8QsWbzOnPNpLwLVorV/GLNonZ/1ozAq/DM6kZnbXabMG1Y6PaN/6ZtrKi+gbk5EhETgHiUJDYM2OkjMfj/vNSRuoDKdP9l6E4oGFNygiKKaHBS9HP9iuoO1j9GTKDuFLcq9swRuSUYB4uV3grLOTS2ijiDqKr/Vcdo3rE9JbDmdIJTQY43kym4egmx/AQ/lWOwzgvgutS1rPo4JcPuSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZShbmeMlslXZ/K+6rnpVyS8Q4bnNNBaJoaALjABXPG8=;
 b=m097PCDZyUpqUCbtCr6OjhtahJlegTApr/auwvgTsBYu62QEpPfTMLUI0NLySwrjKN2KC/DqLofFNu7tfPnv01iUM5jByMRrvJV+bu0qBfuxdc1O/Pv6+m8HaTQtC1OxbeHZ6SXLcHfwmoq5qsGpAXKQjDBp/I9nkIYwEGy0g18=
Received: from PH8PR02CA0025.namprd02.prod.outlook.com (2603:10b6:510:2da::15)
 by DS0PR12MB8575.namprd12.prod.outlook.com (2603:10b6:8:164::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13; Mon, 9 Feb
 2026 06:11:04 +0000
Received: from SN1PEPF000397AE.namprd05.prod.outlook.com
 (2603:10b6:510:2da:cafe::de) by PH8PR02CA0025.outlook.office365.com
 (2603:10b6:510:2da::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.19 via Frontend Transport; Mon,
 9 Feb 2026 06:11:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000397AE.mail.protection.outlook.com (10.167.248.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Mon, 9 Feb 2026 06:11:03 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Feb
 2026 00:10:59 -0600
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Philip.Yang@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<akpm@linux-foundation.org>, <honghuan@amd.com>
Subject: [PATCH v4 0/8] drm/amdkfd: Add batch userptr allocation support
Date: Mon, 9 Feb 2026 14:10:39 +0800
Message-ID: <20260209061047.3881808-1-honglei1.huang@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397AE:EE_|DS0PR12MB8575:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e20386a-7c54-4661-d8b4-08de67a2015f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vx/5Cjtiwf+/M6dga9rdRszfe4hcCCoKt/TOzLQGMEONijSjJ9fX16pCVWNB?=
 =?us-ascii?Q?uIe1dVmzNIqFR8KPN4fVA5as3Q+mleVpkw5XbU+0iwVFftvbe0uWNzIctV7S?=
 =?us-ascii?Q?OeGe2iybu9MKxhPGX8dATY6/RzQQfVX/LNpVjSfo5TdTvV84B3qhVWQncOgk?=
 =?us-ascii?Q?rlg1XLeHLnYmfiWu6O4CP/GtIbrFS07Mz+BH6JK8YWB1oO7zCuqo8BjZ127o?=
 =?us-ascii?Q?FvKyyPVaCoTxXDJWawIs06lFDyVi/DYIAMAYEvONgWzYrgFugaHWbUAnBisz?=
 =?us-ascii?Q?YnAlUgv2NPah0abVbIIb2FlSToIrhruEcoN4flBbeCOC2IdUcXAWd+idzXSf?=
 =?us-ascii?Q?gl39zi/dYUSGbepDlP8O9S78pSCdgA+wbCdVxNPMdZXar37f5TY3+3j2cC78?=
 =?us-ascii?Q?Uly+J6drlU67Jetk14ETVPnnasqTlSmVrqMafZp3z39Ho7WZkCWNx7dVlijI?=
 =?us-ascii?Q?GYFAjk0wlNNB/EQe9ZYeqPoL/ZVQz9c7iKGK+JAf3I2nhdmp91NFpeF38rdS?=
 =?us-ascii?Q?nnuDahCtCOx2JGFgzqknwVRbnvXSkAmbZQFN6TgxIpXVRV9CCKcDXSz30slJ?=
 =?us-ascii?Q?cFzcUcPdSIJ/+hNEqbfHpCMmF0p9n4n+OypyVPKK3CpbqgjzITaVyxiO65EK?=
 =?us-ascii?Q?5rwfpFbO2GnkZGBsjWewsOS1jtkuK3S+i5fNedl8hOm1+0w5WWrmYJsBkjml?=
 =?us-ascii?Q?BGpsyT0KdVvvn87Z3qT8LsEIeJ/pVYW+jGwxBB4YM4BLjpYEBdTsrrvI0lDy?=
 =?us-ascii?Q?tfViN5M3EKS2Lc9B5e5VHNzjfVvTNEEs+ljQ4ppuazMUxzrjwnGI2aCkGqFK?=
 =?us-ascii?Q?CX4vEbiqWtRlzl8LW8JbXqZIiUdwaFrNJHNRRcFXuQ7J2+IaNoqv7FLVJa3H?=
 =?us-ascii?Q?/sAn0UIZ9GnczRS2FUp+OmGVKf7gapkPu48OUuLpQ+HDjBpJTSaAv6T8HGex?=
 =?us-ascii?Q?hrisUn/wg+noFRAnC7jlNDoDhZLkh1tUevB5tY7gvIB3Hw7EmjXGdEh0Ti/k?=
 =?us-ascii?Q?3biZTzSKMYr++gpQGkv1WuEQFtExQZspyYDXpPXcBkW6WiwvB5FzV9eKsCZm?=
 =?us-ascii?Q?nocTfj8Od7OHOok/wUXOFPW3eO6Q+7u+mw2dS+WF0ZXYgi9CnhSK83jyUGiU?=
 =?us-ascii?Q?XxqLJQtX+5eCIuwEeGTH00waENsu/iMouKY8WpD9QGsHHd54ZvkseKi+HYvC?=
 =?us-ascii?Q?7v+amJAFYzS7kcgZb5oodOWM3QSbPPoAy+u6JxFSmvXI4UN5BBUbyD8gHGcV?=
 =?us-ascii?Q?aSikLz7nRRcBlpm/vs+D4KkvXWcQgZSvEt6i/P6s9gP7KnzkC/CznP1xRRKE?=
 =?us-ascii?Q?XB8aKKfyFAX1UvS5TB+JD/73KePh9mMoThHZoKo3BrLzyfqx8OdqDqEU54il?=
 =?us-ascii?Q?mgwud4LK2i2x0XsES8UYQfk20iMsQe+zOJeyuhi/N19DDfDOZuhFR5/Ioaf3?=
 =?us-ascii?Q?i9BBOEtWuXuKP7mscaszKtUCtJR8e+ZgLA/xWSfRO1ng10k3XJ/9ejS3BveA?=
 =?us-ascii?Q?2akt8CJAgvR2RQg/uzTulPLU+u7Y1ln0mC6PJiLQKGXnpFVN/EWnTtVlW5B5?=
 =?us-ascii?Q?Zx9RoC1BLz/fSMZXy8hWat4NIfxikKeOUQTBJciD57XJ/9edh34GKPDaeUSN?=
 =?us-ascii?Q?j5FL1Qy1SLfdhIpls8ttDasgbNCr98kmwyqVtcLfwicRGTZtcpO1DsMkjLN7?=
 =?us-ascii?Q?hOfo6g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gckxkxK4yBgUqLQ7CwNkgV7cUN/4gk6LRveft+geLJZe5f0ntJybiHKqRMPUKbjUZ1nOU7hB8zhJf/dozkdTkBSKZG5x0IPhs58bFGDpO+S2ZkE/XAgLooSP9ZQjjdK0A8oJN1CkvxDf3EnP78UqzVgPuEuFl/w2uAIKAspTor5SQ3L1WuoRGy9ZSvyIn3SjEdDLs4x6r5onS9kFFe5XTUXqlY7jW2XgVnqS0TqkE/ogC5o1AlEDITbqrt1u/h+akcPwr2zYrzFvtqPdRgk4dhExHJO1Ye4wG4dpumcIU28Ug2jyBe8dg0pyPmqBuhFq6mNUlqJwDB5g81Je/wSWUgVDpPMfS50O76qq1nnyDQZRr/4yUBcUzpg7Bho/J5+mTRtLZGW/4W/uXNpXrNlTLDZqP2rtq9miA9TSvd9XV73HfDK65NJz1aDNjSQpYPLE
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 06:11:03.7927
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e20386a-7c54-4661-d8b4-08de67a2015f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397AE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8575
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 51608A000B
X-Stat-Signature: wwob5jtregg3xgszcbfg1gm4fxuqt61o
X-Rspam-User: 
X-HE-Tag: 1770617472-964657
X-HE-Meta: U2FsdGVkX19D/mJDEiFGFjZeHxQPRSZdRmRlb6Y1n1UQMVWju8YaDHva2cmeBsdqegk0pbYwKXWzUUg91/isNMXfq+8vGw+/86WwDJzb3ty4ZQroKqnN4UjrprFvTiokrnmsa0M7pzL2FoAVLeOTxz8JLXlY3rbjqUqbdOQChEtTgrF87zFXtRiuofd6xW7UEITVTodMUMdApsaRxJsUYlSCd3gWeBvkHI/Lw2sd/xDmEcwSIQoPCSmbGYq9Ch22K4JtBcxUcu8ZRXdszZHgDu0de2ccPZZzrxKzkkvVNjSfnsOexnGdkMo4HzgO5KPSmMgJx06bINTtdNt7FdFVBxtA/6EEQ1YJqwR4y7tsUejn24pVD8gNoMvuSFFkxkvnZLoyFW1ytZqKMHh2h5b32OnE/fJR/hXdXNJMv1bU564uC3b7hYiQ1CkyT7DM7KgjfhmtyWqA1pWQPR0PJGfVEe6Wbpwf9vrZwAEtYrdk3pOS0uTFiD7Ke+U+ZqAlkMhAkOAEzAXNoFrrB8ntQcEWz0aLgiTIBnhS9Tb++WTEXl2NVanP+wyENXmJw4v3rVyXmeZBeEjk5CX/aeRJAIljhGBt0UibmaHRMIlvPEe70XpzuQbpcvClHcv3DkMJ3/hOFM6xaiF6PvwZc1eoektn0tZWVVDh0jLfm3giJD6ee7aWUTJDHJYhwfqDFHKUAqa1ONg3efPGgvXtjWSfO8N6co8ahps50wupIlYKJ8aY2tFV2KAMaTr5x9b4y3mAHt9yyxp/BHdkuehy7bftI1VYxSIjjhfikzXMrqjtT6yboEi2y5blmMbr8yPSNKzq2bWrcc7bBcVLHxUGdonM4GifGvXEsLmZJMexqQq6Nc74WFnVoQSxhVWOG8/LycN0vHQm0WoFaR61W92z50LcO2tn2igfEYEBFgTy2Jli89LmRI1LEnSzO6uA+4E81c/YbzWtsT4J4KWS77v4hUiHfk3
 +pzgnFun
 IAKvSIe4tLSOmNVytJpTsU5Yzpt/5c/NRTD6ccCNf3lpKiT8U3tyvofzokpljLoihanc72oovY1sF7hVRZHDZwWtkIXDF587MQe7DiWufnLeRVOWUuP3R5/IUiJ/e+4FYrNqVwkzn3SSaU4MEfereewP89DF83jn1Rig4RjMk11cOjE1O9KpX0aZRq2vXwHyFsC4QsueeQ4OxbKoM/XLxvTY6RLVU184MYHn9ksrIDXacwNda7pwUi6NlmarxXCLzGMBdTtZDhM9pd/05YiTdnDz6W8lPzdrs+yunGM7fMtMxNM2beoE1/zhtAsGlKLyvu3H6Ixrbt8Zh5ctJ6M1fntJ+kHduBTqEE15Z+FRGz0Wkp4GHQCHWOoxgFWWPoFTLzb2XJbiUhWqvFpFwaQ715BBBNYZIGqTQHlh+ZTBOYuoVgkcsT4iNLViHGYAOQ62XTZOqzF2PjeHNhKM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Honglei Huang <honghuan@amd.com>

Hi all,

This is v4 of the patch series to support allocating multiple non-contiguous
CPU virtual address ranges that map to a single contiguous GPU virtual address.

v4:
1. Fixed hmm_range.notifier_seq limitation: add per-range 'valid' flag
   - Use explicit 'valid' flag instead of notifier seq in user_range_info
     to track whether each range's pages are valid or have been invalidated

2. Fixed mmap_read_lock usage: hold mmap_read_lock across entire batch
   page fault operation instead of per-range locking
   - Renamed get_user_pages_batch() to get_user_pages_batch_locked()
   - Caller now holds mmap_read_lock for entire batch operation

3. Improved error handling: Better cleanup paths and error messages

v3:
1. No new ioctl: Reuses existing AMDKFD_IOC_ALLOC_MEMORY_OF_GPU
   - Adds only one flag: KFD_IOC_ALLOC_MEM_FLAGS_USERPTR_BATCH
   - When flag is set, mmap_offset field points to range array
   - Minimal API surface change

2. Improved MMU notifier handling:
   - Single mmu_interval_notifier covering the VA span [va_min, va_max]
   - Interval tree for efficient lookup of affected ranges during invalidation
   - Avoids per-range notifier overhead mentioned in v2 review

3. Better code organization: Split into 8 focused patches for easier review

v2:
   - Each CPU VA range gets its own mmu_interval_notifier for invalidation
   - All ranges validated together and mapped to contiguous GPU VA
   - Single kgd_mem object with array of user_range_info structures
   - Unified eviction/restore path for all ranges in a batch

Current Implementation Approach
===============================

This series implements a practical solution within existing kernel constraints:

1. Single MMU notifier for VA span: Register one notifier covering the
   entire range from lowest to highest address in the batch

2. Interval tree filtering: Use interval tree to efficiently identify
   which specific ranges are affected during invalidation callbacks,
   avoiding unnecessary processing for unrelated address changes

3. Unified eviction/restore: All ranges in a batch share eviction and
   restore paths, maintaining consistency with existing userptr handling

Patch Series Overview
=====================

Patch 1/8: Add userptr batch allocation UAPI structures
    - KFD_IOC_ALLOC_MEM_FLAGS_USERPTR_BATCH flag
    - kfd_ioctl_userptr_range and kfd_ioctl_userptr_ranges_data structures

Patch 2/8: Add user_range_info infrastructure to kgd_mem
    - user_range_info structure for per-range tracking
    - Fields for batch allocation in kgd_mem

Patch 3/8: Implement interval tree for userptr ranges
    - Interval tree for efficient range lookup during invalidation
    - mark_invalid_ranges() function

Patch 4/8: Add batch MMU notifier support
    - Single notifier for entire VA span
    - Invalidation callback using interval tree filtering

Patch 5/8: Implement batch userptr page management
    - get_user_pages_batch_locked() and set_user_pages_batch()
    - Per-range page array management

Patch 6/8: Add batch allocation function and export API
    - init_user_pages_batch() main initialization
    - amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu_batch() entry point

Patch 7/8: Unify userptr cleanup and update paths
    - Shared eviction/restore handling for batch allocations
    - Integration with existing userptr validation flows

Patch 8/8: Wire up batch allocation in ioctl handler
    - Input validation and range array parsing
    - Integration with existing alloc_memory_of_gpu path

Testing
=======

- Multiple scattered malloc() allocations (2-4000+ ranges)
- Various allocation sizes (4KB to 1G+ per range)
- Memory pressure scenarios and eviction/restore cycles
- OpenCL CTS and HIP catch tests in KVM guest environment
- AI workloads: Stable Diffusion, ComfyUI in virtualized environments
- Small LLM inference (3B-7B models)
- Benchmark score: 160,000 - 190,000 (80%-95% of bare metal)
- Performance improvement: 2x-2.4x faster than userspace approach

Thank you for your review and feedback.

Best regards,
Honglei Huang

Honglei Huang (8):
  drm/amdkfd: Add userptr batch allocation UAPI structures
  drm/amdkfd: Add user_range_info infrastructure to kgd_mem
  drm/amdkfd: Implement interval tree for userptr ranges
  drm/amdkfd: Add batch MMU notifier support
  drm/amdkfd: Implement batch userptr page management
  drm/amdkfd: Add batch allocation function and export API
  drm/amdkfd: Unify userptr cleanup and update paths
  drm/amdkfd: Wire up batch allocation in ioctl handler

 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h    |  23 +
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 559 +++++++++++++++++-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c      | 128 +++-
 include/uapi/linux/kfd_ioctl.h                |  31 +-
 4 files changed, 717 insertions(+), 24 deletions(-)

-- 
2.34.1


