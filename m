Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD82CEC047D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2452F6B00C6; Tue,  3 Mar 2026 04:39:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F2CD6B00C8; Tue,  3 Mar 2026 04:39:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080526B00C9; Tue,  3 Mar 2026 04:39:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7C756B00C6
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:39:28 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8764B5701D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:39:28 +0000 (UTC)
X-FDA: 84504254016.25.1E006E9
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2A3C84000A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:39:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UTBiNXsL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FVfjmfIs;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772530765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V9xJDZqfBN215Ym/FIDAZ2c0ME4XFB71GRqWPClynCc=;
	b=elXVhn+vCjAGNHRc45XXcoVbo/PjNc/wA/qJiM1q+maovdRTpXkOm5r+t3+fkJ7zu2SEje
	lHVCXUmCoMaQV9/E2nCUXBh+HDFD7us4O0wGz/orpYJgLc/bKFp5TVUsq3qA+t4Q9wAgfh
	+7MEkZWivj3dbpJQfECGaay6l7lJ8+o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772530765; a=rsa-sha256;
	cv=pass;
	b=yg73oQHpxqIjl84keh3uw00FUwosT8r2xfxlWIqXxTnlQzUu8I8oyrLa8ExB+urxPOOHqk
	21mcVPyKa89XKEGdBIlvsum0NCDr0wO3m5OmQ8MWODomId8Yo92E4lxjuSJ2eZVFVp9xQq
	Uc+WEAfUSrcqAhaeNxe/5CAQg8UxMH8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UTBiNXsL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FVfjmfIs;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62392Qrn046487;
	Tue, 3 Mar 2026 09:39:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=V9xJDZqfBN215Ym/FI
	DAZ2c0ME4XFB71GRqWPClynCc=; b=UTBiNXsLkqFfgVYGLZ+vzkUJYGhQFqVDgo
	50Fw554jZsKIEdfl+45g7DpcLqUE5wekMYwmLDgbEumzLFOyzUnX7SF7ZF97YF6i
	KOSHkhyk1wJexa1YmOXgNHiYb+FcwXh+UbxEs50Hxi3bqcOJ6KLGqLsXhC8h34FQ
	UCJlFci2dt+wlo8EbX94Qu1nEzEWixV41lVsQTgLfZZTFpSwgBWg1QasRClxGyzC
	OvbFNMLSA6pymrKA5Ara3sbzOrBh5DBxsEygBODMWDuRLc3mtLMd5XTH5bi9x2+o
	L6E1AQFi2G2E/ht0BlIsjFzjBzp1C3FDlc4xugA+e0sDofK7SJQA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnvnn81ks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 09:39:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6238VNjC037824;
	Tue, 3 Mar 2026 09:39:21 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013017.outbound.protection.outlook.com [40.93.201.17])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptecuxv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 09:39:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q4mj/w9K3NCI8F8d4ATMgIyY/VubmH+U5lO6LdZNAwvOxHeFHrKhOonwRfLhr+piHHge/a0DhXUDhZ/B+2aY8g/3wtmMBgAQidSiNiKAvJmVga8C6aAwbQkcu1hzMVRL1rEhyVdvRzkzoS7c24dOUDN9zSD6x8vtmzCL1U9og90SoQ/AzvtIU7U9fhs+YdoFj7GGuWScJr2Jjx+hZgKgR4ebf/bWY21BBED67yuTNtxymLPPiWgugbT8/t78Aco0CyiAv7+q8GD79wR5M5pyGIPsbLJB5eloxi9aQWyPO70uGhqvO9zZqUbRWnuScbvNFUKy/DnnAyN1iymamu+nkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V9xJDZqfBN215Ym/FIDAZ2c0ME4XFB71GRqWPClynCc=;
 b=g89o7iIuv5pEMG9YTVX0vZNQtvwlHQ5fulp7hU1eaf2W07ySfo72n+jPhb5Mfp4u1eoj9AhP6paUyEqK0DlCrjROvkRz+m2Yqtq0wfYvEtEiUCnAfnZal2qHIE2+2iBspEpQ18lwkiwyAzO+z/lFk/Nf78txzoy5vnLfxhofaz+UBHcs21BVqXoHYNgnzNUm+HChCHi6/YSmunfu+Pir4PoGxYHaI7w+ezzMGwQZxdZTZDwi7Wm3SYzfAfuO3xnR2fnK2lywfPRs5SlZFQhSXtF3ucEk5nvJzEJEVn11I3cEk6vdczQjBROBBHLDOg/nrv1hOYwFhHJ/a6tfXY2wsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9xJDZqfBN215Ym/FIDAZ2c0ME4XFB71GRqWPClynCc=;
 b=FVfjmfIsaLZ8YEqPE/l2q7FP4DaGlRto6Xdc/mS6cqxhMI6tIsItVfOkz2RBYZ3AqdcAbZZ4hz4UAdMzQbGaZb968Sd6XPqxCZJJsuVfk2atOnRLHnvHVZecPwsaAo0Jd0GzYvJeQyU9vj8Gz05nPU/XHtaW8T1CR2SwrDLD2eQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5548.namprd10.prod.outlook.com (2603:10b6:510:db::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Tue, 3 Mar
 2026 09:39:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Tue, 3 Mar 2026
 09:39:17 +0000
Date: Tue, 3 Mar 2026 09:39:14 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2] smaps: Report correct page sizes with THP
Message-ID: <72667151-816f-49a7-90e7-c68db3ac3390@lucifer.local>
References: <20260225232708.87833-1-ak@linux.intel.com>
 <d2c37aa0-ec0a-457a-bbf8-4624cdb8074f@kernel.org>
 <aaR4y-lCl7YPEcnX@tassilo>
 <af715d91-6d49-462f-9e9f-3a513ff2ef77@kernel.org>
 <aaX2B9Efh0dBed6c@tassilo>
 <4a08a249-211b-40b9-b6bd-7c54af2b9d15@kernel.org>
 <aaYFpEmiH99dryA4@tassilo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaYFpEmiH99dryA4@tassilo>
