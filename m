Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C492DCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 15:24:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9B18E003A; Wed, 17 Sep 2025 11:24:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ACD08E0003; Wed, 17 Sep 2025 11:24:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174CB8E003A; Wed, 17 Sep 2025 11:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 02D058E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:24:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1F161405CC
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:24:58 +0000 (UTC)
X-FDA: 83899115076.30.BD34E9A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4E16840008
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:24:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GkjsqUdR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dsV8vprg;
	spf=pass (imf17.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758122695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Fc4HClGuvBvHZBqr9iXzuPs8SLdHBDBTi+dHyVBt+o=;
	b=Rz0GFvH6WA3VMzXv1gLhbtOrqRRGqo/JxdrO/o5xMnhTah+/cz3bH5Pan0CuXYQUCROzZ/
	sQ9blohJUBJHwhLLQofIIZLunBIaOPG7qhR/SfGWvxQhUgoTLZjpWCgTfm324Ao+UGRsmE
	r2HXaMw3JPTiqi/TwmeCCd54mRqbaW4=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GkjsqUdR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dsV8vprg;
	spf=pass (imf17.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758122695; a=rsa-sha256;
	cv=pass;
	b=5aUOFqssiKtZ4xxnvv/tQxPK9/vOslgJw3rC0odASalnP19c+f4cv/jNy/LvdsxN4ilXId
	iyBmKNZEePxJ8MZadzBB5oqzw0ZxVYniwUyH/EyCerMIHfer/eTMArmvTLssvnatOlLkm4
	bCOs1tmuWscFG8vrz+K7xHDvuwtZQWA=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEIUGq010043;
	Wed, 17 Sep 2025 15:24:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/Fc4HClGuvBvHZBqr9iXzuPs8SLdHBDBTi+dHyVBt+o=; b=
	GkjsqUdRZm9b3z0ebGo/FdZ2AXIGw+dLRQCXmKfI51HDBZSjvwCJugbWCftivAtJ
	xYqEprvDMTYwbiV0YoW/aj7rOnTw6VFsBbAIKWm7AkWj9BlvP/Hnt1KPj9A5J6Y2
	QxWL8Db6irhl75r+B3GJJ6RFDXY/9Zsjl3FncTE/FDPgPAkOV7YcRwZ6wq0ox2Xn
	q3gBHdzd5iz2cfXCo8kGUI84RYWlh1jhr3/jshVIHyi1Vw99PNS0G2O5eS6iF7U1
	fAMHhewEnXZPcW8k7Kb3FQjULKHQN+SnDnFG1tQrRZswnvBQn1kKz+QziMzDwlzg
	a6t4assypgZy8XSdwCDfBg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx6hhbx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 15:24:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58HF9RN0028825;
	Wed, 17 Sep 2025 15:24:32 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010030.outbound.protection.outlook.com [52.101.56.30])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2dw9b8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 15:24:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lDWMmk1hxV2cILB4+D+7rLrlEPj+NSIRMUDeazX5Md0MtiHe44CPZODOdNmLVdbeNOQafF7y7emkinSdAh623OKljS7ZpW+5naggiAuMi21CSvUVl2OHFKKnC8HJ930ooXZg5/qAvAvsgWgkK6jwi9bDoIXvvOE3rcaZkmKzGaI2a4r0la9773vNFm4cknJ08TUCIsHVPbTwmpHnvuKWwwlWmS9svlMXxlhPX4uC2YKd4apbJU5a+Cigr3B39wC+Q84QaPE8Z4hyX0akh7Ft1uLu5YndHtiY7QKJBXwghX7RfyDKXtot1MfC/bCXkTasf5PUc9wq//Q7beM3x58fvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Fc4HClGuvBvHZBqr9iXzuPs8SLdHBDBTi+dHyVBt+o=;
 b=ddBwLCMD+xDRDNTcxsmd2HirvwLLmS9gPguSs4pamXa63QfCxwIXhg8WwXmLGk0SuyL6SsHhns0sMmD/wlcXhjfqmOstKt+XPXlp92pDfmd07bDIWqJZ5HpgYR170YkuRfN3rCfi4eCFCzGdPAFK2KGzYMdHYescuNqAZrU+vLgsAZKNHNvD5Axn6ksHSg/wQqr6rapXWHHpaSElsFEz4UCINtQ7gzK0NF/UC3zpntaVaBEeqriWjl7STB56xFLBToqKlc2hzkhRbuk2Olj2xWS6gS6Dc72pZI6FIxGeoDUJbPVWhZodi3khVEDorJjf6LYoxEX1cLsgjhfOFDiMVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Fc4HClGuvBvHZBqr9iXzuPs8SLdHBDBTi+dHyVBt+o=;
 b=dsV8vprgp6pKCnB7YbUwudohJvR0ieoL9v3v6DWaVfthbWi9OvobzRDDtPGyaHT9UrA9lPnPEuqO2YgtsN4fADKtw/LhlOwXvlZ6WqN3XeLweFvmi7ze0HWXE3eT53DiEp/cxYqXLkXLhGBUTC80/29n3x0/F78W5RN97VZfEL8=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SJ5PPFD020A49E6.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7d0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Wed, 17 Sep
 2025 15:24:29 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9115.020; Wed, 17 Sep 2025
 15:24:28 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v7 05/16] perf bench mem: Switch from zalloc() to mmap()
