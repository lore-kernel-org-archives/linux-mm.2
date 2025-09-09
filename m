Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBC99CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 19:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18FE48E0013; Tue,  9 Sep 2025 15:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13F208E0001; Tue,  9 Sep 2025 15:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA4A8E0013; Tue,  9 Sep 2025 15:10:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D3B9C8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:10:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A05BD1DD6CE
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:10:26 +0000 (UTC)
X-FDA: 83870652852.05.5A1BC87
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 63D24A0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:10:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cdcrg+SE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=d2nLGvRt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757445023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VKYUD4l1VbM8mPcxVhB9K5YyDN3txKtcWh5BgKxh3zQ=;
	b=VeQ4eqlRwjmdZfPNtGjmvmBfeBRNICehQjk0Z1toPemI3mVbNnRKPJ2Y6Zzhf4OfdKan23
	K1ZDjSxlkF/BZvZTTVUi43ct3Qvex8O2TMViQEeyYAfcf8JVI+4F5Vs1O6znkryOOWqI6Z
	QxybQV9SQ6BYmJotruscc8C2HMzRATY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757445023; a=rsa-sha256;
	cv=pass;
	b=nAtrTLiHX/ZOlhwgPjbOqTxsHxH+FyUbCMsEJlWoiVbVQPKTSVoMoJH+siPC+cabzh6QzG
	gSjQ8Yuem1MG4V/SJ+ZK1/HUm2LW3NwufKuxlsCdqwrkf6GtZF2eHXrugEG+TmnyW/KeeY
	9s6A4ZCbS1u7w1xZWPkaGtDEfX/dNc4=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cdcrg+SE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=d2nLGvRt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589FtrpZ020462;
	Tue, 9 Sep 2025 19:10:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VKYUD4l1VbM8mPcxVhB9K5YyDN3txKtcWh5BgKxh3zQ=; b=
	cdcrg+SEeb4f02Y8Y6xmMOA6lcTtxLC11AJ6v8HecuUiJb1SOMg3MDlPZTz6iVfd
	W6+ezK4Q3gqMfjoueHCbFSyAGXIwRKhjxFrQH9WbiXiezmSfvPn2WBxzSF0suThp
	0pvHSxjFVfBDnr7zJFRPuyKWPzpHFFZA/qi3hMbfATgIr82n6uTikdh0raMgHBFX
	rCsz3FW/uJphpFw4JPHUXptVtY6rajS10PBoMXW21/bf6oSTmbfQ+quk+/9zaaXT
	+cjHwFXJV8GxDhMEBLHKf31JqJ0df0O809zfmYE9T/NTSzHANd/jeosM2ICAjJAg
	zpiUfOPFZ5abjRRdaI8+NQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922shtje8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 19:10:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 589Hd3wc038942;
	Tue, 9 Sep 2025 19:10:13 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bda1tft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 19:10:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HTvhxToXo9D2+h+2FGWA4qbp7D/+GTpwFsf6D8Pnd17rzIeJvJGBngC2uBfnV0+LcIGqVU4++Bh8Vts6qaHPQxWRWWp4THo2HhMP41a40iX6ksA25O/tdkGih/mTVj+uwdAaw+gjQHCHw6bbQ8oGjMy06z9WsbzicXrPgR0CdvrYUuO9b2Ng6dGPcM2XmpDSs192rslS2E7bXNqypdjI07WLHixZ1/6kxC04w8oVm0v7/5vLdN3stRWm+h88/lG1jYXjwyPLFzi2ze4FcgOKyj7zWgBze6mVsQ7VSbR35ZgmndLBEIx56VDW+A5TrY+TJ2jiDlL2Z3WXxCYndT98kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VKYUD4l1VbM8mPcxVhB9K5YyDN3txKtcWh5BgKxh3zQ=;
 b=ENbYloyM+CO46L4tYuGz//U3A4Um2tqJLhNvmWNi/O6f8lBmMNN08UeJRMBNubcccUIVvSKnmVDPMSTqu5ifY2lKBCBLXb3cX490ALrmCFZIleI82PfvLfCuyKQq0IJE84I853Lt1ENgVWXX3gdQ7Pt0hSm1ZwxZVp0bK1hkHUQG555hEoymM4sasi8YmCiglYo5kvgDD2hdzf04saBi+wlMOzxP9G/THyG1cSe9ek9hsK3a8AO5CS62hzCr7kWeLgp74BYDMEg9Zmz7JJlcXxkAovXy7ao3ny8ySCdDX2W87oAAcJupFohfoqStbZ6tALHHrFGJ4SFGAffbk4GKyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VKYUD4l1VbM8mPcxVhB9K5YyDN3txKtcWh5BgKxh3zQ=;
 b=d2nLGvRt98W/ylTccD8WU0DcOEeGo8oVRpqo6Ng74MV8pvhv9y7fjFBsj9BboM3onuosDZfx62u+isvyEbuHEO5HtHhd+KcytIY2/gbj9csMDsqC8V71/XAqLVqJFOqmkSouE3yu72vpxZ+mXw4pHowvP7TT10DP0Vv9kqPEN78=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SN4PR10MB5558.namprd10.prod.outlook.com (2603:10b6:806:201::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 19:10:10 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 19:10:09 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v1 8/9] mm/vma: Use unmap_desc in vms_clear_ptes() and exit_mmap()
