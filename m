Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3141E7E0CC
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 11:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DA966B0005; Mon,  9 Feb 2026 06:23:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E346B0088; Mon,  9 Feb 2026 06:23:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2CC66B0089; Mon,  9 Feb 2026 06:23:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB5E26B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:23:45 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 864681A076C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 11:23:45 +0000 (UTC)
X-FDA: 84424683210.22.007FF55
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 356C840006
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 11:23:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FqNBsB36;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="E/jGPxQb";
	spf=pass (imf27.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770636222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2CvHecaFPm/zX3DqYFC6/WLY2GqU8bmZJEfSXPpPTcg=;
	b=2PpTxSwevzNwcTDaA2HEDgldGfvqSqPQZb9ahK1nrQ1sEPxlBxaXUaRFO1455+a6PC4A9U
	HVwQSEugYmlC408ZuqFBDbqCcZ5D1udhBXUYMy2A3iVH7PxvjXQBisltjLImHOtJileMA3
	MJD09Hz61X+aNrupJgknH9+EkjrJWvU=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FqNBsB36;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="E/jGPxQb";
	spf=pass (imf27.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770636222; a=rsa-sha256;
	cv=pass;
	b=SZF161Kw/khgHCPQ2yLLcVYGDzAB+Uwif6FJZkda6I/RfkS43sijug7p1ueMFKBsS/PnSV
	iKdcYQrk60Joe0hxwjS1Hz/oxJdsy8PLBaK+GJDv96HmmhQGIX/Ux39iClb8kjvon4jYE5
	2Ncauh2JF/I7mh/zZFfsWQhTciNA4nA=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 618NP29I588152;
	Mon, 9 Feb 2026 11:23:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2CvHecaFPm/zX3DqYF
	C6/WLY2GqU8bmZJEfSXPpPTcg=; b=FqNBsB36vOZZ2LU8ItMnSvzKc1jT5YdJeH
	4GSbILAWb50ytbvoMJjDWq0PkK1STYvz4C0665eJ0mP70fcq1P4WMZ3U0J1xiLKH
	J2yXnH7ARmLR1fdyytuCg8HJ83Qf9o7Rnry3STguUJlg8ISl5Rf2Y4960sMCK+05
	+NpqSisTS3/f3JsPhZX7c88qENoq9ljr/uCXF2qNRvGmRvVmSIflGRHCff5XLLCF
	QGoJiYUbQ1dsPiDZoCA/1CUXi0z1vj7aVtib0CjeJ6GJqrN3ua22H04W/z58vfZu
	8Z3YFGZezg7ikBGgyD2KhFojsx7IkrRVjNmsBpgf1V+ZzvekBgYw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xfp1svq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Feb 2026 11:23:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6199K6Kj019926;
	Mon, 9 Feb 2026 11:23:06 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010042.outbound.protection.outlook.com [52.101.201.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uu8xa6c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Feb 2026 11:23:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s2P/RqjeuDa3TifW+TTPgRIDW0LsY+3lnvUCOw2uGkZ/qid1JibUt2UJXybwLLIocq+2rqmsisiKXhQjiOA1sP7NWDxFqJFHwpYH/+oCuhHtXcoeEKflXt3kXxfRHXQvUfqwpxAcFXCPznjQVdGsiqCM4rpmCcIR39smtHsqQYaXVzumgYfKYGX4nVVz3Ip5beA+nYXlqhr/reXqB+LYOHFuWPnLTnKyKpuaCFEZbAc2eIUhjZHe132jGurc2ZZw05Dwtg3c5ligZ+D1zBOLcF0F18xbXerkT5XnDokWY4GJI8BuM083T8DQlTNsBxcYP8+EbDbLO2VZiExvj1XY0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2CvHecaFPm/zX3DqYFC6/WLY2GqU8bmZJEfSXPpPTcg=;
 b=bLY8BSIDdxZaWZEmD+M/atYvwE/m2i70T2N34Vh1wWdpu1UgnQyCX6suC3NIFsu2endQUhWGhxwCmSVKR8XZL5oeEEC5YYh0RXHAczYfo5+rmYpJrw0VTgJPwWi75DJmm8bdYtrKAB3uYtDJ8nwwa5cpNFQ8cfEMxuP0UCB+m07hHRUgp0lDqzAWns2OQ1FY6QDUtlwvXzfXglI6eBXYf3pX1rEVBhLAj+yDrp16k7pG2Wnqi5O7wiXhQlvA3Du1Sb8UIoLyow8hVlIY+pXc/CFq307p8RWhrol0rw3O19wtOt887cpcqfmrDgXJUHsyPMx6egGlWWua84y3aazYog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2CvHecaFPm/zX3DqYFC6/WLY2GqU8bmZJEfSXPpPTcg=;
 b=E/jGPxQb7bF0Jvsx0iSPFDr/QdSyQjATff+fsEnsbq4g5DSp396tYSrN4fkuv7WfxgOUUI5JqgUlyc3/b59DzKwJUSUCSMGzW9g36XC97yczocZ8StETtirUGsemegeHT2DrY7qhH1A514a9op83L7KHUdhX4kqdhQbKFZxMDOA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MW5PR10MB5666.namprd10.prod.outlook.com (2603:10b6:303:19b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 11:22:57 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 11:22:57 +0000
Date: Mon, 9 Feb 2026 20:22:45 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Uladzislau Rezki <urezki@gmail.com>
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
        "Paul E . McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
        Joel Fernandes <joelagnelf@nvidia.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
        Dave Chinner <david@fromorbit.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
        linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 2/7] mm: use rcu_ptr instead of rcu_head
Message-ID: <aYnDhWKCoTRsuKa5@hyeyoo>
References: <20260206093410.160622-1-harry.yoo@oracle.com>
 <20260206093410.160622-3-harry.yoo@oracle.com>
 <aYm5zZLvkZpCYw2s@pc636>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYm5zZLvkZpCYw2s@pc636>
X-ClientProxiedBy: SE2P216CA0103.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c4::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MW5PR10MB5666:EE_
X-MS-Office365-Filtering-Correlation-Id: 9650efe6-7cfc-4dae-f8a1-08de67cd9346
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qmkQacauD2hnADVdunL/1ZcvY/6TZQWKRvIjOI14Il2CEvykYmMtgoGHGRY9?=
 =?us-ascii?Q?EfjKBFlN90phjqo7h+fN/QN5ZwK5ek6pub2k7CwJQBhjFE0Oq/oAT7voArE0?=
 =?us-ascii?Q?prvHigtT35EPDIB7W8N1HxZ8NA04TeP+mdhGT1ngmQP7rVUzDnjywYcP3jF0?=
 =?us-ascii?Q?lwBFzIj0+F9uqDZU1PktKVZhYpPF4u2sZMnCwPKkQm7E6P01nNbFFm8e2E7V?=
 =?us-ascii?Q?n6CCKIF2gIBTGLCM+6dwQIK/jKVAdNhu/AZ5dyi02Rz8VV6GfPBB/bKiWx+Q?=
 =?us-ascii?Q?ed7u5Z7+GiST8PmUxirYkkBKung6nd1RAQF/EYxVpp4hfvRMrUQhH8HtVyXs?=
 =?us-ascii?Q?VL+YOXlosq9AMYu4+Bsm/gRIVn0ADN0y44fn3gVT2zYwk0HPhI2BW1pGHw1Y?=
 =?us-ascii?Q?AAD78TWqyLGqVysznl6WEseWliSiJRVxWrRjxaM/O63/nApOSe3DH0+yrjw/?=
 =?us-ascii?Q?oePGhkDtoEh8jdjdFw5F+K871rjMheR5Y9J6lxe/mP/ABLqdQrRVm8j7196B?=
 =?us-ascii?Q?SvNWEs63Qnz5N8PZ+KpkJZ1yGbYsXZ6+5Iyl8a8pxIx9Q3F5OLWeymZD3xNI?=
 =?us-ascii?Q?9kZJD2Td3cug0WieZ3DynJB9CzvjMC0w+zuVUCjZs/wWrpeI1Aqr/dfQhyuX?=
 =?us-ascii?Q?X6nmXCa35ap2p/Cdy/wTdAMOapcYOWwkc/uFM/sO6TomyG5b9XzYX3EO7jas?=
 =?us-ascii?Q?23pcdg3ETmXpEAqx5qLy8si849MBQofi682iaGEA6auZgP8fqnWc02FWrjNI?=
 =?us-ascii?Q?uMy3OUq9oFjF8Km9ljuV1Pht2+adxp5H+GWmh61kDYaYM4r8DxhCE7w4meU+?=
 =?us-ascii?Q?kwcOw1EIMbWuIy/3s0J2inpjSZ9BitOSej7MEvgy/RWrHsAwfxUg+VpBw2th?=
 =?us-ascii?Q?9Qy5zhxBUM6+6lu5mlBkkmw/9VTQnzT356GaApe699zCfKMRTqb7ujcf9i6/?=
 =?us-ascii?Q?6FSnGWs0LhHBNG82ngvM59VNAZhAN4azLBy2hBE7UwU8PdNMZdn86a75zybz?=
 =?us-ascii?Q?TKcB14DzIcRf147m7HCJ8bGWPwh1d9ywrw9aC2gXqezbedq9NAV3B/ZOSUWB?=
 =?us-ascii?Q?WlHIAbQNwASZY0TkaD/Oh9bUhPpeekSpwH9kOZRZvKUpC/aq7sWaCcYHa5EV?=
 =?us-ascii?Q?1XBJyXwrq3xfetKqc1V8H+zWoJmKpGkU88yBAmhd+Jaa6vW4tEOWYhXOQyMk?=
 =?us-ascii?Q?G59Abgfc1a2liGhyfUlMVsxWlLyt6ZddyR4AAd6Z9/XCzRQYBfgiI4ZmUujP?=
 =?us-ascii?Q?1OKTjPnzDNGYM+KJEhjo3gGhCedsVr0/Zd8gU2f0dy2AooQrcp5Q7rOewt20?=
 =?us-ascii?Q?28Zzkt6tv2SrJiF4kJcqRUEZAJUi1CPW566oFFuhhWUW5WpoVrpiYTD2BawK?=
 =?us-ascii?Q?o6tE+Y5pfpwOJjqu5AUkWQ2bqtDE5S9Sz6r+GOHtgXkpmwwcU7+nB7Er608a?=
 =?us-ascii?Q?3EQDg3LaIGRAyRGaxvn/g2FDkxMAQqBAyo9WO7DGcHwFII9PTAPpqPnzumyc?=
 =?us-ascii?Q?nJjo0IvtxLBpD4VwpKMDhcL5S3KEO4SBUGKwkmMgDqv1MReDU/Lpx8AagAbX?=
 =?us-ascii?Q?2ALl7JojEi1l+hZrdrg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c99Tr2fJ+EhG9x9/IAnqbI8I/Si0EswozjDiRANITnJpQ5Eq0hUbLFwm3vL3?=
 =?us-ascii?Q?szWqQuXYZ0qJlCoFNC0SOuDJk9va/GmIEgDlrGYTENtAuMTPoreWDZWA1FAe?=
 =?us-ascii?Q?OJGk/lPbshpnnCGN9CgS+vrlhqCEOHN5nBQyVn/7HbnPhr3AtTfq5yEYwnaF?=
 =?us-ascii?Q?JD+6sDsgj+QXCz9VuZ8bQQdiRvFEVKXPVh168PS3fuagEt58udz8r6nRJuLl?=
 =?us-ascii?Q?dRpYJK3UePX2pyidKvlPWfRA4E+J/aOEMgbSp427Tg4gKTgHoHWiuY3jQfSy?=
 =?us-ascii?Q?rA/IdMHmH4A+QDOXcCSOxY7MDLu4lCjCFEItF9pHgRBNsKmTHQEiV7Vxm+Ek?=
 =?us-ascii?Q?M8l500DGSNawkowCfE+t1wwWMLLjNHMh7cpy4Vgjy9BfwGIBElBRKOj4Q2mV?=
 =?us-ascii?Q?uW0UhnqJ75wxboquGYLPIXfPJvPQrprTvrtCCFnp7cz9/W0I7uEozRTkRmXQ?=
 =?us-ascii?Q?lV9jTqc2tHez/RofDXDpeIpfVQxFclyg5ymKfp6YONP6eWAIAvM996QuV531?=
 =?us-ascii?Q?C3sOrk3rAp2cisQaASO9j+4CAHNhcaGrUaIFPxKDJIbrSAN92j1Wm1oDq0bu?=
 =?us-ascii?Q?5hxmHVyYXUUwAgSl4vSG/KuSqFIySxaa1aG/bFgb5qZlJia5U69PI4AgMkr3?=
 =?us-ascii?Q?sy6TWWpEpbEAi1LnewvS2AQ6G8lewJ42nu7Dw6Cv82TAy0G9otBcqI0GFG9d?=
 =?us-ascii?Q?vtmmfPXO06/zOfzPIhtIGGZ4N1iDy9E8kJBfI83pWumV59AkqZoHXCGDghed?=
 =?us-ascii?Q?Uaa+HCzZqyK8Y0DHpwpzwRPsWomYnbhRwFHDQx2EFqvpnrWauXdLd+5TceoE?=
 =?us-ascii?Q?KKsErGuiX2S6EPnNzxEUQChitnEoOHdaRAH6QS+ix48+hGBVzPEhjNgRfW2P?=
 =?us-ascii?Q?NX4w09OPV7VfviA8yZ02sdsDnoh5jdwsRteZpj+UrfWZFe8iaaAcC2NbfFIJ?=
 =?us-ascii?Q?4v59w3L5nVqF/ali9oMHr3e74yBumtIp9M6wL10dnOYoesbM1iaUjLIIXWp1?=
 =?us-ascii?Q?tszP0wwrv8GsmoPkwM5/OBySdEpUxX7vTwIe3zg9toBjX1/IcaB+nRMRMo3l?=
 =?us-ascii?Q?8nVx6/6vXzdyc5ZAhOV5oMppVr4yGgY+sVXv8vldF2Sj/1m9/Hd8Cq2BqECs?=
 =?us-ascii?Q?bIEKM06NMPJGIyWMVsVGQnNq2Y8xyT+gZfqulyLOhHQcCuFU/kZPgHtmLk6U?=
 =?us-ascii?Q?tk2+KWgNe+y3b0YxD3BNGjRQudWDHsFwYmgIWeCGeMe3MKFJYVxXmRLl5g9r?=
 =?us-ascii?Q?xI2ma5X1bTmkqGNc0k32S/Xqq8L/qRQMPvrdWXcSrnmL6jL1+z7I08rrb+UI?=
 =?us-ascii?Q?0bEnTTKXHkyYpu8ZbqkbeqKVTZxuBZqMjOEgvmIaqoUm/bAJd1kN2sLQnbb9?=
 =?us-ascii?Q?p0gfE8O5/icFYr9QkKNJiAcFe1WGQfiM94f2bAnl8s6M8Pc7od8grvd75f40?=
 =?us-ascii?Q?kar+bTL/bTxXUZQz8NEgd2n73ilWZKw3dKKYp0Qtfmv2+JjmiIvxw9i9Vkkm?=
 =?us-ascii?Q?gvroxq58bcQi3a203jARRu7oP3cogS3bvB9cGrFRXChoYBOMcIY1Q7WBIfpz?=
 =?us-ascii?Q?dfPHm0dbBGzX1W+VDuF9GjkF4edIdUE1mUVlpW87T8VwdSl81dQboftittn7?=
 =?us-ascii?Q?eyX/xUF4Lcpa5Kkj89rJkmcwMPBaCUK4SmJjHVe8+gJE0Pt5rpSKYPvO+NAW?=
 =?us-ascii?Q?N95RHlXKie6xrfmv9ZpUFxxVw0ZLwUEYQYAltBX/QwWHD6C9q1n2cfAfZ/yM?=
 =?us-ascii?Q?Ed0O8NgGmQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	A5RCPNjymWMvEqEzd/JuSZBvojy/u5BUli/egmQuDuF/3ph7FcvX/ZVk9vju8TPZnNzICxOm5cxim1SbUSMiNhQCnSBSs5IUcN2zhyExbPTgd8nBZCokrClJztRjiEFYlGZizqq/egbzpDYQGKfaTLcnho3Qm8ff8klTqGu+6uzwmFe05qF3VFbt7t2ldI/WKnhdIvF+dgab4obLff8LbtCjHkFpu86rzT/AzZZzAWCI7g4GpPpX3/+XK6mfwX4NZ/FYN9go1qUZZiVUdA92J+IwyFYD6xeLOosp3FcZlVsD1Dj+73WJ49CgHdM99MC/VmlpSSaWV4OxDIL/it/Jjk9N26KWVLe8v8MKYQMhbW1mfYfvPylVP0VuXKPue5QxSaHcoJLi/AIX5rXQ1Wla/guUw2VEtFePiBXvt9jaCWXYzxlIqwf+wTmswWl0Eq9Fa8BA73NEMckimGd5UxXmXNrJHFOYTznG6unh7SE0m48oAjCv4SGazrlHgjQE/6BytHCaNroE4F+x4O/MwsYRID8CRh98+EYMi+KCBl8hk3Hu5Rfjf0xJLt1cjkMaAo3F0AI8GGsx2z918opa+h/VjwZUtEr9PrTm4iVQN1fRhB0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9650efe6-7cfc-4dae-f8a1-08de67cd9346
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 11:22:57.3177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bi0RpghNJRovNHwHA5cVGqf9BCA18myzBktM06Q4olZtPsEvnT1WHv78JzcQ1AdfqbkKC59qIGbWUxobjT0txQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5666
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-08_05,2026-02-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=709 mlxscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602090095
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA5MDA5NSBTYWx0ZWRfX/GtJNwEvafw4
 B3YCa6hxDyen9Cfw0SMyHH+331i5BUwtw2muj60SVuO+LjkHFtQOJQF0y7Fz3Aa5nJPofFiu/8G
 3YKERNSA4iZbxMdD4rXjfcNhFWsBe3pTXAvKt0H/wKMmWPxZLSuLWcz4505+c6rpiYDmrkZ53ru
 ATX0pRzgTP7qz5/us/kM5wRGYmIDVuZKnKYf87i0EODe6740y8ZzVUHVekFhzyeS314S0Y3s9OD
 aaVkR6ma881UzstOSLnYqtrYTuJiwZdd2PBVrNxkaGWzCwr6ahx/b3gUav+mQiGzMsbUDisWXWF
 CuE/q3tfx8cZGr4/eUaQz9/J0lktSwmU5+hB+pfrL6D0cJB5lCIo7FyGW1e59h2kHcP9h39oLfr
 sQUpG0RH3Tn1yyYk9DqJWvxdapLDAIvAQ29zZiUgG675MotHblRZnHydi16NW9OVWq5y3jauUSM
 7qnezB63lD106cfXjbw==
X-Proofpoint-GUID: QZnjAyawfskoXB5P2axlxVlqD62nh9KW
X-Authority-Analysis: v=2.4 cv=V8xwEOni c=1 sm=1 tr=0 ts=6989c39f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=qzkADwgYXNuo5f0BM_cA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: QZnjAyawfskoXB5P2axlxVlqD62nh9KW
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 356C840006
X-Stat-Signature: fczi1t131uj3xsf6yroizjn3xb3537ti
X-Rspam-User: 
X-HE-Tag: 1770636221-453978
X-HE-Meta: U2FsdGVkX1/HwZaOgBNSla52XpGRP9H3yTWtH+jtABSvXQPksx2cF2X403HEWicQM7rFpsGpj5fAtkGr1OwI0KdfrWDW08yF1MoJMmTwqrYNfeUWN7BNIJ2GkGNAEbEiAwzmOk9/pvjDNJGUJbSa+vl0ullWf6NRovPdoOrMMd5Fdr6AzMaBw4bArbG/gTJhKSsjSB1Plhz9NHO/+BuNDkbbdOLub8KfHPsgUommlP1rghgFDHBRsCo0b5z3J1EBNUxbyHOlwymwLstEoviAD9EyG3URCjinRveMeJK89sPBU3ogadGeTpqAUZJfZB+3h3Z6phEsXeIzCXV6C7X5tHYO6XxWxIfjCHTBgdQ73rQFhSgc8ofL3/XULGNZ+DveInNFRAFrlhOxK51sszg9KvWQvNdmvexGC/4CXjkboQRI62KxYpDGOKEiSCysoFXfF39sozHkEeljY+AcMwLaXN8RyJ51SBdDvX4X7/kdnRxQszBpR2O3s9tiwyKEMSAC7Difeqs3bT4JofajexJ+YDeX4NdQ6lEV3x4KWZLI8Xe7rHUCDrNBzkCWhr5g6W4TssrD966lhuBqx0TRvdtDOG0MgO5ZT3qGVAKR8Lb3kOBVYpHE3RX27qZ6+KRZw7CzsgINq3ZH2tOSksODkwCEZR/nehDPmfw5Jlbq/nZJAmsJUocQYGnNJnhoqqtc+1gHPzcu0+s5PLdPkVV2QbBMLJDwl788zv0h9m6LBaEC4z24YAzUB1lHh7g9gl5wLtodwLBK/8SL7iNlU9OI3HIVfSOxVJJU2xyrbWlMc+yE9Kip5s4nVWsXOMM3CjWmqiuVy6xuKrrAkW3Gd+EFT5z2nD0uiiaT9KXZocL4KxaeBU5bKShjG9NGYqdWLiDKIUHB+gnn7m8PFEjccbYwgAJE8rCqJ1JO9dzFyRr0B4Kx/1bWBQ1o1dIyfMfdZlEUBAY7g1y36zqIV6B27JiSlhC
 FS2oP3To
 l3R63z56vSuosB8ls1rhUQh9L4Qq2qgIfjh9VYhHT7TGgXLLCwvDPyMVoM/Ga2ZgZHS1xToAYaF2GUiaREGqGit4u+OOBdV9EYJBKBynUE6Rm8b43oqaBhC0kpRVzvog0gQviBNFB0C/tCOZmLJLXjnmtmrA7yVD4eAIjexRS2Sy6DKMSVMAjkkgM9zx94MP/Qc4ZiYQJSHrV4F601b1qimuQwSj0foLnOjVULy5VKkRcDb8c1lAU2uOPRHk8h4ev0iRBA+v/xQSCWza3aWqoZWEhxV2VO+crKyyN7ovinFXCxU6uoBXRfJZ22QDI82JQpIra2lp9D/rP1ZPFvIzR3GPEgkWriUhxrATID9mQbOUbt6zoTSIgYxNWOSzdIbYBZXMZk1pxhc9/8MBVXGi1yBeOBuR7fFR2QX2hZ0G0E2Jm1TXqodvH+yq4+pVy8eGr0Awx8dPfwzm7qgEKh4SOtjPiBiBKRbguALklU8TnWrTXgyKkzYaYs84rYbW1Yjx7WxX35Pz+rARYFgp9v8vDv4hsf3iYGwdrEhifQ+TEMQWFbkjaF4ZuoSO3cJ2bD6s9tpVhzPt5IVWVqNycMP1wks9KUfoJd6iBAQ5Dxbxj9mrwYbuABDKc2DSUy2M4IiMi2+sGk02W0BE374N7E3oVRPuqUVyitYZZFvabC6a2XiX0ByrhK8At0EUMquNAKe5d+uW+oXCePYc5pTU0c4TqXL105hH05/YRE1y3He9ibgY32Uw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 11:41:17AM +0100, Uladzislau Rezki wrote:
> On Fri, Feb 06, 2026 at 06:34:05PM +0900, Harry Yoo wrote:
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 41dd01e8430c..89c781dcab58 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -2596,7 +2596,7 @@ struct vmap_block {
> >  	DECLARE_BITMAP(used_map, VMAP_BBMAP_BITS);
> >  	unsigned long dirty_min, dirty_max; /*< dirty range */
> >  	struct list_head free_list;
> > -	struct rcu_head rcu_head;
> > +	struct rcu_ptr rcu;
> >  	struct list_head purge;
> >  	unsigned int cpu;
> >  };
> >
> Why this change is needed?
> 
> If you want to save 8 bytes of vmap_block structure,

To be honest, because I didn't want to post a series with a feature
that has no users :)

The feature itself was requested by Alexei, because he doesn't
want to bump additional 8 bytes for each object in bpf side to use
kfree_rcu().

But not being familiar with kernel/bpf/,
I just added a few users in mm/ ;)

> then i do not see a big gain here.
> We do not have so many vmap_block objects.

But I agree that replacing existing users just because we can is not
an effective use of our time. I'll drop patch 2 in the next version
as it doesn't (or can't) demonstrate its benefit.

Are there any potential users that might benefit from this (other than bpf)?
don't know, but it will be interesting to explore.

> --
> Uladzislau Rezki

-- 
Cheers,
Harry / Hyeonggon

