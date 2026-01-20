Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C633BD26284
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 18:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 346646B048B; Tue, 20 Jan 2026 13:42:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31DBA6B048C; Tue, 20 Jan 2026 13:42:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CBE56B048D; Tue, 20 Jan 2026 13:42:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 08F376B048B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:42:28 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF96BBAA8F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:42:27 +0000 (UTC)
X-FDA: 84353212734.02.A4AE253
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4957EC000D
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:42:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bBvElvIu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=irfJwmzJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768934544; a=rsa-sha256;
	cv=pass;
	b=NmiRubD7+7mbmDpd1UpYy7N7arnC/7xjzOJ51sMAWTXlWMqlf2xiJ+AS+CoDssoKJHkr+3
	ZnfOAaJOKqKRXqlLs/Npwlua/s5MOwOvNp5o6xi9h+Q/NfOb7RiXNJ9oaWm0v3WEGSSrmw
	ptw8bu/7GCPt0++2qADjDlJj/DEji1Q=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bBvElvIu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=irfJwmzJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768934544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IOHFNHN5cnrQREekcvaOAff3Xyikk4eZezGtRlP0kEQ=;
	b=D6bz8x8k39XDQPW8pSShqLBQLPwTKxuW2pJjCCacTqRg0i9udfVH/OeS3pL2SC165kqvLZ
	G4xqsDtGPjm17z1vS17eL9T3QrlwIx6aCDge8SAp9AGbP64jTnF7zlMvADPLlRogBs+EwT
	fvZXLbubKENBu4zoU0Cb/8NYHtqyQLc=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60KDK2iv420947;
	Tue, 20 Jan 2026 18:42:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=IOHFNHN5cnrQREekcv
	aOAff3Xyikk4eZezGtRlP0kEQ=; b=bBvElvIuvZ9X0/meW+EW6QEUSTtIdLNsD/
	6wX6iVm2+Gn1w92gncs51dNSNvErAstjoRP2cJnOt+jLTqduMzUKu+dEQvk0OC4s
	0TAb8P04OUWLKtT0fZX2u5VAXi5j9q3fXVbuFkSqcppdrpHwzicxv+9RidRMd20p
	L6TMWYFxrae07uyLS9pd6Zk1ZudvwR2pHjmU2k1QXwuLSAnrt/1UoReMMbFQ+cxH
	qwqPEOMvxxSQaCCC7CUreIBsRZW/5IsBFLXmelOnPNRSxj/zbNzW4tEdV726rJ1b
	e5dRDQsHumXG4+Q9lAQNKu2i98dORjrlMILk/5G3x99gEOarNixw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagcrmn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 18:42:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60KHicCS015756;
	Tue, 20 Jan 2026 18:42:17 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011071.outbound.protection.outlook.com [40.107.208.71])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0va2qba-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 18:42:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o8ZLThFfvTvO3qnJNMr48+jWRGxC4O7LAb2qb6p9bwZnKS/fA08ev9FQINxTqwz/+A2dRbTlO62MXY//pzYmUd7ggqzVL0sZG22GsPaJ6rVHi8RiXf3sHjamWkkggU3EVkTsJgNNnscc3aSnUnXpvJo8NFmN9eEgiinlYBWpgN455DedwpfIQHNrLgz0ayt7EhEiuqMPG4GKXD1F5BnodrWAoewJD5XP5Y2sljsAEWjmu5OFh9BA9ezYAH8VnBhdKY7APpQIsSfDs34RMk5/PsBF8/w4DacARvuBwcwcF2HthA4W5UzgkPgjb1GHbQwr8/CXXgeE+wqPSZVa7OzDQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IOHFNHN5cnrQREekcvaOAff3Xyikk4eZezGtRlP0kEQ=;
 b=hQ1sGKl4U7tPjOpuxVCHcfyk2/YILU0c6beJkKeyUWxG7Qn2ZOG8uhI3qu8j0J1HlYnnsP4V0KFPu0t9xRymMqA3G49qQlsqUZenmza/1ootnIF51fQ1elKPsJWpuVoIRSBZYVbwdVWcwdqqczfbBSATAIdh7Yzuicua+GCVi6CXskyJXW3mzymALxTN2wC8//JU8zvzd/dDIqHdtXBChwQLlK/00uzUzwY0NM4m9lBilDV0fmBiSkhN7nooDICM7+ku1/C/eg1LoyTRdoEbOdQfij1/MhcwnLjzECqVTru2nBKbTrQFz7bLhGsEgtJAnwIgsUE0BXevtRP5nw7a7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IOHFNHN5cnrQREekcvaOAff3Xyikk4eZezGtRlP0kEQ=;
 b=irfJwmzJVFv5wfs6BmTgMvLyowvEXR3S1zQJWuZHs8/2Ig1b9ROT/zLJ+mPorPEX2HuJBD7oI+uSsO7lIPuON5eTiUybAF0P2SwGnK3wYPf74IecE9g018V0M8VM2zeNNil6hvAPAZPQfV2BsU1Dg5c2ttH/ZxZ5QXaeZUkPE1o=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA4PR10MB8686.namprd10.prod.outlook.com (2603:10b6:208:56f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Tue, 20 Jan
 2026 18:42:09 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 18:42:09 +0000
Date: Tue, 20 Jan 2026 13:42:06 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Boudewijn van der Heide <boudewijn@delta-utec.com>
Cc: akpm@linux-foundation.org, aliceryhl@google.com, andrewjballance@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        maple-tree@lists.infradead.org
Subject: Re: [PATCH v2] maple_tree: Add lockdep assertion in mas_dup_alloc()
Message-ID: <h54uysfjc62hxcxdnhpj4fnc3smufwiocdkzp3uiah3e2323hc@ljfkxmstxnbo>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Boudewijn van der Heide <boudewijn@delta-utec.com>, akpm@linux-foundation.org, aliceryhl@google.com, 
	andrewjballance@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	maple-tree@lists.infradead.org
References: <20260103165758.74094-1-boudewijn@delta-utec.com>
 <20260106210757.465586-1-boudewijn@delta-utec.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106210757.465586-1-boudewijn@delta-utec.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0425.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::29) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA4PR10MB8686:EE_