X-ClientProxiedBy: LO2P265CA0232.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::28) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5548:EE_
X-MS-Office365-Filtering-Correlation-Id: 54dbf06b-4079-4dbc-3829-08de7908bce3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	KM7xemJcd/4wXUxzwNmJ78MqAyaODv9oMWROHYDuamg0kaY4LCSTjLtcQPGmJ7rWfkYi0wAOrUzBYSfyLavFWDPvDthWLCwuu8weIuWAiNP9IkFIWXJMQpa/m0v05wpyfJkYTR46TkwTM6HApee8bbPXjE1VxTKcWCWpYB8g0uxNprq8PltiOUu434SPPhjGgOcvC0UNfQQihGFoSu4Eb18MB2TWI7xJN8IXdZW3fMyEmIWicu4OP8ISvHg7vs0A+YNrixN8QwFIs0iI5kBsnkGGs2JDkkJVfqvivfyWNcoEeodkMvapowQuwq0FuuW4lJDyuDVmGK0N6q8BrxpLXRj0dA02/d3RBPJE2/OlRTAuojWtpLS+7M3DeghOXbNULpGgXDVMPLHxnNCk5NtBYR8RjxsUkqFKG2FT3S6/ugnAabgTrIiNus1ILH3NnZeo7J10DTUMmMpvvvdRJ6Mdxifok03gTckiDZtGMG2Rh/pmjXOOEw1XUuWlTJ+AQvagYjSKgxup+V6/I6dZVaGY2iZSvIS+KGwTukOe/7TIDrxfKXdrQy93BVEVUJiz3YTbIu364MuLOTbxkSWR3IRqtn/yronhhQLQGEBWM3mrPkiTeQtT/0p/TTKlrb/SDuw7ub28y7QHzYEU2cdHZ92DT3ywCvyjWjmEmoQyaci/IHIw+ycMzRbw3v/odTjzSI8vdUlVXn414nji1Eo+9F94SEuJTfpGNi2XqyT/QHmgV1E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bJ04Pz5cMmQMBzvVvdKJHWF6m0kJzjn7h1czVLmFKiWEX+mSp9vrF+1nmoJ/?=
 =?us-ascii?Q?MSLBugkd19XLVa52/3aqiJ1XWH3GLck2rmcD9TPtkDLwsBGT3ej16Xc6U68Y?=
 =?us-ascii?Q?0P8AyHJ6VrKsT3ijWlzKhXTMo4iDTNnUdrYBMJagCjfBuOicinzPhC4Lpf/W?=
 =?us-ascii?Q?JY8HLXDmFV/EXcq3TQcs5MLp0Aq6ewduTDT/AD2BB+CYv4loHxWigH4vK2aV?=
 =?us-ascii?Q?ACoLLS91fmdd3h7wr3UZpWfAYD0ZrSMIet7CEaCL0cLtB5Emvv7BUlxbB9V6?=
 =?us-ascii?Q?YPqufGZYPKvk7T7bkyabBmNW2hiflbGBmiXz1f/tc4H5OsaNIHVZEbyDH5mY?=
 =?us-ascii?Q?D2ruA+kvpiF0if9FBpDrg9YJdDDlyVNRYnyBBM9DOuYudEoLn0cdwXoH9eaT?=
 =?us-ascii?Q?urdNhRPjog9+uIxjntHu4Uoy0qb5KFPzHFpan7brymgliHNw5oYT/36jAS2p?=
 =?us-ascii?Q?huaCkjXJpzKu7JNtlxTGtYklew7hyR/fa5807X9wKdOVcFiw7e1ptKpNw6LZ?=
 =?us-ascii?Q?wa7u65aA/Dnijh/Wg6+P9mMKyS4182mYQCb/LBdqPWzMw9SbdvOjJMjZxe4U?=
 =?us-ascii?Q?fLrgRsXaRkKIXL7lRD2KuYpvNL1sCpkyWGHc097XRKacss1mLnxr1wYBYz6i?=
 =?us-ascii?Q?1dEJX5rgMcdsm2TgAFNSfBugsavYdPhhPsbYd0ZOV63xThDT53sot81UOI/X?=
 =?us-ascii?Q?jpmGjmBAjHJLcGPlEzXF8icl46mQ+Q5DwJ/hWXf/1/h7giQeDrUwY6FqoA6R?=
 =?us-ascii?Q?KOccB7MoMSo0nFwf1gRKKrMUk/DZDtgcPomU7d39dOBfGDg90kQ2td2myIR1?=
 =?us-ascii?Q?F+iIof94bjc15w1AZ5kvSpz66VwvLxuiciuZ14bJUIzwi/3hGwxWduWODT+u?=
 =?us-ascii?Q?TBuoFwiUlvXC9MFf02Kv2hmI8aSh3GNrHh5eF99O3GB7KZW8aeM9yUPXZUA/?=
 =?us-ascii?Q?OgK+JxHIqoALbYg5kaKDtWq0oAaSzAtcF9uRDpB39TT9xFKO2PZ5GHzQpDED?=
 =?us-ascii?Q?elHADABkcIBAflAL1wmboR2lRMCIRJf3G1Viu+ijkPzM7GAk+SQ9+y3Z/Zrc?=
 =?us-ascii?Q?a6yuH1lQSZrElxL2sl8J4cHVUEnOLsYgaee8RmKwU2tDqR27LsxvgWlsQ04V?=
 =?us-ascii?Q?aOZ90npP6Q1fmdJlFfiQvOZmPGi/uqBNP4le2kMUQLX0LdqsFnuFNf6gr7xu?=
 =?us-ascii?Q?PXEMwALlnsk2DegUlr1TyKtb9CnXHNhw9MYZD5gOkGGaXuaiaTV4t2Vd5/hs?=
 =?us-ascii?Q?Z8jONJ0nggK4zHN8XSjI+MIh86zngaac+EZAvaujlq12qPIGmVHJfVd4m1Bz?=
 =?us-ascii?Q?KAO5yyzZucOdEHJH9WwnDPGiUZH3a8kPYTymcdekOosSSZeuUUnBIFRtX3LS?=
 =?us-ascii?Q?fosuFQ7E1SVtEk/e4gXH7mIoUQbjbYS1FYOAdMb9WLd8WxaUltVkntMc+Rpm?=
 =?us-ascii?Q?NIKcVLWfmRTJF2cN14QUmbTM02XYM7esqDKP8vSPhvyinyA0NDxQ88ha0gMw?=
 =?us-ascii?Q?eLgNpgRrYVzz6pqXd53ccn9U4bTyMFoJuOedxwRevXyj49+APwxtApuytRGl?=
 =?us-ascii?Q?VoDSzWF2om/4Bbz6GpXkRYokJgay7GOxuuj8rT6jsBAt42DVd4A86ve80uvY?=
 =?us-ascii?Q?3qG5U8gN6ILytVgFIJWDc5/vm+ecqwaexiMgtmpbHqWClWJfbonIfxke3HwY?=
 =?us-ascii?Q?eGxD396nFqJs7LErxYLL0Nd7mr/hLwC2ZP8HrSu9NuK7hCn0OaBhma2+bcUo?=
 =?us-ascii?Q?9WdhREER2CD5m3o4HBCA3DeJX/GjKPs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2XH+KaS2yIKCyd4FNgpq4L7RUyCLLyx4OKDElPoVoY6umL74qCmTvf09JJzyXIS1TPENgfTHZkpe58gltwhkhpNjW9TYNIlhc85oIcehO34ybzuCs4zeCJRkVzuUBaFFniY1M390BwMYF0Qji0vhKgPBXT9qF+rIMQ/T0TII1nZnC18NJ2BNmwoEwiWTOW4uH9P9YTi+D4NcSJaBx2Zh3eRK2hBRlMnSJQmvE4j+UbkxUX16Pe4s1l2Q0u+yr4PyOOeRE8801xM2NaYCSDYKJxlQtAu27h0C3OqYAfYJsRxmDz/EGTpf1ORDkxacrNWXHOJOitSiwvNCU8Exdya+E8rUfqSlSuUwpRDsvg4RhHOZuvMtZKP9SS9Pd6k7UIEIFJ7uf7Xfu0+3N4p1ilRhvunrJESl0xWpGEduDhudLmawl4nDEZUu7zkbsqDzZn3599osGmsH/Ct24kSSrJ1dKYPouoWWVZ8FRg01Bb7/fZHNWNdoz7iGRFnK2Qe/3Q6lU5VEpTmz9h4lAnsztCt7kTJ2ksvZB/HVJuxwIbhX/XYocfEk6SboPg9uIF5u8agHUMpnzj58ztnoGWNfQPD9fzWWTEs4M1lkLcAfWxIMKpM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54dbf06b-4079-4dbc-3829-08de7908bce3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 09:39:17.3247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r293WNnrAtZ5Gnk5bwGzni7sUNisiQHoIhR2/oXLQsdCf/IYugRdCi/su/bYu4+97dVps1tz20NzlIi+b8Ak20GfAUdXOjXml/zDDDv7m5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5548
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603030072
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA3MSBTYWx0ZWRfX52En+NjD1Z+y
 X7rXBaZNevfGDr8vJvsmZGMIZtR7RheS2WeVTtxulqXR2cK7r6K3+eIu6HG0gYJtCEDzzRHjYqM
 4OFZVGN3Vc1EaTinwKm7tMy1FKgdz89E9mXWRlmSYvnOLmR2mNni8qBMyMTErnLQxH1NZhlrrYf
 dIhgoKmN1CNG3L0UNCxjxOeWCyORXBOEM6iK7UXVNI9FZwHUKJSA9FBPtXmV+63HnLzKenYRrWx
 wp8Hwth52O06siWRAsC//YKZyX+HWJh/nlEwuYjbzCko2Ldm7iJH3xaKwVEQRJn07GEsHBb7upr
 gkNneEiZNr+g1s0zCFQFWjuj7JIwQ24YNSA6b9RFDmvkKHRZu0wWmTI8LRUIgQuyUrbTzsvlWKy
 ECU5E7QpOmS0RtMC2TaF0rcqN9hPhQoy70ZiR3bOckuANMzAXSx41Zawb56DQIpRRCDokXLpLOo
 GTSsBo6hmb7VlTU4lLljJwjsFDKTLtHOtzoJWI+Y=
