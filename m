Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3043EE67482
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 11:09:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85B1A6B0088; Mon, 22 Dec 2025 06:09:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FECC6B0089; Mon, 22 Dec 2025 06:09:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689AB6B008A; Mon, 22 Dec 2025 06:09:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 584C86B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 06:09:19 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA712140A9F
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 11:09:18 +0000 (UTC)
X-FDA: 84246835596.09.63D4E14
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7E5AB8000D
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 11:09:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fvCQIaDx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=x585Jv4L;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766401755; a=rsa-sha256;
	cv=pass;
	b=ONlVPLNxBDS+I12hBxnZ92Xxiwv3kZ4OB9lfk2J09PS1woUwuw2N69l+QkLIg0D83DtJoQ
	lxQV8A34SCDWRHQjt6QPpvsq74He1rJV67gZOHvj09Lo91ZPT6O7u0MggmsKepXHW+lZyx
	jRk96OVC1Tg+dF6eEnKZeNZ9H3A4CQk=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fvCQIaDx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=x585Jv4L;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766401755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LutcvEd58bIa+FBZh8bC07A6Xg+DVVD42vxRy1H9Qzo=;
	b=Jyvh+PLWkgzJxpCBJWT1KW1Soo7Qy8rmf91MCKUuZscJUVQ9lwYmNyeKKcwE0UFJ6Qa69t
	JC9xpLiQKUl5xNvkM+sn14L3xjIBWKfW9QzSbdJZHC3iHERw2bnzJFF7dR0TiiT61IIuNf
	lxoCI8edx1cs1oPUKKIqVB+uPHdcl8o=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMB6Nhe2055828;
	Mon, 22 Dec 2025 11:09:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LutcvEd58bIa+FBZh8bC07A6Xg+DVVD42vxRy1H9Qzo=; b=
	fvCQIaDxvJs+cKBtgVTvjxZt4GpHkkHytam9ju7g9nZZaSFav7SGCxrFP8oPemVI
	woZwzI6SY1S7wMa7g/tmnEUJQUhOx1noHRF73ZD0ZeZ6KBfipnmZNGrDXWqeikeU
	cZXqTP/aHJMu3uhDIm9H+HfhY5HpE/EqkrkTD3hl9PWVfFMomggQKbi8Muq7BggN
	hjyB4rUrngDHAC5LhvHMZe8797DYWoDXQRkeEvAKRtYtFFQmTW1O1JMjBA61gHcx
	zqlYj2PkunLGW1L6NP75NPYmJNFoV3j/RRMfpHA1rQbwjFvt+iTN7+Vw6VKNw/Vr
	HFgzAwAh8o7cEof8fV9FZg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b74ttg0bg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 11:09:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMALjuQ039962;
	Mon, 22 Dec 2025 11:09:03 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012027.outbound.protection.outlook.com [52.101.53.27])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b5j876nbq-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 11:09:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sldnBMOGUGn3VvPhh+ZLR1TikoiwXohxBJa8fgJLQCB8x/ZQRZW2dPe9Ykn8uW9Ul9ElrqO4hPNQaXN39X8F7yldTZYv5Y6GEiShh2hJ/0OOnqEUouKBueuyDUvWNg2QbaTf5YYDPdXRDKOO423u7m95T9uO2gDYfzPtAYT4vizDp6joGurbLqSiF1Dsm0m8exl2MzPCnXu7Pm0ueiS2vHiARx8zdIsvWRMV43xGS+OlLKPhkXrizo8mUNF80tMa3mmm98LmXhtdMg2IPy4deoQxeu607+v6uZ0PZ0H25USH/+sG2b3BQyFkV0Sm8QHc9APIC52KrC0xmmDSCfnVVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LutcvEd58bIa+FBZh8bC07A6Xg+DVVD42vxRy1H9Qzo=;
 b=HJIjQatFyDv6Xjef7azDqTDXir2RCzRaFKhJkSpTDDgf+k2ABzl/6SSnRk9ZUgdtiilDR9WOCSpYBl8sYXn8kaF0huYb+L+zWgqnSHJWE52eQBeIKZXBrYuLCAtzNU6scQz5gHv6jSoDAxjaB7XK7oVGh6LNxzS2Q/uLRxb5ed0+O7LCWpsCN0yWesDNKraALIgXTF//BR/1+Gg6THESiDLOPt71nXJkvhs82+ni4ozNUh9tDFY2+Yhdf6F/Z29utnFBxztDkYNxfw5pft53kfXzezy+e8yPmicfxYM6QJGtg2uQZoMf+pS9/FYv3N466gyT/nd+MUNFX1KpEWS7iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LutcvEd58bIa+FBZh8bC07A6Xg+DVVD42vxRy1H9Qzo=;
 b=x585Jv4LyPfmMWW28XWfbbjpUVkaABNUgLM8BhmNB+FFPx/eJuhXuhZfXFIZwQzA7WEyOh+Sz4FuHon7S1NibjDIl6YB1yR+K+a/yMCDVpfOQAAmeiD4G9bkg3l0kmvsuBBocMl6gLFKMjmP2ACdoLQ9rDVxJ0ffU7FGr4v4/nM=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB4741.namprd10.prod.outlook.com (2603:10b6:510:3d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Mon, 22 Dec
 2025 11:09:00 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9434.009; Mon, 22 Dec 2025
 11:09:00 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: akpm@linux-foundation.org, vbabka@suse.cz
Cc: andreyknvl@gmail.com, cl@gentwo.org, dvyukov@google.com, glider@google.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev,
        ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, surenb@google.com,
        vincenzo.frascino@arm.com, yeoreum.yun@arm.com, harry.yoo@oracle.com,
        tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        hao.li@linux.dev, stable@vger.kernel.org
Subject: [PATCH V4 1/8] mm/slab: use unsigned long for orig_size to ensure proper metadata align
Date: Mon, 22 Dec 2025 20:08:36 +0900
Message-ID: <20251222110843.980347-2-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251222110843.980347-1-harry.yoo@oracle.com>
References: <20251222110843.980347-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SEWP216CA0043.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bd::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB4741:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b0ef00d-29a2-42ef-561a-08de414a824f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bdPDEVi7FYsreM0p9el21dswSl89tzWkB2ny5bYXFffYNvBoZrZ5yqnGakkh?=
 =?us-ascii?Q?J83+K5bily3qhd8E5+3QB1hHV+1E7V/7asRKLoxdQGia8xU30pOV/cjmVibe?=
 =?us-ascii?Q?feVTOOv2ki51v5DATGhIH3EzT9MlvE4qCX+gDqTWSvMSzBqFWn5QtCTPTbSa?=
 =?us-ascii?Q?/X9l5GJO/mcOW0PJUOF5htUDuxqyjJ5T2WdeG1ZX02TDpuBf7E647cnavamb?=
 =?us-ascii?Q?25MPVJh0lTrWazpK+6L4lx8Z6ig5uMW/6+xSs+0XxuVDQ37XX/NvxTEqy3Et?=
 =?us-ascii?Q?GM5LGIlZRDUlSnSI40w7AK/HCSgSrNIZ7QpFOgInZKyfOaDcQWuz+vRsU/iY?=
 =?us-ascii?Q?/3vI6azu1W9TFTrA2VEPJSu80z4e0odqKF0EpLjQuEjHQRfdq7T8+vfSvlLv?=
 =?us-ascii?Q?d8MfvgmBFyXuaP6rkEYs0cg32FlgIeqgvgppNO+lCb/wCMwO2Mpdg4hi7hyj?=
 =?us-ascii?Q?fcvUDIzTYO86y0xjz+BeAXdj4yIB6gEBGZbVjnSI32WXQNIfcIfiBdB5VN6/?=
 =?us-ascii?Q?Er82p2/qMct48cRHm2hlBVbBG972m4qRx/aBgErZbbUBtGVa6IxcocqHNk1s?=
 =?us-ascii?Q?yeHuxrcE7M0T6RIJzy/m/MVIhLwTvjOD2n7bMjcANxTS0ATrXx/oK11/iaOT?=
 =?us-ascii?Q?tTBD4QI8OK+ViEAzBzCoyjEb28I4Uron5qvrBfvp91riTQWL5o9nDs/JiZd7?=
 =?us-ascii?Q?X7xCnG7nc9PcYjnqCPj8viqtxDa2K2BLHKyakkcxPoDXAJAte0QDpFV5eIkS?=
 =?us-ascii?Q?ZVNmsoRpNN2bgjtUWn3DXSxP8kf+k/dBdec9JEZO0XA9/yeH/JDz7H1RyX40?=
 =?us-ascii?Q?MZmNvprFS/rptNpxT6Qj0DkOFMh29TyptScldTLEbJWWH6yhZ2A/VsHS1drS?=
 =?us-ascii?Q?k2ZjgUQ9SXJ/Jd/jPGyrjePCWNUFATofwI/xv8ujDLta84lP9lnydnBsuC61?=
 =?us-ascii?Q?G6tLtnnfxWGIaws8SXVGmjuBrkyVn5fkPrzD8ZPyiAhopDJIj+lv2BYJ5pop?=
 =?us-ascii?Q?PJldwp2FSN9GQab4yBBv1K/iPacrgP5mL7UcNXgMY/5xd0nf22TFbDyBXKps?=
 =?us-ascii?Q?0fn3syBGPKKV62pV4PuNrCn0Q0TKOWw9X1gPEot+dd+3rbEc5lUhj7HHjD9A?=
 =?us-ascii?Q?kOSXEDfdjX2xdEPH9ZWsfpHoT96usyhjcn4pl3+qLv3H9fz/tPw98pCh5+IL?=
 =?us-ascii?Q?8tfWAv5zvCPOhryVbJU43dBPC43ulj6H3aH1b67P76KVRu2BA9aGeg/Jg0+K?=
 =?us-ascii?Q?/1FJ9i+cvGzmiIahN+Ye0Hij5atc2aeWkR3/H+GrS4IQ3ZQvub2/wC10A3aS?=
 =?us-ascii?Q?drCYJtB7ninnfA5G+HrLmRG2iJKR7lO9oprgQGIceEBMu0ufd0kBsD4Ca874?=
 =?us-ascii?Q?36p+/ONb3CabQd1Um34g7AyEs/Kyzeq9BVQfCAMCZ8/sQb/FokFEngw8H7gT?=
 =?us-ascii?Q?xHEE4VfUksdFVKiqcoBQkzcS90fbkrAu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FNcRERFWt5atM26m94ub6Y4PPT1VWpP0ihVX4gl42cHKcrME4AbM/28oib0s?=
 =?us-ascii?Q?HZ9w7phPyIiUqHyY+S0ol81bhyTiKYQFBEzY5UOt3bfjb9aOFlcbmjVDLXIt?=
 =?us-ascii?Q?MwlHUr+/rOwCpeN+hrzVHxyGMM1nRob5vGNJYTITA1QSNYYoS13xQKYJ2VzG?=
 =?us-ascii?Q?MJfdNzgVWnh4trr+4u2vBtr/wtp5iX8IY7S/3fuxV8aU7xFcKTXlS2evBmZw?=
 =?us-ascii?Q?U1rLxrZc+4z/WUKXyMaSvv7eMT90kFLXWcgtyxjObojkulTrtzXQqodm6yTt?=
 =?us-ascii?Q?CItOYRTSi5xzGbQlyj2xwhMuMgTqraD3KuDsv7bQTICwf3hQ3ewTZUpwbVNk?=
 =?us-ascii?Q?mSvbaCBj/mxohozb3sidiMT0+QQuQLZ+KYAoKkCSsF4psY3H5KDmaS1y4iWJ?=
 =?us-ascii?Q?aQTTYc93EGAMjyfLLuYMjzcGqrZXLZf4ZcEMYPuS7rnwd3dOuQDkztNxRjM9?=
 =?us-ascii?Q?EMvcAoRmTR6srOGdLjYWHBM0VEya7/mwc9XfvuPTzpyOQbZWdofXo1FrSNAu?=
 =?us-ascii?Q?6bY26nFXCrwWw/xwz2QBBfE5uO4fQlGDv3EAjj8vAC5lGjUTBnGWav+sc8YK?=
 =?us-ascii?Q?LKvDNAIz0KiS7CpFDB3Z31qSfnet24HFyqtYAKfV8ntdvl0NsJYyRWQi/bpM?=
 =?us-ascii?Q?1E4Qy+gn1y6y9gwrcxQuGmiM0VcshU9FWj9Qh2IqVfyjWoqVdIY3MAbGGnqx?=
 =?us-ascii?Q?m/rjfTmqyoN7+opHeVdGxmgPrgdaQqEhtKV+M+CmtMR+x1SYsO7I8maqBwuZ?=
 =?us-ascii?Q?cQTDXxGcGZuQ8nKR/c8qm9+vMPmTp3e9Qpo1teaP3Vf/rkvnC+xzVbYaiOoG?=
 =?us-ascii?Q?mgMwzhT5RE+koOLOMiBMB+a2WNokJv7yDu7fAaHgQc/h2KBPixq6MjsGE9it?=
 =?us-ascii?Q?FKT71yqZKJz/AMIJzGvVW433Go0E8bjBhVeaGkWqhrK+EozsmFMZV/Dz4peX?=
 =?us-ascii?Q?POb0rV07SpJ55buVWcg4ZYiBACpxkin5HU7acNM4rYMnImm94VK11ByywhCG?=
 =?us-ascii?Q?Nu0JAewQkYgGQeoJF+my5XNcEVwMx7RGXj18iHw1HCcvJOYQ+5eEknuKk/Oc?=
 =?us-ascii?Q?/vPX1tTxCX5nhRRk0d4nU1OP3NITP8M8aTT3iG6ljVFPOnIJnMuEu5wa4geE?=
 =?us-ascii?Q?3dnZBDtPSA4VSdRAqjQrBnxnysb9uSHfoPjIeBfpoIyIk0H3XiCgKTHECGnz?=
 =?us-ascii?Q?t2iFXC7H2NWhJ01OGQ0YxTlz2RPhsYpyg9Q5s4ZziMpGH2whn4s4uZTDy1GI?=
 =?us-ascii?Q?P3MucRsXrnU9Cv4H1JgKE9V9afFTcUa9bYDUlRX1uVjQe65JWxNfXVID49Bs?=
 =?us-ascii?Q?INEogxBPaZY3wWpA2Cx7kpfpcOmUiqPuen6xq9fejzOUCv3lS4v5DNX8fFpK?=
 =?us-ascii?Q?Ht/dF07PSYGdpIxUudm7TIiEnOM3WMU5EA2/JxKK0mfkzSK+87tYcIC628Ay?=
 =?us-ascii?Q?yRTWLFWn9uKsm4StZH7229PwSWavfoeo5N05Kf3WHOGqnUbyrQJVCUmr3BFq?=
 =?us-ascii?Q?NwP2whZLoyypa1FfzNaoHs9Dp2G696JAl6IPshVNtrRfSwZyJzvZZVixz+Ts?=
 =?us-ascii?Q?dZxn+cpG3VMOmzvWljRfVCT75Wc7PxICT2DAG7L145R0AMPtYTbr9hi1JJDM?=
 =?us-ascii?Q?t+Gq621cySZH+uxjJdXqDUsKRO/Srgay27b+5PsSB0vCKvos0crw/WsJKlt/?=
 =?us-ascii?Q?sQK1d79hkd3cYKpcV3ohLjXX+s3ZBjFit6JAgy0mu69DW1OChseI+LKf3mvM?=
 =?us-ascii?Q?wJVj+wW6Ow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fjx+mBHX6dTw987m/XgU8YavroUxGzReoarXMjiB5pAv2hXRuWYZ/LSn74UXTfJ++gtvMZUh8/xMPhwZC9IxfNEM5uyQyDgtS7fTbZwLhb8u5PX3vE3lvsFyUPFfU8qKvLwptGANZcph6uOQMna3lwWOdl+6wreHIVQdVMGupG+mNDsOY/H5FxQo3kHlWIDTcZb735zx/M8hLTrLUL/m+pGslvw97K4gD4pUEMXhKYS8wecAQHL2LFUOt+lTdglVvz6lW0anstCfJ9zVMA/9m1k/QwZqCUazMfEpfbgisJcw0XugBwkG9GfvGljRpZuIUYl5g8ORxql1KLA4kSY/RW9ObvlyGi8LsYxINg/uSW5+Fl8WMys/VoRN+17F0fWnCtrDNIOvD0gJfmvuP9Z26IEEmkIGpRPc7lng7dCq7TDCiKjnLAOY4T6Q//emD2fs0VLZZGqDAL1GlJ1tTVcAlH9+HVNdplw0P7M1WL9/djHQMoSRAvyh5hgAA1xW6LWZTb7PiN0zO3OD3ZsGprTb/chbRpjObbRSYQU17vD4IQBad0KEPAZW7qwjZTXUEkRI+bbVMiZPQVar4g3qB6E/VMBH8GlbHy+Q9lGeLxV80R8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b0ef00d-29a2-42ef-561a-08de414a824f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2025 11:09:00.3843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k0SCZoYlWNkC29GIKx/PKetnlsWHrjPq7WcqvrU7fWH/TORtBMSd0DN7Cod2wa3AxudzIdnLMioJzJ2EU1lSMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4741
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-21_05,2025-12-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512220101
X-Proofpoint-ORIG-GUID: MeVxCst5-Ofv9Y3YRZ47abTnvo097w4i
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDEwMSBTYWx0ZWRfXyNp5OVblQPio
 8qaAJHNy1RHp2x/h071YruOaxAAuD4i+GJ++qtYhUGEH3WJRHsFC1aziLLpyT7QfAL9GUZHSBfx
 ynevV2B9jZEVnTrZPkLphEgU82dR0GpBDw4zoTOOpBCETwt8MqtXUZa5BFGcymB81JpEA1VknFs
 b9wrpPUFL9b7yA7VKhyuZYFxGfvvhcu7oLr8+1LcF/YmU+jU+6OT1JoBYUuk5OOZUM48Eyapeyg
 MOSiPDYhqL1r2wpkyHo1q6Ewpj8lYRnsJD/GeObDIgqcbdc79TZc2DSv3le8xLal2jRK61VLnUD
 YHWFzho8oxq+JOWIwv0qXC5Ia94I2p720ziU/lcULPlpY8M+fFcdT46Fg6fR39aq/pijDXMQ1ar
 4EL1Ow4AaanBBMwAampf+UxgFrOVyvnOYAbl4RzJjzNiGzIVBOHE+sHmhMSvQyGBwtwok/T9wgx
 dremAD7EK3KdC565d/w==
X-Proofpoint-GUID: MeVxCst5-Ofv9Y3YRZ47abTnvo097w4i
X-Authority-Analysis: v=2.4 cv=d8H4CBjE c=1 sm=1 tr=0 ts=694926d0 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=60bAUpEqyJ0hnt3RZ0MA:9
X-Rspamd-Queue-Id: 7E5AB8000D
X-Stat-Signature: czn7uwxoybpqht8pwmxbf5jaqqhg8wyn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766401755-624799
X-HE-Meta: U2FsdGVkX18CHORhfH4fehG+XR97Y5SRe05Qrco97CggOiQPrXxijMVhE9f/8zT7b0nWBAKF9wHKwVsqk8Nuxpr3PwMwqIyke5ZxE1Xrhk8I0aNFZKT7QmECibYGbDRqjz/yCJdyBWv7T2tONhzpTE18aK8EPrHKaIZ37Yj5FPSH6jJ5HRCk96qMzQ4T/lgMkN18W7lkpZ6GBvIA3IGPDM2zuG/Pg/+CUZ6jZ5uSwVnNpNuqn5lNPSaUN6vp6/psl2ffiJg3KY3WC6W16qbjRMleUB5/rcmqzQKenxoe/+pwbIuNpzXkgDXehD5CEfmQ5fm3Z8FHcoZXZEq70o1eGhONsQjTs4n0IiiRvivvUCCKgvmvEIY1htrn1UoPvMHp1rm0aMNwNcol7VGM1f4JsA61SXGlSheT2AdH9RWCzQhp/J25dC+0FdPLLAukRBv6ns1UMX1ip7Gq8hPW1eNcPWRfTjKYwhNqs+YyEw7lKOTcr3hHr3+0aSWZWX7eKhypOtN7GLLCbZ1PhizuuBbH4LRzzn966j1SeqYfdUkuA35cw+ESui7okrv6AoZ/8A26Z9exAkd5ozrrlBfENPr/l44dZT/rXwPF3ytWD5JyWE031FEGKnOWODCS8DCCXJiTEX0wHHi0c4HVCKms7BPa8XYMF/2PRZ6qGkXVIBrgIX5gd2+GBUET2r7Djk4ByWs2NABVJp41kvr1rY2RXzGJWxzXAS/xyqEUQUKEQ02Q/zRydYKReCAk17UPoBFiiCiTZ2SnwBrl+Dexe2CyOk7N16isb6pf/9aZe/q4ITo0RXTvY60Dx2CbYrkd3/hQXSfI/wmfeZPNwIMID2DRRabwZdaZK3lBESKTjExB/cJ9whjIW+Z3oAPhozBQPUsG9fRlUE8KwrlIgH9OqxmN1AD1jS4if9lALIh0VcushpGaWNVIlBEhwBzy1F94HAYH29kdo4nrCK8qLkBTjdqlCN8
 ZaW41VJJ
 cOkjY6Y/POB8PjtQtAsE+tsZFuSB8vDNoTEhO2Khb9+1hCGjlabspv0jwqxsXsIuiQ2svkCocl8m6aDnVHUsErBUw/YpDUrua1hkt6e90cvghFk2qsTiR8Yi8/2tsb2RSjfINkgYsGGqhqAcFU9CdarzEjGa+lirHrQuyjasgnY+ucXvj35BGGBP93YRXUancF/m7zm4QMs246AI1KiYbo34O/UBuJrIhrTdd9NAsSCfgu8wchwy8+X0MAuKg33ri9l3mtqJTEDxoL2e8gIS3wL0YKD2xIm9Cdp2YWw7OaIA1gCAp+oZOorYyaAKl7aGgQ3/RESu02feeZZ4hB8yDB6qxlLSdKoaAHJieOHtQIpsgKqchMbqg+CaQ1Cjztn+9rYeNwK3/Z2+bkFtIDpmtDsI+DrAUIQOUBkQdAx5SzsOWcNu0QWrX2Y4s0qAot19XNy6eqjBakJcVZa8HHy87H/azgh/tvcDiG2P8V2fQUJ4IGHY+PMEGrw09F+BG06KOGNDGJvoLWxjEkMyew+PDgQ+sBvpTTmnifxzOvpSe5WPRFB8WkgrV957Fdv7EChVkxcDTRqkF79Q6aIeIzASUel2mJG1r2ehEnwLz4Bu/r+tAOcXAFt/b9Hsz3I9/i7lTOsVIZGHHpUosukzey18QurgZa5LrAIbBzIIuwW7+QviLsHI554UCD/tLCf8pp4dzW7J+pCgWiB7oCHj8zpb0I6SfzHHd7IuhOzwPOIdi77/ehDgWBcz/ncb3yu7kQzEJxlQhCw5gsO0RJEiF7+vVwG0qL2QHKV4EycVCnIxH9QCyOUM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When both KASAN and SLAB_STORE_USER are enabled, accesses to
struct kasan_alloc_meta fields can be misaligned on 64-bit architectures.
This occurs because orig_size is currently defined as unsigned int,
which only guarantees 4-byte alignment. When struct kasan_alloc_meta is
placed after orig_size, it may end up at a 4-byte boundary rather than
the required 8-byte boundary on 64-bit systems.

Note that 64-bit architectures without HAVE_EFFICIENT_UNALIGNED_ACCESS
are assumed to require 64-bit accesses to be 64-bit aligned.
See HAVE_64BIT_ALIGNED_ACCESS and commit adab66b71abf ("Revert:
"ring-buffer: Remove HAVE_64BIT_ALIGNED_ACCESS"") for more details.

Change orig_size from unsigned int to unsigned long to ensure proper
alignment for any subsequent metadata. This should not waste additional
memory because kmalloc objects are already aligned to at least
ARCH_KMALLOC_MINALIGN.

Suggested-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: stable@vger.kernel.org
Fixes: 6edf2576a6cc ("mm/slub: enable debugging memory wasting of kmalloc")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slub.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index ad71f01571f0..1c747435a6ab 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -857,7 +857,7 @@ static inline bool slab_update_freelist(struct kmem_cache *s, struct slab *slab,
  * request size in the meta data area, for better debug and sanity check.
  */
 static inline void set_orig_size(struct kmem_cache *s,
-				void *object, unsigned int orig_size)
+				void *object, unsigned long orig_size)
 {
 	void *p = kasan_reset_tag(object);
 
@@ -867,10 +867,10 @@ static inline void set_orig_size(struct kmem_cache *s,
 	p += get_info_end(s);
 	p += sizeof(struct track) * 2;
 
-	*(unsigned int *)p = orig_size;
+	*(unsigned long *)p = orig_size;
 }
 
-static inline unsigned int get_orig_size(struct kmem_cache *s, void *object)
+static inline unsigned long get_orig_size(struct kmem_cache *s, void *object)
 {
 	void *p = kasan_reset_tag(object);
 
@@ -883,7 +883,7 @@ static inline unsigned int get_orig_size(struct kmem_cache *s, void *object)
 	p += get_info_end(s);
 	p += sizeof(struct track) * 2;
 
-	return *(unsigned int *)p;
+	return *(unsigned long *)p;
 }
 
 #ifdef CONFIG_SLUB_DEBUG
@@ -1198,7 +1198,7 @@ static void print_trailer(struct kmem_cache *s, struct slab *slab, u8 *p)
 		off += 2 * sizeof(struct track);
 
 	if (slub_debug_orig_size(s))
-		off += sizeof(unsigned int);
+		off += sizeof(unsigned long);
 
 	off += kasan_metadata_size(s, false);
 
@@ -1394,7 +1394,7 @@ static int check_pad_bytes(struct kmem_cache *s, struct slab *slab, u8 *p)
 		off += 2 * sizeof(struct track);
 
 		if (s->flags & SLAB_KMALLOC)
-			off += sizeof(unsigned int);
+			off += sizeof(unsigned long);
 	}
 
 	off += kasan_metadata_size(s, false);
@@ -7949,7 +7949,7 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 
 		/* Save the original kmalloc request size */
 		if (flags & SLAB_KMALLOC)
-			size += sizeof(unsigned int);
+			size += sizeof(unsigned long);
 	}
 #endif
 
-- 
2.43.0


