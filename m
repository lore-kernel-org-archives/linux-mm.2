Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C1D1CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A2868E002D; Fri, 12 Sep 2025 06:20:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77A3F8E002C; Fri, 12 Sep 2025 06:20:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668DF8E002D; Fri, 12 Sep 2025 06:20:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52FF78E002C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:20:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1299B11AC81
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:20:38 +0000 (UTC)
X-FDA: 83880204156.01.F6E3C88
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 79C50C0004
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:20:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XVCUe9v1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=q4rkuLio;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757672434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYg5F1n79GQDiyT7SVP4kzR3ae0VUUjqngJEVobUius=;
	b=VJYftsJZC9Lbce8i8wh2zk3uITVvBWKxvZwiED9EuAJ6ttiWp4nd4ZTRtnm/zw2Gi7hQVh
	6VqH2RQ50WIMoNC3HLYDDfNF6TZZLi91+8RN90ORfhojmJ1LOpy0lKuRJzOtGFAFguRFL3
	Ribji8kbjkI2ZdSmSESIJZcQ37a3r+w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757672434; a=rsa-sha256;
	cv=pass;
	b=vr4Bw7p4VV5HhXqYlKUL1++AWAbwiwGw55cvtiUIVR5GvtD/6lLOUqTgtNyZEN6NGL9jeu
	cNxbwImutucDBKg84EP0gdRs1MWvUmNoCDMS7FX7zp6DrHoe5fUxGCa5V+47BFCj0TKtxo
	c50eb7f//hMSvmN4bh2HliPsuMep8no=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XVCUe9v1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=q4rkuLio;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C1uPVe022741;
	Fri, 12 Sep 2025 10:20:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=kYg5F1n79GQDiyT7SV
	P4kzR3ae0VUUjqngJEVobUius=; b=XVCUe9v1ZHLGwXTnDJylknCYuwr475qkuU
	B5UP7LoZTMdVC2fgK1PfT1FNVjE7V5BtyQpG/F6yvtGpOLSPAVE0RkAF48TtBWVY
	s83hDj/xA4t2BmznvXUNm8jCikENfjekV2NwWidPVcZpsr73ex47I7UsJ43ZQ+7Z
	o5bp5s6K+xE33zYrGplLCUhism46pf07nL1qJjegpDl3ryFkIwLa4inlc/bW3wvg
	9Qv2h2Ce8rkI9HD3dvmS+mYb3yPl7Zs/PawottPv7AAD13HbTuKCNIsiDIBqMpQz
	qLhYdpawrjuNTFLW46nLkG0rxFJD/8xi5f8q6DEx34xslA0PnT4w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921pefyrr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 10:20:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58C9AHnx026171;
	Fri, 12 Sep 2025 10:20:25 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012051.outbound.protection.outlook.com [52.101.43.51])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bddqp9k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 10:20:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DyNg2jxGIhpuz3qzmvQEysLRrzpXAV+QzAuMbfk4xIgUOD66/nKwKaaXk63GIB4gjcHjuK47Dn/jBtbVJrRiYqUE3ZtSxpnvq+CXgukoLjQVp9+FeFg1tIEeD4pdIZ/sRFVZUfAX00anu/pqykv2Ryg8VJS31B2axnj1PO5qeUA+644E+Y6KCguwWltGL86XhpgewO++0pTm8Sq+K8IDoWiAz1mKjFL64dKNT6X4w4B/kKiEFHoJDp+MPaXaAqT8i9QBRE7bC1kHSsjbavCNSBwULv9O4LMr0/3eaXOSM7q/CU0tfCyEl6HH4yHgsEsa8DSYsOpW4VMnPwEwXF1zfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kYg5F1n79GQDiyT7SVP4kzR3ae0VUUjqngJEVobUius=;
 b=Kckw5X2NWQ1daadT/Kktc1Lu9T2snXcaKsGjjULtLKVO+olKGFfMBdDgQWRhKBgTr2BZ6S1ZwT7JGLOCrE+8msPuxXyr+CbTylzP448Vtxh8vGtPcsJqL/avWWL7H9gsPKarQzxaAisUHVUIbRiCUfYtyJhLM08Ba1IetijT9iavG7xv91gShEQoK5EnafojayYwQiK3tRFZ4SqhrFN7CEkEBDo61DZSVirLhJuzNvtyy+UwXgYE7d+zoojabi0xuysGjd1MrcjEDL+zCY5Fcpp5gf5xs10xBQ9nTEzcPV182vzOopcDCEFFhKNSRIMOYGEwrzPKyGX6B5SnkKtizQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kYg5F1n79GQDiyT7SVP4kzR3ae0VUUjqngJEVobUius=;
 b=q4rkuLioAP7BanWJqWgUmT0HhWolW6q9V8p0YMc3W42SL3gYl4hzd3zLyLnRLR+3vetnjfN811OTp2kXwU155+wH1UJn3dfw1exo2umXLvuS1UyB4BLP5AE+9qGACyZc2tJjDLDYeE+iOSU8EcqGenik4AYWvEpUUq6Vs2RNqUQ=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV3PR10MB7793.namprd10.prod.outlook.com (2603:10b6:408:1b8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 10:20:21 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 10:20:20 +0000
Date: Fri, 12 Sep 2025 19:20:11 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] slab: wrap debug slab validation in
 validate_slab_ptr()
