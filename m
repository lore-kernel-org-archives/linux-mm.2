Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB49FC79F9F
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 15:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 131726B015A; Mon,  5 Jan 2026 10:24:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1096B015E; Mon,  5 Jan 2026 10:24:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB296B0160; Mon,  5 Jan 2026 10:24:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D5EA26B015A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:24:32 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 75F761401BF
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:24:32 +0000 (UTC)
X-FDA: 84298281984.19.5616F63
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id EBA42180003
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:24:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SRMhEZSF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="iNuMBU/w";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767626669; a=rsa-sha256;
	cv=pass;
	b=Ix+DAUd5TyaJrmT69dV27PaVLxWJvovRT39jUKpbo9Z/IRwxCjU3gUFu2+V4+qQVrCmhOw
	4ztPdXcDfL+NTA8rtKu06vUmNWVzDulM1I7kSg3kBwsSnCPtVmkilzpm9g2PqTepuxKcH0
	ZpHBBDBH1BVnvEgJukj7opVyD1V90hE=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SRMhEZSF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="iNuMBU/w";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767626669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ugzeUG5Bfafzku1FH1ioqFTDIk9KQpBZ8yQ+sTsD7wg=;
	b=aFQ0tGKaFJkJsRfAqArKVVNRTg/OgVBDCpQ8UBbyvjrmwbjCCLVMERraQGF2lgDoZaDNQn
	r3KSvGYRy5b6OkDIC4Zxte0Wmwr6kJ3zoA/y+E8ABxqgR24JsVdKezqzr1qu3RWTtbk7Bd
	YIy3ZjQLFUD9Wexo5plaU9rMSgEvl1s=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 605FEUVe1671042;
	Mon, 5 Jan 2026 15:24:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ugzeUG5Bfafzku1FH1
	ioqFTDIk9KQpBZ8yQ+sTsD7wg=; b=SRMhEZSFk0G84oOdNIJi/GLrEzMbqTV4mX
	WI9DM3DkuQ+nxHlV9sjlZiUReFKn4xevF6813uLXCDeARJZhVUgHVETQrcdPoecn
	rZ0AGWyXDEtvd8RK/Rxy+miNtLH6aRH/R1THaRiMKEE0DtVZ+swkZIHWAwmOC3mi
	A6/sInlNt9BGF7O/mM8WY717tz6UZPJ5Xm7AC0ga9BzM7860OLjWXinD6WJWXb2X
	keDoYkoHZYyW2hAy7vrtB+ADIRg34OyW/cxLL0itF8u8wZqoQyRH9SpAzAdHyrPW
	C/cZEJdgA+oiEnTfGKFfPAH62X3X/5U8Ei1i58qDj/elwYtaFm7w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev37swd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 15:24:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605EpJ7p020426;
	Mon, 5 Jan 2026 15:24:21 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012029.outbound.protection.outlook.com [52.101.48.29])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjhg8bj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 15:24:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t0WUM/gAeJpX7dsICfL9jOvxY54FEWC/BLXfdRkZBoMQsyxTkjtW/qlQ0D5LRwL7fadRS3Jti55DgtX4NA0ErILJuxvot90bT+z2h9+pICirEmKhug0pt2jMPGbl+sFun30tIuMLw14jLmVSVnUAMGWVjH6++tTtFsctgtKKx9Rq9od5qFJVCiDFwoGsbAFOBmUXM8RlJhgtJd0/dswDDvx7X1Q6yYnlO3sKJi/RhGA5szvWowPTbDwiD2wKb8FzrG6kmuIgj5ib9vmtIbKSvyVzqJz/MDbSO1nBnVRd4Edy1lYNvkCoUvVTQJ0YU8F384DypLa202siHJBSkxDfeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugzeUG5Bfafzku1FH1ioqFTDIk9KQpBZ8yQ+sTsD7wg=;
 b=HPQujIZEk2Oo7sbQYMDn4Y3yqLu35mA466vHmYkEAUUQy0oDhdOn3AoYeHsh18m1s8VfFXk2UEVmzN6p21icRdGw5HSAD8gVapcLOKCOCyj3eUiEedLSUmehCY1bzOUygGlM2rSffo981i8dYSDg6fLQZNLBmPHMv19+0bUeQEqq/JPr2Rc6os2tuz8AUVmEZa4wjMH+As0sZkzGmpxSJKjqYnvaE3fVb+jjuAIm/Yzhu3sxdcdTgea3FuYhSYJIBuyo0he4Nbv5+D6A5q+vL+xBaOdDTzLt8ckxg8+rskbVFNIxcsU6w5yuITNQtZACrJgiD2dr6YL9qROosy2AEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugzeUG5Bfafzku1FH1ioqFTDIk9KQpBZ8yQ+sTsD7wg=;
 b=iNuMBU/wRJkLxYj+W6Xi9guDP6dRzabEcOW6U1nf/qpM57dPWpkQgUQ5tJmPE7uz/YpG6J5dqrYxFSGwMeVX4k7Oo5aGihVs6pX7FnGo3+2ruT564T0Y53/t7/+lbez7KUh7nBuR3M+TuiMjUF+abIaglVVbFcQ2x8HBkq1zSQM=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH2PR10MB4375.namprd10.prod.outlook.com (2603:10b6:610:7d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 15:24:17 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 15:24:17 +0000
Date: Mon, 5 Jan 2026 10:24:13 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Yeoreum Yun <yeoreum.yun@arm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@kernel.org>,
        Jeongjun Park <aha310510@gmail.com>, Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH] mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted
 merge
