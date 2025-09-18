Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A001CAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:32:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD5518E0145; Thu, 18 Sep 2025 10:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85C98E013A; Thu, 18 Sep 2025 10:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4DBB8E0145; Thu, 18 Sep 2025 10:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B1B858E013A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:32:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C7641DC3FF
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:32:14 +0000 (UTC)
X-FDA: 83902610988.06.22C18F1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id CEACFA0012
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:32:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CDpKqJMp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eBBOYHGq;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758205931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=au+5KJGz3E2k7gSkdNDHsqsXpYTDxAlZgCvJGXeJLIA=;
	b=nlXpEnwDA7/kkSgR9jkL9h2AsQFZJxOvhH3MPVeP6jkzVY2ybL4wLXlFmenPspQVcc4Z2E
	RMuVFFEYpIPygFdaGkTK6aPgM70fBs1nvopa7CsbXPe62O5AcdtD25HPOmrTd5xkM8qrpi
	5EHA+uhpJiH1Rul6VLkMteyMPLzMEV8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CDpKqJMp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eBBOYHGq;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758205931; a=rsa-sha256;
	cv=pass;
	b=MKVseQ1+gxzsZLsfySp7MLh/Xt4L5MJMdO7ilCGLgdSZQA3U8JUXfs7s7ZMeyskWo1STRO
	6lUyWSYHQr68uyRyrnOjAvxsEJwVH4+F0pm12HI+ZXqlRHxXtplpwhBKgPUmndUQnGt2PS
	ZEj//98bpmTNFQmRCMTyV7Om5turQ7g=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58I7fuQS017681;
	Thu, 18 Sep 2025 14:31:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=au+5KJGz3E2k7gSkdN
	DHsqsXpYTDxAlZgCvJGXeJLIA=; b=CDpKqJMpvkxleUwCA0R10nA57PchkpeDyQ
	Imh45H8CsUULK6YeET9vVqe5NGMri/zj0bYtaCXta7ShpXmWMGFu+klWL77rqcrb
	hS/rS2w4yMKXZ0SuQG910cE8Mj4arJ32EXOKbQsnOcX5pJeLLOtrsdsqpDE/5xQr
	XNF4I6JTee5Tzw79YT7zlk8YsC2sMDzz+RJi76x6ICMci9Bhfgk5sZPQVjaJnDdT
	c67A8dr7c8wScCoWG744q2yphVta63qRNNW7PIf986DFINRpWkhqmmWht3LSnBPM
	ffXrSR1bNdUE+8FSyMTsppA167U+uoXcRYekJVkXFiysU/k3h0Vg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx6km7t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 14:31:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58ID8ori037063;
	Thu, 18 Sep 2025 14:31:56 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010055.outbound.protection.outlook.com [52.101.85.55])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2f85pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 14:31:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kZtTJL3g9hZRkCJHXIcvrCPWsmPQqIkaVQnNGY1JN3iLAOJRbY9OitHbN5hJQ5IE1hWVR1X5lS7Y512P3txHo8bV6P8BA5CG1Ma7rTM32RTz12ZSJfUNPTRxop5xptA62olVYC+Opi6AK35BuXSSJwzNkr4SzwpCNzGwEbEWlR/SjZHCd9QVIDy3UTIIPvox/tfl2yOEEVZ1Da1jlcGARxqPx4CybElzzMqRcLYS+5KpfpZgEkWDohKGth+ZL1PoZYM7YDkcABCblBkvKzcaqAbitsjS5/75u2O0Gh16ZhWvPdjbgN0o7btczPM+wKps0+3FtUErffjFSXTKtutOAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=au+5KJGz3E2k7gSkdNDHsqsXpYTDxAlZgCvJGXeJLIA=;
 b=jJKTraf3OCVConut9hisr8MtSmZOOhmKJlOgsyGVDvri4Z16nDyBibAl0PF9YRJIFQAVKj4OL9AlNQM4cphV6m9u89vEUIxXg5ETdrj7AUmHohpw/A1/SV6E/lvf8dFldhjJmFjTi/6mpCHg1RdgdOor2fKgYn0DBVBb0yE4g5llk1+eGxdvEKOGJgMLZ65YFY94BRX+VyDzVz3wCmKKjiwEtB0geSNURH6cxSnrcvVjVwtZLxknFM9sunlUbK+eQ63RR8mKbboq7Ub5knjbe6DWrSNOrMW9n7wn52MKV/WhuMt0FluNbnD/0VDcg9erwpkSMLpEAXrEDOjhkDTEEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=au+5KJGz3E2k7gSkdNDHsqsXpYTDxAlZgCvJGXeJLIA=;
 b=eBBOYHGqcLboqfPL4Dyp8Kb8Mb4TQVnwyD3kADxmzEz754uP45/T15R8p2e6kc2BG5/p4wPnMD2lG2DVOn2AHAW82V/5Ij1Azm7jdYNGOfa6JHDv8L1CDizr+bgFHm7r4TsvfdY3WcVvdq8iq/8x+OQvUaixUSrnEwKy9V6yVdg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4472.namprd10.prod.outlook.com (2603:10b6:510:30::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Thu, 18 Sep
 2025 14:31:52 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 14:31:52 +0000
Date: Thu, 18 Sep 2025 15:31:50 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, david@redhat.com,
        Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de,
        kernel-team@android.com, android-mm@google.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 3/7] mm: introduce vma_count_remaining()
