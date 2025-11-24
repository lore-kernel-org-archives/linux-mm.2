Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE5AFCFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 05:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ED4D6B0023; Mon, 24 Nov 2025 00:56:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5136B0026; Mon, 24 Nov 2025 00:56:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18C636B0027; Mon, 24 Nov 2025 00:56:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 04EEC6B0023
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 00:56:10 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B24BDB73C7
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:56:09 +0000 (UTC)
X-FDA: 84144440058.29.175FAAD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 40EFAA000E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:56:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PLbb+9uq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W6ykTfMk;
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763963766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v9hPOzFI4z+MKuI1bEO4+v7k515veTtQnSfR+/5BuqI=;
	b=kMVX3+XVv4bVSZMMjeTxYTlXpXk2LHjwgBleixYSGrE+qGe6c/HFovPv5AAhSS7ZWIBkSj
	70nmAd6YjTBp5dsg1Fd8h4+7jhwGrrZL5kDKVLmDnexO0olrg/7ZBhI63xRXBKFYaOFDCW
	FfqamL/9b5utih/WwqUR7tUZ4/qZjnM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763963766; a=rsa-sha256;
	cv=pass;
	b=Vb88b/tgRlv1mWWc8KJNZs1bR09o2zJy3jkjtv0gGRODJ7M0gHtLQ8u8Yz4764gc7KW37V
	dGPeNLYmaOypgE1edgyxYKSZkAHaN3FMBrLIIiVNkEjDRHswPDbSu7ZjjcCjHUVsK/geNK
	zTqFJeVyEz8bwrDGINk5GXgDFFGLRt8=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PLbb+9uq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W6ykTfMk;
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AO3lsDb216427;
	Mon, 24 Nov 2025 05:55:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=v9hPOzFI4z+MKuI1bE
	O4+v7k515veTtQnSfR+/5BuqI=; b=PLbb+9uq29NUWufvgUoji+Rcf+e6R1oNHO
	zKvGmAnn8ol5PMsVI34z1migf6iGR353dvE8JB0LjRAFTCI0YnJ8kbPwa97f+yNO
	l0OF/ce3PMtUjGuUTTiSHcmsci1pu8WMNk8xz+x44MXXRtZKHrSVy/kMeScM3mXd
	CPw8Qps6ILoWVNiN6ORw2QDK3Qkl+nj+/t2N8U8s40Nc8HX5LNhyJN2sYhAvTIfE
	eyPooND7vyem/j5igwuoqLN2OOj0V5GNuKKtuCXVmW+Jh/XuXRF3L+PCkJS+QoRE
	A78c4R5DcG5o1tf5q4c0MXWZXnuCvbTMijQo+Klzc/+xlnMQ9ufg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak7yhhde3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 05:55:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO4aUSe029740;
	Mon, 24 Nov 2025 05:55:57 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011045.outbound.protection.outlook.com [40.93.194.45])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mb7b89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 05:55:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f9Dz/mWkgCzuLKuI+oLl+IDob3j6+cEow71Nd4PT5eC7PvGfMvBEwLYb+jdw7pB4xVsoy+kS04RHV2aKLAzgz8o8vj/CXE5Pn5EfLrxSnSTL1w/9aQIOqtQiRVRZKflQ8gFYOTvJqSBpV0mHRjW8VPaZoqkg6KldSbSz0f3MjrImv5kALntVrAIzMU5cY8fPRgXyjk/7g8pO5FwEji/fBGPz8WjK17YQcbgxZwDiwwZOhwK5bemQCbP9jJ5652cdrqra3CXbZrBCrlxdZPAldX/GxkccaZnjpBny3jClr7lEAeZYO5O5EC+gQYusWx1lMBif3bBaMqqTfQmImFEaPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v9hPOzFI4z+MKuI1bEO4+v7k515veTtQnSfR+/5BuqI=;
 b=MOjNKV2KaKS9OfJwgAaAYUBNQMdShKQhft+zf+g441i/J2foJj74YWfgF3YEAZBJH6xpHzsECDLpdjmjQyGthsNwBv7ftCCBQDpigdwqj0X8yX/BzCdkJYnAVm6+miUbcX+Frj7DqwxPAEE5BaD5jEGjjB7M+xhUvS/i2UjHALvfK9Kn5OzklJSlbmH84QastjR7kDJZ9+IurUCcTZDkd1d8J/fuTbrFZtPa4lNM8Vg/y9qtTVeHmsg55oPyeqdUvYiFxZRtGHLSUI68xlXT1uwPavCQPcvhEmiP6WvWYqP4WKCr1C7gwaeyZ140fD+YTcICWG3eX+VQVlvtWfVjdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v9hPOzFI4z+MKuI1bEO4+v7k515veTtQnSfR+/5BuqI=;
 b=W6ykTfMkArF6ILM4ORYokx6exe/Dqa6wPRJtHilZ9kRq2ZYbQJXDwvtKxYfGeYe6IQQ/cTe59hzxkR6IrcNDy6eV2beLtqIDsGjCGbcoKExOpUDvKK4aBsmtAGzvA78PAaAgV2qveg9l3GCUFJQQJL/kjWqXf/SnEO5jBdT9qKk=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA1PR10MB997557.namprd10.prod.outlook.com (2603:10b6:806:4b1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 05:55:54 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9343.011; Mon, 24 Nov 2025
 05:55:54 +0000
Date: Mon, 24 Nov 2025 14:55:48 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH v4 10/16] slab: Remove folio references from
 build_detached_freelist()
