Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FEA7C55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 23:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAE7D6B0092; Wed,  5 Aug 2026 19:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86186B0096; Wed,  5 Aug 2026 19:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B75216B0098; Wed,  5 Aug 2026 19:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 687F26B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:33:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C88EE12058E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:33:33 +0000 (UTC)
X-FDA: 85068819906.07.88EC7ED
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4CC3240008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:33:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Uq8z0da5;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Kcoi24w4;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf27.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785972810;
	b=OZeOiUpd38kcQF7UsxSoUzchqJqJ3QvHU7OqboL63Kn/2IAD5eOMQVLjNwF2uRx2z6rric
	DOk17FEUK2U0RHIRkEWv6yZFx6AVfxvHhIvzaLoGaakZGGK1YpjNiJAg3MwFLKse9a8Zmr
	2PUVQ2MA96impp4vagOQqBzXV2tuYW8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Uq8z0da5;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Kcoi24w4;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf27.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785972810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=om9tG1WovzMCdULt2rKDpWFMV6vWWuSnnNH2WcmfVpY=;
	b=IVknckcmBBmon0a00zXL60qz+0p8yyjMg+crT1Fj43RKdwshRDXAeIt3jC1/JlGPTm02ZT
	wddTmFji/Hcan73hEZsxKH20sPAVTzYs2ptuKn4Gtk85X0Au6imBI1zdEy6Y5CufB2cLTg
	Iw/9T2IRjkkBhHO0Bvn6UBBjBEirdIc=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675KuJoV599367;
	Wed, 5 Aug 2026 23:33:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=om9tG1WovzMCdULt2rKDpWFMV6vWWuSnnNH2WcmfVpY=; b=
	Uq8z0da5+3V8RmRtsFMmvgSSFbFNRH4tEQV+By7aUGtegxXkczxKBmbmjEEnJf8N
	qksnxpTDublgVahHelQnLGvkVe+idJWXDAPZx6hfKpUERBzBsSj/YM0Ap+N7zsmA
	9yMctd44K1SIS9LHcJW9BLmY11LUzGkAYe3JDynAN/QXlUihqiObnj08o7qxdTd5
	J6ylPYkJKhk3JCJeM/l8QYKDePRcLnCY/7W5qvb9Ebx0bDdDDZE61whw4N3MH6DA
	RR2qhIla9PObgSKuKQutCnACDNSfnO01HebvkKI70g/OadSXGw5aiFdES5MyerFk
	nTp7HG+4WVwa1jbXGYkfDA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs7cyay5h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Aug 2026 23:33:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 675NUZKE017821;
	Wed, 5 Aug 2026 23:33:14 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012069.outbound.protection.outlook.com [52.101.53.69])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78vu40y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 05 Aug 2026 23:33:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gdVZKbb+iDzXZal1mx/k7k0ITEdDgTwptQz7QxeSHOonKkFLOjXl9cSFNWdQNDODpxjix0yLOQFjho0xzW/tDwqkX9ml5G72Wj7kx0b4IBJjvAXT+38PSnBodAolVx9pBkEVsNIt2rdhWoTTevSqR9dnInhQfAwcDrAejyLwvytjy/KkTS7DK6Uxl95xho7FC2CLIhm6m3HuAWP0NbKY13fc5FOYeji4XRxS2rY5Np0IvEnccLztHenH4YRo8ofbRepzXpm/1ok/Bm1BDYOWILPCrJIvolx1GnKA8bJroukXWKUuvfro4ciH8t0mGAkdmrY82E1uf9ecMlhgg3OqMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g/xOxYvR0cDkaFy7CiygYuQmr9oljaDZ0yklCSF6lPo=;
 b=dXcmMc1Np2S/b6Vb/EgGgXitWMfrxBr/y+BuMtc6h7LO5l9XPbyKYX5tsgF+GZ2XlBhF3g54kMAJCkTapKS0GPBxBzIgIqQkPlmQeoW7GVtdv8+W+GRhtlWpz681NeQK0bMeKd3emLjbIAOFRHRiLy5kuXraI1J0KwaATERYXJPu4OnFGkH4JOMpTnql0rExrEFPUQBV4S3u2Gq0AtCD7C25MCN5lIAKY7M5RKQoS8DztkqH/7vCBlI8WixugsL/4/2Y983r3lCGRlB3x2KWFNL1BxnHwvbqpVRTbYJAYi5URqCGbMhT1Hg/R2P/95ihTHWJaHHjQFuZHBIhH1GNKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/xOxYvR0cDkaFy7CiygYuQmr9oljaDZ0yklCSF6lPo=;
 b=Kcoi24w48bZl5e9kSyJt/09+Aaa8QcLg7eVkg1eVU6pOKLumZNYWu1YijGO0AWUSkS43T/fO+KQ6icakid6JnASvEOuYo8aDG9cMCnO+hgEtKoHskjvvVrnpgh7614198E/KCvRh5Q72y/i6UCWtPZgbP8VOPC9iEutmdfNvggQ=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 23:33:11 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%5]) with mapi id 15.21.0292.018; Wed, 5 Aug 2026
 23:33:11 +0000
