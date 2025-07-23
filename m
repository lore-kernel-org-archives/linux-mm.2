Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 727DDC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 09:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E84A6B0095; Wed, 23 Jul 2025 05:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0376B0096; Wed, 23 Jul 2025 05:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC9316B0098; Wed, 23 Jul 2025 05:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D88476B0095
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:46:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7CFCAC0624
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:46:58 +0000 (UTC)
X-FDA: 83695050516.09.66B8235
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 34FEA20008
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:46:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EF0gcCIm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UsetEjUV;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753264015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DBehcQamNBrXC9uMphoBc/9IlsdeeBPOHiV4P6nC7mA=;
	b=02Iv8EJNV9LSwd7QNleUZxlC7ipKxkO4tiDnM2C7KK22+cODjhiz/02FaMYvdyeo2EQlbY
	RxE0WyQw4N1OSyQV/Yg0aiVv+lZQgJBHRY+pFnhHixa7lsJS4gdbprQa1JtYXXlVePl+aK
	Iheg2iIhl21IpXZWPv0K61Jh7nV0ofI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753264015; a=rsa-sha256;
	cv=pass;
	b=o46UJIinsfP+FA4Mr3kVtHSbDVL3f5jD7p/N+JR93kcOp0xEzeM3EDBo7Ow7R/NHwW7Ww3
	voZ84BTQ8JsqeKhHh5Byc7EULA2efxnlLUcANuOmI3GgZ0ICgoH4qptRuF4sbFPqW9qLNd
	3raRJQo/aRbdpU/WUP9OU4yp3DJACRE=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EF0gcCIm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UsetEjUV;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56N8Ms25002596;
	Wed, 23 Jul 2025 09:46:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DBehcQamNBrXC9uMph
	oBc/9IlsdeeBPOHiV4P6nC7mA=; b=EF0gcCImWquCsqSVJ8WVp5q6bhYT4nquqX
	m+iAEppfEFvBcOcR/e+p5LhJZMZePuEEWTmavYAzf+u+14v22sADHAfwIMY0+ubJ
	lYr4TAK0vPTZSJDaJ+Kf3cwJZsaV93PCzs4oaRJzYM7xTg/CrboHlhF0cIRlXCdP
	HuIOZGWK2sRvBQJFNbjZmlzryQVCwrr9wHtlWPWXBPGtkueCT2v2pWreKXQ0Oe1h
	Kv3xwonIN9kPgrvnekuYArnXvpaa3uUytk5r1797nWiCmy65m+21Kxzacp9wNsYb
	IRZoU5CtiugDEJFGLToNlFDDeBt1H1t8iSDKFoDx2+epnfgk3S1w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48057qyayq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 09:46:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56N87PHB037661;
	Wed, 23 Jul 2025 09:46:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tadmwv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 09:46:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T7t8xhrGIa/amUSXGBILiesONiaqZHiFvellkkKE1cmBPUoVFdD608HSNW1esmPJ4+pV6VsH6JItq8RMlUHBTbzfEN7+2JlWiOfDlPJKpNjhFdLMGYwHulIa5kG9ZUM13/dcahnj0tiDxT+3QWNP7FjMWzfVEYM6/OZThmOXBpGJ/Eu2h6PgIz4Q6cTAxsaC4/BUvZGJnGI/JOplGcuA3ad68E4QCgYzRt87CxRr5M46QNwRS8b3S0GbfHnN12BGeSneALbF2G+Lr3MOSP3tKoc9984Cb1HyNf8L/ib21u9/PGEaMpa0YQdM3o073+I6kRxFvfRMU1GnmQ4CYkkG6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DBehcQamNBrXC9uMphoBc/9IlsdeeBPOHiV4P6nC7mA=;
 b=WysiUR6g6tWM8C7P6izHzbvTh/dRUvYUUaCsO93tBPCjlV0/s2rB9T3IjEwamaLPhMhfTm3N12DFM9T28zxCatsnecv4guUd+C+MjPXdUyDeGVgddcbknE3on7JWCgQTvwIlZNros7vik+6Eu2oXumeqx21+YYqNP1bSUGhj2uULDzjogRa2DMSI6UjmN5KdSAyU2knpsxSZxEf6DOjnJnByUD0Jp3Wkr+Xv+uF9QImxuRylpZeAMuZ26SQREcRG0RnYfy50Xp1tpGZ1IgEYxF30Qtsrxym9lAkWYA63cmjJWdyWieCG3UNbjpWOnlKJ3f1QVsqzohkvRWy4DesmLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBehcQamNBrXC9uMphoBc/9IlsdeeBPOHiV4P6nC7mA=;
 b=UsetEjUV4aW/fDCb/0xV4V4L4+1RxfuJ94w6M7hzY+hUSGu5oKV5oVf0ql8XTqv6MR3JMcSKk83utSBKiM9j8OoQWhcXauy9de+tbGWr78NTkuFXREJ/7RrOQaaJd7PkDCanvFecVxAGXqfvycPAqzlQmxAuQ0vtqtglkFvZSUU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM6PR10MB4282.namprd10.prod.outlook.com (2603:10b6:5:222::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 23 Jul
 2025 09:46:46 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 09:46:46 +0000
Date: Wed, 23 Jul 2025 10:46:44 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH] MAINTAINERS: rename MM to MM MISC, add missing files
Message-ID: <1feb8f0f-ff49-4a82-ae07-21a91918e5e7@lucifer.local>
References: <20250722192704.164758-1-lorenzo.stoakes@oracle.com>
 <66daf9db-ce97-4345-886c-3f8ab111b4fc@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66daf9db-ce97-4345-886c-3f8ab111b4fc@suse.cz>