X-Authority-Analysis: v=2.4 cv=P+k3RyAu c=1 sm=1 tr=0 ts=69a6ac49 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=GSvWvkLSJBgMLZOMrAcA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13810
X-Proofpoint-GUID: 5zy7wGTJOw_DheR09Du6eBmxeTwNKBOW
X-Proofpoint-ORIG-GUID: 5zy7wGTJOw_DheR09Du6eBmxeTwNKBOW
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2A3C84000A
X-Stat-Signature: g54fu33uumigpj39z7ht4y1ssqh71zwj
X-Rspam-User: 
X-HE-Tag: 1772530765-275462
X-HE-Meta: U2FsdGVkX19c8x7LlT5xh360/UgPgXcXXmkhkKrUO2CyeCd3wirG+3i4FG85Yp5xAusjNdHtW+odPXesfoW7uJWhoL93McQXXQbGfjZ+IbYcetw+UbaJZDGa901mK3ydNEVdfzcKw0QUMNjmD4ocTS4J6xYPWcXEiVanQYeC4LgOxPcFBepDx2KUYv8C9hRobUQDMigvPbiXI3Cq7hQhJoDk2dpAdejIlQvznHiuUwWGBq8Nx1EsL/FTRCHf3mQIBEgZycpq+ZLHw7m7s7CYVweOTIaJYruaBLaQ7Gs5DgdTi8vsjYOHxN1T8/lnwLBhbBLqW87LCwDgMvCKE7UdC4OfS38K2BGnxxwsJeDpq306WsxRlo4MS2A2OfQM3xaGipMJ8B2aXlqm6cqS69e19v5mnwuYyl48uSRBpj1vc/RBuOhzfbhxoEeo52jT5U+D2dj/PTLHMYn8P6CLcMaU84GwJStNMfBvq2P4ey1tu4QKveb2iYICAO5tTs5WVjTH5w/CAzK59P1GYdtuS7DzGtRhp49wvpYztqJBEo7s13nG4HSa4UQksQp+YbV2T1jhaC0f46EaPzXKavBuDGBKI+JT6oAG/IXpBJ2hlFXHbk/eizHqIH5/v3c+LDYblDbsLTXhh9u1x9aOIzUHFIBO8tJidWnOGi/5gJsY3edUgJijXnwHwFeKIWt9V0G4kFB5I7qy+P59Q/ffZp0qJ4qlUkGpJ/xD8kiuRvPjTtuqc+U2YGfVRFIoZDVM1NRKM/FkyjoLlVoJU3AcIupYySbLOFf53rYuFfoZ/QC5Da9VNpkMLLeelnHUwKNKg3QY/816wb7ppVOXFyjA3ZJEYI/xFLHv8VpZWF6udhzu7BbMUNd5IMkapxV4Q30AH5zeByp8W6Z3yl83qETXiSjf3UUka9N9ZoTWd7sDH6qyxRCvATxz+nvzPan/PX2+64Ot5jZM7JRTsq0AM/bQzTGYaj/
 pJ8tYv0T
 RzF7wYoOHardK3RLD1+aPljKqtirFI0TC1uJbhWHgsnoEx6kPUZCKp15eXSq2PhuYvGB3LEkXrqMjuLwRnLTd9OG+wUe4RBk03QCy685LHMiRDAGG3WUBeO897NJiYptMWIOmVlmcKTQMpEq8Mx/LVpkbTFezF95E3E/CD2PrdujLBbCssHWsnATE1J/xsh+W0CsCoZciuHZ+e71N3ppATurX083MSxiDcPKUUEsldrd/XNHfB1GCVytaHyo8XCO1ez174lP3pjJ/3MBNhDrDP1DvPTlmPdbjjnoudKAaONvfq1JKw2WD1bcR6PMiPiopr0PSSOVSwvw+BODNY2lp144MLT66phSgWRCYDU6w26dqahM1RYdkLi12EwjZw779eLV98/6f3Swd1UMIMKxiXLNAehfd1JTX5g2nimzs1naG4P635KbSCK2JYebBk7D3BWzpVXMvQtzSqqyrETQMYsslXqnZqxe6FploWQif1NLec56YZrprwj+iMHF93b2DRO+EshyDMyO79J17GLmNIMW6kWwmZ/pBTBxE/oWy/L6jZPmPa2ct5jTcmGm0y9NZoJt/hgpwjGdnF/c9MPtnlObiMhgmjDkXIFPnwfI6Z9B9lSU0zeQFkPAEDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 01:48:20PM -0800, Andi Kleen wrote:
> On Mon, Mar 02, 2026 at 10:05:23PM +0100, David Hildenbrand (Arm) wrote:
> > On 3/2/26 21:41, Andi Kleen wrote:
> > >> Especially after reading 3340289ddf29ca75c3acfb3a6b72f234b2f74d5c I
> > >> ended up with he following conclusion:
> > >>
> > >> "KernelPageSize" tells you in which granularity we can mmap()/munmap()
> > >> etc. Simple.
> > >>
> > >> "MMUPageSize" tells us how this granularity is implemented (or emulated)
> > >> under the hood.
> > >>
> > >> The case we care about is when MMUPageSize < KernelPageSize. A process
> > >> might have to know that detail even when nothing is currently/yet
> > >> faulted in.
> > >>
> > >> Assume a process would perform an atomic that would cross MMUPageSize,
> > >> but not KernelPageSize. Depending on the architecture, atomics would not
> > >> work as expected in that case.
> > >
> > > I thought most architectures don't support atomics crossing pages
> > > anyways. x86 supports it, but it's discouraged.
> >
> > Right. And if your user space thinks it has "64k" pages, when it's
> > actually emulated through "4k" pages under the hood, that could be a
> > problem: user space could perform an atomic "within" a 64k page that
>
> PPC user space doesn't do it.
>
> > actually crosses two 4k pages. So it must be aware that mmap etc operate
> > in 64k, but the underlying emulation might be smaller.
>
> Sounds like a very contrived use case, which I'm not sure actually
> happens.  From my past experiences most software usually doesn't use
> complicated enumerations anyways but just hard codes something
> reasonable (like in your example just always assume 4K worst case).
> From their POV it makes sense, how would you test
> a complicated enumeration for cases that don't happen on your
> current system.

