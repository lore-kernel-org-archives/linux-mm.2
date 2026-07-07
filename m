Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85537C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 15:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 589436B009F; Tue,  7 Jul 2026 11:55:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 539BE6B00A0; Tue,  7 Jul 2026 11:55:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 403E46B00A1; Tue,  7 Jul 2026 11:55:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE836B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:55:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 88B831C255D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:55:30 +0000 (UTC)
X-FDA: 84962430420.13.3E8EED2
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012014.outbound.protection.outlook.com [40.107.200.14])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8865980009
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:55:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pQTNt8OB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783439727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qkkjJCpuifQWsCbonIH5cl8F4IFLOSfX3PT/7Uh182w=;
	b=3J2HehWGOSOEuoJQfRGHluOzz1qW545Nk6QslOpxN3TFWAebaBbz7361ha4UsurrztNUyQ
	pXuoBG64jWvm0BIfsstOcmcF7UbILLJxOoTTDgrRL3K0v0FOOc/EkI9GsYe/lrSdggmjq7
	7ql1XriLcj5dkMIbK9BioQmqi8Xc9zc=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pQTNt8OB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783439727;
	b=DgFlZg+TLEqbpNT6ZhtUwFfCVclqslpD59i402W2DGhJT5+5xL8qpuy2lLZwTiv+GJ7XlD
	rGEm++GmDjGowicbVebzmdFhk89KcKMKAB8aGzB7rjrnlDywT4//Kcjd+c1AWWArjJshS7
	mPWIxUJYDAlkJTi9a3SfLhDml2FgndM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kqZ9+MEV2c5J60zAypuREcoM6quL0oBqK3Hj6LVPczUs/Rv32tC3CbN/GJ2njwEV2pQUA6igE21FfZ4jh5T1mfxswLyo1Yi2dBTJ9lMIphbkHz6kBPutX4scU+iHMGBnb623tnoL0nV3nkNaGqbZIIlPecKkSQb2Dr58VKRNHsJ56MwrO3K+d6YBhchFbTfVnBIejAeWlkaygvHPvnYxGiRj3iCGmBomHl8LpjezCuCNWdOStxaTESiiVc8LrSEH4mqQtUKz4wxS5yNjhPLgQw5qaodrEQ1nwQygBcmfTSwfkfC4wfmu0Wmj9/9CoKXmVAcx7WeC5PGOZ+iSyKjeDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qkkjJCpuifQWsCbonIH5cl8F4IFLOSfX3PT/7Uh182w=;
 b=Sw74HH2j9mBJGRbEW6/EJAEXBKfHEyFslqOGmTxPQa8fR0eF6NeIa5G57RYZIo6DhU1jmCvMabz4Gacc466qOlabUHJumTNZnceLepdivIDNKOEFi9UJ9+rsw0gqzLqo46keNzCdEVFa2KizMDjsmZLyQPEhQTRvB/NQJAGqqjgfmHGb3HJZS6WsVV4OHsZ+5ymLtIqEm+g+yUeyBJ/kNYSeNoHOxPhk+UhvKa61cqQpAW5sng+Nk1Iyzsrv0H0uKz0vASM/H3dcFDOzZerY+84fOgyvuCk0OSbngXTngum48IPbec0HyVM/byVi+qoONTBBNQcAH3qkGi9VRAWsbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qkkjJCpuifQWsCbonIH5cl8F4IFLOSfX3PT/7Uh182w=;
 b=pQTNt8OBH0+1mmv6UV8f+fmSPnPzUBFrga04gUC5oyrrO/9Rn7ipnSFWcjw2FJB5lglasMScBJGXERhAX0rJyB+ZKOCQRvoW9bf7Lrb7n9ipCsklcJW5kvXkwOzrDbQlnlGwmgPMcyeUXw/EMCH+INeoiCtCzMJKPNFZum+h/kD8U24D7sJ60G/jREunRzlDZQV1YQ2KVrUstfVJOHJfm4z2k3Tk2/mqfe8DoIn2DS5X3UFc2GgX0XekVy8/cWgP6Q8vQ4QziBuBFOmm9z3MAG57oDzPEsaQP8HdytVKEvrMnYyydPcuflQaAyP/ohNnOxTg9st0VxvdGAStOq8VfQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW4PR12MB6803.namprd12.prod.outlook.com (2603:10b6:303:20e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 7 Jul 2026
 15:55:16 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Tue, 7 Jul 2026
 15:55:16 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 Jul 2026 11:54:37 -0400
Message-Id: <DJSGLP9VFLRI.355AAWR2VHIEL@nvidia.com>
Subject: Re: [PATCH v12 2/4] mm/page_owner: add NUMA node filter
Cc: <surenb@google.com>, <mhocko@suse.com>, <jackmanb@google.com>,
 <hannes@cmpxchg.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
To: "Zhen Ni" <zhen.ni@easystack.cn>, <akpm@linux-foundation.org>,
 <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260707115411.1714314-1-zhen.ni@easystack.cn>
 <20260707115411.1714314-3-zhen.ni@easystack.cn>
In-Reply-To: <20260707115411.1714314-3-zhen.ni@easystack.cn>
X-ClientProxiedBy: DS1PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:8:233::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW4PR12MB6803:EE_
X-MS-Office365-Filtering-Correlation-Id: e1b78de2-6108-4fe4-9896-08dedc40234c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|4143699003|5023799004|11063799006|6133799003|56012099006|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	H+UpSihy60H16AIh6qFhU5fR5ZhWH6RbCNNMUimG0No+VXrzWbkr7tgok+XjKe/ACbJcHvpwdlKkPgtbUdetZKNroeNzUsDQzvZr7OvM8HEeoA68TkC1EsTcM8sLkd4QmAzcHU4oBkmTiWrWxZwMlVfiFGxapmEbyEUZOohvTTFsKggbUQemfIyGKjRs3KW3GADAM7GczMwxpJn2nqsABzjSmx4vXY8DyPWcQVvCvfvXahpxdYeaA47CnJ+0Q3MriKZpLLzUTgvJ7IthochnXOwy9Q6hsUYrNRSYEC+rBOEzydT1wpkj87ZINVdJfEAgCWmYzu6b0oV2igiMknFRa7SJYox3wzNGpBhCMvIWr3GRRvL43sAFdBoi05E4IhANhVAb2t+zxckGwq6Ow3XTYfEDe8fU0cpQ3xK0qtDsnnOu8SEC0HFk0d9KvzRapmVp98qbJYSmio98yRLu4tLSajc3PJp6Dc8QPIfnUY4g9xPtGUgmEusOGVWLczxNjpkbjgEuhQXYkXrJfcDxNngkxfynsxn+HmDy0bKMJX0/7b/OmEdXcsha1Z7kQtPeKK+T1E1noLCzMwH4eY53QuFn+Z/MCG4cyy48bJkPn7rzxMpwGP28xd3Ud9U5tMjGEI5y3EI5lXqAw5tfFTRzu69z0VcKa+06tA3pFXYOgvL7pzU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(4143699003)(5023799004)(11063799006)(6133799003)(56012099006)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWlFUS8vQk9NbFJJd0VMRUVwdGdaUzVGRnBqQ3BKbkt6Z2tCUE9tRHRVK1h1?=
 =?utf-8?B?d3BvNDFPaE9kWW55Q1QrRDROU0p1a2xGNUhFa2kxUVRMTkNHdTR6WFhCaG9V?=
 =?utf-8?B?UHJEU1NDNjZQUGtmRDBYdFhVM3B2bFpieHZpOFFldHd2ZUYrSnh4RUFJa2w4?=
 =?utf-8?B?eHpuVmQ0SkRDL3R4eDU5R0lTVmg4b1RENXhOVkU5MGgxL3VjTm5DTzZOUlIr?=
 =?utf-8?B?Q2pqRFI2TThYOHdrbG03Nk15UHdFRUpTZ3gwZ1BoNGRyNGNTR09tYWNDSW1s?=
 =?utf-8?B?QXFpVEZSWVlDOEV2R3NlcGs3UWFaU09RaGtpSTZtZXFCa2lJOHI5VjhDTTV0?=
 =?utf-8?B?TStQSmtEd21LellUNHhLMzlicG1UeXd2NUQveGZHbVVleWNFenAwd0wxZEJG?=
 =?utf-8?B?clF5TzNDUlBZNFN1dmxkZkY3aG92aitPSEVmOXJ6ZWJZU0wrREdkRGppd2d0?=
 =?utf-8?B?RHFlQitBWnk2NnJWaWpacGhyWGY4K0d1K2NDMTFnejk3VVllcUI0aC9meGdu?=
 =?utf-8?B?emlsMmlZT3NhSThzTGhwdGR2SEFiWFZoK2N1OVdOVU9HbFNOenRRenBGNkwy?=
 =?utf-8?B?VHdtaVlyWEh6c0pjZlVlUVREenppSTJaY2FLV0ZnUjdMSWUzZWErZzlkQ2Ju?=
 =?utf-8?B?Y2JmdHkrV1N0TUVYZnlwdEN5UFVJVDU1U0Z1QWswWXdRR0h2UVAwU2Jha3FF?=
 =?utf-8?B?bVJmME5YV0hBWTFJT01qeTJvVXY5dnoyYjQ0OUtIdnEyZ1JVSjYxYStBWEcx?=
 =?utf-8?B?ZHpGR25QN1NoQS84a09ud0JWd3JlSXNKU2dCTzQ3d1V1azg4UHUyVVNmbWg1?=
 =?utf-8?B?Y2F0WkN0Tk1EYlJTa211VXlpWHNuN3BiRlNlZlVvY1kyNFA3dUZ6T2xZbUxo?=
 =?utf-8?B?aTlzbUszSVRkZE9VZTdwZklJdEJ5Wk1pcVNoa3BqOTBpMmVlVzg2aFl2WXpS?=
 =?utf-8?B?cCtJWDlTU2JmNEsrUnpYSXFTTlhEVlBDc0V3WGxJQmlLbzlsR2ZKNFlibGVF?=
 =?utf-8?B?RmpxOVpuQlJ6TGIrUi9FTVc2NjAvK1VpUTMxQU1SbDUyc3BiUnd0Nm5BVUJB?=
 =?utf-8?B?UDhzVUFvM2RvVmFrdkIwRHFwUU5zMjE5ck94Wm01VDNGNG4wQm8yaUR2eWRv?=
 =?utf-8?B?L1hTTWVwT1ZxZ29JWnM1ZmhCdVMvRmxiOGNKeGpZb2xna0c0cjdWRkdyL2x2?=
 =?utf-8?B?M3FYOGp3ankwTzYxMDRPcXBUYm1Ec1M4bU5SYloraWhuNTllckhyZC92SFlz?=
 =?utf-8?B?QTU1UW41YXZ0bXNhZVRnM01ERzBwK0NXTlJIMHdMYm5ZWEVpM2M4RDBGWjRQ?=
 =?utf-8?B?QVRjTlAyQkdsUlVIWG5SYnVGYzhpRHlDRDVURmFtWStpN0VZZHlic3ZtTHRJ?=
 =?utf-8?B?VDJkbTBQVTVPTHJrbFZlZXltalc2d0MxVlFHWXVnbE5xS1UwSE1mNEVEdU5x?=
 =?utf-8?B?RittbitPTzBOYmFXU1lLOXRXSTc3RGR5Z1lrSWs2YmJ0cytpVnFEQ0srZXRQ?=
 =?utf-8?B?YnpOZFRKNDFJVkNoby85L0hFT2h1WnFLTHNnNHdrQmp3TjAySHRkNUhORWJj?=
 =?utf-8?B?R1YxLyt2NEpiNG9ON2xnc2NnTmwwZk5ybjNCK1ppMG9KNzBmV3hBQWNuR050?=
 =?utf-8?B?Vkw5Q2J6cGNVbitBYk8rUDdQZ0VxWmJMQlN5aUtMaG44ckp2dTJIbHRTM3BW?=
 =?utf-8?B?M0t0OWdDVm9IMEZDSG9KckNSbURBZHZLREovNkdza2RPdnFwYU5tN0RLYzQ5?=
 =?utf-8?B?TWhWNitHczBvRWtDRHgxdlB1WDYwRjBSN3VSYTdxVjF3ZzVxbzVwdjRBUnIx?=
 =?utf-8?B?dEN0dTZQNGdjK29XWXIxaW5BMC95WGk2UmhaMEVIL0lsbDJLdVV4U2dIc1Jl?=
 =?utf-8?B?VXhWMkxhQUs4Y3BlYkxwaUN6QUNaUS9hWUgyZlRBQnAzK3AxWUNncDYybFZs?=
 =?utf-8?B?S3czQUUyQ3BLb1RRNnlBbkZnOWNzYlg3clJTdktwek0wckY2cEF6Vlp2ZDJM?=
 =?utf-8?B?cjdqenBKL2xiRUlQdjRONWJuNWpaQ2ZwbGt6QXZxS1I5bHI0WENEaDNsZnd3?=
 =?utf-8?B?WEVoL0h3Q09SVi8rMGthWi9PemV2ZnE0SWEwZHpMR3dZRTdNNVVKZXJZaXhD?=
 =?utf-8?B?SFdrb2hON1NEekhEcUFaYUFWa2VUZFNOa2NXeVAyK1g2Ujhhd3ZLNWhldmxE?=
 =?utf-8?B?MFJlWFFYc2dOZWo5RERKTDJVQ2VPenhXKzhqWUZ4YmQ0VTlraTl0VmJweUlk?=
 =?utf-8?B?dWlSRHk3Sm1sZHhwVXpVa2dyN21oQVduQk53YTkyWHlKdUdLejFWcndkK21H?=
 =?utf-8?Q?tlFxSzLWoqCULjAHbg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b78de2-6108-4fe4-9896-08dedc40234c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 15:55:16.2931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JfiVjucyySuI2DkAOQFky4eQqmpZtYJj+zrP6aW6LNUBs/hz0h16dpxvVMW/PI2x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6803
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8865980009
X-Stat-Signature: hnxcgyhfys3yxhh4sbsfuqebc8dt77zc
X-HE-Tag: 1783439727-191776
X-HE-Meta: U2FsdGVkX18+wO+VEywim0kae+YfWLI/NiCh3dvwoYP3hunF2NmOVaj4QJF9F+ctvVwxHu6KCSRo2aWrydZNdVqMd2AsNlITusrzZafiTZAtI4Mj85CuZA+ToqiQxENGyNqz/cUvNdGp8sFGdZ/S4l6XVNS9N7vPRe4b5FmMWH2rwDeRWlCyzV9yeHeaImkljWzlxBjDVp3Ly/bwH1y+calBNusLfENL586LQyxoaoPkX23UjdN8NUL0Ag+WlmfJILUyrTxf5AYHbB6VQCscfvrw5dz75Z26wC0BQC1PyslxQHbVfOf005q8BdQOCHDr33Qf86Ix8bCqmABQtri8RVcOn6QsOIRX40XDDn+0eGOmoz6wys1N3UJ0MUOhczHK172uf3sjvpM7UElVd5LNR7INEN+8UoPMtQo+0F/hQehXjAfZasnp2UDRO/qd+ebd/UJQr5j+Kb+Hr7Yil7FvPHsGfj7GBx69fKbnqGKn+HWHcCb7Dp9ctbhSdG+G9ZfzvoENIpbHqYS7xAYdDpTFPzX+KmdqHlgE7UZ2sY81Du3/LUU73yyGEY80tFS/pRyL4lykFIjZwwp4OPBjKrw+3vgv06zdBPPsqhTFCTA/zygyVYQ2Baca3Wedo1PbW+Se2Qg90RVvhfq9NMcVAD2QZE7TZbkn2J++puT+3LV4a8u4ZnZTJNYf2rJjmKVBPYugYhJB/HB5rb67l8HjPUMYC99p5+NkTRayU9LMj/Gl+QrTnsaRcOKAjVUxLLIPabG/fVnifKDxWwZyvz8VGd1FXg2WpbfWlwDz2D787DLdPzwdnmLb6Ey9d2OA3h79CkDLP9a4JBBonOlC+JQjf74wDdbDnSPFMYLg60SeGL+CycZnH1FPaZ65g7q+mvjzv3wsIhalMMLAeU16zg2YXnGjoGKrolExdRNO7eSrW6IqLnIiEHRGFTWia1BtLmwoMXnuKjLH0613ztnoDR1XufP
 dG5sHpfa
 YhpsKs8zn849ctC+aFG3FnQpabOBEgEqftwvvSaXLli2ubQ3RDho4UFl7v7UHou0mkBaBhNjZtt4DHnlYa6cq4YGb8xqOqxQ8X5Bl6QPplA56YeYYX97pfH62Gx8mEMUnDCDmbHsZfbaUpI4inOZLiFdmWp4UoBOrn7emM+ap4hfF/tu1jSyfdjkFdehFhW3zD14ynQbrJMH92yDa9VpYYkn4kmLa2DfBZIy41ntxn90KLIMBxWt5DgHLLauAjtZTOZw98W8n+R6t0+iSoiXF52vGQ0eZ0emk0xlLa/WkUApUx5z4+VhCUZxaXTN0u3jzCJRb91VsrXLjbCDa3EK/oPJIXl1WYNDtnJQEmPInRWI0LEsp/83cPrEWhMOUkRmWEeTZ8b/unhxu+uQgIWHXYApNh6xAqXGhC0jznchdXlvkKNoDo5vsTqrlhXmY98oETJiqniwVCsdCvDgoe/wb+kdJmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jul 7, 2026 at 7:54 AM EDT, Zhen Ni wrote:
> Add NUMA node filtering functionality to page_owner to allow filtering
> pages by specific NUMA node(s). This is useful for NUMA-aware memory
> allocation analysis and debugging.
>
> The filter supports flexible input formats:
> - Single node: nid=3D0
> - Multiple nodes: nid=3D0,2,3
> - Node range: nid=3D0-3
> - Mixed format: nid=3D0,2-4,7
>
> Example usage:
>   # Using the page_owner_filter tool (recommended)
>   ./page_owner_filter -n 0-3
>   ./page_owner_filter -m stack_handle -n 0,2-4,7
>
> The implementation uses per-file-descriptor filter state stored in
> file->private_data, allowing each opener to have independent filter
> configuration. It uses nodemask_t for efficient multi-node filtering and
> nodelist_parse() for flexible input parsing. Node validity is verified
> using nodes_subset() to reject nodes without memory.
>
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> Tested-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> ---
> Changes in v12:
> - Remove spinlock protection
>
> Changes in v11:
> - Remove 'nid' member from struct page_owner to save memory
> - Read page->flags directly with poison checking
>
> Changes in v10:
> - Add 'nid' member to struct page_owner and record it at allocation time
> - Remove need_resched() check, call cond_resched() unconditionally
> - Update NUMA filter to use saved nid instead of page_to_nid()
>
> Changes in v9:
> - Add spinlock protection for NUMA filter state access
> - Use memdesc_nid() instead of page_to_nid() to bypass PF_POISONED_CHECK(=
)
>
> Changes in v8:
> - Add cond_resched() in page iteration loop to prevent RCU stalls
> - Reject empty nid list to avoid enabling an empty filter
> - Improve comment: "Commit all filter changes"
>
> Changes in v7:
> - per-file-descriptor implementation
>
> Changes in v6:
> - Add node validity check using nodes_subset
>   to reject invalid node numbers that don't exist in the system
> - Move bool filter_by_nid declaration to top of block
> - Use kmalloc_objs instead of kmalloc
> - Remove 100 bytes overhead
>
> Changes in v5:
> - Optimize nodes_empty() check in page iteration loop
> - Add __data_racy qualifier to nid_mask field
>
> Changes in v4:
> - Remove "-1" support, use empty string to clear filter
> - Use strncpy_from_user() instead of copy_from_user()
> - Add concurrency safety documentation for nid_mask access
> - Rename fops to page_owner_nid_filter_fops for consistency
>
> Changes in v3:
> - Remove READ_ONCE/WRITE_ONCE for nodemask_t (fixes compilation errors)
>   * nodemask_t is a large structure (128 bytes) that triggers compile-tim=
e asserts
>   * Direct assignment is safe for this use case
> - Add comment explaining input length calculation formula
>   * 6 bytes =3D ",NNNNN" (comma + 5-digit node number)
> - Simplify "-1" check using kstrtoint() instead of dual strcmp()
> - Move nodemask_t mask read outside PFN iteration loop for performance
>   * Avoids 128-byte structure copy on each iteration
>
> Changes in v2:
> - Use nodemask_t instead of int to support multiple nodes
> - Implement nodelist_parse() to support flexible input formats
>   * Single node: "0", "2"
>   * Multiple nodes: "0,2,3"
>   * Ranges: "0-3"
>   * Mixed: "0,2-4,7"
> - Use %*pbl format for output (e.g., "0-2", "0,2-4,7")
> - Use dynamic memory allocation (kmalloc) to handle variable-length input
> - Follow cpuset's max_write_len pattern: (100 + 6 * MAX_NUMNODES)
>
> v11: https://lore.kernel.org/linux-mm/20260625043101.338794-3-zhen.ni@eas=
ystack.cn/
> v10: https://lore.kernel.org/linux-mm/20260618035750.3724613-3-zhen.ni@ea=
systack.cn/
> v9: https://lore.kernel.org/linux-mm/20260525081652.2210206-3-zhen.ni@eas=
ystack.cn/
> v8: https://lore.kernel.org/linux-mm/20260520075641.1931080-3-zhen.ni@eas=
ystack.cn/
> v7: https://lore.kernel.org/linux-mm/20260515091942.1535677-3-zhen.ni@eas=
ystack.cn/
> v6: https://lore.kernel.org/linux-mm/20260511033017.747781-3-zhen.ni@easy=
stack.cn/
> v5: https://lore.kernel.org/linux-mm/20260507064643.179187-3-zhen.ni@easy=
stack.cn/
> v4: https://lore.kernel.org/linux-mm/20260430163247.13628-3-zhen.ni@easys=
tack.cn/
> v3: https://lore.kernel.org/linux-mm/20260428071112.1420380-4-zhen.ni@eas=
ystack.cn/
> v2: https://lore.kernel.org/linux-mm/20260419155540.376847-4-zhen.ni@easy=
stack.cn/
> v1: https://lore.kernel.org/linux-mm/20260417154638.22370-4-zhen.ni@easys=
tack.cn/
> ---
>  mm/page_owner.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 52 insertions(+), 2 deletions(-)
>

The fixup below fixes a compilation error.


diff --git a/mm/page_owner.c b/mm/page_owner.c
index da723b80b7702..3fb238e9821e4 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -811,7 +811,7 @@ read_page_owner(struct file *file, char __user *buf, si=
ze_t count, loff_t *ppos)
 			 */
 			if (page_flags.f =3D=3D PAGE_POISON_PATTERN)
 				goto ext_put_continue;
-			nid =3D memdesc_nid(page_flags);
+			nid =3D memdesc_nid(&page_flags);
 			if (!node_isset(nid, state->nid_filter))
 				goto ext_put_continue;
 		}


--=20
Best Regards,
Yan, Zi


