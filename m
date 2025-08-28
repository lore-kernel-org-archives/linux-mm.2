Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DCC0CA0EFF
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 01:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9F5E6B0027; Wed, 27 Aug 2025 21:58:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77116B0028; Wed, 27 Aug 2025 21:58:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3E716B0029; Wed, 27 Aug 2025 21:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 90AED6B0027
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:58:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F64CC08DD
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:58:19 +0000 (UTC)
X-FDA: 83824506318.09.AF71243
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7CAE8A0004
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:58:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AYXRK+Tr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Fv7qTN0L;
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756346295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ATXXedP30WgggFzkK9CgOoh79zM0aN0fRS4PHqKpW4A=;
	b=JWsQsFVNOo2aDrUxVHa7kqFVRwuQjGMdk2PDcCPIyX4niGFfy2wZkcdAtihqC8ZA63kJyG
	XDamQL3JCKfvbkM0JUVYyGWgCH+lFvXGXJh1YIcZKZ7hFwUnqAoYQq8zHeDEzgQE1oW7pr
	ZUANPss6XJ3AYSEasYezI1sdSE6C9Mo=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AYXRK+Tr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Fv7qTN0L;
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756346295; a=rsa-sha256;
	cv=pass;
	b=bTGB17jLNdhPmjffgaAJ/QQNDUXMSUoz8VeuCkhPywPphdLNVTWdKwHVt1TURH4tGOqgP8
	HXlrr7m8yw2uoNsZDc1lzwHodwjOrBYYtyxL/bCM0zHH5BTBKhCe8NaN/7j+Fo7Xfc5gnB
	U9BoAB+ECbMPaTmBYCYeCOR8JOH2hGo=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57RLHZQA005592;
	Thu, 28 Aug 2025 01:58:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ATXXedP30WgggFzkK9
	CgOoh79zM0aN0fRS4PHqKpW4A=; b=AYXRK+TrxUyujDc8XlKRspfET1Zq18ljFE
	Ro8dwkYlJuzk3y67GYRKr9cjhidV80ySYOVf6MXaiMOEQ4+o3zQ+v+guUeYGahP6
	qAT4CExJ4KvaGNheUkS7le68MfGZWJLGIGJG+pd9kHDJ4mvV+ajAIkKBW87pRCUF
	QZBm2liibjy0moSb8JPOOjGyhIZwFICYQGneVy6cjqd6C+tjvD5Rdfd9/NFGX60I
	LZo7TnUYUBkqlyKD5RxTHoJOUcsdgKy274aoj+uMnb8qyfbIpXT0OAwku7JXFGPL
	4y7Z2VC9F8tDxym3MS/y2c27okoBa6yigDpGLkyDzcijXHfL5rDA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4jaqm3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 01:58:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57S0GJE6019578;
	Thu, 28 Aug 2025 01:58:08 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43bctfs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 01:58:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W8K/AOwIyaNiVt0uCqWoCUZRI2mFFrmeDicEcGsUwnSKxnN2FUIm11qw+cpD83ZYp+uf3jLNZ/NQSyC314MJPp6EHfCSM+XljXsdjmOb9qudutCPpBjodCeJjqe8Nr4ZQzdcrijWCl6tseHmQ9ZHCsg2k/RitQdlxhm/cVWGd5JKV/HCgAg/1uxjjRNuhUXQIE+Wj+Liw6RsVtv06TWxXUo8Eb72NiSahkcXWLAn0WPgnfpjiCfKJt8P/pWHudV5LB2CAkqfH/+6BDVvpPTKBH5ZX5gGNjj/22c841/2Lu8dHsTNnU3xTV8u7Jy6917FKDxr/d8XT+UTMkkWe4gtiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATXXedP30WgggFzkK9CgOoh79zM0aN0fRS4PHqKpW4A=;
 b=rWE9UUwLB0BO7iOhi5eTpF4ukK2w3VOmbwp66RxPuSHNC+MnU1qFo82u6mXE/unPAJMbVaMTgRtqjzo3v5oD3RudpePuaONPIA+E0bIFsgBOfMEp6W2Hzm+2s7sNL1ijsY7j3WKPch8f+6uoOl83LH0FyxjTHqaiRXAUKTDzy4nA2jKi3KGmNDqDU1K5VeISCWVr355kQWB6CBpuM20REls9Xq/r+LeSyTVVEJWS9Xo7L8k9rj4eMhgi3u6p6Ju3HXux4iAmfQPAO6JcKawaVX9A4/d3wmLzB34PLlLzF+XD5hOpdfkmeZx3bOlaRtq3Q3DJSdCRZDyhTnRfMoC0Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATXXedP30WgggFzkK9CgOoh79zM0aN0fRS4PHqKpW4A=;
 b=Fv7qTN0LbfcYz+4JB0IaUyzNY9BOVKhAG9WONl2ycIf9WErAzKqof5CJI5+SKGN0qQgwzGwdFGMgNtNykVO10k/xuMN41V99R6JNkePS/8OAebyMUnS252XGLtHcaAwXJE/GBBg18eew5xE2zMlnhyoTmR+mowt73yWPVXT8TH4=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB7152.namprd10.prod.outlook.com (2603:10b6:8:f1::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.21; Thu, 28 Aug 2025 01:58:04 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 01:58:04 +0000
Date: Wed, 27 Aug 2025 21:57:59 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        syzbot <syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, jannh@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, pfalcato@suse.de,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        peterz@infradead.org
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in sys_munmap (2)
Message-ID: <tvtzgibiy5fvmf7rms4jeyim3lx4nas7qmgv36oryizdvwaujh@bsxqbd3nii55>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Harry Yoo <harry.yoo@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, syzbot <syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, jannh@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, pfalcato@suse.de, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	peterz@infradead.org
References: <68a7eee9.a00a0220.33401d.0168.GAE@google.com>
 <2d1297ef-5df3-4679-8e38-05be188f18d8@lucifer.local>
 <aKh2vr9HtFRKcnR6@harry>
 <ourgzm4wai237cpcef3ypdn67hspjgw4u7fee4hyouj2hn3gwx@c322noqn4kzq>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ourgzm4wai237cpcef3ypdn67hspjgw4u7fee4hyouj2hn3gwx@c322noqn4kzq>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YQBPR0101CA0089.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::22) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB7152:EE_
