Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72A3BCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 11:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D37B18E0020; Mon,  8 Sep 2025 07:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0EC78E0006; Mon,  8 Sep 2025 07:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD7478E0020; Mon,  8 Sep 2025 07:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A201F8E0006
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:20:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57C05BCDEF
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:20:11 +0000 (UTC)
X-FDA: 83865839022.14.7C878B0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2C02318000B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:20:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cciIflvk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=i8owcA8y;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757330408; a=rsa-sha256;
	cv=pass;
	b=krscQtykLKl/xq9MZvUVfsNsLBgKrehrr7MENLxBcexWc3ZV6eBeHTTvmAcjCzFO72SWg7
	/zXReV/eFTF8N0Ry/ABWDJDauqnwGk7TDs89P4eGTENe0sD43C5bA2lXwId/4+3IHRw5GG
	gC2jrAWljuu2ORaTbRZ/luTeeHpzwFc=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cciIflvk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=i8owcA8y;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757330408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WyUPf3y3o527W6X0OQ7xXD5/7cvQ0lNTXllgKcs9NzQ=;
	b=yAf4LpFbUYEM2WW6hhqpokgNHYuTGAzoLDxHHj2cwGAlkawaJC6Tq/IJWiNKbJNVPZllO6
	2dnrSaN6QqZn7LL+ytUfaPxgcXxBSwQidqA0fWmxQaG7nWnkdCAG42PsmghjuvL4sbJx7g
	eB88KToGPSeOyauSg2T7hDfp4neB7js=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588At1mV014225;
	Mon, 8 Sep 2025 11:20:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WyUPf3y3o527W6X0OQ
	7xXD5/7cvQ0lNTXllgKcs9NzQ=; b=cciIflvkZ4+iFYfuN0XgwaeaxOY/hcTMv4
	zpN8UdwgsSrT0b1qvOIgjIYmmtVz5NM3OE0bUDyTUQpd66Ffnkt1tnDv9/1Bw74E
	wsOv0ocw1joMYAW/oefURRXNYxxGZYmLfxiAxBmGfKVZfj377bCbymwHdF4e5nZn
	Zes29zzKCfmL1/lfI/jZkWj7YkSj8rdeEmEZs6+Ys2fI1I3VpFECrFdvWf4IUjzX
	dx/c4sg+OX+d1K/PVkAYn8fHFBaW/ayOCl4SInIKotLFNKGfuqITtOgdyI4q7h8G
	5E3H9mwEsxPkq03yqhV1PH0s05ibssusAhSus0lpfI6+Jc0HpPfg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 491wt5g1e0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 11:20:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588B3sH7002867;
	Mon, 8 Sep 2025 11:20:04 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2085.outbound.protection.outlook.com [40.107.212.85])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdej7vd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 11:20:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M1lXpl71CqMNN6Dk7m7ZXIMqxcotkpqJh7YT1r6ZZzllpsXjHZvlomF7RKW6GvTkeb8k98Q8vqerAlvAaQp74KEdezsCsLtTvUzTuA+1xiRV6PHHfM4pHa6ttOYcmZ+ZF8fcA+1mUK7g5y+eif0GfQWqTtRTtJTMQoA/JADHu4bK2M4bObBVFco+zMyo2D7TuXFiycs2ScC1pQhh78xy+uzW66hSEeKW+jNkhsHGr9lmXaBd0wRR6t7bRiXEPu+OnCzoM2L/lLmnXINXRtIALDeF8KakP9AW+cmIamPu4Y1InXfWm9McA6Kz+rc6s1ZZf4BVA/Jp2UoJSCNnCxJcmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WyUPf3y3o527W6X0OQ7xXD5/7cvQ0lNTXllgKcs9NzQ=;
 b=metsuTa/z6M3SDud5niEhknbotBYebhsODyCRaxnuyuv8f7cyvrNtY1GJBORXjhdlp535ISk8ijZWlJZH+RlZXMHJIIx9Wqxe3jzEy2Zo/HfqhLuCKvZm5Bf9y/aNuhrteKonwA1VS1kOXI4qmqVyiLTLH8ZbGVALuEyFPDcE/CRp6S75CmVM8b93Ewspode3XvoIhYpqPDN3dvLfwI7FSuDMpRf/Cqd68upAP7gnE3PNVZLsD+P5kFru2gYEszuvCqwraRWIV6Ex2RJ8kXNzeOXHIc0+KjgIx2hzngt0szJTMi6dX2WSGVbhy6zfy92/TJPvho9kwYsg4vW91hHhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WyUPf3y3o527W6X0OQ7xXD5/7cvQ0lNTXllgKcs9NzQ=;
 b=i8owcA8y34dRTZOpcEnh/9a+I5kXpm7tY2jII1Uzvj6jlUUBvSMOTKZI6mKWB4TGl0Jc3D6Wz+n0DyBKynaVm/r6jvCApl6Hyu0xC0KWAHzode9RuI+Q5gQQVlv0/hDxOfCMG9so/QAHFehICgnarOQdL+BaifPpBmTmhBkLj/0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA4PR10MB8399.namprd10.prod.outlook.com (2603:10b6:208:56b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Mon, 8 Sep
 2025 11:20:02 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 11:20:01 +0000
Date: Mon, 8 Sep 2025 20:19:52 +0900
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
        maple-tree@lists.infradead.org,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: [PATCH v7 03/21] slab: add opt-in caching layer of percpu sheaves
Message-ID: <aL672Jeqi99atefN@hyeyoo>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
 <20250903-slub-percpu-caches-v7-3-71c114cdefef@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903-slub-percpu-caches-v7-3-71c114cdefef@suse.cz>
X-ClientProxiedBy: SEWP216CA0013.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b4::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA4PR10MB8399:EE_
X-MS-Office365-Filtering-Correlation-Id: e6aa188c-3e06-4c0f-a6c9-08ddeec9a71c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?96+Ma54dxv/O5eZmgQDyeTHyjK35TAx1fLwyqX22d+abinFMQbbLahCq5Wyn?=
 =?us-ascii?Q?nqVekemEXEUxNC9K4ejRyFk2HOMp36Eyiubn9pOMZZJ+jGAs6F8o4RQ3SN4/?=
 =?us-ascii?Q?1IBNr8hJ7TNVB+9giMbMnfS583xwIdtcfUtk3h0lHdDX0b9cpX6NKBlljOJz?=
 =?us-ascii?Q?sZM2ghAT++gXM/YWEJaHFNMt9H651Aw3zkykYAjh8rhqC5o+yc4jRoVcnLdU?=
 =?us-ascii?Q?xCH4nDOlwzNM+8VQbDwwM6r48pCVchG8DqBTeV8nQ3JdcZ/UImByZYrkzUFz?=
 =?us-ascii?Q?r6I3Se/T2AQ2ydXLuXztA9WvlbyqZ5P1W+rXqLGvtCob+PCQVRdNisqDvEpt?=
 =?us-ascii?Q?SQNBMHLHgr5n11i8/qb49qspR4Fzw4WgaGl1kK/RLeMyiiiMLE8Mgq8Lll7e?=
 =?us-ascii?Q?mF5oGBJpC+CyFWv/4zE+WNHpHP2MoiQ3FBFISmH3XvT2hCPnqeAzFSbHED9m?=
 =?us-ascii?Q?x3oQz9N76JXk5aKzfXer1nSwx7uUXTbBpXcotogtdhVtdRV/FH4TluB0MHuk?=
 =?us-ascii?Q?g3gGiKyPBE3coOo+fyCVoFMUAKHlL+bIC3VynvvTvvco/r5OUPZM43onAU0t?=
 =?us-ascii?Q?++9pD1IGsEnUb5vOigXf2QdNutcJj5/dEkm0E+9aKZMPFqAqv8cAG5cs84bQ?=
 =?us-ascii?Q?OQSXl04XU0yZk8M6SMyi/xash8Nks7tMxnYb0Y6hlQFyTi//kd9BxGkyWgCj?=
 =?us-ascii?Q?E3J60TKEk9SMdxN5DenCaKZyVUA/5IZOehARe3/hdzb+UXGmU9ZCnUdp1dFG?=
 =?us-ascii?Q?1/V0HT0Ti93BWqXmCHuES5jtzHu03Lmz6dJalsgCD9/mf+X2p8+yczB/pUZ3?=
 =?us-ascii?Q?sK5dW565cUHBWgk5I5QebaeZN2BUgfc0pPTOm40rhCVGzBo6GrbVsvq2PUr6?=
 =?us-ascii?Q?Xe5jrnPK6ivHYpxibwoOK8kmie0nxr9Jq+eagwqSdnv6/W2IyGTzcNrOH3qG?=
 =?us-ascii?Q?24IG/henriLtKV33rt4crksjpn9pgMQuFKLoCykIh10faKSvjQQjswoSh5V/?=
 =?us-ascii?Q?cXAj6f8guMh/QJnBOG/53HGw8PhibHeBuGlBYWbJBSe6RDNHjKJgB9mCpzMv?=
 =?us-ascii?Q?5rIUpThOeswHLDLh8PpklVzUr3B893zSLXlznQk1thbGZvi1tqgerEOA8HAZ?=
 =?us-ascii?Q?CFK63jXXy1q/eB1oJqh1fUF8iltsSHMrJSgb2rgRBkrvFHldIxfA00ftRm6y?=
 =?us-ascii?Q?fvWWcdNJUuYodSKJePqpfBTun75TAehF0psX5GR0vC3q3ls4IjOBqI05EHXM?=
 =?us-ascii?Q?halFeVfR+skIu7akr0zWSIjdFAqhxgs4X58eRhso3nax2duyKx3eIXYN6pah?=
 =?us-ascii?Q?SJPDGk1FmgGHwluvHbg3eZMcgdIA+FF9xRpA11+SfbaJmh7IpC/snm6IPTjh?=
 =?us-ascii?Q?WKl20p3I1wTKpieZsf0yym1bR/FlUmMt7LK832WusBaCnFS12j4K+lUQ2G0n?=
 =?us-ascii?Q?5eI4xxZOtx8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ri54BVVzTLuIO08i5UEdDYPZqJ5RjOuGTPc5K43JYxA/PoWCp/NEPlc1Yf+Y?=
 =?us-ascii?Q?9zj1aZzq4phTfUXoZCGY46K5jmWkTrC4w0/wH3ywi/ZGZBii45rMWbYGtHK+?=
 =?us-ascii?Q?ZBluhXjId8XLkJEqDaGpwv/TVNPDnOqltQtzmRxf64FbPFd4FsoXJQxTOJOG?=
 =?us-ascii?Q?kIHQYABcCNfoY26mzPl1fNZ/KApVKICP+b59DBbwMk8l6kMJMVFoQ7sRaMQ/?=
 =?us-ascii?Q?zlyPUVfhgwsswYP+N1USGMngdME1RdrbV9JtXRBzBqkRk5KDvEm3xweM9YG2?=
 =?us-ascii?Q?465VHkO8U7fTXCgELl7exFG3I8pxp2jV1RXaZwf5FT35z9jSH5CPmQpqEOMt?=
 =?us-ascii?Q?H5oCTZjdNmAN61EWI8xzy9xPO4lrx0t6n05DZg4MD2YxBiQH5Zz0zjTOnmAJ?=
 =?us-ascii?Q?4dGAuZiML76TH2WsXhy3R3Vu5XXy/2ygrSZgLv1f+PGiinduMMoK+z74SSz8?=
 =?us-ascii?Q?vb2x6cTd7QxzfGPRe/ZD0ai7awIvwF1Pp11ylQ+l9gj9xrfOEnQBLCZmxAtu?=
 =?us-ascii?Q?3QR+bdAa/03DY9fO9yyL4BSDUGoGLMX/6pfyRTevIcKw8iDrm3WbEtisz4BE?=
 =?us-ascii?Q?HNEnyGLATQ2V8HL+xncN1uIrB1zGuyvb1cPMgWDk6yUUO1qVIlN3XQhw7TDs?=
 =?us-ascii?Q?vUDCcl05IvxJDx2YKTD34SP8pv95bO682ZdY07XpsmGXgFpGTK08yp1tj5lp?=
 =?us-ascii?Q?+YfBi8Taq9LYku1cc4JmvLaYDyhCABMmN+Vkogx2dPsUPV7MW2SL43mBkk4Y?=
 =?us-ascii?Q?iM6oimDjI7W7RuOVyGkpRsKvrlJBcPc+qkNF4844cNDOstgdhWjDew1itobb?=
 =?us-ascii?Q?AWOr1FuHR62wTEeu8G7gAK3YkGmRfqTAdHPUUXj3ABzqdBGJWaHlPaI4ZMA6?=
 =?us-ascii?Q?jXiEkqrVasr7Xznwq4wnPxGvI13VAtlYN+GLosb2aI6Kf+R1CcrRPFEhwJIr?=
 =?us-ascii?Q?Yc9DtRy4AD3wArJubTmzD9Zob80HtuX7J8pHf5k+K3mlE5he/n3/nNAOEMou?=
 =?us-ascii?Q?enLbHrnHT4NYqj2dG88WyCA/kizoCJGM9htGpTwah9JZQMylkAfOBoSUuxjL?=
 =?us-ascii?Q?Pr4FGLmUsvO+QGfmIyud0HJgeXjN286zypLZ9buDVVIX5pk9iXsPiOhyVfJi?=
 =?us-ascii?Q?bRLPoBsjfv/HV3BIyRt5Xlx7AgrUHupei4ze6lmR0Jnas6HkKlB88Xzva5pj?=
 =?us-ascii?Q?WwSLyGb/XGZHHHF5Xme89fK3Qdt2J03UlHwrgQO86xxleUc5D86Zpnbk2EMH?=
 =?us-ascii?Q?A9abUyAm9W3v3lkkdtzm0n5XLftSDxgFL7cGSVkVJADY1+iTJDyLDoaEklK/?=
 =?us-ascii?Q?oFRRx5F7XBinEKZGN4gsrqlFVvddIHqkXEvzLJ/hmd3tuFGRGny068wIZ8SR?=
 =?us-ascii?Q?WSfs8APl8au9k3t/Pwk6U05+y0FB/XtjVKdg9KEO7J1v3VI4V15NuCrDmUBj?=
 =?us-ascii?Q?N900DH9RsEtsYvkShA7KoIlYfbIWyrwUVpBQ6768BMKVhNe4Gav7/+fpK2SS?=
 =?us-ascii?Q?IZSdyZCDCW0Lr0kgNo3CP6DP+JRw4qtmJzaBhGCjYhhn3xGYzAIqyeea69VN?=
 =?us-ascii?Q?eu4PAstx9Io1YearVpPNqu2TGrDsAHd8syyChM0N?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	meDWl4Th7tzcPv8RUfUkF/AaCYylBY0EymRK55ozfmq+Bhdfan1zgSi9Tz+liAfLYcCksU7/epoEsgDs1TZ3SLVNJw1RhvAIBRuA9FkRuZ1YD5tEZeRmxfsu09khLWXU+KeaZ8uqcGcNOk0YOlvo9lwlN+P+sxveGsCENWY6DvLzt0t4U0jdvmztMpk/fVYFA2bVRzGvbzlvfL0P0TdMGGGG9URs206BRq7iCXNjPzdRkIZ8fkjJKl/EWFiPoehQDjYbj/z5F1MiqRMICbFzfG8jOPHpI/e35U53DIizM6KSwqH324IiHq+mVTZ7wRFlzKacJgf5isYDWdKi/t1040V/DVbBwPhv11CoWHuHHdi+v4ga13hdi8L6rcw5ZnsMCDM/TMy9K5d0jJxGHh8kYjfIjfVniy2Kzmd9GuBWoa14+2KRsubyH8ePWyKf1yfCCPtgZm8fYbEaEO1Vkg+IAgOac6hl3C1MkQVrDKOUYZCcRrBSuzSlqoTRs5sd9OAUZq/Jva9k97nJLMTcGgH5R1EAWKrMYWG2i7Zf3yZnMwo57AfLzOW0hn9RNEqnMOSyO0i0ACsPlvvNjlu60/4ny8j7IlvHqNaQYngRuqUpEVc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6aa188c-3e06-4c0f-a6c9-08ddeec9a71c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 11:20:01.8686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oJMj2zwSlodUG7UF/GEH2S4JY0Wc1Z6y747rvPwwKgxooNK+Hu9Ex52HFvz2BzedApS/ByrzcqWvuJYxIh/DJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8399
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_04,2025-09-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509080114
X-Authority-Analysis: v=2.4 cv=ON0n3TaB c=1 sm=1 tr=0 ts=68bebbe4 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=Pb0I1wAkO33HJiYsQRQA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12069
X-Proofpoint-ORIG-GUID: Wqaw5nuxubryzX4D7KkPIgP4-35MbCcX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDExMSBTYWx0ZWRfX5TVh5DNAN/au
 Im1QCtBYKXwdp0k3ub5NJrkHZTQBZGMcqg78Og9CxZH4rN69C7LgF7kMUYIoR3ReoiX7Zb/G5ta
 WqVUTcvkAwSBACGudYTp6yOOP3QPfOkMjfwPYyX67B76Suisjs1ZvzHRv49DE15hkGwIB+Y684V
 jY4gCJVbUG55rrx94YsmNWHzqfg3JQAqIG/cMt1AZ1JPyFvrIq4YArQtZP38aGDXbuQ7Sd8+wCn
 LCqLzruDt6SLdMNOVa3pV2mN0bHitQMPXZkfW5qSxVg/C422vfYx78x80+aANHDuG75eXjjJ/XE
 qdfjcA4rLohVhSLCZwrByJV0dHPxAZSLzBShkQp9GZQZl9EDHKtrDyloACrsjfGOP3UPy7OiNtf
 tRLilH5Bmn+n9dVoeys/5LhVQpZNyQ==
X-Proofpoint-GUID: Wqaw5nuxubryzX4D7KkPIgP4-35MbCcX
X-Rspamd-Queue-Id: 2C02318000B
X-Stat-Signature: dn8aykrmigyf8ssw5squiiqaja5cspgx
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757330408-33224
X-HE-Meta: U2FsdGVkX18D0SzfOq0yYgywkOEXE8O62FnkgvjNuunYv9A9IEhEhiOutqUPlKroo7A8FZlInvbiAsRnZN7Z3rICz5PuGaqx0GjaW+FJoMgD4lNPlI0tReRQeNMdRhk+tjrztioPk4mxpyAY848zKGXmjt8GPok89Xfvppy/1sBPz8JLAjaaWMg4ZisTUY2JNVDjjUkK+WngboMNo2ANGPi7fr2S7KUidExy88OjCpUYAowi40+fBkBNt9S41nXkcZlVzDiF7KZz12qdThK5R9PrwbppqM2flRq5Yy6HMbL6sJLctbmeEJNOtJRzAs9FhWWqKvMQi5rYLLXdEe1wXvef6PxcS10kU7H3zYcx4kkW01ulaJRtg4JPcpXbKBVhp7S2rUK20Bkir38Yd4/6FQ37+jeyqksbx6LcvPpSO3CZoLGftx7nTin9wkhYz+QJ4bELUqmWVMUSgnuznUEvnrOom1MBnoH1wUPcx76N58w2CxX2IzLar9tGTjMAnssdwS9ZuFwCbE4SFg1xBv6uCl6apw5F89wK0M7lWwvdFWw8H/3fskiGuMLAQOC2ard3XPgltqZ/g0Bw5Mvl7m/xWgjCshjIHJE2IXEK5V7mE1DOQDAdSFmF2OqvLit4t/fn20zxtJxwgZb7oBjTQdsIpLYI7RK4th6nUjdSCxDo++PQpTfbpkJvhXr1YZGbXc1EnrGgp5UPq5PiEvZ//j0EEDQcAthedxzfTysmuRejvYy5VwNTcVmzQd7IpA5VW3ugtGmoy+nwTxribjkQi4JrEVbGWcgWrN/FK0yufc5v3p1j5kLupOS6hqhDrkGkfYpJbUXz6OxHeLjvdHp2JvrGeKZ51ChtkKOjXB5hFug4FmhdIHV3ahpGm7CsQeI+0YHJxsV1zLQ5eeOfnNrQIa6vHhYjkC/57WNHrIJqvS6lT/Yt6Jf7xbHzt4Yp/K/ya61DL0GcQBj35g+kX28mZva
 0bXaNy9b
 RTIraAaCEWqfN826bo9LHjxPatEAz825jIyI7WsSP5awpH5+2UTxCYgaLuFNvZvVm6Wv/GDEiOXlzAl0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 02:59:45PM +0200, Vlastimil Babka wrote:
> Specifying a non-zero value for a new struct kmem_cache_args field
> sheaf_capacity will setup a caching layer of percpu arrays called
> sheaves of given capacity for the created cache.
> 
> Allocations from the cache will allocate via the percpu sheaves (main or
> spare) as long as they have no NUMA node preference. Frees will also
> put the object back into one of the sheaves.
> 
> When both percpu sheaves are found empty during an allocation, an empty
> sheaf may be replaced with a full one from the per-node barn. If none
> are available and the allocation is allowed to block, an empty sheaf is
> refilled from slab(s) by an internal bulk alloc operation. When both
> percpu sheaves are full during freeing, the barn can replace a full one
> with an empty one, unless over a full sheaves limit. In that case a
> sheaf is flushed to slab(s) by an internal bulk free operation. Flushing
> sheaves and barns is also wired to the existing cpu flushing and cache
> shrinking operations.
> 
> The sheaves do not distinguish NUMA locality of the cached objects. If
> an allocation is requested with kmem_cache_alloc_node() (or a mempolicy
> with strict_numa mode enabled) with a specific node (not NUMA_NO_NODE),
> the sheaves are bypassed.
> 
> The bulk operations exposed to slab users also try to utilize the
> sheaves as long as the necessary (full or empty) sheaves are available
> on the cpu or in the barn. Once depleted, they will fallback to bulk
> alloc/free to slabs directly to avoid double copying.
> 
> The sheaf_capacity value is exported in sysfs for observability.
> 
> Sysfs CONFIG_SLUB_STATS counters alloc_cpu_sheaf and free_cpu_sheaf
> count objects allocated or freed using the sheaves (and thus not
> counting towards the other alloc/free path counters). Counters
> sheaf_refill and sheaf_flush count objects filled or flushed from or to
> slab pages, and can be used to assess how effective the caching is. The
> refill and flush operations will also count towards the usual
> alloc_fastpath/slowpath, free_fastpath/slowpath and other counters for
> the backing slabs.  For barn operations, barn_get and barn_put count how
> many full sheaves were get from or put to the barn, the _fail variants
> count how many such requests could not be satisfied mainly  because the
> barn was either empty or full. While the barn also holds empty sheaves
> to make some operations easier, these are not as critical to mandate own
> counters.  Finally, there are sheaf_alloc/sheaf_free counters.
> 
> Access to the percpu sheaves is protected by local_trylock() when
> potential callers include irq context, and local_lock() otherwise (such
> as when we already know the gfp flags allow blocking). The trylock
> failures should be rare and we can easily fallback. Each per-NUMA-node
> barn has a spin_lock.
> 
> When slub_debug is enabled for a cache with sheaf_capacity also
> specified, the latter is ignored so that allocations and frees reach the
> slow path where debugging hooks are processed. Similarly, we ignore it
> with CONFIG_SLUB_TINY which prefers low memory usage to performance.
> 
> [boot failure: https://lore.kernel.org/all/583eacf5-c971-451a-9f76-fed0e341b815@linux.ibm.com/ ]
> Reported-and-tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  include/linux/slab.h |   31 ++
>  mm/slab.h            |    2 +
>  mm/slab_common.c     |    5 +-
>  mm/slub.c            | 1164 +++++++++++++++++++++++++++++++++++++++++++++++---
>  4 files changed, 1143 insertions(+), 59 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index bfe7c40eeee1a01c175766935c1e3c0304434a53..e2b197e47866c30acdbd1fee4159f262a751c5a7 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -163,6 +163,9 @@ int slab_unmergeable(struct kmem_cache *s)
>  		return 1;
>  #endif
>  
> +	if (s->cpu_sheaves)
> +		return 1;
> +
>  	/*
>  	 * We may have set a slab to be unmergeable during bootstrap.
>  	 */
> @@ -321,7 +324,7 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
>  		    object_size - args->usersize < args->useroffset))
>  		args->usersize = args->useroffset = 0;
>  
> -	if (!args->usersize)
> +	if (!args->usersize && !args->sheaf_capacity)
>  		s = __kmem_cache_alias(name, object_size, args->align, flags,
>  				       args->ctor);

