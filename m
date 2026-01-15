Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21351D46604
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:27:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84A266B0088; Thu, 15 Jan 2026 13:27:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B276B008A; Thu, 15 Jan 2026 13:27:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700BF6B008C; Thu, 15 Jan 2026 13:27:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C74E6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:27:54 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 03A0F13AF6B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:27:53 +0000 (UTC)
X-FDA: 84335032068.16.EB0C7BD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id A9B33A0007
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:27:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BH3x08nL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="pkUZN3/z";
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768501670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2I+IGO+oPnXCYZ1K+7Nv92yp9U4aury6RijHzLSfHB8=;
	b=kTd7RN+K/tb65qW99n5tVhUkcVtTLluF57X2F/wUt+3metKFWgfTITVv+wilzs8s8H9L4a
	71LQJgAHzlImaAD3F6ByY7Aemrsvtjv3/JPNSuT7DgXFB0jlp1PedIv0bmJSdS4HI+YNBJ
	MzBT2iG5kGe+J85h9IwVyc+4exGhPrk=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BH3x08nL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="pkUZN3/z";
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768501670; a=rsa-sha256;
	cv=pass;
	b=VEKcUtOXagHdbDKgPVjnXq74W+aAx460L/CZZlD8xuikdqwmAK3YXJrdTcSorXeqCra8gI
	5bY2zROZFsieRsCJ3sEEpKd/uL2B9azvzKfEG4mgMqgSNRtb2wffAFf5qfiYtGa4PxDKlp
	+9p3w5BBfCQt5e0v51wlp/DT10LrIEc=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FHKiUZ2811661;
	Thu, 15 Jan 2026 18:27:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=2I+IGO+oPnXCYZ1K
	+7Nv92yp9U4aury6RijHzLSfHB8=; b=BH3x08nLaUkTrqiTXpuNzw8CpmVrVR6k
	myGbPPEQ68RQvqQrIuSHcOf+jKk37Zqbo8lm8yP4TKMTvf8U9Y6LaqAeOqyjgdUn
	Ex6k36YFPL36kH6B+MvQmB2Dy/vzx5zqgSf8KrFQfrjs1o+TDVFWChYmXg8FTzE9
	VJI/0s9rkx9XKexmvA3RKUvuR1kRzreNgUq4xB9gTywGRaBscac6fkTeUBMq3EXw
	T2Pz6b0c3TBg4BmQVyelT9VOm+8QhYgpcN0iAIONRm5aDRxhNxZRcLRkDIE19SH+
	h17JDCZ23QL01GVDHHaiV8TJZ8DejtCe60z+I01MiGiDSbRMGfNZpQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkh7nrhxs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:27:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FH5SAM029363;
	Thu, 15 Jan 2026 18:27:30 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011011.outbound.protection.outlook.com [40.93.194.11])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ndya4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:27:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FX//X5QSn6G6R4H0nPNM/aCCJi1p6g7UxYUYAkjEnuVdEWW3nv7P1JNPijU/IiVIu7wO0iQVZj5Rlv0UQUEHok7/s+qZQupa6qZBDgbYUyWmXel8nXLX68mWn0SGwVtQJmkZ4Gv/bQIaoatIzVRr0F7jgfDfKK5cgW2YiijB66vuvdpJIH5XOfEo4NvrysZ1C0PbQBSlE+S3lQ67F6PWPS6qcIcxQG/81/fUhlaNgatDC/I7xVIoDWZFBuW5c9z4g2NdXvh0xOCqgSqBjcsQ3JPl41N4a7vMKOHf/D5r8hTpbCzXauBaOj9s9KyfFbl7Cz2BoOQQ0GrRmnH6cuoKgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2I+IGO+oPnXCYZ1K+7Nv92yp9U4aury6RijHzLSfHB8=;
 b=zM4sesBn2EYxgDfTtleLRXVt57eV1LNZ5dupGT54e3Ow0gzGD2N2F6gB3r2CGqU0f+O5EY/JQMMJ+ot9EjR8W6pvvS4xuxSG5wAPQia+FDfa+PCbodbPCY9rhpFgKRo3e3i3aYYcQ85VysjWprt8X1kU4UcNHur1Gguht0Re+UvykxP63bX7wTKWqxkgV7U8ZpD1C58DX+g4w50NgROCYGMvf9Gfs3A6XDfQLcRfxeNV8GrgWG6wQq+2KG94WK1bv92QaeNTT5Q1Ye8rOkQdn7q/EVPWDUwdaq//v/CGuE6ML+y9JZGYLG9HTvhM8TWpqdjDJkb2JvedvhiubcLz4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2I+IGO+oPnXCYZ1K+7Nv92yp9U4aury6RijHzLSfHB8=;
 b=pkUZN3/zewxKw7QnuOuJtWaxcogjNfhYAbClgIYx62WurFtkfAiIZphuVd6/1CAxCSdXgw2i9exI1kzFnCHCUHCbNuuRV0frSuPJCb0hxQK7v0Y/gGav584clPRv+CyfvgGtzTmWdz/Yo/djpQVLAjKVvUq+7+vyUXsGbXnbWJg=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH3PR10MB7119.namprd10.prod.outlook.com (2603:10b6:610:122::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 18:27:25 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 18:27:24 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 00/10] Remove XA_ZERO from error recovery of dup_mmap()
