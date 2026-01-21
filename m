Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43106C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07D846B00AC; Wed, 21 Jan 2026 11:57:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 051396B00C6; Wed, 21 Jan 2026 11:57:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6726B00C7; Wed, 21 Jan 2026 11:57:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C79A96B00AC
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:30 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 96BF91A0806
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:30 +0000 (UTC)
X-FDA: 84356577060.04.035F2ED
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 394E78000C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AWu25kiB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CRqiAEqX;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a09mnnTsWNk8ZDi1O5yzp+1ctxr1LUvOzgOJrfdz7X0=;
	b=cFnEFyIX2F9fwEpOwFuAiSeHUp0a0lIxuAOr1wBxOdVpovnl2JiTAxOZD2mBN+JJMpZyHo
	8C512TQXp5HGNTYh84VWXqCq2DmW29LxJIn1EHvBdqFdbEhOSXBT6cDCJ6HEm+CBmIvPhK
	sX0iWGH0cS5Tinz0mo1nGccOo6gw4E0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014647; a=rsa-sha256;
	cv=pass;
	b=vuvsioin3AavrppOKiGn7UOp4zX0YMLgv5QlF4h0hCkGh4uNRmvX5qbkdZGAg+hiOfFel4
	in5JwscqubCulaUMv6Fi4c3S+YjzbCpH8HLws6nFKyUpZ62wsxP1EIJY2az8U9eDfwbSVa
	LQp1bcNbVG21DlUOgMzVyJ87J3N+7NA=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AWu25kiB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CRqiAEqX;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LE6JZQ3418790;
	Wed, 21 Jan 2026 16:57:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=a09mnnTsWNk8ZDi1O5yzp+1ctxr1LUvOzgOJrfdz7X0=; b=
	AWu25kiBPglGwLRXrG7xFBGfn55ZDXHEiBOXDTUEuSMAXXYfRvQUTvQDVVKOWh54
	QIIg5DYAMnILJ8sWMrz2S1sPLSavjDdEmPuS5yFt6o1eUGnCjHgxhBLXKObAxmNo
	ZT1sj8dwB5SpWq1/LmlDXCs3GPqojsiemJiqoy83ddGlmewSSAU1AzbRbscHXlCm
	8boesNzCJNWIt/9UPEL+nsxHAQq6liuIlIJSjDQs5kU8LaGL/KzSUBtydX/xDwXi
	qQvBY2VqvV6+JNRCq5fW4e11qjfif6GnZKdGYPyQOC0ngwg6cmiW/FV0AFSlOI/d
	nu5nyoLWjhbSbmZkftHMjA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br0u9pe7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LG7dnr019003;
	Wed, 21 Jan 2026 16:57:19 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010067.outbound.protection.outlook.com [40.93.198.67])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bsyrsbw6x-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hH5sPSoJ4ysbBzRAJxypcp323wCxI+85WzIndQsyKRgpAPvPCcMvTYM/cClRujL7k1UqroRcxw3rl9FWcw/3gUrMRJZGGNopy/nzoqDpfyUQG99fHMlU9S1W5wcjunaM71/7OMW7qf9R9qdsqhAVwMf9uIA/ydQhNzTYyOvGwrq/CIC5CoLW1jVv5HXNCLtH9spJDuBJH1YKNsXi79QrBX6VQNTewT3z/egLtgio0/drtLuh2K5kw6Rc/rDpGPEO8EqpdTmhCxTb84yzBq6tfuBBG1n/FRjJcf0XldH7PmXconYhS7ahgnxEATeq94SHcXXycySuNNNv5gJ61XwKPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a09mnnTsWNk8ZDi1O5yzp+1ctxr1LUvOzgOJrfdz7X0=;
 b=M+dS/+jSCH9+FbFtmP8Jy0rFw3nGtWAhbEWwSpEbQUHi+FHd+CJeGKaH3Wp8WCJ6ZOWNzdHvLNHICUeHzKjjNt8Ou6IrXb1Pjcmw0qUGuYV/2rnv178uyLyFJNzcO7e5T8TJ/O4yJJQsa+rQQi/Y5xXI9h4O0amrriLK7LXQ4YtmLkgmeWEn3s86MdbTiza/suyPABO0i2c0OHQBGa2blhdpjjiY08i1NoA8jltklTYxfvvPsWXoBMARWvAXCMPF1tKABnDFA4RtOFkfWTdq3hMpMKzKPNgPNW1in6tuBKzAWSSEk04Ya8R1CpMLGdInGb55iOGPnxQRJZcrStNYQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a09mnnTsWNk8ZDi1O5yzp+1ctxr1LUvOzgOJrfdz7X0=;
 b=CRqiAEqX+VhleaVlSRjKwj/dr352bL84UuL9YmI7q8VoLZM0fbBcSwcBdUtYvXU4sxPdnYevNdN5wjqa8mke+52JPQoruXSp7JARbYAxV8KHRIXAqgEli5yBgxpfn4q7diSSBpbM7jg4hviZ36Y569zGIjP2GIEE/cSEHnu28KU=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7727.namprd10.prod.outlook.com (2603:10b6:408:1ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:16 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:15 +0000
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
Subject: [PATCH v2 15/29] maple_tree: Introduce ma_leaf_max_gap()
Date: Wed, 21 Jan 2026 11:45:12 -0500
Message-ID: <20260121164526.2093265-16-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0289.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::29) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7727:EE_
X-MS-Office365-Filtering-Correlation-Id: 54a4d0f7-c006-43bd-2f89-08de590e212d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9gjJTDc5gc8pSrqifuX5kV5JHw/uXXJ/LqHYzRnW8jOewQEH9JmcEM/7xJPD?=
 =?us-ascii?Q?v6DERtdXNQ+jSN/HWwJVSo8Kjly+RafIR6dLYSd0lhLtAQeXWjQEwCQkfx4l?=
 =?us-ascii?Q?muVRNXGBGBzo5pUwOTguJER0nFdsPinJO8pbOwEWcPYHaSVMtSifw0lDCZmT?=
 =?us-ascii?Q?dW2OZX518jL0rz25Bo2qG2SBJnAMQyBoTcl+73itOqedXmTOW/K+QD8Ys5Vr?=
 =?us-ascii?Q?rTsG2vy+K8RqDrDuL1AvSIJQlMz8BlWHavD06Yf1xfVvCSIMbhfodoszdUeR?=
 =?us-ascii?Q?q+6xYT3OmUTTGcdC9Gi9O4TuKE0O0I3IyqCXVSn10q5E/kf/vOUNWFmnZxRy?=
 =?us-ascii?Q?1YDftlKp6bo17Rui3CDoWU4cJFa3LJKO+un8l0nklGbFSPy3flqzCLVL5iOR?=
 =?us-ascii?Q?BBG2VMv7P8ow1MrYwuBVCyJ5jNahNt8DtpXY2uZHIGD2StFQutArjvlxMxyo?=
 =?us-ascii?Q?Lgjg4YP9JD6BfGH3kAeXuAeZWFkC97zPlR6gX1OEsA8waUv4ymI7P/BHcmtl?=
 =?us-ascii?Q?YzFpgAaZj4WiwazS9z6gEUvEk00mVGlb5m96++KMMQYbBZr/Mu+h8OJAR/kw?=
 =?us-ascii?Q?LJxvx/mhpeJp4EBSwedVdoXYA66f5/y3SvR8tAPoT/c03ErN9bJ9ozp4bG8S?=
 =?us-ascii?Q?OTbxeQSqBPMkCsOI9VTv4z248yeDGl5p1IlgTe1RtT+wGIpO15wRd4u+m3Jo?=
 =?us-ascii?Q?fc6awUcd/jmQngobwOes9mtpKJW+F7vJEab1yx97msiPg+IMg5RySXyOgp3H?=
 =?us-ascii?Q?9PotD/SOO6Bcg6uGqFzt7SZJt3ErfN3+DTtdWswzS5tH28Dyu+SNv7j2t1gz?=
 =?us-ascii?Q?oRdGe7NfBWYOkOc5Q8IBsm4SbjxaEnxF0AjUzzu8AKuCbbGsZt9w7bS3iR+Q?=
 =?us-ascii?Q?MoH3RitUIaYvBDOmEBbPQWT9M7KZYNK24vXpmLyxpBccQaXOiMxZNtTFpeyX?=
 =?us-ascii?Q?bXfHKNBbs7f63R55a6oZEewmLbTUHmkoO/54RXMMyrdnb6Gz7lSWW34wwLl/?=
 =?us-ascii?Q?I5t478wx06ro32bfVb5x4WhbK+resYGCtsdwmn49VME1t0tgDsbAnj9YsKy9?=
 =?us-ascii?Q?ZfREedXYp73m57x2qTY8jPvx8C5zoOHdAXgTHHoy8DelxxSmG9w7nBwAd416?=
 =?us-ascii?Q?R0nzyWNzE1oCKWO/8SkvfGG8K7GagJ9wfjIKAzfgG5OrIB0idfJOhMbD8/vt?=
 =?us-ascii?Q?+dyvK5liwdTCWnTfpxZVg2tWCUlFQkSJhqv14WQlYmTfzWaBTsHRudLEqUkR?=
 =?us-ascii?Q?+JjNnS0ctaPznjrwOMVAE7mNXcMV8YB13GdOCTn8rGSrC0lS9ILCSoThJZEK?=
 =?us-ascii?Q?YIGlum60HhV/EZ2m5QhKhM1IhQAchfz7MuWzriPntxX4kwt/jgU0L8E34GxU?=
 =?us-ascii?Q?lPtG4qjGulWObk7HpuXdhkf+M4PTiUMYUqJjbFwDLlzmQTjBJIHx0Ouzu461?=
 =?us-ascii?Q?JjMJ6lbHgUhJ8kaSpSQLejPaqAUZgkTHYbxIIEu++SKw+NSzY+2QytLelvWG?=
 =?us-ascii?Q?VZFLVr7yAOv/Z79Wj2+mTRjOmxgLRl0sMBofMlWTMRpkoxK3WbRhnsgdh5R8?=
 =?us-ascii?Q?2kiCaMz84ZU0ekWl6MI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?enUxt8SpuPy9h2bp6v9//Q6wfWV/rMDn3K5EvjZOD6FShhwZr05K8B3cdrDQ?=
 =?us-ascii?Q?DIAm7ortJrJhD60TvKIHFcoo+BHb8RzzwfNk3/dpi5DumHy7Ohn6+TKnI73s?=
 =?us-ascii?Q?be8sfp6Mhsg9ieGsgpnfGlVOtBhBzWH+NOUdOS1NJY0AcCKo0wdcsu+lVSfx?=
 =?us-ascii?Q?uH+mSOEn8XnjY7zaN2yYEfnGjAFPSLGlNYAV/RRWcxklqZeqkSEfSN55mAI7?=
 =?us-ascii?Q?OBgfIFc8NpKX4fH3fdOhXo21P82/pZtPeCCyQm8R1ernLW59l42rEGlBvYY1?=
 =?us-ascii?Q?XRhi4V0Y6DLlfBT4YiZFq+0dfA70HGDIo1o2xgeI8HYvk+M9V51NUuryPsDl?=
 =?us-ascii?Q?xJy2V/yK/giWv5hL9ErTKHbal/dS26NWM4cjBO2yrBw36/iq8cFvzFlteNh9?=
 =?us-ascii?Q?THxuE+OXh8JmP/gufqVBeiQmgzLcIawMfNeqE5bljcrAlu1Lwb5Q8rUELW5z?=
 =?us-ascii?Q?FoOwHoF0DNZx6Rt8WnS7dJObkC1cmdZrdvnGlCbCZLrzEi3QO3xWmBetzcuM?=
 =?us-ascii?Q?O8/F81aRGl7INgMzZrE9+IkzZ8/M9Oh1WyeFuHQIv2AvLx4Sbq4yn5ZvlpYe?=
 =?us-ascii?Q?K4NdsK6wt0awGLN3ioRY5Vp+euGfGmq9baJ1d6o0mAv0M55Avfm20lR1YrA2?=
 =?us-ascii?Q?ipxrfExYKsc+MC5PqCsxDQf3GLN7+vQyqalpnVO9+frj0/4y2QG/9kAgY611?=
 =?us-ascii?Q?VjDgYZbfyEcEyufVxnMuKGXju2Wxdx7KZyWU8UCPjLMnlJAXdFue5tlbsUvA?=
 =?us-ascii?Q?lI+qW0xSj3gyw1r1Ig0KoqtjCMwF3OjPXupP6FkbGI4VfHkRY68ynfKcEdIC?=
 =?us-ascii?Q?9yssOmJLyDOLl7RYkptHZWSWBwtCxSS5iaR3IuHqathL9U7t1u3Cu6SeJDef?=
 =?us-ascii?Q?3NU99WmApuS4VQlntlacM/HzmgYACMZ+tJEW1IeP1TjCW7gIeXm7gNNx3uZg?=
 =?us-ascii?Q?Z0QeizTJ9UbmqKuWrrvUn0rDnH2ukVn4wOiJKXMaUfXLl5lrkL6WI8Fv7xGx?=
 =?us-ascii?Q?Q3aX0y1u9StIxUaB+vfJDL8W7lgN3dmQ8pGIgZcgmGsKvmicU15KwQkfE9sD?=
 =?us-ascii?Q?Zz7DMJwP642a9hPCbwP/hC04DVyU3MqJo14aysvA/mLNhj5zAdZOE2zSG4DC?=
 =?us-ascii?Q?S2pX7SvloMFkPxc0b517jjly1dwoZOTDojZ3HVdiL+r2YaxG1D+3yH22hpKC?=
 =?us-ascii?Q?gPiKXwv5KjP0NkCIb13cJzsPgmYonM6oKG6qVULfxNyvs7hpxg69ZuaPRPoc?=
 =?us-ascii?Q?gY5V9Vov4yP1wVWesc1WGduWuuHshHhRH3hMw4JHf6/dUU0IIRrU5RsDTMhL?=
 =?us-ascii?Q?+6YBMcc2dk0PQSil+e0fRUFqqI1FM06398Y3EkhTLBxBrQIO2UuSRhqW67c7?=
 =?us-ascii?Q?58l01PuIHwvoMwhw4hSMwzqwwW0dYpOnRTB8oEiLeEgX5N1ALhFMPIDtARh0?=
 =?us-ascii?Q?zkz0Iou6h4fyUrbrYwyUfDTC/q+2p+1unezbusPTMV7Ml9wenE5tLVUT464b?=
 =?us-ascii?Q?3kJL+IgPH29Rpu8p+H8TZAozP+qbJh4LvGpuNOGFagC8vY8iZjxYuJZM4/Qn?=
 =?us-ascii?Q?h29tdPmjUZoU+nAqo8P7kM9Q1Gzb/W3ejBC04AAxNWvIqR8YeYSjrjUfwmrW?=
 =?us-ascii?Q?TYGFcKZ9Jh0miMJpDNziszhIcxWFmDLCdlqPt4qcbg8fzGBjHmdqeKAkxqFC?=
 =?us-ascii?Q?EXOa9Gz1twhyUMhG1NCHKtgOTrO1GPE/cH0cywGHpnOo3f1tyUDUGnQIK+Wa?=
 =?us-ascii?Q?l6zC9Zoe1g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	L3M8nE+BvFvrg3ZBJxnhJdNXiunNdHmh9Q8jCHydRSyUOllS68TyewkE/cL37c1IVQie0LRI88QTD0+qdsR3j5xxuGbT/BMoNpK9lKgimNvE4juY++gu63Aq32HGdJj7D8VEGuZL457FBKL9yDC8CwxWWf9wjeUPdX1ChQVHZ6iDfJ1/5GQ18ujuyWCiBlT0fTq0m5Vnh9l6EGOYlSCjKQYvKuDlOmIIRgXA890hXhfUNgPSH1U0ddznZZmueJKAZQoBhaGhdr3NIJNuSGrV17/eksTKdfxoe7uSYJfroaxkC0/xAfR8fJko7MWQKh2jkjKzLP6RQMzxFx/eBGEmTwFyer2bomLgRt4TeuEBGgVPdJ9q+vDy8lgrksLNBDZpz6fKxq0gySXoOwk6YgnkA1AUsH2zU09c4JTochj0M2Zn7m8BhC+tLLKRPF0pWX/Yya3q0wS5oWZDZsVqfgwAJX2IM42frEL2Y8GKHUYigwNX1ku9rqbfukDtpzmLhkQ6dyGYj//Om2m1VYehGM0LZTAp6/ceODo7IV98YvwpxigXDIRyImPGyUNfGBxZGdIPynu/MPBKL/cJPqZxfYK6F07XdkvUQUdI2OHjwhWsWOA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54a4d0f7-c006-43bd-2f89-08de590e212d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:15.5207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ry/px9Q/gSZPbKHbhwIg1dfjxcgGPBkl5m4naM60OWG6h8M8L9+HxQDy7Lq5kfX0uAUjtXvofcwby0/biJGaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=69710570 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=-3J-9aNdBi9tGdEVLXQA:9 cc=ntf awl=host:12104
