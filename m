Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D274BCCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 20:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39A1580094; Mon, 27 Oct 2025 16:21:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 371CA8000A; Mon, 27 Oct 2025 16:21:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2618280094; Mon, 27 Oct 2025 16:21:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D5648000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:21:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7CAF9140266
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:21:38 +0000 (UTC)
X-FDA: 84045014676.25.4983B8D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id D2537100003
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:21:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QhWDqwUs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gIX4b1NX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761596495; a=rsa-sha256;
	cv=pass;
	b=VdXiB0TKq0aP7uYg8iONOoi149nj1cnhPrn1x/6Q7oATq3BXBHkRii3ZJ0HQazADa0PgDH
	G13X3U+V1xb1Ta1AzyKcC8RVH97Gc0JcYHNDl1x7i6eUrZaO3yumWTuDF9tKdbwSUquqXl
	q3TYpigWIpWtbPkNB15J17O6l1R/DjE=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QhWDqwUs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gIX4b1NX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761596495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jBbIOdU0gQck7lPQAWXzArCV7mTGqG2uigTCCOYP9Cw=;
	b=rObraFbbc7qJE51HsrtrvcT4BkSPl5pn7khxe+vrvfpZvSKQvk2EbTkMVaVQljdzgmrY5y
	cwPNQY1roHM3uEvKuV4hLC8CIa/0+T3BCZ6Rv+pCdwciq+C6CR+sIwHrnMBG+NpWcrW8nF
	WH0JdWaT7qO7k0HY++0CqiVwUayqcaE=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59RKCX5Q012653;
	Mon, 27 Oct 2025 20:21:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=jBbIOdU0gQck7lPQ
	AWXzArCV7mTGqG2uigTCCOYP9Cw=; b=QhWDqwUsIgM3bb28wCV09bCDummu29wH
	MaOYWBLqHtBgkMrWafrVYEgGcIldOPLqnQjJp9/beTTaTDqgRSLgn5Cms0jtp61+
	h/oJMyVx+rUHYN5H3sKpOU0GjkW/6LInQlF65ynFLI+Np5bx59MxiQba7Kpdd5CL
	78BR/S7Roj/+jDmH0cRrbdNssqNxBPWCFC8b7GYOlYCpihs/tWujFE9dArsru4Eg
	HPQq5AbAQNOCNDA1R6YebRmxy6YYEa1QRtBZstHBtjbmyt9RstVrmDLW2WFnfuWU
	lBWfrGVrQx2XbHhdRKL3cynpjH7fu7gpxPsMtj7G/6JTqI4k30FWnw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a0n4ymgtq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 20:21:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59RIu8Ls009148;
	Mon, 27 Oct 2025 20:21:14 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010026.outbound.protection.outlook.com [52.101.193.26])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n0eh5a6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 20:21:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ip8eErU//2TF77p3wWXT6UyhezvfexeORBIcFiruNj7X42xW5WplnG8po3atVytLRqVlKE6crk1uLm809m1o1uFVy0vKRbVE13K0fVdmTLYEq1ppJ56Ah+sLRaaGShj3X31ABPw/06Wy2Tnl1CN7kLurJq1SRbKWXxNiLAe6qy6AVNFyrm4jI+MDDkTLmJVh6OgzndMyLmICc8SmRyAenbd7HwqhLfYzedb4Wh+RPhPw1bLzM7dLqi4RNmQauL/qMEAtiYWz0BCg3kLBuyM6Qc36AUrc6u5zKjyfQr4jQoB+RP+dXiGM1OViammdu4K65Wbc41w17maSl215R+64qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jBbIOdU0gQck7lPQAWXzArCV7mTGqG2uigTCCOYP9Cw=;
 b=zBdx/jdrKT6Jp9eW4LMMZ1t3mk6omoaZC+7keOJ8TbG4JXhn35DH3ygPSKIBz9VULptafXw5lBLSbs/tXo1zgxKXYj6wwIOCmwq3eCsOaroYgITct5d7N0WczhxDJOxEXW8Q+bqqmlKeXi/BS9WLzimU3AKZuAyJnWXtkotQF6XbAj1u3ZC/iSEv2ElSNcgi+jj3M6hwMSz2d+6b/MLVVjtiS0UjE92KB9lPVxYCekRqAN5qiomBnSNVlkVlPiEzF7xoz8kJ24+PH7Tqy8NtMTR+h+kNmvgZKArLaQX8+xbXnS2cOzGGKHTFjrkuXNa3HWpPoyrPFyBIXsCan2MOhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBbIOdU0gQck7lPQAWXzArCV7mTGqG2uigTCCOYP9Cw=;
 b=gIX4b1NXmhOtbcSOIXppj0ZiQr6tmdLxFHic50huvFHO5DOsttx66bK6YpbXL1wFHPYC3AKm+v0COj2EwjaYXGEs6PzUgGQuE+WX89UXzbgrfqRIH24dlI73NVIb7U2mzmV/u5UJEVmCTXJ5nu/+ndN7Ktxy7/q9YzUCFVoHeqA=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DM3PPF1A29160CF.namprd10.prod.outlook.com (2603:10b6:f:fc00::c0d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Mon, 27 Oct
 2025 20:21:11 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 20:21:10 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v8 0/7] mm: folio_zero_user: clear contiguous pages
