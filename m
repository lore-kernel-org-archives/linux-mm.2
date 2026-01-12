Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97858C9EC97
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7C476B009D; Mon, 12 Jan 2026 10:51:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46E56B00AC; Mon, 12 Jan 2026 10:51:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF2156B00AE; Mon, 12 Jan 2026 10:51:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AC1816B009D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:51:57 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7227B14054D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:51:57 +0000 (UTC)
X-FDA: 84323752674.11.A85726B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0CE10100011
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:51:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IH3gk9qa;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OBZ2VN0D;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768233114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IQQziLfgocnuI48Qt0D/4eBQtJqYjqPQFJuvPqU1QI0=;
	b=RsR763WKEvXaeK6icz7z5tdpyUQVCjZdR+Tv2ITkCZziIiDd4tWPLa2H46qU6wq1NqRIW5
	KnguxvNUlcYx3W2Bch2HoqpWu5RjGYwFEuXE5IvCD3NWB2i7ETuORuP4abjWWOkahZeRis
	JKl9ZVcEn2yyDPWO742yCb9bVBxqxwY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768233114; a=rsa-sha256;
	cv=pass;
	b=zxtAmSo8ihNS/1ku8/usW+h/BRcA/bSL2DtpZXCdMU/vghrW9TooNi+TUK5tUdNB6SOw1O
	shisFAuSldTESw+1lNYMaIs6y6FBC+321jClLF1TOLqCQF3z8B75QbK4xGaOqaziPhKcIb
	marAOVH/M45t2968yJDRxw9PvuzTUUM=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IH3gk9qa;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OBZ2VN0D;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60C1JfVo279467;
	Mon, 12 Jan 2026 15:51:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=IQQziLfgocnuI48Q
	t0D/4eBQtJqYjqPQFJuvPqU1QI0=; b=IH3gk9qalq994c1xiLxIMiZLMr883RCb
	FceUYb6RIe3Qfkx9ehWBl4RkxV9Xub9F8m3f2Foc3UF89TKGjM/uQnNn8CwUsjFe
	W/6LQtD4knOma8uYCy0VDrJTnjqWMAc74BSMlj7IEVitmlOWsYRaEyoaMeJ0i2Q1
	keAPCw4IA0sYNPQ228tFVJVb991Li1Rg01EOmAaXUS20yFoyu5b0TWGqJIz79o9X
	QtjjOHZTa6/u9BqtW92OEKrxRyq6Ju9W9TypCL42P5WQIdUVTQYf627ixGCRZlGn
	jd3Bh3kgzHiYyeDd6sXzgSqDrYtNa9VHNHhMU01CiEqkBxkeNtRhXQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkntb1wr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 15:51:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60CEVYsg004464;
	Mon, 12 Jan 2026 15:51:48 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013055.outbound.protection.outlook.com [40.93.201.55])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7hbj8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 15:51:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ssPtIBgbTzVwTB1n4qysgLbjybhBg3lCpyi3wh1FSRaKcSFDbMe29qI1zW9r0LOcNL7NgmmgRIH6khIFSGPKm4pk6iSqfWECEkPqBl25a0PrzUZzfc4BHoaDhRJ1Gs9LJWdQOGAi2Me5fp/i1gexv2OJBV8aAsS4Q5yNHbmW9tGwT/v/UiEcfoH2VL7Mi5FkTohE7Xr9pDMWkBFeb9LwJVd6OwnnuVbpGm3qBBjoxwHtl6Ktikd0j5M1UXOIuYIpAss497vADna1p6Jg4Nn+4tvrxKaSIALC4zJD9DMJ64zYnB3Z4GHQZHVF7l+4LGZmXMV8nxmHdiUOX3lUErJkDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IQQziLfgocnuI48Qt0D/4eBQtJqYjqPQFJuvPqU1QI0=;
 b=eJQvvoxCL0Ia/g33pCwhG0C73n12my4h+jRjT34+mS6RZXk7VIxmnh44i6Y663GYJxBKOz2oRHA6/ARHu4FP9DnWRhLpOqLPCVSpwXvGFruBG+nkFdld0VjpXSqB3irhd0ZGo09nyj3W2MPMXJFeah96/Gfc3HxkEGhVzQdESwxOvL/YG/z/cSK6i9zwDgbMuRyBvhFAj2B9/0+UDQ1QdM1UAbiD7p002RrU7nGlarILi3F0L6LxzwH+d3syoIaS5+aZcyODSniNU7C4CeGNG1hnt6PsUzx0zky+/57JHPmdIyjORXkeitescdrNk9FSvEgGy6b+ca2MWFY2tbqCPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQQziLfgocnuI48Qt0D/4eBQtJqYjqPQFJuvPqU1QI0=;
 b=OBZ2VN0DwRkNxG6jcRaSGFbel7TU8TAJxarrMx/52RyJN/d7sy6pRJNdeRWV6qYoq/CIPkhvrVAMXQP7IvY75UaOALcGPl460mQWw+GLXFIEPS5pFILQOHzGei+mRD1NUJ0Q3R3b0W/xDtciPbNFlWdZoOSJ3B68dca5oLNR66o=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7502.namprd10.prod.outlook.com (2603:10b6:610:163::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 15:51:42 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 15:51:42 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH mm-hotfixes] mm/vma: do not leak memory when .mmap_prepare swaps the file
