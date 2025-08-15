Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651EDCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 19:11:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F05908E0210; Fri, 15 Aug 2025 15:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB6E78E020F; Fri, 15 Aug 2025 15:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2FB28E0210; Fri, 15 Aug 2025 15:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA6D18E020F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:11:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7799E8284D
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:11:20 +0000 (UTC)
X-FDA: 83779935120.17.44384D4
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4ABC54000B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:11:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=h76GtpNG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="ldaMyrw/";
	spf=pass (imf01.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755285077; a=rsa-sha256;
	cv=pass;
	b=W1AEyxQ1hK111oLfTIGDnFq/VQfiZnreeL7gpuCyY2p/qqE0OcfK3e9s/IGzMim3z8q9Yl
	vny6ip+1BSq2wAXUN6qB/tZPEnd7yKXq4bInonMaVNG8Oni9WMM9Cu1FSJNKtsXwljXyga
	l0zy2I/9e5uXCvdFs/OnKW9sNXd5VDM=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=h76GtpNG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="ldaMyrw/";
	spf=pass (imf01.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755285077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HTBwHdn7dM09koUQxRiOzW8yJsxrUc8qCjNqO7y12Zc=;
	b=1E5KDkFu1F27tWwuYbeOLIH/QO8m2CXEo4T5avwjzmI/mH0Ln+qVRwA47a2arD2OFYp+Gs
	Hs67bdh7r9IuKIQYQfdhWqNPbO3oHAZFYgumryN6aVeFcTtX/jFUoIAxNjYq4n8urgq/hs
	pqOXq+n+YN+baqEfRu1YZbRSnpvMkzo=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57FHlNma026431;
	Fri, 15 Aug 2025 19:11:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HTBwHdn7dM09koUQxRiOzW8yJsxrUc8qCjNqO7y12Zc=; b=
	h76GtpNGVYwNUVfCn7eCIwiBIvtKYJqndwxkBfZO245gxRDMT6fgeHbmLMKSKSEh
	d7tMgPpT2rUFd9M3Xauu2C1JchXePCCQ4wZ42ecCPa+Fin0dhD7Tf/X0KaIPBPgW
	XJ3fpQ4xBRXp7GEUa2vLAU9qrKjj85VY7Jq113sAqPc9JLSSbPUI4pu0gYe8eNVr
	aAqlLE4AqHvU1LwjSHXOyLq+iezDi2MnA4eujKAMKi76Yo/hIN1CwL5gHhM9Yz1k
	dgZqPoTwjd/txVeeUNZ3q7cYA43kS/HCmzUh7KuzxY7MqCJeK4zuYXyt49ZGWY4C
	ixGeLLurIs1y2VFS0OcaNA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dw454hmx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 19:11:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57FHoOI4017466;
	Fri, 15 Aug 2025 19:10:59 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2057.outbound.protection.outlook.com [40.107.101.57])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsea982-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 19:10:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wEfR8DEZuwBogmB4fy8mBOqisWkGd4zrO0fzjL7xqHElUan2YIyJk4QGwUiouVBctnlThjWomZeuGihbkEYfHXhURpQEZWl/UtZg0mHnco0kOLwJy8wvwuK6IZJ3k151KzPakmQHAi1eA16xfK3IMa8KqPF3m4/3iBTf1fZdlipl0PvXesgs7Wl3wBkHoS4x3Ecz+HWSjwy55jqE9vLi9dajUFbt+txybHdirBC9bShaTV1/j91DHhAknNCFz+NzIS23dhPODbS1PSYHdLKIQLc7NCzba2cQsNmeWr7FPhupaM+EhDSIHpQCnukdjG1sY5HkI70N3gA4jSLdzUyJDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HTBwHdn7dM09koUQxRiOzW8yJsxrUc8qCjNqO7y12Zc=;
 b=zKRP7D4RcAHMai+qk6+2HFZ9ATjSpEQ+wB4+iN0f3t7RBoTUwTTogfnacUGOo2A6MCf9PX9+3HyE/O8/oVHW/emsY6fK1MDYXe8aM1IOEuGuI/QvmAydFn6UmS8Q1EWHx4T16cYbUnZk/DdDIffAf7uy6VL79Nl3ice5rtDh0dT6pz/xr2tmUx0ZRpNlVnnaTOS1D8HFUl2LUwwBN2EwmZnpcBcR+glOXLZ9K/HUzjSbb+Bx2IA2FJvNs+VtSmZwLg23uDSQDOQxD9k4naAALeLDbsUBQybb4rDF0U0LDGPaLIrrow8t2RHFkTiMbLBqYFqo+KYXhVBajuhAUs/2HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTBwHdn7dM09koUQxRiOzW8yJsxrUc8qCjNqO7y12Zc=;
 b=ldaMyrw/ed2/Ig2DmcFIvu27ff1GHuY5CKSDXbRNX9MEAdNMgAjozYopYk1xr34ASOhquf6O25YTxUtIppMiUTv4Xg7x91QO4i7gtR12DvxagAxROvNjjH+jD0MSUNareHhnA/UtugokYtqX9L3CA/F68pZmn+4tbXgc3ZTirzY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MW4PR10MB6464.namprd10.prod.outlook.com (2603:10b6:303:222::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Fri, 15 Aug
 2025 19:10:53 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 19:10:53 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [RFC PATCH 6/6] mm: Change dup_mmap() recovery
Date: Fri, 15 Aug 2025 15:10:31 -0400
Message-ID: <20250815191031.3769540-7-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0038.namprd04.prod.outlook.com
 (2603:10b6:303:6a::13) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MW4PR10MB6464:EE_
X-MS-Office365-Filtering-Correlation-Id: f94d0e9d-31e0-408f-7ea9-08dddc2f74a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ClgLlFdWhC68TpCl2B6cFxfYtU0OUPI+eMaLkuKG0hSZcZTofEy90f5Cir6A?=
 =?us-ascii?Q?yb0SGIcyjLr7ezL4YmuSozGYLIUrDIsb1K2f/qZD+agI0Ej7Usoi5wd1THkL?=
 =?us-ascii?Q?NIBzGxYeklTQWqw0EnxcoBAmFJhwzZA4OkmQLnG1P1cd+IR7N7rs/ZDTN7k1?=
 =?us-ascii?Q?wSyaN4lg5FjDZsjJPOQe0p0eIspiD7ZNtqhqMk8tKXasqCiTNqYgiFfu3xYe?=
 =?us-ascii?Q?NT8LaujxD3RbDFxPLx4BoDPDDBp9xrrJAbXqMu6j5udc40SfvT9hFgec+bwp?=
 =?us-ascii?Q?VmWGlrU/xuDU2AJgwMYvFzDAtWJ/Yt1lvaBuBNH36XmgL0QgpX+w8YVc8gOh?=
 =?us-ascii?Q?dIbBLgUmO3PQ2NyEKZNoYWsa0Cu33D4uLyw3llXvpNXYzP/rUrgKCk8Egqnf?=
 =?us-ascii?Q?dWeKZ6DBv13PM9HBwK8hqXKZEbJr19vFQ7fEAG4jW892LLhWzxvki+yV2a91?=
 =?us-ascii?Q?JHUZzjIPkGGNyp2pt0Rt5GSssUK5zmviVvE0crIjoS/1FLTFWcwnCEWu/sDF?=
 =?us-ascii?Q?7RWA6JRbETbvbG91PFFfqA7jkR1Y8KPOKhZelNwwAFrj/OoI+GgNXDpSoYdk?=
 =?us-ascii?Q?rAEeG15bRIRAjRXbr5+HJvg1LMuAbvrzuXsYiZkQMCJialwdhG1jdK8PIsFJ?=
 =?us-ascii?Q?X1WRVk9R49BB4cQ/D7KAhwB18u2fU89USjbc/5CydnCrLtHh1vgmPPD8Hl92?=
 =?us-ascii?Q?CA7D+WQoJXWmRrg/3QbSnT8iBK5AdAMy3/i/eUuDBvhIL+IYhLSuG5a/qteU?=
 =?us-ascii?Q?t4lMsnjVJVNY7ia7mPrM57/Doh+4VerJxGT4pCBJmcI+gMT19M1nEbwrmvhP?=
 =?us-ascii?Q?cWPOgiMhOE4/9blHO5eRgOaxrkxhNG1HrIy8DD0Hx9f92ZLNC3DPF5SZf6dr?=
 =?us-ascii?Q?NE+EpxFNO88D9ltK8ECjfSryTGktFyrLzAWvG12OTTKuJT2krw40bXD1KGXR?=
 =?us-ascii?Q?uaiRDAElfD7yVxoMZJcxc1jNRB0hS+u5jOQXPxTzBVupjWCELGPnPtj83bw4?=
 =?us-ascii?Q?wMQFFlJnfLtdzTLxI6/9ryykP1Rjl2vAu2nMFrPVeUFEjANAZYPq0/qEqIBi?=
 =?us-ascii?Q?RPMWnA2bJVRaiCCJFA6EGx1WDFgNWVROp/ulGnyjkb6BLRT9G0YmBHcMsfan?=
 =?us-ascii?Q?f1F1rBriLiOylvkuQhSrGzQW7FC6rlMCJmrOkKVEyRPbWi0LEDMyfWETY/2J?=
 =?us-ascii?Q?SYDjoVeMf+zAxUig/f30f77GEEJysacFrphI7ABLIsE03qpWUJKcZNDLXer+?=
 =?us-ascii?Q?ysmpLOUqwZQNZ4nGA5Fpei89cfwBiE0S/nlKlivWUzYI+jIUfQkEZ/x/OKE/?=
 =?us-ascii?Q?Y3MpQlVTdcrKj2FZ3L8HUBplpNwHCfy+1IkgO14CvLRAyuck8wL3MuVJQjQJ?=
 =?us-ascii?Q?sW58Qo9w+Ky+8ZCRsyoycxV/hGlKuR31+I3hsjbn3++4WNFH5fOjNdSN09ND?=
 =?us-ascii?Q?RcC/x4orpwQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NYNIGKeEaS5m/bH1utHam2PWj5ENTee8zD5TgcVBRq6l4/0cKNFWK8IoAzH6?=
 =?us-ascii?Q?JJf7ZOJPszUpmUjjMOont7faIcJ2qm4rVWlTXB6rqGHwTSSTHw4rvRPpU+Z3?=
 =?us-ascii?Q?D6y08GwG64tQK4zmsa7xUEc3ZjCu5McIm/1CNxty9MvxGGru4sK8X79BRpZO?=
 =?us-ascii?Q?L1122wLBoqvzNbunuNgBWky0Xr5dsUaHM0vsi4nOi4T3V+XLdAgxjgqcYQEy?=
 =?us-ascii?Q?mW4GAFmL/8U1Ew/Gb6EEGkqG+uoAnx3s1Kuf5+Xfs7wl0UOpQToAapFA4jxs?=
 =?us-ascii?Q?bk9O8iJjV7QOS4Jgo58BLVgvKZY7mrU9+BElgfKIwQ5qqHhc0jJEOMaV0Llj?=
 =?us-ascii?Q?od1aarOw/WhEil274F9dt0R5QB7Yhj0KVzLYpDYgAjZ2C0B8U/YkgnIxpHHt?=
 =?us-ascii?Q?Dc9gLnvx3dFfCFZ5AwWnoTSVTKjHBQPVu9RsLHklFS7E6uaYlwKK565h34tD?=
 =?us-ascii?Q?aM3p7LJWBHLMJhOf1YkjGt4WPhCFemKdaBgdv/eWbdgzF2GcXIwNM6FTGvnH?=
 =?us-ascii?Q?pDT2jgUFKcVeDzF207Hjt3rnmR/92PhE0xd0QVjWLLyRb6dnVfSWIKlFRqzE?=
 =?us-ascii?Q?CLaTL64MVxJLyyGC0BLwkW5eHDB5eEcSmdyOkOuq6NyzunUjFRgQOaY+koYc?=
 =?us-ascii?Q?gM64pDtuIKnd2yk8MgWoqwRR5kvx/HWUKtiYbYgFllGrRqtsJ0WUzS/zSUHy?=
 =?us-ascii?Q?4G0QFf6hRF5HNf2xtdxZmUy1BCN9jD9xXZ4AkwNEKKq340zYF/RIH+D89k9f?=
 =?us-ascii?Q?ta35ntmriFYKdI4faT8u3QsIpxqVybVXCZdg/6kRUhKxdMawoIgSjALesV3O?=
 =?us-ascii?Q?hORfqvwgHvum0GTFZunRBErDxc5e5DQJGjM8AHAecoQh+yYepPebmwYPV9k5?=
 =?us-ascii?Q?josPfaX5eJjCRQ+X3dgzKpJPthr4fceOPfUiP8lzQkRCPGnuB5VawjS8rS/N?=
 =?us-ascii?Q?AWzSjIeNMkmKxm4Fr0hWiuBiW/aA4i1ftDf24tUsmQHPYkQzahMBfKOUq6Aa?=
 =?us-ascii?Q?lOOSlh3ss9wk51Co3GhdCIExExV4jl1pNYmbpqSwPyEPW7AHDxvu1r+1pKYE?=
 =?us-ascii?Q?6lrtIMc/ikcQNPPODYd6WSouU03owOhsRm9/i8cmAe0mO7O5a6NOPv/qLZDL?=
 =?us-ascii?Q?9A91xGiA+v//9EmH4PWewoS6B6FegeCPHRQJDUafhV/S9rlscT4XWUQIL786?=
 =?us-ascii?Q?GwspPL+UQRxtQa0bchh5JjLRbxtgRbYr1ivZeWm46dWV+a0z5Vz7gOTpq7p4?=
 =?us-ascii?Q?Km6GMHw2HDxp2n3xL7/6x2PMxPdJhdSV2K+x6KelCRcurLB2m8jIH/XbpIp3?=
 =?us-ascii?Q?VtP8Rbe+pEb8wq5CcHFwqYi44Si15dhDik6JFI2MgyOYOdXnGgarEXxilGIm?=
 =?us-ascii?Q?gpLSoCPijXoCmieWX2LPluSEX6Z8pyqdYPjI9CT4kYpfq2DP6B5h6A3onhIw?=
 =?us-ascii?Q?Q8QeHz+YrWmZMdbC+k4eGsw/eXHzcFH7NO1JK0IxYAxlxc0l8I3s9DrxwSVZ?=
 =?us-ascii?Q?00gSy6KG/HPBoq/6JVO/pnanOuE1Oa1ipm4Xr8Kq1wpzggOsRHT8KfXRlycH?=
 =?us-ascii?Q?zl7eTu8Fi1KNHd/tyD27lY3MZtUgfnvmNBBsiHK+FDga6OJu3LQCKYLgI3fJ?=
 =?us-ascii?Q?xw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gfUeHEXWGJKog+XvafoOCC+T7/he4GMwolq/JMtwbZh9KK2njhOyCDJn0FICld+nPN+dsKMCiNq3+S7biYCVyiKu2ZqyJxWgxcKF6OQz0slHHgj4MAkTDcr7Z3EksK6hSsB+Y/mELD3dVNrX4Kmi3vFSkJNMzP64Z0sisrdQCWASfpucm6e3Hj5tiYRZupOKgOVZu1K6gQlxJUbKE1qyh85lXAjVr7D8IkxJlq+aicK6cPNb/7r0UAPZeLkIVF1dDa2cgV5eEbd4TtzgSMjsgWEK7/aGgI3Bto7zz7d/nSCMgiImle6w1qlzEruK+y8iFK1wScjxWscfH15gg7t321t+NUQrkwB0sR7BxIFAYwQMI56heK2ayUd09Q3WObPwsMnySIwTotPBB6fuUnYeRhV1bOWBocI9afCRezf/OyQzv7TV9nFJtW0MGCf0LSvYwXRucIxnDSRfKptohdPdRlGGClGwxTSfZJG8unz8HDBcs8LyThMjfpMyKzBaWYXPBzEZiklnx40fzJA/w0s3On5LCtEqXT0FMuEWfRXkuewzoh3xVywm86bz7/GU8OawpOdxgBN67Z95z+Rzl43dagk8SbVGk261q2u7L/2OS0k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f94d0e9d-31e0-408f-7ea9-08dddc2f74a6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 19:10:53.6319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mmfRdIfD+lln+z9gcr6DeDJzfVlH9py6+Pmr4c4YusybtaYtLLsL5uDtWkhw38MBynFL7FOcMQVspZXKIGr1TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6464
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_06,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508150162
X-Proofpoint-ORIG-GUID: DebkGNEPr7vw1yf3uobZyPTl-CzB-3-v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDE2MyBTYWx0ZWRfX+027PnMknOcg
 AYCoXAxQ/hLLU7DlJghvv8ZCW1R0Nda88gmBZiphcRHqQOmy4BOhVoLgebHxFtQ4H4Ajq407LjK
 ne7j1kYR0lcZfIXQ9PGRdlftwz7T1hnZkB8eZ7+5c05NgGFWI1gPhbkgzbMkhsrooqz6IN4gqaG
 TliYAso5qIsPac/mQi8Z+UCOzqfo5NM3Yij9UmC4Ri2OP8BIa3ycSgIxzsyO/O3A7oyLX8rYYk8
 5DbLAU3kd8zHDjQM70pDsJzR89YPdP4GR21Yb8Rf5ULEeOq4DB0Dz8x8HNxjFqqkprneV0rW06c
 iY4mQwYYih/KqnQ3/0VepTI2K1TR1SB1+gvCoUZDY62Ul6lvsneNB5iaIdPmfyAjUvOhFWpjeMW
 jf809qjZGzgdZvuRZ7P8C12CxtUqukk+HnP7FjhKZj57uZRFfxscEtiLsOn1X8uPXTnyAeHi
X-Authority-Analysis: v=2.4 cv=X9FSKHTe c=1 sm=1 tr=0 ts=689f864c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=GSebvwEjJFBsbC99ckQA:9
X-Proofpoint-GUID: DebkGNEPr7vw1yf3uobZyPTl-CzB-3-v
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4ABC54000B
X-Stat-Signature: id6pka6oew8ekyihk8qbjkrbrtnw698x
X-Rspam-User: 
X-HE-Tag: 1755285077-282116
X-HE-Meta: U2FsdGVkX1/LjzovZZ9z9HL1VZ2zKUswcCChNJ0cfc0rfCQUIjWxYrt6VTbE7mTW3US9SWW5m3ag+8lD0t/zHqma/zOMYEBepbVZrFg0pfbTGhkpJUWdLV6rUEF5qGM7LdwhzcOlkTcqzEpeG2n0zgXCRgEUTPmXb/JGz+jxCWfC0+vczv0t1vnZX8IFJNGuooe8/1dFId3GuSrkBzg75+BRVMKve5HiFDID1kXxRuEK9iieFyP8JdmGhvydQ8yHjfCvNoIAL7oGPg1MTxpW5xWbg/PzLqH0hrEvM/BM7OT03XyDe4opPWjgOOwiGMdQFv0eCafVJTgqTu3QHdtq5CFviY/j95q9u3AcDJpDaKiLZA/GMXZ94l1LBKKcMB09jHaF+QBXODaYVxQD/RnADZIA2ZymPkVdzGQHSGwjFNzNm1RR1hS61xClnYEF8cFxrJ7neVs6zrP9FUv3IRl4f6A2n+I92BEfHDq4s0J8ThaslPJVlnITp+FrWwvu4D1hPtHpCnZ2Peqa4A/L/F9IDRhdhvkoZGWu0Q1JRi4+/NNQGf5OKdMuYAfjIgjwnG/07R/u5cRo4K/RYkpDeR16xRKPxBeIt8jOXBZ41QtKxmLdCVwdTC1hizA+WtkkTn34z2BExZ60ySBgZHe0qBhInXWGdRdgJpCamwm1e4k47VPKYfjMLE44liTXk3lQIWt4sECi1VHBqHYbqH3kwhJGSluAjnSf94/6uVI8sGBzs0VePpl3hpdupm1lWGQXCoX+dQEtZUYuEfL2J2S+8Y4d/N9EQBHDM7bIcGKhFP4txheLvwxBkgQzQsw9DD28Lk+VYoS4+GC22nZ3KjnFYaaXg1kF3K2HbV9d6KdmWtFiA0sXzMoqxRbV5+3/pIrtayrk89gBqURTYPpQK1v0BA3m9Ly6THRIVBB9SmXrEe+AKgJiXTa3KJTZN0HJuDPohC8ZJIaPmd0+zVhjvPwV0fl
 aQbgx7hn
 htu35PDCJ0H32ZL2/rEaN1kpz1GXWzGbTjWIt7nbyRkbR+FA3TrDN3eGSDksPeG6pXrgK64p14cQsyMM2mO4N4XryZAKCbKMoku/G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the dup_mmap() fails during the vma duplication or setup, don't
write the XA_ZERO entry in the vma tree.  Instead, destroy the tree and
free the new resources, leaving an empty vma tree.

Using XA_ZERO introduced races where the vma could be found between
dup_mmap() dropping all locks and exit_mmap() taking the locks.  The
race can occur because the mm can be reached through the other trees
via successfully copied vmas and other methods such as the swapoff code.

XA_ZERO was marking the location to stop vma removal and pagetable
freeing.  The newly created arguments to the unmap_vmas() and
free_pgtables() serve this function.

Replacing the XA_ZERO entry use with the new argument list also means
the checks for xa_is_zero() are no longer necessary so these are also
removed.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/memory.c |  6 +-----
 mm/mmap.c   | 39 ++++++++++++++++++++++++++++-----------
 2 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 3346514562bba..8cd58f171bae4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -387,8 +387,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		 * be 0.  This will underflow and is okay.
 		 */
 		next = mas_find(mas, tree_max - 1);
-		if (unlikely(xa_is_zero(next)))
-			next = NULL;
 
 		/*
 		 * Hide vma from rmap and truncate_pagecache before freeing
@@ -407,8 +405,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
 			vma = next;
 			next = mas_find(mas, tree_max - 1);
-			if (unlikely(xa_is_zero(next)))
-				next = NULL;
 			if (mm_wr_locked)
 				vma_start_write(vma);
 			unlink_anon_vmas(vma);
@@ -1978,7 +1974,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 				 mm_wr_locked);
 		hugetlb_zap_end(vma, &details);
 		vma = mas_find(mas, tree_end - 1);
-	} while (vma && likely(!xa_is_zero(vma)));
+	} while (vma);
 	mmu_notifier_invalidate_range_end(&range);
 }
 
diff --git a/mm/mmap.c b/mm/mmap.c
index eba2bc81bc749..5acc0b5f8c14a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1288,7 +1288,7 @@ void exit_mmap(struct mm_struct *mm)
 	arch_exit_mmap(mm);
 
 	vma = vma_next(&vmi);
-	if (!vma || unlikely(xa_is_zero(vma))) {
+	if (!vma) {
 		/* Can happen if dup_mmap() received an OOM */
 		mmap_read_unlock(mm);
 		mmap_write_lock(mm);
@@ -1858,20 +1858,37 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		ksm_fork(mm, oldmm);
 		khugepaged_fork(mm, oldmm);
 	} else {
+		unsigned long max;
 
 		/*
-		 * The entire maple tree has already been duplicated. If the
-		 * mmap duplication fails, mark the failure point with
-		 * XA_ZERO_ENTRY. In exit_mmap(), if this marker is encountered,
-		 * stop releasing VMAs that have not been duplicated after this
-		 * point.
+		 * The entire maple tree has already been duplicated, but
+		 * replacing the vmas failed at mpnt (which could be NULL if
+		 * all were allocated but the last vma was not fully set up. Use
+		 * the start address of the failure point to clean up the half
+		 * initialized tree.
 		 */
-		if (mpnt) {
-			mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
-			mas_store(&vmi.mas, XA_ZERO_ENTRY);
-			/* Avoid OOM iterating a broken tree */
-			set_bit(MMF_OOM_SKIP, &mm->flags);
+		if (!mm->map_count) {
+			/* zero vmas were written to the new tree. */
+			max = 0;
+		} else if (mpnt) {
+			/* mid-tree failure */
+			max = mpnt->vm_start;
+		} else {
+			/* All vmas were written to the new tree */
+			max = ULONG_MAX;
 		}
+
+		/* Hide mm from oom killer because the memory is being freed */
+		set_bit(MMF_OOM_SKIP, &mm->flags);
+		if (max) {
+			vma_iter_set(&vmi, 0);
+			tmp = vma_next(&vmi);
+			flush_cache_mm(mm);
+			unmap_region(&vmi.mas, tmp, 0, max, max, NULL, NULL);
+			charge = tear_down_vmas(mm, &vmi, tmp, max);
+			vm_unacct_memory(charge);
+		}
+		__mt_destroy(&mm->mm_mt);
 		/*
 		 * The mm_struct is going to exit, but the locks will be dropped
 		 * first.  Set the mm_struct as unstable is advisable as it is
-- 
2.47.2


