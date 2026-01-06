Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0F72CE9D42
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:05:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2623B6B0099; Tue,  6 Jan 2026 10:05:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22BFB6B009B; Tue,  6 Jan 2026 10:05:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11C96B009D; Tue,  6 Jan 2026 10:05:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DD2ED6B0099
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:05:12 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 90E4A14023E
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:05:12 +0000 (UTC)
X-FDA: 84301862064.24.5093AB9
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0687E1A0004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:05:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TuvNkF8L;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t0VeuBkb;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767711909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T0sg5P6w0GH5VxwOnRDrAYwE9uAlQP5Tzgzwm/ndR08=;
	b=xkGTVGmtY5/L8Wy7MjX0xWZFUpQHhdUR3vOt33BwLDLkB7jSPMBat8Lmrkfgxg7muC2hlU
	YAVGzqB7aU3YpfBdM0R4R9kedPYjeOKys/OqXX/4jLJt3AvVUDwWZ07YSwtk8rYK6YdYvR
	jCwvr58MQ0+lXvkrczfpkMC+o1eXTzY=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TuvNkF8L;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t0VeuBkb;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767711909; a=rsa-sha256;
	cv=pass;
	b=EvCAPbBbi60PsJCTXRGyfoSAEg1I9MsjJPjKts6iD4fVJqV7IbzwpCl1ZYyKBlrIlnY5ZF
	PeZm25+ifoiDOVZ1IxDz6cmCmtRfFLNAm9imldC+ABdYj6El4Ivv1TzlRVjU8FP0zbOf84
	PVjBuU97VUcbi59zFEDhJauQ/h8rh+I=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606DiVcW3646593;
	Tue, 6 Jan 2026 15:05:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=T0sg5P6w0GH5VxwOnRDrAYwE9uAlQP5Tzgzwm/ndR08=; b=
	TuvNkF8L0KL9JcqSAZFZND9n1Tgoj8Zn/GXGZknw+Logg5tEAQjmzcj4nHNHJLZs
	jGveC1glcKevJibDrJ4zz9rI7jBd9OMgwVFYdRRznZOoh59M762chZEQRWnV3ZT4
	KUAY0rOf65eAW9qis1xqjfZMINDu8QDpv5ZTRIpIFvvBVPn8BB3ObwVjI5UlG7Be
	7icx/nr8Lv5NrROrG9eQDc8wdCYB9j6h8YtJzoMeyB0IxIVscT2sAkfuq7VEYU/1
	LV7pmxURnh6Kr6JMxrNcYoBzzkW4mvkx3CuWjRej0gUfDuQ5cskgqbs6rYsZNKQQ
	zfR61Tq3dzXyghpIoCiE1g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh3hq83uc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 15:04:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606Eipfi020440;
	Tue, 6 Jan 2026 15:04:58 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012031.outbound.protection.outlook.com [52.101.48.31])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjjpx72-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 15:04:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JrWZ5Ts8yprx/VwutTB6vOC73dojRFkHAgSAGm6vdbKYaCrTTSgx5/JT430IJlTwaB8rPHhvZf04TDO0fDtBZfHQZ4Pq2mzwuY1oqHNO3JylkacslwIZcwUsaUcYCqKXBRPqXWKJ63GehEpYmSYkr354MjoWIPi6fwOHDD7C5oQB8MACWVCEZ/6WPqUEu4+QFvhrH7ALKl0P6qHcYV7aIITh4qd5FKz+EjaTWg7wm2M1nQo1cn85kMdUXpiKq4OaZD5kF87EbPEeayPdxlkgguNl8DWhlSm//awbaHy92o8o68GLq0yLG7HF8CkWl1DGuuwkLyyqQR7ZqWOzo7kKhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T0sg5P6w0GH5VxwOnRDrAYwE9uAlQP5Tzgzwm/ndR08=;
 b=G9Tmkir9Rd6H1kaUQefV8xzTW2KwtBLInYLERPkNeE3KOZ2hc0FunZ+bBEaXKX/0yWVaef7li67XZNxHESZtAFY5pDgQYUY2iJx7YlrqAR3g6XmniwMArJnRyCecjy/qJMUnr+bBrLLaetC5s8gCDsmUYLay/FzJsbIA6xoJ5KqdzkqOusZ1WcIIDQPQC/+ZNXEnv64JK82dnRqWNc9geqLpxRRPR1Nj4n5fBr+WTSMzyDyodv5GIbm2sy3p3nH+YarAvb97U7sZkKr46yIAZcW3d7W+jgwTKjctFIZAsZH3S+8z4FJ2QVMzJpVxKQwvUk4ICf5gV3rZqkKSrZUMpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T0sg5P6w0GH5VxwOnRDrAYwE9uAlQP5Tzgzwm/ndR08=;
 b=t0VeuBkblkwAIjeIXu1iJH/eURLRJcrfcvv6sdiD97ihNBNbTRPesJS+z1ySO5kxInDeyPK/5h7uyTx0Q4wucIPSPUF7w4nF9PgnYUNok82i9ekDLqa6dFesRzd7ji3v08DZosBVIN3newURqpfLkWac3Qt1pMEwsMuxDO7ujBg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6039.namprd10.prod.outlook.com (2603:10b6:8:b7::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1; Tue, 6 Jan 2026 15:04:53 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 15:04:53 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/8] mm/mmap_lock: add vma_is_attached() helper
