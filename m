Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD8D0D3B7D0
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 16:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CC1A6B0006; Sat,  6 Dec 2025 11:48:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1564A6B0007; Sat,  6 Dec 2025 11:48:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11A36B0008; Sat,  6 Dec 2025 11:48:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D6A6E6B0006
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 11:48:14 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE874133E04
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 16:48:14 +0000 (UTC)
X-FDA: 84189628908.11.32D0DBC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 32DDC40010
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 16:48:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=F5NC2o7i;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pI4gQkXs;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765039691; a=rsa-sha256;
	cv=pass;
	b=xd4yR5yWIJusLmBp/+VKZQMjq90zhUzzMt/ghW9T+/p7bBNBfhgkxpDilHT2X+A9ZICB7c
	r1vErMZXNEFuEoi3nNN1dGVXk/bogzzSMGxjvy23AuQc9tMdi8QE8qb4c4kATjfgINGRhT
	NIZIl0BRS2F7qsUlN3JUjJ6LQ3BFAf8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=F5NC2o7i;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pI4gQkXs;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765039691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUrAkDP0oUHkc9dI8kON0TrDeybnD7X8cBmyIrYN+4s=;
	b=oV3zA0nsQQ3qdoX43ZR23xDUOY/Gv3bWwNIx7Og+LkuDg7eXfJD0xKjpLEt4gr6fjtTvMo
	WMI1fDAp/rU9iIDi+2Adh8vtwnGUcwRIfv2IlmySLt4iSK3Wn9kCUiruLRtcUvG/su3JH+
	3aStFbMEb9cQqO4aqB0JhknZd8wa2yo=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B6GCtKw2355996;
	Sat, 6 Dec 2025 16:48:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=yUrAkDP0oUHkc9dI8k
	ON0TrDeybnD7X8cBmyIrYN+4s=; b=F5NC2o7ilW6pGKaq4wz/FfwZLB5o5ZS7tz
	gcqWWkrvU4YkKelXVQWCKaSjwhc38lfuvUxKOAhyUP1sX8FQWcbuJ/1mQmREIc6b
	v9dT4cQhCVepZ/VePjzMrDjelPSxewDfrSOA9GAjmkafH78/9IDp1TDV7cKfAh6q
	q/oRqmkkn909RfFGRJUzVuT+doQBjCOuKcWJuINyk/nkAV8GDWUrxulNmYh4sZ/r
	iGbDdWvVwmFtbn+wqvC499HmauBXcaBrZwiFMrCObppexYzx9Hy1K7GMm+MV0TyN
	1nQV7A+fgDWob4UPiFNhtzYqRtB7giJDO0gXuopiTkLL2ovEhghQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4avqjw80qw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Dec 2025 16:48:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B6D37NG017505;
	Sat, 6 Dec 2025 16:48:04 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010041.outbound.protection.outlook.com [52.101.56.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avax652gn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Dec 2025 16:48:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hkXVCM/A/D6UPB6dmpP0LBoh2qq5Qf3UtJWAJgc1ZL463wTTloCydO2yldBPkXo38PmRdxD/n5YNSpXF9wzbqA3WwZg5Z9pPjjp4nf80eGJJbTpkaBvYGeyVF8g3zrIUY4H9Q6O/5Wp0C5G2a5sArag9mQP/iMiBvLY0vI5+V3hEafUR2BJbvn1e3bkclgzTBh3So3w3mVZzCjV5Ce2lmUfUe7fXKDG2YW9w8F0mhnZ4KCos0TZGXsg9I1F1c8reooSW0EJnIWnwOaTzmYwm7k3D0JWz27to0le+mvCBQzdhC6aEHjyQiH9V865Q1etpLh+Ug4/machJFkJ5BLEpJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yUrAkDP0oUHkc9dI8kON0TrDeybnD7X8cBmyIrYN+4s=;
 b=kPheICIJF7G3RHJw4gjimwCjyoVHu6Wq6q/4mNaqmp7VK9g2k4s3LRkScqo4wI+UhZy2bkT0iA5Jcl4ebCEXFhO1xl/aN80K9HBKu+CUIHL8P6XJBIqrQ4S0Qy+5wwUG3Ptj5h1dmoMCIlAZa46Forjlmss0FlgIql7o+QAAQDuTrWZnRy5tJ2f8b0aNyTFSUGfqL4AtYrDDGLHuEUXGw2WnLSbonZPnMgaYExp7KQyOfDthoEI4rt6i4iRJWVQOt9m0CpqgAxDd7uDDLuwsUNsqUAFLgfLowHF5YQlPM9Vvr4mQGetbvWh3U/9/FDXBq4A+tytfPmwgoO5deNBsTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUrAkDP0oUHkc9dI8kON0TrDeybnD7X8cBmyIrYN+4s=;
 b=pI4gQkXssvPNC3GSnpdybynDkhpORFwPlCHPwIlQ5J/N1JiYCElUd2bGuoUj0ne16b6ULOQO5vyfGTrkxlUwKQGs0PSZ6ULsOEb1HORlCTP8l3stVO54Lt+H6Ffyvc0ZRIrkYPgl9cPgFRTMcb6Alglt/TFiDfOmdPipeQkJdXc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH3PPF7FF16ABD6.namprd10.prod.outlook.com (2603:10b6:518:1::7b0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.13; Sat, 6 Dec
 2025 16:48:01 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9388.003; Sat, 6 Dec 2025
 16:48:00 +0000
Date: Sat, 6 Dec 2025 16:47:58 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        oliver.sang@intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-ID: <01016a4a-eec7-47c6-9932-3eb9e4e42277@lucifer.local>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
 <20251205184342.2cfcc73e@pumpkin>
 <4eea9138-3853-457d-9113-e3caa7f00437@lucifer.local>
 <20251205214940.211a2de2@pumpkin>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205214940.211a2de2@pumpkin>
X-ClientProxiedBy: LO2P265CA0219.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH3PPF7FF16ABD6:EE_
X-MS-Office365-Filtering-Correlation-Id: 92ca3902-27e7-48b3-fe5c-08de34e7374c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1o3ACQ2dy04LTnLfa3nETt/YnPJ4gVeQLnRJ7+OCt5BidSDi6C6rPibYbtIo?=
 =?us-ascii?Q?BeuI3joYs7sEFEsgfiSgoGsqkwdWecGI5CaHS5ZjzH6BkmlSBpoSdA3Gdhn5?=
 =?us-ascii?Q?nNSjkxi1RnuB2KS/TmO76YH8VY1m4MeEeeu4wIxa6tuR5GT4oJcXbVr+vBXx?=
 =?us-ascii?Q?45df0+Iq1Y1niueyak8BWfPibF403iJDwzsyGFzthRIjbAiDorzC3GgPyVBh?=
 =?us-ascii?Q?BKs24Ck2zTVO/SCO9mkKkwjBk2I5wvGo/KdBlcohM0NcAcvkO+GtlHdGq44z?=
 =?us-ascii?Q?/uuK+FUOvKwZolNAjMDL09Rfgf8S+YEicdcZn3BydQQY8wY9VmjJfimRFhBG?=
 =?us-ascii?Q?NkuEy7ag2ImEkmnoPibTWFq50wGHAFGN7BozG6ycZp1r1ByXUyf6NV9fmLF/?=
 =?us-ascii?Q?SqyyQYPqzylk8+8/92ptEHvCdq2iLS4CtZ7EEoPIjc1nWVNRZbSraPQvs8k9?=
 =?us-ascii?Q?1ure9ZEnI4V0EHz/p1RyFGO8dL4YrBkMJ61CSFv6C8kv05zvrwVGAScPNIn3?=
 =?us-ascii?Q?2zTAMEq/z3BXMKMPfjo8sabp2nH5fqJ/zn3Q1qpkdASJDNAiHZ0IyDrh7ksr?=
 =?us-ascii?Q?9Iy6RGcKW0zUpLOjSL7tHRTKAxiakCeJsE+m/rEj9XlH8p0F1O4Gb4+D004A?=
 =?us-ascii?Q?9jdwrxmi1mH48IyRmS/FOD/fe8eKaUgMt6zB5i1TrUzKSqPeT7RyGBggWZcQ?=
 =?us-ascii?Q?asgl6U2PLtoHwql7IO9olawBZB/JTrv00U4zIER/dAjhFQtUptbwJbFXA6B+?=
 =?us-ascii?Q?dCyQnG7jyed45AuPBmM+Gq4FhvKoy5MzsBOh0Il2OJRjQOmiKCPmnqTFgEsl?=
 =?us-ascii?Q?9XSAK+ZiglPKkqpQYKo7RHFGSfv+HeyOAMHb4i9Ht5/9j0LfRlAC7khkzwB1?=
 =?us-ascii?Q?XL7n0lOsgp21zyZYJmHKbmA36uZtvUw/cSSB+CC9w4AG0FEweB9UT5snBVh7?=
 =?us-ascii?Q?Q7yF1GI1puosbmBoxYjCL4mLP9YGFGGPEeMfr/g4SJU+ck16KrBnT37ZefbA?=
 =?us-ascii?Q?+qknfzEaYHN3BcWX3YOvy6aJKiIGF00/IswKI7yfk4ATj/KAnSbWXI5kbycX?=
 =?us-ascii?Q?nMeuEZCneVtrNxEh5hLZi1uJ25qyPjLnhS6wWD6nz9ZN69LBx8n886F5CD9T?=
 =?us-ascii?Q?Z7EdzohGq1VpfxXjg2+4lNUSgP/Z6jxYZVHV9Flgwl0NDvPcjhDPavQNhChG?=
 =?us-ascii?Q?q5vXNAJZHMz3dtxkjFzl/D4Nl1XcSVNHgu+LU8AWZ2mM/s7K5xrgKK0XmAli?=
 =?us-ascii?Q?yaKGeaVEh5ldVY7v688fNNTqvaxQ4AzxhRqJQZYqXnsupoUYWHH05xHy1Zmc?=
 =?us-ascii?Q?V5dJso4qgF0I7amqfCeHJyWB3+qt6oxYJxKL2zJWH2L4XpAKXN2qrhqXCS98?=
 =?us-ascii?Q?07k8A4Bub4vQqfzhQr21SMQQt2TPnWXnBHuWuchmXwzq4d0FB0jUhDNO+ryC?=
 =?us-ascii?Q?elrGCJjiITkGcIsPJaIHfCC8eAHFgVcP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zc1iaRI1lGRKyzmxs0WJO8paovsT/V5lQagpsoYS2czKvzsRtfJOg5NasZnu?=
 =?us-ascii?Q?4sW33eynguYpFEJF46lUKR2+KD0wPl+2qqNgDuJn29D7U/wsOXS5AuIzBbdm?=
 =?us-ascii?Q?U1vV0r60LafwMeU9M2D9BgBK8JWLuehXZ/9xzk2vyZRxe16RDbmp9zUZmVSR?=
 =?us-ascii?Q?oUWEa98P76F7nLy82ajqJLzGRZ6o/PJYO48uhx3uyES7Xr1a5HSoDQfBZVAS?=
 =?us-ascii?Q?ZMS29+vlo292aEbuRh8E9QpG0oWWG83GtYVJQvG3QGue1XyPtp2GfLsY1ncG?=
 =?us-ascii?Q?DzKiKJlnxsrTkKdPXYBxCcmDL9OfPmuENXeVH1zgmyAFxEBuX74Bdxkh1nKW?=
 =?us-ascii?Q?LBi8Bxd/Bysm8e/pTxTXWGWpqRMnJ10Jz6Jq6Np6oevrifGSg4CT5/U0rJ9T?=
 =?us-ascii?Q?mKp9SoBGeXa5pXROy11VxehfxQ3c6M2wycxyPGYQ8hqO1uoj83AwctPpUMnU?=
 =?us-ascii?Q?kp8+Vq3dp7ghBnunoIIe+a2GE71fY2ds+rudP8IPbZkRLeAVV6hDYQZpMwZw?=
 =?us-ascii?Q?GCEpesk+Wz+LXCyRpq/nzSx+Dl/9V9jKrXxZjj5MWgEMC79aq1FGBFgj8oxQ?=
 =?us-ascii?Q?SvaHoFXYq/SnrqiU4v/ZbEa5RyVnZUYGV78lhn0elsI4Tyx69XZW7iQ0n1gK?=
 =?us-ascii?Q?8h//5y41rwcqpGFxUGBBjbStiuunfKQbKeZ1dKE6zT4UeaDLX0XBjSQa8uWi?=
 =?us-ascii?Q?08bgmQg04AKNNcKZgUNvo7ucPoYhLXDk4td+tw/1T9c5gTr0vUM9yAKLGj+v?=
 =?us-ascii?Q?hIH0Bop42USETISGj1jnnFlG6xIf+AJ+fGdDQk0EzlTDT4WoVMHTZVEBwLMi?=
 =?us-ascii?Q?6gRHdTw0zGuZegyPR3DfGgVpVlApmMqvOJfU6wczFhwTjFYhTNsw2wruMy16?=
 =?us-ascii?Q?s6Gw8Mh8dGr7Tvy2AHmX0CRMBHJofQyFHdGIRepoGNnWovyLQ1eAONcyCJHX?=
 =?us-ascii?Q?oFu+n4aL4LbO2UN5C4RgaR0zy/eOj7X9i5QDEiAE359gQw5q/vcdXNr6ftT1?=
 =?us-ascii?Q?or76Vy83mTv0nslZHd0JHTbv3Kh2EXXzrx1D9HDyr+9+qmWVZ6nvaMq79UW6?=
 =?us-ascii?Q?17KHGKdaIZyk90uoHs2KSipeKQnokp16qpYDowQJePh+ORs56QdMkbioRGPb?=
 =?us-ascii?Q?4sF1k7mMqTOiHeWQtQg1XwSZCac3+paCltYCVJDq9bVdQeDwoSmGaps1g0nv?=
 =?us-ascii?Q?ZSAK741e3NAjDSjNd8Y2ZvUOjrpnTRyYyfCsIZK06PaExMWwYoNeBd2w/2pV?=
 =?us-ascii?Q?66Rg/c8M+qXT1RhcC0aEZtCth/UwcC9aGP1aDCXoD9xvEUIM/h7aimQqo2hn?=
 =?us-ascii?Q?sH5id4nrzrVo8MR4TrtApe3nZjQSWWTlFNt4Lcb/dfkhX+rB1UDnZURb4935?=
 =?us-ascii?Q?bSiImBb1zMK34bx5fDCy9aa7+r4vdXsKvm4kcWPnbSPqpaOl75C+c4K9rQve?=
 =?us-ascii?Q?j4EEjcVIuovTXgEgU6ZtmVmtdThCGMbdd0wZt3kjVTBKcJcbvHTuNHKzUySn?=
 =?us-ascii?Q?BXNcNuNWVaurmxnhbS7rtJLiiB2W+7wNB77PrGUb77u5J4038enW7DpwQrnN?=
 =?us-ascii?Q?eivA4EutUbwmuW+wQnZ+y/fEX0042h9Uh6RnQUhmQoaTcKFVc44xbgPN4Svp?=
 =?us-ascii?Q?71PZYb8Xz4na+oRHbJdnOpc3NjmYBqUbleAVNR+veOq5zjZzQUAv/4QyGRpT?=
 =?us-ascii?Q?U+/XkA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JJ6Wx/ALm2a6DmQ8eBRKhCaCA82YIGcBVq2gYW4EZXR+OYxR1HYc9ozM1QxOvZ7p8vZAk/WFlgxcxmaRwnB4epjR7KgrMLtTeMenT/dz2/HkKKDIWAAtism6k7kVuClMJ+WHaCYu416OWZs1evTxdPpvGxU2Yz1sEtK2IBNFRCmh2SMs0zOjoGLiSS32DgRoJC0u+bX77QdMk3t1uQMXb/Lh+STP4jNU/fRQTuSMyvc9DW7S/LLZGJGqxAD7B48BT4BoU+oNSdfPbXoAfuXDaiUlow34nY0kHw3ZL+IlPrtD0CG83EcAn8BsZYBPSfMMwMmQVjJAkytbqMpNAfGXP5IZY5QkRoUd2oOzlgzCOXLtkXiaZQvEu5TdujuGvOX/od7HYPtGVsUbLJabqtR0pVZOHRapvMHy3r3I7tjI5g420DbaRwdmtOCF1RxmXwjTLC1Xzze+9HyOpvsPpsfhJp+P5d+ABr14gPeLixgizHw38MRhzmz6CskadrGuhENW8UJV+ZRWlzAUGgybexdcW8pxBSmpBNr7HVW41CLibsg13/fUiVsgmrkL9F1juXvkoK+rn2rgk0ElIi8onufdZArKzguaBbnDPDY9Rxht/zk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92ca3902-27e7-48b3-fe5c-08de34e7374c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2025 16:48:00.3843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LViT2Py9j3tub+im3KRbjdeQZmsPQTDor+5oyVWX/fAaTSHp/KGFqjGBj0iHY20MeSm+SnbPR0W3JM2qGS+1Xn7mGdAnAZKzr9aCKJOHtyg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF7FF16ABD6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512060137
X-Authority-Analysis: v=2.4 cv=GbQaXAXL c=1 sm=1 tr=0 ts=69345e45 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=CZ670seGuAnOMusgH6MA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: bbVT6yqH-vPKD4ncTGmNdXnfTx8rsLGK
X-Proofpoint-ORIG-GUID: bbVT6yqH-vPKD4ncTGmNdXnfTx8rsLGK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA2MDEzNyBTYWx0ZWRfX1zx9kljNEo6G
 ZoynPGNHbjMlMWtwzCIehegxzof1a02ZRgnH0XxNPrOuV/H+FRck+W9eY4rpyBWR9g+ibrTzqbV
 8PPms/WQyUkqu5lPgQkVAlzCsfe/gu0lXDQ1MufDwEJKAYf2VxalEwqWA+b+9jjWKZD4RvZcNAI
 MqizAzXtjf8EHy52IZC5Vea0Kps1+zMRJx7succcpDc6HFpo1fPOhN89r2EfSF+1/kiR09wxDlU
 R+r2tg5DldeqfQS1cEUgKwcf87FDzvPLTKPuPM2NThXJCULHzdKJ5I6zd8lP4JTuD6M0dHw/yol
 bvD2S41Wik79L3TfWSnHX6IhDVwnlR4Nwmg5PLUjOj7kR/7obo3sTbKoROTejvSU6atolgb7RfO
 Oz+lOYTgQM2VUmC0sTJg4INYIXXoTQ==
X-Stat-Signature: 7fjmiaooafxdj1hieoc998k3dio53e6r
X-Rspam-User: 
X-Rspamd-Queue-Id: 32DDC40010
X-Rspamd-Server: rspam01
X-HE-Tag: 1765039691-743683
X-HE-Meta: U2FsdGVkX19V657UikJLPiKQYm6s2LVTDF4O0NiMQxdVpBb9NoaEroVrOiTkLYppDt7IHvwnno/Q3Wgnjaz98jo2omvJHJl1ZmcQV4RV/CfReVSHc+noOP/40ZiBjYe3d064rIKI0GKsoaBpZzAJUnWvxVS56N70o/DvJi7IqVxqymjeuI4CMWLHjVSuAnC3/oiKOgW2IlwmLCuZ2/fcS6J83abEOmD+2HLOKBMlspfi0/dEdmDmEMW7/ShIe/OfTcTLAriH5hMkINrDG1UiVsWdKyoc1TgARuklc+du/N6z4mn3PevY5cs4i6I2ajmCkvmoXJ+clpwUzNmlll/kXdgfScVktdud5K4M71rz+uVo/INKWuMDX0f3UAlJydB1KdcYUl8dWXJkgvAZaRFxgYBaB45u/f4Qws+R4JAioUp86FRkZB1LZCYbruYol1ZHwGmUEV+cvkENNn+KsqpeAwThVphS6OkUsm+a0DROIRFfm4sTyX8EaxCwKa3u/jg4/EqZHmk2FGL9tgU7VbzmEdjr/XIkf/3D3twB/SMwFxTSAR8qeRrbczEXt2CpAFyDiquaoPT54Vb8ryk8iOjjc0yHv5/kEjdwnT0fgOdlrewGgFgr2+DL6aj/wXJjU65jaLMrKHKgXQ1gMHmam8o14ovbk+kuFTn36PLrJjinRGOhDw9uy4lTY3cw2le4Vp/TO4XIMfSPzHNP7g9459qJ1KdyM5dWaJmY3U0ownt29gPUIrTOOShCmAO/LPNdmm4Mtq4ZY9RI5eM+US0YzDR9EB6la/iWLpnuy+enL6to9TF9ZJ1+8i0bBXhwRjHyzROyJzPkIiqX/535/ehgIBdkJTUXPmYZGfS2aljKOqzRTBwkCghr0ECAkbap6k2LvEEU5aQKS1eV2Fuu1EVbOkvcDpXiL3SLTBIZY2mpanXIq6t+zRVrCJ7wpZ2oe7iBWva0S9uUBcAokOYD5/ceBU5
 4G9fq0+S
 pEllh8StHvloPCR3PQf96H19hCJGLkIOhBE//BYRve1KOsoPnHP6YE+ERDq7EobRUIQoMO3svebO5ZeliVdVou+9yUmbJyu0h20Ni3vrT86LVGGMPoMLNsO9gi0rz7C6q0E1nvlueFMxCn+MAFT2n38HtqG9mTmIcy6+VGx3w4Q2m8CX8hIWkZ6Az+go6OPR/wH3VVqqqRIKulyesE1HwyrRkC5UMsYS5GAasw0vDXsEgrrXSABTz+dntjzYwWRr+8i2zx64hGrpMz7+UlgKuGZeJvnjRak9laoghbiP24QKCapGn/vtbFhZhCvk6Urn5q3WPYba+CyKQ2YIp424kvShyLq47S1KQD+SyNdMU0fRVAvXsGTplEcSm3gYo/ED1bdzTPotguPmQNjsjoj3P+1Wd6d8ihDjQYEhr5Ijv3twoPM1X3vZvracnLVhP+CwM2n/Zm1nAA9fkPE5dGWPlGdQXrklWMmaL0tasiLGvM0ELpVazeovva85hjJwUCV06trNkqrJAfRJG9LUxRMeFDkNLrG4ziAqy8Oas2uH7qye+gYXwO2mOYQ6yS2YLXbQybqssdWRmGKzv2fsxjNLYHfpYpYieIx+JLMHw3/I19hBS9y8tU1GWjBn2++Z+ITLzgXQPOrlZiNiCw+mmTo9MerZwFLYu/EzaNwEmcX70onRiZpVIu6wql6l/Lg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 09:49:40PM +0000, David Laight wrote:
> On Fri, 5 Dec 2025 19:18:56 +0000
> Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > On Fri, Dec 05, 2025 at 06:43:42PM +0000, David Laight wrote:
> > > On Fri,  5 Dec 2025 17:50:37 +0000
> > > Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > > Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
> > > > how VMA flags are declared, utilising an enum of VMA bit values and
> > > > ifdef-fery VM_xxx flag declarations via macro.
> > > >
> > > > As part of this change, it uses INIT_VM_FLAG() to define VM_xxx flags from
> > > > the newly introduced VMA bit numbers.
> > > >
> > > > However, use of this macro results in apparently unfortunate macro
> > > > expansion and resulted in a performance degradation.This appears to be due
> > > > to the (__force int), which is required for the sparse typechecking to
> > > > work.
> > >
> > > Does sparse complain if you just add 0? As in:
> > > #define INIT_VM_FLAG(name) BIT(VMA_ ## name ## _BIT + 0u)
> > >
> > > That should change the type without affecting what BIT() expands to.
> >
> > Thanks, checked that and unfortunately that doesn't satisfy sparse :)
>
> Oh - it is that __bitwise that causes grief.

Well, if a sparse build is not enabled this tag is just removed (as is __force).

>
> > I don't think it's too crazy to use 1UL << here, just very frustrating (TM)
> > that this is an issue.
>
> Did you try getting DECLARE_VMA_BIT to define both the bit number and the
> bit flag and put them both into the anonymous enum?
> Or are there other reasons for not doing that?

I did and we can't do that because it results in errors like 'enum constant in
boolean context [-Werror=int-in-bool-context]' as clearly VM_xxx flags are used
in many different contexts in the kernel many of which seem incompatible with
enum constants (even though... they should be equivalent, at least in theory?)

>
> >
> > <insert rant about C macros here>
>
> Add rant about the compiler thinking anon enums are doing anything other
> than defining constants.

Right yes :)

I put these in an enum in part to make life easier for tools like drgn to be
able to find these values (the guys asked about this explicitly). But also it
makes sense for them to be in an enum!

Really the VM_xxx flags are at least in theory a temporary hack until everything
can use bit numbers... assuming I can find a way to do that without causing
performance regressions :)

The perf regression here was - rather unexpected - however - I must say!

>
> 	David
>
> >
> > Cheers, Lorenzo
>

Cheers, Lorenzo

