Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AF35CF31B5
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 12:19:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7413C6B000D; Wed, 19 Nov 2025 07:19:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F2426B00A2; Wed, 19 Nov 2025 07:19:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9D16B00A3; Wed, 19 Nov 2025 07:19:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4626F6B000D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:19:14 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5D5213AF85
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:19:13 +0000 (UTC)
X-FDA: 84127261386.20.B678C7B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5FF2040007
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:19:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TVNVHiQ0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UdMePwfJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763554750; a=rsa-sha256;
	cv=pass;
	b=dW/phozt06ppAWr5g/3qRDBoPfQvsFIo1Kzf/qkeXHfPUxXufGtevLAY+3fO/gwT4FjSuv
	Ir4zX+NOFBRiuDK1wgDZFetXSHiIsFKp9m39OWdo6obnDOQfrcKniB0+0a5DoHX0jUK38k
	12j+hs8WkFe6R/52ah6M7GqjfEgwHn8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TVNVHiQ0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UdMePwfJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763554750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G5NpZTGnPT8QsnqvvLdCpRg422vll3CuelGSXHQbpJs=;
	b=m2Q1k/bR12jh0O2S6PujOcnuMukMNxMWwn1BZ6uScF+vbP8ZtVr2rLWCZSZcFCWwlenCSm
	WwtUm8vt+sPG+Ui+N/lmDcGk53LI6LxsFxaal3W+YkuVJ4nQMet49w1XN6fo/rlNYqg9Y+
	na+bvjCJrLyB1NwVl9nwaJdQKWkuIgo=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ9QQ8i028460;
	Wed, 19 Nov 2025 12:13:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=G5NpZTGnPT8QsnqvvL
	dCpRg422vll3CuelGSXHQbpJs=; b=TVNVHiQ0aDrLHeefkUapMKBCwBL4IoiIdI
	rohvX1zQ7pe/iTg06bPima3+PoIn+y6DUTSbWs7D7qmCx7+4GdQIEJHZ7rXYleAG
	7rPrDWepxbZuYK5Iwc4jfR5H9+aU3iixJAewIc9j6L4s4Z+x7jN96DzGToqmDQXb
	0a4ih6JXtkMQNWzFdHmpfPAixYaiY1dg85bAco/njiJJ+1fARsDquQJBzfP7q6tF
	S+1MAtOsVB8QHE+jDAK7nk1+dykWe2NEwrgrKxfwiGUn65sx51WdXBvvKaOeDn8t
	OVmarWJ2FrhgjBfEh9eP2O0LNVMesddEDCJVavam/UUIln19zBzA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej966tq4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 12:13:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJC0juu007188;
	Wed, 19 Nov 2025 12:13:29 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010029.outbound.protection.outlook.com [52.101.56.29])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyagrt9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 12:13:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iI9RVocIbOYTxKc5DXFKeRv605pBwDjOYMiAJW2uQvyoXFDpDcGxvKr2FIYT5z1syYbR7II3kqzaOv039RkQJ0f+43//Smu6v5YnsmdUUTbRAyEBB250P2en7D06pWTc6M6yMh1t6JUHUa2RRgRUNKKUIqlusmPnSPXXzm0QF5pn0wqsmmCxQ18rl/FkfnSYNVr/Ul6l9GK93buCECH/+h4eSluZLeF1a4dRODc5SDdlXn9OambcCuDkrmMVtiplwSeVsfg6y/E7bUQORbi8u5yjik1bfD5LqfLYyXBKMVOphGi47sI78qUdvvtoDhJUkJPSRyPdCk+Z5aQ0SUnh3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G5NpZTGnPT8QsnqvvLdCpRg422vll3CuelGSXHQbpJs=;
 b=sfZG+hemJYUbfRQvdAf/mIHYzJIGqq/xxk9vYbds4R1A3XdyShp+pMW+IRWOeeeOfJRF96CMr9Ig7youicFLbHM+YhjmDY4FGjUlxB4UVd5waSDO5P+3DJthkzz0mObz40Xt1feUJM+yeaYSPMcBn+tUhuVbNiW/t1r8XTvl2m91OoVtprzqYoBiVmv0ajK/7MgxIQtRdpGxjOQhTLtFGcXdCkobCmal0XqWRYEIIDJJU6y1UJA+FUcKmeuApSIdcFBVucl/Os2N7Pxx7kUJrPeu/LpkmU+oNjHrY0WZayvoa5Yx48mmlad7MFTO8bs7WIrxD9tJpU4ZlZUz3YBu9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5NpZTGnPT8QsnqvvLdCpRg422vll3CuelGSXHQbpJs=;
 b=UdMePwfJ9bQndWiYrv3nAerotsaL+iNUGvkGrcrSFqDO72PAeOAhTj99Ku5V/hdnKan5KdYp0velNoxUnWhn8BXSA4b8LWTi/FAjPBuqGG/xxJnUjf9aEqTvDfP82ZEriQtb8EPre5k7agDScao7pfEPeV9mI56nSc4z2Yly6Qk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4750.namprd10.prod.outlook.com (2603:10b6:a03:2d5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 12:13:02 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 12:13:02 +0000
Date: Wed, 19 Nov 2025 12:13:00 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
        rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 14/15] khugepaged: run khugepaged for all
 orders
