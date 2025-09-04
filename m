Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48311CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 19:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 891E98E0009; Thu,  4 Sep 2025 15:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 841518E0003; Thu,  4 Sep 2025 15:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BACA8E0009; Thu,  4 Sep 2025 15:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53A6C8E0003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:07:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EAC8413B0DB
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 19:07:34 +0000 (UTC)
X-FDA: 83852501628.14.5F35E99
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 41C7E180016
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 19:07:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=g2Bjj+hU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=i1ywzufx;
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757012851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yvv8recZd9uf9C+niawdk9QzaiUyaCbr2D47csTyeJI=;
	b=K6zHCBvRXn3Ud1tSFUJM164t2kGn5J9/8X45RYDpObgeXzMOVRlyPz6ToQPtSJSkhEZOPA
	n/ZgbuADKU82ejslmo9elE5Pij8hAp8Ozy/FinxbL6f+w0yOjViJoRCm4FJpazL5Mg+r0z
	tsIpk8ZGiQe7JSVwTUCOOLkleRiVTg4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=g2Bjj+hU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=i1ywzufx;
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757012851; a=rsa-sha256;
	cv=pass;
	b=o2evhDTRbwGvbusUGwm6wJfji3uVPvRGMLDMGuo2Qcfk7AiX8O+8LS7tnDf+mRgwRUXNTW
	clMYgFIYHzC5hVWrZbedO0J5rP5uzQIB1K95530UTsGQMlOEpswx6MjofH+j2buL6WPZC5
	MahmTuzUUPFa9nn/E90LR97FGzftcW0=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584HsqO4026284;
	Thu, 4 Sep 2025 19:07:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=yvv8recZd9uf9C+nia
	wdk9QzaiUyaCbr2D47csTyeJI=; b=g2Bjj+hUThfrmafWsI9sV4Kc5ynchEXV73
	NW2Fuq/o8CFswVvun37MIIs3RkPSn4nN3DDcQc1xOrWfdIAkKxgheqJTClvas+tI
	b6+k+RsItHW5bX9TBnNZ/drbJ8IQLh3GK8/ByXugoXTRYLxwnacxD2tGf4s+Q1o/
	NPiorvcMCd1gZiik6SaD1ZgLS8hfn3xhFoId7anTe+TkBYIvgjNZkrR/hvPoYEKJ
	ImJ3GjGDao8J7ZTvnhCR0X5DxIIW+txzf6VNKu1trLwHKeoNrMXyeXpn2MRTrRZO
	cHAoADwctENf0Lti8gh/0ZEWj6wfjG0sQWHJi86LDqEjX4KFCsFg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yfk2048e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 19:07:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584IUOJA040757;
	Thu, 4 Sep 2025 19:07:25 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2060.outbound.protection.outlook.com [40.107.96.60])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrbnp38-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 19:07:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NZGn+s/+cPRMC103vpbOO3kS5jJazmyZ/UhMGMW7W5zjBl6a36/xmciOPYDn8EiPw9q6Yjw+C+KtUic0YyDWtjCgUvquh3E9MLSFy0vCboJSJ7rmblIxQa6qw6uJ1Xo8Os0H5R4f4QaoHKxAOPVsx3xLtFzTHi3zh3fBKpZyqk81lUEUpFIH+k9PJxc4Be6TQmUc2uh7Toek+j1AWPBlV9L4LXhAxMMDA0jnwV2ghj8FcJ1s0iHzTWY8nX+pVehjw6WJSw9/89M5KA3kWqwOD3u8hRhwEDfQ73B3/oAvvTI99hj9HbeAyI1ZFnQegbGtCvzG9Dd79DfVBwoWGWa+kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yvv8recZd9uf9C+niawdk9QzaiUyaCbr2D47csTyeJI=;
 b=sAsgUNtTX1gY7ymIIckCbs56PM8P/7ROAqREp1L5GqRnudaNHbzrjBqWzsrmSevTGp631JYt+7TYnyD3Z2BiQwm8wemSS7rP298LlLXvQbOZ+g4t7bKORXkN04aLf8Mkgiz0Rb5d0hCorkk/QLv9tztj+xVfGOLtLjeUOF7N0QBMIop5B+BE/CloudYVgmNXnx34hE/OG9EQVv/VVu1KDbd6c/9Y5KhGEX632woOMOm94B5uY19Ck4MLLXKckBuZ9OKInWFsVTy54dez9Po5wu0rnJ5xJhlka9YpiH1Celch1q++P+lzTsGlAWWzCBEOnu2+Y+O9ohZ1Q7bmeziqxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvv8recZd9uf9C+niawdk9QzaiUyaCbr2D47csTyeJI=;
 b=i1ywzufxVy+U92ym87lCpRHdzN9BdYWb+XA+Uj2GYigUeBMxL2iUBQVDLq1Zjq/stRTyRPmU0DWgqiUV5LPMHMw6/rwRTjmuoYwbUWC2XefEpRzS1r+yspCo8T9aDM+xw4111maMvDuyV0PLrc1h6AuPgWa1w7yJPkz26NT7hlE=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS7PR10MB7322.namprd10.prod.outlook.com (2603:10b6:8:e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Thu, 4 Sep
 2025 19:07:18 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.017; Thu, 4 Sep 2025
 19:07:18 +0000
Date: Thu, 4 Sep 2025 15:07:13 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: kirill@shutemov.name
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org, Usama Arif <usamaarif642@gmail.com>,
        Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH] tools/mm: Add madvise tool
