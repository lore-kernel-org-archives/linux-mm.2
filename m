Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EA53D35668
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 03:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70CD86B0088; Tue, 27 Jan 2026 22:09:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BAB06B0089; Tue, 27 Jan 2026 22:09:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53AA06B008A; Tue, 27 Jan 2026 22:09:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3FE926B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 22:09:42 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D506BC17E3
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:09:41 +0000 (UTC)
X-FDA: 84379892562.06.6E14E0D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1093418000D
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:09:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lTyKkBSG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rMh2jD8x;
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769569778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=16X1pYpwYff2Qd9MnppXgTKxFnfWhWoQap9OSb2vEbA=;
	b=R0D4HfCo09yU96Yfqps5VhklsyCmp350Ozb4s5pZ0qswHQiiLFAhVzCjLTjyPaj+MywV46
	64XhBKcCxZk1IApo4d2aViRW6syn5wKepvN91m9+Rq/VQOWAXazRzgcZTiJOawnfKBhlBJ
	0zbp4qwAFJ18fqKRC0EWWMZTb5YJ2es=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lTyKkBSG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rMh2jD8x;
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769569778; a=rsa-sha256;
	cv=pass;
	b=C7HiMI5643+1XjRVKVWNYlLscLiGLBmEIAJeFkndNc4BM2Ej4IFWKrQATh3Nvi0ZKe0HzU
	mDQh8UowgfG7Usc1df7dfX8Oa/HaLoqP8+F/2P2uIJia3diknPgcWfJUb3Pt/6jq3eg0Oy
	TArzsqeW27bgGrrlVfADsUJblDqa3eg=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60RNEBsc307763;
	Wed, 28 Jan 2026 03:09:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=16X1pYpwYff2Qd9MnppXgTKxFnfWhWoQap9OSb2vEbA=; b=
	lTyKkBSG8omXhXgFNwDhk8+gMEgHo55U3Qv5OMEnftNZYBEuyfVP/BQOuaIeW/OX
	d2YbT3CvIeHmYgl2ktGG7+k+Dk9LZ1PZN5D5bBQiN3DtXe9LnFEdT/yI2WqTbvSv
	OhFWdabA50mJj6dhdbOH/nRIo1G1fvsY4nzZSuHXPzjBHVCn84uWoQhRNdX22q7v
	vnlWbCAyUdCkgF71C8TjVu6RSwYZUQUT0QpQpcQOLvw2nztcyaGemltkJVujyG+8
	BijtQGIwgAsYwlhou2DdBrw1bTTGffFjIHM/KYmRsVya5xN+EYSe63bPqafpvdoQ
	pZB91IsYUo0w64Y6cqEL1A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by39r8nhc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jan 2026 03:09:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60S2w1Vb019753;
	Wed, 28 Jan 2026 03:09:24 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011019.outbound.protection.outlook.com [52.101.62.19])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhfmsfp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jan 2026 03:09:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YczqB9Qnfq2lxpwdEKsacXhjBGh2GhF8XyNevHj7VJn5u3A9LvCpWuvDXAkCUzmG2lS9l4VGitfHNvrGYmEZxHxP0nO6fGfqD0uxRJiw3EVNHz3xw1SYE7SPoOfbaGFLm/n+EFaG2n9+7eMtu7JiJg0wwD+PUY3EwkM9+CwjEyLxptB8NUoaf6EUz6+6BTG7DK2HQWFQwo6bk9Ok34yQSgNmKgUb7ebavow7hJCni8HhRJlq+7c9iYTERsnDXkteKdB1TA5O6fK4ft6MpLLAbYnfnLZCI54FoiGUBr5Lhw/pURaa/2i64lk6OGdUsTQNpju7cor7UJQ+Vh+QJmOxPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=16X1pYpwYff2Qd9MnppXgTKxFnfWhWoQap9OSb2vEbA=;
 b=xCZlbaTlsEDatmkPE+0uqkrAI1CsMzreY4zy1K4wzKjUf+ph0NOYCKc8Ex1pkQE6Psnmcho91o+vBnSdgcmSX9gTm+usmXdKMrmVO3cChf2RzdEFU7MQkHe7EhLPmthEC76F90Kf505cT9C4UB1b2q6Djs3P/SRSa7k0Q/ZCbvJ9kHsNv8Bsjzb4LdK4ih/mG5CzaJGyZ3LXIzsOmDsWHyOEr8z6GMwc8Qd1sJ1p/rt3vxpnaZOjnVYgCQu7Iie/01D7Y+7RpPHwaZuzG9H2sdTcsen0fhbEBAeXDKzSz+7X4y/gban0ybVicPNqfwYp4erXIKAQbmnTe+6fghvVIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16X1pYpwYff2Qd9MnppXgTKxFnfWhWoQap9OSb2vEbA=;
 b=rMh2jD8xzCot6ZnfEZe+9XGsIHZjI1+ETj7kQQY5XZMGwP+FTiJGFP199Ua1Y5WIrY2SFOy8kFocyu9QFzZn9omEsfGuDe8g6Toz2EotB738DNjEbpj9Vl4nLNKjfwETM/uF+r2Cw0W7xMMuPEztYd94kM2g2IJKeKqqjgiDK7g=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ5PPF2740EE012.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::795) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 03:09:22 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9542.015; Wed, 28 Jan 2026
 03:09:21 +0000
