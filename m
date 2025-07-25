Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A07E8C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 17:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FDDF6B007B; Fri, 25 Jul 2025 13:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286E46B0089; Fri, 25 Jul 2025 13:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 100AC6B008A; Fri, 25 Jul 2025 13:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EFBF56B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 13:54:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4D24BBE6F
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:54:08 +0000 (UTC)
X-FDA: 83703535776.18.71E5361
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 529AB1A000B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:54:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QrUVo3ro;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=b3QcFzS3;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753466045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7IJntZIh9eX+NUCjqQ9Cc7Lu7BhXpJYP3BpUNewHQ5s=;
	b=sH95waSMVuPe6vFTGGrJSbaAj+VSKYxNsjmJYGG9v705YNNR4p4jLNouQKojLVw/4aOeUr
	TiAl/JKhzJsXE48Vgmd3yINhKImaLrSbuC9Yj+KEdaPp9jJVrBHCKYcDUtsL+Vs63JmrAE
	FjPhlj4T7Ap3KPJ4KZOG9ln3qkNL2g4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753466045; a=rsa-sha256;
	cv=pass;
	b=6Zf354ObbUihR+vnEQkWg/EmtfUAWwNok7qsrfb4CZWc+rHR9tOZEu/PYEBvBguBV+JGfb
	ibZsATLWmeEG1x+GF6reZ7fD/QRwTP1JcfaDTpo3x3hZnhcLYpFP8vOZfvW+Fvj4Z48R0O
	bY5Dednb/e/XU7PahcRy8cXyVGt8Hdc=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QrUVo3ro;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=b3QcFzS3;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56PGCAh1000756;
	Fri, 25 Jul 2025 17:54:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7IJntZIh9eX+NUCjqQ
	9Cc7Lu7BhXpJYP3BpUNewHQ5s=; b=QrUVo3roPS6KpIqxpeZDkfAcoM23mU873N
	iymJr4Gsphmbs9csnbYlF8FghpmROWN7QtSNfSDgxWRqo2QiZWWzkkfGiUJhbitG
	HBpVCwTx5RK+TbVpfyoETnCw6NXTnMyrjSNZGL952J4OLpEDeuCZO4n7+LskrL9/
	ApBbCCuGwpCzfoliTIMf4r57aL3MASnobhKRfYlpHlQuZSvV220vE3Y31cg9uyeq
	t9d2C+YcfM2AACDWeVXuvdUZMkDkquBxd/LmkJS3LRNlwCMCr+uJXrundtZRO8eA
	MzFWqyCgOmu2t2ArwzNCrojPzUcliVsyQmbanX7ffPMQ4JGAfgCQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1n1h1s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 17:54:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56PGu2JG011395;
	Fri, 25 Jul 2025 17:53:59 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2077.outbound.protection.outlook.com [40.107.100.77])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tdad50-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 17:53:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O2njCyXmXsQF1htzgk+ufaBMZo9IuJDWFPvmvkJNH+8JKihMyE4X6FpvQclrCKw5Vl4f3Kcnrjl9/hCiib9litevjERKXr+4aGp0sFcCoTWRFe8tmh1y+rAxQnoIZnT+iGmPBJQm7CIKU9XuWClwJR4cerm3v9bXa+LlWu9yP51IPWhu3fAUT3WGP4Drc/xfZOasFpYyEsKvorQqbnP1895rTUj6lxTbuo728DmfaOTNV4C0YijwXDdlxrGBkE2dfJ7Z9o8GzfDZzh+aNkhQp9DKSv4RgEfZ29mCyfCvcqIpzY+ptf6i+CKel1nVZTl/14jN7u62w20yOWLQ8w5MEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7IJntZIh9eX+NUCjqQ9Cc7Lu7BhXpJYP3BpUNewHQ5s=;
 b=AsaPNRXXi3AHym+FZrr93zu0paj294tnLXzkOnAeHSnSlIYPxkcIBtyPD6ip2e1nswV5Qa60aeHwoo0lWMe3fGFCqVq+spXlrdrdLKjTEvXLkn1asfSkqmDMo6y09YLY2oWFtUV40vCfzQMVO5SlEjpoC6g6+RJLoYzynd5jPGZgu7k1EfzXJkSQvI+Q2ohjSP0BMcDcWo9lWn/nMoGFv0aIuzJkQBvtywWgMJWTG+KG1f6si62ykiEp9MvN/YBvDYMdE8paXxvL7TiOLeJ/dbUqSHypBzaWoAgUV/XQ4QiRoCu0wsjoiKaymPl9u6jppJCQYXHRCzyTFYC4X0rnfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7IJntZIh9eX+NUCjqQ9Cc7Lu7BhXpJYP3BpUNewHQ5s=;
 b=b3QcFzS3pkC/AkvmR8G5y07I0Q4+QkMrhoScBproj8m++pOn8OPHNs4adAGXgWu9CdWKRT9d9mNTxY4Xtb+/XAySM8/CGyK7DQ87SmLsVszT6xMnGzjZ17Ej1gvV5oJa+i9tfDSIt/OlM/OuIdw482/wMnVuSpEj+oaKYUE1fCU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7186.namprd10.prod.outlook.com (2603:10b6:610:125::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 17:53:56 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.023; Fri, 25 Jul 2025
 17:53:56 +0000
Date: Fri, 25 Jul 2025 18:53:54 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jeff Xu <jeffxu@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kees Cook <kees@kernel.org>
Subject: Re: [PATCH v4 2/5] mm/mseal: update madvise() logic
Message-ID: <a1691645-18ce-4e7f-846a-a5b498df948d@lucifer.local>
References: <cover.1753431105.git.lorenzo.stoakes@oracle.com>
 <492a98d9189646e92c8f23f4cce41ed323fe01df.1753431105.git.lorenzo.stoakes@oracle.com>
 <CABi2SkVSjRV_zz0mhuRF3t3UJM_x=+gct1jbV=qd7eNMPBbvkQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABi2SkVSjRV_zz0mhuRF3t3UJM_x=+gct1jbV=qd7eNMPBbvkQ@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0259.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7186:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d9889d0-e70e-4e86-8f85-08ddcba43a23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?C9BnAhcTJGHkDWOobRm7KMRer6szy3xr/xav6tAW6FgwFVrvMLGfmNFED9z1?=
 =?us-ascii?Q?dv88QNC85t+XUzLbPjh9gv5FocHK7PJpwxf6Xh9ObrWF70GMxScsIDa2T3EF?=
 =?us-ascii?Q?N9o9PN5/sJdn4a+4dSQjRpteYta0GAHRDsSpqUJcYkk2CKRr1+oaZOf4bLsx?=
 =?us-ascii?Q?fMQdJnMgBRgYo7ontHFmSAyNdSUHBsgmI1A4z+AbCZTmyKRLigdWoHCc1W85?=
 =?us-ascii?Q?4pWyqIdclbXXHxmbIb1C52JIJ5Ei7weM6NziCRCdoULX3F9cJHvSkU43YcrS?=
 =?us-ascii?Q?riNdc1Pr8cGSlc9o6AWL/z2g6VlcxUAERbxVcLbogeVDQ5cSyASSPYbPHUe3?=
 =?us-ascii?Q?29hS/E0yvH7RzIo53qU+Rh8bum6t2FX7SKHXKxQDvKmdjdHvTUD1S7HsbUVh?=
 =?us-ascii?Q?UUwuMkNpj+VjQqZujq9VNWTe7Jr5ajyjbcMU4l+Dui2LY6wxp2vNTimcKnqr?=
 =?us-ascii?Q?mXP3g3Px7nifViTIzzSggG/TN+FUIZVlpn6GIjid/hMLY3PT+8Wp+9OaZJGh?=
 =?us-ascii?Q?pSEPGdOiFhOeEB+p9baGSFKIcQHSLUOtMm7Nehi6OCruKNYnczfwXvfxp5BR?=
 =?us-ascii?Q?vItNJz1M5umf/yfG9jxAL6dfvxJmGA9DBQa/Zw+V9RRM2N7X4L+BheASouuc?=
 =?us-ascii?Q?hRGrYac+kf3ozfQx8rLAd3g5xZKALNi5vvmLj91wjGb9IV2ekeZKeI2ZBe9a?=
 =?us-ascii?Q?wXjVs6JgATwRXeTn4Mq1BDRylpOfTm8kev7Vn2B3zB3BU6Z8JU9ih8Wv3oYA?=
 =?us-ascii?Q?W2ehITMCo7PjsKNwfF5R7VDbn2MzYhDm/WBN7TvQLq0Al7DkHht/lVduAF+O?=
 =?us-ascii?Q?+ErsKHRS9cQ4kNmJ/dg5w8Dr6s/aJuBDbNRY6d1wHhzHBQR54d5vaVBcjHpR?=
 =?us-ascii?Q?SQqwYvo5IjsIOHcWsI7HvEcs88Mo+38TuVfL8Fcr12RY46FmGlpjQm6jDoFe?=
 =?us-ascii?Q?a83qPprL1+kHrA7BTIMSnntqmrCNfwhS77UTUe2HAEgPz+vROpi9sAcfIOyo?=
 =?us-ascii?Q?wsXv1B4HnPiJxs0BYmNXg3MmnidZH3i5sjjbBFAG/sS53Jd4hr9xJeseVcZJ?=
 =?us-ascii?Q?v9qOe7t5AXrjKylqhm3mmwqEGZTlGqIhnMEgMGKgaZ7foFNNapC9hPL2/Cf2?=
 =?us-ascii?Q?mK62efucn/Q7GR0BrLNFHD5XD1N2INkANU+WtvAB2IvNgiPqP6sWIV4q7EKT?=
 =?us-ascii?Q?1Wwjk3eBcjOXvw/c+YQTEFuCJ9TAJ3zNq2GxJDbuV/5teDxFx8UO+YrWjpWF?=
 =?us-ascii?Q?csWDzk7HzxtnOxzeaLbI6gBW9Uz8P7WsDAw//BM5N7aSKnsZgeNWEUPyMP3o?=
 =?us-ascii?Q?zt5mzKi1Y7C7zSAvwuK8P60DFI5czGfDujVpMuLt4PoOz3aCZ6PM4+DjhDgv?=
 =?us-ascii?Q?daZLukqhY9DA8GzFwBRlToNj/lttocWr797VcSyB67uKZKtDjA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LYobtwP/Be3nytxrxqkzliLOfZh/KofhpuJMtrn7ISbHAXsCp8fx8ZGZj23R?=
 =?us-ascii?Q?GSSDSNLImgLLjgV70aQAFzO36jO5sn5GJH4p86Iv+ab53JggzqdCGP3du4vt?=
 =?us-ascii?Q?IQoR26KgRFTUpx55oxE9oqvB3oLvHsQAmMqe9QRjgtN3goCDmA7h7M5Fr8XJ?=
 =?us-ascii?Q?V2ihSZfi5sLKufqc/t5qW/smjVCRPnMQostdfOVonS4ks7Uz2flseUEtumRt?=
 =?us-ascii?Q?pukbmjy6x79mSrmr+tLJnD8P/brsksx0sUnQ7KtxFvwt1kZ2mh13hTKbFdvp?=
 =?us-ascii?Q?kMVTA/WJMr3E8dQErzVMWzFkmSduQtDXJvVjEpNJQzpz77u34s4okO+E0SMU?=
 =?us-ascii?Q?ARAnZ0uMmfN9PCOjz/VDFPIN+pSC7vjiGYXTdtIVZRkzLNBwsBAO/EUnr3cX?=
 =?us-ascii?Q?KyIdIQq06nJaXch5wYN1FFTYe1yUKCtiqu9EV3/wIWZEH2Qlb5P8fbw8gGOS?=
 =?us-ascii?Q?+7YHSPAyBJrh4X6PF2b5A/6MC+ZGLmLJZvxsidAUqi70SGh2DahtoQ8uYU85?=
 =?us-ascii?Q?VmdCyRzUZ/br/h2INQVWq6FunTwRZ9+WvtBD9LpQsLTXGD6XNVVUtf99Ecym?=
 =?us-ascii?Q?8+tbVMMZprkXUg9g4avrmYeGkspOesTuwFPyBPDeocjIUrrb91pTEeOfluRU?=
 =?us-ascii?Q?VttC2CHV0PGSpMZEJGl9vcnSU8bw1iGkOE5xXARsQN3udojtnL+sHimi2B57?=
 =?us-ascii?Q?azGzI+LC9VOOvVYTZJgeyq7YOgieYlQRPwkCwmPW4a8XEGekz6rQ66hVGwl2?=
 =?us-ascii?Q?VqZwAHjlLuDMvOGGxuPMK4o8KH9gLVKFKMWWN400OMCo9vULn6q8ovyT9v/m?=
 =?us-ascii?Q?vMd+ZCXhKXIwjUvPjuixvvSL4N0PGjbrQlYo6YqdHFbw8ILWd0tuGIrZ6Nsl?=
 =?us-ascii?Q?axhDkwUYmcRuDcPK6hux6Zz0pZaw81B91ek1jq85FakrAOY38SgQldVmoFWO?=
 =?us-ascii?Q?XVoiwInycies4lyda9Z+P3YCUJ0S8FeSrpJfUIU2hof8bdSdualPl07l1ldB?=
 =?us-ascii?Q?427LnoG/ud91jf5HQGN6JVMO5Ksg5M8ZJJS3tzDm+LHv/TLzC3lfPKP2Sn6r?=
 =?us-ascii?Q?0WK4Edlw7B1DU0Uz/1PGYmbYyoXYqhmU9YeJdeReuZ6z1vVQAj5ljOtBsfQm?=
 =?us-ascii?Q?VWXkj0GH8tspNYiWbq+NPiVVoXHVGTxq24Hhd7sHhpqf/RLLaXtk5MDGiN94?=
 =?us-ascii?Q?KCQTRrVizp2wgkhBGr6qSht3KV3Iy2iFRoRL4BMGmGJi20JVYxs8rPk5Pg+x?=
 =?us-ascii?Q?HCc5cblfITDQOGvYFtDuWh5JeLEHOdD9fznHBj1887WamtjG9LjV7SFeNHqj?=
 =?us-ascii?Q?xbPsf8GHJzC7Z+CW4w674c+/hj0bkVu4wUEX3yjQU/P0uTWqRbtsB92ICon9?=
 =?us-ascii?Q?Tbr9CyUE1NhCURWYPStFdXBAawMePja10aFumd86KSHwHxWlxC9KHwtHWV+0?=
 =?us-ascii?Q?C1S79qbrTA/k/VhK7mTBrfwOyZke6aUTec24TAtWIjddhyptaqszScXgTnbY?=
 =?us-ascii?Q?UKErZfyG+YcqVlPvXCsYqEzZxH3iGRwgI+C0CW8dziWBtVpRWfDUcVHA0Uyw?=
 =?us-ascii?Q?BFykl30kxh+Spr1nbYFb4GA1xU6fdcKqYP/O/ZPDmiL8juwBFm6j2Bxa8yMu?=
 =?us-ascii?Q?Sg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Uy+gsElgS/uzJP4jQscLY94wKszpwVskFyxq6How2BMlo/Crb90Shsv7hTicmFXc+K3i8OFy1yuLh4LLYuGkj6xW6ivXLLVOfWQdYNzZjmVNBWeprsqOEep7CHS49Md4BXcohGqvirDXOxxA/BbAMEiBuQJNMq99D5kLThU7a/Moof/FLyEAx7w1CPuvheHxT4QA3Wo1tYO5vxkQL2nvgML5FHrNNClhmRuvo7KehtS9jmWeEznSJ5rvQE0Ya1EEqE9jrJ6IeWIw9uejPrwZrCrBUYfQMbU4YpJt5lame7Fp7LX12vsoYVJqWKW0lU4gKUQ++59rRVE4DJcv7tF8dKgcbLZTg9ClGAHcQkFPMIGT8mIZd6VPpxYZ1uALq9B8TrjqvhgpZgJ7yDH5s2i6klGXqMNkOX1nTo6c4cGKPZb+sPxBZLej3ozfyLvXW7G1wmfCg9gNb0ercTEpDFVbHOAWiPHwM674k+DMM+7ufRyiEShthIQDzRl6y30srrIWbignFt6kQHVCnTez7+kBLNCO9la8qfedl84MdEyyA7L1C1b2s/0zAldCmbti58C+LJ/pJBeYObgGAdBAIT9GGG1xFDKBNsC+sL3qObda4lY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d9889d0-e70e-4e86-8f85-08ddcba43a23
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 17:53:56.7623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qvMnCtTtq6LWl46VXBtIYFLiTs8gFF/keaJMMuU3W3ZKu7Va9GP04tjhStwInaEsJnG15Ke491JY+FIBQ5E6NEGtwB52mHNx9ndRViTYeMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7186
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_05,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=898 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507250154
X-Authority-Analysis: v=2.4 cv=ObmYDgTY c=1 sm=1 tr=0 ts=6883c4b8 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=MDOVkcc16J-QX9dizX8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: LFHWFVJcRZ8IaMFqzvGPdGhGi6fb7nYK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDE1MyBTYWx0ZWRfX1cGxDJuZMEKX
 egvGjgSQ0Tn5KTtW5c/47pysT6D1wf8cmkTk5bMt1ZQ8boScWJY14B2UYZu7cdVu3zH4U1C/Pse
 wOE4fKAnfDYETjXIO+SIg4Dx3V3EeykUp7N+UMGLrz783BqGqt45MDyI41rLJcYvC1PsVfWya9V
 QTrrrArjr8uNlkMPb18dGfelDONHlD/G5CIwPGIyKOVt76GkSlas67BGD9RPWfNqLuwlQu9FePI
 Cew1dWOF5jpkvo2TBtOEa/CvN7CWlm7TLaq03SWlDKM4voA5jruo1c5Jkuc2OLTKRQibbtPCcr+
 0rtJcQE/zfzH8B/JijaTHlJb1L7X/r6fNmhi8uOR8COiMeNxvO1oEVn5kfnywyQxLDpcdHusnDD
 D+PlAdff+WzXQ20J3//ZNhjil6ugdnYj+nwokBFw2QquQ8KdChhifXXtTfolwqL1uyFKgUGG
X-Proofpoint-ORIG-GUID: LFHWFVJcRZ8IaMFqzvGPdGhGi6fb7nYK
X-Rspamd-Queue-Id: 529AB1A000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: omj7asxdejnfghr6d3atk3144esj1iei
X-HE-Tag: 1753466045-798239
X-HE-Meta: U2FsdGVkX1+MNjDfKcMMNZ1qkJqSr5FLzEHDutBs1SLWsGWWgj61zxtlD3m9mt5zHubK9avDeyDL2QwtfLP1/8T3vTsc/ozpKgSfSQoIcweb0fC9ylPwiFigOeddKCHXnftHwteCYcF8xWOUHnLE7U8OoWKHrHFYkeUvp3c01/C9dJSfQsL0unKor0yL/RiXr3DimdIccUh8MrTWMTgl3Uq3q0L3Z22BS672cnYNP4xw1rssMCEmS7USQc/7kVCYoGelzBdWv74wHEkh/15inP4xmUhAAOmhQ1ZmWivTZR87V2mtA/MGXZk4aCCm0HM44bjwPcWUMfSL2qqGrSD12/WKbaJccWS0n0/Z9hsXOp0dJoGSC77gXL/tG+6MLGmjdt9QFNNYUtXCbXrp1i+BTl7wSC8cJ+Tal8YzvVWsoreUHQKv3BErv5wQyvZqgIwBt/c0702v8d8oRxm40mZ+fAxzs0btDAINkq3VBRTitvA4GqEyIiAOpbw0uCgnm9+oxvWK+FOIBJERQ4AC5ZdwmCo9Kiu8ih3FSGJ5VAzTGhuPEuX+jqqGqnhH25lS8gGl3eLJ5su/RH8mgBsuz+37Sj4RDAav0ECu/oe3MTX49uJGh8+V5TzwKUwTT+zy987XGOnRJ3su5y5OZuvA18AMNaOkaqNdxH/wcrLCwbLXP580To5hxrCgeR+W2b7J8T8gi9a4spvCdIZT6Tk8Saxcz20Ky2cr+FIHCIjdGjWiHdqKCItoQyMjovRmNitfU8cymbNinbnTlsPjoQLiTocgtYXBXoLkY5LPItxPQOiJjPg/8XcDOPzo96Bv7qg2x/vl2Sn3EBmarUbKIyB/0fWT2X2V+QWd1dXIDWwZORaB3ji/MXAcVb+y/3nTflZtYbVyYxbR89zHNVVbzJGYBMZ9Rq0jBpzk68vJSwTdx6sTdg4gswimEmZBi1yn0mLFIh9M+zsZKgoc5jI/pQABADi
 HPFLtXkB
 OjRfIfkMPAXIjxzsy9wA8v4wtvB2itbnLQCKl2u6vkct9kTaPGwJWuSIpiUeq5IJK0v11KtliJWJ/rgsOTXvGByYPXuEGmtErV0mlrOhvtdaO4ItXtrqAj1oSJdR+7N98DZMLoybs9pL1dpRL9fuenB8aYnr/yakwcjB1W5UgzCkUCs1qQ9q8kVO1eGw6n7kUYC+diiS6hAnQdAGg5UyA26WJl6rTkmmVJEyGd+F1SUGCtdnndNwuAlY5Bk9wjp89yeVZ5dfTek59sH5BAoSOqu4xbcJ9so98IQ5gpgEItMzdfaU2esvJr5sP6Xe3Rxz47ao5xLdUOxxun7xDZ7YjXdYCCF4vyFpbcRKusIUAePMS5akWAZQjAzQWjj4UkspDi68RIzIzi/y4LfoeGLgCcd4dOROJH2Fx1olGpgfBBpkHl969hAy88dr2Rzs7/Yj3nP5naodXKxISP2CcCKwcYfBwpep0GwHKDkNKiJ8h/27us17qcTBmLay0QkU3w/1FMGXlZT+qOLDj7gdQ16NQIHuqrRH3Rq5TpIF2ix02PjL4zbYdJZIWyVRhZyISW3OsKf2L++jruJzdfnAHJZvuz0WRdCV/cnLHyJgpYsUegzs5w4vXYYYf0pgTuywxT4WzM8NJ4fQh9IEPZCFIwaRH9LcWe1xHP7FkUFp3Y2JmT51Lvypn+q3X4gThsg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 10:28:57AM -0700, Jeff Xu wrote:

> > -static bool is_ro_anon(struct vm_area_struct *vma)
> > -{
> > -       /* check anonymous mapping. */
> > -       if (vma->vm_file || vma->vm_flags & VM_SHARED)
> > -               return false;
>
> In this patch, the check for anonymous mapping are replaced with:
>
>  if (!vma_is_anonymous(vma))
>       return true;
>
> vma_is_anonymous()  is implemented as following:
> static inline bool vma_is_anonymous(struct vm_area_struct *vma)
> {
>    return !vma->vm_ops;
> }
>
> I'm curious to know if those two checks have the exact same scope.
>
> The original intention is only file-backed mapping can allow
> destructive madvise while sealed. I want to make sure that we don't
> accidentally increase the scope.
>
> Thanks and regards,
> -Jeff

Thanks, that's a good question.

So for a function to be mmap()'d and file-backed, vm_ops _must_ be
supplied.

You can see this in the fault-handler:

do_pte_mising()
-> do_fault()
if anon -> fault anon otherwise fault file-backed

So if this were not the case, you'd have file-backed mappings going into
the the anonymous fault handler logic.

This covers off MAP_PRIVATE mappings of file-backed mappings too, as this
is handled in do_fault() by:

	} else if (!(vmf->flags & FAULT_FLAG_WRITE))
		ret = do_read_fault(vmf);
	else if (!(vma->vm_flags & VM_SHARED))
		ret = do_cow_fault(vmf);

That does the CoW fault handling.

So the vma_is_anonymous_check() here should have the same semantics.

Cheers, Lorenzo

