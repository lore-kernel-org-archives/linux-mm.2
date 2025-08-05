Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CAA1C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 05:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 390118E0002; Tue,  5 Aug 2025 01:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318EE8E0001; Tue,  5 Aug 2025 01:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 192FC8E0002; Tue,  5 Aug 2025 01:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 011328E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 01:20:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 78715140E37
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 05:20:45 +0000 (UTC)
X-FDA: 83741554050.23.6BBE284
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8691C1C0003
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 05:20:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VqR0RtTm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="A2/k0fFi";
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754371242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=naZ7ilrp+7UUWwYg1gaGeEMgu8f8JaJCeQq1GIiq2xo=;
	b=ilGQQRx++vExcS8yociKHmpnoEXV7TiUYAPOy9idl9iM4TXWpkEWobPZtySt2hQwnkUPwu
	YJ/KiCgXlQK11sSExH7eehqP8g0wpRs5xtGR9qvVpW3aSiTlEhT0Dp+u5sY7QMEj4EVk5p
	kmSH07WoEjbNCx3EZnJkIC/8oK+P+bo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754371242; a=rsa-sha256;
	cv=pass;
	b=xBfQPjEHFkD5ouipSNOAi2CErM1HR1o5jdJH/LbA3E/KCsXbRI7meMKNUrsvHYQ3sUF6C4
	lE2igJWricGbZofgsLqgwWprbSp73hfL+IwSDQ0DQq5Saz4fJB42Y9llyjcPW5bwbdMF43
	sgRhJEjxzA4B94RwILHqIwV2ND6GB14=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VqR0RtTm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="A2/k0fFi";
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 574Ng9iO009948;
	Tue, 5 Aug 2025 05:20:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=naZ7ilrp+7UUWwYg1g
	aGeEMgu8f8JaJCeQq1GIiq2xo=; b=VqR0RtTmcw72Ikb6r7xtnGwIvQLA0qQ5/7
	L8CWIiHfnXwHJW3NYPOpER7zfP3vU5qDRpl7uvxNcL6YiVf2IjEmLQE6/XWtqp3d
	3rjCs8ueVaPYgxhieNuJzpfs59TZuXMNIiBqXo9juLgheh0iOyfIduYU7ZHpMSVd
	XXV7FYc7x/LwQCjOJVeAa6VldJffyjn1HISPHHo9W+VHFYrqcyqVXV6RQlAAj7s5
	xnif+kae+imXKTHYfd/CNUSSRH6uo37akKwHlR1eBrF+HIkARGvasQlNcj9pmviD
	UHAesYbgN5j+sOMsyifrr/c50SgdK3ZIGJiUDEERutcdbaeQ796g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 489994m0af-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Aug 2025 05:20:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5752QrJE032003;
	Tue, 5 Aug 2025 05:20:21 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2042.outbound.protection.outlook.com [40.107.212.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48a7jvfnn7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Aug 2025 05:20:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SGTwM/tTJ+8158DfzXpdsJKmAL0+geLKtqQpTUWHQp+H8Fm4H5QQP8Kju2BE862b0MONnnUXgHSTtxbHTCAyPxGW1pWASkPOEFNUjO1DOPbdgkOVRT8KgMclGx7cf+3pg3In2wY7EqDb5p7sqTtzJn/r4WbTBnrpepKpeUc4GqcBpNCBJuT8tC/GLTJJ932giLWKcAvlluahQn8G+uUrzhNM8IaIQKR1plfGt9Dfy1M8uJpOEg4RWMZNReqdMSgbD/RbYbCfTzT7ZVOmBmZYFwn+QmMdXiJL8n0667r6UIDOuTVUPjMy3icJ+Tb/D5Y+oKkqYahCc4hPR2peV+0EZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=naZ7ilrp+7UUWwYg1gaGeEMgu8f8JaJCeQq1GIiq2xo=;
 b=LgWTQtioPLo4G8PMYJwtbptRuCxXgbyY4+5L5Xk2DR1E8NKDwuTfSVAm9rgULkAIe4evbTuIfXLcUDvPmE2NckpRebwo9fzllpN/Gac1ypQjUQyCL0Gl+AFY9F7y66ndxZpdD0GNoAJLt6Ax6NOHYZuIeGPWobHCfNcV1Pc3IE5dE2RuA2jg+rJ19pSAxTG8lbUHiY5C98UT26Yrq8c5g2qUZEB5wKjArKbid9zDBbRYSQj0/N+2mX+0ypdeoJn/aXArzpfdknP1w/ve3n1jTh1FBQuhDn09J60YI7lAXslcWd2nqKsRVbfPFv5/fe3tWAHY5WxqpM6Rqi8MWYwALA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=naZ7ilrp+7UUWwYg1gaGeEMgu8f8JaJCeQq1GIiq2xo=;
 b=A2/k0fFik4rLUqSuY0vhMwgvXMDC74+NAnLH3LLtZE34hBMtwKlpkeI4479AKC8qhbgIr8L6CnaUjSD6DRSOIfP+19jPDPfm8CBB/ESyv3Z2FFbyqbkIVPktL9QufnL3aos2lOXVCEmmp67LpiBlnDy/P/ZIJX52a1Djv754nIE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CO6PR10MB5604.namprd10.prod.outlook.com (2603:10b6:303:14b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Tue, 5 Aug
 2025 05:20:18 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Tue, 5 Aug 2025
 05:20:18 +0000
Date: Tue, 5 Aug 2025 06:20:12 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
        "Lai, Yi" <yi1.lai@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        Tangquan Zheng <zhengtangquan@oppo.com>,
        Lance Yang <ioworker0@gmail.com>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>
Subject: Re: [PATCH] mm: Fix the race between collapse and PT_RECLAIM under
 per-vma lock
Message-ID: <50fb6942-f4b1-4f2d-a86d-dc38d3c371d0@lucifer.local>
References: <20250805035447.7958-1-21cnbao@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805035447.7958-1-21cnbao@gmail.com>
X-ClientProxiedBy: AM9P192CA0005.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CO6PR10MB5604:EE_
X-MS-Office365-Filtering-Correlation-Id: b582b349-54dd-42ee-5138-08ddd3dfc45d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jmjBCXfAcyuXQbIGVHpaqOkoEkUYDxReAt6jHzJzLbNgON+p0SCwwQXMrkn7?=
 =?us-ascii?Q?HEA8r+HEmZmfkrqQOab9/YdDnyFAA1PAujsbfVaoGwiq3SxpuZyd3Q1NyubU?=
 =?us-ascii?Q?h0galFDJ6htotAa/YU6zUCCYm/XKWGNCwp7XYsHECYD1JRoBex2J98L8q+8O?=
 =?us-ascii?Q?xehSmnN6AMAH9PI6kOnHWGirglqoDngSDSAuEKQKESH8nfRHCsxS3zxrKgkE?=
 =?us-ascii?Q?q/HI1u44pROsVraMnvNBuYav9A2KKYJXKhZJUOAmO3h8ZXYgJHkR0Dio8/+5?=
 =?us-ascii?Q?rxQJ++75c2ZJE5u/w4uZvB7Q6SUOSDV6frpviOkN8S6x2VJldGgbUNbFWEJK?=
 =?us-ascii?Q?6VGXeH3/bNiMXRByuNpms2pm7aSrlOKmRt258puz5l5JqCvfsoBDIvEZXUSA?=
 =?us-ascii?Q?VuSek6S9ADcY/9XREgJSqfqYe41OMcJKjtNc0THtvRCFP/wPOPViQWVNqeJV?=
 =?us-ascii?Q?VxGuzHho8DCv6yPujVyxcdUtb5opBCcNA3xfEV1KRLCKOr2Qo8HhuWjHeUJF?=
 =?us-ascii?Q?CIiuBjNNyen/vyv5HvjYGJ+NXXEKvMks54HNJPJhaDe/OVZMhRS+O71J14Hn?=
 =?us-ascii?Q?Z6OIis8MrlwRJkzIqx1JuGPN8UNpEr2SaKDelDkuZTFii2wrdRuRZ2NUw7/K?=
 =?us-ascii?Q?fyX8SEFSzqGWqPJS9nJOwguKB0psScwtyQYyDtg93GFeiqDkDyNE7Q/9YEg6?=
 =?us-ascii?Q?t7CjGMy+cnKhx0MLI7ETC80/Bp5Qg8CgUUeY0xn7n7+JRhUUePAFfRQZuksK?=
 =?us-ascii?Q?swLLcur8aRVcKV9gD5XgexAasCnIlU3LUH7xmnLj64A2xxpfrdc74iBoUEZl?=
 =?us-ascii?Q?frptl/LkSKCvyzyYHiSqURhBWJry3Hr8eo+rgtGRlq0TRH5d3BgfloNC1Nvj?=
 =?us-ascii?Q?EIVuxw1SBwnmWqdeiJGu8/JvgV1jCIf4kbPXNa7nlLY83m+l3Hf6hEOJFr0M?=
 =?us-ascii?Q?xDli3yq6S7oyAd5YcNMvusP/Dj/PQCixt9/psNn82ilJY4hSu9r5hUKLFhFS?=
 =?us-ascii?Q?5C1nTHV6GOtwUuKFUAYw7TtJTPJzzOMoHAQLniEUd7vRwKW2ewM7k5r+1847?=
 =?us-ascii?Q?f8uw6QNh1wA47u5V6/Us0o0KESlpnQqfTppsOon1HyVGF7Agd4bJMten8G62?=
 =?us-ascii?Q?zeLqXPmCT/4aMrHBkl8EiJSq/NAG915r1EJhLfyFsYBcf7e8/f+ZaCwhV2yM?=
 =?us-ascii?Q?Kng47blZu7dxheT8QAOQTqq62u4iphU61q32qWstZ+TXM2RkUuufpzY6VDJx?=
 =?us-ascii?Q?ZI/ZzFKa37xgDhopbCd3iQhNwAixGqQjQotsZitPwthx6XYsTG5vuEV3LbOF?=
 =?us-ascii?Q?zERQTpuGQxYlEIJm6SzS/+s8ohbgtshR2J7MyAhyWMdkNzZctLDz8fL20u5c?=
 =?us-ascii?Q?uSELHJ5v1gCJLMm+RHdNCwtpMYdJzJZ2w61T9CYfTZc0aOqYJRvKTQAu71Oe?=
 =?us-ascii?Q?sAbcBSRTCY0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uN2PWOgaj4kaQD5PgCD67N5RJISrLM1/3/hqnjDEu9Plsrcms19k5trGRsJa?=
 =?us-ascii?Q?0fonjX15yinNIU+AmGFjK0l+wcXlaNKj9bcEvN1OXT8wI1XGBRzRoo/o6kWi?=
 =?us-ascii?Q?6G2ww4B+l5lDnDZcsuHUqhVG1u2lEZ5sdWMUwJ7llOEzk/VokH7SHjpHwyCM?=
 =?us-ascii?Q?V+TiMd2L3xSN3lyEOR1kPa0JQ7n2RmAHpoIcrTBqc0HHWVHP6dUK15HRYOzh?=
 =?us-ascii?Q?tzxTC5skhMM0rfvHfK8zqtnGTVh3O+XZ1p/mOpRC8bU8r5kvmekcMTWpwOUl?=
 =?us-ascii?Q?nzxqT0aXLT88veQptggkgBiklXCGVoOPYY04CpUYm2IpWqzCQt/4OkU5081Z?=
 =?us-ascii?Q?WnN4pFmdtkGs67zJ3RY1CityXG+vzJE/P9PXJ77XiyQFQni9FZ6A6AtMSk/X?=
 =?us-ascii?Q?3ZphmY9zbq4nuNkf2BUy5m9QccTaooMcrQPkgDT99ooMpBI5ifExTagqIZ67?=
 =?us-ascii?Q?Ifw+vlxZg5Bx71yhUv5H+g9O7GoYp3vwVxfW9wzXdwF2wfGH3Ek+jcfl50KI?=
 =?us-ascii?Q?ix4pWDMxoKZFjh6K27METucNup3on8wVAY44EC1adnPycwqds3FRrlipMgje?=
 =?us-ascii?Q?KUNLKKJy/z+4GS7zvy6ROlScRb815FSGx3HvTdEFnSdxN0j9AmXhvm47kHlm?=
 =?us-ascii?Q?TviR/HPYGw7ThCWm1I71uDRFbzQtgkS1FoF/qIZ/mq7VsQ4oGwrZbu5pHsEv?=
 =?us-ascii?Q?kGcoHRKsh/314vzQUmnOEykPgW5Z/c6K2pDnw0bYTLxV1WO0pKfQfQOCwo3l?=
 =?us-ascii?Q?OSvhQK7z9wPU+GAdIaIhbVMegiJqIFbYCqmGYI/1Mt8LcB8zKT3SUyUck4/b?=
 =?us-ascii?Q?wcVmvNZbATPC9rA5RJ0n/jO0JFPEFZdkkyNoCL/eCFnXniYpG2MxPDkYsUEe?=
 =?us-ascii?Q?n4R577RHRY134EYkfXZSxaTAnUub8RIgf/Ae0FdeQOde1tZ+z1wJDCTljwN3?=
 =?us-ascii?Q?v23J/oP4GSd/WSkKyt1Vzlf3/bnf21MVEbGuFko8NIAV2lPYzI0bUGVW8POJ?=
 =?us-ascii?Q?gp+V4HF/iTxpE6TkiUjCHV/dlUUn+GmKYUMaVjL5BXTrKZ5uV6033+men2cV?=
 =?us-ascii?Q?55SIQAp+k3GuPGDoPu/te9hqpKqwFc3r1TTd1sEDqJBqJyHl9Bo0GINiCaZe?=
 =?us-ascii?Q?VIcHQWspYtO8GKVmyjxhhRWMdY+WIcIFegYOD/7D51nG1Jb9bteHf2Y1BorB?=
 =?us-ascii?Q?71Y0C02nIDiYqlH2DkDvgH1yieuwHxmXVX6ovVdrMzrV74C0kGTT9VE02Jj6?=
 =?us-ascii?Q?dG0kTC9j0MXpYFJpj5fRlTgOLBLfEhPC4VnKsj2LJs88KXgeVoMM4lfR3Ag5?=
 =?us-ascii?Q?OOkPGjubUXjH2+DPGRZOh0u3BNLmqJdHpERJAysv6SLddF6hQyrkYta1kYf3?=
 =?us-ascii?Q?IF23UfgynVTRf+R6FeXsQ7FNa2eyRgO9LZ+rD6aB8Vu6OxhJDEl9TkT0oDzZ?=
 =?us-ascii?Q?43kH/g9YzrvJwSAZDuR0BVRCFo0YWt7bfkaImIIGTRc6S2mY96c8puMZfKeu?=
 =?us-ascii?Q?9+6Qq11tSIqXXAihnYchXCjoTMlvfA+r3Z52AL7L+KznGVhDColPtubOFiky?=
 =?us-ascii?Q?WJG+yG7hSp02oO7+8GFn6TvaQwMuyVHY+5sz65U5HLVhGAggWW0GfQZcljg1?=
 =?us-ascii?Q?5Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	w0DPPvJo2jy/3tR03RLHn3d/m8lYoAiA5s2S5hK+rtLdANQ7wTvoZOdZLsIuGyq6VcrUAopPLWizqXvmIj8vLNBp/UxHkuXqrStCfM2gvgnOb3jX6zKwo1rN+x6QiQljPAQRqMZt+1eoXgC3/+AQEijft6v/9vYYHsbZqzyhTyHf6e+G0aE9X+Bf/OXNKBYftHz7NkdexEW2DCnpnH+9L79yFT69ksJItq43EueRICDy5FHP5nwPWkRW3MZvnzPnDXwzfFC+SwI9XhhGOHHNj1DVpgla0bCEWYY1FC0Nh+G+wv3XMlq+R8Z+g9lr3kK6XzcbicGgt/a9iJqbo0czSZ+LBaI3/cyuIP98bh1w8oa2nEvhHDv6wmC5G8yP7wHt1/d33Xhcjv3GwVX0aIUIf3aFiy4JTJnB2NAXOPTdpLjOrigP8ar0L6hWdu4jeg2Zhzsv3QopVf4A+ceV34O+n0UlFpglF/04OY585WWxSetJ3ENEphsxVpVx3JPe5Z9KLREYN59/ZfPoF6BhVPgqZpiZ986v43ROLtFhDxj60UWnGgABOFTdjzdaxg/GVqYB9OlUYoaaSF/631dcfzjcZppMTIs/XiV3xCB+yw6CFeM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b582b349-54dd-42ee-5138-08ddd3dfc45d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 05:20:18.3288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fhNHo6qbi48xA4J7G6VjNOF7RZXVsnyds6hSpEQXHGofFbdeotp5TaVq4RentXTK/nsdID1ePHYKQ3QLnQSQPktUDJxpETg/ny9W/Jq/Mv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5604
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_01,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508050037
X-Proofpoint-ORIG-GUID: 5ksvQhjgdgjKs9n6viIcmBTtcBNWfY6C
X-Authority-Analysis: v=2.4 cv=HY4UTjE8 c=1 sm=1 tr=0 ts=68919496 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=A2pY-5KRAAAA:8
 a=QyXUC8HyAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=968KyxNXAAAA:8
 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=Ikd4Dj_1AAAA:8 a=SRrdq9N9AAAA:8
 a=7CQSdrXTAAAA:8 a=XrejeW6Qvn4QPxMVHWUA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDAzNiBTYWx0ZWRfX1m7YvzW8Q/Nr
 viPNETws4YSoFGMk33+vt766yl5w48oUW/X4aMvBewqj825BzAEegh9GS9ZTeBAt+NkaBndrP7q
 Ru+EzAUt6+Xv+IE9KGFJqFpP4FFRDZzXJ7TP5/iCDfEOnWHooPFT0zeKFNpPzxSMcAnNCfFXok8
 Lgba6/ErlmH9UnyZ/ILS6H49dCZJ9KTTO76VXQ/zVAC59ly/9DbkJ1StDFoeA/c+njes5wRiIRJ
 Kb71UJlNeS8/5ElOumBQK/pHeWHKeCMk/7CU3kzeDMLVLxixHC5Q3JGxQt13KUplHwu4pTmyvUE
 1rWPVMOwtt8xnnJtis7qLOnQiykbdSUQfyXT/Nh9M0XbMTGpclxK08mEoXniGAJsnkJKLC9LuLZ
 FiSXu996vtrpmKs4DvDBGkkXePCo3UGoIPAIN2yzVaIiWbAV+ra9CV666rhQl+72X6ySYpWt
X-Proofpoint-GUID: 5ksvQhjgdgjKs9n6viIcmBTtcBNWfY6C
X-Rspamd-Queue-Id: 8691C1C0003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: atxrdfpzom85zgso17mp4jyhyfyq5ywb
X-HE-Tag: 1754371241-548117
X-HE-Meta: U2FsdGVkX1+HLl4rlEDI51iW4FPErDAqZPpwMCCIxgdkcvLpnkUxEnwe8XsoZoL2pS8nTAj9fnhCT4O9q7kNrAeo8ZV/V56UAyKpZwQnE1q7LMJhmvnYbwJcPa+qarDYHQiGW4XzH4JCZFIlnVPlh6EDFUE2XcSjDQxn+syDXiApnTk5KX0lOi2aCQBD1RC8suP0+MWrNIHvY0kKFPEy90O/OWRKfKqS+/OoaRxVCHdJyc63b9z+LEq5fSP3nY9MJNsQjb89Oao32H3smHulRXufYosBbFcEcwwfxESewDl0aI/nLlrTcg/uAbqcXxVw9akNy0GhpmyBdQjG1T/9W70Lv/zybj5aEG3kujHjxXoajjKFDsBwhFMWocv7hBckQX/MepRfxTX12cXJ22gTDn8u9XANp6j0p8W6Pnb3BQSRbYgkCoXxvJEHZGUXrOjduAvq7Vl84C6sU3/d7Q9Byxbc+zd9gaLy5TtKwa/0RfABIOwCDqZnV/S1LTppfb4Gr8+u3WhLDpCa1qeGbsAK6XFW5nbwlhcoMI7E7CwEBUAz/5ecEpjZSgB8xZMqcCks9pf6uR8rwjeok7Kp9ze1PVjNZRortsuQCDHls17ghx+wHEOone5i4zdNYstbrYykFLlmzljWjGtqQDXpX0L3Y/W0OQwfVAdMKZKhd4uUia27HVVYG0ZGq837/inIe7lTsqq+QqLKzY83H1tZ+IfNegWmwzVQwfKqPTwk/3Wq+U7HjdKReIe51fvCU8BqEwAVM48mGG532+JAenEnJu4wh309jvjv++KPZKnEepzC0Gbfjd8Z52MWhxMcpD24snI1/pehPbzF0XDr2Movt15zNd9zN3hbKYUuG2s5eLIuaqZX7PDJ69TNXpPLOGk3E7Gqi17S5XTaTwRt+VZyh4vN02DIfHBhpnS+/BwhxXo2LBKGd+9sJLVyedK6kHavC8DuMplF//lGjKVvgo1XBOQ
 pKHBP2EK
 olZQpk8PKPBro+RQDwKnk3TK/VN8Bags3Zc/2S51O7Za9+ckeqfDhU5TlSh+Lm7HRgHKDBnODc7F0br0Kf/f7Ns+WlcUz1Ttnb8baXb3mA0FINzSalAhoxqB6Y4cQBnAgUaK7jT7V6N41NO3hFtomYP+RHj0VgqekBTJzwKqlnV/yvR9A1AAODBYsia1Gu6FcQZamKwIlnGAeUz1vtRc7HQhKKC+NprviXA1aF9fahBFXkOWFNttJdXtXv3/fZUIeRpO/dU6a+wxNt6BHTh6fh+DuJReRmzFWyj0vGriJVBKERa/dybzm+VN96Zg/SuoKoLC93eN2/nAwJF0mBdWobK1HEyrmLOz2kwkl0eFqtuX/rLWGtu8jfVfDS1QGy2oKqsWXiQQfbeRHsDgPJ2N5X5WcR4dsEdvzYSkE5GATTKxmQNiDXk6ZhSi8epxjZVrnKkA+yr75jmlPL87gzxcnOOIOLDGUL0Dg7wSwiyk2xJ8f4s62H8Rb7jHu66zy0W8CsbC6/J0ZZaWgGkQQW4BF6v/0kYTn1zni9ccxboDxW1l6A9bxmRuMPxwT5BUfP+WDnsVt8OkW9LMKUjTWuxdZElTpEDpgYC0rXsQjcl9JbgaDGgnimk2oPlOCLJQPmPPfyHELECHm+XXS5k+mr2dUBcptQzKgnJhucwRv/PpKK/LWAOpbb7eSQXYOq/p1SfRmyq5WIdxBqcgcV2a2ndxVxBZC1IrxNl+G9mPadsjh4OqjqgNIzIT+/CqaC9zeBFhPitsfxTmF9YUg+VyYc+Rr6iCChe15kwi0z48FkSKJiMJNjTZKZRmftDqQ5aCAph+y4YDtSiiaJp0htjg4dEwE3ckwMOXiakPUBsiIkdaWnCiAs77FMo2frT3FGtPm1oa7gFTDlhFbTm8kC4CTEwsovynOMu1PpNeoZYw2SRlv8h5Wjc4A/dxGgbc/MfAl0KQgPvIJ6RVksnDNxDqikj3Xgn4eADgm
 fD9eyql/
 dkyU7/QGPlbRWUJ0mXt2VsuNBLhJDVFCZKEDS6BGZ4fOpCHA5sKgSMdQ4q86smNf0wfNJxURrR5KWWKPZ780B6NzqzzHXQzDzfJA7sAbIkE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew - to be clear, we need this as a hotfix for 6.17, as this is a known bug
in rc1 right now.

On Tue, Aug 05, 2025 at 11:54:47AM +0800, Barry Song wrote:
> From: Barry Song <v-songbaohua@oppo.com>
>
> The check_pmd_still_valid() call during collapse is currently only
> protected by the mmap_lock in write mode, which was sufficient when
> pt_reclaim always ran under mmap_lock in read mode. However, since
> madvise_dontneed can now execute under a per-VMA lock, this assumption
> is no longer valid. As a result, a race condition can occur between
> collapse and PT_RECLAIM, potentially leading to a kernel panic.
>
>  [   38.151897] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASI
>  [   38.153519] KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
>  [   38.154605] CPU: 0 UID: 0 PID: 721 Comm: repro Not tainted 6.16.0-next-20250801-next-2025080 #1 PREEMPT(voluntary)
>  [   38.155929] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org4
>  [   38.157418] RIP: 0010:kasan_byte_accessible+0x15/0x30
>  [   38.158125] Code: 03 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 48 b8 00 00 00 00 00 fc0
>  [   38.160461] RSP: 0018:ffff88800feef678 EFLAGS: 00010286
>  [   38.161220] RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 1ffffffff0dde60c
>  [   38.162232] RDX: 0000000000000000 RSI: ffffffff85da1e18 RDI: dffffc0000000003
>  [   38.163176] RBP: ffff88800feef698 R08: 0000000000000001 R09: 0000000000000000
>  [   38.164195] R10: 0000000000000000 R11: ffff888016a8ba58 R12: 0000000000000018
>  [   38.165189] R13: 0000000000000018 R14: ffffffff85da1e18 R15: 0000000000000000
>  [   38.166100] FS:  0000000000000000(0000) GS:ffff8880e3b40000(0000) knlGS:0000000000000000
>  [   38.167137] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  [   38.167891] CR2: 00007f97fadfe504 CR3: 0000000007088005 CR4: 0000000000770ef0
>  [   38.168812] PKRU: 55555554
>  [   38.169275] Call Trace:
>  [   38.169647]  <TASK>
>  [   38.169975]  ? __kasan_check_byte+0x19/0x50
>  [   38.170581]  lock_acquire+0xea/0x310
>  [   38.171083]  ? rcu_is_watching+0x19/0xc0
>  [   38.171615]  ? __sanitizer_cov_trace_const_cmp4+0x1a/0x20
>  [   38.172343]  ? __sanitizer_cov_trace_const_cmp8+0x1c/0x30
>  [   38.173130]  _raw_spin_lock+0x38/0x50
>  [   38.173707]  ? __pte_offset_map_lock+0x1a2/0x3c0
>  [   38.174390]  __pte_offset_map_lock+0x1a2/0x3c0
>  [   38.174987]  ? __pfx___pte_offset_map_lock+0x10/0x10
>  [   38.175724]  ? __pfx_pud_val+0x10/0x10
>  [   38.176308]  ? __sanitizer_cov_trace_const_cmp1+0x1e/0x30
>  [   38.177183]  unmap_page_range+0xb60/0x43e0
>  [   38.177824]  ? __pfx_unmap_page_range+0x10/0x10
>  [   38.178485]  ? mas_next_slot+0x133a/0x1a50
>  [   38.179079]  unmap_single_vma.constprop.0+0x15b/0x250
>  [   38.179830]  unmap_vmas+0x1fa/0x460
>  [   38.180373]  ? __pfx_unmap_vmas+0x10/0x10
>  [   38.180994]  ? __sanitizer_cov_trace_const_cmp4+0x1a/0x20
>  [   38.181877]  exit_mmap+0x1a2/0xb40
>  [   38.182396]  ? lock_release+0x14f/0x2c0
>  [   38.182929]  ? __pfx_exit_mmap+0x10/0x10
>  [   38.183474]  ? __pfx___mutex_unlock_slowpath+0x10/0x10
>  [   38.184188]  ? mutex_unlock+0x16/0x20
>  [   38.184704]  mmput+0x132/0x370
>  [   38.185208]  do_exit+0x7e7/0x28c0
>  [   38.185682]  ? __this_cpu_preempt_check+0x21/0x30
>  [   38.186328]  ? do_group_exit+0x1d8/0x2c0
>  [   38.186873]  ? __pfx_do_exit+0x10/0x10
>  [   38.187401]  ? __this_cpu_preempt_check+0x21/0x30
>  [   38.188036]  ? _raw_spin_unlock_irq+0x2c/0x60
>  [   38.188634]  ? lockdep_hardirqs_on+0x89/0x110
>  [   38.189313]  do_group_exit+0xe4/0x2c0
>  [   38.189831]  __x64_sys_exit_group+0x4d/0x60
>  [   38.190413]  x64_sys_call+0x2174/0x2180
>  [   38.190935]  do_syscall_64+0x6d/0x2e0
>  [   38.191449]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
> This patch moves the vma_start_write() call to precede
> check_pmd_still_valid(), ensuring that the check is also properly
> protected by the per-VMA lock.
>
> Fixes: a6fde7add78d ("mm: use per_vma lock for MADV_DONTNEED")
> Tested-by: "Lai, Yi" <yi1.lai@linux.intel.com>
> Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
> Closes: https://lore.kernel.org/all/aJAFrYfyzGpbm+0m@ly-workstation/
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Jann Horn <jannh@google.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Lokesh Gidra <lokeshgidra@google.com>
> Cc: Tangquan Zheng <zhengtangquan@oppo.com>
> Cc: Lance Yang <ioworker0@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Barry Song <v-songbaohua@oppo.com>

Looks good to me so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/khugepaged.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 374a6a5193a7..6b40bdfd224c 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1172,11 +1172,11 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  	if (result != SCAN_SUCCEED)
>  		goto out_up_write;
>  	/* check if the pmd is still valid */
> +	vma_start_write(vma);
>  	result = check_pmd_still_valid(mm, address, pmd);
>  	if (result != SCAN_SUCCEED)
>  		goto out_up_write;
>
> -	vma_start_write(vma);
>  	anon_vma_lock_write(vma->anon_vma);
>
>  	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
> --
> 2.39.3 (Apple Git-146)
>

