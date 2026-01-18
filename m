Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84FFECA5FE1
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 14:52:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73C806B0089; Sun, 18 Jan 2026 09:51:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704E56B008C; Sun, 18 Jan 2026 09:51:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B8476B0089; Sun, 18 Jan 2026 09:51:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 289BF6B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 09:51:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C23E313B2B7
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:51:57 +0000 (UTC)
X-FDA: 84345374274.28.8D62853
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4743920005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:51:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cTm3Tg+H;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=l3B3mChu;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768747914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i8ZBwvo3FR/dBKpFyyh00VweLyM7/LYGelOu70S7kPo=;
	b=7cdjVoqg972/IWDgeIPnP5Z0v6QbseBV5lPAk35yIYiVpr5BgUkh8Xb2vsRWESTl4qWVE4
	ypUCWEREO/ozPbfAbIUUR8ko/rpqVtoCjiFqo65xKL5y5Wo6ZwmdB4HQ+DizEVXCYAN8AS
	0RsG8k2RDK+EIWrx53hZOQmioO/0M18=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cTm3Tg+H;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=l3B3mChu;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768747914; a=rsa-sha256;
	cv=pass;
	b=Cu5DgMxKM3SAAW26K7HbGDrKMtI5C4gDe7wGvLnl9N97TQgAHF7+4qpXrp9Bs7CAQmNHH1
	Zo4SwB/JogfbJ+8bPXvv4LIhTv3ZT3hotySqKtsAaJHBjbJ0EM90gfFxcDg225WApA7aXn
	5LrFaw7nyxQ15QHsv+eEw6taUb5qnK0=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60IEoFTo3690593;
	Sun, 18 Jan 2026 14:51:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=i8ZBwvo3FR/dBKpFyyh00VweLyM7/LYGelOu70S7kPo=; b=
	cTm3Tg+HozVqIfMbE1WxkWzOojoTeSLGBgMN2bAx7tyrj3+tSFTGRIoNk93krdm4
	cwLv4WtdHC+aZqWRAiN3n3F5AVPWY5UN7DpCxSQTJ3unbWdY2GIc8huOhdBKJQQT
	9C6ebf5heEO3A4hBXUumRZzkvGJIwUU6lULNqDiox9K9iYBDqRu2T7ERzuujs71v
	nxIYFBa2bXsMRaWgdUvmGxq7hXECxh6Np2XZmopZuPMrxuFuXpyK52NJsWkG7LNb
	Pbx6Fo8AxwRJXDbX1jCndVqo/cYYu1nFoK/0ZxdlIg1MS/hOivEwQtqvj2G3dbCt
	x22y/Ir2cqSnT4CBtgUUsA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br0u9hcdr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 14:51:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60IBt4ce032145;
	Sun, 18 Jan 2026 14:51:48 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010064.outbound.protection.outlook.com [52.101.61.64])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vb7ctx-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 14:51:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AWMK92q8sI/X0acrlFbjuZoe3OSDzzI8jLEg6HNitzjNO5I7hQ2BLJO/6sR8MeXKmEvtOrKAuKIJsTJNfwdFGhU00qzypF7EMH22FZVw0z77RU+Ow71j5oyydCfIfv7T2LgtPjlT9LbsGqltB5StHnIFHeHEC+kqxAAcM6X/84yeIOEiwLzauDbOql3VQW3XTE6oarWxHwz6JChYewIciLt2SVi01KSFd+eTYnmvWp0yzQrDdZGTYCuu+irfJ3002lIK2iKW5cpPbjZMd82ZLJAIPfoJYGQJ1Gn0gxtAAkTu2CZOwqZjFJ1xMJ9EZ6eSXWsYcgh3P+9ZA8XATZ+rVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i8ZBwvo3FR/dBKpFyyh00VweLyM7/LYGelOu70S7kPo=;
 b=KlTZQpU0alqFE8xZunjBtprPfh7ARw0cgDUVAUxHHDtvdlWwT6mrL98mDOBFNrc7vnGfcSTUJxRmiyLUSL34OgQtsYioNFifFMV28wqBbYGf4ln+lOWlrrcWAVKKxNlQE5puihyxFYy0IipPEgK+Zn3CTRcW4AvgNQwyU9kRZL/dgW9btPmENel1XflvZvFI6qppr8kSUzySLmd9EgXq7H+dTeu+QTnDfxc/2998uV7YRqlKzmEJ+AU5qZZl3VkbEtJ15oEfLhAHw5z9wVC/60/5jdlxsz/qjklILyegsDBsulUif5LZGAfn7Rlsp0orjhEMlZ+OLvyZQyBre4m0pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i8ZBwvo3FR/dBKpFyyh00VweLyM7/LYGelOu70S7kPo=;
 b=l3B3mChugrF/CM/M5H2RlJ+JM9YFd+MezsKDlVyA5FlxyD5M61te7UkU/D4HhjpFCq5KdLn6YGkQfAzFV2ZlmNGbCEXF3/NJ9Y0Nk8trzPBcAn8hzRhz3bneSPE/zv+a2RjL04A5s47kCVu/NX94d25jWClhircD2n4Eph6Zql4=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA0PR10MB6723.namprd10.prod.outlook.com (2603:10b6:208:43f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Sun, 18 Jan
 2026 14:51:46 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Sun, 18 Jan 2026
 14:51:46 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/9] mm/rmap: improve anon_vma_clone(), unlink_anon_vmas() comments, add asserts
