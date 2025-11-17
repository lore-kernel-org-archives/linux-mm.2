Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31197CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 15:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 417098E0017; Mon, 17 Nov 2025 10:53:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EEA58E0002; Mon, 17 Nov 2025 10:53:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DCE08E0017; Mon, 17 Nov 2025 10:53:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E0438E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:53:52 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C569C1601D2
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:53:51 +0000 (UTC)
X-FDA: 84120544662.11.F384851
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 435C240012
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:53:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=imrTdKpT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="GE/WkdnN";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763394828; a=rsa-sha256;
	cv=pass;
	b=oienR/ZKB4BjNT9wPZbaMjNAOtSJTeZcar4kApLFq4900eNhLY45SFQyv7r1XKg7rU5FCw
	yAQCIDZd8PSrlBTsct3VEJPcvXwTXUu6EbBkqn9jYig2q8WIK8GPe8CnFRSa7Z+1j42Fai
	a28Q0RlIUjilyObcjXyXXjxzw+1Ah4Y=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=imrTdKpT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="GE/WkdnN";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763394828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U9WjM7jqJ/UWJ7FJ++9Npf7ZqIHEgbKjboYJVaqeZ7E=;
	b=XkqKs2YqOw9biV5tRMX/GvydzcIJNosk+8qEVdX0T9bn2WTkiFNBtJG90cd0FY+7HRecuM
	0AOvwpesOqQ2rGBoI9GxVQqyCfquKtI4YaQ5l0/0Q4py6KfyawUXN0W4x4IJCBQ7NBOQZR
	J8YW1ozODP08YnY2DyvI8+rYPWn0fg4=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHC8JdA024546;
	Mon, 17 Nov 2025 15:53:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=U9WjM7jqJ/UWJ7FJ++
	9Npf7ZqIHEgbKjboYJVaqeZ7E=; b=imrTdKpTnj25v+/CM8/BcVMVhVPIaPdSMn
	A3vwO5dJqRaDI7HIncNlZ+1TvTrsa1Uzc5aXIXenzQx2+2znXbCW3qtdlMEfNPAM
	RZ3WalKoyJ2sWQ18dYaJ2JdH3NP9R+ltFpVFIlnSx02G4ABthrHaBnf++Ae6UCiY
	P3U8xArn0Maq8nIro7Tv8s59TrXax5+zTW/1egKIIY7AiqWJ1zGNWsGo+WflZgZV
	EqAyLF8ZO1Zyrf9q1tU3jPZGYdfI2msZ1gwks+o2ZmR+ojnQmxtIRPK3Ok0XsvUB
	jf+leZe2K23SyaK/gKZPOLaQrlp1bjxJK9l/7CFUkRtMf2d5EDwg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbbatjf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 15:53:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHE33Ji002514;
	Mon, 17 Nov 2025 15:53:42 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011068.outbound.protection.outlook.com [40.93.194.68])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefy7v56h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 15:53:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KVkfPuHUckzjpjo0grZwTyXgpZKvotmUojhjG/fhzbpQ1T6rgdhbXM0/lZOzJFDXSbHeNMadTe1o3YnUfZwKtE2H2Wx5/eAMHLw1EzR53psdReLOyJxNfiYlZ2dCNGb8zh5qE8O/3ZsnDNSXV4v7bjS5XGYJd7gvo0c+zarF9Zgv7VnxYEs6+nPNCEkJKf+Z6q8d0+ERzN49yh2Y6pt7puU9LNYed9hE7QBFTUHT/X1afkuvmC5YK9WtXXljsaj1Kjqf52UcOZslXCc1RwmQZAdF7kCRZsBF1+MjRU+OIsPe/WRslD0l11srTbqfZenGM6Th8vOVZGmtCwFoFMJolQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9WjM7jqJ/UWJ7FJ++9Npf7ZqIHEgbKjboYJVaqeZ7E=;
 b=MkyWm0V2Z0jjFp2Cq3dAXkdD5ZSReL9O2PYiIWD+IACxiaNXRZwJXZ5uVHsqNhpU9Is/tZewr+Ej8fi9B6bNNKsCvxpyBnMJ8RgzVKiQ/jtzGfb0YZiTdJexvUCLGBv/16ycjVm3KW8A3ixZzYMLU6PmGxXb9HW1rKomsnF5DaF4HMzyaj9mNdcotJgruQmHB6Ojgz7IMfRuruoKRJPyEw4/4XbFMFkv0nYFKXAueUAQz4xVqz6yWFYngkKABQRrWKeq+OQjM6U8E0ZgaVNPKEdFBqEoXyYoETaoBYCNQ8ZlGHGiFKvsEB4/4delzZE4h9HO4I1S73hdNnHd24Pf6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9WjM7jqJ/UWJ7FJ++9Npf7ZqIHEgbKjboYJVaqeZ7E=;
 b=GE/WkdnNKaCKuqtk2r9UzleK3NM+APx//iZIxJFH+O+g4+RQdd8W6N/OZX5Uv2mIluwqlgezJ6XWuaGqkpk50zb3yWNz5YxFBWdtePNpDimHGf71QVM1HuUL9gMNipGeII3luPmp7buhSzUjVAB9PknwreqZaANmULgfvGfKlTI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH3PPF54E75B76D.namprd10.prod.outlook.com (2603:10b6:518:1::7a0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Mon, 17 Nov
 2025 15:53:39 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 15:53:39 +0000