Message-ID: <aMPz20n2vr0xQJeG@hyeyoo>
References: <20250911-slub-slab-validation-v1-0-8b67eb3b3dc5@suse.cz>
 <20250911-slub-slab-validation-v1-2-8b67eb3b3dc5@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911-slub-slab-validation-v1-2-8b67eb3b3dc5@suse.cz>
X-ClientProxiedBy: SE2P216CA0023.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:114::12) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV3PR10MB7793:EE_
X-MS-Office365-Filtering-Correlation-Id: d074ee43-c50e-4212-6b63-08ddf1e5fa22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PMi6gyIGKUZRfjlaVLHhScbG95NMjiobmlSF1VoEGTqVfA/DODEBRPBfp/7b?=
 =?us-ascii?Q?5z0qkWB7JKQVlS8+YNpmfckmTP3vfTGTNQvrdAUr7eRp3OxCxsxYLEma4bUf?=
 =?us-ascii?Q?8bs9+clHd4fGI47SXOVuh1qV1UKES3Yq/HncV3aVxVFoX2LbeLc62Nz6WghY?=
 =?us-ascii?Q?N4t62yKgnxa2DqlhIkZuy7GIw6EqYegSk4nDUyx680+Z/T49tlc+CpPKNpdP?=
 =?us-ascii?Q?UsxxFsRpsrkarl/WrXJJzKPql0+Ju+LxJ8hlEG8J1WxocBiCzI1PK4Slg0n5?=
 =?us-ascii?Q?EkNP+nEhW4LaqEJaKvV3jhHhxiISUsIF1TDRC/kW7ZTfRgh+4qYROhbyw4my?=
 =?us-ascii?Q?gA9aSQFTpnjZ5yMj3SnFIqEJY5inViivHoBo/I8pbYrN9zsAeJcyCzQvaFly?=
 =?us-ascii?Q?4e6747AEEfkTHGLLHGsmm3DzlItBa89ypmer2yqnEe5flS4Vp/dy2j/1637j?=
 =?us-ascii?Q?bNLF34+uxi4VgbQLBkWBgr55siUz+j2YWu4rSk0K669J/H0+cEFBcFTJLgIk?=
 =?us-ascii?Q?tuAAIoCE967b39ob4xFKUb7NGoFoLBG4kB5azoZH130/JjPdey8XOrHeboex?=
 =?us-ascii?Q?NdbbaInvUEmYB7Tj/IQe/laR8UMDVndyPULUxu5950lKhww51RLoDzKijAfA?=
 =?us-ascii?Q?JO5lvDtj3BoutAB9gYRsvn93tTHaZkYeEdKDiqV9HqZVkAgcuBaii184/jU1?=
 =?us-ascii?Q?pKIyEEQo8KxabrrgVLTi/GZy/GBE9/V89aVNollhQed8A+g2ZnrsdcrKWYyr?=
 =?us-ascii?Q?I4tzHI8SRQnDQZSk0TRGsKoOs2R1uf74/jRdtQH87OypvEuhNFrtWy8DPGMJ?=
 =?us-ascii?Q?1K0nYiU/5FxWCbycqnRfiWVl2pWJukoNPbusImUWVnxB/MTWL8JT76NLg1rE?=
 =?us-ascii?Q?E7wLnQXA1u8MXjl0C6GMk7GSovCkHTOtSJFBAZ5urQjHJbjZehZrgZeN/wQQ?=
 =?us-ascii?Q?OZTjr99d9HWLH72rD9PFJYirwpMNnsWgHrMokbVFCsdDjy59iWCBYPV55hNG?=
 =?us-ascii?Q?CvknQ6x/Fbi5j/wKEnqfScHAraxUPBD1xUuWGK0TKxB6G9CDMDkQOWfqwX/E?=
 =?us-ascii?Q?GxncfFD8966pkqnKJL1UKyf3IqBReyXjBjj8FyY1sSWR5p46XSZcDSsqdOq3?=
 =?us-ascii?Q?+SwxEOwhm96FHUDLmKBQ4cP8gMGJnqydG9GFoqhAKHTc/V1YkjZj/1bfkFmk?=
 =?us-ascii?Q?p6HHkcYKL7dCywKdOQXkJsrTEy2nwGqm0xdGZUJ6Gr5c+9nWb//zdrK03K8t?=
 =?us-ascii?Q?yw+ipBMRgWMHFY1j4TvdG9svzlkYbWW4xO0w/D9F7kuPBLdsejThIgJkqf0A?=
 =?us-ascii?Q?0tElnTpA7l28gH5h9ufIErA00HjGPpsIGFrpT3dPRYnD2sqoQgt4d1BuRSbB?=
 =?us-ascii?Q?HjkCHHR5NGOIbIMm7mN9Ne3nwK85S2JhVJDoysIgrNqBlaa7OIDBqCHqZi4a?=
 =?us-ascii?Q?s5jEyYgDj6c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nlBY+byvCX2dZGhZ+Qod82ZHisLkJRIcnW3tM9Nggk/7AoYwLqSdwXxoRuPN?=
 =?us-ascii?Q?7ifwjHLvia12RabGZnZtSSbwP1TOrhF26StZ0xG44Z75qhiQ/JeSLBpB75vc?=
 =?us-ascii?Q?O37a9i3kfcNLRhQZDQf5JfUYeWjYALl+I5WYzHEHezPgxIIPDelQ3QmtxYY5?=
 =?us-ascii?Q?nUMcr2M6a/tZuHBwdkKdTBLJkq2rCcjXL7J+hkQ6HRw9QEy2Rr0oNwNA4Zwk?=
 =?us-ascii?Q?K1AhfyDVVvNLAdDvIGicMCA+OfTw4OpfI2mJ4oPBhObulblU9mUa2JbKgp1A?=
 =?us-ascii?Q?sWPjNVZ8epM8EOcmK1aaOfXOCqslCtTObuTiMcHz48P8WyocUDPyP+fqaHkx?=
 =?us-ascii?Q?gD0fzW1fuIrIBF4kvKwCAqRMSl1JI0HrLh0qwDhr6xc9tJQ0ubY3pEynqxRf?=
 =?us-ascii?Q?ENKffyd0BWM6VQ+Cg48N6X88yPcV4Ft+En3G9w2o9uLcULmMe2RSm+zCvS/b?=
 =?us-ascii?Q?2yfMYmIc8kvdQYjiqKqjzNaI85NLzMR1ACxDuQhzuhHqvYQpaV9vb3oE9pAl?=
 =?us-ascii?Q?+H6bV/swcokE7fv8Y096GDVs47LWdYrAtd12pbyq+thHWs2UzkO1QJM/FoPd?=
 =?us-ascii?Q?le/MIxRIQjiFlD6LZn58K8IamHTMeiZCsBV91XNSXdMJ1sExsH9TOiQqB+CU?=
 =?us-ascii?Q?JdJq2o0MmJ2FQnmTMYwTSGAipKbIBmKgINdXiR0Lv5h+uE9RcQU2uJRPIqot?=
 =?us-ascii?Q?K47UYVW66lZVGcKKqf2SFV8U4OW5Rnc3MQiuZulrD2o6gPzU3s0mK00TkPg+?=
 =?us-ascii?Q?/nhtmluQe83gDXuzZcyJ/U0QK5nwoKrNsSrOxUfUfMLGxZfEPB6W6ZtyQ/3l?=
 =?us-ascii?Q?dWaUwRCWJhW2quh8v1tb/07ApE8GP3HCeLazeO+tGkdt5o3NZ6rpJaAjEXiV?=
 =?us-ascii?Q?B1qlhSYUAsl90Inwq4QMufQNml6rELlgdUNuziSsSvXtZwkr3kw7cyvv6y8K?=
 =?us-ascii?Q?3jVsG0VjZbQuX7ceAThGgr5r8uE+sLUdHNHLPrC83KSZMuQxcm8Qw6uf/dU/?=
 =?us-ascii?Q?jQEe+sxEoQbh//5k6/gKu4H2jWJcStJGHPc76ImDdZ8dvWvfqagZCCJ4kqdH?=
 =?us-ascii?Q?/Kc8PML6gwCh+62XEWb7gd/c6RjSYp6P7IIWZ2E1qKIuiM6v52GPAgmFOgCY?=
 =?us-ascii?Q?knNDT7IOAmyv4X6BkTzSoT6xkfiLlCDtTkTIUEtwIEPQ44yuoPWDO4DqkkU/?=
 =?us-ascii?Q?JzhqWLVuYZVaROzcyA9d8cRmN8sR5nxWx0mLMpoSsdz62aKxBntM1gVe1qh7?=
 =?us-ascii?Q?Qpcr41JEzwgZ315MCYUV/qp9TebZrLkAUdy8dwRS5/ybdlMu4YiVHPUXF0+C?=
 =?us-ascii?Q?uijNflJDN1U+AFypGxavp2Kq4DQfJNdrW6aM6fxnfA4jncJx0ELo8qCI/IMv?=
 =?us-ascii?Q?CIknwKUHkSzQkCcPRI8yYerdZ7tqtPva6Wk8y+jWVJDAPl/Kdk3YPrP7T5/5?=
 =?us-ascii?Q?AcCW4RL9y5YJLlCCSg/Fm2R2nyvZxvKqavxX4mXI7D6kl9psoBWuFVGUpk1S?=
 =?us-ascii?Q?H7RhDLpw+dbF5J/dgwAACuOI9/pEiVQEr+LWdjQRZga/MnUD7exMMvHs/xox?=
 =?us-ascii?Q?lrrDwmRVmAN5cncuVKomapYBtMmAwlit93q40lAH?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0RJ4QUIeDgvZpHx3knZQ4oYLLGBwn6IygG9rYc8Sq/I3Vs3ElrGeMF4LqMvCuAek/I2QCKgrZP+mJbIU34qojbQKU/k3DsmNrU7/Hs6KHCQbni4MBubwuq/RAOkDYWDsJRalpxCjUBAor1jd7VHWwQYn0zQSIh7clX6Y7DbydBEaQ8iXoH1VnRHSNCVThLUOIXWvGslCzdDTuSYtKG3p8PML+yR4M0RymctfnaR0atbbKKZEzHLEk2ndFmfygsQSyECV02NNoNM2SP2CnKCPBlfuFopQF9cRT+ketriR49zzML06IRK8S9iLrMY4jV+zfo73l0qQiubxFW2rX4LeJLPAD1BysPjaSx0YjzKjZ1xh5r89QeYGxas9pkn8w+aD+EVsrdmjuGxccHcBGflJF2sUECLJU6sKJ0XO7oe9jzfofVNt+s5YIEzvWNO1vk37x/NGUEzjTfY9mv6ACK7fSBiRZ/AkeGA2xc3VZ+tHtYz/+bwMdzANLdWHdfas0J7YhPlRmIhLAUvQahx9abW+Gaq0pkCGwgqTecNDRTli7d9EyBRY8MKQYgGqZfy5pbnE1pA7t23Nvm01SW2/lclkNdY0/IYi7ps6LoSpbQoP5Q8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d074ee43-c50e-4212-6b63-08ddf1e5fa22
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 10:20:20.5522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j3Uc41Hh5WR+YWB4MjcnPYeSVQQeoaRQp84NUpYsehMTVdQ5wcvUv2Zyq18L1MNQdppGlhgWTcShrWR8NoCBfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7793
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509120097
X-Proofpoint-GUID: HwQSkKkxfFteBsNwIgwVBxLOCpDBtoVp
X-Proofpoint-ORIG-GUID: HwQSkKkxfFteBsNwIgwVBxLOCpDBtoVp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MiBTYWx0ZWRfX6aAjl4V/uyTc
 4v52SxjDuhJMShWS4wJ7avmp3lXlcL4GQdjAsZVUuAMX3R4dzliWHYLPCfH3zDZnmBGw0e39NPG
 llxzbvIZ0nAzIvGu1rBAOrI/Y+f10c0xeko2QmToF/iB3luXIU3n7ARXxBcCRfYEy0UWa0RRGVq
 04+i9X6MsLjy1TJYhV7+oDm1yyCXPmmL8528mExsjwGtNv0HG8XPmQCnEPhODmKl+FlD6W82vtZ
 8HnLMJxG8y+/JIO9si97KzrU6mnpt88j2jfi+nUYf4fWt9lSXf2tRWuRnxs282NEZ1O9/BTZie4
 oeRWw8H66cLG1T4P4ATvtyQIUNxKZiNCtWV8b3SAuwF4rpg6y3qB5MNW78zRh87mtPlCokSIUF6
 7wwZj0NaJ9H9du2zTTccRs4NyR3KDw==
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68c3f3ea b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=INnCg0SRCRaDPnuK5sYA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13614
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 79C50C0004
X-Stat-Signature: dwb4dkeukrshjexpupj3m1t5se1f4ut9
X-Rspam-User: 
X-HE-Tag: 1757672434-633171
X-HE-Meta: U2FsdGVkX1+r72goC+pzBWAKdBJp3jqvsfDFbQSNRcxruw3YJU340RTP4nz8MtM2CV7cOTdIGZTRXEBGe/ic81r9omuTi01TcTR49D210HQn4vTxwzKgHVylfc5I+UHjo4oO/YgZKdFBW8MK7i8mQwhUIr9ww92rSjLbSuox8X3q6fNhfvKINWkOdhlhI24GKcngh9yWlOeSzt3gyW92sJ2EbPssF9Vaxf8JWWFt3b2cyFio37ryh6wcC6OvJ3jpghXfyo2yaMPtiyNuD7rpTfH6Q4t8zqdLuOMLETKkjQnf49mSjHp3OtzRIqdmmISCg7hT6Wjk1iDvDGfqCZzYMQFRld3a+iRF6VTUJCXvthHXhkIQMO1VmtTKs+E9fCCYBz8vNAYNmBm30YuGOfrk0n8JVyR+jDV/uTjkRdeHKcr/S4PRDmKevqEwqJOAaDuWBLbSq2vP5KQhiC7yfT47bPlwvaHIU54PwygMitCibIw3jFgkE/A4dEtokS3+vIEs1hisA38LHrd2ro6n9pIo4eLVsRWZBi7R6eTtPPt2SQphN4rExkAotS9M+ntW48+bniZD/o1kWFEEeydAkrtifz3XN6kSvYhJB0IwENB+c8t6ZuxNcp9/x3RGFLKx09olMiGXxdPNwoKWYcPqo0at6ouaS7HVUBMhCyBrCiq6KD+qcnRSlupdF5Yw5lgd5U2PqYD+xgn8aR+4rmSharCw7L1g411LUC0hD5O1xYxltkIRzTYd3HqarTUabcnKkF3Ug/zkxrcCI5vQKQ32rVJulczRhjgFCMoGNeR/h4ke6lWKS+9ThLo+iJh/GP/7nnvibIlIPwfXWktLVD/K6Nk6mUX3rQwdQaeUN9/X6saCfV6eCoTBYMde4G8JEoY/g2r77oViTucWACxlXQXpVm+bHjXoWgk5w2+q/1GyCekPS+00cXAb84gVmL0ntU4s4lWEMAV8q0IRj1EwBgS5uyH
 G00Y84nl
 33FkX9IA/PD0r35Y7YKzBOmCJ5mJtBeZS54SscGcY0+4zgWukQ/l6pg1nNDH00sicQFRlzHe6umkxkwaV8YmqmQBcShYa9sN+CO1haC0no7sqmvDM/Oy4aArwHqa6ykqSNJLKPrOWLV+i8fuXatRhhdfHSD4+KLdA4r18fqda5YmzXlBaTG9TsZIfDe4TT1IHAKuHeA0ushQ+rMnXabuMqOxEznHOVv5VophdckyEMCDlT5DV866uxj+j4GQMdrf/P8aYNQQDAKVZ4fbbBA5Q52Q34ZFN42Gb/YEXBfg27Gg7nA+Qxs8cU3jOc6BMGYCKOLRMfNGOYR9wVWtmeLbXtCeLI9W3kXZ7WmF70DtEVB+dc934l7UHecAh3mc/wmx3V/SCRnXECi5wNQgmUae0KE4yBwRMb+BEhC4+ujnOKXzlYW2cbQK/3ekO3ZbsOCATlafCnH6yzhgA/bcA4cCGwGDTOsFWBWG3U1c2/pY1uqHT2kAnL8m9KUb3HkCCiEuBX3TNODzC6SEkMUV0Zc7pwJh19+oHXhJbF+90gjqMh/ADna2nzFu32OnnRowWjj9Fzwm7Ol7Rt5Wp+SLmR3EjgU+NCuQtIuiose1Mycx+S9G5CNGpJ2kUIQ/2Z1NAm6Iuy/Kj1Sk4+EKk2+T2RvWrytJdOS3IDLhr1vlK4moAa5o+/7bIc/wIUcCu3WHxsD4chDERGoKFbBqdqOSKzwoIJjlwbBdrbY5ynblWqfFRv+7TeROoLPgH8uNGc8QZm+6s/Z28yyAN90lKDAmuLdELAqRKkbljd93ivI4R0fIAerPao2dMTVwNlnkMcc7cir5hleH4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 07:02:35PM +0200, Vlastimil Babka wrote:
> This will make it clear where we currently cast struct slab to folio
> only to check the slab type, and allow to change the implementation
> later with memdesc conversion.
> 
> For now use a struct page based implementation instead of struct folio
> to be compatible with further upcoming changes.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

>  mm/slub.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 

-- 
Cheers,
Harry / Hyeonggon