Date: Tue,  9 Sep 2025 15:09:44 -0400
Message-ID: <20250909190945.1030905-9-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0158.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8c::21) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SN4PR10MB5558:EE_
X-MS-Office365-Filtering-Correlation-Id: 83a4953f-49ac-4f86-ce42-08ddefd47ec6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h6EiXcVdEYtm7ZSvd+FHL8IbeXOrnGuYdi5UEv+GExhhDZ8pPH215vIYrkbU?=
 =?us-ascii?Q?hXZIMrJmxRhIO4Qm/y3NzaF1rdb4QmYxEzbUrCKR5e0wXUl3ELymx/hGjkM/?=
 =?us-ascii?Q?3ertY8KWR28sktoe4sXTLBWk38V77/HtYD5DsblL7mA69wXimwtB9zmjrhCq?=
 =?us-ascii?Q?r8Vy+TOTZerpT1m6XtBFqgy0/Nq+gS//DANCJH765V/HYMamho8ArPNC8+hz?=
 =?us-ascii?Q?kxTUtvf/nkefk4hxlayLth7YBRtjMhjB2QOmYxFh9IzX54zx+9XGnMcIgZDa?=
 =?us-ascii?Q?d/BLSz0zMQoKea76ITGNQW7fBtNRcbOsWQ3ENCbSXtUpCOs1Saj9Kbi3aFGf?=
 =?us-ascii?Q?Kc2hH238nPhiU2b+kbOfIW2ph5R7qfSS/sOJI5mNP/e4i5CA7jv5cNCiCV3B?=
 =?us-ascii?Q?FkdqhMWw+I+ku6sME4+JQn7Ptr2CWL0C9zETZtMxoLBoA6mv5qmwiR3E7tw6?=
 =?us-ascii?Q?rvg1+nXpjG63wnQKDmgbvSwgwDV7F48QjDAExYwH9nkPucZqMMZLzcQpUu1g?=
 =?us-ascii?Q?eX/XTmG+EB+hgNdZE4ZZ7Vk6ZpfRM3k7We5mKjc/4qbs0PZ6hZjL0rpGoAlk?=
 =?us-ascii?Q?hUAIBInyyqoIbMh62Ozfke+0C8lt3Jpdrwtl3pYJUmpubKV1e567THhzc0e3?=
 =?us-ascii?Q?GsHMbiqTAhm2XbBwoEzZsgPC2Smln5nNVLLKgycJNvLeahD77UdkVMVXo62x?=
 =?us-ascii?Q?/Tz9qIl7uVptTEvEEGtHFSzmdZFs6bJoHkdQlYCcCPLljlrNQXg01qh2OgrH?=
 =?us-ascii?Q?RFYQ5ZiAQjIeJvTmQFL9ZImcnYeaDr7Kge2Cs7UDhlvCNalEXthBRyLFoew/?=
 =?us-ascii?Q?InHW0mJRmQU5/gK4eXEe0hQJbjFkeg8hRjLqDC2kgTggVhJVBZc4YNlHnYyc?=
 =?us-ascii?Q?rEvVDvaS0mflCGNtD0kWKU/PrSeKxKh4F/i55URmj39KmD/INgB54nVVOlsr?=
 =?us-ascii?Q?OLawlJP29qehvS0Q78sDe5PDfkT9WYCMllRmBSmh2Y8dN4OTOR3BiA6R7dlr?=
 =?us-ascii?Q?REp5uX0RbMx94sU59HI7Y94H4/4Y382ynI7e/5nlqTJfEGY4uGbMM9RETEBB?=
 =?us-ascii?Q?A8ejQSmyduzPArrBnnbiTHouqvm7spxSe/L3HGofYOdyfVaCEIqCyJRYyoTC?=
 =?us-ascii?Q?CFvsmS8v5QRLxv64mmC3BbvuihQr57RBUO1yCUuK1JUhvWcIPsNjzb0Qwq7j?=
 =?us-ascii?Q?tAevnfoX6FOMehjI5AWIANKjswJRJyW8yyXl4eWpk3ZiNo/iMoSj8N6I9aBq?=
 =?us-ascii?Q?4CFwqXbpemlEmAtRHJ8g6TxY/umMZZGIQuDFnAujWHyX81vT87neIgLMjpWV?=
 =?us-ascii?Q?Aq5z7pBAJSwLIyiRQiKpGmaWlwQM5yADbXdgOODRdg3i1QAMMY4R4OhkT3jp?=
 =?us-ascii?Q?isp2Y5aSr56sdPuvgElSMddOtfbv2nAxiclREPwlWvvdy+K0WbbVqeV4njM5?=
 =?us-ascii?Q?wMGVsVSfA98=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gowi4Iekk9mpm07/mey577rynRcIsa3+uMh7/aKU6FI+JYed2Xbzy/RCBzcc?=
 =?us-ascii?Q?+TzM8v7ZOYP26OmMy94BcT23KM/rR0vD6XY//UuZbrSGQFygypZglhR8GNOZ?=
 =?us-ascii?Q?2DMfBIf08IoiYNYasDoIuTg/zB0hqzL02G3OiE9YXokxvcNwFKxrAvD6CPMS?=
 =?us-ascii?Q?7S5NO/QnK/eaPETCOQOHUEgEmYErQICpeuDqDhaDDIyiEh/mN/FBXvS1sVU2?=
 =?us-ascii?Q?aAUvgQNZltWqTA5Kv2GTeAOklE8mSEzKZO5txcQa7RB9gr19G+WLjVh1XFwV?=
 =?us-ascii?Q?DxkMMXWIqlOwQ7C1sjE0QSYeGooISuOoxPkx7A/HBVVcohYdf/ICh1D8zjZ3?=
 =?us-ascii?Q?K1JQCY9h9iyxPYzhlKxo40kxB5mNutIeEPcffTcMedkdpyV2oHchSTxIb/4F?=
 =?us-ascii?Q?mijJKJRpZo2OitbFvqrZLDQ0N1qLwYg7FsVIzmz+UPvWmButta9flll4D+ia?=
 =?us-ascii?Q?p5EzvkSRSSUfrOGrcqfsSdX9oDsz/4c+sbSlZUQS1QhFcnPYe/s8A0xUb6Sm?=
 =?us-ascii?Q?BVAU+OWEiHtLR0Jt+VOCYa0smn24ZucwKSS0FlI4dFIbfC5PZ9h0aLauZBas?=
 =?us-ascii?Q?bKzgghuqdt1NtvHhTcnym/9xpD99MpvBlbIA+Fi/WPC7N7G0U2PzNHftmGdx?=
 =?us-ascii?Q?Z9DV4O5HtWFSFcE2KRQDB30ib+Pp7mZG5wqkjiiFsOyPy8ncklwHHXocA8k+?=
 =?us-ascii?Q?gLpdeofebK/6EP+ajIX2AvQ5r9kiu0L+yATLJSEBkmC4tE/0pyYus+31m601?=
 =?us-ascii?Q?xzSEZUuTdsHUk23wxXlmrvhprJerIwg8UMH49bRZjgDyI2TX8aKtldUEUKTX?=
 =?us-ascii?Q?6/sJBs0XAYH0dyH8sbI0HcvpTb8mxh4d6NR86FJzfBUxMk7TUHSTjV3U5yhZ?=
 =?us-ascii?Q?unJuq1nYZNlgwei+UqahbjfwU9TqL4dQMDRE4iUHdceH5CRWJlJQX7Q9D/2X?=
 =?us-ascii?Q?/+IzZRuVkl8Se9fFQZyXMxBD7bsnXy5fS7UAJk+V7cN02nvqkG83W+auQhhp?=
 =?us-ascii?Q?3Z+xhUnKlj6DRzempP1yFCc4JMFB+tx27ECAv+5FKLNAR1Haw+AxfnU19W1c?=
 =?us-ascii?Q?gkI0ylOiARUoGOj8ibjFqwN5U1e0cDG2ArdASd9NcJ6ejOYE/F9z0pUdP30O?=
 =?us-ascii?Q?TIfbBlEFXp1y9UpkNZ8E+S7mrQttX+Moa7TIeHVaxtblNVV3nfhytrkQND8N?=
 =?us-ascii?Q?sNWaoVst+gujKOal0aYoMgZMiubUsUMdJxNe458XBOOH6Vs7jZrOxwNkdnqb?=
 =?us-ascii?Q?scUqzLWzz0kbnYUp74PtsZ+1lB/XT/yGEFyP6Op9COP8SSuXGiivEzJrrQaH?=
 =?us-ascii?Q?Xsge1SrLpsR2e2NDI2EdFE+oKhmCi5a0B1zt6eO9ajhMPr2Dysw+szFQLIn8?=
 =?us-ascii?Q?Cst7wJ1lkUPYykIxoDOpddUGIridA4cvJGIO0+u4T6GWIRatJYTM5kcCRgCQ?=
 =?us-ascii?Q?XSNGYM8PJiO/hhbAKAtHJN3bFeUfDADMFhK2Pvgonc3C8sIgkQvdEeGjMuyo?=
 =?us-ascii?Q?drkcsOKBbeyHDpY1GVg8QwgkDbvkxenqB9HBsUiqZxNeiu6CEf94l3v0kERT?=
 =?us-ascii?Q?qlLTJCfIzrzioSisJFpuroZG/ppUgDtQCMXLiUyLo5BRxhPnxxZrd6fWC4Lr?=
 =?us-ascii?Q?8Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	38JPLr0z1nP6wJC6eT+ggzIzBFF0nhAyUqI0HmhmJ6ODQndbH0Bex3TTC5Uu0/ytQau0cmlKepz7VfiAenaHa337788SwDhxKUOs1xTHnqOQi+7VLJDWDWcQ7+m3AzwKIAUbnqS79hs0Ef5XrFM7Nvop+9Zn2zUcuMz9qjv8AFXuZowSw5kjyHB1syaOgUD/IF0LHaBgXOYYEpOoN/rkrs1DrfqtvAFXz02OvEGIPvUNeKOJKtj6cJktIxLzOTvgc7EL054pObj3oLqsPH6zvpejOqK3oF9XYiTLaSRvrbiHLTKBG1MoCvb+YOvcSmQ9wiaE7XwJVjZhJK2IDBbZmPnNLhuOLlS/1yCz+DgzlJzRfW0qpOwihc+6lS4CvEO9djbwcCxTw0pcxo/VIVv9ueIiOTrc5C7zIrvffdJOKTzsvF1RhEJvLc300nJTwhlPj68HezSZtZPU4jlt3ntW6aoaTbYnjxWRUNGkCifkO5hYbare2Bnx3Gcw/cZz1eWqU/c80RCp6ALm0uRQeuZNkZDovT3k9xRbjszkG2lo8QCfSN7fXiFgFirdaCgTVnYAd5WAWJGljk0q/55kK+Dk14Xr72G0PUBibRBgLecPQtw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83a4953f-49ac-4f86-ce42-08ddefd47ec6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 19:10:09.7634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fGugqojad+P29F9mgvrYwnOTT1MjO4TA98fODWvyWC13QORVOn3bx7hcrYVrGHuDasHHDGMPToTx/nfhj15brA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5558
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090188
X-Authority-Analysis: v=2.4 cv=esTfzppX c=1 sm=1 tr=0 ts=68c07b96 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=Ve4DxTUvmLAGs18brJkA:9 cc=ntf
 awl=host:12083
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NSBTYWx0ZWRfX0DIuLSriBT5s
 9oYuYmEZHqMTqWXiVtpq563QJMxwK88BBksYhMeu6SxB/pLnI1uG4vocRC3UhFyTmr3YNCFhUZV
 e5zoKUIgA6vLCWDHjA3728vZGeUvz+JzLJtc/wtnVgs4s6XjXvhfnMeMItceGPMQp9L+nyn6rGG
 Eh12aAIyQN9dlmwjfLdINUXD/NtCXmU/2Hwbl2Bd/UkA1qX0zl4UFYNKUnCibw3thhhkQmJLYNf
 12NEg3aEhuEgpFCpwJHlVSVHz9DmAnyqJvJ/E6htwopYffrzHbjycY2oGy2cBBdIgCOlt8x6feQ
 o3VdZ4zaIXkvtk9+/LHoRUtGCiC3oOPle6svD/54jFSL9a5wXWtCZQltmXfXVkfz7biI8+KToxc
 xf9mlZTWIjayvzVFYcecy7yFS6Ikqw==
