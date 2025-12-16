Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBE95D5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 06:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA0C56B0005; Tue, 16 Dec 2025 01:50:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E719F6B0089; Tue, 16 Dec 2025 01:50:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF2106B008A; Tue, 16 Dec 2025 01:50:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B59C66B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:50:04 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5EE601604E4
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:50:04 +0000 (UTC)
X-FDA: 84224409528.24.C8E71D5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id C813C4000C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:50:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LvNI3h3P;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Vask6Ih2;
	spf=pass (imf27.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765867801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y0rR7ZQKb3Zm+QQRMspJFI6GpdLV0MUoSglYpA7FQp8=;
	b=OHcWYNvTfeH2DAvvhaQyoniHGe24XFzafVC+XrOYDowFK8f+4WK8lwXBo/4irKiq1/PN40
	s0ZWVx0iZ+RiQL8U2GUhw7rZVKsc8lr4WYg+dj6urvveU+hBJ2fjVnzRZdRRPLuKFSdvog
	GlV0EF149y8PP5uvMWaAaF8+oXZUA68=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LvNI3h3P;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Vask6Ih2;
	spf=pass (imf27.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765867801; a=rsa-sha256;
	cv=pass;
	b=6DAUhuHrXdclHBXSE1/7v8uFX15dlwlHSfmuFU3uRzd9nGgewcGQv4F/p7KM9qwvy2Qdx7
	+kEXvwkilDrj358A+hnRmdX7o9SQsJ4i3Wu+c0i+snf81RZpWa7T5Gb+dsiRn9KpsJ3E2D
	Jmu+3O30Owyv0xK0tu2Q7KoWegOC3o8=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BG1j1BZ3508102;
	Tue, 16 Dec 2025 06:49:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=y0rR7ZQKb3Zm+QQRMs
	pJFI6GpdLV0MUoSglYpA7FQp8=; b=LvNI3h3PEGokl/2CkMTgrZqPokbqJpk9Lp
	bziJahALHMHKvpAY4cqV2fW53SNCYx3NBCsp+fmzfziq+XAZWQo/Kz6Osu7j7Xlw
	7xsvJU5wARDJC7Nlj2F9L5MEPMkhb9ak/9Cd2ycDGNp3F49AxJyFbvCXjapV/IAK
	5NnneUfH5RhwzKwRHyYx8KKLJDiV+4Z6flBPhPiqGfNXfiNK63zg9mgP28NzAd6k
	lvwQzPu2ytGo1qzoKQf8HNGrFHOzrw7hy37uhi36/58vKqzzaB+uD40dqFu0PYdr
	sxlhi/t7VVpn5qoapwBjgDqRzaXkSfa4OZBeTlrOKqrg3UFx3asw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0y28bgcg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Dec 2025 06:49:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BG6b4BJ006126;
	Tue, 16 Dec 2025 06:49:29 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010021.outbound.protection.outlook.com [40.93.198.21])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkcw4g7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Dec 2025 06:49:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YRZMo8o5AMHm/+IlFVV4QByVKzS+zvwq/wfnkj6GkKMMbKiFryc0e3m5TGYGXeibfQqiERJG3TJ4t9IRaORZEsD/pE620/tGw0zlTXXZK2Hn4fImAdzBKXTtTWmDGmPmaHS2jF1rN41//mFzr2pwP5HTZNSf3ggsOutPih4EPjxsaRvXJ/j/r4nZ4oMM2S9CTOVoUGYN0r4MHivU6lycTVJol349QXI4Ga/dp15Z2rF4lly4ZSyP9cpTTwenMWwyKrLMGi++ZsSZS1nu92oUP5aq8jx5aWoNCNZPInaCibH6ndphzkzyicE7IGCO+rkX5qjySD7NbXyilQjIbLeNRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y0rR7ZQKb3Zm+QQRMspJFI6GpdLV0MUoSglYpA7FQp8=;
 b=CM2D69H90vmwhIMF7tNJ4S77a9Z2MGy3qLlWnht6vW8BydS2ICOP18J5kjJeOyVv/eTuLGNHQ21aNhNnwRu+7KQyYxOz1zi1IicPECXW2wrkoRuGpQkQzvn2WrvEmOVXUjflyQmJVb8ATxsB0BK9hO9jPQ7QIL2WL7LDBs5pl6W4GdFRiwoO7M6G30YLqxdIWm2izeprsUFDG1BoPTV5RcsSoMWoRgwftL8p2nqxO7Hg+2zB5awuIujRYAC6Qp2q5LCk8tVJnsz9iyqeWS0z5K/8LT32ZeiH5e0X1tv5svnR0m8rawj2NuET6N6PxPP3NbLVKZPYV7lRxM8sHpYOzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y0rR7ZQKb3Zm+QQRMspJFI6GpdLV0MUoSglYpA7FQp8=;
 b=Vask6Ih2O32KRJld6wos3TqnC2VUghZlPPLr+GO+2Dyfo1hnsx69KBkFQsLrzKpGAuCIqNgSvK49NKLq/mllbN9nJcRX9CPNaWS2/2y8LjGvh5SX5E1nxX7S6CEmJBJ/gVEsXfAOicZGVg7GHmBAufXkW7laWWTzJKcc/M167AU=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BY5PR10MB4257.namprd10.prod.outlook.com (2603:10b6:a03:211::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 06:49:26 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 06:49:26 +0000
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
 <20251215204922.475324-8-ankur.a.arora@oracle.com>
 <20251215184413.19589400a74c2aadb42a2eca@linux-foundation.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v10 7/8] mm, folio_zero_user: support clearing page ranges
In-reply-to: <20251215184413.19589400a74c2aadb42a2eca@linux-foundation.org>
Date: Mon, 15 Dec 2025 22:49:25 -0800
Message-ID: <874ipqexai.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0061.namprd04.prod.outlook.com
 (2603:10b6:303:6b::6) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BY5PR10MB4257:EE_
X-MS-Office365-Filtering-Correlation-Id: b64623ad-ce20-4ad7-7249-08de3c6f40df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NFBIm2cd4e+UrXplP+DM3Fd7pE2UHE1QbhlmI69GrQowmubmdkwyxb4816RZ?=
 =?us-ascii?Q?YxOix6K1bTAWWH7EBy63FHtW+7dTVj7+48JEjT2n/r41pMTh/YN3+sdtOZG7?=
 =?us-ascii?Q?XNffPjuV3K8ue37H+U/uFQrZb8aWZguBNIhm0ZvmVQXtArm4OeUEvxl7wgqF?=
 =?us-ascii?Q?64LgRV12HzZhTCe0sYsJ/4Fkzx+2Nm+vu5W4Dk/1/khbfUPy4AgaeztN59lK?=
 =?us-ascii?Q?TQolU/egJJOiNcmoz+BXlkD2eDyJ0DHL+uQL/doGPPZnpjEaLjMQG/BihyGO?=
 =?us-ascii?Q?8AzMahG77rAa5oPW8dg88sUYH99bwNOKPtt+E8yF8MrCbf/rtbNtQEvQG6an?=
 =?us-ascii?Q?yKoT52AWnhZAYRJgzVpN+Y0FRIyIy+olFM2ApW/LiSJOjX6G7mYbbRxHKCRC?=
 =?us-ascii?Q?/5iqtsuET9STOXjfzlnvrqhDuEy4B26LoVhUKOphTkD7UTdMk9bpZLZkFS2O?=
 =?us-ascii?Q?GlL/gDXya1/jzmisS5lcyIdGM/rC0iWZtFUxWTl0Fsphjz0Wpr3Mtx9n2eVv?=
 =?us-ascii?Q?NIjVpUQ4q5J/zpXd5rgEGqcVtvgU0IQZ7UD2PAXBl1HuFQR9tkRynWiqBwwi?=
 =?us-ascii?Q?36uX7SuHqGv0jIBre7EzIxJpTaWVbF2rscPAplS1GoT6MaQ+AeaV4UJjMhgs?=
 =?us-ascii?Q?EgeHg5b3nGiR/a+HexXU6p1z/+beA/eIPPiR3H/NPK6NyydDzS/hAlyQ7GMk?=
 =?us-ascii?Q?ZWDYSGz0lbD2AboA94ffAMjx+FrqZGqXSCNZN/RNxPZcwoShy6MhRo5xmHCS?=
 =?us-ascii?Q?AyoLF4R6w8uUY/qXJp23+tjXl9x6r2pDI+ijqp2d5SJv5lsPmbf6nkSAxbZQ?=
 =?us-ascii?Q?0w4nANxmqrCpJhLiAMyN88AzXRotAVHWnAIOTavClsPAVOOUVIszMxOeEBmT?=
 =?us-ascii?Q?AQ2Ct8uyCkXgAQXg4MXqUrNIl4lXZ4so6q3yWuXWt4mVS9PrLNV3lbwCBkFD?=
 =?us-ascii?Q?K/kva2tBwDRzcfuszCZWPqbzajBncDTJ2mbEv0UfTgg3X0dPvj0wmrvM5XDB?=
 =?us-ascii?Q?vc59u+GDgR7Egtd15GukMNLOVeC/V3/tnXFHRtqYdXOxvTuMWQ3zHFDfhaoJ?=
 =?us-ascii?Q?wRjieShNqvEexsUPsbS9QUjaRupcrs4CE+AxcA187M/cBWG0BHZCXUMnuBV3?=
 =?us-ascii?Q?mLs+IPz9HfQou+0nbZKpT8g61Pxij0iABQOdOz//26QLsx8+tnyuZueT71XB?=
 =?us-ascii?Q?r6fygcX/bTUFNSoQCYrktZ2Vy/6kK4TDqk7Kk6y+CafQznSnP71CUiBctRPl?=
 =?us-ascii?Q?/9C7dFR8wBHu9alkDL5/1cdMI3csNHs5CzdwcIuoTD5YR2RGZrDUPwl3z8+y?=
 =?us-ascii?Q?EJpqe9odNwymmW/R9MqqLy1bOm9yhTCn4NYANiVRyGws/AQl7AVMbSM4R68G?=
 =?us-ascii?Q?1A7v2Kjiuyn/sRbA5kMbg1jrbtfLpWQe20mI1Idw81wNI40oM/V/GJJDKNCY?=
 =?us-ascii?Q?3iZLSOaFT78jJGfAyItfjVG44bcCmShIalJcUPqyQOtgS0SY6wvyBA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o4/F15KBk4JFjgLi6fI6hvUHncse6TUFl4gh1d3nushaUhEOxzjr+/12LKXB?=
 =?us-ascii?Q?fxEaWiIZviLYrepUcdXCr96aLMgJKTD13TBl8Rtbtg4bTheQ2lZZ9QVrJbjS?=
 =?us-ascii?Q?XmS/MyqeP3TmASPCzDE2QqQtg6Tz4Hc3OU/km/erkozQr2yE7F25BKRdsrQZ?=
 =?us-ascii?Q?0izHD86ju7FOtbVdgi3n2JxVPuVdApSGDS6+Am8tSD1VDbQbW0o/1i07DeEc?=
 =?us-ascii?Q?BtUTly5f7TcbDVf30NUiinKHoOv7PpOLqTQJD8iLlddXwaLYUz145Qvt7ta4?=
 =?us-ascii?Q?fJKhdy0jif958YFehBwa58laOsJ4spe2ZfOdSn3r2IL6MSdbmmVMPvBgUydU?=
 =?us-ascii?Q?30i6DsOJU5fphNFNcQ39/fiycpLPovoWoUlq5ABEgxRkwEBZ81Vhh+4CZnzH?=
 =?us-ascii?Q?Q84ZLMpu8ezl6ZYcNF6dCSZv3NPZDAvbytF4EGmPkUp6it/t53xn5C9kOZdD?=
 =?us-ascii?Q?m5+VxdCHte0A7NZoEQFQiiDrE1/LeOkHpV8KB9r9PvC8yCM6kHyjlDC5sNkT?=
 =?us-ascii?Q?QUw+DSLC8nuBWZvb6D2lcKWgpkpAoO2mxZdKGWcNxzK+FnlZgX1D89oynX9V?=
 =?us-ascii?Q?SSPrBv852QCG5/BS9Any2U7+pXW4WBljfnUZE0Em1nZ/n2d28HzAJKWoDuAA?=
 =?us-ascii?Q?QYtdh6d4f2q9p8IHTcgb+MEZLplVMkwPC06hBX5QtmF66BREAx3dFNVkkiLU?=
 =?us-ascii?Q?RD/b68c1/qXNVgg0Hz10G95BauTcdYTIFIJdiuhXFKx+l4Bg1PEeZIlWWsn3?=
 =?us-ascii?Q?6QS8oEZW1PpxNONlenRNdEoL+AaiDm8fe9eXVUcCsAwD5i5+pdZlHyiMF0ho?=
 =?us-ascii?Q?WxchZHee5l/I8rVEREhncGAAlIJFEG18qBuylEsxU/rUCphSnrMFpWtdSgby?=
 =?us-ascii?Q?aJqeXf4c87g7F7/gBiZjiEEAkRUDw0L8XUNwTnafrRpdHBmBj1vKwKDC/rMg?=
 =?us-ascii?Q?K5vYRHbYZjGVnLO7OVpC7fUcztYCu1IJTmw61UHc8+xMBQ4RsYzihipoIgQi?=
 =?us-ascii?Q?ZXmOYjJa0NcizWzF/K85g7bKp/6saCzcleT1FUXv0ze7QmBMfaoDslYDVekY?=
 =?us-ascii?Q?t8FYPTPQ59C7JG0SrZSSgTA6elxVPUEUe2hSpw0JA4u2WgQZBTSDlvRfwTPz?=
 =?us-ascii?Q?ochKMbsTh6yPi2uk4vDpUXWws5BQ4I5PZnfIpcocf4LmmFwOSnHFhOtP47PK?=
 =?us-ascii?Q?ZoVu4V74bLc+v9lNsSTC5opuW4Dfc2VYxei8ooyl289tQELgn4pa8wMJp1J8?=
 =?us-ascii?Q?QCu1/DTB0X+PfoXqQqvZgBOrT92RbdpeKEbCuC0ug3lMT98fi0OEVbgeqUcK?=
 =?us-ascii?Q?OwPLAQufigy1ZmrRBWtPzmHO7hvBIcarUd5UhQ0Phbp1pln0gv5Ec0Amg/62?=
 =?us-ascii?Q?Cdc9bl7hGvOLcUjdSez5qzPjfPWtBCF7YR5lE7qTuOmIrJxGyMuWjBk9FGlZ?=
 =?us-ascii?Q?NqHxULWRQkzL7FzGFO2UaEveiq9GU5EV0hZcSaYS1gTZJnBeqhhmh6XkyMYp?=
 =?us-ascii?Q?hTD0kbkiWZcFZ8pyylQnml1c/0PWgFkJqwzWdpeRQmbrnU6lnARwl9N5CxnG?=
 =?us-ascii?Q?NV13U46XS7eF/3lOqfw4gHMgov7ephXyYEy5PeI6vA1rB8ei+uJT5xDw0zJo?=
 =?us-ascii?Q?uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zZERYW8SZEyXSd8QAJl+riLYW9CeepC3KLD3UxdqipseILzbLSfPtIZkjBX9VfGuzgC3ZMTviABe1TMkX5v0b3+0H311mxQF7cBcg6FUElTevkwHpZ0GybuFkbqxbf8R73jAIQ9/f5BgMigvgbgZAF00/fdflEFS8KCBQsOD2Hxn4qGMFWV0JIfh28VIFTaLjcZqrckSfVQQ6VbyG3qqVxy3gTHtRrheodIIZQ9XO8CmPf6nMRKRWvU5D+mGSHhCH004/fQVNocuKeH9Yc8psrV1q1p0mxQcGoIpQYGED4ssEtY5650HvgPPdsmW7+QjPRLjfRyguTUGYRwhCc+I/AefQFPRxdu357x4JtGRgjqYVY3eo+QBBxnvI2HCaUQ7VtHVownN7/Wbv+ZUTJHmIyMfdFI49QKlVD4md2G0sY5zIJDMVFsQhoAsl3tjSwSPsDqdhyCexgsDHXr4mtGwjgX+/mL0OJxXpPZrRmUWBIuyEJDAUYiX7vsxoV90V2BAE+XDSK2PJK8+zRp7rlN+/Bx/sHKUAO2DXdoNtnyBXqhGee28kHSRLducAL8L6C3+LReXgDb+AV5h/QB9WDzMqedjfC6ZT2M4GCObl3QyxH8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b64623ad-ce20-4ad7-7249-08de3c6f40df
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 06:49:26.2161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e+i+ahycdBrK4IPtUvjkiidf9RJuYjJaBhr2XMu/cZkbagAv6sB27ZhW+H56O14rZFiK22QPITrkFcamFnfbExnYB0j/sqcww16KjLgip8c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4257
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_01,2025-12-15_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512160055
X-Proofpoint-GUID: kLUS7QvJbxrL6nlJ_B1DWkAf2mNTLKYo
X-Proofpoint-ORIG-GUID: kLUS7QvJbxrL6nlJ_B1DWkAf2mNTLKYo
X-Authority-Analysis: v=2.4 cv=fOQ0HJae c=1 sm=1 tr=0 ts=694100fa b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=yPCof4ZbAAAA:8 a=Z4Rwk6OoAAAA:8 a=aG1s7GWeUViGCKzFW9AA:9
 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf awl=host:12109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE2MDA1NCBTYWx0ZWRfX8Lw4ijDImXtM
 zFgjdEU9BamuETJwWHSypn3rIpL6TWjnVNX8F41Y1xSnosN2CrbpekiTvgx+tT9LXuL/b9co9K4
 7NMhT/DPh0sMFS8FAKxh34XXwwlYjld9h4+QdDpHMJhgr8svL6A4s1vgM1ZVocZh8l32BtZSRaC
 fCstDiBpkxIFQt2k4V+fMVUEUbcR4hbWwU3cAqyI/S1GRogHFDdsJ+ZorYrNmU0OBjA2Yu12R2t
 7LCJA3K2kKhralJ2Dx4i8IwkGo3cDeGbwENdCFvCNydc/n7ALl5bxKDbcgO2UuQ9Yu/M8Hd5aWP
 VuUZALmFgmQdpK4i7hPhMoEVICsFszX/W581UOTIp58wJq5OTwpfsJQj5qeSakGS2hsPkZoOO9t
 UDTtuo+T8jNg5J4o6LTrCPhpNnZ3DPQ2Ex8Rltw4bGXDWY6l4io=
X-Stat-Signature: w9xw93ya7xk91yehkeadnr9nk1m5j9ya
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C813C4000C
X-HE-Tag: 1765867800-572276
X-HE-Meta: U2FsdGVkX18LiVHtoswKQR3wpFPmKvvisRE4rKjscy8QwkecZxfC2QNfkNjx2U8CUlkFkpd5/HR1wupye7NdYR1lF6D5IwmyP1uE+yZN7ZYlKEpSi1yyFEN1oK28YtflonumMADsNdE4cR/8eE5ckHpMhE2WmJvL5ayUlvOqOVP4ThR+tdBlCm31wxAPt7HNkQh9tVnjlmLKS5NBEXjdj0lcm97pvIQxz/9kTqSX2Gns0WPHQNCRTbCF7PDl76ATVMkmayWRdfh+8Of0ZWAD2cQ73857djM8iE2jcPBD5GMdk1yxuUomigdhf43vZ/4KamBvHRgNhdLLrD5RbaN3G+rs4j4Y3c+KeSnec+/1L2aPI+NnkHmGpZDbMrzpubzoKR4QgXoHNMNL9P7BTt4/nwk2PJRodxQPO/9QCgEzjAUPxRyZ/6myDBWUdWWk9SNB45C1aWWMTqEZx6Vl17geI6p2qxTi0etM3CdyFhY5eH1F3ztoVABWEeNtivHOFE2GbX13m8Am6csR/3rEO99I6rm6jcJKfam2eQXfQWKFI5X/7G+1qjM4FW983XhrrTdfCDYUGiRsfQmzYTdsvVWv4dwjJAMsjcFiz6sXyq8XbaZ+vFeyJ1sU6JZmSyV2vL6TjGNydEdRMkGek45Qgyy6nQzsoT4BaX2MWElvyq+V/ScaugXwE9XyEofAQIXukK/4UAi1z6KkNvOytUWKtN8QG1pxnEWhHxgT1w04TZcIT2qtPGbfJ3IY79XzzglJdCRcCiGHnhMkGjyo7OrFQUoDwAtQta37vHovO1vz18OWSN79XHaZfazYv3pf8TLn6DGaT2J/riDVpMlupAMpqhuo+O+xT1l+q16AGk028MaD4M8u7kd8SFhL3wOQ3a31baSfVtSsH2IA92FJV8ILzV2JqLXqb4E/EV9UbtJp9i97mbIZXMTN58/NsIdHdBCT8YoLLqTzWOO9GYQ7WPJe4Wd
 e/ZrJD1G
 NBle36+HLxLfUiRFtlwvUsTP9lRlrZtoPtZAGRdunEjdTQYmfmb+kYF5sFySIrkg1IVX3VKiyWSxk2BG5qVbz5fcQFH5w3mIXh7fccfYwNAvpvMtgZJ7AmhcjWBmSmaWD7yvKi5JWI7828rtR4fBLqCPD48XWGNfWL5T0OOyN+Nl3ZB/b3DI3H5LX8UPTldP9OOz1CrGKr4Li+e0smKks1ulUFvGBP5Tc4JDPZcdhFl+Qa8/usleJDrVVUoUuaQG3MoMKh1wwkH/tC0EgttdZc3MqMOtAgtg70ztAOMnON9PBr07hUOq1CyHDQQrp8XVSJglkH1PmrBUO4u9/fkhhOtmexynXMpaGnrKknH2k8jpI3gqN4nTxArKq1YBnpbbbFZ9LPt/2Y4fpyjC6t0ct/b28eKc7+VrD7U3gMW2o56Jx+0VfZid1piJeB93o0N6KsXOG52b8d8oVXvgI0T+rk7cDIZv7NB9Di3ADf/SaFwuZ+Vs8FARt9szgYuDw4IONHDoZ5MtvPCnsZfx1gDyYs/NO86zXqW++4YEjaM6J5fKZE1nTT1jBlS7CLHfZJsh9ohoNJPPczR2vkjYKElRH3swvvHl4y9E7UyAcm0VEmiGUTOIC2TXwuCEK5NxjNVLKRl9kTW6a5j1R6QBTzF/iWxpmvVQFqFmKrg5nVqlPl3i+iwKC/xfDsGHkFo2cndGEvTJgfWWwyGMwg6BwmEg2K/95jAB1UJ7dDs+3TC2zYXf/o3KS0s//PQ5oXddYQxrFs5CK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon, 15 Dec 2025 12:49:21 -0800 Ankur Arora <ankur.a.arora@oracle.com> wrote:
>
>> Clear contiguous page ranges in folio_zero_user() instead of clearing
>> a single page at a time. Exposing larger ranges enables extent based
>> processor optimizations.
>>
>> However, because the underlying clearing primitives do not, or might
>> not be able to check to call cond_resched() to check if preemption
>> is required, limit the worst case preemption latency by doing the
>> clearing in no more than PROCESS_PAGES_NON_PREEMPT_BATCH units.
>>
>> For architectures that define clear_pages(), we assume that the
>> clearing is fast and define PROCESS_PAGES_NON_PREEMPT_BATCH as 8MB
>> worth of pages. This should be large enough to allow the processor
>> to optimize the operation and yet small enough that we see reasonable
>> preemption latency for when this optimization is not possible
>> (ex. slow microarchitectures, memory bandwidth saturation.)
>>
>> Architectures that don't define clear_pages() will continue to use
>> the base value (single page). And, preemptible models don't need
>> invocations of cond_resched() so don't care about the batch size.
>>
>> The resultant performance depends on the kinds of optimizations
>> available to the CPU for the region size being cleared. Two classes
>> of optimizations:
>>
>>   - clearing iteration costs are amortized over a range larger
>>     than a single page.
>>   - cacheline allocation elision (seen on AMD Zen models).
>
> 8MB is a big chunk of memory.
>
>> Testing a demand fault workload shows an improved baseline from the
>> first optimization and a larger improvement when the region being
>> cleared is large enough for the second optimization.
>>
>> AMD Milan (EPYC 7J13, boost=0, region=64GB on the local NUMA node):
>
> So we break out of the copy to run cond_resched() 8192 times?  This sounds
> like a minor cost.
>
>>   $ perf bench mem mmap -p $pg-sz -f demand -s 64GB -l 5
>>
>>                     page-at-a-time     contiguous clearing      change
>>
>>                   (GB/s  +- %stdev)     (GB/s  +- %stdev)
>>
>>    pg-sz=2MB       12.92  +- 2.55%        17.03  +-  0.70%       + 31.8%	preempt=*
>>
>>    pg-sz=1GB       17.14  +- 2.27%        18.04  +-  1.05%       +  5.2%	preempt=none|voluntary
>>    pg-sz=1GB       17.26  +- 1.24%        42.17  +-  4.21% [#]   +144.3%	preempt=full|lazy
>
> And yet those 8192 cond_resched()'s have a huge impact on the
> performance!  I find this result very surprising.  Is it explainable?

I agree about this being surprising. On the 2MB extent, I still find the
30% quite high but I think a decent portion of it is:

  - on x86, the CPU is executing a single microcoded insn: REP; STOSB. And,
    because it's doing it for a 2MB instead of a bunch of 4K extents it
    saves the microcoding costs (and I suspect it allows it to do some
    range operation which also helps.)

  - the second reason (from Ingo) was again the per-iteration cost, which
    given all of the mitigations on x86 is quite substantial.

    On the AMD systems I had tested on, I think there's at least the cost
    of RET misprediction in there.

    (https://lore.kernel.org/lkml/Z_yzshvBmYiPrxU0@gmail.com/)

>>  [#] Notice that we perform much better with preempt=full|lazy. As
>>   mentioned above, preemptible models not needing explicit invocations
>>   of cond_resched() allow clearing of the full extent (1GB) as a
>>   single unit.
>>   In comparison the maximum extent used for preempt=none|voluntary is
>>   PROCESS_PAGES_NON_PREEMPT_BATCH (8MB).
>>
>>   The larger extent allows the processor to elide cacheline
>>   allocation (on Milan the threshold is LLC-size=32MB.)
>
> It is this?

Yeah I think so. For size >= 32MB, the microcoder can really just elide
cacheline allocation, and with the foreknowledge of the extent can perhaps
optimize on cache coherence traffic (this last one is my speculation).

On cacheline allocation elision, compare the L1-dcache-load in the two versions
below:

pg-sz=1GB:
  -  9,250,034,512      cycles                           #    2.418 GHz                         ( +-  0.43% )  (46.16%)
  -    544,878,976      instructions                     #    0.06  insn per cycle
  -  2,331,332,516      L1-dcache-loads                  #  609.471 M/sec                       ( +-  0.03% )  (46.16%)
  -  1,075,122,960      L1-dcache-load-misses            #   46.12% of all L1-dcache accesses   ( +-  0.01% )  (46.15%)

  +  3,688,681,006      cycles                           #    2.420 GHz                         ( +-  3.48% )  (46.01%)
  +     10,979,121      instructions                     #    0.00  insn per cycle
  +     31,829,258      L1-dcache-loads                  #   20.881 M/sec                       ( +-  4.92% )  (46.34%)
  +     13,677,295      L1-dcache-load-misses            #   42.97% of all L1-dcache accesses   ( +-  6.15% )  (46.32%)

(From an earlier version of this series: https://lore.kernel.org/lkml/20250414034607.762653-5-ankur.a.arora@oracle.com/)

Maybe I should have kept it in this commit :).

>> Also as mentioned earlier, the baseline improvement is not specific to
>> AMD Zen platforms. Intel Icelakex (pg-sz=2MB|1GB) sees a similar
>> improvement as the Milan pg-sz=2MB workload above (~30%).
>>

--
ankur

