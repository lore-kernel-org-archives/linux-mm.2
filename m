Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DB87CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 08:43:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61E68E0003; Fri, 12 Sep 2025 04:43:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0C008E0001; Fri, 12 Sep 2025 04:43:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BABD48E0003; Fri, 12 Sep 2025 04:43:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A49F48E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:43:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B44C140710
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:43:43 +0000 (UTC)
X-FDA: 83879959926.13.306E75B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id D631D180002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:43:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=U057Dnm+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=0NhlBo+C;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757666620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAHrx3a+Non00eIwIx6NPM7doMTWi17MvuWhn3Mh7Ek=;
	b=Gglm4wc0bxfmhB+iUhGxDcGlh5KIbhI/wJDMJKnqBq4B+21lO8NqpIe4+64gRj/uAxRpCF
	Ns1quaap2spzLd3xbTXz8W2qrdrcCmHIGAQhvHFfY/12HAe0yoYb3TicsdUgjGHBwGY1ff
	BJy3dBadSkLqn2NWGxWuVEkDD5C4CmY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757666620; a=rsa-sha256;
	cv=pass;
	b=sbm1NrWwhFwMypBCM9ES4b4sKmKue3KwVUBHOXYzw0uys+VUK+ayelaUYbW2jDnenbBtAe
	tVxzdjf30KcFyXxqrY52SU3JLJylP4/o1mUaIOrWWAn0OVnNehVRRfbwo+WkSMRXuJ6KUn
	x0EZUqCAad+CpVRtwiTN/RuuRD6aLqY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=U057Dnm+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=0NhlBo+C;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C1u6Lm016699;
	Fri, 12 Sep 2025 08:43:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=nAHrx3a+Non00eIwIx
	6NPM7doMTWi17MvuWhn3Mh7Ek=; b=U057Dnm+e5TJRvzF7V6RXtWOEq5rpMm0D/
	7+rS6YnWIWcGLZWyyk5O2AoybShLUMmfNaj8oVNfb/kw8EcIwm7TVLzXuGVAmtVr
	2LvV9Cj134W+uUy7FLL1QzFUtTe0bPLn34jxr4xtbNMvNZsWQ8aEbYLr+ube7uM6
	xiP8bHFy97nc/QqRJgjQW0OaaNhLv3eqXo/8ly2rJ6vYVC6L44p6LG++z42olLpq
	5Ae6F/fYjXYV/RfPhVr9BziITPq/yv6bpe1P7zfuNWnrY08ovxImzv8aG0+vyXT4
	0ldPZkrLGQUeQAqZeC2f084PKscHIbLJMuIpKJRyTFbqM0MUdfFQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922967ves-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 08:43:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58C70Veo002883;
	Fri, 12 Sep 2025 08:43:14 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdm47kk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 08:43:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iUyEZ2nX5/cKvU+guQhw45xI3eP2UMylV/wK2c7FuwweHuEQi5TYowMkcw+WuyIqq0wYOTXUehZZYycHiqzjU3JcD6SppKVL+ihhgv2xBY9MXaaSNUf+tcvqkgnRTN3tOTTfQcczMDeS+UoX48gYFwLQbEMtQCWKFCJTpH6e20y24zc5b5lHBmvbb33aMD5qPpb6zRavzDpJrKwfYvv2Qq0YR6CKK9LZKNrpfQqVDG197yVjLOlUOK1vCzchv88OhjbEbvc1a6gyePCnF/v8eysExqfbeGhZZvKKjN/L1f22JzFPup+C45JRvL4ToPSi08HjcsLUmhs95fVyUxAHVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nAHrx3a+Non00eIwIx6NPM7doMTWi17MvuWhn3Mh7Ek=;
 b=yFWh95X7AOL40R8WNPsvGPoqlYaFPS9qQGKVcxezFHkyzwyyiu6hIND/1AXP7tw5n6ZqdzvVlcY6MstRb9LG+XSe2Hbp8U15rDkYHACfdvsBRqNRDFMLA1PnZGc1O1PaSgmu+PZSYX7xCVbQErW65F80F7zLTZgzwURXCldXQxVlZ3T/v16kGfCa1ch5k2bJfwWALS1A7w1Zolnior6rtEJOYJ+imclWzJSHm5ZwqDx1r9lK0Mjg5C292WITURf9GNIO0bx92NcRdRI6wcYkS9T1Wm2l5MFS4lxfA1cACmDt1YDsq8kRAFeBGK7pol5dnZfQUV5L0B33fIwpbOQlzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nAHrx3a+Non00eIwIx6NPM7doMTWi17MvuWhn3Mh7Ek=;
 b=0NhlBo+CxuI7O3JFYBdGQHUhlKULW8nJpX/NONYV6PNBkmkLA23XyoneNHNKHXVaYAf4RlkK0CXxof1Q2O3XxQloEXv6oZ8rbjpmjI57YTJM1CE5RfBHr0xkCgoQWDK5i8gtOUZcJKJrTAc2p9Zjc00EoVAVTd3I+19Ca7OtF7s=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY5PR10MB6189.namprd10.prod.outlook.com (2603:10b6:930:33::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 08:43:09 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 08:43:09 +0000
Date: Fri, 12 Sep 2025 09:43:05 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
        rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <2d5270e4-0de3-4ea3-87a4-96254eb6d446@lucifer.local>
References: <20250912032810.197475-1-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250912032810.197475-1-npache@redhat.com>
X-ClientProxiedBy: LO2P265CA0499.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY5PR10MB6189:EE_
X-MS-Office365-Filtering-Correlation-Id: 13c91b7d-de58-4751-514d-08ddf1d8668f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a50y6r8weCTFA7OtkthZ9h5IWHsgJVXnXtY1UWCf76DoYYGs1cFwO78mYJH/?=
 =?us-ascii?Q?uLOo2BFSaEHqfcsO26xC+Q/2Yj1Wqiu73mWxWSztbSS9YoG0ibfAd/rn5ZYC?=
 =?us-ascii?Q?TW0/t3Ge+Ce7oViEiIyn6Kr5aqXTodHkQ0BhNS0QzoCeCzovSbvyj9UwxGCW?=
 =?us-ascii?Q?MZH6bjuz5/8gTB3WhbsPQGrfKjLVF42045zaCG2qjpClZzcwLPoRJQEsMKFa?=
 =?us-ascii?Q?ky6Vbrnr7+uWaFAyTNeXySmcn+MNTYIBxzDA0LHwDmpDUkgSh8/IfE0JvZv0?=
 =?us-ascii?Q?bNJtk4GPC5aMcQsmcGdEYHt3ye8znw64nPSdaHfF5vjC/mLNQImJjWWVp7xu?=
 =?us-ascii?Q?V1+VRy9z7eh7QmZPgMsUwWR/EJaChIue2Cs/hqsDuMCKhUXP+FVhQpwkDcr6?=
 =?us-ascii?Q?1mgGiUrkxIpQVyh8Z667Tl1lM0oyz1xzDXxIDlpXy2KVQ5P2IFrwixOr4z//?=
 =?us-ascii?Q?K6/ZUAuKk8ZvBUr9cY/ixi+JjUZaIXj4JChw0nMXrugB+Ty8hRieL4PqhP9b?=
 =?us-ascii?Q?y2gBWhNYEBJaWzB+vjyFgfxPjoa+TK1QVGTpa3s7xwpabNygPpRbX4bfzX7w?=
 =?us-ascii?Q?/1TY4+Iqi5rZD9rZpUherTC2blH4AhoIU1gUssrEIWx/eg5C/RZMG1ubNtaX?=
 =?us-ascii?Q?s/Rt3NaHlkxN5sQWn45INf0TDY0zFalQK5KaC3XE5IwIlXnBufk4fZqZZk7M?=
 =?us-ascii?Q?NlCddBwoUMy7EYbN3JgyoVD5XTxosgw3Ny55844oVPMVhfgSMugM9FV9b1dh?=
 =?us-ascii?Q?xP9Us0MtOuxclmDZWDynCNSSvihKDBeFb3FiX2KXvoAyte3h0D4902RCnv1W?=
 =?us-ascii?Q?Tqz/KyzmrfWOU0DNAe9D8iBDvh+FJSYABHFWYPbyqzfmNiKy4X9O5iJC4aPU?=
 =?us-ascii?Q?+k5pY1yi5+bQe+G/t9e/b1bd20kT4lbOswK1rJSOrtAwujEDwSQyhBF7Gcrq?=
 =?us-ascii?Q?GWnV0d8ZfwPYouCKMczz13p8TcSP01Uo0UpoUoWU8URsPxxbJTxRi/dd++5C?=
 =?us-ascii?Q?fv5CBeeNGKrRXASFb7F8Tt9klxsE6GXeiE+iv7OmtUbRpZjFWuju7HMGXUqG?=
 =?us-ascii?Q?iSJGD0vhXkOdccTKhkxLJWWUKEEMwVE+a+VMwTymOu0edsqHcJpaHxA8mlBE?=
 =?us-ascii?Q?korU/G5zLCl00Em6v1uR140Dstz8JTnGXFEqyGfyC6ewU0HDLq1CtwM5WosB?=
 =?us-ascii?Q?Ew1cPLFdlwzFyPjYG4EPrwKJXCalqZlxHCWjQxD1pfdwQ/jedww1Lk83IHFE?=
 =?us-ascii?Q?++v6PstqeHm/XeqEGEgGRtQ3xgEGD6cnwMTXT8eo8I7bxXdREHkXIHHMwpZD?=
 =?us-ascii?Q?lUDDov3nBzIiNtSaUTvbOaya+wmrJ6i8O0GFn9g23KCFQM99Yjq4Dey5RQb1?=
 =?us-ascii?Q?Ywh8ofclODPOI3GHlMGgwn9hqxG+wQVOciF4k8k6ZqFyTykFgqb3E1SpArm9?=
 =?us-ascii?Q?9nyUETKgxfY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Cmtcbg7P/TdaPkup/bfmjWqbTvCPKScnjth/cS7Qb4uuNBIFavBw1tXvDser?=
 =?us-ascii?Q?LO0Sg63aH+XIyMLHB4/7IErJk2ItDA6/cl1So4tmiQiTB4KjTsXpeGi5Qxh0?=
 =?us-ascii?Q?ZvE1+dz1gP8afdsQk7zE4rL9xx91tFlwNAv4jaubN1Waz5jg6KI19Sw6fiSs?=
 =?us-ascii?Q?5RF5yEL69qm/KB4rH5gzpdXy02ohEdXIxCAIsUUoNTuJmtZ+PdAM3INdvijN?=
 =?us-ascii?Q?BS0E0sRrqcaxn2TtcCLXOHsUeQgCehqj3Mdqwzya7u+tQe97rXT1gmGc7wgg?=
 =?us-ascii?Q?wFeBVCqSuMs+WkBHB1Z6RBrNevpvFqo0rWC3pPsBI2D1iuBiCPKlNmFE3t6R?=
 =?us-ascii?Q?2l5Yo6fYr6o1elRlut/oVplm/DUpS1Ln42n2YtAFgHgWpOGmGGGRW8ZiTHPb?=
 =?us-ascii?Q?b9RFCzHGYQjrwgtbniRPgkvuPphUYnsKPH1uQEqDOqkRJKtl8C98W3sm/4mh?=
 =?us-ascii?Q?3FDclK2FHAxHJpMzwxSIoBObiFVt+T0UTfZxFUdaJeIWQFFSkWpQqHmUw3Uc?=
 =?us-ascii?Q?PS2EdS5vUTeDYvDwWc/WDxGemY94/WBiR3wDYFVj+mO9ewBUD4+zwasyPpVu?=
 =?us-ascii?Q?nLpPUsDoe6sMLUYLHQTFQd2VIlj6Ccuc87o5IxT3Ot/btUbSLnd910QiO9gw?=
 =?us-ascii?Q?UdK83N5dHZK/UUosKGd0f2fxhsS+xBJIyln2ZLM+M9mmeesxOmxXAU9HWzmP?=
 =?us-ascii?Q?8INRO83d10RD6i/7eYclsSmIFiWJDCwdoG9KzkMi2D4SI9nnFZTphnSxQ8a1?=
 =?us-ascii?Q?C0drsrxC7hjhPG2pQ7pFUfKQ5RypFmGFPIRCw93bN0qENIFW5Kz2j1GLVf6e?=
 =?us-ascii?Q?yx7hrR8xkOev8D9sBY7ix9rMhreCziHNA0kfAC2/5FU7r/NRLUAKPBoF7Ckq?=
 =?us-ascii?Q?6VdP4c+kqq3nYlPyeqOY2/HKYe5kR9PWRptXc1/OtnnOHSRuRfc56dH79jkN?=
 =?us-ascii?Q?TEYsi0NrHeRoNNPsAE9F5MULLPrczFwxkSYiMPJYN06dCZzsubj1VNbKZMDQ?=
 =?us-ascii?Q?+cae+b1Azrbs3RozgGrw4klublsGNvMxAe3p0Bv9hfgqaaBjMdxXx6uPHI0Q?=
 =?us-ascii?Q?Jy/DI3qjqdyFgJT2ZECQxI7p1jQIPKeMv3Q/wODmgjHf6zWZQ5QlbYmoTPYN?=
 =?us-ascii?Q?S3rVcPZFsPTA/9rhQCKIMlYeGzZLXA4gFiOtHFcT0CtpHo8wrrw/t9HmUFcF?=
 =?us-ascii?Q?N86nkoIuIM6KBgUXHPE1ahDIwgITSmtkB9MotJ7y8dJ3r5LyKs2/5UUvrTbe?=
 =?us-ascii?Q?LFZnqYJcU+z5v2c4zc2YTu8KoS0+uNRt9klFLDjfE/W+XjwoWEwxBr7PLF/s?=
 =?us-ascii?Q?eqohJsyEk70W3box8+Fx8kv9ZxvCNyKLWP2DsXk2DHkITZLGo3udsTkEIb6X?=
 =?us-ascii?Q?Fi9KkZF204qDY8oeWwQGG6/T6O9FPEDECXTlUHLsXL1VK3bIDYqvyIDzf9PS?=
 =?us-ascii?Q?SytmSrr0SCm+jUZHXTgOl0oOVuUDZyQVyGSGi2CsVYVgHtdEBHxpn4p5q2BU?=
 =?us-ascii?Q?sjXnF5gDDC7Uradk5lB2Qp+9OUDSnI479tq9NLVlVbRjNJu9TV6Fnlf/Xta9?=
 =?us-ascii?Q?ieBGNehWbLN2EzoEmLBhJ5ZlNdDkzBsLVXiptYGNnb8LvoKLznqe/qrJ4ryk?=
 =?us-ascii?Q?6w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Iy+Qy/o79IoMEcPCiV9yz+1I4X8M8TzbQbV9+Jeu3m+28PI28mTN2/ZKs0clR8aHVPMNgbuTWR75RjHx4O4DLkfX2SNtraxgjUSutYfSx3WjF2Jwaebh9DkT8Lb5C6ZJ1OdfifIkQc0EJvmuzgK1mGERkPiZyKimODzsIat4Gmj2xzli1ZDCUJxCHeJ81prgSP4u79u1QvB6rMq25w2c9B0YXUWTSq01lGZLoSvkrC6qZmND0pGJTUgilATnhOcU9oHGL6wGZeIK3Vms61+fxk7Vmzl7ZKY+SCzxrbpZYTJYD2GKFk+xaqSAZNl/PqzTfjcZASsgF08kuIiqh/w5T2uOUhN3uBW7DgLnw7hjg+OEvvHDnMGUvJqP0zD/RGgvJ04h1vYx+wkLod3kDMAADn6m6uOY876oBI83s7cJrguu09lExNekwBUiOXZQT3NeyOPf3iYzbTluligzOFknTEcM1zZENtFvSWLyM/iSG5G/urlxzpDd6HGSJUCnjFuvBMQSW8aGvDnmp83+pfDn3G51TOVOwy/cscTfjHJ1EGhPKW80kKPH0paBD2/S3NliynUGqEEo1FWHGpGC+0ZeEOg4J58q8jpJZ+sOxpmM3G0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13c91b7d-de58-4751-514d-08ddf1d8668f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 08:43:09.3134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jWXCGh06/tXvEzwbeKPgAX4FR/01Jx2Kr7pjG3Bn+0JDgb1gtiuxBMn4H9jdYVk2/aHBUxB/o50kx2GwegGw8btAQZA9xFTnTGyZgRoX5CA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6189
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509120082
X-Proofpoint-GUID: BOVjbY1bhpt6IP7C0gL_sbs1zjASCEAU
X-Authority-Analysis: v=2.4 cv=CPEqXQrD c=1 sm=1 tr=0 ts=68c3dd24 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=vPkL-s9oMrLb-R8TjIAA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12084
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OSBTYWx0ZWRfX0i6zrnaPElaF
 Yp4BvjKB7l94TjCqetJGACf4XALKb4itc258MSvhEQOmheB6sTzT0UzJ6Maob8faJH5AOyY4MlK
 7BvNB4aNhcY68ZdqCTmKfpyTn2kXnO/Pi9u0EBWLjyKYn1H4ZeldoI8zY1eSAxBisLJ3nGOD2rz
 8ZcXVwq4+eQFU3LSfQM/iov3tMYZrAztY5c1bztPtQrVe5x9vcWcYXElV6p+52xV7VgzXhuFl7l
 2QcbCnRQjn4IbJRgqhbs1pVxEzrXTTwund+gvctDyD+58DFM+++RR/CaZ4BemYX+VvtCzmb8o5x
 gKgWgRHa4zHV/VHe6ZcHvcDWUosuhX+sgRf0DERRLWcD/BSbYRf5LoRuDt75IQsWA9ZykyHCPMw
 H+MrNsni/++w4Ukz9Xe3bJPfEaIi2g==
X-Proofpoint-ORIG-GUID: BOVjbY1bhpt6IP7C0gL_sbs1zjASCEAU
X-Stat-Signature: q6ekkfy8nzepmi54ynw3ycbitp19zntf
X-Rspam-User: 
X-Rspamd-Queue-Id: D631D180002
X-Rspamd-Server: rspam10
X-HE-Tag: 1757666619-831835
X-HE-Meta: U2FsdGVkX19kG1EarSquYfg3M2dI7J/yVC2LhOM19qdVk2lTgoC/i90N95ywF1ioEBGbOadlJI4WGG5I8H5nZN4wyKRk1pJbvidcpGkXN0L3jxH9dbNnxKb2kGNkjskPqV40pV+iLaL2GbmCEIiI1mfN3NzxjzzS3lHr6dtPl6HgL0iDJmtdtHswT/QDb0rXzYN4lFVCypFCvcWx7zwHVf19H/Rani5l1IvdxNhQUfGnYyxjvzAuULs8+f3kNg/Ja9NusREKdJ7wTRSUMc2q9wPAbtFKbTiHZY6QKsBelK2ajSXdtsMyR2NPFM2WYsZc9gBsfheYVC4hcY+g7uYO64elk4mVlTTrNAYPjavaiSUZqfIyfx9FBH43qw8FWG3iylKVHd1k7Jz7DI7sxywHpEZX5jfRErGWuE9RJRZEWEVEHBy8Zvu9BvA42PtJ+o5AEuLnzGhkOw2+pJlE1cX3qkN+F13Tn3uTh+g1WBXAt4eLQhjLPdyzUGE52lI3RV53XBAeq7r8DpfqcMOT+biGHOjI3NTLl3CGGV10gpxy8VBCW2++Mw/Wa5pQzkP96Rt3mUQlnZ7BllZpq/n+EL5aSWPUg1YmHctSCMvCCcz1DIlx6fAaWMaDM/RsbptwMapWFacUqxdJrijMyYshe+1nvbT1yXNV4vr10momReYFh5XInd5k1B13bSI6tTnghPLnV7hRVH5Ws9TXu/Azbt2zQcwlzG5U1W8LbFE9tIvWo2seDIVv619LjfDypk/awSjjRJFshZHXbtq2wxBqRsEoolF/WTGHIpsMUXlFhn7kf+SnjZ1+mV/M9atxlJBrHHTFqeAVLHrvE/pBQ1i0iHlmF3xoQDFL5RzK2saFLAM4BwA7cFCEyRinND56TlzDw4Uc7Qg3+VLo0Vxlm9yPEpRD8fEq+lGJsl8DWSDiV4K80j0EaULzwTiXRwbmzMQcZhOdbtTHf6OfAaOEYWAZC9C
 ynLPwwtg
 fezdOKNXza1wsopIKyltEfZpLDgpIDHfsJ9buCec/YfbSB0Tmo2R8k3/S8jynTBU1C4Ym1grV0k4Yq0gNJ8v63+rTBMWSA3Jmfrp9bqnCKQ+osRRdkLin7C/M7kj7GDQhgd9/oBGB0/oFa0CbGjx9pWDCbmoNlPXgFmkPWw6tFMAP7zUL9BzbEIfHwsjsDX+Gclxoc0EY9aLQz4c3m7O7nGKjUFnzcsU3/wdICzDUHB1cNzQc5M8/CebFjN0CT/QPJiqmFo6sc3BlrTTF877C6Gr5Rqw0tAy7NXFhkQju10Wl399e0I745++hF+hRd7XktmCri6ted8bvt1JY0Gz+ENA0Fa2/Vj/g5+HbA5s7CmYMgbLe/I7+AHiCmCrHkBnw4dv63pCD9yeuFNaLt3cZZeFn35VeMLc36prFA0u51uu+ekK8q0dapzR5dIBLheFz3Ugg1hBWn/WApei/+2LAYLatNXgNE2txFsx5M4XDau7IL7JmdG6msVCz78Sp+NqHbr6Auj8mgk3tmmThFAVh/hIj1EE96eTLZ30xxMawI7exyfmyEByINAQ+ifx+VE03m/1EZMAWHwEe4aM/kq+SlfhRwKM3SPnRAoDjJAdURmlu87mW4XNciCUxrkB4mv/JofDC9WRwFIm+HW+JwDbu9DlSLqWRO3ktfCFZ9x8NBNI1WhhTmojpoEIG3bFkPCpXPx64ZwMXUYm3d+L6ORjCqq1gwzyKgfYM6HmFizNAYOLh4nudYVHSkza/1SjxKFaeWyS6cPkTbSW0fRgp9ITZSZ3V+e4oNNI7Imh2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nico,

I will take a look at this, but just a brief hint/plea to maybe relax a bit
on the respins, there was some ongoing discussion on the v10 yesterday, and
then today a new, huge v11 comes along :)

THP workload has been crazy this cycle, and this series in particular needs
a lot of attention, so it'd be good perhaps to make sure everything is
replied to and give it a day or two at least before sending out the next
revision.

I feel like we probably need to make some changes to how THP works as a
whole, perhaps mandating no series in the merge window, or something to
help even things out a little as I feel David and I have been somewhat
overwhelmed this cycle, and we do need to be sensible with how we handle
workload.

(Plus I'm going to Kernel Recipes and then on leave for a couple weeks
after that soon so I am hoping here that David isn't left with too much
workload alone for that time also :)

Cheers, Lorenzo