X-Proofpoint-GUID: oOHO5dJLqo3Fyorouq_NFI43riFlbbah
X-Proofpoint-ORIG-GUID: oOHO5dJLqo3Fyorouq_NFI43riFlbbah
X-Stat-Signature: a59j5rcztni4ph8nhr7bsptxabborzbm
X-Rspamd-Queue-Id: 63D24A0003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757445023-327466
X-HE-Meta: U2FsdGVkX1/oJDkJbx3oxgsraDFByQnSzvp3LnR37/gUQPuGVqZJrpSzNyYUOIyH8009l8OfZ7+53YiP9rJLqELTBdNBTH7yKPy0zOYHekewpq8GL6mbdnDaKOHzTdLGg3b2w3FGVETzWam+gRYShR66m21/paZY/txKQ/eMuW/Zg7En/rAEvdk5AIlgffmbD+3O2+t+GQEX+y3JlQFqHkWywiczc7fPtNvX6eCyQO7QzRP3hoMLmb34g+oj8C/2GtmkS0OWwBaLNJZxYv81osjErERGVVioBHjVFLDlgqHYb5IX1Ylv/R2ULh3P27JDV6OXHyZN62LF/XLtnr3UzEJcclebfzTZcUa+c70PwBLuW0U+H/RHKJxM7ksquAKKLvvlAJnQk00vBLgVHl2blxR1ZzIGzn8o9R+MZpaCHXSRXscXw/MID6efs+pYHmmsaijt7SGRthVa7Aj3i7ZHK2e4sO+u+BNc7bXivZuCjUarVSek4gp+vFYWZteY+DaCk28pBeHppaw8K/NIeRkwjXtRnq75bnO+QsWRvzEGvCCFiIS6IrMiBhzkzLqTkQQWdwrRuWgpw4BjHY1OXkywZaP880pMT7ueyWX4LPYDDnW+gUD91w81CDd8G8SLm63qErNRNFQCOvA0rWUHvSlBIC+h7Zi1K9l5FH/UJX6O43wv/yTOk4VscdMQkJEVzZYewVKfrEj7Kz5ynUDcrfN1y/ld019rJYrTcgn9YsVh6Gr99XX4qWnzd5ohV1tLi7XvbGsVKAidRhTL7TybeE8Exbk6/zJRno021P9jd08zfauDA9Y4lfy1fsmZny2PpHw4xP2JOUkAQhSs+3n8VRhJDPz7uswU4hQ5tOtiJvdw4oHHRXU/N3MQeCq0znIPaNP7wZT4lG7Kww5T35W6aVR7urpHrVuubNjbE89clis2GKYMx4ULvWv2SEFm/fLP1wcyCVf3pP5T6bqCKyeKrgh
 P4nY1qPl
 QhTwJeNc7U1+ey0SGYteFhKyQj4Vl40I/Eu5pIWfNj/t3E4mtojkocSsX6YD8W0NKtIog1VgdHr3OMV/nD/omjqD1plBbD6Af/3+Cw1s8FWnuhzOb++RpuFNxCoSWJVP3YsFbhIFIVUz3FvMJ0GcPMHzTvRYSiAg3P5jltmOJfcSlOBY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vms_clear_ptes() is slightly different than other callers to
