Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F41ECFC503
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 20:24:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2098C6B0062; Fri, 21 Nov 2025 15:24:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1962E6B008C; Fri, 21 Nov 2025 15:24:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6C606B0093; Fri, 21 Nov 2025 15:24:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 468EF6B008A
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:24:31 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 039BA1606BE
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:24:30 +0000 (UTC)
X-FDA: 84135741942.10.0E835AA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6372440011
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:24:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=evlpZ3+4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zs9IpSLz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763756667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7YJVfgIlnS5kANFa3xwseJm17GMLncyCGn4THht150=;
	b=xVcJuyEFfVMr76k/rOql/HKKA8iffaBYF+5NLZDheR3oucvxW78EyxlGqOACCZUhX4E8eE
	So9aa6lNK3qhK96YqdAWA0b38AYyxZUaDYCrIqL5w9ggiL8VC7anZqGFTxQzTTmIHjQ3Yw
	LhXUZnQxbRf8KTpTD0yO9UjlBvTTL7c=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763756667; a=rsa-sha256;
	cv=pass;
	b=Ux1k5wNIiPdQng/A/vKJhe/pjYXKNdiTe788vfBPXLFz6Gz/P6MTUIi7iP0WEmkeW4fPac
	9OJ+Pq+loc1RtDwie1wBw1tHmDUsFeLK/lomwZ6849BMCJqac/dVmdQuIfWUNv8KsIESu0
	kOyk3bRx7vxU0ymm2qVMly8rVkXgFog=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=evlpZ3+4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zs9IpSLz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALEgsWi014546;
	Fri, 21 Nov 2025 20:24:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=A7YJVfgIlnS5kANFa3xwseJm17GMLncyCGn4THht150=; b=
	evlpZ3+42tJehOaieT+54xCQL64Ct793aPC/uw/ktMJsaIdzUAjJh4OQLnDE3z4l
	p2Mu7I4E5zghZivEsiPdgyMnBo4qpzKYdgqHuuPzurbaKC2mCSWIOQRAl08tqwDn
	/x3vjBzAx0mqwJYI13Z6uL9aKM6cu3Idnb9AVcEc/CBtUh8nNgSrxhhXiorTPRMn
	lwFUQIT/LA7qiLw8sxxHQpDgWzQr7gwnY8WRKS1ERD/KuvN3Fgq9ZVNwTyokPXnl
	XVJdBfO1luUio3NVe2UzI6bqOEFrU3sREWV/Lbr0JjtZmPFvEj93oTxfGZjoxoIB
	CXizs+s9wxNTNZZPxO/+nA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbuv6ge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 20:24:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALJY0Mp004449;
	Fri, 21 Nov 2025 20:24:09 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010023.outbound.protection.outlook.com [52.101.61.23])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefydufpv-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 20:24:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mBTokBD7BlEJ0hdTw0pa2RgY21etB7jY+fIZoxJROGVRhDzKA7FXbDw94Z+zDUX09z7zCL5ygevg1lAROXkFvorCLeFdeJQExdrNaLXRDwPxI214+tSZ/aigzP0HBIqVL09ukqfqlOAkvIwyzZgOkEuf68kqe5S43PT8+OSMHx34ebVGZHdVyY2V2ieVEfQQfMCA5WV+cDhBBw4xzDUBQCWHB/LYn5dpC1/q8pp47+2EVa7Zn+WIlnY1w66pJutS2kPuCgZ7zq5qnPVv9a8+UGhyIjZPbHMLNYTUwIwiRje64rObQeX5xwV4uCCapC7mjs+iw3LlMwItWDuMTB7wIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A7YJVfgIlnS5kANFa3xwseJm17GMLncyCGn4THht150=;
 b=aBORlGxpAfeiZlvxkjOnj08HW7S2QuukeZKrhzGuElZnvUZfj2QG7X4I2bN2EwL20cuQI9GcEGY6nhOc3aC07Xg/tJto3GKhrpHF3IRTF3+r2bhknxBT2AxiCXEn0HZOvIZisYjhwsoYtY6V+TITkHII6UAtl06VSh4upIzxVpsAQ02g5LEE36rvbZlOB1RNGvfDZqBkv5efbmerCDYjyNA4ezacedyFfWmMqDuod4vKaBqfl409xLolBCS8BWh0bkM5bvgdg6WC+xy0DgvyBN9zl2U+ZikGM/eI+Ex6coi7MQs3MbLKMaHzvS6re/DUwM7awgps0kowMkRu0lNDkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7YJVfgIlnS5kANFa3xwseJm17GMLncyCGn4THht150=;
 b=zs9IpSLzGAjyNtGewIGKQAKU+y9MP1f2O5sCXbM8d6QFALZo5n4QjlnthJhInfW3quJFVfSWveT/p9FWpTP9m+xJO5yjCShv67XUDUb623r0b+rcyuMYCeFYieVedOVfJssFakOw2k7B4enLQ/TnjAcotgzFNTRlK82Kdy1u0m8=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SA1PR10MB6470.namprd10.prod.outlook.com (2603:10b6:806:29f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 20:24:04 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9320.021; Fri, 21 Nov 2025
 20:24:03 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v9 4/7] x86/mm: Simplify clear_page_*