X-Proofpoint-GUID: _XOcHqFxbAPkeRwKxKNsqfgZIF60Cf_B
X-Proofpoint-ORIG-GUID: _XOcHqFxbAPkeRwKxKNsqfgZIF60Cf_B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfX5M5yNMU/x6nM
 aPukUjCJcT6yX4ZKHXdY5OYQ+iC0olvW1h3ZZlre/JWoJkTptX77EIx9Ho939T+XhEFh/iUWIRu
 e/mkdpUucbW0lqGM6VGbi8/YUH52dEMBJsO0jHih1x5n062aRtliZEWlFJ+RMvxTpLFrdziA+OU
 bsXVcWe52TAokunizg5/BWvphAQ79lZdkeFlKdOdiO8JktRiX8vOp4l2ARHDC9y4IkRxvwXJSBQ
 VPLfg4s63ypPcwCyhLQ0JKcNSYwkWpRZc/zSsWaVA/A7sa0RPVu6Q1nhw0KuKEi99x18d4RFAXl
 8xGd/BUIl2b0mYln+CgOsJNDdPDV3gCqM9aB6Jcz2C0BP0swvkkwrUNq/nSuxQAgvqOWKarCFdY
 meqp45N8AzRRX5a9qczV8JxRXVCJzASZhkcZ7oPAKNA+nJfaeAA8cjX2b/ongDP4vW3dx/FWlXv
 NE6sNh/4PrHxRMmFLMp1ENUogXPse/sXsHTEngxA=