Date: Mon, 12 Jan 2026 15:51:43 +0000
Message-ID: <20260112155143.661284-1-lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0131.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7502:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b7ee924-777c-44ce-fcc0-08de51f27b0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2aQaQOE8RUZWZSbcIuiFXopPCiSEjS8bL2d5jSM1qTicA6uOSwbEMcDFrloF?=
 =?us-ascii?Q?7Y8ocf2eBlBVj5xKzXZJXqTQQBwkUwuS30TNm2ZfhGJUmta0GA87I0SvULWC?=
 =?us-ascii?Q?0hdNwmYyJKakw/WxWhZjG6MHAuLZ/Kst/NFXSeNFmPnHAcMzgcX12ADaXYsG?=
 =?us-ascii?Q?Qu/LjfgIchc3PHJSYngJHHzkPj0kTW1JYNUWvaXgw1Hdbs/j78BXTYUqAfFx?=
 =?us-ascii?Q?i2jYf8m6EChqRLSUChNUpjWmyfJr1TmvgxQUpb3A7Cv3BgAhC6qYnEx6q55n?=
 =?us-ascii?Q?cOOHFvKoqanpPpp1c3tybHTlSTZ0uSqPSH8g064lj4x5gqaZAGnqk78M9Zo+?=
 =?us-ascii?Q?XlLSPLYdkYE8OUUqFWF+OEORycd+JWNX4ewGnWaXv2VwofRCQzvwJq1Lj71B?=
 =?us-ascii?Q?xS+kJ3syyXV0zT9GUFPxtSAxxUCncMVA28Dl/QatlCG5MM2DGnVsMANKH35L?=
 =?us-ascii?Q?P8nd7LL2VFRUhcLRUEqEPFLbLYq0GdMcPfo3rApVrckNY8TiSBagLumbfru4?=
 =?us-ascii?Q?pnhW2iq0F5A8laHAEa+TqI0yihLMYeTKVW5vNAhhxMmZrMkeBdOeDfPuJTl/?=
 =?us-ascii?Q?fQSXMkfLjZTn/gR9tKBYv7Hmp8PCcSU3SR9SnyQO5gz+N3BB7RhjhE6Aw68s?=
 =?us-ascii?Q?EXOrEWolKQv63aQpTGO82rNfTmCQ/ZJKrTXfeTlLZ4bi6A227OIKt8UBy39s?=
 =?us-ascii?Q?ulvIoYTSShq+v+IcQPry5bsS1/efimD5al7zYmI/NWfHM/Q5mhbmgr5CzPo5?=
 =?us-ascii?Q?GoXysf8UoKYZKz0bsRRD4o9JktyYCnGeO+8qeEhkN13SZkmwIy7O07shZmJB?=
 =?us-ascii?Q?YqxruNl8wSDT6rS4amHslrF0S1nnuDK8x0NQYJKg2+BMm7BZAYYYuX36ox9F?=
 =?us-ascii?Q?En/kblFlji4inSJ9UfDoAV61sYwILeQ9QG5KxBYcu1lPR805uJiTZGXXh1C8?=
 =?us-ascii?Q?z/awJYJpr93csVbf0JF/fxEr6f8h11mehm9gnWpXvrU5P1jd8iPXB9BOJyQF?=
 =?us-ascii?Q?uTPEzTcFzvSXAQ7LnOXSXtjZI3i5sNgTIBgDRKX6b4YW23QNQlTFpkHcKvLA?=
 =?us-ascii?Q?zmHJqFEGWaRAZOAj9fj4FnT3fSC+BROlInx9hdxDPwPWnxeSK+GO/mset2Sa?=
 =?us-ascii?Q?6th/7lDIkz25Oc+10xW5V8SfROrvBw7bxyiq7DEl+OzyLbDzZEKxw1ChjoV0?=
 =?us-ascii?Q?B547dnRwmabm08GoaHzE9hyWyR92BC0Qa3fMc7oeT7IPIa6m7P/zYzaSo+YO?=
 =?us-ascii?Q?2bfmD6PhYe3rv5p7NyoZ/NJg9JlY5ULsTcKdjQXdkE9C3Rdkw4eusVRJFf3k?=
 =?us-ascii?Q?PMVNi7fT4US1vQZkLoWSqQoAsGnruGdLmO6bjg+EmuMNu1mMoXgJKYaDSYqu?=
 =?us-ascii?Q?LYrPQ/mNI1Kur+Rw8TenmUy4IK6eZbcw1NpqB//QFKgUoDQh9NnA50QD5cg9?=
 =?us-ascii?Q?OqUTs5hjQiZGL5pgfeGlXGntLIfFU+TVWLsxPnPHgmcRTzeLjqV0RQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mBjRWdyO0KCf9OPEFCV3XP3JuvYbKBpUIijvMsvkla+SgidDcr6e8Qz+MPTt?=
 =?us-ascii?Q?ZAlyjc45uysik7ZB9j/3FEELW8OY0AxjMSEI+kWkCe0ficrERA2O2SBPJfXK?=
 =?us-ascii?Q?xM/XInMvbsvbB3tzKQ5q1xKQNVqIkiWOejLh7nzlimM/YZ8h/XhjC/J7Vqp2?=
 =?us-ascii?Q?PrecpFvJc+1uM+NVppbzZVoPZv13sP9AQDZHrTl6yx8UTA7XBzbw5x/2pbBM?=
 =?us-ascii?Q?SWktR7HFjiEIsAtgsTFGCyYcpA206JBM+YbxQRwEvZWBv88A1MbpIT/h6pXX?=
 =?us-ascii?Q?4raqdkvu1QSUlhbvjWB3BRGyIm+GeGTOWuiuMVbCOQuVWDG5L7Vd57F3Mt1y?=
 =?us-ascii?Q?R/u1nbvvAZ5EOcY6t0ceU7B7pWE1DBEkhpFt7piilfPjDu1dvmuYHgIqDm4m?=
 =?us-ascii?Q?izE9eCtEzSklZyEfr6KPhtrHJs8dQZmEE746Us9LI7RIxrXf0HbgnGMm5L63?=
 =?us-ascii?Q?fBxHbjuE8tiy8ByjVpbBB5qoY4armM7BxVfko/Gg2YBzolpcnOEQItlRljbV?=
 =?us-ascii?Q?QJZRVzfKeozkPLmP4LCduSF3A7ZpuxCrOyDTxO4XQoVMLcnI60eQNcBqPwZt?=
 =?us-ascii?Q?D9LlUwdZjeTXp+ll3QqE+TmfmgUn2mykxZd0vDuPQzGa/kjgHA0l672oN/xH?=
 =?us-ascii?Q?FE9a50VEbsBrn11+ODLi4mOCiw3MChytZwMaf6Hf4a5v1opiQI/93PJRR2z+?=
 =?us-ascii?Q?RPkMPPaHQ5FbqoxD8EHBqnR/dKkfeDxrhwlMmJ2bcdvn0+P2AyZwAChM4SNK?=
 =?us-ascii?Q?gMkosmgPWDTsoNXwABJ8qE61Rv+VOPMyuONgzaoJwD2XzKb8dPnwtBjjiaV8?=
 =?us-ascii?Q?dzEYrOaEk0CqSp5C6UVRRusp4c3Yh9cfZ+kgrfYmdxloeqeAGU0DVMHvPont?=
 =?us-ascii?Q?sXBBA52WMMbJJahG16N3Y6NzctF0uuH1qTsQNZ1F0XZt665k7s4bm1I8ywZy?=
 =?us-ascii?Q?5NwXFpcaVV1Bg2HK4tMmugkaDOqUu5GySS4tfYKW3+quXwhTZgoTThCEEOSQ?=
 =?us-ascii?Q?OapkiUjo6sUmYAMnZQaYwKJlyCGm8lBOYyGKRq+5gERmLnwXiK1d+hH7vYZN?=
 =?us-ascii?Q?qgXjTFeF0jhXttk7dkML2zpTKkfm8kQ8K5xH+brnJpZTpa6X9k86ctS0ytMV?=
 =?us-ascii?Q?FQkBQaCWKZ4WRqRi0d5NdZzSrQHrDlEApVpBIpP5uZNGPv4FFC6xdHiXS7Yv?=
 =?us-ascii?Q?+ze1XRy3bXjveyD6lSfIeo/g39Ni6lGxCy9lTfKFh2GgMuRbXeYz+utZtbSu?=
 =?us-ascii?Q?BKyIQs/uDtNGu6iuE3jYxWVv3628pTshrH1Yq5usSJy8Rs9U3Aa3ghY8uAYI?=
 =?us-ascii?Q?18u+aPTTzZVtMziaxTtisFMYf+0n77h5GABd589W+48w3q5dx490YhKWYgSM?=
 =?us-ascii?Q?rot835V7JIwVhIkNQdRIUkU8kT204Gdnqk3ZkCW5ocPCoPoKD+vY8MRfpnAY?=
 =?us-ascii?Q?cP4TG8rR3DrMkfsNlpikOxqi1NfFjzHyHbWr+wnqF5ptn9Lh2IfLpQvkRT0U?=
 =?us-ascii?Q?DVGwKyuuSMzlyFQhrItEkqgsu0FifogiEmsZ+9WI95s5ECZr6SCeNLg3f0t9?=
 =?us-ascii?Q?M6evI4fs5kFmdbiVNzPaLRi8TEFIyQanUGLx61uYCrQss5+k7hFJe2DeTj1z?=
 =?us-ascii?Q?hsUpEgbxmKnm12aZkfhqbdheZhJ0+QnkA15PLPzktu9t2R1fNm/F5WWKdm95?=
 =?us-ascii?Q?07dR2AdC4oghOSKtJFeqhPt7mHD8eekUilDB/HgM+hoygghEHs7RIY4RUrn0?=
 =?us-ascii?Q?8YoocT7OSQzN0xLQAPL2rFcSYq/9Ueo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E7KdZgzswhkIedxRVes+5BP/aL00V0YT7qEWbGeZzf5WKIxsNgwMhny1QELQW+vTyrv11A9LBiYB53+B3vKh1fZsBlcJq8fga7tW3kUfUvk4wEXuse4VvlWo4tmcX4cbsuq9mmSZuUnyzhyK3rpvTL1bUnBLZX4uABBTlOob2etOdSspzAzLFo4oe5xJV+s3muD7P34Nvx8fbZPotSKuH+qS/9tjoH5FPrPbgEh5B/JoYJ9AC+AfCXD9aB3ot3ZQAD7Xels23ZRebJwQcBuI0RDLDLAoqVsLw3qpUs5Tl5WE2WhUm/e+aNOZ3BMxSZtP47BeITnQWLsdDRU2hSXCiF4PG7BugkRnwH69wVAR1CULArWtTFQvlgoFC3CQYy7ZPLUVWdIt1JYrBrIyfc6mGbwumzg+EnhQCybFqOX/uvakGboOSK37v4xySOE8pVaF1/2Hl+P324gNFcIuo7nEhm6eqFVu3op5hs5zb5998pPg5TZq/GAygXwhyW7iBmy4xsCC2RHc1HAtmO5QKbYZXHfMJIMqpnedS6AdLWBh1G1+R5amDGTt4rIPEKl6abiNNcif+E3p2pFU1Nz+saUgLCLXQ5CR78mjgySV0Cia2E8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b7ee924-777c-44ce-fcc0-08de51f27b0e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 15:51:42.2856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dcsj2r4xYPGg9sClQlTfRPp0ciZYrO+EQmzRohYC7Zugt7a1a4/pLKW9NdcaDQ+jpnM9pENCDOMJLkip3qs0ins5hDucF8SzMSpV9fJqHQc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7502
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-12_04,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601120129
X-Proofpoint-GUID: fZqHLNJwiDRY4ueTqAbrglWkVS01ZSd-
X-Proofpoint-ORIG-GUID: fZqHLNJwiDRY4ueTqAbrglWkVS01ZSd-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDEzMCBTYWx0ZWRfX6J5jEtTCHhCo
 ToSCp9HeE+8cdecXobs7kQrTvTVsi05Sj2xJyR+CGpfaNlv8/an5R1gGxsx2Uh7lFM0GtapTAhs
 NqE0wSAjA+D4BiGvGKrB0G7b+IOOAezJ2VEKOh5r2X8TuzE6ctqXYCtAh1+VbNU6VpFS9bTqL5h
 DKKJQWbrqmBpLI1Oy4xuCAn2pMizwU5nMrJ34A0H/P1h3nSVhQzKVwYnSCE6tsZdCKrGMyB1DVY
 60V5LiBa9SQLgCrCYRpTQUqUsAHaYr0i+H3ro/kyyeQb76i5uZnHo3jAFrq7PirS+1QaATho/tC
 Wa3luIoYHAosBbc/8R1Bogb8oOkMWHWUvPSqv+/s7wQLcLGGqK7/2/NhkGEGj+7lfLYSpLuqQ8D
 ft4HyfOjeNg8uxvm37Y4CGeHx7tlMcAbo3Yw8TjnKyoQe4u+Kiz1rnw2AT8Z9KricrvMqn5uGjS
 iGh0zdx3813RLc3YPekhSQvBaXS3X3+HBhgQZnYA=