Date: Wed, 28 Jan 2026 12:09:10 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Michal Hocko <mhocko@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Hai Li <hao.li@linux.dev>,
        linux-mm@kvack.org
Subject: To enable, or not to enable slab merging? That is the question (was:
 Re: [PATCH V1 0/2] Only allow SLAB_OBJ_EXT_IN_OBJ for unmergeable caches)
Message-ID: <aXl91hMQrkEcbwry@hyeyoo>
References: <20260127103151.21883-1-harry.yoo@oracle.com>
 <aXkCFYWvbpZB_5oZ@cmpxchg.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXkCFYWvbpZB_5oZ@cmpxchg.org>
X-ClientProxiedBy: SL2P216CA0200.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:19::21) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ5PPF2740EE012:EE_
X-MS-Office365-Filtering-Correlation-Id: 793a4037-1c4a-4108-1242-08de5e1aa1f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Yndjc0V6bjVSWlpxSU10bTMyclB1czZxUlpnK01PUENpYitOckVoZWxOdkJP?=
 =?utf-8?B?MFJGMGpxeHZWbW1JamVXTFMzdzVEbU1KdmFZVkY4aFIrRWtMWHRSTHVkQnEz?=
 =?utf-8?B?MlpzVWhIT1ZkQTJqeU9Rekh0aFhVYVVzVGVqaU9DRS8xWVkrK0lvZ0I1NVJY?=
 =?utf-8?B?RjhCNGhSWFdjVWpLTnJSYUptMkJKdmkwUHQyV0hlbithWTcwRjBCSVNKZytp?=
 =?utf-8?B?N0JiNlFYRWlTOXRDd0x2UEZ6cS9HYlZuZDIrdjBEZmxRUmJXRko2VG9mTFhw?=
 =?utf-8?B?V3FSTy9TUW1hM1YzbnRudUZJY2hGNktIQnVXSkNmVWUzK21EakJoUnZ1WDhD?=
 =?utf-8?B?U25HU2V4SWwxNDFvb1BxZk1vMjJheGF0TFBpaFZVWG4rMEsrNDF0U2FFcGtT?=
 =?utf-8?B?L2E3UGs5RjlaaHRzL3NJam9vT3hRR2p2K1dMV3FWTnJjY21COXU3VTU0VVhp?=
 =?utf-8?B?QVpHMjM0eVdrZ3dJd0pBQVg1OVAzTGdyMUxiT1BwYUVVVDhmOWRqL3R5a0lv?=
 =?utf-8?B?YVVPQ0FYZzExR09pcEwwa3Byd1Rab2hsWXM5MkRBemlYTEFoYTh5MmhqUVR4?=
 =?utf-8?B?UzZrcEFDK1Rqa0xHb1puOUtzR2VOcXFaUjFvaTNTRXdLWmplMjNqYXdUU2hV?=
 =?utf-8?B?RUp4Zkhld3g4SHFmbEhXalFES0xadFN0WDBhNkVnU0t4cHQ3YjJYdEcxSlg5?=
 =?utf-8?B?UmJGNmprRytsY2pQQy9DamlxNHpQUkJwbHNLTnpwVERkdnNHSWtuOWROcWdm?=
 =?utf-8?B?Z3ZQclZRT2NWQTQ2MC9LQTBrNldOSEE4TDFvYjMzZDUxSzlpTVRUV1gwRmpC?=
 =?utf-8?B?V1ZQUmlMK2VYbm1sc2I1QkFKaSszcDNBTmdmYU1qWk9rRG9yMi9FQkZTWkJD?=
 =?utf-8?B?MzdvVVdYbGYrZnkvVGRDbFRvcVhqd09GcmZkR1ZFblc0aW9CZ2R1U1hXaUVh?=
 =?utf-8?B?eEdieUlFbU45Tm53cVRJUW5HcTgyb1BYSjJqTVgxYkJJdEdQMlJBWnVxMEo3?=
 =?utf-8?B?bW9SSnV5aldaK1k4djBpeUxQeUxweEsrOVFrY3FlNWM0bXQwM3VkdHZkQnAy?=
 =?utf-8?B?K00rbGEvYjljbDB2ZGF0d3lKcmFEZUl5aXg5LyttVGJyVnhMNlZ1clJMN0M4?=
 =?utf-8?B?b0N0dkl2UEhETXhxMHI1Q2Jzdk9KWVJUVHNFVmhQTnpyS1U4eDRoMkk1VlNH?=
 =?utf-8?B?eUY0ZENUd2wzVXlHbmRZalR4Rmd4RzlCT25nQVEyc0JheTR3cHZBbVpKT1NZ?=
 =?utf-8?B?V2NRT3RXdGFFZEQ3NDdJZllQTzlDSGhneWhWOXlCUnpPQkQ5YUlQK2gwaFR6?=
 =?utf-8?B?WkgvbTNtWmFUWXgvUGJFKzNuOWU3bTVTRktDaklReEtPV2JKS25pNC9ybFQv?=
 =?utf-8?B?QzMvTG5VcFZWaEFiQkNhWWZHZlR1SW9kemR0Nmh6UWl2WWx2VEF4czRYazl6?=
 =?utf-8?B?UHQ0WXV4QXhJcG5iZjMrSVBHYWdBaTc3N2JHRE9GTThpM1IrRWVpdkc0eHZG?=
 =?utf-8?B?dHMxQStTa29idEdJTzYxQ0pmVTRYSDBHNzVTZE5XM2lOdFdEUVQvenJ6M3RU?=
 =?utf-8?B?THZJa2JrWEwzb0U5QWhWbTJkQTc5TENhRTNrZk1GcU1Oc1g1KzN4bWxZS1Zx?=
 =?utf-8?B?Q0JKcHVsTEdtSUhuTjhTWk9xcGRJTnYvUlNEOTlDWGxNbHZTeUFIVHpaanA3?=
 =?utf-8?B?c3lCSzM0U0xLc20zYnhxS2V1clFsS0YwZEovRWJ3STZmeEZVZjdMWmMxU3Bz?=
 =?utf-8?B?c3g5TGEyT3IrNXJDSEI1TEtucy9lSUxHQnRPeDhtV1dwWjhzaDRKR2tuNit5?=
 =?utf-8?B?cUJmcmF3Y1lsdUJUYU85Nmh3bld6a3VFaG16RU5rRGxPNDdQT2hmRmMvaW1D?=
 =?utf-8?B?blltREYyZjJpaUVoZVFMUmg2WHBTdHBQUkpVSTJoZ1NpaGdqTlp2T3lTSnFJ?=
 =?utf-8?B?KzBVVXRENXFQRDlNUWJjTTl4Y3l0NGkrbVlHTE5HbFpVcVFFTDh2eVg2VitG?=
 =?utf-8?B?Z2FScjAzRmh4Ni92RUZaaUk2cThxSVluc002UmkxbjhFQXJSUE01ZjMzZ0Fn?=
 =?utf-8?B?anlwRy9Eb09tQ05yTGlGWThOMDVjcGswYTNaaC82T3UrZytEWDFBSmxRL0tp?=
 =?utf-8?Q?fmGPMdFrzPImcVkOK9Jqbk/14?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ejFrQVNDREx3QzFaM2FONCsvVXBySm5WRFkyWm5IK2FSMnQ0aDBUSWZSV0ts?=
 =?utf-8?B?MnYyTXpQTmRPOXFZejJueGdaWlp3N0duUWRQV2VueWs0eGt3ZmtXZ1hnekdC?=
 =?utf-8?B?RnNCeCsvQXl0bmp5K1h5aHdZdVNnMnd4NnV2UXBObWgycEZwSmpJSFJUS2po?=
 =?utf-8?B?ZmVZclZVR3pYRCtpQ1dObHRqNDMweU1oZit5b0ZEN2p3UHZrcGtyME1DUG92?=
 =?utf-8?B?UDFFTmFnK0lnTjdZWmk2K0FIOHgrUHB4MkNraUU0ZHgvTno5UmVZY2gzNlZj?=
 =?utf-8?B?UVZkampVM0NWaU9jQUtDbDJ6Yng5RFY5bkQvZjMyTnJ4b3dybzJlZ3kwVm1m?=
 =?utf-8?B?SXI1SG1ycnhUeDM5M1plSzBZbHU5UHdWL21EbEVxMS9QYVc5QVN5QVZkL0d4?=
 =?utf-8?B?T1lUK3hzcm10dHFXU1NTcVFzdnV0WGs2Ukl1dG1OSXo5QmhhYVluZ0ZWZStS?=
 =?utf-8?B?aFNPNDFPaFpmT0VsTExZMm4rQVNaejg3c2Vwell3VFY4ZmlGRFVoSlVWUnRy?=
 =?utf-8?B?NHZrZllDOTlvamRSK01McjZqcUp6UHZkRGNYWVlUTWdjWUdnTGdncVdWNUx3?=
 =?utf-8?B?WnQwM1FCQld5UForY1JBeHVTRUY3MkpCSFJJTGRWbjRNc3pmdTJVY3djZ0Zv?=
 =?utf-8?B?MnJpYjlTdFlKcVZFUHVHV1VqNGNIM3FsTFpTMk5zbmFOc0dYY05NTEtJdUlB?=
 =?utf-8?B?TXcrN0RBeGhqMXFidEpvaElGSDhVQUxnckdrMFNoak94aGNDNGk3cyttVERo?=
 =?utf-8?B?d25kUEhnN1NPOElFZWZqWUd3NzNpYzVCakxzaktlWTBzM1hMd3VneGNOQjkx?=
 =?utf-8?B?MTJ5dDIvYWhQczc5STBHendXcmJMUWJxb0VqeEQyZmdvVGY2Nkt0Z0tiTjdB?=
 =?utf-8?B?ZXA0NFpIWXpPV0hOVTdFYzM4S3BON0dKMHZxaWUwMURzU2tSVEhPckR2VWRY?=
 =?utf-8?B?ZTNqYmt0ZXhjZ3ZEL3EydUFCUHRMQVpDU1FuWk56VnUyclJUUFF2YzM5WUNT?=
 =?utf-8?B?amtIMTV0U0pqZGVmdDJDNVQ5YmUyNjFWV2ZoOWVjUGdDUksvM21VMTVKeGVM?=
 =?utf-8?B?WUJNekRDZ3hhRTZuUlFuMHN6cnRLQ2E2UDA0ZGxRTWMzeTdHcG5xZTkyWUZq?=
 =?utf-8?B?VXNPQi9XTVBkb3VLMHZSemJwdnA0UlRoUTJRa2xlcGdpNE9NWVpScy8vTUsv?=
 =?utf-8?B?SFVrYXQ0Y1dUTm02T1kvTTBZQm1tN3hDWHZBK2ZCRm03Ly9ybGtac1NiSUt2?=
 =?utf-8?B?UVVmWkIwQ3liVEUzOHZsem5YWTlWZ0RLRTFSMDdyQVlJUWRKWVhiTE12RS90?=
 =?utf-8?B?WStITVQ2VURLdkxPSnFVNnc1SlRpdURCUVJ5NWVTSDdUcUh6eDhaVW1jNDZw?=
 =?utf-8?B?QndRZ2xZYXJuTHlBa2tqMUtXemlTTFVpdmJTWFNHOUw3SjY5VnhZSnF0TEZH?=
 =?utf-8?B?cG4zdjNYOFZUWEJ2dU9EYmhsUGlJTmpXRG9iNURkQnpoejhLajdqYWtVUzR0?=
 =?utf-8?B?MFJCd214YWlyN05qVjFndzNOTnYyQ0tERXBEYUxiVW5kRDFJM3ZpbG9mSWwv?=
 =?utf-8?B?Y1kvcXpJYUJ5K0w3RnkxREhMeUFTazJqRFR3NUJGY0lkMzI3N0NySlNMKzdS?=
 =?utf-8?B?TGRKUXE2K05BbEdqSzloeXpCQVlxdXVjclArdVZCVjFkSzJMWlR5Z0hQOCs4?=
 =?utf-8?B?M2FhRTNnRHZsemRLNThsYkMrU2VnWG5XMFI0aGM3VHdEWlJKRW5nWFdpNDFy?=
 =?utf-8?B?VTFpNjFQbzdPMU8ya29QbHVqMm1KdFUwbjl5RE5lMnR2d2Yva3ZrUWtUcytp?=
 =?utf-8?B?TUx0cjVUK0VwZWxUZVM1NmZSM2M2YlBjNEpXc05ZN1pYNitjMGNPRUYyZUtF?=
 =?utf-8?B?WkVSOFI4cVN0NDlRcngyc1JBcTJOTmpVUkZROW5ieWlzNDIzeGhVdVVNbW52?=
 =?utf-8?B?U2d5WVpzN1FvNXRWWTJxRG9GT2RCeURmSmlkdjZ2czBjV3JXTlVyTG5ieUNB?=
 =?utf-8?B?WmVkdEFVQUF6Yy9zcDJ6QjNjTmNvS2pMUnBWa3ZHU3RGNllOSkFXaFVSTnFE?=
 =?utf-8?B?QUphaEp1bDV6OW8yWnR6VVdvRkVhQXFvbzJBWXJCY2lEdEFncjdXM1JGUW5I?=
 =?utf-8?B?bGZrZWJuQ0xsWjdJY1hPc3BWOXVPZGhZRCs0UER5bGkwSmJlRXVoeDgvSEhn?=
 =?utf-8?B?SXRDaDhmeW9jN3QrenFHaER5TFFXZHlQUEFwM1FPYm5sQWllVjk0ejdWNmty?=
 =?utf-8?B?VWk0Yyt1RisyRUwra0o1YTRiN0JWcmJIU09JY3ByMkFuRHVhbzdoQ05aOVdE?=
 =?utf-8?B?eUhFVUdDNnlTV01wbXlRUEJZSXZOSzF2enVLOFBQdFpnb0JHalVqZz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8J5FCa8opzIBQfYIOgvX8+Bihu2oQQyU8pjulGZHbaO+6x6cJ0b+qnHMFtGMxcpbfecRdqAdgajU6YuApcoWuas5rEWH0W+lppO297ET+H8BeYXmhVDuNrkAcvkbFGktWIfUroVpoVsdOSO9MwBNCSnSvBuggcl012mM+DBc+NsCLrxSEu8Pg+C1bAYBolr/UfZ+IlqG7nFFKzqnlmGxzZtLs3JLStK5b/lMaqSRqWHxVcKG0XS+hdHd319nuLZ7LESXYJqkw6uJ53qP0hvzjH882fiVytzYzPPVm9GehPTTnR2s74dCCYdF5EiuE/gjrjpaFQAejRKkPJ7QD0WyK+wrYTsQSAu5ZKGv3uicO3WElSlYYxUcETKnE6A0iLdPTcBkGXDTiUQcUOuad+ejxh2hq2xsnN5j4iBxjAOCcQewkyO8i4yH7iOZ3KRjd38aXUAhcAIs/m+j/NLlpU8cbfIzanNCxP5AZ/mrTW+NOTlGqkxBtf3bogNB18zl0hcfxQ2C/g0/5EwGYFXwoeVVTTKb9DHbolIHq5fib58qLbgmrajPULCzK/Wv4L1kBKkxrKWz653XguM6F0akubXe1JYSM5ErUSmrrgf/p9b77lU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 793a4037-1c4a-4108-1242-08de5e1aa1f7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 03:09:21.6212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9jBwWH7U5sbq7ip/56IJpzYekClg/yx83ueIVZE0faZfzf7C5jiYSC/UptapWq+wnXUvThXxcrkhxwZ4vWvb5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF2740EE012
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_05,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601280021
X-Authority-Analysis: v=2.4 cv=LaoxKzfi c=1 sm=1 tr=0 ts=69797de6 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=ujAPmXKLeN-LztoF:21 a=xqWC_Br6kY4A:10
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=vzhER2c_AAAA:8
 a=1XWaLZrsAAAA:8 a=w2VnDfcB3kKmow2GWsQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=0YTRHmU2iG2pZC6F1fw2:22 cc=ntf awl=host:12103
