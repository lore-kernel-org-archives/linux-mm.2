Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAAC9C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0C5F6B00AA; Wed, 21 Jan 2026 11:51:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A89196B00AD; Wed, 21 Jan 2026 11:51:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 920856B00AA; Wed, 21 Jan 2026 11:51:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A48C6B00AA
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:51:11 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F33A8C370
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:11 +0000 (UTC)
X-FDA: 84356561142.17.6D836C3
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id C26A220006
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="SNOLa/xF";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vH30QfMc;
	spf=pass (imf03.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fGLlBXFxFAspnzKmOsHJ1rBSdmNQiTS5h4YWknMKOOQ=;
	b=k/75MgUl4YlX+u6TCU2XPnYIoDMeMTIr7baftXiWh6kjOOJV92qR6IGN/QB+FOYQrrXwth
	3Qw6yHhCrd3Ej2Ra1oZzP/Gcr7FSSvoiXfw1m+KhYG9nR1An+ZH2XybF5TOGaGNoEWerf2
	exMVowThHYQr1s6VhT5SjdXzFZEnU18=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="SNOLa/xF";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vH30QfMc;
	spf=pass (imf03.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014267; a=rsa-sha256;
	cv=pass;
	b=0kSPn+ItADfm8eDDOikUohezmyYUu2CPYyrX70GrENK8/skCYK0XKqAHBDBH7mkgElm+pH
	sv+JgAd1bW17JQOywoc+OLyexDjRx9PE0Hhv7FBs00o508drHdW+vVia6jrIZidXHgesYX
	v7MWuliGStblXXHBOdpL9nLcK0bzmN4=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LCiLQ23523936;
	Wed, 21 Jan 2026 16:50:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fGLlBXFxFAspnzKmOsHJ1rBSdmNQiTS5h4YWknMKOOQ=; b=
	SNOLa/xFUPbYBJRHb2YR0Esi3uOqzuv64mhCT9Icu0gshvcdDK/nICJTIQR1T+Jv
	5feeY1w+eFkG+mU/UUe7gIaf5wsaH/WWKBiUlOF3XMcei2qudHec2UzTnLF8PtP0
	Bm3xSN2iqRsSi8JswDq+SUxFp+fa0nCfbHcplMvBFj5ca5NJPWKtaGIkLsze4fZZ
	Zuv770Fv1+sar3uFh7dysYpL6NGuhyWUb9BFmNdhjDA3fSmUuLzK9UfKjOVa3/Ee
	wox9oKEfHeREHLOXw2I8hDqwc+3vox/+urkuycRH3Qtm+h9l7gcgB2fGtSSpy5DI
	m62QWwjfhSPrLFXaPgUAzQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qednt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:50:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LG5lZJ032293;
	Wed, 21 Jan 2026 16:50:51 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010032.outbound.protection.outlook.com [40.93.198.32])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vfacnv-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:50:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UB9ztEU17m0wsLjEWy0BBJhZW3ReW2HHBnDlGBTmQlZ9cHhmomypwjszf95Thf4EZO9DU27f4wL+Nm8403JYMQidxBTvduVhWf7a5glVTq0074dix1FeamuJCNiow9MxRSIM2F66tMVhPs7pYhI7ItmyR2ADz7tw5qFkZxQCqb2leP/WrK4ksAbQrMT/cvCI5CGpvYD4c1TylVH+oYiNPrTUrgrU1XN2V5CKSr5+5/ExrpgpDMss5k1a4beMtifx9mPPv0P1dnRJuhrFbkKYxIpqWoOGLF+5Ui9eKzlRWuwYzijXcIOb8omlWKg7MtIhgtomJ0i/gRdRv8aAEwkOmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fGLlBXFxFAspnzKmOsHJ1rBSdmNQiTS5h4YWknMKOOQ=;
 b=tO4zkztIkbtXymLS4loRioL2akRkkNTyo6ZzGcJdlVLA1iT8ncw1s5lBgo3Yrrw230a5HhuNEwkB2ybUgetxwwgZwKhcvD7ul2qm0jAiM478pJdSTxAGigOjYws2qWPf5g9+3kG6KLHafrJQ1tAyETCSNDICkgOWyeowWo6n/rk+VqYc5u3Qsw7eEPKT2qw/N2gUwQKUFzUhiCHKaujDcJMNxR/dwmdLlLt4731wmJNegwuhuJ/DDn/hbg8XFXf7hg8aoRCkf38I0Tw8y+QJj2jCAlh0l504JGLn8RM3UnONQAGA8AVhQQYWd/5f/sEVKv7TmG4Cubpcp/MYq6Ylsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGLlBXFxFAspnzKmOsHJ1rBSdmNQiTS5h4YWknMKOOQ=;
 b=vH30QfMcp4tEdUb5ExDHZEK0fEdkfIyh7OtlxoQLO9sP316oCC7K4XFVWYVysIu0IGR/dE3cXrbrc72AKYkjFooGGgrM/q8WlZwBtOskF59IAw79koPfNogOAjT2/NlMl5qTeWTIl5LCXYsM2h6gn8y4vsw6MZyRSCSVOt0twrE=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MN2PR10MB4255.namprd10.prod.outlook.com (2603:10b6:208:1d2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 16:50:48 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:50:48 +0000
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
Subject: [PATCH v3 02/11] mm/mmap: Move exit_mmap() trace point
Date: Wed, 21 Jan 2026 11:49:37 -0500
Message-ID: <20260121164946.2093480-3-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
References: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0305.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::13) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MN2PR10MB4255:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f38271f-bbd1-4b74-e301-08de590d3a45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z6NmplkqfwviIbSxuJ3wEI6aEqZNfxRt6A6MrHIaxda5MSrJpTZA4OwisIkj?=
 =?us-ascii?Q?nZbKstwu/GTguLZor/grqUX8Q4D4fMt13dvHUTe492/DCblxFRpMWLrKPUn8?=
 =?us-ascii?Q?HJEQuWvOFh0SB1GmxUuHRUY7QYm6Sh7gkRmwob7yIGhqTfaYXu8+Q6A05GLg?=
 =?us-ascii?Q?l1nXvLBg7BhrVm+910NfDLtoYp5vNj47pfO/ti9ufMUBLbQANLpUhk9c7YIg?=
 =?us-ascii?Q?zQZeUndaQc7hGbRKDYQmqrFRP6A3uUmWGHOLsSZ7W+GYtyOis2HUTNLB1rTB?=
 =?us-ascii?Q?CzdB4ex+WfF0/KltkIIKVTbOZvjQTQtzhA5FI1JeUr1aD472USyP9gapE9gZ?=
 =?us-ascii?Q?Q5h153rtpf5yQU7Yo+ZHXTU8uC9qoS8KL9O4eJFCoD2wlJRRPkA7ITKK4Cg1?=
 =?us-ascii?Q?0nSrqAegrBPV1BKjr1YeSUaVMqOc9vPkL2MIZHaRaUucwS6RqieDCX67VJGh?=
 =?us-ascii?Q?9UBWSEBvSm++QeYYjwoVfu+BfUN9eRDrzQ8xiWCETRg4pj9Lf7Lf5FPxcYB1?=
 =?us-ascii?Q?bbgk9R9Ql4+rPyjbECm89he726CdOqT0jgsil7DYwA6MylmMe/CuxVIpZv1N?=
 =?us-ascii?Q?mFmN8fLuF/XBoyJuNpQ4yixcrfIb/WVUaeRZS5gIB8i7OW6USrK4n7ae+O8P?=
 =?us-ascii?Q?ZJwf7z+YUwpYiHqGoU4k6XxERZTsFfOrGbtyvqO4DumHA2kLezMu+Qa5tpsD?=
 =?us-ascii?Q?nIMAIjEB2F14z0G3S02QrlF2H8v5Y14taGWpAt53nKtgj4kxRriA9Gczqw/R?=
 =?us-ascii?Q?g0IAyeuto3xGXHZGgQm7azM1wM7jTmeUXqL98fJ39OxqgUHkX5qdAGSvzbqp?=
 =?us-ascii?Q?0yl/ArpPXIdplHZmZIdTIbQunh3CZtBU8DX7TFZM81w1hdVGrY5y7S+kFdbx?=
 =?us-ascii?Q?fjlXUgbukpHiMssUsLjN/7ZpHAgkVeyDPiuitK4yQfhNZwJM15vaaeBmIoMX?=
 =?us-ascii?Q?N2q9B5MdYP2zNl1QB5TApmQMe8vQPBOT/J1Z5Hcb9P2+VK5uw0cv0koFg2UX?=
 =?us-ascii?Q?vUfrD7GLryOhbIb3NenhT00ddggKzO8s3ZNSKrLG1JypztsGrNYiW+j4pE9q?=
 =?us-ascii?Q?5XVTB8PoCojoJe2i0zNXZ0WKwdHzY/a/q0QxJj6BlhetK8IFyzfaFpBP6j9Y?=
 =?us-ascii?Q?PJSwkps8DyCwMmuSL+H/0lEKiycWE3HSVx/0lazMSL0nLyIO09jJP7lStwdd?=
 =?us-ascii?Q?pD35TCB/XqlJDdVA2Kn0N2YtO1bfNkWeKCUsBGa5k/eQXpDTIA3/V0fM4B8P?=
 =?us-ascii?Q?Cd+SVqqOZbhpMgWGtfxFsBCdgluR9WjBLr9U5zAbXvpfCDxfiXLnm7wer7/t?=
 =?us-ascii?Q?vnQYyioO6Dk8P8clklv7ZBtVQ3PvXzI/9+3AE4MMcZ97BBkPvYDUogfyUrDi?=
 =?us-ascii?Q?FVmaCKnJeNpDw6kfiz+xsUk/2W9K24qhmBaUgV3tLg9qjI0A6StcalHuTjg9?=
 =?us-ascii?Q?e4fZ4qqeOL2l0wXoiJtgQ8fssNTZvTKvBYtK6MFNxEorb9Qc8sPXU3m7yTdz?=
 =?us-ascii?Q?FCsRMUOmWd+pK4O6DH4zbT3LN+y8uSXQeK1uGzdV5/SWZXP/cRXiv0bc/4yB?=
 =?us-ascii?Q?dBFw9Uj9gXal7zPZSJE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lkuDKN63nL5HHR+GDrQtk0vtU2fpNlBSG67gqEpTBcJhpDXTm34q5bLtjG9h?=
 =?us-ascii?Q?mODUn4sjDRsy3jlPDiakmZFmhpzr7LUH0fVvLlEQOGsEA6GOpYol51B5UVsB?=
 =?us-ascii?Q?lc0IIclRegJBQG8VfUDJMFwmYbsra3oVVLYXwnxFj2dThbByqkg4UlJnzebm?=
 =?us-ascii?Q?j/6h1u5kNKqJOsH8A1zzm8Rg0zF1pUHbkHfcqtmFC+7t9rRYvqNulypRgJfr?=
 =?us-ascii?Q?x8cJxBQQeljLB+asReK3azeI87dG6Wz+fxqxHSDoARFCvL+HjtmpuUAPWYdC?=
 =?us-ascii?Q?0iXg0mOHjojFYkcVQq20OE7dSyxBpKHkPfvnvPrrie44COk67CrGntpxx7QO?=
 =?us-ascii?Q?rQgRh+ysEIKOJQsiZscp2A8QzGg2JC4Msp4QAdT2L3lx0ZMnqfLpxyVqOouJ?=
 =?us-ascii?Q?M0D8MefUp2EUeMxvk3rpTwfGQIAV/GiH7gyWwk98eLepdWyWptGpuWFIsMzB?=
 =?us-ascii?Q?ZuGxdtPjfqbu1wW9Vnb0Q5AojFGVAehRJn3NeziZFcqvqoEuXhNuj2hN5PgE?=
 =?us-ascii?Q?obB0V/6GlXyjQ7zkAP5Xa1DZSNZFyrKUEkwItbOk0l89IsQxcJZxX605WI5+?=
 =?us-ascii?Q?W9b/EGmzrC46juUgSwv4chTIFDoiKWQgtgxwp8xHzvIKTKVXD+gR5Oy6C0vA?=
 =?us-ascii?Q?8Q31MX1WmT8dceRE3OEKYaPemrEgQ615YAnYPHs7V0NqOOhOMgFoaGq3PIBF?=
 =?us-ascii?Q?3XtH07Eu1lCiW8R2L3rVZGOfUoXF33UqEbuTSTcZvRz2EqbRB4TZRRNn/z98?=
 =?us-ascii?Q?QiHB+sIZrnZHtroKGhtlg3ZKmtMxbpPM6VaEUaIBJ3RuZccAG765uId7qxvP?=
 =?us-ascii?Q?zVLG4m0+4GFWZbxD0PwB72diSovr34JklM/SsvRMfjldmo0jaVlDLjTW/8l7?=
 =?us-ascii?Q?JfX6PVyILVuOq72/inHKJiuSVXEYdFokgfu2IEsxZOUuqF7FpKoX4e97n9LC?=
 =?us-ascii?Q?jMgwBO9i5PlIKt11V23YFa8bneIfPXxKX//9WkHC5x2OtRpypByt22DGdXGW?=
 =?us-ascii?Q?dO5pT1mlDVAq/t83PiXQeqb9JwvswL+KZx7ZBXWRVW4ZaQlRa2apFVem9Y9C?=
 =?us-ascii?Q?M8Vv89tAVRWg1MYqlJJwYIuCjdGwcz2He9mXpRCboJg5kMjvgBxlS4UvUo9M?=
 =?us-ascii?Q?v02kEmKDaWOhYBH8VhHrZYJm0bt3M99NB6W69vq3pY2Gzs/lHIC8ue2WsFO7?=
 =?us-ascii?Q?SLClfcw5r49uOr6p+ax1D6hSwR0l5aNuNRwD+4yKUEqjhiibrKk7wYsoqn0p?=
 =?us-ascii?Q?w/mCt05xB+QbC+fqxgUAitwFLFJ0ZtYt6Mrkj0HnTDH1OocuDPnv+tRwpqh1?=
 =?us-ascii?Q?sG865kIlDWNo0Rfj2S9+D6li+GF29Ke6pb1mcsPIwJWV8+ig9P/20i3D/8eP?=
 =?us-ascii?Q?7Infn2/RLoDxbHET3/r3tlXNq99gE+YI7XbO4O8R0bYsMb3EH249zkUCNTbO?=
 =?us-ascii?Q?1Vb7JnCGIHqRldx8VMQuLVTV1MdJ/cTjVLQMJCKUlS+tcpVJw2NDk70RQyba?=
 =?us-ascii?Q?r/W5Qyre2cq0A0YiyjWeb3dbR7G0+Zw1goTKODFHcBFAyWs5NAGH0YozjZcr?=
 =?us-ascii?Q?l+BXXLELRdm9YjkTWjWf+4vjdEz71vu3Jn7QfUt0EaapTCpXvY6A4sz2Z0Qx?=
 =?us-ascii?Q?wyR8UoJe86jB2cdENmKt0Fz73Z25likKMiaU2raRRVxEZMFkvRq4LPD6PrQX?=
 =?us-ascii?Q?vIklrHdzYfoVUE6165z4TjneOGuTmplqnTqXdwcMGuE/BrG6XMQjB4LJSeRf?=
 =?us-ascii?Q?jNiugFmz/g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YPiQcatkH+zXiGYfRpUy15HnYwiEy0Mq2Cx8zvcptgibrfxY1WMYCof/DhRpKemskxws5wTft6tl6hesZeMeSQ43qP9t2hFzeDSbkJAVmzoow0HmCz9hsAEmmhwzByHoT+TMoj3V/NtwKwoL/08z8IHIBJny/UGydawDSzMPn3WInbOWTgTHQoUn+ve0+3pcSAoLxVbXz48EdePYzSagPbLvjr1DGjSFdW+yLqqvGlu4TLr5aHrUOzjReaXw83DyQK0iIcPfEa1Xyimsl1d2C6bATg0Wyym9B25zLJ485LrBETPWv500Ykq0COc48m9JhAmCy00OWFdiwPe1TCjKnjveCGtO6ouU7T9CZ4+coIqV6ZgU/mfIAnu96FNKHr+TKvE8dUJXkzT0cxsqLKHR3oNYuWy5gSQyM1CmH1vsWUZGwx1dlSirKIzR7+z34gmhcQV2vfc9GNX99k5lOZfw0fj0em3dxjO7fNTCdkkgyzyWee8fNVLCzTOgu+a8iDqc9aqX8zIfQ8818Jz0JnKYzXMUExsmev9O+gHsqBKH2uSCJFYO25VKc9Mz7Ihx6hVpdDxPu3j57/BiOJt3ikku1lZwNJDUq0/3/hLgbf5hhRQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f38271f-bbd1-4b74-e301-08de590d3a45
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:50:48.1106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3qImSHOr0oN37hgaOOJKMFzYUX7FXFQpVBGwETQY183QoD3HPW9K04v8KmPRJb8dTauQqzSeSp1wIsf9y0YI3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4255
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Proofpoint-GUID: gxpFQPFc2JESbqDzJSkLXDo3xQi56SS1
X-Proofpoint-ORIG-GUID: gxpFQPFc2JESbqDzJSkLXDo3xQi56SS1
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=697103eb b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=bdutT2PD6jGpcJvN99EA:9 cc=ntf
 awl=host:13644
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MiBTYWx0ZWRfX7MvfXutVy/5V
 AmB4aF2c8kzgblJOPaa9QNicS+qrAX1FkeJU2cFaHFoKo+L22llrr/F8CpiSEEaVFdm7/wnmXvI
 rBHjzbnkCaQpL7uF6dMZLZxHcosuZMw4W995bU5L/9QrOvZdbRYA5SSfK5oG5nhcDU/zZR2zz9n
 o8h7fErfVKPyAruvsUjdXB6RGhZvXpQfshavtPLFrMiWmU1P600BUqqBIUfDvpzo0ZC75BZdzJj
 M3afvCJDCVWCxSxXA5U4VYBh0QfLKp4IYSteRY5VGkG5K1Lod+4i3CBBwY9uklgFxtfF5rNqH5l
 CY+UzJg1kE4l7/RDQoGsSo5yKc2cqGVCewl0uIzG57nqMeEGIesqmEfjjTj/Uqs6gG9id1z3ncx
 BKXLxsL1CHL6JPsjFe6ua/Bqyid2jUSxbho/NORysbFSQzJSSPM1Cv1yqlB6ELSPNB4KX19OKBD
 /9HYd9/oskhe2JQZkvRar2S0hC56Sw62n6P+1AQ4=
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C26A220006
X-Stat-Signature: x78djrdn8a5g1ysh5hbpiixrf349wiqi
X-Rspam-User: 
X-HE-Tag: 1769014267-536887
X-HE-Meta: U2FsdGVkX1+1l+kLMxg4ujbyFx4eUhUQz53PNse8Te1YvBHdjja07m8RStuiiZuCQOiW0UJsRSehta1vtQsvP/CBeEKClxgDw39FEFYoZEQTV4pL5JiSnOI2+gCEOldQ/1+sQIfVtVOeXS2J0agYv/xruCWrw/b8Ze5gvNEoezryTG3A8LNBeMQ9Qn2gcVOw8BL72f+IQ0Pl0MdjGUM+LWgi+snICAENPAZ4jkNQVuXwhljtGfTMpTMrgCKfChO6UvHpu6h3lFKpAVAZ/vrc4wRJNajCNn8OFas1gb7Di035RhL1ZTcMsQ9xH9vx8Nx3p3n3zFvrW7jTPAwv6qgJOcafP0/pCbCR3Fq5BXbxjNYjNfxCFrNxm3zQzuTkymLiZXHxza+Q4ZWlirFsvNW1sdc8ikR4TxI5K7ggirmRYg4uecTn6+s6McYS4E69xhCHNmnhw6c0Kf/LLC59hf+0Oz/Ti41Ga9gfUMw6wVBU/mnGIf/dy7Ypt43/Apu2HE/UtbB5E+78BdI7KIyeGMZdwvqGMBkzppNEowdNnrfYn3KJiquWQOL/h+W01MrsJc7/aJYeT0FpYciFgaVT99M41W76R8VY2piLhIpLQQhy3LiON77rIZE9LiHGrvtC5cw1N+FX+Xzz2Fm+phAPkE6tFfj9A1f6RtdmtwMNut79+6PgmSzn5DyeDBQtNCmFTjNj/ZLD33ExoYnXgjFqplU7OxWyJnpDeKwGreiuBDJ3s0O6EUlaOtAOhdPypJIah8Wn0HW8zjyHtr1cEdVm7PdPwyvjeLvqSrFldpMvdm1c4ZiVkPZygNG/idKLE0nQ7zF+LlKOQBf2lrucmR4Rztc927HqHB4TK+xEkHeTDUJdeYNA0JmiHJ1vswnqhdte8BN38m9XYWGyIwQgBDodAslUbN3V/DJ1pSlxrTXk16lpcWy6/6PWo6+tAsJXOcrA4JaBIRxbsoF/RRzYxdwGDzC
 NDyoI/HC
 8YFMZBun1j6RsAPXdgEpAtJIImkXRHO09MzTbRoU1gD+c0PLr+Z9XSuuaFjY1Al2oiGip76l6WKcGrtcA8JKl0QIhdY1Ils+JZagIndTPBDslp5+nw0aEDqSRHv7Y4H6MU9GzWB/XZdPdfjtGHiOLhxkmiBPNGEKS7HKG3oiMiwVHeqCgNF909aDMc0N7hGy9sa762fJPXui5mzPGJR9pE4uak23hP542D/lKyMO9osCg9t6NXMylGgjXfyewElWs59bNsoE1gJpGFrb/qHveORYlN4QNMqf8TAQPeMmO9bhhr//+VcRCbeIFDdgzl2wZ93tLHfSrVq1qX0F40ZBVBeusV3Z3vBGay6iMc/wwsdt41U07ocmWnT9eI+bBn7hTSz8lPteoGuRSzAO7yHwbLxRVCR19LL6bgKPS97fgiJekRM+/SOupNHtq6A89uaysZiPy36msH52ta7nFO4NsKooBHqJH/d48nx1mU4Me8tKz/0vjp9UM37pPu191bjvXd7/XZgKIkg7tvcFNoRJ8/kgXKHPqdq2Vu78CC6AYsYpLmh8IFfBSL695U3yu5C180OW7+zEn5JxhDZeLZyRgnf8sCtYDXDcSvJJjyfABjcdlOhCxkvpet+cuK0SECXSndzwZvqC3ETkY/DTmmJiC+hDTiW0Ov66DtKzyBCS7GteMoqliP4rjyIHA/JxC15ZRGrn6laZ1ymLzsIRiS8cMZ3qf6VaINI+cKJDWKd9ByMxxCZ3lqTA9fO3XmK5KqB74OV0AZGPoVGkbfYFVtyqbL6tV+aMaXqgEYYNv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the trace point later in the function so that it is not skipped in
the event of a failed fork.

Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 4bdb9ffa9e257..1f025edf8d7d0 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1307,9 +1307,9 @@ void exit_mmap(struct mm_struct *mm)
 
 	BUG_ON(count != mm->map_count);
 
-	trace_exit_mmap(mm);
 destroy:
 	__mt_destroy(&mm->mm_mt);
+	trace_exit_mmap(mm);
 	mmap_write_unlock(mm);
 	vm_unacct_memory(nr_accounted);
 }
-- 
2.47.3


