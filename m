Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE370D5E125
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 11:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39A666B0005; Tue, 16 Dec 2025 06:11:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3482A6B0089; Tue, 16 Dec 2025 06:11:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F2D16B008A; Tue, 16 Dec 2025 06:11:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 053726B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:11:27 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D8C21605C2
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:11:26 +0000 (UTC)
X-FDA: 84225068172.26.FB7850A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2B3468000E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:11:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TQ07whHH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SHKr3e4H;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765883483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmXNA8MEqX4J/vV/0ZeP/J2l/jwj3pr8pBUu+SsGjcc=;
	b=fcifocMXrcmME/W3FKDkub682AmXhwDnuBQS8LOiXJ/qBhK5TXC6ilYrfp0SyCvrO1U4wg
	CrRLEXYa4UYR223pv2hZFGtzRHkM/cudadiCzlEG2+B6iX9OVwCmF9+H4QhbBm6uchzjzH
	tyc+yEz67MyXY76pG14gTirKep0/v9U=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TQ07whHH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SHKr3e4H;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765883483; a=rsa-sha256;
	cv=pass;
	b=HDVKJ5JeFHO/7oTrbJOkkOqvS05JK1vkBk2479GPv/HI79d/pA8/XV8QU4V/e3R419srhy
	r+2ZKDYdb5buKx5AKC+egL1Ndl6SbJpbV/chfGKcNLRheMVsLBggimF+qSnJS7mlatTEW1
	Quo0uwmgitHreNWoH5IjjYduyVwEgAI=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BGArpXd204572;
	Tue, 16 Dec 2025 11:11:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=kmXNA8MEqX4J/vV/0Z
	eP/J2l/jwj3pr8pBUu+SsGjcc=; b=TQ07whHHBHJIQUJ2iev0b7I6vgJE47dHsO
	ggYFvb8siA2GUrYNksluMnkfR41g6QSo2pCNr0prHlTmsPYqb9FAXZeHzgpZMmNq
	VZwN2U98LHQI1TV4M5N8nS6Fyf+6e7WB0qVJ4yyZkfTMmqB2/GljqvbNgdNt3pZ+
	9AhqakckcQLMJrn8eMUpYm+LlrMAhYWhJjQIRniTjA8bFZy6gJJAdSZht1hp1mFJ
	9Nhf4v4TQvMxciPwDuG74yoYpCuUSoiG5F0/kXeSOVFTM7kk+tdNzgHWsKBPtOAy
	MrMy1CUIjdQy91v0IO6WqY6VU+07NRq5HPXH2owI9YPrkE9SxHWw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0y28btfw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Dec 2025 11:11:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BG9O2BU006015;
	Tue, 16 Dec 2025 11:11:03 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011059.outbound.protection.outlook.com [52.101.62.59])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkd4d7p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Dec 2025 11:11:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ILUpwoK90NUZiDiO83bi5lPKzd4boMguZxj8n7Doo/VLtGicpcwf9iWh17LkhZIG7AcG2JvCjgQUJrrEiM0Jq7cP+mBKqWjOp/DohgbWSsU5wpViTz4Cd+hoAzRFi0iCdV5HEFCaZ+EURM9iJOyJbsZjLfAaFYYRGIdafDOZ9QT6Ar4rfboHRxeysIcWhw943crlr1AamfntrdMfHdCSDXzCo0SuK8E5nbO6J8XubQF8fLQI5KuKqNq4gmjJvLdiWBbo+RL4pcTjsIJA1XS6gc+CuIz3ZAHQkEBtpSwIpo2uBbSbHjC1GNMxhE7fsvxwAfHd8ioiw4s7zns/52SzrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kmXNA8MEqX4J/vV/0ZeP/J2l/jwj3pr8pBUu+SsGjcc=;
 b=OC1Vj2C29YXNUpAX7GAkGPaq3IPjmx0DLR5LlZTvXegam7PwtVOcpj/bbbRFCnWzMGpD2JcsjbxWme1bJ3ZqFYfkf2AWZF/JQ3s21qeKQsDIvGayqy9oVhRg0l5a8iv6ZkWHFp78VaugsooUGIR3eCslOaRgz0sQPxNdQg7Eu1Z4L6//7BMo+97+LiQFZdZjsbcgNYR/NoDDoRdlmr2TjOlTIAm06R71ZrIwy37E53I5Ft3Ja1NEWaVkdLSP49I9kPzECK3V02hFxB9Px1fesmpUP0ItwnM9m1HZ55AxjBhCSFxepOTjwzL5LKkhRYf8XHVlNOSu226zoIrKs4rQQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmXNA8MEqX4J/vV/0ZeP/J2l/jwj3pr8pBUu+SsGjcc=;
 b=SHKr3e4HhbnAnOGR0xlS4Cy9DALGOfpoTcgoDyfbqYv+GN5VMC0J1qMIQrxhSrV/YgFWY+xJ0RAxxXXll5/+wOr4t+MM5yt+qVvnmrwILxTv8N0VYoaenC2aLWV4CCxHKVECvxh+jwvI2NJP8ZzAvTHaRieOBwXX4/yeHHePNgw=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA0PR10MB7372.namprd10.prod.outlook.com (2603:10b6:208:40f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 11:11:01 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 11:11:01 +0000
Date: Tue, 16 Dec 2025 11:11:01 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
        will@kernel.org, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
        willy@infradead.org, baohua@kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] arm64: mm: support batch clearing of the young
 flag for large folios
