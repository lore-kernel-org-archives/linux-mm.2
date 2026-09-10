Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 238B1C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BE026B0093; Thu, 10 Sep 2026 08:22:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395806B0096; Thu, 10 Sep 2026 08:22:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283FB6B009B; Thu, 10 Sep 2026 08:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F26206B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:22:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5CDE41C24EB
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:22:00 +0000 (UTC)
X-FDA: 85197764400.10.6E89801
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011032.outbound.protection.outlook.com [52.101.62.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8588C100010
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:21:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kM54kR5G;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789042917;
	b=hKk9G5LGdPPH8TIZIDjlbVdKkoc6F53k3Wl1NCYoXM0OcaPSxJMQpJcXhOsu73NGzMRUSq
	efefpFfnqhw/ik9m9Vzg0FaPP/v0wuoRvhE1bsZv7xvoSZddPMgaWdhjQDmaEPYM4Wm728
	dhW+IWK8um0VIfYkTqmRHrpAD+j9Ans=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kM54kR5G;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789042917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Se4HlPyGVigrGHnWPlCoT/Tt6qCSfO0pnPQmufzoLRw=;
	b=128EsUOkjpZqDPreq1sNLkSV/tnymnIVDf+1fRa+DjlsX4mUevFZ/+4tjt0IxlO20Nv7Vu
	k9hQk0t78uR6AqLQPJmJvORKg91m3VWTgDSAK+NE5Na1KKR3PHfzu//6UXa2KGR71xNbhV
	9TgUulfYyd35/oPZnZdBl+4y5wpyJVU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NyX2lP4yL4yyiNmSIdIZaKatetnjQAHMgPJWzfzL5I61m7x7H8BovKfaAW0hHC4ZA8pwWH7nNxjHOfkHtnq+PimVACQaceRb0ZeIl2FGhvsKQEFv2l1qCbOlGLF3RQP4mIG+2/P6RDNx3B6bMD538q9UVxwB2HFqJrnsdyEOubg+eifaIxU4lj/TEO4UPNO49QC3Pzp7GTsNDNxqtLSEALcInamvDk0OCjHoiCyoFWEuiYdzuxUQ0jFVrJ6wFM/6Ck4IT3c/geR5bIU182rAB28SMQhg+1+mAgGVcGMsfIpB1Z+MolucFWeitBGV0Dg313tsLxodOBtng6iUBcHe4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Se4HlPyGVigrGHnWPlCoT/Tt6qCSfO0pnPQmufzoLRw=;
 b=wDNFeLDyxtXBN/vHeqRTX9duRj1+LDXIuxPSKBiqtd+lAg906R3Giln4lhqQZqUG6+TMHjaS+I3BNW8XsGu/GUwrUfoCPG6A3go9QTgmNM3KIBVlilvMD9AAOeLLoN4UgWRzkUysOZ/XHglCivqdiKWkPtJvQzCJqviGUj31AgXGJ8/0h+xz52XSyKZRAIzceVbP+42G0irF0g8PsBswKa7gXVFckDjX6Pulcw575oryqpqyPTj9KbVDLPfYLHm17WHIxV9f36+3bhUOFlin2STh+Uw9jGLqJNdp5iUOEHmGeSwYjYt58Crf/4XKeXwSPL2oZOdPRZEKa9BcyKJNyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Se4HlPyGVigrGHnWPlCoT/Tt6qCSfO0pnPQmufzoLRw=;
 b=kM54kR5GCpGKLKYjEGx1aqNyZkNtg2N8GkcrrRkvHIS3//HavE5/cwqc3xrxUZDlxLsW4QqWX4ZvOMnFBrkGK5pUuAaLrsXHTOetuR1LF/Rea5dzZ2nh+i33Hl1/svD+0awRiKyOv4kGeUJRgVthP/6RSxQ7o3Ip3qysz+p1tNwzE5oy8PtOEi/hTIEtW6bdlHGNlo1+ev6lvYVT4+XT75J+H5T8MstHfOKuElaCmlPQ7le3SvhJZHj5Z5yO5lNhXP5CfCQwJD437/hxIDmEyETmsQoV4w0n+7X2CmvNKGusD4GKYKOYkSmD3V+ceO973VS1OU+hemp0SnudiO1xbw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BY5PR12MB4067.namprd12.prod.outlook.com (2603:10b6:a03:212::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Thu, 10 Sep
 2026 12:21:52 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 12:21:51 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
 Chao Yu <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH v3 06/14] f2fs: stop using PG_private
