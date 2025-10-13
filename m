Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DF2CCCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 10:53:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FEFF8E000E; Mon, 13 Oct 2025 06:53:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AF4C8E0007; Mon, 13 Oct 2025 06:53:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E922D8E000E; Mon, 13 Oct 2025 06:53:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1B648E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 06:53:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 87DE71DF757
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 10:53:19 +0000 (UTC)
X-FDA: 83992779318.26.4FC25A5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1A8EC100003
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 10:53:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="APuH+/bF";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Q2aJQ1LS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760352796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IExFfHqFtLsvBB/8BZwZ1F2KLZy7rWWVjqTFMX4XizQ=;
	b=N4m78Y7iuziGHcxRATIK5yt1YeO9+x5WOPtjCuDydydsECtzaanNzGb8iDgjkPzl6UX3UA
	CFiOyfZa2J5ZHwXkE40BU0wfps93Cjhf9NimVuEBLemHGiPumjlwB4tp7uKfjnYwJC42qF
	dYwwJpbjKVl21bX1ULoK6Kd83G8qQHo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760352796; a=rsa-sha256;
	cv=pass;
	b=WD5av/tyKfxWP2SAuMisO0oOMGcmujvqBJpWp1VTVUqDzrvfvcY0BDEtJYqBBeNQXa7C3o
	5OACF52z3RKn2eglvrAMFtR75f4b/yBHpyJwFIbu/kvt+fQYCoWKO7UdPX8iUWKmLivqEa
	wnWNpUYcW1IojqQ2VnzBlX0kxoJPAIg=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="APuH+/bF";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Q2aJQ1LS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59D7uBtA026865;
	Mon, 13 Oct 2025 10:52:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=IExFfHqFtLsvBB/8BZ
	wZ1F2KLZy7rWWVjqTFMX4XizQ=; b=APuH+/bFKtz0+6r0fc1TIWtAXGOR7xuUyd
	ndW8pKOkwHjqSDB13Ou5Gepc+EbXCefCo/e7KfB4csnnJ3NYUAv6R2iDqay2/2FY
	u+TdSZ/a32mfLM1iaq+Fv3XtPCivPVK5aJzDSIeUxu3J9S29O5spqfrtI1fPL02c
	/GDozgWN8Yy782O6L9u6EFfcIdCMS22HU9f9MIW3Vz/7YGh2wD9LjmMlo1hDuga2
	joHS8rXYFCOCnNh2mo/SffJAPIfzKdXBLSuVkfqMa3ZbDhvHoYVglIkHf/2bDF5e
	v4nEyRJIBgNNPWcc5NvA/dZvgTxIAH6olfDrxamnZH9JlZxJNyWg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qe59a1r7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 10:52:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59D90k1q018289;
	Mon, 13 Oct 2025 10:52:58 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013011.outbound.protection.outlook.com [40.107.201.11])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdp750v2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 10:52:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fF4oSAYWvC8dazHI4TRx+lh2jJbCfDjPiAfFCUI2Dv684IAq2nSpqGo+XTSvhhzBopjHUmKeJadtmK+5WFmX3OjmIW6LMPtAfh9P0wiWg8XMIcsr8xSC5XtM+YO2r0xAwoMjgGJin3Ylb9nZ1HOwUvmZEZqrgpv4KyiQTOnddFxeWNRqhFBQ+8a6c5DxFiLFrmASdYf0wP5euj/n2voaymZ+ZAA3fbJu5ZxKlN/C636gMiNOA7c7tkclH5AFMdFPVe27KxQVYcwo7be3kFl9QPBA6cLI/j8Pfr8s6SBWlrwJgkNYWDOHadJtnYoXociAmsVoiojbrnDKTpFmmgqA0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IExFfHqFtLsvBB/8BZwZ1F2KLZy7rWWVjqTFMX4XizQ=;
 b=lmaN3pJx7DNOnx8jx5qN47Th40W11op/HryNSSrle4WRB0RgJ0FJ2LZdMS3+TzO3Vduaxfs+G2x0vLrmgxl/igmB0LpOpG2rMs9ficiV3/Y1ed0A5a0Exc2XOq+fr32pKZFRq0wKmOSLYu5vA+Vf1OiToo1ORh6uOI831uDu3PEwYMin8PAoP7u7RRb5xsnpODvdrBsEiwdaLwqIhDjFJ9O4lgNJteKPII3pJYdg+MFnnS8hBG8s9ctHD8loEmcWgNkJfWT2K1dnWZCZg6wXfU76tbqDb3byff5BkPj0zLwcfhofw4J3SRDSF/VagsGdJgdtu/8dFJkk2Ae/TCr0OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IExFfHqFtLsvBB/8BZwZ1F2KLZy7rWWVjqTFMX4XizQ=;
 b=Q2aJQ1LSbXnt0T6d+79SUpyEwm9fvhT1FMl1fP0VCBDZoKRGAaSs1lI6aQrSY3AJ8bSRAPSqCY8kSyYG//fNbMurSgMm7DEjoTGaw0ZBx2ddG/btu3MWMIrhlSJy8QFXay3yYLDpysoMDZ9YcZ3BSXjUi1MwyO2tT3vDBrOKtk8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ5PPF6998A7572.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7a3) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Mon, 13 Oct
 2025 10:52:55 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 10:52:55 +0000
