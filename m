Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE4AECA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 17:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 107346B0022; Thu,  4 Sep 2025 13:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B7DF6B0023; Thu,  4 Sep 2025 13:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9AC86B0024; Thu,  4 Sep 2025 13:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4FF86B0022
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:34:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7390C1DDABB
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:34:02 +0000 (UTC)
X-FDA: 83852265924.01.6CF82F9
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 20B4B18000F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:33:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=olWrsWD7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fWgVimgD;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757007239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BrVWFtzDekW66iL9oaKw3dbdkU1PLtdBDTfnKfp/8s4=;
	b=fkqBJ3GaQ8enTN8uwnbyw1cmCUOs4XhxAr3Ovj6JIiBxQM0PxRZ/kyaaSna5tBtEPj+ykU
	PKMPQvou2dId9cB45fmVR5Z2LNylgYFKGDMQlb2tAWbBJI3IRsuxYybwZbAG46dNdTS1tt
	B6or+vBCbi6a/UBaEFbkl1QvYP3lYBU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=olWrsWD7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fWgVimgD;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757007239; a=rsa-sha256;
	cv=pass;
	b=aBWjWcL52n1D2QKPISakLMFJiiCAFhPRzoO6zYaDdvujiw1X/4zLYdNrhiZyx7MB41SvsT
	oKSa8mGvenMQctszGdIU7WvZsh8HOVmB3KuZU0kTdPUnW29atOF0yZVQUWVgftBYKDigz0
	HLVqZDoSPz/I6nPxrrT1eSiWT17aEj4=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584HTwP0007843;
	Thu, 4 Sep 2025 17:33:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=BrVWFtzDekW66iL9oa
	Kw3dbdkU1PLtdBDTfnKfp/8s4=; b=olWrsWD7pQB+Ba1fnHMALXm3yyJhhuLIBl
	/wtMRDADRfUIznjnqn+O+huEO1nJQpdgSjGl2aYYawVEIOa8z7b7FoV6R8365iU8
	mUufmu63YSVWnsDVUvB+fwN83zBQZnlICDiIl1FHyQy9eGstwpVR9leT/p20pyJz
	dLVl7Gxfz92NP4IdJj47lhBPbpHsfnAJmTbyUygVkwvkFEmKjD2/u2BW5M2a/kFC
	/txF0A9G5bxNOhg8B65v+GtNJTTCKHA0jrwp0j9DB85g6Zcd4bZvUIiADvuc4RvU
	uDK4dS9ke6raUe5+pP0UV7XkepKRGuLOcg/ohatT2XHmMXNqiDGw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yf7b009u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 17:33:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584HNXIi040063;
	Thu, 4 Sep 2025 17:33:51 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhwryp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 17:33:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lXKQd0wvSYLZvYBGRBuj/C3BLnDdakMxz5ZAoRMbChJOut2egDvqnLGdCw8IXgEjUe+lFV3xPkIj7vS0jBqoqsGOP9UCXFz3IFh9VdvZVEreUc5VSSno0Mene6WC4p+Xjo0Z778OfvVNf6ey5wkkB8RVF4nJLs6BU8blbpN/LP5DUQQXhav1ofMkniqfspz/bMZLw5LFi+agIf8NwhBalePdxSDO/ZKsJ1ITsyRkGgpQPH8kXvvBqzMe5+PMfB5kQrZxrEhCEU0qpm9rbiXTonbznBxLj19pM0EBrdQvZ3QMFalslSrUoH/Jv85OjeeWc92MepjXzrCOth/H4ibYFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BrVWFtzDekW66iL9oaKw3dbdkU1PLtdBDTfnKfp/8s4=;
 b=Wx+M1/vlzPuPiQC/2pAx/7MEgeErb8DBiH8EQHJKTgZu90rmhWx2hyaJKNnaV9zb9yRcr9QddryJ+QJmr41dUd+sUU9qr3ThVltH++YRMp3R1L9GRNw4TBLQKhft/IaPkVVQm186JUdvYLXi/H24FNOYfaC6pgbnew6Uk5UaH+CKA2Yz9jFZcAcQ5E3QXOKasSyxVXt8asAdwIdyiIEd7rlJNUBKqJCfoMYdA3c8524JRGjChqINnDZ2XBpEqMAdVqqlKV5XuoVA5zPW7DFxRaPt6YkOR8Fs8SHETslj4BMcOn4imhsGMxOGDh4I4MIAG1k6qaB5DHXifL1Se3vpIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BrVWFtzDekW66iL9oaKw3dbdkU1PLtdBDTfnKfp/8s4=;
 b=fWgVimgD0QvHCSR+f0++nq8DVU4MFgryxAlvW7Ss45OYA1BocbNFdrae9uI9EeVUvAbPa2vIMu/jNlx53147WFfeF0wFkb3S8Rco0d0U4UcBcedeeqmddMNkDyYFrdwY/hdIL51QXV5kUyAckOr2cnusCF/9+TrZORgFYJ81wp4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPF5F5663669.namprd10.prod.outlook.com (2603:10b6:f:fc00::c2b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Thu, 4 Sep
 2025 17:33:49 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 17:33:49 +0000
Date: Thu, 4 Sep 2025 18:33:46 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Kalesh Singh <kaleshsingh@google.com>, akpm@linux-foundation.org,
        minchan@kernel.org, kernel-team@android.com, android-mm@google.com,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
Message-ID: <413ee338-1795-433c-b3d4-72c870488d95@lucifer.local>
References: <20250903232437.1454293-1-kaleshsingh@google.com>
 <827c844f-7106-4f62-a108-1f83544aa56e@lucifer.local>
 <43ryds7hzhs5bpaxznco7fppmakdb4f46agwtsc5erudqfoz2x@7y4jgbtft7jj>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43ryds7hzhs5bpaxznco7fppmakdb4f46agwtsc5erudqfoz2x@7y4jgbtft7jj>
X-ClientProxiedBy: MM0P280CA0026.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::25) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPF5F5663669:EE_
X-MS-Office365-Filtering-Correlation-Id: f036076f-4888-42c8-6451-08ddebd93552
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pAUfzyobG9yukRRBFgce22u6+vdfvfVqHjXfFP8FzXqdYXN9BneC7IJjninK?=
 =?us-ascii?Q?4sqBaL7ip5Ks7fiYFTgsffXeqm0LTa+GUVl28HIhC1Z0mNr9mmUKn1eV29Qi?=
 =?us-ascii?Q?qkoyBScjt6esZ+GL81PZbVwcf8McI51Rp21i97648YGNuIPYHRu1nm1sk/KJ?=
 =?us-ascii?Q?ZqU5iVrOqi6x6RS9o1KzJX4ib9MB80f3loeXfQwiPOVKYzVc/Pozj+FWdcXt?=
 =?us-ascii?Q?x48r0DzGMZFNmBcCNP3EQDgPaxDNztZYeRt85F2sFeUkHw/+iB1TtWmRS1hr?=
 =?us-ascii?Q?6v3WQRoG/CbQ+J607vcIgD+1PVmx5CZUUayn5zFprVDX+NICpUYMyu45z3I0?=
 =?us-ascii?Q?qCtOJIgdze6xvQmMKdQfj/HEyNOIqb0MeJ+++EbL2MisG0BxPgilg3spf1ru?=
 =?us-ascii?Q?T34GrJj5C/on8V1Waw0MVb7waSVcea8ARUceTtqMgtiDe3s51GL5mEhp4/fr?=
 =?us-ascii?Q?16nU7cy8kBSbYza55/ewI1eKOVdrmlru66dSM3C1VgYwenZDvwMsphUuS+Vi?=
 =?us-ascii?Q?xlKs0w+sgFKzyYHuAB2BkAam+GqgjJndMtbwU0XstJrHFv2Nl0pRgL45qLhp?=
 =?us-ascii?Q?wdtF6zr5pWX+l+1dxxHg2zGuTYjtsefN1TL5DPDa31E7OJVMedr6C/ZnryIm?=
 =?us-ascii?Q?jSDoXPGaHDsiehGNysm6Ns0o18uyVkpTxhoS0de1o1uwSt8X7OMbPeS64dSH?=
 =?us-ascii?Q?NVO+xzjF0cz9LNerN/J5IiPKO5+m0+beOLB973QmiI1Bk3cGCRN2XC3d2gCj?=
 =?us-ascii?Q?ej1h+IdaAwGwoOmW+CZWd21Tz1C9Q4pmcaEBS5FyA450HbFMxZ6XrOtlFtIm?=
 =?us-ascii?Q?XxUxkCCqO3Tn+goYEV3CIdWKWlDihKOodbYRty63dW96v7791bJu8en081m3?=
 =?us-ascii?Q?zyZbfuA3DDTKKVUVOwz9VBUJCjVNGKALcIdTv3DyqLqCfivl4Kf/05XZ0K4y?=
 =?us-ascii?Q?ZGOmOY9FURSRqPVbgKngDRHm1b+b4rgdXQm+ttyDFw+9e7t+zh29Up+EySQU?=
 =?us-ascii?Q?Nt5A1M0IOLKTxr7rhOixgnP74Rjdov7ae5xdBNHPI+WVWhuY+YSz34vLwoII?=
 =?us-ascii?Q?UiKyJ4ahMiKiBwx46iOBMVZ9r76YaF8ZV4Er5j0mR88W7sGI5zratran/fGQ?=
 =?us-ascii?Q?LE9KlbWt6nxPHejRgl5y7qnR1A0Z9nBp+xrvwnK1bdXw5JlS0CrS937CchNO?=
 =?us-ascii?Q?qB2SOkJNJXlWd7rbTdR8gwMV8FaeKTF0avSiittoslutNbAeqQz9gk0IUet9?=
 =?us-ascii?Q?HTltcmmd3dCv4vP5W6cTuZmiAWt7/VfOcdSuctaHt6hhOzt+nqf8TQRyXDXo?=
 =?us-ascii?Q?a4Ii0pkC3c+mX4YuolmPGELOdXJhqnSr7fuv4uZwEfwnxVb9Fv13lFh6IKfH?=
 =?us-ascii?Q?pqfwWnQurWmtEypxuTOEcuzT6I7cuXeYJ4mLsPuxPGySDLnPQg6gDPUlDYlf?=
 =?us-ascii?Q?UKEuZZslGFceLmFOuZyul/IdfyLBY9389XsBtIlIx+YfvtlzH4mkbg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5Eq6JNzhTzyKghvmGmco3Yvm5oSemfXVGP0FSOLbcARONjJIgI0o2Ds66vS5?=
 =?us-ascii?Q?PgZory/Ak5UrKmF15ZVnqOQd/EJRmqS57YIQQdFOteyju9hTCRcIKUkrIKx/?=
 =?us-ascii?Q?ep3GkZ+mM8DuNvumuDD3W0O7uBvJq6VqF1RtvT2tNnGEMWTxuUZXcAcMIpYE?=
 =?us-ascii?Q?Wvp5McnaTGlkV8r6trN2fQO1lmp1NIVT8YOlvJZ8V7N5X3odxSkadrJNCG9O?=
 =?us-ascii?Q?VRaqzfQrXhLH4Ylp9jfqQ1ETDF8rYuFHxyr0CD6FOqv4ss3pEUSR9QUOJt3W?=
 =?us-ascii?Q?PL2Iz5kL4maiHeOMwTyfsqiyEmVmidTKHmXZxQKI1PaLS9TvUCpeGeSMvKp0?=
 =?us-ascii?Q?RxV/6QsuTDny7WhviZpxVBTVFbvKW0D92+uphMAv6JT8FqSTlNOpzi8s/HZi?=
 =?us-ascii?Q?31DF80SwGTZulQmfsxB5RAyKJS1+eg9ulwV8UhcaDTBv1EELPURa1hPelKH7?=
 =?us-ascii?Q?YaSXVKiEjvOjjbCZmbSc9gGNh6Msfz04bQasS9wxgYMIwm5Vv2PjVuV6rTCT?=
 =?us-ascii?Q?x2K51LI3W/zo1rtPIgPbMkNN/OXEZrq4h6LbthG03y6C3y77To8xjT9uMMWT?=
 =?us-ascii?Q?qWjkVG2D2dVROQ03bRtEAWaw1fZqxQPzj0UMrrNP/vKdPvUUJZ8gvkcPSPOc?=
 =?us-ascii?Q?TbHvbRQCWsr3Yg385QLtdSc5kTvVCvOkJ9/u1NqlDEqjiQ7i8Oxnhqhlr214?=
 =?us-ascii?Q?Y5Xm8yKaOH/WUiVfuTxl1qA1lvL02pFyQyoDjni6/cQj4IbsTjauMwxtsO6M?=
 =?us-ascii?Q?LcYMbhguAo2fByHY2BCBTojzPOKYTo7V/MU++Wiut5OQEXspVzLJx6FRaPX6?=
 =?us-ascii?Q?mKNTbS2ax4hbQb4GDafpTqdbWlnFfwsDAeLGBL/hG7aHs02fKaUlCYdw3xYU?=
 =?us-ascii?Q?xEIa+BtavFlANGHclwdOAuMPsYoYpTjbje3/CUlH0OpdX9mZqkR0P3cCqIaz?=
 =?us-ascii?Q?QxeAMPgPT6EUwX+n3kvKELnd1ep2R/VMjonvhfXpKzHLu3x3uPGaWuI1qyN8?=
 =?us-ascii?Q?1R4oo5ZdTJifjOvUcqrq+hPk5XF0YR1kruzKLqBtGapzM8ZWnwvBtqcF83z/?=
 =?us-ascii?Q?dHoc9kPp2KNx4nmXWp4Qlcu9F+RTGtPJ//Xshp3eCWLYf+VhY15b1AbVCoQe?=
 =?us-ascii?Q?jRXwczFqLAet6Swxa6gOIU1nzmf06twhrX1y89tADldNBT8vV7G8nXSKP/1d?=
 =?us-ascii?Q?D9hxktdN+R8vRPl5gFRuuXP/lHrQCUA0ShJcMrqaCiOrAVrvGjHHj+EmjH5G?=
 =?us-ascii?Q?0xjRwRxyaShFXGT1S/O2pwPX0sY9+w19UQg/VrUYUK8wF6z7YbrpHbM3/866?=
 =?us-ascii?Q?x2dDURfGksLVKfqxIT8LG1IMFsViOSlnljHFi8misF4rLgEqqENfnooBfX2V?=
 =?us-ascii?Q?WwlFM1gmSVu5TcrRky4B5uj0RbyEPKtDu9vS8Qg4mYjHCFNaPdP123YKK097?=
 =?us-ascii?Q?dhaRwQgj7LOJw66eSUY394Z3syKuJVSE8uNWcjw4lgKz9zUcf4R7MNfLIsIE?=
 =?us-ascii?Q?T/bFR/2m6N7raANcbmQcHQhgG1l/CTb8mq8Cl1fwFcFHT7A1fTY4sS02rpMQ?=
 =?us-ascii?Q?qnHDycVyMCqBS8tLHRcXdY3CQH+KJm4Oe6djBoe/uKntF5TnXbbix8rXHIT1?=
 =?us-ascii?Q?zA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kzwdfxxyFvo+mgUc9LX2z8XAKJ6kk5f9jNwDxutkVmMXiXlzy/aEMIEVNikvQTljb9M0C6RrwzPuLeO3dcXh+9HH3/55qT/tIsw5uimUB9KnKNDROnBgflv1eW6WMrPYCzlZsbnOZPHXaG0kdgHGZfc2m02LMeVmldS6HtsrwDbMkUxj/C7qIzRUhe9ntWrZUWQ/LYv/0hOoXktNgO+26acEj7yuS0C8xOTFq55J5GmJSVkchlb4tHc81rQoTI+OZhiCp+1FBiVuOeM3EY6iTOLtcudZ6NL7SKPUv7cIDo9CLyk4f50z77wrc0WWlJBWbuU7u/ATvuz2Of7DlfF+WapIpamqe+bGTbXAoRpRIzYAOHH42A9TzVqouCDQrHBx1nxZs0SNCQiH5jWuqtUVPYFhOQpnSTWBA8qyEgWEULW7YS9snI0FnQEmMAjP7QqUskvovoz1rVUW6+k6FUhi3xU4k/3I/4bV+a08qY8Meo1Kz9cOcRiIXtpN+5ehGbMEn2JyapEwQ16TAzwou6v5eVyYrM6G1RmXRyQMNmDK/zd2ynypHN8HE+M8wr21W/RCOgKg85EZSl29744QvNStWf9OPnapZ1yuSBCs4vo8uGg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f036076f-4888-42c8-6451-08ddebd93552
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 17:33:49.2225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qt/e2AtLY2rt1AS3UH4PjmCpANK3dUrZVX662OVBUvl12xHsrqvAhmo7U2wkchJleHLCjS4uO9SfHKhCj5HHvVUsZC5J32xTRCmzkGyUXYQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF5F5663669
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040173
X-Authority-Analysis: v=2.4 cv=Qule3Uyd c=1 sm=1 tr=0 ts=68b9cd81 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=kYCJdZcMpDcPJNhWyLkA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12068
X-Proofpoint-ORIG-GUID: fvXMnTyZza0WOOCS5LYD4EQuxOX5kVM7
X-Proofpoint-GUID: fvXMnTyZza0WOOCS5LYD4EQuxOX5kVM7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE3MiBTYWx0ZWRfXzQqIxtTFgz3F
 lSuOeAOSJCOP0mFUC5uDrrC/dO4T+XWibOJTbKbD7SpIdsyJN74mdhzD9IJhxy37IQhuXuRGBRD
 git5q+xJXXVqNQRJ6WHSuH0Kzpz0rugixuaFBb1yB8cxgHtotMCC/003s7F6b8f+3DhoDmSLdOQ
 NrSOvtourAOMWBdtUIv+5aWBx6pFi2SdPY2mEXcTznGkxsYnVyDjHrJfHxNUELl9StW5KHJiY55
 9gcDgBBxdBk0izjdmm/ffOjx714OTDUCeZg4m4c/5BMCUC+8PjDMhlO6pDYoJ2yWSSBsaADF8Wb
 jszmWVAEn1chLpl9j5FH0fMjgMh99fldOKAbjqylY3ySBpZ5eOLLPMzPopJ5BSyw6yQrFjOw90K
 ngLzoH6Q7Bz6gF621udZO8BysfKPkw==
