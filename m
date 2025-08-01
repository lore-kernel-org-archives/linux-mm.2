Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9BFC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 09:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5349E6B007B; Fri,  1 Aug 2025 05:34:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E5CC6B0088; Fri,  1 Aug 2025 05:34:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D4EE6B008A; Fri,  1 Aug 2025 05:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 309756B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 05:34:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AED601A13C4
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:34:06 +0000 (UTC)
X-FDA: 83727677292.24.5BA1572
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0756040019
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:34:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oUNvMf38;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nR3O8pYx;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754040843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V69OVblX878Nkah3zE59Z9VE7TBZ0/v7LxcNTshKXOI=;
	b=PfgQqeR56w0xnR/hidgnmQaWS5hwcMfxXyF04QM+bFFtFRO08IXbPn8877Lt1Blpf9+5EN
	otysnUe8XjtA2jGHrIxYLP/4aKct2NoSWSSd1HKoOYRmxPYpRyEK9rRx7l2sAPvD2CdhVl
	MUERFykPWKkLf9XPC7jdxDtzKqP4HFY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754040843; a=rsa-sha256;
	cv=pass;
	b=60n/bL+oqAt58+GblfcG9pDLsOzSxt0fOmfsmxcM5dXS0LYF/FO+Irnuy1SCvyJxsHZZul
	eDjcsTATCY2PpKMNZuGzQe2WRByRu39zWq4lLY6gZZ/16C21BJUcrVIdzqxlaCQDWhyQEL
	Fkz/dhNCpD0IBTIE136fnBXpBUGADQk=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oUNvMf38;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nR3O8pYx;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5717C5XI018435;
	Fri, 1 Aug 2025 09:34:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=V69OVblX878Nkah3zE
	59Z9VE7TBZ0/v7LxcNTshKXOI=; b=oUNvMf38AKr75rJ2x1yWGogzNZTvu72vrm
	inMtRupbOYzmuwyfCMR+uj8OMOvmpH2Vsg/fhZX45IDWmiH3oET4uLZrBOy7XFPP
	9o006IuG55Sxx8JqnA2Csv2WzO8bWTJM7arbj5haXFCEallT51v7z6ICWXFK1J0I
	dhrfg4nuvTWPW2gz4RCJ8yTHGJfgOS+M+On3pS3J/c2gXXvFoATH4kIDU834i5tf
	EzvFxsAb5mIQiPwhtb6smQ0E3DPUYCRDmfLR6qUiaSfMGPsVvhzDJV/sHtIO67D7
	SGYHfjUenM9L8luiWlBexuTKxFgd26iAocG4STP9NTkyyYGi08Ew==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q4ee34j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Aug 2025 09:34:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5718xYO2016791;
	Fri, 1 Aug 2025 09:33:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfkxbjg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 01 Aug 2025 09:33:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q0AbLlU/xDMjzes9uVrqKNa48qsKg1SUA8OtrJtpf4bZQ3v2vBZ61wDUCHEIbVXDM9PLmHiYcG2mce6C1l6O9vcUqRnJ4Ob4lIBYTbkibMk7UC4C3WfqLVB4uw/oq4rGo89Of++9oiQmI3jtBiEWOmMfWWaEWT4WkX1ck3JtB4M+eQBRTP8UUMapi8JG9WhCW9ro7Uis7bv18QPU6y4jFJxlsqZfbMhtFlELzqJTBmx/8RfbHm7VoNjin08tmJHdkPi5+VRYFAxDfHO2UWwIzwNI27C1FacVoF+Jk34zApl++ojKXb2cPspIP9eDRhikiZsOCFy0yTCPZuVCo35OZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V69OVblX878Nkah3zE59Z9VE7TBZ0/v7LxcNTshKXOI=;
 b=T46MwE8n1dHmyFICK++3b2/ewc2EfF1jGcMwUAJCz1mPecBxBGKVH/v/8jvqQC7WLrfEbo4buBvRzUDs1ez/O+UJDq2yHSAuCPXHWx8B2SSRFYrEH7gST0zcUu3kQ7MY5dT6gVzSsLb0WKR3X8MGiPUbuHT7Tnzhu9pT8zIcccHvjfg5DBRWTOdfg45DbgJ4lFqdn+UKrD7dZeXbpN+iel9WEKGlxdKES14UfsISVHWU2PNxa3tf9PeykE4fvFd0/UzfM6GaOET41B2NLUrWCFhCPQyV64Cuwp0KrGJhnykrR5KeN0h1LaihXk/Nax2PVbZjZXgkpHQe4tFMY+tIKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V69OVblX878Nkah3zE59Z9VE7TBZ0/v7LxcNTshKXOI=;
 b=nR3O8pYxrKd/CYn4Rs240mJ5B3Cw8D3Izofi348EsFnA7a3uHnPGFH9fbTr79WdkHpyH3sJyh3QVYbX6uTU0i82nzRUCqEG4TkJWbEIRpwyfDbrodXiIYyhp8LJ047ykcRzYrgOm0ufpXfHvOS/nHlHmDsmSVk0uVFsGdteVssE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MN2PR10MB4240.namprd10.prod.outlook.com (2603:10b6:208:1d9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.15; Fri, 1 Aug
 2025 09:33:41 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.013; Fri, 1 Aug 2025
 09:33:41 +0000
Date: Fri, 1 Aug 2025 10:33:37 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: WangYuli <wangyuli@uniontech.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org,
        Liam.Howlett@oracle.com, jannh@google.com, pfalcato@suse.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        niecheng1@uniontech.com, guanwentao@uniontech.com,
        Jun Zhan <zhanjun@uniontech.com>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tools/testing/vma: Fix function parameter declarations
 for GCC 8.3 compatibility
Message-ID: <d8143801-0d4c-467d-a181-eb411ea8bb07@lucifer.local>
References: <EFCEBE7E301589DE+20250729084700.208767-1-wangyuli@uniontech.com>
 <e7554f93-03e8-4315-acb7-a55312354485@lucifer.local>
 <CB890ABC56C2FA67+56b95783-ed70-4744-9fc5-f2d93ddf2c12@uniontech.com>
 <37b606a7-17c6-4865-a78a-ddde1bc15649@lucifer.local>
 <d31803bb-fb32-4a94-aa89-83b02757d650@suse.cz>
 <12cba6b8-6853-477d-aa6d-23180c2fec75@lucifer.local>
 <671CE9DD76801AE4+34f3e3b7-4684-4fe2-80a9-93de1dde9c31@uniontech.com>
 <20baf9ac-9328-4110-97f1-91e9e76b8914@suse.cz>
 <27488afa-1d53-43eb-bc68-8e950d804000@lucifer.local>
 <E6DF1F491EEF7B1E+9ce0f7cf-7463-48cd-b80f-1fe0cb1ea70d@uniontech.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E6DF1F491EEF7B1E+9ce0f7cf-7463-48cd-b80f-1fe0cb1ea70d@uniontech.com>
X-ClientProxiedBy: MM0P280CA0045.SWEP280.PROD.OUTLOOK.COM (2603:10a6:190:b::8)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MN2PR10MB4240:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d777565-e8c2-4c20-5ee3-08ddd0de8053
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u2Ai6mNpGWJFSQrTMcbPh3V9feoJ4H2pzIaLdTWUZRuNpFvFnP9RgeZyJWrx?=
 =?us-ascii?Q?hh+mXWnlaGLH7Ry/AsuMEXfag/Zi9XKgOrdN9pMB0Jg6y0OPBd9mNYu829Wi?=
 =?us-ascii?Q?Lzv68zXkGo8/v1MqX85NLs5lk/rOVcYpCn1em7xTGG+r4cHn5ylWPt619Us/?=
 =?us-ascii?Q?ShFEs5aykVcdKX2Sesq6a9lZYekCNvqYqWN3hdqPXfCHr1MFRf5119sPrMuQ?=
 =?us-ascii?Q?d1tjfc1xWslc2eV8eRVJ8cr6bcWuW104AgR2MxNqa6mTl1T3Ybnpd0arBMg7?=
 =?us-ascii?Q?E6/R7v8kwGlTA3Ik7OX5LsxXU39rBCqRAeLs9CdaFloeh36z714UdI2XHR4a?=
 =?us-ascii?Q?L3kky5r70UEgc2NBHsh2sGsK4FXutCfV4re3RamCyicjwkHcZ6LBmaTsxe0A?=
 =?us-ascii?Q?Nzp30h+AXOBiCt2aXL+6wFsAYoOkRRLQcJYivq+c77B/HM4thF5nPVJGKTmf?=
 =?us-ascii?Q?SgECARPwZY15fAK0JqUjD3NnHBoeLfwFs9UMcjWd0ikkSi8luh46099ynHCx?=
 =?us-ascii?Q?0fESBbPTHR67frEwjxJbgCdHGz0+wN0bdEscAxdVsiOZMtfLA8OeKTybtlSx?=
 =?us-ascii?Q?B7dPQILhFMreJqXf0/pw7mdDG4ERWQz/vwjshHJosnzMw1+uyxJTaKSr0nQ6?=
 =?us-ascii?Q?6xhH15QpuEiRK6jCYlfd3sjfG0sB90XfQfmzAXOphRHC84aleqw5lkc64LbT?=
 =?us-ascii?Q?xw+RXPniBQ3kRimHrKYI1ZOgf04Tq7LCMxp8zBW2su2YT2mPX3gJOTu5cF3+?=
 =?us-ascii?Q?hdxum68DSZxjPF5bg1YQ1prfQ87snkAbbyANuqu7WrzqlHSOGAd+pbruEe7h?=
 =?us-ascii?Q?grq5HceBQi14U14CaKYVp7Ks/m9tfTNYDaqSdQekZQFMGlTdXCfLTYQNv4cc?=
 =?us-ascii?Q?QmRRRQQiLck44dwH6b8pxDu5XaR81z65Lfd4Ivd/oXulUyMUxM+WRC5mB8wC?=
 =?us-ascii?Q?91PBe5sRTHTtJcIWunG+V70Nu67lv2u+uxLHBPl3BHs2zLElaT08UvmV8lgQ?=
 =?us-ascii?Q?k5JpadQnchDuws0BMuRyB1keQP2vJn4MoT9RlCEFqnD+iK8YK6DhHgscegts?=
 =?us-ascii?Q?7Bs5HVS+n5P8Vcyvf/EuF+/PiudfMspmJ1XAnSL12CAtSZS6K4hi2Zlya37/?=
 =?us-ascii?Q?2/Z+pH6pySnAwVV4aMMuvG8r8Kg3XC8fqKBCUiXXJt4nNpcWdYAlULSLI/0q?=
 =?us-ascii?Q?3Zv671nrcmfzOByl3bTkVklYOFAVWt/9mqXCdvI9VOti0TBJA7BgFDT5XbLo?=
 =?us-ascii?Q?9Iy8vMqg4TU6OZ6LT+fR+VZzyd4GUiB/mPjF2FCO5F3SnIm+HI5p5szgK1qO?=
 =?us-ascii?Q?0aWwfDrgGlLs5XP7i/jUWwx+KU9trLapduB4VEJjmwWSxuCfUJfRctKgG4zm?=
 =?us-ascii?Q?50++7SlxRxM0QnpjTriRoIDhhqVABh9EtrbsoeLVrjzyAN3FnPhyqlpq2dug?=
 =?us-ascii?Q?845cyaa692Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?quFxJWcQ97ebyfBYSErRZOUiQZY2vKl7nmjHbh2afG0+xzjQTRETEe59P0lP?=
 =?us-ascii?Q?EjgGaGvGPs1sgQWeRq0coX2AQ3LpZKvB8ErOa6oxmhPzTaopIO743+NrCvkD?=
 =?us-ascii?Q?Xp8MDPZB6PigSzmsBAYrJcdYN+DsR8m2FIyIvfU1vXD20gjKZNwpEphs4KO2?=
 =?us-ascii?Q?yt5kTi3f1jSQ66Jw7qKqqzPNnnx/y0scXwb63WJhumllLcrOLaSSh5pbm+GT?=
 =?us-ascii?Q?78wrSiF+2GJhXDMAF/iR+p7sv3Klh/nhHYx1snnssehwa0y7BWKF9f6mkDKl?=
 =?us-ascii?Q?OJ/DkJkK1x7X10A//KaSpA/lzbSyhsdDQbB+0IIpwQMi+J96amcFFoV62ayE?=
 =?us-ascii?Q?Ly4L1MuOLkn/7auUoLL3YlrJmeqQ4DBreFfqqhmNV5L5f+BB5Smgl7Oif05m?=
 =?us-ascii?Q?wT656rofnanMRuZb5km92pjux6MGczIb2TPWwy3NmhAHaKqVU/7H6X0/JJYx?=
 =?us-ascii?Q?fsqgo1RHAp6WJIf0/vL5YKwuVdIgXVwN2JBE1Vz7skGBMH+6rNU3CY73mgVX?=
 =?us-ascii?Q?cVAM8+32XHumxD5DpBg5/UEG4xUj+XEQ/JlO2Jmg/dA7Zk6aBSMCd2aIF/lT?=
 =?us-ascii?Q?6yTmXKDrt8LWSFiMQ70BKWN0kFYwJz/C6kk9NYQASbAqTfhTNHu/eiSu479d?=
 =?us-ascii?Q?wJItg1G4X4r9BO/XZrDfDGjo3KffAXCRgKCjOfindVnEjJnUysTbDHWVM+ml?=
 =?us-ascii?Q?KidPot9VL5WFXj0GpJ/sJJeNIO7W6PuQCUH2BJW1CdwtfJ3YbWcsJ+5nFiDc?=
 =?us-ascii?Q?1jD5h8nCI5XQTRclQ2WgsGUVmP9CKfcGOOO8/CpMbvGjGIG8yZoVLKMLnj74?=
 =?us-ascii?Q?MBULGl5eyamrmRmAXX6tzGLw93R8aCh2ykOpxG039B/Jki24Lyc2U7uJO2PH?=
 =?us-ascii?Q?ZSAbyc0I9hry7w+ANNr5IuvdZIhUY+y8UykBGcqgatBQj+EAc+mi3dHrAx12?=
 =?us-ascii?Q?PblMvzRX6aIQzAOYfF2n/ULeZ6oX+20N82zxk4x+n6o5FxhTrS5iPQl95WLQ?=
 =?us-ascii?Q?wL5Dx/L7DV1jtA3fCG/2RsQDX3xaSzA8fZsPWcwBH33G1kkZzQc341/aeEG6?=
 =?us-ascii?Q?+oLEg2r7w8F/Ime4zFORRJW/jNnYa7/WF8D6q3sgp4fQAzwJb8t3+fKBl9Ge?=
 =?us-ascii?Q?JgbQvpZ2UDW7v9tobg4gO9xg+WiFJGeL+kfw+zkRp4DYIixHbBjOGZJQqCFp?=
 =?us-ascii?Q?3EnBABbdIb8EwVb23Eiwet8GNFDR5XWCWhx7BAT7WArj55zvKupuilEdCTf5?=
 =?us-ascii?Q?7xtN2H6X7SS3ZR8LK2e+z2q3lE2m8NoQZyiR+oQZfxE/VvtlJIWBQTXkZwQa?=
 =?us-ascii?Q?DdkedJs6F+/QUq/G/JjY3YI++bzGrzZ7m/sAEoMH5EhHeWq+fboBRRjsv7zl?=
 =?us-ascii?Q?/3w6JEwd7nWbYs2mZs3NFY67/fTcW4ayfXTbWAUAILGC1jiUpgGrxqjyaKJM?=
 =?us-ascii?Q?3SyKNUFnWhkOhAPlPtwgNdVVm8qmIESeXcpeIvZgYRvrMbFYme984dhcZw8o?=
 =?us-ascii?Q?dYPTRAMWRsN2i+b+lYwzZlL7t9hXLIJyk0fGYZU21ya3xAtwkfCC3kiUTCvd?=
 =?us-ascii?Q?bVmR6mfNv4VskQ8KqBG2hboUOCxHizUsLiTYL6K7x3wUMOlJmoS4mrK8cviw?=
 =?us-ascii?Q?uA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	91UmZntkU5uShmFF/+GRNLyLnLRFTGoDtf8pP5d5SDEIEqHeeLhRp51sFzhpNYYI5QtUaOlsMJ40bS16C2XzqMnoX8CufkPB89YS9hXyd3mYfMHIITrTbdEXCFWnzCg+JVzVLmmfHClJytoM3cJHNOSU3/7RXiZw7UhqlkT2j/a6BoSwaSJe6Mr62GsSiFn0nVforw9YonHtPiyUzIzwd5ZKiex5D6qoRroCITLhyuLrKrJGuHJqSXXeQQ4OPuVZisDyYTEtzsA0Mjc817WlPCeD0E8J8dxb0SFzWjbNwhcw/OuRanTgaztHoFLAXo+aitn/IZe+fTnGCazzZTFVPSqOz3/Dm5Nba4EG6+CQwwqc+MKKldjD8giuHrD5SBXAEjrUUthCo2OvwR+k7TnQ2g1zQEnvLvBLZBo+fp4+BTBABQqZjuq/ahVr3ih/yMEFTtXi6U5QiXYvEhdEuyAd8QijATinygmj6C7SVRgPlPFWRAYam0XAzou2wHHOc2JzEBm0Ypj5oK5ZTxy2rNodMZfKjS1d3N2CiYIzHwarK/Lrvemciwwmr6HlvgRqK/JtWju6cdMwsRjRmahN/VW+2K5vWkGtdNKipzIrlA+7dAM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d777565-e8c2-4c20-5ee3-08ddd0de8053
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 09:33:41.1644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: srM8SudNKD/y1lSOlnh3wXtoFKGxqqy4IHiw34IuiAxPeP9dSKGYYalz4dhWUlPEaPobaMYn7lBHimu6oC0lynsMCAGI76KIeyfUdNSWRQ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4240
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-01_03,2025-07-31_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508010070
X-Proofpoint-ORIG-GUID: IRY999m2ncN5U1EzOg0eoHRnqoPm0KmF
X-Proofpoint-GUID: IRY999m2ncN5U1EzOg0eoHRnqoPm0KmF
X-Authority-Analysis: v=2.4 cv=QZtmvtbv c=1 sm=1 tr=0 ts=688c8a08 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=DsAn1rU10LKvwdXetjAA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12070
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODAxMDA3MCBTYWx0ZWRfX+ultO+LKglV/
 K6wzq2zLyIjMh1TXYc2wgtCBM9UyWejlTEa0f9IfJozpu1uuidv00DVGUpZx31pGCeVbStKReAS
 1eZqbd2F5gJ3VCv+je/8Ee1VlhJ/nhcpjnDNB3Cow3pHtYA3R8nWkFIxnIMC3J237yWMfI2wVBT
 gMfZptCky4hWpY80wnE8OnlGRfrINNfbQWwvfSa76fM3MJBvDQGMG27VF6PMPdaaQfdEtkrHJmP
 7gf53XrXaZH+uJasj6RItjvchnbZDtyMEn4oTg0GzL6hxvyB8Upffx4BXquBCf0wB6gAkNVI0wZ
 l7tAsvqoRAToFTD/51i7lIAO5pKhF4hUG00K30FCO5eXFVsoqhjs7XYUnLmDsCETijq/z7C6bD7
 NwjRlL8v03bVZOfVgG5n/Cz/MNyXIuZMLwHlpsss2o+78mXkho7TVU6KNaWN0rr7Cwh4IAy0
X-Stat-Signature: z767gby3ntr5ogi3fuds8cit5xaf7tsk
X-Rspamd-Queue-Id: 0756040019
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754040842-781262
X-HE-Meta: U2FsdGVkX1/Bd+oGAduiNDDHvubXqxELx6pY8yjxIcyOSXGhX98yr7BhnoaBqoAzyEOZ59xa88XEUjF4El5F5nVurbRuM2MVTz518CyN75Sds0r8w62o5P77h0OzIMABPbIKqsvmwofbmYaaZEAgPA2MVfOaoXP46kVwAqXdTAamAf0glPcn2p/nCCVLGhQbnlXWB4n7XHvYWcybf70ka6UODymZQ9B98vMMV6KHWP2HLx2DEgdBztuMeZ7k42vs4ZDGB3MU37FMJ9a0ZZITpBImsew7u61Bop3XdTJdy3Qo3++PdMaDe9JNOxeYD66txFWLxCTg5WbR46X9c3oP0xKa/WaM3PTqEkgxPdxk0YGLiLkr8sIJfwAQBt9SRyXHp03SzuvWmOU51JQKGgNYEW/QpWJyVBadQ0BomS4CMYoMJoNiONefzG4tgiG5zfSJneMETkmQJrsEB/+61A+5VmJcDkQuP6/avZugtisNcPn3DShvfmANe9tbGTuOlQtGEpP2b8U2iDYVytWGo3xArE4gSKlAlYLRS/iKQanIvTMLXV8vw28+9NVRBaH5mup20kx1AHcYq8c0Yl2Q8nR7kPX2oDBQPjQNTi5rjVNxXFLIoZW7P3fNGYfqZsW7g7KuIaJLWlZlzHTtePV5+L2lwbqzkmb9VaFLoVjYkg2idzqyEc/4kKi5gbgA+7pDiu1VWOhvTnkkxoBU07q3yrSrlsa9iYHumCP40uYwcRw8e5BHxV5MXVnZXF1HnNkIPDhvWIheJWuBIju9I3KbUNHcny9C1x8w1Q7H6qFY537RpPBYDys2VZAQ0FSpzeRf4jMeI7Krq4l5GEZw9TO2Gbnb8pv+Z/tAjp4+NIkc8kJglLNsl4xOO9c9xEsh4yAHfqvHtwBKDuFIuPt7lNxqa/8vkCWILiIHlrkjeE/iPTkogJD8U4FHNLU82eNrh0D85WHSOSw4VUeRdWRZWHZIe3e
 plJaUDjv
 MU0XHDE1V6ClNqqYj90m16RArMweYAclqWK5owIc4xBgXKL37BaNkBQ9fzBGs1IU1Duu7Ce9qFCnrL1ac55j8R/lw85bJhermB8EsDLE7z3EaLMzsepiWNFndzPY3dQ6fDTCwnGbymRRg4icFt3SmtK4IX3+lEoYQ3JR9mt2eD7S+6Myw2FHkQ9btOQFpV60rhQeSv8AHShER/zUk4wSFZwMzJQRo5fGiMO9sIP+iKqZ6abOM3O7CPk/x9WH35CwbI7U7aQfjPCU68Jj8jiw4rfyA3/VEKK0WShdzatVbSreDG3hO83MYbJ9nY457hj9zz1afRgZ/GuiC3Fdku+7PboquoF8WPPFXoJdV3acFKaOHlqT7cIlkxlUPu+ejv0eCJwWuG5SXJZTdtVd2No3Ke/jDrt/LIkz1ROfoaXQeR21R4VXjKQjX8FNr4S92EgoBd3LMVfzbKMEs4731JbyeqY4hDKazBj398l+h0jPVa68BHiEWyU3j/QJmOykd/xfm56eIUgeLQKppiCjp9P39AwC4qePZ/GCttu9Ot3judHNntAEa+iO8TKMA0Bur7gu7LN7jW24hTxkzXdKRdF4Z8L2wADv8RKocjuv7dYNrue9Gzjij4C5r6bZtHO1RrT7EvLACd0KYi0rCt4DBW3CisoQ9WoInSYw8rO8XOfpFUjTxYxVPus8n6S7yNZSCCEr3zUFOLJgockOYhMLJvd98gs79zQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 05:26:50PM +0800, WangYuli wrote:
> Hi Lorenzo,
>
> Should I split this into two commits?
>
> As Vlastimil Babka suggested, perhaps it would be better to add both the
> |-std=gnu11| and |-Wno-unused-parameter| flags to
> |tools/testing/shared/shared.mk|.

Sure, perhaps 2 patches is best, 1 for changes to shared.mk and 1 for the
fixups to vma_internal.h.

Also note Vlasta's reply here, he suggested some other stuff.

Thanks very much for doing this, you're saving me some work by fixing up
the silly (void) stuff and I appreciate you fixing this for older gcc! :>)

I will make sure to review this once submitted.

Cheers, Lorenzo

