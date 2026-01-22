Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11D11C44508
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 01:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A0E06B0093; Wed, 21 Jan 2026 20:24:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6791B6B009B; Wed, 21 Jan 2026 20:24:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 526DA6B009D; Wed, 21 Jan 2026 20:24:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3E9936B009B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 20:24:54 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E95191A1416
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 01:24:53 +0000 (UTC)
X-FDA: 84357855666.10.590E039
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 82D581A000D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 01:24:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="B+7KF/i/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pZWZbRH1;
	spf=pass (imf19.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769045090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4vQVH1MMMPbeGv0o4zaocP0Wuz2yQDoSNhIcfgxUWb0=;
	b=PaoAAKqMEgj7UkOcWMDvahnLu4zzijIgDFOQ1LshkXSilxrv8EYEAz+/9nFyklf17kVFlo
	anS5E220jy4s2bduHUflu9GKG8HMI+90LphpYxAolx7WcNqcrGhXCfdHfVsYPTUU59ddFP
	Ob5j9Qq42FJEjZJnBL2YLnJajUncXz0=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="B+7KF/i/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pZWZbRH1;
	spf=pass (imf19.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769045090; a=rsa-sha256;
	cv=pass;
	b=g19sd51ca1vlNV1yZc/s3ZbShOhnMDknUHz6whl1Ud2qhbDqyssBeiUN1Bd34N0MXNyGEt
	geWM+FNwNHwrE04XCnQOKGgK9UWBG3/1tDk9YVFQ7eQASH6Dowu6i55DbxhGYMKYUIjpDq
	SgWS3xpi9ivOddO/eCttmo+3cqWpQ5U=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LM7KDF3429899;
	Thu, 22 Jan 2026 01:24:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4vQVH1MMMPbeGv0o4z
	aocP0Wuz2yQDoSNhIcfgxUWb0=; b=B+7KF/i/YqZm/bw3eHYl/bi9KfGy8LV/2h
	yNOR5vhes7Pm7IdyBBUzxFiqR0+dTOf7rJs96DVuEqmJ+9Y4qgEscS6TmRG0X1nX
	96jzUxdEFSbfauZiYQZEqrzTeBUFKJ08vJiQtu7nRmz+uHQumUYq7BqwTWZQhtyb
	MWuJ0cWiasI0rQgsfSd7UnnTAFmhOUikGeBgBqmJfWjErM4v2PMCScjg0Wr5pgSi
	dp0gOcyRDrYy7d2JdWXbX4wVy19n4KoaPm6w6mUFuLnEaHvURP8HGp9PTy0wEKJo
	TGka7kkuJEbrkvWSIhYCR7BtPXw7vY7hC3riHmy+BslNcaIAa14A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2a5pxh9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 01:24:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LNFotC038266;
	Thu, 22 Jan 2026 01:24:46 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010037.outbound.protection.outlook.com [52.101.201.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vc3m41-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 01:24:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vE6pgw7P/9trnwRdNiQ0L+gi5szA4u6tljqY1lthUu8j6CN7cMV7Xc0+x7D01yOeObzzCun7Ss06gOQMMBYCVc2WDDXkIDD8kHwrJHt1yYIttFBmBm1C9gYbFhwV9BoGOriJ9gBaOR1ttzlmxNvoCVnRuCo/aW+aBnjYX9cyNspvoIt988vavk9HF2MbhLY1qOjM4tnaB7N1yxGC6t/e0SiVZ1IXALlib5uOaQ+fJiLsg5No/xigMA1Rhr+4SZqHwyRC8vq8oEu9wTkiyoBL1EG0PzmqRWXUYUIdg2PEdV46iRhOobOmvtANZVPdXbCi8nYjUdNviA4eg+AvNLaejg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4vQVH1MMMPbeGv0o4zaocP0Wuz2yQDoSNhIcfgxUWb0=;
 b=h4XH+27VPX59PIeF4GzJQGtOsW0BGHWjrzJuAldRwXWLpOCNwLDrmho0uf52K4bstAMpYbHC/PqAus9F5Xi88jAZyUO5NY069M5rjRXRwIMQNDvSilS5/N9qFPrwvEZT4v+fXpZ7GIW4ADi8yHCQOG8b2KbM1P66adFo1KHEjFA1BamjyX9LusSdJI1ULxXy1tHFyQGJT06MrFoyPhoCzH123WOI2VEgFE89zEzcSNYtUAww9MHe8xHt/pifcTda4hjQ7+pkm8nuEJLLcRMsg/NjrREBxAp41HdtfhYZ34tdwdhH7tKmt4SxxrdPvEOstS0HX3klI3o/pAj9l25BKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4vQVH1MMMPbeGv0o4zaocP0Wuz2yQDoSNhIcfgxUWb0=;
 b=pZWZbRH19zznsPXyteE2FBhxuo9glLqFtclqa1FopdQr/kDrH2R8aruuSLl3bwIGyJAfCgU8YchBz85PIJmfbhiuuL62RH8GAWjLHr/gMRAG3ob5OEgK5nuNH8Jdr5JyL3Vokphjan2RzHEx9QCNw7bNU4P2HVkPQNGnUFuLUMU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH7PR10MB5676.namprd10.prod.outlook.com (2603:10b6:510:130::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 01:24:42 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9542.008; Thu, 22 Jan 2026
 01:24:37 +0000
Date: Thu, 22 Jan 2026 10:24:32 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org
Subject: Re: Possible KCSAN/lockdep issue in -next barns
Message-ID: <aXF8UAEEa5IuIbGr@hyeyoo>
References: <c858b9af-2510-448b-9ab3-058f7b80dd42@paulmck-laptop>
 <aXB68e_DtXsr7OcB@hyeyoo>
 <aXB9hHM3T_Q6KzfA@hyeyoo>
 <55e3dd8f-1b56-4f83-8657-7583175de8f4@paulmck-laptop>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55e3dd8f-1b56-4f83-8657-7583175de8f4@paulmck-laptop>
X-ClientProxiedBy: SE2P216CA0129.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c7::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH7PR10MB5676:EE_
X-MS-Office365-Filtering-Correlation-Id: b3d0e6ac-8091-4586-d0c2-08de595501a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QW1LwJpDpwdctQJGe8mr8nMfPC/U5CequhHsR1twwwtC+4X/LpG/1gi6ObLg?=
 =?us-ascii?Q?DqLkr0kkobMpFe2eaOItAD0TZ1tfZ1rpI4Wx+ledzZ/y3qFvw7Uv/qVecFNn?=
 =?us-ascii?Q?hfy5UpZbpmUnfU9kgHP/wmPRc/WelYOWLk6DfNuaZyR3i0pmoYCq15fgQCZR?=
 =?us-ascii?Q?ntDh83X2lX5oC4usyAsD978pmqcK4Oe845I8kayDOYQT7HmSigYQOTb1N2L9?=
 =?us-ascii?Q?ri4+rxjXSJTfJEXAX5sutZ5N4ML5lOyJGSGROAsAWoCmqMPg4+Z+O2UPcquA?=
 =?us-ascii?Q?AHPjFYFHCj0r9IjiEXlNYYRc5aj3D/j8oagFG3u7EqTm2KBuU+Ah6aBx3FV+?=
 =?us-ascii?Q?tsxMvjMO9oUdbUfpcYRWtKxwyoNGgvfiQU8J0Sm0fqr8k79Cg8nWV7whkQFJ?=
 =?us-ascii?Q?VuD/8g7POx+32c0v4GrVlWXCHxMxMO4VnFr2LxyjuG5zzWhqrrmNqnBkSnXH?=
 =?us-ascii?Q?i7RP9wMfPTFtXxon0rIzGLIVNwd/YB5GHTa1hWoirjVq4ZEUwvaEg38WiPa9?=
 =?us-ascii?Q?oNCibnxQOj+10csBEOkorIfy0mcUNxeUkJN7Y7Lp2ZN54WZUBW6tNe6k/LRg?=
 =?us-ascii?Q?+onpGfTfyc9bUMKBuQTWBl766eSvQmPGdAuWZ4rAxU+QEpRCQuIf/dmm/Bu1?=
 =?us-ascii?Q?PF/YhvuyFUoWm1NLyGFkKdCnV+RF3uKzd4JypM/5p+K3Lvq8KwtO9Vdh65ul?=
 =?us-ascii?Q?NwogprbzhyfgL3Rcq7CZUSVDiAeCWJyeiv/2dDsAitDRE1X7wCJ7htCIRjiw?=
 =?us-ascii?Q?WdjeaDDTRnnR3opMsCsOsfbuFTvlKg931JYWV7+umgGIKLjNfERonfVPJ48R?=
 =?us-ascii?Q?TvhEUJixc2BtXnVIJwHA8kTSDFWnZ294RFPUHAxfdpKTlCwjyuMiBaDJJEKg?=
 =?us-ascii?Q?/TTVysCltjkoNY81Fqh/6vcvQKq8MJIoYbyIn+4OgQKE3IhT2WvWIe9UfVtf?=
 =?us-ascii?Q?cdMl6Bvp8lVoy58zYCs4iHOEv2id7KvwgtIQuy8fbCdQjHGR2d884v8GxiTl?=
 =?us-ascii?Q?/CWXhvjxtNzr136ReSNkp8p88G9E1UIlPtp30MeDfnc7jkY4cIk38orh45/y?=
 =?us-ascii?Q?iMNm0GzzFPeFQuR9yJIEh7XR5A3bF4dK9Rye+xRpJ+4BJOoI1X+a3ry4Dc7V?=
 =?us-ascii?Q?4X7p8znQO293dbun+qZqpKgd1gn4Rsi1xhJDJy6ct4til9shEfi6jX5Bo7Vp?=
 =?us-ascii?Q?z+x9tRPpGvZn3T7W1+0Vv890qQipDRjBJA/wroEFG3rnlKHXxFmYw26l48fk?=
 =?us-ascii?Q?cPFNPhHsXKRa2us+mIR+/X1pZHtSUU1ShgIwLblBzR2i8zAMX/CoTzjYsv4H?=
 =?us-ascii?Q?3lb1S/1JJrTAisBItTtWaj6CD8LnWuwnUiL8VkNYYZoUo32YlNjhOyPtml6F?=
 =?us-ascii?Q?R12gNY3YdhpINi9VGicwkBNeZYmtUG6Q5DKlstlaljc+w7AFgKvbKWeK6Se9?=
 =?us-ascii?Q?5/A8qjxWtx4PgKFBoUyvChAkIMKfkdChXdZWO+bnCUw77N6UZeaQNSVfYjl0?=
 =?us-ascii?Q?TeE8cdQyYqcZU3ZHNYtVEgZbfh8DW9AIw/hHqPD8Uv9i6xiQS/Pi4LpJcEt3?=
 =?us-ascii?Q?4OV9+omkCOua7Hy9070=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rdbtdZzTrIahubLAV+eq16iu2eMappyODA2hxYq9flvsZZq6fJZ9OIggPvV4?=
 =?us-ascii?Q?toyag/1E+5Td3q/2uzE/ZqJuqc6gOX/VF6TVk4AaSTNeB9vqHk30lOA69dvR?=
 =?us-ascii?Q?y0jrrNaPpYuHQ0+pWzZtBt+1/1TtFASy15hSQOTvszPcCRPg+j9VkkO5LTys?=
 =?us-ascii?Q?1ES+saNXlxVOiM0+3OSIf62+DF6WtxYTgSLV5kbuIUqpGg87lmCZ0PRn2VPl?=
 =?us-ascii?Q?J+LU1V7nLs1Qsp7aBxflFuVn8EbWkjiVl7dwJMdDAo8P8ysho+13pANAWgpT?=
 =?us-ascii?Q?tVHLZAPrgzxfHPx19oC5ZlPMrJ2X/g9w0MXc5jcwpkD4lH0oZBygPTfUPlYA?=
 =?us-ascii?Q?xFxgQLGa0Oo9H6h3Va3lfiAue/aC1ewiEjhjH5qMz8WQpk/yVVmQd5ACKgBy?=
 =?us-ascii?Q?D4ulP3HLiKiKPGYWWECFye/RIrEBvHLB3PBpS07YQaMQemuCyHy6y6hr4FCN?=
 =?us-ascii?Q?LB3mS10q8txBCw4tahoH98fUx0C61VSnaRVv9L2MioMNgd4/LaRVFFIteY4M?=
 =?us-ascii?Q?+3ltqrKUeCyLouuXG7g02ZxUVlnX7uivqqRKhdmbpaAAN0+fWn83p/9uhSX3?=
 =?us-ascii?Q?zU+IfzmH7v+DnE1nIj95X1KSljpX28zBxk8Jk7aXSSIAAJwugxvhDPYtcyUl?=
 =?us-ascii?Q?Jw/PGo01rRKuXsdbv3kT+GhLqV0tQE5N32wrVOYsn5Co4QGDKb0Z7n63iYJp?=
 =?us-ascii?Q?g6WhZnCTFM9hjkCoKYK/ueY4NsZtWJWBoWRQGOengYpWKWRzEABu6gQA5kZ0?=
 =?us-ascii?Q?FqZhqZr/oo1KodDSzk6Po1RjwKKhuJ1gIr4d+7MikxSI2SRHKO+xAGaEgN+a?=
 =?us-ascii?Q?JQaDqWSBYVKe01Rt1MT1OPSikZYrCQpPQjG/fVKUZmErh0HSpFRLwizxiFsO?=
 =?us-ascii?Q?09Rd/K8mZbwAtEbbnKHa0Nle3nSXKXHdSNpBK3OZOz+6qWp+mn94R6FFjqWl?=
 =?us-ascii?Q?8RfnamTLhk9zRPpipsIf3/yQFbM7xxGFVglyyGPQ4Y5OnuYi5cF/xwckEfbx?=
 =?us-ascii?Q?XgQWYSQmAiIzzW1vf7TwybdA/7G9eYi0IaZu7IT81DCIS5+jXkm4wRuQi827?=
 =?us-ascii?Q?pxZai5IVU+IJW/8/DPtF7QgUqv2OQDfq4jsxHfgA0RCpMMnR/7c8kgDECzg2?=
 =?us-ascii?Q?MFaw26fv5s6EkKJ0n97UPNiCsYwvXQmKjRmyLug1Hot6rsPQNzShBhivJHn4?=
 =?us-ascii?Q?0H/MxfUjxF4rBKdNXP8T9Pa3v7JNxWIbJ6AYsItFpB5Oyl/LcncrYlLEh9YO?=
 =?us-ascii?Q?RXkRkiUP1kwV7/Wl7DCmIGMKGGsdbXAWibykvwFnhwyCizsbyFz11aLBLH6R?=
 =?us-ascii?Q?Iy7J2Ww6VMovIY7ttTZq/XILEL2MXrttzJHK24S01s1lDrvXtQNVnNU+fGIh?=
 =?us-ascii?Q?Ze2IQyWik/jdIcBbYf29wUyHBmChOtCVkbny9Cqb1ngsze5zNmVqGMTdFyYP?=
 =?us-ascii?Q?wHqxcltnts8Pv1mr24mcKqC5MM3Pjj9SvwTj00uJk2IqBKnMoa0qasAPBeME?=
 =?us-ascii?Q?jRU92oMGHQhKNIr9xd/Sqvt2SpWGERO0n9zCvtZi5/4f86vxXWJJupRl8+IS?=
 =?us-ascii?Q?aOU8INwwz5Tvy8ea1XvwW3zwJosddF+A0aZAVFZy4JmOAhlypNh3a741pgU9?=
 =?us-ascii?Q?KzgyHX42EuUSZ8nfmmimSLmOeH0zboM/lRtbR4M/fbcpu9pM0/Hriwe3ys9M?=
 =?us-ascii?Q?rqMuqzF5D/P6boL1buP1/DLRFa7149BGE/lAmGV1XhqD3bXpeCCIC7hc/YJ8?=
 =?us-ascii?Q?7BkOUJ7nDA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1cZQ7QCgQrQvBuNHjvn7/QVkh/KGt97sDSSMB+6PWAbZhJNc7gCDZlooGBfAHrDJjjdOX1JYzWi3UO2/murmYR8esCLfcOcBJah1iPyQyudfq5MYruDvp6I12HRpkRDmSAA25UzZCTo/ILNSAcVvEm7pdP7aZax6+WlSNvUG26RINbSPgNNDsUSwR4ecyQ+cHQGLGffR+aiWHKEUXM2l1cqVRCSE9jMuzm+/T10xAxffVIEaopauQhiqTd7kAMf52ABt8P8PuwG2D1cgQ5aFy0/kt3LzNYC2cZlQu08vBm8dqqZJGcRjPjyCHt1X0cFvm+NRF6EgopP1yV9+68HWQphboZNI/PKX3CMQPfLSk7SyupjNx6lhu5j1kVdAazBMf/H1bF28mcUWjD05ml1caWzjJe79lX7DbGHV96ycVI9CMcmeFO3OIo1lmid2q4SoA1yEgs+HgkFWjf6NGAC+Oe8fOL6ueTaC7cLUGrw+SuZ7XndX7UR4bC9C9wUTCt+HV+1e0yI6ObX06UfTFuZJvb/9ax+XtNuswOfz4+vyKgpjBMNIg37A7+oOsxR8DkiUafcS1GmynWWBJqY9SfUpKPMRr/tApJRfPwOHy53j47M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3d0e6ac-8091-4586-d0c2-08de595501a5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 01:24:36.9321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kYsXISlPnVHC15RB3qarsAPFl+UcziBXgEXKER2Zr5l04hsTzreUWiFi/tu+lbX3EygCPYGf8VISTsfxiacF+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5676
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_04,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220009
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDAwOSBTYWx0ZWRfXxeAIfrB6Ape2
 8b74k5K8jwV6NUZc9x49YOteyXXPJSjvjLey+o7PAsRWOgGgWkfpnDD/URCTB5ftgbE8p9j7BCd
 r+UOhXhNY4VTkE6ae3u4w9TfY9pUP8i42G1PKmRmDPc/3PE8YAdtT6hdmV31PtjAXXAAqNpQ9OQ
 pl77rO3PiMia3RqF0RQE6tUkRkm/0865qpUIY+c7wAuZ2wIn5xcxLU/4eOMo82c8wqG+UNaQs4a
 cZggYn39/6Efb8L+NaIPMjD4KdKGsyBWLGDNnE3o2zfVcdVvAT3ZElK5PvAkuFKyjniMUaCC7CH
 FBglba4TjPf8WUcF2mpunSZr+PMoXNbmDqw4nSSaqVs5LezxJiMfAtHbSI6DNO7a5l2ToW7yuoz
 mF7XBrh9CJbnVwkjSJtmfSEKDYLJ/9Em6gdhmEKEOPH9khrLse9jpp32dPJ/3K3iq1cUG7+zoO9
 5VPtxPzV+PeJ5tM+5Fw==
X-Proofpoint-GUID: X7S3_jORL9_qCK6cRJAz7ljWUrK15_bk
X-Authority-Analysis: v=2.4 cv=XK49iAhE c=1 sm=1 tr=0 ts=69717c5f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=ID6ng7r3AAAA:8 a=tuWiHY0Wt6qE_o2qUVUA:9 a=CjuIK1q_8ugA:10
 a=AkheI1RvQwOzcTXhi5f4:22
X-Proofpoint-ORIG-GUID: X7S3_jORL9_qCK6cRJAz7ljWUrK15_bk
X-Rspam-User: 
X-Rspamd-Queue-Id: 82D581A000D
X-Rspamd-Server: rspam07
X-Stat-Signature: zuhcckdfxdrx8t5jrhdjhw8rzj49ikc5
X-HE-Tag: 1769045090-444722
X-HE-Meta: U2FsdGVkX182advgyzbsBkb9YXk7ZEYeXsvIEguqc2epdip8UcngaRfXRPcWqCEb/xKQMuZebYqAjwt72IQ/1O9AFVqBr5hhuZKng182Mjz4lP9GCgEXL6OFS+cpv2y48FSNF/IDICDttBXw7LliVvDY3/eMIdO2SYsubeTwKyqDjIhIXMBZr05P+LqshJaYGVPkmI5HDHa2vO0gusRr7TRpBp4SKW5mJZQbiuepdTIlJ3IEi+6hlYUokvburgKVqqjt79cHwQtuHk5JNtKlk7o6/VsntS0q4r+09WtcW9j/tdT6I9AyqWemWMdPpMBu2EGLOUz+1+y6NpA9zqnDRPfI52aSmVKwcXnIf9IVrpNIok20CTTqfFT98IC4pVWBvkw0XgWUTsNFLRXH43EYwIvIvhugS1KcUhke71oPPJPp+CRxE5QMUujtQWs0ACKyV/ZUL4vFqONDTjrFerrnbpHWO0TsMKFhafWTTNbvlsVCmD98sWCWIpbxTv3EVgF7+4EE+jkoBx2gKyTXt76xLv7HycWWjoT8O2EmcXdouegsGXWklfxVQGS+fMmtshEcCldQbLgvEtSGbWi0tknKThpRqyC4hc82GR7s9ciZAn46XpOhnBB2UG3p2whR/XA9MbJpL7KHFt3KxzjOJLzVcKUZrBNY5VzvzASkhG3VQ19mb+gC3pxUq9S/mkNTtOHlp4BXV/yzsRLFMARRoIk4gjqTJ8V7k3LBoZ34aYr8bYpd3CbAEpRct2SLt80sk6Jk7h3uRcjOFHBYHPiygsZlv4SvGlrX6duvMyiZIJgKUdHYIdOh3Zfh/IqT4V0nTxzfeR53+JqNxyPYiRX48hAHk79mWeVJTLR2JByi+MBaoBEf75lNLfEulgpfJmActI9mbanKLcTvUB0dwa/p+im3lmrb3T7B5uK15UMn6DusVt2ia2wbLnqYz6/T+PX0D/ax24y+UYlcZsMiFHHL6lh
 0zWITNNP
 YvmQp9/YutN8VYrdzYnruopILHwsUxMnsMcyb+ZRcLUQ03cLio3uzdHHefEYNP1ZzF3FAB4yrg0Gu6tPjUmoN6dZC2oPE57mnqiLpxaXigMD88VHOSFFD5vCsEPoHBBLB92vs5a0MWZHVWGD1GuvEVqRIv5NGGV5mXXuwEjoU3Kghfemvg0JjFIQV9entl1N769u4sE1J+HXhnj72vrbqJl9je06KHwpS8LYBSTzLucuIijBY7qFF1UV9zcogJBRtjIJmDljp2YR+vAHRL2/snPbK9jf52Z9FESI1JWSIbDALiuHWZ9bG8DoReAjKGGHBk3Z7wkDiPMaHlchWIafV0FoZGa/B0Glm+Ak9PODtz0p4NME/ba79SU0eExWqGsxxXdvvpiDE2B17yvN1Rb1iJBYmPqrU7IAjazZrVeVqkRngTRjMoozEiqa4bSzqCcUZ0I7vCI4dT1NFLdc/1v13cDedvT1GMPeLaJF2Mzi7G0nhJv0XakDAkfbgpFGdo71T1ZGPNfTQcPUFpsueKDNnXyhY/AIx8yUCd8lKVnptXLELKXB/Xivj3QciiH4AeWb0ofTm66/vceLoqKQ6HYgXTofSZIFSWn8EKHaw75Qk/8rCftnJcIn/ONObqpTsb42ENUltNwZPn8c235cglN0w8r6Rd7Kh1AMmaRY1yWsRGOH92Xmrc6WzgCXJBsMEEwThA6nRIXUL1GYxtUEvPcFWyBVXNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 07:58:29AM -0800, Paul E. McKenney wrote:
> On Wed, Jan 21, 2026 at 04:17:24PM +0900, Harry Yoo wrote:
> > On Wed, Jan 21, 2026 at 04:06:25PM +0900, Harry Yoo wrote:
> > > On Tue, Jan 20, 2026 at 09:41:14PM -0800, Paul E. McKenney wrote:
> > > > Hello, Vlastimil,
> > > > 
> > > > On the off-chance that this is useful new news.  This happened in
> > > > rcutorture's TREE04 scenario running with KCSAN and lockdep enabled.
> > > > 
> > > > Thoughts?
> > > > 
> > > > 						Thanx, Paul
> > > > 
> > > > ------------------------------------------------------------------------
> > > > 
> > > > [  253.872153] =============================
> > > > [  253.872271] [ BUG: Invalid wait context ]
> > > > [  253.872271] 6.19.0-rc6-next-20260120 #21508 Not tainted
> > > > [  253.875774] -----------------------------
> > > > [  253.877983] migration/1/23 is trying to lock:
> > > > [  253.877983] ffff8afd01054e98 (&barn->lock){..-.}-{3:3}, at: barn_get_empty_sheaf+0x1d/0xb0
> > > > [  253.877983] other info that might help us debug this:
> > > > [  253.877983] context-{5:5}
> > > > [  253.877983] 3 locks held by migration/1/23:
> > > > [  253.877983]  #0: ffff8afd01fd89a8 (&p->pi_lock){-.-.}-{2:2}, at: __balance_push_cpu_stop+0x3f/0x200
> > > > [  253.877983]  #1: ffffffff9f15c5c8 (rcu_read_lock){....}-{1:3}, at: cpuset_cpus_allowed_fallback+0x27/0x250
> > > > [  253.877983]  #2: ffff8afd1f470be0 ((local_lock_t *)&pcs->lock){+.+.}-{3:3}, at: __kfree_rcu_sheaf+0x52/0x3d0
> > > > [  253.877983] stack backtrace:
> > > > [  253.877983] CPU: 1 UID: 0 PID: 23 Comm: migration/1 Not tainted 6.19.0-rc6-next-20260120 #21508 PREEMPTLAZY
> > > > [  253.877983] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
> > > > [  253.877983] Stopper: __balance_push_cpu_stop+0x0/0x200 <- balance_push+0x118/0x170
> > > > [  253.877983] Call Trace:
> > > > [  253.877983]  <TASK>
> > > > [  253.877983]  __dump_stack+0x22/0x30
> > > > [  253.877983]  dump_stack_lvl+0x60/0x80
> > > > [  253.877983]  dump_stack+0x19/0x24
> > > > [  253.877983]  __lock_acquire+0xd3a/0x28e0
> > > > [  253.877983]  ? __lock_acquire+0x5a9/0x28e0
> > > > [  253.877983]  ? __lock_acquire+0x5a9/0x28e0
> > > > [  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
> > > > [  253.877983]  lock_acquire+0xc3/0x270
> > > > [  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
> > > > [  253.877983]  ? __kfree_rcu_sheaf+0x52/0x3d0
> > > > [  253.877983]  _raw_spin_lock_irqsave+0x47/0x70
> > > > [  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
> > > > [  253.877983]  barn_get_empty_sheaf+0x1d/0xb0
> > > > [  253.877983]  ? __kfree_rcu_sheaf+0x52/0x3d0
> > > > [  253.877983]  __kfree_rcu_sheaf+0x19f/0x3d0
> > > > [  253.877983]  kvfree_call_rcu+0xaf/0x390
> > > > [  253.877983]  set_cpus_allowed_force+0xc8/0xf0
> > > 
> > > set_cpus_allowed_force() is calling kfree_rcu() with a raw spinlock
> > > (pi_lock) held, but barn->lock is normal spinlock, lockdep prints an
> > > error because on PREEMPT_RT normal spinlocks are converted to
> > > sleeping locks but raw spinlocks are not.
> > > 
> > > Hmm... but it isn't great to convert barn->lock to
> > > a raw spinlock just because of this?
> > 
> > No, on PREEMPT_RT kfree_call_rcu() doesn't use sheaves.
> > Is it benign and it's simply due to PROVE_RAW_LOCK_NESTING?
> 
> Unless your kernel is built with CONFIG_PREEMPT_RT=y, in which case it
> is a real bug that could call schedule() with preemption disabled.

Right, but it's fine because this path is never called with
CONFIG_PREEMPT_RT=y. Yesterday sent a fix to suppress this warning.

Thanks for reporting it, Paul!

-- 
Cheers,
Harry / Hyeonggon