X-Rspamd-Queue-Id: 394E78000C
X-Stat-Signature: 9zhxjdz3phh53t5pupgpzfjxg4dn14fq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769014647-38146
X-HE-Meta: U2FsdGVkX1/FRgBWqk3Z1q156VNZ5Ar3LhdmhBa+zB/jocW3Gmega16xybG5oXJXqtLcO0vcxmGXLzzwGm1BTQvYK+H2cbwGW3KDo/7WJ1stdNltweuWWDzXpoMZ3WHKvcPbr1gfyanpZiDiv+6+KC6x28t62mWqlpgtP8i2fbsFdbqq6QMnVIIxRSZr46Lpi1w2i5jQRiUkEOJdTKwdEVT587T1rtMjdWT82P6htyIkNvAFSxXNvc1zkwRNHZF0hgjIcc0uoSTrVNuK4q88dvrUwtGjqWRuBlIlATkqfHh/1ijF7zSJqUSeth4nAcwAf1QFTJGylr2dSFoxcO35qUCcbX4NXMpG4rwZ96KuKfa+3howarKjphOf8JOANuQa5zprmsG7tI5yRXkx48r9ZjNn/ASHjQpQH9yTs5dhNOhR3A57fRSrt6r/+1hJtx8LrLf/FllB3mP0aK1kjf6Ggwrk+99hlStceBi414kcRDnrVe9Ly8PRjwOQip9rr4JFl90hjyjdejwADf6F37VQ2FVWhBOmKYCzZnJD5ezQIp8QvBNea9VbfretSwkorg09ynXmoUTpnFJx2RgF+swkKRsTXBNu9aUKmGOKxSmgpoLEgRIVbl24tEmPH9gNYmyJ0vePkXKgZkNW9XL3Iyj6bO/xSGhgnGFDhF4GkKC9xUahU7dhriCvSqSQByE6ScJxRdWn3WflrJEHSSjxemUMwv1uHcGZ8MujPXd73hGBzkOtql76QuuzB8lpNMIBX74iyXRCwCEf4krov+2UgzsrInlFk5sDjqtjcMX/6mi4GC/r8jLHGbkd8O9TSmjFndpRQw4AcaWRXg2+RXYcwL+Zb/J3KddAcI+5vxaw4xNLdHD9z2oYAiQptvJ41jVdkpC734+tGo0+BOUGCfAObDjInv8NH3VtWT5/wGU91q808EVE2OkiOr7tA5+6Abu2oQJXagHRKExLOPWMtOTspKB
 BjBy/eGd
 vNfcd8VrTn0OyqUXDcOVA/qs2j3SES5UFo0oQaMLiiSdqLFrbuOrIsETM9AcAbgN/QeGcb3tyZHQLKqt5waddBCdHxWB6Ws7+uFoni87p6ZX24378raB2MardNQ3668FA4ef8v4/uhum3b4mgS2z5Wm5IWwym2KmSxWj0BuCr4lZBtXxOSPVXtEW5cmXBoWaQYiMqtaNsahh3Iy47ZPJ3HebubyhNgQIoTsp9KymM/UHwahQUDR0tW2uPUJwCwmIipOY0wGJkcN+FjGE4hjkzUJq2b8oOTSuwTb0tmbRCLzpcMkh22eacQ2drHV1w4iqDI2fuLJQ1rzx20lILhd0Cs/yl+gXK4d2L1hOcaZNZW2JKVhifSyFU1zCXdU0BdNtvp6fyg3Ap74fIDfbyNWFlUYKu5QZe5MMfWa7Y2yoWbT+SlnNJoyYEe6rq+ROTcrU4zO+UL5ZaYOFlhm+q82zdM3BSiWmAc0aDH0vUCm81aC3j2neufLCN32rNsbofOhZ6ZYU7MFx6SD/BVuPNh7vZQ+YdnMj06o/O9TGwmf2NgUQks52jmVD3sfTudS7sIpbxTC5AiWC/zvAnZ6F8UT/PfP5DKfE7417JovCoqT0uBdruIKy9ssygUEptDBdzm8KgXIZPdabpmaTpR+6ebt+1LAy/qlcJf233xRjtBqa2OO3i5krUSNWIA5yHY7Les9XL/XHv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the same as mas_leaf_max_gap(), but the information necessary is