Date: Mon, 27 Oct 2025 13:21:02 -0700
Message-Id: <20251027202109.678022-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0069.namprd03.prod.outlook.com
 (2603:10b6:303:b6::14) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DM3PPF1A29160CF:EE_
X-MS-Office365-Filtering-Correlation-Id: dc42fc7e-754c-45a1-d676-08de15965e75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6SYiDK6KZkp3AY+Zsqvqlo2YVC3d1kCYMUKqLk1Doj1P4fP0w+2DV1TrMsdp?=
 =?us-ascii?Q?b5GtyXFnXVJUfJYv6ZZvtymoe9EIQSSJDseVGp4VmwIJkptAH+8o866hvzMb?=
 =?us-ascii?Q?9RrjU72Pof93eK4lMwRoJa456hfEU/wGAoQ0U12gHLv/Kby8eDAntx20x1pN?=
 =?us-ascii?Q?i4LqizvLmDX58jpmakRbBWFbLFBJgW0VJCLhEbc8JW4kPmTKvdVoa2qpzdfx?=
 =?us-ascii?Q?Dl8UIap7tbnbvavC9IgSlAf/pWSUHiiBpYGolYfnnn9OkVHoCk559GQfvnfJ?=
 =?us-ascii?Q?3IOlqXDcAVOV8YTAMQyBD+aNWeq3SBOI/arsPsYoFbNHK0YqAh0yFpKFnaSj?=
 =?us-ascii?Q?r64/fAOkFE3TEFS3EBA0aP1fVfZ8+WAo2w23jncCJUGSqud8yIZFB8cG8ZRS?=
 =?us-ascii?Q?LJNLdB2/0G5LVQnuHXaJlOpipWStLgB6sSbX1A/vsYQaZl/yliHbuUP/6m74?=
 =?us-ascii?Q?sGh8fuLoet2TZH2mPFNbdWFwHCPOn2PkW3HVZWeKvfd+zLi9X2NP1/50YyhP?=
 =?us-ascii?Q?CzOg7e7SN+h2AVe+CbL/VyjMCX/QfzCbpSLb1GOCeV55mLbzOLztIdX7S8p5?=
 =?us-ascii?Q?QwJvjstzNwleOGz1/r0oIAVcd3Kjp2NWIvF3D9ipkAoSYM4SP8QjejFBLqZH?=
 =?us-ascii?Q?o9kW/7XHjrQLMuh0DcwOo3iKAY3DX7nHB4U3q6aOs5TC/OWRZmBDbeTxUVg6?=
 =?us-ascii?Q?u+9rlysrY9NAmFuYe3J3zDAO2H8YNU9de/I4/QBRcgtqciEW2o2SwCPmjmVx?=
 =?us-ascii?Q?YEuQxcA5vS3wimKIvX8PZSYwyTWGGt6f2yZbBqERYioiRJHAy1qiynuuMADL?=
 =?us-ascii?Q?m7ZRZiM51OU1zyGuGo6uLqFNZcxYY1VOhPjkfa77SInI7WzDXHld9H2Ztjto?=
 =?us-ascii?Q?jrlxL3PnF2VBBR83fRMytro/hCBMAyHMhIm78H3+S8MsNugPWyn50CthQFBw?=
 =?us-ascii?Q?3DtdiEgzhSUfSNq+fxFUSdCp+rfQHhpUkLiLWv6SC9xxNhwNicoP4KaaSudi?=
 =?us-ascii?Q?OCnV6sdshaYPcLCPbD0oTAgtCtZThNP7n3IiQPjv1yDIbCrDFVZTRzrZuTDt?=
 =?us-ascii?Q?Cnu9LGMLc/pa1zskFF1G23sOGAFk7WDDiZvwPM0VZfM3nDxDUT+oTsW5VMRY?=
 =?us-ascii?Q?E4PrayXPQW8ivcIZX5WINd+wjSOQK8BoWeKnZPXgbGUDNqu/qIwCV7jC2n8G?=
 =?us-ascii?Q?PMe+TYhgQPbNgWw+0A6TP0dHvgovi9XW04gDaYBs9196vKXqkgM+KL3jNBCm?=
 =?us-ascii?Q?Da9ZOd/JLEhlh1fvdC1RKLlc2yQPSl7UJzmIlqG/fZogONi3wjQqkjajQ4Am?=
 =?us-ascii?Q?gXzgOV5aK2lMGY49aMiynrSNViaVVswBhcpgVUtMpyfWSPfdx6sCEzl71IWE?=
 =?us-ascii?Q?NnZIKf/40Wh75eB2+rDwzTZgMlxTFA5JQbHp6LSZ6GNgNI6SZ3FKRpWOqK3C?=
 =?us-ascii?Q?gDzZC/dgaQw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K5Ab3zy6kLVCBPP7dzg5P960gimWLvUfDsilOdC6DigrVje4W/G+Lt2yWvTj?=
 =?us-ascii?Q?6toUXLyAvTvEqEy2cKgC2NYuKoBYTDhPkS8nVAQ/73gmtzn6HUp5//t6YYOa?=
 =?us-ascii?Q?u9eHtizquUQI/fW5zKCYSz5VGkaNrUsEYVto5iREhBOwO1N9obj6Ki+N8cqE?=
 =?us-ascii?Q?gwTznM9tLLn0La1MqbcAbzywWBUdVxgKUd5n6IK5HDuGPfzXu9mwAYLwFifx?=
 =?us-ascii?Q?152ghbfa+5KaKoF02yaLjnAhC0cKn360UpYWiZETBs8eLYQdj7mAEniFgpFY?=
 =?us-ascii?Q?DIhSxKCLDrY6jh04wyNYW5EbDuNXXEtV2qDTTkL40poWXIbDwteOhsN/12jN?=
 =?us-ascii?Q?+KoIC5dNmafTY3qmM4ML6VCncoGNxnPDZv5VNU8Go/bzr2Kus+j+F/GgIF5q?=
 =?us-ascii?Q?TpYaoVM/D8Yh94+DjuyhJPzj5GSgWWzFSxYyT0jb0Oa97xvu3Hh93kgIERJk?=
 =?us-ascii?Q?MImb9uGkMHUdxerbXF1D4Masjz8bbB+PVISoMKxv5x1FzcYvImW4bkojZbJH?=
 =?us-ascii?Q?UeqFRx3fG1lPt6WlICceSQP/CQ9EX9wIFnQi2ASdlLC238cINu+MbVbk+oGO?=
 =?us-ascii?Q?UWt4UsoC/U8fDEFuo3uzE54+0Ji1YrK9W0S0oHAcclYyyfXYLOyUoIdkvn/N?=
 =?us-ascii?Q?TB0HLcVDdIBe+omqMHliDh0aJLhhU84S3eh8y1iYHdaxmCBT9CMiAMVXqNIM?=
 =?us-ascii?Q?WuJ2EppsgiLu7SAUfJbpd0H+2Uic6rOgYdRDCLhXxM9fap7WfWb5pGGZb/Bf?=
 =?us-ascii?Q?yy3m6oj+cDO7Lecmd/rBKB7nTBsTdHBrEWP2eDtl50ojlSOYCJ7zmNcDJ1tG?=
 =?us-ascii?Q?bzk9tSZk/Vs7p/WK1q5HWYcjE0ODMP8AQ+TuC+r/z6lZ3v/mFquOl5XeS4d0?=
 =?us-ascii?Q?Wv7el5dkyeYGZyx4qdYN21pvpXi3MYm8kXy7rsVyhmRlwyTzCfyvE3Ain4FK?=
 =?us-ascii?Q?vIOcDK2VgtQkB5ZFvJLeuatbHNITDdMxBLAsBzkJc//4KuNNqODuaNPL/sQY?=
 =?us-ascii?Q?dKwqe1IdPgxsRK+Eo8uR4X7qeDFqOcOekYlu7qTu1AWeEfKFPl8rtXMS3Y48?=
 =?us-ascii?Q?SQ6Wr7xzycrlVYdMJV5bj3U4wjhEsX8KFEKv3RiLDeJjxJ30KzH17vABfLzm?=
 =?us-ascii?Q?0gYnShRsrp0EIM1SrBy8QkKVVXLzw07UiC4nNXBO+iBomhHBllWE09VDQA1Q?=
 =?us-ascii?Q?KhiCo+rzp+IDb5k08P8HzMidO6ldCcnpjuQ+9BT5YywsClauToIXrZssIScF?=
 =?us-ascii?Q?JZQ0/QvFM+4LoM2wb7URv02m73Jg9K7n4ewLxZqv6sfo6WaU/+lVzx9gibLs?=
 =?us-ascii?Q?Dfj99ysvOVB6DIkfNzlOCs/ykFqa7u4qxEnMRXoLAtyCMBexT5OefnV3q4e1?=
 =?us-ascii?Q?SzhBCFOhY8HQMB7F+ryWced/kknxIQpgfDpGPLPZfk3TayQhG+CMfjSg0PBK?=
 =?us-ascii?Q?3YZVZ9gF5O4lmnIbKKxHAROmSOaAbQC82v/NCYgGFQI8zbMpTsZ9DMkwes9r?=
 =?us-ascii?Q?ip5mt/7t+zmH7bvPae7h5HO6UE0/KeKpFSKJ0DcUmN5Y79Gw92mrt07Izflz?=
 =?us-ascii?Q?01y4RBGV4mC49woNvoc7mDe619/QmLGgqxnD42mELFqypV3Fia36yZS/Gpg/?=
 =?us-ascii?Q?6A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MEglryN7j80YvmXCqKq0Nx84i74NfjSBissXug+9NO0aqiKJIM0g5Vyj7OnJIjKcVvX9xcP1nre+dU2LEPI0QqHiCzhH6Jbze3zg0XK3Y8gx88Y52nYxiOb2FhxUHFW8ANq20oCkfg3Gttb3v7Scf1PUg2VVYk1L7ey82HzwLQGp8Sva+arkGLk2GHh9z3js8hmkv2rjOm4zNuhuFXZUVqSM3lgesfJOEPXoGFHY/pKg5V/DVCeMuK9RHbE5OZ3iKCw9IoUJ9eqyDLb0/ASu6A1BTy0IUYEVPaKOsnXPfajkyxKlY2RTfy5pAoXzIpXUpTleRKV0JfdnnwwAZQVmBm5K81e0vRts8Y46A59VqJxOyZ4fnSoAf7MchvysLYRrJHR0pqBl118gnCu26GWpo7P9vjle3xlZq4wd/CM88RBiwsTQlEpZYavECN45ZtCDIeWYduv1u0/+OLiAJzBVCIi6yXeEzOBfYgH5HoA7Hl86qxu86i5ZYqixKH78Letz6TZd3zY8AXDWcdxqVZDMYJb0lWEgcY+64vQrjuCper/ur6BIPdsTAATk1j3ccOppqFHMiZbr5JDUSzV9iW59iGER3fubmr+8IRWrhkygb0c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc42fc7e-754c-45a1-d676-08de15965e75
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 20:21:10.8839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RlhTTqQKPpcz7v3zXR0ZVb4gxAf+Hf874Hoi+Goy5xoheiVyWmO1JChPz1/WpfEMFnt3CJE2uKJp+svPBw8P201YwXvqJ6tD2km+Tw71dgU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF1A29160CF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_08,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510270187
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAxMyBTYWx0ZWRfX+41SDIqgy9yz
 3oeWIyonuiUfHRR4FInPLvJh+wzIW58bRLmOAPfYStfRKgdr/MQHntE3i5m9ZPzeMxQ4SiCWuAS
 +Y/hRZ+UCdlR0y768sIKZX03IGIDI6NUo9iNp38hDyy87tnmPYFtTYz1wiAYWQM2Q1GTugbQFUd
 HdfXj+h7XOOuL3Hh48JsXB7IgScYjDxH4T6IQHP8rvK3yVk/64mgaBGdwuqy3x34Q0VawosBaPc
 2SdRDWjxF2Ub+fYIDPew/yhd2wRaTtix5BKefCRZpOngnOBdxHxHJ3ngmdQyJJqunyzz0U4f1hn
 PmmN/DEJfRW+pKbNXBiZlJqMn5zsnDMXMsKD2hJNmLTd6QPHa2akyVksnVaTW91mB1W1V+8ubXY
 FQSrgsNsLZiQb1JrWV9yveN7JCJTN9VB6Oog25c+F2Iv8yVEgqc=
