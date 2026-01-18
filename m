Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73DDCC9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 19:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3130F6B00B2; Sun, 18 Jan 2026 14:17:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EA3B6B00B3; Sun, 18 Jan 2026 14:17:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E9796B00B4; Sun, 18 Jan 2026 14:17:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B01F6B00B2
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:17:19 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 57B405971D
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:17:18 +0000 (UTC)
X-FDA: 84346042956.30.DB23697
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012061.outbound.protection.outlook.com [52.101.48.61])
	by imf30.hostedemail.com (Postfix) with ESMTP id E56B180007
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 19:17:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=HX52BKQw;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of shivankg@amd.com designates 52.101.48.61 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768763835; a=rsa-sha256;
	cv=pass;
	b=Kv7mqUd/VN0UdWWSi6Pjgjy4p+U0PaOfPJYgbA8LVFkyBZOmZQ9P2FHf+QAcHkxXMesqPZ
	gtNCrPzvYDLIvp9an2aTnSw1dj+IbcO4wIElwGSfhlOPd0f/rcYHQs5CIYCqpSEAzSgVVT
	/yiQ/gxoFLuNBH75lTYO2vnV/GJPEqc=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=HX52BKQw;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of shivankg@amd.com designates 52.101.48.61 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768763835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7UFEs0I6TT7LB1ebYKv1vwH+cPwBdP8GtI27w0PDSwA=;
	b=sXw7+bNb9KEXZNI6aHMg6TZZtZcy8qLxjHJB1ISaEy+K5xrdeiDe/NJ3ifJhUBkGahhl5T
	Gsn8TWh/nBUgTMv0ON5itDzup0y1sRrC8sLWKNp6SGfcNlsCPBjmQHhp6Bpt9DN2c9chv+
	d99bx2Ss34s5v4KGZdXaAEvdRMBKRpc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=optHCQ+MvsuNBRDSCaSfk5nftPudeGr5mag71s7zmHShU+tXr0uOh3gX87yNc66S6WNiP09iRizS1ttpnQysfdUxFov1glKpjKNyrGIPe01eGNknCmsWTmVXtZWuCCj7GwLiP1MX4K0+iiXCFm2QsRpnZaN8FgXVlg6NRPhaCg3bUt5XQ+WO4+YJICQ+/gvXXelyTrVH1TlJoz+iiB/LR9PiG2i+2OAiN1IBE4pIM3ajyG/9WXtQJJoCrLqc9s9i1bGobe8gjHIIN9f/4y7AzcRBeI3veZio4q+409koHxsvi8kPmn4oM4u4f42X+4tMna7S+jFfIRDK7ledBR8F/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7UFEs0I6TT7LB1ebYKv1vwH+cPwBdP8GtI27w0PDSwA=;
 b=iqmja8dGLHMx8R6xEGKkFrlzhZN5Whdg0S7qUeNg/p/5xSkrTeJmQQqxAZMWyc11MgCr++s6EWbb0KfOXtM5Y0LN+XesPfBW2X3RcFaoQz+Bll/ONCI8x6XBZL3RjwLkF6pI3WQRVk70p07Il2GRcsk2AsvSCO4l7vDzoZdU7kzyt1hSlXofw8bxVpB8z9E2hR3i2llb16c4NKAMCUQ+6t7fAOW7qgrN5k5XTHG0D6r8b9Cjesum73e8WeKTXR/Mt1cogsnDieKWm7KaZz6pOhDaGs9zM9/hg0ifVKmlkzL5555ykAbY28FiGvsDjUZgbwxrmM6Acu1lr577ZNmuJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7UFEs0I6TT7LB1ebYKv1vwH+cPwBdP8GtI27w0PDSwA=;
 b=HX52BKQwsxICNLEGoq7llVJWRkc6CJfh56M2sPXqYJbornoU49FGMtYTM+ys9Dm4+TsCzABrhb0Wv4WqCs4ChueZoXXrEn16OSyR4Ps84gqSyuqxUdcfvPE02SFRri2bN9FBvMnHvVcvL21Tte5Ul9tU49jJeIUkmvss3rGZ4h4=