Can we merge caches that use sheaves in the future if the capacity
is the same, or are there any restrictions for merging that I overlooked?

>  /*
>   * Slab allocation and freeing
>   */
> @@ -3344,11 +3748,42 @@ static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu)
>  	put_partials_cpu(s, c);
>  }
>  
> -struct slub_flush_work {
> -	struct work_struct work;
> -	struct kmem_cache *s;
> -	bool skip;
> -};
> +static inline void flush_this_cpu_slab(struct kmem_cache *s)
> +{
> +	struct kmem_cache_cpu *c = this_cpu_ptr(s->cpu_slab);
> +
> +	if (c->slab)
> +		flush_slab(s, c);
> +
> +	put_partials(s);
> +}
> +
> +static bool has_cpu_slab(int cpu, struct kmem_cache *s)
> +{
> +	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
> +
> +	return c->slab || slub_percpu_partial(c);
> +}
> +
> +#else /* CONFIG_SLUB_TINY */
> +static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu) { }
> +static inline bool has_cpu_slab(int cpu, struct kmem_cache *s) { return false; }
> +static inline void flush_this_cpu_slab(struct kmem_cache *s) { }
> +#endif /* CONFIG_SLUB_TINY */
> +
> +static bool has_pcs_used(int cpu, struct kmem_cache *s)
> +{
> +	struct slub_percpu_sheaves *pcs;
> +
> +	if (!s->cpu_sheaves)
> +		return false;
> +
> +	pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
> +
> +	return (pcs->spare || pcs->main->size);
> +}
> +
> +static void pcs_flush_all(struct kmem_cache *s);

