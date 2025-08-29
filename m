Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E003CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 15:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B3C46B0012; Fri, 29 Aug 2025 11:41:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98B9D6B0022; Fri, 29 Aug 2025 11:41:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 853516B0023; Fri, 29 Aug 2025 11:41:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 735DE6B0012
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:41:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2F143BAB0B
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:41:52 +0000 (UTC)
X-FDA: 83830210464.27.BFC2185
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id C037B20011
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:41:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="OWKOg/9P";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rxIIGCPr;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756482108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EdpHuHn6Rwf6fHuN+40uxJ6J74fltI+rH+z8c7vEeDc=;
	b=Rc1qdnUN3WCZsQByCg12LA3hctgjjEqCqHdMWWXq/8992sWYlv51uM9wX75n6pKfgZyIBz
	U/sy1ZZSJRF/fvzMEbKVXqG5QGq7xk6e5cw0/8q8b+Fb9f0saMwnRGdCDTDaOFPBxF1eJ7
	KTeJn8kNaDwk/pWbON7p7WNz06IeXNY=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="OWKOg/9P";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rxIIGCPr;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756482108; a=rsa-sha256;
	cv=pass;
	b=r196eI1PgwA0AH70rjFIggGHjRyQtqag0I94ObY0MDPgw19pzlZbEDxBygN1bW70h388fY
	3LrUVT27uhypkJ6M4MN3D7XEt+IPZtPZA0DEuh9LDOOP170Y8l1qJToqrPazpQJ0z6+ruO
	6GRSQuERVOs7Y13cN2iW6gmWL7eJ1TM=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TEtr9u006809;
	Fri, 29 Aug 2025 15:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=EdpHuHn6Rwf6fHuN+4
	0uxJ6J74fltI+rH+z8c7vEeDc=; b=OWKOg/9PL211amYp/DYxG0ar7XD1asd1po
	w5oLU0pbKim/1UpEmxkNccUbYXx3EBuJGsha9Yb6Kzi+TsXXHrqCPls4xOKuuqvT
	cf9oqJLzHlTIX8eGduSoZzve9g+FTWaNptBiRZ/etC9h7h6onqdJgDOaXx32jBZp
	xp3rNNNanCxSHbcytzleS2Av31YAcwOrXZHn989TvD3Ph9PwEegyIYImtoKAEImG
	86C+lH8y0M1xSf/0YOCWWp/PS6WRt5srCIA1AElOuBJ7ypgLwl95I/K/T/IZj5Cp
	lm9UI9BRzF1JqXktp1ky/8qxqHcVI1zwT6WekOwb1D7EUD79XhHg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e2av78-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 15:41:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TEBSvp012336;
	Fri, 29 Aug 2025 15:41:37 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011032.outbound.protection.outlook.com [40.107.208.32])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43d91k9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 15:41:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uZ6408WMHaCNIHKBCARU4016QJ8XuhfvhP97AaDnxj8fveVJFZGA6fSGImbxW4j0AWvgv4ud6jkBx3safdEf15/8JqV9hnAhtW1w6TErLRyJmgcizFyaXUdPxGUCSTsqo+Vg0ibValy1+uh1Ak0sFrPWK7CyVgw35vJBHugGkz1OQ8pCkyU2WLAirSdYwj+Ici2c+8De2cmaXRcBB6R7p1QGoCoP71kJrqHj8mtziLf083C48oM0WnICOr+u/Q1mq2CKP0ETgshh/n41DVNKSRoBiggdyhIDz7rFMXnjKcWFvsg9wuTY7iIwVFWBbwvhwqjpcPQwzbeRgGvG1t1k1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EdpHuHn6Rwf6fHuN+40uxJ6J74fltI+rH+z8c7vEeDc=;
 b=WIHR02VyD8qCAOw4pOpvhT3g15Aj89POxAGZtBJ+3cjdClfz8M/b8Vm6/2ciIi3vZ+8/k+XV20M+JL8slI8IBU4Nu50jb/Qb+NMBDtLzTaJBBUAjVWuToF/Vu6KIWyjHHJ+w7ONj8g0oZhvct/UZXH9U7lczfqZpLAsQmB5SyDJuGDfJV6hfGOLqCYhk5umDkZO4bppUs99jVC+7Dv5w096zzjifb/4skxs6SBJFMNKtc6XZe/OLaw+N0G+Su4st+REOvEFKRIFQWZGOuXlUKAMbh4btVlJ2lqoFuRrnwp+1tGOLl2UDCOEvus03C96nCowibvVZH56PN2+X9LQfzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EdpHuHn6Rwf6fHuN+40uxJ6J74fltI+rH+z8c7vEeDc=;
 b=rxIIGCPrldx6MRsGwh3rTtvsALO5ay+Z7bJCPiQnRNXwbZ12c5Cy/0HVFpJoKZG/YbOEL0TRqg6Uo2tKMQO7pR4TDLX0tEIHd4x+hw7FAte+EvhrBLQzA+dW3ca5rVu8hrDuyLk7rEVMmVEReUYIWy8kVslWdPPDqx/0yXIRJPA=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH7PR10MB7694.namprd10.prod.outlook.com (2603:10b6:510:2e5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Fri, 29 Aug
 2025 15:41:32 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 15:41:32 +0000
Date: Fri, 29 Aug 2025 11:41:28 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        Kees Cook <kees@kernel.org>, David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] task_stack.h: Clean-up stack_not_used()
 implementation