Date: Fri, 21 Nov 2025 12:23:49 -0800
Message-Id: <20251121202352.494700-5-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251121202352.494700-1-ankur.a.arora@oracle.com>
References: <20251121202352.494700-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0050.namprd04.prod.outlook.com
 (2603:10b6:303:6a::25) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SA1PR10MB6470:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e220f75-0ef7-486b-949d-08de293be95d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qqNhLktrZGrUrRG8pnyU7ZDmC8C3xr7jK4hCjFPRim/k2Yod646Z1FinYz8T?=
 =?us-ascii?Q?LDbuDou9TF9LO55TVgBT5lgMt6EPdQzD/m11S7YDXzGWur9IIDPVtjqrHyKw?=
 =?us-ascii?Q?zixkMWKh8+rtFlJ48VG9RXO2LP5WKGyAorT5LC5/ws77HTrryLEDU59NQZGv?=
 =?us-ascii?Q?qWKCZ2BpBAVEYSg1uq8UHb8w/4KcxSA/lKq9HEwW2AH2PGDyxXkKZ3PgY7mM?=
 =?us-ascii?Q?Mt2BpPKTw8GlVxc8InaWNNIjqN068MI7RxFRHg/+NLIgAYoO4q6+6Arx8juF?=
 =?us-ascii?Q?/Ik+lOhH6dIg6kg/xaAD4sUYbwCf7HrU53Icd8SYvG2ShUQm3a+iclvXSToX?=
 =?us-ascii?Q?0DdCIvJtdY4KFx/YUh2N+IxwDcLPTm7N1dhElVYOhJq+e6cFWwW3QeEcq6hN?=
 =?us-ascii?Q?GNFYgWLkt8WDT9cJWH5dr4P/hYhG45jlEXgo2FGtY4UI+8qn7ADiS8MG++Gk?=
 =?us-ascii?Q?uUIqMVyjvGsPserbO4g/1ybcF953IwHFSg8DH+IKJWzMzO9RONUj9G0J8Z+5?=
 =?us-ascii?Q?iKyHWFhjn/h2GlyMv9m3vdFhLpMOkBYBBkYIYQfCuBWTI/9mucDZ8z2yX3aD?=
 =?us-ascii?Q?LQYlR5pBXgGgWpwN2IIwAQ72uOL/1tr9g9nJdBHYdaLYpRLQHm7hxANAR+pm?=
 =?us-ascii?Q?lGCgve7dizJRxCGimk80c+ziPVQGOtcCW3+3UgZ/ltacm5+Z4nxy7udp5iF9?=
 =?us-ascii?Q?o9B6Fy5P0efThWtzWDRNmUYqYjlfWVgGyAjq/Fh7xpQkkRqtfhej8w1nXj4u?=
 =?us-ascii?Q?6p1r23dMf0q+Rh0ny1YyKhYe6kJXoS5ikaDaGaKoOxAlNC/StfLh6Rd+//Mo?=
 =?us-ascii?Q?TtlteUruETZkUN7exhSonrsqCjuvyMAOei5OkpzKyLjbjUfqWEYgxbio7kCM?=
 =?us-ascii?Q?Wsc0nddcKqszRYkFYfBNyGrEd5y0i3lRPYpBmVWXMyTYVmdID+DpzDw7doCo?=
 =?us-ascii?Q?pSb+WuJ35ZJ5655vi7yWUx1pyQu5EPDNmqwpu413w423MlR8RugNH62Nebta?=
 =?us-ascii?Q?ZFhFjvw05snzxJz7ubk+h0b7NghagJqm2RDe+BQtBAg4y8S/NU0vxPIu+1q7?=
 =?us-ascii?Q?m+pfdiLkDEgo1Be4Ig80qAtfIeP5hvdkz3T8W/wr4uKIgBb9mcxbrGXW7PPE?=
 =?us-ascii?Q?xnROlmoMxRdwhci7ti3AfaZvww14cAQi0H7xqcDs7lZDvr36IQ11rXZR+VJR?=
 =?us-ascii?Q?+UZua27YrGe8tLWafEoGYyNfLnKUd9OzoaZtifwlb8WSwkbbtIVOGIdJVpt0?=
 =?us-ascii?Q?fR321rsEid1aRtAkqdZBZ0AmN+41iblXXXmHVJdUevG4zaVq9ppRJiH62uch?=
 =?us-ascii?Q?/7ZqdG3dvt811kCh7K72nYc3bmAGA6ey+79TxBibWI4GFjGvsMWru3F5i4RL?=
 =?us-ascii?Q?GdVhODhsOxwQ58dtno8JA/GI0JK7n1LfhyFnoDruQ2ngzxPbWjooi8pr1brK?=
 =?us-ascii?Q?FCm61itf55U0+xBcy2vFgDdvvYJ36U/O?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BLeVihZ0S4ipV+j2kWgENgLDm1UtqELNZENfu5WZozxcI9HSkXdkxmjigQFd?=
 =?us-ascii?Q?4d7QkAXMMYCCqT6tnhmbxHMMwroAj1NZj5WGvWrDS532rvLkzahRhq+eWSob?=
 =?us-ascii?Q?KK2ttMg2ZVW+PcLwBD99tvUJz3mICEWGH0nbFtiqrvg6SBoycjvpQWeB6Qp/?=
 =?us-ascii?Q?AoFDh2zvY3RIb9jWbyzXLK2yvYpnwXk+qNgsLxelUWr5SwrcGY+Vros+lTNG?=
 =?us-ascii?Q?bD74wYecWPG9QjMSIlMFp7PrlJZBFFyodMOXe4FwtjBQ5+EeU6Ap/6S868u/?=
 =?us-ascii?Q?m+JoyZb8q/VASJkwTFCT4T4vead4mW9mpNSuEw7fcH5DNCwR1TN2epxudqnB?=
 =?us-ascii?Q?8ccUJXZZ63ii2hebD0N+r8apRjoc+N3YeAy+wK+9HLP5qHWFuYQJf9AS+ijc?=
 =?us-ascii?Q?phRB6asOuN7i2kw8W29gi+ksQVE7i1JB8glxARjFZueOz3mj1LjIlfgehzvq?=
 =?us-ascii?Q?6ca/RkqqykHqSPIc7Vae3adUQfaE8SFsDNdYre/uXZa2YNnvMjxbuH7txcV0?=
 =?us-ascii?Q?+nBnkY3HH5iewjRHsLDlhIIpoRzezlqwyuCEH5Goy0CpUDrnyP6LbDyr93F9?=
 =?us-ascii?Q?w7XcQu99ToOjkqvEVuXmzLc4Riau0o4oMUf9u9WZsz0Y0pWaWvqICzWPtbew?=
 =?us-ascii?Q?lBMUfaQE7fCMg8QgeU/Gx1JgUop2f2AB8hXTC3pNY2lEg4mcanq9MZZQ8YRu?=
 =?us-ascii?Q?RmdICCqf4X4mmhChyob3YsNQd5J8ErAI9ZolmxlTQiDagnfcU+ZWySWas2FG?=
 =?us-ascii?Q?F6lMvY16oQxh2pG618ezbNLahOHUpggwWEm1Leki+AIX+F4UPk/cMK86eXYG?=
 =?us-ascii?Q?W63lMiu7GA3B+9Q58SeuCVhqyf9MpIyQXhI5KM3xIGOOOqll9FmEtauSFGSo?=
 =?us-ascii?Q?4tDF13R/o24ZaVydEgxwVPWH9n+2W0Qnk4jYY6lmFJt/uaLLLqAdulXNyMuc?=
 =?us-ascii?Q?LkIVimLKe3f+Ur2El9I3ydfLZiBa5Tw360Yt8BCK6TD7K6M9qly0pgXa5P02?=
 =?us-ascii?Q?wZCUwwP0uzTgfaPlBqF1SSr2X1p18FVNlpXVFYFLd2X6UkdBoVieRQGnyNYy?=
 =?us-ascii?Q?NV5cXMdDoLyAuby4RDe3rsOz7KT7xAY97qegMRhwHWhpmcNBjPlXJYljcKU1?=
 =?us-ascii?Q?mMz+7TUean6sz5wmt5oN7KLy0eeJj6FbQNQR6xb4fT0x5NXF5mnXviBpUI0e?=
 =?us-ascii?Q?z6OBzWsG0/5RUKw00h7bM8wlTNkFks+94Pi87SPwOS0K9a2MybjRsfDAUt+S?=
 =?us-ascii?Q?ifQw8uChMmeIYK9a4Ohc0vF+dUvSmKnsLxbs0BVChJXprm9gS/dvw7fklR8K?=
 =?us-ascii?Q?6fNUFDvXElxQpFQMY/RCVjujubmkkTJHscr6t+x1VwWzTVnHZgg/f+/8Wobc?=
 =?us-ascii?Q?ogkPaZmTPKBE7Kk2ia39/fOtVrbbW6y7+D8TDXR7k+pzqQSt3VfLLMz9Q2bU?=
 =?us-ascii?Q?VbQcDkKJPILvL08nmGHI/XIJWbDttidH6E+GlJpNBXajRSYMackPuaa6Yn8v?=
 =?us-ascii?Q?nNsmbuhpBYMU+PDp+FdN5RbQQ5CyP8QNHhXlJkQ3jweNSJM8LVzQ5EaObcNJ?=
 =?us-ascii?Q?bP3Gu0gN3R0daY0IrgNJ3kUoAEmj/oPweqnSJfDhQmn7bhrefYkKyntJl6Qf?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BPjv64FHKardgAn9MrNfOKmfEo1lruu9tT4sqSkoiiIa0lqNpm+IX7DX5aR82tlUZPS8vIolpSG8rgPD8X2sSa5Fog2Lgc9IadJeYNRcLwMo2gHua1zTcLOflmUaNMjNcf/7CO1RiSAQGWYeQJBRwKpS6q23axLD77ZUG4M3ynmD7ODlFu898KoJqzc0fxPtNNcrpDRLU3MkXbwxMpFfMrktrdrueiRz32mx2odP9W4rth3yOQm59KCSpVKxwZTRjs3XEEeGfzMT8ArDQYAjBal4/1oGPq2DN8XydIiHKhLCgk66wwOob7/sgVcT1YA1HggVGkQixR5Kyp6KWeOnUjKAituVAv0SuPlklXyd7bMgbM3G0BgyHROfjMJhEhy36t3QPLaKRFe0YGLjwXDyXbUuBa7Eofo5UcCtBgqG4nxWsZ7ifVUoFoiWF5Owfs3VlwaYeZRr5fC/em5i7NkV7xRscrXhBJs1ENSdTDJO5hKOfeq4NOL7pCZuIX6ZuCajTjtGlkI1XMupbQ+1UTTr8U0X7qngOySE3avJQ2sDnmCVZEfqMXEaXCCQcrhIos/ELIcZ9MxGUKvkgHV1arCI5V69qYvZ9mBRHS/NX3PYtDI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e220f75-0ef7-486b-949d-08de293be95d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 20:24:02.9638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: slidGTLevPGDOkd+M82i10cp1wu+zG+XhIZbcKavkl8d3WWt28+tG0E22FnJBi2bCPibRwZy/3EirkIz92gP42CEr4jYgbOrLCSmDxFu9eg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6470
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_06,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511210155
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX924p7CfNC+Ox
 WGOu/UO2/lDc96/GDbMhWfi6/kSttNOzzI7u8EIGIwCQr/ifTRNE4rBYcZzzDlWDRAdC2/upCpQ
 qqQay5ej2HxFc9m/KWafFKUOgmlYx//DuNBYoXiZWDHMO4z/YsqyjTTKjUeI3ZfCW1Y6p4aCOSX
 fjguFXd8R4CF4TwkC9kFLxXC3b3RD+GSBBQwUeLwN7lGRHzfAlrDQoG60y9C2Q95zRFTHO+EKnj
 t+NOilCTmxo5dMKunUsfj3FAQL/DClKxJA42hd/9Kxu8qxUMqq+A5Aj/lCn9USfOpWnNOVYnMXP
 M88FLpyO3T9wAR29HfmSAOATSNfTJ3gdfM27zdDaW7ysx5353jm5KyVCrjPje1fRojdeMiW8Q6I
 OeGvo526744LCZ7awL7dI9tfgzi8Gw==
