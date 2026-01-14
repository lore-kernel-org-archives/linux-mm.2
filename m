Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECA3BD37E37
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 14:10:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9B96B0089; Wed, 14 Jan 2026 09:10:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C0CF6B008C; Wed, 14 Jan 2026 09:10:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4417A6B0092; Wed, 14 Jan 2026 09:10:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A90E6B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:10:52 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9C50B9E49
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:10:51 +0000 (UTC)
X-FDA: 84330755502.26.9D4A58A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 83A031A0019
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:10:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lMApnF14;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vf+HDn75;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768399848; a=rsa-sha256;
	cv=pass;
	b=3OPtKgjBvc/sWmqlk0bKYgV/ja96fCJBkMQdIrpLB8J6/ZUpUC4ygPdcDXo87EXCzvCgW3
	OBAKPp5cge9xUCqK4j58HYoUt+UkDvOKx43xGe33rvOSpSmmFifU06UOwacIplnX/hWd8p
	+4sFJTV567JWiuVZ9kGupV5zzgUn8F4=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lMApnF14;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vf+HDn75;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768399848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0n3aLJDI1aAiB6UR/ITzTzgqN6v6SDsXcS3Ia6KlUFc=;
	b=WXPvFd7P/B/1dwt1pBfqebKCCBYoRxaG21aNpBYY8CRkHbn59nTgqSz45+mF6t+1EwThws
	ZCUGQQO8dhzoTrkw0XDlERNvNgBX5aDBhkf0KCQhr4ArBzeyiDwbFnNnH1qGQ4lA4zD33y
	BrvCbHI5zgnJD5fds+xm3xKLoM6I8Zw=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60E6RNHE1362469;
	Wed, 14 Jan 2026 14:10:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=0n3aLJDI1aAiB6UR/I
	TzTzgqN6v6SDsXcS3Ia6KlUFc=; b=lMApnF14LPm1EGovW8uJTTOngJ6ilDXiQC
	wFnFwE/f0esF45ZhZizEimu7labPk0GMKWr9f40dUgpdhyvnuQFNXHOUc9wPFrA4
	FVidg6zDwdIgbP/bjQjPLb3k573XVSaj35loAvzd6RYFr9Ius7xa/waGV2fChD+g
	0eQKTXn6om2Al39TFVaVuty4mso+1cCZD8ufvI9yJsIeCewStwP8V0crZVFyjGvq
	GGN08E0ncmoS3yAIt/g8+4mLO/Pi5SHqJdylO781V+5qLqsQD2DkezzlrmGeZbKj
	PFAyLK19CZDJ2NHYFzMZm/XFilkPehwSzd6M8ssHJoOCCQ9LLQ8A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5vp0h1r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 14:10:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60ECubM6035318;
	Wed, 14 Jan 2026 14:10:42 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012025.outbound.protection.outlook.com [52.101.53.25])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7a3e4x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 14:10:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SCM2zCUAPccQyA1v5x94C1gbeeURudk9MMm6rK4Qkww5xy1/nnRlYf86DeJu95giZ1gMXsC0TVwf2SWo3WhouAlpP1DSW1Nk7Zp7CQGA8tWLaVomskELNFPt0/lbdg5mUom0t8xuo8/qpBBvBXgQ0UuSMKf8oCOgERqvPGSRrUZST9lUKzShHJIThsHljc94ZFy1I8LV7mJEfWbJMjgO5BFOPzNSbSIz2zFM63RqfkBYU79Kj14ptyaiw8RY2CtszRcy4Xrvl8ISV7O9hsuHuQkqVd/wtQYzdlHhGYwqbrvh4nVafJ/aqKu2FZnYWRAfiGTJF8tjzrVZjETdJ3U70g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0n3aLJDI1aAiB6UR/ITzTzgqN6v6SDsXcS3Ia6KlUFc=;
 b=vrKLtykXqWax5D8brsCS8cbVxc8zObw0zVKqkFDY6Krjb8YVheoA4cN93HhdkI3QrpXBEUERAEXyps31XeNnv13LF3wk7K5h/Av8PXwXWJw1/vv1mABRVcXjnG390FuoG6fznYnoUtFF7eSaACzmyUWjhFPypGFh9WOD51U+FbVN6NvKrmA59NfMbMMTarp6fUIcsKjO8yYsH1X3f5Lr8xiZPLtG8wz0Snf8Bjtg5If8VbMNnxWsY/V3rsU+W8OwK5uaK4JPmo7UVEyeasMsM6ZA0cN7/dPNBNdOySL/qSIdyfFINk7b+vkCirf1WbU4ELHCk5cxpGpKKxuRI/BQew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0n3aLJDI1aAiB6UR/ITzTzgqN6v6SDsXcS3Ia6KlUFc=;
 b=vf+HDn758Zfb3GarAaAAMtLdI5GH1fLyvm09mcUUmzBlIrptyVbiTEFBmagVuMjcGdBhuHYd8/u51qEwsre6gKvZhm3aTzBKutTVhmT4qRhuUrvNiQLlDyvYRcuM2z7VnnLWu49rV9ZFv606acrOHljGtUuZEqeH9yV42impYhY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB6396.namprd10.prod.outlook.com (2603:10b6:303:1e9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 14 Jan
 2026 14:10:36 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 14:10:36 +0000
Date: Wed, 14 Jan 2026 14:10:39 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: klourencodev@gmail.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org
Subject: Re: [PATCH] mm: fix minor spelling mistakes in comments
Message-ID: <76546b6b-aad6-4e3b-9a63-1a63dc0a19f2@lucifer.local>
References: <20251218150906.25042-1-klourencodev@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218150906.25042-1-klourencodev@gmail.com>
X-ClientProxiedBy: LO4P123CA0419.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB6396:EE_
X-MS-Office365-Filtering-Correlation-Id: f4db67ae-9310-4d60-8771-08de5376aff1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rV7AjK6rj5CmkpdCRiggMvUbiqmWmwwtDZ0NeZU1UCj+qLnV1kqFN1KgaE9g?=
 =?us-ascii?Q?obGUsO+S9vFB0wu/uuurSuvyhLid2M6iQ9cQ+TupidJVyD+kJJcUjp9oysDv?=
 =?us-ascii?Q?slJg3kgAQm83htn3/1hQbvjiF1H21nkn7N+mDffE+OYIBhGowHLgCRlv2s2K?=
 =?us-ascii?Q?/dsLmk0WVaW77nDOkCKXdyW5DiTBNEMS1tFpTeTG8oWcwuBALoc0ZizNWbdC?=
 =?us-ascii?Q?OuFZWeYH5y7GHd6IxfJGPJDESJ1XrxQvAyrX86VO4TVOZeq32MVHxun7Q4BW?=
 =?us-ascii?Q?sFhsV6h+fEcqxuXwO2lCfIrdSya05hWNGvLD694QM2Ur7ppjNcPhsc3+Uxc5?=
 =?us-ascii?Q?oYMxrNXB/ydTfIZ70mpHpd620yw3zBaplyUc8iIUo9R03lWLQ6sBxojMuL2D?=
 =?us-ascii?Q?mAB3dSImgN1IRE2NP4MGIiNiWXiRPV5TRaX+cxm0QgQMSomXtn7GoH8zE62d?=
 =?us-ascii?Q?tFhpJNzDgahbreTXouBSPLBN2ISPRaPFNW4OQrtbnNRcIcCZyrKbK8TNL+52?=
 =?us-ascii?Q?ydtscGSJAhBJUnJ30XjK8mMKjcf0+PyNfQP/c/KnU+EzNSVvY2NNpVRuX6jb?=
 =?us-ascii?Q?sLu/qvHoM9ueC0mUWiDYx38BsS0sifCcQsopbT1lFAPmCcE3nOy+6oyB86c/?=
 =?us-ascii?Q?9GCZOJNesD/YjlR0pxNCn2UjUbRioDbT3PgOOxqYms9+kKoEAH12hfGS+ZrB?=
 =?us-ascii?Q?ba8GbaNS++J2B7j6Px8rnoi9lIB5SmS4gOZpDbuM6Ic/4oriVg8SBslRv/iz?=
 =?us-ascii?Q?T2/tXuV36HNpndC54STulddoRmcuIgJD/R+eT27ShGnuN0ft+r7tkmE80BzS?=
 =?us-ascii?Q?x0ykEdxlQAHNq5r+ElBZmUDnKZC+oLmOPBlJkQ0pkXCiJCx7AqXjsivga1KC?=
 =?us-ascii?Q?PmDWacCq1GFnaS2ZhrAQlOjfkKQcOB1XQWxcayBFxd8uLEuvbpM3ykoBAy8C?=
 =?us-ascii?Q?tHIl2Om3cVFtEV1q1D8bOf9cfQMGWy04/1yOx9KCQKQrY8xJfATj6n4pYiN1?=
 =?us-ascii?Q?8m/dXYzOtU7KxhHxCAVxNQLv+nSpo6rkmuHYCT3KBHeJnu8d8y0IMOirl1Oy?=
 =?us-ascii?Q?yveTpPrjsxI/Y8rYp4SWyOVSSIBMCtC8jHd8dyWrQThTFqcQa71xqO1FyAdZ?=
 =?us-ascii?Q?Y0k4apYrniHe7TN1q4Q+UujkNNtI2K5ch3EqpmEwuhku6w8w+EcFrtSSRqBD?=
 =?us-ascii?Q?ivxp2cx/GC5Lft3hNtqXp8/2Cxbv2+joMgNMbXDwqyeEDTgkHG6lrrGeJTtD?=
 =?us-ascii?Q?KFmh2phGy1y+7hcNT0SVAb9iZ8zz4xgnUIt+xCmR038n40+kYW5soA+eSoaS?=
 =?us-ascii?Q?m3CadD1yyisHTSdrjbtp209m09/9jKAvy1Fuf4gqik+h5INYBXeBEOuE8fw/?=
 =?us-ascii?Q?WWyrccUxDPmlrPBsFobGevThO8DD7e8cKQlIafdiMfzmy148/FrT3rO14/qD?=
 =?us-ascii?Q?2yF9ffhYkETtKObhjnRJXAjp+sMWDIgfLIOI9HE1Y2Ipv0rn7D5af/j3xKYN?=
 =?us-ascii?Q?7mBTSPX0bdsE2/v1cg88jJ+eoN+E990yzXx6+kGdUSVWKcO7/CS9sEyb4jFD?=
 =?us-ascii?Q?15+0dd4i60XtIzm9K/8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tpRqVg+pZvv9wxsU0RWsxOzgu7wfJ+DTyXFoO2Jis8RT1PG0e+njIZJSVmoe?=
 =?us-ascii?Q?ExeFSpNYo1aSPrZ2Qq5vppCTEDNp0LQnLVKgnt5RcPEyRpqqXNVtmWCTeNR2?=
 =?us-ascii?Q?d5NYSHUk62G6X00xM+R+sEkpXmJk2csEUpJ74OUeT2/UoA7gU3cV159xfs2/?=
 =?us-ascii?Q?lt4kQnZQ+npQt3U2XpIqLVEaIdtB3G2cDWtjCBwB21G2UzXQW34pJ+K5AMGi?=
 =?us-ascii?Q?v3vbZsaFc29k6MaafbSIsRFpPUmwhIjOlBVG5P5x2Yeyjv/87qadtx6uXolj?=
 =?us-ascii?Q?y+eiWlkRX9gFsOvIkb7uG+/g1OKzZtjDJGRFCB/oicmwjXlUF9bQCGqkbWia?=
 =?us-ascii?Q?XmEauwNIddkfDf0rcWCoZhsrU5rOV77h4frZy/jlaf88fl/lCXzyzCT6oq9n?=
 =?us-ascii?Q?4cAeyTnK2wjvv7TWr2U2uqtzwvAvKPil/fqBFcXt7AKoPVc2ZyBgTcyEKe0C?=
 =?us-ascii?Q?6Vp2Ft/5mKdVgMznlzkMnsbizfmbbIIKrJMm/sqh9vn84YFgYfqimDN4JyKV?=
 =?us-ascii?Q?4MgXUsbCu22WYuQdGYdNr89BUftVohF0iRxDHs7+GGly+ViVe5RccAnKnWbT?=
 =?us-ascii?Q?ZzMaw/sfSIP9345bao2LgrbMBjrb1lyimEdb0AjyU8v9E/pWF6MviSGZNpiK?=
 =?us-ascii?Q?3hZGYfqULjH+acsJXx8TCXoJddqospEF18tgu80R2m2eSqOwHSZpVmv1tV0v?=
 =?us-ascii?Q?pX6bDhaEGUDhv/ADI2dGRoh5jXHquedyFvaWnA4hsscrqPfz0UBvyRdQcMIU?=
 =?us-ascii?Q?/Da37Tz4OOB9rrua0eNuOf+/pwSiq0s1yhxNXutUe//+AB8F9g9xn4uiP1Ag?=
 =?us-ascii?Q?vzhI/Vd+//f/eA0H3CFUuVzi93QBf/q7xuDbIcD6vV1EZow6ozdngyfAfFn0?=
 =?us-ascii?Q?zO4ATJ4mxUFdb/01Cj+cL8VWa2BFhGYdZYJL6JhsFGk+XIaiC9nI/nTV8yQh?=
 =?us-ascii?Q?Nmq4OvExT7HKCwy8sR+wDYX7WxF9yfTIaoV0yH7115mwhojhY49zYbMICt/Y?=
 =?us-ascii?Q?qva73vnm65I5btcuAwL/3TXpYoGWG/w96zUqI1fO4afrQXHrT32KnnI9d40W?=
 =?us-ascii?Q?4Jg+0pXyEVVQdidpDIUINOBW95k/BdhySvr2H3+A5baFS1jDyy/kDsbcxyaJ?=
 =?us-ascii?Q?0ySDDkF5Ij2hT7vfQCyHwwIVQtm7W+3/STwkCbKogPlwAZSHUswrrqiKqd/a?=
 =?us-ascii?Q?8iYYcSedDd3qKGAV8pfPjUh4r6v6DY+erUbJx2/xJap7wt+zg8+SPfRuDBsg?=
 =?us-ascii?Q?ntWWmqYjqQDemBCCbBuucnglAQgH2ozkeCCf75zDn1GbxrQ+tP8k7UEl8bdp?=
 =?us-ascii?Q?xvcAKUa3lOiFXagsrzriet/7UqqLgrPs9wNgaiffG6TZP7ODOJB2YfU6sZIh?=
 =?us-ascii?Q?+J2co9QXHtZ8SaQxnhhppCQ/yjp8m+c8myhtR9jDpWpTgX37wtk0QCORdRzc?=
 =?us-ascii?Q?XigiQpbRByPpD/9yQZUaBlFLehSxZ9JCXvwaFH6yDxnl9IhQD4BahnjnysJV?=
 =?us-ascii?Q?lZ2IDGMP+ymakxSWoFQhVHSudgiQU/opLwmXnY488YqmoUjW5tw9scdvi7Li?=
 =?us-ascii?Q?IHH/fcrembIvAPqiJYgZ4UL+0QZBO5wls7ZF90qPecI0uA+NvKr0nXFXHopq?=
 =?us-ascii?Q?U+FCwON6qEBlqmhQh7tRX75aR1I/2u2qxQ8d7qAyXt5SowM7iaVB94Z41A2+?=
 =?us-ascii?Q?R644/ig9q7OlynANSZcvLZBUuJ1B0sQLkraLhQV12sJvQLPHjzesTZQxYwse?=
 =?us-ascii?Q?gk/6o1gm6Zlf6ruQN7aES7OxJszoDOg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KUUEbYv88YZdSP9gu3GZFlKcz6FWLL5N0pGiDhtLLpsbUKrA/kxdqaXyD75+mbhfj1WOeyegAVf9K/t6VILvY3nJ7tnQ1RKioaLVtM4BpRmgFuMd1Qgh+bkO9lOqqQWVoEdIMB/mZl0zXCHbkhKw49C50kbPGpS2yE4wgEm645yJYiQQNpMUMR/mlT0zDNXxyQ4LdP2t783+m7gG6AAmwReA0SoXt1B9lYv8TtJiy1v5HDjuOUKD0mbjX5ecWAt3U0XeaBFr1zF9NgJupXrRy3xo1QBCWi4zTXZp3reqAwnY4vo1qu1CQIXiSp9ZN8ibXAzdVvAttXzMaYgj8dB2HJMybmelB7mqJ/ci4H2WPf+HbbR2u5bPQzSIVpK7CoJv9N4vLwX4wneNOulgjGXIaWdDbyMfsliKTLdXZgVJ/YHNqRBCdmpm6SDQAUQ2RWbPrcntOFmQWS1g1DbCWOXQK3lyDnHWVMm59twyrT9y6zbaUy5xyjii9SONa/HS+3DaqYFbmJ7KBcblVH9zXZPITDgNw43IMpP7RMaz9LTNwl1W5Y5fz5aqkdK+jxN+sdAxVvU+PAiV+GF5eHdjXjdPW14H45mxCSEL010eRQSPEcg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4db67ae-9310-4d60-8771-08de5376aff1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 14:10:36.1396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z0dZM0JsGG4ihy11FqHK3gn5kqVgAjAo55aP50lzd+8qRAXLTU9Oz5ibRlUhTsZZuM5eTfqHL1oh1EMSESykjEoGRGZAwtXurJPGmLBV9gM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6396
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_04,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601140118
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDExOCBTYWx0ZWRfX6QzvFC00iCqt
 JSGn3KVKp3m/WomPDFL0tSPzWq2CJYENf21L0Zy2T6U61jyuzKgMgM6b0zE1OD8T9qhxfqkK2uK
 MZbIuGgXM2Meg9wfxuQyJt/4U8HFBp7NLtLOC7NtNSetVkY3RZTRCA01J4d/04E2w94svrghqpk
 11cu4nCgCjQqBMTFUHC4MQ7xXmrfbnr2mCRqm+Ydh8bPNKkWdcKWParag4aC5gRT04HdvZSmbG5
 imJyIxXjGRQLudU4wZjKnbhvrW0YIIB67w8DjYnHF3bfKiJZgHFK7PUDolRF01iB4oXDPmAQcuP
 D9a2rIqnAu+RQqaretUpDiWSAI/3b6/ljF9TJQDAmybg4KF2ynV9tCkbjIEo4hjPIToQDQfPFrj
 U+4l+0Ej7YDkDe+TlFXRJsPUGgLmf8h5JuZW623BKVUckra/1T2pSbbT0sxKUgaTO2lJIZLYikv
 ZxH9DUqHU3RBs3lCjAg==
X-Proofpoint-GUID: ESbMNuQLoiUX1FUll8atxCm1u6PRNqUI
X-Authority-Analysis: v=2.4 cv=aZtsXBot c=1 sm=1 tr=0 ts=6967a3e3 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=PKATLqCK6i4AbjVh9rkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: ESbMNuQLoiUX1FUll8atxCm1u6PRNqUI
X-Stat-Signature: dcph15hpancsyf65rrbaqw5nfftf89nz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 83A031A0019
X-Rspam-User: 
X-HE-Tag: 1768399848-237268
X-HE-Meta: U2FsdGVkX19HSd2T5ZiByXBBE0RY614n6iRY/SXq6BnxQRJGoXxlvo2KWymrKg/mJ2pqKJC2dYRfEN+JJ5GTwy0rGDIo2F9VgyqEkIiOweLPNqjYxL26au/9xIFVsxKfdaNREAHDxmdOy8CPXMZD3BI3RSpK1gp0oNJbpEHp3DI6osAttFDM9n5HkwR4yXaHNK9TLWnA+G4XJi4/q+BpE0+WQWVTgyQPP6P9IifD3loz5qGgrhEDRcWZUVJMktwTUEKBAOoZB3qatdZ98xdXSP+6/Gwz9rdKrfg8S/nIPUTw4UghilgcuwWgPNtut1NxiwzyM+8QgYx5OPBTaPS9xUkpoblpSrm6hVm3ygqYWw2/XM4lUPI/hAYuGfNIJ+t5Nh1JDQ9n7W6ILy+S36eHdmHAh3/lrMYg3sCxt2H1igYkMnG6OBK9AS6rd5TFbByFAcGrxPDWRVYXOjzUg3cQDlenQPtXNef+yjv/+9y92SW9Ky6Nt/ScJXF9RPaEICwaO6BiDMrXgoc5rs1DsXzuP6AJ4tKV4swPcJ6nb/u21YcscxBy6vw/eo2i3q6+8/FNi07a0scGdXZMQt0jpBGch6DTIsb63V2NwA73bw+QBh9Cq9ti1bXWLZm1Egddpc5WSvl8Rrq+eXC/OuY2To6ZR1AGRSgAh/bHTLvg4ZdAqtEdWa9cjCxCVgjqELI7E4yEkxg1klpYh0nzkAZbfDhrSUj8/ZFfV+nn1Pq3Fd3iI/iIeIHjFBTK30db4B/5blaY7W44rxRVgk7yo7PzcX5f0giZyIhOAjv+8lQEqx+kHPvlsKogebsSbCjffg/Yqy/4RpNZkIK2GuLCzWxgNbO+6v6QEXySclyYoIuQV8PNnlNfxYt9m1RLCBEI2E+K92Q75AeE/oBMaxrSRxIPfEtRjJydQr8spO56fyJEKBkijoPIZiigZ2FbYgGNqjmTqwSmv9WKohAMhONwWIbWlta
 YvOkuk6c
 hDXjqPLoP7dpVmaWBV5qIwfGGFGHkhjl/kAj/j1yB3Xh3PMI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Do run scripts/get_maintainers.pl --no-git on the patch file and cc everybody,
yes it might be a lot but otherwise it won't necessarily get attention!

Maybe not a big deal with a spelling fixup though!

On Thu, Dec 18, 2025 at 04:09:06PM +0100, klourencodev@gmail.com wrote:
> From: Kevin Lourenco <klourencodev@gmail.com>
>
> Correct several typos in comments across files in mm/
>
> Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>

mremap ones are likely all to be me, oopsies!

Had a check through and LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/internal.h       | 2 +-
>  mm/madvise.c        | 2 +-
>  mm/memblock.c       | 4 ++--
>  mm/memcontrol.c     | 2 +-
>  mm/memory-failure.c | 2 +-
>  mm/memory-tiers.c   | 2 +-
>  mm/memory.c         | 4 ++--
>  mm/memory_hotplug.c | 4 ++--
>  mm/migrate_device.c | 4 ++--
>  mm/mm_init.c        | 6 +++---
>  mm/mremap.c         | 6 +++---
>  mm/mseal.c          | 4 ++--
>  mm/numa_memblks.c   | 2 +-
>  mm/page_alloc.c     | 4 ++--
>  mm/page_io.c        | 4 ++--
>  mm/page_isolation.c | 2 +-
>  mm/page_reporting.c | 2 +-
>  mm/swap.c           | 2 +-
>  mm/swap.h           | 2 +-
>  mm/swap_state.c     | 2 +-
>  mm/swapfile.c       | 2 +-
>  mm/userfaultfd.c    | 4 ++--
>  mm/vma.c            | 4 ++--
>  mm/vma.h            | 8 ++++----
>  mm/vmscan.c         | 2 +-
>  mm/vmstat.c         | 2 +-
>  mm/zsmalloc.c       | 2 +-
>  27 files changed, 43 insertions(+), 43 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index e430da900430..db4e97489f66 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -171,7 +171,7 @@ static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
>
>  	/*
>  	 * OK, we tried to call the file hook for mmap(), but an error
> -	 * arose. The mapping is in an inconsistent state and we most not invoke
> +	 * arose. The mapping is in an inconsistent state and we must not invoke
>  	 * any further hooks on it.
>  	 */
>  	vma->vm_ops = &vma_dummy_vm_ops;
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 6bf7009fa5ce..863d55b8a658 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1867,7 +1867,7 @@ static bool is_valid_madvise(unsigned long start, size_t len_in, int behavior)
>   * madvise_should_skip() - Return if the request is invalid or nothing.
>   * @start:	Start address of madvise-requested address range.
>   * @len_in:	Length of madvise-requested address range.
> - * @behavior:	Requested madvise behavor.
> + * @behavior:	Requested madvise behavior.
>   * @err:	Pointer to store an error code from the check.
>   *
>   * If the specified behaviour is invalid or nothing would occur, we skip the
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 905d06b16348..e76255e4ff36 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -773,7 +773,7 @@ bool __init_memblock memblock_validate_numa_coverage(unsigned long threshold_byt
>  	unsigned long start_pfn, end_pfn, mem_size_mb;
>  	int nid, i;
>
> -	/* calculate lose page */
> +	/* calculate lost page */
>  	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
>  		if (!numa_valid_node(nid))
>  			nr_pages += end_pfn - start_pfn;
> @@ -2414,7 +2414,7 @@ EXPORT_SYMBOL_GPL(reserve_mem_find_by_name);
>
>  /**
>   * reserve_mem_release_by_name - Release reserved memory region with a given name
> - * @name: The name that is attatched to a reserved memory region
> + * @name: The name that is attached to a reserved memory region
>   *
>   * Forcibly release the pages in the reserved memory region so that those memory
>   * can be used as free memory. After released the reserved region size becomes 0.
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a01d3e6c157d..75fc22a33b28 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4976,7 +4976,7 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
>  	memcg = folio_memcg(old);
>  	/*
>  	 * Note that it is normal to see !memcg for a hugetlb folio.
> -	 * For e.g, itt could have been allocated when memory_hugetlb_accounting
> +	 * For e.g, it could have been allocated when memory_hugetlb_accounting
>  	 * was not selected.
>  	 */
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(old) && !memcg, old);
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 8565cf979091..5a88985e29b7 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -864,7 +864,7 @@ static int kill_accessing_process(struct task_struct *p, unsigned long pfn,
>   *
>   * MF_RECOVERED - The m-f() handler marks the page as PG_hwpoisoned'ed.
>   * The page has been completely isolated, that is, unmapped, taken out of
> - * the buddy system, or hole-punnched out of the file mapping.
> + * the buddy system, or hole-punched out of the file mapping.
>   */
>  static const char *action_name[] = {
>  	[MF_IGNORED] = "Ignored",
> diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> index 864811fff409..20aab9c19c5e 100644
> --- a/mm/memory-tiers.c
> +++ b/mm/memory-tiers.c
> @@ -648,7 +648,7 @@ void clear_node_memory_type(int node, struct memory_dev_type *memtype)
>  	if (node_memory_types[node].memtype == memtype || !memtype)
>  		node_memory_types[node].map_count--;
>  	/*
> -	 * If we umapped all the attached devices to this node,
> +	 * If we unmapped all the attached devices to this node,
>  	 * clear the node memory type.
>  	 */
>  	if (!node_memory_types[node].map_count) {
> diff --git a/mm/memory.c b/mm/memory.c
> index d1cd2d9e1656..c8e67504bae4 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5932,7 +5932,7 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
>  	else
>  		*last_cpupid = folio_last_cpupid(folio);
>
> -	/* Record the current PID acceesing VMA */
> +	/* Record the current PID accessing VMA */
>  	vma_set_access_pid_bit(vma);
>
>  	count_vm_numa_event(NUMA_HINT_FAULTS);
> @@ -6251,7 +6251,7 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>  		 * Use the maywrite version to indicate that vmf->pte may be
>  		 * modified, but since we will use pte_same() to detect the
>  		 * change of the !pte_none() entry, there is no need to recheck
> -		 * the pmdval. Here we chooes to pass a dummy variable instead
> +		 * the pmdval. Here we choose to pass a dummy variable instead
>  		 * of NULL, which helps new user think about why this place is
>  		 * special.
>  		 */
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index a63ec679d861..389989a28abe 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -926,7 +926,7 @@ static struct zone *default_kernel_zone_for_pfn(int nid, unsigned long start_pfn
>   *
>   *   MOVABLE : KERNEL_EARLY
>   *
> - * Whereby KERNEL_EARLY is memory in one of the kernel zones, available sinze
> + * Whereby KERNEL_EARLY is memory in one of the kernel zones, available since
>   * boot. We base our calculation on KERNEL_EARLY internally, because:
>   *
>   * a) Hotplugged memory in one of the kernel zones can sometimes still get
> @@ -1258,7 +1258,7 @@ static pg_data_t *hotadd_init_pgdat(int nid)
>  	 * NODE_DATA is preallocated (free_area_init) but its internal
>  	 * state is not allocated completely. Add missing pieces.
>  	 * Completely offline nodes stay around and they just need
> -	 * reintialization.
> +	 * reinitialization.
>  	 */
>  	pgdat = NODE_DATA(nid);
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 0346c2d7819f..0a8b31939640 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -1419,10 +1419,10 @@ EXPORT_SYMBOL(migrate_device_range);
>
>  /**
>   * migrate_device_pfns() - migrate device private pfns to normal memory.
> - * @src_pfns: pre-popluated array of source device private pfns to migrate.
> + * @src_pfns: pre-populated array of source device private pfns to migrate.
>   * @npages: number of pages to migrate.
>   *
> - * Similar to migrate_device_range() but supports non-contiguous pre-popluated
> + * Similar to migrate_device_range() but supports non-contiguous pre-populated
>   * array of device pages to migrate.
>   */
>  int migrate_device_pfns(unsigned long *src_pfns, unsigned long npages)
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index d86248566a56..0927bedb1254 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -187,7 +187,7 @@ void mm_compute_batch(int overcommit_policy)
>  	/*
>  	 * For policy OVERCOMMIT_NEVER, set batch size to 0.4% of
>  	 * (total memory/#cpus), and lift it to 25% for other policies
> -	 * to easy the possible lock contention for percpu_counter
> +	 * to ease the possible lock contention for percpu_counter
>  	 * vm_committed_as, while the max limit is INT_MAX
>  	 */
>  	if (overcommit_policy == OVERCOMMIT_NEVER)
> @@ -1745,7 +1745,7 @@ static void __init free_area_init_node(int nid)
>  	lru_gen_init_pgdat(pgdat);
>  }
>
> -/* Any regular or high memory on that node ? */
> +/* Any regular or high memory on that node? */
>  static void __init check_for_memory(pg_data_t *pgdat)
>  {
>  	enum zone_type zone_type;
> @@ -2045,7 +2045,7 @@ static unsigned long __init deferred_init_pages(struct zone *zone,
>   * Initialize and free pages.
>   *
>   * At this point reserved pages and struct pages that correspond to holes in
> - * memblock.memory are already intialized so every free range has a valid
> + * memblock.memory are already initialized so every free range has a valid
>   * memory map around it.
>   * This ensures that access of pages that are ahead of the range being
>   * initialized (computing buddy page in __free_one_page()) always reads a valid
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 8275b9772ec1..8391ae17de64 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -678,7 +678,7 @@ static bool can_realign_addr(struct pagetable_move_control *pmc,
>  	/*
>  	 * We don't want to have to go hunting for VMAs from the end of the old
>  	 * VMA to the next page table boundary, also we want to make sure the
> -	 * operation is wortwhile.
> +	 * operation is worthwhile.
>  	 *
>  	 * So ensure that we only perform this realignment if the end of the
>  	 * range being copied reaches or crosses the page table boundary.
> @@ -926,7 +926,7 @@ static bool vrm_overlaps(struct vma_remap_struct *vrm)
>  /*
>   * Will a new address definitely be assigned? This either if the user specifies
>   * it via MREMAP_FIXED, or if MREMAP_DONTUNMAP is used, indicating we will
> - * always detemrine a target address.
> + * always determine a target address.
>   */
>  static bool vrm_implies_new_addr(struct vma_remap_struct *vrm)
>  {
> @@ -1806,7 +1806,7 @@ static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
>  	/*
>  	 * move_vma() need us to stay 4 maps below the threshold, otherwise
>  	 * it will bail out at the very beginning.
> -	 * That is a problem if we have already unmaped the regions here
> +	 * That is a problem if we have already unmapped the regions here
>  	 * (new_addr, and old_addr), because userspace will not know the
>  	 * state of the vma's after it gets -ENOMEM.
>  	 * So, to avoid such scenario we can pre-compute if the whole
> diff --git a/mm/mseal.c b/mm/mseal.c
> index ae442683c5c0..316b5e1dec78 100644
> --- a/mm/mseal.c
> +++ b/mm/mseal.c
> @@ -21,7 +21,7 @@
>   * It disallows unmapped regions from start to end whether they exist at the
>   * start, in the middle, or at the end of the range, or any combination thereof.
>   *
> - * This is because after sealng a range, there's nothing to stop memory mapping
> + * This is because after sealing a range, there's nothing to stop memory mapping
>   * of ranges in the remaining gaps later, meaning that the user might then
>   * wrongly consider the entirety of the mseal()'d range to be sealed when it
>   * in fact isn't.
> @@ -124,7 +124,7 @@ static int mseal_apply(struct mm_struct *mm,
>   *  -EINVAL:
>   *   invalid input flags.
>   *   start address is not page aligned.
> - *   Address arange (start + len) overflow.
> + *   Address range (start + len) overflow.
>   *  -ENOMEM:
>   *   addr is not a valid address (not allocated).
>   *   end (start + len) is not a valid address.
> diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
> index 5b009a9cd8b4..7779506fd29e 100644
> --- a/mm/numa_memblks.c
> +++ b/mm/numa_memblks.c
> @@ -465,7 +465,7 @@ int __init numa_memblks_init(int (*init_func)(void),
>  	 * We reset memblock back to the top-down direction
>  	 * here because if we configured ACPI_NUMA, we have
>  	 * parsed SRAT in init_func(). It is ok to have the
> -	 * reset here even if we did't configure ACPI_NUMA
> +	 * reset here even if we didn't configure ACPI_NUMA
>  	 * or acpi numa init fails and fallbacks to dummy
>  	 * numa init.
>  	 */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 7ab35cef3cae..8a7d3a118c5e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1829,7 +1829,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
>
>  	/*
>  	 * As memory initialization might be integrated into KASAN,
> -	 * KASAN unpoisoning and memory initializion code must be
> +	 * KASAN unpoisoning and memory initialization code must be
>  	 * kept together to avoid discrepancies in behavior.
>  	 */
>
> @@ -7629,7 +7629,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
>  	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
>  	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() will
>  	 * mark the task as the owner of another rt_spin_lock which will
> -	 * confuse PI logic, so return immediately if called form hard IRQ or
> +	 * confuse PI logic, so return immediately if called from hard IRQ or
>  	 * NMI.
>  	 *
>  	 * Note, irqs_disabled() case is ok. This function can be called
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 3c342db77ce3..a2c034660c80 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -450,14 +450,14 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
>
>  	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
>  	/*
> -	 * ->flags can be updated non-atomicially (scan_swap_map_slots),
> +	 * ->flags can be updated non-atomically (scan_swap_map_slots),
>  	 * but that will never affect SWP_FS_OPS, so the data_race
>  	 * is safe.
>  	 */
>  	if (data_race(sis->flags & SWP_FS_OPS))
>  		swap_writepage_fs(folio, swap_plug);
>  	/*
> -	 * ->flags can be updated non-atomicially (scan_swap_map_slots),
> +	 * ->flags can be updated non-atomically (scan_swap_map_slots),
>  	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
>  	 * is safe.
>  	 */
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index f72b6cd38b95..b5924eff4f8b 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -301,7 +301,7 @@ __first_valid_page(unsigned long pfn, unsigned long nr_pages)
>   * pageblock. When not all pageblocks within a page are isolated at the same
>   * time, free page accounting can go wrong. For example, in the case of
>   * MAX_PAGE_ORDER = pageblock_order + 1, a MAX_PAGE_ORDER page has two
> - * pagelbocks.
> + * pageblocks.
>   * [      MAX_PAGE_ORDER         ]
>   * [  pageblock0  |  pageblock1  ]
>   * When either pageblock is isolated, if it is a free page, the page is not
> diff --git a/mm/page_reporting.c b/mm/page_reporting.c
> index e4c428e61d8c..8a03effda749 100644
> --- a/mm/page_reporting.c
> +++ b/mm/page_reporting.c
> @@ -123,7 +123,7 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
>  			continue;
>
>  		/*
> -		 * If page was not comingled with another page we can
> +		 * If page was not commingled with another page we can
>  		 * consider the result to be "reported" since the page
>  		 * hasn't been modified, otherwise we will need to
>  		 * report on the new larger page when we make our way
> diff --git a/mm/swap.c b/mm/swap.c
> index 2260dcd2775e..bb19ccbece46 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -513,7 +513,7 @@ void folio_add_lru(struct folio *folio)
>  EXPORT_SYMBOL(folio_add_lru);
>
>  /**
> - * folio_add_lru_vma() - Add a folio to the appropate LRU list for this VMA.
> + * folio_add_lru_vma() - Add a folio to the appropriate LRU list for this VMA.
>   * @folio: The folio to be added to the LRU.
>   * @vma: VMA in which the folio is mapped.
>   *
> diff --git a/mm/swap.h b/mm/swap.h
> index d034c13d8dd2..3dcf198b05e3 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -236,7 +236,7 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
>
>  /*
>   * All swap cache helpers below require the caller to ensure the swap entries
> - * used are valid and stablize the device by any of the following ways:
> + * used are valid and stabilize the device by any of the following ways:
>   * - Hold a reference by get_swap_device(): this ensures a single entry is
>   *   valid and increases the swap device's refcount.
>   * - Locking a folio in the swap cache: this ensures the folio's swap entries
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 5f97c6ae70a2..c6f661436c9a 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -82,7 +82,7 @@ void show_swap_cache_info(void)
>   * Context: Caller must ensure @entry is valid and protect the swap device
>   * with reference count or locks.
>   * Return: Returns the found folio on success, NULL otherwise. The caller
> - * must lock nd check if the folio still matches the swap entry before
> + * must lock and check if the folio still matches the swap entry before
>   * use (e.g., folio_matches_swap_entry).
>   */
>  struct folio *swap_cache_get_folio(swp_entry_t entry)
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 46d2008e4b99..76273ad26739 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2018,7 +2018,7 @@ swp_entry_t get_swap_page_of_type(int type)
>  	if (get_swap_device_info(si)) {
>  		if (si->flags & SWP_WRITEOK) {
>  			/*
> -			 * Grab the local lock to be complaint
> +			 * Grab the local lock to be compliant
>  			 * with swap table allocation.
>  			 */
>  			local_lock(&percpu_swap_cluster.lock);
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index b11f81095fa5..d270d5377630 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1274,7 +1274,7 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
>  	 * Use the maywrite version to indicate that dst_pte will be modified,
>  	 * since dst_pte needs to be none, the subsequent pte_same() check
>  	 * cannot prevent the dst_pte page from being freed concurrently, so we
> -	 * also need to abtain dst_pmdval and recheck pmd_same() later.
> +	 * also need to obtain dst_pmdval and recheck pmd_same() later.
>  	 */
>  	dst_pte = pte_offset_map_rw_nolock(mm, dst_pmd, dst_addr, &dst_pmdval,
>  					   &dst_ptl);
> @@ -1330,7 +1330,7 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
>  		goto out;
>  	}
>
> -	/* If PTE changed after we locked the folio them start over */
> +	/* If PTE changed after we locked the folio then start over */
>  	if (src_folio && unlikely(!pte_same(src_folio_pte, orig_src_pte))) {
>  		ret = -EAGAIN;
>  		goto out;
> diff --git a/mm/vma.c b/mm/vma.c
> index fc90befd162f..bf62ac1c52ad 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2909,8 +2909,8 @@ unsigned long unmapped_area(struct vm_unmapped_area_info *info)
>  	/*
>  	 * Adjust for the gap first so it doesn't interfere with the
>  	 * later alignment. The first step is the minimum needed to
> -	 * fulill the start gap, the next steps is the minimum to align
> -	 * that. It is the minimum needed to fulill both.
> +	 * fulfill the start gap, the next steps is the minimum to align
> +	 * that. It is the minimum needed to fulfill both.
>  	 */
>  	gap = vma_iter_addr(&vmi) + info->start_gap;
>  	gap += (info->align_offset - gap) & info->align_mask;
> diff --git a/mm/vma.h b/mm/vma.h
> index abada6a64c4e..de817dc695b6 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -264,7 +264,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
>  		struct vm_area_struct *prev, struct vm_area_struct *next);
>
>  /**
> - * vma_modify_flags() - Peform any necessary split/merge in preparation for
> + * vma_modify_flags() - Perform any necessary split/merge in preparation for
>   * setting VMA flags to *@vm_flags in the range @start to @end contained within
>   * @vma.
>   * @vmi: Valid VMA iterator positioned at @vma.
> @@ -292,7 +292,7 @@ __must_check struct vm_area_struct *vma_modify_flags(struct vma_iterator *vmi,
>  		vm_flags_t *vm_flags_ptr);
>
>  /**
> - * vma_modify_name() - Peform any necessary split/merge in preparation for
> + * vma_modify_name() - Perform any necessary split/merge in preparation for
>   * setting anonymous VMA name to @new_name in the range @start to @end contained
>   * within @vma.
>   * @vmi: Valid VMA iterator positioned at @vma.
> @@ -316,7 +316,7 @@ __must_check struct vm_area_struct *vma_modify_name(struct vma_iterator *vmi,
>  		struct anon_vma_name *new_name);
>
>  /**
> - * vma_modify_policy() - Peform any necessary split/merge in preparation for
> + * vma_modify_policy() - Perform any necessary split/merge in preparation for
>   * setting NUMA policy to @new_pol in the range @start to @end contained
>   * within @vma.
>   * @vmi: Valid VMA iterator positioned at @vma.
> @@ -340,7 +340,7 @@ __must_check struct vm_area_struct *vma_modify_policy(struct vma_iterator *vmi,
>  		   struct mempolicy *new_pol);
>
>  /**
> - * vma_modify_flags_uffd() - Peform any necessary split/merge in preparation for
> + * vma_modify_flags_uffd() - Perform any necessary split/merge in preparation for
>   * setting VMA flags to @vm_flags and UFFD context to @new_ctx in the range
>   * @start to @end contained within @vma.
>   * @vmi: Valid VMA iterator positioned at @vma.
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 77018534a7c9..8bdb1629b6eb 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1063,7 +1063,7 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
>  	/*
>  	 * We can "enter_fs" for swap-cache with only __GFP_IO
>  	 * providing this isn't SWP_FS_OPS.
> -	 * ->flags can be updated non-atomicially (scan_swap_map_slots),
> +	 * ->flags can be updated non-atomically (scan_swap_map_slots),
>  	 * but that will never affect SWP_FS_OPS, so the data_race
>  	 * is safe.
>  	 */
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 65de88cdf40e..bd2af431ff86 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1626,7 +1626,7 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
>  	}
>  }
>
> -/* Print out the free pages at each order for each migatetype */
> +/* Print out the free pages at each order for each migratetype */
>  static void pagetypeinfo_showfree(struct seq_file *m, void *arg)
>  {
>  	int order;
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 5bf832f9c05c..84da164dcbc5 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -105,7 +105,7 @@
>
>  /*
>   * On systems with 4K page size, this gives 255 size classes! There is a
> - * trader-off here:
> + * trade-off here:
>   *  - Large number of size classes is potentially wasteful as free page are
>   *    spread across these classes
>   *  - Small number of size classes causes large internal fragmentation
> --
> 2.47.3
>
>

