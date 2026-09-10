Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF575C79FB6
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 02:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DACA26B008A; Wed,  9 Sep 2026 22:12:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D55A76B0096; Wed,  9 Sep 2026 22:12:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1D5C6B0098; Wed,  9 Sep 2026 22:12:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A7DA6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 22:12:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 930801603C7
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:12:26 +0000 (UTC)
X-FDA: 85196228292.01.78DEEA8
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011015.outbound.protection.outlook.com [52.101.62.15])
	by imf03.hostedemail.com (Postfix) with ESMTP id D33B620003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:12:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ohW90PuX;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789006343;
	b=wsvzaJNsu0Bgq7WXiTnfT9M3PuD9aQr/DW3ivudUcYq/ssdY74aWl7eM87VuB9DC3W1e2o
	eu25evSr5BMcMf1Ditn1BJHu5/BRIq86aZC7/oAFWD7Ah8SHlsC6z6elQuXbpihIvTxgXj
	Qmupg6p7bx3CjjOghQ7u+kBURS1C6CA=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ohW90PuX;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789006343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yyK4wlQwe09SITpFrWIGcbFXS/j69YYjzzAywZpktTs=;
	b=t5YQwPIlToox/1IJpG91iWQHh2iovK/nMaa60XedALsS+5XvBK7O6iI7L6SGaOA2kfxpwl
	Qmc0I4aIFr6Jed+H1kS99YU2MzROXpuRXVxYFwb1XBhfeDFUsGeg/mayxBib/KVHNBA80z
	SuXphsChWUR/vdq6bvOE0JjL3LDqonw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BcZ3EDe4p0rNJK6Nl4/HStl3Z0OOkXwtKygS0YFz7+sx1DKMDxnBRdH2kaYAqOgDfQdQLFLgpaIlHQMz37IftpuW/HMSrDjUK1EM/w5FVda4Gi2APFFVYvewhsDGRl2zNNHbyhDXVEbad/0dkTzffifnF5k1fpwwPRgrPiTqTaM1xGCmAjzVM4B87sL+YKHVBVgh0Hq2yvUWZFlRxhH65ymcuai0XMG1TSX9jkip8b62BXzv1tHQqICQzACNAVAXWMQGikvd1mVGYgQ++DKsNCqZY8XAzXiaCZt7Amq8atew9RmxvogEUDd/B2YtKOtA9EPvu+AhnU5NJXWuO/Tkew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yyK4wlQwe09SITpFrWIGcbFXS/j69YYjzzAywZpktTs=;
 b=q4IOfAXxAK5OcxFxt+9VSTCqZrgLM9ErJcVHEeCIpzPT/TWhbWx5YRgAsPGtqPq3WgqBsPy5gVf+1UjNMYllj7j1agH8jM6oDEyxG5hfOjW8t9dsyTxdMp7pckdS+DQs5tpgsKoqi6cipPaODIgBNNp7JoR8mA3ieaKHtDC9UWd0V34QPbEfR99wtbZD1eiWznyEZPdDByX5hnbbPCUIGcdBhQLVLzBcyhTUWpOkLHoxAzWY/DBxnqP8/63OYFxkDc6qYlbu8mGaIFWyoA5RpTpKM4eVvZQEcYTEYePLfp534eN/tD4yq4nDrxJoDZ3cMssx46M5QCc8BS/fE7t64w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yyK4wlQwe09SITpFrWIGcbFXS/j69YYjzzAywZpktTs=;
 b=ohW90PuXUnbGoeVTmRiKhvkIez0nMLPWLf4QvG0aRyY4csKPy9VucI//6+9U/lyPhmaJxoDPQlbhVefb8OMLP8cyBuW/pfzxb/6KwhbtwYV+MuB+kwte0StHvvuNZdaYEeNtpwz9F86bNV+A07/Iji2mRXsKVz5CWhx6kuhKM7YPbiAnA3CTIuKUto+5jCSufd31evyFeKFF4ofPv5x1ii6x/HlhQqAR1iLfcHWFKAjavhIllOIDGKGb8d6a2I6oltLuSL61F2YMlqjMLh4/xhEZ5ypxKhBX+ISI03+EJuWAbT8EaMhzQNsszrhwY/HncMdqny/TiD6lyu15tS5wtQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH2PR12MB4183.namprd12.prod.outlook.com (2603:10b6:610:7a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 02:12:16 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 02:12:16 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 09 Sep 2026 22:12:15 -0400
