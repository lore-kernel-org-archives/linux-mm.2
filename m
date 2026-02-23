Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D60FEC110E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 17:18:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8189A6B0095; Mon, 23 Feb 2026 12:18:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ED036B0096; Mon, 23 Feb 2026 12:18:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F91E6B0098; Mon, 23 Feb 2026 12:18:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A3276B0095
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:18:02 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 19FF614020D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:18:02 +0000 (UTC)
X-FDA: 84476379204.01.F3EBD8B
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010025.outbound.protection.outlook.com [52.101.201.25])
	by imf28.hostedemail.com (Postfix) with ESMTP id EA4F3C0006
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:17:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Hmx7zPfz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of Benjamin.Cheatham@amd.com designates 52.101.201.25 as permitted sender) smtp.mailfrom=Benjamin.Cheatham@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771867079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RAzWJbM7OQaueOQ+W03t4HPDZjEwxYkzgxpnswl9i+k=;
	b=Kv9JIF81b1ePpmt8s73oPowfmHEfR9bXjc1v1b5k2nQEyM/Hks+6A06J5DdgN6xp9YQHGJ
	1Vqr2wBtpe0wTIFWjt20imLHqpDokF3LWJisSuDz3BBXkj3MdGMul1H+ElJADYA05cTUpl
	5Eso+lT88YYcpWBP9deysHWDIumWCtw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771867079; a=rsa-sha256;
	cv=pass;
	b=bRpjoBH0iSBxJd7lTMz9Xu31cZHQlp5uzPyM0jw8XjYSdeMoG59VUCGLHcSIxvArbjOsIJ
	mJJtm8z9e1OIWttztvi2JqIah6KIOmh1h3TRGALjUWds8774L0hp7+lxIwi2YrXfY1b3vG
	a/JQ2p1o3jOq7blolIWtJ39avuV8WwU=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Hmx7zPfz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of Benjamin.Cheatham@amd.com designates 52.101.201.25 as permitted sender) smtp.mailfrom=Benjamin.Cheatham@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KsXCg/GxpmB6Gh5NAUmHU3KcNBQ3USyXk8twZyX+ySS+cgXMtbhqnVqBk6ctPSkYg1ccNx1rYiW2oQaIpqdpWcCWcHeCBbec8j2oel0021VQBa2xhMZe7l2i8jxMoMGCDbDmXnO7qkV1Mbx8IlasWaF2mVLfLXmWhl/qO0FuUnhrIEnxTFXd7q3dMqmjoyBn71j9U7T+Fhl4siy+LwbjAHjfbeCUCNqRklkgc1qWwElhnYpDObJbGrtWQYgrYeG+JBkDnLwHkHAvKpHQXB1jIk7u3Poeollw9VZHi6GVM/Lwa515dFUudQFxBdube/tkzLeciqpn1uBbzUxCRS6WAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RAzWJbM7OQaueOQ+W03t4HPDZjEwxYkzgxpnswl9i+k=;
 b=o8cBXgBBzNnmxlAvkSm2soDPNVsUsf5cYsMK20G/jrtKzFvNKZSifc3ehkMwh6mbK4ubU+K5k9MlMAOOSlcIQPPDCCSTBaIpthmcqBpfvGcLKIc3/hZnCIY3hdbyUr78sbsy9mO6aQHi0hh87UujNle8vp3vqOBITiqM+A1lEVLiYv0UX+PB8+FJF1iPBO97w/SMkLh07hHeOmmwdATbU3NQfdJls/fCq0jXRZXxzqlF6zQUKzkAmsVy/4Ze2DjLhIJO1j7SxB5l9DDMyduiu78a/6oWX1YOxsjKI8HBGcTUjXpqi9trLEvfsA3ljxW3uOj1wGGOuSgeLEVlRoVS1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ilvokhin.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RAzWJbM7OQaueOQ+W03t4HPDZjEwxYkzgxpnswl9i+k=;
 b=Hmx7zPfzSEeWrIlhzIkTfEV6c9VocLTaGscRw0UFUCIMoRsrWaBacmXFR2tqMIJxQZle7CJZwjNcYV6lYIU6XpmUJdWno6jzkS8vwceZtSj1QHcqYl4V0gJ8JjH9EfeQkRbLQKTtGcsOqQVWxW6ukJtSL7oQJENwg8oLGp7zQVI=
