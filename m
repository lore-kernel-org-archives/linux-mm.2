Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 433F6CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 09:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FCC68E000A; Tue, 16 Sep 2025 05:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ACFC8E0001; Tue, 16 Sep 2025 05:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8743E8E000A; Tue, 16 Sep 2025 05:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7193B8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:54:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B5C413BF21
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:54:26 +0000 (UTC)
X-FDA: 83894653332.20.3F27255
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id B81F420006
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:54:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EKGN1W1M;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aaZM6xfs;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758016462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uy8zz+QlRWnclYFbe3Fg0kFhkAk6JiMBrRe8A3uIaqY=;
	b=nALmaiO5Woo2ADmhWIrAKHq6T9niF1Yv1IUJHFBgklR5YhI0hx+Gok3Wxaz7DjhYTu78jK
	l9aXFz3R99sUGcsgPHAs/6+ob5Pjq8FJjcy+gH7xjC3AB/c6sX87H4KS/UizqORheBJAKO
	Tjs1BVfZzmrXwlt/WEQUPyyIzcVtoAw=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EKGN1W1M;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aaZM6xfs;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758016462; a=rsa-sha256;
	cv=pass;
	b=dDMf84nD99RpI3sh7H97RaGY7Apx01JoOiRhO36k2gLfxI1Ud79TyWGnMiQX6RdVeGQhpU
	r7eVRNJx9r9SkaYb5JnAc1paybynEBK1R7KgcQsgqQyRS37rjSvdQfzVyaR6ttEE1hpzsv
	LCSLDjz8W0fk7baApJ8fa2dGtUQSJzk=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58G1gCLX003101;
	Tue, 16 Sep 2025 09:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Uy8zz+QlRWnclYFbe3
	Fg0kFhkAk6JiMBrRe8A3uIaqY=; b=EKGN1W1MKTuXYuzL1SK5mviHOXxoJS7PWp
	Czj8jx9WxIQUmk+X//MwgPdfaAutFnJsE50XEw6nVSMTdPCO8qgt60Oy4oCkuA7k
	CnXHRQgp0DJsIiwsCPNJeoARNtF99lHZLkucWj+rzUK3laHNISSNZnKLyLx26Lmx
	z2FDXZz14SKtzVY0Nk5KF+05C8v0V9b6YSsN8V6wPIIf2GbcxvEZvu/52djrcXlL
	jnFK/TWCBN+duWRTb+8p5LQVkLDcXnWaGhL327f7k8MOA5kxcPOIk645kgaYFs7S
	6Pv74zPKfDjuWkJkFZXJ0nXynyWpRfxlzX/Wyf/Z66ysKWrbiCMQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4950nf4b2w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 09:54:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58G97kSw035162;
	Tue, 16 Sep 2025 09:54:17 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011042.outbound.protection.outlook.com [40.107.208.42])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2jevrw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 09:54:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QduN6I0cDK/trTj8lJ4QJifGXscPA/rJBUJ2Y3wABIprp4gwzNKXR9mbOIIEqqdyObzbOQ2RXxKxoTb1o33Up5ZiEHZtvH2SnaqRlQ3MhZBhMZKySyyI2TjD1ai2vD+thpPuII4FzFCAQr63O0aDZrSWGkg+YviZx0rWu5KoYu5oxevw4MWCmgnNMGXDh+8o+YFxtiZ8JkuBQEO/NrMxciNWLs6ZY+nMUW+SR14ZkNlZo4ixfV6Joku6izjRp7svCDl7nhVk+f6xxsSaZjeaPKn6JGgNyi74gRMqI4ibtmMNZTmVGli4Xo8sjOsGj8Wkzt+0LfEj1xDcQCjtKG849Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uy8zz+QlRWnclYFbe3Fg0kFhkAk6JiMBrRe8A3uIaqY=;
 b=riOFdzFSZVJgqKShA1eRPRjgUCkvdFLqGUgQFvqW8CKmMkMU/t6o1Hc6vXal6XOqAG/bBDZpmL43fjoTfl4gvYa4j5+v6p/rjKi12UDVWNyOEZYl5r2U2nDwPL0CDVK6ZeXFiYYlFsqc+ZEiEDvTh5cG9qOLdsCvK0jkAZPhp29c1IN8IBiR4jyiKU/ZahXEiOAQgpmIM5YwMXaRM+LBCLAh8XGgPU6gudvIEyHU/em/6qsWCTIps6lg6yESHOeHr7y83oRUFRyDQtsGiAgh2qkOByhya2cV9xjiMYBzD2J63ldFie//AEvGcDUQTmf1XD6J6+vZaR81Mh4qxlEk1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uy8zz+QlRWnclYFbe3Fg0kFhkAk6JiMBrRe8A3uIaqY=;
 b=aaZM6xfsiqqajpZ5nOK61AmmXRJJXzMa/zgVVXpBeD7fSOhF5Q41vACCmetwxLMwFYc7pr+713LKkxqrfeqzBZ+waqCZ0/XNy54TExdXMuWOKqn3zFt6XEC5i56/AZ4E342rlfDVpZoc5VXAWjLK+3iHRliINShDV8Rchsvs96w=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS7PR10MB4959.namprd10.prod.outlook.com (2603:10b6:5:3a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Tue, 16 Sep
 2025 09:54:14 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%3]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 09:54:14 +0000
