Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B37AD46956
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CD646B00E1; Wed, 21 Jan 2026 11:57:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 460AC6B00E2; Wed, 21 Jan 2026 11:57:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 269766B00E4; Wed, 21 Jan 2026 11:57:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 02F6C6B00E1
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:47 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCD9D1A07FB
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:46 +0000 (UTC)
X-FDA: 84356577732.06.CFBFF22
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4BA3940013
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=m5DIqQgK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mycd4cov;
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0n7H+usa/qUWTCDLeWd4ZXGdk5/3Ptqg3L/u4308+zc=;
	b=EI7/9RmzZzB8zWTxEofTD8RR1Wk2T/WrgKOPx3MX909xRy9Ad7GALKFBX0I9I3dk614Auf
	rpq3/DXVdmiY0P2gt2o8lh0oVYXjBVxskhz1ju+w1t76cPpHZwxE7pW1bkSZGU0ztdDzm6
	5V9BEuU1GiFSkPI2RfTopNh/l+HcWVg=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=m5DIqQgK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mycd4cov;
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014663; a=rsa-sha256;
	cv=pass;
	b=xlOzeftmCC90hWb5+tdlehjoAYzcOu0Z8NK8ifru2PLjRK+8gnpgB7IY6AUI6M+FlN0fy3
	hziRhvPNA5IgxeuryL1QYof5k2ukljZ/cyUQKzGvWMwaXg9K63Jgt7WklA6cwMb+jcM1Hb
	dCtcj//Y90tcsbqomx46HjQC9EhrXMA=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LEljR63029078;
	Wed, 21 Jan 2026 16:57:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0n7H+usa/qUWTCDLeWd4ZXGdk5/3Ptqg3L/u4308+zc=; b=
	m5DIqQgKPKEq+S5ui5ABmqS27wygqX2PJ+u+eXA8eS+PRK6zXQfh8IzewyG3lchN
	noyS4oPk0aepDkYXOGodrIexc4/8AC7dnuPhsK8EffDnFBxqGrgnsg6iQpndUfxO
	0aKSjt/TjfJoeK6VWMz6OhRSdb0DfXKozTNem8tEViMJgk7BGa28Wgpi4l7iRaaO
	CIqr+iXejAdKbJVWwIdpJ549fNgQQAwV5sbsJZ/0hrD0aG1bXmImx7I2icPYspW6
	Wn/VpDfWz3TJnDbNqZT/Vs3VpJSF8iqKwtRNeZ3eyhFf1W88+PpqCq8JjfM0h33b
	SCipQUigMLlqyiGzQ3A/LA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br10vx8nu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LG7dnx019003;
	Wed, 21 Jan 2026 16:57:32 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011036.outbound.protection.outlook.com [52.101.52.36])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bsyrsbwdy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hwmgipf93T1hl3ljFwB7VLMsubJrVxPHM2omA6yRoLO2JZSaUfITAx6dVQeZs+NpaBofrr3K1B4aq2qESM4WGg7OErIlK3QxSUs97lZVjRvhUBUp2lndoykBoSmnDH4FWcYToLjZKXQQt/xeFH+hzwBDKyQP/BMDARR55sbqrycJDV7b1m40LMDi85A4P4DPKrWrzmhYDrC+RYfvCuNwUFVLXpqntraKXFzjI2oX/sYloNJBbep1BDXlMYkqPEcOf2rqe5gaHfbQlSJsqeoGLNFxJek+0wl2jNVTXN2IYj5Wfzav795JADktDzXDqbOZ3/q+hqzz+qf0xpOgrdkMoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0n7H+usa/qUWTCDLeWd4ZXGdk5/3Ptqg3L/u4308+zc=;
 b=BbgxLnbOA9IJIJj2SBK+xFc4gutEbE0KbZVs14AEgmFcTcmKo3BqtVxkOV7RKlOBZ7RGxkNnGBu73+vt0v3KF6eIy+xS4daAZY08AsA1IGcFphDt81vg5TxXAsK9l88+RwS/nBdUg5kusFfYDHXUgx5I7hfAcgzatEptK7OFjZ1nwVn50SshJHDjxYdp9PAbzz9jvk1yDR2SNYeN4Z15XsPXN6NEtZYFeha6gYLxGsNalQ+A/kgjzykzEJFRr1ChUWFOjkTCtCx2s1eDCn5asdEtDqAoHN6wkLPcFcWcqjWpV/d/824Op8V0MMlCz9zvEOWbjQtJ2EElAZVy5zZICg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0n7H+usa/qUWTCDLeWd4ZXGdk5/3Ptqg3L/u4308+zc=;
 b=mycd4covQZFCZQHZKecRW6NfdMKl1Z8AL3Q7F1y/ezpqyZIywQd/ZLnlQfwlmQ3Avekv3gagjGQiVsrdgiiQ0AdoHjNvGTOd+0VG3gWc3jLSh2J1prXC68iTpQIegcv3hyrwj52omFpNu+97eHxsRz64iSN/DH5t5ESI9A6XYfg=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DM4PR10MB6696.namprd10.prod.outlook.com (2603:10b6:8:110::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:30 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:30 +0000
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
Subject: [PATCH v2 21/29] maple_tree: Add cp_is_new_root() helper
Date: Wed, 21 Jan 2026 11:45:18 -0500
Message-ID: <20260121164526.2093265-22-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0063.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::32) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DM4PR10MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e22ccfe-c9fd-4f33-b7b8-08de590e29d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uf1x7XnXfvQHUODWjtOpZ/vKSHyWYk85DnBWEQkRyZZIYwQf9l80ZWzMzJCf?=
 =?us-ascii?Q?8Cq4u5uGD5HYkFJeyB7XWe8Y5WH148tT5n7+sV1xKSW7DuLG+HoYRuKMbsYL?=
 =?us-ascii?Q?I9IoX24z9/fdWjMp/rBr7BcO7c1f7cop7E+YCsuYAUIAbnTGvMqulnw7P7Kc?=
 =?us-ascii?Q?8II+s+vPllQljefxKN6YFNjaS3v7Ce7mVMwO03yPbOuVmHBoKQMb2a/bEhJB?=
 =?us-ascii?Q?4JAVXRb0bsJB85Jq6+klzABIjjxH/wJDztmi/19SqYm5aSb2WnLSFB+bbmNM?=
 =?us-ascii?Q?WRThV4icnozU8oVGNnSTOXePUA/P23OfwkELH/+Rv23bmCXMTDN26amJYtUX?=
 =?us-ascii?Q?VvqDDRHFI/tt6d91xX50SyZsPUQzVQ7FwaJGWuaZIg+OYVATpkt+gf/Ruv1n?=
 =?us-ascii?Q?9rva6SHVDYY+yp9EozpHGzHz42ZAr2z3wPKOL99J2py8jGa333I1obM/ab9Y?=
 =?us-ascii?Q?ROcmJoD5AUShfKahT7NpZbn6wFF4Gg9ShYR1dcANnStTBDQkwr0UP/S4z3l+?=
 =?us-ascii?Q?kCnQkF/FMAryWGOpTbr+HFBNeljltvECXLdZ1sVUq7JJaKyDR9lLbPyXJbUm?=
 =?us-ascii?Q?ZX9m6useYJd60fxKr0VIDS4b+D7lUr3i+K5ZtNOkcsEaBzUGvpS+uW+cP6tD?=
 =?us-ascii?Q?DMtagR09NfrXKRlt6EQbOn3DiP6isPj6OOTEY8szyqCEMXpOGn7xRS06ru/Z?=
 =?us-ascii?Q?FRhmovE7qyV7ckK0i3JKJ44y6w+docknXtGGwNqQxZBVmq1qXeZhD5o9OHce?=
 =?us-ascii?Q?u3j6cyJ+Jm8U+UpQ6PJ6IF5q3+iYOMzyu0Hr6+KmDmMGW8eJZp0Ol2Sgvinz?=
 =?us-ascii?Q?P/y7mxgnOVWVqa/tSlXLOC6KYMhX77cViIEUHBlfDA6ePOWW7M/yNm0cRbAD?=
 =?us-ascii?Q?Qg16KyxwhERruaQrrReeNOk8azMWcMQ2zxrx791kj+YwphujvRb8/UY/u2tj?=
 =?us-ascii?Q?ovhTc+lEA57M367Qljo7iZCBVGaidEhytKot/easJ13Qa9YVfGbY6O2d77Wc?=
 =?us-ascii?Q?WSwCQel7KUqO03HRMhMoPM04brPOozJXaMDjkT4Odr007U2qRNsYp7Mpd6qG?=
 =?us-ascii?Q?vmusmzV+9loMV/VAPTRokyizaq0hc68OOaouCB0wajEZ6GDYOUEw0c8L99tA?=
 =?us-ascii?Q?SUGEZp0ommKSn4zHgnG/VUZy50HBb5PHnBQ9tbpxP6VpQXv20oEmSMt686w7?=
 =?us-ascii?Q?OAQNNDMe13DrfDQTtPUyxIkGTcSSQGu/bCBS+dM7kt2UzZogUT23T+coGgGP?=
 =?us-ascii?Q?kKn7OWixdpcNXarYuYbOh6M323F44yGvPIcxprhGsbCgWM51ZpIpEKJfZskR?=
 =?us-ascii?Q?c7CIRvvmSI6sj0tpkw+QKhEWjaSQzyPjzpX/FhpZ9lo73HipXrZ1fgnNa2PM?=
 =?us-ascii?Q?GyNuwLtTtN5njrA/sPjqm0h7rj3ubrMiF5bS26zUOFR2vy3I4PXcuMfuRykn?=
 =?us-ascii?Q?nI5PtEuPj2+1Aqqe9Ke/+kZNss1KBkMuFRimQcxmtzx0ngIqlM3VPMvCYkpR?=
 =?us-ascii?Q?oiSqzJf7X6uxLaVkMOvXFbxXMXcvhAUO1Frd0yqDHhAsi3rpWpaMtII0bgb3?=
 =?us-ascii?Q?QRBypsouPg7gaSA/DXY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ONupbMcrm0dXLsaD9cwEV+6YcsEmT3ATolpaEjM1ZhlUkit2jckdRCaPTvLS?=
 =?us-ascii?Q?2x3O9FrPPfzxnqLxZyyoYByxgOHio7HGGdE9dsDVFZM5y0gisIDpG9GrNtq6?=
 =?us-ascii?Q?uZ+NXynhVKm7PCdYvTKRIfxoB+X/qZ6xXrKJ+iRL9/8lSTXoN5NaXxzDgjmy?=
 =?us-ascii?Q?7upL5pMxI/SQQt/fZoJ3XtXj9BcbJMu5WpxzzFuRH0gl3hTwSS4U4YMDgyP2?=
 =?us-ascii?Q?mqrzm86OUircim9R2z/RpTifaPhcajgVCDdqOK/+Zpsh2qh5pjlysi+JN9xQ?=
 =?us-ascii?Q?EpjzfiFkO5qFLma8myRxCMd1LTtRrH1aaFmujHpoMbCqo0rEpeEvggsCOu09?=
 =?us-ascii?Q?pZk/hvMvTP9F+eRRTG8Jigxb6RJBy0d/PLrsgMUGkkScvTOt4PCylWIPlJHV?=
 =?us-ascii?Q?YNO+hYygzazA5+GPzk8bXHU4NUQAFyYU0KF31DMRTXjOkCR3D2YYxDXG4Wfn?=
 =?us-ascii?Q?VIfzOPuhxpAyg9dW3vDaA3qA8ftmdMKH1RxRb9zu8Sujrw/taDtfTgMN2TjJ?=
 =?us-ascii?Q?nsR9C9fuW5DpHZq6Z5vnWckYQPqrXOQdCZjDSSCOy8Ie6FZZnhwXWSgRQYz0?=
 =?us-ascii?Q?7JYuu95qeTrFkY3qCFuUKF/MK9D3qc4yBU6C9LJzI4x4LAymDQdssWBm7DKV?=
 =?us-ascii?Q?DULVkeLSTCVkkhhCXNQLZJD22hrvDrPijfTtF7g9m1m/uS7TQxkAUpztUDCv?=
 =?us-ascii?Q?bLHCvIJX3gInD0vQ1zN8GbnHv2Gn8VHvYu+e4meG/J8+4EXcTJHno1uf9C5z?=
 =?us-ascii?Q?P1p9LqRsZfk0Yim/ntYRG27kKnGLvZNX7r9gOYIqILPtytNrkjlryRw3eF9q?=
 =?us-ascii?Q?jefRAFHob+IKB14p6oRPxgiHmazA2PJvSV8iFQMsi+aXuAPnp4Df/TaaOpml?=
 =?us-ascii?Q?cgtfdYAzLrT7J7Yj2Rnn87UTSI9pZ9N9BMtTMW72Q3mFXt3yknfZ+inehIs9?=
 =?us-ascii?Q?Y+UuYwdXb00TdMKNZ1wzLJZQwsG2iFktaE9GM7hUBebk9XVg0aMYCK56hI1m?=
 =?us-ascii?Q?Wrrx7jP82JBcFld/dNMLWQHiGFZB0/BA7Q0VYa4EgUODLi7/fQ60nsJXKe8Q?=
 =?us-ascii?Q?LrkGeqxNLYeVh/TtwlIfWRHTt0FtMppnAGwD98HORaGfSkYlgzZsrNpKe6y6?=
 =?us-ascii?Q?53XJSRO7c6I4+F1Wtqkf+vcYk345r3Jf9SyIChOvWMJIkTHre/LF1dVjbj4s?=
 =?us-ascii?Q?lYKezqAZNmUZa3JmvWpkHdrhHbUOCkPOzvHjSAYkbFU8hTmqXVup0Tw4BjkU?=
 =?us-ascii?Q?fCLiHvnPHA24hXX0umMB1U+D0L4fyxRgWMOGKgG8kvwC+841g4xgPZGtW2Iq?=
 =?us-ascii?Q?C4JtDy63nmYD//SMP1FwiaKnaDtcCTUPLs2nE5O0r+nNhfiN9gcg+kvGEZw6?=
 =?us-ascii?Q?d7CJQRcHiwBqnaIu5Kss67+jXAayt9Tm+uFaPcyjRJDLZBIsiw9ufrbZwb9r?=
 =?us-ascii?Q?FWSizrgZ01oiQwygFWh13lhCQPVL3iTJFQP4EM6vs7g4QgcVPj2ZX794MkY0?=
 =?us-ascii?Q?FOY6G3Ls65b3PIw8Y+d7/m4tWD7GH9KWG6oGHIUEtvS3kjevh2DfaoDztuUL?=
 =?us-ascii?Q?+QK+V/06HjS0wgkwzUi75gtHp6EWAs0SxNhwK9gki0Tzv0UYjAtBF9wl6hMK?=
 =?us-ascii?Q?C+fwLc3D2m9l40gxkY11qS5By8dUdf25cSSQHHbH33aJ9wvemWrbsXAJhbWM?=
 =?us-ascii?Q?H6koei7+mgLqNn40NAtT/O+yXuI/YodNUD6nSz2zjXJw7JjCD3NoUT58tai3?=
 =?us-ascii?Q?9Ljfkp23FQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HToB/5rzvcnri+UeU9Pw0zGN5YB/FU8Fykm5F1quJf7qwcDz/QX8gvnZWmBTdrV/YHfji2F2y+rkG9rF8vJdAmoHyBCli++zM3BhH9ZgUNqWqdFojn5AcPZT6uBCZvduFfnwvDw7DxlX22cju7YJvtolUXcaVuMLm4qQxOxxSRnCsvL7X+NjVl9P2kHWwpz9mjokTUHt4HujHs4JdEsEH3IJhtqhS1xZnhW3il9by6JB53NFyR0dTOm/DLtXMZ3jTWX76n5fqsjcfqVeYv/9BJD4W/3K7iQNAneyncHuOjW5Epn6rVDCIbgzKYDjN2C0w6MZD28B4H6Yxz/ZmayDjmg9LOShT8weS35EiIPfpniRi7hWJ5Bj4QCy4IuTzpiaExx9loEGhNIB4N2utCpoV3NfsM2ci+tQS41o+f61dh29xPxeoN/FIsT4yB1LG8c9E0Jdoy57m3NLevQQ7xBfem+5Zd4eq/qTZJL/vNrd/E7IE8KJTjSTq9q7nigBbFRtb6kojNr9cUSmf6IRIYXzvDfFXNLCGtLsWLeTmtEzMyzrTSfW5FxgawTqdk5Indc0Nn2JcTafPy2nRglk2vx6RnenOIWtP6IEvoRkGao0DbM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e22ccfe-c9fd-4f33-b7b8-08de590e29d5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:30.0377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nbxsqXxVhnCcigRILd/PXI/GPEO5bxxzHTKtWCg7B8L8DxdLUV2tz1ODpgj38hlP0XosJ/qmSAGWl+dMxzgLZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6696
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=H4nWAuYi c=1 sm=1 tr=0 ts=6971057e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=j0p3HzqOWq5dXWzuM78A:9 cc=ntf awl=host:12104
X-Proofpoint-GUID: ToJQbZSlwbfW0liBSOmh8DUWbxYdHx7x
X-Proofpoint-ORIG-GUID: ToJQbZSlwbfW0liBSOmh8DUWbxYdHx7x
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfXzSeSms0B55Hz
 q1tJ0Ryhr2cBPWeiRfmwKEBmsfUQ5VTh6CvxmscrBQ7MW61/78GP/GSImI090346WayPcEKkcCs
 tpWOZ8NrizmjZZCCu/OAAB3Bd3Qlz6XoE2JMLga0wYG0Ko18b8DyE29igiiQcSGQKWogPix23pH
 FLcDX1f0sw3cRymftV6gDswd1FliY3fig3LO3SDvbIK9R1ILcsAQSfWTb0ZXIpWhJWQG2f6qjGk
 cASeAYxyL1gcQzrt5IS98R4AjTgS1acUkvkvTrGZiXn0bUZY8yeT8gq+cg4zKHg6i6htcE963RD
 fIBWzTDCKYTmUO6bX6ErE+AyceBGDCictCauwIXrMQOaIcL9hj8TYTEfqdjygry1v+CzL5wGYhx
 R33rKwvbYjqSeLQ/IwkpVQzeHN7nLdgwCMssh3xlquAueiE2B+/J0BUbPDyp89wSrqBE6udVPgQ
 7/2c4PVfpODCaIKGYAySCjdxZ/rHe9I6sWCtafvc=