Message-ID: <671ac450-4a59-4e26-b098-7cf65add1e75@lucifer.local>
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <e10f876ce130134fa089befe83f30561b48b9889.1765439380.git.baolin.wang@linux.alibaba.com>
 <5039c6a2-09b6-4c9b-accb-26583ba120db@lucifer.local>
 <1a0001cd-c38d-403b-b3ef-d19e85acd772@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a0001cd-c38d-403b-b3ef-d19e85acd772@linux.alibaba.com>
X-ClientProxiedBy: LO2P265CA0208.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::28) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA0PR10MB7372:EE_
X-MS-Office365-Filtering-Correlation-Id: 53a027c2-a97c-4fa3-e8f5-08de3c93cbcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?78ZIg+qFIfnmw5LGTg8FtCKdanKf3BRhyTiZSfft4uxt6EPQyIFZwZdQMPBg?=
 =?us-ascii?Q?hWr/BF0PVw6304Ntc/K7o8Bx/wC6F7+ZZtIOK8a0sB0jWQaOy/5o+2/O6bsL?=
 =?us-ascii?Q?Gyxog794zMq3kpoowQp7BJSifRbKlwaI0m8WyRvPp5Mk1jrz6Lf7tYOlWLWI?=
 =?us-ascii?Q?pLGawjDaq/pr395OvA1eKVK2xjwJKZJ3icgLJE5E77Iw/AI0K2iOIOmgr95e?=
 =?us-ascii?Q?TRoF8u6CL4yk8cXainUc6ij1cDNHcBK/pQ7TQ/E253qhYuoV1bxwu430uk75?=
 =?us-ascii?Q?jd0dAo2/bcHR4iK3LfZt8V0U2gfam3jBdzeP6MyKkar9so7OyhODp5NK2hCd?=
 =?us-ascii?Q?rUPSjZabJV8VsAAcW7NWWVdWWqM8zi7Co1CKr0aDYz66upUyepVldxjehFH5?=
 =?us-ascii?Q?v1j9GycBjSd3RVJ0RZbercOHok8MKzlh0SG9rUKeUoY+qb6WxnGVSNYJcZFP?=
 =?us-ascii?Q?ioMpbsXy6wR/gyGJ+q+Yrwum4UEZqtlnyYiuHtNfEmZxnSKO2HJ8IprCpH52?=
 =?us-ascii?Q?4vW/U9xvbZYA/ZnuCAgFD0S6Z/qWEmyg5yZ9+rSXsIadf2BCccFbSTwTDOil?=
 =?us-ascii?Q?u6SK6ssMN7KI6po9sZU+VL31j3Or9BGfc+TpNejioU4EgrRrfI5KtDUarN4q?=
 =?us-ascii?Q?lhy7ULLeDu79UWHZubxI1iVWGPEPuRlQxvJC+459wJWB9rzKwsuNG5tU5l9z?=
 =?us-ascii?Q?8I/EV387WQa2ZuNXRt+cZhGsgap/j5/5MtkaabowE8TPBhgJF+pQAvFSJaPb?=
 =?us-ascii?Q?zLFTKDHgMhV18wwttGCkGLI7gbtI1/4Sf01xZc0WPAHwn0hDOOHBhZehN9IL?=
 =?us-ascii?Q?PMY4qh8wPnq4toNBk3mNG9vd4ILf5wb72gv5MHmE67aTnpjMUbV1LOtD4GHJ?=
 =?us-ascii?Q?wzhdJ5iF6UYt8Z7lwGJtoKtX4XkVY6/wAtQwfcLVCVhxvUrjvfbiEYGkBun9?=
 =?us-ascii?Q?pFUPR8bWPbIsd5pn8rMeu+CkhSt/ItfOzWcPxaSEVFo4amz7fGpvpqcfW9z/?=
 =?us-ascii?Q?StxxV3fo/13WZykbdRsvairKwCtHGRaYkTpAsSwBn9Wsn4CWklRsi9+r/6hB?=
 =?us-ascii?Q?c7m3T9SeAhi07LtwSaCCBdVKXHa1UjVlFxUPP8FW8skVeVcGjF5EtDvCGMPz?=
 =?us-ascii?Q?CwCk4BB+i9tod1ImybiDmut4YqC2y9YN5kf8CJoaue8uFFmh/XGIEf55F4dl?=
 =?us-ascii?Q?5fArpKG2DRcCpdRcmv3F1XgrRs+plF63jwruz7eZCmcU3MX4Tc51GgWTvibK?=
 =?us-ascii?Q?atN7TzRS3ICFZ3SkLtmJVfZ6r/NHWkY/VCS6fI182w0LrN39bH+Spr1d08jO?=
 =?us-ascii?Q?+o8Rco+RS6kuLj0GlpdbZu4kRri4Kl5X4f2TIUDD3G7agnpoW2LXG4pbri85?=
 =?us-ascii?Q?JzYDAM1zx593usoEc0c8k5g/kb4Rrs4vkmVUpkLPXRZpopY/HNNFlESf8IMp?=
 =?us-ascii?Q?3mzG/dcBO4Y22cm0eumatO6cQN+Cgz7X?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Hx4ZVzPqY2/1r4b4j+OJ5Ghxnx01Ga9sg9sMjZ2YK3wrDcWqfx26QrxhJ1QG?=
 =?us-ascii?Q?9mWOYB6SqCWe0E4hG+m01RH9AudegcoSICBY8xI/XerwSTJ2EUKsc2hOWapd?=
 =?us-ascii?Q?/QQr6i0PDrgbxm9FBsfALHr0MSz+13yS4A+66LfAM0wZPKwjdkC3agUGgb4+?=
 =?us-ascii?Q?1Rbujkh7pOZORyH7QaYIgAuGkrX2xLmz7lbnhV2jccQ8PdFUZFIoC5yAbZtN?=
 =?us-ascii?Q?xZfF/IOMxt7xlyeu12uykyhrEfJs0uWR47KzMr21zTNv8PNxu5+lG2osKE0a?=
 =?us-ascii?Q?s98odn9c3m1rM3zVRvGTEjSVmUnEbhmMsysvP3FfwtnMCR1tEdb98XHgD0wy?=
 =?us-ascii?Q?e3xdOuOq0XnbSNc3EY033TyNbhjM5BWMlN1ahp5Nl5z2MiSrMNKuo83X5dIP?=
 =?us-ascii?Q?KJoBVUBefaYKVJA8sLXIlt6EjwHLSjpHDmQ9P8lKVbryUO5/vM21uYWdm6Z1?=
 =?us-ascii?Q?/irzgKY88O4XbMEKG1Hf/PQgmT5pXN4Jvp+NVdLRzyCxq2lfcO7lJ0GMVcsl?=
 =?us-ascii?Q?W7ljW2bm+Q9S6bA/pfW2dCaK/qX5cOvGI+wE8UEi8mXLw4OS7CEXghsg3kFK?=
 =?us-ascii?Q?dVo6wfKlAg/mchSnGFRVfhG0d6rT6QqynzH9BZe2v9adG31ROg/28H/w0/5A?=
 =?us-ascii?Q?CI7U/rWA8w0HG75lSReo2QMEMkRu5VLU1v1lrq4X5duOl6A7ROHte2UrGEY9?=
 =?us-ascii?Q?XqCGjb2CKnYiCQHGcjjl+mvKWUaLsKaYT6mCkwKnMTjfL+t1o3AL/n5mFAqj?=
 =?us-ascii?Q?vW2rlzHOGXChA33aJwHzhf8//f5WUwj1s+haKsvxehHBaCrm3PAaIN6uSaVi?=
 =?us-ascii?Q?E1ZhlCKfQvPA7/GqclMTPGHknhQJ1U/dwbaUqrwB7Q7Sl2Mh29TbiaMl7wNp?=
 =?us-ascii?Q?KGLlvErAJKCQvfgL4eXtbHRfSNNL3neWz5W5P6+LWNXcGREiw97L0rD02BOu?=
 =?us-ascii?Q?KTGJStcVAxQCNICt2Hnb/XM/7q4EB2v9JZhNPZCjR2vdzY4qAQ8epK4TQnoq?=
 =?us-ascii?Q?3v7qa5IeQcRwyTL/9Q5DHsNxXBYkV/dDw16cqXaSvM7s3AqEo9ktMeIxhq81?=
 =?us-ascii?Q?mubrjAyl6uz7g7uDsq4eSEZRVBMmbNoT3LKip5Uf7XT/yRGWogYABVjzlAJ6?=
 =?us-ascii?Q?NUK2u5W2YMJPqTwzlSxho9sKy5r8zYV5n9vtsWcDIdAF0LUHXa4sYIJwutTO?=
 =?us-ascii?Q?L6rIbuHTpSQ8pOlnldlDildSQmh9wJtlDTuzokkRT/r3M7IffHUVCZEC4Ll4?=
 =?us-ascii?Q?4e0RMTjk7RTzFkTUVsYsyY6WIBoejxMn78/tSAHF6QnU91AYEoMTHVusC66G?=
 =?us-ascii?Q?OUChpD+Sr156ulcP3y1qM3BlJtbvrznhpKOtWgjEID0OJS1pVykpQdPzoIZI?=
 =?us-ascii?Q?Nxy/Wr1y9HbfW+WXWjWfnEtDgweYLAY+8uLs5B+lOQdh+2cU7lL4BWiwPavT?=
 =?us-ascii?Q?Kx7dtxK7T2hPPOZ8bqxKybWuHHAmdQd0WNb33AU0E6N6FR+WZ5046r2FHlhQ?=
 =?us-ascii?Q?mcmxbVt6MCgl25QwnXmTVeRX1RTBmNXBs2Uad9N6pMYkLDdoNZCUOYMWPofb?=
 =?us-ascii?Q?6oAhQDueRPt9JrNOwBmH7TTs3II9RHXKBpgb/kTM9LVEQvYDuF7rO7jHqdOl?=
 =?us-ascii?Q?5A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oNOwfalReaN2g1Mgc8iFISAy48l2yWlTzjnnVw+PDtrzO8639D2zDdK7a4WcGxu0JpSULH1shvaO8WU22n0yuIpjlwvVjepvgQrD+uFZ5BEJD8VfG1VXHavXpuzuLkn06QIPamrnCrDOUEl2TEBgzgonirBvYPBEnUn2TuLwl2KGieWZqFO9ZX6RPbm5vA+QAdJqZ+VKcna8FaTvQBBNQItAbg/2b8KwDJ7FhkSoNQCYj+KhSr2MKLZ1s9ay/mavegdTNhrU2rX2G1RDjiIV+78FFmS2V9uk2kmqwjc09R6gHjdCSHHsnSfnpdVKDiOLrAMLT1MrZE4zWJtsz944/V+pf1DIVxlff09tw1ds9zPA+y37NKoucYiKSwfjB69azpGipV06z41NpN7d5l+6+1TJXIq7hsx9i9zZfkZf9KnJxg/1LguKtdCbTxSDLJ2Xd88sTmzyMwKGU3qYczAJN5zjC9DdHl8CIwcOz//25X4+tv2DR/B/fHlHoe03qh8t3bP+p/5uGaQR3SXX3E3jbu9slJ0FBpxegWsYXKPym45k9ikOI2B61Eojq22SZdMpTiq5d3Ha4ZvxdEOIb8qAxXaJbDng4DAT+BGDXYK+iyM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a027c2-a97c-4fa3-e8f5-08de3c93cbcf
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 11:11:01.1195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5M80/fkdViGkXKiT3IzVK3SWQdVRKv5Qj7xQTb/P4e1dZ2krcvJmEW8/2/shcvq8114K+v6F0ZdHcMd6rAITA2f2xCg5TFzn4Z2kILFzyKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7372
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_02,2025-12-15_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512160094
X-Proofpoint-GUID: usNTCxtrdkH3erpBWdr9t6AsipZIaXID
X-Proofpoint-ORIG-GUID: usNTCxtrdkH3erpBWdr9t6AsipZIaXID
X-Authority-Analysis: v=2.4 cv=fOQ0HJae c=1 sm=1 tr=0 ts=69413e49 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=SRrdq9N9AAAA:8 a=f7AKKD2GU1BQZfEi5i0A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE2MDA5NCBTYWx0ZWRfXwgNoWPSYc56t
 DPZ4I6i/Pn5P2qeRQCnID8igNDJT+Jpu3agNsFaCWW+0koAhxI0Jp8dnx4a8vzh/C0HOfhWHpS0
 31l+QVpaqoNbqzIxkJxph0bEiCitxtVT32QNcrnWa38HNmjIWukazKfpALHfSnFaX6zACHYxdUQ
 UNlQUG+Dctj/hy1GCOUe1vw05+GytobUsmgaNBTQ+CUVYenIs9Mi1R0J6DMzyafjjy5yd3yENAG
 10cnOiku9ada8Ka4FWpJvgegCMXICh44iyId264ZoYkgbz3IKKaLqRwUC+qUcHHDuMZ+7oaz4RU
 aw1KgCvP354MRH6XDJ5+A3kY22B48+f72ilHMhDXdb4qjYwst4Gu6sHm0OZhh1drHGcexmVGFsd
 Aklsw49gaqJMOGs3hlIA8ESvUIxyDbmYvCQMH2LyVyyQMoYHA80=
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2B3468000E
X-Stat-Signature: s6ui7ua664twzqgqq8x8z79njhbma9pu
X-HE-Tag: 1765883482-261323
X-HE-Meta: U2FsdGVkX18jRaQWgrh7WvqQVDbzpVF8iewHhkJ/07yNTHvOmLaPpHpaorErHwLhJSBXtdT5/m2UwiZz8M1FBlleELFU5ikD9N5AcSmlm01MjntjqYBORmn1CdEjp3+By5J2F89zvvSEnmtTdUxXPipOEr0vN86jPdHtwd/i/VY5Uw8mnacx+Rj7MsnNXlOCc/y5+7dPSm2q8MI3eJ2TpR5wCzm389nPBmcoaKBgfHYUYGd+6hYtfpMH9SfPw+h717JELWH2azjz1m4+B/YefjLk4DOq7Pvc5jDspMyzuKDV5biDH6tC0As6XCaHCGFdxWwdkDL6JctYAfUv+2mhr3zryrY2Ic7mtgfFFfU82upuNdnRkZEfgSCfbvm+3eu/M90ONcMeov8QmoOiFGwLh+AQ08NYlXyeUA5V3zLW1m3sw33iAgVTXgx42IXw/ru5R9XKnZV3S4NLEEjuHvJHzjYDfNx4kEBZirSVkhvk8bT0kd9/oA3OP6EpysNQQu1IECwa/WRrvtDQWC/2y/Ul+UrWGvpav/f17c78PCei4H/DjsDc66anncn3AYa72Lb+e0FklvBQMv8uOvhLcGAWTy/UJXHIEltQM6jmcQc6wcZii2JtUU+mdUDKrt1oX8duMmdH+aOn1SmjbhTZIFDIkUTPum8SOlLp0gf2d6n9bC4YTv2ggK5L1QnqCz2OH5+dUVOVM+LZW4fXXEhRIjD/6VtcUDHEMt6skDLeHEkE5FgLSduwh9YivERy9eY83RPXoAcL5xo1rqxSE8byb4mrUYZkVUSCYjspS9xSn7XR8s4jcTgKmtlo+3r7xL/KhBJzFR8NhdR2lDgfYZn/kSpHsL5n+3+hYrLpu+p7xcvPDQjb0S/N7aHujKwiR9b104NCL1dabx77R4EuOpCNTvwPgmb5pGCzB32Lg77uUcayf/PaID2qErMZLWI9VO72e573kQA3yN5xgozaMISoUdz
 sKMknHWu
 qKRNA0ojSLIOLnMNUg5rIzbyxHRoEhMOR+S306c/o7eOUd42HhEfDOHZsUREPduHv3/cVTLwEvJYmdlc9ITbxvbL4+DOMDJoOWfflXP2VDH/C/C4Tk+4vg3/5xwWSlH/aOHZJTr4vyHOBlTp1P105Ip0a3uZ58gtNuTyEm15RNE9NaxOf3GqHMh3RM2SznQM4INFxBItnJHArQ2XGMQnCsQhPenFv4krPUfXGQV6P9MC1BrAN+SGabGE7XjK4Ge7kgr1ufdtT4T9X7+mNryuxUWbFAVZydaQUMRK7DbB2TFbYsvDB6jvjZjtA+SGhwopKli8leC2LbofeBkhIKK76VjRlrwv+PUvLufXRPPegzzAxJLvYGslaR9mVs87h2ivdJKb5QxnptVYLEclrfuHTgXiEwpNoBBKlhefGuKpz4+OKbnm9k70Ml810EY+8yi49ImD5hUbNm7F1FqdPWr59AXNrpggMM+CmLQdx4/Z17VIgWvLRWCbAXeJ53YuDqspwUn8bCbnN1oRPpHX1a1ocJSNEwTXToPQvrWJFYaNxPop0b5x/fcEhkIAFgXsp5mScejbKaHTs7/fjWsC20/+8cE1RSRXSD+SCp/+3cwk+hF0CAnxLaRMuGk7UkLOcoojZU3QGdTK4bjfrTYobsM4oGuxObg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 11:32:58AM +0800, Baolin Wang wrote:
>
>
> On 2025/12/15 19:36, Lorenzo Stoakes wrote:
> > On Thu, Dec 11, 2025 at 04:16:54PM +0800, Baolin Wang wrote:
> > > Currently, contpte_ptep_test_and_clear_young() and contpte_ptep_clear_flush_young()
> > > only clear the young flag and flush TLBs for PTEs within the contiguous range.
> > > To support batch PTE operations for other sized large folios in the following
> > > patches, adding a new parameter to specify the number of PTEs.
> > >
> > > While we are at it, rename the functions to maintain consistency with other
> > > contpte_*() functions.
> > >
> > > Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > > ---
> > >   arch/arm64/include/asm/pgtable.h | 12 ++++-----
> > >   arch/arm64/mm/contpte.c          | 44 ++++++++++++++++++++++----------
> > >   2 files changed, 37 insertions(+), 19 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > > index 0944e296dd4a..e03034683156 100644
> > > --- a/arch/arm64/include/asm/pgtable.h
> > > +++ b/arch/arm64/include/asm/pgtable.h
> > > @@ -1679,10 +1679,10 @@ extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
> > >   extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
> > >   				unsigned long addr, pte_t *ptep,
> > >   				unsigned int nr, int full);
> > > -extern int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
> > > -				unsigned long addr, pte_t *ptep);
> > > -extern int contpte_ptep_clear_flush_young(struct vm_area_struct *vma,
> > > -				unsigned long addr, pte_t *ptep);
> > > +extern int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
> > > +				unsigned long addr, pte_t *ptep, unsigned int nr);
> > > +extern int contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
> > > +				unsigned long addr, pte_t *ptep, unsigned int nr);
> >
> > In core mm at least, as a convention, we strip 'extern' from header declarations
> > as we go as they're not necessary.
>
> Sure. I can remove the 'extern'.