unmap_region() and so had the unmapping open-coded.  Using the new
structure it is now possible to special-case the struct setup instead of
having the open-coded function.

exit_mmap() also calls unmap_vmas() with many arguemnts.  Using the
unmap_all_init() function to set the unmap descriptor for all vmas makes
this a bit easier to read.

Update to the vma test code is necessary to ensure testing continues to
function.

No functional changes intended.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 include/linux/mm.h               |  3 ---
 mm/internal.h                    |  3 +++
 mm/memory.c                      | 24 ++++++++------------
 mm/mmap.c                        |  5 +++-
 mm/vma.c                         | 39 ++++++++++++++++++--------------
 mm/vma.h                         | 14 ++++++++++++
 tools/testing/vma/vma_internal.h | 14 ++++--------
 7 files changed, 56 insertions(+), 46 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 892fe5dbf9de0..23eb59d543390 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2450,9 +2450,6 @@ static inline void zap_vma_pages(struct vm_area_struct *vma)
 	zap_page_range_single(vma, vma->vm_start,
 			      vma->vm_end - vma->vm_start, NULL);
 }
-void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
-		struct vm_area_struct *start_vma, unsigned long start,
-		unsigned long end, unsigned long tree_end, bool mm_wr_locked);
 
 struct mmu_notifier_range;
 