Date: Sun, 18 Jan 2026 14:50:37 +0000
Message-ID: <8644e89369be0cc89d7ac57443dff9e822803c91.1768746221.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
References: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0235.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::6) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA0PR10MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: 599d50e4-48bf-456e-234a-08de56a11a0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eT0QXWJ7AA0HgycOGI5jsNM5gnW/wuB+qP03KeD4dk7pPXMwhGEV81KNOJ8p?=
 =?us-ascii?Q?6pFP+nVLlXphcm6+m5AW3dlGxFovylwcY4bHyzA4y8p8TyKfzYONyfACCsAn?=
 =?us-ascii?Q?Wkap64isAo4/UDMur28GgXgiVcBGhhqMAR85sdunwjnrd5f686gWpd0j8eCq?=
 =?us-ascii?Q?GpUsx4K0DGZ6Uc/JWfitC8Btg4pqFxLvCVYafY0P85GwEPl9ZCr/sQNu1lYd?=
 =?us-ascii?Q?mKyjOG1TYe4g5DP4L37djSGnO1DPxNnPbrdFrur8PtGczzalhbluwv3TpKgy?=
 =?us-ascii?Q?K74TYi9LTFHfmiIxJsHHz/BEsy/i5xOzkOR0dlBYvsqDSNbOK73IjPbreqea?=
 =?us-ascii?Q?UPSn23kTPvCa+zQuWaJKWJYWlykstHllIHi7UJ5X4kK6WtX56GHTv5C8GccB?=
 =?us-ascii?Q?AckTMz+2jt4l3wXewKQaxY/9GfOLV8FIjRQRq6TfNsJCOvS6udvBB2cD/bJD?=
 =?us-ascii?Q?8wA+81YiL4Pwf2Sy0Y8VgBRpraUlGxJeSBV61S3PJTMMB4gGr6Z5s5zJC91b?=
 =?us-ascii?Q?I9gqNtkpw0es7kXf4Bcj3QU0jzr3wgogLngx2oj13Mkq0lHL0fXLQco9ABfV?=
 =?us-ascii?Q?5+okXKi3mGlGUlet0OtmV8sGpcjco84K8GeTii5RjppHOok2lmI0wFWQwWPQ?=
 =?us-ascii?Q?GTh5eTvuG1Gq9YdxR5JpJAwbYC+zptcNZOQSJJDxhMFyjps1dXD/j3ryOZS0?=
 =?us-ascii?Q?lzv8NESKsSDuKX1cYPWq8GI0F1oB4gJ3FeI9x+lnvRJ5SHT2krKeK51i3H1w?=
 =?us-ascii?Q?Jju6fSAkRwD5AW4zK+QvRCZ8P4ESv3Ko8NSrkZYg6MtWwsyyofTGnM6pqYai?=
 =?us-ascii?Q?NW5FkVtHqOPaHUz5wDulsjX02MywoQKyj14XV5nkLkHTsQlwOOenLmD64pkn?=
 =?us-ascii?Q?AXD2oqmq8TJ/rMRsWu1Z6invBqH0ZKb6nMuaisn0OsrWpE1kXYe5aEAEXPhq?=
 =?us-ascii?Q?ENPzV321uExwhdjIZVcMpJqovNOTcIwiB1LiQ7RWzdM8+HuAMH4L1gYxYT5J?=
 =?us-ascii?Q?XFLmyq5sqHGtTyp0yJVSSgLwHrd21JqIQEtulHSlqWx0pPa6kdKUM+199QU3?=
 =?us-ascii?Q?+npWck8jyyeHZ0AdfPKF65hEPWjLeChSLWohGYelVPCLciJb1YrAqcHRZmcH?=
 =?us-ascii?Q?u6oc+1wOwRjBA6O0RhurUBgR9edZ3e/2CXuTxCvU3W4yP3oXn9PYCcv8Yz5g?=
 =?us-ascii?Q?sblFLsn9vmwGSFjYF9vO9IpX+Jfg7FdYiSpX18v7d9gx16KOSEwe0adGu22v?=
 =?us-ascii?Q?2fSmEQo8bp4gGGIoPUgHxDSANb8yOLQt9X8qR7psGoUKH7KAD3GjUXJmfYrM?=
 =?us-ascii?Q?xOC1wTUdyGhnfLyjcuiigATxP/1SA6sqojFdUdE63WLVJl6fXxGQMV1kztiU?=
 =?us-ascii?Q?21ASe9dtFxjMaBRnHKIk92D9VGI5EZl1kSh7jcoLQmCT2VurH6uCaoEPG5Td?=
 =?us-ascii?Q?v4MrEQ1OnMEwTHwyaUDhjUPcdZhbbJzxHrQFCxpp9xG+mpfc2YoTCRdL8hhz?=
 =?us-ascii?Q?juLC7pe8VQqX2OOvCey/j6B3beKNWFgyCX7ow6FlLmaUJ40FHeMGkD/oCuUb?=
 =?us-ascii?Q?EjxgwFRTIRukcOlkHC8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gs9ZPgR3PTsJ6asihU7r2WypKTXyt+f3JtMyhZIzAd/Kplew8yJI7OrYlkPa?=
 =?us-ascii?Q?urD+JRb4Xv/OK/L3Om3uYMme5GWC7UXBapQ3mUYL/1uBp4wtersxl9KJD+6h?=
 =?us-ascii?Q?cgXp6aj1YE+v1fHzqUBsQ1w9ngA6jBPilkmLhk+D8t+D75iT973ECFK/pqeE?=
 =?us-ascii?Q?rKjiTtz7EfNuzfnG/UDW4yPS/Jkl0yC6wsGGRqzWHTopBVVpWlyfNofM6Zdw?=
 =?us-ascii?Q?lyoC1AI6dsGRmnurkze4p7Qf0rXslzrXsRWwHaYh4ZwlG+TYWad8MWPl9UQY?=
 =?us-ascii?Q?IbcHGTKv8lC5DRsp8cYSz23ONRmO0sPyW6TRJJReTlP8BalP96zGRt+4D8kX?=
 =?us-ascii?Q?Oou67lhk3aukRXLXR3YDknK0ar1CDmZL2n0hicYdcBdtoXX105SaMLWKAn9B?=
 =?us-ascii?Q?qWeRGcCX7UecK8sjuqM5NfhRhXKX2IiMHJ69Q/16W1Uktr6wm2EZJTxit6Ip?=
 =?us-ascii?Q?IBn7mY8aq1XATKK4L+sWgvPOoeDXcsR3g8dP2A4rvG+Tp4YMKjz5XXKjTb/8?=
 =?us-ascii?Q?hRjt0P45lckvDWyVl1Y/G6n95kUct7A0bLZj1fo82WG7x6vPChTbFhe7QPwI?=
 =?us-ascii?Q?Dpiqrp8z/3kmae9qVM4Q0YVcb+/7rBzs31L+Sinx8u9+PjYmUVRhMS1Oyg5t?=
 =?us-ascii?Q?9/vCx3hpsmGLUwFoXQWjRKw6MMq5Hn0xBvWdipkHpphAh9NGcG4fj2i5WggK?=
 =?us-ascii?Q?T9/Zg+TfrS32Nyvggm7lor7Qjc2laC+GpHaGAOQMbydEiw4zvRwK5yW+4smm?=
 =?us-ascii?Q?zqnILVyhDxQ9FzO1wQ7tkEJ/N64WK8HIpTVhjht2K2lMcbtsQt9HBsoRCW9z?=
 =?us-ascii?Q?HHm27dvSaoDXjN0SEiFSaIewExvUDk6bGeZkob+YZn2DyL6wuSff6ZcWSlh0?=
 =?us-ascii?Q?SHfGfstYqk3Mg8hWEgowwsQafjaJgCMZx+jTlcKap6bcNNq7borR1lIHEGRL?=
 =?us-ascii?Q?waVafTU1fOT/wTxrmraPn35XvLxkVgMdFLZDhXFzueO5iIYNCVlQYFXO1Xdf?=
 =?us-ascii?Q?nEzTqztF4p4eQlMt5+I29hVXz/nWJ2PvMqseuFru5GRIySXv2qd2e/2bKwzU?=
 =?us-ascii?Q?u9BVUJZ/8zkj+4MPi+p5Plo2RUFJUF3y5+bjxfA/qVb2u2iaxlJlYdm9b4is?=
 =?us-ascii?Q?pR5w/cQR6DI3uJBZWx2BacHJZqqyf7H0Zs4cGUWTapgmSZvYQJ96J85Udsah?=
 =?us-ascii?Q?1EfFkS5abakfMoEqQ6FTsD3DNwK2iDI5TEDPgcmfVq+kq9caW6iVfKCiJ6RT?=
 =?us-ascii?Q?qvMdO9heldC7jklvj2TE0ONF7+cii5nDRUiUPQfurRjfHlwz3RfXEWVJSXlj?=
 =?us-ascii?Q?9sRip4tMpW20+BRKZ+zTx7fkbscSiXJ3dcLcGRvYnbP+fYvbv1Co/hbpjbcW?=
 =?us-ascii?Q?wUqRIn0c1RPVrMm5yKQMmTu4Sk8VTuGfvdw+EI1L+HqTV68qUXGxsoD48r7x?=
 =?us-ascii?Q?Ub2BdKv6fRu0UIxeaEGJv5X8T2HeYUlEXtzSmhJP16pt+X0XBUBSCG0qtvJg?=
 =?us-ascii?Q?OEUuqg+//qTeIrsdeTmBe1dICLuRQ3t+Z0nMtKVMWV23NIfUVAFlVDle7js6?=
 =?us-ascii?Q?o9ZWy/ZN3IJs9PGkCrLqrvJBqhTJUIkm6fPqIA+hLUvqwLwzE3MJfX31Jm3Y?=
 =?us-ascii?Q?O9eDZ0+92zKinqCJrzFRO80+k0uwLqvc1Qns/0GSPCPo+hD4N93GOf2vwUNs?=
 =?us-ascii?Q?2O3PkY0uQUHXO1tpyT8v0xF3DPQNmif+cTPdzO/ouEfR+20E6C9sOqxcS6a4?=
 =?us-ascii?Q?9ev1vQtA11saXsHeU+LPwcxepc/l9Dw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Y9ADdZLGiGheY/Vc+PbgfmhqOlpR0xJDLLfGC5Pm20A2nRKfT9qImmV/nMy5iZn8Z1grz0/69HK+XDbeIQcgIOXq3lndmn8ZwH0lRHe1WfiBdAPwA1nwsirhbN0Eh2JZdud6t3KqAdW5ymA2Lq504hYaYs54spxGz2q/z5htxTmLxZV3QpXRsM+6e4M4Mluh1phsBG2ttZh6shJ63dAy793uePMC5aaRBpcbLkA7nk3SQHuNRYO1tSwojNsD5FvRlutJq9BYHKEdGrQmTDaMA38/UGXq/mrlQjOe8fB8xyMwKCOm8HBNCXkQKRN/VdHV+V1UeRhQeiNRlWvpyE9eQQ23mdYsICnDFoxgpXoL87cdaAXA+AAKmDNbty3qfUfdKrWvL+TtSNbXuSIxG23pU+krfyUSnl129OgujY1E0wSN8KK+zL6CHRCsQjHwjkyfWZEQtJ0zL3t79Ql4ClIHuLFxjlyqLvM2ZP1IXiRLAWQ2XkrzfelguzqoLuP9pBsxSaJW3V7cUpQy2ACOGO49QMSNS4HtiBoeqCb1QwzlN9QQxa1haykCxrxulc8c8a7Fg20Fg2CXifhjzsdu7sb801SQSghWpk1dGc2N4d2XMyU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 599d50e4-48bf-456e-234a-08de56a11a0b
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 14:51:46.1052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2jWMw9fJpYeNVlr+7FLAGuBqZhM9X5mrNhSXum8F+bh6SCw94X9U6WeYCuXpcwJCUhDCm+fGx5nJ3phFpdbNcZLernXBSYrwDb2Y2uBUqBw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-17_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601180130
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=696cf384 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=TS5ZMjQafXG62o6CVrQA:9 cc=ntf awl=host:13654
X-Proofpoint-GUID: etE5OhbUMQa83ODW-kA7R1ovmYlAZBOc
X-Proofpoint-ORIG-GUID: etE5OhbUMQa83ODW-kA7R1ovmYlAZBOc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE4MDEzMSBTYWx0ZWRfX/VcCe6Jp0Mu8
 C7v/eSB+U2FMSnbqRqIXRL85HZpHbzAmQD/XWInY0yw/jmyGMvJX/1yFaQ4+KJq4RQJ4Ye1oWTE
 96JqRqc4boGIC1l1pcHHFqWQXqg08wYyxeVFKFNsZb7oG/DCOTOn++O1ft7zZR7+JqxmOx+dJhn
 tXx9zyqCwFWEoDsHnh409wel3X4kn7v66CUpoCCOBoM9Kw6YEkNdtguyvqz/R+ZQNqEfP5SZUVz
 PlxzRQAelomxHo079b0A+v0jSCbeEEXzJgeN0JYCt2an/A9Or07S7k44Ynwj9R6XxkKNKwNwIAN
 +ZqYn5huHXu25mHxR9IfT7dtBpau52uD9Dtl/WKtKJJM3VREH0pga6oEj/gEgsmJC0b9pS2cFqj
 tS+PLFoXYC+Zou/stnoFmmBfUkhIA5eSAmwkbMYERW/RLfIbEHoJtvfYOjJmjharusC+wlTGdK6
 HlvcLZw/8/YZbqcdX0m8nPRJ4/CbZHyKoyaxcFTM=
