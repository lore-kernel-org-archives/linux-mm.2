Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A001CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 19:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9785801B7; Tue, 28 Oct 2025 15:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6EFC80199; Tue, 28 Oct 2025 15:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5D8C801B7; Tue, 28 Oct 2025 15:13:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C416280199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 15:13:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5CD084862F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:13:56 +0000 (UTC)
X-FDA: 84048472872.22.993CB32
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id E48DB80011
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:13:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=I+QwcC7S;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WwoU1cVl;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761678833; a=rsa-sha256;
	cv=pass;
	b=3YmOwpaflDMK2d22hmL4WSlDuihK3ucpVf9Nl4t8g89XSzMtexkGYR0gBlOVqZCJ5yycAm
	MOvqFVM/kqUflq6onR6MeEiAfTFo8ewS2406GpP4FmD+tddwmcOCCG3GpzJC6FVowJNKH3
	8Ozkky6y5J5sjxy6pgD+8gijywzyr5M=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=I+QwcC7S;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WwoU1cVl;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761678833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nukCrEA46m9igPwGWCUytDZgKFVhd5a87xPJggVQWWM=;
	b=MdNKeObeA2gfn0IS3tU6UgcGFbttYRzzFIqMVk/14I01MdQmBWB2r38d7faVXytKKkft/x
	rICxmWAZjdnI5Yu5++48gzowQjJ+bT0cPcPDcqiTMxztpoTukrHFcdcVC/ncSoA0XZ78I2
	HKML79DAWJl6k5putR2Kr1XioY+6YAU=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SHgt0t024399;
	Tue, 28 Oct 2025 19:13:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=nukCrEA46m9igPwGWC
	UytDZgKFVhd5a87xPJggVQWWM=; b=I+QwcC7S8/LPzKLtxGtHt7IMV+JPzueln7
	j48IqLEgwLrHcTeZ8C/AGR6PEUERU54V5pOQF6amy/Yy0xQWgxXCcQxV1UHD9kb2
	16fgwBdt5MwDhghy5E2lY9umWhNcJE3MF2yVUx748vEdaJuCfYr26UnRys8LW3gM
	GjYhYN/PdIU/UIfHb/JeypigEskL/BZ+6enkHbp11tMWjeTyDNMklTJKOb8PejfC
	1iHUBbp7MFfesNIiSqWTDlGphcqWXHW2fBpgGxDO2mxEzkvK7MhrvAwN9IiB6c5e
	a5g4y46u1sEAT638mqGQEo8bk23Ui1Z/MrmKFsgd+ZHo5jCEm9Zg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a2357mf62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 19:13:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59SJ5vTZ024898;
	Tue, 28 Oct 2025 19:13:42 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012051.outbound.protection.outlook.com [40.107.209.51])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n08vjkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 19:13:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yPSPEkpTdhSmHlgCM8mbFi01r6op++yBvpSdj1c81ZjQzzBkj0rk1nQnY1/pVspzHkWMl/A4Yy7egzwJNuDY+oGmiyKLaml5HLYfPwKcxexQehaKCErTFhw+DeicQdyj+jNJCzAdh+dNLA9DTFigc8gf6MVJa0lwP5pm2GNQecVtR7dGnHnt345i6ucwqXtnmF3xjhUSckigfGwGGfXo/Gx6p/gysXIznrlQ4eyPkW5g8g0eEaI37qxv86Ft3CnSlv32g5P800DJIAn/6MhtdLUSWXxIQcaV6vBWya4YwUFE9GmSl9+0RsjdX6tS97pTvzMkQNruIfFIC5VPLcJfzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nukCrEA46m9igPwGWCUytDZgKFVhd5a87xPJggVQWWM=;
 b=OeFaqkpZo8qqX4/gYHpN+kljxmrCsFKLrSsdKQpcbnAEXFRf41rnOjB1puKFRQuZDJbbvL7n3/cdnm9IaZ4E4nfthVURJ09FNfrYCFF6niOo2hhsq9HZzNs5JJQcPlh5RRnxLbj+8ftzv9z6TffjKUhkTNYlN+rtZU2xL4NEhv2LTBkfH4vcMjjCKRS3eYdUwiOP+tXtUnEUhVBfjOYf99fia5HT4QBUIlIoaCiFamTBRSuJKfE0Yl7nJ3u7LYLmATU7DiRMUfIBbWEKfU9gmfkAJWW4Q3Q65y+z2yLcgTwRB8ZgackdQSsdDJONMUkx+buNBuETcJWJgSCZs0FWHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nukCrEA46m9igPwGWCUytDZgKFVhd5a87xPJggVQWWM=;
 b=WwoU1cVlWK9FqsFYXHgMD0g3SzgCAnoTQNJjvsnoKv//a6PFNKX+7zNzqaWhEyIQK3qqkIDaBGE7V047PhVZkXOB9Vb0/aF4KZeu7E0nfZc5sJvYlt+p3zGOnYfGMumOg1me87YefJdDDOz48Z7tjRh8x3qWgX4vs7DokMvdzG8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB8084.namprd10.prod.outlook.com (2603:10b6:408:282::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Tue, 28 Oct
 2025 19:13:39 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Tue, 28 Oct 2025
 19:13:39 +0000