Message-ID: <2f1cdad3-6ac4-4502-a599-5bef9dbe0847@lucifer.local>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-15-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022183717.70829-15-npache@redhat.com>
X-ClientProxiedBy: LO4P123CA0344.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4750:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d6fb7b9-f107-4e2a-ffdb-08de2764fc98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sdxRcXTlmFDjPB32d0JMeCG/U6JnyeNVmW/0lhk/ymCJvRFyAMZ0LpKcUY5u?=
 =?us-ascii?Q?FwFOn+n91nfsU7273MM6UeskVELSrDyHS3rhIAvNDBz6+52uMH2qDBa8yo4R?=
 =?us-ascii?Q?Wd+YDp2oIwr9+bnUAR3Jqy+EIMymje8D2z63Ny2aHYFtPZGt9tflorvt9r8I?=
 =?us-ascii?Q?jedC1TPypnapWTEOkocqlp0i3rLF9QVnbMdA+A/h4Awm4sNKqmlXsbcgj29D?=
 =?us-ascii?Q?WGVDzje2KC5wdeqn81ZdlE/l/MXoPtjaa+wB6rg68ITpDxZVIfzV0UzLUSKZ?=
 =?us-ascii?Q?X28VilbEMKCRV7GxUop6mm9Tos/egja7JNy5e3lNmD78p21gq35bjjFPL74a?=
 =?us-ascii?Q?N1qhwMz70trj0c76OGKoAoN6g8LSBdEogtr44LG6bbMi6BuLs/2mAB24zHj5?=
 =?us-ascii?Q?rzM828wJ8F+5JLgrrnygccgSQn9VkE2rOymRs7eyFdJHUdfrtbb6599wSr3K?=
 =?us-ascii?Q?L1h22IVXfUZf6YvXEeHV2g0LCS5SmMiYo34IXTKft7v1YX49o5jSiaxqW+2M?=
 =?us-ascii?Q?+HD9R9Cw/XnPoplBwfLGvA7YQ/qKtGfQ/PwmFUd5oF8r83/fr2vdvFxiOvUl?=
 =?us-ascii?Q?3QxHBen0eOciMYhAs/zXBqxIkZqFll80P96madYHewqRUPzTo2qI7tUjWBqA?=
 =?us-ascii?Q?0esJ0eeTezufpRK04IcNzOghNFEVJt9CdbkAQobVbsX1WbFEfeh8F5KQ2k+M?=
 =?us-ascii?Q?HCggx4G7HWiA5leMbriOM9TrD42mP+f4ahgHk93/SevsaLV+X3XnkRsHX9QL?=
 =?us-ascii?Q?8vb82GKzseF4Auaag2ZO+FB1/g8CIEWiC9zGxYJ1iV1CBxf+n+oyOR8I0rd4?=
 =?us-ascii?Q?+KA3lq2Rp78XtT/UdWHLiTXB3MZ9xPVSedkN0InTwbBT0KCaToAAAybD6hp6?=
 =?us-ascii?Q?1h+q13n8OeCVvu4vMBTBftBNn4rWpOUy7PSEjfxcvXwTW9mgZntEGtM+UAyg?=
 =?us-ascii?Q?dxKeLnHjkmqrsr1yTiX/gxEj/3gLbrDJClT68ayIgcCGZpfKrH4deYOfIxLw?=
 =?us-ascii?Q?TiKZ3my62PG6Xn9zzk+ZV4aNSFw9QPJAxxpYxA2e+O8dW5XP06q6WCfrkz5E?=
 =?us-ascii?Q?COmrJjLHBraQMRP4BGWdqiAJLr8At04lA7hxkcX3Df8miJCJaHHYUixJHlHJ?=
 =?us-ascii?Q?OHl0ItRznfVENNS9NrRRY7wPVw51xuTC+8NVL85sWtx4wXhUkFeIzN5SXQ5k?=
 =?us-ascii?Q?wdKpjA+pNSHKaYQDz1Pw1caUrzS5GRhhCncoXtIfqU7k01hupb+5yBgmsm9g?=
 =?us-ascii?Q?fsq81YNuRKk5SQANy12kue9b46FQNpUmX7+h/SAwzGApHXQf8OCsPGJZMFOW?=
 =?us-ascii?Q?cnPZgzkBkB0BSHbqLWozFRJ565bfENaenUpCEZ4bZ/By/UitVCeZGkmwhDzy?=
 =?us-ascii?Q?+6PqeafzfvDd+L09DE7BgPtsAicm3oOUl/349GJWGUr/oyJKicluUrhJE43X?=
 =?us-ascii?Q?DIJAll/sjonP/m2AkOxMOCjhr1/hXIe1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rUXsZMT8RAhZPhFkGrFEerEQ480T7gCmeXWI0S0ksAfvB2tjpDfUF2g/NKdM?=
 =?us-ascii?Q?iSD5X+SwKDQDC7dCPWSK4cKX2dRxP6L+2+O8ocVdMKsreFZx21A39MgKkpBx?=
 =?us-ascii?Q?7isa5ec1numXi+EHiNSLWblpuqwuDQ4ih7AcbNPg6yE/AQU6HM+kv3n8+zQB?=
 =?us-ascii?Q?wxftCOVWvIHahZXW310ygmpzv18cLtzkHFSR7A2M4bY1h3Q+zigHdEJJwVPN?=
 =?us-ascii?Q?Y32viUY9xw9tz6IhCwkbUfd2nFvzKOsign1B/g/7D5qPHqz/1HNuQjOlupLK?=
 =?us-ascii?Q?d5BZqzESN6kP+3PEwY8HJ6sbKKFE2zZag4fz2gvGYAKzK1A6AX81HRTX+zvh?=
 =?us-ascii?Q?ayKEOA6bYOSzUCWN1NsoBHE9XkqvXuR1/J8AA17zYdLtGElL1IG725KBfEiv?=
 =?us-ascii?Q?IjuIKRw1lWZiYKhn8tOkrgAHvw6zDz4GlkvgPPvmr2NcrRCCuV1evxrtVKgR?=
 =?us-ascii?Q?J1AeIJBoaByN/rsULP9jBeA2GL5uvLewNldabQyepLQg9p8e4CaV89/uuLJi?=
 =?us-ascii?Q?RSceCyFJNYmAJ+vqLGlaYWchsZgz5/24lLIIs+kyT7JT3e2LN1NV9GOxxyIN?=
 =?us-ascii?Q?F7Mdr/Q/kwGHo/VeBpOL4KtouwC9/xQjbY5mJREgcqxf6jyyaEMdHCspc4/d?=
 =?us-ascii?Q?4cqMn94iWL5u2Np5g58pB+xkIFkQUqYEEgNNxzwmn3SqYQ+UkvrdkDL1Youq?=
 =?us-ascii?Q?4wtZFsGo9r4kNeU1EljpCecMV8HhPdosDfCLwGMhioQ8xyFuvDEk4cmyHEna?=
 =?us-ascii?Q?11Nlz+ChXEOdPm/1rEx0LrzjQqPX7aOjn98vBFQzTVB2Adyz3/yfvyWoHXKV?=
 =?us-ascii?Q?9rYo5HeGOx/mny4p6+v8S0qyllSNRKczwEBkvqcSWrqe3bamby59zVt2O3Gx?=
 =?us-ascii?Q?UWrwdm4074UFPGlO5m6C/Wgi4pe/Ek+rC0Rhh46Z36qUadxf6NOqmfVQ+aYX?=
 =?us-ascii?Q?PwGE65i1SmZz5fnftdOpdGxwB2ASdEiyoD09nEkhlTtsXxqAxfXi6n0OHB8v?=
 =?us-ascii?Q?mx8cRC+pDJwFHz7F2HItcFih8N/F744lZ5M1Pw9D6OWN8qC+ipcNo/UGqbj+?=
 =?us-ascii?Q?ur9FwFoZMqAvtawdwETQY/OoOXiHU/bX3w1sW0d8DtnhOFu+GeXXKd91Ex42?=
 =?us-ascii?Q?KZzueW3oBFmnW8IcvoT0JMywzheBXtsk1ARiZdozOJD1/gAMLxgHBaA2Nt9y?=
 =?us-ascii?Q?E5XxLcGKwDYb18e2Hzky3hauCUvknPSbOU4cPWMuPVBndAovFM9KQzreOuJR?=
 =?us-ascii?Q?AMa99C1WdJcKQMJyV2HvurHCTWVuoI7uEudnRqV90f4J2yJ9lrLfdiWEPcSC?=
 =?us-ascii?Q?4wCde0InnnGUGzTQV9oT1AmjXrbGf68imzGqv8WE/R9BcA8YLA94remrrfsM?=
 =?us-ascii?Q?wWWZSxPUYsCIDz5bTEa/wu8Mu6kCcL4wjGADVMyNT3r5Y5LQTOGd0JqUW3ZQ?=
 =?us-ascii?Q?+lUk2weprMlkTK0PtYYAFopx7b3VtrjYdBv68PxticqABte3UQTEoxc80mJK?=
 =?us-ascii?Q?VHssAnUNj1F5BtOrVmdD1bcVPOfA9CLpC9LzhOILBb/3oZFKzqwdV83qMgGk?=
 =?us-ascii?Q?ghzSIoVqO8uDYsONOQZ1yfYOIeEYHMmUWyRsvkOyNMbys0z5lAVf3Tpu7u8G?=
 =?us-ascii?Q?xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VX0ulvnvsnhr9m4P8Q3oUVCUAo1f7zgM80sPyOrFjtdmbcWcheQPqfmR3Wr5SgRHUyz4GKl1G7ljluPc7qxDnX7Uti2iKTTOZMNAGOfkC/zDAUaTwsPn/Ei48o8jdXJ5bzicpBRd4IwP1wU0XSFEWB5rJLfeJ8as63i8a0tmO+RME9bk7drgbdZhFv+KJjSohRcpcMmwIdjGZooUYtvcouYARJFvhs4K9QMUZpq64n+ooSBhhrq37QfHi0GlqhOFGEEayvIh1jdo3b7vwSlJaYtVDueDW9rbw3tQRflLiJ4X4tOuo59bezgPSrAvPpE9NkcI65xncCmag14nAETHZFnyW7Gpes+mLjtA37+0ktB58oRZsm8xRzQkXcEvt/ACUJzQI4CaCDf3w/m5178goaAO3o9+MHB2MCMaqLPdbZNdBv//4xSkoYF0uv4tV2uOD62Uo4d/8V3TXvwf6Qs1cxjm5PTS04hHb1rrqhQgQUZoOwKILNABQeRDuCGQWuccGVMdyqXblcpYpRvaJDt+x/NTE238jTGN9yy4SQVHLjqg7BigBUWsO4x+nJ+LHGDLRGq8wnQv9FnFOnh4OFWbJ7t1AqiD2pzE+dU4on5M4bI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d6fb7b9-f107-4e2a-ffdb-08de2764fc98
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 12:13:02.3184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Awx8O9jshyzklC0VCDqeEzvqsUb14W2EeFcfkamsbqHmNb/MMJ7smhOjX61dCjWL4iwJpipLMkw9+ltKoUUqQwbjhGs8CrPMw9jotU31r6k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4750
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_03,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511190097
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691db46a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=SRrdq9N9AAAA:8 a=20KFwNOVAAAA:8 a=qDWtwT-RVvwK0_lMGGMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: dEJVJZgIgKuW1IDJw2hS0tk05j2IJYFd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfXykcOp0Byyd9J
 1vw/VmdneRAYAlXhiJKO1IgPF/7bt0tk5iItSq7wfugIQu3d/bi79noiaA/C/We/i2uATM57lKf
 VFmFpGPXTiJ2bkTCUPYAFAtWEfUiyZXA3vDse9hOnu/ciGuooqc5OMlTO3E43hdO3b0hRkROze1
 u6DM44iWvNPzXEVxtEl5dYJARO4FgrUYcyG7I9KZBPSKkr2S+ziaDobGFKL/GfL9ygIn1agExZv
 2Z5L2H1d0K/avPE/G9R5V7iQb3CarNxtVaENxSGEGuKf99kuAMTWtIpvoocJDx3vhRf9nYAmk+A
 GFMWg1Zxh+9vUygKoZus69ZfgW+Lg85BH1zK5k0Q0yAnfvalPTJVTy/VFWUcFO7nAMwyCNLZkB2
 TI4PLIqRRmvjIo6z6kRkyfq5Ty4rUA==