X-Stat-Signature: 5sdk6z6gtc5x7muyqihk3imrk11iydbq
X-Rspamd-Queue-Id: 4BA3940013
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769014663-744799
X-HE-Meta: U2FsdGVkX19zqQ/DVjBOxkhe7sv+i4Zx5jzUVlMbDOSTPiiPMiFxftUO7CpRs4XBGCSwu9d9TXcTxDhvH2BJL/K6WJ6cExDG/6MR68lJpfxGKTw+L93Z75J/MpsaNmlmurI8h6FT79ruFcHEaXzUx48PgRvnKfDj5SijHfvlk2+Nx2mEn0c0juUcdsZfM6pGIJThX8NUjGC7w/oUlWJaIxoCgA/z1LgASZLlODVODl2zo2yDC4RrHtK/mgZtd3R9qm8ffxbjGpjRf9SggyeXtQ4dqlMxOjhC6TacyNsZStRtqj3Ho/WdaUbhhhxm21DVh/a8tsdFLvqplRKB7UM4cyjdd+qL78nBNk2ugtghCQs+urBUVIP1tjOhkr61rMWyDBQxtYq8MU/Ybh7eG7BxS7w5+4SW/uuij5+RxUKve1iWnLW0IkOYM74mdhZYBAzGhNGWBJO/5GSYst/4S4Qw0U1zXUeWOF1XzQlbTOw9jzSVylFHkUmWAttzPpvScr2dH4RncVdzXaQNHyT1PqCJQAmcpVZ5Cv1y+PX5IAlreTgxE0k+9zDHLWMAnfVp1ZwwEi3vbc7JLVLHTcTA9lVERwvfpM8MWLdDo7a5yzm8qBbdWkjtP8NqsrbRCyZxTXWfutGUgemudR1iJk+QLawuxHBciezZbA0TIBhXwaWArkTRv+5PryiH1hlSu1xJdeuFNZlOUz9egaQplh6oTBNWR0r4I1Z5g7LP0LOhpIhTu6kGPVzCaesCwSSH5O4oInZekW2JznyUojm0+ssczbu3szRRkpqcS7qIo3hy5pguDM3KqhoeC+Vvqgtrfe/5rHZol9XnK1YEAlNFSoq2Mpl4+etEfxcC+GZ/h2sTpRird1NMSvMfvP7vEuBaaGZ3PUhW2QqGzRpX5zgIcvQTUNsV8ANkrTfuBNsyEHgEAv7ByXUTicw1AnZ6osf1xn0bfGfjzF5lXvwVtsgzxCenS3Y
 jKmTi82e
 sWO5Iy0j7vUBL8xTu6+vvR8aVYtXAbPzZZ47lDNcdawclN9MXnFVQzQYfSZIkL88Ir/WEuAt046A+QhJaBI7pZGu4Mac6iw3io0fa/re1r8E1bcDCq4o6IeP4q/LjPA0zwRR9Zs5WiggF+6I3dW/TmNgTxPdXqqVZBANHaW4mCumtBJSObmjasaTa5l6SMwrJAzcV2oMW6RCbjZJ2AwKmj8/ujN/KcDP5/rp46m4j8azkFRBtoRx0zdFg9mdyNGZNOnYsSYVX7Pm8SlViwo2bh6hao3xOs92ZepN0eqe+LOwah+xN8b2FG8isKDlVcK9ykL3fTKwtI45kvtItk//+Os2q03ii2AoD31iQly8SHFaRDPGfsH+oQpkCm9bMjOTv3rT4EBUpAwfWi3JnZaEgq6DVjqMJSiaMXJKqB6SzHYCye/3AeMwm1dBuhWccLCEhjrdSN1ypoghxIKfrOj57Tgy7ivpov01CjVf+v3gynVFwanxonYBf3zVLdxiTdL2LOP2u+DNqJuNBO4NoI3lZp+nWGe1bgIgPIegeAclC7slQnAdJdGQyzRxwLOo75RqOzRI7bwvZS2skidzphFrgaFt5X/kk5BDGHCu+p9ZPJJqi9pi0ASTiUtUWwmTJgy5l8eafgsukyi9V9938a5aud4jZT9Ud5ecrDJIJ6XzOwlxBRAMGFsHn8Z4rgjowQFyR4T1N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a helper to do what is needed when the maple copy node contains a
