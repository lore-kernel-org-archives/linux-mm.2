Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68DCED339BC
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 16:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C85846B0006; Sat,  6 Dec 2025 11:34:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5C616B0007; Sat,  6 Dec 2025 11:34:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25176B0008; Sat,  6 Dec 2025 11:34:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9D8A96B0006
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 11:34:52 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50481133F10
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 16:34:52 +0000 (UTC)
X-FDA: 84189595224.26.F3AB499
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id C9587A0006
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 16:34:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WdPMD4w0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="etEGmW1/";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765038889; a=rsa-sha256;
	cv=pass;
	b=TMg1co6x+oCEy8ltTBmtuXC2tiMIwZ4Ier1i858QtFiLECGzbYhkGIKM91BrfVjXYVzj94
	Z+O7hcmZImsmT1cwERHWwPHkQVhbPdj9RiTzWF2810O2drGK/BWA+6ctnXYw4FAkA/aZW+
	26LJMo8MbqCkrgx+jJZZPYGlsuWJDi8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WdPMD4w0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="etEGmW1/";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765038889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/EThc7X74JWANKXSv8P2or9poKX2c99Rca4Ud6V+Q3k=;
	b=befikWw+Q7UCe3XmqRnT0eYkuaPZACVFKELENbxZDAz10CEfHY4yDmjBfw1z8E/R7bnhJJ
	H4m0sM38j67fkevclGvid6FstSc4iZ+wudptzdUxevC6jKdLXTXdkPFenE5l3GsXzUTTBy
	LuPJ5D4BCiBgppE0+XqRse4OooPtE8U=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B6GEaUg2395953;
	Sat, 6 Dec 2025 16:34:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/EThc7X74JWANKXSv8
	P2or9poKX2c99Rca4Ud6V+Q3k=; b=WdPMD4w0V10pEZ9W/Y172IKH1gUWik3WBP
	WRw0ug0pdQy4WrZcuqy2WeXoBnqIFupTGeFsmZku67Q/cBJ8y6Wqw2uOJJVGewtf
	rbtWJN86Bdp8/Xjm9iREQDQMAcILAhTC6sPR/HVTy/lzLO6ppM9gHyxiPBxyKhA7
	Jkw5/wQrkVH0UZCLYt2z5sdBktIlzUbfjJloSIsEIfh/fKjr90yw6IFjMTHsa2sY
	8lg/g4UQEJ9Bo5G07x+/MLOmJZPhDXtV+4Uyowc8JzDjGzn593k67Md+rPQPymY7
	H9p91J2yfLDnSsEcSjmg6ouS3aspTAtI8BBSelF2jF+0gJWuSUEQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4avqq2g0bh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Dec 2025 16:34:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B6Cvube038209;
	Sat, 6 Dec 2025 16:34:41 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012044.outbound.protection.outlook.com [40.93.195.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avax6csy3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Dec 2025 16:34:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qSK8GqnNCoBXTg+vVd2b7JfYmcZidE/9DyB3YBttHGYrPaF3qn+reaSZ8DUB0SUW18V0PKgZwVxVTcPBKqCrNYQBsWuxoCBHF2XOmPe/hd7y32Fueb0Y8l+lmHuAGAnogXugxwv7BJmYj72T8WkiTK+NuWz+0Rd52x2j+Wnd+QjlmzJg6pENQvj40kOExSduGySEOwA1Dq68CT4NfnLTZ5uhMzZV7K62xlVZfBE9SDF6N/Pz1eO61wCddhNgQGmYwVfyuUR6j4GQYsXDiBF6uM4ygznk5oOt1gXsZ+Qxqk/GwVmt2WDRYMPH2uOLNCha+6AAky/5ujcZ2fzCtbm8aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/EThc7X74JWANKXSv8P2or9poKX2c99Rca4Ud6V+Q3k=;
 b=JwapqkdvIc5pRePvqzHmuYOVhvyF4Mqn7v9h6KCC6YmtSu0qXswwDdC+taAnBMhJVhHA+unIl6OF3zPzT+zYCJSGCfjHzjaQE8M7ckSFLadfjXK9Vs8OWLQN5lrWUyBB6sU9k7Fdni5QbmvZuDdJgwIkv09uZED9Tu7hGib+2yfN11WAz700bqJahtW7JaFTqttDCkOBqFalWTOKRoJy0UX6Y1wAVBjwX/ybUvFn1DMbM9QxuLMMesX8/3gR/DbKDqiQGRGn+7Q8dkpUYXG3EmLeeBYYIeWMKTfaLrwzQ1EPINM8HPraZ+Ml5bzoZArE4E+adSRqau4NxBh5t4Nz+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/EThc7X74JWANKXSv8P2or9poKX2c99Rca4Ud6V+Q3k=;
 b=etEGmW1/0E+aWlHW44py7N3u6MPfplwawuXUIIr1xLZjv8INRS+cInh9KBmf5H4PcYnZGPJkLcxI7UmfiJLzA7+fRFq5mBxAIJxFoPXI0yow4GTJNnpcIZqd9QbArg4Mbqi8ljJIbGFdJyHGatALdghnaNWGjJwbuocKcxjfXe0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB8180.namprd10.prod.outlook.com (2603:10b6:408:286::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.13; Sat, 6 Dec
 2025 16:34:38 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9388.003; Sat, 6 Dec 2025
 16:34:38 +0000
Date: Sat, 6 Dec 2025 16:34:33 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        oliver.sang@intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-ID: <12076aaa-7dc2-4388-962b-7620f9300d07@lucifer.local>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
 <20251206011435.GM1712166@ZenIV>
 <20251206012608.GN1712166@ZenIV>
 <47e99b07-e599-48d7-92ad-0471ed6bfd8e@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47e99b07-e599-48d7-92ad-0471ed6bfd8e@suse.cz>
X-ClientProxiedBy: LNXP265CA0055.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB8180:EE_
X-MS-Office365-Filtering-Correlation-Id: 825b52f4-d462-47bd-f274-08de34e5590a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZtY0PobBXJvsd0oYPdeuL6aw4Zs5Mlsc1n19G+2riw1ivDp8AsjO+c+U682l?=
 =?us-ascii?Q?PpZPLRg6lHpbjH9Ru62YKqU5v86Vm9TBwXRDIzk3jBvzHTMyVDCMEWkGYufX?=
 =?us-ascii?Q?wuUid6Z7qEp0Nbfd8VDZzaP0S2mqdkpF3GWbDJCC58kAdaOwqiftSVlLYJk+?=
 =?us-ascii?Q?rRpg2ywMgdAj5SjmUKtz6TwilxEW+Ds4hIi68PyT7jm0gVvBwctVN6C/K4Qz?=
 =?us-ascii?Q?M5yXd35E1AXbYk7tJ1rWR46ro1CxCKO77+K6V1QVLrprvcUWTS8r9vv9kyVz?=
 =?us-ascii?Q?Cyx5d/I1NVv+LJ/uVjqt5HaA86+ITP/t2Tq3CGytfvle+XUTzfD3CitytBBo?=
 =?us-ascii?Q?kWetR9n465EeiPkL4IU8VPi5s3o6m82RcKAZIwsxAOYBRP0Ok+KMLiK35TuA?=
 =?us-ascii?Q?m0T9THa+vgUaoPfj7nMhvK8pq5ebxTZyXVfP+8Lnes0uoC7BhoO/0kM9y0Do?=
 =?us-ascii?Q?U2/tSpgT7Q9vhOGhRP08vyW0K0c5I6cIBRuw53lbX+QJ+C2xNFTg0ZfLF9V+?=
 =?us-ascii?Q?8I2ptamH/FB1YZhN5K8rXI3HUwvvpo/wpajiuODjpWxbSY5SX0lq8fZsxxGt?=
 =?us-ascii?Q?lXlXCK068nGgv1W92lC2oJ07qk8Z5rKOT3vMHL/CX13MB2zdmmUOIEIpCkyK?=
 =?us-ascii?Q?/ItyKr6dYb45vKzM4kyMbf3TzJbWarJpwv46IivdFFpof8jCi3hHsH95xHkD?=
 =?us-ascii?Q?ntTxN1GOFBMxNmLBeLTbM8oo/8Yk0iNKxawwVE46HMIrbP+DA9JxxKODVG45?=
 =?us-ascii?Q?S16Yc1vYsSrAvBLf+6KbIMC5C2WIgp+SBCpU7HxFMN4g8bk41H6OhKbNnhH6?=
 =?us-ascii?Q?OSTL5dKLvKGggBEnUz3l6XbaqLQkhXbxY39VXxbsvcc2+j9vAsjhdOx/AGjs?=
 =?us-ascii?Q?V+d2fYBwEM5pLBTMHzlbiMhULSX3b5S7ISf9iwO2CM41NWNpsWNe0cSS5Jla?=
 =?us-ascii?Q?j2LFAw5slBl4QGb5ilIe9YwjVk9GUtyzCkEF9/N4faHRqKsfkiY2ndOzyJtM?=
 =?us-ascii?Q?lu8KfMQpW54R+H3R6e5dTTpecxfNHQhNobQUFPW/XnUS07baz8H1zP4G0IMi?=
 =?us-ascii?Q?vDmP9OTeaEThEIkKc7Jp8Ek1rI6htJWKUN38ImQIHk7g5uEPtuw1lS5y4o6g?=
 =?us-ascii?Q?zVOYq3jomS4FxGRYgSHnVASiyTaya95eIVsijiUzumPCZd1CCyC9LAPrREWx?=
 =?us-ascii?Q?tLEJ4INWwa4ZsG2hz2S9dx+qyUNtAQg4trgjSjuJcqDy0VNFs1C/2MpFEVOD?=
 =?us-ascii?Q?gEfe/A2y9ptg61P8bee4jKdIlMHqGO3Snu+ehFmuuL9rsM+PLgJPozWfZnAX?=
 =?us-ascii?Q?KXl+lpsmB05me1CF9yAVrRfn3DbjlT/p4bupBQXDL1kTFWgRcBfVX5rN0pRd?=
 =?us-ascii?Q?ikRDGv4qi16EdWGQUjdiZZci4vif850TzkoXn5EDwyyf6Zcdao7KwOzkxVhB?=
 =?us-ascii?Q?pUOCKmj4rRyw0ay9g4x4D72Dstm5Lpjl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SFpvft0dEnEd5ASlO46rYnnBURA7HaaHxXqcxw1q7Ux3yi/ogmKk5ddqx01Q?=
 =?us-ascii?Q?ML/zF/AsNDiJbgj+GpnsxLDn34ZwdzyGEtXLRWogaD6ilA1ioiFOBAzl2wAz?=
 =?us-ascii?Q?puTTSrF2O1BkL4Wra8Begp2s28nrjQeeZL9JuwA+0DkYskSO/7sCFiZI3iV5?=
 =?us-ascii?Q?0GkijeXuOCrDZLfYF9QK0rxDOS4nkrfve3oPgrW6Q3PM2G7GL+5v5GLab5Ox?=
 =?us-ascii?Q?niPHeUx3Rwlx2yyCbICULKj/KivANzATzRspyUbIFX+gXJk+RHZGg26KRvfp?=
 =?us-ascii?Q?cWyCeNYGlSAIwZIoIh2/NzfcxacK7cQCKzpQPfgAVG9PZScww3tyuCqYEQHZ?=
 =?us-ascii?Q?vjtvge5No6ZfJeFLeFNDgd14MC6yY2kiZKGTl/h23ZdPKvGRyFiQSmOl7wUQ?=
 =?us-ascii?Q?k+qhHcf588XRlNzT2NJ1hu9BzzmOgBGdlEsvveKqyTP3/wPCnFQ/Vgr8DoM0?=
 =?us-ascii?Q?7iz6Aw023YQs5a09aMV4Dglir9FEIgyXHwr59OlgNAgOs75ugUOOsdpbY7Gs?=
 =?us-ascii?Q?fNCwrEYAdOIMquRjxAPvyzJyTPCp83r/wdJlIsSW1xmgjF9JhU7KrKJEWWgE?=
 =?us-ascii?Q?ZgpAnMDneAPnUDMoKJ/oANBoEPwGjsAcfUClxg3nIb1ie4pb0eFzWIgENYjN?=
 =?us-ascii?Q?sBs5s0FLTcANvX3g7iOYYtX2LCBUTYn7schONTklWy1tP1YTsxvP4hnRtjcU?=
 =?us-ascii?Q?q52/tXcPY45gFo2HCqP48kwxZivjG2HRmUtFw5aKM8dFyqA8k7i5Wi2XTBan?=
 =?us-ascii?Q?6RJxFJIOtKhBMh8CUAaTXdpYS1NtQ+UgnovvuwILjGiVjsPWy+G0jR9b4p11?=
 =?us-ascii?Q?DTtyoAZDzn1101F6ZhJqanvCSFZkfKdjL63Ktt8QQCF/wwzKEudoNPjIaxwC?=
 =?us-ascii?Q?MyS5RHRDLt2y7sqgcgCbboh39lITAM5SIH6r/LvxtSQZJFJFyx34HU9n+Rlj?=
 =?us-ascii?Q?IdkUTTXmRzExfKxxZnxHb62m9nOp0lo2Oq1CyfU3pB/xmpvu85afM9CzSjoV?=
 =?us-ascii?Q?VKy6FmeK0wKo9cEOusLB3gvCWf3QAF5hnvuZ2/KRRYkwmqhqLZiZLSx8uIkq?=
 =?us-ascii?Q?xCibBHXjpZK0zA2aX9Q/+hh3nsrg5gD+r6MAIpM/wKk3zGRTbyLOWLF9iuA3?=
 =?us-ascii?Q?dIG6ke4BCGWnSYIIb5G1ptm1l0S/zVfqQ4Iq/noGrCXbQppyN8hHr1wEvHdt?=
 =?us-ascii?Q?/ijvBA1WU2+iGg7uw5RT8UfgsRAzL89io6sYMF0rYG5Su/pcbIMJO+RBCf6x?=
 =?us-ascii?Q?FiLZOsRYrZZesgRAFGZaj1c4EO4lwcSEjryO9mpCknOd5pjD8kpVWh2RfEgt?=
 =?us-ascii?Q?ezpnQVYvVsFcr/au5kDVWZqRffcRelKWFA8MSIXDCM6utQHNbonzKObwz55q?=
 =?us-ascii?Q?tNoLYZnDeKRPXUGtwJ+LjR95qiyEJg0W2JPXoecHOgNx86hrmqMERKQnZwho?=
 =?us-ascii?Q?Ruq2m5c2CWQTH2ivvEQVjJ1Tl89EoL6uWY8aPJ+Ek2lblF99RPMnNxJcb6NX?=
 =?us-ascii?Q?XMIsqLnDIz5vO2T+LFUsuz64BuBStLUx2g1z/qXb5voyHGCjUGZxT3az3WBl?=
 =?us-ascii?Q?V3RGliYXeiXwBLr4r4EiLT1UaeunGpZlB8x8mAnpV8t7/5DqHq0CrZ9bJN+N?=
 =?us-ascii?Q?coX4Hbo5e0bFY4XdAA8QmoU5y1h+TqFR3xK7rzjzwwaIsBtNf8pneR40e1Bh?=
 =?us-ascii?Q?nB/iDA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	S2mPEQMPzDxKq9Yl5CE8kJTd2wBzHDWKmN8jtmifaBEyIYHqmlhXt2iPuYGn8rmh2U2V1K5PG2ZfaCk9WHfOZ4rgGnvYEssEvsu4WVPNuqoDh4iPOgD4y9AkkXKJqwqqka8nV6uu3Sd9ZUe7+YXh7AQrYcb4Si3d7If8e1BDFWEhjI6eWDjSuOIJOREPOYZ763nXqmDkciGx5KC2ptwDaEwh7x9Za5Wzb8T6GvQGIUJoKoLt+I5SSpEhb/F8HEWrst2qkmHjwSsHKVYND7Pt10RQcKFmBKDQre4O+QeSGKZ+sJsd032RbU9Nn90OX4MDWKZLngK1gHCOdkpMWP50RsZn+PfyHCXDBngWeNG7tnQAyf2rhDC9fPDE7WlXn7jbwobh9ybd3Odj+ntOLJBP12z79EUZ5jdocg0nn1puXJlfTbdQmaURjL+LdNkKyuZPAxIz112Omz6Gh4NRv3G+weas7UF1qmMV8jZxeZHMSIgto9ftEKGPnztIuXeYLzmpvWjYph27CshJZN/HBQfR8vm47GcU7URjuUOLsDMuFiKkRlXnmb/23S3BfOYpNwX5hgRKw4t4e6kh2VcnQ4LtENtp+2vU7W2LLiI/p7R6M/s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 825b52f4-d462-47bd-f274-08de34e5590a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2025 16:34:38.0960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1qS8m6+Cp275I9hZgfyHZB55izViTGUxuMaRmrcQ8Ee8dsomYcSMjmtxZXwX/ZvFPLc26IHTxdVUwxK2/T5SjIFE9ucwNVYrSrBgr7c8J1g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8180
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=605 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512060135
X-Authority-Analysis: v=2.4 cv=FIEWBuos c=1 sm=1 tr=0 ts=69345b21 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=TmjkUoeHBnpz1n_LwOoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA2MDEzNSBTYWx0ZWRfXygZIU7eh0Tao
 ZYWj9H8W1c2+LMCzdxnH2VSvT1i5W1gMiScJCA0FeRbBWs9SgxIWLJlcUvmUZMIvWmId34tKJBG
 TOzb3Q5bfys/Zj+lj/h+NAtuFDxTCU5GERQDqf9uDq6C3Ut5ektyUp8uNrAdvg8vxLKa6T3UmrF
 +3tdEegtLqzV7SJ6C0X9O9aXdjT5qqSFMOv1hjOGDJ9sb/dsrgx7owqTikqZrhvrc5PfkkTv4ky
 z/FioWw1tHKVILlYR5mb30LHo3c8T+4t4hTW966u+sr/N1sBGtkTxqha2UsC+NNkK/Ug/D+/bwa
 U+qOxB3qO/mm7u6pNzgxgRFwUwTkr6tLi0u8rnz5il3+Ldu8I1G4caHP3VagIBfczNwF/Ilz7O7
 qcU3+yCmgSVD5jmjJsfJFsBkdGEidw==
X-Proofpoint-GUID: bYnU6-Cq90YPh73qTzY9EUByPfHsp3TO
X-Proofpoint-ORIG-GUID: bYnU6-Cq90YPh73qTzY9EUByPfHsp3TO
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C9587A0006
X-Stat-Signature: tinr5awyr9xdh5u9hssk1myioctq7nr3
X-Rspam-User: 
X-HE-Tag: 1765038888-521320
X-HE-Meta: U2FsdGVkX1+4RsXAPbs5PVWJOiiFNBeJpaeQLFavHEahgYyecjNc/krZX7I9E7KFpEUm95XZCHCMMqZX2IFn4OVxXzUHK34xk7P4y9caXk5EB/EdCG6Ii+EW4L+L+F1VRLX5pupXpTFCrGFAJnPuJEk5EwmSQe+su6nSRFrHia4G7ZGKxovHehtRFC1k1imbfnIDLGVxmVganM8ntV80ETz5ew+/0PadMFBVY1CaZkaDYrBZB55U05k9AopxBJqQKl464qjGlXva0e27Cw1CaGYrOSeuUmcmpa1fdIekLMeoZPUQJ8DDWDeUJ4y7h7BVz1zXrTMeMmfjI8Paig1+22Htm7HMvDCIwrN5B8AWMVLWAYY6ZdX2myy/UCY+ePa3IlYtNQhscev1fbA+g3JF3zypA3IcooAlwq8YCJXMYW6+KKHrFYskOoj45Flr583NHdsRgd057j4tl3itgN5S0WWPnK2lNq4k6sUYgrV1FIs5srfE4Gh6qZUlm9oplqGgC1c8YL1AJq0xx7Ulibr/I1o87Fy8zPw1FFSvY6EIXW7pj9KUGkwwKpY11zVqBK2bimzxWBB8fkRnEIVQj4Xxd0Uay5dZ5/mGkKOErxMTw1+HrOkbt/V05lSbZx5zUJ+mpkh04gksKHmhcNFngfpqYNqr/DjHcmR2lUt+zpdLDQY2cGCqljm0OmAleGKkb0Qjf4zChlgn620yB7t17OA/pFQPhoOSx7xVl+8Zp5ypCp6gSoQhQ3q1Rs5jdnVuiQBZ6vH+QrMpf//ly+b+4xe5Ra1mAhgW7rUCCOJMu1319Bh0FQP9Ceavg3/apKOQQmYdNxD6UNErlusuJnc7prxe0hZIliTzpszCOu2F1hUSC3HQp3CWAC1iToCWM6tFKCLcAnrfEhEuF2YeTAYbil2xDfQddyROXEbdXmMnE8Cj+VR+1T622LNgICfz7kDwcDQ3I3SxxGpptMGxfLaQaXO
 0lyvT3PV
 HBF9glZD4IQvp0TOAmQf/jk+PTiBk4OXsEw+J3afzYi9iie+nemqHgwVal5xQ/8xH+IFpoOoTdLZFiNykOq3TuUu4IXVyxAmOngzxczESLwul26s/PRAI8iyiEDmFAbQJSvAz3pVMEe8obgkGxj5AXjKax4gwHoRXcan4BpByUTupoNivsc/gRpYcXyKpwTCYFbxxCOO839KKXsRRJWEMS51RI0v/JOyPHC0x+1peNJumJxyyVz/NdGWtV6ENcXp05Cui7A9V5cqBsoLlbNn8DVAjwtKV9b4BFTQAwNSvWh8tHXGt7HVsNpqx6h7i75BSiKOjdk4OvXiNwuZ6DMbhJ/pw9yGVfF/StE0HOrM2GW+/bKDtdbwRAv0vJFuYp/Nwy0HOL4Ifkyd67ENB3Ohbz6P5b7aKJeXjCoW+5UocLtuobu1ZdCvyXNW/xpujbiff1EceDFCMaVic1rHlXSQLxll5+Nu50NyVlpIOHJO7sfmpD7IFf1TESjoHvPhLBIa/TBSf7FnbRPN2yDFVFxNMK/USLKqjAdv3zbfpPY8B8gbfRF6NZNjCzuWTkq/DLSyK23Zq343vvW73/a/1FN2dps6OYU8QhrBuDHXPKfLaTLK0RR0yLEThhc6RBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 06, 2025 at 01:35:51PM +0100, Vlastimil Babka wrote:
> On 12/6/25 2:26 AM, Al Viro wrote:
> > On Sat, Dec 06, 2025 at 01:14:35AM +0000, Al Viro wrote:
> >> On Fri, Dec 05, 2025 at 05:50:37PM +0000, Lorenzo Stoakes wrote:
> >>> Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
> >>> how VMA flags are declared, utilising an enum of VMA bit values and
> >>> ifdef-fery VM_xxx flag declarations via macro.
> >>>
> >>> As part of this change, it uses INIT_VM_FLAG() to define VM_xxx flags from
> >>> the newly introduced VMA bit numbers.
> >>>
> >>> However, use of this macro results in apparently unfortunate macro
> >>> expansion and resulted in a performance degradation.This appears to be due
> >>> to the (__force int), which is required for the sparse typechecking to
> >>> work.
> >>
> >>> -#define INIT_VM_FLAG(name) BIT((__force int) VMA_ ## name ## _BIT)
> >>> +#define INIT_VM_FLAG(name) (1UL << (__force int)(VMA_ ## name ## _BIT))
> >>
> >> What the hell is __bitwise doing on these enum values?
> >> Could we please get rid of that ridiculous cargo-culting?
> >>
> >> Bitwise operations on BIT NUMBERS make no sense whatsoever; why are those
> >> declared __bitwise?
>
> I was confused by this too at first when reviewing, but instead of the angry
> display above, simply asked the author and got answers.
>
> Comment says:
>
> /**
>  * typedef vma_flag_t - specifies an individual VMA flag by bit number.
>  *
>  * This value is made type safe by sparse to avoid passing invalid flag values
>  * around.
>  */
> typedef int __bitwise vma_flag_t;
>
> It's done as documented in Documentation/dev-tools/sparse.rst section
> "Using sparse for typechecking".
>
> So yeah the keyword is __bitwise and indeed we don't perform bitwise operations
> on the VM_ values, in fact we don't perform any operations without __force
> casting them back first, to catch when they are used by mistake.
> It's not cargo-culting, IIRC it catched a bug in an early version of the
> patch itself.
>
> I wouldn't mind if sparse provided a different keyword than __bitwise
> for this use case to make it less misleading. Or even better if we could
> make the compiler itself treat vma_flag_t as a "special int" that can't
> be implicitly cast to a normal int, so we don't have to rely on sparse
> checks to catch those.
>

Yup precisely - this was entirely to avoid issues with passing a VM_xxx flag
around when a VMA bit number is required which is a kind of bug that would be
_really easy_ to do otherwise.

	vma_flags_set(..., VM_READ);

Reads perfectly but sets the write bit instead of the read bit, for instance.

Yes this is a hack, but does the job, and the sparse documentation doesn't
dissuade.

I agree with Vlasta that really we should provide an __explicit_type or
whatever annotation for this usage.


>
> > FWIW, bitwise does make sense for things like (1 << SOME_CONSTANT);
> > then you get warned about arithmetics and conversions to integer
> > for those, with bitwise operations explicitly allowed.
> >
> > VM_... are such; VMA_..._BIT are not.  VM_READ | VM_EXEC is fine;
> > VM_READ + 14 is nonsense and should be warned about.  That's where
> > __bitwise would make sense.  On bit numbers it's not - what makes
> > VMA_BIT_MAYREAD ^ VMA_BIT_SHARED any better than 3 * VMA_BIT_MAYREAD?
>

The issue isn't so much the operations, and yes obviously VMA_MAYREAD_BIT ^
VMA_MAYREAD_SHARED makes no sense, but nobody in their right mind would be
doing that anyway right?

I'm not using sparse attributes here to enforce basic baseline sanity, but
rather to avoid the aforementioned class of bug, and it works very
effectively.

I did speak to Vlasta about a struct foo { int val; }; type thing, but
sadly then we can't have them in an enum, and we put them in an enum
because otherwise tooling like drgn, rust, etc. find it harder to get
access to the type, and it is in fact a useful way of defining these
values, as they naturally do belong to an enum (unique, individual values).

Cheers, Lorenzo