Date: Thu, 15 Jan 2026 13:27:10 -0500
Message-ID: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0139.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::31) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH3PR10MB7119:EE_
X-MS-Office365-Filtering-Correlation-Id: bd0a8658-8465-4f1b-0b0b-08de5463bab3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Zq1uJLaugViqGIcyXHylc3W4Dsg2C958nMK5YoopAPFML2iqD6DukfhYJRDm?=
 =?us-ascii?Q?uS6CaX+clqUNioRFeC54D+lCLTeL1KEw/dhChrxOyNuYSUAD/IUpI4oOEKN5?=
 =?us-ascii?Q?SZh84uf309tSDwmJFdUm9gndkW1llCSn5RBvtZgfQKasRr/IGKAPScoUYuo9?=
 =?us-ascii?Q?Csfyfrw17WYh1jR0m8SV5qCWvX9r6lFK/s+6G1u7V6zNeETPtCF32zjN2abm?=
 =?us-ascii?Q?sokOKHIIREFTzuM8nPyRbhWDsTBMrFQtMrGzy0NkDkHzBCJThsQxJzWVMVh9?=
 =?us-ascii?Q?UGNyIUgK7/h9JDmTxIOd6tkx7f6RDxVlVYHTfqB44hS2GxmiPe7DQw88QfSl?=
 =?us-ascii?Q?HLkBNXqHl5YuvaTOEsewCXQhOFTGKcvFaYOF7I4AuiFDZwLNNMZI5osECvKV?=
 =?us-ascii?Q?YswbFY2czuGhDN1den680B4y3XEE5CQX6pwuqJaQWRUD/hR4yYIgBG/KtJdL?=
 =?us-ascii?Q?aLnxA13m8tS5zwJPUgvZCEL8fIUvXuW/meBwXDl25cQaT5Vbk1mguXGGvWfi?=
 =?us-ascii?Q?nsF/P0SbLldX/o6rtNrLT0mhm7wKhgATACNiIbn4b0nZGZs6UMp+iKuQnOXm?=
 =?us-ascii?Q?Dol2V+IA061amU5iZj678Q5wG3QaRqD6R5wYh02uPfPb3REqiKqw6RyCNVwf?=
 =?us-ascii?Q?gyerZYWwx5LIwkHOMdXCrwz1aikyECUiqiGEjQHxFIZo/gGDD8mvW06Z4sgI?=
 =?us-ascii?Q?EiQUiHlPUMPd8wF2KNoG3rXc9T+J5ke0sGxb9PtgXlT5ZsFdQvNY5g/LMoaY?=
 =?us-ascii?Q?4Qafz93ulqeXfjVXwbf7ElPQfND2u+6zMa7T4wDYYOeRaaLCKRz2aLbZcbYq?=
 =?us-ascii?Q?uf5iLOIX85JRR8VK1UwwP9AxnjTN5slZHqJv5eeqUaoa+FTYpfGKqpq8ftuy?=
 =?us-ascii?Q?TprdAcCiui/UgFUaH4qZPTnCoLmrQN/BOoZmeJift0pPu+VahpnasUXbAS4/?=
 =?us-ascii?Q?G71ZDvMQXqZPmW5xl87AgF4d+orlD3WgxPqq9ioUF3C61Iudjf0EPirpu14o?=
 =?us-ascii?Q?WvTy3Q9pN/j9hlPjt7dmG5WedsiSJviu6lzI4KHhmQOnoxdp9T+/WmAPAher?=
 =?us-ascii?Q?2ytZcXp/Hyv+4Dh3Pd+G8kdwC4d1UE7EkjWoIOMYB1nYIPSAzn6Cur80X4I6?=
 =?us-ascii?Q?JGlY5qsqJWWBGnt28gWDRZcmcnc9oCUD9djeT1TI5SWWHDnogAdH63IGjDjQ?=
 =?us-ascii?Q?oBPQbF8F4Fck7O+1G7mLiqyKfTii8PVuXzWhPTi5vlNnDJ0JdiH4j2dQ1Qmf?=
 =?us-ascii?Q?2pJig1W7kKZj1/TTrDiJ1BlP4T6nwZ4cx8FWw8ulwV+uOqNcVE+NimUxvgLi?=
 =?us-ascii?Q?/0p8p18lVspuo75N9mkTsv88bqug4cfuuwiAFbWbHTkKZXDO1WnSC9ZLAYim?=
 =?us-ascii?Q?hLAzlEFkNZWlfKP45Dp3qIln9V2RQp9q0smovyAplUBRLP7aJxFmCVyk/B7c?=
 =?us-ascii?Q?72aSmj+Kqdgf4T2nxgVAgtBDrSymQWdtoEuij0tQoq749zK2Y8olmbR/IdMz?=
 =?us-ascii?Q?/sAMTFphv7OK92Jm6F4nhZnbQ//eWVj5U7G6jU9lj4eWZDwr7rxJbJ8M8K+4?=
 =?us-ascii?Q?pzTdfM+0U6+DEi8srmDREER8Ml8QUcaPbXBkgX3r?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C9W2O/UZlnB6pC1mysRR3SKtx7v5A0o4zCXq1iHGRaFLqKEYxaUYcdi0Hv4m?=
 =?us-ascii?Q?hcgPecGQSOVhQ3lKtK2zh/ojfthZz6NRZ3vRa9FTA88S8ccW+888exBK95e9?=
 =?us-ascii?Q?k5l63qXUm3AFNPdv9nED+tKIuryDY5ltX49eyFF6Dff4AtCVh4g2Hex9K8SL?=
 =?us-ascii?Q?uVsF8zQ/yKibjZ9hlWzOFVv2DKHX1skGPUy2VrIoNEWzBtd9m43+GmKH1uDn?=
 =?us-ascii?Q?dh5BZGxvfUYEKaMSeJwd5sdfVvg/7g1d9rlMduLvQbvrpzisHHssBzsKDhjo?=
 =?us-ascii?Q?EDD8g9e1uA1zFEOTlk8tdOtToxFEy1MHu3urELAGXcfU7euGIn0OO2pGHMT+?=
 =?us-ascii?Q?BKo1qz0ih6JImZOc7/0gMCyhOWvKRz1Y8SLq7b0SjLYFu2CjmI97Su1hNIOc?=
 =?us-ascii?Q?BBMtTWwzg9BBQcZ593g8bx/8178LP1fwZqRHpHr5HF0o3Dk6FyGIdNz51dH7?=
 =?us-ascii?Q?UewYDpX/Yr5AL+CyG7gfb64r+tVdewg3F1tWKQYOwWDhpWxzTsGYnEvXxaRa?=
 =?us-ascii?Q?HnYiDVpc2QwiJd9o/cjfEJfHobVZvIVbayM8Tb6WowXH0h25w645NF8elDMm?=
 =?us-ascii?Q?AwA8kz//WhBWURNq4lzjhG8ZgCQZGVljL7dXwCCRZbmLG4LANbZVMAgbcKdz?=
 =?us-ascii?Q?LqRsCPiasA7NzG+g7VwK1Gs3Zz3ftdW7r5U7TZqReoPcmxdmMFZZzeB9Eyuh?=
 =?us-ascii?Q?vvMgI9RivyNkJeMsXF7J1rLOp+c1rlX3KOpWTT9LRH2hawGfHs3i546DN9Su?=
 =?us-ascii?Q?ptkNL/U6tspoUE4rKDjmbNw+x0jW7sMOYtS9WZIfRoIXYefkR0fe6MD3HU6b?=
 =?us-ascii?Q?4Mt1FqM6Qi3bpXh760hiccS4D51pMGwUMclFO4UvsF8SFhfhssrW+ojqUbbP?=
 =?us-ascii?Q?Alkq/Aj4dRBcUySuce2qeEh15tRKtBcJ7VjoorHHeoxxebVzbnpgIxrdMyAL?=
 =?us-ascii?Q?G03GHO7MAEWxcqjHzNgu1aadZN9vBvLn7jVHbV4XrJyoCccn7MjFam4oSDop?=
 =?us-ascii?Q?uFxI20jIrVjnSYXC6VOHq0X1qqlhp9EeQF4zQWtfgvLeGz7bDhVRLuhHChvH?=
 =?us-ascii?Q?K4GPSMBzLOzxE+C7OUrccQvG6NORrxRCyTM93ymkC2wBxSVRiniD0qcTWbvq?=
 =?us-ascii?Q?8th6LSstFm9TfpaFhOtcelu9+LDI7WyMafY8VQJKF+heMhkyjtrj+wZDy1dM?=
 =?us-ascii?Q?oOE1USNK6aq9Ux6PWxdOEvDP0+m/dx7SigOh6RLvu+rCh1Zj6DtD6KDyAmBy?=
 =?us-ascii?Q?xFbKoi73sPTVw/cod4eyKHvdZvxa15IYaWkJpBCAfZ7B+PM23svcAbvjfmBx?=
 =?us-ascii?Q?FnRSzczRLNOP0BuPBLCLIkutQlMx1Gh0C+8tV9WwCOLjLm5d1xKPc7kJ74Jq?=
 =?us-ascii?Q?AkinXwn60Z8eM2f3c+P5AyaSm3tD4MrGp4VT1WPtLT6sijaBe6aC9fzZYoA8?=
 =?us-ascii?Q?2zKboZvXQwezHYpasmO8uqydhQ0P9PaRz6UTScWeYtxtRYdIh/4OGmFTXrN9?=
 =?us-ascii?Q?gWg1bLaxehOogzQFwn5YMa9PAjufhm/ezQMdCUPN1vwnRRNNE4VrR42oJP9J?=
 =?us-ascii?Q?pILwk7t9VpaO9KJez8AdQrRENiRslkRrsP0XrvnBWBEnQjG4Bb2nj9oRCyil?=
 =?us-ascii?Q?o/gODXnmsspzhI0gCbL+dxeOh/r+zyN0MNwiUtY5KSUpWOZs4fTppGJL1DMl?=
 =?us-ascii?Q?S9j/vbRi/qVp6FvMEIBxq003I0WekBsHgeWcYYXzMvjLA09NCCViDN5ilZS6?=
 =?us-ascii?Q?thqqL/pM3w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ifMNMuCEbBkTTHDVJI/ZO8zPuHP1k2YiX+FhAEoafWDCPeiEjQF5YfOex4GKe//0maZXgyptawYLUG919h7/o2Ner/hJ9iY8tKNKXIyh43bXfMZ905IFCnL1ADTCelocVuxBOSL7zHfl4nFedXcRcTAkNdjlDRqVTSLuZs1fNIbUNUWKVFCqBQMbaQqe+yYWzEZbwO+HjQKGLKTTQatsGiYvWfDLTA2vBlaGI7Rh1pVu8lSPakdurzkPKp9IpQ3QmI5Ma+pPY88NNUUcbRvYN1rtqtq2h1lvPrYdmbj2aYIMpL76/Rt9xYAc2V64twVhwrpug5DpTgVtr208yskFSZzozmD1KmWWk1ME+ckydTddmInN2NFdVHi5DVRUdtWOX25b7Mrw/ohykGEyoLBZVKYkaNyQoAtOpUb3UvQPV0OsAag8jGiMB9aDP/6UVzjJYQFpDa/jjTL2bkA3wDT4lA0wjg5qu3Nxat8aLHg2wr9mTcYzmoIxFdwpuKQtk8bS8P0cSncRXznsAFhJNtMUgUG4WEhb4iYlyBY4OS735jT7SvXiTKhcHfDCOlPfX4w1Dm5IEO2M8DbuAjJ29sgDs1zL/noFoev7skmYNssLwsE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd0a8658-8465-4f1b-0b0b-08de5463bab3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 18:27:24.6095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HO4Qf0Ftpji/ygA7CWOmmVJZLPg1lJP1vPMH1aZKTEITvGrtRrIopKK+yvQjFQLEYiBm7d8FmOOWt7FmREwoTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7119
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_05,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150142
X-Proofpoint-GUID: Iv80dpVCXrdGF9Az7MHGkE6c6-oYDUk0
X-Authority-Analysis: v=2.4 cv=X7Bf6WTe c=1 sm=1 tr=0 ts=69693192 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=lRyk7R2wpmETDg0olqEA:9 cc=ntf awl=host:12109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE0MiBTYWx0ZWRfX1PTyppIG0/4l
 J8frmXGwuH9RN59dJwGzB5sPtxsi11KVJEGtyWtXWnVOhcal2hBH6bjcplF/pw/YnI32D4CEIGx
 2eoLDKRqnSW2plUqu5CMRVp0gY5lEyi6YljS2JNeZECo+6OfJqRDAsQl3UneDr+/k2wrdQngZWq
 4Ds20UuKkb+7RBsEsSw3bz2mS4XCIRi9rvEwFNyNh+4njJQ4DE7etf8fnJwDglMT5gJAtJ6lxaC
 MIYM9wIDzIOxns6Coa70CFIJnDgJygi1meVaISFUEBwiKfxKrY9sjh6qyv0Yb3ha4o8SA5Vp/oj
 JiWFdkkLM5YSICJXGtUAPmMDwqqfrr54OlENBoZ4NFWNnAleUNRl9C3P5W03n4uYnB6TAEAv+II
 gYpO4hC547lSW1oO2Ed//ML7xxkoTyCu8+gNFxmk0J0XFSqy2Egrkf2+ZMHQ7qiz5Gdipo/8AKc
 EyzE8uynW6iYz9oQXJmB4JwL9XBJiAzK48E1CLfo=
