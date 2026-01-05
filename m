Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBFDCC79FAF
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 18:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44FE06B0092; Mon,  5 Jan 2026 13:16:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3306B0098; Mon,  5 Jan 2026 13:16:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5796B0099; Mon,  5 Jan 2026 13:16:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 106906B0092
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 13:16:11 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A26661A8438
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 18:16:10 +0000 (UTC)
X-FDA: 84298714500.16.550AA78
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8C722100006
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 18:16:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Pt+gfazq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ejtsmFAA;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767636966; a=rsa-sha256;
	cv=pass;
	b=Asgfu+kmW5/fkN4BmbhIQWEDJlnye8cqdHncqCWdHqQORYUBPPD7saj5p/LDZilZb5Kfze
	jbEBCcXmKrCfsLrrH+lP4/ZjdiNmGMkOZQ56cwvfzH5IS+XCx7GYY6pA9/hW0Pk5imJRm2
	Y+tmW658pC18qLec2s203JXNhbVxaEc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Pt+gfazq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ejtsmFAA;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767636966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Px8KfeJIcNYxsVtJ/xpAQQcGar5L1xIHhuIAMHWmZsk=;
	b=gHLcXnZLzGFM/ZNdztPzt/h4MrEJ/6t3HLfrqaOnJLDU+jwONeVbqUwCrMNf5eit+Hg6yJ
	WaNAmCFMzWUVBy3RO84VoeC31uhA5zTLsFxqRbdRPF9Out0L9JxPpiJjDN9E48ZxWDtsAH
	pQvzv1293CGo33HJkUUeGeSq/oWfEuE=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 605HZYEE1921772;
	Mon, 5 Jan 2026 18:16:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Px8KfeJIcNYxsVtJ/x
	pAQQcGar5L1xIHhuIAMHWmZsk=; b=Pt+gfazqkZ6Z9bQT6TbSZo22m3S0i8Od/6
	3UTr1/OglFJXoawH4e1o9UIbT0o/aKVLqWPw6/vZ0e4P9ky4s+MkfpV74y7/k6VL
	p2PBgDefjVbBHhMbNppQBqeO7xh6DCjvWiEppxKlUtjMI1Ld5ZuakjKIcrhdAefw
	GpCP0MSHB9TE+ByQdNSBf9alHN9xn+fAHjY8YiXEHjlDQLv4bso3TtsXDBu/uX8z
	t5+hJAzdoEAYClzXZlhQEZ/Arn9nPQ7E0pc/ZKWH8WqxwOMenQbskHqnbxx4sceO
	69jsIM69hjjvRH7YuP/U4S8AKkx1FwVM2vjwmhWm7Ciy5R9wcqGg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bghu782gp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 18:16:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605GvNWT030764;
	Mon, 5 Jan 2026 18:16:00 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013016.outbound.protection.outlook.com [40.93.201.16])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjbp66u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 18:16:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jnzsb4ZCRla1P2Sx4CCCbPVQDlkuowvEl3EJwOvWK7H64x9kZb7MyzhPRYMD1U9UDOx7uDWKZF+t12hmY5VnS0p6DIDsDUGd4dhQMisWOmDSO1W7SXPjkcU/mdCfQfDpsjQxqNxDw69bQf37bDS1etXq4vd2xpAYuxmU6HEHtVcIqdM2ANVHeIuETjMr8cVC4aiRHrKH3BbXqKKNNxGxS8CHSMjoRCZttDp2VT12Jt+LS9cIoURW0utyZM2PafY/wNAJARTrcAxmTEcwT7Y0o3Cu+nI42RB0+eW1BXmUeYGQyOV8ZLETj+OWMVWSGH3vBb8bC2h+j2dQaDOrxVGMGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Px8KfeJIcNYxsVtJ/xpAQQcGar5L1xIHhuIAMHWmZsk=;
 b=SkuF1x1kXYgTN4m0Y2n9+dZ1o3CxkcKCrdxGwmaht6w2VLfUy3Jdike4IkIJCp8I/TUwDMjCVBLJtebmKDjsePcsaOlHS3/fMOlNHXSu/a6jrda9pgpPe+zS/N1d36atfdvqv25hpKHnDvrsCDotZJca8HWyHeTDCFmmdBw07LA2MyLFsDE749Bxp/JXRUe4QMqdKC9vfqz6pktvXGvHQuj1/Q27NZhrDiMkaZQmEIt7QuIcH9bY+miu43ekeCbyQnwado8l+MOokf2JZpmGWz5DZHiJnUic3wbElDj9Ms1jQQt6Rx3Mh4KGbYmrvelue00vopMEOrmt1GDhQ4vPbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Px8KfeJIcNYxsVtJ/xpAQQcGar5L1xIHhuIAMHWmZsk=;
 b=ejtsmFAA9uC0djpSs5Ww2Uga0NLu5957OD/0JpWWioEGvlLVFXR57CWfRa+R5fm/gPeeJ/taAfoGep52cxZHKIu8lgkoJStM5DpN05mxAQOzSTyFhGddgSDl857Od2Zu/Cw/GOqPhwBPniUVFg215qs7fKa/PNuaNa032BPMk+k=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CHAPR10MB997747.namprd10.prod.outlook.com (2603:10b6:610:2f6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 18:15:57 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 18:15:57 +0000
Date: Mon, 5 Jan 2026 13:15:54 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
        linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v3 2/3] mm: only interrupt taking all mm locks on fatal
 signal