Message-ID: <qhhhf2s2vaajvr3u7k6r3vjbpx6r4ama46kwrt5xsusdoccsi2@ldazcd63kqbb>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>, 
	Jeongjun Park <aha310510@gmail.com>, Rik van Riel <riel@surriel.com>
References: <20260102205520.986725-1-lorenzo.stoakes@oracle.com>
 <aVtH-9rUDNAhjc6V@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVtH-9rUDNAhjc6V@hyeyoo>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT3PR01CA0047.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::11) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH2PR10MB4375:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f76b4d8-6947-47e3-917a-08de4c6e7d67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fjVCXE7kX90feYjV5Vpv8tTuSKvYOZquPzO3e7SWZQLXNcYuQev/dOnHZNt7?=
 =?us-ascii?Q?agbiQatBng3Kt0Fhe9gej3sEtGiMOotyZ/u5ea7ys08tn5T2QHssSSe/v3Ku?=
 =?us-ascii?Q?X0+w8tXTGOVplGkSvOyNEChYACRdWijUqDXv5EuGkf2NBbWcDeBH4nUqKpGC?=
 =?us-ascii?Q?TUIH5z6g3w1A/16HpRkK9RYvUFaIsT+qyDt2JiGnFgvE4s58fE9qN9igjPX2?=
 =?us-ascii?Q?2kYLzi8tj0wjPNFnN940JqgtLdooGJ18WZXLxeERirv5SgXlCwVI8CuE9Ubj?=
 =?us-ascii?Q?8weYS97Lk0fXyd5qwFbSdP4R3V9Bq8dFtvLQKxETWuTT3/8D1MU09E6tFCoJ?=
 =?us-ascii?Q?A87MfmL2T38aqPjR7vyn40Dye4SYnNq2w8+8zsZrOeFg4UpAWFoBUqThmwuk?=
 =?us-ascii?Q?/Oq5ivjgkD360HEMfYfDzBWyko1Rl768w1Puj6EXOKd05I4pANkPGuKjvjys?=
 =?us-ascii?Q?ul5z1HLwL21QHw9mLptV0a4xO7UtwzSHAfJpH7IRd8kD4K3S6D8CY2jwRIT7?=
 =?us-ascii?Q?EeRgTKk3FwGGO9qltlD0Z2C9VXBPk5Pmb+zNvBe7iF0DJBNao85c+1TqM1cI?=
 =?us-ascii?Q?lftkvmxjcwReduI3sswoat7ZBDEcVeWa873BZ4EbV7brO1DVSvRWMvVDA5aW?=
 =?us-ascii?Q?qiWfkElG/Ov1X53ENlkxC5OsLdBPiDiJIbwNk0iRtMUd64LltAflFjeOV6/e?=
 =?us-ascii?Q?10LPzrefvPSQio5frSBxULSQGmcXb+rREA/yFXyq44Q0Q+4Sf7PHlIJDVlAD?=
 =?us-ascii?Q?p9atl7l9sc264e81GyM4QfAfx+KO83Rpe0l0J6k3fc2A7QfPpiBGCq5gY+F/?=
 =?us-ascii?Q?twW7gswHYthcZ7pdBrw9RjYOLt86bl0XHQXuqr7CVrQ6Gu0a9ohBIjSodQdd?=
 =?us-ascii?Q?JHw1+/3IIq1s8kLaZwlBoRO/bWHE1Z4FjCqrcIvcvIF388UNetOWdhwS+mMS?=
 =?us-ascii?Q?eOnQKRIBcY4gTkGsk8mltXRdYX0/OKnj9rIigZRcsgNVwdNoF0a//KMfa20o?=
 =?us-ascii?Q?50qB449viOUdNXfnr1laesd5NxoSVSfafjDN5RIcXmD+T4uOyWgvtSsNq/u4?=
 =?us-ascii?Q?nwim0x+l2Xf/wGGqvLNkQWLxK9dU/ekMDAa6GVmEpI0X6U9381/MbwmUB1+c?=
 =?us-ascii?Q?PwdHvbMuFhyxLCyQudpmJ0r2ynbijkLfVA63ETcCPqeOviFHkkgKI0RkLdGU?=
 =?us-ascii?Q?Ld7E6C4HG7MhLkeF8bsKcNyENxIl4GpBRihKaYWlneJmxtoWK8ZzpDPhNQC2?=
 =?us-ascii?Q?PWG+JlDBJbb3SZfrFgMKfX02wlFy4QwOkaXwqXevQ5NLcvDxe9sd2/63htSy?=
 =?us-ascii?Q?IoLoa/RL5K6iJFQ98dO5Bfylb0pGcpY84CO/zZ0Zt3wYWY/tpzQSGcD3MYqI?=
 =?us-ascii?Q?7rVyW1rhAPOKS5Czt8pUjoDbvMjtEzhWDF72N7WscwEnkUnBrQyjB80zwwR7?=
 =?us-ascii?Q?gykMxPpoRjtUCQ7e4Hwe6W/fa+jiInVrbeuRLRk/FCGtxe/Jlu2QvA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FPOdItO3uFp9NVunrEQuCkwXz7ieuKEbYP+hoG9P+2fmwyhLz5MGlSZSj71u?=
 =?us-ascii?Q?EU5vro/E4R5INQkDFUz7XpfJvsMlgFj/jkkAIjo01dYG1XOXEIunFVgjy2t+?=
 =?us-ascii?Q?eYFAcsv8fnLnGC0UVqDfcRnBzgKKCCr6i26JNT7Odz+P8rqcSdd4u4N6S+K1?=
 =?us-ascii?Q?WRDMHRRHocueBX/1njQZYw5ckI2yvUf05V1Ggas0N4UAyv/FCuA322+bxeCP?=
 =?us-ascii?Q?NwG88r7mh5JPi97SfdjS6p1fPmJsQZdjhVRT5gn+ydiA6oyQWaZTvZFa/jc0?=
 =?us-ascii?Q?ndZ5SVQUhqw2+V0Vwtj5yF3wabzlhwmoiif/sKFEGlvddR6oSLTY0yr4KYLY?=
 =?us-ascii?Q?HrlXFwQ8geDbNoEPDHoocBfdayocmv3hk/uIS4b5KKFOxMyprrt5u9gB1LHB?=
 =?us-ascii?Q?Ed/oDUJ9pD1sdupgd6DiB9uElofewl6SbOTMl7vxNurPHmFiIxyoHQVjmTvE?=
 =?us-ascii?Q?jxNHpYBVjIOwR5YdMEkcw/I+3ZRX+dKBXXT1CjwvYn3a5y2ZbtOl1iiQZEdx?=
 =?us-ascii?Q?0lZ+7wTeCSG1AG0acHPANC96QJ3ORcpo113wSyOXxSBqd41gKm4G0CJvd2PB?=
 =?us-ascii?Q?uCI0Wr0ms9Y2efHYw13q8X42/Z1K+xzEjU8N5IKkAeCqgZu/GlPHNNZ0K/Wu?=
 =?us-ascii?Q?NIK20fU36FJuhlwse7fw/cE5HPvsQAVUY8yHbJw6sWURsb4YNbRjrKU0tFkt?=
 =?us-ascii?Q?BiHHxlD+ZJbJvtwhNk4eL5KbS9Slw1eGKnyitT7jfJ6LJJFlAk5hzJMBSLHo?=
 =?us-ascii?Q?X/F7LzpvrfrwUAtDPxGV/av823Zav6G83+lXJs/2atKLptQTwzLQe/d50f/N?=
 =?us-ascii?Q?/iRERgEyAkFz3q7geOTO3hvQyIKaYJyyoA9xQ0TBqcVRcDaECCXB7Mqo8FBx?=
 =?us-ascii?Q?Six/rTEuvLaFuAF/O7w0FuHn92/J/nsWVHoHMnnMbm4FHaSiMlnUh/GUPxqC?=
 =?us-ascii?Q?5D6fUoGyYOE83OohGqBb37d7kIWtZfSZ9/SHE41GzjBQcutFpLl0MvSfnJKt?=
 =?us-ascii?Q?goyPXPUC+9zkWim4oikHCDRJUj64uuEAB2YMgNR8nvh58BMYApGly8iWfqRt?=
 =?us-ascii?Q?jLbNyYGJQC5P0++LSDncZol94I9epA+GftEmUlzHKCYUnqw/BgUOoX+t5K5G?=
 =?us-ascii?Q?itZt0mRS4FM10M6raBGdyP/X6/FptGCkVHdSBhOHPgNcF6p19jpz5qNzo2kc?=
 =?us-ascii?Q?CLxsZ/VtwWRQrdmICDCwzHSn/tP/0C8WCl5qy4EdtRxYAEoHfic2yWqRvFJR?=
 =?us-ascii?Q?MFQB2TgoTJazpOsxB3gaN2Rbh8W8q4oKcDNPx6T37S2txqT3KEW9hBQ63QSo?=
 =?us-ascii?Q?TC6s3cGkL18EhnB60gATHm3QnA+S0blnHxpK2lRyS2JaBPDHS3J02hnbyN3x?=
 =?us-ascii?Q?dvH9NXTluHap0T/8expDJxJClIPHu2M0D8Cwv1yKw6PYbCwIjd3ig3xBp63N?=
 =?us-ascii?Q?CjNxkUwp7AVTGYP7v+pjCVtUIEefwykjFnWH5aGLdYt+01zH8BscBHZ91t3C?=
 =?us-ascii?Q?avvU/pA+w/XZhAOK5H5iykvD+ovJWG7FgK3VpnFcJwwgpbvkuOGX1AqpLQBy?=
 =?us-ascii?Q?nmeEG6iSxpuIA7AwmUR144xwbtY9qRJ/7ASyTxg9L9kNzF1oiwGsZUt4p3nA?=
 =?us-ascii?Q?tHwURQPQvs8mPWtj+iNiiHy97SWJDH0PCszCf1FUJqL68+LAAr6dk9P9eiJ6?=
 =?us-ascii?Q?TCpnZVdnyskwslaxGpaZw75wELG8hsxuO+gjQj68l4tc+lRtMlkfnmzhmwHB?=
 =?us-ascii?Q?cGzROrotiA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nD25rmGbFUYXr7ntmsOQsoXhYnEhfewT0CSnWzP9IGSEdko/2GpqYTVn3iSYDwdnfo0rTwcQybG04q/LpG0SSxM8wTF7lHDVYd14rHtx4T88fCRxBur6wiz6oPsu+JnZB/r4jA+An5NZrDIVkvxqdmpurhYYISCnWGt5uAw+Q6f+lNg0+6Y9Jc+YrCqPENs/nXqh8jiluvIU1KeTTotCAfjYLS0QOlnlb8Tak85CvKQgXZ4mZbkN4Z8XTDRe6lp7UsklU99yzAGTUl1ByW0G7c0yD8yTNTIJ+dakUcCeftV1AJurgjq8+PSPE/M8/+cAF1uQ1al3vGm1xMPCTj8gldK+4aTED8WYeEV/EuZ0WaJpInlu4+a8hiXAU5+TG3qnVCrKK4F0jXwveaXNxj+mi7Ev9TivIPrdFUBCeU1/rsev6d+0ldMCm3hxjdUBi7Pew1ZgcnJyyN/mkpY23QzxUEeHc1+Np8O/n33d6mIVyPiIuhaS9iSAIuhMrM6P9BbInpeoqekjfEN/djsaP7VjPtuTHP4mt/IDoDRnGkD83VVNI7MLNmIKUprKfAZ3yq3NcpqTYSFKUm0EM9H8J6LU+M/Xr92EixG2l3Wm1C2nZ+s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f76b4d8-6947-47e3-917a-08de4c6e7d67
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 15:24:16.9047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: awNm/sA0qAOuM5EPahjHBsJG3odyV/L7kVPNw3bYf/jJsZJnVuyJNYMqH9sQkPKMyLZzTQA2MwfXh8rp0BrUww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4375
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=862 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601050134
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDEzNCBTYWx0ZWRfXyVQZ2h1eiZME
 r/+aytpBWUChsbD57Uh2WV2kuUBzkazFwjo11+LPUFKdrFl30gQgGtUtTosJoM7xrvPrXoEEWvf
 /IwuAC5ZF/gpGQT2NbcobFODMr97UpU7tawjU+ycT+EXjUN96WZj+4yt97LNDnxt/PH3rVwNjRP
 WU/mS7jtPVd7Eia4sFr24jEuLNQep6uEV0T1zjSq1JNG3B/s8Aw3hbmbuyu6UwENe/RovBNa0sI
 hqqgHGBIWrZ35EB1Fupk2JMflILKNobj3j9iliLisVOB2ooJoQW2YBQpOKDDSKYbeGSFpelN8t+
 Ya3k002xEa9z92rtPY3XTV5IlQ+Px4Prn1E7lnv7c9vFMjH5+kXEWLPAQ5ZbxhH8nbhFkCTWwRE
 YDvIvsa1o06nthZ4SkhKKDpEW3GKSDc1R0DzAh0XIEnA49faUlDWEwFwuxNv6qRfHGNAtLxaJ9U
 sAaUitHO/kb+7e3Hib7AcDTF7ARTEwOoO4Sdqnzk=