X-Authority-Analysis: v=2.4 cv=fIc0HJae c=1 sm=1 tr=0 ts=69651895 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8
 a=yPCof4ZbAAAA:8 a=hSkVLCK3AAAA:8 a=sCk8ghL2F9iQDLh0oiQA:9
 a=cQPPKAXgyycSBL8etih5:22 cc=ntf awl=host:12110
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0CE10100011
X-Rspam-User: 
X-Stat-Signature: jzuudh5ob14nomwunmpqmidss7iu6gzg
X-HE-Tag: 1768233113-905774
X-HE-Meta: U2FsdGVkX19UMo/hLgX5nEGAVDu5p2qt+kHj3yDKwhvmMaYIdhUNFJacsEKbkv/ZaNjmTMBWaZrQdXrFsBB09KigOZoJKZk4njjkF2bcLPP9K/yxCaSRBJPFAlZLRk3hK51vuXYIGPQV0f4BBlj+RG/EJG4OSePiz9Wu8d3y30xALisd0QZyrnj6Ojd3gnhMnMnykV8M2ERRFspm3kU62rtId4Dpu6+TeOlHUnw5trlZtpXnYGCUhoAzqTSvN7N7LL6LCtUOfg8nQk0/irq0hXt0b0opsb93hbexplPSj8AeRfF0FuTsbldoNecmkU+UDOuZnnXUzhC06YLJt7/WrzcGOeBb8/vxuW9oYRHq6Pd4KtTttvry8bGeAP7zOXVci4axRy2soF2HBEGBoha82ZCSspV8tpvhGm8dQIRcE3uMMb6MGlpOcNylz2DAzuLIHAmj8FBTr4dyq6gMpcUZB63SatAkIoPAOeMvdo1o0vQPP4hrAw5fU45qYGeYDEjB1wI6LDtCN5xJsmdVnNwf5995jXYP17g3RYajnaAfsc19ahUz3uWN99wP70m8xkFXt6nMl6S8Qsyia2rVEXtFy11jojyUhg4nC5eP+5KGZikPOwAQdv5cfJaejQGk5X0TJ76fG6yHkALLm9n5JQkn8vt5vKb0ohWYW4fIQidwYSq7DGbP3yGlXBsMNChoTWP+7gTwsSvRloPgU7zfTKNfiNtDxLmU5IDO3SXXh+lh9EEB16432zzQn6ckU10WzXUR/W+Q5Y/CUA1RxWGcB8tVoBPUx/y02zuGe05Ne7i8bHsJcQqXmoSo6N0+BXZHb44t9HC+v3B1c1XjX0663uh8supqZrqSkHRRCSF+wBeZsse8ngi9Y0zFLHIEIzLW8vTRz6SQEDQolkLCMBoTlgp+a9DntiyV6fRzmvQSd7ntFuGgLNcuXOYWLiBmoKXKibGLBvR6/iR/T3xiOfBnVyb
 EMBQNP0B
 RNHe8vNbvnJV7gKO5Wbs5ekVUHWF+RYe93GaCdC7KU0wWFmVvEbwgMQDp5DCs8cI0IIQ5drUmG9zVwf/iPvQKN9WtL3EofKDQQe22ZzDP7GbKQh4B1LTyvo8x6uC4BK8akbVBaYbMEflVFbC+Yl6yyJzeCy+CqK1oku3QMBQo6kK7fayMbanAL8Lw3/r96nQeAqcjzvGnO+Ll5RPQwz22qxAW5sM1oiJwhTTn4hRnYe2gMZZel/NAm4G0fl48n0i1E35xwenUvV/e9Ye58Uda+a7vfbTyNTEOv4D1wumEKg+M3U5ngBrlHoGDiiJNBWEVYUix+SvE/G+oUFnk1mO1zvAkfKihZ5ct4dmIjCf90SSQQvdAwl6IC9j2FhnUudYyjksaPAgtA7B3oQA2MCzNBdt9RVUHJxYtTYzZvN7hKXjwPM2lLi4KfJOBQruhS8zYSbOSA464Jk7xLUZxFpBFurZoiuTau4t9G75FLOfEaVhFgkJToH7FYYGckYgwvHXUuJkG1WdqdrI2y/geaTp7C+jm2kTr1Klpwv3XyYFr89pGq/7chCT3GKC39DOHLO/vCNjJKtROctoZXgi3osP0EQPHgdwnnoIGkRJRPG+goWTYLN8LN0uHbNrn1jLTkmVFZXxDtM66EKt33Gxkq4HdtkIwZ+dqxpbxaQDSp8BNpOg1GfWC2u/eXwMg+EuQrsPlMmCjHgtijb3al+9UKKUg87RKfrhMwXDXFMEjvz/g6MD//2dyZSD4P3Uend68nSiLbcYf9G5UTjX8pwz+E2Oj0kmO5LSMjL3umHic
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current implementation of mmap() is set up such that a struct file
object is obtained for the input fd in ksys_mmap_pgoff() via fget(), and
its reference count decremented at the end of the function via. fput().

