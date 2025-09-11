Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1BD3CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 17:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FD336B0005; Thu, 11 Sep 2025 13:09:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D4B26B000C; Thu, 11 Sep 2025 13:09:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29CC96B0010; Thu, 11 Sep 2025 13:09:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1638C6B0005
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:09:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A7C551DF02C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:09:39 +0000 (UTC)
X-FDA: 83877606078.11.8CB0433
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5FF3C1C0004
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:09:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UQoXUhqU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=REZFY+FT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757610576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPGNNjngPpRrrXPKxaOqwgDxDe7YdqJpNWBgyVlO1Lg=;
	b=R/CYp5vyWp0heF6LzwaoDGByHd1ymGEsMnfPzB9rGTLJiwWspGzq01iN/rxahIFwCgzQzF
	RpdHdM1SmBcKoE88CyGi6OCvmMP26Vct61wuamYOlfIhM8z5WVJOq3WpodpTYMG5kuqWGS
	6J1ar3i2cYCQ6VdkDWSc6MBiwfQurVs=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UQoXUhqU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=REZFY+FT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757610576; a=rsa-sha256;
	cv=pass;
	b=CquwgDdBlKAWT2je8t+eAFo2GBn/11h9/puP+C2Z0f+ydJ5XgZIvZq1s0859XJjPyN0ky5
	1gHBHeYJHbDgzM5JlLlqqQzYAsgfG6ylh12xNXKbZcjX6vK2jJyRr2aO9qa56QTsPAjPQ6
	h9yvxmJCFVUbIswolzsjbKwWHVBfapM=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BH0KCq009161;
	Thu, 11 Sep 2025 17:09:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=kPGNNjngPpRrrXPKxa
	OqwgDxDe7YdqJpNWBgyVlO1Lg=; b=UQoXUhqU5IZwMUW1MnVEAOo05dhUM06W1B
	epVvAGmjbRZBI2lRwO6M50fqYtGoYvFxOPcTN9DK3xw3Vh4T1Qk3/8AxsSkxR6DD
	r8/Kd463hr45pb6k3ksiTnXRnzSJZGzCY/igjb4aToOECArA6HCIDlWJhS5Mzm++
	vBO3tDXbGRteFghTN9hVJZUuZa60D1OeRiZWLxHR1kQiigGdU7gFGsXD+Cu0WzcC
	xa9px0vb/6sfKIIuK7xNZXQSjwKaNORdeqQPulvtWLBfh3c/RQ8CndICcIQP+1V4
	s0jHzkL5xyaLzJAT4N8Hb0zOf13+38lkc4g0OdsGeMjTNno6mpPg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49226sxr0t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 17:09:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58BGlwWH032870;
	Thu, 11 Sep 2025 17:09:05 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010064.outbound.protection.outlook.com [52.101.85.64])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bddprta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 17:09:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=twWuzgsw7jopVcstPfufMqBK0pUeTc8qKc7+n9PrS4vlsQ/m742nbhcqn0ihTdep1KF9NCo4Dfv4UEZ6b1K9DCNFFEZ8wuLGBugR0JwvBB9vmq6cociH9cV6wuPi2KPaP3G82c4/iQqJAomHP3J7RagQ6FcMGsBB56AOep2l4otNlfpsOYA2x/LPEnrpv8Hr5ZjzaGKCmSpQVZvpKOASVeUlV6asJ1EzirXirZkrnm3sP97RgCLhJRgScgIXjgAQnyWl843rjZruMchyLNjUQf9x0rs1YEiK17PNuP6wFRfGE7UxEhAPlcqgbDSOzvBFv5E5yq9OK+b6wR6krVj/Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kPGNNjngPpRrrXPKxaOqwgDxDe7YdqJpNWBgyVlO1Lg=;
 b=Rg9xIZ6RuE7IfySMPpIrH3D62WsT2zC/MzAAm/l9WrSXh42XJf99R28bv09aEDqrsWNyX+lFbCXxLUtBQCii5/MKVqLob7b39JTqSxLcIijhTRSBLMZnUxofu0KSgflMWm8s2u6sSjvv4YpbQ99zUtb0LZyPNWp2m+nqfL9pLhCuVyn3V68RDmGlBBaBJZDnFcGTidBKDnf4ZY4LiJ7VMUKnRJbEokIoMraNnh73RUnlUvdGbX5CmAY1N+yXvUt8x4Y5CsTLy2BxcNOz/NZ9wZhMP037zNEicyuoklwi6aBPvV8Dz4OxvKlchzvK+hqK7HBHuE84cZ7j1877FttXrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kPGNNjngPpRrrXPKxaOqwgDxDe7YdqJpNWBgyVlO1Lg=;
 b=REZFY+FT8p82l0JTOFLSbLHlzpuC8OScz7cMwrENyDnW6ZqbvNRaaIwKHQuqhBxoRAwpMSjkhEuGCDjLEEB3tSnP3v9yUJp1cU/EU9XtBsYmubXHGM4El8W8z2rRThf9bcwOYndB2I6jf1GpHcF0RQVg2OtXQi8yyHdhNjEgZ9c=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH3PPFBE86117B9.namprd10.prod.outlook.com (2603:10b6:518:1::7c5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 17:09:00 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 17:09:00 +0000
Date: Thu, 11 Sep 2025 18:08:58 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        hannes@cmpxchg.org, usamaarif642@gmail.com,
        gutierrez.asier@huawei-partners.com, willy@infradead.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net,
        21cnbao@gmail.com, shakeel.butt@linux.dev, bpf@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v7 mm-new 06/10] bpf: mark vma->vm_mm as
 __safe_trusted_or_null