Date: Mon, 17 Nov 2025 15:53:36 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: propagate VM_SOFTDIRTY on merge
Message-ID: <e16a403c-2194-41d3-acf3-fab09441d7b6@lucifer.local>
References: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
 <addc338c8b33aea3c31202180448ea32ef37956b.1763142412.git.lorenzo.stoakes@oracle.com>
 <hrnnpvhpio6eb27w6xnqpdlyrlivu4xfbghagousys44a5dvgp@urmlfv7dyiqv>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hrnnpvhpio6eb27w6xnqpdlyrlivu4xfbghagousys44a5dvgp@urmlfv7dyiqv>
X-ClientProxiedBy: LO4P123CA0202.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH3PPF54E75B76D:EE_
X-MS-Office365-Filtering-Correlation-Id: c1bfdf59-9187-4a01-ede2-08de25f179cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wv7X7U+dS08IPJoGsTai2ETPbMlPIWci5KDY5sKjrdL//instX7Twgx/Jp2r?=
 =?us-ascii?Q?x2O8X4SNz673zQtJAdz0CBMDyQDURsJ/YeNSUgTIgqMHZ8uyKa9x5ppuErQK?=
 =?us-ascii?Q?E+N4VFqIJufKVNzpOWMmyPqE/+k+jiWQ0g2W12jerS01Rm5mMg/cp156jGZM?=
 =?us-ascii?Q?9WCxltnRxfDdP504f6EF9WRgnY8+GUIu8ozOAafbqi9iCcadBjIDbaRtBKsX?=
 =?us-ascii?Q?DVaPgObVd38OzIfr82eJ8s1jzz+m3mkt1YNq+DMj2xJjQW7+Fmh80au66dcs?=
 =?us-ascii?Q?u0SXznC1e0cncl7cEg1MpXMdWzARlfdtrxM821esdNgyD/P1t57+iO3pLGnu?=
 =?us-ascii?Q?Zw6gkjwHkW+B92yvfbjBDPVSpw9vgiJkSyfJNfv1GMQrpZ20EZ9O9MUivOty?=
 =?us-ascii?Q?hGSXEMc2D8tDEjApkGmpwK4Sg/6GrWRrEP923CwNYaY+CzQ7NFkvF9zx5mz2?=
 =?us-ascii?Q?PIfxw1mTYlexsInTUjfV4IwE6owjLxHzuYDFe9kOEkjD/9JgJkOeOJWAhRue?=
 =?us-ascii?Q?PemKqyv4GMP+0uaW9Px/+5TadDpYC9LFvdduLFofLbpR0mcTrPPR0evzWQjI?=
 =?us-ascii?Q?lXTTxnlU2X/UqHnQ/n7kEgK3v93yI3uCc80Y54dWYLfHxdqRHMkAH94Ppnbf?=
 =?us-ascii?Q?Buqso7ENDidduIuNgLZZo0E+E3QHOSv2EkMSiQJTSo02rIC0+TcYxh/ABu+U?=
 =?us-ascii?Q?3b5fOLwxuUdJTuWIPG5MzPc9SHrvpw87FE5FHcl3fEzdw5NtT9GsbSY2NqTr?=
 =?us-ascii?Q?BT9516cxF0rJY81MvcYnFadJkCNtiefxyLXjgxtnbvS38THJNOuA/01uIbZB?=
 =?us-ascii?Q?VK4RkdFMSW5aS9gVt8Eo3Qs13OjS2TwKwtS4jkIPm/jfjjhsfIqFVgf4ID6Z?=
 =?us-ascii?Q?2jWiu1BSD3Pw/KgfgSnpWB4SXUNV5rFiV98eGUThPm6F2ufjI9FxioNU6Mtf?=
 =?us-ascii?Q?GrrZ6FQI8wBwFcwuOBVvs6s7ha990IXPITODrqLf6pvCfWGe1/XP9wKillst?=
 =?us-ascii?Q?YEy3gkGXQAcVVLw6UOt/mqjVcXqd6SBuYC7wE/rj/5/o4Bny7Su1SzG5jO/a?=
 =?us-ascii?Q?qhSPHzzJK+/06XWrMntE4Wn6u0/WSqCy8YsfYVqHkFvmVDFNfdRgfTLVjDnw?=
 =?us-ascii?Q?N96x1mDASbdm0sZeh54gQS22i6+DqzDk7CcyAdQqw5R/qpDgAZzTjqrZW6yt?=
 =?us-ascii?Q?95IuMiT7SU16fZeZGW1hfGvwSzfhgyAlDhFeMETWvCAfvmpQOG2jEcFT/X0P?=
 =?us-ascii?Q?Tu33e5za4eixvjX/3lxgAVxvBHEwKqRRpDznUKIaTX4HmRZ1Bij0yY4+Bp0m?=
 =?us-ascii?Q?ZJjNzlKWzypDzbMSyThaSIUVNbXXIXgHDmrTj2uUzK66X2ghZ59mDb+fMvrf?=
 =?us-ascii?Q?heEUPG8kxUir7xFRugQx7kVVXmevVubp0MOR9lXizlyg5am761bcIYT2G+Gp?=
 =?us-ascii?Q?tlPbEs9eD+tn9yti2dXb2ANsIh0/YizE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LQ3dyMDtEJP64MU7TW4DeUjjPKf+MhO8BEOivbnyNgf5KVygOOFKpIPTG2Wy?=
 =?us-ascii?Q?fEiz7oEYc8g+GSKvPkC2Vp2YmZlJ2Gjm24dpDtDPEMXSOIzJQF40yXAVT1A8?=
 =?us-ascii?Q?O8ADFCBcjvQc32nxLjbZ4pjPkyr2yCG14PoulISVTseYaOT0dRW824VzH/p4?=
 =?us-ascii?Q?WKiUOWnvxp7Z7bR3XjIwIrMwpGpsB0+6yGwNhK/rtfOIyWWIqM8m9mAOade2?=
 =?us-ascii?Q?XHa3UdQmMDUytggF+nNdHgfcmET3V85uJ2hY9YM2CWmEtZnZDgwb9/SZ6qfl?=
 =?us-ascii?Q?Qh9zGb4JLlbMOUC35MmodZlCm89IvKDtDsTNG+iuSVwyWzf/3TaqImDJ2Bfc?=
 =?us-ascii?Q?5lW7/mvAYpZPJcINu63xr2b2RfZ9aLgxdMPocSA8KYSD3w+8CZMDeL4HtRhC?=
 =?us-ascii?Q?4XxJQ3nNj7WBB1h6g1GRndJN8kWYHt3Aq6cmOCq/iShXsTPX3QZJXDI7odMS?=
 =?us-ascii?Q?66N69GEk5jCtJAnQmzjl57H+Bgy84XZlcCU7/kP/uEYF+7UqgpnGbrP9yax9?=
 =?us-ascii?Q?QXuTvLv5bBgmMLo+aI1O6ow/1UoaHt7wcM0FqoLJXDnBaEscNOQBMs06Cjxe?=
 =?us-ascii?Q?q01SgkmzULyRe0syqmtXreHnNb5xy+4PVToZqiL+8UNnGU0m0Cb8p5vdnxoH?=
 =?us-ascii?Q?yb7agbCkW2lATqpDSwhaKuwhvvw/MlYkTKcplc8F68Pa7xh7IiVyDOApywSj?=
 =?us-ascii?Q?8RA9Xih/ZFNMy6EB7LX5mBt581YISOfYXvbp+bQsHYeIC2eGYvO/NhJ2Spvy?=
 =?us-ascii?Q?aivL+sg49JcaVfIxabHBeKEKdAEm7bHU8XpIHvai2kdb0kODikRpnoXFueQZ?=
 =?us-ascii?Q?1Bt6cPuE/4Rsd0PdDdYSmHozDVfoU701LF9z5W56AlzNRyb84E77qcTFRtd2?=
 =?us-ascii?Q?QKmKaxk7Cj72AExFNBVX9X8ZMHBV3q0t8jh4zniLSMj0/GrDkVfjdd6PVxqW?=
 =?us-ascii?Q?2TOBxTXF++ntI/BJfkms2Sp1fCCxhQvT8PHwEJQSwhKVg3LtFPGev6IM09TA?=
 =?us-ascii?Q?JSJdtKSFcvzXeccjYp7Xs76aLw3wsF8NSLt44Kp+xp2NatgCyMN2UXfOciQy?=
 =?us-ascii?Q?z0Wq+asDUL2iRthEnvBCRVAJslRwndRqFrzIfvRuMdLtgHp/0P6RjtGFhIz8?=
 =?us-ascii?Q?vgVdXETh5Gjt9H37e3AVA2GjjdAw2PwZ7QClTNp7Yhzd2zM5D5DBkJf2Fo0n?=
 =?us-ascii?Q?6ubOTvLPUQXm+7swFIylsPcr/C83Us20DHNOJ6yVr0JiDpX3ibWBicCeGzbJ?=
 =?us-ascii?Q?YjuyLvi96ouqGh1wjxp/iGEHaAjxfcmUFH4wpCVX17aqErLZLlUDHIdF5fDN?=
 =?us-ascii?Q?eW/GDSGXl48Lbm1VMX4X68Rk8ynsYur/bpgG5guzSL2kQOOEIdbWtaUwX4CJ?=
 =?us-ascii?Q?FDI23t/sKVpM434+3Pul9BRL1FfrG+4eHMbI5ub2bF3s+2+nSArvzWKrYKMW?=
 =?us-ascii?Q?rRo19oDPXdB2FUvYvDlrycR8t4pZkgeFdQwGGJkUJFSil0HHq08BZUt5YOOC?=
 =?us-ascii?Q?vekuCc3KQCuQ9a0KwBicIIBDWqZQSod0L2YZKfE/8lIJXz0IR+HSyiXxbCxR?=
 =?us-ascii?Q?A1QFzwM5ird4JZCZL+yUP3U6BX96nsZthcNMkcLdHhw4+eZetKIOKp7Ci8um?=
 =?us-ascii?Q?Ig=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I+mnYJROqKkZ4prr0BjOCQpm9ty9bdrRMJJ29aHQ+oFTJ9M4SMOgpfZiYG2wEvv7PywvuHgZSIj1bxHw7LSx27fUd181Rldti86pxCPJB8JGZc1Q122EVICMa5WWZTZWtcizkZ+dlBkpByRk0N3eLR0LdHxzfZeDpz3xeTKFJ0XLCKx+yrHhNckLUcT7G2PWrgQ22yhYl9KNfVJgqnCfKrcikYnQ9E74bukESBVDk1nIIfa/KmYlSjtSx8nX9nTMwzFVz1KR+ucTFvigX/EVD1VSrgMSlVwDh3f0er5Okj/Z6tL/91pdkbenpL/82bxAY7i99nAAEzgsl9Mq4ZXQQ1B3swg7rZ8CFidsO42MV2RRaHfNVWJZzNkOY8uLb6FcNFEnn0E+dsXZ5Yq+ga9/xN83Mfw+oCEJ/BjDtKCtKGlkbkI281BxIBZhUXUoyZ04ZWHCdRbE4BQwsHfiOX630F0uTY24cPJlbR4zczJK/6urufPsYmtGI9q0ryXyFtWlSjzQNxQ9tivg12AJNRWiEIuL2dFRRwR/4RiQTIOKVRS3c0YsAENHwLJLidiaoN0pH8ppdz7BRTSg4STeesNbO9XxEnCPzli6TMOoz3s/EP8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1bfdf59-9187-4a01-ede2-08de25f179cb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 15:53:39.4550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qW1srORZB5hPqHvQViPTccjgvew7JtSJEhfFWp9lnqTbXu0Ehx6vBkGK65rIeRh9gW8+5oQpHezYwg6aejdCnQ25sjjBEgarnZN2sI9V44w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF54E75B76D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_03,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511170135