X-Proofpoint-GUID: 6toqK3udfFIOQT_MheQHxMd1UpPc1GPy
X-Proofpoint-ORIG-GUID: 6toqK3udfFIOQT_MheQHxMd1UpPc1GPy
X-Authority-Analysis: v=2.4 cv=Rdydyltv c=1 sm=1 tr=0 ts=6920ca6a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=zd2uoN0lAAAA:8
 a=CZTfYOs-HqEX1FBfxHsA:9
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 6372440011
X-Stat-Signature: q5zgtemnwc46r6ka6xut5rbxa5x9f7ip
X-HE-Tag: 1763756667-584300
X-HE-Meta: U2FsdGVkX1/xbN9S8Ms2j7AHD4vAltb+2NPw3XZZvvQluQUahIX/HmOKx6Ecn6XsbpDVvXP6MjVJ8FWNMzYMNb7VYolKkhg46IHcJYVoQPHxBbdn5msHeGpqYe16FCd6JravPRa25DvIrAgOVx64RJHcLA6nQe0O8eJN6Av05gmSJKQD0KyZ4ny1TfPfOPPBuQNg6qSEZkXzv1O+gpL4d/VeeTr8KfA4l/DVq5EEbhnKj07CyNU8TFlnpbzuZtbEkPuWLr8WIJSOhIPfGUtWA3p9hpJWTFIcNMr1QHndaefFX4PJ/BshJr+BjXmyxT4hiZFud1i5GQeMNHicVZm+df5ScXqiD8CSDFEIPEAUYsThIuwabmOQBQJB6EWvVE1LN+Uzr9xT74A0Z2+baCZibteRtNhwEuOVxzQQd8dNPjIJ2fmHqL/P73Pc37TvVPwUmN8iRcgro61brKGBcTkTwmt3vvGahVSQ1djyxlDolk0PVvBV/ZLANwik2xsYVCC8ZQCjBeDqYEH+F8uTEi3amiQDVo/CdWooSsYAL3mdGKkWKfdUoWf0dM43F/QX4mTFCeUfQNOYq/iNuyKHKePiMBXtizMF7bhx7iHSqxxbhib7UvonVHlaCvWoJz7MukYiZjrf3WiU4aATac+5EZTExrQc35IGaKPgbNqxm5ZH0fR6a7F7Fj79/g0YmQZiS55iUAuXHBLoMv83H7c2kDH8zGxHVlumJ5lR6/b1NrAZxnXMbfRMx4GH3Mxc7apr1EUcwyorKXa368TP8nV905W9kghJXoAIzsBoLhd9FiDpidmqnywVv5s2WyJw3FejDz6jXPxrWArJKG0l2tE9SRqeHSZNVCljO/VP+CthsyOXi0jMbTpfUc4qi/GG/izp4TQhKzWTeaEDn/+jFUzRely20dxPHuDY5QqPip/ltCqxdK1lYscO5SeqAjFJF0SBv4I1K9CXMBXk/Llj2Y4hZot
 JZRLpqPK
 Uwf/0k5+FAl31/3Lsl18Q4ofxNDNJexP9+tzwdgPftm/EAaQSwOS4ceVkVM04sYRFMLfS+e9WY+uYnoybRCF8Qm2Se/kcgJCKz6C00uTgk5PdXdm8kTISzJpd7SkXPbCel60xTIJZKRknf1l2hjwV0aMNDu9kUwVjogCfCl4H9n6O6yr6ApRvqXu33ptFnF6Y9V67DU9mOZXHaWS4YfVUAC8ARk/vvuCCp8YNbXoXfpkW7Xu+e6B4tdmfa/xBeyEm66n2tGGkcVNzzJixHPYSeBFrkhqGdw2K+hEeL4S+7drto75BjaPzQ9Cz0DlY1Y7TyIkIhCcbHo0BLxValYIOua6arB76GiXSQYA5b5Y5W8w3UxeltcZB+FA3uQ0fOUR1c3cMdgt9TZbUwS0exO0LVe0IOD/Icm/ilsztGsoYmxSJqObsaOWRcX11uhpPs8iTyYTnd1LhZHNuTNa7QwK9PYcdhivuEdl4XhK/3rsGOjFK/Dpc8uml6/nmqV9MyLPz7YuHLHw1ar3vlZxL9RYTktyIf4evg0Kwg9MWzwyh0zswsgfeBLHdEvWXzRwM2gV6J+wArgQChcrwYosGLJ/CFmzPJbAuHTjUp2b0e+WAWxPKBARpLr7PZpsoG/m6t2PXj7Z0jK+InTxJqsISux8G8SAM2tVXf8qrrpIUYFu+gZ/B46Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

