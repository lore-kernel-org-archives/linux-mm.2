Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E8FCF31B4
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 12:10:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 619C26B0089; Wed, 19 Nov 2025 07:10:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C9B36B008A; Wed, 19 Nov 2025 07:10:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 442AD6B00A4; Wed, 19 Nov 2025 07:10:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5FF6B0089
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:10:07 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0D564E1DA
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:10:06 +0000 (UTC)
X-FDA: 84127238412.28.73D8CEF
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 50DB0180013
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:10:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gmAuYx8T;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=X61Ox7wf;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763554203; a=rsa-sha256;
	cv=pass;
	b=NXesILWcFxqU9bvHDK8ByUtHe0PxghnMqTUm55lRIwDU7pCa7F/cTCoM0sdyqWf912DCPF
	afX74x1EYfKoS0WoxKjywcBSSI1fd8GGFyoCUh1cNqiZu/dhNttgrzs3AFO8ctU+RJw4fN
	aqTYsLBPr9ryg17qbULFmwmz7ciPX74=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gmAuYx8T;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=X61Ox7wf;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763554203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+3J36bIF80QoYDZ/vo8AbRG6UZqKRTzVmd7W8fQMi7k=;
	b=hovVHerv5fy2m44NXngyJDvIk7awrVfgCKlRWaBRBOXomz3J4yEHQ24HNgV/gOfZCq5DIb
	SGbNLuUxqu4HjLfuzNXko/oqjVydJ82ntJSOzkbTQauc24SgJtpDOVufCgN1BUPhCaUolh
	ScOzio3iXoqiw387ZJJx7+kwg29X/Pk=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJBovfL000433;
	Wed, 19 Nov 2025 12:08:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+3J36bIF80QoYDZ/vo
	8AbRG6UZqKRTzVmd7W8fQMi7k=; b=gmAuYx8TG38ueF3eRNw8C8cA6Gh4OvR1Fa
	EBRlE8zBFbHaTNFgjgigHiJnfTmI3DCbokm8mhP8ZtuqYOJnpZX4D8kC1YAB/CqO
	vD13HODJgFV25a2+oJbssLEKGzxzZLxZbUtNmxQb0FxbfcuSp8NtvucX5DtfJ0c4
	X0xETGj5VQXjFU+uFlza6xxYp5Qcj44kIaqvCBhKz+buj1cWbHc84UGHCvnMfYLe
	naB1oD7u/nWCu/taZnT6+U/1pPQ1nBSaavM3ZtLY6YtKtShxx6/mGEVjCIBzTdVm
	R6pdRFcFf5ZQr5wLWNXepsyj65hSVRqJ+femy0ngxsYSTc4LMwxg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbuprxd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 12:08:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJBM5TM009745;
	Wed, 19 Nov 2025 12:08:51 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012060.outbound.protection.outlook.com [52.101.53.60])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyehs7j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 12:08:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wvpDRScEl6BTiu/+V5dK/B8mMdlAHCIDM5HuNCCLiKmww62f+X2B9Nb5u+cpcBRSQ1q2x5/r3eOSgUf3q9TwEwJLo7gwyTrv26MMk8kiZahfCkzOMgAYGvrieWUnVe2INmc7xax9j3roVQJhqMk5WKR6AWdNA77GPyVPq6pLD8GA1X6NR3e9r3OFLnKRAGyRlhYlOLtGpo/ybDLc0NOM2Zk7mC3vBrYRF2Gr1+7wRDd3yCKQ9gl9wvp5SHCrBS2qIXLrBnCy7nZWVMBu3aMUJEjisetYbQX9xAu8g3y10UVPIELRNF5kVyNQpEJI+IxrVMeIFzHma7B5cmWQeamzqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+3J36bIF80QoYDZ/vo8AbRG6UZqKRTzVmd7W8fQMi7k=;
 b=syN245glGCa+CrGN1doQrRhAvwpvONIrIAbejr+9pa+offY8+QFUY4wrZqh/8NYetjL6PAJxcRU7ztCm/scdu4uBWeq1Akh8fjqAYBS3QI38MMwitVJ97YHTe1mZ+etV0eMVcT4nnwRGpvMMX8V9iiZXbw7uiI6ysa6zPOFGBCRrYhBuMf16zyGCJgw8KRYNkkXPkA4hh6Ho5ziA+RTIBGKb6PvpC4p6q/quupgDlNdfx0jmh/akTlEmPt5U9kNWm6fXi6EkVub4gbNK56cBVeOGXdybg6tvsOL0/06Qw6T/ieoMCIKyW8Nh6LWVpZ1Vb5vSdhfwjrQ4McMh6ESxag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+3J36bIF80QoYDZ/vo8AbRG6UZqKRTzVmd7W8fQMi7k=;
 b=X61Ox7wfIn7ewFOEn+iN9hWcnbw24PAHF5kocLOpc7Y7wkI0tDXZV1T3s3YeMv6c1l/AF24ETtpbgK69Nje/BCL8stO64Iu3XtrpI+ZUhtk/13jl01L44DFBxS2UqJbRIhrTO8nv9NybwitfCXERRAn4iKd5LpWy+Lae4y4m4YA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ5PPF0687F9010.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::786) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 12:08:46 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 12:08:46 +0000
Date: Wed, 19 Nov 2025 12:08:44 +0000
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
Subject: Re: [PATCH v12 mm-new 12/15] khugepaged: Introduce mTHP collapse
 support
Message-ID: <a01349f5-a870-4a13-a4cc-00aba007348f@lucifer.local>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-13-npache@redhat.com>
 <d03e079f-35c0-4fc1-8856-44fe33fabb2f@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d03e079f-35c0-4fc1-8856-44fe33fabb2f@lucifer.local>
