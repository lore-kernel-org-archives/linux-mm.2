Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C4B8D715C7
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 08:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35066B0593; Sat, 24 Jan 2026 03:12:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16056B0594; Sat, 24 Jan 2026 03:12:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCCEE6B0595; Sat, 24 Jan 2026 03:12:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7D816B0593
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 03:12:04 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 739FB1A021E
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 08:12:03 +0000 (UTC)
X-FDA: 84366139326.20.8492271
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 28EFB80005
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 08:12:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lUEx+cv5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GbQFAbSF;
	spf=pass (imf02.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769242320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M+QqJhfJeTPFpKjcjkzHGEB67XqQ4OnGCQhpU/cC4yo=;
	b=FjlLPz8zz5cZoDkr2KBLzsGUmxEHZGzTUjSuv8n18U1egv2Z0In1qmOix4iHVvYCETVdQH
	nuGNaZDjosLETL873HLvI3qSQcXAolRe9mIemEg7GkRUrBYeEZGMv4g9OC05G4pCjNKOW5
	F9nFipL2Ta0Qfu8mgRwTms6oYTuZ+m8=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lUEx+cv5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GbQFAbSF;
	spf=pass (imf02.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769242320; a=rsa-sha256;
	cv=pass;
	b=AdcQvOHrbulEV/vRSCAIuyMCA/zSecXOmZpWvTQ72ed1HBCZ6h6My1bRpI9Clk+8V1VmEv
	zO6sMACbiTJZKIr4ejKlGvCPSpMH9DW3xD7c5yEpjc1x8RbK0j5CoZ+w1/9UlVhm/GDJbB
	dn1MBZHGIPl2C58CpAyjOnGZTDbfvxE=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60O7p1G71017106;
	Sat, 24 Jan 2026 08:11:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=M+QqJhfJeTPFpKjcjk
	zHGEB67XqQ4OnGCQhpU/cC4yo=; b=lUEx+cv590YqL0lWcRwRRDH8LvL7s1N8lR
	1h2uz5Su3cWagQcfK2Dayif7EVVI2F7N8BSpMA0NvZ9wp5QiQhdXnwch2P1+jZFh
	7lgTt1kS4H5X8DyJMqnV/Dm6oKnBZbDJ9xhOtLweVDYUE7Zu3o1NMaD/R7EGuskP
	wXRoK6iWrAjXA6ZsHDC03B2IKhfY5HFfy7FgJDr1wLUCOEhTdIZ51959BhB2+UIY
	BZcpLsvllJKCqVVVvdAnovrE3Jx5l1e5Og9Xat1ROF07jcSB6L3o3SVASjJIEPwt
	G72T3dty9i/Pnlj3J9TC9T8TCCaDu3UdS86gkG0dp4THfKsKbuTQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvnps83k3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 08:11:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60O7o1oT036089;
	Sat, 24 Jan 2026 08:11:54 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012021.outbound.protection.outlook.com [40.93.195.21])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhjh0p5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 08:11:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RGAN7S8U8HJjgABBpyAp+c5l9c2txEWtXwxEQBQDfS81NAnwFgQdq4SzkhRSikok2qUZ70S24HWGWhWR8rQA5gB1qbEze90t+JMYIVlxKvgrv0rirSvjzWjYhErIKM1/LVs/KgxdM5bXOl42qXeerRh2REwXVPRQv8yeIm+NvZedb2LDJ9jmF+DNGDDUu+2mTs3Uz721p9OINWUdHzTpBuzaZnwvhE+xpaGxbnlyE/7VCDCfPeN7DHmUYa+NtMeP1u6Rj9fST50PYJKVgm+NCt4pW8Po0HRMGz3XurPpUB9chBe3dLZuQV9ue9J+CWcR5Os19QWgW4nIqWNkuWzlUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M+QqJhfJeTPFpKjcjkzHGEB67XqQ4OnGCQhpU/cC4yo=;
 b=dCDMRWGdblqFwNqxyyNIdzEVAwMK1prtZANHIJ3fD2TC1GQG2TESg3BhihSl/D0EZMPDv9zHPngdcfq1t3Df8DLIHydqK0j8hUdS27E1V9Rtb/Bk1IxabkxwzhpP34cjFBEX9AfVRe74rvIIlzS37IAIzXZRb3N+Bpjofkv2UlryIbWGqXPvLUtkShKVnkgYZypZYzwIwJalKuD9l7KWWxZAGYlb2F4wIY9+ouBO6IXEN3SpDSC9xcyjf64YkwBdPuMJnPr+po4EB+VBpam3HLwWpAmSzZhcRPd8fh5pH5sQFEX/0SPpwinG5BCblK5U2koiB0Z0ryCfHP/Gi/0Mcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+QqJhfJeTPFpKjcjkzHGEB67XqQ4OnGCQhpU/cC4yo=;
 b=GbQFAbSFMM+RCVh5ip4V0hrvku4gW1MMQMFlrzBMfLwmKy+ucVzD17jbZeLzIymqUM8vSZH5WIl+/F5/WRZt4ckJe+A/gfMUKnCdxy/peJ0ff2R7vucCzlrTPioUQouHtuSwUoX494Qa9aWcpitl6JT/BzGYRLsIU825tVd8+Eo=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SA1PR10MB5783.namprd10.prod.outlook.com (2603:10b6:806:238::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Sat, 24 Jan
 2026 08:11:51 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9542.008; Sat, 24 Jan 2026
 08:11:51 +0000
References: <202601240453.QCjgGdJa-lkp@intel.com>
 <87y0lnewjn.fsf@oracle.com>
 <20260123174839.334fa31ce9ee6633d471aecb@linux-foundation.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, kernel test robot
 <lkp@intel.com>,
        oe-kbuild-all@lists.linux.dev,
        "Linux
 Memory Management List" <linux-mm@kvack.org>,
        Raghavendra K T
 <raghavendra.kt@amd.com>
Subject: Re: [linux-next:master 7919/9290]
 include/linux/compiler_types.h:631:38: error: call to
 '__compiletime_assert_639' declared with attribute error: clamp() low
 limit pg.start greater than high limit pg.end
In-reply-to: <20260123174839.334fa31ce9ee6633d471aecb@linux-foundation.org>
Date: Sat, 24 Jan 2026 00:11:49 -0800
Message-ID: <87sebve8fu.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0176.namprd03.prod.outlook.com
 (2603:10b6:303:8d::31) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SA1PR10MB5783:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d19084f-7db9-4211-5569-08de5b203a63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Xonpc6OT/F5frmTZacdtMoPNft9ZvLCQAAQ1fvwJmrMjrgjgVeuL1TDbswur?=
 =?us-ascii?Q?ejm6A32Zmdq8bArXLedvs/yf2QW6e2eqUXUWzpS2HhPRSqJ3ufnAfHKflj7a?=
 =?us-ascii?Q?iYo7zyOJwBv3fccbdyl/Nn6gPGnACwLgml1RUE7tzhoFSFhuOS1HqoLiwiP6?=
 =?us-ascii?Q?WVLifJO0SbPM+yb28EGjGZ+lYQR28xULq2xyfe1znhkiiSd9RgxMsZfqXQ+T?=
 =?us-ascii?Q?UozsxLMS9Gcmq52rtDPAfRYJI+pjfBD83a6Lr5FJeNFfs8sCQFDBBmHnfevs?=
 =?us-ascii?Q?zkKp1VdOIF6YBWahpWl8T2qPjDxyCJbR07v5g6pJlGzVbpoC2mP5NTkf+BZD?=
 =?us-ascii?Q?G1VLqoiEz2vyztMtPPYgY0XFH68Qk+2JvnfqXKv4voJ9nazWE1pLJXd8GTU2?=
 =?us-ascii?Q?8FMV6S8wVDRtlMBlonhYYDX+j5ISGPHwYbveU0Oj03VXXQzngsRYBWKJCEgP?=
 =?us-ascii?Q?2cI3NkQpA3xaT0LdQdLk51sh7OTASwjFwCI59dk74nbEZEmphYf9AansRujt?=
 =?us-ascii?Q?KTF/W9QAO1tZE7crQ/6fpldCyy0f/ou2LYWb3NOEmeDqOXmTnvGD8kGQy7F6?=
 =?us-ascii?Q?Y/+F9OTD+1TeQjnDCll8cYUt8GEmvt6pSKfBEZLz3axAeQlCRe1NRCxdxIxV?=
 =?us-ascii?Q?ceqfDYhzTJQlN4CIsfbRHMMK0aNLyOE6kopjPXl11rG32rEiosi0KdtK0Oaz?=
 =?us-ascii?Q?QiAaeXDSm/E7VgvjWk2/iVHKD86Ta+imjlkNzmTZYzluoDHfM7XihXA9glyq?=
 =?us-ascii?Q?N4NJelo9SrVt8Wd5VizQJiUGRO7KYfOvZUEf4SENgbqeGFnb7WSIvIghDFub?=
 =?us-ascii?Q?vona8vdGPdP+KDc+dcFF054/2awe7u3NCVAMKaR+VV2vFBhq9s8cEo0dyJ6e?=
 =?us-ascii?Q?5XROFIIxPzKmVaJnM/Xk8qINpmIW2X0pRN5jfgh+Q+ltKoy7w/MnPJ1O4YoQ?=
 =?us-ascii?Q?3EJn1jJmpnEwDqrN9YXu/fZ4USIpDHbp6UyMP6pmKciY05PZC+xPihR2u0UM?=
 =?us-ascii?Q?wnqwNKjZnmVzjhwN2AP6owxGTKHOmVBHQmfk561kfFVLKe3lyBcShG15mhuO?=
 =?us-ascii?Q?cB/9k+6dc87tvLKtMmY+0pOIqihjz68v46nyUe2qYe5xnsLA0/xhr4eSr0rF?=
 =?us-ascii?Q?5Zk1RlugzCJPxarL3jvmMv83tW/bvYpgUr++ecwt4uu5dOsHk+aDYfMAMEod?=
 =?us-ascii?Q?+4gFyLJx95mJcdQEZTsCwzect8bWKx5/dkoFRqaiJj6VXdeZNa9HHApC7oYe?=
 =?us-ascii?Q?jTT+bBtSi5m6JPop8AclOn5vlKHT/in2o8aKKY8dLDTqfI+Gv++LYvm0zsxr?=
 =?us-ascii?Q?9AoESlyetfDdyn5Sx8ERVv3nHAPPF39F6te1wntgW9G0li5MBqOEm6C6AIuL?=
 =?us-ascii?Q?EpUpFNVIH5UOqmIYF82yCrtgaLm5HRnAHPKcql5dIJmxgZAFDpyGlK3o0JBW?=
 =?us-ascii?Q?exnHz7s7HTydtZbza163ueIzwFoYS7rf3Es/XajVx+G4GIm+PL1rDVRxIr5d?=
 =?us-ascii?Q?FMPaHVqOB0q6A+sCxZZARym67zDm1y4lBKDinKKH7onZvlXdRiD9HQbMtqId?=
 =?us-ascii?Q?3iDpf1pc4He+hwTQlwM1YGHdZgSPg2VCw7iSON2R?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G7qlp9BuTI2jZs96GLS/h2l2u3Brr0XqiFGPumpuqJEqPx0FytEuuAGhA+ac?=
 =?us-ascii?Q?u0w870ejdHwzPBhtyFSSDoqnROBwuGX960HXbM0DzSxPLWBTb9H8p7creU1L?=
 =?us-ascii?Q?JvPnYOWrTqw2STAzGCP7VZOHeMkEuy5P3CeW4BsjERevqfPu8lSJ+mgmuid5?=
 =?us-ascii?Q?CBYW7GeUDSQ8YnbrPsn7DqwImzKv75m2agOqbtx6V4nrpVEn4Ync2y2vowT6?=
 =?us-ascii?Q?zV34EZYGo1qbI74JYeWICJCUPSshcUjB+otbvmKMBfG+ez6Le0suM6byhnKb?=
 =?us-ascii?Q?l4dH7qrsVMfnJvfIXMz73RVHYHAf1snc5ae0LyndBOivNX50Su1+PCtGnyfA?=
 =?us-ascii?Q?EFRr+VJLXy4N5xDurugZ+/qZ7UH/H1x+8luguTrxkpVuXFRMM2i7oPDfW3al?=
 =?us-ascii?Q?otlfy0YFEer64I9bAn9q+UwJp17NszOurT6x4VGKkZUzMbV8BCpYYRbeulOV?=
 =?us-ascii?Q?5WMl3P/7RD+MeRTVkWtFR1FUyTVtrd++8EdvvEXoqGfsAubEWoyYSTZe24ic?=
 =?us-ascii?Q?FeWJ2Omw0j3h+VAdU0GswAwRN0FqN5CEvH08YlCtytWF2tAL2kSexGicwV+J?=
 =?us-ascii?Q?VL3KgO8W9HJtEP+LNT4lV2BTQnyBtNvtxtbdE/5B+nXYl5LWIDqX4ubGmPqS?=
 =?us-ascii?Q?4iHqB6F2ufPlvjP0X39vzeJRJa2A6KUHYQKkjCkfPJBAAITUOW58Rd2R2ffG?=
 =?us-ascii?Q?lbsf9g3h4rq0bCkzvyV+brdgMHtDXqcue1M/vAE8WyQLDUwcwOAOM7FGmJyF?=
 =?us-ascii?Q?Yw4V7EZQYdkUpuXtFj+6m94v6pu+iSFf6vy6b2vFeCh7RoNfTV0cZp+JIe8r?=
 =?us-ascii?Q?XRTGeejcGj6cjoJgJRdpw3e9tbHfMCraHdVljQ6hnrr6uJUbyIObDSZBWYun?=
 =?us-ascii?Q?rJcpJnS1MgZPun3frkhxMCROn6RmOWhjAm6Ewb92abDP1xYP9mBx85dDXKHC?=
 =?us-ascii?Q?zJiMIG/jkM3TeX/bsKOmc5/bEFQlmR/7DqEbDWw1BaJXXm8QDfJw0eweERyR?=
 =?us-ascii?Q?0yUkBBFx4MDlK9RbXKYSAgsQO3HsH93ALnbRGlYyiRAtMJoJFTapFUz7MZD1?=
 =?us-ascii?Q?Bec/8qwBYqsVnc0NUgbTeQtOI6uIdtyzj51Y7qoj9iA0UTK2+1cT0ot2JtG9?=
 =?us-ascii?Q?yjVDM0AsagNE0iydNI9Ta7h+qKxy1O5GRIsgxHImIhTM0QHuzXTrpTzmlh+W?=
 =?us-ascii?Q?cP9RANrlUCnbCsL4d1G3PVYP/OUXAWDKhtw168DG27lKCRipayge9qcuCZlk?=
 =?us-ascii?Q?C5/7qcmTq3Vnc5yrdnmkasFAh8rpIFcVg7o88ncCcuC8oEZ4uQpQUr/SPIjv?=
 =?us-ascii?Q?qAE08bs6JdcnByYAiXiDT97wpTLGRzNwgGn8vQbqfdaCUYUWN1J72vND9lBC?=
 =?us-ascii?Q?MVAE/Q0IyVu/1ewtcDVgL/f90vh+I0H7pBjfqZQKf3YeiRTlar76ahg6+Lsi?=
 =?us-ascii?Q?cExp9+0y8G2WvXeUHJkspvhRgq15JDVYew0BniTfXYLW1Ybf48xPQ2xuL+9s?=
 =?us-ascii?Q?FDdofHNsc8JpnThsK+EnD2h3TIbognicvwBeXlWC0agb1rOgOIm+jh1MgiiP?=
 =?us-ascii?Q?mg4JTJcVh6TgT/bJYbP/PTbP9uJDQ2oILEZPIR+QHie3aXfi94PsTTjEfrYo?=
 =?us-ascii?Q?9CjuKtKY0ALnLUs7vg2bvlW6Lq7B3MbRq+w6s51cS6K4MqLh1nehcmq/twYA?=
 =?us-ascii?Q?sr9/EVYcsNnciZ8o2rr7z3P1kShyus8ZDLdi/2dbYEN/bLTWbygoZBXdxIUa?=
 =?us-ascii?Q?syG4caVTSiVlmyz9shF+U7OZxXuG4eI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gFaqEE5uuAKDF1PvNRVG4ZcQmlpSLzM8Y3LUUsDjdVkHq0LsGzfzgkiH12cFd3ASsAovSY4DkSGd1GAwWCNLuPrSWCo8KXg10TVcjYKBpuSJGSUuAdxA2rtRgtQdFmfDqI0aZyUUYNdBc41lWwiD+/QTWrEPhP64qQJPAq+ET2kYoHDyv9H5qZP2ELawqyDJ+2gPpwEznTrJ/w6bps7e5SqEBWPRXpoZbA+0ikZLfVDpXGWpt/I07JE137mPqyIEiqwBsT6uNL87ICz4hq+V5LLC1rzp4QYjdUGz4npWjdDKSa3goWf0iitfeOfkKsSbz9/pmkRLJdiAKY1AbvHktWCyt7xTqF/IPdYzdXDLZun5aIvmsKRy199P8TD+oFAdV8Qc6ScVlF9opSlyY5iNDMvIhL0Yfk7s0RP7b5SKIfnkN6URu4kRe4adrnhKHsTlz5lcj6cvLw2QrZ1/QXt885pNHYTAcTbkObCsfYOi20HKJsT3CN42Db0J5duHyF3crhaBP0HD/73xnfu/tTfLzK/F12j684STh6HMPvmBXOrZebBy4f9BJ5HkXYweXomR3y4ceRJbqZ/uMV3KkFxErGL0H+i3BX53vYhTxppVq8w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d19084f-7db9-4211-5569-08de5b203a63
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2026 08:11:51.3811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zjopO3eaEFNuH74t7vMGKkvk3WZtLhkokVK10HX9L6bIPMukwXPBDS9h6+mRZQMzGeF77dkGiWL8TYQTZ726Wey/xLX8Nky2Yn++0pBUk9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5783
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-24_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601240063
X-Authority-Analysis: v=2.4 cv=dY2NHHXe c=1 sm=1 tr=0 ts=69747ecb b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=i3X5FwGiAAAA:8
 a=QyXUC8HyAAAA:8 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8 a=SJQ3e-STMHx2PYc-mB0A:9
 a=mmqRlSCDY2ywfjPLJ4af:22 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf awl=host:12104
X-Proofpoint-GUID: 1H_gw8kQQjuj05jxGtm9ER3J4heWzSyo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI0MDA2MyBTYWx0ZWRfX5PNQdULoTKGr
 ovmQmoHNGFuMuvak4RbBa8lwuNQFvTLl91cksntCZdmJJF3I1lpXQwh2tIU6nYVm/INpZvIrV8N
 7fQbue8o8pcTDhgu2ZVU3l7JHzLHZmTBvrbu1Fva/QL+xZ/OR+6zoec5AQGK4lpmvashVsSpMSn
 biDwDy+O6y4WIqBGVAVrlX76I7Zua0u/3ktfmn4xHV9EGlcYOVzUCdjjz3R5bb0T2OSsVB/ofsQ
 7LHlkftIG8WKYNs/4LLx2l7aUa45lYB+UZa4FoLBGVJLvsH+WWKjeP6XKCs0hOGaGpc+Q8911nU
 5Fmz/qD6vk3U3r8gQ00XRI3APPv1GvvslWqSMPeKIGXCIfVcqc09uydCnoiOaS9v8rbdsWiAlax
 jWoaaWWprSXfcRK2Ak55dhYgehpVthh1voc4N895k/j75USt4dqyY6fhJFmmC4SMWuIaRun9Sbe
 onVkD63df3GpyxkKjx44uQsc5TnH9GEqJ2thFOcI=
X-Proofpoint-ORIG-GUID: 1H_gw8kQQjuj05jxGtm9ER3J4heWzSyo
X-Rspamd-Server: rspam11
X-Stat-Signature: d1zasp97b3emw61cb44zoia3azpnkz1q
X-Rspam-User: 
X-Rspamd-Queue-Id: 28EFB80005
X-HE-Tag: 1769242319-942976
X-HE-Meta: U2FsdGVkX1863BLbZivYtLGhxfESc/KY4Frd8HGJYVn3S+sHvzsENxpImmzd5wPLdi2FnYVLuYk3KHy0hTYue6rSkDNNTDtU0k7VvDC5UE1vkZvInrUpwWj8nDtYQd3RuJtr8qc+ng0oRAGanyxam8TDQzftz8W1M+YNYvM+AQWAqBOI2i1kgZ22GYncAm0cYuTRUuqnJLYM8gGZsflPPD7F9TGvnAdW+Je7txDKjNBFpX/zjAhZrEkV3H6pO0GDfmaVfhqit78qwS3LVscNxZ731aYqqnwaXDuilwQKVk/OpVZw2+HKgfoNlJOUtGADuc7iRj6nNThkO+CL2uIIH3vVpVmqCiXs6eT33+SLivqwnVVwxwnTSRocjbeERwrfeWzxQO2sI0+poe+PUdBFJiq0NHnjM7y++X32kYNd3J1qqKtofRYYuwBPe04Y+PLAzfFK8QDYeJ9WgbeSdhxe+CjYcv5g2vYpXYwn+cEJFxwTMDvoHCa/SVlMIWNF0FLs+w8ws9YM0Xyq5ryOa7VoSMV68CE4l/NH8yJwYcmAqMPMMWPMoEXHFTEbUpWLtVNh5KJfXj7dzXUSfOMo9HdWLOLp6dUbJxYe51YzlZ4vEmHi3EFweiM9lQDx2sf98TndvI8WX13iqBzEMlOmziadFX9VptJ++we1aFRBhOM+NhusDNs+tlcvSTu0YLdCOFhrqQKYh4nG9ccJSwtHzUHQUAH7rdG0E076rS+bklMcvIClr/gEt7s9WFiBgqy45RhQ5Cp2SbvzsNpN9yF2/EvOJAcBr/PPOGIlyvgoUBH73agRVOcDO0aFKKqV5Q2LZo/W0ghN0gFN39sY80E+1Pi0goyhoXt18kUYGLvvxqmcKPk9eEZYVEmLLkqsXxYE8NZLwyZIZ9rGOm/EFZ+rHVTVPokSJOrmC7xZpHBKiA6iIA4h/J8DaQy2scgu+MJkFJP7BXr4Phkv1xTj+KFSLhT
 5u+dG8Az
 jkHIEyTYbz6OMZ97XgSNcftURdKg7K9r0ECOGlGXPsPy8Ds+ELfQnAD24UMO5OXwZwZabFj13CwO8ir7eockFRICOchQR/+3GeEtku8pluEBbnd1FcQr+ak/hSXKG0RSW2KK5BSmyiR2uZT9SkD0uI/yRW3PgSAImJjYMB90Ih6WaIkth8vX0sO4Qt8Q/FQsG29yxgc5bDJ5rFspbRpJ2hTakeF7QBbLm0III2qLrHeIEmpZjviQhUAfnN7QHjUXgQCJDXjwoEDkLKSF4s3xJ+aElXbm+DcGPQLanEMHEVvDgtf45DO1U+CY5uhqnCA0M1EcWaWjCQtsLej9usHfQksbPZcIK2AYSc1aSOmFb4DXJFueVVr4+V9NnKCXxlaetxPEY/m0M6F2bl+VQsxnwmaKTKbbYRk8yANcN3ghP9/q9f+0ZwE+7purB7Ul21EoeM1p47PMweglOHIx9zLYT0QshJ+8vEwfZ0RguvIuQ4rjiEhCj8q6s1EOGTuI17h7uxd0/Tc/VzIhdNWio0P1t88ICfx4Z2MkkSyFBfk5/ddHEFGrnYYn1fbH5Z98OIYaz1ouVa9i/d08BL6Y7ZRmoNWRhY23Gy4tk9seAdLgwa8xSmy5mipvs1Mc/y5i2/A3eAotB95JiiJabstzYsZNg9Te8OoQY0jzp8G4gWEDlxokcWkHnvPb2uh/s9tGM6kbcL0X1AU6C7ywdJXoSv+uTWrWj7RrWPyQPvJqgx7FNxBuOv4DKL4FYN5uiD92XZjm6LiuUHPUCbKHp49s30wPZMs9oB/MAudgFQpQSgkg4WAGQyqmt5OaiZmlJBh5PKUqImHL1buMqnnIWcLUSEe8RvRhFXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 23 Jan 2026 15:31:08 -0800 Ankur Arora <ankur.a.arora@oracle.com> wrote:
>
>>
>> kernel test robot <lkp@intel.com> writes:
>>
>> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
>> > head:   a0c666c25aeefd16f4b088c6549a6fb6b65a8a1d
>> > commit: 93552c9a3350fff06543da18e4c80d3e804191ca [7919/9290] mm: folio_zero_user: cache neighbouring pages
>> > config: riscv-randconfig-002-20260124 (https://download.01.org/0day-ci/archive/20260124/202601240453.QCjgGdJa-lkp@intel.com/config)
>> > compiler: riscv64-linux-gcc (GCC) 8.5.0
>> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260124/202601240453.QCjgGdJa-lkp@intel.com/reproduce)
>>
>> Oddly enough I'm unable to reproduce this with:
>>    ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- make O=build_dir/ W=1 mm/
>
> I couldn't.  gcc-15.2.0.

I had gcc-12.1.1.

>> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
>> > the same patch/commit), kindly add following tags
>> > | Reported-by: kernel test robot <lkp@intel.com>
>> > | Closes: https://lore.kernel.org/oe-kbuild-all/202601240453.QCjgGdJa-lkp@intel.com/
>> >
>> > All errors (new ones prefixed by >>):
>> >
>> >    In file included from include/linux/mm.h:18,
>> >                     from arch/riscv/include/asm/sections.h:9,
>> >                     from include/linux/interrupt.h:22,
>> >                     from include/linux/kernel_stat.h:8,
>> >                     from mm/memory.c:42:
>> >    mm/memory.c: In function 'folio_zero_user':
>> >>> include/linux/compiler_types.h:631:38: error: call to '__compiletime_assert_639' declared with attribute error: clamp() low limit pg.start greater than high limit pg.end
>>
>> I'm a bit puzzled by this assert.
>>
>> folio_zero_user():
>>    {
>> 	const unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
>> 	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
>> 	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
>> 	const int radius = FOLIO_ZERO_LOCALITY_RADIUS;
>> 	struct range r[3];
>> 	int i;
>>
>> 	/*
>> 	 * Faulting page and its immediate neighbourhood. Will be cleared at the
>> 	 * end to keep its cachelines hot.
>> 	 */
>> 	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
>> 			    clamp_t(s64, fault_idx + radius, pg.start, pg.end));
>
> This line expands to 2846 bytes of C.  The clamp()y functions are asking a lot
> of the compiler - their development was drama-filled.
>
> If we want to work around this (and I guess we should) then simply
> open-coding these operations would be a good approach?

Yeah, let me work on that.

--
ankur

