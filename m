Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92B46FED2C4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 03:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9DD46B0088; Wed, 11 Mar 2026 23:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B52746B0089; Wed, 11 Mar 2026 23:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2DE66B008A; Wed, 11 Mar 2026 23:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 91E656B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 23:35:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38D211B884C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:35:48 +0000 (UTC)
X-FDA: 84535996776.13.7499C46
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id AA17112000F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:35:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="JQVV/ZF7";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QCqXlvLu;
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773286544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NrFTn9cyksTY4bOpmp13MKtXOn6TGXhChgUaiQKRKVI=;
	b=gYoHJaayp5IbW6p+Bnq6LzW4Tz8+Q3u+eS0M6Tn3odwCVyluYtMVRdd69GkpkAX+FdO5Ux
	mZMsHRaxR8iNpZjfaINrBa9yWi11juYrKU+iseTuiSjsVJBsWmB8fW9pMqnprjLl+tPxq2
	e8fciuu3vNHxjRHSFt0Zgr21H9FqVP0=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="JQVV/ZF7";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QCqXlvLu;
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773286544; a=rsa-sha256;
	cv=pass;
	b=kAlYB3xThUShe7cE31dTKpCT3O9LlSSYcUyFVhihQUwoof20NFT9s5Ug2ZiTisB5wMTwfQ
	OYGhiKS16wfc/butKSW8+EX3a2sW3Xne+baJ2iwpKpHmQWz6QumyhVJh/C0gX7lO6Z4J6F
	TV6lETh4UED9B7sgHOT8QR+Xv2ShJ84=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BMMXJ43506407;
	Thu, 12 Mar 2026 03:35:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=NrFTn9cyksTY4bOpmp
	13MKtXOn6TGXhChgUaiQKRKVI=; b=JQVV/ZF7XDmWiUm5aPcVfidVFofNzP+rGG
	ZaBaxFtoZz09hI5A3fQSRIhqyWIA6M9kXTx6cMcEx+5W07u5VE02xzGt8QO+Yqh9
	EsxJMVolBCfNUrnEjZ1nfcP+WMozgpw9RXxhvXFn1ccvmIyUPwp9T2jH13Xt4viw
	gttj9qUBPjBG256y+CFutHBBJpwkJ8GQZGOLYFiLZFk1jaGAyguGRCp04XhpFuVs
	Inf0YmQtS16cstqohk1kY3MbJiMy/HEX5Q/GQpQzkwvAIL9vAZPB3yY6MDWV2KfK
	vONXdWPold6m/QX/M1W98hHyPk2zTUcTH7nOTuSamLVhSl/prnsQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cuh4kg6yk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 03:35:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62C1piZs032960;
	Thu, 12 Mar 2026 03:35:37 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011009.outbound.protection.outlook.com [52.101.52.9])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cuh5denqe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 03:35:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eQC5M1ilAqbYUGyRwqU4bern6GgkDU5jm0G5VIi1/y6b5sHqovsLWD3SPzkAAa6MnRxQSLuNg2qwYjw7SVyEb1BvozeZd4jvbDEqGsTzfCnhEukxvJRaJTbgrvbgZp3dcphtZWQM0Zs3lucq0wlv2tZXgaXCQwxALA3fdxUsTYSyv+mOkQ8P5jMDJNmuewpqsgZMIiQd74wgblc5a/lU65zdfmrCxLuZWQMZLvco1sV7iVIcseA7XCJKfnp6FvKukfaHdGYZo5PE886xIx4uQUogNBTyxveqPp40+IE55PwOXG/Rf2jKgGbtJK09SbHAnZc3vOfbb6xBkr5ykKDtOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NrFTn9cyksTY4bOpmp13MKtXOn6TGXhChgUaiQKRKVI=;
 b=LUdAyBdbcGOb8QlW1YtSmJ+yyfenlVRothlTz1mEbuNVmJDefoGuCMG1jXET9mVLXfELyIig05xSWLHGu9+qsjgsTt0eWSC1yviR5rr0+FKh9PeVYIOdjffAM6oAlGVTAnB7rEnp1J4ouNKilV8uyPxOPX6gwByGk3M60G3/nOFy/bgFD3SKpoiKoF0D0+4zvGLwsKdA4DRnKEEq+NNg2Kl0+/635Pm24vuKK0zxXb12TluSURMs/Qbvwqom4PNJKX2VVGgVUQSWJoP/E/A32KjT68IVcR80LMd1IHm28fZBJCzQ5k4kwzvAdIuJElnNqM6JWo9HdmvskVSn6J32fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NrFTn9cyksTY4bOpmp13MKtXOn6TGXhChgUaiQKRKVI=;
 b=QCqXlvLuwYS5LSrNviMyU867w8C9Jiy9v7V5jHvu2pzJ52ICf730Of1WP33e2XXNfhrp03hbzzNvIqgXc0o2PNbkFogIty+pv+EuiqoCcUO9qBJ5woRBR7lS5L43I250o/cVmcApKgQVCTy3SrehPCF37Cn0nncAQUB2CJZ9ijc=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CO1PR10MB4578.namprd10.prod.outlook.com (2603:10b6:303:9e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.13; Thu, 12 Mar
 2026 03:35:34 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9700.010; Thu, 12 Mar 2026
 03:35:33 +0000
Date: Thu, 12 Mar 2026 12:35:27 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qing Wang <wangqing7171@gmail.com>
Cc: akpm@linux-foundation.org, cl@gentwo.org, hao.li@linux.dev,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, rientjes@google.com,
        roman.gushchin@linux.dev, surenb@google.com, vbabka@kernel.org
Subject: Re: [PATCH] slab: fix memory leak when refill_sheaf() fails
Message-ID: <abI0f42Yj4A6AOUM@hyeyoo>
References: <abFWmVU6hgqiNn25@hyeyoo>
 <20260312022142.528493-1-wangqing7171@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312022142.528493-1-wangqing7171@gmail.com>
X-ClientProxiedBy: SE2P216CA0040.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:116::6) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CO1PR10MB4578:EE_
X-MS-Office365-Filtering-Correlation-Id: bc535c36-8aa8-44bb-76aa-08de7fe86ae6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ogVG48pSb+z++2oEpZ3JTCS1ou1I/Z2QXFYowSS48xOblF0VCYtKGpX1zs0ScWzJmBa0U8pg5CR1N3i7byKqhtYkqNqRI0Vth6yMXaJxynwUHicIhNL08G7rL/yEM8j91fEcZ6nIwtIOkJ3fHwoQc3YtPHWvl0bMOPUWiOlvZO6e5obpA9uWQ2fCz5hX+URByLIRczZWj1MAjMPEQdZCIi8GuPUXkP6CqryBXMbdSnaqkAPyJzu8NfcrHOEkUyBX9fP8UGqW7bOMAKoFixv/KTUUsGmZ5+n2rBfrV+K+HdnaD04bqBmLbH2HuqVHCi6JyUKRhDKad4Wuk2odT7yii9+9JR0dXoYYEbewDOrd86iuaDlaitLcHRadsrKXqUtC93bfQFK4MFiplVMjBovYcKMYbCi/mlyBqWEbqIkm60wk4l+N3UcsoPda12dfZA/KsoT72bkw2f9iQOrHF2EL5YGSomAdgzK/zzzabduy5qZIKAIRejWkayI9Wykk69SvkrwP3u00oFOAkrlpLnueu0CRnUCC2edOR1CsnTa3979/gAsaAoUv7QAV1KNEl7fRWvdfDea/rp9ipvtorxGR8b0PkyJweTaAncH3xNVqcBWBVjnaSXayE6KgTcam0RY+IZdGjKr0XKANIXNZlFYUCISXqTVhyA1Hcq8H80qYft8mfFleXuKuuolJGUywf53dVnW8CuKM2lTulILVjrCbNu7UtFPU+5HFm918+OReYSw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x0G7NB4o/7EKPXsCuv97YRGiLlObYg7smkieyU7oHQsjO3YWb44Nf+vUm8Q2?=
 =?us-ascii?Q?pD/8i2G8oSrqt3+LoGKatklIciR6eJ6clEfYeTpNcoarTiiOlxX/rUXYhnMv?=
 =?us-ascii?Q?gmT+UjhgqtJ80nnB8bHTSud7s5pYCAdyHv/DKgyS5G7McemV25stQzM/Uy5x?=
 =?us-ascii?Q?GfARcdAKeoR7TptR+16ws/adqp0+hxU1t0bYhG1NFg4HIK+3aRFTjbpQ/oPq?=
 =?us-ascii?Q?CAKm9ju3GG7+t2yKDA1yaeHZiXL1MQaODVw89sZ0Yi8g0yCanqj/z3KNwdUQ?=
 =?us-ascii?Q?PnfEeVN457huBx6MbZVqI2G6h+IzkoiPyQSTUvAYC9v0JT9QFoij8TtzC9y7?=
 =?us-ascii?Q?7H3zfZPUs/84VMj9O7J9sSi79PNpaXfIJXDmLGLTOO9ezFs2viGC3ticbTe6?=
 =?us-ascii?Q?sAD57ijpqgSgcXsz+n6Zk3NHqecTWWRdtQLVuqLBEhZR64OJjxN+NLjnC7Fv?=
 =?us-ascii?Q?rVitySolz3iURlMdB6BNrh5gMn61iZxa4FN8XpgjM82w5pea5nWsQIe3PU3z?=
 =?us-ascii?Q?nPZOWJdHp0CqsL+6Y4mMAap8V1dHbFPZnhoUnutw9kbqBknr066Nak1CvGsc?=
 =?us-ascii?Q?xH/NsDau4fxaVz2m420f1o+lcES4iCFK10TDiDoORP1vDNmnoLef0ajtnuOJ?=
 =?us-ascii?Q?0W2KGNOriTZMUmcmHLDIK74EQ8Tv07Wjgnpd/Dp7U1GQNk8ET5rpmguGmp68?=
 =?us-ascii?Q?ZW2XPWdiDem0KpVNVlVVzD1h3DRPTItdhgHBDdbLaUApUjnUzlrEjDZuo1U9?=
 =?us-ascii?Q?rDkliu4j4ZQys5eejgmE9/B3iTaQVRYeZqVEl+wvHCWbgDwU8eh8DXX58mEv?=
 =?us-ascii?Q?CwfGQvrAlBHEcySq2LWJu+wHjbHvCFa5zxvZQliEhbl9/e45dHWr4Ovqprkn?=
 =?us-ascii?Q?b/tLsPuiJD9zTwQgRwsiJbyNGPjcfDJF87/bk+T1GfH2ejAKAowIAO0Xg/iY?=
 =?us-ascii?Q?SvQG+LaByF38PnTHm08vuh1xC/MUk0Lj5/nV9IAalv0KqCG78ITGLjeXpSLW?=
 =?us-ascii?Q?HMiVIwZPgWmeVCeywJmNyLuVnyFkgsylLFNcOAlk0cOMib3+RRS9668BMB0l?=
 =?us-ascii?Q?OYAy2FxsvZDhneSOLqCnhxO+cPMicx5U++ZIl5ElmrRJMO/wRfYQix2Nua41?=
 =?us-ascii?Q?7RWz60ewrGKdzNaJ8mGk+GmfutpejsoCDPMoe7kn1w2+3YHw8BcRLoMZLxSf?=
 =?us-ascii?Q?VtC/JbYoPMfgqjxzzay4ZbzzNFyWpzrCjgAPMbRtQLX0vSIRgpLAKm/p7n2u?=
 =?us-ascii?Q?guL7LA1rRev8eA4dBGMMUX6oXGbUowUETVR/BI+WfpSP5/J9CrE/hvm81Hmc?=
 =?us-ascii?Q?h4DG7579iBuVqBXNZ374q/J+2zcP6Un1OmWT3ftWvo+19Qsbq4vc+maB/UFa?=
 =?us-ascii?Q?tzsbKvpsvo2Q67BMM7rc7XouOnntgs5LoHBpl3mp+Hnkr0wNXtzVpMMXyIKZ?=
 =?us-ascii?Q?1Y49tBi4sVIoOOX/O+kXXZo/mrqbHsDT4TuTcuqUoFaOlmsMpkrBS3ZCJ23s?=
 =?us-ascii?Q?WtPGtzX13WajM++I/EEotyyF+72mNJKmpHYAAch5j7ZLfjlmiKRC8LjZ+clA?=
 =?us-ascii?Q?laNQRCtTFl1NuZKfKRDmoQA2GxgWgFVYua5fTQw+OkGkTZsO3/fBcIm/eZO7?=
 =?us-ascii?Q?ZgRWsxq2H8jxlZcNWFfHwPb0N2v2S8zXDmd0gLt86bZOqAQ15o1LcFB0emvD?=
 =?us-ascii?Q?1TcQjVki0g4LVVPbuMq7YKkTa056bz7iTnpBdWU9ed3qOSJ4heZ/yUhTPfDV?=
 =?us-ascii?Q?pPiU3PEgyA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	C1WiSa5ueXy+SFtzCVvIey3H+TGIlLyrzp2m0+YwgmYT7ydLA9Zmtr4AIR6VhEr1JNvcSIIP8Q4q/6e3P39Ti/G0LJiLcqGP9wYsBfj7ywcWKBudqyz96pa6L5H98ree9Niq4T4vaYROBKWJN2R7ImuRbpjaGpyNnlbkbr4PVnUzipB5n8O7j2KUkSDjc+QBzyGakqqve/puiOWLV33IHU5WY4bSHdqx2WJ37qUYKixw4Tg5pRRzlko7U77iRGvYodok1y/NwmQ56vn5BYWogYXaWCIh56y0RdnwPVa0uoxttNghZHdrM1doNlEIxiyzECBSlNn2CU60U4Lqth1HPA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	S4xhFs+KWDz3xDr8kVoCgilLl/yMfkKQsy8olq6jHiJHImtRbq9RUd189+xuIKTmTJn/S2oEryfceQ6uE8unxNHpr1ppjUnTJs05NaBzWqtRIuctVGSu/qlmWB+V8l5MO2pmrIjphwdLblV2fBaEuObB1xEbKSpDX6JGNIY3sOnAWQIx41S8bbbBfPXw22+stF8QQDb+NV1k4gEeJCr5/pWhWUZIzQNkDbfPxxX2dp6ilJTLpxeFCCTLm6Q5+E9wc+wZEEAqNy8aeiX1J+sLoCEMr0E0WqaU+29EopSdL5dQWPJXnJTe7T//uJs4mqmYi57qE9qvGzZyRXsbllOda/nBQhkLEjPsH9thY2veJwY82rtomUwyRSAONwTMP6flfOntQBvjuzD9Y+U9ng8vgmC7pGAFTbzoIUT3sbYmcCQUIWW7nEmAxLcK6qH9nksxtI+gRzZxcGwwnOb7D59v6GAkZ4uRBaDHBciXNOt8yTxe8BNiy0Tkl8a9p7tuHz8HdDAN13Tp0XJHHd0Xu9IooHt4hKALsMX4E8kc65V3HKMaVaZpuAWVJgw7qMbChOLZd3YAjA2cZe64cYjHJ8AfrQHxt6zcqzJ1P+F3Z3PtDrM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc535c36-8aa8-44bb-76aa-08de7fe86ae6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 03:35:33.7002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZVzo4UL+/XQHt9nJKmgUdRTt3S5P5gnEMBTXYoDKLNYrWX0E8IhbEe3blkr1qKiKYIOprZiGo1VtJ2hCtSX9fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4578
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=852 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603120026
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDAyNiBTYWx0ZWRfX0W2m5msdy7ky
 gMFDuq+UV1YAZfBy4VDdgcXG5m75XDRjH+KC57wCugt8IgUgmoNeAUr/fAPt5rhyW5Kn+dRNQyC
 Pi+8Obj5qlb6Q06dc262wNxz1v7xhLUy9rt0oBPt8hRNEjM2J4s4sWUPaJ+i7KEu5EUp/Rbng2t
 BZ1/Ob0tj6i9fpGnrOG/mt+CZgzbbAqaQGYikj2oJUqO9HxAeUuUimnLgOIsd/qElGKL+8NfTcb
 PLJbfHai7w3tXxQYvqGGZGqHHLCQKYwjeHEC3behavyiiXe4Kd6rZqTusMKVD0dTJC1qEtXgni+
 35MJeQPr/CByypyIUSEY0i1uZPrZzMY6ojZGlZPzZML/48w8HlBAsusXa7AvOiPVkiRKS1aO6pP
 jaN1RNN36975rYZk3RVdeK4FE+rHEaHJce/35i6MRXq/bI6Dv2aSykppJDaLGb1/olrzBsB/A/u
 ZvidltCSlJg2SSzMQzQ==
