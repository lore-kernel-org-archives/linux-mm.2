Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99B77CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 12:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F15198E001A; Mon, 10 Nov 2025 07:01:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC5288E0002; Mon, 10 Nov 2025 07:01:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66488E001A; Mon, 10 Nov 2025 07:01:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBBB08E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 07:01:24 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5038CC0D81
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:01:24 +0000 (UTC)
X-FDA: 84094557288.08.64535C8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id DE372C001D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:01:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Yd5Lr3yw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wknUe8ah;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762776081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vcAEArzMU5KnmsVKaV4oWD8PdlONN1J7QzF18ALePNo=;
	b=UMWkEJjOUljEZ13DN+w4p/L/VTc5cLQE1vwQlJL6aYkRFcJQY3x5On3tADfStNgQONH8oM
	+bFTW1ylI6mvjx+yX9MGyTgVi2us+eEfpvmOJFIwvt5FKGt0MSHVBPlxgRjAi7QyAFy7QT
	Xh4DbZiNZJp7AX7zMD7Uy1x5K/KPqvc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762776081; a=rsa-sha256;
	cv=pass;
	b=ySCkCtG9jmEDOWo7a+GfgRb7Ktu1swz//3XTyY8jHtQdEGmC2cPo+VWDCjFjyOFvs6P6+u
	pIa5P/FMx3gzHkHDnU5VNUrvkdXuVL/d/COKK6grwLJD4/cZgNCwQCCQtW4KWJziAHcxte
	lxaRgdzW8fbfSZ25p/wZkCwm/hVTjY0=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Yd5Lr3yw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wknUe8ah;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAC0XVI018514;
	Mon, 10 Nov 2025 12:01:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=vcAEArzMU5KnmsVKaV
	4oWD8PdlONN1J7QzF18ALePNo=; b=Yd5Lr3ywak9lC/eRkl0DW68qmNvtXEUrBz
	C070jdBryoMNYN+L+3pA+rqQzAKcO+Ic8BWs0N2enX8wFUVPX9HMFCFKaCVJiUkr
	ODglQoMBniaRW4oQBbwXukYX7Cn0T2XI/e3Y71XLTCvKepg/CF90GA0Iq0I26e/q
	8SX20xg3lDzfrR1bhVRmL8+sPfoVpBpahDUDfvpAlbkm2JxM937tkhYL4xeyfxUI
	R6Vlw1duWmUdiWwleI2Go7+JWx14nydFtbb9MRYbdauOQDzhcvKFGGkzGf+wapTO
	GGWlpGOnRigjwiNNhpQTLIWO6706IAFBof/Nt9bL9r7me1Hpro2g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abfhar0gf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 12:01:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AABKFMC010113;
	Mon, 10 Nov 2025 12:01:07 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011053.outbound.protection.outlook.com [40.107.208.53])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vahthbn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 12:01:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B0n0U9cTEI4bJVxu1Eu5TCGYSxVZjMZS9sEWJb23gfDLWwlzow8WUqlp9+kCyYMHRFpeY/uv0mjwjGwdvzZn8/4UC4i+plASud1+fPHxxVXCf3DyOOafZwbzAo+QgHkdfZakSudS9r8vy+lZV+3rsaEAsiJQFZYGPa+I2jED2Fv81pC7izrCtUtq7cO40pliY7FjzEtdqhT+6VAZlpevOo9+i3aawyKRRBr7R7TpqLjK4ex5mZIiuj/AEN8zOykddImGeSU2cejMnZO4oOyomxBj4y+l1HA/pFDuahhE0MufGRqZ0Z8S7sJj8hwXMV7VlqwR8rQvlBt+VCCHnUHtQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vcAEArzMU5KnmsVKaV4oWD8PdlONN1J7QzF18ALePNo=;
 b=NKOkAasARjJlxHe6YXBWTQrHzVMBuPjAkWO7lIKhRLkRrShhUMKqmd29UnhHi4PyOLYzoajy9HXAoJ0ky8CpJyPfWNLCyvF1L9r6CcN7qICQjoL5Nb99jiVPZ/HgsbMDwZOHcBPcBJCCSA0zn2eQ13CGVaj1H5M8Ic8xIa5E1EuB9yy8vHgShD5kxaT7HCmLV+1IPVtPoSnrwZkiQAOoGxnMi72nFYvbO8ydtMLlh3J9P2XtEXDdoJbdv0s8WxnXdz+vwm+wSBEwC8ZGG45n2Xau9oRdSp5L9WBtm6Xszp/rZPkhh5G/5noNQHEEDnD55TJglJATmZWCtUyOjMfsLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vcAEArzMU5KnmsVKaV4oWD8PdlONN1J7QzF18ALePNo=;
 b=wknUe8ahudvaU3RQuB14O4SnRCwg3yC2egCHkYNfXSl+rBmOGGHKAS08AQawRpiwt7dhjK/bPcpM7UtFBQkNu51kqHcF4WabQkR5y30oGYG3iegfQeoVCu+VXSo3s5gjBhMV7FR3JkhAfpf72dAFo58MkdozCUWRioz6HjcQeJI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ2PR10MB7598.namprd10.prod.outlook.com (2603:10b6:a03:540::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 12:01:02 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Mon, 10 Nov 2025
 12:01:02 +0000
Date: Mon, 10 Nov 2025 12:01:00 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        Branden Moore <Branden.Moore@amd.com>
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
Message-ID: <f21b37bb-7a2b-412b-be76-e8968b4c375d@lucifer.local>
References: <20251110113254.77822-1-shivankg@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110113254.77822-1-shivankg@amd.com>
X-ClientProxiedBy: LO4P123CA0451.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ2PR10MB7598:EE_
X-MS-Office365-Filtering-Correlation-Id: f7f43f7b-7af6-47cb-137a-08de2050d20e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?20tSseM58JKNB+ALT6fXdVfX8Hp2i0XasQfWoi9KQt0R22X/Rl6m+VNGtCec?=
 =?us-ascii?Q?n/69N4+opBl5F/zV2xcrajIDPjharT1ve4He1BxW2w6Yh7wrO7lZxLAbaBsS?=
 =?us-ascii?Q?pHsQATcNb4fX14Ush1VcZUkaTHDf5qx71YVEkMpR98XbkFFaERetc1WKbVkz?=
 =?us-ascii?Q?o7sgVxooGb/MeN66JMB2qwjLvtr0LBpZ7F2R9566T/CBKn1ZwGMuHCBeVQse?=
 =?us-ascii?Q?OeAWQAb8jiZsdRNphB1poxJwpqCCi6lmErKmyucb5xI/J+8JpYWa+XIUB+aK?=
 =?us-ascii?Q?WOX4wfCWDRj6TxzhCJM7Eosbnk5nxammuVujAPczVv+GEnBbIFEhhN+onEwE?=
 =?us-ascii?Q?n6IbHl2ygSmhlNHmqTyiRvusTXweg9kUaLqhJBNRPj/R7LWIfbr0G2oIUbdo?=
 =?us-ascii?Q?mJL46rBf9/dR4SY8RhfpLe0G/e99iuLYN/3N0zjSEL8REMKeqCnUbYwD+h5p?=
 =?us-ascii?Q?zBLkDk3Hj0NruVLaMGWohdhFjU3L8H15BiXmGERk7kUZl0bFo1XE7nZTUFfs?=
 =?us-ascii?Q?e/XgJT2u2Qgpg4j5BdjrRnv4JjfgKwtdOuHr8NNYvGpY1+AjExRRaBUqwdQd?=
 =?us-ascii?Q?v1tYdqqmxMZn8OlB2QWSXOC8JRzgiawlPy3LB+SdSqfa2YZtJYFrJ2hiWnfl?=
 =?us-ascii?Q?zxLsO8AgyNITLn9OnMdtAsNKVZxDQykCdC8WC860etS59wirT+cVaaRe9sTJ?=
 =?us-ascii?Q?5VwJNPA1qo/MkWGtSRiG4F1bvD0b5G0qw3ClGj5MrqxvmtoQybMnd7+15WmJ?=
 =?us-ascii?Q?BdJGVo3+J6xyMLCJgLH4Y5WObOnYZU7OyrBcwhxWICJpbaBi2H7etiWJQolb?=
 =?us-ascii?Q?0bJUI9xf60dve/04Jf8cKuyK7HXeuyClyHwlcHxrERrtktKvAdnm2BjHUibj?=
 =?us-ascii?Q?oXa/0BkjMb0Iunvv6tS00IGb3I4pijD9lXHKCoyAfnzyjfkxEEL9sE6XkIak?=
 =?us-ascii?Q?RXbUsc5/VCeaX4oyTFupTx5iIX42LatG/EKf2Mh0J0xX9o+eJfDfAgvtJUlW?=
 =?us-ascii?Q?+nLKNKbGT1KYxNZANxPoZH/6hUKa22ZReRFyOxJM/2n9bnFzG/3IDYx+EqDd?=
 =?us-ascii?Q?IkMvi5mE6KbKO2J22qETbTpL8CvkXyN2zj1UUxOzeJcLWz7JJn1DbIG82Hz3?=
 =?us-ascii?Q?wW2kVD5YmWkG2vSgeO4LCQ4D7mv9x7xi627EH8M6iMUY+I5ML4I4flM0eQ2Y?=
 =?us-ascii?Q?Ln6WlD2UsAfXG/LLUSrfSC+g6HPhJFiBOG0bPDVNqzJ/g0N9Q+DUthpyNbYU?=
 =?us-ascii?Q?36Hr4cgr6COXoFeAjIdDTAYB3fIwnRvl4vvMGrmB7g5ClLZ8Z5FOErt3fbN9?=
 =?us-ascii?Q?wgzDRJuxQAEv63Zti6Jil4o8SIJ77sj9P8xoDYinRyetyaVHRFw8FnBBlvc5?=
 =?us-ascii?Q?+RlzdNJD7pt/m9wHtoNmkTh4yU5j1SZhudimeOT1/trEfWFyT/5WXGSLWnaF?=
 =?us-ascii?Q?ZtzNWXCxk+UvJAM7Sunw31fCGc7ms+/nOs/LJzfjZO7O7BlKLmu9XQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DlamxcFKrbiNSHkqqUICmPObpfBZ3PpUaiXFKYY58R3AOExAgYHk7n1B3xUK?=
 =?us-ascii?Q?a3lOFvt+0VR2hGrZVWLA2NxIzO3NTwrOM3VLq9eTgsB1o5jYasZrOKk7yByM?=
 =?us-ascii?Q?pfW+l2A6SULrnPKlhaNk8xM1dBwEz6spKf+xC4cRaGCpB5BdFc6HeRN7XxlX?=
 =?us-ascii?Q?a6xVN5/6G2o/VEmS/1ZbS17El05JwQiiAwt53D3qSp2/qTZJBRY9ijjaZjJT?=
 =?us-ascii?Q?stJ4td32J8SEQQYpyFLI9HkPZRLlV86TRMFpEPfCCXr3JswILpX71yTtt/iq?=
 =?us-ascii?Q?7H4y3BsefUJ5vQKh2C+xLt60Vq2F9Hk+JO8P9mosUcshA2O3/DrGpXwNKmzQ?=
 =?us-ascii?Q?hqOhIyk0U62HLh6y4ojTT1ZX6ntVdj9kZvhUjix0l05v+oYb34pv25IiSFBs?=
 =?us-ascii?Q?mbimmimM5vAH0mnT8/qzLSRL6HYyKpc6rVjksJ8C9PIoDj+mNmYC5IePfyvI?=
 =?us-ascii?Q?EmKXl4F4uv5D4kdVR/NBnXR4KTMKEiB38eAfANOXE56zYSI/4TSXTng98ORz?=
 =?us-ascii?Q?VetGjIeIDyWu0Pv0P4hCH82ylBvfH3YgKC23bv0ZLVI1BM6M/OvMhA9yxLa9?=
 =?us-ascii?Q?F6bvNwpHgWn9v7rDK/y6/x+TMZ1RkN14eI+2al4Z869ZVGNl7oevT/LQCnam?=
 =?us-ascii?Q?dqsxSa9/UzIkqsOxZoez1oOjF5s8vbneyBuxipfepeyhf3RAJnFLhCM/zBie?=
 =?us-ascii?Q?gOP+JxF7Ueq2IW6mkOSZrprCfMB0oFqfD1Lq6xvgoqdR//M+PxK/zijLv8LP?=
 =?us-ascii?Q?5OBr05xtl4Eczu6uxod8FnktACE81WmzOtJBDV523mTzEfM6XB7uefee5F55?=
 =?us-ascii?Q?wAG7BGxbQI7BBOTYhu1UUKtTvglb4uGKpwHKFFz0L/qSzBXHCPNTgkBie6Jy?=
 =?us-ascii?Q?d6K3hWGQcDIOTDYqrLxNTbZKzZ6sl7UY0ZEa21wKx7OOOSWeIDQL0joduouJ?=
 =?us-ascii?Q?p5RTs+/1OYE8XvbrxXjoyT8Ks5KmDQL/CWEI4CcR/4mOrCImiR01fifoyBkJ?=
 =?us-ascii?Q?qM80O9t431SWqbpO2FEMhyUkvFdXHhB/rbFmco0cDILuIHCXwbKJ39T+JmP4?=
 =?us-ascii?Q?38wPhXJCRK+IhxhrlzkeetF6mksRLJkMYME5pd8d/nQlfKi5pfvT8RSwzX09?=
 =?us-ascii?Q?x7fdGHht7sLjcqztJv6oYCQzy9QszhusB3j5pjbJtXwpU5jzTHasKwjS4h+F?=
 =?us-ascii?Q?I/txuMpybTt5XIXcSrjqPM7d7qgvhzVqs5nCPUiCOoT8dEEL6T5FG0TIY23n?=
 =?us-ascii?Q?n2WYlcTPgJCPr+G8kD95HmEFcBDhM5RlJw4osq+SGNMR5v5N9u/TmldeoLY7?=
 =?us-ascii?Q?GSxN/938Z8oOnccnY35JnMW8y4jbM38Rz+ohV5cSz/Rh42GvIPA0xYIIueIG?=
 =?us-ascii?Q?Horsm/AWST1CvQk0xmu/I1rsnwefosWaqdi9uAKrPjP9v3SIJnvjeQsYRMxu?=
 =?us-ascii?Q?bWUjs5lImqTcQTzvy/mQe1Fz8NuGtbHumPfsn5KNaDjJszXdy/xcu4t7V6gN?=
 =?us-ascii?Q?lDeF1rTw2dEKQcZLrqhq8GlnQnktfPUFSWZTR7Cy9Bp4NiTaukJmB9aBoIf2?=
 =?us-ascii?Q?Fof1UcMqrM+6kUcM4fnW1jv7789+fIaQy55A+JEJ9TU/x4tDllJF5t+e1R3r?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QOxG0wjCOfD8vkd2C/LQMSkr/ZaM9EgjgEYFo8XgVHEgJ/fTyJzQIMCtHW4ZHdQoFRCFebYxCbN6fkuDL2wnnu9Snlg97nAdWlUPxvsRDvn7Ua0tC2mIdCOCxE1wiVW3TVcYFQKH4OdYR2uyPtYokDz/l0ZYfPqmU8Kb5UjTGovaexmsaK0jsDFchUE2+5bMN1CPHNg3wBPsuzFdt6PNZNBU9d4Tcq+eR20QXaNM2EVQ5mZQik5Sf/PY4oUqDcN3pEn+3rV3UNeiLrPgjjjSKpha/nt/phSZzeWIOSmwwU3+9KzughfHAeRo8PlKPo4gwCE17fxpkBUbyQoemnY+kzwoH0MsccfPnbcE2DyJhG2s84oBh2QRHVJHPGWfQnPszHSiImfzUDYmtBv+gJydCXy7UfsZRtCFhyoOJjVPE5Y8pwf4kh7FKhz/CI2Psr5OZ2jT9zAWFnQbQh7b1nBvwZWBAm2Zj1n1rjt6RcUVDHXgVOvfgP3CvOj64zOpxkd/acM11w1VMzyHZF0XwyxShkSpq+YtOIpaMcN/a1KN/jJdZutjpqcV51aUt/mv0a/Es0F/9gnvDEEr20lpzVfcbcDVHaa1zEnkZSl9at+6+dY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7f43f7b-7af6-47cb-137a-08de2050d20e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 12:01:02.8413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y1kax0ZB06Ov6cEvfpZwK0wDeP2fG3HGRulxqGaY8aWtO50KEmTUsfcHOTJvTXPoHftnzLkP12DELZE3CjT7HOcmzmjHgeul01HyYHVWD+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7598
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_04,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100104
X-Authority-Analysis: v=2.4 cv=D7NK6/Rj c=1 sm=1 tr=0 ts=6911d404 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=zd2uoN0lAAAA:8 a=20KFwNOVAAAA:8 a=ONvA6ksYRi1Ru73Y1NAA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12100
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDEwMyBTYWx0ZWRfX1nJjmFBABjtj
 wHjGCbAX1cXws4JLI0+nNxPg2o+lAuHzNdNFE6/AAdJq9uGTqfoJBqadHananWwvHGUtwKBF36W
 61Dz8PGPOtsgmQkPmg+s6W8jh8tfbwJeX0tUINxnk6ucytewnHhYK+LKiizlsWX1pYLeQLvsW9u
 gup7nuyqbMzncUZZbm2dwM2io0mMkpaerMTBEINNG8OCAy0c/NV8O/xoXN/LoLJAUKr16Cx5fTh
 DQndv0JGyjJIEW5hdCpj0hlTiml7syUSA1Y9S00m938Rjz2gCVHauUnD6SFy3HcZdHb+KXfWTwO
 aiCzOSevYnJbawBkWgBB9/yCYNmda6JoRuriMS2kVxsCAQmwDIDDIiHGyuvupSlQAXuCy41FZPU
 1G2vWwgEk+mD0vt8bFRAG/V7iCwFFscCO6R5m3TQg02BIuusvic=
X-Proofpoint-ORIG-GUID: wOtvG7zSycJpRWqPVm0qQl5IF-c_HwBr
X-Proofpoint-GUID: wOtvG7zSycJpRWqPVm0qQl5IF-c_HwBr
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: DE372C001D
X-Stat-Signature: ggeschd596e6u1o3qspetmabsc6cxbr1
X-HE-Tag: 1762776080-223421
X-HE-Meta: U2FsdGVkX1+2Nnd6cxIfhEU6nSsryKH0OFsrakoEw3eWvjAsPrV/wN8qL5eDTWm5QCd1l44UkSsr1pGyGuVcwSc9QyUpwbgWQyKSQ0TKTnVeqC6T7ijLS9AozpzC6WKJtA68vpzdO2banBFMfQBM1N3lqu0ziyxG9NwFOf62yhBXhjmo7G5wWgsFqACldpxWSETjq4a4gRlgciGwqreWDeoyI9bMGpJM2ChXSkcOR/o1mgxub9xZEjzAbu3HIlGUZD5yyRvRbuIwfrInnZaNt13SLZsrybTllvi+WAl8mty5cVDWJSsqoZ65m74WfuxAB3W+3S9WjwWrBM4q0+c7SQlykAt9IsbakxzuXM6mZMzAVrJDCB+UDOueKSn4zpGwKqn4YAynapNQDa9XfS4Ek0Ks4CmXIkHJ+MA1ABw1LD71agLS7Sgmr9OzTWSJlHK9z91WnbJG3kyRtHmG3+JxzxJGjQlq8JmBJNCqakZyTJIiqVxM0C0IgolyWtELiY5kGKsVylefUkEU0S3c46+MGWUoKDv3RQCC555ZmlCklYZGrS7eO5MEh/wLmwgFdGANv15FZjxQdx6CyDoTG+3P5Xjw02bCfXzmr+SsWQTSMvUybbszThwHCujZJq+0xMQmYWNbvCzMlkutPAyR3yHMo0bocAzq3blZgzfebygGpr/bSnOAGCGvNCV7i9gCiiWJ/dYSCsLLzgnt1Ed30McsQ8HVoPXwFnbPYwnXVKLyNcU1FI4aj5auW92EV1SCfzHrT9W4iiz2eyeV+TqNLtfcEiuFq3D8fANEeo80s1krdqGwRLHxR1MzOSshq5vYuKttXJmZsqwryIvX3vH4fAx5151WFKZQVpqT63xPMGkPzHkZZC50UIam1LKUQEAZqQrT1USLNGEHqAYyg/wYIl6kEo+WX2pJratHMablZYFgnB1Anr8wp498srfv70bE3MKXTcv401CbwTELffESjMi
 sKQh9Mxz
 qEVWFZYGFimfyd1P3KFG1BliAtJ7Ze/wTGTQ6sg91IZv1CGNfl/HOtRGUTA/bbRFlyxznZ3a9HxnIAWCRbBuncxLctre9VL2JDKibcu9c3emZERWwMZRla9u7ljH0bRlT7eWaaamDuUNdJTNQyedRM5dPSZMWpcu/2Ds0hbd4kZjFkOQ6TYIP6ScANEu8TzKx8WEUkUj/3pQzZ63d3zYQx9+tnRiL5UkbdoMfxhTA0uSADErrpm9KR7DxwI7WvcRAbRyDzf+/W/zjQmjl5bZGI/1Mu2r/MZaPo+RlndQANLXp/a9fepBXaQVPmgoOte33LJT+HW6QnDKr/A/kHq+oywrvzg3roKyYxMfhkjK640E7sNVYkx5b4QPjXcgBMMO66qtoj7nlYWpCeh2xoiqiDzbJFv1pr/t46gUf990a4kzagEXfvSYuMnJW8C39mqnKeyWyGw1yRDGfG3jbsxl+xGa3GL/Nv90hFRr+5dek9Y3H8mXZ787c+NHnI6ItEVnpYxX76coN/c/hDKm/kw6PkYUo2aT5xOe/ykRrN8heyC8JwXDfNO5/7YvE+CHxREXaoVqluhWCr+KFOrZatz//7iNx6CiSAYqyMvkRNTaERcH1i6O5Qt9bBMJ4gvz3KQEsgQpHpAsgT0JVH88sjuf/hM4KMB0SIQWdKzQVAUo1VHGqp2Gg6urDE02vSvRF8uZF5dvh0YxzqITESvkehDWRZrkHXFEHj5IkXDdqZDmLijlG8uUvLAA3UZOEim9O3Ot06Prd1SRh81X6kKU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 11:32:53AM +0000, Shivank Garg wrote:
> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
> text sections), the pages may still be dirty from recent writes. The
> current code triggers an async flush via filemap_flush() and returns
> SCAN_FAIL, requiring userspace to retry the operation.
>
> This is problematic for userspace that wants to collapse text pages into
> THPs to reduce ITLB pressure. The first madvise() call always fails with
> EINVAL, and only subsequent calls succeed after writeback completes.
>
> For direct MADV_COLLAPSE calls (!cc->is_khugepaged), perform a synchronous
> writeback using filemap_write_and_wait_range() before scanning the folios.
> This ensures that folios are clean on the first attempt.
>
> Reported-by: Branden Moore <Branden.Moore@amd.com>
> Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
> Applies cleanly on:
> 6.18-rc5
> mm-stable:e9a6fb0bc

