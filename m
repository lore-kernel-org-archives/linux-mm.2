Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C88E3C88E75
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 02:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14F36B0092; Tue, 15 Sep 2026 22:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7256B0093; Tue, 15 Sep 2026 22:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E5C6B0095; Tue, 15 Sep 2026 22:20:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BFCE6B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:20:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E83A91405DD
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:20:51 +0000 (UTC)
X-FDA: 85218022302.23.EEC3219
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011035.outbound.protection.outlook.com [52.101.52.35])
	by imf31.hostedemail.com (Postfix) with ESMTP id 27DD120007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:20:49 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U5AI83LA;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789525249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8iSbxoSYJSXL5nZj8aASWmVAQ7Z2qhna9/vGbeVxCvs=;
	b=QI9JwFzSi1+ndSEGwvj++IcIWViaMMVRHqGW4G33WNY+5801mVHjaDR7ofsCT2ptTFzyAg
	aK2yMEdXz2Xk7yQVP8PHMQV28qBoQxkTVs6hxakVURpWDV8BEPbUCH+GKGxfOogX+4tziz
	rpgoaF+dFJ7/R3x5ol/8le3RJy8maEk=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U5AI83LA;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789525249;
	b=HeckOQaDD2YZCbiXtlEi1HIJDSUdqKC1CzDIqF5tbBH9fXUpBPgqM7YJ54Oy0a5ltIJyv4
	ZTISVmAN/fs8L4Tm5brriwEfqSI7c3k1lE0+TPYm6aSoewvwweVLMvMJgU16d2cJZUiMJv
	TFBO5+a+B/hF7kw7CIYrVLTqoRiTYtM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t4k0+1BaewR3zk0Y07/I7iPNFf9aapJK9QUB2R3h354Hnu/cQU0xRDl+Lx7h7peu+KnbAYszccpfAEk8j7mKy+Fa95eW5pH8iSC0GBBjMhmsoXiTmhHbSDteS4IMhabpkGog+EM5sFZwYvn4Yd8nKxNQHoASrK10GKunaXwgPSF3ZqI2AxbLOgK/WGbNn9AIBpW91S/AZJ4cvy+R2eP/Y/hLZQ1/3rPunuijdO6BSg0gKW9mVxVgzMQNdzmgiiGMc3rMrQedZpEzVV777Mf8xd//NhftDeQ5j1h0+Y3Pgdwpca1CoggsoP0+idBviNwk6fBySlZKDLlEOC+/1vLoMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8iSbxoSYJSXL5nZj8aASWmVAQ7Z2qhna9/vGbeVxCvs=;
 b=OQW45YdTYmXXUCchvSfP2fI5cEatb2PQaeGU1Ug/XlnblBbU3YFOL3SHU3jqz86uGTtwoPN91Gg62eqLxI5MybVX9ectmJCSbSg0qteqZJcrwqNEs9rSpw5U7S3s+uyoIKUa4l6fGeRVZ6nrfv1xQ2HbziHjiM2o2n6CwDgeaE8x4o8cx+OBauS0pDVO5MtT8Rxw0/Bycp7wqyQS+npdesjgxCObKAzZ9InOqNhVyVnrKx2J8zqZ9VCqjqN2uRe7aC2aL+GLmnkmYmvRI6iaXNpeAz00GO+C6tiaAblsiSiYQwB6CkGICGvzAQI29Ymitls+pqSYRJ9q/yU9cdnalw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8iSbxoSYJSXL5nZj8aASWmVAQ7Z2qhna9/vGbeVxCvs=;
 b=U5AI83LAlbKHxtWx+Rjsc4/Ku7WIUEMR5Tlbcbw87noNKwgj2NJjBpixnZuV51MYY94Xhs/WYp4irts4USzZjCZIP8PDY0TxvMAyQ7d/pr6s0cwULau9ilTahDYE7DmVbzdbLwZU1sxI84eDYAk+3KlV9wXImpaGCmstPgUkVTVAytAEdLLP2hhZnLcB2+l1XFeJ8ebDGHmJkW5KgmdR94OWnHEYxADTEOLL7kBq7mo8Vo7Zw5s9+JKhm+5B9wtO7LVZsgNl5b5zsouv3N4CuTyH5DsJJvCMqO7RCFQnbhDCLel3KRIEs5DDPeSj7EUEpo6cUWQSKI/sehh1tIKU6A==
