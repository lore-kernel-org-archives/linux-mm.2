Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BAD6D46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:37:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 907786B00B6; Thu, 15 Jan 2026 14:37:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 889926B00BF; Thu, 15 Jan 2026 14:37:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636AB6B00BA; Thu, 15 Jan 2026 14:37:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4DAA46B00B6
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:16 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B73BB99E2
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:16 +0000 (UTC)
X-FDA: 84335206872.30.42CDE24
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7C02C40011
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=siJEhBpW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dtiVbhGP;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505832; a=rsa-sha256;
	cv=pass;
	b=rbm06il4bMUNnSvESy6/xBsvtsqG6k1gQ9mU31fGGnhxVnfNqF5dTfBLfaMRXJ7EBId9Am
	PIkD4IhMhGHl/d7jk7eNd7a3P/CtAED6rm5R3xfzouFeDBX8Idz553s7j8dOhXffu0wF8P
	TQs5G1IC29MxtNeuHsnIgqnWcRiwiT4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=siJEhBpW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dtiVbhGP;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m/S8Z0WMtUiSILXjuzfxu0ZIKqnpBq5lOYWZuelb8wg=;
	b=2bmoMiIY/W6xf65ohmassAI3drBU80eu6tZPNhlgp1ywJw9bdlROkbt5+cUuhJ6t66QA6q
	+3HnShn8mK0bhQLEnSLCN5i5eUGI577TFMiD6O9wwfRRwU77uWKcJKnwqm/dAoLWOfXq1h
	hr3orN4OJNmZjLylHpHFBxVrXnrNAks=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FHRm4C2753713;
	Thu, 15 Jan 2026 19:37:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=m/S8Z0WMtUiSILXjuzfxu0ZIKqnpBq5lOYWZuelb8wg=; b=
	siJEhBpWY8fJWRR7Tk3UDnIe/bmbj589FOVBrw90Bci7CxLydX03HSZGfTuP5eMy
	awYSpT4VtxmujnthMh/VjwjxCWMBfqXkJtKg38eNtzutQuzDya1TLcWDJBsurKCB
	/1pJxkARVRL6JqqgCyCU9n7BU2O5A1O6rzn2jsSvQo7d4uLpOMznsow7q++pygWd
	hxQgKTSZN+xJBb5yUn/SP3m7PxcexZISsT/EAFSbNgUsvBlrjTtygCOYkYeIt5vx
	GJCidQyAY2CXFLpYeWlg2QcQ7wXZMjaLB+szoBaud711Mm1kmfnQOl7wQ/hPwodI
	QjzaEMq2N9Wlz/dQ/PHf9w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkpwgrgdh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FJKQPQ004292;
	Thu, 15 Jan 2026 19:37:00 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010012.outbound.protection.outlook.com [40.93.198.12])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ngtwc-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FH+DJ6VNX13uAFD3WnPSyDONH5OSmwBL/PLw/SjI7asTMLN5m7QWU5i8LgpHgjWzWYsDI7eYzQOFAj4tKGOjnwjvBS1JZGEcUIwonNZe5gWccTuW3kfk660gv6O4Is2QSbqB1WcpeWg62Akr07NhbrJ/7cqJ+1TLKRmhhd6JQCS5rdp6RTx2M7mGwJ92crojr5ELBQSD6WxFOjpteasMbyxtHC8P5H7VxMTSZ3yDNLhViCu1OH/DeK4pAl04JI48Cchkr/+EELY+mTj/8j6GvObalLGvmnRPdcH/SWRcx7K+zAGjj7KV0Gjwvgxa1PkR9T+njH8+XaWL4mVOz3Lswg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m/S8Z0WMtUiSILXjuzfxu0ZIKqnpBq5lOYWZuelb8wg=;
 b=vaswuNU97DCga6sGpIldDGDnt7U7/k4cH35/x26wzDCcCnBPsecj8c4XL1uXOQqrUVBS7Gey21PFCbesU8RJwfqsgGbsxDUBim1ggpRilgOyxbF4on2bPMjL4PpEJyufWUy/Pez+6Fsoe+qzgAh4IpY6E4dVo/ZlvJs8SXH79miNW9DB9IwC4iGV3g3MrYyfRiGmy8LxZJWF/yhkZP/grNmsO5UwzpFPK1qtuhhtfp8wLZHvx6k5c/goJD4og+EJh7/mGhxZXFwsMgfSEJl7Sss+JWjhixNu9PeHodGMd/NvD6gVl1udo1/Gi+ncDL1WViWejyGOVyyaHo235RjYpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/S8Z0WMtUiSILXjuzfxu0ZIKqnpBq5lOYWZuelb8wg=;
 b=dtiVbhGPHo2vflG+/lkeHIUnutKLNDqBBqv9bLAT0RKu01enDHarvQ9p73g2Y2Tz6xM8V3D4cZd/MDGe8qTa2fBPyEeADRAcVZeOOt4s52wo3/9JJfnVaXM0mZLleCP5uV+w7bZvtFrLQGWRfV8u7jcU4+bZGgKOld+1RtbNJro=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH3PR10MB7703.namprd10.prod.outlook.com (2603:10b6:610:1a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Thu, 15 Jan
 2026 19:36:58 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:36:58 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 01/28] maple_tree: Move mas_spanning_rebalance loop to function