Date: Tue, 16 Sep 2025 10:54:12 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] mm/khugepaged: Do not fail collapse_pte_mapped_thp()
 on SCAN_PMD_NULL
Message-ID: <ecac1e7f-1709-4348-b8ff-fa1c0f087548@lucifer.local>
References: <v5ivpub6z2n2uyemlnxgbilzs52ep4lrary7lm7o6axxoneb75@yfacfl5rkzeh>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <v5ivpub6z2n2uyemlnxgbilzs52ep4lrary7lm7o6axxoneb75@yfacfl5rkzeh>
X-ClientProxiedBy: LO2P265CA0018.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::30) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS7PR10MB4959:EE_
X-MS-Office365-Filtering-Correlation-Id: b60bbe0c-98e3-4ccf-fdd6-08ddf506fe36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VAf4oHOZL4QoDbrp72bCU6pu//9Asp7j8hv9APz3Ug3em4dyB+6M75nWwyMe?=
 =?us-ascii?Q?8tLOlczYznCRzfvK5NnEFx6IFymcYm8fQM0rZmxZm5aitf78wocgcdRQnpR2?=
 =?us-ascii?Q?XIBErGM2QgGSKn9n/XvPB9bhXWLMHPYHY862fNYBec4916+edoQmzCZ1O4Ie?=
 =?us-ascii?Q?Et29iJWo4b7euqYxKBqEdDVZFw0fQly6lPYnpr+Wcembxo4rVrmaQgXY+6VS?=
 =?us-ascii?Q?NnbMWthg7R1FhVp1Fo/Kgo7s6J0AB+Z9ldnrVpQ0PhRMK93JY3iPQ0VVKCm6?=
 =?us-ascii?Q?+X2HMFbehnI8S/rT7Y8PS7x3GN4o8DrKXGTcvXJ2Tw9a/BYznIRZDxqiQfjd?=
 =?us-ascii?Q?kDfPzq1iiAoimUWdqr6W1KDpHj9wHb5gjlnneu7D9rTDeEzffKnqXbpOyvej?=
 =?us-ascii?Q?9TbZlNcCcal2ggfewua5W0jU/C+gEVxxmsgmoyTzVo+Ircjl0RzL1lznToga?=
 =?us-ascii?Q?YPY20m2bqidXQ+pYN+DpxfZyRGanfBDkF1SErS7xFrYocILxt0OlX6wRszME?=
 =?us-ascii?Q?sP/zFItF8uRUSEK4PTiCTtxkO+1JWEJFchVqA27RuPXieOqGoxumi0LWjXcU?=
 =?us-ascii?Q?b/Csjo0X1fgBLXuqyQUb1ypyI4yo4VNl4ajcN+D9Vnu736oX9039McN0eGs2?=
 =?us-ascii?Q?pZdiRSVtPU2TbBwwfoMBAVAfMktiiOcrbqpZbazxKqt+ZCInc+S/L27/sDOo?=
 =?us-ascii?Q?qpaKYa+2bjsyiClbrgX3HI+DHvZjgjUiYIpGL0JkX3Y60f6IagG3eNPEW0XE?=
 =?us-ascii?Q?X7NPAskas77NtXpCZc489Lp2To1RYV+X+AayZOF+uAk83pPTlkMbIs1LDGL6?=
 =?us-ascii?Q?oXS2B+4kxywdp77DJfzLMO6pG0MbXDmdPaDmJ7KhTxCJJqgCfuT9CLyKjmYQ?=
 =?us-ascii?Q?/Av+BbgiWwOxULFA2oC6LIpVz+Z15/6v59DCeofKHGpwTYvAgCc13fzrKvUy?=
 =?us-ascii?Q?L3RpNDPNJ2vKkqBjsZAc1I1jKx+B5dqs3ejDxGU4CRl4Ncf7FgIq2Igl6ozH?=
 =?us-ascii?Q?ObFbBw6LEoEN5hIUD+9K/c1Kjyq+EVt+GgzAYreKGOBGh2pW9Wp5a1G+9bGr?=
 =?us-ascii?Q?p794+POpfeaCCAKees8XwW1Kei7QiUxQ/Dp5iKJXicS3OD5lJqDD47g0urrI?=
 =?us-ascii?Q?+0dFMqNP6gwHdEgDlg8J8+OC9jezGdRQJNniB/VrrFBsfkrRA0Qk76cnXJni?=
 =?us-ascii?Q?A1Nt9jHx19HYPy33+njsK7tMTezF0sfgjiPUWvStzY/Ns/y1pE/Ws8x0knO2?=
 =?us-ascii?Q?jXlr3fOJFLsy9He+5ssXgW5zxGx6PnNiASGQ51PRULhcC863BF+YjOfTr9Vc?=
 =?us-ascii?Q?n/RZEJs/3GOxCaJOVcwmf1H3cwE7pnVj4NT7Gzi9aekMvOvkaIhv0bUcA9+b?=
 =?us-ascii?Q?2lQPw2avFuk41ys8dAl+1gMFdc/cCbcAvDaJ53tT4N/jdrij+WK4pmqGkh+G?=
 =?us-ascii?Q?jE6PdJ8/1Gc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/8lNUmHtCReTk/UHVq9/6JSuGSuALUr6umkbtl7+1n910wS4AxUp2B8ZY7bS?=
 =?us-ascii?Q?MlvTPwnlOq2HqjuJcnTiedHs8lPu/zqBiq6nGyx9hFD1rm7Zd/K3RFeCZEqC?=
 =?us-ascii?Q?yjzqjRFBGEWmq/b2L44eR0Y48Cin1BkvpcTx35Llpsn+kOskP1erbUnNF/XC?=
 =?us-ascii?Q?D+Cs9ug+hfoTyPqGFPK130jWeajk3K9uksqSEPSice6if+tRHZWLk5Q/GjDp?=
 =?us-ascii?Q?4SYSDIe4yhzOJIMm+j2SnYqaCBarlOqsalrkAyciRwC+3G9Kr6JjtQPmboq8?=
 =?us-ascii?Q?J2wFKK4dUuQFWdiIoC7u+b5Yn5xk8CRlPR+jUoRkaNqBMXECa7DCwjOaOkSJ?=
 =?us-ascii?Q?EVj+LQH4v/ODtgqSXv1djS0J4lJ5LYWUPPkdlGDg0Hjnr93ut92ChyLOZ2nb?=
 =?us-ascii?Q?9H7CZCFd5n7FYLdBFjNvDVD0RCPTuVnyVtO79DjpXtrNTTbm0vfhdZoQ7/+7?=
 =?us-ascii?Q?ufAuXLYvavTBc81qnhDcVFCIw0n46QNlCjvGOcfFcHHTiJT+0gK+6rOM3dwG?=
 =?us-ascii?Q?H864LhYMApazrDN/h4OBFKUyfej/IwaFTes/EFNElbflQse/mS9O1qslCrCF?=
 =?us-ascii?Q?HdMgii24M8/tY+RNEYgNV2dA5swARSxPvFBW2M66vz5ia7FN0rm2PkyzZSS6?=
 =?us-ascii?Q?cx/A5KUySkRsSJPAum3rOau189cTLmkSal0LNRSudM+dcvCvmwYxpnvr220g?=
 =?us-ascii?Q?8UR8Fyf1fN+PiUiVy1S017GwGgbunTvbTCTqeZIMjfMfKwolppr71Kz0pQ72?=
 =?us-ascii?Q?EjzSOwuiiPyraDEdtuWGLB1aNtYcGFpYylCAU7SfhLeH8RlJDMhIQjv9VJRu?=
 =?us-ascii?Q?mTfNY2hMRCqtpvloFjyTSg5CjFHolbhDGMUtJYjk1WfIj1uxnGyO5LtURbEN?=
 =?us-ascii?Q?UlZtKrrOAElHAvQsrX2vhKGfiG1Rknvd1l0f3024q0QkAydw5e/j7zJm2FRc?=
 =?us-ascii?Q?qjplXY+qe4atkrRP/5vG1+mgwoRVEL1dS34Qb2Bv+EqIbknp5tw1mmfXoXxu?=
 =?us-ascii?Q?Yf/ipnWk9su2Pit6PcvyUzO7PYkyoroVDOiYAxlrRSazD5nf8Qk5CUDTny0j?=
 =?us-ascii?Q?Wt6HBHgpJuxMYg46NcyQnrnPsSJ9TK32rHNW62EG4jTJ+ux69FVCXFx+k3Kq?=
 =?us-ascii?Q?gQdkVKVrBZzGkUpq8GuupsQCqQIxCmjBunKk/u4i56ZxNqrqVg/6mF1AR1g1?=
 =?us-ascii?Q?Q+jwqWzhZ4ZbFbpx58HdcWdU8+Ojx50lJByW8s8lb9TxW2AsJ2+uwloJaSmg?=
 =?us-ascii?Q?CICQJ4ddwjoq0e692TxOTXD+752NF5xYxiiBLSQ9Ih5XfRoFFW375YD2+pvl?=
 =?us-ascii?Q?kCYmwg3BMCuHYQuMY/ifDsaT4MXkkca/v/v2YhnNpiTwgjmniuKvy4P2zCSO?=
 =?us-ascii?Q?Xs4RrVAoQl80hLeQ4mzuowFxCUsyg+XhzRnMyFct23iuFiCfM/OcjJaB/bwB?=
 =?us-ascii?Q?yLR9LPdaJGRn64HLcHVeriX7Rckmnb0Ra+b+KzJpi1hZaXPbGKQyasbT8Aif?=
 =?us-ascii?Q?a+f7VH45PMr3QuwKzp6aNIa8l8H/LKUy9W5NewoQnPJIYfo1obEhJTGvNyqF?=
 =?us-ascii?Q?KrTE1LKPG/CA4hI3Fy2KepBSeZ0QfzZBeWelhh2ErY/yMisiu5/5t4TY9ex8?=
 =?us-ascii?Q?hg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8giZ2LmNGUpkST75Dz7mxocXDb0R/Q2H9tB+ydZcO9lJvnW3/56b6hk4c7fiP/fx2s4ZfywHQP0Y8S2MM2fQT47tCGTqm92idj35VJHq9fP+CyVcCYXtQVohTN8MXGpQmg7C+BU3Ba9B5eLTh4duJUVb6tBS8J3QCWzZMjQGnmJjp76uoqIFJtg7beM6dYxEsSOlbDrBbmQibasSfpFkmvcTCxn3NERuRG8ADFL/1Zg/0OQ5CG8xcqbzDPLu7/9HyGf2mzq9/CoGbwKaGHf9fvE5kfs4gg0ntetrAxLP4+EdGounnRMzTtz7uUY4BNIY7xnqySpeJfQhY5LnyzYeWc12pqub6Qa/wP/9rukvLcJ+50llsSdan/nYQfxrQk4E+iAdukS2oboi6O9iOE9BJmIILDLbbwYiRmVjH8HwaZpG5TU3wLbmf8xD1d2HI2B2vMUepxZq5MArlMTtxGhG+H8kYwjMlMwV34t2Moeez4SI2W9+2A/FdbPLY27/2DvHDhCtMEbDpektGR4isgIxj0sNf3CAXFpZfoP01vLxNDBbjRWMNyIrO5LnSeUFh2oDsV+YCyvm0/Y8CjJeke1CjJnXlkRuwao7ld93RRQ9v40=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b60bbe0c-98e3-4ccf-fdd6-08ddf506fe36
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 09:54:14.0679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xgcWj8QtgU6YAvvVlvVu9IU2r0uGyDDke27fne5ilNnJnPm78bHhVXmWk0utvA/PysOHtQZw4hSsVTnUBWWnpbiRwir9bq337LqaQxS7xyI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4959
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509160095
X-Authority-Analysis: v=2.4 cv=S7vZwJsP c=1 sm=1 tr=0 ts=68c933c9 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=dsin297h58ZBs74DGyoA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13614
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAyOSBTYWx0ZWRfX1UR6BbSzaTmK
 sOcgok3r+ydvWIGgw7GRJPhZBhMZuC0Msu7R1F0fwvXw/etn9mrCMatX5j3WX7kCG4A4gUX5a7o
 +y1XaLFOrA1hEB4w0WAaaYyQVeOamSZX1fkw8fgYa3kfmvQb0FXVgTuqYedC+iEvYWq+R/Zb7lB
 j0MoKUYBL6+zU3MjX5oS0TmoyrSXNsN7Yw+Q2JGbPvRx1LwAmtlS6MRWg99TtuSk7a/eqa7XYuj
 BnxHaaOWb6CubHD3kPu+lsVHKILe02R7VPjt1Z+4YHmBJrCbRyBXyOPYj1VDKut/lP28PXRDylu
 L1Gmw9W2HFjIlP1pTM1QsCg7/Unicvr5aHC3rYqhCQ3IhkI5xCfH5vD8mN6OPwME72iRCu6XEoT
 sb8g5GdD6pSyMY3nxCT9Z/Y55Z9+pw==