X-Proofpoint-GUID: iMqsGKY4uikHe21eFF6qYmBfdUHNsMRX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI4MDAyMSBTYWx0ZWRfX+IdlMZQ9i6Lj
 FydIGU2MLUlDjneiO8f/bqOKU9rnTzaYxNCVQkYowSuBWntHZN82RgvjLP8pxVvRxtlXfq8+aGi
 ocDbuRkqFM4PHKtPepp07/psVeIi0BlxvuMrSB8fVHC9B0HwAlBOTB1/3J5MkCHLEsQyoCF3s6m
 cA4HIf6UNNtQgx4XvKOccKRvM/n5Vq5FtcBSVly4H+DIu2Lj+Ij7DQMLRfv+wZzONHVPdFvofTa
 RKPNvUFSbtZ98WpDuJG/PSyFcLPDCitwhsOPOHVN/oE4zBxkShP54wRhPG6dkif3nUF2mLRqQy8
 pSznyI9hLkbqV3nUU5IqZw3Pdhq79Y90e98VWwUxpQ5yStV/mR3MqWkueBTj3LEsD62SE5EjajC
 24d8vaE/ymju7FSYGq9aHyBy5AQmGHk794JQ6dvy87Z1eHlu+emUYk8kF8gy6WRUaXy91RIDgVg
 N3oi3yA5IFR8ojcRbzB/CgaueR7dDAOikKr/KtaI=