Message-ID: <18cd11bc-c4dc-4d57-a35c-2fd715ee1e38@lucifer.local>
References: <20250910024447.64788-1-laoar.shao@gmail.com>
 <20250910024447.64788-7-laoar.shao@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910024447.64788-7-laoar.shao@gmail.com>
X-ClientProxiedBy: LNXP265CA0085.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::25) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH3PPFBE86117B9:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a522718-7fda-4864-66d7-08ddf155e6fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k/jHOe1CTI+JhF269jBJ5i/BAFowpcwtPm/tIzrs7Q9720p6r5+2SdU2GiwN?=
 =?us-ascii?Q?soU4qyxJ46fGPkHwkTJtS0DyXked1aklYjCuv08+rCbqEnPyqVblaJzNXnem?=
 =?us-ascii?Q?jATGpbB4ISFMGTzh4EVmiX1j0YIkbdeNDZFdNVsninlaQLa3W++VfRkckNuV?=
 =?us-ascii?Q?qopT2RbWRMdDfz9T/9CnugZIL4CPhFUGidnITZmRTMgbjHKfZbvptixgkaH/?=
 =?us-ascii?Q?4VQmkGojfhmp/wMQGE4v68T7rwcapLJhDvhdf9jYst4beUAlUXvYVzUbs4En?=
 =?us-ascii?Q?81A6NnVdQQdXz5cpASVTbMpUHrh0ZKKZJ2pFRZGaTNledMh1mK4nEws19twx?=
 =?us-ascii?Q?gYBKfg+onblLDJ64TlkwS+C5VUckU5QFODNbj4nDttaIEJLnmIAW8J2SEqDO?=
 =?us-ascii?Q?UHo+MkcMFGPcBa7D2jCodhYI3yDgR0ZQEz6HXh3WcgVbizW7ZXACjuHNz5fU?=
 =?us-ascii?Q?UYKsJaSWxn1Usfjs0y/CN49WQeCLuc+UfjgL2vTWNxSjZJpPHyXezDBDkwtf?=
 =?us-ascii?Q?QUBo8kh+3Ev9rTOChuG69iYSk1FYOOP7fhd8YS+3US9GQY5YZAoe5D1iQJMT?=
 =?us-ascii?Q?Fa7a9yvsZN9IoA4ovMRRykGt6tDMxD1ZbjwCAmsRRHFh/zx4Ep3n6UWPyrZG?=
 =?us-ascii?Q?Ztek1ZPQE7GDV8pJKQmEB5l+HFCYgpY3bZUz4MN74JngWl4Q93C4RCdBbvD3?=
 =?us-ascii?Q?AaFBm0CUDOX5b2yNwpJ99AtVUY9D0F31NycfYo+ePeUT1wXZTaaEVRzZ0vAn?=
 =?us-ascii?Q?0lzo8nvZz6ZZdB96zvzSx9Trr7IsXIoY1SVgwJjj/eZHVmPQn4D0IiSO0Jr0?=
 =?us-ascii?Q?pTNcgRY3cHHCsGIP7YWjgEn81uKnwVW7N2cxulpq6SUco1LxvvJMZW9zjfwP?=
 =?us-ascii?Q?JMwHi2Sb3GLlAoA1njai2IQTXWX980RItmlPm0jzEijk9gImvE9cPvJeojRw?=
 =?us-ascii?Q?4qubW82Uj7VcaTEsMIY1btUXYK63Cs2B5p3+gKJp9nBXWVL867Xqss6001FK?=
 =?us-ascii?Q?9M8IrECVEwN8/VmO48DpX2ZYtsuh/TZnWDzrQcqI1F+nBSii8Y2XC9BTw3aO?=
 =?us-ascii?Q?qMg8y1BDpuUEkbOUYZlHdXUN0Wy8mKMD9Y8PS99i3CTL4fZE5SCF0HorcRQV?=
 =?us-ascii?Q?qIJJpCAmUzabJQJnm5Rp6YjMyOYy/R0Rrd6lbd1OFfT8eTi6f86bEdX2Ospm?=
 =?us-ascii?Q?PdcI5dsWjZZe3ad4lVZng6K6YOunm9s5Ex/2OOild9KrvY0YMVhk3K+YcfRu?=
 =?us-ascii?Q?lx2K8g3auMK94H+7avQnjGZ1IVCczEEYE6iiIaODN6go3MwOMTLpbeGD+rzo?=
 =?us-ascii?Q?fGGyyIdquZK7Pw8ZxZaygaKb6KqPPk0v5RB9hx7hyCwLWlgiwc/YnRouAzNc?=
 =?us-ascii?Q?YhPg64p+T9joYDCZkQ4ZXkymIBdCttaUkDIeN/F/FH9WO02WImuSgozmL8ET?=
 =?us-ascii?Q?zgN11u8qJFc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QYMp0FdxOQjPw73iYil9dDEIjVVUWu9h3ePf55rEDU/VH/FENSmMHAx5QVHo?=
 =?us-ascii?Q?hKNG+4o7oLwtnh5RLI0NzZPNFMInsYJIHmrQ0x2/s4OZdN4N423dYV9Xse4B?=
 =?us-ascii?Q?E6Tm47zrM0rSkzX7v2cjxTjn7dm5re8rRY0ml1P2fO6mOCy2HB8Idxz3uTDN?=
 =?us-ascii?Q?4tflNUzrEjLDAFFvie+jHHSe6vRv4xU9NokZ751sXM6GVwIEGCeLemTeZvc/?=
 =?us-ascii?Q?bEyx4WRyU4pLtZSyqnglozeilVd5xFOex9FaqVJU2Lui8cSU4I/aGhUZsQAX?=
 =?us-ascii?Q?Fy+HXjlalmO1278LzQp4IznSG7tNBlv87c5/XVBfG+Kf4sk7C/smC15oHhU1?=
 =?us-ascii?Q?4NeYGDw1W5yI1RC8iGEhMCVzn+1l+e5Dho7jIChDUrIistttgiJFwUuJX/2P?=
 =?us-ascii?Q?k9BYEtj8ddNjA7rXYi/L8c7MVOZWHcKXjpX3zmyT4NP1s1nw8Ma9ZTzPC9bc?=
 =?us-ascii?Q?XRxyRV+AkUrCS+N43aOYhrxWf8jv89nD9ZhzhAwAzL0m5cO66Nt5VbAhJ5CW?=
 =?us-ascii?Q?a1ylt4b4jah2auM4H61yF2ey2Om/cCTFU/ZpdgRMmB7JxacVjUGUX/LPkedK?=
 =?us-ascii?Q?TTiQJFNbxiztacVUNeC4/UlP1iZCalmnglkoEeWQMQ+UaDi8K9exfwtSa8N/?=
 =?us-ascii?Q?RpPvQNaj3MMZibTbSOJGNin5M1X46O9aM/nwx77ysWUynbfWixFwKguq0mvG?=
 =?us-ascii?Q?OSQmnlXa1wd3m4ZWMgKxyCGtWR7R6l6QqWHYD9Bc6jHnS7AAEQiGFweNLSzt?=
 =?us-ascii?Q?Eg3DHFTZ406ZcIPVvGRukjW0O/5VptP34zNNGqYkXjlSUHyyUjRSbW6TjQnk?=
 =?us-ascii?Q?VcUcfRwv4ceuW4hJ/qlP+xTkNM6wSxAuzXHZVaXIcPeL/rKueU9dC1VYNO5l?=
 =?us-ascii?Q?qAXqgi04takAQbd88KFOIAjqFLvMZBmAPYWGAdW8BSiZuoRkuRHeHhQ5BoXZ?=
 =?us-ascii?Q?uEgSDD0Ck6PM6J/lsHP4uYW47cjAsmbXkZXPz+Sa89QAF/YxWUMOSESPYsf0?=
 =?us-ascii?Q?QiqXtqviBUKaX79xLEYPfG5FucOC7xXBQXO/IGrF52vBXYjxa3ebVksWpwIo?=
 =?us-ascii?Q?HycWYl5fPOTVGuXI/kUVxfG0mlgppglTCmHqctwIq5dkQoDoK3syAd1pQw87?=
 =?us-ascii?Q?pzlgBIyjmtG0xkF6mxdLE/tNQ68fSpn+6ZP9dKIAFokd9qEd56x/K19LhWCS?=
 =?us-ascii?Q?rDmN9u/frp5Nj8B0gXsJa7HS3xSJwtFWdMpBirvq+bEt+SA/qlGYMQyIiUST?=
 =?us-ascii?Q?P/uY/bvK1jDExhYUDjuIoOMDuXAnZdwy5l6GDBXRf2sdFJqJOnECGjommqVE?=
 =?us-ascii?Q?A7H55CYaumcOy+TYcUeYud2kngRX6iEYpEFqGZpDPezKJ+WwCHIcUfXeSUXO?=
 =?us-ascii?Q?umBevlpJWN08m8V9hqAoIrGO6FnrAjJJ+5OmP3dcUnE4AUBL3WQEmZZTJ5kS?=
 =?us-ascii?Q?TNwo/rD9TvIWyRdCchjdPPKWZ/RkCW0v3eKY6CdNBhAnYT1VZKnMYRKecDr/?=
 =?us-ascii?Q?R3drqmom5QI7QH0PmtiY2f1YrPUFcAOdfdNTC2vapkCOh7KmGlnrNiieKxpH?=
 =?us-ascii?Q?dfv2mS1yp/I79IsYry+1GyRNtR43Ro+t2BSKfartacv8b6294RUEW1gbBk5f?=
 =?us-ascii?Q?ow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0GaNF6xIcxq+mMYm9QWFsmaoiVvaWwZj6wF8aEoUnDlh/VPFOyNaznNgZj99svb3Rovxb6Mlq3h/r+5jGzquG/mtNl5LsO1NdS9IN4RB4I3/sqkBpAEsd1OqvoNEpD2jB5lxpS6pDQU7fV2VIkmYezsHFKljXl6rIZSZiPj2wn7ky2484ndR3Qwo7iC1HPmjPz4BhrbutcjnB1cxDzEtzTi6SFI+Imy6moaEwM9r6A3EeyxpeUvuK4M28OEoAkZFxoFKGzZ0wcBPvhB9eoXPSsD28niLp+0OyV33qQsAYMSBaxTWnnStH5sNBoTc+PPQw/nE31/mRS73eWq+xOPo4CxSLqKTOwrGjmOTSjhcTgWiZvv+YFttzWJI60sE+gYWhNCuv44G+107u2Snz2mjif+eIJkQt9TS8j6escc5ma6YOFFqIvR87reOwmnKuAozpRx1m/GDzVbrzQXTUM9iYozlz1NWHAviZGi+yEMLmOGK13wis7GEizegnnC3Smfx6yOnVAEMAW9IqT6J0rc4aqT/WsMPYL92gH+duorLDblwUWQQPKwlr5rd7L9u8qCyEnOv6bVFc8O0tUpHxjLYO3My6gO5V7Y+LYvowpkWV58=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a522718-7fda-4864-66d7-08ddf155e6fe
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 17:09:00.7133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vSLIVCxvpkidIwRWtE4VD0HEiX8OAELZGKbbdNjQ/bdMM/kxrgUpNqr7tPw7xORhj7tiAFLgvSXLRDsil4DFfKvEibf3Tl3xih3qsXSSRVY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFBE86117B9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_02,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509110153
X-Authority-Analysis: v=2.4 cv=QeRmvtbv c=1 sm=1 tr=0 ts=68c30232 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8
 a=5anGnur8A5fybgIL7Z0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 8yryyqk2L4OCWz99UJfDsxwpWnYKV4UT
