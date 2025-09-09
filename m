Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 493D0CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 19:10:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E396F8E000C; Tue,  9 Sep 2025 15:10:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0FC28E0001; Tue,  9 Sep 2025 15:10:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC6688E000C; Tue,  9 Sep 2025 15:10:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CBC68E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:10:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5FB60C0694
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:10:18 +0000 (UTC)
X-FDA: 83870652516.28.E843041
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2E2151C0011
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:10:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YzhlqrDq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xEGKlfjG;
	spf=pass (imf18.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757445015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vYTlWkQdkZ5M4FC5dnxjKM+pzSlZUTEXO9w5j0/bnJg=;
	b=RkhYKg87Z5nGbhLaRLot23qldEy5vC6YcZMRNhK0ion68Z+DlGBmyLXwjt8GdYVy7bFji2
	v6CgZQbgIWl7mI4cpS0nzSe+d62RMUxrwf9zkt/9pf2byYafMYwcT1BDsiDKTXePMUdnIF
	eyO6qc3O+8NMW1qV9hBqGI2bUAfTU2k=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YzhlqrDq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xEGKlfjG;
	spf=pass (imf18.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757445015; a=rsa-sha256;
	cv=pass;
	b=Fe4tQWNwltCNG/C7puoh1OpkSjjp0pRHC/L1S/1WOtTULPZUhIQvhLtPO2mG/UBa7e3JVB
	BcLbvDyUdNbHYTGToU8Y6Om4cDNf2SYjDm9fn/pMTtxIyLaGEeDDW8I0wSYYOZFsOxxExi
	gfSrfRCY3lekp/J9PTcsoH67T48FAuU=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589FtdkU003511;
	Tue, 9 Sep 2025 19:10:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vYTlWkQdkZ5M4FC5dnxjKM+pzSlZUTEXO9w5j0/bnJg=; b=
	YzhlqrDqpzpTwLipu/jWSmXlaA/1qWphQTdBOpBgJ61DJddLeoInOaeB//9HyHij
	D5eaoY5EOz97gjnB4isKPfamDdRMOR23ECKIbzbEJ7p95zpd/cVR1qj+MB20YwDJ
	tb8eOy2+o6elvxqVdFskAx2tLJBj9OuhEwggBbM1nKht5PjhGTnkCHAgGOSUO9+2
	3YHRpbTvXpPEACUijHd2ZwtYc+LgJ8ZvGkkahWrMPC55zQTcJpZgpTNo03LVch+t
	YBQTxi0hh3Ia3eahj/AX3iymG6l+dBu1LHUKq1jKadjwPlcsGaMYSs248Eds/5AJ
	avFYEQWUhgZXgbGiXYawhQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922jgtn0w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 19:10:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 589IpkQe030247;
	Tue, 9 Sep 2025 19:10:05 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2046.outbound.protection.outlook.com [40.107.101.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdb18q1-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 19:10:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f3teaGgw50ZkfqJL2FUKIvuUvSb119RMz4tRclWrCpJLGFHppIbKzr5Ygae+Ilb5zZeizY6BcIISXa7odh3wJZKIkOabHq7JIpYD+X/7tJV6trWmL45boydafV/jwnalwR3J+bUBIdj428Ku0QAzRQ7jzvAcUfAaZt7+PID5gbEgzPVfZHTiJO9BHL3okPJg6GppAN3xy9K9dlkB5FisfevWQK5JA0yAT6UlrYnEgRTjyH/z00yR2bbsWhj2deHy6FxU68DirIP9IWgbg4Q5b8snduHDhz1PaWwV2CU/jEcx0P/VaICZz2ZIO2AXmNFIprKEkJXg+IqSh+Z0VkrJQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vYTlWkQdkZ5M4FC5dnxjKM+pzSlZUTEXO9w5j0/bnJg=;
 b=vYTpmqSRzA1OoTEEMqdg3dXA6R03U8Yv6oOmQHy5JmpB5yEmrDJyGaD1wi10MaL49CYHVmJZawrbg9H3BFmpAQFmpEO0w95xiKBkR2ln15I/3w5fE/+mB0aYlOdAUfKlqkYxFtkD1r8Lfe2aKbas0tJoKsT7Errf+E/fYSOkHXEWo3m8jGAs6hYYOodKcE+Zlz7w5ViuxrtrX8c77x/IScJUsiFF85MqapjXrjVrLZP9hxVk24fKUUoYmtzsToI3cbij+QTLrbSK++UWke5tDP3DPYkk7gBA1rLvr8dcJz1wBulBsy+IVLBn8Yhuxiq0pI4L2GrKGw6HCLcz7VMxGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vYTlWkQdkZ5M4FC5dnxjKM+pzSlZUTEXO9w5j0/bnJg=;
 b=xEGKlfjGFlE1V8db1+LL+maki/m9TvHoP4OO2VgMxBeI/4dZQQ1SvptLe71hWZUjInsWLJV9TQdsEDg/Tisv5hI8OqbuGidTEIbPVcdyDc3hBmNGlKU1NnZflDkYcoQ+FiVPYpEXGILJiogfpcbc7+3FQrg3H5JTwppl7UU1fA8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB7052.namprd10.prod.outlook.com (2603:10b6:8:14c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 19:10:02 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 19:10:01 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v1 5/9] mm/vma: Add page table limit to unmap_region()
Date: Tue,  9 Sep 2025 15:09:41 -0400
Message-ID: <20250909190945.1030905-6-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0014.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::22)
 To PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB7052:EE_
X-MS-Office365-Filtering-Correlation-Id: 8986633a-c48a-45d3-dda8-08ddefd479ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q1mVFOSw18rdNhTqut0SlF44YB2TxZGF8DyGnnr/1tX8ycx8LF/U1F8E6iK3?=
 =?us-ascii?Q?ZJt+j00gCm62Q1zIjuEYud7AvvAVmpzK/uXuG6GowN6rSF71IA89v06h4NxE?=
 =?us-ascii?Q?uMuSx68rvQFBJCm1CGngYUFDTCPv1tR+7+fRmRFE3n4pN7DIX+SHudvvAdvv?=
 =?us-ascii?Q?Afwl9jkya0A6CCay6i+V3IUGdIh4sLynSnqBRKClWZXL+NjEQ2/o2EilTKil?=
 =?us-ascii?Q?0kCCOHUuYeJeHHNN552/Bd6GGTv7GluZR//Jg40eFE0grtPqZwOCKEWhAFWB?=
 =?us-ascii?Q?tI3DuEjBpaTuikJ2tQjp+CQeSqtDVPvp0RZ6gcCwIQ9Wl8QqxN4Uq4IIgR2o?=
 =?us-ascii?Q?4Dr4dmLRnU80aY2C1UP0Xiiv7XkAQhT7SY9yYFGJGZhYW5F+BrNOteq5UJom?=
 =?us-ascii?Q?q2jeM9l6rzqXPmgA4rzTWfRpQTa7PPSMfuakv4Jl/CMhGXqVHEVxVpH0vwTk?=
 =?us-ascii?Q?IQUY3bXg0OI1oNpZKcvtDjIB1W4GHhFkEYzRPVrWRX7qVGDI/fpNU/dUZa3J?=
 =?us-ascii?Q?EPdxeqtQcpqO6rowubVqwLhjGRQIB6IC34OOIu5SaUQY7NvXG02GQmgPTlmy?=
 =?us-ascii?Q?3LXGTa75RnPfp3yJvS8DqMIG/M5RmfdGXtDgTjoD9x+tZLczFCD8LpD+L4TT?=
 =?us-ascii?Q?q924I+kl881EaXYuQM9CAABvcv9K+lI/nOIY7cfPN3LVBtmsFm9uzJaNcQ9C?=
 =?us-ascii?Q?j0WAVxLL/IsPvdNKBPUdj5yqtfgEhQnD+j97zdx/wxu5GSJ6BMZYDIgXqFnS?=
 =?us-ascii?Q?2qzuYwbNdzsbYNxqeTsPtUdl7eQTdy6mRm3dfSfAHPaw1avut7D7AwH49+8T?=
 =?us-ascii?Q?gcF4OumAZP4FRujHqucf4E+qNAUstCx/L4jVMskz/9WhaUfL+LQITPlYMxgt?=
 =?us-ascii?Q?10GFgMPl0Kq4V7rHSvvg7/Iu82Ex6QiQwQYsk5ludyYpQmKmGRK9ZKHBPKFW?=
 =?us-ascii?Q?Yv+zM0mXy2OrjHtOkGDRsqWZOsb2d2Q4qtl+ikhh6fqrxpnUcTHqgPTfGtfs?=
 =?us-ascii?Q?98/nslCx4TFgW5QGwvjmk2N4dxpRCZG/xuSdBQZD8kXBjbnpjSxEzlu7g52a?=
 =?us-ascii?Q?7RkciEX9Y3M2M5W4L1KzhIfMqJzqZniXIKYpP0/1SRQXbMEqSM+GwaviHmIX?=
 =?us-ascii?Q?gxtVWroE50FnvVT9YVltV67EyQ9SsdFpwYBsTnTv9IR9DDaRf1yTxE6uh4hr?=
 =?us-ascii?Q?epNbwSg5RgiyO4ygJBO/7TIX0X0YcjAym/hfwDS06yfmYKXCRPpPwTzf6lrv?=
 =?us-ascii?Q?HzV1XBcaD+TJvtIE/r7/1+TBJTxzO3oS4v8F77P9xhVUplCh9FxVHxYwq9C0?=
 =?us-ascii?Q?A8ebsFyNMaFoURzN3xKhxR9UpqYs6KYkEwyyFh4GR7XtXpkUYDbmuLxHXs5V?=
 =?us-ascii?Q?fbcuoyJJ+3uQcysJTjFV8Np6cPs5at2j/m6aYXEVL7fPfSH/I/l5Mm0y4FVS?=
 =?us-ascii?Q?Yzc/nT5gO/k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GXYuDIpTCOAW/adh2LRbnFSK++WA6T3Il83SW3rIQgpDuBFBVXrzMvKBcN0M?=
 =?us-ascii?Q?gDYWvUM9uH7/3S98tkqa3RB+/G1Oy/geLOEXA8S+doGW305+6rTX4yQai1t+?=
 =?us-ascii?Q?UZ3CnB5n9K2rgnhSFWvQjLBt7am6BYg1hg9n6abxagVB/YlZuDTkU2Rvl/sC?=
 =?us-ascii?Q?V9hX1U/mPhsfcSWAEXZ+OJbY42RGBZ4aipYla4q2VrJOOWZrzwOoov3rp+7y?=
 =?us-ascii?Q?dz5IUNnT7fPXvVO3N5Dj9NWhQuMMaY0waGYIuAafCQ45mgmjTTRkJo7Y3WIW?=
 =?us-ascii?Q?4suqKjUkJEox6Lbg6xJdO1QZRGW0F3wjT/a8L+6vmIRByjso01zHtsNltGgi?=
 =?us-ascii?Q?M2WJGYRZ3uLin7D25n6rzpfh54+coxIMY2tyW7+qpbTJtuwz3r+Iy5lH2laF?=
 =?us-ascii?Q?ZywaYNbzFwfhMW2Ch3yhg9q7gvG/KR2nDoO2sVw5n0nzZAtAVPjcSxCEfoRL?=
 =?us-ascii?Q?CZt5YhHxvzXYJ8yMr9lFZwHHYnpqofOIUUl7QAtz05aaIoo8/84FKXwg+gNR?=
 =?us-ascii?Q?JAWuExcAhSYe2U9X0eUtyATavDqGDUAwvJlotQ5/L7Hy5IX7KpJuBvsaoZQk?=
 =?us-ascii?Q?x3pxYhC/12G9Q0vnFJpVEnVwpL5/C7xiScJ2h5Uhw1FbYTKIzhvkVV1zTthA?=
 =?us-ascii?Q?ucpHMZi6r3MLrfkAtvWG6oo1Df/Yq/lP943zXB5A6D+yG30itGqGu7IEmQQK?=
 =?us-ascii?Q?dxN4lvpnl0/2oz0RKpQyScbvvmiygbsHvaK5DwDgtlMHwcelpYz8/OYLLASw?=
 =?us-ascii?Q?+IpfdUHgwiJgNEMdX4bSk0LhasB4sNtlxtzI/46W3q20s9B16akxR5v23bsV?=
 =?us-ascii?Q?/fELLgRqnhCdoKC3ZX82pq7u5UvLwrK16KfHA22GowMVPLm7Wf6dB7B7+yRc?=
 =?us-ascii?Q?c4szKW7aJKJzK6yWrqZ93h1WiFjZSTpme2X1XWoRxgzCF6s8zjw1I9o4JIxM?=
 =?us-ascii?Q?Czqn0YM+ghd4TpOeHm3GRmbcClZ12gZOTwIReiiE9nk+fZQ7Fce1thTHgsaj?=
 =?us-ascii?Q?UR0EqMv7njCGsY3nR3GJu6tghKqn+rSPEeRUaBf96w5hiWLp4oX48hwG1zfw?=
 =?us-ascii?Q?qk4msFPuVww5l0fPM1aaNbrX9MBdonh0UBFEM4HAPJH7puCUOd9VerusRIzZ?=
 =?us-ascii?Q?JeuuDNL8KMUT4bjWfolZOCqZqm8IxW42wmaELGw/TY/D1Q/tXwM1VgAaFXTT?=
 =?us-ascii?Q?JNaZGjNNK0rytoFgW6iRr66lffS4y2Vc4zM1jIRgXNCFVMIbPbCSWEW1xTE6?=
 =?us-ascii?Q?bwv7don0MKimHL+TMzd+tEV35F8K/eo1F/EF/VVtHlkVE2SAp0Op/9rDXimo?=
 =?us-ascii?Q?aVTpgY3s7LpsQ7x3G6gffozS4arsvWiX4eKvifimCxYpWg5nZ3t2RnZUYwIc?=
 =?us-ascii?Q?n/h/ajkjKcS3Xg1dvMTdwRqZiC3Pz19+jPZzuoVBw7Z0Q/cmOHU7q5cPNLRV?=
 =?us-ascii?Q?OIdEal+JEqWBYn1qlOooenD7szEHy2NWBI6DwFZv17QTEjXAAG7AFgBx5ag4?=
 =?us-ascii?Q?8HXg2QSBFoVPJAG36YUbFrs+uvw2BwNz4Y9A2ouqvoDefClBFDjlZ0tnkQd4?=
 =?us-ascii?Q?NveTiS3f2vMtR8EA0id6s2yts5wjaVNLWvSBLhyJ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jueOZzrT8/keN5uvyCnvcCk2Gvc6YGGcn2C0/h2mPrRhsa4Z6AUeMtI7kJv0IzoPrkG3cCC8Y8RUYVzhXJ9aqR/Zd+wdRyzRILJ3xVn9kKjhGI4PAvfuudX9KOrliZxSDNXT2RA3bILUYZsPhYxs97Bx09w2KOgR26l28Gb/ikKek/yKpudVZKAiBaz87+CF0w50eYnMVZXORetMryyFECLiYYsZop+ptst4HDeLnD4EOZth0xxtqD29w3S0iJLdlZkJRc8NwP6x0Bq+7h+EzIktu4nCFw7IbcFvasEJvmv/v676NUl4+SgPpG26wbs7duPJ5JUBHPjyCYdpRHNP2QqyANeKUjNegWS2sagbspoCcDKCN3r/Nsupj2rBeq11LJ3PYS3N1eQERad71ABRNyVeAWo3QzvWHVCTrvUTvz8Uck0JY3fr5FVv6BETzK5S+JillVMCY7D91zfVgAVqTiIz/eeVUtnHtMJeuwQ+kE0N5elck5OtdiFHALepjD6bG8bCJnnfCjgUb4iG24IouFPki0jjrt/TxDYplYpiHyOBls+cA9WK0dj46C4bpZMnaoVb4BeT8d1toQDWM+djX3FDJuqb3kXBJFeoqGkQXNc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8986633a-c48a-45d3-dda8-08ddefd479ed
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 19:10:01.5881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M8mt/uaj1silRzPkAD+VyLuJQYWhEaAgDpOZsjIMVQ8IrCAwjhJ/HQqPSRn6RXcyTQXK+h/QT5V1/o+wkL31Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7052
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090188
X-Proofpoint-ORIG-GUID: NhZeJ-D757Mg-l95_HawMKe1GRCwNkJ_
X-Authority-Analysis: v=2.4 cv=PLMP+eqC c=1 sm=1 tr=0 ts=68c07b8e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=mRhb7lE__WOmgSHBrkQA:9
X-Proofpoint-GUID: NhZeJ-D757Mg-l95_HawMKe1GRCwNkJ_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2MiBTYWx0ZWRfX3WwHIhUtgNJ1
 Uzu9hjvde+4elra+4txs46oPrgaCBNq3RmcI27M3jJTtC8dimbQyqywPj70pgXz2rhZPctVj3HX
 1tLIiajzbE8hIM9zUNR84cVUTbbnFXlWPfxf5O7kifhIVSdIHVbVLY/xY9N4z4RUJPrYgXYmDsc
 fQD2BOX/OyCjy5GOZPqLcwRNGZFy+3xk3RXDWV+RVQB9VC0P1tlyXDVjNHOOseuFZgLXU2EtZfE
 X6+u7ghScX4VQbjJUdOXtrljx/zhTXsryEWriqRPcNliCJVIJ4PXs64OYCm5jbtC35G37+WuHx4
 RVTPGP6mS5YSa0l1No0wmcIlhSIM6KRhW+lxp4Y/KgDgT2DqhGgAufOgefYAKfuWt3BrgRTqBOC
 D0Dq4jBY
X-Rspamd-Queue-Id: 2E2151C0011
X-Stat-Signature: u4cosmppib4o14ssnz3e4zky346rwszb
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757445015-631802
X-HE-Meta: U2FsdGVkX1/xg56QOu4oyZ/NMk7sTIPIip+2XNhlyux+keyQLfPR1448r0i1TTTcpVZj3+pC0NaAlNlHcdO0ASHdNsT1NRqFhTvhJdvkcdmuVRtex0cEdjewwgeaOW8STaT7nZV+mkjixJl3OuoRJi7X9ZBXMqkgczjNRJrogyEylXhxKmomCs81wx8MxWYCiZt5hpD76kRmR7wMpzQ21TAbQ2EwGC3Qr28NCUd3vbIrUYf4IwmHrVx1J4+hCvD5iDyPskSF99oaGuhNxSPV7s0z/B8Vr+fmUpBKcBj4JAkhqmArBdd/+JSDxtVQJ3/BMKl8TIalhqIe6B5UM26iLuhv5eW+M+VEi/GQ6DOBelMw9Sxt8iL/d5+JJyLY4CgIf7Lb0UMUxS32wI0yUFxcOrfLg9JIpmfzgGk3ItZ4ox5uAPXaApg08Afa7vpU5d/rDDjOcGHKbungDsss8kHuhy7ViTyu2dNbMr7Iyq2yc1uVsFsqCVHHrD45iQstKar7jl4qpft3J9iJvNiYYh3Sz2uO3hefKyDM1tDLurYVEMwWKqjvFpnSzyxBI0JDIYWfg5AN8m9szuFX98+ep23Bb06H5YA5IzSrZr4ZZULvZb2rg4KJ/dNVBHOzwIL8llb3RxKjpfqW8u0bmMAS1lXdHpvVcy4eiksmTIiZqmi/3JGpO9CqZQ/vCzs5HHgsibcoKQ2DWiXg79jGqR2DM7YkGT4+kKs2jL5/RdGvFjaY4Ey8YDVh1x6FX8CWidzRbZBLtW7MRvgo1Yk3Jp6i3tUQWvgcbGPAM73PTvP17bqDmotlQ5LxZ2xQ8fLnkN7yxncdUlqpU8xdIJzNcvHdzyVdTTQX3b50qQOyH8qDj4ocdGXtNtrz7CrERkX3+SY1oAmLH2jcg5BEP46iVDqp0QlujJQgJ580x1O0BIlLHhj5Qpf7BDc4sMXC4SwrZeiEiQvvKAtDo9/WxDS13yn+OzJ
 BalNIMkt
 RaWSiOdVKeI5KRVD4meMDfUdg2k5OnIC85rmQTcmThGOi4RUI8MN/2pUAvJLRKTHVvkkyb/bKD+/a8XThY1xmFfTM5K6v7ghslAuHhaUTj1y29W7W9eP4BK8LmK430fxlGqWmWXyOVexNOSgdyggP4rPmlMbtjzjwwEhJR/63d0B2f3c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The unmap_region() calls need to pass through the page table limit for a
future patch.

No functional changes intended.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/vma.c | 5 +++--
 mm/vma.h | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 1bae142bbc0f1..4c850ffd83a4b 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -474,7 +474,7 @@ void remove_vma(struct vm_area_struct *vma)
  * Called with the mm semaphore held.
  */
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
-		unsigned long vma_min, unsigned long vma_max,
+		unsigned long vma_min, unsigned long vma_max, unsigned long pg_max,
 		struct vm_area_struct *prev, struct vm_area_struct *next)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -487,7 +487,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 	mas_set(mas, vma->vm_end);
 	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
 		      next ? next->vm_start : USER_PGTABLES_CEILING,
-		      next ? next->vm_start : USER_PGTABLES_CEILING,
+		      pg_max,
 		      /* mm_wr_locked = */ true);
 	tlb_finish_mmu(&tlb);
 }
@@ -2420,6 +2420,7 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
 		unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end,
+			     map->next ? map->next->vm_start : USER_PGTABLES_CEILING,
 			     map->prev, map->next);
 
 		return error;
diff --git a/mm/vma.h b/mm/vma.h
index a9d0cef684ddb..b0ebc81d5862e 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -261,7 +261,7 @@ int do_vmi_munmap(struct vma_iterator *vmi, struct mm_struct *mm,
 void remove_vma(struct vm_area_struct *vma);
 
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
-		unsigned long min, unsigned long max,
+		unsigned long min, unsigned long max, unsigned long pg_max,
 		struct vm_area_struct *prev, struct vm_area_struct *next);
 
 /* We are about to modify the VMA's flags. */
-- 
2.47.2