If a merge can be achieved, we are fine to simply decrement the refcount
on the file. Otherwise, in __mmap_new_file_vma(), we increment the
reference count on the file via get_file() such that the fput() in
ksys_mmap_pgoff() does not free the now-referenced file object.

The introduction of the f_op->mmap_prepare hook changes things, as it
becomes possible for a driver to replace the file object right at the
beginning of the mmap operation.

The current implementation is buggy if this happens because it
unconditionally calls get_file() on the mapping's file whether or not it
was replaced (and thus whether or not its reference count will be
decremented at the end of ksys_mmap_pgoff()).

This results in a memory leak, and was exposed in commit ab04945f91bc ("mm:
update mem char driver to use mmap_prepare").

This patch solves the problem by explicitly tracking whether we actually
need to call get_file() on the file or not, and only doing so if required.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Fixes: ab04945f91bc ("mm: update mem char driver to use mmap_prepare")
Reported-by: syzbot+bf5de69ebb4bdf86f59f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6964a92b.050a0220.eaf7.008a.GAE@google.com/
---
 mm/vma.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 5fdf38325b0e..3dbe414eff89 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -37,6 +37,8 @@ struct mmap_state {
 	bool check_ksm_early :1;
 	/* If we map new, hold the file rmap lock on mapping. */
 	bool hold_file_rmap_lock :1;
+	/* If .mmap_prepare changed the file, we don't need to pin. */
+	bool file_doesnt_need_get :1;
 };

 #define MMAP_STATE(name, mm_, vmi_, addr_, len_, pgoff_, vm_flags_, file_) \
@@ -2450,7 +2452,9 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	struct vma_iterator *vmi = map->vmi;
 	int error;

-	vma->vm_file = get_file(map->file);
+	vma->vm_file = map->file;
+	if (!map->file_doesnt_need_get)
+		get_file(map->file);

 	if (!map->file->f_op->mmap)
 		return 0;
@@ -2638,7 +2642,10 @@ static int call_mmap_prepare(struct mmap_state *map,

 	/* Update fields permitted to be changed. */
 	map->pgoff = desc->pgoff;
-	map->file = desc->vm_file;
+	if (desc->vm_file != map->file) {
+		map->file_doesnt_need_get = true;
+		map->file = desc->vm_file;
+	}
 	map->vm_flags = desc->vm_flags;
 	map->page_prot = desc->page_prot;
 	/* User-defined fields. */
--
2.52.0