Message-ID: <7whbqlfrwjr4z2d4bpny3rjyl5tetdyx7ccf52uvby7hgywoym@6l6m2xcytez7>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mikulas Patocka <mpatocka@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Alex Deucher <alexander.deucher@amd.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	amd-gfx@lists.freedesktop.org, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
References: <b672e17b-461d-16ae-e7d3-45d3c1aab142@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b672e17b-461d-16ae-e7d3-45d3c1aab142@redhat.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4P288CA0011.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::22) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CHAPR10MB997747:EE_
X-MS-Office365-Filtering-Correlation-Id: b489dee3-1c5a-4241-f84b-08de4c867938
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Lp/NaAiJqYFhTo6EbK1Ogp70Ts1+/Sd7Oz8AiDJ91HLDaXuReSw0ETxa/2iG?=
 =?us-ascii?Q?wbqBVaGVNGaC5okwiNF851i6FEBkX5CNd5pz3SQ+UL1PtBZFeFq+yuC/vHjG?=
 =?us-ascii?Q?gFgp1GaMQ7ge+XjSvfryBGV+lLUvdBhf9qfQey4DbATCV9c1x6vK9Pk+KvIC?=
 =?us-ascii?Q?uZuk+BV0DJev6XsBA8U9ZQDbLF55TbG4i7VJJbPN4yROBhGx4wSGiDg59sBN?=
 =?us-ascii?Q?1lxE9BcfsAbRJbiHO9an+zvA6D8+LsJJmKU5T7nvPZ5NwpqfbNMV0eR5ohL1?=
 =?us-ascii?Q?U/pmd+n+MijiBcWMhsoBy1eDu05ZQ6pTRJT/o9zZES52c1dhBeIQPS94/h2J?=
 =?us-ascii?Q?T7HhMhSOERlUs1WBFhr+v82JhccE4KCjzJxWgTWxLDYYo/VVby17E+LACmD0?=
 =?us-ascii?Q?ImhgdymBzwSxCSReF+AwZCJmhHpUCKwbPLgiOUkc7+enX9pLYsn7scNCDat9?=
 =?us-ascii?Q?pyFLdy+ffeNq9J3wNY4DY/CdtDPBqwty+KZOP2awFQuhND5OA81/TrAX3LGB?=
 =?us-ascii?Q?FrwCG88sT80kikqc/QIe+1JMxlfbjHURjj2P69P+6QEtqWCNRVaH0kHBhqX7?=
 =?us-ascii?Q?Ptp87WruuWW7iy1AJPW+QZFJDHzhbnkebQqMZDHjpJmHZs5c5RgfgLCW/ISl?=
 =?us-ascii?Q?8tHOAUTCNuqnp8lEDa8m49YSIwinD0mAo0UzI2nNTbIUhvIkoIAm2GI6SaV5?=
 =?us-ascii?Q?iLdfMXd0Vo5hIf/2ruo13wNoKwN9QNtDClVfZsRHwALWzNtbIpOPZqcoSj/+?=
 =?us-ascii?Q?FKXNtpiaRR0H+WZjEiFwtjTaVI0P8x5YR64ZnNuESNOzj33oYRGSmw+xyMvx?=
 =?us-ascii?Q?tZFA3vV/Tta+978FtA3fj9jA3wBEHHcVv5aETc64qm7uJxW3HMobaR2LCta4?=
 =?us-ascii?Q?fhCohkhlsSOpURCzyhgJQKLlbN4GwYiGhss+9VE3cxd5yXDvITMgMTbWrREM?=
 =?us-ascii?Q?NyiP0dvUdN6ZcEkCKxYdBcrlrrav81wAMIj4X53EopUg/3Rk6NYK1MwDaPWN?=
 =?us-ascii?Q?rY1WxdLO2HVdGHN1xpLKpJ0HNuhSmgzS7TAnBJMeSGUCaVvD+Ez3STu9GB9t?=
 =?us-ascii?Q?ZLpLqTiCyR35g3IDTdiIpKUCN26O4Grbk1+/6iwzB7PIOjxIc/dyluj3B8z5?=
 =?us-ascii?Q?8GDgZmQuwB791RCJJVnauhhHQ7sImD/K9gscFatREHkGtEDetJ6tZWD4uvJk?=
 =?us-ascii?Q?xvH9/nHtiKbLSY+9cHWQaX8wOHPvre8pogmCbucZ98NChJS0U7E7tbLPt2wY?=
 =?us-ascii?Q?XW9WtfQiyzsUxtwBDDK28jKRavYrirKgZwXp5F11JI8aX73pDVY2JIW+cCF5?=
 =?us-ascii?Q?r7VLPB6ZjM/wSyiuw/7GQQ3FOQAEAYY0moKnOJYs72nGrpTFdeRvzJ8MztCq?=
 =?us-ascii?Q?hx1lNPZJ2Otdmjuc0LY0e2HkkiuIbAzKMcD7EY/H9T/Wy00hdTk065JfoQ1j?=
 =?us-ascii?Q?zwlyZXK7vauiFHTvu9laiIxMuzU4ssGX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kgo/sRWvtrnXviylOaiG52mKgO7tAo1RUF6qPqrz6VmhZfHww7w3OTN+Iw6t?=
 =?us-ascii?Q?nV5p+X+dl3sZXMLrgKPH8Grwe4lYkH+dIHw3I+QLcmjKWb2XZMHIUz/BKj06?=
 =?us-ascii?Q?Ns5lgX4wPXANaED3IzTNr6bjiuiKkVQ3FaOVNm8GIhTCPuQ5rKXp7YPgxbjB?=
 =?us-ascii?Q?2ZBu/9kXmumT7PazsEDLiCHQNqahEcWvE1BQ1cQpesVnGcs2LUUYsEKO0sqU?=
 =?us-ascii?Q?MtD5ESPFOq0ox1mVcsww75hPr0KCgD+HEdYL2h9gnKWoyWJgWluCkNGQB2Wz?=
 =?us-ascii?Q?e1hJVRxaVhevGCHlhEryVKbrPAeNaYRu0yCh92b5DKnaFN6e2Sv4qfWRjdRN?=
 =?us-ascii?Q?f+Cz++F/pdIk3sVIYT7t/g+o4mGri+XjZyzDerW1lpbVSuFN+/hUMVM8+9Qo?=
 =?us-ascii?Q?sLeBkhkshCd5nGE/HVrW99lAw95bUltIWqnCAj7JnuVZ4IbkXkiQzY+E0uEP?=
 =?us-ascii?Q?THogSw5MXnUGyRzupQiBWg41wiRBqtYCZHt1e4GvDtO59F1lZ/8Pwzj07JXP?=
 =?us-ascii?Q?JYaQ9c6AbROaFQWY6M693HLLyy/eFxstPCGsPkjeek5E9Gkt9C5Ww4IUWpef?=
 =?us-ascii?Q?Ifn+7kSrUe9NrKHUBejzxuVVJrNjIBu5wWHMjja6SWo/iCPR93v6Lih53b/i?=
 =?us-ascii?Q?qmkoYELVJkNAIPpTP7n4cdvSueQMidcyFxmb1Ul07Yv+H56RcoCTIfeJvZEN?=
 =?us-ascii?Q?E9uoGP3d3AoP2/Rjj/0J94QjHYtlMJ2WQ+e9yHeRmU/Poc8C8J56aOU9PdRy?=
 =?us-ascii?Q?821qj8G1OugBR7P4x8Y0BKBP1oG7a0bdkS5IvFOtvUO4Jf4L9yRv67a7u6UI?=
 =?us-ascii?Q?dU2dl6/aK3UEIqBnBUDu5pPv7Y+MyUbE/59HmxOC87J7QtrNnpiFy+FI3boA?=
 =?us-ascii?Q?1KbP6ZZLb8Bn5WNQgfWYhD0Oz4miJ3rpSqbM62NtonbA+oObziqtbXy8Dpmr?=
 =?us-ascii?Q?JtHEXkbVqsAlY/n8XPXy8sp2QBxEJZ6xuib8JklxIFvGoHJemxdyDDpFU7a7?=
 =?us-ascii?Q?/HC/3827WtwxS+rguf05f9vnSYmh2mcSr3jQOVFEIkviQveNNu4B9Olzp6Ry?=
 =?us-ascii?Q?YTr5ZmOvTxE3AwP15BFQ0RO4Xn7J4ebJV1t99SPuDfesS+2xjpx2fl2R0yaa?=
 =?us-ascii?Q?aCG/AJSl7snFDspm/wzegtjswmj9F459yLsOoUVaoT9LsEiWOnEIjCE48Oh5?=
 =?us-ascii?Q?SgqLWk5YYVOWnKGfHttoNZgtJ/r5U3XzZl4GIJc93fVBXpuO2My3bDG2hnJN?=
 =?us-ascii?Q?uOB9fkyHKIopPgJelRGMSrR13vJ2IUf2gPCgYfFgU6rmVLOFn8nygXePAZzS?=
 =?us-ascii?Q?1uwqbUSEoq0k/HJlLcTpbj4NavUMlWhO2FlzapC84ALTN7WDhdExpD9YEn1V?=
 =?us-ascii?Q?QnTnIy6crUfjNvAFlGJ9Dik4/ystOHwi3znj2gEBueHaG+C/tUXTM87imgio?=
 =?us-ascii?Q?WGmyIzABdBa+cAWtIv0eprxFgCvq8++sJNQkjbRlUPlomWuJDs7+SyEc7HpO?=
 =?us-ascii?Q?/jBOSlSPth1m9tH/BY788vbGsA7OL7gRFdA9qMRtpCfWDw7kdcL+DDH4YLVw?=
 =?us-ascii?Q?1fI2x9uE16Jo3KDwa5OcBzjw21lIxobE2d+VWIZNiYsr34zAg67lXLp5j8KF?=
 =?us-ascii?Q?+GuhPTZW+ue4o1edxU8dZTvFSskhSrvBGAjaj41A7yfdPVTcBvxUK/qBPf/j?=
 =?us-ascii?Q?iHMLlETSkX4ALzwoj7yZ+uRhn9tU8kbsXXA/fT4At+oqSM7MzFmlfIb7AAAZ?=
 =?us-ascii?Q?sVdoR9NBzg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2sWfJy8Yc9Mn3OhmPLoZT0Q8p/qsJKWrG6VvgSTQxo8C941e4+tXeoSyNym5D84iUBVm8gb1LYYKX8pg8KXTRYRUsSQla/GDj9Fh9tyxJb+22BMrikiBuAI9/vfh6M965bWqGbsqEoocQz4W4B+mCq+/TcW+BTn4NPulEZGy1LVBs51tPQ+Y0ZbtHAtmwJyF8kSH7mFTFSELurrAUTrkCKEZ6Kg10Yce9idbHO3oHZY+T5OGQQ0MYmZK9snL/imV3SjQquIrioYGLTIQ0/mh9jeCI1qh14/JLkp2PYNs3zOzZfwOAWBWcJc5dTb8MaVO0h0omqGOBJuxyHRGf0qRCJew1eCi57804Mg674a5pXyJ3vnpaXffRgiZsB6QbY4QPRHxY1yOS8TytgmD74hKhHZdIjNmLpQWa0LGwVvQ4D8ipVZiP0Y1KQhgLkOGXDOczFfJTBtoOi+ylqt1TUwkN6rVQw+3W1msPnzhJ3r7idg4swc8Hfwx2ENNHA03YV/pYjTONf3BxghPOVjSOiRaSvGD4RNLeXNpQldECA8CvGYpQ6ukKUZues9DQeRkG8PTMxYY034QYGmG5osis/qhDxnRZ11oDPFcBa7SkQg9k/8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b489dee3-1c5a-4241-f84b-08de4c867938
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 18:15:57.7290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wGWJbGOatS/b86d+lfinTDGgKks8H0qoX4M/aZjSWuelg7TArqqGl+ifLwprTuuB155RHKw0N2D2Y6Gz0CYVIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHAPR10MB997747
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=770
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601050158
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE1OSBTYWx0ZWRfX2R3QBtnJRnQZ
 96HtQ/c0qplSn/hfdk1CHrnDIAvJdQoMh5AxzkfiYqO8lGqw8HLruSX5/DMnSmFq1sadB/4cjHu
 TY6S7cd1w0vIzdRJO/q13n7bDJxISlm2RRXCcyeqXPj6Z8RMLoINuo9ulEdWKa6U2EefKZd7n4A
 tL4rJoFw2DdcznvW4L7P4RFdtHiw8Yo+bCoGP5tr3StvUH34TYdhZJZiBhO0jQ41isECgB4io2f
 ipzrOLNSZ5s7fPU4ORPykBE2x+QZ1vA/FRLmM0yOjktTri+1Hmz85CiSIEZIJqYDmQiXG4IkwOT
 EFbiicdlnR9i/ZZEb0w2pLAYD6Np4YQSXu2CPdwjaLnKtpaOdP8yhMgCwd5xpvgaxR1PxOqc8Ve
 O8p174loYNOTWXB4g1FyY3KqDwj3Wg7Ky+QMN5gJ129tnMTReYbk5AMVBePiNfxNwTh7XYi+441
 stBiJFt/TUgKsyjbwjcAYOMpbdGqumFDUl20KQio=
