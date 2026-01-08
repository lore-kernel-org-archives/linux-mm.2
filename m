Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC83FD1D485
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D20116B0096; Thu,  8 Jan 2026 12:14:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEA256B0099; Thu,  8 Jan 2026 12:14:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B235E6B009D; Thu,  8 Jan 2026 12:14:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 977B16B0096
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:14:23 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63FBAB6FC7
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:14:23 +0000 (UTC)
X-FDA: 84309445206.02.ECA4F67
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id E15824000E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:14:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=k0YxendJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XKzTgqqT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XL0eSl8irolohFaEbfs2gG2wF6THUyf7S0b4VXj/KXc=;
	b=p8vv+FRMC58T5765n0D+F/KfDYt4a9z+2+7SErKFCfsP3WTc5Y2RHTSnyTqoQa5rsfGcPc
	MLQ1BSAYxfMiyRGqH8MqCqMA9BH3sYISBX/1MNFbyyVHgeI5WnniTZ1SFYfYV8OsnqWHI4
	M0XsU7Nf6qvt/+S79DwCxi6g+ycCG9w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767892460; a=rsa-sha256;
	cv=pass;
	b=qgTPQ3gLQd3dBcX6yzzgFFVCEGuBJa//KwHTe4go8bA/oFw5EZp4Q0Wn5WlGR6BIabAIfQ
	aNlqw83Igf0wiLKIAfukuvoC1DOAOXsut+65VGUkoG+5iBktytd6AP2Cbax7x0Rp+vWxip
	1PM74g+SLgwA6N2UsW0paXrz/8S4zP4=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=k0YxendJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XKzTgqqT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 608Gnbtr742116;
	Thu, 8 Jan 2026 17:13:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=XL0eSl8irolohFaEbf
	s2gG2wF6THUyf7S0b4VXj/KXc=; b=k0YxendJknWhHTyrBUwvCUO0DzCm/2SCEw
	i5yIWhSyrtUmPntKMntJPLdOTp2USU0Bdw6K7zdJWnlslWU6sWoQ1nhF6tXuMNSo
	6GCgRr7k7yV7zfk/cJyiqvUx2cQaYiq2wnFSa/1dqYJQO8N9aMguGg67mL3bespk
	OVw/vaOmeY0DX1bKPLsGpIHwvRPCy5jQPiASNG4sUlgrrEckkZbDrijFHBwF9/nj
	sUuC+gllCrOritdqE+poglmzHxp7/VqnIAA9mLdxVwONiN5iqY+oMMY5uOFC/2y7
	tgDhdyalVOXfKYX6D8XR6lRa11/902XAf3LIEuvkp6t9hbfN735g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bjgep01at-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 17:13:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 608Fh96d026379;
	Thu, 8 Jan 2026 17:13:47 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011033.outbound.protection.outlook.com [52.101.52.33])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjnkg8m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 17:13:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w69sJrfUFXYJ5XFrEbnBHDjI1iN1fiTmMgAi6AW46mJlBtg4pJfa1c1OrpRox/dA0L+wF4Ns1uD3WRA+blLINi59YiXmhh2gFhrrKwktRmuBoCNfSTHX3h9hkRdfZG89UXzvDN1yKTus8jJxKAXidpTIgSHkvs+qcOOWOGk894FPjQ7rgTE/gcIDqpYVBAg95TCvlaqpBHqBS087Q94y8nb2Fdm3g6u958ZfRhpYsJmsYL7ZllOl437bRc1x8oEsVCu8YjWOfBFQx+UMDJrSegPWHQgwRhBjTl64VWaF5dxECf+lzTvdlPR2IBmEcAHiXjy7sFhu2au01CyI14NIUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XL0eSl8irolohFaEbfs2gG2wF6THUyf7S0b4VXj/KXc=;
 b=ds9TkG0rRIfhSqDqmrdvI/ehSRO7A4HvpZxWkhrcRHi6UkgeJdDuEgeOB0PAC2pY2xhJkdgBxw96ao1+wCPH7q/kQcr9K9OTX3tSs4sg5/o7dflvNsT1gW2iGGsz2nKJN0PBSiwL+pMpm+CGrGXSHKChsFKDups9HmWqGH9C7cG057INo8/Nh1srWS9AMqjjHGcGnGqrytjGVxz/lCNnev7CTCogpH7X5j2tzpPHVEH2WfqePghHwFIwYSdDk6VCVot5gH5JXMAIldRJAZCNZXc/tG4BwbvCLPkXM6CrzcJ2FzIy4mjsuy1XqMkNqdaJcH3BocRQ0tq25pMXELrTTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XL0eSl8irolohFaEbfs2gG2wF6THUyf7S0b4VXj/KXc=;
 b=XKzTgqqTpfES6beyOkKPBwiRW764dXdizCNx1AGGMZOITZHbaujjvGm00PcSl4ZfNtQGDNXvcOMeUk+ZjltJYfpmfKrng3sFm62qp8ok3x/MkDlGspLlHWrOWcPrahOFUhv7JnlFl5+V/OoflZO8O3srxU1i7TxOjmxou36ktmo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY5PR10MB5916.namprd10.prod.outlook.com (2603:10b6:930:2c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 17:13:40 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 17:13:38 +0000
Date: Thu, 8 Jan 2026 17:13:40 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
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
Subject: Re: [PATCH v13 mm-new 12/16] khugepaged: introduce
 collapse_allowable_orders helper function
Message-ID: <cd9c7f08-192f-4220-91d7-10890ed11612@lucifer.local>
References: <20251201174627.23295-1-npache@redhat.com>
 <20251201174627.23295-13-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201174627.23295-13-npache@redhat.com>
X-ClientProxiedBy: LO4P265CA0268.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY5PR10MB5916:EE_
X-MS-Office365-Filtering-Correlation-Id: 30d19acf-d0d6-40c9-eaac-08de4ed943ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nQ43q157aIHJ0XmZeiUAhZ/y6TKTvf5QwpF9wIvegtpZMBkSiNZVPrynmyYV?=
 =?us-ascii?Q?WoSy9/1jQZesS0ivdgUmZZ72vV+Pe8/pijSP8PN2Ye1QUtqNABfFoKIvO8b4?=
 =?us-ascii?Q?AlxBnDGeqorBbo69jyELyE8xbeocEi7VTNNbpzKBnaqf1OsNAESPU4vammyn?=
 =?us-ascii?Q?x9eBbX9VjlF2cO/FFXYXi1Xp57GnljzS5k77KcjqkMTiznJko7jdsAyA5xOT?=
 =?us-ascii?Q?IPLJPEZhwGI5ommLLBqbIGdtr8xUrbLECvHTzIMWToTUog2pkh9JFf9W+daD?=
 =?us-ascii?Q?wwMvIqwanAZQ/zcpp0xKCYnbQ++gMblQ9TM1F5yE+MygrPS9Y9qwzHogcaEg?=
 =?us-ascii?Q?unOnInA1cDH6bUVA3m7/YaP+Wfv2/hSP/xN0+0oe77OMgcozKBxs/E3gGWql?=
 =?us-ascii?Q?UI7DWL3KYA9C7g0CfCBLo2+svNzLjq+4A5AQE8Nk2ZgLLvweDub9ybPISCAC?=
 =?us-ascii?Q?iL3qJaoVb/l7fYMMUz6zhjSRNxVPV1eou7uVC4F4hi/ydUNXzwIN6fPFPjFi?=
 =?us-ascii?Q?EvozAtGhSH5/C9HCxOmJePRrHI2/sj/ogJwhC/HdSCp/Dpbz2iQfGgMbZjyk?=
 =?us-ascii?Q?3krPPSItm1vXhMo5C9rzrURfMFeNOy5t2wD6AA8oUScWBCv2mr0r5oSAYJr5?=
 =?us-ascii?Q?7TV2YXWWXMjeF5UxJBEDjsIsZpiswLqS6DxO0cGMkhoxX0lfMtrFTv+9g3ch?=
 =?us-ascii?Q?P2Kq5IthBGIc8ZsW6tZNwGie5gGwvCcvJz6vbdapYgfCA+AkhEwxxca9FouW?=
 =?us-ascii?Q?GJorYQMDBeai3YTCY0S3zIk5Mk4EirhhwNYq9ILcHFFOizQoMd1p5oXeKc/U?=
 =?us-ascii?Q?hY7kibeVooEWoa/L8KD3jia2dOv4DqA8etcWJCiP4vNoMNnc/6g9jHqvmTLo?=
 =?us-ascii?Q?hw1ASi7C9UistCr3BFFklnqN2vxeM3EDEgN9xD8qX0a78varQay5dIBK4Gte?=
 =?us-ascii?Q?UTY+GmlUXkK6F8YT3awaqqaZJKqV6ezd8+Q7h3+Wxzn3N13RYTkYc6MRcepb?=
 =?us-ascii?Q?bJv+TMCeq02JpazPQGi9cmWYE0m3X7U4QAM9rbIMmP+u0i8/UbwytYoHYt8J?=
 =?us-ascii?Q?kyGwemEfBQHCugsbbfs0rAy/2h4my2kp9pjvR0aU4WGXRQLgtSNgrWk3m/lr?=
 =?us-ascii?Q?cT10lQyLWLzBudcKfNGQy9NmXxswKh/dNRtXMzELm9C4mmH+08nSqyZKX1VK?=
 =?us-ascii?Q?SKIPN40tfowtV2ZaNWPCV8jEYMWNPPU63aLbIaQYu59VffDUcscpeyOjT4dt?=
 =?us-ascii?Q?w6GrttgzClCj+cNCE3CdS1+GjbkHlH6uZqDIZUfIh+EvgUEDOXHlNe+hSGry?=
 =?us-ascii?Q?qsuOQn71PcsGol6JN3SZ/gh/oyyILMJJA8qfymm46aMhG2wJla5RNiKTlF93?=
 =?us-ascii?Q?QfhVx64FEksi84u+QMbaD2HBzB3qCpPrKK7N+r8ElFO7V/65BDRhOtsgtRVW?=
 =?us-ascii?Q?axAm1dXWZ+ed3eDUD8Ux7WAtyKCxNmBv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WB46FmwBYF/99LJmhz8CLMhbX/L6HoRS8yYmreU5hNlyTDWHLG27Iu5jeouk?=
 =?us-ascii?Q?grzPw2aPVrJGjVC+EzusDyRa8P4TL5MJmKhZhqv4yNl3ABSU7imU3cZ1vGS0?=
 =?us-ascii?Q?LmOxBA1se99FEXE0m5awB5IiZ27Vmwkwf6+NaBZjZMvtBytl0CVmMBlyWix5?=
 =?us-ascii?Q?leQ0HkfbxFj3gZ7oBCMwqXbB7Mxexq8T9eptGhFEae0c5QiUsbOg8UkRqOYT?=
 =?us-ascii?Q?RgGDT2eagJk2pkzhq54Cdvl4IKbM55FpyjKyM1pLd8fphWt0Tp6+6QrUqTua?=
 =?us-ascii?Q?OZfl6/8Zn8cFGtW/SAM442/7KFeMrykH6p3HjYIXFAHIfejz4P4PWoBZ4V8f?=
 =?us-ascii?Q?FG6rblzvTx9XN8aNQoiZao5GGJkDXu+jdJbqUjCdgCRmjTallU2H8Z64Kxpg?=
 =?us-ascii?Q?jYOX50kyVJnBkopv/4+FaPUJw3asV03kgqpPf6cTUqI+e5/HHyNanPi7zyi4?=
 =?us-ascii?Q?UvAu/AC/guz2Hfleh7nVIFxip6t/2Oo34WGvTG6uVYYxiC1aw5ttEYv2Iofp?=
 =?us-ascii?Q?i9ZxwFKhOGUUcgz9IUJZh+b4lGNXegyuNW5edgbKNyw9fhMLr758yShZVXA3?=
 =?us-ascii?Q?ZP+UEwcgCEu9bklzgWJvfEXQYU3rfh0h5fjlTnOibN3iK8gOZgJ6tHT6wTGT?=
 =?us-ascii?Q?bSFH49kuNUvqDxTaU93Ud3O4vmv0qojUGAK2tVfVqzfn6Jrl40/PfCSpkIzm?=
 =?us-ascii?Q?Y+EidCrgieiDomIhPfgq3uSXWtvCboKrxzQE5PkHgwh0KfLK7OCqVLUZr0Yb?=
 =?us-ascii?Q?Vc9GSZU55lMSv9OJCX6Fp03TdMgX7tPBXYcP9aaBzIBxQNchoB7E1hSUnJVV?=
 =?us-ascii?Q?2A6JzFNlB/eEq9sGsgziy5gb3ljBy3fdbrUe5a23m3sEcLDronqmnUC3AaVd?=
 =?us-ascii?Q?3u7ILX1a4Ou0xdZtQdC8pI15WV3jQAsdRTooqPVMgPJAV8f/yNwPne037TNd?=
 =?us-ascii?Q?MyP7qVjSlR3vjrnX/G+2VW2icNUxx3DkwJ9nGJYTtSGlNfE9C1sEuGoAvWPu?=
 =?us-ascii?Q?Vdxb5nDsnW7ZGKqGjOIQkXZoikR22VXp3cxQlkdr/HHaWWSw0S68GNmDrLSV?=
 =?us-ascii?Q?saAri0Vsfla3ZmAIM3BtriatVTwiJS+Vikcbor0vOLdNaRXR57Rq3am6WHfS?=
 =?us-ascii?Q?6S/hkQGdoKCQv3/Fdm5nHDpeKE2XUMYnL8aCi5T3EsUUnIEuVz4q3VxdBT/T?=
 =?us-ascii?Q?x5qXQACAHuodyrIqlR+OJxKVlyjXRpHDneT6lF9oMWxjKnRjLXymE7oF6rS2?=
 =?us-ascii?Q?l9tU0YHU5I4BSnoaKHeyaPz9oH8y4JCKWnYxDBHQOe+F5YNON8D9KFeRA4Qh?=
 =?us-ascii?Q?fl1FGIAZaw2Lpldv601F0vlC6eNk/cSnnqTeI8Oy1eJMlBVxuQrWk+D60SVV?=
 =?us-ascii?Q?RWOuURuCIlCmXXBrC8Unsl4fZB4LYwXk3Kmv45Ju3nmlqrC0t0rXt+58r9ne?=
 =?us-ascii?Q?u+q3ECxW+jvBu3wmID3F/p0KlkeW2Z7Lw29J0rnze4qLpvNRWi9eH6GE7BWW?=
 =?us-ascii?Q?FEM9N1R0u/yYuKWlJE8eTlhfOxKuJIjkpL01yWOIt9NPyhJrN9fGrZH2V3Td?=
 =?us-ascii?Q?rqsjPRie0ERuzFDm65+3SxP4ubWt3UTrAqqlKnQxpKH+oBKBShPT/u3S+Kz2?=
 =?us-ascii?Q?k7p8VklMIYk3ojhyA7omL10uTTejYhxplB8Zoj0psE+PvosVXwFv2YggShZy?=
 =?us-ascii?Q?2IZvwUgy/2iM1zWGwlYMVlFt2EPMC4KHVO0VxTwMkVH/4HL5GO83Xlt6LIpJ?=
 =?us-ascii?Q?wUOzVielJylMIzlqduSlcTP6OX4HBNI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Vvz0vR7c4S7RVuJKfSXBIGXBaz/Qyh8Pj20UftuUtQYNc6qcEljwnKcFJDy5pxVCp680e2mASd7S8uV9fWAYHSPZu1HlnsYtQDESg8WBsgzLUvAelX0TWng/LSIu6DucPrslZVkRIjEvkQ6JPWYHwz+WNhmbVNQrY0yQGR5YQz2ehIuAeXZQsrRdrGgeMH+M4hmwZv3Ra/72zz5/qcXg1aREjgxImajXR++Fq/qkjBileGAY/CmOlGLnEzUw6H84yfjRjj1vqooptiyV3RHj+PMwvRoBjKJt4lGbSOfldRcMCx+6I06vh7/T6zF2bVkngU94FJie2z426oNBby5tYpbpSUDDLJ+BM6Qau+6UOX0kCtFmqs1lN1eIHGYncp4Ue2Ku2nXZ98K7WbpvcXh5xsQdtUw41RQUdVLOZC9psxEjc+uiaCoE1QlhxLSt8YVlDRIb83Uhx3C4hv4jxoynlvOlxm1qglWcwztU0TUeE2CVOzhlYADMnwvWZHxehtUhXRed1hf6bvYyVQEUfkjS9ibhjmMGa4ChoQbaM+godRsZYpgOjH7zsuzCdvhXXx4lA0GvCDXD+yKW1yRlVOQqzwQ9PLHAYPEOXdn0dvKQE6Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30d19acf-d0d6-40c9-eaac-08de4ed943ca
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 17:13:38.8084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jn2k4eK8s5E+FJmfjNtSNXTsi4m0vXa8G9vAaGydBqaDWV1fIGHn0LwRTbcBliXsr6YvTk6relmfn4O4NPgzoV46WyFN7AIHjrXqiYcNmn4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5916
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_03,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601080127
X-Proofpoint-GUID: CbrVPp2cSHFNvseb03thyLN5R7vH8fT4
X-Authority-Analysis: v=2.4 cv=S9LUAYsP c=1 sm=1 tr=0 ts=695fe5cd b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=SRrdq9N9AAAA:8 a=20KFwNOVAAAA:8 a=bv27XuDUiYcUaJ5gn-8A:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDEyNyBTYWx0ZWRfX+VQyA5dM7LQ1
 +XGK0PpIsE/A5VasR19jJ9Qv2U0AYtfRpBQAkTGNU8RLHoDKDViXAlcbdwjbfn5w6gFquylKkp/
 aYcgYvBwu4w2yg9+lrZI1BhtjOEMNZ43GY2OM4RsHCeVdcpM0qN+V+BU2WA6p9bVt9nKusgVL6H
 WOh/yUZcMgUm4O2aPVenytlOMgBePuyy7T7FV4kfF5Has9yTgsQ8VNg35ez/2Q8WtduJKgiYX6b
 atfqUqn6oFdspA1BZF1mQG1bJUTQkDxvWiIhuBf2uW5jnkSeeScMZZxmHLGHjKZN8m5/FTIWel4
 +Y29lXfDi23+NI/8fqrpYoq6ZQhP47AInusYzLuApovfgGIeg8GgF2bxLOOy6vkmxjey9L6ImVk
 fPAl45S/wzaXQvAwxNR28zZaDIw8rkzx903TOAC6h7DVNLSt8vqbCffQVQ9jI+SsgySvtVtQLB9
 r/yYP6vltJQaRtxO1l0KpW3fL3pxluzPhijmYzyk=
X-Proofpoint-ORIG-GUID: CbrVPp2cSHFNvseb03thyLN5R7vH8fT4
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E15824000E
X-Rspam-User: 
X-Stat-Signature: rfefwqsafhgjp7czuxxaorsau5h1rh15
X-HE-Tag: 1767892459-568902
X-HE-Meta: U2FsdGVkX1/lCMRTRS7n4DuNJmbSV95y+Hhlqby4ESwtQ4xofKsa4FMlVnY4StYw8K14bsMMA7qotQhLFyYKl3PMOVnQXxJt7HwWTm+oQ/rqXIwxAGbCrGX3ShgumqQptIVLyLf/CDLnTPSeXKfDyQ9FSuRda1GyHxvX0IXI/FvUA/U+CcupeQnsWxRcJYx23n3bW2idGCGnZWKFAcfmDfSMWrTfoOHqXMeCRpXeRDiXnCPOuhzLDMlolHZLQEa3K4+IPpBMeSWwLN7TLD4kmKF1fuKCtRMrOX5PZXUjksIqhCTa8yu+maZ+ooBjs7EGvk/CNHLAHHVfGQ6/rpgEkeTrAANPv1SqVGWevr9laL+UAVrMnEeHwZKJ3Tfnto+qNAbEO1n6KhEwYNtHGojqVtgy472VzH6c8sF38+WXyD7e/WWMslqCe6RhdWF0hSESSLDkNq6dDrN5YaoNgNvislSwLxjmlqbj8EjORuX8GKOSYK98sJc0hG2hkFhRROfZFtDHVinoUC4U3tSleQixCgqi/LQFVYdL5JAM8Fna/q8Lp9/Wj4hITHgYLb9NeqgN8hw4UYGzHwfs8+oMvrIBP8pnkqYfwd8xgpKwkxJaL0bKsOYywjGMujM8x7nWsZwWOzazPRIX8yTZDpvbauFl/3YI7HynGW60ObVWvsyoZWMXXAeEWwxE4Mn4NsyhrCXy8zMDG2ilKcHjieNszmE61D5QygCA/zKa2Xybn+a5wpKe/IwmXOTIt1T9ztdf4JM15/SqB0IEa+PSKCwtgwR+Tej7kciSALBWDRgiJaD+qC9AyyzvwNP2NqPvGwwXJKoHnQp2gxQMATWPqh8dnfVyp4UKaLjkTIDtNVb/ZcBQgL6o7+j161UHTg4qQSQuk2takdXIDqIDL19NJrFNXY7CZHJjQY3fy8kPmy/NUurWKPabg6ldWUvyxRnAvI3dMzJQMQcJVytLhBiHI6yKh15
 vZMcTQqZ
 qpuPrpuc92KfSjzLWKD9OBCfjVU4XJMWzXe6YZ6D02P61iDopBypQhskCquMhgPyRokSCluyMmW6Qhi3xKoGbukuYg/3lKrgssO6pae3qc7pJGYBAVN+zyjFRiikmJKloP9BCJdIZ3OkEITIF2i10gn9jMw6dWfZBJDPrNM33FtRJj8zpIaZFlRvj4br97Byj//yNidIcEaCyaZCvw/oBsONE4oRiPLB5dthCGEt0L9JUK6sxoQUcrYyOYkPu95xMZuvfmg7X0av9hj3VuVpxlUSrGkwMiyaSaMjJtKozDX6H9/dqZki8SVJnu2pbP3AyxJjPxPRGbAF8pn1IH8Uktvwp2hm07XcvrOvKa0qE8LkRmuhuKmHiayVD1tDom+WoYUR3a9IDHBaiD2xqFK3BVoAyIVlwY+kHGOJ8vy+Tc0eFIxcXG8pCnQW8ySe3QQOvycgE0hG8fQ50amnIX16CKtAT2IjXdKEyQqX6PtpNW3p9KvlWxVU94pLVwGevIYmNdnOpwSmVK6gRVCiQlcPkQLIq2IGljm7mAcrdwIr3DXdyHnMwXkLgldXYl6tydTCkQ9Mqbu3lNKxfUiBBuWG+bO1FDa5+HxDkSP2iRX+xsO4sbl5YOlTuQCZyguUATxxUIqpQUDk8H9qrDvhUs5exdnoIz0KQVQY2xbg6EvyIyA0TdcShJUT0kDKXRV1rgm+XLXMVYrIMBwUZWQKvknq5YbP7ygTz1nQw4wb3bfL8ptnB3iFRiFvLSic/UL38zZTRTMf3FSibj8TCUSE7H9bEzxgos22NSvz93e26
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This one seems to also conflict with (current mm tree) commit 85c89728af35
("mm/khugepaged: remove unnecessary goto 'skip' label").

On Mon, Dec 01, 2025 at 10:46:23AM -0700, Nico Pache wrote:
> Add collapse_allowable_orders() to generalize THP order eligibility. The
> function determines which THP orders are permitted based on collapse
> context (khugepaged vs madv_collapse).
>
> This consolidates collapse configuration logic and provides a clean
> interface for future mTHP collapse support where the orders may be
> different.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 049da0305440..33b70ca070b4 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -501,12 +501,22 @@ static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
>  	return -EINVAL;
>  }
>
> +/* Check what orders are allowed based on the vma and collapse type */
> +static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
> +			vm_flags_t vm_flags, bool is_khugepaged)
> +{
> +	enum tva_type tva_flags = is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
> +	unsigned long orders = BIT(HPAGE_PMD_ORDER);
> +
> +	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
> +}
> +
>  void khugepaged_enter_vma(struct vm_area_struct *vma,
>  			  vm_flags_t vm_flags)
>  {
>  	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
>  	    hugepage_pmd_enabled()) {
> -		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
> +		if (collapse_allowable_orders(vma, vm_flags, /*is_khugepaged=*/true))
>  			__khugepaged_enter(vma->vm_mm);
>  	}
>  }
> @@ -2606,7 +2616,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
>  			progress++;
>  			break;
>  		}
> -		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
> +		if (!collapse_allowable_orders(vma, vma->vm_flags, /*is_khugepaged=*/true)) {
>  skip:
>  			progress++;
>  			continue;
> @@ -2912,7 +2922,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  	BUG_ON(vma->vm_start > start);
>  	BUG_ON(vma->vm_end < end);
>
> -	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
> +	if (!collapse_allowable_orders(vma, vma->vm_flags, /*is_khugepaged=*/false))
>  		return -EINVAL;
>
>  	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
> --
> 2.51.1
>

