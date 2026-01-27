Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1BA0D2FEF4
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 23:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002B26B0005; Tue, 27 Jan 2026 18:43:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26BF6B0089; Tue, 27 Jan 2026 18:43:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB35C6B008A; Tue, 27 Jan 2026 18:43:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C57A26B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:43:38 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F25CD378A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:43:38 +0000 (UTC)
X-FDA: 84379373316.05.D70DC25
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 168B0A0007
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:43:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LKGjo9L7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qsAX2aZw;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769557415; a=rsa-sha256;
	cv=pass;
	b=CPqV71sXGvVZZZLd5VrfeN/uuTjiLSJ0dmljewbIeh1VJ/JB++ObnSYbXqroyKeztqjx3z
	dnojW07IS1hM5JTI/LVG+aHl+vR4xKAFGqn617tvICfxjQy9hMcOSZ7xh0rCvBc1z65cs7
	KAfRJMDkQTNgSlFoCx3vi1AG0Mqy8zE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LKGjo9L7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qsAX2aZw;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769557415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/7zYRLSrfS0IU8/8O7W+ehuU+j7CE39Eh5JYviRXUk=;
	b=phnNjbeIME5vvR58066iBT2H3bYEhkg8g4d2R1yv2kAuC4f9uY0r1L6ZWSeO7I4Fd2ozK2
	qurYkA8hZ4oRuvQ97k/2kN+7WLRM0R3Y3BHQqhHVt0CuOZ24VPkbJ5DqCGIAKlsc4zcrh9
	Oj7iZQq0rgN0Ag4ndCPp3gZOMAAZbuc=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60RNEKD7855754;
	Tue, 27 Jan 2026 23:42:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=p/7zYRLSrfS0IU8/8O
	7W+ehuU+j7CE39Eh5JYviRXUk=; b=LKGjo9L7CACwHV6cwI+0cmKj4X61PRMxXz
	Hd47U1XAiL134aZEmaUQmqVt6PYnj3U0c26wex0MR4o8Ts7nBiwDVt+R2GEPGNWy
	8vXDGr+wRaY5swajXq++KqegfIEeZduDYkpMqtmLfKpn7uLNLI6KuJRA4Ay2fqB6
	vN9U9q7zqT8wXuT+1TuNC2vswhMLWog0+/5XLx+e5vgI6kCu51lIfF6rqPg8pIXI
	Hkl6k71ZFjK6NoeyY6vTMqPSqKBICoUTilPxbSl0qrNuvx+T3XbQvi1f0TfTy78I
	N3lCjpoZBNRuUNkJG1RAuYZsmTKdhU9gx7XL01ZdDNxhJxewYZGg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bxx09h4jv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 23:42:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60RNW4Cq001870;
	Tue, 27 Jan 2026 23:42:52 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011052.outbound.protection.outlook.com [52.101.52.52])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhepk9h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 23:42:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OZNLeKoFzxrUdjG2Q2H5S2suWNrWvmpa1Ro7mM4kOR1KCdtsleUis0OnZwELRTlRRGhILteNVhi0fOuyBfwsrCNpnNheBN/7ad2M8OR+FnR4U0Rzjcwu6FJZJ3kj6AgXyBBq+njclH+ETWTWk/vv7gIjgRymMhNZUMI6eiFmVp17YOwxacP5PlZxTIuckB1NzjwNIp1kFhTyO8FtS6SR+C+dGO12YEeV6fSelyp8qXn4o1Hp058E4yNxirpL0unseOyWs3UtG/3STh97ukcoF+dwuzHSWwj3qUot0SfWatubkgXeG0xrdpKs/cgjuIUMcf9j47H0j6OpMyMM4BsR8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/7zYRLSrfS0IU8/8O7W+ehuU+j7CE39Eh5JYviRXUk=;
 b=Jaf9oj/TZfOfXEfScNBSpFbabuDe5uO+Y9Y5K6/NYSo7Ufa10yH4hdKJmt3vo4VZXcWIpsPjY+FqWVJxIq7jMiDoVJXciUR/PvQ+OBKLbfrVjF6gAo2XcTVtpfgNAEDvlG1bfEIH7EIyLJanpCzKBfN0R8PymLTGE8Q14nfEWbsvmk3LANQrKZlklbfngD0zagCVDXkyfFbYAPFWbO5Pbxq4oq0rtWs7ns7vZSD2RmjO9FmXEKrQsTQPfz4NeNeVmUhIM3HwsDLmFvGZuiAiCJ8jmFnW8S31Am+jaXbfTEwD7Oeg2xHu8dr7AjiZelPrWB44sVfig5hQTm8DIl/V3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/7zYRLSrfS0IU8/8O7W+ehuU+j7CE39Eh5JYviRXUk=;
 b=qsAX2aZwCCpCQtfirCSEGJ6i/v6uGZk39Po/92+IMUloD8TGTzaUT1VSLYEF4xVmdT3WX0krih69hhyLa75+fSxtags7f2FGdN7ENqUdeGMA/WU5XGP+vOOmd0fDxXmBn592n8PcqJ94uy+xw2t8MXz80t5e2FLUbydpIyTkE6w=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SJ0PR10MB4432.namprd10.prod.outlook.com (2603:10b6:a03:2df::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Tue, 27 Jan
 2026 23:42:44 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9542.010; Tue, 27 Jan 2026
 23:42:44 +0000
References: <20260107072009.1615991-9-ankur.a.arora@oracle.com>
 <20260126183212.2366596-1-ankur.a.arora@oracle.com>
 <b7549e2a-e5e3-4052-92d9-1e7361b52b78@kernel.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
        raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
        lizhe.67@bytedance.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] mm: folio_zero_user: open code range computation in
 folio_zero_user()