Message-ID: <aSPzZG7nqfyamMgX@hyeyoo>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-11-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113000932.1589073-11-willy@infradead.org>
X-ClientProxiedBy: SL2P216CA0159.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:35::10) To DS0PR10MB7341.namprd10.prod.outlook.com
 (2603:10b6:8:f8::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA1PR10MB997557:EE_
X-MS-Office365-Filtering-Correlation-Id: a04a649a-5303-4873-2005-08de2b1e2144
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D8xgDdLrSKq2fbX8kqiXwYgDqgz/o3sRhduSqJoSmyqJsKchMlU1fjWJEqT+?=
 =?us-ascii?Q?mbfpgA7fbCHOon0+jIACwqJHyNiec0aRe/x2JIX4jQs6cbpnpyWcG0HYcTOR?=
 =?us-ascii?Q?b7vnURpGo4SfaEAyx+QzRpldz0x/l9CTeJ9gzWyaz0hQMSAlfWmPVlZAHM3+?=
 =?us-ascii?Q?XmmCf/UT9eVqFDLpKFbcis/RpKlQVW2ZnZ3ro+NwuBvN2x6qgxqhdJD2cI5J?=
 =?us-ascii?Q?12eF7XqtYTpqE5ynNtYySzOVwmYyTK3HrM/9HtNpR4VFS6lXxmkflyIUcDbm?=
 =?us-ascii?Q?jCzr2d+0u1wd9FnfJzsQxyz/FyYoAPZ5/11KI2uDjHaIIR2AO+5Rk1wpxhBc?=
 =?us-ascii?Q?xKMsz0zizQhuoAUiHmGpbQxUbw1JXq3jrC2Ao650CR13DFmMl5flyhShZ/BN?=
 =?us-ascii?Q?WoKZemLNtDroFQ+/BR3gOCQpNCixd+0U9P3QcbffAfMDLhb4gF04PosoUwHJ?=
 =?us-ascii?Q?YaWXDIzul4otm7euTm1eu3JShATEJJsM6MVhyXHTLsXaotmNpYxxRHXq8l3m?=
 =?us-ascii?Q?a336A7/V6WN0gO0FDeh32Jt3KP/Ei/YKkLCeePdCTC2Ml8UWDwFVAQlTxde3?=
 =?us-ascii?Q?Tyx/13aV664/1QClfYZ+zuU/+8zJgmNNucMCgQpyLXg5pTLl3lteNhji8/9Y?=
 =?us-ascii?Q?4lspzh/SK+aEIFukgnso3THjrPvDUMOYjqkoPjW08qtaZk47GjQsi/1Cxcv+?=
 =?us-ascii?Q?ShYA6YAEk4RFJnGVBAb9m3DoyCbA1HoLco27mHokfBIaCW1Rnw+KMp960tay?=
 =?us-ascii?Q?AX4n+uLxzVsLx20zCmXZ7LWen0/LqY3UlpyNVm2z12PcQL2zY7MynIpW6zwk?=
 =?us-ascii?Q?Bsp0QJ0eD4z6X3EfzJrEaKmbA6cbDfyOouJMYGBrDt8W4jg4UPu1qtDPblE7?=
 =?us-ascii?Q?yYymUE1fnPwoDIXRn5bc8nHauOgz3Zx8PmfAQzl98MBbh72gNbp0nmH5bnv+?=
 =?us-ascii?Q?E25gEtQUqPVMZ/0SJZOts5WpGdcAIplmz1q5pJyGndcfFVybb0+Auv4DeFgd?=
 =?us-ascii?Q?cJfVXhNY276tg534UF/hvsyhfh05C4QKFGj/XpOqaFNrvfIyajsQRQN+c20D?=
 =?us-ascii?Q?LDXCAOKMnxXtP6DPKO5YsvbHryO26ypC2KR0xvFuedhmHSQVydzB4Bntc1ji?=
 =?us-ascii?Q?n1WdZHbvceKrZO5uc/QC+oPa8s0RIXxfnp0mWyw5bNvR5u2ZUIlR1WxFdMBy?=
 =?us-ascii?Q?v5mwkKPhSlYVpDdYerILgzF2LdU6MafEofDV8t+Lq0nfpSAfvib2DqW4Dsa5?=
 =?us-ascii?Q?5j671t8o5rUq5DnKfJWDM5IYLKxLwH+n1bVKXvzVsYNBz0vpVHidBCn8+iZg?=
 =?us-ascii?Q?0brk5p2+Of+nV0ANvJv+6AnCuI2sPR2Lfy2HaiUU5D18n9T3ItBgg9pXxQn3?=
 =?us-ascii?Q?xfrxRJAD2P0VggbWoRx95vgKl84uiqoGrrIxcRTlNo4r3XXalkdq4B+RNAc1?=
 =?us-ascii?Q?d7vUbn92VlViTvSMgYO5oJJ0lastszC2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XgBwV9ZbAG8OHNjtTeCSH/zXxYlQCMUXbymw59DhgNTXmlgkHIHhwJm3GXAS?=
 =?us-ascii?Q?duVrV7Fgq6kvW6Q7/I43h67J4mLxrjm3dxdckFlEO6Bw0sq+WzGioMJc/Lxx?=
 =?us-ascii?Q?XRlnq0L9ygGoI5wXZu8Cgda6Qhi5j8Qk9mVEDug2K4htwm9+CE6sXYSOejnM?=
 =?us-ascii?Q?8ha6fvv/A4IMm2FJ1s0GZ/F9eaTqXSpH99TqAoPHhVoLhcD849ciWCfMYzri?=
 =?us-ascii?Q?5WQPhRE7ZqP3V4FbG3jQ8Wc2d6SGTG/cMv8hzjNJUL/rJQg+76B404lcLSNB?=
 =?us-ascii?Q?waNrTd7vnYj2xc/cAwMe2o70dfxpga1e5UE4j7dH7ZVnkO8ssA9b0gFWe/dt?=
 =?us-ascii?Q?iw/rIfzBjbClMKvwouTY+hlhx92k3CFKwxoc/XCtvEXO6K0x95ko1oTHSqKz?=
 =?us-ascii?Q?kZvYsCdwJgfi0dI16uY13QU1RiKMlg7iM2SWs/mTJX1ZRH9vqt7LyIyHegWt?=
 =?us-ascii?Q?HfPBVW48rOhfANWGpcRDx6OpDoo0riJRKwClvXWrgAufGNxHAYoi+hxk4Cgq?=
 =?us-ascii?Q?LZ1ZHVrWK5YRjRZba/FxOIVnZHK1LdJcMDYtCAWTeatzouHZAaZhr0N8oIUw?=
 =?us-ascii?Q?LGVH9EHnI5QBqDpHAFsZZviJwQr24zaO+rkzM1b+bmj8aDsJcAurop62ioZ4?=
 =?us-ascii?Q?CWPXGB6g4BW7ahJ80yhnrMan/rQhwoSHeay4hGPFmVTNb5baMWQE40GDPQvz?=
 =?us-ascii?Q?wP60gP8blaMUfJjRIfL91oZn6+KBtg5VNSPqtBWREuL6nkovBnPx838if5dT?=
 =?us-ascii?Q?F6h4yCeFDrFSxkKh4TwkYYpF5kkYov8wNMoC9o4AmplpoBuyMj9yaKBT+ckK?=
 =?us-ascii?Q?K4LP11HundNMARxwdLMliLDRk80xK+OpLNTi497msXe7IsO+G1DvwiB1suYm?=
 =?us-ascii?Q?8c8ofapIJffzuWWqVR6HZgTJyae5bzVgTS/PC7TMFPNpj12yWgC/K+Lj26/x?=
 =?us-ascii?Q?ZsxPnRe8LirKwJzlBjzs4pum+tVPgQ76qU1x7jgvO3Us8TJ5XHP7iepC6IGo?=
 =?us-ascii?Q?dg7WmOy/eUv1NuYr4Sj5PV3dY6DIN9BnVVsna4n1BOO6pvyaM3zNEb1awSiJ?=
 =?us-ascii?Q?EG8z8N3vFI0t5bUeeTqkXGMhtOyfo6KDeRDiuDBkdKbKNh2f5ARufe4iS44J?=
 =?us-ascii?Q?G+Opgw17b/vLXC/XqDpy/QfjEcWp7FpQJzPz4rXYTACqFTU6QsRRXKfFZGx1?=
 =?us-ascii?Q?3Mfd8DvB4EN7oKFqvROJOa1fQJ2XNkFrM599Me0vB2DJCVwlI8bVo+76k6ez?=
 =?us-ascii?Q?KcAdLkenoTT7K+aZft2aE2CLxMbxtZH0mMYZWYAJ1lwRIsmhYptfMQFZcuwk?=
 =?us-ascii?Q?MGuyDZE7Wdz6k1/7Kq1ozHDmbDLnqlU3bLUp9Ffl5ngo8la7CbrAq7f9DaIh?=
 =?us-ascii?Q?q3OJbczX2fBEYWjZ98w8D18vvtgDvngWgWhNi0YfO+4UHXC4w3igB2hs0ALM?=
 =?us-ascii?Q?rSwafBnYWMWdbBM3QVwIob9iPQbzljl5jZvEhzeAyGwldKkOX8Q7ylfH222a?=
 =?us-ascii?Q?pK+UF1wB8JMOLP4QA2akfxDjKbK0ZXqIbaqEZ/fU1A+FMhQ3pwL0Yizb4mdl?=
 =?us-ascii?Q?WuzFfEA6Z2XQs8IF19CLjWUed5xZEwTtaj0abLfr?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	h3zcquy9dAXcgmTZzoENZuVzF431YfdGsd2Eou5KMjkco1vfaqSKoNBCff143C5L1A/N60VQVY+cubO6X9O9t2DEi4aHs1/hwVaj6X/gL5KJUEMBRZMd1dutMeCDpoYcL6D7nd6Ktd3C+IMu2QU/iAOdNnu/rotfN+BcPFm07but7aBl9EK3Z6BT4gpaXYOoBO4OKdr41FUBtINt5tHd8Tn6v7eTQF+TW1L+U/SzTYwaYoc0vGqLz66XvWZdSyZn4JEmU5dnJaPDuxVKAH2UZlnqh/Bcp2RRE8uCzBCPRr4RwYyX8AF/CqCIzOnzK0HjGJjZNwDqPVpZKy5txiAwTfHmNlFUpmnYBgCiGxwHil+xWyqm0EPJtneZycPt+jj2H397CRgwNeyJWmdqn5656bG0cexBegSCELIughGIL12fhJo9JtEt/Hd2H7vzS6Z1MWKtVny3NQxXqcLD2wpThaE7N4TORj2rQGw/wWi54s6l61tay1kmXSyPe38XbTwZlYJOEKbnzE8FP94oM3staU9k30Nv9vdUdxM3iHbXk7Oqc0REwr7QYIqSWKTM/VAzH0y2/dOH4hA7Si/ECa4WJckX2RVoH1zSVAn8AmXraC4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a04a649a-5303-4873-2005-08de2b1e2144
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7341.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 05:55:54.5640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SE2PXIFU80pcPWujW4EHjVYy7VG4oVjV6f6OECMb27Bm+m4lG9Q5qQzbOWXOT0JXOAF00eMyoJPvdX5zbipbhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997557
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_02,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511240050
X-Authority-Analysis: v=2.4 cv=L6AQguT8 c=1 sm=1 tr=0 ts=6923f36e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=udIUTaqqjkO_CoZl_tAA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:12099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDA1MSBTYWx0ZWRfX4xsbOMjiu/xa
 kHP/GhH3gCgFlSwR8HdUou/27SjTkOwRN0pFDb7u3Q4HtdX/IhCoStxa50jsptzRPuAhuuNWLwV
 owRjcju3l6J8j2ibGQePtp+YUq0jGl4P/YAvfOIREmKnxvwXQJBNvSFedTkWFLhH/koQ884mEcZ
 hG3ZajCE7PebJk7G6spdjPMali4+bgznIUru7h1xITTt4265BvLHojubIlwVArXXhrKv0nnmv8w
 8UGH95xxGTDLOjUTdRTUkC29XukwKq/uXfci0qVFnQ97v8ItbRQpXbDc2pVB865WQPVItBF4yoV
 R1MfzH8wWHbYUpemzGaG8qUxeVghtlk4r2m7niw44osrrc6TVbmSNKd/E0ymoDi5lOo3haJekul
 +Rc4aTAaRnVUI3y1P3ota8n6c2HOM/cg1UkzLlLFjzbL3ovBoXU=
X-Proofpoint-ORIG-GUID: r3M4zxoaRncpD4HXwUqkKeXvM9Q6TwXz
X-Proofpoint-GUID: r3M4zxoaRncpD4HXwUqkKeXvM9Q6TwXz
X-Stat-Signature: pci3w3h58a8x8tjr4yre1wszj7631uq6
X-Rspam-User: 
X-Rspamd-Queue-Id: 40EFAA000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1763963766-875328
X-HE-Meta: U2FsdGVkX18Uy4IujzGApT484IX5Z3bmJR8sPHzqAlGS8YWOxjQlMIPiP++gqY1fErAUMvmU/9yul9juxQNXuMWxCYoABbbrIN8VnnsupRoZ9QDJje10gL9VySqu3HFJyDEr0/fMuGauWlKesXlY6nmxb0vRtP3mXinx3DC8j7tJMlHaTyRlI0IiuzEYUe+8+ADzR9sq2UOgiMw2j8nXZAVYFkU4jxOmLmFnfSiXrqQSHHa615KuNgIqP3V5ZfIwvCKQq7sD6ZnUYG/NNbGNiCsSPT1g1UTSY4pQ8NEXKswSD/PSkvEAWrW6gANPRFkhAUs2Tze/fn5L19KxHBur4K+yKF1onD3uVkniUt1XYdDbHaNXP4HwyZYDJ19dh8xGlCU9D/tFozymgfQBxICSWHPGPYbHSVhAAz6yQ3DfShKLDS5/lgIzhh3B99JRWT4mck7/TyazCZmxznabFTLGj8iti5tQx2JEmU2vkpV8U/qbF/iJ2/2SF2BN8xYrfSz+7piyAmeswqEj7/M9Xxx7RdZvEUMqw5uC5XEK4oJnUIqciku5bcsxsiOQhECHbRvg2Eel4CPYhlSv297hCjrUmdfyqa2xYXHQm9ebU6wp9RCus0aT2Z8Veloz1RI2c/eQGA3GqlBtf69W5uVAVdd6pUf4yoq41FSB/OdPAyRObL9AiymcES4dUF09LZH3YEQOAmt14jApykPryI/2FT8TZBl40/oKMc3AksqotPRChW/2XmPb7V7hLImSDTmukdaa48RlnQurArGtmX+cMn4nIDoEApBQbmkSvRFL+ece2g8cUseTUdWrisb/NRXnWYvL13N1ixo1RoquT5B0WaJvnajjxTGb/lUuSRQYF6i1CVd2bh0I1jdYGDcgDHEpE37n3jG8j1BDRs3XFudtA5uh4p+OGEsN/gp3r/oTsrR/caJHnSn9aNCSrktEBYqUyBOHNo2bppJ/pxqc/t7Ao8s
 g4OChFM9
 snfvhirNxwIwHv7VsvL/Eiv9VW/T9Ngh/Swz4fSeBfZKkwV3FYkCCU0AHT1ERJoIkSI9bd8P2vBhfitGx84hTdRwTuGK15bQRqySGq/cr3s42mZJKIGWWSITnJ90AwijQdhrZhad5yMni5gvhtXLmqvbet/h0zKb+EyAjRKf7rbS8o/U60+lp/nWZ5ninNCR2diUCR6qho5enImUC54rkBQkXZGBdqpt+ZEtLzGLdiN9YtEmY883Jzpvh5la7msoTBfghijXWiKNgEzoVLEH7jf9CagPsbTuomA2X2ruzIJhGmNetf+s0rceAPZhYtMkW2F7IeLe5lZrHtdHShbmv3+IWeTwa43o7+tNi7LTlILShHFKaDTjloXkgov0LNEvwKtgT+lumDx3QTCWQwnO9HD3ryXnm2SJA0vWnbCGflbMMnZXLQf0LIryRxlaKnAFCb/sL2TmYawQlWiYTrDDSjAcw1mYfNpN1l3jO75aJLnMGMQZkCgwxtakKeMUb3P08M/1ukdUS7aOwjzRmePDew0O2TLM75noQBVysp/bJzjZ5Biqw7yzpNY3BqGmQeb7vzcbqBB7msC9UggfBCqe3Uu1gAbBdmdKsx98Qw9SnpnZDatZH4J3m7vL8r9uMvaSpuWBNiiOFAPlMxfi6tvkGZFhigSMFm/IliB2slQpLmsdevsFn7eaR89cn5ASVPYtU/XXijTTpNF/WLfSljqFmK4h8UkPdRTEiZ4R5YxZTrVqjKuwaU5SDL928woOJiNL0aICtx6lpPynIwYHm74jJr0F0Di5dFzjpynal
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 12:09:24AM +0000, Matthew Wilcox (Oracle) wrote:
> Use pages and slabs directly instead of converting to folios.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

>  mm/slub.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 4570d1dce271..17b456f6fd4e 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7297,23 +7297,25 @@ int build_detached_freelist(struct kmem_cache *s, size_t size,
>  {
>  	int lookahead = 3;
>  	void *object;
> -	struct folio *folio;
> +	struct page *page;
> +	struct slab *slab;
>  	size_t same;
>  
>  	object = p[--size];
> -	folio = virt_to_folio(object);
> +	page = virt_to_page(object);
> +	slab = page_slab(page);
>  	if (!s) {
>  		/* Handle kalloc'ed objects */
> -		if (unlikely(!folio_test_slab(folio))) {
> -			free_large_kmalloc(&folio->page, object);
> +		if (!slab) {

nit: unlikely() is gone.

> +			free_large_kmalloc(page, object);
>  			df->slab = NULL;
>  			return size;
>  		}
>  		/* Derive kmem_cache from object */
> -		df->slab = folio_slab(folio);
> -		df->s = df->slab->slab_cache;
> +		df->slab = slab;
> +		df->s = slab->slab_cache;
>  	} else {
> -		df->slab = folio_slab(folio);
> +		df->slab = slab;
>  		df->s = cache_from_obj(s, object); /* Support for memcg */
>  	}
>  
> -- 
> 2.47.2
> 

-- 
Cheers,
Harry / Hyeonggon

