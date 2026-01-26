Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D2CDCF65E9
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 12:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 391746B0088; Mon, 26 Jan 2026 07:25:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33F956B0089; Mon, 26 Jan 2026 07:25:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1B86B008A; Mon, 26 Jan 2026 07:25:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 060F36B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 07:25:54 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AADF313B95D
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:25:53 +0000 (UTC)
X-FDA: 84374036586.25.381A3F3
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 484EB1C0009
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:25:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eTLY7+vq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TpwCaqan;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769430350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=keHxqdGjg0KMFM6uvEqdX1SW1RbMIT9iCCW+WsxJI7Y=;
	b=HojbeJiHNR1dChj0fcmt6GtQfPgCv7XS8WL5isnRkz+RvgVSeISykL+KT41xUunJa7joJN
	LH3d9iocmsivA38QzCSWSJvuexRO0kEAgAErvG4sWU3gwG+t1FQxoloC6pKgfVs4zp1Gfm
	MYVxEoRkxfhg/2DxEKECn1vvj05LcZE=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eTLY7+vq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TpwCaqan;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769430350; a=rsa-sha256;
	cv=pass;
	b=2TR6uVUYh9D0rmxns/ijk8ukLklQgpvxbzV/Rfj2BM0poczzQmxaYwPmNNbo29Hj1j2nC3
	XK4jCz9jIG2jGELAiWvAqqqzqGNuWAec05fP3dPwtgJtaa0e60UIJLqm23CA65/MznoLCg
	9Kghcz4ENKos71gY7A3UoQHaXzCGgPI=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60Q42pkq1535660;
	Mon, 26 Jan 2026 12:25:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=keHxqdGjg0KMFM6uvE
	qdX1SW1RbMIT9iCCW+WsxJI7Y=; b=eTLY7+vqNOo7aS9qgiVexUFObcedpBLvYb
	C+9rOygpniuBRX3xQ/SANu4yPKiYW3hewTs76fuVmbms1BJ4ERw9NjYnB6LkVChZ
	S4Bh6vLtYWR6Bf6NDWJAWcmdBkYq2/ysUvT+0FR421qlN2KxKQbu2VN05f74RVaR
	XLts2SwP59e2U/SGtdn+poDUnBY1QOMD/qdXanCfGZC72mUSnJyadJQmmgKoqaws
	pQ5DrwMsfYFMqRIw4/ODeCHVsugi+UWg2tgrz3PQD1wStxvTSTmJtDehmLeTs3qn
	rfydQFmozDhIc6+W5uaxVu2q8BPZ0QjZ8VTn5pIDVvuP+XX4wWAQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvp4bsrj5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 12:25:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60QCFxdt001857;
	Mon, 26 Jan 2026 12:25:47 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012048.outbound.protection.outlook.com [52.101.53.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhcde8b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 12:25:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oSxxrtYtJg4GCxwdEBHFnS1o7+fykjV2t4r4D2r8kacXqfI5+ISm4FZbPSziZVQMmamIaDkxp5CY9yZX6eCZsHmmvWGlnUNJI/DT1iZlayyHw9aGAQ2DM/w4ObI+ViBJIOhb/2Jy5Z2sI9FnGXfLea/qz4EbAAVOPL5exUy6HnqZo6mICV/zz0/YWCLhakeOIw1wfFxzlpx+3qPiCYkTrBhiUtmZ9NOwbw34PRC4GygeebXjdcPBDeFP+03OXEDljz708vvZqn/9r56kkk+9MvaAf73ZYn9zs4RwdF/8el0k5A5lzgpUKMwrQ3aEBSsP9LlEkhr4lfvbYAgBET0a+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=keHxqdGjg0KMFM6uvEqdX1SW1RbMIT9iCCW+WsxJI7Y=;
 b=LbHrMF9xSmrEOQPouJmENE1MUL9rCEQN+GqknFwxPAjh+taVD3xvHGh0fJ8+n81Vupac4yQgFCyDIA1EaO+o0rcZD7rrltpiNN+ncIntfFyOJlMurySJpwcf/3uY4aBkd3BIBjjfeyd5AY2FvNm9/Pds4my2DMbr6ExUzXFManYGNBY1BFyl77O64RdfvVcgUs+t73UdMDVAM+n3poOah8iwfncWwbxuXIAjbC+43zOIjI/2Ai5lOTb5epil2vS+QxZqJTvgtZPgZ5i1uRwF+kJAu3n+5feuEhg1JAmjVGzk1cM5WpH7UnqTIEAWEk3eyqzBS0Rc9sQ1czSSlQwc4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=keHxqdGjg0KMFM6uvEqdX1SW1RbMIT9iCCW+WsxJI7Y=;
 b=TpwCaqanXNONakuzFPc0bk9/qPuRcfVOvgJLOwEsYL8FD4VXfWzuIOhqLcf8HxTYgD3DI+kTGwmxWjtvuGmY9rwgzJFwTxSd/QEeKNpObAAojXqBvAgBmJornrJxQ1hDrrcQNte2SNoj9l1zKG2FHtuezAECQoR/lZzsGOWZ0y8=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by LV8PR10MB7869.namprd10.prod.outlook.com (2603:10b6:408:1e6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Mon, 26 Jan
 2026 12:25:36 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Mon, 26 Jan 2026
 12:25:45 +0000
Date: Mon, 26 Jan 2026 12:25:41 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lance Yang <lance.yang@linux.dev>, Nico Pache <npache@redhat.com>,
        akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com, linux-trace-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, corbet@lwn.net, rostedt@goodmis.org,
        mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
        linux-kernel@vger.kernel.org, matthew.brost@intel.com,
        joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
        gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
        jannh@google.com, pfalcato@suse.de, jackmanb@google.com,
        hannes@cmpxchg.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, zokeefe@google.com,
        rientjes@google.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, David Hildenbrand <david@redhat.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH mm-unstable v14 03/16] introduce collapse_single_pmd to
 unify khugepaged and madvise_collapse
Message-ID: <7e666361-24cd-4eb4-a591-73a8900bdb5c@lucifer.local>
References: <20260122192841.128719-1-npache@redhat.com>
 <20260122192841.128719-4-npache@redhat.com>
 <65dcf7ab-1299-411f-9cbc-438ae72ff757@linux.dev>
 <b1747380-1f2e-4edd-81fe-f01b3fd01bad@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1747380-1f2e-4edd-81fe-f01b3fd01bad@linux.alibaba.com>
X-ClientProxiedBy: LO4P123CA0488.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::7) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|LV8PR10MB7869:EE_
X-MS-Office365-Filtering-Correlation-Id: 012f0bab-fb83-4921-1497-08de5cd60766
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OgTjDkPPTYmfTqjmin2Uqf/hLVGWz/ofWZOxKD1g6pQA1f+0pV9ZgLfc4EOy?=
 =?us-ascii?Q?Jd1PzbXYvUWmXcQM+CeJZIHyKFP1Dwclx9v9qhz/O9fDafM19obzuXb2rY0u?=
 =?us-ascii?Q?HoJmhCq9VC7Qb0Ae4rdcxXBknWYka1sslsZLvWUHjfX73KB887idR0HLmYLT?=
 =?us-ascii?Q?MtTNfYV2g7d/ajFUXeQPKRD01J9lxKx9nUhudLDLz/Basbazxjh1AdeYJZid?=
 =?us-ascii?Q?3jDaTUsRGpnl7EVyqazvR4gRbx/2UGyc9yUhEiDeXqaX0YEais1e4ZrBwJvY?=
 =?us-ascii?Q?jGOKvK2dOAB3k1D9msXNLOdr7xMqz/Mbp/EboPNrjT6k8PS+oS2CFiSg4fOL?=
 =?us-ascii?Q?XCMoHkoxB9fmE44Ky127BweaC+GcbXv0piAl3A7V7R5wLn4rq8JsyhKhmfi8?=
 =?us-ascii?Q?2giilFgSOmwv83IYk7BjJ1+Od9OmI/hMwez28UKCBWyg0smejfzHONqwcKtz?=
 =?us-ascii?Q?u+XABNEM/polGLLTovCWB6H4vopNo4dPHiYWQsrXE4xLl2nvaFGnqYnXcE5i?=
 =?us-ascii?Q?WInNJgbFPNsIKuJmRN/yS5lAX/YO+z3MOHF+UoHbGdQgTvdYjM/p5teBqGVV?=
 =?us-ascii?Q?9PrGkuoYawnnHDmhkIVKVO9faYAP4gJukAVUapD0i7VW5axrpHZqWMRpcLfX?=
 =?us-ascii?Q?NSvZ99oOuDJimCNfCSOylJyaHS7/C8uVu7tEOR0b/tzlH0RQdfRx4VcKtK+y?=
 =?us-ascii?Q?4bTzz5ZFO2jSHh8klr6TzBUeI44mSerHM02EGp58UB22ejgAXQyuxTpwLjgR?=
 =?us-ascii?Q?p4F5d+TGb2gOZPROVP9pB1y8eJyRClyJ67QoXQe93AsLVHKK7yR8epRqHBB4?=
 =?us-ascii?Q?9KtpnwPgz/+EjGacY92Sad/xcMBRyYTTDNAM8qd0qEoFwEKyE2IOejOYFPue?=
 =?us-ascii?Q?oLBCgM7Ilzu5BNrkjUy0Yd1JNS0PTB7TqqWSAHIdAKKW+jgaJlqNTBQOnmRA?=
 =?us-ascii?Q?DStS8JljztOvcWgz/t1Sggt4LMj3Mt+Zm8u54X+7PtPg4MFlmYV0/Gw/KP6c?=
 =?us-ascii?Q?rqg4CtnN95llI1vnjMQ6IuI9Ay2M8Msx6zTLpj3lx7Lv29Z9ZSlyZr+GejP8?=
 =?us-ascii?Q?/yoUABVCiD/QykUnZb8yJ/Pda7a1wubaK0B2yH1QsIAVIQRTT3opxJfNUnq3?=
 =?us-ascii?Q?EDBjYB9vZ+AlACQroNHQtvEILSB/Rq/tJH8fU83WvnuGt2BwUWktSzDb78Ru?=
 =?us-ascii?Q?HLIJAF6uEKE6ha6wwc/0L89Y+xhdaXhJhpMJ3cJMon0YDL9fA7Q1z7F9N37D?=
 =?us-ascii?Q?Z0WO1zyEjc/QAOqVnrTUa5bViMgvfiqbuXNwiiiY75zE5xRYiEFo9If6/oE2?=
 =?us-ascii?Q?4olpdmBDpumtbN8nnCbJM5eKufzbZuUv11rM0cSeCwlvrjcPjKzDBLUStw/V?=
 =?us-ascii?Q?hTCdUDNn09FHaepbPBswWi65ayQnzb5WIZZXTNoA8F6ZdQyvrHrvvmwKVE6u?=
 =?us-ascii?Q?kQtjFFG9I/YVVijfPZShRrZ7zFWu17yoBbayzGMdO8JUgnhBPN2ax4inEXJK?=
 =?us-ascii?Q?Rdxg7U9DsoZ6ZIpjWsgPHEyEwMaqERpniFicOyVSUnag3rRlW7i4hJmfhJpy?=
 =?us-ascii?Q?2n4RboggUDqGhe7UthU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HpBtfI1jfaisKLLIzdksqaEodhxcSFKk2hFDq9o6LMZtHmhpvjSzE/xcqLs3?=
 =?us-ascii?Q?atqVUuqqz/YCzWF+Lcg/Qhd5kmZAmFFjhPZSvwk7P4FsRNKgZNnGX03l6kUE?=
 =?us-ascii?Q?iUB8WB7Md8fyUGZWkCO2Uvo2OngpCL8yDHvCAZKU4qxqTH65+t6uoIHwKCxs?=
 =?us-ascii?Q?yXtODoYjdQwfES2tLQtotuT/Nc8DEQsFz2CyDYDK//MuHvgGQVeoMj7icSij?=
 =?us-ascii?Q?J9BeyedFKDRz2VK1Ndq5eVu+IkMCD9cA5KtC+f5dBR1flvrAK0xuDmcro70Z?=
 =?us-ascii?Q?KdzKq1qlUMsqWBBDKcjDMn017sisCdFLt9jPnwNyito3QpW2VSW5IxMoZ+k2?=
 =?us-ascii?Q?W2qwZrk5Kt+sT6afrOVPpgsGhlaP7Nf8V3pDLOBOvsABVJnMqOe4Fh0hJHvV?=
 =?us-ascii?Q?VU7p67znvQu/zeGZ7OCAvJTLLd8LoyEJrswDICOXFUC4mSduO8zs0sJss8xU?=
 =?us-ascii?Q?bbAmkOXpjcLr95CNGsvGI3zl/8rTcJqZDP50OvKzJVv75YzjFdnbK3BuFE4Z?=
 =?us-ascii?Q?Q0TDLqskxvEeC+1/BDAuYL+/mcVis3ZnPltEc4WsG/uC4FZI7Idbzbjit1MO?=
 =?us-ascii?Q?CijJdvvgXSzUWS4ovBKxDlfpmGEl1RyWfA0U3BmVVRckIjUt05DUoeU2rW70?=
 =?us-ascii?Q?v3QY9ScLiVF0XDT9nQpJW1pVN+GUmzVivX8UtwJWcOEJdGzOxKK2k6GGq50u?=
 =?us-ascii?Q?zlEaxixipTYOe3sIUfgzPCPaJNPcfSJfZUyt3kO8OR6YAvq0znaQxiJZevnX?=
 =?us-ascii?Q?sjxKgsq6d+fj111Sctk6s1bIJXUnj9ibpG0IF7OvAOLPkjUJaNC2EOxl4zvP?=
 =?us-ascii?Q?uhOiljr9CMUi2kyDp9L+x0lQH6pjG+L0aLCcNTuyP9vUNdBJVGQXHANgFGRd?=
 =?us-ascii?Q?H5Tf7yTTl9siVUQuY72TSyrj2Y+QMp8ZkxHp1mKzBEysNeYQoTilstxxLfPR?=
 =?us-ascii?Q?p/WEcMrMu/FfGuOX9ZjhuT8YuAlyyQgSxa7HR2L9Til3eP90IE2UmjCuIChv?=
 =?us-ascii?Q?bC76dQ5ri35DWLkrzL3/pBM2jW5u3QCudsG/ZuVR6sXnHwVY3aKHcfEFdxS4?=
 =?us-ascii?Q?LcFnTs4UrXX4wFl65XCCWaBC40Yqci+ClpQxX3huG1wXrUK81Q7UL8CJtJ8h?=
 =?us-ascii?Q?Q+hG3jyeDVVsiYqH1FO2sXxaNQmGbWEoppQ+Npb7urfTpfjJXxENQ/LUg5db?=
 =?us-ascii?Q?R0jb2vQFLEKngKnhVpvMFdkizHXgRztnE/9rK9Cg5zjpGzTiEg8YZQPXhJtF?=
 =?us-ascii?Q?ILp1oGZyLMWU0D+EIhmevhXd/YZ5o7xcu7ZlXnMS2LGQoKcsnXU7rnrtbcRE?=
 =?us-ascii?Q?FUarNa8+/MxWRQTWlRFGB/JILtNsbTWeeSdAyayQbirx5CotlQ7oXC91Mv2o?=
 =?us-ascii?Q?+CNB/yC8TdzSrneOraxk055xZ2SZSSNJUu2QdhRAP2yEeQQQoxr7cQIVWhea?=
 =?us-ascii?Q?Q4N+noIicWOI2zDbex/vcSuElVQXaxcOAw8EcZMyVHf2ccklCSKRvkRC0tmz?=
 =?us-ascii?Q?u0YBNcWC6Xml1vwSykpkJrPa7onoCrHjhGhsrXks5DXE2ILqDJzGgT3IY2D4?=
 =?us-ascii?Q?hseXgZs7KWdF6eAmZw/+9CkrQU8FDUH7KX8UvKsPpeedx/czvj6Ygr94DHLp?=
 =?us-ascii?Q?/4D/Uc/qfIRu5nxYG025LwhcvPNqkNRQimV3A/IQOX7I35GcNv1bl6b4qqT2?=
 =?us-ascii?Q?MKxT7/C+mYehHcpBUl0JOorCBWlyKgKPbxgqTuZkTW910lYNBIq/bJtUxwFi?=
 =?us-ascii?Q?IQnCs1kixXZUl6wfcbTlOwE20YbprDo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CMeoRbvCyzCVchK7ywa6c0bajw10CXtOx/QCJYmK8JKP9MBceH5R4dFqMoeQxegq52IX8mMvf78b1V/WuSLSHDXduUDVl8A9VhWn1TxbQBQiV+GwkKHAy9zWwkCf7DbZEBm0MvStFX4Ux+zWyOMuSFeEzvAlbUHwumTLsaJDQkPtn7lGxEY5Pf1BXIbR7rMWIR279FU5NJYjZGuSRk3qLlUMuPMhlwxM4KuSZsKuq0kibI0ZvGVygNekDJRHPLQqjbmCh3+LKXiIUJHNZfDs73gNiOPl92xpUN6PebeSUF3X8BqcQgwqGQfV5hULilhZ3jK6Rm/iYg37cqzqcs1xLIJCwi2GxzFNnigUporM4qRfPBpyno+jMe+gS8dzu2WBdX8++ta1kCqe0EEFgrPLBS+EXae+XiH9Y8MxH5DmZmRRJ3ICsHlwzyUpnrv8viFLFgvElGzyeQJOGMiFc/K8IlY+RaEq3phrshVCxceCP9ogrrQdAvhQMqVsjefpGSQCEwwnuHmaF5C50532ngSlbYyXLWC4XoeGg+Dlv78qlC6rkX1poh4ZWLJJsA5W/89y8FRsOJ6bKqAZObm6LrvHGfi8oQktvy1GWz649c02j00=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 012f0bab-fb83-4921-1497-08de5cd60766
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 12:25:45.2108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4gnwPQl3TpeMhGBEEdJlzjCIR5WeAqdQQV5kihtRKd1OvTmDA6dHY4YxOIbalQFtT/vylkLM+hNSHrEawAyd8V9r4i8ndPKwrZOY22BTBjA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7869
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-26_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=457
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601260105
X-Proofpoint-ORIG-GUID: pJAiv_UBS7LNqyECahf4qrmTy9EmEOI4
X-Authority-Analysis: v=2.4 cv=StidKfO0 c=1 sm=1 tr=0 ts=69775d4c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=-_PKkz5EsPa-ZpMzDjMA:9 a=CjuIK1q_8ugA:10 a=zZCYzV9kfG8A:10 cc=ntf
 awl=host:13644