Date: Tue, 28 Oct 2025 19:13:37 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Israel Batista <linux@israelbatista.dev.br>
Cc: David Hildenbrand <david@redhat.com>, Omar Sandoval <osandov@osandov.com>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-debuggers@vger.kernel.org
Subject: Re: [PATCH] mm: Convert memory block states (MEM_*) macros to enum
Message-ID: <02847a0f-600f-4cad-b7e3-371fa98049ed@lucifer.local>
References: <20251026162156.12141-1-linux@israelbatista.dev.br>
 <811fd675-b231-45e4-b9d5-636fe63bde6b@redhat.com>
 <aP-2x314BKks2_N9@telecaster>
 <3d3bfa52-3e13-4d23-8ef7-6cb8b1ab7d79@lucifer.local>
 <aaff172e-8fdd-4ff3-8161-1c7afb1f3e64@israelbatista.dev.br>
 <3873b85d-a8c8-472b-82e1-2751c6fef3b0@lucifer.local>
 <7a46f3cf-3256-4179-8ac6-25223908480c@israelbatista.dev.br>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a46f3cf-3256-4179-8ac6-25223908480c@israelbatista.dev.br>
X-ClientProxiedBy: LO4P123CA0679.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB8084:EE_
X-MS-Office365-Filtering-Correlation-Id: a9dc246b-b778-45a2-c20b-08de16561a54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3APLRZJnVa/Zf2BDNADdlPbrY69rnFzYlwFx2a8Acs7KUF1f0N5+ITK+UQjw?=
 =?us-ascii?Q?33cLBNlu5wPX1KQ4igvyWw5KdiyfPr9bHXMHjIK+zHftRaMJW88+QHinZF4r?=
 =?us-ascii?Q?beZqXLp4IjlnSfosabJ9bW8zO8jwJnFJeOCjslR/Orn9U8fDKBCuLcCPjw5O?=
 =?us-ascii?Q?VvZXp1jJX+uBvGXl8WF8zWD/HxjKImO1ReopBZTmuQuUj2fUiDiqVghkexql?=
 =?us-ascii?Q?18bce54tIG9UJfLfsyI/ht0vY6NV4J9eB8a2VEpW2gn8VbXBCWdnLX7khMOW?=
 =?us-ascii?Q?0F8eR7QgzUS06n9+1UZo6oiskt2X/81KzmjxHe8CSuQNTfURf8Tje0czSZKZ?=
 =?us-ascii?Q?ODtsnWsC6u75CPYIsGsktjUwRlLXnoy/4Iu7j9EWBh9fFLsV0oqlodhqTpZ0?=
 =?us-ascii?Q?WRtzYADSXaGz4BpjRMgTym7KshgJmmqFzW0MksDiIBddgZjvzIvZv05p6qKv?=
 =?us-ascii?Q?n2QYo/JbCqRF9IsOdAU1REw7SSLM4rnSyOhxXUOU8Nq2KBCw1VSw19MX2dxw?=
 =?us-ascii?Q?xAkl0VlV8fvjQm61KR8BUaM37fiA9Ym1+RvecRcSZF7Sp+TJupEBmAFLxo94?=
 =?us-ascii?Q?IIw7rccYnCDMLk+vOBw24u3Vr4QTiEOUpzoSXuTUlPGcXvdgAldiC+T0moUZ?=
 =?us-ascii?Q?PUqBxvBnYFHtqrCBwUFuZsVetr5IZ+EqH/mnvQsG+M4CUlEtBW1sEao1TVUA?=
 =?us-ascii?Q?eY0FkwpWIZKUZEYyUsqu7T+OEcMNi/H8sbocy1p0Hk4Kso0pdG3BtvZufh7Y?=
 =?us-ascii?Q?LE11Gji/RcVe9lBMSprthiS+qD7XwT7jbEeYAR3+WcW6oxGOzdRBBPEgAnZi?=
 =?us-ascii?Q?xwZwHXGImTMEMBAGtnF72Zm1UM4vJnZ5gABTHgKTYtuUs6DmmRqFSfHni1HC?=
 =?us-ascii?Q?7Cj191xtA1WgdzNrCfKrxzeYS8BEdUVB7qj+TF68oyLLvOvUeRTtleafwZnX?=
 =?us-ascii?Q?oyyeZckO1HLZUuhnWI7NXTTmZKiqkNKYVRKdgkk5Ubv6vxFT/AlLdqvR8yFr?=
 =?us-ascii?Q?IbiDlnNRhqkaLorEo/F4d6hPtO1OnT4izzZiqb9NxsiQcAaQ8X6AVXc5YjOn?=
 =?us-ascii?Q?nqUsBdTmBOXbw1kUQKEJIraWCICKAIQWgjFLaBR1d+Qag9G8MBn7l81fwr8G?=
 =?us-ascii?Q?Cx4kNxRvhogdJ0I9Pf8R+3T+3sv16VH6O95zZSiXcVa9/5gqVzR2h6TW7Hny?=
 =?us-ascii?Q?RB6C3Cia9gtEviw1lj6xW1oawDQ4LWz/ly04cefnz/eW9lo2AZ1YSWGJnFnN?=
 =?us-ascii?Q?dFVxm0gLCXV/fxyptQrU7znswyuXGVxwsJpThoid/0nWrL/SxyV27ekfaAP/?=
 =?us-ascii?Q?TgLsSUxroyIVHFIcgEUjvbb1U90jkwpjRFn937FhUJOap4svYPC57iPZ6/P5?=
 =?us-ascii?Q?FxxNuTmO6jPrfIqb7RdhyWPKBlcR52fO1QZp/jVvOHr+bZqrsINdgMTplcPF?=
 =?us-ascii?Q?RLS9E1cKVXQWi9fbwVYjZVaai7p86uAkFd5gvGsUQ2KfBwb2WcT7zw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vka8530OJ+Qp4458ZsknLJ96gwiH26gk+tiVL1GMyduRqbWYhlrE6oiPBueK?=
 =?us-ascii?Q?fdBWrv3rlLfDO6foo6uBK/5Ep0S1eRicXgrV7CnA0MKkkj4yZPZXfCEnZxHC?=
 =?us-ascii?Q?Xdyqd5Hp5+pN4Js+/8NfPSbQbb//MEtvT1lj5LXnRU4bwRaejNyBnrnXOuSX?=
 =?us-ascii?Q?U7qcNpvpYcqQnIJmcef8qKwfGLnuZa69PifQ4SiHNVLaWVr2jg84a8B6TzHO?=
 =?us-ascii?Q?vCBmxd9pWd2ryRvnXuLsrSVDGUfqXYRUx3zqDwTuAxCQbiqkydElBthPFOmR?=
 =?us-ascii?Q?I6k276PMLm2W7sz21U38Izaghsi6nsZt3woNOB9W+/fszPUDOu6NkD3w2mWp?=
 =?us-ascii?Q?B662ucpf+8QBE3pkN1G5DEPNADGknNngWLVh9hv2wvTO3HKVfWl88Nu2pmR4?=
 =?us-ascii?Q?18BKjewpHVpc+WJ8FJfFljWd8+u5E5EjAnRUjogk95hAISx1W9DMvB/g+7EB?=
 =?us-ascii?Q?XBrf+Ywf27MrvKTMc56d2Y4BYaRguqKiWkIIcXaKWMDfbibkgIBvuNNb7zBS?=
 =?us-ascii?Q?pqjKDyAj4zPtZy56AvGbPG94lmgwgO3wPl1mm+yW/pT4PZsuX+permqYziRD?=
 =?us-ascii?Q?fGkOKUBOtqwhoWMl6hktHTReMQxdCsPmcx/ENFY2mFlh6m0buCdflLOkkYb8?=
 =?us-ascii?Q?8nPK4Jaggln7qJPzXW/lPECkftYFdgjkMX2AgC7Gh12izx80O1QQElApun14?=
 =?us-ascii?Q?feP/yw6pLC7BxMgZrs1jg17v4grOIhnXzyxa1v9WqEI9/QvHZTqFhdZwbNAj?=
 =?us-ascii?Q?eTR8a2GMe757uVv569TLFjd9ZNy8gH/G1Rmynskg5Pwa9HIq61/JA19mRfnV?=
 =?us-ascii?Q?9vJj4bu1GxCgQVuKmqdrgyxIC9JAHCiQNKuByW5OYKYhqt6rhVdAArdP92q0?=
 =?us-ascii?Q?C43BHJZ0fQBUoWz25zvKtzUo7p2ZNukVaPwxx2CjDBSKGe0l0Q1hXYFEAVzz?=
 =?us-ascii?Q?yJVBGX2TZfuRFaYMhMWO5mS0K8mTovyW/mmlM7VIlGjHH//NOvRLkXLHtMHz?=
 =?us-ascii?Q?gxoFU1C3mQYa45CmnSS4S61UCawS0PmdsixR+diRPKHX11iX+d6IS2JqJbAs?=
 =?us-ascii?Q?a8MiWN92YEw6mz7eGAYHcPiaG+VhbJAdCuU8QeuXA6eG87usiRclDc5QuBZ/?=
 =?us-ascii?Q?oMAEXg8QHQ0wEpcbn6EiUvdIhZ7/dD6ZFQH+iHZgVq1AuiWSpc03ds1HZ1uC?=
 =?us-ascii?Q?Zw6sd+IK59wnZIr25QbwSeltq7vrZPMspgHbHXGxeWATMhIxWqSf1dqGCcan?=
 =?us-ascii?Q?OtD/EeOjObYfDygGvB/ueVSh7iLJ+En4TN3TAfdWKOgjJomy945u4TTEDipH?=
 =?us-ascii?Q?FYzHSmZySBQBRWpqUNt0sS7YsCrbYtl8ho41357YxtGLo7cNgCSQ4siTEGOl?=
 =?us-ascii?Q?MuZigpT8ki8XTC5Mo4Zo94CBmzyqYusd5KuuAUmC7uX48k7PKUOtAz7NVt49?=
 =?us-ascii?Q?y0XxB3xzQ+t/OzGy8n1bJQQVre+9Wgy5OP0j+Hp5XXayMHV3qpPqzGXa6Y9s?=
 =?us-ascii?Q?+6F4zMGSFZXODCGnTzCGOiHOB5dyM769XKFZWhb2BpzAlcmxX2EjyMGs+AGP?=
 =?us-ascii?Q?x1yskMjuNAZLHA42B0MNp4I8YUhZQZ6gKqe3zOPv+odIyrnleYIwvRdbntOQ?=
 =?us-ascii?Q?Ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CTU9xY23GwauyWv6RlrS65DHLSALep59+1keoIwPg+1VA3PbQW/4VbAf2Cw18vde3VMKcL9vFOcvkf5q5m2K9GELmh//cpAKm/rr3Qq/mTqsrIZQw8DC3kDYfw91gU8b8t6Faix6Q6aiavN4GhBvNiiFWonVGyJ6weKavqkyY9rRmyfp4+ZlKzZ7Z+V7bQllPVdT77QNtk3BOjdA/rbb9XYxzyUn5kldxa6A3ItwY4j+S1FrmBpvj/7h1qIZSgneS3CqoIqFC2hn7blsnD3v6it7ubviLBIQYY8N7kYatLg3oHcFXefqBhA0DJC9kAxgHctK/Nz9TNAXx1XuuAH+ZadxGqrLSal0kFyL3OMWFGvjyXOt2BQ9v9T58shH3HL0nrDYFbF2WEqEoAYcEvL+72mSDO2rLYr95o2n/CHTe+yhxpkweqZZ00hSZSSy6FR4wAf1jqsLDceHNczqUb3NOebobgbSayVmk9uWo+uVgWgWl+qF5DLtDq3CsRCdxDZLdrvCZvDhu05FpN+Q0RuWl0Kpz4U0uUeXhLAVNUXkSOxn6uJrfobSpyG9hKNQUvR6vb5UOmVsEa6YxT2dFQQciCNkfJaA2h4YroVbprvwOWs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9dc246b-b778-45a2-c20b-08de16561a54
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 19:13:39.8481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EKFgYVQXsdSzxBKTjpYWK0Zg5aQVUQvLvT/Zq+C+WNIdJme/IKWaDogA3YsrNA/efFZZ5ngcEM0CSibfmh4utLbth4B2Z0dVWHq/zPJn68k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8084
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_07,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=751 adultscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510280161
X-Authority-Analysis: v=2.4 cv=Bt2QAIX5 c=1 sm=1 tr=0 ts=690115e6 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=5A_cs92ztgfi5k0fr8oA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: TAns9gx--paXT1b5WVUQP6w0el2ts5g-
X-Proofpoint-ORIG-GUID: TAns9gx--paXT1b5WVUQP6w0el2ts5g-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1NCBTYWx0ZWRfXzI580rBM+2JQ
 jeqq4cBCQoj5o4WpoRSkKaRzBIqfmQQxGNMK8CS5fgEfrmtitiBmuBDLpq8kMcTu8a9nGyUapVQ
 o7RDek2/21rNC9Tn6XjyY5VJS7OesLc5hjt/A/ryX4vSKCiI1TvlzJvmkXcpY/uitu0K9pS8dqY
 7cwYFNleX47Wk3kQpzWbxuV4nsDvxyNii308BYjPq+wwDaxa5vXl0o6TUyhRr63B7hYbV4KFceJ
 PxO4iGjB1d/fVFj4C/TcpCSPk+8XdH8UTp/vGWC3PJOf8IzEoKhtCFIxRTAesrL5TEHBmH4dnAs
 cXHXRR68ltmM+HwSIw5sWxx0QeITeVwLVoWNv0LTF2EwNIUwtk/e4x7wOE6moixENrD/IiNmL2C
 F5grw9S5sw4aFK6jYrhDQmkBPDgpDg==