Thanks.

>
> > I wonder about this naming convention also. The contpte_xxx_() prefix
> > obviously implies we are operating upon PTEs in the contiguous range, now
> > we are doing something... different and 'nr' is a bit vague.
> >
> > Is it the nr of contiguous ranges? Well in reality it's nr_pages right? But
>
> Yes, 'nr' here means nr_pages, which follows the convention of the
> parameters in contpte_xxx_() functions.

Except you're violating the convention already by doing non-contpte stuff in
contpte functions?

The confusion is between nr of contpte ranges and nr of pages, so I think we
should be explicit.

>
> > now we're not saying they're necessarily contiguous in the sense of contpte...
> >
> > I wonder whether we'd be better off introducing a new function that
> > explicitly has 'batch' or 'batched' in the name, and have the usual
> > contpte_***() stuff and callers that need batching using a new underlying helper?
>
> OK. I get your point. However, this is outside the scope of my patchset.

Well, no, this is review feedback that needs to be addressed, I really don't
like this patch as-is.

So for this to be upstreamable you really need to separate this out.

>
> Perhaps we can clean up all the contpte_xxx_() functions if everyone agrees
> that this is confusing.

I mean, unless Ryan explicitly makes a case for this being fine, I'm inclined to
reject the patch unless we do this.