X-ClientProxiedBy: LO3P123CA0009.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM6PR10MB4282:EE_
X-MS-Office365-Filtering-Correlation-Id: 768dd468-f1b7-4b56-25d5-08ddc9cdd6c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JMuQSKa0eQFWIGqcMF4aWRiN2HijA7Xj7R3c2UEbNQpJ7QiuJ8gsEzLuzzvi?=
 =?us-ascii?Q?5seA8HqdzzCats2Ig+iJHPRTcymcc6FKcohcP3MbTif+NxCCXEiYlrbsk0Kd?=
 =?us-ascii?Q?KndpPtGLEAAHM68gEd3c0RuPV5FGEGpyz5T4KzAYTPqlN67EA7nLMXYJZdlt?=
 =?us-ascii?Q?G6Mc2oqvTXBRdRG80Ig1v+bt2cZrQypvCxhmpKfBpTfCDW5Od2US91vjWluz?=
 =?us-ascii?Q?OXzJtXIufBQQVq0CGzvlaWSW4U//h09ltO/7fsdex3Kz2AtOFyobm+6hYai1?=
 =?us-ascii?Q?vgQd5BLMfvttsrmxnd6HMK/h8pe6kS3FmKhUWt5tJSxR657SjBPERHSSDz6c?=
 =?us-ascii?Q?IMATLkZF6WRJwjTbRmAyk0rA1DmwJRwg45jxgWvdPRJsYba93bYxh1Yjw2Ww?=
 =?us-ascii?Q?14RGWMCALkhJ6nZxlRMSnyHcbDAGYYf6hr3hIqQPzZ80eokzBrMERcf+JoRb?=
 =?us-ascii?Q?NHAqfCCiB1Ek1kcrca61BumaOpUFxVUJFlp6HhQLhQZSj3WR1miIzvnKTZbW?=
 =?us-ascii?Q?ike/QWTODAPgNsjPyezi2eu1/9ikCfuT6aIC7SSzk/wHX5SFN6Nx1oPgJZR3?=
 =?us-ascii?Q?AnCXptf7Lwfrz8MunN6H0f1KBPl6DjjCgnZJ/npOFryv9u7AEphlH5LxNaKq?=
 =?us-ascii?Q?2g6uCWOC0J46zZqZWg1N10zQbuMJrlFCrc5z8mtU2lofuPo08sLuu0WFbdNZ?=
 =?us-ascii?Q?9Gy3aCGDCXHdbW13jt6c6573++eKJnrO58da+Le7nARiI+hrkch1IZ9ext+3?=
 =?us-ascii?Q?pccXJVNBpEUSR/nxSTowR40eR+2lth8oiqCJ7G2nEALt4OV1j+CNxSxHL9Tz?=
 =?us-ascii?Q?zRL5T5g0sIr7BA7W32Lntz/ffBBPYNAl5+lKTY2Zr75leUoL3i2NpoYFAL7j?=
 =?us-ascii?Q?FV6f3yxeAT73pYfzpjlfYj29XGNmXVFuajMdk1I8wBZ4z+udiOzZL9KT3bX1?=
 =?us-ascii?Q?hDPXn0CsDR26Zo/YkgrU7jWVxw8M5froYEyrsMfmSruRpuA4rZnx9Mxrzx0S?=
 =?us-ascii?Q?ZJcSgJRKhu720hLenl+wa73dKPXgyc/cKVO46J8goIRnUOOUPlAD7cfH9XkH?=
 =?us-ascii?Q?HV7OKE2o7zc+V3aO6AcQ2afihfkDuDug/AheDbVEY/1W00J/q6FkUmWqR6f5?=
 =?us-ascii?Q?hEzTtHlTxFHlB9SU6R3Q6e7uH+YoBR74Or5P4xnSx/6leSlFmSB4hb7FNaPg?=
 =?us-ascii?Q?qdL4ZCSz42dYuQ2LozVlOqrJ5/1w+zCNxcvU/0hzpPBIL4aHvMakQMal//jU?=
 =?us-ascii?Q?vTmYEN5JG0nBSdAgZ0hs3cGlCo1v31MBubL96emQVUiYk4SCphZ+6whOlSHt?=
 =?us-ascii?Q?GpoE/dZtLUxsiQ0VK9dEWveoLsohkJ3IXo2sZNxu6xwIqzzNALrscS2UsfzR?=
 =?us-ascii?Q?/gwLMePYdw2eBsv8koNjJUZzDsSt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?moMAF/R2kqCO7ftCmoFVr6DjgHSJ3KATj8apFcBL9Gh9uaHt9UwhbY3JpALh?=
 =?us-ascii?Q?LvQ3ABlSMA0n+HiO9cvV0AZ1EPJyto6MJ8HqsTTIGd+vAcKCJaqEji9Xldfm?=
 =?us-ascii?Q?JNCr9ElQ2EvfCWxKQx9yHmhm2zuv1sWmQnu/BzNAXfanX2WmMWP/646r3ALM?=
 =?us-ascii?Q?L4lv/4AymVGndEFfGpMPAcNUU4VyZW85E0d2WYfZru/IH2yxr1iNVZQ8DPlR?=
 =?us-ascii?Q?KvFxJamX801kuRTSqcbi5yggmNC96YRpZaymAsVeLX/3N5KZGKFfXmcHrSyA?=
 =?us-ascii?Q?aApx+cvadohqc2fLaknyfCMxZMnT/0Uj9uJBBBuTrtKpuHoGdEI5Ncz0k/JW?=
 =?us-ascii?Q?w4HJNDRwettcNZO+/G7w2ASSdoKYKehMYO1IAiQE/2qCP7JMHEUUt+FT9wS/?=
 =?us-ascii?Q?jS2tYBr3OedQ3R987Yfb3NnTQkic/8BSfWH9zqCeE8tEqf3Ms1nyBSec8DsQ?=
 =?us-ascii?Q?xe9BJH/EQgEY4oD3Rayr4ammHPlKNe6pmg8s+mCkjMikecJJYqyXQmxu/8iz?=
 =?us-ascii?Q?2nFSt5gRWsZxsUoDcijaKW56IxveSWaHFKI72WpQHWRdE6zILwAYB5mgonMx?=
 =?us-ascii?Q?XZ3pBMJuu+5TeTghf3W7YLYoJggFF97Es0RUj7GIYCwGojGUNM73OfsQWVeo?=
 =?us-ascii?Q?HDiFVTLmn2C5AR8eSUF1RrsjYqMPop3wnyI8s5GL800qkq4Jm42C/yMl1t34?=
 =?us-ascii?Q?ns7Sh5mJkWnFyuiWHNn/s8FV92lhZozkFIhzB39CC5sx7DH69mrydV9LHmyc?=
 =?us-ascii?Q?B5KytK0QAouphs6QgC/7Y6X6BhOXOAtvXCFnBGOpbvs8z1fdzUf4THIw9Vw4?=
 =?us-ascii?Q?J4vfYykdvX5tbDIByw8eEabrbZm+/KFpZQlL4ywmkX32YaIFIGdU4xCAVOaj?=
 =?us-ascii?Q?dmBdPcJvfCND9EMRVwHy6Xk0hPI7/EKN/tEIUiCC+2Uh0+LiwV7NbvZMnp0w?=
 =?us-ascii?Q?7m+B2zZT63wOTuSLN/UhuiiWoaC0Jj0KIpLA2Sbfam9FPKRPuq3LkBMq0gVj?=
 =?us-ascii?Q?Few9GFYJku+LrVhU3tlHeh0QSYCqA7sPCSj5kYhfsyquwaNbWcAMSp5QdOUv?=
 =?us-ascii?Q?zT/oloAQNR+9hs16RiQKSShh4vRuhaYcWXWS4BHmzB6XQl5gCUuFDaO9Js7w?=
 =?us-ascii?Q?mAUP0gyPm0gf25yu+TCvnWfoIsCc/0zoXmakupqGIUvuOtyuXmcET140sjTD?=
 =?us-ascii?Q?PuglXglEE0wkQXG06ARdfszB1lIGSVkK5mcv8aRVjHSWGSHOBSzRvCTsYIQu?=
 =?us-ascii?Q?+K+MQFzhMmcsTkF2B9GMSFcZzpkFAXUcFYajDG/luPlRQPBQDcLhy131R9wU?=
 =?us-ascii?Q?ileCc73S4PGeIjNA8sZFgSQjWbvCkhcDVhVnhXiRwsV88NFVjP2nWeuhAnKM?=
 =?us-ascii?Q?43I6zb2iK/L8tOnFbes9mmJdtUczFIT7jHBMoDIBh1n5khBtUCJiLL6uY4pH?=
 =?us-ascii?Q?k3CGwU9WPg+IccBZFILyX/kSa16nTAPgbqsr+/r7glMzDK8f/L4txSuIQfhE?=
 =?us-ascii?Q?Kxaz75QHe6Cny52Tv+xCaMupreOnrOrTB6MRIgQXygO2Uf0o+MvaAxzVGpjv?=
 =?us-ascii?Q?x2tT/MEp8XmIpkbrMSx/DBB8VV/EtqtK1APuPxUsfT8W1HTvn2Jgb7iUNncT?=
 =?us-ascii?Q?/g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AH78rFSpo9DiXlHTd2hz21XYPmjKSAfUE7jBV5NC3zpU3I8qdZoKZt41e02wVQdQJ2baR++rA0ErIL1LAW+c2N8Kdam11w73GymqhdeHCqXb7/Jpyh4/cQToNMHSS0odqJymIrJbhvBHNJVZpiLJGAzdTSYxwIaR0hSIXre5QqKYpLuxKffGNqZJE4dEX+RXFtupyHvkDQIWo794caa4VJkZGfJIGlHC6b+oFcxGXndEVfX5NhmyqzFfPKCYyRAcj/hldDo51Dq9iWML3v0XLF4bWeB5olEfouslpvoA9Q9eAzr8ZxZWjPabzYTiCPInYPMIWVr5sx7vIOyqgjmfVfUdMHlqAwVARdz50OFbMTIgEqqEEDVCT3NvFPCkgw1i2FxxSpfcC12n+YBzl2triZSGQmuSnTedEP5N8A9MfU3Kl9mbJcEIvAS+57yjA2RAdNVwkXzD4M3Wk6ViBF3l0DqXAPDBilib8KkJ1MF2nVFTfoFO9cRDqdQH7OHJNOy992i+fW96H8e+cHp274+zKk1Il9x9wqhqtlemdQ4iA2OhNh/mqgPaqYiC1SOLB239qXRo81EsVg3EdOzQ2X7l/agGZ+Yjv1ViO4kKC0N/Rsc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 768dd468-f1b7-4b56-25d5-08ddc9cdd6c5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 09:46:46.5848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DG6cLlT2azZoNu00/+hW2K8coO3qElcx/tfoRvxS0E7D7IKUAn8uhIII5ETqkQ34DFyvf/ZWK0c8XfSM8AZVno+2FaUBlaNsgB7ob9VHAqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4282
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_01,2025-07-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507230081
X-Authority-Analysis: v=2.4 cv=MNRgmNZl c=1 sm=1 tr=0 ts=6880af8a b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=1-S1nHsFAAAA:8 a=Z4Rwk6OoAAAA:8
 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=iox4zFpeAAAA:8 a=37rDS-QxAAAA:8
 a=W0AEHhZxnHpuk4u8SUoA:9 a=CjuIK1q_8ugA:10 a=gK44uIRsrOYWoX5St5dO:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=WzC6qhA0u3u7Ye7llzcV:22 a=k1Nq6YrhK2t884LQW06G:22
 cc=ntf awl=host:12062