Received: from BYAPR08CA0069.namprd08.prod.outlook.com (2603:10b6:a03:117::46)
 by DS7PR12MB5936.namprd12.prod.outlook.com (2603:10b6:8:7f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.11; Sun, 18 Jan 2026 19:17:06 +0000
Received: from SJ5PEPF000001CC.namprd05.prod.outlook.com
 (2603:10b6:a03:117:cafe::6a) by BYAPR08CA0069.outlook.office365.com
 (2603:10b6:a03:117::46) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.10 via Frontend Transport; Sun,
 18 Jan 2026 19:17:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001CC.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Sun, 18 Jan 2026 19:17:06 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 18 Jan
 2026 13:17:00 -0600
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Masami Hiramatsu
	<mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	<linux-trace-kernel@vger.kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Zach O'Keefe <zokeefe@google.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Stephen Rothwell
	<sfr@canb.auug.org.au>, <shivankg@amd.com>
Subject: [PATCH V5 0/2] mm/khugepaged: fix dirty page handling for MADV_COLLAPSE
Date: Sun, 18 Jan 2026 19:09:38 +0000
Message-ID: <20260118190939.8986-2-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CC:EE_|DS7PR12MB5936:EE_
X-MS-Office365-Filtering-Correlation-Id: af0aaa41-e70a-447f-d978-08de56c62b5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j/10hL66il40T65eBftoWtyMWxnXeTYX5XMD1vzqPDR1yTbCdToY6j7M0yog?=
 =?us-ascii?Q?qpPOLRiSwJ4SboKMRew5q4xpIkfRS4cDx7SvK5HntKO62ahDvPiS7R/t91NA?=
 =?us-ascii?Q?tounyGXiKv4D74EX4AfACRgxjLM076TzulNF79m3com1FOIN6ON27855X+Wy?=
 =?us-ascii?Q?5D8hd2s728ypu2bCy64KDffladdx2Of+tyOQkRuXiQdNf2At1XuoA7YdXT/3?=
 =?us-ascii?Q?XrYjA/oyNsN9HHf8fnZOhmORos2HFeBxPjvA0elCn8VoK9JL2F+2QGxmQfzx?=
 =?us-ascii?Q?U3H6qcXRb9NB2TB5BU9kaZ0mDH9HsaveWUzzMJ1izxNbj5/QN1TWAUqaYT8U?=
 =?us-ascii?Q?5BFUc4qndRI/6d59yrRyzSWh/Vr5W8jWPuyQfA76VVxmcXA7Hm97mnkOz/YO?=
 =?us-ascii?Q?zJ3ixuSeTgOjvQd4MW/usZEuvgIos8twuWLbKhsDAzpyBkCyIrTrlzl68qh+?=
 =?us-ascii?Q?bH1gIb8ZLqrboqUkx1+Mn+Y1PXW48AHvdq42z+rDEGGftqEQhPByn12m8WrL?=
 =?us-ascii?Q?e3v3WoRrgnbFJ/CA6UllNky6yN4iXL02TRhpeJ2I+814DNIPMVr5CkH7gi9w?=
 =?us-ascii?Q?zZKek5V7DkG3bRefBc6gOHIT/lT6AH/vrAqJkAKvx38pIpt9BoUzRL9rnNHt?=
 =?us-ascii?Q?LYGP92yjGPZqpTnbMhUNNczQfTsqOc7+KYwo0vMPIDg343PZWu4V/GXvXE1z?=
 =?us-ascii?Q?AGy9AL+YW7d52G/6lTsD/n9GVmoOgqmkeLaB/up+qEW1u7k2/FKTzDwcy8Fw?=
 =?us-ascii?Q?rCNOynGl0kH75ou8LF3isVwj464JekINXbgvxAmn7S21y0pxAlGe7+lflzrU?=
 =?us-ascii?Q?koDbS1X4Hq0zBfFK599deRePuH2c8eyMiiRzsULDo76dxxm+xxucTM48XbOr?=
 =?us-ascii?Q?MqguZvvhcdunnTG+8h8Jf4hHjtzq3f5xzJ8i1YJ4k7/ko+f879pf9vyCTz0+?=
 =?us-ascii?Q?mqpBfDjYsotM5VVJnD36NkZoVDLsZyxr1u85ijjwvd+OTyD2i8Emg0YBBHd6?=
 =?us-ascii?Q?KeXA4Gv/1RzgIRXEzeKtUbjTM2qXVeHn4n6AdUU1ecaaTt7tvkg1GOYlz02N?=
 =?us-ascii?Q?sfYuzmnuenywA7qd91ut2hWnE6o6neBTv+PjFYasBRjOvpFMjB5ym8a8FL2W?=
 =?us-ascii?Q?cuALbhPjlzJ0ra8fzcedFOUPsDUHMk7VMqugD8VlMGh3SRSk0tXia1FiaxD9?=
 =?us-ascii?Q?pE9wgACptdNl76U2SzPqJqkIy6na4lZyVJE+H6e5fWQslLrADHAtmvll6sQu?=
 =?us-ascii?Q?qnYw0aw7GokLNQdBn1JymEUJL8nNSVYgpb1jVSVOdhba24ltiJVGMJKNY9J7?=
 =?us-ascii?Q?mhGVHDGVmNVPEt+f14HEgEytH9kggIme2GGBab/26qPngmbYReCtcf/fGyeu?=
 =?us-ascii?Q?Zef3TZt/FhZ3XaYL04FhqmqRCY0qOyxCWd4kG+dCxG+ak24xPxm6CHeDQZJ0?=
 =?us-ascii?Q?yr6TXdWtHVv2Wjy3/IzuDuV8i3DEPyz6lHonwxuBbncuf3HJRs5uq1maX+bg?=
 =?us-ascii?Q?b8cHyV8d/XICRBVBkSSSh4fRKTc4/4UE414cVDTPw2rlaRuY4jS9Fjsi4kTM?=
 =?us-ascii?Q?xaHxS/V/MT5yNzeZtM4CrKKifhpmNEdKGUbGf48/adE/za3qvR2GtyDBU8Nt?=
 =?us-ascii?Q?76k/c/fMp+Tn7b8sUrUcfxOBzMv19FgUrkn3CvsP0AzbtS7ACirVCYr0j5R8?=
 =?us-ascii?Q?dC4sb9yTmg01rI2V63KbTPaO8V0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 19:17:06.2729
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af0aaa41-e70a-447f-d978-08de56c62b5a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5936
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E56B180007
X-Stat-Signature: nw8xnrsqjkhe7f1tj6nx7opgmpx3pypm
X-Rspam-User: 
X-HE-Tag: 1768763834-822695
X-HE-Meta: U2FsdGVkX1992KMbWfXpXPM1IzEf2GNvCIrXoTVRz5WhFSrN7URsUva0upHnCH5NHq3x87MgGstGUP9h/YDfYK2fNZv0F2GNFYUpgqZQ55l7Iu5UzJRZ45FVvD3vvRBbZlL+Va4uMO/c7lG83/gQxYwCB2G8dv4c6hlFZszuT9vrf8G0g1ZiaQVOgf0fk+4w21J+8mZueWA08jSbqz6xrC4Yeyy1hrlgMVtNycqf49ChdEWyZ/LMY2W62SLQl4gXXJb4g0sZbY45sAiSxKCpi0Jz/tKQT/k2MAKr7K9FbioXXXMkZxDefXxBfskrzhenyr7SYcUQXfimFe/3m0qW2a2m5N27KCZvoMuM5TwRFHNo62sNpjk4Hrx+vOlyOlAux1Y4XMGL9w963bPi+W3LQn0xojWy+3QV8OEygzJQN7whY2CFRPZ8wDi+TjNAc17yEgqwAiozKv3sAiwCmxS7CZMSirlaY2C0+YDFf7YpUloOWsrzJ46cNPpd9B/HyUqX7faOOpq0iPLSqxgLjHvn+eejSyJo8CiQ1+iiEMt31/CWA8h/fwCmQOz0yXB6599eakNbhZVW5Z0i85EymooybgAK/2GbJvNzpmaJkmzbiKfvdx1g3l4EI4gBDDwd9oOq3K8mp6ILqYodwqK/LbkbmrKzTx5riC6ssADdD1JtVU1WJKvV9XKXYYCRG9s6ItPffmg8wBICcltLgVx4cdx07DAlkARE8O/QBggHeG5pVV7tFq0MOvU+aTZXDWhqFn71TSeedUM18Ibiv6xodQs+qwpe15x9JnK3nAoZ7VhOCsZ+o45tbLEWF1MG5YZRlDsoGJ4fatK+ZCkBsCWQS+bhpVcCtfUWYjqh0T1mPcfdukdPi1rYGImFKGen3RJKMtnj794TvUFblToEKaK+TmyGtFEZoTiWB3br+Akml/JVN76EIgDXKVmzs9+N2p6A0H42tyYLaqiPPIji8/6HcTw
 K8PiaChA
 fpQMsFLl24+qYxmPWLrwXnoE8MOJos/5WdOwogOUSoASRQuVC+tWDYt9w5VQI6Nb4qxXGTDUN+pH3gSO63PN4ZfBrpR6nnEya1PTn+/UGMQxZ5fLm01X3bv85MG0Xw40BW8nC9aDi/HG5Ms7pYPJCsIT6VQaIs16icUzyF6XAmE+Wco4B0FlXknqWMZIG/qukcphOscolid1tE/dLBKgTXt/J4r9pslAOBaLs8qpnIMOuV4xjvfPQiCplwMPgE0W3xAxtmZXkR6hJOjhVt2VjRw9BKTmobuWyjkb//Kxlcu1YN1Sv0+bIoyImhv14dyg5JIokiqoedqXZZqw43+nj2MQ2CtBLVdafGDixggd5cgzxbouXs+ztkpz7dsl+WDs2v2Aft9AqkXykwCs2q4md8mkNhhKC/Iqc+EhpBx8jfa2uh4gaXTQcQoOLNxL/d4Kz3xCENS4AsmhqTG76FGOKpX4CZn7rHwqvRTPM8x2aejGsHHbMU0YX/ysNo1oXsBrFZF19niP+PCI4cZE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MADV_COLLAPSE on file-backed mappings fails with -EINVAL when TEXT pages
are dirty. This affects scenarios like package/container updates or
executing binaries immediately after writing them, etc.

The issue is that collapse_file() triggers async writeback and returns
SCAN_FAIL (maps to -EINVAL), expecting khugepaged to revisit later. But
MADV_COLLAPSE is synchronous and userspace expects immediate success or
a clear retry signal.

Reproduction:
 - Compile or copy 2MB-aligned executable to XFS/ext4 FS
 - Call MADV_COLLAPSE on .text section
 - First call fails with -EINVAL (text pages dirty from copy)
 - Second call succeeds (async writeback completed)

Issue Report:
https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com


Hi Andrew,

This V5 series incorporates David's feedback for simplifying the retry
logic. To apply on mm-new, please drop:
- 20251215084615.5283-3-shivankg@amd.com:
  [PATCH V4 0/2] mm/khugepaged: fix dirty page handling for MADV_COLLAPSE
- 20251224111351.41042-4-shivankg@amd.com:
  [PATCH V2 0/5] mm/khugepaged: cleanups and scan limit fix
  (merge conflicts with this series; V3 with review fixes posting soon)

Thank you :)


