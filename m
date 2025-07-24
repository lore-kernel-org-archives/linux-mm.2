Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C0C5C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 19:10:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0295F8E00B4; Thu, 24 Jul 2025 15:10:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D0C8E007C; Thu, 24 Jul 2025 15:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBD058E00B4; Thu, 24 Jul 2025 15:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C8DC48E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 15:10:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6D09EC0509
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:10:27 +0000 (UTC)
X-FDA: 83700099294.07.9BA59B4
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 128B920018
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:10:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jyqgUpWq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AkudwF8o;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753384224; a=rsa-sha256;
	cv=pass;
	b=W4ZrhLcR0iyR/x81gepemc9hYPe7TagMvf0If9WPv5sfr+2nlH1kvTMJimKdRt45W5AY2n
	9ky+jhhaESqXlczvrOUV9CXJWvHQAXCTX5d6IlaQt4gNPsS0wCTOK1277W6miPJjcdJTEs
	ztX2uaqA+ISoMQGYOVZn3ByfCMS1YOU=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jyqgUpWq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AkudwF8o;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753384224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q0xjA7oX4TbE7OLcXuSewQpKLYE1O8boMj31fQ+H45Q=;
	b=8IhLPD1YyTfmKUCdqdzd6AjMDtksNF2fM6+sZfhqdMOMpSE+o9Qa1pP/rrYKXTJ6BY2c0X
	Huh0c9h35Hn0N8iynslo+HXdiZKk6/pIpRMTTnwkXBHX5UeFkqJ94KVwXO7bhcMCyqpUv9
	1Uc7DmFklALiyruJ660yHbkCUKmRSew=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OGixaU004319;
	Thu, 24 Jul 2025 19:10:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Q0xjA7oX4TbE7OLcXu
	SewQpKLYE1O8boMj31fQ+H45Q=; b=jyqgUpWq47Dw2GjcYo2CiXzwMcRfmkmXA1
	7UVx7ETyQ9g2d41SchVti6hfJKHbyVtSM/qcfooob8V9Ur5cm5Xk/m1fnB+n7nmI
	DrUiTjbSi34IHeEE502A3i5lK8f3K2xPpl27lJylh35AcXVi3MXz24843/kVEGPc
	8ySsvUJtq/6s+uINWjEcOYSB2wcB6BmWIOIVaG/SqJ9NKLD9/zp+HBePZIP8nPZh
	QFAypa8HAKhu1o0cOSZdmwzdO372L6JP5Jt4mIqDS+jLB3qJl03W//CQ34Tsdy1I
	hie5m4o27Qw0nZTPs9+pesstoRs2vLf+/UM4okFL/CIi5XBWIF1Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48057r2f6x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 19:10:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56OIblUK005877;
	Thu, 24 Jul 2025 19:10:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tc7v1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 19:10:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RuIomcQI2w6C2AI79/NQM6AwRklMauPT064f3DAqkRExztuBRb7tAp1pmZDBb9q3KljRIzCuwPFjXgiB7xNrEhS1YskJCK/0OyUzOhzf0/5HdgEdfwqTUdC4xyypSB5hpmje0Ui4s2oKFO+mu+cu4MgB0C9TZRMZCnqmOE30X7ITESTbdDcvDgnU/Gs/L7VeWv3rXTrlyowRryuAlK2MzMOu7alIkfNM6TjfUBdFWrf52KLfx3swIqxlDB3snVQE4VoCSBvkw1XnXH8xEArTH1A+Jd/bHrNwUGryuc9Cob/znX+/eVdZQD9g6V3PcGT0YFmW2PAcAriShy1T0lAKpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q0xjA7oX4TbE7OLcXuSewQpKLYE1O8boMj31fQ+H45Q=;
 b=TvnNnQUA5PkMeL9XCI5dN+YDnLLYk76oWp5fE63JEFKWtxoxiuSqgcwjhhDNG9Penw1G+Gmr5ir4/XoM/0t+LYZn267kAnxToZmOrjJczBCzhm/qWl00PSxQmwmv15GifDQ4aX2YfMLZCNC5f/OFQDWcgSwRspFuM/D0RUMctsFrWuxn/UFJO/iedyeyKcZkgAwCOsABbOBrs0+Xdpa+Ckt0WK2BDs+BFs8ceyOUy0n6ixIScnRmtCC6rpMtcqNue6XIm+3N+ObT8eLlhBJ5mfsP5ayCDicz6BetFfnQFfINcILFArsldokFKtitH9sLZ71bqVyc6INQAXOo4Cn0zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0xjA7oX4TbE7OLcXuSewQpKLYE1O8boMj31fQ+H45Q=;
 b=AkudwF8o9Ay2GMTO7GZCwTin8EbxaFGNuDNU0RPgOs1SI0vCxyPlVu58HYyWiK7KxzAQ6T9QYv1bJlthRxgDz7GoI5VINITBBgBeFzEbNrnJx9/fe7w9MCFmhfzf369rY1v38imHgtK4Zh0yVj0XJFhBHL8Gi8jSuIdtLPqGuTs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BL4PR10MB8232.namprd10.prod.outlook.com (2603:10b6:208:4e6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 19:10:15 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 19:10:15 +0000
Date: Thu, 24 Jul 2025 20:10:13 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jeff Xu <jeffxu@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kees Cook <kees@kernel.org>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 0/5] mseal cleanups, fixup MAP_PRIVATE file-backed case
Message-ID: <8f5a51b2-e743-4e51-979a-f3ffb5131da1@lucifer.local>
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <CABi2SkVVswRr+H5OWRcbFQSLq_457a0eXwn0OrtkcMEbGphz6w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABi2SkVVswRr+H5OWRcbFQSLq_457a0eXwn0OrtkcMEbGphz6w@mail.gmail.com>
X-ClientProxiedBy: LO4P265CA0211.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BL4PR10MB8232:EE_
X-MS-Office365-Filtering-Correlation-Id: 95330f3f-c7d7-472c-e85b-08ddcae5b8ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0bhxp25Vsn1s7O9WvR4RiZ6zpAlcpetlVK/iFQBG5p1s8JeLpZn6orb6b8Ib?=
 =?us-ascii?Q?WVkcis+MgWyClrw/PvCWjmVuyYMiPuk7Wkntq4QohRKy/fubrAnOHJVWRiJW?=
 =?us-ascii?Q?BHhs7PmIksNO9iouxZVdxF+E9K5XtPN0MQ5vcmWH0aNx8nkcGTUzWXXatI9R?=
 =?us-ascii?Q?qzqWG9oJbWnQUgnTWMGGa75lf2lC4N6Wh23ZTOBxd5rW2Mv1pN7JJDMfeneR?=
 =?us-ascii?Q?CpV9k7X/g7jmL1In5iP5lLBz9mDleQ373y/0h3qxVW7VAls5g4PZQ+dmcsxq?=
 =?us-ascii?Q?Cox9Tu9doXtRVDJ9wTT84lBZt2un40dRclR3LaNOON4TlBV/fwRyYJRkp2tQ?=
 =?us-ascii?Q?DDQ7XZETCpLHb4Rdrfk2C18cgaKrSUxE5NiltczT48o3fdTiXeItQw0uYjpT?=
 =?us-ascii?Q?/QO1MaoFKuEHqBrJAPPieFI3XQwIycSIzeLvHGJ65K0m3QP6wDlRLsNZ9EFw?=
 =?us-ascii?Q?53gC2LNkt3m1oQVkg6DoAvtAzy2IeSWrMriLAkmS9yjqAuS291au1A7WyjzK?=
 =?us-ascii?Q?/GHzdJ0BdWY2H141p+jsiJaSPHUyuqQwne0ZZtEBBfowO+wVX54yLl2BUPYJ?=
 =?us-ascii?Q?r4RXFy0WYec0K8mEd/5JC9h8XoIEdmybRtECiai/7q4Qdqc10OT27Qw79rnj?=
 =?us-ascii?Q?GIQy4PgcrpxQyUmn+8NLRN1PFXbxoTqoYmqzF2PxW9YaM3V+O8J/jlL/Ap8v?=
 =?us-ascii?Q?8lPPzy71VEqUjp7cgzCzKqhT6ZsZcvRed8xrKrcD8sv7lC8XY7+DQMx+dezH?=
 =?us-ascii?Q?H731BqmtAaJ7QIFf3cXLv7fTc7Uyx2AcA/FCugYvslDKu0bNC4zwG2Dcvtj1?=
 =?us-ascii?Q?9Lq6nT+9vfE8KOJO77BSXvSGG7WvIKyfVfbek9Z1bmCPZdWHvSk8jNy8ntND?=
 =?us-ascii?Q?2wUcLgyP6IbXHsHK0lNIybyRfKJ9rJl9q18E91bH2NaZXRD11d25drtduWBL?=
 =?us-ascii?Q?tZ5al8k4nqjTf58xZbYm/OXxMkencuY7EIkoW++y1S8L6I8UMJ82hs3J/bLp?=
 =?us-ascii?Q?qsGpQvAy3Or7J+pay+B4+WXAsjfeh5G23U+eWFsamDuCM5uDoZI4ujG7kvWm?=
 =?us-ascii?Q?3W9O5aipvBH3EysxCl2koH7JEt2RLq7g4bCyxc55CHOBdypgCHpEdsmKfL8O?=
 =?us-ascii?Q?wUfCxZAO32Ojmosa/dvRGuF2VIXcGYWV+oaAe9Jr/GLV7DIatNF02wpH6zrA?=
 =?us-ascii?Q?YR88PL6/K877EjT7fIpt2VxExqxmtVSsJVu2SK1KD3c+Nhj13PVZ2uR1/q7m?=
 =?us-ascii?Q?fXRhjQmSloQGyQdPdk8Nc1Cr9hW+2sPjMhA2xSIQEJWsgI84HdphSjhg+ElH?=
 =?us-ascii?Q?ixBDyos+/L4DB20j2z0RXyXdDgialyXPgLr2eTQDVmPlF9SyfwEHUQzYckPo?=
 =?us-ascii?Q?rxJDHyQKnonFtPMjGZggZtMOi1CSYZg78F15trYtMa82Zv6+Bj6Cj8cwmwrl?=
 =?us-ascii?Q?GY+VZDbmo/4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eq4SZyXBAModV7o/FlzBHIF0APvvGGo/2BekDgwXabjOJN7S4I6W8zQAA/fK?=
 =?us-ascii?Q?nvaGm32elazr0yZvzzhXLhIjqRQnF6bPzIU4bA+LdlTRGZfw0X3/r9wM1zlH?=
 =?us-ascii?Q?U46xje72WLM24dZMF8sBQRbWqQoHHe18fK3Jepc7xxwUbJDRaphTXz+r/Uka?=
 =?us-ascii?Q?K8s+LJxA+Cls8a/QdIy2Q8akhYzJ9r2qS1o4LVKv9+GLJ0q0MyqlK/RHVu+C?=
 =?us-ascii?Q?/pUUPXK5sFzJ2eCB6Yp2Ic1p23G25abLdMZ0odiL3N8CNbTS7mLQ/AbmGMaL?=
 =?us-ascii?Q?i4RdAqDhgEtev/5y8iOjfX6Av7Siez42cszw5un+3Xy84quvy4Wq7F5GUTFy?=
 =?us-ascii?Q?pdR1beu8wno5vn7NW6ahHHhQn3FEOXx+3VwNo4bnAgvHF7Fc4byOnCT+MAjM?=
 =?us-ascii?Q?fJbIraiQJPVmPkqTw5ueej2HO/412FEc7O/K0I06oA9QLnXPrglGBxoa4pl2?=
 =?us-ascii?Q?PzS42zz6Vd3kx6mIo60spW6cRyMcrRA7wyCznMWmogd4EUt3DouNiY+8DD5j?=
 =?us-ascii?Q?NkNCeb09IbXBGezV7e+pHK2eQiIQaFnrf1qM1HV2PhEsk5DKRGVMCPXK05uv?=
 =?us-ascii?Q?ZCokxuQnpV8ccr2lJliTaDM8bYIqlrdL7TUo6ALY3mjMKzSZ3wHnbpia/0wK?=
 =?us-ascii?Q?Tbz0USFbxZ6dlR+UfMyze1IhCfIMPWwI9yWUa05L8WM38/8esGGA6DpF4l/m?=
 =?us-ascii?Q?3TciuxZIXLGhcXvJyjoTvo/RROxlerjord7YhUcyYU6llKUAqHYgbednhiM+?=
 =?us-ascii?Q?8G7oqpWkZ+vDAnWUd9riXpjJ7q9NkmlJQf4be3jwezhX/DqUmoAVkCkOfXun?=
 =?us-ascii?Q?/jFAAHXnROg3NM7AYMHiqdBeTR7NGRusC4dbi2EcE2lFmL6U5qZgISALsuun?=
 =?us-ascii?Q?FvMtWQoTAmQb6Sr+5BT4QWQMybvkORdXqxPC8ccwp9Fwpw63WS8AA+xps7Dn?=
 =?us-ascii?Q?Y/Dx9D3UOHA+uAGX1sQXVm+Y7LWpAuh/ZB0VCM11A63ptDMMUAE3jdS422VY?=
 =?us-ascii?Q?4wrMIBflO7b7IeP4OdD3vjhuFcXhZxw/rhlY0UvwVfbbU5BHLdO6pvd6kjeb?=
 =?us-ascii?Q?1DrS0301UOfRH+L7nFZ2y58zcw5/0j57RStfw1I7p0U0GyEBnnTlDxpzWEcB?=
 =?us-ascii?Q?1t3z1oV3GQKNug0TyTh62NMBfW5+nCVct4IbOSzhKkRNvZv6n1Nlj6CgHbLO?=
 =?us-ascii?Q?J+ydXWgj3F2rHJU51KhKUx9u25mgFzGuVVTNRBYffu02aAKb1HexM8f99Yub?=
 =?us-ascii?Q?oPhpt/P4JhdHIjUvIIWowqU7rvFJ7bdlFIxniwfuqJ0Z8I4xvbF5v+LbT1/I?=
 =?us-ascii?Q?rc2MtGG8vR0sgIhSu8pxN/3pdN8/IdJPg/w6OGNtnk8HHEPRzliDxBeAZ+er?=
 =?us-ascii?Q?RKhvTKrG+QWHwMPgXW5S4uXYisN1W40DG+pEFd945plwcvXKW7ktDyqf/vcC?=
 =?us-ascii?Q?WC4LCKJqtvaD4kALzHl/axVEzGG9m4aCmdFX/3nWnpiP7BHgc+XTIWOQKnAv?=
 =?us-ascii?Q?bSPuZvmCitaMdzNGt8GumyhuZz5ODPNXXBlneeLQ6LHQ9HtAtKcvb8vXvOGG?=
 =?us-ascii?Q?Qyp3DQOTWMXydHK66aA5qhDM90wyz1qOwt0Jy+Jn8KXfZgnLvvxz4kH2pgUX?=
 =?us-ascii?Q?Vw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	N3SrSqRUP9Y/7lxRLV8BlZLWpVDBiNYZeJE17Uadzu/MVtkk1Kk5kZjxaetBY0hWCug7jW8+wyhsDV8A14buJITNb6dAF/6le6NUiJpyQinfoj2jnJAVZa4Bom6+XpVtxusQEUKRj8veaabRGq/LU4/dIfleGW09XWPDe6/bNIh3bxxEUtHhrlELOVTi+2h+8lZ7bku+yv859fDpFRmCEwRdmSc4LGxYMju6eCeDGHosPFozH/5Y82lH4a/ivGYj8qz7dRr4cLn6D6Y90F1iEo8ASCuSPmxTIzEXPDmHD5pKCRFMPPBtluutVaO8+LRrK6g/ZvjjaepD65CkZDjVkJHBgNOrRn0hx3NjuQfsHC3Zdxg3tzETnnQIjWnExd9avtEavjxSwF0GZ3SaEOcTW2nq5NfQ1nZPnGvEiAoM16VqJGY/KOnKyt0mxLau6bUvZWINqNogL31lymn3E+YMXa3AniqY/7j+EyINBrO0bKiEHwqPdQWmwhWiDJbpBIKMPe0bRgtVjkUhA31VbE8ZpgnTvF6hsz/gaSvwiPDssc4rFJtcewGmq8gGGnIsiK7hY1hcCnHM57ZiGh78ra/nn1NJy3VPMrEGRm4bR/ir4W0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95330f3f-c7d7-472c-e85b-08ddcae5b8ce
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 19:10:15.4295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZJVXLmEvgHqn8gIii7MI/xKTPisIBUoqcYC/rkXhBIYcI8jabMxbXl2dYMl4unbSxTjaYBYE9XVrtJNvyyanSa3FWyKUp+ohRvSIhUtpOIw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR10MB8232
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_04,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=906
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507240148
X-Authority-Analysis: v=2.4 cv=MNRgmNZl c=1 sm=1 tr=0 ts=6882851b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=YwWqIYDqwpndRdz2ZF0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: PDaoTHBoORnrUnZznrG0kSVrWHXk7z3l
X-Proofpoint-GUID: PDaoTHBoORnrUnZznrG0kSVrWHXk7z3l
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDE0OSBTYWx0ZWRfXynYjHruVBjJp
 UKik475fLT7zI1E0/Np/GBdy2sURDL/e/EOcgSHDp81sS2aX4dJ7gCoau1enPWFccwyyDwtShvl
 zA0UMhtacQayzRVt1bmn9WsFgYXL4Vgp4YyJnE9N3iORPHll560S4biZRbNwReXRiu486X430R+
 PUAAfi7+J1MzhPwut7NqHly1x06/jhuV5kzgH63GAr8Kw3pP0atftC6qosq65e27Yi3Mh55DCS4
 OqqXgCVfK83Oc6wDc05tnq0BnO7k2Y6shQ+IbtOIyH6iA55pog07bpC8W80vNP5pXu72f42/9pA
 nU2PhiK0Gblk4sBPnv2T5gS/foI25XStp5NH+oaXMvLj9Gzx+sU7fawABNuz1WM4g+EUiY4fJzD
 VOLilAcdOv1rr3raApE1f3ZKKqjqKVLTmcqZ/QsDPESmaUvQmIc7OuuQgyq9iAduJzdk1tn6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 128B920018