Date: Mon, 13 Oct 2025 11:52:52 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Fushuai Wang <wangfushuai@baidu.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@redhat.com,
        mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
        axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmscan: Remove redundant __GFP_NOWARN
Message-ID: <3ed12beb-c054-4cd7-8938-64b899261887@lucifer.local>
References: <20251006014948.44695-1-wangfushuai@baidu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251006014948.44695-1-wangfushuai@baidu.com>
X-ClientProxiedBy: LO0P123CA0013.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ5PPF6998A7572:EE_
X-MS-Office365-Filtering-Correlation-Id: 697a503e-b75d-45ff-332f-08de0a46a9fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iOyTyoT25p+1v7nP2hJVtyaBNeZNTB6JEfAXOGBQ67vRJCQkDCZUqnw7Mz/6?=
 =?us-ascii?Q?1MssJWXTSLWXYfKQywbE0LgSlDcvQqiYVDI6yLdNdNN3BYfaysLuOb7jcK2Y?=
 =?us-ascii?Q?LJqqDhyiPIpv+pSS86+aTvL7W2jxR+nuBtzHjkBQ/02LSt96u6nj1Kr+vmLT?=
 =?us-ascii?Q?lN1tqyKpIVZKDsOoIpdXVvVxa+7VbTyh9MCamKwqFebL+eVsrBES+uYnyKkj?=
 =?us-ascii?Q?vYn/Sbw/oXbUnegcc4C4iGY3boV52f2twEUPLyrgchgnGv0C1QFdJPgBfbya?=
 =?us-ascii?Q?FTij045t9458kJelF7nzq0y7QM9ZVlp9QeEsB1UDgtT0gbMgswE+ejU2akF2?=
 =?us-ascii?Q?+RO5amMMY1HFHsruui3/RZiyC/UaNwPK8S+jFJ1tjzep7ZDno4uSylUCXlWz?=
 =?us-ascii?Q?Lb3ng+0NO2ftMluOH/95V97GNQF+5RHv78l4ozkkCnFlSyMiY7pc2UfWSqLZ?=
 =?us-ascii?Q?hcAn6Du+n2RkVnOU+t+uclkIcAUztN4XGHOcT29D1U/s1mfk8dn2tdV1ky96?=
 =?us-ascii?Q?Q+MqVEcq1SN91ukzSsJxVbF8hoPqyvB9ZUnU2aGGZlqTEiMh3UoX1f9iU5m6?=
 =?us-ascii?Q?rEpFNjtwv9b/EuSMhvaS8QGyp0E+VcZy4WvXi2P1wczr5gXGrFiND+bGODCr?=
 =?us-ascii?Q?lJnwOL5qulZmiRzuPzVTUDF4PX+ZJa6IJBxmJqkJVbvHwiaJjdB9HTSdIQsM?=
 =?us-ascii?Q?AhYTZ30dsiQnvsHDn9uPkfYHAlzTshJAEmTPdRXS58+qznXyWcOOKW/eKbBV?=
 =?us-ascii?Q?ZZOPs8fvjCnOfHdntFzlt+5TvM28bi30YhT52NG1/EhKEHiBa9zoRpVGgR9c?=
 =?us-ascii?Q?22s87dhmhLD6DbAZpYnrMqQjnTkCXH07/WItybqjkZXNsqBZb0+6OC5j9VTR?=
 =?us-ascii?Q?iHUdVNp/+2Exh0MS5Ob6maTsDQH3S+kKd5ip2WPspd1wXeZ29k8w+ZAfY67N?=
 =?us-ascii?Q?VYf5Wx7HlOiLk1K7E0rxeTn465MsHCJ3kLaeXJqWrizTCmx72RuVl/YcIlvt?=
 =?us-ascii?Q?nxkMLBLzB/g0q9HfBG4MwuBkScsD5Zn0tqKYlWeTK6HE9sYJe7kRick5CYJF?=
 =?us-ascii?Q?BL0Rz/Y9QckQE9EU3Cy/oLxHJEKb/yAKJ36V/j2Lielh12N9qe5BqTiQqC7C?=
 =?us-ascii?Q?SnopRb1TyABrQORLWzItjl1e/i9777SEbCspZ0Ls4E5qxvXKB9l2umEZN+os?=
 =?us-ascii?Q?xFiwrBTevLltmtZYpYck9UWedPWUVKi2yv7gZ8Q1iX4xkjigzX6iXE31zLeZ?=
 =?us-ascii?Q?wnYHWBF2hClEOq+88/MZy6eollcRepkKfk5e8tHivwWD36zLVFrmTn0tocjD?=
 =?us-ascii?Q?7EErF1HxPfC/Fl2BlyhaRGaA5/sbqTLicBwHf3/u+oVCdJ4aWLVgJsFskFlc?=
 =?us-ascii?Q?kPF3W/YRPN/Mcowi+KMqVM85KffN2g1L7J4+MrXuqMWZIaEa9tKQBXuo+YhE?=
 =?us-ascii?Q?OUT+I5vFl0RjsDdDruquE+VuMGXQPter?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sxKs5ZOBVcYwfLRg19t3fVSBvSYFpZcwiJ+tXUycs+QJ6RSpicoYcvY68SWn?=
 =?us-ascii?Q?R18LXeRAtRoeqNKencnxK9BbPBoqrZ8B3GJqP4Ym2UDIQ6RwgZyOijt1D6Db?=
 =?us-ascii?Q?U45WQLlFeohZpZQMplRjSm6i/4tnKzh05GQI3qj5EOpCskFYLN5N1Ciy8y0P?=
 =?us-ascii?Q?fT9E3BjA9bK44H6LHV4giTU3mxd8nGP/t6VE7fO679/QInbuKzXyRyVW/vqK?=
 =?us-ascii?Q?I/V0xbKpR4T5TWM0P6yybT3T4zxEc3ApIuZlRKzVJcYvJxhxKh4KjQj1CStx?=
 =?us-ascii?Q?QuumG8gsClt1JLiSGEIC4wChHsiGVxu5/SqZmzgmIRIaFrLO++2vDnekQJTg?=
 =?us-ascii?Q?nspG6yIdyoOGhC3p3QnaFW9X/bNzazOLdb9isnHJDda+EWg8cTH7HQGe4idk?=
 =?us-ascii?Q?AQWt2gZohJsMXwhKnrzFr3/JknrvI0KbGccNGRDs8OzFvLUNp4zlNqkmapmA?=
 =?us-ascii?Q?lIXYFizszQ4qO4wJCxle4CtPnDilz6tyLIPj5W5FrCzgqCaEabR3orf3rP29?=
 =?us-ascii?Q?oKdl0FOqo0nhtE3zMaKt4zZ6hjOLfrxiicgvI1ylTS3IXE78dINrlnX8Q+0Z?=
 =?us-ascii?Q?pBUX2bVEWy7Bi5Kwd+LXQa6NnxYyLAs9WLl8utmC9Cek2Zt6flZgQsf1Hbym?=
 =?us-ascii?Q?u2eFmmxGHEXtFB5UCGl9Qc0Av5ieRqWksqu8WDTrZ4/0k7s6A/xI1nfOwn8K?=
 =?us-ascii?Q?8fB5Fka4PWukapGlNY7LWAZvaBCjMGQl1jtfgimdx976m2qzjthqKY6zAvsl?=
 =?us-ascii?Q?EtWMx3dAuRLrCrcU7fVvn08mTxuVj/ANHnBGbFMilTaHPnZL2A4D9DqsawMo?=
 =?us-ascii?Q?IZ8Y7NI1gzCIrRFoTepov2l5j0ndePIkfqPZc6UNs3icGTxaaVrH41jKPqvc?=
 =?us-ascii?Q?0qZjegf0tok6WVlXY2+13rIgTPw6mHLnNaQ937pgprp2bJHvIUCi9ILSlBNz?=
 =?us-ascii?Q?DWqsKGPzfetVvdXb0VJJu35DSD/ZmoiO4nHcMHioihwWXXgerz3aeKavgB2c?=
 =?us-ascii?Q?zBdhYlh7PIWCQ9aQX0BzTfT91DTvDLvE1++ZnwStbdJFNogMONbWl5mldEJ/?=
 =?us-ascii?Q?HZcWc4iQWJKGP8GdMYuYANb+X8y0Ll6VqtHaVZhToOD/AnNm0RaEEghjI3Qp?=
 =?us-ascii?Q?36zrRxXmuauWur8jGLuNti2GX+pxjMw4n6LUlIHOBOu6BE2Z7PePxFLQIiqV?=
 =?us-ascii?Q?Qv54Tf2h1vsL0a8hJyM+Ghdpi0LEreS+tgW7QYP+UYYlGiy1cfxTSg3mUy7i?=
 =?us-ascii?Q?/XBfU3M+38juUjmc9//i9qMclB8NnCce98IkO+CdoqmVxIiEAoLyOnl8w0fk?=
 =?us-ascii?Q?dotzifnKZa8zKyAyKHuglx7wcBW5uiovYIf7R4A7lUfH9mz/d6EDipqEbGKg?=
 =?us-ascii?Q?OVAS8u0n5+AEbdpmK/lrK/XkoWW1e40JzBKMYBZaJPdJMrBWeS9swZ83gFIx?=
 =?us-ascii?Q?FdLCsDnpQe/ZYI1/T65Bws7olJnM0v9E9w1Ll6eK8LZ3HIZJwCsCqesx23Ri?=
 =?us-ascii?Q?wP0eiul2EsbEYhjrVd8ECb1UUCyqXwtCIgn5hWWO8RR9Xj/Dm/9OfupYnfy8?=
 =?us-ascii?Q?a96OqaQonBbEWFtT3nhpIQb/CeViLzQRAaXnr5mGXMA0F1LMa+IJJXlBFsXF?=
 =?us-ascii?Q?wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BT2PuadZHQe1tJEQVgZOqCdVrT5NvB3uWIFngWGMaC6uQodh7YOm+9G28QRXpBjC95llHEjrQ/NU/4ULQjzccv1oF553VHc07rjLEfoBlf8yRJtCQ0akGS4D9d4OSK7MCYsOIdlehQCkKzXO5jENllVTgz91hx6oulEGgU/DQ90q6nX9jQc8x2lXw7wT0P1KPE1Fskaut3XUJexO0seZYKyAL0N54/bwl340yvPeNuila7mYzAtmn1xNucdf4EysJK9G8zicYFAMtFFnyQ8Z8GfCdWkIpFhbX8MtTEZ9lNTgdTWcFq4+MO5M3tRWFobr0h2xGVptkbjcH/IwVOJ/0Sye1X84g3pDm9BVE/tliBS+Lc6/CKRmt05XgH2NNcDh6Jb+0HaNdiTykovX9azpem33YriGxdBYCEMqQy/xX1TTHygNxMrph0Bp9dBT29JAbKSxmZ91nw9KbpMz99HbdjTeeyx673d32bCWfL/vuGm9ptSaGn5yI9xQndEf7XytkF1s4KdlDwz9kmSF0ouQUvVlw52yRHdQBZY1rz9CS9RSGduTZ7UR9cnyogbSeienGpl7hi7SUDyS2XnUDPpGrM/uTFT0dSBReZOFqJbF01M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 697a503e-b75d-45ff-332f-08de0a46a9fa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 10:52:54.9532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jyC+WnZOURmm4iENDPajaj/8xTfkW8NLoX1/c9H/s+ScCVwdgwg3MNR+76HpqeYKqYu3AoMsYK6upvRwAApnA/UCb6khfGH+VqNhQl1MXi4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF6998A7572
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_04,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510130049
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxMCBTYWx0ZWRfX/8Zw9Zb+oN5s
 6SMRnAY1rk1OmttROtKu3VVxyy0kBoUCrnBZ4iowWT4Lrhvppg87r4jESiMkpff/9VZtnyzJly1
 uoNlOKvKhWS56T3cWR62hbFEsMoAbwRPO+YOpWDtUaK2atpmm42WiTxRSceF/t/AF6HaN8wBaAO
 +v/D8oIXbu8LY5rhgVYNjPpsiPSC5TsQhOlIL0rxXw3o2G8NBHYjemh8sH7ibaGYCdjJqywGX4y
 Ry5XudefkcdNL5jem5+2SeNb2t78JkuaCEQ6YscdQ1QW+qt/QvZrD5dTOwDcheROjjhFdYKvMBd
 yaI7htiAm78q7ivI2GDjP+9ZhqYioa3XMNJkym5AVGVB2eTt/T+GpifSw+hTMXoIf5ixvelKHg0
 1vCSBka6MZxMNgVju1nN+p0ahpwc+A==