Date: Tue,  6 Jan 2026 15:04:31 +0000
Message-ID: <38f916c87fb873ba8866707d51f5da8ba10c5de9.1767711638.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0525.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6039:EE_
X-MS-Office365-Filtering-Correlation-Id: 10ad7827-b9c8-493f-3d50-08de4d34f25b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D8rH3nFrKi51cTjxrHEeT/vclZjZnkWzP6zy/qFoj0S/ZEfiJfpJHh4xoAok?=
 =?us-ascii?Q?UCl/5g0Kn6RaPKSeZisrBlZ/P3tsIO859dgTKE8LQ5PMcZjqGRDBqS8wbdYI?=
 =?us-ascii?Q?iK/oT4GY3KIn0tQSL509IE1ecd/ODr2kQDPrQsC89SNogiM0xf1gacRtXv9d?=
 =?us-ascii?Q?FG4bgWLKUuvK3dqWzPvnC69GyIdVO+RiHof7615L60bugQP0xa6WRFdATlbi?=
 =?us-ascii?Q?52SLRdkN6IL1KLRLUogYRnX8bC0/ruaNlKJy2eI4H473YvDAgpCvhm+3Mo/c?=
 =?us-ascii?Q?YrVqxJQZGJsbkPjiwyC2vOSfJsGMI5nsM4bL4lKx+xkMt14Cv7BXQgU30aWL?=
 =?us-ascii?Q?+EAwdUejr2w1klOFvXvCB7pCLoP9ZRuG4LTSwK59xVmMdrZCZ+jpjh4pXe2d?=
 =?us-ascii?Q?aepk/QTCBADw6sEsCUuSFgMUXxOF7hklOyIG6xSvtFdAeh8Fqwtpz1E2oRPA?=
 =?us-ascii?Q?LzehuBnx4qYbfAqG4z1MmqBrBgJmjei0BrByffARBh1qJ30q/klfJTou3GCN?=
 =?us-ascii?Q?qUp9YdmMtVkEJzcYbV6XQ5iDDdThBmiiYeRdyfcE3MHE+IBGI6+DF1wUQrAW?=
 =?us-ascii?Q?mqEf4jN2uWLsyT4O184Psast1jHH/xzTPXl2TzF3Eo3duDGk1i0RIcRlzCMt?=
 =?us-ascii?Q?k/Bys5TLR0QMD1pxPCzCXaSBZ23fkR26YlfUyDXxzhdo+5v94VpQgawL2tDV?=
 =?us-ascii?Q?wAJvsnBRIKpFKTzGaQ/kSQDcjJF0E2fabWWUA8Blxdx8jo1e9VpOeFwcibn1?=
 =?us-ascii?Q?3O9xFmAgZbbMZdW3kW/5Se5kYVEPkGIpX1VecwVzDHI25wU5rTaUaCY94nwq?=
 =?us-ascii?Q?VpI4U/YPYoruXT2OSjEGkKCdUiTHCdGLf0cnMeBNcLW5uh99P7L4gnVKhMws?=
 =?us-ascii?Q?KGt2epps6wmQuF0utuTWDEnXkdkYlm6veLNREZi7UWNokUXGdRfTkIN9/+fn?=
 =?us-ascii?Q?eZsyhTr1fJ9e1PaCD27ro/pKi3XotoBI5Bhdlkd53ylEsmd6A5tqJ5jJwVNk?=
 =?us-ascii?Q?dGN7k+A3s9GBK+VCx9g48wUzTjg60U3uqft/Bs6DzW57rlLijISkiM2foFlo?=
 =?us-ascii?Q?4JFKMed1RYKZTTv1JEPLXxn8AX/cza/GDTQQghouH+NINiSt4MLfHLkJOWWz?=
 =?us-ascii?Q?UrTq2HdOdVp+e9wm2ZsqBoOr+ok0glIOW03soXMBXAWaw4RdOE9x/ngqWINe?=
 =?us-ascii?Q?dfWtRMqO6KF2uNvhk0oAWfdhYn/dVQBkvvCXjk7geMtQ8fDt9XsCsFVFad6I?=
 =?us-ascii?Q?yTpTcw0ZH5tZESW+9RWRMbIdfyuCznUTnuhH9Iwh9mtMgbUQpFrJfXgrcKfx?=
 =?us-ascii?Q?jvu7TfAldCE4r7Gg5tBzTC6UuDFqkkuB/LNb36WJlNbwqS8zd+/sm/1H23HP?=
 =?us-ascii?Q?A/5yVaELYnwnmffteQMvx+uu/OGWWdNxlwrqu4OCUD6ivNpDG1cCB2n6uTVm?=
 =?us-ascii?Q?eywF+4+cekpMD4ayr1985xgKipDN8/bn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mLD5HnVDAsGNAhyblW/+yESn/+5lvxUmXOtwz90v2Ryqxb5pk5/f//vrJRUv?=
 =?us-ascii?Q?HJA9IkEefqO1M/JxAEbXWqXJ5sxCbK85MtViQLZ+BAmIK6AFq8Cmf3LHx1V5?=
 =?us-ascii?Q?4S7pyPjz3vLhth9W9pps++lweG2fAb56U51G6XRa6nF91aK1eHN6iy5x9cAa?=
 =?us-ascii?Q?mKxWbcMiaisFuGRpv+yP14iU/RZZFbVyBfCv8iUENZrSKkb/4b2BcE3sum7m?=
 =?us-ascii?Q?2r5nUqXFegJbu6FQ3SxLYeCZB+ZFuSh1TkULP0g/fuhB1ujbOJZyajseLVgD?=
 =?us-ascii?Q?pgBFwcJTwZfroUId5O4yM+ScVz3uPkxQjw/meoxA9VTSDpw9r7eJsJg+m1Zs?=
 =?us-ascii?Q?TVCu2ncel6LQ88LGlP0k15ulJxr7miLWOZxpDKTONlr7gyZd77kbcnbBmTUk?=
 =?us-ascii?Q?Dzq2KUNxcdFDv2RLr1XykUqe3F1YUI42ivaudPKA1yEA8wzVrjjnxZmipsF7?=
 =?us-ascii?Q?gElTIVaJFTmprqkGrbzmoCZfUZ3hw6dVrcCmXSG4w0+HlkMNM9eGULfSJ6lK?=
 =?us-ascii?Q?BM2e1JslqdUWRKSs0L0ADr7o5rNH3p+eCmf2UgJpuxvra5VHxF4w4DUzy9kx?=
 =?us-ascii?Q?8feHarWJ2dW5v/wr4jtgdY1UhAW0cFLJ9ZN1vtbNGTLWNbbSK6eDG82HPk8t?=
 =?us-ascii?Q?8gb4jFfjGBLxP8yQsvIMrQS3OAiA05J7psh2Cgb9e1M21aKdMpnUcGPaB4hG?=
 =?us-ascii?Q?TQcrT3591GlKYuXRxufu4hMCBqXtbqLhZjEJtucRbFjkYK0eOFHLEgXLVFWg?=
 =?us-ascii?Q?oEAFkXYc6ItOGFhzyTHEKi2QvY63EemO0aqMioU+m6uorVIbD3myIPkkqOCd?=
 =?us-ascii?Q?WTfeW38L459CLGCEYg9LacrZRFOzJHIRbVmsDkoCtR38NvHS9qqDGdCBOwlf?=
 =?us-ascii?Q?1cLK1HKdNnwjrytGpYdtZeRSwARQxmFgLFBOxniKXIquTXP5FpeFPejq7RHv?=
 =?us-ascii?Q?A554/aw+SyUBoobsvNCzxPs43gdfo60y/tKKvx8zQ4A4pOVU1kvFI3IIgmiH?=
 =?us-ascii?Q?t2nRhhh4+aF5PSTDEVjPE4/0F8LK2OD8iU4VAoR/HIHUpdxsIapZ2xgavV3V?=
 =?us-ascii?Q?D3Q7td+XFaXvkW2U4ellIVkEuPR0EuO+cYXVHPmKa0jzvZVZneeiLpFQsLwt?=
 =?us-ascii?Q?yCDtuWoJbizIov/d30vSaHJykgV+QDYavYbwSxcXl8hLL4TvW9FHsPdzabWs?=
 =?us-ascii?Q?PMGZpL3FR+2I7gF6kBEGRR4tyOAmJ/sQw2XeBA6am8MzUWi7OcPJWXujPAr+?=
 =?us-ascii?Q?c+X/GkUy9aJFmVCGrPj0xYLN4zO6cqMAfDBasl+s7qn5NTDL+eyI8akE7gAN?=
 =?us-ascii?Q?nzn7Y3pmcJM2te44r4aqDqpegV62/l6emeWYq9/3euUtNjKPBOhiiUy5+6xk?=
 =?us-ascii?Q?jo2QuX1GVh9Fvcgkbu8gZfUp6FPjpwx0bGtqH8i5fufyn+sVqzb3bpWaIzml?=
 =?us-ascii?Q?7axwURtsKyzrsyzHkyp5C6ZMx4KEDvcgLb1EW+nwyzVBYsApC67fmgOCxibd?=
 =?us-ascii?Q?Ylzs5fmOvS35l0dEFkbsfVVGaCzMgZEY93swUNkUxzdRHScsfhi8EoW5NRXf?=
 =?us-ascii?Q?JFBBynRvy7rCuE07LTX7280wVakRibRhg35Qr9p1Kt+mDKbN+QicSKwO8YFn?=
 =?us-ascii?Q?Gtbb/icAvXUWDFyIf626A8qq7gV9qOUEKCtnOnt1xh7smesGWGiKbhP5HBoU?=
 =?us-ascii?Q?xBqKTSJTBYL44kb2JoQicm0cM3m22sYloVkW0OqRo3m/sbwSJUKOpAXeVcEU?=
 =?us-ascii?Q?xwMQssCczwlLDmOdhaKay6kspT9NG0M=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pa8AIZ40FSVj41aBclT5KfDtV1TIqNa4ICeifXaYX217ABUDs8Vv3fwr/lRhZVxWg7KMe6SsXGHyVS195PWlQYvVwnzGz8E+/iGKdOLFCc5+DvigM2ktoSfhE6gFFoXsYPEAwC4nqU+Q808KSaO9j5VvobGsxF99U45j4ausRHoEyDKQPFjbhiutJHPGdeti/zRU/WD8W0Ex9Freaz4hGSk5IZborY8+84ASz35YyRJ9WsWoMllXp9wkNss87bNxpOGJlG7MyXfL8d/e8MulQy42Sq4W3K4EyUgahaIVQQl2XnW+tiwwXLtwwMKintZrPLHgYXND0b/TbI2AgJjLCOSp+A5A+pc9GPvBWAcAl/19uI+qTTIl/PMnUc+RzDO38LvOKUaPK8R5LPnb6nfKw8B69aMi944Yz2BR6PlSY9thGa94vlDjXbEp6YIG9MwOApSFGluXfZ9tvMLFrkzfHE8OKSbleBh+hk8CINGgFrFboOJgQSbrT75jBRRrxcJuDpChxOw1mOJLmp1k+N0YqlYkd02hsZvXkW40cI5GZt7Gf14ZAWXabgY4Uhrc5CItgGuc0FJrSmoBfbxGnhXHih7+Twj8ou2vwVjHK3G8Fc8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ad7827-b9c8-493f-3d50-08de4d34f25b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 15:04:53.4015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6WtRxItJm6gRTesjrbNP+g79i+pA3izo7+OwdqqWdQIx1ILO5y0K+RYMzv/F51m0cwphUzEgOVdOOFjiNe92T295JrfLNP0I4JIiTzwdQJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6039
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601060131
X-Authority-Analysis: v=2.4 cv=Zvzg6t7G c=1 sm=1 tr=0 ts=695d249b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=_f7RAM-W_OM-GOxaregA:9 cc=ntf awl=host:12109
X-Proofpoint-GUID: kUiCH0J6IgYekZB5qrObU9H9l7fPtKU7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEzMSBTYWx0ZWRfX0ThoqIwcUbC4
 pUeEYJtsOOFoL0qmtdwpBiWYzCpS0qvdMRjNxvvXdhwnThDmPvx45FeND7pxzI2pspDEX3nFIeV
 KPR6gTeMcujJ3vyCcZXce0dIVN5brrBPgHYpwkBv/0XLnTVdxuZcAK4Ti0b/EHa+oxEKuWvgtMn
 e9nwLL2w3rLeckfbVX8wQ4L0lNOTmS+vc8j1l3XCKx/D+OBLIEjhL4sUKz18PEB3U14JAUokL3g
 ZPtlA/9ou/SBDA/Q6swiMiz2CM3W/wmjyQg4nLmT/RxcDzU3SQwP3gT9ld7bV8bLoiPa3XHcJ2e
 IbSQJzRPwSYBiUmoC6AlRXhYoQTQFVOqjLrxjNRbbajZ6hKeCaFmtyKU0AnPzoNl0rSRnJwRVmA
 sUFX2R89uXTVb/KYICJQ+HXRZ2lclNY0HamqOtv5t/29Togk4k0+Br9MjONuKZn/SPWjyii8ksi
 nRZeps3nJkXIzqp659oT4X0EKHroQEYTrVePzNco=
