Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51989CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 05:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7023A8E0007; Thu, 28 Aug 2025 01:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3198E0001; Thu, 28 Aug 2025 01:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553098E0007; Thu, 28 Aug 2025 01:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 444318E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:38:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D63E95BF6A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:38:27 +0000 (UTC)
X-FDA: 83825061054.23.D1E8625
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7E5201C000E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:38:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IKTwOCyU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PXxQdY48;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756359504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NCWgxcI5fvQCUveZ9gSj8PQ2OmqUVbS4//UEWA2Z8BA=;
	b=OiFnYjZCsCe+20bzQ674XvTRb1mdVu53tSFnnDPfPEIa4hwcUdO+r/1CV+lUnxVk3LEcoE
	s4KfzBwZoTR4Xr5cE74Cud+BZ+BwCIlkVDM0uTMrDoa9+XpWJyxQyikutcpUdv+OYrJ44p
	3Gfc82Ll496zqbe6Gt1tOaXKm6hjKJo=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IKTwOCyU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PXxQdY48;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756359504; a=rsa-sha256;
	cv=pass;
	b=LO93Vd6PISopaFP9Pyy6l/1S0cRq6UlOPHxQo6fkTjcxZ4H1wtrAYtn/9CH2R1D9kaa7HU
	frbyebzkdYziZgCt05N1a/GbLh6czaTobw9BR+TzAIkBysVbeGO0Z0IO01W9vEMdTcb647
	Z0AbskXkKj49Su5q7DCwfFWUnhFDnZk=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57RLH57a004683;
	Thu, 28 Aug 2025 05:38:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=NCWgxcI5fvQCUveZ9g
	Sj8PQ2OmqUVbS4//UEWA2Z8BA=; b=IKTwOCyUCzxzJUW7w63+/R6WqnMJO/I8ph
	u7GzxgCcX794+5aN8fMbnJ3FlQ1NsipXx3mNzvTFFlNwhs9aKrkH0E4VTXu4yz4P
	Q0zhGHpnd44tOAMhVmPH+6jWBJrkCMmMnlc8191Peidb0PlWDU4P3+8dJ6+flu+5
	IUEdSEIz8zS9FLRPcnfc3D4CHj7mWyfmFcot4FMDLGhUruo4Sc9nYH0SpMXmW3y8
	0eoMe4sGfF/mEArRp9ZPmQudFWp2k3ud2dkngm8b/PSoRA4fs4fwaB4Ya0vHpxl3
	Y0YkoUQ2bNypQ7KKvU0aekovLShoIHSV/ufOAwYfEX0Snqy8vTpA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4jaqt5t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 05:38:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57S4AlcL005431;
	Thu, 28 Aug 2025 05:38:19 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8bq6ga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 05:38:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UzG2BI3cbLt/4hwmw7rJpvEZ608PDtl6Mf2AJ2rIhw9oFgVPQ+BrSCGCTa0UKt4vMkKOVP6PHgwyixtvlraPg7G1SlSFrQiCLuq04/x1EQ4Hs37ODqp1eI1DEu7+znSyny6iJJg9l0tk1Eb3smcqLOmgDSbSX82bXDgVfr91gaftAg0ULnkzWtK879lzbRKjJYgJG9b2/YIkJOMNTpl/sYxMuTUMJY5Ci6S7uDcpie374z3+t+IQSlNgUkL+lCW1/RrPeKmeuTZjkRBNX+F5J3QWudekFg3Wh1PCLu3zJ2ilOjpEpnkSVDpjuIer7dZ0r6Y0kj3S9e83IX8qN0//rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NCWgxcI5fvQCUveZ9gSj8PQ2OmqUVbS4//UEWA2Z8BA=;
 b=TVJL8ZSIYLWl6/0Cs0v2I/Av+s5GsXNYcLdUPp186jXcQ3n1iRH1LfVJWP86M2QlOCoOndL+Yjk27cY8Bg4WpN1kPAdtZ8QQp0g+BSoeoPnli+KDw/Cz0TiDRuMoKAQZjSDEN/+Rak5rvZ2KV6sCcHZjdi7d9nu9zA3x5KIaBZwD+vgloPxA/9c+4qp5F5ZwOIYf/VAq1EzoUPWsSkv1+LWakrC4gr3nroLwyxeAqOCfi2Y8HwY/I1ppaFklZ3IUg25Eeg48e0Tqr6N5wpapffqr9y5R2Bm5kExGD1/BKJr9sqDb4Xp57FXm69i9qHKxP6ub/1GqPaJbhb8saBW84g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NCWgxcI5fvQCUveZ9gSj8PQ2OmqUVbS4//UEWA2Z8BA=;
 b=PXxQdY48G5pxOfuXcGYSPJLl1wk5SonLDwtPenhCGIvtvmxJ160/d6oFdE4hKxACG5hY+5yUR9FzLJTe1kGQr/3sxVgOWJH9onZYZ3HHVyoMtunDarre3OdfOTEgjBLrUatFLOKVEafxCCEW6CKBVQ0gAojEbh15uwt/NUbfMok=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PR10MB7971.namprd10.prod.outlook.com (2603:10b6:0:b::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.21; Thu, 28 Aug 2025 05:38:13 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 05:38:12 +0000
Date: Thu, 28 Aug 2025 06:38:09 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Carlos Llamas <cmllamas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, kernel-team@android.com,
        linux-kernel@vger.kernel.org,
        "open list:MEMORY MAPPING" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/mremap: fix regression in vrm->new_addr check
Message-ID: <8a4dc910-5237-48aa-8abb-a6d5044bc290@lucifer.local>
References: <20250828032653.521314-1-cmllamas@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828032653.521314-1-cmllamas@google.com>
X-ClientProxiedBy: GV2PEPF00004527.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:401::348) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PR10MB7971:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a1ff3f0-125b-40c0-e9bc-08dde5f513f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sITLQEaHBQlmhhT1cmKntgrQP1G29VlXpeEl78FfcSkWT9KJ/YfGNWaxr0nk?=
 =?us-ascii?Q?+c0xaJvgEGmOo0Qf/RbHQLGHXNrmnTSg8tptncJOW3HNbaJsCng6FKmGmrAt?=
 =?us-ascii?Q?+Ue7ZtSgbpR+HPvpG/+QJp9pSY7OpypjzFseOV5yHnbdiL8VEYXQmxHek+1T?=
 =?us-ascii?Q?vOU/Dn975M/MLg9MQdzTpcIYYIZU064ls5sqU0HGSmWLQq6x4a73cWt57RZG?=
 =?us-ascii?Q?tddVYM5XEHQY5TVdNqX1SbEGzbR3M6/rCrP5nQc4b1/bM0sGFIl4Py/C1lmt?=
 =?us-ascii?Q?wzbjhbdRDHqaq4YDxPHqxMPamuH7Ensw8puDff4g6Rx1IJo2rbQOY3tVlk8u?=
 =?us-ascii?Q?G3E9LQD0gRlOAUyAk74lKRpi7bslbNw6Iwzff8+4hXGWVzAPR82K0opncY4x?=
 =?us-ascii?Q?B6JVAbIgQ5eTeOrGrEwqQUKzRHF/vA/MzAvXeeHbhvulzkelPpgf+rLJcRZa?=
 =?us-ascii?Q?a2ne1QTC4a0TDb4+ILThfGqs7QA4g2hHX8raKwbL6vFv97/zpzEb7rKxgGZ8?=
 =?us-ascii?Q?E3PuoY9AkCt2fjbUowyHOgQN60cWbyEqiOU84/6uV61WjzlO+6qj2DE1aJEO?=
 =?us-ascii?Q?AuH/M7a7uESskktd6TdBcFUeCbPFOy6MJyOvo6PulGHTVldGuoaJ4uCi0p8I?=
 =?us-ascii?Q?HSynnMuCbaU5RlJikc5JkgyEsq4zeRPWRS14SUGL1SIM/TnQmEjE5dJX4S+g?=
 =?us-ascii?Q?Pja1RsVdbPghTfiDI8wK+FjgtgKU0uw1MnCrRIi/iuSGW0aO1OhL5wadoDHi?=
 =?us-ascii?Q?TbIq4EsUo9p1aeG6e80L/WO5mXOAVuQ6dlw+tjH/oDNZKq5GcQ+DLGGdALPg?=
 =?us-ascii?Q?6x5O4Tf4flW4Xq9PeHrvQrRioqz62WpGrFESAxQu17nvJNr1kvxVh81IFNpz?=
 =?us-ascii?Q?8iYJ6fm+VXWUmx5gVKfFp5nooapUhQ/krx4xh6cRLA4AYANYTURJsw4ui2/h?=
 =?us-ascii?Q?8CH5jyYdSkCmhDIkuhhhWB1JJxWNzk5Tk0OJjOPh6QqlQE+hgi7zu8efKl1O?=
 =?us-ascii?Q?H5PO776G6TufY4pJInqT8FBqz0VylHhLISl3LJKDUF2xuKg9I9mIEbyI066O?=
 =?us-ascii?Q?oWKCCTeUCEF2Gc2Ztx6soh6wsYc3MMHgCoy+zEqmmOG/RHYIPBqBEDjOsAvI?=
 =?us-ascii?Q?zB5+TcrtKl/3gAnhSdzSPPSwlBjJuFNDaQZ6eC3cFFsZhpHhBM4Buva+6wOv?=
 =?us-ascii?Q?LZqYg1P+bdaeyP281zyhWCCWmUQqakLk2UyyxbqtaYc9cZuxKzP3gKRNIWdp?=
 =?us-ascii?Q?1oLbMwDXR7J0vMgE+1TBpagWaqaGdOg0sGIeSygvfCQXO3YDaeMaAjNs+yk1?=
 =?us-ascii?Q?28K9wUnsXuqFk3vSii7X3qnwUXymwYJJR69aIDAAg4PzeDvuV3Oz0lCZIvAx?=
 =?us-ascii?Q?k3hLXNbZ9NoEVURwBQeEZ9t4FEsLufyVJbYdpWDCfbN2S11sAw30mU+H13HB?=
 =?us-ascii?Q?NmqLkIdFPWg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CBkUo/N+VeOjGNMd0EbMb9Gu4UXTkeIFKsT8QzmeeCDMNkt1N2YF66DCTSAQ?=
 =?us-ascii?Q?94stSmWnlrx61O/l7VYX8eBMq/1e79lWfuW1db5fYJsr7ekP/pZiZ+Cn2Ksb?=
 =?us-ascii?Q?QPCMzwXKDYG65wLm/dAzPt6B6l32/JUanX1jUaORGYsGJbZBV0YXkzy916DR?=
 =?us-ascii?Q?pN+sZMDA/RGhJnZwW1t8Qf+tW/B/KBVCrPMD2e4faHqNyckIea4zpL35U6GL?=
 =?us-ascii?Q?//8SCAbyKGKBzfeWGURyr2X+87q2qFJuji0lHaaBPoUhKmuQ6RvY+UMx57PL?=
 =?us-ascii?Q?3Q7PS1fod1nZR2/3WLGlvrqCPp7S8LMyPepQZUnpBfEsecYqWOsGJ29WeT6O?=
 =?us-ascii?Q?m2AuoA1B8JYOlyaTm2XvNatfQrIx3lHwKFKcKZvfJvPJBupqCl/Jikvc4Q24?=
 =?us-ascii?Q?niAm5P5s76Yrk3nIGAQ299H6za0R6thEgm5Bmkj/obPobSw8fSL+GrxHx/sI?=
 =?us-ascii?Q?vV1GXAji6PY3eTYqYv90Mwc39pYyGG1w88Gb6cGZ2A1CflphcTmVEi8SYI+5?=
 =?us-ascii?Q?J2iEMdKmpsQbSFu8lKUk71iUn+0MR7je6b7sCEMgI4ML50dHjOte0wkK5XPd?=
 =?us-ascii?Q?qFK90MUUBxKqit7OAjIa2U/xfoCMOKK6HqThVLB4vZAFsd+LIoImj8+zCHcW?=
 =?us-ascii?Q?s2UxX+9/2uJHZRcryVMJjBcKfjHQYpKXgkaWTVWbhgmmqKi9RaRBBJS8a0yr?=
 =?us-ascii?Q?9NZ7qVXjNRg60wtpcu1oPlw51Jra0TFjbgbnc0gpg5153LxCSjq65nKK45St?=
 =?us-ascii?Q?3zUZfNCFOK3QXVP9Sfj8vB5pZ8j30A5FfSiPOyqP7qheA68cDjj5SkxBn6h6?=
 =?us-ascii?Q?qI6lj+zXXlBbCpgDTjsDLDBERsylqP9pkbRNAjc3LcYH6KbUuWQBNa0Pc9KN?=
 =?us-ascii?Q?lVootgN+0tDjxXwqqSptSIaPd3yDCczIFgNysPedPOT2QrIBWXPMWMD/kgP4?=
 =?us-ascii?Q?zuVRheQkBeXdZq4N2QHBcmRKfXqIaa466H+zktRZzHH3/EJrfTZP/JuWcE3f?=
 =?us-ascii?Q?/1zmgGRerWyMwq1NVkE5j6DScj71Ja7UFskoJWwkP9lPepkn6hjWUEteoLi2?=
 =?us-ascii?Q?nUiig0z2+wHzxl1Klrecrutlrz/GP5o33kXef3d2uJy0MHhtAxcV6DwfVbdy?=
 =?us-ascii?Q?bl8xPa5gzNjFiIq7Qys0EL6JjN+jsYEfHl7NEA4S/7ODDc1iBASpK2o/d2xE?=
 =?us-ascii?Q?kFYvH9vnXKndu4W8SdRu4zjFneM27Bod83fTeD3Y0fryttXiLMjGck7Z7y1B?=
 =?us-ascii?Q?9LxdNYoKfugzs9n1RZSpCFvxsNrn7vQbZQGZDQw++5swk2mmtOhPzgRPEAeu?=
 =?us-ascii?Q?/FmiikNDIIBPClmUbyCLERwDTRZIVojppxOQZ+gfssVjveGKlpcfF9/DafPA?=
 =?us-ascii?Q?pWTwSPhVBfVaJJ+Z741tAi/FugapnGGo93F2ZhJDv+589T0IwI6bufcDlb9n?=
 =?us-ascii?Q?zRwEf57B63gRQx/0hlmNqpwIoXlfeqnUa2D2hETO1rLKkT71Hc8QUs/bVZNt?=
 =?us-ascii?Q?yVpG0yM8DQVZaCdt17ILt1+CpJRXVZjCZpT64EHfWMHCGttgzM1sMuYfN4Mo?=
 =?us-ascii?Q?N8x7fK35XRNeq0aQTxnkCGPUmkbEePHN4+qyZadbuQPQP2so6vVPCii/+4Iq?=
 =?us-ascii?Q?Qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/CrQCk9pgTAY1MexpwuIe8vl8ujELwfWyxOT3NwbSG48j9pJP8SuC7tyDc8dagLLmPaYAR5e/tJ0Vz2G2OTkCyIuRuaan+dWpY/jgfc6kqt0gyQiOb6j3AY6V+SUWxdKwRQ18GbOEYWqhTinYbvM92tC+JjY/jd3KZmUxzudgteahua0Y/ZORF09eZ/KfJo6J2015Mjlrhp3R7vG7KyrvfcH5BB+0CMBL6LJ7QvHQPEz8p3Y3O0wWMBKBgRkjbykx9+ctXzHXAwkcANkRJWP5Rc3rLH85sJBB5+F0y5t2qsXjyYpRJvhx1NQ7pJpm/nru9OmIG5lYgxzohSTRVOVkJb6GkkF6ubtOS/+uy4uDW17IxHUgVXmUwsqm6WtkpmTAmTiDiX79EqfklyEJt56Z/+so19Inj1CtDsO+PRHRgt/hj3UXfMiGZwvodU5TddbVprqP77b0Oy+zQqKDRBkzOtGPvFPO/Ivszn5Ec1+awfWghXZ3vomxitbENbBJcKWXqak3g0tb3mt5B9phKeVLsp+4oa++wj/34JsQrSv6vokd+Yw7dEaqbtxzlHtvlV5uF5Vz/xyps+EG+BSuFgaKoue9uBQBj5xXSRgndri590=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a1ff3f0-125b-40c0-e9bc-08dde5f513f1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 05:38:12.1764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g6OiodCKw+phbPjx/Z3XQcWTgJd6the4ug4Igp4Mn9UjdmXg7N7hKeVamAd90uqLjXPh/9j3mZ4xLQ2co8ozk1VaACRwon5+Ugeq8w/TxHQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7971
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_01,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280045
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxOCBTYWx0ZWRfX6iEyCg1pR9KH
 754glQe7/zo689XRz2ErP6kBDAhRjIUsvn5v0lWorHs85oOEsfHgw2WcH5U0xEJ1cSWL7Nd3d8W
 uOWPtPFNbrym8Gcc3WRyHX24wc9NmEw590wY3YrPsPBHI8+98fjTLcof9Yvtm6mZM6qRtyiMgBG
 vF552WmGqMf2b+H7WmAttTyJijAKGQ1vjGKigQ/WkwM8KO9atOn7+GCqIuUYzgLFn5Zs3SS1cqB
 07zm+Ks7V6UxsGjxiipxohFC5wC7e61rQZOzFS6wW0w7lVhj7r029KJSS+N23DzrCmCD1V77Vgd
 yk4HYDR8Y2yCHl9PMm8ajDet3BjY6PELwI5I1HBWgDWHuyAC1xWbrMwC5zXmL8h30jsZk6TV9q1
 ZVfYPRftEDeGxUxjsdaRaPS1ALHPXg==