X-MS-Office365-Filtering-Correlation-Id: a3f20d4c-8390-4541-776e-08de58539df5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7053199007|27256017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HoPfC4KxxyJggxLk1W/Fqq+iVhDU1TWEPr7Dvq4ui3ndtNJUCCVzH7vN0EpG?=
 =?us-ascii?Q?OtmRDeTiwR8//47fMvywFQUDgTnQG023DNFv4TWWt4CHfcMkZ5OOLwQwkc1a?=
 =?us-ascii?Q?AgIBLCzqDD05jNvme5vFXt+0Bj3nYlcSak2j1M5DhJQtCCekNVAYMayTBMD8?=
 =?us-ascii?Q?42VjdE8JYNpO6+RluxHhZbxPp2vHDisuAjN3fnqvPOXCQpGb5obXIAFC5qSe?=
 =?us-ascii?Q?vc4LyS28o8v6xD+nDHqu1tkmsMR6RGwZ8AyJSTRjRuD+Hvur33avdkgx22Ed?=
 =?us-ascii?Q?SNZu/x7hW9GBtN5ZT7nCAA8adjfiwtoFOpTtfrWreusVdQ8clORPDtkAgXkO?=
 =?us-ascii?Q?LLjg6PVY1SZExxxiBhsXXijRPDr0caAhdaCytUjg6p23EpR9KhyoaId963TC?=
 =?us-ascii?Q?/d4NMbIuQxe0hz4mMpKTW0elQaAZZzJLFkqzPBa/3G9JJxHZ9CKq25F2koiK?=
 =?us-ascii?Q?jq/kozL5VBnVhpMIyg+7I68cCbIE4Pd3pIwqiT9Atxr+1C3v66Za8J+uKTB7?=
 =?us-ascii?Q?DxJfoD2I5K8HGi54PLNqZpE4doOH+pauyKguDof+JYxZ595xW3eMGCddoE3b?=
 =?us-ascii?Q?BLH5Yqcai1nF+jv7JQgxSYfbuIUPllbtFNNS6oqjP+CDtm77ltuZYGR/uCUq?=
 =?us-ascii?Q?VXK2xtfPoMx9GVRQYxmRCyd86b4FQLJuH+CeaeBLwpBxA3GWdy6v8WWoymau?=
 =?us-ascii?Q?MrH9n4spkWdecJVRgeoV4g3wJqdGTvYrsaQaXeCP8kdPZjzzQanOQxFA8B9J?=
 =?us-ascii?Q?jQknsfnyjnZf+koTlqmMDu8vfkI93wfZD40tNa3zvHLa6B2PDyULFfI5Naxa?=
 =?us-ascii?Q?uYHvlJ1hP6fwfsMasZyWwLuWyYXg7L7E8f3rXZEDP4zr0sGHqVsfsw/7myne?=
 =?us-ascii?Q?YIA7Kkikwr9w90eX5fNx43geDEaYIiH30iJKVaIfbOEWRdVlYWqMxQPTfTj3?=
 =?us-ascii?Q?qNvGfi0LNW04R1+VKA/kLekHCqmtblK4qcpo6hvkq04oDvO7SVrfnZxiTGj0?=
 =?us-ascii?Q?y/0coVYIlDe7QRmbFjaanXiSZiNxjcCqqzOJuyfki2bzPpgxsuGgTsRN1aH9?=
 =?us-ascii?Q?YdQKcEXBEA5LBMMfKfEsb51xRCiua5GSn7UizNS7FmBi3A7lB6vWJ00ysnRh?=
 =?us-ascii?Q?Gb2j4vMnEIfcmXa+QDOPLRJXiEOZ2gYzGccrif+XvWAYu7cRbK3AeVMvSCHa?=
 =?us-ascii?Q?gLA3r0SIvPUoVpBBmzNtTao3f42nzlmTVGrzpSzXhn/k/B8RbXNchhuHYFTv?=
 =?us-ascii?Q?WqW7Nt+3WyTDFmEH+bsVrI2CDg7WR4SC+HGVBCD2M1oTRgQiVaf3xF5YrpjX?=
 =?us-ascii?Q?Gex4xaQZYHBgJEB/ZTBQ6VXMQwPPJcdMBjcTciB0aXmY6uPE/q0w2VMrtQIv?=
 =?us-ascii?Q?w42ZwRVkJQKzqrcRkM08OyAuw9P0XQP6I+xbqWHRjLrJGFbl0yZWUzF7QPye?=
 =?us-ascii?Q?cgfrsZTk3ktkOt9KMiSqSR7SYjsaA7JY7ZMioWGANg7xKeP4++oZucUWQDdi?=
 =?us-ascii?Q?kbsfXK3YzHqzgc0pzatBozNfxMvirEXcimpq2yLyCOokm1CkblC32nUVHKkF?=
 =?us-ascii?Q?gCZz19DVNK2TfvSmBLu1JzlUPrJDNDa1pfDnyOW5g135hxDa9FeQw7jp9C7u?=
 =?us-ascii?Q?v1jdRN0JrT8FlrPDYGFQStI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?edKvEAlYuo/VQvNU42aL7ZWXxTF+cHlFeOHQmdoaVjhBiYbgiwHD+18ZZUfa?=
 =?us-ascii?Q?ohr0H30kD0f+lx4m42MD9U7Ut3M9mPdn2gWvRAccKmqgJEaqz1c2r0GHkEf4?=
 =?us-ascii?Q?gX2Su/SQHzL1oiuemw9X+Oqul+L08JX0WR6jdMNJHgSBtm4QBt+CEAlCkb5+?=
 =?us-ascii?Q?8+vLh6ZiOqg4RSF6pjmb67KgBb2TVCzafHw0qrjjW9ThC6MZFhuqZ1sZIpjz?=
 =?us-ascii?Q?iu9QOzKotJkh3hnx3JxTaSnqcZRiXa4FMFwcMqgODfmlUyfpg5q1o2QyxCXe?=
 =?us-ascii?Q?vHwV8tvWef/jkp7fE0B/bMv55vKkUBiLp7YTgfOXNyQKgKSd5CYHQppp0GUR?=
 =?us-ascii?Q?eoDnqeGt3YufHMjJtRyE+5lc2nJpbJHDJJqfvCCAhXEUFiongeeLHXH8LQTt?=
 =?us-ascii?Q?PRYTowYBChnKpZWYuvzH26MdoQOZHEQWAPoNhy2k5kN7GQjD7Nv8kLyLZvTP?=
 =?us-ascii?Q?/+LQuNlEu1n1KSZm4/xKFaqPIVwMvuwoT53gXqiBethMRlKb8o2Ym1xlZXiG?=
 =?us-ascii?Q?v7VZmiRsSrtvAtqa9FoE7xytaGwV7safMXXFIgrsX8WA7AzNSIPMmklc8kkv?=
 =?us-ascii?Q?jDJxxZ/6K65KoVZ8NgpTZmsQH5Q1D+Syl7lzE7tSTlurhdw+4134AG2SUGg2?=
 =?us-ascii?Q?6ODvpHdFhK5tsp7B5xtqxi3jKtZ4TI5a7Dnps4qhJtzNbBU/iJtP1PZz2K2/?=
 =?us-ascii?Q?dpE+ZBBPFPL8oA6ym3CCfKsEEIiG6ruStdOn/jQf8TQ2IEARt5XhhWf5PY6k?=
 =?us-ascii?Q?jZ1eI31nzWT+O3SKCHBFoPn8TucBCU1csVeFdhoh4CwVbR/Xef0HvSWzGdKU?=
 =?us-ascii?Q?mRzFZD9DkHLuK9wQG+61t31tGx77XK6GIoafAnXju5RatIP/48/dMfECXUWm?=
 =?us-ascii?Q?tAtBn0JSWgphffEGAPxM8BzZa3NLRLmI3bL8gN0mBxvnDuRG1ZWDMkJdcoJY?=
 =?us-ascii?Q?EwgWe40F1elJQn7ejKxDpnlwa7dXCFwyEA0+2Py8rZ54KoGs0nI9cB9267gQ?=
 =?us-ascii?Q?eh+TjrievAnpbbKCO0dTo39minULCctiJ5D85TIVMzQqbPYco0RivS+P+VtW?=
 =?us-ascii?Q?xnt1R+ZP7WsO5aX8lXz6LtqlFZNXxAVVG2lPsZhVHl8P/lTPiFrRbXXUOwKG?=
 =?us-ascii?Q?KgmjGFBMawyQc90ZCT2UHvQkJyayvauf4rZIakRTwbEUuHCGyhT+eE8OJAfD?=
 =?us-ascii?Q?ooZapIv7JqZUvBHSk7TKWQ9wLzKqy6zk7qq1ff3qPcPQ2a7GPQj8E+a1sH28?=
 =?us-ascii?Q?Dfh7pTlxhkSRH/lX5ehWhH/IqQDZvl/OD2I5H+PqHrygpiEQgrnmzk7bl2oj?=
 =?us-ascii?Q?K9kVBiJb2PjBvD72VMDt7EHOUL8GEuWsImUtb+JHsObHsogkHmlCatJ6Fgq2?=
 =?us-ascii?Q?0wCCFNT32MMCoAafbBGAzhJO8gfKFe2CpYnfOeT7w7PD4ZzFZVXnwNLNIgZt?=
 =?us-ascii?Q?ixp/qBQnHC8XsxSTM5FrBclj+p3Q2iT4ktX++YTc8Ndtq+rVhcSwMNLsghSY?=
 =?us-ascii?Q?fFUEWHIkFAGgTK6RetjADOjweTBsSnRF/NlWfI2jsuOJskvSpTozE18kh/TM?=
 =?us-ascii?Q?QTeMbYF8alBHwPgEznvXhZaajB6aGVkXzOq+sNQd64U0sep8ekHd2TaKf7bB?=
 =?us-ascii?Q?zR1NIqCJzX5itFJhhl0W9PKDF5G5IrRhfsf6uAg+jCJBV0Aq1RoSjFgXQv9K?=
 =?us-ascii?Q?yfmNfIKJVcZXqqOrkUVLrUIbQKgTLX4r4qscGQh43tk99InO0TYulP9//+JU?=
 =?us-ascii?Q?56ItgE5Bsg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	11rhBooxaDQ8fsKM4rkj5j2iOQwrwTKzEwiERn9M9Xbaq+G9DGltOUEKl25WpBo041rcKSowTGr2gyFroNrwPy9++HZsAh92axXzhyZbzzbJzPnzJIST9z9hSYCZekDiorPcOVt8czI25yU3CDodMTiQrrmgD33wUVwx18BJnZHyMqITyZGKThmuaSqZoIW9I9KGqofQNKEBB8gvu8wlt5k2flSv5ARKnXVHQsKfh3dQIxhXJxkYqvu7DlDRyMql6bdXHd2foRnBqqx2U/bNc0qeoohri0rt3UaMCkyHaPMNX3FSCkmFy+A0FlXlBRdLy3TtI4ymtCkq+2j4vkv0GMo15iKu6zfKPDVQsa1rMUP928vPCHKTjl2hddI8xsINCtJqoBYF1oZkc3rjicSvkIHwGylDN/j9DmkTKjTlhX29D7IP+WxvLZjdGsrMcmoKN8UYcJmqmNxRoORPpAXQBtdsVPQECAfsXkmMICoKxJUa4B6I4RxsEhwXfVcdDXWHEXs02a65Voal7DPdUzyiu7W73ecifNu/IQT76X6aMqm7FuvlecSCPn23hcS0LeZNTc3RJg//LK8/g0dgeQVAWgwkJvggOBrUiSF/JZm1EBg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3f20d4c-8390-4541-776e-08de58539df5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 18:42:09.0714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q+v0EuQxYlStYX17WCI0noD/I3LnV6w20NhUDJCLcryRR+MbQp6pVOALFTVWsAzRI0xqUZMpaMPdvyqdV4glBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8686
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_05,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601200156
X-Proofpoint-ORIG-GUID: gmQIBbIPInwL4O-gh9_GeZtSRCY4KRty
X-Authority-Analysis: v=2.4 cv=IsYTsb/g c=1 sm=1 tr=0 ts=696fcc8a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=vZsEGXKXAAAA:8 a=ML_FxUSDloE52PkaL8kA:9 a=CjuIK1q_8ugA:10
 a=DNVdo1jukY1CbBonMcdR:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDE1NiBTYWx0ZWRfXz9/cZ6qlLtdT
 S/ajfy2VBNg8V9HUPGF7KOIbdgMP7wfHOoVAQz+H5I/f2W91W6hiJ9yFEHkidhIQ2x5UBonsLHo
 q821gWX8dWKJmeL5g59bgHrUg+KJt81gzBBzGWHawL2spWOOijGb1g2rwz9sKziNvrb3slQ5BP3
 bYPSpfuFxY0JFv5ypFW/2vFyiZ+SGqrBnB2p5Oy4V4ANbkGjQdOFWEyq2jApUbYP7avNjAecRsy
 NJDtUzyyR3/UshrPxLNOsEFEuOCSj+9AFD4rZc/aEfRKarUZeM4kM7QanLWWPDTg4k8CjVx1Kv4
 UzOXpUoNJuVrtxhmjadjkKS/kMpaJoYSDDDZotswmF7R8mC6MUyoBobAse7AqA0MQkaS53cJnvI
 Wu5SVvydjH57l3LREHq8YUKii+VOp5k3cwQ3Z/H9jr3yrzXC2giU3HGUiYvDMbIGUwBQZaVNNoD
 cI7mhbZ0GUfrMBtjjQg==
