Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6A6EC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A48B26B0093; Mon,  7 Sep 2026 22:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F9276B0095; Mon,  7 Sep 2026 22:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C126B0096; Mon,  7 Sep 2026 22:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 54A9D6B0093
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:56:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3F8B40380
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:56:37 +0000 (UTC)
X-FDA: 85189082034.24.3F22A81
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011023.outbound.protection.outlook.com [40.93.194.23])
	by imf31.hostedemail.com (Postfix) with ESMTP id D4B5E20002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:56:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GV7KqV7t;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9fw3H63mFOM5wM+X5HnSTRkGMbpfnfajuq1vd0Z/41I=;
	b=UwvJ3bpg0cckvEqr6QXEH0EcEX3Um32K1DCRi2OUaNPvk7rUjX5MQ6UXvl/R6gvMsLiSvg
	/yqqZ9YgQPgyG/xCRW6AoDJazFXazzGxSLsiVFRJMcj3xxUbCXs3B9hdfaknEJUsrQ34D9
	78tWj0U+T8w4p96W9fIVtg5j2T6WNEY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788836195;
	b=CeJHct6Fkt8ooh8xZavLSYYED5O8fAYBprUsNVLXGRKKKrFyTUgIBEYCg6PvOBn6zf9ZIA
	RORSw3WJYvavO/dB6Z/twQS0DjQN02SiWDuG3HZqcnFFW/oq5v73wr53DU6maBRrRz80qA
	dExV0PpOtsOrC0h5XJfGXB54RDw4CNw=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GV7KqV7t;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QLAqNoLcbXKJg1Csum+zY0d5yHs/0PkcHvsodgU0hL8/+nwVoNQV1NZr7ozB3uuOOG7jFB1QsNkuhxMyXjVTbfAe3i84HLxJT6tOM/oC9xlSJbtgvqoxZKY4/5FHd0n1H1Du4PQ5TgWULTGSp0w2+HsRbaQ87/hUx2OhUSybeE5XalJKv9iKhpLyZpVHZH38PfMyThfCzPRgUNIIN2CJpk+Kak+IR+MxEBbuwYmT983nPNOW3xKheEt7ysGNv5mAu468gympzo6RG1nO4gxQQ7UKXluu3j6wltxZSAKT6Ojz4ee2SXkHAfhv9LZ1Lfq4Ygf4/HMZGJcayxhSEMlDFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9fw3H63mFOM5wM+X5HnSTRkGMbpfnfajuq1vd0Z/41I=;
 b=g3aoeeVgZcaS3t1rrOxj+NTNllqMS0EjYgOL5kQFjqJhKpufXJa+JIv0Zo4P53AH2MELAcdrbbri+vBCbbkacLAM3P6F/UniIZnm8LhBhVrxSw3TMssAyeHdJjrCFukVw49+TcqPrWEWASM5FCnLy1CMG3n4C44NEGDV37xN5T2qonYGIl3gNT5xkyXazTeVmZC2ZhbnKnm1KBd0tglrgcuXaRe5aXbJdySTvFxTFSWUvB/ncpWzJ/0SuHd3dzvKb7AIxaIn/aDh/vSAh1PO5wq5HLuH/ao2PVr8WSTdvTik3lC6XQOkhBnMFMFStseCidYTVU2kGDbPqK6T6qsO0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9fw3H63mFOM5wM+X5HnSTRkGMbpfnfajuq1vd0Z/41I=;
 b=GV7KqV7tKxWgohhOZuRuCre2xHkurS4/8Rpnhhun+i/9DTBeENi9DDRQgBcSg4UHmSO0fM5lAyOTT2D4moXGVnLw0Xrl2Qa815zbFriyoSJ7nx5Ld1BLGcHdpFoXH0hBo2rETuCeOf5XTr4JwToGrWoCW1sYnWkJoskmS1B0y6Qoc8e8zYS+x8F0hfdOM6BLNCK183Sm1F7rPLCKeoO7/DYj/VeCJTHog+AYG/4HY/iJlDdTOKeYH01Boz2/VhfK7yN8sHCYa7fYltUu0YtSjPaVi+YGuUHdXDDuI9lYfLGjWtnQ9TKOswuYR7/EFtghs0LGFTPKmj+cpXjx6GPgZg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4435.namprd12.prod.outlook.com (2603:10b6:5:2a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 02:56:28 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 02:56:28 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 07 Sep 2026 22:56:08 -0400
Subject: [PATCH v3 01/14] mm/zsmalloc: replace PG_private with pointer
 comparison
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-remove-pg_private-v3-1-6ae22f9d9272@nvidia.com>
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
 Zi Yan <ziy@nvidia.com>, Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>
X-Mailer: b4 0.15.2
X-ClientProxiedBy: BL1PR13CA0286.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4435:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d173bf6-e8de-403c-cd45-08df0d54c720
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	aOEmDer+kidDygyELFXVwVgBPnjbwlrQXWD5/l+Jfr1dwCpthEZO5+WZhyrKrHgyArCzc+Ts19mpApb7jrnS6d6TD1ijQFqfj409MubJ+C+ILb3r4r1aIdzkGmCxL3/fTlO93u/CKgl9bkz5NAwsJovZR/ZfwJJojfAeiTmjPmQCkiGZGCVNcuJSEaej+T9kZtcTjo1ZzN192u/YOuv/OEzz/N8Ga3xkCe/WaLnAsSD6PN/MwzFQuAjyNKR6qh0RaZEWVUllbMXm4e/HK6nn9ChjoA2JCWZAtPsLvUIk+eBOog8kHEF1uNFbEcomZvyHf+v59qLu9a4WcDvSA257ygYlDJ3tyPDEhp+T8nb/xG29axHK7fJrmIAyvnIbW9g6GnrRor2Bm/HUJiJSZALa1r1OhqnT8QICbhfdTBub+EVRpcTOFZPH/rv8j5jMHXDuaC85H+e8wjfxVTX8hdu1fqCAiC7k5Yw2QYIBUhHp1RhKLYPRDy6YCfUpdO+nUlqLr3CarDBmLAdYJ/r7dq8kov3g26FNY4E595ugvhlWhLminPaUchWtY9s1d2bPQ75bKUjJH7A3a+Zl5Rxiek8wFxSz+68TR03viXRmDgG5ANJRkDdTATZMfI7e1iXA7NST5xaN4t9RzWmzEJ0q7XMOZq9p1LsLKj5m2qf92X8L1S/H55at+UAq8gPwQMoORY9f3O5quUOennPZ0CtoUdBFEA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VEoxdWFTYllWeE1RWFpZQjJJTDdBSUl1Y3RDdEZEdXZnS3hsNDl3bzFMQ3RC?=
 =?utf-8?B?cFRvWlNzdDRkejZkaHFwUVpYUW9ldlFpNkhHSklJdFpLdkRRaUdza1FYMEFl?=
 =?utf-8?B?cFV3TG9rT0kwc1ZOeE1ZNVl4TUdtK24wNUlBS09wUXhHTEZWclMvbFhicHZZ?=
 =?utf-8?B?K1V0TjEzeVBpdWRPM1dTaFRmTVlEL1c0RDRzYWliNGRYbmJtVmRTNjNDSysw?=
 =?utf-8?B?UnpOY296UmNKOEZ3aldYVzZWeGJLUndoN0p3bFB1c2RBV1lvTy9zaDRGZERZ?=
 =?utf-8?B?NmNHMS9KMWQxUHcwUFRSQTl5ZWYwQlZkanI2UGhOQUdqLzhhWEtETDFSakxa?=
 =?utf-8?B?eC9OK0IybDl0R1RTLzluR0YvSFd3ZGY3c0QxV2dmSmZhc29CWGY1K3FyK3lI?=
 =?utf-8?B?VGhxaTN5dkVwVWZIdmo5RVBydU9xbEZWbkxMbS8rZkVzS0lHaDhDR0ExMlhQ?=
 =?utf-8?B?aSs0clNGNUNwbFZTL3l6R2JscmhwNjBDdVhRTFBuWFZ3bXV3dUdKTTR0SDhG?=
 =?utf-8?B?czYzeStTWDhaalBSOEY4RE1sUUJJTmJWa1cvd01wMEtEVzhqcVlLRzlQMUl3?=
 =?utf-8?B?YjgwMVlrdzgzMWZuTWtoVmFIUmR0QXlUQU1QV01DWG1ldmxQbFl6NjR5QlVw?=
 =?utf-8?B?cmRkZUZ5bVpZcUV3cHd2T3p6T1JCTC9EU05kUms4WXNWZW9UNFVXMForVEd5?=
 =?utf-8?B?QnVveWNleDRpMWpUY2tENFlSTzdqRHM4Rmo3ckx2a2xFbVdzU0xCUnVYZE5t?=
 =?utf-8?B?bnhnUEJvaU9tMVNsb1IwaWtvMi9LSndmbWVBcitVeGRkeS9OTUtNTENvOGg4?=
 =?utf-8?B?eEptWTZkVDN0VWtydmNlaWxYV3dNaFV1emRybTAza1ltT0xNVnJJbkRCbXM3?=
 =?utf-8?B?OFUwbi81UjdpRFZHaHJYM0d1am1UUmlJK25MeVByMXUxSDk1K1FFd2FiSUdl?=
 =?utf-8?B?RHRZK1h0dzdNa2lXQUs0RWQ5N3RhcWJZNHBzTlRxZnY4K0IxTFNUaXpDU0wx?=
 =?utf-8?B?Z2t2d1Q2a25lUnpkbjFTb1hpWkhBZjlPcGZvWlhRQ2pBcVVseUtsVFJvZVdL?=
 =?utf-8?B?U3lRUCtpZVBSTndmYUx3a1Y1ekE4R0dteGJWOTRxbXVmK2dCTVNjV1YrM21r?=
 =?utf-8?B?b01hK2VNNWEwMkRTL0lVNStqRGFaOTd0TlNMM2NDb002WngwNnd3VXpOUGZD?=
 =?utf-8?B?b2hDcGErV2RHSmVZbmtRRXJYYlQxbDZZbUU5VWRmbExsYUp6NElic3R5cXFH?=
 =?utf-8?B?bytZRldzam8wckdlOHhnRVZwUU50ditDWVdOZks1SVU1akJCV1NMRk54ODBS?=
 =?utf-8?B?Q1VyWGt3c0g3WlJqVmhjVW5UcVdMbHBTUUVzb1A1QVNpK0I5aGFIcDBZWVl1?=
 =?utf-8?B?QU5sc3FFQW5mSzhTQ3ZoN05CaTBxb3J5ZlFCVFBnR1dJSEFRTjhaK09BNmRl?=
 =?utf-8?B?eFdEQ0RnbjhyQUhDNWJ1TGRjeXkwV3hwTGtXRUxPbDFUWlUreVBoU1k2Rm12?=
 =?utf-8?B?NVhDM2Q2NUV4VW9QZUdYSDUwenNrRmQyMUpOYVREZS9LakJPQmJvVFJtTnR4?=
 =?utf-8?B?WFNZSlpBTDRXRDRsVUFDVThqQjN5c2dZTGRoVnQ5ZlZoQUlGZ2lOREZJRVdu?=
 =?utf-8?B?SDNGL2dPQUY0USsxcThLdzkweXhUTDQ5MDRZZGN3KzE0ZlgzbllQb1JsZkd4?=
 =?utf-8?B?S0RyYXNjMmRnditEVHdkdldia2Y3eVVGK1pZdjJLbGg4bHh5a2hadHhHb3Uz?=
 =?utf-8?B?TlZIenA4Um5WK2ZCTXRNUlF1OWxjYUE1dyt0cVFIYkpSSTFUekEveEJyUU5p?=
 =?utf-8?B?M05XSWNJaFVTa1lzN3hhQXR4dFl4TElSQlV5b1AvOXAwa1lRcmhpNTNDQzR4?=
 =?utf-8?B?dW9JM1ZGeE1NQ3l5c3RnVkNYcXgzYnpnM1ZyT3h0dUtUcUJxN1dhTzZiZUll?=
 =?utf-8?B?ZFVwN1h2TzFrVENrb0NwUVFHa0ZpQjRlTzkxa3RLcmxBOHl0d25JU3M1ZGJK?=
 =?utf-8?B?NEIxb0c0enVHcCtQUWlaQkR5azRLNmlmbDU0QzZ1eWQ1aUF0cG50bW1odHpk?=
 =?utf-8?B?ZUJ4c0ovT215eHN3d3lBajgzVGxPRWJCSHR6dFNQbTQ0dndwcGY5d1BDMitU?=
 =?utf-8?B?YldyTmtxRmhQM2E0YTBxZGZtZXN1b0V3OHFxODI5SVB2YVlsZzJ4L2FOMEdk?=
 =?utf-8?B?bzljNjRtTHh3T0M2MHlBWGJLYVZJVlNaamFZOEFDT3dvRnBJUkRqbXlMcXd6?=
 =?utf-8?B?emNCYUNPaXQ2aUZrV2FPVmJERHc5eDl0bktzeXgxb20zR3Fuby9CNmVFcHN0?=
 =?utf-8?Q?tIVt0yNYzcI+yR2pK1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d173bf6-e8de-403c-cd45-08df0d54c720
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 02:56:27.9978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yX0AZ8rW4JJVr/EbNyAgnDzwRpG9IY+NK0itiD32D6MulIL6Bi/wg2FMwBG/xTLD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4435
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D4B5E20002
X-Stat-Signature: subhi987btfegssrjfyxzf13mo5zej4d
X-HE-Tag: 1788836194-821980
X-HE-Meta: U2FsdGVkX198EUUZeqigOQGcOwCxlq3KLIAzvqyW630GFZQ3K294/xQGWyGAYXH+7KJaUw7fxWEUoAE3Y/po0foz0I2vtPWRJFOmZ3yfh6sNz4y/JrDph8gBZ6rAVZt3k44ZZ14dmsZLefbP59zGQUDnSlnztVdxJefmwrpZ4fuViKD1ukkHtCBVhH0uYLR3K+Vtct6DJSPKsZ8Qj2LIlX4oOisd14PBbtbDuRN2p+T77aidD1bwLUaGuqrfomJ74EOeEEzFlMPVhQ/N+4Zojd3d992hTkGjAFsySAJ20/qxw7iFYRSMIt5SV8jWpAAwanH04HMXIsrF91rfpTqLNI86M1x/NMh82Nmso541STKDN4GoodmY/NJIl9zxGK7YOyJT1LzvWW/bOJJEdVkWlMIkaxTzQmBMUd5tJ650HBWQZ76E4cGB0YOx9RTOOGZCoXNzvtmhY6V6YTLrparIhpG7RMYIE7J/1n3+akinUu073RegEzqXHzLCVRq8v1egpmlm6sUzbSIanUU4FFoAK5hvieNArOHNmt9xU8YuPLoGpa/B42rXCoFVUYZ3ljuZpJTimOS9o4sA+2qWnvgmcsC29It51N+K/5hrfLLGQwvfGS36A6QKOZO9nStAtNm+uf21bm6gf6h5Vkkxnnuc36S9XchgehisUg5bFMB7s7R1R+xtrmAB5B4H9ToSerQ/kXtOOcZVUbhNZtw5go6gqxB7jjhqGZXshWfqLp4qy6mC3ThOxpZjozplDS9PStUulH5RjOpuqwTO8UPD/JFMdzUL5y8wVhapMP4jsN+240YKCHbd8mrSJN62PTrGSoGYrRSUy22eGdKq6aOk0MQEKHH1YTBxLnn9GcvP/ZEJ5dVXefbwjxx/mWbmrgHZu8QePOwyVieBL7vmVcHpjRU462Lp4p06MgmOQrtX+byZbOSEDRIbqWLt3aUMoABfyhO5jAj2ng9M2wpnnVueo1o
 McgP51rA
 3nyP27/46yrl9qnmrUqyzi6uHhFRMIpRiQPMO23RWYETRU+aNFKmrdAu9s+ps1S2YqWyk6UGjwOK5eB/0X9J1JIkoHIPqpNj+1MZNJS9XbcXpp3ndiIbJyZuioaiQHeAOkJgJlGUyGE8xIQh7Q/Dl1aO3PjzjMJQ4tTUvgLLm7bOkdvueu0XGq9bI5eI8eLEs4URWl2b+2rnh8n1LDpba93M9BZNTKyTQ3YsL+jgA9NRdZvIEBeMC5SRt6oillHMkS2OEg8o3PJhGFAaNl4hMlglcQ1K5ZeCCdhPMMI8MOz1mGcO7y28djyZHakAMgS/Abh4T72oLsA5kim8eIoTAw4YyRhTy3rt28FtOuM+uXOsbJNwN1wczdIci0p9tPHg2bS9B7zEXGgbYFKCzM1ce2GhF2hS/k1FOVqUqjtCNVmcZDF83194dHnKvC9Y067GTFhN6Gi3jbhiCEwpXlPnxOqDQVY2Qp2OjkzTu5eDwq6GDSYcgrXVs7tGYbs1LUiWGngMX3hEKFYN67wW/rBookbW6Md3K/zBLY8DCVM1ledx4apwtTcZGvxJ0o9c6oZ5azvm275WaPCfbwQzKnYrEmZzD9CyrwQ6n9G786mJytysAgYIwgjWw+UWOmYm37kZPDxz9uHyitiR64vElh9kV/FCReuJQkjUVIUKC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zsmalloc uses PG_private to indicate first zpdesc in a zspage chain. It is
equivalent to check zpdesc == zspage->first_zpdesc. Replace
is_first_zpdesc() with zpdesc == zspage->first_zpdesc in obj_allocated().

For get_first_zpdesc(), first_zpdesc is from zspage->first_zpdesc, so
replace is_first_zpdesc() with first_zpdesc->zspage == zspage, the second
requirement of a zspage chain, where all zpdescs point to the same zspage.

is_first_zpdesc(), is only used in VM_BUG_ON_PAGE(), so performance impact
should be negligible. While at it, change VM_BUG_ON() to
VM_WARN_ON_ONCE_PAGE().

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
To: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/zpdesc.h   |  2 +-
 mm/zsmalloc.c | 24 ++++++------------------
 2 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/mm/zpdesc.h b/mm/zpdesc.h
index b8258dc78548d..4fd81c2e80769 100644
--- a/mm/zpdesc.h
+++ b/mm/zpdesc.h
@@ -26,8 +26,8 @@
  * with memcg_data.
  *
  * Page flags used:
- * * PG_private identifies the first component page.
  * * PG_locked is used by page migration code.
+ * The first component page has zpdesc->zspage->first_zpdesc == zpdesc
  */
 struct zpdesc {
 	unsigned long flags;
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 825022a7a328f..24526185fd31f 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -290,11 +290,6 @@ struct zs_pool {
 	atomic_t compaction_in_progress;
 };
 
-static inline void zpdesc_set_first(struct zpdesc *zpdesc)
-{
-	SetPagePrivate(zpdesc_page(zpdesc));
-}
-
 static inline void zpdesc_inc_zone_page_state(struct zpdesc *zpdesc)
 {
 	inc_zone_page_state(zpdesc_page(zpdesc), NR_ZSPAGES);
@@ -476,11 +471,6 @@ static void record_obj(unsigned long handle, unsigned long obj)
 	WRITE_ONCE(*(unsigned long *)handle, obj);
 }
 
-static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
-{
-	return PagePrivate(zpdesc_page(zpdesc));
-}
-
 /* Protected by class->lock */
 static inline int get_zspage_inuse(struct zspage *zspage)
 {
@@ -496,7 +486,8 @@ static struct zpdesc *get_first_zpdesc(struct zspage *zspage)
 {
 	struct zpdesc *first_zpdesc = zspage->first_zpdesc;
 
-	VM_BUG_ON_PAGE(!is_first_zpdesc(first_zpdesc), zpdesc_page(first_zpdesc));
+	/* the first zpdesc must point back to this zspage */
+	VM_WARN_ON_ONCE_PAGE(first_zpdesc->zspage != zspage, zpdesc_page(first_zpdesc));
 	return first_zpdesc;
 }
 
@@ -838,7 +829,8 @@ static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
 	struct zspage *zspage = get_zspage(zpdesc);
 
 	if (unlikely(ZsHugePage(zspage))) {
-		VM_BUG_ON_PAGE(!is_first_zpdesc(zpdesc), zpdesc_page(zpdesc));
+		/* only first zpdesc holds the handle */
+		VM_WARN_ON_ONCE_PAGE(zspage->first_zpdesc != zpdesc, zpdesc_page(zpdesc));
 		handle = zpdesc->handle;
 	} else
 		handle = *(unsigned long *)obj;
@@ -853,9 +845,6 @@ static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
 
 static void reset_zpdesc(struct zpdesc *zpdesc)
 {
-	struct page *page = zpdesc_page(zpdesc);
-
-	ClearPagePrivate(page);
 	zpdesc->zspage = NULL;
 	zpdesc->next = NULL;
 	/* PageZsmalloc is sticky until the page is freed to the buddy. */
@@ -1006,8 +995,8 @@ static void create_page_chain(struct size_class *class, struct zspage *zspage,
 	 * 1. all pages are linked together using zpdesc->next
 	 * 2. each sub-page point to zspage using zpdesc->zspage
 	 *
-	 * we set PG_private to identify the first zpdesc (i.e. no other zpdesc
-	 * has this flag set).
+	 * The first zpdesc has its zspage->first_zpdesc set to itself, no
+	 * other zpdesc has this set.
 	 */
 	for (i = 0; i < nr_zpdescs; i++) {
 		zpdesc = zpdescs[i];
@@ -1015,7 +1004,6 @@ static void create_page_chain(struct size_class *class, struct zspage *zspage,
 		zpdesc->next = NULL;
 		if (i == 0) {
 			zspage->first_zpdesc = zpdesc;
-			zpdesc_set_first(zpdesc);
 			if (unlikely(class->objs_per_zspage == 1 &&
 					class->pages_per_zspage == 1))
 				SetZsHugePage(zspage);

-- 
2.53.0