X-Proofpoint-ORIG-GUID: nH312t-kp4FezMmrRlXhkDt_l08mKiZS
X-Proofpoint-GUID: nH312t-kp4FezMmrRlXhkDt_l08mKiZS
X-Authority-Analysis: v=2.4 cv=R4YO2NRX c=1 sm=1 tr=0 ts=695bffe1 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=XyaZgpgpaLO-y_kssBYA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13654
X-Rspamd-Queue-Id: 8C722100006
X-Stat-Signature: skcduwyusbzji8fijsbn34uyf3wbnoam
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767636966-646479
X-HE-Meta: U2FsdGVkX1842E/MaikcxdVFDvtIskyPjNoc/DbBrTKLRmYUy3Kd76pmzfFtBmvulzYS1Xn0AqhrIyjnfNlEleTcLgZimWuHbJB3+SDyCO8p7RSmvmIX85+8MVfwQtAm60Pp0/0CD0ygX+9CXknuQouO0WQu0MHLa4sH8vgukVjXAgboPnVF9bok/IQm0TF9l7cD2OAWl/6sXLsdTlrqqC8QJg/2xu5+AFzOqgrpoQl+zffK/aESbYidAut1/yb9A24pbqKAsOoNzZ3YtV1xmYNEQBxcf0RO2zwyIGA2JOL7ak5nNjwJg3NNI37XyD/KSEdz90m0iLjdP3OKTrHaSQIWe7LVhYoGcBzFQ5O3HLdrEy3wdw9xvIr0wt2IDbpN+9IujsP2ZescAzxKIwNO2zdEFxyJNzTRFRrOPIkaRtt4ti788K6Hu7gZtG9FC0HBetFwo+aDjIT8T2VxntZSOnfMrOI5A6HbKItH+Aatckcy6TOsHnQpHtN4trvRyK3dcZYBr+FneY2pnagoioZjJvcJ53z+DsILuj5ehoODWGVGXrJCn5WTTSU5nO5A+YNrHtTB8Qy5TbMZwbMFKyT2eCbfLxWjmVR5GWlH8quHT1wkOxQ46VHujJHJn4Ce8sfa7hg/CwI88VkSUcD8xCWDSZ1cx6/Hhdi9Gd4pKHgsXBuf4u1P/4wYW8llYO0xwcHBD5aIZHpL26rfc4uDlJ8grFDvLVLl8bkiSNvkaA77aZKMtFjdt21C8jw+ESkVEPNwNiKUsAbIwsQb+IYovy0PnkWC+OHAuE6U9WYF+rNnONQuSmFSlhpq25FAN4PVDZ2Z4uG6kFd8WUUzVsfARDULtoTV99hLm1aIMaOMBLl/qxRqKYesAn03sblqkfMlBXt3nEX93m7qbJvrkTqqy1BqhJwjkovObLRuMVL66OXfslts7C88vCOGbEmZ7u3fII/I6MlSvesXvUU9eebPNDO
 yWxuZlS/
 jpsK3tBFL8vvL6KO40JV9ytlrTMfYkSW+FaviECOeamzl2IuwZzI6Tx3OJ5Rcb4jHDxN/ip++zBrqf4bLdw7kgNkyEURCAm2st0bBqZeIP7Pvp9COpz93Cnw4okGbGRSZE5ytf8wd1HD2Do4eDe9Odc6bT6Kbx84LdAGZ3JEukC2sTtpARoklzKpxG3ne9QNQAd45PZrwU+8SoKQQy1MAA83s24AhmIbf89WHEDiaSrjCFJFEzkkuIDTLh9xZ2At8waSujFB8b66DJdroXv1aqGwveATpFTc3gMMObrjoDkQlX5tjkUFrJs6fziV4XqlJwgh3Q94hwgVaJeo9hx/XFUVnW8vFZtIzsTv0FXaiiZyP1PGDwJQh1nASNNN9xR9OoDkAsay8m2Rn/ZFi2MiM0g0EytJMVb8YTxvPkBcAhI/5lA22wgLjyNMOQ7vdmA8We2aSvqbBGkFbbEiHT+TpWAIidZG22F3vcvLNmcFTUGz35OcNhPEo+sULWSVp7Hdend5MobYYhsucrUMfjwsmMbQhe4I86ag4NBRjfDVf0zyuJKRQb7NsKk7WIGoc266of6vweskyhqBlypVr75GP+R+T/AYC9gs64QG+XULoDmaLPUl99eQn69eNIiIe+NPAk+l1R73KGOyeYFe8hdFMo5I9bQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Mikulas Patocka <mpatocka@redhat.com> [260104 16:17]:
> If a process sets up a timer that periodically sends a signal in short
> intervals and if it executes some kernel code that calls
> mm_take_all_locks, we get random -EINTR failures.
> 
> The function mm_take_all_locks fails with -EINTR if there is pending
> signal. The -EINTR is propagated up the call stack to userspace and
> userspace fails if it gets this error.
> 
> In order to fix these failures, this commit changes
> signal_pending(current) to fatal_signal_pending(current) in
> mm_take_all_locks, so that it is interrupted only if the signal is
> actually killing the process.

I may be missing context because I didn't get 1/3 of this patch set,
nor can I find it in my ML searching.  Nor did I get the cover letter,
or find it.  Is this series threaded?

What you are doing is changing a really horrible loop across all VMAs,
that happens 4 times, to a less interruptible method.

I'm not sure I'm okay with this.  Everyone else does seem fine with it,
because userspace basically never checks error codes for a retry (or
really anything, and sometimes not even for an error at all).

But this could potentially have larger consequences for those
applications that register signal handlers, couldn't it?  That is, they
expect to get a return based on some existing code but now it won't
return and the application is forced to wait for all locks to be taken
regardless of how long it takes - or to force kill the application?

We regularly get people requesting the default number of vmas be
increased.  This means that processes that approach max_map_count will
wait until 4 loops through the vmas before they can be interrupted, or
they have to kill the process.