Message-ID: <1a2536fc-afd5-4831-b5b9-6d970d29f0b4@oracle.com>
Date: Wed, 5 Aug 2026 16:33:08 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory-failure: fix refcount leak on soft-offline
 LBS folio
To: dayou5941@163.com, linmiaohe@huawei.com, akpm@linux-foundation.org
Cc: nao.horiguchi@gmail.com, linux-mm@kvack.org,
        liyouhong <liyouhong@kylinos.cn>
References: <20260804035356.2615408-1-dayou5941@163.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20260804035356.2615408-1-dayou5941@163.com>
X-ClientProxiedBy: SJ0PR03CA0193.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::18) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|SA2PR10MB4795:EE_
X-MS-Office365-Filtering-Correlation-Id: 54ca2aa2-dd9f-4d1a-5698-08def349e990
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|4133799003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	8J08eYMp5qpFKQ1S45mH1xuRTmj6+9GXlx1hNy9ysBbR7bAVofCbTKcs0mXOvBUOXinG7n85KFvtWZaHH7iE1thnkFzi1PDTojPwQjqzGFsBqDbKKGTlDgTgQRO91khI8unv+J/6VuBqhHvvZGPB9HMPa9yT+SjFbrBws6qcXaN6Z4wpYVKlw0PWXlzPMNLtzotIubW7HzvVr+tH+fGEe0hbPvzw1r7IYBULjlRqHiYuUc5ZhFH06bReKjQIqVUrbFbnsqzHwg9TJGcmK/GWU4t79ZFYw2jUoRxXlyd8Zxlt1ypJ4O4OM8fx/4Xg6P7e1ptttz7f89HvGdWp2/XVQy95whd2SgSY9xPHPasxjSfyfEXksBE293tJJfWocLU2uM1hSmfATl5L6ImBzWfSV+u4QKgV0yrN4faTvyJJWZSr0MHeaBbe3LRor7a5HGLdw6H5u1/+ZOu1sMPWXHZ1GFVzUSAtxOw9BEYb5Nt3rKOGEZHUMdyPh4T7VGiYuYV1UosbwivG6L7V75ygHn1Z12c3dV3YeJymdq7TJs5OXF9zHPlS3/H4qG+qFZjHSlG1+pLZxCVB+qCGMLH5kkjevJJyrxl00nNT4nox4c7CPqoFxpvIYNX3jhQgxxkJtgSOqd79xQOHIO+Nkg4qavNeokCWXuiw4mimwFS35a8eWKs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(4133799003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Nm1vQUtRQnBTN1M0KzZiM25kNTduZjRna25WazI0NzFMVU9Ia2RQSENYTUF5?=
 =?utf-8?B?SWYvMjUxa0hoU2daaDFQTUhNZTN5S25DYmg4RlFyWTRrR0sxUU5rTnFWUW5J?=
 =?utf-8?B?eXF2akNFWlYrNmRUWG1iK2xSMUNTeVp1VWlyRUZCT2VtRXdraGJHN1Z5SG9G?=
 =?utf-8?B?VlliZERjZEkrdnl6eHhNdVU4dEttZFd2R0ZkUGc3VVhxNDhQTmRGYVI1TmhM?=
 =?utf-8?B?NEpQVXM2VTVRREpzdTN0ZnpVZU9FbUFjbXVkbVZnZS9zdU43dFpxY1dWY1Jw?=
 =?utf-8?B?ekh3QjhKN3MxK09yY1FEWTIzUk42UE03WkYzekRuVSsyTGpYRnJqV1BCYzk0?=
 =?utf-8?B?cFRWcFg1Ky8rdWJ2NjdlRkppS3U0NU1VOWR0UVdrK0dDY0gxb1BHSGRCdDUr?=
 =?utf-8?B?USt1OGR1enlXY1BIT2QrOHF4dDlQMUhrRlZtMXdZT2t0SnZtWDZSTEp4R3NR?=
 =?utf-8?B?SjFKSVRwbFk3cmRBVGg1cGFuOUJPbXNJTDBBNWRja1FNTllpMlV0TlJEWTk0?=
 =?utf-8?B?cjliZEhpVFlQSWVrVWpma3k5N0JJbnhVMnFiTk5Mb0NFbEhZb2NJbUJZVlZj?=
 =?utf-8?B?L0NySThVeWNJT1hWOWo1L1lRWEE5T2VhNE5TNmZZdTdFNEhsZ042NmN3NHNn?=
 =?utf-8?B?enpCM1lrMW9ZRHZuMmQxc1lnL01GeGhMR1htMk9oYUE5OUNzK1VlZ0ZWOStj?=
 =?utf-8?B?eE1aRDQxR3l0dEUrVVlMbi9zQjdKZitlaFFMektiQmNmbGFxRWt4OUdNaG9m?=
 =?utf-8?B?K2VtM0F6cnRRRnlGeEVoYjhsQ3ZaVjNEV0tBTmRrV3pJbjhiZkx3RVFzQ2Vw?=
 =?utf-8?B?NXhyN283SHJqSXZzRFRna1c1Qzd5K1hacVFMNFpKWkl6ZWEyWlhKWWtJUzF5?=
 =?utf-8?B?Q015VTUzaDVpaTFjL3pCSEFya3BqNGNoRGdDaU5uVysvOThzOE1Sd3NJcFVP?=
 =?utf-8?B?d0pWU2M5WGd5Uy9zcXRZWXc5RlMwUlM3UjE5QVJCRWdxclQ0aUZ6Z2VFcFRx?=
 =?utf-8?B?UzFkc1FVZzRVTzYraVdwaXlXMFFacHJ0bUI1WW42djBCdmRJTU5yZ3VCZk01?=
 =?utf-8?B?OVBJRWlpNGJNOXYrTDRoM0VJOWVLcWtGeXkvaGZWSmUvZlh2ZVpONlVaU2xK?=
 =?utf-8?B?UkNnUUdwNnZmZDlMTzQyd1lIRDR3VjdtMXFhZEdHOTE2UFpKOGVjMjlRZk02?=
 =?utf-8?B?dmJveHJESDhwdU1lQkVWUTFNN2lscmlBMHJLcytQcHlObUlWWkdNZ05US2Zs?=
 =?utf-8?B?VUpMTnZCRVI3TEVKZVdNTm81djRCQmlhM2pWbE0vbHNNTUxHS2hlZVppaGFi?=
 =?utf-8?B?cmJIdisycktHVWlVZktrT0lnK2dkK3dzZVgyWnN5WlEzS0dQWUoxMEQ4OUo4?=
 =?utf-8?B?T3pHaXVJbmlGWTB2UyszYjJRWFBzRTVROEZOU3JxL2hFQUpiamJoYlVGMDV0?=
 =?utf-8?B?QXBIbWl5Q1FPQ2JBeVZOQk5EU1o4YUNMb1lDOURYbmlUK3JLRGptL2Y4MG84?=
 =?utf-8?B?WXdoTExPSXo5SENPdVBFWWQzeVc5MzJEeHB3RjM5YncrbGhRZWlRVHRBaWpZ?=
 =?utf-8?B?UzE2c1NySWlyL3hGa0sxYy96THBVVnBFclhJY1o5a2NMenNWUlRUSGRjK2FD?=
 =?utf-8?B?OUNLcjA1dDEyZ2ZPWE1MQUVldU50aE9qdnI1cVg4L0g0RVB1RVpsZE11SmxG?=
 =?utf-8?B?ZDZhTTBOQThKVENFdkplMFJieTExaG0rVDE2NDRZQXdibmhucUtiV2ZIVXA1?=
 =?utf-8?B?UmhUVlAwV3lOU3VUbCtMQjFNeC9TU01OeitEa0s2QXR2eXZoOWhIaHVBV3Qv?=
 =?utf-8?B?QmZVbmVWUUNCYlVQZlhiZGdQZUowNzZteUZYWVRFSWdTdlZsamdMT3FSNmZT?=
 =?utf-8?B?UkRuVk85M1JyMlV6akkrbDVXazMwTXdTeXkwTlU0YlZGMmdndEcwL1FXenM1?=
 =?utf-8?B?YmI4aVBJTUdCcTF0d0NxUnJZUktaSHYwZ2gzTUtvZmFmV3hDY2U1TEhxV1Vi?=
 =?utf-8?B?SmxEcEovanY2K2ZMZGNyZ2RNajBNUng4V0pHaXlvS1lyaGpjQWVBREdkZDVo?=
 =?utf-8?B?dGp0NTFPV296c1ZkUnNLSHkrRUlDVk03M3BWb1ZGR1MrcjlUWWJIS3BTUzBq?=
 =?utf-8?B?b1lxRVMxTGR4YWszVUhVV2MySVh2SEo5Y1E4QjVUL011a0k0V003MDBGQjVT?=
 =?utf-8?B?VkFpL1JYUU1mMSt3S2U5azBRK0NlQzNDeTVXVXhZV21IUURBdERHVyswMXJt?=
 =?utf-8?B?VTVrRFNDbHFJRExmajJWdUZibnFIVU5FbzJCa3NoelFFUlNGUjR1N1FPOUhS?=
 =?utf-8?B?MWFKRmxrWVNCVmIzZ3E2TlQ2bElnNjRIb0taWElkMVpzWjB0Q21lUT09?=
X-Exchange-RoutingPolicyChecked:
	S0QiJDfPgw2BNCmaKhGWignmXHEs0HZdDIIznfcrRy5Mn+r9+PoJxMoxn5wYtm/PgpbXw/GYBtIk0d6H+jSPXEUG3HjfE/R+2Cswq0pSScmTKZidMRKCzyt1/ayFaRNXGo/9k9PM7v0RZs2YA+aL9ti9TOuTlSOV7pAfxBFXCzx7wqnY682q4HTDkfw3YVANdyLaHi1TcasEHvF5tfThlI9NFLu1zBmHqCwnryf12xyiJDaQ+6hz8wpJThC9xjoiAfj7rctOJb8zFW1MKAb2FD07dxY9TsWpqFEre8hvESp4DsTTpGF4se61pRfn55nXMB878SHCsBbxPl9WmdWAvw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4ESVJ5wkcqDhcu2RjvEkjPeh+WqrIPl7fQqZvGyVfLGm6xYHJs9gXvucIRLr64k3sAJl+NBv08goPA1UqtytCZwVIx8A9cEbM78bl1Ob5Xl9QTMEGopNMWl42z4HJnMHPQELAyLraFQvraa8JC/crqBC3NiBIjN11Wbyj1nP4ORW0n6ZOnbrPL5r8TidyDm7y8Gd3a5rebrLK3JhBCTQiM4Z4+ThI/mxs8Izt6uJkcZxc4zWdh6/SJCWHjIcyzXyxEwdBSly3H/t72iEUTaXgDGsKXNSlMhdTRc+gRmIWM6vPsVZIdSzEfXQ91q5iGB29B84khy3bxtlGsymFRu5Zbt4wB74zgck26uF26S/0Sm8x6d8e+BXatm8oLC5wObJSGdfZGgeXy9Ag1OQyDTAvfDG1kZmp3ClCdWfQSVs46+e58YEIfBeY4ulPkhYmPT0QDAjf+78diBUwwsFCwhH1tsiFvOjmnqDbfGmIzS4Hvo0oHhfYErUcNRqB1gGas+XnfjVQZkDDeZYbdVzW7Aajh0+zvkFDWbvaCVOZuRlia4ipW9myC2tdX76YJSRcGQOel96ZVUVfSwnmZdcnh+0lBDw0d/DY5SYJxfXF9yb4O8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54ca2aa2-dd9f-4d1a-5698-08def349e990
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 23:33:11.2626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eajY6GxQxmObbOCa4l44Vnqf1sfu0IsClFRfPJVfLpGU4iTuy0FAHXF8xjFdnXfJ4n1e72zpmIPstEreqJj87g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_05,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608050192
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDE5MiBTYWx0ZWRfX2nKYopUhnl1a
 3GN625VskAgwx7sxD1KAP9ne7MRl5KwAr2CykjXBPNy0qe2w9+sBobHL6UN1PwA7+6ru7MVC+uV
 fD8d1WQ9JPoECGJbF0mck5UBE8HKl21q+xZQ3TqWq1r86aO9dYJ8
X-Proofpoint-ORIG-GUID: KJTauSM9rXDzHlXRWBaFDLdoNfK8KFYw
X-Proofpoint-GUID: KJTauSM9rXDzHlXRWBaFDLdoNfK8KFYw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDE5MiBTYWx0ZWRfX20j7MAuf1zbY
 nOpkBv/Fem88/SRodYYZ7YHLFg5EA49HNqQweFjhwqM2bbZneUNoWanyEB8lt4dmDDkfzz7c64y
 dhR95iAAtn2cW7CSRjSJWa2zvtc+FihXK/yY87w2F64qaPns/Uu98G3fipZxfUILzaXOK3crffi
 QkfHsP9gmjexfCQrH/az3z76eScx/9tqxt+JLygeFs6avirZMK/HqUYZZ+Arbsif1oxDzw0vDg6
 DGH4lBh3IoXkISqju6wBdNCX2S9ceFqnB0C9ExP4/9SNvBMh/fpcykS9jLmyqeevnImrQ8tDjW7
 CbseM2YmurRhq2dKQwlj+rW3DzzMU3gLJwn02+fPKfeFTteVWg3zXvw30o9NrfnKtLApPhTErjm
 yn5PuFqIx5zNC+HbkXUFzDLHl2B9IL0R1BiiARMghAYMjJjmZvtCPcATbWGq6Wf3zW3tikHvTnB
 e98erb7rwHQ8UifTt/g8aQikMzIPccWZkJ8cnA6o=
X-Authority-Analysis: v=2.4 cv=TsPWQjXh c=1 sm=1 tr=0 ts=6a73c83b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=RpNjiQI2AAAA:8
 a=VwQbUJbxAAAA:8 a=Byx-y9mGAAAA:8 a=fw24WH7T9zRrfIxPuPYA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12100
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4CC3240008
X-Stat-Signature: abk4uozzrdmqhwzfceqdm6izcty9xm4o
X-Rspam-User: 
X-HE-Tag: 1785972810-769856
X-HE-Meta: U2FsdGVkX1/fp/LVR7u11DLxf6vfzobaLtD57aYPKlhHVZMIfOzWdHk9L7whURQbP1n641+Pzcxt/zOETHHiTJsS2vKaE01rkuT8qMw5VSqjYcu2AZQUvu+ajQJfE54oaezl5p0mt0ZI6bcZ6UkFnmasF7YX3rnMTsfAj4dhYL7Zz+wuNtgD1IaKok7uT8OcsdgJSqgAvhGwls3oREVkSu8OKnjI5/4kIUPt/nTDAcRZyTQBvaATv1wdQa8D2dsyQtL/HTu+59BYbweAMj3xYqAmFW0wdj2D5vpOLUzxPU98hF0adouOL/pKdpLLtIDjSscsngZYNyApUyEzh8FF0aQY6ny49PC52kF1gGTFyHvQRyCjD6EFYCsD4Kr0JcvCBxe7UjWJwnsOOPG6un+vewvlU+Kgpi47LweUSC7RFlTrvRy/NRx6NjtqAYBbeUm2t93zHf5MPhmtztRaC0N0l2IHGi6eZ6GSbHzp+b9ZxNN5b1ac86dFkAkIdGdy0fLPhkv4gDx7+WzJfVyLr9W56aLXeautP9v/EvXGnF/9V4A7gDFhhKWB3JW9LPZZwPPr14OVx8Wn59GYAfUKD43GtLyunR8M4BjBjFWn80556gCMITcuPOC4rnWuDHCPrio46XAqy6fmjlk8vhHE/r7J8tpFZXOvB90+k3vpny1hdRe/N2GYOUnj8acV5axmRvH9aLB2hsadLwXx9FWuSJmQmUSR9LwvaAqiMQ5KYYON7cc1MyYypmj2jIXvps2Gr0hAAfh1kotj24MRY5xCBChDerJ2HRCnBdoPcW7OWfRv80BGWYAqKnYeUke0FI5Eainq1Z7vgCwfCrAIi8xAco6+YLGs+tp+nOl5/+nfMhDJ006SkEsQviunfGb9iYTBJqvWIceSrBfcrvO/hsCFSdS6dloOJ8rHLjZDSZSWiH1TzZokphqcw+0N0THWeTkWBkCc6dziurQ0rAlCtV+Kzi6
 TckPvmbz
 X8qy66Wo9EXWcp17PwRQKRPPhJ9DBL7JRLyi5IhdW5xhDABq129Ck9FaSf8OsGSyxwI/TCJoqG0oqQJkFGt2AwycEmV0/2mAx/D+4I6+Yx/VSsAZ1x/1yl3Otq+CsHH/rdEDAI2bmu6S8zbt2ZqoRUsuC8VQ4nuHFtiZwhAXtehZVeEOT+CKf/Kcv7FAZRLFAvfWS4Jvzf14UkcwW6crqQ72f1x4KztW2x/vJx1DDEnxJ40Tv9ozSuqm7UXNbZJv42BbsNj3fq6N1K1UCsZ92NW9zS/LPmm3uGAV8nPMKmAC4m0EpM7K5cZ8ZxxkA0fITDNEgBDFzSU53jxwp+YCFeAZ4sLdGK7wbpTI6gGKKeIu8mMHHsu+4LTEdANToKDh+QuCfLMAo2g9GAfbZFEIdqhHYZphQx/D9CsCJfE46GoDA6YZrGQRnEK8A7iBC8SexCZEBEipew3kqkxZ0D1+SqALqIPsjt+KgnmCC5ndjRkuzPT/rz3nRjV8SdLQUdcbpg46nDwu/d7sGuMc7PZWe/5JxZZwjGbrFZCWzgk4H6zSfznRW2My3yWj2bw9jyYBmYNXVf+QTO83rdRY+FWzciFgrNFjevqqulDKb812EiOqjJaXC/k+IK9M2mM4gzwveoQshboi9verT1iL0v3PwJYLm3GDJedw7PQXiTLVjDKJywI4FRxE/82jf1w62UsX9NQ6ETsKK+ZrFP/Dep7vaInN7ovk5xZzPcm/Nstrb8syHT4VprNKomV9CXRTx/7uWJgbl3E1QLu/8Oc7gIadmGJ2o2W7wNrX5BCQ3mcVeTr8MBwqlV5egQ8zuBahGdX0cWEmp3ZORx/zw7d32q4o0HuRXhgUUYZx08delsQVGLZOZEUeI2m3UPfCHcu7+9uS8pDYcp3IqOi5tN5KybWSimTifJPBoaYrTbAhSW+sg+37MkHav8aJRq+Pu8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/3/2026 8:53 PM, dayou5941@163.com wrote:
> From: liyouhong <liyouhong@=E2=80=8Akylinos.=E2=80=8Acn> soft_offline_in_=
use_page() runs=20
> with a folio reference taken by get_hwpoison_page(). Soft-offline skips=20
> splitting when min_order_for_split() is non-zero, so large folios stay=20
> intact. That early return
>=20
>=20
> From: liyouhong <liyouhong@kylinos.cn>
>=20
> soft_offline_in_use_page() runs with a folio reference taken by
> get_hwpoison_page().
>=20
> Soft-offline skips splitting when min_order_for_split()
> is non-zero, so large folios stay intact. That early
> return -EBUSY path never drops the reference.
>=20
> The other failure path is fine: try_to_split_thp_page(..., release=3Dtrue)
> puts the page when the split itself fails. memory_failure() also puts
> explicitly on its analogous unsplit path.
>=20
> Handle the new_order !=3D 0 case separately and call folio_put()
> before returning.
>=20
> Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio h=
andling")
> Signed-off-by: liyouhong <liyouhong@kylinos.cn>
> ---
> v2:
> - Add documentation for the folio reference counting convention of soft_o=
ffline_in_use_page().
> - Remove MF_COUNT_INCREASED related description in commit message to avoi=
d misleading.
> v1: https://lore.kernel.org/all/20260803060001.800638-1-dayou5941@163.com/
>=20
> ---
>   mm/memory-failure.c | 17 +++++++++++++++--
>   1 file changed, 15 insertions(+), 2 deletions(-)
>=20
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 51508a55c405..3b1e6946821b 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2776,6 +2776,9 @@ EXPORT_SYMBOL(unpoison_memory);
>    * soft_offline_in_use_page handles hugetlb-pages and non-hugetlb pages.
>    * If the page is a non-dirty unmapped page-cache page, it simply inval=
idates.
>    * If the page is mapped, it migrates the contents over.
> + *
> + * The folio refcount has been incremented before entering this function.
> + * This folio reference must be released before the function returns on =
all paths.
>    */
>   static int soft_offline_in_use_page(struct page *page)
>   {
> @@ -2801,9 +2804,19 @@ static int soft_offline_in_use_page(struct page *p=
age)
>   		 * NOTE: if minimizing the number of soft offline pages is
>   		 * preferred, split it to non-zero new_order like it is done in
>   		 * memory_failure().
> +		 *
> +		 * Drop the reference obtained upon entry;
> +		 * try_to_split_thp_page(..., release=3Dtrue) handles refcounting itse=
lf
> +		 * when the split fails.
>   		 */
> -		if (new_order || try_to_split_thp_page(page, /* new_order=3D */ 0,
> -						       /* release=3D */ true)) {
> +		if (new_order) {
> +			pr_info("%#lx: order-%d folio cannot soft offline\n",
> +				pfn, new_order);
> +			folio_put(folio);
> +			return -EBUSY;
> +		}
> +		if (try_to_split_thp_page(page, /* new_order=3D */ 0,
> +					 /* release=3D */ true)) {
>   			pr_info("%#lx: thp split failed\n", pfn);
>   			return -EBUSY;
>   		}
> --=20
> 2.25.1
>=20

It seems me this will do -

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2802,8 +2802,8 @@ static int soft_offline_in_use_page(struct page *page)
                  * preferred, split it to non-zero new_order like it is=20
done in
                  * memory_failure().
                  */
-               if (new_order || try_to_split_thp_page(page, /*=20
new_order=3D */ 0,
-                                                      /* release=3D */=20
true)) {
+               if (new_order || try_to_split_thp_page(page, false)) {
+                       put_page(page);
                         pr_info("%#lx: thp split failed\n", pfn);
                         return -EBUSY;
                 }


thanks,
-jane

>=20