X-Proofpoint-ORIG-GUID: Ht_Sm_XokDFDoqWDCnSPxUW6fCJPnIu-
X-Proofpoint-GUID: Ht_Sm_XokDFDoqWDCnSPxUW6fCJPnIu-
X-Rspamd-Queue-Id: B81F420006
X-Stat-Signature: tsw5bo37ebcrz59fwjkrecimqs9w651z
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758016462-23876
X-HE-Meta: U2FsdGVkX182Ly9LX4fCVbOCy3LWbmWjcRsWb00VWYF6sUSQvhT0dUyHQFOgLGODHmuVLzOnAAnEiLAFasOUjkWP/6IbBv0idAHU8t0Znmpl2lKJ8IG1xTSmaW4fuGwLeoO8WkLsOrXAUSIsK3U0Z2gF5IUqWoFPyuNCB+MrjE0slwn+ZxErh29Bgbt1RlCsP12u3rsDKpom2YpxevQQc5BJ7QNTznRl54fzO6a5tF7hrbuC6qq+LAn2UVQ8wX1Oww9EGtQNTIbQ4jwh0/J/Quni3xjbUyPUyjdh9O48lPd6k3gDNEMd3V6haX4PIOXO90BogGchLmFG+eBg0hibQqxYtC0LX+eU8MVadUXsAFdLpwoLN6ezHg+WylGDyzmj6tzBsu9BgVosoTUyzxinlSqHv5CHfBDFewVf8fkBoGRZnjspd+3JD/9zn1/uQnf0iHywYNAp1A3Sw056NrDgNaXFDGhV9e3gGp2/xDyXf8jCVHZlUW957Ah/6l7iVeIOULHo+AchtF893h7icqDu219QC6e/sKqk9kupI0kijqd4G6tvKfQ5r4SkTLKdxjiRyog5rJgRK10UlJzpfnZHnpkhuFYz4thGbJ/JCrUt513Jq51LclkiiE4ofpGYIfG7NK6ScPc2FQAbD5T/1nfMnVKkFJ9IOiJkctmW8elDDosdAjNGv6CbfG5iwnRA5dT3FleeiS/6Tjaw4sIh1XJTFmx20Amnli/anSjSaafQyBQyiD+tpwsJBoN3JhREAAQM8pS/CHtXz+zzdH1R3ORCQptQWGa1mU5+1Ys2MsJ2zgvHafErf5XuvVUnLmQRVkhGbuR8JJki6PSLFDK47yvPlWKL7WYcNhnWloJMcQLBuTTRmM9TIoZ7lKxbsjj1SByO7DcXP+pGD0E+M5ceGhv8P2TEdN75qz1HOvskUIrGEC/r17LYBTyXGRT9rOJq2KJOtWGeR6StuszWj+2DMMd
 NMWKnHWI
 HJ5TRBbu3SCHEK2OeTplcqJNt/p1Ef9uBBnOY73W7p2nPsOGNvyGvufAz4PhPg18ve+SLVKa0wQTUxQCSRW8HFZWkUQl2UHYFc4bIBz8Ilmm/cX26N8UhPh1/1x3CfJ1Ttl1A2DYRvsVs4tbQ6qennWBR5cmgAvyfsNPgeWnFn6u52h9yDqJ2IH4lYgqnGtedryPKkwa4LPrYPIEmH7rY/zHwmv+PRWM7qHySmOVuCOUbrQmblthXqjvq3p46MQQXdOIqvB3+bHP+mOhDEpT55tuudFFF+dXrpVuviC+NDO+PHVgP71V/p3umY2I5dpQIa4wO0NPQAgIyEI6vdGTjAGSDlMI4CX0PobWv3oWEPSFM1mLD9LUU7uYdFXqPx+CctZPQVM0/Dnqb7Bvp7TNGvlWVVmE1dthKQOsrtU22nUD7ZJUhmjc5z/ZYEQGQYdQohcGoUCg7JJJ+8htoArggcaif/rYUbbxgLQP1735Zy9S87HqBgRQcbTu2KwbCt3AcfUIqaZn95AprEI4f5rKe1eBDhSBh0ctJy/bKBPAWhmJvYYc8iwRW2840apmNwJYpa2IxWymVwDIMnaXG+noJduRjwSsR3cwU0RXTGDYUTEd05sHfilcG1aYmPXe3B4REe0/GlKDB9L7aekUQzobj+lwdrVaZJmcsUTWp0dbxgaw829+rETHFvjUjBIlbuvcp/5nCeinqiKWTNCOzBPGv2M3J5Mhz4o3GRSfc6/4e0Qc5NnL2B7JpwlxSOhGKCWLrjCx+oS6HSZzPiakFX208avFlXNnnOKvrX6xegnfTWRPVJ+rwTli3e9gvBYp03bmQkSvxvAVavkHWH7hTPF32rpS4nQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 02:52:53PM +0100, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