X-Proofpoint-GUID: xm1g8aWU1wql_hJr8QAbLJG3IT52vafw
X-Proofpoint-ORIG-GUID: xm1g8aWU1wql_hJr8QAbLJG3IT52vafw
X-Authority-Analysis: v=2.4 cv=Ob2VzxTY c=1 sm=1 tr=0 ts=69b23489 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8
 a=gJuzVsToSMwP89DkLkEA:9 a=CjuIK1q_8ugA:10
X-Stat-Signature: 85bh488s99ejjfoayxqbc1po5ybb6o5e
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: AA17112000F
X-HE-Tag: 1773286544-928503
X-HE-Meta: U2FsdGVkX19jHBgeFMuSozdJSk86JDNzvX0wVUEKG7jvaUB3bJPRVM80Ti44AuiYp6dgx81Nw+YugKtfBA0N/smSX+3RqyZtYI6cO8Li3cpApWPEKp5c5KQVgFmuKmYv1yRhxwnq6bWdSL3HpPH+l42GbFduemQ+Yxo/jmOGX4c37KQlzPCZ4likpaxzINQB/kG+AfCZaAWdbZkhEhTFl7TSxepjUd0SpfQLdXBenxtcWIS4ixCb5NE6vaq6V6qVkCT87I0/bVyIMJreyoUrNruu2Yp3hlm11hm2/AqTVHL+I7VYqoKmw/1IuyjH/NbXWaUKnCMdJ6O17dZefzmiBvpApa99s4T7ueWoRyJD1Xqw7KLXESF0cm7yNDHZOur2dti02us5d0qGSotHNpVGyWHgBNrwodT3GJg26qU5QAcd4kOxm/Uv5cppPDVe239k6NYvYsTy652OGkPlhOt4zCx2a8IdXFcW93LZ7iHl1DO+p8KQfye5htYKVaYtPv4jHMnyBcFOpclzAZegrEE0U/5v6f4ppGhuEpqB36QxVRDHtjtxjK+JMiq3j++5WlPWS+Aa+DgoCaaV4Hk2vV4yHry6ggF00TfWIlPLBSWskOV5mW5yQp4DKaWPt+klLkNsm8LTY0V6jaIWQXNCO+dqm064AOxW4Xvtqte9ea/XWoGbFpl+BEPb5WhGwmFebtgyIZQ24ZwoOPKIpmIjujvy7vpCJqoUH5ioJd1FqMR/3rgd0x55uSOSMWxHL4jo1fMA9s77Kpi/Z9bRpczl6HFvX0Jw8fXzFDbyJBDC406VHeOUBY7KAIdzBF/chRxPWcoG4do82za01/I/sqJp8ETpNtmmbKaCgcaa7XoXXBVIrMTM+E393iUfqDkZ4k5NWV/ESdxqRe5vRU6gP+VD3RyT/QNQQnPzRAOdiYk+mZT3kUXqmClWXwKuYy+rR3pOPQky75c840pv+6H6tl+dVjs
 gn1gs6Hd
 OIPOeYylkCoroDWZm0KA68Van6hDD9rstqhx/p4wN93JYwFG3F4v+eBLBRs9denvBIhGVRUT/OgCBphGAN2PS/qrno8TmEGhmuwK8mPMzWwTZW0JoClOJPH2vgMDT1yUAENIdx8Ftm0NRQRLDU0FOMarxxbI0OGm2SkMH0QhzMvdnE/o5uAFpOC4Fa79LGnuKBczocA2vwuq8svhS0nnEz+dBjO5glR8gQFhASnvh3UbZnuRX1wkAQkRTbAlI0hXIWwCg8mSWmJD0DFXnBzXzRuxwQdaXcLLnjNmX4F6XFKUkfnRchoSm66SDaigARtsOFoh4gp88K+WtzfStHFAoGnfGPwIUt7FLHlJ/hWdPZ/t+YFhrDr8zqVXNMBCcWu9XO0CCfS8V5vHeiobnEit4G97GNGiz09gfQFhAz8ggmSmlwSdhPOEBhMxKVxTHi1ljO7db2uEvv3YG4GyIzt2kdsrZ1ywgM+oHT6+hgltk9bLkb1FGwGVhr77N9sZHvCR9uodhulO4COjRhs+1PoY4Wy6MPPvMOBnQ2xv46yqRoRqpIXTrfl38NXEzKylbu04bW78c4DBaKz8RyfQYdhAoe1CmH5HXc9Rw7cUl2+2KgI9j/WnyMfzFhw3Cs6xAF7QutzJpBDeOucVeiW0Lobr8Ofr4rQL3NzNAlxJt5hWFIwEyHjjEOSlEmYnPP9jtXtzgoBeu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 10:21:42AM +0800, Qing Wang wrote:
> On Wed, 11 Mar 2026 at 19:48, Harry Yoo <harry.yoo@oracle.com> wrote:
> > Just out of curiosity, could you please tell us how you discovered
> > this and confirmed that it's fixed, given that kmemleak won't detect it?
> 
> Just discovered it by code reading (while learing this featch):). And there
> is no good way to reproduce it, so confirmed it by code logic.

Ah, that makes sense.
Thanks!

-- 
Cheers,
Harry / Hyeonggon

