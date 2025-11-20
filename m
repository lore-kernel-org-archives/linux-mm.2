Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DC01CF64AB
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:43:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED9786B0031; Thu, 20 Nov 2025 04:43:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A216B00A3; Thu, 20 Nov 2025 04:43:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2AB56B00BE; Thu, 20 Nov 2025 04:43:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB9606B0031
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:43:04 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 849E312FF66
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:43:04 +0000 (UTC)
X-FDA: 84130496688.12.8770835
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2F0FD1C0007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:43:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WLjisFa+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RUMb4F5B;
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763631781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2aW7YHoAm8J6aIawKP8JhLWo0wXqXGp7XHeLnpwQicc=;
	b=w++tEcH/HDfD1Cw31PXqtPAzV+7dyvHBxlevvdLVl/DvLcwWiV0t7MXO1HPosutnv4JS3r
	1P5x5BjTG+c4WYZeKLyPmQ8xD21NM1uuOkaP8UDVQGKDYdU82p5cDxvCjJ5iaCoSPeB0Pe
	HCdzCBoaZsJmPkKMT3i3N4d1Qx0+Rhk=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WLjisFa+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RUMb4F5B;
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763631781; a=rsa-sha256;
	cv=pass;
	b=6kSHneZGru66lHH9patIESjFKQDBIGH2ve9p6W/gX0w4T/kKV+cd4/EEDqdLSvyQLiho53
	6zz2wki9HzL6qvzoevAE8tEIYouG5kc8+VCfS88beu1kXsw4P/SFcfU2sL3MAEH3Dju1K0
	wKbCOELcrnmjzTL2Hgw3cycr8XHsqi8=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK7nkfQ014322;
	Thu, 20 Nov 2025 09:42:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2aW7YHoAm8J6aIawKP
	8JhLWo0wXqXGp7XHeLnpwQicc=; b=WLjisFa+T+e+Il0L7ZYZrofPB6n05A6ZNh
	hWS37V7mSSvn5Ocou5/MPPMDKIsn6O+vWeaPMajYFWxBFCik614eo4QGwBtUSbkH
	xDSPhEMI81zmO2vD8TGunKCYOBs7c5T3katH+RjUkF/a/sYAdgRlQylbRXQ3fhsB
	wc8/PuUSXmWwVxjpgLQVROqr9SApmhdVitRw0TIJjBs8Ybaee4xKMhoirohy1lyv
	qOq6jVUyGzlUMDl/At/Wete1lN3ZFu7B6aw3kXTkAVV3uNQ1o6cDri4faWByI1zk
	Bjc5DK9JO+WpBadornVprxXyJJUqtwowLzn7OaDQecY1Nak12qqA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbbgxmv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 09:42:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK7gWt0035979;
	Thu, 20 Nov 2025 09:42:44 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011070.outbound.protection.outlook.com [52.101.62.70])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyp3ekc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 09:42:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QyP6zBRkZUpFpV0uccuobEZU3wqWu0SP9o8he+qoBcAHOiVk1FPwakQl3ZUCOQJGwMPg8H/mXaZnk25NGXsr0aFpc+LM097az54iNkM9DR39gtv0BKn+zLrOgee6hTHx3BoP3DJTYFF0qWB/OSIqNcJHjGdJWkdpe7yNhp/x9OU2SXMSA0Ijq8mnFq+dVeVRZBg6rAVYvqlbt9rdZe0Ey/pRnBUQULjg2Owxa3k2ECF3udb06fE1qDK5qiAs+YfKMYZ7hKZ+lCvXEYhveCpQ7jFkj0kkIWefGSZCpqRaCQx8tI9mq2L1tXbaoGzGiCaf/ugSVU014KgrjGi+1D8HKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2aW7YHoAm8J6aIawKP8JhLWo0wXqXGp7XHeLnpwQicc=;
 b=Ec7syfSD3JSx3xc51AfREbKZhTU9DCk4mS+chyNqIyJiSFC4bkiE4h/1gakO8ECbr5rzVZNnG+FOmGj5BBUvpgAYbV4RKMKpvaN3DOakmAndIInNyjUNVZB3kgBupiY1336Wl8vkNf4q75aRkYUTk0xmrlXg/u6NFrn2//FN21BWp65sAHygPHDuoDUUEVGDEDiQTuqxUqap3Nv0JUM2uT+W9HI90rmazgY8z0feCu1uZA26BPPyvcj+vZLgBjVPQ5QJLdnRrZ6IJXFaD6wdJpc6wdu5veDEkGJc8daewoicx9yqO3JMwfljwA2yGnTimAPdey/gfBJI4nN0PV39Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2aW7YHoAm8J6aIawKP8JhLWo0wXqXGp7XHeLnpwQicc=;
 b=RUMb4F5Bp1691ROlL3PV1Y1LdhuChXcpqXHF1O/53eK+l40GqUUQcit6wqtw+CMCdLOvwXodPN0Mn1gaL1ma6N+LtEk7ATj2FBKREF6PfWRIZROJ4+Ir/iw3AL8FrukQX4YYrShSqQYvHlOah5ghJAOZu2khkHOXGxKLxNhwbY8=