Received: from DS7PR12MB8371.namprd12.prod.outlook.com (2603:10b6:8:e9::18) by
 DM4PR12MB6469.namprd12.prod.outlook.com (2603:10b6:8:b6::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.9; Wed, 16 Sep 2026 02:20:41 +0000
Received: from DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a]) by DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a%3]) with mapi id 15.21.0406.007; Wed, 16 Sep 2026
 02:20:41 +0000
From: Zi Yan <ziy@nvidia.com>
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
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 Zi Yan <ziy@nvidia.com>, Tal Zussman <tz2294@columbia.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: [PATCH v4 07/16] f2fs: convert the ->private flag helpers to
 folio-only
Date: Tue, 15 Sep 2026 22:20:40 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <2DF8A821-30B4-42E7-80CB-E7B1CCF37930@nvidia.com>
In-Reply-To: <20260913-remove-pg_private-v4-7-848550f7574e@nvidia.com>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260913-remove-pg_private-v4-7-848550f7574e@nvidia.com>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1P221CA0044.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::16) To DS7PR12MB8371.namprd12.prod.outlook.com
 (2603:10b6:8:e9::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB8371:EE_|DM4PR12MB6469:EE_
X-MS-Office365-Filtering-Correlation-Id: cb8daeed-958f-4966-f8dd-08df13991afc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|10067099003|11063799006|56012099006|4143699003|6133799003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	QYRfbFunuMKc6OgRWk7A7SGyQlpS4VvyfjNgXFX7TTTulAEDHp0NelRCSdTOxc4SD5aoPhFODl2Bp9qnLGrun+eGRURPRjuwZ0PNaPYchHenMOoqeZKVW9cvfm+gcsgp8sbcFq7w9BsRV5FBqaSqRQAAACaGv8w3ihv+7//Wkfika3/dBtz2HL7Yml/jh5HhIOLZrrsmNXJH1MxI+w4uyw7fjyYhPFIVAEYTsJPrA9mEc2imr/zbRR3IukCekX0PWqt4CyUqTlFRthhwW6f7SSmg9xoJxMfhS3fSMasR6LXl8KqmSyxoUhcrZ50ey1mFC+qCqHks7kZm+c7IwaWK5h+hpJ1b17ono+SKE6z07jZDw8ODR5mgdVMvjKJi0vjzJMBt9E2JrdBsm54Wbj1b1XInCb1A6QR597eVOIPlIrFG+BpciczlDASNiBBRRLHYcNiahqeY8GB+GJBZkmj95uPRF5pbPo5v75fihaFfR1XB0fpe2SB9ZhWfK8haEHTzR20+ekdMTIhzcRfdRuWxrZ3mdu+dv9z+IoJOrygPbwceYQjkqJ8fGw4lFwCcD5fl/znrQih0uwyOBl6PzbiJEbDTtkv54u328/KFlQoWQ3sQEeUxyq/1/xNaNAvZDQo1o5808db+5dU2ooFO3x7nk8clzK08ZzUD8vTNv5dGhT1CpJnF45KlPIXjHUECiMdYLpvx0bBN93Ts15I7A65xxg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB8371.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(10067099003)(11063799006)(56012099006)(4143699003)(6133799003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YLuMJf/A8OEh5d+CUtxMSwpdUybMHDapFaYTgz+QGrYevvgXRlW4r6x/2Ndk?=
 =?us-ascii?Q?81Pa0AHx4nUiBl0uRvb1w49ytAHXEl/U1Km2E+fT5LHShMlNTGbhVdv9vhTE?=
 =?us-ascii?Q?T4gQjfSAsegDSU3jQMbwlLea2HIN6VZhq+qe9BLYbPt6Bs270GXT9n3v6LC0?=
 =?us-ascii?Q?oa/+0gne/N28n0cmNksSN6stlLv8oppbo6VCk11MR0rGZ0HCFDkQcKFzJ7B5?=
 =?us-ascii?Q?gSTXJq23Tn8ey7dl/HIyEBxIeePj+r6gOlow2RGesvBxc4N9c1uY2CC4lMST?=
 =?us-ascii?Q?hOlLgrLu1VD646nrpDsIS7Q6pU1o8tBECF+kUNt4o7LeQMn35LWxVPDXGKbq?=
 =?us-ascii?Q?DYxpRlYoRypVTvyjWZET+TVNPyQlUCVY0abmGVMwBPvwPqzgW4c2GwZl4SvF?=
 =?us-ascii?Q?esrDLbj7Wf029qo6I7/clBcKPb/zmBcP5cFZ73vYkuzJPbzPJN+kQ8oQHidC?=
 =?us-ascii?Q?3lH748IuCwMyLu/q/X68+1H9Mj0WBQymtPsKAl1LMexwdzPRm4szrOvI07uD?=
 =?us-ascii?Q?eHkQQ9ETdsWQwaECTKoKxAlyrNn+E+UXibycb8i42m6O3DORW45X5sQt1Q8Y?=
 =?us-ascii?Q?SNfctHSMtKdkUU9LonVBBmlWe+/q7TzjUsaoNFWYTGioDu6nKTzBeY4acImL?=
 =?us-ascii?Q?h2tPZcQ/tZexHLGjkSEBLHAa76mvkgmQOjKpOwj8/6rnpdO73ofAs7DmekJ7?=
 =?us-ascii?Q?McIl+QQPtCbosCnZkyPdnH8DKVsqYNkV8QEPGiSWVMo5DH2Oq5zKrAsyfFe/?=
 =?us-ascii?Q?8zYtSI8OWcJLDqk1hhodjzAmhNHvg5aB9D2jDmwAd9g7kAEOai5VoIDr3rns?=
 =?us-ascii?Q?rSXSiwCGeIcwEEFUpmngyuZF8Bb8TlXDvhNuSvWAJfxdwYabzuP00lveuip5?=
 =?us-ascii?Q?bFTFfmvxMuzuuUvw+ufSsakmx+O9gbYp+qWVyIqkzE3dtELFZTJot3JbTgEt?=
 =?us-ascii?Q?3vwfJfvoFdQcCMP2qZhXQHnc+eIPxMWwqBWgZgRivtprCCDAC4BBMKvWTn+g?=
 =?us-ascii?Q?ZafKyX9yB/gAlMMMLxiDxGWIgJHXIKcN1JOpTQ4t+c0pn9gxhLwOH4YwBBRU?=
 =?us-ascii?Q?n+HLJW1FZ6HpI/sRsnqnQrzdwYlxyoVp6Hs0I90WXGgDSN/LBaBOBExnef62?=
 =?us-ascii?Q?3rcjdQ1OrqvQrR4eEw0/w323QG+v2xGmW4kHe9ZLeGr51DFV9VzrQbkvhCtD?=
 =?us-ascii?Q?OYziwxzoUEx6sOv64y5EKlRDy4b2MeHrRfwxqFphL5lsJmKSX0bs3aqbnVJr?=
 =?us-ascii?Q?qKEz51N8d39ETcvVnOIiQWSbstiiGQkiov7JdGmmx+x9DEF+UV+t4cDh00tB?=
 =?us-ascii?Q?ehW/M+RQxUKkZYoBCywrs8AMSuMyOSNhiNaOtFDLnCjpMwOambU21u6lIxuS?=
 =?us-ascii?Q?35NxqpfCtGamFv67HuBvC3zrP8C2IH4q/4Qy7pP/2m0cXyyQfRA5nwPr5l6p?=
 =?us-ascii?Q?xn99I0e64vPYG3pDJAOMGCt7sSCgKEh4IoTXKxbfIzm5b+HdnFstPh2bkVjd?=
 =?us-ascii?Q?Ajg/Pb2o2xIhmGVDsdkI970mxTjCj8CMzm3Zw9XBkN2C2ESbg5GWLL9MZg3n?=
 =?us-ascii?Q?PKko/fAlmriMEkj34w0NueswMGwew3d1PIK7KkbaSxahL3gxaD4hoy9yLeoK?=
 =?us-ascii?Q?TcMjGyeZZvaYUzy1oC4d3oL5ch8zbPV2GHp38Ihvk+4ru72Hu0MveG+UArRo?=
 =?us-ascii?Q?J5SPDRYaf0Ll1bTQoe/Rleo3TEB8KK6jysTlQhIjgbiRRVjz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb8daeed-958f-4966-f8dd-08df13991afc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB8371.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 02:20:41.5782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /p8VU1vzRI3Dm5zw63J2+kfML9Tkg/TLzwxagLY6SHGKrmNhjFcuBKV4kXvZ3Rgd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6469
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 27DD120007
X-Stat-Signature: wxmyn6jh3ck6z3snuztzetwcj7bkooxw
X-Rspam-User: 
X-HE-Tag: 1789525249-758151
X-HE-Meta: U2FsdGVkX1+78AwzouGYGk3tafv6EcNFlNRGlyOpIDviI2PNygFS6JcViKu4MF5WHiAA2lec5lWtvJo+5OAjVAMF6GOPGA0CV8Rn3Z3d0b4Nxu757eHZmhAOI1i0wKKlLBfzagGMowwUQuFwnTvSF9497cUC1QLHLi4Gn4tLMOHRPRxRMUA2zOs0/ttIkwOujyDpymXpLt85piRGKZLrBuQE6EpGvVPZkz3MoWWF2nN84czcB0Xq+woHnktHgbFRBrTtYvTuqTfmIDyeug3ysbBQ4pEsUSbX3BE547Tu6v2hNJ6il+qZbn7Qw0vtLaGwZtCGd8LaHDXnP83NaOENh+4TalnOjOskYObkv5SpjP5uCXBQMoffYUycE5qI0y7DhRdHYYLpnLaD/w9Nd3zfcAgWhAQjR3SYLp4Ghjes3oaUk8cJTfPF8JsexHAzHObSxxc8iWZGGU0T5Z7RSrnuKIE070RFBcBVdpuG+EGDj8BVtxW9t9quRbZcrxfsvmnnY0jtqxsMcGHqU3a2ZoqxJbxxwH+ncLsSVrrDvwspys5B5FjFRC+19G8HgWxQsPwmF3nhTX75rElc+99RyMRkFyeZgre41v2p7RbtWefbsLfc0slewwBwbbdFP/T1igtf9s6AoJWeHqLLTA28akg/nbk8om41ybLiBy8g/riq0a7LLPNdfgXup8aqLUoVZ+wp+zpF7hMjiItT7Zvtl6xDBtGBCf8q4ueSf02KWR0pAJ2dOBr3e6ntnyJW13GavoV4fhPYyAIpZPoaomt6myBcxMe3pjx78JdiZecknpVpJbUBgWvX4zXlIl6JNPqT8L2PsEWQM+/v5GuI+3UtdWN/fSwpPJ2chtZho3RAok6H2LuH2faxv2tlmQMfIYeg0OEleKet6GBiCTbK+HjjgJ6yQJHWNWUiYhxiAU7u2LM9AOmyrTKZTd27IYNDx0Jlv383k6xNNjax8MPXpEsnUML
 B0Ri5n/Z
 OaslMa/OQjhAPv30hYknwe9DhNniPQIKC9Gs26IIclpf074iARLO3J1A9cpGb7BdP7hf8sWHCIkEhYBuXrbgIVSbc17C7OCb9aMSZeMsD2eZf+w9OxoVh/bBTXdcK2tDvesV1gmiHNkUoRxNKR5wWw9hYsgi9GXyxCggkS9hHWfkJCsPBE5saWE2ampjY4bK/4LP2wm4FF/XpgT3ImEu9aKD5e16jJEGIftrT9G/+IW9/FhsaoOKLbMCaUUpeH0HpzdUddSxTnYEWYW5fgGm3jObjNBICxyUrEE7PeUoF3H/1TyaZzMHGLnPIfJylFdXcx9Dh7hNREqyLLemMs2Nh8iKDjO3kSZ2d0HGdnOMDCQTI9eynRoT7tzelg3xaLZDf6zYKhy/I2WjrO7l/uXR46XQtH1TPwU8QKb8dW1k4cMDsABH6DLagbS0WmFUF0gEjrWxLAGMyFpXMfb3NxiT/6gkx4FJXVdCnTwG9gTTp1QauedA4Q/r6pcG3ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Sep 2026, at 22:24, Zi Yan wrote:

> page-based ->private flag helpers are used in the compression path, where
> large folios are not enabled. They can use folio versions with
> page_folio(). The two remaining users in data.c and segment.c can use
> fio->folio instead of fio->page (two are in a union).
>
> Drop page-based helpers after the conversion and rename
> PAGE_PRIVATE_{GET,SET,CLEAR}_FUNC() and the PAGE_PRIVATE_* flags to
> F2FS_FOLIO_PRIVATE_* to match. Convert the folio/page union from
> f2fs_io_info union to folio only, since no page user is left.
>
> The folio helpers do a plain read-modify-write where the page ones used
> set_bit()/clear_bit(). It is fine because the converted code either holds
> folio lock or, in f2fs_compress_write_end_io(), matches what the
> non-compressed code does in f2fs_write_end_bio().
>
> Assisted-by: LLM
> Suggested-by: Tal Zussman <tz2294@columbia.edu>
> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> To: Jaegeuk Kim <jaegeuk@kernel.org>
> To: Chao Yu <chao@kernel.org>
> Cc: linux-f2fs-devel@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Tal Zussman <tz2294@columbia.edu>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  fs/f2fs/compress.c | 35 ++++++++++++-------
>  fs/f2fs/data.c     |  2 +-
>  fs/f2fs/f2fs.h     | 99 +++++++++++++++++++++---------------------------------
>  fs/f2fs/segment.c  |  2 +-
>  4 files changed, 63 insertions(+), 75 deletions(-)
>
> diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
> index ce88092d9ce26..09d9b8d0fdcce 100644
> --- a/fs/f2fs/compress.c
> +++ b/fs/f2fs/compress.c
> @@ -1064,13 +1064,15 @@ static void cancel_cluster_writeback(struct compress_ctx *cc,
>
>  	/* Cancel writeback and stay locked. */
>  	for (i = 0; i < cc->cluster_size; i++) {
> +		struct folio *folio = page_folio(cc->rpages[i]);
> +
>  		if (i < submitted) {
>  			inode_inc_dirty_pages(cc->inode);
> -			lock_page(cc->rpages[i]);
> +			folio_lock(folio);
>  		}
> -		clear_page_private_gcing(cc->rpages[i]);
> -		if (folio_test_writeback(page_folio(cc->rpages[i])))
> -			end_page_writeback(cc->rpages[i]);
> +		folio_clear_f2fs_gcing(folio);
> +		if (folio_test_writeback(folio))
> +			folio_end_writeback(folio);
>  	}
>  }

Sashiko[1] said there is a pre-existing deadlock here. Submitted
pages are unlocked and remain under writeback. If someone else locks
one of such pages and waits for writeback to be completed, like
truncate_inode_pages_range(), they can wait forever, since
cancel_cluster_writeback() can end the writeback only after it locks
the page.

Answer:

Yes. I have submitted a patch[2] for comments.

[1] https://sashiko.dev/#/patchset/73521?part=7
[2] https://lore.kernel.org/all/862E7DC4-14D6-48AE-87C8-11664354718C@nvidia.com/


<snip>

>
> -#define PAGE_PRIVATE_SET_FUNC(name, flagname) \
> +#define F2FS_FOLIO_PRIVATE_SET_FUNC(name, flagname) \
>  static inline void folio_set_f2fs_##name(struct folio *folio)		\
>  {									\
> -	unsigned long v = (1UL << PAGE_PRIVATE_NOT_POINTER) |		\
> -			     (1UL << PAGE_PRIVATE_##flagname);		\
> +	unsigned long v = (1UL << F2FS_FOLIO_PRIVATE_NOT_POINTER) |	\
> +			     (1UL << F2FS_FOLIO_PRIVATE_##flagname);	\
>  	if (!folio->private)						\
>  		folio_attach_private(folio, (void *)v);			\
>  	else {								\
>  		v |= (unsigned long)folio->private;			\
>  		folio->private = (void *)v;				\
>  	}								\
> -}									\

Sashiko also complained that folio version is a non-atomic read-modify-write
sequence, whereas the page version uses atomic bit ops. During IO completion,
f2fs_write_end_bio() executes in softirq context and calls
folio_clear_f2fs_gcing() without holding the folio lock. Concurrently,
a user process dirtying an mmapped F2FS atomic file could trigger
folio_set_f2fs_atomic() in process context. Even though the process holds
the folio lock, the softirq can interrupt the CPU during this non-atomic
assignment sequence. This is racy and can cause a silent drop of ATOMIC_WRITE
flag.

Answer:

The above commit message talked about it. It matches the non-compressed code
path. In addition, atomic-write files cannot be compressed, so
folio_set_f2fs_atomic() never runs on a compressed folio.

Best Regards,
Yan, Zi