diff --git a/mm/internal.h b/mm/internal.h
index d295252407fee..1239944f2830a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -197,6 +197,9 @@ static inline void vma_close(struct vm_area_struct *vma)
 	}
 }
 
+/* unmap_vmas is in mm/memory.c */
+void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap);
+
 #ifdef CONFIG_MMU
 
 /* Flags for folio_pte_batch(). */
diff --git a/mm/memory.c b/mm/memory.c
index 829cd94950182..8d4d976311037 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2084,12 +2084,7 @@ static void unmap_single_vma(struct mmu_gather *tlb,
 /**
  * unmap_vmas - unmap a range of memory covered by a list of vma's
  * @tlb: address of the caller's struct mmu_gather
- * @mas: the maple state
- * @vma: the starting vma
- * @start_addr: virtual address at which to start unmapping
- * @end_addr: virtual address at which to end unmapping
- * @tree_end: The maximum index to check
- * @mm_wr_locked: lock flag
+ * @unmap: The unmap_desc
  *
  * Unmap all pages in the vma list.
  *
@@ -2102,11 +2097,9 @@ static void unmap_single_vma(struct mmu_gather *tlb,
  * ensure that any thus-far unmapped pages are flushed before unmap_vmas()
  * drops the lock and schedules.
  */
-void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
-		struct vm_area_struct *vma, unsigned long start_addr,
-		unsigned long end_addr, unsigned long tree_end,
-		bool mm_wr_locked)
+void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
 {
+	struct vm_area_struct *vma;
 	struct mmu_notifier_range range;
 	struct zap_details details = {
 		.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
@@ -2114,17 +2107,18 @@ void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 		.even_cows = true,
 	};
 
+	vma = unmap->first;
 	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma->vm_mm,
-				start_addr, end_addr);
+				unmap->vma_min, unmap->vma_max);
 	mmu_notifier_invalidate_range_start(&range);
 	do {
-		unsigned long start = start_addr;
-		unsigned long end = end_addr;
+		unsigned long start = unmap->vma_min;
+		unsigned long end = unmap->vma_max;
 		hugetlb_zap_begin(vma, &start, &end);
 		unmap_single_vma(tlb, vma, start, end, &details,
-				 mm_wr_locked);
+				 unmap->mm_wr_locked);
 		hugetlb_zap_end(vma, &details);