Message-ID: <6ynuammf2mfrszwuw5km4kh63ue6ttt6hknfjavfybk2gzwrj6@w473jonqztqv>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	kirill@shutemov.name, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	Usama Arif <usamaarif642@gmail.com>, Kiryl Shutsemau <kas@kernel.org>
References: <20250904175729.1029735-1-kirill@shutemov.name>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904175729.1029735-1-kirill@shutemov.name>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS7PR10MB7322:EE_
X-MS-Office365-Filtering-Correlation-Id: 80bcaf32-ee60-406f-a415-08ddebe64476
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u2zmajdCRt+KSyVVuNUWUWoD38Xx8S5p36z5d4DIb+wKW2WT+T5hb1U/TT1m?=
 =?us-ascii?Q?7tYl59OaWRuo6IYnYeJg33LOP/x/2SnQ7EN2zqBfV5/3UlQ2PqTBZ1c3mXtL?=
 =?us-ascii?Q?gNBHsOAjMqbi2OCritIrqzWf99Vj12bmduUsEKmoO4stcMUyr7P6C1OOPG+O?=
 =?us-ascii?Q?0/Fd7HUUS8lKzRJVu5/r5WesUMno62L0GdakqHCpiMdSz3ODo02fC/tPsHF7?=
 =?us-ascii?Q?t0hRA981eqETQCxtMsar7CHYoO5AGXO/xI6NMX9kZXpWYr3j+SD1pX0dK4Wg?=
 =?us-ascii?Q?kRbok4Gf8crnl41+pRyWkfmXWkgZ1vpqMpkKEkZbe5zWm0aSIFHOjTy02uKR?=
 =?us-ascii?Q?p99v9qAl5YIftqjsFsmOS+XzvVtYUlR0MMQXLVJO7R2p+k0sdSeUiisGWyM4?=
 =?us-ascii?Q?NVuO66MXuCcCVhWqoYWHvc7NXsI7UmNOOSZeeDgt7LrTiI/d8GyoG6HTrGYO?=
 =?us-ascii?Q?uLFKJlzg4VFjoYpQGXc0Op3IWCsrwMow/qKmqtxVttaiWcUe/spsrNLoB3Sh?=
 =?us-ascii?Q?MaXQT7OWvM6VpQQj6m6PVH2oDS5FlmVKU45x7NLeP8j4bY57l0TYcQKs+mUB?=
 =?us-ascii?Q?HNPLfTvPPkpd928GHliSgeMbW6eYpxi5z8TStJUlR+i8IBZmlITnhw+Hqi2C?=
 =?us-ascii?Q?5stYpBEpESKbozJlIqiwcbuPeNJ8x0p/LWFr5IFnZHG43lF/ADNuS6v58uJc?=
 =?us-ascii?Q?PM3+VxZOQtx2K99QeSLRuxKFmmdJYw40WvQRXTeYianT0BbPsYksv9vy2i9/?=
 =?us-ascii?Q?ltVQOQaAlQ79kNA0UQdzzGnE+Hf4n3J2qCTbqLlW/VFAr1sELbtKIIcyxqbZ?=
 =?us-ascii?Q?h6uYGdEKLFtrHQgCsbsrZDMviLfO/Go62JQ4aAa9bX72Vck6XYFOtpXsbdt/?=
 =?us-ascii?Q?5lXz6hOd9YLNyBL1D7XF8183/sDXFgi1Z4E0wvNgo8IgS+Ohz0T/cJqxA28V?=
 =?us-ascii?Q?1GwyV2LmUdb+bYXRTuneEmiiq+jd8MuQwXjeO815ZZmLli/BxqSo3YFfbf88?=
 =?us-ascii?Q?md0INVZwbd1nvvUXBK6bEUC1Bg99q2lSQPOI4k9P2LDEfB06tlWssayQYsAe?=
 =?us-ascii?Q?JNXLz4XNN/LhP8CyXxvraRdQdaXjvocAHMnpQrH1GLQcddPa2nDQQYnvkMgz?=
 =?us-ascii?Q?eZrFmr7rfBHp1dVLjABWpgsjVSkwInwuJ/64mZ+iMCOIwbZMzal43j/PPAkB?=
 =?us-ascii?Q?DBq2mkXifNY0btcYd2Gg/9YB9Qm+KA1CaF5I9cC/L7n0Q3mRvzyfE9M6w/L9?=
 =?us-ascii?Q?iIu5CE5Lcm3ESBgdQScA9tAUAwagyaeIJLhKi/CP0J/80ujR6WgyEfuvCj5A?=
 =?us-ascii?Q?HyivPpVNZY2TBH9OWRYEbBtWbeBfHIedD2ApTc1Y7hpvWAk2ShU04zUK28tO?=
 =?us-ascii?Q?Serr6cIm9DPIOMHIxZJugtWZv+VBRstRAo8aymfhp9DvL7bIWS7MtayLVQLU?=
 =?us-ascii?Q?o1pXzSqC7Ug=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PkEZrMZvoROpJyDi2KwPbjKfj1gYiJzOH1SLIbe1rgNWIfTw1fguJ3q6y/S9?=
 =?us-ascii?Q?uFR6gN/pFluzww5f0BT5JJB2VKHNKGzKRZeLAY4R5gBpX+3JT5+pdIMzhrZK?=
 =?us-ascii?Q?hGM4cdjZmMvxS4z13KWQ2anOu6M8I/yTasAC4LZKLlngJplynj9ahEJbhVmU?=
 =?us-ascii?Q?PtI6yCrZmAHitrEqkHD3yztYP+5nZpp3TSAJb1mhyjpP5B6LDD0KkH6COkma?=
 =?us-ascii?Q?xJ5k4XNeJ1KOVH+P+MnQiaOpUUjK7TVk5pakfiBsUa/sF1CHiy4lZywXu8kD?=
 =?us-ascii?Q?XOAwbUYwE+GnfgXx9gCtaBajo2wwEmrWWm0huDiXuFr/ScJCGkFPXQckf/Za?=
 =?us-ascii?Q?pEPRP1bx+2Mfd3Hm8PUjiWB/wNDcLIUf58TnBafPwc47Oj0LmrGxUxpJu75X?=
 =?us-ascii?Q?AE35FnbzRkDje0YZYoIf76+7vZxOdaN9RrbCZrCAcMj+XY/NP5Vx5pHG6cJ+?=
 =?us-ascii?Q?OEQdZuFvL4FejkTOjv9ROWDYclMGDJ4jeAzbXKsyZRfKESCRVqv7y+Ds+jk7?=
 =?us-ascii?Q?w7u32NfLRzH0xzo1K4RC1+7CuDI0tx9RoZLdMJh/KqVbsbAq4A45yfMPUEAQ?=
 =?us-ascii?Q?yKyjpNWUDzb1iM8OO6JzUTQX3TrRG7uFXRKqyYOc8gOTyjpx9osqG1YVJoaP?=
 =?us-ascii?Q?pvf79nAoFy8lrj/ph4CRSocRiKUilQKPWMSbyPBi1BVXi+QhvAYH7CKjr+H+?=
 =?us-ascii?Q?UPdjOosKI3JBIB6dVQI345Ut4Vf2YIvd+IrZfnNQ+IbyHgaLhdr4U03IheXB?=
 =?us-ascii?Q?/gPG/hxJYkbZbkffUImYWy4jSKZN5W4rbRAkjRG2yewB128Q3nNCKTw0B3e9?=
 =?us-ascii?Q?VPIsngQ1XAxgPRmDLf38/JwS7E9el9wmuplcjcdcmivPCFHagZe3evm7iEBO?=
 =?us-ascii?Q?UDkD4YVvwAq2QLRTxHAwF2Uhj8zRqosxSiT3iHgkTyfmjNI1a09D9yh4bAAG?=
 =?us-ascii?Q?drzD9GjJYx/OQjeH5lbIhhDlkg4EYIVuCzj19vQYTFKtungpShM4u5BR2uTD?=
 =?us-ascii?Q?DVCMs4AyvGflXq5/t7h6Mgb+hDaMDeYYu8874FdHFtAAzop/5uMBxVjTfZaF?=
 =?us-ascii?Q?0DceFHfwKJKPPJ7P1Ojtb8/EJkUCKKDIPBY2YNYrLoa6QE4rF0qZVjHbsyac?=
 =?us-ascii?Q?VXmO67VNg3RcDcbKFcKVHE9psmruG8nrJkvTQwNsNsB8CRn0kmwqb8NRDLKG?=
 =?us-ascii?Q?AtWzApkj6iOf3HDLL04i8QyQPJ3zr9pkfGwdze4sqW8Tm6jqF8zAqvfWxH/5?=
 =?us-ascii?Q?N4eCe7yczkLkcEONkXxyM0rbnM6jlhuLL3LTNVKYtYCuvzUCSR52lM0b42P8?=
 =?us-ascii?Q?OUolCDJmGLnloFqajGASr5SEOZsXfeBaszU2Vkh5e/lGdHhEfzsbbD5ZRHR+?=
 =?us-ascii?Q?SRGXKCokGe5mpmmpHcbwP7wTusA3aQGfWdxBnMva4nLw6ZVBNZprJIMFPKCE?=
 =?us-ascii?Q?saupLOHX41jR0PvN4+OfV1eCLR11miBl59x8u36OPT+Z3uiDSMwR4q+jTQsm?=
 =?us-ascii?Q?jMfQFTh2wZgzB3mmd9clZ/Zu+0PjqzXR1abEZ1wPO5NkPLJIJh/7nOpcjT1t?=
 =?us-ascii?Q?as0siFuobT0xomFg1m/z/diqFk6O5doRQaWcfrFK?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+5RYpgG+rGXc2j7/4nfyRdWNtxMRu5GSPZyNSouKbEpu+33Q8JdGE9E89ddMJZ9F66QPxYLkHlE6nPIEmcNLFugqNIAnn1WvKjKHIW6mcAHC1PNPE2cr7wyWQ8CrwqznBvvY6iU+GyCJyDvvYl1NPgjNNc2G4mkuhE2o7W3TTa+cch5nGg56V9HU+3ykFV834dGKvx4QBMaYfRjRLRQOyHOfid1jypGXIpWjGjWZfoNQTJlJVjCrfigkNmT/h/YJ7sce78j4WdtPI79lin73pQ0uibSFhHtmFoeDFnRTXkGMaQ4T5IwAuDJLIQkFcDKXuG42pV5mPayCyB8Ew8frVHUQdMS/JZub0ZVdlk7QuA2tQjdqtnNG245mCZAEtajqWTKJXODTPTD9FwK7slwwYVbTSPwc3CZappBP5qvcqA3v3QOX9wrAijevufgaHL/uzldkDDRr9Eog8Niuggp/Cl7b68A+Cqw0QXW6IYRkKhu18zHk+XbqDJpSsS4hQKsTeOgbqgupFVGUu5/Od0jjoJigNKWoA9RTTB8nfO6f+rSg30crTnkARDZ4qxb06peeKBlXpdLpO42xWZVqvMT0Zu/Rx4zHFZuYnthx8kMHBuo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80bcaf32-ee60-406f-a415-08ddebe64476
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 19:07:18.1457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P8LM97/0mBM+ssPdYRvWLXd4VJw3cwsBA7L/I70v1usZBo3xYiZ76tmZr8BrSmyMTcrJRJ7X0P5kJSW5frMhYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7322
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040188
X-Authority-Analysis: v=2.4 cv=MppS63ae c=1 sm=1 tr=0 ts=68b9e36d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=qvTEentxbt_f5Pyo7rQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: vIwjN6lZ2GqIkyuMVb8zvpPSuApHB7hB
X-Proofpoint-GUID: vIwjN6lZ2GqIkyuMVb8zvpPSuApHB7hB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE3NyBTYWx0ZWRfX3mWftAH1BhnB
 blAWdC42xIBbfNUR9ZwzpU4M6wXvjfHLTk25N6cBz0ReJOOMUW3WuqIHcpgLCX/Ydu8eGbIVMSf
 UBwZkrKGV6Ro4ua+IZtgYCPNVXSaCZFAoPNmrY5d6m4X2/L78Obq638dQT3cUi5rmt8RivY3AdR
 QMY/lekJEcyavz4Ga25Wbr+os2GLkjteLcovMldy4KDxmRUo9zdP2b2ANpHdmTzW9xTPejvlriT
 XV1NGdEWGUrOLHpifTG09PS0Q1INyuhtJsYiionmRpaq4hGggdnK3n1KUT2jq5q3PtOZUAfY5Fe
 pMwea/t0zQPzHMXsPryFn/rCeUYxeDNFE0KPCrLyRE/1aJXTgxt/qrFNF3NzpjJhDXhpB/w/JA3
 NQQlU7z3
