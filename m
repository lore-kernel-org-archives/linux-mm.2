Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56EA5CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 14:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A47E6B00A6; Thu, 21 Aug 2025 10:48:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97CF76B00A7; Thu, 21 Aug 2025 10:48:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 843BB6B00A8; Thu, 21 Aug 2025 10:48:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E59F6B00A6
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:48:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 327AB58AE7
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:48:54 +0000 (UTC)
X-FDA: 83801046588.03.24FEE48
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id CC240140007
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:48:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Ulhfm/5J";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=b1mg3Z3I;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755787731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M8O2JJTC7pIKMeTJca1dc18YoysPk8LtAX+2mKGMbJI=;
	b=fimU7cLFfXiDSvqe1OdOr7LpJFn0w4G7sSGFTUYeCtH27Pqy5XoUQLSN/BFUWsFSWLhzNv
	pt3y61LYBS2qKG1XpDQkSqrgZC9lrfe8ZRFAJaDCWppkzY3lbbB1zecpY08vF0nteAPgCu
	WwwJLbBRbDCOC7jI2GpNHlgUSpT8xOA=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Ulhfm/5J";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=b1mg3Z3I;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755787731; a=rsa-sha256;
	cv=pass;
	b=rKdH0xnpTuuzn1U6FQXhJQt79WBe/iruAZ1FdS86rqTtskMmXRd3Wa+si1IEJHkl/Dt0fO
	0dfgpkfUaUctND35v+Sw0psv/0iLrbnrsbNqrR9+UPQYihYPLqsvrwJwy4P9fejzrtAc1l
	wwtwsiLaOay+nqaeomNobBaED8lsmjk=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57LEhbLD032031;
	Thu, 21 Aug 2025 14:48:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=M8O2JJTC7pIKMeTJca
	1dc18YoysPk8LtAX+2mKGMbJI=; b=Ulhfm/5JKxRiFaY+cUyH22fQtqCNU3GJ5w
	ClfTZdEavyEmk4gCoDmnZ8Duy4f8jB1dZE8b1/fc0LSV04WVtO3EtK1Az4c9sgzO
	VDW3SpTbc9FDazDmVCYMXEHQa0k0JzTKsWPTgVDPoeMDEze+Psu9o2wiX2IZfXVy
	R9ZccZlE8CpvH7aacWxJJtc8Or9+KuX0ELXcGfiKBtvuJfnvoAca8U6s/HndhOIg
	3BhGSr4DelCl7rP+VDxjTka7IZr71tKY5HZQm9gJ2ybVWv+UghEN9IQEzs7afE83
	qINnP7mEAQQAQBUJ5e0MIp60Xkp0Jeigv8rMwKXhlEslw58iMH6w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tsujqa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 14:48:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57LDC7VT026336;
	Thu, 21 Aug 2025 14:48:17 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48n3sxn3b7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 14:48:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QyT7FTixVd+gf298UPtkldhjgqT4q09kvU7JHP8A3HdA4NWzR8rHMH+ilOreEFf95LpSNhQcP6YKP3rSehCsPdSsIcD9sUMqO2k/IfEqTIl68+EZBIH1T1xef/uoUFw1/+LwRW2GiRDitsSmqtUWSgpNeXKPN2/eCp/fpL7cJj6ZN4qqo5Gx2Cp7lQVIlsjbjBAyThH8fNMvtmF/4MJYD2ditkzWJkTccMZaooPj3KSw+CJWOljbp1QGw28njEkZeLkJICC3LpK2sAlwMyEv5ggY0MJzXIL3hQQsPbybmyQN1xaI7Zu+zZc0bnGuTkVnirBe/p1DWjsSWa9S6JGGCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M8O2JJTC7pIKMeTJca1dc18YoysPk8LtAX+2mKGMbJI=;
 b=cChuq06TRE9Z/UfOCwjgggHKOAnsioGP974qiIufAEuZej63OAi8J1YH9O/Gp1atHtdrPrZb7P1CJlr78VgEXtnzJZX01HpugsM+Hzz/n1hFsQulw0Vg3LW10XVq5X5CLK05w7qrPRZnX3rBoY/uujP4zK18GZlsVNPP+98srRADQXMMU07ZZATXe6eUY/nUI7StplQH0vTb/Sjf5UChyChOyj6oksDVX+41+Mh91n0Py8PbgsdQTNv4w5OyS7/euI1vr2PTxy2nA+BBw9SOImHP/0tqms+w3KjWOP7ArNSkV6vcFaTd0YpYbf4eBVGkypdtubJWYeiHNqc0UoaCiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M8O2JJTC7pIKMeTJca1dc18YoysPk8LtAX+2mKGMbJI=;
 b=b1mg3Z3IO3ev+oGqH4q2VliVVn1/Ecg5XL8bh32hQp6mDcfse2Pjqpwp/Mv/weF0pb+cbFTHueOX/8K0pLyCMhWITB0Z8QkzvrflWhxCjB3sLW0EyAGBJbYGfX6YPLNa15QVzOUiRoM0vIkYgzt/pWEMS7pctm0XUcxJDkVixLM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB7252.namprd10.prod.outlook.com (2603:10b6:8:ee::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Thu, 21 Aug
 2025 14:47:55 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Thu, 21 Aug 2025
 14:47:55 +0000
Date: Thu, 21 Aug 2025 15:47:52 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kirill.shutemov@linux.intel.com, aarcange@redhat.com,
        raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
        tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com,
        jack@suse.cz, cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 12/13] khugepaged: add per-order mTHP khugepaged stats