Message-ID: <bed862a2-60a8-466e-ab71-b1c009bc4e5b@lucifer.local>
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-4-kaleshsingh@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915163838.631445-4-kaleshsingh@google.com>
X-ClientProxiedBy: LNXP265CA0020.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::32) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4472:EE_
X-MS-Office365-Filtering-Correlation-Id: c4c61aa3-3c76-4feb-806b-08ddf6c01c5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JiSG/iDRTeKYp1YtN0hCY4VwJ0G0Z+F9qAeLisoCig1m2dg/rsVI5p1TxJ8G?=
 =?us-ascii?Q?0qeSNUMI1fJF9hzH1+yHcsqXRH+DJhVSqTTq1o6PafypoViiyJ0ViRtip4bB?=
 =?us-ascii?Q?Tv6b695L3pqk2JNdKsl03awYa2YXaPf5HjvORrKS8F4x014HLIlOl2P5tia+?=
 =?us-ascii?Q?miKcRYiBNcgeO7N/PmVukge2grD8oeae5U8gKQGHtUPU4ddEdAMjHBlz74kk?=
 =?us-ascii?Q?0UUQbaVeGiKpTWo2N9X74nBjlhPcz8BzR3qOHDQA13a1tVGyZ/c63lpvaT0R?=
 =?us-ascii?Q?vxwws2V/HYQ3x032D38QzX5SQiN3rr9r0xuG6YON9qyhPdW+/fTGmItXWVFE?=
 =?us-ascii?Q?jW63kynhCSbw9Fl+7Rs7xCCNpbEAMD0bti0Z/KkVSWS6o70JlvJJfYPe3IKs?=
 =?us-ascii?Q?7MWarYOjGvGF2BVIkL1uMLiQX0QgRVRbmLvSg0IUbVB1hnns3xTn40dFAwH6?=
 =?us-ascii?Q?NYGbqgJz9ypbOKxaeEJi2mkyLg5TtSiZJt+em+qZXAisK9bsud7GV2JBy20l?=
 =?us-ascii?Q?L1ErocbRT47sax4l4wP72kM92MMcdi0bznwQq61mgRBVL0k2YAkDDgKCM7bd?=
 =?us-ascii?Q?s4oTOEWG0C9wsi/6ZNmM6nLdcem7PknD+qfbumZls17AQmjMjuYbsDi8LxC7?=
 =?us-ascii?Q?z4WV3XI+ZTS+4xsqX9Nf099TcSdL5KucAA/bxcLkJpa9rcB+nX+WUd3aUPsj?=
 =?us-ascii?Q?xyCjL57HxPByzRE9ve+FHAczi5RF9qWY01SkNSvaR8R3wsjR7IGK14CS4gP3?=
 =?us-ascii?Q?XHZAR2/3OmfxuSO5c+WLjldJ8jIQdpZahyQmr0rdhO2mq58tMGU7viXNjmvQ?=
 =?us-ascii?Q?jnj8eIkH4Gy0U4Y7ARyPXcoBozhI+GwX7BaoV/5lNpwfJlI3rfP/0pbI6DX1?=
 =?us-ascii?Q?N82conqjVHAFBhFgpt0bXQrbKvhk0mZhYwypKrCgZnScQEmQBhiOtWihgEYQ?=
 =?us-ascii?Q?QQmfAgI5oUNp8Pzd9Lvrq4Yyf3glpiJQ3DCglcjdLengmb3aYEh3sWlN3H3T?=
 =?us-ascii?Q?6Xg+2Im2rSKgg2cwR8kZFdjsKCiaSu8a7PfAMigTo4GI5Yfz09LGRqR9B5Al?=
 =?us-ascii?Q?5LiFPEMA2v7lGEuj9H5udr91aanxYFW55oHbR+yc80qlwI55MfB5liHMm+R9?=
 =?us-ascii?Q?QfoED5NbvGba0eXh6d7yx4QKCMwUk/equ1SJbFuMdGJNRzkAJVb0I+oE3Jjx?=
 =?us-ascii?Q?pkGvPeOANRrkgsg5YwU+S1NAgLCVRB8D3tZLhJZJteBVYc1vc/FJNXaFCaSp?=
 =?us-ascii?Q?oBY9cS2fFXaFts/4KU1qIOe8HR6YT6dREeGxcmX/UAbJ7NIrlRIZwFXi2V5o?=
 =?us-ascii?Q?lETUbs3FoelQvBb3IJvYprGkz7bmTYL2nd3SDS8xpzz6kfGpR7WQqbzr8TY5?=
 =?us-ascii?Q?lzZgXxuCD4IH7kmDG13GRmE/NjF5vfIDDBTYDkI00VSy12ZyX/EOws0ZAQ9M?=
 =?us-ascii?Q?uWNwg0O9AB0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z5joC+bL8vM2V9iW9kYbCQrHLxfjumKVyc+M0TIqL7xTRQwjZZRjmK+AXIPT?=
 =?us-ascii?Q?pC3VUe9ZxY3Qnsap2FVHgWE0lhRU6tG2F4JBdCGLMbS/W+ca7+w1Q+onPLcE?=
 =?us-ascii?Q?JVhxhSW6zC6MkhIe2KwA0kky/f4XkTKBHlgwJOngRzjY/jIMvduZbi6DVD/V?=
 =?us-ascii?Q?nL7NAEKMxXXxs+mDTAQm+Q3MpJt5Z8w+lpLjJv0zp4tPwKxAqbjWFDb2iSVz?=
 =?us-ascii?Q?gTkyQeJmOVkLofHrrDH+d3eFCsUb3j/FBzBLQ4egq2KX5m3kSf/Y5YaeiLvY?=
 =?us-ascii?Q?7WV+EFSkJ5namOnYdKa694Zhn7ILOqlZYPkff8G7236h7LZ51zJJcea9nlIO?=
 =?us-ascii?Q?2Lcupa9SZtpCfrCmWWuALkrx01shr3SqAo9EkRcN6poBp4AXPWgb0XJIbwcv?=
 =?us-ascii?Q?r17nYlFX0MF4HSoX2iypdrA6MOhNCPG3l3d8GFLrAhasLOFm+2TyGeuyZjOo?=
 =?us-ascii?Q?+1u/z26HlFZapNcQwwZ37pijAldmP454Sq+VCVGhqGsWc2Q23hyQq8BJ4hTU?=
 =?us-ascii?Q?8fZtXL0tVFzy+kKqf/3ZimUuJ1RUYfQvOgcdsP2p0OlfXw/6Ncmho7VQPLwf?=
 =?us-ascii?Q?6EBZ5Hx2tW9d1JyLdVi/zlsAROXgYvQnurKYfv6/VwJLwX2BTu7hTiaAsE08?=
 =?us-ascii?Q?nTf2n69tvpYX0M33Iy6qY7tCiHlVEm3ZFh3R9xCxifn34kk/MZfc0CxQeQ3g?=
 =?us-ascii?Q?Ltja5o4gbKQ08nzZUUxsAsKP8otkRI5F0+Cfp5wOdsH5wV5bqrCh9/RQE99u?=
 =?us-ascii?Q?tqp8A5pDmck8LIkppQPAJ+SxblusEMTwQ3J3KONZx2bkxEUj8vsXtfDZGDvO?=
 =?us-ascii?Q?gCNDxWCkJAn/1fmQ3Whm6w4yGbF7dMy4dZ4seUtwonr7ePQ7QLpHdrSWJojt?=
 =?us-ascii?Q?7ixU+SXxYiLEJFp+ubzQti6sSwMjVndGa0xXugRWECj95yE7bzcx10aOM4SX?=
 =?us-ascii?Q?dUuvgaJ/kBpvntpG6o0hAX76ADoRbNTBwIEfcO0xP9tF23OzvXDS+m4FV+7x?=
 =?us-ascii?Q?zbz8f8ubTxIaPI43UzcXv8H5PCI+wmY20fO0K+G5dG4/mZbk1qldaLEogLwg?=
 =?us-ascii?Q?hyW9011Ba7u4/tFTxcl02ePDWaeITcD+p1eTBcsLOY5X93LkoXet2RGUpHvw?=
 =?us-ascii?Q?oi5XJ77AwOv3+KjmEUGQTMz3KXSvPRl7thFNsfdYdULo5s7rAkfjK/0zr3DY?=
 =?us-ascii?Q?XsVx7Dg3c7HxJHzzpkOKqtvL08FDinMKY6lOVhhNuUdYdsCYUUT3f3gfePlr?=
 =?us-ascii?Q?KLmkUXPsNehZT8FBbowW9KFMTsPuemkcwFp/JYe6o4ZrmhEvc1a9aeLxAKR/?=
 =?us-ascii?Q?DhcQhtDQZKpiQP/GDFk3PNmQrnJYOu7Aq1Eeea18Fn+BUW6o55MuEVgzKPq1?=
 =?us-ascii?Q?xgLXKGPoN5GXusUKlXstKg8dfGEq+/SYScJmmeOtFt7FYiqnwbH1CzIhFlHc?=
 =?us-ascii?Q?PDJvyTqQjId02caY7ve05exiFqI9toyr9ksU8/4JmUOfzjI1YwlPBLsXBrCS?=
 =?us-ascii?Q?8wBLIqFJk7ODXbdXk/6TpmgTgST45GKKs9eLdrqupsvYX5L61FZ2DGHqEYw9?=
 =?us-ascii?Q?8lavsZgWER5wcV0Swh+vCj7KORfp1hABJ6fyyxvmamfcjUxpcGRan2wzO+hg?=
 =?us-ascii?Q?jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Uxz0SUl1XD6um/nDUU25KwCdfwtRqbdfGaXKuF9dNdtbbWXBigo3IQDCViYAvxJ1ImxJnIwLnjn0AXPC6aow2i9iF4f8y4Z7D2bU6THVzHnVorOcU8JLcCK50hxz9gzmxx1cITQpbW7rqUTDZi9p8Y5LHx1fY3hM7mtQBX1Q8h6bPlHD8CtmSSlRtkFa9GdT5thSQt9hiqfsKltB2x8Egib9hpAsJVNLgtdzMwqAUCwlsWxAyyHEXHSJzS4rJqRhVGZgDnutMNE8IIRheXYeO9W4kLVDm2e0D2rVR1nOYj1j/N9IsFeZL4xOZS8NVWCafF+SbD1TIr/Dsk9LxqDmxw7d6DqInXVdQ2/drafn5DF/gVbIfwCLzTp4Vw+6Zov7ntUDJBtjAl91vUjtVRu3lM3wymd4PfYoZj88Us570rIm6/uCi0ZI1dJ9OJMoPL/zAczlpy1UGRWt/4SjEmnS7+2kL0eqraNJ5P/NDuhHGSOqj5uoh+cbkUjwQWjii9CwLi7Ptg8U3tnfo5eTuCGNeTMLXRSt6tf7LGTI9eEtHu24ZCWXkWnS5jEQ8wKYWihkH/d+0LPCnv3FzS5o6kGmSeI0AXfn54WyzmGCPk8nxjc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4c61aa3-3c76-4feb-806b-08ddf6c01c5a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 14:31:52.8091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FiKC40tK9NRpSKRQONmzByFTiquUcrsJbIK+iIbusaylZ4rR6MHXJZ4yw9Zvjl0rFfGrzhjg8VoEKvat2o/TSeQRlyMHxX90gXNcna/VSuk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4472
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_01,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509180131
X-Authority-Analysis: v=2.4 cv=TqbmhCXh c=1 sm=1 tr=0 ts=68cc17dd b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=3JXNTmX_oAs2ufBueHkA:9
 a=CjuIK1q_8ugA:10 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf awl=host:12084
