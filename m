Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD7A8C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 13:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 610536B013D; Mon, 11 Aug 2025 09:22:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C0D76B013E; Mon, 11 Aug 2025 09:22:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439A56B013F; Mon, 11 Aug 2025 09:22:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 30ED16B013D
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:22:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D6F92B6A2D
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:22:34 +0000 (UTC)
X-FDA: 83764541028.04.5054669
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8E6C680014
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:22:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aAW930nM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DThfeqOE;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754918551; a=rsa-sha256;
	cv=pass;
	b=NzAi7SquF4xyB5X47eshcm6U7VfvgH1Zjo3IT1u4KYTqSQ3Co9Q9FBCbtX7T3pPfG7bOfd
	smUmv6jp+wav4qw8bC9dzcFtG2kg4PUdir8J6Qk2EVByVJY+XUiwFQ8UTznC0T7dNruzTD
	1yrDA+viWddQXOD7O6yqmhv3J/Txlgw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aAW930nM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DThfeqOE;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754918551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VKeA1XI4h5CAiMaUqLKyHpxnoDQ5ykr88bqeGqrR/UA=;
	b=ztiuuIqqwd/XiWvpMRz3IbWkZKLcvObG1Kf1XgdLGOhbRCCAFlniJxtaCUAVhHwc5VgVDx
	QUi82Cvri1NzdvGYdXcYkzGYa2HatqFJzlFAfSLmMQ/Yi1LZGegtgnpn7KSzRf1hHCVq77
	WuqdvSEE+JNdHAo5zHybse4H0XOZ6+M=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57BDLGcF022133;
	Mon, 11 Aug 2025 13:22:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=VKeA1XI4h5CAiMaUqL
	KyHpxnoDQ5ykr88bqeGqrR/UA=; b=aAW930nMzUelbm7qjmnwbrgUoPqlpx3iNR
	3+lnpPLWoFEMH3AOFJJ2lZKMC+ciZUPEspDG1oB8rDV8uqrW97nFWXJfLTF/FNfJ
	kUGlnIAJIViT5R+Y+Hl/7LvpEsTPseCG/0+S+dsnRiA7QCVJhQbGU7bWMthZAdM7
	Wt9iyQGvRpf8auhBiYtNnqq4AJf76OBLktZ9Pv0EHtbFPPo/t8RVyJ8zSsBQEJNr
	EhMTWEw+AZs40FbOpKrhSKmAH5GTBYsB7O/Hi98q1jbIFsLG2o89rsl/lRWd8R8j
	+fhpSuBJXrA8eYPpcbwadtwE6SXcBB29X+M2ZUcUcHtHy6OO2vsw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dwxv2gnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 13:22:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57BCL3Re030020;
	Mon, 11 Aug 2025 13:22:20 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvs8mkye-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 13:22:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FM51T5pUE8Jv9RmQx9VZNI9eJaWUQVK0w3AOob6i5ylJAntObXdhHQDhH6Tw/xTRobI1u+VxBJYLwld3dvZTcAHFSbTyWaGxKpCo8U5UuleevL9seSlQ/8hjb0LYquk6PBZ7Us0kwmjjWv8z0IOb0L5nbfQxJvDegAM9aV0CXcVl2C04l10Px6bwagUumwmmGFNGExoimZSdlzaIgXvnMEp3zjI1eIXLsEyZI8Bw31GFce8fdnvGNuT+dssV0YXDN1YjnHoDU+6pfYImTTRYN9Qs2ThfHWXezx5cwf3rMQVlCv8R9UG1stfYF6REhwz35W3hc5NhtonQ0fBtVvm3Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VKeA1XI4h5CAiMaUqLKyHpxnoDQ5ykr88bqeGqrR/UA=;
 b=VLqE/18PxDINlpbiaU4YfPbWS+hBRPfqxT/eN2bYVXJC368woTX97dH3ej2oGbHCOqVWDKDzZAqCC9WkoWyabiYXuK9bkM8rLOIFZR2aTf+ta5CcnSKElLUo8ZEcrSf0ZZpfwK+PUMF+RWGEe3M2rqw/2MxVZ9KaZbH2bKX1hbggRZolVHGhpND0sggOLcyI+JsZYD1jR8mNpWiQcFJn4+Hoh54r1Wsoxr+z9+zWS3XYNOVbz9w7tDUlHshbjouTdmL7V7d/oa43KGLd4ABpcl9Rz0Va96e/X71eiBxw3e+4sZtVhw3t+liKChHNIDfiJ4DuUyMKM8GbfTLiyiwXMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VKeA1XI4h5CAiMaUqLKyHpxnoDQ5ykr88bqeGqrR/UA=;
 b=DThfeqOEYGFeXc/SurQRXcHmrkpmxl7bc7mi1v2Xp4ZtN4p6s3scb/oec5CS+a8egABNwiTh93PGAPqyMZC45DB5B2c6JGonVQUgA5yfVaghMwTUBOzZp4Rc2ICiUxkXUxxFxkefSttIJ1LpGe+7ohgET/sLXFlJarrWUxWUWD8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB5829.namprd10.prod.outlook.com (2603:10b6:510:126::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 13:22:16 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 13:22:16 +0000
Date: Mon, 11 Aug 2025 14:22:13 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>, akpm@linux-foundation.org,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm: swap: check for xa_zero_entry() on vma in swapoff
 path
Message-ID: <fd35dd5d-95cc-4c37-bf72-52a27fe822ac@lucifer.local>
References: <20250808092156.1918973-1-quic_charante@quicinc.com>
 <dedf7436-9afa-47f6-b676-88f2dd8b638b@redhat.com>
 <f008107a-2741-476d-9e32-ae9fc0f81838@redhat.com>
 <29e080fd-5f9a-4760-876a-a6ccef33129f@quicinc.com>
 <fec5ad61-7caf-4076-ba81-7b454ec7018d@lucifer.local>
 <9178bf98-2ea7-4ad8-ad43-cdcc02ab863d@redhat.com>
 <904f85d0-acd6-4f47-ab45-fbf18b80f1c6@lucifer.local>
 <7e7bfd05-434c-40b7-98ec-8ce352a8147d@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e7bfd05-434c-40b7-98ec-8ce352a8147d@redhat.com>
X-ClientProxiedBy: MM0P280CA0098.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::30) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB5829:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fcd8751-cf3c-4c3b-a902-08ddd8da1701
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v3K7qQloNRUzhPTnXf2TwiVQMOVAa2iyN0gBxrfLV332uf4TafPVzlLKucRQ?=
 =?us-ascii?Q?CGnkLCKColjwiF3eujhHkDvRBK2fkkqBb0lr3MExWKRCPs/HAzTcLpnMxqJm?=
 =?us-ascii?Q?fiPl6sRoO4oP9VpnrefZ90WgUZxntK0IsgUs2b/LXdcNcj691JdQ+ZRplWDE?=
 =?us-ascii?Q?CLGNNLV4A9MtDhMq8523DyzqOxX12Z8begzYePw7Q69ZSTBmKivXaUAA3SIq?=
 =?us-ascii?Q?Vf7ak4UGKMclReJ0JHs0s8Z1CtQp4IZixcTiaIQW2Jc0h1IZJveAMwyb3HZT?=
 =?us-ascii?Q?GS6ArS2M1DhhdpPI+gBXN3vps+diuyYSkcBYVHEwGhifbUuBGbkg5jjCd5kQ?=
 =?us-ascii?Q?UNPPmfyA5SWRTtBKcuZC+hF4XvVghHKeZzyCt2KkHo9CvgRzjb3NkcIrSebr?=
 =?us-ascii?Q?biBW3iTOdaUy2ldQZhwNarOP5iGaEdYrZyIC4HzCiiol9dohSKfyTZlKJvjb?=
 =?us-ascii?Q?Njv15VMb3M0pAybehywce0LM4eAIbsIi4STSeFoaAW58ztDMgD5aWh3V+/vq?=
 =?us-ascii?Q?A/rrrCDN8pGOx/OtRpQ8tNJPPVmssjNgsVPgtAVbYNOo7kVOiFxyOGhZiT58?=
 =?us-ascii?Q?UrbuMXztjoImW3rrJu59DAl9GhaXjqrHWRZ3G8CB7iLr3H0EYU43OL60BDQk?=
 =?us-ascii?Q?u1df31aeoRfIVJxT6RUPDpoDrozA+zv9YX7Davme3TjNGUkshwxgQedTb4K4?=
 =?us-ascii?Q?AIo/JY1NZZwT9B5s58XFZK/CL2BsqD2S30KMxBZZ1PG7xtYLnSlZJVTqGY2K?=
 =?us-ascii?Q?WPs1tvJJ1IlSND2TWA+Rz7mfOaQAAl0uFP3SC//LeN94hSZayAuj7GOkbm3N?=
 =?us-ascii?Q?uhCEh0n4Fal+KP+WH4vvrw5c9m74yRo7OgUafmXQ2zJfTJVeyOdLJMyPgEW+?=
 =?us-ascii?Q?K2fm/BlCz/JFP8Zq+e8nnL9Lg68P1BcDwiQPORV+pRJUNzxekIXD2/1KziLg?=
 =?us-ascii?Q?46GiTanj5g1i9QD0K7HJ+JZ1IYNkF2zi2P3FwbNoM2YO/93AUVNX6kYHMiP8?=
 =?us-ascii?Q?1zS2t3cNjmCxV4urSj9CGIZ1H5BLVX4fJiZuHTU6gyKWrscM7CVHuCt3Zx9E?=
 =?us-ascii?Q?bwzDFnoPibNUVWMaFWLO111/d7Qi/9dVXnuP+lj0O8oiiS+E4Az1vm8dibs/?=
 =?us-ascii?Q?8Zh77fffnaANe4iYnEbbqRSQJlH8dr1IYa/Wax+qC0e7lBO6I6UFuThVg1uw?=
 =?us-ascii?Q?EpeRlJOiabLSjCyX8r+9zwJYQiJgwudkkyX35o4rX39wgjVJRNo2mzdphdSJ?=
 =?us-ascii?Q?cyy81VdK8N3Qf/sTdRndN91tIvXxJSAdqj8TC8LIjfr1IPntrG+Ou+hbLeOZ?=
 =?us-ascii?Q?tCZuM4WUigLyuX4WniBLBIwjMbr+P2o2Q7PaXekYvEeqHKOTnyuYBPt4vw3H?=
 =?us-ascii?Q?JSVSuo0TPOtrKTS1ocEpR8IFB6EnMO4RRpfOW2mlghSFgQI3kSXpqb31z2f3?=
 =?us-ascii?Q?R5zW6Y4A9TI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4guQ2uGDBHXR7vndbQHGylU1Byvob0ZHAcCgxD2X3+Gf2yViY0HLJ4V+29kK?=
 =?us-ascii?Q?pRkUz5/GWnrp6+Xhzu8DzeLqeXVC73+upjWH3csuiboKjPJ4InpwJQsed18T?=
 =?us-ascii?Q?Cyx/NLP0q7gDmGhb6sceIGAJRvDq+eguLi4r5YELLck+iQHX2yWgHWSAAnVC?=
 =?us-ascii?Q?gknyBlT5j+guP5ZM6WRlFml0DMWVzpfaZFljFFE9G5sQW5e5TXqMPyPD74np?=
 =?us-ascii?Q?ekyHrIMO9rIVp+adurcDuvJlb7Z8uE28cSZCa8S0cNCdmf+P9bBBRGUcRkA5?=
 =?us-ascii?Q?njfWb/21h/X6rufFeTFKo3ILkhYbcblYobwZTmmrV2qWcXSS8wD4JuJxwbyv?=
 =?us-ascii?Q?U9BTby5oDEL7bf0Z2zB/dGziMqvp60PGvT+2EFlbAHdHclXc/1QAVLye/8yP?=
 =?us-ascii?Q?2/xnfN4ehbhL9TwnDg0s0JyCk5VFoZzGfyvs3+bdWYdD1dnIT08UVV6BwkBh?=
 =?us-ascii?Q?I8VL9smoWx7D4UYF5OeyBl1WM/vP5k5QtWN5ljEsZLdUtE2b9IIrzXL55uoy?=
 =?us-ascii?Q?ADHw0EA2lL9GTSY1qbw1J6DZCQufwwaviX/voy1m66Zp+/9g3fOcYFb+7s4o?=
 =?us-ascii?Q?nBEZxglBkylUMz8ii7+Y8ayP7Vpig8rxh6FmWjcD5mso9mogQAvtGzQC8koP?=
 =?us-ascii?Q?RjyBSMkbZfrPQJzug44J0eytHghIiscU18apmaIZa+NZlQB5Jz0TC++hNRcE?=
 =?us-ascii?Q?AZqa8g/slN7w2q/GvT+lrQ+UXhPavigAoJnTsdLdl0CMDHttr71gYijcbf++?=
 =?us-ascii?Q?+087tHTe2HO3yxhkIOQqvqroiPTqVzUiJh1weBGNp9MlHpe0Pyj2mEh9euyE?=
 =?us-ascii?Q?Ic9pbi+MhHiKBAn67XZqoWmVSUkDmFhF1r3RnUQMCC07jtZTO+dsxGg5MzT3?=
 =?us-ascii?Q?ujtbeuNUENTW6n6waMET3Z4ZQCcvsrNSAN1ZdMCeX+OI8GyGl0ctnNqcQ4BF?=
 =?us-ascii?Q?0BTQtK0a+aHrKNzyWGgdO6I+S86ZH0L02ow7gTN8hjuTdXS1+POyc7nuFBoD?=
 =?us-ascii?Q?gtSFuXmLIMgt5sjMnXb98g2/iiVoh8sqvBcgPhp11xl1lgWk5gOrncR2spMa?=
 =?us-ascii?Q?XwDoKV0HOB5ebs/4h3b73rmupz6ODY14fVDNtYca+MMnq9QUlowT6wsX4uGD?=
 =?us-ascii?Q?WjYrcOsnKpnsUnJsRIPI5wzhckasbpFERfBU1PlR0V3GdNgGV+iwqOY4wnCc?=
 =?us-ascii?Q?Knij0y72woTR+fWb9dzaTQDu9T9GlHSPqcsmefLBQqJZxZD2iCAypzyWhK/5?=
 =?us-ascii?Q?y3fPHezySb5tKAPbhpGnYUw5mqwb9wJL+GR8O4MMqI907qpvIhweRXi4mhGX?=
 =?us-ascii?Q?iWU7QicKsQHTGnkxZiSg/SjDcvCjege0F0Qo1uqKawmNKjHqUrx4RdeaurFk?=
 =?us-ascii?Q?ZZ21Ukj3LclgoG2uD2kNbx5KDKtf8dzvgozSnMjFMXtLBNA9oSJhCecD36yT?=
 =?us-ascii?Q?wp9+3y1/Fj1EZ1apecouak8gf6Ma78/cGrbaWqw/mxf/ov/UJnqHXB3YEUtg?=
 =?us-ascii?Q?YPdnLai6lsmOw6OEVxG4va3U2YxWiie5KtzSeuQzX5JzxwERq91i+t0fChKF?=
 =?us-ascii?Q?byk3OX4hSs3NewoxVh9i9bRucGdyA42TXCXnyjTsKZhjbUBAWPpfOuC8Rj7z?=
 =?us-ascii?Q?9A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KAnYA3GCjzb1eWtjbcnc2kjXt26Z0oihWJhuVWzjpgRtHOYygyImquf+rrKtU/P6LtUCRlVfS6me7wFC8qr2LR65pXzGJI2NQ/9Zd3AQQ1ecYuX9raiyXnqumKeNNKkLJ5jEu7HWNaDrj2dinfE80K1350d9hzBRssL0b4u3Y4FIvLnUKGvepCe5ENJA6W7kA1zY4yjQaMRmI1KTcbYTXgtUMNwaPb/AtBVEtCE1u787aQCX++UQauwz3KkJt6ggyrTekZjRhfH77miNc8sMt0HHu5LK1KPHWqsbkkfHu6Y52mQ9uNx8V4b+iAO4XzSXvlvhBBxlZU3Iq/hlLWwqyTVra3iMxl9+c379BmIicO/G11opbIW/cuarSDzdEpk8l/8A89oikKmAfxdhJrEcxY0qz2LkzC5o35/MHaxd+fXRu7XKOkM5s2+oW4Ik+/YF/Ji5/n4BSsm9kHsn8KS2MHAnU+bdilFqKKO3X182weZIpQ6G/eksUedGjDO9oXanngkeja/kznOUEyFza+i/nxUO1jGsaQuN/SEWb3K+3FKCg5kmZtTRzyr6yP624RyaR7OM9YL8qmzYPjSl2wDx+JP8rl1SoZRSEoMSleCi5LE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fcd8751-cf3c-4c3b-a902-08ddd8da1701
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 13:22:15.7502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: APeC5vekLqOrSTAfLpAbCDbBkaktBll69MGa0/t75miIEHgl8Lj3MhUxiGH2im5dKY9qxy1m8TZrH2hgs9Pt0S4BRO4gnI5S07NdxjA6nUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5829
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_02,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508110085
X-Proofpoint-GUID: yq5VPPweEw2GXpxaG8JoClCHUjCKydTr
X-Proofpoint-ORIG-GUID: yq5VPPweEw2GXpxaG8JoClCHUjCKydTr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDA4NSBTYWx0ZWRfX1wL37D822589
 ZEh7X4OsqMDBNTM9aGyl85j/5uYsynfUgaYB1MWZDXRa8cjRuNeMqsdjCmbaD2THrbNE0GmMMtq
 puRvguhP/DgUoeYK4P87/tRG+SUTmb0muSgyISt7CkL16ZZJgfFINIYhOBduoV9IpXSq6twNbcd
 KkmR8UA5HaPm9L3Dbc3LZHCyiIeQhn8l3ZPTbAPtBBYzvHCrMUWvjKCaALtLvLFx9stZWlAndMt
 IxA5d4VBCN+ZtqktwO8cVWIgRoR91YXGHzcNtsETlR3fEATB1bJYr739xwqk7qqSsjj4+wbGD24
 AQKUZmWykEs1dvSD0wvUxbYPlVWruqApDIHVDMGX3ZLpXr4EBap2ku98EIuxMuGC5Pu8S8QcS/T
 3riiE5LEyVFg6W5nmlH4tyC+505qt7a9lKcKEwshTPwj56bXeBehuaPUeGklRRDCx4/pCMdG
