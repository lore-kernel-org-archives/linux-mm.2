Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38731C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0F536B00DF; Wed, 21 Jan 2026 11:57:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A372E6B00DD; Wed, 21 Jan 2026 11:57:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F13D6B00DF; Wed, 21 Jan 2026 11:57:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5391C6B00DF
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:41 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 210391608BA
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:41 +0000 (UTC)
X-FDA: 84356577522.15.D3E65D3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 94956100012
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="bATeb/GU";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="G/V9vhhe";
	spf=pass (imf14.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iRn0fsS351mw15bhKjUHwsXVZaso7MWLkrabk2dfSsc=;
	b=8D5cHEfZ8B0966NsAa0AgbFsN2kVpGtOty7GQFNGpIQnm8PSKwbZls0/57MCL+kn+yxONu
	sdBd0UjUIMXUkLSePnbUzHVLvYreHzVHs+xAknPXI77fPBKwmwAOyaIegNiO+JR3ghXtFG
	U5zA+iPct+1knc0x8HYfsDM3gPlZci4=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="bATeb/GU";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="G/V9vhhe";
	spf=pass (imf14.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014657; a=rsa-sha256;
	cv=pass;
	b=dZIgi8puLAc2odGh/sOPjM2wV0aeAANnnhvU4W5V8TvYn9EvBvB2fJ4BoOiM6Ymbh6MYPh
	tFkXEAb6Wd1INHr8Gr4oZZST+sNCHGDuAc37/2qUdulbSn2JaJADezhpAWFgc1P7KfyoE6
	S+PJzSxoPDT/ZqqIVyaZaPa8NYxL70s=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LFUJiu3264931;
	Wed, 21 Jan 2026 16:57:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=iRn0fsS351mw15bhKjUHwsXVZaso7MWLkrabk2dfSsc=; b=
	bATeb/GUyc6KOZ2XXnI5dOP5yRvOc7z6siBMhGP0u7oxn94+XMxa+Ys9Z+UMrtdZ
	0+jU739XWaWmPo7R7RJfDJmm/SVNddZRgVWSblwZXytwfLgmhWw+IdYm/5Ibu1rg
	yXYyU5JBS3oLKMy/8dzkGCgH2fq7OB5FS6VWintmEFc3GlhlQM7TwH/TSTXqkCoe
	M1nORV8obv2BXP1cMJVYFxSBLct1GrP0NIfloAU1d0Hx6ZoCb9Lp3XjRFjed/7TQ
	Jz+H8RvEl2xExN8J7xLM5Hz2xCPH22EK6uGEcm3/kMkGrmqUoUS8wityGTEy+qvC
	NDlbEpScuccJowKuFKllQA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8e90s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LGWLCv019002;
	Wed, 21 Jan 2026 16:57:25 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010016.outbound.protection.outlook.com [52.101.193.16])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bsyrsbwa0-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wRIZcqkSgjQx6EsuL3L6GybhWREvcnNVn8CEhKi56Go6K9jPLn7RgqsN/CxhJeJDOldigvM4M6NtOQF723YcI32B53L9pd0mryy14blSy7OLEE+g+y+FBj1W8KkXIqWnC5JLOAsYXLvyQuioyhCcuKmr1lIhbL34FAbXNSjL/L8xc+abyICbgxKJ3lGtqT/xCV6Srh+5uK5m7PoxyJnmQkCMAsBNVyAkYvE7XQa2eW2yJ/s5ErudsZ66K853muXfYQtbiYFLBa2sBypx2xsB3ucjN1EA0/K6hx4ZqZfyX5hkCQWjwX5ixtOwCf191mqq5szHvt4TzWP4/226iUdVPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iRn0fsS351mw15bhKjUHwsXVZaso7MWLkrabk2dfSsc=;
 b=McSrhdV367xPG3rqCRb74wgUDBR+v0FaSKQzkCl9eK90zJQqqR3lyDjHqW4bKCa61bDXKVDeVJYrdZy8c0SiIyEkOVF0OLJyEA0xPyKdNJLk4tZQg1b2NRZJDiTxYN8W8mRzD8a9H+jAYpLj0ET9TqWQ0Ud3sCK8RDDnzvda+d73/Ct5MfwGf+1CNcu1WCIw/Pv6beKycvqJrujmQGxoh/RQYuWWs7zI+Upeb1mZlHFwOkynbSvqurotPaM+g5vEncwfL+nHQ0i8JpJvkOV1QkSJPOUFuhlDW8RjuafzcpbECC97F0fiBKnbMq5DJW6+wEIiZuATMkNofXOvQir9Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iRn0fsS351mw15bhKjUHwsXVZaso7MWLkrabk2dfSsc=;
 b=G/V9vhheSkFhPJEg8FH95YeYzKBEBa9TNPHV0xay12r/pr3qBqdS61aKHw/wcZNyuI/2qjSNMpq/38RKwchJnJ/I2f+9j6jwBbJ6uW8lkFN+suZAN1UFo9iBU9qDPE301wWyNP+PhqimDRyJPgibxt3r1w8oXAiZSJwFI+WTfJ4=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7727.namprd10.prod.outlook.com (2603:10b6:408:1ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:23 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:22 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 18/29] maple_tree: inline mas_wr_spanning_rebalance()
Date: Wed, 21 Jan 2026 11:45:15 -0500
Message-ID: <20260121164526.2093265-19-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0196.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::26) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7727:EE_
X-MS-Office365-Filtering-Correlation-Id: 5121fd89-dac3-44be-a293-08de590e2592
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3oIWrjq4ckxRb9j38/k913/HYAuCP27fC/O/G/h0vl3r19OMIPO3xQ/w/eoU?=
 =?us-ascii?Q?Vj1gvZ++tP8hDBxYJhTEzYcFH7VzgOdjZuDMR96KevY1hQw1H62eb0Ua16uv?=
 =?us-ascii?Q?gEdg9nfv9T8UeZrnN3hh4YiWC5P9qGknxxr846J4OzcHajtuf9KuywOUX7j1?=
 =?us-ascii?Q?7ofEeOSGNYJbm/DRi6B/wJW4Rq2KZUn5XMAF5CscNQz9m0IosDvKFgoJcQyr?=
 =?us-ascii?Q?kj7MK5TJm/h+W5n8nv947mSgLBf+FlpKnbPCLU+vqLL9Ose4xU/t1NLTIjpC?=
 =?us-ascii?Q?GKCauZjsPIR+T4mYmyyUK2iOj3M2lAwr9q2u+eoO6+z26pfmV+MNMF/q38aM?=
 =?us-ascii?Q?L3Q2MtzvLlTz37WrUxFsEasaRNFj+hbHj/WOXsRhbKPQqvr0ixBDnh3Y7pd0?=
 =?us-ascii?Q?ssRZPMyEmzdi0d5PeB/4JRwdVPRg114xSaEhffdEcXpmsKhUCevY5ZBuIBtu?=
 =?us-ascii?Q?+5mxqgkTOR4ywLw4l8hCXcOzmSo2MH7RP1Cx3+ASWUwahVeeQi+0pCcof9Ob?=
 =?us-ascii?Q?+D8zT0yOkxA6efjRhxadzrBddAuvXaK0QT4vEuaRW1cl627jM4zXoFnWjqjJ?=
 =?us-ascii?Q?BIwBnTAKiCabBRvpkZHyKzqUjL3Y5tCUdcSZOjW3ajY4/fkMNkS3ji/K9hVX?=
 =?us-ascii?Q?cZSwqh3Wtn9yVe3OMXWwKQsnVOyuSG1WJUFc8G4no/5afcPbm/1oSMbmfWAI?=
 =?us-ascii?Q?OKa6yHvBmGz+JZJNGZZBHVFzgWidnTDUEP3QSSG0CwZBrbEQ51NuIMR/E3iK?=
 =?us-ascii?Q?WVImOMuAXTHiW+UOZpaojslKbDH/TsQoVIPmwdt1NfnB6U9g6kKmX5QURZnG?=
 =?us-ascii?Q?NcPgDdD4hHNWPfxtSrQ7HcnMtY1qoso7f3Fn98etF9KM2cpDVko9YGH8O5Rj?=
 =?us-ascii?Q?kjLso3cD7rpKq7C54zw6950shf0xoFDcK2/pXPOOLSkVPWF8FOKQoZebHYl6?=
 =?us-ascii?Q?w2xrdbzXVtxdiHHql+ml/mXMu1mmNn+Ngeg+01fL4ugCUTCc9j+erzd/W+/J?=
 =?us-ascii?Q?R6tVnG7R51c3MeIgrLWyp8ufDkHDsF9kjQ/Fltg+I8QSHWlhLk7J+bXdElvH?=
 =?us-ascii?Q?zynU6Y1D5RaB4swowzOXk+MCMCzMlFnTyerKqgnTGo5xz9sWgixlPLOQEdcB?=
 =?us-ascii?Q?bst1eSCtAhOW+Rd5hM/u1M9Xoz6uudS2i9dkH7//Pm8aw/PhmN+OSvoECWRg?=
 =?us-ascii?Q?5hqVLwBrZRuMPDyk2ZrT3e/tViowJEjLdGVQvWuuwZq7E+Lys7kZtIY4KRrI?=
 =?us-ascii?Q?e7IuTTX6HyCsVS1Ir+pzQ5nbALY7ZYWqsjrhD62/LrO8aCJdAXBIVZjQcqUb?=
 =?us-ascii?Q?CLR9ZKc9TJccXt/J05OIYUABGHlzbvGjISEBGniqFcQpu2kvtgKHX9aGZIvq?=
 =?us-ascii?Q?Wy+efC1PvF6A+mxH1EIXdZO7o2LZu9YhyfxuuMUgH76LtD5JT4pETrR2g8PW?=
 =?us-ascii?Q?tg1A+ERlZpVyznvhtdWR3DHc+8H+oIxE5aTKTBR/LjuH92z0eQIyQ+BSLogp?=
 =?us-ascii?Q?X88xSExJzq4S7MgNgx+na5+ZrUA/W6FLYjiwXAVaQtpxjHt2ihahQJ0iU5FH?=
 =?us-ascii?Q?IsZFsvlsP/7hWLlifpw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AUpeZli0MEVPcItxrd+bhoTHKJtIdRN/5CyntkxG9jHnwKanK8G9QKxfd1ef?=
 =?us-ascii?Q?wT29BoYACZjElEFUpLuOUllJgNCTzaWxY9/sYG2Rhrs5T5hJf3yiKs5cgtVy?=
 =?us-ascii?Q?j/rwQaGadzqdu+BgJIwYWb6EecfEgWD0a+GlbSi6+Aw41F5UBuZ3PfQzRjSQ?=
 =?us-ascii?Q?JHiNHJPJOmK+Ca8U5srE2cpPRAJX+nEDMG6my2sv8+WB+EQFdCsHA5/ep9NY?=
 =?us-ascii?Q?BeBhLtt8rsAK3OlunOSd4MDXJHIAkIKg2lHZqAEzPIBVyzHRgfEfqecew3h1?=
 =?us-ascii?Q?T7ZWFgez4feGuNWxhbcePq/3FAEgIIbvPEns2zkDAoE6idj+dxf6DDyQSlvP?=
 =?us-ascii?Q?ryuOTYQ6Neo0QYDexAGDv0tr1Er5dqlXvKANu0tmfqEM0K4WGdBcVm1IrXAc?=
 =?us-ascii?Q?CJb2jybqd/tQikdSuh1fEX6qt8bDM/AnDNYtD2Cbu466oudwqI5ql8iwdYPN?=
 =?us-ascii?Q?uJWP3mztY+42Rit8m6nD6mdhMsFg+zLJF1OuvQo6T2MmCKFGEgUQ5anBHkLS?=
 =?us-ascii?Q?p9Dya6h1QAnHrubVnzp6TMsRKrAV7wl6NK3DtLM+L5YZpeYhXD/yCWyqXzsa?=
 =?us-ascii?Q?lqI3UXkia/RD6+w5l0gsL7EafiqneIdFYv/5dzpeAVRXUnWeRJlLoI//ffRp?=
 =?us-ascii?Q?gKVQ2QWjlvUKD4ZAaRqgpWcKRFSLWu2Dsqp4WtteC5kb/AtJb4uMk4LF+OZh?=
 =?us-ascii?Q?MX+gw236zSmTrJReqsMo9vrxgIcqw1TZK1xYhoJq5jJl+iOJdmO/RhKJJMT+?=
 =?us-ascii?Q?vfUpuIsUjElRlXYMDt8C5qeiT5K/FnXVoOvVWCH0yG+wGey+xAVG+L5xWKjm?=
 =?us-ascii?Q?VuimrKKLO/LTJL6BAhsXudrGa7fEayWRGJcG/5ZSAuf1Xz1b/zEwDFRzPshg?=
 =?us-ascii?Q?yOZS0MJs8DRLRlzEMz+aFPkLjuzmvO66RDglLQWEL7kSyotn7q/na2jnaRS1?=
 =?us-ascii?Q?HNIyiz+nOvH4OetESkhD+KKPL7YI6dRhFGya5nVpGAwb4eJl9YnYMwhavgl/?=
 =?us-ascii?Q?1+yUFGC4QnK1WHIRq47jYfZr0wCjzUye6tTh5/jNmoMlK9n0tFe2Cc19ub/L?=
 =?us-ascii?Q?/bk87NjCKzUO+u2hpYbGFnqkXSFAFRvtHfcYhNi3xKTFW38YU9zJRoFZa3UX?=
 =?us-ascii?Q?SEm67dE0I/55l11M2b02TXlUpPfbxz3E+yb2stRiKEbmn3Zw8D7pEICPLL0x?=
 =?us-ascii?Q?xBpR5qtLoVRZ1UZQH8oL6nbxv5UCGnsiSlMnA8axC/0W3g7pau5C7rXMsgkB?=
 =?us-ascii?Q?MNSGrTDLWztu4hrZWW8c4cwb1TzX/9G5S6XT3tobZboRSw9YS/zSdM05eax9?=
 =?us-ascii?Q?3m8M0jMdvvBIGnidmtzDFYN8XkkuIqLe0CSfq+xp/vhGgKFUKfllLO7Iv5Xt?=
 =?us-ascii?Q?PZKdWvhMJEZP5QEzbeTBfuGDIEcgTwHy373ER/90pUZfEI8Fm5X46UTCloIX?=
 =?us-ascii?Q?qAuZXJeiPecTm87IGjAva+vLSd99FDmaL9AzJcTAXfo2I+PGUmh9ZnDT0fLw?=
 =?us-ascii?Q?6klEmWHTrVEuzufRqylQDGywO/O57X+7W4QIyakfD/MCw3klHWQwq6xYEwCi?=
 =?us-ascii?Q?0XqN8iD2b7u7OUQrVP4wZGyzTnD9NtD0R9sGamcR5E5ZAbdES6ELvOJ/PmEH?=
 =?us-ascii?Q?yO5kiqJrHi2hhh7Tp3PMoKWr7GWifI2QKPq1qGa2jM5LLI2iFVvLVDTl2UlC?=
 =?us-ascii?Q?F7dyBx6rCqBJtLm+IDoa5S/4p7mQIbQIs4Ms0np3nF8w8GNBU7msNCsaTiPa?=
 =?us-ascii?Q?KcKnfRLvBw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Bydlmhnu8xahCV1cjYboF7EhpsotSFDFL+paW/Ax/BjK2HhmhKTEVj2cdkZB7iS1BLkNKS1ztFB3hGwSyq4xicGIS7ah4KzNO5+hSBJZal6JF13HYTkfCokAKRzkKtreWYklY861qEMSZ5zOMHfw9R1fo9hyUiZxvj89qWwEtNuVCzF3Q3TOzv88j5c9ns3Je5nZT6dq1U5oEyP92tYWrJekeNpxBDsUv53FiYs3PP95AAEi1qidMKggEFn7jU3iYW+HZCDqXuzN6/jpLZ+JvRGcSbPWW6OoQFv/PqSITJ0WbkRosvTkHViwWakonfhyyn1o1UVTwdgYEoPT7mnccJNuSbfw/hf+lwUwZ5Kpe2QA2pzWcb1NVr27Cmioc1ntMAP1l/zRbwXie3X+8SxAZTCBUomMfUimHJZsmXvp2DkK+Yu7p+tQUNGWOifmpju6KjZEtPVk+jfAsCmEAPlotzByYXLFklUpXaCMEFA5HAJyDzJ2E5Tf1dO5pLLNJWg60RJT4nUf668UxeLhrq1KDMYSvHT9di1+DzglB+EsaxTM7PRpDak3/dTQDPUFEEvvT3oeJw0SeKQX4cnm0JRz0GA78ad+uSJ2KOOhKC+UVdk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5121fd89-dac3-44be-a293-08de590e2592
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:22.8944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: horFvb4XHclmDggNOhoINQb9A9thmodjymVPy7iCYkqJT6eaaN6cb8mvuCb55MLOG4RHhhuV+BwxbXXC4LVksA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=69710576 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=rS4Dkz7vSkpNL7l-vQcA:9 cc=ntf awl=host:12104
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfX3g6E1vi0zSXQ
 cmpQZgs6OQYr+SMe7jsxDaNVs438UdrzctbjKEFbK1emLk8VjPg7jncMmi+oI8Sh77J0R0K3thr
 Vt4vSZp6M+g/2/hlZMtD84UzvPj+5fSigc1+RBMHjhVUJRu3DL7fkm/caUbZIU4+8W5nEJHV1r3
 /My9aTOcOymnDnDMtPKdvXEFkvrq8cg/zbKZ3oS+SA1ih7mUh/K/MXkxqSSOT2v3NAuEggC0wyj
 B2PjnpIBxxp0XoqJF1D5WRs3jTLqXCd3nKf2/fEMZAczGVO+i2TO+jcv3dO5tKbguoHdGfFswrs
 1jm4IGdJA7okWtr3vnUZfALIDMlWECZB8FWiPxasc5ILYMcoK4qB6zFtfzV3foEoM/qhtmqFz/w
 iuYQuqzuqoEyJscxZzDgyUQD+oVNeEsDaRrFDRyDcheXlqnNzd1YZU4ixq7Knx+ZPGa5X3X1GaL
 q5RIHnEo0FP6zrmKj+Y9F5mUzvUetujs/YAR2XcY=
