Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56814C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 15:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D5ED6B0088; Fri, 10 Jul 2026 11:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ACF56B008A; Fri, 10 Jul 2026 11:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C3E6B008C; Fri, 10 Jul 2026 11:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE7696B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:57:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 640211C8B41
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:57:07 +0000 (UTC)
X-FDA: 84973320894.07.E814508
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010021.outbound.protection.outlook.com [52.101.56.21])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9BB38140009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:57:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oCEGTR0o;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783699024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+M+XW/bJHe70lF9n1y1uylPMnLmlmjGE42oK3IJAnVM=;
	b=LgOYTxNFTT3wHxCPMpauLQ1tb1RstDdkJq7e2o37I1IqR3IoZWP8+dC6zYFSxnHE1uvKoc
	VL3WYVoswGhZyT09EAsJK5zLbdGrkuVh20it5kf8mf9UOl9A3iz64+q7qYONdy22sJHx8S
	MsBToQtyri8arupIQGtyq/f/En2OUdk=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oCEGTR0o;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783699024;
	b=B8Zptqnkl6rAIiGUg6uTvGq73afjyeBhOHnJjIHn+6UVlkcKEWJtHPiWdFq9w2Y/9/Ny0g
	Pz7rW5mPaKvbwDhkM84EbOAqmwSGFOx10YyCq9kPXZgw5XjAHUbcQn1et3yLv6RJ3DB60m
	DHdfp42ylypRGBM0O6O4fIHcKy9Laiw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fsXEUuCW7QjQOK4nmGJu/rdnA1L8dwZ94RafN9yU4k3HuUi0ipAx6Uqx6NTwqpSW1rxo1UlBmHFBF2j3xLD+NITTpUNFG6oxWhqZVvCQEdPdZFE+0zCNi9qvgx+HdpS8CJfk6wFXJk4h5qjfRRyWOss0Vkfax2UJOuQSCzssNFlUkqRkaACl9Lo/Nf3dVnpwoWbp/UXU5MJb2MPholZamCJGUBYr62ErHHN6zl31aFgSEz7LoletF0GzGt5Zrwozlk7aPerj4OCXjt4SkfFbCHIHuqOIJ7TuUWG6al2Mq4wz+IEInL6iIYUOKGuiQKKm7cV3DA0J2cas8Ee6S/jkdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+M+XW/bJHe70lF9n1y1uylPMnLmlmjGE42oK3IJAnVM=;
 b=YGvj5YxTxNL+hPSeGjtdg9vrzh3a9bA9DLmfo1ge53r7cZlHDEroGddMLZwikuCTdtVC0ka0wT9/LNPKDSBn5a8q8jlYvt1Vl/4bBB2m1MgX4zPCaw6F3deHI+TbIbYmRBrCaQGKRJVHHN4I7FMqL2QPStavx/+WS9Tb+LX/u89waU4oSGaw6NHV3l+ZEx2/wqF7KTk8tQv7uJweJqZ1nEJfoLPjQcjMyw8e5hneIzKe29Nxji2hmaW1x3CiREGproivxv+cBhzUb1+GM2owzy6F1wn0HdfYmWzeUo6WHKwrDvAM+0LcPfvr9ge1dfBrfZwvg81T07TViRteJMF5FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+M+XW/bJHe70lF9n1y1uylPMnLmlmjGE42oK3IJAnVM=;
 b=oCEGTR0oCNycBc5uNzvkrqfQfMrlNDe592qPYsizwirjXp2tX74yZacz0TbhFgtLQoJZhuvDH2bb8FmegqJcx9tGK5kOSHIVr4rGEJTpBjV1plPjl1paV0Zh5XaaBq4ULNxwg9Lc5wX6CP6GVP5p/0HjYNtE7IpfIrArJjGZgmeWj9gMjEcezJhEAaZiA+6xc2H5dv/sEd7XXOb82WuZeDsnPTFVDmIzU9szlBMPJRSjHiC4VVmfCP6H4exY3/s4LRTJA7g8j678lgqZxUi8pGsrnaDUmqEko8ENHl+IkX6FL/NtDfF7YqYXMtqDCNUdHZJ5eYz1S1/ncJg344feuQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA5PR12MB999300.namprd12.prod.outlook.com (2603:10b6:208:608::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.17; Fri, 10 Jul
 2026 15:56:57 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.016; Fri, 10 Jul 2026
 15:56:57 +0000
From: Zi Yan <ziy@nvidia.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 9/9] mm/page_owner: use memcg_data snapshot instead of
 PageMemcgKmem() to avoid TOCTOU VM_BUG_ON