X-Proofpoint-GUID: 8yryyqk2L4OCWz99UJfDsxwpWnYKV4UT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OCBTYWx0ZWRfX1/Oc9l6+Rg3p
 26vdyidNJNVokyOoKn9UFPtF7ngisLCVWJDVMqgMfkzlklslxIwI5iH6d2CgD4X8D/1liARjwbl
 B6AVNUXq45jOxcE8RLIA1jJ4lasrmxPy5MEmF2rY6bAQ8N69RX5rYsu0gouQXPTajRvtWdmxP2l
 8Wud3pPkPAjHNMzKAuaniApUPTxI5SnWGQhxpV2MPKmknnRSbJOZl2m/QMBwzkYxMEg9VYofo/O
 0vaVfopI7chRHVwTYTJ7+QUfSQIhCoZWWaZfbzuIOJzfpN41qDBC14L6cq/7g+y0I5TiF62dz7L
 kfhSBxFvRLWWaG9zyBMBzKGxiM4dLeGdJQhXXKUe+60mAnjeXBrBOS+mSPpvxmJhIhEqoPYF7Ii
 h2EMUGjA
X-Rspamd-Queue-Id: 5FF3C1C0004
X-Rspamd-Server: rspam05
X-Stat-Signature: 5xujhd6uta9zedi94t9ghr3azizenama
X-Rspam-User: 
X-HE-Tag: 1757610576-308293
X-HE-Meta: U2FsdGVkX1973tnyBotve/OoYRpJVFuHX5yiJiD82h1O3ofzy/h/CzR8qWWhg/5Q1aJk4PI1D4Y3VYoLsgbE25ZnKI8d9pWanR1pb5FLHNn79/zBJBng75UGfPq86YL3WeU7N+JPaG421LcjPONHxrh2WTWxgULebs6U8xYaGkzP+TOlH9c885kstHvhEK6IgLMbuLaGUpYhhlo0/dsI9rrH65E1JZllNqiY7sZcqlOSA9/K7CzsGg2YG5ZaYiyzzJ6Y1rBee1oz5F+EmA4y5yLuTxIw/EKAJCDkP3/CMUBb3jA8FYBiFmvic7YINRJh/gPUY4dNhcsObfDTG8aH6LuRfgpZT+/OPGgCKIzORx90DsoI5GpE57IJMp5gXgYzkIVxAGa3jZvCbOTG6FjoMrXPJrJ8lTY5xjhzWe/9mV3FKQyFsf82hSnGNybHibgAFdHBpQDnDfdLUxbAFZbr+ncOCPqwXxS13Bykk/x3lq/CwfKRfEvDHoMgC+qMAUvvKxXArIv0TKFFFvgiPP0q2vdwVps9rPsgBbceEICm/mKVRJ9LbEb0izM45dPfk1M4t++hC0bbEP/whn+pLWV0Cyyas3nWrKpvAuvujrrAapyCJ6UZeyOi8RPAyaskTEZlTPgCMPzeo5CIrgAdIEnXr8zTn4JB8jYvuTIl1hxlzUau6bBzrquLdoSQW6bpnzpLJGQ4JTarGNM6OdFIVt4r+ejIzzZqUIbVh6xcmE65+2/Xat3y3VqzrnsKe4+lBs++GShIw9txSlFfQcJ8nEESjPu5Bs/Qtng/6SuXtTtdeEZ7M2isAZWx/6tQKZhRQ8k4yNMsL1FFjAJvTDhNnwxjgaSN+2X4fHtxBxKdOMCG0eZ5sgcesqIvSqW2ivumx0rt0kDfIPfcnFXbkxxgwHA9fqfxi6X4x+pS2kf9f9Z2PNFV4FvzPkeWRDzJlxXsF+Jbm0K3HMghDflIv8KxJVT
 su61KgLy
 iqu+FoT3uJUBwD68eDNvtZ8/opPrsAI8Skj+/Pl+oLj0PpoolLtmgLTNApY3xuUmyRNzs/rpGUjNblsyYhRDtx6Vg8g5QwP8NGQtm4guA6M6ACblPzEEkJEm/c0vPRXLUJNlvSJcoWebleVaXTrD57W5oCKcN908JRLdmtCs9wnyGhf9OBsobc3sRiKpxlp/UBCTVtAJ/H12vBfZV4p+cZ+Ad3TzK/5GGpZHLllv8MCwZmdgp5Xn3/CnLCR+/RQGPgxzhkQbM7+7Nt/YU4ZztvTpJ2ihfMJNGcTDr6v6UEeleVrJdXnBig1uLheVHr7b7r0A8pGVjNmJM676sfyi3B/Mf013lTLIUom8SLCOKlcYeBgW1kkS2TgXjyKCepODkOaAGfwtnv4pxG1sFigN06FcHNRp8rkFFv6qEUvVuIbYzGv5kurXWkPKkknQPc7B9zv5lnrrJr90uVsiwVSA7ahz23OJEt0/m+k3hEY4j0eY7u2xk36fMioRtX8tcKRiRXyOJDSze2rE5zCksKTTONDGCy9DXfLDmDxXusKG7to7U/yPoUip4CdDPzCHpJz7o+8TcTLE9H/tn5wGwBXR9fNnNIl0t3TJ4nCE92RZalczmHpFSKT1/+gmlmuX+Hkwef+iFFL+ghrt2HD6Vp/t6x/kdLXQTpiB8y+sRWah5eh/W2mJQ6L9rLNDmjmr4hsC4O0xNVS9XWpkOPYtZzdxWcTAVmxHsrrdItKIWIPPHbDLDDgry9rgp/aDE/+VX02VnZyY11+KsL62LZ/q1tf/8/e7Ot9UXBXb5VeWRdfMtch9KtgF8vQ+tknDDkrn/lJA4rbSRUM7H4qhM9dw9gpvuixN5OA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 10:44:43AM +0800, Yafang Shao wrote:
> The vma->vm_mm might be NULL and it can be accessed outside of RCU. Thus,
> we can mark it as trusted_or_null. With this change, BPF helpers can safely
> access vma->vm_mm to retrieve the associated mm_struct from the VMA.
> Then we can make policy decision from the VMA.
>
> The lsm selftest must be modified because it directly accesses vma->vm_mm
> without a NULL pointer check; otherwise it will break due to this
> change.
>
> For the VMA based THP policy, the use case is as follows,
>
>   @mm = @vma->vm_mm; // vm_area_struct::vm_mm is trusted or null
>   if (!@mm)
>       return;
>   bpf_rcu_read_lock(); // rcu lock must be held to dereference the owner
>   @owner = @mm->owner; // mm_struct::owner is rcu trusted or null
>   if (!@owner)
>     goto out;
>   @cgroup1 = bpf_task_get_cgroup1(@owner, MEMCG_HIERARCHY_ID);
>
>   /* make the decision based on the @cgroup1 attribute */
>
>   bpf_cgroup_release(@cgroup1); // release the associated cgroup
> out:
>   bpf_rcu_read_unlock();
>
> PSI memory information can be obtained from the associated cgroup to inform
> policy decisions. Since upstream PSI support is currently limited to cgroup
> v2, the following example demonstrates cgroup v2 implementation:
>
>   @owner = @mm->owner;
>   if (@owner) {
>       // @ancestor_cgid is user-configured
>       @ancestor = bpf_cgroup_from_id(@ancestor_cgid);
>       if (bpf_task_under_cgroup(@owner, @ancestor)) {
>           @psi_group = @ancestor->psi;
>
>         /* Extract PSI metrics from @psi_group and
>          * implement policy logic based on the values
>          */
>
>       }
>   }
>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>