X-Proofpoint-GUID: BO4xGQipPHbdkguh7YM2--Wi8p_hKOxK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX7dUm/dIO08hx
 dBIbHBMaH1i5Qbzfw3KGEf1YOrb6bWI715iuby3esfC7Rub1jqstuSRJkafgrHQ2Y/kT+l8oD3Q
 hnwoYkE6iMN43ecAepVk+ZX3IKu/icba4YUnLWGNedlKLOV87wfGXMSUHUsEgRN66/BjEhiflv9
 dy9TMtKuYhRKpO2FG5vLwdimGZuoclUMVH4gHFKuVssc3hb0Z53JuG7GgWn5nM6SLGSse9sfWas
 GOFTn43hLCirgE3sknXggqUFvqH5vzu0V9YaG4hQ8iHA1WufIqGtY1GKXsh0dN5OXi8A+ak8N4D
 MnSahcYE1Sxy7ING/Ykmez6kX+R+AvbPUGntsEW24jzLSX6LOpTX3sqxxck4t0gbAVvj+txPTo+
 j6rZQHISiAVcl6aYlUyj74mv/f+mlA==
X-Proofpoint-ORIG-GUID: BO4xGQipPHbdkguh7YM2--Wi8p_hKOxK
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CEACFA0012
X-Stat-Signature: xkrd85w8zmpbzc7a4fxq8nm7ykfpqhm9
X-HE-Tag: 1758205930-612508
X-HE-Meta: U2FsdGVkX18xJrP9w9F8UoSZgSrCxTWuyIPhhrp/K7vSHTY3Qnhzac2rUqLSZQ42dMFwmPkvwZt9af0HrM2UkUDrmkJNx8Avm6KrwJdKf/97nvWeQrTXj5rxnOE5RYYMMRUOrW0/jBo6r35XzWkf1YuyvfKaf4cA2C5kwpPI5O6eY2qgd5Kerk4ETgNs0a7eenOCHHd/VH6V/Y0/JEUCcfi3cNhL7k/8ZSxzMnUw7wJpPXAPSY6FvLTAVJBhj4zj3S77tvYxH0pDAmh+s52dNJVDfjFB3f+Nv/liEZZrHwpX1LVQajf7QtosIIkksDH8SMwW5G4iScx5Yix2TqGyQ4VOm9gmD2H5smz29fX73BqsANh75cCz+KrMqxq8cenibaAOpW9/AK75ZsQ54ani9W3VZQp5qxTihBGgq+uZ666aSgClqDMo1hXvXvTJQKE4zOGh6aWDpvnT5iUK/m8pUnJGobKTgewRMZQHO9x+o2JfUvcG42ebB450UlkmKsz3xk25cmbRIkxP7u8Mn6YDA81w5KnXTjIZvRFb1pN+qIJRHGezazq+gTHA9k6yBls+vQT173s6C7p5yQ0/QQaN8AzyronfxbQXt+8et36kr2SptuFGI4sj5sASr4RxYBmqcUObFF3lLtsnC3HmDMiLfkg7asaRMtnJJqzkE/aBnG5pPUFfpj0BxKDVU3hzFS0vJhSQ1RNDe7lHBqKEJBTHuePLn79pG9t7KEH9JGRbAwe3+/mHCXQY7IGSdWtCiy4BU5qRdheNcFxaxuWpkdHBSM8WY5nEF8mWxmGeYDPBZe+b7p38cH67s3OXSbgHHGAQCLO+LeAT0SofcZZCqzL3iDiIodljme53Jj7pwHAUglOimL9UZFudy0euAb5MKLwatkNqsMJQsH1jQ4tKqZlqJ+kxrA/23nwLih1MhXRrtwYoAfoA5SFJP7cXcJfhhT0pau4j2fHovXgyGJEruBO
 0JziM9lq
 L/PTY74hXwWkrxUOJ7z3O/a5Zc2MrscipOyl07XBWQbWluiqWjTU1RKgkTruG4Pk18jYHGNMyF1Opk5vVVHnUsGsO7hC0YG2IaOM+jjktxNlUeb3Uu/RAuW7agIZYh5m5F+kczG3DOCpipaFyRk5KiZu10uDH0f8zTeL0ZyT6vhPko3YdMIoyeGKVU6yl1r/WIjc8N0JVAUQfzdoqsyzbqrIRaSWgPk6CQRHa8dDb/Nqc9xgOsVBiSXRxV44Hc+d6XnCaWvmTeuTpHNo3BROWMB7R21mOOFrePUrvXl3Sn4pmzsgcx9vrz4S5h9tjRFdBoY8Z3BTbpM/O3GzYL2u79zRltT5dVGoll2NOK0ODpZY9mdeKcJ+4EFFnIObjrcqm7V5fhszlZPRrtYtwD7DBtIUA4ST3dVXS/556G7LkaOJNADllcLvDhZcKKmRqq9jET+GfioPdkhZ/C7Pk4zQTfr8UeHGxrZFzftue3W8HovGnWn2ArtRP7srkx9naQE+3GWodxDG0/uwX3yA5Sf70ahzjdBi1strafOoU0BF/jcNgoi+qCdm7Qe4+1cqyEQ4StNvoz72+PcrEVX7jiEPPOKoVCz44XoTz4Q4E9Td1yA91GiaMMUMB7tHSZHu1Zi+E+R90StNDJmXjkM46pvavbiUWnTXGZDYEsVWp4ULQ5eC+PH2Vv+RLVdK48YD+KE+WczpQCqvkjz4fO43nKdJ0/D9RyG9sZxgsWB1k+UA+fOHnrGAV4fVpnm5T+AxZHLIELApWOXYmyceZTuNcRfGvZotln/k5GF5nC0G7I25yPfaojcBFny4J2yDRXJcvnsOkdjZb2wHMbZWBzKu57eYwuUHR/bZybONgMMes/uctX+ikrQoCW8icShRf/E6yojJg0SXtMWHYn+z8m/d6WM+/S2aC2zSzXNirHgXQGX0+iWz+Zc0eCMBDi12ZLhVBtg1pdSvT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 09:36:34AM -0700, Kalesh Singh wrote:
> The checks against sysctl_max_map_count are open-coded in multiple
> places. While simple checks are manageable, the logic in places like
> mremap.c involves arithmetic with magic numbers that can be difficult
> to reason about. e.g. ... >= sysctl_max_map_count - 3
>
> To improve readability and centralize the logic, introduce a new helper,
> vma_count_remaining(). This function returns the VMA count headroom
> available for a givine process.
>
> The most common case of checking for a single new VMA can be done with
> the convenience helper has_vma_count_remaining():
>
>     if (!vma_count_remaining(mm))
>
> And the complex checks in mremap.c become clearer by expressing the
> required capacity directly:
>
>     if (vma_count_remaining(mm) <  4)

Double space after 4.

>
> While a capacity-based function could be misused (e.g., with an
> incorrect '<' vs '<=' comparison), the improved readability at the call
> sites makes such errors less likely than with the previous open-coded
> arithmetic.
>
> As part of this change, sysctl_max_map_count is made static to
> mm/mmap.c to improve encapsulation.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>

Generally logic looks ok, with various stuff fixed below + in commit msg we
should be good to go :)

> ---
>
> Changes in v2:
>   - Fix documentation comment for vma_count_remaining(), per Mike
>   - Remove extern in header, per Mike and Pedro
>   - Move declaration to mm/internal.h, per Mike
>   - Replace exceeds_max_map_count() with capacity-based vma_count_remaining(),
>        per Lorenzo.
>   - Fix tools/testing/vma, per Lorenzo.
>
>  include/linux/mm.h               |  2 --
>  mm/internal.h                    |  2 ++
>  mm/mmap.c                        | 21 ++++++++++++++++++++-
>  mm/mremap.c                      |  7 ++++---
>  mm/nommu.c                       |  2 +-
>  mm/util.c                        |  1 -
>  mm/vma.c                         | 10 +++++-----
>  tools/testing/vma/vma_internal.h |  9 +++++++++
>  8 files changed, 41 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..138bab2988f8 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -192,8 +192,6 @@ static inline void __mm_zero_struct_page(struct page *page)
>  #define MAPCOUNT_ELF_CORE_MARGIN	(5)
>  #define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
>
> -extern int sysctl_max_map_count;
> -