Received: from SA9PR13CA0044.namprd13.prod.outlook.com (2603:10b6:806:22::19)
 by CH3PR12MB8972.namprd12.prod.outlook.com (2603:10b6:610:169::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.20; Mon, 23 Feb
 2026 17:17:51 +0000
Received: from SN1PEPF00026368.namprd02.prod.outlook.com
 (2603:10b6:806:22:cafe::cf) by SA9PR13CA0044.outlook.office365.com
 (2603:10b6:806:22::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.20 via Frontend Transport; Mon,
 23 Feb 2026 17:17:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF00026368.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 17:17:51 +0000
Received: from [10.31.207.109] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 23 Feb
 2026 11:17:49 -0600
Message-ID: <c13e340e-74f5-4a66-8fa0-d307ee5ea0eb@amd.com>
Date: Mon, 23 Feb 2026 11:17:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] mm: zone lock tracepoint instrumentation
To: Dmitry Ilvokhin <d@ilvokhin.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-trace-kernel@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<kernel-team@meta.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, Steven Rostedt
	<rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
	<ziy@nvidia.com>, Oscar Salvador <osalvador@suse.de>, Qi Zheng
	<zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>
References: <cover.1770821420.git.d@ilvokhin.com>
 <06b2a2b6-d5c8-4522-8e22-10616f887846@amd.com>
 <aZyEctoThn0anlz8@shell.ilvokhin.com>
Content-Language: en-US
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
In-Reply-To: <aZyEctoThn0anlz8@shell.ilvokhin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026368:EE_|CH3PR12MB8972:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a21cfff-da7d-4d91-0965-08de72ff7980
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NXZBNGRnNGp2c2haaHZlTGNEcWU0cDBFTzcxNFR6bmhWZjVEOG9hNXhUMmxN?=
 =?utf-8?B?SWNOMDlTOXBCSWVKaFZPelRzdUJ5RlRLQWNpaXYrbVBaamJ2eXQxb0lWcS9L?=
 =?utf-8?B?RzA3VjFDMW5uYVdtWVZ3VkFOV1NheWJaUG5CQko1c0gyUlRLYjl3WHBrSSt3?=
 =?utf-8?B?WTRpZFdjN1lxVWVOMEg0OTRtaWpocVMzclh3K2trSWRHVEE1YlE5WDhDdzdx?=
 =?utf-8?B?bG9WbUZWWDg2WHRWZTVKZGRTUmU5S3VYb1J1RlJEZXh3T3BMcHpxejlHeVZx?=
 =?utf-8?B?ZWRUQzFYbWs5ejhIUEZzdGcyZE5PVlVGZE5NTUZpK25NYWVuODZtMFlWMy8y?=
 =?utf-8?B?bEh1aXBVNjgvMGlUL3pBc2txMlMxSG91NWV2Y1VKVldxa3YvS011ODluckxw?=
 =?utf-8?B?R0t2UTBqVmdUSE5jOEVMZngyZEpxRW1nTnFFTlZ2Nm90ekRUdURSRkozK2gy?=
 =?utf-8?B?bzdrRUlUajhsdmlTRmkxV0Z1WXRTdGRaRUNrUE0xclpuNmVXaWNYRHNoY2hn?=
 =?utf-8?B?Q1FGbkFuejdFZEJiZFYvaENvRVdxdWVpVXNreE9xRVhONXFmL2dIZmwyTDFj?=
 =?utf-8?B?U3JVQ01BSXF2NnVQdUZnKzA3Yjlna0FSUlQ2aTgyZGJBVVRrQnVHYityTnZI?=
 =?utf-8?B?ZXVBdGR4RUdFNkRmcjhuQVFiOUpLN0ZINVNBZVdFV0pMZE5ZL05oQXBxaTh4?=
 =?utf-8?B?b1JSeXVoSUc5NHp5WWVvampLQ0JHa1BzVDhXT1ZCSGg3a280UTZ3NUtkVzVt?=
 =?utf-8?B?WWtoYXpqd1I0KzI5WXVveGNLL0pldWtDODBDTFJVaGRBcndxZiszYzQ2UkFF?=
 =?utf-8?B?WmRmRGNJamFBeGU4VkU5SlBFT1cxclNVbDlZMjNIUHdINzh1VUcyUG9DcWRO?=
 =?utf-8?B?UTl4RGZTVHNJQ2xITGFGSG1ZMXVnUE9NMUs0YTgxcG1HZjBCSlhmaVhsbTQ2?=
 =?utf-8?B?U29mc0V4dlY1cWMvUVVSQ0NtaVpqdnVRUnFLSExET0t3Nm9rcTZBRytReDJE?=
 =?utf-8?B?dVRWVXU3ay91cnZrbElQZ1JuWStYOGlwdGgwcWgrZzVOSDlxZ2RTeVh1d2Zp?=
 =?utf-8?B?ZXVYblJJcnFLbmtGYWZEZUFGZHpTTWIwcytJS1QvVEp6UDlpQmpST0ZBb083?=
 =?utf-8?B?S0FCQ0Y5ZjhCbjV5ZVRrT1dOZHE2dTljeDYxc2FkbHNzcS81bUhMSEQ4ZUxn?=
 =?utf-8?B?NGZ6aC9ZSEJjOE1uOUlRZFdaK3JhdlFMYmtNZ1UzWXpIQVNzMUFGRWI4R3hM?=
 =?utf-8?B?UnF6Q1dxTUhNa0NqdEhxaXQxbWY5d3ByM3ZxdG5FSG9BQVNnYkoybFdOL05J?=
 =?utf-8?B?bjJVaTh2TmJHamxOeEFleVBNRUc1bzNrMjFCckJENVhGSFVBYzVqRlZkYlFT?=
 =?utf-8?B?WUFZbVZpRFJpSVBGM1pncVByUUNGeWdZUmhGRitJRGpPV0EyRDQ2azhMbFRW?=
 =?utf-8?B?cjVyN3hHNFBOelh1MEM4Ti9GODI5OGZBL0w1ZE5zc3UxdXNGdDFIZE4xd1g0?=
 =?utf-8?B?WHRPQmNDd0d4NGthUlpYY0dzNGdoTGd1bVIyeGV0WlhMaktTSHBhampPWE4w?=
 =?utf-8?B?a0Y1QWNQbWZ5eVIwYVRob2E3ZzluUjFSaWpDSmlsWDhSUWxWVXhGQzVQT3FU?=
 =?utf-8?B?OEVVMVJuSk1PNGVBcHRSSlNDQnMzRmZqcVRoQWtoU0I2WGRiUklXa1NxQmN1?=
 =?utf-8?B?Vkp6dnFXZ0lrM1YxOC8rSnUyWTdpNmpkU0JHVzE3S21HQlJTTERWUEEzZWNi?=
 =?utf-8?B?SlJ1dDVMTnpsK3ZRaWVTcEsxWkFZZktTY2RmSFp2dS9sZXBxemNtcm93Z1F4?=
 =?utf-8?B?ekttbjRISk1UM2ZFUk9nZUZzanN2ekg2bnN6QnVBVHVnQ3Nuc2VjMXlBbFZT?=
 =?utf-8?B?Y2pyZ3hzOHZJNG5ibHgwR05HVmVta0hpd3JnQkFLT3NMMU9SZFhROU9QeVV2?=
 =?utf-8?B?MG1pQ240Rjl1QXZkTEQ5SmhYYlg1eHJYVW12aklnY3JvNWFNazROUW44Z2pG?=
 =?utf-8?B?andxTnM0cWg2VFJzT0FCUCt4U0FtdWZ2SWpzYXQ5TCs1QzA3R1ZWZ3h0elRU?=
 =?utf-8?B?U0lhK3FuM3R3Tm9CWENXRzN0d0hJbW9oWXVJejVWMWNHVWRhenVuZTg3c2FP?=
 =?utf-8?B?L2trRHNLbUhxOTVncFFHTWIzVUhSdXFxVkcwUTExWDJwenBubnFqSmU2YXBT?=
 =?utf-8?B?UlVvY0lESlJJVXcyaVVYUlJuWGxVQlhqangzUDA5MjlXTTFWTTJmUkxUQVZt?=
 =?utf-8?B?TGlLbXNuaXVWS3dzRCtCMm9HTHJRPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	z8eCtQadELFLqs16nLk6HRRSxLjUrK2Wzl/FYyIM/HtlOPq8UnXH0Rr/kjIlXlC6YH1orH6YopkI3DJbFtrnOERsIVI0DDgWqVeIO20VGhF6D/1JVp0/ODpJViAjnJ1PDnj4f1YLOQs9g4VSuIFiI3smlAqlFVsV16WnE33auU6bNYHhEibR6gtUjXAfrxKDBaxI7N0+YjpORXHAxY3ZJannCnw+Lut9BbVElvfvDlSVm/mavzosLvETd/8Cc+wKuJHqpWk3wVHjfOccSzWeH+bC5ER1iadsDusfvunOu5EX/gIDpDwuGuzS+BOu2/k8BuDMYdT59fArVqu6tYGrftJWxrXPi7Y4jr+bAHKIGrdEJ8+LOxD8M/QL3ipkXkmsAoy8KY1OURj72eWa2UVStEb9+Aq0Q+cxKiKWiG0uNSO4RnvmbPMBI3gB+HzEEPCd
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 17:17:51.3437
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a21cfff-da7d-4d91-0965-08de72ff7980
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026368.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8972
X-Rspamd-Server: rspam09
X-Stat-Signature: u177snrioya6wha9h1j6r8cxcio8xymd
X-Rspamd-Queue-Id: EA4F3C0006
X-Rspam-User: 
X-HE-Tag: 1771867078-96188
X-HE-Meta: U2FsdGVkX19Aj1XjbGZYzf2LrmpP6HbSBRKJoW/ztgl7RgVzRIG3d3ft/sq/n951ys5psJoO4oqxXEU5zvLdLXvXs3kCc4UtsE3U0ymc4H7MGsyXHj8l96ZuufDzn+LsTGvSMRw+rOM60XuP6EGIox8Yytm/DRTG5gd6MLTLxUeng6pkgzFdKaMDEWhhgFZgQ/nez+SPfud2/K3v5WuJHeXIurTaOSdgnYt6sfi/ERjzCzIMNNeI8AShgZzlkA6Nxlc1QMguFuF4TFWVnNwDZ9R82so/qKGxIMxmDe95E0gl213N2QZ+1OAxD7XnixZLfqqgB0rJWOZmR/gJT63yk4SB74ILHzcf9XdAMl7pxjMIwhuT+iqAcvr46TB5O8ibPMPy0ioZPCpEIj6aR/XDurwEf3oOVws3Tg5g6XeCYb7mfv52aNACpHWcNrrw6a0q+MRIRDhP+HONYkuW7lr3e1+9jkqV6l2SNoKlL7H2Y1RJ4aWw0RWR032Fd7fxtSS8U6qEeM3i+llBt5JeO65azolDfY5YpCIQ/KklfrFtleTBz6FtHgHUq6a349jq3N0IHfQlhoGc4/7kVl9gToNFubjH0ROARoeT2TfDahtQlmIYnRLR7hL1lZxg6YPlqF6F4G3u6Y+utwmloKhtKZneg8F47t2+O0Dtcd8frzUAf9GvCvXMZ10XHB0H4c2lvQRh8jT0IiMNWtCxLSMu/FoUVv1hTJA/u6rp7+GKAWLv68DW3M8kZ1aQsMoAXIotdAhNXaveV0N7h2GWDGiL6C2vo8E1BwyTh+G429ndhp4jRumtHmtZ6MB7O0TBVmdnHBRyRxScXYwm3kwEgxLcXIOZGWEQ+wfZ8JW3juMXGD7fYd9UB4SBhFAjnTgYbsWef0G63gATGI4uk8A8R8DQVbdlLqJNBBLc3S9gAvbQs+N13II4d7YjU1k110+ll5UH9ns7jvRnOYaGPJrp3eV7Mzx
 Llx84flM
 09MYNwaPYyP29WNCtvtgExAYo+I8Yyhxic6hRd3t/0ay3c0ayQYZsoU4FcLfCy4DmhRO2528RV3EEByctpDgF6DXxJbU/8YnoEYW3S9fekJO2iJVIFW1O7rnrILkYnUVvmQe/yHi/nv4aDKNVZrJnTwJ39d5QQj+louuc/1aiY2sARh2xiB3GP/cOc2kS5hJo+77pbOE2CmCFezJF9R1S6wi1iuAUxMerrc7R+qwv++k2BsIEQB/1UUU4YASxDwdsR56MzZEE0VWqrMgPr940ZaMgPECCYB++twkDTCOFVesztW7BZMqLZOQv0RIQZSIMxK8t0LDGojPPgQVcyouu2aj4Fx2UeuDZcrUd232xpbeQCqC6X3wp9tVV+kTUqin4xZml9xhcOGuXydZ+zCzCHaMwcQBxHXfbF/WUlrmGst2PzEGlROAI3k5T0vj0amteqCQ9zxcv7Exu3AlmqepFf8yGSKVLD3Pums7MueYhmzhbtUvs6mXgsfVzDU9lNh0EO+yFz8/r30Jn1lO+crKvko9PUFXtxU9m+lCrk2UAETTBEU0U4iv9fBBX+KP7gj5Tib+N6RZiAvDdbO6QS0Xk7kvWifvJcjAFwUK03DPgvkGxRbE4Pla7eFrluQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/23/2026 10:46 AM, Dmitry Ilvokhin wrote:
> [You don't often get email from d@ilvokhin.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> On Fri, Feb 20, 2026 at 01:09:59PM -0600, Cheatham, Benjamin wrote:
>> On 2/11/2026 9:22 AM, Dmitry Ilvokhin wrote:
>>> Zone lock contention can significantly impact allocation and
>>> reclaim latency, as it is a central synchronization point in
>>> the page allocator and reclaim paths. Improved visibility into
>>> its behavior is therefore important for diagnosing performance
>>> issues in memory-intensive workloads.
>>>
>>> On some production workloads at Meta, we have observed noticeable
>>> zone lock contention. Deeper analysis of lock holders and waiters
>>> is currently difficult with existing instrumentation.
>>>
>>> While generic lock contention_begin/contention_end tracepoints
>>> cover the slow path, they do not provide sufficient visibility
>>> into lock hold times. In particular, the lack of a release-side
>>> event makes it difficult to identify long lock holders and
>>> correlate them with waiters. As a result, distinguishing between
>>> short bursts of contention and pathological long hold times
>>> requires additional instrumentation.
>>>
>>> This patch series adds dedicated tracepoint instrumentation to
>>> zone lock, following the existing mmap_lock tracing model.
>>>
>>> The goal is to enable detailed holder/waiter analysis and lock
>>> hold time measurements without affecting the fast path when
>>> tracing is disabled.
>>>
>>> The series is structured as follows:
>>>
>>>   1. Introduce zone lock wrappers.
>>>   2. Mechanically convert zone lock users to the wrappers.
>>>   3. Convert compaction to use the wrappers (requires minor
>>>      restructuring of compact_lock_irqsave()).
>>>   4. Add zone lock tracepoints.
>>
>> I think you can improve the flow of this series if reorder as follows:
>>       1. Introduce zone lock wrappers
>>       4. Add zone lock tracepoints
>>       2. Mechanically convert zone lock users to the wrappers
>>       3. Convert compaction to use the wrappers...
>>
>> and possibly squash 1 & 4 (though that might be too big of a patch). It's better to introduce the
>> wrappers and their tracepoints together before the reviewer (i.e. me) forgets what was added in
>> patch 1 by the time they get to patch 4.
> 
> Hi Ben,
> 
> Thanks for the suggestion.
> 
> I structured the series intentionally to keep all behavior-preserving
> refactoring separate from the actual instrumentation change.
> 
> In particular, I had to split the conversion into two patches to
> separate the purely mechanical changes from the compaction
> restructuring. With the current order, tracepoints addition remains a
> single, atomic functional change on top of a fully converted tree. This
> keeps the instrumentation isolated from the refactoring and with an
> intention to make bisection and review of the behavioral change easier.
> 
> Reordering as suggested would mix instrumentation with intermediate
> refactoring states, which I'd prefer to avoid.
> 
> I hope this reasoning makes sense, but I'm happy to discuss if there are
> strong objections.

No that's fine, I figured as much. I just wasn't sure that was more important
to you than what (I thought) was a better reading order for the series.

Thanks,
Ben

> 
>>
>> Thanks,
>> Ben