Date: Thu, 10 Sep 2026 08:21:52 -0400
X-Mailer: MailMate (3.0r7028)
Message-ID: <30DEBE66-9E26-4468-9A12-123539ED68A3@nvidia.com>
In-Reply-To: <927c0ec3-4183-4355-9269-721d79f4983c@kernel.org>
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-6-6ae22f9d9272@nvidia.com>
 <e5792e81-e8a5-42e1-aafe-58dc603f4968@kernel.org>
 <178889163877.1334491.3646957026033534678.b4-reply@b4>
 <83a8743b-9cbb-42a5-9ff5-718297916a76@kernel.org>
 <3dfab5df-c205-4853-bf48-86351a02b4e2@columbia.edu>
 <927c0ec3-4183-4355-9269-721d79f4983c@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR20CA0041.namprd20.prod.outlook.com
 (2603:10b6:208:235::10) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BY5PR12MB4067:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b9d0721-82cf-491d-7215-08df0f3617f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|6133799003|10067099003|4143699003|11063799006|5023799004|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	jWdcUDHCijees+S+jIrnV6n897ChONRQehwY61dyn6edq/JJpj3pvAbvdWrUiFEL7B/NIgdw8s9wOMyVDaEnF/IQo3wXTWodLErpOj6+EUfr/qNR8u+F4mwfhkgHO5c133AGoiQPzdNhFwQTyFQH/3DexVSoCPQONFVW+caYj2OnGWFUFNpwHBRCZI6yhY31mN1ldgO6veVBM8sRlYKnkz0CSHJZc4PPi2B3N2bhie1JNoT4kyY2S9u5jme2iNxnn5V0OUVbz/C7igDCtEmnenwe1w8kUyoysw/XM5WoLRCqjfQGZ4447yMksR6lXDIo6fw0MfTFpP4hkCSlFteAlgQmDGkHxH9tjAg2PekWL29XPcuRBxdrwBWNivk+6DiF4BPBK4oX3i7t5XPo6wTYm9UvLHJoVIruj28M6y1upJaaYsTlRtol/3YjKVmbfeGJ0TGpfAV6xBJLx/BKwvDZIXNbQePB5X/3Or/K+bNcBrNEGSqxACtsSyjjC3WLPNbhWR7VIOOFGP8ZZ5LVhwN3WtMhoCfHOQbXIKoM/YuN0PpgXRclMCYiEYsLO6yFhKT5gU+1Gzt12aBv7bScf7vXU69TI57Smd3m42dSiOSijE3REzk7vFu7p1TM3t68+s/KrMKpyd2qVcC3OGQOMXfcoUMqt233G6sQChdgYzqpUgM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(6133799003)(10067099003)(4143699003)(11063799006)(5023799004)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TlhRa1plN3JIT2ZNc1JSaTNtUGhBbkIrUDR4UWZuTmZaWGJETWRtNTJRZVhR?=
 =?utf-8?B?dzhRZmRRdUxiL2doak9ONXpIVVkrYnhJSDVwYzcvQ3gwbm8xcklrOHkydnoy?=
 =?utf-8?B?YzVLTU5YWEkwOCs2ck9VL0IwdnhINnVyZmY0UjVnc1BYR1FnQkt0REFWelgy?=
 =?utf-8?B?RVRYT1VrMWE3ZUNMeHlKak5KQS96TEltNDJudVpySkI3VDBtS3RNWWp5M2Y0?=
 =?utf-8?B?VW4zc1JoWkhVbm8yS01OZHBRc1hoNHdOSFFrSVQ0aTFPSmhscUgyMmNIcUVE?=
 =?utf-8?B?RndKSmNVV2FlY1ZHaWhxY1B0ZUtTd3ZBR1hUQ25kYVk3a0Zwc25zajZLeS8y?=
 =?utf-8?B?QzlvQ1JxZnNOdEF1UjZBL1lwTWVIN2xjYXZCQ0dOZG5RVmg3OThwYVBHU2NE?=
 =?utf-8?B?ekFpVnMyRVRiOUI3bU0zV0swK3NTejhjQTRUN3BFVFBFVUk1NUJ0RldsTldr?=
 =?utf-8?B?aENiTUlmTTZaa29pWlpsam5vVG1sVzdsNnBtQU9pcXRoMitoeU9BdmIyZS9s?=
 =?utf-8?B?WVJiQy9rZlUxRHZQd0pkeXBiTk82d3E0bmZTMnYyZW91bThreTZNN0JPcUhE?=
 =?utf-8?B?d0ZuaFBMVEw1a2JMaUV2WlBsOW51VjJzakwrUEx2eDEzZ1VRUThtNGFDY0Y1?=
 =?utf-8?B?OC9LRnkzekw4RFpha3BwQ0VaVXllbE5pbFBpZ1RFQ1VZa1BnWWFGbVA1ckxx?=
 =?utf-8?B?ZVZkVTcyS25ibTJuVFlJSElUWXZhQVp6YU5BN1FQb0RaZkFwTDRDZUlUMWlL?=
 =?utf-8?B?Rk9aWDQzaldRNkVKc3dZRFhVYTZORk0vazVtc2thMVpWYTB0dE1kWXZwR3FD?=
 =?utf-8?B?R2dkVEVuQThhdE5pb0Z6N1N3TnE1Tkc3S2RmR3BLc3Fjb2U5WTZBRkdtRHNF?=
 =?utf-8?B?S3FKQW1WK04wN3o5ejBVaUd0dy9QOWVPSEtqa2ZlTVNlaWJ2ZnhyWUNzZlYz?=
 =?utf-8?B?VkU3QS9TeWplVVd3RWdsejlaWTdLVjVkNXNKSGZmbzZRTXQ0TFBGNjN3eDFr?=
 =?utf-8?B?QjdkNFQxUlFuSjByRW5Wamk5ek9LVzhoa0RBWExSWCt5R1cyQWtmWjAwS3FT?=
 =?utf-8?B?ZnBCendVUWMzdUY3Rm43N2NXU0t0d0RDMjJnUTVSdFRWckxiN3J2blBtbE9w?=
 =?utf-8?B?eThReTFWUll0V09rbkt1dzJXczY5Z052RlhONTZ2UjQ4Nm9mK3U0WnFFMVpW?=
 =?utf-8?B?Ulp0T2ZOOU0xQjVwSWdVYlBrN0JWSHB3QmYwMHczR2J3a0s2UGdvcFlMdHU4?=
 =?utf-8?B?S3ZINUpqc1hGeDJGZGM5M3B6VDlBNzB5WVgyRmZtblJyK1QwK3dLWlBMM1NM?=
 =?utf-8?B?NXVEeHlMNStRQ0lXWlF3MFRBTCtDOG13cXd4VjBrMExZSE9IWGhjem1XUnBL?=
 =?utf-8?B?VWpGSER6QVlUcklldGFtTFFMb00zZnREcWs3L0RJbC81c1Z3am9LVjlGWWpZ?=
 =?utf-8?B?M3I5cVZ1akxkc3RMSHR6K1R0Zm1jSzcrM3NqbEN4dTZkU24xcmd4UUxTZVl6?=
 =?utf-8?B?c1VNTXQ4YXk3ZUozRjVSclArRldHMVlBUzd0UXplN21xSm1lNm9nQUtFazY4?=
 =?utf-8?B?ZlMxd3pjOEdpUytlVytvZC9rMUpjVk9pck1QdmpZTlVVUTllV3dWUWs4TmNY?=
 =?utf-8?B?ZDhEZVVkd2s1SmhkQTNxWlNJNzNkQkl4R1dTTUFsdmh4SXNYZWZpSlFaNEM4?=
 =?utf-8?B?WWFxM1E2Yis0NGxsS3M4VXhZWFppTFo5VU8xM0dES3lFYytvVitMVWdnMFMy?=
 =?utf-8?B?WmlQaUNmQUU2ZXoxZFh2dUk3dk5HR2poSk5LZHBZRzUzK0RyQmJWQkY0N1Fy?=
 =?utf-8?B?U0Y4d0IrMDJFSzZjUDVOL2J5bjVMZHBpQWR6RWlaQ2lEdzMwVi81d3NEN29O?=
 =?utf-8?B?dlE5Y1hta2ZndTl5elJOT0piRlBZRWJSblQ2V2ZPdUp3RGkvalhxa2d5TzFD?=
 =?utf-8?B?WTRBeWp2ZDhLblFmanZTTWxyUEpUOGZEc0xEbEN4ejFVbHNad0xvcGpiODgy?=
 =?utf-8?B?LzR1OFplK0NFNHpVZXBhODBMUlYxd1dXazBKaWhHa0ZYZGpIc29LWEIweWhj?=
 =?utf-8?B?L3A3ZEEwb2VSNGNwaWc1N0h6eGxBb2t2RExxRkozM1hCR3Z4MXBaM2Z2ZUtO?=
 =?utf-8?B?YlNsdmhmNFVGREVrZjE3WWZGNmswZzY0RndQVW1HdFZwV3NYOHFySW4wR3lH?=
 =?utf-8?B?MjQrMVdJQ3RCNElxYjVjV0g2Vmd5VUNMZVhGaENZamlpL3RYbUNtMFkvOSs5?=
 =?utf-8?B?VGh6K3NOVm82S09ITC9zSk1GR0IwL0VDQm5iTTdHVDBicVZ6UURtMHcwbG5u?=
 =?utf-8?B?WEZldmREWTkyQzRxSlRrN2lZRXNMbU5WcFovSVlSSHBpUmRuQTBWdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b9d0721-82cf-491d-7215-08df0f3617f8
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 12:21:51.5990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qRwrEhgW/YqLSR8eK12KW4CbfVA1uPJAcA+9PW0diz3hLjUZra0T/4EA5lBYcF8F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4067
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8588C100010
X-Stat-Signature: ruycxq6nbqx4rsojey9qtri7acsbmsqa
X-Rspam-User: 
X-HE-Tag: 1789042917-660063
X-HE-Meta: U2FsdGVkX1+VpwYtV2zcI7Nb8aWtlwI2djx4HnwreqdiWCmjN6aQrhkFjn3C+ozY9VBeJhkTgIRxxCcLHxMqR9VkVFTUDjIHamDlSRLNkkO8B5l+gMQ2JNQRwo1CcLa0AlxpeqDLyxgaFUPofX4kwa2/Q4LQ1n0hCJlH7zJO1cEmGueS1uQM4Mcu1WGvNEQq8xzNwV3R05CJxL2KubqlItQmiVmf7QnTyySB5uml4hdaddUBQ1M4gyK48zhOmqB5+4na5KAVU1SeQ2uMBINfM4NR9zrFh6szeuMpK9L5k/YKGw1ND2DgJoRoExuJK+9tLyvSp8NAPMARHrmECK8nodxekffvnq/YCumgobVihzo/+qucxodOtCXnbc1xz6aP+zY9OH2cWDB99cct7Fl5tUekF2WPuEKb0mG3z20u8oXihR0jQHIT+sivAYQnI1XbxeNQbPRWWaLMIBe2vo4QAjWtJBOpZzIWn5whczPWvZHopn1M+KHpQ4qPAc3v7Aj5fNVYd3LEYxVR9D0N7498HlZ/n7RtmivfvlBN48LoBTp8Of1gU2ued8dPlKjFhreH2uEjy/PDBIuPLkMPD/pXbjUbpEFeSDA4I57JbaGdYLeQm4fOAHvm181pYCf9Ry+pu7TuP5rHkGLtjG+m8M1EG34uuxGdsxP+gbGiSFNjkkwr8DZWDuBNY8ueSkRjPBYtwYn5F7U73uUoxR50jA/fLsbii9VITO+EAI1LZ7d5XZtOXPdaj/D7iZIzUlt9RBppgwxwedeBJ/l4W+HiIl4U43YMCbD/KBzx7r9Kb89ENvMu8ug1I9/BEru5Pxj5c7YA+fPE1S6aHel0clXWGF/E3iw3gJQFLObsFHR8GKqwPDlIBljBJxwy/NsyJTtHyjti+RwStu86ysI0Bd1JqRg3luyH/18eVvNkEubJI9NiN+wGTBJRn4Bmqz9eLlaqzMXZTApIDgo2PVrHLHrN5bP
 V3ZkDJ98
 +rnvD4V7ciKjO40sw4MFtUxMySSc6PckVKxRDGCjIP4xXUxFZKfCAz7cM2xzF6hONTZ518NimUf8y7l716pAMETN3ea7hii3PRg5IvdWYVk62qK0k/fGrzI+YmkvEEWYasj49FRTKjWHXlMV/tUgFFGxMRtJQ2rr6r3ooxwqIoDKpHfzyImq9clMr4LLN6MYauxCgkhOmRlw0KaB0WBMunzJ4//NWiMExqt30ks2Ayr4RiWfHmQU3MKAFj4P48X1G5LPs5V4NT+H+GSmWOjf6OL2xhS1i0xs9tSeVep7Y4V5n+q2T7bhlhks8wSWsyMkfEIWF6NorGZumiin+jxQIKsiNmMKZ6/cUS0sd1+Ormg6Gy9YMohchSo4EQ9ME83UPraP2tbhFl6CKtsb1+CiMYW5yc1DsnNDqqlsCO4ZZuhUt9UpwfHvusb7OKF1jRGeqg2Ei
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Sep 2026, at 3:35, David Hildenbrand (Arm) wrote:

> On 9/9/26 19:47, Tal Zussman wrote:
>> On 9/9/26 3:48 PM, David Hildenbrand (Arm) wrote:
>>> On 9/8/26 20:20, Tal Zussman wrote:
>>>>
>>>> I have a WIP series of ~30 patches converting much of the remaining page
>>>> users in f2fs (including the below) to folios. Still have to do some
>>>> testing and clean it up, but hoping to send it out in the next couple of
>>>> weeks (in the hopes of eliminating some more folio_compat.c functions by
>>>> next cycle...)
>>>
>>> Indeed best to wait a bit before flooding -mm even more, it's rather a lot at
>>> this point.
>>>
>>> In the context of this series, it would be great if you could review whether the
>>> diff I proposed would get the job done, thanks!
>>>
>>
>> What it changes looks good, but I would go a little further.
>
> Thanks!
>
>>
>> There are only two more users of page_private_gcing(), which pass fio->page.
>> Those could easily be converted to folio_test_f2fs_gcing() by passing fio->folio,
>> which is in a union with fio->page. That would let you delete the
>> page_private_##name() implementation in PAGE_PRIVATE_GET_FUNC() as well and just
>> remove the entire family. At that point PAGE_PRIVATE_{GET,SET,CLEAR}_FUNC()
>> could be renamed to something like F2FS_FOLIO_PRIVATE_{GET,SET,CLEAR}_FUNC() and
>> all of this cruft is gone and folio-based, with no more f2fs use of page_private()
>> either.
>>
>> The renaming could be done as a later step, but I would get rid of the accessors
>> as well in one swoop.
>
> Yes, either as part of the same patch or as a separate patch. Zi, can you take
> care of that? Thanks!

OK, I will come up with a patch based on your patch plus the suggestion here
on top of this “f2fs: stop using PG_private”. I will post the patch here
for feedback to avoid extra churn of the whole series.

Best Regards,
Yan, Zi