Changelog:
V5:
- In patch 2/2, Simplify dirty writeback retry logic (David)

V4:
- https://lore.kernel.org/all/20251215084615.5283-3-shivankg@amd.com
- Rebase on mm-new
- Fix spurious blank line (Lance)

V3:
- https://lore.kernel.org/all/20251201185604.210634-6-shivankg@amd.com
- Reordered patches: Enum definition comes first as the retry logic depends on it
- Renamed SCAN_PAGE_NOT_CLEAN to SCAN_PAGE_DIRTY_OR_WRITEBACK (Dev, Lance, David)
- Changed writeback logic: Only trigger synchronous writeback and retry if the
  initial collapse attempt failed specifically due to dirty/writeback pages,
  rather than blindly flushing all file-backed VMAs (David)
- Added proper file reference counting (get_file/fput) around the unlock window
  to prevent UAF (Lance)

V2:
- https://lore.kernel.org/all/20251120065043.41738-6-shivankg@amd.com
- Move writeback to madvise_collapse() (better abstraction, proper
  mmap_lock handling and does VMA revalidation after I/O) (Lorenzo)
- Rename to SCAN_PAGE_DIRTY to SCAN_PAGE_NOT_CLEAN and extend its use
  for all dirty/writeback folio cases that previously returned incorrect
  results (Dev) 

V1: https://lore.kernel.org/all/20251110113254.77822-1-shivankg@amd.com

Thanks,

Shivank Garg (2):
  mm/khugepaged: map dirty/writeback pages failures to EAGAIN
  mm/khugepaged: retry with sync writeback for MADV_COLLAPSE

 include/trace/events/huge_memory.h |  3 ++-
 mm/khugepaged.c                    | 23 ++++++++++++++++++++---
 2 files changed, 22 insertions(+), 4 deletions(-)

-- 
2.43.0