clear_page_rep() and clear_page_erms() are wrappers around "REP; STOS"
variations. Inlining gets rid of an unnecessary CALL/RET (which isn't
free when using RETHUNK speculative execution mitigations.)
Fixup and rename clear_page_orig() to adapt to the changed calling
convention.

Also add a comment from Dave Hansen detailing various clearing mechanisms
used in clear_page().

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
---

Notes:
    - s/memzero_page_aligned_unrolled/__clear_pages_unrolled/
    - fixup comment to specify x86 insns in the standard ALL CAPS style.

 arch/x86/include/asm/page_32.h |  6 ++++
 arch/x86/include/asm/page_64.h | 50 ++++++++++++++++++++++++----------
 arch/x86/lib/clear_page_64.S   | 39 ++++++--------------------
 3 files changed, 49 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/page_32.h b/arch/x86/include/asm/page_32.h
index 0c623706cb7e..19fddb002cc9 100644
--- a/arch/x86/include/asm/page_32.h
+++ b/arch/x86/include/asm/page_32.h
@@ -17,6 +17,12 @@ extern unsigned long __phys_addr(unsigned long);
 
 #include <linux/string.h>
 
+/**
+ * clear_page() - clear a page using a kernel virtual address.
+ * @page: address of kernel page
+ *
+ * Does absolutely no exception handling.
+ */
 static inline void clear_page(void *page)
 {
 	memset(page, 0, PAGE_SIZE);
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 53f4089333f2..6157bf46590e 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -40,26 +40,46 @@ extern unsigned long __phys_addr_symbol(unsigned long);
 
 #define __phys_reloc_hide(x)	(x)
 
-void clear_page_orig(void *page);
-void clear_page_rep(void *page);
-void clear_page_erms(void *page);
-KCFI_REFERENCE(clear_page_orig);
-KCFI_REFERENCE(clear_page_rep);
-KCFI_REFERENCE(clear_page_erms);
+void __clear_pages_unrolled(void *page);
+KCFI_REFERENCE(__clear_pages_unrolled);
 
-static inline void clear_page(void *page)
+/**
+ * clear_page() - clear a page using a kernel virtual address.
+ * @addr: address of kernel page
+ *
+ * Switch between three implementations of page clearing based on CPU
+ * capabilities:
+ *
+ *  - __clear_pages_unrolled(): the oldest, slowest and universally
+ *    supported method. Zeroes via 8-byte MOV instructions unrolled 8x
+ *    to write a 64-byte cacheline in each loop iteration.
+ *
+ *  - "REP; STOSQ": really old CPUs had crummy REP implementations.
+ *    Vendor CPU setup code sets 'REP_GOOD' on CPUs where REP can be
+ *    trusted. The instruction writes 8-byte per REP iteration but
+ *    CPUs can internally batch these together and do larger writes.
+ *
+ *  - "REP; STOSB": CPUs that enumerate 'ERMS' have an improved STOS
+ *    implementation that is less picky about alignment and where
+ *    STOSB (1-byte at a time) is actually faster than STOSQ (8-bytes
+ *    at a time.)
+ *
+ * Does absolutely no exception handling.
+ */
+static inline void clear_page(void *addr)
 {
+	u64 len = PAGE_SIZE;
 	/*
 	 * Clean up KMSAN metadata for the page being cleared. The assembly call
-	 * below clobbers @page, so we perform unpoisoning before it.
+	 * below clobbers @addr, so we perform unpoisoning before it.
 	 */
-	kmsan_unpoison_memory(page, PAGE_SIZE);
-	alternative_call_2(clear_page_orig,
-			   clear_page_rep, X86_FEATURE_REP_GOOD,
-			   clear_page_erms, X86_FEATURE_ERMS,
-			   "=D" (page),
-			   "D" (page),
-			   "cc", "memory", "rax", "rcx");
+	kmsan_unpoison_memory(addr, len);
+	asm volatile(ALTERNATIVE_2("call __clear_pages_unrolled",
+				   "shrq $3, %%rcx; rep stosq", X86_FEATURE_REP_GOOD,
+				   "rep stosb", X86_FEATURE_ERMS)
+			: "+c" (len), "+D" (addr), ASM_CALL_CONSTRAINT
+			: "a" (0)
+			: "cc", "memory");
 }
 
 void copy_page(void *to, void *from);
diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
index a508e4a8c66a..c245b7fc01cd 100644
--- a/arch/x86/lib/clear_page_64.S
+++ b/arch/x86/lib/clear_page_64.S
@@ -6,30 +6,15 @@
 #include <asm/asm.h>
 
 /*
- * Most CPUs support enhanced REP MOVSB/STOSB instructions. It is
- * recommended to use this when possible and we do use them by default.
- * If enhanced REP MOVSB/STOSB is not available, try to use fast string.
- * Otherwise, use original.
+ * Zero page aligned region.
+ * %rdi	- dest
+ * %rcx	- length
  */
-
-/*
- * Zero a page.
- * %rdi	- page
- */
-SYM_TYPED_FUNC_START(clear_page_rep)
-	movl $4096/8,%ecx
-	xorl %eax,%eax
-	rep stosq
-	RET
-SYM_FUNC_END(clear_page_rep)
-EXPORT_SYMBOL_GPL(clear_page_rep)
-
-SYM_TYPED_FUNC_START(clear_page_orig)
-	xorl   %eax,%eax
-	movl   $4096/64,%ecx
+SYM_TYPED_FUNC_START(__clear_pages_unrolled)
+	shrq   $6, %rcx
 	.p2align 4
 .Lloop:
-	decl	%ecx
+	decq	%rcx
 #define PUT(x) movq %rax,x*8(%rdi)
 	movq %rax,(%rdi)
 	PUT(1)
@@ -43,16 +28,8 @@ SYM_TYPED_FUNC_START(clear_page_orig)
 	jnz	.Lloop
 	nop
 	RET
-SYM_FUNC_END(clear_page_orig)
-EXPORT_SYMBOL_GPL(clear_page_orig)
-
-SYM_TYPED_FUNC_START(clear_page_erms)
-	movl $4096,%ecx
-	xorl %eax,%eax
-	rep stosb
-	RET
-SYM_FUNC_END(clear_page_erms)
-EXPORT_SYMBOL_GPL(clear_page_erms)
+SYM_FUNC_END(__clear_pages_unrolled)
+EXPORT_SYMBOL_GPL(__clear_pages_unrolled)
 
 /*
  * Default clear user-space.
-- 
2.31.1


