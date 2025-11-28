Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84451D116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 21:59:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6C4C6B0099; Fri, 28 Nov 2025 16:59:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D456B009B; Fri, 28 Nov 2025 16:59:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5836B009E; Fri, 28 Nov 2025 16:59:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7B5566B0099
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 16:59:55 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B2318A6EA
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 21:59:55 +0000 (UTC)
X-FDA: 84161383950.13.3E6B6E0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 314F6140004
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 21:59:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CJVKWwNQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YadNqa1R;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764367191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKuihAl9afXAARHRGqO5v1WEnqzoR3yBM3BElc9Pb6I=;
	b=gO03nZMzDQYKHZ9x02hcEJnumwFBx+NQMheWuEFaZqrPp1wdhfAms5Iwj45Jn/dWIbMhdJ
	nJTpWBnCcY1lLgGbnzyd9HI0qaSuzOOGddP0lOB+xEP/mcmiLc50DXTfSyaN0wleOSvm/C
	zt4VOVdupJmYwGBiEQAU3BNPNViA1iM=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CJVKWwNQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YadNqa1R;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764367191; a=rsa-sha256;
	cv=pass;
	b=OOuNdQqYS+vKU8QVCrQfYmMr5Kt6gRJlIki34+S5qkak1pjq8ZQVLIyDGSipg0r3NK4v9l
	1DRjjH74+eicKXse5UxO1oWQNLSkjtb5CLFoQ3TYgm4fib6b2SWnzKdYfWOfh2e//pNuFH
	jSR9RIySiYzAo8I8vpcuDqGkgWLlIAw=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ASGvAsT3815875;
	Fri, 28 Nov 2025 21:59:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=oKuihAl9afXAARHRGq
	O5v1WEnqzoR3yBM3BElc9Pb6I=; b=CJVKWwNQQEthUc679dsCZmg5jtyptdWyGk
	bCpMu5L5n7nsMZrMqk0yI6rl0wnnSXEaYVMG6J5hRD/9BtdfmhISLbSkSq0A9AhL
	zpgjCpm4fj84Jcgh9tdahf2SUkWvo+Ff/Wtm0ak2qv5l8I5Xqsd0ITkWT2LCMlW3
	9FiRrd4Hl4NT4RlItKzgvn7IWWPEdJqPVGTAAJcB9JY7EWRzE5Xvx6LGvgzwtIfk
	pVvDfO5pcn/B6dYHIXFnrvzzLTm075TWnXtdgZDg2eaAuG8kMbGxHJzts0xShpFY
	ca+OZz1FsDYn+ww9W4b/oDvpQcaH9hCMNmWXIaXz+YesOV7o4KNw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aq3j8h8h7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Nov 2025 21:59:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ASL30fx029779;
	Fri, 28 Nov 2025 21:59:13 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010004.outbound.protection.outlook.com [52.101.85.4])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mh50a0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Nov 2025 21:59:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u0/PZqKxHOC5AeFwwMvnN2VVrttGdBDlPQvD6D5oekv7tQ4XbmxvwAOLnvLD05we65GIoWYfpheVr4mZvA7notsKMyTtPyh+86z5kZjSgczt5HeAlxaOj6p6cQ0fUCHDlk4suXDrf6fj8vScGveJrku1plFJkkF70LXBAzHfcQjuaslaJmsILNZW4UxuEySaBpzhyrnUuuZZQS23hzvrXqpX+od4dXOTcx+noZgAXsOvDxlfmCO888Pe6FpNFsg/QYXshSDMdMR09S/W4pdpYv+rOGouPVKVxjdKw92Kxjj03KyqHyegCQpQ7Rp+gLrTgBr65NLeToLEiKPoldy5kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oKuihAl9afXAARHRGqO5v1WEnqzoR3yBM3BElc9Pb6I=;
 b=HszC3JKqqpY+CeNSveWxzPwnuFC+sjbHyZPstRbLxYOvjmZmXo/4GLqc/Rpc9ooFIT96WvYpuNh/iznJohY4Ll97yLFGGSTLmb8OMdQSuCgKUIcZ7p0w/gaJUmbj/fAXEUEIbExGovnw3lsHmoyS+AOYJsso+e+vX9hkDIhiKNPFo3I+nUXhqhR0PWYCBiDiPBqlvx5yzqRNNW1lcTc+lcCssaC/oDCQKdelLxHMPhVfQ+a+BNZBAlENvbmRtk6gbNi6yD0p8qJOyWTPpHHe2UWsr8G5/iGKj+R212JheSay/zceJSI5J9jpintPvVB0arT5uBFR1O3Ny2vPA3faXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKuihAl9afXAARHRGqO5v1WEnqzoR3yBM3BElc9Pb6I=;
 b=YadNqa1RUHQTTbCDpPDwEyR+HN5IRKjqn9tV2oulsK1Ay2FZvhfQr8ryJHPyaH4ElOAFgo58Qu/3oOeb+vvhdTzLb0urMpTQmkvYGKJU/6xyWiBH6VttGF2eGvO0PAAxJXC2sLPu4qtciSy8Gt+urj95guD6XEJUTlUQlTLEefQ=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS7PR10MB4989.namprd10.prod.outlook.com (2603:10b6:5:3a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Fri, 28 Nov
 2025 21:59:10 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9366.009; Fri, 28 Nov 2025
 21:59:09 +0000
References: <c9c75803-c8d3-4f9d-b726-d0aa19926b88@kernel.org>
 <20251128101329.86934-1-ioworker0@gmail.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Lance Yang <ioworker0@gmail.com>
Cc: david@kernel.org, akpm@linux-foundation.org, ankur.a.arora@oracle.com,
        boris.ostrovsky@oracle.com, bp@alien8.de, chleroy@kernel.org,
        dave.hansen@linux.intel.com, hpa@zytor.com, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org,
        mingo@redhat.com, mjguzik@gmail.com, peterz@infradead.org,
        raghavendra.kt@amd.com, tglx@linutronix.de, willy@infradead.org,
        x86@kernel.org, Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v9 2/7] mm: introduce clear_pages() and clear_user_pages()