X-Rspamd-Queue-Id: 4743920005
X-Stat-Signature: mro7wgkntrorgyarke5mptq8h64gbfs1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768747914-153709
X-HE-Meta: U2FsdGVkX19t2fVWXBFFmaMInDEViJ4lRtPfOJHBVHcb84p6se8C8GdbCtsNMCP8q6NTk5BNE2xbTkyuPsPY6z0lT/qaGdNnCYbyI1yDfVmLWoqSUM3lY9/LRPiPRY6f4ITas1/VsXNQeDMQxHhYj+STle2W0qcT1ohSG1iYtjxGTl6EY6QgpGhaWsusPgfM5dkgR/rghMEcwV9MQveCPs7CqwXuTqnzDZoSW+br7sFE+4rAU3BmD1Saa5nQ3xpHSg2DfVkEBPOivPlZtf3TorcyJMJio3vBWQeq1nmCZiucq+Xs7N62vKLfjrLINCTQxNLUwT7auENQHXBhP9I01Urzngv1NJZuPqJBE65dClXusCJIUxPmF7O/pG80jVUd0kqMm5RqtJ5Lo0Ba3XyqeerwPmwSyNozemIwlXCFRpYQC5sa6DYJEYaW6/9I8NBOFYs4gBrvjb/7xyhjSL/Ac5b46GVZJeXXN7+nmNb2s7M/DdSWyRQQGKqWPaKFhojiymQkwnU5EGd3b3g7RovMnW8snNwmg3QyqKDB+31+77+B1MRLzJX60iotly2+rBRL9uq/r7OYIzSyxIqkNznayyIvnfDknNDqDlbtk0kgDHleanAkziW4ljZeWqgS5b6CtG9Ly6h0swaFiC8CC/mNkawnyjKCNE1U401DGd3IPOGfe+dIYxP597uQzrgsMS9twrL5FuS+uZbbk3C9mdpNatGn1Qqo+o03GmXmttrCvueUQkPVWnyVxV4tAar+Nl3Kx7WQIrYPO/kExqUt0uBjtkuqxQPy8m466+hO0FJprPO1S7u4fXmTBj9quZ+ClP1gFE1zRZ7SmufDFI8SB4M5s1dZ7hLqgMKXLkBoCfPRrlNKIc8D5WGki4gl/bZR/Cc5ZsygelhbIDukLYjdnuojE6lzL0NlxWTbBVGbViDqF7YwAT4QzoUfoce9PYbENWf2WjLO5PUEmXMLc56tIrx
 lTE68TPa
 icLvPYZKj+GMjoM0MD+nPe0OLib2olh2cuQbaRAF4EFF7sYEvgWRJWml/+pBaSqB6r5wV2Hwmtw7N3GLTn9tyHCYgoVyxLrB7Ac14djTb1tLkezkZEjAsXOoWc0XlIVeHKkuxsMI19fd9y0StFPyTGASP3VeH9LGVfqP90ajpLQd/WXKFRB9Kdnged7aOViZD7iRJzCV3379bcvbkWP6IFtQ5othvOyDois39HmSzYQ71kVgEK+L02+cw2tA9/OUnMeBkiHgJ2fRyyc8jDF0GaCLUGfGfQLTh6XX40Ob2jh2DCVWpTfgq6i75xInDum4slcLs0HG9fqP2sQbHf5q3UrYL/IPi7e8gdM2a9zly/ggX3XJRsz1kDNZmaV/oc/908dq7pYOQKUUCbVzKWTw6WXSPDBOds4du3Gd/lmjQ/qX4qbv7XKPWROVa0QxSOv7KvXw08gUF/vBxN9NXdb4meo+6CKsJfNsu/X6vl3419Rkax6B4LStDmHQkIJQvFs0EsgAa5kH8OMOvSgQQVUTy/fZyHyzyYQ92pCD3+UWuyGbYo53zvHQbtqOE8zeEL9ZlmZxrXAgMhi+xydqFSK/kZM3A75+TqwQEsjSoSzEaUpVWoeP3Mj8cFtJFp8CoIY827G5sPdKmszzTV97C5j+uLRxDooxQacNKwM/P+MaaeJWU7dDoYnIk01ANbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add kdoc comments and describe exactly what these functions are used for