Again more for BPF guys, but seems sensible, so:

Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  kernel/bpf/verifier.c                   | 5 +++++
>  tools/testing/selftests/bpf/progs/lsm.c | 8 +++++---
>  2 files changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index d400e18ee31e..b708b98f796c 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7165,6 +7165,10 @@ BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket) {
>  	struct sock *sk;
>  };
>
> +BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct) {
> +	struct mm_struct *vm_mm;
> +};
> +
>  static bool type_is_rcu(struct bpf_verifier_env *env,
>  			struct bpf_reg_state *reg,
>  			const char *field_name, u32 btf_id)
> @@ -7206,6 +7210,7 @@ static bool type_is_trusted_or_null(struct bpf_verifier_env *env,
>  {
>  	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket));
>  	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry));
> +	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct));
>
>  	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id,
>  					  "__safe_trusted_or_null");
> diff --git a/tools/testing/selftests/bpf/progs/lsm.c b/tools/testing/selftests/bpf/progs/lsm.c
> index 0c13b7409947..7de173daf27b 100644
> --- a/tools/testing/selftests/bpf/progs/lsm.c
> +++ b/tools/testing/selftests/bpf/progs/lsm.c
> @@ -89,14 +89,16 @@ SEC("lsm/file_mprotect")
>  int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
>  	     unsigned long reqprot, unsigned long prot, int ret)
>  {
> -	if (ret != 0)
> +	struct mm_struct *mm = vma->vm_mm;
> +
> +	if (ret != 0 || !mm)
>  		return ret;
>
>  	__s32 pid = bpf_get_current_pid_tgid() >> 32;
>  	int is_stack = 0;
>
> -	is_stack = (vma->vm_start <= vma->vm_mm->start_stack &&
> -		    vma->vm_end >= vma->vm_mm->start_stack);
> +	is_stack = (vma->vm_start <= mm->start_stack &&
> +		    vma->vm_end >= mm->start_stack);
>
>  	if (is_stack && monitored_pid == pid) {
>  		mprotect_count++;
> --
> 2.47.3
>