Date: Thu, 15 Jan 2026 14:36:20 -0500
Message-ID: <20260115193647.1695937-2-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0074.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::32) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH3PR10MB7703:EE_
X-MS-Office365-Filtering-Correlation-Id: c4ce4ed9-e321-453f-aa90-08de546d726d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?H6VFYz2kpJoJddxl7pbqBnkQEaAyD2r+8CRiv/XVEXGDyb7mLq1pUJI4HEoR?=
 =?us-ascii?Q?HPui/xr7E49wcKYBFShTOG0XfmZzP6D18JtT1+n7y0K1uNxOpMSb48qX8h3D?=
 =?us-ascii?Q?d34LNpkIdjDudSFWV9dKBsu9znNH2EytekaUGQ6IQn9UsOo+8sOlnWZ9G3Rb?=
 =?us-ascii?Q?EcXwJahH6am7pqoixqE5cLrfwMBw7u+gVEG9sj//7MNVNZroPP7vgaTARdEI?=
 =?us-ascii?Q?GclwjJKsRPiMAjxuuxUjRpurgUlHxJwpc8WyR9Xal3pLlj2UK2G7IBs2ibV/?=
 =?us-ascii?Q?NSUorb4EbUzHG4u3xXGJGB2dfFgTbXeEZrEVOS+4CFK5lrV7s22vdGQZoq6C?=
 =?us-ascii?Q?TYNV11lfQHRgaR60IY/ip8QdNZhLqkXXW/MLwgRHP1ePclvekfKidWyD++p3?=
 =?us-ascii?Q?BuxbAJBwlUSzRCq4dP4bDJ2Dg5OgF+CHXVa0hdht+31AO0WQeiDRk9KJpogl?=
 =?us-ascii?Q?+TrpG6KXBDyiIk/EIQh6fAlngPcYjFqQF8Tjo0A2qfQAJX6rESyMwxGlMhlQ?=
 =?us-ascii?Q?ob6PWJ+vONiKSMWEf+by9GcKhFbBbbsg7U5bv855YCEAGIAFsWfvp8TNFSKw?=
 =?us-ascii?Q?smDVlwtPYjIG81mMg8wD0I3sIZYZa5rSu/2ZoC2J8VKsrlElInXhyjP4fHFI?=
 =?us-ascii?Q?4RcjmA+XAhhe7bj4VXPhK+ltNzZiwMSyw4Flgh2ksYOg3AkzYu0UNhBSylau?=
 =?us-ascii?Q?4oNbFeEbQjHRvGMiI1iSWslhbV1p+g+dPo9YRCVFYyDskYXEk5mlna9bOJx+?=
 =?us-ascii?Q?hWyRPXLDQU4+4LaowRE+fsj26R663tW4qEx7wG2iTKrw88J0XT4IUAbEKW/h?=
 =?us-ascii?Q?33WrWN11JNqi+5WB9vAW7Yc7tzjWNloP+xAbp6LJGAyPzkFFmLdDRqesyGlH?=
 =?us-ascii?Q?YZy4UNZ3RCOYQCqMhw7T0pMynx6aQlwpSTxOGSxXnDpo5WFZ4mRwo4mJhznK?=
 =?us-ascii?Q?mhd+W7VFlX+Wv2wBUsspeUc6rto5UWInxgab2aw0FZ9Jmw4Jq4c7PceAjNod?=
 =?us-ascii?Q?i+xKGXc1JjPrVjNEl2HO5O8HAHLcfQdmIWlEl0rd0LkIgMcay+ljtwJ7BzQB?=
 =?us-ascii?Q?7Lk4rq9Qtqe7cIjes/lH9+7+9Z9yIzx68SufXnRcyw5/AI136bXDy5uMjgPl?=
 =?us-ascii?Q?ZVKCVhxREr1SYPplFYbbsPL2c4t/tpjZKb7pCcZtXRrj2+vS9xkvSOx0Td94?=
 =?us-ascii?Q?hZK/ghqV13JTzMRpyFjZFLM0lB0MYZyYgnh4tBM0C2tRqRXpLw9tV55M8Ft6?=
 =?us-ascii?Q?crf5+hhOzJPwD/8Gv5Jeb9zQwR9CQpGYRnw8+uJRTMXfS65wBljBg+ueRH5b?=
 =?us-ascii?Q?NhoWLeGt9azIjVqdvlzss6rRgDfLfL9nbFuI3rGSL2R/pmph4WR3G6ZHcaaj?=
 =?us-ascii?Q?8SWwVB1Cn/XRQkzJ9+82GI+sqi5LcKohfXaXQoB3WlpCgfiFpKBUj1MAIFla?=
 =?us-ascii?Q?8luHPqkJpvhgs9jssjVZnOGPV1nZxAyFRgYwoLLCUXt+RS+YHMNeqFWPhW1U?=
 =?us-ascii?Q?bggj+W8SGjoNxfauiIoplEP40si2hzaCkH3wpkg6hxwHcnAGpwPAuypw/Dhj?=
 =?us-ascii?Q?qLJrSya1YdnjU322yl8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5aoQz/3T44iOoVNTJZMuYCI+lpT4ZlAH2KkNoyn9ZTEU0tzRO7rz+hW/S+nP?=
 =?us-ascii?Q?69/81+IS/4Ku3X4WGhHzn/0TFOafK+/+enp7Ym0tFPjdmMsqXiMcmOfqaVYj?=
 =?us-ascii?Q?7xlK8NUhm1AZMNEohYc7ugfQJrFWYwQyEloajyhKALN3HW5il+R4Zhl1Ss71?=
 =?us-ascii?Q?s3IvnhifdTS7UREDfREEKdo5rPbpdefGso6qMoIOArrQzfFAny1DRly/Liqn?=
 =?us-ascii?Q?l+WAwMK2qVmx0nu1JiHVumA3IIJTArp03asNEFCRi2K+7vsj4vZOx1iGO3jx?=
 =?us-ascii?Q?uc1kN9CyCcUJJyk8NJEdizvyswzFzPEM2cUAJwCGvsdIJP07PeUHruEnk4f/?=
 =?us-ascii?Q?K5+ppbcIqaRHwLVlz5ujG+oBPZWikiL0Nx4PuOW1bzt/qT6sis0KHsyDD1kW?=
 =?us-ascii?Q?FQf5r+1Q9FK3lNbw6E1p5qg30Sl1kMv/nLCdFRgmhuuLfA42C/pcAIKQAnI0?=
 =?us-ascii?Q?s4N3qlmLT6+aMbDF2DL4LWN+DUGdO6DMd2yXqkSf9CPqAskHXzc2l/pAWrOn?=
 =?us-ascii?Q?i7tZ5sbz8i+FN0//a0JcbM4dS1nZDPrmtIX8aJL7KV2LwA9dJa/JlsPEJCYl?=
 =?us-ascii?Q?phXvRbPNz6KB5deSdfx1xrIvrgM44BY7ThHRV0VmdbDeIg83Um2RpGTph7Oa?=
 =?us-ascii?Q?4vRFgWq5g/5KBwQzudSOsqYRWueQXbWJOcIHE27wEWUtJpTJ7/yurFDop+h8?=
 =?us-ascii?Q?Fnkc7W+5Rz0EhNa+MnMj9PgFTHCVUcW8f4FgC3OLYhi7zrLPdjzZF7fJ0aQZ?=
 =?us-ascii?Q?mFmnCF/Mibe/Mdg2wM67jyhTOwST1vSiV3zzi2Chezvgr808/8flSMguH7pN?=
 =?us-ascii?Q?4rG1rkUdak3HnCQu6UwKcWzqDAM6Dc2fZ4NfNeoOIvOK07HmGwc2hRDFFz7v?=
 =?us-ascii?Q?U0HXlzPd25RgcPRf3Weqt24o8t0WXkDfCUGLUZPwhu5iuTgJbSsb7aQ52N2J?=
 =?us-ascii?Q?0Qeh48c8yMfv4CanMjl4RcztoeHC0pvZmml/YHTJxKMndGRBdJ51cPKCIlHn?=
 =?us-ascii?Q?dLcUTHioUCDJ5DSUfXfRBAPK5YqwkmtgDty8zgbzyoTtek5bE9EQ2XnG/bzi?=
 =?us-ascii?Q?GUJGRQxNRfNmQ1v8zUZ1jYk0oUMyRKGfslBJ5wGa7+WxgHkQkJA8j+uL03wb?=
 =?us-ascii?Q?pHP0/8NZEvU+dRKE7J841s786Fim49gSjYzL+qSIKNprotMUfPA9u0wmXA0n?=
 =?us-ascii?Q?aZM4/QIUmqoJfpYhSrJp2BTEzO01Ytw5fhJfzH3bbj6NnqtQd0XlINTJ9Wt2?=
 =?us-ascii?Q?zrMNM6gIxegxekKgJO6cWCeeZUC7YtCw5rgZ7rIO5dR0tBHGHeyF5BAbGpTv?=
 =?us-ascii?Q?n5URUxh+KBJczpdPFeuTkQYeZS6A75/UOflFUcGpo4JiI4u7vV34tSZPNO4V?=
 =?us-ascii?Q?qioRf5r6y2LCg75cEhSiDmcqrMOAxYa9GeZAmG2lcdTrfHyS+QNygfnJJ7m9?=
 =?us-ascii?Q?ltwxPIu6FOqBnXwqwQxyTZEeZJm2BSZ9RGf4VWQww9EW2QWq143u4z5uiE5v?=
 =?us-ascii?Q?TlAwInseKVIbk+salo5sr7F8EQ4C14xG4SARWIw2pTXlhg6ytU5ymyZd26+8?=
 =?us-ascii?Q?STVMc1wFt9xsxrRZS/v5/E1gO18QxW57vBekh+a4XZuQd7SQQDzRYrNKl5s4?=
 =?us-ascii?Q?QgExaHa9esjG3mpZY8MCylRfrpB23nbWb84+8Mj4zVsEWFCyL3YzBwUvl9dU?=
 =?us-ascii?Q?ITzygy64NdesDUIyRO4u6Q4C5SdoeO06POxN//mfC+xk1Y4P3vdxJiyWgsHr?=
 =?us-ascii?Q?nJWJBa3qSA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7PWf8+8+4USjY0gzx0xIQdKcIkH1nO9Tq8RMydC0xsO6iH/lrp77gMXZeJy2uletiH8/4wNmkoA7qMGtOHEZAzczrFhOW8Cf9AaXy6D/BGg+HqrlsPyoLzkPcz9PMRdR/cYKPWkEDxjmTkNTmpFZLfFf220PifgYaSreuuIo77Ckr5VjiAjnIzCUAfv7/q7v+IHsFvGObJHRY6tt82RxSuey8C4nymvLu81/bDU9R4T+BMRx8yDer9jdpGb08pskDZ8LIRyNaVfOUZRYMEe3eVVxv6mTBsKCSZJvLSPC/CBmKC7F6c3hVxL0d4/YqcThxSzXd5h4hKJIeLGKGlZpw8WN91LG/cOiWwYyRAbsKGCJ3VXPbYQc/4K7n/s2WK3BBvHHCLK50vyVuaLxDs0FiRX8hJsTO1WI0tjKmA3t/McbB/N6+Dy8GCW2Kt2rGF3s17GjRE/IkJjzfcJoam8HJa62thEquXjuVO7mcsgq4weNTpTZrDO2X/1YKyv3Is/igzQ0uPnTKwYrMbc8UokHS4LdZCleGLg+isVlGj2LYsB4MBjgOVXDSynG8zrvWSnz2FeWFX5jOukc7N92Qncq7B0k8wcQTFrCp9egH0J0Rec=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4ce4ed9-e321-453f-aa90-08de546d726d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:36:58.3101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z/OEjoaoc0Kj0dSQxOoR5VNhe4fZRhUrvrMOHG6PSLPxwh9Zyj/O1hhp7eoEn3x871dGbTiUvjY3X3HvXGjiJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7703
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150152
X-Proofpoint-GUID: KybKsexA80x4n7dZkRRRMXSVR-x3I5gb
X-Proofpoint-ORIG-GUID: KybKsexA80x4n7dZkRRRMXSVR-x3I5gb
X-Authority-Analysis: v=2.4 cv=ZtLg6t7G c=1 sm=1 tr=0 ts=696941dd b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=KfpCAqERy7lSuQKxsjcA:9 cc=ntf awl=host:12110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfXxPhuAJafQzr6
 rm7KiW6EZnL+ExEX373diMqt6QINT5bD/yvq07xBByHTQoa7L4Rlz8SOi2QEGEAlhF9Jlcrej5Y
 p9+JjxmTKBF/wWq8DL5JIpowVDfEFIra8S850yj3S5Fm9/W2BXhLIiprvjit/Nb18A/I46Ay5ZE
 CtBsJJNWoE1HpubAWiOnxJPxovdxSnTX+TnswSfsBzGtmJXp49Lr6/+4X9NRqVUAOSydTN6nyr1
 zVb5DLZ3+nbQY/kid/sGGNtCZW/YoowPioWnZFSM4eENDVhFH1M1+la2HBxtP1xt4SwkdGCjcxk
 xL+dx0tT5ErYljC0I2/O56LntNNfNQQh57Ul7O8OzZyH2d5I1GJKntHuqiR36yZmw9GWYJmi+0w
 w6rR9lGbPFhJeG1lTPUq2ndTxbsyyEmRGuLHgcGROdLhj4OYBgUxth5rKhUzHvlH2q5v3ArrV+a
 lszt6f76zHr2KesUHRdyJv9l4p2OrJH+POdTenOQ=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7C02C40011