X-Authority-Analysis: v=2.4 cv=KJZaDEFo c=1 sm=1 tr=0 ts=6899ee8d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=ffWR4FN_D-2LzKIwSJYA:9
 a=CjuIK1q_8ugA:10
X-Stat-Signature: wchoj1tr4f9675eeij5jdkrebihz9u1g
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E6C680014
X-Rspamd-Server: rspam02
X-HE-Tag: 1754918551-107372
X-HE-Meta: U2FsdGVkX1/YIwOX9Mrn0lwHKLXEOP0gwGJuIP0jejF+QkPdF/T3EZidtDUbI0pkyUVcRZXMPyZdAgWb77j8m+TU5S9fxeU5d3HncmrDA04fn2xRzRey20rE0dAugovqCc9hOY2j3MS5XNwwK3iWRAaL8BkDATlLT9lE4J9emBMylSFMVcJZSmDXHsjBJdyTkCa2p8SjEMInva/TZo5P6Kge/qYAGVsM4Ji8sMOq9sp+N0LeAPjPozYMib/tgbnNjTxYtVEKK984yg50w/ywkt1UdM8KmlcyfqLPhxkkIs4IY75Go6kzfjTyhqpeEXrCSfKbKSUprBZ+7uhCWw6DVCKnLKnvt2rhY4Wi8ojcUpp2ZVVpIidGRxaSBSrCDD+8dj9lUdUzFiGgA92iV+bbRK+J80fCW699+akf3DIVUVBJJtmMv1PVI9l4jWOwoWvurVRfUkI5seZnUmSUi9GfPKnhFx4TNzHjj3ZGGuNG21/y+9vkQMY79ujr3bxs1LXVTlbJpYqwi5IF15OXoLLsWc///3H/0C95xypMb7jfNQhFOFvhQ8qWMmHnOfenz85NojETE5DjsUAjvU87PmEMO3QlaU799QDaL40a4i7SW4guS2qQ8lpWYiHozyLI16JmpfzMgcCf03JZzoKJW56BL2BOVP2dZzXEHDC0duZkQ6NyEuG3G0/Kk5CpmoU2+bwDy9eKgMAa2/0LbRkrrRAvQAM0c0QlIfCURwr23SX3RhggkVn6/CHWFaYnxqeTGS1W6tKz5bYuUX8Cdv7btGTEmwi2cCeWU/SDfKBpm9tZasKEKc5C1ZEEmo/L5SC58Mlq88MEI32X0a/57PbopPK7BSpTkWYCvzg3kP9fG5Q54UQEAoTyCtRpc2PhXi8Nd5c7uXFfhMkQlIe9+/1qxekvGZZ5KG5IgErOGzP08I5dk6SjCZVG0qgCybA+X0JX8CUkjYIzmsYVToBDZz1D1+f
 nbexUDai
 lgiWfURgDTPREavzaG7gse6ggCBC040j91afEP3P5QK8QbxAgJ+kXMl0uiSIeGbGU/hJjNgX8BJyjeQWeojZFRkqP4O+dWVaJ3Tu9OWRWRMJiE9pdLgEgqc3zfhO/cX4zs8RUlSxzGM5T0nFRbkUCKysZeWc+bQ+rcHnOYSneI1F/LHT14m2FwRBJP3ehyW6K4jkbXDFLDOyv9T22rb+Dj4eVoV3SP4sxTEgD0c3RvAlquBoE9ISsbgyK3QWolrkSoFbkOZWpuGKCGKAqMbJU6hqJTwumMc/wmGTwhrDGPHiBGSssXdY81wKXJquWt+Tm3XGlWlEAqmmA5Oip/iRd0KXhls2hCNFbvXMcdIm3RY5TsvXKQobY1sYP6PIUGQ6XLE6P+mJFk7Ajeg87yqWTIR6b06fRrmmAF8JM4BludJ7um9F853TyeG233/D0AEZmwB+l96snOg0GCpnuJTnilkaJZp05yM4452F5veQPOzDTmDEfp3ip1SBOw+3pA8Nqj1cd8GEBvrvY+O87VozDBJYNYRanU+0HKf5Xqkg6X1a+sGbmh+cWab0P54wdAkiBrdr5rAQqbqXyXu/LivXGrDC2qOvmIERfZGpFmBzBxiS6EgBZg4wOA7XX17cbo04t1q5oarGCmgsxUv/yNU8rHeFG3pfdqhiyzWFUg/223fO24JVr9FUwbW224v9k/Yh6+vByk/ce2SKwGjbT9I0daZnFdNp4++0j878J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 03:19:53PM +0200, David Hildenbrand wrote:
> > > >
> > > > > When registering vmas for uprobe, skip the vmas in an mm that is marked
> > > > > unstable.  Modifying a vma in an unstable mm may cause issues if the mm
> > > > > isn't fully initialised.__
> > > > >
> > > > > > Is there anything preventing us from just leaving a proper tree that
> > > > > > reflects reality in place before we drop the write lock?
> > > > >
> > > > > When you mean proper tree, is this about the your previous question? --
> > > > > Shouldn't we just remove anything from the tree here that was not copied
> > > > > immediately?
> > > >
> > > > Commit d24062914837 (" fork: use __mt_dup() to duplicate maple tree in
> > > > dup_mmap()") did this for efficiency, so it'd be a regression to do this.
> > >
> > > We're talking about the case where fork *fails*. That cannot possibly be
> > > relevant for performance, can it? :)
> >
> > I think it optimises the overall operation, but as a product of that, has to
> > handle this edge case, and that necessitated this rather horrble stuff.
> >
> > Obviously we don't need to optimise a 'we are about to die' case :)
>
> Right, so my original question was whether we could just drop all stale
> stuff from the tree before we lift the mmap write lock, leaving only the
> VMAs in there that we actually processed successfully.

That'd be better answered by Liam who's more familiar with it.

I think it may actually be difficult to do on some level or there was some
reason we couldn't, but I may be mistaken.

>
> --
> Cheers,
>
> David / dhildenb
>