In-reply-to: <b7549e2a-e5e3-4052-92d9-1e7361b52b78@kernel.org>
Date: Tue, 27 Jan 2026 15:42:42 -0800
Message-ID: <87pl6uei6l.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0258.namprd04.prod.outlook.com
 (2603:10b6:303:88::23) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SJ0PR10MB4432:EE_
X-MS-Office365-Filtering-Correlation-Id: abf1944d-ce36-4cb9-9001-08de5dfdc45e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qwmA/jDbFLIhFPVCQlgPPx0YwlaftJMOoZ7R555ffmnxf8Pr4G+hBirtQU2N?=
 =?us-ascii?Q?+CYWPKqI1X38obc+UIc4gffuBXmje5nOM3mFQopWCLqcXE/+wWw9aapDJYGT?=
 =?us-ascii?Q?/8YJWDWNWRmj3uhkSUxI/vNylrD/kFleNuQv70GzqSg2B7a4fSUkZug+csRj?=
 =?us-ascii?Q?ImnTaT9foljKVA5eV2BxRO5C5aS/zfGvdemQ1I3KALm4w/E28nKuVYGEr00n?=
 =?us-ascii?Q?KyjKDOCCrwU2wsrT9lcC1MJnZ/VORAjpgN4zT9OszCzO1nidd7PE0DsTjYQh?=
 =?us-ascii?Q?lSICK6/uU7bQ2hh4hfY9fUC8Vn9UeDPk3nWFgVjuvSs7sTGw2RIkt9j+7yDi?=
 =?us-ascii?Q?PcM3s74arsxniAbLHm2jBb2YdYv7T+9ODYIykRpQx21eS3pDuiV3HQwPpbC3?=
 =?us-ascii?Q?Cm+5bNIXEyjgwam0DfQSUjuml6Dd3pVg+TFLeYzxvU/809Itogh2zURtMMQr?=
 =?us-ascii?Q?I9yDMuITkzY9aAK+NbipMUgF1B7j27rr44jUyo7EmQporLZGrD9F6LTp25TT?=
 =?us-ascii?Q?RUENWQL7JveV2oTuyEGY542M9NNUn+0IBAiBN7Ufu4tbFUShAZ6dfB8GvUYG?=
 =?us-ascii?Q?hSqgs799Qx/W9ip2fsj2G19pLYn0Co1uW8yLoFI37cxrMhmgK3oa0MYGp1E2?=
 =?us-ascii?Q?cl0va9XChcHwaschWb9Fpsg+6kOLlmn2O98cH/27OTz6YY39xgotn9bNHJNv?=
 =?us-ascii?Q?/0kyB7ZQcNus90A8dMbpIzoEgCrpSC7opYxQgIde9HH32FNclF7Jf60wVDAc?=
 =?us-ascii?Q?AFxrCVeJHzw7qovOjxBFZ1ALRfBAVxowfsXntnYNfDDDHFeaj0c0l2rBv++4?=
 =?us-ascii?Q?/a2Rs3Da/TFtmVmqcHKCkFscyUDbMBz/LIQTy+sETNZO3M92pEqBn0RkjRT3?=
 =?us-ascii?Q?TSLnH5i/5vU4NTELzU2Az3l0i+jbcCRPPaPfASAjxTXd0rqDXis1TaXwuxxw?=
 =?us-ascii?Q?p+b5H1tkmGjeth+F+EKXmpvR8RGKPaaOccYGfIA82c2LCY9OB4hbge8P+gCm?=
 =?us-ascii?Q?SwM1X3JxM7qJUTwC5E7R/I72kejh7+OGZM4MPOVojD8S+dTJytjxPgrqyCN4?=
 =?us-ascii?Q?d0c3moWiUEaVGFYxsKmf6OEvCNPrzBv/gYzN9WOcz+UgOx3H3s5bNhpuswdA?=
 =?us-ascii?Q?QF+FnUtbj0IrkkqaAE0EDp/5MtW1jyvFay96SikPNy9m9b4XLYlbJHlyyru+?=
 =?us-ascii?Q?NpHhAQxKGV6KRKJo55ji58WuznoJfSCqx6rrWT1GimFYN+JcTIF/dTEFMBoX?=
 =?us-ascii?Q?xQ4XtJkgnXetf9OwUpCu3hem2NnWnNyFdk1EkEX0uz7Ayebpg+9iXimdXJkc?=
 =?us-ascii?Q?gzTHAOQq9FDitCluve196TzFdBLy6e108wYdFZwURq1r2cx0gP8RhPD7ouoT?=
 =?us-ascii?Q?e1fxIwkwvbnHtQ9ud0Dj/qVFpkYUCannybkOIZ0XsrbFltWSbnYRwGg3n/l4?=
 =?us-ascii?Q?i7XUJJWc80fNRokDPBKIxazMd/bJyt+NWlNMwa6sy49NtlDuLUOszsfuTbTq?=
 =?us-ascii?Q?93ey2BrmdZss7cwyf06ZU8vv6x6HiDDtTBOXzFl/oU4FDntfiYhBEk/+Bwe/?=
 =?us-ascii?Q?Qs4npiRmBb7d9Usaw2ieJO2+uxcR9rQYUAk6oIgw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KKEOEaHXghcHi69HjrC4B/Q4NM+U7JyFN94m4YY8tgBSVxcpeQdgFstliczR?=
 =?us-ascii?Q?eelMzNnTgfrqmR4t89ozFqsyZ5f379+iPa4xHFGdQYLJlw7ZkJoZPqUiKc8u?=
 =?us-ascii?Q?XNtQ1a2dzmBC6jgMM2Bv6RaxPWFmehWM16YuUClZk3UC9ONzD1qoZ0el8rlI?=
 =?us-ascii?Q?9t9pgaJHLNQb9WkgJ8ma3dqYG1ATcFBYsfz5yhTVoZjN1Vm1pi/mc4pSIy51?=
 =?us-ascii?Q?cD4qEFWNXtaqqzazJTzNj4nr2vPNW+kPrbaanwuyp/66vOF+kt68ArqM+qfo?=
 =?us-ascii?Q?bWTV49KA4FWWHn5IEZvveUuuCJRiEm9+RyWV/sRvKO9BEZdihoAihI0gd+XL?=
 =?us-ascii?Q?Q7AHH/S/u0owkRo2T+mg2TWKRBLXLbzdfPNSlY4MgMfWCES1Gq06FV3dW6pe?=
 =?us-ascii?Q?3ss451vMGjBIiiZ+F4fsW5hmV5JHfe0yoczMU2p5gKa9O5x3E1uBTeOSBVay?=
 =?us-ascii?Q?0M++5t6x/c4e9+Jj5/sx26w3heu/b0fWVABuxgCSfz1GKjuRAWeR1j4rx7IG?=
 =?us-ascii?Q?PgKE/8E+HAHTHSGdu9KJ7y89gY5DWoUvHzd3eFEhZaY/vbjcRuzT/tL1cJ93?=
 =?us-ascii?Q?bON1my0ZDY3zF45ReVMkND3nmv4zGcvkaPfM+3WcIy4SbKaocCOyvZFouJvl?=
 =?us-ascii?Q?wljkGOejWQKTxnT07PmbPoRDVQYgc1OHx2mwkSE2I11wq1fHdBO88G0upHOH?=
 =?us-ascii?Q?UFgeWZ5LLl+N6iIouPfgJojlciyAvwQiFqfLg87GwVjbqheAUdQlPWQ5a0eU?=
 =?us-ascii?Q?llyFBhkL1EKqx5LXrQVTJ4U1CLdVEMcHCs3CBiUQ1qiMxj7gCcEijVnqyN8T?=
 =?us-ascii?Q?ePKd1m1p9dqAcFySodh0g7/wbXQIcvIzaShYNHBY9oEOV3jtlyRinD5u+j2f?=
 =?us-ascii?Q?oUnX5C4O3mI4ALabBFkaKbzekfBPSBHXqdpWAbPYLwT8ftkZbY2CxB73HPPf?=
 =?us-ascii?Q?vTueCcs5F8o2JYWtlrVnCM5SPN9mcwZHLYUYHleEC+ReNfDTIEX2/S3plP9H?=
 =?us-ascii?Q?GigqirNVdgWZJ3cBvBYbnz95999Dgrr1GIYiyPeJTObPX/EC9Sn3VJre4aMA?=
 =?us-ascii?Q?qcZmb3P3uLPJB2Xc9F2N5198tgulzo0deTpLrZwXCcRKzqn4PDMUL/qj4OYJ?=
 =?us-ascii?Q?ze8hplxLZG72jklvnqDQPnvNOGgJuXpPo7Hk5U/rW5zrHp4TwsTn6ag0anlJ?=
 =?us-ascii?Q?jSZIUIJct1P7FayRwLL776NnjqQTw9vSJpkWLn1S8oEkE974mC4em5XiTQLK?=
 =?us-ascii?Q?euRoSrddLKz807+3IR8i/ZkMhC2P/Q3rQ1sTDPEKcU56I06u4BcxQTYt5quC?=
 =?us-ascii?Q?ZSsymjAuc9Y3daOjUCd3ln0FcdjycNIKRqlI1KhNspAPF6/DEjGpRosJKVk0?=
 =?us-ascii?Q?j2Uxd8XpsQ+xM6qP8MjU8xXX/HvLe+xeBYanvk/9EgcZoNJyDzvlPkk+7Asi?=
 =?us-ascii?Q?dLOwU3g1cZcloV/da7o7WAiW2/4/akYAcbc8kGNqnNyBDkjQyFr3tYxYrTBC?=
 =?us-ascii?Q?OYogdgkRT2HDZ5vSAiO2XHHqkPJj8cJMJ4Je1DJFDjOmz9rrk/wDJ+NKlNV6?=
 =?us-ascii?Q?aefxx53iGuEYJaWKW/7iNngjkn9yeCAlmLxgM1UGMJOkqd3HGxvAS5K3E7ZF?=
 =?us-ascii?Q?Nn/Nw9CekDliSuwUfNMMZb4ak5pceVm6+tcfulsMLVZ1DBsEvlhmvCUyg/NC?=
 =?us-ascii?Q?z94pIpnG4wrQ6Yp7NnWjnKN5ijnVaVTuwLQb9khmxe5GolXpMjMRhYsDPGqC?=
 =?us-ascii?Q?JPRXs5rL6DntxVFSJyR8iQ4B+pni6ss=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C6gw1jRE7lz88dFKLDHTt1bPqy8+vGhs2cRjnb3myNm9ufIv3Xg3uuVpl/6etIqXTHSzjSg24+IDBoGRxT49gTnVoU/hfc54Epo1uoXvkyQ3mGYVTb4dJjhK94VP8qxKu92ccitRrT4ozTvR2Enhy33Vu6NE1yCTIao8H/NNLRhrkIZ3GKde/w1THDLflVAG+ZEOb8FSltuAfLXuorPmOAjDwZzt+oIPqKKZnXrNG2rxqPEqiBZ8hQWImcHCJHs5xOi5IWJXMVC1fC5ZCAa2ftRD4dXILeLAoThVDkot5Xns4wry/eQEowc0bfX6fXTVRlfvTJFwdMimUsw9By5t+Y4wSYQ5nawv+dPwct7ao9kpjVQtbS1MGUqxUX9ipuhrxd/l2pdk6zqaDchfjSv3qVruwTC2Zl06FJGJBpAbsDiTjOpUKA7xYGUf9MTU11QmgDZjnlsWKw+0/DkpViL2v8TXlFvV2ELPKm6tfZ9HdSvYCGaR2zLEQb7n0lV+U+xG9W4+jVdfTd/v51uzj/7h43mTmmchZ0CHd9HvG4v011pPX1jy/xqWymICheNe4d/QIf3ddF7kGQ5/0RwjkHyA2IcGYnNLZh9ubugbgt571jE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abf1944d-ce36-4cb9-9001-08de5dfdc45e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 23:42:43.9628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jbwncTa32FsTDbfSPwJB6EBQ2M0UdIyV6rxsjtSr5R6a8d3Aopvdt5iJTkfNgU7Dlqi/5D1LV1TfUfU0Ai87KH87L79JSWQwIYtFT2LZl+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4432
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_05,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601270193
X-Proofpoint-ORIG-GUID: TTwGvUQZkkhMyZWm0N-mI1tUZftJUWWm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDE5NCBTYWx0ZWRfXzHKPy45WMNs1
 jacstGEhM8gFLsr72NF6wrfL9Rr8/RcPc3EYTvi1agq2NEfuRZjsr7kyXY/3m34FahqtccoWEJM
 af+hp+kYU63arwNkfUO6zIngOk/vY3PexbPITseNrpJ82h9K3UUGfnga1X6SkVvEdY+1l8PVGeK
 /bmRFhuGZm5Gvq42mkvrNNQk1wcppmnUOD3enK3d4OZ5yHFDPhZXn7N11RBcJmch+sJNjli9xvJ
 ToODcKjonkNmq8b72shSqUOuZbSLe0AH+ufBBh1Q1fpbRznpvcw2gmhUzV7pOlNE2X30lk1URTq
 IepX+WaQHc7PVX94yONbVk6QSEd37+KMhODcF4z3bPaigKXHo5J97T9GNdHyEUMxl8GNUHgWfnT
 SRyO2Z+4vU2nrdi1H58viMlv7XNK88KzbdXK2CW2aoOrTEEjVnQMKm0Iu0Y/cjq1FiMH0ldquIA
 A34pwX3sXFszPQK9oD0n6wOkWK3couYvUPHiebMk=