X-Proofpoint-ORIG-GUID: Iv80dpVCXrdGF9Az7MHGkE6c6-oYDUk0
X-Stat-Signature: t7s85a9rgfeegfpoab3jsfhfxaw17c41
X-Rspamd-Queue-Id: A9B33A0007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768501670-249411
X-HE-Meta: U2FsdGVkX1/sWUy76U/V1X91TJj4MeRyl4JXM9/Fvqx7jyxM9abOS+n3rv1Ewu30465Eguf/29emq8QMGbNzEvvLA7r7kzuTw2jjK3krf7VGNte8syFFkHyEb+fUXABB0cL7LMJ/tSqEWBE+Hm8rumwITRX4aEi1lzbATg6T/zE39AO8qBlsoSBH5OeXFroSOJDxNAAbi5PNHFuQ7lBnZZWcrjiqDIGcUeStmXnWCOIxR625QeOCyibG1OwJCyB5taFejmIDl6zYHAY/3SewsXgtoKP58vAuqHfDjYcE6OQcMIlr9kf8Kf6cinXyI2fmvRIKD3PAikdDRzwE534+FKIRJkZDb3CiS2DEMG+2+PniDyuYH0hMZs36SZ2EiVcmCuq/AOvljg5HgEDJ/zN9csez+XO6jhnkkfjjJdGqnTSJGYQ2mP1GlRz4ZjuBD3apGn7MKaGhug68hi70gIsL2tpoyJbMlFscxX1oXcFltgvxED6V8VGXMfTk756gxa40iDoMhuF4Y43I1bycQXw/96J54r2VzXFsHtOQrPi4Je+rljdT316nv4SZf39QIYZGqLZzG7qyq00iXFjcYaOkN7NhJz9sf8cmhira+0nHV41fAHOw7mx3UGeVF9afuxRjX9HJbNXZvUE7j2xnnU1QPQddSBEzMyzkpQ1rpLAGT0ROW9+2mocBtXOnk0RqArY4WiCGlY/jljDWvD+W4zx8JJU/37OAiCUWxfwXELWd5qyYEpoh6RXHJHHgTsvBN/HgiMoTdFXLPVgBfsbuhZgd5l8qF/V+FQz+6mwpBD6lkbfqGTpUB/GL8vHqmUSRwIXZ4ncnlnxZTqPKiEU2bDUeaEc80/fi7r4Zbuoxr4mlSNlY0i9YcpUe7mnryGyRnuxSDIvlZahaIEHgN8YSqVgYdqUSuxBVJiU5OxHafHgQHHw/lpxlmBtMYsRAUa9yEFWTwXw51p+bNTf+s5wL6X8
 ONz+vxFN
 NeTHsJzNoFbU91AQ2w3tNmBq1Ydun9MQ4btOElhw0FIxyg9agiKWJ6qMwkHO/5F+iKGeXULcxIUoO4P6ckcMWSuU39LU6IvwRWjsMnTFKVg9gIi1QqhWtWL93B+dwNvGyla9Q27+IBtk3NjmEypLTXkznrqYKvZ/wFddKIoRqF2L8tavXY6OyoHgWYQA+b3u63x9LIT7dku0brl7qxc815oSvRist6Qr9IeLRihmjCuD6FC99fL58+8poM1CaiiakpqeF+GPYxJ1RmNBoGr8Y8LspEBul3Mx0O+N/iRcygvq7qCmevr42KrJ7PLB7YsC4Yw3LvU9x+Dd1iQEeoNLki5biF4vV8RlyUDgqqdMdjPb8u6H4Xuxg3MDGyZ3t+qc2rEFM1nGA2Fy/AdHTn76knFX2U2CPbgnCDrPq0WXTSpt3QjarrHBybFkysNhrOH2dOCrc00re+U4xzVHkoO1CvBHYilF4w8uISh8/C0iqgmgl/SLgySmtKSAPTXXnBxl8m1uceHw01y8S/3uRncT+QEj4oc6WxO/mSRks7E6kK0cxgcxrwmPIQlvZlgvso6ABrMsUpzn5hgcrsV4MQKVVbn4HB0TOcBFfGR5egyFq/PwXGKC8ROikxtxY2F9yAMA2JL+oAanF6Txin702paFDJ1KXbQnfpkNIvoZO+rK06cegsd0oYPWaJgmcbfyzZDL49LkbLDakvskZTE6Y76M5DF8fMVvZ1rzm4J21nXeCdILRXKZUcZzkRNfyCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is possible that the dup_mmap() call fails on allocating or setting