Please base on mm-unstable. mm-stable is usually out of date until very close to
merge window.

>
>
>  mm/khugepaged.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index abe54f0043c7..d08ed6eb9ce1 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -21,6 +21,7 @@
>  #include <linux/shmem_fs.h>
>  #include <linux/dax.h>
>  #include <linux/ksm.h>
> +#include <linux/backing-dev.h>
>
>  #include <asm/tlb.h>
>  #include <asm/pgalloc.h>
> @@ -1845,6 +1846,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>  	struct page *dst;
>  	struct folio *folio, *tmp, *new_folio;
>  	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
> +	loff_t range_start, range_end;
>  	LIST_HEAD(pagelist);
>  	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
>  	int nr_none = 0, result = SCAN_SUCCEED;
> @@ -1853,6 +1855,21 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>  	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>  	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>
> +	/*
> +	 * For MADV_COLLAPSE on regular files, do a synchronous writeback
> +	 * to ensure dirty folios are flushed before we attempt collapse.
> +	 * This is a best-effort approach to avoid failing on the first
> +	 * attempt when freshly-written executable text is still dirty.
> +	 */
> +	if (!is_shmem && cc && !cc->is_khugepaged && mapping_can_writeback(mapping)) {
> +		range_start = (loff_t)start << PAGE_SHIFT;
> +		range_end = ((loff_t)end << PAGE_SHIFT) - 1;
> +		if (filemap_write_and_wait_range(mapping, range_start, range_end)) {
> +			result = SCAN_FAIL;
> +			goto out;
> +		}
> +	}

I feel this is the wrong level of abstraction.

We explicitly invoke this oth from khugepaged and madvise(..., MADV_COLLAPSE):


khugepaged_scan_mm_slot() / madvise_collapse()
-> hpage_collapse_scan_file()
-> collapse_file()

ofc you are addressing this with the !cc->is_khugepaged, but feels like we'd be
better off just doing it in madvise_collapse().

I wonder also if doing I/O without getting the mmap lock again and revalidating
is wise, as the state of things might have changed significantly.

So maybe need a hugepage_vma_revalidate() as well?


> +
>  	result = alloc_charge_folio(&new_folio, mm, cc);
>  	if (result != SCAN_SUCCEED)
>  		goto out;
>
> base-commit: e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c
> --
> 2.43.0
>

Thanks, Lorenzo

