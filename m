Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E58DEE6B70
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 01:22:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6846B0092; Fri,  6 Feb 2026 20:22:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8367E6B0093; Fri,  6 Feb 2026 20:22:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E4706B0096; Fri,  6 Feb 2026 20:22:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4216B0092
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 20:22:08 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EECE11402FC
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 01:22:07 +0000 (UTC)
X-FDA: 84415909494.09.35026C7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8E45910000A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 01:22:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LhT52EqE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gIRZBrJ0;
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770427324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/1q+RS9rS0XTvBVFjcYaR63ZSNxuX06rKpzfWyDzJDU=;
	b=PokoXsrjJpMSILC0DWsIGPdB+4ml1nFJnNQFtBfMjCXjMSguzypUiyFo3dq+13eYa6Q6Rp
	GQ4HpSlc6dfbsrf3zdOPmUxTpl5D+vNCP9316JnpiGzXlKLPF4RnhqBg5rik7fLlFy52bA
	6MMUGM/HpSt9A47oo0C3qIQYF3AW6SE=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LhT52EqE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gIRZBrJ0;
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770427324; a=rsa-sha256;
	cv=pass;
	b=Gg3wXYrcn8zgaf6wBWIECiFAIOsKu84qh2qyQCuKk4NJGKL0BiPm2UZnEiWHturoLGyHZ9
	lDP276uVy843l3UyQRZLj+5K0YUtDBdRFX1mdc2iC2z2hj4e1Nvy+yV8QHRWUevLSnej/Z
	5UXDWJpXm2xJUlWxMaQA3Rc+6xLhlgw=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6170lYxu338768;
	Sat, 7 Feb 2026 01:21:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/1q+RS9rS0XTvBVFjc
	YaR63ZSNxuX06rKpzfWyDzJDU=; b=LhT52EqEgCWMz9ZhFmgnOExvZ+ArFWJLil
	gXa7WcUpBtol2Rx8db27sp+CDI4LH3fHiv17w9NnVRP2dqL5r1atETUdAoKo1xND
	L2sxlJmS/4JdvMVfAWX/iONcFA4O1m/26jyLT7tWKcW7+L1k3CkoSSINcfuvoAsr
	gzoySUCBwSBZY7whwIKj8/bOwzJofuthC/B4HaPyV7G39N3O65Pu/s4LF7XWTDql
	FFPHdHv6yivU/V7LNFvlaM+5gB2Cd+00ee3viBnsrdqK1tlrC64QEMlcI2fQyCM6
	q5wwyrfKvEIDhwnVljbowDeOJ9lRIirzuPVv0/hh4BS4l/YVnNtQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3k5g685b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Feb 2026 01:21:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 616NUuvo030721;
	Sat, 7 Feb 2026 01:21:40 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012030.outbound.protection.outlook.com [40.93.195.30])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c186fasqj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Feb 2026 01:21:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GTOp0KYCR1J0oCb45EoVNvUH1CafwS9SyPwzDSyk/xcs+Aj/Zi5k444icw6UUdNilj33Qj1olZSVaJnWWxLSx78VZm7SX+0kD9XEA4n38cJxC/ie274nzbrVObcQFyhUJQEnjuCZNwhiB0eGD6KhVJ1nXbGt64jRra6QD4f9cWBiQtDrsbTNsMzARoZ2cbdUahDfptG6eUk6T+yI5VuXTLDHpR/VmvpitGJcdDwiSDIGNuZtPsWv91IjRYE7QIPjwk/ixXXeaVrWq5H1R8wOsEkW5PTwNRAFODjNM/+xeocoDUFm6uSQhGERG4QO77kSlxkm9CqMJZG9g908zZF2Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/1q+RS9rS0XTvBVFjcYaR63ZSNxuX06rKpzfWyDzJDU=;
 b=sMX2dDUbQ1TN9W4XZZkqwklQ3LAuudOv6BprZQTtKa1ejChFfYoucFR+Wyqc3s9/FWfDaUhLR3xEwo1DMADfR3LQ7wTClPq4IWi8lbJLlKV2TQ7HsEkUHBIGD007AZjsD0J1IIrq29LduSQEj21/2MHbeVV2AIh4bAXN/nanLU3ezBlN6wlX4teOQjBmuP1THS88BbzxndsFp2sepUnGed9FeG/avGRVQ6eU4la+vHe1E2rZkJ9h2gaiCLfB7C/vuaUrRMIXTcwXZ2wnplkZeHn2YXJ46soE2P8IwM62RHVykSfi17rK7g7TX8gjaSmWhGOwcl0IQZwg2A6xUPossg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/1q+RS9rS0XTvBVFjcYaR63ZSNxuX06rKpzfWyDzJDU=;
 b=gIRZBrJ0EuMCxigR8MYu52Vb4Mr9XcmpQXQBYI33lRv1fZ1Ch5DioXWVvMFPofUI5a3xOOlSplmiu3T8BhYAZrPKbn281me8WluJdYLvsvI4cAKph8+6SZURBPHhAOsBi7k15BHyyswiwoLDNetpXbxhNQIorlZA9jdL4GNyS4I=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA6PR10MB8208.namprd10.prod.outlook.com (2603:10b6:806:435::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.16; Sat, 7 Feb
 2026 01:21:37 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.013; Sat, 7 Feb 2026
 01:21:37 +0000
Date: Sat, 7 Feb 2026 10:21:26 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Michal Hocko <mhocko@kernel.org>, Hao Li <hao.li@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Puranjay Mohan <puranjay@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
        Joel Fernandes <joelagnelf@nvidia.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
        Dave Chinner <david@fromorbit.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
        linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] k[v]free_rcu() improvements