X-MS-Office365-Filtering-Correlation-Id: dde17d35-66cb-4ebf-c406-08dde5d65336
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+biS4t2MQhXcfkKOruOxxPRHbznyN37biXbTtEpA+5M+/r8QSm7cZHhCpDIL?=
 =?us-ascii?Q?Btd1GxbqzKb1k3raZPph4MbPzsj8o3fmCNYouLz3GNwD55O/inUOmgoU7L2/?=
 =?us-ascii?Q?PIhGRzJLx66vl2uH/ygpoF2e4mTujKg8CioFh+mF9E61nG0cFTMDlnqNkLzA?=
 =?us-ascii?Q?i205g/RKMsIo8eKHzg4K4efzrdlN1zDFivlWJSZh15hM7CcOQnSay8GAZyfd?=
 =?us-ascii?Q?3FtF4wu1vQyb/FyZ0cQ5Vu0xDNYBtr2wjmunqaO1LJebSKZjfdaWm7f2vYF7?=
 =?us-ascii?Q?qS8RcBeYj7LmuDqSt+b4fD6E71NktCj7iSlwdQuRMuwMrLOAwsFA+8D9huz8?=
 =?us-ascii?Q?NJLFqmSwK2Wy0Fqrbh9U/BJJK6BdDXKEEgmWmUe3gkdVaqD2UJDeR3v3LQIU?=
 =?us-ascii?Q?7HDhFAI48E77miAKlRJeUs33BPuYwJwf+eVz3WNdFpVU1Z6cIM0JlGO0fmLM?=
 =?us-ascii?Q?fdBZYCsN7D1J1SbvwpIqnKjv8kj3Y1hUyWV/njIGhnG+03GHqbdig2LxGRPY?=
 =?us-ascii?Q?M9NovSKN/LVavD7XduJG0bte4eZBEmeFO9tHb7pcUGCdcN+KDTHeMVlsR5Il?=
 =?us-ascii?Q?omm7kHTq9YuwRNTaNmndUeNGdM39Ida2SnuyDfXzg2xt1rCOeMm30YPeEZbj?=
 =?us-ascii?Q?xMv+UjwjsF3IFtKnEDibDfhYcj7F4APWZW6A0A0UVJrcH/jY4h/wf/Iyj5Zj?=
 =?us-ascii?Q?ffzUdTwau76C9sklUmQKhEorCHHwDfBbStDe6bLV3Y07c7CRZ9EMfcE9WanD?=
 =?us-ascii?Q?IkHU1iquES3GTjIv8/rV+dSlqS8rC2cln7SKaxpjYbXm0anREz4qH3H8NQsT?=
 =?us-ascii?Q?enX31RtYxuXc4n+JfneMxTgS5vIxEikGpjWm/1Fp59CmSAGpyinxE18jELMu?=
 =?us-ascii?Q?F4UIfsEtrmO2qSLTwOvHb8Je5asrWbBRz0OqKr4uBUrWIiABy3NTsDu5bYph?=
 =?us-ascii?Q?K8B5RJ7I12rLpJ4wtE+AMIr+qAVvpWckYkVzvLDkG03zKSGzb+olcJDrVtZK?=
 =?us-ascii?Q?dasGCvyW7L/eWKxp6NkGJIC99iLN2CdNPbjuXassIPoe84Et4cHai0UyAzho?=
 =?us-ascii?Q?b0YHrm/QcoXAp23/Pj7nicSF5RC6LfAvyiXjEcSUl9/YkhmWPqDi/EuXqS0W?=
 =?us-ascii?Q?lwlj5+RZRAuyPP1DnTHkfOlY3vNsqzlLS7ib6rlpe1casGYU5hNaWWQ739Kx?=
 =?us-ascii?Q?KKOiSYTlfheILt+jxVaw2AHuVyktKqbHGIsCp55TEnbgND3r4o2c1bjj+W3D?=
 =?us-ascii?Q?9j6VMr5PQul6gdp3T3lmjjtFQX3vcLjrArjKHMVl3/DhDg/QbGlcAu1Uiplw?=
 =?us-ascii?Q?4pKisQWGled9LgmMqcfbwsx8+oMAYnZ6qqusivssiy9NJyshyIqV1pFNm6By?=
 =?us-ascii?Q?zxbyGgO8aoXXN15MaJZf+6nqczJwyrE616JmYB6IOB6noXIFU7msfzPNSrxr?=
 =?us-ascii?Q?qwyjwn7Hw+Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ub+2o/erl079ZbkJJeXadq0dfbn5+ufkPBmqTiVjq05knA6gR5O7FvjDRLE5?=
 =?us-ascii?Q?dZ9xrF3QMGvCn1fqxu/L0QLV3qYB9yUgO/2n7xed3lxubYpQp0nCcT1PAtPu?=
 =?us-ascii?Q?pGi8u35ytwiWt23gOpJ1LmmcVKVsWYHXCO2pmAahtwRt/+VUBQwTYA1zGr/8?=
 =?us-ascii?Q?v9ug3QYempDEIQkJEHB/+GplZhjXmMU/LUpmOOtJJa/kgY87E9zSFpSeVh2U?=
 =?us-ascii?Q?GEFyhZObv1NpVsZkt8wGhFpJ3dcZi9F1csbr40dM1HI+Yre8eCaUZYXZmqe4?=
 =?us-ascii?Q?5i8kOop2e7oskmexPWJ0YS3bbM62R6uqNLItZjms7KwOzyOzNiIVu6ZCiucu?=
 =?us-ascii?Q?MvW9TFVIrjE8Vv2Z6TYWksKjyeTgu/+miJ1KLNZStCAfMGF2BBYpp6y+7YSz?=
 =?us-ascii?Q?cm3Jl5+5j7n5oSqo7EtejuV45g/mzkXVBYBc6lya6pZIjicyWo8Ydyoi787x?=
 =?us-ascii?Q?/hrSVE9fZPHsd3+NWqV7ylr/D5ML3kjjyidCchoLwVL8fXjx+krgXLgi83iN?=
 =?us-ascii?Q?eu3iUwP4DEO1q9Eb8z3jgMhj0562mMlu6se9ci2GafSJT9rtN1zpI6GbMapH?=
 =?us-ascii?Q?HVj9x3dtwR1+KqLfoYHORqmuxAXZu55/LCszfUTMzXR2Izw7ajhKC5EXFwtE?=
 =?us-ascii?Q?h8zhJlqC7i4X/R89ZBU7aQDWq1hPn6AgrFpKVkHkuAV4hwDT//f2GuX1GNcB?=
 =?us-ascii?Q?JwnVJftRBVNrwQP88jNepZvCqn9LMs7JS5pY2Qv5IM5DBSlZQN0jU03UH/M1?=
 =?us-ascii?Q?5AD2z/sGJWhBLWE3/c+S/tAoC4MRTf6FpGuopu0oS6EVve2RBBfgIAaz/XwM?=
 =?us-ascii?Q?NUFV+Um3oVR3qz4VeBbftYlEH6VC8Zq1l/6dCGV9Z4XpzbxRwvxRqeOeUzcq?=
 =?us-ascii?Q?yOYgkfPMMS7JcuCoVE7sM1NpsnVTzSBqBdiWD8TazhM7HDeb94uCFudk6Cuo?=
 =?us-ascii?Q?4PKT+cS8+4xHx6ozcb28KkbnK7+AW63Z9Mb2A9erIej5woNtaqfj3tqfdfEH?=
 =?us-ascii?Q?FaxWHb+ft4g+Z8A7k7jX5h/ytlGLBC00rzySyZ5+Si9RxOgoeom8HefdMyIg?=
 =?us-ascii?Q?5kAnYY9DVNpSOVnA6B9+hwBudWJik/svDqV6Eaw9YWK8999Jrs7mnKrBktLB?=
 =?us-ascii?Q?Th2m1rdAcJ8wiO5j/tzpAPJ5t0X4KUfmRbvixv5za/6lczWxNUtBTFowdAvR?=
 =?us-ascii?Q?Ix60c/O312hIvjNtDu2kaiX3BTCmzuRMnv6HWDrCbYDZ7Sfwr9dxvkkHIYw1?=
 =?us-ascii?Q?yIctXoiPbrwZzOEXWvH5PKIfS6eLSQcO/QlhS97oXPZD5lmjcbnbe1d6NUOz?=
 =?us-ascii?Q?FLbcpf+T/V4fLV7o/LREE0RXEFCS6XvR/nowSoKn9rGl7/VUUI2YSDJ7fbJf?=
 =?us-ascii?Q?iAT9ANOL02p5SK1GXfStoXRTrczuo5gYEseOkTNB9oDEPnvez5c0RRMKI7CG?=
 =?us-ascii?Q?/8NHB4kWpJt7e0y/0NjlbltJ7kdhZnxupYEZpxtG2Z7l5wPsq0YC+CMzcaCg?=
 =?us-ascii?Q?xS0hKJlR5ftgNEJCUg5Kt+ZQ7f2s9rx+/ktCUirzGwVnJC/WtsohawEIvod7?=
 =?us-ascii?Q?3O3CQI5LiVXgv/bmUTAmmndu7Tx2WEaGccpbAWs6Hlp/t1qrmAyXkHEwwvwN?=
 =?us-ascii?Q?wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	w14z56NRG9i7T1zpzEISSOpfNs8QlVemIInET0aP5DoN7pJeyzLwvpwQ6xKFwuujUQAJnHPLWk3HaZtE/P29f89Y9TXBQY+N6gjxAGS3u8+UhOd/CnGdTKR+O/D6HC0xqFN+FQnRvgosXf0Q5pUN8lmhBiAqbDO5A77q7LHlC03QkMgb7AzgghvLneZNS63aEInLlPWfSkjtyhICc8yb7VusA3Fjf5hnMeTBS08CRg9/KQZJTtGiAmEZZyrUHApJwE7Stq60sGGENA8icOsiD7de7XUBImi7+4TE4bko/5Q+cJvNzHsuwiWLM8hqx/ThGmsiLk12W/0T7Xp+iyW+gQQEXyjKMihHuUbRG+FPiicu98+mkprH+GJ1FGotS68I4pKL6s2zFcm0IWl89CfJCxvNieCJtaSWyGTQUEqN6USJYePSMP0a4TLEEenBWJYPGmVrNEtrHZa62e2QDa52XAbG8fuflhh6DV6Ng8zhYrfr8mEzlLW2IMhstiijthe8aDu2xHVgidP37Aprq8J3wjfqsS8EVbsDAhOcxQS1+2KFbMfWkfOcgeUBndszhUHrp0GCAq2dOw1v9BaJLeYJuHyQHztaawniY8eE0CpXKhA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dde17d35-66cb-4ebf-c406-08dde5d65336
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 01:58:04.0854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FhyQ1yjEMirnjPoZq3+kzNo8bQBJCuQxVjt1v2O0hxflM1T+96TevFzmiDAzJHhdmquriSR7uhD0rHkLBkdDyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7152
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_01,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280014
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxOCBTYWx0ZWRfX7AOCev+Fn4Ri
 mypinAcCyV1YCP5JoRyus7939N/8XkS6Kx6/tNQnrcayAlE55Djdc4Run2Bkjum56+a9TT3kgwZ
 LQP9wupCCDAbL/ndJ3UjjOEMIH/Qy2eGlhM1WosNCxncxaFacFgB7SH8VTcQkJkConPxqsvO/be
 P7WVOeDY7iof0vWIM25atTzDIwNjdlxSzCzD9to1OK7vpeC+u7v0mWDlGiow01CZbm4juv+jP2w
 xvrkxxLIEc4jv9Non/KQWp30mOQC8USSDNexe9g3zfMolML4GCRQ1vH5y493rNxelN8apDmDJvI
 3p5XsuSo9/8Ya2V7kyK8ilENgFeB3bGAu+dCN5Ug+/56jC7BOG6UwgzXhhfAXn0pieNUwmr2NwP
 dy/jIBUn
