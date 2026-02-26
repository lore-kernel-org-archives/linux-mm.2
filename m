Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8449FD461F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 06:35:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E7746B0088; Thu, 26 Feb 2026 01:35:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 695106B0089; Thu, 26 Feb 2026 01:35:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54D876B008A; Thu, 26 Feb 2026 01:35:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A15B6B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:35:50 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 536451409E2
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:35:49 +0000 (UTC)
X-FDA: 84485647218.14.7F66881
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id E475C14000D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:35:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dwHCA6jT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZXIvLJkc;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772087746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IvktclLrCJr233caf0dvhnH9VqWuJrecq5oRcVhQJA4=;
	b=ARNzOGe6dP4sR8AflD2bhfIlO7v8Yh3Cq8I3rC9bR0XoWth+EUN0mPac78uFOtVN+A7bcu
	3clLL5nJ0ONvtzdPkignQ8qFaxaWQzaLX/8tBQjKj0XFuNTtFIFvwjpxARyBMfEzMvwAwL
	YitDki9q+Z4zmJq2oklmcwtGbsGVwms=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772087746; a=rsa-sha256;
	cv=pass;
	b=GqaF3P7GgCV2/Pzk7+ZaYyDKUEhMNNnbQ96SQdMUcysA8hBhVRRYxn9dDJ6vFIMqWOviGg
	JAM2eWj4KRErM1M/xuqX5TFIXhPzJN12Ab+5lj8kA5r19eesMxbVmC/Mvrj71qQJ+ATyu4
	Sy3BRopTfil9DjKi9BHS3SVvb6VsN5A=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dwHCA6jT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZXIvLJkc;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61Q6GffA1271739;
	Thu, 26 Feb 2026 06:35:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:message-id:mime-version:subject:to; s=
	corp-2025-04-25; bh=IvktclLrCJr233caf0dvhnH9VqWuJrecq5oRcVhQJA4=; b=
	dwHCA6jTNH++mVr0MZUFKTmDrI0CjkImlDRfOKKQfwtKwJ8IcCiVZJBfKq04JQtQ
	WGmQpZxHqmiljQzKPSWB/WyeBxddq5IHEujrAyLqF4LCWgWDDH8D/rszo5i4N69b
	YpRBwTV9ORBojfFeuDRtWmAH2hQIGTe38i0wYEAPgvtp10VAW5dY2VFcPT/34kmj
	y5qkspHKbVoc5KwVh1WVY1Wc8MNTKNoHL1LRXbLARrZycZ4xJJ8t/YgS8hDrrJ4x
	dtq9AhTGR6DSTZyFPFeTkxvyX+in6nrS9k817pSTiZjcx6Ep1C4CNfvuxLReLYwV
	Sa4VgFTCeQYsgpCQKCdSrA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cjgs000hx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 06:35:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61Q5K71G006267;
	Thu, 26 Feb 2026 06:35:25 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012047.outbound.protection.outlook.com [40.93.195.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35cbq46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 06:35:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z0DTSRB8XYUmW5OX4G46bPggd+Qvp34cZ9qFSMQY0+Y+9cg6cNR81fFW/ocjUJemO+R6/hCofl9M+U5SNXWEOHbaLm53XbnSaHgOa2Ff2Uu7tWd28KsS8VwH71bR9Sx1faMi9DFlLbgwg/f/pafWOiIBaUm8GAK3RaEyXEjVgDyF/udpwsTLOfEdtjsRTv1zP4a5zff5W9j30jOqNOqLzynBgxzlwliYDODmWS3YNppRhgM7Cs+CJ4JVeulcdUP/YYciwHX/Q9Hh7QeG7xEYAL0ukSSPi0FR2ShzBqSTFvYrpi8AzEdukre1AG/DljXR+Tqo+iswP1GFZjiSHh/35Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IvktclLrCJr233caf0dvhnH9VqWuJrecq5oRcVhQJA4=;
 b=x9EEUJqfnfis+Ldgw7gXNq2IsP8duRJKrBgywkteNT62+hCKM+NmtFF7GPjFccTlc6oOTZ+gXBwXPDwPRWuP8Q03QAUtVmCCzhA+FKqPFVXYgsyTwGPAakYiuckLXv4fGCunYW4ziUjIy8LEuq6I517sEhRPPth3SUpIRkJVjp1GQUfl/wZrPWWO0kG+hhqmwdUCFhL01RyuPb4kvq3PdrFlmesTQWMYUR8BqWt/sseyKpxtBRUxVj8IaCafT4V0f1zlZabmOJulGkwukEmZrUomDZv5tNWr/2aXbebdmRuiSEAvWS+VDg/tdlPgvqU7xbN/aWrzGSooNdwTHm77hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IvktclLrCJr233caf0dvhnH9VqWuJrecq5oRcVhQJA4=;
 b=ZXIvLJkcpHccYsGC9FWUApSY1YgmerS5iFs1mP7xIqFDDtVTc9QFoj+j+qWzj3+sMZGP5YQlPr5eLrPL8TTWXFgYh1fN2gzA4khrFNp0fNmklTR1R6kAecFfD6cuKYY6U4TizG5Rupc0x+e68flleTY5WUqhuiutDZ+9+d4ycs4=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB4710.namprd10.prod.outlook.com (2603:10b6:510:3e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Thu, 26 Feb
 2026 06:35:21 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9654.014; Thu, 26 Feb 2026
 06:35:20 +0000
Date: Thu, 26 Feb 2026 15:35:08 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: linux-mm@kvack.org
Cc: Dmitry Vyukov <dvyukov@google.com>, lkmm@lists.linux.dev,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joel Fernandes <joelagnelf@nvidia.com>,
        Daniel Lustig <dlustig@nvidia.com>, Akira Yokosawa <akiyks@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        David Howells <dhowells@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>, Boqun Feng <boqun@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>,
        Andrea Parri <parri.andrea@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Pedro Falcato <pfalcato@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
        Mateusz Guzik <mjguzik@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>, Marco Elver <elver@google.com>
Subject: [BUG] Memory ordering between kmalloc() and kfree()? it's confusing!
Message-ID: <aZ_lJAqxh_hNGr_v@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: SL2P216CA0222.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:18::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB4710:EE_
X-MS-Office365-Filtering-Correlation-Id: 2afcfce9-a073-4323-7d8a-08de75013657
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	A6ivwr4iSm7adkQsBu2oZA/Bq0LMXz1mP/fEdIITlkxG4f60kZMLuKCDsw4B5WhCWhCc9gyqqX1RDVrQe4k7epGt/B2q+20L0jdSb7U4tXAUQrtm+H89Z5cu4j90Rl+yvjfo/o5EONfCmV1iSvOesxnlixTmcr6mDi1utop2qw+syKoM99KpQG2vZ5EFk5MtkMcwbM09+Wtn/oLvPqq0PDCO4vWFTLxvOhaMLSrlyLWAV1xR3UDY1WpH6iICo09EwBS0oA7ElWdh/IBbFA4eaPFH/Dkd2in+FIaWPhMw8auSX6tpY7BaT6Gj2c+Hgdyn5IfAThbFptt+CiffrIrViwM8Y8KUCPOMXT9EAs+diQ3YztmxYUOJ7BPnnvBg+42tYRt94xbdwGZQlqKvsVmP8ArPR5PD7TdQoybrOtwNFWRReAcrLNcjPhBpwyn+c0WGK3tKqGDqGHJX6dsQVGW1j3BbVo69JJfjzfnW1+j8uKOxl16DrrYrTx5pwX2O1Pj0d3sLIb7ZPWBmX/kkObGM8uirOtYfmgmacO3F2GGNBCj02NGi3F2sZvJNhCFba2LCJS1fLFRJvabDxvOVRXEFCKZZL6/zt2ceotLVQVeJtZW57ChMVi3JTNKa0kJ9AKEpTi7tsCAS2mc21KbLGW3sgEKP6XDd6qDYPKsQXQvELetIcDh/v49iRGFsWGt+Mh25PVjaKNMQDbSU6JprFDl8Fx7/A5TT8hBZ1IueQhwgXTa8rdJO05x1cwbT3UPBfSoJ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TXQG4thlFA6tJJwRuBPLLVkJczrZdszdGBiJfi16HTrQZGFLorGsw+B+b7ps?=
 =?us-ascii?Q?bpudP8QlyxneL/3IoNdNBtFiPtV6sbQkvQ5eGEUToicVXAhgT7oVQg/YaDIT?=
 =?us-ascii?Q?SkQO3hHq/PYfrRV341V346YHMQ3i9nRaMjDB7+FOcmZBuMP6jI4C4BcY/VAW?=
 =?us-ascii?Q?VuRdeJfBbhRVcbBUxsLyth3WIN2/RsK2UVlcs96VyGvp3IdlzHwGw/GID6j1?=
 =?us-ascii?Q?3uYcdJ+iZI3xUN0BsG2qkaDYeVlnE8/f3Bp9Jc4uAKPqKuHAg0cTUIAr4uqg?=
 =?us-ascii?Q?uB7r8Xsnerrm1p+QS1cn8pklP4RmskP5Hd+F/8oYDyeXN6lGWYnAi0ANAFop?=
 =?us-ascii?Q?86hY/ZEL7buKtDVitWZxAxmMjOGBpnE9VzaSB9K4ZPqSTD9BkZPRspF4WUrE?=
 =?us-ascii?Q?xHkprvBjHjSmGr5+juB9GysaF+//weW+SsUtdiXSA1R96NPbmmBzQAECGe1Z?=
 =?us-ascii?Q?D+KhTz0u787XOBVDWDvTNFCf8vkOu9fi8guJscvj7CZO8DAi4YqvqCJQmhtJ?=
 =?us-ascii?Q?+eV103Q6OuJ024iQ/OeTXI+P5nmgiINSSs+82DUSGkKGibAVBVQZIr9kLn2Y?=
 =?us-ascii?Q?XIyqixlLwCesnKZgZdsHmREKkxsmR7GOwXkbBfQLz9f3R/7lGh5vhYWH9JdT?=
 =?us-ascii?Q?UYiQv6MC5bl4ipVXMMDoQUv8NYILoEBk77kCSZr52qIHNALngRHCgu52nGiE?=
 =?us-ascii?Q?kDCbgeqI17JwL69LcfrqkcqoUmGeZA2CXCwJO6IYJbOauQoDlfUz4d8/PFi0?=
 =?us-ascii?Q?fCgvLa7/EfXF8iJOa+xzRVqMHa0vyQ9uCE+Er+AQbAVV4tVfcU/nudSDKSJ/?=
 =?us-ascii?Q?j/e3kchMTzt69UA3nxOF+uwfdwGTE2rkbZB9WMT/9sg/Mj9oSel7g4SbOB4i?=
 =?us-ascii?Q?JXvHAQJaXbQu4tG9KbuSA9rNLdTW04JEHQBstwfe5AjJwieaTasVGHHhF33U?=
 =?us-ascii?Q?NvXQ5e6eEk+ut7wax+djXOvdmRgVplKWuRUNmHTA+FD2Vnwq3jc8fBMDvkiJ?=
 =?us-ascii?Q?6tlVspulvLKcxfXtZmoOydLySj847Z5ZA4mi7A0jdK4zgMP2EpSDspo5hVJF?=
 =?us-ascii?Q?Fr8RCIJhrHHveXHdYikzpFtM2rYd0NKwLppXfGAAv6lpuRKrZ7ivJp4ZQRN/?=
 =?us-ascii?Q?uBv27/QOtWkUYR1kmNUX7h8lO4pEC2eZJX8SRoYE0vKu4FEGOHlEnMhoeBen?=
 =?us-ascii?Q?7YyzX1s36jaHqikjCeOQSslgEQMdomPz8Z1vgefO5x7lrkqotn+ZzLgxL+X+?=
 =?us-ascii?Q?5hnsENIF1UqiCxX4VScnxAffJiflJIJg8UCOpIXYXlK9sLkI03zxXvywHy2y?=
 =?us-ascii?Q?AETVOxEjMS8k2A7ikJDBwAwLh12TkBHN3VV9PvK0J/DjWKHhjEDuZvlW0/Ce?=
 =?us-ascii?Q?BjiS1HpxB44Tveo52oHfDQ7rfMXUIbl4fk8flIu+YKLUUXK60Dw6eeztYR7M?=
 =?us-ascii?Q?dCjuGY2v1pKZOyomw0bpodKQL5BtfwqREYJ+LmbYH4s31fmI5LuzPDYqEFXS?=
 =?us-ascii?Q?aI1v/4zGp6lQRL7YKg/rPS8Jh9DHkaGKN+9ymdyq12s32FVKg+cDsNGjMZkD?=
 =?us-ascii?Q?iPTCSmvn6CWjub+isfFjiKOUVyEuJGVqiRW68w3FO1g6B4HK5eZUH6+koMub?=
 =?us-ascii?Q?t2VaaCB50EeIBZe9HJ2ErSX3nSk5DM0j9wp7iuLn72Jq7U+Sg9MwT6iSIFFJ?=
 =?us-ascii?Q?oQeQF4ZPA0JcKPo/Fl08glt+JZEOcUft8GbppZy9H1EQsl5UvVbLfq18tPMo?=
 =?us-ascii?Q?UHdEuulWuQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t7Ck6flw7F2bNcyfy6TPWFHI207pkKaW0DYIj5BWPhLwdaPKphRPXfrtWVSByysJ/4u0XVigiVK+TY/X2m2damJ/svhx0VV7lBKcO3/G2fZMascfcCYccJagAiqOmhTfXPKAQnDjZ5/ezx7Ve0PPTdFUzsp7k9WRckui68KV0DG1w3wlUDN1kX1Bc9TmPEbnQSokORN0AwL2/wzYbm4aLgjgmo7kZyiyVIUaPpBUFFKOOXMkubAfm6m6ZtKhkwWmZuh8dsNzcFFK2Jmu0Yk6axj51dBUM3ufdLzFIl2QUgwhUSw0e5ZMyKMcAJ+Vqrg+EDRmGjaUz5STgbb45C7nGYUPJD2d7CEUTaxzN/dDO1r+L4xu0XyJ11M63In9OHeYB1K1yaHmBf+nBR0nqlrVS5puhXgWUJqbmJ4RgWuBAyfGSCeC6FcnOmM6w0gqTTbN5lT7C5ILAwuBBHZ7ivjWZ+oXawdnA2Yfj/IJUa6BhT3iFjEfvbrd4vL2+oWRTjLUyFjATBdrjVvDyiuexPssqFmbMgTYlHnu8x9+VJ7e7WJ+Or4D9VAi8Jwce2kDEg+QmoyCNFRG63DDI3X1A8ICzhMlNewYPpvlZJuAdDfdCVs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2afcfce9-a073-4323-7d8a-08de75013657
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 06:35:20.3422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 02jGG/Lcwlatlj93eDZj8Q22ZAk2IWLKIrmt8jRnIGTGafe/d+2FSyi9NDyFP/SAPIG+2kMR3aaX9sUbNr4vMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4710
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-25_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602260056
X-Authority-Analysis: v=2.4 cv=BKK+bVQG c=1 sm=1 tr=0 ts=699fe9af b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=Sd1HvPlFv4XxTduQrekA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDA1NiBTYWx0ZWRfX/WFbjS9mq27q
 NOl3nRAmelNR5e6HhdFc9mxAy2vUyFxytLvB9mhlcA7Z5WPsAVpNXiz6Jwrlr0Sluy3uHfb1fRu
 PbQ9iG/z578lEhc9v5ZLSD41TD3ykFxRxWI5ufOMnaAz2/T+5y7LQawG0JUVGR9SWz1Sr5NS/hP
 Z1DrOjG8BqX8NeBpPF0V2Vd/Q8oKfhnSLN3lbOpSdLJjY4RhUZtjC496e+Ix16nuX9R0GwAYJIF
 cfu8pJK4+4dhRtzb9heoEYNR3yNkq2rJ6ciE7s8iLU3x4X+qt9GooD5zQCcT6CizQWZ9CoECHaT
 8Xz/Xz7NfeYGwqh2IvwqAl0rQUx9VfujLWbv9jBxtm6JOrDLjydNR9QNd87ShWMcP276uG2qoV3
 gTUAHY0j3yYhEBAmSX1/U3nxDPi4z5nfw57qvASRtsTlGk9RlNtc5AjYfZeB5efcxMP/qnewJYs
 iVl6aA5Z7dg9dJT9orA==
X-Proofpoint-ORIG-GUID: xkUQt5XeGq-fwMBCtvTsTZDERH3-Sh1z
X-Proofpoint-GUID: xkUQt5XeGq-fwMBCtvTsTZDERH3-Sh1z
X-Rspamd-Queue-Id: E475C14000D
X-Stat-Signature: hmx43pwhfsfy3upcj3bsf64e6ad9ey78
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772087745-975893
X-HE-Meta: U2FsdGVkX1/sN5ITlJENonh7VjJS3mIHYcHVK3E4WGUoCRqdf3Ykj81hOpEbPRnTrLn0I4uF/euAZ7tv0S6h5SCyRk1VjgXqhDC8LEHpt3yngdGAUU5yz7zeb4+OjcilZwadfrf89Mr0plz+MU5BsgkrTk/vWPnoYo8w8sDVxaT4KN0M1cpNL0PD2xgRszj44Qe5el4Kyl2oeSJKeMjC468ZXRkc8DEQGqg6L8tduVagYTctaWmmqYF8DftVOpmK9EVDpQzNFI0dpGD17bN498J0XqUl8FvxJ93wWDcFkvzLEzTjBymYXUQPXCfTzpLOsNsHWj0AbXYFqsh8JTnChTDv/EwTzmaodSHqAdstnlESzAAxtb/srvVcciFqsMWgxJHyDNqp8c4a5tkwFBe4UvPZ/CVejqphK2vBSOvEa1Uu9CjzU5L6ChCJZFSfxiGqBq7LDQeVv1+4qDxtHghm/pYfVX7BzQeqNNiLxR6Jkffs948V498BnX7FgnnfynqzaWLvUdiU10t4RtDaRwXydi46CeHDeamrd6L46Sww/X373gX1qEpmIORXamHbD1LaZQw5U9wwL8+tDzWFCgSmJcRBFefn5QaSFDonSE/9VFXwr+QslV7LnuIbIds9dlM6JO/2CrRhmt86zReLNmQjAWwVI3yIkkp2U2yb9RGjU23SXx39p3J++sv2vZ/Hna9m4NopyKHYgBq+2Ck4FzBXDlThMrm/6K5rXDIskOFG6/ALfQVJtesIjexPh5dNj4arcw+W+Aa59NfcXStr6CnkbPz3WEDViFy+7WkIZI6z3VlmUFo7EXf0lFdtlqHpX5csbh5v3J6VuiKGjlxfj3yYtOPYI4PqHgLA8hO6W7UM+VYqPgBZZibDQVkUeWD6XVDlvXlJrHSTRbfEU9ZPQrfMUMHvFWaNEJBmSA7isLrKGEg8c0CfT+KqcHTNV5RjvEqOwTK1XNddWPNTSGnlaK0
 1DLWjGPQ
 qFmS1oIFgpjOQ6asFZ6BxlL1+d9W3WbEMkva32R8AfffKqpx4pL0ODyQz9vP0ld2z70Hfpyx05Y60gqWBrUaJQmUfguVFmweSD6uTUVXwn+fnAv96F58Aw+eMgAjeTGLnopkknPG5vHjq4zNfUwO/iiH2bT3oUuhGaXRy/Jqsf74T31I77tWc6Trw2OXJUCzJwnuwB0EF/KBViPrpJNgKpGAAM7sO9GrnP15y2cJdDxp4nU0jJZSotHx5I6BDpwYthls/rohhkQEnWIfeGeIlhJrTflyK7nFx4Ijan866ElTHM/OKldCcQ1ztvr1cZxrmP4gel9hwtJOQQS2pdJUklH0YQ7dkSHSsF2k8V7UD/dii2NKMsoRA90DqxRjgU/hy0UsbtqDrcdNe1NOz44kBbOiu9adL6h3eFG1cdeQZMTVjXryX1L8tnQqpMXlF1NMMICPbrM1vycERe3htyYA6MtU4uBOubjej3hgO7lGkB1Xu9y6kvCPZ9NnMKPz8i44Zqmvwg51gxsw4WlmGQY+thwohwq3wzl279U4coOE+Kt3ohFjTwn8cArCE2r2LeUEgsTkbuEtJ0jcg11PXR6VnJ0jvj5Sm/LP/9yybbPOgb4g5S+fUPlZJzSus6pSNqQsHNfJ9CKRAMN4ktuiD3jXDVyen3gysY764ekR+0Ppz7CxJISsuTc8Oam0soJKiFzF+/jhi1uPDOjEDu5Iu9IIzRsDTzCbi+ydh1DRBrW7BQOLUUgsQgifTCUMsQNao/iPfAZ6uPhrry2DGVENRcSXv8Nb3ldEW4i5wo26VH0JLWCvbR3MJJIJJVXRWoxVoE13bTAuoQC6BbgmZb3DjmTmPh9ei8bM/XxSwogKyRP7DI1R9EEStwb4BVtE3O28edtkVFp9ZKQ57gRHtYIO4K2seWrSsC35K4iKF1edO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, SLAB, LKMM, and KCSAN folks!

I'd like to discuss slab's assumption on users regarding memory ordering.

Recently, I've been investigating an interesting slab memory ordering
issue [3] [4] in v7.0-rc1, which made me think about memory ordering
for slab objects.

But without answering "What does slab expect users to do for correct
operation?", I kept getting puzzled, and my brain hurt too much :/
I'm writing things down to stop getting confused :)

Since I have never thought about this before, my reasoning could be
partially or entirely incorrect. If so, please kindly let me know.

# Slab's assumption: Stores to object, its metadata, or struct slab
# must be visible to the CPU that frees the object, when it is
# passed to kfree(). It's users' responsibility to guarantee that.

When the slab allocator allocates an object, it updates its metadata and
struct slab fields. After allocation, the user of slab updates object's
content. As long as the object is freed on the same CPU that it was
allocated, kfree() can see those stores (A CPU must be able to see
what's in its store buffer), so no problem!

However, when e.g.) the pointer to object is stored in a shared variable
and then freed on a different CPU, things become trickier.

In this case, I think it's fair for the slab allocator to assume that:

  1) Such stores must involve _at least_ a release barrier
     (for example, via {cmp,}xchg{,_release}, or smp_store_release())
     to ensure preceding stores are visible to other CPUs before
     the pointer store becomes visible, and

  2) The CPU that frees an object must invoke at least an acquire
     barrier to ensure that stores to object content / metadata, etc.,
     are visible to the freeing CPU when it calls kfree().