X-ClientProxiedBy: LO2P265CA0082.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ5PPF0687F9010:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e268cd4-3aad-4c24-da04-08de27646447
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Lzzn8zyEF3XAigo3QvZqgXCijiGj5Y9gzQxQ9hCxNlqZBJjsLL2JBqVG23b+?=
 =?us-ascii?Q?yahwEvyTwJYqir7K5mWQ5xEKx+H6HKolgEQ20qUhfmi570Fis2eHD2c6YuiQ?=
 =?us-ascii?Q?pnmG4T3nadDFbdz0b4JYcdFCbyxQQdW5NsBISNIDI/e3GoRyxfbOGrlYr4GN?=
 =?us-ascii?Q?KXJtVuhSMesuhp0BEVF9gHgu6okmnGk5g+DWwwysEhuL8euUuT14ErluIVFb?=
 =?us-ascii?Q?qu3NuPMp5Cm1o87bduGbB3gNGX4JQvcHDwON9VX5zB5CQADN6BcLZMrl/iTL?=
 =?us-ascii?Q?x0j7+3tgrlStYqr2d5WfPRxjNRbOqzMvwQ93U/KwyOMu5hwRTeTmbWOEoorK?=
 =?us-ascii?Q?kj5HwIqvI+TF2MNNWD0i2+9nq3mnfGkHmavktDJz0aQv9oP5IsGoEAdF58mk?=
 =?us-ascii?Q?/r9Phgj/Aq6QBhFvM0wigQACwH6PJStKNOfujDxKbVpdxE8tbgAkhHNA64A4?=
 =?us-ascii?Q?BKlgqaJFDub9lGME+XFPJ7TtE0i6cntR41effmBE5HWC7wqksizqYfN0qVVt?=
 =?us-ascii?Q?2AW00H4EowYKidGpxRdII9YKCkRaAiuZzAcYNqZTaP5s2RpT5jGDmMJrYM9Q?=
 =?us-ascii?Q?lwyI4KOisXwN4j5lZcZu8/RmhdvRb/Hp9w7Az/29Ki4MMMA5P607YzV6Y2K6?=
 =?us-ascii?Q?kRpiqN5t5TKLLTn1Ud6vldOI9knyqyOHzdIuCF2gridVJPgDQW8VSkiAAQG7?=
 =?us-ascii?Q?ekYgRbHMjfpj0T/1fnvzozkLq3gH3VZpk7YGahm5Kxhm0tEulN7oAXDSiF9A?=
 =?us-ascii?Q?Fa3huDk9+45eOsVeHNeVQSAyybSBKBWhgGbKqjD1WE1PML8UQgYLssB0FAH4?=
 =?us-ascii?Q?ZLzfZou8eaJQqos98axOrfQOwYmGrcRZDnxgwZzJH0RICLjIFkSkCpAwOlWN?=
 =?us-ascii?Q?PBnrETBLjVJdB2cf0GQPmGWxNf1y91qBspcAQU67etFpXDsxF9WcP/As/FAX?=
 =?us-ascii?Q?LFtPkE8VzqytBr2yYRuxKCt1mQ/YzX7SiAJK/T1qmMWNwTRGIPOxGzQaY8xY?=
 =?us-ascii?Q?+FDNlcvACryaBFqISfdw7aB5+uSF59DekR5u0ea+KOkCDUyklgoB77w0J9E1?=
 =?us-ascii?Q?7dLAgWb1DWnAWyW8+gq4giwdgxo8hqLv2U17GHUnT9QJrYsNuj01mDyjA5/b?=
 =?us-ascii?Q?71YabZcYip3mbqNBtlTCdWYEcn7aSXdMQs25KXAd/8A3lBx5VaO1Dw/+wvW9?=
 =?us-ascii?Q?gBUA5MUjr4ixtPlxFsDTt+4b7wOB0DjPYMU7Vuf+PuA7emsBEDjwn00bSNbC?=
 =?us-ascii?Q?9FrLox0EmXzytKPs/lCpsrYrvUTMhCP5vUIKNcTuAUtSTUU1pT9lzfwtiyfL?=
 =?us-ascii?Q?Lzi/ddf4bKTBCSOevFkyDhY3yETK5l99rp5GcpTqRkjxhadBsVl/t6HyQgGY?=
 =?us-ascii?Q?c83f++hePh0epnLA6qPWIL+ag/FIESDHWr+rO8Nn/jIkfwyv37fZIkKQz9Fc?=
 =?us-ascii?Q?ZwH3e1q0rKfXcW+t7iJNbQE2xjmQmTrK?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Az7tXHN4jFSdWX8zGBBUk6Qqj2pnWrpaE67wOhRMa0xUU4LBKitWqnT+RV+R?=
 =?us-ascii?Q?m5zdlZHfT2PPEENv3SKq2vYLv5R8Y7Rk06cxhe8oz9hHFio6VYnl8nkjmWS4?=
 =?us-ascii?Q?JoQ5S6+aJx6OgzfiwOBcpN30ny3cNqYyxWmcmEckALK/1mlqjhNE6vUacVoJ?=
 =?us-ascii?Q?gD5IMeZAe8Z7QkBEXHz5lmT3fRB5ins87t68q1GfG5I9aZg8jEvOlkvToOX/?=
 =?us-ascii?Q?zpp+q/VuMQBK22/FdUJACGd1RnCuIp0Gc+vHJZkVgYChKOaqGM1RhWEX2N3O?=
 =?us-ascii?Q?bzN7oqmCTg/s4Yj4JlyIkm5JxEBfVZqWAcewW1sVEW4WVQyD5WY3ATVUF+xs?=
 =?us-ascii?Q?hi7GCWPzhvrkpJxlNa8Gq+vVW2pvVkjH7T4kpOyCoa7yX5wQ8+uLE2S+abiY?=
 =?us-ascii?Q?qFFx1DfYXqTQE9saKVJPBWdhqb/gy0cJG3Ff5EA5sZOhT/EDqTCU4U5VqNCe?=
 =?us-ascii?Q?AlQqa3SEGNshjG9WZEGK+0Lz/CCqxxDAbUyMYYjesdB5VnlcxoX8miorkJYY?=
 =?us-ascii?Q?N4o+XYPu/8uLfR1GYtmdqsC3zcUr6N+cmpOxAol+tS5PQOQx0gvVfEqNnAgq?=
 =?us-ascii?Q?DmvmYG3LRDlqDqWK708jVxnpdYED+SkXRH2vi/JUNXVyyS40wE82nIzmTBJ6?=
 =?us-ascii?Q?+guX6S1oKrjHsJl3bEfNHpepVkD3H/8xsFk/6+QtBYry8v6R7Z+06SZgqRFO?=
 =?us-ascii?Q?tV8HBg+yiFsa1MfB7HaxPKGMx8kqDPv1A6gbpLrrwrZz8ti5qz4/XpKUxsJH?=
 =?us-ascii?Q?ot+29ztoKWVZKNqBaN3tOD1dnYMg1zbeh0juudzUg/O371cO2IRVB0fKNORh?=
 =?us-ascii?Q?VWABUBlY+BPtTv2E52W/qutg+SJYI34DSf9sEcXWhVKIg3YykADTbtESkhBg?=
 =?us-ascii?Q?TI1y0fjNJOks/P2Xgdf0uG33WMxwCBJngrC/Z8+u4Xf1OXa7Zt5luLY5n1Vo?=
 =?us-ascii?Q?XGOltnaaH9zMkH3VevG5GuSC9PUjjJM5dliTKC2XNOV/ZAGem7WMqeGF10Rg?=
 =?us-ascii?Q?LB84NLpw13LpbhXABTb4CoO0iQUtLuubKd/xNO9z8ZDjxfZtyD1qkH2xm562?=
 =?us-ascii?Q?dHRqsfYATpPV3ypUN5KNyq8KtFS26WH1+IXpBuMDeL/6edFDNyqtfFwz/4sL?=
 =?us-ascii?Q?fZpkE2quyzT3waTFVcQtZt64Hu4CiTbHDDAH9EWyyuXPFhmsU1v/LQuzG1Vp?=
 =?us-ascii?Q?jOPvjWQ0ipV/hSWIJf2KlYARsToZKO4mQaBY+wZZoVA/CLUUeBhHqFNPLGNl?=
 =?us-ascii?Q?oG3BpdeXPfVwHA1vH4budGf0riip+dEJrQSA2wAq+/7z012EeTVGZuiP6puS?=
 =?us-ascii?Q?JQFuUQ/+x90Qj76SI/kYz7yZdXDn4IFkIR4gaP3x8+JuDR7fuCF1e4a+pspf?=
 =?us-ascii?Q?gS8lWKZevCKFTanTUU0SKTDOu19lc18+XUvqNXnEBHU7Kr7NrsySQG5Eni79?=
 =?us-ascii?Q?i7NcnmX17m13V/nglug9IHpGxY1HvQeBh7aN0k9hzRQ2YTUJdt353TufYyCP?=
 =?us-ascii?Q?I1gNVQ4vgTS6C0yGCsD6rNwIpwXjRVkPLRuyW3E8wCX3nmJn8kNbpPfWYCjK?=
 =?us-ascii?Q?WSI7uNHFXhIabTVmY8H5Ygc4cA+fH77r/ha8pu39uw2iZGknJS9XN9U5rwJj?=
 =?us-ascii?Q?4A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+hYAOJKMzKDcqQ0E/BiDBZonMgsOUb+J10EVdCnLdBRviJuCR8wUjNxSt9bAK0449vSDc+C7JFquFSU/MkE57DTpudWzdAWmUb8LVRBj7XzJ2Q5IJzFRS9hfDqhlZJ9ux+MpudOGYM9cXmOulGM5IWQl9em4ns8syfYbrxB9cty35y6ccaqCwC2bBPk1Prb7DszPVTr+8yJetSFGFfIQvWtSfi36UHSV+8BUtSOIQ+mTdJCzddXDe6RxURWM+ipDwlCXYCdZwV2T70xVacEJMCYCB3359DyORrscb1TQ46JPAGesnK1pAv2/uHGc16YPEHgb/knmFkV9aKdiB4u7ojnXXvbnKRPmX1qKPJvePSuF3iui2Ta383wAbigEMIMV+cQlZHpjgj994CTzx7YhMFNDtbR+81i6+Z6eTrZ7YZimDpasTtaeu0qTZchUXl3pBuXsl3g6nxr6VbbcJwYoFRWchbyxhUfzrnlzA4TxalrD3lSWPCE0nw/xsW7tfsdcz0wbVj/ge26FUm8r+gNUj9eMLKwnBzhM9AZw40ZWKTwGYClzGRByDGE9BhkvlmryaGVsJ0Jg40YwJFhg3Nk/yMADluRDI2FxJl9EGSdvlk8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e268cd4-3aad-4c24-da04-08de27646447
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 12:08:46.7671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A2xnNYcnt4Q+qnq5fPagZj4q+IlRbWs/QpMegGUMsJVDU1oZUaxrWANXcED7bKtW/WWTep8RlIS5Yj6BtnS+HJkRqfkvLLfkqzXSlgeO4Zc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0687F9010
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_03,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511190096
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXy+vYOVrxLrX+
 jEPHn5Yxzi3QenBJwKPR4ELy+tqfXai13dMW3bO5IxfnGwxmmIL9EA9zGosDWukYkaAqtS7erMe
 UwRaOJqKjKK5nCeXHnCr/mFUn2hd6Erd2LP6OqmL4P86JpUqPV375ZIFEfeUbg3m17eTz7W7Y15
 5ZZ1kN9KY3NyNTcbl5yuyN+MZSY/kUx4hUG7GNx/cSiCzMWPoULHR7uBewXJFvUxEkZDVUBXthA
 u82BZFFPEz8jblwjXXBQUasrMBfnfMhpv+6Sc8cDdcjtvEKL6GALBQn3bBgfiMvxHha1hnlq4mW
 zYpEVNcySBRowS2H+UxchDBQyTpEIVBQ/M+Wgu45Ii+rOUG0p410E4xdVYS9KeRlyLcFtfx/jZk
 eDK5gfVDp+pZQv7f7XPm5y33SP29geFtD46VheZkDkBa1i06Ndw=