X-Proofpoint-ORIG-GUID: MSCu09pG24KlF4X6TW5zjYii0-nsVcUj
X-Proofpoint-GUID: MSCu09pG24KlF4X6TW5zjYii0-nsVcUj
X-Rspam-User: 
X-Rspamd-Queue-Id: 94956100012
X-Rspamd-Server: rspam07
X-Stat-Signature: xnzcshpau7uenkhm3akz6ko3wxs881yj
X-HE-Tag: 1769014657-254139
X-HE-Meta: U2FsdGVkX1/DG/DiXAByu76nSfcQltOjGZi404t2+mywNiLOquyZCIv29S1FurbXadYCLBV/naHS5IOp/kOfGya1iernaGxnI4U2vgIOyXX/TrqQuWgW59h6jAVkVdg9M3q2bC0f+1J3iRCRsHLlpYcHtdpHPgOxpFC+zbZFUROD3YRXIkm4tJCcoT57ne5xZqaBo/oGzR3LK0F7HjFgfJSzc/cEpNpiJdCEwnHxFeuIgSU5xZO370XAPXoL3BJ8JXYp0lttp26Pmm/CqG6DPjisvt4nxD62IHbXKbhsbsN8OqCw33Nk1l/MB8faTeLg1cIVCbiNM4guLJY0vJ/yMWXc1BeSElbSf91Z532tAbVJX+2jI4AIvVbwSX6va9ZyaIXvUw7TXVIENyItjoSYn8+TZc7jpKP39nvgG+iSaQMmCRCSzqBa0mY2d5Rsc1Cj30P9mfw6IXRhEBIzmkks9FflEpqggPzeDKS3WWwWWYNb75rnTPL4JOZnLKO+nvyx+23yusB/hlBuGeJa9h+m0g4D/EeI+ZRspyDR8GfVK0yxnhsIkL5TdQCC0JcdtjbewpqPOWioInB4N8tBTvn8mW8ufdwwlbNkDLtVOR3iOWXOxNfU2eftHCjQtNn2py695EzMtFkIftvS8hyBz46ZkTApuGBPtQpxcw9dStfox8VsFqMUNzNbVh07x+7nWZggv5GMASj86nnI3i9lT9eJ3eApgI/KCCr/pXotLNy2VEOX9XHRUCMM9rXw96fDwOQQSzzPPvgBCvA11XmAryyF5TW/mZcIh1xdgDEP77IqEdYqNGukFsmCmhSgTzM6oUG2PF0ldR8ytDDEqGJDea/eSAPUeQ4nHF5iSlG1loasu+R4yS9IMaDM/tjYTxTN7Jo+jidDpXjN7XqYBizoh2FxufwCfJDE6qzAjAbATxA9tE6Nrpq0IiuIyt6Bj7iOAGzSaQcfQu2uUFFBMLPuA1q
 1gKDUHfZ
 B71a+kKCpZrkUlX84Zc94vCEOerdUKCY8hgpy/9umsZUJ6xTTO6Ywj+Psa0zYgLK5mz9zSHlzvI1YTqy1hOKt7BPxadRx8/SO0InSBq661hyjOMIAmG90hswMkwRVy5uQuI3Ci16Ot0azdhFvUHxv+DMzlcuN/t7/GaBSj6IZCYC7K7IIlgtRaJAiJvk9Jd7JrcHXSR6uq53H/LHkbDXm1FuRvGYC2dQet3DPEGnfrdcvm1sW7T137EQE4eBPdCkhFVqIvY8og7IlCwQjKN2CROM8cTz8ZPqdgkqLaRKCiYA8b+q8jikO9d3ztbh3IPBnKfCG7/fE2L4wswnl7zWuFBPUM9fCKcztlz/sZ45/uthsaQatZlJZVLg3zaABQCbaPkkEmhX62Mrok4oegPvtX5+znCi9ytn713bzlXAm2TCOBP+4/w7DSegrhaaDDEnqIyEqPF7qu8kOPmK/Rl9MGJ9qJ35EJR6HiGAciCl9RgszybCVaqdTSGEnFC1VrywjNelues8h+LEFcWiDi6PkKIOeY+Uf0IbhBo+QI0u+k2K+hAx3Ln282g415rh+/HmaDqFK+LaTwpreT/cOLkRSmNT1C487bEntWOjlFLtP7EM+CLdjXtOlvR8dophmJXRD2KO+beMZ1J+X2CoV+Ea6dwIqr/kwSeY7BYgyuzesAz0eZ2rJ9mfHDlti8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that the spanning rebalance is small, fully inline it in