Date: Wed, 17 Sep 2025 08:24:07 -0700
Message-Id: <20250917152418.4077386-6-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0212.namprd04.prod.outlook.com
 (2603:10b6:303:87::7) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SJ5PPFD020A49E6:EE_
X-MS-Office365-Filtering-Correlation-Id: a9a620c3-0eb9-4d77-46d3-08ddf5fe4ab6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mmIuJiRtj49rgJ9xSYZRlstaJG5R6Y4UpMW1SsIa4+YLpAaWVOIb7ceGwfeP?=
 =?us-ascii?Q?zZEO4wxlulLYZi18yuoClX1nmNChmnpVjUa7DOfYyarr3EmheGhvnE6/gSzA?=
 =?us-ascii?Q?vrZ0Hy0v6unsFrkX18CCNrZ/rINsv1ZyHPoz2h43I1RvwMI/ziKcvgHUiN4U?=
 =?us-ascii?Q?Z2q/Q+qUcIGmcDfCI+WJmKgKtN4gzgJR0GFJ1p/qhtjvO6SWmQh0Q3lnSDnr?=
 =?us-ascii?Q?jVwjLhr8yBWVZhUGpySAOZMnpS9hwghY+o91/A+fa9UZ9CNi3qv1xYi5+jcI?=
 =?us-ascii?Q?Bwbfe37/T91Q9PzEcVDmmoyQqXrWe3Mav4eR0lk9ZBlPuw0YP+mkQFCYELEs?=
 =?us-ascii?Q?aruYT3TJ5uVpLhLT8Lo2STmCvHYPUSgJEH4wDADrLnSLT9K2AAkyu8NSd3JV?=
 =?us-ascii?Q?QjPwYDM1OccuGEjlaKPrv6tOkiqirrk0POqeiIsXs7ZV04zSd6KijAemZWS/?=
 =?us-ascii?Q?4nTxwfLiGKYdnEJwqqu8sFqYqnsQBNFCF0duqukvZWTY4E8+kbFxR1URmxvh?=
 =?us-ascii?Q?g9abrJRu26JLHUETcAg4aDzksUYikIAGn4kVf1b3rVVeJArb1aUU+Se510Az?=
 =?us-ascii?Q?XFzxpzTuI6w78/u5y3BFmJ5GHDcG3zLP9oQhoHl6hsZvLGd5RXJsu7Bm2SOO?=
 =?us-ascii?Q?0CDQJ3i3/pr87CL7uVkkJ/DzCQEAArn7kh2zkTmWk06/mPv6dqsuhZ5l9Sn5?=
 =?us-ascii?Q?ohoL1CC1rB5iVeqOCdqQCfN5Hxjwi05RQnyHrOX55GrDvlVXpBLLZH7kr9U7?=
 =?us-ascii?Q?YkyQHkErR8+iNSoI5cVmD0cotqaamc69NsBp29CoZcqGaVupVW2RqWUYUSC3?=
 =?us-ascii?Q?GkHoXT2ssS/UuMvRAjpSaq+Kn3kp3QvSllWdNUkjOQU+kx1g37k4lzArqfQJ?=
 =?us-ascii?Q?TH7O2WFxGnql7bBX9ItqKfHWtyyHzft2Lytj6k0TNRHGBL8N9vXCROtXZjuD?=
 =?us-ascii?Q?ZCEu03xpmI71VPALWlRht0wvgTMgHhRTGkFVuONxrm2Bkvx6xfkiZH7JHsi2?=
 =?us-ascii?Q?adxt3+uORG9xe1Tosl1QDNDOXtPp3lTVhUOOnHieCJQrDISzqeyjPXXaT+5K?=
 =?us-ascii?Q?aRMBg1Fg7BVJWBMLWFRTdxmvkyWOhqnEQWiNa3V1FpB2jSgQTiHPB/xwlE8I?=
 =?us-ascii?Q?WTgU7t0qgNpzEZ+0l0mKrb31bzztuIky+V5nyTrriktAfAHJlCUIGoAxyb+3?=
 =?us-ascii?Q?bW5uZ6z9/FzB6Jcr3B6TLQigfhHhtBUDKW07F4j/pDCOWBNLv6HmSjXX2m+q?=
 =?us-ascii?Q?l9tdH35vQl/N3fh/zjDAoPXIlYPTWW3k2/JJKUCzzGaGMX9ig4duVv2mmjl+?=
 =?us-ascii?Q?QPplSuO0JdF5IxTsYVzgd/YYGKG0FwpqZMP4sXwOKHuD3zy65wR8WMGkUn5P?=
 =?us-ascii?Q?XGiSF72lyqK7bwW8sue+n6eJnOYiLKqlYATvQ/wtPMi3StKO2a1ZniGUUqAY?=
 =?us-ascii?Q?98VL/871r6w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fTwdeNptl30HuarDBAUZ0ZunoxJ4ykb8E6sE+/vMD1H0iaN90SiromEp+2yr?=
 =?us-ascii?Q?7T77WW50ePq+KnzZgbBFYUq+j5+6KHKGMm40EN219oXNH64rTEYh2V/zFiAz?=
 =?us-ascii?Q?/7U0IbWbfMgfPhyyfud+Tpov3NZI9LD3B35A1QOjaRuM/sui4UzRqp+oqB4H?=
 =?us-ascii?Q?J5Kfyz3AIR3GfK6BpwCgDkpsWtJ6rZsgvo6jzHU20mJLMR0WTZZLRizupFTC?=
 =?us-ascii?Q?fvzJI3HpvCUeV1D5JrPCRk3qnniCpRje6HMz8z4+WXnUTRqtMOzf/KjBnQt1?=
 =?us-ascii?Q?hvf5A9nDcTCQP2PWP+rYhsEki+ZjtsE4GrvOjIcquAikIlLVNJExlE86bXSX?=
 =?us-ascii?Q?iG0SlIg0JN4n5eXt9a5zIVL3oQ2oaJsSKwtntmF5eE+Y+mpWrtm7WCvfufBH?=
 =?us-ascii?Q?0/dneewH3OsAifGDeZCg03GaP/ufOwX/wbmZpNd/KGLtbDUXYbqwaSSyI37U?=
 =?us-ascii?Q?DQOJ+jIPwm/dpNOsSzTmP5YI5OwHcpYBirnQ9BvNop8C6ngxYwHV1c2DaW1P?=
 =?us-ascii?Q?zSSRMsw+BNjFgJPsICH1T5vhfRMWuTHVTnvWykM1W5Fz4fx6+uRxG4X0ZDu3?=
 =?us-ascii?Q?KxJQTz/g2Lgfh+lhz2ljd1o1xD2o5/Hd9s5V4qiI3+7tEG4CvvspCzg3ri19?=
 =?us-ascii?Q?78dbTYtmYqiId9juimqDGoMo4++0QdF2Y3HND7ssoJxiWKAPvJmLOxx9ETpm?=
 =?us-ascii?Q?QlbmVEl0D5nwqCG0pGupxlVpZUl0rwXOVefxXkQaw3cXL5kWrZzhqYYFGYLd?=
 =?us-ascii?Q?T0Mc1RBrSU8BG8d2Ed7gLA++t79V1q6guUTxQr6tMwHln8UmmLzsNX65ef/T?=
 =?us-ascii?Q?QlF9yiNFfTstdEtx0J/cOieeh1Pw6axjsalaTxYr8BZVYuFyPCp5PJ2VFqpB?=
 =?us-ascii?Q?Tzla0uCqPsJq/Zj7U50x/foBLsbpC8Jl6/x19xRCMeTiI0iOmwcPOh1P0kD1?=
 =?us-ascii?Q?cpxwQeF60T1uVj0aAEzL304/bualzhzflOwi5X1Dh8kIazDmeVzhQRkeNbIJ?=
 =?us-ascii?Q?HxBFXNsa7eF+p27C4AbGS9E+5HkuY7/2a76qKROB8o5RRIMZ2dux8UrYcN5J?=
 =?us-ascii?Q?JUON/RFzUgbpXmtxyKKjVslTEAPynxyT4o7QKBKNX6ZCwFR20X6i50gpdkZa?=
 =?us-ascii?Q?9lxlie9W2QpNPA7CiUjQpLYN19ST4QJKNT3AyeH3kSe9QHr4qul3E0CC87N3?=
 =?us-ascii?Q?preXkSSXynL8nl6KVavcxE2evBWNeykP8hLVrIHxy7qUaFTPcvo4m/QqJIv8?=
 =?us-ascii?Q?LeYSigwdTiMEzcO1xLoTxX6aRE3R6w9BqVC8BUN1N7AyHzoDE2wzZmkoi8/3?=
 =?us-ascii?Q?usNUw9LphK15/RbTHiRtq9qCSIlvEeqcnThBZtZPh50bUUt48L6QcRssP8Yq?=
 =?us-ascii?Q?1xLbL+ofiPiR5wsUJCmOFh3KznqxZgijXknTP7Bt8ObLn7NZfNWZKduBHTJN?=
 =?us-ascii?Q?Pi3upyHa7YI5zC/VCebiACP77i17TbaeUQiNsMUsVpsHw3fQkYGLwxbQkmVG?=
 =?us-ascii?Q?nD+37fAFw7Kfqv+WsGq1HSqfSuyT/ZpMCdf66SlC05E2BgszTW+H547bQ3ZS?=
 =?us-ascii?Q?4Flffa4JW/teBkeReMKN1Jj4MGVl2/9B8vnGEMiaTVkEhcpoxMWqtWyDYMri?=
 =?us-ascii?Q?cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gFTXLo510j32RU01Wpb+DSXUltO55kz92Uo1v9YjIiPsmM0IQouIII/9xc2vrcPCLdqE9DcyvLzhVxatYnimX/Urmp8e26B1voiyzGxLOel6nWvjGAiYyHSxy3yzjRSvAZh+pcIth/NYfI6j9b5ABlLO7XL4v3Z/X7M3Nc3yqqurQ0hIYyEhu9j+A6WMnGKFE/zxBXuFtN3SxKHy+5CLCu+aSPyTHS+4m1e83ekzlq393qDRHlZV2HBCPD+i/0Upy6GTCSKLGAlKwCQOZCVcsKmFpQDg8pMFT3XVwn+xd/7H+Xv75dHrp9y+vozzcRmj5b+S38MUxvtEOiBoK5vD4iu91vde8w/JiZijKM7o2no7Yy1tsnEfHEdXf5L+yV6icewuwcOfaVPVY0hsOHcdsSTPYCssLPuajGQtYcZuxsYF7soXjCp2a56P7LncduT7RZ+WoKAvUJLZYQZg7mMR8428Zpfyh8hhwSsaHgbxPeCg+FGr1Qs+jSJtq1t0xQjAZeMjYIn00wecie4CAyCcccqABZjkIlLz6B32cTBP6pDiZKYZw113dG5y+oS3uaD24TC4wbT6h1rVp+ooOUi+ixpo7ayxs9vCtrtagrtnTBQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9a620c3-0eb9-4d77-46d3-08ddf5fe4ab6
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 15:24:28.2049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WvuvidYk0BRPZM0ctpU4/9eZOA/naBz6TUecpeP5olu/flLqAm268edXFNWzMiEiSD6UDG9ikzf9KzoiJNrL3C0bfQrz3nFIh2M9zVUaSLE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFD020A49E6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170150
X-Authority-Analysis: v=2.4 cv=TqbmhCXh c=1 sm=1 tr=0 ts=68cad2b1 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=X8XlAeXZIpgir3S8H8YA:9
X-Proofpoint-GUID: VWyjM9dGAmQutzAk4IBHpBwNH3aMVu6N
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX2Cqx7uRmwukb
 hpQ6XTho0GQpaAwMVJyPXZPK9WjtdYgRG0twh3VQWjy9LkTyekQ7r9pxj4kV71qWiCHe2v3bWoK
 tRPk14LVV714aNiRghPQQ2564Bc1ACTzDoAwKR6iN7Dg9VAB8P5yjIsgPsxzjSncRjE1QknA49j
 5vFi31Vt1TdGjeZyOzveSA98DMlNIjMfCwpLTroHu6N19q7Ec1M1VFfTnn0PNvfOaNT/F6Tv42B
 qt/9Kx1x56/xn14mPjiuD6oX5BJfH5FLCfs5s+Cx0Ft56bdjoF/qV1rEArE6Pj7YISCoLfG3vwv
 Era42bL/C39NvccBf7ZyJoea5NZldZkogWmebhUdukF73DZmyMV8lYsGYTR+rSlfcxkoie0EudY
 /nEqK49n
