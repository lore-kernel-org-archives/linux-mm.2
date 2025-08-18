Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F183DCA0EC6
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 10:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D1526B0100; Mon, 18 Aug 2025 06:09:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A8B76B0102; Mon, 18 Aug 2025 06:09:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 671376B0103; Mon, 18 Aug 2025 06:09:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0DA6B0100
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:09:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F0F295B8AC
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:09:31 +0000 (UTC)
X-FDA: 83789456142.09.325A5F9
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 79FD31C000D
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:09:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WCM9deNy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gk2Uxfjx;
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755511768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vhGqmFQuPMG6tZZ9NsKwJuCNCNS6/ohGRqP8NHnMgRY=;
	b=1+Emn+yygc53StEUuWPzl0RHbvNUicR3EJcNjM40eskqlZA949QRx06r8Ps7q0lBdwwruD
	JuxxkQFGwv+LGl2T1HhqIfRMUMRbRIQq/+W+FF2UkPwMOzKcYfYuD1fK8EwTt+5fuh9Ckm
	uoY+9R/xnTni/rqJrl1MrztnG8RfmSM=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WCM9deNy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gk2Uxfjx;
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755511768; a=rsa-sha256;
	cv=pass;
	b=lh6PU4UEJ8/ggn3SCJYeDabxff9DJ2Ch24MOHlVvDhtSkmRmA9germRtqIpt0nGgyJq98+
	UKpmF7sYPqiELjNqv2NM2WiNrlRJvjLjofcm4ExR6yhUV4h7MkgorEDgYRsX0Qhq8UVNst
	KOY1PLLTskQY6dUY/s4Uc55PmLbTsEs=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57I9etBm014000;
	Mon, 18 Aug 2025 10:09:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=vhGqmFQuPMG6tZZ9Ns
	KwJuCNCNS6/ohGRqP8NHnMgRY=; b=WCM9deNy+Q5EjYiEmMJU2Xw3JugnorxM4z
	aa0b8mUA7TJzbBz9EKJvW8VwI14mR5kX4OuffRcrGJO3+wVVbQqj+eEjwvgOJiK1
	TmRqRvSe5A/wJtQSBPLqrZZYG9dIYcPQ+utEfOHUzUwG/bXeGipBPgWO1lQNu9c4
	JhE2uBp6zJXmyMQ4zICcZZUD91Aycxpr3Y8XaKk9LNPHZLjyRuCkszLRGgFh/PhQ
	UctQsbkrzpHyu8HTcZjaW8fpKtrSjGDz+Pq1PTZuSMUMX8nvVOocX0pq1mHnNexQ
	lkwtSawn9YRxYVUD8yorbV+QvI7YOcBiFsdlWSDwSk68YCES/iiA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jj1e2mq3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 10:09:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57I969lq040744;
	Mon, 18 Aug 2025 10:09:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48jge98q16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 10:09:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QsZjkox9rHjk6AUn9CiHGaueDGxe3Ic75rRd4Hql2lEe32lLZC7TkDJZtGbDvZb0wJfQtotNKxAS0FEY2vQF63xZKwTz2H5kxrRAmIy3UiAYkftrNT+A0kR5FPlfBuvvy5ieqh+QnLelXAYV1wfTVKa0mTu6H7ddHnjlgP7vibe9N/G11z3eW1yc9a+U+XpRl9X4Jcb5Rik2mdWV4+Q/8fcPB/8sB73feIryNOXvUhLWNWN/IQamLPoUNq2n4SMdOA+IOomnR78V3kO8v31cywt4XbuNKliyMe3z7tK+v8s05x/xFv8sRklMaZOtDpbSoouhPOMRpC6uTGZKPhLDFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vhGqmFQuPMG6tZZ9NsKwJuCNCNS6/ohGRqP8NHnMgRY=;
 b=w7QvukJn2QZ3chCCDK7ADB2Gim4XXNNmjkGMJcuYIL9O+HjRTeRsu7LMncE12jWKzcXtrzYNQJVAn53mnOrGiXZFSr7/CFz1TzeiwmuwbnDKoG3JBAJa+uYLX1fsRFNItWKnI0E5dbJIKrUlZVvTOjNR9Ak92MbCxCN+Br4mTSCaxyWotKTKLVuI+l/UCFTuKEf4eJnEawUZhTCtDfhhCcvPf/DiAFMHwWqv8EOYsISWiyHZi553oCPLlpGnstenkmKZ7VJic4N3uIWxXusbMx69XTTYsvBC94ui80k34FWC26UUdGcJVjp1n+vuscf9yz8H4FOi6tZXAobOt58DUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vhGqmFQuPMG6tZZ9NsKwJuCNCNS6/ohGRqP8NHnMgRY=;
 b=gk2UxfjxuPsR4PETLH+TkMKnEA+C+rR7uF4kkSSQ71GgfOG4I/CMfz+RoQ136M5anYv3ts8VMZJ+YzHKe4xx1YJ5CTMKzefy6cZsC7HWdeEt+2jPsORDJLiMd6mEXONlx52jxPqSSA+srUSnIKjICCH5Haj++0IKSKyKyPteEmg=