The contpte logic is already very confusing, and this is only adding to it.

>
> > Obviously I defer to Ryan on all this, just my thoughts...
> >
> > >   extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
> > >   				pte_t *ptep, unsigned int nr);
> > >   extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
> > > @@ -1854,7 +1854,7 @@ static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
> > >   	if (likely(!pte_valid_cont(orig_pte)))
> > >   		return __ptep_test_and_clear_young(vma, addr, ptep);
> > >
> > > -	return contpte_ptep_test_and_clear_young(vma, addr, ptep);
> > > +	return contpte_test_and_clear_young_ptes(vma, addr, ptep, CONT_PTES);
> > >   }
> > >
> > >   #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
> > > @@ -1866,7 +1866,7 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
> > >   	if (likely(!pte_valid_cont(orig_pte)))
> > >   		return __ptep_clear_flush_young(vma, addr, ptep);
> > >
> > > -	return contpte_ptep_clear_flush_young(vma, addr, ptep);
> > > +	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
> > >   }
> > >
> > >   #define wrprotect_ptes wrprotect_ptes
> > > diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
> > > index c0557945939c..19b122441be3 100644
> > > --- a/arch/arm64/mm/contpte.c
> > > +++ b/arch/arm64/mm/contpte.c
> > > @@ -488,8 +488,9 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
> > >   }
> > >   EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
> > >
> > > -int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
> > > -					unsigned long addr, pte_t *ptep)
> > > +int contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
> > > +					unsigned long addr, pte_t *ptep,
> > > +					unsigned int nr)
> > >   {
> > >   	/*
> > >   	 * ptep_clear_flush_young() technically requires us to clear the access
> > > @@ -500,39 +501,56 @@ int contpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
> > >   	 * having to unfold.
> > >   	 */
> >
> > Hmm shouldn't you need to update this comment now 'nr' is a thing? E.g.:
> >
> > "And since we only create a contig range when the range is covered by a single
> > folio, we can get away with clearing young for the whole contig range here, so
> > we avoid having to unfold."
>
> I think the original comments are still clear:
> "
> /*
>  * ptep_clear_flush_young() technically requires us to clear the access
>  * flag for a _single_ pte. However, the core-mm code actually tracks
>  * access/dirty per folio, not per page. And since we only create a
>  * contig range when the range is covered by a single folio, we can get
>  * away with clearing young for the whole contig range here, so we avoid
>  * having to unfold.
>  */
> "

Except nr means you can span more than a single contig pte range? So this
comment is no longer applicable as-is?

You've changed the function, the comment needs to change too.

>
> > However now you're allowing for large folios that are not contpte?
> >
> > Overall feeling pretty iffy about implementing this this way.
>
> Please see the above comments, which explain why we should do that.

You haven't explained anything? Maybe I missed it?

Can you explain clearly what nr might actually be in relation to contpte's? I'm
confused even as to the utility here.

Is it batched ranges of contptes? But then why are you trying to see if end is a
contpte + expand the range if so?

>
> > > +	unsigned long start = addr;
> > > +	unsigned long end = start + nr * PAGE_SIZE;
> >
> > So now [addr, addr + nr * PAGE_SIZE) must for sure be within a single PTE
> > table?
>
> Caller has made sure that (see folio_referenced_one()).

You should comment this somehow, I hate this nested assumptions stuff 'function
X which calls function Y which calls function Z makes sure that parameter A
fulfils requirements B but we don't mention it anywhere'.

>
> > >   	int young = 0;
> > >   	int i;
> > >
> > > -	ptep = contpte_align_down(ptep);
> > > -	addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
> > > +	if (pte_cont(__ptep_get(ptep + nr - 1)))
> > > +		end = ALIGN(end, CONT_PTE_SIZE);
> >
> > OK so I guess for PTE_CONT to be set, it must be aligned to CONT_PTE_SIZE,
> > with other PTE entries present there not having PTE_CONT set (Ryan - do
> > correct me if I'm wrong!)
> >
> > I guess then no worry about running off the end of the PTE table here.
> >
> > I wonder about using pte_cont_addr_end() here, but I guess you are not
> > intending to limit to a range here but rather capture the entire contpte
> > range of the end.
>
> Right.
>
> > I don't love that now a function prefixed with contpte_... can have a
> > condition where part of the input range is _not_ a contpte entry, or is
> > specified partially...
>
> Like I said above, this is outside the scope of my patchset. If Ryan also
> thinks we need to do some cleanups for all the contpte_xxx() functions in
> the contpte.c file, we can send a follow-up patchset to rename all the
> contpte_xxx() functions to make it clear.

It's really not outside of the scope of the patch set, this is review feedback
you have to address :) trying not to be a grumpy kernel dev here :>)