Message-ID: <69e9c0e9-25bb-4ff6-8469-d9137a5e5a75@lucifer.local>
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819141610.626140-1-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819141610.626140-1-npache@redhat.com>
X-ClientProxiedBy: MM0P280CA0058.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:b::25) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB7252:EE_
X-MS-Office365-Filtering-Correlation-Id: fdce3df2-22b1-49a8-dc69-08dde0c1b698
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rTA53gDoszq7ZwASgD2ustZo78dwTWVlMvoh2zd7OGAKWKZPeKkREsfjTHzJ?=
 =?us-ascii?Q?Zqp64EGqptRSu6qDTrLyols2P920Qr03c4ifT67ZO980ktws1EdqEvUVQY33?=
 =?us-ascii?Q?qApTlGBKMX5VUBIco+0WFCOfVq3nU/40tjED6bC+wozJifM+5IyPMbECBHNQ?=
 =?us-ascii?Q?9OKvvGaal5w/SN0nDq4NLkEjGjf2ovXdDR1MSUK1enBz23hkLF3TbnZ0J1rC?=
 =?us-ascii?Q?E+kRWirq5JC8av1IDEYBBj/Zso4nVGrkO6RyrEfO3+WynALtFsfWkY4eK/yB?=
 =?us-ascii?Q?kUxx4pCD8n2jQDGMpxZVD+ipKOSCyia/ACF8SbAloLOwnh5eE5u2VutvUF8B?=
 =?us-ascii?Q?HCBrWV/wZhCesSTSO4Zs7rmaoWsvqWm9GhxKIC+aJ+Au+v48ydk0345oWXBj?=
 =?us-ascii?Q?Ie4zoJmu5Bp7FGY/KEKXenl22Q4z33PW01+GQGD65Rpf6L5h9KPTcC4uYzEE?=
 =?us-ascii?Q?4xJGVkoeu/LW0KIjYboDDA3oUmeWAIA/6iSLOI0Xn+T3zbfqY1wFuCBbDtgz?=
 =?us-ascii?Q?5QqvRFhZ4oYk97+Q/SQrRWPGTFrrVKmCy1Jva3gNoGf2Et9JOVgn7Q1me3Eu?=
 =?us-ascii?Q?alYJ0yCBz2SFmBFWA0BIjt0wnfN4kh5KUoqRuS9DEYTJhyZ2zIrn/Y6afy1e?=
 =?us-ascii?Q?tQMEBGF1LfQujGUR4s8y7uvs73rfmtnopYAic/j8LpFsJBLa30ImpxcjX4hY?=
 =?us-ascii?Q?/Hkb4kKSku4wkVtuoML6glD4/Zav0anDFg9MgqWi3OcAQQxe1Yxz0EHPND62?=
 =?us-ascii?Q?i0sJUKEj/vABqz2woUVt+4Hk5T6h9IuHJzrgfVKN6mKXZBNM9i6rA2t3g21J?=
 =?us-ascii?Q?SbpKOmZLS/j8JNjlo48zsJ1k61KAB5pchL/54mEeoCYZIICNnv79rX0/XNQP?=
 =?us-ascii?Q?yy/eyX3tCy3IwQXmB6WxEdx2407f4iiD0bli+f2qD/yxCMDCK7czy9RG4yjC?=
 =?us-ascii?Q?+JwQEcN6B2Weg0J017bPoXVv3R8MvxT3X5upLKrTYZwqyC7o1ZRKBggHsKle?=
 =?us-ascii?Q?POB8SUQrRsA/RJ7AlzzPiz1UjIWk0/d1lnWyXm/FxT7Z/xQPFop5HxYw2NNf?=
 =?us-ascii?Q?fS8RUBrxu7KS0EP0+I5qWOywxAS4jqztcR3t6XBx3hQMUSDgjPzzpknCI92u?=
 =?us-ascii?Q?HpyRrPeAs89CyHjydcVmYZC9dmbO0DE3dzP5ROdbuqiUeAAzLinsvWSixWsf?=
 =?us-ascii?Q?d4B7xTICAEu47b9lYptTokUSmYRp3fYqzcuObs+C7uCGi5WZltmCLgwqfuEs?=
 =?us-ascii?Q?2CBwk7bA6eMBpv53matz2S/iXSGprO1zMKiw7S3VAF67ujxFU5ssUD224sSl?=
 =?us-ascii?Q?lUM8hpbWEiN5+6fGyy+wGkfwcB83RyB/Bd0Ud9NqzYPDoIiXJirIW4Mig0BC?=
 =?us-ascii?Q?BpEjjC+qfeAbXeWN58mcUsKX96s2AzOdFZz5Hluvu2y+m4QfVsV2q0L+/a3n?=
 =?us-ascii?Q?c2QG7NFRxtw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CcoKSY0uP0XoTN9p4qX3/uvxIjw+cEsDgeZejw+Il8rhWOWCOuxIEpGFQ1d7?=
 =?us-ascii?Q?FDp949xtXU5HMRRGPcM+rbKlUlPADhYl0mhTrQ6puFROfKKxaCrIxvLa448K?=
 =?us-ascii?Q?8b1AvxZprb/L2cCykvoxZH8yXaJZzk+7jyd5fKbCLWBg6YQQCGMdERMkseQj?=
 =?us-ascii?Q?5L7v6aLFUV1xBoth4wT/8MsXPVJODPovFdm96bXVAxGHJpiPV1u2PT9gmskw?=
 =?us-ascii?Q?GQwxeyAj66Cd5/AKAgQxNjwnfqRKvM58rxZTGh8paOAVqxGxFXlbpNylFf0a?=
 =?us-ascii?Q?wU11fbTZPCuWaHh4KeJLFZiK1Zx7ki6KYSFDMlci4XkVYhGPuqYaNqr6kV/p?=
 =?us-ascii?Q?4tsrKGKJOjFwqYMGLKpX8ygMXwKJw7BuQKS15mbZZhAHIUXt1q21TNleQsC7?=
 =?us-ascii?Q?BlDAQHXz45ZyqM8YEQTbzreyn3tUFYOLdQMcztZeOI4dAqkE2p9Oa/u+EcIR?=
 =?us-ascii?Q?U64+1zTCNcfrROkcvjUuhyWOJmntdxOWC0OYXAVQK4974lCv3mdjncTykOKX?=
 =?us-ascii?Q?/FwkLKOL7tHTNwvK40zWHFWechap5sKhRp+8paCyaqy6wgiF5xSD/PiMCaCt?=
 =?us-ascii?Q?uIhEl/e/Jtjs44v+XCkNFeYlT2bvIn77dVLQ1nlvuc/XzG7oJLurrh0dJqs6?=
 =?us-ascii?Q?8MiFJjHKLGyyG81SNRcHfwWxKpoCGQkcTpd7NfaEI/3mqLd5yO2JHTrujKz3?=
 =?us-ascii?Q?mWoywJBo2g6D/ZdOiADx9aGX7Alac/3qRgPswSuRiziZmCXe0uzS8hiL07Fb?=
 =?us-ascii?Q?NRucAZQJDjgWKIrP8wE2JKgbp4iPa8boVHkHj/ElGQb3pRb0elqhI6xBuO6O?=
 =?us-ascii?Q?WmJaUl7MvUd6hc2NFuYeSESaoxcYFhVwNG211tsgubb+yVV4qlnIWX1bG4HK?=
 =?us-ascii?Q?QcgT9X7ogZuheeeThfZuF63Z/FpCnZSAsRnc2QVo35K9guppx18XkKb0m6ai?=
 =?us-ascii?Q?d/G1IZhBiYcsFWkSqdh6hfnhKho7LVjOGP6Ofkz6mN9KhcATlJA2DA/x5E0H?=
 =?us-ascii?Q?uy0Y5pWO9BQMcWNH0bisFu2sumeqVrJo3v+akHCTeDb57pLBSaKF1rfEzIfq?=
 =?us-ascii?Q?bBGqdaqUh3OxmZEEwIkqvZFa3K6dHV5XEkrvaIib97AesFuYkuxBx0FzWNFk?=
 =?us-ascii?Q?6AksHCtoAE8WfOXoEA4taGMvvZHGDbj9WRmLvtDyuRPx/lf2Z7kl4BPXk7vv?=
 =?us-ascii?Q?OK31HcDli5xO80IPajH3DNm7xd7EphFivWb0PpCJq3mnA+zJvXoS1YJTsc0F?=
 =?us-ascii?Q?+iww5B/p5vrye+gSCGqj7b0dizmYyrpW/tbEu0o7+DqwcVmUJhR3nA9jYLO+?=
 =?us-ascii?Q?PxYqzMkvGPe3e8MsNsi4FBFOlkEP+mZzHaHyPHr+pkwwlEB44lt3gE//V7Nm?=
 =?us-ascii?Q?MYfQR/M5sOTtIyjXxbmEetYiBnhXYb1rcHAHMNAZV2pYTMOUKFgKXeUPriKH?=
 =?us-ascii?Q?+uNkoFJZBZLa95ro7Jiyax9gz2fUQVdzdQknxFj6s9bOZQLv0SHrFPxIG0OG?=
 =?us-ascii?Q?C27AsasdqGk0Zu8nEmEYdNbAjjeDXDAv/Tt7lRtfARm5x01zs4uvEGE6FVij?=
 =?us-ascii?Q?QtgB+T7YF/p+HaxGggu1UPf8kIMCUp9u1PNQo4bttNmuMNAxixICAcSTARab?=
 =?us-ascii?Q?kA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cruyF7waZPci7k72xtEjWcJsOJe5+K10OzrZHrYUlqa5ndTU7ZOsVUaSrNrjQ7agVSNhihwMXAFHCHcThkfpU92e461mlQrkA64/Kipy4BB9aMeXd0sWMfoGY+sfTDyrrbwILfmqvRYezrcYLo7dP005tHQ9ZFPpge1Fvtk0oN7jq2wKjblKpHz0H6QAvIRnB+AskHPvzJVkwh4i9Q6zRQbUXdZFJB/C9Fr8uIrtzooAWkA9ZNejZlUgDifPUM7stwf6epzS6VQkFm0Xw9fr5R/NGQ0RXj6/5unIU5w7jZzog4UdSEzRD+2ZK3p/SvWiiwkK3Ob7p8ECILRmrtkwdMboZg49NYC5bnBKRAcufVpSX/Hah02/2d9bjhcaS3Nq/K4+bR+DEsa0hMZUPkeaUXZKk2Fcerk+1HDCzVxwanNBPaDuKcy5tF6lXUApEcEGOJ6UNOvOIJGQN47JsO6nMwz4+uDpi6/f5yRQZ9dkl0hnMATq2U/YSfBKsF9gqnDu4XXLucmxpCA2h0Zv9uOptvqG1FV7+kWJ2Eg2aATBoi5DwWOfW7+IiSFOMi/p+BIRFOFylGv4rtkiMIv2Km1zHIWAirkr10OV6QLWiltLhkU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdce3df2-22b1-49a8-dc69-08dde0c1b698
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 14:47:55.4491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mndDs9MD9xvO9oGuu/KBylCgo3U4b6SxYn7Jemtin6rKPi92IjeAjYxXly35ZMgELdTz6sCLMVtWXQv1lIwFLDyWxJwYz3HUH4qpZjv0zQc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7252
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-21_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508210120
X-Proofpoint-GUID: vpXXJd_36qQK72amN3GNc6nWSIi9BeeZ
X-Authority-Analysis: v=2.4 cv=S6eAAIsP c=1 sm=1 tr=0 ts=68a731b2 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=Y7f1edr8uATmA_85KAkA:9
 a=CjuIK1q_8ugA:10 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=QOGEsqRv6VhmHaoFNykA:22
