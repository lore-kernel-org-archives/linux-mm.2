Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E319ECFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 15:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 468756B0031; Mon, 24 Nov 2025 10:27:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43FDF6B0032; Mon, 24 Nov 2025 10:27:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 307DB6B0062; Mon, 24 Nov 2025 10:27:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1ECF56B0031
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:27:05 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC76613007C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:27:04 +0000 (UTC)
X-FDA: 84145878768.23.04E20B3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3679240018
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:27:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ix4xEIgw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FzUUaQrJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763998021; a=rsa-sha256;
	cv=pass;
	b=veBP+dcIS8mWzDM0qEXVbuzmbVqk6Bbwsn2Mc0kWDNdFZQlIKTDoV19sEvn2OFFfVFHRCP
	k6JrvamQ4FYarpwOGuXkIgFbpMSJ8H3ebEalXK4GwwMBUNOT094HZMdmjYN5ArLrytv6pr
	iutQM2lJhCsRfD3zIFqh394fa1nDwxc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ix4xEIgw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FzUUaQrJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763998021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dqXAq0+msEKuvU5DjY+gEMRoygpJUaqYeJjnaZCxSHk=;
	b=8EdByw1vDF2uPZ0mpEFDyOSIMKeTO+YkUsi3Ms+PZSdlEet+tTCj+VdJw6FtB791ctCTmW
	tM6xsIsDa2zPzH9/BEUk234pVyYDZN5dWdNnTO975nfCPX5KsKcl0ZWXR+ORl3GjQ43dIG
	F9OR2kc88inmw+XRwgpGQ6qEaazsyT0=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AOCVGCd1038231;
	Mon, 24 Nov 2025 15:21:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dqXAq0+msEKuvU5DjY
	+gEMRoygpJUaqYeJjnaZCxSHk=; b=Ix4xEIgwWPLL+MCStrroEZCXtIw7n8y0bf
	noftcnKcJ/PCQVvewaATbyOVBlrSHeEK5YsiHaK0qKG0342MnCLCRAiHqMAxUZsO
	qQu5hxH2ELsXt2vJB5DOXOuV5EjLpN9AkDlkZwHAnL4Fhk/pn2XRnmx0sZLXu1IK
	ok4nhfnHtokeYRnYRKaZiYpP6AJI0K/FA7IcQrZRh0eJjvdcl1/f+HUFkKG0AUGS
	U94yOP3HtT/H77wfW+aNLkW7Xo+RY6DE/0bFVouWASddK8mxph0FzUwOMcjEh8Yz
	QMoSCcTAgR/xeP1n1ZuD+X235Z/obIoj32IWzot/p7+2vgx8IrkA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8fka76j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 15:21:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOE62uj032077;
	Mon, 24 Nov 2025 15:21:50 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011011.outbound.protection.outlook.com [52.101.52.11])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3m8817k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 15:21:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S6ThHFp1e+oqafDE89KINdOM6AZL8zpdnMsEqZ6X7QDYhfwTOMFmFRsYCFE6RdNY3WrT11zQ3UT7is+gcq1MX9JNiKMadmnSp4N8aT2hrgbbgcrMVXtOHY3vDaOpGDvdgeDnq68pdqHmIAb2zX+ZW+QO6gpn7uYowlC+p/IfKsccWAjNKco6mkdza/yriAb5dgAM7qz31XLIjJloYW8F7IQaUNaBxSM53HxehkorkP4Z1sPxL6R3qE48MP39+qircSZnz8XsIYwhl4wIMwk2PxLHMws7417rW781sPjFgb/WWIdHSU/ZitTICKomQGnZXc9Nv/BL5pt6G7jFZsiR8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dqXAq0+msEKuvU5DjY+gEMRoygpJUaqYeJjnaZCxSHk=;
 b=x/iQ56+btEyoL4QKAn5XYOJ21AUYvYMTScSnInlunt3iC10hDRjiuzBfT15/ZQG6PudcLsqrX98izoJu7dIsOGwrL8GFBYhrL2CTZZP8Ascs+v3JIYAu9z32yRxwPgGj1/rzM/MINV0W+QPhPF5/KYeiZgS/Kg4WHHuf/Z6lduRdPewGhN/A2ssEv9SwEEuEYcmu9EpL7jKr2EXNdCB37U2z4Kmhm4JM6lZX2qR8aIoUfwAnYe68IXxtrSKThw/mbP81kxmXfPnCIsjoqe5qe2z9VVOR9Rf2KyybrDenGnY6TP5qS8C8Mk9IMzQzthpg1VWuUQgqSA6ety6zvDkQeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dqXAq0+msEKuvU5DjY+gEMRoygpJUaqYeJjnaZCxSHk=;
 b=FzUUaQrJ9xaZcd/Fvvh4NRiv7IaO+Fg6Mh3HdDVvIlqYAXKCv11pfcv04toB2G6s+qRK1Kk6Hx9tMAHhboji0a4wSJtpKAvr5tip2I3fjgbqHk1UHXHqvV+4gLJw62iQxaMqdLodW83+9JLsf3+ZcYukd273gmK2b2av8DN0zSU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB7697.namprd10.prod.outlook.com (2603:10b6:806:38f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 15:21:47 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 15:21:46 +0000
Date: Mon, 24 Nov 2025 15:21:43 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] mm/huge_memory: fix folio split stats counting
Message-ID: <721894de-1b36-419b-a3d4-0ab43d607d3f@lucifer.local>
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-5-ziy@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122025529.1562592-5-ziy@nvidia.com>
X-ClientProxiedBy: LO4P265CA0316.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB7697:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bd2a7ab-ce82-4d76-ee78-08de2b6d2e79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lqXqZMbSEyZ7Hzty3lMMbsmpNzkMHORibjYhFiMOL4dFT4BHs7GEKGlC/fcJ?=
 =?us-ascii?Q?aPzFHvLICwv8sl5tE9dTQr1SWIMrbluYLxb29MQVdXc5Z+R3LrHWOcNVECLj?=
 =?us-ascii?Q?HZpuNq3lNKPM1gldze2EX76pdIBSdXzHDDSgTSED8h02LT7NN64Da03ZwbhC?=
 =?us-ascii?Q?nY5gPfNUSrXJxvdDw27F5m74syQrYmwJ1bMNHMH4Hmm9/WjfGgpUYfH66/5P?=
 =?us-ascii?Q?cerlO86DK1cIreW+ItqfibFJnvybLMYVPW/w7IbZbZabwhjLXQKQOS/1B43R?=
 =?us-ascii?Q?c+OpiVTWejtrVBSOZGCu2jaGchmrSlbxe7xl5bJmPg3DNyzVym7CsxKqOazT?=
 =?us-ascii?Q?D27JB7g6fxtobBpoqsgiGNaHW31/5XE6dIzposZMzE4ugFepR2BIft2CYmT0?=
 =?us-ascii?Q?divEPL+834eSQHQnDjFSSTNywBeGmYJhMmNvMEXxzc5wYTKpbItB73ydS8Wm?=
 =?us-ascii?Q?ctHIUk5w94sjdgt4jhejHoPpq6uubJNZLrPRpalAylNWSpfmAc/h1mme3SD0?=
 =?us-ascii?Q?UL72ebOP7ByMvGDgSu3VrdopwJDT+0Ur+GNZXwtpNL7p3eMbfBBb+lek4IN0?=
 =?us-ascii?Q?D0OJgeTaqYFkgcIZZmld/+ExnAWv+4KTY0iqozOHeui4tp6blyQ0ASgENoi4?=
 =?us-ascii?Q?xZNlvlQRIol6TILPw0Lbf1Qul9PUNa3Lybgxbuy2slUNYtxDZUCuPuWqWkEy?=
 =?us-ascii?Q?DQwQmnMJW5Gwg/kO8oW/IZEgHWMsXp1jZN4WgHs+Pv7e6mGX5eViVspniUr6?=
 =?us-ascii?Q?RzziSONqUzAlQCM4Mx+vhrsKjaGSeFOC4TADdOIX3cSCxxGu7ZSCqpAJ2Y6H?=
 =?us-ascii?Q?tC3MaLJtE/gmxobM+lsFnc7YtBmjhDvKduXo4DyzCVXwkph6XG9BCyBsMkpi?=
 =?us-ascii?Q?3GlYl8FfW4YE7iYnQdTbYDkkInb3U+Xk+f+m7a1Wrig3xd8ejBml0DWKk77M?=
 =?us-ascii?Q?0DjGXTnMRMXMxU+rXxiqGoJso37vrBR/EBpOAG11sAeXqBNoNPSc1TzZtbG3?=
 =?us-ascii?Q?0+yHELrHs/OVX9xtDZF7ZvFQx+DHLMKrfu5iFw4r3ickQ0ay040fnVz3rGNL?=
 =?us-ascii?Q?IqOzJsXvsG6Tnp+jypV/TzaJfd2/eEDrLT4w0/yqT7pLGqkXX6S/upct+Yv9?=
 =?us-ascii?Q?r4Pr/FOaltM5W9YmoGPqAGNJEmGZMpGQa+3rwp9D7pv7AhLMryPZmGmyTT7O?=
 =?us-ascii?Q?zxiFbCshmBk/zNnbFnPaoCtOvDb0LoIpzSO21Yyn3MjK9yCT5uVG1ZZ2SMyw?=
 =?us-ascii?Q?nuovErkF1ds4wK0MyOnmXDNmbawDuXvaach1TyqgD3q5x7nPowgcOAvqszmG?=
 =?us-ascii?Q?QndEFUO/RiwASNpziTJ6gFydy51xgDXyg8JVxLRsAzAVhiLSUAyXJyXVw5/5?=
 =?us-ascii?Q?b7HrXwtnx/MQ8MlgCc7YyIW+CQ5BGmv2cnwLBbT/5IWCVwhVM5g4VVvMVsfS?=
 =?us-ascii?Q?UHTrEI7O9yJQZuk75bsN6rgElV5fM4PS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nGurneOZaQleF6nOhaKRzmRPktDxCIHCTTt7VWXWZ0Zf66goW5uQV4WMXUjF?=
 =?us-ascii?Q?/2Qb+hH4pOf3+bI/Xe0ZWwcHlJ6VhLh5TtTJ82oOqK0aebhtYOtvSqIVy88J?=
 =?us-ascii?Q?9hmU7RMo4Hcv6iG2IXH8ndoXabQzhT9w6zExJGey96TTcIRdBy1Qr0Eb0fgH?=
 =?us-ascii?Q?4Hal06oOc8wJlbVaJGnSw1K2wh3UMkGvnHEpRzRsAM8uR0GwrXNs0kBRrxfa?=
 =?us-ascii?Q?rqUriRSsRj0tCoIC7q1kLZ9gIAHuXcuIjnJcA4nX/JAyl4/ARq4hbys8KBNm?=
 =?us-ascii?Q?6v91iFmyEcq+36mdIeSK1yqku4kXZ85M38MQRi282Pa95HAje7MBKKLGQPVg?=
 =?us-ascii?Q?+aV3gDLYeP5y6Rypq7qnXhgBwF6Ehb58S38FJOt/Ifd4vwtYB2bHI7M2WPNc?=
 =?us-ascii?Q?4bgB0JgVuMC18+huIPY28m0LK8kyVaP+RAiMx7vkGjjELYtOSsASj9/YddJ0?=
 =?us-ascii?Q?c320ZMza+DIpytcEPjIgDAXfRvM3u9XFQ2tcDkBBGnHZZJJcQJkfxQfrH2om?=
 =?us-ascii?Q?teGHp7Ej4p/I0grAKEsCfODEaLtp86WRtzRypSOM7cOmHP12CopnUUdLpWs0?=
 =?us-ascii?Q?SZKDLJIpPEbulTB6lisJz8+oQySyGmSaGXkiKoZ/xpX+sJGZ96R+UJGvFBxI?=
 =?us-ascii?Q?Vhp2abdyMsbprjJDUiOHTAjYA1uODJ9gue9OzFmuf5ewIwM/aX48CmdlRXW0?=
 =?us-ascii?Q?ATAplAJqfNewFSiRoDywDP7cB/hIU2Pkuf5eXx05CS/TDcYmRhm4bBiF2WRG?=
 =?us-ascii?Q?8jTqk4e20l2T33BasD7J3q2ofyqLMD6uc4oX4dFCPyPnveijTXWPKd/pRrEZ?=
 =?us-ascii?Q?FdxWze+TBzxDDYvV0X2E7U7XolfYFKUZiJZWUX9iMKdLwo8RrHRbZvRYPxUl?=
 =?us-ascii?Q?OhmF8hcBCgMDs6NauBTVMjFXge1HKjWFs8cg+bRTEE7bfINZcwqK95ug/KAh?=
 =?us-ascii?Q?AHhD1CL7qVwghCq07lGI9PwOqTEHbib8FH0mdC8jLJak8U0RZ+SCdXZZm2w1?=
 =?us-ascii?Q?ZH62aKJK9/lVJqFRYjhI4SyNj8XJtvSSy5WzEdHdwc9YFpU2KnsWxwN1481D?=
 =?us-ascii?Q?ezmk/KtSKEYoo6P7+8atAZukBJlwM0y0o0XTBV7ksij0Lpvhz5SB4R+KVqSz?=
 =?us-ascii?Q?SQjoM5uJzGUZOHQuJuO2DFQA+S1IX+c55Wd/LoUeNxTeR+aZ/tc8RrjommtX?=
 =?us-ascii?Q?C5Y0gVDQQ0LI0TR7zteUD2Lajvi5gbnzo3dGcwPeDP0Uvjkrmcselqa1oLns?=
 =?us-ascii?Q?QiwpsJhYjEeDg6ScTcYgi1gMYDLDHUGwTaZLv6RvKYpdkGyyRlOXCYb2aAC1?=
 =?us-ascii?Q?DQPoQz/V09ywFWx+Y+5bBeU5DqXYpBjjGXlrbLQ/1w5+5Gqj1k/0oM3Pqv5a?=
 =?us-ascii?Q?RXbYc3OiTeg717V4w9mkhlBU3I6oQQ01ALHwG0bLyZv52e7v7nATuYuaawi6?=
 =?us-ascii?Q?azaccRs4TASHcQ7V/r8s33UOkcrOiMCmyqTnQSm7FKJ0vPR2+j7Ls0fheIz0?=
 =?us-ascii?Q?UCiSzZw/ieqFdwkPvVquZ51WB281T1c4Pv6yxdu7Dqh56vNyNOB1dKfDEJ+a?=
 =?us-ascii?Q?MJSsiXajamThKG+mdlL+2tVp2yiE2JFAlCjhpg0xc13+Y2RD1RHBZrsxtWub?=
 =?us-ascii?Q?Bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cnm9QrefxuORRW0mgYwIUNIdE80FvAFFsENrYOL1gu5Zcsa9f7wx382+pqVJSuKPVY9vwbpbHVmjbDzt6muUSMTxC46pe4BbZdxNO/p4REzp97h1xvc8s8Dqk0ru/bAJ9HWHoQK8K+6fG8J7kfGrLU/IeUXbpdqdYaGSitHjUa1Zi8sDFxRDnwFXqDakmGsFrj+wC/8ZKl7du5c7Iv1EwqXV0dZpNpD0wSd+Aj8XjwkIbv4o2G61J2iq821cox6obcG6yCIgkOMg5yd1z9cdBYXMLG2r/9QC4lG3zeF9Z/wb5VhX2+NuAX+pryEsEgXV9+BO1Pu72Obs8Pp5Hp1bS5ljs+Jl1Xan08NcaFN6LspkdNQNL/qyXF9OKNpJMG7XGs5/y1DU1H3pdUusVkNwjBmU3xt26gwhvuhcDGk9Xbv6FZWzEocgwgR6myQS2OqPjs1VtqVxtToD3AqzgGxg5Im1GAa4ybYS+pXIYrBC851vNT58q9m8KHQzYwG+uA62lFex+ze2yKd4Nol6gbGRpI2fGaAeC4Pz+Bv+vReMLIcYbk7+F4seWTtSjQevkukCcVaOB2B/BV3CS2FOm+Q6z6whAXnSGYee/ZBjq++YuMg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bd2a7ab-ce82-4d76-ee78-08de2b6d2e79
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 15:21:46.4978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yFd75eEFgGsC1/RCQ1NjSATk7sB5br09cEUxxoalaTBekUYze8w7y6pgOuYPbqoG/LFujJ3aHN8+VLOmQlGBva1e9gTquga4i2O54VP2IvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7697
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_06,2025-11-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511240134
X-Authority-Analysis: v=2.4 cv=f4RFxeyM c=1 sm=1 tr=0 ts=6924780e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Ikd4Dj_1AAAA:8 a=yPCof4ZbAAAA:8 a=fYDh86TeQS7fVQUpQZ4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDEzNCBTYWx0ZWRfX7LkmLYhYlxL8
 K0Li/jI5t/8hOHF8oL+M2ub26ZUgCNmVx9/kQwGTwyJaPpVCEgUGzLsxt0VHVUVhzZQWLlVSMwG
 lMFr0+Y3nTgX0s7+cNlxUNiqXMtPjncvgb8t4x5WmGZxXZuttKwrhFcUHpGXErfrJXreubNiO8z
 kPmzDGRhl7noTyz2lL0ypu7qoUnaTErl8jqE4k9H5/OROF19u8tzF9/0LlVR4NtGv6JGgHPLgiI
 kZ1gtn+3gn6C/YxVRUFjdDdohmd1NtM/ah//PXegWpd0xQ9unie1qp8+U2zIe3R3veu97bVnrCr
 n2cl+quZGrfIw8Mfn9JtOY+Ky/zEs7KR2nddCK3vxu7dNXIyNa0O1b85Iv/sDZudq/8sLgtTFEr
 nYWc6RbLvbzKrKJz15NJaXBmJ/WBHA==