Nice to get rid of this as a global! :)

>  extern unsigned long sysctl_user_reserve_kbytes;
>  extern unsigned long sysctl_admin_reserve_kbytes;
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 45b725c3dc03..39f1c9535ae5 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1661,4 +1661,6 @@ static inline bool reclaim_pt_is_enabled(unsigned long start, unsigned long end,
>  void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm);
>  int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
>
> +int vma_count_remaining(const struct mm_struct *mm);
> +
>  #endif	/* __MM_INTERNAL_H */
> diff --git a/mm/mmap.c b/mm/mmap.c
> index e5370e7fcd8f..af88ce1fbb5f 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -374,7 +374,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
>  		return -EOVERFLOW;
>
>  	/* Too many mappings? */
> -	if (mm->map_count >= sysctl_max_map_count)
> +	if (!vma_count_remaining(mm))
>  		return -ENOMEM;
>
>  	/*
> @@ -1504,6 +1504,25 @@ struct vm_area_struct *_install_special_mapping(
>  int sysctl_legacy_va_layout;
>  #endif
>
> +static int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
> +
> +/**
> + * vma_count_remaining - Determine available VMA slots
> + * @mm: The memory descriptor for the process.
> + *
> + * Check how many more VMAs can be created for the given @mm
> + * before hitting the sysctl_max_map_count limit.
> + *
> + * Return: The number of new VMAs the process can accommodate.
> + */
> +int vma_count_remaining(const struct mm_struct *mm)
> +{
> +	const int map_count = mm->map_count;
> +	const int max_count = sysctl_max_map_count;

David already commented on the READ_ONCE() here, seems wise.

> +
> +	return (max_count > map_count) ? (max_count - map_count) : 0;

Not a big deal but would prefer:

	if (map_count >= map_count)
		return 0;

	return max_count - map_count;

As the ternary here is a bit less clear, and it puts the 'failure' case first
and the 'success' case afterwards.

> +}
> +