known without a maple state in future code.  Adding this function now
simplifies the review for a subsequent patch.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 48 ++++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 0d6f810a4a1fc..499cae720251f 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1315,26 +1315,14 @@ void wr_mas_setup(struct ma_wr_state *wr_mas, struct ma_state *mas)
 	wr_mas->r_max = mas_safe_pivot(mas, wr_mas->pivots, mas->offset,
 				       wr_mas->type);
 }
-
-/*
- * mas_leaf_max_gap() - Returns the largest gap in a leaf node
- * @mas: the maple state
- *
- * Return: The maximum gap in the leaf.
- */
-static unsigned long mas_leaf_max_gap(struct ma_state *mas)
+static inline unsigned long ma_leaf_max_gap(struct maple_node *mn,
+		enum maple_type mt, unsigned long min, unsigned long max,
+		unsigned long *pivots, void __rcu **slots)
 {
-	enum maple_type mt;
 	unsigned long pstart, gap, max_gap;
-	struct maple_node *mn;
-	unsigned long *pivots;
-	void __rcu **slots;
 	unsigned char i;
 	unsigned char max_piv;
 
-	mt = mte_node_type(mas->node);
-	mn = mas_mn(mas);
-	slots = ma_slots(mn, mt);
 	max_gap = 0;
 	if (unlikely(ma_is_dense(mt))) {
 		gap = 0;
@@ -1356,26 +1344,25 @@ static unsigned long mas_leaf_max_gap(struct ma_state *mas)
 	 * Check the first implied pivot optimizes the loop below and slot 1 may
 	 * be skipped if there is a gap in slot 0.
 	 */
-	pivots = ma_pivots(mn, mt);
 	if (likely(!slots[0])) {
-		max_gap = pivots[0] - mas->min + 1;
+		max_gap = pivots[0] - min + 1;
 		i = 2;
 	} else {
 		i = 1;
 	}
 
 	/* reduce max_piv as the special case is checked before the loop */
-	max_piv = ma_data_end(mn, mt, pivots, mas->max) - 1;
+	max_piv = ma_data_end(mn, mt, pivots, max) - 1;
 	/*
 	 * Check end implied pivot which can only be a gap on the right most
 	 * node.
 	 */
-	if (unlikely(mas->max == ULONG_MAX) && !slots[max_piv + 1]) {
+	if (unlikely(max == ULONG_MAX) && !slots[max_piv + 1]) {
 		gap = ULONG_MAX - pivots[max_piv];
 		if (gap > max_gap)
 			max_gap = gap;
 
-		if (max_gap > pivots[max_piv] - mas->min)
+		if (max_gap > pivots[max_piv] - min)
 			return max_gap;
 	}
 
@@ -1395,6 +1382,27 @@ static unsigned long mas_leaf_max_gap(struct ma_state *mas)
 	return max_gap;
 }
 
+/*
+ * mas_leaf_max_gap() - Returns the largest gap in a leaf node
+ * @mas: the maple state
+ *
+ * Return: The maximum gap in the leaf.
+ */
+static inline unsigned long mas_leaf_max_gap(struct ma_state *mas)
+{
+	enum maple_type mt;
+	struct maple_node *mn;
+	unsigned long *pivots;
+	void __rcu **slots;
+
+	mn = mas_mn(mas);
+	mt = mte_node_type(mas->node);
+	slots = ma_slots(mn, mt);
+	pivots = ma_pivots(mn, mt);
+
+	return ma_leaf_max_gap(mn, mt, mas->min, mas->max, pivots, slots);
+}
+
 /*
  * ma_max_gap() - Get the maximum gap in a maple node (non-leaf)
  * @node: The maple node
-- 
2.47.3


