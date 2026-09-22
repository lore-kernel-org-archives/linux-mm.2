Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5F09C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 22:27:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 993376B0088; Tue, 22 Sep 2026 18:27:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9439D6B008A; Tue, 22 Sep 2026 18:27:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80E816B008C; Tue, 22 Sep 2026 18:27:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51FA76B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:27:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4980160221
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:27:42 +0000 (UTC)
X-FDA: 85242836364.23.20879F3
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010050.outbound.protection.outlook.com [52.101.85.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id DB6C3C0002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:27:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HdCWvOVZ;
	spf=pass (imf22.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.85.50 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790116060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4KBR8TkDnRJHwhHj4Q+cVvmSI6KJBBvUoA2EmU305QE=;
	b=1ik5c+fHCXHBe2wEikM0yj9aqcB75OIZKKbLAquWZ7cgg/h2amdPzNla/V038sEyshl3ZD
	0isgbklmskvGFCX9NeS1HNhlp6G/8aS2wkw051TXvtaL1T1toMq27iqQb82CD++ux7Lc5A
	jxPDx5PlDnVTX8cD+FggplLFUFp33vI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790116060;
	b=fu74hHTir/uOKmuZ2ss26gv6nhONY/AeV4bNqCwT111D5ARGnK1uTno8SvIDhpEizJiE/D
	PqpsAhmqUDeXTxYdCcawLGo/1Lh81OXmFnajJZXd82xibwuoUWqzEAUq3QXUt4ZOQttYRM
	fINu7Lwr1oIpFirTTgQxnvbuvHaDoRU=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HdCWvOVZ;
	spf=pass (imf22.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.85.50 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ey85LsqZaGFqDWD03Anufwkm5u2TpxzU+AVgCiIXNeMX+XadRqklOP2iN5Mz1rhc7gYsLYZ4hWvuEySLfnD73rzoGaxl2CXregY+4ClkfmafWONMsJbJrvYSc3Q5VGeb5iY+DXU286tSomwHGudxUc3WoC10DxUFF2ImwwmxCHQiQREXk/IgPF/u6x9hnk2DnFEwa78vIMtUyQD5e/61XSNp7PMUMaOmNUKtPCxX8h5RuT9A61IUXhoQ+6huxgnyCE+Q4mr/PHjkRCXUaduq3SkVpAsiF6HDFmWX3PySY42WtoSLh4vc/OaeIfpIAAUJ1oE1yDnIG0uHahx8pljsQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4KBR8TkDnRJHwhHj4Q+cVvmSI6KJBBvUoA2EmU305QE=;
 b=HZf+Z6w7Mndzx1I9FC2AOEPUit5yRX80KcPkVT9OWILgUeKrYqCelro4yfKoCjcPVvcd4PYFpCsnnl7OXhr4OhRRn0EhtNbaJao9HaDMmo0XJT2n8jn3K+JwDwPaOeEC/HXgdOQhk8nwqhCYWptS92I7ctKpmkLqJyGF0HU6RpBy+TUg5JrePzmUDyiEiMuh/xDIgUtlGH+VuJrfmG7aramVZ2xFIieq4++zeNcAIjALDNtb0Xwa35jIc2i6f0HGVqdZu1vgQe3vLm6RUCIz23DbzWdNcHyWKpJ44bLyfe5SYBZGZYXxHWohXhZZ2g78EK9WwFhEdpewvw5G/TYEPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4KBR8TkDnRJHwhHj4Q+cVvmSI6KJBBvUoA2EmU305QE=;
 b=HdCWvOVZvdcOMkoZhZZRltE3hX35CgFiSnGPGy8vKSLk91dTQM/DNl2NhewJPpqQSNYOZtJ5F73AFhfnS+tXNEr1j0q9suT71w23Sjfl6rx1saXOdRDcnuEHFHGH4PkHI5PHQKESW2YNk6UtW9R0qBpyQ+so68Q2xjExEfaQcruWDx73gQGlrgNj5QX6Fl9kF1TiNqH4feRRiwq3x0CrYLifO2DJbco5/uStP5ShdiphJrbD4/AzEih96I43TbTI8x6sEZ4D1thv8VW3yfEIVC/zk6HwgQ/3mNDVog8QZSEKVqaAlur6b/nHV31QNIfxSi1JSdvSGK7wDyyyH3ze7A==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by DS4PR12MB9795.namprd12.prod.outlook.com (2603:10b6:8:29e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 22:27:34 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0428.011; Tue, 22 Sep 2026
 22:27:34 +0000
Message-ID: <c2b28c18-3717-43d1-acba-05eaf9b1b9cf@nvidia.com>
Date: Wed, 23 Sep 2026 08:27:25 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 01/12] mm/Kconfig: changes for migrate on fault for
 device pages
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260922053421.4092027-1-mpenttil@redhat.com>
 <20260922053421.4092027-2-mpenttil@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260922053421.4092027-2-mpenttil@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MEVPR01CA0058.ausprd01.prod.outlook.com
 (2603:10c6:220:1fd::14) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|DS4PR12MB9795:EE_
X-MS-Office365-Filtering-Correlation-Id: b03aa359-d7e8-43e3-127d-08df18f8b322
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|1800799024|376014|366016|11063799006|10067099003|18002099003|22082099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	dmWWs2iQnALm94QnNqm4doXwuHYUhjbGi1jTzUVDP3XVPo3l0bzEumpxsDpZd/utw0NjzllUinMG8LnjPFwqxPFJ4sgXX24FC5VRu2LblAF+LENKppe6+ohUuwChgWWdoKn2EnHn5qH3vd8fAOw42WVx8QWrODmzMxg+ojpSUxpxNe3NKnoXfgSpWkLGwU8Eu+TPhwfUNDvLcReDmprrQ4NK0gSEnWd8iFJ5cOUfi31KN3pUVNzmMDYC8kM2wE1w4URGxRrKTUhYChbIsfoiKHLfruBVCaDpfgtoyjnxajzoZ+QJXevEwOAz6WsMR1zmWG2Pjf7LjXiLGcj9e6gZkmrQQUnEJOwShg1P7WdSRKOLbiImIfWYSJnZx+pDtVpASmYac+tEtp0jDLAictgCSzS1DMGjw+Zj1AfShlfqnbehJSmJCapk5KO2Zc9hmfSOnBn62I8sANhu1SNZE69pXW2sZvA1yfwIT0Eowxnqwwi5AQE7p+54HjmmQU0JtaadZhWmBKHx5D2mBJdTb4vMXIbPYp/SU0wbbOCsLrEhcBWW6x5nbLFtUK0eb9oVfKaErKzYzyDwd+NO/7Xjwi2bweLSQRJnvlVm/NUhIsUZtr2YhfuM3UMJLykJYJb7IUCAiEqbfghAY4jvVNR5JHBzhIXz4CXfmGLIHPExxo/Ta54=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(376014)(366016)(11063799006)(10067099003)(18002099003)(22082099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0lMMDFybGtxN2FzMnJUb2I2M1lUeWxSbVRrRW5CcWJvYzQ2RmtlN1c4YjBs?=
 =?utf-8?B?amU4N1I4NzBQbk1tV2lYaXZvSTcvdnQwVmt2Q1hnQzhmclNERnhQTEZxc0F4?=
 =?utf-8?B?bGRVVjJTWXE4WU1WYU0vNTFCdHhWWkFvajJvbkQ0dHhXd1lpbXJmemJKelU1?=
 =?utf-8?B?MDdURDdPNVp5VTVDbDVYSDB6cjZrQlIrcjBrdDFXUUJ5YnJpMnNMNTlaNDJW?=
 =?utf-8?B?R0luN05yTzFHaHFYelNsU0E3MlNOcXFWbVgreUphZFdLVUdaL3hnN3crZ2tN?=
 =?utf-8?B?ekVIa3BEMDlkQ2pQMXI5QklqUTRKTDRuUXhwdDI5RjlxbmpJcFJ1bjFiY3lv?=
 =?utf-8?B?QVBrZ1lzM0hFM0JmSzZycm5kV3FyZmpzcS9QSVN6RGpEaWp1ZGFuTEJGNVo4?=
 =?utf-8?B?cEUyTStyUWRaYjZxQ3pFeUIzRkRmdVpENk9VMVZFdlN3M0tHQXZoMEs5dGtl?=
 =?utf-8?B?S1YyOVdWU1AvUTY4eTdSc05Pa1YxZ1RXa2M0QWRQV1N4dlpybjNOQzZ2enZr?=
 =?utf-8?B?aXdBM0d1MzNEQlJDL1R5amVRYlZiMEVtaUV3TFB4NHFFYi9rMzRrU2lZaE1G?=
 =?utf-8?B?V0wyVzk2MWhUKy96bjVlUkhwUHlpeURjcU84NGh6WTlEMHBnQXNhZXVWakxS?=
 =?utf-8?B?bERqQ2QyLzFza3MzQXVpbUFGbnk3b3F4UDRFL2lKN2xZV1N6VjlLeU9iUmYy?=
 =?utf-8?B?K2o2S1lrZzlES0lYajVGZ3k2OVBrRzllRUl1ZDFKVjNtZE5xUzloYzRPUWkr?=
 =?utf-8?B?MWh5S3A5VG15eGh3WEU1VG9MNXg4eWt2MWpJcjhNdUZ1NWtBcnkxeHdTUE1o?=
 =?utf-8?B?VG4wVjlOMEc1S2ZVYWtmL1VWNjhDWW1IbXdwdHlmelFPMDFtU3o4Z0Y1Y01F?=
 =?utf-8?B?a0JjMnBXUkd1MmJEQUV0elNqVEpUSllTdWFzL3h3TmY3L3Y2NG1hOVluaEU0?=
 =?utf-8?B?NS80Ty9JQnVLQlM5OVk3QlkwczlEUC9PblZyUDFKWnlKZUsvTWwya3RacGhC?=
 =?utf-8?B?UXNYUXFGSTIva1dYdFBCR29pOENkWmFMVFEvNU5CSXUyZCs5S0FpQk1lZ3JV?=
 =?utf-8?B?VFpBb2g5bGdSa0x2OFFDZklUdUFibnpiamc5WEhmeHZGcEpEN2JPNTdRS1Nu?=
 =?utf-8?B?dmF6czVZbDhjemV4R3dvOWd1M2x5NmN4VDBLRy91VUxDSGFyUTUyWUM1NHcz?=
 =?utf-8?B?M3dkdU5LR1RVNEJoRjlqMXBRempwS3hHQytUQTJhWGc4R0x3L3g1VlBTUUZL?=
 =?utf-8?B?Z2ttK2VFYTNiQUFHUEJ4SEI4VXlOTXczTmdVRnhqTU9tN2VzY1hIWCthY2J1?=
 =?utf-8?B?eXRZMHNnZUhiMldFVUhDeXJVdzlESFhzVFg4WHZDdGhmM1lwRHZmbWhwWVdH?=
 =?utf-8?B?QVc4V1NFRjE0RXdGV0hyWVRjQXd2dWFwSkxncGlvV0tHaEtqU0RqM0tBc0dY?=
 =?utf-8?B?NGFnTWx2TEZrZDg3ZFBhS3dmQmZNMjFjRjE4emd3SnRFM0FMODM4MHo1Ym93?=
 =?utf-8?B?cm1VV3EzMEZQZ05EMzczbFJGOHJKcWtiVVY0amhuZEhtQTA0UE9MZERIeFRl?=
 =?utf-8?B?UjN6Si8yUDlMRE03Mmd4dlVwbmsyMENYckMvdFlMV0JLNysvU3FtdW8ySDJn?=
 =?utf-8?B?SDVsNUdsZEUzcFE1c0Q2U2MvY2xsRkJuVGtuRkpMcVJSajlYWEZvR2l5OW5I?=
 =?utf-8?B?SDlkYXdLT1JNYmtnMkZyVkw5Z2NSWEkrUk5EQllCSXhVcjlYcGFrdndBQ3FT?=
 =?utf-8?B?MkVXTlBzdEJ3U2RHL1pzQlFyRXR6TlJJRWhNUUoxaG04cDB1c2xteDNpbUF4?=
 =?utf-8?B?OG9GbFh6SzNVd2NjT1dJZ2VGblBWVnZLeU1UTjdyYi9MNzRzUVRoOFpCWEVk?=
 =?utf-8?B?Qk90YWIxYzZDUjl5WlA2a0ZRUFBNcThIUWVpM1lzZkhOZkNOZUhuWlNXcHNt?=
 =?utf-8?B?RWFVdk5kWDlLTGNEM2lzNVo5NVdoalZCdFFVMVpxaW1CbngvZE1MUm5HcXFR?=
 =?utf-8?B?TTBBSVorM3kxWkNTOXVhZTlkaVBRNnlrL3llaXJIZjRZaHdlaC9NSk5wRmZh?=
 =?utf-8?B?c0F4bksvbEVKbVA5WkFZWVQ2a1VQcWVaelVRM2xraXdZclgrVTcrTHJuRytI?=
 =?utf-8?B?NGExZzY3QmdBN08ybjl3L0wvMjBqd2tLQUQ5N01CUG9qei9wVC9FaGlzRy95?=
 =?utf-8?B?WCtJM0pySnNLVkszT1RhdUs5SXpFYm5ObTZibDZaclAvVlVLVy9HaGVwRnBM?=
 =?utf-8?B?VFJzMDF2TWlXRElWTm1uNWVoQlhEN0c2UGFKYlZQMEFDczRlWEE3bnZmYkZZ?=
 =?utf-8?B?b3ZHZmRSK3U4Rk1HRm5hSXhwRVc5YVQ2S2JUWSsxUVRlY0JBdmpZZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b03aa359-d7e8-43e3-127d-08df18f8b322
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 22:27:34.7185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U9cLUv30rl70FcE7bha9XKhDGvoXVCk1QHv4O0mDhvOe4tqLPpdZi8CjLuVrZAUn4kK41VK0psAHpVxuDCm1sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9795
X-Rspam-User: 
X-Stat-Signature: ubot5a7ubztf8yejh5p6zuok11ztryqa
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DB6C3C0002
X-HE-Tag: 1790116059-668484
X-HE-Meta: U2FsdGVkX19UWdBFpjGMIJqJp1Mak20GBb0Lmhl3p7fx9hPEPgl8PtYKuiHhsgP4xsqmvcl3gUJ+5Qgd4CD/VWRV5H/6a3APhj6X1nsB7WglDPt2GRlFIZo7eZGa/27qX6ZVv22YGk7ZHG719LObaKiUIGZeK8XfOpkjbfUecEjnHl4bYGAPCBJoLFoZlBVHtlOmgp3hr4e2/OkFlLXt6Ge5Hevqnd87Zlli6Hhw6CAPwMU8fPqGW+jzA9ahjWTEHcJg2A06bzf9iwCs1ymCXPtQVpffjfraXWIUBLvAC8Ug5z7Oc4ni6eF9Ssdi3CnBGaImkKre0nhYVgkhZNEtonKZMJejo6iZ+LHU6Kj6/gomATyF9q27TchDW8ydzjJirHehCzfOi7KG3DL1Ey4u63gpXJX5965gnbkoKdQOJ5i5ycbphCI3unSjrbZYUOPO+XF4mx4u3TB2wNn9x9KF7mKGDmNZwVkEYSqL0rllHKsLcAovWyYPIXUh5s3UnhN0r/J+moif1YIcsiLOikH7ISdtWAcKcM+HthjFtMIBMGv+ayrXcuENBFglZYIR1bHowvY6CpXQvCsPQc/eTDDcOPkviJKvoGcHRvJck90B6pQe4vFcFOeDsL3saOzh0Z9WetE/D0Xh76AvRGitEpexpei9HAWvAzWmpbCzDen34jxn6OXNvMM2eSS6UA7EvxJ76H4wKRxXbgsXYoiEVScBAq8C+UcqOjLoeWMt3u5wRqaR8KaV/fQg9v/vodWrjC+MJizbH6ff106FueG363Dam+qIAXx6OXqpSkL7ODFj66K41gjmgZUB0CPJ4sIWJAZVljFlk8V20HpwC5w2Wgjd+1YFk/P4WVIvWQAjyLpu5QCBnq4lAOEDoZ6nY0Qj+kEsTMA9VG69JCMyrhSq72RuB/irxT8QUQGwm592s7QMn79tNhO42v1xPE9+lc2QkCdftMbKWbytCZYoVCNTEsP
 t+LjCnyX
 +Fr2Eo8FcTQE+HNTEFh82mEKAS92Qb16A7xFvMAHbqsANIu8UVFZzHlLvExAEuvaemoh001GwZbi9iYRWXF8VJNo0WViXKCwIARNqKAs0rNCknI3TckZ53vsVyVme9DYXntjJ9A0+iNbC0a5q/SwYHMhZCXj/a14Y75akdYuyNDJZ2nCBF8ULKwqKh/39kWSU3sQyIkLVt5YOqr9KTGSrLFC1HbMgN0c2ACC8OwVIfoxxo2as05G+29b9isukfqhcaT8BsAfh9hSrt+v7U9yWxWjefaFyMIOIV6AM7ELR64DN/kWtlpwzs30hq5JVDGZEZ6Kgte7bN00JaPUjgSrzj6x/y32DPx1pS0kiaacRklCXFp8P8t6w2TxPeVhgIozeoj9rf88VzK5vXhXehob60Wxm0/A22Sroi/YK8Uo/hPCKzPk8WhfXZK0CE5Abz3JVdNCtybvnoh/AMvmEYCekwGSLqznDs4RBMOyy/2sNenq4H03gUpgdEF2fs8k/6R9BS5vAtXHTh9J2lt2XxRGlA4tr5668vLwRMWPD9eTqw9OJSU/TDrxJFm6hqgyrEXg7DQjxzVGf+G4wmVCvjfVra6pnf+dacrVFA7umUwL/0MmjlKmNS+a40s0taRBdhWT2uXwS6ubHkqk6dbOpiBELIchTd/4jGIlAsQ4GBAcC05G2gRbhnN7o3foh6YD8ude8s81JdScXibEruNK9enZFizv5unaV2a3w2eL9xacX5g/zI+MT9vZRRQkiSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 3:34 PM, mpenttil@redhat.com wrote:
> From: Mika Penttilä <mpenttil@redhat.com>
> 
> HMM depends on MMU notifiers. With the unified HMM/migrate_device
> page table walk migrate_device needs HMM enabled.
> Enable them explicitly to avoid breaking random configs.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 604c58199acb..b7a485beb9a7 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -687,6 +687,7 @@ config MIGRATION
>  
>  config DEVICE_MIGRATION
>  	def_bool MIGRATION && ZONE_DEVICE
> +	select HMM_MIRROR
>  
>  config ARCH_ENABLE_HUGEPAGE_MIGRATION
>  	bool


Acked-by: Balbir Singh <balbirs@nvidia.com>