Message-Id: <DLB9TGGY2VXO.OBBZC2WW5EHA@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Ilya Dryomov"
 <idryomov@gmail.com>, "Alex Markuze" <amarkuze@redhat.com>, "Viacheslav
 Dubeyko" <slava@dubeyko.com>, "Trond Myklebust" <trondmy@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>, "Richard Weinberger" <richard@nod.at>,
 "Zhihao Cheng" <chengzhihao1@huawei.com>, <ceph-devel@vger.kernel.org>,
 <linux-nfs@vger.kernel.org>, <linux-mtd@lists.infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Gregory Price" <gourry@gourry.net>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Kairui
 Song" <kasong@tencent.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3 13/14] treewide: adjust comments on PagePrivate and
 PG_private
X-Mailer: aerc 0.22.0
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-13-6ae22f9d9272@nvidia.com>
 <54a48bae-aa0e-4833-91a2-5b5908356255@kernel.org>
In-Reply-To: <54a48bae-aa0e-4833-91a2-5b5908356255@kernel.org>
X-ClientProxiedBy: BL1PR13CA0327.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::32) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH2PR12MB4183:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d0a63ec-d13f-4d89-4ad5-08df0ee0ef4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|10067099003|56012099006|4143699003|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	a9mMbP+tNzNQSDQh5XvLFHJiSXepgnScIrvJaOUBRPYRPrqIyVTib+5JDnir+xIOKp43+noT6VCzNgMaIRSlXFl+WdAR9W74uh5ETH1g7YTtwUeX97Jm9odk3zSHtCqmhF9ppTviGWeUA65KEALtUuCFntXKa+qt7aAQYnJWLA+tp0MDIsHT5oETQHHMtJHhFVCQCVUnVw+4uYTqgNcdrpTzcyjNmdAGynvdQAP+w8Rl02+pW5w3gPCqdfXIbi3RQOqNaYTm1yrG2U8peSxKqK5D2isAZL6duL6Cqpel2Sg3b3Gt4K/PtCWEZLfT4fnwj/R+3fE/OzIa7V3DCTmhwfDZoRwns03swQWMA5XIdT8pupNSUS5ENRpn9S5vMwVhe0c4hfZx0WcUUhtatpAK4RpDWE6q/9/vCL+2GNvMJnYAGwFlqVhEv+rW3/41/4tyvehrb/el2gHElj70ITngLvNCaRhMxDf/k8CWLwqEgTdTN+t78xq2Brm5lURfOKtC74mQvW/QfBj3g50SDTZJRpmmb9THQQRIDyjqSAJYmx7B2iQ58X/deJC8MPYBrNYX83VTEuaeHHwG1XQTbG/pl/tr/xRrZD9uQslJOtbnaqJJJM1t/7ddGAXWjjgguiQ6vVvBpxzzv6uYQvYcSFBMAqIhxL1qM5nNYXwy1uPHizFPXRWjVkgr6wb823R9p0es+TKrfH+cUz/IkfC4xXYV/g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZlUwQVhwMTJNdWtFeXFVMk9QQ2VRSU1pbmhTa3BwVjFyc0xwQWw2ZGkvSDZF?=
 =?utf-8?B?Uk9IaUpDWE9XQXF3L2l3NGZqYXhURDFCWmNCTDlTRlRCYVplcGVxcVB0b2hk?=
 =?utf-8?B?NmRMQlBKZDZBUStjdDlDMktRL1QyQmRnU3I0ZWRsMnBCV1hKL3BKRG14MHNh?=
 =?utf-8?B?ME9KL1gvbDJ2RlZsVDd1NGZPWUJtNjB3RXk2U2xhOEx0aHcxdlBHSytZYkNk?=
 =?utf-8?B?Yk5nUUMvY3hTK3YrcXdxMmNhb2dMZlN6R0oxdWJyaHhqdWVyaDIvTjJGYzJv?=
 =?utf-8?B?Z3pFNjdIVTJ0OGJrRnQwZG81SW5Yb1ZJUndhTFhUZXBKQmVxWFdHVWJiVDRp?=
 =?utf-8?B?ZjExTVF2d0xIN3JkV1BTUVFCV2VaTUZCa2Y3dk5QVVh2WjJaejYyaGlZdVJU?=
 =?utf-8?B?OVFLamI4b0k0VkNUaWNxalVveC9kN2dqc3d2MW1FMzFlSEN4NmdwcFFWZ1NH?=
 =?utf-8?B?OW9JZzc0U1FPenZlZTZ0SkVDMERPZGZOWnBRSjZRK1REMzlqK0Q2d01iVEJv?=
 =?utf-8?B?cHBhZFRaTElhSVdITmFkTFhlN3dyeUdEV1dFTWVEVU96SVIvVUJ5STlHWTlY?=
 =?utf-8?B?VVZRRVd3NUV2MzlQM2QxdUJ1Z0l5emhXV3kxWGVqQU92WDNlMFl0bUpuWk50?=
 =?utf-8?B?RDhvZ2pxTWt1VkVPL0I2NHBvay9HZU8yVUhsTDNEd24yTUxVSGwzVlVxd2FR?=
 =?utf-8?B?elBYWWJ6Y3FMeFNReWFiZHYxTmRTV3NlZ1lwbUQvUDJScjd2RXplbFJzMlM5?=
 =?utf-8?B?MGF3THN0UU5QWEJhdG53MTY4T2pEQ2tnZFRjT3RnK0xLRUtqdWxNb3g5NGRV?=
 =?utf-8?B?VnVheGxtMWhLYXJNRzZNck5wREttQWdiSWUveUhyTm4wdnBETFdkaTcyVjE1?=
 =?utf-8?B?bFd6RytPaDJvdjRLSTRSSVlwUXJCNjljMXJ2cllCODlnNmJ1TGJORkFzSW8r?=
 =?utf-8?B?V2RtV3MyZ1BIcnMxMG1oUzlXUlBid1RSWGlHaml4RmdWeUVPWkczMzdsYiti?=
 =?utf-8?B?YktZdEtnaTdiWWNQWU1pYjMvRm90Ym05UThVcnp2UEFIYUlXaU9VbnAxNFRQ?=
 =?utf-8?B?aEFhQWY4Q1lsZ2FyeEIwWWNoMURKaXdIUHpNRXAzSjFXWjBNNEtSS1JWeFJi?=
 =?utf-8?B?M2twTEprcWJxTTAzNmRydGo0dmlPS2FnYWFRRTFZWGVvaEdxbElkaDR0YXdy?=
 =?utf-8?B?MktSNm44cy9XeUVGdmpxOHRVSVExeU9xbzhtUktzQ1NueGl3SXp5WEZWVEtv?=
 =?utf-8?B?eG8wYlhhQW5XZzROaWMvOWhVWFkrMjZxSGhMS1VweExTaTk3dTZvRFI1UDNL?=
 =?utf-8?B?YVVYVjdVRHJxWmFBVUNZRlRjOGlNV0NTaEpDK2J1NWtwSit5WmxyWjM1dk9t?=
 =?utf-8?B?ODdRK3l6RlMvQmxyei9Rd1VUMGVKZWZwQ3R5ZlNxeUhMdTI4UjJ2SHUvSk0x?=
 =?utf-8?B?UEx5RVpVN0JuRHBCdlk1RHRwbUR2ZGlzYVo5T25sSTVPUlpEZ29mOGpYM0VP?=
 =?utf-8?B?TEtCbFdtTlZObkQxOHpaNDJhcmkzUkNOM1UzaDJHSGd1VlNRclVQbCtlam9k?=
 =?utf-8?B?d01EWVA3TUoyK3VWVjdBUlVWTndQUW03ZXYxYUU4M0xxczkwZzVKbXp2d3lP?=
 =?utf-8?B?aGUzNFdnVHpJd3FPNEV0VW9ucjVGL0VBVHFSYUg4bXFGKytDUGhmcnRNbTlC?=
 =?utf-8?B?OHB1TnFnMUo4dVgzSlRISGxpN3ZJckoyZzU2cFRib2ZHTVFrQVZoQk44a2pS?=
 =?utf-8?B?V2Q5blM3TXl1dVBVSFNIOW1QbXFjZWhmME9TeHlPbXpyT2t4VTk3NWJKekEz?=
 =?utf-8?B?Yk1KQkFQL2h2em9ZZS9YT3JZOURlUWtqYXZSVTUzODMvVmZPMHBBMHlEZUtr?=
 =?utf-8?B?RU1abTdoVUgyZkx6VmxUcTBYOCtkVlVqVU5palY0eVNsYUc5OWIzRmptWnBh?=
 =?utf-8?B?UlNTMHJ3c0g4ekVQNkoweTdKR0J3UjlNYUtlKzAyclVXMVhrOUZncVNxc1FX?=
 =?utf-8?B?MitYdjlPVlFWRGRkSEhEZ29IcHhqbTN1VHJEOTBYTUVEaityeGFRM2FhYWhR?=
 =?utf-8?B?K205Qk4vWm5scDRFN0JqUVZlMytiUVl6L2w2NE1QYVZwQkV0SXl6OFNXMHc2?=
 =?utf-8?B?RkpFYkpVaHZhUXNmRC9LdERqTjdyWHRDSm85OVFGTkZWWnYrckg3Z1JPQUZN?=
 =?utf-8?B?MUt1UXBwS2Z5K1Q1Tm45YUtsVDUwTk8vb1JSeGlaMFVRVnNKZjIzcSt4QmlI?=
 =?utf-8?B?V05vYXJBanlFaFhUa1F5UlJrckxYR0tUQ2FXTTlLdGpYb2xVSWhVN1VvZUNF?=
 =?utf-8?Q?89ZXKRbSlixj7Mhy3I?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d0a63ec-d13f-4d89-4ad5-08df0ee0ef4d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 02:12:16.1977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qo5gWPo2di48TXSgXP7CqDR0gX+PhhUjjNTFXUrZZknl/la8jD+OfD8qwDw6iAUd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4183
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D33B620003
X-Stat-Signature: dd4d1fmt759z3sjkxk917zed4j6qzq75
X-HE-Tag: 1789006343-874153
X-HE-Meta: U2FsdGVkX1+Jvx94LoAi57vCSCPe5AfGFSha9uiHQyqXTLvCXVk235W4oV920Q0Pv1DdfaVCjP9og7KfsAiDc9YHRfpXBfB1tKOWSIbw1/6srEPez7w8trRxZYSiGTOkyc2kiG9f6rlaWg30vx4ZD4pFs+iMjW4si1dBWbBYrZP+N1+OZBIrZOh3wD5rA5te7PUE0joFLz47wUGfHrKcWC/+o2LaM6vkinOn0Tw4FbPBf8dvQihCP3wMKV5h3ruR+l+aw1qCL3FJJzJxoZLWiVSOYv0R9u2Bw4FYuJtoptvNr3aDl++FWB50GXu6rdOEW66HKsYnWJExxWc64xpwnEqpg3YsAhu56tdkRcwZdnEaeX16C1jqYZ0XCVRndMYhWUVL1Zmg4HhQOu9G2RAUcah1giL09ro3LSrwDUzcGA24ikzdnlkkTnmw3Yg0R5ajnvgTnwv0Z+Lf9RC67CVvITE1WqxLBbf+3Jsi4Gmg67T6f+kYQWXIsOkR2YqfrymfKYyz/kdXhtQc8mqFAEoJbE1TpysYGfEKBnDBO/xcGU5WoEvLKNsaBE6IetqAoOd38cNyDONIWrfU56YsYaAaW9TllJJ9ndtKP76tHH0XeCr1yGgrlSbo6zBXCsk8pCbFnEsrOCbXTH5dqY5MdKibagFYReJXpdc9K5s8/1sGztpLFflQY/YdJqBJ4Msxli1hCEd1UuL6ulDjv0pcBqIZ0V8BsNXV/7z2x5Z9qO/kJAJV5VCJM3JFgO/dfz+x4gx4hiFNP9sJ39eyYaHwVRZeMA4eBxjY/pBI2jDvrpfFSB1f9KQKkIibBbictD2RhnFDSmQO9yUV6ro3YYSQ6KNcpUYhBsbPk9/cCiFHfQFFFppZZlCfb+vWytTJMrONFaoKjuQLp7eoZJ4+mh1VIHCYSpiP0cqrG7XTATbgvW5g/NuZYWXXIkgZE8kaqEu2bM+snS/A1SV8YaSRozSurr2
 9s6lVD6v
 3cY6U3HSlGDN3RtWsIyCrLl0naAugKAKAv/SP4LkknZLsr63jymcHJcCx5J+i0+qgJ2+zTg7r1gbkzS12UsQrcFOBJ9zzmm09sRoHwAellolzs2GXRBsjUKsAUQax1jRD3oy1/m5XInq/xvYNp0eDt9i6LnLs01dCgpg/qztja5d4NaIvIsRUAXjsHqi3SmPAOsIizq485muNbofdzchEBIud+lIzSsDtn3mivsJ+TYXuw03eQjZju/NuA5vEIz+UtB7oYkJ9L8bykfo2PXdAotgszH+V6qqbnqNMWtWnlxRUFVqYa3pcTUNYBH7y7m8tfUrLF/MiOe1pvbjMhfvWOo8uIRJJJsibrwK4SsB1L13lxzu2d5mb8MRhUOvrZ64/Ue4v4dFsAYFnd3Q3FpzWbZyXd67i2Gh9ofDtiIgLZSlLwXo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Sep 9, 2026 at 10:27 AM EDT, David Hildenbrand (Arm) wrote:
> On 9/8/26 04:56, Zi Yan wrote:
>> PG_private is going to be deleted. Adjust related comments to refer to
>> page/folio->private instead.
>
> Thinking again, I think this is misleading.
>
> PG_private is defectively already unused for all of these cases, no? In t=
hat

Right.

> case it's rather a documentation fix. (could some of that go into patches=
 that
> convert away from PagePrivate, like in the previous patch?)

Will rephase the message and fold comments in previous patches if
possible.



--=20
Best Regards,
Yan, Zi