X-Proofpoint-ORIG-GUID: zN8ALQ-7CSRbDik_f8Vf_EctgWCYJL4z
X-Proofpoint-GUID: zN8ALQ-7CSRbDik_f8Vf_EctgWCYJL4z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDA4MiBTYWx0ZWRfX6LTRVH9fWrDm
 cObWQqpiN5GW1W3mD9/LPWBUkJ8fVQlzA4B7n8iZ421T4v4nNdhCvu1U/FtzVznck50Obb+4Mj+
 tl/kinAFc/n2omdTxaq2EeisUKgfq7DaPeV+W7tYn2NH2P6MmO9FwZZAH7xr2YemewFtor/pLzT
 lAXok0+6FtJ+lnsChuy0UZgpy7HknXuJLnGH/g1AQD5m47eWdzp/gMVjJyosRth6PmOavRxQv8f
 43OkHctoYpQ3d5M4MFdiT3twndua9kqbfWSJRqS4tTFEwtXfD8AWfb/3fQrATQ4YRs86UnxYLtu
 8+VNxwDykV0hebYgnEi3fI9MokOsOtU8WUXdZ00hPLJ5WE5nq2+hsqj0WU2MXfTE99llm1zn0uO
 I8xTZ6+zqxqw1pSk7cpkvCm194VHJNCYtY3tmSmD0844elWRRfdsXgEyGE4xE67NfuXW/gyC