X-Proofpoint-ORIG-GUID: VWyjM9dGAmQutzAk4IBHpBwNH3aMVu6N
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4E16840008
X-Stat-Signature: q943kzgnxhzf6watjrtjkja9dhf8qoqr
X-HE-Tag: 1758122695-455232
X-HE-Meta: U2FsdGVkX1/bJYjw2aZU///a1DPG98QuJfY24vCfTLo6ydnO7T8YZiA7kJhM3O1i0sSuihIkBxTAzsEE66OINVsRbwfLF4YmCEcCkJB+B9sFHBq1saGuXjDFeEnJMPKNrVMqF8wHGZ3aVs8uX0lpYavwy1NhRAe6fM5uyo7GSuD2/AR7ZYOGlR6ubfYFtEFAbxELM+5qiEmWcmpRULNpucRS2ZiSv1Ur49AtKp1o97j4uBRoVj2FLVncm4nJwtzYlzeaEqFz4qEu5yFQH4ij47X8CYKBpu2bzvxozvWF3yIOw8g1qIGOjMuQRWELbdh64aFImmCQjx6Lorox+f9Hk7toQHIl5Z7teVCu6z4P82hAn9Gi5mmP3DWmLv+zHms2qKFMTrheij+Du8a3xNWsgfQQZrOhZbPnbMDlrzJzWQhqiDqEznz9D/vFXYNJrccvhjxY+XxTGubc0kUeeBwax96rRthy0xR8PaYZgmoumzm0giubWAO6Hy/qmW4E8RU7wffy2rIRoYEJcm15T1wPAxJpB5qVdBEzGRadpffNdWoO640MQ/HBTOJ6rmpf3rO5t3Kx5n7BLgfDw1OLOrG81liatyHWGoZYBioj7zkcSEh8uJpY3vGvdYj2OlndUVSUGcjjIYr5l6ZBCcZVYEvl647GAM8skA7IdtlqJonZYFfG8Ry0R9kbE55zWodNmZt/XQDiD1myIr5VWpSQRRnGtu4l9tW02qtxoHR01E3VWFGJtDxE59wq5sZWt+P/PKDTSAWy3t/qF8nyfronUzROgUxr23MayIWj1HmapcoYDDoPXa6yrA0jUSs5FvzhMpkM3BJhMudrJZ2rgkinRUEhxcCk+EpP6+Nq9NnHL6PcjK5ZqVNC1KO3cbluQCeBmBq748wu3RuQU5IJHFotpB9dp1Md7uzTYkERoBx9NkMIIX7ZqEPAfQGSkUKTcxjsvTNebpwdIFf5WPDwH0gY4M+
 lTBIurrX
 5OcVNckz02jPjbD2/yRdbtwmWogtC6fBHUkqVXj2FJZbWfbHojqJ3VENecKiy9bUNz1FhmyQ4gXmWTeEEUkji4cp983d89u+HDgDnJfFKjMXMsFCjDytEOt7swwYkPSGKvPMJe4eDJDtLIY5hSZo61WSn4zYem17MRnx7/z7dygyUhKxNeTMJ5sp+lh4abfdaP87gVzntTOEP/I5SX5r7jS4y9UvsXejg36ew3UvskFPOq6QAMvo29BfFS5AXFHgVB/nzNVSWxRuesBnwnWd7LXgKXaVGBSmHgnJ34HyGKFhNCpk/x3Kd9btvetyK6QJkIjUj77JQ3+wf35ZIXUXUE8wPqMznm9lVBrN2POIVL8HRhmQLnG68UIZwEyvJK6Yh3Yedp3nr9bUbqumbkMaDSp3RAdAQh4hCYni3av7j7ob/+AiLKKuvklT/qqC2v2dcdS4NuKjWq4qQDfwrH54WjWWAew1+Evg2joxM9WhJUz5bp9kuTPBjIZBhNnJxnBgXJQbR8FYkuw0JqVb5/tW3pOgJT4Xd7u6QWEgSIdwp+Kr/xZ41s43lFpaENMzBm73KolUCY1P6fjVxLL4mr9cepN99Rmcq1wMeZ0yJjI/7MCTsgsrLe+3DlDb2AyEVw5VbXPtM3TegAuUpo9Gkjl2e4N5RQHATyItJx0eEatjrsBIICEqte/4+6dpLy6YngRC42S3kbWiTftwx5vBUNLdL9+LCJZqSrTxIu49zOfgvFaTCSnY/m1BPNN877w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Using mmap() ensures that the buffer is always aligned at a fixed
