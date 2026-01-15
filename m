Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E11ED4661C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA4726B00BF; Thu, 15 Jan 2026 14:37:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1AA56B00C1; Thu, 15 Jan 2026 14:37:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FF306B00C2; Thu, 15 Jan 2026 14:37:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B4BF6B00BF
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:20 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 582481B97B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:20 +0000 (UTC)
X-FDA: 84335207040.13.DD466D8
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id B6D96A0015
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=K0Ctgywj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=K+FoXUXx;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505837; a=rsa-sha256;
	cv=pass;
	b=mGv20VJ7bPRaP4eemnCHpMstoGXNKM4FyaMJnvFePSVKnGAKA0VImdvzSNo6vLtlA0B1Q2
	kJi+2fGZnectC48ST9wMeRFZ2UheqcTYFzLf/t3/gCxPbQwoqnDg+tLbYbG2M+/0VqmdL/
	Am8wuZ3aT02tsTVFPRumGkpWM2+8r8A=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=K0Ctgywj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=K+FoXUXx;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aKWESwbdGd2gU8YMlrib12CN9Xs5RivGZ4b6435VZkc=;
	b=fX4H8D/R8AdYeBE3LaDiqF7yEWtv/jZJF9T5c9WnP1MIDDDPld7vZ4i619Vi95e3iOVmX7
	gObYFU39o5H7kMspId/6ho1swGozGQi4qtlDHe+5EhBQfIZPkIhCjHc4P8kga+bLAsAepu
	yiOLxPDqFdXsEzM6KkxYm510ZuUdKGI=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FF3x4V1295786;
	Thu, 15 Jan 2026 19:37:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aKWESwbdGd2gU8YMlrib12CN9Xs5RivGZ4b6435VZkc=; b=
	K0Ctgywjkj0rLNfpVBHGVvKKPm8a8KD5tep3w/pp8vrAtbppIBsv6G3Yi0IUzoHe
	/Rq9LgvRqB/KqcuhD7NU8ChDxmzfhmYSpYqMxJCxdc4A18kfK5poRfB+7mIBMGBH
	Iy1MLyZyrN+7jNheKdytyrCtVxzvjr+JMZwNIq9ii8DygwSNSMNxXxK+/RZup1NH
	rw6oX0coq1dkNeQto/eKOyvb4B2GzEfmUvQV3Fck0n4Vbte5UpY/EsETNeLJAhZ/
	ZlC4nKfxqZX0LV9cQla7H6eRW0jIw8aNBd7hng6t2HZxhH3DeXOH7LNa93nT+V+l
	TvKYibmjUlBfqdhqKRmM4w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5tc3tsw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FJWfbQ031014;
	Thu, 15 Jan 2026 19:37:06 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011037.outbound.protection.outlook.com [40.107.208.37])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ngahr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aLAJeK/QsPCB/cEKEVUxhSrXZ3xpnUUCy2kNUA5Pgob9RooRdKI2rWGWS3AaJbm+awnsA5iicA/EZnOWSvFgAw1dn4H+Swd3MQoTgNUK7+yW06Ub9sCI7tSD7ZcLP0s2iea6cHnyFXs9CCuSE5LGS/N5LUEzvouBgh3V1TBUzSUcmdmK+hw9XEANiYuj64C1eFlX+YDFKRkCSGhxPCXbH97/IRQ2cIF2wFVG392VJzY7htwQyrkVm9d144nnKhvZe5lsGf7WQ2VF/fAM4uWMw6GRfcjW9OfVdGFnkQC3g/CNxufTaLu9VnzJFHZEVBfB6K9jAE/GMikEdW8jE8nC8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aKWESwbdGd2gU8YMlrib12CN9Xs5RivGZ4b6435VZkc=;
 b=tLTiuoBcymiYyNn3EZDMbrbQsHcy2lKAbY+BQk95tDXgAeBUAixm6CEpPNOnAGi6aSy9U/of6WD5gkcOvKSJTK4thGwHhlhgOZSO8PWhOE75bub1Oao0Vq0LdNHAFEcSCkAQkhdUWXZHHAUlzZy/VcIOqRwGTz1OY/zdk7ImUQibfc9eXbgQ/99HZBU0eXIEziBmdKakQg+1Y3Q/2FmKh1JsUe2WHD3159qM6Y+ne/ikU7NnofOOg3DhtBCLjfkfHOQx2K/AAM4jqEMx3YB0T/ubgpbPqm6m5zSzA+aXTRLUw/kSPmt7OqXoe1V7Sb/O/zA+I1xwviY62DdEW93Hsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKWESwbdGd2gU8YMlrib12CN9Xs5RivGZ4b6435VZkc=;
 b=K+FoXUXxaTgErrcO1QQWQHS1VTpRMHOpiwjGDMiU6O6RG/WJRzqjR8ULymPZ+CiiqjepOBUNMtCBwsz/nbt3EFz/OtyE3wWWPPzwXLcMj8uhlrSEmb1TQFUUOZAZWDkH5wgHMv2fry3jAF/2tx+5zYzsKDzsHgEK8DA2HeXi/9E=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH3PR10MB7703.namprd10.prod.outlook.com (2603:10b6:610:1a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Thu, 15 Jan
 2026 19:37:03 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:03 +0000
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
Subject: [PATCH 03/28] maple_tree: Remove unnecessary assignment of orig_l index
Date: Thu, 15 Jan 2026 14:36:22 -0500
Message-ID: <20260115193647.1695937-4-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0497.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::15) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH3PR10MB7703:EE_
X-MS-Office365-Filtering-Correlation-Id: afd6cf99-0b17-415d-354b-08de546d7567
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dvISO/PnS5MC9kWbUu1ZY/5c9aLDOOVChJJa1PAa/4l5ouAV4ppLbsKUMN1O?=
 =?us-ascii?Q?YxS+7yor2l/krGGih/O0NO8qb1XJzPL+FPFoni6tzI78yNEJX9qTQB0haUNS?=
 =?us-ascii?Q?WUkzsqbp/0Htsak3dAZHAnN/doGuJjM1Y3DrRbEbGgErlYuHD3ODFsf442Cy?=
 =?us-ascii?Q?w0Jk+A/5lJZo2tU7QnaMLtnTq9YayKlrfCyPTSht4B8FXnmvjxy7VVJow4dy?=
 =?us-ascii?Q?LHUY0epokFL6zeTZkKxuYzIu3GN/zPvE7U5QvSlGfzMoag2eZlObpER4yK7W?=
 =?us-ascii?Q?DwKA7vIjetul2uWndEU06PnxLmGSzDclF4vP3U0yXbWimB6noQAYYsxsnibe?=
 =?us-ascii?Q?X1KnYy7SmizdEAtQ4pqp+saEXakdpsnvR6gNtlsgvnpo0CN72apIy4BOSYwC?=
 =?us-ascii?Q?lvDg2vVg5TOKrsq6cPA40ndDR0d83no58aRFyqfdU71T8JPzgOlcJZjf8tHR?=
 =?us-ascii?Q?wfwRT0i7xhUs6ztm/qS6f5ZsPoft8cvyA+p2838g/cMzO18eEtuvdgmcfzjR?=
 =?us-ascii?Q?4OyTR2H7MNlvZY/pwCSO4kwKn/6p6vAZzX3CbF4LOdvYkax7rU3glshfcxc6?=
 =?us-ascii?Q?ao1OtGvppKmANKWHbE3V6XYEyRX3QqX+a0X37OJTyJp90oxuEBiUWMuHRKCD?=
 =?us-ascii?Q?n584nnBUXLGTQith4Br6w1ASBJr/unxBAJj6P5M1MY2iiYE1nESE42raqKz8?=
 =?us-ascii?Q?GyPQO2pKYCZw8l6yvDz0eMg1IWzlmJLNKf4J6IvHVJtYPVLbX2vrEX48kZfl?=
 =?us-ascii?Q?4Q68v1wWFzO4lPb2BuH73FaYtIZs4b2TCYbkJ4EPCIAF4CFNu8vXR8e18enj?=
 =?us-ascii?Q?qc154qupFTySzh5u58FzR3RGIHkwFjCeMBnW/41iFihBLQug18ZMmiiTNkjv?=
 =?us-ascii?Q?vVZlMuV/wSqz7Bsbmsjd9UNYQY2YTAFozcIu7YYcjwFNFNiXixpeuGnFoi8a?=
 =?us-ascii?Q?zOTQsQPIiAsS4f8Teyn1jsa1DxuiDdul1Mcy2mKmTuswlrFE4EQthgrKE4Dq?=
 =?us-ascii?Q?NXcjfE+oTp9PCVfVtQ2HvKgBDh5XycCMyeUdVbHJP+QekCZSvlCsD9mHghfD?=
 =?us-ascii?Q?ztsx9FNX9XfnIHKqSwIQsYPrUREqeecR3lGziek5kh3r8YBcXzuQsayiYhEy?=
 =?us-ascii?Q?Ac2XB+z5JnxX3GQyRYLBH0AKn/VKkCrmYNCd8zBcP1L0As0LcyZvyupjFyNI?=
 =?us-ascii?Q?IZ/j7fwJUI5vmET7TxqG5C9a39FVdRf37dJBkhBi2bimrl022reE3sQUrczw?=
 =?us-ascii?Q?yai9eX0IMYZQF8hh+yQdeImwld2Qt96Ww8KjrnJi1Kuw7vtexCE2Asw3N8Hh?=
 =?us-ascii?Q?nVLvUtmBg7uxXGaEt9VuqPqWRS6zN+c2wGQPOkg5CoE8VI4GDK6aQ/j0Q98z?=
 =?us-ascii?Q?OJUDhYSlERxebSo/OcShCW15yM/byophA2wjpyWuRV0x/b41blDT+CIxWz+3?=
 =?us-ascii?Q?1R5KMYkb1yzgUbvdYwlJI3AQ8hzV7wJJYARnVyj/e3kWZECelmbDf1oVO8Bl?=
 =?us-ascii?Q?elRS0rY8Bo5Zx52TDE+cq8B4M5MGM0tLeAlrB6LeI0voUkkfdaV5G8UoGhR1?=
 =?us-ascii?Q?Sgcory30uKIIdDe+qOA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R0MqS9mopySRDjB2rM8aYxyVAdz/AsUulrQ9ptH+ensM3UiPVIy/Y9o+adMI?=
 =?us-ascii?Q?TTEDmP9crlODVQdGGpSlr01/ht5zWIsxrR7hRqYjhG63xN3xWy7t7r++HIlD?=
 =?us-ascii?Q?Tt44zcbqlOtwNmWspOZWXbi9RZXkA8kjdIQHxP/6rkuhxc+8NhTfWLZkpYNF?=
 =?us-ascii?Q?UIzJi951cmLfbsBgC8XxOUwpTTdgSk1jzoWUHs0rY2wmDcLqXF1f7VVOb8vE?=
 =?us-ascii?Q?XW4OZWw5axUMw65Rcl22VjuA6I/kfLq+dMCr658kk2Z2yZPEbU0O+Gaz7iiI?=
 =?us-ascii?Q?0kZxNDgoryEepxshxOC9psRuQmUzvCIcWeDPBQNwVdkCTZG/4WDBvlt4IGGk?=
 =?us-ascii?Q?aP48w0JLn/gmOExbtAqGPFJwZaMzUeUQB07DzFleQskkYg4RNhy4TWcjMb4r?=
 =?us-ascii?Q?LWYl0QLRSCQlsXKP7crGs/6/JhhFNZB4agZBP9BLNZIm/ozNrcLLlfavdtNn?=
 =?us-ascii?Q?+rJ6mlwOi7BhQGQ2TFggUWMpdKpQY9CCwAqRkEoSR+wjWwXTnf4u0P0TB7LN?=
 =?us-ascii?Q?ks65StMufRHJ75uDeweBzLa6+GYe8dUnsJngDUSrWeSdlM0RRZLvsRSf8d+y?=
 =?us-ascii?Q?nMl6zMe4evMh4vPYW3VNRozEEntrK2+QDY26fuNHP7k32GYkDp2FMCna+lOF?=
 =?us-ascii?Q?dIB6m+SISbMfq7nXbPE46xlP1X261KkK68EMK5BAKy16v6vtR+AP8prfVTA6?=
 =?us-ascii?Q?OamBSSf77Lt/rShqHUALCRnUmCQ3TQass7SqMyY+iLsMGVduGDZaUvYKV+F1?=
 =?us-ascii?Q?AFDrUrntgQ/JwSpFiCMocLGnDUHIY5PezV8wtTANeiuBvv6ZBia6K1gN5Fip?=
 =?us-ascii?Q?MZGxSfI1j78Sr6UDw+DtrFZtCEmfcO79iVc+z+I4hwLLvabeE76pg2MxcKkE?=
 =?us-ascii?Q?FN/OXXYT6/jsBqWSzQ9cLxFhUNqAxM40ix2zqjV9q5r+5lVaqBjcGMAqswH/?=
 =?us-ascii?Q?QQ2OXfmH5HLFqBYKvH+Zes17AxoI6GI5+Q2cJkPXtncdRG5ttYk2qL9xl3ja?=
 =?us-ascii?Q?rfOS92UrUyVGqK7NX1y3LQ1m1+BLRB/eTElYu6AQa+E4HsDnsCsLxvtTC+Ma?=
 =?us-ascii?Q?HFfbwIJ0lTrqpeKKkVNRKImMPdCFidWLdK5DmKCDR77QwtkQULTa2A955li9?=
 =?us-ascii?Q?BCSmjhafpgFABd97BMGi8CLP2GgFFFfZluNl2P7mg7sx1a7/dbTfL71ftKWs?=
 =?us-ascii?Q?0Y0lX1ttMSlAmonfoEXGqmAYM6IxmLtIl2aoz6dKLYpVfDLlyFTQa6TMj5EW?=
 =?us-ascii?Q?9ngjqf4PfisGrPrMBuTlTBgoUIwjA3nXoQ3MYcHOoE+EfQkZyK+PYelZd5kl?=
 =?us-ascii?Q?icneOUYKmrEohUadnwol0PIancM2olzcTn1AUlMDUbhi1JjF9RyLLXpzgSPJ?=
 =?us-ascii?Q?RQn8q+spPmr0Xi4IsWDRO3iH6zGmrmHc/uPj1paDmw+rrCogFeYVnKbu/RRN?=
 =?us-ascii?Q?GFTpnC9ItnB7XT0TnLStaz7PB9aKGK/RXst2DYwiGsE6k+9q9PPBlAVumSa+?=
 =?us-ascii?Q?YpfzEu/PjiHDJ6qX8GKDMkE4tc1xghseIaPGK2AvXepCfJhSIREA82/lfdwI?=
 =?us-ascii?Q?nW3iDScE52+LvcUcWR9ILsOoRotDZH1iJ4epW92np0fJNUmPz0lul87sYmdP?=
 =?us-ascii?Q?cbZQ0+4Tn6v5i6Tb8/omGktsYrgbIJfuF5py5cicki9S6fVgDyz54NRRaBAC?=
 =?us-ascii?Q?f4fhhRbyFmyaWppv/hv684mJFZaFfEuliMze0P1cf+RETu2tQUsK2m5yAbc2?=
 =?us-ascii?Q?Om0JpyTXlQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+bkr0xI+pVCJ17wktsv6632+cgfZaCb0qNlLuVk6jOtKaOd/jcZOJ94hENc680+mMBx7NZHE9dZNChmGVf8A3ZIiO9waRQzQONKsQYnauwS2HtdcqK1JpbMA457HrSQYdmsgtExjvm2NG9FmR0t3qFwdiaUA01asFnZCiZVvDwbUcAsuddnFrr0pebCiV4q0uE/7b6YfvWAhKf82DCUac3FDJDEwCALV4JXoRJTel7UOiFBja/v4PVOAmx1hmYfqiN06xTMvUPVawH7kK2uYPoo5/sTwv/pcuK2mwr5rBLKXfKMTDykj5RJvWnLkmJHjT6szqh/J2veUDgWFQy4UOAN+raUgF6FSAMFU+0j5WbeybsE/IxMGOySWHsmtHl80joUdrYIdzd1f4gNrL9ocKZQbmlu6tQdog7XeKYF+CE6Z+uS33a7MKpXJXLclckkZ+cDnJ+/v3Y6dM5JUEBrAX8lA3XKNa/Q+Bc2+gAPlW8yPy4c2KMfS32uBk2QREecu7auVoWWUg/F+P7Gx4LkGiYiMcMQJ0+Mfq6baRkStoVrgMWIhHV78+kWXfh2mmff7RoaJ+joY3pkFXfQqFiqZIXUbsGpMoI9/olreGuvanHg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afd6cf99-0b17-415d-354b-08de546d7567
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:03.2347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nWjtlufuAP0a6mvoz++yPWbArWs/1qTAvdNabroJ4IAw4BQtn3BP8Qc3RujSYLeh+0Cc/aFGkqz18yMHS/ueBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7703
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150152
X-Authority-Analysis: v=2.4 cv=XP09iAhE c=1 sm=1 tr=0 ts=696941e3 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=sHg5AOaFVM-jeF-jK6AA:9 cc=ntf awl=host:12109
X-Proofpoint-GUID: EdH-Kw3QZNiwTUuiavqYMlXdrSOgR93b
X-Proofpoint-ORIG-GUID: EdH-Kw3QZNiwTUuiavqYMlXdrSOgR93b
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfXzUuLeXGU+ORz
 Njl5MEk63awZOvdct1eWsO9WjBdW/EZW1I6jhgZZjR8AVcagq8R6GFB0ORNBSyur4O1qvhbmZs+
 62hjrQMsFqa9UhTsciQF+QksfbMF9pS2wL8wOaahIiaSXtD/0Ym5+cWeHccTx1biiBMErRrp4+P
 8jD0mir7GdoKrY3FLZyD+Xqxwgt6kXCaxgzvS3M8TMRdz6PboDqdpAfK//nxYLNulO0KrdEt/eR
 HXBdWlPlUzUkA1HKYZRHCJ7COUx98cE2NMCHi8FMlpMMN4zJRm6hqWU1NW0wzCnHioRZRc0Tbu9
 blb0lBXU2zGONmht/P0DOxFDyM8o9SvDR4TpKo5Vf3t8k5tJYAREfOdQziqBZLU3kGgO8C08/YY
 koj7TQ6YfCKDepmMHhscPSyTLUrQBEx67SSbFG7Fhaif/9ZAXPT6YsonSgXFf1vDdPzFErtU8Ba
 v0OkLTZPnuGOxlpz83l9WB72XQwlZ9ZfArcGCZHs=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B6D96A0015