X-Stat-Signature: fb5cazops1fmkftt7x9radksfmrga41x
X-Rspamd-Queue-Id: 34FEA20008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753264015-869093
X-HE-Meta: U2FsdGVkX19HnnDx7JveiSybA0glPxIVmKkUorzFeB2FHUFpbAVKpqUnq+xuAp9j6OY0HKIq5La1MscPmkwUcROatdSZPTof5E7JGdKWcNRAsHEo3kY2EwFD6OBoYx/5BYJGXOKwwdgfTiKGEMrbByhINiPpEk163hRpXfU5tVZeDwPNOwIeJiZLJ3fhk/3NKacr24rPhRj06nwge62YZH+UpLIZokRrJjw/tBYk3GbKFmrHypGJ8cvlXxLGUmk20VWiZtPqlE1jpxZ8kN625Ep+UCHB9parT6vSD+LERS16WedQ9166DmTcDbO/oR7pIiQQhRAku8G7A6egK2I0eVPY2BXgteZePOASCQA6KKRer5pISbEOALyr7JKwZRs3PYcXd5Hrc0umEBpbFT+47XYZZC7cULXUvEd1k4tIh7U/cbXBP3ZIOYcSYdZV3e38ipMnu6s4eNSNF7U1sbg8DGFo3c3/+ozIdsB/wLlM++wqu0cQbHW19jMP7nwIGEnKWONFnGuelmDZxL8bIqCsVwK9p2+ld53SSHl19oeyv5VjXFDT1UfWt8JNXJAVdTIfxzymgA5KPmO+xWG9XUAcXPGMog7mwuHe8KZM6j2ATZTGDO/ZrevA9DWnNLGIR6WebNU1X76H8GkEISsWd5ljugzxL7mSvMqL8Yg5WPI5XlC6rndyj2dAU468MTzIr4RmpZfaI4oDLvwicajG6SpXG1zRj6i894qlADX7wxqUyELu2R4dGTpluJY1Lt8hJzOIq4j9jamfEFsDp7Kn5s5BVtbiJaUEIdL563sIZU9cuT1dHIh5hOziC9dXdB499ddeqMRmF1W04owMTrQc5joawaEc6DNgwSsYU7O90XCKcBzJExdplnKbWxxjaDlw/1nerkahr5FJB878gI1EuyvGOax3LeKygnFWtieBNUZyNY/QeAChRnWVMhdXfttmklgKWd/0k2TpdpHGaWIiwdo
 V4lKxlEO
 N7UIU2aZfjEEhFgE/F0FLXSbBT57y6WzcpVMTjDRcpK5LTsQnUYgTaBPKGigiJ5TTBeq/zEpFOL1d/b08rDyeRkhpvtDEl/D3G2F6p0bDyR0+ysjeUMwuhOHil0Lu4rx/YNNuzhR4dBC34NBE2uQw3JxFdaRY8THSEjLny+kD802ly91pnjgSKfIRAZjwqzLm/5re0nPlN09i7bw1B0z1MibTWOscCSYZ7iyaOnKQI+ftWTXdyRSpKMtJCC6RCghJXeT46A3xOJe2l4WpL2W/ZLljmBNcHIGnpjpSVgB2cYwFcPQJSWFfJ0wnmUK1SQ0FVUX+5sbEBNQeu2dCgIvf1okpvcpigYiuGH6heGtQ988kVngleAv1HaCELIh/wq0vh5YmpUEGS1i46WuHD0z0EVs/b2uX2qjetVt22kM+C1hUC0O7kR/2nfN78ZFrGupqNc3UuYsTSdgbhw5OgX8wkhIhGwSnst/+bvUvKMOHxF6G61CM2uY7R+ttzuwnddbd0lke++O7bSW1IWtSr1ni5wpa7tCICiNWN5e+jHNrC5eBbKciFDkiDAmwVAXPwN+1kpUOlHGz9/gUFX6x3YH8G53YnxWk7WWE4rlNttOXsHW9tFZSoQH8NaVz69yLywqx5VTPcovohkU8zQvtmiSsVG6E/jdzXG4Gv+XF3fVjxxJrCuPlRrFwHsQXBE6H+u4jbCWU0KwbFnSGPqsfo1/+mW7aY3QnXmpllJT/a38BCs8A+UVc6IkSefVJSKgD8Fs5U3xs7YNGmXkLqNbdTRbeepwAf4//r35hvHrpYFqlX7E2PBngemRBRbV1yxOR2Gpo/+G0Sf9PR8GhWAcFjggnF/9aYHC4VVsh3zqHiwW6td5ygcT6uFOMGQ/B0mPy6XJA360qTACzKO60w+MgYIV6Q+SATS/Y/sA/+Iaevq+GIGt9HPIgQy2Q9GkkR82mKyEkP6+Oo0E1fGbUuxsOuSvQY4WaOyp7
 beCrM44Q
 OLnFJsZsIn9+5zX8WZ4Nf30a/thQOTpk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 11:42:09AM +0200, Vlastimil Babka wrote:
> On 7/22/25 21:27, Lorenzo Stoakes wrote:
> > To fit in with other sections within MAINTAINERS for memory management
> > files, rename the MEMORY MANAGEMENT section to MEMORY MANAGEMENT - MISC to
> > contain files that are not described by other sections.
> >
> > We also add missing files to MEMORY MANAGEMENT - MISC and MEMORY MANAGEMENT
> > - CORE sections.
> >
> > Move over appropriate files to the core section, and in both sections add
> > remaining missing files. At this point, with the other recent MAINTAINERS
> > changes, this should now mean that every memory management-related file has
> > a section and assigned maintainers/reviewers.
> >
> > For the time being, we maintain catch-all mm/ and tools/mm/ entries for MM
>
> This...
>
> > - MISC, though in future we may wish to remove these to make it obvious
> > when files don't have assigned entries.
> >
> > Finally, we copy across the maintainers/reviewers from MEMORY MANAGEMENT -
> > CORE to MEMORY MANAGEMENT - MISC, as it seems the two are sufficiently
> > related for this to be sensible.
>
> ... together with this means the pre-existing reviewers of CORE will now get
> CC'd on everything under mm/ - I'm not sure if this consequence was apparent
> and wanted, so pointing that out. Myself, as long as whole mm/ is there, I'd
> rather not be one of the R: purely for volume reasons. The misc files
> themselves would have been fine.