up a vma after the maple tree of the oldmm is copied.  Today, that
failure point is marked by inserting an XA_ZERO entry over the failure
point so that the exact location does not need to be communicated
through to exit_mmap().

However, a race exists in the tear down process because the dup_mmap()
drops the mmap lock before exit_mmap() can remove the partially set up
vma tree.  This means that other tasks may get to the mm tree and find
the invalid vma pointer (since it's an XA_ZERO entry), even though the
mm is marked as MMF_OOM_SKIP and MMF_UNSTABLE.

To remove the race fully, the tree must be cleaned up before dropping
the lock.  This is accomplished by extracting the vma cleanup in
exit_mmap() and changing the required functions to pass through the vma
search limit.  Any other tree modifications would require extra cycles
which should be spent on freeing memory.

This does run the risk of increasing the possibility of finding no vmas
(which is already possible!) in code that isn't careful.

The final four patches are to address the excessive argument lists being
passed between the functions.  Using the struct unmap_desc also allows
some special-case code to be removed in favour of the struct setup
differences.

V1: https://lore.kernel.org/all/20250909190945.1030905-1-Liam.Howlett@oracle.com/
RFC: https://lore.kernel.org/linux-mm/20250815191031.3769540-1-Liam.Howlett@oracle.com/

Changes since v1:
- All patches have been standardized to <prefix>_start/_end with the
  prefix being vma and pg.  - Thanks David (and Lorenzo)
- Change WARN_ON_ONCE to VM_WARN_ON_ONCE - Thanks David
- Drop static and let the compiler decide - Thanks Suren
- Fix header/c variable name mismatch - Thanks Lorenzo & Pedro
- Added to commit message about the vma search - Thanks Suren
- Added to commit message about variable names - Thanks David
- Fixed comment in free_pgtables() - Thanks Suren
- Make free_pgtables() comment a kernel doc - Thanks Lorenzo
- Fixed order of arguments to free_pgtables() - Thanks Suren
- Added change log comment about cleaning up the failed dup_mmap() even
  when all vmas are copied.
- Renamed UNMAP_REGION to UNMAP_STATE - Thanks Suren & Lorenzo
- Split patch 8 into two.  - Thanks Lorenzo

Liam R. Howlett (10):
  mm/mmap: Move exit_mmap() trace point
  mm/mmap: Abstract vma clean up from exit_mmap()
  mm/vma: Add limits to unmap_region() for vmas
  mm/memory: Add tree limit to free_pgtables()
  mm/vma: Add page table limit to unmap_region()
  mm: Change dup_mmap() recovery
  mm: Introduce unmap_desc struct to reduce function arguments
  mm/vma: Use unmap_desc in exit_mmap() and vms_clear_ptes()
  mm/vma: Use unmap_region() in vms_clear_ptes()
  mm: Use unmap_desc struct for freeing page tables.

 include/linux/mm.h               |  4 --
 mm/internal.h                    |  8 ++-
 mm/memory.c                      | 71 +++++++++++++----------
 mm/mmap.c                        | 97 ++++++++++++++++++++++----------
 mm/vma.c                         | 54 ++++++++++--------
 mm/vma.h                         | 47 +++++++++++++++-
 tools/testing/vma/vma_internal.h | 12 ++--
 7 files changed, 193 insertions(+), 100 deletions(-)

-- 
2.47.3