X-Proofpoint-ORIG-GUID: vpXXJd_36qQK72amN3GNc6nWSIi9BeeZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX+i+42olQYdUh
 WRjteooGPhnKHGbi+GZ5YT9mSql1xeMRuaIg8VMpHVQA91c8/TK/KaOra9WBlkHghTJPnAhV8Aj
 zbWx+OeeSRB+b8OkG94Qr4B6BfXpHQJtvkNRD0Y9Ma5tKuFS+nWOaJfZK0hCj4PqxGnCP98yjiC
 f0s3b/gbYMTvZBLK3OQquop00IYgG6ZRzr9HobmpCEXEYxwlVSh+JmWlmMJyWDMsa8r1HSv1AbA
 Xxib92wuHt8+MFZS/r7yOYmEfGS9ZkLQP1y93y+95X7HMYudHoxUw4RHftm874cFkjFXyu+0+la
 he3DW6pkdpJnEjHYsb8BS+MQ6x2xDBH6heXUH7sCd2x39WTVkmQUJ08RZee4G71TMlzAmHxagGc
 F0UxqZ2hxDldcgGUZeaVsqP1SkQw4Q==
X-Rspamd-Queue-Id: CC240140007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: en6sigeqr4da3gko6usdeedgmxb38wqz
X-HE-Tag: 1755787730-255480
X-HE-Meta: U2FsdGVkX1+pM9YOcumpMdEYMIJhRvNWjrezgkpExTvgd2oRjI7JSoQ57/vTKTHuA+2BzBwtmZ81LZhHhAOFx6VXxTJWLej4Vf8El2RW4IdueEOJCBIAJg6XqcH1A6mmcwl/5tygKLfah7p6oeqzNO3MhbN3Lq3WTdu45BvzXNkw+DI75aWH8Xr8IX2xmIZANK5rKF+7/AzqRSpOkXsjTjMCktOEfvBpC5wCFoLQogqUWQRRDhJ4IInJTW3JIugl/OJIaA43RHMqv8vy084c93vJKNKO3THR1O14QfHmorDYvBDaABSXGl7QODtl7Xs5e8LqsAteqgytstW0L4BKXFtxH2NfX9RjX8XKw6b8JAX2Vd2aVUwdl0mz47juspX+G7hgAzTbi1DTsX9gVBAL6WYQ72CCPC7uz8D9TSGe8xP1evmMyfWlioFzNj7vv+LkHlSHNPtqBiA18+CiMbWCJ3MGd5mAYLLaceNyTrKv2ZAdB7JwrADq39eT6s7ny9RB6ApBuVXRvCr4/7iYrh9XAKRqLmZ83eQzISVJpOpdrgz10/IrmREwVi3wJsJjhb7GHDN3aCC98NXbKl0mlUzkv4RI2CoLK8SfdzNDhVewEDdbEI9DeI/oUGTZmsYtQAp2b3PL3rYDsSPi0ptLERPWMh/0vDa/Z0DQ/cZnLX1HUfdxQXEnlRGLlbjTj941t4X5FfKskBt7mVi1MppbyyYphHG0+kBw5O/AkQWWMCOsgoRxRBjqM16UlPdjOcjndDy9dhLqpTcku9ibgII6MUcsCLWAjo+xulFNSDifq5xP2lmQRyKK2W9HhOI/KGdXzNaJ8DPnn3osPufohAQc7CIhMvrAcJdRUR9svi3S86fDxYsKCojDWe4F/V2CbP7xvxopeC098/nDpYJt93ARkX/V196CFnEr+l3nlZnutZss7z9IKdq6MAUCn5QGqNHi739vLuT0FxdiJHWeW/Orgc/
 YT/pEua7
 cLBNEfqSYMmJxd0TfiXOZMP3DBMfxbv0QYtWOWQyFKcw1Z1fxVld3OcPQHePganKg78wmexfb9qi7czrolLuLZEMnmSfdMG4ey9QyiZp1oiSPPuDazMuJ0TtmkC77aqONPP8brMhssYslFR4AY09vgaCq1q65PofZz/RHT2qkibcgZJAsPI1UspWsS5HZ8ty0dnP+W//I2rCMG+cORxfXgFDMPmh5cimwkgsabFaRqCw8Kw5bMHgzoWMLsQ9fFPB0kT914WMKpfR360Ucrl6wjYiuNbzVU5ZRZSh6zk63dveX94xMc35Gzn3cUh8/IAAv3YfB8SoY6YKqjyeSVd8Cl0Qf4n/PxzpUDjjhTvFKZ2XWSMm07JcUhpjCuaVh10nNkMv8naJy3Bu90wTz5XY7tVvkzI2HsT1ex+YWrlLJxVf6eJ9TRTm51RdlWuHNk8wyIdZY/WHaWj8hVz1VPGZZJz4NI8N7K70p3zbpe6a1OcRecpKkgPdsJOvavNYdZy7FiGc7h5uC2uutQtBv7uc5GuKME3TDBUXrEwRn/3OiklXxXAAE4c00dT6+3KmGKZ/mUMcePBAMilvcbG7v4MBvJPf9HBP14XjdvOy9p3Hwe6fRipmh3yYWAzDvZ91IWK5mx75/yCfHoIsUQpD83MTbkuk+LjkLNsDuOxg7qXJZ+jyxoYWpbzFZwa5RcaEVsm/g79THo4qMU4D8ACDDBk9E7aSg1NTmQSe8PbDanIpEENQc7T5vt8e0yFXaQxxrrwM1LShCUKZL8zPJQ99FS14cfmjL6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 08:16:10AM -0600, Nico Pache wrote:
> With mTHP support inplace, let add the per-order mTHP stats for
> exceeding NONE, SWAP, and SHARED.
>

This is really not enough of a commit message. Exceeding what, where, why,
how? What does 'exceeding' mean here, etc. etc. More words please :)

> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  Documentation/admin-guide/mm/transhuge.rst | 17 +++++++++++++++++
>  include/linux/huge_mm.h                    |  3 +++
>  mm/huge_memory.c                           |  7 +++++++
>  mm/khugepaged.c                            | 16 +++++++++++++---
>  4 files changed, 40 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index 7ccb93e22852..b85547ac4fe9 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -705,6 +705,23 @@ nr_anon_partially_mapped
>         an anonymous THP as "partially mapped" and count it here, even though it
>         is not actually partially mapped anymore.
>
> +collapse_exceed_swap_pte
> +       The number of anonymous THP which contain at least one swap PTE.

The number of anonymous THP what? Pages? Let's be specific.

> +       Currently khugepaged does not support collapsing mTHP regions that
> +       contain a swap PTE.

Wait what? So we have a counter for something that's unsupported? That
seems not so useful?

> +
> +collapse_exceed_none_pte
> +       The number of anonymous THP which have exceeded the none PTE threshold.

THP pages. What's the 'none PTE threshold'? Do you mean
/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none ?