X-Authority-Analysis: v=2.4 cv=BoqQAIX5 c=1 sm=1 tr=0 ts=691b4507 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=vhSDPgbdtxYiioGkHJkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: JKl7oNBk7DgnHpJGkFxo-j1NjMVj7EpE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX7t+/mWtrJPnx
 YckdJ7981Nb5ps6m0pysGyEC3JMfM4Mtv4mrBTb053qgZp/NdXc3coPJLmJBlE2xF7PER87iEcE
 mw89kgstBVirpxAS1cHMUSTxp0YWqJZtWrK8us/K6FFg/EAb2sUTQU25RhZHCnTNAEJ0l1IaHZc
 2Q6TpwpMi2x2Iq/glg2PcGipk/lt60PSgRkuoeh8KuIAp4528Qvi9Ee8YpdmOKQuayRzprkqZ6k
 GPesQjU52j/9HX3xvE1X+E9ZlM+P/HWrMdyXpbz279iqj6djhYuSNwkcNNq6ADPRZCezx0epcP4
 EZjqyGC89HtHOQwqp7PMI8tynh7PELnhuELP2iW6L7jM5iKCa4IgaKn/U1/oOS1JQr/l2hnqNkL
 jBISlEwnpV3Fm9dWyYEiet9gWcOgPw==
