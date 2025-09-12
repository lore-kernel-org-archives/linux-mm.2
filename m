Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA1DECAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22CA46B00B5; Fri, 12 Sep 2025 06:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DC85940008; Fri, 12 Sep 2025 06:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07DDC900002; Fri, 12 Sep 2025 06:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA7CF6B00B5
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:41:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9BDB05AD8B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:41:25 +0000 (UTC)
X-FDA: 83880256530.04.CD1CE8E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3D60910000C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:41:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MfIExpeD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zEyLQjVG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757673682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g6BUlMea7h1kZHTzN2axym9QlPsa6FiG4OUHpq3O+nQ=;
	b=rkZVzXKfDCpfPi/5Znbw37pUH6yizfWaz7nbSxJiY+TZoAyHrJjTZfLqwV5g8Stf8cURFC
	ByJesnq2uR8u3ijbAleJCVaBJ+DSly3rct/iDoSaaZGhQyeamo0Pjg8Vca25cV9H9OFGZW
	eIvHnOnM7EVNA9h0ENWjf59HXzXnIfM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757673682; a=rsa-sha256;
	cv=pass;
	b=JZqMHshqbYyHMg96Ktded2giDJUBZZXhJcgrAJGAGBBZ3/epJw1IMakgH1IGr28m6+adwZ
	l1absmiKBTw/JgeZhZ63UIK7w5tsdhcN0C21cZsSVM9XvXNP3IC1oD3mmzBF+703WjvN0w
	hnKnJF5dOI9eX8XLrgiuOZZcwxnaV4k=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MfIExpeD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zEyLQjVG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C1tsiJ027271;
	Fri, 12 Sep 2025 10:41:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=g6BUlMea7h1kZHTzN2
	axym9QlPsa6FiG4OUHpq3O+nQ=; b=MfIExpeDEYvr21m+WEwRMZQjRFwgyPFvao
	ArcmigiID3ZcLVRKSuPFAHcRsxp5oodelevM/v7ZqpO0K23cr9ok2Xrs5Lst69OL
	qPL4ZbpkhdK7Vs6S3SFfFybaW7GTwD0jl3MMHemZgzjt4YGThDxysg8US+wpbl41
	Ki9SWYmEUMh+Rcz04mg37ghcBmmgSPlQ0mZ6JkUe0k0WwW5LzaOHjUTcmP7akrc2
	kyT1QAqBhqMW9m4rnSwtjkesNTyBGqAjQAg/eAsE6aWYbglCN6SBZhyks3BswGHL
	FV1EOsIMO1nUkxSyd49xOL2gURUQQgQrfBE2jki3GF6DOZGRcWqg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922shyvs4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 10:41:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58C94eGG002760;
	Fri, 12 Sep 2025 10:41:16 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010026.outbound.protection.outlook.com [52.101.56.26])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdm86gf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 10:41:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NMVM8D9QkY+vZUysQbRIhMaNnUnXYke2pMIEe6yMWXq+9C3aCwuTzADjghh8RX/fTt+mzpRw7k3Z71ugw9s80ztByh7EjTpGWu5Vjz75F3pxKGnFfwYK/rn2RR4OLgEGJO4EiHZs+n54qBTY6auz3JkpdowgXqYmNRTa8Si0iKSshuGw/CaIRbK3wG6erlEzWwRANSuv/+B2U8/PmqYDhAGj2SdyRUrBYfS42FLa7pnVmQ7TeRUmrgM3tfWg76obfPGfdw5oxvKrOtWGrGxCUZP2xJe+bnZztKv79J5WqoLhqyi+luRnyy6UCnFQtHX1Ch9TZscVtONicVGBoUREdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g6BUlMea7h1kZHTzN2axym9QlPsa6FiG4OUHpq3O+nQ=;
 b=ohGdm3cq3gdRuZLrLHvfhXVEj14XSS5rmV6VXHgaasY0V9Ffqrvt/pSVnjDofhQ3So7V4k6bwENIIXYdQuDpi+PB55lfFLvRG2DFiFFsNJ5eh1m5dzpP4MiyxL1wNJhTyC+ok4qbhOQEWpJMZHVQFbmGlyrokMeMD/K8tFTXC7ydd3iKJL0mjyzf3eHCxXGfUhVggPjqb637cPe0/LyYzu4LorhkZ8LNSohwVSUaQcekwNQBgbTWZXks/VaXgP7+ZlU3Z1IQD0vt3p7YoJyoyb7ZeHAIU50A9OxrG1UJuCRKL5xGKMcMYyPcjZ2gtHMORJ3j7G02cMPPf+kkoRRG3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g6BUlMea7h1kZHTzN2axym9QlPsa6FiG4OUHpq3O+nQ=;
 b=zEyLQjVGGiG1ZHNglKrHOy9J62cPXncxSpRzGdsammFyVBMFp1PXDVTlTU7Do+kWG2YnZs1BvpL5QtEidatl4CaUFh5icROwI89IdjbatazyLWq3iJ+MzkklUwKXtgQQf0+fiF7Swoclu0BB4FY6W+jcha+xgrTQ1a830BPLhlM=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CY8PR10MB7196.namprd10.prod.outlook.com (2603:10b6:930:72::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 10:41:14 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 10:41:14 +0000
Date: Fri, 12 Sep 2025 19:41:04 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] slab: move validate_slab_ptr() from
 alloc_consistency_checks() to its caller
