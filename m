Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 957D3CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 20:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9682480098; Mon, 27 Oct 2025 16:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F0A080096; Mon, 27 Oct 2025 16:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B95780098; Mon, 27 Oct 2025 16:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 628D980096
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:21:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10110129C82
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:21:41 +0000 (UTC)
X-FDA: 84045014802.14.0BD3B86
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id BAEED1C0013
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:21:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=M3y39xY9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IGyCFzuB;
	spf=pass (imf18.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761596497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AvFUy1ntT4q7U5oPFZWIQw89I1nS6X43sBwT48nGnMI=;
	b=g2t6LUdSzEGsNciQIh0a+86jq8y3KjCD6fgrs8m4EZziM85XaNILxUj7j796mi1j4qwmpG
	kC1clNGur0kf+RrLLj/EF2rHP0sKmTf44huFcd6ab9pkYkI87g9iVpaw9AQbvLSEFmwqqY
	lj5em0einEmlJpkmcCPO+vj4UxPO0rY=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=M3y39xY9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IGyCFzuB;
	spf=pass (imf18.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761596497; a=rsa-sha256;
	cv=pass;
	b=TIgWnOcVTwzS3nafn9bw9xSCHm008HG8Q6AsYbuuyy9XU4g9Bbt3wR2BSLQrX1ptxivWz/
	ctCnxC7jbqYMizgDZREytK/9BCWpqJrA6/UucPQaq4EPdXDjO3zUtS8B33b8uC11OmFO/x
	NBCe7GGhz3HMc0/koYqxci6/AxnT+Xc=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59RKCLJE012203;
	Mon, 27 Oct 2025 20:21:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=AvFUy1ntT4q7U5oPFZWIQw89I1nS6X43sBwT48nGnMI=; b=
	M3y39xY9K1XyUnugxGRkF8xvNwqtEo3ctQ7WUiUexpbNfOauZIuA5y8rQlRCRKmw
	ImsWPLVr+RQxwG0nzSkaX6fWRmD3TZxnSxVwZwYJBqGQXkbhVHfHGMVY+vKuyjOx
	vgHG6zIyP9FuUJGRlcPeSzE6H+qpW318+nx+9I49ZtmLaZa1T+FgrGZC4UEi9Fg/
	Bgccz2yl8pDRiDMBwSlbAeBDWBfvB5mCkjzvkFLk4neVadNB0KEzWJDYWxtHjF0j
	+60f3EsjXKNt1WKIN3yaxPj64dP52zLbPpEzWJp4X1qxzHrcS53B8/jk7ds5Qi/W
	fg1UNBWng/HVUyuSWbo3+g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a22uu9wr7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 20:21:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59RJ0BMe030492;
	Mon, 27 Oct 2025 20:21:22 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010005.outbound.protection.outlook.com [52.101.61.5])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n0792r3-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 20:21:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PW4ivcOyW3I9oJs3TYNQ0FSwb66Ag9hAnwUQhRGBn6UUSTnyi2d0pPQtgqp7wMG1NQjQDN38jcZUDptK2Ios0W+kv/7Nx5roOCekZEsxIC3JzmWRlGqzwhQKJjajEtfYPM33YIypiaIaUGmd6cZuW/W11vdAXuvOPU6uGr0IBhxnUkqrxDj8fVbz7AfJLqtBUJ5fBtHpLH/qXTbOfDVd2bR4wQ6excGnd0zL2T1zInLKfbAFx2w2p/OxeXwGTodKlVleZKBrhNo0cRK4r539saMClPuCVG4Jj0uxX/hBPzJ/V3Ld5lwz+1qjL9yaT74ayiepRhKWd1QDmKMLScEJjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AvFUy1ntT4q7U5oPFZWIQw89I1nS6X43sBwT48nGnMI=;
 b=vBsZYb1pSi+gn3fbzYPcFU0t2/FkVbpOH3nks3WYteeHP6HpaCxBAl3+uli3dw1dLl8M5Ic9UlWOOeoHD9lmWh7p956DAIYye8RtTcFhHLWPgqDMFpPL15KM3HPPRkA5UpNSqI1t4hBdUtL962+JSl962cgafvrvuiWRMmJYFYNDpH4UfzeGGmt0EeczRjJ24GP4ReAn2xAwUtqBkiSycetwhDxZ6x83+1KFLPkr7Mg8k86G1eK+79hDOIvYT33ldDSkCFGAmcCs+LKV+NEezGSeCg7KmMdA+xCecVYvNw1FeSonPIzVw8UrlDjLV8QCvOQmwSJmTnVcerc21zlKRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AvFUy1ntT4q7U5oPFZWIQw89I1nS6X43sBwT48nGnMI=;
 b=IGyCFzuBqPtujhtBOC4fnHgj2BezbV7hjY8LWym+N5f716Ts1XqP/fZ1+El+Q5c3uw0DPNyu2qeUTwKKhSa/S7JHhO5qRRhQuM5WXj4oLhj8HtbYjAI2oER+Ifnyaa4sdOYQuzhooF/xtdR/xJraH8ll6yfb6ddHS7MY/hh/Cis=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DM3PPF1A29160CF.namprd10.prod.outlook.com (2603:10b6:f:fc00::c0d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Mon, 27 Oct
 2025 20:21:19 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 20:21:19 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v8 4/7] x86/mm: Simplify clear_page_*
Date: Mon, 27 Oct 2025 13:21:06 -0700
Message-Id: <20251027202109.678022-5-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251027202109.678022-1-ankur.a.arora@oracle.com>
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0079.namprd03.prod.outlook.com
 (2603:10b6:303:b6::24) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DM3PPF1A29160CF:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cef91ea-87fa-46d2-b9d5-08de15966364
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SIw3lUpnbuab6zbvX+EQ+Ahw4fAR9IH4koooo06vimxPnhj4pokiATiLmstl?=
 =?us-ascii?Q?Lo7iIvaGIWJ1u3wfz78p5gb6TNdbwbfT3VfDMsE4xmd9/w5F6HfpRjtdgUUX?=
 =?us-ascii?Q?O70ehlvosihpiJ1pKYQC73/1qBxaolhu4VkBlB4ntQXrSOKAvu95dOzyiN93?=
 =?us-ascii?Q?U2zPT76MpYzyBjGSHvLVuFex7Kyj8zTDeKHv2fRmcdudfcOX2tFOCe/0Vfnk?=
 =?us-ascii?Q?xq3dWn6qYwtpQPmfIXRY7DE4SloT2YsHexj/VKK+mtloMwok5EjsrPR/dEIR?=
 =?us-ascii?Q?i3aY0TiYJhllmhtjYl5EzHnC+auik0F6UwU3/aaumHr8+cx5yQuh1sca1QbV?=
 =?us-ascii?Q?FYoCxF8/JUip71SeVv5y47RKAfJoY21I+elt8OlrUREnJAJNMxvv23t3DCPu?=
 =?us-ascii?Q?AGKyajS4IRi5wA9DiTa4azdchCaezhL6nvLBat62SnXna2hIkxTrKO0l5rRW?=
 =?us-ascii?Q?+j8ETwjdP3mmCoFwCtlNASLmSK/ZyUaZfCMGfD8D2QNTCCUg+bOgNFXVuWvJ?=
 =?us-ascii?Q?pKLwnnysUmdOksVTrl5lFbzAv2aX1VhD0WE5psYtKi7p7xrJfM2rIhfFdynd?=
 =?us-ascii?Q?I9rJIykvJUXbJ8EmXQkmqs+tx2zF/GQ7zJpcQLY8zbgW6gjcCsMZEmPx0ksp?=
 =?us-ascii?Q?T2FRY3HAB/oea2tp006w76LIBYOghW+Lu4G5OtNaI28cE70+OcvMtDegmOYD?=
 =?us-ascii?Q?ywggBlam6lIfXPrbnckZjOzUih+I7jGrSTOQc723bKtPXwWder3AupigenUX?=
 =?us-ascii?Q?4/HoM/quAF4aL12ky/vjWy82SbqRExm+HDiRBSlui1WYy0lqtfRv7OmrERwF?=
 =?us-ascii?Q?WvaLqcjuUjRXFRpBjfA41xAAwiloAnZbBE+AYmUiKer3E2y8McKnNl5YsZ4n?=
 =?us-ascii?Q?dM0Ulg8yLfKgMZnpw3J20aFHG60qXlQ+nfqfhLyVTDrjxf09ViBVRbUeFuOx?=
 =?us-ascii?Q?Zh3v5c8ZRrT9xMtDWrRPzXbi8hM34aFVtzbd8Gbgl/tR3aFynedRDWjMV5Aw?=
 =?us-ascii?Q?9cqQTjr9/pXwhzvUkvcnQt45iXcU3LNB2/26Ed7peRi3bDgenA/AijVlmp9u?=
 =?us-ascii?Q?5AR4uxzb2eKTxj8mo9ZYCnoCYu/l9rNEsMy6Mpy+8IkTJiaStTvE9f5tVjtj?=
 =?us-ascii?Q?g0XiWFIzociycN9YiPsNqNVdQwGZ9UTMQs0j4GYGpkeWrpjwrPfyxDDotiOr?=
 =?us-ascii?Q?0oVXT27uQA8sE6mGCjaBU+ftaYjr1For1J/KukR8cxPHbhvhUdWXivLc/1ZH?=
 =?us-ascii?Q?2TOy2dl3UpxIqblQEPc7cRwZbWCYUEpcAv5ROM2FYQBQlYmCzEp1dxD+beai?=
 =?us-ascii?Q?3m2fC0qd4SAdWokpdXh1L5Qo2g6YfepzBaiFBRDCM53kRva7Jwvn8vQxPxlp?=
 =?us-ascii?Q?3mBPjPPyCcM6s3MLLAb9rW2PWOAdCVpkwqMHwCpw6k3cGcVxby0phOBzR2Ph?=
 =?us-ascii?Q?Vyej++qJY5dncAXQZLivRgGVg7DluwC8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vyCrMbkn9h7OuGB4YI47nTifFtTBo5q2/JUm47YxArTnOSbT9vst5jY/rD2l?=
 =?us-ascii?Q?aAeRIkQTOlltSWXJJkgGDbyz7W5R+xDxP0NISVEmFLrh0E/y7uO3jWmHjbty?=
 =?us-ascii?Q?76KItqUEJPH4u1GYm5picN1RNaliY0yGMCpWpInpO2nNEO8DZ7twYikgzrX3?=
 =?us-ascii?Q?mELHFJmaUP9VqInwKxa6zVsOQY2AEiUtuU+3PYrzDBsXyxaRQ1eIs0ZQourk?=
 =?us-ascii?Q?oP6komH19y7bGBCFU12D1S0y2sgAiOqfbqnKOsy7DhxUqNhD2gGu/VRC7RtL?=
 =?us-ascii?Q?QmYWW/TJcCjHtHf3D0BHuMaFcj0ndSGO0JyX7ZdyXdNu/Szwaxul9jbfcWUG?=
 =?us-ascii?Q?/ehNw/91cXdf0DgfThAvYnkUbKYrtPfigqoo+M+6dmmxhPXhZEvxqm/LQlBp?=
 =?us-ascii?Q?rnX5C6Y6lVcC7ZDC7BU4+szGgwptpbg902j44MdxWU3C97QpmywNy4CC65bz?=
 =?us-ascii?Q?5KAp0dUB2R2MgtB/adsbB/hkq267BJMJJGVbvedA4o+UDlv961tFZrak+JoU?=
 =?us-ascii?Q?vbPrX66PQ47gXKUrcnKkf7fYmEYUZc7wHvW81PKH4KxUWbvj7Fo9o9pqz9my?=
 =?us-ascii?Q?7ZHiUDRRePJZ98QqsqnSJjcUzUZ0AYStSJhtO2eKMk/HXGbgi5ghhnu86tSc?=
 =?us-ascii?Q?9wkh6TlAVvGMM8wNFHVsLqi3e+85MhjV7+1eBPoEIwncLvSPJXvRO5JrbF23?=
 =?us-ascii?Q?rmQvSFPKLIU1UxwDZ0gxdEPMbn7KBOvxxKG5Udl6HObudaxk8sw5aheBDRjY?=
 =?us-ascii?Q?PucxpzLMkvxkwiGLCITFwZAbaITSFBfydgOQCkMq8MuO0Z/6y6Z62ZQ93CXo?=
 =?us-ascii?Q?sWUL34kHaHobHUNv+FK4U9e+e7wHNmFGKIuZueHh1/nVVf8ql/TjEGfQ0S4F?=
 =?us-ascii?Q?F86ZcbxkzL8ax2d4c8+MZ1FavnDN4/5FVxf5gGNjkoIDAapDnxDNYZdGh01h?=
 =?us-ascii?Q?YbVIz0VoFbZyMuwh1LG1/M5T0vZynxrJYM3UI5bQrLK9Js5EQM/YeP6w3dlP?=
 =?us-ascii?Q?xAUXbLPgvHHqaKJhIFME/5vnDkNNaMmTte2L9lZtiYGGtFn3shbe4rxL9nR5?=
 =?us-ascii?Q?OzaKsldPWjKyLRv9RfsLk1O4qHnSe1oSahMBoc6b3XnbV4KtxfwnuosnVcOU?=
 =?us-ascii?Q?cv/QvYLzbUlTLvV5TGtAhF7gGQGCmH8+KYd+xHlTD013+uF37jpjMgFVbtJd?=
 =?us-ascii?Q?B9Aodt1m8ASAuGt80ZEq9/Anf7OC0uJhW/1gthusosFo+oHol92FydvbK1Q2?=
 =?us-ascii?Q?f7jx/N0ftM3N9kOQOWFOCX7Py91LIS4RYdnEZjMiSOXd6N9YiODtg3EJPb5s?=
 =?us-ascii?Q?6ZSOsmh8wrN0ZLJ9x3A9BGRxA9MF8XA5fMB7MI4msLK14ZMxcTktUHXCOHWN?=
 =?us-ascii?Q?XyyDSeHGOsblMgfJGhOkV/l4hn7ANKhwPM9iOY2lGD+gQElfz1JP1gK679P+?=
 =?us-ascii?Q?em9kVelbcT5CWR4ekxRKnIAnPizX8PonT8nFUD3t6L+t2wydtrEGQEOBxQMC?=
 =?us-ascii?Q?DBZZK3bjc+SfWVY+DnKnHzMmpS3f9RmHcS0451bMqIgelgP8R6tJWueyokm9?=
 =?us-ascii?Q?+wKCQGfUM/ZNKTbfXWnD0w9jl5l6KiIXAkpSJ79RIvNAC6HOdhRne+vhN0Dt?=
 =?us-ascii?Q?3Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lAjsm8Oir/EWOkbMFD6Mc+5cczyCXaERUWfLAzezyi5vbtWxJH+24zf/NvZaX8xFfgsfn+sTm/nSe7rwjm/t2TLBEuTOoFt72G3qOQU3mIJ3fAYBm4rbODwCBaiBFNrpPHjTERQkYS7H1rLary0mzeL0Xwrdppn/EIiGNYSmmn/OxFizsPkFsiEe0+gx8mdmLRPuZ+dsd3fpENOxpMEuiyciz7mWGQTWkhKKV4VkFKwqGmZ12i1En85pnXdt7BKyeKJb5oG/wnBCAYo0aTOZAy6CkAWAc51RMcC85m+POAcWEF9qUxmyIYHtDX3/q2HDJL4EVIteS+LlMSNWgBDxj9AaNCLaXCC1pBrBYYAyaICBgUz+SyAxEtbRCEfld6XNoZz8qOQ9HGVNNZSS+KVGtYI/HG55nHgoBA9HlVCGefRJp13IukmTffN1VKA8FE+bqeJpSCHrXiwbBH856Jd0ttkUWcp7TcTqZvU7WYXUEfVDDBRYBMp/BSR6UwKluKfzrO4NrMEM14oE0ONNkfLOMTPe1uBbPB2DRqFWWYzZ2gSOoeBLrxl09t+kOjnPhqEd8EeT0fa0qbdmOX6n+ny6bJycrXPLLSDlt3fdLP540+8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cef91ea-87fa-46d2-b9d5-08de15966364
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 20:21:19.2082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: abhgGwvRqS3BGZfHaPSIEjmiQ4C4/qA4wl6eDYJCxfGvRYoj7MDOoIP4kvCENNdh9X6SBOCzu8VtLziTrZLHlf9zPmyDTL0Q+5+gcwRVQqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF1A29160CF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_08,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510270187
X-Proofpoint-GUID: WY4Kbe_H8p_T0_xHvuKbOZcAzKxephyY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1MSBTYWx0ZWRfX4SogZaBIxS3N
 wBFMKjFEbEYw7vDnH738Y0EW2yb7Ufq64LnPBLC9gqrGU6NWvUc/uoLagay1EAL8wCWi81bu4si
 8DL+586H44/yUrMAj7Bqk3+ueEoJdndI2+p3rWdH4kmCJ1pZ5QLj5XEq/83j87CCbkpvfJagFyg
 JmcAQnpiJWufYHLaO9pdBceQvsHrowz5g+jgSanq3hX9asayzlTxGcybQ9+GSugklIhwRSrIx96
 ZjEuImhy8mVM/jSckgHPYBywJZlBUSEzGJMD6lRdX4jCV1Algnzi2ZwmfMBOLbIyfHNsBbUbfJ8
 QYZuwLeOB993Y5PEOY97Hl9PYzSlZXInsBVUqZLAhEd2fxySK9zANEwWBC94XVTXt124xYJqbXA
 gf54tLOUvBVUPBLg+A2Fj6nVgtU6Jg==
X-Authority-Analysis: v=2.4 cv=Xe+EDY55 c=1 sm=1 tr=0 ts=68ffd443 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=zd2uoN0lAAAA:8
 a=CZTfYOs-HqEX1FBfxHsA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: WY4Kbe_H8p_T0_xHvuKbOZcAzKxephyY
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BAEED1C0013
X-Stat-Signature: shc4ip46xmksipboywxf7kbac8bqsjae
X-Rspam-User: 
X-HE-Tag: 1761596497-88290
X-HE-Meta: U2FsdGVkX18+IUFRGD30HyKlDL8FEmvVcr4mZ6Q3W4kpEmv0rWt5rIWd/3hFALwiNlFJchxFv6oKv25MB2J0Fdi3MkJTXOvDEycUGdpzP1DNRIOawgjSEJZ+4blHTzJcXeZGpE1TkGG6Sea+4vG4dvnvNMykA19DDyy8fWguqylUiM5txDqYSGvLURH39t/7utpKMV1WxnP2AXG2867LVpBXjiIKQMSdBdQor7/fXUvHwY2bjURUP0czqK6VfOQ6zqdf2ZzLVyBe3wPCPYtuWCN2bdZsiee4Mzt6OAx6OhHLxKo97C8NpQw4ZjDGgiJXyRZFOj3DZ3lUQmW3zrdqbN2OxACblRBhb7m1TvtgkKEO98heZi5UQ5iA66zGwzwkgu3degkAZksPedSe+vTFdUXXmD9LBnF3CFXaycQUoEKCg3DwLFgRuP1tddlClHbFKXc6Z3NW9kLgFJglSHu6IeujA5y5T5/4XUzR30OPXmZJzWRuyvURbRsz+Fxqm9Qw3e+UVqL/6597o7U8F74T6rx9WGLvJbTisMuf8KT0eXNc757WUD1DRFqMxTESic/1H2yNNrlJrLVRj/+fjGPAhRHQSSFFo2vKKTuVySPacRElbVYtAPk4e7Bo8J+pLnS5aJXUrZZUXyRYw/q6TQ2QT+i4IWH3YCJh2RblcrFLuWFoVpX0kRnpfqBY4u3h8bF2T+na/pmHadZDpm8TTvFhaaHujQzNbaReIkziLKxHccTXkya/72A6+vL8ofT3K9kVM1W9DguWpucNkrTSfq46joHnLK7LcWkhH8s0l3MAmHwyYbCzhpRBf7WwQtg1zA8pEWkuoiOvlqL0DQj8VNyPMX0Y5bq8QWXvW7dA5urpbQ5PbPRip40PNDeoG9XraRmamlwUPOcCsVK1gEKFCtClGgAQXDYLgytsKxLNYopyBZ43nTDYqz1Ys4lL3+QzJTc2sWa5/enezEi/rA6w1xj
 jNEIifZa
 iy0AT8++djW77OEFb7VcDmxMTXYav8OCd9UnXCU2U9l47bcPRoLWKU0932xR52CQLtD9nFGdXh/yRElRtTDo1tH9uAM+rnrijYUpvjerCu2vemij/nAVBqDaGjW0CFZi2q7tb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

clear_page_rep() and clear_page_erms() are wrappers around "REP; STOS"
variations. Inlining gets rid of an unnecessary CALL/RET (which isn't
free when using RETHUNK speculative execution mitigations.)
Fixup and rename clear_page_orig() to adapt to the changed calling
convention.

Also add a comment from Dave Hansen detailing various clearing mechanisms
used in clear_page().

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 arch/x86/include/asm/page_32.h |  6 +++++
 arch/x86/include/asm/page_64.h | 46 +++++++++++++++++++++++++---------
 arch/x86/lib/clear_page_64.S   | 39 ++++++----------------------
 3 files changed, 48 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/page_32.h b/arch/x86/include/asm/page_32.h
index 0c623706cb7e..19fddb002cc9 100644
--- a/arch/x86/include/asm/page_32.h
+++ b/arch/x86/include/asm/page_32.h
@@ -17,6 +17,12 @@ extern unsigned long __phys_addr(unsigned long);
 
 #include <linux/string.h>
 
+/**
+ * clear_page() - clear a page using a kernel virtual address.
+ * @page: address of kernel page
+ *
+ * Does absolutely no exception handling.
+ */
 static inline void clear_page(void *page)
 {
 	memset(page, 0, PAGE_SIZE);
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 015d23f3e01f..df528cff90ef 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -40,23 +40,45 @@ extern unsigned long __phys_addr_symbol(unsigned long);
 
 #define __phys_reloc_hide(x)	(x)
 
-void clear_page_orig(void *page);
-void clear_page_rep(void *page);
-void clear_page_erms(void *page);
+void memzero_page_aligned_unrolled(void *addr, u64 len);
 
-static inline void clear_page(void *page)
+/**
+ * clear_page() - clear a page using a kernel virtual address.
+ * @addr: address of kernel page
+ *
+ * Switch between three implementations of page clearing based on CPU
+ * capabilities:
+ *
+ *  - memzero_page_aligned_unrolled(): the oldest, slowest and universally
+ *    supported method. Zeroes via 8-byte MOV instructions unrolled 8x
+ *    to write a 64-byte cacheline in each loop iteration..
+ *
+ *  - "rep stosq": really old CPUs had crummy REP implementations.
+ *    Vendor CPU setup code sets 'REP_GOOD' on CPUs where REP can be
+ *    trusted. The instruction writes 8-byte per REP iteration but
+ *    CPUs can internally batch these together and do larger writes.
+ *
+ *  - "rep stosb": CPUs that enumerate 'ERMS' have an improved STOS
+ *    implementation that is less picky about alignment and where
+ *    STOSB (1-byte at a time) is actually faster than STOSQ (8-bytes
+ *    at a time.)
+ *
+ * Does absolutely no exception handling.
+ */
+static inline void clear_page(void *addr)
 {
+	u64 len = PAGE_SIZE;
 	/*
 	 * Clean up KMSAN metadata for the page being cleared. The assembly call
-	 * below clobbers @page, so we perform unpoisoning before it.
+	 * below clobbers @addr, so we perform unpoisoning before it.
 	 */
-	kmsan_unpoison_memory(page, PAGE_SIZE);
-	alternative_call_2(clear_page_orig,
-			   clear_page_rep, X86_FEATURE_REP_GOOD,
-			   clear_page_erms, X86_FEATURE_ERMS,
-			   "=D" (page),
-			   "D" (page),
-			   "cc", "memory", "rax", "rcx");
+	kmsan_unpoison_memory(addr, len);
+	asm volatile(ALTERNATIVE_2("call memzero_page_aligned_unrolled",
+				   "shrq $3, %%rcx; rep stosq", X86_FEATURE_REP_GOOD,
+				   "rep stosb", X86_FEATURE_ERMS)
+			: "+c" (len), "+D" (addr), ASM_CALL_CONSTRAINT
+			: "a" (0)
+			: "cc", "memory");
 }
 
 void copy_page(void *to, void *from);
diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
index a508e4a8c66a..27debe0c018c 100644
--- a/arch/x86/lib/clear_page_64.S
+++ b/arch/x86/lib/clear_page_64.S
@@ -6,30 +6,15 @@
 #include <asm/asm.h>
 
 /*
- * Most CPUs support enhanced REP MOVSB/STOSB instructions. It is
- * recommended to use this when possible and we do use them by default.
- * If enhanced REP MOVSB/STOSB is not available, try to use fast string.
- * Otherwise, use original.
+ * Zero page aligned region.
+ * %rdi	- dest
+ * %rcx	- length
  */
-
-/*
- * Zero a page.
- * %rdi	- page
- */
-SYM_TYPED_FUNC_START(clear_page_rep)
-	movl $4096/8,%ecx
-	xorl %eax,%eax
-	rep stosq
-	RET
-SYM_FUNC_END(clear_page_rep)
-EXPORT_SYMBOL_GPL(clear_page_rep)
-
-SYM_TYPED_FUNC_START(clear_page_orig)
-	xorl   %eax,%eax
-	movl   $4096/64,%ecx
+SYM_TYPED_FUNC_START(memzero_page_aligned_unrolled)
+	shrq   $6, %rcx
 	.p2align 4
 .Lloop:
-	decl	%ecx
+	decq	%rcx
 #define PUT(x) movq %rax,x*8(%rdi)
 	movq %rax,(%rdi)
 	PUT(1)
@@ -43,16 +28,8 @@ SYM_TYPED_FUNC_START(clear_page_orig)
 	jnz	.Lloop
 	nop
 	RET
-SYM_FUNC_END(clear_page_orig)
-EXPORT_SYMBOL_GPL(clear_page_orig)
-
-SYM_TYPED_FUNC_START(clear_page_erms)
-	movl $4096,%ecx
-	xorl %eax,%eax
-	rep stosb
-	RET
-SYM_FUNC_END(clear_page_erms)
-EXPORT_SYMBOL_GPL(clear_page_erms)
+SYM_FUNC_END(memzero_page_aligned_unrolled)
+EXPORT_SYMBOL_GPL(memzero_page_aligned_unrolled)
 
 /*
  * Default clear user-space.
-- 
2.43.5