X-Proofpoint-GUID: mNF21wQpswwDe9GT_UFBMxciwH0uxSGm
X-Proofpoint-ORIG-GUID: mNF21wQpswwDe9GT_UFBMxciwH0uxSGm
X-Authority-Analysis: v=2.4 cv=Rdydyltv c=1 sm=1 tr=0 ts=691db354 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=KHyt6t-CTgoUCxz-I2AA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13643
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 50DB0180013
X-Stat-Signature: d4j58p15fokixqzyma9k8exm5grrhxhm
X-Rspam-User: 
X-HE-Tag: 1763554203-114501
X-HE-Meta: U2FsdGVkX1/Pk7wYpclzz8H+C9kHfVDRjZgrsQECBbRVPHt4hZtYHy5aYU/QbMm/n4o9PND2wGqty/ngmpo85VqkAWZ+EtzAAhkxVrqWfkyhR+yO58fon/4HDwsm0Q3L+Q4Ffk4fhs9Yfizpgu4VKyiOp79MksD4NVUv07CAF1Wg/O+deZqDFTRB2r6g8OHNNpkjDiGo5omh6TVoRVozkdJUSLoDIHXnLaWsa63z8jLdMLuU4n+ZA491+vFu6z6LowTBvLzZw2+JsU/9zh68OUkQrwCUPUd4AVfbYM2FUjsuka9Ssg/sDL9NorQjmD6HG5jr1SDTWOy2yth6TcOczbmmmMh1fWzOabZdVbvAcQhlJO8lSPp6Vrds1KSki+UWDxcnNEVqZezfCCx+x3eUirF0JrvT35jl57rZDyET+IYCBWSjR4VNEyaubohy7u4TYd/0jKtV0nLYPGUcqRkDVRo4muddsEpxiZOjKJ/EacvxfsuL9Z62WPWhyC8QuxL6Piy4ouoYZ4ZRt9SxyX5hhU6+zcCsfNHLm59UXqyxUfNSFffUk7QdBZkdhsdVsiJ+YlJnE8wbcipE+DRznVlJminbK0AmshjxIRuT01gRvvaRlFPWc4S8x/7HNiISikWhLyw2H+04t8wmkq3yfvFqWaqwf+KxOQkgU80TuSxJyh/fiMMfBBKoJmdVIIppnSO9e4a/yiYL0cXtj7r9Wss+VGl/hsL/kH6ZWMw5mD2tEJLE5oPGdxQmZfGVdl5fHzm8dmKNIgTIFkfAOhB0NPR6QYsODKX7jWgIbNpQcSBvlYj0L3vae5aMsYylhVW94UzahVZ4PAjXRR2dtJgPtQL+0GRpKyN1u7QkLBY6HLYj5BN27EQgbISXiTVe47ZUPwYyBWkPq1NB3iuJH5crPVqIvPvpVRVSv61dYocAIHl9nPeYi+ds14JduGeP2nfCa/L3UTiixn0GbKh5pnALCTU
 VeCzZUsU
 5acPCFZE9cRFjSvOsZQmRZZuKz/aQX3KHrNNcwkX5FJRM+ruE2csr75v3NpqSw66IPRZgbGdymNyjJowkkhnqnYowov/0FaaD435fXlebKQf5D2QwpsVUl0iJpF9Jr8TqJ8kcNx73eoFvVYZaTyEkhXvigmAsQJN7fZ1DqFsZtl3N8LLffdivJ36/V2fGV1P2nnvnKFGQwJ+cRb+z+xMEoNm20YEtCztLzWsAwaZMy6NFJdtO50Vyf65YdOlS6YlcaYgUZBssDXwvDgp6G6LU8tt9wBHaE4jipXabReOJ60HRRawMJDIUR369J6uLhtvJ+5j0mQ/2IjuLsMXwJ3FNUbAhnqjyCtjzbjweVM1eLLVEAzKRkgsBuuzIspbvPddRRW/U/oS2c5EmDXxYs3viha2GgAImtc3UgpLgtJzBVeSj+f5ce0Ebh8EchSET9/kGBo98ng2E9c4s1Sc3aDNb7E6x20yE6zrQHfuk+1tyM8uHh54WvyE8hiX+hOTOasyrI/p6+3TfnxQE06giK/dAhaviXpz3wIzm9Qm6ixJlCrws4XHdFy1LjBgDGFvT6h1V6T5yeQKobLuqQcI6S45uRXXjjvUXryKmtgUPXgOo++Xv3y//ufdtz9S1O8jU4xlfopOler3NOsFKtXYYHfnOaA3Ml1hg7f9RYXLCbc5TggPh9NDOrFl0JHKalHnM3yIgDcQg7SIEfqUEzC0c3a1R2Ftf9UncoxL09bhGWMcoJwz6s56p0X5I/jfErGPpVbEW+GVk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Oh I forgot to add -