Because the slab allocator itself doesn't guarantee that such
barriers are invoked within the allocator, it relies on users to
do this when needed.

... and that's quite a reasonable assumption, isn't it?

Actually, I'm not the first person to question this.

[1] https://lore.kernel.org/linux-mm/CACT4Y+Yfz3XvT+w6a3WjcZuATb1b9JdQHHf637zdT=6QZ-hjKg@mail.gmail.com
[2] https://lore.kernel.org/linux-mm/20140102203320.GA27615@linux.vnet.ibm.com

# Now, let's take a look at the bug I've been investigating

There were two bugs [3] [4] reported, with symptoms that appear to be
caused by slab returning wrong metadata (the symptoms: incorrect
reference counting of obj_cgroup, integer overflow as more memory is
uncharged than charged).

[3] https://lore.kernel.org/lkml/ca241daa-e7e7-4604-a48d-de91ec9184a5@linux.ibm.com
[4] https://lore.kernel.org/all/ddff7c7d-c0c3-4780-808f-9a83268bbf0c@linux.ibm.com

Hmm, if it's returning wrong metadata, how could that happen?

Well, perhaps it's either 1) the calculation of metadata address is
incorrect, or 2) reading the metadata itself is racy.

Shakeel Butt pointed out [9] that there's a potential memory ordering
issue. It suggests that no enforced ordering between slab->obj_exts
and slab->stride can make the metadata address calculation incorrect.

