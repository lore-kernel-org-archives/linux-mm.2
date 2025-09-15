Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24E4BCAC593
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:59:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CD8B8E0014; Mon, 15 Sep 2025 06:59:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77DB38E0001; Mon, 15 Sep 2025 06:59:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7438E0014; Mon, 15 Sep 2025 06:59:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 475248E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:59:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E49B2598F7
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:59:54 +0000 (UTC)
X-FDA: 83891189508.18.A274B2B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9AB4520003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:59:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CGD2GTGB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dPMstmPZ;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757933991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uyYIrjKETP/7JT0nAZj61h3NdodRFyu0QZvawuVtIm8=;
	b=GJtS8YKkqezqDW6DsNAf8A3nMthbUtDoVNxjN90VCPkkMErXY3v4UCCzbrR6ED+L4WRTcE
	TNdkg3PPstG+a3sb+31uBy22iJ2ibcp6K6z8LnifrIKtVFa/YFuDqy2/mSABxacMJx4lju
	+8tn8Oa9oIyBzBzkAymE9gyITLTD/oM=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CGD2GTGB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dPMstmPZ;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757933991; a=rsa-sha256;
	cv=pass;
	b=Yr/tXHx9GJHh3/75Za6cLzT9iD21pkC2RtNACmwJXyvESCO199CzoT7Yt+i9pI3XzMDn/1
	RjrsYNMdbogRnj9bZjRpNG3tWG8r8hJySF8SZSUcxYfWMJlU8ma9Vhjqa+5AvW93uaOvxk
	P0/3VWG+q+GH3TmZIub0T/884gQGQcQ=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58FAtp9A022652;
	Mon, 15 Sep 2025 10:59:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=uyYIrjKETP/7JT0nAZ
	j61h3NdodRFyu0QZvawuVtIm8=; b=CGD2GTGBhMrqFuXVhZc41k9GE6GSZTGa0D
	IRwQl0xmt4Uq3d4jg1O9JwZjc6SzcPIMu0qy383xQi1OGc+jF1JoVDCBmbwTBh2u
	xfcoJPlJ1bjOrNVUsSHERMBv82HzH9z4tAFEFHadum0EIpiLtBbVwEXoGtRgXtSm
	QQdNBXocGe2jdDgFDtmeXFjktCQoDSmwSHZJ94JPVmBWNsW0OZQYnrUB0ABVab03
	VLIWFyk7WkoawkqII8kFK2PjMvfxC5LEObAA3sVMSqyRdyvtyDRyxgcwPapNMWWN
	Cwh2+GRrJF27htAtgiXyVcVdOMt7UJJjFptKEoArASt3pYc+3qyQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 494yhd25aj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:59:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58FAXbdS015444;
	Mon, 15 Sep 2025 10:59:32 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012022.outbound.protection.outlook.com [40.107.200.22])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2av9xe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:59:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JgYzo973ebRqktxQ4+opEdFGh4a/VNCtzGcIjUmsxsan5f5beaIysj1If6HDoO4orkGqcuFBytlHMLb/3EGclnACU2Dpl66Nxlo63vHeS1W8GuXqo+zwFAy7dvQbwOig5qNCPdMmXGoSL5EkBiQJ64HB0zIWMDkH1homgqLIIegZ25qlZv0mNeVQBV93/hpeQJbDg8W3IGNuISDHxlQvtW7xcsX4+rHMlykhJlJLKyJF9/e0c+zLO8rZEao5a/qri6xAFu1hZ/05qbyjE6ZVuInBfOF9Tj5QTpEH+XG+bjkO8IqDT1ZQl7Ep6OtMWkt8VMn8RewtJUXgvBLtS47BDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uyYIrjKETP/7JT0nAZj61h3NdodRFyu0QZvawuVtIm8=;
 b=LnvhR1FjG4+UNCXv+DoGh+EhdPokYVskz0LBwL3rzG+egFtHm0MyNYp1Zikgv/Oz3Quuu3iEVUMCWnpvTZEopU2DO2z0eYr7Wgth01lo6DyQ4+j4GYjrM+KkWJhqpYVU008G4SvVJKp4vSkHGqOaNd3gm4ztN1PfQY6Xk4YTUUZQdmE6z4Kuk0eX7GicPkEQEEo4RMQ4IE3KRgaT5z96+SdxPwmp4lQ1wFkKCl2HsAvV/mak2zMwY/tgmcsNXSOXDJ4k/TuMyKAdyNRFFjfo3tdnaPz0AIYUShW0HAAA+/4J/9SxEyuvMF/NsXWMhIST8h6bCvp12kyyx+xy2/50OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uyYIrjKETP/7JT0nAZj61h3NdodRFyu0QZvawuVtIm8=;
 b=dPMstmPZVFlc17xQ3sllMb5rNJu0nFqV6m6qggoQmAdeQ+jHTUTAwt3qKzDFQybUBExAvKEzY0KEa6hAdKs8VJ/kodhEq9avEV/IwCwK11PKja82mqGD46fZaNdHjXOZeT9lhkPyqavF0D7tZm5M8nlGoMw3josx7Cszgv4IagU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB8031.namprd10.prod.outlook.com (2603:10b6:8:200::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Mon, 15 Sep
 2025 10:59:28 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 10:59:28 +0000
Date: Mon, 15 Sep 2025 11:59:26 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
        dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
        jglisse@google.com, surenb@google.com, zokeefe@google.com,
        hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
        rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
        lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
        jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <5099d9fe-4a07-4acd-95c8-782ffc74df37@lucifer.local>
References: <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <CAA1CXcA+pb5KvEnJJqdf1eSjaFiBZ82MRB+KDmyhj3DbiQqOxg@mail.gmail.com>
 <enrgrocqajwu5d3x34voghja7pbvau45oobxgabawrly44ld4u@ahch3xn6rtq5>
 <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
 <2c5328ee-fb6e-45cf-a151-868cc8e7ff97@lucifer.local>
 <4508810d-7645-4f57-a0c5-2ee9f44206fc@lucifer.local>
 <34754ca4-fced-4a3c-8ff8-c00967d487de@redhat.com>
 <92352257-5be4-4aaa-b97f-c4e879ac6959@lucifer.local>
 <de3f5502-ef81-4f44-96a9-995e512301a3@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de3f5502-ef81-4f44-96a9-995e512301a3@redhat.com>
X-ClientProxiedBy: LO4P123CA0180.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB8031:EE_
X-MS-Office365-Filtering-Correlation-Id: 909b9bed-adc8-4834-cecd-08ddf446f0f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZW7IF1aUaP6nH1/y3agyc+xbREq3AnnWCTzmV+w6pfW+xG6D7M+OUvtZuRIq?=
 =?us-ascii?Q?z5/tSq7bVjlEltflREWzoDdo98+I/D2tiLQTvoP+kOr8yWTcxPhWFuNu0M1U?=
 =?us-ascii?Q?gTZqCGqLfzAKPprC72Q7wlch+eW3Rc6HxwMCO96eJMZHXN3Z6491NVo3ppKX?=
 =?us-ascii?Q?LDup3mzq4qoe0FiW+YuKRyw2JG8Gu8DOST9FkWMue4YdXF4zLeMkLQRTiqeu?=
 =?us-ascii?Q?1y+MIt7INpZxMffpPSvaIVFppgeO09z502ZokdLqKkICdErslcGPWutiQQfT?=
 =?us-ascii?Q?b7AxyJIWSRzUCSw8DQEe+ycqclt43SlSYmJ+m2FbrmnK2M4RIwdWqt/gQZtR?=
 =?us-ascii?Q?Oi22mGYkWtlBLN2svAnvwzEiEgSRAhoq1MANwc5kNs9yOCAT3XxAxY1X4iHk?=
 =?us-ascii?Q?9fAufI2JUQWUY0DJOgbCRKpEu5yhx+Eh7YcW3e5VNVlVEoAziNCLkTZSxCxs?=
 =?us-ascii?Q?H7KF1cScZNLapxGIMf7tN9YdVNLmQA6nHYjH2KJsTIV1gCIh7U7MRJKxNX9R?=
 =?us-ascii?Q?dUBtXbjmsJi9KUZcnzajfuUEgmXcT8n5SxFhFCnCNoehhT/L9455k6Zjl3DN?=
 =?us-ascii?Q?Pq2o+mLtfEOhbphw9wr1dc1z0pMALZVNZbjIB5TqP1tEPRODIhebQhqfMxXU?=
 =?us-ascii?Q?S/uwCcHSHgQbkTfjc1pUai2DKMcG5kERAtGNw5HgiURXpK25+7pP7yBc69cU?=
 =?us-ascii?Q?mUNiAdv1rd8pjUmuy084tdUhUdAConKIme0/rx4Nl683DFF7N0S/fcZD7HBc?=
 =?us-ascii?Q?5RMrZfbDtFGY0gkMZe5nSI+mNXIM6ty/ykS8DUw/W/lDNAiw0x3rVUVpRaP7?=
 =?us-ascii?Q?20TMs3qdtlHmrjdKp/QKQ/TcxTok+nakA7iJcCv9UVQK+3h8GN7uvsUxuvQd?=
 =?us-ascii?Q?j4xqAZ+hcjTBy8ZdbBOC8gaMqhbT2yBFnJxUm755C5gIETZENY/q97esTDoI?=
 =?us-ascii?Q?SdjmC9YCRQuGX5fsa9X/MbBIiyaaiDtAY2fDpCtaUp0vrPzyHRK4l3+6thCw?=
 =?us-ascii?Q?4tJQG7lWgPI3miwI/93raQG0vPCuCug2VvJTtlvwGJVfSup2RyqjYlLxp5f/?=
 =?us-ascii?Q?NmDU6IXg3sJPeJp8tH6+y6AxKd3o5zgLccnHq0+41vC9dYBXzYqfDr0eR5hs?=
 =?us-ascii?Q?tr/tk2OypvQN/i75cJtaFLQ1Oov6592+H7zVX6O9w3/ZjbpRtcO+yqWtqpl5?=
 =?us-ascii?Q?5BwwAlIQYEO98DNmS0LAmTFHbzx+2fYvAXmfs3pZlwLqSrDLpElBJ9r/B8ms?=
 =?us-ascii?Q?eNAIQXtxoQmPHujf2nonNSwpL1O68G/dZupi7uV8zrGD5UyCOoiWDPkWHvat?=
 =?us-ascii?Q?3ZlxXheEU76uEtvB/GCZ1lIXnGJYIw5soJXAcPE+NGoi9eF2ucr+BOQSm30O?=
 =?us-ascii?Q?GPylczyGoJeHesZn8+j+8UeJzy/bGh9z5ZW8EW0GMOsd83eRGq60TZAy7fsb?=
 =?us-ascii?Q?BbnW5AAAHL0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gOFsIPE4mBzybOGAQ8xzkd2i+p2OpTp0ho7/3SZv3Gm9JCzMziLS6CzQOzCX?=
 =?us-ascii?Q?4HFLd8IrltSQGHMHaOb20G8e5o/LyrPPmEs7NZrZY88X0wPieymLvKuVmWv7?=
 =?us-ascii?Q?qXcMjU93FBrSlK8cQfNaRW18Kyw+Bbb1fall1/mK/FkvXH59IyXEvytfCV/c?=
 =?us-ascii?Q?K89USXS6xWbC2S50u30lyc2CrgnUQmCz6GkJ9J4EpE6eWkwWFzSXb9WnN+Ze?=
 =?us-ascii?Q?hBgfKQb+6wTbvCoP1qZRdmnXXRXTWLyLNAA/Q69v2K7TdUb05QUekobCgJLw?=
 =?us-ascii?Q?rGiYu8+RJ/EoOv/n12/hV0VERJmShpgQSgGvCYVjhhHADwONtZ3KAqnkf7rT?=
 =?us-ascii?Q?lEvktRtoQilVNDGusvKSA1vSggja2QqXTy094DBjmdzoYAB0dxw99iWdIM6t?=
 =?us-ascii?Q?rzdxf5zbsn2+/EYAtyxaDxdaeLbCUJd8dR8TvN7JKmuvsbQ3iKXdcbCIKS4a?=
 =?us-ascii?Q?spqMo4Q9s65yBOYzqE9n+cFbg8IA4CyX2VifZj6wbRH70W+w/sr3pubcpV4g?=
 =?us-ascii?Q?qaVC5mCh65FoXelH9Uy69nq49DtWKsXr8mMGv3zOoA054NEi1QnXePehsFxZ?=
 =?us-ascii?Q?gqHxgc2Solt169UR3UD2+3v6jM2sVvMCCK3XWENdSseqMqkC7AET4dIsaMC7?=
 =?us-ascii?Q?ZJfjRJtQK/UepNbrPk/G6Zzxe3h9QBcG7+m7xQancrnxFRXzo/1iha74uAoL?=
 =?us-ascii?Q?BL2mWnQKfeUEbNWOWtFcFg7iY2EVy1+LB+pw0tE/0en2piWj1amWo6Ne5dGC?=
 =?us-ascii?Q?pxKgj48iONu/6/BUz+SUs9x/xxf8VDSL1pOUGKvjTbm4OGwtkZQrznbOudVK?=
 =?us-ascii?Q?bMgtA7f1wvhRsPMf6w3u0coZ1eCDBjxhl3hC65Ocvs0otlh/oaTUa3KwURBO?=
 =?us-ascii?Q?Nw3OAU/OdRBr0cWK9Ayc5U2Zc+l3szp4PsMNUl1KeaMmlp2+7M+H569ygPaW?=
 =?us-ascii?Q?/5fzLZ2NT6HOGMET8tET5haCwmRcKact8DB/bX9hxBDLv8ae+mhselUaTblt?=
 =?us-ascii?Q?dr4vZaHU168Xq9Fz4XbdYK1NqycaEclcirCHubErSsF7nMY/Istl58sHa1B3?=
 =?us-ascii?Q?SKKjF/3eV/wFOp6TJ5aVeQiI/NOhqLLsBOSg8f9Q8IjmJW1T8SvJ1uclwwu0?=
 =?us-ascii?Q?oVTC8qtPlb2o1v9T5PZMLBZe8OIF4goYbQDcgzLj73tsF9C+E8kLf4KPHcnh?=
 =?us-ascii?Q?9sRq/ZXmZp+CIkLbFYCDYhmtOe8lUMKVchhwl6Hp6EUumJWW//mCho0oFS/x?=
 =?us-ascii?Q?rlsgJC/6+O93qlMToUdnEzR0Ro+Pkk2t9kCd5uAoHq53IwqwgKBJvMygzbuI?=
 =?us-ascii?Q?CTpQ4iWrdveJup8yyQFLm7a8mLrHEsUcmOn6Od39WCWF9VerovSV2pRtQSPp?=
 =?us-ascii?Q?7OlMLdCQkwkuKo5b7Bqoga3HGdHUylFhw8tIQVmh3ZHDBFGjCLmK+NOaouYP?=
 =?us-ascii?Q?/u5US+nI0ATa+RjF8bVkFDfDBHayEgV7W3YbochOPidqmAxYb7UxRWdYG5vf?=
 =?us-ascii?Q?tQLH9Qa1Z+pdI196snbaYci8NbeoCLuyLxzPw2iviPJkbwGbAlUg1hO5b2lL?=
 =?us-ascii?Q?8nPBg/8tI9QlC+PMH9NjanfzJjRxXs9YJHE+tiynqnH6mu7eHNNHy9kEwd+X?=
 =?us-ascii?Q?fQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4epkh5ojiO0vZD6F1w4htS6oM4UHB7IcDVwwGI5VpM2DbmXhMTi/PKRoFwAMF8rtGVP8xEL7bxLKNoAlQ10KIvWoxE1h1db9JjlsecnbeDm4971adnTRkHw4LnXjLQg5VozUuK5uxWkI5fo6J8fO2A5Fc2ROzHCMnUpJpGTRlWyk2mTj1DFHYr/JseWtfTaNmRsPwEP4CIP6m75kPQjANQf3ICEUwnS8ohtXqP0SW5v3McGOWdUTfKsnFbaAsb6Ht7vkgG0Mgh+olt5N4Gd/nCSPUaANT6zOtBugF3rf6eAHaRHO7/4x8jp7r3LiCctF/KmPr7NAhoahYMx0cbGUBy62+FqOLHv003JcJFuhyIK6DbmPKL0ayCA+jijsHh6l3OGjMEB4scrYiTybyZZ4TsOBLZPLxKAZuOxt0FycA7pMw3lnuKA/UBLSzKCJBLnBBDzCpNUPXGj/twFd6IadeIGI2s14nSfkGZxk75tjgddk7v5HI30wru5UheSoR2ghV9VxrfVzImf5GegxbpjsaTjZP6VdflvlzaenBIBk+9FLRs+G+yfkBrE7gGBlto5Hc2r23zv7Rx5yerROFxkI3EmmmBWs98PyjbUkQQU9Qmw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 909b9bed-adc8-4834-cecd-08ddf446f0f5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 10:59:28.4838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NAzAdW5v6Lc5s4WEy55qbyUO3uEi+N2UhW/fIGJc5OG8Fkpplg6qyutr6rFL/LlLJgX9aEUnpiRjHtDYsJXdQRXx1b0wjxIsVHwGqFdCbv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8031
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_04,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509150103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxOCBTYWx0ZWRfX5NgXGxC02N2s
 JzrKWGRlcQjOX7RSNy/L9D6eEkNDo+yzIDwgdxsgxX8/s1267FDED04mdHcE3qLE54+x7pxKVGT
 UBR0V101fYjwtc8Uyx7Ef2FXnb+pCsY9a0QHizsfeXWf3uYkiMshUhvqhSdRHAF2VUepwpSmoiH
 OMQBcyNY0Kz6T6ESHt2xCstYm+6sWT6b3HGTznBAhODpiHXs/kXiAmv+BGEETIDw8VXQ4Ys6jRG
 W023XZFVpF340kz7bNAWmTPxZyyfKz9Xef47XfhOZuzVPijxcGBfo13kDQCeQQ+z7c+C9NBmh+3
 lmCAC5VLVenZEk3uZ74DEr4e7IXyDfZA/Wj/sHUUe6CU8kejr7rz4SEwnwnuCopOZVbMvH8l/bJ
 jOtRpAFSbOaIKxFfgHfR8F6JHUpQsQ==
X-Proofpoint-ORIG-GUID: XtKYwKlq5q6Tlh_KVffr4i1b8sb-N5aO
X-Authority-Analysis: v=2.4 cv=YKafyQGx c=1 sm=1 tr=0 ts=68c7f195 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=wEbG5rfdL9Owz04-svUA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12084
X-Proofpoint-GUID: XtKYwKlq5q6Tlh_KVffr4i1b8sb-N5aO
X-Rspamd-Queue-Id: 9AB4520003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 9bj5ziwek6biaobf6s89wzr1zdp3tipx
X-HE-Tag: 1757933991-477786
X-HE-Meta: U2FsdGVkX19Xo2Sm/KQSIkpMcFZ/LkjeW5/5PMUhv4y5/VR/0SdFk40otZ4ybMWenv56HatOXihGYGdIAhzDUKSVhePYa7kP4kJ5RgzAyqGoFg60gtjDzIsU4ygy/f3oNjk3u9zy0VPQIogv2mezxAFBuqwrEavlhZFPtj1CC8PXZAvADTAfAgDVnq5ZE3/TNfrnBGSSgMWdjO1J/Gly7in7AXRLzG9+x8FbkYmpeKXYRaFUPbwns7/zBFiJOycQtJYO3e60ReCYF1ZPXas3ZajuOaGQjI5Smhi1Ts6VbKEyzQtz+S4dVzpW4JIotmIKCEfsxAkntMsFMtUTTvx9QNueZ3BfEqRbMxajdT1YFsjm+x7qvxChLRpOnV5eNH/yHIHEzPwZt+uVC4XweUOZdc/TnouoWe6fxGE4DcgHJJ4Ate7Z39xre508d6LQ7uHQOiQUiOQ9dZ4k/y1ZAmAOcvTXmGH7cmh+cja0BmgEdtNT9QWqpCgkasUWkyTtcffsbH0+Cq3FF7gms4v5jcwxe86gZXIUb76TM1H5GsH6WlyhpPo0LbU92FZtHj/+7mwa6/W3UCCBiVjhI833W8NfbW6KjdeNxVR5XFcDznP30SaMubTwfnkGQO8zCGB+OcYAiP+TdNGAIwkM2JtW0CltEcIBkNAuMPyL61QBhtEOLjQtJN5bjo2X2mutaXfPI8dXZAGtHp8TuPnt/I95/tPcWaRuwUmKiObgRV/CHV3aakZqntP2bprgCQh8zEhKg2YHSWGHy1IvixUowan1PUhLdSuIsmnL2QxvuRcui9f5JtJr2MgjMabmyIP+ScQ/jsCT7/psDySOf0m2ewdNO/5+W5RXM7ci4gGX+OJRscmYyBdCQ9g7Z354QYgINICgxn6TgMnVfp4x3qkWfNOix0RK4SdbPsfU1UKODAVPvSKK8LZrHkkzWjYpWTgqGkRR8Dt4DppacsLS5iJtSbpCtXM
 sLEN67pE
 endaNL2d0pYCMU+6StQTO367JlZLe2MSKuTPjysMOhrM1iROowI65ozBMniIZypOdvGsxGgtbSUkibJ/cXK9JLRJOCinm7yLExg8E/e/cXGtWxselT7BYG/xKeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 12:52:53PM +0200, David Hildenbrand wrote:
> On 15.09.25 12:48, Lorenzo Stoakes wrote:
> > On Mon, Sep 15, 2025 at 12:44:34PM +0200, David Hildenbrand wrote:
> > > > > > Mapping that to actual THP sizes (#pages in a thp) on an arch will be easy.
> > > > >
> > > > > And at different mTHP levels too right?
> > > > >
> > > >
> > > > Another point here, since we have to keep:
> > > >
> > > > /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none
> > > >
> > > > Around, and users will try to set values there, presumably we will now add:
> > > >
> > > > /sys/kernel/mm/transparent_hugepage/khugepaged/eagerness
> > > >
> > > > How will we map <-> the two tunables?
> > >
> > > Well, the easy case if someone updates eagerness, then we simply et it to
> > > whatever magic value we compute and document.
> > >
> > > The other direction is more problematic, likely we'll simply warn and do
> > > something reasonable (map it to whatever eagerness scale is closest or
> > > simply indicate it as "-1" -- user intervened or sth like that)
> >
> > I don't love the idea of a -1 situation, as that's going to create some
> > confusion.
>
> swapiness also has a "max" parameter, so we could just say "override" /"
> disabled" / whatever?

I don't love the user being able to override this though, let's just nuke their
ability to set this pleeeease.

Because if they can override it, then we have to do some deeply nasty scaling
for mTHP again.

Would really prefer us to only accept 0/511 + warn on anything else.

We could put the warning in a cycle before we land the change also + just take
Nico's current version for now.

So that way people are aware it's coming...

(Could also put in docs ofc)

>
> --
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo

