Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52F8ACA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 01:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 998E96B0005; Wed,  3 Sep 2025 21:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 949ED8E000D; Wed,  3 Sep 2025 21:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8115E8E0001; Wed,  3 Sep 2025 21:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 710F66B0005
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 21:41:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1E7C2BC469
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 01:41:19 +0000 (UTC)
X-FDA: 83849865078.18.484D639
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id A8EE116000A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 01:41:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=f2iRVeVc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XXUOJ6co;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756950075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gw8GqAMZ/xo6KGvVgX9f0JXICs8Hyv0S3YB/GHRSt9s=;
	b=gY1G4K5NTXv83bAGrIWphkQTSEihpPUMaeyIQj+7UkdIFpN3s4wChfgKJwQPwoAnEiLkiU
	3r1gcOsbA5vVGhi4Pi0rCrMnGZX9DCR5i65EfzHVc7FmYDqn5c80KR4Hyyb+7jl8q+9eRo
	SvIvKBD5SgN/SV1Q2BuFq07JC6R1XqE=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=f2iRVeVc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XXUOJ6co;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756950075; a=rsa-sha256;
	cv=pass;
	b=3bd2XP+VWa1GjO1M/UlT08WO8oMPvqsdmWamUmgCVvePZK0orIGkbwuI5smMbb93CQ7XsJ
	eYiJ+5nSnVb8d3SRJDIuhzZLpzEQut8wCd6D+b1cv2MOorBwWWCWg7AoLql8kruBQzUyyT
	I8DMhSaouEs+YHqdbeYcr5r3CUBmVfM=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5840uS2p018205;
	Thu, 4 Sep 2025 01:41:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=gw8GqAMZ/xo6KGvVgX
	9f0JXICs8Hyv0S3YB/GHRSt9s=; b=f2iRVeVcjNHzOOgteP4PL4WeXEM7HpdP10
	DZyl09CpNweB+HkereiQsZ9fV049FqdKCxFMX1pxpHj5X2p343CP+tzrhMGyEuy6
	2nasNOhmo/ZtyfwK946SKbedtCiihTsXtNlO0wSacuW/c2bH8/nyZfsODgZrW60e
	ycNQvqo8JtLVWryn0/Y8hjS4AcT8t+oPRkTPppDgxh+buMgSzo1pSKBWhUgQVpxb
	aq+JBzaVQOaKrUAjd9Dmn0bwSzXW9bqdNNCJn45WYoN8UlAG0KITIP7HRy+iilES
	0YzzA8UN7Mi02jMbM/eFoAClsIy71ehgElViukocOk/Zhv0KszSg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48y06w02sn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 01:41:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5840TbkJ040719;
	Thu, 4 Sep 2025 01:41:11 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrar1f2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 01:41:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V2hq9Tcf236v1rjVKdawUq1tushsq1A328rW1ICSv69YIf1Wz9ATXLq30pRabpneZ1qaeuitu66bM0TnRkbIRzOP4A4KXIHKJLipcxOc6qX/g3mlBHimjSASz6uE5Vm/YLv8b0jP5ZjzZ2F8GBgzS5SkzdZd+r33F/ejhTaliA6nch5LuFJ0rDafbjiNcZB//qPfv3RdqlmuEunm56l/wHa4mxfjo5FKOXA4MZ6gEdLmvW+6MGbfiBz813cFBlWHOIUhZRZpXvkMx6uItakwWsYfCdCrLeRRzB7lpL9a/fLd1yCCtCE+FjdZ4CIKGQn5mjWuFPGTN/xzgZTv8Tkxxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gw8GqAMZ/xo6KGvVgX9f0JXICs8Hyv0S3YB/GHRSt9s=;
 b=zD0pC8lHx/r/P2m6I+1MOPsQU5uVw+S+w0mZTpUt9f/xtnzV0Xk7TnqgK0ZVo/JO689yH1FgsN5vjbOPPdvVciKqISTh8KCBVrDugiH/z9PBGwfmLeeelS4dNg8OXnkEZ/3EoAh/PlZm6pVYKmQgEgVHLjmt6T3DHZx7DVslL7QzRoKQ08a/Y7jHNyclUQqS4TICUyCbLKX2Su67y9DG4cnEf2+eWSkEF3cmnOK0MJ+y7Np7sOG+Lq3DDULI1FYpXFRNViCusNgGlAR4OVFck5frOp3WNJuKx2e0hBNH/7+8x1stSlnts27ggX3xXadFB5dqwvG9Wr6oxeEwIUfrXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gw8GqAMZ/xo6KGvVgX9f0JXICs8Hyv0S3YB/GHRSt9s=;
 b=XXUOJ6couadTjhilxLZkHu79EBiKQ2VLLA1mhffZgG+YTFkfRxQSZF7CY6wzLnmFiHD7XgNeAqAjI4gF1d/p9h8Pj5Hs9SghX43EybEX8JRZCu+NyWa8Myj5NTzWqD+SPGPDxaoGoG5ptRvwzK2fPLe6z110k4KkYn2UdxCFsuY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CY8PR10MB6489.namprd10.prod.outlook.com (2603:10b6:930:5f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.17; Thu, 4 Sep
 2025 01:41:08 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9094.015; Thu, 4 Sep 2025
 01:41:07 +0000
Date: Thu, 4 Sep 2025 10:41:01 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Uladzislau Rezki <urezki@gmail.com>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org
Subject: Re: [PATCH v7 02/21] slab: simplify init_kmem_cache_nodes() error
 handling
Message-ID: <aLjuLRHHfEmJ2tRf@hyeyoo>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
 <20250903-slub-percpu-caches-v7-2-71c114cdefef@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903-slub-percpu-caches-v7-2-71c114cdefef@suse.cz>
X-ClientProxiedBy: SE2P216CA0162.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2cb::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CY8PR10MB6489:EE_
X-MS-Office365-Filtering-Correlation-Id: b0a52941-e3c4-4728-deb3-08ddeb541e3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BmbW51Ex8klAlacJUAUwa78XBxKTkCmNLw5IZcKmV94ymMYjTl8s5K9fsvsV?=
 =?us-ascii?Q?0cJcuf0kSpwQXCcY4+tMsim4VSDFjUDSFt+Snd2phArBiTF4Z3Vd2wYnYavN?=
 =?us-ascii?Q?GsgbjUmbdHJraaHzBy8DqiaBORtZ988zHe20nmiJVTouOydz2p1tEt+DxWaB?=
 =?us-ascii?Q?PTwhRAHzSN+3DPhDqwpqyYg9R3HY8FVCQ3n0x72JDmlMvBKiXTVspYFScArI?=
 =?us-ascii?Q?t/S4Kl7MiI40eSzOkWxCOuKZMKzx8NB0qHmAkNNaWUjToT3RhNL4xAx9EA0M?=
 =?us-ascii?Q?9Tlbq4WolqyzsZQaW2LGEjznboqOauDtIAK3XZt24KMB09Kqtag4XlqgU7dz?=
 =?us-ascii?Q?trs91+eEtW17vdwGOCBMIwDMQUbnWMDo0UMRSchrX4M0xKpYKwNGe0wtrRSL?=
 =?us-ascii?Q?jg3lYnUSiSJJ0QNFPxftjZbqydlAHuAvYFwoK1fD+2zLwWqZOZTqkiwBPOwC?=
 =?us-ascii?Q?pOO1Fnc/QzoAgydm9XbVvhcb4jW6r+2WUgI31AtlhlLBUSgxV+lTH1Xipxjf?=
 =?us-ascii?Q?AazD4vU3EeQZa8tIa4xr5F4zEf4+J0NSF8Y7HiNpKvO8Debt/KA4ETf/JA53?=
 =?us-ascii?Q?EfBaQrCfQfsB6Z8p5o1+nhTctGve+Yqujsnt19Cn9xJcMZ+FPOSofjhGD3Vq?=
 =?us-ascii?Q?jeyC0SxzRW0ATUpnv4GmVOO9KXUdfYXvd7GX0oWpEWiKn9jTvs1L2aiwChbl?=
 =?us-ascii?Q?7hWBbu2ZRQYOZgPV8/EGvuwDmB2V2j7XSrHkdMOesh7Px6YRmzJDNnrB9uM6?=
 =?us-ascii?Q?JqAD3a0a23jlkNWcjnH9RBaeSqKPlu/BaJCmsy3wYBKqO0nEPXcHTwXEg0gz?=
 =?us-ascii?Q?352hoprDSoWXopIVqgqD9aE16w3rtia1lPnPA0TerRDtWOPcRN5ZGP7Sr2Qq?=
 =?us-ascii?Q?MgEbr2MIOWiV2ExRXSJHXfrRxXiFholcMzWUNnL3nBb4LOCxy39vQ/aeTcCQ?=
 =?us-ascii?Q?jgwBW8FVC45+TjwyCM06bXiaKSBb8MdKyNL+1GOJ0NONUVSOBb+iZTyd7kDO?=
 =?us-ascii?Q?Siw3GAzAyCDWGli+tquDLU3pIVE81hpLh1dxY6mpnFjwBTbuGk5EUKCOg5fY?=
 =?us-ascii?Q?QmuTCWffI64ijXvaQD2qmPdhUF/B0nyWisGEDbMcTwv+FoJ1ZUhuSwGZ7Ceg?=
 =?us-ascii?Q?YrmxZuJHfH4oXf4z+qzVWpUlUnljmXa6Co7zsF7VZHAH0RnylypG6NEtnJA8?=
 =?us-ascii?Q?PRVSl4xEbXrmEj/lCVVtQ/eHe7s/DYuwTK6e6Co8qdZ7Q9/YhJIhBYwzzaVF?=
 =?us-ascii?Q?LB95yGk9wqfBU3fhptcqdiNS10ieQxBGZELOZGhCQbOZuT2OmfU8w9r2c9Lb?=
 =?us-ascii?Q?J8myNr04dzX6ZC0uVurcmIdygzN62YFyxD6xftsUxfSCwH41m/kDrmTsd8Mq?=
 =?us-ascii?Q?0K2WvBhDThY/dPjB4l8aBiV9aVQNLN1PgnBkGErDMkhdRfhwOXaTs3sS0/Iw?=
 =?us-ascii?Q?L0naq4k21LI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qL7/GT1xRgqbzF55nL8hvyrviTFVp3CULFoPqSw6BPz8NAf/AGDr4K4jf0J7?=
 =?us-ascii?Q?43lgT/XaVMk8Xk/Dh4TOTbHSnfI0nerFA7RUcHob9MWz+/+yaq2k4BMKufjC?=
 =?us-ascii?Q?xkFeiT6XnLAXbznm+YBCxx/YWRty9wWqp6chBPd2TkZlPfJXwaSnjWEsSupr?=
 =?us-ascii?Q?vUAS1ccXlZhZFLtGN7m6HcVV6jHuPEhufGXMMK2oJjkQ3pXFyTkbSeS28Lm7?=
 =?us-ascii?Q?3hoHjp7WMr+JqdCmDNhk+ezdQf6TNtNZiEybpxV4wS80UZgqI+HZI7Uhn3IV?=
 =?us-ascii?Q?n511cNS5ublUHhtkmFtHY9XuUXDNChYZSHGZoMWtLuHSXNtbCdErizxVyN4o?=
 =?us-ascii?Q?IPS6TuqowhM7fIcwQLimxiAxhdUavdmeB55BJLk5DsW+Wr1acGj3W1J478b4?=
 =?us-ascii?Q?Xft3rl+xnYIsj7vKuqzzD3A5Mx/IBtqcfOWKBZxb1tRZjdIRk2haOOZhBDqC?=
 =?us-ascii?Q?4HEg07ISBE7kf7zUeTy4tNGRLZm4imM0Fxmx1tFFU3Mbb44KW5cY6q5s7R6F?=
 =?us-ascii?Q?QZXG+Y/LIOIXcx2yDYeSvb1BbbE8ExsTB+NgzigmOc04xblDBPOznCDQGyad?=
 =?us-ascii?Q?Ez+ma+lCZgGZYpLuIjpdrebUROnMs/lQkwtvqDe8OFDEE0EKNpcPRfHh7mu2?=
 =?us-ascii?Q?GKX05ck1DXsjeLRcd/sSLPa/KK4kExN6m377UMtqMrEtZY2J3k2+1Y1UHpdn?=
 =?us-ascii?Q?NxRo0datPZ8xqe/1qcM03y7YSnkApY/Fq1t+ebypo0JUxf2CSI/EIB0QSSkO?=
 =?us-ascii?Q?wgOPglTFpLCKW5/r7xfb01GMIyxgDLabEf+70/VAJnvfZA1nEk4QsRqAYkjR?=
 =?us-ascii?Q?q5Ty0OuQh6UfLV0K7YPjLJa+FcLzWhNGgiYI/+H6l4Lglfgp/XEDPAaIoxHR?=
 =?us-ascii?Q?ThpM+y9uSsvUVUj2MJgYU42sLo8wYS+Y1bWpLDZ5Zqt6YhHeF9RmTkKfWruX?=
 =?us-ascii?Q?Xu7bKaZ0NG4bdr72dAmVkUR5aOrxDrVly51IB5J9wLvxBC+3ap758HhpEKtU?=
 =?us-ascii?Q?7qilW4vyZwVYfV7AZoZ3hqflYv6Fl4Hcg/9NY7OuouFT56cvjeKKJbGItf5h?=
 =?us-ascii?Q?j/nBblF7Cq0dSXddjZs6C/ybZnjPj2Hzxh0zECKSBY6Lem7UtncqdNFub6KY?=
 =?us-ascii?Q?vBaupyA9bnwGVkaIRSAL4OXZap74SmEUfjcS8sLz3gwsao0y5LR/3Ar5Nwwi?=
 =?us-ascii?Q?7Mr09/xyAP5fUxwjO5etJb07UyBr0mOKZVuLr01OXMdk4AiFEygyyX4LDPQk?=
 =?us-ascii?Q?EjoXKvZat4Fueu+DcNlf/koVB4eKRE59kdZKTOMdtA0Z8nj8Yzh9EFlTYJZ5?=
 =?us-ascii?Q?pRRFWXXjJRIS3YM9PqY5nT96iQwsk4COwOD0lWwOAPuKiCUK4ChnMMO2W2fK?=
 =?us-ascii?Q?gBHwcCRaDnb8hS87LEAIzptsuG3BzBO8kisZ1MEkxNDk2RevmZkmpzdLAIRC?=
 =?us-ascii?Q?wDcBE0tLglwRyN5THsCYoi5g8d8g1Q122GXM59zoS7OIblT/5o2MNrX6Jr1N?=
 =?us-ascii?Q?bu7IPy2q6nwspGqDlqg4prZXcAyG7Hl5HuRGF99z7OwLpeK6u1dzhGOozDtE?=
 =?us-ascii?Q?BF1i58jfmcf2XDNrZrGMYRtphPp6esx3g2FniRYU?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NXE+7kIxZUXHa+WpCv/kED7Lnnt7hzxgDwMl5S+jju4gLQDff/0jIlcMddeR5UB+QMDSkc0Kh7v2HLSCBjknejM4YrS1VNR9QhwGAHnVoYUuaN/FuatKySWgjLBolWJPvpg5Dr1LqHMtg87Vp9sMZTqZHeFiDPOmXR1BM5bsYd0NmAOnDJe5DgmOuN2p1iA0u5ajTEaGHUmngOSq3wPN0j+T3GJ9NDbMQtvxw+mVhGwjajWL2cpcPmhqgwX6tkEYVMOkGqIMlgvPqlT22B/+vj4FXQBmgCjH8Azukf/kNKYywklh5Mhpv8kD0JAP0UpphyItd8JGTN/JHCOrcYWbJ7XdC1LtNlc02fD/x5/4rCQFKe/OVqzgawubXmPfvbxDXenUbNOsT3WkB6wPPwCTewqXy5NSkTb/9nZ9j9kUsfl4f2bmwbllrEe/TrVlRw7f/vfigugrRXfZbWfaTscfXJav1VqmDfuKDBgPIxSSyrGd1X9H89MyIhh2nPBYXNJpQjYmEMivoZQlA0qLoBpBWrXJDca/ajUPPh+EfAKosrTJNEp/+LvNw7RCrrq20mfErdCasAsjwQhcj3ZvuFfvjCJ5mZ3U3fmIoYMx1CBiZbk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0a52941-e3c4-4728-deb3-08ddeb541e3e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 01:41:07.7989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pwWMoOC0rDnO0MkmSdHq0+fAeJan6nxVNJ8Rf2NiPunQDI84ndZ6lKWDyo5MNa1RVi/qYYYT2jm9w69SCLDYMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6489
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040016
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDAwMiBTYWx0ZWRfX8RQ6pj2bJ7D0
 sCTLWJRcqujKDSWljvOS8cVlhY97wy/xrXr6TALrxzkJwLYa1n5+yh09z+eXJqD5/4sm1jr8xDf
 ImERBNHXi/pWcaj2/lOWxyIFe/mDXfoANehJRBQ69rpWwkV3jYPAZEMUcxfRIH/2/oCKjwgcqQZ
 AFLmJ32Pq2dQPPW/TVmgunK/H8vrAACp1ZgPFv3dE1KWitSN7+WtdbsoAKGnuOGAAKYSfxhdmv/
 eI4FUoIROvHQu92BBYe0zK1pkEK1EEAjdoG0Tu4sYc3UIZTDGqNKzweZYpKi/bJzNbw2h6P8k0T
 rjenjHf2/2uMBY/aOPW5MvZoFKYWJabVWk8jljAinQn24S11ML2X7mBiWFSPXPRL38LP+z3PkqH
 p+oJqIga
X-Proofpoint-GUID: gg0JjAdlVqlYOP4a2rQG8dInuF5Vg800
X-Proofpoint-ORIG-GUID: gg0JjAdlVqlYOP4a2rQG8dInuF5Vg800
X-Authority-Analysis: v=2.4 cv=A6RsP7WG c=1 sm=1 tr=0 ts=68b8ee37 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=unuw46moUMiMv4NvmUsA:9
 a=CjuIK1q_8ugA:10
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A8EE116000A
X-Stat-Signature: eufc47p5ihs5r1keexng1d948imzpxrf
X-Rspam-User: 
X-HE-Tag: 1756950075-367678
X-HE-Meta: U2FsdGVkX18m22HWc/3R4VXWT3IdhZUH9sqEixqxXzm28u9SZryZpPii5FatOjKxziDZuOFGozwz1NrmRcA8oH2qCR9JwCYhO4ucMEatDbJN3rLlGRmy746TpszbqZGFGlm02tMwnN9vnVNmu5qiejp14ouygEiXwatiRBbpiDk34xw+8/BbGpruhkdS8A+sfwx7hXrghu4x8oTBNm09cx3FFMh6MbEIHDH5yNcwOj+Fxks2KD64ajok7hHUMf2qxgJ1OpX1JrA0oXUtN0K5kdj22TA7emtY+k4EKaC/JrrsYJP2VfXq77lqQeteyBLN1F4Nt50SORl6Mzr8j12Z68M2Si3b0sq9qKo4wjFOhl+stRaqgKIdvWBKDoNpPvcLsRRQ3bEUbE/n+6kodU531HM78P6FKLQAA6swuuSSrKw46kHZ0fG7LuFgVxkYnwuq2PEwTpOV7jCo7I12+rGmCQ/8XiqU+T4AatGZPNavcdI6dsClWHlVYYN2/iCH7UCATcw9jRDBphsy0vzTQu4zSmc4urNGmXTq33qWLFMMshup8Pax9Y90n/9J5Bxja945MUwL6uJesBikjJhyLyPfbk/ECu5Rcg3FxERDnaOsHDA3Vh+A3jFqiFqKn5BEG8Rwq+C8N38bLxSq7ZotNoeXyqLPtJ4O6BbohBXgMNZTXquLjuA/YyX4O7eSGXBdT14C0RhqyY92mwaO7JfyjxzfBwC0l7J6oYMQYbdk6bkcgCXImaTHK8boRB2lZ2NfDM0V3zYaGvBsDHv8gHnunBv1Th8NsR7J64dVe9zur9Oq2KpXbsnrKCWT+ADO30oZ+5g3PU26NzSz1lIi+ahA1oC92cI0YZFICgGCN0cOpj7+9uJrnDt6+k1YEZzThDZP77PPJKiwtXQ8USzY2jfeGZk6W/xKEDA1NpWo8WHMh6NqRIbeHAqodi9QZR7LYo2ZJ7CNGKnEwK8mSQbHB/kQVvs
 952lmd5D
 ArhiwZg2vStEstXL5qOJ2TdrcexPDn/iKajkmwqSqbR0TXtUcsFtedNkQX8yRW5eKeGmdc4/XexkbIy+AQOza6wxNKNRd7dVQGvcTIFqLcnpQGqmR27/1Ru159P1P8XPH38mpOmnH6yeqd0NS9WK8H1RWi+zn2kAySe1SQpF8f56TsrwLrCZX3SlWvZ3x6miJa2ORAAh6IEL4YnJ/ECg7oJ8vA1GpVbU8bgXm4BYzuVcq/3Y85pRXuf3Wzj8qat+t9/5KzstA8gyAj7O+s/BdcAZs3+qjP0i/Us12SoBA0UHcrHZSDaqoamG7CkbA8iY3z8NntMOf032+ca5B92QDSsU20/FRJSJ9Gc2ts0bXq9Lc5g9JZpBMlG3mqXs/0Yr3+kp+dn73P9DdISpB9wWIHRW4BgIiphwIDH5SmKkwBSe1nA5dqaduu6k/JM3on4kohkXSpOuysHQ8Zexcr/s1+/qCLSvFPUuRBN04gD7gmEH5WQLXmkUAKLja2L/FVMeNtcPO2hJ1T+f54vnI8rQm/J04Z9sRYi6P92d/Qq/D0NrRd+2p7Hpthh9pD6Pi/36gPhdGW/Mu9faDDmWBVNUd5sc++DHE+uejJrSELREqNhroD9beIN493gX/eQhIauZ4QBc/FxBXZwE5+Qe5jg/RkFUwY6a4xQFtu8uuENbQgA9DJXZmsP0xivMIx4EDam27H/DIR3V4U9yv0r+rIUOXyCAucXCaJPnYfBT13a3jzVl+y2+AUpPlUoBWxoXGVe7s0DYkA07O36JU37bEZo5fkg0Lx0pdZgpCdEyY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 02:59:44PM +0200, Vlastimil Babka wrote:
> We don't need to call free_kmem_cache_nodes() immediately when failing
> to allocate a kmem_cache_node, because when we return 0,
> do_kmem_cache_create() calls __kmem_cache_release() which also performs
> free_kmem_cache_nodes().
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

> ---
>  mm/slub.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 30003763d224c2704a4b93082b8b47af12dcffc5..9f671ec76131c4b0b28d5d568aa45842b5efb6d4 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5669,10 +5669,8 @@ static int init_kmem_cache_nodes(struct kmem_cache *s)
>  		n = kmem_cache_alloc_node(kmem_cache_node,
>  						GFP_KERNEL, node);
>  
> -		if (!n) {
> -			free_kmem_cache_nodes(s);
> +		if (!n)
>  			return 0;
> -		}
>  
>  		init_kmem_cache_node(n);
>  		s->node[node] = n;
> 
> -- 
> 2.51.0
> 
> 

-- 
Cheers,
Harry / Hyeonggon

