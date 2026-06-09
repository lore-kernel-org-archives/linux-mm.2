Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00513CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F9C76B0088; Tue,  9 Jun 2026 10:07:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AA756B008A; Tue,  9 Jun 2026 10:07:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 173016B008C; Tue,  9 Jun 2026 10:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05DE86B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:07:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4DB91C146F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:07:31 +0000 (UTC)
X-FDA: 84860551902.24.6F2101F
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010021.outbound.protection.outlook.com [52.101.201.21])
	by imf25.hostedemail.com (Postfix) with ESMTP id D0984A001B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:07:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OLlInpZk;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781014049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yMhR78U3lnBOoyU0FBotXnURlWnGQC85qSxaCUWPDZA=;
	b=wclueEM5gNdIp70OZPR/86A8WKhrDvpu9jhUcjpVjMZrbLw+CPJ7BBJn+oYjLOTXvMhXXR
	mn4ppG33i5hNxBJBPrqnu1EXAPG1FnVKJ+lLEIr9O8M4Ji3MAq01GjQMdwyoOjA9xstUUF
	IFAl1uV42KbM5Jt9bayUG21pUls5a0o=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OLlInpZk;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781014049;
	b=HrO1OFxGoTiiNgxntw2+ibGYKVgF2XhQSfhHHi64l7uOdSuNiHMcte9ha9s89ksVwwzXdS
	DIaMW95CsennJT3XbJ3wg1WJQqKXUoyLNncwDZqB6qsba0ZruhBu0lVbcdLGeIZVz2neO4
	RkmUnorSO962mnYPhpReQqfw/yHihQg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tjAbLOPAHixomfPlDLplBze3nfLwatUJOkKvP7fvN3P+6QaRFkB7xkXPdZPegRDK7uNMWjxjTV5Ga6S8ihrZ28zEdiOm5dTmHbOrXdqSdI6cYFanXok0FxWWdElo1nw6WHUQFRX+5tOFFjgphq03lZ3pVwMi9HSre7aDukC/fgM5TnDSGmOp9iQ8jU4nmbb2AA8BFn9w2smQt7HA65I/jAu7D5xkvr62NoA8ZjFvmUSeFiNdgaKIuoYteKJgv/bQy4jF7EbQ85b+DU40pAR6k2NtzU6aypRr+WPXEOVHF+DqjchcyDIsl4UvlEMrhly9IbmNIWFTkuNroMBuoMa6bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yMhR78U3lnBOoyU0FBotXnURlWnGQC85qSxaCUWPDZA=;
 b=rnHosUMGfXq7Ad6y+jse+QAJTeEsRVxc3bmn9nr93kQTNkeCFZr+7vBOn5UVVRzrdY3SaZhpkHakmxga6l6QV2tVLorex3X3ETsUrMNFl3+sUVkwpYx8xYfYE2EAtLnGU3G9PthwMBdZuI1UvOLuVGwiteO+T2q3W6WIdMHfL3Jnmy7sXV7QAOOLiLEs7+TdMDvUpBpn2xzyX3hNspdylfB4SXIp2b7pHcQdG6Z0FYP+BXpXCaD9/ARQONCcFN3vtzP2o5i8oQx/DyRK2xo3JoWfyIr0HtKIuxPjJKaZgFpxsPjJdQMke9EaO4przlipEXgUcfCWvsQ8tUo1heXCiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yMhR78U3lnBOoyU0FBotXnURlWnGQC85qSxaCUWPDZA=;
 b=OLlInpZkbQ7wEKKhpqXuObdYm8evfXc/vu+NQ7bqx6m2R7SpGAPx4GpV18mkRP+oB+8KLK3FTdqp1onjztpQE8l+V/ewOHiXzZP7uU8Kb/yHclRhEvKLQuYfr0Xs0WHZLUL4NkJxnAz7xwLJGHsrf1GRHLF/aL8PetnFlxae+ptle+O0Fm7T165v/w+IclHT3YXxHQ7rZaBI3Tw9FRWQ0efKiB6IcFTCjlZ8E1zoVcTz4ccRTDct3L727oUpPd5Hx7ckK8Zr5K59G94zM4XJJY/MtEGq0xk6f1HXTUqK0lYDekH0KvxFV4AdN6vZ7CAyJZmsJqvfwvJhAdQ3C4d/Tw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6249.namprd12.prod.outlook.com (2603:10b6:930:23::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.13; Tue, 9 Jun 2026 14:07:23 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 14:07:23 +0000
From: Zi Yan <ziy@nvidia.com>
To: xu.xin16@zte.com.cn
Cc: npache@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 usamaarif642@gmail.com, yuzhao@google.com, aarcange@redhat.com,
 akpm@linux-foundation.org, david@kernel.org, chengming.zhou@linux.dev,
 ljs@kernel.org, baolin.wang@linux.alibaba.com, liam@infradead.org,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com
Subject: Re: [PATCH mm-unstable v1 2/3] mm/migrate.c: Prevent folio splitting
 from interacting with KSM
Date: Tue, 09 Jun 2026 10:07:20 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <18102ABA-0D8E-4DA0-AC30-544E34E445D5@nvidia.com>
In-Reply-To: <202606092147587040QWUtifMcXLhNfANT7GRO@zte.com.cn>
References: <202606092147587040QWUtifMcXLhNfANT7GRO@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0224.namprd03.prod.outlook.com
 (2603:10b6:610:e7::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6249:EE_
X-MS-Office365-Filtering-Correlation-Id: dafdab88-0ac0-44fa-a508-08dec6306da5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|6133799003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	dCA3fy8aP1D8xyF2bsJPzYX/gEtzWDxbicbZH7H72AtmZDsb73tjsGoQOYUMOuHlTbzwv61uhlam486AMO+0W8nR5ZR/xuCFo/qExCZ+8PlzBBlzDB/bCuQnRDuCNMSg4/sfa0NURS/oEMQyFeGCgVuwR8C7+QGSzNovKSHKvx4wowonMqewnS6RtrCKPknDjYqWgJhICHVVnOcfXikTkttRJfvOPOp4mRLU7F6SoknTG8iPgwDvhhBK7DFXI6CdbBzwGApm6/IFO0AO6s9Q/kqicYH4hXXZuu2BK8i/QEHgX5BRTbzLZvQGlINX9cGNdwPBw4Dl1MMX3bybSTe9TM8bEKbzoIUcVEVOa4fLzcCB9QP5BDxcUmjBjmUc8Ki4KFJT53xw8SAGkTdhiB6ZItUUtnT6gD9/WEBO9n2UdJBAUK+kdqNcAQiMz67aMUUwjONfGaeNC8JgSzTK1xVQsOGTc3dr1OkU8bP9Ob67jMH7VpXPMZ5RBppSI77CXUZaxKKs3k8Q/9UB1B4qKmzfciCjNOB2zEG/MNQIXNdhxZdXr9N8gsqsg8R4apy7wA9TrPKv1ep2Klzxhw+TpokPE/q3sYeHEMhR46dUPorCCTk7oLPoRgnB2rWE4qxqsFUhcR21bWnO/zHSqpWhRraYtqaxV+k/wtFeUmp5JDcJ5VCe6sLSTrxz5EPoyyLYJP61
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VU4wVlRWOFB2YWxBRXpaUk1tUjNvU2ZJOEhNUjlQOWxYRUIwdmp1U1BBaUpx?=
 =?utf-8?B?UHFBa1hsc0trazh2WkxudUVKMjN0TVI5d1dIdFBORE4yNTlVREtyeEpKWWtU?=
 =?utf-8?B?c0lvdFBDRTF6OTFiS25XSWJQU1NpcGU2VVNJT3JSSFRDVnhvQ3Vyd01NajNa?=
 =?utf-8?B?N1lpUHluOWNQTFRLK2lkcm9KaXlUQWpwTFpRc2t4V3lrVlRVUjBVUktHRFh3?=
 =?utf-8?B?ZHV0ODFMWklHbDNGenBDcXRWblE5ODllbHNQc1poNlFpTkdlaHUwS0ZYdW5v?=
 =?utf-8?B?OEpRNjFTemZzbWJ1R1JCWStCZkFhUGkvckNRa3VNeTRCTVNiQVlTZmE2ZmJU?=
 =?utf-8?B?anRGK2ozT2UvaTlPSXc2WW55MDd1QUx0Q2NCd1ZTVGFXT2QyRmQzWHZWcUlv?=
 =?utf-8?B?MUticXBUSm83bFNQdEE0NVJCMHM1WUJaNUxvUWlUTEpuMCtSOU8vS0ljeFJl?=
 =?utf-8?B?ZEtlRGphMU9FNUZ3QlpPOEMwSnNuS3dOUXYyRTVGbEN4R00vRDJUSnk1S0dT?=
 =?utf-8?B?WlNSNkpZK2Q3T3JKNDU5Q1g5RnV4N2RlVk8yVmFWc1lZbktsa3BpTCtMTHQw?=
 =?utf-8?B?MTZaYS9rTi9OQVpKTTRBOEdlbE9IV2p2UFlRazljNmZsREJxRVl1MlZZTE5T?=
 =?utf-8?B?YUI1d1VtbWNXRG4xM0FabWtWMUJBekFLempaRlltZDJyWk5WVEZRZWJUYmpp?=
 =?utf-8?B?ZS9WRk1mY3M4emV6YUNVYVhFNVVnNDJRZnk0OEJ4NGZPM29zZDl1WCtsV1A5?=
 =?utf-8?B?RWJvc1FMeDlWVC9zT2JWNndhUUQvMDdSRXFlNTJUSmJ5ck9uNy9DM1RwWkxG?=
 =?utf-8?B?SXN4bEtkMWF0KzRhMmtxM21OdEp4M2JicWpCNldUazZwelNNUitVSC82LzBo?=
 =?utf-8?B?VTVCcDFuVkR1Z3VVVWx6UWhVb3BGUVVESmQydnNJK1dhUi9WV0wzU3dlNXIw?=
 =?utf-8?B?bERGTlVzd0tpWW4vWERlSTNqQjdrYkd5R3NhM3dvTmhJdFFkb1VjdmNSSkt4?=
 =?utf-8?B?Um1rbzUzVkJOWmpvMDhQNVJTeVZmSWhsNFhwSC9xenNGTGEvcy9wZnJEc0dT?=
 =?utf-8?B?L1JwMERmWlRhSm1mVTd0VWd0VFZLSFJmUmFXSVBIYkdhVVBVVnQ4bHlTczhu?=
 =?utf-8?B?RWVnenE1dG1tNm53UFM5cmxuSTdHT0s0M1VCUzJ5NGVxOFRNTE5JR1IyeG9r?=
 =?utf-8?B?NFJ5Q1JlWGgxQ3dSWS9FQ0FyUC9YUVFtS1o5SXc1b0ZYQ0xYSUJ2RDFyd0tn?=
 =?utf-8?B?NE9iS2hhUklNc1E2ZWVQTlRpU3BoSzBBQ1hsWEx4ejh1amh1WktpOTB4YWlG?=
 =?utf-8?B?bUNkUFNCL3V1Q3Bpbnd6VkZGWDZYMXJXUFlOVTE1TklsTHNreVNPai9zSmN5?=
 =?utf-8?B?S3Z5Y0kyR3A2VXE1UGN4SENuVnNITWI1VUxIR2JWMTBrOHhVS2FxUFlNS1Fo?=
 =?utf-8?B?bjl1ZE9zYVVWeEZFR1VET2dvL3FCVE55a0d5Vmw3TGxJeTZoeldRbjkxN0FH?=
 =?utf-8?B?NVBqNUtsN1E0YXFlN09PL2ZCdkgyNytsMzJZRW1XMHVGTGcxbmE2dFVXckFM?=
 =?utf-8?B?dFNLcTlLc09JeTZzaW5DWGtNelpCcnFIOUJkZWdFZ2I2RWpQUExsaHVObzRy?=
 =?utf-8?B?Vjkzb0N6ZmhLWlV1NVYwUytNWEVYdkdCMUhUMjRkcG41NDJ0R1ZIdVNTR1d6?=
 =?utf-8?B?eXBuWGpJV2R1a2NDR05iQWQzRTd1N3g5NDlHMFVnOVFIWVR4a1RjRnUvV0RZ?=
 =?utf-8?B?dHRDcXM2V0dBMXI5SytEL2VlTEdLL1phbkpIdjlYWmRoL0lEQXlFaC9SOGVk?=
 =?utf-8?B?TFdmQzFkSDR6Njh2V1BJRlM2YWhUSzg3SWxMNHFLTkNEVlJ0cWRVUE1TVCtT?=
 =?utf-8?B?dVE5cGtxT0hqbk8yUDR3OGxHelNZTmJHdUpBc0M3bVZxcm5zTG9iK0p2MXZJ?=
 =?utf-8?B?OXMyWU90QjV1eXhQdW0veTArMnVxVmJzQm82Q1ZvbFFHUFBtN3VBZm5lS3Fs?=
 =?utf-8?B?dmFPSUFFYVdRK3c5SEZhZmU4dm5CRkFPcWNuSU1UZG8yS1NyUUpoVkZQZUw5?=
 =?utf-8?B?TC9KSmdDUHA1T3FrQUxXTFNKbjNjb2Q4cHFndzBYbWNBeUM4aFlvQVB6czQx?=
 =?utf-8?B?RDJCVUdTOS8vM1dUVENveCtzRlVEQ21vRGRCcTcrb1lNc2x3cFJMVG9HUFdm?=
 =?utf-8?B?VXVjSXhWRnFoU2NEcU1GNzBLWVRLZVdkVzFpbEp1OHhHMER4NXE4M0dZSjRu?=
 =?utf-8?B?ekZITGM0NUliQlJOVlBWNGdUdHFjcjNVTTZGRkNuTnphNE94M0IvazFNcGlN?=
 =?utf-8?B?SmxLa210VnFuek1vY3lVeUpLdlBsdkp2SmR1OVNXNXRKMHM2VTJtQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dafdab88-0ac0-44fa-a508-08dec6306da5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 14:07:23.5379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sRU/SC/CP3Pysr8h7/8mSiRKkdBB5mcgDKb+f6IrgEpao9WBkq1Q0xJFUfYcrE7L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6249
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D0984A001B
X-Stat-Signature: tqzdz8hd37n1d6saxfedd5exjd81kkij
X-Rspam-User: 
X-HE-Tag: 1781014048-637220
X-HE-Meta: U2FsdGVkX18SadijYNjz+YzZ63rU5KhKa3vXsMqhzpcDcVEj950OwnF1GK2jZoT2oZ6XoL/Wik9yYM+0cv6BcVGVfy63wLZPvHUT7T3auA8F3/E4835xyI6LRR3oblG085nG72/DkTGTLa5rzUIjwZaNaBIeHeelQfP4nGtv9A2CwgqmRXmFLeRTo2qVDc5ASn/xqwShwe7xwsqvb7d5pxZjL5M3hqUkR97NJZ0g/3/sTO7FDsF7JJ/Z4L6nolRdIaJHHVi9AFoGOkH0jZ5FCO8V2uGGibyoB/9XGNZNXo3j3zFNmfjKflXC78P7RWIho/crPWyPUkuRPImMBTQL9BPGWpUZWCK8bE7v0y/3sGwbEwjMxWUXOP2HBGhRfjt5BofXZQp7ZdmUADxkap72VO6N6vljvQezMqjc5y0lObqBLIh6jMU/DaMK0SQCPV0M6Z2tsdQqFQCg6OvjIXsFKAvWvLqCmnywG/iidcDshObTujfHdpaD5oZnSUMAYvdOd9RxcIdFkW3TiIvViSCLD7Ze58J5zhT5Hresza5eu8uewEBizBS+By3/GjhKcezb26Ot3Ykmc6qaAW884hdZ9J2jwJPDvNos69OLGpPiL3ckgbV4XP8sitM79DWlbKVFoVWnFkensN5KHzQI1VOEENbnr4oy7FjbpnvbAv4BPY8PCNlgPpRjfHpIzrPTDgAEvxueAA44RA94MHjGiasXiYZ0IWx0pEIGKNzZD3KuRzg7TRbtPaCZsYR2nwgmMIXHBVhhVMHK2Lum7NzQOwaMDxdnMpYTWp8MkME0aX3jgeVSLtwoX5igCPVqPwEGHcttPcTMFA5zGrSqDo8M3v3IybdVAZB8G+RW/ACfJxr0Vb3E/ehRgShKRzTtT+O+w+4b7gQdYMoOWAKJNIg8WUW+Y3RNFE6ZtqOmFTDYKguJuSmbvfpGmOOwZuIloaN9kSFUkLtWT4iCBtqqhC7U9Vb
 OsgXfAF7
 g53n7Otc+hPvK3y8Pf5bqqZPX58OEr2hTHEwXtuipwBlj09ChDFs7tZAmyE/uW8k7ZwtRKtY1HntbqyHZo335C+mg+dt+zn+PiobDb8a5hlgHa2IKrqeFsHvHkQV+moAB9+tsmDsUjsSmMbqpfpv7mBohtwYuVk4w8blaTGWJlm8bFG7bvk8oq5hWRAWCCQDi+FX2pLd1W0ZkQUlWoKBuS5WLVX7pPm5tipIhszzeylYmD3djycCRy3H7OrryBuxGWKfMFT+Bk2pntMLLKdRVhhFI/Bs5tFTnmdlSqkG1A7CiQfxSd3nY/G4xkMFT5WkbkiTYpi+kUi9TPr5nF4mR3v9zGyk8xBBd3YEwhYNESqKfcgkymowLDkfUJkMEIYmdwhUvitWkADcWxDgfFY/6hyPBXhMfHpKC5tl0JtKRZuUsGgV8MkbVVw50XxbEGLTsSfpiDr6YDKjTW+YpvZo+Mf2h2jTG8sXEFWeBAyPqy7AbQh/1rjceEcSyML2J/3NyryPKxZqmlc6DoQxx5LcXdDjvgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Jun 2026, at 9:47, xu.xin16@zte.com.cn wrote:

>>>> Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
>>>> when splitting isolated thp"), splitting an anonymous THP remaps all
>>>> zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
>>>> This flag is set unconditionally for every anonymous folio split,
>>>> including splits triggered by KSM.
>>>>
>>>> When KSM is enabled with THP=always, this causes two regressions:
>>>>
>>>> 1. use_zero_pages=1: KSM calls try_to_merge_one_page() which triggers
>>>>   split_huge_page(). The split remaps all 512 zero-filled subpages to
>>>>   the shared zeropage at once, freeing the entire 2MB THP when KSM only
>>>>   intended to process a single 4KB page. This bypasses KSM's
>>>>   pages_to_scan rate limiting, causing ~1GB to be freed almost
>>>>   instantly.
>>>>
>>>
>>> Why do you see it as regressions?
>>
>> Since the zero-page remapping was introduced our test has shown the
>> following behavior changes:
>>
>> With use_zero_pages=0, the merge rate drops from 60MB/s to ~6 MB/s
>> even after raising pages_to_scan. The KSM merging is now much slower
>> and CPU utilization has increased.
>>
>> With use_zero_pages=1, ~1 GB is freed almost instantly, and it no
>> longer respects the pages_to_scan behavior.
>>
>> Even with just this patch (1 & 2) or the RFC linked in the cover
>> letter, the issue no longer occurs.
>
> Understood. You're saying that the additional processing action in split_huge_page
> (remap unused subpages to shared zeropage) increases the scanning cost of ksmd.
>
> However, I still wouldn't simply classify this as a performance regression,
> because commit b1f202060afe increases memory savings through this action — so
> it saves memory at the cost of additional CPU overhead.
>
> If you want to address the increased overhead on ksmd, I think we could add a
> check for the shared zeropage in cmp_and_merge_page, and skip merging when a
> shared zeropage is detected.
>
>>>
>>> AFAIU, KSM and THP do often conflict with each other. THP tries hard to collapse
>>> a huge page (which may contain many zero pages). If KSM is enabled and part of
>>> that huge page is mergeable, it can easily be split by KSM, rendering THP's
>>> efforts futile.
>>>
>>> Therefore, in our actual production environment, we typically avoid making the
>>> same region both KSM mergeable and THP always.
>>
>> THP=always is a global setting used in many production environments,
>> so these features now interact very poorly together.
>>
>
> Actually, I have long thought about submitting a patch: add a new interface
> 'skip_huge_page' under KSM's sysfs, allowing users to choose not to split huge pages.

Just think out loud. Or just skip huge pages all the time unless memory pressure
is present. Basically treat KSM as a way of reducing memory pressure by merging
pages.

Best Regards,
Yan, Zi

