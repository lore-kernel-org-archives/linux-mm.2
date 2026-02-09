Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A8DCEF070F
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 06:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 803916B009E; Mon,  9 Feb 2026 01:11:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78E5F6B009F; Mon,  9 Feb 2026 01:11:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62DD76B00A0; Mon,  9 Feb 2026 01:11:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 50B856B009E
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 01:11:42 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 131BB13B86C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:11:42 +0000 (UTC)
X-FDA: 84423896844.08.13F5790
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013043.outbound.protection.outlook.com [40.107.201.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0381E18000D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:11:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Wz8T8sR0;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.107.201.43 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770617499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VJTtTawA2Hmf4olaQXrPFzgodT38XQ6lbiOfeh8E2SQ=;
	b=zS6m+TPyd33Fmn8rWYgDbCuBsUTtTsujQNHTe7NxBIgreLs7r2r5FApi9G6Ei3d8Y1ILJT
	JkzSoQaNax09CMGIGen1W4ZGPJt0nkP/RCcD9+9cwDO0jwB8aZRSfDT/aFKtbjkyn8LD8g
	L6XVBUdFUQ2qgvN1lPBWrtQjFLSMjCg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770617499; a=rsa-sha256;
	cv=pass;
	b=xpnmJ/wMC9unSwC7cKXpTFlTLFmiBs0MjNVTt0NvtW0mpFkbnKygJBOWljSsKyHOhcAMYT
	zn/pU1z61iXIQNwf3Ut7j+dY+jim7JTL4kF2GVNT8T4eQ4Q/QJSrEIbAyapjFun5cYL2z/
	0XrkZw3O6/5SWvz/KxfSRO3xZZEilDo=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Wz8T8sR0;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.107.201.43 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uSwjouzobzZHhR+/yoimlW5oTQfgeZrxxfQuslJA/YQ1tCG5UKqZiTFtNp/Ya8X384IivZb8XRCdf+MnA6slaRz8FKyKh70ThcX8nj3GsygWTLbcLpWZ8Zpcw4X1R64QCFfvGh5DP0YdBcrNpB4RRwzBTZnxZcvHzNAjRQIu25ZE0P34B3qLFrLz+DOkUGxz54ETIixV0zQH9lZk1nOxgPJSZMUM8pEB/OpxFpKE9XrVa89rypsMG8spU+5ghMZrmnTbXn50ekfJPQG77tJMTZaXrqzg5itzT4w+a0ywETeS80I/Y6CxW0MlJZy4XIwdlsNJJn/x5kWzcKZHiMHEyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VJTtTawA2Hmf4olaQXrPFzgodT38XQ6lbiOfeh8E2SQ=;
 b=jgvk7RGJfotxjV2UwpzwR40YhvDdB7kHldOV6MRNzO/4B5Q4px9QP8/PEp8wCsMMM4GIrqgpfSNvpVMH4EszpCvAndBJBNfGq2HYkjUXstdVMvLBQycoA05zR75hNLaaXNS6eh3kaXQH127XyRcpA4clrkkE5bTvEaCJKZppmZoRXnOd15MDji2Sx/AmliBWgGK8y1j+RN3yES530P8zMF4/JH7v4dgui4a46YMefqQseXlT2WNoNXQe7nO9KP0bMN646rhpNspi1HnvbNmP3eqN+inUKGh+rLP+IY/53Q6mAS2VAPe/amBKGutNzM5/+sMsdyfl/mhxzczACPjSfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJTtTawA2Hmf4olaQXrPFzgodT38XQ6lbiOfeh8E2SQ=;
 b=Wz8T8sR0F2xjsN5eD2LZChNsUI7sL9uZsk32mOsPzv0tyxgaaSHAj3PGj3jYzdKkYKPt/TE8d9KxrWnJNqQlXTku8GczLzYEgbj6RTHLvl80MvuDiorieVY/HRHAsv8WqR0t91Ni/LMqxc/aj1S8k2QU4P84wZsd3/0Hwc3X99k=
Received: from PH5P222CA0011.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:34b::15)
 by DM3PR12MB9414.namprd12.prod.outlook.com (2603:10b6:0:47::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Mon, 9 Feb
 2026 06:11:31 +0000
Received: from SN1PEPF000397B3.namprd05.prod.outlook.com
 (2603:10b6:510:34b:cafe::f0) by PH5P222CA0011.outlook.office365.com
 (2603:10b6:510:34b::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.19 via Frontend Transport; Mon,
 9 Feb 2026 06:11:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000397B3.mail.protection.outlook.com (10.167.248.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Mon, 9 Feb 2026 06:11:30 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Feb
 2026 00:11:27 -0600
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Philip.Yang@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<akpm@linux-foundation.org>, <honghuan@amd.com>
Subject: [PATCH v4 8/8] drm/amdkfd: Wire up batch allocation in ioctl handler
Date: Mon, 9 Feb 2026 14:10:47 +0800
Message-ID: <20260209061047.3881808-9-honglei1.huang@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B3:EE_|DM3PR12MB9414:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cf27832-5857-4486-f938-08de67a21175
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bGowHUmHZeofYiJkV5M8MfsxKjrZyW8/AW/fpcjBiRQUt0bh+k1wu4YblJr0?=
 =?us-ascii?Q?+weZZ8Vw3xDJb47yW1rE0B7LIyI2+SBshAG9iwh6Non8kOPh/kkdGsbfqs/z?=
 =?us-ascii?Q?zUqzfIUhNbGFuuesgAoXWZWsPgL1pIEiR9oN2p0yr4bG27kRh6JU70cd6cCQ?=
 =?us-ascii?Q?fJzf4IvIzrrKVCwdguxJXa8YkdWNWYLQ6bKloS9gMEZ0Yb8HU+/wmedqvyUb?=
 =?us-ascii?Q?lN6QTHTMu0QZpdH4szSuRoMB8E827uo9xn5vXKgh+XH/rOs8gu//oRPG2wAc?=
 =?us-ascii?Q?TyiZq2PvN9O4EvucU5tacv3ZVie+MzjqVAtNTA7QGf5UfP/00SXR7jxDhYVV?=
 =?us-ascii?Q?bHU1/+RCD8A0Tnnaz+tPLtPIC/oI6kedLpp+LJJuFbjrsjJqOb59cQRLuNcH?=
 =?us-ascii?Q?JbAXZZJEsfO5nOa6cnSEF+iD0H27Ah8bqwkTxFWP78nPAyqnpkvDwR6aQJKl?=
 =?us-ascii?Q?6vuCLxy3GUi+FgIT18L7dl6czfFvqxD1b1MXAlHSyr4n+aiYnuizmzKwbeZw?=
 =?us-ascii?Q?IHS+nB5E+3ujblrGHFc28gEEAR+QLtvxCf/Vc3bgYDdW2B5i2MB4mDIni26B?=
 =?us-ascii?Q?lLeq5cDcwFaPdE8RqQgAMlM6FF66qbzs0w2m6X40tSLZxlwe5raQtfZoG3XH?=
 =?us-ascii?Q?iMOzhTSGHZ+3S2fKNYM+gn+tQTzfYDLsRO/rJ0zPJ29W6pb73KClMaA2/7fu?=
 =?us-ascii?Q?MUdyr0b7odTmPFR3IkON7dQEVHpFXWlBRLQRdRSmUSsaIKefydK2GhO6LuNA?=
 =?us-ascii?Q?9keJt2TceSwO8poaCl6Gyx6iQpFO9A1wOnVDyafIQAKFHMKd0ZI4OMws5fte?=
 =?us-ascii?Q?P+UWmA79NgoaU64cOKVUNxnnEcBpzi+CaIhcsLF3iFwdrCxsTeDAkdjmj5pi?=
 =?us-ascii?Q?g1moWxMPYHDXc0SGUymlnBVO4ZKZrvvm9wmvoqUGNivUOtdzuI1hE9wcjFnL?=
 =?us-ascii?Q?GhsOPmOrl5CkIXUpPGNJfIsKj9y69xxyEplCU0WpVGb1zgNWl6s+2/1jYtyL?=
 =?us-ascii?Q?qbIBReORjKgdv75/hNCgGW8oOHx2PWRl4O5RVLaTUAkFnYcRU570xOzAjNZn?=
 =?us-ascii?Q?aOdr7hQJ+TIhwhgjCXCf5TLos4QX9taX/NaY2MO7DYcVu1rurMpCapSTAVgX?=
 =?us-ascii?Q?02/bJWqe/XhLrf7Sv3tuazUKrIEHeHvNcJajxZwsWaVOR2FjdlztBSyKdfKj?=
 =?us-ascii?Q?y8T5WjNkLIj1//twmcYsZO0rMNjVZg2uTtE1RFn6/il952DKiN5l3NxYactu?=
 =?us-ascii?Q?JTXZ4+Yzc1ckHImGgU+8AR+dTk3l8TAj2KSJz6H3cmdDvRXJS9oI+gUqzA95?=
 =?us-ascii?Q?GTNfZtOfOec9NLFnTnX8WAn9UNJ8CnfLsdh/Zb1F7JoA6cOU7fBhLOFnhi0d?=
 =?us-ascii?Q?0L5rFI5datupiW4BvOfc0lqpU/414jre3/lObQMXVl2qgJeGMDNo9U7WslBr?=
 =?us-ascii?Q?X1viDkl/436rLoj5tcsMrWAmDQzTILz2CryPx1IlfiJ58/KbSjrWBM5iEhhv?=
 =?us-ascii?Q?39gMrE1+OXL1fxPn96K7c5H/B+7AE7QcaQ1qOkVVqxP4JEIE6Thilnw/TjLC?=
 =?us-ascii?Q?/UdYi4ZqMJILBOTXcLt0wdt9O1ijkHwArPNWp14yife5fvRq1F2ExuMd4FeK?=
 =?us-ascii?Q?zPLMSl3Fcw3LH/dQRutVeCoW4pkJRnb8uplqSngliLVZ2Azdq1Ncni5o1R2j?=
 =?us-ascii?Q?H+3jSw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ksEU1CkqiQCgMzq0NrLjKy27HUY4XVq8MfP/c2atcVp4DaNC0hvsU2PbI/Pa7x9GilSsStXDliHnntI4TC98ISfr6R7ndeNd9d6ZHZJo8qiArc7ZJ9r5DK+qQSD31rM7HHUaGs/p9GZEsrU3rFSUWMUcWxCeX/bIzN3BDx0Oh68wN06oIqF/y7R0kjQijSybErxbT7s4Bt+wAO47hEi7Iynis5BV5mz/+2sgKSg1t8lNN1w0RZhgUabl7bK6MZJmbAJ0TzxY6ouTZq312Ys1eLfOiUd6khjWHYOxfVXIjXKFWfzAagsjBWNcz6nqQrB531UpUvokMTSnH+pETjrhqaomb8B7i1lKzKunWtHjVuOnfc79dYlq7aErxWsJDjCGhtk6RLhIR+I6bqrTI+2ePqq9jktBhNEZjrqtjPV8ZXpI+2gCDQ+6MzzS2WMW5uNK
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 06:11:30.7861
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cf27832-5857-4486-f938-08de67a21175
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9414
X-Rspamd-Queue-Id: 0381E18000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8spsubzixqjpuajdqtnjwfjeoregbpjt
X-HE-Tag: 1770617498-298924
X-HE-Meta: U2FsdGVkX1+1EcI1+NG3WGW636r4jA3YCSqR0ZRccj8ZzYIWzeZ1ihdSQuv+ocoAQncwt3lk2OSijcDB4KEDpRCEx2eLAgzEzn65WP1A7Damde6BMzo8wU+CndhFsoGsPiV0ArTFHz9bSsMkxE8hDYsWd9p/O863jwHRac/EqUwRR71jwjGqfbYmF5o4xJ+GJROX32FIuisCOr6hp76OQk0sfVEiHg23omw5oLkKFPlPjgL3j64ABQKEnqLn4OObau9YISD/BKmzIGiNMV2SepqNGj3cHykRJnAAaYTQ1qfIeAZY8K8U8TFESYgTXzZhokgpADY0AuftrancoolLrvnTCT+9yYEWgJc/sgiE53oaXmCFnN+NLhHh4l0InPxn/4rEK9rzWXIqblevsJJqTiMAgDPh4DxXoEWsBYqg/qm86jctwb0dwsGR1QsZFJArnd50G6KpqyBfO9I8jftEGgqbV5UrMMGQBNa/6ZTEPX/NmfdBXjC8aYX21Gc+cTL4ja4ywmNjxQN4f9qqBI7IgvnN6u9LF5AnywV3GxElOrcsNZC6YVeRVwQ8UKie7YIih33CsgHHGEw18d0Ct1YzEjlChbM3YFmxa452lp0BtjtqIS/nhvKbM9gbq+fTKAYxUkoVbl8oSe7/SuwAnYUlSjNHUEDkmES6M18Pkq1Gtx8rPT4Xg83XaVGn6c01aGOkug4WxM85dAsh0S+ltt3eGqKfv5rQ/D/vOZFFYx3HwRus4bMlYyoPnaHmFbHWeLkYTNHUM8ZvZTV8jUSS1BAPnPM+5pREETcr5kOs1Sbc1GvDGfOR9gw7SFTlAzxb2F1r6VtkQeml5sPAembM76f4AypmZdZd90iuLVdwSCtnAAjq6vKjIQSVOUucaNOo+CIG3KXjRMQ7qFSDYE6eqYWTQIpSUGgvrhvRSlJgaKF/hu6FlaMxfXOhmmxIxDfPx1mlS0ZzxQdkfXup8ySIgrG
 CcyvEjzA
 j7GtPzCmVG58smcESAr9C45wt8fdxqtVsj4Omgj6pgO3NHltkWTcIkBhKAst41Vtqe+YTN317SOyb2uAZ9ACSldwXef3HO6wIOjGIeFBEkfDewl6/TTSV0l2vMEPUSgtBr+7GzT1/T8TT+nc/d4XTbchQR412NpTl+qU/UuF4PRobz5dWRwwHPENcAKpnoceeDMso/Ga4uKqRtEW82KjumWQwShuNVsnIrWcqLT+gmtKQdycCxd//6aTsfBYlROVPfb+5sSjYNQi9iXCH/QrlfeF+GvqQQaP3wlFSK8zttw7hN+E3WbkXU1nNoAgttJy+Npd7HfY09WpW7wP6cRQUwwViAbtdNkjxWyXc/wrjvoK198k50E3lCUIZGgCt4vTgbnxPXnmB17xHS04ZhWP8LdlKfBl8fePYyDsqRa4ByfUCWyYd16BbiJOcZvv8HnHF1Vb3hA8GMb9eCo6meChWIEl/HyyMWhiOSIrVffQH07lQTfQCUZ/BisppEuemlx8vM4yR6iTlOdwj9JXkq9JjQg1kdTMCbs/29vCXpyysO8I2xEKjQffi0M9ZbiXv5jXWwu7c
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