[9] https://lore.kernel.org/lkml/aZu9G9mVIVzSm6Ft@hyeyoo

Let's say CPU X and Y are allocating/freeing slab objects from/to
the same slab. They need to access metadata for the objects:

CPU X				CPU Y

// CPU X allocates metadata array
- slab->obj_exts = <the address of the metadata array>
- slab->stride = 16 (sizeof struct slab)

- stride = plain load slab->stride
- obj_exts = READ_ONCE(slab->obj_exts)
- if (obj_exts)
    - metadata_addr =
      stride * index + obj_exts
				- stride = plain load slab->stride
				- obj_exts = READ_ONCE(slab->obj_exts)
				- if (obj_exts)
				  - metadata_addr = stride * index +
						    obj_exts

				// Wait, obj_exts is non-NULL,
				// but slab->stride is stale!

				// Now, metadata_addr is wrong.

Hmm, this could definitely happen when two CPUs try to allocate/free
objects from/to the same slab. We need to make sure that, CPUs cannot
see stale slab->stride as long as slab->obj_exts is not NULL.

# How I tried to fix it

An expensive solution would be do:

CPU X:					CPU Y:
- slab->stride = 16			- READ_ONCE(slab->obj_exts)
- smp_wmb()				- if (obj_exts)
- slab->obj_exts = <something>		  - smp_rmb()
					  - plain load slab->stride