X-Rspamd-Queue-Id: 20B4B18000F
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: bcpd1gdpa9ws9coy7qpidzr745gqiji1
X-HE-Tag: 1757007238-610702
X-HE-Meta: U2FsdGVkX199tpgdhshOwaVGL+P2hnQ+zJ53ZdiahJE8AMcsJ10h4Q85ZzbBbnDW0cEV8UGGpuYsPZ/IHH0wY+Ww7iYNboPoXL0IXHJLyD7n41Gl6w8iUA8fua/9RcdUjsOpjSXxyYn8YqAuaygq15IpA9VhvWqLJPySactylC49cDeNHe/JCTDcbGGZrmFqaQ3xU6xOtx+0IaOukaIP75p50NxR6L3CeQoGBfir6RpiFuuK8oLeC8aHU+FPzzpo9WOAJ0Wuqmpw1LLF9Ew+YuPowGRJUgBTBK+Pv1iVArmDhsKmWqmmNPUCez8yioGggJ6ePmfe5ZmMhlPIO6lfw7RXVnG4oEWMMuY9B8k/eapRxMVRctybNmxH0myVg4pxbO0oRuzXZ+/eMinj1Z8nUdScTzWSXIzU1K7HjOPK+EbVNcgBL8WZ3wKRt6SbOygmEg7Jhbho+3R8MxS30LjS1z8d96avv/RPWVzmVBQjc4c0TTtRkcFPkjkMmpS9DHsbH6sOngT6KQAQBla1F8SA8bj/eZpwsVFK3gl4sdILLtMzuMMl//1U4LoypwQrT34dFLpdSvX0rVWEJN8TxK/6uO0f2XFq+DD4hqFMA8PHnEuZvuIXek0p2dnAnf5qj7D86Bp3k1m4YzCSUIqJAV/L4JDCZ1i65G8O97OjR96CLmSzbxIUOWmDu0zsGtwpJwCcsGi2oWKiQW8V0rWJwbAOcK+ZmH40wfz9bi5z35Gg3mqXZ3X+SyPItNmqRc0lIk35G3GbJKNq/568mddRzv/dEctepahL4gZacRpwbUhwYMZgorhtgU6MJOhf7zsUgxB4X0FHLkYih9OXODsXJoX7SGWn5k5Ibv6DV3K3PRcFZiy0U84KdAkF6FdIp0UwVtqKSFXj9i/xQUq6X9nHm+8RpPwho8NhX991lLxq4ME/t0hD2HmwuVNljTQVJbLuaQ21fc9xNHawE+Wf6Za3Axd
 9PC42eXM
 Ra87R1kSL25HjGi4nv0PZZzM7PyjcylpYK99fmO2pzPuMlHI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 01:22:51PM -0400, Liam R. Howlett wrote:
> > > diff --git a/mm/mremap.c b/mm/mremap.c
> > > index e618a706aff5..793fad58302c 100644
> > > --- a/mm/mremap.c
> > > +++ b/mm/mremap.c
> > > @@ -1040,7 +1040,7 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
> > >  	 * We'd prefer to avoid failure later on in do_munmap:
> > >  	 * which may split one vma into three before unmapping.
> > >  	 */
> > > -	if (current->mm->map_count >= sysctl_max_map_count - 3)
> > > +	if (exceeds_max_map_count(current->mm, 4))
> > >  		return -ENOMEM;
> >
> > In my version this would be:
> >
> > 	if (map_count_capacity(current->mm) < 4)
> > 		return -ENOMEM;
> >
>
> Someone could write map_count_capacity(current->mm) <= 4 and reintroduce
> what this is trying to solve.  And with the way it is written in this
> patch, someone could pass in the wrong number.

Right, but I think 'capacity' is pretty clear here, if the caller does something
silly then that's on them...

>
> I'm not sure this is worth doing.  There are places we allow the count
> to go higher.

...But yeah, it's kinda borderline as to how useful this is.

I _do_ however like the 'put map count in one place statically' rather than
having a global, so a minimal version of this could be to just have a helper
function that gets the sysctl_max_map_count, e.g.:

if (current->mm->mmap_count >= max_map_count() - 3)

etc. etc.

>
> Certainly fix the brk < to be <= and any other calculations, but the
> rest seem okay as-is to me.  The only real way to be sure we don't cause
> a bug in the future is to have better testing.

Speaking of testing - Kalesh - do make sure to test the VMA tests to make sure
this doesn't break those - they live in tools/testing/vma and you just have to
do make && ./vma

Cheers!

>
> Thanks,
> Liam

