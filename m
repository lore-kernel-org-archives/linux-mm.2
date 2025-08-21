Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5A6FCA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 15:02:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F18986B00A7; Thu, 21 Aug 2025 11:02:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0DD6B00A8; Thu, 21 Aug 2025 11:02:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE0D98E0001; Thu, 21 Aug 2025 11:02:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAB806B00A7
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:02:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58939B71C5
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:02:06 +0000 (UTC)
X-FDA: 83801079852.07.506942E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 78978180013
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:02:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rNbqgNG8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SRV8Bgsj;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755788523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sX0bTCSsM76hS3rDyvdm1/2ehFcrV33eBWu1pZ59Ecw=;
	b=Kd1KJfTppmNQuiy05Vg2lyXiMKSZRhBjVi+UdDpiShJblkXCtSZnSizYGtL4HobC/dosSq
	2L32GPyWYXFG5A7I78K7SfW+uxTeTPSRdDVb2S+6KhqDD9+cocx3W00hU+UVSOvQwSje0b
	rf7YJ4ZPduNzAWFNxOIEumxyHAFST1o=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rNbqgNG8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SRV8Bgsj;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755788523; a=rsa-sha256;
	cv=pass;
	b=gSl9pBBujrrO7q+M4tZy/jMXYdLJI2KhxyqcwAmY24k4rFI9q1arFQ6g+PlrUqpDPNYnKC
	pusSJC0LFFkZnAnlEK5ZHD+HTTe/P0lT4Bc76i+ijs1lqTa9pt0RyumoT89aRvi7gGotyz
	a/PWkzjgRTAIXp6iy6E8xDeCIYShxIs=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57LEt8ae025537;
	Thu, 21 Aug 2025 15:01:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=sX0bTCSsM76hS3rDyv
	dm1/2ehFcrV33eBWu1pZ59Ecw=; b=rNbqgNG81r4Yy3GtKuNUtk5rx8WeO3KDY2
	JFQLPrIJ+gcjk/0H8cErkPlsXK9qBcJe0PFRu/7ymQBX8N4XB2rCttDa5bdCXSi5
	HC/yBvB5H5s+92pc4ReWEa8hIjqcMacUT6o0MNoneB9oN5uwvvC7N1ohTW1nunzQ
	rr0bO83qpJf5t2v4V9NWLr/kdQ+Z5bYWGEPt/8HGaDx5HI16XdEihDMKl9mPqQKl
	CFbz/5tEVcmxhTcYOU2KllgZOXGMAYcPWQmqXyPoH/N2tlw6v91g+CKxrZ+rLyDi
	mTlJE63MHMrmXTrMbt+tYHeS8HoCPOhmzG88F2gQCCiJ1ODwaqNw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0ttkjbp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 15:01:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57LDo6v0039559;
	Thu, 21 Aug 2025 15:01:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3s72uf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 15:01:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XqHA3XjKEjptUbYaoUSdpD6gP/LN8kiTWXUlp6ME3IUJg828z/KJZlex4Vb5Tfqrv+Kgwu51bJ0ZpH6+GE1hws7ueLjZuaDOb3p0PKigCV55AqK0xBrSI1nXHbiCHgfoiqtqzqZAYurY0TZzl6WzWNcWrLAx93H6I06LvSNW2mElN75fXTT9eLb80Xx2ihSSi3IZ2S5dAzpKe37txmIXxqCx/3VWskrkSnCBywZ1VeiAQug2yEt5PSDat8BVwx0ZVzIChUS3sXR6dp7SkCnHGC2EBeCDRbTAdOoWF+8WxpfjOoGUOAwIIQcX6puU9U9HIyeyim9kJDZG0WJBunaE2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sX0bTCSsM76hS3rDyvdm1/2ehFcrV33eBWu1pZ59Ecw=;
 b=c2vssc74M3AhstC3E8LPppK5oXGpvfi2kVqDviVOhP0TDrcYthuXj2HKgBhBGKcpnUciqe3ioA6sZIObBhw8hqRtN16MjuOMps/KMMbXjH0Czm8KI0q9RwHsoi+Svck+pU6OP5axdrKIIu297rd0988zmQVOejSW5ih4mJskqYr9OZIkpmjp66yTlcxOEk8Pbs4xr1cqHjZBhygKAIjmP8ZaP33JC8iTPC7/8jXuyosJkfKB1nhde48yYgI9cRKL8h/Qd6cywS+0cAR8yWQN1WOhqA5Cd1aTq8YQa95cF/8SGAT3YEwFivSdwVdkrp1ZywMg+LoA3s8g+E2U9nVfNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sX0bTCSsM76hS3rDyvdm1/2ehFcrV33eBWu1pZ59Ecw=;
 b=SRV8BgsjPljkc4uRGg1V5MXALokrGyY/ZiyhsAuOhOl9VKyuFHDc+69AGJa8b97OWt/SPE4CIeoL5H+ZoCvyvpzZ/iksPE8DW6AxKpNGgro6/idNYrryz6v8d71UyYjZw6cB5uDcP1AbpShhdb9CNCsg6SQWXVkmmkPYjCbiLMI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB6534.namprd10.prod.outlook.com (2603:10b6:303:224::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.23; Thu, 21 Aug
 2025 15:01:08 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Thu, 21 Aug 2025
 15:01:08 +0000
Date: Thu, 21 Aug 2025 16:01:06 +0100
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
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
Message-ID: <e971c7e0-70f0-4ce0-b288-4b581e8c15d3@lucifer.local>
References: <20250819134205.622806-1-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819134205.622806-1-npache@redhat.com>
X-ClientProxiedBy: MM0P280CA0065.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: 92f3a222-75f0-4553-b1c8-08dde0c38f4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2LIfTq+aHWoMOYtglbG9vNibPlikbjUJFMxVxNGxOdABVA9WGztv6iSqx9CQ?=
 =?us-ascii?Q?W/HFMCwCp5DcP+tqv07hJydieB0HYluhfVldqjsLGoZOZIAIPdaFyaxScS7v?=
 =?us-ascii?Q?apu9vUi12SY9CMi/nUQfQwvwracigz9CKUoDTrpJlVaoba0LId3n2zFrh2nN?=
 =?us-ascii?Q?9JfzaAPbBXC3A1V0+F2P0mrXfSmBY7xZ6lQUtwYYYizm7HeDHp5H/0VpT/ro?=
 =?us-ascii?Q?rYufj3f3uhaj/SiZASfIpXgvwNOxtQ9UvfXH4cb79cGfXA8ZS8KVs6zavGs2?=
 =?us-ascii?Q?urOQxepjba4rlLO0WBm8DpwY1ZNnRgJb8M4DuV5uxNFiJZW72U7afR+d6wiI?=
 =?us-ascii?Q?UklJFNrrCHIHrPBYdKIeS+1lv1QMgfp29UY6V7K5EqeZ9cQvwdFhJnupfnsH?=
 =?us-ascii?Q?ZAeJO0QDdg5dOBqIsJ9wg9NJOOTOChKd376Pj7rQmeUJG6Ag6S/7UZALdUIp?=
 =?us-ascii?Q?r9N4BMAsEcGxhIavd4QdEJd2sDMt88ct7LaH+EjT/I3/tj6mg9vlv1ew4qcr?=
 =?us-ascii?Q?4K9WT9NDdOzpaFwNvXKyIsFohG2uYjuwXQ6geGTGcjZyWzTP1Ykyyj/wE48E?=
 =?us-ascii?Q?VZ+PBYPpQmoGNCYSAsgB+pk1T36zXKtGKVcQxM8kCsLn84byX20dvolY+8EN?=
 =?us-ascii?Q?4Qb3tqUTKeMvR8c8aeZwGfbNn+1dhyGqbue/L163cUmGjmT8zsBhKOmHNRHT?=
 =?us-ascii?Q?VW4u1wTLnfhoUFlRhE9a24berS1LyxnlQs6+zC+H+ymvtTjC9Hs2XUEFNxvx?=
 =?us-ascii?Q?oYTnun11Of3SX4s17qts+c5127C3YXTkkPr9rK4cuyxbJMedlas6i+pvap4S?=
 =?us-ascii?Q?a43zNpEHgfwriTLv7WUA7jk39ULfibQKjuK/KsfB5/e1FBqqI4gVlXH8CA3p?=
 =?us-ascii?Q?7ELQ5CYXu6RrJQt972/nzYax107jJ94inJyWldlPxHSQRhEQ8UtSw4POHZV7?=
 =?us-ascii?Q?tRZR0YEQNITDZIsLk/h0o0fpPIhpWQDTLw3R2qgjaC1g06SW2GS9lk1rF5vZ?=
 =?us-ascii?Q?ZGH4QbwaN562v8+SR9rmQ9fBgyv+GzsKMRelci1k1FL0VghJUcyWsXfEY8h9?=
 =?us-ascii?Q?GGBasRBPZckazTEzXIlh0s4tfy2+CR97BgJwA6KJlC5fVfif3ZLlMbKsYOc/?=
 =?us-ascii?Q?hNNy4/p2Yoyiryv0sIl40BXp8IU6r8RdKQTm91Jm/dKw887DRKrzoxY5hH72?=
 =?us-ascii?Q?GBfYwg216hbW39ilZBhyYEP0XL7Z/WtZmROdNrSWB82C/It4hsuoQLqVr1x+?=
 =?us-ascii?Q?mkk/w2Dt0lzZxZOLS0Dn3nY2N8MoVVWUe+Y8oCXm7i6cPHbrYN+4nZcg4ZDh?=
 =?us-ascii?Q?T0VgQWdZxTNJfsKGDt/DvTv9xgEOMBTOalVm9v/YqayQo5r00q6rGxd1QmtO?=
 =?us-ascii?Q?n/DqyS/hJwYXNjaskeu+u2J7aGglSal1+yoabnsfXdsyRHbQcGnnGuFVU7JG?=
 =?us-ascii?Q?CF8YBEyeJ4A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0BwwHDknfsEcnTaf/AznzFPQr3udldMlFKx9TQ431ljw3wfkWmsuiGuEbntt?=
 =?us-ascii?Q?kZeSoWzWu37V7QqpTyWviCBsdymYFENjRGs5sSAlRlsjB9Glu7aUjJXr+tAG?=
 =?us-ascii?Q?TF7N+7a3C1yeiZDz3bsbWEr69srHaWmnSBA/goY3MTNzgBIWAhnWzFK0sT58?=
 =?us-ascii?Q?YZVeQQKz1WOnnY7jugOKYxJFEoZXyA7GKJ6NsjeOyjW1oi9e7YbfFcAoo1UO?=
 =?us-ascii?Q?2oB8IUT1TM5z7bMhLX7ZJ6QN7DJjyI5//AXAYyusuOgCT8vmx8HPjI0r925N?=
 =?us-ascii?Q?IOLPrnnTCN1R5NSs3Yfp0w2SLjSX5pHUNIjpAQ0zjMTjMs43J/A+807fr4PX?=
 =?us-ascii?Q?yAL/YN9o3gS78bOEc86GQxbCzMUrBYPNKXr8a8ZLX0FtStTSaVygjl06eoEP?=
 =?us-ascii?Q?SRVTIN6wYVcf3ubdsNDio+Rle4OSrMOVukCIiYShvshPDw0kILi6PSR1F/3i?=
 =?us-ascii?Q?Hwo2zbdYRemdUTeu0GqIgIc8wRONeGTR63bIiQCrQb9UVR1qVz2MiOz/H/Zd?=
 =?us-ascii?Q?G1AilaAj45oRBSe+Dpu+dwjgHPT3kw4ZEggTzX1jAuKVP71HhOrLL4QojAXP?=
 =?us-ascii?Q?JoSacb8Y4+ZTvuXTLSGyRM1xPxhVZ/l33O4ybB8iNHFdNv8wDxDRb7jnXqnc?=
 =?us-ascii?Q?jebEZz/rjV6sw56niepVDogmTy7L/H57LmJ8uQys76kyk8xiMP2oma6nqmWA?=
 =?us-ascii?Q?KaFJeH/LOb9wXyM2ZX77Ou2oZyqb1eydAyEnOhDSCHnj+RIiEa7n5tRMkbCU?=
 =?us-ascii?Q?pASC+BXs7rMSNKJJRThttQeVT49hylI7qS/NU5oGLDJk6FhZnZUb4ESXhDrg?=
 =?us-ascii?Q?ry/P7CkbRRcBghtbM21baQeTp4Tj4pXIcTayqyXlef9hU+dgZpEeXJjZ1J+4?=
 =?us-ascii?Q?inRckRdY1h4wR6st8xGp+zoQKS8ukPKCvqj9YbMRsNn88qrU80WW/Zeighpd?=
 =?us-ascii?Q?qJ0LA2FvBmq3F4G4zFIVC/lud70LO6fCb+LZbudmxYTODj3Dq8+zH46VcWA0?=
 =?us-ascii?Q?ldlIZ4aD42dZI1N9hWPwkG/2mRRvqfoI7HAHKUXzYAOGDMpBN7UegHY6AlNt?=
 =?us-ascii?Q?f7QUbJ7CxrN2lvruIdHbEYDftVnGSRBjJwIUGF/TFT6MHdapKHeflBC/gGmY?=
 =?us-ascii?Q?nAkYVg35GqqkIdg/gkgt8Lb0s5tl0mhRs7sye/YG8S7OHlOmVSa6R3G7ToIS?=
 =?us-ascii?Q?/2b9uCL+Bd+lMW06QOjLFfY+F7MXSkpfBTc0liyd45PQbITmGv79cbZtlLkG?=
 =?us-ascii?Q?zyUWBTFdsph31XqJU+H/vjT36ddS3QdA1LvvX8xKmzd7OBKNbIsEW6jmyUwM?=
 =?us-ascii?Q?ZqCL+dvgIVwcRp7b65mICPvfYlmUS+ufxxak8Ex2kkj34JYrKPxCXFsTV23U?=
 =?us-ascii?Q?1jJMZCpKpmdH6/NlRQts7snP0ss66U9FpRMryDOP++cliRlouWRLEisEFQ8W?=
 =?us-ascii?Q?rRGzkZoR6DXyCwglYqNMiJm2zgzyMx83VLhxY5NMPNjt3NdRa2vZrdjg1IFx?=
 =?us-ascii?Q?YbRpvA2oO4My1ZEVdmvXsqIod9DLCP2UzhgssAMf5xZA8Gb5fm+ZwNl3PciE?=
 =?us-ascii?Q?aICVBY43m+tYIr6QjHPBjlEj1CZ9ydb2NpX6GMButr4OT1e5Cj2EUOXHTTDb?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1M6NQg2fM/8JNjTZh6zFgmGG2AYRJmFZOkDZndex2qnJQIk9+3/N7CEj3GSMVjhUwWEF8eaLB9oXsns4TSMEgelfIoF9De4nDvobVpzc6YVZdadoC3qN8DrJaHgE3Fnx6Z2Wutg+B9Ny26hkHZPdYQSA2oF8/cODKD7yiDESguLTh90YvMJouLUDykR5W0hNI/pU1f7GCpHi1J479zS9GRvVxVWtt5PXbnTIq3h5jMrZPPkEeO386uFGC5cJm11XTOHaZyE8w6Z7kW8BfE6wDX/Jv+eOzALbCdwn4eWiJvkWYMIzTSpfkIYoVe91k1dkGGb2ozSFlam0/q6/1+1KvDoTneifbWlSc6ENkMCusv0uMbTRWQY0bkA6OoxJdB6/ff9GNREi6NDNll0ThmAzWP2sMuOpqJOCreHD576fLtZm07BKvIVl0njYJASyDWY7JALjHnTbkYMyyC9OGr5OZl7SCWHDdARzelK5X4pyvXwXWDe523LWl6vT5YqcqdDU1UOzdnRTzWTpxiBo2itEgKMDzIHAWt7RgkXEwxjKtLCP0A4JnM8xv8F67gp/UtG0474j3oH5Go/wGPv463zripo8yMiHlmgecUst0vGQQM4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92f3a222-75f0-4553-b1c8-08dde0c38f4d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 15:01:08.4928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bY0yCr5H2uP/1wzovGnK2wPmmfZvEgGR9OFLSqgc4KZRR1BkFrSulEagzRkvp57BmKQPpou6ejOeNZ9dext7YDSTispqj9CEbfCA3Evb8c8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6534
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-21_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508210121
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX85iuU/e9GbXU
 bXCMFKCVSTSXFSGRiX+YD//x0GeHuCmvsxkDcc8gMA0+xAy+jKyVRKluDVqiWw+Kvm/yk9hRPpE
 tHqxsRpxUUuCjgUVlZRlJleIfvhk6hmBCrrO9whNb0OGLH93pJtszx2r94aG51NncuR6Q1IOfER
 KPV8wg6wq/aHeDs7Fz4ITvawXNAsBLDW7iLPlW6InrffUFYMoHUm2b1PCDipe25/ji+Trnov12j
 48vCIU+Rev46anY20LXIP+FcfTzs71jkhh73gRnt+5DuyYqUPSLZ2Lq08TnJtFmFllqfsgNCoSl
 0k/uG6v13YkQfRaq8tqcx73u3TBi38GhUmJym5jLSCL1XvURarEP2sx4lv+QsZtFMwsVVGRGOeF
 nctbJCjGkYEZXDhMkdfvu4CkVXY+OA==
X-Proofpoint-GUID: JQYkiDjSarl0aK9-ARo1ie6O4IqH6EXU
X-Proofpoint-ORIG-GUID: JQYkiDjSarl0aK9-ARo1ie6O4IqH6EXU
X-Authority-Analysis: v=2.4 cv=V94kEeni c=1 sm=1 tr=0 ts=68a734be b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=55jzWK8lyJ1rYz8bVmQA:9
 a=CjuIK1q_8ugA:10
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 78978180013
X-Stat-Signature: 3p7nocd6scwgrrsesje9qx54xa7hupjp
X-Rspam-User: 
X-HE-Tag: 1755788522-56805
X-HE-Meta: U2FsdGVkX19Gm+IVUZLmu/34z8R2Jm8FBGCWy+sgxmu1p6iBY9uUINUSy9vsCRB88wsrExOztT+nR9DbOI0A1fOoj77m+rTnzzAPkkxr5p7GjMsbBu/Cd2JE+vZFi4cW9fRG6mzbowaOtJ3LXuM9219EwAh1mXN1aU9YfhxvbxYC7npVem5jxPLi0ZJmNVc/+qpO+J/UiDM3daCy2z0JFJ56hjSn7n59IIHLD6hiNc4+9o8BLd/v6wQWJu/5qE9eoGDY4rtZZB22Fox/+FlmN+b2F7Eey0dETD+w68toXVXyJhzSJAApNzMQGR65RLudPM3EPVZ9y33PN2Z8+NUq0kW5gV03JwVYu8o5hPGZKkTiywUG10dDiotC5Ccs+mY2aXxy74eL0nWcopHpH8oJrr4sU+kLJxYpQGddb51Xex5dzBlUVt2PfHFeSdp5Hcb1gmkOfPrU2gy+Dg91XDk4zuDLN9dv5NiQfGv5ArBCunf5pYt+3gMOQjeKH1KIOl8o7WE5Ql9ct49KsFhhyoFws7wjdWiEnwOvSPNIh/MweFFA5wI9TGN2/R1uWbf+E19v5KB6yHpJhzFv3bvJUXK86xs4/Wz2UZYep+dQjUewaPfYMxQtBGSciJu1fJ9tJATFjzit/bz4wFwbi++WUgATbFAeHTC4cZ7FbmIKVASsZdYdat8APPoqsNBg/oiqiy0U/ngvuJuzgBaaEhRfn6S6r9TKmwkLQV0cr4Pm4FU+FzTZdW3Q069SlNohnTCrm0l+IaHJCbj+bfhjwgz0JiFMsGplRgchpbB27RBfJ7d6bzIqlQQs81GxcbXGMMfkjwIqh14lPb1QHQxNjP1r5Pt96Vz5/WSRQcK2PabsUFULWoG65Q8cTdb286lmMr+a8OHLU9AF8XxZg0zq874h9PrfLiWuESX/8vf0sB+W/+XhumoJkwv+2GHgwB9cR0lxjvRsxHszChbQJ6CUjGe16Zj
 qKHYYhSh
 LlZjrpHueq6pvYGLhTxjnIqNop6fj1ONfxVTxoczOqelnrqiyzumN7hWIApHKwLKl2q6stW1qhB9bzdDFGrH5rAj8pCMfWSEhIWS8CrIYm5ef1StwGFes7XM5db+e+6hSY5yFj2k6z/jxQrV7pZgWlsbbjBpuGp+sPfz3UBqMSzRzg3ioSl7J3cCxxJCA1AmIs3B+VTfFVv6KxHuJ4Kd0pI27+Sm+cdhF1vNUjIQvteZ8ktdBsyauuPAWxWUiN90IYRpoqM/pnMtR59KM8VZKoNqsJxLggDjrho0zooFd8CYJSYKxqpZbE3uafqPsgqvqesrHTmo8SuLjuWm7TAIpwsMU8guwHDsJSkgm14sdWvBg7sRl2uk5Jghb0D+YYuEdd35YXOOzI7x349bop2t+fF5KEIs+x4q0lw6NIuSVLqo0wVl87qTLG3hotpIXqkefcHp5PdP0x/F1AsR5VM+FSDHAnbj0pb/x9x2kI/Wzy3cGL+PAThkffSsyaapgmgsP9Bqayw1RzxglULI8t47Yi2wVaznYwPFekWLBYDAmK2u9+bOqFUDDlYDn1VDJn3Nh+wXUGdkyKkqjTj21p5MJJKr9j8vpNkLCSbhODJckFxiI2ZYP8NSqMXfOpdnhUgW6R/u7zfQmhNrV6d6kmjd6YQPaYSHuR0E3oNFX1OcRWSMjpkD7K7ahUmJnzjXIPG6cMCW0HM3vTHwbTYkyMm5IGOX9SVl0bAjOSHgLLHM2sRisyxlkt7h+GHLGeUx30myHcs4KoZ+SoIoI1G4FAyA9NoGaNo8M5Php6N8i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OK so I noticed in patch 13/13 (!) where you change the documentation that you
essentially state that the whole method used to determine the ratio of PTEs to
collapse to mTHP is broken:

	khugepaged uses max_ptes_none scaled to the order of the enabled
	mTHP size to determine collapses. When using mTHPs it's recommended
	to set max_ptes_none low-- ideally less than HPAGE_PMD_NR / 2 (255
	on 4k page size). This will prevent undesired "creep" behavior that
	leads to continuously collapsing to the largest mTHP size; when we
	collapse, we are bringing in new non-zero pages that will, on a
	subsequent scan, cause the max_ptes_none check of the +1 order to
	always be satisfied. By limiting this to less than half the current
	order, we make sure we don't cause this feedback
	loop. max_ptes_shared and max_ptes_swap have no effect when
	collapsing to a mTHP, and mTHP collapse will fail on shared or
	swapped out pages.

This seems to me to suggest that using
/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none as some means
of establishing a 'ratio' to do this calculation is fundamentally flawed.

So surely we ought to introduce a new sysfs tunable for this? Perhaps

/sys/kernel/mm/transparent_hugepage/khugepaged/mthp_max_ptes_none_ratio

Or something like this?

It's already questionable that we are taking a value that is expressed
essentially in terms of PTE entries per PMD and then use it implicitly to
determine the ratio for mTHP, but to then say 'oh but the default value is
known-broken' is just a blocker for the series in my opinion.

This really has to be done a different way I think.

Cheers, Lorenzo