X-Authority-Analysis: v=2.4 cv=Z9vh3XRA c=1 sm=1 tr=0 ts=68ffd43b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=zd2uoN0lAAAA:8 a=NEAV23lmAAAA:8 a=LQDZQVXwOrBrzxWjdv4A:9 cc=ntf
 awl=host:12123
X-Proofpoint-ORIG-GUID: BIj-f7vS5KiwilSbyISJCD90Q5pHMCZ8
X-Proofpoint-GUID: BIj-f7vS5KiwilSbyISJCD90Q5pHMCZ8
X-Rspam-User: 
X-Stat-Signature: znguhat9b687fbcob4obyi9cobyx5ceg
X-Rspamd-Queue-Id: D2537100003
X-Rspamd-Server: rspam09
X-HE-Tag: 1761596494-490332
X-HE-Meta: U2FsdGVkX1+Q0u28H7fYF6B7vq7Gc27eyH5tv2cf6VwlUzKVQmkEuAJBXjtdivReH9yNz6mPWU7Y81RWXkvg6r+FwIjejllCxt8R2iFEgSndKdzoiGSI+aZAr0oZWmSkOHMdTWaExEeAkIJlPYhfXiu/jpPChjHbBaTGeHloU1sR3v8uqtuEd81pzSOjycIbaUaV7x8TY4TWEOR+9dZJKJ22LdwVwIz20gDcLglCNjldkvIJFH1HrkSmfV+qp4RCLgvgmKj4G4EkiqKDNA2PWtidA5ySXXhL9lHO9JhgMgDC+3R2HsGQnq8jWEUSxNlCqYjmSRHLibcl19adIpi6I6Xtax6gfVEKls+CDarW9K3u0koqWnS1G1+DNSAz1aHMxEGRmwMbnwFhNTlXn+piwwN2EsDcAbmovi4g1ggd5O4wc7dTnLu2LR+VASYEUc5QypjFM4qzNULXPeurvcSfd/AvrZebihU/7tacFzuIUSfRGBEidKZkM3c2F5RR9ILldBLzHLWtowqk9ZOa55D2KlX9Befe5CobWVXJmIz+GUxNuqSi5mEO4vewiL51yX1w4uv8SQI3E28z1Ucwx9NwfomBUPujMlD+ZUViJqb6mkA/Jt2uYBPXCwQPF8Gm2PEO0Pi+62xALLpxOJEGW47GJHFIw7iX2IgjFkxAkoQtcpl/3K5CFuYPJR9cpY68hZ01MJ2ivv9nIegs/XJZN3nKO3lDt/ok+PRBhoYe2Nwr7ovwsPTB4j/kLHkVb/WVgvcCt0GQiI24msRJbrX1cVeURjEHqr3iIt0mQ7xa+Y0nEp3LBAAsU5IAP8bv0OZD1XiodJVDjcmRThUOKJr8eufY3eq0S8KYpHuMUmxVjQIHhkEsIKeUj0RIaU3R5QLxfhD6KDz4KzBAvI5TidDMMGUaTzKkeNsmo9Izie0Xq79gYamWdvsr/b9b+/1gVos1m3pGOWEiDP6JGKCgOSkRyhX
 TVfvhStA
 6LbRQ3bbUMt17UuxD0mDxhqQU0EieloJVZtya+Ts8qa1FQmRdthi4DiQidre/3YLYKhtHoW1aYaWqfYSBwvE/LsSuZdvJuJ1J6VvQVt8vdQ5OEN6lc4On5nrdbc5zzkFUu8KsghHe4TahaZV7r7J//AOt5J9uvYt2pQC4jdVMh85r7vDf0x8+r7iHbPOg3fEAqUBZLkkDN0x2VCGJLS0wCcZ2gmIVyAn5PY8+gh4UyrMdvs/OJzmht6ijYCOtuSsXDrW9yLmHSJRTZBgqufkvPVwRBJ1ceXhq/N6mJr/A0s+o6swPBSN6QVikKEC0/9kpyBMiA1aJRabfgmG2evVemuCbQVhPuYgUtu5uPGCs/SHleEUfUgkKu0RfHU9PXoGUfaPIqQUp/wcUXFjCOEW8wf/yq+/ns/Pgks1ktBg1PptS7yuthq+SdH4Qv25PHbkjm7Y8LY815lNy5fhpZQdOLHeMMd7hniTwjSIaxiDY3kLtJa6F7HlK7QUn4E6lvD55VJAW7P7niAHJd/IsFAVHPy6dhmZgz0werUwKH0lVuul2VCE5x+kQpg1+AgBEgcsTTG83fVqbq5FWGouL8DtX/2KiicOFs5CMo00hby83PQBYxcrzVVb6zPuVYjZpXBN1dWZds1drPWL2D3MCSwyHKHJdnvSgYLRPkqjRBrP62p7ndy4HKpGHPEKwYp4BF3CAwqbn3rbwkraOlgzC7ZKJPJPM7EuV/F+F5uhMCntN018HOHMrYhL0xMtBS9teyCAxjywR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series adds clearing of contiguous page ranges for hugepages,
