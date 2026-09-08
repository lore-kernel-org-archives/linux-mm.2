Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF837C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:56:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69F556B0098; Mon,  7 Sep 2026 22:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64F6B6B0099; Mon,  7 Sep 2026 22:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2566B009B; Mon,  7 Sep 2026 22:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 148846B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:56:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 96AA3A45AA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:56:43 +0000 (UTC)
X-FDA: 85189082286.21.1AF86A5
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011023.outbound.protection.outlook.com [40.93.194.23])
	by imf31.hostedemail.com (Postfix) with ESMTP id D10B420002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:56:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aDOhnClj;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vgf8AR8nU41qGg9Ak0WHclMBa3GGy6njR91QTF4tAYc=;
	b=FGWD1qsEDpkF/weiNMJm3CyIRJObOHXH5+5f4vaSF7IEsEmiYFJSMc4f/5zji6U/cuEDF5
	UsHThaTX8M1Y2sjAuH1KatxXmygw59lgmV/um1vrhZbV8Cv5MOqTjF1+6FjlxTIFLbETAs
	GS7J3gazzsMRokaRHrYbfDCOXBM+QNw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788836200;
	b=8AmpYVg09wrs6o+GCtHQ4NshtaC7kU+XKV1mA2XyrLgshxOmhUn0xnVklVEDPN4CCPuUtB
	yhGc4jAqAnmDoojVbObqREk4dz+xUbkEyNeNO+Uf7LmIQ9cYQJvGhabmDyx02SlQjXoloP
	dDJjOxcrDixhglILSQJMyFhYhJoTj40=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aDOhnClj;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QZ5hLKHaYzmJkZSLcIYKJ2gJ+/N4E7Ljz8W2kKf+SOtYnLwoFibxJ+OyoYlZRwYorCx2u4VktKelVQ56HW+6lLTH7rMkPEHpZFYOETZXm308oKSLnYBTEjqKADN/izUCYf+0HVH2fDX3jWv4XhGS383/gVAPkzNzZ6gFs88biQ+ei8t71phKXPCBA0VZ2tRbylAUxiVxD5hF/jkYswbNAGoTLwkoOL8IHiZ9GuAV+IGpd+uS/xVNLLcJ33rW3ePNSMZJemOYhPiKwYKp1hH6cPMf6YW3LEZmLWKjAuZmgQxpgRm3G9yzQoz8LvozaHs8/9/z/n+ffGYskJXq2ecZCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vgf8AR8nU41qGg9Ak0WHclMBa3GGy6njR91QTF4tAYc=;
 b=P9DGD2WqumsVeUHRW1wsQabiE4SdQC62RmuTLn0BFQvCWYHGvu7Pm6M2a+dTlVDZCD5qHtDT+FWaTiPvDjcaVv53oAO4FBbnCIWWgsmhpktgU64momMCeW0sLZWdwvVAw8qix2gFt5RFav7isTm/NKncT8zW5k4Ow89HrKQaB5eiFklaLu4vyRU4sJtaqBw8BMyRad2k0eiiJHPOnniDMZgWQsQoX2C0yyttEHkFKKHyDrJ7qOBWEwYTa6XFNuxKV1YlGS8o4jCDeoNGrvK0atuQJRhp3ylNZztlHQ/qefNk7o1ksEWUvGndzmO+EwvqtR5fWqqCMbMJh1bUPt3Ljw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgf8AR8nU41qGg9Ak0WHclMBa3GGy6njR91QTF4tAYc=;
 b=aDOhnCljt+nkoWR04sKhhWlQezDH6t5jOU6EPM5JMpkRft3AU2JVG+vr+Ig6vC5a+OFe+hcCf16TNV2gf0TGjr0sGr+csi1xYdTp7t6UCPVrzfvX7r5bv3p0lECox736zOqYkjAIMtSJScdiW26ucq0A28WBBhRs0o3aCkU7s4AXxv7FnlXDrQcAbbGJyP3fQ0jjsgaufGXjVTTwBRqJQyycoIr8mk82CEotTT/odZQJFiCUL3OvUPwJTGS0L2ww4v8zKZEAwTbUORxsNi9J+4Bc6IW17xlCcIeOOGroj1tSk+b7OJ4fvsgqiBMspjSbzXrnaba1ndekyHJIMGcjjA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4435.namprd12.prod.outlook.com (2603:10b6:5:2a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 02:56:29 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 02:56:29 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 07 Sep 2026 22:56:10 -0400
Subject: [PATCH v3 03/14] xen/grant-table: stop setting PG_private on pages
 for grant mapping
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-remove-pg_private-v3-3-6ae22f9d9272@nvidia.com>
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
In-Reply-To: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Juergen Gross <jgross@suse.com>, 
 Stefano Stabellini <sstabellini@kernel.org>, 
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
 xen-devel@lists.xenproject.org
X-Mailer: b4 0.15.2
X-ClientProxiedBy: BL1PR13CA0335.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::10) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4435:EE_
X-MS-Office365-Filtering-Correlation-Id: 311f21fe-4e34-4094-6a66-08df0d54c840
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	jbSabVQG30RHv71lVYeVvSNmq4tYCclGHpQ7tv4QEmjEItFEMzotKrbMHuoBF6ELwqr9+ZHiyF9B8loNLYGK59EDFDMTp36tIuVT6z8KuE8qEhf6VmH1lmkUSLQTCR/KzQGmn0BkdsMvv2BjIumSIdtFqKfMbYKrEPglyyjCW6dCV1m7BmuX0e3t37qT7LsWEf775QlJK7zxePaNw9YUhXywmgeKB1QS5lWuMkpsdYbD8emlRRDjw7axZauZNtWHl1PikVX/vGGccGiQ5lYqJS3H+Ex57Y8WW7geIaMLqwNV+2LByXWbfF7HwBQkXOKs81DpcRjKfd9adzx8xVWPlo7/X//yiv8bAAnKgnsPRegcfUdjvUimhsUGaHC2qTvWBbOLkRsFvRgs1bNBASwFi2u3anJtEKV+euddny4H2ZSU6iBohjLbFgo5ZMERe9ff/6Lkt0oQOho7rNU0znGOMqh8ERqZLiO6lrhAF4FvtSMV3J13tRmQmZrw+/uAgTJUeAbPUYQstteDqlAV9tKM1+XmMlsQ87pKsO00OFKc4Y0duKFhs47zZIMxUunsl44dw0OIS+sLCkUpqeL5+ccrYCl1eFkU1A38Z71mGH+bg7Yvzwq8WAgTri0Lvhmnm4m+8d9N3yKrV5S+FU3spNC974KlzB4ZIXrlMu8k0h5kUjKxkIeuRujjPzsfaLXA3xtjeObYR7sx29+KnRMbQFo9+w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RzFGbDcwL0c3a3A4a2ZjQjRlT3B5ZFZWOXJSSGJvaXg0UFZ5M2pwV2R0UFd6?=
 =?utf-8?B?bXAwcGdQZXRUSXVzL3d0cmlhbXZvVFUyMEM5ZHpOM1Fya2RqVUhIbWZ1VjRs?=
 =?utf-8?B?cVVKVGR0SndpSTQrcjF0ZC9WaTlVekRXeVBlRTJJVHozeEd1cTB2ektzRi80?=
 =?utf-8?B?QXp4K09TTWhIZklxUzlJeVc2VmVPYXRvNEgxQitnaG9LdFFkb1djUEVoZ282?=
 =?utf-8?B?SXJaY0pCaE82UkxGTTV4Uk0waW0zb0Npbi9NR0lRcmlJWlNjUnRQMm5BcEUy?=
 =?utf-8?B?dkl2cTFsZjdTRVkxYVJ5Tkd1b0JYak0vL2owa0RrVVJJM0NHOEZBUlBVU0RE?=
 =?utf-8?B?MkdEUXVGVXJYWGJFcUhhQmZKZkQ4WUJnTGlpeHlMTE5rcGprSXd1cElxNWtt?=
 =?utf-8?B?QkliQXpLdVZ3dUxuVjRHSisrT0JmSHExN2hIYWJzeitaZ2ZkU2VjdHJ0a3RS?=
 =?utf-8?B?ZFo4clRlM1Bqald2QThOWkc4WHpySTBtcHN5bExQRjQ4a1JCNzVDUmRzejZZ?=
 =?utf-8?B?SUJwZHZqNE53REtxRzNuTnZEeWFBRlVFYlZFUDJvWEtST05rVU8yTjRhVk51?=
 =?utf-8?B?RXE0a0ZPRE9PSVV0dkdMMlE0WmtaMFBrenhTZFRac1NrbXlBT0l2S2s1VXRP?=
 =?utf-8?B?YWtJQWZ1NHhqcFJST21DdmpvM2lBWVRsYjN3dk4rL0E5ZW9XNTJGckdrUzhH?=
 =?utf-8?B?eFhIMnJveFRxOUpLNG9jQWxoZW5XQ0FBSmtIK2F1SnBrY0tjVWkwcmZmQ3pa?=
 =?utf-8?B?VjBkMWNtc1d6YlBrRWlWLy9QM3ptRDZ5dGpIRXJvZG12VlpFSkF3LzhzVFU4?=
 =?utf-8?B?KzBYSmk5OE1wMks5NUF1UEdTWnNpOVRkazJ0c3RjRlBMR3JZMUhpQTBhcW5n?=
 =?utf-8?B?QnVMbFd6Y0dFa0lETGhhTERjQTJOaGFmczVkR3BSNmdLWkZwQmp1MEVnS3BD?=
 =?utf-8?B?THZRNnBmMzZYVVJZRnY3VStrOXdFVmR5RlZRZlFyRVY1eGZEblZUMnZpdGZZ?=
 =?utf-8?B?Q1BBamRFbkNVQzlyeWQxZ1RQS2loTzVob1BFa1V0N2NuWXpwbHp2dHBwclc5?=
 =?utf-8?B?NkJXL1NuZDRKY3pwQU1YcUEvdThqSGhRVStWSlZFdTltcUxqbzFXUTN6V1I1?=
 =?utf-8?B?NFpWWUV2WkI3am5tOXdraFh5V1UxREJpUy9BeEhXUWhPV2RnV0M0NExpaXd4?=
 =?utf-8?B?S0JwZ1UxVmdWOUh5TkJmK0RJaEFBSEZGMHRzWXg3MW1ML1YvM3JETW0rd2pm?=
 =?utf-8?B?MGEzRDVtTGQxYmIrMWltZjBOcmd3NGIrSzVBM2tkanVHNUFXV0VDYUJMc25Y?=
 =?utf-8?B?M1JyUm02K05jZ1BSR2JnanRKTllVRTRNbVlCTytGN0F1MXhVQnVLUmNsbTRZ?=
 =?utf-8?B?K2VlNlR1ZUVBZVVXVG1zTGx3TCs2YW0yeFlhRkdhcEk0eXdLaG4yMml4aDJ2?=
 =?utf-8?B?MVp1VDNGVE1tNnI5MEFQRVFJcWdpUHR4MkUzV3kzU1V5Vk1MQjFERFVCZVAw?=
 =?utf-8?B?Q3Mxak1YbXVZNmYySk5kTEhhcGVMbkpKRHRCVWdMRUFoMjJhelFZY1FKbkM2?=
 =?utf-8?B?enVBSTZlWkd3L09IeUMzQlFmdFE1T25DR3ZKeU9WVDdLUStKVm9Ea3kxbDVt?=
 =?utf-8?B?MmlHVlhGdldLTXRvbm00QlowbWN1UHB1cm9YYVFaT1ZqSEFmSThlVXpxU2RP?=
 =?utf-8?B?dC9XaDNuOEpoUTR2WmRaRjd5RXBPVFVxRS9XZXUwTUt6b1JnendZVGQvUjU5?=
 =?utf-8?B?TlVhMGlWcUk3RWNiZDAwRTBEcFBYYXVuV292RDJ3aStIZk5BWVFpNE5tYmZp?=
 =?utf-8?B?TmpGR2EzZG5tMEtkWkxsSmhobEtVUXdNWjNFNE1vbFVGMjBwRy9OdFIxR3hQ?=
 =?utf-8?B?SWhuTXMybURZYVpMbDdCTW0yY2QxVkpPdHAwM2JDUkJvY3NpZ3I0YU04TGJD?=
 =?utf-8?B?YmJ2ZkhGRVZWY28ycnVmamsrL25FeFhNQklpTWFwU1kvdjBTVE9GLzNhcWcr?=
 =?utf-8?B?cCs3cUJOQ252ZmZqazlmNWdCRXJxLzZZYXdMVFppYThCWExMQ0dNOUo4eWFa?=
 =?utf-8?B?cTFDNituUDBPSWJCVmtrdWZuU0N5R2JBK2cvWXZHRWFIUjkvSlY0bmQwcUEx?=
 =?utf-8?B?M1pKRmVXTFpSckVMWm9hMHp6dW9VK1llaHM3cXZyRldpSWMxUEVncWZNSWs5?=
 =?utf-8?B?YVNNYUw2OWJqbG16ZitKL3lUL0k3ZjVwK2NWdU9IRTBWbHdUWkYwL2VWcEpW?=
 =?utf-8?B?bE5tUjRJcll6MjRYT28zT3FBS0swY1lZWWRjdXgrV3Vnd2xNckM2Uk5ITzJH?=
 =?utf-8?Q?lBp7EAf5XXWIufUjfY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 311f21fe-4e34-4094-6a66-08df0d54c840
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 02:56:29.8638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2QlM/uczXHjWE7PSdJaYLIQu0dSp0UAjugrRRw4tmD2alv1B38aHLz0wjbAg2Vpg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4435
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D10B420002
X-Stat-Signature: fsctypauxaa1scwom3cmz6upq3pdayyz
X-HE-Tag: 1788836200-721744
X-HE-Meta: U2FsdGVkX18+q/QxmYbiZFaPfjwdEiKj6e42l3p58KScvTmqyGDfiePb8E0e/BR73tGZKHaj9xdpBQzLhGZX2XxHyNf9gpocgNGAHZRVpWV87wuZ/NeeDroMKx/P012mu2IcQkMvxO0cuhXgxj3IkxXclOYeiD8VyfG9eOtn3hnI2Y7tfLWgiPkRe6/AeUHExt7f8O2eyDVZL6DFxjb5YHig/veFZyhFfOVtapfkN/xPQhIxM/m8vo51wMIDyWLtVAa5Trmrd/Gl5R00JK73SYdt/ehhS/eTdX+NGX2NbSOMiomo5klaUGdKg1f+wav6JSS43Ifxo2Mb8V3IhYzBpjXFI4kIPBKg8D3qUUqvzeELcysGprpKbO7b6pgkIlEdRhAaM9T5flBo8FYhMtEPc4+ftz+UviLL+8ZMGmJpBnnkWXMnI+aQc2+Y5LZCJGyWq4kBTycO0EYic0FDWj/5o7XqtgliThfWmJjMGmTJ9cgZukC0QRIf7TGm9MwfRxazviPst+BV4g7FLTLQg7IRJ7s1jULkfeSyqmgx0apUl4y9wYlyobEmlTjHr2GRr6+9qO8+ctwb73h29KH5Au8YT56QIa8HNo7knJUIz7C6Iz6EI/GCxd3kpW9DaESsMNdbGPWMFQATQjWGx1PEwinY2VuCt4qrBnZyOOdjjx9CNiR/qBGjf/XqS1DpvkfQLcQ5tDThecuuTdDEFiDztIAES7O4wubxQGDaLV7IupAcO6l/jkAcYMaxTf8n0Yur7IP2D3r+bKFF/aW1tfI+kQ7DAmzmKwj2eXGPHJAjsfuXp6KTIl/3mpJl+cpFS2VLa02NEfTXlmVbPQwbe5iXt77MB5Ozt0iL/qcmjZP2zcebXHJraO0W/FtpwicEmAW4b7pZz25gU/Cz22f1Mt3/ZRG/fgTKaz6vs6XO8O5lUCAfG1q7YmtxS7kggeHBXVVcR+Y6Ymvb1NGi+gdd+58/sj6
 TqorQzU+
 rOqRe1GcmElQrL+5I2mNnrlRdZmgh+ZvLk0KSJxV3OTNERXGY2boqoH1y4AR97XDqC829ju+ViBBip0NdmHaT/v2x0pamhqLTBgx44uvQmY352JrV/2zuinQFq5AqmD3eVK4/OC9iuf2sh28YlcVLBp0V0vA4jmj8f6Bpw0hD8iAwHAx9+ywiSgvuaWqfw44nYAVEqzznucix0LQ72GMWYkSbKubQZf2k2eAkuvTVnpvUxhV/6XnbhWPOyZRwUtMCHyVDPbxKhhUB5sTKyAzTPSTLLrjyqvo9RuXYt9CmG1YP5VlSNC0uKYQGz95QK2I2KCBvglR039Mpb6xOTo+JXQDNDx3S/UJOVKlAYzh/shIvvaBbYRP3hhjI3r6XC+6bfRA7XN4/NXH67ENHNBzpUR79kbAdl5AJ6QMHd2chjDl36VGMb6U/K2XzJAd8+xR7DTfNfSfknmWDpjZbz7fOm1KKG5PpBxS3d+Q+BFKhVVHdxcdu5NrbIM8SGFsk7Rn94kWn7iguMyozZ41dCkoD9tTbh5AIcgqVe3Mmuo8I7AXAk0ZYbX/2nHP4HH1204rAVZbphfTS9skMO1OqDAQt6pf5ywCCga9EcyJP840gRP4nNdg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