Received: from DS0PR10MB7341.namprd10.prod.outlook.com (2603:10b6:8:f8::22) by
 DM4PR10MB7508.namprd10.prod.outlook.com (2603:10b6:8:17d::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.23; Mon, 18 Aug 2025 10:09:21 +0000
Received: from DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::3d6b:a1ef:44c3:a935]) by DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::3d6b:a1ef:44c3:a935%7]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 10:09:21 +0000
Date: Mon, 18 Aug 2025 19:09:13 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org
Subject: Re: [PATCH v5 01/14] slab: add opt-in caching layer of percpu sheaves
Message-ID: <aKL7yYL8coNuQpAP@harry>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250723-slub-percpu-caches-v5-1-b792cd830f5d@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723-slub-percpu-caches-v5-1-b792cd830f5d@suse.cz>
X-ClientProxiedBy: SE2P216CA0119.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c9::11) To DS0PR10MB7341.namprd10.prod.outlook.com
 (2603:10b6:8:f8::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7341:EE_|DM4PR10MB7508:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ef61883-e67b-4a91-96c9-08ddde3f4ccf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Scn/bb0ELEkZgpmODRMepCp6b3yknoed+PhsH7wZxsmDb/s2XsIkV2w9E7uT?=
 =?us-ascii?Q?E3okdhRZt/ViqsqG3NYLu3OHMbwE2HGPZI3OYVwzMqS8BVfFUPxn9ur7Bjsq?=
 =?us-ascii?Q?Bx/SmlPHmvwrFFgKtlLmgiyl/ZV/+xudBG9gRKvKrXouiTyZ6jaL1DLuc0cU?=
 =?us-ascii?Q?0yJPfYv3Ws3mYE7TAFw8GvfPFhek4VLZdmA/tqOYZLMKJbeu9TOLQiePNwGX?=
 =?us-ascii?Q?y1afartzm8Ol98lMa2jcYQyMwSkMBZKhUPKyGnRI2l8wZQOzmUt4Y8fsNQsb?=
 =?us-ascii?Q?C+yn1Rm/ewUvfI6VppifMSUVjUhfm8RZLO1YVZrYt9M3ma5EIU5p8N2anxot?=
 =?us-ascii?Q?c6cWKB72f5w5GJTDI5PviEskWM4xQOiofTEP+WGozLFog5k+wA0FnA9rCde7?=
 =?us-ascii?Q?+MHnsxaRuCC0Dr1urTjIFv+ArklCq3B+k0q6K/lIvnjcOsZJdtw/vrEzaAWL?=
 =?us-ascii?Q?O87SJ1q4APxyR8LyH5avmo9XRgEG2786FiqJUGAOrGaAY19iTEXgzr0n8lAK?=
 =?us-ascii?Q?IWjcnziVFOImtoYdgGUf2AZwY8QnhgLKa9pMh96ILPY/OG6oiWwFMUtA+sEF?=
 =?us-ascii?Q?HY8g9KW9f1ARFn0A4TKRhEbufXmyPyoLZTIPW0nYhWmIQBWDpmYIH6H1zsUR?=
 =?us-ascii?Q?P0VhAWORkMzNlPkGx0e71Bs5fzP/H84iwewSrixr1yiiW/a17Td2gHslwEhv?=
 =?us-ascii?Q?ifkgFashpcd6wHLQemKrjUC8vuyajuNWthj0v9YS2XrBXWEEI34AkTAStl17?=
 =?us-ascii?Q?O+mRrEUznaeESkO/GJlFKqMg0GviDynG2//PL8Z8HCEjP7aItDzzBVQzMlkJ?=
 =?us-ascii?Q?kx/Z5Ucy125Ogfp3yFspqDyOU0czfXvvLwuV3SPbKr+wPM5tyJTD2P2AvXKM?=
 =?us-ascii?Q?+ehqb3E7wJ+aXTd7cqW2aOryrbH9/EbOp9iTwkWWRqcnS9SC6poadbk12C64?=
 =?us-ascii?Q?CWkkHuJUr+Fz+LV+BcVBDs0WLb/Rnsb6srQh2oPo/Rwa5rDUYO/qu/EIUwbe?=
 =?us-ascii?Q?8Av7tjXKe8pHu+ZhvCd540JFm1OjlxZdju39qOzESE00am73KBV0zW602MZT?=
 =?us-ascii?Q?TbzbiTM7lnQzaCZMCwaPY99RnRTgQ8IYmlvyKM26gmspdCt1EbjNGmjDgLpc?=
 =?us-ascii?Q?bumkP0uBKAsVMoj8YLamvf03OPOYKwmM1A8lpryhYy74L+BL1+kK8Q0+9Pu5?=
 =?us-ascii?Q?oOkMWGGMExdA+yPWY/fZWiptuWwAbWzv4LrByK9XJlmZBZ44vnFS8x1YG0pW?=
 =?us-ascii?Q?fTrDhPMolcW4xHejAGXXhaHqAjOOh6n1XUm0hN9yzROrHfKK/snlFTGLd6d3?=
 =?us-ascii?Q?09xCBmXvXzbrl0Ym2urTXc4l+133o4dN421I+K7dBUVznze3fI60aX09e2GA?=
 =?us-ascii?Q?c+IkNM++UQZLoQqBvRJ5JjsvS8gD5NNHrveCqXk7P3cf9B+oaKYp8iEpLViY?=
 =?us-ascii?Q?OBm12MYYblk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7341.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n0iHjBJS2RlzDDsrlLLkolZN2U5ZTPA4lMiLypZBO4cu1bnMfXEKrAcFwNqg?=
 =?us-ascii?Q?dlZx3cqFnFkgOsgu41JDuAraBCGctwDU2Zn/sGafjH3hpRlRSnuzKflsq4Ml?=
 =?us-ascii?Q?1Jobmg5MGlq1aFGmbgzWN3YEzLH3gOzb32idlyCj2uoA5/dK7QYdKcW4rG6N?=
 =?us-ascii?Q?EdzTWdaPgbRXCX4wdGrJO8CdfolQwZ7X4eTUislP+qJ+0upk5P7nDD8qUV3I?=
 =?us-ascii?Q?B+wFfmL8yHLriJqj0pT2+Fv9ekA9KuVIcVSFCU7HyAkQTSwtxALoj2JtddVD?=
 =?us-ascii?Q?xNa1yeQqe/2rwC7gh5NuKgUlWnAkSY70VB16Wy2/fTvCyq6AQC6BYSbYez/l?=
 =?us-ascii?Q?5TQpESVSjfbjo/sbY5FPGrA/HXpxmHYidE6h0IixyBu8S0gu5K2B7B0ydFGm?=
 =?us-ascii?Q?1JdZdnhvXwxnyEtozzeOoYRxAmniUyNdcbxqr1L978ljaMiHUiaKrqlma1uk?=
 =?us-ascii?Q?4X7dO5Y1rFJRD/BU8vXHnmrOHlakkAQDp3HZMPPVysPcuhszL0En+6K1oiek?=
 =?us-ascii?Q?LpJSKpnuZt9yfbJDMRhK3GVUaGGMutyiUyYU5wCEgjX2JRutQdkP01mzroHY?=
 =?us-ascii?Q?CDK2GxPFgD879HwjRK8zSK2v/4V2fBnAGFRYdD760XkhFeZXIlVIbXN8vGYn?=
 =?us-ascii?Q?MkrENP3Oz14qVYUtSJEoS5NPddYgZVB2o0SQyNTkpzsrU7n/nxMOi0BFub2i?=
 =?us-ascii?Q?+q6ZCk6ocQGtJhfeUY8UWAV8v3ARon+kFxyanfn7htPEHESffkFQa9ZNmvSL?=
 =?us-ascii?Q?IIN4V6ePksqQtC4cqnHobTHblojBbbfgP2MZ4TufTx1pbuT0T/iWlGojR1po?=
 =?us-ascii?Q?O5yVbmewmze8qBaJUgiZUDiijZB2UETZBJ38NhQ9VNH3Ur629f/d8o72Nkm7?=
 =?us-ascii?Q?yDMPcXAM5E1Eushw/byiS9D7zQ3N//U34ctMpeRLRS5w/5F7IxJ/M+YY3U31?=
 =?us-ascii?Q?x3rroh/VYVpxBOWSw8Jz0CK9PKBScFFrKi5G+6xRZZm7x4dMLC+qtwURICYa?=
 =?us-ascii?Q?WO3ns9FVXreuV3yTKK7/e4MjEspcmTcp3iXbbY6zNSgzfmGFx1mpHIU1mGtp?=
 =?us-ascii?Q?/SC5oWpyZn9EDHW14mGkYodrX4OQHWLzGViUzaymdHUNZkhBWZXyV47WO4FQ?=
 =?us-ascii?Q?I/o13FNjGYZRfh4OZMYppHI0AYHZk0hbxJ0IRwLdfIkQGUZqyWPUiT6knfpY?=
 =?us-ascii?Q?iW9qN0DPNJsS6usuHrqILZek2hDAoBILMnQLHirTDIgi7BKeGm30O1UoXEaA?=
 =?us-ascii?Q?GguEzB/F/A0obcc4ibaNAn5sVrjIJcF9yuVn5hL78HiEH7qHndAE8Q8x/io3?=
 =?us-ascii?Q?Tk3DXHaIFXiSLfkY68DXtwjQ+zWezdNPUMiygWrORW8irZ47OpBTRik7nEbo?=
 =?us-ascii?Q?qp5XF5YVXyyLOMWHAFnblwAZTToWWSz2YNUbvfseGX8aFjyEfT0t3Mhdy78H?=
 =?us-ascii?Q?Yn4M2vKfwp6nA4Xmz5l7bqENm+yZNHhiNhtszWW13gEx6DbFmOTYo6C2GeBY?=
 =?us-ascii?Q?XMu0m2C3O3b/OaH9KqWx3df5X3KWk47GtDCPz9oF6MTLOgBmEfr3bWUAUq4R?=
 =?us-ascii?Q?uF6KWwkD0gR4H9AFiNGC/EH5xGJ8usEDY2CBdMkT?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ne5brrw/1IMylQn3kxzyYNiP8YXvOofRdz73e1R6mkiIAMsMInE52eM4T7wfxdZrq82CWHQ0dZ+A/ORNV0O854/yCJWtYP0OYd/IeOPyjuRxNMXtKAwNCg5hYufmXfxziKI9yjmZuNHmr+4qkFJq7KB/MrKddCFO0gEkcE5fNzBndNlsaOAdkC8+SVLCfcrmBnLvVfegKyQFjqZr/oA6kRnJYYS/tM2i/AtbhN5v4w4qjjrMlHFZ7QpCFNYE3lZmOAd9zsuV5lXAImBZfTKbwlvG5AntZ3mlaDDzWP0W/qZE82GYqDFYpwz7d5yxJ1pWqJfC1ltqgvOW7LN951sX31vbJ/OXgdp2+w/XSuEVaesTALKlYrUoXQ0EeGfhNOloL0Z7s48d1Es0ZZcj+y72Hdk+BTXbuk1Rg52pFDovMOFJiYmfuQuhACLbMMLBETHIbpSZAYcTmNJwWUC2Ab1UZDJLdvN+97C5qtrv9381TUeyOeNb2ZkVNlSY0JGQkUhXRiO3wbo4t67bvf95qUfEaRzjgfM1yYEvPkRHG7JK5A/D17kM5c8qgD826RCvXOUcynvMUu73pLgoaSxoE/ndHQVXraosPfGrZn9k8eVtFCc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ef61883-e67b-4a91-96c9-08ddde3f4ccf
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7341.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 10:09:21.3449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: We7Y1VgZERIrnbwgwpruExnmZPEia7nNOWvwElPEBZVJKgacZbtcxfrGhrACNCFxVYEvHYerkDIhy66rk7F1/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7508
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-18_04,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=915 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508180097
X-Proofpoint-GUID: 7r2wM-Obmv_qhJALhVn5NtIGGvgvihMv
X-Authority-Analysis: v=2.4 cv=dN2mmPZb c=1 sm=1 tr=0 ts=68a2fbd5 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=qXUgdGPzAaJJA45habwA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE4MDA5NyBTYWx0ZWRfX41hTNKNzPaxm
 KbAOnLA+ip4vPIGpjeCcPzH+Zq6q08jEyIJxCM/UTG62Zh9FyzwsBNhIyhdjbfHL6mybpQbzsPM
 vosCZkQH9DnOij8QYhkWToYQVIwwl+7cbduOysyEnSi+aFO+/GUVITGL8w7qySEayXXsTqCrhcw
 WCgm0O9t9jaR8LMXam64kSVKOGxYNAbWYLYSmu6DY+ODzUjYbOCO6mFkuakOY/o2sq8r9CMc88R
 b5wZBQu2yS6nOyWWm0IeZBYP2oHE8b8YlfccOJNAnK81UxgExbd1RVrgg20Qsj1n2tVhCTnuWgY
 BnSK9YE2Gl0s+7U3d+uQKpFZZCC0eCXhcusZJLZQ37N9pUu93ghJS7wonYxQQAXIhvwzgnK0d2p
 aLM19HsuYU5nMk/s8y6a+haOyScRfoIL88Y9pP0i/Rs85tqcjhfoBlM0FJ/TLzAvwl2jxyo6
X-Proofpoint-ORIG-GUID: 7r2wM-Obmv_qhJALhVn5NtIGGvgvihMv
X-Rspamd-Queue-Id: 79FD31C000D
X-Rspam-User: 
X-Stat-Signature: jg5ucosc3exj4fww6zqmjg1yj4m3x1d1
X-Rspamd-Server: rspam09
X-HE-Tag: 1755511768-10909
X-HE-Meta: U2FsdGVkX19Ear49jYA6NdcpJFPVkeJIgnYpJQHnmMrfKsWNIjgaIvX3HD9YsCI9YgEKFMa6Isr8ExSiUiNb7tTlr5T6Z74as+tgjt23vttIaRiPANV84BLcWD1CNcykm+gZhXBrWP8yYntfZ+3/sEDbDTO3gi6agnFJMLnvecdijx2bbD0/hhg82gICJ0lNCm39CCeqMZYZJrAWU0F3ZTY4KMydjwRrLGkMd5kkpekvYI+x4FQDZaSUJxZq4tcpv/4LOtqJZ1gDgM8DvW9s48WzOv0dS2c2m3nvxMTweJEmIRSwBWZCsqi2QBfG939lUz6hAQh21pX8BOAS61p2DLK43OvfnL3WZZerJGaPC2tHE+yAvmqWdYh6BgSPTpjNccI7KFsUC22NIoEsH4efqZ0mZYYx14OsNUoio6VzavN5HMvR7eyt9/pwIUjVKUWY/+K/slhqTrRtKSYnu7KbDqSfbrCabEQFzzxcSoYuGfppXQxgfYJxhY7qN1JAoZwMMEQUi3TFzg6QHEf+bFRrXVy+sj3D2J4J/x8nfaHXJVml4iec24cGmKzg/U0rgIp6DG3JDkYe9ufVZ2OqRefHoeV2YFsHMALatUITLUGG97lF6f9DaM2xgFNiAmqq4jddygSGBffJ5MqJE0W8mnKVXr1JaJWT/cEDumwZScVi5GS48qsDuZ+BADUtJlgu/AIqC2Eg9QzuPngJbJKzctS4oe6cbWrF189d+Pl6ANAFJYQHAxHgA4bnRxeCE1k4dBdPC6dAYCS/W1va/36ZvUIuv1oKBeA13LcA6P+jzzf1I14WaxbXeDFxFfpawLesVN+sIN2mGw3U6eM984weod9jetJ/vITJvGWpvtXikZmD3wwGA/aO9LTdVneOQY67yR2Hkd1dB3M7hczZqJ+v9VtWw4XZVHypACUuGJaaR48YESt3KBttxVFZ+608APGFhsNxzR2NI1ZFT3yXjy3+vAv
 B1XDGlbX
 ZntMGYjgPybpprxgornpYadSFhztusbmLEDLnrnW4OkGwmC3I6hEOCy5/KudX46nS32KD5LzDWB4DBLBiIUDbes26eglIHjdfCMBamR9ri+AiRijADAdiYFo/JHKjw97vDT7pbJKXcu7/ESNbCA69zigk5LUP5kJzQNnrrX0lXwSzSbyw7k/GWiXlnNmYUJR1lG0mO2ZIvyqAzO8I0XARu6COtlWT0dWmuoKLeJ/I5DLEmhF4zEcbdlXBEtE2ClrzwPDoNrWl6X0+npDw20cVJiQRsb3OPO/XQRc2ZlM+Y65HeIgoXVuAx+le47If/AXgrbx+Wg6b6/Kw6r1CsS27lXBJzisvKCkTlQyKQw84779aLcRGsa6BxqwsBTj4phUc0pA/lVlbpJ+mkWdm838b+F2y8+7LpMjWj7jY0knEFaNRSYNBNMQjPTPuBoTk3YfP02aVjfq+bxSIkfxHOlPl97LI1R/o+zAKQkbrw3h5VoowyCevrdtirG2RndMeGr5alc9doqSifXB0VVCkTCNr5rI17IDYRRTKJIbKU+0tvPGXbVfFtLeQkDpeh2eDHRtWwBx8d4mrjyK+IcPjhP+PdQz73iyGz8/mNmY6a9NTltHe9FHl6jfgjUnSj8ONzObD1s9qg8vExmHEV/yjmJFiWM6gz7rv6UgxrH9nWdSqabMST+FKYH07tO3PPNfno5l+pifrkcuTd6v31hdKsNuesMn2/GcVq7pK4QxbQUrLlOwGmp6yE2yIp7RcqLVOBtmD6hpX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 03:34:34PM +0200, Vlastimil Babka wrote:
> Specifying a non-zero value for a new struct kmem_cache_args field
> sheaf_capacity will setup a caching layer of percpu arrays called
> sheaves of given capacity for the created cache.
> 
> Allocations from the cache will allocate via the percpu sheaves (main or
> spare) as long as they have no NUMA node preference. Frees will also
> put the object back into one of the sheaves.
> 
> When both percpu sheaves are found empty during an allocation, an empty
> sheaf may be replaced with a full one from the per-node barn. If none
> are available and the allocation is allowed to block, an empty sheaf is
> refilled from slab(s) by an internal bulk alloc operation. When both
> percpu sheaves are full during freeing, the barn can replace a full one
> with an empty one, unless over a full sheaves limit. In that case a
> sheaf is flushed to slab(s) by an internal bulk free operation. Flushing
> sheaves and barns is also wired to the existing cpu flushing and cache
> shrinking operations.
> 
> The sheaves do not distinguish NUMA locality of the cached objects. If
> an allocation is requested with kmem_cache_alloc_node() (or a mempolicy
> with strict_numa mode enabled) with a specific node (not NUMA_NO_NODE),
> the sheaves are bypassed.
> 
> The bulk operations exposed to slab users also try to utilize the
> sheaves as long as the necessary (full or empty) sheaves are available
> on the cpu or in the barn. Once depleted, they will fallback to bulk
> alloc/free to slabs directly to avoid double copying.
> 
> The sheaf_capacity value is exported in sysfs for observability.
> 
> Sysfs CONFIG_SLUB_STATS counters alloc_cpu_sheaf and free_cpu_sheaf
> count objects allocated or freed using the sheaves (and thus not
> counting towards the other alloc/free path counters). Counters
> sheaf_refill and sheaf_flush count objects filled or flushed from or to
> slab pages, and can be used to assess how effective the caching is. The
> refill and flush operations will also count towards the usual
> alloc_fastpath/slowpath, free_fastpath/slowpath and other counters for
> the backing slabs.  For barn operations, barn_get and barn_put count how
> many full sheaves were get from or put to the barn, the _fail variants
> count how many such requests could not be satisfied mainly  because the
> barn was either empty or full. While the barn also holds empty sheaves
> to make some operations easier, these are not as critical to mandate own
> counters.  Finally, there are sheaf_alloc/sheaf_free counters.
> 
> Access to the percpu sheaves is protected by local_trylock() when
> potential callers include irq context, and local_lock() otherwise (such
> as when we already know the gfp flags allow blocking). The trylock
> failures should be rare and we can easily fallback. Each per-NUMA-node
> barn has a spin_lock.
> 
> When slub_debug is enabled for a cache with sheaf_capacity also
> specified, the latter is ignored so that allocations and frees reach the
> slow path where debugging hooks are processed. Similarly, we ignore it
> with CONFIG_SLUB_TINY which prefers low memory usage to performance.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  include/linux/slab.h |   31 ++
>  mm/slab.h            |    2 +
>  mm/slab_common.c     |    5 +-
>  mm/slub.c            | 1101 +++++++++++++++++++++++++++++++++++++++++++++++---
>  4 files changed, 1092 insertions(+), 47 deletions(-)
> 
> @@ -4554,6 +5164,274 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
>  	discard_slab(s, slab);
>  }
>  
> +/*
> + * pcs is locked. We should have get rid of the spare sheaf and obtained an
> + * empty sheaf, while the main sheaf is full. We want to install the empty sheaf
> + * as a main sheaf, and make the current main sheaf a spare sheaf.
> + *
> + * However due to having relinquished the cpu_sheaves lock when obtaining
> + * the empty sheaf, we need to handle some unlikely but possible cases.
> + *
> + * If we put any sheaf to barn here, it's because we were interrupted or have
> + * been migrated to a different cpu, which should be rare enough so just ignore
> + * the barn's limits to simplify the handling.
> + *
> + * An alternative scenario that gets us here is when we fail
> + * barn_replace_full_sheaf(), because there's no empty sheaf available in the
> + * barn, so we had to allocate it by alloc_empty_sheaf(). But because we saw the
> + * limit on full sheaves was not exceeded, we assume it didn't change and just
> + * put the full sheaf there.
> + */
> +static void __pcs_install_empty_sheaf(struct kmem_cache *s,
> +		struct slub_percpu_sheaves *pcs, struct slab_sheaf *empty)
> +{
> +	/* This is what we expect to find if nobody interrupted us. */
> +	if (likely(!pcs->spare)) {
> +		pcs->spare = pcs->main;
> +		pcs->main = empty;
> +		return;
> +	}
> +
> +	/*
> +	 * Unlikely because if the main sheaf had space, we would have just
> +	 * freed to it. Get rid of our empty sheaf.
> +	 */
> +	if (pcs->main->size < s->sheaf_capacity) {
> +		barn_put_empty_sheaf(pcs->barn, empty);
> +		return;
> +	}
> +
> +	/* Also unlikely for the same reason/ */

nit: unnecessary '/'

> +	if (pcs->spare->size < s->sheaf_capacity) {
> +		swap(pcs->main, pcs->spare);
> +		barn_put_empty_sheaf(pcs->barn, empty);
> +		return;
> +	}
> +
> +	/*
> +	 * We probably failed barn_replace_full_sheaf() due to no empty sheaf
> +	 * available there, but we allocated one, so finish the job.
> +	 */
> +	barn_put_full_sheaf(pcs->barn, pcs->main);
> +	stat(s, BARN_PUT);
> +	pcs->main = empty;
> +}