Let's spell that out please, this is far too vague.

> +       With mTHP collapse, a bitmap is used to gather the state of a PMD region
> +       and is then recursively checked from largest to smallest order against
> +       the scaled max_ptes_none count. This counter indicates that the next
> +       enabled order will be checked.

I think you really need to expand upon this as this is confusing and vague.

I also don't think saying 'recursive' here really benefits anything, Just
saying that we try to collapse the largest mTHP size we can in each
instance, and then give a more 'words-y' explanation as to how
max_ptes_none is (in effect) converted to a ratio of a PMD, and then that
ratio is applied to the mTHP sizes.

You can then go on to say that this counter measures the number of
occasions in which this occurred.

> +
> +collapse_exceed_shared_pte
> +       The number of anonymous THP which contain at least one shared PTE.

anonymous THP pages right? :)

> +       Currently khugepaged does not support collapsing mTHP regions that
> +       contain a shared PTE.

Again I don't really understand the purpose of creating a counter for
something we don't support.

Let's add it when we support it.

I also in this case and the exceed swap case don't understand what you mean
by exceed here, you need to spell this out clearly.

Perhaps the context missing here is that you _also_ count THP events in
these counters.

But again, given we have THP_... counters for the stats mTHP doesn't do
yet, I'd say adding these is pointless.

