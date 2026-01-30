Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AB34E6BF39
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:01:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BBE36B00BE; Fri, 30 Jan 2026 16:01:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9BE6B00C3; Fri, 30 Jan 2026 16:01:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25C186B00C1; Fri, 30 Jan 2026 16:01:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0B4246B00BE
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:01:17 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C28635AAC9
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:16 +0000 (UTC)
X-FDA: 84389850552.05.9A3B70E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 26904A001F
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dssBxWTk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="mq8P/tnK";
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vunzutFJY0FxaaQBRK90L5ua1XE38f/nrM1TBCreTyk=;
	b=YbUg5VGzIJrEjnOBPSU4K+HL+TMR6bbVKQwNGwuA3dKLY8siNO1lcvY7B/9W1Yl4EK/wR8
	OvDqwpMiyaCtciVkU4D9TfHXbmPhXvsZLwMgDp9uyUVioHzsH/B695pK4rXhgsWjQ6AdyX
	rT9SaEeWxFN2Sik3+ATGHCxvQTDz95g=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dssBxWTk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="mq8P/tnK";
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806873; a=rsa-sha256;
	cv=pass;
	b=Cume8MW2tccAzu2jySow3bqdXrIwFfG1vjxn6DnTThC+dJTW1WCtWkpGmCfQEiuY/iUdFf
	OC9BGkV/GsKwlrT/6sWY+ntwcW3yvOOby60pmlTYkkQE66IcAAaSwRUdT+vbmLtv7aiuje
	MKebqSC0d/Kw7eXcmwHAAUONjzy/SQM=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDVg84078825;
	Fri, 30 Jan 2026 21:00:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vunzutFJY0FxaaQBRK90L5ua1XE38f/nrM1TBCreTyk=; b=
	dssBxWTkIzPFt5kcqFG6kcAYecyHgBgiQyl8pQ+RHPyaOlgzoAVO0l0ECrYmR6O+
	7C7innWbLJmaJUfsvU2CKUCMIpDlmz5fBSxOj+/qVsWKvahRd9OM2AaVCK56kHRj
	eJi2pK741K7orCJQzaqbLZ0uf3wkaY8uNIIXSHzu0mbPuLgfFivkF215U/Kpjrx6
	WqOGhcb1r0ndBV1O7UTwAL0Deo81pxfux6sQvrJvINNj4XNaBpViTo38b062km0I
	Yb4vuuAovId1R/KEKqVxvaI5GZ3WvC+a7M2HU9P9jadvsIqyihLy16c+C0csOcaI
	HbuDRUHWkAY5KywBgVbMHQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by2vgny34-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UKQd0c001917;
	Fri, 30 Jan 2026 21:00:52 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010044.outbound.protection.outlook.com [40.93.198.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhjqvdm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HmO5ejXsO6ZtpMBsco8S6MLVXSg8Yihy57NUksNjtaeFxM2KJ/SMnuxglrehcoWleTHCNlrA3ZGEOkLkA7pEmYHsgjHoU5EFJ6Ufx6VAygLD8UGrkxmw2bcrwtNsiCRirJHqrznho9AS1c9aNbqEnB4NoMB/+NAbtPICf2e9LWBQTVFdNF7rf64Z2zxMfgVu1bc62F7RiGgZ8znKpHjrCnfSF3XADEogtmIbR7NkgPxuMwpg5U1g339BDdJ9CnvnyEx6UMICT/o/5v8NoF2eRRYaMaVpO4iCqfq2XtBHWzY1pRjjia6n4zwV86w3ImERXrvqCZXGP9RMtVoFZ++f4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vunzutFJY0FxaaQBRK90L5ua1XE38f/nrM1TBCreTyk=;
 b=MQfEosTp5kwMtnNZTL3msJ1+VoeEk8MxbrDHaHyKA585gZpTeSjy/fyPb6mdgiqgMOsrXyXqnisyU54QDEYQK1RpcCkEJu2iiB+vTt/ud0KwqO6vqjriZJHzhSnWsV7hasB1/kvXRbjWmx3ego3uvD4MIRPKKFLuMiCW/Z1I2qDc5b9jKhLjM70SaNPq5/aR5RlkMVNdo6qyLev7FOTTljSO2h/bvnQL4zmg65oc2E4Qtf89jxwygia8rr3r0R3tkv8oZm5mGn899Ck/pvWMwrk+VlR7DQj6SdCjdm+dE78r1djU42iFRxzNIZEEhjHQulEfJ8C+KF0BS3Xi5CZVRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vunzutFJY0FxaaQBRK90L5ua1XE38f/nrM1TBCreTyk=;
 b=mq8P/tnK+KAftMqftIb6i3xuxENvWf8H4ox6GCOfKI48ZuJhYtt2Fh2A+XXmBzSQEGtLBxsJeyyyCyjjZ1qsoaCeyxGMLeMW2PHo3EaLXTWbdscm6IhKyGlL5XQf46PmtRDEszuQi0xgH0j/aEr1F4ci2n+je0gCzipNFF3xLRE=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA6PR10MB8061.namprd10.prod.outlook.com (2603:10b6:806:43a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:48 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:48 +0000
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
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 23/30] maple_tree: Add test for rebalance calculation off-by-one
Date: Fri, 30 Jan 2026 15:59:28 -0500
Message-ID: <20260130205935.2559335-24-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0292.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::16) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA6PR10MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: 4072b589-93b5-451c-72aa-08de6042a4c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bXbB3D7A4gM233nb4F0mbeklshCz+zCzmdzn5VFd05bHPPkraNTbCm1i87Iq?=
 =?us-ascii?Q?KYdI0C6fNqGfU1GbavA8GxA4+8OigFkTvGrpog53JZdAZVjAtNp3KQJGz4RZ?=
 =?us-ascii?Q?Sakdxm+pjsTIdc540kZPBD9vRNSmfkN5t+PYvVPUKPN6CT4Ho+9UtPpIWJdC?=
 =?us-ascii?Q?wpO6wucQphc8YgB2QkWm2thzYZ7jF2mfT+03T8KG3u2QkupILeSv3UMRAMKo?=
 =?us-ascii?Q?BG6rnoOUz1HrFKMwk2Sn2RNRBbu61AC5GQYdy/EX9HmJ3I+nYgfshhrspeNz?=
 =?us-ascii?Q?P1pRdGCoxUYpiPO9C9XeEwdb1TrIeQojvIIZHGQoDMstiDpwSRor2iiQ197+?=
 =?us-ascii?Q?RRRzhIH8LkbclVPUcbqikAy9pXDNfwawfG/t1B7xB5Caq/DbctsLhJZ5JEQZ?=
 =?us-ascii?Q?Rk5QH7g0rI9jXNSVoPrmxDaOxhABQAfbFx7mOE9F1MTkslZmNk+uN5M88Bye?=
 =?us-ascii?Q?VCICOvbU0H9HOPyeDHtpEEuHJZF6F03QONHb7PFpBL20tn8b7bpfJ7goP/BZ?=
 =?us-ascii?Q?jK/cZLQqcY+/qpvGBuX6pn3+G9WL3haxy/TFw3fm02lU5QW4pHf7kDlb1VWD?=
 =?us-ascii?Q?EymYMZRd3gJN1wReLW5ix70U8Ne4I4hV+rHszHj5abWnTw/udbnfRtlKX1HT?=
 =?us-ascii?Q?19sC3+7Y0/nGvGP69s/XOuAlgar/X/95+36XdwNooskXFP/sDodD0dw5CYQY?=
 =?us-ascii?Q?+pd8NcYr0gnWLqq3kfxK09aQJTZJADJq79ehLvmToXOmc4L1fpD01tsFUEZa?=
 =?us-ascii?Q?fuhOv89cK4AYQnTqw/cngu7NkoV8isFziCCj6WcKfwqL4mIYsTdjP9x3TXe3?=
 =?us-ascii?Q?L/N2mv6QiDDEaNTkE8du5B9AxP+Fi8+icPmyQCC7STrzQjcF9wNVVBJqnk4i?=
 =?us-ascii?Q?mj24Nan7H1oA4JB5jH5L8qJD10JwwDmmK5l3mor4VABPIFv6bN1P+l6ONM9t?=
 =?us-ascii?Q?CkdoDPrahMaGz6rn36IUK+robr4hp6wHuTxi/fZN1db+TeGwCPhEmKwfVMtw?=
 =?us-ascii?Q?QLNNtrHK2rm3e1s8r9A1bXNXtV5umtx+WS1F4I/GGiMZUGCepcl4PkXOM0uA?=
 =?us-ascii?Q?032nbJl+TREyGc3q1a6EcoBkZkEocOGEkLlQt9bECKRfZNEn0EYfs9iD26KW?=
 =?us-ascii?Q?4hYIys6Kd7nTsz3KQ4zTTMOG4t5EQfgXaCRCrr4BC2gKrB5HHUoI/H9FOUWx?=
 =?us-ascii?Q?XmufAwFkJ117HGkDmjo3XTK0kySmg32Hkp74fufHs5hVggChw8I0zPxE9npU?=
 =?us-ascii?Q?lEOoTi/jyBtpxXgDaFqCA+/jgaC4i77aB7ZsDSqA2yCq+/wVkufuhptNUPbq?=
 =?us-ascii?Q?REFg4fcnACdtgqfx4N9kTNty3l9tGmU7pi19aqeAC3Et/X8T5cj6wWnVuKps?=
 =?us-ascii?Q?ot/URlnbJfrdCKerygGX+wT4cKWoRV/l5MxS5KKOLEv/RFURxcN+F+fT2IjK?=
 =?us-ascii?Q?jKs1FT9ieZjjlEQBVIudHezKK7mugV6YmJ/iBkJr+/SVV1BG7cukk10lM4zw?=
 =?us-ascii?Q?j3WBYT47auJBW8AKgNqDRr5Rq9wxYmq02uG7gmHRWJVjQO60jjpG7AKe78Ql?=
 =?us-ascii?Q?O4aI0dql0zM3BEI6w8k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SgbeDTah0g27676ZcxJ/ftiQGOexiyx4o6w4LXmL8DWJGZAzGL2Crb7UyLqT?=
 =?us-ascii?Q?t9D0Vvgs9QRnA5JvoEHmKfm9pmqsEtgcNuoch7ZXFjyCq/vth3yLFJL48LqZ?=
 =?us-ascii?Q?cXLRWl/qQ6fQ81Q4wp4+AZhkLkxyQyE81TVrqDpmpsFzegi7PUusICYpaY5E?=
 =?us-ascii?Q?xDFzANoYkfYtwZaY+2T8jq3AIj31D84pPYN7D6FagZuj3+UzgLUBrFD8iCFK?=
 =?us-ascii?Q?6vJoDdeGTYQGfPDm2nySYipJeIg5G8be30C/9/USrs4N3jcgVuvET8UQ/qF9?=
 =?us-ascii?Q?2GSj6MuzLkoB/P6uD806BswMZDYURLf0MUiqaA34LNJykFq7hka9ft1gJVUD?=
 =?us-ascii?Q?o/AK/ngxL1jOemHeFLA90DM1zTxiVszk9dw74nHMubPS5POUDnrHDqoLMLqz?=
 =?us-ascii?Q?sgCc/dIeb83HKO9ZUNQKgF29IG9KKwTZjruJHTrYQWyXP35qvj8X//FkG1/S?=
 =?us-ascii?Q?oFxmfwPwyjHqpU74x26T4pQjC5xbKPzNrFlO1Bsz5IhsxjokQftSKs6Pjpyr?=
 =?us-ascii?Q?E0oW/Hm67lvlayqW9xzglQcxXdueLW6sWdS6ejAFeMDGBW/h+02oFJPSkAMy?=
 =?us-ascii?Q?KcL551ByKG5VSBvtSsrcp3QXojwBfQWyLksn1Z7yd5AfbuixomGnozhhkAGO?=
 =?us-ascii?Q?dZnMX3QGxmrW773DIW4xbOjM8LwWmi5MyGdPXFEI9oDxEI1ZQvqx7We53pBw?=
 =?us-ascii?Q?V7QZmZ28fG1bTDrk1Rci66HvqzC1vYSWuFXSZD8kYopuD9dt8aRfuwwcMgFm?=
 =?us-ascii?Q?vi3aZcYk5EFjbjzmzIdiM1t8aVAqaxeTh/dbhOeo0EMkStuHRtWkNSt3iOoq?=
 =?us-ascii?Q?+ify3J1nUWtTiTOKTiRnKMwC/TJjGVY+WIJRK5XGh2nudaJWU5nLAGr+xYRV?=
 =?us-ascii?Q?Q/k7Bv32mlzLJ+naO7NUbjY9HiFYN1eKZ4J9vRLEyJckC5+bRtVe7/Y1XBzm?=
 =?us-ascii?Q?5jbWfpex8ya5uj+Ah0FI4R02s1s6+QSMQ2cAp4AGAGq8JANCrTUc2lBz8/1q?=
 =?us-ascii?Q?WWhxjykHWuNtcwsy4KslwXp2wRJpbf/irAiNjMGbKnzqrkNcrqJkvfQ88+HN?=
 =?us-ascii?Q?Cgdqv5pR8lS0zt9qaCK8HA/lSwj3JXcOpavoSUpLwf5SRrXhw9BaIxwML9qO?=
 =?us-ascii?Q?hB+Z6FL5L0GHz9OjVD+rTnseWoTPQSbGSfW6CAaNJoLdEoxsdCa3MTNoxJj3?=
 =?us-ascii?Q?W96qsN/H5Aiegk0WmNd6aVmNKzC+bvo5ChX8NdHK6Yt2rxBNsbtz/nh8ZI42?=
 =?us-ascii?Q?YSN5+NroKzmX9/7W+HhA4KGRCkI0NxmbICj7sI6PtF7mRq711JnKbYGMNXM5?=
 =?us-ascii?Q?iot6sL1zH/VWnrtVZem2TnyQd6o9RYHyaS/XKMwKs+VajzuDjuwfTsmFFrmY?=
 =?us-ascii?Q?pMsd/8a+DUTPXKiFxJxYUTZzsctibwBpZ4RcVGrsPXHQW02AEYzJaMSg0WOL?=
 =?us-ascii?Q?a0JTEox7FqfkT3qM6VL/3wTAnlrx62i7P75Vo2Q8N9No2GgYuA5zEgQ+07/7?=
 =?us-ascii?Q?TdiJNSy1QZG0VY2k5WxFwaNP/fcnOMuEKAJqkZ+QfZPcVN6TeAL9BP8VS5Qk?=
 =?us-ascii?Q?K2zZlIaQ5P1r2Th21lA79CMInKRaE9AL/xlhc3sfcZWIFZTXsakDeD43WgDz?=
 =?us-ascii?Q?K2/IX4JdeLaXrbs3wjIYMbdTmy6HkUuDKo3e/3rFhY8+ma3tzeS72UyYUp5T?=
 =?us-ascii?Q?K8bV4gt9ER/CnNVpzYP5a97kQQYDAL9TwukhZIEnBly5ntTuPsCGBZ4Zinyz?=
 =?us-ascii?Q?ewXwUOrdZQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EW8+xSeQvww1MU5uXdzSNYXm0FzOtj+UBtENIGFzTRYN1TZugMSOVBHZYuIFjs83m9xHXMG60hcfYUZVGBPV+Oo2QwfQD5+Jq/+8q0mOn7SHWRO+r14IS2tcYhZc4Ht//ySk8tOT5t6eyEqzvmu4BdBYvvLcCUJDW7SZKLL5SYnElPKVQqXXyuulG2sgEDFu7oPmLXA51GcS2heQpjcbzjOz6CCNKrvIF1lvNlxbwDLaZjQTGO6ifYyM2RfoaWseOmFwaRgBfAOPdk1r7mFjphsLXUSxJsuEgfguBEg9oA+Xem8o6HDaSyYVqNajokQGecruIZbFwlLC5MC+NCLFZB6Cjgkj+bVR+5kyulgiDcSqT6p+eB+/iepc+eHeI6RULBOX8LDVYfL0QyjdBxBtMGKfy0dwe/9IOvJ5bnpMu8jZ6QAjqA5FiSrD8g2GS+GE3JIRBc3jK0Tv7M/M7FZnt4+0laysNqyMH/qPk+XuFr6THoxxYwayTLnMcQJEaiXmSJ2oh84v90qMPgtfr4g7dKAyrZHBbfWnab4v2HfsUU2mxhyJM5rxcqZekes27Qj2gNMXkiNTLGjD//9aX9ogwphwUNlljX8gxEBkFNEMWIY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4072b589-93b5-451c-72aa-08de6042a4c5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:48.2493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ArgT8YWFYb7b8KqXG0XOZEJi80Q76kP/Uy7CVnY8F9SlKumHbrpcOU027GUQSw+JouQI+Kf2RhzAAnHI+3L2sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8061
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601300172
X-Proofpoint-GUID: YKi-3cBNfUmzFrMEs9BIncTiCcsTSuRa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfXy+lJrsosb6bN
 025fAzaYhI355xb0eQUOaJhgtYETRWBelVEBD4EBLDswHXMMTUSmZ5mc2FEK+M94kpMOYol5KN1
 fT8l/dBNS0/wMpgD3I3H07atQ84FCg526uVnjHkvLjz/5FOJ9rQMU/V+xdpwNY0UxeG+0TNvT5k
 wlz9po3NjOqmdoZFohc3CXr5y01IUVGqYiizLuepgi4QCJ4PlzvKwD4fV5pLfyylSkAlv2xNmkz
 I7Z83cN27TpYZ3VtL7mRIw3pWxbbCqqgurqAt66JIAXnjwU6NfUkdbO9GFgZ7MPzlpOF1TlWf1X
 qbKINSITmFumzL1PGQz1M+Sw8IQ+9rjzaGQtlVFIqmvijL313ozlIoQ2zOxT+Mi0POWbu1TyJ1H
 1ICAAyvB3fsj/EbzbQVX6MnLX9fz88iQLUTrCfq50nChZHA7td01XPl/dIGQTEiKl/IPCR6jr1R
 q6nz7GCBM+ouVt6yq+EaPYCE78O7pFND2WHi+rzQ=