X-Proofpoint-GUID: gmQIBbIPInwL4O-gh9_GeZtSRCY4KRty
X-Rspamd-Queue-Id: 4957EC000D
X-Rspamd-Server: rspam06
X-Stat-Signature: wmaoewj3mz14ag3gjazs1dz7tme5b5uz
X-Rspam-User: 
X-HE-Tag: 1768934544-386436
X-HE-Meta: U2FsdGVkX18u6jts730EJNEExwPQliHN/xK/Frgn2MlsotULlDD/0Ir5jlsrf1lO7sYykIlVTcgYt63ZWz3WxOPlSW3pc6tutGBBI4T40iazx7UGLS5gnu5jpJd1BljSNIMR1UIyO3qN0f/vofn05GuBko/ZMQBMQjcfJL4jax8EGZ3cbHirMXtLaqGnmQ0CjhPPgifLku24oyZTAAyoLN+JCYcwjj067OoRZez/nYplPsHT+0C7V8dp9UjrElGEqMeKNBH1ApVtstQrpYtWYZYFhx4tRivzuASvzh1KqCjgQjZo4KUfpz22yNVOYTQgt6sB+rhF43AAf7c8gs5FzaLMbCiofDgZWNwU0bXNzlX7ti1O3nL77zYRNXc/Uyp4GjLnchOizgXypjPo8I1ea2i0qjk9/1x7OtBo6MZJ72iS/N29Z4GsURFIdMC6klbY166Gb3K4H8wAnTiaHQe9/qVCquHLgpAtY9eQ1+Nm3/gfaMO465QrkZltKznkt4n9nUsMGDVQmbg7STEWCiGBmmYuMGD0XrQx6WY4sPlmoayu5mKr1kKtlFXqdw5ej6+uU/W4QYTy5K53oBfMZD/qQ8u+1iiA3UuQMvlE51mNiLLP0K/UZLffMIZXjEHrFhcIAMCUj8Shww7wvXI7/WUTJnl8HWAxiF/0m31VTjUaZ1O13/p9kBMkw4CVTVepmudXskAh4kBUZcQisD7yFqo6M3XQQok/bUHeJ8LC5YLQQMw8LrGhUSItC/6aJUBBbSWf5GXKPYVTw2DYU/VpCjcqLcJcw0s2i1QkJ/llgF54rSAXDvs701rOb7Mgi9JRplNiX08uQonlIWY84el17FcIWyquntvkUXzBkJSBeIfyROh/atm5f+TlzC4IpofYGh6vQptT/kPZhcU55vz2UB4tlPcE6zaa3js8oj4TsLMANkeKtRdBL3LmStRMo/Qb095wAWSy7jgefzF0JndaoSt
 Vn8KaIYO
 7zYYIuz8rafmBamq5vGwUauswdDoA3yh1xbuK6w1Cw7XhrXQMB7saxWwS50WndKJzTWPOIAXGf8xcWF4AgIUoH60cPGDREvyI1CNmbnPFHDZECWCVzdPOKbr/dYoyUYP/+cvtuolMiPZRoICNka9Fsc4WaiodQbb8cdBst5Todu8NM9WJxaeL1H8R3UW4UFp/EPnDxXdf9DuZYI7pSYpatODfS18rPBWxRAIIPhsdlOGXNny5BBaUtJGX+8JYKeGqsJvkhbGsHhfAkcvW29pF5MKvZGrlY6x37lOmwMJED3gRT/wQt8F4q+MGbrBg/BEc1R15DeVSn5joK+aKGmZNou6ZMzQolsVlx0TD+dscmiL9AGCezPZpVUGtCUl3dlEBjdBctKnW9SQp1YPWg3JLfYEMkyozy7ADXMhnlfDFngzsjghyq2D78vlImCS5Q9U1ocGJaIWFh74oQe9qWkumzVIqMBdusdhmJgwIVT+74Zj32SduIOZ16MjDa8FUo9FwfIJvPkSrB+Ux5FeHuYvtrnmsAV3shcUaSdFv/FYm0a/GnYcgycnGIGyKFihsUrNvJmxUj2skKSAv47gmr9iJvNquxKMDBUKKDX/7YgPLPPFAFyHohsKC8aQIZ0QP7HCBMOKiUGcICUHLyiMY/OqOFX5NqjMwlGHcABQJUhCjbUfo1BoBhq246AMmgKJ9KM5aPxoF84Zo51Na0N0A8EXMrVu7Ng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Boudewijn van der Heide <boudewijn@delta-utec.com> [260106 16:08]:
> The __mt_dup() function requires callers to hold the appropriate write
> lock when duplicating a maple tree. Without proper locking, concurrent
> modifications during duplication could access invalid node slots.
> 
> Add a lockdep assertion to catch such API misuse during development.
> This is API hardening rather than a bug fix - all in-tree callers
> already follow the proper locking rules as documented above __mt_dup().
> 
> Signed-off-by: Boudewijn van der Heide <boudewijn@delta-utec.com>
> ---
> Changes in v2:
>     - Replaced runtime deadnode check with a lockdep assertion
> v1:
>     https://lore.kernel.org/lkml/20260103165758.74094-1-boudewijn@delta-utec.com/
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 5aa4c9500018..3b4357f16352 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -6248,6 +6248,8 @@ static inline void mas_dup_alloc(struct ma_state *mas, struct ma_state *new_mas,
>  	void __rcu **new_slots;
>  	unsigned long val;
>  
> +	lockdep_assert(mt_write_locked(mas->tree));
> +

This is still the wrong place.  You are validating the lock is held in a
function that is called in a loop without any unlocking.

mas_dup_build() is the only caller of mas_dup_alloc(), and that is only
called from two functions: __mt_dup() and mtree_dup().

This would be better served in __mt_dup() since the other caller,
mtree_dup(), already does the locking so there's no way this will
trigger from that call path.

That way, we don't spend a lot of cycles checking lockdep when forking
for no reason.


>  	/* Allocate memory for child nodes. */
>  	type = mte_node_type(mas->node);
>  	new_slots = ma_slots(new_node, type);
> --
> 2.47.3
> 
> 