X-Proofpoint-GUID: pJAiv_UBS7LNqyECahf4qrmTy9EmEOI4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI2MDEwNiBTYWx0ZWRfX4A7R3F8Ghvka
 oYAobOn7LnMMHU/JBxnD6a9nadNpRjT3DGtfJq0eACwSMON6LO0KxKaO2MVLgb+2Kypvv2Pd3QQ
 rFuCQmEqAYJvXPxU0AoFUHAqL7y9pXgCaoIGH5927hTzhTrrMdY0lE6WdWTrSEFoU5ITaD1ZDGJ
 58pom3439cM5CUZ5+Jk1994q6j8ApP+6R1fIDuXQ87dKn4kxT+9T8zR1jSOmi9trP7Lft5ZvjFu
 acPJfHHqZTP+i6Hbb8LicCqUV/kgNkqzZYN4Oz2DW1CVXZe/iQJ3KFvkU7P6DVKWrqyaRfp5CaH
 5SA/Zxe21ik8BOmj7ywShSYwKkcmB5DlXM74ZBKDYbAn5qGUjLwRFbPYR/4RI+OKzfzzXxVWLEf
 nCJB1wzOWgD6lV1XYElXmbtRgRw43+VFfBbuqGaOMxz86KgPcmx1Eg+AHmKaH5G1Wb8lm6shz9n
 Qih+zTZUU1hBqMwkAcpAbFV5bwPCZ7ZB7JoJEzRg=