Date: Fri, 10 Jul 2026 11:56:55 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <622D6E1C-6E27-4912-A1A8-E5110A4581BB@nvidia.com>
In-Reply-To: <4d8e0125-0630-4070-95cd-acec3d626329@linux.dev>
References: <20260701061101.344679-1-ye.liu@linux.dev>
 <20260701061101.344679-10-ye.liu@linux.dev>
 <0E890CCC-818A-47DE-9D1C-9EEF98CC758D@nvidia.com>
 <4d8e0125-0630-4070-95cd-acec3d626329@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0437.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::22) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA5PR12MB999300:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b4957b5-3f1e-4360-0d4b-08dede9bde83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9j+aIxuVj+LI5QYl5fsNT+1YpbKjwSdH3Ut5AG26FkcC8G+Nz3C1F5Lj1aePd2qG+vT0jtZX5DC3elfBDO+tmuH5k0I8UBSXxWKIpL2kI3bRAlAik4lb/fbszDRQ+LOcqxdScEGjzqKEALpgeXRHAeVUdfVkvMUCQDR9qCT0ib+kLRlMRTqZSJ8kkL2aDQVGmPZwYXpb/Ih1ffG+VDTacPydc2M899GQkipApI3xPxZz6B5ZPOUixZMspGbBaBD70dQjmDg8g87j57AtWENc4JcZY7ot/IvydeSIxgpfq3MxJEicbGiKvlJ83obiU3l/PFkLDgrDlhY2hvL71wIfzGHsu5TWia1AJsii1wCs9co+ynRPwgj4+fLhmO7yAaxQrXZ1LueCdfZuz63V0HoBtKvfYRoZqsyrudIZfmG1EyNsUHJ9vpKU94ACMwGwge456Jc9lofkDa5QxAusTPujaX6XksHd2xm0Xi8yiNATKzY3d1VxOdW0ecDA69LX7OVxQKlU0R+OoLhjrLWlBx0sPUnYrxH1HRHb4GZ9H41+9z/YbHPysUb3Q52KpWbehUc6gC/Wj6vFbubZ4vHAiHeOqEZfzL1h8hqXBaAe8L7PyFZfvyoKQH6Ze574m0iPfW3OBgXBM0lXO7bVvpNHNppuzo1A34hsc6MWqYoddpEQLnY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dEU4NUlFNXliNXBveDZkU0ttNEd6Q3l1Zld3N01pQmg0ZVBvcm1ibW83ZitM?=
 =?utf-8?B?QWs3cllzOUJCcTlIOW1KOEZPYzRnUzFMaGpqV3lpOUFIOTJCUjZpcmk4bm5I?=
 =?utf-8?B?VjVONHgxcVM5UTdLWjkvckd4YnpKMGZMeThWc1lNVUV2bEJIbnRndXBCS09z?=
 =?utf-8?B?RHBiYTZWUEFuaWlYNjFtOVRGQ2JCZXErZGpzdUpUMHNodWhUVW1aUDdiTXFL?=
 =?utf-8?B?OEJmVEhDT2J3QWRFdEl1VFpWbVlCUy90LzJFT2w1cTVHbVFKZks1QjFmZnll?=
 =?utf-8?B?c3FaaUZOOWF6SWVOeDZKd0RIS29hQUs3Yjd0aTUzc2NxVjhhNStPcTJuc0ov?=
 =?utf-8?B?cEtFRHdiVzdhZmZMaEppbXlQM3F2WThzcTAxY1hUc3FmZU83ajgyejhVR2d6?=
 =?utf-8?B?TWRUcEllWmVPaldZUStHanhiTWNGYzNIaWVsNE4xcmRya1ROTG11NktEZkpl?=
 =?utf-8?B?WVg3bThKbXFKMU81TmlRZ2sxUjg2ZUlpSFk1dy9vaHloeXVGNDhEb2k1M3pN?=
 =?utf-8?B?L2tCZFpCVFgvQWFJb1lvRGtaR0Z6Qk5iRUJ5Mks0cmFVVzZNcTg2cGJLWlcx?=
 =?utf-8?B?TXZKNkZsdndjM3hEbnB1L2RDdlI3Wm9WOEdVQmxIRitZT2tVcWVCK0NaR29r?=
 =?utf-8?B?ZnBxTnZFV0VGT2VnSzUvNm9aUGxTcEN0NmxsOFNhVGNDZ1FTREU2YzVtVnE3?=
 =?utf-8?B?R0M5alFqbEJEVlFoOEdmSjI0YWZ5NlZZS0crOTNzRCtORXJ1akFnajJqSjFa?=
 =?utf-8?B?VTI2Zk1oWExZZG9nd1k2VFR5SjVoWm16UDdwa1JSQkZXWkYva2FVb29hZEZi?=
 =?utf-8?B?VzQ3QWRYQ1JlWnVYNlFVbTA2d2s1VUtidHBEMFpyZXJ4blRHcDYyeWNQL1VX?=
 =?utf-8?B?ZFl6YzRlR0FGUHZaZFZvOTRIZkkwVXY1ZDNDTGdVUm02Umc3SjNOTkxkTWU1?=
 =?utf-8?B?TVZrdXRBV3VlVzdTYS9oS1ZwblJQdUxGS0pneWxiczJ1VG1ueVVKdUorS3h6?=
 =?utf-8?B?c3N4RnNta1JJcFdMS1hoYnFHSkdEdGl1bXRhVGE3T1FrOG5mb3lINE1yeXlo?=
 =?utf-8?B?RDlKYWswbGlzcmYwamRmcFl6NW8valNEdUYvYUg2Y0FidTlUR2NPeFpsNjVk?=
 =?utf-8?B?NURYWUViR2h4VjJzcy9zb0dvOGNSZW1lNTlTemZadnZ1cnhQQUVjenJ0YW5s?=
 =?utf-8?B?UnhHTG9NYkhJWFdFZzliL0F5eXovSDMxY3Q1ajBVcERDeXpVQXQrckJqVi9H?=
 =?utf-8?B?RVBxNkc3UGh5RkNHVDA3ZkVTYlhvMnFkZHdFaWQvU0V6ejZrZENXSE8xVjhL?=
 =?utf-8?B?WjF2SkdpSGd0QVdkUmUrZEkzNFF0cnlnWnQxaXdjRnlZTUhuaVJXclREWjdT?=
 =?utf-8?B?bmJETm9ZcXVxb3poMGo3K090L3docXphWnRJdUpXZzVJanB4Q0tQTEF5WnFk?=
 =?utf-8?B?R1VWWm4xQlp4Y0x5Mi9WUjRvNDVyUUd0ai8zNnhoakM1KytzQk5wOEpZbVBV?=
 =?utf-8?B?Z003SU9XVXNJUTlsYzhCR2lac04ybmF3S0UwL0k2VmhONXNQTjlsb2ZKczR6?=
 =?utf-8?B?R2x6dTlKZW5ZSHNwdVZ0WUtzajV6WGxMMkxWaERIOHlKTGtId0xuaVJyUFo1?=
 =?utf-8?B?UlMwSlI5Z3ZTWDQxNW5BRnFDak1wYW9FR21NOVRUTm5YZDJxaG9MUWNNblVX?=
 =?utf-8?B?b2NPU1NwZmJlN3JYTjA5ZFJ4ak5LSlIvbmtkSXk1NWNPUVBlZTdFS0Mzc3pV?=
 =?utf-8?B?RmVLQ3lrZURDVzdOQlEyWGZQaFFFRVZheld2c0xBZnVUYmNGa1N5bjlQbXR3?=
 =?utf-8?B?QldTVTJXd2FSbmlDckVJM3NSamU1RnFUUlBzYzkvWWlUL0FTU2NtQkUrOFlE?=
 =?utf-8?B?ejVjNkp2UXB0clBlb09GNG12REwraUpXWmZnY3l1Wmd5N2hNR216MzFITmI1?=
 =?utf-8?B?enZJdmdmNEJ3R2NkTHJvc2lxMitUWWFaaE5WRUxxaGhqRUg5U05Vb3JNaXlB?=
 =?utf-8?B?ZjR6alpFSzlURXZGVlZmYzVwbktxN0NzQ3FTUjJhY2psYkE5Q3FLNFhnb0d4?=
 =?utf-8?B?MUhWZU5BRVlleEpyYk0raDVwMkFLUHU5Z1JqSlRLWkdpa2V0Wm1SdkRhdU5R?=
 =?utf-8?B?K3o3RHl3MW80c0lZUTZJRE9KWnVreGtXZjM4dEZNYmMzREhIaWpFbFdyQVVi?=
 =?utf-8?B?NzlvRzlIa1lVWHh3MFo2UUJ6Yko4L0Z4d2I4akZEWWFWNkd6VmJVY1pSRmxx?=
 =?utf-8?B?Zm5HMkQzNmk4a3NFSlhsYWUwNUpCVTBrWlUvK1RraUoyMlJjQUVSbXdUUEk3?=
 =?utf-8?B?SGoxREVoNmdWZFFub2FkWjhEVU9Id1ZUbTB6Y0lUN0p4RXQxWVIxUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b4957b5-3f1e-4360-0d4b-08dede9bde83
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 15:56:57.0031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iqfumls6QyIuSDFVbUfYO94a8cVtHTqF/+NyOETHjG+HxCkruHKlMkkDHc7GZi4N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA5PR12MB999300
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9BB38140009
X-Stat-Signature: 8mm9jhcthzq6opx1aifdd44mohch9r7u
X-HE-Tag: 1783699024-119315
X-HE-Meta: U2FsdGVkX1+ofSrT1kcuS73kBQxhFNyJlKKeQX4mAwqkYZbwyoCmEM4MsipZIoTdOzYpQLRInfFreEz359My4qDjpsSisBZbVNDk7gS1T3dUO7pfEPai/BZ20yYpZjsh9NOp9YqF1OfHY1CBw/3nCILM8Wa0dseV+kyM0blfPOuq4llbPznmpjJTjq483WSlLPdxAIKJGB2ljNx2YjHPXMBse6bLjn8gczBQzl8278RF7dNmIfpwD4Cs5tpuDaYwasd87YxDfMVClsVLAfegtaceRLXtA6pCLg3g3fB61kKFUpGXFxJWBAI2v7OmDDgAe0ll49m/wuyVwL8yYHQFtHpbqv34yn1D61uTVSFxAkdpRiOhW8/5NCOv+aaQR6QrUKVJ5o1rejyEH1y9ShE+pXynV6AgKhSys/wOqa+UCbLHOAylK2rzqtB5hlXPXi3mIzWA0i4SbhnecS/1FMjI/Sd+cVy9V5URi53hhJvnXbWWphMT0damMdjylD/QKkljIyobWd/iPJXwFAKayyQPsyP4F7tJvUlV3r2M1MNd8AHTDPw9EtBOIFg5toRSbyFfT7q+GmYnws5GbsKPg8yy5bkGh2i/KWQMEY0DxxrJyy/MfgHFpPIS2i824OJG702zq0UKTZC5uXqct1sIIGUz3ysFFuGKRRQpz9ilKW/C7h+C+KnXKI0qYbq1r/3skwEyLvHMReAY04ywRe2YdmCWLF+nhDCsgiyS9fv+USHNBnZwcfCtkMvHpLU4CccFktwE1qjsVrnEMAzNVDHu6UOn+cKFtM9P1vk+4rnjvT3RKATFYehG1mAwSMzjhRTvBayblFbhwgZy+F0/qgZCKJqPLoEQhulGkZsamYsfIaY9UBqp5iUS8VuhF7lBbsvFnksC9fC2dz/cNWNIkxcEbIGswS3u5MaGyamDL1EYjW6D/9guPoTlWICKOXgl9drLvTADBTWIYvK5U/H8B+2+IlH
 CDLVA6Y0
 DpImNuV4BltCMuOzf7vL5gn1/PHMgZ0TM/AgeK9nTDIn0PA/K6uooR+i38N0IVG5E4xDCgEpwun7QxtacNOeQgUpbQFfHeR2DUTIjEr3a1naPz5C3ZaiZy4epwrfxaWDZdkR+mL0TwDgwspDVcFJtuX+PRh/sAqIrsVnwYyEqHWR+oik59djzhuUXahbUQCg5BADlf8MKQ1ym22/07/149OykpJp32f9lz/Y3Iz9MBw7Nw7tf7FMdnCIebYeYhfCEPSumvgfccWxbQoim1RQdTJaaqC0duZ+4jU1JduFW4jt2SX2bkODTJzOP8mw0/NI6YAz0s9q/eyD+W8aWUjWJnEqUlnQJN8Au7McmsCkOq4nPhTyqOPrr7NEcs7b8j+Foiqz3PyIQBlGlpeWRmHIT+O2+iDxkXbhodHUcNEF/zalCUhMGtv0XLb3cYNJ8Cczamx6geSYf5bHdZANRwgd+OIMbP8iJVcVRjbX4LGRpTI9r5a/LwmfxbuYG7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Jul 2026, at 2:51, Ye Liu wrote:

> =E5=9C=A8 2026/7/2 10:02, Zi Yan =E5=86=99=E9=81=93:
>> On 1 Jul 2026, at 2:10, Ye Liu wrote:
>>
>>> print_page_owner_memcg() takes a snapshot of page->memcg_data via
>>> READ_ONCE at the top of the function and guards against tail pages
>>> and NULL memcg_data.  However, at the end it calls PageMemcgKmem(page)
>>> which internally calls folio_memcg_kmem() =E2=80=94 and that function r=
e-reads
>>> folio->memcg_data and page->compound_head locklessly, wrapping both
>>> in VM_BUG_ON assertions:
>>>
>>>     VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
>>>     VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);
>>>
>>> If the page is concurrently freed and reallocated as a THP tail page
>>> or a slab page between the initial guards and this final call, the
>>> VM_BUG_ON assertions can fire on debug builds (CONFIG_DEBUG_VM=3Dy),
>>> causing a kernel panic.
>>>
>>> Fix by reusing the memcg_data snapshot already taken at function entry
>>> instead of calling PageMemcgKmem(), which is semantically equivalent:
>>> PageMemcgKmem()->folio_memcg_kmem()->folio->memcg_data & MEMCG_DATA_KME=
M.
>>> This avoids both the TOCTOU window and the assertions entirely.
>>>
>>> Signed-off-by: Ye Liu <ye.liu@linux.dev>
>>> ---
>>>  mm/page_owner.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>> LGTM.
>>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>Hi,Zi,Vlastimil
>
> This patch still has warnings (see sashiko link[1]).
> I've made the following modifications, or do you have any better suggesti=
ons?