boundary. Switch to that to remove one source of variability.

Since we always want to read/write from the allocated buffers map
with pagetables pre-populated.

Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 tools/perf/bench/mem-functions.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/tools/perf/bench/mem-functions.c b/tools/perf/bench/mem-functions.c
index 60ea20277507..e97962dd8f81 100644
--- a/tools/perf/bench/mem-functions.c
+++ b/tools/perf/bench/mem-functions.c
@@ -22,9 +22,9 @@
 #include <string.h>
 #include <unistd.h>
 #include <sys/time.h>
+#include <sys/mman.h>
 #include <errno.h>
 #include <linux/time64.h>
-#include <linux/zalloc.h>
 
 #define K 1024
 
@@ -286,16 +286,33 @@ static int do_memcpy(const struct function *r, struct bench_params *p,
 	return 0;
 }
 
+static void *bench_mmap(size_t size, bool populate)
+{
+	void *p;
+	int extra = populate ? MAP_POPULATE : 0;
+
+	p = mmap(NULL, size, PROT_READ|PROT_WRITE,
+		 extra | MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
+
+	return p == MAP_FAILED ? NULL : p;
+}
+
+static void bench_munmap(void *p, size_t size)
+{
+	if (p)
+		munmap(p, size);
+}
+
 static bool mem_alloc(struct bench_mem_info *info, struct bench_params *p,
 		      void **src, void **dst)
 {
 	bool failed;
 
-	*dst = zalloc(p->size);
+	*dst = bench_mmap(p->size, true);
 	failed = *dst == NULL;
 
 	if (info->alloc_src) {
-		*src = zalloc(p->size);
+		*src = bench_mmap(p->size, true);
 		failed = failed || *src == NULL;
 	}
 
@@ -306,8 +323,8 @@ static void mem_free(struct bench_mem_info *info __maybe_unused,
 		     struct bench_params *p __maybe_unused,
 		     void **src, void **dst)
 {
-	free(*dst);
-	free(*src);
+	bench_munmap(*dst, p->size);
+	bench_munmap(*src, p->size);
 
 	*dst = *src = NULL;
 }
-- 
2.43.5


