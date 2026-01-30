Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13649E6BF10
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:01:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FD026B00A0; Fri, 30 Jan 2026 16:01:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8876B00A1; Fri, 30 Jan 2026 16:01:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3A6D6B00A2; Fri, 30 Jan 2026 16:00:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C29036B00A0
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:00:59 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F0DE1B1B31
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:59 +0000 (UTC)
X-FDA: 84389849838.25.8FB6F1A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 080F74001A
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VVXYv+ms;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="M7ckk/GK";
	spf=pass (imf11.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pSIi1yhXk5IuY69n99aDDBJcBkNo5zv1nX/Mvo5fjno=;
	b=MnbbdS9AOZLg2Zl5JHu58JWG+6pV14R9566t7KE9GxrgLKL0lLKjd6fPoaccyVFoBuRLH+
	bgYXBT3dfYrbAZb5nyIrgGcNbT7ApCrRD7nDXX04Sj+fWiKfpLgtXN+MXXtgT79sHdEhA/
	nA0j3qYo/Y9ZOIHrPh6Z4LZMFUfU23U=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VVXYv+ms;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="M7ckk/GK";
	spf=pass (imf11.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806856; a=rsa-sha256;
	cv=pass;
	b=d1YZTbFmq4xys6QmkjaTqXG23IcsrwNjzignC9poJkL9eCxLTiAqk08iDxPBR3athzMjp2
	LsJ2ogRiTs9JctyjEsJj39LDjEOjLvuattQoapA33QcHsUluAQE8sFXNLrb24AIyEFAQvq
	yUl5mhKuxlPYFv7V0HKkxWBEfK73TRU=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDVUt4028717;
	Fri, 30 Jan 2026 21:00:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pSIi1yhXk5IuY69n99aDDBJcBkNo5zv1nX/Mvo5fjno=; b=
	VVXYv+msFwFDnazBBo67M7NpBlPZsgzsKfOeSp2LwXuLULPnC4PtERT2hQWDzko4
	rtJlHJ030jaYCQT7doTOl55TvRLAlyNB4xxrCyJPF/IblZfO9VTbxtSATrR33G3F
	2yPC9IqszhO9qyLXzDNU0DSbmmzK6l7bukXba9Q6vdKGPXThrQXxuUrnpy6oN7mG
	CvzQnSJl3MIKNewPQm+GcgRLCyngZ75Gq1CwzHLm2baA+JM/Siy30k3ksfPk8VrU
	KmMfHriyERMVFJMoqQdJu/MEhp9xRgyjuPHp+5PxJSl8CUmvgI8kORVrcAlEdO+Z
	uS2iZiuKHeqaIaVaSAZhWA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c10668cg5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UJKVu8036073;
	Fri, 30 Jan 2026 21:00:47 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010052.outbound.protection.outlook.com [40.93.198.52])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhtexx1-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vzC84NQ0U8kwCmMjAaYtafukJzfQ86BuamEzbCMF+8ab0+9NMUkOknmysy7sWl9ZXFR8wKxGRshtNBwMw4fEH8Mj+WjXCWazjHu8r1806hqVWD3hLbSValbCNTFLnw7Q3+sY0A74xnXpUL6SIUwbqwlqLxeVEDbx9qhwf3jHvViFVmrotOt5gkguMMjvihLumlWYuj7EYOHT3jo5suaG4jhr/6w7RhLkzWibC1N92IKsuHz3MSxX612frwbxPdQRxKC3RknU8XiBTltt8aCftM1mtfIbCp90Uhs7iGUJ/c4GhpdDuvR8w69f34Kh+YS/Jd6chLMLbxkT9QcwFzLuOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pSIi1yhXk5IuY69n99aDDBJcBkNo5zv1nX/Mvo5fjno=;
 b=MePd96wWsfIjOt9sBhwG/x+q1GzxjJyolFFMzQfiqYAoblDERgtN2EwuSvisyIcxT3BLc3uSaxcWtJMfJG8Wfx8BgyCB4rJOZzLQvx1AvjwjNiiWW2GXOWR+eiV/9b1K85ZnaStjtH3sN3tlpoa0QT60WoACIBWlFdBk4JYhGiYdkWMWmhdLpwJ0rHuYdfRImV8J3ttjQthzva23JjXmg6qLekt4n84kEJxsxhSZWT2DnFtA8LxUZRmnFHwpLFjVeXqP8ae9I/CkIobC1xtBJFYdGWZnQ4aHrK6IDiyDFqfvAo81Nf/70cVWoN55HJTcmJ0U+OI972rQVRufS9v15A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pSIi1yhXk5IuY69n99aDDBJcBkNo5zv1nX/Mvo5fjno=;
 b=M7ckk/GKktnINiuOVqEn+yfjgNE40nfiig++9qynpKfni6Q7uOANfTBMjFvk9VNYpa9IkvLxU00LT0UVrcZuikuiZnJxdqTtPxDBleE+M6aVepBdNy+6hgNEYesB75tu+DtAeuhnpjFdf5eYD27EgLiJYf3r8ANTzF50e4IFiGs=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA6PR10MB8061.namprd10.prod.outlook.com (2603:10b6:806:43a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:43 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:43 +0000
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
Subject: [PATCH v3 21/30] maple_tree: Add cp_is_new_root() helper
Date: Fri, 30 Jan 2026 15:59:26 -0500
Message-ID: <20260130205935.2559335-22-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0040.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::26) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA6PR10MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c315743-641b-4678-a34f-08de6042a218
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UqllA14kmPWtWx2OcX0K4ilP3sic+k52t593GsI2bOeYT7HE1JxX+ATURy17?=
 =?us-ascii?Q?maUUUpARUpvDhvPEIvHsKCroEYL72SkYCEBiv6dSrqw+zs+NoggD8rlW494/?=
 =?us-ascii?Q?EqJEYnry+LprDEg4jArhc5aTgKJfTbrH90WBSZu8ZUnzCSyhv/4Mf4ZrruOS?=
 =?us-ascii?Q?Kj/LBXXH2QYtPs1c2pB3pRTcloCLwMUpHCNpGlHZgSsUh35TKHx1kmdecOBH?=
 =?us-ascii?Q?/ll4loKHmnLcab3nzPZI7pTNJmz41yolsI5ephxAk9CS7z2CjZJWRkHkJd3v?=
 =?us-ascii?Q?dPxl0+bRJfZj5uithEzJ2Q96l73J2k69X+tbzLaTkB5fmZPqyPov/YHettve?=
 =?us-ascii?Q?PiNRi0PQqFUrjAFGW7MylOkhqGZ8zPRBCs5C6wbtWgLbsqdbJENLtvehx6XA?=
 =?us-ascii?Q?J4zmZYZlGcG/LTeKksNY3zLceOuABT42ruq0SxG0rwbg8ae2Ca71e+Lxh6hr?=
 =?us-ascii?Q?D68ywLyqDFSZ93azmx2cjoBxBlvmVb33lXnWpgNbWKa/R8Oc0EXBYBv5LZp7?=
 =?us-ascii?Q?9Gbxhz553KpRPfzyH92tgQKTOW366uCh75wVBHRfF5CnNzBRu9MLDd5aRSBR?=
 =?us-ascii?Q?3u0EOOwhgoFVFRMGRTVI3U9PsMO6Bb9IvvSLzj3Vw5TnGKj4U/jmFKR6L9Ou?=
 =?us-ascii?Q?n4F4EuMmq8JTUnPYtjC7ju27wo7jTQZp+HEPFEzL7BdQT+K3V9Ysp7ZFpo/x?=
 =?us-ascii?Q?7k1UcVR91EgbSGjoR6BsM+wAbbAszX+VWAL7D9+WRkcIdX6jMJEHFfJs0VM7?=
 =?us-ascii?Q?e8Hig16VXqE6aJ3m/vZNgnLhIuwy8SQE/8vvrvPcmNnmd9W6M9s57jg7p2RB?=
 =?us-ascii?Q?dwR/WRwI+F913qNMN8TXAb8RUy7uJJ2sCUcP+scHh0QivB/kJUc4zcCFec6q?=
 =?us-ascii?Q?grAouemeBALOd2zbzuXSs/sPj/vsD7pO3XU/q5LKtQ93PWazv/J7W9BHV/h4?=
 =?us-ascii?Q?T0vQb9TOQ9ib2flQ/KkyaT3clSr7BGbM5iCUTbQu1Cn3yr7RKUsZ++LrI6i3?=
 =?us-ascii?Q?xSPvG3iWx0mSQ0+WbThNJhM0P/LGsS2av/594KA7Mag4LYA+jOATrj6e3Hww?=
 =?us-ascii?Q?tW9yorh5q12enrwKgbHtP3aMNfis6f3wrsFPqtoM6LGKjbSZc5r8XZj2MBMo?=
 =?us-ascii?Q?NFl30fxf7eZbps4xrHyuUSjMrCBgXhWcHUDpGDrbpF3CCA7Su7QQ6/6bPvXb?=
 =?us-ascii?Q?AOZm2peE3dnNN0ZwG9Q9Gyzex8KRQgpotTlErdSRI9ay+xHSj8TNwtGPclTP?=
 =?us-ascii?Q?Y3ZydCCRZa8skD+K+amH+f585brqwUjC9MVBRzEA9NiMRHMR89+Rwra40II7?=
 =?us-ascii?Q?/WjNolII2TMihwwD34jTEfs3vb7AJfSQHBJ2dBKRQwcFf721KWmCu4dGJrIP?=
 =?us-ascii?Q?1i3WKlXcPd8RmJOcKqyVWIwABpJ1XxBVtpkoRL/Yscpvth0cDSz5J8gG7xza?=
 =?us-ascii?Q?BqHmRM3NKXmN2RXuc5LS/2o0HeEPmtxhOiyrcDk0XTTKqxzb0lwY2xvetggc?=
 =?us-ascii?Q?vPg+dV6xAjRj7LrHrVZ38AgH+h2UvSCT7r80dv4g9Gfo4TNn/ASKE7P0Udtw?=
 =?us-ascii?Q?ZhDNn7XzXMGp7Ug8lyw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aGSjpHivr43VXQfaBHK15bMysGCYaC/7qaverupbPvPSYIgPyRmOCCijOXR+?=
 =?us-ascii?Q?VCU2CGmSnijtaHdvXA8DR/OOWZVy7CFUOkvzu84NhywlKiQMhd4MEml4uo66?=
 =?us-ascii?Q?roqlNbk9UVejX03HAlkSA+urPTOaTCRFi9R5VeRRj5H1v4rmvtaeCiD5g88J?=
 =?us-ascii?Q?s/S0joHy2xyIEsChXVZYvhs1gOG+q6NiMdb2L9bZ26ByZdxWonTqu4WMcsRa?=
 =?us-ascii?Q?pO2zNLpI9SGDZ8sW9k6vYIGb2hmktxN7+JWW2vVuYc8uP1F96qH9Sosyy6DH?=
 =?us-ascii?Q?ifH/ZuLHpvi+QJb3XjKIg6Muix24ecLT0TzXtJ+GWYlytHn8R2HoWPKuJgtS?=
 =?us-ascii?Q?TDd1G6waHlaIvMiM1zNa8vSoOEBQml8l9H4pzMn3bJdjbzHSL8O8Xb40caWK?=
 =?us-ascii?Q?xpSJsFQMhRn6QWEP3FtnHeCf99R0oNy2vg1sJsLPvT85ZyAgdB8vk88RG810?=
 =?us-ascii?Q?rdxgLVKcIoBpH20LbqsXQwX4qOEV9Z+7Exr8DoMKtA8HfgjzvWFuNn2XJGOh?=
 =?us-ascii?Q?7csWoEF5mQCwUVEQIMURLhpsQrIJ4dliH5bbjJu4yAD/SZl6ZwgRBfxCJUtu?=
 =?us-ascii?Q?SgjzmYoZdEjs0T0/if9J4oA/tqEyQg0EFmKCyVCCS43YkiY/O9ORgyUkcyhv?=
 =?us-ascii?Q?yN/eKWFvPz4dfQVKexDyt4ERWKDFXh+2Bn8mX0IxJ22Ew44EEL/DW1+GRPJA?=
 =?us-ascii?Q?fvkm3mwjsS5e9EXlYf/GggYtOnUwmO/XtmFHlh32QZKQUW9/IvQRMAGVghM1?=
 =?us-ascii?Q?l2xLrwle4rY36KcXKV9Bd0YdrHOCXQVZ4hvrjmlNoKoB4jkMGPSwODqft71v?=
 =?us-ascii?Q?hDi/5QuZYgOB6tTDLOUZxalwkVs7VnzQbwK81K59gpISWLTR03t4Na8hWBJR?=
 =?us-ascii?Q?svGe5bwMZvNXRHO1La5dd4cPallU+YXI1Z7kw0o03jioyyuEiXv86bhLoM8B?=
 =?us-ascii?Q?UPIrhhuplxLFXtAD0qGGVnP56H3E+1e2BWriAgf/ZHWAEh+EA9DjtwyHf8Af?=
 =?us-ascii?Q?/Qhq2uOaQ8DipnrnF/Oq7p2sd9k9MmvKwdLLO4W3C7DI/5CtK8UeXP5qTOOm?=
 =?us-ascii?Q?vUrqr8ENgjBHtkPc5ZcRy9y4qymh36EXCsheeuMcYCPMu4Q9RP9y78S8IiDu?=
 =?us-ascii?Q?JxtP07OVTwhdKZTDBPmsnIqqp7D0VpXHGtK2o9H0+cnVF4K5FeY0u59824z8?=
 =?us-ascii?Q?Tl2HYndiSfXJFpxd38u5ve+5rfmCC1Dj+b+n9O8ie91PUlGWuqjuV39D2gJ5?=
 =?us-ascii?Q?7+w/+dhoUJp/LGyQZ6n/FPOwa4maEmzqyzdakD/bgDGscdpPmsoUxj8ggSxV?=
 =?us-ascii?Q?PGMroh8JiJLK7kBWDFfEN30sVABEfo2SFmlKTPWmnd9h2EFFxJ0Dz+9rZ2KP?=
 =?us-ascii?Q?VHyZfFX7sMVe5mOsH9lWaSDYu/Cdn6sbEcR9snD4pdAFnBhDLFCDbDgr2yNm?=
 =?us-ascii?Q?EUT9ynrEx/xJTPu5RegJLC2fN4rmV+AMl2oDdfRmYdQrCJVe81iv3AQtUkVF?=
 =?us-ascii?Q?vF1A41iMUfn50ESxwZrimEyvTxNqnQdLfoLs1CZDUp/msXfBJg0GVS2iFHDi?=
 =?us-ascii?Q?EzohjY4S7S1gvKCT+hJUzwwSqfJFUFbm30Q7b6iLD/oxlcOXbZKgX955TWAc?=
 =?us-ascii?Q?kITXyLqwrxUluc51mNfGUDK2/NUfwYYLLYAYvP3JPcOTSIqfl9Vxx/mnaFIU?=
 =?us-ascii?Q?UjBhj7X56NYaHIjhrk7ocJY73QdXRq9SDslE4sB0fPOf2cuN99egLNsOtBOm?=
 =?us-ascii?Q?G7PeY6RvPg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EKk8umIXAYdMx/2nx4OfVycog6JPcfw+9DL34juHGRSNQ58OsI+HfAR5ceW2+WcrBAWfSmEd0dsV8hp9uQRXZmBa6xKvbqQdNn0hVtN3L9gMdvv1lCJ2dr7WpgoDZmVdYeNPrbGaIGvVIjjPu0Z9VhDv2tjxioAomgSm2GsIEKvl8YZmrc3rgrqRd6LDma+VnayRB8iDQTECahms4gMsvcPOtG92Fd6WvX+VyAKxapdyOr3T7wxyUx52o4qilNhTHbv0G8MFj3K2zE/sZgQ9+YxCG0v7R5oHIKhkzTY8/tVJdIhulTwuyPI7h+8tejneucCrNdfOd8YZHJB+spx99XKUDOfgfp1+c6krlcssBG1TmW8kx4yfv9qeFPfk0L2HRF8NAHlUoLewbamKy2AVC63Gf8a8z8RzFMmYvLFBvVXLiUw7ajFnt6Ea+lkIA7NCgtzSnpeNYq0jp25JRP8mpmckkIlCcw3ketRp7wHWj3Vb6YNRIzwbvho/AAvc10ONV0bINm0RvyKrLbAUMkQK2Y8LS1qDxLzQyS+buLFTN2FSgfdOEuF6wl/4MGdo7no7Pdoyn/fD3P16qCV1ILszQsJkLuZ3wLAKrB3iBnO3tvI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c315743-641b-4678-a34f-08de6042a218
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:43.8066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0xRSwQ1Z77dMJ3OZAftDXZaPvLqz9zhowGUWIw7J1bFRCRcVClsVcGQLEhu6svs2ZdFwLH2aHoian4GDojj3jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8061
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601300172
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfX6X/+ecMORZYH
 eHpsveGt7GRAiV9CoA9RJWznMJ/f4zvzWjL97I/nVq/qir8FSBW5FdbP7xc/OHz3tbpFiSqhORY
 4+SPDOoRnr7tBPbhC+9DKGPpanwJxQIW8PDewiBMlIU5yLLsI5mIbjApzSK9AxLSfPYE15FhPE9
 3kInTrq6GSgtrxS03kL9RmQWoKmBYkuYW5yrLuR8hwwu5nmxe4cNyk4k4E7xGPmdkc/E1B7LuhN
 crGDo/qhCOImXa6Hxs8uA7DB//Xq+GtdfV4WCOwVJt4stm5Osgtg9uOHQOh5fSKVRBbokTCb5Lk
 QEAH8VWnq7iwNABhlc9wjh0qOpcqi5XGaHCi6Pv0JkW+YhxWjjOtqj8JFKwNouVVI/YU6sYSV/e
 4Pw0grqsdyBwY17O8IY+sz/YDP9gC7TatQxivJoV+4jaEyFBr1OKwPl7B+Kw/x5vY0vuJCRE1am
 Q63tb3bTghBWy+N/JGMpAOJGrc8shGRc0+KzZhOs=
X-Proofpoint-ORIG-GUID: Peoe5lKnrtRI8MNsT4kJTXNZoC08Elf_
X-Authority-Analysis: v=2.4 cv=EebFgfmC c=1 sm=1 tr=0 ts=697d1bff b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=j0p3HzqOWq5dXWzuM78A:9 cc=ntf awl=host:12104
X-Proofpoint-GUID: Peoe5lKnrtRI8MNsT4kJTXNZoC08Elf_
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 080F74001A
X-Stat-Signature: ssay9tp419c6hqitnp7domcfpumfymih
X-Rspam-User: 
X-HE-Tag: 1769806855-751402
X-HE-Meta: U2FsdGVkX1889pInpo1I4YTuKuCnlXtB/bQbIVOLjE45qIoLj595um0/cIX7uzwIkh4RO9tOzax7iZxLXqF194gavA3pdjhSla2yWIuWzd0LyMZloJ2Ec1S4cb/cqC4hkJtqrVKiEn7otZeO2dESu3fQWJHk5vVogUBblPH/hkohRXd0mxWVysJomDhpVQAECv6McADmOo4FrhTTgAVV8f513Ko9s+/kfsv3VzKu+73YoWBwL7TryXxyujBJ+iPbDb/VQoNSn0ZwifOovSIvs5T9Jzk9lu1H+dWJDcn1i9XOzpn+pb0sw39ETteAuslwxYM6D4mJ+mpA2F7YVIgMdwu/rqdFHJ90606kUgSxvkqtHrLs60Iq7iKKiEK8PIFS+wz88pUttpZhJ9kpa6foL4PoUi/eWeX/HshuuH6Q2M7TUDNZX0fgEKG21ESCINWNLBBizl9ohdoSlXCHz4Axc+TJXgh9qzzoSsttOTFLGvivo6WQjsvuoshlB4LiTOgPdNyXv4QS4F/Yr1HlzWOPNHyq5vzwKkn37sEe1lKyNyvyHOx9o5rnQGotfC7Lm7Ne5LI23OAsBctX/TX71EYbLKsNZwjzr6D/oIMF2wFYnqzMzazMq+MCzWYxnxqusN5yCAYDANVnxRm8yIV6Q0jk36oewpp4o3uxU4qi7wQcSqozYa4wSV8GWX4eK/pZwK1bCzj2Du9/ieXrcvqMauQ1zRqwM7wVohGdQz3rgs5lrfyvgedWHMDzdVSNlj7mt4AA5jDNd4Th/NqJ8REIzMLhEfd6DV40pz4wuFTNa0eRl44GyjuW1O88TJpkC7S2TU0NU2zo6cvMbA6giWC333FE8zvED4Sk0a5v0fMyc8qNVwe15MEHkiY48ULEXQGmfhMsFHIqAuhrfphrwGusEUqYl/boUbxRn9bXqYG3baaptga+q30cXjddRWI/Lw4MfcFholpFIj8pA/zfeb9ECXb
 uyaqcFSG
 wtBRqKUi0S1PGU7+fAfV3JwQO7+w1IFUCgK9Rd5HsZXdfBvkEqsuJEl71IDF1DsEKRuBznYMF66Qeo/o8XTXw8TyklwHyknRF8g0HziXHvtOL86rv8V8fnMQBWMQtg2/1IE20dQqBDlFnG7dysvBMCVbeyKnokkCD7MDl/uqvDIDKw9efaDTgEqLY8eSwYQowz7zxxRr69b8UxgJPH8n61JRbUJvB9K0cNslyk4Mr/d8MqvPIGvt+Y/zzljSXLaYgiAJjGErKE5Sz1rwox2QUoTr1QHGROsrrpU2FLRQjB/OpG4BOf4kRJjAFLy5sFhPZxGUtjsqPsoFZBtoC/OBhADeqON1Zd3UjcaAei8+ywdvlmvGTjqoq9l5Yxa7F/Hl0NiXPSOiXDliH+bwV0uxQkWQyuMT1yRW4Zj+uZ6ihlfEsehm3oMKmQcuC87Xujyig+AJF9ExgMtd3iEHLUCr3HhmylRbD/m8uWzcnL7RJIQXyK1Ki8LimMaXTSQ+GvAJc1Z0uUFO7YxqZM2I/TaX5z7rMair99KoEtMoBWnSsQL33ini5uLDnSWWH+5jupgUmpWy36VzKioElw4u9ujAM38cxq5pfbwQvfzpT+9rItGz7JOSnkk6jowjZ53s/Zdn/MD1A/0nR975WjEwJA6T2p1xdWZge6UB+cqjjb+HU4vXsapiol4pYmQaGvQ==
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
 lib/maple_tree.c | 70 ++++++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 32 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 5280fa6d2d6ec..42038e42a4c7e 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3337,6 +3337,43 @@ static void mas_spanning_rebalance(struct ma_state *mas,
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
@@ -3359,39 +3396,8 @@ static bool spanning_ascend(struct maple_copy *cp, struct ma_state *mas,
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
-			ma_init_slot(&cp->slot[0], cp->dst[0].node, mt);
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