X-Stat-Signature: 87dsbtzbjbfk7ashj1j54najrj8rskxf
X-Rspam-User: 
X-Rspamd-Queue-Id: 41C7E180016
X-Rspamd-Server: rspam01
X-HE-Tag: 1757012851-135225
X-HE-Meta: U2FsdGVkX1945SvwHJi/f+jhCnarxGV5d/xtGVEijQNZjh7In2E3I7++xG7L0iqAIeO02Jz2jV67x7isV9iNnJCXahvAERtJR5CgaxRRGvaipArlx3Dr1RE9BBpGQxWT0deJYii4ewd6qEoDBB54f+D0AkdAGV3CszThiLSnSP9FVRMsxwIPYNXQjd6DleTO7qvsDaTGt6H2vKszQuPH9hjDv+IloEemKDqb/fxkVZP/jN9HQXNCCSDuyzIC7/0zgG0rSUhu2jL5xinstvpzPxZwE79NyOllItzSjb7+Q7AaFVqKk+VKU9BfrODx3QNLZCG6KRYAZz3gwR9Au0JQ0FPMHRE/4J9gOoibBqc3MfjnXDBtJWSaHXWv7fAZJEIoyNDb6LuUJI56X6kkEB4ZFlt4Jlzc/gE4OLrAYtsVjfGU2wJozbwLWb9zxzcuejoWHwYEipSYVjmM/jnwoSIciPbz1wgzZl1sAjaBDnLXp3uZ4TIIz4+HwBPEADyER8UbWIBAa/nOBKSnzGcMgT3i9GoKg6dRlzfwMuvXSAFu16rIM0B5A+8/rbT5w8tCQPfAGRn6XbUFxP9lQuSiSdBj3Q0vUdRzbNrYM4knJSk9Qz+DLK1UwhuViAC2eML3LAMQgeOo/mzOw350JFQzWk+1k3myRM5RfDa1HQjoKjQAq4PVDmdiSbT1kxPWdLqMj1clagy+28mcq40lXUOWTgQqRXfOSf+NuNtLj8VKkzDe0nNBUcDN+QKv8DDQ0IdFFvD2KdeXs2vV4peBIU1NYX+AjydYoGZh8couEMvrtTxzGtpnfxOKSM8RQNX3CNwfLTFO2Kto8LFTTY+ykInRYFRiWzZvK2xu8lLokvIJfeJ9eUE1D9YBrEQqMHVrxFQuzIqFyT6LM2lfWhIDB+8RouzjWopjtNivvflmxzta2XV4ZlKmGdtAg965gC8Jh0qgWroYFEwVUUq9IAbwK6djhaa
 QdS0hA57
 rOWyXY4cbpjHD3fmpQJ8lQjh9TxnJzhesDMG8CXiHIlFvyDflx6y1eZv9A/4E2MLFIRZzv8cD3dL8FyMsFANelHNwv4uHre2RXEWOiKDPEfk3PLeudaCgHy8jH+VoWJM+X/DAPu+3eDjrmgsDSHulFR8nsxAYG/By1TIdc8b9AA1recuuYeLMC5zTe528S05LG+wnMlD1qlD+HnLWM1BvSdJlZ9ipu00lfE6IAEeHYn3F6ck4MUTQvfMgBM4J5rRr0Jl8qRS1wCo45KieaFU8pZ5VJbmRUy/oJ9trgmIEzYznlp01aFcKuO4cgb17/8p9vu2JvLVccQ1QsyQCNHZOIU3w5VUisQty9/ksIvpKtztaTR8xtQ7ue45LNkNfdDQq4WUhAo46brzJqk546eOA/Xb31dDZJTxXzmW+3oDilPjmDo9A2oMMlhOfbhcjnfSCtM703Pnfrg5V06H5KJumJUqZdAANjDFBbXwE/VOKz3nj8K14qS2JgIOU4hUAvPmV7Lk+v4WdJtjXdhXfEiASx4VTRYrpVulKyXWvQZeZiL8zcylCY1bAI9aZnRjHbhnLXeuT4T4ETxylwEfNpuWC/Qk7fJZD0a3VJIbKBbTkv9iN7sGT7jUYhx5+WUlz+IlyJFoO8LWFbNk9+C3BQjBqKgSLs05HwsO0tvuczDeFhGMKEKCT5hyyEehfI5B4kwMFHgHWrrW9nlvoKrMWwMIqfpK2LBSndL6L6hyL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* kirill@shutemov.name <kirill@shutemov.name> [250904 13:57]:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Add a simple tool that allows to issue an advice on a process or a file.