Hmm, I wrongly assumed it would act as a catch all for stuff not covered
elsewhere, but obviously you're right it will. OK will respin and put MM
section back just for this purpose.

>
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >
> > Andrew - apologies, but there will likely be some small conflicts here
> > given other MAINTAINERS patches move stuff from the MEMORY MANAGEMENT
> > section too.
> >
> > I kept patches separate in case one ends up having push-back we can still
> > have the rest putting missing files in place.
> >
> > Note that we also have [0] going through the slab tree, as it seemed a more
> > suitable place to do that change to minimise conflicts on that front.
> >
> > [0]: https://lore.kernel.org/all/20250722175901.152272-1-lorenzo.stoakes@oracle.com/
> >
> > REVIEWERS NOTES:
> >
> > This is based on discussions had in [1] both about this newly renamed
> > section and where David indicated he was open to maintainership of the misc
> > section.
> >
> > I am sending un-RFC'd as, while a lot of files being moved about, it seems
> > relatively safe to put these files in core/misc and we can move them around
> > later if necessary.
> >
> > Additionally, on the reviewers being added, these files are broadly files
> > that could have been placed in the 'core' section, so this is more or less
> > an administrative decision to split into two and so it seems reasonable to
> > maintain the same list of people.
> >
> > Apologies if this is overly presumptuous, the intent here is for us to
> > finally reach a point (with the other patches applied) where (as far as I
> > can tell) every memory management-related file should now have MAINTAINERS
> > entries.
> >
> > [1]: https://lore.kernel.org/all/20250616203844.566056-1-lorenzo.stoakes@oracle.com/
> >
> >  MAINTAINERS | 82 +++++++++++++++++++++++++++++++++++++----------------
> >  1 file changed, 57 insertions(+), 25 deletions(-)
> >
>
> <trim>
>
> > +MEMORY MANAGEMENT - MISC
> > +M:	Andrew Morton <akpm@linux-foundation.org>
> > +M:	David Hildenbrand <david@redhat.com>
> > +R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > +R:	Liam R. Howlett <Liam.Howlett@oracle.com>
> > +R:	Vlastimil Babka <vbabka@suse.cz>
> > +R:	Mike Rapoport <rppt@kernel.org>
> > +R:	Suren Baghdasaryan <surenb@google.com>
> > +R:	Michal Hocko <mhocko@suse.com>
> > +L:	linux-mm@kvack.org
> > +S:	Maintained
> > +W:	http://www.linux-mm.org
> > +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > +F:	Documentation/admin-guide/mm/
> > +F:	Documentation/mm/
> > +F:	include/linux/memory-tiers.h
> > +F:	include/linux/mempolicy.h
> > +F:	include/linux/mempool.h
> > +F:	include/linux/memremap.h
>
> Weren't a bunch of these moved to other sections already?