Then, CPU Y should see either (obj_exts == 0), or
(obj_exts != 0 and a valid stride). (obj_exts != 0) && (invalid stride)
is impossible.

This fix [5] seems to resolve the bug [6], yay!

Before testing this fix, I wasn't fully convinced that it was a memory
ordering issue. But after testing it, it seems reasonable to assume that
it's indeed a memory ordering issue.

[5] https://lore.kernel.org/linux-mm/aZ2Gwie5dpXotxWc@hyeyoo
[6] https://lore.kernel.org/linux-mm/84492f08-04c2-485c-9a18-cdafd5a9c3e5@linux.ibm.com 

# How I tried to optimize the fix

Hmm, but it's not great to have memory barriers in slab alloc/free
path, right? So I tried to optimize it while maintaining correctness.

Previously, slab->stride could be set during slab's initialization
by alloc_slab_obj_exts_early(), or later by alloc_slab_obj_exts().

Within the slab allocator, for the slab to be accessible by other CPUs,
they need to go through per-node partial slab list
(struct kmem_cache_node.partial), protected by a spinlock.

Hmm, if we make sure that slab->stride is set early, before the slab
becomes accessible to other CPUs, smp_wmb()/smp_rmb() pair is not
necessary. So I made that change [7].

But something strange happens when I tried to optimize it!
The fix didn't resolve the bug [8].

