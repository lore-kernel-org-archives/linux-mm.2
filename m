Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A075BCCF9EE
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 20:21:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 150C68009A; Mon, 27 Oct 2025 16:21:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1011880099; Mon, 27 Oct 2025 16:21:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4858009A; Mon, 27 Oct 2025 16:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF68480099
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:21:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A75FCB6DE8
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:21:48 +0000 (UTC)
X-FDA: 84045015096.20.9115391
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7FB9140012
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:21:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="ceWVyB/9";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ItHOrk1j;
	spf=pass (imf17.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761596505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fUSQ95lSjSf0dcucysntZIceCbJA+dhwhaFtfbEIMKs=;
	b=u6sTsdgKlgvxsZ9f/GHMmlchC4zw9CdDPe1t5eT+3PLJbLACkKBLH8pXgxlLyc8JjhT38N
	tQRNYot1kIxsclVYtxur9UYcoi2lTiKPll8iP21cUK4Opi5eg/lEfcnIiXX9e+tZ78aXsL
	clmCdkA0ddxbrqcPy/3ALUfDNy4vd4o=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="ceWVyB/9";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ItHOrk1j;
	spf=pass (imf17.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761596505; a=rsa-sha256;
	cv=pass;
	b=fApRJb8SNx0guVwmZzRv1vbHIJqAvzfDjxzX4sZNE17mrUYR8I+XQNneuLlX7oF0a9jN0l
	iQ0/xc94a8yJRB7xMBieppiwWQsBmMbrwi0CyTjE7C+08YvHNG9YU9FB3YmMbKCpAZxVkc
	DcrMIt6MjyrvatOg4yzBl3SVXjgN5A4=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59RKDPMO013956;
	Mon, 27 Oct 2025 20:21:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fUSQ95lSjSf0dcucysntZIceCbJA+dhwhaFtfbEIMKs=; b=
	ceWVyB/98l4HjQTobRZ0VeqTqSi8Y2r783PGiQktrs1wA04gSQg9qQFiRE46KbYw
	E6sX3wiqnKMUuPF3K/672SpXjhr4/Nlviiz8juPAaCNp9hIlcgVNrjYaGI/V9qOu
	IhJ13qa1GI7e8s0Ewq5zlwFDtlcyHlrNypN4F2DZaqGHw16ISfr1wf1gNAV5lKYN
	CYUXrOPQxOWqEB04XoyJ7EX15u89wqqq5/PpRmqLiQVTPxN4l63Mdez9eri+M0NR
	8fc2DZfNKXRQxPI54EvqDtl1NJLxe1641Z2LPd5vhToW1D4YmWTfMHNGvS0pT4mz
	hB51uSyWiE3cFf5CoNkVwQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a22uu9wrn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 20:21:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59RIkI1R024485;
	Mon, 27 Oct 2025 20:21:34 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010056.outbound.protection.outlook.com [52.101.61.56])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n07h7ue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 20:21:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WUG+oZBXcgkYqMK1Gnkpf02YKWVqLYdx/9dGji3IB48b2cOz2Ek2oLT7STxrEii5h3qGW31yT1yM1CyrckEZPjhyIV/Dywpo/9f80GsoRGSJWmFs/rx3HiMlSCudIqkXFI+teZXD70qtohN3n2DiXxmoarnOPsKEGMc6Y1Kfs9ikVG7dQvCK45/Jgn3kmhntw0bKCk67R1rrxR/qsvUY2tYQWncURMQi3lmFvwEISTYA2fmprF7uW9z0MYVCLkp5oQO+H2qa6v5nprq2zphHNdEzYPa+J61ty7uGoJ5b/tRaN2XID+f/C6CAc0FGRwv33rADjqDE9J0XAS+C6kglOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fUSQ95lSjSf0dcucysntZIceCbJA+dhwhaFtfbEIMKs=;
 b=Up7Gz5aZ5ZJ9i7evHH3d3+D+f3GKgUuUAvr2Rk1A806w/nCOaIrGDFHisGfyXS+QiEFXtpsglXyc5F0uNwoluH2swwV1L3fuXkg6NlVJgEKSCtBg+agXuA2Bv/H5uv1DYVai0D6oKOhc94NjqSZi5O6r7WsZ99uOwdZGRl74djlmiZRizUjYdun3A/a1cTAwR7DkSWXisy9GNnzRUvMzvX5biXdjwKYH9Nq7uDkrLPe2vJwBhUPdQ7Vp737/nH+79O6LzOr/1UaGsG7O7Y36OmFGh6ot0XCnSLJPJO2M3IoNumOzN2bTQaFBD7tVKznKaQ18QYcwTzV+cdfm/FZ0AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUSQ95lSjSf0dcucysntZIceCbJA+dhwhaFtfbEIMKs=;
 b=ItHOrk1j+an0Llc6Krj5DW64njipyjEa4zuMrCQZldHNXoT1SFoIupkoQ99hDes6+QFfDR5tQzv/AU2+gbp33IsrC4q2jh2rsoNKFi4igiDNCUrA5d5a1GYoXMy8eZ3hj9Oo9mP/FFtFFiQNYOPQxw/9l5lG8lBQhKodvnBYd4E=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DM3PPF1A29160CF.namprd10.prod.outlook.com (2603:10b6:f:fc00::c0d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Mon, 27 Oct
 2025 20:21:29 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 20:21:27 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v8 7/7] mm: folio_zero_user: cache neighbouring pages
Date: Mon, 27 Oct 2025 13:21:09 -0700
Message-Id: <20251027202109.678022-8-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251027202109.678022-1-ankur.a.arora@oracle.com>
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:303:8f::28) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DM3PPF1A29160CF:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c8db2d1-c02b-438c-8b92-08de15966810
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?umv4u6wCZYD9blborrywD1Zgc7ZWJfvfYN2mH5xhT8FTX1D05pJuXmNV7gjP?=
 =?us-ascii?Q?RuTp6zxVS9UjgOTSXo7GykN/ZclH3xEvo59sumAMyjDWQ5hd9keukX4liJK1?=
 =?us-ascii?Q?LCSnn3n3WHzcdPNtWbyDXizyANZd1eCAAlwD6M3c1tOwTOF2mkFLG3wSid58?=
 =?us-ascii?Q?TiP7ZKGnSMDwqZoq7/DKlxheQe3vLCWuwzTQ+kMqlr0H0C3DxwFMpSJbCl9A?=
 =?us-ascii?Q?h/E7LjbbykacmIr3FvasaABgzL2dwGvRSbdKBalJeKnC7u8bwOnFZI+OAC0J?=
 =?us-ascii?Q?/TKYOpQ1HrJ14PsJCnXgJo4C2Tj5a8UmMstSqlLowfDycu6kztK6YqRmPRkS?=
 =?us-ascii?Q?npyad0ZevH5A1slXIj9RC5VoSu78AmNm6vkBfnK2n4ijkj9rdebeTqtJ2OFm?=
 =?us-ascii?Q?YUeTR2PeqxnvwjXDFsvgIORm8aOzDhpnTk6+5RCD9DZbvuPJJl9llemSVoZH?=
 =?us-ascii?Q?4GpbDFLz/goGsy/NEz4RcPLK7yGLP3x2K339RqwMym4Gc/XBHQWyxRlxNiZ9?=
 =?us-ascii?Q?u88x3ZbMjDvf9M3htfhfPVDBN+6v8CyPcu94ACk0FaurFPuFsf20BKYc+mWx?=
 =?us-ascii?Q?F/zCmxdSsk2KA4vnUChZOjWaefRGKBL300GBu7GYVDxC4YRGOPs/sv0g6DFD?=
 =?us-ascii?Q?KXRQfIWTkBRczXG0w2A/jnDe3DhsCVEyE1WTvlKLNbBBgdBTVk4WGMB0i2Qg?=
 =?us-ascii?Q?YPZbO7aX7lVY1C54yOgWRFmeyCk1wUumq8VUlnVogoV+iPR9ODymI9GVcLyo?=
 =?us-ascii?Q?e5J1AbFPVRzTpkHLojSqXXYs9BYgHwekBC0cP2mhFCMP/Xpr/AbirV0dWPAr?=
 =?us-ascii?Q?05rBpcZMMYNWrSQhdskrDXG6D05XSpBQOljIlIJ6CEs8+BJEcPej+ZeEC5AE?=
 =?us-ascii?Q?5Uj4qIR5N/WjDDIqx1iREabizrVri6JKd5CqFXyqlaaDh3lrbzLV57iacmMK?=
 =?us-ascii?Q?x6gzC/PQ76z8+LSBEVD9AaaaUBzeRpwo2AmkjURKumYFgRHzHmAgYBiiJHCC?=
 =?us-ascii?Q?PItMohmBtK2Bg+Jb/CIt73LYgZIUU4+pZ6bJB28EvEhnhdImSkEFyuawZLGY?=
 =?us-ascii?Q?wMcs2jeCm7thoWA/RDvSmUGxAadl+AwGMemKv1k2ip4UH4/O7SkbUE3yYQ0x?=
 =?us-ascii?Q?sjqPUobcXuvFxtv6i4BVcm5+dU5LHlbehLDoCRuKIczyun/7dAI5CLeilpBW?=
 =?us-ascii?Q?Z9pq/Yn+apHPBqpmZca1VYVvoHD47XafOOp6ItVuASyMRqq63tm0LupYRHAN?=
 =?us-ascii?Q?cq+zNFaKThWeRCOeq8dKR2ifjDNd6eYhlq7Rganht0z+GWMnu0thxtTTHgNJ?=
 =?us-ascii?Q?4SH8v7pWBArpPa4B5eHvX35cKwrnp3gHJvDxW8J7IPosphjtGnRj4qrGswmv?=
 =?us-ascii?Q?o6ac9pZgAfswnUXvLEgavdC2Mg6GE1N2hD+r/80G45Z6EwWqNS3yeaysZLJA?=
 =?us-ascii?Q?goNLRM3PbeaWJYAnrRpSxxV2L08RRJMc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q+mxVJ4lusvuBo7ruUExB5PAWxyhK9F9EAYWnkA27IZKBwjSdVkZD64edm+r?=
 =?us-ascii?Q?g1rvHmGgslKGfzL2JIw4l403sFuTLko3jt8pep4YQUcUpOd2cnkEV6NBLm8Q?=
 =?us-ascii?Q?t8HKSZSQGI9HE+nFM2AZiPuF8iV103WKW5UYLsLCMXNLMmIStNptMZO6ltAT?=
 =?us-ascii?Q?RkDsjOol+iieNfddHEs50iBFPbRIACI0d60PsMTkgZh+4B3bvfiCKSaMiQkB?=
 =?us-ascii?Q?Nj53aAhTrpmvbrJASgHpZi06JR80GdOlStm5E5dBBD54fhYyLEM85RUU3AU4?=
 =?us-ascii?Q?Gb0d/JKC6ES9+jYPMdD6gfyrU6RZhDJPkR64cxqdi9FED4B88ij02XaKDqxO?=
 =?us-ascii?Q?8bI4bBI7BDgdBtBJJLv11U06R+k7X2lXYIgBsgr6SzwRWQOf/prQgVzrM1Sb?=
 =?us-ascii?Q?smxkSS04O7GGtKbQKpyQQWakyZyB9gq32CKDvNk5RZNdwejyotgCJ8gIEOSe?=
 =?us-ascii?Q?3gxun5upMOrhDkEms+aWFhkSHYRtEsdS1bur4Y5O8/p4zwzZGyCXGg6DDtab?=
 =?us-ascii?Q?x9+fVj76BrS8ErWbBsh+GW10Lc9R93Zsmraw/WK3kGqZOpWP5eo05JYFazaC?=
 =?us-ascii?Q?uSCjtl4tyOWk7lPGdVBok+cmSN7r2qdQTYBnoyb9gEGEeb3cRWN3zwSe1jCr?=
 =?us-ascii?Q?ZNqtIf9DMkcVo3JQOSuySXwPY4NYJlInBeMQtIMxyTjCWzWky4s6aosVxZn3?=
 =?us-ascii?Q?MViwdssVBDB6MmvRLhUjAEfffA2kohrgU6AZMXFp6bhXynEphhFHBc90LN/p?=
 =?us-ascii?Q?oU7Iq7soL6zTeOBKLSiqWHvJRUZW36p4xsPeejYgLgsQLUHP2BAoqBPMgqee?=
 =?us-ascii?Q?efzKIluHAMBJOhNkSNrlgo9tHf1tmKkNOweQLjfPENcA+PkvwdPND+q4+cE2?=
 =?us-ascii?Q?anBceTHni3gyf36dG0OxMUMQgM/EPAOL13US5mczgri5C1x01O+p0ycsoyWB?=
 =?us-ascii?Q?ZLfVZuUY+1qv9KXn2HFFvraON4IxQIlEBLAq7tRiLFPrmQQZs4a3Rf7O0vEK?=
 =?us-ascii?Q?nVMYaZaR9cGTCKxWOC1M3TOjtFi8ZsRWTHXZSudMk1NwSOkt/lms8iCxitrF?=
 =?us-ascii?Q?F3IknP76amsLyfzFvGyiDx1SIyEkba7X3Aarc47HOjPeA5wUp29Ak96xo9v8?=
 =?us-ascii?Q?rMVRElB+w7vdfZGc65Gi2EmIKtqeioXJ5IOEFIVLQsvRm4d+IjRwIjE2h3DG?=
 =?us-ascii?Q?ycTEWIU91JKKBRph/h/gp2ZdRHhHrAXRKx6HbAxCtyT+uArUQSp4BbcqDn/N?=
 =?us-ascii?Q?/5GI5hD8YW4jVXQCmpocfBw2T3T+feBWZwqKCbsssWb6B+aRL1VGcgE0heb8?=
 =?us-ascii?Q?Mezcw0rOTOdnHli/+KRJjveicCHKkMrgC+xM2y0LioIbcPpxBH7uujASFPO6?=
 =?us-ascii?Q?PG2bLfNHt2F4Gf0E4vGlXYp2Kwd7TTDgHQiCQCOqX/mwTA7dv2jY97o688Xc?=
 =?us-ascii?Q?pZ5klCx0TQ58OEMJZvvScwz6SeAWws8IyxS80qcV9w9MTStuwzQHDTi/zjjI?=
 =?us-ascii?Q?ZxE+TBOLFkpF0uKZTqKL0qaRbh2xstXibBBAVfeeHY3u0mI9KSAq+RGfusO6?=
 =?us-ascii?Q?/DO8k1bePQ1NtYWdg1grUBYiDct5PPc/wKwJxRfH6edCYfG2gclCc6gqCMDq?=
 =?us-ascii?Q?bQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zGvVWHOkRPPX/ttLgNTV9WFHI5jcTHQ8Qd9jpG0NrgH7GqjdE6e5zhniEJsrFnQ3QoYM85isPV1SkViURWxuXmmLLTaH8uM9criyoYHzOvGqZN+YLd65gmN/XXPgqBe3eQbAnysKBWpzwH4EhTQTXSHH/2cM5Q1r/wJ6F4pmhvYZ6CzKXToB3rzfxH5K0tzp/bxqnbHTbRXt3vMyDo4DoTaL8ZMtzNQAVhb+IXEnvsSb1Tun5+7Taaaaoqbl3AwVF7zJEzTNW5l82lRnUSOkpMZHCm7/WsveWhQoRHRwGp4qNPK4uNN8Mjt0K6YrkBQsMWyEaEdrv9YATFwYCqzEaurgh6pp9O4JbEewaPzgresKBLPbUqmdaPleiugOsWiYm5CtrniXClgkfQFcLt31cHnqUiRSZ5mGzXOQz1YCO/CMSvUCONq5fUJYUNntQSpddbcReALUXM/CYF/ZfC4DmNZyD3RvyvtxPXgGJ7czjX9GrZs2SXMdEbCd5IY+8cBjQI5C7Zds/UQTFl/Xv6PewTSwkyKhGBecEGGfRsR0x7e0t4CAZCRzHa6sxHo0XJEO+rAc+xXqblsUCrUV+MLP9ilAdJUk18B9JAUArN2pNGY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c8db2d1-c02b-438c-8b92-08de15966810
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 20:21:27.0615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: edpybpoS1X1+UxuKaXXvtk6WGkxkPPGG+p3PV5RrHHBhO5CgzAyjTmG5ztmlAil0MNcTLzbizDpbhWv9rXBdvw1q8M4rB98MWHzYuD5hVdU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF1A29160CF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_08,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510270187
X-Proofpoint-GUID: Ye1wZq7eT5EFM2YE8ZbKZA1pIF42Zddg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1MSBTYWx0ZWRfX8iJ78R743X79
 zlpjGHcCHWpKabSAygIHHFKSuTAtNsXX3G0qsEqFGeME4TYv69yNkC8MANRyYoTVk+5cUpwOA16
 fS16UK3blKmJVtKO9r8cH03k3/hAt/45fJOs50rhwlTK9WhaCgAFoI3f6waaJpDzSjv+0Ibmu69
 i0+VCz+bauLoimu6z3GQ8xgkjEOf5zv2EAC/0B3iX2tsQdiYaZntnP1w8ZP0849BNIa+1J55ePU
 74LV1AvB76wk16i999qlSEMdlSe0XAOzaPTZUqpoBzp2Es/eMa/ZV89F8nOmAyxnbruHfhbkB7k
 ey1Un99Sr3cySwj4H7897MpZP3u7JTLC9VYEchcfyrSMXFHTCBrVcoBSsmWOoHzIhmfcJIzcF2M
 ykwMMAL36selGCHmwE+vVyFaEpvhFg==
