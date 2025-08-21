Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AFF6CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 14:25:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDEAF6B00A0; Thu, 21 Aug 2025 10:25:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB5D96B00A1; Thu, 21 Aug 2025 10:25:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7DBD6B00A2; Thu, 21 Aug 2025 10:25:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B22756B00A0
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:25:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67978B9725
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:25:17 +0000 (UTC)
X-FDA: 83800987074.27.327A193
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1D53140010
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:25:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="fPFH/xPq";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="rzPFh/jN";
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755786314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2xR1dvhOn7Ev+7sktbZ/YJYGGHuterTXPWsCqSQTxw=;
	b=bjA6xPY4QEOsPCLMBUsnm/zAeRO2w3fs4hXgxLIScR6Xw7Ui5GoebMnBLXXG3NaWIZCNLQ
	s5rQbFAzNZp3cKN7zpeRSvZ6kdffhzNPHixh6zBX2PuFTLblEGleDasigYMgl6k4NSZHwq
	9xUXxjU3FQPXZHJ42vk+h6WVns8kZ7U=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="fPFH/xPq";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="rzPFh/jN";
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755786314; a=rsa-sha256;
	cv=pass;
	b=k0FU/+cLNSPCBJJZK9NZ4kTFMxhnp8K0vvoHFlHZZSkA0YV3gH640cqcctLKswRWfZEpZ3
	jGx+l29J68M9JkFHJqB8adQg1Hpi1fjmYg3GCyKYCwXjiRemMF0JFgzMGZXAuFwy2RB0rB
	aVuO+ZaereGaVXHqWL4vrG1ZUiaVOp8=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57LCv07R016962;
	Thu, 21 Aug 2025 14:24:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=J2xR1dvhOn7Ev+7skt
	bZ/YJYGGHuterTXPWsCqSQTxw=; b=fPFH/xPq14Kzz8CvBxq9eaw1oAtD3+yo4Y
	9gt2OR18cs6n2RNMi8p0yt5bNbwybnukpuntidDGRcv8rkTt58n79u+5WkekQybO
	+Uz7tI3qAbX+/es05WjNvtGpxOXtqnaTp3X2twCmt4syaDJgSv+8F4wYYMPgNKM2
	dnnc0YKb5f4/KiNYIT/ZjoyuSXmQSK7fTmtOSC+dY9xDIkfC3dy+1PWwRhdUA93U
	oUD3FcbFhFzRY4TTrOxna+6wfVCb9HvrJ0SqBYUSpLfkL1Ae3iqDzyi0rN7czEOU
	bNUBxYMHwFXt15ljX2Bf2tXqeiREJurEwcG1NTO+G8phsWudMufA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tquqd2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 14:24:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57LE4mlX027084;
	Thu, 21 Aug 2025 14:24:28 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012014.outbound.protection.outlook.com [52.101.43.14])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48n3sxm6ff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 14:24:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YSG5JMEmMRlYMsNpAA84U+5ryu9RfzjVo8MU9QX9w/LwGyUtPgLijv0KAbrJ9oBvH1p6UbHMGzCstBwNEBsg50tqma4RarKujSnj0pp5ucGeDP3P/SSvcx1+CDlObPDVhkgp10esqmMUMZiAhWBnHYEmzXnwarpJYPHFuYYmro0L15ixFsq9/KrCw0BXrfQquj6pGXNdZpng/sz0JvdL2S0+jk1HXyHvs1pBvjEcNYuUJfFFiYA8240XU0rzSEc+oCFxJ7gyQfQsnTiEtHpFH+2HKtp9Q0ClBV16LvqV0E4l5ZRKD4cHq1aene+fURhyfYce8UDQrXZe/yhge9yWBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J2xR1dvhOn7Ev+7sktbZ/YJYGGHuterTXPWsCqSQTxw=;
 b=VVeEXooX7QY14IZoGjz2jmCa9uTEdRhcZ02d/hL51tsp7yGPvB5xiGBWJarPgJ47Nu8AWl03bGV3HZ5ZD9NPAcrk5hM6CaENNRDen2Ze1N3fKN22GbBbIHHaSGn0TZXGdmt9E5ZAuaT9q5pIOGJDp6YduJuMofxGZLIBEbmtsjk7Qki3LHXIQO5L30iA+c+EtLKiQMecpYFuexiYVFnTwPI/eXrTLBmmL1ny3VFGwCW20rba+YQZ4uI4zJ+66bkI+/jDEHiYxGxW0srSs6OXN2xl1GmIWj1TUpguZH4z7315kfCVpqH5OgbpNhKn8bf+nFz6NcUCvk+ttTfT1z6w3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2xR1dvhOn7Ev+7sktbZ/YJYGGHuterTXPWsCqSQTxw=;
 b=rzPFh/jN3iRCVF/BCtbgxxPvotV8SzfbqLN0PFJ59noTpULtjnSITRG/c+4e9BeGY8P7gWyLBD2hyCW2qcSfw4huNKYBFIb3O41xHbntGf/t12UGkoEDVwhjfCD+W1+1rjIQMwlxcI3aLm7x70G3HElwpAGs9t1iumsM+6dtrHw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB7345.namprd10.prod.outlook.com (2603:10b6:8:ef::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Thu, 21 Aug
 2025 14:24:19 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Thu, 21 Aug 2025
 14:24:19 +0000
Date: Thu, 21 Aug 2025 15:24:17 +0100
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
Subject: Re: [PATCH v10 11/13] khugepaged: improve tracepoints for mTHP orders
Message-ID: <8ce6482f-4e24-4f6c-b28d-641fa878b4fd@lucifer.local>
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819134205.622806-12-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819134205.622806-12-npache@redhat.com>
X-ClientProxiedBy: MM0P280CA0003.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB7345:EE_
X-MS-Office365-Filtering-Correlation-Id: 66d9f333-65a1-4309-df21-08dde0be6acf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uw7WVe8K8wwsjDVvs84SzReDh7X+wRnBgHV+XoL5/kxba70rKSBaO3MAxm/f?=
 =?us-ascii?Q?Hi9V3PpQexOfOh9Lx0EWWR5YXgbMpFASlzKsIP4gp4XssvykzWa8dqq1IlwX?=
 =?us-ascii?Q?bYwFkzMCp8/eun6qglKYMiD8S9P5fuhChEgYntXbDwKxY4wAzBi/2OxnvlhB?=
 =?us-ascii?Q?vL53VnY8Obm27Jh7kvq+guDO33jO1mSfQs/HA/L71RPTzaATDCc+ddjyl0fA?=
 =?us-ascii?Q?oGAaws9K79b9BzgYmXLv+pJAWCl/6zR1qtSgD8d0sCVMRokLnu4rG09Pka88?=
 =?us-ascii?Q?6o10FARD7H0dyoxEUkBRu6hNyzFLdPq6kT/Um5ZfxLidbPQukFBpPGiZVzAo?=
 =?us-ascii?Q?NF6g5nWek7Yq/dw/A+TZYB5e2VPL5GY30psPVONOKghW1C43mm6kP3JFakok?=
 =?us-ascii?Q?2KdT/DE2Tu+fasBSQMjiryuKLk3px8QGRqzRSvb9GMtg4ycmtW+IxKlN9LDY?=
 =?us-ascii?Q?LozdEMVqNiaAZSwI4d9/Sr7yZVeJfM+aWlzVqN8oWS405hCVrokCVJ823133?=
 =?us-ascii?Q?DDxZOTiuliz5wrDesaRx84D8eOqixZRWaHtqgsceRXcmBdD+9pApkFse3oKH?=
 =?us-ascii?Q?5Ugp0lXmIJ32iEGb9xjW5TCIDbD8fd5LkhXPWTwi3gi3TDDKOb6YQCs0wamy?=
 =?us-ascii?Q?/vG5WwQ8Lx+e6fehlUsPqNakfK9dDeV9tRV31R4Pj7TzQJfFmlnpK/ROGIhl?=
 =?us-ascii?Q?cRge64WlFyh+spU3B/qE0OJrc3n/YwW4zdiM4RuDlw/i1fKzzV/Erngih4yB?=
 =?us-ascii?Q?uSAaY8X7wJgGW4OKMgCIUUmqSR+sEyOz6TyTwyJOZfxEbwuztTXglPf15voa?=
 =?us-ascii?Q?7jCQQgMthJR7Uw28/fw2n/ostvsBdWtZjHe3te/DEHeaaHudyU44mc+XieXE?=
 =?us-ascii?Q?ZrAsZ/UrTcYDT7lPGUzmz/uWwtG0lptYotLzP79B/pj1WSiXhEeUgR8NzKE+?=
 =?us-ascii?Q?fDZxfqnB0i8Ze8lClz9AgFFJxTdMuRLNr11s7PBevM9WOBDfzhqd3eIp3nWT?=
 =?us-ascii?Q?aC9qDaoTKfI7ckSSoDxd6yo+7CMmZSJTJ3LZ4ycBew3jKjGKg3QrZ4S8LIq/?=
 =?us-ascii?Q?EzxE8u0raqPKjHm5iUIBGIhdeRpUU7yZfz9U/gqyW4midFLRyGugC0GMEHy+?=
 =?us-ascii?Q?osS/JG0Bnk+p84kyD5/HSn0L7sRof58Z4CnUsOAvgHyIY9IoRrPPOl9ZMrNd?=
 =?us-ascii?Q?curX6Hhd5/0Bd1DRTLXYw1eNCCKq29XiV0umFKbUegkK8sUq+1MF5Bn2nStu?=
 =?us-ascii?Q?O0Jg82BWp1MHW7kIRJuTt8FCoCX96/hrETI4oDXYp0zXCRu5l7zgPxXtKR/J?=
 =?us-ascii?Q?2StWF8yRzRn7EqlNEcNmThEU0K+kKmn1sAF9r6yuNLvRmdwjePoppmgHpdYA?=
 =?us-ascii?Q?vX2FQyQoctROcomxJ/WFQUjG8UT1OvcPPZ6nYzrO1ZClg6rVD9jzD3leqd+w?=
 =?us-ascii?Q?/D1DN+Rohm8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S1lVHl7LrI3qFgpzp0AucvAaMuYK+2gPI1LDdrPrGg1kFlZ//ow2CBVtAhjY?=
 =?us-ascii?Q?oalbf1Ire4umxd4fTnd57uUai0pNsd4HY53TQr/myMB0YM/p0Mew3yaFIQ2N?=
 =?us-ascii?Q?tJKsZN1KO09+5rzRqv5T7ka5EJ/QEL52oyxwnu3NxKwM2464IcdtNlQoePu4?=
 =?us-ascii?Q?47iUm3mQ1WYoTTPj422tuD85WASZ5cAx3v5blMSrBsTcWwq20hgwyScHyMsA?=
 =?us-ascii?Q?+V5SBmSFj0LIvTk2Sf1xHEpWWTwR9W7if0EQqQ3BOHl8WnMa3m2mt/HpccRP?=
 =?us-ascii?Q?mqGikaA1V5rK6O7w7pkaXhMN3S6xtvcDrJ8oJgEeNNQk6Xi4IDFpOClzW5hD?=
 =?us-ascii?Q?7P2CQuxEpVh2S0jikzWZP8VJxjFZdx8wWj3aWwUz1xBXDH0gFACVXihq+D8X?=
 =?us-ascii?Q?PaqMpJ7lYa5rSHmfBlqxf5fJPJh9eN6cCkBB4uQukZiZG6p8Z5zy2Il+hheG?=
 =?us-ascii?Q?v7G04FKVd1thKJxfSPtMFFWN/1F5HRxYt0wCkq6aB1VkJ+RxTLyflQX0s91E?=
 =?us-ascii?Q?roNUEHnl8CJtZ0hUF6HWPb1lBwEAnYxRPeUaTPHOgR0ZMPwfH0W4l+AMrRSZ?=
 =?us-ascii?Q?wPQl69P3Z1b1LOsVHV8nLLI3Q6R7mXkxqCSpe3eHe3YZHNAieZeTVT415tZ4?=
 =?us-ascii?Q?/Y9PXOjwC2hFYghzQPmyaG2YqeCnJN8FMmV5mPc7yDuR7jtK8VAzuQ0mr5SN?=
 =?us-ascii?Q?gCMfJz2HF1mmgwRa3VmPnIZzz5RI3wEIKfRdCAUUdGgcWdXBPqWnFFFmbWrw?=
 =?us-ascii?Q?CFEUboTwQVQFxeDZMwGTezsXTh6+mEL/W899SSXeeHPScKyPHHQ4sgQkHJOb?=
 =?us-ascii?Q?Z7beSLNoW8Kf4BkAp/KxpneiHAPueaXVpR3fyg+lEwMwKQnLxwa/b2GBXhd4?=
 =?us-ascii?Q?KhrFzXiHCgT42vzsApCRSwPI1U2GZkRIe412g3WLuTBFHXe0utKHlscTsrh3?=
 =?us-ascii?Q?SE9Wdp3qLHpOh0SrJ7q3uB6eVnIqNio3YWwYdY4mDJIac30ugkMoW4T0At1Z?=
 =?us-ascii?Q?2o9sF/ws8mHBDU1slVt6eA5wcqIYMG4yR6C50GVqZLpAe7M3b/ciclvJEXs2?=
 =?us-ascii?Q?JMgv2zMTj6IDs0+GzJtYL24UERkvjTr72e4h3FSScL2xge7jyJUaRzAg/Ip9?=
 =?us-ascii?Q?6Qz4U5TYjbDNV30R+NyvQ22FL1EwxdJP3CWETli5g+ztjJjiEI2mAuXL7PWO?=
 =?us-ascii?Q?jBMDL4TtXFdrfyrAA7xe2pD6WBYN/krMbCu4M0MwSo7PwEdOKFa6jhBDBMg2?=
 =?us-ascii?Q?6EGdtr+RfNqyBA3JIrPVTI5vmRcmzQ5KhN67YPiv7qj6iHjBMt3JljD8nOK3?=
 =?us-ascii?Q?VLCcoyRhExILS7ETUVT8tiipn1YdBlpCK+FwydQTU1AqAqJMLgOQlbXKdZcJ?=
 =?us-ascii?Q?7ei611tnzAdcP3qg5WJrbcn00/zczvzOJjnxWiOUTbssskArpTSUN/ke2k+Y?=
 =?us-ascii?Q?AJtVIrS5S+PTomd0zSBYZdMp51n9k5UoxhdJkAC7MrCAXmS/cP9cxXIJHiLI?=
 =?us-ascii?Q?r9cvL4lSDH/inIiDjC4MsDvBQBeDepqD/i8UBHsKiXlKOncBzl2v8rhJFopk?=
 =?us-ascii?Q?JUBMuNaUkgIt2pvamWYcGGzC+A8n15GFbIkYWdAH+HL8AcZ/GJW9rXcxXPWM?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7K1FhCyhHJjXV5U39sY0XSR2S4++Coh6wFe5pUGT4N4w9QO8pCA5AiSEQYXfADwMgX4SCMHW2vfKEH22ybH2EgloNZyoSwNpsg2HZgov0PEqJvgr1Rqi4OvlxJW2N1FNyk7hp8JTIyR32pFqS1wCMTt6EEPjGF74DiIKpjp8v3YVsnRj4+I8VUPfDXa012c5xSPjkXZHj0cwi/WHxcZGjKdlUq4mTTgRUw7+FKLTDao0QrIud3T0lkbB0N+Lh0MhHxP6T+oqBvaIxojt++QpV6qTmOJVv2j3aLR/jaGaGgBSLy2czeqUxyz2Y7kqqMc9JB9tqndizgGaNCJZEwWK9N1EdxAOP/lGsudp1rUoObR5yZ5DL/taM7+ROkIs5hfZq4W9QCZblozGvVromlw+ctuRO0/aTHXwT8dYUOe0ZKR9oCd0exZyaxYtLCzlKsFcXBPxm23v2++xI6k5wT1ksckl4UWk0tMbCc/yUJPx2cux3eizBTkUS7xOiKj0P5CgDsUmDz2hwj99rtzX2NaMTFBQNYEMumqjycGd+4rWQqk2nRmBzpHZ0OaQsyvEWoGJ0ML+VpnCYJTnhuzvz3rN+CD3Lrw2ho5qn/cYRlTGIVc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66d9f333-65a1-4309-df21-08dde0be6acf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 14:24:19.7699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eVUxyZ859luux1/rFlnY8lxiL04S3C+1NW7c4wjbjko+f7xjR6DhfpcAvbT+wJO+BkeEd7rlf+KNNxEgVJbyFyARxu/3Fj2jUbKsFXe5JtA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7345
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-21_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508210116
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfXy140zumW+dE5
 MWQcjPZTcgEA4D+cBdUuQTdR4pZzZrHxnPA5+IlOj7uS2FhpLlvq2igHv54TRsaDhlQDPhPdpX5
 lPKJOEwUzBTRsd5ZuD/zwvDeXgXybwIREkdLSPSDN9o2gUtHLwdQsXN/CaC/Ch0R22JRpacBzZm
 tZdtXeLlbOsurc+1k5Y3PCi2zxSQqlJnP6xHxsm9NYBOlj6k8Bdq+rbJY8WajJGPj+poj9NLDgG
 L2ubv1Z4OOxRtY4dgSa64+kIsV8MkXsumIOtvC+Ylhc6ghcP3BKIQdjz70BFYP7sjFv2/B7H7HK
 VpvFrz1Pdbwe7jYbECq97/2Hgf7LtVn0rRrxs6/xZ/JLE15PCQE38cwC9VMIVGXlEdEKLXxQ97h
 i86dh/l6oe6pbi335gXm1jHYiqZSLA==
X-Proofpoint-ORIG-GUID: 4RoGAKHqTJWq2Iwwwu2D58m5ch_B9isV
X-Proofpoint-GUID: 4RoGAKHqTJWq2Iwwwu2D58m5ch_B9isV
X-Authority-Analysis: v=2.4 cv=K/p73yWI c=1 sm=1 tr=0 ts=68a72c1d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=SRrdq9N9AAAA:8
 a=yPCof4ZbAAAA:8 a=v-LYk_omI0BxYk_5GfEA:9 a=CjuIK1q_8ugA:10
 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Rspamd-Queue-Id: 1D53140010
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: hz71px1sgxbq7n4d5rbgthbcujq3ab9b
X-HE-Tag: 1755786313-834610
X-HE-Meta: U2FsdGVkX19/ZM8ppzXfw7AZ+GvYje+xzMX13T8HaX444ncGN8wGrqV8ka+alebdE3N5xC9zGotMF06csnJF+46eDXQA+ZS075PTFOKdxmG7YTO5WOpBO5k4xywbYh/FBAJbw5mnXyj9ROqfy4GPlR902ksvmtDXTl//cVKf/rM9MJro2liouEYdGMNKB7rnGtygl4kDlXjmlC8EsgVD5H8bYADvOwkQ8R/wb1pnMyWdJx4l3qtqhjm6Xr/Q2Eo3Rg6sYfV+v0fHg8sat7dQBqOYGQlv0EVmyj6QoAsb7Ks760GOSXxN4aQb2rR+3mq1bYfdW8nxV8ksGFyNKdOTIzWs+/yP1t6tvPtUw0+JKCmHM5NVBuewPgtHBShsIBq8Bg2MfSF2B8Xsz/LI8OgrYlNkcS15k746fzhn/l2leogjSRf1WDXrnmWDlzX4IvgnJfPO+MOMAMuzFIM3Cr+xfLKdGp/D6S98hpXHipIbYcdODvzUCv/pf0K+2MekoTTHYckaCHz17NlrXq1EZVUe9M2vw4kDHDjfWiQicKQQPR0UMW818UPNL4H/rYkUAVoIEKTD6tNf0N1XRVngh75HRvwFac+x+9gwwtNFZ9EAXJQxjLIz6J8vgkThklhS+6zZxBuMcC6HXy6XrHKmbvRay4VyZGb9q9Xns57vUdbQRa1XGJQo7jKjvB8VTkxP19JRO/BLB8Khf29GJuT0jdqsSYLyhfcV7LnCTyTvNiPWhYPFesG8CMCqeyYW+Jamdv/SgkEYtw8kcjtcWsh43FMV2YArmkM8YtZNz+R9D5tnEpp9jeJW26LyQ0w5nLrV8xtOO32TH0ipTr3TBdyPtaJYEpRYoZsAVvsy2ah3gCTwDO6bdZgkZ2DOiztqb2PoSNcI3VFlTy+okY772eDtcyHtER5dPUNG739yi0L9rTptVavR/uLIUdpzVd0SzP+dIH+dTKjd5kQZyxPQR68Sl2s
 jF74Gw28
 K8jnKWd9gqpAvRRKmVtrqnu2Tvh3XPck1E1r0GXX5T07aCeoQmyvBTsqssmTrTUbzIy5gIYLkvBj3gTg27FUOEFi7skXm937O8djoDGutlbXj4QZhFs+YnLc3FnmUbtK/L+jWLLd2igATlvDRz0X6d2WgKviacjm9KUVzVGsafdmzx3tyIGfwGsT6VTYE7ESQjpJsez91ntHwj+EhvpyZ/b5/nfN45n+U/uwqBLwWQjnDB72pgKMydnzj2T75PF2acBSA0+wEC0TaaXstVdA0jIFFw+v4v+UFfBLQotPEUqciCjXzMvleNJLGhsjb5URl3sRj216VhQUwJNTTojGgXkeSfFqzWMH9LaMRm/SwCZlGiZLuUp31ZedqC12dBsVgJjJazduZPwCTue58OEdG1xmqRM5ayCL4Znw8/4IfuWfEpNJzwdJ6YJX7gntOuMHP7+sPgpDHR+HTNm2GnOGsc11K1W8CWorzevaugJ0frXLiZ93H/CQ4uhHadlPbLOC4DnXW0jnCH702LFYS+HN3D4TXd080A/dwxILbeCdMb8Ccr3PQ2k1E3w2k5LcgivQ1lK5ozU0EC0cEhn6klpj+xiim/BDhbnkF5EXjh/ZRVpwaGfoiEuF+IErgBg1hyVrJB37FUyycCjeG2ub0J25crK3tIcIPN1v0EoBWzf3TDXeLsvvfGw/PVYknC09hM/3s/2rdFvXS2Pfzf4106GBjCOzvHgORw95zrhit4YvFuJk87g48kFimVRj8zJhkwh5JkuFJo1NKrxVzHWtLc32/+c3bMdQ40GMP43nTBP998zJyosjGALZmCHx8AbvypBFYQl2NCYdZtZaRnujLj+fUQTCjSGDGO1MPCwwS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 07:42:03AM -0600, Nico Pache wrote:
> Add the order to the tracepoints to give better insight into what order
> is being operated at for khugepaged.

NIT: Would be good to list the tracepoints you changed here.

>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>

LGTM to me, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/trace/events/huge_memory.h | 34 +++++++++++++++++++-----------
>  mm/khugepaged.c                    | 10 +++++----
>  2 files changed, 28 insertions(+), 16 deletions(-)
>
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index 2305df6cb485..56aa8c3b011b 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -92,34 +92,37 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
>
>  TRACE_EVENT(mm_collapse_huge_page,
>
> -	TP_PROTO(struct mm_struct *mm, int isolated, int status),
> +	TP_PROTO(struct mm_struct *mm, int isolated, int status, unsigned int order),
>
> -	TP_ARGS(mm, isolated, status),
> +	TP_ARGS(mm, isolated, status, order),
>
>  	TP_STRUCT__entry(
>  		__field(struct mm_struct *, mm)
>  		__field(int, isolated)
>  		__field(int, status)
> +		__field(unsigned int, order)
>  	),
>
>  	TP_fast_assign(
>  		__entry->mm = mm;
>  		__entry->isolated = isolated;
>  		__entry->status = status;
> +		__entry->order = order;
>  	),
>
> -	TP_printk("mm=%p, isolated=%d, status=%s",
> +	TP_printk("mm=%p, isolated=%d, status=%s order=%u",
>  		__entry->mm,
>  		__entry->isolated,
> -		__print_symbolic(__entry->status, SCAN_STATUS))
> +		__print_symbolic(__entry->status, SCAN_STATUS),
> +		__entry->order)
>  );
>
>  TRACE_EVENT(mm_collapse_huge_page_isolate,
>
>  	TP_PROTO(struct folio *folio, int none_or_zero,
> -		 int referenced, bool  writable, int status),
> +		 int referenced, bool  writable, int status, unsigned int order),
>
> -	TP_ARGS(folio, none_or_zero, referenced, writable, status),
> +	TP_ARGS(folio, none_or_zero, referenced, writable, status, order),
>
>  	TP_STRUCT__entry(
>  		__field(unsigned long, pfn)
> @@ -127,6 +130,7 @@ TRACE_EVENT(mm_collapse_huge_page_isolate,
>  		__field(int, referenced)
>  		__field(bool, writable)
>  		__field(int, status)
> +		__field(unsigned int, order)
>  	),
>
>  	TP_fast_assign(
> @@ -135,27 +139,31 @@ TRACE_EVENT(mm_collapse_huge_page_isolate,
>  		__entry->referenced = referenced;
>  		__entry->writable = writable;
>  		__entry->status = status;
> +		__entry->order = order;
>  	),
>
> -	TP_printk("scan_pfn=0x%lx, none_or_zero=%d, referenced=%d, writable=%d, status=%s",
> +	TP_printk("scan_pfn=0x%lx, none_or_zero=%d, referenced=%d, writable=%d, status=%s order=%u",
>  		__entry->pfn,
>  		__entry->none_or_zero,
>  		__entry->referenced,
>  		__entry->writable,
> -		__print_symbolic(__entry->status, SCAN_STATUS))
> +		__print_symbolic(__entry->status, SCAN_STATUS),
> +		__entry->order)
>  );
>
>  TRACE_EVENT(mm_collapse_huge_page_swapin,
>
> -	TP_PROTO(struct mm_struct *mm, int swapped_in, int referenced, int ret),
> +	TP_PROTO(struct mm_struct *mm, int swapped_in, int referenced, int ret,
> +		 unsigned int order),
>
> -	TP_ARGS(mm, swapped_in, referenced, ret),
> +	TP_ARGS(mm, swapped_in, referenced, ret, order),
>
>  	TP_STRUCT__entry(
>  		__field(struct mm_struct *, mm)
>  		__field(int, swapped_in)
>  		__field(int, referenced)
>  		__field(int, ret)
> +		__field(unsigned int, order)
>  	),
>
>  	TP_fast_assign(
> @@ -163,13 +171,15 @@ TRACE_EVENT(mm_collapse_huge_page_swapin,
>  		__entry->swapped_in = swapped_in;
>  		__entry->referenced = referenced;
>  		__entry->ret = ret;
> +		__entry->order = order;
>  	),
>
> -	TP_printk("mm=%p, swapped_in=%d, referenced=%d, ret=%d",
> +	TP_printk("mm=%p, swapped_in=%d, referenced=%d, ret=%d, order=%u",
>  		__entry->mm,
>  		__entry->swapped_in,
>  		__entry->referenced,
> -		__entry->ret)
> +		__entry->ret,
> +		__entry->order)
>  );
>
>  TRACE_EVENT(mm_khugepaged_scan_file,
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 81d2ffd56ab9..c13bc583a368 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -721,13 +721,14 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  	} else {
>  		result = SCAN_SUCCEED;
>  		trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
> -						    referenced, writable, result);
> +						    referenced, writable, result,
> +						    order);
>  		return result;
>  	}
>  out:
>  	release_pte_pages(pte, _pte, compound_pagelist);
>  	trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
> -					    referenced, writable, result);
> +					    referenced, writable, result, order);
>  	return result;
>  }
>
> @@ -1123,7 +1124,8 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
>
>  	result = SCAN_SUCCEED;
>  out:
> -	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result);
> +	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result,
> +					   order);
>  	return result;
>  }
>
> @@ -1348,7 +1350,7 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  	*mmap_locked = false;
>  	if (folio)
>  		folio_put(folio);
> -	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
> +	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result, order);
>  	return result;
>  }
>
> --
> 2.50.1
>