Message-ID: <zllb6trx6rbheykxoj44bztbxzumseiedwwvyemv2y5vch2w6l@igkejk5b7qb3>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Kees Cook <kees@kernel.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250829-fork-cleanups-for-dynstack-v1-0-3bbaadce1f00@linaro.org>
 <20250829-fork-cleanups-for-dynstack-v1-2-3bbaadce1f00@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829-fork-cleanups-for-dynstack-v1-2-3bbaadce1f00@linaro.org>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4P288CA0044.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::26) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH7PR10MB7694:EE_
X-MS-Office365-Filtering-Correlation-Id: 448aad24-2ad8-402f-6597-08dde7128766
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8we8jRaTTML7F64gcmYQCx6EeYr/Apa45TO/e+AwtIimBu1lOAIXRv9NuzCb?=
 =?us-ascii?Q?Sh+2x/WNk/NcnbcTfUkSUSwsK/H+bMWnfNKlTFjlLXiui94ZmwAdCJz2CuTY?=
 =?us-ascii?Q?sfUCbyEm4YDGPv3Bz3xU+MP2JQgKMXFL+pUSyUCA7GRqurHAr3EdK3CvzXzr?=
 =?us-ascii?Q?50AsehzD18Cu4akbuB3AWE8H+YAwX6B6Ish6vwIr14jIkzh9LqQGKw1ZcIo6?=
 =?us-ascii?Q?BsLy8y4CXgEfPcYWpykq6B3ZxmQO5gA8eQ0tSrg8/vdawUyR7ffVz9p2+JuR?=
 =?us-ascii?Q?zaOtLPxX9k5qhzS+/EDsTZgPWPzd6+blWyqNSahWby5U3WeaFKKaBx9aK3e0?=
 =?us-ascii?Q?VZS0KaRpKvbDGIQRo6i7HLn6HYcpl5yW6Sy4thHqFoqE5vW7FYfjPO1NHLtq?=
 =?us-ascii?Q?+ZiWUFfOpxScaGB6UCgTKN9rdMl0hoyG6iwVL/+7rwAu6xRCMupFpvjv0l5p?=
 =?us-ascii?Q?/LLmMEKSwg73EUv8McG4LqW1gmd0Ty++yW5QkjZXzUa4q4UYZ8uiRfYTuouY?=
 =?us-ascii?Q?65wbvGqYQYEjmpd07T8NNMWhQnqVwrdJ/WOcTxVFlaMjTHLD4qQ/rqpndHO3?=
 =?us-ascii?Q?Zw/g+B9PLIksfsfo9d5Ys9NLTMMSG5Vi1LbECNIZ+QE+KGRQ8kPqZtzE/HiH?=
 =?us-ascii?Q?J4xgK3TnzYZhklmrf1Xe5Z/1GVfG0hLcBNzH813lpRG3VEEm44WY/UXXxirM?=
 =?us-ascii?Q?mZVfplZjCfloj09+W7g0xTbysKoqC4rNe+EdStBOzi+NJIos5QCFojvfV1G2?=
 =?us-ascii?Q?W62UkXZxEFHc+NAR1uA0l0jyhCySI0c20J/bGBylS9S9xoOX9dXc7U56rMUD?=
 =?us-ascii?Q?F4VblhsesZHir5obnMApxPVo6Yac/0Z7QwPawXPCsprN/oRWY3Iv6DtqBJyP?=
 =?us-ascii?Q?CyHHmyHUfdfJhh8+RFQ5Qs5/vzP6MPO3HrpGJqaATIf9K5U3zodamCmp/wmK?=
 =?us-ascii?Q?yMj66U42egLQOYWcz9RSf4m4HNLr/fO1b4Cjph3i1Q5+YRkx9sdcJuYF3/8i?=
 =?us-ascii?Q?Qgl+VL4883gzLmcBg9nCH1izIBJ2wrByP7GpVTBGHsohJcwNDkHYkiLTwImS?=
 =?us-ascii?Q?jgvNrtYnAZ2ZWz+GT4h665jYkQb01LnljtJ/nt4Ao3khYmyfC/ABphG8Ajdv?=
 =?us-ascii?Q?I39V/KwPm+N+9ypcX9kuc9aFDgAOxFT2u0IcHqLjmjwz91Xr0rsG8yzUWz9T?=
 =?us-ascii?Q?kBu5zj6J2uxkTOmPm/wGRQtcIBlYrc1axwa7NN8B9lQulRKM1I/VL030tgpO?=
 =?us-ascii?Q?8ku3ZZqTnYioiIPvU7hQsCZS+YPvnd9ueUwU23y6w0+SruHtAM42BFcw+Sw9?=
 =?us-ascii?Q?qis1lCDbCW1jsMVJiEohCjOyaUubChFAMXByfRrCF+XhUOEqehEp0+jbRwUj?=
 =?us-ascii?Q?d3tuR2+AJPnhF5dyM97AnPM5MLtmdY5IXabXFIyfVIpxKhJc2r7eqpjhHEPT?=
 =?us-ascii?Q?iD6uFkUyEig=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?77fw743Zw1RmEFjqIP44fJndGu6SApAJqjw42pgX98p8ZPn5u+OF9KCzWE/N?=
 =?us-ascii?Q?kCLU/wtpMHd7nzPCV+VevhZ2UfijQF0TV08CTAGzIKwjrjUI+fNZ/Q6nsJd7?=
 =?us-ascii?Q?7riyCFhfF2Lwu72v6d5LXC91T+ikDxGFAPJjZZoTf3V+Y2ILPqrdmh9hAsL8?=
 =?us-ascii?Q?ZipcETjA3DnJB+N9mYtHmU2Qjo7Xxp+l0PyLFFfgXN5P/xTKszZg5fH/SId2?=
 =?us-ascii?Q?6zPKg2W9CBXcasL2l3seHERmdRZWcNIykJAku5VoJJis9yYjI1MoB2em8K/L?=
 =?us-ascii?Q?DKl9mhsFySAz2uWuDECh6yZQszZoj3E+wtG3lg/WTc0C0OgCEmG967j8r3kM?=
 =?us-ascii?Q?ATZGD7uMzl+sjH8IJShFtqEL79SOvF1i+kuWe/7WXHFa6u0TwTGd1FEym0U4?=
 =?us-ascii?Q?1kWax326JNpWwGtmqV5qCzWEfvF8krYkrj4lXb4qkNHB8k6CxmySy4cRxfuB?=
 =?us-ascii?Q?C8asCsN8dn6GIVFqwqVtXuBqVQQOQ5zBCp/zeQINBV8QtICn12z07mwNFlTb?=
 =?us-ascii?Q?oTe1oddvL20a5LghckEegZEbBJ4JkhTxqo+NM4DW4F0ImB4NQwCmggJ2v+Xn?=
 =?us-ascii?Q?+ZszkARFog5d4PFYOx5PFgx0d4FncXAiYpn0C8fa3yHRrZkAUJt+wNmoYEE5?=
 =?us-ascii?Q?nu7xkVWVyuUKVMidXKDuePaFp4SOohJIUWcjAHLkw5VnCQDP8gv6bzKYlahQ?=
 =?us-ascii?Q?EcOcivA4TWZskUw98HfIIOLHVGAz1B9V9kQ5X+IG2aH9Wg7yTEbqBdmNntWw?=
 =?us-ascii?Q?Yd9cUg1L2cJLn6UeuoHk015A7lk+DFy0cpZL6mgPlerZs/Aq2fXfWiot9zpd?=
 =?us-ascii?Q?z4nHKOnCIARMUcu/+N1PQiwZlZ+XlBU8f8ucbFoOHlf4V9U3dgMCV1QRE02n?=
 =?us-ascii?Q?QmEDA/W1y8K5jjkbI5b+OH4N75CjvJiJXeNAXzA36Nm1yxm3PvX80ACqjZHg?=
 =?us-ascii?Q?Nd6vwcJQfDlzz/2Y259nvwGLRdXLAfnZ5GkicmIj4iEp+RN+WZPU6leSp8yA?=
 =?us-ascii?Q?byg9tpgcZsNL3BGO4LX97btpoMj2fZZ/ay7PZeQbQWe4P30lyA5ucVE5Ep7W?=
 =?us-ascii?Q?sSETK8/49Qg9B96tIG4/2lISMNajTuyo+JgLyqRRpUlOUcZvFDGWP1doydrb?=
 =?us-ascii?Q?5cPoyZFyioLbtD3Bzh5y26Qpj22jkru1VM7bmvMS7hMF6HXXUG/sxx58wCiN?=
 =?us-ascii?Q?UBTnNkMMXvbsbX9fyRzw4snMUBtrteFe9e4x4l+CNXBlyIQ7IDM7GDNbBIBL?=
 =?us-ascii?Q?89FPj+sZA4GpZJT1IIyd0HU0L75RFUJCFMqaZgBPc9u8rGyIyGEn4Z/XWNKr?=
 =?us-ascii?Q?GqmoaVKb6Gm4Y3lrnbnpEd4QOptZuz6T/4+NR5rmho+n/wvzcHtbpSEEaxHl?=
 =?us-ascii?Q?/3o5wygTvqnvaZvzwyMmxG8X0kPUZzECSe4eQnm+gPBAH54CbrBV2DPwLyVY?=
 =?us-ascii?Q?pHrnb1Sauatm5xVw7IJl3ymenNvzRKfauavZBpsvjXkj9KN09uaVUE4vn+pJ?=
 =?us-ascii?Q?4bbKxrUuCo6mL/r0P7pADNNSVZyKVZK/t1+oFp6rVmK0sDiw0a+pe1fPdfId?=
 =?us-ascii?Q?izVJfty/v2bgSx7c4Pl1AeAhfoZWnPRGOolMox7iBSov9VfnG2UYqJlsg5jI?=
 =?us-ascii?Q?1A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3zQDQvgngxYMIJ6K1+BJGublnFVmnbgBfv+4YMM22W+XncSg7vJQf62S4fHStwfl8KFALXRfSCjRHHnZ2+JPevd32Fqso0B5dQUi/xkQYCx4HwwnC+DzqF7cK4b62fM6WK2JuT44+2IXE6+HjFRx62scZd+hDnsMXtRbnZzLJsluAwEC6Q187cdOqDSTAzTFwTGjq7Jvzp4hAV5LqfBe//ymiqs2870JncYhFgeikUUhmjvz/5VfR6G47SH0fTk1Tzpw3Nvv1ZyJlE1gkU6LRQ17/q7lMCxeVlY1Ncz6dnH4fKBEpdshmPJqIDDxqVYfzMNjxW6bWTaupQuGzofQh9WTVrkxjkpaeFHn273ZOt0N2zYB0lqm40NEgKH6jvZBaSZGMS7cTqFgPmqvG5dwK2Pavxiv1bdlqvBn5dLysUUJb2IB/u0CgwcIDG+rSBiEsGSLOOGWgUnwGm0OhpamWnJMhqpEHeRteKJutWTIPBcAYEvYT6amJxKsU4uPv+ancpMbLS/DfyO3PjZqj1/izC1VYfMLhRIScjBgRHr8bSPqIxgla1Xkguc47dBh9V16Kk35fTlHN7eLMsAuIDPdnhu9+W+bahJYM0QmEJLEH80=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 448aad24-2ad8-402f-6597-08dde7128766
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 15:41:32.5144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zHiv6HsL0wQIj0HjteFiYVCpStjoFwlOWiQsklTALu0g8L94JdsKgzE+V5j7/fMmlKOvR7DWkPFibyQngxYjdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7694
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_06,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508290134
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfX06ZGRS7CwI0z
 x6MmGRgH4cHl/16dZFkp9yNb3QnmwWAIeaDfafypPxO5Aa9LOdmhwPTR2i6wQ1TeiSzk09cpOMM
 al72EsafmqUhmFtoEukMZKtULDN6fNH0TYEOg0neuyhXSVAS+dTo1g7EgOXPKlXyndRjDn8HAW2
 bVWCCmcNBWhfYIvIqHqNG2L6/xMcG4QQlEz9hXpPFUWlCkucUNNFoOxDc0f2QgUrevO5g+AVXAJ
 +4WUHezoL5DXfW9sejpaVHGPEV+YYYbEidyD60/JPevFTGJmIfWHdwjimysnlvki32C8LViyNQa
 7nqNpmyugXMffOroXLfVyhI6SeiCAjGS0WpziksAUP0s/gy8k3MwS+xyoWpPKBaRcUBhtkxwzdd
 zAtRhbaeOrEmbpkloDmq7xfWVgvHUA==
