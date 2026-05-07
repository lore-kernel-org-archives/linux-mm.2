Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 829B8CD3442
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 18:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9E196B0088; Thu,  7 May 2026 14:59:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C50E46B008A; Thu,  7 May 2026 14:59:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16356B008C; Thu,  7 May 2026 14:59:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9F86B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 14:59:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 30D01C2162
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:59:47 +0000 (UTC)
X-FDA: 84741538014.09.1528ABB
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010070.outbound.protection.outlook.com [40.93.198.70])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4C6A34000F
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:59:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=djDF5wzF;
	spf=pass (imf27.hostedemail.com: domain of joelagnelf@nvidia.com designates 40.93.198.70 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778180384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JhOcJMuOPIRvcF8OSeGhh/YoFBpY6QNdDaC4Mq+b/XY=;
	b=iC23VL50kjdoEVaRtVundeaC4So9qJB7Un/6+svgnpdYXd0WLwTtq+/nOMwzn5eKG1/nhp
	BpCjjchrOs0CBGF7ikeG6+0yrRNNsw0IV/fgHfB/IF+GeCiFoULHfbypgb8J6SW0WwHhqI
	i00bTNJIpxitgPCXATExbLqQOb5hQpw=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=djDF5wzF;
	spf=pass (imf27.hostedemail.com: domain of joelagnelf@nvidia.com designates 40.93.198.70 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778180384; a=rsa-sha256;
	cv=pass;
	b=dSRcDEXCddiwiZMiGZ4TCWHs8ToYsnafpn96bL7RY6xl92L35VnCbg+n08Ke24X2l/SyBb
	yPDjAAjFNk1e6ZoO9GHidrihALEEQtjYTDm+UfoG+sx/+WvVcoHoEkxvcTBvB2IR8au/+m
	NSODiHtIlxBGuarvvGEWrxN1D23vtDw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZnGlSRIx/uN+DCBfojf0olYShr90RHlreYZW4L7nbTesQPdHZYF+RGOT2SbeGzgbI8klsXIyW0gFzsOmz1jpbd+dKTCxwadd0XbYYtHMNBDcj5nZAClnzkBgf0fLXq/ZlwYZiE4cJ9m27Cs54wBqy/DiDWfV8l/oDBu0sKsTqtGFEThnYYKB9UvkpUZquuLbAU3lGrIs8ruGZqNbqKvbP5KUXHccE+zq2ptWyXz2zHjuxPPptftcfgt5Pqxaeogyo+LXH+pDsM1uOdKwzjTEgmGb6qPiyrHJnJZ04/8nnrbCKLBTgbpMfj/4bAjCpbaveWzczDn7imAxW3P6Sny70Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JhOcJMuOPIRvcF8OSeGhh/YoFBpY6QNdDaC4Mq+b/XY=;
 b=rlwI4SF63iqM93Q74/td7uEZu3SXD5fOF0J8SA4JjWyKTFtueuBbYWcFr+9rH5qy0zV1ufIt7DakMMz9x6Wh6gskNF2XN/3KKyZ5ymMNkEtbfQ/q2ftLr2zAVYFZ2lmEDipMFLC3QD5Lyi87YnEeas2GGqPy0tuBcqGnwPbiXYOwwWVhcLQT06sXE6Eeyu/Vxp1EYbuCZOyaLb09gsb/LVlrV+HEAw3ldr5eWnZ6BvtZSQqJKglHq9CMjD36qS/EIE3WlP0FRwPGCT5zmPtLv63/LUG+Cr5MGdSyfo2f0ytTcm4ra8XfK0w2E1pKrIR5zC4aeFymxJrSAwe4cxO7Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JhOcJMuOPIRvcF8OSeGhh/YoFBpY6QNdDaC4Mq+b/XY=;
 b=djDF5wzFEmAs+yizKIT0dnn9RnlXIhETziPJckuj5v4Pso/5VMK8hJaNXw3EFRokSBRjRlUqNkEaxNqG3xLC0Ywt2iyf5gfo7jwdIAokJCWvFggWU9myd8t+IuA4nro9hkzAKK3kD6pn+5+p32CcadS1sIUXM2+/kF5eLrT+lGyz9td9cpHFdA1QOgUXdZZV2D3KAQasFx59EIZmgNaJmpxtPVL2qmKcodM1jHpu9JDu5o3OIoJBI2zL0b4Gw88VFEvLenr04xnRAYGSbzw+GlouYIM2RTwdARPiAxI7bf4BShyvok4a4pM9mJlG0bbAe6IoDwMd3xQO0Irf0aclEQ==
Received: from DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) by
 DS0PR12MB7994.namprd12.prod.outlook.com (2603:10b6:8:149::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.15; Thu, 7 May 2026 18:59:37 +0000
Received: from DS0PR12MB6486.namprd12.prod.outlook.com
 ([fe80::88a9:f314:c95f:8b33]) by DS0PR12MB6486.namprd12.prod.outlook.com
 ([fe80::88a9:f314:c95f:8b33%6]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 18:59:37 +0000
Message-ID: <fd8b4470-930b-4688-b423-2e349f8c883f@nvidia.com>
Date: Thu, 7 May 2026 14:59:33 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/2] rcu: Add debugfs interface for pending callback
 monitoring
To: Gustavo Luiz Duarte <gustavold@gmail.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Breno Leitao <leitao@debian.org>
Cc: rcu@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260507-rcu-pending-cbs-stats-v1-0-8f4eb3553bc9@gmail.com>
Content-Language: en-US
From: Joel Fernandes <joelagnelf@nvidia.com>
In-Reply-To: <20260507-rcu-pending-cbs-stats-v1-0-8f4eb3553bc9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN9PR03CA0198.namprd03.prod.outlook.com
 (2603:10b6:408:f9::23) To DS0PR12MB6486.namprd12.prod.outlook.com
 (2603:10b6:8:c5::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6486:EE_|DS0PR12MB7994:EE_
X-MS-Office365-Filtering-Correlation-Id: 248dae49-6d58-4969-6021-08deac6ac93a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|10070799003|366016|22082099003|56012099003|18002099003|921020|3023799003;
X-Microsoft-Antispam-Message-Info:
	S52MGkJAIGRDwJwNAaBsNOaWT5zbTcHTWFtaDYQNpgrRqF2oUd3FYqZafKmvGAd5E2DAoq9P4Ph9c/6Wrxmeigrdi+ZpWvjefY0cjzwgMfwM3b6a6OT7+OYxb5AMtmqwQjFa3Mmsuo6Srlq/ZARc5TQubTzaAqubwVBw9QxjaXLd961KBrm+Rxj2xVznHO4mHpzM2IZWhR39ai5EQDtXfC/O8QyP5X//P/4MqofXGgdDnea7+DamPiaYUEbZ+WZ/9fbyYO9XaRPVUC+YvqUp2YZxjqOVUtG0OJOoWM74bDYv5BLx3QRZpFrP1g5M83U6JUKYsBg8nQVFOMWUYrP9HOdWIrVv8Mro6bI0S/reYV54VgtvEEcoTs67U4DyIWcWVQV4X/XOExR0l3ybUL0I3V6N6zfcAsip0t3i+PJlFbduPpuBxByNzdhzS9ubmhdMHpUqHnbJN5XLjacMDg38SrTEk2I6rqDOvrdMaLTcffRx72YL3MXP6zotmpe/UBCRlt8Usifs8TidWkjOYRE9bEE6DKWP/CeZ+W/lc8k2iyHeAHpGwREP2bM1tO8bofctnJfvKYq/YHyS0tzyMBPnHMQjO3BLBaHgN14zg5dVGiQawDtV8XrP0in62lAbLpMc/VTyGtn5KXFEOgWYR+eWXGbt8woNn0H3mwDQ3IhNCPZhZ2EOXHHCCSW/OYnWrYPZRrsarYU4yDOUah01OFTQrbD9IGjexFSHd6JTtPfSulpt2iQDuy3BIxewySwXT/Mk
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6486.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(10070799003)(366016)(22082099003)(56012099003)(18002099003)(921020)(3023799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NkFxU05mTVFEZ2crRnVYQytoUVZzRWtVa2tiMHlXQ3oxVkhPTFIvZ3RhdTJr?=
 =?utf-8?B?REtKaHRlMnBSMGlOZE4wQWIrOHJvSGxGcWpqRm1iWW1rSWV4RXJ2bXdLM1gr?=
 =?utf-8?B?SURnaXlNYnNSZ0JUaEZqRTBNd1dFcVdQZjJaUkxaNGZOZGVtTTNzWWhZVFVu?=
 =?utf-8?B?R20valFlWlI0dFJsNHJXQkZDTXM2aG80T1ovZWNGNGpOY2taMGU5b0dCYTUz?=
 =?utf-8?B?dGowbzZ2Tm51dkV4ZEI4ajRiRUZEYmRicGk2TWpsNVhFek8wTy9uOCsxd3RF?=
 =?utf-8?B?WXd2ckI1UUNIZ1l6MUJweW9SbWxSWWtZSEYwdHBjajlZVjhNMlB5NGZ4KzI0?=
 =?utf-8?B?TVRHSEZPb3NQNVAwcytFTFdJUThablg2Ukd0YlNNUXdVNFVPRmRTaHNabHAw?=
 =?utf-8?B?UlFCK0hkbG1OL3I5dXgzS3NMNCtlaDZlMmdkYmlJcm9xMS9JdTkrd1ZXSFp5?=
 =?utf-8?B?R0F0Sk5aYlNteVZxMzZNR3hOYmFVYzZ3eHU2OXdVdDFhUTVCTzh2SUJPalRZ?=
 =?utf-8?B?ckJZMWpQRFJuUVhQWVhqZUVCZXBYQXc5T3VoTEx6bWt2dS8ralpBNVU2V1hY?=
 =?utf-8?B?TjNicnRxUUZHU3hpN3J5Y1NEZnFEeWFWRTgvbHp2R0UyVDZRUXRQYzhzcFF4?=
 =?utf-8?B?MXFLK2pzMTRjYStNTnZoVzdEWWgrR0h5eDhGeXRra3VqdWtkYzJOY3FKSlRS?=
 =?utf-8?B?eTlWU3VUcHRiMnVMU3RJSDBqK25HQTRINzIzbXc2Zi8xKzZzUFNLSFp2SFpZ?=
 =?utf-8?B?UWI4K2V5aHR6eDRIZytxTUVrMEhuaXdieXZiNkpUZTZ3dnpkbEVsbStiTEQw?=
 =?utf-8?B?SVJhbkVVYVNPTW9XeEtBbUtUZDVxem50cE9ueWtneXFtZmE1OENscmxhUEhw?=
 =?utf-8?B?a3c4YnZTYU5BSDkrNkxWaWxta1hvT1JsZVVsVnFvTktQNCtNdytaL3ZXS1pJ?=
 =?utf-8?B?Zmx0dVhjV2U2STJzMTNjQktBbjcrWkxZWHB0dERqcnNVamt3SkxJU2xPZFl0?=
 =?utf-8?B?dmZsSWs0NGp6MXJ5OTNOeGl6L0hRV2hxQ3g0SlNVYzRlTXVyT1d4QVR6WEVO?=
 =?utf-8?B?SU85eXhXMWdxcE9ZeEpaWnBuckNmVjJobHZiY1F3bWloZ253c25EQTkrWmtB?=
 =?utf-8?B?M0Q5a3BlbW5HRjBoeGhoVHVwV25PREF1YlZLMGptR3hodXlJbVZQRHBDUkNm?=
 =?utf-8?B?R1ZlNnlpSUc0c0RZVW1ROGEzWm9EUldYSFpjRmxIdzZ2d3pyU294aitzZXli?=
 =?utf-8?B?WWpxak5YSkJkTHo0Q2IwQ2lRUG5teWFEVmZDVmk3QVAwa0RwZWR6U0R2dFZ0?=
 =?utf-8?B?eUJla3ZtSVdBazdzcWlCWC85c0JQUVU1RDZyT2w1NzBMekY5ZGV2VHRjUWR0?=
 =?utf-8?B?bmc0TEQwa3hpZWNVQXRuUjE1aDQzUUdldW1jUzdCTjQvZ3J6MitiaDdxMmRZ?=
 =?utf-8?B?MkZOeXkvMlA2MEplK1pKd3FNQUFiZGxjOWlmUDBDVmh5K1pEU0VaQnB3T2Rn?=
 =?utf-8?B?amc3SFFsSE8rQ01vOE9tR2FLeVlDbWFENHc3bFdSbUMwZTlsNmFHeEl3VVpQ?=
 =?utf-8?B?bTQ5S3ZadzNicCtyU05kd2RsYXZreW9US2NaUmh6UWZGUFRXVG9mYjFBdVpH?=
 =?utf-8?B?WlZmemJTSExPbmVSZkRpMHNraERWbzJFR2pmc2JZNUJqdmNOWkFXeEE1azhY?=
 =?utf-8?B?TDJ4dlpvbyt1Tm1kMFBDMytTeHRLcnJGSEpvb2dDblBnd0VUeTNuSktaNU9F?=
 =?utf-8?B?TE1vdHE0aWh2QWtlNXBuMi9LU3JQdXpUaGh4M2ZadzVGSW1DUWt5aDFCM2Zu?=
 =?utf-8?B?a0UzSmdVRlVSY2t0MzZqL2U5SEg3eURxVDZlZkZiQnZJazBOalRJTk9OcHVp?=
 =?utf-8?B?UzRSQ09xMDFNak5IYlVwZDBlak5GcVpvRFlmZGNEVG9MSkFzS3hKbDBoZ1Fa?=
 =?utf-8?B?QWVkdHFwT1c2NjUzWVlROFVuZWlDend3QWd1WkFyZG9Sd1BNenUxOTJzR05i?=
 =?utf-8?B?anlVZEh0NnMzcFpHOU8rNHJnMmdOWDhrOWt5aEZhR0JkRHVpeEVjdGFFK1ZF?=
 =?utf-8?B?Smw2Y1F5TllJMmJEeWxIcVY1WWpDbytVZ0F5enBTZC94d3AzWFJvYmRmakpH?=
 =?utf-8?B?RG5VYnhYYk1iakc4UDBrQnkwQmcvR1huaThJbmRHd3hKUDJVTXNucUxtRVRa?=
 =?utf-8?B?d0k4RWtyZzVDeVpDMEFOVUt6cWxwZFNiUTU4bUZDdDN2UnhDYk9XVGk0UnZO?=
 =?utf-8?B?QXFid0xjN2h6WjR5YnNPV1A3UEVoY1VBN2hCTGRUTlQxa0UzVVdESGpxVTlr?=
 =?utf-8?B?TGhZT2g5Y0RxNlhUVWtPdmhOeC90NEx2d3FtMUtheWxUMEFGT1JaSTk3SmtR?=
 =?utf-8?Q?g03yKhQhz7CvG70h0Y7SphS3z+VuyRgV9KQRyixZFXoLu?=
X-MS-Exchange-AntiSpam-MessageData-1: WfQ618Y/AqdeJQ==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 248dae49-6d58-4969-6021-08deac6ac93a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6486.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 18:59:37.7381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RDRX7kSDwMGPT2fj/sef5Xb7xb4tY4C5W/UuWy6kGfIk9evK84VNpgthLnbPrq0Nu2/AT3mU03vhXqBhERlx+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7994
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C6A34000F
X-Rspamd-Server: rspam06
X-Stat-Signature: n9n6uw5qw55pr9hq5cac4toacw5gz4i8
X-HE-Tag: 1778180384-868718
X-HE-Meta: U2FsdGVkX18kt/lRlbRQBDduxlhkT5m+/0KpPmttPEcKCL3iWK5WQcQr34gs/HxIpyamnrBFL29mQtjJkT6m9AL4XXQ6xNSK9QERhcDTxGEycw+htif/u3ZKuqHrMJ5o65e+pwspdvhaIYqERps2xo5qF0Bp9FJ1HFoXLMznSrfk1ULjUg7z+zbPtUKOfXuUk8nCtP0OYxKP8rA2dAxeAFFNXTO4/aHgi7G+aYbJcd4Cvhccm5z34FiOKf4gmxl9cIPm6WzI0gtrBM0HjtdGYVKSJz06XJAAAXw0PtUyRZM22VLl7jFZg98dWH45EZTALPLC9q5oBzR28z2ex+QuIxHfIzLCj5vmiW+dxYCGKmP1DCtlEd1EDi10/oMDocl4c9+YkTVS1KA39LWI4MYbnwTgik+c2PNe+A18mrJnC4jtt6s722E/RclzNnKRoAjJU1ktacm5LglccG6AVi6W2uQGg1E0aHsrdgUI0ON8UcG+tnU7jyOun9dai+Z2w6I6BzQayb0H8cN/jNQqcCjZ499su6bYXhteu7N4S/MAo6CS70kUEvJOjO4LDjxkKcNmf/HqieIO77dY5+30mnqyitUKIGEA8iPHi6hfUBEqZD6jawpBzcXLX6xzCzpSTWpo6IVs6Hm0DgUszbv8GvBHBnGv4k3kn4mv2iGgUE5AKLQrzuVqSevdNNSgyk0m2OLNEhxoXdFzwxvZR7IYEvYXDa6cnOBgJD6Ey8t4P8K1RfIbMguwQLznFHQcVvqqVUw44LjH6lVAgLOrBe3wxgft6+Oyy0GjLJAEnR/EW7lbnMc6DVR2/KH1s7W7noPgUFTke0ucTj9Z7QOk/knd6ZRTWnPxNNqNLuF7tCaYY/CyLIQTjaaPDAiIPicHSgEvqqHz3sBqFJgokEelFv6EGj20lbgFiB/AJDk8mT/cYMlkkTpUzDM27qJ2MlcwKbnhDItokYidC8SA0byURGg3sYZ
 ePKfjsHd
 t8PaQiCT360x2kogRh3kY8E9V7q0L3jnhDggKWuASB/4WTAt3zb7cg021jQalZNuHNr7pTjqdRJeErCutg8p7N1SVRrR8GisQ8nYI3VTzoZ0/1dJoTikbKK3a/B6jhzk9AECCMFnN8FHxKTB1EODMuYigdj/yo6dKl/7pZMEYp+JRcZllk61S9k1w3FSSb3TCM+0b9VESReenzaujoxzNz+s7wpft3tlytqFL/eBpkuDd+c1KGjTxVkBT9VXhNfBvFO4poYM3hI+/1xrD/8F8sZYcXwdDqeYeuwoHvcdpBBbu0oB7IrO18FA7W67Q1Pxbq0OPaPVzvnJCFZiUjKX82lFgnY1/5j9ECKZvk0lhm/WNtbWzjM4eGSRPtwpSvHnxu5EhlMVq77QGEJQyLGXoTVVNl1S7DfrB8reFcUX1UH643vqw9lZDOaxGLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/7/2026 1:37 PM, Gustavo Luiz Duarte wrote:
> There is currently no easy way to monitor how many RCU callbacks are
> pending system-wide. The existing trace points provide per-event data
> but require active tracing, which makes them awkward for fleet-wide
> monitoring. Knowing the depth and stage of pending callbacks helps
> admins reason about RCU health, gives an indirect signal of memory
> held back by RCU, and is useful when tuning RCU parameters.
> 
> This series adds a debugfs file at:
> 
>   /sys/kernel/debug/rcu/pending_cbs
> 
> that reports per-CPU pending callback counts with a "total" row.
> 
> Patch 1 introduces the file with per-CPU columns for each segcblist
> segment (done, wait, next_ready, next) plus a "lazy" column.
> 
> Patch 2 extends the file with a "kfree_rcu" column reporting objects
> queued in the batched kfree_rcu()/kvfree_rcu() path
> (CONFIG_KVFREE_RCU_BATCHED), which has its own per-CPU queues outside
> the main segmented callback list.
> 
> Signed-off-by: Gustavo Luiz Duarte <gustavold@gmail.com>

You actually don't need debugfs for this. You can just use bpftrace and
instrument trace_rcu_ (with other RCU tracing Kconfig options enabled?). I had
something like that working sometime ago.

Generally RCU doesn't add userspace interfaces randomly like that. I remember
Paul ripped similar things out some time ago.


