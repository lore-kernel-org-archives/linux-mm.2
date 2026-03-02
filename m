Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1523FE9B35A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 10:42:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E6346B008C; Mon,  2 Mar 2026 05:42:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79A056B0096; Mon,  2 Mar 2026 05:42:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6650D6B0098; Mon,  2 Mar 2026 05:42:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5440C6B008C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 05:42:11 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EB3F25C666
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:42:10 +0000 (UTC)
X-FDA: 84500783220.08.32D6B4B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 710F7180005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:42:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ViYYMtIx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=d39NcNmm;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772448127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YwptCnliuj6dA/CPebYzq1mAz9pJLVTZi6GbG+LCjkg=;
	b=ioCICUJLYVROYyTQ6Ty3lSmkz230Cwge/ry26kaGNeNGXOORMKdzzZrZonLV+Mp+pqKjB5
	IYQdvxK4AXomEmc5W3GOAcGicKatJcqJWywA/SaDai8GGdE2ei23kJmISzqb305vFj2X7b
	7ah+4MkAspKuABDR9pid19/gwyCD7BY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ViYYMtIx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=d39NcNmm;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772448127; a=rsa-sha256;
	cv=pass;
	b=q4YHdO2dvrjs0pXDUAqYYlPK0M632ekY2nZ/KCnp/V2RtaerAq/M/7PF4axY09QHmXgh2B
	aFG5pBua4znM7XIuCChKcFn70zGG7BoQAdztgxyUg9aTG6ADAfwzYHSuv3sY1RKUUKMviM
	a/mBNfM8johBNfeS+m5RM56DT1MaPL4=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622Aaj8E1522697;
	Mon, 2 Mar 2026 10:42:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=YwptCnliuj6dA/CPeb
	Yzq1mAz9pJLVTZi6GbG+LCjkg=; b=ViYYMtIxv7yEi1DGHZIEQ6VnMjTKOaOovX
	6BAeATLMp4NDNPxnq8BMF9vix5+wiHMMq1pz1rCslO5CzY3vpr1Dedb6GvlmqXli
	E9iocDQEiAZG8SnCDxvdXq7Tw0btuZFsdPBfm17E7jHRmcOhtSsUuGEg6Wk6M8Yo
	SJ5dPnLwCaZhoqXOrN9fIyafA76zS1vcANe5JJRrUCVMtg+aaIFpL10SV+sfoDRG
	4PPo5nAef97w3Yt5lMzPtbUlxUSZCEB5Kj8Awxm+Pt8aYlZKgku8ly7+j54TKtFv
	Hs+I+grWa3aXA4WH7wC2GuDZQOvNWxvoXvwrYxyRUGJWyApyK7Jg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cn8xs808k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 10:42:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622A1tH3029671;
	Mon, 2 Mar 2026 10:42:02 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011027.outbound.protection.outlook.com [52.101.62.27])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt8s5px-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 10:42:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TiI5mCIyZAjubj6VvShyCpeqdhL60v54qZxTdHMiipFHsXmiEt/sWtlfrNZS5m3o8uoU8JQJpsuKbqAyrcfH5TyrEAIdVgAkLSzcjW8DQ/vXc5Cnt+lnJkozVAXdcBkFB0axr/x26qCu7s7RzWuiszEqaPoTOUBLyhcNbFTPoGiw56f+tubpibcbaHSsBGGv1ZZNF6yhojzk8xgjWopPxIMXb5DFKIQCqimYV0YCvCs09zzuanUkE+EB5OEGWDgC+dAYze+YjcXgKG7QGtvNMkeE1QkBSjZ/OEIsGinl1m0bKR9PrGEV7A8uHttiCmcP3Jdk9x6EbiF2uUvG0fcsCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YwptCnliuj6dA/CPebYzq1mAz9pJLVTZi6GbG+LCjkg=;
 b=gaNK3ce8FZiZNnXeLg1CYUeymsjbN6jKD68yTTrYRc2j3kg7TpS9FvF3Mtuc6MnD2GgMKtS8BdH1utml0nkLv4LnWXSv1TM3uCTE0HiNviNelntGuZY3koAA018rpOCRIkMUTOhpoMxw6LjlTBD8nR8jPaS1q/WxksQF15rLsIIq+na320LmTDHCTHO/xKyQR0Yym2X6/tjlJEqJfFE8ef5YXLQQjkzHZY6XhzMqQjRtw8uB5b/90rVXnnE09ZNKJt0O8E1qUQne4ffGhfkbWOSGsOLHzVntDHKeZAKef4knGp3+Lv49b12mXv4WDimrwpp5dcZHFUOFRANtyrRhOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwptCnliuj6dA/CPebYzq1mAz9pJLVTZi6GbG+LCjkg=;
 b=d39NcNmmJ/YfFE3/iAYHbSUi2h8ryxvYssprHvnbRaXullVaSKVU3zj8fXlU73QoyheGHcddUXiY0oefrJiRYdhCQ8zKRl6De9ZuObG7IpYw5+4tk5rULvUfHgxA1AILss30mtqoTIvUhFLxE+1o3Zy8x+5dfyDIqaD06JwJHb0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CY8PR10MB7123.namprd10.prod.outlook.com (2603:10b6:930:74::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 10:41:59 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 10:41:59 +0000
Date: Mon, 2 Mar 2026 19:41:50 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hao Li <hao.li@linux.dev>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH] MAINTAINERS: add co-maintainer and reviewer for SLAB
 ALLOCATOR
