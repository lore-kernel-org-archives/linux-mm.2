Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0C55C88E5C
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598136B0096; Sun, 13 Sep 2026 22:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA1B6B0098; Sun, 13 Sep 2026 22:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39CA76B0099; Sun, 13 Sep 2026 22:24:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F119D6B0096
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:24:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9FBEA0DD4
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:24:31 +0000 (UTC)
X-FDA: 85210773942.28.AE73197
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013010.outbound.protection.outlook.com [40.93.201.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0F2CD18000D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:24:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tgTgabpy;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789352669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUjuXILVzjba9z+thh3HvZCbjHvrFmluDi/6zJAquZA=;
	b=N9bepIoaXEQaL0k2zSG61Wz6EVCE3cgcYDLXzjHxb9w0EaVKn5V4RiAW8/ZHA2db6eNN2b
	SJ0G9cA+toejETOSWac7CvAL479PKf26BCd2rRD2F7cgkSF4fDbUCStZUbVlr8KDdTSdWe
	UujSPM5RbMk6sRcGs6WN/YW/h68sSZI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789352669;
	b=yq+XYMtvEb/2Gb3ed9CTrQgZMx7GZ04s18nFijUtD8FZBRRQIjutMgm7Hh0h/nAyTJPVcj
	lEBi/phDjAM7q0DkIU5P5NFStofrwdkN3E5vAB/W5jPm4x9ixJfFHJblCVs9dPVmds0+SE
	DJfon12Qd05VgG/QmvfB0CQ+VAo6sYo=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tgTgabpy;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sp7a8N+W7oK58Yehu//myQNUCEHc92N00qTl7DWhS6ZgaVp3rm9mH4wVZ4kamCZuFW+GhJHHvuOL5XY03V/qqD57s1xEq7tUkGZJ+Wk9dtuCjMuDHmenCi/jcMxL65PCZC7jIz97Q17pEztE6F/6BdK/8UmDH5UlVdqi3w6XDDfXNRsyex9A7LFj1h3j3pG9GsQHO2enNWIxUF0CytI+5wYJFWxaEnOkQvUuMT8TyYK0qdavlbRiaoiZy9pA/fLAUpzWYIiiJYocriY8ewSci9lNcKud1Bvh6pd9IuN0srN/deH3+Ux2Kf9lFKxXyd6gpKNDwbOaCCmTdEQ+mhOJrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUjuXILVzjba9z+thh3HvZCbjHvrFmluDi/6zJAquZA=;
 b=FWDgr3fAx2uhKI0H/zwX6hCAP85EASuBYBwbUAZ9do28DW3Zch4cQF9EdDp2FZqUwp/8tOyF4xnmDk22PwTvG5q++i2fBpyrAObzieiodpsWDQGvNz0aLHFAYuNubuySRLeJQAB+WcTlsMaCDmafgLq+tNz+ZVPbv4mfRx7GU8Y4FIy+8T/tMwbWa3apqA8Zkii1S8RDVSldX0TaYOXtycda33UQvtOzYOD/MxSUHZJ4oBI9lr7iarVo7GLWlaKU9RHIlYx7+sxAWOf1zT7er+/OEQk3fZ9aM3B8GYRZCm+/s8/UAXWpszDSWYhXBGM/IBCX5uFdhMZcEKCQHkvLqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUjuXILVzjba9z+thh3HvZCbjHvrFmluDi/6zJAquZA=;
 b=tgTgabpyBmDE0mCjoSaz7la/NJHpLJTA0QNH8L/8JGOH/adKuXwr99veXr6SGMiuvlV0V6m07iB3Nh2WHjkXuLGoC4FsaMZvcc4M3uArrl6yOCiuTzPT1zwPqvCjvNyBmcZwHw67y2gKDu/AlQhrhITRjCoYCZycgjANQLBHkGipxhW/XJpfvBXiBFQ57DRQqDbi/IZTe5cpWZrS8pAqzHRHqm83h6AAgQ1Z0ltHLJ9V2o7hWVoTHh1XocrzjJaHD2p1KTNLfKnLJ+HSNNpoyJN6SL9F+cbrG138oVtt/i/eVg1fxbDZD/26wMNE/RsjnZZoWft6maCaDTSbX/MMfQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 02:24:17 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 02:24:17 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 13 Sep 2026 22:24:01 -0400
Subject: [PATCH v4 03/16] xen/grant-table: stop setting PG_private on pages
 for grant mapping
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-remove-pg_private-v4-3-848550f7574e@nvidia.com>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
In-Reply-To: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
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
X-Mailer: b4 0.16.0
X-ClientProxiedBy: MN0PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:208:52f::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB6486:EE_
X-MS-Office365-Filtering-Correlation-Id: 982e5414-cdc7-43f1-3bd0-08df12074690
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|22082099003|18002099003|921020|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	z/p1/yzLc53JZYZ53rmd6dC7B8L8w49/gMQIhGR5QrVHUh2j7O2ONa48qlZznHbJHHion+Ak5rQoMEcxqjOhfla0nLfQWree90L1bause5fzWfCVNwirnthORJ/vBOEdWOo/WN0TvQ28YG7CsUhHx3biEDWDj/LZvwryd8xnuJS7ils5oqyvcwMcg2G8ICND4SdpKu1YVKrgJOeOioarOycaux98PW1Q0BJheuya+ZsQ1mjgx1xgoIOxqChcGDYp+Txu5XZiGLY8rPLk83FChwpnRooWCdqHKN7XAzLsM4b4ZFhJx/H6iYIQDqpxo0lcYijMmvsmuu6LlVFe8nTS5YoJQBlBT3B0Zy9xoBfqDzWTzPrq45OxQz/7Ni+ec0Tr2matRDgbNGlwXnaoXREkaICDQpmzBrMBp4fdtLBWw9ALUbLeOTwxrovQdO1P+ruGEnbuUtFF+kv3jcyklVGeIxpcivXGGuRamiLh9EFo3fhAvQIt9RU4+3VFWJyMKFgJ15BTNiVw6cYbIQ3U4pmb5krdyStnzoiVVxo0MmJqKkZ3bS6q0Zv53zw1EvqdXQ8AhvzUhbMEq/Hav4OeRn6ODjh+00SWRsjdsOZj6/3PbNYdsw2lv03YYQ9IBWKYLY6htsIyyCu67XGkVVFqJdacMGqIGIz9obMZadbHmiBqPcI1VqKXA5qIfBWvUUfSIHrqPg0beVreRPsMdUy3scJ3zQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(22082099003)(18002099003)(921020)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0dPWnF2NWlvUmZxaW5RcnRkWDRxUU1jOTA3Z2l5eVF6cDBHalkzaDQ5cXlP?=
 =?utf-8?B?a2JBUUlRTUtJM3F3R01BWHdBZkRNa0paMFN2b1BQckJjNGxaUmJnb053YVJG?=
 =?utf-8?B?bU5IbWxJb1M4N1RnaWlndmIrdVVyMWhLS1hNbEk4ZGh4TGN0N3M5bk1uSjNP?=
 =?utf-8?B?V01XWVNxSkh2bFVOZm5pWGtIVUttQ1d5a0hMQy95dGt5QWZGVUNzOGplTWhF?=
 =?utf-8?B?U2NabUxSdE9GemxsdlMzdjNVMFZqS2ZiN2d2ZUljekQ4NUZXTmRpSzZqZmMz?=
 =?utf-8?B?Um1GM013YmhINUd0Q0d1aHl3ZVFBWnFOVnpJSGJIUEZrWkVWTzFhdnJZZVNs?=
 =?utf-8?B?UGlrdmRncEFDOW13Y25LOXZQRmlwaTdFbHhqTGY4MTRrT1BLSnNLams5SEdU?=
 =?utf-8?B?a1VlTlduLy8vZmRkeXNpTm5VTDU5MFRmS2JPUkZ0YzJ6bGNJNnBiVmtkMjJY?=
 =?utf-8?B?RjcxdGphRjZ2M0lSTFY3UVN4cTA2SVhRUG5QWDdmaTk4cTlnRVMwUGtTamlr?=
 =?utf-8?B?TUFETjY2UVllTVFTRFlCQUlGTG9KdHpzdUdVeGhPRjNwMFl2RzB0Mkk3UVg0?=
 =?utf-8?B?bHlNT1hVMGRhZEtwVTRub1A3VjZkMjBhc0VmdG94L2xseW8wZFN4bnZtd1Qr?=
 =?utf-8?B?MGIxS2JJZXROSHFvNElvYjZMVVJFeTlPWWNVUndjRnB1UGZxMXNXb20wNVFw?=
 =?utf-8?B?V3laUnZBQk03ZzQxRGUxODRDSXFLTnErcEZEcFZBUHZZbVlwMnk5UWRVZXRk?=
 =?utf-8?B?b2F2L055K00wYVB3VHhvTy9JaUhOME8xWFlIVDZBZTRidUsvNm9iak8rYy93?=
 =?utf-8?B?NUdCTDhEUzVVQzZCUnpCMzJzN1phaWxtai94dkYxZS9BTENTbUM2ZElVMkpY?=
 =?utf-8?B?NlFTQm1CQ0w3SjdVcWYwVFcrL3ZXdmJvZy81YnpMZEpFRFc5Rm5ZU0FUcC8w?=
 =?utf-8?B?Qk8rQmRYc0tiaVdVUmFleXFjZytPMUlGRGZpbGlMdHR1dElVU2VXTEtQcE1Q?=
 =?utf-8?B?dDFxa1ZiNEVhN0pVcUxodnY0QXFOZFFmQ1cySEtnWlVSb25ieGsxUWhxUWtE?=
 =?utf-8?B?anNQdEdQRHk5Ymt2aWl3K0Vkb1ROVnJMOVdxVFhwZG9uTmVqUTE5eVRZbkNv?=
 =?utf-8?B?bGliQ3VpVDZlTnl2NDZXTFE5RTRqRHMyQnBjUVgwZnpwdUFCNWg2WEMxazAx?=
 =?utf-8?B?U2I3V0tEajNHNS9jVDZxVTA2UlZPM0VCWWhlaDNkanBQc1JDaWhHWktaellz?=
 =?utf-8?B?eE5JMEVVYSt5eGxGL0JUMnNOQnBJRXJ0NU13SWpYaGN0Tml0WU14YWh2dGU2?=
 =?utf-8?B?d2tSU1RmS1VDS2VTREJRSkJGSWt6TXl0V3BBd054d0VaQVlySVVKcHoxNFBi?=
 =?utf-8?B?VlAxSWE4NklwYllYV051SC9xQXJGZ3MzMi9OOG1rVlpBK2YwOUJFSHh0RURX?=
 =?utf-8?B?bUx4Z1RLd1p3dnhBUDRUZFV3bGNodFJjZWNOSW0zM21aMENldlZGYUNUNHhW?=
 =?utf-8?B?cmtkRHdKZTcyMHFkeEdpVWJiQlpWaHRLUjJja0sxYmNudFB0WU1ZS0VNKzdN?=
 =?utf-8?B?U2h3ZjV5VW0xQVVBRmlmaEtnRk1IRW1teGE3ODF4b1ZPRWh1TXVGUnFyTndv?=
 =?utf-8?B?cE9CYWhxU2lWOTJTb1ZzTjE0M3J5NW16ZGJlK050Rzd5blQ2ZGhvTDJObTd6?=
 =?utf-8?B?blJlNm5naGpmdnpOZHM3NzdsQkVPZTZCa1RwSjYzVnNCODRtSGpOMHJFVmZ2?=
 =?utf-8?B?cWpRUEozcGR1RkJ0Rm5ERzNINHJZVFZqd2N2VzFLbzY3V0p3R0ttNDIrSzlt?=
 =?utf-8?B?OTNWVFNOKzFXNzZjMlhuWGZrejBZd1ROQ0Q0RnFyak96TGtuZ1RFdmdUdVNr?=
 =?utf-8?B?RWc0d09vZ1VjNGQ1UFJQb3l2VlV2RVJoR1lnUmswUjFYZURUUVhXVmE1QU1O?=
 =?utf-8?B?QU50V1F2NG5oS3NpQ0xkek40RkFnQVV6cVBKdFJSV3Fod2hwQkNIKzVWQzBR?=
 =?utf-8?B?QStNTDJSZ00velBQKzNMVXQvYlpRYUY1ZWtVQTJCVjBQK3ZvLytMRVNhRkt0?=
 =?utf-8?B?QzBiaDJZZHhGNWtreFZyemw0UkZGS1htRjZXZzRZaEk4Rys3bUlObWZGWjVX?=
 =?utf-8?B?eEttRGVDYkUyRFgwREJrZVpTTWhoK2RYWlhVQ2xlZlVEdlYzNlFGSldhWG5w?=
 =?utf-8?B?M0dMbFR5dWVZZGZIeWt5aWFqeVNheXczM2k0dUdFQ2VrMkU4VzBWSU02dU04?=
 =?utf-8?B?Tit5QU9UeWx1VGptSHFMd2EzcElRaHEwVUpJbS8xNXV0TllYMGhNMGxUOXpn?=
 =?utf-8?Q?ja6n8QxfWm22fveCv8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 982e5414-cdc7-43f1-3bd0-08df12074690
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 02:24:16.8986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: To3O9zZcW/LMdCtzpMacLnBBGk++x3Djb34juhRZC6KxlJaWhOUdimgBAOw6n/v2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6486
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0F2CD18000D
X-Stat-Signature: w9yyt71tir113adoz4odok37zk6rh7u4
X-Rspam-User: 
X-HE-Tag: 1789352668-304036
X-HE-Meta: U2FsdGVkX1/QYP4Pgfr/4w4OIqYnFIbdaCU4qOZrI/eXoa2AgY4IkeiqudD0WkZzBD+7hcpCqxoj4tiJbsekiKUoKav6nZi8qPAgk+pIewKUPIyVX/1xZYi4K0RgA3tNOU5cWRe/Plk5+jrpGt4UN+kQpHPV6O05JpbvzqzxFQJP9uXATMjmf/xcXGBFkTDtjpGRl7/qwEMISmGe8QhK0YGf0YiQO/rGyFJOI6GTUfGmn94jrQ1eK9KHXefT2iqxqv4aDw9PpoNu1Rx4F7zm2NrgxYTU5K4/+YzTzebgXNh6KG5SpLQcQ81ie8ilu9YCMhZT2wZbYFoLKuPkrw7dc6GFyNR0mM/AzVZLEqhdelgoVy5ApUVdi1OPW880JFHkhWe5ASMDeOCR2IBJolnMA1nHhwvCpndIqlkjiN28uoPvF/u0cT/ZlWiJ4k0+Hp5GPM6669k02EmBs6CwGolliMcqkv8VM/Lfqpuj1KEHw2NLOwYzXv/ktwOj8iYzBmGrYLsYh5+bHG4QlZlwC+QICG8BRNXu4UAfcpS5RQUr8SofSTWHvaTMQ/pnLtzTb7EHMNtmebPfQlggy1AOK8uOPyrhIx08UkLkzE1CQnqSN7dX0FryfVPMgGmQ/m/Z6lAAGY6fhypiEGaZmgWVGPBGpaGH7Uak9keSJo0G8uAJJOYrZjD5bjqnG/EsPFBI5Vj+EoQyECbvvOVRr/A1PBYaphEF87kLqvsOkiRHksqKeFh1tc9f7ZNUaaKcygfBvGasR0skaOA34EXmv3f4bDvsFex3oW7urRMa5E7RKlnjJjH4nmg9ie5Okcv2KPmkvsii5MXOtQR8p75VwPBFP/uM3UOg3Q2ubKlo/DrpO5Q1uDEVsBv5OlA4tTsiAs8kotzuyIuxxflW0iInHVxdalR24yGZEzh8XsZIBgW50kZO57YxhR8MsK9Ib8qGDLrpo6RbDUtn50lOtxUutlnYyHr
 sPPdGFSC
 FGPKQ9WOwRkVYsLfFKwVCDZolb+uNUheezkObxuOBOeTyemi/Ft0C9peH0GwfIrvGSoOtoFJ/WeHphoeFwvcoyHgVi6F0EsPHg+1r0AlQjLptUv5FwX1MrHQInVsyWnwz35aX88Tg0MBsTsFsAK1hGcHHO05FssEnciOwaMaB1hWs2yrwH1LtAUu2fub8z1Bt2d83YlnU74hMZmprTFC1yiPStjRFwJv4kjjqbtvisTjbfctsA2crGa8BBLB7uIjrU2C7ZYyLp2AQWZKjPem+AsuYj0Gsu8ZFOVf++Qm/Dprxtn/84egrJ4QVQ4sVW6H1UYvham8Ob3RJ6aivGNU/bHbTML7mzWeJkB9HhU3jw7IaKZ2Gnlaf0u3sh8oGRSji3waHyKpG/Hb/cc4EY+me65aXdAB63XJqUFfZyRkNUIlJA2bUDyJYlu/kz55nbKmGFXuTGeGP9Ff8Yg64W5n7eUTKijs0o9Ulud9XOYFxelWNwUfJmYfvCh9V8nidF8HM5NTJmrHZ8Q+EboqUmWH6Wgj1S52wjvA2fd6gm+M7UchMJVLM3ILShBO/zDxuqCwerZ2q6s+6vn7Cfx2yDS8V3Cq1c8f2YAniYAXy
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

Assisted-by: LLM
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Juergen Gross <jgross@suse.com>
To: Stefano Stabellini <sstabellini@kernel.org>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: xen-devel@lists.xenproject.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/xen/grant-table.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

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


