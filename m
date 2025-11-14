Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2157ECE8D68
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C07D8E0030; Fri, 14 Nov 2025 12:53:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770368E000A; Fri, 14 Nov 2025 12:53:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C36D8E0030; Fri, 14 Nov 2025 12:53:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 421B88E000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:53:44 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 00BC0C045D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:53:43 +0000 (UTC)
X-FDA: 84109960368.27.B6462CA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7C4424000C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:53:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UaJuxD5k;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=C7uPhGB5;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763142820; a=rsa-sha256;
	cv=pass;
	b=jTxosw/BK3Y+XoA4LAYgxuF6CWUAoSfJ420brrohqZTMNN8BBwVbcWWZekIjtCFqVLts73
	N9H7Cwqqf1ldIkhw9lMaV6Yz/M3KEuPAB1sOxBh6Wgwdt/mzw214jLKYXzwMz2iaBPALq8
	sY22kQGr5ouyoepr9cCDG2x3Mx3IaUM=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UaJuxD5k;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=C7uPhGB5;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763142820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NrWdGOIrshezQTxDd3WyrJPk3onlEWepiFpUHZn6BSw=;
	b=D65654myeP61YI67BE0pHKRAVB4Gvk1ec1yKDw7N7/1dAPG9/andP8A9lMshgw1Poe+GZc
	Ol5lnId0W4FJDGN7uc78rx9jhRKGtfbosxlRKDGoW/bk8ULeFaIiVzXFvrPxQwQVLQZGqa
	J/wus9hFoU/kkr3G9FrXf4NYchVzHeU=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AEGuH39017649;
	Fri, 14 Nov 2025 17:53:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NrWdGOIrshezQTxDd3WyrJPk3onlEWepiFpUHZn6BSw=; b=
	UaJuxD5krQ2IfGbMsbTQmw/BVgPsQhUKBk2Lajr7uPSgMGJwVnLIp2P9YFaBfDCF
	zYPQuGGviTtwbp4E3z+NLHdj/WLLLi0WNlgRqZV8SPZPPCgdz8ta1gVpDl7LvqHC
	6V054w36B9N0d+CEdjq6o93ebQ+sAsG5QH05d0vpUeXDVISh4Bp3lS9Wpq5bf8u3
	OFivZDhFwahSISQlz08wg4yBjm0ThGFPPI++dpubQCCE2XkbMW1S9/v0BkPLtI18
	iWInw+GCKtZuTMTHwTFuYZB3XExhpdClqTTXhTcYDnRlhuCTTuwr70IwuSibC5EN
	C3UkBwQRv7HntspxPlXkOg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4adr8s9p46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Nov 2025 17:53:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AEGhAmY022020;
	Fri, 14 Nov 2025 17:53:34 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010040.outbound.protection.outlook.com [52.101.61.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vadu0x2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Nov 2025 17:53:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XgIoVBNgWdP3BRcK7CJbgKk7f32IGRfUud8Iy3Qr+FUfjugM6flpTauLOvFi6odamhPxHKMSbhmCIROVr7rnWmUjZHsbwS8C1rjhLA48mgEgpgCcTN4ClpXw5zknd76KghZtk5r4scpucR0i9M+adMKa/oRujwYAioiTcncniNNc8LXQHQb1ZN9lwqm5MYCao8mbBOnwtm32y1F3X8UiJD9B4UYuldl6RXZbS96P2Agg4QAoRabT8gcLdQI3rbormqX1pLX1R5eKy8IDAhYwlRpMQE3OgCe53l+iTaegWG8xpEIAXVCHiJQpjbYDNXkwnNOiMYO89pOG5GhiKXyV8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NrWdGOIrshezQTxDd3WyrJPk3onlEWepiFpUHZn6BSw=;
 b=Rp7OlxhpnCP60va/qMCUnai4kBGtiqVV7nVTY+Boj9iY9m0xRQf4rGCVR9tpsBpZk5p+N377QBznHTWhzzzzkmPlVtLTSlOiN30barXs0fQUwl0z2gujxZ+yFKeAalDNHgMt2wJLTkRiOs78Hi+9KExztq1EeyyTcjz+esuYa0T8po9qnLfwlsZFDnz77VhgkNZSlf0i6m5q9TfS2CfZcHhzXclT8kzj3HatlgtsJrI9XoO90PKT7e8BuWdKy+wG7BhK44XQGNuMwjwDzv8mA4d5xiKRtOO/lT57N/HQdnk6gtJTycaTdsc1g0P+vJI6nPBrGeihTbw+eww7ng+yjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NrWdGOIrshezQTxDd3WyrJPk3onlEWepiFpUHZn6BSw=;
 b=C7uPhGB5R6xld+8Dzpq4+XvyTr6HIInsp3mIgqzLXBoZmtknPd2C5QGXwGKoS9Fws8/BKPJtId40xRQPCqI3iT/Ge/qoqkqYR5BSAR4Nj8SZiIxPPRnCbQTZ5ooEYabNvYZlqGTK+vSvQPvY2H+T+glg/NcX+/i5TkQ4JiplYuA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7164.namprd10.prod.outlook.com (2603:10b6:610:123::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Fri, 14 Nov
 2025 17:53:29 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 17:53:29 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] testing/selftests/mm: add soft-dirty merge self-test
Date: Fri, 14 Nov 2025 17:53:19 +0000
Message-ID: <0db6aeb73d42876756ba73163cc0cc6e7e8c6100.1763142412.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
References: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0387.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7164:EE_
X-MS-Office365-Filtering-Correlation-Id: ac0b4fac-7693-462e-7865-08de23a6b7e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dKAc5/QmWB6SJE0P71J9afnA6mS5geyotthRQKGNns2f7dC0pI28GOTdptL4?=
 =?us-ascii?Q?6bQBG7Pqrezscx3C78yCXlHP1QXrETtSHVWe4kr5dwU9DBmnYRyeLIoGj1Gy?=
 =?us-ascii?Q?6InhEYancjn4ufXLw9dPxqSa3XX62u4oWLBB8/R/WGM4RqIF57izaOh1f/Yv?=
 =?us-ascii?Q?7NufBw0NFjgdQeRJCiG8WHlCAYjsVnvxX8WCl+qIRFTJ4WlZFeOi3eK/5Y5J?=
 =?us-ascii?Q?XAkcYlwHNWXrBdToU6o2TMql33mKeSzpGMozKBfVxcLhelNeTyjAKHKFZUSx?=
 =?us-ascii?Q?mwbDGh6g8ziGbK80vdtJXdtnpdp9IVxvlm5ExGzpQF6DNk5ImaA+z+smBTEB?=
 =?us-ascii?Q?8xbNgWelWg4z+5xV13hXcQ9QFBqngz3sY33l5Qb2/u1OuOl4c+LL7xQnZCJE?=
 =?us-ascii?Q?0SucUQ4q/5y84PlXIEfMPFH3EksH18P1bLpJ4e9nBGB2bm2/ah2ihMkRTOra?=
 =?us-ascii?Q?VS9PZCO/adU3BqkYdwrmNH6nARVyBQtX6Svgo7ZvgYfQ2NaCIzZ9hYrlocbQ?=
 =?us-ascii?Q?UMFUYtuIIxivQY51Lcy7qV9KpzEjp36DQP6sxGHQTEf/zvIVF4iMNywVLPgf?=
 =?us-ascii?Q?hj8o6pswmJLb3s0uQVQYhkPNt+yVGG/2ZInjNAXYGP5KeaFLs2lRRXWUHq7w?=
 =?us-ascii?Q?7o0QwXoqJUPLn4odQHDBR+h5WLgr3ypt1ydZgGV4CySBgVsxtmgJR9+zhUq7?=
 =?us-ascii?Q?FAeBmuAnQ3CkbynHfpv3mFbHZ8JEwBDGf7nMXF3RzUzrkkw2GdiayhG7pZ9S?=
 =?us-ascii?Q?ahogmph7wnO+0WAHRRwRYLdb/P5rzwqpR/SY7nONYYSPa18NjXs/0BLzD2xv?=
 =?us-ascii?Q?VNwgmIhWiWoA6JJ+ZzXrSQCJ7180cb62+hxqBc4GDuS84nr8RdUSQGtlzsrw?=
 =?us-ascii?Q?kv1GEtaZ+/F5jKtDTnS0ac9zRaw0FxOF6FwZSxvToCqds4rHNrJy+dD0Zc27?=
 =?us-ascii?Q?lv4Y2O95qY3P8C5vkn29fx/GYQJeIZxE15KOaUEFfsT4zhuLW0Mmll0bbZY/?=
 =?us-ascii?Q?tlTggV7ZKprK0+H9GrTT+5PmK0EbARCaELCcmQZtSHARcbxwLCYz5FN+2hor?=
 =?us-ascii?Q?MhVakqxno/+GVX77dixVlEP23WQlX6H4wHl/ILQJjhOwdHCEBvYbohuVsoGQ?=
 =?us-ascii?Q?4Girksbl7qyRncHu5zks7V0I3B+x6M6VWjJUiYGfguYesZ9GTt46MljMRghC?=
 =?us-ascii?Q?8+cS7F83Ibc6UglArePv2lsEtt38KIhMYBVXeuHMHwggqxqSh5nK7hUK6i/p?=
 =?us-ascii?Q?u1M7NIWPJzngXR2BpVvpmXDs7b+JI7yUALLcJ3AgHDF/TgFKJKhEinP5zWmH?=
 =?us-ascii?Q?7ciXFn6Rfe05Jr9HqCX15WsM4XhY2lLj78SeCRxg1VmOOZWRcjENz71UzCOU?=
 =?us-ascii?Q?ScqwcYhZHcTn+SG/SUepmSrd0MDVutTZKAMlRDICUwKXdfLeG8/0XTesbwrk?=
 =?us-ascii?Q?c4/GiFt9KJPYicxTyOLnmthWXrfq6W9V?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nSdBz8aQJYkuqo9okyemYOtYNa+xaHA2odx174nOyAB3D0zqeizSmroyhp6N?=
 =?us-ascii?Q?WKmh736RVC4+2QXIe5yh3T9NBRSLS2ZEEzKi/rOx6g28VkdYIUx4snN3o1e3?=
 =?us-ascii?Q?jlX3r4Z3G53H9N3sMxwKt+XfLJd09o46RWw95XxGJff6SsAKjoPR6VMymJnb?=
 =?us-ascii?Q?pDNJBLz9vgDk9a9vWSglNTcf3bLH6XbIFqB8jdCU7/GmFX4ryg8sQ9fU4cVI?=
 =?us-ascii?Q?KTIztgjluPrbQCNLKUZo/imE9v/nQZhnEvTF6MgJhqmmg71kBAP6t0zPH5If?=
 =?us-ascii?Q?Ie6r3Fjt5Kjo2zXOP9rzDefXM3wT5iWNmtH7i6JNUY6ghYkyzC9NNCQPCm/x?=
 =?us-ascii?Q?+7TkLGU9rtO4R9zNeys53LrOGVrvOhjKwbBBYk0k8M5yZkWr4P/0Dj9vSEL9?=
 =?us-ascii?Q?+OWP+0YLlXZBvXFnRHCZLPOGlrFyshUfktKpVOsiT3QNCfthj9I+6K0OEaQP?=
 =?us-ascii?Q?z1YyuBGTU4BRnug/pncxrmvhH9E0TKK/3QtaES7ALHJbt3Pq6s4g+i3NDT8w?=
 =?us-ascii?Q?JvgChpU0qZFr0FnKIZCpAwtenfk+CxAO+3zuU+zKpGDp+O3Ce3CQNedyZ6U+?=
 =?us-ascii?Q?j4oC/C1QicOuc8rlH0ZhQ24li22HtbvqUq3vMvuXHLdzbphQvQ6CI8G1k/YV?=
 =?us-ascii?Q?Y58dTmpfTTWz/D0nppGl/cBh6Ogn74UbdcpwHYEzrfBeuFX8cEp9xVmVoTQ7?=
 =?us-ascii?Q?BwuNroXSUzihnrCRjCYkhqNu1PeYIczlTsJSfAmzm/vmAy4cKFLtW8wo/DpS?=
 =?us-ascii?Q?PWf4b0GQ+Db0k1J9PtcfnO1xnehGsrwkq/LoFUbD3qvuhgujZxUc4YaClTLF?=
 =?us-ascii?Q?++Yz/CP0P+hkOqMWeZDPzvnRoxpm9f0ixMVVtVqOya5jouTf4b7j1YsydODL?=
 =?us-ascii?Q?peCsK84labFpDocPEGbYFy5JWrGGQMhpBdeMOFmmyd7jE4KkQjifCXBeqNi5?=
 =?us-ascii?Q?pjk7nUaBmbLJdkAkyJiZRnOsYTYDKEvV5dfdnhKN+ptTdTqPAnGJxoAWOCNQ?=
 =?us-ascii?Q?kUw5DCVAblAQWBV8liehTCZQcNVGdsj1S2uxH9TV7TD1feVuRp5AIBsS2Jo/?=
 =?us-ascii?Q?YA9a4wv7MbQzfi1kuZ4E0aaUTD+3OZNZcJ61/o8N2iOCK4lNpfc0CudBpFXe?=
 =?us-ascii?Q?pWnhBkCIf0E0lfHMLiVKc+XO0x9Go5ugP5dqtn6xyIOFRKMpp6CPVQ5Ry4FV?=
 =?us-ascii?Q?RE7yV/LbgGgPhJqyzFX6HfMThr7xklHD+x/BRg58sgpGP7knoh2DJM3hbpNV?=
 =?us-ascii?Q?JcyhR9edf2NnsP+Ua9MQYyeYE7tmVv9Cx43fwFtsYjZD5hM3FYbe7/1S6bkD?=
 =?us-ascii?Q?lsIMXh3BJ5hw3Wucb2dS1GdcHWR1tDHCgrnZJzdiMXj/4POguq3vQeDJvLsP?=
 =?us-ascii?Q?2ZsrytAPZI/L3kn2gaKdvYPk2WxDTWsL05icp5B6Iu90TsFQ0UOPx6bPduxL?=
 =?us-ascii?Q?Mdz9oNR/DQyqv3utFZ4lxzETjnzQCzDs5gGIdvKETAMc/aMtx/M3x5/pRt+M?=
 =?us-ascii?Q?BWLPKkF6k906fPr+ZHOU0/OOyw81S3/l3CuI6dsNsfw2BHZuO5ePRhM98XNt?=
 =?us-ascii?Q?JLklEcn0OyeYXHxq20tPiqni5PqdZytyPuimjNAHawoYB+1hLv945Q+1bFXp?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tCnCNM0DT1mhT6vtXaRpc9oxu0rp2KXNBrQBPFTZmcDJdzyIYniWDXpjILLJA+KklbIxyAVG5lVCE+GWy9woymZ67GczBTs6hisG5nOipAR5NeZnrzTMEvin9CyAasnsLTguO/ldsrlXWaqSY2HrbiLjHkgvAmMH/6/4ig5QAOnEg/5UHGMV5FsRpGaq1BpzP+AUmhwNtJqRNL7Li0rvPSY3Je1GvQRPLYan63c/fWVZTnS0vUtIN4I1r8IfJLJKggIr7TpVa85inAOWpSoQUK5+WVvasBhnASvRrhWaTW5rNYUllsjjiRbmyY8iDomq6nJ5W6Z/Ci5+b6CIxVponR3mK8EdgOW6VL9E+BOSx0jm96fvfNAn+kyaYRw6JbcfqFuXN/0+5FoxkVirGcRBiOvWUxTJgDs2/P9xHf9BV60DYsuJDa1JL1BpvAvyjBkHoYETOqcL1gfdkHVodrUo3dP/oYsBioH6qCC7jRZWdyS7I/u81wtkJlmOgLjYizjq7gNL9P3C67hRhCin0HdsF4bH0GPCt+RAfN7ifVI78JUL6HHskb4WUPATtlc8/9oXPS5auxECDTo3rZ/9tzNgIkI1ZtIuDi3t8AlsA2V21kI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac0b4fac-7693-462e-7865-08de23a6b7e1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 17:53:29.0367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KkXVka/s8w+xFslivZ1k8YjnGprLeGqGf0/D2QUyYSdUHqQwMeiFqu7N5bkKdhlzWD5PYVcbjJ4CL8CV7NBvfehjJrhrBgWwteD6Ms1jH6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-14_05,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=965 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511140144
X-Authority-Analysis: v=2.4 cv=VqQuwu2n c=1 sm=1 tr=0 ts=69176c9f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=-rSKcG2lC8jYhIwHPvgA:9
X-Proofpoint-ORIG-GUID: 1k-SB-o1-xALc8EnZOUmmjGZaFRosST8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEzMDE3OCBTYWx0ZWRfXwGL8sr8nSDcH
 Dmr7ZVwpv7lsIbzRQ+yzvEXcuKd3kb9yX9yPy90p7iZ9CmHsAk4YrlnVQbgbyAhSgdHwTQfRzet
 Qy/OXGBsX9ufqVhQpRaG9kKMYkMNGcqnYja2XLWaBp8BACnV21pRcOXcZusplre2wncBwpJQjz1
 57kC31hVu/XcXcbWYm9XJbCysNWl6jTCZnA6AdkY6p5JNK+6SjdaELoAAMa7oyhBAaIqi6m0Hwb
 ZA59iwvSHpQXUrP4H4psIXjjRuZ8YwjAvXMVPA66Dr+l1TToZbumqVnh7VeTWK+D87YqwU+MBvl
 NgWY2nr654GRwBqmUhwLZJ/KE7U63Q9/f48xtvPfpeeryMbh60MQko/GKXRzsrZVimDD2du4LmA
 BHGpniNScbNkMHveKrE0hsth4w7NCg==
X-Proofpoint-GUID: 1k-SB-o1-xALc8EnZOUmmjGZaFRosST8
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7C4424000C
X-Stat-Signature: x5ty76hmbbe57zu7fjfkn1dzx8ca79es
X-HE-Tag: 1763142820-251116
X-HE-Meta: U2FsdGVkX19z3NA9pVPgOcsoFLRAeldq+2EJYwftiAYJVni1QwiFhKZgfarYqyiOmjyyBaOK3FV8i72GODdwjvpMLWmzwJx8eePW7nz30iIcZWLFTRpIlwCHgW78Z6DkXuSHJZx0igUGk+lzJai6BKjsn8ZSedfxwpLHp/K0WaKXVt4ui9pTJ7c1DSTpb8LtU5cw1v3emQ3VRqipgnkX+iRNURMwIl0/6qJYrmovOUh4H8aA384hYyOkxiOCKRb5hn4NPc4e3vT4QqNk+9n/ZyhyiNVegRfKAlWQEojmruD0Dq4hqMJ0FsHB+Hc6QUfNc0wnwjk6/9sOIvQ34fNCbGCTHNb36duCXDJbbv8O+6ej8TgoyQdLHk19g7OOgew3Lt/WZLyZyvqgK5CEfouU1NDMbmgVA+/aQTVm7jXHI3nUzu5hy6BJi8h9pbmLb/ZcsrCS9b3J/xgRb0Uw69dENw8/E0ibgXzoj6BbyA/Mrcm5TAOlmNKPKt4TxJl9cT+yej744cRL33/U5RxIruMvxLWwcHZ8k63psUwaodYzWsj7y2w361kSk4AVrK6YZf5eZk0gWRlddQJn1pM931aaN4cRuK4aXGT5xyiDSJwCQZxBwXfxw5TtbIq99+Xqa/UV0YXNfvwHOPso4i3PD+dmjl2VXLbRIiLZ44v8w02Iht9lMk5RLQ54RVdTWsGqRGQZX7kDuN0avz1SOa34mzt/pMUIkaN7uqlW6/Pt/y2W/aNVJRXZ8O3Kn0oQuLrbnRWQLnVth13YNyaLf7GD6QWOFiupsDG4p64SmoS9J4yQfgmcSlHlOKGPTPA9nBNfjzLrls7QMdCsv7j2yZ9QwSnMDQSyE84XSlxblaX/B2M0rxRxsOHLqE5/SUPmIjl1GmY4N93+FV9PlLd5SkmRygCw1z47havkUN9GGIhqGKitHLEfn5kOAH2ynGGsA2EFxsUbaZBBYg7hf56aavoOOFS
 xsFUW30F
 hbhJOB27/JKRrg8Yg5QiN5VD8f0ZF1ztkn9Winzv3LVKguCqG0/DoF1kkXmzaarvRvJG5Et4mvJdBibyYxByKU3HhLyfZkhGRGz/qCb03Cmj4QsX+KB05Ssw4ba8nqMpVrUZ3AqU7T4pkXkBLlp4F3hGsaPhvrw4v1UnpXlLXRFO6tbVFrYWRJ2I1MKDoeZbKfwBs7+5+Ts3skVxe5hIymhP3U6AJUZkhf1BYgqcvrMf+iFRUYrLYig038pWpZV9/wcI8Hii5RdNeSr2Cm3snjJGZ/pkLQ4uvf/CtxehBQV5Bo5Ui5gWF626jteEiI85amqagqZDqfSy6jZI4ZdJVWWkLBPDjkjQFTTwz34B5vTV5iCEkPkE1YaoKknm1NjC3TuXtoKoEf+QofRIuI7i7R8GJ+ZAfIL19OnDgKqPZ1TzS6DjhDMhygbfGLzUfvmzKDy08dNIXHScwRBq9/YPbWNSieReIUQLGaAYlX7WvVlmP91pqB/sOEWrawGAc7l3SbGWqc64hiiYV+MjQvttpn6Gr2X+s96w9QD4hG+cmTWx5us5Q4AWu6hGUBniGOiWcac4nmkkMxQeqoi159uhyxhWrOI8AJM+oUW4+jsog7p4N5PW6a2/YsnhBVNsKYk2rGiPi5UeY+QLr8lc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Assert that we correctly merge VMAs containing VM_SOFTDIRTY flags now that
we correctly handle these as sticky.

In order to do so, we have to account for the fact the pagemap interface
checks soft dirty PTEs and additionally that newly merged VMAs are marked
VM_SOFTDIRTY.

To account for this we use unfaulted anon VMAs, mapping one VMA in and
clearing soft-dirty, then another separate from the first which will be
marked soft-dirty which we then mremap() into place.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 tools/testing/selftests/mm/soft-dirty.c | 51 ++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index 4ee4db3750c1..bb29edb1e2a3 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -184,6 +184,54 @@ static void test_mprotect(int pagemap_fd, int pagesize, bool anon)
 		close(test_fd);
 }
 
