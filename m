Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACE99CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 15:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFA078E0115; Tue, 14 Oct 2025 11:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED0AA8E0090; Tue, 14 Oct 2025 11:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBFC68E0115; Tue, 14 Oct 2025 11:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB74C8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:41:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 864A511B14E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:41:59 +0000 (UTC)
X-FDA: 83997135558.23.0E6CAF1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 23FD440012
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:41:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=a5N6Mc60;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HB1QcSo1;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760456516; a=rsa-sha256;
	cv=pass;
	b=xfI/YCzSY8uAp43mwSiombqVKVF9Lw9t59Pqt4fL/Csn6meCCwF2YC3JPk5pDZxsRwVAHH
	G9E73CMhG91IiyUm5lmDLGEX6+nuO9GyubeO1lLguDp8Rg0JARRa5XEvPZEC0GytahALas
	SpO+RdQbf3NdM/K/NcIWpV2MolKZJVA=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=a5N6Mc60;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HB1QcSo1;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760456516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jzYWxAcf8HMViCn+hRysCCF7dZmmW3SSxuQbpyRTKOo=;
	b=hx1TMdS9M61HNjzLAgS4Mg2yCD0DwoELi5cElNgs3aNpV0W+it/ZOp00JRagaLF7hJ/2Or
	wrB31qZNQBIaR1/ILe7w28DSMLLfUeU4OP3PGvb6yd6BsGfl+Xyf0n+iMTkP7zBzUHd/j6
	OJbR1y+sLvwM03aljKP/WCVop9qGkqc=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59EEf6Fu014385;
	Tue, 14 Oct 2025 15:41:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=jzYWxAcf8HMViCn+hR
	ysCCF7dZmmW3SSxuQbpyRTKOo=; b=a5N6Mc60NVfFYRX/4V3O+tOOTLtLZgLMUs
	vy+0Jylxurtx74Dmrv2TAogCKkE2GpPfAZW2gWCIuGUUpj/aM0khmRAEycajMrl1
	/QDazdTgok8uxqJnj4lpia7fHp8Jz3a2FAUn8fbGAk4fDz4XMlUqP1H/BqNnBKXN
	DkANtzFvM3NIBQm436cRFDHNQWRN1L7NCVETLN8U3bk/iFsu7lzUP0eHFjkPys90
	l3/+Tls7ozyjBnLAZjOAvbk5Fj2meAfGF8QxtJzgN9FSu9oCFXTtiu3b8lgtXzaO
	zQh9hdoM0yRvod/wiBaudAfavY8keVDjJFgJlzJzxxG1tqlhMvGA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49ra1qbrxu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 15:41:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59EF74cb037163;
	Tue, 14 Oct 2025 15:41:48 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010017.outbound.protection.outlook.com [52.101.46.17])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdp9478a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 15:41:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EzgWC03Hu0lxiATjSLVzo+XqypleBWwnyw5Kp8igj6Z7W+qPqY+gasQVQE73gA/ss2AWEmSi9ReGWTSCGF389Zu6C/I3xhksGWvhY5z5pQLCLPgt9wBBv2Uf3ePfBukIyDK7m/VbTlSmfiaJUPgqJL2e/FBH/5ZhxNEePZTI8C5kw9iofoxJGjYGODpcDmp8ygY40jD7IfUV24if2sMWSM9yBBQxkOwCqBK5+dBjBzoMiC7r1uC80fffsMGRd8696+ilorTZ7EAWk8ImFppMA2zNJ/DtuLrzh1B2pnJlJLRyZDnOhxbli6VhJHZpYehhtdm3XTPpeXSNh2lRIUQd4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jzYWxAcf8HMViCn+hRysCCF7dZmmW3SSxuQbpyRTKOo=;
 b=UspilxpJgcfyw+Yys/nxb4y8kRNjw+1MdzKKO0Jmt8xutcpcQx+XDcK1Nqee8oMfKsW7iFcz4ezvlj1gtzdI1sQS3HkXIX6FBR9AuzqhDqX7gDk0EjE6YxXDWxZO27vkhB9w7bBVFqsFQMwi7tTuXbe17iiu+pZNfWK04vmsqDmigEVoG7K16O2zpF3of2qy9DHTBPHIcxgMbkC5pY3ZMJFZAbvx74J7CtQJLjIdIYyAXvuWHZYemuBP2FLsSMfP5FxWbZkdidi8M33rNMsF+9BtNLOVQrCn8wrs0JdrJjKJ+b/PBL++aKMsC3ejT4WSO17l+XVcm4wt7m5Odkumug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jzYWxAcf8HMViCn+hRysCCF7dZmmW3SSxuQbpyRTKOo=;
 b=HB1QcSo13Hb0+2Rry98E7p70qHVXbB3N0Z5Dg4SUCAjbPPJ+TQdhmlf4BGVS1ig4BbfeIH4a2eCfM7Kh+JY1SAFRTQuaZgGQY0UFX8uHcFIJX3FJ3bGRDNt0l91a/uh2YSPhiw+3iDlslp5NBOfr3OuDmW6KzdUBuNgcT/6et4k=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB6223.namprd10.prod.outlook.com (2603:10b6:8:d3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Tue, 14 Oct
 2025 15:41:43 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 15:41:43 +0000
Date: Tue, 14 Oct 2025 16:41:40 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
        Liam.Howlett@oracle.com, baohua@kernel.org,
        baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
        ioworker0@gmail.com, kirill@shutemov.name,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, mpenttil@redhat.com,
        npache@redhat.com, ryan.roberts@arm.com, ziy@nvidia.com,
        richard.weiyang@gmail.com
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Message-ID: <b35b649d-5566-4467-8222-e358439b4f84@lucifer.local>
References: <20251008032657.72406-1-lance.yang@linux.dev>
 <f33735d3-b38d-4b6a-aeba-b415e6b24ea2@lucifer.local>
 <0bfdbccd-9d4a-409f-ae43-b44bb7347d70@linux.dev>
 <f7392f43-b8f1-4e6a-b9c8-25ad8a47f82c@lucifer.local>
 <d2e5b099-94bd-444d-9946-182807443539@linux.dev>
 <c44e198d-7d46-491e-adc1-86cc306c27db@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c44e198d-7d46-491e-adc1-86cc306c27db@redhat.com>
X-ClientProxiedBy: LO4P302CA0005.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB6223:EE_
X-MS-Office365-Filtering-Correlation-Id: cf97ae56-f5c5-43cc-0b47-08de0b382d05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FtkDX0TW1kpyJV7SMpEmw0jJAwkddSU/AVjXC+nqzeoGpcQe7Pt79jyxKzia?=
 =?us-ascii?Q?AaFFIO4RStpw7DQsvKHPJf8z73eLAJO5Bqbz4B3OHCk7n4v4FMHrtV9NG7rr?=
 =?us-ascii?Q?xSW1zVaIKeaoJR4ZdL6PzbhSgqrOyVFz3eoBtj+sYMMPiUko6gVyU0nIU/5C?=
 =?us-ascii?Q?j6880R0PVzC8362+HxA6k7CNUH1RMAI3Nj9oUGZ1SmAXxj9kVuUbXodHqjet?=
 =?us-ascii?Q?1DkbuWh9aF6RQ1AvlU+xepBApAJR5jyusCmaA65yhWXXfbm1pgiGdo3aeMFQ?=
 =?us-ascii?Q?Q4YP9FB50Pymlr9cmCSdpzBcdK60/JtKbTJ8mgZ3+DvnVoY3JKN/FiipJOMQ?=
 =?us-ascii?Q?SCYWdqYq3GKhOKKw4BDEZ6JJV9td1r0P+ZcrwCHv3X3F/TNeFPInjR7L3Smb?=
 =?us-ascii?Q?/sk/U4n5w98eAr83X9hciFeMrQqsb2bGixhXaDfWJ63LLqIZcKVOc2zQ+K2Y?=
 =?us-ascii?Q?6yypkLPRTaPSaxtPcjUEZc5TdZbxRe8rALivEhsjf8Zy5IEb3eqF0WNcu62s?=
 =?us-ascii?Q?1H6dC+B6t4Fm5GaLzQXN4yhwgQ3ji+7Er1dvP2QHKfsb6SFbiuVbYgt84zdv?=
 =?us-ascii?Q?NQ1kGAW8W6Z5INU24IXrhaY5Gkrwrn5boBs4oHo8/ZpGAYNptr0mXC6FaqXK?=
 =?us-ascii?Q?WzTdL8/umVRJlfxKbA+sgxrP8MXj0ag2jEG8Vci9I/IHjd4Z6oV6AMSzHsNG?=
 =?us-ascii?Q?+rQbh7zqbojOkxGEcfM44cJ26iWyId8aX9mk85oN/zsrEpmjeLEMlqjQZsq9?=
 =?us-ascii?Q?lFo+L4ciesQjJSh7r3DSo454kPmdpCS4maYEIdYbRpGsNJFLMHBgHjbEJeYS?=
 =?us-ascii?Q?dmQOwogTdxdWbkUOgtgk+pLqhukOmbTpYtuzGxOrCHwdaXEbvMBzaiuGiT3n?=
 =?us-ascii?Q?3eK/LrWvSxMvW5TtotayYU4JF1AWJ5GavEnK1UEvETdRbxxRuBZ6Kt5iDAJe?=
 =?us-ascii?Q?LHwWIuPZ8oGTbawNO1P1zEuyd74vtbnLkezg/u5YsuDApVdJXKKnOPDXK/3k?=
 =?us-ascii?Q?AjdMi7YULkwpVGULJ42WVhgXzVJGgkHwU26zEJYkDGs9Iw8AzGsHzQB6wxJh?=
 =?us-ascii?Q?avc2jfWfb7BI2UhjYymnXMR8QkWUtyTLyxozOqwNUeKosbJrbRlKLTUEcFhJ?=
 =?us-ascii?Q?SjQmuNlO3ENVwCtRQnR/nx2Cbz1T0/j9MGVkd88+PSC0FXhSYA5TOAYfViZO?=
 =?us-ascii?Q?as4yyn8V7J8QZ1MtNAvrDC3TjGEvaMsEI+162Jj9UenByIZVw4bOyJWRTGrZ?=
 =?us-ascii?Q?Xd2n8XBKmv/McqsUQgeNrelvRPGtjfxnjksywExONI35gDeXm17gGmwxjNM6?=
 =?us-ascii?Q?l4DuRDmGTBlocdAeh/5gbYdEaXMO5GbAwXV0AYSFdnVcFORy9QoNrN9GtzMl?=
 =?us-ascii?Q?2cUTv2rMNmyb9hUc1dj7g0Eb+UvrxKMk40dKRcIPtshgoqdHT8NQh9bkT1hm?=
 =?us-ascii?Q?lu1nTOQgz5vUJX/tYBenYazT8aEjeQvK?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nu7aMblL8mnoJPCOKtgpsScfsfre9w2SjRw4tydqg+0wd5cetWc7ghitkph/?=
 =?us-ascii?Q?nvixZqj27jIBo12cOVZtwp8fHzsD7EmXNFMpjtO/wksX/2mhtkKYAuUCVzkq?=
 =?us-ascii?Q?qAFp5U/GndjP/ww8k6yAKHLHBHgd3QTHW3HoQh9tVMmAREFTFoG9V3vnESst?=
 =?us-ascii?Q?htscyJidkFwoyeWk6Z49sUjfM1SamfLYvdFQH2+i2/22S29ZuFB3VBfNL7Er?=
 =?us-ascii?Q?+EqodINGnhB/+Z8pBiPUphyFE8Yf92AW4bXlPjqvvHMf9Q1T+AcKQOmrPLK8?=
 =?us-ascii?Q?lEoRARQiIiWsboRTTFI5+jZprad5N4FoS5Qs5j5Gk6m0Ntsjw/LEoUPuG0/W?=
 =?us-ascii?Q?JD1CEkI8fuJSPlEyOP6FZ2jTpG9fKQ0uxuVvxjwz5o65RfEemFuG/rKbyqXl?=
 =?us-ascii?Q?RXIPAlSmGk3R5RpZ6YMTzBFe3Cz+x/HU96Hf7bp7uUUZV+gq53QCBFuzcocG?=
 =?us-ascii?Q?e17onuo2BKiFaV80ru84C4g6XM03HUX6hyX7q7hp7Q3x4fD0LUh9SOI9KhGj?=
 =?us-ascii?Q?eAJd60ib/vvYEb0mQTH9CJVw+tN5rNtlhIgHs72hLfAR/tIjbP1E/RMQpgsX?=
 =?us-ascii?Q?dTOeQGrIXDpWzm9uv/a+OqVdHBbJcbh0TDU2mKTEFfSMCRMErk3EhaDxc2aQ?=
 =?us-ascii?Q?1NkNJOPzSA/MwStR+xokETvqD3JuLMSWA4Q7FfUE1rretTqqJk5c7FLHHqav?=
 =?us-ascii?Q?hizHA+VvLw+6bD6lYf1cALzci/R8MW3sWC481Lq3bjpJnxJ1HyCqT63G+x1C?=
 =?us-ascii?Q?kt6ZsaDR7ZmGNPyCMX+sQm2rvVeTWudq9W2KzLooOKYsSYLkuuoPS/QPzcNX?=
 =?us-ascii?Q?alJ4ARuqbQHf9M4dFuOscYx7tnwVzAf55E9UzV22EWJWD+q98HkSJgXGI3XX?=
 =?us-ascii?Q?Y9jILXASQgk8nuZgBRsp0uqiQOrHHkEiGbBTgqHvvt/+Z47ndb6H1oeLo9i2?=
 =?us-ascii?Q?y7vVj18SyrCf9fwW8R6Cece1a4tXV7z5OunnRi51SxxdoC6p1jZ+afmNskCt?=
 =?us-ascii?Q?Iqi1sh9jGhut4nl2toLMHKItasTiGGr7xxODDQGekIdm8aqlu874nxNn43a9?=
 =?us-ascii?Q?qoU3364m2TQjeBWi2sSOtgd2U4E2AzIMxYu816UlqMlvxRzu0kMbRn0XAFCA?=
 =?us-ascii?Q?4r5pnRs0NthOFaREKXaEy+IYenYq4I6Xdw+ByfWKL6A60Cnn9vnrGdiSPZO1?=
 =?us-ascii?Q?tXKSYvYq+qTIBXJpAMZCgwlaRrzPXi6GJWFA5GCaptd2+vvHoj+aeDKNcsj5?=
 =?us-ascii?Q?f0x/rZ97EMSnWc97L/a60bifBaLHhXKgywIo9C9LlF9fBt6hIgMaR98SVNlU?=
 =?us-ascii?Q?lt/Y/+mHtgBC6ImSJ7N0GtaHWpeZJRm0x8kDEorszW4bb5CuvTooME3czEDX?=
 =?us-ascii?Q?Dgi5iISm1KFJLjAVv/DT+fCho2Z9rM5lzCYNPlxmhDo50cHjnP3/q2NXky6Y?=
 =?us-ascii?Q?meXWr36dJi/u1i8aIrvagryvCYyKzb5JumQ/lnqr/iOQTVb6PY8RwA9BS80s?=
 =?us-ascii?Q?16uoQ1FHUQ9hTMeU5LetJUxFS4TcRgfWfmoa5FjQmt0T6VE9ZztmxDgqguhW?=
 =?us-ascii?Q?FC1UW+Ob5WaKPJ2lYn4PCx/FmNh8EMj6JwyP1xbfKzJ6rcX4TFOiFBL2Ksyp?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dj9Cb9Rld1T8TS0mtU0WtcvYFD4NG1GpmQCCu0ac0mScPsKWZoElpaSbGff2i7Nw7I8NAo0QMXMlX8qdyLojruxEBg2HcfvPuUpObACPbgPLccxVN0iFVaCjNHg7arUQFEEQMwVGp0q6dnvts8Rm7U/k5yavS/34TH3vgj9kvscEQIsgDu9Ae457jNGMgSgkbF2Jf7CQWTxgeo3sDo3eBXnCOkdhGmXL+eqF+nG6A9+IXhw60TveVZMRsrhhQHWhR+hYF8LyTfTEKNi8XlW5EuV/JWaTe0dctx+pGbZ+TaKLi4BMFUeHdBpdRVcAh865UF/Ci84WY8Kxbt6TlqCjA0hpyDUzfZnkfPzNNOdHarQaPpYcKoTEZwSqoytpuQVfEvXSs/DFTGFRruh3ypYC7WTrEYUixsgPXxi3p5/Wo0ml292fYnNsAw6oUmGLdUoAUPXaThAXl13tqhMqZ6vReLy9eyYFPP1dasmANoM3KEC9Pe0iZ00znpjSf2B65QKW2JDP0vJ5hQkSdA2FpZ8nh0LerudcbPjyFIgmMKP2yw/lAC66ZTyARmWJCjjlOR9f07MmIB9FCrKAF/X9MvVoytytd0foV0WjeRyhvgFx5YI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf97ae56-f5c5-43cc-0b47-08de0b382d05
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 15:41:43.5170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VNVzr7MK6tFUnzYeq2mE/HU1orQYB+S4BVq5xeXNnJnHJqi6S8AtGWjfGIZOFdTKe+hao4bv6hqZK9uOUyXTHi4Xx2s3tgNNTxtb8T5ydIs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6223
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=603 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510140118
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEyMDA1MSBTYWx0ZWRfX/aNPw4/Omhi8
 oNA+jNKpw3xP7bbvWFyJ++/CSTtu2BP6yKLR99bDEDSSV7tZGUBYXu8eD7nPQo8ln2C2pdZQXvL
 BiP1W6o27zcjnZ5OWJ2O87GhIcn27IE9aaGe8yEPO6V59rQoAhh6SZB/ZR51Dx5pMfUnVuEYCsc
 JuJXcUsYVOal2HoVpyRxfZJG+g8LSTG85qPcITHaeORg2EgIu9PQJAqB/y4iQi1GBgNE+WdqorN
 JR+u+RhbyZrMWYxkXAlfucYfsTbbHw0xztu8RsiM4bJXe69isZ2FKJmT+ge04Z5VFeCOFAKh2gv
 msy0BLLFk9yz+KFl/75H3r3QPl0QRyotHI3pHx1Q+dyXevdX85Fzg5x228BaCjvjFPgbhy54s2x
 bG5SNTVEAmNjO/vZWxFdeFS0Je0RFA==
X-Proofpoint-GUID: vn8u5nMr3Jr0M9AWQ9CpfY8FeGd_34kc
X-Proofpoint-ORIG-GUID: vn8u5nMr3Jr0M9AWQ9CpfY8FeGd_34kc
X-Authority-Analysis: v=2.4 cv=GL0F0+NK c=1 sm=1 tr=0 ts=68ee6f3d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=_zfPccOjOWhN6ilodd8A:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 23FD440012
X-Stat-Signature: rej1qjc19b19u8u9zu6gc3fawo6tkefi
X-HE-Tag: 1760456515-792208
X-HE-Meta: U2FsdGVkX18IT86epluaMLBnCVYuNHgABWGygwKnyksoE8XjoA5L6BPZjDCkJRk2pF9WgUL+dioFcMtBReR1Um0yFmL1mbmhi+VCPCaCxAzTDzu03VlSjE5d4BgWUluyo6C7GwZfoan7jscqmDvtVKjBsWP1CWW8WviCHd/Xlyln2fz/4kn0h5cCfnpGyMurCPoqVN71b2ZplT9IgsjwRqyLJpV0YBv59JBBV/EuhdRgCMtoS2zallvns+Oq8Ja+enBnHIRkEal3NSptJLwZzw9WkpHki8tXuhFPmgU72BemsB9IFAoFrYmlB1tPKXMWcujXAHzvIwHXq/yVg1+Ip+B7TT39KYNrEj6VC9m+G5mU0yCS9vV+pNGtlZkSUsPnTLSl6DcwFi5isr6OBov6SW4nvXfvkEHzeDlk6ePpRNqdtZH2EvIcrGKi9kl+9YmRlnKCFJxQlri2okLDVK2qzSh7O2KrjGUFjLN9c/7O/ppcEjODV5uwuU2gCXg+f0HrUK9eZHmY7FKr3/aRSTjda+x68qI2gAfiGZH7lg4pdPGE5pjPrOhpJcZzI7JSTDtSArQ2EWdJl6WvyjMcdSxrWWzZqZ2RSJMOC5s9hbDnXqvge2BiBwQMy6Uyp+vmvahEZ+VUVmK43yUdmbopGOyJQxtq5isqhRZwhRCx7xwOybu5IbuGiKbxPmJJAdyJECAVFEt1JhjpxxetH9v119d1WTIWxI+vyGVxaX1xTTUG/dSd1A2lttSUbrzAdlJYuWhnYYjruF35YkB0bB4TmHZgSm5rq1N+g18JJGEwM0a7rOtNcS4StDMimiXEZxheBTeQh+TLRu4sLcJtNeeiv6wrVKFVIwMoWqSzT617OwHbVCTmv+l90WCpC1iNH1ZcmWfddzYHbjZ2r859b+OW7gKa8FlUMWysiMZrMYPEKnMg7ADno/Urz0bihEaWq78QRzQOWBskQLUQ8ZaYOybhUnJ
 Thj+uzls
 MJnNhmyiXZf5lzLWiaXzZEupIrgWOFnXkwBw7GtN/RQj4bcS8KUPg0gcT5gOgaBIElZgiwugAXYJa/JNJAosO+BxPzVXq7Ll23flP2LWDQe98K3+OXwCV2Ao4GmWCEWfQvrqrCdw2SN17Tq/litleAFJu+3blC1M+9066VOMqENt+XA6xm1qc282inFKQPAKjRNQTZYOZYh2m6s+M3ycJ8KDWfGS1DJmlHb5RxUn+wBLPm7ATCuItgecy5SrA0T6urczXvU7e6jD5gcvvXeJd5SPfnCiGrExJb0PAOyiUo16bJQmy6YhX5nqgmvA5Xn+QBCo7I/D3flhD5+H/rWzSaUbmTy8zsu58Ra7P9S27j8KjuMZWXCJqxOvHjWUFPpIHk42DwReYvmXffp2t2/bPP7Gp4jtsm2tDooQLOAdMOcduQNEprBRQFo1kwTx5FcJWun60W4C+27kCjG1ojvyN02Gtog+u8aFE1mLLLn3gU3+u6QEx/LgZEr09VVXCjZZcmEB802/MaXAk23HSmFckDw9NUm/rg+ABr4xl3FfQka0XvVwk0c6hydvTf2Rh1Jm7Kjw8wxhW1p+XNx0/Dg5CF29mqCzZtQQ2vJvlXZxYliFMKiowLgbi8Rv2vl7hb2HZnSQcuHY1tkI0lWOX2DzLV0qcvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 05:12:18PM +0200, David Hildenbrand wrote:
> Can we please take a step back and make sure we are not starting to do stuff
> differently than elswehere in the kernel, please?

The code already had the is_swap_pte() check in it, so this is not changing
anything, it's just avoiding confusion.

Even if this pattern exists elsewhere, I don't think propagating 'just have
to happen to know X, Y, Z' to understand it is a good idea.