improving on the current page-at-a-time approach in two ways:

 - amortizes the per-page setup cost over a larger extent
 - when using string instructions, exposes the real region size
   to the processor.

A processor could use a knowledge of the extent to optimize the
clearing. AMD Zen uarchs, as an example, elide allocation of
cachelines for regions larger than L3-size.

Demand faulting a 64GB region shows performance improvements:

 $ perf bench mem map -p $pg-sz -f demand -s 64GB -l 5

                       baseline              +series             change

                  (GB/s  +- %stdev)     (GB/s  +- %stdev)

   pg-sz=2MB       12.92  +- 2.55%        17.03  +-  0.70%       + 31.8%	preempt=*

   pg-sz=1GB       17.14  +- 2.27%        18.04  +-  1.05% [#]   +  5.2%	preempt=none|voluntary
   pg-sz=1GB       17.26  +- 1.24%        42.17  +-  4.21%       +144.3%	preempt=full|lazy

[#] Milan uses a threshold of LLC-size (~32MB) for eliding cacheline
allocation, which is higher than the maximum extent used on x86
(ARCH_CONTIG_PAGE_NR=8MB), so preempt=none|voluntary sees no improvement
with pg-sz=1GB.

The anon-w-seq test in the vm-scalability benchmark, however, does show
worse performance with utime increasing by ~9%:

                         stime                  utime

  baseline         1654.63 ( +- 3.84% )     811.00 ( +- 3.84% )
  +series          1630.32 ( +- 2.73% )     886.37 ( +- 5.19% )

In part this is because anon-w-seq runs with 384 processes zeroing
anonymously mapped memory which they then access sequentially. As
such this is a likely uncommon pattern where the memory bandwidth
is saturated while also being cache limited because we access the
entire region.

Raghavendra also tested previous version of the series on AMD Genoa [1].

Changelog:

v8:
 - make clear_user_highpages(), clear_user_pages() and clear_pages()
   more robust across architectures. (Thanks David!)
 - split up folio_zero_user() changes into ones for clearing contiguous
   regions and those for maintaining temporal locality since they have
   different performance profiles (Suggested by Andrew Morton.)
 - added Raghavendra's Reviewed-by, Tested-by.
 - get rid of nth_page()
 - perf related patches have been pulled already. Remove them.

v7:
 - interface cleanups, comments for clear_user_highpages(), clear_user_pages(),
   clear_pages().
 - fixed build errors flagged by kernel test robot
 (https://lore.kernel.org/lkml/20250917152418.4077386-1-ankur.a.arora@oracle.com/)

v6:
 - perf bench mem: update man pages and other cleanups (Namhyung Kim)
 - unify folio_zero_user() for HIGHMEM, !HIGHMEM options instead of
   working through a new config option (David Hildenbrand).
   - cleanups and simlification around that.
 (https://lore.kernel.org/lkml/20250902080816.3715913-1-ankur.a.arora@oracle.com/)

v5:
 - move the non HIGHMEM implementation of folio_zero_user() from x86
   to common code (Dave Hansen)
 - Minor naming cleanups, commit messages etc
 (https://lore.kernel.org/lkml/20250710005926.1159009-1-ankur.a.arora@oracle.com/)

v4:
 - adds perf bench workloads to exercise mmap() populate/demand-fault (Ingo)
 - inline stosb etc (PeterZ)
 - handle cooperative preemption models (Ingo)
 - interface and other cleanups all over (Ingo)
 (https://lore.kernel.org/lkml/20250616052223.723982-1-ankur.a.arora@oracle.com/)

v3:
 - get rid of preemption dependency (TIF_ALLOW_RESCHED); this version
   was limited to preempt=full|lazy.
 - override folio_zero_user() (Linus)
 (https://lore.kernel.org/lkml/20250414034607.762653-1-ankur.a.arora@oracle.com/)

v2:
 - addressed review comments from peterz, tglx.
 - Removed clear_user_pages(), and CONFIG_X86_32:clear_pages()
 - General code cleanup
 (https://lore.kernel.org/lkml/20230830184958.2333078-1-ankur.a.arora@oracle.com/)

Comments appreciated!

Also at:
  github.com/terminus/linux clear-pages.v7

[1] https://lore.kernel.org/lkml/fffd4dad-2cb9-4bc9-8a80-a70be687fd54@amd.com/

Ankur Arora (6):
  mm: introduce clear_pages() and clear_user_pages()
  mm/highmem: introduce clear_user_highpages()
  x86/mm: Simplify clear_page_*
  x86/clear_page: Introduce clear_pages()
  mm, folio_zero_user: support clearing page ranges
  mm: folio_zero_user: cache neighbouring pages

David Hildenbrand (1):
  treewide: provide a generic clear_user_page() variant

 arch/alpha/include/asm/page.h      |  1 -
 arch/arc/include/asm/page.h        |  2 +
 arch/arm/include/asm/page-nommu.h  |  1 -
 arch/arm64/include/asm/page.h      |  1 -
 arch/csky/abiv1/inc/abi/page.h     |  1 +
 arch/csky/abiv2/inc/abi/page.h     |  7 ---
 arch/hexagon/include/asm/page.h    |  1 -
 arch/loongarch/include/asm/page.h  |  1 -
 arch/m68k/include/asm/page_mm.h    |  1 +
 arch/m68k/include/asm/page_no.h    |  1 -
 arch/microblaze/include/asm/page.h |  1 -
 arch/mips/include/asm/page.h       |  1 +
 arch/nios2/include/asm/page.h      |  1 +
 arch/openrisc/include/asm/page.h   |  1 -
 arch/parisc/include/asm/page.h     |  1 -
 arch/powerpc/include/asm/page.h    |  1 +
 arch/riscv/include/asm/page.h      |  1 -
 arch/s390/include/asm/page.h       |  1 -
 arch/sparc/include/asm/page_32.h   |  2 +
 arch/sparc/include/asm/page_64.h   |  1 +
 arch/um/include/asm/page.h         |  1 -
 arch/x86/include/asm/page.h        |  6 ---
 arch/x86/include/asm/page_32.h     |  6 +++
 arch/x86/include/asm/page_64.h     | 64 ++++++++++++++++++-----
 arch/x86/lib/clear_page_64.S       | 39 +++-----------
 arch/xtensa/include/asm/page.h     |  1 -
 include/linux/highmem.h            | 29 +++++++++++
 include/linux/mm.h                 | 69 +++++++++++++++++++++++++
 mm/memory.c                        | 82 ++++++++++++++++++++++--------
 mm/util.c                          | 13 +++++
 30 files changed, 247 insertions(+), 91 deletions(-)

-- 
2.43.5