> 
> It can be useful to experiment with effects of an advice on a workload
> without modifying the workload itself.
> 
> Only supports advices available for process_madvise().
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

Nice, thanks!

Should this go in MAINTAINERS?

Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>


> ---
>  tools/mm/.gitignore |   4 +-
>  tools/mm/Makefile   |   2 +-
>  tools/mm/madvise.c  | 170 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 174 insertions(+), 2 deletions(-)
>  create mode 100644 tools/mm/madvise.c
> 
> diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
> index 922879f93fc8..b713fcf4a2e0 100644
> --- a/tools/mm/.gitignore
> +++ b/tools/mm/.gitignore
> @@ -1,4 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -slabinfo
> +madvise
>  page-types
>  page_owner_sort
> +slabinfo
> +thp_swap_allocator_test
> diff --git a/tools/mm/Makefile b/tools/mm/Makefile
> index f5725b5c23aa..db315a48adcd 100644
> --- a/tools/mm/Makefile
> +++ b/tools/mm/Makefile
> @@ -3,7 +3,7 @@
>  #
>  include ../scripts/Makefile.include
>  
> -BUILD_TARGETS=page-types slabinfo page_owner_sort thp_swap_allocator_test
> +BUILD_TARGETS= madvise page-types page_owner_sort slabinfo thp_swap_allocator_test
>  INSTALL_TARGETS = $(BUILD_TARGETS) thpmaps
>  
>  LIB_DIR = ../lib/api
> diff --git a/tools/mm/madvise.c b/tools/mm/madvise.c
> new file mode 100644
> index 000000000000..038b3e1076ea
> --- /dev/null
> +++ b/tools/mm/madvise.c
> @@ -0,0 +1,170 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +#include <fcntl.h>
> +#include <limits.h>
> +#include <stdarg.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <sys/mman.h>
> +#include <sys/syscall.h>
> +
> +static void usage(void)
> +{
> +	printf("madvise TARGET ADVICE START END\n\n");
> +	printf("Arguments:\n");
> +	printf("\t<TARGET>\n");
> +	printf("\t\tA process ID or a file to give the advice to.\n\n");
> +	printf("\t\tUse \"./\" prefix if the file name is all digits.\n\n");
> +	printf("\t<ADVICE>\n");
> +	printf("\t\tcold\t\t- Deactivate a given range of pages\n");
> +	printf("\t\tcollapse\t- Collapse pages in a given range into THPs\n");
> +	printf("\t\tpageout\t\t- Reclaim a given range of pages\n");
> +	printf("\t\twillneed\t- The specified data will be accessed in the near future\n");
> +	printf("\n\t\tSee madvise(2) for more details.\n\n");
> +	printf("\t<START>/<END>\n");
> +	printf("\t\tStart and end addressed for the advice. Must be page-aligned.\n\n");
> +	printf("\t\tFor PID case, it is addresses in the target process address space.\n\n");
> +	printf("\t\tFor file case, it is offsets in the file.\n\n");
> +}
> +
> +static void error(const char *fmt, ...)
> +{
> +	if (fmt) {
> +		va_list argp;
> +
> +		va_start(argp, fmt);
> +		vfprintf(stderr, fmt, argp);
> +		va_end(argp);
> +		printf("\n");
> +	}
> +
> +	usage();
> +	exit(-1);
> +}
> +
> +#define PMD_SIZE_FILE_PATH "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
> +static unsigned long read_pmd_pagesize(void)
> +{
> +	int fd;
> +	char buf[20];
> +	ssize_t num_read;
> +
> +	fd = open(PMD_SIZE_FILE_PATH, O_RDONLY);
> +	if (fd == -1)
> +		return 0;
> +
> +	num_read = read(fd, buf, 19);
> +	if (num_read < 1) {
> +		close(fd);
> +		return 0;
> +	}
> +	buf[num_read] = '\0';
> +	close(fd);
> +
> +	return strtoul(buf, NULL, 10);
> +}
> +
> +static int pidfd_open(pid_t pid, unsigned int flags)
> +{
> +	return syscall(SYS_pidfd_open, pid, flags);
> +}
> +
> +int main(int argc, const char *argv[])
> +{
> +	unsigned long pid, start, end, page_size;
> +	int advice;
> +	char *err;
> +	int fd;
> +
> +	if (argc != 5)
> +		error(NULL);
> +
> +	pid = strtoul(argv[1], &err, 10);
> +	if (*err || err == argv[1] ||
> +	    pid > INT_MAX || (pid_t)pid <= 0) {
> +		// Not a PID, assume argv[1] is a file name
> +		pid = 0;
> +	}
> +
> +	if (pid) {
> +		fd = pidfd_open(pid, 0);
> +		if (fd < 0)
> +			perror("pidfd_open()"), exit(-1);
> +	} else {
> +		fd = open(argv[1], O_RDWR);
> +		if (fd < 0)
> +			perror("open"), exit(-1);
> +	}
> +
> +	if (!strcmp(argv[2], "cold"))
> +		advice = MADV_COLD;
> +	else if (!strcmp(argv[2], "collapse"))
> +		advice = MADV_COLLAPSE;
> +	else if (!strcmp(argv[2], "pageout"))
> +		advice = MADV_PAGEOUT;
> +	else if (!strcmp(argv[2], "willneed"))
> +		advice = MADV_WILLNEED;
> +	else
> +		error("Unknown advice: %s\n", argv[2]);
> +
> +	page_size = sysconf(_SC_PAGE_SIZE);
> +
> +	start = strtoul(argv[3], &err, 0);
> +	if (*err || err == argv[3])
> +		error("Cannot parse start address\n");
> +	if (start % page_size)
> +		error("Start address is not aligned to page size\n");
> +	end = strtoul(argv[4], &err, 0);
> +	if (*err || err == argv[4])
> +		error("Cannot parse end address\n");
> +	if (end % page_size)
> +		error("End address is not aligned to page size\n");
> +
> +	if (pid) {
> +		struct iovec vec = {
> +			.iov_base = (void *)start,
> +			.iov_len = end - start,
> +		};
> +		ssize_t ret;
> +
> +		ret = process_madvise(fd, &vec, 1, advice, 0);
> +		if (ret < 0)
> +			perror("process_madvise"), exit(-1);
> +
> +		if ((unsigned long)ret != end - start)
> +			printf("Partial advice occurred. Stopped at %#lx\n", start + ret);
> +	} else {
> +		unsigned long addr, hpage_pmd_size;
> +		void *p;
> +		int ret;
> +
> +		hpage_pmd_size = read_pmd_pagesize();
> +		if (!hpage_pmd_size) {
> +			printf("Reading PMD pagesize failed");
> +			exit(-1);
> +		}
> +
> +		// Allocate virtual address space to align the target mmap to PMD size
> +		// Some advices require this.
> +		p = mmap(NULL, end - start + hpage_pmd_size, PROT_NONE,
> +			 MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> +		if (p == MAP_FAILED)
> +			perror("mmap0"), exit(-1);
> +		addr = (unsigned long)p;
> +		addr += hpage_pmd_size - 1;
> +		addr &= ~(hpage_pmd_size - 1);
> +
> +		p = mmap((void *)addr, end - start,
> +			 PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED | MAP_POPULATE, fd, start);
> +		if (p == MAP_FAILED)
> +			perror("mmap"), exit(-1);
> +
> +		ret = madvise(p, end - start, advice);
> +		if (ret)
> +			perror("madvise"), exit(-1);
> +	}
> +
> +	return 0;
> +}
> -- 
> 2.50.1
> 

