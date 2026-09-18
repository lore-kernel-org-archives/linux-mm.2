Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF153C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:41:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FA7A6B0092; Thu, 17 Sep 2026 21:41:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AB426B0093; Thu, 17 Sep 2026 21:41:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779FE6B0095; Thu, 17 Sep 2026 21:41:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE20F6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:41:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D4DD14050E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:41:56 +0000 (UTC)
X-FDA: 85225181832.27.382CB7A
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011033.outbound.protection.outlook.com [52.101.57.33])
	by imf05.hostedemail.com (Postfix) with ESMTP id AE435100002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:41:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RXn4OVEy;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789695713;
	b=dK5tbTpFZPPq4PWA8D7CTqGPGPnil/l3hU9FQh4ow9028EqXiOTz1Z/6liH/EFZHti7uEg
	+jAexZF5//87k22CLg7N5TQ3bnAhN122lr74phtatMcWi/hbKRH93e53O1BhhydZqWZs0s
	7RGF4k5DgzX5zJQpzbWvnuQThpniadY=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RXn4OVEy;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789695713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z/WTC3cPvJQR9oV7HuuRV1dhz2Xdf7s8w/uglsOZvrg=;
	b=BqpjMXtIGUye7oVrXuHijJXpSu4wxF6CQCyIoB6MwErn7WUEus7Bp2IV6FSukS2xVzXiqW
	cGlCDf962gNTUw63veTZBCCaNt9QnsCeUcgOsa2YfCjLRzvCUzJFPCl38RoytgjCfMpGyu
	JFoxmBno4nSkuCLnTjNQViRieJFHVyc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I0H1lUnB7a0cYAbwjcbdg38z0PPEfe3W4ohq8Pwf8lyD+mXylypnTvMucWNe7bHCr6xvq/jF9wOTK2HVZOls58nsi87QKDjoBIEKuiT9h6bImZ/MfxWCpIUiNsbD8OjxIzgAlQf6RUm3rRXSdAUZ/Eoyc1TrENHIy/5Uv+sDQw1qkxAuEV87KnTpxjDG8lxtkTOJkW9SomTTflLjnXr+wfOk4Q3nFLPfFTDakynJcTs7p1FwQzwuO9XhCgyA939Rxi9VgprMPHCEaZtAQ9XkEuyk0W17qNxzUYdMLbXv5lfOiirpVP7va+0ur4nkChIeklqh+E2WCuLnuIBzmQbiVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z/WTC3cPvJQR9oV7HuuRV1dhz2Xdf7s8w/uglsOZvrg=;
 b=dsoMEL4oTSlCb7bOK8SEqC8jpNGV/o32wKLDRMZlmuf3pc67mO4lqgFlhNPofRixMMmK+swXGl93tX9s7SZnnF8OmNpA0BzTKXUUNkdK96+u1zJCDhCofsYc8T9IptiIqYDSeFPfpdO1z8D+SFZeqr0JOXU+t1Ny45poD7T+VTPpy9bmwB1mit07aJcaKLV9S1N1mWdhAggkpfPDnJEgaYE0CJOTGFM8jwMFQkYqf5M7dJhmasBNXC6vyv11AFMbnu3XmypVkJ5BLtvnIqUifX19zRNz8E4ajTHSvFAIJKERxTq6yKyNgS9gRjbeItuYuX9s+3jaSIuhUMRgxMzUzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z/WTC3cPvJQR9oV7HuuRV1dhz2Xdf7s8w/uglsOZvrg=;
 b=RXn4OVEy1VcomS0wOvfJXgnqbILjp53RUzC8GPddWBZQ4Bye7hG1rfwEEtrxNBFcFRy5bg+tt6nzrp/QVagCnL812ISq/8AZzLbb5OV8hKKTe1fgT/PigaATHqSpTjYydgED4I+l/qmAHV0hhSeuR7zgWrFN8qhP1lgbCskrc4WduiuPDivsM99IwNy/kTud+tb4fyjgOG/J0t9ZRIm/E/zoWMRyC7swYOoYGzXbLeiegIQSwAcwL7wYWVRzrUke2Qxe7ocqEEyuZWk8zOiC/nJ/hX6t8EcuWJShpnscZu7agIDgDIgxhbfSVi744x7GiU09aoMlPDhxi3wKvgBfRQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH2PR12MB4261.namprd12.prod.outlook.com (2603:10b6:610:a9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Fri, 18 Sep
 2026 01:41:48 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.011; Fri, 18 Sep 2026
 01:41:46 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 17 Sep 2026 21:41:43 -0400
Message-Id: <DLI26G4YSWIO.E52DKMAH6ZSG@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Gregory Price" <gourry@gourry.net>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Kairui
 Song" <kasong@tencent.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v4 05/16] mm/hugetlb: use direct assignment instead of
 folio_change_private()
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Oscar Salvador"
 <osalvador@suse.de>
X-Mailer: aerc 0.22.0
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260913-remove-pg_private-v4-5-848550f7574e@nvidia.com>
 <CC279633-6F0F-440C-BCDF-1D5362C4CB7B@nvidia.com>
 <c7a5ff0c-126d-4762-8b04-5897da09b8b1@kernel.org>
In-Reply-To: <c7a5ff0c-126d-4762-8b04-5897da09b8b1@kernel.org>
X-ClientProxiedBy: YQZPR01CA0168.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8c::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH2PR12MB4261:EE_
X-MS-Office365-Filtering-Correlation-Id: d429d0f7-c941-4016-58a1-08df1525ffea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|10067099003|56012099006|4143699003|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	n1VpvE6/F/Fdbm9prxSXr8eyUlomrQTIA6VBfxh/WQchareTC8X8yDMh+4k5TodXmS5Xh2yYa6KFshDJL/RAatCgfo2EdyWgoOK09/gSJLt3C27eEvxJmEQ/lazvgWBier1ZV9p20Qp0e8/cQsdTBObDDdgT+iLpHdbpAlzzHLWrIU4NHoJxAIbmsIkWkl/CRWJ4GJWlHOZZigCij66z4h+QlX/tiGgOrPlmCI29UoCxOpZoOpwCXGXAPhfCgIaZ433830fevxBKmrQ0MESH7jpa/5v6Dl4TGfl4UQ6AkMYlo76AkXEMnnbifoYdmaYuMI/D8C0xXOTZFq3mJs0ycukHwtv9A1dIBefe+VuP5CioF9rnJIx48jYIMsD9CZjO/u270PBTTml+jdozUhU1MZBF1bFD0LyirYeeKWrkVV3ShCQOTxX/0+qQC0EoQ0NbaLPUfE1L1LckMOj0OYFWxnuL10xzhLaCE8bGHKUUsr+bCgfwMt092w8G4+v+NfKaJBqGdzofdFlR7Hc6mcRRscmIXuSWqIV85UIY3MhLl/MBShmjuF718UivNFj0YS1Di/n7gFgiRObHLidHX6eWWjbY6yUwieGRKjez64wjUceicgqEWMAqYdSFDCFLVYQijk3O9SiVKGw1+YwHaMgGGz7SAJbJGUuLI5pIUjdPGBgPRzwf9Yz4Ga1VgtAkM4qq5HL7TU6PdnLtHCdBy5FBgw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(10067099003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXVkWXVNR2tEWXZ2T2NHWTZ3M3BtOHJ3NUVuS1VhMkg1Z2xTU1FiNHV4Z0xp?=
 =?utf-8?B?bW1ZM1pSQ1J4ZjkwNHZwTmM1ZHZlcFAyalJEV0VWamxvNEZxUDNFdGkzQmVa?=
 =?utf-8?B?SDU4dUZtWXQycUVvZkhydkY4Y0xVQVJ2a0Z4M3A5NWJWSnZlTlVXanA0REdj?=
 =?utf-8?B?ZFhjNloybVZITWV4ckxMOW5ONzBITEZ6YWV2RzBwcy9ZYmNDZ0tXUDRtRW5m?=
 =?utf-8?B?MVRWTXpNc2pLZTUySXQyenBneGJBT1ZteU9lMEhwRUlMVTlxV1dKRDI5R0Ur?=
 =?utf-8?B?MUxqRzNIcHEvRVVNeTExWUVCL0VqTFBTZTc0NU1kK3ZaQjl3NHZacm4yUEZp?=
 =?utf-8?B?cHNUTy84Q01Cc0I1OUltY1BjNzd3MlQyeVlRYlJWYzhBZzRWbldKOFBFT3hQ?=
 =?utf-8?B?Uzd3WkV2a1lzUDI0Zy9XZThtTkkwVFJ1RUJ4YlJUS3RCUDVXVWY5aG1kRW5k?=
 =?utf-8?B?V290L0VlZGVkQ3kwTU1rUElycUdPdzFscmM3Q00vak5YZGRtMFRKeS80Ny9i?=
 =?utf-8?B?bS9DMUh2czNEMlVBdkNFdEZTL3NWeFZ1NmxuUE5ScktTWjFMZWZldkdjN1dT?=
 =?utf-8?B?UFJQaHQxeWk5elU5Tk5Zdm9Rc2RUNEZBNW9STEVKUGxNZFBoNk9hTWdJYjI2?=
 =?utf-8?B?alE5ZEdZL1R0ZkdqeTBMbmVWNll6eDRnSVlVUzRNNjVpaS83RXZUZHFBRFdD?=
 =?utf-8?B?OVVwMlZTdzdDcnBCd09Wd2pCRHNzUmduL3VUd2JqZysrUXF3dHZhcFVJUXlq?=
 =?utf-8?B?QnY2WGxIV1lrN3k5c0k2SzNtSE0vUzNlUC85bUFTRkh2ZGNldExYUUtyNHpC?=
 =?utf-8?B?T0JJQ28zR3VPQnFiSXdXeUY2MkZONlROTUpxa3ZsdVBlamhoalJKWjRMNHJY?=
 =?utf-8?B?bG1tcWVXWlNrOXRud2VveHd2VHV4cGw5ZURtOU41S3pnaTFXOHZleXZiNkp0?=
 =?utf-8?B?TmQ2TDNHaDJ4VXNGSUh3YTRkR2hYWnB0QWlhRzhJYUlPWXczTEQ5MzQ4cTFr?=
 =?utf-8?B?SUQ5TURCWU5odzJCYmFhZzEyam9JM2s5OVVad0RJVUlvdjhqWjNCNXhWaDJp?=
 =?utf-8?B?ZnZHS3RDTWF6ckdHanRDUnRFU25NY2pCVlRpMVp6bTVQM3haVG9jRmY3Z2VS?=
 =?utf-8?B?VHRzUUxlcVVpWmxiOUZtbjg0MEh6UkJ6Ny9KMTNUUlFqMEw1Ynh1WWV3NjBG?=
 =?utf-8?B?TWNpTkdGM0JDcHB0UTNEZElPblduWDl4WStuOHI2TWtQK2Y5QnNIVG9WUkFq?=
 =?utf-8?B?SWJBbk81VWF3ME1qTlJSRGxsR1B1MXF4UWNQTm9RQVFEb0tITDIzT0VtRW0v?=
 =?utf-8?B?Y3lYMXFPL3VvSGVDZWJPc01qNnU0TXYyMjdycU9nN0YrN1BaRXNtZDVnZmR3?=
 =?utf-8?B?bFNCUEpYUjZSMGhPZTYydCtvaVVkOURNYlVZdXo2aHN6eERVeGhwWmhRd0g3?=
 =?utf-8?B?L2sxTi80d1dXMXlYRWVIcGJXUk5zcVIrNXFVbVJncEgzUWdabHpWeHZZME0z?=
 =?utf-8?B?UTZYcCtmTXNZUXg0aktQNUZ0ZmtlV0g1aTVnc0xSeFpnL3dFdlNacUZtYXpY?=
 =?utf-8?B?SENYOHN2VHJ6OVF6blpvc1Y4dUtYTURIWkRXQ1BNQ3BIRHF5L2xQbHJWUFRz?=
 =?utf-8?B?MTBsN0gwTDkyK1VYQ1NVeS9EeGI5NU4ySDdIb0JBWkV5STJpc3RncFRnVEU1?=
 =?utf-8?B?NUJpZFRxWmxWSHE3a002QjA5M1hmbkdsVVpmQzJ6T2N3RlBVTDJ6RmlFWUVM?=
 =?utf-8?B?T0dxQUs0RDdiaHFiaThhV1FzSFllc0ZSRW9pNUNibmFVSHhzL2szUGJNSUZ4?=
 =?utf-8?B?cE5QRjJISExlTmFLV3MrbjFidDZzS3FhN0cwYUtVRGdQS2IrOUJUc1RtcUdO?=
 =?utf-8?B?eEZhZnJKQTg2OWpMMVd0N2lxVTBwYTNPVzdZQTZOdGF0R0JJMXBzbU8rNWI5?=
 =?utf-8?B?eEFOb0Z3UmhRakJXMzYrOWVLWlZibFk4VEFJRkZCRzBQU1NUSlQ0M3p6YTQ3?=
 =?utf-8?B?RWVtZEI1S1ViSm9tSGgzb211L3hjaFpuTVZFOGFCOWpmWkhiSCtrdzUycEJo?=
 =?utf-8?B?K3BoUER2aFVGTFFnb1A5eVpqMkRTZEpwT0JTTzNjeDBzWVNjYVdCMDBsenVD?=
 =?utf-8?B?cDZhRjhXT2hNcnFoQW4vL2RjL3UzUjlacWV4dGI1Wk8yc1J1aU15VFhrYWhG?=
 =?utf-8?B?K2RLSkhRSklFOGtKNWhFcHVmZHhqeG5pcDhkbG5JZ1cvYWtVV1FRN3FReHMr?=
 =?utf-8?B?QTJnalFvQVJ2bGVub2pRajZvcmN3bzJSUFJmSWRMWmI0QnF5VUlBRkNLTjdV?=
 =?utf-8?Q?IJRvNBIUPlDfgMffoh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d429d0f7-c941-4016-58a1-08df1525ffea
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 01:41:46.2928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gImkg9UW5/AbUyT7i3ZrMW8L30E1InJroUKmeAc4afkncbrWfp4g/Vp4P/KihlSA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4261
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AE435100002
X-Rspam-User: 
X-Stat-Signature: cyo9us3znd71y1ii1wqxws9uibwf1x71
X-HE-Tag: 1789695713-872778
X-HE-Meta: U2FsdGVkX1/bzqNGZs5G9Kuflv8kPSbCdDWChqTBOp0eyVJ30TUvWyOLjUpvJchNog8inn1OvxsMY2XZXudEatUbSB4yx3B5OMkVQurCm47bxJrXSPf3tbKoRfxoOXM1jIGnQ0u91zynUWTrzP2O1jUAQ4Yy0MkPEVKUinvZjKCo8bHXOAFZMTa0FXsBHfY8/77HLMkER4nVepprzJEJlptu3m4WVBNNAnxy1Zn2lPU+LZvEUmhLvPT0I5sPdJ1Q4jdfX67boDiG5eFDkr5VrEAdBvL9SztniUICXcX729MzPcxgbqZP5cdqOX+ebJ8m8QIhO24ysF4GikX+v2emu+5DzLK+5EB95aSW6ib7cJMLiXaWoCe1jg5mC0QuknAksfeKBhciwpo8fkQjDBOfH26+J+S9HUV9lbefSbLfKL4aVDBqqTLpU2qgedtMEWCel1i+AZ1CrC+k0lnWb2zcMjDUa75cnnt+1LIsNwMJdsEwrrRMxhpluUpt7bsnYME5sBGhApxUMoJEDaX0jqv5FLIMicvRdP7yZXGEeu8jDPx52qX3/cCal6sg5kCHLC6/kaKf9qS7UUWgewB6IyURxC4C2HDrkEj6j/1KvXyBSy0iBuua5D+4312s3R4U07dhStCzbR90vaSvlFcP53d3n99S29ZSvnn0FGo+uEQr4AysWy2ddDTXV7aLdbbr+Lj3adS6eG44dJoMegy0bI4Jq/0lfEbIObQhwo6pjFrHlfpo4Hc5vQ2BdCjHgJzAMJ0dJcSJexcYFGeZ+B1lv2yvctN2OqHikgr4o8Yzo9kpYR7YSxLiwR62zWcl882nk0S9KP1q9AP/NsHYGCqt/0eTZo2UeCi1weMxvO9rMUN89dlyrAdFfZ9YohsxCS7gznGPy/OvoUHUOFHhquXNXHWQBniRcEFAEnWF40NvNz04xv3CuL/PtbI953DFx19A9vpxsJYoXt350XwkaeUDWU7
 I48Kjz2i
 hgk2PLsvbguFBRF0HyS9OvTWmJFEWiUUNujmngX1QGE4/omYbGtgdJXqYisKjht9VRbIOVZe6hw78LpQW5rGkp2dfeslz3pc5fQXfy6xknXqyFQi0GR9EmfJeLG1i0VmcEsXXm97ggfcDi+y4QtSe+UrWCkx+u+R7SpEoWzc+tBRlwHlcbCLRnHZj95W1pfDE4gqczjGh7YrT0CJkHeRIrF8cj8djmBvxmGSLg5OYqM/EkvyoLnkal21eeAyFmfx8TF8Y154U66BSDWzsNZohG58CVjPTQS93WGE15g6fPUUAfJq65L8wC1n6a+nKR2ytcffHHAlUqeMQm3Tj9QR5lNByc8vBM9eYmqk2OCqGI4uFJr8dxxKInss1GBywNJE5odPbQDbV9VMWz0dQvR2IruD8cs7LodhJkKUQySA7+JSOQWTVnQUBp6oRdzhiEgZTAblAHznj5UCKlDjmejSHc0fHaYto1OFWRCPfJPHWmjlutjSl2OhsnuiR0LCXpABVkurfZNZEltf08H5UDLsLkKBs3XkCUfhgQk1qIWFuYM3gpuH5qWO2j9asDT9baLSNmxKu0B7BY4D60FIuYU0FcjPNoiEXQgpuGbCYOcGhVf7N8v1sLtGnPsnVoyM6QYe9PoZR5+ozdPjai/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Sep 16, 2026 at 2:12 AM EDT, David Hildenbrand (Arm) wrote:
> On 9/16/26 03:56, Zi Yan wrote:
>> On 13 Sep 2026, at 22:24, Zi Yan wrote:
>>=20
>>> folio_change_private() should be used along with folio_attach_private()=
 and
>>> folio_detach_private(), where adding and remove ->private content requi=
res
>>> folio refcount change. add_hugetlb_folio() simply sets folio->private t=
o
>>> NULL without refcount manipulation. Change it to direct assignment to a=
void
>>> semantic confusion.
>>>
>>> It prepares for a future commit that remove PG_private.
>>>
>>> No functional change intended.
>>>
>>> Assisted-by: LLM
>>> To: Muchun Song <muchun.song@linux.dev>
>>> To: Oscar Salvador <osalvador@suse.de>
>>> To: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: David Hildenbrand <david@kernel.org>
>>> Cc: linux-mm@kvack.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Acked-by: Usama Arif <usama.arif@linux.dev>
>>> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>  mm/hugetlb.c | 7 ++-----
>>>  1 file changed, 2 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>> index d3a0650ff6905..8d551cdaef9db 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -1446,11 +1446,8 @@ void add_hugetlb_folio(struct hstate *h, struct =
folio *folio,
>>>  	}
>>>
>>>  	__folio_set_hugetlb(folio);
>>> -	folio_change_private(folio, NULL);
>>> -	/*
>>> -	 * We have to set hugetlb_vmemmap_optimized again as above
>>> -	 * folio_change_private(folio, NULL) cleared it.
>>> -	 */
>>> +	/* Clear all folio->private flags except hugetlb_vmemmap_optimized. *=
/
>>> +	folio->private =3D NULL;
>>>  	folio_set_hugetlb_vmemmap_optimized(folio);
>>>
>>=20
>> Sashiko[1] said when a CMA hugetlb folio is freed but fails vmemmap rest=
ore,
>> add_hugetlb_folio() clears HPG_cma. It either bypasses
>> hugetlb_cma_free_frozen_folio() due to the missing HPG_cma flag, or
>> skips cma_release() and causes a CMA memory leak if it is free directly
>> to buddy allocator. Sashiko also asked if HPG_temporary should be preser=
ved
>> as well HPG_cma.
>>=20
>> Answer:
>>=20
>> Missing HPG_cma is a real issue. It can be fixed by checking
>> folio_test_hugetlb_cma(folio) at the beginning of add_hugetlb_folio() an=
d
>> setting HPG_cma after folio->private is assigned to NULL.
>
>
> Maybe we should just simply only clear flags we actually want to clear ..=
.

And it turns out to be a clean result (see below). add_hugetlb_folio()
adds a hugetlb folio back to freelist, so prior operations like
remove_hugetlb_folio() should clear hugetlb flags, like HPG_freed,
HPG_restore_reserve, HPG_migratible. HPG_temporary is only set in
one callsite in free_huge_folio() and is cleared before the folio is
passed to add_hugetlb_folio() via update_and_free_hugetlb_folio().
HPG_raw_hwp_unreliable probably can stay, since it preserves poison
information. The remaining HPG_cma and HPG_vmemmap_optimized are the two
we want to preserve.

Muchun, maybe you can chime in about the patch below. It can be a
follow-up patch after this series.

Thanks.


diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8d551cdaef9db..bc772954e5685 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1446,9 +1446,6 @@ void add_hugetlb_folio(struct hstate *h, struct folio=
 *folio,
 	}
=20
 	__folio_set_hugetlb(folio);
-	/* Clear all folio->private flags except hugetlb_vmemmap_optimized. */
-	folio->private =3D NULL;
-	folio_set_hugetlb_vmemmap_optimized(folio);
=20
 	arch_clear_hugetlb_flags(folio);
 	enqueue_hugetlb_folio(h, folio);
@@ -1736,6 +1733,7 @@ void free_huge_folio(struct folio *folio)
 		h->resv_huge_pages++;
=20
 	if (folio_test_hugetlb_temporary(folio)) {
+		folio_clear_hugetlb_temporary(folio);
 		remove_hugetlb_folio(h, folio, false);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);


--=20
Best Regards,
Yan, Zi