X-Proofpoint-GUID: rkyH1GUXVlPNW2N5touj3aml-cb2ifGJ
X-Authority-Analysis: v=2.4 cv=IZWHWXqa c=1 sm=1 tr=0 ts=68afb7b0 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=6_kvqSaMON5sj44Xqb0A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: rkyH1GUXVlPNW2N5touj3aml-cb2ifGJ
X-Stat-Signature: sfx5tzrboighyw49h1kw5ad5q45wsdia
X-Rspam-User: 
X-Rspamd-Queue-Id: 7CAE8A0004
X-Rspamd-Server: rspam01
X-HE-Tag: 1756346295-694018
X-HE-Meta: U2FsdGVkX1/Ta5hvqkG+Q9/zB1S4diu95aEm09jWZfw5N/F9Co8Qo6AnJ3cJOd5vpkQAIWJD8D4+LS1IBPnaNhurg4a+DL8d9HHshhpHlunU9a/WgHtDM9j++LuWo3F7Q4IAA0Jw24vftVOiwEhduuI3JvPb63UL5F85BvQ/4Y6Wp+QM/v4zk7QJLmRrhrco5HWJ2uFNBM558hFi7dYfnJfnGPvGhi0nXyvU6dfa8EqZkMgiqQFwdzJeiXoxrg7gqrROvp4v9v1t+rbUHOdhuSehqAwQJdRRRy1jVHQGccStr7RfjW4NHV3JfMvwj2N5LZiR/yOc+lrafxCGVxOAOd56PI+3NeGyXQbU26C5YTFV+jK58fDHcjO728aKG9YU4lSRWkInpnosGBztONsKYKxlGBIgDSdStSo/8pEbt4EJT5kttlI3R6/WQTswCiImo7Gsxg/1iN7ib0eMmeFnlJ8HxP00ZZOc/Mywq6PpJtbnTrcu4gWThPI3VnhVu/sDUk43KLekBGdudmlZVi+zd5aRpnFczhyKQhgfyrZDEySWhV/qGud2FeMQcef6fai9UkbXviFGsadJJWbftgp1DNOZFkLpgE8aHcNFAIUj/j41mkFn/tFD2OFrDDr3pV+pWzVFjCmTp5nLTCE51fLWNU2+GeK4/joKKpP90ewelBydHi07oxGjvMQdBmjiK2e2Ux51Yue02IrkOEzhKjtNHvOl5woRhuGiXiuBEk988nw8Lrf+wcoud66AjI8fP9F6748syzb6pkaMHuGEa5424TAJSEzk9nxUZMfKX7Y3nIMG4tYRHJpU/dcTbRQC4bDbwiYzPgHPEdhcyn0fI7rOz8h7fsPzhd7+yHKsropecSi0c0RpEa9+v8gLvSR//fL/YjQYsxHvxabZvF9cyKCfzdl7PBugUFGKKHNddsc9SQL7l4AsITA8RhBkVlyeFPBUxCn+9jcTV9+6cVOaUc7
 JvnU3BxE
 E97rkTFcic5siRrQFdch3/Je7ZmQK/N69egdsK4ojg4nJ9RHYqe5IX8/S5g5M/AKBm7UOO47V5+Nwo/HfrGPoHMDvcGiR9b64rILDH69yMqXvF87U5lIpHooAvP8UB8aOAE/uLJLvxuySy4NzDzdrfcjxGIH19Dz9hdia9jcOX700yz6/K3oc+4uQWVmXT2rxVLi79TndpP1jbiv2EHVX86OJxiV3kNCh62aojFU8krhgNIsIUtNrDHu+ZgEFRY9KYt57MmXqqTkGYC9NZh1aIM0seP2ncufA2Hq7NrmWSdrHBTujP8E4Q66epIdy5n3r8h7yTM3POH/KXdYmDThgKh/FyGH6eMgwpBuzP2t2vZlpGLATuqi96LZnkPsG16UdnIHFW/82jveZLOf9KsmKDNYEmqSY83NSr3L3gaMr8pM7JjsDfqRwTgJHs9W9xducMOrspoLC/QDi21P3qQqyRfJd0jeb/KV+PjV47ICulH3oKXKRR6pVsyLQ2CLZf98AE/XBD2u9Bpg69NZyWsOTxIoOjgcI6iYH+5pJrX0Zgr9Y4qdxV7/g7OW8R5MDE3uNs8Xadio9TkCpOJhLfnxGL9XZZFmaB5BV4RMfOpAuyCkHj6k19qPrZDylWosWTcgByxplCxMo5gRUSt66UpHjrVJJ+nF/Rd7fO4PwNyHxgJxIzVQUIb9zcOQ2P0yNpoyhDhMWNTWj0Kw1cBZK3aFuePQartC7ITGnCjVDfqIlN/p5WyAG/B1fO8pPQyZO3mIsq35aB4vaIdgVegV8Ninu61gYfZo28gOElI1BwsS1EdEUquQufbSKPKKin0P/I87jNtM8l1SR7Rf1Horr+nEEaBEC2DsoWCCt4m3M1nizo97Mrnuwtr3dzAFBOFEJICZCAQsjYJuPtjajqj8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Josh Poimboeuf <jpoimboe@kernel.org> [250827 20:29]:
> On Fri, Aug 22, 2025 at 10:55:10PM +0900, Harry Yoo wrote:
> > On Fri, Aug 22, 2025 at 01:08:02PM +0100, Lorenzo Stoakes wrote:
> > > +cc Sebastian for RCU ORC change...
> > > 
> > > +cc Harry for slab side.
> > 
> > +cc Josh and Peter for stack unwinding stuff.
> > 
> > > Pinging Jann for the CONFIG_SLUB_RCU_DEBUG element.
> > > 
> > > Jann - could this possibly be related to CONFIG_SLUB_RCU_DEBUG? As it seems to
> > > the stack is within KASAN, but no KASAN report so maybe it's KASAN itself that's
> > > having an issue?
> > > 
> > > Though I'm thinking maybe it's the orc unwinder itself that could be problematic
> > > here (yet invoked by CONFIG_SLUB_RCU_DEBUG though)... and yeah kinda suspcious
> > > because:
> > > 
> > > - We have two threads freeing VMAs using SLAB_TYPESAFE_BY_RCU
> > > - CONFIG_SLUB_RCU_DEBUG means that we use KASAN to save an aux stack, which
> > >   makes us do an unwind via ORC, which then takes an RCU read lock on
> > >   unwind_next_frame(), and both are doing this unwinding at the time of report.
> > > - ???
> > > - Somehow things get locked up?
> > > 
> > > I'm not an RCU expert (clearly :) so I'm not sure exactly how this could result
> > > in a stall, but it's suspicious.
> > 
> > Can this be because of misleading ORC data or logical error in ORC unwinder
> > that makes it fall into an infinite loop (unwind_done() never returning
> > true in arch_stack_walk())?
> > 
> > ...because the reported line number reported doesn't really make sense
> > as a cause of stalls.
> 
> There shouldn't be any way for ORC to hit an infinite loop.  Worst case
> it would stop after the caller's buffer fills up.  ORC has always been
> solid, and the RCU usage looks fine to me.  I tend to doubt ORC is at
> fault here.
> 
> Maybe some interaction higher up the stack is causing things to run in a
> tight loop.
> 
> All those debugging options (e.g., DEBUG_VM_MAPLE_TREE, LOCKDEP, KASAN,
> SLUB_RCU_DEBUG...) could be a factor in slowing things down to a crawl.

DEBUG_VM_MAPLE_TREE is super heavy, but that comes from validate_mm()
which would be the last thing to happen before returning, usually.

I mean surely that would show up in the logs.

Okay it's in the second log on the dashboard..

Yeah, I think it's debug options eventually causing failure.  Apparently
there's a reproducer for syz now but without the validate_mm().