> 
> For example, this bug happens when using OpenCL on AMDGPU. Sometimes,
> probing the OpenCL device fails (strace shows that open("/dev/kfd")
> failed with -EINTR). Sometimes we get the message "amdgpu:
> init_user_pages: Failed to register MMU notifier: -4" in the syslog.

If you only get the error message sometimes, does that mean there is
another signal check that isn't covered by this change - or another call
path?

> 
> The bug can be reproduced with the following program.
> 
> To run this program, you need AMD graphics card and the package
> "rocm-opencl" installed. You must not have the package "mesa-opencl-icd"
> installed, because it redirects the default OpenCL implementation to
> itself.

I'm not saying it's wrong to change the signal handling, but this is
very much working around a bug in userspace constantly hammering a task
with signals and then is surprised there is a response that the kernel
was interrupted.

This seems to imply that all signal handling should only happen on fatal
signals?

...
> 
> I'm submitting this patch for the stable kernels, because this bug may
> cause random failures in any code that calls mm_take_all_locks.

They aren't random failures, they are a response to a signal sent to the
process that may be taking a very long time to do something.

I really don't see how continuously sending signals at a short interval
interrupting system calls can be considered random failures, especially
when the return is -EINTR which literally means "Interrupted system
call".  How else would you interrupt a system call, if not a signal?

I feel like we are making the code less versatile to work around the
fact that userspace didn't realise that system calls could be
interrupted without a fatal signal.

And from that view, I consider this a functional change and not a bug
fix.

Thanks,
Liam