In-reply-to: <20251128101329.86934-1-ioworker0@gmail.com>
Date: Fri, 28 Nov 2025 13:59:08 -0800
Message-ID: <87ms456cpf.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0079.namprd03.prod.outlook.com
 (2603:10b6:303:b6::24) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS7PR10MB4989:EE_
X-MS-Office365-Filtering-Correlation-Id: d57d6b58-f292-403a-f693-08de2ec95b89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sm1T5aTVN88AMxbBYMbIW72BQ4rDT1ihbgT5EWjmppZ+t0oAWgGLCE4qdQ5e?=
 =?us-ascii?Q?DCdpgT1PIeumXsedCSmKNHAbIYCgoAxpA01vbLqVmB29Jb9fTo6a5zOvfAlA?=
 =?us-ascii?Q?7XvXP/03KsC/r7H4dvQYJsJfMR2tHRADxjzW+f1pYEE1v8hDbtG5htRwJjuK?=
 =?us-ascii?Q?5Yimp5hYX4JTNwFxNM3QOk69381+26pa6z+mC6VWOBlfL9uoWrq1iTy7Af9X?=
 =?us-ascii?Q?qKwHm1zZzRWUYRIuOmN736t7KwAA41P58mbkobMVEfPGFNyQzclEEfcRafiA?=
 =?us-ascii?Q?lOY+MOivDJyDmFgN5fSWpRKkN9ozoGVoP0Vt4kEjGFDiNjNnCV9rB0/SEbH/?=
 =?us-ascii?Q?SsaNOLgSAAZYA1yRLAJzAxYvrbPXoHG37vThxf93Y+b5YHmEOMLoGZwc8jAp?=
 =?us-ascii?Q?bvK/HCVDRvr0QBfByXkMP/wfU5ji4wh3uPBiFEmNnvqP5gYJ4Cqrp+RhUhyG?=
 =?us-ascii?Q?kupbQbV9LOYNcHOPlbtgEJJQ3bKrErQgy9yIQPWTyeS0zR75aK+lOs8y0fde?=
 =?us-ascii?Q?c+RNId0XWpQNarHk37/7iF0Xg77tMkDZxy9DskraYaxLBd6oQ+2yMnk+w37C?=
 =?us-ascii?Q?2beX+GGfUUhzdvvjCbNXVD+3q+02SK7mtoshVi/nVv0MPG9pKsOULX5EJuwZ?=
 =?us-ascii?Q?BLgGSlBQij1SqOn1BXZcaXAJaV8s/L08G+miWgbAf8ySHRBmWuiGGmNXNEjF?=
 =?us-ascii?Q?yfL4KIKRPq5xs2Q57Q6YnSw+4KGfn7qz7OhjbdX3CS6OylcBKwsUsQzsd2EV?=
 =?us-ascii?Q?xULT4cvP6u4bOqGOA8zAn5Bo4oFvFv82z+so5SgC89C17bCgjvAIpixSgduS?=
 =?us-ascii?Q?jTT9O9F9//Z2Cnssqncst0MmD99nDbkpe807Xlb8a60Z0P1bjcyc3jEfEpyT?=
 =?us-ascii?Q?7yiYjrwjD0k8gnygYOynElE6xx3vAxqHys20+uZHiyoq4seiVNFVmWpmW0lt?=
 =?us-ascii?Q?u14hCcb5R5u0Sfsy6HvKdoFMgg7oENdcM1XBwrYYBBnwVMsNHVYgi3QNYITo?=
 =?us-ascii?Q?SLGCJMYsu7I1nRAIKbLLOvJvo2HJ/kY+Q4K0Q6qe/Yu2m9UezTnyRcikUeV8?=
 =?us-ascii?Q?u1Jv1ZYIrfkhzw8BcqEZ3kbwiMcmyHKUkLY1GAMvjjP71RNtMq26cD/gaKNz?=
 =?us-ascii?Q?M8nRGwbkUGJKPTF/aWwoRt1aN8s+YiObtDwNRVp2ZsRuuPsH3rUyRzp3eAlX?=
 =?us-ascii?Q?ZkKBLgidVYPksbgrpUppxV8nRubKFWN3sa5aNtSZL14ZY8jAar0o6cJjNEFA?=
 =?us-ascii?Q?WcIK1PRdzBrz/a2KflVSyE82Xb7d6xVMtvhTZN3K0NsyI6Q5pxH5aBMNqmcx?=
 =?us-ascii?Q?vaJNnflZ5r/Biq+li2H5Yl96VPFM/dglcAQZyZVWJdVfSOxEXNkBlDy9wL62?=
 =?us-ascii?Q?y1tS/nSNM/rbT4+O9TRn7p/wuzdcNPF83gDjcui2zMRwryOLyYPOLNqqFZz/?=
 =?us-ascii?Q?6h6kFJbDBIoq3G1K3XmmCDNVeS9hDEoG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JApISBBQyi/BW44H2lRKsDsWdKP3RXHH0seUHmarmb8aT1omeHYlDldt1bbs?=
 =?us-ascii?Q?kU8awVaGuFZALuQ4LvejVS6092uOhkTbE4wBstTUoAUCWlFCoik0NGbD9Scc?=
 =?us-ascii?Q?+kNtAK9Gq5DduW2o2GrS2Id11hwdvW5z2U1+XXBeDxkhF0nlY+Z4C2VfkLBX?=
 =?us-ascii?Q?F4hJ65Nwmm687gc7TLLvI58O6aUIHvxmLZ399KX7CBrB7XYuvGYSH8NTnA96?=
 =?us-ascii?Q?ILlpQMycr/+XTL89pMSTXnfQ5o7rVxnSnE0mztNER5VAFISuaaFc2rBlKS9T?=
 =?us-ascii?Q?C/gabtm7N4yrCfOHbcmyNM4WJXESQ+8baPo1YUfUnSfMV5PZqCSZJ3ZCj481?=
 =?us-ascii?Q?YTjGLzvRsObgFiPxRrHaQZ4nve1FXywZygyQTMXyDdqTh6FpcbQOwit7zj37?=
 =?us-ascii?Q?fBw35IqUyPZzip6m3F/p3biCGp0THHkLgCRfXNd+F/5KybEo+harzKXLY42t?=
 =?us-ascii?Q?W07NwCZEeJMCRBt93e4SmHK3xaCVqZL/29LiXMJLR3v4FcxbZF8zybpUbbfG?=
 =?us-ascii?Q?hfeMky12JEFb9RIiT/U37YozuJksZlaAEpcT9dxr352CAOqosARoZoLxg0ua?=
 =?us-ascii?Q?L32B3ZSx5C7E3PgtpMSBLGjY5VtIwR+TDNS6oDvmS6fd2XAqveZqcikPIl6Y?=
 =?us-ascii?Q?bapm7+t4MhOqDHB083VCvZ22orKKT72/SYM6EZc9E6inc7jGAQ65i2b6Hs3u?=
 =?us-ascii?Q?8wmWesL4ZVvN1FNiJkI+QxoQbby09FZ5AT6GwdcoJaQvvD8qYtOOK/23+aeW?=
 =?us-ascii?Q?9jDULsqrh4elGVkeRujRME+fM73Thh/q7e4+XwaPBCF0WWbIH+0qMesghL6J?=
 =?us-ascii?Q?ZQS5sPuRb5oDLTGr23f6N0XXN0GseHEzyNhiOzYfdguxiLb0ppklkYd0QDIj?=
 =?us-ascii?Q?cVo4I4Ser+mSPPvq6nTtg1W7W0BRsYScHkgqYtDxyV+755ZSv+6UDPE7+5ZO?=
 =?us-ascii?Q?v1cEhoem1YNltIMEPGlM4LQjAaaoLm8ispurGDfjxbBOKRgL6+O9s+k9gKAD?=
 =?us-ascii?Q?Q2/LyHhuEflSdBWb9pzPyDPakLvg7ocvhAmocxI8jH0ccqjR709GT3InSAvr?=
 =?us-ascii?Q?8zJAK7gZQDqbavth9SVNHRxmLApcA8Cp7270sLz5MJGnOjVWvjFrod4VrujV?=
 =?us-ascii?Q?jce5uA9TTswvPVw+6F1guIedPwh668tFZGrDtLjcqoQZMtp2NQuHGVAkxiIK?=
 =?us-ascii?Q?nSxXjArpbumJ6dLOa44CNTk8Uiu/mU//r1hrwj+WxdIr37BTPFj5GrhA1+wO?=
 =?us-ascii?Q?e5C6ldd1Gw3gbCv2uYNZNPKiWdhqkCxZcKm1dwlud7E1USbf6AmerBqIJ04d?=
 =?us-ascii?Q?yWHoVWMDUElxEMnCI3bRDBcqvldkjppYHfqLhU7CacdxLq8KH0I2NrlURa3o?=
 =?us-ascii?Q?J+BCWGQsnDFF1EoSzq3g2UvRt5NXQ25wA3DYeU9WPbrnbp5zMgsAEZ08J6Li?=
 =?us-ascii?Q?46Wot/WouIrWUSdEkSsdAAxaXny8dGTJEudUP7NJcWuY6eOr3FSCmZZwb6XB?=
 =?us-ascii?Q?ktbx4cvr814Go9y0lLlXK51VjXVgEvd6NT5vKA567dM4Lbcitszr+beTywKU?=
 =?us-ascii?Q?bShTNbIYzV3sYnwsrfMHjrdE1JQa4qrStCJSavnkKVEPA//IebXzcTZZ15Ph?=
 =?us-ascii?Q?4g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7hGTz36/j4jqRZNKCdR9iq3yNA91hDReBd0qTX/By00SEn4EnbasnhHiICxWZx6yRXJz1Z133NClloVbFP7Qp5z1+bjM7ApZ556ME5Fb7npB7m3yDUv9XAeQK3JIQ6Uw7AqvYmdBzqtTtgKE0vUN7BpnbtgY0QsMzF4nYJPh9rK1V0JsAqufwA9mzmgrv+xj6mURKweHaC29AsHqt1lucLEuTndQX5iL81K9a9S3tmCnnLDobkMOTgMCnhfAdRBaoB/DOWbQJf7O30IurmJaYqZ7x4MQYOpx7tSAcOTkZ++7vXvU9R6Roj3ia3VWFGTjRj3Vif2/AtjmvwXSn7It1X9bU2op7QCwXgp8sx/hRFbkGAXe0kV++TX1hx0f3gAKSTd4L3no+TePy3vuP6dxp17R1dq5KqbN+9a6tK9ELC/MortW92oPiR9GIOZiV+fsUD9hjiIr17bMKUQUvW2bnZ7MtXlApFsuOBuCS1b6EXfRS2rYnI70ifbdU5D1XKSo/6j0U6J6lO3zmz+PO5XWYxbMpXe5RE5oBaMI0eJ03gO3m7yZ0Y8YfGYzmpUgCfdVzkfNRkHqj6jg6+30hw4jOlGBkApkYSiO760lZ2Ypp/o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d57d6b58-f292-403a-f693-08de2ec95b89
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2025 21:59:09.3534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ct6Y19WBqwecymRUsU9S/3z40XE3jxat9w3LiBTFo97wsEIpyNZgEmRp7jniX5wQAXzwgL/zqm5h6lg0B0WGvBXVWmDBoxSZJ7M3IL9DmQY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4989
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511280163
X-Proofpoint-GUID: SrHlL5uvV37Zm42Snu2szieDFz_FvpU4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI4MDE2MyBTYWx0ZWRfX/UQ9UCeP2OUr
 5mopE+JawWoXhDpt8EvgoPTcX8nCdaUCvXGndEc8EPgsQp00otzkjkPat2cpnUn813tKOgkkqSP
 unNTniRmckIHuiFEKrmpelwq09XNgUonGfrbCk5KqyIpeA7jb1jH50CRftkJEMy8mn9h6cvEZeb
 l1BZMD4WN7viQ+xUQr7lXpGDlwpF9E7AMjV1Gp5q5Nv06uLxL3uVN1vFZLX7Soy5wv7QgqSJ3bw
 K3n9mCfC7yIRkPHJ5g6t01tKugzrioqKDm2As6VeQar6PP03vooY1sZr/bvGCFuy876qEEi5kLp
 RZvo3wVgpUcGLH6yNILaQMWjeJrZdZ0VyjwYAvKuToFLrRbZhpnLyQUS1MS5+BuVA8YHdGXqY5h
 3YvUWZBETKmAmhkKm7pFbsCZWSYMoxogjit7kzLKo0N65JXHYNA=