X-Proofpoint-GUID: Xwf1dgISwEewgGvy5T5lz04_rWYodOVR
X-Authority-Analysis: v=2.4 cv=IZWHWXqa c=1 sm=1 tr=0 ts=68afeb4c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=rU-2k7L0ub5ZonEggjYA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12068
X-Proofpoint-ORIG-GUID: Xwf1dgISwEewgGvy5T5lz04_rWYodOVR
X-Rspamd-Queue-Id: 7E5201C000E
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: cr4n8ob7ringxru49rbtobgz7jrptckz
X-HE-Tag: 1756359504-187102
X-HE-Meta: U2FsdGVkX19wNrusvc2W2E8UqC+u2uSAOn8nGFs1MjJsEmwMuKXOjkc8jec9l9BlzyzUfpArR/vt96h+B0VaNnXRuOEGCpx+2HhIy9dz60iNk1bv6bWvBBpoolymtKpvd2S+gnRFl44uE47dXDBmuvZepm2GFALg3Lik6fg3RiDjGNZlB3ioyQO3CB7kMLk4a0Y3bfHvJpYNLmHgJdj+fn7L2eO3xhPDLbHzkyebeg8N1rmmZcamWnbejQ9i6ZzY6pHT2nPKax7s/CyoPpwEMAAwz72hRHQ2o3mWge0uEH/X4qLLYnL84rm1p+1jQgqNeDyT5ngjZTD0tDka98HUArUonCPh0gAUNJy8I3RNlrfERpi3fqV8jXInKGMxLmlFj1pDgxMv2Ftxz+STOBINk2cUeOlsNaQ64iWdnzICJagYAmD+ALaNuWGCPFC7LG6vW+xCpNQv7FufoSsSx552AfkqvDh5BK3KMbBI5Qn+c66HUOqoPVK1wgm5k2H3C46bW5GFZdB3MeKfs17UwRkOCvV2PZFGG0Rf2asakMBhY7/6QoJHfh7jYx5taNa9MpkP6UTHo50rLHaqKsWzxo45sXGceg0nXAsfzbvCTHLbxlr09mngGQv+lOaCjoCjl96cIlLz05NdsSuNWVEj1F99Xh2yQiSPaVcoly9pjXj7HnXOnZfPvSPlqCjpqJJwu6Bhqb3LDrrG8XZw/cZrfMgPZJ22uCzp025EoOu8k71pvjfzg/HxXjncsJ0l18JEaGa+4M7rFKUkHsXBUuxEO6glLBJ+OAMSHdiR8AjOxDsLDF4WEWDtexaYKf1w0upqKeB4dLU2qq4zUitv9fe2OPOrnmaFYXYFqTldg9W3DdkigD/4DhUqIPxG2Pz32XzOMQl5kpDIhSHZ5NNXZrBwIl6u4sAhyZJJi0ALU5rPrdl4hE1b099a8xqk2a6RexH3g2w5sxDUajuOwTguq5vXN8l
 8G2txlnA
 xjPSLKk6EUZNIVnwky3kfxjXWBztySptkmYybHTcUUshtvs9jKjzL0T8wiScgfo3thqo6EeTHPwM4oZmgMPX8DDXCOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 03:26:52AM +0000, Carlos Llamas wrote:
> Commit 3215eaceca87 ("mm/mremap: refactor initial parameter sanity
> checks") moved the sanity check for vrm->new_addr from mremap_to() to
> check_mremap_params().
>
> However, this caused a regression as vrm->new_addr is now checked even
> when MREMAP_FIXED and MREMAP_DONTUNMAP flags are not specified. In this
> case, vrm->new_addr can be garbage and create unexpected failures.

Yikes, sorry my mistake.

>
> Fix this by moving the new_addr check after the vrm_implies_new_addr()
> guard. This ensures that the new_addr is only checked when the user has
> specified one explicitly.
>
> Fixes: 3215eaceca87 ("mm/mremap: refactor initial parameter sanity checks")
> Signed-off-by: Carlos Llamas <cmllamas@google.com>

You need a Cc: Stable.

> ---
>  mm/mremap.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/mm/mremap.c b/mm/mremap.c
> index e618a706aff5..692acb0f9ea2 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1771,18 +1771,17 @@ static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
>  	 * for DOS-emu "duplicate shm area" thing. But
>  	 * a zero new-len is nonsensical.
>  	 */
> -	if (!vrm->new_len)
> -		return -EINVAL;

Please don't refactor code at the same time, especially as this is a hotfix.

This line is associated with the above comment.

> -
> -	/* Is the new length or address silly? */
> -	if (vrm->new_len > TASK_SIZE ||
> -	    vrm->new_addr > TASK_SIZE - vrm->new_len)
> +	if (!vrm->new_len || vrm->new_len > TASK_SIZE)
>  		return -EINVAL;

Yeah, it's cute but by removing the 'silly' comment you're making this
associated with the comment above and... yeah.

This should be:

	/*
	 * We allow a zero old-len as a special case
	 * for DOS-emu "duplicate shm area" thing. But
	 * a zero new-len is nonsensical.
	 */
	if (!vrm->new_len)
		return -EINVAL;

	/* Is the new length silly? */
	if (vrm->new_len > TASK_SIZE)
		return -EINVAL;

>
>  	/* Remainder of checks are for cases with specific new_addr. */
>  	if (!vrm_implies_new_addr(vrm))
>  		return 0;
>
> +	/* Is the new address silly? */
> +	if (vrm->new_addr > TASK_SIZE - vrm->new_len)
> +		return -EINVAL;
> +

Obviously this bit is fine :)

Sorry again, this was just a mistake on my part.

>  	/* The new address must be page-aligned. */
>  	if (offset_in_page(vrm->new_addr))
>  		return -EINVAL;
> --
> 2.51.0.268.g9569e192d0-goog
>

I'm curious why only you guys have seen it, a theory is bionic is sending random
stuff to this parameter when unspecified, and glibc is not.

But obviously this fix is correct, and the original code needs fixing.

Please respin a v2 as per above.

Cheers, Lorenzo