Yeah this was a product of doing the patches separately.

Andrew sorted it out.

The respin should be ok for this, modulo stuff that's not merged yet (a couple
patches where I had to fixup).

>
> > +F:	include/linux/mmu_notifier.h
> > +F:	include/trace/events/ksm.h
> > +F:	mm/
> > +F:	mm/backing-dev.c
> > +F:	mm/cma.c
> > +F:	mm/cma_debug.c
> > +F:	mm/cma_sysfs.c
> > +F:	mm/dmapool.c
> > +F:	mm/dmapool_test.c
> > +F:	mm/early_ioremap.c
> > +F:	mm/fadvise.c
> > +F:	mm/io-mapping.c
> > +F:	mm/ioremap.c
> > +F:	mm/mapping_dirty_helpers.c
> > +F:	mm/memory-tiers.c
> > +F:	mm/mmu_notifier.c
> > +F:	mm/page_idle.c
> > +F:	mm/pgalloc-track.h
> > +F:	mm/process_vm_access.c
> > +F:	mm/ptdump.c
> > +F:	tools/mm/
> > +F:	tools/testing/selftests/mm/
> > +
> >  MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
> >  M:	Andrew Morton <akpm@linux-foundation.org>
> >  M:	Mike Rapoport <rppt@kernel.org>
> > --
> > 2.50.1
>