Message-ID: <aYaTluYIbqt7xSC5@hyeyoo>
References: <20260206093410.160622-1-harry.yoo@oracle.com>
 <3069e76d-5c7a-4c3f-9b83-43ed1700b95f@paulmck-laptop>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3069e76d-5c7a-4c3f-9b83-43ed1700b95f@paulmck-laptop>
X-ClientProxiedBy: SEWP216CA0041.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b5::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA6PR10MB8208:EE_
X-MS-Office365-Filtering-Correlation-Id: 589ad55a-c768-4757-2c0d-08de65e73cee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fFbUP2/0z1EooyDbUDI6PZJ1xEUO15QYHtR6wgYch2MgGHbOjtqkxLWVzu8w?=
 =?us-ascii?Q?dBBj8HtDyNWC3K6IcMuFpYExJkZMP6s7vk2N/TdM6SWW3nSPxGhwPvzRfMQl?=
 =?us-ascii?Q?bnH5aGTDZE27TrJY9Tq9sr/Kj63LNIrQq5dcLh54000aV4cZf5umJXch2Mlo?=
 =?us-ascii?Q?s4KAN1sVSpLc03qDtPFoxl/HPRNAEvuZ/PO9bpJRglCL0ztoqY/reHO6Al7o?=
 =?us-ascii?Q?B3/vFeM1f3ySz+in5haXS8fmF+YkCDa+/je2eUnMq8+RhXoKf2Az6nxHGDDs?=
 =?us-ascii?Q?9/jMDVWSFofxj7H903Fvoals+KJ/izxzS1e+1qnJ8o9P9XtMghv39Nj9D+eo?=
 =?us-ascii?Q?IgKzM+lpPvUF/ysTInjiKyOBlRfg9v2CTcHrtdjZAUOLzRC7Hhw5dGOuR3e+?=
 =?us-ascii?Q?6G9OlwyEZFO1m9zT9ldb0RJM5wr3po366UiU/75XHu0SeJZBSFc6sYHm6De9?=
 =?us-ascii?Q?3K0remoPltcVjM3KgB3Ass5I+dwmlLHsP1B/yPFAG0Q+rFuTE5vkyAneP8ar?=
 =?us-ascii?Q?mf9j0O9QA95iBwOMEZe5kPLgTSmnuOk/42BeLVHJUp5UYB/lkFVvuekzqclY?=
 =?us-ascii?Q?D/Rgd6/KwVbufYxADQXfcdqy8nTvDxhUVJxCLQkXVJPmsqgN9AMNnydHXcXf?=
 =?us-ascii?Q?AEkIvaRqk+zdUL27o99zP05QomTdt7BvOCTl4RTJurJM1uJVt9z8dQr+ilsb?=
 =?us-ascii?Q?q57YLHPzYJmP76cZhZs+fZiPdGaXOGoPvCUf0YxMNF520MLJrlocENz1jQjc?=
 =?us-ascii?Q?bom01wWzqJ08Z2g+zxvnfV35GEykkzkK9aklY9g8n0sTfXCiC74ZzgCWLje8?=
 =?us-ascii?Q?mqFaMBlRGrQPQwXtnsodp3h8pDlrCf+UbQz/pIhqa7YeDWT16wyWMvOMkLf3?=
 =?us-ascii?Q?Fh6kn04Bc3XfD4QlaY2JwCGpTXkDNOAmUvku5bk81DKQadShu7eETKO5nuv0?=
 =?us-ascii?Q?cCOZ2mz6dZVik3K+jBeBpNf0pNLqnstN8Bq5lRs4SatjTsBqJjjeWeLpN6HZ?=
 =?us-ascii?Q?Z8+A2lk7B3nHTgqYFaD1Tt70uIKfBr/+JLFqwQqfPyKIfLYw2umPdnnwwhro?=
 =?us-ascii?Q?ZiAGfhPUjB0a1AKOyy+0OISLUC7pE0d8nfqzRv8E8G+Kz7dWLHM/hqqtwGkJ?=
 =?us-ascii?Q?6Tu35v4rujwBdeNTAa67fxCOiUJ9HezIBjN8o9ml9EFoHG5Q7gZe3wSRbhjK?=
 =?us-ascii?Q?z24tCxNfG/cThZrJPNzdcWRga9335ly7lPd2nKeM2uWS1EUWdB5PUea1oAcu?=
 =?us-ascii?Q?C7g2NMFVF/YW/XLd6NDm8elodQ0v24vFt2u579hQtMdjr1vAD8l/K/f9VF//?=
 =?us-ascii?Q?Af+1g41K2jl32Y+g1v+NuATWZLRwUyVCXzdH0amMCnMQiof7hTgluxgo+C6g?=
 =?us-ascii?Q?eABc3xeqvddm0f5IhG2kYEOucmGcuE6vByKKONlYRUB7pMG6S49w/dG345pe?=
 =?us-ascii?Q?Q3nBOj/XhGSLQUnVfeCnzashdWRTyiRv3wR0AWm0aDgkC1lbqwkfHFTr9RHz?=
 =?us-ascii?Q?edZy2tEuHTByjNficTMEqx1YVYgG3kBpM9gaYEagVL+TTXeMahc195UnhYQE?=
 =?us-ascii?Q?Me9yjFUM+L15rEZp71XjMEubcNyF/3QgC4wI/BDr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4kQVhRxG2+bx9MvsfsyUMq8GUsiQVLDrUG7lHd5EZ73Bt86AsdbncIbub1fx?=
 =?us-ascii?Q?kQ1JM/TOKW0dhVz6ogTb/jw/gCEJlMD35Pr8sSxglyi7TreucUw47Xu2krWK?=
 =?us-ascii?Q?GGsC4XaSrtBBOf8SICmsgm9HdNZFO6Avmraoan+IKxr0/Gasv1LMOAY3gXva?=
 =?us-ascii?Q?sSdUBsRmDDEOHF0UuLj5GX9ZBcGUuS3pkB/wz7LZaZG5JoPrf75ojQSUfpb6?=
 =?us-ascii?Q?BvVsv7P/xdM9cH0rGVfVATFwQypMuIBa0Iyoqt+v69q/vt4SRpkE0+y5Gc/V?=
 =?us-ascii?Q?unSZCtvF/SCyzhXHCSeuTF37/ZwfFuSxyBkKkBst37A8tpNHD9ObRn29sL+c?=
 =?us-ascii?Q?p9W2zWrk8edTB8Sf83oPOmhrESf+aTcWbb3EMKUfXo4mTLLcLMUqmMskBBCf?=
 =?us-ascii?Q?H1qPkAwrnQncOAWY3XBXaHoyUtHFs6E7z7+oaIf/WGSmJxv3k2vTmatOpgcR?=
 =?us-ascii?Q?xSAXRTLoNJx/acRarwmZ7P7lYGzT84U/QBE/ftvNRTzGrKdMccss3ZgHP+LD?=
 =?us-ascii?Q?CL53RTjx4FwxD18lMdZkF2kfCkMhYdda69SsMWyFFYfKAb0DIZbCw+X9r//S?=
 =?us-ascii?Q?RkGji3D7JNilh0my15Fao9Zho3SrjsUE8nZC8qCP43VME+JdTZRwdyFKCRJ+?=
 =?us-ascii?Q?n9uj0z8t1cZ/cR3fn9istHskmcf2nnDy/QAaGPa4c7kFrfz7ZoA8TSlkg6qe?=
 =?us-ascii?Q?Qy2dSoCPXhuU3qWYOPPiBzRxPyN3H8hlGfaz57CYw32+IYngWaCpUtFVpd/3?=
 =?us-ascii?Q?XVSTEvh7fTX9ZNKLLszaxNR5VP66s0rIciUuArCfx719TtOh6992BiOLiqL7?=
 =?us-ascii?Q?znRSnmoXq2vfbnwwpbw8rLVgJnoXOswou+zX+yGA5IoLQ9tIe4Mj3BIBnGD5?=
 =?us-ascii?Q?ETCLrmU8gNvhTVxMhQIjnqyrzISFanv1M4UyyOe0wF/7WJ9LJVLb/YERJyWN?=
 =?us-ascii?Q?6ickinvoQnog/oS4uR//cZxGO0+7ZQ4OJ6yRfxFv3NM1+lUY6fNxg2BFzImi?=
 =?us-ascii?Q?B6x0t1iZ6SBdShe95KDEWxJhxegKtceVyLkYqqI++qCD0So2dvh0bz9jyg4R?=
 =?us-ascii?Q?wyLOSXpACZO25tlKDTj3xTX0PAorxPo4rYqrujyeFdOzsySnR8yXclEBV5pI?=
 =?us-ascii?Q?eSxqn7RLbKIjQdCH/JuT3iOcPTiBN6IdlV74nJ9uXeKY+FNDw1jLcpBgLIzM?=
 =?us-ascii?Q?TmA8KF6zqu53JPkGS0vn5v2qCh+S946FRe7Sko5lFOMCfcH2Zgkf15cA8+bZ?=
 =?us-ascii?Q?pIfGBLU5rO5w0i69+y3hGKBkeyNCV1vgq4CVgh/+HzHczIYLlI6RziJRi0g/?=
 =?us-ascii?Q?BLiKDPXfZKQyMcNzJUR707S/5V9Yrq09cY0cOLBpMkDtrWSLleiox4tRB5n2?=
 =?us-ascii?Q?smUYUzLeNAYTJ0PnLiohm0kSJbzlfVfOKT/4WZ39c994eUViiIZ31SQdE8xf?=
 =?us-ascii?Q?MBFHUmOEEU+GTrI3ZW87wnd+SnBMnpQHY498N82AjdAz7fzOMUwMRBlZcW2x?=
 =?us-ascii?Q?amZ3g2ecFZi0hKSUB32c0u7tz+7SC3PKmneRC+jUFuMMrsjH1a27suEOEweD?=
 =?us-ascii?Q?4LOeuomuoTwC4s3vpn0g0RjzgSBC/x/M3+xM3wAHqChNYxJMewoYyzXje0ah?=
 =?us-ascii?Q?eLUyQHhJ25VWuOHHRMBTd178Jb4Cj185GhH57yvpgZMGFA220eYm6+hHKHsb?=
 =?us-ascii?Q?josw75LCdfekkUhucxBUTghmLRHgYwFCoqcomss9iUmCjF4Xehu51ZGTzTKG?=
 =?us-ascii?Q?mCCjC23IAA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mQoK1YFInJx+zS6V+2oOeJl893SiPhv7yr+/pVGw0bopLB25CfVUagTtIfTVfj1uYoPNmwnBlC1Ou2hzFyFsaNH5BkhSw8RNZEaZRR8CO7FRPkc4hyOSUxR8Asas9HTozfmK4/B9sCSwdNE4BvPaPff+9b3X46l051BPSXu97EdthIaKm0ji2RIOVbEz0ma1AhLu/1U+lI/29fcS5gdFDBCpWpeqqJqCllxBSQRaXt0Xy1INqkyCGDy9Rz0acGnuiGCP1JKbfpBfYbE2w2FhkHE0LkbtheygHrOuI5wGoeEBZP3Rjmcr916kEfBFNaslK4l5s/mGJYlAjWr+xEjs8hu2gWJOxgjgAwWKhXQhgBS+no+TEjE+3l2Z6Oz6kAld0YRo7VyjWU24oy2PZiEzbBqposYLVct3YkD+Gao7/xyn1Vx4934urcT9wRcQHzOX41ETpfWCYQIiQaI/aK+A23tU4+IPo8rKBVwX4XPCMYGeB09yt1ORnRPKWZRMgQalNivOorrwyrlKYMqSXZGHwxc6DC30Cab8wSO4brHmuBA3D+QuNDhLXvnR2ujjKgcpGT4zs/zdDMakmeAjLBJP17Y7izkJz8D4iYcp1fMRHHo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 589ad55a-c768-4757-2c0d-08de65e73cee
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2026 01:21:37.0303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: te/O/db9XsrB4QC5fxSeRO3zV08OuWy6ZSutVIRCh9a+MAoNFW+SRoPtY3v53EAZyKLMG/8+QV1Tk2JzhiKVVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8208
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_05,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=764 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602070008
X-Authority-Analysis: v=2.4 cv=Jor8bc4C c=1 sm=1 tr=0 ts=698693a5 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=2D1LTiv2pzEklK36x1gA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: LHKZMHlIFNHW9nFrAR3P7nJc7EaY0Zq4
X-Proofpoint-GUID: LHKZMHlIFNHW9nFrAR3P7nJc7EaY0Zq4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA3MDAwOCBTYWx0ZWRfXzZwCfGqv1Azu
 R6wHfc3kWYG2fx/ZLoTCjOCvZ5EcBCWnr8idpLZtLkJYFgt7mtPIs6vqZqbgYhGV7fdT3J16jo2
 fNQ+fgQmFUFkPfl0XWeS9fh3tvnQoXhx/Vu7yBgWN5o7pDWy07D+Z/FTGsPcW5j0nDaCrTwrnEe
 CZYTNSnztUaNF5J2H7XofacC94HexGuDpDl3/Ur5/4sP4kziAQm+LXjcz5mb4jYQo4V+JgsGjIW
 dFeVy3jjIcYXSOlXC6+pcyRqKABuyU9PT91NIoJiRRgV9ydOO1zVdTLQA7PQjvtiF4ZB27b6Mi3
 1AWFYeJmItXXi0lIYtEPa/UtecPV+mW2zHJPrVF4hFdXGYFSYTL1Y1K499p4z3MmtK9Hq43/AnQ
 SsBgvAmas1sY+w07X7qkG5lsJSjweg9luEFIzf92s+cbjlNwuZVnwus58xNVCKWuVaFWOroNR89
 dOg0j9Ih6AFbbeRVm7Q==