> +static struct slub_percpu_sheaves *
> +__pcs_handle_full(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
> +{
> +	struct slab_sheaf *empty;
> +	bool put_fail;
> +
> +restart:
> +	put_fail = false;
> +
> +	if (!pcs->spare) {
> +		empty = barn_get_empty_sheaf(pcs->barn);
> +		if (empty) {
> +			pcs->spare = pcs->main;
> +			pcs->main = empty;
> +			return pcs;
> +		}
> +		goto alloc_empty;
> +	}
> +
> +	if (pcs->spare->size < s->sheaf_capacity) {
> +		swap(pcs->main, pcs->spare);
> +		return pcs;
> +	}
> +
> +	empty = barn_replace_full_sheaf(pcs->barn, pcs->main);
> +
> +	if (!IS_ERR(empty)) {
> +		stat(s, BARN_PUT);
> +		pcs->main = empty;
> +		return pcs;
> +	}
> +
> +	if (PTR_ERR(empty) == -E2BIG) {
> +		/* Since we got here, spare exists and is full */
> +		struct slab_sheaf *to_flush = pcs->spare;
> +
> +		stat(s, BARN_PUT_FAIL);
> +
> +		pcs->spare = NULL;
> +		local_unlock(&s->cpu_sheaves->lock);
> +
> +		sheaf_flush_unused(s, to_flush);
> +		empty = to_flush;
> +		goto got_empty;
> +	}
> +
> +	/*
> +	 * We could not replace full sheaf because barn had no empty
> +	 * sheaves. We can still allocate it and put the full sheaf in
> +	 * __pcs_install_empty_sheaf(), but if we fail to allocate it,
> +	 * make sure to count the fail.
> +	 */
> +	put_fail = true;
> +
> +alloc_empty:
> +	local_unlock(&s->cpu_sheaves->lock);
> +
> +	empty = alloc_empty_sheaf(s, GFP_NOWAIT);
> +	if (empty)
> +		goto got_empty;
> +
> +	if (put_fail)
> +		 stat(s, BARN_PUT_FAIL);
> +
> +	if (!sheaf_flush_main(s))
> +		return NULL;
> +
> +	if (!local_trylock(&s->cpu_sheaves->lock))
> +		return NULL;
> +
> +	/*
> +	 * we flushed the main sheaf so it should be empty now,
> +	 * but in case we got preempted or migrated, we need to
> +	 * check again
> +	 */
> +	if (pcs->main->size == s->sheaf_capacity)
> +		goto restart;

I think it's missing:

pcs = this_cpu_ptr(&s->cpu_sheaves);

between local_trylock() and reading pcs->main->size().

> +
> +	return pcs;
> +
> +got_empty:
> +	if (!local_trylock(&s->cpu_sheaves->lock)) {
> +		barn_put_empty_sheaf(pcs->barn, empty);
> +		return NULL;
> +	}
> +
> +	pcs = this_cpu_ptr(s->cpu_sheaves);
> +	__pcs_install_empty_sheaf(s, pcs, empty);
> +
> +	return pcs;
> +}
> +
>  #ifndef CONFIG_SLUB_TINY
>  /*
>   * Fastpath with forced inlining to produce a kfree and kmem_cache_free that
> @@ -6481,7 +7464,6 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
>  		__kmem_cache_release(s);
>  	return err;
>  }
> -

nit: unnecessary removal of a newline?

Otherwise looks good to me.

>  #ifdef SLAB_SUPPORTS_SYSFS
>  static int count_inuse(struct slab *slab)
>  {

-- 
Cheers,
Harry / Hyeonggon