-		vma = mas_find(mas, tree_end - 1);
+		vma = mas_find(unmap->mas, unmap->tree_max - 1);
 	} while (vma);
 	mmu_notifier_invalidate_range_end(&range);
 }
diff --git a/mm/mmap.c b/mm/mmap.c
index 5c9bd3f20e53f..6011f62b0a294 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1280,10 +1280,12 @@ void exit_mmap(struct mm_struct *mm)
 	struct vm_area_struct *vma;
 	unsigned long nr_accounted = 0;
 	VMA_ITERATOR(vmi, mm, 0);
+	struct unmap_desc unmap;
 
 	/* mm's last user has gone, and its about to be pulled down */
 	mmu_notifier_release(mm);
 
+	unmap.mm_wr_locked = false;
 	mmap_read_lock(mm);
 	arch_exit_mmap(mm);
 
@@ -1295,11 +1297,12 @@ void exit_mmap(struct mm_struct *mm)
 		goto destroy;
 	}
 
+	unmap_all_init(&unmap, &vmi, vma);
 	flush_cache_mm(mm);
 	tlb_gather_mmu_fullmm(&tlb, mm);
 	/* update_hiwater_rss(mm) here? but nobody should be looking */
 	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
-	unmap_vmas(&tlb, &vmi.mas, vma, 0, ULONG_MAX, ULONG_MAX, false);
+	unmap_vmas(&tlb, &unmap);
 	mmap_read_unlock(mm);
 
 	/*
diff --git a/mm/vma.c b/mm/vma.c
index c92384975cbb2..ad64cd9795ef3 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -481,8 +481,7 @@ void unmap_region(struct unmap_desc *desc)
 
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
-	unmap_vmas(&tlb, mas, desc->first, desc->vma_min, desc->vma_max,
-		   desc->vma_max, desc->mm_wr_locked);
+	unmap_vmas(&tlb, desc);
 	mas_set(mas, desc->tree_reset);
 	free_pgtables(&tlb, mas, desc->first, desc->first_pgaddr,
 		      desc->last_pgaddr, desc->tree_max,
@@ -1213,26 +1212,32 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
 		    struct ma_state *mas_detach, bool mm_wr_locked)
 {
-	struct mmu_gather tlb;
+	struct unmap_desc unmap = {
+		.mas = mas_detach,
+		.first = vms->vma,
+		/* start and end may be different if there is no prev or next vma. */
+		.first_pgaddr = vms->unmap_start,
+		.last_pgaddr = vms->unmap_end,
+		.vma_min = vms->start,
+		.vma_max = vms->end,
+		/*
+		 * The tree limits and reset differ from the normal case since it's a
+		 * side-tree
+		 */
+		.tree_reset = 1,
+		.tree_max = vms->vma_count,
+		/*
+		 * We can free page tables without write-locking mmap_lock because VMAs
+		 * were isolated before we downgraded mmap_lock.
+		 */
+		.mm_wr_locked = mm_wr_locked,
+	};
 
 	if (!vms->clear_ptes) /* Nothing to do */
 		return;
 
