Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4912DD39008
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 19:36:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 631A76B0005; Wed, 14 Jan 2026 14:36:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B4BD6B0089; Wed, 14 Jan 2026 14:36:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46B936B008A; Wed, 14 Jan 2026 14:36:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 308906B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:36:54 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD8341A05D6
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:36:53 +0000 (UTC)
X-FDA: 84331577106.05.BC36EDE
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020117.outbound.protection.outlook.com [52.101.189.117])
	by imf06.hostedemail.com (Postfix) with ESMTP id E0E57180005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:36:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=kLGZqaA1;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.117 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768419411; a=rsa-sha256;
	cv=pass;
	b=6EJvRjFhEHlJRki/FagGpur9H4Y0IBLNj636FMVzvlx+ClDXB6B5wU4NZ2l18a/gM3q87F
	x9Xdytlkl/guD0nD4TISJ5dX4c35JruaQulEkK//KLIEJ50QiQmIdna8xFP3bVmtM7+4oW
	RDLowImJqguIK3yL5cH7U7XM4GFi46w=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=kLGZqaA1;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.117 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768419411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOX8Ov3j5ESnVD+6UvK+BszDdy7WtHToyWxfoNeGtVg=;
	b=ywkGS8xzXu2s9yVFUpcunBd/Uoz6hhHmIZBLFbaAESgw6pxPxBKABmR7VOdlVsa85b5KWu
	Yz1l6Pa4UU5rASJVGAzMrrdBRsrniYzn5dAnNch6K+3OFRsj/l8z5Xf6ITeDrnpjTdN7V8
	ePrJ10SiS/6YHdrKdT1mRacfIs+ziZQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qvFosMKyEzu2RK0hlB1xfjjgQse8ej2OPTjwWRBy64ISc2dzfaQrhM2u1MgnRnLBXba6eTAumplVn8zmycYjsdi7joLeIHFElvtuECt82FNM/Msic3psr03eXclxO849nDkp9/Vdpr9VO4Y3FTmIRr6hNGmfhVcoipXzt/xWs/JY9vBOKpbZvQ8tApomNOOFg4Rs+zh0oiYSLbM7lvmSJqiyCnIOdHBAuxUzE7jm1BagX2BJqnxc5nQb0421cNxO82ITFXoBzsCaQ0zBbWp7NlNWISOmf/MeJKc/SBQKiGWBF57WWOnZsrMRJbjWEnlfhqm2Nylszbel/LJXIjDHYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SOX8Ov3j5ESnVD+6UvK+BszDdy7WtHToyWxfoNeGtVg=;
 b=RzjJY2Xq4mg+9n/WLI3r1wD8rtKTFhVORp/PtTMz9kBSawzXse7giGzxKiSL88HxbaUg1PVcJExVyv5yMOC7A2hR98VW/6J/pLKBrUtrSrZ0wirZdm2S+qqvyXWwGJDySoSuzehMsq91Bb01gVdy0sr5vCaqdqYEJgmDBc/yH15sf1/JnRtuhw53ZUWKnEb8oNWHJS6rFvV+2T5j0Q1XQ69Rjm9uroagSNX+9nq7YXzfNiUYNP3nCgvSu3O5AGv/xxxRVwLnBB+/vR5r7UqQ5ztCq+PvzajWW1krx2B4GJ8NtzwowyM2XbiSwZ5ybcdGS+8Njdo8RswiFxuIG7ctJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SOX8Ov3j5ESnVD+6UvK+BszDdy7WtHToyWxfoNeGtVg=;
 b=kLGZqaA1ad6/yH9o37ym3r7rGynCdfRgspHQqza8UldL52e2iI889njPlOplYljMMX5h1WwuTPFpN7jnc1dyXdvUzoY6dlGlQ/GmjTErMJ8b958KH/5yy+KzgFsjnlQyZm0xXINYjbt7VbjfWeoq2KdAWGs63OejcIkc7y9GDaqIykJZxU6JuHdfxT2ArCevLKgcAmQkwEIpuKYQuvT5QvSBQVGKnaJWpxbML/yZ3XoEHZWqmK0HSjedTk2W+7Xs/tTRkv0e+pXpYCgFEn7XKKKiXeILFGadXHK/z7RCtSaRmALZNkpFkd/NVX9KjFgyFuLpuFt02iGgexF9R5aPoQ==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT4PR01MB9846.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:e4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Wed, 14 Jan
 2026 19:36:47 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9520.005; Wed, 14 Jan 2026
 19:36:47 +0000