X-Authority-Analysis: v=2.4 cv=Qe5rf8bv c=1 sm=1 tr=0 ts=69794d7d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=yPCof4ZbAAAA:8 a=JOvzhGu9rYm4vAsCd-wA:9 cc=ntf awl=host:13644
X-Proofpoint-GUID: TTwGvUQZkkhMyZWm0N-mI1tUZftJUWWm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 168B0A0007
X-Stat-Signature: qptkbfe79pbj56p1wapup1ssg5drb9we
X-HE-Tag: 1769557414-872308
X-HE-Meta: U2FsdGVkX1+41eKRQaTpwpChHQIL1JVm8mzPnfSG5epRlyh84Ap9KIGwZTMXRpQm2gn6BHcQpH6s9ErB3db+YNGomJlQW5jRDR1YnyCO8VPzb/Udgta1zMTmjVU2IswRbGwh5kOwGlsJqgIATLKvAioc8MVQozLOFYxE8xT6WajccykmCSpG53vz31Gu32B+s8RMXaV1p5RTH6/hXr3fAkqFjXzDgf7CfAOtgF4induqnmatNicH7vsjny3C8YINZXAAi4GQNxT5zFaRZSEBPxFgbOJOxlLe0FNwsWnYjNBNMtg9Pc3wsWNOYLR5ukXhWIRRm7q2m5NCu/5DXO8rZK7h2tDp5DCNfG1Xmz5bdbbVqaMJjNy5jTrRAUvvfi+F2g6uQbGqnTNpiM25g6YCHLzOYEif7NK4VMaRdyRMvP+simM6cFg3bge0aVFsj15xx1MMJx+h1HHe/sC2bYKRL2989Gdrgb2kKHIwNJwlpTat9GveVxS2avOMEH0VJpRCb9TQUaBenfpOYeDpwBgdWIJ7vwW/EuKieHt5EPV5NIcgqUQ+v1tg1CcbLkuIJXj6uGkihyUpiRRk+UBDbzEPDQeWel4EBSbVQ3uLdT6BEaaM3sAKHEjiF048J18LL7iGBlsZCPYkPx80qQ9QmZrW3zyLJmfn9gDbP/6Hr9eeHpHCU1Ere7FSJQmKiZZufEMi7Sq7LgsBbn6I98GU0Rgs4M3bCzFGKTkd8ETrDs9bzTecMlYE+aAB1wRdeoiVkGzMvgLWl/pgTARPrIFJAdbNo1gWyycu2utnvBm4lBbz3VrqQXHfv5HzJKN1StS0l4hMYkuEa5MaPaoo6BQmYo02BEUGe4SORdZT23E1V6rmbNv8Oe65g4e0z/eWCJJta4705DJwxEtG8GrATUkroFDZchVJ1Em5gymOSTYPdg+TpPHiTjY25K0oJP5Bv2IEWgQpak+3dZRqx4BRXArcM79
 vsrOeBZw
 Q7JewBAt7LQgkBuKnsy+aiLydTUllu1bUWygSxH0bIRL8LoSdS0Revz8TembKhQyXlOnb30Jg1x76hT/f+GWXXWrCxcgDPXpJ0VCYumRCiUALRak5VW+t8n6FtkMdZevW6rtZqFx4Ro4P/Bnnne9ihW5ZIpDI6pWyHjEV4QmPgvhL6uv2k3ViHbaWazTXUsNxaYWfObE9EbthdAgTiQtyiIJ+38N3rdCge5OaZJJQdtex2xT79wF8Ejd60lmOCJ8sXUz3Ail+tMEeSXq2UbUCjGAE7l6oCoJMeaSXi+oCykb7O7zcGBraATj5Fe5I+N3dLpM8kpgg1fsp5sAd5W2ZwgREAwa4e+Ts4D90Y+5/CqofKx9B14nR+PIr2A5t4BtMpmZ3MJPkxpIR+D6ZCposELLymwSAiW+OITRhZgwhql51nFrqJHfKmJOLX41P7sSGmgWULQn9x4n6IUQXaFkcAbv16/YD15IYWXHQEUpAAkVEFAMAxY+Wjc5WyqPG7LyJe/ABTe9yk/5DNoBRoR4j+mKWBiVT+zk8Eh/JBvO4guELvzsJNom2k3r3BdakwXqGhMWvoJgEXgVlgfNPqA0/yxnxYFFzSZ8LmbVKgbckzY7eYtKsE2KKP6ABsrxvK2mf3SLBql78GZXV6RWtd3TPFKOU0dkLy0Fk30WC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand (Red Hat) <david@kernel.org> writes:

> On 1/26/26 19:32, Ankur Arora wrote:
>> riscv64-gcc-linux-gnu (v8.5) reports a compile time assert in:
>>     r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
>>   		       clamp_t(s64, fault_idx + radius, pg.start, pg.end));
>> where it decides that pg.start > pg.end in:
>>    clamp_t(s64, fault_idx + radius, pg.start, pg.end));
>> where pg comes from:
>>    const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
>> That does not seem like it could be true. Even for pg.start == pg.end,
>> we would need folio_test_large() to evaluate to false at compile time:
>>    static inline unsigned long folio_nr_pages(const struct folio *folio)
>>    {
>> 	if (!folio_test_large(folio))
>> 		return 1;
>> 	return folio_large_nr_pages(folio);
>>    }
>> Workaround by open coding the range computation. Also, simplify the type
>> declarations for the relevant variables.
>> Reported-by: kernel test robot <lkp@intel.com>
>> Closes: https://lore.kernel.org/oe-kbuild-all/202601240453.QCjgGdJa-lkp@intel.com/
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> ---
>> Hi Andrew
>> I'm not certain about linux-next rebasing protocol, but I'm guessing
>> this patch will be squashed in patch-8 ("mm: folio_zero_user: cache
>> neighbouring pages").
>> The commit message doesn't contain anything needing preserving if it is.
>> Thanks
>> Ankur
>>   mm/memory.c | 23 +++++++++++------------
>>   1 file changed, 11 insertions(+), 12 deletions(-)
>> diff --git a/mm/memory.c b/mm/memory.c
>> index ce933ee4a3dd..e49340f51fa9 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -7282,30 +7282,29 @@ static void clear_contig_highpages(struct page *page, unsigned long addr,
>>   void folio_zero_user(struct folio *folio, unsigned long addr_hint)
>>   {
>>   	const unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
>> -	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
>>   	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
>> -	const int radius = FOLIO_ZERO_LOCALITY_RADIUS;
>> +	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
>> +	const long radius = FOLIO_ZERO_LOCALITY_RADIUS;
>>   	struct range r[3];
>>   	int i;
>>     	/*
>> -	 * Faulting page and its immediate neighbourhood. Will be cleared at the
>> -	 * end to keep its cachelines hot.
>> +	 * Faulting page and its immediate neighbourhood. Cleared at the end to
>> +	 * keep its cachelines hot.
>>   	 */
>
> Why are there rather unrelated changes in this patch? Like this comment change,
> or the movement of "fualt_idx" declaration above?

Yeah, that was a mistake.

--
ankur