in detail, pointing out importantly that the anon_vma_clone()
!dst->anon_vma && src->anon_vma dance is ONLY for fork.

Both are confusing functions that will be refactored in a subsequent patch
but the first stage is establishing documentation and some invariants.

Add some basic CONFIG_DEBUG_VM asserts that help document expected state,
specifically:

anon_vma_clone()
- mmap write lock held.
- We do nothing if src VMA is not faulted.
- The destination VMA has no anon_vma_chain yet.
- We are always operating on the same active VMA (i.e. vma->anon_vma).
- If not forking, must operate on the same mm_struct.

unlink_anon_vmas()
- mmap lock held (write lock except when freeing page tables).
- That unfaulted VMAs are no-ops.

We are presented with a special case when anon_vma_clone() fails to
allocate memory, where we have a VMA with partially set up anon_vma state.
Since we hold the exclusive mmap write lock, and since we are cloning
from a source VMA which consequently can't also have its anon_vma state
modified, we know no anon_vma referenced can be empty.

This allows us to significantly simplify this case and just remove
anon_vma_chain objects associated with the VMA, so we add a specific
partial cleanup path for this scenario.

This also allows us to drop the hack of setting vma->anon_vma to NULL
before unlinking anon_vma state in this scenario.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/rmap.c | 133 +++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 107 insertions(+), 26 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 262bebe6f947..cdb7618c10b1 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -258,30 +258,62 @@ static inline void unlock_anon_vma_root(struct anon_vma *root)
 		up_write(&root->rwsem);
 }
 