-	/*
-	 * We can free page tables without write-locking mmap_lock because VMAs
-	 * were isolated before we downgraded mmap_lock.
-	 */
 	mas_set(mas_detach, 1);
-	tlb_gather_mmu(&tlb, vms->vma->vm_mm);
-	update_hiwater_rss(vms->vma->vm_mm);
-	unmap_vmas(&tlb, mas_detach, vms->vma, vms->start, vms->end,
-		   vms->vma_count, mm_wr_locked);
-
-	mas_set(mas_detach, 1);
-	/* start and end may be different if there is no prev or next vma. */
-	free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start,
-		      vms->unmap_end, vms->unmap_end, mm_wr_locked);
-	tlb_finish_mmu(&tlb);
+	unmap_region(&unmap);
 	vms->clear_ptes = false;
 }
 
diff --git a/mm/vma.h b/mm/vma.h
index 4edd5d26ffcfc..8b55a0c73d097 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -164,6 +164,20 @@ struct unmap_desc {
 	bool mm_wr_locked;            /* If the mmap write lock is held */
 };
 
+static inline void unmap_all_init(struct unmap_desc *desc,
+		struct vma_iterator *vmi, struct vm_area_struct *vma)
+{
+	desc->mas = &vmi->mas;
+	desc->first = vma;
+	desc->first_pgaddr = FIRST_USER_ADDRESS;
+	desc->last_pgaddr = USER_PGTABLES_CEILING;
+	desc->vma_min = 0;
+	desc->vma_max = ULONG_MAX;
+	desc->tree_max = ULONG_MAX;
+	desc->tree_reset = vma->vm_end;
+	desc->mm_wr_locked = false;
+}
+
 #define UNMAP_REGION(name, _vmi, _vma, _vma_min, _vma_max, _prev, _next)      \
 	struct unmap_desc name = {                                          \
 		.mas = &(_vmi)->mas,                                          \
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 823d379e1fac2..d73ad4747d40a 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -884,18 +884,12 @@ static inline void update_hiwater_vm(struct mm_struct *)
 {
 }
 
-static inline void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
-		      struct vm_area_struct *vma, unsigned long start_addr,
-		      unsigned long end_addr, unsigned long tree_end,
-		      bool mm_wr_locked)
+struct unmap_desc;
+
+static inline void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
 {
 	(void)tlb;
-	(void)mas;
-	(void)vma;
-	(void)start_addr;
-	(void)end_addr;
-	(void)tree_end;
-	(void)mm_wr_locked;
+	(void)unmap;
 }
 
 static inline void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
-- 
2.47.2