+static void test_merge(int pagemap_fd, int pagesize)
+{
+	char *reserved, *map, *map2;
+
+	/* Reserve space. */
+	reserved = mmap(NULL, 4 * pagesize, PROT_NONE,
+			MAP_ANON | MAP_PRIVATE, -1, 0);
+	if (reserved == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+	munmap(reserved, 4 * pagesize);
+
+	/* Map a page. */
+	map = mmap(&reserved[pagesize], pagesize, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	/* This will clear VM_SOFTDIRTY too. */
+	clear_softdirty();
+
+	/*
+	 * Now place a new mapping which will be marked VM_SOFTDIRTY. Away from
+	 * map.
+	 */
+	map2 = mmap(&reserved[3 * pagesize], pagesize, PROT_READ | PROT_WRITE,
+		    MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (map2 == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	/*
+	 * Now remap it immediately adjacent to map, if the merge correctly
+	 * propagates VM_SOFTDIRTY, we should then observe the VMA as a whole
+	 * being marked soft-dirty.
+	 */
+	map2 = mremap(map2, pagesize, pagesize, MREMAP_FIXED | MREMAP_MAYMOVE,
+		      &reserved[2 * pagesize]);
+	if (map2 == MAP_FAILED)
+		ksft_exit_fail_msg("mremap failed\n");
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map) == 1,
+			 "Test %s-anon soft-dirty after merge 1st pg\n",
+			 __func__);
+	ksft_test_result(pagemap_is_softdirty(pagemap_fd, map2) == 1,
+			 "Test %s-anon soft-dirty after merge 2nd pg\n",
+			 __func__);
+
+	munmap(map, 2 * pagesize);
+}
+
 static void test_mprotect_anon(int pagemap_fd, int pagesize)
 {
 	test_mprotect(pagemap_fd, pagesize, true);
@@ -204,7 +252,7 @@ int main(int argc, char **argv)
 	if (!softdirty_supported())
 		ksft_exit_skip("soft-dirty is not support\n");
 
-	ksft_set_plan(15);
+	ksft_set_plan(17);
 	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("Failed to open %s\n", PAGEMAP_FILE_PATH);
@@ -216,6 +264,7 @@ int main(int argc, char **argv)
 	test_hugepage(pagemap_fd, pagesize);
 	test_mprotect_anon(pagemap_fd, pagesize);
 	test_mprotect_file(pagemap_fd, pagesize);
+	test_merge(pagemap_fd, pagesize);
 
 	close(pagemap_fd);
 
-- 
2.51.0