-/*
- * Attach the anon_vmas from src to dst.
- * Returns 0 on success, -ENOMEM on failure.
- *
- * anon_vma_clone() is called by vma_expand(), vma_merge(), __split_vma(),
- * copy_vma() and anon_vma_fork(). The first four want an exact copy of src,
- * while the last one, anon_vma_fork(), may try to reuse an existing anon_vma to
- * prevent endless growth of anon_vma. Since dst->anon_vma is set to NULL before
- * call, we can identify this case by checking (!dst->anon_vma &&
- * src->anon_vma).
- *
- * If (!dst->anon_vma && src->anon_vma) is true, this function tries to find
- * and reuse existing anon_vma which has no vmas and only one child anon_vma.
- * This prevents degradation of anon_vma hierarchy to endless linear chain in
- * case of constantly forking task. On the other hand, an anon_vma with more
- * than one child isn't reused even if there was no alive vma, thus rmap
- * walker has a good chance of avoiding scanning the whole hierarchy when it
- * searches where page is mapped.
+static void check_anon_vma_clone(struct vm_area_struct *dst,
+				 struct vm_area_struct *src)
+{
+	/* The write lock must be held. */
+	mmap_assert_write_locked(src->vm_mm);
+	/* If not a fork (implied by dst->anon_vma) then must be on same mm. */
+	VM_WARN_ON_ONCE(dst->anon_vma && dst->vm_mm != src->vm_mm);
+
+	/* If we have anything to do src->anon_vma must be provided. */
+	VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_chain));
+	VM_WARN_ON_ONCE(!src->anon_vma && dst->anon_vma);
+	/* We are establishing a new anon_vma_chain. */
+	VM_WARN_ON_ONCE(!list_empty(&dst->anon_vma_chain));
+	/*
+	 * On fork, dst->anon_vma is set NULL (temporarily). Otherwise, anon_vma
+	 * must be the same across dst and src.
+	 */
+	VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma != src->anon_vma);
+}
+
+static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
+
+/**
+ * anon_vma_clone - Establishes new anon_vma_chain objects in @dst linking to
+ * all of the anon_vma objects contained within @src anon_vma_chain's.
+ * @dst: The destination VMA with an empty anon_vma_chain.
+ * @src: The source VMA we wish to duplicate.
+ *
+ * This is the heart of the VMA side of the anon_vma implementation - we invoke
+ * this function whenever we need to set up a new VMA's anon_vma state.
+ *
+ * This is invoked for:
+ *
+ * - VMA Merge, but only when @dst is unfaulted and @src is faulted - meaning we
+ *   clone @src into @dst.
+ * - VMA split.
+ * - VMA (m)remap.
+ * - Fork of faulted VMA.
+ *
+ * In all cases other than fork this is simply a duplication. Fork additionally
+ * adds a new active anon_vma.
+ *
+ * ONLY in the case of fork do we try to 'reuse' existing anon_vma's in an
+ * anon_vma hierarchy, reusing anon_vma's which have no VMA associated with them
+ * but do have a single child. This is to avoid waste of memory when repeatedly
+ * forking.
+ *
+ * Returns: 0 on success, -ENOMEM on failure.
  */
 int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 {
 	struct anon_vma_chain *avc, *pavc;
 	struct anon_vma *root = NULL;
 
+	check_anon_vma_clone(dst, src);
+
 	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma;
 
@@ -315,14 +347,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 	return 0;
 
  enomem_failure:
-	/*
-	 * dst->anon_vma is dropped here otherwise its num_active_vmas can
-	 * be incorrectly decremented in unlink_anon_vmas().
-	 * We can safely do this because callers of anon_vma_clone() don't care
-	 * about dst->anon_vma if anon_vma_clone() failed.
-	 */
-	dst->anon_vma = NULL;
-	unlink_anon_vmas(dst);
+	cleanup_partial_anon_vmas(dst);
 	return -ENOMEM;
 }
 