X-Authority-Analysis: v=2.4 cv=Xe+EDY55 c=1 sm=1 tr=0 ts=68ffd44f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=zd2uoN0lAAAA:8
 a=EaYD0BI2-7KjZKhOlH0A:9
X-Proofpoint-ORIG-GUID: Ye1wZq7eT5EFM2YE8ZbKZA1pIF42Zddg
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7FB9140012
X-Stat-Signature: 4qe9hi8cc5qoxomzpo151rzwx51iktm7
X-Rspam-User: 
X-HE-Tag: 1761596505-15874
X-HE-Meta: U2FsdGVkX18bZAeHl0siOAa7jBfzryg9dl+Jk/rR2EMUwjhlUKlXYxCt7/gNGO1DupXCSJ2qfhYW4yGu3+7d+IPRIUfy8MPrqwEny6D2kpdEBEwgh7OebTN6rNDQnZNz4kOnJf6kptPP8zJeMpKfYJpGdvEfzpDbkd0D+Za/x8sqenzAxsJ4gcFj1l5qeFVVd+UK7OY247ZtQ892b9O4xkZydmm1eTjCmVFQIp1b4CbctkqwnDX/8T1LbJUttxsVS19OezlN4p155Uy80fEBUjDVdahU3hCEGo9saVX6sjLu5/65BbKirttZWzIiplmkJnWdoCDK3w38CImWOkyb3WR0vZuZYBMkgnm8E43wUH8ZgzKfSsW/zl5uik4fqWw283QonDTbcP5sF2wfBNprEsvthShFhk9BLLiUOTbhg9+PM1kIeOMwCu+SkSw3Xbnqp4Zk7ak5U9WyLwfTV3bIz0X6A+VF0LzsD+vMmdqeFqa4S+KW8ZVL7l3Ma+A5BcDthg4LJ5B7d9/BxMLVFzyqSImhe/s0/rJ0Z0xf5rucc7B9q59j867KlTsWk3i1HDW5CQe7dADEcZaYYHhsHpLxSJL6InCPgkFYIlCQJ+JQmNKCXIVrs/A7riV4zTO6f2Lc0df4+r2lEcoxcr6mXSTVN6rDeLXWH9YPnCJI+nSHe+066B+119swMQjMUhnilxXtzbWl3/GONh5A6iKOjA4hM3ZFcIDFaDm64b4UWBAk773OEokLOvNNiT/oj0efigPmzxgadGARm9wWFVn9iQ0kH/OBu2uI4Q/pM4ODMzUBgWzb2qtZjqVUl+qB7z+X8Vmv/tsLZXxBOoEzi7OXzByWxCdoU6yjnjqpHpP9MH/K9LAegoNgmCaW/Uil+GB+stVLdQlAgkFpTzXwFgyXM5LzOBE0igJ9iGC882ksG7wbLKvjaepH1fvmiNSGdZquswU+GVolKXalHgtZAeGJjjc
 t6yIxTaU
 IJsdSEDnQu/mLrxLUatrDP+pQFWQqL0H5h+aGN+ElU2enjopFLsGSCzOd82BogCyiRThfOuCufv5CiRdnAW6n0mNEupBT8BCZmUkX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_zero_user() does straight zeroing without caring about