X-Authority-Analysis: v=2.4 cv=V7JwEOni c=1 sm=1 tr=0 ts=68ecda0a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=zuLzuavZAAAA:8 a=yPCof4ZbAAAA:8
 a=c20H_170WQojPfgUF-QA:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: EW0Z-NNbRSIFjx-CKNeJLRImxo2urHRA
X-Proofpoint-GUID: EW0Z-NNbRSIFjx-CKNeJLRImxo2urHRA
X-Rspamd-Server: rspam05
X-Stat-Signature: mhcmwc4bdcbunso78fgp3su8f3m5yufe
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A8EC100003
X-HE-Tag: 1760352795-408241
X-HE-Meta: U2FsdGVkX1+VYvX5L25sFbRTHQSCgrBL9or6BqNHHOk+8oFILVpp12RM2rF664JWgPPt/Oew94DndFOMRSOGjk3KIbsfE8f8+PwXclMpj2BkxfXCya6WVzLG8NdHoRuUc6Tx7zPNSB3pV0PAdVvNmSiopEumnEgsKQ7yQvu8v4rfyJa5NeSzOEdaXJysNZnt3VAZdNlG19XyFoR5qctG0Kuw5Y7pjyhdkMNs6EoKbZuFciNZEcFD65GJm0Wx0jD6pyZsf+3uL8I2Sc9kX7SMWJnWKB5jQNx5hqMANIhlk/XTnaJZozUrQ9lPVCgbIGexSqIEKllfI9VPyO1MV/fVFyT8SmzDm8M8nssA0OJDdQJkfkdNU59+hyLRddKVlqE2eeYw97BWdI3/rq+jBbw4plEdiXUMqJgrdaEKuuefS244rN96eYtQAZJ2IyXmbCRJhSTNOOl3MJzbZdE3rXr3VVM4TrKYMMGwJedvkIQlfWdBMadxzOqumtiyBu2p3Kke7u6Fb4nq98x64+v6rLnF6dNoKhCbew+m/LttJUixastdmUiwdFZoYoOBPZEto9q21wGE4yv72FI2Sp7MN6eAQykfESzn1Jw7CMQUYBWRMV9LBM8cNYxbJYFDT/ETMc4EekrY26low9vkRRvi+vpgoKDSkIDAHfIRH/gpzvxhHsSGzHF00XewjeguN2PUeij0/l5KezEvGp6AhoypQcUAjVZX1cudcJfQCnSQ3CUgY1LYfqmnmgDQY+8s5umRb4qSHpcNmM4xJcv9KYQpCThW5eYLDuLnsN+fJ6e+V48WeNnIZww9HVVVp2tcAjXebpCUzqf7qp1Qm7XXYinB/SClzu8JTcFl9yLiw1XvTuVxcilrQOi8l/KiJhcxSYy1xJmDzx6ER2rvIurHIXCQWz5+TdVZIZWsjl4FFWHglGI92Wli89Wa3fKjL76RnzmeT29j+0WWmO8qv3H9CQSfajX
 yEmgS77i
 BaujzhZX6JNH3snS6ocQNOUfpkSqhN26Q/0L3u7gnXfMcQlicI28Z3knGPI9y9z9lYjxJtfR1d71UxO5AiUDs3RV25zZWnMygQv+jrfs13z3KVf3A/JNZKXVEMEzT7JBjkZq3DJtmgD1oY9x3266Kk3Wcbcj5hJi4KS28/kXvzWOSnoYNQLkvmG015uVxqjqtZR8MI+gI+NrBzYE3dFabjrI6rhDuldhKL+Ag6IJWx0ogFzxktkvl2r6TEK4cyHOmyoqpmguncu1H+79Gdez67LLH/UP+m50eb+YKf1OK92eR06ZiIm1m7Z5pYhwGec/3tkurE8DoralQ+TRnYKCcO0cV7Yj7nMKxSwR85mcubZHmLWTzmdiTboGfa+uT0D50iVKeB0zUPdBrZymhPPVT74J/W1OpU3fxWUYnuocjypOnTK0mis+Mm0FiMnUwMKgaRZvH4nB4NFrbQOFFuJUB8RUoI5cWs+Eoxu2IDsOGGSUQAFjjfdNiqvE2JHgiGxMp92i4HKxIXx04CS+V9zTR69CnksLjU90ElUYrY6wfNNiAxkddn9zxcIILjPa1UNoghtDTfa805YZrvafVRtf72Xmr/BOiTKtN58Vcto1MP0rrwr6x79+za7sqyMa/RswietGfWbQcB7Ogueh5Y9pL+Zn5G9I0Z2ixGQRfv0WCHrBQUhv5t7ezdmfwNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 06, 2025 at 09:49:48AM +0800, Fushuai Wang wrote:
> The __GFP_NOWARN flag was included in GFP_NOWAIT since commit
> 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT"). So
> remove the redundant __GFP_NOWARN flag.
>
> Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b2fc8b626d3d..e7ecf3b608cf 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1054,7 +1054,7 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
>  		 * When this happens, 'page' will likely just be discarded
>  		 * instead of migrated.
>  		 */
> -		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) | __GFP_NOWARN |
> +		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
>  			__GFP_NOMEMALLOC | GFP_NOWAIT,
>  		.nid = target_nid,
>  		.nmask = &allowed_mask,
> --
> 2.36.1
>