X-Proofpoint-ORIG-GUID: YXRLB8KcAgCdAr7KVKZyvlyc4uq9J3Dt
X-Proofpoint-GUID: YXRLB8KcAgCdAr7KVKZyvlyc4uq9J3Dt
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68b1ca32 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=7ipKWUHlAAAA:8
 a=KKAkSRfTAAAA:8 a=yPCof4ZbAAAA:8 a=-qKUV0opkMw2jbiCCzoA:9 a=CjuIK1q_8ugA:10
 a=gpc5p9EgBqZVLdJeV_V1:22 a=cvBusfyB2V15izCimMoJ:22 cc=ntf awl=host:12069
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C037B20011
X-Stat-Signature: 756d9un7wz88phrkam9m4hpqikwdcwni
X-Rspam-User: 
X-HE-Tag: 1756482108-758941
X-HE-Meta: U2FsdGVkX1/0MtTg2CW5kwK+OZLZpudX3UTdL0W/y3+2XyeDax78oeVt/FBPcpORprhhTaCecOMhRA6/0GUOy9zHJu768eq0UMyFP/WggnjLNXNqlVwX4TVzy7kqQ9jAsIyCWN4A7lBhdGhZmCDsVtcydlCfu2gywp3549dA7MH/AtuiF9DOnR+++14aeAjwwOdFHDmeRP1vjH3DT4fcY1nx7Im6OoTmjbiWccYFB8u/9gRLHIBDh836Wcu9hglxKCRtYd2XfXn+kN+YTFHk5asX7o8mDuOjsV1s5RNPlDjdvY0kKBf7EQs0I8HMqhYuJ1RTKzXqLGNDVPE6r0wk/sg1UA6PaJWbAA1WDNnfJF3TLOnhOLt3WPFRUDltTpucDtvMHivKjf+Glq0nPNK6/+7y+I084OtcPg6cJfQRt9hSR40ViAsp+75T2LtAT787nL8zBNrf8BQi0ZhhZgihq063pi4Hz6fHldbCuMH7tekygR3FuZMKkQY04Qy0M45r7yIP9GY5cgBj6sdkjNrFnpxbj4RmuhXU8F+BIoBGxxIEMmA3bPI9uOeNkte+NAyOOtOhsgk2Pqcd6D1AttEybf6k58wYVfOdoujD3YqjVWcP48u62Dck7NBfLC2lSYBr/JhiqyqGNpnO7klWtg3bkWFOIPmPv23yloG8uJRUr40wo7dpzqQcVmT13u9C84foxrJuDtwbJD+lbqP+tbeqvBqEkaWF4YA569BUurOlzUP0fcQ+jZ2xEk5unSQH++pVr2BM/DZ+WIWBA5gpyUh3qzAtZr0qPVRQIZSU3vbFeH5pnqy5FHqwNfEx6imkE63RQ0tG1epI61on/bX/2a7+5YS7d8qDynZHmUOoxGHPai784sG6INI2urAxAYIEB9LfsZCTb3AEs0y91kBQlGPdwV9PhvwdMN/Xa1QwxkHdUA29SeongnGvB6R7+PhTL7yCGU2c3YzdZuFL8rZo57K
 27UUXAxM
 Jw+VECsEabZ4IrhSyc3t1Kd3aIsZiuU20lliceJYrabfH3T9bk4lybdF+QvjAHSkAVcx09EVw+zgMWbBPnfCwXdjTp/eUftCa+dzOb/Quik+LcqSaAb9Tt31vRtlAyynBH7Kv1ij+jk+3bPz2H7OTWYPCccDc6EvbnOgmhpCZH+2+yfAP6wyvGfIQp9l1dzAHpi+ZTFYBhCPxylQdahGhjzJH2+khzsgcEqUw59GbuSTloS2KyWc33uXjyvFMl86Zejm+fsDi8BjhpIDRJMm550d1gPwXAzBbxMXaiH3KfRjtzOYneC1+ZjDq0f/jcZbIzaO8ugko/arnmXShxNFR5wLjOwWvIdZ93cNEZHfHOIg/vMXujNZpX07qXj26EM9RCfqzto0J/SZdI20pegvQWqzq1l9nZftI77soMFinPQRMYyXTviCOK+A83C9hA55RdZ6ilp6zZgmDKSt2YJG0FxUPxDTKgC/Ep1710pjGIJTpzCMXFSYE0lHmilghxizspKcS/Q+iCSKq7bt3kNsBKNcpO1C31n0U2FcR/LgmSpLoH7lCwd++G8yLpw0cVHLQAaNy7cbxFYTYq6whryxevxfkw2T8ivF3vVmoTQ/UP90PZqWk3AIqpCUp/zr3x3lRaZHTSXY8Z5Px9h2h30YnVePF0KVvI58IsONxNll/EAYI6lT2bqYoa8CLzUKvxIPfJlzISKtFWl+33Tu3+VlPGDhtB3ihM33gwFyNj+a958hYXvDD/Xf0HoygeQTmWv8htGUaI+oHi0Iu/MAHhOTSKyNQwqX16spMxxrGARLQkmHa4/tMnRBiSUU2GiuumCRVw9g0ekw6jESNgbJwrZEvIXX3ActAzMgjFP7i08WgceCBZmlQvSDSk57lV5vUh7U9T7li7wxxyfTvvw12a7p4Fno3CWbU8hrv8YKW3to40EO5KcSFLnpHW+v8/Zx3eLBrq3QNX4rb0Tb3VzQzFVkxrON4Zw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Linus Walleij <linus.walleij@linaro.org> [250829 07:44]:
> From: Pasha Tatashin <pasha.tatashin@soleen.com>
> 
> Inside the small stack_not_used() function there are several ifdefs for
> stack growing-up vs. regular versions. Instead just implement this
> function two times, one for growing-up and another regular.
> 
> Add comments like /* !CONFIG_DEBUG_STACK_USAGE */ to clarify what the
> ifdefs are doing.
> 
> [linus.walleij@linaro.org: Rebased, function moved elsewhere in the kernel]
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Link: https://lore.kernel.org/20240311164638.2015063-13-pasha.tatashin@soleen.com
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Thanks for this.

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  kernel/exit.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 343eb97543d568baeb23142edcc9050a8b8be8bf..9f74e8f1c431b6aa6e391ff71aadf9895a3857ae 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -780,24 +780,29 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
>  }
>  
>  #ifdef CONFIG_DEBUG_STACK_USAGE
> +#ifdef CONFIG_STACK_GROWSUP
>  unsigned long stack_not_used(struct task_struct *p)
>  {
>  	unsigned long *n = end_of_stack(p);
>  
>  	do {	/* Skip over canary */
> -# ifdef CONFIG_STACK_GROWSUP
>  		n--;
> -# else
> -		n++;
> -# endif
>  	} while (!*n);
>  
> -# ifdef CONFIG_STACK_GROWSUP
>  	return (unsigned long)end_of_stack(p) - (unsigned long)n;
> -# else
> +}
> +#else /* !CONFIG_STACK_GROWSUP */
> +unsigned long stack_not_used(struct task_struct *p)
> +{
> +	unsigned long *n = end_of_stack(p);
> +
> +	do {	/* Skip over canary */
> +		n++;
> +	} while (!*n);
> +
>  	return (unsigned long)n - (unsigned long)end_of_stack(p);
> -# endif
>  }
> +#endif /* CONFIG_STACK_GROWSUP */
>  
>  /* Count the maximum pages reached in kernel stacks */
>  static inline void kstack_histogram(unsigned long used_stack)
> @@ -856,9 +861,9 @@ static void check_stack_usage(void)
>  	}
>  	spin_unlock(&low_water_lock);
>  }
> -#else
> +#else /* !CONFIG_DEBUG_STACK_USAGE */
>  static inline void check_stack_usage(void) {}
> -#endif
> +#endif /* CONFIG_DEBUG_STACK_USAGE */
>  
>  static void synchronize_group_exit(struct task_struct *tsk, long code)
>  {
> 
> -- 
> 2.50.1
> 

