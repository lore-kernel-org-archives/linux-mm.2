Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD29ECEFCEC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 18:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27F106B008A; Tue,  6 Jan 2026 13:42:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2567F6B0092; Tue,  6 Jan 2026 13:42:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D536B0093; Tue,  6 Jan 2026 13:42:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE2E66B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:42:30 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CAB5ECF245
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:42:30 +0000 (UTC)
X-FDA: 84302409660.18.1548DD0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5626140005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:42:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gWRDsHER;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=P04mOIeO;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767724947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z9Ae97Iv9BeHu8gZmsZNHT/pm3EZ2iw4djxzVoENbvE=;
	b=xQM7u7LC4guvCZWRwlLYVruwCOngXo289VKQxdrwuIEn8lhLoxn5fepyUZmucBB2rrOkZJ
	WxCHm0P0kqUn/mRAzpPnVL9GTLIj+gQxz6Yf35QKTlg60E5plKK+sY8ffMQ4I/M1pHpxsk
	+9G1QeeWbBNDwmp0rmrbtTM1uw+UzMs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767724947; a=rsa-sha256;
	cv=pass;
	b=ljLLf+cIGTvoh8PtsgD4TPDiDpa/vJLaxA1dwWK0AQbsqfk49CRWUgmM1EvOMW3Dj3k4Ni
	Ybqae4YJbsmFARLXotAFmvdEhRxVEtdVdMggBsfqT7dePekev22uT8/KBSoRkmr5XIBeK1
	qWsP1l94ynWJlleAiFcM8tWr8bmT+ps=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gWRDsHER;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=P04mOIeO;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606IQFLA702819;
	Tue, 6 Jan 2026 18:42:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Z9Ae97Iv9BeHu8gZms
	ZNHT/pm3EZ2iw4djxzVoENbvE=; b=gWRDsHERLAa3v67/2XQ6mMz7FlkUcPHWAF
	SH+dJ3EONKjYv0IlZfFNMlCLI5ypBRYlzGxiwnTrxN3xZbT895MNnOEnAnCkKFBX
	wGUeBhIzkA4zsNWtT7QhweBDOc7L+RO6MJk5B1kWE9xM64giOqlXhKZeTibdQojx
	AQHJXoRy0O7+xQ30IgtziR+Uk12vr/0EPnlf9yD5NSNbmjtTVMmcJk6t8H2IAqOh
	D+ks2N+XEHjMRS5ta7PbhG40CFFmJP21u0b3ZSdN01ep2WRbNcpSfemd7Tjhaxq3
	smI1yfUUD2QnptOc6TjCOTsVon7nRr4GwSFD6RRR7Z3xjRPE48JQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh7ns80n5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 18:42:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606GmV6T020376;
	Tue, 6 Jan 2026 18:42:22 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011001.outbound.protection.outlook.com [40.107.208.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjjxua0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 18:42:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v1qCl/DrNESY0j0CRUoLE/pA/PSnKQA9PXL/qUpUp+goxcxDIfcN1RbSXN25B8CwMEsPdHQ79DuZ1KlvO9DDHNyO8cGu24Z/GbtRPlgwxZDwLy4zJI4i4ERYZ2eQFU9F/6z72LS2OjO1KZ04QotmwLyc2kxKF/n1Z+9fk9TTsOvKIm9t5P1Tf4PQGavFPdTrMghvat3D4hiQACtQQ2Wtgcqk2ld4E7VexprRQfV7U8Fj31voN8CFFmgUlG1W+094vXkKutAR8Ck6sn4CmJ0DkczfRcQ71ZNoINDN/d3wytao1oKQn7Q6rTtHVrlMGljG4/nk2emeK12AmSY9iGDhQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9Ae97Iv9BeHu8gZmsZNHT/pm3EZ2iw4djxzVoENbvE=;
 b=iytPYV//tzQtYOnKBODERzy1Rr+UDpLha3pjDKbfgVZIqAta6kjatTIe/Gc1lk7KANPOjOjbOk3faBHYhb2dpc4jTZPVwc/QrGQ/H3vtJtgVRYrZL1byfyc/gF3jEGHWnShZCAiMJsp6Qr/yWXKJy9LnksEtPRRqNtHHcd3cK0bWIzrTXFHzPP4MixUxo7txgtigZ5Eu65SbmFEhEHnbhT278+ls4iuDNrie9Mxot5e2vfV1zyjSLFeSUO5t9z5a28Do2+8wREpS8uXnGuXgAT5emY2k0xO1aMWEUjb0gg/yvziJ89fj1+ZtIklrQFPQtjwqYAtLscLgYgOno9o0VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9Ae97Iv9BeHu8gZmsZNHT/pm3EZ2iw4djxzVoENbvE=;
 b=P04mOIeO7QPFL76lznBJepqLL6PVJDZf6ve1FLhlQkq+nU1D/c8sl9f7N20zxVYPthOEnsx5L43dah8oQPsHr/44lnTma9CqBYKCC4M2HrsQ+50dq4FWOGB/hyxZzI9vagp9XgChbhA2avJfqGrFlR9oVx/7Ep4IWinh+8FNfKA=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 18:42:19 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 18:42:19 +0000
Date: Tue, 6 Jan 2026 13:42:15 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/8] mm/rmap: remove unnecessary root lock dance in
 anon_vma clone, unmap
