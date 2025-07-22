Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D328C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 13:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA0BD6B00A9; Tue, 22 Jul 2025 09:54:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C781F6B00AB; Tue, 22 Jul 2025 09:54:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66A76B00AC; Tue, 22 Jul 2025 09:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A56946B00A9
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 09:54:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B9EC80424
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 13:54:16 +0000 (UTC)
X-FDA: 83692044912.29.AA4F8AA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id BF3D2C0005
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 13:54:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=drfTqe+b;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Kh3QF5GM;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753192452; a=rsa-sha256;
	cv=pass;
	b=z6zmMsJXXP2GTH3XfPGLO+wthUzKgmi57D9KWiTtdGqOgkctJX62ith6e3b7IRhOBED4WP
	Ad1Gw+5SWpg7oroEbLc/TuKubSuJl6s3GFDwadlOSZvu/3PD1Rq+u/cfW/D+vDa1ofSZWz
	BMoxL6JT/lC3yOEozkrA177dEPkHovs=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=drfTqe+b;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Kh3QF5GM;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753192452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g62j/1oLS6sslb8N7K4QRTz/7ZxZzH4uSyeuV3/Q48Y=;
	b=qXuzCb8FIbcwZP4hAUxn/DgDDgNXuPlVl9186oT2YXps1QZB+OSL6XWSAYLO+tQz9TezeQ
	MOnFC4X7BCYgkgpw916RKZzkgFr9kMz7UIR7qexP1aZuvLuNuVFpx5rJ8Ttp33op2q6gM7
	7m8lcrRTq+fPIwdWtBb1OSyKSHa2v68=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M5TC5J006872;
	Tue, 22 Jul 2025 13:54:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=g62j/1oLS6sslb8N7K
	4QRTz/7ZxZzH4uSyeuV3/Q48Y=; b=drfTqe+bXLRFzPzq3xbljP8FOeVH5tkEXB
	8LiWgFUNRtd15Hkks2Gnk/NNxIixFsBIFAGob26MYbjX5C9mvXICff/Er/0jEQrF
	pxoz16Pu4EeIkxTrvrXzY0Q6pA1ykaHdRoLsGpfb3K5QbETXq8yS/hEwvnGGStmU
	6/MMiNKnibLRohTl17Mq3vrZSDpQSOvUJhvR5FQmWGed4waN2bm7Qu27puf8BNa4
	LmxduTmtsQhoaCuOmTPEVr1tcgr2ySIgwCpGQ6oAPlLSvqWFxrBMHZmQEpClF+3F
	EgDnw2LjkOYxBKf7uUcaHtbB1GTaRD0dvnXd30T723WCE6G+HyrA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e2d7f2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 13:54:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56MCXuBc005743;
	Tue, 22 Jul 2025 13:54:03 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801t9bsbq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 13:54:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=doLHM0HQzLw0f3xwc2TFoSMbxcvHYgD9+cu9qKtZGz5azaNaJNzz/9YjZ50Pw5o74KquFcrbef+tJqFkVCAL/pIBX1qI+Vc1mOZz7YXAa7wppFbf7+tGkHLeyzcV8D5rUHhukFx3Vn7zR+dZ15GrTpoEwqXHTGDWiKS/9QSYTsKb4bMEeFCYiuyBeGgiHkrhxAjHWKy/KIL/plRs5yd/2Hph7dBoTz//2YoHiGfoC4OEudt1h5MFF2jDXTMTVF/mWBDsxwJOphRO94/ofcP67Xqv/zTojCjYvIuufblYhBOSMmBNqXuMmGjJdb72/jrEfylV/p15xTA/Z/ONIHjhuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g62j/1oLS6sslb8N7K4QRTz/7ZxZzH4uSyeuV3/Q48Y=;
 b=TSMsqLMmcoFAd8xnKJ1LnwgwWPV/c7A3WXwwEZ1ElayjnRTObEvuLLf7kDSUJ3YIHHI+4+R3UPU/IHGMBIjkIe+Zp/izcvkDcyWPWU66tCtncM0OFl2O/cdXfxpBKBhVEHhhCim7TVEwXmebqIWwgsyPpWfgqp7tNkh8nonF5JU4M5H0OhSj0sekwiw53q68EiTABIveD3kzsmPNsZN5qX1jPMYkeg5VFAe/bxx5ri/azeewcDh3KI+rCc+kHadTwaz6GDvyIk9fsJk38DdDpPYxfFD6iSx36B/mHBnk24MGyseXRGUhANoQuh8FX6w43Z2kGsWSzqj+8ftariCRXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g62j/1oLS6sslb8N7K4QRTz/7ZxZzH4uSyeuV3/Q48Y=;
 b=Kh3QF5GM/cf4VSSIbKPde+rwGI55D1+4+fzqa7CRdgc7zDLvu1Dp+O2ATGJckSjW44zIFuc9GNnS2myP/2vK/huVksa+bZl03xSMXenVj4TmdObtx8aTFmBNr/H2ZM03FJ4DViMjL7FaeYDFlyuALgoPDEU9RSOFhkz67wKY4KI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7561.namprd10.prod.outlook.com (2603:10b6:610:178::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Tue, 22 Jul
 2025 13:53:43 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 13:53:43 +0000
Date: Tue, 22 Jul 2025 14:53:38 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] MAINTAINERS: add further core files to mm core
 section