X-Proofpoint-ORIG-GUID: kUiCH0J6IgYekZB5qrObU9H9l7fPtKU7
X-Stat-Signature: t6iysxi9a3wrtxc4dd4bf1f795cttchj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0687E1A0004
X-HE-Tag: 1767711908-247394
X-HE-Meta: U2FsdGVkX18jhiGXbXB8ze3eF26q0VYOCz1oPeJe6YYZmy12mWvL3GN6MimquwA12PAgzWwOQDUsN7TRDDW4mAxKWiVy7N1vmqASbcrPUG77CXS58fp3jzp9yFaN38Wd+UxLYVn0whDjeFauPvFfZ3AryrwsEnjYXyDgISR6KU3gH/NGRu0YRJoox/VwQxIYquVBY0pLm+qpT9TUekQ4OQrUYydoWNJ9IIPLTEsLYe9pV4ToSWkT2bp36jKrd4ng0MxClaiLfUqpWkh/ptQw55d3Nf/8ePoxM9gv1agBTC+3mZUHYbJNdLdpgGiTiB3FG3JXdQO8I19o1jMg9VflSSuhane/cG1SX98MHkowuABIQ9DtEaW4wt5mjuRFF9T0wzy9tfaHlaJypTPGjgh4Ucfy6ykNOgI/AptX1S/v8Xh1jYz96P0SjnIWL8Jd+QqBTOwU+QiifICAxVUAT6WCgz/i76T0PlkrEKlFOfMYOzCApGxpM7b/5ZYqc8tTLdua1/rTpWDhrVjsYahMLwbr8WuV/crcdXlmAGuzv49ZBPy1Hlo/9ewjxArHxlWRnjhbkVP2KRkwDU2CWhZL/SjkXUrXB7zHjmMUEZrivVPLuxt6Q0OTBv7qyvA6WgFr5WCT+tg8yugx6BjYI+0xWkcL+p26gVDBYwRIWtTfzp3evlyRqhHeCWKnLaPkl1tsz3M+crw65Bmsx5ZnfqO2vUNGb1J3J870JfnQNMyQEM+ruM2ckPygEW0vIA+pR23VTQ52Krc0URL1DR8Ge4AB80LRbKSc4Qizkblt/ip0GdLnQz0+OFhrLZE+N4Bygoh/VmsPDM++oEoLLnK43Wjk5TlsbDTG4bkP5M0DXvTy+tEgCtnEgoMvoPoo583Ga/CmrTjiQktuCWh0xKuQ4i6USDzYf8ThqnvgOP84yfy/z8iLtHG9/+ekHsN78IxOFD9yo553naXW+RpwAOovoCOn6SV
 l6Z63wx1
 8m8cHfK4PnHa3hPPxNFitQKm5v7JlCXS7wsXnORDnoOB6IFLZenWDWguELz74hdKDZmEwPGayvxT5oxgm41eE+kd9LZFD8O92c/BlVd3NNKGS/7XeNcydUZzQ3iRDcbHFXjiepbkvml17IQ4loF39qPpcqGOqRXRqJvzHHOMoUNChDQdtYn1OFS8H88X6/+r7hcuO2fA6SYoee/Xz+6zd1/6evU3GAGnzPWxlK0W+1IsRNik0keOjrORPRPI73ZOBAc7Zu+Rp42tM5F+fFFlCNWGjnfUG7ZM17ciTjxRc5lz5IGmWk+jAdoFJum6XQTbwTQFkqmmmBCX1ZUtkNZM/trPXO8Eoctrjed7RJgoLpr2b6ZWngl/He1OM55nlN0lsZFbfjDzSUxkTGtN4DsTBWoIdIyr50NkDPIqY3W3mberzwWlQ7tWCS0reqSvNf8GcFlu7UTU4xbFMw0kNvEh4KKdNcCszwwAkVoHrA6ESAbrg/L64NstTLNHDGLz+eTxoQCkZF7zTHLBGoYlMF+HTiMii5kwqqRRz3sFVW4/whfuSNf04nFMbXzbKJaw41J/ah1dQqB7Ew6hooDpOUaIkhsCcatcMBpdG4BLFkLxwKqmn8H3WDQLhJsNBqv7GwLONwENGBkKTwxbWuWLJyNvjE6yY9zVhIYx3RdB/Z7g0mQEBr0QgQrspif6i29RIMX16pDyVmyVfbzu1dDABKCiDABTGmgIfd65fm7kUs8CRLA2779Xe/qaWE8p5qw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This makes it easy to explicitly check for VMA detachment, which is useful