X-Proofpoint-ORIG-GUID: dEJVJZgIgKuW1IDJw2hS0tk05j2IJYFd
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5FF2040007
X-Stat-Signature: iemmc1zfxrzcrgwgeiukzwmqp93z6zqo
X-Rspam-User: 
X-HE-Tag: 1763554750-710879
X-HE-Meta: U2FsdGVkX19iz4U/LbbMFTwDf/gZp71TEFozY1vDP72B2uOrSm6bzl3l8xJB1EGQr7e9g0gSUXc0X6cwrrjFEAEIoKNM1jAKRUSfM1E0JtxPfYhggKf1kJWZMmkvB3fpdkPZt9Dxc0RS7Em8ovqETTd7zudg1IPCKifFhSBZEsYvd/5rxoJrlUiXfPAweqfN/9gCAyPFUnqht8c3X85MqyQvlJXjlQv8hrMWIUgoS8gQH1vM94jbsBfof/gbkNAHE6T0sxCOsejHmkX9r2tqBhGJOL54rwt5PYyRtk88CyW91C0LD5mMNkDx90aDliaTv21Nd90evkQV6hoU+4nl6zuQGDe61maOKIpJ2xp421L9Y1L3Gf6N0uhkug+94+ikgPfiDRdPPtykZ7Q5E0wI6/vaHsSZrD/XVROy9Ul+2ayf7Gwn9O5VZ1q8r79KULLDvDNyfQV4gXC3QzOdBgvZgd3p3IZHkDeVV51vcm+wxNPtwcylp1ZTXbrIEJsKeLtGR3qBM9MZfzmfXOXmXpscgsRA4HxE+5WpHIBH+RzVj5NluYoPVoCn3u5TQpOhunpdHCT63Gs+fS22JT8fL+x9WIGxAGh3F7Bpc8dfRQ1krwDJVexR66thR7sr+3rg9Qy8Yc4dVNCDEnhtAWaEgwKqgGUVweYA3dPiheFy3oSLr5DNISeqiAco5l2qnKOKYMD3QQxpDPg+HAEpIYPReySmEdQ/bpXdl86cmR1N3jzY35YgozXihL/BCapcTGPjKRiIjaNo6/XhFrsFfkqhvKihwo8wYsK74v3cEM8cvoTMRgxUqa83GFFTQQxSaab+S/IxIHOkHRRnEtSfbpwIGwu4xQinvTSaFVzlgEsG42yqto0zij+/M2s5MChVJjEbUkJ42KEKLwPZ0ZhRfKFYmMN2RPK/el42NDAhVoPXQk5O1C7ayLX9R2kGJNxdJKfFC54MnQWhOa3I47ZhMPg28F2
 bizbPqpO
 zDmnoV+i3+UErscfk7pjPo0Nk3cmpDwhuUJ/E5aGQVac/h8r1A8qBv6AjkiEyMbqbkyy0JqO6et2dxfdSVYVUVQJTcfk52KGlXJGumUINYQNsL5havW6uQNpt3Q1ioiu5fR04HRI6ukxubDJtWDYHERgL1QV+oTcAsnyWnk7p9j1zUi8bIfEs1WM35FTlyu1/q+QjpeYG96PP2UhnvOOteLqKVe0l+VmVGC/vIV7w0CnSw8udHufwzbT3ukjVNxlO04DQuyD2wqsszzy2rSzGmbCyCksQiGDgUm2LlCWnDZ+9tOca6U6Xiw28SL3FyA3MUEpzvtENCcQGe4EwkpGn+ZBO/UgPbDtlop7eE8hwKueMlXQJHpAv8kWwx5xapJpoEWjt9d5xiCdBLoW5h7FEnlFhAR9btNvhTZuiUOCRy4/31XqXFTp8tKXeDEhlbCMvfNIxlT3Wc5gjyNZXclmrL8cZwpdLCuoDXxGFV78f//L3jDMqtKlSSSdcPXlYDSG9q1Z+UFuCkjpcdywIBjjei1N9sH6OFvj+o6ieOzZDRo8Yy+3SgnaB+w5e8pwNyq6WbZeDY1ZvrNuyJgciQBt54525RMH9bByCuVpLk34wx9CDmN1NG78HJExcdGVua7yG6D+8khsEEvp/SaTCNIOcWloiWWUF94AKJ8fRUEmPWUkXavV8mc3UdW0loND/LE4GVwlh6M3F2uCpKGI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 12:37:16PM -0600, Nico Pache wrote:
> From: Baolin Wang <baolin.wang@linux.alibaba.com>
>
> If any order (m)THP is enabled we should allow running khugepaged to
> attempt scanning and collapsing mTHPs. In order for khugepaged to operate
> when only mTHP sizes are specified in sysfs, we must modify the predicate
> function that determines whether it ought to run to do so.
>
> This function is currently called hugepage_pmd_enabled(), this patch
> renames it to hugepage_enabled() and updates the logic to check to
> determine whether any valid orders may exist which would justify
> khugepaged running.
>
> We must also update collapse_allowable_orders() to check all orders if
> the vma is anonymous and the collapse is khugepaged.
>
> After this patch khugepaged mTHP collapse is fully enabled.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 54f5c7888e46..8ed9f8e2d376 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -418,23 +418,23 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>  		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>  }
>
> -static bool hugepage_pmd_enabled(void)
> +static bool hugepage_enabled(void)
>  {
>  	/*
>  	 * We cover the anon, shmem and the file-backed case here; file-backed
>  	 * hugepages, when configured in, are determined by the global control.
> -	 * Anon pmd-sized hugepages are determined by the pmd-size control.
> +	 * Anon hugepages are determined by its per-size mTHP control.
>  	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
>  	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
>  	 */
>  	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>  	    hugepage_global_enabled())
>  		return true;
> -	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
> +	if (READ_ONCE(huge_anon_orders_always))
>  		return true;
> -	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
> +	if (READ_ONCE(huge_anon_orders_madvise))
>  		return true;
> -	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
> +	if (READ_ONCE(huge_anon_orders_inherit) &&
>  	    hugepage_global_enabled())
>  		return true;
>  	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
> @@ -508,7 +508,8 @@ static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
>  			vm_flags_t vm_flags, bool is_khugepaged)
>  {
>  	enum tva_type tva_flags = is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
> -	unsigned long orders = BIT(HPAGE_PMD_ORDER);
> +	unsigned long orders = is_khugepaged && vma_is_anonymous(vma) ?
> +				THP_ORDERS_ALL_ANON : BIT(HPAGE_PMD_ORDER);

Why are we doing this? If this is explicitly enabling mTHP for anon, which it
seems to be, can we please make this a little more explicit :)

