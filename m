Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09644D172BC
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 03:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FCE36B0088; Sun,  1 Feb 2026 22:17:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DEC16B0089; Sun,  1 Feb 2026 22:17:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6686B008A; Sun,  1 Feb 2026 22:17:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECCF36B0088
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 22:17:07 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4E4001A0A19
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 03:17:07 +0000 (UTC)
X-FDA: 84398055294.09.9AAF4DD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id AF4AC40002
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 03:17:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=g9L1+xdy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=h4UMczzf;
	spf=pass (imf12.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770002223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rnOZM0ojkwbGDdeQuG3/ABdMe1CMEBwD6hcvzf3kRzs=;
	b=oXsVP9UBVgETNXNnOM7W6S1rCbxP5j9SpdphBAv2+x8sSJ4x+HlIokUbTR3ZE/z6yFXgDJ
	lYb9q7RDQ9AATESq3cTfGtb1nDoKkaeXGUBfIuM2CG4RAJX6IL9RUyvJnhdEUgHdwW3nY8
	K974+Kvclwuch775ksWkM8aBkg8rr0w=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=g9L1+xdy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=h4UMczzf;
	spf=pass (imf12.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770002223; a=rsa-sha256;
	cv=pass;
	b=BHwh5TJTPu5C57OD5M5FypFAE62hIs4WfGDg404UU6cqIW7w625b8DDSOxnMxKTQok0Avb
	Ng8k6RVn9fxTg8w0EeWqyfkSEvcv1s59gSwiRl3pMu0P8brSIKXS8/DysLw9sCQ8HFCrgK
	nvjnjswln9F7tJcujbFfBQHoYFZxii8=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6120qUfN136274;
	Mon, 2 Feb 2026 03:15:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=rnOZM0ojkwbGDdeQuG
	3/ABdMe1CMEBwD6hcvzf3kRzs=; b=g9L1+xdyyC2eIsqqZlgEWgZ5CMW2vq/I33
	+MU3wKdzozFa8q5s40pEtfVxEJF1PKEK3N62XqNC3SnxMQrI3kEf32qn0KGxOQIJ
	8VldKlM876kEXFrsRWxw2TTN8vVyznkthRCkpMsbFpgY9/+Hl184i5/zT2KNp1UD
	oQRH7jFeRHgib5EZ8U2A94pM/yvF+C+KXvlbgN1NlQACyRLKo6kfV/Z1II0j9Bn5
	3ypEUB7s+vyOy76Tqc+8QIQzqUooApl16VlSQi2ejIibyJlG/zHM6WpEhb00NCMt
	NxCV55gvrbHFfdMcnBNBQ1yAtWrMvtrowYa6OxgjnHsg2G4+Gi/w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1arksbuh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 03:15:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61209GHG037239;
	Mon, 2 Feb 2026 03:15:19 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011046.outbound.protection.outlook.com [40.93.194.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c1867udqk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 03:15:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GsIMDzh6nVVLgx0Gtt/lbciirYsJn0y5TSCRp4sV4ZeV7p8Ig+vDde5hXaAX/OeSDIKd3oKRzt6uPe8gZSG/iRrDELuIqmaJkAOak8VUU0Iq+gMq85VMewiJnfrsxOQknjlDW+vx4zEutPQGyvGsHWy6c5KAVHrngNaM4gyhHNJ+rp315ODUJTdC6NZA+rmSUuqoud1AMpdeaAgCTnBGH5bW0LcaY/66MqBqFGc1qQqlEmUIz3ap0Eo1KYmZjDpaxXJ3wBk2LrwtZKA21J+9ZOccNkVQL2VfXbPAfGWy+75lKvM2Ot0hrZ0SAxtDeurZfentoXsFUzLjuhAbjnldHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rnOZM0ojkwbGDdeQuG3/ABdMe1CMEBwD6hcvzf3kRzs=;
 b=NbTEFOWGOn/4I/iO+gJuL2BLCEmwTPhRR5IJKMWotnQa1Q/UiIVmD50xCVYd7dwPMqQralfApEwcwycBCDiLXC8TN0H311a1uR/aFc3EBpOeG/Ydy3EHMP1O1Our1yMNhqT/ADL9NU5TUTFCyC7JBqtxbPhGTvB1kF/f6jW0OfYDlRU/lmiePiSetNyC3JqRAoPwDUI379P00815EF61Zn5rm5JO/0xjxPDms6q5zQiHdykSvx7aNTyylmYk1qwPxzyXQb0V7OtJFmAUekvXfBFjqA8mfnQHd3k/oHxfmkRkKs+ckcRltxS5kGjeXGTWy6HUg4g1wDwWeZLvSxdezw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rnOZM0ojkwbGDdeQuG3/ABdMe1CMEBwD6hcvzf3kRzs=;
 b=h4UMczzfqbLPYhlkT2CSgNzTTb6aY0CNx5c/XOabYHnsX2kBogTeq4DTgRKYWy8Gw46neXWHxgo4WFj/7BNIv/K6vb1Ukxu5/gXLLtz3Mx3ZC5GEFewdNPuQc1pZc/5nRHH3VdOIo/9RgekVGquLJXVJ+l4TQcm0r8MHj6LktsE=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA0PR10MB7545.namprd10.prod.outlook.com (2603:10b6:208:491::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 03:15:15 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 03:15:15 +0000
Date: Mon, 2 Feb 2026 12:15:03 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, hannes@cmpxchg.org,
        hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
        muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
        ziy@nvidia.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
        kamalesh.babulal@oracle.com, axelrasmussen@google.com,
        yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com,
        mkoutny@suse.com, akpm@linux-foundation.org,
        hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
        lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 28/30] mm: memcontrol: prepare for reparenting
 state_local
Message-ID: <aYAWtx9Qp4vWSoXN@hyeyoo>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <b11a0bde9fe18673a61a79398f226ad7cb04a894.1768389889.git.zhengqi.arch@bytedance.com>
 <iu27pt5nqs6myshw57e7dotld33v6lwuyouvquoqc2zmc5loi6@f23auf7hqbdp>
 <9b9057f8-4c4c-4067-b6ba-0791888c25e8@linux.dev>
 <aXrBiPlpEOOC3cMZ@hyeyoo>
 <6860146b-be12-4d5f-bec1-bbcec1dffbc6@linux.dev>
 <aXtRWdwwmi7G-Hlg@hyeyoo>
 <4535d53c-68aa-4c3d-b95e-6fbafdb83881@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4535d53c-68aa-4c3d-b95e-6fbafdb83881@linux.dev>
X-ClientProxiedBy: SE2P216CA0173.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2ca::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA0PR10MB7545:EE_
X-MS-Office365-Filtering-Correlation-Id: 53090815-c835-4db6-3e5b-08de6209491d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Gn+CC5rlA34hGR8dShwP0ZaLsubwqME2KMbObOHZZSxqWUCTEXE/tFjEhQSg?=
 =?us-ascii?Q?whH5pBkaEH5UH+KZDMHkD5D5ffWVI9NjalxExxp+G5kxKm5mbDkAj9PK4lOC?=
 =?us-ascii?Q?Uh8syEBUgm+ZVQV5f83HxF7z4ZIkwvnyA5WuC/HMtd7B2WHnigME1IuDV976?=
 =?us-ascii?Q?8JtYPWjKhqlt8uzOS2b8NdTZakcJ6n3ltl5kLyR3buILnDGbJFLf1i+VXM2k?=
 =?us-ascii?Q?TqIkBWduoysr9/Xsdde+CjWFJBaiqh8JBntDAbD88/DaVBqCx7F9Teeq1nJS?=
 =?us-ascii?Q?v4uUdk+IsmQZbwY8Zf1n8g8BS7FC5wUMnu5Pmub44W0jOkXI6KN09MpaPftl?=
 =?us-ascii?Q?38Q2gwbp+B6ehjP+vsHuHO7gG7DCeGPj9xobtLckUkksAUu0cskDLEOiIcxC?=
 =?us-ascii?Q?7ZSINpV+G7goHxPR7qoDHr0/mUsTH/Dxv0WA8vNViRuHFmEgsl6rIrKfcSU3?=
 =?us-ascii?Q?mF20+gTAW1L7C9ILR+pE/JI7HRoVfKvcZ0cHGRSvEpC6TFYR0NZbLiPk8o8X?=
 =?us-ascii?Q?JiHKmgT42raufjyzHoASRK+KUopDevVHlaE2K7o76uv3+pl3aIY5WcjD9ZZv?=
 =?us-ascii?Q?65QrS5f2zFSc1xPd2rIG/Lvc+HCCDRubqgdDOX2DV+8eaAqlVKd+FfArlXJH?=
 =?us-ascii?Q?7/TC/YmVmCthTArh+78kpSqeMn2hQtTchNwWFq6DxUpNCXXKUJme45NY0kpp?=
 =?us-ascii?Q?JkxVHlCMJ/JMTV1dwJ0JK/LwIPdHyoqvRnY0WFSuNGqOClMj+oqgViX3yV94?=
 =?us-ascii?Q?V7ZosvfsbR6zgHE/lI0eVckOo8ei0beMDDOT91o7ffhdDeNZOqa9Z7+VbKEX?=
 =?us-ascii?Q?3E93pBYh2HcqslD0wyGbs858N1wiQgzQNGqGGAi3ljlUMFkKhT089KzchB26?=
 =?us-ascii?Q?e/PAs1em1TAtAdlxMiVqBNsacESXEARBDT5ylh7mpMcHlX4iy5JtAyuccSAK?=
 =?us-ascii?Q?aIuVceX9zOfviTUBmMte16pLdFd2xPsuQBGTWmNCax2vVoCPvMwbMQlmLTUX?=
 =?us-ascii?Q?4OQgE7/KggAMwIYPWAcO/6DxffD/GJUWr7mKOFwp9DOHydREez5c2U3IWcWx?=
 =?us-ascii?Q?3XibKWE0bP45YSbkydxWpuqEWdpLMBH4KFrHJFbodMlU2+Wcp5eZL43npH1t?=
 =?us-ascii?Q?SNY23FjGCTT1hwKr8P6kXDyOvucbSfdaCbHQqXAE96Zeq5kxp1qrfqe0/HGG?=
 =?us-ascii?Q?TrSveGua+gUnskHTUdD74U90tJkuLBPWfCIbvlFCRkGVL9xqjNtLp9Jba4HR?=
 =?us-ascii?Q?UkVG0aXNt0Zwo40dkkAz/IpSfx6rlymPSYxEMKCzGjyybJ7n3Rv2rPzma8ck?=
 =?us-ascii?Q?l7jNSwLT7wtG9mLcfwalUSuk4ugByr/7kz8j+jqnHGNi2Yvq5Oc1ZXiJSZfC?=
 =?us-ascii?Q?oJ0G2sD7giaCXCYQAwBxZdKH27UxpV3OiXOkQUs2rdCpEvYQuKMyhKoUSNiI?=
 =?us-ascii?Q?sxUscYhANOWVNtZFa6EUW4RxtvLGM3fK3P1Q5Sv8Ek9UFCyrl7K0f4q1oaPI?=
 =?us-ascii?Q?bcFJ+jpv5scaKIZ4Y/CYtQ7dDEwIJRachJdEj7Ca/uiNC7i8g1/VvkRAhQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o/KrvmlRvd0emG6WoEenttho4Osq6Zx3wQtZckT4UbTIhza4FDVBaK42UHVT?=
 =?us-ascii?Q?N4cj+XkBIlgtd8i0SeQp3ve5d23vHyABZ+lrWZRmBKcPrAci87lEdpSw5/Sq?=
 =?us-ascii?Q?d8sEOT0agx5+F9yMET/qNaff5MFeZG1xx9v41oZ1XDmguB+XeZCb/mW48FPA?=
 =?us-ascii?Q?Tll2Apw9xUuGwc66qoOvgmcuIIEHjIi9JcPklKMuLjJJoNRnAb1iJE0xUKo7?=
 =?us-ascii?Q?rWllup/jwq8GfnWC8mUUdtJTiw7H9UX4xhzhPnzOEDdqtmCOgsPsXI/GRzTd?=
 =?us-ascii?Q?iND/Dv10AhHKAkFD6BQxS3Zd8BQWi+bZ4QaDlZ4dJmkP0L6RR16WqA3Mon3g?=
 =?us-ascii?Q?hufKD/23SCb2NmK1j5ZkhgOAQjRcm0KRbndlePFvpQ+24CzDQCRiMJHt1n2N?=
 =?us-ascii?Q?j0fa9xUQGensbOVe6jbhThrv4bUJwERubB/Cp+vwx2/kIe2mn0LK2t6OtdGC?=
 =?us-ascii?Q?1k0qq23euikjwMazlkX2tEFvmzAf+a8F4FB3yL6a4G+Gd87pZl7Ox16yL1oB?=
 =?us-ascii?Q?re+CQ3N2P/FauO1tAeGOBv/5TBiVDusyKplDMeVCRonA3E51tTzEFYgirSmJ?=
 =?us-ascii?Q?PN/Q827JHiLELme4vohZ0lqtfDMjs6H7YV6oxOqHc+451vwtBEb5cpyF39kF?=
 =?us-ascii?Q?BleRn0FO3vJe4g+AKwZQ5OJNI+vLRXmMajlqXhWSnLhggFriXbH+YC3gFWMd?=
 =?us-ascii?Q?rdJJQBJRvYPTLVRlIfCUk/GZmauN2hVs/arWka+5UWsQ8jUISEL/Hv/p/iCJ?=
 =?us-ascii?Q?RIeJkf2pUSHzyppLarezRMOiTrCDXcGlcK8UpZfMewZOTUqN6hVSAlLv1yBy?=
 =?us-ascii?Q?NE/dpTaY68BfZ5lXiQ6A9kCeHrqUtgVzD5hGmGkz4y82nW1H1jFTOWhhxQlo?=
 =?us-ascii?Q?OmXnu4wlHA0jGuumbDS7iTtSwmCk3xIVfkdW50jVJt687XGp1VczbrIVye/B?=
 =?us-ascii?Q?FtuiLoeLA9xMR/HuOY+0iqWWWQWOijG4qfIrtXUDYqR1ojcc0m1bGcq3t21W?=
 =?us-ascii?Q?bdp3i9dGtU4Ch5i5J63IqThc/ClXCusBBsVWdMrVFOx5/HVZaUB4E580krkP?=
 =?us-ascii?Q?LyARvyvWhIVJZUm1RqaJATLaHZ4byTcPqDQCMPosfc6KFryT06qvu0SqXdML?=
 =?us-ascii?Q?Wt0L4io+nLmYzxBaGf4SkCVV7ebT+JQOGM6SxPLjH7rNYc42rH+iZU1FnHHq?=
 =?us-ascii?Q?gOV7LF5bsIxSyp+TM9nHu3guwf7haoLjmw6nBKQxkH7UX6qYfUwVo7RILHsZ?=
 =?us-ascii?Q?aih06WRNLE8GNRLnMhbfpJDElTG3MaAVWajB8c1AFLojKLhI73HUyG/U2ubv?=
 =?us-ascii?Q?r57BxNOH/oEtpMppm5u68YugN7kEzoYFps8KejU4HMWzdkbN3ig3PIqS5hbc?=
 =?us-ascii?Q?eHagciowL9PbpEQIUz5E7bMZppfZU3GQko8mzkd2KNGCBXwRmhI3LHLiSeSE?=
 =?us-ascii?Q?eipCZt9+EjkFv6rkIZ6m9Hx4MvKKid7fsVir32RQYtDFgk0XUKQmRVJ3pnav?=
 =?us-ascii?Q?9sHFdp4sZCrCdDGObpgzXldmkhp+tK+0ntVlIYaZKjUEVlhhB2YXW+CQ3agk?=
 =?us-ascii?Q?5hifDVhWuQaPagt+hhHP34u5C6Jw5+Myz9hqyI16YsZKYRwMCf2FC1TmXOe2?=
 =?us-ascii?Q?Z9ov/DvqcD7LCEAt+zxthAWYLi6d68jOGrXfdng3IpexbGoLrZS3N+vcrzrA?=
 =?us-ascii?Q?DCdqppuHYZemUU19z7MM6PyaXhgw+dhecbF4Ps4IGYelJr8vSGXGwMh4Nhbz?=
 =?us-ascii?Q?+3PLhurG6Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I7WsEGSnkGw9bHbMz7SJ50g/4Um8kBj3PzGFnr9ULEPS6HL1QONJwL6aeCIgnFP3mAULPUN3XIeIPlGj4jwrBE/o9D4HBENaN8MnElW8NNMa8/WWPNhD0kZKjEaXMPEBi2qLrjp0bmMk5Pkmb5Cd9bWZDjvhCP/w1QpFaHohCMdDEoeFsXDfNi5PokNifH1AUutJKZzwOsYoUADYnBpe79EvYSH6tYm2NohWPeWkqugQqCLXWUtQCWZZ8J+d0iRUWupWQfpJ2WhM+7JRHdeCopv4j4h5ji23nJxrqoYH/bPkfizFcY82vRCGAq4yped5D1C8UtUpfXy7yWFu4Fn/VNkuphkUx1Ka8tSBmbW7jRBbnxcC9hpgh5X5s8QMzaOonni1PYC/R0EMa4BnG2qv45qP5XFFRlEO0jOJ8VUUT7Xu2J793vPMCNvt83jv9q7wRxouQUU5WyzBvhhzorc8W5lYx09r0J0JseERb2+12XFtJZanNhMgE21fF3H7DmCcRv4NhNg/wwrNICRQJhxtD653QHwpKHHKmPpSAaKVsBvDJsotID6S7C7CO0e12dtJe01DWdC4IhmorFa0P+mtF3ssf1k6KEVkhAZhkM1GHP4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53090815-c835-4db6-3e5b-08de6209491d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 03:15:15.6480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DTAVDZHGi1vw2EiITVEfMPgRFFuvdx/kvaXvwNfeAG5+Xh+C8DOwC0qsXFVj+vfifAvV0tsDTxmGfHBz5uhWQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7545
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_01,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=897
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602020026
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDAyNiBTYWx0ZWRfX2CgqVYF2R14/
 KeI2ny4C8jKqAMKEV3Pj7N1LKIPXg179AuXH1x1Ghk54VyoJKWXORcJraLgW5e3TZRR4FF/OWLH
 n+q0l27R+4Fhahpuc4pTBeGwtyK3uH0h5zvvVvCDCLnto6mnDv2epJfWV/0VVQj4HYBWC/1OWY4
 WMBP1h/Mp+aqORlVCwvFS/49q/PuMHxYAtNNX4Qfph+3L1o5c+KX4IPaY2EIIUE+8fUu45CeBd7
 biwGe+D7ZCeJlkQ1jhrMLTVL7Ra/zgzGf00KMW8pytxQcYh0xjT85fLbhEvqUNUMEvKqmz4znP6
 cXGLypkbgcBulCm11NotHRbJn0OmGZpMFYKby1qyICDbUMXLjUvxjhi8MjETHOrDFw/v0yYOtwQ
 CRi5TqE/fPNAmyJ5f0hQpGOAeNJ73MyUYDc7t2S/kSFU40VTeaa2FoB3ybnT5lp1f5sgEi3rzpY
 b7nEh/qMDmFVEPeLe+g==
X-Proofpoint-ORIG-GUID: zduffdN8Ap_LMtPL51GKh3If9F-7XYqJ
X-Proofpoint-GUID: zduffdN8Ap_LMtPL51GKh3If9F-7XYqJ
X-Authority-Analysis: v=2.4 cv=VfL6/Vp9 c=1 sm=1 tr=0 ts=698016c8 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=wxOlz8tp4pKKseulPKcA:9 a=CjuIK1q_8ugA:10 a=Ic--COEDtmgA:10
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AF4AC40002
X-Stat-Signature: ne5kokocf7guses6qd6wnkpsu75xwg3w
X-Rspam-User: 
X-HE-Tag: 1770002223-586324
X-HE-Meta: U2FsdGVkX1/0gAAqbo/Y/3I8A+PeHraNyF1sRjtM5Wr8PHU4i8BucPd1s0IFWiyc+ybwFYvpzDziNg8YcGsc0HfipbtG4+6e1nOV6qmNzZpE7vSgICbwX0QkQh2o/wR2s4gpVCti9mLnbfMOBmjk9bn5616AgdgUaprqVtqLSjePJurGYgCayNiUyQfrAIZR73PZsduUlqhBFIo9RQMLiM/5pHp/hROr1lK1SFvGMV5gXu12Jw2tc/d1BlKvue7amou90c+QN1utA66MC6/fAPJ25lBrwinI8AcbRfrfK86SINdw7cDY05aGbB5whShppm9M+cyLQNpmo7p1zkPbH/87bszg2t5p0kKL3+WIgckFq8iDuy9W9Gh2ZOFIOAB+v7A+Kj7tx/Y9gve7WmZMXZawSw6XYpV/oNAnguFa1rcrROb6+hpdr339eTL81y2DRSNcQpcFxN7ExrhKwdpGgzGwU6IzmoN4HC2EB8EcxZHhiCHCqTPNrjmj2BzU8aCTG4Rhqtw/4aUY6dJWKeXDdB55DiAIVInvgqNGZFkU6rhvV8WFah6nhEp+A167TOBwAku6rHGiT4unhWQkhQpGJPlZxo22+qPB5e5J+xxoBQ5IpnJM8asJZv4ot8+KC8VAY+fiFn5KKNEzpUdKfMPheyZhnIwsSRyWYoB7mJdYFiFzihx+rUHWtNF9g/4erlFkLdBqmUA9y7KsBvGJHjD0fUK8ayjbWwUMuuYeDHhWwADqhssQ93ATbiEWYSKxh2GWnfusESvD10TpsvZ+fG9oVeL3DB7hq6NSNGyqWIFTd2CIdw3YzvNefpNQoEdjzMZ9Wq/7GZsg0eumqtp79R8Nh9zuxRyvGqafYgenZtFjeyk8SUkNnYf5prG9PSil/vLidtpgmDGd99oGZnO+R9QUKoAPrlz3AnydsMtdNkTorkaNQv5HEWyyI/dM3hOtJUASReQ0kqJd4YRj8hv1yUi
 2Bdwcl5j
 4vDzNvzgS+WcJzl/ek8AHYXjwyb7b+e/2RKfa7cNnzFF4NoXww0WxSNeSJ+vospNoMlZh2B6jZFxvvjLzUkfSCTN/Hf47ldR0tE3YjMdP1hpq3FpSIH23RGt0lnitBma4XfnTCKnWQN8DN250U4tFWHRST2Yw9eVtvUbLYde7kJ4UlzZ/HOhCm+7itEJQW18ejFlmFX/oOrm6lMddocVTghsRgu3gkHZSLg3fqMehXeFx3enq9MyMbF2zclPxqpNEL5B1tTgHN82He4hArMEmWvbSv2WVtEcEXqrN20cf3zVj7nfrPxdjB5X8YWQQN0PPe9xXvdBguHafUwdw2YA1WDmA0JirsncjSIlxL6prsK+dLzFql2EmkODfW8lBiGTaQ7/Ai9eYtHX+y4lV2YFVooZY5KHicV1Nl/C3XAXOXa5EEO12YKsBewGzWgOwx8Zzcbhi1PDgMpRs43kl/4djcqSHyN5p1QWAWZrR22Eo1yv+29EYKKPunWXAEuObbweyyxniERc+3SdpaUHc6OgLiEedu6R3U2MXnARZSrfZ7rEJygD2RVxjLaAZa4sNnJ8TOAPinPqNxkCZZwUKiPSstHWkZU7DnzcwHqz6cJO3PX9eh48rNAZJ8FvivJUT2HF6FYO2oNECuHWRA0Zo2aoUcpcmUvH4N2Gl6FZPF77iwnfkrr5/fJTVAdvvSn7vt23u/tf/jcu49KYuFQ3zhbsHegOtoWIM2FUpoKIFdKCdpbaJz+4fAuRAgiKYqSOM1YNEa3Wk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 03:22:20PM +0800, Qi Zheng wrote:
> On 1/29/26 8:23 PM, Harry Yoo wrote:
> > On Thu, Jan 29, 2026 at 04:50:39PM +0800, Qi Zheng wrote:
> > > On 1/29/26 10:10 AM, Harry Yoo wrote:
> > > > On Mon, Jan 19, 2026 at 11:34:53AM +0800, Qi Zheng wrote:
> > > > > On 1/18/26 11:20 AM, Shakeel Butt wrote:
> > > > > > On Wed, Jan 14, 2026 at 07:32:55PM +0800, Qi Zheng wrote:
> > > > > Since these two functions require memcg or lruvec, they are already
> > > > > within the critical section of the RCU lock.
> > > > 
> > > > What happens if someone grabbed a refcount and then release the rcu read
> > > > lock before percpu refkill and then call mod_memcg[_lruvec]_state()?
> > > > 
> > > > In this case, can we end up reparenting in the middle of non-hierarchical
> > > > stat update because they don't have RCU grace period?
> > > > 
> > > > Something like
> > > > 
> > > > T1				T2
> > > > 
> > > > 				- rcu_read_lock()
> > > > 				- get memcg refcnt
> > > > 				- rcu_read_unlock()
> > > > 
> > > > 				- call mod_memcg_state()
> > > > 				- CSS_IS_DYING is not set
> > > > - Set CSS_IS_DYING
> > > > - Trigger percpu refkill
> > > > 				
> > > > - Trigger offline_css()
> > > >     -> reparent non-hierarchical	- update non-hierarchical stats
> > > >        stats
> > > > 				- put memcg refcount
> > > 
> > > Good catch, I think you are right.
> > > 
> > > The rcu lock should be added to mod_memcg_state() and
> > > mod_memcg_lruvec_state().
> > 
> > Thanks for confirming!
> > 
> > Because it's quite confusing, let me ask few more questions...
> > 
> > Q1. Yosry mentioned [1] [2] that stat updates should be done in the same
> > RCU section that is used to grab a refcount of the cgroup.
> > 
> > But I don't think your work is relying on that. Instead, I guess, it's
> > relying on the CSS_DYING check from reader side to determine whether it
> 
> Only relying the CSS_DYING check is insufficient. Otherwise, the
> following race may occur:
> 
> T1				T2
> 
> 				memcg_is_dying is false
> Set CSS_IS_DYING
> reparent non-hierarchical	update non-hierarchical stats for child
> 
> So IIUC we should add rcu lock, then:

Right, RCU here is used to enforce ordering between reparenting
non-hierarchical stats and stat updates for child.

> T1				T2
> 
> 				rcu_read_lock
> 				memcg_is_dying is false
> 
> Set CSS_IS_DYING
> 				update non-hierarchical stats for child
> 				rcu_read_unlock
> 
> synchronize_rcu or rcu work
> --> reparent non-hierarchical
> 
> > should update stats of the child or parent memcg, right?
> > 
> > -> That being said, when rcu_read_lock() is called _after_ stats are
> >     reparented, the reader must observe that the CSS_DYING flag is set.
> > 
> > [1] https://lore.kernel.org/all/utl6esq7jz5e4f7kwgrpwdjc2rm3yi33ljb6xkm5nxzufa4o7s@hblq2piu3vnz
> > [2] https://lore.kernel.org/all/ebdhvcwygvnfejai5azhg3sjudsjorwmlcvmzadpkhexoeq3tb@5gj5y2exdhpn
> > 
> > Q2. When a reader checks CSS_DYING flag, how is the flag change
> > guaranteed to be visible to the reader without any lock, memory barrier,
> > or atomic ops involved?
> 
> The main situation requiring CSS_DYING check is as follow:
> 
> T1				T2
> 
> Set CSS_IS_DYING
> 
> synchronize_rcu or rcu work
> --> reparent non-hierarchical
> 				rcu_read_lock()
> 				memcg_is_dying is true
> 				update non-hierarchical stats for parent
> 
> Referring to the "Memory-Barrier Guarantees" section in [1],

Today I learned a little bit about RCU's requirements :)

> synchronize_rcu() can guarantee that T2 can see CSS_IS_DYING. Right?

Right. It is fair to assume that a read-side critical section either

1) ends before synchronize_rcu(), in this case, the reader might see
   CSS_DYING flag or not, but it doesn't matter because this reader
   ends before reparenting the stats.

2) starts after synchronize_rcu() starts, in this case, all stores
   before the grace period starts must be propagated to all CPUs before
   the critical section starts. Thus, such a reader is guaranteed
   to see the CSS_DYING flag set.

Linux Kernel Memory Model [2] explicitly explains 1) and 2):
> RCU (Read-Copy-Update) is a powerful synchronization mechanism.  It
> rests on two concepts: grace periods and read-side critical sections.
> 
> A grace period is the span of time occupied by a call to
> synchronize_rcu().  A read-side critical section (or just critical
> section, for short) is a region of code delimited by rcu_read_lock()
> at the start and rcu_read_unlock() at the end.  Critical sections can
> be nested, although we won't make use of this fact.
> 
> As far as memory models are concerned, RCU's main feature is its
> Grace-Period Guarantee, which states that a critical section can never
> span a full grace period.  In more detail, the Guarantee says:
> 
>         For any critical section C and any grace period G, at least
>         one of the following statements must hold:
> 
> (1)     C ends before G does, and in addition, every store that
>         propagates to C's CPU before the end of C must propagate to
>         every CPU before G ends.
> 
> (2)     G starts before C does, and in addition, every store that
>         propagates to G's CPU before the start of G must propagate
>         to every CPU before C starts.

	  ^ this

[2] https://docs.kernel.org/dev-tools/lkmm/docs/explanation.html

> [1]. https://www.kernel.org/doc/Documentation/RCU/Design/Requirements/Requirements.rst
> Qi

-- 
Cheers,
Harry / Hyeonggon