gnttab_alloc_pages() stores xen_page_foreign in page->private. On 32-bit, a
pointer to an allocated xen_page_foreign is stored; on 64-bit,
xen_page_foreign is stored inline. Checking page->private != NULL is enough
to tell whether a xen_page_foreign needs to be freed on 32-bit and
page->private is zeroed unconditionally on 64-bit.

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Juergen Gross <jgross@suse.com>
To: Stefano Stabellini <sstabellini@kernel.org>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: xen-devel@lists.xenproject.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/xen/balloon.c     |  5 +++++
 drivers/xen/grant-table.c | 11 +++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index e7f74ea7cd5eb..fdb18348cfdfe 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -182,6 +182,11 @@ static struct page *balloon_retrieve(bool require_lowmem)
 
 	__ClearPageOffline(page);
 	dec_node_page_state(page, NR_BALLOON_PAGES);
+	/*
+	 * clear page->private before giving it out, since it might be used to
+	 * store xen_page_foreign info.
+	 */
+	set_page_private(page, 0);
 
 	return page;
 }
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 69922be28b54c..993f89f048e21 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -863,10 +863,10 @@ EXPORT_SYMBOL_GPL(gnttab_free_auto_xlat_frames);
 
 int gnttab_pages_set_private(int nr_pages, struct page **pages)
 {
+#if BITS_PER_LONG < 64
 	int i;
 
 	for (i = 0; i < nr_pages; i++) {
-#if BITS_PER_LONG < 64
 		struct xen_page_foreign *foreign;
 
 		foreign = kzalloc_obj(*foreign);
@@ -874,9 +874,9 @@ int gnttab_pages_set_private(int nr_pages, struct page **pages)
 			return -ENOMEM;
 
 		set_page_private(pages[i], (unsigned long)foreign);
-#endif
-		SetPagePrivate(pages[i]);
 	}
+#endif
+	/* Data is stored in page->private on 64-bit */
 
 	return 0;
 }
@@ -1031,12 +1031,11 @@ void gnttab_pages_clear_private(int nr_pages, struct page **pages)
 	int i;
 
 	for (i = 0; i < nr_pages; i++) {
-		if (PagePrivate(pages[i])) {
 #if BITS_PER_LONG < 64
+		if (page_private(pages[i]))
 			kfree((void *)page_private(pages[i]));
 #endif
-			ClearPagePrivate(pages[i]);
-		}
+		set_page_private(pages[i], 0);
 	}
 }
 EXPORT_SYMBOL_GPL(gnttab_pages_clear_private);

-- 
2.53.0