Received: from DS0PR10MB7341.namprd10.prod.outlook.com (2603:10b6:8:f8::22) by
 SA1PR10MB5685.namprd10.prod.outlook.com (2603:10b6:806:23d::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.10; Thu, 20 Nov 2025 09:42:41 +0000
Received: from DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::3d6b:a1ef:44c3:a935]) by DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::3d6b:a1ef:44c3:a935%5]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 09:42:39 +0000
Date: Thu, 20 Nov 2025 18:42:23 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
        roman.gushchin@linux.dev, shakeel.butt@linux.dev,
        muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
        ziy@nvidia.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
        axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>, Nhat Pham <nphamcs@gmail.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v1 18/26] mm: zswap: prevent lruvec release in
 zswap_folio_swapin()
Message-ID: <aR7ifyNg5qG38BLp@hyeyoo>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <c85c86746a3103bac3657934a2655c1eb81ff290.1761658311.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c85c86746a3103bac3657934a2655c1eb81ff290.1761658311.git.zhengqi.arch@bytedance.com>
X-ClientProxiedBy: SE2P216CA0056.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:115::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7341:EE_|SA1PR10MB5685:EE_
X-MS-Office365-Filtering-Correlation-Id: c94065f4-e07a-4af2-b5d8-08de281920d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IDvNlYxKci8hmG3X2Y6zv6b9/rxmPTa1fFfhtslelwJ6G8f9bXO4WpD1rChU?=
 =?us-ascii?Q?zyAG/1rmaCxiQtm95Esa9o6H4QxknTeaFK1HmXeuMsGJeFuEhadVHEr/Mcz0?=
 =?us-ascii?Q?eUjGB9i2wIDO8XEMi6Wi38kqBdvKVHKSk6n20u2YwGHhOlG394FiOFiZJRhE?=
 =?us-ascii?Q?nRFsDJd8fmITnHoB7EM+O3924j2/ueCMNVeQXtL6HKcoVDGTB8JicSBaE3O0?=
 =?us-ascii?Q?skEbaNvRYfiRRfOMd53FiMQM17ytCCTvXHKWooE10qcnu6frOS92pL81Ogcx?=
 =?us-ascii?Q?K/76a/nTw50zlr05icvH5iYZoQY/KWFT/65YYnZf1JiQrRMZMDEmPTl319g/?=
 =?us-ascii?Q?HYESMcC9Q1iPCitOUty57Is5RAFL0gsY50Ox0X87WPts0vkKmGweP+hJRJoJ?=
 =?us-ascii?Q?jhC6MISFYAiOKGQ1W7cpxL08Oi4ioiV/dFyBzPOZ8Qay1anTsV8wpJvjceOj?=
 =?us-ascii?Q?w5pvqQrEzDk4oBB/DJ8pkJl8xH2etVWq+hWPZ2+oU3Gq1uH78WT93+zM/sgn?=
 =?us-ascii?Q?5QMJ3D0XELircHa0ktdhf6FOAPkzxdf3mPsLIorTXnH54CWeLzFsNzqfOA39?=
 =?us-ascii?Q?FfeuFBqLPi9/v97eOwvs21EGBhq8XLiSH2WurkFowa2rlFYRvM/brM5rmgnV?=
 =?us-ascii?Q?4lIAGR/JBNc7pQrfCQ6w41lS8AdmjojbdUvztOAxyn5qndv2KBMOqdlzwi4W?=
 =?us-ascii?Q?K8yH6fjO3PDusuoiCie0W8msl+SeQg0nvdAs+NIhkdZ6NM5ZZ+vPAnUhU4+F?=
 =?us-ascii?Q?jyUcQqEuASTq2DsEKSR4Yg4ymYbNh3zM/2s/jlEZvwbcgSzFamQrJ8VlDL+K?=
 =?us-ascii?Q?pADHvueZ2S7+uHha52jX1xKiMEOzvFG1uMKsMrP6VUQX6T42Bry49+iMSp6T?=
 =?us-ascii?Q?W9sL0gw/gGigQ3hUybcoaVQj4kiqClMyUYtbnBd0g1p7zx71/blT9AwIBEcU?=
 =?us-ascii?Q?okBIV33jTnwKCDQOQjL6vTF1WAnxuoBoimfIHlEY9uclRWUThcYbL3bpLiJG?=
 =?us-ascii?Q?o2TeUNRHcjWIROufOhLgo086E9TQJF5uFdcU1h//LoB4/dJikbbnSXCvayn2?=
 =?us-ascii?Q?pCZLVzV4379T8WoUrTb8G2+ZaEWpdfQv9FFhEVkVcp4RK77C5rv3qSPGFOmL?=
 =?us-ascii?Q?v34aO6C/7i6MdUk1t0aAn8Ps09EVS3DoVz6BzIGRsc9z3vGLQwP0htkD//RH?=
 =?us-ascii?Q?iLODnh8WCJZ7MX/y26MBuz5X3RCpRwJQB3gfdrBTGzOsYF0HVXqvaMiXyooK?=
 =?us-ascii?Q?N47M0VIORZwVQoP8UvCYVnl5WKSHLZfgmEnMwc8n80uMErsM9ZxBGRtDDBe5?=
 =?us-ascii?Q?451+Ugks3PtwOIuHHj2DjgYukIPhS/fmyZOh3+L4g4OjK6APoFVHHgYlGE8J?=
 =?us-ascii?Q?7OUKy9ytBlY6pTc/4yVph9Dvko5sXw3IK8eN7SxKazRbu4pTYrModbrUl65u?=
 =?us-ascii?Q?AEJqUUxtK6p4rQKOCUY0SaOKa7MV5tiI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7341.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t9EgMsAdO5Y9wyA/idrLo0F+aJPAmzGYa6tIVqS64wXQL2ylwgsaQ9kP2vkh?=
 =?us-ascii?Q?oF9URMRkmgkovUYDBA9LDjcBt1Zo+KH3IigtReInf0g9YfDqfj1Wf/ENU8bl?=
 =?us-ascii?Q?aWJ5QkbIk65RGkIVQfZOHz985jRQxgWA1tXm10jYcs6IpgKLgZOr+vt4Ys3a?=
 =?us-ascii?Q?x+ll/F2n1p7MSBNiCYk4c8PPGXjk2Eh9DUfnvw7WLMq0b/Cjfxt2DbmmNhYg?=
 =?us-ascii?Q?5JUQQadUdPvG0o0it0Xhn2HQZo048jG45No9pkc2lxkx1ByEbZI1BRRiMPwG?=
 =?us-ascii?Q?0KosxZg67iwPecjW7YXeLVkpM1J0BeMS8B0MHs9b7cWIsz17laz8L8nmxMuW?=
 =?us-ascii?Q?bmNDSy9FzREUncllgkhk4K+OMmm9H7koFBPFNPpU6nFHVx2zgQeZTJ24Gj6Q?=
 =?us-ascii?Q?p5YzCvb8rRUjYJAA9Dfd8nuHYJrPPXXlGPApQs5iKh8CQH8nMh74sLD3G63f?=
 =?us-ascii?Q?fcmLBLqLzVRQ6UHcnws+lyG8b3RNWiZfAHhR/YdSvF1CVouBdMkoFC4ECXPj?=
 =?us-ascii?Q?JGnXkMvBMA5JFCMsIwstYzJAICRBW/GurAqS0SZGO/ICI7a4jx/34PKI2KGc?=
 =?us-ascii?Q?CIuIX2I6EpwLMdn8OmA7xvlK4/kK/g8UHtQdRmm9GT0k195M8lgMIAGLZpAb?=
 =?us-ascii?Q?0OIf0K7WKy0dKVMJ5pgjab+ndFdFNOGS/EtnqKroPaRdTvCEykc9yXOAX3ji?=
 =?us-ascii?Q?r9wAufZ9cvJbL0gq55D8U3nSIT6NuBUjOvvy0h711xW7PqGu538m1KOItu43?=
 =?us-ascii?Q?BzqwUkBJVJlWNhun/k+jdlKX/LKrN6ZpmKuyNvVOOZpW0TiBaZUfw8kwrFma?=
 =?us-ascii?Q?bSUuGIhmdqgKjRXOx79zMPKm2GA7B7Vy6TkdERP7AYjf6ko2xsqc7nKl9CLn?=
 =?us-ascii?Q?l8j3WcOdnzyZtuh/O2RzZaqwFvDkGtoOYY21URv3tRxak/EJo4KPgQNHUSwY?=
 =?us-ascii?Q?wA7ztmz1MzQhj0sZlbanEi1WluR/Ce2okhizaL2J89OwQm/37+S6nflf3zvF?=
 =?us-ascii?Q?xfuO1bXyZK0xpAMS/dpe9zVCZcPjAJaW3SSnj+4TUEtSDCcbOKhUapnoGoxP?=
 =?us-ascii?Q?s1RXCux9+W4p8t26bW1aandeuR7JuvKKkkwLhvrCQZ03ANutPjjmG3+LhYBM?=
 =?us-ascii?Q?2NPAO71kkkYbEwH2gnJis1g5YTn6ExgIacwmZhcvKzIGqwQE2v+87UoOl/sY?=
 =?us-ascii?Q?AO1V0NyBj3a2a0OQIclUovE76M2nl61yr/xnfPTIoW2tA/UPwrw363jAK3kn?=
 =?us-ascii?Q?gbrrn9ACRR/ODzWdzDwYGqG6UCDh1/6BtioC0wmxKA5u1BqngaqpB4LOT04u?=
 =?us-ascii?Q?5MnCLw1zKUWnUEY2655Kyisc+EvdyGkv59R+e9xNccQ6FRtZVzqdBVJ8L6bB?=
 =?us-ascii?Q?4wscxp7b941+dKW/9/lNH+ag0RGCgmzC6DF0Q0nu8bHz/6bdYGJhMun0Kz7S?=
 =?us-ascii?Q?lL599qm3KuflRQiBcMBeXXI/zPSossmzgXimFh75wIur/RRwXpq+lA6tNIul?=
 =?us-ascii?Q?lK/lN1rguTlRO5TfV4dmysb2xyjpD69sY876laoc2as2UjjfPaJ3SiOIdtmq?=
 =?us-ascii?Q?2AqBDeec3zwKZFjvEP2/nV7YA5B3Mfa7i2k1QWin?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mGJx+cGtFUFOyLtjl6JSuMGtZonsTDnUfiV1x6yN4fPMi4A+tzVDnwA6OsKNOxW2TTgqGOPadan0Vx0UGCXhWj8UQxsbNF+Ek+Hs22sRzNGLwnzGJBI9SS59lvwhy/mUfiMMowE+vyHHmn0R8bC2iPFPbiiNfu4eyM5hS/G8z/R8wZKXJXABDKWX/3reuocp3cNlH/qitokokdCeCRzvIPPnLJ7QPTFrBaNbydFJG6W8aVfMPq8DlLn8mZgy8acDXa16BOiIBY/2n+e8FhH6lCp2GqxKIJSYYkq0bM5gFNzVRKT0IR4pxVaiMSkD+gGEoOO/HEST0eB3HXFVV2HZw/q5i+Kx/z2E4IHJ2ns7My77Y20OO6nB/3HrCYBMOBFVBK7aYaInc9Zw5dDfGyRdSeGmaieYgE2g70S0nE+GelTc5UfNEHuu6TXUiNI50PqK7zZucUVOyRZngGs3krrijHqPqHfpRdmU7tsciIDxVvd7li+QmKo9fLfwP6sAGnbW51EBpkmphMivJGZ0R/y8h9H7lXFCeeNMSs786qpCko8trafM3WRhCNu5DgivVIiU7GF9laUAn24TSbEEIlqn1LvFC8ruy179UbidVv9J4x0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c94065f4-e07a-4af2-b5d8-08de281920d8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 09:42:39.7915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6BrnBnuKD4elynPecZWV7WdmzfigVZ+Cwdm0BpxeTqbVIiP6pmNTrlFDkPFQURa4tsHEUIfL0n7rtzvHbu7z1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5685
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_03,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200058
X-Authority-Analysis: v=2.4 cv=BoqQAIX5 c=1 sm=1 tr=0 ts=691ee295 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=968KyxNXAAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=W9BqLgzXg1EqYeH4nf4A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12098
X-Proofpoint-ORIG-GUID: FJSfOJP0M2aCzhSNGMQAuDn0h_JmBwqh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX37RFKbe9lcwF
 8RpAscF8SF3jgTtWae9GYajQudGQS3CXYUdKa+ikurRpu4afyXoHc25qEF8NKzqFewwbdvLJpFz
 mnB48phcvFMP1K3HDgreyk3bZhMKYkiU/lrrlpXnf6S+sW8vRLp7u1TYLAB4bbfgi94aDcyFTpm
 6jigM041wV0CkbWCR4iL3rgxAO2PNZgdVGL+4xg4nx2YARj8MZo40RPtSQExcSDi8uzm+RD/+zb
 7mCrkvLTYtsFJCXO+BkrbKFB8k6iPiSxusOcOaGslmplV3nxAIRgU7l2h9SRpwbogoVCp1FnW0H
 fns7ETqC04e34gquuns+wL/UvypA9XSPcDu1moeBpcVXG4vYfy3erNgWG/rNoIaWxg3li7PHDXI
 TJmfbgmSExIOcPH0Spp1DRdzPDZuX21c0p8G7w4ikDm1BMR1my8=