X-Authority-Analysis: v=2.4 cv=JKA2csKb c=1 sm=1 tr=0 ts=692a1b33 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=pGLkceISAAAA:8
 a=B_3odPo0YCNfFC4NPngA:9 cc=ntf awl=host:12099
X-Proofpoint-ORIG-GUID: SrHlL5uvV37Zm42Snu2szieDFz_FvpU4
X-Rspam-User: 
X-Rspamd-Queue-Id: 314F6140004
X-Rspamd-Server: rspam11
X-Stat-Signature: rpz86q1wxuohknb5dybw68n1a9to8tdi
X-HE-Tag: 1764367190-519827
X-HE-Meta: U2FsdGVkX190LhS3ek6lct6SLSsQHyZIXSHLiTdQ9i0MCyazFKU2N30bHBi6iG8UEJpZFAO3cKiAINVbDKRMvURSNy4+BJOAI5TrG5Rbd/EJWK1LIM0aF3OCCCF2msVEHlw/fLaolA4alGtnTRx66+HRaQ13x8wgcc5Y+ZiK9cJjEKpr0OtxitGVCdGgdrykmJ4NY41uepHd+RuX0G6DeH8pTpHjoVNjcwyr+lM4i1LeR2Vakm1QR9AHcNDQRj/cdAP4Vhfa0KwWlhS5Bz1+MPUIIle+ykEqBzJ5xqUPfpwwP2dc/tswW/IX7xex05ItvrqqBrX0XpCiR8sfPhCRYRT8Mind6lYSbJzQalDCUwhgXxNY+Bl5b05vBofkTbHJUTOd/+V9Na/Gog594s9YYeN3nmMsXT60/ukz9MCJbdzgoZnZvsgiYM45o03xVvOqv4BkcxtXs2i4psXvRLbqDeeQ87Sp4F0HAmvRQ70TqtlvYI78YZUSrCq3bCirEo91iDtcCvb2NKTbI0MCJR6NuJrxL4V4jaQOt6P8oIYlPQdJkWl14gtnILoXHYfTSPpMz2v5QUXTkiD8GUN6Hs+6Bz4/Lf5hhz7vdoqmySRDOZXw+QWiuFEfH9OXOv58ci5Qk2O+HlWdftAQamXst8F8zNIsD+CsFqQqDELGtXjGlKXCsffgkQLc9yiWS1VqkhdFrkiEkUfkstmuxH676yicPRJxg1RfYFNCQ/pYQmlL8/Sakjkj3Aylbg2wCXXm74RdaK0w3v+DvryAhXavznoDUFbZdtJzU8er5F+QOEw0BegYsFRh0ABNKeow2WjKGrt7b7424PI3tKP6+VBGkX9KIOQCeoBybN1S/5ggd5tuxBglmIYVmTLz739c6P8c3dbzSiyUj01YD+oalZ7BY8doXVYxv/ilS1ZYUbBkubFTiWRa9DHEcqrs6mlkbyhpKmp5Jxurdu2eOgyKhgw2Fq/
 mnt68zFC
 UchVQAQQfVmS2ACKZzFrD8Ih32EVEpcFUTB70AmD8k9PhU/TnPjf6wyi6SkMMJdaiEEoCYvf4grqunzXNdfauGtqpTyfOhqxLgGA+IYa/I6/KVOeRXXQZ9158Lc/8MRWqtxWijKN7yoVjej9xd4fJLP7AJN/EzOtdnBhb3sFYoFNf5UDkgxk07GVki5mI0fCCuk3oVlLNsid/UvuyqfKd3ZRjNsXU22O+COvoTCDwmS6wvoICykHqyhkL9y7fqjdmxjnFVFjEpLJkmTswFI80DMBmPY4NxYXuqaJY8aoTm6pjIePSf//n9kM9NbTk5d7MsyqU263/ssrf08rdts+2S4XkqZWRr7A/+b35gOBLuWNOkYgwiLWk1eNbSCgGZ6lQWO0+PNJsiMnhIhafR32GoXuGUqfOCGMmTnxHMnA8HViXpSaJ+hAWt6eogs89RZjooJEICqXaQSJkNrdxm4DTWInytr/nd6YHCfZK4FeMYvDKIVHFehEc7T9ZpX3abLax3/XURo80yfghP11TUvhw5avH9crQFIEzvQYp0eQ3ASCMP3DvzcLk8JqHHcUzAdoBC6LJ/iWUFn16E4qAqWjXlTFSEYzVD4qf1wn6ZcJQULUH5ik=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Lance Yang <ioworker0@gmail.com> writes:

> From: Lance Yang <lance.yang@linux.dev>
>
>
> On Mon, 24 Nov 2025 11:26:56 +0100, David Hildenbrand (Red Hat) wrote:
>> Replying here while I am already at it.
>>
>> >> +#ifndef clear_pages
>> >> +/**
>> >> + * clear_pages() - clear a page range for kernel-internal use.
>> >> + * @addr: start address
>> >> + * @npages: number of pages
>> >> + *
>> >> + * Use clear_user_pages() instead when clearing a page range to be
>> >> + * mapped to user space.
>> >> + *
>> >> + * Does absolutely no exception handling.
>> >> + */
>> >> +static inline void clear_pages(void *addr, unsigned int npages)
>> >> +{
>> >> +	do {
>> >> +		clear_page(addr);
>> >> +		addr += PAGE_SIZE;
>> >> +	} while (--npages);
>> >
>> > Why a 'do while' instead of a 'while' ?
>>
>> More efficient when we know that npages > 0.
>>
>> >
>> > Are you certain that this function will never ever be called with a nul
>> > npages ?
>>
>> That is the expectation here, yes. We should probably document that
>> expectation.
>>
>> >
>> >> +}
>> >> +#endif
>> >> +
>> >>    #ifndef clear_user_page
>> >>    /**
>> >>     * clear_user_page() - clear a page to be mapped to user space
>> >> @@ -3901,6 +3921,27 @@ static inline void clear_user_page(void *addr, unsigned long vaddr, struct page
>> >>    }
>> >>    #endif
>> >>
>> >> +/**
>> >> + * clear_user_pages() - clear a page range to be mapped to user space
>> >> + * @addr: start address
>> >> + * @vaddr: start address of the user mapping
>> >> + * @page: start page
>> >> + * @npages: number of pages
>> >> + *
>> >> + * Assumes that the region (@addr, +@npages) has been validated
>> >> + * already so this does no exception handling.
>> >> + */
>> >> +#ifdef clear_user_pages
>> >> +void clear_user_pages(void *addr, unsigned long vaddr,
>> >> +		struct page *page, unsigned int npages);
>> >
>> > By doing this you forbid architectures to define it as a static inline,
>> > is that wanted ?
>>
>> Note that this is not the intention. The intention is to either use a
>> direct mapping to clear_pages(), or fallback to the variant in mm/util.c.
>>
>> The architecture is currently never expected to provide clear_user_pages().
>>
>> Wondering if we can make that cleaner.
>>
>> I'm wondering if the dependency on highmem.h here in mm.h is rather the
>> problem.
>>
>> How I hate this macro crap with arch overrides.
>>
>> >
>> >> +#else
>> >> +static inline void clear_user_pages(void *addr, unsigned long vaddr,
>> >> +		struct page *page, unsigned int npages)
>> >> +{
>> >> +	clear_pages(addr, npages);
>> >> +}
>> >> +#endif
>> >> +
>> >>    #ifdef __HAVE_ARCH_GATE_AREA
>> >>    extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
>> >>    extern int in_gate_area_no_mm(unsigned long addr);
>> >> diff --git a/mm/util.c b/mm/util.c
>> >> index 8989d5767528..3c6cd44db1bd 100644
>> >> --- a/mm/util.c
>> >> +++ b/mm/util.c
>> >> @@ -1344,3 +1344,16 @@ bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
>> >>    }
>> >>    EXPORT_SYMBOL(page_range_contiguous);
>> >>    #endif
>> >> +
>> >> +#ifdef clear_user_page
>> >> +void clear_user_pages(void *addr,
>> >
>> > What happens if clear_user_page is defined but not clear_user_pages ? In
>> > that case it seems like the definition in linux/mm.h will conflict.
>>
>> The generic mm.h variant will not set clear_user_page() and consequently
>> we map directly to clear_pages().
>
> Hmm, I suspect there might be a subtle issue with the build flow on SPARC ...
>
> Inside include/linux/mm.h, the guard checks for clear_user_pages (plural).
> Since SPARC doesn't define that, the header provides the static inline
> fallback.
>
> However, mm/util.c includes that header. And since SPARC does define
> clear_user_page (singular), the .c file proceeds to compile the non-static
> definition as well.
>
> Wouldn't that result in the compiler seeing both a static inline and a
> non-static definition in the same translation unit? It seems like this
> would trigger a redefinition error ...

Yeah it would.

I had only posted the linux/highmem.h header bits for brevity but the
full patch removes the mm/util.c bits.

Sorry about the confusion.

--
ankur