X-Proofpoint-GUID: JKl7oNBk7DgnHpJGkFxo-j1NjMVj7EpE
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 435C240012
X-Stat-Signature: fsstqm83p1dip9iwxyqj93k47dp4c6zq
X-HE-Tag: 1763394828-653950
X-HE-Meta: U2FsdGVkX19MEhNemb7nFwJ1RmNwaEuNVUuxkV5Y75IGkW4pkXeF1KILjPk7rso6eVR9P8Xm4OXmBEMSm5uayawK+Ta08AODsENEZS2g2vq9Pkn392DVHkC0YkpROfAWgh3bng/zNlvPQIiI2HHLII9n6CniVTIuLjPKybEvRHO6gj2ZebA5FjVKnumqpWMZ4gkfIfv2fEVHXuYiUx14eQLhZK2lnIyvCes10kiEcVEGF6rU8AB0Zvfn8g91FuexT35gDn3dz2kT5rdAJbce/vqeNpEYRcWNSLS15c8ksDByVnxxNf4KJQCeg27sx3JMK+cVOlA1rnkyf0DQanml6X9NnFcfF90PRaVoJmvYlVlR4pEpT5jvFoH5cAipzTaiQjIXtmBOJkL9ObWjRtryeXM3SPfACDq6hMlbHqliIW3UmRki2FZEpn2MSnCacvCgExOXCftnwnjI+oB/+ASBt5QxXwY3VZDgxaYdbzVJLnYLyLxCCcv5rAFGkKd2dhTsI0gzQpitXD/SzD4i+Xk6ejI7nFKvi6r+O4QETlVY/LVQa3km2S20pcaTYlbmnT7jfTAPmugzet3XtYRUfIz8cVCDE5gXIy+uV8zFWKMRyBOGcIc7KUai/gDuAyh8Y8m1S5wZAwBhpGqR+VEIkogCi5Y7sjJHOZKVUQsHF6Icu0e2F7wQMcLpbx1FUqmOPqmJdu+kGdhLzAj3Um4jviZIc9OTe5DP9O8w+YXdwiQ97FjhT9d0f6qnZ+QWFWzTnzC5bFI2gzYSFEGtC4cYQWBvRdBgkyNPrfJDQh1lZ+o+NWUiOn7rvp/e3mxTBt8/3brxENoeJrkuo4xnuLtCEL2kXjCX3+OgKvmbSUXZaVomeA03FK6r3UbEUa7xnOxueDDjGlD4QeZ/cuw1WZ/fDYoezYpeO94hmFrFBxr4T0cBINe9h5XEYLUllJlm3iS0caCoCqxIHADiDF+aDTIh9od
 5VsUkB5l
 BBbbchnpFsZeTsTr2IVDmKayCMRSG4bxrtOA5/iiHZHg93jOjjzKjk5zgxCOIx3fVRqy4+lKhz9cp4KRPHQNHts24SD5wqAHBDxWTRtUals/6S4bWiGSdEPr8YOE9cwOixfLzlMEcGdfiBeRyZUA1INcU1/SUSdJ5KMqpubOJrw+GcV0j2h4XUFx9REWmbgLB30JP9a6exr5yPkA7io0j8pdK6lJ+PT8gU/vTDbfx/qkFU9V45Vf5vKd5/sGMnUHYimu/zM2WxGDks5uU76h2lS61IrRKf7ffRm9pATKD5Z7J6YtrahSSjP6zBH8oJ6+z89bThW3wuMpaZM2+MFU42DhNu7+IuKDnFsjoWfkExGGPIc9X7/WUd/z7L9oF+PEtGRskXFDpVsXGC7pd6lIX/cEHOPCRgO60cQwuLp8GrXSo3eg/6AjckbobkpEASlurPAlv6j3OieUMxTJoxeRXp72dcyNOTA5VwK1mEO8C0H+Y54ELwCfid6UafdI4dLWhXfKmhKV6PlXWFs4xy1XiMyg2VD88+DdWIj8bGudtb+8bh4yEJYAwMIwAjT55SOP7/2iiS3FR6/7i6GBCyrxb/3XP5xlyAD0zH889BdL/xZ1d0SxTbBkudcJ7ZGfWdgfIpCSLz9mhOly44sTzrlGjK/tVk4IHLWk0URS5qP34W9r4EIEL7r/RHcA5/uClHkSYZDPK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 03:47:51PM +0000, Pedro Falcato wrote:
> On Fri, Nov 14, 2025 at 05:53:18PM +0000, Lorenzo Stoakes wrote:
> > Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
> > establishing a new VMA, or via merge) as implemented in __mmap_complete()
> > and do_brk_flags().
> >
> > However, when performing a merge of existing mappings such as when
> > performing mprotect(), we may lose the VM_SOFTDIRTY flag.
>
> Does it make sense to backport this to stable? A more minimal version, that is.

No :) This has been subtly broken since forever. I don't think it warrants that
and it'd require significant and risky changes to older kernels to even make it
possible.

It's more a biproduct of features added so let's fix this going forward.

>
> >
> > This is because currently we simply ignore VM_SOFTDIRTY for the purposes of
> > merge, so one VMA may possess the flag and another not, and whichever
> > happens to be the target VMA will be the one upon which the merge is
> > performed which may or may not have VM_SOFTDIRTY set.
> >
> > Now we have the concept of 'sticky' VMA flags, let's make VM_SOFTDIRTY one
> > which solves this issue.
> >
> > Additionally update VMA userland tests to propagate changes.
> >
> > Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks!

>
> --
> Pedro

Cheers, Lorenzo

