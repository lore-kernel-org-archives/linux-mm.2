Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C75AE9B365
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 11:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 537636B0005; Mon,  2 Mar 2026 06:24:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E49F6B0089; Mon,  2 Mar 2026 06:24:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B9C56B008A; Mon,  2 Mar 2026 06:24:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A6AB6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:24:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C98B11A0B96
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:24:33 +0000 (UTC)
X-FDA: 84500890026.10.5A46C2C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5D88940006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:24:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Pie4vp+A;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="K/Yx/x7M";
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772450670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VPOh3LoN9ARJo8pXzYeDS3Crg6shVmaNrV2yr/Je5gs=;
	b=WDJg7FE09HmCJNhXUek8C6m466y78t1jBbcXWfNee+XGfW7ROqcQCmMHNkgNaHjlW+6dM/
	Oe0GjPDHp37pcnkyQ3niIw+FqEK+382beuG9JckS/jWNrdym/iiuZrd2iALzVKIk6Br7fC
	4XpC25PROu8aGtTiWReb/Gl89FGF8d8=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Pie4vp+A;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="K/Yx/x7M";
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772450670; a=rsa-sha256;
	cv=pass;
	b=MuPfSSaYEXkjvcMO2B9sI4FcmdoaCZchctJK2fd6rnMgxIQKr4wFqXAbiRauHM1ND4IxPj
	yw0klhXtV9vJ1kolNXyCBNogfEiiw7bXAK3s0dX9wEZBbjXcFKD99qzgKq3ZdTQDhBuhbF
	mdrTGt/0aIQgNugLCz1YrZA+SQfVM1k=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622ArX061737760;
	Mon, 2 Mar 2026 11:24:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=VPOh3LoN9ARJo8pXzY
	eDS3Crg6shVmaNrV2yr/Je5gs=; b=Pie4vp+A4BXs79E6Sn0ZC0uUQcEICfnjsz
	PCJhD3v300DZ1u9NyGg/vI3ymOKYJshhdvbafWeSVFdUlnP1Wp0mcXqynQNQF/Np
	sSIa+ElBrW68k20x05mFQz+THwx8ojpYpNIDQXuMIFLOYbHhwmHpJwyun0f9S3Jy
	Fkc7ZNyhTnHhBg8QYy5sLu4qA5DDkgQUyvkgNy4kQH4pWEpqbkFIqnfGc5qkjvoU
	9x+o04HJOn+DhW/SgEgHvI0eupSY56yHrn/FSQPqVsb2TAWFPz7p07Y4vVImZe2/
	jAdwRi/M/wViwzb40XApLvpU4rRFPrxNPPPievrTSTGhiFXSa2yw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cn96rr1cg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 11:24:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622B27Zh037200;
	Mon, 2 Mar 2026 11:16:04 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011044.outbound.protection.outlook.com [52.101.52.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt8hnp1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 11:16:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PDZHqKxckbe8MimCpsMxshfltqWrluiLhOJ8fvIQgEVe6MLQXwpotlksFIa4qviV/n/oeO4s/qvG6t2le/Ry0++1P/3pUx7VTmQEMgPYR02I4AkA6RJYebXKbuLpGoKIjw265SQv4ByMTwE3fOXKQWnFMhSgjt0W6UMvVm+uZwt6f8gQlxZbzHPTAPxNrz2fZhA5Wr7FtK2jtttihjReCykvX2HRD+KsUpFsLFhgOqG55iEHxYKcbBf/S2Sxg8x02RKWELmpwASVZjunCiaJ+SfVTFJWNybrWfZn3Z8JLIfSajog/HZTcAM9gSPB3PMVPePW7g4Ca9AHCISIyuSEaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VPOh3LoN9ARJo8pXzYeDS3Crg6shVmaNrV2yr/Je5gs=;
 b=j1VjgFeIjvutP/A6rmFBgaRND+3jPFZ8iL4udir7X0k6XxPKYf7+uAug+QlJkI8e31W7CXYK3EZ7+8a+xG6TwfBfcSDmaXli+cxe58zHcsl/IWVgmH3qpjU3a0H0HDUmf8eJ+yhOyf7aCD3Jx5lgwycci+3qwXReAkB5a+4hzD5/6wRg2YDEQn8bDURoGEist27G+Pf+Vl8aD8FxFCcwKm3eK2wZmdYGSIoqPJncBk85MPtiHdjdWP3LQKQuvB/qZYljZiES4Oo4NmnBxdwCVLXmk0Hz8wNL9aea05ccdkqNP9QdzXSd57w8yu9s00chxWt/Tw4E9upX8Le84bXXHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VPOh3LoN9ARJo8pXzYeDS3Crg6shVmaNrV2yr/Je5gs=;
 b=K/Yx/x7M30ePXuj/ZM62S3NVao4o0iStKNNbz3xAwD3ocbq39uzzBfyfKbh7CS2BdRbRKnZ7pirhFX4MZYHPngo2eLtJsSOmwbanKSUR+AQFgagGCi4WHg+dy98KeyZ/5hKGoQyugXESGcj3dJe//2WD98uV84Im5yN9hGQLqFo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA3PR10MB8563.namprd10.prod.outlook.com (2603:10b6:208:571::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 11:16:00 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Mon, 2 Mar 2026
 11:16:00 +0000
Date: Mon, 2 Mar 2026 11:15:56 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: SeongJae Park <sj@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] tools/testing: fix testing/vma and testing/radix-tree
 build
