Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19612CF397D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 17:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76B3B6B0098; Wed, 19 Nov 2025 12:21:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71B9B6B00A5; Wed, 19 Nov 2025 12:21:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BCF56B00A6; Wed, 19 Nov 2025 12:21:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41E576B0098
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:21:34 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F113AC054D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:21:33 +0000 (UTC)
X-FDA: 84128023266.15.33A75AB
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9218A10000B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:21:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SBp1S99+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xlJ7OAUH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763572890; a=rsa-sha256;
	cv=pass;
	b=NLdoG+KCAfUQoj4/k9OMN7Cjp791/YQY4BpuJg3yXjOAPQkFTzsB0qQHDttKd3xJxitEC9
	CNwcQR4IHc4DDi6b/jSukp6ct1imWK2FeHdzuNMzCUgnQWojvojqz2tTagN3s+cntGxFz9
	QRKk88Lh+bP2AecXRRCTfXtGdBCZohs=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SBp1S99+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xlJ7OAUH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763572890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+4bUPMfK8+Vo70HE6gAhXeoOOIcjnZmTj1lSgnaFeU=;
	b=oBLB0iR65wYeh2/kZpBQsPpGaPEHLilWbn8Q9+p6dShTWt8JgqUWzcdq1FZ7Dba+VCrjpe
	FZ1bk4hVm+fdHH6gx1HymTto2NkB4+uUi1xDnlrMvFOW1fP1X6eRCtp3fMM2lkqliJaB2Y
	kiCMtteyWZfOkZf4UC+KMkdAYga4PC0=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJH1GCl027231;
	Wed, 19 Nov 2025 17:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=W+4bUPMfK8+Vo70HE6
	gAhXeoOOIcjnZmTj1lSgnaFeU=; b=SBp1S99+oOX0XPXSzWryatWenM7MGuD1QP
	zvdHuINaIZHpeOk5asKxEiwSG/puMxvlE5tuGINl621YKSkbdLUFaE61G6e3h9aK
	bRAt9/lTDV8Hhiu4m8yNkobnoJBeLq9O5IMIDRw71fERZQCIHLS1FXr2uywDjpNR
	HZu737n+UOruz+Kqyai/u4G6FEiP27BNUb/zUpyoMfyTZ0ywUDa9PPttdgA9bU6m
	0XLbF4chxz1UWxzuTA1ttDZKS/BHB+rFdHgFet52/BErwuqXfxIILDO8XoX8qiCy
	MjAIdOHX8wB6eL6fQ56dHIPQ/goVi4hYB888vzHiZe7tfsR1m32g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej8j7hwe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 17:21:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJGVLFR005062;
	Wed, 19 Nov 2025 17:21:24 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010002.outbound.protection.outlook.com [52.101.193.2])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyandws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 17:21:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eSoA7OfQNj/JVAhR0kDNlvc1BuoJmgj/cbv+ii5XvmDRX71HQIPOpMWVMaqUHvJmKXHgY5Nx25o0oZQiOdLIODyK40P2JvLyZimYE9/C5j/TpgBkR5vG33sB63JRXyvYKO2Da4ivhju97cDjrt47bCuU+Bic75WXdV1gjSPWt/m/GrRjLoO79b/ABkVyNQ6TUZPKxWnbtLpKF8nYI6e1IEeN8Rx7YLZwtSRfWqw2Js4fr+MYR3PIzZSAaqaF08Wt2xkJm5xrz0BtcdixZSoSzgTGxMt3gsFbJ12RwHMAGOSEsH5Q82LOW57Ow1qTO59Vd6bioc/OoKXugscZvJ0FPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W+4bUPMfK8+Vo70HE6gAhXeoOOIcjnZmTj1lSgnaFeU=;
 b=TL4VLDh2HrGr5xXyKaLzdOwgV9hn14GA/MkxBis5DduevAo/17ScDOm1w3ivQfLA00NzPVbD4aRCI2fRBHueDoVGET803g/izcgDtJZrdWaJHcxDfB5Pnb5AJhPsofiuiyTyEnM4hh/Nl8Wb1Z00/ieLvBKXghXVe1eS0HdgnTAp0qDzqJUNbK9nENPXRtoB73wTl5pAAVErCWJV07vGkdPv9AX4GJoyS9b3PFUYIZASj56ekBO9vGjQHQFBPDc8DcNJf/m9M1zKdlxt5nf6rKbVBNC/UlAvizPNnHnoh8kH4wTYYWKee4nLLm5CP+2c/O3yxYJpz5guXBpgIahTpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+4bUPMfK8+Vo70HE6gAhXeoOOIcjnZmTj1lSgnaFeU=;
 b=xlJ7OAUHec5VLMzRXuRyinKppX/QeCg0ot7DzGWLE8Q+auuSlTi4yj0jVEZP98ZtqHzzWRehfwfbUnEENMs6Kr6XQ+tY5J1uy70tkGDzdvItrqLivehPGgNrVDP1BBenjNm1o6UoNBGjd6XDgNVlAcAgqkU14mRnAJNF9OD0660=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MN6PR10MB7544.namprd10.prod.outlook.com (2603:10b6:208:46c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 17:21:19 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 17:21:19 +0000
Date: Wed, 19 Nov 2025 17:21:16 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrei Vagin <avagin@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, criu@lists.linux.dev
Subject: Re: [PATCH 0/2] make VM_SOFTDIRTY a sticky VMA flag
Message-ID: <6c0f29f6-5d6c-457d-a5b7-9bdede35d4f7@lucifer.local>
References: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
 <CANaxB-yqsphFXvY0diEaHL+Bg4eJ+z_mqezxen9xVyoyL+4NMw@mail.gmail.com>
 <1c20ec44-0775-47e0-aabb-e1cf1f38ce94@lucifer.local>
 <CANaxB-zPuxtbpt7wcjDE1X5nv4yWp=JTq_MqWSfDce2gx-WKiA@mail.gmail.com>
 <f00a062a-8941-4cdb-975e-c13aad860168@lucifer.local>
 <aR3BndGWuzf8vnku@grain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR3BndGWuzf8vnku@grain>
X-ClientProxiedBy: LO4P265CA0171.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MN6PR10MB7544:EE_
X-MS-Office365-Filtering-Correlation-Id: 2592d925-bc2a-46cd-e1ae-08de27900d8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fxYxRX8vxa2ciZ3WKDoL1yDpCDFgUHdgJa43c3kW+Ig5B75TLvrarpahLA7s?=
 =?us-ascii?Q?6tHGDpnZ47VP+7ZcXc8iQRIdmMsFZX3+/2MWXK/goWMKF0SU8nTHDgoxLB54?=
 =?us-ascii?Q?exkpEh8WQtLlvmW5TozgQPhTD33gtUsbOkGhG3TY6UMzg74GC52TwqkirJuQ?=
 =?us-ascii?Q?6lV0W0yPj0JHb57DVEv1B+8GUF9z4iMbJWGMj0eWi/wG5EajlzMZ1afwkwQ7?=
 =?us-ascii?Q?fpWB0eAXpdkvM+2y3Yth9wnXRUdyhY4b7jRkG64IbRLUqiRAbONPFMjzvAL+?=
 =?us-ascii?Q?0UQeMwi7yePmLvq04VS7CG20Fun6KYyMG3gThmvrOiV+HKN+4wVyfC/rQyvB?=
 =?us-ascii?Q?C7qyIAYspuonnDenhA5DLiHsl/H/c3JYv+AafVp5/JpPXb3hCHayB4Wg4iCG?=
 =?us-ascii?Q?W0/1UJc21rEJfLYlvI+rsBhVui0nPtgZ7FCWgNetQaF/Dp7ZQH+rkHyFD9A9?=
 =?us-ascii?Q?ZLt9MFJLEZYgy2xqqUt0a2Uhu6Wr1kaW6KehSrY8MX+YzJJ7INlQ02yxmwCT?=
 =?us-ascii?Q?QJzF4fq+ntciAbRMdKX7lfVizLs5DlzwjkKJOSczIvoRuzAZhe+ydu2ZbJXz?=
 =?us-ascii?Q?XalX+O9XZSz4u/JY3O9P5LiReWmh3gXKmSqRcHmFT79ojdqJgHC4P7lukjwU?=
 =?us-ascii?Q?lhZi3NA+N/5KhHPVvIE+ngJts5e8RnDqXMdTeZYaOKOIWyo4XXy97lJhj/48?=
 =?us-ascii?Q?uIOp7yM338S0hnZ/RjGAtB0lCvheTgplxedqsiMkeszPfR3XkwKZkTg/LQ/7?=
 =?us-ascii?Q?y+gofSrLYuSLht2n1zK3s1NypxWoojbV3abyLtPyUgTGxIdg4RnSysQu/wzE?=
 =?us-ascii?Q?IcU5Y2o7kwf4y3Rn9b7kN+Ic5u3r5ZFiw142VBEfZaR1aUjzXUzk9jDBk2ZM?=
 =?us-ascii?Q?VDagBhWyYZIqO2HG10YWeoX5i+RftrYy3cp1KNZVV5lrm5Xi/jU4BxQK06lp?=
 =?us-ascii?Q?WB+Fv+X6i/8Ovs/jgqg3EYENpGqkdFLZnEKYRWe1i3Z5DfV5B4nlk9fy7hUt?=
 =?us-ascii?Q?ex5gJ2AMvSqRwnekg5IKCIEcsUXLWnpOv2LTzz26abeklEbPCizL4PvNsIXn?=
 =?us-ascii?Q?GrQgqGFanEavC1md90q2P6Me5sP/AL3gOCAPH5YPCWTT/RsD0n6DByciRwYT?=
 =?us-ascii?Q?pFu3Vowi03wu6APEbh0AMS61Ry0l0lMPkt771W3UW4VMAhS5vnE1O3xBXPh9?=
 =?us-ascii?Q?Q3Wzeo20fJBwUlDSFnJFoI5wamFo3pDeDSa9dvNZTrNpgJ24DyhD1+J+7pEv?=
 =?us-ascii?Q?AuCsCiuSRtcV99mJfWxeiyjfZ3vubxe/YDCHWEYcnrNjc7mwOQQMG+hihQ+y?=
 =?us-ascii?Q?EV6OxakwTDI+pH+jEopMH6YR4Uo9txYYFQ9UavJfAyjcaqmGFeU9PJJIlXcC?=
 =?us-ascii?Q?l4ZNqTaSGhjJZgEfSK+HwfOAGwnk67kkRC7iH510IC5rakr115yRDwoxWXZk?=
 =?us-ascii?Q?ieemvT2Ha8TF+i7PNgNdCJA+3UDknkPX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lt11rO73jk2B5HAZgnGh36eL5icLD5Q7MHx5GLthwIwwdXhR+Zz6wLCiGsPF?=
 =?us-ascii?Q?lPGq10o5HGpfKIH490TWdWCJiYs4WEQmjdNXq0OuiiljcZyIL6VUdBvWy//J?=
 =?us-ascii?Q?RIjXoYcVHoA1EsUckiHXanLWbYhbhjrVvS6LqhqD4zb3RwNIVOLC4CBibLNQ?=
 =?us-ascii?Q?btiWCX8+rAknhKM3FrLtmS535P/RaXMGhHxt1p7Uc2xupF2Dlx2m03m77DM7?=
 =?us-ascii?Q?ZfzRD16PLvK2AuaGgsTHvv61rmSWJHvjCl0f6E5YEDloDvhCSfdcmrc1VYF1?=
 =?us-ascii?Q?uoEbNlvURz5En8P8cZibAmIi/ZQfUZQXOdyayOt6c+btfnTVi065PHm5bSkj?=
 =?us-ascii?Q?Jmr084gBKXlqIEa0mcK0/tSalFbvKcO1Ae7lmUi+CoYha+gab4e1jnxz7wE/?=
 =?us-ascii?Q?4nkuByoQzsqf2+tZvlWJOGF84P0Ku0/XuDxJTjGVjH5IW8BpR9lfiHXuP0mI?=
 =?us-ascii?Q?sElHmsmLyCAqrX6JEK1QmDD3DwiW89rI+alfgDbJ0jdKN3Z4lqgxNQy1kWo8?=
 =?us-ascii?Q?AK3LOuT0r/vlXEU56Nngmue2xh2YcGDa1xHhaxEuiQIo+bJ2EmbRo+v8hYPJ?=
 =?us-ascii?Q?YpTwtL/KgdtsrCyPE5+POCchr+1mOJu9zY95lw3+Qcj+BcNsIbAOvmgd+teO?=
 =?us-ascii?Q?93lG6keKIaTl8bj9KkK308vvyFbI7m3nal+0xH13kduneLELIN4lzVvG2srV?=
 =?us-ascii?Q?KCsvf7BD/NUHm2OWgTvfLtluezA+wUHF+qb3Ag0pqaa+HkzHoc+DCiiqP2vm?=
 =?us-ascii?Q?wnjI5ZwT9IEOcb4P1DUk1BxXgCNbNVyr0ZyMvqNznk2cF6m31AOGM++Cw/66?=
 =?us-ascii?Q?9xp0ErOBjinbTtsEcsR6a4K+nkcNqzvVfMXFgYaCC8l/4OP6le9j2P55gSsy?=
 =?us-ascii?Q?UPSxGJOgkFeiuQQxPmyAlj9rs+SZVZj/zNAL1E+BDdUMCdZ3HRWiFtOq5Is9?=
 =?us-ascii?Q?mWNDW48SxyNU0yJb8ANiT6Iay7fZz80xHgJAY1jfz7VYan3nUxWJIdv3QjRQ?=
 =?us-ascii?Q?w37/WT+XkHcW5AlLCcAgLyvQuTN4woSEYC3fgqrNaa4YRLBwlV1rUPNyR2V4?=
 =?us-ascii?Q?t18IGfqpS3uqCGK9VknRPWfeS0vZjUvu7dMXCXePiEALHnplJ1+kVSM+AjMC?=
 =?us-ascii?Q?Cwx6cJ6+xdJ3kJvRo0qIdvQOG8GYQpTrgARjW7/Q3/p6e0GLisN6kbCRW+fh?=
 =?us-ascii?Q?J9o2rpl+oKq5KMoUl714mU5jXh2bhe0Iqri2dE5WheX8Sd+/3oaUFgBYVaLC?=
 =?us-ascii?Q?ONxVC1avvjrjCoscgaDTqhYtL+r9aj6+QbV2Wo03erod1d3FCWZ2LzxSZvtx?=
 =?us-ascii?Q?GF/BrDdNtmVHtlChKbqHpslwozpsvQOoP7/GyLXep0VYDFQR3fHOFDhJZHVG?=
 =?us-ascii?Q?+wusP/y1ZvDUrwWf+i/GPD5HQHPjuiSsZSXQNgzJgdYNAsc1y7ye/Jn/7srx?=
 =?us-ascii?Q?jU5JG7LoaXWLpJp3GjvwcJs/0IqnKddWHTcY3P9HNUAmUnlzjXBqY9o/bLPJ?=
 =?us-ascii?Q?aGZ85Egs/9QqWADPopaRndpIJS9SDTWRlcDK2HTPGuG2KQ7r50ahuI+kLOcj?=
 =?us-ascii?Q?tRy66wC3cg13ZhJ4FI7xzIIgCPIDL+/H6BK0lcGFzqV17DtJiTtNXxmVy7Z7?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Dm68BJm6BuW+hE+LU5evZ92iOhzNj5PWrgP+HTjYXcWzchXHH6Wcn0Be+17dfUTvOKDpmxrVB02m47SeXHJZakTsOQX2YxMF7DtVGYXqhDda+KoJ+4Vq/lIpjp8HbhxgjR6m+mCsFahVD8h3kgS1pAggbZgfIAzM5W5SEL5pXWp/X4h2+Qc8m7sWoowmN8YRrb2YUPUMLznF2WBuiMtzRd1FQmgufZNbX1bce074bsCnuxt6r7mxaSRPm0KnrOaJeU3DpbCY6Hvs6jJB/VLRYUIBl8lECa+2Z9lqcTSUosoMEKSwFKsnYIUUFsjZKHzDxGaUC+3ICysPJuJIQUlLqzbHOiCK+JLFgp4gHlADFxSA2IGxkcs9bSQzcmLbxITg8EkO0Hzue4lixxd2iO4pKVcw4PslyOGVcQ1C/H/+H/8fsrVzbnAiL3k86KEYeKzXNSq30vpHlmhBLSgaoV2iDInoKW1zJeB7DVkt7P86AO6lj5EVYG1FovVwe198UJeBHONqGviqQm+xw57F/34HdgymHF6Q/6qrSo8k89/8nG0suHSIIzFWEFf4G5ALiycxvAip2PmnT/FJkYZdKyDFX/3MI+L+R3PFLOqQZ+m1ngE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2592d925-bc2a-46cd-e1ae-08de27900d8d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 17:21:19.0136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lB7Tx/hErdk1TvD524aLlbwdniwl14TX34OyVdX6/31McLmNaDd0mXZolR2sAdrX+3Zd8btyZpMlkUqX9yZH+B39wYHv8+X8hmHnfsWNyJg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7544
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_05,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=644
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511190137
X-Proofpoint-ORIG-GUID: lpIdrHc2F1m-zKyAU62XsM8qnc8eHROa
X-Proofpoint-GUID: lpIdrHc2F1m-zKyAU62XsM8qnc8eHROa
X-Authority-Analysis: v=2.4 cv=I7xohdgg c=1 sm=1 tr=0 ts=691dfc95 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=Zxe2XVvUlEE-9FcWktYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX2EHcuERQMupo
 RHyRmmkkyeQJVXQwF6CPN4bmCWWmX7JNFXHfw0oq7waSb/e55r+CxwslG5q1j8bswuSWd6Cxbd3
 jAlKCcq9nbcTfmP+uHUFeEUw0Rj2U1gttuRbk2Tcg2VU77aytwe8r7Tdr9qnLgHsMp5u1PF88NO
 BHC58zgdck1vVLJzwa9VSgiHFS7GbvB2GZbQcvdFxvkbJ/86tsQcwFKVmZENm9WH1c5cNzdO3H4
 oW9wUYXmF+DK1ohcNEIjXFcbanEChgqMgcxUVlZYRItB0UcWPVsVAEQSkX3ac0QXPXtdllzG0fR
 wFW5AMmhk+iXRCqiaIHjFYVWuReGs3Rzx1AHRY2I72hGkuPPxZeNp8G6rOFsrjgEV4o6Z4iPJAR
 PHIPGaLDjxoXQs4H5dsRiU+g95iMNQ==
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9218A10000B
X-Stat-Signature: r5bjnnon1a8i1j585ciwgrg46gtgqp1t
X-HE-Tag: 1763572890-298986
X-HE-Meta: U2FsdGVkX18yuqpI6HKwd0RqY7vX8yHqPmhAh4trHLzMWiiusnLhLGI7xs/UTiIlDI6rs1ikae7916APstXJqH+604ev8PgN3/No0yWboduZ1/IEfGEW2Tr5ZCbWA/s62QDW/QJL8mN382pEgjbzNzr3sKsCmUOOvDipHaoXVTRxqNov4HvXv7k6/3NfnBip59gIitocCT5B8gt8ytr/bd+OcqsmpJgP34gaIUFoynvGLb0dN/gVPz/xBiAunPDXNbvM1txM586cr/i2rhdLVTMrapE5+AmGXLgIF/5NRbBBc84kN9J3zOmOgb5Fck0TXo9KpBdta7G8DagHLhJupGOdXmN5Fr/nYApK8OW11uxCUzIB8hwySBSnBgIKGAF7UbZU3Z16Oh2dMGFhsVjujZjebEJJ1kA1xt1PP9blTuBZk6EhpL9gGCU2/yHWvh3Z0N0UOtjuaBURvbPTz7dZkR/HCjbs7hXFngYTN8RcAbup2vaXS7RHp4Y3O5Zrac4bZjzbIjPgqsZv7TodjBrzAdqTQpIUKFbND3+VKkLa4zMCqqB68XSwOkrvfNkrYS2CbhJf0Q4hxDs1xJo426TUqiZ2sO1icH1gx0LW96lOFFcHcRivyTQhAdj1yr8R9cfz+kzn679jCe0m3jGg/MRTyr0EhSweT9LErAeCQ3+JMUK05W929wAK8TUlN8WvDH0h7u4+vwSXaG5H6lIXWtSYGGUsD5DXQiWSiuutWbbgbugnmTLFJGpfj9qQ8lcDMi7rCrfNY7ayZZFkEaO5eXnOi8EYc7zcl5TBbPBivnRV7js+IFiU/xIj7nPbNPmfc74lVaHaO5N80rqaRUf9QP4tmuLzCMxqnNkT9feZPaRt1M/sDH393TAjXvuqK3pyHJ9VD2y/jjNqvYxZVPZtEgEQItUsF/fx3LFQ5bCc7r9yNyHAO0TDxmhcLYteMgEISC2Qok++JTIywuWeQABxhOR
 akWPxXmb
 6Yau693/DyoE99x02e/seQX23dnD9BadBIx8tqxU5tFXIkc395tnxL1O8dFIZRkgSYpOzpclpzSuxPn66Dpt2QrvYJb138j2rbTMhGMUXuX3llZOpgKzuuHuo7+LQP4V+xx5mhsFuPOt9qbz0S+W0s70zC1B6j4MrZYGnDtnGMShmL/e1BTZ13CT5O92Q5WYv96TeH2BAXjom1aF2zdKUKcJh+Y20z7gq2yJBgGOjvsw3HaxA/FTB5EPKfDmUKszu7kepMk0bbfpyGbmooiW03bAkTrs6fFeHVtoo4S9YFkBRz9KBGkBuK7usmg/MCdf15bABbq65i9At4GsrisEpmQ4dmgHEyLww1suUWHw/U4UeTOQWoym9a+Muf0WX0U0IEbkeCrrTYccnZjFAaveSoT6qWhu7OhpBL8qq+q9PYGFLTnttt70HMToV2VwUJJV54glF+o0yf6ct1lL663PPG1lTYTQJvTasrizp4cjXK6gYVjDeOj3aJ/2UdYUXiuptOTypAhYa/4kwmCN3uV4aFkCA1ZuqptdNJih3yTsazRpdCeJtkwvujmvfpdYZJMwQFDa1gVxO6StNO1FJpNOGJSesLHhQ8NxjCH4FLcV2ZtHVvsbtBcqQ7BY9Hvzzr3JQgL8sdmw8g8gTV9GwR4Ew64jxbviw+xS/LsGP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 04:09:49PM +0300, Cyrill Gorcunov wrote:
> On Mon, Nov 17, 2025 at 07:57:30PM +0000, Lorenzo Stoakes wrote:
> ...
> > > I recall correctly that initially, merging vma-s with different
> > > VM_SORTDIRTY bit values was not allowed. It was a bit surprising that
> > > this behavior was changed by Cyrill in 34228d473efe.  Cyrill was an
> > > active CRIU contributor at the time, so we can't even blame anyone for
> > > breaking CRIU :).
> >
> > Well I think Cyrill is in the right here :) the problem described there -
> > that of hitting the max_map_count simply due to failed VM_SOFTDIRTY merges
> > - is very serious and clearly highlights the issue that arises from not
> > merging these - that is VMA fragmentation.
>
> Hi guys! Happen to miss this thread due to high message traffic, thanks
> for CC'ing me ;) Yeah, disability to merge VMAs due to softdirty bit has
> been a serious issue, so better criu to dump more (redundant) memory
> than apps got broken. As to this patch series, I think it is good, thanks
> a huge Lorenzo!
>
> Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>

Thanks :)