X-Stat-Signature: 1rdjxo35aso9nfx77xs4ek5tsftdthno
X-Rspamd-Queue-Id: 8E45910000A
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770427324-521627
X-HE-Meta: U2FsdGVkX18Q5THj8kteTZvxlC52FgBTyQrG+8yXFMZutgTeGijP3XH3Q4lSFaX1hoO8w0X/9tbbMKL/7D+DOJ+xvj97+9Bj+6KL0gV1QbdXx1MIOCtWoeY8DUavxeFSYKBa9vtFxff4ftBmCasC9wd1sz/VqnVLlC8i+SmrTL+BjPwXNx8ft6to10Dmadl9xvHyNwqjmxwUWLVcNCCA85aaV1JWvv5ii2OmRuOK+7sJioVsjhJ1FyxKNG/gtnZHpgRseRlXo6u6Vu6sokcrncBpn1f8w6jsxkzj8cS/QKWf4B5a1s7yHLIW80wUGYscU9+C5Rs3WqDMI60peZp5GGHY3YDEGTDoZXSI4qanZzjU9J2KN+tVNJ66j6m4lbmTZm4wPeNBGDGO5CNTCJ/pI+SJHb7iXNwp9vpBnK5+G1WRfZwRSzDsGKPI4jkKZb9tustHSpsSI5mINYp7nMI7uJXnalAEoChodnDj6+Lo/Tc2fBwo116TS2xEIuZ8hnKtQbCnEtlbx1TmA2hLHQQaiPTD99KOGuwiLQnz8kLue2y7Lq8r2wa9cS9VN5tAApNjdnmUvlV26IbMXdyWvAaTpi75whAmFgX85aMeErKWjnLHR5GQFKVC/qH37CojKM6rjGv8A8pcE9lC/xH/ZwPWt0C94SNaCsh6UHkHewFl+XMCbnC1wv/24eDJuSBvgWOKHVX8bjXkvmAPrwaV9FjAJ/iPd7qymYDbCTJ/8XnR5pULGAKMC3ZdMvnA2kZYr/exQc7utErHF034Zt68+4cbcxa1tCV2672jDcTrRWMukIHWWn7jOUmcX5LeuGweT1IMEvsyu61Y0DCSp0DGzBnl3owqhvaeFBUOpAhIflsryQaStzLuayaQhqbyvFhD/XrtO6RvdMwWoZoMTcxqeWYipTSqERP0yZrT/2yeuZDf5oaQA3F83fdchvbbO8CV49u86m+t36pDoaCK+pu7F+d
 msZTGWGx
 CLAcRb9hjJpVW5TBEdHn2rwxOx553JA8j6FvKiwbnfqfYpbY0l5YZZA8SL6XZ9KX1NM78LfcRgIEqMqc8taMILFgzCMWVMweMaL5qZH8EwW+6a0+MIWPwbTxwVjeNXyBgaeKmFGkV2rpVp1MSp9uSWkYzrzzQjHMprjmcBHxSXgmBPwneKjE16c4M7qEXQCbqT3fYBCs4EME9glDWZ2YeZuFYu2Cm13UM3uKdh5kFFT2V04D/MLg6ytWZ1xxqpt64FB6HPzWxMdNFj0oYeNWXscsdzT/VJm/qGg8y0mIuv4GwmVjv6xBH+SnMKY/2dOJ92ElochxVYew+U0n3d2cgg3U64KN8Ji9czyGTZhYnOe6Mjolz3NL//p+raSEHvUwDsHeSEIslc4JgCAJYRjvB3hnXUIZkJV0EAWO1FwbxrrQxoQuHJxhSCS4dekuxP2fhl1DbzbvuAfwfJGyV75L6R+dy4QwOAqM4y3P18n/pNsDbk2ab0ybsEJKPaPpvYavlgxmGHws19kvGRlg7uI+KNeyZhfUi5MlPHhyWKd2pKX66QC+9m8Kbo4aGbohnLS+Emb3EB8Tr43BJdzBf2cImz1ocX/pq4olJ3oI+79udUrYAnqv7E5JeARRhFg5j9HgIW+/YvjiWB1hqNdZcgPgMOMYUIRxIEZN0tz/qJYXZZ4cIUzzYkrd9KZ1Lyz01RswaSl8IIhsI0oyigY5qOdECeUroVrpGI6iGe5+ibebVDqwnRf0DpEueFSfaDY8vK4LZm4RZbnCY+VABblg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 04:16:46PM -0800, Paul E. McKenney wrote:
> On Fri, Feb 06, 2026 at 06:34:03PM +0900, Harry Yoo wrote:
> > These are a few improvements for k[v]free_rcu() API, which were suggested
> > by Alexei Starovoitov.
> > 
> > [ To kmemleak folks: I'm going to teach delete_object_full() and
> >   paint_ptr() to ignore cases when the object does not exist.
> >   Could you please let me know if the way it's done in patch 3
> >   looks good? Only part 2 is relevant to you. ]
> 
> On what commit should I apply this series?

It's based on Vlastimil's slab/for-next:

bc33906024eb Merge branch 'slab/for-7.0/sheaves' into slab/for-next
https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=slab/for-next

> I get conflicts on top of -rcu
> (no surprise there) and build errors on top of next-20260205.

Interesting, I don't get build errors when applied it on top of next-20260205.

-- 
Cheers,
Harry / Hyeonggon