[7] https://lore.kernel.org/linux-mm/20260223075809.19265-1-harry.yoo@oracle.com 
[8] https://lore.kernel.org/linux-mm/2d106583-4ec6-4da0-87ea-4ecad893b24f@linux.ibm.com

Hmm... even when slabs don't go through the list protected by the
spinlock, perhaps an object was allocated on CPU X, and then freed
on CPU Y?

But as long as "Slab's assumption" described above is satisfied,
I can't explain why stores to slab->stride, or metadata won't be visible
to the freeing CPU :/

That makes me wonder "is somebody breaking that assumption?"

If so, the smp_rmb() in the previous fix [5] might have unintentionally
acted as a band-aid to make sure stores to slab->stride and the metadata
are visible to the freeing CPU. But in fact, a barrier should have
been invoked by the user.

Looking at commit 9e6b7cd7e77d ("tty: fix data race in
tty_buffer_flush") and commit f57e515a1b56 ("kernel/pid.c: convert
struct pid count to refcount_t"), it doesn't seem too crazy to suspect
that somebody is breaking the assumption.

Does this sound reasonable, or am I missing something?

p.s., Many thanks to Pedro Falcato and Vlastimil Babka, who actively
discussed this off-list with me. That helped develop my understanding
a lot!

-- 
Cheers,
Harry / Hyeonggon