X-Stat-Signature: cn77bnnniqeqbxft7s9k4dmf9np89ofe
X-Rspamd-Queue-Id: E48DB80011
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761678832-53724
X-HE-Meta: U2FsdGVkX1+sgrhW1gFMbzzUyce0dEeq6eaVfoYGnZeeK8nP6y5uBeUhx0bu0lJQu0c5SQn82Y25oCfnjYcUzCNvufZYZ5TZF0NlzDpWLIAKZ7Xh5LrzaLBkPQuQQdFGQYZclN326rpai2T1mJ4rR18pIQIgI+PTSeziIJjII1q38oM4rSYBxYNsEwFSVH3Z/RH5nSGHY068bBMPPeRgHfHPHKg1kz2OpBvVCrCdf5CuGocPUZrYudoIcvRUsPitWEpDk1+i1BjzrZWmFxnWbI36dOlnsqE7oPTfW61+00a7FCpgWxbJ14zKENB9APn33X86qifsP8hPOULqMiLXE4CG6GM4iOsGs05852ZTaJkIscNpvoax14I9bsqAd/tw6ady35BG7AiHXATURK4yVOIKgSeb6373XfapKfHgO+MFuF+b0E0nQWehbqosKW2R8/hsMKglL0Ep3xDGNJLOfRkllJ/1sDbqMzIMnbcB0ynBkvY2e7g/rb/u0EAYiCcfcp5eW6Nu2KtlKLT2t4SxXbg1G+IzpW3j7E3Gsr49eKGj+kTbHoOKslK/sCRTrKmNrDkEy1QBtQfmAHrey51+gLmuiUyc6XazTgVLrQT/WSc2fRNh/WSgSfwLzz31X6duC/22CLwr+guxiZMJJD4/CAR+kSgo/JVtS435IkCDYxrixmU2COUXl2cR8+Wb4vmreu0uHywFRrFVvD6zLX2DjjiYCMxlZlQFRWgNc0fzzQ/3fkixjidQZR1FoxjiEwEUHoaVOqlXvbC/dydQNHfQwIv5B31f2zpjh3nu+GuNTq4Nzj4rQEP4PdEcAmmvjENz1doMIU8bpn8Ut0URq39SLZUYBoziHpNpP+o6UHv6+lSu7RCIklwot+njut5hv8GJzNOf2FuMUr8Zwi3XK83iQhl+c19tWDtL0bRHdysFAuRfKoUFMXAdk7mZ3bfeItH/IihOCl6luK7+Da/mm8R
 CrAyRjhn
 nN3O0MLgJ87DwnuflglgfCA+bG4EhGjnmxCHhGtbmKrPKhhLss33XTZp+nuZx6C/yHjCzZvVWjhh7Vg3+71rURcUoGKFYlBK6hLps4qWfbVc+7JVgVYpdJAbO43j3lCBUlDYP/I4Ndp/gmujaFXqM8vXysdnN+lQ1TA6LYfNrLdBlRtDsrGS3Z7OI5Qa800nNBu4udaqnHbNTzCHJ2GchsH9dThGhk2pl9qQVVLRan7gIUk79Aea+YNnKWbTCVX/rrRNFAwfes2xbNc0xisA0E2MJ003l7/P6osagRsXYRCKYQzzIU34/G8m0n3JRjYmAp+pg8zIc6WRFiblkeAZkB6ggS4mc6RRdqDUjw4y/3Rwez08DkybMAWQa3BqMQVI30n0S3VY7e2hK77DIoglP9O3evfUi3xWvnT8ptdVjRAEEX0c2Fs4p3APNlIDHLYNHcPdnod4Im+qXThMYSkuzgRGO5bJl6Pumj3WrFZGckHBtwOt80mdxLt3FFcAcZytyyE4uXrPISacof1akH3JD4JPcEff3kJV1Gsy6WC/CuMH/ad/lZlb4W+eKZF5xh14wX7gatlakx/bglm2TaRYU76giVgF2z62CWEURvBWO47vVIEJdh4Qh6YxOgKMTt6q19DHHm+8T4XOZwkbrWbbuLoFP1RahFAj8QZcyGm9gODkwX/ATSlnPZEJ2JA1FKVM0zh/I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 07:06:00PM +0000, Israel Batista wrote:
>
>
> On 10/28/25 13:34, Lorenzo Stoakes wrote:
> > On Mon, Oct 27, 2025 at 11:53:57PM +0000, Israel Batista wrote:
> > >
> > >
> > > On 10/27/25 16:46, Lorenzo Stoakes wrote:
> > >
> > > >
> > > > So why are we naming the type... does drgn require it?
> > > >
> > >
> > > It doesn't need to be named, but as David pointed out, we could find
> > > where these values are being used and replace the type with the proper
> > > enum. I quickly grepped the codebase and it seems doable, I'm probably
> > > adding these changes to the next version of this patch since there are
> > > some things to fix anyway.
> >
> > I mean we're getting a little out of scope here but fine, if these are not
> > in fact used as flags, I don't mind, just remove the silly 1 << x values
> > while you do it.
>
> Could you also point me to what tree is preferred to base the patches
> for the mm subsystem, please? There are differences between linux-next
> and the current version of mainline regarding these values.
> (MEM_PREPARE_OFFLINE and MEM_FINISH_OFFLINE are being removed on
> linux-next).
>
> So I would appreciate if you could indicate what tree is the best to
> base my changes, as I'm not that familiar with this subsystem.

Sure it's not at all obvious atm (mea culpa mm :)

So the tree is at https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/

The best branch is mm-new, however this is the 'crazy' branch where _every
ongoing series_ that isn't found to be broken is taken as a testing ground and
base point for development to avoid conflicts.

I tend to base all my series on mm-new, as series must apply against it to be
taken there of course (though Andrew may resolve simpler conflicts).

The more stable ground (despite the name) is mm-unstable, which is everything
that has sat in mm-new long enough to be likely to be sent to Linus for the next
release, and it's mm-unstable that gets set to linux-next.

_Generally speaking_ your series should apply against both. If it doesn't, I'd
base it on mm-new.

So in general TL;DR mm-new is the way to go.

Cheers, Lorenzo

