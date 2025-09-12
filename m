Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80B33CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E23FC94000A; Fri, 12 Sep 2025 06:48:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFC04940008; Fri, 12 Sep 2025 06:48:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEB1294000A; Fri, 12 Sep 2025 06:48:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BC650940008
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:48:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6359514079C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:48:57 +0000 (UTC)
X-FDA: 83880275514.30.6CC652A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id BD73640005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:48:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TyJmhKaM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="dTF/LbDp";
	spf=pass (imf27.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757674134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FbAv1lA46EGTfLVNOwv30UMBOhNtokxKa3DnlczWnas=;
	b=5ffAbklxYi2+OxjIOEdLqge9CQ7FTcg3q3sMJADXYNezQMjgZevL3kthK9CqZzuul7Joui
	6TkziZwIkF/KuLnLw21u9+y/4p5Vz9wwbUR2RQtOWgrJPHgvOv4SnNO01NgLwGz2cM1rI0
	Cm+MCeMK1tB9ccRs8RGbB9PrkYufdmc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757674134; a=rsa-sha256;
	cv=pass;
	b=VggUI+BejfGLzJO4E1FnnUtvwiv01Pm+Lognv/yuHalKNACqK+rkXFHqly+k5i62qDJUUi
	64we1yIZFlC7+t94XX1fopcImhtMX/auEsJnUuegIHvNxMx2Pwc9cGVekcpv2PLkv9FVi/
	em5YATfozzHvN38wSbLFfFQIiTyHFyM=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TyJmhKaM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="dTF/LbDp";
	spf=pass (imf27.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C1u6QI009704;
	Fri, 12 Sep 2025 10:48:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=FbAv1lA46EGTfLVNOw
	v30UMBOhNtokxKa3DnlczWnas=; b=TyJmhKaMAuZNhwiSvA6eHPZmY2Ym7IpA1N
	K9rhhjJc6ohJk6ywOpUCF9kKeSjBTOYWYVIiIGos6kTR5r4Y4dAoLdqQ2LY9Ru5r
	zwz/gdCOoZxH0MoXoOZHPTGetwbOb5c03eb9CRSp/Fo77j66264bOb780Zu+Ol51
	0M19uc/59Enblsw1v++tjeMCkmug7pA3CR6Jipa+sHZFYftV5ra3EqUgq5+hhnxb
	C1rPd2YiuOPrbqOIWndo/mwXRPOid1I7yM6D1kg6J7MHmB+bBU1jC6JPftdzZoUu
	FixsR2BsQqpj+y9bV9NakFAwjgWW4BcE1zmxrThUqeImwyNWEjLw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921d1r47p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 10:48:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58C8kL5c032828;
	Fri, 12 Sep 2025 10:48:47 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013003.outbound.protection.outlook.com [40.93.196.3])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdepdhf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 10:48:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vzWHoWYny1v7wSWbA7Op+k+ETQ1wPiPpEEju3qbobe9JJsxcjEc5cKKaquxYnlOTlk81V4IhzV5wr3mgpBUEtpLB6aXXpsUdJ9rZuFpJYBahqC01QFPfVT/NeSZoF3Lcyv5vJOfl8kYeGmUk6M5xaql/h7TKs7NMm2T/fHjwIgYTbVUh20Bi9HfjDY4d3C0bcSBDTNgfndWfPT26y5LeiC46sywQTX4zEHPN1d8dVwNv08fZgTdPd/mJMrnLgJFUjngFRXxiDNJgh8+pPwsKOismTnQizOcP2tCXjKx772ZcVyVVFRFlBfe9r2usnYHColiR/ijmNT9cxTChuORlNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FbAv1lA46EGTfLVNOwv30UMBOhNtokxKa3DnlczWnas=;
 b=juBYQKYP1VGCGKg9ifPb7APqUf7nnEQCwBUxR0TnfPc0MAPzF8yZjVAam/8HzacMfCzVrSInNdywnLwozy+GK8kyZQ/Sc9CIQ2EtsbVsY8o60dFLidgR38CH73jsYFT/bYJjIY6QOi/1ikL3XI45sjoj30F8yoE4dWZbklgnofMEbh5A0gIyYpPyHYNtZw5H5742HS21ecotybIpprFSgkFkSKHDPRwaE1PeYaX8IVi7BPYFX4XvbKHCn32nctCt1TiHKR/9PABMYr6jHZt4ZQsVawGXNMTlRm1KKUuuRrH+lV5zaNMKUeSsJH76JgngD3DDF9MveUttWlH2+pP5lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbAv1lA46EGTfLVNOwv30UMBOhNtokxKa3DnlczWnas=;
 b=dTF/LbDpCN/ff5bAMnf2LH8kMcl1oHUd74xU07UmJPUS5StNRoFqW4stTs7q3GzxmFkT0EI5XzitEkEo/rsZuuIRuO3wPuNdo5Q5cZFRSEiylmOW97k07+oCQtAjdRol0hVQ29G2QjcNpFNbKydHcW+mNhZXsSHpYHCE12T5kEU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ1PR10MB5979.namprd10.prod.outlook.com (2603:10b6:a03:45e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 10:48:38 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 10:48:37 +0000
Date: Fri, 12 Sep 2025 19:48:31 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] slab: validate slab before using it in
 alloc_single_from_partial()
Message-ID: <aMP6f_fJ27flhdSq@hyeyoo>
References: <20250911-slub-slab-validation-v1-0-8b67eb3b3dc5@suse.cz>
 <20250911-slub-slab-validation-v1-5-8b67eb3b3dc5@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911-slub-slab-validation-v1-5-8b67eb3b3dc5@suse.cz>
X-ClientProxiedBy: SL2P216CA0130.KORP216.PROD.OUTLOOK.COM (2603:1096:101:1::9)
 To CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ1PR10MB5979:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dd3cfe0-95f1-4da6-c0b3-08ddf1e9edb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ey34jgy8p4YmhuQUu2Ho8EnSjoprd/1VlcroWHloEyA9KWLcWK44NDYySuY3?=
 =?us-ascii?Q?EbT0LKLfdNSFXEUcuXXxD0d9kGCcwNo2drApwZNBosc+y1p/TKxJDLK3e5px?=
 =?us-ascii?Q?qj6tPY0uejvwlmbQvi9N8ngAE2G+zcJQkNDmG9gwRMO7Xk8N8zFMZTJJI5HW?=
 =?us-ascii?Q?iAfHBtEWlXpOWZPgtUp5Wd0qHFcsApxNHY2iPTuvixlhstyDQff2LJIXdREH?=
 =?us-ascii?Q?IspaI6fizIjyrnjOJotCKoaBKEJSWr57uFkSmzAsmkZAUwnkYkCKg/9sDvI9?=
 =?us-ascii?Q?dUd46Y1V76EzOoiQ7/P5BIzd+4bNMtO5YVCcp8E7xinpcwzeTsAiX1B9EJDr?=
 =?us-ascii?Q?3yBydzlymGSu6ckiE/h/76lFGuc4EkNgIQOjSTy8MeQE7kZ2oxlIOihQZvZU?=
 =?us-ascii?Q?5BN9RrUu/m3eyL1gOkT3Eak/koopP/3ZcP/mckMJNPM2CXYDeqop2czbgCu6?=
 =?us-ascii?Q?5ibO0d8OvRUDBRmf+zw02u4yzQR/SZqeM026wdQokBCavdxNVtUN9P14VwdQ?=
 =?us-ascii?Q?ESXH7YtNesYhQn3lKF273KEemVrul/iRjG5KXObYtpq0Aqcfib2c3thRyGyC?=
 =?us-ascii?Q?APK4KKOOWwBG4dSlhBX869Z/vJopr0EIHDKlldEWj+JINqeyvbxKhsjksI36?=
 =?us-ascii?Q?Lv2TIlLGsZZeAuxAaOBDV2NuKD20hK75jaXxWoc7x9ejTNvNKYbbTLrwmil6?=
 =?us-ascii?Q?V6bZk4okSiPD6v3Bg6A5Tqmf9cz8RpMDkRZYfrIIdTuIE64BEcI1NwkecY1H?=
 =?us-ascii?Q?S7h2N1rg6CboosJM6WWylaf3+hwDWwwO0pn6nUCl1V9DMKLPAU+Aqu5s4c5M?=
 =?us-ascii?Q?bfS1wGZ9DMcp8q+W1KH2jrxp0SDTa70wcRq8GinWu0UYaoBvhl29Im76NpED?=
 =?us-ascii?Q?RiG5a71A2RzpfkP0u4+dVDSEzdKw2lVUHAd3BLotjRljKWGkkd9t/tHnrwKD?=
 =?us-ascii?Q?eNOuwAxpuYySX2aNhqc5WNMtct/jVpddzsbSMSRxwuBMi8qH9RueCJ0xrvzl?=
 =?us-ascii?Q?hSZxr6/j8rqgRrbF27+QinTG4JlsAHReYnvzAg6xf3iqWrJz53LEc3wLjwTh?=
 =?us-ascii?Q?0/2ZheLHfnXxMpCv6dkczsnMVynqciS9FI+Yo3O92Afbbwz9IHIUiuHmYuFf?=
 =?us-ascii?Q?ekET+yKTsrOwjYRXm6pTM+nitoUSqVh1ql2XDFcwpnMiiBFr+wumf9XMiJaa?=
 =?us-ascii?Q?v1qfoHI/P3niEkJW2aWStaHi6now1QM0TRf8DFg8UHD8pjeBZ3aNydObqAmp?=
 =?us-ascii?Q?ozKREjMBSCdHOtWgfRZcj/If9qDxSnONicwjngchO5kDwTlkrmXJnggRgXtC?=
 =?us-ascii?Q?Q7+1DIH6iJZ2DQVIMAa4gShfzYEilMjwBV3Fw259gFkCW1NN6D2GU94T3wxa?=
 =?us-ascii?Q?RgMBc2MQLyOw8Oz5yOue8W/z7Oe4Xr18lU5M23lOqeZhSJi3J1XvGtwexiHO?=
 =?us-ascii?Q?9J0NywSNitE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mDPOYgF+bCtpv2Gn12oVfzwn1Oj+9ieqnLw70ANqcsdf4TkMaVH0qYA9S5TZ?=
 =?us-ascii?Q?aTDsLLH3bOnNKCWJTawMnnaOJX2QHahB95tMYhzBYqRtrF37HGRzIb/gg4Gb?=
 =?us-ascii?Q?aUQ2BOk2JSzkfl2Z+Be60IdQM54HmxbvYu25FI23lmIThNfnB9GgYwYPUllo?=
 =?us-ascii?Q?0NcKruF1TkEZg4MtPofWXlqQ5VOFCnwk9QH4wsg7yciaFXCFJjk3u4k0coJQ?=
 =?us-ascii?Q?XBCc1lMCPGkzaI6EyeBmxYQHgjzANGW2k+MvOonOmwHVstobK0dtItr0Gyhc?=
 =?us-ascii?Q?Ci9gu2mAgDTwdFSWbUUrwsOgRP0HLZWzinWbF0xK7kwG5+CGkQHTMrXP/yPK?=
 =?us-ascii?Q?mCurg+8uINl2BUvWF7CV4gP7hZKd73NmobZ6SQwqHtLeFMynTTEgeLdUD1x2?=
 =?us-ascii?Q?+6RwYGC8FihVV/aIBzUVT9dEdWjcymbQCMQQFA+WM93JrekxkGpCJYLfVzCc?=
 =?us-ascii?Q?uqId15uGkAeKTcqayRS1cpZIkf6bHj6uvtE6tAucNZrh32LwCUDDIJZBOxcp?=
 =?us-ascii?Q?64QIh1tgvaLni6W2iNorZSajVvRnFsf/PYplMm3ZjP3hUcv2QULFV9z0DJXF?=
 =?us-ascii?Q?pudbEkmZMWzwGu8VX1F2S1JEeQunpsXebc5zCIuJV9fC4lHGmqzQOSzAiokS?=
 =?us-ascii?Q?XGFuxqcH5MxY9lXx7x4iBoE4IV4JfV5J/g9qllsYfPUmAZvxsqyUEsHnbZGq?=
 =?us-ascii?Q?HhoG5O5Twf2KFEsWP9rX3kNt0EyxjH7MBFAgZT5YrNWA8T9kORGEX9jb+So/?=
 =?us-ascii?Q?nUzhhTaiNlcQlOS3wHTfyfRwt67xScYCBJlJXdI/9kiIYQaaGYmaQEa0bltN?=
 =?us-ascii?Q?aDeri0+Z4TyicBYLptpn/DkpeP2szcbnJHLYe2iZLlfwnul3brmPa1MsqfMs?=
 =?us-ascii?Q?e9yOprYKxPGw9sXKMm9x1H3vbd4zKnZmmvLobg3ARjqOJ/ko+m9YlwZSRA3U?=
 =?us-ascii?Q?oI3CnT5jebSb8eVL+q+RtgO/iiUzvmwPNagpw7bYwLZ2nTVFBaH7QGfmjyWw?=
 =?us-ascii?Q?7kMp7tmJEocwO/7YU8ylYeZEbrVyW1JYOYrIZOdIerCN+NJG+ErYt+UwUJS8?=
 =?us-ascii?Q?nTlr81ihhCn0wAFNMLkkzY1E3y5j3BHeH90msIKIE9v8ZtJcqlqBa5E6J/8h?=
 =?us-ascii?Q?natS/N9cvzHpYAMDCMB6it3SrgZLSZna5DJejICuh3OqtzJ2IvYLAmIToJr3?=
 =?us-ascii?Q?yWddiOd4Zj4dYzM5XZIG5J7HTgVCbHq+fsJ5GUcXyVG+eWJO3HastmOhI80y?=
 =?us-ascii?Q?EKO+xYsyoViz/V/ai4fEMmTSyk3wEMgscHMx7FPpFIkY3oFYvjrYE3dkAEXa?=
 =?us-ascii?Q?nDdB7JV9AOsqkWNzmf9czb1H4hhpsx6BWoZOfkifSaKH0wT1Iio0FJ/976Vu?=
 =?us-ascii?Q?mi666dB+R8VkejtnjAnL4y52KJVT7JqSUPz8Ko99oBmRjkOcpY3UtDuzXLKj?=
 =?us-ascii?Q?qRYD+r4H3gBzGrZiA8ICd2o3dILAzSCrjQG0Q2T970bgRpk2G4gPhkQSbNWV?=
 =?us-ascii?Q?3TmkCGBNyGsCDr/1XA4F7CJoB9ixZeTDSBnD93/ONEttGooxZ2yuJcz68sAX?=
 =?us-ascii?Q?2KxLIqB/z97Kq+bKpMl0DU9DLN39CktyP5+qTYdS?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mqhq5SEXsSoSwBTBVKPNHBLGebktAHPUdlyVzWrQqL47AQqlMr/UxlMqnx1dSME51GcYWFTXv5tMfENirocELSTzY0mnc77YZ7Z8tj/FNbvMBz51LuFAIC8//8c3oorq9aIC5KWmUy+Qb7RF4q1J60arcL9Ik0xFtZaY139Nn1xC+ryf5losVyEn7YQly7CucsQz6icijmJL1RMaVbJi+Nb2eedVu24+FGFwNsOpSf8dTEfMJtlck36e0sqvps/9qy0ya8kH9rh8qiNqra7E6XZ5FEGOfgUHk2QOIDX35JoHV/5fXCfsJCn7/suEcuZlTAC3cZFmFf1TwywSwM1mJrVCdIYb2P4n54Oa8/ZHeVjp4cMYMUAYmbK9ZouJFFXqToEWftrchlG1pkgAHHLgpfuLe0VdqtPu1JzOws7agviCqTzzrk9B/mOYAB5p4NKg0Rsr00YEa0YFwslfQhYZC7uWUMHqNH8PBjA/R/IDYjx7/gSh3uM9IhpYTQBwkOtOGW98S4VXGi/QtSvLyH3652T7BYdztFRKGx6eDJEx4dLQ8uOtQ8MUGtOz7FSEW7rEzB/k9/b6WGf2oUG1qcxsD6Z9X7ToLgFwBdjtHHd/2x8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dd3cfe0-95f1-4da6-c0b3-08ddf1e9edb4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 10:48:37.7939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DYJ0ja2OfpP3BpRr3PAFbR1RXExHaThnFto/JvPAzfO3Fc8czPK9r75nziNIn0ywUOOTsySZP0z2gaiJWIOmoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5979
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_04,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509120102
X-Proofpoint-ORIG-GUID: S-YbzFGrGkTrN03SDwhcr8hgBz7AV_gn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MCBTYWx0ZWRfXwnYklj6yOktF
 d+zJEHz3R6OP1apvpfl6AXY4t3hzP1QnbAxwufbTRORgSxA7RjE1GHcZqpRmCQVjGIsC+eYAKFY
 aOtEtDxc4vydCVkEhHr1AKWSo2KuzGIa4TGkvrjpf8J44uh7M2VvbNX1mgQiIGFf8iZivQYYxSL
 Vjo+HmiN7qL2XPwA/iHFzLbg/Eec/POB9r9vZRzqiSiNUWmLD0gOitkVuHKEeRit8PMY+Zu1C2w
 gwAP+WVRy5gUEUtygJ0h9q6vHBP27tGgkeJDXp1L1slIVoIj7jcVh2SdK9m24gSnXI+r+UWwqmW
 DQmLqPTTk8/xx0RQ0A00+LiC5QXmDnMT38VZooJqJyDJb+7nFoo3xpZpQ/QdFaCXr0/xQgl3jUR
 9xzX+h6g
X-Authority-Analysis: v=2.4 cv=d6P1yQjE c=1 sm=1 tr=0 ts=68c3fa8f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=j8R8Cj29S844qgnthlQA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: S-YbzFGrGkTrN03SDwhcr8hgBz7AV_gn
X-Rspamd-Queue-Id: BD73640005
X-Stat-Signature: ew14xktd7eenajn4r3gwgk8wd7ahujnu
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757674133-284368
X-HE-Meta: U2FsdGVkX18yQet2NE78CMItjC6xpDbz3NEgjb4X6EG7YJRlYKiDOdecThFib4mgl9B4NCtHLxuFiemBoKpvBZJAoFaclyBmuc8e/8YH038hORjjdsBow81qxXkupUsomBnq4kniEVXzVdiO6LbTHLvdqsCZg3gltiOQVabTOHU4gerlUEwD6hicxSEzv5vAGhKHIxWfbqYDoVrWFA3Q86U8M5wcY/L9ohkvmX+CTcdSChvvV5aU5iCrZPa/iWVfoerW7V67wtM38Z9aDsanCY5N43QVtKJQfX0ej9oUyoZ22Jjb0Bmc1dGaNkGg/O7fleB4Jc+kgQoIoOCVN0EzGFWOuRwzg3Klrj7s/QnniBGwHx3x1R1BphJxgmrKwD4hqWBxYNHmX/lxLhfQsQxkWySCn3YSeIBQ7mV+75JPjngWq+1qLGAZyvcA+UqGwaCKA3DOp76y2dO2pnYf1rTmDGCgJrHznPcb8xVrDcH4WKeE5drDoHJJUv70rSdq+PPHf7/PhCqHgixHZ2XyHJVphPmLWM48LivJJOUeqaTqz/ZN5PK2z09dJP2WU2gMTWS0XELEOsk/8sn3oQc+9R2iuo6kS5CBaBlUbHAKsefHbJpkKIwgNYXZcxyFw/7ug/SwjXJCw7gXg4pV9sY8+UROdITmvSD3ba3ud2y6gb4R1M81uhsb0LbnkawhF12ClOmzJvxTfHV892saK3A4rer+P5+53tCnWgzwdQSs1eMRztvhl1kg/tXa785tMfYGEWqlfvp0QBl7RiFJmWxV4e1aNv0U8qlBSvfmXGl+bs/k87OEI30vupTRef6Iz0Vu0TeaFAIm6QaVS+ryfNh329qSM/wk+hi7WYCOsT6J1YWbCF6fUfL9vQFtAjoPPTcdmlBpHfuBxSbeD9DSAWXGWcL/B9jgWF2+LMDn9FjUrCURBMPXzMby9fFIRLJ0ukPMwq+SeVp/ERpKqjEgT/xDr9e
 bHOrDY/h
 Jcqs8gpvc1MnnfKBEka6sUB7lUVSrWr5ID2ls1QNXATOOYX438+1b/52ux8xlVOiXEeWQ0L2pL8xbbJbIsnPS6h938CDOgv5aMdmHbQheRLpOsnkIomFjj5Pq2CAQtk8GdI1MogYhQeqP8lwACB0saOeWdSubD06ptDhMol7KZUdj9Ba24lamen7wigXm0K9fYZN/skcAnaoPd1qnjVXt6ppCG1xh5SCyAKxEGJl+9k4DhVQWBVlqV1F7N99fhP08hGCnJTMiGBOeIrcogW+fJeAm8nLtsN7iZdhXJ/EVREVdfMDhjGM5vqKa1WDTfvYAFGkdYeSGwDAvhgYJuerbnE3nY12PqQ78bFULO8WuYXUicioZ2wfipQAiPGJK63f+VszSEYcwFIZHtCxzcrCCBEG8LtOHc0BecbfIBfyDRWFRDcL9tU9PVKnRrn3SBKxWgSdAV9wW56Z/O15yaLcTvtJrP1FfrvZpDEM1ggDZshHKye/fvK6A9VOtqh6aWDE/DNpNiunDuiIB6QL4CzvLwb6nT5FpC3wQP3vc4DRRFn/+rGjXX37UBdks8wdS9VXTQITjiawHVZeqJcoHG1hc/MMU6uRumRYPv8I5DnxkEtwJx1tIt11yUpfLpOfGfJgbDP3Jt8bIZq7ELsGhUb/nCBPJ+S7oBqPiHRiZ6KUuoFOt3kU9GNNh9xwOgv5GFqVF1tEYmJPdiCtBM9FUcETiOhtFXnapWBrOS1mAhnhGnnC7Utww77iFhljvuwXaSrXNL94p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 07:02:38PM +0200, Vlastimil Babka wrote:
> We touch slab->freelist and slab->inuse before checking the slab pointer
> is actually sane. Do that validation first, which will be safer. We can
> thus also remove the check from alloc_debug_processing().
> 
> This adds a new "s->flags & SLAB_CONSISTENCY_CHECKS" test but
> alloc_single_from_partial() is only called for caches with debugging
> enabled so it's acceptable.
> 
> In alloc_single_from_new_slab() we just created the struct slab and call
> alloc_debug_processing() to mainly set up redzones, tracking etc, while
> not really expecting the consistency checks to fail. Thus don't validate
> it there.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 909c71372a2f542b6e0d67c12ea683133b246b66..93df6e82af37c798c3fa5574c9d825f0f4a83013 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1651,11 +1651,6 @@ static noinline bool alloc_debug_processing(struct kmem_cache *s,
>  			struct slab *slab, void *object, int orig_size)
>  {
>  	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
> -		if (!validate_slab_ptr(slab)) {
> -			slab_err(s, slab, "Not a valid slab page");
> -			return false;
> -		}
> -
>  		if (!alloc_consistency_checks(s, slab, object))
>  			goto bad;
>  	}
> @@ -2825,15 +2820,19 @@ static void *alloc_single_from_partial(struct kmem_cache *s,
>  
>  	lockdep_assert_held(&n->list_lock);
>  
> +	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
> +		if (!validate_slab_ptr(slab)) {
> +			slab_err(s, slab, "Not a valid slab page");
> +			return NULL;
> +		}
> +	}
> +
>  	object = slab->freelist;
>  	slab->freelist = get_freepointer(s, object);
>  	slab->inuse++;
>  
> -	if (!alloc_debug_processing(s, slab, object, orig_size)) {
> -		if (validate_slab_ptr(slab))
> -			remove_partial(n, slab);
> +	if (!alloc_debug_processing(s, slab, object, orig_size))
>  		return NULL;

Is it intentional to not remove the slab from the partial list
when alloc_debug_processing() returns false?

> -	}
>  
>  	if (slab->inuse == slab->objects) {
>  		remove_partial(n, slab);
> 
> -- 
> 2.51.0

-- 
Cheers,
Harry / Hyeonggon