@@ -393,11 +418,67 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	return -ENOMEM;
 }
 
+/*
+ * In the unfortunate case of anon_vma_clone() failing to allocate memory we
+ * have to clean things up.
+ *
+ * On clone we hold the exclusive mmap write lock, so we can't race
+ * unlink_anon_vmas(). Since we're cloning, we know we can't have empty
+ * anon_vma's, since existing anon_vma's are what we're cloning from.
+ *
+ * So this function needs only traverse the anon_vma_chain and free each
+ * allocated anon_vma_chain.
+ */
+static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
+{
+	struct anon_vma_chain *avc, *next;
+	struct anon_vma *root = NULL;
+
+	/*
+	 * We exclude everybody else from being able to modify anon_vma's
+	 * underneath us.
+	 */
+	mmap_assert_locked(vma->vm_mm);
+
+	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
+		struct anon_vma *anon_vma = avc->anon_vma;
+
+		/* All anon_vma's share the same root. */
+		if (!root) {
+			root = anon_vma->root;
+			anon_vma_lock_write(root);
+		}
+
+		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
+		list_del(&avc->same_vma);
+		anon_vma_chain_free(avc);
+	}
+
+	if (root)
+		anon_vma_unlock_write(root);
+}
+
+/**
+ * unlink_anon_vmas() - remove all links between a VMA and anon_vma's, freeing
+ * anon_vma_chain objects.
+ * @vma: The VMA whose links to anon_vma objects is to be severed.
+ *
+ * As part of the process anon_vma_chain's are freed,
+ * anon_vma->num_children,num_active_vmas is updated as required and, if the
+ * relevant anon_vma references no further VMAs, its reference count is
+ * decremented.
+ */
 void unlink_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc, *next;
 	struct anon_vma *root = NULL;
 
+	/* Always hold mmap lock, read-lock on unmap possibly. */
+	mmap_assert_locked(vma->vm_mm);
+
+	/* Unfaulted is a no-op. */
+	VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chain));
+
 	/*
 	 * Unlink each anon_vma chained to the VMA.  This list is ordered
 	 * from newest to oldest, ensuring the root anon_vma gets freed last.
-- 
2.52.0