Maybe use snapshot_page() from mm/debug.c, so that you do not need to repli=
cate
the code from folio_memcg_check(). You probably still need the rcu_read_loc=
k()
when reading memcg_data from the snapshot to prevent memcg going away.

>
> [1]:https://sashiko.dev/#/patchset/20260701061101.344679-1-ye.liu@linux.d=
ev
>
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 2e3880053a34..e18512a49e38 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -540,6 +540,7 @@ static inline int print_page_owner_memcg(char *kbuf, =
size_t count, int ret,
>                                          struct page *page)
>  {
>         unsigned long memcg_data;
> +       struct obj_cgroup *objcg;
>         struct mem_cgroup *memcg;
>         bool online;
>         char name[80];
> @@ -549,11 +550,14 @@ static inline int print_page_owner_memcg(char *kbuf=
, size_t count, int ret,
>         if (!memcg_data || PageTail(page))
>                 goto out_unlock;
>
> -       if (memcg_data & MEMCG_DATA_OBJEXTS)
> +       if (memcg_data & MEMCG_DATA_OBJEXTS) {
>                 ret +=3D scnprintf(kbuf + ret, count - ret,
>                                 "Slab cache page\n");
> +               goto out_unlock;
> +       }
>
> -       memcg =3D page_memcg_check(page);
> +       objcg =3D (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
> +       memcg =3D objcg ? obj_cgroup_memcg(objcg) : NULL;
>         if (!memcg)
>                 goto out_unlock;
>
> @@ -561,7 +565,7 @@ static inline int print_page_owner_memcg(char *kbuf, =
size_t count, int ret,
>         cgroup_name(memcg->css.cgroup, name, sizeof(name));
>         ret +=3D scnprintf(kbuf + ret, count - ret,
>                         "Charged %sto %smemcg %s\n",
> -                       PageMemcgKmem(page) ? "(via objcg) " : "",
> +                       (memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " :=
 "",
>                         online ? "" : "offline ",
>                         name);
>  out_unlock:
>
>>
>> Best Regards,
>> Yan, Zi
>
> --=20
> Thanks,
> Ye Liu


Best Regards,
Yan, Zi