> +
>  As the system ages, allocating huge pages may be expensive as the
>  system uses memory compaction to copy data around memory to free a
>  huge page for use. There are some counters in ``/proc/vmstat`` to help
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 4ada5d1f7297..6f1593d0b4b5 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -144,6 +144,9 @@ enum mthp_stat_item {
>  	MTHP_STAT_SPLIT_DEFERRED,
>  	MTHP_STAT_NR_ANON,
>  	MTHP_STAT_NR_ANON_PARTIALLY_MAPPED,
> +	MTHP_STAT_COLLAPSE_EXCEED_SWAP,
> +	MTHP_STAT_COLLAPSE_EXCEED_NONE,
> +	MTHP_STAT_COLLAPSE_EXCEED_SHARED,

Wh do we put 'collapse' here but not in the THP equivalents?

>  	__MTHP_STAT_COUNT
>  };
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 20d005c2c61f..9f0470c3e983 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -639,6 +639,10 @@ DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
>  DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
>  DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
>  DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXCEED_NONE);
> +DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
> +
>
>  static struct attribute *anon_stats_attrs[] = {
>  	&anon_fault_alloc_attr.attr,
> @@ -655,6 +659,9 @@ static struct attribute *anon_stats_attrs[] = {
>  	&split_deferred_attr.attr,
>  	&nr_anon_attr.attr,
>  	&nr_anon_partially_mapped_attr.attr,
> +	&collapse_exceed_swap_pte_attr.attr,
> +	&collapse_exceed_none_pte_attr.attr,
> +	&collapse_exceed_shared_pte_attr.attr,
>  	NULL,
>  };
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index c13bc583a368..5a3386043f39 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -594,7 +594,9 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  				continue;
>  			} else {
>  				result = SCAN_EXCEED_NONE_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);