Message-ID: <33c605a6-2b89-4b40-ba80-ed2ca665ef5a@lucifer.local>
References: <20250616203844.566056-1-lorenzo.stoakes@oracle.com>
 <727b5e89-89d7-4abf-a93c-8d6f2cb2c438@redhat.com>
 <aFDm0YrbSAvXc5Wp@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFDm0YrbSAvXc5Wp@kernel.org>
X-ClientProxiedBy: LO4P123CA0681.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7561:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bd02cee-a86d-4c58-271e-08ddc9272b9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K7wk2ND/oIB3wJXGf5vqT+NXSlkgEq+r10tx48b8wan3DxR2o63Rg5EQA6Ap?=
 =?us-ascii?Q?ZrLEM0DZn7jBNs/bAC+EsIX2Tbi/KurCaQtH6i/NcUTnZibROa3SByMqL7uR?=
 =?us-ascii?Q?NYH4l0U8umnOsn5LYQS0GAz9eGviBaJ01ELOzJwhPbWoZEq1kDW6w81OJU9v?=
 =?us-ascii?Q?3UQ8wupdTQ8dfC3CL6F2Wg+DGcCbKqcULfrTJtQ27eApVRRkAXcGSaSFQlsb?=
 =?us-ascii?Q?44vqQslLyVT1/DyOHlJ64eiigsPzUJHQWZYrR8vElmNfLdvFaiRZ4R+BjtJi?=
 =?us-ascii?Q?xFB173CB9qrhklzgZDVlCMNRIW0YdyZnalzsVjUwGXgoPCEKAq+2iHSgGEq1?=
 =?us-ascii?Q?Jy4pspx5ae4xWWJ3/hx5RLxVqKEx8bFAiiUB9cvdnIcNvxpN2eKeSrZciltc?=
 =?us-ascii?Q?XlZa8lXOWti7mhzGe5Ob48bCiLebKRlLbBuRUK/M5VHlpaNJCASSrcN7Bk6v?=
 =?us-ascii?Q?CbdCt8XfotBfH2vk3EAlXMiYUE6LMAzoqfkDC7unvmCqwxvwgQR8ukqpeIQD?=
 =?us-ascii?Q?hngj8uuOSvFN3vqfN7goAZFuDVFoiGVSOaMJow3qh4671Ol7Xbf3of5AP5vW?=
 =?us-ascii?Q?W/RtsPS+qAMhDvIHe0AW04iZk1SukCbSnA4u8QzbAFsASbPCUdvXCu2fZQfz?=
 =?us-ascii?Q?Volo0+bV0MWdwRntYhs2eCI/+zCdUz6djnKYDWBFkSUms/AAVNDRlQMPbvus?=
 =?us-ascii?Q?qTIxV4Od3l74gQlTioYOzqyJu3yjUOD0E8i6/GmswtpsM0jmW7u4uCJgNnXl?=
 =?us-ascii?Q?tSYsZOjqILuLQWBZETxK/5if4na9Nhl6V3KanBlzUgQLWOFG+7Ycu78s75yz?=
 =?us-ascii?Q?kDn3Aeq6zVXNLELAFVZGe6sw8eN414bRCGtkG+jZLW0f3lx25vuuU8UEBD54?=
 =?us-ascii?Q?qoVkKvK/lXdToGiPHcfnHK25/ncs2MTcZvIxMvRKVSr9+a5eGDPdc8fJTvHL?=
 =?us-ascii?Q?/WItO6OTX3Xj6+3Pv53nh4KzV7pcX0DZWjXy2isP+q4VTv+4iFw60+WjCJeX?=
 =?us-ascii?Q?8mcmGQBiKt2zJ0pdxtfDXw9lVaQqwiu/yfqLZhmCf5RSCAF53RHZi/47teKM?=
 =?us-ascii?Q?uL/gQ2TA5GiTSkONzri9bo7piP/WK6jhonowjlmdxfPIGho//3+zlTtNz868?=
 =?us-ascii?Q?0bDr0imV0SSlKPGrhLotrojyLaxZzhU+gF3nm+1NweWb5Jh3dBCkGw/lMywT?=
 =?us-ascii?Q?FtbQAVffxt2mttGbuf6hCM8ahXQGSGuqR4LaAVnWI2P/yPy3PTeiJ7GgPLp1?=
 =?us-ascii?Q?YiMNXjhFiz0n6b1/iWEMeh7+O9c5HUKUDDzpaJnO4q11lnNRXldAz38PqboD?=
 =?us-ascii?Q?96QxStCnAVI/zvaBzX6yipdelZ40/1rilhpoL4ca8feBhwbALyUZi3iVlrTP?=
 =?us-ascii?Q?npuMKOcdpVP8sBudApgq2Qr46dqXcGde38neXor4yB9+bBv2Sygr0ufub3ve?=
 =?us-ascii?Q?p43ViSCs34M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eBool/uIPujTSM+FQYcdHbazXtARdOLk5Kv942i+kD7NtrXOoz1DTSHLvXyK?=
 =?us-ascii?Q?o9ws18VYvFVQgT6sH9pz8HW5CXQIyhrXu39MT/r6zJV+a5EJn+zOUYdBqm1+?=
 =?us-ascii?Q?jEhHSRse4mXJDGUAhx3ozfp9GvE/5CHKPL55AJC0lthA4oJMH0Z4XIybrI2l?=
 =?us-ascii?Q?6OSgEu2DYksic/QV51NuJ1pfg8lP2jWAU28VED7btknRZDnh84zBaLfcIHxa?=
 =?us-ascii?Q?PnGuiS2rcPLbJwFLGkMJum7ghkOImOQX7GUyv6bBC/n+N7mwu5c+Me5tmtQ3?=
 =?us-ascii?Q?wy+dLwIa4kqbNcvonaenvk1YizMu4yAl7GufzO6Nf3+HtYoMqGx2Qs3xIFY+?=
 =?us-ascii?Q?Fs7bW3kadzgkZSvtZIYrZsIG3odUCVYtmUOCA2s2LeVEkiqy0LhOLxEkVIKS?=
 =?us-ascii?Q?1cwKzjx1f667KJdFKF6k5LLEp92Uy+oSVT2ERcM1gniaqRpWa4IhPBdZesUR?=
 =?us-ascii?Q?SWYgO9CvggzLfumhIJRPfWLbVMofhjdPlzCTDPfiIxmikRY4B5j0NLDgvHht?=
 =?us-ascii?Q?JnkJ2T9/FhAZAiB95CvethoCEtcPp6hFqM4Zv231mKwP59+FT9nlfYgUmXVl?=
 =?us-ascii?Q?uvZC8YwYAutaCFy2UwKFheyuy2Sggi37NKdP9F1zrUGC5ZpzQ0TL8A2U+CKO?=
 =?us-ascii?Q?4YaoxLLXCmV12YbmQBEXNp1nHlfB0EniS4/DFWKd1Yt7kw7jgonBPIAb5i4o?=
 =?us-ascii?Q?JRp0+64OorVQnTR9xnkFxJXtZjUs0rbr65OqOIsuIJE4CVacF8M0ILx65mVy?=
 =?us-ascii?Q?5ceZF1r82z4U4eU/tRIp2iRL1F7iZsS5nIoWNeCk+47diWymKcgq03syboz/?=
 =?us-ascii?Q?AUGU7S2mM/6jNM9uCGl+O4EnJakjm8TxW8Anp4PdYv8yV1D1QCjZJEPY5Y9l?=
 =?us-ascii?Q?rPEsFjtjbiVnF6JKbbEumkk+I/Hny/VCRj8Be0uD4X992HUrU7hpTbnIp/rw?=
 =?us-ascii?Q?VQdb/DtXbmO4BIuMiDWtq430Y7VlIivzwudySgR3AUa4+o7rjpnKI7cC+4Sr?=
 =?us-ascii?Q?cqnxiCrheVFHfVJBlyWKJeE1Mee6QWm6ttLEf3Lmjatsu6J/WU6o3PibFzUz?=
 =?us-ascii?Q?uz66qNX/FTjyf1jYg7FmWKSYdngkm9N91WEGwMbs5JybL4A/2De7Gr5w55a6?=
 =?us-ascii?Q?gZS68dK8zVlVeLE8NThL4JmJsxSUWeEefF2Pc05xXntvbg4+prlcoyE+pejI?=
 =?us-ascii?Q?rTuv3Udz8EvOETCHEZlQz+gso3Vp3+hN5rwijPUOFDgPFmMBHDO1fTnC+1wW?=
 =?us-ascii?Q?2fDHIwe8g1ARPzgAzl7T32ggWBrZcunCF4QSnbgmD7l0of3Qi9ylHQb2ZtGq?=
 =?us-ascii?Q?UUfmI1ygImrq0uxVG6Bysn01tlr4XzGBKrF2CfEUS21B4J8Mj295DpUdvBhk?=
 =?us-ascii?Q?M6axT+MqdZPjNkM2JUnbDG46ZF/V+4er0QxW/VBT0iqPAuKtjPB/pQq5FQcu?=
 =?us-ascii?Q?9mJqib2fX8cIHw1XGc7lPB041w+G0UHXJhD4JYFSs3ctGH9LXZhN5jAoOnzZ?=
 =?us-ascii?Q?+6O2hczTvUJQ4owbCy8HCBe2NMsDb/MeqGUH/4PGtKm5BssiVyjZt4d50Cia?=
 =?us-ascii?Q?RXWta1qaVHaLvNUUchjkXHnrp9zl2UT4Ef8awAKQhs5kZfJ4tjM6fRl8rP8l?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E2W4Z8AdzmJck9GoV9ZrE8+n/9GYxYyjCi1NiAMHvm6FcEd602GLx62ZAKdzcRrxfdrgqdTVYkfYY8BcAbz7YqoFU9XSK7IhVUOS1SKbbFP5TLnTtFPaFpM9SZ+oO4rW9MEysfHx/n1qGPujal9QvGNwjO2o6ulOJzRmvYmni1rrMH00Ud0MrrMSRIh58qd3300LTuVbdkfaO5Ldjr7ghxyyyFTW6umkYil97+n3Ur8fp8qlYOTx1g8tlQDF6gRL4ltmXaYB0L+MbpkDf86BCCnSjONaNoZiYrcYrPT80sV7UCUhrOOlsZy7t7uUMLhvWFzqwbNhcqJ/+gA9g9sOGcU0l5iJe7TXerFUV+yLzXBUpM8sM4Y/ckanzueMxcEajV2iQS+IXwWSoD4OW/W4zaaQmDu6xpELe+t4NzU5w4U+861ShVMklXIBrs47nn2Eh50gdfRcLPws+C+ZYVzen80Yn1D1k66/EM/RgnV/EmBkfL3Uaq2rQJSd9xTC+X6znk7wEXineLCF4TBPwTu+oUe+wHbQVFnvdoH8rVzgOyzkTEWzS8Xyrgj3SWuk4TzsF0d4b85ecg25oa3UhSVtVwqZXFu62CEGxDi+1HWctcU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd02cee-a86d-4c58-271e-08ddc9272b9a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 13:53:43.0190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BqQ9IXV+/jI9zoGoF5Kwp3HjMWkjin65PVlap0N2ipxbzwn27uKdL4NOXtKIqZt9ZzGzTidqhG893bHsAjPMwCWbisoGhaSUvYL+enEScac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7561
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_02,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=800
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507220114
X-Authority-Analysis: v=2.4 cv=WaYMa1hX c=1 sm=1 tr=0 ts=687f97fc cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=LVC-YzPUhquGcwqOwmsA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: s2by4IGMfDVsKt_8fbFiM5TY7GNsg-_y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDExNCBTYWx0ZWRfXzWUxYk6rOYYZ
 lHaDwd+Db5Q2JXrWh477sCc84sYHcgQV4u+0zUhSGwz8eiIf7/JD/5woGGJn2AfydnJWnNlTfD+
 TmOmkaqNUcYCY5CH8ojOqHKoOUnIuatqyhGaF+VoFtkN5VVJIcOMNfZ3Dr/CVdBcGBeZ8H+w4i/
 H8gQUjXgIpWMkkvZtMvtQMIrNxRHVc9kdnbzVmMJBla5Xpil2fxyR4PtgOopYluJDAQqW6QQ+qY
 MZTqsyHaUODZPz870hOnNi7iSj+JU/PBBFmm5Xrbp/I4I40aGS58SU6Zu97qFSZaJbsvKtZTtKE
 GGjBFh8Zc4pgHFRS91oxEYVg3l9ix7gTqg/X7riO8XSA6DfeaWzaid+l3+uTOlIh9xS3UzYSeWW
 JYSQZpeRAXllc4N4it/NcO08MqZ7fW0BQWjv03R64CEEHRvrbvQiSkwoGVGPYadICOQSh86M
