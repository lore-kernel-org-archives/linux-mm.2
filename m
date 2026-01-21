Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A15A4C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BD7E6B009F; Wed, 21 Jan 2026 11:57:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 885D56B00AC; Wed, 21 Jan 2026 11:57:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A276B00C6; Wed, 21 Jan 2026 11:57:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 253266B009F
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:28 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8DFB140829
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:27 +0000 (UTC)
X-FDA: 84356576934.16.EBFF6F7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 89A9440008
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PYbD17nu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=N25SM7QW;
	spf=pass (imf17.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tgkE4OW0KG6KU/HEahv4pxM8DZ5R+yPd67+MplgFSU4=;
	b=lsM9D2Ne+GXZQAPqChledorgyWRRIqnXvNo4jshKx0N2KJMHPWfg8sGDhw4Iy90XfL/MX8
	3bZ2hbDeb/mPcXmtdOde0xZYku/f2xX5y16FgagFASrtKHjceUaA8U9ZOwpfF3pVpFQY2x
	VQGWr3hxyd2PxKVjB8Oolas/vnNvnNs=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PYbD17nu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=N25SM7QW;
	spf=pass (imf17.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014644; a=rsa-sha256;
	cv=pass;
	b=g2fIQZ3sS1FPTWbqwFgT4twaLIpeqE9t/LL49ksvEQAsckohFePeHmzeekZ8pUrmGdCQeg
	Z/T5WxOnko4182PFuPBTw15qiSGHcKPNEqQm+4aoBkpIu5oFs2hXsGOT3/9OUBZv86dTqM
	7mi3nSxFVBYK7QsljEb8MyW4fL8IYaA=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LDEfgn3031860;
	Wed, 21 Jan 2026 16:57:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tgkE4OW0KG6KU/HEahv4pxM8DZ5R+yPd67+MplgFSU4=; b=
	PYbD17nu4LgR/B5dwOgxjZnQ8pOv0mlIeBLTA5NfJxIgMCoxe7pA3EmTfI5u6PHQ
	ewQW16V1huU+uN6LCEcwRbGuztMZnACMzvIqsDWSIny80mVu8yv6R+8cNTjXuKRU
	lKLfd3LNuRNGjyDSRm06/7YmagQBEdsr45tKCmCP/qBZ8a3NWY4OaqqkfRlWJP1j
	QYpDmmRb6UJHyKPejMSQPzFDw3CwWyPn2N8IJ5erUwf2EsBFdUNYQleMCervOwv8
	1XwUmSiidcAh5/0/+q2UW2zXO+c3BhRywOecUTS/rMsZXNynG0lAdlrW6/ru/Pwd
	UpJEJtOyqoZ9jPh/F+sUDw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2ypx5ab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LGNgJk008393;
	Wed, 21 Jan 2026 16:57:14 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012023.outbound.protection.outlook.com [40.107.209.23])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vbht22-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r2KpxuuMZAqETBvddU9M8GSwMh/y7yl3z3GP+InwNVrDqmB059lORJc/6GJ3lfw8qflvL4hMANt0wJ6suXUrYBN0ZTlznMbqBs+TzfH7AtsIqmbr4ec5NJMm0I3hCTIPavrK745+R1dknTO5U1Q3BhlvqxlBb0/LSHf/WPPh8HrB2D/8pT8gEgk9BloJUvM4JFs3RFScK099bfgx2vPZTITRT3kWOriZsTcn8HyQXwQobiLq5WPax7Mx0XqD6BYFDZbZL6PJVO/y/uElUsNXVVO32yT3WrJ3sA02NpDhkDOVjnkhMig5+fVHwWt0DeXhJQgbPsSSVK6WLMbv04b3+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tgkE4OW0KG6KU/HEahv4pxM8DZ5R+yPd67+MplgFSU4=;
 b=N7p8YHUD59gaqkxO0hHNJZJU2Sutydbypr7T+eI9MAlHg2al+ymn+93QrAknYch/PaSo5EkJJtW/6gv3SDJ6BVuiuxb3idECze65GVV1E9gh/PaGAOrrn9Bk4kB9ZHs2syLuE6D3HMyGSeQfdqeTlDX/wFX0Yokg86tgyD/rGK6dsN1KylMpE9MTPm85ir5l0Yo4QShZWLi9FIv18eXn3ScA70nGQfMFLnPTEPG8vdoOtJGMIwvOyJgRr8PN0wfhahNYgaHKbxm8eML1tfuJ0+JFVf9ONRY55s5WuiGoKyN2oVmnt9STwkOwtvX2bJOzzqil1nbPAKBf/VpqnrEeTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tgkE4OW0KG6KU/HEahv4pxM8DZ5R+yPd67+MplgFSU4=;
 b=N25SM7QWl+C+ZVP7s6L1TUXabHkr8i1wlyNUXNN0REN2qb68Qxc1oo2mSVwaQzSShssUXAjD1/nfK63xHb8zVFS54Gyiz9ukJ6W+/pU8cAG+0PIPlp1pkGUbtoVxdIOoZ8TRkdoR1dlolNH5kfqqAyFvq+NaW2g/+wDejF0ZnV8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7727.namprd10.prod.outlook.com (2603:10b6:408:1ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:11 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:11 +0000
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
Subject: [PATCH v2 13/29] maple_tree: Inline mas_spanning_rebalance_loop() into mas_wr_spanning_rebalance()
Date: Wed, 21 Jan 2026 11:45:10 -0500
Message-ID: <20260121164526.2093265-14-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0076.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d0::13) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7727:EE_
X-MS-Office365-Filtering-Correlation-Id: df9653b5-8cdc-4a6b-cadd-08de590e1e91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VH7iru4dh8Yz/9/pj5bDc9O5Nj5656/RawH6bPSs154jmY79NFPob64+zTqN?=
 =?us-ascii?Q?Ei2XPMHV2ONwR63CfUW4eLjTZF4Pdm3YLIINEYT7q5+jl1VY2xnW5d0bap7r?=
 =?us-ascii?Q?xEfNQsRnoPH/EgnShZQGtZvubPbD/M4jkcYVivFsDuVmYtHVBvVC5YB+uBIE?=
 =?us-ascii?Q?rEMLmq49I7ZW28f7EWG6tOdIGzD+ffoRGJGq0lFIkuKcWEPRvaE8waZbz/4k?=
 =?us-ascii?Q?x2PvGnThcniWOspEM9ovAlVsl+c6N8qOLyiuRnVHVIDNhArG0YfpHDH/ntzG?=
 =?us-ascii?Q?IXmTDaH4euo/wLwKnEdXgOnI1Xkiydapn4invpW5DZXecDMSDDP8CcToNlbG?=
 =?us-ascii?Q?XskvHC68hN9nuupBfJUMvfR14PvN7n7IQV+yTnLOOMKEto9MK0q6XDes8Uzw?=
 =?us-ascii?Q?Se5KUsCNJPlEL9uGAiHkhQpALdyG43dIwPFjYmLLJLNCR+mpbMbSx1aq3Pp3?=
 =?us-ascii?Q?aLYHZQsrlGilN1HCleOeFDrUOrnhHgv3x8FMq0Jy6mr9s52694bq4Bj4X/Yb?=
 =?us-ascii?Q?v1IqDZdaYoIMNAQbv8+tcB1vbdwz84oYibHsWcLxJfSsbHQLUfsne3Rn67is?=
 =?us-ascii?Q?xXEqu4+DmUNQNgq6H27if1zVweZwM5vvMowXT2ENcbnEc13wZdprBoRjcrJw?=
 =?us-ascii?Q?IQQZS6BG6zb1sWLl2q6+xHj6CUH8aacTRkPdllqzo1U3IEYV7VMYn30fQfDN?=
 =?us-ascii?Q?NkUVfEYwoQ7ySXCWLswi4IRonPEq9MrCAPW9GTCvaY1RblNviX7Qm41JUvfQ?=
 =?us-ascii?Q?XZSFpouLL0tejOdWnbfe1iBuYaSQ/egh5OhPkWhdc/bFmQfrCrBFWxUiN/I3?=
 =?us-ascii?Q?5aoJnvFH6M2ojqr3SS/jS7Us1asteNg7sgShHYwt6RszHQfUJ0TwC+eTFbEZ?=
 =?us-ascii?Q?kMTf+D9tz1JFYO5vnBhYztSf3bPA6Ik+Kxiz0fHss4iUjdl65Xfm6aqqJ/w9?=
 =?us-ascii?Q?174+4tZuzhcF7CQQcjyyKGG8GLkaiXvF8mJ7lCaQzLgrw//e/sVr/J0w2gOI?=
 =?us-ascii?Q?HBNrRqdRs9K0IAoCf0dUh4MSwQR97B6r0JSBWIbQMO2kuKPmPrftqh1Fy/YP?=
 =?us-ascii?Q?V3N1huDj5vf4e4iyBITuUKe00hUtVQMRja90u/bW+0r6RXWHsj77TDYAs9N6?=
 =?us-ascii?Q?9dCbUYxizHIC/EEJJPecvv5RLtmQIIC01D/jrJsaZ7eiwF87zKjo9mhYgi3C?=
 =?us-ascii?Q?xWOFMfdk2jfrVsUtLncp5KC7fqq813VgdpF5c24+LCD/rAmIVukLYz3OxMyu?=
 =?us-ascii?Q?oybxxcN8VtIRoGOqSyLVbn2yTxPUUH1OGMKwtKg4MwClFf8gE8Sa/h3vsLWt?=
 =?us-ascii?Q?8EBCbrzFnh0DSp7LNFzXLTsYDx0RlvDxkD6Fbmi59FlrfjQYMh2XiftwRQWC?=
 =?us-ascii?Q?38VRQ4RBXGNy6QQpo6xHtXzaGU0pWaQO2wx0lwnjuD2nB4ANmEDBEiZis0ZH?=
 =?us-ascii?Q?dUPWYlrTkkb8kjeWZeJRn3sgq+b+fOiRIYvDHBZ6QIZVd4IR0J88M6haDl3Q?=
 =?us-ascii?Q?2KYPiH/tNQUE+98xShDB/wmzCUpIGDDWao81c79P/IH1I1JcN48M6aLfHrzY?=
 =?us-ascii?Q?gvVf+LXO3ncRRXQDxag=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oNz21SDY1xkxm5S+DPJnoIiwNULflANQpwNuHZxhOF3ZqCV9kGwm9ZIp2c4G?=
 =?us-ascii?Q?y1jjW383hNans3wJDTNr21YiB1hq0DCSdsejTM78+mgvaY9P+KYBbPCNL488?=
 =?us-ascii?Q?cqNhEPKhtDZQ9wOvzi01rmsPDtU/k1Kt4dtVbDmHOt27AXSxMrlH/WNGvEMw?=
 =?us-ascii?Q?mTv5I0jm0FThteu5n10wbT5Sd9hOLGlfMD2+VHOJ33cv/QnkTpGLnGxaWaRH?=
 =?us-ascii?Q?bjF9gd5lZu50Uz1x5FdwA1Zg4ywPuhrJHiOui/lCItbATBCDgvghiT7VkHTT?=
 =?us-ascii?Q?wm2/4c3+NXvDNyinmyMcyu8eZ5svYEvPV+Kq98eqZg9ACOK+4QQeaXl6aRJh?=
 =?us-ascii?Q?S9oUCC+CBd5oLoPcV+ZsSldQjqVrT4uepSL+aGMxWfyJ16sGeAkI4hcDb+vm?=
 =?us-ascii?Q?Ed6dXjUl+Ihw+VKqGQ8DftfZJaRa75gnVLB8EXLR3nWjS8ksffsqYABIwyj3?=
 =?us-ascii?Q?54rqGOz6wImTBLWdNnG5nzxdC/ritp5wCnXhi1uDznu/PzMtTPq9vyCZNPiD?=
 =?us-ascii?Q?a3q3H6+6o9Ga/5M7J6CFBJHKKTxQdFz3OsuHf5+OyKSJbHWlkhYrkwXgtQAT?=
 =?us-ascii?Q?26s9DmsUqhOKIdGiN0ZrgqJRqD3sZmVh4CW3QvZnz6HOYAgA3pK8mUmX79ZB?=
 =?us-ascii?Q?XNP4do6wPxMwtTuS07dKXoJBt32ZFWD4oVJj9J05tw3zth0eQnDWhHPC6rr0?=
 =?us-ascii?Q?enw9GUng5PzwslikhzuXkRsGu/D5/IPqa9edhJVH9dpMrzZfZr8v8ERbbHsX?=
 =?us-ascii?Q?a5pzPfiPbU67vulMlQWyOQXPB1NblmLKDvO419UaxdDyKt5Dp8DS1gRz0qC2?=
 =?us-ascii?Q?6qSPWOlFgia5/apEkMA8ab072YbLhhawDmjPlAjY8ooGbeSl+Fbw8TT2WApm?=
 =?us-ascii?Q?CcqaRb9v/SMdG1EJ7Dxjg0+SqC8v2d70diLPQXJya8CkCKZjzwyVAurXrUpt?=
 =?us-ascii?Q?gFeJpElp1Mbm9Koehse61if24ZqhqnuYrDIhAg2tSRYnXJ8/YrAxHl14Jkam?=
 =?us-ascii?Q?0Rpb14nAzhRYzQsY4GAVhGoDStDKmFNVRKBhHyBFCY2DxbalaA+8ADWTYaPc?=
 =?us-ascii?Q?nAC3wSXBRufAsG8qiQSpWonrQzXrzOb1YMR3qTbju9wys/VrzrEfe2UIHq3x?=
 =?us-ascii?Q?XymKAyKIcmFehIahoTqhs/MOw4N6UqlMOpOrVRntmh6g5eRhJBT9/gol3p7v?=
 =?us-ascii?Q?0qP/xpfSdcYKPnQrlDuzGHLwp6J08XQGAJ5rjNFRqJjXiNj3BJq26d1orSBn?=
 =?us-ascii?Q?BlhGxz3cLv204RHtr1yhXsenpzSwxTDK6jXZzTUyxmdWP/EfUzvkyPyXANGf?=
 =?us-ascii?Q?cfVjFrOWkdrdZeD66qoO7x4dnVxXZmVVIYIvZlM75dt+HUUcQi9/HdoqU49E?=
 =?us-ascii?Q?lBkb3Q9JIchp/+QlaqF3x0NfStk8xoBt/Xw8n86z+5ffCyiPmVVswD8PODVF?=
 =?us-ascii?Q?UYiA2EzS0nJkF3sLwcJdtZRpdGplLDGcytaoEW1W+HKbtUHMjUkhhh8a7Mot?=
 =?us-ascii?Q?xoyA0vXnCp2RmkzeJXcdZZoSeBXYm+WRi4x37r79cNa7+MaUa6VV/E0ryO/h?=
 =?us-ascii?Q?dXACwM6C2UwTznbKaz0SJDZCL4vkdOlPUUUoISvR3oHzfgrWyMmibalA4VWF?=
 =?us-ascii?Q?VmILAobLHH5xRpxytZcsNjUakR2gnyEext/vbZ9lL6Ag9hkuYu+zCOO38bdG?=
 =?us-ascii?Q?XeQV7nIQgx6OA8CsdJdBmmhqAjuxZYFFc87tW8N6Dp2r5EOszMQfHMDwSAgK?=
 =?us-ascii?Q?osI6Ni8/CQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qDEdqE1hsrPMHNOIFsMBgPogUq7aCZRIYS9dAuOYPSJPf49rLmN6DzN9O6j74c5S11MQuDA/fy/5tUdUjBnsudr5z5dEthEH1mnSRgmEBzLy6Vcxq0MAkaRRcW7KtOr/5gyTDykFfdIVg3VfU6x5L4TO44em6490jORZIrZxVPZRisaXgOXwxNOPyWzZqUq7kORSF5AdO4flTIPv5l6gB3y/Kox/mrmRvv/L8r82JQH7LWFR7R3qTA9uzdp9J+/jNo/fsBYJhY9RRZIGmGO8ylGVg2TNnI6DKZT5AAEVqSpYLRSjj8DcneTWq8EQBVyTT/FuW+JQnMId6kI2gzboy/F9mksc31V783/m1FQv1m5ZEnhNu24fvgKrKvRo+f067t1U7Eiv+/NQB51/3NHupC9o9Lm8jNmuHUUsl6OaWUYz6zbY4gt2pz7RLuReRYFZM6LfkAvCWdZXpMxA3z0RzhCT3fAf7LY6ChYGMoByWOV+apH/CaOC9LHD8Z1NilEAfEeb0IOYyvLsIurZdxAXfP7UtBfjNivOvGrp2RWGh2WCXpCKjYx8SdAM7p/ru2pahHGlTpnmyGjWGq+jHCNczs/x6M1jzSsD3l0I6YBFIp4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df9653b5-8cdc-4a6b-cadd-08de590e1e91
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:11.1401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yCs0bqAF7hxTIYaYvZ6VGQ+KVw++5NhFadlwxGmTN7F8nYYsdnlKHHWaFag9I56aLEV10w2sO5GgolRVvsXc3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfX4FVnRLO9UQr1
 wqeDK5zk4UyoP47kFcMAPs+wDIuGv3FNK7zJDMp7jVfeyper3xs9/U8iZJCV7HAneisBS1y9mkG
 /WGpEvVawmu/h6k3Q3KcwOZDWB3qTllb4DhcTBpqZk8fPO/jWY+b7Echi1S2wNfaFvpDzEWb9sQ
 K2/0Z+CcCG67et/Nknf/XeOFJh+/ZMbvUIr0eqyXMSI1CxRsWndMyJjdkGTFWnD6AKHTJPGKMPV
 7vuZG9MjLOC1XQ5dJY6ywb41Wdk8UJ6t53KNym8ftrfA8l3adITqK0bg1CWmnZNgiE+Yqd1BqmB
 bbAgbTyrovPStL1/gq7bfEXmJD2ylIIsiCFPsxa3ZJC91lzueZo2ygHpYSKTl0HIRYPEq4sxhhM
 RRUur2PBX2iuaaZgndW7t70zc4TJndGZNVX2ZXSbFD7RrbthL+TUGQYznXFljsvesXgDk0GTTSK
 sANm92lGCHXveZRehvA==
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=6971056a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=SVrgk92_VGy3w6ovwu8A:9
X-Proofpoint-ORIG-GUID: a9wInoEQPT0l05YZAy_XLM0uotLSYl7d
X-Proofpoint-GUID: a9wInoEQPT0l05YZAy_XLM0uotLSYl7d
X-Stat-Signature: 56bys66hj6akogxqeimn9ytaddtn5y55
X-Rspamd-Queue-Id: 89A9440008
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769014644-214293
X-HE-Meta: U2FsdGVkX1/72myskuCrp4J4r9oglTo7PePchqb4vymlZwL9YOW5hJPV8TSKH5DJaLpNDRU0Wrwtz1QdYQD5ao5KV7kNGZHOU5fDp3ibbjrS7iGOCY1bQp0ffaGHvkWxf1QiTsa3n38j3VPe053iB03mZBnmSH6jaEplaKkmxeTsZKFoGyQzrKxQKjCNjjabeYCWnlxGZzZx0seeWT9JUpIhAwuZ+s7UkrbUZEizNfMrTKEVzXMrW7gcKAZqD2f0DkxpC4X3RVGRTH0DXgFOTHjjb7jlqnYHb8cnkaIAV7mNsfalsnzRLBxGPuSTunj7dJVhbS5ktNfkAttjQLf2fSsHrvof25MZxTZ3Z5uSdrLSKLDbTR1F8i2x+IoyoLGjKdEuzg4RnTaCzALfqR8XYUj09UEQ3GJPjiaw7u0X5wSWMcLsANe6f/NFhMxlhcJWjFp6gTmDeuNnS63cfSwPsJs7wbRHbdOhAWZO7rsejPcMFooz/cfy5Nuvg9wihQzPoi4KIN8YFXn5k1eVI4PCmG+j4FiBJOMH5ZR0OxWBXi5dW5wsFfWXdgyBvUi49gtA5KVA1qI3T8kJBhEa08PJCWULmJVU5i5SWwX1Je9KeHMp502LT9lLqz+gR88fUiamF3MYZzoXKcuB9LqxGlC31uVc68/59s3/eOHP6O5MAuk6Ue5wcoULvkzMaqMYzjrgTn2Mq0SmrD9qElbcPAI9iAZB0XeodiAE4nHy/p9KFKj+Rfu/Q7HyNf8HucgolmU86IIlEkw5UMToEv2Be8+NnlH2jHUszvlR7JOAwB0ZjSd0/fXhpQtZ7J6kNGTsUaEGWGhMyJ8x3iMRyKG8pSJFg4garjZRex0G+ywjzW85T+Jev5YoLpqlxDi8oduvNoOnav/iNZRobE2eWeNcNgcihYH52sVQTWETf6YVJ1J2VW7F4CJ36a4FJUhfXWpOHyznktIjtuMFfZm4W/JBlKS
 KNTddr7u
 Q4AUvrtlqyIkZicv33xQg4xV6EeMOyZmnLAn2On3pchdN4IZ/Y04fL+zAkZUnfeHjuM2qoy7nqTNT1CdoWJginp9x56vu2wKaNobLT64B2hGRg7rY0fHtw1tu/3zHdAJMyvcgbb52hmtdrkE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just copy the code and replace count with height.  This is done to avoid
affecting other code paths into mas_spanning_rebalance_loop() for the
next change.

No functional change intended.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 108 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 107 insertions(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 554fdffd6c5b9..a9b7e398c7dbd 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2862,6 +2862,13 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas)
 {
+
+	unsigned char split, mid_split;
+	unsigned char slot = 0;
+	unsigned char new_height = 0; /* used if node is a new root */
+	struct maple_enode *left = NULL, *middle = NULL, *right = NULL;
+	struct maple_enode *old_enode;
+
 	struct maple_subtree_state mast;
 	struct maple_big_node b_node;
 	struct maple_copy cp;
@@ -2917,7 +2924,106 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 		mast_spanning_rebalance(&mast);
 
 	height = mas_mt_height(mas) + 1;
-	mas_spanning_rebalance_loop(mas, &mast, height);
+
+	/*
+	 * Each level of the tree is examined and balanced, pushing data to the left or
+	 * right, or rebalancing against left or right nodes is employed to avoid
+	 * rippling up the tree to limit the amount of churn.  Once a new sub-section of
+	 * the tree is created, there may be a mix of new and old nodes.  The old nodes
+	 * will have the incorrect parent pointers and currently be in two trees: the
+	 * original tree and the partially new tree.  To remedy the parent pointers in
+	 * the old tree, the new data is swapped into the active tree and a walk down
+	 * the tree is performed and the parent pointers are updated.
+	 * See mas_topiary_replace() for more information.
+	 */
+	while (height--) {
+		mast.bn->b_end--;
+		mast.bn->type = mte_node_type(mast.orig_l->node);
+		split = mas_mab_to_node(mas, mast.bn, &left, &right, &middle,
+					&mid_split);
+		mast_set_split_parents(&mast, left, middle, right, split,
+				       mid_split);
+		mast_cp_to_nodes(&mast, left, middle, right, split, mid_split);
+		new_height++;
+
+		/*
+		 * Copy data from next level in the tree to mast.bn from next
+		 * iteration
+		 */
+		memset(mast.bn, 0, sizeof(struct maple_big_node));
+		mast.bn->type = mte_node_type(left);
+
+		/* Root already stored in l->node. */
+		if (mas_is_root_limits(mast.l))
+			goto new_root;
+
+		mast_ascend(&mast);
+		mast_combine_cp_left(&mast);
+		mast.l->offset = mast.bn->b_end;
+		mab_set_b_end(mast.bn, mast.l, left);
+		mab_set_b_end(mast.bn, mast.m, middle);
+		mab_set_b_end(mast.bn, mast.r, right);
+
+		/* Copy anything necessary out of the right node. */
+		mast_combine_cp_right(&mast);
+		mast.orig_l->last = mast.orig_l->max;
+
+		if (mast_sufficient(&mast)) {
+			if (mast_overflow(&mast))
+				continue;
+
+			if (mast.orig_l->node == mast.orig_r->node) {
+			       /*
+				* The data in b_node should be stored in one
+				* node and in the tree
+				*/
+				slot = mast.l->offset;
+				break;
+			}
+
+			continue;
+		}
+
+		/* May be a new root stored in mast.bn */
+		if (mas_is_root_limits(mast.orig_l))
+			break;
+
+		mast_spanning_rebalance(&mast);
+
+		/* rebalancing from other nodes may require another loop. */
+		if (!height)
+			height++;
+	}
+
+	mast.l->node = mt_mk_node(ma_mnode_ptr(mas_pop_node(mas)),
+				mte_node_type(mast.orig_l->node));
+
+	mab_mas_cp(mast.bn, 0, mt_slots[mast.bn->type] - 1, mast.l, true);
+	new_height++;
+	mas_set_parent(mas, left, mast.l->node, slot);
+	if (middle)
+		mas_set_parent(mas, middle, mast.l->node, ++slot);
+
+	if (right)
+		mas_set_parent(mas, right, mast.l->node, ++slot);
+
+	if (mas_is_root_limits(mast.l)) {
+new_root:
+		mas_mn(mast.l)->parent = ma_parent_ptr(mas_tree_parent(mas));
+		while (!mte_is_root(mast.orig_l->node))
+			mast_ascend(&mast);
+	} else {
+		mas_mn(mast.l)->parent = mas_mn(mast.orig_l)->parent;
+	}
+
+	old_enode = mast.orig_l->node;
+	mas->depth = mast.l->depth;
+	mas->node = mast.l->node;
+	mas->min = mast.l->min;
+	mas->max = mast.l->max;
+	mas->offset = mast.l->offset;
+	mas_wmb_replace(mas, old_enode, new_height);
+	mtree_range_walk(mas);
 }
 /*
  * mas_rebalance() - Rebalance a given node.
-- 
2.47.3