Message-ID: <aaVpbl7Om6aImsMo@hyeyoo>
References: <20260302101345.36713-2-vbabka@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302101345.36713-2-vbabka@kernel.org>
X-ClientProxiedBy: SE2P216CA0132.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c7::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CY8PR10MB7123:EE_
X-MS-Office365-Filtering-Correlation-Id: 53265323-02e7-4870-df91-08de784854cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	uUE/TjwvwhDYhYTX/zZmv5Eus3jiftdUlgtodYHMgUGNc5RihOPRn39LkftpqkDgVBLkn39aJhsWFovtyxs5qeA+hpgVtwNWA2nLGywBKXVFHYZRf7+DsT5b4f5nEbtyIfb5yZdN2r8lPu+ot9t9cxM9lyvyCu+DwEvfdqkUZh2JA6lqOrUqZR81ngag+v1/T2y5lgYNAa2u+FjCXiU/W0QPl/5XMdyQqXMJfOfBQhox36cqYN+ch1HaeZ+2k0+AO0j9lNIoTCqdkLV18pf2zi5PTEEU9szsVQTmkvostpt7/l8tJ9xm54OHKZbJCz83JsBfZMjNPpHj6OL87BOMrwFBnaqMFemkHXMbMiLO2no+CYs/cShVCqBemgngMy6Vqd/RLSRTYsXYyKrIC4rM9IpX/OkZVGMD9/lM9JdJCSvhUCaNDAKOIU8udkoeefjnDaaxRKnSwZefu1vFZWT5mST94kXChiub1HTaiS69QylZkRiD4CfajiUi4c9GL3WlZWEF95mSd4lnpjM3A8MW8AbYjMJvnFG8QVshgPPXtD9qj6pho/x6LmEVP+oKt1vVyJ3hc+09c47CyjKP7qg1Jf9Zzck3jz6XW69jNjuz4pCNqjkNhWlnUDRVlQ8D3Pzvb8OZNWDpcPtv7LFpwM9xaWC9tfVp9TAJVlPlMmDmg2zTfUHDxO6DaaDsgc39CuJUYg8E6C4OVosp9xYh4Eb9nY+o4V4kpFLd+3XutOjYWkI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2M6uhGGjQ3XWVg5ub0YsvAZ+SgHPf9+G54Sdggfojq0nQjvS/85NGCRWyqak?=
 =?us-ascii?Q?awLSEGoptc+PI714q4BM02pnZOPHT7Cqzjx14HSwf5UJt0qqDXrYrh+7rV1r?=
 =?us-ascii?Q?FMzyDVCRfpK2dWDdqye8pBwDPrr7p6XV6SLALowh/3rXkawjtPy3TE9jqPr7?=
 =?us-ascii?Q?E0LNKLNDWPoZuY0VadGlAEXl0rlt1oaY6jYInjEzMt49eMBEJ9pMvb0YkVMH?=
 =?us-ascii?Q?21VnoA8MswYCOgyXJHuf6XstXfw4usIpJRNbii/B0tnTibpnqEHX0CG8/o7B?=
 =?us-ascii?Q?+48T9Wwbr7c566RpvlE9M8r5Jop+WBhUyk/q/g1sFFJany1O5MYlDQYx/VCh?=
 =?us-ascii?Q?pEnwGZfYlFRKDfCd+dHHq9IFrNIC/xiYM7fAbFQB9SPbhJ5dX3i+2p364xqo?=
 =?us-ascii?Q?pjJF92KX6hKXGpuiLkEUfIkKD/labm/ucCqJB7TQHJ4AlwWVazbvZPNsTqEX?=
 =?us-ascii?Q?oxB/AAsdyWD57D3xI3QcIsh1EkW64lROerDJPaKsHyaUGzU6qkWCzM4iD0a/?=
 =?us-ascii?Q?Q/JTt/G89TEhsIyCa11GQJvlUrKwdKsmZAnqUiSDI49DliZYGHKqsL38zfqP?=
 =?us-ascii?Q?PdDgukRWVdJW9SXnOf1WqpJK6SJgAd7CZU6KaGHXTKy8SCWc/mLwvWsDwMzx?=
 =?us-ascii?Q?FPr/BUmx0JNVTJhPbjjO0GhbH7JouXD2FYiHyoQEUXR2swnUVM1SC9XsKZL5?=
 =?us-ascii?Q?SfvuaoImIH3VBOIvah+CbZPeIzKLgBGwhd9Xvo2KflHyeLzrxxM6tSjQ2fL+?=
 =?us-ascii?Q?rpo0jNhypK7RocY+ywIs3vTgrzouRJZyABpqpFUx4FHREIuLD8Hj0qPSatgU?=
 =?us-ascii?Q?JJsBDuSkgGtciQItYryqDtT4Cwd6t5vITrXME4PmtE8ZvRS4eT9hdxBH6mrN?=
 =?us-ascii?Q?ygZxNEfujMWH/ljpSAkSGC+Jjt0A7a5S4AaLOVmlJ2hPyPprau3PgeZ6JJ1H?=
 =?us-ascii?Q?6YVzMxHNSkAfQYQp2OCmEHS7W9kpLUbPS6E7cwiQJvfNjy45oIk+mp5woKiF?=
 =?us-ascii?Q?i6yNHeIBB8bSSSDN9Riff4sJC1spsok0aTP+nJ9+CVEC/gJ8W8rmSU9HOZGO?=
 =?us-ascii?Q?FClwcuxkNHiQG6hA4r9t1zpCDio8v2wCTJVmNECRemuY/dzukH/K1rd6AZQW?=
 =?us-ascii?Q?qU+Q5ZpewPNFVLDJ4ql5pg5Y7tNYQHalxr79tXrX0lI7XnftiAJmmDL8attx?=
 =?us-ascii?Q?HREDM0SREIrcwge0IJ9/8gj+SLwltMthTeJf0RTGt8IWXDhDfXXmkDqcF/Cq?=
 =?us-ascii?Q?GQODo7USeK5I1dKJYaDrzBxMqP9UnZDbqy1YKlVNo29xc4GnKT9JW56o9Yh/?=
 =?us-ascii?Q?NzE8X5mxbxBw7AIQLl9fa4sV1/CIDMzbbwpeh6GHHQ+D7+TXk7OqSJz2Cd8D?=
 =?us-ascii?Q?wtOg6FUu32wcQYA5AdFxIMQq04RDxiVL3ZLqwqZ3c09FLSEBifpyoNAia9u5?=
 =?us-ascii?Q?lYIm88BJrT+lZYUgw2Mm0QLsWl+LdNktZ0ifwIaM7OOBYzB3yurghlDyHQ6R?=
 =?us-ascii?Q?U5Qv4Hf9apU/Mw3Rr6knswZiRGS2BkuCoSUONOBa729Q52SSMbcJvXeP1aCq?=
 =?us-ascii?Q?m1XvCS/c17uIlf6VC4UMnILIuAnAARTvenwnElrhX43RPEUIe65l0D/lSZv1?=
 =?us-ascii?Q?8kquIabs/hd0P2S0Uy1uRmYyQxQ/Qpu0RM52KDk+wmm6gysxT3uD68oeMNLH?=
 =?us-ascii?Q?3qff/etnXsw0/Gk7savAJd1s77rV4A9DjMYUt4Vq3hAZqCT435M2VfMwLoqh?=
 =?us-ascii?Q?CGh4tTNlNg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iYDDQ76o1tDslodVCzmvgIN7pC+PW1rbUh5Toy3V6Vr6LSCc4Kiech0Ph9Eq8kQ2Nnij/QcbuwiVsjHXJPRdkhew+AElG6KCWhTa3tgR380o/Gtm9Ae8boilcyd9iAaQn0lFJqaEvDjcZGNYdBoyTLDx0GpRQ18DVrtzqyV8CHlOd9hDr5GF7pmTJGP1gM7qvpJcvK1+Vy/6Xa2sWDayJAC/X2GjRRgN1fMglDu6Ddj4tKayp44BEpdC9l53AZa/51ns3ZWfxfWIjVC18e020Dnp1yBizlvSSZn8qDd8dWW3M6cwSmjhT4hjzBkIFl5xFqHcEGR4AW1amPgMYmSpQ6u92GzDdJLpCGd+blxYhxVFRRLNeDf3cwYKYjpQ5xxmZcr57AmEIfRML+gslIbfEzcsCiYMyRZJQyUfoWWwznY4G0udISTekpH4qBGoUaQ9dK+gEfKi/S3BNJOugXLuysTS0La2KUHD27yy1u3YrM9vPHMorDABk9e2EZa7FxgWohHBpuWvy04UDJDDtoDvWfdVIJQnU3ul5rM0fMQVNk1zFzB/h8e5DqRGornCXvM2cjfekzL9PrPpXHLsacfARCH/9G4Tm4I2PEne2Z8smhc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53265323-02e7-4870-df91-08de784854cc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 10:41:59.0237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: THlIc8+mdHC8Kh5gXp5nbE+K1p2yKq3L7Z+VVyT2Mg2QHA+BazfQzuBf9b988/gosvMGdl/A2k6ynajMiB0e4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7123
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_02,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603020088
X-Proofpoint-ORIG-GUID: snmJru5i6srSUtB4AmkaleIIe8TChuN6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA4NyBTYWx0ZWRfXwQV48vT9bOWs
 frMgjJw4ma3G0DJIOURlYkxj2tgZwO4l2iXhyp6jmmhkqdz3LrMCReCCHQFVSGkc9ZK37jcGk8p
 fxRrJUg4XWfi4aw0EpVSMcFevodWfNrdlP9/xooVhSR3jBJcVdBILeNrYFl6ElkRLgrEbSN4M/p
 XxFgDNQaxhPVCeElCgJMmPFA2TLZEeCkklVcCAJky1+2mRPdvmfM6bTRb3ieSPKkKBFALGhFSW3
 EKuySzJr5r1I+szGkhkLyd9DEPWr/Jekc9bi84/1qOv8iod/vmWydkcUIZti+AX7WDwje5VNUwj
 aVhfhl+iSMZQj5nO3BbRBdmgPWIV8UxTsTu0KidL6iAAT4Nzuud1c+qHhwOhKiNG/HofHsOauvw
 rtbQyYeRR3+VqG9qEHJ9+H9p33Afwdlt3I7jRVfe9LutxYnX6xtErBV1p5li497r6xABmlzDin3
 redNmMwoLAddaAp2lfA==