Hm so wait you were miscounting statistics in patch 10/13 when you turned
all this one? That's not good.

This should be in place _first_ before enabling the feature.

> +				if (order == HPAGE_PMD_ORDER)
> +					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_NONE);
>  				goto out;
>  			}
>  		}
> @@ -633,10 +635,17 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  			 * shared may cause a future higher order collapse on a
>  			 * rescan of the same range.
>  			 */
> -			if (order != HPAGE_PMD_ORDER || (cc->is_khugepaged &&
> -			    shared > khugepaged_max_ptes_shared)) {
> +			if (order != HPAGE_PMD_ORDER) {

Hm wait what? I dont understand what's going on here? You're no longer
actually doing any check except order != HPAGE_PMD_ORDER?... am I missnig
something?

Again why we are bothering to maintain a counter that doesn't mean anything
I don't know? I may be misinterpreting somehow however.

> +				result = SCAN_EXCEED_SHARED_PTE;
> +				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
> +				goto out;
> +			}
> +
> +			if (cc->is_khugepaged &&
> +			    shared > khugepaged_max_ptes_shared) {
>  				result = SCAN_EXCEED_SHARED_PTE;
>  				count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
> +				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
>  				goto out;
>  			}
>  		}
> @@ -1084,6 +1093,7 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
>  		 * range.
>  		 */
>  		if (order != HPAGE_PMD_ORDER) {
> +			count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);

This again seems surely to not be testing for what it claims to be
tracking? I may again be missing context here.

>  			pte_unmap(pte);
>  			mmap_read_unlock(mm);
>  			result = SCAN_EXCEED_SWAP_PTE;
> --
> 2.50.1
>