In collapse_scan_pmd() there are casees where you just bail out altogether.

E.g.: pte_uffd_wp() for _any_ PTE entry in the range.

Or !folio_test_anon() for _any_ PTE entry in the range.

Etc.

Surely these are cases where an mTHP scan on part of the range might still
succeed?

You then in the subseuqent patch seem to check for collapse failures
specifically due to some of these, but surely you will never hit them as you
already discarded the whole PTE page table?

I'm not sure you've updated collapse_scan_pmd() sufficiently to account for the
mTHP logic.

Cheers, Lorenzo


On Wed, Nov 19, 2025 at 11:53:16AM +0000, Lorenzo Stoakes wrote:
> On Wed, Oct 22, 2025 at 12:37:14PM -0600, Nico Pache wrote:
> > During PMD range scanning, track occupied pages in a bitmap. If mTHPs are
> > enabled we remove the restriction of max_ptes_none during the scan phase
> > to avoid missing potential mTHP candidates.
>
> It's a bit odd to open the commit message with a very specific
> implementation detail, I think we should instead open with a broad
> description of what we intend here, e.g. to permit mTHP collapse, before:
>
> - Discussing the algorithm used (in more detail than below!)
> - How and under what circumstances this algorithm is invoked
> - (Mention MADV_COLLAPSE not supporting mTHP as of yet)
> - THEN super-specific details like this.
>
> >
> > Implement collapse_scan_bitmap() to perform binary recursion on the bitmap
> > and determine the best eligible order for the collapse. A stack struct is
> > used instead of traditional recursion. The algorithm splits the bitmap
> > into smaller chunks to find the best fit mTHP.  max_ptes_none is scaled by
> > the attempted collapse order to determine how "full" an order must be
> > before being considered for collapse.
>
> I feel this is a _very_ brief description of a complicated algorithm. I
> think we should go into a lot more detail here. 'Binary recursion' is pretty
> hand-wavey, and you go from hand waving that to being super-specific about
> max_ptes_none before handwaving about 'fullness' of an order.
>
> All in all I find it super confusing - so I think you need to take a step
> back and 'explain it to me like I'm 5' here :)
>
> >
> > Once we determine what mTHP sizes fits best in that PMD range a collapse
> > is attempted. A minimum collapse order of 2 is used as this is the lowest
> > order supported by anon memory.
>
> I don't know what 'lowest order supported by anon memory' means?
>
> I guess really this is the minimum order contptes support for arm64 right?
>
> >
> > mTHP collapses reject regions containing swapped out or shared pages.
> > This is because adding new entries can lead to new none pages, and these
> > may lead to constant promotion into a higher order (m)THP. A similar
> > issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
> > introducing at least 2x the number of pages, and on a future scan will
> > satisfy the promotion condition once again. This issue is prevented via
> > the collapse_allowable_orders() function.
>
> Obviously this has been discussed to death, but you should update this to
> reflect the decided upon course (0, 511 + warning, etc.).
>
> >
> > Currently madv_collapse is not supported and will only attempt PMD
> > collapse.
>
> Good to highlight this.
>
> >
> > We can also remove the check for is_khugepaged inside the PMD scan as
> > the collapse_max_ptes_none() function handles this logic now.
>
> Again we're kind of leaping from mega handwaving to super-specific details
> :) let's make it all a lot more specific + clear, and then put the really
> niche details like this at the end of the commit msg (I mean this one is
> fine where it is ofc as a result :)
>
> >
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  include/linux/khugepaged.h |   2 +
> >  mm/khugepaged.c            | 128 ++++++++++++++++++++++++++++++++++---
> >  2 files changed, 122 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> > index eb1946a70cff..179ce716e769 100644
> > --- a/include/linux/khugepaged.h
> > +++ b/include/linux/khugepaged.h
> > @@ -1,6 +1,8 @@
> >  /* SPDX-License-Identifier: GPL-2.0 */
> >  #ifndef _LINUX_KHUGEPAGED_H
> >  #define _LINUX_KHUGEPAGED_H
> > +#define KHUGEPAGED_MIN_MTHP_ORDER	2
> > +#define MAX_MTHP_BITMAP_STACK	(1UL << (ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER))
>
> This is an internal implementation detail, I don't think we need this in a
> header do we? I think this define should be in khugepaged.c.
>
> Also this is a really fiddly and confusing value, I don't think it's a good idea
> to just put this here without explanation.
>
> It's not even clear what it is. I'd probably rename it to MTHP_STACK_SIZE?
>
> We need a comment that explains how you're deriving this, something like:
>
> /*
>  * In order to determine mTHP order, we consider every possible mTHP size
>  * starting with MAX_PTRS_PER_PTE PTE entries and stopping at
>  * 2^KHUGEPAGED_MIN_THP_ORDER.
>  *
>  * We store (offset, order) pairs on the stack to do so, each describing a
>  * candidate mTHP collapse.
>  *
>  * For each (offset, order) candidate mTHP range that we consider, we must
>  * also consider candiate mTHPs at (offset, order - 1), and (offset + (1 <<
>  * order), order - 1).
>  *
>  *
>  * This is because each order can be split into two (an order expresses the
>  * power-of-two size), so we examine each half of the next lower order
>  * mTHP:
>  *
>  *                offset   mid_offset
>  *                  .          |
>  *                  .          v
>  *  |---------------.-------------------|
>  *  |           PTE page table          |
>  *  |---------------.-------------------|
>  *                   <--------><-------->
>  *                     order-1   order-1
>  *
>  * Given we must consider the range of KHUGEPAGED_MIN_MTHP_ORDER to
>  * MAX_PTRS_PER_PTE number of PTE entries, this is the same as saying we
>  * must consider KHUGEPAGED_MIN_MTHP_ORDER to lg2(MAX_PTRS_PER_PTE) mTHP
>  * orders.
>  *
>  * As we must consider 2 possible mTHP ranges for each order, this requires
>  * our stack to be 2^n, where n is the number of orders we must consider.
>  *
>  * And thus MTHP_STACK_SIZE is 2^(lg2(MAX_PTRS_PER_PTE) -
>  * KHUGEPAGED_MIN_MTHP_ORDER).
>  */
>
> This may seem (very) long-winded, but this is all really non-obvious.
>
> You can additionally rephrase this and utilise it in the commit message,
> description of the iterative recursion function and possibly elsewhere to
> describe the algorithm more clearly.
>
> In fact, since this should really be declared in khugepaged.c, and since
> you can place it just before the mthp collapse function, you could expand
> this to describe the algorithm as a whole and simply put the define and the
> function immediately next to each other after the comment?
>
> >
> >  #include <linux/mm.h>
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 89a105124790..e2319bfd0065 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -93,6 +93,11 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
> >
> >  static struct kmem_cache *mm_slot_cache __ro_after_init;
> >
> > +struct scan_bit_state {
>
> Scan bit state is a bit of a weird name. Scanning what? What bit? State is
> kind of implied?
>
> struct order_offset_pair?
>
> struct mthp_range?
>
> > +	u8 order;
> > +	u16 offset;
>
> Real mega nit, but feels more natural to put offset first here. As
> (position, size) seems more naturally the way to view this than (size,
> position).
>
> > +};
> > +
>
> Also needs comments...? Order of what? Offset in what?
>
> >  struct collapse_control {
> >  	bool is_khugepaged;
> >
> > @@ -101,6 +106,13 @@ struct collapse_control {
> >
> >  	/* nodemask for allocation fallback */
> >  	nodemask_t alloc_nmask;
> > +
> > +	/*
> > +	 * bitmap used to collapse mTHP sizes.
> > +	 */
>
> Nit but this should be on one line /* Bitmap used to collapse mTHP sizes */.
>
> But we're not storing sizes though are we? And we're declaring two bitmaps?
>
> > +	 DECLARE_BITMAP(mthp_bitmap, HPAGE_PMD_NR);
>
> Really this is more of a PTE table bitmap but probably fine to call it this.
>
> > +	 DECLARE_BITMAP(mthp_bitmap_mask, HPAGE_PMD_NR);
>
> You've added random whitespace after the tab twice here? [tab][space]DECLARE_...
>
> > +	struct scan_bit_state mthp_bitmap_stack[MAX_MTHP_BITMAP_STACK];
> >  };
> >
> >  /**
> > @@ -1357,6 +1369,85 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long pmd_address,
> >  	return result;
> >  }
> >
> > +static void push_mthp_bitmap_stack(struct collapse_control *cc, int *top,
> > +				   u8 order, u16 offset)
>
> Not sure we need to say mthp_bitmap_stack everywhere. This is a local
> static function we can be a little more succinct.
>
> mthp_stack_push()?
>
> > +{
> > +	cc->mthp_bitmap_stack[++*top] = (struct scan_bit_state)
> > +		{ order, offset };
>
> This feels rather difficult to read, cc->mthp_bitmap_stack[++*top] in
> particular is rather too succinct.
>
> This would be better more broken out, e.g.:
>
> static void mthp_stack_push(struct collapse_control *cc, int *sizep,
> 	    u8 order, u16 offset)
> {
> 	const int size = *sizep;
> 	struct scan_bit_state *stack = &cc->mthp_bitmap_stack[size];
>
> 	VM_WARN_ON_ONCE(idx >= MAX_MTHP_BITMAP_STACK);
> 	stack->order = order;
> 	stack->offset = offset;
> 	*sizep++;
> }
>
> (Note this requires the change I suggest below re: not defaulting top to -1
> but instead renaming it to stack_size and starting at 0, see below).
>
> Re: below comment having pop as a helper too, that can be:
>
> static struct scan_bit_state mthp_stack_pop(struct collapse_control *cc,
> 		int *sizep)
> {
> 	const int size = *sizep;
>
> 	VM_WARN_ON_ONCE(size <= 0);
> 	*sizep--;
> 	return cc->mthp_bitmap_stack[size - 1];
> }
>
> > +}
> > +
> > +/*
> > + * collapse_scan_bitmap() consumes the bitmap that is generated during
> > + * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
> > + *
> > + * Each bit in the bitmap represents a single occupied (!none/zero) page.
>
> In which bitmap? There are 2 that are declared. Be specific - cc->mthp_bitmap.
>
> > + * A stack structure cc->mthp_bitmap_stack is used to check different regions
>
> > + * of the bitmap for collapse eligibility. We start at the PMD order and
> > + * check if it is eligible for collapse; if not, we add two entries to the
>
> I questioned this since you start at HPAGE_PMD_ORDER -
> KHUGEPAGED_MIN_MTHP_ORDER, but then realised you're intentionally
> offsetting like that.
>
> See comments below about changing this.
>
> > + * stack at a lower order to represent the left and right halves of the region.
> > + *
> > + * For each region, we calculate the number of set bits and compare it
> > + * against a threshold derived from collapse_max_ptes_none(). A region is
> > + * eligible if the number of set bits exceeds this threshold.
> > + */
>
> I think we could be clearer here. Something like:
>
> ...
>  * stack at a lower order to represent the left and right halves of the
>  * portion of the PTE page table we are examining.
>  *
>
>  * For each of these, we determine how many PTE entries are occupied in the
>  * range of PTE entries we propose to collapse, then compare this to the
>  * number of PTE entries which would need to be set for a collapse to be
>  * permitted at that order (accounting for max_ptes_none).
>  *
>  * If a collapse is permissible, we attempt to perform one. We do so for
>  * every possible mTHP in the PTE page table.
>  */
>
> > +static int collapse_scan_bitmap(struct mm_struct *mm, unsigned long address,
>
> Really inconsistent naming going on here, we're collapsing and scanning and
> what's the bitmap?
>
> How about mthp_collapse()?
>
> > +		int referenced, int unmapped, struct collapse_control *cc,
> > +		bool *mmap_locked, unsigned long enabled_orders)
> > +{
> > +	u8 order, next_order;
> > +	u16 offset, mid_offset;
> > +	int num_chunks;
> > +	int bits_set, threshold_bits;
> > +	int top = -1;
>
> This seems unnecessary and confusing. Just start at 0 and treat this as the
> exclusive end of the stack.
>
> You can rename this stack_size to make that clear. Have commented above
> about adjustments to push function and introducing pop helper.
>
>
> > +	int collapsed = 0;
> > +	int ret;
> > +	struct scan_bit_state state;
> > +	unsigned int max_none_ptes;
>
> Everywhere else we say max_ptes_none, let's maintain that convention here
> please.
>
> > +
> > +	push_mthp_bitmap_stack(cc, &top, HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER, 0);
>
> See below re: order here, we should change this.
>
> > +
> > +	while (top >= 0) {
> > +		state = cc->mthp_bitmap_stack[top--];
>
> I hate that we have a push helper but then do pop manually. See above.
>
> > +		order = state.order + KHUGEPAGED_MIN_MTHP_ORDER;
>
> OK so now the order isn't state.order but is instead state.order +
> KHUGEPAGED_MIN_MTHP_ORDER? :/ this is extremely confusing.
>
> We shouldn't call this field order if you're doing a hack where state.order
> isn't the order but instead is order - KHUGEPAGED_MIN_MTHP_ORDER.
>
> Just have state.order be the actual order? And change the below condition
> as mentioned there.
>
> > +		offset = state.offset;
> > +		num_chunks = 1UL << order;
>
> What's a chunk? You do need to clarify these things. This is a new term not
> used elsewhere in THP code as far as I can tell?
>
> This is the number of pte entries no?
>
> nr_entries? nr_pte_entries?
>
> > +
> > +		/* Skip mTHP orders that are not enabled */
>
> Note we're also considering PMD here :) Probably we can just delete this
> comment, the code below makes it clear what you're doing.
>
> > +		if (!test_bit(order, &enabled_orders))
> > +			goto next_order;
> > +
> > +		max_none_ptes = collapse_max_ptes_none(order, !cc->is_khugepaged);
>
> OK so this is going to be scaled to order.
>
> > +
> > +		/* Calculate weight of the range */
>
> What's the weight of a range? This isn't a very helpful comment. You're
> counting the Hamming weight or much more clearly - the number of set bits.
>
> So it seems you're simply counting the number of bits you have accumulated
> so far in cc->mthp_bitmap, adding in the latest offset.
>
> So I'd say add a comment saying something like:
>
> /*
>  * Determine how many PTE entries are populated in the range in which we
>  * propose to collapse this mTHP.
>  */
>
> > +		bitmap_zero(cc->mthp_bitmap_mask, HPAGE_PMD_NR);
> > +		bitmap_set(cc->mthp_bitmap_mask, offset, num_chunks);
> > +		bits_set = bitmap_weight_and(cc->mthp_bitmap,
>
> I think this variable name is pretty horrible, we don't care that it's the
> number of bits set, we care about what it _means_ - that is the number of
> PTE occupied entries.
>
> So nr_occupied_pte_entries? Or nr_occupied_ptes?
>
> > +					     cc->mthp_bitmap_mask, HPAGE_PMD_NR);
>
> Frustrating there isn't a bitmap_weight_offset() or something, as you could
> do that in one go then...
>
> I think this could be made clearer by separating out the gnarly bitmap
> stuff into a helper function:
>
> static int mthp_nr_occupied_pte_entries(struct collapse_control *cc,
> 		struct scan_bit_state state)
> {
> 	const int nr_pte_entries = 1 << state.order;
>
> 	/* Setup cc->mthp_bitmap_mask to contain mask for candidate mTHP. */
> 	bitmap_zero(cc->mthp_bitmap_mask, HPAGE_PMD_NR);
> 	bitmap_set(cc->mthp_bitmap_mask, state.offset, nr_pte_entries);
> 	/* Mask against actually occupied PTE entries in PTE table. */
> 	return bitmap_weight_and(cc->mthp_bitmap,
> 				 cc->mthp_bitmap_mask, HPAGE_PMD_NR);
> }
>
> > +
> > +		threshold_bits = (1UL << order) - max_none_ptes - 1;
>
> We defined num_chunks to 1UL << order then don't use here? :)
>
> I'm not sure we need this to be a separate value, and I don't think we need
> the -1 either, which only confuses matter more.
>
> How about just changing the below conditional to (assuming we've renamed
> num_chunks to something sensible like nr_pte_entries and bits_set to
> nr_occupied_pte_entries):
>
> if (nr_occupied_pte_entries >= nr_pte_entries - max_none_ptes) {
> 	...
> }
>
> > +
> > +		/* Check if the region is eligible based on the threshold */
>
> Probalby don't need this comment with the change above.
>
> > +		if (bits_set > threshold_bits) {
> > +			ret = collapse_huge_page(mm, address, referenced,
> > +						 unmapped, cc, mmap_locked,
> > +						 order, offset);
>
> We declare ret at the top of the function scope, then only use it
> here. That's confusing and unnecessary, just declare it in block scope
> here.
>
> > +			if (ret == SCAN_SUCCEED) {
> > +				collapsed += 1UL << order;
>
> Again we have defined num_chunks or rather nr_pte_entries but then
> open-code 1UL << order, let's just use the value we declared here.
>
> > +				continue;
>
> This is kinda subtle, we don't bother considering lower orders any longer
> *in this range*, but do continue to consider mTHP collapse in other
> portions of the PTE page table.
>
> This shouldn't just be a 'continue' :) we need a comment here to explain
> that.
>
> E.g.:
>
> 	/*
> 	 * We have collapsed an mTHP in this range at the maximum order we
> 	 * could, so we do not push lower orders on to the stack.
> 	 */
> 	 continue;
>
>
> > +			}
> > +		}
> > +
> > +next_order:
> > +		if (state.order > 0) {
>
> This is a great example of how this is confusing by making state.order not
> actually be the order but the order - KHUGEPAGED_MIN_MTHP_ORDER.
>
> Just make the order correct and change this to > KHUGEPAGED_MIN_MTHP_ORDER.
>
> > +			next_order = state.order - 1;
>
> Not sure we should have a label and a variable be the same thing.
>
> Also why are we decl'ing next_order at the top of the function but only using here?
>
> Just declare this here, like:
>
> 	if (state.order > KHUGEPAGED_MIN_MTHP_ORDER) {
> 		const u16 new_order = state.order - 1;
>
> 		...
> 	}
>
> > +			mid_offset = offset + (num_chunks / 2);
> > +			push_mthp_bitmap_stack(cc, &top, next_order, mid_offset);
> > +			push_mthp_bitmap_stack(cc, &top, next_order, offset);
>
> I guess one subtlety that wouldn't be obvious at first glance is that
> num_chunks (oh so badly needs a rename :) is a power-of-2 so we never get
> weird 'what if num_chunks is odd' scenarios to worry about.
>
> Probably doesn't really need a comment though. But this _does_ badly needs
> an ASCII diagram :):
>
> 	/*
> 	 * The next lowest mTHP order possesses half the number of PTE
> 	 * entries of the current one. We therefore must consider both
> 	 * halves of the current mTHP:
> 	 *
> 	 *                offset   mid_offset
> 	 *                  .          |
> 	 *                  .          v
> 	 *  |---------------.-------------------|
> 	 *  |           PTE page table          |
> 	 *  |---------------.-------------------|
> 	 *                   <--------><-------->
> 	 *                     order-1   order-1
> 	 */
>
> Since writing this I copied this above in another suggestion :P so you
> could always say 'see comment above for details' or something.
>
> > +		}
> > +	}
> > +	return collapsed;
> > +}
>
> I've commented this function to death here, but a few more things to note.
>
> (BTW - I'm sorry I personally _hate_ repeated iterations of review when
> there's stuff you could have commented in prior iterations BUT I think I
> may end up having to once we respin due to the subtleties here.)
>
> - I wonder if we could just use a helper struct to make this all a little
>   easier. Perhaps as it's realtively short code not so necesary, but a bit
>   horrid to pass around all these paramters all the time. Maybe something
>   for later THP rework.
>
> - Could we exit early if it's obvious that we won't be able to collapse due
>   to max_ptes_none? I mean for one, we could at least check if the next
>   lowest order is empty. If max_ptes_none was 511, then we would have
>   already collapsed so can surely throw that out?
>
>   I was thinking we could go 'upwards', starting with the lowest order and
>   increasing order (essentially reverse things) then not collapsing until
>   we can't collapse at a given order (so collapse at next lowest). That
>   might be less efficient though.
>
> - Given that we're going to be only permitting max_ptes_none of 0 and 511
>   for mTHP to start with, maybe things can be simplified - either all bits
>   have to 1 or we don't care what they are we attempt colalpse anyway?
>
>   But then again, maybe it's worth having the generic algorithm in place
>   for future flexibility? Thoughts?
>
> - How much have you tested this? This is pretty subtle stuff... it _seems_
>   correct to me logically, but this is crying out for some userland testing
>   that exhaustively throws every possible permutation of state at this
>   function and asserts it's all correct.
>
> - Are we not missing a bunch of stat counts? Didn't we add a bunch but now
>   are actually setting them? E.g. if we reject mTHP candidates due to
>   pte_max_none?
>
> > +
> >  static int collapse_scan_pmd(struct mm_struct *mm,
> >  			     struct vm_area_struct *vma,
> >  			     unsigned long start_addr, bool *mmap_locked,
> > @@ -1364,11 +1455,15 @@ static int collapse_scan_pmd(struct mm_struct *mm,
> >  {
> >  	pmd_t *pmd;
> >  	pte_t *pte, *_pte;
> > +	int i;
> >  	int result = SCAN_FAIL, referenced = 0;
> > -	int none_or_zero = 0, shared = 0;
> > +	int none_or_zero = 0, shared = 0, nr_collapsed = 0;
> >  	struct page *page = NULL;
> > +	unsigned int max_ptes_none;
>
> Correct spelling of this :)
>
> >  	struct folio *folio = NULL;
> >  	unsigned long addr;
> > +	unsigned long enabled_orders;
> > +	bool full_scan = true;
> >  	spinlock_t *ptl;
> >  	int node = NUMA_NO_NODE, unmapped = 0;
> >
> > @@ -1378,16 +1473,29 @@ static int collapse_scan_pmd(struct mm_struct *mm,
> >  	if (result != SCAN_SUCCEED)
> >  		goto out;
> >
> > +	bitmap_zero(cc->mthp_bitmap, HPAGE_PMD_NR);
> >  	memset(cc->node_load, 0, sizeof(cc->node_load));
> >  	nodes_clear(cc->alloc_nmask);
> > +
> > +	enabled_orders = collapse_allowable_orders(vma, vma->vm_flags, cc->is_khugepaged);
> > +
> > +	/*
> > +	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
> > +	 * scan all pages to populate the bitmap for mTHP collapse.
> > +	 */
>
> Ugh this is quite ugly. I don't really love that we've converted this from
> doing the actual work to _mostly_ just populating the bitmap for the mthp
> logic.
>
> Then again it's only a couple places where this is checked, but it's pretty
> horrible that what once was _the logic that determines what is being
> considered for THP collapse' is now turned into 'the logic that populates a
> bitmap'.
>
> > +	if (cc->is_khugepaged && enabled_orders == _BITUL(HPAGE_PMD_ORDER))
>
> I think this should be BIT(HPAGE_PMD_ORDER), I realise I reviewed the
> opposite before (or think I did) but as per David we prefer BIT() :)
>
> > +		full_scan = false;
> > +	max_ptes_none = collapse_max_ptes_none(HPAGE_PMD_ORDER, full_scan);
>
> Again really quite nasty, this may as well be:
>
> 	if (cc->is_khugepaged && enabled_orders == BIT(HPAGE_PMD_ORDER))
> 		max_ptes_none = khugepaged_max_ptes_none;
> 	else
> 		max_ptes_none = HPAGE_PMD_NR - 1;
>
> It makes this hack a lot more obvious.
>
> But also, what if !cc->is_khugepaged? We're going to scan everything even
> if we only have PMD? I thought we only considered PMD size for MADV_COLLAPSE?
>
> > +
> >  	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> >  	if (!pte) {
> >  		result = SCAN_PMD_NULL;
> >  		goto out;
> >  	}
> >
> > -	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> > -	     _pte++, addr += PAGE_SIZE) {
> > +	for (i = 0; i < HPAGE_PMD_NR; i++) {
> > +		_pte = pte + i;
> > +		addr = start_addr + i * PAGE_SIZE;
>
> That's nicer. I still hate _pte...
>
> >  		pte_t pteval = ptep_get(_pte);
> >  		if (is_swap_pte(pteval)) {
> >  			++unmapped;
> > @@ -1412,8 +1520,7 @@ static int collapse_scan_pmd(struct mm_struct *mm,
> >  		if (pte_none_or_zero(pteval)) {
> >  			++none_or_zero;
> >  			if (!userfaultfd_armed(vma) &&
> > -			    (!cc->is_khugepaged ||
> > -			     none_or_zero <= khugepaged_max_ptes_none)) {
> > +			    none_or_zero <= max_ptes_none) {
>
> Why are we dropping !cc->is_khugepaged?
>
> >  				continue;
> >  			} else {
> >  				result = SCAN_EXCEED_NONE_PTE;
> > @@ -1461,6 +1568,8 @@ static int collapse_scan_pmd(struct mm_struct *mm,
> >  			}
> >  		}
> >
> > +		/* Set bit for occupied pages */
> > +		bitmap_set(cc->mthp_bitmap, i, 1);
>
> Maybe worth highlighting this is now _the entire point_ of the loop.
>
> I wonder if we shouldn't just separate this logic out and name it
> apppropriately? As we're into realms of real confusion here.
>
> >  		/*
> >  		 * Record which node the original page is from and save this
> >  		 * information to cc->node_load[].
> > @@ -1517,9 +1626,12 @@ static int collapse_scan_pmd(struct mm_struct *mm,
> >  out_unmap:
> >  	pte_unmap_unlock(pte, ptl);
> >  	if (result == SCAN_SUCCEED) {
> > -		result = collapse_huge_page(mm, start_addr, referenced,
> > -					    unmapped, cc, mmap_locked,
> > -					    HPAGE_PMD_ORDER, 0);
>
> Hmm... what's actually enforcing that MADV_COLLAPSE isn't using this?
> You've not done any cc->khugepaged checks afaict?
>
> It seems that you _are_ enabling this for MADV_COLLAPSE unless I've missed
> something?
>
> > +		nr_collapsed = collapse_scan_bitmap(mm, start_addr, referenced, unmapped,
> > +					      cc, mmap_locked, enabled_orders);
> > +		if (nr_collapsed > 0)
> > +			result = SCAN_SUCCEED;
> > +		else
> > +			result = SCAN_FAIL;
> >  	}
> >  out:
> >  	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> > --
> > 2.51.0
> >
>
> Thanks, Lorenzo

