Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68272CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 05:40:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7D809000F1; Thu, 14 Aug 2025 01:40:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E69900088; Thu, 14 Aug 2025 01:40:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF56E9000F1; Thu, 14 Aug 2025 01:40:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE48E900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 01:40:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3EC8C057E
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:40:48 +0000 (UTC)
X-FDA: 83774263776.06.23DD827
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id A565A1C0002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:40:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Rp0ZJs6d;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zDDvgz45;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755150045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DewrvPVf44ZEqhe3wf7Bmu7GH/t2e2fjBDnF/S1OnfM=;
	b=fHomtNIeXJ0h6IuxOx1m5sLdg9jvZIEVB+qJ/wM6jj+jrZRksvN0Z18D++BS4qU4wRzVZw
	dQRkhSp8kMDxJvJRzl1sqn82f0cxA9nQSQWlf3XaKOJ63MAbgs4bAln1bAshNg7BvsWMAJ
	7Dre7UmFMQ42TIM6pGB7euKt0fz7t3A=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755150045; a=rsa-sha256;
	cv=pass;
	b=C/50UocyN/+MzZoGPkmZxyZ9VMWD1G70iO478aP5A5N9Nh3/UXRMymPPKpp63ew0RKenTE
	QeAW7AJoqmrBZ2a8FUzaIzyUyqArcmq5e6ZQWTCDz0styfUmqv+2B2VvZA+oAjIf9wOl4o
	vA8V4fRsV7pOYGXzHFMkw0pXUpLp3GU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Rp0ZJs6d;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zDDvgz45;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DLu2dS022255;
	Thu, 14 Aug 2025 05:40:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DewrvPVf44ZEqhe3wf
	7Bmu7GH/t2e2fjBDnF/S1OnfM=; b=Rp0ZJs6dPo824ObKH8Xp8GAe3vhv6BTuds
	oQBw8Bs/gaoVwa5+wISL+g+Tg4DDoyKQIvhozhIZQjqc/Ax0p1t/Y8Uns6Y+Klza
	Y7lvAJFP2TL2NuE/KyzxUMJU7F29T8mGzJC47cUxo2fx3tsD/cKGVrdxOxElRdsS
	PmhU6Wph0NEc+SVGRPiEqGIQZa+jYE+3WEfFZWsGnl4zkSNLuG+D2AnJW5F8pcUi
	EpNP7E23atHs9VQtYbXdL9eVJSMif5uLYBrDPjMFEXrEnOW64HlPXGlRVep2F2WH
	38L3yT5s0HkSOOtGaQXsJ4h8zZH7H4hTXiXKxiekIX8tUDvDCHvA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dw45111j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 05:40:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57E4daYv009664;
	Thu, 14 Aug 2025 05:40:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsjkwuv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 05:40:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R2HsLIxlJfBaSX12b18ZRbFPousjrps3rmnKTJ8TKVY7XPc+YGNqmSnhwJHkJWWwJET3RIeTlXWrKvBMlbGbhObabJBnosIGA2TDe0TCfKQag0sryk6e0nRt1r6C0amC+PqdongufYNnDWe3pg6EpoYrijvKrjdcZd0DkSBG4bFJeK4Yz0wpzI+yux56SG6RJKkMf+3rHoe0vj19Ls2fhGRYxFa/QCC/AgXfN38bCjTJiqyBqf2x633p6fNRaJz4Ei7IhFO8shNBXiE+H03zzoPmn9Fnvbxu0idchJ4u5klt1OtLQeBw61QaEcD1V9htFQ6dz6yjkeeraTmurMmenA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DewrvPVf44ZEqhe3wf7Bmu7GH/t2e2fjBDnF/S1OnfM=;
 b=pL653wD5/jJpvlkXK/3tCcnl7MoX32/xblkDqrLLvki5z6J8zd2Zv2uQ/Lr43YCvb0WLl69+8QpXXMvHGwd5GsT8lsgEuE9b4Hm2gnOivbxObLuuDot81D0x0Pmznvx8UAvB6i7sfmCJEO/LUjkhW0VSGjnc8lLQsIyIpF7eYH7KqRCxw2D4qt4Vt/Z2kAnGo5pjSQi/s6e9ptHh66LlXDC+/IDjPZTXtuQJharqzPRd8L/nRZ6EXjgSBNl5JR8pUTizKoHYKvzbRS/Fs+lTjqUYBkYiUMyBN9lzV/9PfU/AgbseDzx7K2nxCJ93+RoHORxFvWg8rKeQtZKNEEBy5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DewrvPVf44ZEqhe3wf7Bmu7GH/t2e2fjBDnF/S1OnfM=;
 b=zDDvgz45KbCVhp4N4l+tWUy7gqO+D6kMmqpve8DaJ8Shuf0e0NXHDmdsI3JRnffwg1N15vKcn9Dz9OhQ8pSJV89qsQuoY8i9MALt1VHc+oIQzBjxUj2E4DVcNN2BKGIfX0dYxRfkGPCxAcYlQMwR/apZgTQNOffliUIGKPTbLHs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB7832.namprd10.prod.outlook.com (2603:10b6:806:3a9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 05:40:12 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 05:40:12 +0000
Date: Thu, 14 Aug 2025 06:40:06 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>,
        David Hildenbrand <david@redhat.com>, Qingshuang Fu <fffsqian@163.com>,
        hannes@cmpxchg.org, mhocko@kernel.org, zhengqi.arch@bytedance.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Qingshuang Fu <fuqingshuang@kylinos.cn>,
        Yuanchu Xie <yuanchu@google.com>
Subject: Re: [PATCH] Fix the data type inconsistency issue of min (tier,
 MAX_CR_TIERS-1) in read_ctrl_pos
Message-ID: <d6463ac6-a27f-472b-80bf-49cb2a632302@lucifer.local>
References: <20250808072106.153449-1-fffsqian@163.com>
 <91d72c49-22df-43ed-aeeb-0b93a9da3bfa@redhat.com>
 <20250811214053.857168fd35e70e73dee1583d@linux-foundation.org>
 <CAJHvVchDq-p77VbzO53nNxMTZ-5okMp1SUSQfw_VD3f75fFgAQ@mail.gmail.com>
 <20250813144145.cf6eece4d1d746568c39bd86@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813144145.cf6eece4d1d746568c39bd86@linux-foundation.org>
X-ClientProxiedBy: MM0P280CA0104.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB7832:EE_
X-MS-Office365-Filtering-Correlation-Id: bfcb61a7-498f-4141-38ad-08dddaf509de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7oZsSnfFHwghAGv0WToNMm/F9eVxjwVZG9fTcN76IY+3+XW90qfYZT4ur6ox?=
 =?us-ascii?Q?HSuIh571zLSW+RdrTgezH6YXQWzz0Hw7OH5VBGeneqTZiRa8NydJjWhMbxnU?=
 =?us-ascii?Q?HCTOFV+Ov+1+vGbn1/GFZnqQdXnYEQKUNSczdpnMOFG0+gKxdbKN3ZyzFldW?=
 =?us-ascii?Q?RST/KrgDQM8QG2bQdnNa797cS327+bnPWJ1th8gay5Zg5GrxG35YthT3hfyt?=
 =?us-ascii?Q?obGKtO8E/GlG7XL4qsULvfyp6vflTSAODjKJL27PJDAWz1q5CPXxbMF46IzB?=
 =?us-ascii?Q?uco8FqXPxZzPJkS9n8LpnLOqgdoBdmTpA72M3L4zGWw4HzlCZVFx/wzps2Jy?=
 =?us-ascii?Q?Fbarw1msoUPGVylS9wLhwOml3n6fjB95C65f26NlNuyIVZQzp7evxdaCBHDc?=
 =?us-ascii?Q?jmcuVvW5aHvT2oPdTUnzWtgiI/TvW6oZoG63AMvEacomkNoUnV5+YS6RWxn8?=
 =?us-ascii?Q?dDABTkJyfoDayGkA0E/GfW/C2/15tWN7fd7AG1PgD34BzVW3jDRBKt3pkAZ6?=
 =?us-ascii?Q?5vUh3vtT/OehrgrzDFhP3XeHmtMZ6kqz8o7++F6TknfDNvDONhljH6vWW/Bo?=
 =?us-ascii?Q?0HmBiRsSjERiqoAZyl8cX9VRomu2SHlrVm4McHLk77NgRl0o0xSr1sinqG5l?=
 =?us-ascii?Q?WushDel9VxbLKnIgmTinknrBbaJahNzdYM86U/MguwCpyrz0EwXATgEsIuh/?=
 =?us-ascii?Q?9jNbrViI6wRZCn1jSVM04eDYf0Mb2dA1iRZpSYELCxt7moqr4Nko+dmsPBl7?=
 =?us-ascii?Q?IdtzrnIhGiG98eRvcGZjllEKxg54YYOUj9YIpZc7M/A1YktFcZt+f/8zZmec?=
 =?us-ascii?Q?KN1cqgWCAmrYI+mug3sqVKO1KgjY+eKwsN60wUfya8BcAEmifv4yL+EKerNY?=
 =?us-ascii?Q?Mh7KxpQXYL/B6i/sPEqCnldGMsS6ShLbZjLUUYXDk8110FjtHEyJoCAvYLXN?=
 =?us-ascii?Q?DVGTEvuSivGD5qDddxgSy8ikpxiXGAE9LUPi39egCBzqy8Dy7RAAjz+Be8wE?=
 =?us-ascii?Q?w3yqN3ICz4DbLQCkEjg+61wNSFLTPvNBYmUC+MagHfL7nWT1cSBmvd8z9VyV?=
 =?us-ascii?Q?vQmKZ4mCiXZRHn6l4O8jQNIaL7qRwwxwfUb9O4tJSqR7+yD3tcGTukHOv5Me?=
 =?us-ascii?Q?fCrWKqqN5dQ32IHpegWWcC4M3M/B6JhyWllZX7IKQSHGCIJ9zkCwbPErXeNq?=
 =?us-ascii?Q?G1mJpONJkndlMPwC+oqYxcP9ZET2mkH5/W5Z00IZCkXWQpW+acf/b/YF+n77?=
 =?us-ascii?Q?c4Cg52tBYL4aXKSf85UEinQmiiL99VA6e2kV++ipEsmJh6MpbPTMCE5tJU5J?=
 =?us-ascii?Q?w/lLWq43VC9fVZtj9gRqGlsVB5o2um8liANCID1+/9j4ECBxtappP2AfL54f?=
 =?us-ascii?Q?x0alwjxHPZ0PIVVJJzgUSKxm55thRLGFMniPWFFIjIt7zt5MpVBNP9+urBTH?=
 =?us-ascii?Q?s54QLjF0y2I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oJr7+Sulrqj+PdDJuVAJmxw8QAsLCgG6LXF0H7S8KJjwMwFZiOG+crF6VQ7Y?=
 =?us-ascii?Q?Qd6yGOLImaxdM1hsrpK3F7wQyL8IPb/21EJc2bfHHvoCls/CLsVmJUXTbPud?=
 =?us-ascii?Q?OiBZNXN6CONSGv5bqw2wd/iym+c33vSPE7j3Vnu9cT8POVdLISRX7UuxrkXz?=
 =?us-ascii?Q?6fB8MH+QnuuAvcmeGeT7qwtfNmvHDbJGYAnujEd7fDY9bVG/BGO7uTE0Ci9m?=
 =?us-ascii?Q?7R/tCP3GWQQiDDXxCdYdCdT0pOXHPEiUKT4sm1b/jxp/CGdV4rT5YMb6QVPV?=
 =?us-ascii?Q?2LkU0NY1xDKYY+/Ig6LqfgHohbJ18vS9dmAMyc51KDWEGT9W26KXN2MRyvPo?=
 =?us-ascii?Q?trgDrjaT6WhcmB5SYx0Aq7Cb/w0vvPToROxj/VTnGi9N1HFiYMNOBmDKxUSn?=
 =?us-ascii?Q?KxJO0UIsSlj34KTSO5OpHomfyWi+tCHtlfvc2eiaUrfvrI6YRnWBV0tw4Jak?=
 =?us-ascii?Q?0ycXUXOPNzlym81+yOwzOMId3NS226SE5uzyNWtM2k5CE84Aob93eMz5Ysi5?=
 =?us-ascii?Q?4i8Tb214r1d09jc7rJOQ9N8g3/vBAAc0J5Ck25EEHf53KiRKQZ0H58YcD7sK?=
 =?us-ascii?Q?bKR33iaAL512+D2x/O668swkhfXiQg5fSm8LVoEBaGREW7UySBheNLN2V2Pg?=
 =?us-ascii?Q?6z5UARriVkuIHhamqYhDsJQNqesLeg9SbjNrevosXSHnIk6aTA+sObmicVwC?=
 =?us-ascii?Q?pF2BaYsdVxrw3ooKZsDM7mB7ZzgggwXFPBA2wEGe2yQCHaa4GEisV+KtO+2W?=
 =?us-ascii?Q?n7fwe0U3fcdxuGFn2ryjMUOcRZqO8bIKAdRtll5naC6YYlmsenlrmLMW9fNm?=
 =?us-ascii?Q?XBP8Uug+Cz0kOlig8M3cFXJmAmXZgH+s5EKILL5r7D8BIZ8wDEUHKf0GTb8K?=
 =?us-ascii?Q?fhTRmfXFotFU9cmz/5B56Q4UWIdbYzEc8cPLARrj8i1wQ1x0XBYgyEAakh7P?=
 =?us-ascii?Q?zEfuwhN5p8/c8M3O5LjyJac4VDZ3P026xMwGptATDU9UswQ3hMlUhmXZJl5n?=
 =?us-ascii?Q?W1j22csnDl8xj15SowxksMxBuvD5NecvfevPGi0drC4SV2BGBhYNpN/VmPx0?=
 =?us-ascii?Q?sgvWGMUM2oDTMBJcMuyNz6Xx4aJWzPt4QkaMR9jvRamOS571eS9xN4az0/cj?=
 =?us-ascii?Q?95eZYYLfzfXozOc/DR5/bM1XvQ0gl+Fg1TrzS+0luK+gb9wsug4tvawKvCoh?=
 =?us-ascii?Q?w3WXaZSmGdWhxHOulUSfpiwfScxErWfKmtVWowYDuNhmNkIRXE8WG7Oak17+?=
 =?us-ascii?Q?8q6iAT04ONpb/965JOjk4+JNQ3aebcZYqxg2SLEgISeQ9MdryNu9jg3ZGMzj?=
 =?us-ascii?Q?rvWlsdaBf9YcaSP6KDGiNgHSvwxf88n+uMRTeKzDzO5gtb2xnOovbbQ20B/P?=
 =?us-ascii?Q?H5CvEMWdaTUnXsaZ+rQf05qDVB+ydEcgI/6/8F9mAwstMrUe7pPDTA33vwjv?=
 =?us-ascii?Q?NkbfcRNIkigjMvC8iwZZo2DKiSVUJ4F+B+i2hxvEWDHtMHa91JXryDP1tRKA?=
 =?us-ascii?Q?zT/awB6Jy619z+5HeRvgJT1y+Je+7F3GBmn16528OBagC05O/fsnXxje87bs?=
 =?us-ascii?Q?+mbK/LupdQpjctOdMmKRB8uNDou5WHJx603TL6HbiilBFdyvs5u8jGy2RFOy?=
 =?us-ascii?Q?aw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WSO4XVfF+SPP6DQ5WZmX3q0BvV6VbEG8LO1NPNhdLWINfZvFvqC53odL+i58OcteVYrk39FZAoE1Ca7eyheOE6bwRfSTT7ojTgp0XYk29rQPtsbO93MBl09bCN6xmRcvyk61L8VlkDOiER1EiiiVpVeUpVdIGgGGfOymKX83EscWldXmgDUBnrTnK08pUo7C6VSFc0BzaBiAmFOsf0swrcnqfsIPvFVgL6oubiwijiW+Jum1Q6p3YAajIA6ialDqyn4vRRFDNYPtux5pu8PsZDd5iL1rrNHZCZzjLG77CR62XFleOvD/f9WLLN6yQokssJtDEKr7hz1Njgx8c7D2nrDxjgI1tgnhh33HZbmtDAvT1572Sm5uMznyscUKViyVteEBj9aeQGrJhtU4oKUqLT/rDhexzEO6xzA6Zp6/T61E08Cie8LznrRw2cWr0dmaxm0QCibd+4EiPiMoY1spiCQU8R39fl8XQI1T55fetnOTlEebAdJz/WpnYw5JEF2xfgAcyU0fWd9v41W0R0Jfqq0FtJKrI/GX9stfiR2IaS4LMZLjdweRKnEoUBJiTGxy/ToCuJ9XBCLUEli//doCFyxMpVx6dMCqBNratP1OFzs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfcb61a7-498f-4141-38ad-08dddaf509de
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 05:40:12.4788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RdwRN2MGD5LLsd49qUDqN8P+hub8fvrvRUV7f4vcc2rNSjQ7MNO5gXonbiH95ea0lvnBdCJLfTuzvCOD55NWn2OQtBOTZepv7KeFaSQpUPI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7832
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508140043
X-Proofpoint-ORIG-GUID: nrGp1dj1ZBlyPkuOYgTOflvZrA6H7UrB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE0MDA0MyBTYWx0ZWRfX6x1Dnue9AD6d
 cAn5re5IqIKDTBu5jJHNdGQ5RovwRTND048G39vZq1KAg6KqZmgWiubSJ8aiUPxrTNikE5FiiVS
 HqWCL1UWe/16CWE9QJWGCVX2ipwvytAAwCuj+7GCaV8e3PMxwT7T5NKETQACBuSAN5K3DR3MTbk
 L1dw1hU6gf9PN2DlgCQcyhMmWHjLxm+ShQIelTi82kT1NsUDdMTwV9uF8BJwi56ue9HgQemMOz9
 cAE4hxKEriSZcEbXpR+RH8VXt6KgvHtAIHB0Pir82PAZsXkpXFnsdWZjgNrYb+pSQoOqkQFM14V
 ZesyUpACV6u56913rtZo8NbX97Oe3cZhLv1hTgkK6XzgC+vNs3/QvdsGpkulrfw9OXEDHBlStke
 lrtBFYcqopeV5JXoUNYRFqjxvr50LvK9hg16mgO/WRFG1lsPl6sKaK9KitUZi4FqRWlCao0Y
X-Authority-Analysis: v=2.4 cv=X9FSKHTe c=1 sm=1 tr=0 ts=689d76bf b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=Z4Rwk6OoAAAA:8
 a=37rDS-QxAAAA:8 a=RbcA-sRVA9sTYJEJ0lsA:9 a=CjuIK1q_8ugA:10
 a=HkZW87K1Qel5hWWM3VKY:22 a=k1Nq6YrhK2t884LQW06G:22 cc=ntf awl=host:12069
X-Proofpoint-GUID: nrGp1dj1ZBlyPkuOYgTOflvZrA6H7UrB
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A565A1C0002
X-Stat-Signature: rjz5nrsq48zaieajt5n6ji9bpfjjmfn6
X-Rspam-User: 
X-HE-Tag: 1755150044-62669
X-HE-Meta: U2FsdGVkX1/Cnbw7v01OJn0QUcZrZ3XqdoP3KRbBE9LJoCZXwCOOnfuCvxn+N3rGiBTTUjj8QqapAEsijadsoWhzvS5tcg227EGTzutdeLwW8crtIzHWs3MLjI8w7XfyjJWLek0nwiojUuegMJRAr6GFcYGTRbhz0cndi2CKZ1NYvuN7kGG3RqN+JMKXNmhcQBoivW9ReQryI1uKEh5ZkU7DxICa4deBxW9MA5caB0b/4O9Zj0kB18aUT1P/YVyB36RqptjKggs1DFwbkanP3+0m+RQCBzmb0i1fR+RSRt/q52arRGVdu9ew03K0vR6netg8ijYrDcfX+w5kA7EhLTyqzmXZpU4ZxIR9XwzxvBFByzgSdOdah2zUdE30NwgavYjetrsBeldReo3B8wzTRgTS6C90PqYEILuKqT1QHvr4c2qquaV5pTfhdMthtWrNni9Ben6D47PMOZsPWO3r/TJD3LJHiv+fQSsc11OyMJJPBE6l+YmFP9LRs8oBqR6NHtVReQwe4EeOMdvNqpMI2JsbXe3stAdxOwifHIJessAY/o8LrEKbz/X/3Qf3XpT1KxNlpMhR2OS7b8V9yKKDmjEl7suJfvI9X+MbWleg1OF6Lpx/4eZ77K7+9A1IXOedS8LT5cyzCzVi4M3xgOMktKzDL4GohRkTUOG0qJTLyt7rMxN+L1/TPDWLUX1nOioX/wOm49X9DDe0V63mn8ZHBD27nrysLGukPw+3zaVPONzrBVx2MaY5+EVOy7RPOdCRh7/jOGfyNPd1tNROm4AIPEIvRhLzq8ylQBcp3robFJWM9BTf2wXbS+PUs4Rec0E7z9DDXdy+smz6h4a024BgYvHcEDyF9qa6VEfAYXiMmEqKamotxJf8l8UpeQwTLoKHej+o4nmT2k3by6e0bYvbXzFTg1D3yaB3r3tmnHdcOQobx8xwE9pUhCyh8qi7ICm62nnClHQJpcWgdMCR00e
 kfq37ikJ
 f6wE+aqDuLXLO2/T8qB8OHv8eoRyEQG8Bl+/kg3l9cWG2exQYGOIbA8c4NYZPX3WfWlSLlnZ6IqxDQVruwnmKNZwm/+XbmBQ03acAGy3iF5nag6H6UoBj7HExPfRwCDtg1B25sjHZEi9pagNiSZs/Kk7BuXUxZptNErhrMJMM8M+DEjq6obJOhCdHT4vKrRsYDtWFeyLgaqgdjHJrMsvH3kljuRHubBpVldI0U6TblMxKlgMWUycHzrPLjffNGnH/23ldb0gGWPkgyvUd320Dp+luBMs6XB/VqEbR64ljGl5rXYpksYESfvFUjCNNnljSyLvpvWLE+ZdKPtzY16TbsrtZFQ2dpcWjzCy6mVled+2mG5gIq+b2xU7IQ/NVMFA23DKNnbN6SxyjqBTRrzLUOBwnqGUgF2g+Os4la5hRyyYX2iLieFVn8Kcg0aWgwbrK1bPj59S+nXOUHh6LUMkGO6Shoi1RLm6bjfOvi8j9ezxXZ/LR9bTykwgm+IJjCOIl9fwWtJZS/YOsCJQVjhd33KNCK4lWopNGbpvVO20jDT/6AgjGJYXIqLePNeMO5B1ZMMusWfpcdotUQizzjzxotXFzqEp1OYcCLreLWoCIGGY4lJGOTV1OuT6bFGjtJHTJBXlx5YShtmOcrko8qG8/XUGf9R5g1iRjcNA2c6m/WrD7gwrfRfE6EDjNRQQjPMQpVMdUHJ7T2nXzlQDQ3pbWzzYmEe6QEnTUXFS20PKNMaChARs+tgcD7xxfsWWuIWZuVAxC8V0fSY8iBMSP5xe1tixKpYgZMh6ow16Zot8faeOlGsG78RNEBZL7ACAIN+K5YaMoyhAX6cqGuuxVBC8eozp8Wdn/3sU5sDHVoZe8P/NZZ14=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 02:41:45PM -0700, Andrew Morton wrote:
> On Wed, 13 Aug 2025 13:03:42 -0700 Axel Rasmussen <axelrasmussen@google.com> wrote:
>
> > >
> > >
> > > (cc mglru maintainers, who have yet to reveal themselves in MAINTAINERS)
> >
> > Sorry for that, I took a look at adding myself and Yuanchu, but it
> > wasn't clear how to represent MGLRU in MAINTAINERS, because there
> > isn't a mglru.c, it's bolted on to several existing files with
> > existing maintainers. Should us two just be appended to the list of
> > folks for vmscan.c, or?
>
> I think a separate MGLRU section which mentions mm/vmscan.c is
> appropriate.  kernel/fork.c gets a mention in three sections.
>

Indeed, it turns out you can have multiple entries with the same file(s),
which turned out to be very useful in assigning the covers-many-bases
kernel/fork.c.

Having added a bunch of the newer mm entries, may I humbly suggest
something like:

MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
M:	Andrew Morton <akpm@linux-foundation.org>
M:	Axel Rasmussen <axelrasmussen@google.com>
M:	Yuanchu Xie <yuanchu@google.com>
< figure out any appropriate reviewers here, if any >
L:	linux-mm@kvack.org
S:	Maintained
F:	mm/vmscan.c

Placed in the correct alphabetical location in MAINTAINERS?

Cheers, Lorenzo