I'm sorry but it's a legacy user-facing stat, we don't get to change it or add a
nearly-identically named entry that means something totally different (?!!)

>
> > >> I'd expect other cases where an architecture might have to care about
> > >> the actual, smallest possible MMUPageSize it might be executed on while
> > >> running the program.
> > >
> > > That's fine, they can use the min, or just the first match
> > > (which is always the smallest)
> > >
> > >>
> > >> It's a shame we had to add MMUPageSize, but maybe it might resurface if
> > >> we ever support emulating 64K/16K user pagesizes on 4K MMUs.
> > >
> > > Okay, so if I follow that correctly you're suggesting
> > > to change KernelPageSize, not MMUPageSize. I can do that change.
> >
> > Not at all. I'm saying that we leave KernelPageSize and MMUPageSize
> > alone, just as they are today.
>
> That doesn't solve the problem that motivated my patch
> smaps is confusing today and would stay so.

Except as you've been told you can find this information out in different
ways.

>
> >
> > Instead, if we want better statistics (and I think we want) regarding
> > how things are mapped, we should look into a better interface.
>
> I don't see how a new interface helps really. Some of the problems

I mean, you want information X, we're suggesting the providing of an interface
to provide information X and... you don't see how that helps?

> you mentioned earlier could be either solved today with smaps
> (e.g. handling the case when a folio is mapped partially and just
> report the smaller page size), or are unsolveable in the general case
> (what the TLB actually handles)

We're not having multiple entries in smaps for every mapping size, it's broken
and ungreppable, and very liable to add additional confusion to users.

A new interface gives us flexibility to do what we want, we aren't running out
of syscalls or places to put statistics.

Smaps is necessarily a user-facing contract at this point so we have to tread
carefully there.

>
> A new interface doesn't really change anything given that smaps
> is extensible.

See above.

>
> I'll look at the partial folio case, but will only handle
> it if it's simple.

Feel free to look at whatever you like, maintainers decide what gets
merged.

>
> > Ideally, that will tell you "how much" of a certain contiguous size is
> > mapped, if that contiguous size benefits somehow from TLB optimizations,
> > etc.
>
> The key word is "somehow". It's better to work with real use cases
> instead of such hypothetics.

Except your suggestion already demonstrates fundamental confusion about how
folios are mapped in userspace?

We have to live with the legacy of MMUPageSize it means what it
means. We're not adding variable-key entries to smaps full stop, because
they're ungreppable and confusing.

so in _real world_ terms we are looking at a new interface, not overloading
smaps.

>
> -Andi
>

Thanks, Lorenzo