X-Proofpoint-ORIG-GUID: iMqsGKY4uikHe21eFF6qYmBfdUHNsMRX
X-Stat-Signature: waem9xe9bfncmwz8kb4hf8yqui8613nx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1093418000D
X-HE-Tag: 1769569777-295157
X-HE-Meta: U2FsdGVkX18mnj6bi272mxYZfll+/2+9I0YoOCCWuBQfQbqdxhB/YalTBFzBSiXsdT7bwC1hrzutEPc2y5Q3kFmBBc1kRXJKhh90IuPVCLmXYKr68RneYTq6tI8vemTVx8n9Xm9fY7n8hWs/5IflMiyN7V7dX5v94iyNsOxfol/nFnBDXoRdmsAzHqbJpHRcJ0Ked7qwcwYKSKSr/9s9L2TBjZJdZaOuxrSYrnorJ5L4jzXb5ZqZX3RM1F71j99MsDBIU/mlBZ4LvmlDAlVjs/4LZv2y+qX6ilK6EyxhZ/OaJ1cOxz1nF98a02DftXcVNtVSlEUbFmSuSNTh1nPHw8fDcgh7uqelELpdZkXQ3R7jccjv3nK5g+fcqtszMw86lfbjdZmg37qALty/z+TAnT4oozjLpkuP9ftV0HPop9+ZAoOVtE/nwnicPMwJd3ZXy1fw/K/aRiRbgZNM6g+MSZEftcVYLiMxitP9Eop/P9gP2hzGx5MbFmNCGqoS6qDhMA8DfARpTIqMETJ0yzw+G19fu9jTwf6kNIKq4LSLbCg6OS+uqaAHZzhHGIznHKVR8MgSm5HxLm4/IL9f+PK2+dMPEZYUsVGzm0OCK2J4tIOS6VWk31ciy8xgAVH5DtUwMMlMGTD9o3gdcomdK/MbFrCY4ipLwUpYQMUkGwY+KQfC1lmZa5YGVj/o6n7vk3yiSFHXp2qBs0MUEXeugUb3k12ogb/P5t6H9F8KHHfOrWNy+BK/bumBynrLoBmFTdIKluYzh2xNdCVBcIN80OW2DN7SCZ4IZl+MI3C5Fl6coDUpHHsP/+UUt2/dpTSkxspJ69gkY617KsKHveqbn39kGehI9svsd3lrpHvn3UYgUtVlhieoIUNCL31x2R4WzBg1pQzcAWhyw9B8CdcHhtS9cEncRjy5Swkuc3AIG2lHrDx8r5/pVHb8ExEefJoS5nvRITlRu82Z5ndzhbLWUQo
 Kt2hbehu
 Pc1Qv7X0zntwTyDcRMyWbHp52gwVXgUPf/sNfWFYyWk20074t83URnCLe5MU57QWpM6OQs4mNaBllm4ddHSgTgxv44NKlPGjKP1f4T99yZ6K723b8qKPPBsA4h5+/55YmUBhti90/CvZkTKjNrhxiMwxPvpKtn8FcjGqZ134Vr0Ha8NVhbXZ4kdqjkuE61qYNM2VTIZC+RfRxI7ugIB4IBkVhbwPek/UUmkiChZq6QAZZtKuGPG2UK/9xOjzl19JifwaHpjnTyLE+dtL15xbLQOETtvKH3lvBnznyzJSSrBmkUTL5gdbF2S4K3aWJcbQH7riIy/k3PtSMgD3QmEbZtCTjlegtYcdpvh+kE7VXgsdOyZvZ9N6wPngYueSI5xoYZLU0e2JFprMCPAHSNe+nMGQTfbWtTE3keYPHyHilsEVLY2UcGaiezrpE6hNZsH7yUMnyJmivo2RxRDtYP3A/OvqD+5csvoV2kIWNTqE9nLHkLrtFNoPWJiF1Etr4yg9Xu4/h6GNc68yEuKq6GNtAiVOy2NeFuICkiXE7LpqPatVB0BaFLK1mhphYOwCs1kgRxP7g4WVH1L/N2SEuPH18bDDObPV39Yo8UUnH4jWLveP6FoWlvUu+IhCsU4j8iPaOrvvFyzC2L9Eo6XRukI3U9Pgrt8R+YtrxuB65JSKxYnKb5pLgmB/QLwTngGwC5VukFWu+HGIjkMRb7TN/V14RFIvfJvKrQAN84No7zLF9XeK518Hj2x3yu2mEa+ooydy/eHQ+MXEOQ8qiqrCvIAC2IuTvLbTqawZroV372c3VZ9sSNRF/XxIaohIYNuP1IL4aYdJ2VmHD6S3qmoWV98YDjX2Xqqem7Qhd2C4ClzbP5NsxMkSHZywg7Kzgrw9jQ39y2sJnW09PiHLErsk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 01:21:09PM -0500, Johannes Weiner wrote:
> On Tue, Jan 27, 2026 at 07:31:49PM +0900, Harry Yoo wrote:
> > While SLAB_OBJ_EXT_IN_OBJ allows to reduce memory overhead to account
> > slab objects, it prevents slab merging because merging can change
> > the metadata layout.
> >
> > As pointed out Vlastimil Babka, disabling merging solely for this memory
> > optimization may not be a net win, because disabling slab merging tends
> > to increase overall memory usage.

Hi Joahnnes,

> Is this motivated by a production issue or a more a correctness thing?

It's more of a correctness thing :)

> It's somewhat tangential, but we've had practical problems with slab
> merging and ended up disabling it in the Meta fleet. It makes it
> difficult to identify culprits when there is a footprint regression in
> merged caches.

Oh, yeah. slab merging makes it harder to investigate which caches are
actually contributing to the regression.

> IIRC there was at least one instance where it merged
> wildly different lifetimes, which raises fragmentation concerns.

That is a valid concern indeed.

> In the end we turned it off and noted no meaningful usage difference.

That's very interesting observation, I was thinking slab merging should
have some benefit in saving memory...

> So I'm curious if there are cases where it tangibly helps. And I
> wonder whether default y makes sense given its observability and
> predictability implications.

/me digs some old email threads

Julian Pidancet tried to change the default behavior a few years ago.
v2: https://lore.kernel.org/linux-mm/20230629221910.359711-1-julian.pidancet@oracle.com
v1: https://lore.kernel.org/linux-mm/20230627132131.214475-1-julian.pidancet@oracle.com

Christoph Lameter at that time had a concern about its impact on systems
with larger pages.
https://lore.kernel.org/linux-mm/2df9debe-cbdc-abf7-4db1-1628b29df801@os.amperecomputing.com

David Rientjes measured the difference between enabling vs. disabling
slab merging in memory usage / performance on some benchmarks.
https://lore.kernel.org/linux-mm/3bcfa538-4474-09b7-1812-b4260b09256a@google.com

The observation was that SReclaimable was only slightly increased
(which probably isn't a big deal as it's reclaimable), but there were some
performance regressions when disabling slab merging, most notably a -18%
will-it-scale.context_switch1_per_thread_ops regression on skylake
(but not on cascade lake, presumably due to differences in μarch).

Looks like at that time it was concluded that disabling slab merging
by default probably wasn't a clear-cut decision, given that it showed
a measurable regression on benchmarks and without knowing which
real-world workloads would be affected by corner cases.

-- 
Cheers,
Harry / Hyeonggon