X-Stat-Signature: spwaca3kawztgrifq6s8ptz1q8c3ywpe
X-Rspam-User: 
X-HE-Tag: 1768505836-104663
X-HE-Meta: U2FsdGVkX1+Lv8Xw3PlCj9KyvbWCLARy+kv9Xy4XDyXyw3SLRmvOM8zKEcxuRYJ1Rg/mAMVhzA4BII6HoHlXtnwWKccNRZoZnfqiRp+Bahp4PS4w1vJLnLOXIXsV22uV4oDZyhbZZkpzUFp8e/8CySAexu+UJ90AcWnPj+LoXG4ewArOUrzeXn985Wu9AfI4D2Q+JmhIlXl/79ceX2PHRXjN4767kC5Y6N7wM623BhvKNJHZqC2WuIz1gI8NCt5uOCWchi3n7IEK1Lr+7eijpxuKdQFQ6oWfyennoo73RE+7KrLgHTYwctP89Fvrtk7AqnwiOGGXGNKWd76BCIg++uXEYObe/bSt2d8CEhiSUH8M36WSE/VelHOkHmPiLdK+8IQv6j86xM1ar2umx1fdx6Gf1XPV4LxJGcNd3a/08q34rsgXFH6RVZ5cHZdVJRZa3zqSj7KT1k6Bs16gWE41kNffkl8rYinieDv7sNv85liDu2dnb7qWjuTiEmgQPt/5AZwyr2zeOqy65HFMsnX0A8FNhCj9+HQHtkojwwfjTzrT32OX5E9rHYoXa1fMhvKK1LOOy8Ny1uhMbQ9b4OwWk2TKYQwkjOhZaTwFyb6Tw0F5zVBunpHb5Fjf7HtaJ/VLAflOr8XtAYdfdAzdcBUAWSztid52q7Cr7GPBk8mfZWo6oLgsqLfiXGj5+iRl6FUmSBB5thMJGcAECN1baCbHedgexEGCAuXF9sdPdMVLE/DdReHDm58uXaRL1Fw+PhefPU67RkJx5wplBBssJZVy8hgW1Uiczz6pQzj3CMre43PCI3KNJHXuH/fKxv6sC83w8tceit9GSF30rgXHL4WevVhFwoOC+5xMmUBXpQFD7yttAnDgOOEw4yURU43m+d9gT2qTto+2m0h28d0b+0ZQZUGsdkFDqFN1U2pd+J1PCFRbpf5vLAOjtTA8ii6x+5UbwOeiCij0SBp4eOWAgDN
 ElvFGwWQ
 wZKRDMyyAtGcEiZZ9O4Kdb3cVunLf4V1tZArNQw805fJltyOYZia+ZJCCL6mb9UwD8vorByhttp2uDPr0RmuDjhfUVWUvsHuP4jVrtF12/ysJiRzlGWilG9WgMOK/wgQPVSIGQ8qVobWvLUDD2IlU+b+BTI550cJkYXA+tVrpJGFMrEpHV8MLDN6KmA7RkHEW8reUwqeL6IMSG/TWVSc8QVcnulPFPTFXzl8qThK8SS1ep1lKgy4Qw+oD/Oq0jysOoAEE4brO6mZ80j4qnEdcAIsEKCgriX7FKxroJECtl4rahstGlUnb+PwYOJYa3U8t4lPM8aQ43iEH2jMz+D6gPYDzVNOGBUqk+r7agJbXpDerwdySvXR0aRIUyI8PZ+mpWEF8Ryf8YefGB1TLdNEJuFQsBg/OkldednihOusCL+s865YirFeNU3xSElzNKgrqfBJVEyxlZvb4lvEzINSv/wxMgk2zTLCZTUhL+YfkGa65Ez4OnFMXFyLIyqnsIwcAXZ1UfWuj2cvusQSJpNYalUbiqMQN8sht+Jo14K85iSMiiGFErsp7ezIBgA8YH6RiT/9rdATczeSMQgpeG+JKFekp+9qZLkaGWOJ/eSJcgfnmt5rPLSaL3vaeViyn7d3gZeQt4Y9ytpvjbHw9vKrJFMilXVr371CmWukcHfna9eBz9RhcICgVHJ7Stw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The index value is already a copy of the maple state so there is no need
to set it again.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 5cefd85a04766..5d1dacf95f718 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2766,7 +2766,7 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 		b_node.b_end++;
 
 	/* Stop spanning searches by searching for just index. */
-	mast->orig_l->index = mast->orig_l->last = mas->index;
+	mast->orig_l->last = mas->index;
 
 	mast->bn = &b_node;
 	/* Combine l_mas and r_mas and split them up evenly again. */
-- 
2.47.3


