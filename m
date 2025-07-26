Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD24CC87FCA
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 19:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD4A76B0088; Sat, 26 Jul 2025 15:16:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAC916B0089; Sat, 26 Jul 2025 15:16:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73ED6B008A; Sat, 26 Jul 2025 15:16:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B3A666B0088
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 15:16:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 172661A068F
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 19:16:39 +0000 (UTC)
X-FDA: 83707372518.04.97376B7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id B1112160010
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 19:16:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZZc8Zcrc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=M0LcZ3YT;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753557395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ds9vTFnhoH/yzNRaCkkYLkCYNr30QO+T8aBdRllLu4k=;
	b=pzGFsgNSwhfPzwnO5OpwynGoYvMWUxJkz9+HYcITAPlK5dyKx0LTHL4Ik0EXwy/LPO93CD
	B8gqZs57+wzq1upaB4V2Zm/Fpi7u4SflRRZJamBSmhI3K+ioJp7S4TE6Ne+kLPaFvtnzCA
	5+2Ke0zlsNiZJ1lqI581NtHD2QsIhjA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753557395; a=rsa-sha256;
	cv=pass;
	b=kHO6/5gb/aharx+qJd44BIbX3msY+l+mGeNXKHSOJ59hYekasfC+sfPrQcXG2pU4ID+dDn
	YP9QQxaa6ndJydBaQS7bITGuUIjcG9aW7NI33/5pAE3mZW39DNabgbkrNvFYPooOGzawq9
	Yrxcw2wOOYQm6Oc2cpjcqjS/bFDWH9s=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZZc8Zcrc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=M0LcZ3YT;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56QH4MtL012918;
	Sat, 26 Jul 2025 19:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Ds9vTFnhoH/yzNRaCk
	kYLkCYNr30QO+T8aBdRllLu4k=; b=ZZc8ZcrcOBH1ulG7EIo6jnMCmEElmn/gHs
	nOsM4337lkdnNh7zMy0VjR2MlT4oJS0iGmd8OAK1QeZynv427PHbErAbt7DBHNkk
	wxQ9ILnIPeluipEz170Ioz7GQS3IaCyhuj8iiucnpDrdITx05Ty5NCng6VXW6T6R
	0UYfEqGSgfwwp/XX+TfoRM+cls6PV3323IzOSo0+a7wG2w1c9E8nxzEZCudkA8Su
	QjmrwIWraC5BjwOpFZHeNyb/FPC8W7WUnI5uo+tkkiZYpw7LdyTpKgBCPQfQD4U7
	+lW/BC4cm1oKk2j3TZhNx2hJU8J9NJLMG962IhucPxtJtBkABW8A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q2drvf8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 26 Jul 2025 19:16:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56QHHd6I016816;
	Sat, 26 Jul 2025 19:16:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2082.outbound.protection.outlook.com [40.107.237.82])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfdeqvn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 26 Jul 2025 19:16:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vhd6gY7/ED+TTk+ctm2lpXcAVdXDdXMmikYxP6RuDJHtd9/wZ51MJvKQx8zCEeQQQgcRo4I3XgLfurO2+LnX9YK03JiiZcmirjIdPEw0iO7Tn3HALF0Ks5An3nK5ndZRdmftQ8z9/gXXwOlSFqLd6bUK7R3qypEErfxKegkoTpOeOvK+SdFokAhGkCWJOGrR9qjhCJJtWeOQCyRJ6QV3994e9bara+IODq9zfu/j7PRcd8PDLBh5G2wGfoVSShwOnTGgR2CgsttLjoWfplSNoWDoxFvblEpvkA21rtsX46A2dOBLHzZRJ8COgfZOiZ82H5+2crnTo5gryFKjvXskRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ds9vTFnhoH/yzNRaCkkYLkCYNr30QO+T8aBdRllLu4k=;
 b=lwScKTv9vva+h5vr4s6dcD1PJnlfqRybdquCKiKr4Iwtsy/QWkn1eq3z3C91YsK+F4ZiON/BuFf7hidNUfGd1r7JSwcLW4N2Ub9Z9MxN7DvQ8gRNZKu7I+efWM9Hoq3cqMoJVEWHyVYiWm7dVPjHx+POyRe2fhYip1fw8ar64IZSXZAUR0vYCTRZ/bmb7a5q6xLqg2KRu+u/IysTOOCDGO1THXylX1fSz2DAFM8TRWzv6KdnL6b8jdMqhAjHiKKvddREQRChNsbhHepa0c7xwzrMK7qJsvsXNqzyjPBwKhxaTqpxg9OK1s/S9zzO4u7X55PxXhOA1Z21F5YN3AcFtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ds9vTFnhoH/yzNRaCkkYLkCYNr30QO+T8aBdRllLu4k=;
 b=M0LcZ3YTlgeY9Ka2nX1Uad8HSleTqrQboJ3FBQFBF01SQESa9nbmw9F8O6NbGt8TJRhcnL3GmpLDxmmIBq0VxKKidxmRBLdxDJtm7dxVfEDJN5KIv+VumqIQsNXzAiFMkp6oWzbcAVF7sTzx86ZhW3LCIPW5H3qRM79jBmvXypo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH2PR10MB4133.namprd10.prod.outlook.com (2603:10b6:610:a6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Sat, 26 Jul
 2025 19:16:21 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.024; Sat, 26 Jul 2025
 19:16:21 +0000
Date: Sat, 26 Jul 2025 20:16:19 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        Christoph Hellwig <hch@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: remove io-mapping
Message-ID: <ef4bb599-8b4a-429f-81c6-261ff64a6e76@lucifer.local>
References: <20250724145313.65920-1-lorenzo.stoakes@oracle.com>
 <202507261811.4FJjX1bu-lkp@intel.com>
 <20250726103952.674ee38b16202dff3d54e8aa@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250726103952.674ee38b16202dff3d54e8aa@linux-foundation.org>
X-ClientProxiedBy: LO4P123CA0689.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH2PR10MB4133:EE_
X-MS-Office365-Filtering-Correlation-Id: bcb0a847-41fd-4e69-c48f-08ddcc78e7ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YLl5W7RK/KHPYoCx454A1VAsutCD2ct9DHco94BcZGPbBg3+R/gKZPnIT5h5?=
 =?us-ascii?Q?YaN7fMqU0E+H7Yy0JID0MBrS8y3Ytka59jmzH0APXjgd1PYSfisZBSOI+z0r?=
 =?us-ascii?Q?k63FjNGyjv6iC4ZJ0tJGDqxyHeTQHRQztIvjDqHLD4lK8H6HjOoNsaecshMD?=
 =?us-ascii?Q?YD6ETTk8I+Xpgej/Lae2bye1lhkSw3rOKgbt6QFJNFKFt4Lq3EHiorze+r0b?=
 =?us-ascii?Q?i6y4qJQbGRxJ+wJ9jQtGoumVg49ffWMGKwGDPPP6iY2DgkMh03yoX3p5sOzt?=
 =?us-ascii?Q?O1xqMtDg2+sPMCw8t9I0GLD+2623dyP0r9hX29pvzKtnrUWRRqmftiPcvBPf?=
 =?us-ascii?Q?sR3BcMCFPe1SOUruG/9neeqauZxeRZfZFNYg0wFTw80GkHJzDASE4Ox0X7jn?=
 =?us-ascii?Q?8O9DGP8kvmbem98Z+VNTEQGPdEemKiYG49nV7xP54hijBkjsUwk8S6+o6s1b?=
 =?us-ascii?Q?F1HF50r1Ocdi4FpHWnMeRArJFNx4xVmc719yY0LgezHY51mNRdosBywI62VC?=
 =?us-ascii?Q?uesDg64/Wc4BoVjX7DlMvyC8fEy5p4sGAa930Rs+8XXTWx+SmwSYcjL7BdHy?=
 =?us-ascii?Q?rSFu5zBpe7BO8bQ5fA1s3kYhqJTan+6aCj6C6hXXw3B30tsUeis8wYOI4FsQ?=
 =?us-ascii?Q?DLv6tTon9JFNb4WKFwaJobaHMGwRaJ9TWNVsMRQoY7e4DrLNNl5HbPxVyn35?=
 =?us-ascii?Q?O/N7XM50RFRWPb1AshiAbtJEm76WKUQPe/NiKtbZ9MtsuhvSXgHW9Od/XVKV?=
 =?us-ascii?Q?Bm9Mh65kxCXUYDMdpm3PrC1y2C9ffK2ptL8HxFjUXQz0ChNnFdmClB3VOmvv?=
 =?us-ascii?Q?HviK1ZHkmxtZS/q/Dbupbd8d3hn/oLjpFZr6syMd25ukTTnM4IPaqLqIetF/?=
 =?us-ascii?Q?4hGM8RwgMiouMOYeGV0JLFBHqzc/Aj66Hlv4X1RwK+iKiGFIoCtJTa8prNz1?=
 =?us-ascii?Q?IhUBu/+Vv9DIBeuRhnWznNTopLKE8LtJILS/T/kNHM062o0pkORsgbxtpd5b?=
 =?us-ascii?Q?BljEyBsAfN8KdbFvdpVBuvHTSM/uPR7XhwPqzJ7qkUnZlh4Qa1MrIHNilsUw?=
 =?us-ascii?Q?o/vdl2uXL13JXi7XrD63lWBR37j4DUGuHOSLuOEGkUv5Me0e5EGz/3Q4Oaec?=
 =?us-ascii?Q?T5y4yofFdfOy3Fra0pCFd1FwcSwOtlPut6EPnhlZOIgMiXT3YW+IndGmEgRn?=
 =?us-ascii?Q?PXblLEXQcfgs/P5/eaiM+nSDVlWRnc8gANhQqtaig4TIaeRD+MzNvUetRVP0?=
 =?us-ascii?Q?vBBQBXeVHAYZt88JC7b1ZSKJBNIVEZ/50DTLn8izLuICUHdfoqIfqD5KKw6H?=
 =?us-ascii?Q?dszj+McnlE+K6jp84CDwMUbTet2+VBU3EGqZF3knw+nUEdhVsMXQifV6/0U9?=
 =?us-ascii?Q?gGvh9me/u8n0BEOMZHyEdJXTydQY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g1xRPJzyhDaORjv9yFTPVYxnLYJKtdXjSEXKo8CVfOdHtG1LO6fHVIaQDrHO?=
 =?us-ascii?Q?+P0PhAW+84KYH8IVqzsot8XwMAtQ/w+ANrMB2Z6wUL8th4EJWd3QQ19IeFYD?=
 =?us-ascii?Q?7uf2yVXW+E8d2t03HLn3ozNhd6RT99DsfpadaJNpCkTPaA9lUQAgw4EgFuwK?=
 =?us-ascii?Q?735c1w333IJtL1lGY4nRSFzoFB6MQ0jjxcG3iPERBfIfFDYOG3mr0cP+txmY?=
 =?us-ascii?Q?krzFLWON/7X3mCKkZEfxoby9xf7c2YAWFVwIUaCCJf8yejlMai5WcSzf17jf?=
 =?us-ascii?Q?lPTcfC+W/vV6PDDns0oFZJVY/cgRPb1yXQtYDU5PI9p0w5OIsCiEqJdZ1OiC?=
 =?us-ascii?Q?886VmvGrGRhHn2VHkpubsO3WQk7LcL8SAQm6zlHrJycGpZctGJqKw9A7fvhy?=
 =?us-ascii?Q?bnzKIWDKDNlhOo+2fLMQ7IrBckTEj13il5eDuIKd6zTBQzECShR205aN6+JQ?=
 =?us-ascii?Q?JGjLINbiFwff1cglXYUo5apFKXL/ajQJV0MYa/iC7+Ni+x3YCzle2KK1BK3I?=
 =?us-ascii?Q?5RBwWJhv8/ExgVLm0VtMVptbJX2/sbtGTXox3uQxi3d/dbvU2lSte2ESHMy/?=
 =?us-ascii?Q?W1rkaxZMpjZK2UioWEAlu8fSZ6xskwrOi34T5LcFCcCUu1ILpNQaN4x2MD5m?=
 =?us-ascii?Q?3UXU6HoFgN9yWhrEIflnOa9iR6zbx948FkbRsvB428LgVFbB3T/4oYhw9TMG?=
 =?us-ascii?Q?mvlWfcujamuX08Cs0O46nSi5qoRznPVzRUPF9jPNCGQZbLz8Pxb1XONcJtHd?=
 =?us-ascii?Q?XVxjyDVdcY3BZTm7y/fiWiTDQGoQmTJ83NwhygF4mOcnt8PwpJFmVUSK27is?=
 =?us-ascii?Q?3a6P3axX6289NuAYWpxIdzLK0IxlfzDDQeDfm1Unk/UF2WTd3Ir2t9hodVw6?=
 =?us-ascii?Q?uSt7bpP6zAds9u0YV2l5IF4sL/dfOOexnWZqfvZR1c6ADSV1FMg38PLJRudB?=
 =?us-ascii?Q?IvgZR2FPMmJYZtS9kHW9pmXzjQf2L7rsRu7nRomq8BzNqIl25wI12Kmn5Xom?=
 =?us-ascii?Q?MOvvjRD7ebHg5DETdkNCkQIFPNfpZzj3JqhJU7r3+djhPbizXGu6DNilZq7C?=
 =?us-ascii?Q?leds4fmZVr0S2XhkBzwWJvCPCpvTJ4rqFLBlWdeM2ie6he8Gn13R/wJy63sR?=
 =?us-ascii?Q?/hz0LaHKiwT4zjQD9yh6AVcTJXXl0aGep+9AdutxL7+ZA+Fjo53IPb6tXsQ0?=
 =?us-ascii?Q?PEGGusUwu9IISrlR6+T3gJK6n9buLFtO44/Y1kgVgeZ8w0Kn4x7bA/5xIwxD?=
 =?us-ascii?Q?ftkv5+N1TA5pZL4abnDC32II/cjv+rRL97iaV0C+klIB/lbMZctf5tDwCoQS?=
 =?us-ascii?Q?mEV1r0NAZ8jNjFF8vk6/7tvZqocb0WUZ8OXHCzvg3aDZcSaOuWznpLrHw7Ro?=
 =?us-ascii?Q?GFo2aUkVudZ0t7BVVGx1QpUdZYzXSEV90lkSi+KIhNR0FyrbDtC67lIuM6BT?=
 =?us-ascii?Q?OwwHWS5/yFgTYHm50+Ypyjojt4jrYHqtnDSS8qAhFuZ32h+E3qxaxQPXMxhz?=
 =?us-ascii?Q?6/UBLVrluJPzcabEo+bK4vLtYyX++utzOwxUnA+VxWZ3ZRWJJDHrqYdUcjI8?=
 =?us-ascii?Q?uREMi1fW2RkLisUWwvXNpJD9q6shirL+QRYpyf3QmFQvbA/rjaEH2q9ci49N?=
 =?us-ascii?Q?8w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WTpiYWG1AUspO0ZX0bg66oKxSm+tqxE6+NDWEBByBuNpjO51hy3qcL70CkQIbAv9AmzKpvt87OUaj25tislacX6WZ0/wzJfE2z4JynmPrsqmQ7W8wsXREtWxYajEFYX+Jo4ifUKdSK0RjsHx/KZrs0ppt5EmbjCTm+EwDt4SFCyQJkFF8zRkbQgKHV4/lF4ddbC8uz5n3nbbiaKa5zYPd0OlOx/kRXmUtLQRrFdVttHLV6LwvyiWKz0XUXi0loDfYwpgf7XLdkMGj2qI7posT00n460TgxVz/F0UxuFa2Y6NTqTKsEpL/95LyWQDZEmlJQJLnZa17UQ07SODxHfVaHyJkynYnX1GuKwOMQkyR8zeu0ZvyqJa1krR1drYxb4rXIT4vo0DBXcRbv4C3IbpOigIoj2BL0R1JpGbrpte4cpmX/SFVSTOi6HYS1jSVZO8eLE9LKCJwVge1T5InFmYQDyBvY2b8sgSRfoGnUl/KTfkiamK/gPs9vqTaGpZCnYjx0rHOtIW4A5AJ0MQH769lojtelBVk9EA8w9l7xycamFhcOVxXQzrx193GL8s9YOEVMKKLT+M/TKAh/DCFMKF3xwOfBU1rFclw1iK1V3wcMo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcb0a847-41fd-4e69-c48f-08ddcc78e7ec
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2025 19:16:21.6439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rewAbflGwcPRc6iOQrV5/k8sH1Dxo3E+nkoyLiB4VO1LoZ3MFZckPlD2uGAn5qKqAfuqHjJouWe2CcnPLorodhG4R1YrHia6mq5HwvlRJEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4133
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-26_05,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507260170
X-Proofpoint-GUID: XzS_eQDFuM7g0LXPi_7MIqg5RMsO_aKg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI2MDE3MCBTYWx0ZWRfX/DhPeAHWa9KW
 cjcDemyz3H/iq5/UKMGkQ8z3Hfk3EvTtnwLUEFzUeaL5kLmr+X6KEXolAgUJzlW2pxPneCqdXyS
 yqOpnSTAjY3I3W1QefQUsMJA0Uxw6tOe8BF5NLCPNqyRvUUQSZ4ETOjmks/KMyXpFz49UOaWhbl
 lBIk7KT3ayF5H6RtenwFYidQphoHgjK/uTTz15dG+d4FzlDwb210R0ob8ME8QoTzga6jhXiUDaK
 YYU4psezO6PbwNv/MOIvDXpCrA42aIkpMilUol0kyEtY2Q09z5Z4/c9hbD2r9SzSqz+PpHp9Bdf
 lTBVJ6Y0h9xNLFvWO8eK/JCGnLi3QqYvEaIlaeTLVRl2w+bVkx3ZO1zAG+IXWE3CVvbZjlsHec5
 ce9raVY4wmnChoDpd+no9WYVdTCrNbJbdSCC2idEe0Ckhcu1hcFLbxikCwbwvvWANw2XZz6B
X-Proofpoint-ORIG-GUID: XzS_eQDFuM7g0LXPi_7MIqg5RMsO_aKg
X-Authority-Analysis: v=2.4 cv=A+5sP7WG c=1 sm=1 tr=0 ts=68852988 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=i3X5FwGiAAAA:8
 a=QyXUC8HyAAAA:8 a=L3ttbaDb0aW9jVM9yKIA:9 a=CjuIK1q_8ugA:10
 a=mmqRlSCDY2ywfjPLJ4af:22 cc=ntf awl=host:12061
X-Rspamd-Queue-Id: B1112160010
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: andxjxi8kiptf7fpn9i1uo9zf5izo1az
X-HE-Tag: 1753557395-56203
X-HE-Meta: U2FsdGVkX184oD5/50woUpPRXJ9LiSb9AMCHSQZnEhUBJ9TIrvvEbv4zvCUHuqivkNz4hnoZPzktRtr5UanuseOAQI7HksHGlA0XqibKnoxREo5UJEm4Wz3lY52++qEKv5aV16FAFN6tbgtQU1NN05TCSAJoLcUYSrMADiSKTnwoRtTwhzqpihLG91C6W5x4Amw38c5cptKDLkIf+gXkLMm0f84M2ZWyLX37ob074YLHFfjwQjKG0fb8VtrCHloDnjbthk5yfcVy3X2ReUzIlc1i3uFNxDtFjkfeeW9Ssszvu1WLxvNdRpmaAF1OZwaONUo1+uyZiD54TeSEfvBQPuHxPjR6X1rd3P8HGKd/bWLoST42iIdbCYOmi6LNkpwoFtOpljr2FeBHE0u1uAW38967YA06DsCMd1+oVlnhu/IvJgKlxYiG7BL7xOFcXsTpNAReHJgaEoLinkqYvW2ffOBf6EbfmNPTUbPRbxDhnXXi45vi4VZEUzE3MZzW1EKjNv23NqG6hXtiSWTXt2BeLQ1CTBGouHt+8/5siKkjTu59wBL1PXc/lYgiS1XGeEDfBjUIbnSl1/m4dC6si/SXdYJ9SGmbp5PrUpBFecM0Iytqkoi7im4UvAcq3x9SwPtSVlULChqVpoAbFbJdJ+KQcMJEa7fBoBAw5l0DHK+Av9pE5WqSJh10SN+Ttu7Z46DqtNw5TqGWPJzTsuSgTBcAxt8BcDzCg5zSNQ2Hz6fy0/BE5y0nfSsBd7By/FpI8QJDnnACqXmg0DH/gllSN7PCbeUJnmSvJo4MRRnraicaMFBPGX52MCDq1KGC0DrIdeW4EZTtcyC7wy0hCAVwhx3GQE5Y9PdpUvbeulL7LFtqHZyQ7g1g0rcdKLzY64pPmWbMrbRG8+4cekQhbMqg7N2i+E87KhnLdLszqq5GnU/3rHmUsE8ZQIgSIJHVzV5Mx1gtPjtwD8tWOPZlNebTwjX
 C7y6Z1t0
 NCJ8S4jQBk52i9bQu3FLEUSUa5rGcuumDy9ZmsImkEq1UDimprLyEcetqYRECBBnJFDceixkRJb+j8H5udEbpJXDhNs2D11ceB2CVL4quZuEbrCZz8rzHBpyMyZ65aT3zy4s0OW6Kn5FALD0j/b0zWhOudYBMQx9DNvAiyST6n8AVV6CNsH+KCDx2cfgjbcgyT52HKiwEGt+cgwzLb2sMZnwOfJKOKbv2hjSq9o5GzgAzKgknuI2OUkz31mynVkwy9OUlk3XCcih+3Kj3o938iQe5fNpLwtFrwVwIjJYtHvKHSRF5xSHA5VS5qmm1YGKP+riYumvQYb+btZ87gqd1qgJlgPr/LJnY9lu1g3z0Mg9wk3xUOfPGy5L30mrtm402L7AbBj1pggxvgbbZXMKHGUmp1iMwvIm4pyXO9pnRPQeTZfi5OXij/807hOB2ox8Kx1vnCHMd/ccbCfYhSIAKWon7eWXXaY7dloB5Tze92SbUf+jazLkrJtkVs1GEvCJVHlkyUZGeVehrcRYyD75m/+ub32uo8O5tId6Oa7W/0jhMbg0hkG6G53D7QmTQySN2tvuwbHu43gyDpgywfTvw0LaNFkyt3Sv7iToqauY/bG+zUrRCpOnACd/5L3a7ZT8XUJYKqiKrm03GKTBFvlXQHsYzL164PQ/f3Twl6hD9x9wgrXk09RjQzW6abjob2+0c0suPYhlOxOjBeypeJQjaUtR+D0iE/k9XoG5I83Wp6RLqhYICO4a+1hesoFWnuF7EkbATK2y2c1ew6jk0nkDckauQNwjpjGVWvdVueWnpG8e+4WKbhzAfpfJQcd6B7SKAf7zcf12VSUPevzc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 26, 2025 at 10:39:52AM -0700, Andrew Morton wrote:
> On Sat, 26 Jul 2025 18:15:44 +0800 kernel test robot <lkp@intel.com> wrote:
>
> > kernel test robot noticed the following build errors:
> >
> > [auto build test ERROR on akpm-mm/mm-everything]
> >
> > url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Stoakes/mm-remove-io-mapping/20250724-225556
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> > patch link:    https://lore.kernel.org/r/20250724145313.65920-1-lorenzo.stoakes%40oracle.com
> > patch subject: [PATCH] mm: remove io-mapping
> > config: x86_64-buildonly-randconfig-003-20250725 (https://download.01.org/0day-ci/archive/20250726/202507261811.4FJjX1bu-lkp@intel.com/config)
> > compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250726/202507261811.4FJjX1bu-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202507261811.4FJjX1bu-lkp@intel.com/
> >
> > All errors (new ones prefixed by >>):
> >
> > >> drivers/net/ethernet/mellanox/mlx4/main.c:43:10: fatal error: 'linux/io-mapping.h' file not found
> >       43 | #include <linux/io-mapping.h>
> >          |          ^~~~~~~~~~~~~~~~~~~~
>
> I'm all confused.  include/linux/io-mapping.h is present in every tree
> I can find.  This report doesn't identify the HEAD commit which was
> used?

It's testing against this original version of the series that incorrectly
removed the header (long week :>). The v2 of this series does the right
thing (just remove the one dead code function, file it's in and related
Makefile, Kconfig stuff).

Anyway yes this test report is totally redundant!

Cheers, Lorenzo