Message-ID: <24c74821-1c1b-47d9-b7a0-2685339316a5@lucifer.local>
References: <20260225233111.2760752-1-rppt@kernel.org>
 <20260226003945.7145-1-sj@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226003945.7145-1-sj@kernel.org>
X-ClientProxiedBy: AS9PR05CA0319.eurprd05.prod.outlook.com
 (2603:10a6:20b:491::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA3PR10MB8563:EE_
X-MS-Office365-Filtering-Correlation-Id: 70b63693-b616-4dab-8f7e-08de784d15a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	aWO2l+kxiOg0nekpOGri4Anak/t4b4mPAVM0UCc/jGyIM6dDUQrGuZR+9iBB3HiVGTqJFSD0H2etuNwudC3E9H/NEubnJQoUZ4uGHwBS0fixI6dQ+4nhTw6+G0KkzUNPIp7E5YqLz6ZUM3GZcWUDg6134hjeyugydjmc3osekOR1jFMiI1NLzKL8FxnhHtqnAV0js4d2mMT4lckKYQA90yd0G8nox+DFnnvqW57hahTWbH/mJYj1OapLILzCXzVD9lgsOTDJnynQdAWs84viQYEa7u2r81ZU3RbbIJzjzL9gNySCj8/x92GcznITc+XpL2YuIQ2hH6UFxVkHru+ISmwxXdwIocFmWlsXon1pvYWHBmFajolj72Pihr85nYX1FniEsvaSVB+PfY2PNaXkw4i4JG9eiXtv7SqLA+C1G3C3PfkCBGI42ygTsvTFR0atzVeC7lXJGHrUzesnJRYJpVahR3I58zyIIOwU9pHn0IepepiquWTUNU5GsRKy4fA9/jpNrUiQn2D8GyvvPZ6WZP2G60cit/icGmBAsWCU6JIIMhUx82CKve35aM4kx4J/UtYc8XPYetvg2XK5vuDcoAUsiYaD8e6sJ2wDG51jKXJ4WO76qeGN1rkPC9Jdp0Utj8giEO37Ry1fiMRenj7XNXMLAbqNwBPJUH0FGemt4f6F0EdSA84o5FJZtt75YMScrOrSsOL06IlUDZc7TAs6c9vAxZ0ae7PZRJCqXFvLgXc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+FK9CIB/cFf5ofm+50dYHPcMavK8/jc9SI6SNasntpkolF6/vc1/nHghU5yp?=
 =?us-ascii?Q?Ps2HRBcD9ar6UzrBTT3WIVZTKoulpYewr06fpRLHjfboBhVdeehdxbKqB6N3?=
 =?us-ascii?Q?L5oXbrTfayAxXd2KoLU3MROHRupb8utTC36LQ20z2PG1vjl2//z6LZfkQNia?=
 =?us-ascii?Q?rPht7ZswqR30SZHlaaf5M+LVf73y+2yvO/zeZ0QZjPIgGi6Hb54AfjImL7xa?=
 =?us-ascii?Q?VkxuHy5z3o5E/+ErjVxvQS9J3xm4ty+a/gzEqDACDD5I32a7W7dFYdhI5Ycg?=
 =?us-ascii?Q?akcsVo7e+srA3BqzEH9vd+FgTMhb+MtV5Hrh6oxMUGRdOp6R8IobOdPt+njK?=
 =?us-ascii?Q?hQzxKM6ppfbeS1zc+9dEtnsjylWrYeQFplPRpcVjri/DthOk4w7yo1Z2yFrY?=
 =?us-ascii?Q?Hg8wCCdPU7wNe4AkReAyewWlhurOEZ1m/Qg7wrhMGPRxcdi6tvVJxTO6IDX1?=
 =?us-ascii?Q?D2US7wNoWMmFxRSPJPd2y8HZ/yjGmEU+bW7cn3cGVwn5T5fFsgbv5vTrSs1L?=
 =?us-ascii?Q?zX93UTJWwhF6boM/jsoP0GlNXygFdQa59QcSvF/rlXTHOELOK47vrMGodP6K?=
 =?us-ascii?Q?mQHIH51xWDxVfjsxiU6x4jop5AplUJLa/mP+56yFhNE8zQMrmXfnInHNa5XL?=
 =?us-ascii?Q?L7R0t5U6tjdDvOOm7nk5OPHffpOaBWIfpw/cTikHYegUX9GhrsKlCa00n0uU?=
 =?us-ascii?Q?dkv8Bdc/lB7zuBQTmge22a7oj5/zbviRoPOnFZvfXEIrzn7Aix7mft0S+mHB?=
 =?us-ascii?Q?LmQuiddUcEoGOgI+SHEKuhUpoqURTBz7+jbR+wbksyuezILYKT4B8BkDDFLG?=
 =?us-ascii?Q?y61EdWEQl57sClOgrZuMmHIs+vZhKOwJEbEtJylrfPsdUhPoqHKeKjMDQOSb?=
 =?us-ascii?Q?/J2iWWvrwsns0zzm7PP/RqJQYJq715rEUv9Yx9MXvKl7KpMAWjPZ/l+enTRC?=
 =?us-ascii?Q?ZeoyQPzYxHR+aNa2TCtATMqeJi9Ob2xhWZKMRMUDNwLBjVXFA/Xjx3sVcaJ6?=
 =?us-ascii?Q?ZeTq0hxILdNPjHQImiac7liyt6k8JX8r4xTHcDDVfEHZfOU3Cj67fjVGxtaY?=
 =?us-ascii?Q?RNcd2QmDdXXfaF2BHP7RF5v7W3epwY7AJFIjJBqF5+xVqqRjN6LuIdfYs+KG?=
 =?us-ascii?Q?fp2nuewAnA8YfbDfMIXme5r7ADvzB2vvhtikBPQg05yaWcXUfINx54DC1e6o?=
 =?us-ascii?Q?EqgCSNDuJIzDX5yO8nJZovrEUWnwdQEoEijcYLIW/+2cWgrC9TMGBcFvS0et?=
 =?us-ascii?Q?+BsXq9CahADplc1cRSWiLOKfx1U0BlRJGGQlANUe64AncDdFzNuFmBsfM/z0?=
 =?us-ascii?Q?Ycrx2Lki/ncLq3U+3TNF/RJlL6wB5M2KpKp+AMhiuH+dfWzg4vWEimYi39di?=
 =?us-ascii?Q?T0soy6EuE/9HBeGC2iW5epQoGQX1PMvEmaTDWVKno6jFo/rNy/J/WqVD11AO?=
 =?us-ascii?Q?i0liw/eQCh3uuTEggWA4rAg8IKo/f04MmxJ7/pDhVHWpVjAnW0vhhoCmaFvT?=
 =?us-ascii?Q?0GpExPEBVQn3sqPcWeWooMUHqP5KBRSNiQng+i7zH/6ia2Okd+8Fd8UPDovK?=
 =?us-ascii?Q?TIGDIzFHzEEMfJM3/7PswWscMmvu1chufP7ga1O7OswDYkLh76pcr/TI2TJA?=
 =?us-ascii?Q?CkM+8AwVPOJqIaNtRhakDzj/OAUAoYUMso8eQbKhvTw+LK0s2Alxj6tG+pN4?=
 =?us-ascii?Q?P44Slnly7DR4MXabzVzIgP8b49cKSsNt3r7oF3aTP746jUQ8JieEcuMSXLTI?=
 =?us-ascii?Q?AJbVb2+/d7MQuQ68ZvmsfK+/ENUiDzE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6M3udumYIikGVE1UcQkCMIvoT4KahD9K3ICvvmt32V1Zw+GLwxbs+4lBRGpqM8EWEwQBKYqrQoYIstnbtZctESKro6xOt6VSBSvYzn9bZF7XWMHNbZbcMbw8PX5QQujTwmm/oyqsUdBV2W4PphreWUHO6FHu6f3wbGUx8880xbQJInEIKi5LLx3YDINnhvIGgvoHB6OhzvtL4E0Xe1TdcxE8cf59xXayj397f2aGBA/u7bOVDfcjDx94WprhQYzOjem7H3jzap0dv/hV2GUvnAOJt07Q8yFkSMyTP+8TxiFZEiYMXDIjuUFArm9l2plYUFikF07wjhCOw91jslbcZU0g+k7fMbPW+9M20S/Lq2ZLWUhas9LiuVyhhd3ERT/IsnKVigjvoT9JiBSmS1n1Kl8wtEZZ6Q4UXiOuxnZkj3ZU/tvpgmwat2/tJGcTV2waD11kon0NOBdrhFoAEf/5ajN87K5IlYgyIKvuCRYKSRIWHiBQiPwjeBWx94cpK9VALsTzlhXlSyl3qJxz+XhniHqKAf8dSLiTngWOhr2LMwZdfbqznWafnGkpxpYWnd7C3Hq4uADQP66QOM2yHXvMqiF08n55CtkeXGDgQSuHtCM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70b63693-b616-4dab-8f7e-08de784d15a8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 11:16:00.5236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /1uqr2MC1GfqMJx4zRXvk58bfvy7vTR4P8gFv95TRaVffvf+pwjLOcYObVoLAB3r7j+6YAYZQgsR3NKoiAi7Sq9Sefox+cexZ8vcit8tsC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8563
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=613 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603020093
X-Proofpoint-GUID: mrtq387ESg8atDIJyF__OXORnt-v6xdo
X-Proofpoint-ORIG-GUID: mrtq387ESg8atDIJyF__OXORnt-v6xdo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA5NCBTYWx0ZWRfX9ymt0k/a8Njf
 Z1gNrUW6u5mpA6VWK364X3PCe5JQ9ZDccQUImj/lvOJ8Ff91HP0a5pQg8FIiJ22Qwz6tkYcUx7c
 RbAQq/dJ0dhAG3NXTsO/5tWRhpuJ2joCBJ6Vx/9ZR/25uoH8d7OxRtzrDJSQPpG4DLH5QvPzS5C
 DDA8Pnzq4CYLjRaVd+6gIKkNkk/0U38YyvI74FiHmSjDJUzVgsLpAib6WA5jmarwYg1CUTsWQ3r
 Fg8TD+F9mGwnjqDNi9r5zR7ESw6w3VB5abAK0CFk74WiA4WnHCiSs1IRZobJRkijx7KUzHBO5Ku
 x3OxBieoNtc6lh3Wdu0k/uY2FkMLsnJ5cphkvmTD/qwNAyP0ht2HS5afFAfp6N9RFe+RK3hLt3I
 hYeSdaVx59WTM7/2+BdWb/BvFEfGZbIR+uhNy1QrGCngx7T5NawVpaYjJdtcRyBLzt+K3KsHcIo
 UwPXwfq2JjBDJdUxYOg==
X-Authority-Analysis: v=2.4 cv=bbdmkePB c=1 sm=1 tr=0 ts=69a5735a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=E2Az1r7JYB0TBKBJJGQA:9
 a=CjuIK1q_8ugA:10
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D88940006
X-Rspamd-Server: rspam08
X-Stat-Signature: oaqghaa4htpz37qf59hms8tjfynpmgpc
X-HE-Tag: 1772450670-59958
X-HE-Meta: U2FsdGVkX18PFD09dVmG2lwkXe/OJ+Pq6O/wn1FevxU+RoWqVmG5xPEMdhSrsM8bs2xLgO7YKaGelkaTOw6jiE9lPkUYEweajqrONJc1TBaT2qFZLYGRBJyZskQLayAA9qhXcGi5ERawWx5JLFyaKfSx4NcRK3vN65ZOz0hK/wBGPMs9JrZPIc9aEc2BV+hWUUbFwXf4HgSBoEES9ukXe4K/LdkrlyumM3OuDyXFJmG7yQhlWCckNeHHorP+PCakIxB9G5ROjSW/fAfGq5SxJeN7I2MNDSeIP2xFf8Ejr6q7fhjlK7VYKV0bHv3KW0CVRZbyWy6QMRUUWKKq/jw3RxQKeMIjuDczbvsvEFmZp7zwuYGo5xQEPQUm6dEvmTCm3HotZqVVVuPB0bgYQyaGZsquzuSj9SGHPbNp0gqwf8p8Yp2zZ+FrjdqSgVDu8vM0RjtnQX0sZqhcIH0G1Q8D0pbZxpLZ+rXzjkOG0f4EiJLdQ2TVYqfF8/fqKvuZ32OJKE0M49xUAsqP/SYHaSLtZZhYsPcvnC4xk29cWh7szYNw5I5VVra1jGAHwkFnlaBEkJXikznahCCmVwWssmdArFdQcZcqZmTU7GqVhzcaJaW3Mb/ljJHpNApnv0w7OWwscHhgmvKYGhJ2SjpzmF1bzx9MQy3/srDzo1hY+ekPLPPXqvxsndAbttqQzVaSM6fnYnVePxMxfDtzCB22mMdc0RaHw6EThiExLSLZuaPuc72XxO0v8d3w5CikxetMn4XfTV67lfB2/IahN9BPm28XqMTGVkQAmDtLfecgyBYBBU7TeHlm0YnSPX3dL1WayXP1Kk0Ejejx2AMTKHI7lw/dZD6I+U1thRgGAmKX5oe92hwkm756zrnTSHRPsTGwq6/i5JC0pPqIRAeJYlUKHUI0c/oWX/VyjIUeozwag5J+jngpuskW3Iy5xVorOPYInYliftPZV7YmHc9IZuIO92E
 gxmew3E6
 v0J54hxJcYwYZzf1L39oQFMMSeuDss5rCHXGJjtWhjF07qe5JMEIfiVzfiFA5aOts/0Vj9fgE7AGINsjhaZRKYvM5BwRndD1cFoLwIeVw82jXivM6rKjMro0KSFiDti/4FwXDrbCn+kAplYz3OsLPOId28TFuwEzyjZmKXxQfrhiXxvRvUFDyKjaZUkJvOtHuRQWgK0bhiOyQiZhNu0UGzzwZsinoE1xsxn52sfQouIlTdgNy1KxF8MuH/ILL6Lhxiqz1V57lE5oC5lyMaiRRNaJi+dh51cxhp5G21dMW7ELbVv6ulXm0BzJu9fRvD/H4VkmGgNzcGFdDtNrn8KOa0EjDwQAp2dOVqfWsWxvku/9789Uueyt/LGayXh/3+dCgnP+J7UiERfp5YLp/cn0kqwYlWnKn1wa0zhbBLLWo3zFN1/IJQAfXgXslo9SME0QzcusiL7rT4EJ5hix3CBjzN+f5b7It0l0OxsyICUf2xzokcK2DCoWBncAhKa0hHntBxqdnxltVJx/RTRg+K1mQXr4CvDtPFKDRKxVhEOW54HlrpoUaPr+klSVl1XlcFLADEFEtD2pVul9wElc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 04:39:43PM -0800, SeongJae Park wrote:
> > +#define kzalloc_obj(P, ...) \
> > +	__alloc_objs(kzalloc, default_gfp(__VA_ARGS__), typeof(P), 1)
> > +
>
> Just out of curiosity.  Is there a reason to not copy the comments from the
> original (include/linux/...) for the above two macros, unlike the others on
> this patch?

I mean it doesn't matter too much, but I think for tools/include we do _try_ to
keep these as close to the original as possible.

But again I don't think this really matters here tbh.

>
>
> Thanks,
> SJ
>
> [...]

Cheers, Lorenzo