I'd prefer this not to be a horribly squashed ternary, rather:

	unsigned long orders;

	/* We explicitly allow mTHP collapse for anonymous khugepaged ONLY. */
	if (is_khugepaged && vma_is_anonymous(vma))
		orders = THP_ORDERS_ALL_ANON;
	else
		orders = BIT(HPAGE_PMD_ORDER);


Also, does THP_ORDERS_ALL_ANON account for KHUGEPAGED_MIN_MTHP_ORDER? It's weird
to say that an order is allowed that isn't permitted by mTHP (e.g. order-0).

>
>  	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
>  }
> @@ -517,7 +518,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
>  			  vm_flags_t vm_flags)
>  {
>  	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
> -	    hugepage_pmd_enabled()) {
> +	    hugepage_enabled()) {
>  		if (collapse_allowable_orders(vma, vm_flags, true))
>  			__khugepaged_enter(vma->vm_mm);
>  	}
> @@ -2791,7 +2792,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
>
>  static int khugepaged_has_work(void)
>  {
> -	return !list_empty(&khugepaged_scan.mm_head) && hugepage_pmd_enabled();
> +	return !list_empty(&khugepaged_scan.mm_head) && hugepage_enabled();
>  }
>
>  static int khugepaged_wait_event(void)
> @@ -2864,7 +2865,7 @@ static void khugepaged_wait_work(void)
>  		return;
>  	}
>
> -	if (hugepage_pmd_enabled())
> +	if (hugepage_enabled())
>  		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
>  }
>
> @@ -2895,7 +2896,7 @@ static void set_recommended_min_free_kbytes(void)
>  	int nr_zones = 0;
>  	unsigned long recommended_min;
>
> -	if (!hugepage_pmd_enabled()) {
> +	if (!hugepage_enabled()) {
>  		calculate_min_free_kbytes();
>  		goto update_wmarks;
>  	}
> @@ -2945,7 +2946,7 @@ int start_stop_khugepaged(void)
>  	int err = 0;
>
>  	mutex_lock(&khugepaged_mutex);
> -	if (hugepage_pmd_enabled()) {
> +	if (hugepage_enabled()) {
>  		if (!khugepaged_thread)
>  			khugepaged_thread = kthread_run(khugepaged, NULL,
>  							"khugepaged");
> @@ -2971,7 +2972,7 @@ int start_stop_khugepaged(void)
>  void khugepaged_min_free_kbytes_update(void)
>  {
>  	mutex_lock(&khugepaged_mutex);
> -	if (hugepage_pmd_enabled() && khugepaged_thread)
> +	if (hugepage_enabled() && khugepaged_thread)
>  		set_recommended_min_free_kbytes();
>  	mutex_unlock(&khugepaged_mutex);
>  }
> --
> 2.51.0
>

