Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0115C982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E09F86B0096; Tue, 22 Sep 2026 11:30:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1BC6B00A0; Tue, 22 Sep 2026 11:30:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA8F96B00A1; Tue, 22 Sep 2026 11:30:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA31E6B0096
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:30:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3DC9912048C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:30:52 +0000 (UTC)
X-FDA: 85241785944.28.82C46A0
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012056.outbound.protection.outlook.com [40.93.195.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7057640016
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:30:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=b2efmT8y;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790091049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I3bJw5nafa1wI3g2LIEOR/oFpcgmnVxHCgT1+flvaiY=;
	b=f9Ly1RVNSSa5tMURfDj2j74ydMSDpB5nZ/LfU7UgOuBcC9EdFkBx78Ghg685egHfEqgCj7
	WPawGU0QsP7Z14T2ACAk1BTbShOpSrVJ94Ux/HLETV+mNsfvM74cQo3Mr1MWAXtSNoCx3D
	XiwsGoj1BbqQ1Fhw0MH5IgibgOlas0M=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=b2efmT8y;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790091049;
	b=ZqJD8fsmuLFShmdOcYJZeq4LDigm/xDS2V4wKnFBA9Te3JtO/NFZbm9eIuqyMD4m6AB7Yq
	h5Klp+cWtVVN8keDQIAc9OzjabfP7m6EoolzwKJCoZVSJo/4x2yL/0LJ2mpI4vWq9jiEOV
	/fSSTxKxEft+LYRcX3IKBXnD4fAQSyc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p6quWvb2rG4gcjpusgYHQXCUV0NpD/MKVaYlLCXx6oYhAmV8oGfsmjpNjvXNlOKYjSzjPxwssN4GqBhoArTiw+2uV48FkOgphY2avrPgXc28eMKwgQ35sA+rbZkvF7MmsNutSnbMXQq3hZm/C20MlSfg1pvtD8WLEyXmPlUdwEdDHH7lA22VkQlFmFUb80/dumypAH7reLlaD4kMQQP+OXGXfFpBWb2hXC0zWtMQSiHYaki60m0LbAjbRIWNcN4NP15vGT2nZ8X7Gae/I8gJCK5nH3UUdqkEmhq6zItkPzhf3jXLsN9sJwdcK97nlzYHS62vmjN5e6N90gkS436t3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I3bJw5nafa1wI3g2LIEOR/oFpcgmnVxHCgT1+flvaiY=;
 b=FUpm+nHhzCkBhuqEIgK1AN+JVPnyITUBWXjZi62o1Zqag6J93cUuAIuGvplRrKiJTSeORmQmkBFkH4NetCjJ/wr3IPqtzmsPmtdqBHAPo5XoADUrgrFlgqoWvHJ4FoPvh/5iNyLw50jnit71mNDIijpTPN9wXtztWqFoAzaydydOiByHanqrNrIew9TTouUQ/4J8TYaErYIBedC30W/KRfuRr/AKFJgeRxmSqhaQUd51reic47k4aM7qCqcAEG5M4B3JC4furt/y6SolKPlYhqCfR4svkbJ/YN+yoIl8+vWv7hr8h00gc8KeM73cOOrimi3/+1aTEjiEdIGARSBjug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I3bJw5nafa1wI3g2LIEOR/oFpcgmnVxHCgT1+flvaiY=;
 b=b2efmT8yWviN9dC5yeYc2IhhGIpotyZeHyGcPfmhCotj5jk8+cTP+Bh837IBBF0K02iy8R1hMWQliKVF8sgtgCmlFv9JFVZw8pM4VF70lzCl8fIKxLkf5w/H8dWt9++cdHpClUmjujYjOkRIO3TcSXpLB05PDnKbIKI5MK+2nfWFpL7Kp8MDkm1qDsNZm6H0pCVzTjZosaaO1PYLlE4ZLOQQWdxMneGTnAHYZz+Ca6OKwd7dy9EDXMzXumiffPARYFpLDJAYt+aRLjhuQJELH8T7ecDnZtV6XTEpi7R9pK6OkOP5YuRaI628XntZ1X2QE7bpAP/anALI5mIbR/ZOgg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB6935.namprd12.prod.outlook.com (2603:10b6:510:1b9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.13; Tue, 22 Sep
 2026 15:30:41 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Tue, 22 Sep 2026
 15:30:41 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 22 Sep 2026 11:30:36 -0400
Message-Id: <DLLYB9MM512V.1RWURJZZD2EQR@nvidia.com>
Subject: Re: [PATCH v4 2/4] mm/truncate: look up the end-edge straddler by
 index
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-ext4@vger.kernel.org>, <akpm@linux-foundation.org>,
 <david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
 <vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <hughd@google.com>, <baolin.wang@linux.alibaba.com>,
 <willy@infradead.org>, <jack@suse.cz>, <bfoster@redhat.com>,
 <joannelkoong@gmail.com>, <djwong@kernel.org>, <yi.zhang@huawei.com>,
 <yizhang089@gmail.com>, <yangerkun@huawei.com>, <chengzhihao1@huawei.com>,
 <wangkefeng.wang@huawei.com>, <yukuai@fnnas.com>
To: "Zhang Yi" <yi.zhang@huaweicloud.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-3-yi.zhang@huaweicloud.com>
In-Reply-To: <20260922110703.468389-3-yi.zhang@huaweicloud.com>
X-ClientProxiedBy: CY5PR13CA0036.namprd13.prod.outlook.com
 (2603:10b6:930:11::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB6935:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dcc4889-60cd-4e1b-e764-08df18be760b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|56012099006|6133799003|10067099003|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	/ZZasgp1740XBB24l92SNL5M6Ak4lFgL9LkhiSTSa4k7yHE6cqlUAI7UeYZE4mmQcwNdH1SqVgsJEU+pOznVa1mWH+aRlr9zHwryIDpEAzc8x4UEV8HN1XE/vKeFjEFLTHKwCv/KssIFpf5v3U9cWhqgoFG5o0B8xUoj10D70/uovWkRGP4+FEDXh0h/K/tQhoQi0grZJy6MG/ro46H3IxoUymRhPNf9iFn8inUIIsftsin7dA/XkHHecFCYzH58DMnRl0HoDCGzVQ+n3jQPevYBUlYc+BAor8hyoacEgdIfQOE9H4MBov5pUA6P4iWcJjtme6GDBr6VSpPDcWMf7ytVczlET3Hn5+HA0uJM92BeDvBH/PnFjPdQIvzusEdGKwm3n/yNuprArmKi+ozyxZNcKWEpXhco32dHljfncAqW5N90OSXT5y++wv9hFI3XlVm4RaDuixdpbTrP+qps4Q02K5h1Gs5BLUCCnInARUN6m4ZpS158qotTa8ANp3WMXXzsD3yW4meapq7+u69/xlYxRz+mO8raIWaQ0xZORqrDbB3eRmmRlXA5UJpvUnbbfMEeuoDOddpF+KeCGuOX8DpIRcaE9474QBpfYu2AacGrYQzCzSXosQatA6dfSzfyyRrTGIj265rBLc259gPjzSVJ8np4xNuwXF34vfP+Ppc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(56012099006)(6133799003)(10067099003)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vis0VHNNTGFqUlhUdnZXM0llSGRLOThhSUJzQkxkWnYzakhOc2NjTEdUNHpV?=
 =?utf-8?B?Uzc5ZnZ5aHJzSHJ4b2dhaWxpMmcyNS81aHVpTHZvbTQxcmNIQ2hnelFJNkdz?=
 =?utf-8?B?ajMrZEdoQ1FKNFdTVjFiQXdPNGluUDR4ZWcrb1ZoSTcwTSt2OWVEV2lXeWZs?=
 =?utf-8?B?TzNabGhmV1oxU1NLaXVLRGd0LzBTaU9RNUxxSndMeXRwdGhjL2tXRWtaQUNx?=
 =?utf-8?B?ak5HNnNFWDVqZG1wd1J2SlJ6MWExRGl5YS9yZzdkRFlpYmRSZnZIOHFEa0p5?=
 =?utf-8?B?dC9TblVTMEJlQ3NaMHdrNWhaWVdZZXJrZjgwY2lnemZWdm9HVmk3WTNyMkV6?=
 =?utf-8?B?TzBqWnZEZmRlMkphUUMyYUhyQ2wyeExuc0JxNG9FNTNmSm1veGd2VEY5b2oy?=
 =?utf-8?B?OWpzUnU3OWFZOUJyeDRXeXNZWmV1OE5OVDJiQXQxTmwzNFI2dVZLT0ZLS29K?=
 =?utf-8?B?Y0UxRkhUa2RPRTNDYlJXZmk4aUhGbXFjM3poMmhtNURLODd3SWtBa3JvcFlI?=
 =?utf-8?B?Szk4aDBPdjY4cWRqN28wY3dsb0VaanRrMU1VLzlRWGgrUmRxRzJqcHErM3J2?=
 =?utf-8?B?VnY0NUJQNUFDN0hKa1JMZ2pxRi9LMDI0bGZjMjN4c2ZQMlVOelFIb1NCQXVU?=
 =?utf-8?B?VDdWc3F4UHp3ZGg1YnpHTGNNNk43ejNvRXdmMk11U2wwU1F0bVdvdFkydHpw?=
 =?utf-8?B?WWVzWGdVMXYzVEhJQVN5UmdvZW1Pbkg4dStHU2w1VndjYk5Zd3lpcmJmK2hi?=
 =?utf-8?B?VWh6Vk5DY3dpYUxYRVFBRm1OZ0xlYVlZazBubmw5dXFmdGhUbXBRM3ArYmZv?=
 =?utf-8?B?Q2kwRy9kSmpheGFGdzdOMmVlN2tZak1wSThyY3g3RDNMVU9nY2lzZlM5dWhk?=
 =?utf-8?B?VXpGekpYbDZjdDJBUkx2bSt1aVRXak5hU09oa3pMZVdDRHd2MEdwcG1XMFVS?=
 =?utf-8?B?NER0UWxPZy9ldFVaSEVzL1Fwamp0amlXM0JXa2RqR2RaTjVHd0JjOW5rRVB5?=
 =?utf-8?B?SUgwNzdOS0JWT3BxS2pvVGwzdHhEVHQ3M295U0FIUXNoWFh4MnB0VjhkUjIw?=
 =?utf-8?B?cTJlWGJEMGkwQkkwTU96bURBenJaclpjOWV4L1ZVZmJVUVVwVXpIV1kxQzhE?=
 =?utf-8?B?SWxaOU9DeUgwRlUzQ0R0eGF6dTRqcUZaSTRtQWpoQ3FWMzJjeTBqZFRabWlL?=
 =?utf-8?B?WHRtQVdQbXFSNUgxcnZwdlVNWFNQWEZwZEhYVHZpU3VwODFyYlVCM0d4SFlP?=
 =?utf-8?B?a0tNRTdieTdFMThPSDRKbjkrVS9OMFprL2hHdzg0cm1XeTZtc3cxMm5BNmhv?=
 =?utf-8?B?OVNldkJCWDA4QkhOV0ZLRXQ2MGV1OUhLSlhhcmN4bTV6bDRMMGtzODd4bElX?=
 =?utf-8?B?aHg5OFRTWFZUOTVLWTl0eTZXS1VqUjBkeS90ck8zb1haUUFQU1VoMHBlZGRI?=
 =?utf-8?B?ZHMzaStoUlkwWVcvbXBpeStLZWR1cGFVSFA1SS82R0hWVi9vaVhSU3Q1SWNP?=
 =?utf-8?B?ODBJSVd1aHBWM0YxY1BBa0tKZXAwQWdJRXFSbzZZOHY0Z3VvSDNseTVaVlI4?=
 =?utf-8?B?NWFsd1Y3MG1pTjR6dmZ1NmI4WWRCWThHR0tRUmQwclR6OE5FaUEvcE9Iczhz?=
 =?utf-8?B?RlkxOVU4Qk5vNDhDZ0RXRVAwdXZnOXZxaDNFckhhNndCeWo2d0hEUDAwOWo3?=
 =?utf-8?B?ZnJ2V3l2K0d6UlNCTWd2SnNDSTlQL25LSmlNbFNDbmxhWTdaTVFOckRjV2U1?=
 =?utf-8?B?cnA1QjNZVVZiTDA2VGhzSjQrdEQ5ZkF4QUtPL2V3TW9kR2tUVkREYTE3TTZJ?=
 =?utf-8?B?QXRZV0JyMWIxbWtMcE5yUmYyVWNqZGlZNEdKZ04reWIvNm1Qcm5kMjZnOGVG?=
 =?utf-8?B?b0Zjb0VaTEw2Y2s5c3BiaUFpbEFKamM4Z2NoWWpQZUozdzEwNkxaVStvVXFr?=
 =?utf-8?B?TmJneUc1SVRkR2ROVU05M3BjemtLdHV3ZlNScThHK29PbjkvMDZDNTA3RURI?=
 =?utf-8?B?VDFYV1dNZlhkNHMxYVdZYTZPQWhiYjY2TEZHc3BIMlduY1h2OWhXeFR0Yjlm?=
 =?utf-8?B?QXY3LzVQVmdjb3Urekd4ZzF3VEh5RHdkS2dDZGFwMDRNWDNObXhLSWxHd28w?=
 =?utf-8?B?OWJ2ME8yempkZW1SU2J1eEpyc2hpVmlBLzRvTTBjdzJuREZiQTdXT3dQMTlF?=
 =?utf-8?B?dm0yL3ZKbTlhV0RiVnlkU1NRdjdiampKMEFOTmJuS0ZhbDRPMUhROFhUdnU1?=
 =?utf-8?B?K2VqUlZRVjNzcVVwQ3RSU3hJZ001S0h0OEpMQ0NvWmxWWVhzbXRsamNmL3h4?=
 =?utf-8?Q?Ha0S2CDGUydxhfe5HM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dcc4889-60cd-4e1b-e764-08df18be760b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 15:30:41.4634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fs6zFBuHlMwe9EcJxC5W3GKN/tTUYI1pOTDSZM43XaoQqAyOfYiGcxgOO9A6mujI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6935
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7057640016
X-Rspam-User: 
X-Stat-Signature: ywu3od46t9uqqqni58jcb1uxb4az33dc
X-HE-Tag: 1790091049-736910
X-HE-Meta: U2FsdGVkX1/xlx9RInSbuGEyuC+7qHI98GS13rKvHItO2Kr5YKL1+kwHgcn+7UoTPnp3H4KINgIVEgu2NzQh0uvirlRihxbFtLwWxqilSPUge0BeeMMD8J4D7/DQMHTjKdaZVnZyJa78/svRCegkKJsU1tb1JRmzaHnSpqW1IVNww1/JN83tputRkTeNAZSyUDMtAw63aOIKb/TAuMM/NkVFVV4WYT5CR6j6Fxg7dk0CyNCJccD1yT2rBvokul2wA0c9QGVKIePa3N14QbS5EY7auy1Xo99V8PU2ikjDX1ZMFx/k1Mzt9dCS3aypvipMwbe3tUzA93cZVTy8SvBMYWkjQnlKYtaVC5w5lK45fFh710H/CGlxAuza+fMgMsrO8cx/V1BJ7xgSz3oZLQzz+SXSjlpVtacU9CM9i3Twshi4wroc/llGIcVx33oJP9o+rOpeWNVXDFQD8Y/yHPwGpwaiMOUKHUCWd/QGP060nKdX06+Hdd4jfLJ+B/hYgX95kMvAWypnsNw1U32aYFvPKrKZy3Mb2uCt1OXadVzTtIwoI7+7z5HOUWEeXfFRri78kKOxPj9JwOLTOLElLlDFZPh3DVUCBNnaFoI4xEbAJMPLV3jGQXoVlHVGp6Du+tqufovx148OzibU+VqZWRSBNY0JSWIUZDE0RJmZdm8E6WVgmIYtNEVPyDzrWAyL2IAXehzzhYaakE65WR1iKFxOfHIW4TbsKf2TJcEumOyL/oa69QH/hRSznpVPNvEs1EDD8u2WqZq5kF2fF4TxYVGNvHA0erEGPj/pahxSa93NetIjHqQ5RibzSF8Oi8Wyh49oGMckhFrN5PFP1OB1StErNg6UMOpTvCXYIbTCBdp8AwIDaRlUfnIVbmOv2yh0ytqAmiWFFNLbSkd7hI3acPAbboYWkkfk5/17EymLnnhbCOn3Skf8u24qIVG/8BkCi3+KeDsjrpOYLcYZFeqwYEL
 2cK2ZIRL
 dblKeWE0kV40kOy6qdqxDK1HngVmm4Jjb9irBmsXA2WSjVx7eD97l8Huy8HJPsY98m+urzPMal1C5iP5PCMhHvclH+uKs+xOkL85E3CJteqpOOzP79s+13b8fKg5BhCO3Xbh+q2fC+qjwU9g9Yfq1LsroMoXCsXZjjKQ6TNOsR9DJexYjrWSil98gmvNKRoo8s6jaXJARS0obUoVvhvxW2VYkRpKdEMUWGvGQGoW5gdBGZtdFTGwbItWvsuPT/Wukegv3U6AuiK7aDPcjkrKqXV4KCj0cGXQWUS0F45IFG/Bo1oUV7ywahwopWzk/Sx3jPe4j2LcPNsvu3W9Jf6/ZEa5JEQBa2WTl2Pj3DRhO79wQCCUTF+6EsjnoJOQN/lokc17gGppddmc8h8nvfDAnPgAE7SFjUZ+RSQhmtXaP2qXigtMWRl1t4fp5ZroCAbcjy3L4M0zWkyGjBzCVb4qzYvQi0XCV1WLLR0UZB74Xi9iDbLPcyoxfhQo4zy6MSA7s/Wbq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Sep 22, 2026 at 7:07 AM EDT, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
>
> In truncate_inode_partial_folio(), after the first split at the start
> edge, folio_split() unlocks and drops the refcount of the after-split
> sub-folios. The sub-folio straddling the end of the truncation range is
> therefore unlocked and only transiently ref'd in the page cache while
> the code still derives it from a page pointer inside the original folio.
>
> Between the first split finishing and page_folio() resolving split_at2,
> that tail page can be reclaimed, freed and reallocated as a new large
> folio in the same mapping at a different file offset. folio2 then points
> at a folio that does not cover the end boundary, yet
> folio2->mapping =3D=3D folio->mapping still holds, so the stale pointer
> passes the mapping check and folio_split_or_unmap() splits a folio at a
> wrong position (or, with a transient refcount, a use-after-free window
> opens between try_get and the split). __folio_split()'s own
> folio !=3D page_folio(split_at) check cannot catch this either since
> split_at2 has been reallocated as part of the new folio, so
> page_folio(split_at2) resolves back to folio2.
>
> Look the straddler up by its page index instead. __filemap_get_folio()
> returns the folio currently covering the boundary, ref'd and locked,
> with the mapping validated under the lock, so the split target is always
> the real folio at the end edge.
>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/message/20260916094500.C30061F00893%40smtp.ke=
rnel.org
> Link: https://lore.kernel.org/linux-mm/DLGXT0ERY79Z.3C5DYVJVX6S9Z@nvidia.=
com/
> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operatio=
n")
> Cc: stable@vger.kernel.org
> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  mm/truncate.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
>
Thanks.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