X-Proofpoint-GUID: PZgbnW1citW1zG2u682gHbKSVyVzNhnr
X-Proofpoint-ORIG-GUID: PZgbnW1citW1zG2u682gHbKSVyVzNhnr
X-Authority-Analysis: v=2.4 cv=F89at6hN c=1 sm=1 tr=0 ts=695bd7a5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=hSkVLCK3AAAA:8
 a=8tiu6-A0RlJ5_adRGnoA:9 a=CjuIK1q_8ugA:10 a=cQPPKAXgyycSBL8etih5:22 cc=ntf
 awl=host:12109
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EBA42180003
X-Stat-Signature: u6pikxw8yctgdom91x1wo5oajj53u48a
X-Rspam-User: 
X-HE-Tag: 1767626668-128610
X-HE-Meta: U2FsdGVkX19qPn/aNWwGJ7Xvs3QSlU8Y0LB5Q1n84CEg0FqDhJdqCoT7Y7f3mzAmSGLpMoBA43VmAwjlbDnJsqUTMLWw0z65s8vZiC7PlnT+yrjce5P4CoxU5A7GO1R8D/5oTumvvJ+lrRtDgnvxZDo1d9qKYJ0moTjklgrhDXNqVk0uPLtw6YKrU6tOTDJ7qB2dFmfZXoD3rLaNiUCGZJ8Z8/N7lMfuCL/WMCg4cCtp/yBFV7e7ubpPsor3P0w5NaIDf0AbhlraIccY8y+TD5mOBZZ/d3+TVtlfBRrnTZ+pqioKZriT0zpmjnIheHcv6n9n+TtNVXgMnlWrQB1g6eoLMgeB/TR/Lw7tAp+QOy3EziF/RyAtw/vVpUZtT/NgRuh086UBaD/idu8vum0Lzr4m0nNietQpxhg7KkbVqxrZIKXUfF+MjVWiOdFr9G75i443GxKApG1gyF/RBqInYNrDOZipwM9SItUJWsVm0mt08aIJOS3KKaubvP/MPFmkArTPPFn+pdsS/2OuIefcWHh3T9bwNfyZK9k9jhO+qaIl96NcImCCQ4GlUQljqxrKVydW/oB/RCP+WbOiOd0A+8vVudhxokL0ohSn4qES7EW2ymVc0yW6zgdLKlcRfXS5YXymWzNT2p3jJJ6PjqUcclUztdATaWuPCxTY6olIYl7ZgOO0K+lj6p0EhS8gYI8bqceHNKP8z4j0uu4a3vJRUPZKb67qqTKS+FslVNxuBt3icn7V8D/33hIFZGF9we+1Gs95QlAqOSWn7iZNuRTEPyIsJ1AgpZM7+IPylKzQmFNQFEZzkgi+6FNJ24WqlnnME7ZLOPz5WkOzaw56JdWEjSt6J3Rid8o7kH4elOk9C1RVyXd5InHaTcTjC+xke1O84eED+qSDWWp18oUM6zDRMnYruuGzPWU/cNiZe9MnccbqABRxfzxz3+vgkpWKCC2Jtt2Iva1h+DIz/6oG9R+
 lE/2TUmZ
 in+u8+F3zBwxGwNP5zK4lmFcsoJdbC77xJpDSeAFr4eXTy3cP3CTV3tck49DZhM4LXx2DVPEHnAoxxjayRvNuXikhZ2s2LOG5Wu2lqvDGRzwZXdtL6u9fyBzVw+DaxKEQ0S9Lg3K4qab5xIb/kR/CLz7SV+TPdDvmUqJSOc/dHJkDoXQdda8+M1DLHzalgGaAv7KIsOH5Np68E1hikgIfMeruwF5k7zQ7a7rWSxsL8Qx3h30myWipQHDU7Ke3pbWDAK5L/x2x+OT9XbBILEsvSximsxov1LuKq8hoebX0/IK27/OWKoFmPJwlU9xnaxKAxoUy7oRCJrAa+ZoR1yk0lgb1xanjISoq9fUaBZ4VRX/ZZ6jnbbGTngYDHoU3LuwoDMENtaYzQd7nxo2t6DylI7P/oZeaUx2NoIk4lszLZtEeEHujhKmMJt5RuDf0irSL+9J/+G7ia1jbpfToVkN112Qz/wwqO0Rbd/seGWqIs1/X0+EQMaaA23r7vYTr32fVZnCwGQP/sadFPKRrHYwmKAIKELuQlArfuwdYS9qrRpc8ooJaWd2ZECJELaLpcFkK228FfLVMh6d1aF4RJAa+75y8taogrI6VT91dRw6fqg7pFU0mwBJcs4Un+/bz2/mNrcQKZIjwTLyXlpAukreawvR9WPcyZOsIeyEkWDgV+G1kTDdag9SMV8SxZUXd+NrXwGwiLTR4i8g/4hVkVA5OQd+2y82Jk1U/qsliqhBsqEUIWHe/CA4ApWU69NtaxweIEVjaAChDeHEiEAH5DFbdFuDwwTcziIXGZNi/yL1wozWecbU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Harry Yoo <harry.yoo@oracle.com> [260105 00:11]:
> On Fri, Jan 02, 2026 at 08:55:20PM +0000, Lorenzo Stoakes wrote:
> > Commit 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA
> > merges") introduced the ability to merge previously unavailable VMA merge
> > scenarios.
> > 
> > The key piece of logic introduced was the ability to merge a faulted VMA
> > immediately next to an unfaulted VMA, which relies upon dup_anon_vma() to
> > correctly handle anon_vma state.
> > 
> > In the case of the merge of an existing VMA (that is changing properties of
> > a VMA and then merging if those properties are shared by adjacent VMAs),
> > dup_anon_vma() is invoked correctly.
> > 
> > However in the case of the merge of a new VMA, a corner case peculiar to
> > mremap() was missed.
> > 
> > The issue is that vma_expand() only performs dup_anon_vma() if the target
> > (the VMA that will ultimately become the merged VMA): is not the next VMA,
> > i.e. the one that appears after the range in which the new VMA is to be
> > established.
> > 
> > A key insight here is that in all other cases other than mremap(), a new
> > VMA merge either expands an existing VMA, meaning that the target VMA will
> > be that VMA, or would have anon_vma be NULL.
> > 
> > Specifically:
> > 
> > * __mmap_region() - no anon_vma in place, initial mapping.
> > * do_brk_flags() - expanding an existing VMA.
> > * vma_merge_extend() - expanding an existing VMA.
> > * relocate_vma_down() - no anon_vma in place, initial mapping.
> > 
> > In addition, we are in the unique situation of needing to duplicate
> > anon_vma state from a VMA that is neither the previous or next VMA being
> > merged with.
> > 
> > To account for this, introduce a new field in struct vma_merge_struct
> > specifically for the mremap() case, and update vma_expand() to explicitly
> > check for this case and invoke dup_anon_vma() to ensure anon_vma state is
> > correctly propagated.
> > 
> > This issue can be observed most directly by invoked mremap() to move around
> > a VMA and cause this kind of merge with the MREMAP_DONTUNMAP flag
> > specified.
> > 
> > This will result in unlink_anon_vmas() being called after failing to
> > duplicate anon_vma state to the target VMA, which results in the anon_vma
> > itself being freed with folios still possessing dangling pointers to the
> > anon_vma and thus a use-after-free bug.
> > 
> > This bug was discovered via a syzbot report, which this patch resolves.
> > 
> > The following program reproduces the issue (and is fixed by this patch):
> 
> [...]
> 
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
> > Reported-by: syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/694a2745.050a0220.19928e.0017.GAE@google.com/
> > Cc: stable@kernel.org
> > ---
> 
> Hi Lorenzo, I really appreciate that you've done very through analysis of
> the bug so quickly and precisely, and wrote a fix. Also having a simpler
> repro (that works on my machine!) is hugely helpful.
> 
> My comment inlined below.
> 
> >  mm/vma.c | 58 ++++++++++++++++++++++++++++++++++++++++++--------------
> >  mm/vma.h |  3 +++
> >  2 files changed, 47 insertions(+), 14 deletions(-)
> > 
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 6377aa290a27..2268f518a89b 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -1130,26 +1130,50 @@ int vma_expand(struct vma_merge_struct *vmg)
> >  	mmap_assert_write_locked(vmg->mm);
> > 
> >  	vma_start_write(target);
> > -	if (next && (target != next) && (vmg->end == next->vm_end)) {
> > +	if (next && vmg->end == next->vm_end) {
> > +		struct vm_area_struct *copied_from = vmg->copied_from;
> >  		int ret;
> > 
> > -		sticky_flags |= next->vm_flags & VM_STICKY;
> > -		remove_next = true;
> > -		/* This should already have been checked by this point. */
> > -		VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
> > -		vma_start_write(next);
> > -		/*
> > -		 * In this case we don't report OOM, so vmg->give_up_on_mm is
> > -		 * safe.
> > -		 */
> > -		ret = dup_anon_vma(target, next, &anon_dup);
> > -		if (ret)
> > -			return ret;
> > +		if (target != next) {
> > +			sticky_flags |= next->vm_flags & VM_STICKY;
> > +			remove_next = true;
> > +			/* This should already have been checked by this point. */
> > +			VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
> > +			vma_start_write(next);
> > +			/*
> > +			 * In this case we don't report OOM, so vmg->give_up_on_mm is
> > +			 * safe.
> > +			 */
> > +			ret = dup_anon_vma(target, next, &anon_dup);
> > +			if (ret)
> > +				return ret;
> 
> While this fix works when we're expanding the next VMA to cover the new
> range, I don't think it's covering the case where we're expanding the
> prev VMA to cover the new range and next VMA.
> 
> Previously I argued [1] that when mremap()'ing into a gap between two unfaulted
> VMAs that are compatible, calling `dup_anon_vma(target, next, &anon_dup);`
> is incorrect:
>                                       mremap()
>                      |-----------------------------------|
>                      |                                   |
>                      v                                   |
> [ VMA C, unfaulted ][ gap ][ VMA B, unfaulted ][ gap ][ VMA A, faulted ]

The key part here is that target == prev in this case (as stated in the
email linked).  So we're going to dup nothing, but we really need to dup
VMA A's anon vma - right?

>   
> 
> I suspected this patch doesn't cover the case, so I slightly modified your
> repro to test my theory (added to the end of the email).
> 
> The test confirmed my theory. It doesn't cover the case above because
> target is not next but prev ((target != next) returns true), and neither
> target nor next have anon_vma, but the VMA that is copied from does.
> 
> With the modified repro, I'm still seeing the warning that Jann added,
> on top of mm-hotfixes-unstable (HEAD: 871cf622a8ba) which already has
> your fix (65769f3b9877).
> 
> [1] https://lore.kernel.org/linux-mm/aVd-UZQGW4ltH6hY@hyeyoo
> 
> > +		} else if (copied_from) {
> > +			vma_start_write(next);
> > +
> > +			/*
> > +			 * We are copying from a VMA (i.e. mremap()'ing) to
> > +			 * next, and thus must ensure that either anon_vma's are
> > +			 * already compatible (in which case this call is a nop)
> > +			 * or all anon_vma state is propagated to next
> > +			 */
> > +			ret = dup_anon_vma(next, copied_from, &anon_dup);
> > +			if (ret)
> > +				return ret;
> 
> So we need to fix this to work even when (target != next) returns true.
> 
> Modified repro:
> 
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <sys/mman.h>
> 
> #define RESERVED_PGS	(100)
> #define VMA_A_PGS	(10)
> #define VMA_B_PGS	(10)
> #define VMA_C_PGS	(10)
> #define NUM_ITERS	(1000)
> 
> static void trigger_bug(void)
> {
> 	unsigned long page_size = sysconf(_SC_PAGE_SIZE);
> 	char *reserved, *ptr_a, *ptr_b, *ptr_c;
> 
> 	/*
> 	 * The goal here is to achieve:
> 	 *                                       mremap()                                  
> 	 *                           |-----------------------------------|                        
> 	 *                           |                                   |                        
> 	 *                           v                                   |                         
> 	 *       [ VMA C, unfaulted ][ gap ][ VMA B, unfaulted ][ gap ][ VMA A, faulted ]
> 	 *
> 	 * Merge VMA C, B, A by expanding VMA C.
> 	 */
> 
> 	/* Reserve a region of memory to operate in. */
> 	reserved = mmap(NULL, RESERVED_PGS * page_size, PROT_NONE,
> 			MAP_PRIVATE | MAP_ANON, -1, 0);
> 	if (reserved == MAP_FAILED) {
> 		perror("mmap reserved");
> 		exit(EXIT_FAILURE);
> 	}
> 
> 	/* Map VMA A into place. */
> 	ptr_a = mmap(&reserved[page_size + VMA_C_PGS * page_size], VMA_A_PGS * page_size,
> 		     PROT_READ | PROT_WRITE,
> 		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
> 	if (ptr_a == MAP_FAILED) {
> 		perror("mmap VMA A");
> 		exit(EXIT_FAILURE);
> 	}
> 	/* Fault it in. */
> 	ptr_a[0] = 'x';
> 
> 	/*
> 	 * Now move it out of the way so we can place VMA B in position,
> 	 * unfaulted.
> 	 */
> 	ptr_a = mremap(ptr_a, VMA_A_PGS * page_size, VMA_A_PGS * page_size,
> 		       MREMAP_FIXED | MREMAP_MAYMOVE, &reserved[50 * page_size]);
> 	if (ptr_a == MAP_FAILED) {
> 		perror("mremap VMA A out of the way");
> 		exit(EXIT_FAILURE);
> 	}
> 
> 	/* Map VMA C into place. */
> 	ptr_c = mmap(&reserved[page_size], VMA_C_PGS * page_size,
> 		     PROT_READ | PROT_WRITE,
> 		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
> 	if (ptr_c == MAP_FAILED) {
> 		perror("mmap VMA C");
> 		exit(EXIT_FAILURE);
> 	}
> 
> 	/* Map VMA B into place. */
> 	ptr_b = mmap(&reserved[page_size + VMA_C_PGS * page_size + VMA_A_PGS * page_size],
> 		     VMA_B_PGS * page_size, PROT_READ | PROT_WRITE,
> 		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
> 	if (ptr_b == MAP_FAILED) {
> 		perror("mmap VMA B");
> 		exit(EXIT_FAILURE);
> 	}
> 
> 	/* Now move VMA A into position w/MREMAP_DONTUNMAP + free anon_vma. */
> 	ptr_a = mremap(ptr_a, VMA_A_PGS * page_size, VMA_A_PGS * page_size,
> 		       MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
> 		       &reserved[page_size + VMA_C_PGS * page_size]);
> 	if (ptr_a == MAP_FAILED) {
> 		perror("mremap VMA A with MREMAP_DONTUNMAP");
> 		exit(EXIT_FAILURE);
> 	}
> 
> 	/* Finally, unmap VMA A which should trigger the bug. */
> 	munmap(ptr_a, VMA_A_PGS * page_size);
> 
> 	/* Cleanup in case bug didn't trigger sufficiently visibly... */
> 	munmap(reserved, RESERVED_PGS * page_size);
> }
> 
> int main(void)
> {
> 	int i;
> 
> 	for (i = 0; i < NUM_ITERS; i++)
> 		trigger_bug();
> 
> 	return EXIT_SUCCESS;
> }
> 
> --
> Cheers,
> Harry / Hyeonggon