>
> MADV_COLLAPSE on a file mapping behaves inconsistently depending on if
> PMD page table is installed or not.
>
> Consider following example:
>
> 	p = mmap(NULL, 2UL << 20, PROT_READ | PROT_WRITE,
> 		 MAP_SHARED, fd, 0);
> 	err = madvise(p, 2UL << 20, MADV_COLLAPSE);
>
> fd is a populated tmpfs file.
>
> The result depends on the address that the kernel returns on mmap().
> If it is located in an existing PMD table, the madvise() will succeed.
> However, if the table does not exist, it will fail with -EINVAL.
>
> This occurs because find_pmd_or_thp_or_none() returns SCAN_PMD_NULL when
> a page table is missing, which causes collapse_pte_mapped_thp() to fail.
>
> SCAN_PMD_NULL and SCAN_PMD_NONE should be treated the same in
> collapse_pte_mapped_thp(): install the PMD leaf entry and allocate page
> tables as needed.
>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

There was a v1 with tags, you've not propagated any of them? Did you feel
the change was enough to remove them?

Anyway, LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>
> v2:
>  - Modify set_huge_pmd() instead of introducing install_huge_pmd();
>
> ---
>  mm/khugepaged.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b486c1d19b2d..986718599355 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1472,15 +1472,32 @@ static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
>  static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
>  			pmd_t *pmdp, struct folio *folio, struct page *page)
>  {
> +	struct mm_struct *mm = vma->vm_mm;
>  	struct vm_fault vmf = {
>  		.vma = vma,
>  		.address = addr,
>  		.flags = 0,
> -		.pmd = pmdp,
>  	};
> +	pgd_t *pgdp;
> +	p4d_t *p4dp;
> +	pud_t *pudp;
>
>  	mmap_assert_locked(vma->vm_mm);

NIT: you have mm as a local var should use here too. Not a big deal though
obviously...

>
> +	if (!pmdp) {
> +		pgdp = pgd_offset(mm, addr);
> +		p4dp = p4d_alloc(mm, pgdp, addr);
> +		if (!p4dp)
> +			return SCAN_FAIL;
> +		pudp = pud_alloc(mm, p4dp, addr);
> +		if (!pudp)
> +			return SCAN_FAIL;
> +		pmdp = pmd_alloc(mm, pudp, addr);
> +		if (!pmdp)
> +			return SCAN_FAIL;
> +	}
> +
> +	vmf.pmd = pmdp;
>  	if (do_set_pmd(&vmf, folio, page))
>  		return SCAN_FAIL;
>
> @@ -1556,6 +1573,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>  	switch (result) {
>  	case SCAN_SUCCEED:
>  		break;
> +	case SCAN_PMD_NULL:
>  	case SCAN_PMD_NONE:
>  		/*
>  		 * All pte entries have been removed and pmd cleared.
> --
> 2.50.1
>

