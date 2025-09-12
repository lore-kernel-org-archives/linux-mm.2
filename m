Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 672E4CAC58E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 02:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF2ED8E0006; Thu, 11 Sep 2025 22:21:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACB368E0001; Thu, 11 Sep 2025 22:21:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 992548E0006; Thu, 11 Sep 2025 22:21:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 874558E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:21:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2BF7B59E37
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:21:21 +0000 (UTC)
X-FDA: 83878996362.01.744C453
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id A615A20005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:21:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QznODj3s;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OSzlb1in;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757643677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5zz6JmIbBlLBu/cOqerhyTjYHLEbCJ9j+6xJH5n03n4=;
	b=1rRSGTYIdbUzZpi7fLdrNevNOfZVXxd6hM+TkeHA0y2KlDLCu7deh3gng1HBu55dAf7q4b
	ZGnt7RMlxXRyUwDVversNN0KsUC85xMgI03/CVJGBdXs4EsGqPVTMTyWeMDTiRM3jp8E8K
	ZBAvE8vvj/ftuuWk1F+XvoFddwwCgw8=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QznODj3s;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OSzlb1in;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757643677; a=rsa-sha256;
	cv=pass;
	b=aWxSKy/hvRwsXwe6s9xMPfZ4pgw2gq43IsUTm64XGfGR7zM46Is+nLyzY5znKgV98+KwPr
	e2NW9soYkW+2qQYBu8mY2hDhgFrcz4zQ7Xs8HdJuZqBeC25XvSep/CiijBifrngsZJiLhS
	ikigLtQVwATyU7X1EcR0NJI2J0lWZ0c=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C1uRtK016819;
	Fri, 12 Sep 2025 02:21:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=5zz6JmIbBlLBu/cOqe
	rhyTjYHLEbCJ9j+6xJH5n03n4=; b=QznODj3s2OS9hVAs9Iwy3zgCoU/27JWtiU
	kMIjEga5Gzvj7f06ZsfPhkmE8X/3KYPnqa+D2KGznAnSFwfnjVBqW34vkCyqLnck
	EwVUTD2KIw9Nq7b2uH84md1iY8pkK4zmqKEGMnafil1CdvwCpao40XbVnHbrWO3n
	qO6cPsdtxfUgqKa/1PeZvDi7Z0Z2qmADQ3aMJOuPmBZivyVgT1rGJBcll01d4lrg
	KzGQT3uuytlIBV/iCCdwjUNwCS9JQ8Gcf5BkskUz5WeLrV+Jn3I5pwFykgPS8UgW
	jS91lc1zPCcQfyxZsgIvMbArJm5FBK1ova7ry9g7rP73w86upexg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922967ea9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 02:21:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58C0qSKf013394;
	Fri, 12 Sep 2025 02:21:12 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2060.outbound.protection.outlook.com [40.107.96.60])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdded60-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 02:21:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gS5x7r9K1S963c0tpQfCpPQbK3LU9DB8Ltyt7hiCMEkq0J50B3wyXAyReM/+YZ384P64DmDqirs3eu2gIXfIdFXdiMGOlhjBtKicmSQM6XWD0rqBvGRhvk7qqbiOBFSq/tdY6ZggcLuDUe2zbnZF0umE/NLSyfSR7g0QhdThawhq6Ehi2JB+ktK8lXoW6I0Boym4sKrcRIdq/zeKl7iNoaMc0SZPXGblKjaYan4+AH98aaYftwyrvQQJmSsuglEiPbqN/R85PIi/wrwpmI4eo/Hu3C3uohdAd4B+cRAsxEt4RvbPuekY3eQnLGnlLOpGmD2IpBrs8BiMakrEDS3PmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5zz6JmIbBlLBu/cOqerhyTjYHLEbCJ9j+6xJH5n03n4=;
 b=i5K8z/fEaD2vsgs3i6JJzx1jrxjT6R4y4tdEpcFAYGbX+hpcm4b3Iz9zhtM4u5lWtH4GFr8f3PN9kbZr62xqIs3AFpsTqph1KQH+zin60IkN03Jd+PPeDTc4s9yiuIEDS6/3kHC9YUsAw2qkFCc6d3nvMLMgzxZ5QOqNG8d85UcybsgNRnmy8AAekPn5K3tqaWMutm4oNNlsyUl1KfoaKnLitobrqeav7ElkhBfIrJNZTYHe8hsEFKDapjrBfQaZ0cOfd2t8kNwIo3MT/W3fmB1V8LNEuvafwSGzGtmtlRvVMFwTtGxQCE3WEdrqxFbP4dR0ReRAf2j/ZFgTQ9XLkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5zz6JmIbBlLBu/cOqerhyTjYHLEbCJ9j+6xJH5n03n4=;
 b=OSzlb1inpv8wF9sJsjjVav3DGYFX3BNN8k8TocgTMQQ9Ei1ZRWYJJW8RXcbJi7f+ejVTjobeZQlLVUuVOVHwL2cmxaEMgGg6h+Ur6L0Ev/h20veHuwMIUpKy77p1bwteND1odz1xd+yM9yxfLjpBlDXl7aLHApQ930mbcMjuWAo=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH0PR10MB5003.namprd10.prod.outlook.com (2603:10b6:610:ca::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 02:21:10 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 02:21:09 +0000
Date: Thu, 11 Sep 2025 22:20:54 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org
Subject: Re: [PATCH v8 15/23] maple_tree: use percpu sheaves for
 maple_node_cache
Message-ID: <hc3kari6hxfw6coyl24v56ynn4djvpzrln4eltctiwkafv47my@rbv4jxquriis>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, maple-tree@lists.infradead.org
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-15-ca3099d8352c@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-15-ca3099d8352c@suse.cz>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YQBPR0101CA0210.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::21) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH0PR10MB5003:EE_
X-MS-Office365-Filtering-Correlation-Id: dee87f61-ab6c-49b0-c438-08ddf1a3095c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lTy9De9j2kb9ebWIVqmHIIVSAgVQnRCGN1HwGFRya4fmrCIttz2mZZaf3V2d?=
 =?us-ascii?Q?OB3Z3DmXAOoD8N9XHrObGUu6ujdasGCHHaevtj0QIYBDlG1MnxvyHycqJi/y?=
 =?us-ascii?Q?OCtWA0xtInkLZIcE2Vcm1Q4GloN2XuAo1vvpJqijBsbdzoWRLS3FfETHy9Qc?=
 =?us-ascii?Q?z4pViOVQXrsMy1WajqUL3d08Zmfz3LBQ8StVT3Layd6DUzT+1PQnPjoytVKU?=
 =?us-ascii?Q?Yqcr6y02fMs1FjrVCcIyLQUIN+Igzb6wnTXO8WQSyOXOFHXwyDPj0N2tqLWK?=
 =?us-ascii?Q?0L43alUXWeb4c/184svCN46fGHqIRqe70TapagnjWDvOgVdaM3s/sMQtYbuM?=
 =?us-ascii?Q?G8pDjHD87uNY9Fhk1S8jWVr8WL3Y6hnjhB7PPLuzNHaXqpb3nIqrTwKrPtwN?=
 =?us-ascii?Q?G9fHZuv9SU9Ygt42nUHVcejwiFEOo3Tvy3GV5sVn5pF5V1XhGtTe5K3nw/gQ?=
 =?us-ascii?Q?LGLBfS5hXmrCKaPA8kUS8dZnAh51FXSMJ2qG3qk6Iqgs1uznQa/+2qsGBT/5?=
 =?us-ascii?Q?21pXaSdKwiRw3G9ss7qftx8I9xiKStjTxto1fBb7yqwVfoNPY/orWJCmTkdL?=
 =?us-ascii?Q?xFlvuufK+k5P1wPI+NofktR5VSn/wIn9r14p0OuNNQ9VOTqJ/OvfTV7LMBB7?=
 =?us-ascii?Q?Ygtclx4kod7yyifVK2JGNB7RrzyUurLu3B3U2eMt8TQwpC/06lkbqIBeAdVY?=
 =?us-ascii?Q?ddvPOHMLQh2nB8OG/TFA0sRtnHF3MxRRPaPoTTHl0RX0/7OYK9kGbPD3gu6m?=
 =?us-ascii?Q?d/gNnTtzfunebY9V4gEbyKo4LhvoYfQIjKM190/sknsOvpm24uqeSRQUFGoU?=
 =?us-ascii?Q?J0Egm+VwodMru5fKo9CiX4CX5T6K66GnR28kDJWuO80moETSfYvCqhJr1x5z?=
 =?us-ascii?Q?Kks/mnbQDCcXiBrUdd1TnzQtCe7QiyKzL7mIE3nGKj1ChVQvuM5ked95EsZJ?=
 =?us-ascii?Q?7+Jy4itVlRdjjlH1f/w4BLwRXZpzeckn9qNa41mTv5e+R0WOV33z8ikrACI8?=
 =?us-ascii?Q?SEMTkGQSRf7OZnnvIVsxRC8SkJH4N8Bj8OjoI2ObvMiFbLk/f7GZL2Z/OAqN?=
 =?us-ascii?Q?ph9fGAsxvS3Itplx2VM6EXavR/CZHbPVKO0yqDavi9lohDPfq08Kbq0zBJ8c?=
 =?us-ascii?Q?Q7nCjJ9rwdyrW86Eh000eR+0OhO5WWh7PsK1KmVgzj3EJVcKQnhoy9iJuHF5?=
 =?us-ascii?Q?/Vc7Xj5Ey5xc32q9LW0piFR/oDZez5l0+4j0y0Mzxm2rzicXiAG19sFphASw?=
 =?us-ascii?Q?mju0HpoMyrvHnvmRzUmdcOP5i5/tAI95ovLh23ymeeAMS2yL3Dy2bAydpIGz?=
 =?us-ascii?Q?yInPCHFG7eFLWNP7Ll5Q9IcPSIbz8dYHDhKoYsQgzrmC5v4Z2ojqVBJfk2VE?=
 =?us-ascii?Q?rmpGEVfQt4EnRCxN3kTG8TJaI/qWKkcrHoIf3cxNTgQc2UWh5ILowDQNdgdS?=
 =?us-ascii?Q?ih43RUA7CJ4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ve+nixVFbWSS5iXhX08YaeTAmzkOqZ9kgmrzp2CcIwCd0X3RyLLKeFosPuA5?=
 =?us-ascii?Q?U+o4leTrsExiZ6fv7VEDKZWUkjJfi0HfiCpnF3TYWbaIZeJ3oWhiXX+MZE7P?=
 =?us-ascii?Q?snkdYp5BjWiD8r7lFxLiLplFvULspOEFje8OwW5r4hJcAlqn7kHww4MnzmJd?=
 =?us-ascii?Q?aWNi2Tkr9m7VkHBvQZC90ip2npgL6MQ3tRGkTYy4o+LUpTwwP2bOZzz/l2TW?=
 =?us-ascii?Q?l1IkHHhSX6oOiCHIsZA43hmAH11ts1rDOXXG+DnQJ7MDM6dYeN9Vh35TB9Ld?=
 =?us-ascii?Q?5qZo/B1TPCu6ROI0TaSV4XS/iqVRkVuE6yKRfABoEsvM1bSATdkBSD3ZMZCu?=
 =?us-ascii?Q?sVccTF0RrDz9BF+ypsWgeZw1QrmyFDfp2TK5sbr6NgEXUmEDRuKafwM3yiGy?=
 =?us-ascii?Q?2npZFGeiQFOf083ugG0zo1fIjjH4ceoOrmJ6yILhk8q/yl86PobmSsRbywkf?=
 =?us-ascii?Q?MTXDJH+OB4eBTAUxFsZK8aZaNIlsvA1tPImuemWL2W8xfAE+k9T1Qzxq8sOX?=
 =?us-ascii?Q?htECD5eG+k03mQbecO6eZ59soEUWITE6PKRT/xAuPXi2iSGNTcBJlojmrc+r?=
 =?us-ascii?Q?1jNoRIU/2gyWerMWOgvziUm303i1amaMWjXvYHCpkaEC4eg8Y6eyvX8y5Ssv?=
 =?us-ascii?Q?9qtHstaRW5kgS654GqLvRrUr8hWOAKnzyLILJVSL8iPYW5ntOJJdvrgeEcf9?=
 =?us-ascii?Q?ATf850+VKg+DeRs4kpR2s+4vflvYFdKkTK3N4qoH6bnURZuEVnTM/2MVTUQp?=
 =?us-ascii?Q?BfzIvrgM8N0IlBPGbc4kLJG3bCSTA3OBuP4MhM0sKjsl54TpqCaOlG9sK5aU?=
 =?us-ascii?Q?6ZxTsJlokGcDSK7T5a53+9U5z21QRYCWXt57tACqRF92m0t7yB6ZNPXeBN8K?=
 =?us-ascii?Q?YA4w1OGXpHurUFPnfIXqmnnMaWkGau4Y3Dffg7ghEukhWNWqZpK/zcXDrSU8?=
 =?us-ascii?Q?oB6r8gi5TgnVC/73x4O4FHlnHhuQLgXYz8BD5ZuCQW/jbdpqiZrGQna3XD3w?=
 =?us-ascii?Q?o5vvy7TwfB9+sPlp1xzKBLuZAoQmtQu1bU+gq5uB6l3iC3j2UQ+gJSPZF5EQ?=
 =?us-ascii?Q?wG0A0TKXW/5eX4LTqCgrO7G2MgzPEYP8fZMhv9eEiqY1GaxKxFYn8MI9c4VX?=
 =?us-ascii?Q?DpAbx7kqntN3quK56gUsHlDEoR0Y8/nZ76qcP+BnbChTzdblpapMGbbJEzZj?=
 =?us-ascii?Q?F83EFbJb2vpOsOZRR81oQ3kdEswqblJ+HO7OJV1qmFtxZU8Nr6Sb4K8kbJ9L?=
 =?us-ascii?Q?SMiJ7FbtLDPXy4Idl7bR1H5LA4fEceo0mM/u6aM7MshovP6ksvB5oYyWQV4r?=
 =?us-ascii?Q?K/Iy4SIG+t84uaNb7lS2P3K7yc6P6405qo/1Aj2eh8GD6CWW9i7baBA18Jy2?=
 =?us-ascii?Q?8jzxldybGcKVb3wHAFNp0fwJ+SWWBlvQVIVa2rwK7uuBf69kzxzAVcA2m0FY?=
 =?us-ascii?Q?E0JRFpEQJ8X45QXzO9L9nD8cZb8OG/uRzc4y+mq8x4QsByXBHUjwZezZPanP?=
 =?us-ascii?Q?Mdl3U/kFwtsrbJu6eXLE+C7imSjpSC/QeT/dvIPAn45JMENCqiPf3GHlsGyG?=
 =?us-ascii?Q?D81TM59OlABf0+l69I/UtxZvVZumLqf6s+VWrHeA?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UmuKQy2jM93X4dnRNzqoUjd08JSg+6fhfY47OCEuwoJqkVmh40DsFzg249CputpzLVUxVXwR12fRc9IRDA+scs1BhTdL0GowmKLTRgCp04dzzlzKSffrOKJC5Jb41k2pOtNplfMuMjtpQ40aynP4oqlAIXQXdaAjGOwiOaCCZeAhClp+mvJtGi59NySwRpYSdQBCr7Fl6YmEOXhpM9eQQi3hpt4iVmmJr45cltOOAn8Mm5ykqs3HGqElEfeIrZrpdIV/g3MPbWwCnnzml7zPlWDkWnbo6uHuQ0ub0Ptx7T8ZfsdGDXoC7KdLFeUjYW0nuQOpE8aosW87+cIciltZjfgPSzppOyDsSAqo60b4ddv/k0BCVgt2CVkE/Kh7kFaPSX5e/ARN3T3QLhYpR9Or6XlL10cdR0DbqqjVKKyCR/uIyqpnAqXbFm8ftpDZxeafxqEZW4vL3y3YyEKVVzLxWN1w/9oftjkQgLOzzvi2YbEBTbHpTCv2bEOuHbYsfm7i3UI8/2y9TBSOj9nLm0exgLGNmABxQzmLJYQaj/q0NRTXljNh+i1z9kb+glMK0RJfaTEVh7KpFKr1XVJ4GCIE/FPfk5NIHJDvHe8JC1TVJbA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dee87f61-ab6c-49b0-c438-08ddf1a3095c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 02:21:09.7669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qtwi5KY+6zaCoqAsbU753gMc5jSRHRILFuI1plMLE5+ZWtuHE3W3XzrWmxxO2GNw06a9TmvpV8nxRaEJfoLuKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5003
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_01,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509120021
X-Proofpoint-GUID: NrbAJFNyXILjfh0eYbjpE7zmQe1flTSk
X-Authority-Analysis: v=2.4 cv=CPEqXQrD c=1 sm=1 tr=0 ts=68c38399 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8
 a=1XWaLZrsAAAA:8 a=h0xQpobXdOLgO96ornMA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OSBTYWx0ZWRfX1nK1/MO9aQBq
 Q6V0aj1wpN3WslkYsW6GpH96EG9SojUP95yU2hxEXnI68Cq/DbEisHXLvl7E5ESSCtU+mLYliUK
 MgQ4PbdaTDcA4/mlK3HlCp2f/GefaMT+nlQx0P16KLF/iG7k2GKEsSdIKjKAObBqfR1/lIbxlqT
 mzUqvgqYXhaqWAvL06bj/ctXoeV3psEhfkw3UBjK0Eueh40fk2W6VieKIZuPKVUCQnY8mBwoHBL
 niDP3F9aMHdTdBXxgTKJJ3+WfrDQxR6VjFnMQ8+aKRaHDKT5WOywRFSMZffj8a7rlK/vVqI9vB3
 Z8dywUFfBRuqQYxw93A/suC6QGf+9MgIlfqzzP0eG1hddxYme5hyhLh+lD1nePWsIHoNq93pOCV
 FCCG95Eh