X-Stat-Signature: grks87wafck3b7gky7rth77nxbcu777z
X-Rspam-User: 
X-HE-Tag: 1768505832-257673
X-HE-Meta: U2FsdGVkX1/p6f0GXt80rjVqBP8P391S78XqtPDigY/E7kYule57pHa/3JE4M0QkU0vHtHaMOy+QIjqUr24G9ha7UZUQf6qc11Zoy7O2Awbvy/Tot2sRRDJGfwZp6+rv9gZAta/yNfX71pl97xbwqyI9ajdoz/toopfYcScwAH6/neQUF5+wBKL1V1oCjdbq+achPcLSNdnxEGkBMaLPgfaNasDIeI9G2xJxPkSGuElmKzi34kekC7ANll+1DCN0jGkYWBgCbNTCjxGpVPTV68Rna6yxm0dtpp3PVfGFdIrUzo78scz7FJ/A+AXCTAbd6BwEK6MMeOexvWvY3i3xaCw2q18CtyU2aBWGVWNu0XvQiuC24q4dJUsMDfgP8znoJ17p6eI/aDybSq8/gzrHd19J1TeKLjLqJxCMlGHI6m62kfZVcrDMJgmtJ4JxDX1L5id+XISLdL2kaGIpfHN1JTn/1VZhkAWduWJW9FL20JDTeQoIm6LBpOSmEAC/s1q8oazHvq4/1EJZre/nEeV32i/Crfy1ZOlAU1QkR51fKIN8KVZt0053VsR8OK2ZM333hB1tkwBCYwL2jbB8jNo1i9akb5bl2YLrXN2Ys+uWiztGQu/+xEAE1HNnh8xzTX66eEsLZcr63se3Dh3jvEaBNORdlmsMsDlObuUOfbpVgsNqKLPdtJ71o4mcCNLPO/G2O/rbLz1mKM4T9viaJ1lrlxfuQ7GwdoSXPPMUE6Kp2GyVkH25bfTmfS4Izhc/ouUF4VMw5rcdtj3uiyJJvP3kvRnSm6R6vzdp15+6zcTzS51jv/u0Ghl6Xe8aYQ+PLyKluPiLZik0Vs4kiE0VT3UgMISlrtCNGOrYbEw/I7WkD2QUDIoi4HA9XHUejuVsMQb/GNdyr8QGWmGxG8rt1KX39gu/qUfiMRTESgxqQoIfxeJ07HEaxOLEjxDzksV7VhDsqqODulajI4YVEHEOIrs
 AMOZcHog
 MEFsS27l5HT8MU+qz0QPfUq1qJl5Bj635x6WWGwZPAJXPpwofwoT/BF5+NcjKUvoAo4tD1ZlkH14VCrC8f959BA7nPfehoEIZ6awo/zdtNuDUi8t2cUCH/PsnygpDVASRjRaHf7LZjmowzy77EV0gaSurZB+rzl1dOtQGLSma5CPR0kaJ2900P9f1hf/jNSu42iVjIoShGQVJpB5tVejA5ph1lJlfbYlX+U0VkLKCc6qsSmbNfs09F8zpAN8GYD8JS/1vNGJeM8mBtQ1cIbdCwbZlq3TXacSFmv4o6IP+o1sMF7ZlvS97neBuT80czikh2Sh2DiymTSQrLcoMITPmr+3JUlWULAgHq+RVcJh1f6bJlAfyuEP8GY/UZGwaFiXDul8WPqoNUZsOCODNAcDPRmOP0GDsu0y5XmgdYTIknOLnyXCNdzM3zIvZ4pQeVutrYdvxyK7q+OXq8HoUA7Bub2w3TsduuAooLUFd4iwPgdeaKDNGL57AqNpPUM0EQIoTJraADpNa7k+FMhPD0b8Jg7dzVxm2hs5mMC8DKK6scEy1mf59U8S6V2mxqNiNEG9uj99CvRw6SsrujSBEnhvASv0Ep6UK2dc3I4BQzdKJTkmlPAhHXxtnuUFsqkjS0mzwpVZfKu5KNJyDHWoXCYCVZ5/VVmE5pWupL+EbN5SSYpJcC36IkKy7aWndHQenKTXrhwx7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the loop over the tree levels to its own function.