X-Authority-Analysis: v=2.4 cv=BNi+bVQG c=1 sm=1 tr=0 ts=69a5697a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=Z4Rwk6OoAAAA:8 a=PuvxfXWCAAAA:8 a=1XWaLZrsAAAA:8
 a=37rDS-QxAAAA:8 a=hUmQZmHxkQf1B0ZsiCsA:9 a=CjuIK1q_8ugA:10
 a=HkZW87K1Qel5hWWM3VKY:22 a=uAr15Ul7AJ1q7o2wzYQp:22 a=k1Nq6YrhK2t884LQW06G:22
X-Proofpoint-GUID: snmJru5i6srSUtB4AmkaleIIe8TChuN6
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 710F7180005
X-Stat-Signature: ym8yirguty7pqm5j73jrf5o9a3yaa4om
X-Rspam-User: 
X-HE-Tag: 1772448127-551773
X-HE-Meta: U2FsdGVkX1+py+oeA8oemoJMZ1ypFsXbBbindBDk0dHwdwVuhbHhVjLMleDZawZ60R6yj/fAE23MiEye8dF8uGMGQKIFNiqZod/6Bx2GNJlXP2GFEl/JE8z3jrqQxzkmp50HVaw8rQfkui11sZAMwOeQA+l3PvugY0CijqxHtYOWTPpqDcUcYxdZE+zzHSF9unpxRXuk22LaA7bh2MxfocCOA3onioZoW10L6TGTBBTdgAvN9snEf8Dfas0FSC1drSFfvQy2iZmilGo4qswcUGML97gdjAs9R3lbuLR9IL4McIkoXjHkOr0GrMuVbA9uX2jjK/y0VLv5qtAAlS1Vqh4JhkmLWn7MCwKLePyveultyLb8NrS+g1BqI2T801D9RimY4I3x0Ahi5raF3a8eBcfhYkWd5TYYz27VDA7Wrmy/o7kO+5ZAwRFQsWzZEGEyocbYUMcnZz6fpaHZeBob+2iH+UtMHfcIrUIdU1Yq6C47Hu62sRH/SNn2CVvqmGAoScn6t8q6+1jWElnQz97Q/jJMaAK94lHTe4rPDnB48Azug0XGQvO3j5bH5iISazCP4kAdLoo1pa991F0G/d/KPGJwxQFmMpg4G/NCKzxunj/rxPskT2wNDMl6gRRrYGQzk/ZU3QN9lZegrsl2ftBXqN8pcp/WmRiXCRwv1MFBI/4UrP7r62RbShaBs6bL9BIYHHibEik3Xxesa39DY+D+c3TYKks1MpNAU/xniQ4yuMmDirOBq/ngo3XlVGrbHDW4dlvyd/tAQyykcJ4ahw/c/d2+Nvbb5KcCtE3JuBtI/7VPO3HCgpYQZrXpsaZ8Ebsuj8058aLMJVPz6KjRVc3O7+z2TFQd/E/Vm27Wdk3KCcMks6rRG12oJ04Z0GpdfLT/DRvVqTv/fMBu3IkdxpwLWrgNSRGHECkNUZP0OSy1nuzgJLS4LCPT9DnCdksr+nIaPcqeDzhulQB0aeFjMPB
 KkQ2LyDp
 zvk0AbEmCDSA3pM4Axm7Zm1ViZaHb9XTagrW53lTWXaE03jsohDesOmO+5rfj/sVpW1yBgzK31VvpBdTeA6HTnkBXkNFvxI9EzydKtNajw+rw7nXh1XU8pnuHzRQG1d1XtJUJVkIAZmLz7aM41BXExBXC4s0hTfWnK1E92SRIHn+LIYHxEgYHX5t+e6YmO3u4lDd7Ibu04hhC/Fd0sKFjqjpY23USDzIkdPkRvztvPDm1UYmRs5DXt4824GRSChX/+NPJH4cJCGnE4gYt8xsOJMtSYvF+VQYv5c0ui0DptWPE7Hji7+o2rl8dC6GDY23VNxFzwrD+P0jJzYQ3FhZJ3eeK/EfANOdCSpOrvifKXb07VIA/JFJlTWsxnUL38l9LsXh1GxHCgGMn6d0445dIbfFh/97ZuqwmFfqEm6dZ47E9pD079KZi8g3oTzItWfML/a9uxRbV2Ts58Wlcbvm+MN2otm3jGSsW7DLx9qy5sIHoX6APSwBiQDgtZWFyBhNvX7qvUA65nl5dtiESk2e+x1K6KCjM9RASlg4gAmKVZO9nZWuxtUHact06mwDsc6o1PalRzBvWkQZsiT1fec7dsfq7uvpQHOIvo2SWSVYM/LEdTUpdMqqQeKRFHKO2TaubHVKU/735w9ti8k5cD5z/fljCcrGWicwTCMwenykIs9mkTc+jSViNKZS21wHUrYIHvuRZpGSnINMk/9fO4CmNxz+bFH625FbMSZVYRwCXRHcIVh0v5C//SjkT8oXO69X9zqTN9M70rz+iHW7hHfNE2J9pFQeuVChngtuwgKYBjPzPrcFSfglXTgzQ94aqdRjsprNrbBY5yOoAWjJ46fy4k4HOoCPtAyOLMW2sR1EZflJDAa8aFKs0H5QbHUcqV527R3IM00a+EY4jQHZPQQG/DR4XKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 11:13:46AM +0100, Vlastimil Babka (SUSE) wrote:
> Promote Harry Yoo from reviewer to maintainer. Harry's been involved in
> slab development for multiple years now and doing a great job.

It's been my pleasure to get involved with folks in the slab subsystem
over the years, and I'm happy to continue to do so!

> Add Hao Li as a new reviewer. Hao has been doing very useful reviews for
> a while now, so make it official and ensure the Cc's.

Many thanks to Hao for having been involved in slab development recently.
Hao's been providing constructive and helpful feedback (while being
friendly!), and I look forward to continuing to work with him.

> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Acked-by: Harry Yoo <harry.yoo@oracle.com>

>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 61bf550fd37c..5f3cc4193a8e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -24350,11 +24350,12 @@ F:	drivers/nvmem/layouts/sl28vpd.c
>  
>  SLAB ALLOCATOR
>  M:	Vlastimil Babka <vbabka@kernel.org>
> +M:	Harry Yoo <harry.yoo@oracle.com>
>  M:	Andrew Morton <akpm@linux-foundation.org>
> +R:	Hao Li <hao.li@linux.dev>
>  R:	Christoph Lameter <cl@gentwo.org>
>  R:	David Rientjes <rientjes@google.com>
>  R:	Roman Gushchin <roman.gushchin@linux.dev>
> -R:	Harry Yoo <harry.yoo@oracle.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git
> -- 
> 2.53.0

-- 
Cheers,
Harry / Hyeonggon