X-Proofpoint-ORIG-GUID: YKi-3cBNfUmzFrMEs9BIncTiCcsTSuRa
X-Authority-Analysis: v=2.4 cv=a7s9NESF c=1 sm=1 tr=0 ts=697d1c05 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=N6NVBK_I8N3MV3nHsA8A:9 cc=ntf awl=host:13644
X-Rspamd-Server: rspam12
X-Stat-Signature: 9c3ubb8fm374t44t6q5bddrjkx3joftd
X-Rspamd-Queue-Id: 26904A001F
X-Rspam-User: 
X-HE-Tag: 1769806872-965396
X-HE-Meta: U2FsdGVkX18Vv6XvhFewSGTxjV0BykLAt/wB0iGNAhlZDyAb3KCsjFS82Mz1Wfwf9RR1a0OQrlhdvtxCBaprCX6Wjlt7kcrrbwp+Wc6CJSXf9ysO+rEeKJLDFXx8D5vBhA28kFxO7jKgw4Q+MH9nX6yw1gLVcPT5yEboHMzafh8wKXMsivyTRiWGF0V8kPe9jT/WeIBGNkb4d3e9180HsBIkzg54AOvsk5TnogvDvTteqySl8fBcb4s5jpyxinoAnkgr+UqASvEOHwNE7/s+RmeTDLUnJ6Ae3a4dVlphD2uHOgWL+1rSCe3WoNWePuzh+KUtQNKzVf642QJuFLYHSAUGGo99VqRA4hxyXDeNYVKeGAWNcXMJ0ZoMXZwMaTxg/RYRWPwFwHdqWS2Gaod3lXH721D/o92w8SXSZ1sliJ5JrKMVWKy0vYVxb/qxEdBTZ0dVtoH2NQp5NlObuSGjr31+is7aPqJXDGiq1oJHy+/NmP6ON2oeB2Nu2eIbYpuzv8LBTM2FBbwjHd69mNM74TlkCYAC8lVetjina2xQrk6giUoFUvOulT0EmOcGt6h17iQ0SUGyZk3S/OJUbUzIeGZEArthsaS9XGzfnn8hkYmHuKBxy6gEtnGZss+/u7YvcSWzfW2Wwa7mx8ItL+BXTOz706xspA2QEUzRTb58Mwt7vvi7RkD0ZPkWRxpTULqGHPSirhaiL0oXAWc3/0e3BEYPUqs0sEg/zhzxF6rfxQlQqkkyzIeO5BzV12uiTF92TPOFu9Y4R0+wY1GU1dMYwvU2F5MHOepiGScqkGYvnIdlU06pihDXcoSBc/KYTj1r6cBEfc6SwjIxSJXhygYLU/EEBUwQO52e++MdJLx9r2UsAgBnX7I6q1+pq82sw32VTfI2+z8Y5xvK1IoSgRWGEw+tIkDeUJADaL+Bq0ZT8udJ7WNr8reMzQNE3wO9UdBLyKMJcwD/OiE8Tqmd4bZ
 OhKcSOOq
 1Q+TxbnmdnDmTJZsQ+dRomHmeF7QKH8W1WdUkdCQI11uF15s4DO0v6QIk4RX3hSeKYaVvYtxZqPyaNlqxErnx/W7zFjqa2XhT1yt0O9PMeYpBwPAk4ZgC/RNzd3h9X0OiZm1KqoEFUW2ue6qY5A+fM07mTyYXQVwQieyfFqdiKpnzf8S7K8inurLHWUv5ttY7So9TvhoNtEqD9xtYeTMa9BAg/kooRwDQTM8f9/AqoCI0qBbdTzKXdTDLUC8O1GTt9QVZVnoj4JS4QS0xUGIskLQIqHcl8SywxBH3iqFHt87PbXWtX/Qoyll4EYRp5p3XnMQoTlhhZWidALws4siU9K5lz6xH94xnXJrGUUSNiglv0RQLBIfZpWGUYiwUu/MfPZdh5kt4X9FlF+iCFUc03OCTLfRMe4l6lEuVK5jdOWXX+2mnPWthMxXU73VmIYKBa3ZsRjwlk+y4mCzJmYAQ0C6qfJLgMqTH5/HexAXMPbr88nH+u5FZoQpVNSDWSAIB/tHRFzkDiKvadqivdtku9WAjEXopuGyVcAY6MoPMjJWTON930bQtn8oRlIDicElBcT/A2YN2eqyhS9666jLEK+eoXQXZsWORbs7d9weSp7/R2gvDrpEJ9sOnoRfUsYGmCmHUFWG8OVMG2kfuPbMAu0u957Mdp5cmbQE18r6QSz7K2GriMG1/ch6fTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During the big node removal, an incorrect rebalance step went too far up
