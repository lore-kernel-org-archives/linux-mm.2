Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE7E4D3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 09:36:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035D96B008A; Mon, 29 Dec 2025 04:36:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F268B6B008C; Mon, 29 Dec 2025 04:36:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC5FA6B0092; Mon, 29 Dec 2025 04:36:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA8856B008A
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 04:36:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 696A7140D65
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:36:13 +0000 (UTC)
X-FDA: 84272002626.25.711F414
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 24FDA2000B
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:36:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GbfNvNuR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BrSMKBeo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767000970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LS6wvHLAUwM8CJGOBBtisP2y8BV7PC5zA6y3hQYf8oE=;
	b=3gEQ5p5xOpUKEYxJD36cSKl9PmOgknxAqFYNBldeUBXKGfXfpimNGWxy5hBHaJDAuEtBrt
	pYARCOoOYtpEioX1DmG5KMS5CZjzFhP3w3ZykfN4fobKmPug9ohDkX3wRf0Zek8J/VmIx2
	J2+4zcCxK3zTL6BoZDWpBhgGSmTBNcU=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GbfNvNuR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BrSMKBeo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767000970; a=rsa-sha256;
	cv=pass;
	b=fvEJVpnb0fNUz5FnW9fIT1O4eGF93vuI0zhvoUJL4/vu/paKi1l3LAsz4l+AGKGTFdwSd0
	VhEZV3TFUx/E9f19LIFR7rgggWMxojGJUVdfY0JvK6H0ZuMIB2Y1MslFU4jcUhGR2S3YPS
	tYKCopRCIu3mDBzsu4h3yClVaF+wFO4=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BT3SEHg849467;
	Mon, 29 Dec 2025 09:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LS6wvHLAUwM8CJGOBB
	tisP2y8BV7PC5zA6y3hQYf8oE=; b=GbfNvNuRmd+PD213O46AvcjVn//OmCFd3j
	fEtKe/oiy6ROSHyul681+VmwlbpRZA5t6FuOfZm1fVyMzVeHkRCPx8eHgMaJAoRE
	42lYo+fRPhiDMXKDVqz7jpOym1P42ri7XMySgNeSSVv0JZpXjl+oiW6GH3mh5qEq
	gNclMm3UXCS4rxQa9imNV/kb43KX8bRxpmceMQjWp3rcmEnOMCwYRdfppjG2ve3J
	XCxttgccRw31Q7po90ceAD31+1z2l/yPlnwDsVOe79jUNfVTtv58R3VCKO+3lSnc
	ibPwzad8r8BZkHVx/P6hNs6M7bxPfWWZU2WzH9quuXiQOPcfY07g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba80pscpy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Dec 2025 09:35:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BT95NJH003799;
	Mon, 29 Dec 2025 09:35:35 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011063.outbound.protection.outlook.com [52.101.52.63])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5wb7w6e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Dec 2025 09:35:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LrkLvuQsMgclEd9gjohb35dkLJwnCtmVbjivOgVE1jr+P/iebAka3V/5Vl+LmzlTvl5ImYbms7CvzBZcSawjigarzbIvOl4yN6tdANqCO38QEXqCR6lOxIH3M3ZI/og3490dTKjYEH8796Itmq7v3DYk1PRFkliW+EWG4W9kcOtwfdwmb1cH9QwKC//C4/z+qm6sCgNSjapUUioQyupDBVglZfw3KKsWezRKSBKu5DEMz1cozqukYHoXcIxhrXGDwM28o2kelJUFT6L6mPdAQNqdfJsB1EvkGpA/cpYYLvwSADIsOMWO1TSw8MHgweRrIGIoZCfKd0q8T8SH0AqAVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LS6wvHLAUwM8CJGOBBtisP2y8BV7PC5zA6y3hQYf8oE=;
 b=DrXGh0IFCubR138cY47KJArYjO3k7iBjKzJzMyhY+W1PzkGXiDCjUemBhTPKCXYbDv/cB4S6a7LU4W82EMVvwbbInaBTQWkky4D2YxhVwmkQjeyWdEFJkIuWhA5gRMET8A9XK640lFsGJI12mbdwjW+5HRaRpuBQd1rP7U9Lk2+12Kae6vmffGElSwjtObJWXARv427QBIuR9nUtmBWM17PD7T9OEAumy3sZ/CKIe+eRiZn7hCRCKYfiu8apIOrCZW1oTqFTGKKyZV8iv2iDCTYoLiRPLMcBm5X7oioQkTqu6B4hdnXCWJU1msVuLzrGp794buYZnYRdRXobJbZQ8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LS6wvHLAUwM8CJGOBBtisP2y8BV7PC5zA6y3hQYf8oE=;
 b=BrSMKBeoRYHITWB8gZCuc4yQCs2fvRZlpsW4Uiglb+WJccTBqC6J5GHcpLDNnIRqx3FbbknuVjpvQ+CWUdQ71GRYk5GvSWATJnJ3iO/iNlIUIDWuvhdqFZBD5uy43CPrC3bUXG9fBMKCowePtu2rNwv6Ddcn/km2TnDSK9dt0Xw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA0PR10MB7383.namprd10.prod.outlook.com (2603:10b6:208:43e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Mon, 29 Dec
 2025 09:35:33 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9456.013; Mon, 29 Dec 2025
 09:35:33 +0000
Date: Mon, 29 Dec 2025 18:35:22 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>,
        hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
        lorenzo.stoakes@oracle.com, ziy@nvidia.com, imran.f.khan@oracle.com,
        kamalesh.babulal@oracle.com, axelrasmussen@google.com,
        yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com,
        mkoutny@suse.com, akpm@linux-foundation.org,
        hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
        lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
Message-ID: <aVJDuObeV2Y99em-@hyeyoo>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5>
 <vsr4khfsp4unk73a75ky7i35nzdjqsbodyeeuxipu3arormfjr@awi2srdwawfu>
 <1264fd2b-e9bd-4a3b-86ad-eb919941f0a4@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264fd2b-e9bd-4a3b-86ad-eb919941f0a4@linux.dev>
X-ClientProxiedBy: SL2P216CA0198.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:19::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA0PR10MB7383:EE_
X-MS-Office365-Filtering-Correlation-Id: bc8ccf2e-5eb8-4eb0-007e-08de46bd9cc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?beTgHoPcZ1Ln4mlb01q+bwnWvkLWYE6fNo9S/ahOydy7C25lcVnBHNbxrJKL?=
 =?us-ascii?Q?S3rBdZApPIMDQTDgNDmV9HaMxtyPd84pzyGzoL46VkAUZWRt3s1zrQz00KFA?=
 =?us-ascii?Q?Hhf5lYi2JMSIsrXcf3CziZqJziSqngTOyMm3M1tqH+tusLGdrM+S7DzuVtPX?=
 =?us-ascii?Q?vnYZo5JdTLNg1HJxuAjIrYJyP515DeAp3ekjU3Cq6b22TTXnmzfZQZAG45G7?=
 =?us-ascii?Q?Ay58g47mf53RttQMMOy9oJhzP8Z4egWTYI1gNUFk5gkpQFWH+HXTbNYhE38X?=
 =?us-ascii?Q?Xwknu0hCuxTHw2q8WblWKGKoCc8c5eofJBWGnMXcCJUccjEIst92SjCyCscM?=
 =?us-ascii?Q?r8FfAjnlAwiXZYl+3L4hKnbmiMbLiLF0jzyGHxXwUgG8VD27+g5JeE8ZgPi9?=
 =?us-ascii?Q?anVw6+FBuwSUo7kToB6CGaBq1GokLy3RshBQQ457ZuU8IsTlZReNOsZ4PvB+?=
 =?us-ascii?Q?Y710ojo6VoHQGl5MicjOrpcy87lGLWdhcwRcFw/jXT44Tit0ARLReYSg4Y5r?=
 =?us-ascii?Q?ZK6ZoZygjtIkkRw768v+hBtW66E7qfodiaJf7/SPh+kHvnB1/29dkl5ufz8W?=
 =?us-ascii?Q?4qFfy8a5HzsBIadCdio35HxlbgQd7r2RAKR7SwiBe5X8flJ0LtGev/WjBgHJ?=
 =?us-ascii?Q?z6be6qjKXJZSZUVMc5n3uW9pzedP3DxBL2O7Swog+ykDxiHwba+KTxVj2sd8?=
 =?us-ascii?Q?rXGiKlJTR32Plm0fwd9riRrdL6X1gNe34zSQ9p7xOx5P7XqDhBaIseMvFD/J?=
 =?us-ascii?Q?2oyQDNEQK8tn+rF1hkto+grk280N6l7yGLIyASduiIyrrFKIovv3ePd0kwTr?=
 =?us-ascii?Q?NZdg1mpz2yV5DXIzybKlScu/w99hk0LEM7ZlKbhkfwJ8epjiO31kVQGRDkPl?=
 =?us-ascii?Q?Fyf7gAlEHsGPZGGZ57KZKMSQqFU11DP3KiSptC2QeviLkOp+v7ZTblHbcnKx?=
 =?us-ascii?Q?ZGUMh7bezSSv84oCg7GWBpK2uOLmG41PolCyKsK2cMU0QYDJNCvyO6rZ2kHb?=
 =?us-ascii?Q?oXy0uvXrzfkdvvnACOBTGdztPDOcxniSBhgelgcT6lCJBsRlLRoN0c2Cyevh?=
 =?us-ascii?Q?JmjnJRzvJPsrQkIFr3mM+ll1GPRii6VO+1SsKJaPBex4YTsscF9OWDb76n73?=
 =?us-ascii?Q?wZgLDn8eJpMu8khOk4fPXztOJYN22u+wfGLJBwgJU+hvyXXgYOgAQCYg81rK?=
 =?us-ascii?Q?Qtf0xijeA2XHPBXsXT1rNLnoZALpzsWcyO7wougkWzTP6W755rnmkgsAcrk9?=
 =?us-ascii?Q?gDMJ7ZB7rvuaiuUWjPJhBZeD0gySvBGiwmO+BmeaZvMql88rmG/JXbAhxEBk?=
 =?us-ascii?Q?s/nR56aAS1KlccyOeAk/Z3ZxnBmWDIkaNqHGXShrf7WVXJj3/vN+udVWaVwH?=
 =?us-ascii?Q?LZqvgMrWE+lPR9YnHIz7IwP2ZHliNTxBtk/FnJ+Q15CNhPOMglzn1razacoS?=
 =?us-ascii?Q?jA50qCnSOqrcTmEdoqUFb/ZwqK3SL5ecy58gH3Umpp7WOQSE5cUiHg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CQBHbEI9kq9E4mX3KR459rG/RcFXEg6TL1fIzuTE4kh7PxUlPmGX+R1ybu9s?=
 =?us-ascii?Q?otFxChRypXQ7vI7qm/bb6NgdhAKSeKnDuhOcJp47Q8VnfFZciTqkLu0nZkle?=
 =?us-ascii?Q?uLHqIAmjM1829TMi3mvtf5tJ4fyGte8DSTjhJv2Y+7rAL7JBTwtnko4ULVF4?=
 =?us-ascii?Q?sop8vnyY09qNID3nnxngOP+FeIX3h0SY0qRKLXsQE/JtcCLvnj0QqBGQ7Isp?=
 =?us-ascii?Q?6K4eEc0pSbD6ch4gPJJCmm6vrlB6dGv+IzQnkERHG3xBVGKJuBl+WxSrLajX?=
 =?us-ascii?Q?M8H49NJzDeiPhSUrZJpHhzcfY9Hy10ZB18DKWyJimeC7H6itgyigmC+xRd2N?=
 =?us-ascii?Q?ameYHgc7dVmKSN1p9C6VPYhCgfDvkWOulFFgXSpI3Gw0vsnZEf+JrYpeYmhG?=
 =?us-ascii?Q?su/FC5E8L+0Epg8VVftnpFSpmPD2bWvFatmz9bs203oghN5tHUwMunl7Daa6?=
 =?us-ascii?Q?+APWfmJQrNN/MNc9jsnZhunbmTKW6ChR2zS6RdJ6pdS6JdRPJNzqDV0zhQA1?=
 =?us-ascii?Q?HOtFCxl6pwq5TXmki3cbaPpL9P0grtuo8HKIUSf4kJUpklKMYF+eynIBpJ/i?=
 =?us-ascii?Q?su+1lgQ2dBmP0+5jXHrYWtGQ+ZFpVVJjnfsQbie7rxXuyqRC8/FchtYJVsgF?=
 =?us-ascii?Q?Z7ECvHumtzHa5lOLGcOshdcfK2f79oMFXin5HHEDndtfIDb7GHlplOEL4mrz?=
 =?us-ascii?Q?j1Q1S8Dc5t/sL2CtylSmoys0ksOuCaYGCaLfERn2ywh8EBhEl8saK7/gY8jf?=
 =?us-ascii?Q?BLX/Iew5RSImWvFDunAu9fcbSnn2q5WsrJnTylde0K7I7iOMRdq41LXgVOu1?=
 =?us-ascii?Q?JVa9XPXFN7PfgLpFzrpT+xIBjzE0+ZQIkYfZNVrRC8MhvCULPgB7gsVydrIy?=
 =?us-ascii?Q?cVfVqFwXuzvbmIX1m49TdfpLYfZNUuXriTDFagprPJz/vkWY0dlGHoShQCde?=
 =?us-ascii?Q?KEIycTLnXDQKdmdOzJ21pme6m7+oCTQ2x0iGm69NFIOFEQQNkWYB3pOdmU/P?=
 =?us-ascii?Q?u7YUzjb4OH6Lw/p/jrC8Yg45yDGq0wApkk/7ekiuax1w8+gb07k6m0dOEBlB?=
 =?us-ascii?Q?1aT33KoehtXcWwTt2UEM43viEsWNdYCrbEssmo3tWdi9ZVWKnARa5Eccc5Sv?=
 =?us-ascii?Q?VRhD9EirSl/80QsJtt8C+qDJqP4KZeh6iAV0dcYdziTKJRyZB3QwiHXqMEXE?=
 =?us-ascii?Q?4ghRi3utG6MeW4w43qPsBXuWG0XXNDAvh6dZpjt3+legaKQmYBEATZ3T9Mx2?=
 =?us-ascii?Q?WMT+XnjKLCWfDZjYSxSJooC8p4F4OVO4qRfzmzoE1VFVcu7Sz8Hen8t7p9/h?=
 =?us-ascii?Q?a0dkeFpz/4vzPDSiQI92kXekOJiktn8eNRLR3/R0JnR2n+PZ/RF9MUnXkDvg?=
 =?us-ascii?Q?asFGAV/9Z0KLja7eskzv0rWrZdE6BpYbj7mn+7pJ+P5FtnFn0vtxH98eROSA?=
 =?us-ascii?Q?De/W8Z1ipLoP/cz0vEqCs91gWoCiIBld9yUazaffNYQcge9AO3N9R7H3Uyo6?=
 =?us-ascii?Q?1QBC4uBeFcDT0lA4Qtgi14EFdTq8NGzfoia/T1Tz+qyGdThN3846BIlYol3K?=
 =?us-ascii?Q?Fog7HjjJYN7BYmugTPsAm0zi8NIn9C1Ihu8k6TQvE/azt8Uk/oSjeBFcM28q?=
 =?us-ascii?Q?ySTuuPNmJHW2XOm1v3erZJl38MhEt6oMhXQb/24DUCBsvBnsGF96p910yohO?=
 =?us-ascii?Q?Do9y8hd+myCuxJZ3ZqODpFK+wp3noAUgN0vxHYnukmAI0deuulBqrlJNotKb?=
 =?us-ascii?Q?UsS31rGRZw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FzK9HguEDhIW743JJhjvOehuGjC8AgjVzMWNDDfe4fU/vGyxR6YDZf7iRHr2YWJgekh348JHGauXt2Cs2jKDuyp9gFVu6cD6OfdzANW1a9gEVbY/JqUBacXgr8RGwLOm/bp4RG497dUCFE1VQ0WWeFrJL3cJfN+Hjjqe7FNkLU3BfewTw0A/ixMkBSCUTvODcKXD96GPGw5RHZ2LAA3y14+rFINB6gc1dhWLoxiNURsN1zUBhhYpjpJUNzGR9wUfw0jf/1Al3v9j2mqsRYyynzSzmeM+YOErylhr8ovWrH494KDPXLhajWtYs2PT9Ke97yJZ2rirf95jKlJZ/fnx7JL49iu3e7MVWnwHTRviSr8WNzeGfCb6XAhVvKsEDNNCYGV6LX4X+KLtLqHcX3rDCw7AC74o3AIFbLBOL3Be7zRBIcCK6S6fx0Sv9ZHugTpW1XNd1YwmYeJAyNO4TRRymtHJ8vnZ5q8aEtynf7yN/ifBTbaflFacVdpqBquBMp2K8S6Z0DTkV8Ua9oabjQqCOO8Hp9lrOZdv1zfk8E9z8h/TK6JKaGjUnebYwiDJn+1QQs+rcdG+qkt0Wh0PVqECMaGPr8XT2ESwSpqlqqBq+xs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc8ccf2e-5eb8-4eb0-007e-08de46bd9cc0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2025 09:35:32.9248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +0lwDGdb6zOI1kds2INDj2PWOIGkmeUlFwkKDKijiVtBbeOUsngSA8ZRwywAXCJOWNHr7BZZibUO/AKdAZk3tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7383
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_02,2025-12-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=983 adultscore=0
 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512290088
X-Proofpoint-ORIG-GUID: 8-9crjta8qmcmgxZ-3ueon6C0UeIYgv0
X-Proofpoint-GUID: 8-9crjta8qmcmgxZ-3ueon6C0UeIYgv0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI5MDA4OSBTYWx0ZWRfX1LhPsh7xmXPR
 ONscNwb89XbgNCObl+EopsOQFZmBsjtgifFULXNbiekzojqZPEv6qpWM2nKN1Of+Wf9s7NV6r1O
 /tYobPQ3QyXowpJsNZimf4nHCuF65v7rNE4rJLqOfFXf2yMpKO5yZ4Wx1Q8D+L1Zw97ZiulU5Nr
 9kRiVwmLlfUNlvVL0iCORnNUVauD2SE7CvK8sW7uEFB8DNDFNh7i31557NCC4UXSS5Oe1rEeHgt
 n7xfEs1OVBolg04XDXt9j79X+9CjrU4vyujvoZqrBGalw/ogGC2VJn2oBS6zfK7lAc4LCuJCULQ
 s5r3YiySfOUJXTOlIP8ZLlWuy3k8IyoBNWFkqcM9E/TPpNBExHxQZkk19/woT5j/abcNfjpE8Aj
 q2IxnviBNUT2fSVDbzNoOpBCxpH0CGDyS5xv15DTXVByqppcCX46nAP83eRV6GdpdrGwbzHiPPo
 m4lrJ1fOOaUQ1jAqpLHx4LSFPZyxzyb8nc/Nj4iw=
X-Authority-Analysis: v=2.4 cv=RY2dyltv c=1 sm=1 tr=0 ts=69524b69 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=_nEdYcyGl1_pypZuoNUA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12110
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 24FDA2000B
X-Stat-Signature: oammnpywurereqkid8icg5pautn9ro46
X-Rspam-User: 
X-HE-Tag: 1767000969-993848
X-HE-Meta: U2FsdGVkX190wN8YHeqA3ugsONoUZfGpxAlNRP6ApFQt8481mIPe//2iZ7scblm4RBF9svyoK7SccFnjkEBpGSkV6lnvvGaWc6vbp5B1hJeNGikY1vUAl7TaibSR9qZAj6i3Brm7Jr2FhX56BWaxGg9GnU2aHQjgEgOL5nwjXnCVE3Oap3yxDZgK2x2D+wXxwdAJ8a3kJEEDQNRAhbF9ymzCPwTyfN7ns51T/lymt+QGUQg+wGKCIZXlZPGjE1bZ+j7vdLpVA3SzlfZL+rYVQ9S9Z7X5jgEhie2q0YUMQZL4CUgao2iWoGupMshJPHsc4d2UghsDa0Pi3KF7dyqJpW3rjVHQkEz6ZXsz66Psza/be/PjAcluy6M66jPDPIp0mueGRXaoxrsiK0h0IbwanelKLdjqofKtChMhHW4lf6qajlAWPqhOXYWsVmGUkGAr9sZW/Pzm5QlB5h/3saUZFpLvLIMc+oe1eDWln0/RTzsNxRSQlB7I5aYBYtI1wlKO8j1tOnzebheagNOl5zfofYTn3w9xYnHs49Y8ySSG5Cm+EH8tFecrp3dXMTXMZCY4WbRcbw8prmnSeDh7B91RtPXVBP1cRXEXPh0i1Gw3LoUjWR+MF+hi1z4WeiAU26cV5Yni0FqFtAMeYpRrUn3BLktgck6NNOtyacyoAXdeeeHZ82pchPhvUQskO5bdVUcjahpIH5jeUqdunuUleEn/5UpurzflSDEuVa3FZAgsgepQqAMuO7E8ZLsk3chb5Cl62amR8tK9PW0JpB2A/+MKerabdj17+aNfctYopbeNaMMHL5LRtNtzPzHdX6bRKbqOPFskEkpDEPs/ZkNTI01E/Ffzcd1DneMX6YRuwXPbcS/pgLmiROgEeJeFfn2zHqIHy9AXzmcNR+dWphUU3VjR4S+1CkY+cxSLLdoxM+j3wxRtAV50GOB82sDEDvDfu28gHyHqD3OuBYLz8VdG/ex
 Slm6uXFr
 t6l/BDLQ6ZVyQhn6F36qzs7eVkcMc1ODUD8xuT/+3FRyJC3eDBOr3bQ/FuJtK4a0AYSNxVP26j43y5+U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 03:48:26PM +0800, Qi Zheng wrote:
> 
> 
> On 12/24/25 7:20 AM, Shakeel Butt wrote:
> > On Tue, Dec 23, 2025 at 08:04:50PM +0000, Yosry Ahmed wrote:
> > [...]
> > > 
> > > I think there might be a problem with non-hierarchical stats on cgroup
> > > v1, I brought it up previously [*]. I am not sure if this was addressed
> > > but I couldn't immediately find anything.
> > 
> > Sigh, the curse of memcg-v1. Let's see what we can do to not break v1.
> 
> The memcg-v1 was originally planned to be removed, could we skip
> supporting v1?

You mean not reparenting LRU pages if CONFIG_MEMCG_V1 is set?

That may work, but IMHO given that there is no clear timeline for removal
yet (some v1-specific features have been officially deprecated,
but memcg v1 as a whole hasn't), implementing Shakeel's suggestion [1]
may be a good option (it doesn't seem to add much complexity)

But it can be argued that it's not good enough reason to
delay the series; adding support for V1 later sounds sensible to me.

Anyway I'm fine either way and I'm not a memcg maintainer myself,
so this is just my two cents.

[1] https://lore.kernel.org/linux-mm/wvj4w7ifmrifnh5bvftdziudsj52fdnwlhbt2oifwmxmi4eore@ob3mrfahhnm5/

-- 
Cheers,
Harry / Hyeonggon