nit: we don't need these functions to flush sheaves if SLUB_TINY=y
as we don't create sheaves for SLUB_TINY anymore?

>  /*
>   * Flush cpu slab.
> @@ -3358,30 +3793,18 @@ struct slub_flush_work {
>  static void flush_cpu_slab(struct work_struct *w)
>  {
>  	struct kmem_cache *s;
> -	struct kmem_cache_cpu *c;
>  	struct slub_flush_work *sfw;
>  
>  	sfw = container_of(w, struct slub_flush_work, work);
>  
>  	s = sfw->s;
> -	c = this_cpu_ptr(s->cpu_slab);
> -
> -	if (c->slab)
> -		flush_slab(s, c);
> -
> -	put_partials(s);
> -}
>  
> -static bool has_cpu_slab(int cpu, struct kmem_cache *s)
> -{
> -	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
> +	if (s->cpu_sheaves)
> +		pcs_flush_all(s);
>  
> -	return c->slab || slub_percpu_partial(c);
> +	flush_this_cpu_slab(s);
>  } 
> -#else /* CONFIG_SLUB_TINY */
> -static inline void flush_all_cpus_locked(struct kmem_cache *s) { }
> -static inline void flush_all(struct kmem_cache *s) { }
> -static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu) { }
> -static inline int slub_cpu_dead(unsigned int cpu) { return 0; }
> -#endif /* CONFIG_SLUB_TINY */
> -
>  /*
>   * Check if the objects in a per cpu structure fit numa
>   * locality expectations.
> @@ -4191,30 +4610,240 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>  }
>  
>  /*
> - * Inlined fastpath so that allocation functions (kmalloc, kmem_cache_alloc)
> - * have the fastpath folded into their functions. So no function call
> - * overhead for requests that can be satisfied on the fastpath.
> - *
> - * The fastpath works by first checking if the lockless freelist can be used.
> - * If not then __slab_alloc is called for slow processing.
> + * Replace the empty main sheaf with a (at least partially) full sheaf.
>   *
> - * Otherwise we can simply pick the next object from the lockless free list.
> + * Must be called with the cpu_sheaves local lock locked. If successful, returns
> + * the pcs pointer and the local lock locked (possibly on a different cpu than
> + * initially called). If not successful, returns NULL and the local lock
> + * unlocked.
>   */
> -static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list_lru *lru,
> -		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
> +static struct slub_percpu_sheaves *
> +__pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs, gfp_t gfp)
>  {
> -	void *object;
> -	bool init = false;
> +	struct slab_sheaf *empty = NULL;
> +	struct slab_sheaf *full;
> +	struct node_barn *barn;
> +	bool can_alloc;
>  
> -	s = slab_pre_alloc_hook(s, gfpflags);
> -	if (unlikely(!s))
> +	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
> +
> +	if (pcs->spare && pcs->spare->size > 0) {
> +		swap(pcs->main, pcs->spare);
> +		return pcs;
> +	}
> +
> +	barn = get_barn(s);
> +
> +	full = barn_replace_empty_sheaf(barn, pcs->main);
> +
> +	if (full) {
> +		stat(s, BARN_GET);
> +		pcs->main = full;
> +		return pcs;
> +	}
> +
> +	stat(s, BARN_GET_FAIL);
> +
> +	can_alloc = gfpflags_allow_blocking(gfp);
> +
> +	if (can_alloc) {
> +		if (pcs->spare) {
> +			empty = pcs->spare;
> +			pcs->spare = NULL;
> +		} else {
> +			empty = barn_get_empty_sheaf(barn);
> +		}
> +	}
> +
> +	local_unlock(&s->cpu_sheaves->lock);
> +
> +	if (!can_alloc)
> +		return NULL;
> +
> +	if (empty) {
> +		if (!refill_sheaf(s, empty, gfp)) {
> +			full = empty;
> +		} else {
> +			/*
> +			 * we must be very low on memory so don't bother
> +			 * with the barn
> +			 */
> +			free_empty_sheaf(s, empty);
> +		}
> +	} else {
> +		full = alloc_full_sheaf(s, gfp);
> +	}
> +
> +	if (!full)
> +		return NULL;
> +
> +	/*
> +	 * we can reach here only when gfpflags_allow_blocking
> +	 * so this must not be an irq
> +	 */
> +	local_lock(&s->cpu_sheaves->lock);
> +	pcs = this_cpu_ptr(s->cpu_sheaves);
> +
> +	/*
> +	 * If we are returning empty sheaf, we either got it from the
> +	 * barn or had to allocate one. If we are returning a full
> +	 * sheaf, it's due to racing or being migrated to a different
> +	 * cpu. Breaching the barn's sheaf limits should be thus rare
> +	 * enough so just ignore them to simplify the recovery.
> +	 */
> +
> +	if (pcs->main->size == 0) {
> +		barn_put_empty_sheaf(barn, pcs->main);

It should be very rare but it should do
barn = get_barn(s); again after taking s->cpu_sheaves->lock?

> +		pcs->main = full;
> +		return pcs;
> +	}
> +
> +	if (!pcs->spare) {
> +		pcs->spare = full;
> +		return pcs;
> +	}
> +
> +	if (pcs->spare->size == 0) {
> +		barn_put_empty_sheaf(barn, pcs->spare);
> +		pcs->spare = full;
> +		return pcs;
> +	}
> +
> +	barn_put_full_sheaf(barn, full);
> +	stat(s, BARN_PUT);
> +
> +	return pcs;
> +}
> @@ -4591,6 +5220,295 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
>  	discard_slab(s, slab);
>  }
>  
> +/*
> + * Replace the full main sheaf with a (at least partially) empty sheaf.
> + *
> + * Must be called with the cpu_sheaves local lock locked. If successful, returns
> + * the pcs pointer and the local lock locked (possibly on a different cpu than
> + * initially called). If not successful, returns NULL and the local lock
> + * unlocked.
> + */
> +static struct slub_percpu_sheaves *
> +__pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
> +{
> +	struct slab_sheaf *empty;
> +	struct node_barn *barn;
> +	bool put_fail;
> +
> +restart:
> +	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
> +
> +	barn = get_barn(s);
> +	put_fail = false;
> +
> +	if (!pcs->spare) {
> +		empty = barn_get_empty_sheaf(barn);
> +		if (empty) {
> +			pcs->spare = pcs->main;
> +			pcs->main = empty;
> +			return pcs;
> +		}
> +		goto alloc_empty;
> +	}
> +
> +	if (pcs->spare->size < s->sheaf_capacity) {
> +		swap(pcs->main, pcs->spare);
> +		return pcs;
> +	}
> +
> +	empty = barn_replace_full_sheaf(barn, pcs->main);
> +
> +	if (!IS_ERR(empty)) {
> +		stat(s, BARN_PUT);
> +		pcs->main = empty;
> +		return pcs;
> +	}
> +
> +	if (PTR_ERR(empty) == -E2BIG) {
> +		/* Since we got here, spare exists and is full */
> +		struct slab_sheaf *to_flush = pcs->spare;
> +
> +		stat(s, BARN_PUT_FAIL);
> +
> +		pcs->spare = NULL;
> +		local_unlock(&s->cpu_sheaves->lock);
> +
> +		sheaf_flush_unused(s, to_flush);
> +		empty = to_flush;
> +		goto got_empty;
> +	}
> +
> +	/*
> +	 * We could not replace full sheaf because barn had no empty
> +	 * sheaves. We can still allocate it and put the full sheaf in
> +	 * __pcs_install_empty_sheaf(), but if we fail to allocate it,
> +	 * make sure to count the fail.
> +	 */
> +	put_fail = true;
> +
> +alloc_empty:
> +	local_unlock(&s->cpu_sheaves->lock);
> +
> +	empty = alloc_empty_sheaf(s, GFP_NOWAIT);
> +	if (empty)
> +		goto got_empty;
> +
> +	if (put_fail)
> +		 stat(s, BARN_PUT_FAIL);
> +
> +	if (!sheaf_flush_main(s))
> +		return NULL;
> +
> +	if (!local_trylock(&s->cpu_sheaves->lock))
> +		return NULL;
> +
> +	pcs = this_cpu_ptr(s->cpu_sheaves);
> +
> +	/*
> +	 * we flushed the main sheaf so it should be empty now,
> +	 * but in case we got preempted or migrated, we need to
> +	 * check again
> +	 */
> +	if (pcs->main->size == s->sheaf_capacity)
> +		goto restart;
> +
> +	return pcs;
> +
> +got_empty:
> +	if (!local_trylock(&s->cpu_sheaves->lock)) {
> +		barn_put_empty_sheaf(barn, empty);

Same here, we might have gotten migrated to a different node.

> +		return NULL;
> +	}
> +
> +	pcs = this_cpu_ptr(s->cpu_sheaves);
> +	__pcs_install_empty_sheaf(s, pcs, empty);
> +
> +	return pcs;
> +}

Otherwise looks good to me!

-- 
Cheers,
Harry / Hyeonggon