Message-ID: <ky3uwqtuabfve3genu6wdfygwsmaefhbmgsvvc5ny2bmgbnv6u@behequww4fa6>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Pedro Falcato <pfalcato@suse.de>, 
	Chris Li <chriscli@google.com>, Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
 <9b5a438237e4ea3b19a986a4f8fddb8848cba54a.1767711638.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b5a438237e4ea3b19a986a4f8fddb8848cba54a.1767711638.git.lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0286.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f32bd7f-e4b1-46a7-4887-08de4d535221
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fLvExw6+/s5BNgLG6E0EnhW/IkPNMEyw+l0QHH8BxpzRmSDNuGDSuVTKFaA9?=
 =?us-ascii?Q?LuiiAJiWDWgA+bCbZwtoSCBFqY0cZ9O+24NEQdId9dePDDMjnu9kHLWhGkCL?=
 =?us-ascii?Q?uOjki6varLz3m9YcFEYNLblsnQYUdOeIhsr3WygVTABeGrM4nB5Y67sED23d?=
 =?us-ascii?Q?EdyHx/jky4QddSTYtSt6SwcnpuFosruTxBT78SjHD5ii63JT8BM2St8lIMih?=
 =?us-ascii?Q?hH0WDC5v1YcWAd/MEcD4GzTBBAUzpLe3kF9UU/0aDO4nuOLgxSozlAlcD5uF?=
 =?us-ascii?Q?6dE1XM+4BgWhFtzcALobU729yC/o1dAygADefgkJZzKPcKrpu2bC+XkVxIQT?=
 =?us-ascii?Q?98/LzG8v+a88rQTinXiZeBlhzhXWmOOfpJ+tvfyfwM2qwJeIOA14ahl4jOB4?=
 =?us-ascii?Q?ShqIduzHSo086LjMU6pPpdPxuR1jbPxXLLA5GgT0ZcqNcdEJXOxD+piGeDD1?=
 =?us-ascii?Q?pTBOLQMTK8iM0x8rQm2sYFWi8vlJ51sf+DDM4GxYfTOxAZLuT9YV6eV4FSF6?=
 =?us-ascii?Q?93q9gw9lQ302cXUEmszqU7NELr0X46OlkUkSgy7dH8fMDJRZzkTeQ/+zMsV7?=
 =?us-ascii?Q?LR9ZV/LyTJ0B+cddqzvuRVnbwsKh4Df0CVQU7MbLnf/KiWXc23rMnkgP9plZ?=
 =?us-ascii?Q?S2hAYJKXO1rQ2FggRI5CqT7BSPjQFu1kUngP4DQhdKY/noKVjNbz4lZMzT5v?=
 =?us-ascii?Q?GjF4azJ6XKJBcf0V3AqUh8UeYq13FmoOEHqo0eWgAS7FsHr/qAMh5x+LhlUC?=
 =?us-ascii?Q?XSkpocu5CuI+PvnRi1qqA1u6qmYSnBPkp8He1bWGoMwkt7T9JkXLVU1sGv4D?=
 =?us-ascii?Q?kZL4ldyyof4/o5sqXq3eS//sQmNrcGAcSD3/6axQiiak7n1Mnm8ISHAkQG0J?=
 =?us-ascii?Q?bh7zghGDuqj//mWKJ3czOB/bSEgEM/HltvVJn8MpS+IpPBZqZO46FK8Heo1a?=
 =?us-ascii?Q?+J0JyZtxlcllVvQHmgXBb5VUCBveGVwYwEpuoVR/kKxDKvsIh3Gz9u+y0lZy?=
 =?us-ascii?Q?/FSoXb/wxDsFd5IXAjguFiCwGArP3J5SOf7mUKaBLRVDSd/GKtXQ9Rw2sE8f?=
 =?us-ascii?Q?R/7pPaNkrYGD8w4OaELUmV3gFvIGltE2VEyEFdSRBT9kVcLnBa5UrB5XIP0I?=
 =?us-ascii?Q?LszeA1ZfyVnfTR78RBtU+N7pdfgvRIeBKHhIu8wepIMY9rFVPtoXf5cVkBB6?=
 =?us-ascii?Q?9miodWU5zrYYbkG6oWVoEhCeH3MbDiWER7gKX6mPjt4s8Dv6FvAVEnAuY2XP?=
 =?us-ascii?Q?d1vORKcygm1LVFCAUgIdE/AxFbBr/d7CA41//qrLneS9MvmTtfDwRGLKv3gu?=
 =?us-ascii?Q?p/EOnV0y+0ZZpCPsHjM36Fhs26gyJmUfpivJxM0UX53EY1LM2d9d71TYWKZ/?=
 =?us-ascii?Q?ycKSNA3NlLHXEss4kRTpo7chakiKu/jTaz9+ANxQHR4/6MmXW9Q7ohFBEtiz?=
 =?us-ascii?Q?MSSkkuhqCmpBn+3wBnYEe5kahlyIu8EC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JTg0bSxPUn3W/sqEG6gVgyfAL210imLJqhdiCb5kBpiCtxm7jH+plElypsZy?=
 =?us-ascii?Q?uQ2PZAFcRkP6fi/zEFy+2ibp+o/tiDJk1AOf4YDGnB3LpLruE4l/OWAu2hn8?=
 =?us-ascii?Q?xt+Tcu+K2wKdwSsLEZvtyIHQwZZqevULfQ4kZyEOKj6Z8h/eu4ePcZgu2Tyy?=
 =?us-ascii?Q?9t8dzu6673LjSxHF0Wvc4kOw+W+oi/HM5RuMBc8lnbPLx/u7s5D0IaF0IQeG?=
 =?us-ascii?Q?9pJ68DUuBv2t0CxtMNHsx/sAr+SxzRjxtBNG2Ld4hGvR/gur7wK1DjVE3jgB?=
 =?us-ascii?Q?ATz5xMwZKTLKBbFfkWoSW4zUE3ILyEjsOnm21gxOqynoUONoktDM8qUM2ggk?=
 =?us-ascii?Q?5Eh4Y4grDoPGtYGn94e8fmBbWZgFV6tlIJ6TO5sv8J0TdMASbAsLlVlrBKup?=
 =?us-ascii?Q?hpdGptGaeZ3Nivfhi1d5ur0g4NdfwPnK1BUvhOk2iwj5+RNTeUXwZ9zbSwDQ?=
 =?us-ascii?Q?8iIqMs0Jegpo4GNGsS21tb7Dd6y/br5zAvGd+8UR+o3B6NwP/Fx1kYW+AUKy?=
 =?us-ascii?Q?sV/zR6Dr0hVV70B1rRzhnTgIR+tv5g8hOSt/ce0C9gyvs63/ieEJGBZDcqY1?=
 =?us-ascii?Q?6Kg6Nyx9TXy2wbCYHTegsE1fLKSAi7XYCSOAQBB7fiIXJ3vnUXFfnzLrIqz5?=
 =?us-ascii?Q?2G0uLpuVsLtvTlIOXvos8w9/c9YcbtiyvvlGtZoxMnP6H6ZLvYkU5Xk2NRZO?=
 =?us-ascii?Q?SH5nZysVCMKPVCajpyJ2ZR/nPi14tfzWHsd5W9UXitv/RxfMgfosCZ6/Nw0g?=
 =?us-ascii?Q?PTcLvh3GstzT2me1wbt+ChQWK1niAnYb4xeqnsyQWgEFE4Rmi7r7njoSynxx?=
 =?us-ascii?Q?vFmIMQB/k+q98LRYs7K08ItogI4FqAXPAeBiNLItM3m3frm2a2g22G6nJA6v?=
 =?us-ascii?Q?3BGJBRIwADZT9LP2+/4ZeCCpNUT7RqPZlT3u6WeJAmKgV9Jwv8nYgVPhNEAv?=
 =?us-ascii?Q?T0m0coQSrwdA0jZpyAoqyMZfTeoWWhImZhm5NY0ZrmCgfbcZgXEYt1bYqHng?=
 =?us-ascii?Q?lvM5lYWtcOil3NyHh+T7NPygJEXq9SDGxaqRc/yoPKiAe3uQsK6jHX+8nAu0?=
 =?us-ascii?Q?HtYeWKv1gaCPt8z8V8Yurmwn1xZRj/Ek1odgY01Dmxy5QAIpJMmbumBi3jnB?=
 =?us-ascii?Q?F+RIOKp1tWRR713J2IYpLvsBfEc2VW0Va1FdK+XLTv89mCYaliB2u9zBXCgk?=
 =?us-ascii?Q?LjPCEaCNpM/8WZbTlp1PDhlaPVP+8Fq6n8hd4hCkAkCUEAjcew4sPoGJZ689?=
 =?us-ascii?Q?YdeLzTj2s181HnvEZ+qoc/WJLKtmnMcGBCePSJIPMX/c0FV2YrPVwH+GJEt7?=
 =?us-ascii?Q?Z7dUHPUCQqfwBQ2DHyhbqpZgoMjKg/XRqqNSILJTu3XrUxubr7cK6Z97Hvkp?=
 =?us-ascii?Q?WcXY875aEAOLGq9smcowYSnhMGnY0/mGsQqt6WGCMlgOijUJ4FYsh7x9Tiec?=
 =?us-ascii?Q?PqC/Qcjr9UmWDWEZfWAtgIHV5/TXq93CR+We8INTTeapbQM0KSG/g/GJR4Qo?=
 =?us-ascii?Q?uddJJQUkYku0pvY9yV1ihSm1aHjgp/0TORGJYbSnCJTfza/hAhBsu2uEDjCD?=
 =?us-ascii?Q?aDHyK0dckYu1zw/bHTUpX1isUaoZe+8mqQE7ydYhRqls+jrGIVplth8o4Fwr?=
 =?us-ascii?Q?WOT/Ou+RK4PkrX4HwpvAjUYBURM6LRgtY0ln2Q12zPo7zk71OReQPK51hFLQ?=
 =?us-ascii?Q?TijcVZtRcr2yZ9CBYfGGGBu9xWmetMSLg/SvBEfDW7zbMp6zL2GjD4VcsK48?=
 =?us-ascii?Q?Wygz8zq1XA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	26czlV7Las+a3qLnN3DNZZuw2SvR6gq5yJyvdVM5OgYfK2llVf3MdJY6DRFPPZRjkNnsEGx8uF5NxVFNCu7Cm7GjOUg5OVHNtNlAtXAaEoSRZ6pdmUmQ1cBYkllo2hqhfm+t0xMvfchmKdZknnZwvQHbJoQEvTWBnn7aUg1rxqtKg6kAAgfTI5gF2o2z3SWM+Wgx+oeKwrVJZs9NvR0jXE6ge7pmxIPS30s1AP3x+RtKaXr6Q9anOsSlkef2RUKy+58vVHUb/U1kVLwdoP7AcEyiRW9ERPANrzeoq1AhK7KVPN8txbLMOEPjlbxpImfTRx3zPfDesW4dL/0FmzKWW0iqD2AcADJh+JjdbBbFeD1ZsvZ+IOQJXJJQ6D4fuOTnhhjN3ns2t8Z2An3pnMT8SsGVKKusKTWC+oZzMWMAFA3znpmQncuWgFmdS85v42XNBGzoKBBK7vOgbGASbjqS1CEccOaXEkv9C1nBv5fYs6klIR7I34cCZ5XtzqWi/w5EafDPimbQLq7vbhjo031qO4KfAx02utWsmSpKXTn/Rsu/sNGBTfxye1XOF6OZ0pQTBhVLNIzgbS+Sk3fKmHArNDf1q6fXLNDYg7DXZHzFmug=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f32bd7f-e4b1-46a7-4887-08de4d535221
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 18:42:19.0238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4FpLCW4LQnEHJC9CZZ2KnotKMV3gsXsYuEIHpJPxBRRlR+Dgt2MBNjZP9AxR41HGbL0M4bP2tFmsvLFX/pmOkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601060162
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDE2MiBTYWx0ZWRfX51fXdmmdrTeM
 WaZNJXbrOpUCq0EoWi80g/P2W4yZFqWlSSJzzim3yKQT5Ug55F5PzRgB6QUiVfu9m76rNzueNSQ
 958W8couMugcUM5qKFJ+BWc14r93Nbj3OxOnH3ZXiKzzyDRrVrcbbDjmHusHdh8mfIE3yH12Vgg
 /Ph0KyzRTD0WJEsuy3IMsd2p8STzBqMLHl8jtqbuqX5ooLNxsUf+lOZdct4E2EaXno821494aRR
 hwUxWp6jrF88YW5EIiSOtJbNlN3EwQPNlb04l01DF+BabLM0addkAjkVNQQ9uI/4BlA7RJtesl7
 kVnMhEg8vsQ5LaSM5P/thG86gMsiuzYde2O/9y8WDJ9NCbqV9rjMwa+yKQKF+CmVwmwIJP66nh/
 0rtOaoqSr+JVd6d1aylN2h5OoThMskTJ8BywKUpd0PRYpCfmZID3YyusjpZXrziKgiQYNc45Nsb
 C62VmjikVT9TkllBIz+/e2yLTUBS0tW9jmqdreB8=