the tree causing insufficient nodes.  Test the faulty condition by
recreating the scenario in the userspace testing.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 tools/testing/radix-tree/maple.c | 125 +++++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index dfd7099f0d8ef..5ea45d67556a8 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -35888,6 +35888,127 @@ static __init int build_full_tree(struct maple_tree *mt, unsigned int flags,
 	return ret;
 }
 
+static noinline void __init check_erase_rebalance(struct maple_tree *mt)
+{
+	unsigned long val;
+	void *enode;
+	int ret;
+
+	MA_STATE(mas, mt, 0, 0);
+
+	/*
+	 * During removal of big node, the rebalance started going too high,
+	 * which resulted in too many nodes trying to be used.
+	 *
+	 * Create a rebalance which results in an exactly full parent (0-9) that
+	 * does not need to be rebalanced.  This required two full levels,
+	 * followed by an insufficient level which will be rebalanced into two
+	 * nodes, finally leaves that need to be rebalanced into one node.
+	 *
+	 * The bugs tree:
+	 * root    4      Label     R
+	 *        /\               /\
+	 *       9   X            F
+	 *      /\   /\          /
+	 *     9   X            E
+	 *    /\   /\          /\
+	 *   4  8             C  D
+	 *  /\               /\
+	 * 6  9             A  B
+	 * ^ becomes 5 with the write.
+	 *
+	 * Below, the reconstruction leaves the root with 2 entries, the setup
+	 * uses the letter labels above.
+	 */
+
+	ret = build_full_tree(mt, MT_FLAGS_ALLOC_RANGE, 4);
+	MT_BUG_ON(mt, ret);
+
+	/* Cheap expansion to 5 levels */
+	mtree_store(mt, ULONG_MAX, xa_mk_value(0), GFP_KERNEL);
+	/* rcu is used to ensure node use */
+	mt_set_in_rcu(mt);
+	mas_lock(&mas);
+
+	/* Node A had 6 entries */
+	mas_walk(&mas);
+	MAS_BUG_ON(&mas, mas_data_end(&mas) < 6);
+	while (mas_data_end(&mas) > 6) {
+		mas_erase(&mas);
+		mas_next(&mas, ULONG_MAX);
+	}
+
+	/* Move to Node B */
+	enode = (void*) mas.node;
+	while (mas.node == enode)
+		mas_next(&mas, ULONG_MAX);
+
+	/* Node B had 9 entries */
+	MAS_BUG_ON(&mas, mas_data_end(&mas) < 9);
+	while (mas_data_end(&mas) > 9) {
+		mas_erase(&mas);
+		mas_next(&mas, ULONG_MAX);
+	}
+
+	/* Move to Node C */
+	mas_ascend(&mas);
+	val = mas.max;
+	/* Adjust entries to be 4 */
+	while (mas_data_end(&mas) > 4) {
+		mas_set(&mas, val);
+		mas_erase(&mas);
+		mas_prev(&mas, 0);
+		val = mas.index;
+		mas_ascend(&mas);
+	}
+
+	/* Move to Node D */
+	mas_ascend(&mas);
+	mas.offset = 1;
+	mas_descend(&mas);
+	val = mas.max;
+	/* Adjust entries to be 8 */
+	while (mas_data_end(&mas) < 8) {
+		mas_set(&mas, val--);
+		mas_store_gfp(&mas, &mas, GFP_KERNEL);
+		mas_ascend(&mas);
+	}
+
+	/* Move to Node E */
+	mas_ascend(&mas);
+	val = mas.max;
+	MAS_BUG_ON(&mas, mas_data_end(&mas) > 9);
+	/* Adjust Node E to 9 entries */
+	while (mas_data_end(&mas) < 9) {
+		mas_set(&mas, val--);
+		mas_store_gfp(&mas, &mas, GFP_KERNEL);
+		mas_ascend(&mas);
+		mas_ascend(&mas);
+	}
+
+	/* Move to Node F */
+	mas_ascend(&mas);
+	val = mas.max;
+	MAS_BUG_ON(&mas, mas_data_end(&mas) > 9);
+	/* Adjust Node F to 9 entries */
+	while (mas_data_end(&mas) < 9) {
+		mas_set(&mas, val--);
+		mas_store_gfp(&mas, &mas, GFP_KERNEL);
+		mas_ascend(&mas);
+		mas_ascend(&mas);
+		mas_ascend(&mas);
+	}
+
+	/* Test is set up, walk to first entry */
+	mas_set(&mas, 0);
+	mas_next(&mas, ULONG_MAX);
+	/* overwrite the entry to cause a rebalance, which was 1 too few */
+	mas_set_range(&mas, 0, mas.last);
+	mas_preallocate(&mas, NULL, GFP_KERNEL);
+	mas_store_prealloc(&mas, NULL);
+	mas_unlock(&mas);
+}
+
 static noinline void __init check_mtree_dup(struct maple_tree *mt)
 {
 	DEFINE_MTREE(new);
@@ -36249,6 +36370,10 @@ void farmer_tests(void)
 	check_mtree_dup(&tree);
 	mtree_destroy(&tree);
 
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_erase_rebalance(&tree);
+	mtree_destroy(&tree);
+
 	/* RCU testing */
 	mt_init_flags(&tree, 0);
 	check_erase_testset(&tree);
-- 
2.47.3