In general in the kernel we don't accept confusing patches then defer making
them not-confusing until later.

We review until the series is at the correct standard to be accepted before we
merge.

As always I'm happy to be convinced that I'm mistaken or something's not
necesary, however!

>
> > > -	for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
> > > -		young |= __ptep_test_and_clear_young(vma, addr, ptep);
> > > +	if (pte_cont(__ptep_get(ptep))) {
> > > +		start = ALIGN_DOWN(start, CONT_PTE_SIZE);
> > > +		ptep = contpte_align_down(ptep);
> > > +	}
> > > +
> > > +	nr = (end - start) / PAGE_SIZE;
> >
> > Hm don't love this reuse of input param.
>
> OK. Will use another local variable instead.

Thanks.

>
> >
> > > +	for (i = 0; i < nr; i++, ptep++, start += PAGE_SIZE)
> > > +		young |= __ptep_test_and_clear_young(vma, start, ptep);
> >
> > Again, overall find it a bit iffy that we are essentially overloading the
> > code with non-contpte behaviour.
>
> Let me clarify further: this is the handling logic of the contpte_xxx()
> functions in the contpte.c file. For example, the function
> contpte_set_ptes() has a parameter 'nr', which may be greater than
> CONT_PTES, meaning that it can handle multiple CONT_PTES range sizes of a
> large folio.
>
> It might be a bit confusing, and I understand this is why you want to change
> the 'contpte_' prefix to the 'batch_' prefix. Of course, we can hope Ryan
> can provide some input on this.
>
> Thanks for reviewing.

OK so we have some reeeeal confusion here. And this speaks to the patch needing
work.

This seems to answer what I asked above - basically - are we doing _batches_ of
_contpte_ entries, or are we just accepting arbitrary large folios here and
batching up operations on them, including non-contpte entries.

Presumably from the above you're saying - this is dealing with batches of
contpte entries.

In which case this has to be made _super_ clear. Not just adding an arbitrary
'nr' parameter and letting people guess.

The contpte code is _already_ confusing and somewhat surprising if you're not
aware of it, we need to be going in the other direction.

Thanks, Lorenzo

