Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D3B7D1D478
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 16:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912956B0088; Thu,  8 Jan 2026 11:12:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BF766B0089; Thu,  8 Jan 2026 11:12:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73FC86B0092; Thu,  8 Jan 2026 11:12:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D1226B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:12:44 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 121CB8A457
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:12:44 +0000 (UTC)
X-FDA: 84309289848.21.4349986
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id B79C540012
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:12:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hyIm7TZb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PbmOpM0a;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767888760; a=rsa-sha256;
	cv=pass;
	b=KQvKW2FdmaieZX27/G0mjdlUxPmONvyrdBu+Ppkc8k6u9iW/X5kiJm6OsTXvNnz/N1C3cM
	6gi/TXgF6iDwq74lbIhNacYeAgzZJspqTwbwsj146kWfx1WFfSsC741flKQl0MsF9SdfFd
	RIFHmjgi1gGY7UFfA0rgX1/9c6R/8OM=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hyIm7TZb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PbmOpM0a;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767888760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Alq6Rkrt7zfv6SrSHWsqHzsHNZDVKyiD8qCCfAB0gI=;
	b=6nz+l6IQIb9o9cRH0Ef82Yro+aJYGUkT2TuhnQ9YztFXtvz1CSBp8eJPVi9vuajekUo8my
	XVxlBSmZH4bKxQVEw0ejBOaji7lHqSH6QXV1nma2uWweZCXoD2F3OIEVrgqqPhkunTSRAs
	1UbW54UxeS17+8e9ROreUQX5erfms14=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 608EAGY6285202;
	Thu, 8 Jan 2026 16:12:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=5Alq6Rkrt7zfv6SrSH
	WsqHzsHNZDVKyiD8qCCfAB0gI=; b=hyIm7TZbCII00arBpCCBPPpXctnpNkf8Wk
	O89IiTXCik04D5ETwlvA75LCnWFfQkvjCkjJGglmD0BVKk5T0oqpfxP2CoFgu+t0
	/d9FeBKKR7O1LPww64KZHFIAMTwOFBmm2/1wT5wujtMdsspmrzsa1KycIQuPX1dy
	zF+qqHebWBxtw4nRyFGyKUI9uh6e5CmKvXRyJm3WfYO/HurFY9gIpCwZwKYzj5ok
	UieoF4ou1ItkC5EPadHlHEhimowDNEG5J0Djt6M1hDWDEfeRiBBBM90pgT4qfdP+
	EydqFXZUGaccIFeFxvAk5uaP+UC+50YSlUDU3D7+z07ZcOLksLqA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bje3vg6jy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 16:12:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 608F37lV027538;
	Thu, 8 Jan 2026 16:12:15 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010063.outbound.protection.outlook.com [52.101.201.63])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besjb0g6y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 16:12:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ApKsZrJqkGfbhY5noQn0eQeUEHzNGH3tOH8j05ghkoVVckjmu8bEM+76TqGyBtitOA9ihThjsFOK0071plB2f/kdQzc09jNB3VXWVDBmMqmte8iekl+1FHV9/FIKwugsatSSDxtJL00k7ejIYSHMdauc/BlB8bJ11VNUYf8ZhGbXwx91xPBNlIS15//jQHa3U7Tu8m4rED99TN8gkL+IIhYppPUGThpJ150UKjlGIthhfP66bFwr6zGhZAufc6+N4qtJaMd2a/FyIEgaYOK+MWNpkEe2ysznunMqdgiCaYI57FDO0dcJ6t7d4zhAGPTjo0CgGKD1i844c+auv1Om8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Alq6Rkrt7zfv6SrSHWsqHzsHNZDVKyiD8qCCfAB0gI=;
 b=A3fBcwJdG31xFF9CliFrpF1qwvaZVmmTihLVPOI9s0C51LhIxtgNpjpirZJpHzCZFKbMSdXOTiF2pD+zmQ3EQBxd8IUQCV/Vd93QOtrwJM2M7w/ql/b7aktf+0emdAMla2qvCDmWylGJZPLWQznSAwhjhFpqpcVPvCyl6VeNE8Ju7KsbDEkrX2TEIVgu6XqTpWLqpgUFzhuHQQLEgDCwLJlb7ZaAlY8GzaYi/35xImHOPySNqbvXyg8+/oHYGrw4MdAapwDXkH8M85j9doJUrLs8tkr9pfJ6dvJRoAvz6/i/hdrsmJWKCGL9W27CRFxApgf7PIQ14iWKLzSj5Mj+8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Alq6Rkrt7zfv6SrSHWsqHzsHNZDVKyiD8qCCfAB0gI=;
 b=PbmOpM0a9NXrVUqeYkipTRoo4RCZ8g65KxiV+TjRIusNnd43Ix/FFmE11884V7pPwavVDzU1+WY+qNRBdiggYanu+iJfVIu/55id0Ism+zerQB44G9y59jk8Frr9MjG9uPDYhaK1IjH4PU7lsjteF8cfpUyzy16Lwy7tse1eYFE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA2PR10MB4762.namprd10.prod.outlook.com (2603:10b6:806:114::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 16:12:08 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 16:12:08 +0000
Date: Thu, 8 Jan 2026 16:12:10 +0000
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
Subject: Re: [PATCH v13 mm-new 00/16] khugepaged: mTHP support
Message-ID: <bd28dd69-0890-42bc-bc1a-5d8ad4d2d8d6@lucifer.local>
References: <20251201174627.23295-1-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201174627.23295-1-npache@redhat.com>
X-ClientProxiedBy: LO2P265CA0322.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA2PR10MB4762:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e809e2e-c032-47c6-f838-08de4ed0abf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SjE0R3m6ca8jdk6J9E74vwA1Ta1zdCdqOT+27ItnbN0n030BSINabVLeRnKG?=
 =?us-ascii?Q?aDQNTO2YNv1VhFQX+eKxszyBLvFVcTM/l0oi1vUPQJKEbvSjtDGTtNZCeN+8?=
 =?us-ascii?Q?laJfGsvpzxGnTqy4tDJpKBLQmxGyBOIWM8gvTv21RMph9mc4XT5rqHpd9z+E?=
 =?us-ascii?Q?d8MdgClSvo6u0sSGpJ5f+P6wYYwBK2XsCBaQOojCAjE8mMQURrwvxElYFYXe?=
 =?us-ascii?Q?90NnU60ry5vTBLpF3oB+6wDYGEL42UBZm6nBC33RL8WlSVzwy+yRhwHvJt8y?=
 =?us-ascii?Q?nCL8mjfbWg8ExgMAKuYr2bXm0cQCzbsre9Ysao4UGPFYPj0B8tbSQ84h5JDv?=
 =?us-ascii?Q?7smKqALTmw8ewDs6T+VTJh9+mfQfBSdQOSUJAoWTQd2PT5GpgBsYrAMI+h+/?=
 =?us-ascii?Q?hQKDgNGWUbM8mzPPpE7K/yIVxvDYqzCfed8Np1KiBNdQXMnDlM4DZ1rV9hto?=
 =?us-ascii?Q?U+5xfhcYn+jQysXUSOLo77LWzS/CwFiy0XmgZMhgTgA3SrKYf7Q0ehh/wfEY?=
 =?us-ascii?Q?xvvItOI/k8jA8HxONe463CS6qpWG4RE4nbzHT/iSZB+cRYH0XTYIM52KRkS2?=
 =?us-ascii?Q?mOo0AuoCF8yhmqcbw6NShB9SvdZbuoGg9nATouXYvmFrlqNxS3XKeDGVN+Fj?=
 =?us-ascii?Q?X1ZdsxD4eoJUaGwQ6NXrXxPGpUptiiTEpFi9QHXpI1otRVWQYqrP94u2PQTH?=
 =?us-ascii?Q?VWPTqxC60A3ILbHjIUPTv5ggKIVQKJu25uE2fpL/yu0A7H0ea8Coxnnj+gNF?=
 =?us-ascii?Q?q1hdrYgcZuHWvs/UBDWULcIrbkm2hYv2yX9vid2uGTLVyIjQd8ckYDZmZ8Sj?=
 =?us-ascii?Q?uwZj3ep0ZJ0ZCtTz/M3uoJkimGzVgv9Ph8XPf6uJ046DOqDSD1raKVxBM/u8?=
 =?us-ascii?Q?Y43jwp8JnB9lLg7hvUxUZqIKqEtp17+Z1skpHPGwt2Pqxkhc+4Xj2Sm6VkTg?=
 =?us-ascii?Q?giFu+pd6exZUDfmPveMNogVzJSwRrT1eqJUcHLxbGcr/ucBGwcnA66Wi9C0f?=
 =?us-ascii?Q?MM+M3Bd1TgOXCaV+gnlvLV0nCouYrIk91vwI7SDSaH8HwGKCrq/fQmv1Aizs?=
 =?us-ascii?Q?2UXh6oqVrTLozhBrOZvS7bbwqTE3eP1e/hc1Yk6dx/U1YbsucH+FvvHZrJNZ?=
 =?us-ascii?Q?fpFJqDfQKitujn5X7parsxrTOI5I0Sbq+pV5xedg8GqNRPoTBKBtqqqU/hmL?=
 =?us-ascii?Q?Dll47NFA3ryFi/0Lxqe8gYfLG6P9Y8RcCuqu6EzMfp4BJIAatrdNwYLcuddJ?=
 =?us-ascii?Q?7hxzjiKF90BgqT+UxLlx5I8mMQCVoZzgY0U6RfEegv+dCKrDB1koiBO6Vlkh?=
 =?us-ascii?Q?tNa9OvGEuu+byydJwZIPoR9McgFrOTumTCwhMXptqsH9+8Yun1ruG+1qMrQD?=
 =?us-ascii?Q?AGGF6ATyt1VY1T4gnmtGYmwgMk2dNT9bhRoM1uAedwDjG954Y6f4JYyU1zjc?=
 =?us-ascii?Q?JkB1oLvET/XZh5686iv71zBdH581PgFW6qYrocYQOrmB/SYreiF7Wg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+qH/uNy5fQj4rDiJTlGtSktUtTOj1lxIRZLrPyCXxY3qALQvxqczaLjmQcfV?=
 =?us-ascii?Q?YYeLjbZujFfhb+JbFVFn2astkMgXRpK1IPKt+uwih8dc+rdwxmgIf0om/9T3?=
 =?us-ascii?Q?paRc/aJWKCEhU8KeNTMpVyQ2fm4xOIRYhg72ZLkmr3Tgf5y62+Xo3B0APx+T?=
 =?us-ascii?Q?Qq8VFvwCvXD4/371RGGpJsdqRLLoqMwS1ph1tx3tsqC/x6ST8tX731BLnVej?=
 =?us-ascii?Q?SMLhgqjsNtQC7g4WfSQtJHJi5WhYskSyhuD91RQnQoil0IFxl94Jswl8LMuO?=
 =?us-ascii?Q?7PlBPGzzAnPspalXLcEGi029udFLXYHOa9tZTGd/cCGVxqmjJxkb3ZBflHjH?=
 =?us-ascii?Q?16hsu39wwcQHMK4JDUWzMMHPBPHNXwerHeBnPymOvaOjtb87iM9NxnarjK1V?=
 =?us-ascii?Q?vpmpaAUnzpKtjc2+No0z4PJaza0vuv8QI+LPtd12woX0+Lotue85j+BZAwpz?=
 =?us-ascii?Q?079hGbsYvrgQK/NpZNIzSrJbi/sIgamTCYMF4Kao6ztnV473enr/g0WF2g1S?=
 =?us-ascii?Q?43IZxX+sNIxAziIjHw6EUKuvzvXMtVrbPMhBP2Vq7AYoDZloCa0GkwIYe0C1?=
 =?us-ascii?Q?foZ/S1RkBTLUdswmKNZQGsrxCm72Rn0xIY6WubVzcBa7+o7cEeC8oGmSnfey?=
 =?us-ascii?Q?gvC7+JmLcwG/1gjLM0v1k7BLr9eU8ZOf0c3p7mKpLG9oNBFMP6yrtA4223eL?=
 =?us-ascii?Q?Cg2JxP9LLwZNKkXlNynSTrLQ1JZfj/oWiMNcpYpl8nWZz75bhB20+r4pU9vN?=
 =?us-ascii?Q?Q0veKPGeTWHwlF9Lr9LuoUqhmbClNgOtFh0SqoVixAaOKzBDRQDpBTJ3046g?=
 =?us-ascii?Q?6l/htTiIUhaVtxSf9xFe8BfYX3ItYr0ieugCUopuCo7UT/CnIQfXBAEjWycQ?=
 =?us-ascii?Q?hF4Lt7xj1hPReJB7Q5a4aoZianLKJx1SVavUJTUrWqB6ZahffXjCU4mOlhi8?=
 =?us-ascii?Q?bjlVAicJIBr12hg2WVgiW1VZOxZgQkZD+C6qt0sdEgOFUS3LV8x2ePhQSruH?=
 =?us-ascii?Q?7S1M6jGDR+vkuriYkedPb5rYuX8ZoF8ci450GLiieKiOPUL3DIkHIC9QqlxV?=
 =?us-ascii?Q?S/Vv+b8vcsoFiUtbd8vTChtgqa9IeQt5qovRHA3r5C3Mv+8BXv5d+Ov+Y+XV?=
 =?us-ascii?Q?Qy2WALvK0JVwWgppo3Wlr+L0DrgSlA/I4rHw5INjfOc2D0tPKjWW3d+MTt9T?=
 =?us-ascii?Q?UBHC/D83/ktCG/CL+ggQUhtqjFsP9+6jTyB4lS76B0uPsxTVrZzFkTO9EnFD?=
 =?us-ascii?Q?bmRpznbTs53ZhJ4wZr8aCQ0mTRY8aZkAYPM0M3U/GramtG+Lx361vLlfzYzP?=
 =?us-ascii?Q?RffV03z5dEf3XQgYywKWPvZ8AtUhdakuo8LSffRuq0IYVVqt38ghuzH8tQzC?=
 =?us-ascii?Q?WpU43P3aOz5RBRW+d1hkiZIj669nu2mfn5iKNRZcOiiFYDxB0dtyYy8YWFuY?=
 =?us-ascii?Q?yJpsTo/iSzqnU3TsvS9fnDyKHNatsTLkKx9+0rmCEkoXO3e/Pui6bjMC40Sn?=
 =?us-ascii?Q?prkbSKhKCwQarcQvkVFrOYTdVbfuRtMXqRbDaYLpgLaJR6130v7vkFdwcxEZ?=
 =?us-ascii?Q?3tHDUG2oio/u49gXJz+Tv7zD8nGWQF6gn9sCdmJtoMPGnPRPjvTaic72mIjm?=
 =?us-ascii?Q?p3bD1gLXjlzLFSo/lJgDI7NpeqpFHK2bo78pDajjD8bDdPM6ygtFDcLiUs7E?=
 =?us-ascii?Q?mckXGcubg4RKgT/l63K/UDW0j3Omy6Vi0MIBh7/j5cL/+UuOINifdXDeKyIs?=
 =?us-ascii?Q?M2ZrcAg0O4oGmKXDXzWibfXkv1xKKUg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ur6oTx6C9Uqr5paSGmKedUvLOG8y6YutAZ3z/6I/WoBdwPnYPI9BsZQH+++56NCwzc9jACvpLi9o5NWstYWlazehkXIyZlZDx+80g4AqBgGUaVRPpp7kRoixoLllYUQytw7mOjCT8YjAKKsC9WWrxfZQnKh1mpwAN8+TregipPyHfYy45CWGXucBVlagOM72K55I3uJV1kRyPsOJ7WwsnPIsXocRxTjCLNJ1lr0rSVQtCdenWM2rcrcNy2wwUjcO48wke/PAjshqMC30ysF0JqA5YntPFSl6QkBon76S4fJCxqDcnl91y4c/b35JhEGGHGhDFCvzyYdfIidzF7fCzPoJkReClMJ0XPGMnUb+PwenlPaJFuX6ohzyY1vi77NBO4j1qCRGcCCs9BKXeOCAXYvrG6MrwsoIIjPw8OhXObfRhk7pUKxcMZfvKtVjBV1NfI96SbIe9xo/ehVZahoY9dib4QFXESZ1Z4ruOt4r1ipmzT2dP9IFUYCoxpb0W4JHaS0+/NFEmbirK/3eqW58gjwJ+E7xOw3nY2v75b1FNTalvO3QjQ5ekrKLl3LiYHs/wi2tq4pzU9PdAo+e3CO8q5FFyg3y8rcCaDZ21MxnOmI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e809e2e-c032-47c6-f838-08de4ed0abf6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 16:12:07.9552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KmTopQvHjiLGSLfsC4O/PpljOz4bdjyUhfGmMOftyfPH1pgLKvEdPn63uOQfwC5/maJLAO+MqjCDS37+w+qA0nsIl1GPtPY+ZWt0t2rVEbA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4762
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_03,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601080118
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDExOCBTYWx0ZWRfX2q66Ro+7fmr5
 U9WBpFwMWQ0VMeVLPFzoS2EvIQxQ9A5lD+z26pjfbtu+dsf5O+gx8yqMZc/ArBPRALkreyV2oID
 idSLan/WDqDeAs/f7yU86L4pY1w7uLlEJdONlEgOw3Etzkb9aVsujRwhyGN3d0jL4MFQV8RWxla
 p+yVS1J3rwFlDYIKSKCyLTB51K+F7U/i81cinvyayhqLTdswuI87XdpNaOXCf+ifuogrkPE9JXe
 xLo58OOBm1Pd3+KyOgWtiZNduclqgkYOY1mHLqMUuyNZiThn/a4tOEzMxPEWMsSDwYFYZSjvc+k
 0zLLz12SDYrPuOiuarE0/WpmEUW2YQH7nh135MPRG8t+l6HDb7hEyWErUS/maIsuehyvI9TQKAe
 f/s55HYx7/+KMaKCP/dKbI29DWlQJXauRfbCEw0P6Tjf0DmNIVut4ia5/KQ+lKDdRbIRVitwKUT
 RpP2x0DCqpc9EUWNXcw==
X-Authority-Analysis: v=2.4 cv=fe+gCkQF c=1 sm=1 tr=0 ts=695fd760 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=p0WdMEafAAAA:8 a=feYJxv-PvuhrjdhfU70A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: kZf8PSNvprJDdO-KtIdM1-bS2WNn5Muy
X-Proofpoint-GUID: kZf8PSNvprJDdO-KtIdM1-bS2WNn5Muy
X-Rspamd-Queue-Id: B79C540012
X-Rspamd-Server: rspam06
X-Stat-Signature: scps3pys4afz5qad8kycimb3fjefs14n
X-Rspam-User: 
X-HE-Tag: 1767888760-316920
X-HE-Meta: U2FsdGVkX18Hco+KGzOrDY/6/x9Xb65i6rJbaSsnuZSN1BVM6upNIfmvSWh2v7vcRkkzS8Wu6hv0o/NhIDzL49PCyoCfFa8a8DHKP9rG479us/SGYXkdZVoEYsuhkbGJO4nmUtR9Eg/dJKJAUp+XiJ7N2g7dVvrBjRvIBXNAeqlqPf3MlU3tUADvSZEc6Ntb/9NXMPEFLrFBo3LjJ8NKao1PZpv5/szka6dGb6OZmL9cLNzF6/cOnq+JRMVIN+H2fRextkMfpmc6Bhk7tRUh2vRiLJmVtowRi8ESacD7xdjvBdBYpTBa7AOsmyIBdeZNMVjdi2t3eZ4nRNEXjTFHgBQGHACr+K8AZvSSJy5Xmb1ab3k5OqcSHB5k1Y67mrKxwdCDCLOBSfCVc6nQDbz0YKbvDlrhwMd+laEg7UbSIr6GDVGj/K6Fy9dWa0cURQL/alBjOWk8JTZmrE7rm/Kv0YPNEZUggof/9+ATt+KEms3R7C8ZyILALdr9b6KzMim7Q3oFBb8TGwP03zQnWBI+zI7JK+xcPKlpAA6ckmpriaDStgUO4OchJjFBy/qmGkVnCykMzPNzUrQnRH3kwxIBdYIkfsn3kFIL8/DjOe9VZSZtNaoMJpWDPjOTyCF/4wQIaz4k2PTmWUXTiENVNJrcHD+/2igzLWqQJCBG/XjeBJJyxz66aIB6otjrI/2iDhm2v2/5CO2VpQS8V0P/dAG0JpM0qEiHQGxs2gEzkmKj53NZqy6+JRFgV9AN2IHK3DXmqQuAYxbhuxQ9hblJWTG8XFN1ZpnUQdv3CWxagVMUR1LbQChysJeAA/E8Bc0XMTeAg86kHSIp0jhQCNWM1sFRr70OYlE+mv8G7bjvk+s/3Hs9Y1ua569AH3gXPNWNM9o5748HJaA3ou0s0ZKfWEBijX4WzT6ZJnNbsTvo7RWmgGkOe9zBIOHMUYtMrWoUh2OkVx/0Qzd7ui1yEsuPuD1
 ZX+3DfE5
 PH/EV5oZ2cFqap9cqLL5SYiZMn5SEKdmR2W6oDF/UoXPvyg6/vuBH5xhizBPnjioKzA0OV5/RDWQqMV8FNimI1Y+XGd5xlVPxYjZRSLja42+028KvKXJMODgnSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One nit on this series - you sent it on the 1st day of the merge window :)

