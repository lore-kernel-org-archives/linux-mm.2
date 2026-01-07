Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 488A1CF6C19
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 09:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF4E66B0005; Wed,  7 Jan 2026 04:18:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9F0A6B0093; Wed,  7 Jan 2026 04:18:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94CF66B0095; Wed,  7 Jan 2026 04:18:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 84EE06B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 04:18:52 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25E3957270
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:18:52 +0000 (UTC)
X-FDA: 84304618104.16.32B74DE
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013001.outbound.protection.outlook.com [40.93.201.1])
	by imf17.hostedemail.com (Postfix) with ESMTP id 512304000B
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:18:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="mSgXs/Ob";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.201.1 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767777529; a=rsa-sha256;
	cv=pass;
	b=1lFe1sfWG4+dtKc/DF3RYnYYYXJ8JxGcx1t5mfQlEuHlnOYgboVA2vU5YD98TY1zqM1OUF
	ZeJxDPDV3IJ+eAM1zxsTWTh1t4dGJLHZpYK9v/9xQQZGiXAEF+4HHWBZlS5pf9nqlYRFLH
	2YDa5Hj3kHhBLnFhi9Y3+hNFs9AEOTs=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="mSgXs/Ob";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.201.1 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767777529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RiPfsVeSco4+tw9MLR3a6AO8th+OP5bcrFN+x/BIKr4=;
	b=dmmYMCjamA7wR4wdIoWHZDlBqnKuli2ltxuc7g3F/dfbESJI2VA6emaf6jszZ1eYvgKFzF
	U+IVHRQemzsOX3MXySEpovHidkMCParbi409/6qs1oihQsWNYxKWauNichoMYeOpFIa5QF
	H4NKQ2nBzTK9y9m55gmh6MzazLtgI7c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZLQxwNlZjwktSnACPhuOFrcuEhx0Pk2+aPh20RCWU1pXwcd6W8O6pMUmO3x2/GZBEQsyZgUTMp9+4K4AXgMc7Fr1Y1wTiBLjnArXn8ntMbBMNlMKXCiqWp7q3t70T0bdC2RifDKY8E52YsWzxxcI0bWHuKwpJoqj2dO8dxY+rwjDtL8mOAU7jUKmkECwQlXzVCjGxYfRiowCuCzqkx4R7TOg6eNnHyEe4GJSUlO+sDy/tpu9QXVvT3tXAfP4x470PUYlbKuuND3URfiDKySS7N7FckdPRxtESLGoSLqmM9/nWNDCnN6XbdpUWJDOgNnLjXJXsQnj0lqgX3y7O2B2Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RiPfsVeSco4+tw9MLR3a6AO8th+OP5bcrFN+x/BIKr4=;
 b=S9L+fGmPDbkOaHiDlHa8idiFsi+X66YwXpqyXPYAYgdBe1ODp3JSOOIJV+xfMRtsv7CBxeMpNU/UDQDyBnejfolx+AJJziwfhJ5fjZ8pVQ6iSkM0FM+vhl0jzFC2Rn2wn1u34Wlf/BGsH0FDPtm6NELDMjYbfc1DJJKEO8v4iYCrzgXUOxSAKfBbmlIoq9owfB7v5IKOar+InrbLTdOPtTz+39bGXSMg7O+YsFn+hRCTZc3j8UYJUIzElVZSp31QbzjvMkUAMZgwcOj5zb5GFKyb1NdABR5V46US2so1SEgduiVujJtNytZ3Y0IpJE826nHoYYXj7w75f/N/bMVtKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RiPfsVeSco4+tw9MLR3a6AO8th+OP5bcrFN+x/BIKr4=;
 b=mSgXs/ObBn9EHqPfUmrOVEkF8n5mnEKMiT6dInjMTJxZoFcTd33PkJG35Kt07LmesMOVUJH1G3DlRL8JmEE3gtj3FvLW24kbUuPzvcdRj3s/mkpRBQyzcgKSEcCiRAzrn/YLRbDWmpVd3cISGH5PtrmBNyuVhIvy97XO0uKabDSc+qyOhQHQ7jsDbFk3qMwvOOJjNyR3uA9vKkHY1S4JdHf4m9lEeCROdYx3ADukcKGqb7G/ZSQvbZG2WPCse+5IyRxFFkAOiK0RYc5J4OGh3Pu1aGbDlN9AktnVPfvU7sYsSw74pO3E5Vy88fPYOZ4hZ2EjwGrlvwv51+18bZWTWg==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 MN2PR12MB4335.namprd12.prod.outlook.com (2603:10b6:208:1d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 09:18:39 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 09:18:39 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com
Subject: [PATCH v2 02/11] drm/amdkfd: Use migrate pfns internally
Date: Wed,  7 Jan 2026 20:18:14 +1100
Message-Id: <20260107091823.68974-3-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260107091823.68974-1-jniethe@nvidia.com>
References: <20260107091823.68974-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0088.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::33) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|MN2PR12MB4335:EE_
X-MS-Office365-Filtering-Correlation-Id: b50f75a3-b3c1-4f25-ee76-08de4dcdbebb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ht2hzWEkpYHYdJ3SnrQI+/WUi3+0McxrO1BfqRULwy2A/PBx6Hqkgy9Cfxnb?=
 =?us-ascii?Q?npDNpBhy/cm+zXSwWv3GwFXJnAXvV76BBr5kwSwXObF8qZMsDNxsbvtued/N?=
 =?us-ascii?Q?QwZJaPius1lBLSJGI6G1vdHyWLwDI7AGTUGEE13IB+yXqak8z8J32NIOdtu3?=
 =?us-ascii?Q?W8AUWL9x20oDPF4NyghpJ37jy3IJ0Lfx1/RwmOvv38E5ydOFmW877bJA0pSO?=
 =?us-ascii?Q?0cxvjNdsMNurmkoC6UDi9DVpE6mr8pQUlkFrvw9/C9EE9qukI5sYh10ecRyE?=
 =?us-ascii?Q?zbAgiQRPN3j+dIGTrVVldClGmZ5jsgMtTaRDEF8G2rpDSx2mSAXOyLAeEiVW?=
 =?us-ascii?Q?kPBvr6JC0Dh/A28NzvBHW6TApXYU7k3//M1Xc7wzRr0iEIN0cfzoGIZPOxNJ?=
 =?us-ascii?Q?DFeZXMG6B29sWclyGqOno1i6cpO/11CyKGrofEYoM2PetcoWcnCh1xKdqrHN?=
 =?us-ascii?Q?P4rDx/VqlvR90gxBR66rwZvTe3vrYvaxhN6MaTIxc0kW2GAznAkMLqOZePgM?=
 =?us-ascii?Q?uztlWnFrCxB7Unwn0iC+n8K9rB1ONW2+bY1ALqirwT3/8qT7T88pAUbyc5gp?=
 =?us-ascii?Q?LNeSOLavvzHFiPRxfwZYj12tkYoAWgLVxMAnR9Ld6VCgN9dHMsP1/1cT0T39?=
 =?us-ascii?Q?iCgh6fBWf7ftj5o+6IEAlAtWmD6In2vwFIjxShhFwufyCUjAYyCHNkmWw0Xd?=
 =?us-ascii?Q?m04LFQwxPAIc054KgaDYKKaNwN8qRkdV9eFJW28QB7xpvTIML6cJe5Y3HRKu?=
 =?us-ascii?Q?BQv937u6z4cuP/1UBLkMH+MQWKdjD0aZLZfsIcHj0kaOcU6C0kcHYws7nCBP?=
 =?us-ascii?Q?Mj7Z/FeGNpmbTvP/thp3BL7J40PwF8EMaZfXaUsZ7p+eCiwyouSI7n9uFeA8?=
 =?us-ascii?Q?lxOm4AcYGVMYj3szsxXfS9sjI9+mrR+O+o/eIsekw+fb0laGyEpvPbYFJ60w?=
 =?us-ascii?Q?kXtWSdvLrSPChGuiam1hYzgxv/ivai1w9DeCyBwcMIT6kbaq0GQXMsP255Mb?=
 =?us-ascii?Q?h86oIbOOYu7aD4cY7kjcnNyAQsPMKm6aFLox/nhJ9QG5Av1IjD/CwguHl/2Z?=
 =?us-ascii?Q?qxGz/18JVY/BPieS40cap1v+CJ10pPDh5DwV2QJvk81QIhdTFnnGz8zcj3fM?=
 =?us-ascii?Q?caS4Q0oiLWU67xNbtEIfBCz5+AA9EEXB6EwOsjwd7LqpzyzTPSBF0sr3THAJ?=
 =?us-ascii?Q?Z1xcrtQ+IiSaMbHrq38EEWoQpVuONbhbMb9jjgn6f2mopYy/Iy6dfe9jI4NL?=
 =?us-ascii?Q?cEL4ecdeaLPM05PGz0Ek3dMAsCUsZgxbfPeTh45bb8cb5N1ov8WKPH1L6n5j?=
 =?us-ascii?Q?UkKQ1oQZeHwH3ecnC0s8JYgHI6FHJqfWyyYF2ER51/EsXtNgjNefHDbLaJQn?=
 =?us-ascii?Q?vFs6ffV76/YN93mFalQP5y03AktYgMlvnPiz/besEuldOXBfH/KjprgB6Z+c?=
 =?us-ascii?Q?rIYoAhmNap47zkZ0EcQopYpIBYwrv/zu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TCdr0I3l4QWPrwFFi5lHosQ7HhbTtAGak9zRtr7jfpFCscgseMnWcI2XufyU?=
 =?us-ascii?Q?d89OfYXoWTZuZDg1mVXHoJ+u05tDCUmvA7QFj71dkbj1hp7EXX56beS37N4v?=
 =?us-ascii?Q?uPbBwl+GsZep/Sy7hq86Qbi8cwzTuuxnIbCwWcVRDgZfpwc4+izC9s6WZh+o?=
 =?us-ascii?Q?Gx+qiNCQowd/JmPcKJ76csYY1uuusQuzjIP4kYq1VHc8kKgTnGu4xH71C4gV?=
 =?us-ascii?Q?HywCcK8CZkj05PJwtMtlFklON0RYfPUBguKY153q/k49++EESIKf6IDuKpaY?=
 =?us-ascii?Q?CQa2X2RDsr/wylupPHqjswVKX3UsnZueQCJzVVSDzX9D/0NiL5nYF9sVsGPe?=
 =?us-ascii?Q?/1eNCdLxg39BB30YAtHfl7i5ZQRkSjsOjrWiywfQvi9AF0o5hRIe0ON8++GR?=
 =?us-ascii?Q?PMPbWp8Pd3uokPiqhaTfMeAxUu1yVxPPy77oL6FwF8yq6/X/P5up4bo+JxkS?=
 =?us-ascii?Q?zJU/ZEl71wsespK37jfnCGXOOvoQRG3uiyOemAzxh5TOyEoh6D3neGIgowL+?=
 =?us-ascii?Q?1cAhU99xXjTDM85rpGuahsysCoJOOm4Xi1AkLzyO0cL48dlEh8QEEleSXO1u?=
 =?us-ascii?Q?LHaaxI3gZ1vFlblqLINZ3hoXB0/fs1HDo64gREvwrf10NMzg3JBYLPMOlfpf?=
 =?us-ascii?Q?8ECntDmtJbNCnykNK6C0QY/kQotv/Js0xw0hC9yUG3+3gdtiPbud4SwPywZE?=
 =?us-ascii?Q?J4Wo8ZZK3hiR0caO8xQX6BXYZDSm1ra57ax8Xou8oaz9bGBP0srnRLDgQsMm?=
 =?us-ascii?Q?p202NcIwfaHxO3igPuMsKDyaFu9F32pzpUrCJuhFtlnZ1VKKoKCmBnD47Joy?=
 =?us-ascii?Q?1EnjeuIXiAdRiQCP7s1Gs7rHUlqMIpZ4ibPJQlsba0hfrUfRvFzuRuLHKqa/?=
 =?us-ascii?Q?V36GurgEdvBAP7SLbkJhBnRODt9+8C9qtOnYMKSYDqHCiSq9KsUEpU/JHN/Y?=
 =?us-ascii?Q?7qrXnW6XurP4u0Sx8NyxwwXhGmNuNsmp4tHChWVDkJCCP1uZbIJZHp6J9XaL?=
 =?us-ascii?Q?fNMlq3eNlrpukt5jkqfqWVJomHZ4ZeJzosjHVi/t1pwc1EsRifqWjRqZsZYi?=
 =?us-ascii?Q?lp9OLL81RgZwJ+67Nisrqayqmf/eXbI6wUTfqxJok0lcgxl9xKvmK27Bx6SN?=
 =?us-ascii?Q?w5cOmGMmOSA87kJN3UnrD+O1ZqWWQWXLU8DqEwq3MVXkAb4wXKdJz3sPEl0K?=
 =?us-ascii?Q?NfbnhaB4l/2Ml1Vda5tedcF5YCfXodHDDxTywqI7nTjB9EUTzNiSwrItc9qd?=
 =?us-ascii?Q?qnUGol+FkoDnfCeq8QsY/SEmMLlIGI+bXeuN34xxFo6aDmNPDfqV9njmLfCd?=
 =?us-ascii?Q?qcHrPRk3qIvqQcilfF7/AomiaOeFfyRruKHCxC6MLJP0o8lgDe0swH0VinaN?=
 =?us-ascii?Q?IdwBIcM/JAfEYc8+zKNmWk1bSJnFkqBluxNg+UJ9Lr5aO8JKYu9ToCFeqDNL?=
 =?us-ascii?Q?8VrfYO84HL2U0bESEubhHqAXM/M1+UbTRBZP+GZ9H+yDazGQ6YEeKekv8Zyh?=
 =?us-ascii?Q?A8pV0ZArxhBEMDv8uQ0cz8/ArjBoVflcwtcgyGl9/M4FWR2VLq2sqdN7VCcG?=
 =?us-ascii?Q?bxk6o10qK46i06C9K65atlG6QHwycdSVHcmOQw9drQB14XcnfmoKiSTU63H1?=
 =?us-ascii?Q?BP687snziMVjT84+W0Z71hi9RJbMfz7wCUYcFjR99tNFhzIr2jhhSkUlPvLm?=
 =?us-ascii?Q?Fx/nby62zm4v8Ds7DO8TtB6qjLSaNp9kbVy2NR3Tq98a4yE8moxqUmq8Syec?=
 =?us-ascii?Q?Yi5jeYZoAg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b50f75a3-b3c1-4f25-ee76-08de4dcdbebb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 09:18:39.7927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mGYfVMHJZtjE43fhRM2WJcAswJ4mqRfgDYtKFqcjs77+5SrP7+Izx+Z4hqu76ucJuCM/e5qIoV7MO/3Gf1/wlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4335
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 512304000B
X-Stat-Signature: psy78gton37bfhi5m7173y1ok8f3ya4q
X-Rspam-User: 
X-HE-Tag: 1767777529-556593
X-HE-Meta: U2FsdGVkX1930OhfMFkW4EFH2RWP8zJMYFT4UnGFMjCoXul1IAAVQIX0f/un5QlPDLuQY/DduJjMLLy5ZBnJrusAA5Az/lbs+9bgWA6JTfqQLO/oYLL8kF3485FlcAW+cXUtTfShZz5r1pBZ3FU1SGRRxNcGxosYgq5lwGyrEyXV7W8lUlVikZcHIruyEaWfYDrzwC7Q4iaMrgujUb+Kds119QECP1FDrf1b+CAzJpuBHnMjBTcU5wyyLJb26QEkeJLGU7akfor2m7cbmY3WP6EXYrIAs2VJoA7HQ6RF6wUIMuhuueNFZmDKRgWnzLebuRPep3aSnsaYxrfgs4sq/cMv2tdN6X+KRcaSx83/SgN1HopwwIYOfJgRR1C710DKrCS9XBVFlWIybyWcWVRDbjap6AP9Ws5ATHWgg3XisW/V8ByjmDI9k5jr83XnRW2h6fC4dRSzdwXkg0g+jGuYCn+IW7FaisELWcCaiLRgX9/lynSotnyntvUseyJgkwAWqKfNd2fC4f2iJ4nX2VZxxqIwVK8YtUrZt6dpQRBX71iTBBO2LuCq2WIlSKIs69u1VY496SfZKBML1oSwZwzxkSlS7o8PPeFBtdg8NGdlxADmsIeDzawJtsU4zHsObQtwU2cLvCyMWHrX2vJDTjBc06OngkILQ95w9L7A3NdHe02nvV7gIwrih/3L8QqYWQmWkGQdNx9kMSqPhVdFxuHOz/8LzEr1tFUWqmJbt2Pv6vMFGPl06b+IugUB29KQlSBf2WitX84jS+Y9P7vOEwO5hdBFiJdYoTakKYX72errVVzt5zLRV/kFEDm3N/CaaDt+4plC0+0MGqu+LV/keWyKQ6Lk9Af6+eupT3z2C890sJalo0ZE5zzlIU8tF5ezbNUiXXMuJI2sFnzezsNK2LAiwIsIWY7tTTmDxWU57nzpYOosExrX4yHowFXBM2iXcPhNcx6eboKIUQhSQpX6R3H
 lL/tb/Xp
 aNLu/f4icWDTYbr5vYKV8wQlKYtIv7uS2htq2+epFLxXMN8P1gFBHX44toqOHepNC/BvLiU8s3fWPw73IEEoXanoKSbTYjUtFyh7aYaNOU3GFbqlUI/8Ss6KXxzbj4JR9jYk852EValYowcfWsxYw+4gWK2pNvLgJXf6lmodglocY0aSf33He/28jpTD+TQYKVdrRnQH0uU2UbBXefSMmRhVfA/85B5zqyfedUWyI+x7NH9Rexpg1Z+vgDMIHKW1f6+NG87+lkv4Nmk8ByzF9aMRYeSjKcIvdab39pdGlp8T6dJm+588C5DnfyaVKxKmfWTmWASHAQHyzn2bh2BJgTfZSijtPEk2aqhm9pF0XARRv2iQs4TeqhxY2O4U/o71oQP8e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have a