X-Proofpoint-ORIG-GUID: iKg_Vwhz9_N_jJ7Kg4l1puHwEs-vFlOi
X-Proofpoint-GUID: iKg_Vwhz9_N_jJ7Kg4l1puHwEs-vFlOi
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3679240018
X-Stat-Signature: k5fodb4qdehuu5w3yxm6mgfug1gz3zyn
X-HE-Tag: 1763998020-780948
X-HE-Meta: U2FsdGVkX18/K0ywCFJFpdOJiI6ECMyEcTEy5yAELTTNf5CSRqmT7PyXcoISnSPsWWJrEQEBvJxk9FR/FyUpTKGc7Ch0oUl2m6EVle69wmh15Ni92qLdhDGNoGynD10ITAxlU539zjIt1UxOEB2WLEa6T6FWs7c+v/7R61eTqLmsAxqlwo8duFa//IsMW+KknloN4VJ2XsvUHYR8v3+7FHFcKrhEao/sGIwkhHRi+Wqcd9Ottxg8XN8wGbG8jLzWho56law6T2d2DK3kqjDY1TxdjNl4dI3aIOMigIozZSSsd6+aMJb5sHWpQrEjd6nNiW2E4F7FRYmrL7yUyd3YfNyVeWVROYrIbu2rMlZBbYvBYjeRE7GuJBE+RE2wtQzsSi88VciD723DC5ntWIn+XD411jBRql6sV45Pl6mZAHjBgI1/KJE9EnD+KQ2NNZUdhy6J0Xm+4M+UAglYai1ImDrwOxqd6aQ/4JPv/0v2pX9pOaMnr3MMhkU3lVMKqGxoQ0Zs1UcSIT4a0zAXAuKEc56+cKBExYVlS/n8kD5thHqcYslDUN7lBAhul5n1pQmdPDCEcOD00a+vvJI3lWaIYcnKxSUHfwzcBJhLYw0pUOmCDwh2i/flJoyOE9mop1XoFwLHyebJWAPOn7PiDWeHqJiJzzoSyfFHPS1OUA1zMWMsL+FkgsrReeFzy1gr8vO9wSlJOgmiTHI7Eqj2/m98qI2uXmq1+noGJFYzfUEFt9Tv8Vp9esfnmcFP0k0FUYUYgR7iU2LDbd4mJU6xXCUS8DzxE8yHLPhELw9haGdm4a+yPlg4keDOy+LazrWXmHEwq5GW+kxDPj+j1VVwI73jV/EG1n9Fw8rTxOAkImB2MJB/H8FT3zMxZunnVL3gLp212UZe7Slg67wul7DbWJQX2eVpsUGOtRVZyLSWtZWn0bbO0rO3jNAkKpwoxTLGTJHvgW4ScUrYmxpqGKL79i4
 X3XDQ2U0
 Zn6jC4BvvJiHUrRkW+TGqtVqZb0jEapzf9F0vELpYIFhKaNnhI72A6JVlUarTrq8ksn9awhOOey4Opa2SNFMnXIGRlKkVHXybdSWHzvsdeILt7/TaB0xn/wDdoh38n8N1wLE+ANNPKup9354UVm1mb7bL0VgbS+CCmsOmANU3b15FX0pD6Z99m6wRQxhMcbS4hm0y964PbaRr4OWXo8hSvgQDy5SZYWJPbtnKMmYfopYStLYRpnvIlH59NiFM7GOcu9hACHNIOx7cfRDmTAI8w6+ZJKYAd0ZG+jKqtay0ko8HwvZHzZIEMVLvpoQipRD44eT5mLWNXtcqrQS2krTp7BBD7FcuWZysp02WeBjhj5xerygMze5mUtFdX6uv8BDm8x0BoUJ6wWNL0Qr8F8d9UhZWQ8S0RdFQhZQeqmuZl6PXWeEpTYlHqAzfDVdGtOvnJFvPj5DUuh9sb8XBcpoLjx06uXoVyBdEDHMq1DZ4QEFLIy6mFU1X8Wdd2D1BnIX4+ObJ/23BuD74GaiVwlD7HMJMoN0vby3ngQYFN+b9rSmypgWTkukiW/uvwin/h3gn9E57zBOHdEqyXFld187gncxJboEGxoJZyBm2G90Ou5A6rg0scFLEC9LgWRpI/dNhsv0X9GaMAUIoSonfLVgh5JEUTUxAKJwhK6jmt8zoqpTsJbblSfUoUdEPwOLqjKa5h2fp8yImWUQa3n4QRR5CxlE0cNP2MfzsLkUq00eZXAbt0ndl1mh4n7W8v0mvQIuqPTvH9c33zDL/XvC5KCmUf9sHQLiYZkmQPt4N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 09:55:29PM -0500, Zi Yan wrote:
> The "return <error code>" statements for error checks at the beginning of
> __folio_split() skip necessary count_vm_event() and count_mthp_stat() at
> the end of the function. Fix these by replacing them with
> "ret = <error code>; goto out;".

I guess the xas_destroy() there will be a no-op in these cases!

Good spot, as David said, maybe one for stable then... not sure if necessary for
statistical stuff though?

But at the same time, maybe users will be misled if these are incorrect?

Has this bug been around since the beginning? Be curious to know if that's the
case or if it was introduced somewhere along the line?

>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>


> ---
>  mm/huge_memory.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ebc3ba0907fd..a42c4f29ce4f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3954,16 +3954,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
>
> -	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
> -		return -EINVAL;
> +	if (folio != page_folio(split_at) || folio != page_folio(lock_at)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
>
> -	if (new_order >= old_order)
> -		return -EINVAL;
> +	if (new_order >= old_order) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
>
>  	ret = folio_check_splittable(folio, new_order, split_type,
>  				     /* warn = */ true);
>  	if (ret)
> -		return ret;
> +		goto out;
>
>  	if (is_anon) {
>  		/*
> --
> 2.51.0
>

Cheers, Lorenzo