We unfortunately have a suboptimal approach to the merge window in mm in my
view. Unfortunately it seems unlikely to change any time soon, so I would
simply politely ask that in future esp. with big series whether you could
send a respin within a cycle? :)

Sorry for the longer delay here btw, I've been on leave after that!
Unfortunate timing.

Note that I am scaling down my review somewhat at the moment as I am simply
disinclined to deal with the merge-by-default insanity mm engages in any
longer, but since I promised to review this I will do so.

Cheers, Lorenzo

On Mon, Dec 01, 2025 at 10:46:11AM -0700, Nico Pache wrote:
> The following series provides khugepaged with the capability to collapse
> anonymous memory regions to mTHPs.
>
> To achieve this we generalize the khugepaged functions to no longer depend
> on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
> pages that are occupied (!none/zero). After the PMD scan is done, we use
> the bitmap to find the optimal mTHP sizes for the PMD range. The
> restriction on max_ptes_none is removed during the scan, to make sure we
> account for the whole PMD range in the bitmap. When no mTHP size is
> enabled, the legacy behavior of khugepaged is maintained.
>
> We currently only support max_ptes_none values of 0 or HPAGE_PMD_NR - 1
> (ie 511). If any other value is specified, the kernel will emit a warning
> and no mTHP collapse will be attempted. If a mTHP collapse is attempted,
> but contains swapped out, or shared pages, we don't perform the collapse.
> It is now also possible to collapse to mTHPs without requiring the PMD THP
> size to be enabled. These limitiations are to prevent collapse "creep"
> behavior. This prevents constantly promoting mTHPs to the next available
> size, which would occur because a collapse introduces more non-zero pages
> that would satisfy the promotion condition on subsequent scans.
>
> Patch 1:     Refactor/rename hpage_collapse
> Patch 2:     Refactoring to combine madvise_collapse and khugepaged
> Patch 3-8:   Generalize khugepaged functions for arbitrary orders and
> 	     introduce some helper functions
> Patch 9:     skip collapsing mTHP to smaller orders
> Patch 10-11: Add per-order mTHP statistics and tracepoints
> Patch 12:    Introduce collapse_allowable_orders
> Patch 13-15: Introduce bitmap and mTHP collapse support, fully enabled
> Patch 16:    Documentation
>
> ---------
>  Testing
> ---------
> - Built for x86_64, aarch64, ppc64le, and s390x
> - selftests mm
> - I created a test script that I used to push khugepaged to its limits
>    while monitoring a number of stats and tracepoints. The code is
>    available here[1] (Run in legacy mode for these changes and set mthp
>    sizes to inherit)
>    The summary from my testings was that there was no significant
>    regression noticed through this test. In some cases my changes had
>    better collapse latencies, and was able to scan more pages in the same
>    amount of time/work, but for the most part the results were consistent.
> - redis testing. I tested these changes along with my defer changes
>   (see followup [2] post for more details). We've decided to get the mTHP
>   changes merged first before attempting the defer series.
> - some basic testing on 64k page size.
> - lots of general use.
>
> V13 Changes:
> - Lots of minor nits, cleanups, comments, and renames
> - Bitmap function simplification and more helpers (Wei, Lorenzo)
> - Max_ptes_none (0 or 511) restriction
> - commit description expansion
> - list all reachable enum values in mthp_collapse()
> - Fix ppc64 compile error due to using HPAGE_PMD_ORDER (replace with
>   ilog2(MAX_PTRS_PER_PTE))
>
> V12: https://lore.kernel.org/lkml/20251022183717.70829-1-npache@redhat.com/
> V11: https://lore.kernel.org/lkml/20250912032810.197475-1-npache@redhat.com/
> V10: https://lore.kernel.org/lkml/20250819134205.622806-1-npache@redhat.com/
> V9 : https://lore.kernel.org/lkml/20250714003207.113275-1-npache@redhat.com/
> V8 : https://lore.kernel.org/lkml/20250702055742.102808-1-npache@redhat.com/
> V7 : https://lore.kernel.org/lkml/20250515032226.128900-1-npache@redhat.com/
> V6 : https://lore.kernel.org/lkml/20250515030312.125567-1-npache@redhat.com/
> V5 : https://lore.kernel.org/lkml/20250428181218.85925-1-npache@redhat.com/
> V4 : https://lore.kernel.org/lkml/20250417000238.74567-1-npache@redhat.com/
> V3 : https://lore.kernel.org/lkml/20250414220557.35388-1-npache@redhat.com/
> V2 : https://lore.kernel.org/lkml/20250211003028.213461-1-npache@redhat.com/
> V1 : https://lore.kernel.org/lkml/20250108233128.14484-1-npache@redhat.com/
>
> A big thanks to everyone that has reviewed, tested, and participated in
> the development process. Its been a great experience working with all of
> you on this endeavour.
>
> [1] - https://gitlab.com/npache/khugepaged_mthp_test
> [2] - https://lore.kernel.org/lkml/20250515033857.132535-1-npache@redhat.com/
>
> Baolin Wang (1):
>   khugepaged: run khugepaged for all orders
>
> Dev Jain (1):
>   khugepaged: generalize alloc_charge_folio()
>
> Nico Pache (14):
>   khugepaged: rename hpage_collapse_* to collapse_*
>   introduce collapse_single_pmd to unify khugepaged and madvise_collapse
>   khugepaged: generalize hugepage_vma_revalidate for mTHP support
>   khugepaged: introduce is_mthp_order helper
>   khugepaged: generalize __collapse_huge_page_* for mTHP support
>   khugepaged: introduce collapse_max_ptes_none helper function
>   khugepaged: generalize collapse_huge_page for mTHP collapse
>   khugepaged: skip collapsing mTHP to smaller orders
>   khugepaged: add per-order mTHP collapse failure statistics
>   khugepaged: improve tracepoints for mTHP orders
>   khugepaged: introduce collapse_allowable_orders helper function
>   khugepaged: Introduce mTHP collapse support
>   khugepaged: avoid unnecessary mTHP collapse attempts
>   Documentation: mm: update the admin guide for mTHP collapse
>
>  Documentation/admin-guide/mm/transhuge.rst |  80 ++-
>  include/linux/huge_mm.h                    |   5 +
>  include/trace/events/huge_memory.h         |  34 +-
>  mm/huge_memory.c                           |  11 +
>  mm/khugepaged.c                            | 696 +++++++++++++++------
>  mm/mremap.c                                |   2 +-
>  6 files changed, 618 insertions(+), 210 deletions(-)
>
> --
> 2.51.1
>