X-Stat-Signature: abtqtxdzejitz9djor5zugey7xugxtyw
X-HE-Tag: 1753384223-274826
X-HE-Meta: U2FsdGVkX1+DSuUISxQjn64vugDNWsD42394f2wCrczAFNW5fs3RoOEZQ3Z3HnisdGumiZ76ZtW1f3CiAW2Kk93UAT3tLpObHULIz/Yz8xbUvB7nzJtyf26AYUHJH50jx9qee5YUSY8A4iLCUIGzVJlYStR5XPd+kI9FqI6LXOPngShHOpgX0fMTF+oeaYU7rBKOLQ3dfw9ZtXeU22x8IklbeLSCGY6T1oHe2jgZIAHbifgUCz9HMEm3YbroNWhSWUleEIW0FzH6pQ1vexMRXqTybT5D8Deh3c3L7rsepjULRYvuPIOt/t1FkoCy0ohL5h+pWPIl0VNJ2ka/NkkRB3ZGbfciDJ+MLK1VIaQma1ok1jMLfDTD8YPNRyQq7g8R6hrtmJsd2+QMgEogzIITpxi9ANS7NmmhAuQ93v1TCJw8WwR/1x7F+VbiiTt+UklAcBQhX8jHxidgI14LJ+9a9dzI9gSfFZ7iIrTSbbveiwsAGQuQklWZTik6XAJg8TnRAw6SYBTR6Gw/RwrtJ3cRsHtCOvanTMIpCXl26p4+5KISC8W/Vs1MHWj25/tPNDErKED5tH1zrx2C1fKtqofyWI/t/kHnZdpWiF76CowGiR8K8NbVLt5jz6EK36qUR9mGP+u5eR+ZYzwTwkqxEvHXf1+GcJvye+B9X2QtcrfvRlNNvMa08VS3L/IAAYKFQ5ycfdBy0reGmjfY2GjNZZWOfOxJj1L1viv6aBAqvf9xr48ooBBlT1WIEomFEmv2bgEm8tukXcZI7jRJRzo+wonG905pDo707B9rlaWdu5kSvGdJ5MoIDt9hpQTtJ3fFPqNe2o/brtvlxX2WIz7ObCj3J2GTvSueLbvHnmBBhXFD8SXICTc1QM0M5mzqe6QXdMX7e3qI9GRpj4dAvHY5FFVPjLX7rJDL9lODMA+RF/NviQZL+BeijjyX8j4VDV/jpdqF8p2A2AsZ27Dm7Zluews
 TnhR+jit
 mdDRVsIoJWfTjbyN/SKwygGAdZwgofQIqwNrvn356aW3xwqBPgqjoSGMpcJY3EPQzQPkTydBhU2bfAabVX8InDtHiVN6C5L6zVAQIGX6RjhCQu2RkN0iffZVPF/fpeohNrGz4WYAkbIm7Rxp9EWoSh7CRXPv9vA0NQPvzCdRAM4zY+WAHa4G/SkXwUKSrN/cz8Nupd2AjHoBUWuQ7Mo8TwMCVsJjJCisARP4phk91YQQn4yVNznlfcWCxwkD9tkoNDnXWs181hWsBqVfo48Y8ySmR/1R4I08FL4zxqf6r/FB7B6mtBgN5cD3sC3Cz3jtqBpg2XaTSxACJ/vHmWe+t64gqp3DRFF7KtkiXrrHMqF8fKn2OCL6vj9HLCczqM8KH37vCYETokJziSN0JL6ktVxIrdgAT+kky2GMoV27Y+IWz1LIsos05NOP60BDMNrNpWwom/mEHHMmiDYtKmm8YKsAf6NyKcZxdE514nrMaXsvJf4HmTAhcllFJeVJxOChLcHftQSiazhFOXkv26/nP/PxtOWdWJdscAZ7SWyGSuefrH2sys1ubzSChAC8PcKeW01lMGYWz2buok63VA9D0s0VZPvrFT6Wwe2R/TTV8IkX8/BL8zgUAHV306IiVzoCWH1/PNmZGgQLQRvShwpJuYHsTnjpjEM2jaHxFiHcCCqrI7/+tEOwDzNeolA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 11:32:26AM -0700, Jeff Xu wrote:
> Hi Lorenzo,
>
> Thanks for including me in this thread. I've just returned from
> vacation and am catching up on my emails. I'll respond to each patch
> separately in the following emails.

You're welcome, I promised I would always cc you, and I keep my promises as
best I can.

It's unfortunate that you're sending this review on more or less the last
day of the cycle, but there we are.

>
> Could you consider adding mm/mseal.c to the HARDENING section of
> MAINTAINERS? Please include Kees and linux-hardening in future emails
> about mseal - Kees has been helping me with mseal since the beginning.

No, because we might move any of this logic elsewhere and I consider it
fundamental to VMA logic.

I am more than happy to include Kees as well on any emails regarding
this. But it does not serve VMA logic to arbitrarily keep things in a
certain file to satisfy MAINTAINERS.