As discussed in reply to the kernel bot, you've accidentally placed this in a
CONFIG_SYSCTL block, so need to move it :>)

>  static const struct ctl_table mmap_table[] = {
>  		{
>  				.procname       = "max_map_count",
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 35de0a7b910e..14d35d87e89b 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1040,7 +1040,7 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
>  	 * We'd prefer to avoid failure later on in do_munmap:
>  	 * which may split one vma into three before unmapping.
>  	 */
> -	if (current->mm->map_count >= sysctl_max_map_count - 3)
> +	if (vma_count_remaining(current->mm) < 4)
>  		return -ENOMEM;

This is much clearer.

>
>  	if (vma->vm_ops && vma->vm_ops->may_split) {
> @@ -1814,9 +1814,10 @@ static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
>  	 * split in 3 before unmapping it.
>  	 * That means 2 more maps (1 for each) to the ones we already hold.
>  	 * Check whether current map count plus 2 still leads us to 4 maps below
> -	 * the threshold, otherwise return -ENOMEM here to be more safe.
> +	 * the threshold. In other words, is the current map count + 6 at or
> +	 * below the threshold? Otherwise return -ENOMEM here to be more safe.
>  	 */
> -	if ((current->mm->map_count + 2) >= sysctl_max_map_count - 3)
> +	if (vma_count_remaining(current->mm) < 6)
>  		return -ENOMEM;

I hate that we do this silly check here, but the time to revisit it is another
series...

>
>  	return 0;
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 8b819fafd57b..dd75f2334812 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1316,7 +1316,7 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  		return -ENOMEM;
>
>  	mm = vma->vm_mm;
> -	if (mm->map_count >= sysctl_max_map_count)
> +	if (!vma_count_remaining(mm))
>  		return -ENOMEM;
>
>  	region = kmem_cache_alloc(vm_region_jar, GFP_KERNEL);
> diff --git a/mm/util.c b/mm/util.c
> index f814e6a59ab1..b6e83922cafe 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -751,7 +751,6 @@ EXPORT_SYMBOL(folio_mc_copy);
>  int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;
>  static int sysctl_overcommit_ratio __read_mostly = 50;
>  static unsigned long sysctl_overcommit_kbytes __read_mostly;
> -int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
>  unsigned long sysctl_user_reserve_kbytes __read_mostly = 1UL << 17; /* 128MB */
>  unsigned long sysctl_admin_reserve_kbytes __read_mostly = 1UL << 13; /* 8MB */
>
> diff --git a/mm/vma.c b/mm/vma.c
> index 033a388bc4b1..df0e8409f63d 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -491,8 +491,8 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
>  }
>
>  /*
> - * __split_vma() bypasses sysctl_max_map_count checking.  We use this where it
> - * has already been checked or doesn't make sense to fail.
> + * __split_vma() bypasses vma_count_remaining() checks. We use this where
> + * it has already been checked or doesn't make sense to fail.
>   * VMA Iterator will point to the original VMA.
>   */
>  static __must_check int
> @@ -592,7 +592,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  		     unsigned long addr, int new_below)
>  {
> -	if (vma->vm_mm->map_count >= sysctl_max_map_count)
> +	if (!vma_count_remaining(vma->vm_mm))
>  		return -ENOMEM;
>
>  	return __split_vma(vmi, vma, addr, new_below);
> @@ -1345,7 +1345,7 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
>  		 * its limit temporarily, to help free resources as expected.
>  		 */
>  		if (vms->end < vms->vma->vm_end &&
> -		    vms->vma->vm_mm->map_count >= sysctl_max_map_count) {
> +		    !vma_count_remaining(vms->vma->vm_mm)) {
>  			error = -ENOMEM;
>  			goto map_count_exceeded;
>  		}
> @@ -2772,7 +2772,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
>  		return -ENOMEM;
>
> -	if (mm->map_count >= sysctl_max_map_count)
> +	if (!vma_count_remaining(mm))
>  		return -ENOMEM;
>
>  	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
> index 3639aa8dd2b0..52cd7ddc73f4 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -1517,4 +1517,13 @@ static inline vm_flags_t ksm_vma_flags(const struct mm_struct *, const struct fi
>  	return vm_flags;
>  }
>
> +/* Helper to get VMA count capacity */
> +static int vma_count_remaining(const struct mm_struct *mm)
> +{
> +	const int map_count = mm->map_count;
> +	const int max_count = sysctl_max_map_count;
> +
> +	return (max_count > map_count) ? (max_count - map_count) : 0;
> +}
> +
>  #endif	/* __MM_VMA_INTERNAL_H */
> --
> 2.51.0.384.g4c02a37b29-goog
>