new root node.  This is useful for future commits and is
self-documenting code.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 71 ++++++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 33 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 005cf46aadc10..326d6026afee3 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3330,6 +3330,43 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 	mas_spanning_rebalance_loop(mas, mast, count);
 }
 
+static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
+{
+	if (cp->min || cp->max != ULONG_MAX)
+		return false;
+
+	if (cp->d_count != 1) {
+		enum maple_type mt = maple_arange_64;
+
+		if (!mt_is_alloc(mas->tree))
+			mt = maple_range_64;
+
+		cp->data = cp->d_count;
+		cp->s_count = 0;
+		dst_setup(cp, mas, mt);
+		init_cp_src(cp);
+		node_copy(mas, cp->src[0].node, 0, cp->data, cp->max, maple_copy,
+			  cp->dst[0].node, 0, mt);
+		node_finalise(cp->dst[0].node, mt, cp->end + 1);
+		/*
+		 * Warning, see cp_leaf_init() comment and rcu_assign_pointer()
+		 * documentation.  Since this is a new root, there are no
+		 * read-side operations that can view it until it is insert into
+		 * the tree after an rcu_assign_pointer() call.
+		 */
+		RCU_INIT_POINTER(cp->slot[0], mt_mk_node(cp->dst[0].node, mt));
+		cp->height++;
+	}
+	WARN_ON_ONCE(cp->dst[0].node != mte_to_node(
+				mt_slot_locked(mas->tree, cp->slot, 0)));
+	cp->dst[0].node->parent = ma_parent_ptr(mas_tree_parent(mas));
+	mas->min = 0;
+	mas->max = ULONG_MAX;
+	mas->depth = 0;
+	mas->node = mas_root_locked(mas);
+	return true;
+}
+
 /*
  * spanning_ascend() - See if a spanning store operation has to keep walking up
  * the tree
@@ -3352,40 +3389,8 @@ static bool spanning_ascend(struct maple_copy *cp, struct ma_state *mas,
 	}
 
 	cp_dst_to_slots(cp, l_wr_mas->mas->min, r_wr_mas->mas->max, mas);
-	if (!cp->min && cp->max == ULONG_MAX) {
-		/* New root */
-		if (cp->d_count != 1) {
-			enum maple_type mt = maple_arange_64;
-
-			if (!mt_is_alloc(mas->tree))
-				mt = maple_range_64;
-
-			cp->data = cp->d_count;
-			cp->s_count = 0;
-			dst_setup(cp, mas, mt);
-			init_cp_src(cp);
-			node_copy(mas, cp->src[0].node, 0, cp->data, cp->max, maple_copy,
-				  cp->dst[0].node, 0, mt);
-			node_finalise(cp->dst[0].node, mt, cp->end + 1);
-			/*
-			 * Warning, see cp_leaf_init() comment and rcu_assign_pointer()
-			 * documentation.  Since this is a new root, there are no
-			 * read-side operations that can view it until it is insert into
-			 * the tree after an rcu_assign_pointer() call.
-			 */
-			RCU_INIT_POINTER(cp->slot[0],
-					 mt_mk_node(cp->dst[0].node, mt));
-			cp->height++;
-		}
-		WARN_ON_ONCE(cp->dst[0].node != mte_to_node(
-				mt_slot_locked(mas->tree, cp->slot, 0)));
-		cp->dst[0].node->parent = ma_parent_ptr(mas_tree_parent(mas));
-		mas->min = 0;
-		mas->max = ULONG_MAX;
-		mas->depth = 0;
-		mas->node = mas_root_locked(mas);
+	if (cp_is_new_root(cp, mas))
 		return false;
-	}
 
 	/* Converged and has a single destination */
 	if ((cp->d_count == 1) &&
-- 
2.47.3


