Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39167CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 760AC8E0019; Tue, 21 Oct 2025 05:17:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 710D98E0002; Tue, 21 Oct 2025 05:17:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B1448E0019; Tue, 21 Oct 2025 05:17:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4262C8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:17:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0693448211
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:17:46 +0000 (UTC)
X-FDA: 84021568932.03.214E199
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id ACEC71A0013
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:17:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Dj65xuv4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wCgix1Nb;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761038262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eoQkMukVdG/KQOjAIzw+f/14W6Icc7mOIsbyDEV4aYM=;
	b=07zsgW3iEmPo2r9OGqojCUYWFrvrIFwHpp6Rpwy8fsFWnUVrmO5p4ZHAztcaEiZR7t69xi
	RSOKukFoOUrAGjtEP1Fomg5xlLxlDrzwwytsgaWI+1X0QAqxxF7CN7GT+e+SNOagBKjfh7
	juTrPZvKpbOykKnnkrcZtLJCiBwndlM=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Dj65xuv4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wCgix1Nb;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761038262; a=rsa-sha256;
	cv=pass;
	b=xO9ECnBRdVGZDjB/SQb/1ZFFecy3F0KI91hYsX7s4CkNPBLRVVvX0eGRldihL4H+H6qa/e
	eDxGYtZbvVWft1eyR9xQsWziMMBX6NUrSTO/PiHyCOIxUMN3o1lkdaQEsNPBQ51MvLjFX1
	IqixKTgXTRCrmmDTJr+ul3NPJCmzZxY=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59L7uT0j029422;
	Tue, 21 Oct 2025 09:17:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=eoQkMukVdG/KQOjAIz
	w+f/14W6Icc7mOIsbyDEV4aYM=; b=Dj65xuv4z2yUBN/Bor1hRuja7oZrgkp1Lk
	yShGWh4Xx1PZjlsvH2chcCDMwQgHyuTj2RIw6qv4qGe5BLQm9YYD+zRSxpzUmpPj
	pHtQfzcpTgFAXeSgFXDb38dQOu6netuB3TaQWZkBwK5/QMzsyyoUme+LXxSta9MU
	834uh7es2bBFzsaWrAz/ju2lqurllZlbjiWMmDxJBzKA82Lb+6Cm/67ib1qD56nt
	JICbN5zwfGC6FzNJmrcm8JcuwIU9USxHLSnP4UN63dSo7NIuwLb34IHWiznt5QpL
	xV05tQSagUafGRgERqbW3DsuzdcsOuXxMW3gJyJKHMmlu5sbL4OA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2wavh24-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 09:17:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59L8U6O8025406;
	Tue, 21 Oct 2025 09:17:36 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010019.outbound.protection.outlook.com [52.101.56.19])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bbnmj7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 09:17:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YF513TJsr4GSBDYSm7XR4hBuZPlBmdI5m6wFZulzyPI33hjJ0o+bMKVfo9mb4mqodcWgN0MFA0K/+PPSQhOtmwHFtHGI5ZeDVM9N6fgu27t2d/EbAGQg6KDxgl6rXljGrq4OE4q8m6bR5sahgjcRDeLlw/qOBdgaCmpnfILJ46WqfTQPKLdJNrtSsgvEMhDPMAelgc9Mv8AYqA6xWVGH5y6+3EhVfFXthQibdWMM99Jg8SBkvEnof3PQWS8erwITf8Hi677Y8q0yuPRyGLz/TGK7jhnB069Xs3lw68mCHB6oUv2Isp7A7JPX45u2o1CcygBWpi1OfcgJyqdRrHPEGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eoQkMukVdG/KQOjAIzw+f/14W6Icc7mOIsbyDEV4aYM=;
 b=gDy0US4GT6kXJ0HwygHp+dHVrnEd3/YMRB7T/CI1B/kQKmP21C62Z41JVfGLGzkhAjQzCZ7wQS6LKWYW7poRXK8Gr941p/gZJdSrDETq2UI42OPgypJm4BOT9sspeDSJtlE0eR4ji6FaXKFC9gYY/xRuEPEptlYE3obN0+jchjdG2PqeitkYuvuzeT+5w2m5PHJbReKVWfP9O4C531BB8hyUaiWocV6TVXbgt+zSkiRn7uz7h8Tlq5Bl4csmzU+EeVUHilnekEy6hhEV4OGsLIXdHYCVnMslcKMQoaSZbv7ZUwG329x6aoBvjXFvDIs2EcepFtkddETegz9ZhwXWvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eoQkMukVdG/KQOjAIzw+f/14W6Icc7mOIsbyDEV4aYM=;
 b=wCgix1NbNXIP2vjf9UQip/c4l61OOaKLmh7L/oVwEy37cBGhGdulcA9+0l9KtJY0oeAGJFchRINa7a4MpdhQPQIrsfI/NUYgLP579QGuzPAQVhk/GlrSRX+nWSJm3C4Sx6RDaP3I82gpGEuK3eoqSWOIDfR7O9tzsMId6Wnei+I=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM6PR10MB4297.namprd10.prod.outlook.com (2603:10b6:5:210::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Tue, 21 Oct
 2025 09:17:33 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Tue, 21 Oct 2025
 09:17:33 +0000
Date: Tue, 21 Oct 2025 10:17:31 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@redhat.com>,
        akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
        dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
        linux-mm@kvack.org
Subject: Re: [Patch v2 2/2] mm/huge_memory: Optimize and simplify
 __split_unmapped_folio() logic
Message-ID: <03f4ad96-0f10-4eed-8340-ad2f4003fadf@lucifer.local>
References: <20251016004613.514-1-richard.weiyang@gmail.com>
 <20251016004613.514-3-richard.weiyang@gmail.com>
 <7ed84d61-0a7b-4961-82eb-fc8d38b77162@lucifer.local>
 <154924ED-0CD0-458E-B760-F9F0A92CDC89@nvidia.com>
 <d0a2c81b-a0e0-4457-b355-2363f30ecfb8@redhat.com>
 <cdd37933-d2e7-4675-82fe-62b7f0ccdd80@lucifer.local>
 <A67D1276-D59B-41E9-8A88-E54E05A0F479@nvidia.com>
 <8dadd256-175a-4706-84d0-180eda04ce89@lucifer.local>
 <20251021003023.owj5f4gceqpnp2ze@master>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021003023.owj5f4gceqpnp2ze@master>
X-ClientProxiedBy: LO4P265CA0119.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM6PR10MB4297:EE_
X-MS-Office365-Filtering-Correlation-Id: b326cbbe-7337-4e0e-2d0d-08de1082ab1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Mbdto0KQHUuqyvin5CJcwqL6fuCy9YU0Zygkhc33LQfIe9DDWJUqn6lg9ds+?=
 =?us-ascii?Q?VVCaAp5Gs+Ow3zBr83ya1JhY/0BjgB7ncLqi26pux3T683EAt3RHAJE70ldl?=
 =?us-ascii?Q?VnzGWjr4FLWDvYk7dud7XdWEp1gujRz4BGILNl635142XcHy0sBHaXx92Nmi?=
 =?us-ascii?Q?0fsU5pOdWj0G3p8BjY5vjyg5UwkCjblosnIE+yYCXoEJLPYMNVc7E1Y5Bq8M?=
 =?us-ascii?Q?48j3+FzHWba5j8w9y0ketIkEfo4E9ItJavlAEzzyGGBcjsQEzHBs9GAP4L4M?=
 =?us-ascii?Q?Bk9Du7eO6OeI5oCPT5QoXWQLQgsnOI394v1ZUg9sqYnvPmUIzeUvCuqUsWsL?=
 =?us-ascii?Q?fuPXo9q3bXHDKG2oQaeuj69K2EWmFx71U2L85ecuDtBo8QXWD6SY9M599RRk?=
 =?us-ascii?Q?ZGjdt+wo2RphLSpJli7T8wXOfz5DyaZPYAdeqQG9pAcbVaro5h59QnwshHBa?=
 =?us-ascii?Q?yTEpEqzVwRUz8FJkd79yqrFqJXNWo5FjqfSpYMv1Ni2FIle6QHAWixrF5bbd?=
 =?us-ascii?Q?D2zHRMMw1W2yxHPd3eaojbo3zy6zTjmouBAYNakhediCdRJSxJQPtJdTxiT6?=
 =?us-ascii?Q?Bc/vTZjarALKoPC8wne30g6b1OWN44Y4DKQVATSyeAMtuXGz88JQA+Hl5iMh?=
 =?us-ascii?Q?z1OV/zarBDkcMyP+c5yw260LRdPlPpg63Hu3JMGlHb3J2DmPXijmC3tUhObR?=
 =?us-ascii?Q?xgE/d17o+U9yixb0gFHIc60b1+gM4QBf33BFEGk5yD9iY716wy+LnJ7IHMpR?=
 =?us-ascii?Q?12hjhzRL461Vc2T8g83sdFVhpVkYG39iRIYjClYttgAEU8g+HO3ynE9BwspO?=
 =?us-ascii?Q?TivqowSCsgiV4dTErlWj+gsZ6WBQOLIA5kqTEjobB/XUl1wCbbOYBZTbMSVJ?=
 =?us-ascii?Q?ozzlwGVGe/36GvzqrixbX22Xl6Zc1N6eed51kfaEenAi0GHNauurSRfpFgOO?=
 =?us-ascii?Q?OjUyRZN6z/xwKSbtOtHmx3sSNo7Zj4oKjPy9ko2WrVhn/u/64XaNX00wkyMd?=
 =?us-ascii?Q?18zrJpnm5ZD1XNfKbSghZfuagIZdMQd0rHkK1CiEGugjGrsj4+9e7VhiIggd?=
 =?us-ascii?Q?JAsVL0fDwoacl5Kt59v0ZkfriQkgTnUH5Uqe9OZXiR2uDC+DnDZWLpsde9r7?=
 =?us-ascii?Q?lHff5XrQAuISlIyJA12uh9SFtSDTpEmtr9H7uhQVoAJf6o3TrcmqoGqoNnMk?=
 =?us-ascii?Q?Un88/2dewROs9msauKC4sSGFJ4ShzaIr/rH1CKW5/cDdhQ6UWXbH8fhIl+Ew?=
 =?us-ascii?Q?i3cwc7vJGSciOdiBT/mt/ZbYiP6E2zAxE07bYxlorPOjYPNPABL2zAmbGHqI?=
 =?us-ascii?Q?6uCisZ3rmo8hR9yOx7fyf+5Hg43yjIR5w1EFwcOTi/OAAXAYcVnAbokiVHqU?=
 =?us-ascii?Q?6nMFgNYqYDFN82xn2iS+qP3GQdsiYC/2HMaZel3INy710ngn6nrmEyQo4lSg?=
 =?us-ascii?Q?T244mUDw8+ojz4br92QqqwdwdHD48gKU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nA1k2tRJxFvsdEOUlR9wwK2OPaMtgmzUzg7kELmp6g6bvKkOhmgLEJ2Ztpl0?=
 =?us-ascii?Q?V0Fd2DcqJWfpfxDf2IKofMptd4Ao5Pjoa79P9kEu+z4BKSxvJHHSuKiv/gJP?=
 =?us-ascii?Q?YSvv2G//22QiVb+EPgbV3ZfRYB/q7KsTQyfxSE3e2XrmwHQbpaf/xi2i2hSe?=
 =?us-ascii?Q?0VNPkJbohSBkz7ccP30YFeuxIvLPAY+W6JgiYUREh84wKbmVTTqhO7CwZ3J1?=
 =?us-ascii?Q?8fQFsW/HxcPjI9H/c+myXAbu7dNLURYCAv6Xpln8JCmYkkgbJE0K3hy63uUB?=
 =?us-ascii?Q?qXqX2BJNWSHvZVdCBut5/3KCE9zW4t1hniGcJgMC9izJt3QEIaUdO5iLegaQ?=
 =?us-ascii?Q?kUcwtKQwJrJ4Xyu+ZUwfZ7hfKIlBMni4QGqui4Yv454BdH3N4vVbr3CWsuhj?=
 =?us-ascii?Q?Fe4IjccvFQNtMfkLOTM0wpQiEs/eMZshSH68IIFYqY+o/niFLtH9hdi2pOP/?=
 =?us-ascii?Q?pdLMbDWawWqYS5T6fGs0wWsmKcAe02dgzD8GVpJQXZ6lY3OKFLU0ZFo8qyT5?=
 =?us-ascii?Q?GGE/fhNsJHqOQWuuqVa9ovlwwQcrNIxro+ywHudXTuv0retp9HS1OYV+fQjg?=
 =?us-ascii?Q?LqZo5G5wUBAz60AZQe3xc8wxGtz7asawLJsBTabYIX1BTss8Fc5+dZiOfhAW?=
 =?us-ascii?Q?rOZzisJLRxiQXmH1/m9yY6kHqozP7jC7dE72gFjFcSW1PX//Y2iJtYHK0sO3?=
 =?us-ascii?Q?0Wbm+JytXVD5iumVey7IZc77gKcMNuNnUQeMYweSHLWePUuDWqpw2ShhBJnt?=
 =?us-ascii?Q?CixJVUtTuaED0LBBjDQQK2lStlAVU9e6aRWRUEncO3+v3TDXo6wg+rIkazsV?=
 =?us-ascii?Q?cNZtxCsTtSGIIAv92+w0Zql9VAzRHiQXqwIiAH/KIGmpEhMok9ONj/HdKmF8?=
 =?us-ascii?Q?OKUpbyJfD8Uierj+Wv+yiLlJsVmVERs06ix8rqopInGXvUb0w1DB0QWjiVq4?=
 =?us-ascii?Q?VBHwBVVfjDCATheWOiP2Xu9fv5takRFY8oArYjy0ofAaLaK4LnIco9AMcrxt?=
 =?us-ascii?Q?eYdi7q0XVfaCtX2oywjcwaiY2aSh2HEtFQFt1pOuIBAjGRGbMzJIFN3l2tkP?=
 =?us-ascii?Q?o8mhJ9WdwBz8/xpP8AzUesJ1qnc/+5Y9mLoSuDVgogk1c2hSNrz9M8LTB4Mu?=
 =?us-ascii?Q?2vBM/bCl8+vHGM4qRMRbeoGsnRRahNmV+eoP/Uk0WzS4Vvu02/FCEkP6X95e?=
 =?us-ascii?Q?kPQe/kJyNxtUuVpeJ52f/iI8ZJiNlJdo1/kWnMyXG6/XWu1h3l/FrDG2gGCl?=
 =?us-ascii?Q?WLJPvErjQVP6wjbXIclZGcVASt5mMOG03w8ayjuLHG+8bnyxFHUl7FO9+RS7?=
 =?us-ascii?Q?z/dBQYd8oYYQKZNk9RMKSI7KkmQCzfbOksG/MoxGE0fjQa93mNPUF9fcCHLB?=
 =?us-ascii?Q?86gajWufpf8IHR1+rawDjvsRN6fIc7DJMrhyH2RWerBpmPGXkGdth5nNrbcv?=
 =?us-ascii?Q?BFyW2RkFXB/cXZhMA2eN3eGKmPR/HYB8+mJSUeDm1QjnP/2GLgVUc0PXN5sv?=
 =?us-ascii?Q?Tg/1vvJAEU0v1Mik7Jk0/pz1Z7DNit+c15w+/rx7z7/KswvtRPk4waQU+Bic?=
 =?us-ascii?Q?At+MelC8ThINXDFtNP0q0ipOi2oLEo0vct5MwVLSVQYQKQm30ziKQ6zCr6Sx?=
 =?us-ascii?Q?zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OzMyYFtD5cCDG9M1TAyn4TnuLAYwsF9TGU1rnVu0tXr5he7J7jt8zVw6/Q72pUYOGU87inJqMM0MYeuqO0Ud26iG9oL3xSD7mfCcwtTO+KORYQKN5wAH5Fl96mDvtRyhAqwCjjYkYn/H5FVQP2RB28PP++XQ8ovUMijXNUEewDQKM7WBr2h7dexzddm7FGS93ge5cNrnaNZKbm4ZWobECixFy3q5LpLLQVfmP2JWFVGXypwUNeXpgW12K+PFNGkDFyBl8M5gXKQ/Q2KA1vzPO1on1ELxVwjb/HbQ6MP6v9wQFDsIpPAUKQiOcu73hxdkYO88XX9WprM1tEC7fXbNCThiOFy2R8WKbYst7MbKZRftPtd+KAX2k+XnagJmvOv2IWINgSBoD1U5VoMFS+RIQmMsy+93RJe1Lv27RPzELxoAxgYwhZOHzpDH82snEi9/W04BuuGEDId3TAdzifbhhTAHMGQJ9XowE1l4y1RQcKV8uBtzGZs1OHR82gvcqsmvABY8q4KcHvX8pZ7qsbgct6qX2If8sSkZauAJy5X02iDtW/lT5sV3V8kxljNuF1SRm09T933WQ95QccukMzZfem9A2HbU71JRoK+pESwATek=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b326cbbe-7337-4e0e-2d0d-08de1082ab1b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 09:17:33.6424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: plI5pjqrePHdEVGZ6EQ0ibDSMP+q4Lb8eQMF00Fw+/gLAZ8UeVMRpNDsyNuyW3eakONtfxTXRXzhBR54Hw9u7DQ7a7rLGMecQJo/6zN960s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4297
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510210072
X-Proofpoint-ORIG-GUID: 5I3gvnx2aOKqkkeX3ZefD-CCX2moJSdd
X-Authority-Analysis: v=2.4 cv=Pf3yRyhd c=1 sm=1 tr=0 ts=68f74fb1 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RrZwl90FywMJn_PuOWAA:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX7TqNsVD/6hON
 fwb6FGBBWWKzrSC4q87QjJMW8fFW/nZTVoXAwE7XvOdwgzdtbfLgltz9syCmM4RFiWZqKzwoCZP
 ZTHc6eEV5B245RBF2uVWhD2opA5TUVY2VjK6s0PhewxJSteRzbwuY327LiG1WplPuM4JvJ2rcSq
 JihX1MG4h+rUuA0pK0vu4I84mg7RV+r9NcZmk3fYL7kiwFwnWSS2tDdeMieIh8rE4PIvUj1MdNd
 yA+Ho1JEWSbfUoi7yqhlX09Z2iQz5/3M7Xi+/tOUlHgnhaYKwh8tqouOv+o5L27hLn9dzgfhHqi
 hymc0cgTyIqpsWRVWOMwcwOoEaYLvBzT8y4juJQix1yqaeAKOwAZ43p5Rq4eJo4Im6/PNvWCdY4
 919I6uXsFHHKwOIZWzu20RZpSAXVtw==
X-Proofpoint-GUID: 5I3gvnx2aOKqkkeX3ZefD-CCX2moJSdd
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ACEC71A0013
X-Stat-Signature: ygc4g317chd76g6eyz3nhg6x6opatyrw
X-Rspam-User: 
X-HE-Tag: 1761038262-66138
X-HE-Meta: U2FsdGVkX1+2imxNDVTp92ke8sevCgIvi2sitJzegnd01+zJpvntM86zfuKC0V+80J3GpgGfTe0546/VzTqU6G0o4giv5TCwMdU2An9NGrKTQ+O6+zdI4i7CKc5UiZdYUNvtmhgZvv1/Uv/kSXhOX9xdVUB62dwLIXxYlyCrdJ2xBkP/2ordmjeBwkpR77YSy06iBryY8c07cAqUO5oRw+SEajo6aZiFdjDJS9knmLBDTC9zYI0aXDyc1zgw3g14jtz7OaeICUeTcGfBx9muNmtNtGgXHWFBNiM7kVh6zuSySV+VfyyJ9rZ5m5fu/ulqCXN/EsCExa+Pa5oC6y0Zdf6zKbWCQo03Oqfvd21L8V0B0Z0Q8mIB/MasHWsScVRkIXCqP9VGGILvtUvt0YIA2bJNnM7aAX9mUHZ7dZ7Z9hcmxqjqNPYX/x6yHr33fscD8AEGWSR3slH8JQEebNjXGDf/LLFzBCFiob4jIkSQesu5Hdf8M9gBJKObHKt+SkR8nnVjs+MgTpDluz25wkVnUjGy/+JYWyNygxKDpQPKIS0Cg9xcXWRyUBM8fQQnn8eJ4qhUuJbelLRN0W57H7YlX0JA3RlqJAxxmZAHnggsgeluzpaXQDKR0aSvIT0/3F5BWQ2SALhaolbLVd/uBQlchzKT7ubbVSUnBOV5bgFaWmxi2/4CnPzeG/HWPYGkyEsjiwSAAC1wB2qxPq4/lV9B66VBMI/hbintXV23rbvHjSo2hGyIno3QDcbZbtwjBuaJulCH6qUzzAcTzdN9n8CWSRcNPiFXXDulqsbX9jYpPEqpCqw9mAY4tjlFNtgchtSp+z5q/cYBtAB/Lq/Im3Bo+u4ON3XMkxYBZcfS4uw9i8l9VR9MvKeT0Z3LB7jv4RnHDf8S3Z4NG42uv8lR/AAi+Nvfyp+xOa1Yn4sCyNEVdRU4zwVp/q0yjVmpgwdhF8DF+j56yND8TZSmskgLgQi
 bdcymzOI
 mIBtFzzhy/exrwZpaJ5oPhJSNP0c9DTFZfxms/Seh93OU4zhjGz5DBLXPw6Gf+hHmTV6JHbzV5KQIVx13+FaTFd3l5GTu0MtDupn34eTWd5YhN/35SyOWrAG7BKf4x6UsmhEXcX/a/e2QbTzVDvUKESIj6mEImYnYj0PBllRlUid0V0xIit4WSETp3ReULYaXl8Hx26Uhdl0hROuNlVKqqZxgy05kwjZbT/C1UfwOGXdDwqMioX5ykUugIu1v0PvH0JhGT/OXnf7+vSXkQHPSKbuESEn3QD4zJBhWAWUlcsqV47Txhz8YkN03SyosPJ13zUL7Cdkoiu9UHY386QuRAuxUQ0xfiSfY1/DDJYVuJO+XUy8H5xdVTAOCmJ6872mJZ2A/jn33wwRmlAnyUTFrshUJDTNYuYFIxPZwwA7MDLEW8XPL1VH7WdDhNK9MpU/RamL+Bft+008YPcpSOzip8zoESZvtApgbrAHRBOBJjKD0FqhrcluepMwDR921AzaRKyV8ZgMk1CqEeKRiQZjuVg5jVuny/lEiiY3JrXe+pv3BfHCcyrm5Xa0IWhYlBOnrjGqsnGQdJOCQVuWaS6aaCglqbOGZbe7w4OMvuHMbEd+IHFEWQgTBEYSzDeaBWe+34tnqneTgSMdvMIA9nmKTHvCVOEopxOJGWDH8uUdUH3dCtfjm5le6mzLJ0tP9mVPcF0uQwb3Y6aC+dYA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 12:30:23AM +0000, Wei Yang wrote:
> On Mon, Oct 20, 2025 at 03:03:06PM +0100, Lorenzo Stoakes wrote:
> >On Fri, Oct 17, 2025 at 01:24:37PM -0400, Zi Yan wrote:
> >> Let me explain the changes in details below, so that we might find a
> >> good way of splitting it up for an easy review:
> >
> >Thanks, much appreciated!
> >
> >Looking through it seems to me there should be 3 patches:
> >
> >- Getting rid of the trailing loop
> >- Stats fixups
>
> Hmm... I don't get how to arrange in this order.
>
> Remove the trailing loop before stats fixup means we still do mod_mthp_stat()
> in two places? And we keep the stop_split and fixup the stats on stop_split?
>
> If this is what you mean, it looks complicated the change.
>
> >- Remaining trivial cleanups
>
> My suggestion is switch 1 and 2:
>
>  - Stats fixups
>  - Getting rid of the trailing loop
>  - Remaining trivial cleanups

Yup this works too!

>
> We first update stats only on success split, so that we could get rid of the
> stop_split. Then we could get rid of the trailing loop in a clean way.
>
> And this my v1 with patch 4&5 merged.
>
> >Do you agree?
> >
> >Each can have a commit message that describes in detail what's happening
> >and why it's ok.
> >
> >This is also useful for bisection purposes.
> >
>
> --
> Wei Yang
> Help you, Help me
>

Thanks, Lorenzo