No intended functional changes.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 108 +++++++++++++++++++++++++----------------------
 1 file changed, 58 insertions(+), 50 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 5aa4c95000188..5c85964b36c58 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2595,49 +2595,16 @@ static inline void *mtree_range_walk(struct ma_state *mas)
 	return NULL;
 }
 
-/*
- * mas_spanning_rebalance() - Rebalance across two nodes which may not be peers.
- * @mas: The starting maple state
- * @mast: The maple_subtree_state, keeps track of 4 maple states.
- * @count: The estimated count of iterations needed.
- *
- * Follow the tree upwards from @l_mas and @r_mas for @count, or until the root
- * is hit.  First @b_node is split into two entries which are inserted into the
- * next iteration of the loop.  @b_node is returned populated with the final
- * iteration. @mas is used to obtain allocations.  orig_l_mas keeps track of the
- * nodes that will remain active by using orig_l_mas->index and orig_l_mas->last
- * to account of what has been copied into the new sub-tree.  The update of
- * orig_l_mas->last is used in mas_consume to find the slots that will need to
- * be either freed or destroyed.  orig_l_mas->depth keeps track of the height of
- * the new sub-tree in case the sub-tree becomes the full tree.
- */
-static void mas_spanning_rebalance(struct ma_state *mas,
+static void mas_spanning_rebalance_loop(struct ma_state *mas,
 		struct maple_subtree_state *mast, unsigned char count)
 {
+
 	unsigned char split, mid_split;
 	unsigned char slot = 0;
 	unsigned char new_height = 0; /* used if node is a new root */
 	struct maple_enode *left = NULL, *middle = NULL, *right = NULL;
 	struct maple_enode *old_enode;
 
-	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
-	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
-	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
-
-	/*
-	 * The tree needs to be rebalanced and leaves need to be kept at the same level.
-	 * Rebalancing is done by use of the ``struct maple_topiary``.
-	 */
-	mast->l = &l_mas;
-	mast->m = &m_mas;
-	mast->r = &r_mas;
-	l_mas.status = r_mas.status = m_mas.status = ma_none;
-
-	/* Check if this is not root and has sufficient data.  */
-	if (((mast->orig_l->min != 0) || (mast->orig_r->max != ULONG_MAX)) &&
-	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
-		mast_spanning_rebalance(mast);
-
 	/*
 	 * Each level of the tree is examined and balanced, pushing data to the left or
 	 * right, or rebalancing against left or right nodes is employed to avoid
@@ -2672,10 +2639,10 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 
 		mast_ascend(mast);
 		mast_combine_cp_left(mast);
-		l_mas.offset = mast->bn->b_end;
-		mab_set_b_end(mast->bn, &l_mas, left);
-		mab_set_b_end(mast->bn, &m_mas, middle);
-		mab_set_b_end(mast->bn, &r_mas, right);
+		mast->l->offset = mast->bn->b_end;
+		mab_set_b_end(mast->bn, mast->l, left);
+		mab_set_b_end(mast->bn, mast->m, middle);
+		mab_set_b_end(mast->bn, mast->r, right);
 
 		/* Copy anything necessary out of the right node. */
 		mast_combine_cp_right(mast);
@@ -2708,17 +2675,17 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 			count++;
 	}
 
-	l_mas.node = mt_mk_node(ma_mnode_ptr(mas_pop_node(mas)),
+	mast->l->node = mt_mk_node(ma_mnode_ptr(mas_pop_node(mas)),
 				mte_node_type(mast->orig_l->node));
 
-	mab_mas_cp(mast->bn, 0, mt_slots[mast->bn->type] - 1, &l_mas, true);
+	mab_mas_cp(mast->bn, 0, mt_slots[mast->bn->type] - 1, mast->l, true);
 	new_height++;
-	mas_set_parent(mas, left, l_mas.node, slot);
+	mas_set_parent(mas, left, mast->l->node, slot);
 	if (middle)
-		mas_set_parent(mas, middle, l_mas.node, ++slot);
+		mas_set_parent(mas, middle, mast->l->node, ++slot);
 
 	if (right)
-		mas_set_parent(mas, right, l_mas.node, ++slot);
+		mas_set_parent(mas, right, mast->l->node, ++slot);
 
 	if (mas_is_root_limits(mast->l)) {
 new_root:
@@ -2726,20 +2693,61 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 		while (!mte_is_root(mast->orig_l->node))
 			mast_ascend(mast);
 	} else {
-		mas_mn(&l_mas)->parent = mas_mn(mast->orig_l)->parent;
+		mas_mn(mast->l)->parent = mas_mn(mast->orig_l)->parent;
 	}
 
 	old_enode = mast->orig_l->node;
-	mas->depth = l_mas.depth;
-	mas->node = l_mas.node;
-	mas->min = l_mas.min;
-	mas->max = l_mas.max;
-	mas->offset = l_mas.offset;
+	mas->depth = mast->l->depth;
+	mas->node = mast->l->node;
+	mas->min = mast->l->min;
+	mas->max = mast->l->max;
+	mas->offset = mast->l->offset;
 	mas_wmb_replace(mas, old_enode, new_height);
 	mtree_range_walk(mas);
 	return;
 }
 
+/*
+ * mas_spanning_rebalance() - Rebalance across two nodes which may not be peers.
+ * @mas: The starting maple state
+ * @mast: The maple_subtree_state, keeps track of 4 maple states.
+ * @count: The estimated count of iterations needed.
+ *
+ * Follow the tree upwards from @l_mas and @r_mas for @count, or until the root
+ * is hit.  First @b_node is split into two entries which are inserted into the
+ * next iteration of the loop.  @b_node is returned populated with the final
+ * iteration. @mas is used to obtain allocations.  orig_l_mas keeps track of the
+ * nodes that will remain active by using orig_l_mas->index and orig_l_mas->last
+ * to account of what has been copied into the new sub-tree.  The update of
+ * orig_l_mas->last is used in mas_consume to find the slots that will need to
+ * be either freed or destroyed.  orig_l_mas->depth keeps track of the height of
+ * the new sub-tree in case the sub-tree becomes the full tree.
+ */
+static void mas_spanning_rebalance(struct ma_state *mas,
+		struct maple_subtree_state *mast, unsigned char count)
+{
+
+	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
+	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
+	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
+
+	/*
+	 * The tree needs to be rebalanced and leaves need to be kept at the same level.
+	 * Rebalancing is done by use of the ``struct maple_topiary``.
+	 */
+	mast->l = &l_mas;
+	mast->m = &m_mas;
+	mast->r = &r_mas;
+	l_mas.status = r_mas.status = m_mas.status = ma_none;
+
+	/* Check if this is not root and has sufficient data.  */
+	if (((mast->orig_l->min != 0) || (mast->orig_r->max != ULONG_MAX)) &&
+	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
+		mast_spanning_rebalance(mast);
+
+	mas_spanning_rebalance_loop(mas, mast, count);
+}
+
 /*
  * mas_rebalance() - Rebalance a given node.
  * @mas: The maple state
-- 
2.47.3


