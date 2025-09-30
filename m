Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 431B6CCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 14:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 636E98E000B; Tue, 30 Sep 2025 10:28:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60E868E0002; Tue, 30 Sep 2025 10:28:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FD2F8E000B; Tue, 30 Sep 2025 10:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3DEBE8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:28:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5207140727
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 14:28:39 +0000 (UTC)
X-FDA: 83946147558.01.03C8E4C
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011041.outbound.protection.outlook.com [40.107.208.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1CB7114000F
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 14:28:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MXykD2a4;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759242517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xcxnqPwkOV/Ukne/2LS9fWen1M89DKiQXJSfhbUJsiA=;
	b=TyNYuarzVlU/ctTvH+y3wk8MOMGKXMd55AzdpREdgZ/EDcNpgnfGFNnwDV+XO0wwo02sXD
	HOM1Kl3zKxG/Xq/v9kMJrC53UFwaYLAlSE5Q5oqhZbW2mGdDuQkGBZeCF/7rgE4nRkjEOr
	AZ7nN+aU0MAuJ7+4Wgr/QmDo4ssGs6o=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MXykD2a4;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759242517; a=rsa-sha256;
	cv=pass;
	b=dMnttCvD0fLA6y0Yzz6rLIWFuRjAEvGv7lr/OjuFfOKJ57bsedylNypXDbdRz88ncC7xLt
	JXGnLcU7wplTpqedbAZT7q1sa6x8GlZnGIMXaU75ceHhfe3FJ4A7iVz9TZF6FGyLGKcWPd
	FWsDYHfcVKz5xTeJpYcOZw9OnK2uTic=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LN+0yW6gZJpPWNYWAJk9Bg+CmLOTop6DbnbjVbz8YRDyxsLOqTaAuhfqO2SZxV8dTv0wNN1CkT7Clgmkm1PvK65qSxcs2NoCabhG2u0eVlycxzdnQkP2TOL43oVp6Pio9SiPfK0/yNsp6rlTLUcU1xD9yOfbidjF1VTl9Fh4HFCp5zYHdp72ZuWvqKwMuwrdPp1LEzhylqi13E903j8PI/FvpJm86rPL2rDF542/y3ye2SVlKfySzCVjxrrwvT0LH0avyRxgxRx9rJ181/edilm5JaN5oAOMtip9DIOdJipt+7l7RMkzvdrkgV5QeFr1PDL+csrvocVUQ9fIYgYItQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xcxnqPwkOV/Ukne/2LS9fWen1M89DKiQXJSfhbUJsiA=;
 b=PtKVSG/dgyfqZ0paLHwv8UMzwvR039MYdKA+uwiCmOf6z2dK47f8Rk20kFhdA2dLqGkRnYJi7zkHvh+gvxQgztG6vEfuja2hTaSht3uL7e8OyRl77IuNIY/uynfrP+jEBJirRv9QvmIGoFHnb9t5mooRHlRsgO7KPLgJ6b9RAIPcXlYVk1IiB3nmiMlDn4tr85UEPGI09y6sU7mPH7MivZB4vmrNzJH1tXqkA77xe5a86/PplWrvz+OdCAk4Rlbl8SWOS2rnSHyKZG995oTiGLYm8Bk+7pIeEri5JZT8h09GN6YyFYEvy8Pl5EeMS+oEm6ptlTC3I76GtcscwjsKNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xcxnqPwkOV/Ukne/2LS9fWen1M89DKiQXJSfhbUJsiA=;
 b=MXykD2a4CfZgvvmOO07v/a5G+UujFwkGjxuFEmex8hPfkTmZN2NRGH6lApcqlKV585wg9UwpcGHk66Kh89BHihVzsJq77wrOYnq8WNA+yCyUiheunlYUi9BftvWfpINMKEy0iI2XkP+Un8Kh+8Ohv4oBtBL+q5j2l2zarTOL2KGn2SbhUFY3lKyfy//Yjztst3NdPoWI2v9Vq+kZc5AAaWThnAXskEPS8TUy8d6odiiHhhYq5fEPFkNJc8vu5giTdlm9PBvAy/t+uyxwYiEnsNul5iQjFATvtBZ95vIbLMls8MUtPSrg5A+MfYG2PAO8KPAObOh7oGsRePaXeec/7A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB7526.namprd12.prod.outlook.com (2603:10b6:8:112::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.17; Tue, 30 Sep 2025 14:28:32 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 14:28:32 +0000
From: Zi Yan <ziy@nvidia.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: zhongjinji <zhongjinji@honor.com>, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, liulu.liu@honor.com,
 feng.han@honor.com
Subject: Re: [PATCH v0] mm/page_alloc: Cleanup for __del_page_from_free_list()
Date: Tue, 30 Sep 2025 10:28:29 -0400
X-Mailer: MailMate (2.0r6283)
Message-ID: <F1AB428D-73B3-4E40-939C-2A7BAEA1E73A@nvidia.com>
In-Reply-To: <6fa0e2e3-045e-446f-8ef3-955711b6aa82@suse.cz>
References: <20250925085006.23684-1-zhongjinji@honor.com>
 <6fa0e2e3-045e-446f-8ef3-955711b6aa82@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAP220CA0020.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB7526:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a8d4420-5d07-4294-d0a1-08de002da1a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VHBQVmNFZ3BnNitIYVZCV3N6UktFc0dQS25nR21XYUE5b1gyWXVURnVNNFhT?=
 =?utf-8?B?NHpnRlVKVDg1cWt1SVBYTzZZUzBqVFpJZ0FkWnh4eE5udmVPaEhGOURHOWJw?=
 =?utf-8?B?OEhjeEE5M1VnTFozZUNUVk9PQVFoVXpPWkRaUlZ3VnVwKzUxK0hwSVFRRUxa?=
 =?utf-8?B?SGM2Uk1NaXhVL0tBU3RkSU9uVzRVUVJrMXlkaGZ5N2g1SmdGNCsyaE1UdE5j?=
 =?utf-8?B?OVMrWkRGaTBHV0E0Qis5ckYyODlYN1JvdjRCeFZBNVVRanBKRHJ2SCt1T2t4?=
 =?utf-8?B?RVhqaTd2ZTVMQ3dpUFlqVVlJZEJBWkZuYXIzMjBJMEwzclVwa3lTbHZvTjVQ?=
 =?utf-8?B?YnhVZXVDVXBqbzlTb2QyV2xnNlVselpWa1VFbk85RGtNTWRxWG01MFFwY3do?=
 =?utf-8?B?Undoazl1bGtocHA4M0dPeGdxM3EwTDUwcjJpN0Yxazh1bDhmamRhRUxCY3Nj?=
 =?utf-8?B?Mk9BdjY3ZHg3UW1hZnlQb1BQMFJNMXpwQjVSOGhFRzZGSVlCNmxUa2w4aWdn?=
 =?utf-8?B?K2hhZXVoOFVKRTJpaVhoZEI4YU50ejN6SzA5bmlZUTZBL1h4eEFUY3E2dlZJ?=
 =?utf-8?B?TnhxelFUWFA5WSsydGE1aUtLZVFhYU5HdERMVHR3MDU2ZndNRW10ZThlNFVL?=
 =?utf-8?B?T2xzRGtZb0FDNnpiV1kvYlUzZmcrWHpxM1lCcW40NVNkS0xKOTVrb29CeTNQ?=
 =?utf-8?B?QXZ2YXhQWnVnclZ0M2pYeXpvdmhOcDI5OEdsSGFja0cvaEU4QUxjZURUaDR1?=
 =?utf-8?B?cC9YcnUwNUs1NXBld0F4ZkdCYVAya1gyS3RyZFlTbmFSMEhXckNsay9TT2Zh?=
 =?utf-8?B?OWJ2d1FjNk91dVp6OEMwR25PblY4UG96VUdRUnlXRG04ako4UjUyUWxBamJh?=
 =?utf-8?B?a0QvaHlPREl6ZnJqck5yQ3V4cXJXa1MwYmlTRjlROTJlWGtkczdxcmNPMXhO?=
 =?utf-8?B?WTZIS2dYMmpneU44V2JHMEdlUkdTQ2VGNEFkdGVuRTJHQlFwUmJrd3U2aGYv?=
 =?utf-8?B?dzlIZFBmdmszNWRFVndiblFEbmd3YVNCRm1JRXlaNG11THRRdUFucERWN1l1?=
 =?utf-8?B?SkJTOVhXYjhLbHU3UUJMMnhkQjVaZkJaOGxpekE3cGQ1UUJKS2VpOFlFR0dm?=
 =?utf-8?B?MHovMzAzbFlIbm5GVHUwalJJYWh5c0k3ZS9FT0RPUUUxS0NwSVFWalFSMTRP?=
 =?utf-8?B?bFJnbFlOcHdFdDhWZHFKelByUTlkZDBGVmFuQUVmdlcrNWcrcm11TFlZL1Nt?=
 =?utf-8?B?b1BxRUxhTEZaNWxsTGMzOEhOQk9reGMyMk1CMy9USm9FR29NSFRpeEdFMGc5?=
 =?utf-8?B?WWxyRjd2QkY1VC9BckVzUlBzTER6QWk5TU1wL0Q5SEtBQ2k3MlZCejdiZ3RV?=
 =?utf-8?B?V3liZlB3M2xIYXlHN0tmNGZuUzI2d1RoZTFUVUx3Yy82SmhkWjhTUFREa3Bq?=
 =?utf-8?B?NmVRV3ZWbHdvb3N1Y3huRGhlNUpHT1JaZWRBcGZtLytrUndKbjZyZlZCYmFR?=
 =?utf-8?B?VUtOdkFSVjZwTUI3OTJrNDVPRmlFcnA2RW5FcWp2dHFwdC9Ldm5UV2RGanRm?=
 =?utf-8?B?NkNJM1dpV0ZsQXF5UUQ2Z3FrWHo2MytZcHB0R1RhdEExWnNGT2E0TzFsM1J1?=
 =?utf-8?B?aWhCOHZYczFzWlBkUzBqRXhvdk5weFFiWmdRQTJkUzZGM2FvbnlqcmdmenFX?=
 =?utf-8?B?ZCtINDBhK0tBUXRCa0orZnMxSDhsSG50anRtVG5QM2ljUUlxcHM4NFlqQU0r?=
 =?utf-8?B?TU1nelVVekh5blpTU0tCOFIvQlp0Y3UvSXZnUjQ4QVNacTJSUmtub0c2Wml1?=
 =?utf-8?B?bC9PSm5aWjkxcHF2RmZzOGJreHBSeXFBV3dLRTdnYkdiM3hOazAxa2kwUFR4?=
 =?utf-8?B?NVAxZWtDWHpOY0dZcGFJUU4xeDBuUWxRbHRNanA3ck0zUUozeTNGN20wZC8v?=
 =?utf-8?Q?Pf5ODU2Wh/0dh/2fVvgI/34IjwTHkmEp?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z3lyU2pmZTRFVzFwQ2lRRlpNM0FzQmpyUVI0UjJDb2dzVWpGUHF3Z1pzSUVt?=
 =?utf-8?B?aEpWTmtGUlFlem0xeFBFajJ2V3pJcVNYcldrSU9IVkRjcjBWWGF0d0dLdCsv?=
 =?utf-8?B?anVZbUtoRG9hcVJYRDJZaTBVNHRoK1loanNaN0lhT1BPd2d6V2JjZzl1eExL?=
 =?utf-8?B?NzBWOTllY3BEeXEwTFF5R216L3pnNWR2SEJnYzB1L1dmN2QvcEhWRER3eGlS?=
 =?utf-8?B?S1hMekZnV280Yi9hTHh6OWwySjB2eHZGajFKcVJOQ3lTU2hHbWo4eTR1aWJz?=
 =?utf-8?B?RjhGU2RnaTd4dHRlRUx5RDkwZWtWdTRtSmFTQWJUc2dJZVRFc3lIM2J2ajFr?=
 =?utf-8?B?bzV3STdmSTdVdTJEbzBBQVR2ZmZuT2crOS9pMXlTdHBjZk1Helpsa0JCVHVP?=
 =?utf-8?B?OGlXRzloUnkyNXdpR284QnpMeHpHUS9GdE9rVHNSRE0wZzFtNjhNeVhsRDl1?=
 =?utf-8?B?ZkdoeTBVNEd1N0FHdC82bXFrVTI5MTBBRjltbTM3TDFQcC9XcVkzcVJXckQ2?=
 =?utf-8?B?MzZKMG5obTF5R2gyWXlIYWw1TDFFNklQd0MxT3ZZTHRBbXZmODBzaWc4K1FT?=
 =?utf-8?B?ZE1RWlNHYmF4RXBURmlIaitZbkdOdkVsSWpEVGR1Q1Y1Vit2WUN6aHZyVDMw?=
 =?utf-8?B?dDQwZmozM3RGclNMeEZGTnFmUjJiOHBTNlE3aXhjSUg2RE1jWTlsWkFjY0ZQ?=
 =?utf-8?B?OWYxM1NXWkt0VHJyK2pBQkZ6TVFPWjF1djZVUGxUU3pnZWJac0dxSlVhSGJy?=
 =?utf-8?B?TmtSMS9tZGl0OXRkZWZUMzJtK1c4cGRSc2pUQXJTTmR6SjRGUFdFTElQajVx?=
 =?utf-8?B?WGFWbVlWMHdra1hxZkF5emJpVHVGS0NOcFk2WnlxUUZlRmtsSmdxbldONnFT?=
 =?utf-8?B?U2JyTWUrNG9NRXRMZHZYRWJ4a1RxbFNSUll1ZFdNTmZyS1NNdU1maEdTWUtR?=
 =?utf-8?B?Z0ttSGVUOVhVVzVSWEU3QzYzb0tNR1ovR0doeUdjbHNXUHNPb0RRdGlkVlZX?=
 =?utf-8?B?RDNXeFlBVm1GNkU4MXNMNCtEN1RrWlh1cHZmRGVCMlZUREgxSy9zS2NGQXhW?=
 =?utf-8?B?ajNzZktUSTBLNTdEdllZUWRWamxBZXVTS0htaWdXSWpTSVkzbXI4S1NFaTVV?=
 =?utf-8?B?MkRmcmZUQklrbEIySithaFgyaFc2UU9GYmhoY2lhSmQ4SGtNRnhDNUtEK3p3?=
 =?utf-8?B?K2JnUVdEZ3d2YmEvTjVtck9OcnJZdkpCU2lkUTF3bnl2Ty9zV2tBWkI2KzBR?=
 =?utf-8?B?SjIzbzhMOVZIdFF3ZjN5ZlphR05DampBUTJmRkM3MEdwZXRmZlA4V1hadUow?=
 =?utf-8?B?K2MxTVhSMFhuUWU2Rm5BU0hTb2VRS2VwK1lDV2E4NHpKVzZDRHBRQ1VLTTRC?=
 =?utf-8?B?UzZ6Q256OHoybUFGdDQ2Y0VMMGpzdXNOYzQ3UDJHclIzSWhObGt4VTl4SHRh?=
 =?utf-8?B?QzA2b1hRUDR2dXNMY3NBM0xNVXFvUUgxdUZaOW1mOGlsRk8rMGFVWFBiUFNW?=
 =?utf-8?B?QllvY1N5Rzl3ZXdSYlJnTjR2R1hyS3Z4M2U4SDN3Slo3R2ZXdk43Q0hkREZH?=
 =?utf-8?B?Smk2aEF4NXc1Vy9ib01GZzFtV1IzUEhTcWVPSXNjMVA3RlE0OWpkeUN6c3Zx?=
 =?utf-8?B?OFlzalRZN3RFYklQQkY3dzJFQmFiNWc5ZFgyOEpJZlA0SERrMWZkZjlOSTFk?=
 =?utf-8?B?dU1QcFEydjRoWjNtNU5HSmJ2SkYzQTd3RFN2MFJvaFlaNGU5N3cwZlVKNkkw?=
 =?utf-8?B?dWIwNmhxaDJqOVcxQlJ0em1JcGVsUE1DVVhiUEg0clIxcngwSHVCckI1SS82?=
 =?utf-8?B?bk1kN0VVczIzekVuN0VRU09MSll3ZmNRbm8vSkRvVEVvdUxTam53dmthdUZ6?=
 =?utf-8?B?L0wxWnk3M01ITlhNVjJBd1F4NTNKSVRQSDBQNEx1ZllHRnlaNEErNzJJRnlR?=
 =?utf-8?B?d240eEs4ejhEa2V5dTN4czJxN25LNGxYaE1Eb2RJSUxSL01qZTFXZjdsTDNn?=
 =?utf-8?B?UXF5NlRyVFRLd1QwblFyTitleTZwSGxpS2RmdVp2dEJDa2d6c0tsc2gybVRS?=
 =?utf-8?B?WjFGSmJGdFpBZll2OFc3MTZCd1VLcjl0LzN6aDNCNDBHbTlXTGlyQm1mVTRX?=
 =?utf-8?Q?sQIemqbu4/lETww88gJiQRxUS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a8d4420-5d07-4294-d0a1-08de002da1a5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 14:28:32.0146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FXpvJtNv5oEzzIIMXhnn/lR6KkXoPsp9eui0MZL9qNHEs/kddqap1okZ68+oCj+Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7526
X-Rspamd-Queue-Id: 1CB7114000F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 8d1djcrgun1pe3jusk3wz7ur189wuw6d
X-HE-Tag: 1759242516-100653
X-HE-Meta: U2FsdGVkX19fOsM1WqYBq9aySJ1ibzDJbCQdCTA0G42/TYQot6uSQWsmGQMYTWluYetGkbFxuMLBe1SiwE1glUq+FtoMMQw7ANPnswD80R8iwWqVeqM6HnF5h+vtX+dRcy+yLUttuv30dF9dnph4R4I832+M6R2FFTOTToBdO3Fwl0ZZfHjofo3WG1z25xBaUAd+qteiVuGBAvt2saEsnSBAahF06h88X6HuAa7TCHdDu+siNMIdyEZEUh55sr7Rvl6ZHVdfniySlOM8oIH1t1Sv52d/UKFOYSuoDzFJCm2UgySF2EsS+PViT1qvYdgFHpBTxu0ksPFBevj3gqjg0jWDJccwd0DQ81bP1cuIEPTNwhoElDKyOU51tMlH94HFhwlDl1ZsUubJ1eLsl+odu9UZ5aTZOAXHH5Fy9MpMe2YYBh+v6tDUu4hemz7SY7rAQ1vKrFZ/POv11eyxszqgk40uWnRS2cxGCJ+p+RM6psLAKZQSNM9iYzxiS804rf3T6hq+X6LrtDO+KI4HvD1eus8wlSOCoDlRZPoDyYDPwmAYD3BoMv342vZQy8SN5ntTsDtQ1k/NFvZ/cRtEL3WL+U8zFH/WTYL4zW7vVxhr9Ps9G1VwRFDSpOhF8i9A419YzjOqqMhvsel18My800MqYoA+M7PFtSOWaVT0mOZWZ8izKHaPV5gkysw0WBdewcBftpEqf4EGNnLVz7nOEfSKIrg7A/ZLqajqcsr+ZZ6SRsm2Dgv6YJk78oi0rFdhtvEMAI0Izfy/jodA7s+c3yJ0cWZTS0tPxmdGs+acMEbGgvDrhdqKqM8wdJnY8JaZ3PuoknnYw0xwaLmqEUr/2PcC7UXBjjf1E1dt1cCdp5MOE1gGqCiQYZxk3r8ZkaVxl0dAyA9hxiVNtKXo0r1pGjiKDeTQigiCx9aQPW4/SKdqucHKIwX1tVZmaBjJywPASsO5R3cJLL0ZapaFRz7iu2X
 y3hlsKGW
 Pr/2ri4a+BJj1oBa3iYUWTws13VBwo2mOGtSorYsgMdeau6y2mOnnnyqsfa8sId+qX8zBBbDNqJpr45nKSMQCv6Pr6s4aIGL0LarIpasP+ZYA8ErtpRL4PLUgW8DuZGCy3JvzTKNwN8EUb739Yvny1Ix3cBruL3fZG1nYAeDi4DNIjDrOrcg+brOv93p7LokNjuoWWxl7MAEYvTDyu6Mz35Ljqk02T23q37A9FeJz3CuHSXZVlnIs6RJulIr/2aYDdQNxUn7WiLhdA2DGn359DjVxv42daH3uHMRl8pq0DUKo61tIhyEqZNmdpbItHXrgyzjXqzjFtJOgJz+qkzX9BUicvg3ahkqEGnrP8C0eTgZRZIyExZ+4+GH0674h7aS5lcGpXP1X9XzL5dy7Xdd7fIfeyiAdrS40UDFhzevc4R0oz88OE0uSKJCtSyoPin4Wj3YrQtGKviUnVLPlIQQKFjlih9WTFI3aa7x1Mpl0xprvpZuy024sZB6JneVfp3rxYwPZLAXEawQ386pfDqhiYcF+8kO8I420UJCPT33Nd4xZDy9cJhcEpFvAi1rAlUa6Fb7P5C21z0GiiM3GdZFpjkY9RcVgoFthBSeJ8Nho3G5q67aAPjIvPn3iBQuhoWTSbEhv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30 Sep 2025, at 9:55, Vlastimil Babka wrote:

> On 9/25/25 10:50, zhongjinji wrote:
>> It is unnecessary to set page->private in __del_page_from_free_list().
>>
>> If the page is about to be allocated, page->private will be cleared by
>> post_alloc_hook() before the page is handed out. If the page is expanded
>> or merged, page->private will be reset by set_buddy_order, and no one
>> will retrieve the page's buddy_order without the PageBuddy flag being se=
t.
>> If the page is isolated, it will also reset page->private when it
>> succeeds.
>
> Seems correct.

This means high order free pages will have head[2N].private set to a non-ze=
ro
value, where head[N*2].private is 1, head[N*(2^2)].private is 2, ...
head[N*(2^M)].private is M and head[0].private is the actual free page orde=
r.
If such a high order free page is used as high order folio, it should be fi=
ne.
But if user allocates a non-compound high order page and uses split_page()
to get a list of order-0 pages from this high order page, some pages will
have non zero private. I wonder if these users are prepared for that.

For example, kernel/events/ring_buffer.c does it. In its comment, it says
=E2=80=9Cset its first page's private to this order; !PagePrivate(page) mea=
ns it's
just a normal page.=E2=80=9D
(see https://elixir.bootlin.com/linux/v6.17/source/kernel/events/ring_buffe=
r.c#L634)

I wonder if non zero page->private would cause any issue there.

Maybe split_page() should set all page->private to 0.

Let me know if I get anything wrong.

>
>> Since __del_page_from_free_list() is a hot path in the kernel, it would =
be
>> better to remove the unnecessary set_page_private().
>>
>> Signed-off-by: zhongjinji <zhongjinji@honor.com>
>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
>
>> ---
>>  mm/page_alloc.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index d1d037f97c5f..1999eb7e7c14 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -868,7 +868,6 @@ static inline void __del_page_from_free_list(struct =
page *page, struct zone *zon
>>
>>  	list_del(&page->buddy_list);
>>  	__ClearPageBuddy(page);
>> -	set_page_private(page, 0);
>>  	zone->free_area[order].nr_free--;
>>
>>  	if (order >=3D pageblock_order && !is_migrate_isolate(migratetype))


Best Regards,
Yan, Zi