Message-ID: <aMP4wBdNzsTdDwva@hyeyoo>
References: <20250911-slub-slab-validation-v1-0-8b67eb3b3dc5@suse.cz>
 <20250911-slub-slab-validation-v1-4-8b67eb3b3dc5@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911-slub-slab-validation-v1-4-8b67eb3b3dc5@suse.cz>
X-ClientProxiedBy: SEWP216CA0088.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bf::10) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CY8PR10MB7196:EE_
X-MS-Office365-Filtering-Correlation-Id: 18d8e076-42e4-425e-f0c8-08ddf1e8e5a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1NktWf1hA00VWKs4/YVVXvZhsegya1rv37+A8qwF7kCjPnoIKzJUQtuBbkSO?=
 =?us-ascii?Q?UDsyD3Wx8xvbC9SrPrQi9M7HFejkuu+sI2hQiM/UvBbqsivnLTrb0oa1jtdC?=
 =?us-ascii?Q?N2r5L7NP378Upm5kkDC0iUZ+B3hBQTAY7DnoButwz3Dn4q0pDbjJ2xm8PR/4?=
 =?us-ascii?Q?PXQGzha+AjpiYMc0vb7v2enmY9dIAK7UVb+nSJAvCVl3CHftp2DNPodPJ51V?=
 =?us-ascii?Q?h2bTFlUuww3Kfy/fMlbDiv9DbKJZ81zKqjMCGLuc55jmAMe7aewp+WdsBG2D?=
 =?us-ascii?Q?Jghvxe+AzP1vRl445SrNzsLg0S/U9buAL0huwW7jR4VS/9szshiaSEfo5XLM?=
 =?us-ascii?Q?UcP/dTNOhRt7HwadKTl/0OWEIS3TFMvwLJjbOBxd5zYORUMLNs6buZsgzrgE?=
 =?us-ascii?Q?2wQQ0KylA9Y0ICZxkNLrpcfM+aAzcpTO/YCSnWMTFvD9EtSJOAla+l/oMO/3?=
 =?us-ascii?Q?0H7YjDXAnE3wZSqA07/A5k10+VMLI29p1GgvcuKPgsk9QtFRxv/szeC3vXBG?=
 =?us-ascii?Q?TPG5TFXMn8HxQ+6IhjAB7q6VwWUeoUYpUNSgeL3ig0/+pCgkpsY8GuSA8qn5?=
 =?us-ascii?Q?XtGUxBA9vpsMWx9n2MYy55m+NKp/iqLME6A/x69u3w45k6wSQMZ7E5jjM0rK?=
 =?us-ascii?Q?OCVidePOMn9LOykmF7da2i9o3Yu5nq55SAcisqQebS8J8C+EpORoO527Wurx?=
 =?us-ascii?Q?xNAlLatT6eDm7hQ2CDKdOVv5BvcYJ18gMsSZd4hLC3NHjKadmYXD2ifBiFav?=
 =?us-ascii?Q?+ty7/7ITJdZVd/Ui/6AzU2yOwUHXjJ8cCwsnJ7Bu7+KK0T1CpKfPBFYKFPcX?=
 =?us-ascii?Q?jF19aY5hdyy7zVGUpNMG3uFEEi2WZJKCYzanqP4eWLnZlYkHc6lFtuOcDkbU?=
 =?us-ascii?Q?/eWYXE2/OgGjBcaTm+nlDTiHDdoVRJiaa6x/o1/uxoYXb7ObwKPmbch5RsGQ?=
 =?us-ascii?Q?j7h7adhv4Jf28+sqJ2QNn1dgVH/1j8RYyO/gAfwYUM6OCnWCz9pZUwW8GauO?=
 =?us-ascii?Q?JXYmyDJ7YCZGzdZdWxUtGOQ+a1ykyi6Hr17hgzBCGufZEI3nXWktneGqVP1J?=
 =?us-ascii?Q?omrAN5U0NrR8q7poy6Q58+WRlAk9rr3nPrMgKBIesX2b1JTDa56wM52LTI+i?=
 =?us-ascii?Q?0POyLq2tXgnVL7oqNwdHxRt+FWmPvTtWnjRczbjopWMzDw6TZioj4/DcFgl2?=
 =?us-ascii?Q?hj3owf9Kq01F/VZqn25wmkrcZkEioMJ8bYwfuqzxwgUODOkangsYKIOv4kb7?=
 =?us-ascii?Q?2OogqgXkp/Pn0Uvs06lqH0gN5ZVW1YgfgBKm7pfXCoEgPkGXMGkO72ms+KKR?=
 =?us-ascii?Q?VmGi7q8cGo3z51aWNoccEATMSfvvl9qjn1WnrWFvUlVnI5Wc31Upo3Ws6Nk4?=
 =?us-ascii?Q?Ak2rNosq8FOhpmIlXXk+ZFvHaJBhD7lzaQ5wW7r8CLlWIViESUWqxq8wlAm/?=
 =?us-ascii?Q?VaSVUgmJB78=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bFrSHZDPx1AX3bE5bfteQ6hXgAYnNxIbkHnW/NtBjIHF67soPebEcy++j8oP?=
 =?us-ascii?Q?uwwkD0KXhWS3MYz7pHbylegMdbc+9z9zD8HFjt4Y9rRl3bHMmeGuGTwpYNaU?=
 =?us-ascii?Q?deKoM91q7ZoYUE4L8EkgWRUfXaCnVJRNPVjwc4ciYJ0qecelxs1/IueMY03s?=
 =?us-ascii?Q?QemAVbCc/u3oYit+VGdYxil5Jv/g0aOe7SdKRl0ZzQ3hRgSFDp2db8VfNfXC?=
 =?us-ascii?Q?23hDo2qT4sOa34CIEhCfGlY6V634+718bJAWdtxMIoXKyUgpGQn8/+TTykXt?=
 =?us-ascii?Q?qHsa40cTjs3Zl4r9ER3byBZlb38zCZnxK253Az6JbrBEbSPzP/jgCYQyH3pM?=
 =?us-ascii?Q?BlGzhZkXN6mKRl6Dj/Gj9/shY2FO3qKEcWSLkolW+HIpCZ+Dl9H4FJu3p988?=
 =?us-ascii?Q?aLF5RmE9jseMeufTXjeguy+HlEqCathLSdYYp662dBOiXeIRVTLpWlRJnztj?=
 =?us-ascii?Q?TBttvBD0/I4sMwd/Aerki8OzsnxFjvLAw/0COBSmL1nhEGH062bHHfvG3mk2?=
 =?us-ascii?Q?LMRHljezWcrw42+g73mJMz03EQDcMHlrxgdfji7RUzC6/6ofUjQrGG5KAUaL?=
 =?us-ascii?Q?POS50cNhC5+etfiipAqmiHl8crg4YhSbBdYvTSNeCeOi1wfrWaQrW+YmdW+V?=
 =?us-ascii?Q?qmkQAtWgZEY4XZf+2ztsjFxnBtp0Q9ra40PPMeGBSVL61J4IBYGvpx1KmkNS?=
 =?us-ascii?Q?dsny3mdlINxoslLgkU7ZyjIYfBPqj+4FQAq4RDoEZT5vSGLeRlDJHCbGmVL0?=
 =?us-ascii?Q?ujPKWrCNndTf5Af9SlONsqy3n/MnPh/VJksdAcDSaELVOl9xE80HN7atujTZ?=
 =?us-ascii?Q?og1AQTw4nJCk14Sr+6GJigrPES1wGONCSTqDcvJXoSBkwvlGk9mClvNfTDpn?=
 =?us-ascii?Q?gyxPnXp+Jk7LL9bvOjaE1unJ5WI9ft/YW31Hwnsv9SIN1DUyl+GmOij/XFXl?=
 =?us-ascii?Q?0mevl1qUroZsTi0T0XktjS63mRlHysoIi2PZRAT2Fvoz7BBj6jZWg3PtaxLC?=
 =?us-ascii?Q?4Oryxnk6zr/1DNUsJes559VKjI/uXo7dXsWfPNod+Vm9v0QyCQtHcOngVR19?=
 =?us-ascii?Q?3CIvfaFmrsn2thU1YhmjY71BY1yIyRo8T+zrWqJVuy3zFxoyqsAsOKk7yHr4?=
 =?us-ascii?Q?ewH3Alw6VX2rDRT7ZJDDZOHgW2eD7zAnfpaOk4vHPiE5AwhiyI0JyVybvRI6?=
 =?us-ascii?Q?Ab0DY+SNR03+drT0iTH87TZz3XS/6JnWIJ0Y8PMtisUY6mbytAsVNB415MvO?=
 =?us-ascii?Q?zfOwKnRsaLPG/Kdz3JFTG6vzJog0iQ/uK+ErYJSTTIDuT7XCQI+0sKqEoatg?=
 =?us-ascii?Q?hGjLBT8J1rae2N0J89H7EyXXHdsg8UOmsxh9LMc4tKP2zcc9SukstK1T+BAk?=
 =?us-ascii?Q?LoFw88prhqCshYJbgMr864z4QgUo738SIA7qsY3Kp3BTuyfdSsiUwTWQPAkX?=
 =?us-ascii?Q?VvVR18W3BqqgjLbecXm/HVp2PgoRtHllLh1K8wBlOKxLIlLK+xHAGCInZvmE?=
 =?us-ascii?Q?uXVQGNLACu7eL2CE1QpJcKCT/cmQIjo+O1dEuAdcatLqoYffaiEcw/ppwiPs?=
 =?us-ascii?Q?CrEHv6/9COmalQWnsF38+O25ke5J/gwhNWpNhaWF?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mpo22QrNhjOMPZGidJanpiH4KN3SSKjHr9Q5CBhwESxbY3Uv6RAZOXcK4aFzzeqMrLjeMq6Wtnl3RuciWMmZ+JOVu8uYLc9Yto6rHtr6fKH/pylgwLc9+78nfgcP69MccKZlKxb+JKa19vK+ZFGpEHXweLb10swwE6rah2dXa43sHMmoWSLYNMZIrsxtJzmE2MO0WVFCiJhtWkhfol18NylHsK5ft506+IZbU2VgmL7vgS4LqN5eaBPu+ZQ2YvotYMePfna6BZgCQizSPeKbNs1YB5OzY00Kywr4vhMcN6aVf5P5tnsHGuiH9DkMuu13R8j2qvFmwfPHJ8mk4g/UC8zQLVl6FcEgyHiUq4b9IwGM9TSxwbGmTldDOHYdd+rhTtoI/uDq9G3mlWWf4IoA2eTYOnsgTDZYeHJ380osIWw+9dWpl1UwN9CENEtpLRfoUGVCjr37Ag2XjU7lfRGfTJY32g5mBqoXfIuMvj7PiSJ6pSroMfxjNGi2c4tAFg3pqMy3dzRX+TXFQJdlyhooY+O2U5GGA3V/2N1zd4y2BWmBf6EgX1aXgNiAKBCSaLiFIi9varxNJbtWI4dxWy8QbVyqxe47LHHJF93gtDCpZfY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18d8e076-42e4-425e-f0c8-08ddf1e8e5a4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 10:41:14.5832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s0p329ptuAG2aOZtY3pbFJW9cLXmFWJpt3BtTErnHMhG451RXo0cuRJQY/8KUTbY/YC7/YzBHikeZlYQsQZEhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7196
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509120101
X-Authority-Analysis: v=2.4 cv=esTfzppX c=1 sm=1 tr=0 ts=68c3f8cd b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=FuyENsUI96d6ynYqOAYA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12084
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NSBTYWx0ZWRfX0fQeV9m0m+Tc
 9OXf1EVYtooIHf9IgIHAQsoSkWvYAF3lZcU9GcynDkxDpPoukPd3rHIS9loWAfV1Mk5A5YsovLP
 kQNXboqAzDDD/NVV1hefp+E1XCUv4cDaW0exaulUJU2zcpeFKDNqx+AOqyn5rdBiTDeetDu2HWQ
 K7dTaOIy4EZHVn+Qqlk3OUqZMQXkgh6T99+Uax5teSYyJymutmuwjjXYuFGsz8tfa7RX3sEl9Xb
 hktQSr59/saDzX/mhl+TleRPtiDLoCc4BXSuE2ARTpP1RkOqtmgra1djRgCkh4BoV7KwaagaKpP
 qoTp/FTjs82eeMI1HjnCdmhVGHIPiDyAIFzKkTxXZhTYtysSPcISp+hkLwnqJhBFjI0BwvgMeDH
 +nNsH+n+yUPuL3kMDMRs4Sdsl3tSZg==
