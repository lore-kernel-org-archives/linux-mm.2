Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB5FCE94619
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 04:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 304556B0088; Mon,  9 Feb 2026 23:47:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4346B0089; Mon,  9 Feb 2026 23:47:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E696B008A; Mon,  9 Feb 2026 23:47:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 05CEE6B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 23:47:17 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C71621A0321
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:47:16 +0000 (UTC)
X-FDA: 84427312872.28.E3118C9
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5F17D4000E
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:47:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qmA22s2b;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qKWivyyK;
	spf=pass (imf27.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770698833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=j/5vScUga2d1E3RGvvNsWv2C8iuEZEMEVD0W1aS30L4=;
	b=BEZj4Z+uS9Kq1jbq/3eiBwzorSh94ZYapz92BadY/zWvFMs9vP0ZfpZeBdXJGkbIdaBpfJ
	6WrRn/PMGgrkQtV1an5lDXcGJ83MEd6Qhp9UmevGcSQ2dQgbLlkzvHJSrK6eCJJNAOjKhD
	XCtSgdkJ05jHceNpkSjcqcSCWC3BngU=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qmA22s2b;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qKWivyyK;
	spf=pass (imf27.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770698833; a=rsa-sha256;
	cv=pass;
	b=cRyFeO9o0I0vtHlWFOU2wcfedvuClFnfHt2r7HYDnRb5ck+4vgt8VON67VlI03A5+XYChj
	Q16WIgkFAmiKC/RkF5sCzA2uZ9/MH6N/PvT/6j1qhmGnd+hB4AZnDfVaygkRyDYpoJu0mZ
	7sdKPyarshS/5gSulLPgR2gsffgEVEA=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 619MUn3B1557983;
	Tue, 10 Feb 2026 04:46:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=j/5vScUga2d1E3RG
	vvNsWv2C8iuEZEMEVD0W1aS30L4=; b=qmA22s2bJf0qm+gaBuq4T5xl9F+W04Oj
	Fc16Kz9VDVh5jfgbeSDmZWMhdMpGLmU00h6IUIt+2me8ku26RJxArk6V5ZU4CP1B
	A43tFoty1Pot9euzEDGhyC30i4asCFKRjHb4QzlJwvz2JsEd5yK9zNJmqi0NQxn/
	97hExn7VvVYPmuHfUGC67aCAOT3g8HdQwU9+9V7F4gHZSQ9nC9xigy62UokcaL+v
	JWZqcCreshoYolzGoh8B9wQ49gR7EI7oenYEUVvp9Xe8Ey/f1OMte7m7jeUyFpE3
	7Tb2e13Ojv8GIHOcBxOUjRga0k7Faz45quxtbHQxkiI/YHjMV/iJ3w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xhub943-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 04:46:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61A2o7W6040554;
	Tue, 10 Feb 2026 04:46:54 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012008.outbound.protection.outlook.com [52.101.43.8])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uum0br7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 04:46:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CARVKXZIJAjYD2R2/eGlxVdtNrLvqFVqzUyvFfOQAB0m7QQCUgt3u8FsjVnROhbd8BGKvrH0xXRPJDOzJpVqBR4A7GFgBdSoztR6hlpPxRW7BukgtirbhcC4PZUZuSYW4ZiiGdMgiBw5fFvjWK8DgMn94Zml+ASU18ILLAiROEWBXQr1ynWPqeNCqjfC11yt2Ehayms5I6xdvWcJISwO0zb62xqsZE7gXB86z7foaI9uNOt4q8i1INT9bpyrTWL62rxsTGTQAaLETC2W/VTnulaxO3oQttyfSFrv2Lge/6fAb+Y13yhpCKBPEyJLQCTrr+S5ffio2rNOqdvvlA2tEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j/5vScUga2d1E3RGvvNsWv2C8iuEZEMEVD0W1aS30L4=;
 b=cTdXE3i2vBBE2y9o2Y0iRCZ/z7uHu09K89ZWW6eH7rPnvsshysypkFasT1Zsn9J+mmSo4sUvOm3C8i0x7PZmNZtOHy2oH+WTO58CwCMdbabaiO0dzSqKZdE+F4zkGFMnbpCPTc7+tkPA6w+G4rgJuH0MnqVY6sbykV3fwLniKBRrlqimkBUwdImQraqYjjKo5/1KMAA+bawecAc54m5bDcNBLIJNTnoUUNdAi5DHOaD+wuDPoFASn33YmSO3P/bIA4wWUx7p9NGtNY+q3TwJdVRe4+nGq+DGrIXFsWyjtEjkFEFaPjDOB4mrz2x8kMkOoUg6tpBE610+skd4H1mW3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/5vScUga2d1E3RGvvNsWv2C8iuEZEMEVD0W1aS30L4=;
 b=qKWivyyKWPynoDjzo+7Dw3LtDv34x2E3iw473F0PJF4jxB8VzsCDrv/mVRFkT9nQBCooMO4kESq7wHcazWOODdO3T7ThMXELeO+2WKIGMQiWwhUhxjkJErghv2hshZbufLCuejeWP3lVf9AvGb7IOK4agomuCwGbrFnx9Ops/yY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH0PR10MB5067.namprd10.prod.outlook.com (2603:10b6:610:da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 04:46:51 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 04:46:51 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH V2 0/2] mm/slab: support kmalloc_nolock() -> kfree[_rcu]()
Date: Tue, 10 Feb 2026 13:46:40 +0900
Message-ID: <20260210044642.139482-1-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2P216CA0185.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1a::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH0PR10MB5067:EE_
X-MS-Office365-Filtering-Correlation-Id: 52df771b-821b-466e-f81a-08de685f67d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Hhm2jQYhKeG9urMOBJjiQwYh6YH3ELlfyCcq0FyMsXBGaDfMKnnDTAVaiQtL?=
 =?us-ascii?Q?Savts2aMvjLuWVlc19OUXjWz4pY8th5ba2hJhg7l67xNJ6RB0e1qcG3ZT+96?=
 =?us-ascii?Q?eRYJbDyjdZKO8myzxH9kKHJpbTRlzME+s+JQimGxNtos15GBvOzwjkMymoYf?=
 =?us-ascii?Q?AZPRRm1z+yoN8tKVifii8zF+aOPvQn+530n+MNYLXHDgsQJp1TmFKEs6La4L?=
 =?us-ascii?Q?I9GHml7nkpRrcPgRTIBqD29/dAA6NL5iyrPM2Qqv8Wm4c/cGLM/IQOhsmS2M?=
 =?us-ascii?Q?CELdlVJ3ZB8sRjFdl9/KXSOfmuIMyHEW33+rjeeopcMT1AF/YoTYSxr4tPKv?=
 =?us-ascii?Q?Kj7/1vtbrDE2rSXmhuD169N7Xf2l+PYDq2RMOK8HVK6FfvJexAiZuvx6TK9E?=
 =?us-ascii?Q?hJmqlcg1pSwTtiM8zm5vVHkko5AQSgQQkbgaKo7I1ctU80hmT4H+4qupcPKw?=
 =?us-ascii?Q?gwRMUgrO8oNgYVxuATdIKyhjahErQgs+Zx5Lq+NBKsTfQH4nRwn2Z2SH0bQK?=
 =?us-ascii?Q?4i0yF64FKdRViUm/2c9gT/q6VANX5JxcR5YAVukt3IEB+QnieFfIl5WekeUc?=
 =?us-ascii?Q?IR7lzNGDxEOqain1CTOh4Q/jnuhJ3vU2GvKBptvAX+kxNIKNsFJtD5wRWW4j?=
 =?us-ascii?Q?vqE3NteTUyNQVygll/0RkSAVm0KiGB2r08uY+VoBK6TFBghhjLIIcgN0Eti/?=
 =?us-ascii?Q?GPKMxg9cbEG7US/HEeliwqSxrC6gkZKcYFYmtW2S+29THt6PRXFyfqvSCjhb?=
 =?us-ascii?Q?8HwAY/4P4yNH7CLg+6C3HEWfHgXjo5burCT6nqIfcl9f1/7DF5IZvW/I05il?=
 =?us-ascii?Q?ui2kzs4p+wXJVTo5Tf8Fjg6WQ2SiIruCOCT/MvJGNcYboPlvl8hmpmN1qnGc?=
 =?us-ascii?Q?O1vAUeVIZMXrfRuptnM41akbV+fIlPhH0NGKC0yBvLKpVBo62KDTJEyPnrLo?=
 =?us-ascii?Q?MpmQzd5ljh8mc9HzRvZYDHVW2LBU7x74dt1Ksvf2Y80epeVxUWVtJ2ZwWcvP?=
 =?us-ascii?Q?F8yDLXTuItL1TDQ+yN32TArPm+/FC2t5fe8mm5VIFGFUOVyP+feBAecdUNQN?=
 =?us-ascii?Q?JdFEqXwa5fdptMrywjoQ+unNqQHzdR/pW1QqAWtK2vrIxb/uQjF2Q5mlPxQV?=
 =?us-ascii?Q?v/USh0zlwjmoip8m6BfKJPNwHGbHPV51L4nxf2Xje1tQyGDsttceU/Vs+cUu?=
 =?us-ascii?Q?6zPmZojz+qR1Bhq/rO4G02ih7RjHM5o9wR0GPtACbWi7nP73CGmrofKWrpI3?=
 =?us-ascii?Q?0InH+ui23U1dUcPTvEgzh8gqjoiATPQQT7snDeXKAJxKahZh+uAXR4uQmUWs?=
 =?us-ascii?Q?C6mshiTTqZ47t1nbXUdPJuN+lwU6bjK5t0BqbftYKPZvIr/gYbECMnTIDoAy?=
 =?us-ascii?Q?od+jKa64IwTS/YTpcz5wNT+Hu1xrU2g3LL+gg6XN7VgEw0p93tpZLGVOydbo?=
 =?us-ascii?Q?V3t1ebSQAW5LO3qy1IoNEaWG4QcvJMu0RZdrqAX0bpLTfpNUHwA48kKBgbnG?=
 =?us-ascii?Q?Rbxnn83IX1ayaVgH/5N50AlGubn/Vh/i5S+7to85veDWrKc8Ng48NRUh8sO5?=
 =?us-ascii?Q?WvKDrV42Z7cW9nZ+3+LxCWLC5GAaoIGtN0jEl9wr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?niBGvn9wg7v0dNL/sKiVDqf5cciNdYIO9VAwt4ww2dBHr54QOEnCLuYyCPwQ?=
 =?us-ascii?Q?J0VU5PiRePj9vZiYMsBkO8+k57llOOOhpue8DTEst8nridtgdjsGAq9ScBr6?=
 =?us-ascii?Q?lOQBi0yI6CtFMzDYyw4XKoNhkOsWcVr5joSLT0ZD4WLUbIVTtFi7E60lzegc?=
 =?us-ascii?Q?NI09OALReFxRXzwwwm/xvrbkvfrL9ZbRE/STj/fek0/97ADvcPyz/OPgJi/6?=
 =?us-ascii?Q?Oebe+zG+vRD19TVi7QXt7wMo2Gzx8q4rJXvOoIGZwtf0h99yuu9YR951E8kY?=
 =?us-ascii?Q?KdPHCTghcuKEDkWFfT7yG+9yMzYaNKn9IzVhdfDyXorAATNvpSFAeKBCI7oc?=
 =?us-ascii?Q?/9Jd3PONl78aAxUwLAFfPEB59Fz8I7hZpSzJbQVZR09sabX/cbpWOT4kO1Rm?=
 =?us-ascii?Q?xgow6PH/mkbSoM+6brDvCxcHyg79we0Atc/dLD2ngv4+zm4s15I1RdpGaJR+?=
 =?us-ascii?Q?6gKDAkuMHb+9xPWs3IZFgFh73By89YrcM4FLuH35Vn20h+8GUZDp70yB2n1c?=
 =?us-ascii?Q?fR7mqu+D/qVCByXn+rtbSyrvV+uTVHJfioaekx+8XycZ88+TuKlyWGztGihS?=
 =?us-ascii?Q?3Wgzk5P1NeOg1O5rNGsL7+WdEGB94eWQfNUcosJZhjxyu4r8IO57Ax3gyY/o?=
 =?us-ascii?Q?vSSJEuMfhWffbF7PCaKWUTJ/S57Ihg1YFftATUCOY/GHa6PL73d/3dtxJEtV?=
 =?us-ascii?Q?wJFN2dy2mbHqgcR4/Zp4bYcKgqzTwaTFi5J1IBIX1n7KVRVS7LaJb1TXpwhW?=
 =?us-ascii?Q?hA72Jpnt0ewD6CI+lFzic+uhcp5/m7oFp7M9p45HYO8Kk5RMkGiatChEBvfb?=
 =?us-ascii?Q?00oi64SKn2Eyi9uj+boTV7RrPvTD1gv64NrJZSW1sjuk0wrRk4AiZE2vSelk?=
 =?us-ascii?Q?OXPCHxHCUvt+bSmn6TF7o0oYqct+gztzp7wj/GJh4TaKZvPJyIDSKU543b8T?=
 =?us-ascii?Q?C2A20QuDvOU3fMTZeBP00Ws0YDwnwVCRCsUXLNBZsOg/dpmArwIdYia9fbBK?=
 =?us-ascii?Q?+3yEUbaDOEsXpgLADNVlfuQMbmSHFejrAg+F0iQCEQzZ6vRGPSfEjFtUxkLg?=
 =?us-ascii?Q?0VcO6zNBT/5WWZZiDrD93LhYe1vPUhLMkVWtSr4Pu2hu20sC1cPzwlgZ+VCT?=
 =?us-ascii?Q?irCbqQgzYNI8lnzGYN64egbVSdK341fVVa2Dg/vuYQQk+uDWxwszSowLht4D?=
 =?us-ascii?Q?KfA4C1i2rV0bey7vhzVyrPHRkbS4QJDXVpUC+eL434B1NYYmhSw0BrHJh98z?=
 =?us-ascii?Q?97SYpGtWRTDhZPxM4whudqyxuOmS0luNV/YLPvW37T5mavJI0Jskff4EWmBM?=
 =?us-ascii?Q?9KdjIEkjhWG35KuzJg+fi1Uk1dfevu59o+as6XzRN3fKbT/nYIzsH6IHP8H1?=
 =?us-ascii?Q?URk0OyM6XpZuW2wGXg/61R99W9aCeRVNXywcYEBD+N+BRu8rU1dASQN3f5qk?=
 =?us-ascii?Q?dQxqHMleyfEZP6Xa2HWhIzZaS2v3f8uAbe2QVgWNq7RAWwM55GL2IXtz0OFs?=
 =?us-ascii?Q?rl9OGEZHMvd+zB+d2q7QZSYpPjs82jy0Fmsr7Wma4Mi4kKdMHYItPpwx6GGV?=
 =?us-ascii?Q?A2NQNH1Cf79OHHo8n4m9QRwv2/rGNybMLHNODpTIjDRfQHgct45U+eVqiHfs?=
 =?us-ascii?Q?kOPoew0V0ST9NhvP9F+RCdY+2tpJoEzKmD9gvqZ9ooXcJKn/sEJnXp+OiRTU?=
 =?us-ascii?Q?G7LIjZxDA6KElYM6DepRnFMFWY4XMDOSdtWlWbspxw+420eu9uZ0vzxgli7n?=
 =?us-ascii?Q?x2nZK1HlLg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LzstNaRRUo9edZuMV/NXHlkEtIbW4KnpMxWMiZOK47y1h7rqQl++GMAWSGp0FOJHSRzP01M40Q9aZdA7eIKDarNTyOHl4hZznAPePCCUP83WjRzhcTn5AWBDyzF2yVSi3scyBslkcx+N0d+h59QkvrAbFvCCBYSlGkwVT5koYQ+xBJqtSXxxgDUK43RwsWFkxQzP7A9Bf/T5e5rxrEvsqrtaOBiGSj0QFH5N4rE/W/oFMi2xqR8h3wseZvnvkWieXAlFm86x7J8RL73L0Uusw0apUbOk+IpbslriiI3/NvkT+nOkTXZyJPbDxdf2dngBF8Txg8N2YPfTP34hQDOx9t0wSYFVliuDKZNusF+CaRjcZVDTSkZSgRvls9tteklQKeg1q54EZzCpAeh6QkGh6sCAZOBKR8zUVTyoN7SzQVDqQIYX6CgN/Pqyzc38W4Wy9PvOXJT8t762rOVmq8EOHnA9gPVEGzoSNmQFDtPBco/y81hEtytQ2X8w+1MnidJagmJAAPoh1HDpESUenw9h4lGVbJZ1mdtbBK945WMN7iZLEfczr/OjM6zxM3ZxsEG3iT9HguIcKEJYcISQK4pRli3cP8qZvqvO3Cxduywzmw0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52df771b-821b-466e-f81a-08de685f67d3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 04:46:51.0140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Slk2anmlyceF4Laqo2HpJ4LSHzlsVXKRStnGGwvR0I/4tfheV0EBQtDRhKcGOqfc/Z2KU/GF6K8saOoDFl5gdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5067
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602100037
X-Proofpoint-GUID: UMYY6p518-KtI693SFEDJk5woLpV5K4F
X-Authority-Analysis: v=2.4 cv=FIsWBuos c=1 sm=1 tr=0 ts=698ab83f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=m9zTolpj3w2v0F2e1AgA:9 cc=ntf awl=host:12149
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDAzNyBTYWx0ZWRfX/1N0NelnncEl
 gyi6/kWi0S1xpsw+BVjLZ8kAhmTQ8jtUcrXrxhOvAbGAnZxsxM+1P7DsHKg0qo1T6peb1iI155e
 /+ZKLgMVWtN4JDqE3QS9JLYpR2QHVlDMJxi32wsooiZZwH42iDPOWXwEUAdfe4uH9T6wqGl98MA
 +3PrxQKis87hGxqczC+YGi6d4GN1cmgMIUiMItN3JygBbz3fnNpR8oErjWENlkPLSI8Cnu5btmu
 E/73i7zs6FErS6YNXfy1cmdPXiiSe+qMClf+AWdTNQYCsvrIhJn/TdM91KE1Tkc8Akgqd+nS29w
 yQ4Vv3gYfz9Wf2Nv5xSjZODf6zaORjGqCN6Us7kf7RwwmVU56kfagFkNorYHb1keGxJqS5qXLhT
 2Mooj6sp30ru94LYG+olZu/1YWZpGPQcAJmw3pxcCVUKAGpxd2HYBPy1SZvRuteABGh4HSA33ee
 FElN72na0YyMdMuYyB5vXc5vY1wGc71uO7rOCmb0=
X-Proofpoint-ORIG-GUID: UMYY6p518-KtI693SFEDJk5woLpV5K4F
X-Stat-Signature: cr98ejztnfoid5krkeq811hxyziyhj71
X-Rspamd-Queue-Id: 5F17D4000E
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770698833-659862
X-HE-Meta: U2FsdGVkX1+d2xaq3RCp16lKh55NSM7ZoWdSTMTVIlz8vYQVtekrKxV65kk9baKDWt572amQ9ffVZiI0UbHX8JLuNO1avmXupIFh2Boiub6TYbyu+oEHBCxrlBFIlyg4g74v4jKsfSTAcGxm2dHrEIXT+uvdfYHZaOdg7K84Qc0OMu6KeyZS973rY99MmwB+BIpkl5Rd8VwB5PzlRJiRASFy2EVtoxho+GbkXQdMkozoavwh78QoDsZWGhxo9tzrX5mA0UMWS3ho1oZNcN63YJn/Cdh13qtaU3mDzM205nz84QTN7n8Stlv/eP+euQB2+iPiJF+qkGvguwwBTT7XZbMcMYjljgpkFf+LCqbbkLwTYQyltS/cjRmer1NExNx/whLAB/BtawWidrPncsaBpAn+NC5z5kYp29vTesB++QaSie6qcp0W5lhcjCSGiMeFAxWURIqRkCcXjQk7B04IY24hVRMxArgW8A5Kr0h9pDyvCERGUsowAaC0wd7UlkLCUXwZ8RZDg3Z017qQdrRMrod9E6GTIzBYNRGzBpK/8TS4Qk6RuEpVNkk1/W5Sh3hcEWLH2DsCn3aCWafzN7wgtS0+uCrfJoglscClZWtTs6RkDnBZ5889GKU9M0z7CNkXuxvLJ0a28xm+w/iWLssf5AxBjqL9ThheS5pBrzK6aklbW1m/GiRNFTxG2CBmAsuU6vGTLmOWU7/TUuNvrgrk7nzW7Kp3u2Q4YClsXW+lcC4aiRUFjbV0woCsMBhyX0rQhuqkE/99lqVktS1ubPo2RlP/Qji9X2y13zie5qBNbBFf0vRz98WBFbmkya0B2v0y94Pb+Qx7CP0qTvFKZTsPOhva9/PwQ9HOyffaTuWsTpVjiwMa1k/LCd+wVZiXygpXgJQHQuSseijxFuDtmaJJ/R9lILRt971Fwe2tgozrVfwtuE3vxv1EVWRLloSsBWlRSlJlLCkZ+Q+uO/a9Owi
 3UwnjqPW
 G4zWd6MfaLqHtnTqFtoIrhCyr1XyxvfPQPLYMPO8K3VWBi+dNFHS3djVH8A1A0gPkVpc1a6rwO9HIe9v00zXmiTvGVENOzUxn8GO29mz0Zqq9RscenUQTst7Plmg1ejtIurFjzM5uS4D52T6fS3HMvxuNphBEPO2zmjLG+/4Mi788+qBXbSeePKwvyGnPbHJ/8xOO7CaCiu0g94FfworB/ciIdPlZUILO4W87gPSQGgsdYvyxwHJw0SIBbBfheKTHUzg1Nqr2ZjBWbY+AH81wINnoyEFLTqlyWvBa2HJ6e2FQ/7kMjc8KflGgRSA0APeTd7bTu5WX5z0ZsBgHz+of33Qut1+IC89LRd+AXoTRIsPSnZD3039RJiSoK7yRieBbMCjCHbnXN00dxsUUySNfrZOpxFs6uCiZwpgSFcflAmvKWCfttfgzttf98ze303Ee0N5gmc/B67URga+Lr//h6gPORCbNF9YtgITtrGAm7pwp894OzdEw8nzNBvFOgGOiQn1oMGs844cfiH2qVTLTKioTZtS+vnZJ5nXuMPTLhKSxDX0IeI17kurHr2rxFifL9N2OlQPJWGRruusRv5cVrCYHGHGPdTiBtpcAzamNLsmIEkCrOdcfsTQEVdSBmpUR1Sktk4xp34aZCmFRAG3wrux8D3yU1R4ZMt/8oPgZh7LfJDxAMkpQgq6Rg2lylstH6pqzv393IrR1y5fMtu3BEKadvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is separated from the RFC version of "k[v]free_rcu() improvements"
series [1], as these changes are relatively small and beneficial for BPF
because it enables the bpf code to use kfree_rcu() instead of
call_rcu() + kfree_nolock().

Patch 1 allows kfree() and kfree_rcu() to be used with objects that are
allocated from kmalloc_nolock().

Patch 2 is a cleanup that frees a bit used to record whether obj_exts
was allocated using kmalloc_nolock() or kmalloc(), since now both cases
can be freed with kfree().

[1] https://lore.kernel.org/linux-mm/20260206093410.160622-1-harry.yoo@oracle.com

v1 -> v2:
  - Added Catalin's Reviewed-by tag on patch 1, and Alexei's Acked-by tag
    on patch 2 that I forgot to add. Thanks!

  - Fix calling kfree() in free_slab_obj_exts() and alloc_slab_obj_exts()
    when !allow_spin. Pass allow_spin parameter down to free_slab_obj_exts().

V1:  https://lore.kernel.org/linux-mm/20260209121013.50475-1-harry.yoo@oracle.com

Harry Yoo (2):
  mm/slab: allow freeing kmalloc_nolock()'d objects using kfree[_rcu]()
  mm/slab: drop the OBJEXTS_NOSPIN_ALLOC flag from enum objext_flags

 include/linux/memcontrol.h |  3 +--
 include/linux/rcupdate.h   |  4 ++--
 mm/kmemleak.c              | 22 ++++++++++-----------
 mm/slub.c                  | 39 +++++++++++++++++++++++++++-----------
 4 files changed, 41 insertions(+), 27 deletions(-)


base-commit: f6ed7e47c1fc78e78c9bfeb668b1ad9ba5c58120
-- 
2.43.0