X-Proofpoint-GUID: FJSfOJP0M2aCzhSNGMQAuDn0h_JmBwqh
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2F0FD1C0007
X-Stat-Signature: jbrpx447w3jsss3kbe5fxojixj89spiu
X-Rspam-User: 
X-HE-Tag: 1763631781-140751
X-HE-Meta: U2FsdGVkX1/nntDXI110SRXWHwAdKkPcWCPS6lx4nmYCnb7W/HPj0TRtyCsSQ9mGtCWf6fYiT91uZuM7HZw6WA0tMvcOr8cOueAiGMCk9ma99M1MusNhsr1JA8y6JuGFeIu+XX8qcdoLpaEyUlbUv2pegnOVKeDNAQPBDz9rzifQT66EiFoQG8epb5OKUjbabhEeULE4KNWaQdb2CWX63Mn5OM6YYhRQ68/M1YtoduJBC7L0LSFLgeso08MoPAswYhJIiV7+HHVYQlVZwUb61s8g7geeHqJx2eSohfD6If2MZBh3m2y9i7+H8bWPpnR01RiArKtxQ3mx/uXH4CwF+eoVzZurS/8ke62du2B7ZZ4bcLJ5A7Nbwb/3Own6BKIJiPu28ythqMa6DdyU5IdT9Y/3zZzeBbHsuVMzozguqCPau+g9G9bTxfZ5bGKUksM6WbLOt8xU5/UIvDwsG9PxAR2vpfMlW2uEUnvEyPCz0+STtyN45T7GdTNX+TRSqOsOVJjOiWfZsjtPSe1zG2PO3izi6nPYi31YvqTU61BvSjIjf6QbGtDPafTfjN1B3f/35TGTQx0rhOxOGXJ7FSoGnt5MtOdzNn1a3RJIVCeOvqVKQJg4efrKY8LvJfTSxxa7Y5GVQqDk+enrQVe258yzc6/SfiaeeAHLN3W1Y7jPslrHFtKd422hdexieS4aYeeRpkHCbWQQ9ZJtYlOSWxB6etfydlNZAL3dWg62weXRwP0KeLO/XiWuwA0AnkVxksZDpu7Ej+aCVKiwOL8AdHXrTbiF6jMhHJZOSFsYjeKpgfLGkQnBQ65KOdfQE06rQSThSdpe1uA3wQHXHxOJvbdPe8Ziw5vlibmg6Lj6anvyHqEgm5+Aau7uMQq69v3Y0TCUzr5OszuLc8wYeMsKnK7/y0+8z1KHkzz6LZ4eqidRpYMtLdWm3tfKiwvnI+xODX+s2904xcwtqIx6s1G/Jbq
 A6nKuAKq
 OY43LvLrqWrTdK+mBAC45yYNs++oeSO+3pXm2LCTvf2TONYRXr+9zmxpxN7atUBsUAMY5nAfoVemyMAWw9Lc14UCWEuUsqgIH/7idRErk4rGdoDEJaPf2Yk/H8UG9KoT+O8Gz50ilDN+FBlNkhHQRj+xLV/J/RiRizSshVqFraYTR7gh+AQuLEm0CX5StTtuoKKvod7BxSKGMb8ZJtiXFJp5NKo9f2Ebm4qxnS+FXAo9ZVyIXbQm8EWUzW8gS7aL+L3Jc181V8poTaJmSCkM55cPYxPUd0BPhbhJsZfPs3l0R21mJFYiInEP8SoHZtyTlFIld57MudC7n09y4ksJz8fBI8Enqd7ba5lLaTnoSP693EZJMQc1URFh0s9m37X8T+90mCqemWK9WecGEZbRHG0NytOZGuf4jwF/64ZHIYCUhIFFER4yow4SDQatVWs7RK5hBHs+iORisKq8cWmfLmaeQFxqYmq1CDSNiUQQUnBDvRVAfX0QpqAjAdoI3JMoEbt3nOFrKK2a+os2gxZnpWXZyL89iSxFReh8JrFCoEklKLHpP5R+6hY7rC0iU018rfgBXTNenHKA8dcQK9h5oj8Df/Md1T68c3TJfLxTVqQWS/+Eg4WjGutuPYCHp/gKDLsOkomkPg5tmeM2uHtoDOvYcmMckpaiPIAA3Jdw4jYvVzuwhiAyzGgo9VyLL3qJ6BBw5sYkNWB/UT0NfffoRGjcIVBY3/TJgWLbNUhbhCbqKrjh8o6Inim0f6j/ZLo6siCxJqzRIXNvC+sqJ7vgwaQ+pdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 09:58:31PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. So an lruvec returned by folio_lruvec() could be
> released without the rcu read lock or a reference to its memory
> cgroup.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the lruvec in zswap_folio_swapin().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