pfn.

A MIGRATE_PFN flag will be introduced that distinguishes between mpfns
that contain a pfn vs an offset into device private memory.

Replace usages of pfns and page_to_pfn() to mpfns and
migrate_pfn_to_page() to prepare for handling this distinction. This
will assist in continuing to use the same code paths for both
MEMORY_DEVICE_PRIVATE and MEMORY_DEVICE_COHERENT devices.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
---
v2:
  - New to series
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 15 +++++++--------
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.h |  2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index ca552c34ece2..c493b19268cc 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -204,17 +204,17 @@ svm_migrate_copy_done(struct amdgpu_device *adev, struct dma_fence *mfence)
 }
 
 unsigned long
-svm_migrate_addr_to_pfn(struct amdgpu_device *adev, unsigned long addr)
+svm_migrate_addr_to_mpfn(struct amdgpu_device *adev, unsigned long addr)
 {
-	return (addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT;
+	return migrate_pfn((addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT);
 }
 
 static void
-svm_migrate_get_vram_page(struct svm_range *prange, unsigned long pfn)
+svm_migrate_get_vram_page(struct svm_range *prange, unsigned long mpfn)
 {
 	struct page *page;
 
-	page = pfn_to_page(pfn);
+	page = migrate_pfn_to_page(mpfn);
 	svm_range_bo_ref(prange->svm_bo);
 	page->zone_device_data = prange->svm_bo;
 	zone_device_page_init(page, 0);
@@ -225,7 +225,7 @@ svm_migrate_put_vram_page(struct amdgpu_device *adev, unsigned long addr)
 {
 	struct page *page;
 
-	page = pfn_to_page(svm_migrate_addr_to_pfn(adev, addr));
+	page = migrate_pfn_to_page(svm_migrate_addr_to_mpfn(adev, addr));
 	unlock_page(page);
 	put_page(page);
 }
@@ -235,7 +235,7 @@ svm_migrate_addr(struct amdgpu_device *adev, struct page *page)
 {
 	unsigned long addr;
 
-	addr = page_to_pfn(page) << PAGE_SHIFT;
+	addr = (migrate_pfn_from_page(page) >> MIGRATE_PFN_SHIFT) << PAGE_SHIFT;
 	return (addr - adev->kfd.pgmap.range.start);
 }
 
@@ -301,9 +301,8 @@ svm_migrate_copy_to_vram(struct kfd_node *node, struct svm_range *prange,
 
 		if (migrate->src[i] & MIGRATE_PFN_MIGRATE) {
 			dst[i] = cursor.start + (j << PAGE_SHIFT);
-			migrate->dst[i] = svm_migrate_addr_to_pfn(adev, dst[i]);
+			migrate->dst[i] = svm_migrate_addr_to_mpfn(adev, dst[i]);
 			svm_migrate_get_vram_page(prange, migrate->dst[i]);
-			migrate->dst[i] = migrate_pfn(migrate->dst[i]);
 			mpages++;
 		}
 		spage = migrate_pfn_to_page(migrate->src[i]);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.h b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.h
index 2b7fd442d29c..a80b72abe1e0 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.h
@@ -48,7 +48,7 @@ int svm_migrate_vram_to_ram(struct svm_range *prange, struct mm_struct *mm,
 			    uint32_t trigger, struct page *fault_page);
 
 unsigned long
-svm_migrate_addr_to_pfn(struct amdgpu_device *adev, unsigned long addr);
+svm_migrate_addr_to_mpfn(struct amdgpu_device *adev, unsigned long addr);
 
 #endif /* IS_ENABLED(CONFIG_HSA_AMD_SVM) */
 
-- 
2.34.1