temporal locality for caches.

This replaced commit c6ddfb6c5890 ("mm, clear_huge_page: move order
algorithm into a separate function") where we cleared a page at a
time converging to the faulting page from the left and the right.

To retain limited temporal locality, split the clearing in three
parts: the faulting page and its immediate neighbourhood, and, the
remaining regions on the left and the right. The local neighbourhood
will be cleared last.
Do this only when zeroing small folios (< MAX_ORDER_NR_PAGES) since
there isn't much expectation of cache locality for large folios.

Performance
===

AMD Genoa (EPYC 9J14, cpus=2 sockets * 96 cores * 2 threads,
  memory=2.2 TB, L1d= 16K/thread, L2=512K/thread, L3=2MB/thread)

anon-w-seq (vm-scalability):
                            stime                  utime

  page-at-a-time      1654.63 ( +- 3.84% )     811.00 ( +- 3.84% )
  contiguous clearing 1602.86 ( +- 3.00% )     970.75 ( +- 4.68% )
  neighbourhood-last  1630.32 ( +- 2.73% )     886.37 ( +- 5.19% )

Both stime and utime respond in expected ways. stime drops for both
contiguous clearing (-3.14%) and neighbourhood-last (-1.46%)
approaches. However, utime increases for both contiguous clearing
(+19.7%) and neighbourhood-last (+9.28%).

In part this is because anon-w-seq runs with 384 processes zeroing
anonymously mapped memory which they then access sequentially. As
such this is a likely uncommon pattern where the memory bandwidth
is saturated while also being cache limited because we access the
entire region.

Kernel make workload (make -j 12 bzImage):

                            stime                  utime

  page-at-a-time       138.16 ( +- 0.31% )    1015.11 ( +- 0.05% )
  contiguous clearing  133.42 ( +- 0.90% )    1013.49 ( +- 0.05% )
  neighbourhood-last   131.20 ( +- 0.76% )    1011.36 ( +- 0.07% )

For make the utime stays relatively flat with an up to 4.9% improvement
in the stime.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 mm/memory.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 7781b2aa18a8..53a10c06a26d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7171,13 +7171,53 @@ static void clear_contig_highpages(struct page *page, unsigned long addr,
  *
  * Uses architectural support for clear_pages() to zero page extents
  * instead of clearing page-at-a-time.
+ *
+ * Clearing of small folios (< MAX_ORDER_NR_PAGES) is split in three parts:
+ * pages in the immediate locality of the faulting page, and its left, right
+ * regions; the local neighbourhood cleared last in order to keep cache
+ * lines of the target region hot.
+ *
+ * For larger folios we assume that there is no expectation of cache locality
+ * and just do a straight zero.
  */
 void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 {
 	unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
+	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
+	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
+	const int width = 2; /* number of pages cleared last on either side */
+	struct range r[3];
+	int i;
 
-	clear_contig_highpages(folio_page(folio, 0),
-				base_addr, folio_nr_pages(folio));
+	if (folio_nr_pages(folio) > MAX_ORDER_NR_PAGES) {
+		clear_contig_highpages(folio_page(folio, 0),
+				       base_addr, folio_nr_pages(folio));
+		return;
+	}
+
+	/*
+	 * Faulting page and its immediate neighbourhood. Cleared at the end to
+	 * ensure it sticks around in the cache.
+	 */
+	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - width, pg.start, pg.end),
+			    clamp_t(s64, fault_idx + width, pg.start, pg.end));
+
+	/* Region to the left of the fault */
+	r[1] = DEFINE_RANGE(pg.start,
+			    clamp_t(s64, r[2].start-1, pg.start-1, r[2].start));
+
+	/* Region to the right of the fault: always valid for the common fault_idx=0 case. */
+	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end+1, r[2].end, pg.end+1),
+			    pg.end);
+
+	for (i = 0; i <= 2; i++) {
+		unsigned int npages = range_len(&r[i]);
+		struct page *page = folio_page(folio, r[i].start);
+		unsigned long addr = base_addr + folio_page_idx(folio, page) * PAGE_SIZE;
+
+		if (npages > 0)
+			clear_contig_highpages(page, addr, npages);
+	}
 }
 
 static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
-- 
2.43.5