X-Proofpoint-ORIG-GUID: s2by4IGMfDVsKt_8fbFiM5TY7GNsg-_y
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BF3D2C0005
X-Stat-Signature: 37889krraxb7j6k1bc9c51ficyepfqmn
X-Rspam-User: 
X-HE-Tag: 1753192452-311998
X-HE-Meta: U2FsdGVkX1/qS0LVUvxVeTkwDLSP4+UM2Fq/uj4xjf96A8UxIU/Kf7tPSzfUGTM39kc/lgshMKMgS7xNueisvfQtZWVnf+Rj8R67EKUFKoC0CJG0KTs7mNZpU+85JTB5wzJTzzcAmzGxfA4fpiETNUMWeahY1+/4/78apJKFdIpOumwztHgyLcRWoZBg7YFaI8b7o01uTbq1ZejZ66NEayWZ4YvC9O/liKDOpQUZazKNq4YwxdF4q7jeJXYGQF7m/o5FjQ9sy30RbnnusZzcODa+O8UjuOKu4zV62OGxJCH4BhgQHtm5nEXLE6bZG/4QF4LqSKJ4vLRG5CMN9//RKaGHAbll2JXDgmpzniBj1qWFicfEJVfLPBbuNIJAU3RHVdca0/BbAf0u9b7cADg4+1eshkflCc1+ueWAguBwCIHgHfvefzknFWp2hXtSJKapiozurbeyMK3zo3tGC5NJe6WEDPx/4M8Nkaw92n7tGQf/pPoGos+g91yhNSPZRJz24R7IEKC6uE5ZhxnGsSustWHTKQ+8ORCLqSRWQ+QQYQEDHbZUJXs1N2vqb7ImnndZrC//yfoVE7yjt5T6M0QL+kr2CHcDdcu2QAk53AmHvadtJqgm+Vc0hf2oVs7QnMiHy/7gWg+QfpBZeb9KkycX6u6nWkxLRQDq5BDBWkjRPFKiQc/0mAplNFR9dDEAyZn6CUyBthM/P5Goq0YnIvmGvTI5gi6IQQFUbdEWsrSZFtOsl91/qUkkid+hfWX4MeKoJRmB5bgAeIdJP9O5/8QedL8HoKMUNRTq6MyqR9OQooa6lQngwGM1MAbPVLS1AH9Qwz8nmWSNc3hfiCt8ER8YqZw2mGQGjY8e1XpP100ohX/h+hqK+/6xaI+xhSBpkFAPPJ0++qh7orZOFQ4ZiWGsUBBzdWGZu7A5y4HpvVxjTZMKo3kysT1ywZQS7dFQffoFr134J8opfGoW/Bg17QR
 7tBwhCK0
 ASluV8iOmjlTcZfT34FZGS+RcO3HLb3mzQwomTb2Dg10PLpz6RLORi4N9BjCmiYVSekE3NBpUdn1WZpxZIX9Reo5V0olzp5MYwK6I5GYPWuTtlQygHOBxjAK0mq/dT5ygCoVLUiuewjUlBiJJWdeJ2hh4vPc+oarRISvtitrtvlxT7O7LBgIL74s9+J3+9RYi479G8WfUDaop4GreMZfvWqEAs9ioN0tMmb/Q3B1w8BCA+7u8Jjm/N0j70Vfm1v94j643dYmr+Ha21g5z0OxZVKRkc62zyOJgj5mn3UPBkpC5GsdNlol6A18XxbD9dArFIdFPAXr6dT0Jqs6HdzypPeJ0ItmSn5+xxJrWWZKe/NX/kQag74XgGGxpAEau5w5w5pYKSzhSyAnmGmCNYXYx/hoomqLkXYTprKLN6tyoTFIJ4+J1TdyLt7QwIVT4etZ0j2wzVJw9ttgbYHyAPjlAPUMm4wG68gd8/TUQ2l5zXhwgu4ADRYl1HeHWy0v8BDB2Sz3UeskG2RRR01vHKI3XCekc6tOtqRd0FUH1BKKNNGy/gcWlK7+J7t4RtKQeTdIuwQOA9QSSPs0UHKfvVseH3LyLISGL6MYAa2sZeZKMDYNlou4FTC4JHjjb6u0DHmAPfWw+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 17, 2025 at 06:53:53AM +0300, Mike Rapoport wrote:
>
> > > +F:	mm/io-mapping.c
>
> This is an interesting one. There are no in tree users of the only function
> it contains.

Hi Christoph,

Was going through and making sure mm files have places in MAINTAINERS and
came across this - I see you added this, but it doesn't appear to be being
used anywhere. Should it be removed or if not wonder where it ought to go?

We're contemplating an 'MM MISC' section where it could live potentially.

Cheers, Lorenzo