X-Proofpoint-ORIG-GUID: NrbAJFNyXILjfh0eYbjpE7zmQe1flTSk
X-Rspamd-Queue-Id: A615A20005
X-Rspamd-Server: rspam05
X-Stat-Signature: q38wcx6174iwyre663z5tkk31ojk5bge
X-Rspam-User: 
X-HE-Tag: 1757643677-331795
X-HE-Meta: U2FsdGVkX18lU3bIqCmMPReqsM+xms0EGyV223FqgDe0pAXXtxUeBJbeLdfkpF3TgGN41UTvEGhuCZS7vMedAQtHhaercc1Er2t+1SkW+hm4OWsx/KE1ZCMfpU6cohUd1P1X6qKpDo54wbO4tGKGMikrWCOt80stnSR4w9q2r+7Qk/5QFTz7puVcGv3rpfQh5lUYtBg4+GALDTdW594IFdCH65ArM1/4KSETI0mp+1xPDDMul2rizLbVnRrTpn3NIKghjc/vUifPHp8dhWbwWUBG1HBvDdwd83GGd1GhfUJu55OpxqSOA65KY8GgsmPQmiO61tV2F62Hsu3/WaK1PAuoxytTKx/W/WLiNSW9MLAP5s/TU5FQLm9pc+EHDEsNbMFkw1P7VX/7DYpHati1wzls7ZYjYUJ3oy3+s6WQdmIPk1FlU1biYdqc8iTY+sV+tNnSkQAoisWxmFhnyWTmOQI/kKiJI9AqzQ00Xg/fF4uKRnu/y2ttkdV3DKMi+GisHDC773B+68cSQ7sq8QUWOcL/IoFy2TFo2oe2d6Y5QwmVisVI7RIuqvT4XOyE/Gv/WcYM5leSAWu2w9CWhoABXj+N83t1D9EE5Gn0eBSrscWgoHGFpg/UAafsVLtwKHSb1Ubwv+R+Nmi4y1XD4pG8TklRh4advB2fjpq9nvs67+nP57sVPnCxBzzQqDwgmgTy5dmH6hUWhfAGQebuekehULNkjA/jmbdVpPmI1demG5APM/QMmDmTH+3GqGLlnvKxQ3G/bTKU1bhx5DQ12Q9dsqfR57R9hXEYNOoVb2lB5ieEdPbsfaGhx2xa4/jWnWAN3y/ORZa+OuHVFA5mZQlYFIPX1aaF5GQmNZIJX1ctkImNaab9qJUWVfbByhXEBQy8ruRdWtdX13IWfDGCPxT0OeIlynimF9eEtILxui13avLId7slZPXXpM5DNyDyR2JfUn1iWBOkiouyvmiJZob
 d7C7Ubc+
 mHhDDdQTxeRfRmOVnseK2ReQn8CXI3o4TIL+9n1pFp+JHUxLXVcIlnmIz2AOo0ZiDG7hNojVWC6YfJjdOLaM/08gVU3IcUTZd2qS421Igh9ijQGxdoQAGFxFnw/AWmEUPr70Tv4pG9vJEkORxJn2LPi3Il/bgSZt2WZLrGtypgyAyCXIKBNorzLovsSf88y4r7u00qqhYXOPImZ9HdNEE76ekiMaGbgkQjceLwlOw1A3512cdQj0MyW8vPcRX1LLdajdjARTwLMSiNbfu2OZiXt6YRfRKPRVmeD/1m5Ud0+rLr2i6iRz/gx/pAmAdXkF3sRJ+Imf3Yf8hYKCQ67bcCYYT/MHb3FQll1QPGTpFbdYuwpcVBplbo9V75vdctuV7bdUX3spF7uMw0NXeVt9HCxRKkQEBFaFuZHJPQEjblfumdMOxTsJpMZbHzahwVlPLMAYKxfu1Q9foCQBVCfA3YJWyMBhzt+NbMbF7vekdq7jJdQ8Izc3WzJN0j90ckA1Bh9W+kyFO/afmB0fE592kvmyhVfeAX3EiwRZGy7QBtBUMSOE3C7DTU6+H7XwyuKybnL93rr5PxeMBN13CaWYnGgEK+0ET1OwUInSFabjXnKFC+wZ8yA85G9DAO7Em8MlmrSnujqMdbGlqstMw1akdwWuOOyuRygCj7NBHm/nqG/MjFO2GjKaj+BHtWYiqccksaYv0FbMTk7nWO29hqTkdVaS781Z3wpfr1gSG9XcmS31qQBlWQrerJ+0j3Z4zsTppNN9SOKniYNeexGFB7oYPim5NWXsUhV/r5apAXczcjlHAhbN7qLN1A0vg4Z5zct8ovqMBlOIouzfdhUbAlNYCv09H79INSwTXdymYOxe3bLxINEllSrtVdEApvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Vlastimil Babka <vbabka@suse.cz> [250910 04:02]:
> Setup the maple_node_cache with percpu sheaves of size 32 to hopefully
> improve its performance. Note this will not immediately take advantage
> of sheaf batching of kfree_rcu() operations due to the maple tree using
> call_rcu with custom callbacks. The followup changes to maple tree will
> change that and also make use of the prefilled sheaves functionality.
> 
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  lib/maple_tree.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 4f0e30b57b0cef9e5cf791f3f64f5898752db402..d034f170ac897341b40cfd050b6aee86b6d2cf60 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -6040,9 +6040,14 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
>  
>  void __init maple_tree_init(void)
>  {
> +	struct kmem_cache_args args = {
> +		.align  = sizeof(struct maple_node),
> +		.sheaf_capacity = 32,
> +	};
> +
>  	maple_node_cache = kmem_cache_create("maple_node",
> -			sizeof(struct maple_node), sizeof(struct maple_node),
> -			SLAB_PANIC, NULL);
> +			sizeof(struct maple_node), &args,
> +			SLAB_PANIC);
>  }
>  
>  /**
> 
> -- 
> 2.51.0
> 
> 
> -- 
> maple-tree mailing list
> maple-tree@lists.infradead.org
> https://lists.infradead.org/mailman/listinfo/maple-tree