Message-ID: <a46b298b-baa3-4998-8715-0568b5b186e6@efficios.com>
Date: Wed, 14 Jan 2026 14:36:44 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 3/3] mm: Reduce latency of OOM killer task selection
 with 2-pass algorithm
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 "Paul E. McKenney" <paulmck@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>,
 David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
 Shakeel Butt <shakeel.butt@linux.dev>, SeongJae Park <sj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <liam.howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Christian Brauner <brauner@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 Yu Zhao <yuzhao@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Mateusz Guzik <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>
References: <20260114145915.49926-1-mathieu.desnoyers@efficios.com>
 <20260114145915.49926-4-mathieu.desnoyers@efficios.com>
 <aWfNMKCoEp2LuA2v@tiehlicka>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <aWfNMKCoEp2LuA2v@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQZPR01CA0129.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::20) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT4PR01MB9846:EE_
X-MS-Office365-Filtering-Correlation-Id: 3690a018-c7ef-4978-1be8-08de53a44143
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bnNMRFRSaXVNYzgvVGZQS3dIVjNMbG9OWjBZN3BsLzZBMDhycDl5cHdMMXRk?=
 =?utf-8?B?VXcxK1JoTWdHN1NHQ0hyTEovV1RrUHpoQnFWemsySmRRd0dyakc2UHR2bmJK?=
 =?utf-8?B?U3A2TytIYVJVWjFkaXp1dnJBclJHSmhJbFJQcFEvR3gwbU5iYUwxMEFOVzlN?=
 =?utf-8?B?Mk1QRXplbGF3NkE5Um1XUEZ3bkQ5Z3FXQU1vUnJKaU1CMjhRTTFZVFN4dzUy?=
 =?utf-8?B?bFFBZ3U5MDVlRkZubDRDU0pxWGdvUUNnRXhOeGc2WWczNDZGT2RCTWpiSnpI?=
 =?utf-8?B?djNNZForSk85Sy95NmtxRmNaWk50b1pxR1dPMWtyMVNhS2wyMEJlOFBtNkpN?=
 =?utf-8?B?UGljNFFuVUpEZUQwdnVvL0NQbXVEb01uaGZxR002TW9OQzFCZHpXb0RzNUMw?=
 =?utf-8?B?ODVkTldkbGdNY21sV0VNMUxYTkZuVGFmTGp2Wkpja3FrK3hvZm1RU05Qcmtl?=
 =?utf-8?B?b3ZMbnc0aE1abXVmMEJBc1ZCR1FORVd4ZUlDZEJqNXVyUVRWZlN1UEEwemhQ?=
 =?utf-8?B?bWowbXV2Tk54ZWdjbGxReVAreGZvOEh4OWtNdE1ENlQ2c1VqZTFwc3o2Q21J?=
 =?utf-8?B?QWoydnN5UWp1N0ZadFpTRDhvNktLeFV3dFc5QklEZXFUWmxRWnc1bjRpeE5O?=
 =?utf-8?B?cEcrY2lXNGh3RlFzbjRKQUZJN28raHgzaUNmdTJ4M0lLNWJ1a3JXcVRCLytx?=
 =?utf-8?B?V0Nla1dPOUZWSUFCV0xRVnJhY1BUOUF2TksyaVpsU3VuVnlubE56OTZpSFBB?=
 =?utf-8?B?TWJOM1dXY2dkZ2lnOXdsNXJBYUVXeHhCemo1RktNckJIdTcwUnhHZUZuT2g2?=
 =?utf-8?B?VGFMK0dxM3B5NWErejZtVEgxdEtrV2FMeXBJZmsrdVNJUWdERWZGeWlWdlJz?=
 =?utf-8?B?ZjlEQ0N1Yk1UWHExYWVObWxoZnZXa2p6T0RrTDE4TTQvWVZCeXdiMkdtbFIr?=
 =?utf-8?B?ejZLRzY0TThFWnlkMHJ4cDdNSHhHNlN2QW1MYTNKWnE5YVFyK0QxaDZmRlpv?=
 =?utf-8?B?NnVjZDlFOVpVNkRiMGR2cm91TDJOU2x4WDdyZTc0bGFZMmZyUU1lOGx6emtF?=
 =?utf-8?B?VnlZcXFzVXRrcUtDTnNXc3BsOEtVZ2FQV3BZeURvQnJHTEJBaWZxaTMwQjBm?=
 =?utf-8?B?LzlnbUQxaWVqVUVrcVllK0tid0ZRQmlTdnAxL0VZNUhxU2hPN1p4aWExRXBP?=
 =?utf-8?B?Ky95UTM4WnMveW5QdlR1Z0tFSE9hQ2NCTENTS1dDbERVZ01VSEE5RWc4RXVp?=
 =?utf-8?B?RjJTT3V6ODNkYkNOUFNhMFJmc0wwR21ZU2hGdm5RRVdxYU5XWFJWUngwRkRk?=
 =?utf-8?B?R2FmVXFseTcxWU5Mcm5PcFgrbVRuV21uSmZIeUxJVlpZU1h5Y2M4Tkd4NDFu?=
 =?utf-8?B?dzhOMEQzOUdOUkFsdW5qbk9Pa1RoNmJMRkZDT0JqV0pydXhxTkFFaktReDBa?=
 =?utf-8?B?eEoxbEVPdVpOMGRRZ1duTkV6dkpCVTRuMFB5SlE5UkNZZWVrdStEbFp1cmEx?=
 =?utf-8?B?WWpVT05SWmlFQzY1bzFjY1dFaWk3eUlBRmt1VjdjdGNxMm8reW1iNVVFNVNi?=
 =?utf-8?B?V2pSM0Fnb01CS1BiRWRWakY4aXcxOVdaa2NUMDBrSmNKSldUcEY2TkJpZ3lF?=
 =?utf-8?B?WU5sbmF2SU5YTmNLYml1TGZCRHhjaDh3T1ZhT0E2bkNqalNHeXRGeWJVVS9z?=
 =?utf-8?B?UDZvZUlsRDFEcml6RzdhV0V3N05aaFdCcC9HQlFrSmhiRmRuUFNqMm83RzZT?=
 =?utf-8?B?YXhhUUp3Smx0cTNMNGhtK0xoZGdpcGpPSHFDMzVDRW5ycTI1dEE5QVhKTGNB?=
 =?utf-8?B?eDBNdGt3THpIbzQrZDZvVWFtK05COWRVU0NTZEZPMDFWOEM3dWxqWEd1bk1C?=
 =?utf-8?B?ZGtCa3VXOWw4RnVOQ1lqa2JvRlFvREVvZTZsaEFxTXlCUEtoSVRpOTVWMVdT?=
 =?utf-8?B?RnhFZkJaVmgvR3h3R1JWNlF3bUNPN1BSaDhjZFBiV2FGL1d2YS9hVnZjSWtF?=
 =?utf-8?B?Rm8vcmpLRTl3V2VHZm5KNmllVHBlOFZNWE5abnNPcFZoTmR6RWFBbDMwMk5X?=
 =?utf-8?Q?Vs0Yjv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WEgyMFRlSXFXdnA1bU15cm9zNGRSNnQySjd2eU5DZTFhQW1vWmZlbGVpaWZW?=
 =?utf-8?B?S2h2UTdsVDlDM2lONUFBQlppR0tLYmF1TWNFYjdMMHNISTczUkJxZWgzUlBS?=
 =?utf-8?B?UnpmeC91YlJuQ3NPSmRJS0plUW9KcG92OWtKTHhFTitGVjI2ZHc1d2d4bE95?=
 =?utf-8?B?QlFHbTVBQnJBZ1FHZHpCUTUzTHhRK0R1S1ZjUWVIQjNFcTRnd2VqOEthVVdo?=
 =?utf-8?B?cjhzQjhEWWJnY09PclFpSXN1d2lFeG1pTXJJTndUQTdBU2FpM1BUQ3ZxTXFu?=
 =?utf-8?B?d2UySHBUY2dLQ2RrVVpvUmNyc2tJSzc3QnlEZDVDWlhKRS9md29IVVNVQ0U4?=
 =?utf-8?B?bFhTaEErWUhqckxhbnZmVTIyLyt5VVlHTVRkUGlRV1hmTjZ5Zk1UUmEzQktw?=
 =?utf-8?B?UzA0RWtjMDdGTVNNZFg4aFYxVmhoUkRvZE9XeWQ3ZkZ2R0NGdTBlZFlnV2Er?=
 =?utf-8?B?VmpVQnhDRUVBejRDTjlvdkFUMW1HWitjamxORU9CUEJqK3AvYzFqMSswS3dv?=
 =?utf-8?B?V0o3ajBlWENIcmlNMm1jYys1OURDVUEzeDR6UHZKcnlXOEw3MjhDSGdia1N2?=
 =?utf-8?B?U0tLMVlmUjhlZ2R4VENtR1F6MnFxcHo0aU54NWtjNFdaZVYraWQ2MDdPOVdq?=
 =?utf-8?B?Qkh3NGZPdThtYlNualgzYk13cEJ1ZGpWT1Y5RnY1aVU1NTBncnJGWjBYakVT?=
 =?utf-8?B?aVQ5VHBvTGExV3Z2SXdkbWtpZVMrRzcyZFVwTUJyMkRTcFQ2UDQ2T016b2pj?=
 =?utf-8?B?NDAwbHAxb1RqODRTNDNoS2ZHRlZlWlBYZzlWa0JJMWhIYVpZYU9CNVQ1Mlc4?=
 =?utf-8?B?Wm9kYTFONnZhZS94YU5OK2VjMGF6aDd5WlB5bDlZVjNVWUhaR3lrOUdoMDhJ?=
 =?utf-8?B?WURCbEhJS0RGOCtLUHVHL2FFVUdrMDRXRlB0U09BRTIzQlpPTTI4b0dvNU1r?=
 =?utf-8?B?NmZJTTFlQ0lJMzB1VklUeG9CRExtQnR5aGxtOUdueGIrejY0ZVBseXE1RXB6?=
 =?utf-8?B?MTdVSGc5U1EvYldsUDlNZEc3VDYyQXFVbmlqeVVkbFVSYU9LZFdENWgzdjlJ?=
 =?utf-8?B?T0pMTHZhSFVXM2dTQTBuOElPMEpYZXNCVlpXaUVIVXp6a0F6K3l1YU5pdk1u?=
 =?utf-8?B?cUFXL2ZkaWY1ZVhjdlVuVEF5czFQOE9KM3pJd3Y3bVJJREZ1c1lWVlU0OXpQ?=
 =?utf-8?B?ZTBSMGgzZFZGTjFaUGdhS0xkK0s1OVhQamdEZ2lWSDk0cXFhSUUyMndjaTJY?=
 =?utf-8?B?WVpwWTRXb3IvZm1tVUN5eG42djZCdENoOXllclp2QXkwWk5YQ1N5Zm45emZp?=
 =?utf-8?B?S3FyWjhoOTNCUHhKRHNuYjNGSml2TnhqMmRvamNYWlZjeFB0cnpyaWdBWjl1?=
 =?utf-8?B?ZmJYRW12UFYwTnlwYzZWN21UeGowOHNBTFE0elJIZUkyZG5JV2JxQUFqQXMz?=
 =?utf-8?B?MDVlZWk4NWFLWDh0R1p6L0VwVHl0NmwrL2FDdWp5ZFhQWEw2cEVQMGlZSlNa?=
 =?utf-8?B?S3BDeE15Sm9icWVMVXBvVTl3d01zY3pVRGRUREltbkg5RXlndDRCYWpjZkdN?=
 =?utf-8?B?NEdqYTloZEFSTjBFeW1lUThzOUF5d1I5dUdSSjhrMUdOSEhtMHdOVGlsMzlE?=
 =?utf-8?B?RUFmOVdxVUhMRm9Mem9ZYkg0c1VadlpJaVQxSjlxVExwNlcvQmpMNDlBUkQ0?=
 =?utf-8?B?a2tqZFpzdjlRSlBGRU1wR2NSY3gzanZMUXl0OGtaTU0rdENDbWZJVWdZdSsz?=
 =?utf-8?B?NmxjU2hWNzhlR1BZTlR4YXlwK3VUbEFpVUx6dmh5blcyR3A0YjdtY2dVOVlu?=
 =?utf-8?B?eXREd1REQXVROFlsakppZGdjMzVoL0xkTklBL0tZOVpBSzF6bVUvVEs5YTV6?=
 =?utf-8?B?VlAwRk42amtDeWJ6Zk42U0VoL0NGVDVzK0tqM3EreHhHNmNJNGp2VTVvUUx6?=
 =?utf-8?B?eWI0TzJvT2RtYkZGSjJxQ0w2MERiUmJiZzc2SkQ3WjNMZFlHSVBJZHFkZnVJ?=
 =?utf-8?B?cXgxNk1jR2YxQTkwNzAxam1rdWIycU1VZWhDdWJUemRGbnRnRDlSVHU4TnZi?=
 =?utf-8?B?OEFvUTN4L2ovai80S2tBcHY2cWZLT2RRSS9NajY5SXRTQXBHdUg3L0VmMTMr?=
 =?utf-8?B?bm1ZeFk3QkVDZ21LUG9oeDc4aVFETjJ6a0poM3JiUzBYRElSTUFIbTJ6QUpE?=
 =?utf-8?B?Z0NMYXlMSGlHM1VIM2VwVHVuQ2x6eHJUWFA5ZUFxbFpabFVWY2hpTW9mY1Jv?=
 =?utf-8?B?eEpNdnRvQWV3Wmtnd2lpOVhRWjFHdkppNnJFNmR0cm40NXVRYTdVM2FNQm4x?=
 =?utf-8?B?dU10SkdrbE5pY2w4QndxeVZMaFFtSkU2SEVnSUQrUFg5M01EZkhucVpTdHVB?=
 =?utf-8?Q?xMMcyHKPWHQ0jKEs=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3690a018-c7ef-4978-1be8-08de53a44143
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 19:36:47.0165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i8R32/s/0Vae7XBWWw70Z9WHX7ba372MMMan8a6YlAVEeTttMh/BaSgzQ9/ppxx8BZ/OsexxIuSXkze/iiXtXk2vxud2QuEbkvhr4wB2C3I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT4PR01MB9846
X-Rspam-User: 
X-Stat-Signature: ajtyrfu7n3emaoyyc6jw5ia7a3oz1sxd
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E0E57180005
X-HE-Tag: 1768419410-743466
X-HE-Meta: U2FsdGVkX18ZR39UHle/5VKor89SwwJWRv3BpdcNrMCb03JvYMRJxKEDnDwEFSUPQydh6j0A1ygS9HBSzar5nln/hu73jxs4NRZpWMM8+kQ+OHmkIBrbFRFJ8Ud4e9VoJOxY9tboRAJ1vhLdt67T/FeghCKCKThGKJLuTYWb2mqYELCy0Wj/t/RoBF9O1P+B0SkMEFfhPyp0fpkPzZaBZJKzsScJ6dklBxQrwAeiS955iXZwSZyc8IDKYDvRaJz30iJZsM+eTiv7Awhi1Ga8/vSZGgIrPJJZq8EMhYqRozM69VPddH7ZZ0IZOgGtkcx2DBK3S6qbp5XHoaMzUpqlpECzjyib0eRrOPfp+ane5XpGGQdfKmX8Jc+a3UuxPFzLwrq0xDHybvG03fQ6yQTqbtBGTEPtc2wrnFzSwHRUBgHlGhMgcm7ZLud07lmzb9aEoxvpETC2CJmWDKJYdPqdQUTXT0zV0l7Kn7QNfBoXtkgVnIne1q8t4uPhO4nt8R+RJ2M4T0cptYfiUfHIH7buPm4S8KgoQ6vnTieebKc5JDdX3ikSY58LR2BjMY5wzI4e7WLn79Qa5AZUM8tumAlArku8ftFh81CJ4BjIWtNvP6ScBBeDwpjGAvsPSdwfEc9ZlE4DcNrY384N/JVJLXvRGInuomVilYIGF46j4rnzlHH/E8BiGDCL92jbnLdMmB/yjhpfF6TmczEdYJ2+SJAhhsBseCc5CTasFz9APy4tIQiTsWwZ3sS5tQESXf8P11fu2vVdpDD6fpDvdzkGM2IKh4j6vLZzwMDAAX91Vkv1/6L7mFEtsothAk3rAFFIZA19qEem7TSxfgVECpnm00+cHnbAtdCN7vyk540wnGfGA/h4xNMqk2kZy234LvjHHbvT7h/iXZRe8noDRhOX/UwZALVp9F8HJXZOxCuIGB+pEQY29qA+Lk8BhBSuwYn6vmijkcWSasTOITfwC8UNK2P
 GvnQVE9N
 xDmSn1oBtv1WZHHk46M1dgeUW3d7QWjhTtwZw/ILGAUNJceq1YMgeKKgMjSOuTrxTAFl6WS/IOv4nYAzadMi4EkD4ZHxP1bPM3CN4qnbB4ZfzQ+8a9Bzxzs1xFv8IFed1MtpXar0Ol7GaQD8yx80bIwiVtKIqlwh2yuIzJRp8EnMj/xiOC7fVblyCelFlfqpn06sKrShKgSxKD+2wLRv4m9y33NkYubAIClP1ZWnpkTlzeJJ69cfFtlFVMjXOK+gQSLadKpqzla+GW32w4ZN7+REV8H21plTkuVhNJbGR9nimNtIPuGipApDBdx+RJMzvxRu8kLaCSmD5GVc0BGWYhIlTDLl4u+lt5qIIIws9Bn7V3gZc4lPlRf6imkiw+0Y1cWeteTIu46oUBPvQI2VsXvsVMFlwrOarURy8+xSNK41kWFmhoKNNAKqMH4o7qx/foozXDqoUKAjwDz0+MlifyHsgumIPVa43sGYW+/Le118pxXLzTjOI1d4xdJjc1WBGzIw5sDx6sI4QAVE56BCW7YAAQcR/g+ZeBIHG5J4477m9Slk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-14 12:06, Michal Hocko wrote:
> On Wed 14-01-26 09:59:15, Mathieu Desnoyers wrote:
>> Use the hierarchical tree counter approximation (hpcc) to implement the
>> OOM killer task selection with a 2-pass algorithm. The first pass
>> selects the process that has the highest badness points approximation,
>> and the second pass compares each process using the current max badness
>> points approximation.
>>
>> The second pass uses an approximate comparison to eliminate all processes
>> which are below the current max badness points approximation accuracy
>> range.
>>
>> Summing the per-CPU counters to calculate the precise badness of tasks
>> is only required for tasks with an approximate badness within the
>> accuracy range of the current max points value.
>>
>> Limit to 16 the maximum number of badness sums allowed for an OOM killer
>> task selection before falling back to the approximated comparison. This
>> ensures bounded execution time for scenarios where many tasks have
>> badness within the accuracy of the maximum badness approximation.
>>
>> Testing the execution time of select_bad_process() with a single
>> tail -f /dev/zero:
>>
>>      AMD EPYC 9654 96-Core (2 sockets)
>>      Within a KVM, configured with 256 logical cpus.
>>
>>                                        | precise sum |   hpcc   |
>>      ----------------------------------|-------------|----------|
>>      nr_processes=40                   |    0.5 ms   |   0.3 ms |
>>      nr_processes=10000                |   80.0 ms   |   7.9 ms |
>>
>> Tested with the following script:
> 
> I am confused by these numbers. Are you saying that 2 pass over all
> tasks and evaluating all of them is 10 times faster than a single pass
> with exact sum of pcp counters?