X-Proofpoint-GUID: 5LVBl0I2bLJVX14JSfXfWqDTKM95NzRb
X-Proofpoint-ORIG-GUID: 5LVBl0I2bLJVX14JSfXfWqDTKM95NzRb
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3D60910000C
X-Stat-Signature: gzxwhk61wrpnf5x55o5ektkehokaf7cg
X-Rspam-User: 
X-HE-Tag: 1757673682-678143
X-HE-Meta: U2FsdGVkX18QvMlpD5mdYeS3FpxpI6Vad+hLgyRKRlG8wSVaTQyVMbwEdw7aKBhJIcfdwcrU65D/TPYMkxhacu1SnZD/CEtE+gRB76qNBrNw2XR68Rl8z6dZ8Z4cPIfw/kAJQOf/LJ5WEyTmg3gSgNVinUwPIcEkJQpdmItCrp/zeZNH3RlkJ1uVdvl0P/uyKY8mFXPui9TzBZasnnt6FOUoxOkyPC231JCdxpPePGaWdD5wdcH5U/IVmvRs+cjKCoJ3gruyPrswbiYF0BpE09Jy2tMbuM9eYTNsMzDrBhb3vKaJJYIFb1LtbrGfxiPflAnjjRATWzX5VOACDmN1MThfZJwdLTy1isW40nqDvlNLybcJObponcAr9QG/g3k4oFYWrIXh1T1wvv9SjVgsLbvs+GsbMkjYmxqNCCXwvb3JF12J1EeQmxE3zARUPg9fkrL3fko4tiOTzOZPf0I3yWn4n4zlZRzDKhn/61E3YfZq3rHC3TZMoTh33j1QBicJH9BV2lbNW7ar+3OzKl0U4belKdzU0Au2OAiVZuBSLGusH8tKDjZXSk4lann8/9jFX8frSHqSBaGygZnPlWP5NF3jnCE73hRkbL+R9oc/fETcTrXBLs1wCYXbeFE9KZbvTpjbLnllat/H9yMDh+2qOhzJAg0ErOE+LHklOCeU2dQbQVSgJgVz4jhS6jwocvTpFhNcwTBn1FReNBMuxSyB1pXRGj719yb2nrdiftkwgEa7WwaKTx32fBFHeTROShqRT29/XvMHxNCIDf6ZChf1nKkEYBAibZZfc6p6sAa08NtKs6Z+eho3xSUwk/FiJHF61/8/AX8Ag+Q8wMUOuHk7MfXWa7aTUt3SoLd4cQQBzX3MsVWIOL3tSSbFNy0bj4bsecHsYFA/ouwp+xS0PsdDpJ9AL9NpYDHiYI38gh1ahQq3HcTliLIHHxupgbvIjmYtFCQsL+kk5p3GcAcPd3i
 V08QFcz/
 isHK3m4yMTKEERflXoyO2FUVG3/s8IaBObX5LjPMaftTgMCVNekAO/aH/LuN4tQUgzxReN1eD7LvTqVmMTO04JC0qDbfipW0fUMtQIsiTNk2PNWshM++BXtG3Tm62zQPFoav1qUgYpUE/IwjKbul5+nn5Yky1GIxQEcv3bsWjS39+VsGv4+FSqw0wr74KU1cu0oYdeu8YVRsaStIi2owbPQos8MZCPpTVcj7ZnZw9Xl4wOg7Tbuub/p4xFO0IT+YjfSU3qTfcU9JFrNL/sftCEKqYCUn2ZSMRo1/V2XaP4hB44WO3JVv4AEcp5kjzu6yTiGwCVqgOnVWvbA3uIT9c2LGWTIUovsjheT1XyXTDMjwFkICx/T/JVx/h/rVobA10/hp7RRPAKu9YOFCNjNQPne/owlXoYWv+o9ZIZJEve40BxPRxhQ4qBbqRhrJ/hnW41KkcElFCEuBvpuDdBUjwNtM38lUWOGz673wBgd4dNBbNPTRWtE7hO8m12Kx06Nsbe9Q6PIax2wthxgzT32MhhXRKcBWvobRenqrbh3pRwiel0vxJwLJxX3Cegl2mhFBq/wR7ubHGu4urGrwwxbEdbhx4CIgqitsUHuq8/Yp6yWJSq+jf+xB89es6CXg1cKLxWWR0C/KkqsNpO+5bp4x00LdWbXA4KOd3Hy1bMqK9EesxyE8Qb4jIKpFajPf/TRvNU2Ka5E3hhKCPpMl7/COk4ZAtFaa2rMycSdWyP/d/tp3VKtdEHJgolL7QhC892u179eHFUmX/HKH22jrULrhQXDVU+Qjf8+WwGGxiZVaGExLxXW4zSc4mBVtRB3sfXAgXO34w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 07:02:37PM +0200, Vlastimil Babka wrote:
> In alloc_debug_processing() we can call validate_slab_ptr() upfront and
> then don't need to recheck when alloc_consistency_checks() fails for
> other reasons.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

>  mm/slub.c | 30 ++++++++++++++----------------
>  1 file changed, 14 insertions(+), 16 deletions(-)

-- 
Cheers,
Harry / Hyeonggon