X-Rspam-User: 
X-Rspamd-Queue-Id: 484EB1C0009
X-Rspamd-Server: rspam07
X-Stat-Signature: zqhetkh49o8438ucdsx3qfcf59yn8irw
X-HE-Tag: 1769430350-944055
X-HE-Meta: U2FsdGVkX1//od2I/wg2tgbSlC7wR5rh5OClf9yYyhECzldq/nRegpgAtZq8vnyocNLchQLzUflj1u2perDXrxjnkklebiVDckeL1SR2HAsADh4VDMX3U6KKIl6+spMI2Q7iW525MAvVrmDStQ0DEG2sziG4NyVVvxbZXo8dNgVdX4/WcthyhaF9bUaFxDl4cvOTTtHRsDhZ2KRuhJHSXppRr96UiIN0Al61yMS4dfMD+2xP+LKNr3CFr1H+Sv78fp7r1zXMErxA4cUqdtPHiVVWouobwqo1a2xU5ibMipG3169iEqmJyYEVTbDQopchN6X11D5Sep2SET5fXG4EcYjfrTB11gD2TrOXHfWz5BVMDpgGwDkchf1Vu4rz2OSR3PGWx1ECXx4WYhOH+gyPaDkurTDHUEYsksPU9zyJb1Gy8VgGT/3jg909bh6wVIukKXRFaBSW+bbBkUqR8bcw/m0ha4NTzPWV56PCdtQk5YM3xaShr/gXCnGlm/WSQq4TX8HIRLkjxkINVkXBa/FC18LGNp6e/iFaGaUuRTe/rkp4MRtzXdLFydmObKbLlXpJthMvXRcoofEO5iPYoJnBJyOqQrbK4uTTHgimU/FbXkGw8HK9IHSsfNV0fVRu9OW4q9kk7kQszWhC4BQ2VNyVN3Z1vm61ukh9sYGN48OPRZdgnHMHavYMhtEm/2NPgbra4qGTNeie57trOwAguXY9Z58j3Z5vjEUuAW0tOn7fStvVB8O6gokrAca+s8Kvp1NZqOXRlx9UES+2K8XrFqClTVsCicDouKeDgCOetNA5c2WsIAFDhRjmRkv45Pac5DD4xptwRzyMTZQ8dMiGWyhfdcbRbwwxdBX8apeyHKAhoKSBnvzr19meS7qn5wnIBC8hBXjjGqkuhh2G9pS1Zrbm3qa/ehQLnw8t4DKXTPQU5FIFzwMdD50PoKlPX9vjTSCODyD392qqrczhTTFzEqj
 HytnQNix
 szSZQL7lSMldWD52MSF0gjKlHd1g8uGU32O0ze8DMGCxqixaSq94YxNfs76YHRElTr4K73z4qAND/TtA22766sQCm3xBry/CElKSEvhrNWaiyBFXJDX1IWTj62/vhpalwVVh8j/QRrGnqhTl+ypRxXKcmpw6lGnPKUVZNujrKm3ZRxSEj6Ke+82Y6zFvJ9u+JbS8vWdM8jmDYa1NDbg+ITsbAjX+WGiQn8DZgsTVZmtDlMMp1BFAsAJqWabFC8Kd1f5HEVe6scLlwMYp6ES25fghYkbsMmjAh3acN6m+gIR3KcMlSy6Cnk2BmTmv5SQJEHQSnPtC5ZB2z184wiKo/c7n8TXDFuLLDSE47LYXQptGyySvFkQ9HofT3V5VWw23EJ/eLgqqXg1VI5xwCTQC4M4mPDr/Q4At6SKthfxvljK4RN+Q7nt1chHqGA8YKPUigu50C/F/rLcdpECWHakjw334gy+NX1ppqYm9SdxPkhkF/4T1IFUG2J25x5qzyrxjTosVbFtU25ZDx3o4aUe5STqCpTJ0TYxH1oK0XFqnQyBeJkTwu7P/hUbhBX0BvztQMI1PBehszP5WvHsFGZiXhXdG4PH4JHJVjzAmGL36cFH2wWmlpIg/8zLkrnEtg+ysmx/4S/plTBoeK4t4Km73PoYxjkW59Pf5zsYGHFpBMAqAODXQjxDXrULjCxtPdkhzqlfuoKVrwKZeadd3JRiTeJLpa7vxTYyaWO8i9Hc5AmpTHLZ74YiNTbuZnq+zq22YoYgsk91f0gWfalxM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 05:31:17PM +0800, Baolin Wang wrote:
>
>
> On 1/23/26 1:07 PM, Lance Yang wrote:
> >
> >
> > After collapse_single_pmd() returns, mmap_lock might have been released.
> > Between
> > that unlock and here, another thread could unmap/remap the VMA, making
> > the vma
> > pointer stale when we access vma->vm_file?
> >
> > Would it be safer to get the file reference before calling
> > collapse_single_pmd()?
> > Or we need to revalidate the VMA after getting the lock back?
> Good catch. I think we can move the filemap_write_and_wait_range() related
> logic into collapse_single_pmd(), after we get a file reference.

Good suggestion, is what Nico did in the suggested patch :) Agreed better there.

Thanks, Lorenzo