Yes, that's correct.

This is because we can use the approximate value and the
min/max possible precise sum ranges to eliminate most tasks,
so we only have to do a precise sum on very few tasks.

So we're basically going from a 1-pass doing precise sum for
all tasks to 2-passes doing approximated sum for all tasks,
and only precise sums for the very few tasks that happen to
be in the vicinity of the task chosen by the 1st pass.

We could probably do something more clever and do all this
within a single pass if we keep track of the possible candidates
in a separate list, and then only iterate on those candidates
to do a precise sum at the end of the pass. But I chose to keep
things simple, hence the 2 pass algo.

> 
>>
>>    #!/bin/sh
>>
>>    for a in $(seq 1 10); do (tail /dev/zero &); done
>>    sleep 5
>>    for a in $(seq 1 10); do (tail /dev/zero &); done
>>    sleep 2
>>    for a in $(seq 1 10); do (tail /dev/zero &); done
>>    echo "Waiting for tasks to finish"
>>    wait
>>
>> Results: OOM kill order on a 128GB memory system
>> ================================================
> 
> I find this section confusing as well. Is that before/after comparision.
> If yes it would be great to call out explicit behavior before and after.

Not really. I'm just testing the "after" to make sure we get the
expected killing order.

> 
> My overall impression is that the implementation is really involved and
> at this moment I do not really see a big benefit of all the complexity.

Note that we can get the proc ABI RSS accuracy improvements with the
previous 2 patches without this 2-pass algo. Do you see more value in
the RSS accuracy improvements than in the oom killer latency reduction ?

> 
> It would help to explicitly mention what is the the overall imprecision
> of the oom victim selection with the new data structure (maybe this is
> good enough[*]). What if we go with exact precision with the new data
> structure comparing to the original pcp counters.

Do you mean comparing using approximate sums with the new data
structure (which has a bounded accuracy of O(nr_cpus*log(nr_cpus)))
compared to the old data structure which had an inaccuracy of
O(nr_cpus^2) ? So if the inaccuracy provided by the new data structure
is good enough for OOM task selection, we could go from precise sum
back to an approximation and just use that with the new data
structure.

Thanks,

Mathieu

> 
> 
> [*] please keep in mind that oom victim selection is by no means an
> exact science, we try to pick up a task that is likely to free up some
> memory to unlock the system from memory depletion. We want that to be a
> big memory consumer to reduce number of tasks to kill and we want to
> roughly apply oom_score_adj.


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