X-Proofpoint-ORIG-GUID: d8tTlDrBqoSzklCWY0qtdUasi4bp5yDP
X-Authority-Analysis: v=2.4 cv=XbqEDY55 c=1 sm=1 tr=0 ts=695d578e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=TjWXLN0b07coR2kkdXIA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12109
X-Proofpoint-GUID: d8tTlDrBqoSzklCWY0qtdUasi4bp5yDP
X-Stat-Signature: c74ip1p4cptcxqptbqsg6js9auihsogw
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5626140005
X-Rspam-User: 
X-HE-Tag: 1767724947-601478
X-HE-Meta: U2FsdGVkX1/6ICQZtTuEofk0tZPL+B5Vwbtv7dEYdXqjPU84XJa1P/JJzUTzhuHe6neJLh+g5HOsOnqwcUSSIMloCbMy4cECD3eUToH8gsAJHYPehlQHzVI56mmtPOIQLlY1NNxyuskYlqIkZDKbZfCqLPyir1EVumvVltp3r3/6yLIRiOWs04nKZqXQofs5OPQurUkem01UV2zZhE6zh513g5V7XKsGKt+C3TXmIpjA2uWom8NH6Qqx+PjREBAmvMLNxerUZ6JZyiNIYP3U/hSXN2dgrH3B5OW9ki1OLpzscRTVOX+DuJ7G+h5AwxpxPsAEl6CVk23hZwPMXms63gwRq0/OOMTcUbJzARPJFz4XnU0Je0T7t04nF/n9rRKr9tuaexvL/qNKC7sjhQyiO9nNjqhqyPR2pAI+k+cMMApdVshKyPkGad0hzXDqjLV7U11Oflj+pOE3NkmVUDFLP6suc2eI8T8cIvGbnm3nXxUTJKJrEbsV/UpG7a+q2rMqGGXirHEiDclMSz7Ps0juLJWPo+1yGUbg/IL1iR36/kgFtFh+5Ktro+AryOUQQO9zfwFCpWiQviBkvsRmBDxF56o2H3ql/Rf70yErbdD8gJoudtCBB25azc/QLdKywaImffOxbXJlAFN107r7Hsb9CcROcTxJf4fjK9J/Z7lBybV//yXDFYGGK1lfzvEOAkf/Z6baIUt3OJduqQTmgJZSpvJgyzwp0nhHl+dXtyPxkxsYZ6JPmNmh+12rpRBbQXOM54hFDW66v5S6lgT4poqYjOzXDllRKQmICD7+94OyOkOjeuB+9fVmR/WAfzdD4OYR5LAVQslyK5YOZu2vFxyNNFcn6FaeujRLDW0fPxXGUMc9Ay468/uzjCTVCXYs2BkgWBcV8m6Dv5o3iZpvtdvP9zcaKcoBmLq7TqWO2OAWcvRgldFvXvUtGadCzFLGYQM68PFGwNTv4k3rW6Nq5NT
 w8EhjjqC
 XLHWjOLB48gq8U2rqD74FwLTundyqHv8L9y6GlTeTFAV23HIhAEBzzCUQOL9KibfSyw8GtF7oeSOvxKU/NRKuMxdIBAAA8sQlpAgtH/KTHSW/DbXIgndWRrMEbF0Ao+e587xpZs3Y97PdJmNCrxTeuLBS+WL2GEkNhHZgQw0NWDxFzAyk2rJKj5UL5SZBMI9fen0Vssp0oRzm5qky7I9Mtwk3kwHmzKzo461xknXJGrkNgWREeG+2OuTMAvDQ7rHcOYJvFn2GiVGjLF3sXd3957LIq6Qq37C2+aCUq7Hu4SR7h4jxzq7QTdOJ6ik0sqgniyRn4qvVg96AKuk1CB6pzJN/mg5G3mFpJAha14IcValL3GCFuQi7AZepZRlnncHdqRuO9A1GpgBthxYwfz2oO1iXe3z0W7Wga4eimOh+YABwtad9tXC2QBq6zt5fWGzYPfqQ51gqiz0vb4pLZgyOGRytKe5ZXVXHnJ9oPk1Km0WUyhd7UTDzIGQn94X3pWncC7XPwRhZetcVDGhlXVJ1SuTntS0xzMy08mhnBwA4JXvPa2UqQAQ3UsIlmSBY8IqYwC6WMuyOQKNk5zlIKH8h1CEjeScdgW1CDYFsRPl7E8z07lRJZOoPWL3MIHSdK1gxCUjTQexRiNzxstDbIDCwY4hCqs9x+iZcTR+E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [260106 10:04]:
> The root anon_vma of all anon_vma's linked to a VMA must by definition be
> the same - a VMA and all of its descendants/ancestors must exist in the
> same CoW chain.
> 
> Commit bb4aa39676f7 ("mm: avoid repeated anon_vma lock/unlock sequences in
> anon_vma_clone()") introduced paranoid checking of the root anon_vma
> remaining the same throughout all AVC's in 2011.
> 
> I think 15 years later we can safely assume that this is always the case.
> 
> Additionally, since unfaulted VMAs being cloned from or unlinked are
> no-op's, we can simply lock the anon_vma's associated with this rather than
> doing any specific dance around this.
> 
> This removes unnecessary checks and makes it clear that the root anon_vma
> is shared between all anon_vma's in a given VMA's anon_vma_chain.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

One extra whitespace, but lgtm.

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/rmap.c | 51 +++++++++++++++------------------------------------
>  1 file changed, 15 insertions(+), 36 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index de2cbe860566..6ac42671bedd 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -232,32 +232,6 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>  	return -ENOMEM;
>  }
>  
> -/*
> - * This is a useful helper function for locking the anon_vma root as
> - * we traverse the vma->anon_vma_chain, looping over anon_vma's that
> - * have the same vma.
> - *
> - * Such anon_vma's should have the same root, so you'd expect to see
> - * just a single mutex_lock for the whole traversal.
> - */
> -static inline struct anon_vma *lock_anon_vma_root(struct anon_vma *root, struct anon_vma *anon_vma)
> -{
> -	struct anon_vma *new_root = anon_vma->root;
> -	if (new_root != root) {
> -		if (WARN_ON_ONCE(root))
> -			up_write(&root->rwsem);
> -		root = new_root;
> -		down_write(&root->rwsem);
> -	}
> -	return root;
> -}
> -
> -static inline void unlock_anon_vma_root(struct anon_vma *root)
> -{
> -	if (root)
> -		up_write(&root->rwsem);
> -}
> -
>  static void check_anon_vma_clone(struct vm_area_struct *dst,
>  				 struct vm_area_struct *src)
>  {
> @@ -310,26 +284,28 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
>  int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
>  {
>  	struct anon_vma_chain *avc, *pavc;
> -	struct anon_vma *root = NULL;
>  
>  	check_anon_vma_clone(dst, src);
>  
>  	if (!src->anon_vma)
>  		return 0;
>  
> +	check_anon_vma_clone(dst, src);
> +
> +	/* All anon_vma's share the same root. */
> +	anon_vma_lock_write(src->anon_vma);
>  	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
>  		struct anon_vma *anon_vma;
>  
>  		avc = anon_vma_chain_alloc(GFP_NOWAIT);
>  		if (unlikely(!avc)) {
> -			unlock_anon_vma_root(root);
> -			root = NULL;
> +			anon_vma_unlock_write(src->anon_vma);
>  			avc = anon_vma_chain_alloc(GFP_KERNEL);
>  			if (!avc)
>  				goto enomem_failure;
> +			anon_vma_lock_write(src->anon_vma);
>  		}
>  		anon_vma = pavc->anon_vma;
> -		root = lock_anon_vma_root(root, anon_vma);
>  		anon_vma_chain_link(dst, avc, anon_vma);
>  
>  		/*
> @@ -346,7 +322,8 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
>  	}
>  	if (dst->anon_vma)
>  		dst->anon_vma->num_active_vmas++;
> -	unlock_anon_vma_root(root);
> +
> +	anon_vma_unlock_write(src->anon_vma);
>  	return 0;
>  
>   enomem_failure:
> @@ -471,17 +448,19 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
>  void unlink_anon_vmas(struct vm_area_struct *vma)
>  {
>  	struct anon_vma_chain *avc, *next;
> -	struct anon_vma *root = NULL;
> +	struct anon_vma *active_anon_vma = vma->anon_vma;
>  
>  	/* Always hold mmap lock, read-lock on unmap possibly. */
>  	mmap_assert_locked(vma->vm_mm);
>  
>  	/* Unfaulted is a no-op. */
> -	if (!vma->anon_vma) {
> +	if (!active_anon_vma) {
>  		VM_WARN_ON_ONCE(!list_empty(&vma->anon_vma_chain));
>  		return;
>  	}
>  
> +	anon_vma_lock_write(active_anon_vma);
> +
>  	/*
>  	 * Unlink each anon_vma chained to the VMA.  This list is ordered
>  	 * from newest to oldest, ensuring the root anon_vma gets freed last.
> @@ -489,7 +468,6 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
>  	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
>  		struct anon_vma *anon_vma = avc->anon_vma;
>  
> -		root = lock_anon_vma_root(root, anon_vma);
>  		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
>  
>  		/*
> @@ -505,13 +483,14 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
>  		anon_vma_chain_free(avc);
>  	}
>  
> -	vma->anon_vma->num_active_vmas--;
> +	active_anon_vma->num_active_vmas--;
>  	/*
>  	 * vma would still be needed after unlink, and anon_vma will be prepared
>  	 * when handle fault.
>  	 */
>  	vma->anon_vma = NULL;
> -	unlock_anon_vma_root(root);
> +	anon_vma_unlock_write(active_anon_vma);
> +

nit: extra whitespace here.

>  
>  	/*
>  	 * Iterate the list once more, it now only contains empty and unlinked
> -- 
> 2.52.0
> 