mas_wr_spanning_store().

No functional change.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index f694a38ccd4ba..6d5aa2088d821 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3401,28 +3401,6 @@ static bool spanning_ascend(struct maple_copy *cp, struct ma_state *mas,
 	return true;
 }
 
-static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
-		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas)
-{
-
-	struct maple_enode *old_enode;
-	struct maple_copy cp;
-	struct ma_state sib;
-
-	cp_leaf_init(&cp, mas, l_wr_mas, r_wr_mas);
-	do {
-		spanning_data(&cp, l_wr_mas, r_wr_mas, &sib);
-		multi_src_setup(&cp, l_wr_mas, r_wr_mas, &sib);
-		dst_setup(&cp, mas, l_wr_mas->type);
-		cp_data_write(&cp, mas);
-	} while (spanning_ascend(&cp, mas, l_wr_mas, r_wr_mas, &sib));
-
-	old_enode = mas->node;
-	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
-	mas_wmb_replace(mas, old_enode, cp.height);
-	mtree_range_walk(mas);
-}
-
 /*
  * mas_rebalance() - Rebalance a given node.
  * @mas: The maple state
@@ -4079,7 +4057,10 @@ static inline void mas_new_root(struct ma_state *mas, void *entry)
  */
 static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
+	struct maple_enode *old_enode;
+	struct maple_copy cp;
 	struct ma_state *mas;
+	struct ma_state sib;
 
 	/* Left and Right side of spanning store */
 	MA_STATE(r_mas, NULL, 0, 0);
@@ -4136,7 +4117,18 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 		return mas_new_root(mas, wr_mas->entry);
 	}
 
-	mas_wr_spanning_rebalance(mas, wr_mas, &r_wr_mas);
+	cp_leaf_init(&cp, mas, wr_mas, &r_wr_mas);
+	do {
+		spanning_data(&cp, wr_mas, &r_wr_mas, &sib);
+		multi_src_setup(&cp, wr_mas, &r_wr_mas, &sib);
+		dst_setup(&cp, mas, wr_mas->type);
+		cp_data_write(&cp, mas);
+	} while (spanning_ascend(&cp, mas, wr_mas, &r_wr_mas, &sib));
+
+	old_enode = mas->node;
+	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
+	mas_wmb_replace(mas, old_enode, cp.height);
+	mtree_range_walk(mas);
 }
 
 /*
-- 
2.47.3


