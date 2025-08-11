Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7BCCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 18:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D20E18E0098; Mon, 11 Aug 2025 14:41:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8FD8E0093; Mon, 11 Aug 2025 14:41:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0F138E0098; Mon, 11 Aug 2025 14:41:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AD0228E0093
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:41:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 55B1C135D36
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 18:41:13 +0000 (UTC)
X-FDA: 83765344026.25.89CB3CF
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2045.outbound.protection.outlook.com [40.107.212.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id 98F221C0003
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 18:41:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GGFi6WaF;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.212.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754937670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FcD3at0JKlhE8rgEyDJ+JyXCGfqOay/SidkZpmzecGk=;
	b=6pilO41bGvGTVPtXmQD6k/vCikgPfQUZLhwmRhZyU2Mp3iMI4oX4SDktYVa5idB99EGIwk
	CJQQGFPR58H9TA+nbbAG/Vjh7aROj1osC61ODD0DHt7aJzKzzlTZVKR89GyfgudmycpV/u
	Z6Ts8Ok6SgNzJ1NmamoWcgzT0Iax/7I=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GGFi6WaF;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.212.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754937670; a=rsa-sha256;
	cv=pass;
	b=RGsQlRFDnhHlukqcja4hIGJyOgrxhys3F678b2WxwrMswhMB1U0u355Q6dHghI/3pmOL7O
	WDGscbttTQMzYBRcHLMvqfTDYqzbMvjciqrZlb/uPy8h0eghSl3T9OoG6o/dsH4nmHDfqk
	mUka4N0IWwMt0D4xzI9Gdy+wfJA41Go=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B8POdSkf6WWpVsNsfHrztP65a5vnkvhaB3YDBAPl4iuQ+GSnxcnJ4bBkcTUD41on3B9RYRQ4AXnfx/UCnEg11VzV9Tl/gbX1QosUXJuva5vvQfAe/s8LPCGFgsCiheG9x3EiQAcMUre1QTRlV3YHJscJNBfLqvM8yu7CKp1/XITagHIalAV2lKwhTHScsyL605P4/b1v21R42ag0Hc9vOpyPxxJkJVToZFW3ydxIZeDZRCoXg/QAfnPlIrajG5VRXGDQt9R3cH3sjnZcWXZsKyY7wV8RnsVPUUV7UEwEx+qycz1PHdoZbEHcjLDheqC9A9tEIKYAP0P0lpynXQIMhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FcD3at0JKlhE8rgEyDJ+JyXCGfqOay/SidkZpmzecGk=;
 b=argyJmiPp10qjA3sGNiherE1U+eZKj0m9YVjbY83ATkx8zsZ3dvMg850giUCwQ/vG4P6HaYUFeNqwXU2SoSVTF/03YlMPcyCSanmA+IwFFOSbPB0OYW+/DiaEAX+3HmqhQ/EdQLslW5/WN6tOoW7BHKAcm/7ffmiXCYtHCPYpNQpXafQN7mhr+rFnLhdfKFwEedxM4To/luINQKg9ojLKoGou3yV/sb803HoUAAzQ93qtCcvclO/pEmSD1SAPBeeUy688goCyfmyqVYPL4tHbhoonG7LpYy5OqX/jrOsxKf29u6TV1RsHqeagxXH+51Q6fI6GTMWUnPY8cjj5l6eGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FcD3at0JKlhE8rgEyDJ+JyXCGfqOay/SidkZpmzecGk=;
 b=GGFi6WaFdnTwFSdZ1G1fIgZ3QxQiiU9NeukJdinwVWg7LmV5cdM7+um9n3g15SLb+NTPOPStfsiFZTUDVLk6RYLfwgK+G1h2FHLpErjsEUjFrap7+5zcWzu7zrwlp+Vre4Zw/38baUxJZj8SyPPHCCap3HZcopcpuAmrobVLfWvTsxcj0F8SvpasBbXB1O9yeQUXN3GH3CJ9kUjjnlk1V+WtAsaA+Aln/X3/NmThmMVG0mcnGRBqMAoMHv7odNNn0fGeWYG9k5N++yYDzI9PfiaJdHV9oUajV/ooDShv0yG7paexzsrg4VkbFzfYgekxZaV4DtD13hQxmLucdZOsOA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB7759.namprd12.prod.outlook.com (2603:10b6:208:420::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Mon, 11 Aug
 2025 18:41:07 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.017; Mon, 11 Aug 2025
 18:41:07 +0000
From: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, wang lian <lianux.mm@gmail.com>,
 David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 2/3] selftests/mm: add check_folio_orders() helper.
Date: Mon, 11 Aug 2025 14:41:04 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <4A5AF314-A688-4E7C-B5F3-19E6D8093DD7@nvidia.com>
In-Reply-To: <f0711fe8-88e9-4634-98ee-1e37453a7e53@linux.alibaba.com>
References: <20250808190144.797076-1-ziy@nvidia.com>
 <20250808190144.797076-3-ziy@nvidia.com>
 <f0711fe8-88e9-4634-98ee-1e37453a7e53@linux.alibaba.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0261.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB7759:EE_
X-MS-Office365-Filtering-Correlation-Id: 01012372-ee65-4b58-4432-08ddd906a23e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MT6HvMXTMCul3yacpW3FB0K7Tppcjwb4HDJTrh3xBECUi+F2ttsdHlHjKFez?=
 =?us-ascii?Q?aapOMc8lq/a0SUAhlSHIxmoVs9vR5ADt3g43JNszFdiAJN4hraB4HZpkhh2Q?=
 =?us-ascii?Q?jqzP043QblwCCasCnoO5/iz3sqxiuhTIIelQfAU2Bcq0hacQORIUeBaITB5a?=
 =?us-ascii?Q?ItZLjpuPAId6cgd9kGiLFIQ1HUAaeKLp9Re1FjLIr2ytr9/3nb2LEvG4VCNT?=
 =?us-ascii?Q?RalKE4oSomUAL2hg8lWLwvMEG3fh3N780KKZryvpywP7fW7cbR8hptk3jVXs?=
 =?us-ascii?Q?4i4svAwGNztM2/P+onqwkBe4eqUn3YV8olQJw6zqprInyLP8jfI6fh83u4gQ?=
 =?us-ascii?Q?fmo7MBEYeJg3kEkPKo3GRLI16pL5rbqT6mSDaTCYFOcQPf2BIIXSGz6/X0pz?=
 =?us-ascii?Q?r6NU1ZkfKWJfh4xV5XEWBHndqynb1+oiEcfZEkN1hsZZXYT3kbgD+/JZSj90?=
 =?us-ascii?Q?rkuFAKRxT8DPWYmNqmplz3VdsSbphqkzgMLLci0XMo5n/NTJ8IrLl3m+oKbx?=
 =?us-ascii?Q?uDaeQmjWU3Lf7CnFJ8JFnWX7j6o/1JvDsWP0MjVoFnV0JnvQcuZBF/BgAGAs?=
 =?us-ascii?Q?IRwMy7LkFVbLwBxpvgGejQUsWA/mgIRDsDMHgQnUymUhhqrrYPRlMQzCNw3r?=
 =?us-ascii?Q?DrfWfO+6c9Zf3s0T6trL+/DV3EHIqJLm4YzyugY1C3je8wjMv89b5wmFNPwa?=
 =?us-ascii?Q?czO/vClYxgEkEQOZMNANvWCtryJ8uTTrzQOVR+1OebADRbLzBvIjWKxu4iua?=
 =?us-ascii?Q?QZWQ/QASvwv7ZzOJTmDpnzibaEQ+dz4mpc13E2VAMjnkvLTvyL2ks9SKxRyY?=
 =?us-ascii?Q?x5/Fanhd2Yl+6eFKjK+iHLi0WqdsksUUg94py/4j/8wI9bma4hRusbmsRI/V?=
 =?us-ascii?Q?AEfhOdFpbtKIwGrhm7uM8Y1NcrkmfeT4f6T6r0t4BRyQLg8xAGh1G2x+2w/g?=
 =?us-ascii?Q?BrbQfesBPAyA7jIGifylDxCI82Kz+9VBeupbHHJdDvr194twy+MfGpeExtHv?=
 =?us-ascii?Q?Z+Db+nryjbHR5RICFijPtzIAJW50bNPJ3lSXfq7B+7qChmPIIIbAnp3xPrRX?=
 =?us-ascii?Q?xNfayLeEUmDl06iD/ieaZOS5kaf1QtUYRMhJvF7oASLsDMenRh5WSOwDCQ/D?=
 =?us-ascii?Q?LvSXOqWZAIcSkfk2j7JSeId5WNGX+vvEzOaFPhXT/h2oqWWJUTjY7bUFXtg8?=
 =?us-ascii?Q?dqZ7LsllTPiAVXofKBsdrcZQ4qtec+kRaYZ4TeG8lUcYGMSPIKN+Kv+Ys7D9?=
 =?us-ascii?Q?lIj4VYMzjOSu3cWfB+nMWHboA2revp6egQsQYQWYMEUFXext9jMslN8fT1bK?=
 =?us-ascii?Q?JyzJSipG2cKkSFWbf/7SCSKPuEZejFVYuGPuzb0OkFrY6HOlHzuNGY/1eMiU?=
 =?us-ascii?Q?c5MXIV7R5a2VLz4rfRYmq+I6FAGpBxC01nP32kPVtktTGh+VldYsiRCt0sFE?=
 =?us-ascii?Q?NQ+hmglEWbo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5zfg/2o70ybccjv1CuCp8bGocJWHpTK2Uf+alJMFGyqZMWHV7j4zIZ+T67Xg?=
 =?us-ascii?Q?r/PNVNaE64XQTLCybPhnzhtfGEGtolK9BqF+JBnT7tFjEZMOExH9ZNfjo2S+?=
 =?us-ascii?Q?WH2JATlFy+PxHMhFAAWIgBflTh/3gHTdQvcZC6Q1PrPyznt2OsJrmw/H5yIF?=
 =?us-ascii?Q?+KZQ9QBlOFpnbr/rNhQ3wJxhBm/S5W0eRqHZA++Vv5cKdFkxRRO3CQek6ibJ?=
 =?us-ascii?Q?9S06jEyRAOheQCnDZV1K1MZI+nR/Lj/QfVjW92zUVk71VDJ436/xH3v0GGcv?=
 =?us-ascii?Q?0+TvTJHD7NGq39jfIFL8q5rCzlJx/fgU/AxHh5ER4+ViAbfBg3u9qpkkyuQc?=
 =?us-ascii?Q?Y8l7VwvDNzzPMo/GR8MG/QOZ+0Xi0eKvHmi09Zle1nnTNT3XAByOyldTM2fF?=
 =?us-ascii?Q?DF84o80oRjoXQ6+yn0q9cD5fg18i6EfIv/4+wgaVz+WFrZyOuPzrKAsIWi4j?=
 =?us-ascii?Q?BiDZ1pFfXOKBlXZm+0XAf/URk+ESWbviybiqaKl5r+3QzkmeS60ALrNJZepU?=
 =?us-ascii?Q?hEGqAM6U9ChDLVj0iH/udrKDIBpNaUXiRqKHx6Gcp8I691FDksYvjp+Uw70D?=
 =?us-ascii?Q?Ik6ogxdEadmVPRh6nxMVxF/0IwjKKOIMHmSf0OoWeLq8FEbYgUucTZk2Z1Jv?=
 =?us-ascii?Q?P4+9JdKfgpuMTmJFWQTNwP4iIWbw6sD+j5LOTF9rMD3bcNGxt1A+RVuUh7/y?=
 =?us-ascii?Q?1DuUvDsnJ8UAgjF3+za5HGNKH5bHQE1CduuK9a3ZPLetZoyNHohi4fhZ5UQP?=
 =?us-ascii?Q?UwSH+Tm4yVzVDxGh8DcEuWSVgdaova5/k7sr7nEZiOy3jsrzhqvdhKUloE9B?=
 =?us-ascii?Q?xxwJTo+oQeIa9pWWbftafqSQaEvD0ghY/sHW8zMlbD/njHQOdaU+3FDAd2Ht?=
 =?us-ascii?Q?G6vFny79krqscAFBjQLtloc7pND6ZHb/M0Ft9RhHDqc9DcZVaPmpj4TQo60C?=
 =?us-ascii?Q?QwKBiQgORBVl2oeSheHx1Ro+Ai6MJpReSLU5Gdqj5C3hzhQD8DfnPuCf8cn3?=
 =?us-ascii?Q?u5GRKFHRVWqIO5+8KUfede+ty+frc14f3QUHgTfiawdb1OmsAghIwAHAHbrP?=
 =?us-ascii?Q?Be2K6iobiNQTFBv189j17lBuYXoZnku5a5LnXZ4Ii8KV7l9K7aipBX7ANBk/?=
 =?us-ascii?Q?XSexpJMTdyuNKrlbwEeSmIHIEQVzMcZXr1mtdpb2qmGVwi2966gwRII+BkRR?=
 =?us-ascii?Q?OKZ0prUzwPoQYvkaI/LeDwG6nCLVqfCdfwmDFzJ9Y11xq4l58bF1/wJ51O+K?=
 =?us-ascii?Q?JxaOZpxOrDEKtOTFkEafl9DbCiJnh9hE0EjKqG6ECIhuiHGtAE9qMR+h2ULQ?=
 =?us-ascii?Q?bpvHfwT9b1tZkhxwsNMkFsBvWQMmiErC2vl06Ogu76DkcOPNM8mNGNd3LglJ?=
 =?us-ascii?Q?Pcg41TWogxrtOi9jJ4K6dRbUulhmxwYvcSUGDfkUYUBfjiZoKq9lVRp4Y6w7?=
 =?us-ascii?Q?1IOr4WRK4vaQyP7purZx0CYV/gFsFBnGadLxqoPkOuzKpbjPtmxR15oUfYJY?=
 =?us-ascii?Q?L+Q9fgSWcVTfJV5w3XTjSfCiT1LyL0AIk8kVm7uwgucWKD2k0J9CY+Y5uG//?=
 =?us-ascii?Q?MCxE0cjTv0kGGUqCVO5BHXHBM9Mc4J794GEdIo2W?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01012372-ee65-4b58-4432-08ddd906a23e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 18:41:07.2416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WpYcTG1v/xaLHVMGGQAnbYgCzAVA77qoVYlHoZcpH+dT2zF3M/mqDNmRw4JBq9ER
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7759
X-Rspamd-Queue-Id: 98F221C0003
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 6dm78dxx3sxnb7777zzjpkxq7msnt1rt
X-HE-Tag: 1754937670-34033
X-HE-Meta: U2FsdGVkX1+Vtz+5p407e9ek2huhnDBsRqmErQ0nYFLbyBX9aWxI4TkbDVP8hxFWKTNDW3qwK9Av4kUi2S/N8VS3f/fM/aRPouekuXRNRM4pkr63cScBdYoRrqPUdKEfVLIPt4sLyYq5sQaiN4zMc7lUw6s9H+K1oDDZILwacwIg6M0FNbDTuYuVzc3vSE2obqRZFROqLIm8SOLXZ2+Krs7F5pb85Yq0ERIDQjFQ4I0cPxLJNujs+30iR8rHI6OxxS/ckVfHWWpVXpSxM52xxMELcx5csELOC7lboVlQeJ+IRMu1cLlmII6op8b2rKrCl1xqON49Br1xEjH+G5k6y/ERUgcmpDGYVCmzSmr0LVHMjLbI/yVdIPX2gRyDEZVJOgcCVDfZkQG9xq+zSmosIalGHpyKPy7dwZLiAyC3iQNEgxR+WyhyLsJqgu8fGewF9ouU4PvDehZ9vd35EmPCj4e/i/G1UG+VPeGsbhcDi3K7wPxvpGuKHNIP1ZnscHhqEW+eMvHI4620Nl7KzigLWC4UX3uTmbPMa7d27maLu825z/a52Ner/z03R5EfaQHP8y+E+iPxNZKv2lHa5i0X0KFLzkwqBsfTx339fJaKH/0F0BGMImJ63mbjXXsng8frgDQKOmmFhlnAFqRXZVqz6s03QIDjp2p/HKlp2+hKxh8fDyy7xYPWJmuSlhKkBC1M91CyQTaiUqpg8xBczSWY5S17SGG9ziqoJkGoCMCwfL1kyMYlImib3O/uAco0rFdzxI/A2Xz1PUNIyH2VcCf/ujbKsCKw0dxE06mqeaQ3dK+YA0KcpK3rf0z51/PnLebH2icQLXaNWrnLmynbv97kZDPtP0GLFGQUDCVnEii1I35ALtHuUSmP/20exezACtep82912GGHNer5jluXrEGYtr3p9K9nAYPhmqrxRtTBbPFzeqrhwAXNGlXaMyIPoRTmEjvRoxj7oaw/oH6w24j
 Q6hVFty1
 0CZPfER+Kyu+toZX6BhTTfbiHYMP4xzjzWYIt3d5cAtTN76jgeuBSRx6FbNI/GsdLMVkCKvFFtX43snxckau6BGarN/xrlcb9BjNYKlFqDiEFcngesPShedRinC3WrygjrhCxwKGK1vFt6jGoxYTPRmjir+aTvV/ivc5BoxhGtMRq0OVicRg3yojMEO/EcqpJAdVdT+AF73pgLDjItVeM4xQxNZueJjKTERMnUJiVVnQl0Ty7m3T2altCckQE8F1vBCgm3hyQ60+RBheTFWOsXD13TfvbRHMmdRjFtRsXq3dtgXT7aHCuk/c1mGko7lrnXD3MMP5leA115gTOzP3IFUmoVoRN0J7UlULRPkClA+1HwfFVhDkHgJ86DxyJbH98WY2WRBcNEqr1XYCngFPmMJ9RKzMBg1IyyZrjH5l1M7nJ2JUu3s1e37PPWMaYTrTlaui3ivgswgMCqpArVNxDc02xVlk6QwiLEOmN27W1A3zGjTtBTR0h6YkklYpDpbt//7UWL368U0Ol6gSJr2/YPANI+TcazeuQBi8Zmy5kV1r1k0JAvHlCLni3tg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Aug 2025, at 3:52, Baolin Wang wrote:

> On 2025/8/9 03:01, Zi Yan wrote:
>> The helper gathers an folio order statistics of folios within a virtual
>> address range and checks it against a given order list. It aims to provide
>> a more precise folio order check instead of just checking the existence of
>> PMD folios.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>   .../selftests/mm/split_huge_page_test.c       |   4 +-
>>   tools/testing/selftests/mm/vm_util.c          | 133 ++++++++++++++++++
>>   tools/testing/selftests/mm/vm_util.h          |   7 +
>>   3 files changed, 141 insertions(+), 3 deletions(-)
>>
>
> [snip]
>
>> +
>> +int check_folio_orders(char *vaddr_start, size_t len, int pagemap_file,
>> +			int kpageflags_file, int orders[], int nr_orders)
>> +{
>> +	int *vaddr_orders;
>> +	int status;
>> +	int i;
>> +
>> +	vaddr_orders = (int *)malloc(sizeof(int) * nr_orders);
>> +
>> +	if (!vaddr_orders)
>> +		ksft_exit_fail_msg("Cannot allocate memory for vaddr_orders");
>> +
>> +	memset(vaddr_orders, 0, sizeof(int) * nr_orders);
>> +	status = gather_folio_orders(vaddr_start, len, pagemap_file,
>> +				     kpageflags_file, vaddr_orders, nr_orders);
>> +	if (status)
>
> Missed calling free(vaddr_orders) before returning.
>
>> +		return status;
>> +
>> +	status = 0;
>> +	for (i = 0; i < nr_orders; i++)
>> +		if (vaddr_orders[i] != orders[i]) {
>> +			ksft_print_msg("order %d: expected: %d got %d\n", i,
>> +				       orders[i], vaddr_orders[i]);
>> +			status = -1;
>> +		}
>> +
>
> Ditto.
>
>> +	return status;
>> +}
>> +

Will add free() in the above two locations. Thank you for spotting them.

Best Regards,
Yan, Zi