for things like asserts.

Note that we intentionally do not allow this function to be available
should CONFIG_PER_VMA_LOCK be set - this is because vma_assert_attached()
and vma_assert_detached() are no-ops if !CONFIG_PER_VMA_LOCK, so there is
no correct state for vma_is_attached() to be in if this configuration
option is not specified.

Therefore users elsewhere must invoke this function only after checking for
CONFIG_PER_VMA_LOCK.

We rework the assert functions to utilise this.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
---
 include/linux/mmap_lock.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index d53f72dba7fe..b50416fbba20 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -251,6 +251,11 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
 		      !__is_vma_write_locked(vma, &mm_lock_seq), vma);
 }
 
+static inline bool vma_is_attached(struct vm_area_struct *vma)
+{
+	return refcount_read(&vma->vm_refcnt);
+}
+
 /*
  * WARNING: to avoid racing with vma_mark_attached()/vma_mark_detached(), these
  * assertions should be made either under mmap_write_lock or when the object
@@ -258,12 +263,12 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
  */
 static inline void vma_assert_attached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(!refcount_read(&vma->vm_refcnt));
+	WARN_ON_ONCE(!vma_is_attached(vma));
 }
 
 static inline void vma_assert_detached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(refcount_read(&vma->vm_refcnt));
+	WARN_ON_ONCE(vma_is_attached(vma));
 }
 
 static inline void vma_mark_attached(struct vm_area_struct *vma)
-- 
2.52.0


