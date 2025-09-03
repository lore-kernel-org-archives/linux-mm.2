Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE35DCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 17:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C079B8E0005; Wed,  3 Sep 2025 13:35:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF4F8E0002; Wed,  3 Sep 2025 13:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA6A88E0005; Wed,  3 Sep 2025 13:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 968C48E0002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:35:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B36CC0804
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 17:35:16 +0000 (UTC)
X-FDA: 83848640232.07.8BE4C2E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0D99B40005
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 17:35:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SCi7nwmc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=md15tJg7;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756920913; a=rsa-sha256;
	cv=pass;
	b=wZVk3JHRbA8XnFHKjfKcSVg1vS1S5Qk8ZowAO9H+REnID6B5G4h2DswdUiDzj0t7ttO2Pk
	kkiOE3crP/VRnTRSayOQVVQdSFTe+Quu4etR6kAa6IBslXMhaB8WwFi3vK09xohjtOT/sD
	Wml2tkObKEiV2yjcD1+8HPUrTLLk4og=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SCi7nwmc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=md15tJg7;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756920913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jARuuAweg/sH/cS0/3XM9OOtRiYYM92UUVnccFCaUJA=;
	b=MHYYKmtv3b3TIcEAaPdJO3vaiU5ELs5+gASGnqe7bHUpWx5m/9s3jYIxdsIl182AW3+CZy
	9+zxP9RxhbnZ92iZ32wEgJo2u1Xm1ZeSsJtvDDHhws102ZJ+JqcVxaC3xeVC+L/cRdDh2D
	RP3eDzhUnV5TrnMthdn8T0haBZSRp2Q=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 583HUnOB026801;
	Wed, 3 Sep 2025 17:35:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=jARuuAweg/sH/cS0/3
	XM9OOtRiYYM92UUVnccFCaUJA=; b=SCi7nwmcUBtfoyAgf4d8IOjTwIjT3yWD2g
	Ab2i/PvKb2SDc4oy+9gb1GT8F9KGhIqoeZvXKK6zYEWNoUDpHTywr4H6qLrmTTSY
	bnyQq4OQjNqLI+bijRXt4Z0ds5ES8IblCarGbsSl9viAJV7y6zjq9pXqwP7ngCr8
	7wJioyOgzDYjcoqjhqpEYCK3fd5rmxOLAo4saOtu+sgxGW4ff6wbxi6Bhxvq23mE
	lYLFluU0DSF83UtviRISBYKIQh2cuCcvrl9S92pWcPPekj67VLJQO1R21fX1b5By
	k9occ2UFXVoZ+FKifb/xIvyY7cbChjSxHa1wd7aMx7CVc5rW4Sig==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48xt4ur0bc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 17:35:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 583FrOa6040751;
	Wed, 3 Sep 2025 17:35:06 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrabtu4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 17:35:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CJA9qoUoU0UZZALxt+NPjyw1W9ZDYhkySof3ularaYJm12hgsNXrw50Jxl1VpKDCVvKdREXTfZUAjW5knwyKxs+LE+PY6yxWtLIEubWIBAci4sy4FK7FDdHRwzAwAR3BdtS/enEPRZGOYl489vQAlmXsnraxKLUh76Z9Zzmhu3d0lk3/jz56gp1LdBMipYi5PyBBJ9DgIueURjrOpEYOOyyeFz9t0fVGSR1Pq8sUcRyl3unkxaawT3nbMh518DiEXahM1J1wNxKggSZw+Nzysv8FcU7PNTfp3hzwPYJ/RN92fqWegRK6ystK5JC079kYreY+LVCCHZP48kPf5cCVYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jARuuAweg/sH/cS0/3XM9OOtRiYYM92UUVnccFCaUJA=;
 b=mtvTidb/nLc0NsV9WtWq6svC6nZBjXe/8CWXlDevR9KkZoh+wNYV7nWwCUBSdWz2G7g1Ib2cSK2aG2jLslfMY0zZnNMZAx/17tDfDzx8T5ZM1I/U+QPEeHHz+qHYR+Z2Yz2pSHdA3+IS/W0kkXUG1D+dx4QHXH26CEbCv5dJYQQtFK1J3//gcpj2/5Q9baUs+J16mm7EM66u4wVbV49ShXHvFfGaddP5k7AW4bLGIGdcBZE2wypsl2XCDyvSOaCA5/YNxBZz1VzRS4GNHzRvnWgTmDrgZsjy9ECcgJr7cNbln1VLdHwzjN//qYCV12ZMiTNAN77RHhIHad6c9shxOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jARuuAweg/sH/cS0/3XM9OOtRiYYM92UUVnccFCaUJA=;
 b=md15tJg7TKwzSBO3nDMbcsA+mh8veMV72dY33Cx5Lf49G0yWsOZNMhYMlfGUlY7r3obGFYqP2GySqiO2DzkZuhDgBrR/CYqNWzKg6yUSA9TLHsGHmi5fD4IBxSfIOAhbz+qI+hDi0PgF5gK1FCJBHKFzt1oslxyXatHqi0LTJkw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB4863.namprd10.prod.outlook.com (2603:10b6:5:297::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Wed, 3 Sep
 2025 17:35:04 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Wed, 3 Sep 2025
 17:35:04 +0000
Date: Wed, 3 Sep 2025 18:35:01 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, oe-kbuild-all@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: do not assume file == vma->vm_file in
 compat_vma_mmap_prepare()
Message-ID: <0539e252-0563-42c4-8044-085504a89c69@lucifer.local>
References: <20250902104533.222730-1-lorenzo.stoakes@oracle.com>
 <202509031346.N6FpuQIA-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202509031346.N6FpuQIA-lkp@intel.com>
X-ClientProxiedBy: LO2P265CA0128.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: e7eb61dc-9a5a-46e9-138f-08ddeb103793
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J0aVlh+0gYKfTaib9K/bckEO8zMSOpwtlnIT8DJB8m3OxGbq97HOtk4RGy8I?=
 =?us-ascii?Q?k4Xq2S+kWYkz6+bHImTath4w7ChrKo9sQl6cVZa7m3lOpWV73c3aZBpzHhNT?=
 =?us-ascii?Q?y/qYc95/JlLTTZUgo4fqYxkcMcnHDH4ddRv3pjTRfUeKOKVeUiecY6AN92SU?=
 =?us-ascii?Q?fdvFB68jhXtq/b22VCdRjDV97siUDHKT4rd0Bq0PCLCVlQRVUhYTjBIKcg+9?=
 =?us-ascii?Q?HjIu2nkiAwaFk0nkIt47X9YjY11uPzMEqll7BwkrE1uxwOgj9l62XMEto/SR?=
 =?us-ascii?Q?sUMOr0k2lYbsuM19tnxjEwKJxJxglFPBW6wF5Lb8NphO1GjUY0V1UHj9r+xI?=
 =?us-ascii?Q?7UXU75GqceL09hiTNezuDZ6c5zrgl2xyKEqQG+ilUStc2OtPyUYqDKRbEMMK?=
 =?us-ascii?Q?y1SbYBq/2+lkj5zoJHNZlPg26dSVLDA+/2dB41arJUjc4t/Tb7pRE1g4Rq/p?=
 =?us-ascii?Q?kHIOCa9NyDCK9PkgokAUNvsEuAiBOYOQ2e1NMwjb9QWxTBNg/GUKb2NzrPHE?=
 =?us-ascii?Q?vzHqdAITxFQsiIGqIhzVsDqUTC7a78rL/VGSIv03uD+OhOxXbvZUak0UVXsw?=
 =?us-ascii?Q?7kj774sPrVoe+Vt8Y48K6jBCIOrZ40nZn39RitxosiEvxqps7wAwW7sxHSZS?=
 =?us-ascii?Q?WOCPkcjms1MWsQEZernT+7+ZYYHztgKa8OEZZQJKRjtfqWdbsDF/INsiWBFk?=
 =?us-ascii?Q?8cGikrU4Yg1YzpZgLTgV9x8oICkxVNCMBEWyk5dEGG4GkaEg4leh2phvL9Ty?=
 =?us-ascii?Q?p4CV+8+qFKFb3D6HD32xGhKXivrDeDrhixT4JtO/Oc0D6lcrGCk8qq7ZPX3T?=
 =?us-ascii?Q?qGDhYUk1VOCtwFWJAPDEiIzwCvI/MbWHtF/VuiDYPHGRloSpfnJJUq0WL2Sr?=
 =?us-ascii?Q?OdcriJDwCpn6ZlDxGG7kOVpLd6OeJ2iU7MOTWtPJE79aEGDlvO4iK2EtgHgP?=
 =?us-ascii?Q?BPaqOI/Emhco5/15ePRgVHRqWfW/JbSYzDrY5DngYw9d1e7Vm13ui4o5RyRz?=
 =?us-ascii?Q?OYrpQbBAUdHz/YGy320KdcIReYxDyZWtB8daPl7Kml2KuvCJxPylFgZ1QXCh?=
 =?us-ascii?Q?JN1d2Gm0nYHTk+bq5rO79DFxwDMfbcz9Km7NztJ+lgKgnE1PjW455YkzFaQh?=
 =?us-ascii?Q?tfSxYy6TgjvllUMdYNY+DeFDFdhQSuSTIkOCvQDGDvqLPVecsw+DkJgTkI87?=
 =?us-ascii?Q?d4wXbU/arVTmly9Ngo/w1OVA5iOUVQ1JnS+3jHkltiICYhm8/oY+ZLLHcr0S?=
 =?us-ascii?Q?iQ/3Y0oXL+miL/EZy03WRLtibaWSfagXgcgwnQJ/1x3YILBBr9kB/vGRglqK?=
 =?us-ascii?Q?2ComcJVAqIYqGDZ4TWPpWhHK8CGN2CVb9TFPUlzxcia8ZTInwcmVBydhLsSF?=
 =?us-ascii?Q?oy6dHO7RMF5N9643foug+sRrqpFV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NSkk6+zQnwrWPAuadjXxMcfVstsaJKB57piuZaswam9ICGQ4K5rOg22YDEwm?=
 =?us-ascii?Q?vbM4dBJ1O2qFq7b9LrCMZtZaCaq3D7I9T5pFWWF/NmKm7b8iQw/qJFAv0QLl?=
 =?us-ascii?Q?TGTii0IyMDEq+GUZopbQEBedsBUWL3X8VR8jnQNI2M/J8j6S8clh/ZrpscI+?=
 =?us-ascii?Q?cArbLv7LX6pI7FOTQmjVqotTxkCE+atmKbw9j/gCHWAXmM5XA/7+d8CZHPUt?=
 =?us-ascii?Q?e/vlKFTaUnMlRdXAxzXw/aepB9xKcJ3sDMfAhKQ2VF10TWE3INOrrd0339U9?=
 =?us-ascii?Q?hgNTb9JxxV4184BFVumGWvWn+V0qb22hraQTqpSAQx/ejHjpFdCJYCSZ+Yb2?=
 =?us-ascii?Q?KUcRcD2hxLWv/6Ti5eCWOxPW7OBeU37NNoP0TX5Y3J/tAfAnyXYqtiAzh2OP?=
 =?us-ascii?Q?FSGG/kMChIGQb9LzStTetgk1/98AUmisUxVtmdgTtFDdL9d28rcoFHA+ATYe?=
 =?us-ascii?Q?wQK/zMbmHTwbtIOxtfesnQQoilieuXTDiK6P5JHD5KZ8cqxYlkeQNxVTYqrq?=
 =?us-ascii?Q?0rFPZ9xZ//Jp55CwkyQ/1geA5ZIGpjQjHdRTjCEAOBsDaG7glYZIWQi4B8c2?=
 =?us-ascii?Q?rJFEwkNC2LPXvbeLc/142sWs20Ij6b2O1GHohQ0dJ3cxPlPvC5MuxAibaGd9?=
 =?us-ascii?Q?4y6Istj5ZRKVWHaANe9a1cQcmbEvccdqKTwGEcNbE3cL4BkWq9p9479RxmTh?=
 =?us-ascii?Q?wv59twSbOpVEbgydg4f0GDkgmGGTmBiQw8VdQgI/vnT/6T7l+NYXx3Vnjr1i?=
 =?us-ascii?Q?09MmcYO3S8KmcdX+QRm2M1jbd+wuNGLk6Cjtav7m7SiSy9mb4vJGVs6O72nb?=
 =?us-ascii?Q?j9Of5lJxn+8TSA64E+MTrMqrjC3T0Atk9NZZJx2Wrx1RTdHzN+uDREMDbELJ?=
 =?us-ascii?Q?etJG1mRgOl8nD/DhrcabcL11bemBUUGuP4/CRH5moOFIIxJNkZ0VCa/MEf7g?=
 =?us-ascii?Q?6rvCIYbmDF/+2qLbauC3rBTtMg7I+V0rKEYGEal+bQbnk+s0ejCBo9SLFb5A?=
 =?us-ascii?Q?KoCI0+Li01KISscM82/AtL9LzaF3DjxKXzrKCSBd0OKcJdNcUtp3ypsoB9l1?=
 =?us-ascii?Q?2YOnDTYNJIDNxMwttQVLfMETJUIDyNwhHxnHYV0vEvlLiCVLgpoqUI6O1kh8?=
 =?us-ascii?Q?fUcurB8iaBZZH/sZC0gbZ2UgTehYQuwzlsNi0fo7fjj986xz3t0/gLB+cFjm?=
 =?us-ascii?Q?6Qjytz2o81Om8MLW4tew5VSuBo2WFSY1zgwwtYDaO/cB0qewnJWJWRhgr1Yd?=
 =?us-ascii?Q?i3q643R9ARcVbKgoaETP+L5T5IwFb34JoPIhz5YvRirFpcgiiFocO4a9H8G+?=
 =?us-ascii?Q?krMr7vObC795ME5nAoTeQ2jp6c0CvcJsgK1S0Up3t0VO0lMa21Xdj/B6Whpb?=
 =?us-ascii?Q?1Nk30bVMtSyal7b1ZxMbykGDbVj+lzJxJg+/KBGwKQJZgMBsdWAI2aTdHI2A?=
 =?us-ascii?Q?1nUWCq8WTacXreK07pyGtXpbJU6K2nM3hSxJfzW3ihRGYNUIBVuUUSVSMrzD?=
 =?us-ascii?Q?x7oUycsD+fqhljMQYyBfPe+QgD2iT6MyuFpbbqvPackW4LcXFZGBsuxsad6K?=
 =?us-ascii?Q?PmXq9sd9/T5ZryfDQQpQ9VAbVkvRCfp8H8FdD0oP17oh+QCdsHy2GOkZzRNo?=
 =?us-ascii?Q?/A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RO8QOZcFemwTo4kKN8oSHs81UfOOeGpFdqM5kjzxdOQ/PYLZcBa6d1afr+XDW30XchPUi/UIz300uLV8AieS06oahdpzJVB4q9D395odxMuW96ZcnEhaLN6kS6IqcKWgECUMYQbu/wxqCNu8ELJvcaW9601F9idWEY5I/rC14KamnxfoIkWEw0nnvnll+mRAq73iQTIyO4M00MkQuK1nzO810YV+YnATA3O3jfoa2crpZOGPpHjZOcOjg79SH+xCQWQ0UN4W5L5Ge/IyyzfrsXT4/k09r1UZMB9WSKQTrm4xZhvPZCABonAyvdTriZczFa7NnGREe41LS1wR65e2qRE8nW4jRiK6knlBXA64bqBF1j53UL0DG8DrYQhe6y1F2GavR7veC9q8ecfte9uj2UON874xLHX8bomG4K6w1wsVsRlpsqNL1Kg7msnNVlfD3b2o6vyeNr8MYBFQ9DgQX1oBJA/C2r7T3u+GiOiwltKaKRs6MZILbgPwYbTpmLeHeaUPCKzPqocB/wLACrP5PfKyq3rrSeC5Z5RQHWf22VHfRbqa7xBN2lM0x8V1rEU4DbvE+M8TbbRwxlvoP16q0dmQguVfQq5/ZQOIr5Uf5YA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7eb61dc-9a5a-46e9-138f-08ddeb103793
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 17:35:04.1851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1gQyj/ncDk2LZQKxhNSVnj0+kBiPCcJ6Z5MlehShCApJqD/EGkCWGUtPP0TXdP7mWiRh64FdFrjItRU+rtkKSFoQt7wvRV0RGeDFg0iazow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4863
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-03_09,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509030176
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTAzMDE3NSBTYWx0ZWRfX6Pq4xzRRujcD
 qpoSOBj+Ui5eUsi4l1fVG346Racxq6iPfpoBLKAEB0tmsFC7nBzEAa6/1CZMWO+9JjbypLLxfMw
 /iMuimRZSdk7HfuK46D5m7/4zJ8kheqRViqAYcK+3Mj6AOmK5TjOZ3SqooXUPoIOTr6am4nWOK6
 6J902ueYh7QRJzLvO9tHZgljC1Eu+oG8YqUN1tYa4XJ1X++IXxHfyZZgcc4UmllZGCAvmYpLQI0
 1rlvDtQTbWPGEGKON+kGscDix+P2UWiK1+Soio4q8HrFudqzPBs763Aw/yTuXanbZmV+6u/ebXo
 ht9CfvS+6mEYNTWTyecFEflKNxfdijkQJXde99ApPDX0mod638KEKoqnZ1JnlpTH4qYdZyogM4J
 QmxPmXew
X-Proofpoint-GUID: Saf42e6EQq39EKrJRGqcQmnpi3XzFaBh
X-Authority-Analysis: v=2.4 cv=H+Dbw/Yi c=1 sm=1 tr=0 ts=68b87c4b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=M65uBQoZPnXqXZfGRzEA:9
 a=CjuIK1q_8ugA:10 a=mmqRlSCDY2ywfjPLJ4af:22
X-Proofpoint-ORIG-GUID: Saf42e6EQq39EKrJRGqcQmnpi3XzFaBh
X-Rspamd-Queue-Id: 0D99B40005
X-Stat-Signature: 7u5ccc7q8cty4xqge8gugig53tema5yh
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756920912-209837
X-HE-Meta: U2FsdGVkX1/qCCjxGmsvU0WkBoGZbdMBlXBJHIJbaVfjGNyENgdjdHKWInDZOd/v7O8YjlBQ5ifTKPAkaXh5MqnZr6y70Xz2QkM3sfFMh9RgW6Xmsab4jnBMVt0wEhLR11KILjgXElXLyBsnRjz1aduXg1N7qvhC5TAYSo2KhSFYYu6OK3hjBkd/AUdlRT/oYB/d+yQnj5ShjP3SVpKJnBuH7geA+dyKMeaqwP5mDVNro26EATvaQ7CnfKweKDjtNEDiEcPELBv5JDouFihBbOPgALgVc+gLd4rvkQ3d7N0UNHupz+pwuSwoVeuCOdWUmrudQGmRNcCKjOngeuLvjtwBlLlaosFJEwMgDcnD+UM3FT3h5g9JqcXUa3ZZJxzTy94pEv6BK1tNb+TPOOq8c69f8J9G09toIu6EmKzdY5s2pLchHy2QE0Nw+O9mISGWn/v3zQrq+9e0HXaHTyN9fv9a6ff+Do83oxtPdjCIAiG/jH5lDWTQsSxYkTU74tjLGj6Bwgh1AzS4cQ96cGXwIsj2dDdlYGIcRGId/Bk1HtxeEcQ2z9lAO7RV09zAwrQuc7BCzPznPbAts9IHIRvGjEV4vBf83k7gQc3EJvDHQUg9/QZ2hYLdB3Eo5vJf5Hjjdua/mzhy65YFrLq+XL+/b5gHV43ENAHApWuXUaBiH9Lmld0d9aTzXLgc79IcS774CuSodCVpnmZOqiolmEeo611vjU8/QskgwwxdJBx6XbOgBjm0++/yRxm19cIief8RtopnL2tNJmntyD7JOTfDHsRMY7NQTkBu8u/iyu8BbGML2NZ9mHbJvmRoSEw8RyMhU1K/613zVT5cc0sAgS+ImyA2RPSPvS+uckyEeSZXszcbt7LaIryxGg8US85GqVFBk6pQO/g0nUYxJoL+ndxUng+R487bmbWSTPOSwV+qde5GbNSJMV0YXUmtkBA5BC3R7XTMakHqh/5DhXUx/L7
 uBvQsCTQ
 bPt/LN8nL7PSX1IjDmenuZ76Sp15aPI9MIQo2dqV23YLNXxIPFij64vj3Fr5ybE00Lag8RfgeQtFzgsvG77e1EOMOEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 01:25:47PM +0800, kernel test robot wrote:
> Hi Lorenzo,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on akpm-mm/mm-everything]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Stoakes/mm-do-not-assume-file-vma-vm_file-in-compat_vma_mmap_prepare/20250902-184946
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20250902104533.222730-1-lorenzo.stoakes%40oracle.com
> patch subject: [PATCH] mm: do not assume file == vma->vm_file in compat_vma_mmap_prepare()
> config: i386-buildonly-randconfig-001-20250903 (https://download.01.org/0day-ci/archive/20250903/202509031346.N6FpuQIA-lkp@intel.com/config)
> compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250903/202509031346.N6FpuQIA-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202509031346.N6FpuQIA-lkp@intel.com/
>
> All warnings (new ones prefixed by >>):
>
> >> Warning: mm/util.c:1145 function parameter 'f_op' not described in '__compat_vma_mmap_prepare'

This is because I used '-' and not ':' :)

> >> Warning: mm/util.c:1145 function parameter 'file' not described in '__compat_vma_mmap_prepare'

And this I just missed adding.

Both are fixed in respin I am about to send.

>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

Cheers, Lorenzo

