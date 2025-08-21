Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FC35CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 16:39:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABEE06B00AA; Thu, 21 Aug 2025 12:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A95DD6B00AC; Thu, 21 Aug 2025 12:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95D978E0001; Thu, 21 Aug 2025 12:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E5636B00AA
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:39:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4CE491DCB3F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:39:09 +0000 (UTC)
X-FDA: 83801324418.19.8EFEE75
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id CECEA160013
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:39:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UUpL0ghO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Sd0x2Oqr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755794345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7qePYzsQl8f17Z0++MkMVWBngwIykUGTqngtc+1Zbto=;
	b=KxiWiR4jB8VS9zHtFHuGOm9gBjXfd7PSmj/mggPe7UHjNLUSTD9kTs8uoCJFL29KtFCFTn
	qSRg5BGHFJ/S7TrcemcUDXHE5Ht8+XW889ac2P72Hud4ZlBe9sfn9JRG0XLLw8F0FJqTQ/
	9HTOTCylMbZ1MDrUOBQv9JWFgHCNXhE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755794345; a=rsa-sha256;
	cv=pass;
	b=wJPF7q2O+DEJw/45sbtjl2uIsQoznlqfVqjwwe+VEnu4kDZtYBZUUvhWKXC1lVcEVhVdRl
	U/Y5IlAxMoznFGShemgg1px7t1p5Yadgx1o55HbKQzsFqqHxMFtInvMfnWXBaXHMh8PrtT
	AhXHt5U2AcrOPr4XhaHvMI6O8uyMdUc=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UUpL0ghO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Sd0x2Oqr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57LG17ew013855;
	Thu, 21 Aug 2025 16:38:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7qePYzsQl8f17Z0++M
	kMVWBngwIykUGTqngtc+1Zbto=; b=UUpL0ghOGf5Aw66hPFRVXFGxS09zqHzlBh
	dhlsccfVVe9HBEpUqgo5IvHhEZiL05VpvQI0vgb9IRsGgEZECn0BJAidiNqMr5C1
	lnDjMH9JZvFy3kaY3d5jc0fdh4/Xkf9uBaK4Ol3hnAP9JMC6QfkzFX1w+METY/jT
	DsQAiUsWuC+i4OSNQ/niBES0RpVL6sW9oUXUY0nV7ugyqZ5HbVw9YjaSuiXsF06B
	+SmaMRDJNrRvbFU4x6G6UAtl6W4Y6KSgsL957IwfxzZ9cpxrCq7rfyHwyX2ARfta
	OHBgflxd52cwWiJq2Y48YTcxViqertnFhrCqe33CmkuX9K6bV+Tw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0w2by75-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 16:38:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57LGZ8Ev020699;
	Thu, 21 Aug 2025 16:38:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48nj6g9pk9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 16:38:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jjERxa0MfdPmBR32vbFVTQtlVY/kwM7rgOMEejHJU6hcDZ1e7IlaEIvLOKyIS2vZ1yJiBiqBtonIqLzWWRqPfEmpWYtHRj/IE2PTcyoA1eT7+UUT4w4tvCQfKyvyC0n5iz35cZ25itFJecD7SiU2EXJq/dMIeirp+vX+0WwHLKcrxn362IHKcQhVaLtaJPOkVuLLsCRWj8hl0mPMCpTwdMQBkkvhyYllDKrPfSl9s6It/Evfecr0s+/RuDD74W31+yRir3O4kO8sPwLIyM4Qh8rB4tnV/5RwxUPtFqDt98THoL6MttLoHWkmBZ6885bITSgvvRVDyYGuR6S8AL2lCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7qePYzsQl8f17Z0++MkMVWBngwIykUGTqngtc+1Zbto=;
 b=dpt8zSqeTJyWCO6RNl0mD09SBbXDp4PA+LOgZbJC2ZyGOVn4Bwj4EQdq5WfVaFH5FLRn0aOWuXtwpyDNJS7G5VVEzV6TvE3deRskkROpliA9gguZn/SQDSr27ddM8ZugLaet+SupubgxIualWD39i9qe8aa8yan60TP8B6nMPpvihVvxX4ZlKVyqwZaHGrncUhSXhcetEA7qUEUEVbLw3ujt7NgoUkfcX23PqZPmKcfXZ32MWzV+XB9+ZWBhH5Qld3oCO7T121CvCfeAEjN9Ymphe5OzClV2O7uitxxgmb86x8ctu2Xfob0cjSvQEwzzaqM3IEpakoDyrPKAqI4RTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qePYzsQl8f17Z0++MkMVWBngwIykUGTqngtc+1Zbto=;
 b=Sd0x2OqrBQhQmN0XiJGW/9U6+5ZyEIuuEQXjtsTtnzdzkQuGtZw3/pUZke5QZiSjoGkNzBMdU3R1nY4bOfN9bH79W3CrmTaJ4CVyXu23hV6WzGF8iloLijmU8VDXUJxU93sB9xiQJJukb54wJRAhozKZxXrjcMF4udy3eFi+QuI=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7800.namprd10.prod.outlook.com (2603:10b6:408:1f0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.16; Thu, 21 Aug
 2025 16:38:34 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.013; Thu, 21 Aug 2025
 16:38:34 +0000
Date: Thu, 21 Aug 2025 12:38:26 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, ryan.roberts@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
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
Message-ID: <bdhwa7x5zys3qnvocluyrsi2rwxgzd5ia4pzw3qlblngezrbjb@ke6jydmjm3ad>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Dev Jain <dev.jain@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Nico Pache <npache@redhat.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, david@redhat.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, ryan.roberts@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, kirill.shutemov@linux.intel.com, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, 
	jack@suse.cz, cl@gentwo.org, jglisse@google.com, surenb@google.com, 
	zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com, 
	rdunlap@infradead.org, hughd@google.com
References: <20250819134205.622806-1-npache@redhat.com>
 <e971c7e0-70f0-4ce0-b288-4b581e8c15d3@lucifer.local>
 <38b37195-28c8-4471-bd06-951083118efd@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38b37195-28c8-4471-bd06-951083118efd@arm.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW4PR04CA0124.namprd04.prod.outlook.com
 (2603:10b6:303:84::9) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7800:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b2a7458-022e-45d8-0e5e-08dde0d12ba8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?L+fAiyHzSZUKCpSNIc/qFPSJ5KcQPDPrjoLTkBkj9uXxmqESVwcN4m/eSVCa?=
 =?us-ascii?Q?uhE4Gs01MzSGbpVBDZD8mBIqgYqnKqWn4szRNDzqgymY7Mq4Vuf0rn4pZhAn?=
 =?us-ascii?Q?I9dBoWZyjYQKdAbpp5NBCIk9pRbPf39wTlJVJ1aow7o10ApRnHnfI7XUiYnn?=
 =?us-ascii?Q?VSs8qTcMS/TUodI7tJXeLYJ88qbOupRgDz2ZlTf0aHx2Vw8+0/j17PjfbODT?=
 =?us-ascii?Q?LsW1OWPfEgkv4OW7zmok7iTU5gBsdAW5EqTbbD2XN09nyjeghsPjIm4Cs9fu?=
 =?us-ascii?Q?8zQFZlW6Ropl4PjxWhZGAyqMShi/Y08bnH6V1lSN1oWdiZqDQzY+eqbGbGu4?=
 =?us-ascii?Q?LSEf4NrHa+AP+q/FqMvqRs2u0+mQGE/y96eDOnoF1G1egaa3ZT6gW40Ny/M3?=
 =?us-ascii?Q?6VerzZr7IkXsb2yj4lQM19EtM9U9DZbXzdIWlU/QxSoz5Okeoycna4buvu/k?=
 =?us-ascii?Q?yq15Uigey87FgYH7avOffUWFN+8uMtIpGrXb7HXG2eLhUVwDQ/njXm2nWfxA?=
 =?us-ascii?Q?3zox2gCIDvG8Idi/CVDnrtu1gEerTuTmj4G+ryIPMiOig5Z4k17R3bYBWVCq?=
 =?us-ascii?Q?Cvnvnc+gcTX7Uv0McaiibdKiiYczU20oj3u6lT/fv0k58D/fsTQlgcSGQusk?=
 =?us-ascii?Q?OfJRyKTNt3KoFbOtqV0hCkx4kz0XOD+ZfPrU2SLT42liJ1hIuOo8oDdSDO67?=
 =?us-ascii?Q?IyHWgM8xqd4jRX5zueyxZYTYNXsID+JxzJ8/pMU3iJkqKUoRqQAb0MfpkV6N?=
 =?us-ascii?Q?viCQY9+qwqAczBflfKt+tjGu/XcXHkaCbqpUmoG6ucC6jijL0aTFu3qOp4TA?=
 =?us-ascii?Q?Gwk1NvyIw34MJr1Mh5W4fihK0kWXOUXkEJd513iJZvKr+4CNNBaEVhIiDf1n?=
 =?us-ascii?Q?2gD+fvV1gBvHA7saC9aiYP1YvKHKc4krvI7lztLKpTeUapYTsBmz/Uyag/4p?=
 =?us-ascii?Q?TwphVXdq0/irtqiNuEIpwEtHu+f7NJQR8VPTysyAsyjF5pQ4QpEAKCvr2yds?=
 =?us-ascii?Q?/qNWYpICU9U5TilOePEsO9Xeg2Rt57IU/7C0OH6U5IkV6bmCr7pufuoqc8nj?=
 =?us-ascii?Q?FF57Y5C3NDJBzoR1asBXLpM2o2+1XhCY7Yvk+ugxHAqQvUY0UQ43Rrs0VN+X?=
 =?us-ascii?Q?lmUSrfsXBEyL6Ts5MiNZ99V53pZW6B9/eVmnaOJ7VBDtDfzMhjEFdds4KX9b?=
 =?us-ascii?Q?LavwPHghDzPH456OsFOlhnYrwkaaEk8QezWEyVWQjWCIM2xxO4zSqTt9nOwX?=
 =?us-ascii?Q?3+WbyIi8m3KvImoLONkho6/YKMf4zGl/dS6AXIbAMqHoTTqLwcX3GzD2EpdA?=
 =?us-ascii?Q?qjz8k+KOOLmvAIaSKskY4M2Cgt+1h2YS9Mz2MiLRkOc1BXpS7F7RA4a/92cj?=
 =?us-ascii?Q?tcTDmQF4yU3cjBQfjI86FnniEhNohTFuajY/4HqXqgttyFKt2ubVtCovR+l0?=
 =?us-ascii?Q?VcA8nVOqDuA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/whubK5pcr+jDR+6XAXDxbmqGUwoFYp/A88dxOTjq/vgHU92E1GYKJelJTy9?=
 =?us-ascii?Q?VnONNttq/RzLk8wl79nt2ms2oOH6Ps/9oaSkWau7tDHE4k6FowQ2jh4fLgJs?=
 =?us-ascii?Q?Jmit/tJ+sd1GiwaC4q65N2bXTutTrWK7dbytIdB77JssbDSv9Xa8XC339TL1?=
 =?us-ascii?Q?Yxq1vd9lAcwF5E80AMVu/8FwDP7GZEc8MnaqvDxTRHE9ZCuPE6Ib2xOixg9b?=
 =?us-ascii?Q?0OyA+YHTG8HdWCjyWok4rd0AgYyvsISezOgzRRR+7JJXDvb2oOEKmVlQ2HYe?=
 =?us-ascii?Q?eC4i9P6nAUB2H6MEGFwC6DH3rpz2I4EC5ssgKziizQudZVjp/T1zTE22Fm3y?=
 =?us-ascii?Q?ciT4DufhjDJOZEuKtwyNklcbLkaywuQAK5vexSJMzRvZj6qFrcD8ZCIRM45J?=
 =?us-ascii?Q?ZIPDwRkQFWEVWDNHEF0zQlaQ3qgm9XWBKLxRxSQMxvFMYz7ZqAiLvlPQU5lL?=
 =?us-ascii?Q?iR2yIycoIbFN2FCPScvfM7HI5AyTqFcFts6xmprokY127KU//l3hPunAGG7H?=
 =?us-ascii?Q?RhCQJv8Hpf/Q3sywzoDs/I0J5GBL/Lv20h4bYb1rP9oajMuYQQdedUHwvFsW?=
 =?us-ascii?Q?ons9T9pXHa5IiUCiIba8F2dIqrUnbgfYc1PG2DC6jCiV8OvVmacIYJfocUn4?=
 =?us-ascii?Q?f61f9SesBjAlHWJKdoVAJR3wiv1CFFX3/mAgZHyczUbzq05wCgihZkRgANtm?=
 =?us-ascii?Q?YHTYALxVHpmdAJwZbv+yqhjERXVrNdV6X8/I7wqpEU35Ckig8TWX5+jMG7gd?=
 =?us-ascii?Q?FfW4MjyeuNQLxuSCk7fZ78FYDDbEojF8vErz8K3BAaP8b5V4mQaQzmH3u/2q?=
 =?us-ascii?Q?KNiqqLXQ5IoOVAz+Iz/qyx/IpfBNQlWYcQpxFXWNY9d1/B6dAKOdK3WX5BRD?=
 =?us-ascii?Q?eS/VuzYPa8PiVlq3DCEgab0+9KaRIsgFdVNg2eRTMlz663RIjuxMqC2XID8S?=
 =?us-ascii?Q?M7mkdjrv+BkV7fXiaqTR1xGrnNfv4qxwNEAhiubYfRoi//vSJB4F00Rd1XOh?=
 =?us-ascii?Q?Z/pYn55ALxOZiluMvtyTkxqjIhQceIot3XB3zJDVWSBcfj/rRcqbS0KT9mDQ?=
 =?us-ascii?Q?0RFW7zCtbT78RqoJAW9h13fvvQbs7NC2fp6Zx4yB+2tjBdcuiQCsVwXqgv53?=
 =?us-ascii?Q?joaLiZPoMtWhB7V2+MvR8jPfGFUgi4nQZrZuVey11NZjaHjmu6fMPgplU6pA?=
 =?us-ascii?Q?l2uBJc8q+2/VnYPxI18xMoFaY+5X867B6YusGUxZMaDAvVAShC8/DzwOkY3D?=
 =?us-ascii?Q?lKP4MLKOYmNgLog3XINE3vLik+xLO595mrpF/iSEMWuqimKah+IxKAI0ftgA?=
 =?us-ascii?Q?QcsRPraQ0eGlZfTgU5IHKy2s7cN70vNzjtlsQcCRZYTVoD/eG8V1EtJ50noA?=
 =?us-ascii?Q?YfLyJkmjKr2zCwRmj5jlx8G2xM1x+nGzhoakurJ4yhDD02aHwdhaicnWgp4M?=
 =?us-ascii?Q?ZAC9enNNYazNXQBKB/dq1bsjXDdIxOSQ2v7QKAYvNFD+k8NuNJTeuy+eUnIO?=
 =?us-ascii?Q?Ab0E+wg2R96PtlWHm1IgRanOJwWok/Fr8E7kVCdEbBXtN6OrD/aI0nTxPKvy?=
 =?us-ascii?Q?pBhtajlTfRWQ8OWNKfAarcsu8vVyKMf3cAHfq5+t?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fWbvYeC3sTzQREMCKUZFKba3W+dO5ZFSj0juDM+mdnD7mMClUCZkwv+//G3MZvC93siqV9dz+lWOXEaRrjAkgm4TMoHIV2Y7yYEspcax6O+I0nBViGfBCVpHfOV3uekOY1xJ89GxpWbBTWJFPGoeWJYhnAxnuplsg3ypLyYEUXUipAxvZ7yfS8H8Tv7wxebTMGb/WSA8XkGz7kEuKwyu9kY52dK/6nf9QPkRUtMWdFtXcjiNAFYt5qC7heOJjRn86r96juuyyD/ql749gGAJFi8B62eiRDZ2hRL1I9ZLSDhc2QcPVVPLdZB+3eFEqcSmZ6TCC1x81GtaTVejZMNHx+OAxuabUQOLRyC2WhBtdhkPgzjZDREUW8k9vzzc19qlWGS3MP5+DXv0jXyZbrgJB87kq1+Q+nhXGUAdHg75Tp71WvR7lfY3k9k4jP6Hznp0RWZackGLkd6tfe179z4MWmTcRA6J+mSbtEVQikk6Dij99cPHwMq/w/xvDaVBgtNNGmtQE4XXAqtdtfTacNd8dsALsygsVRuwBBiVSlI7LKbO0BTdo+MBJ125lpfZFpELEOgeOIWw/J/2IzeCzwCkr2BkX54I9FCMrGjdQvmXFnQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b2a7458-022e-45d8-0e5e-08dde0d12ba8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 16:38:34.3455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JYTs5xasCWSMVQt8k9te0L8xeiZF2+IuyIZCSvH2GIlUdT6bLQZKqfb0Lw17vhodE7xA2o8uNvZFNYRo1kBySA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7800
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-21_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508210136
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX8rq0+xUyWHpA
 g9wHuonNmjBsmTN9xFJMYXbMmpOHQH8CAmoLe4caoJWQ22XSkctAeIuj1BP2lRjK6haeGvw5KaY
 xvsOw9nKmxf953881+FIVXq7pQf6U/WTwSEJt1uFs5hMRjJqdw40YmGuRTCd4r5FEkJkqkjtHFi
 mKpssv98A+eN/S8YP9J7qpfjyX2cezou0q3pZkpf5fBh9kjJ3aKTFyT0Hr9ZcP51l0UZlXvNi5Q
 XP1W0le/kVQW0Yfgcrcdtajpaf1cpmZrsf15298XDCtBQwBjNPuYdN+fLIBZvyUB6vzvgsRINAg
 8HqOgr+J7iBXvw7CjuYUO8IDwAXXQThzFT2rVaIXgu9/M2ZlYt+AzKxaFKN+oG2w3E8oBTq8pbW
 5JXek6kWbLr6hMBakvxb4AwT0GXBNCGXsdXrCVeg1IgaLd+GdUQ=
X-Proofpoint-ORIG-GUID: 1F84mrdGbyymn3YWMIA98_gER9JU5Sou
X-Proofpoint-GUID: 1F84mrdGbyymn3YWMIA98_gER9JU5Sou
X-Authority-Analysis: v=2.4 cv=GoIbOk1C c=1 sm=1 tr=0 ts=68a74b8f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8
 a=20KFwNOVAAAA:8 a=ghP1IWPhH_UCEVFjPpEA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:12069
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CECEA160013
X-Stat-Signature: 831k66g9w6yeqkutsr48jo99i3shtbum
X-Rspam-User: 
X-HE-Tag: 1755794345-620970
X-HE-Meta: U2FsdGVkX1/ORKFs8PcyOIw5at4bOi19kXAi1d5XKqk1QIhrZJdygjNeEdWR1LcuERKGGmBqCg6r+BTVK4l87hIVTgXoGw8NLuOJXr2gdxaLfz4T6ivr/iTjw9MUGhuNKXY1utOet4dwhBBIYGwZVII89LOoQBEKgQ9s2XTzDWn5XXP6Z/+YFyZxk/LJC4Tpd0AK/K5YE3VjYJuC+Qn/MogKY5xPdf63yZHJbCBQnsFkNQk8+dJ+bB7FCUqqnDdWDY1lvYJk2HijYZCFZMC5ByG4QykcBfnufbmoOSSkN01rzkVVKqnrjp5nAMFHkaGmbL55zkENCaoWunRZKzejbHEfKPaRnHxZoGwzPSi32b31x7AGYvZtKsEKsWaZw/C0R9W/hxl73P0K42c3HOZEWJYHu9t6pZCnrq3e/0NQygm+TQpAKIWbbtfpMI/RloimkCWsNXaqH6OewBK85uKOK6Nxf8FmHwFXREstBNZClrNruZvH11AEhado/KqtYRZ1gnWzWyIcvpxtIBETQlJTSLqbfc74GRxEydrHLSyRytaZJwbEiMommv9U321rqBLmczLAddM6WVwFqwUxSqLW2xO6SMfpK1uPuAslDVwjsY+0gSgJBAXqLpvcqvSHw+6R9T2wob1YbDkyMGONNZzgkfAMy0VkwtcyRmUUUZSMDJ+wpvhIckiwHdw59YC7/UXs/dxTih+slXmf6gyIf7DB9nFY3arN0IMfP/bnQ2f/FVsSMCTEEfS+FVbybiM22OekzJgkiGQLk4Vqhva7YRLFRiC8VoboLoVV9NTJkNPEgdLinZ/fmyHHA6t6760YYcNb9WfuLN296Ji/xVzoJAn73ivkLe+ssCwWrP2uuUl495nC7pfS9CofiD/tJLi/I2uznSJ0RHVdvF1CzzEVaKybei6RfZlw+B8SY+QLVVdxNZav1gdoX62tVCSkMxyn+e5yGVP5+6s6vs8VuiqOanU
 vAteM48x
 +okAMvl0DCSWGJnsh6qwRwrb9n5cY9KYiheCSErAgpc2EqsqgDIvF0fFLGiE9f1qY4MO8EPwcM7fZ+ocCfaHcPEyX/U735rHTH+F7BMefa4EVokKrwN3NK99JjiHU0Y9fdmB6m5X3BkiJ8sGyv46w6FIajxZkY/5tR4zC+H/fGjPTAqw8nAAwgV18j5nrG6TNH/L5j3FKzyQEeee7MMP1L6jROCUPLD0wj0vTKkEkEwNPvie3MOfiofJF6ULlEW7wFKtDIwRf8zCm2josqzPUriu9JT2bN2AEXYEeoh76dfQElgjwGQYWKFoy15Lc4OIwmBxGt8YeidloZHURCBtPkKDWut1LgHuQjAosgOs2SyhP7Odjyj0O2bp37/iQ4EZ0jnLfk4HW0DLUK48U0Sv1xJnOpzODYR3yrdVUnB/z6HPPGif35aSjoMgmZm/KIV8GwOP3XxwV0meQURjiYr4uOKnQsKaozT3LrmcsE1MOLurV598v5qYTAQp0IpaOo2ZBENa/oWi5Hio7nYrnhM3UXn6ZcIhtZPP6LYREhlEGtnW7xpmpgaWFzqMW8F912YjPbmx/Mj9TDbWgz7Uo/crB5whijKBOIWwQnEjJBxd45Ab8rqc6DfZkBR06+LqDiB2dZvJ+pUq6QU3ZXQRxDk47mX8HLf+7frEsC7c4jSNuVd5iKY+VH8GR3RLuV1nmdBEG8vcnMkVJ8VevIti1RPaoqa9bUqUmOSmZCQC/jF8E0iIHgNBztzI2uEjIMzbXcmnZJIEg1mKjdaOfmBH4ESiH1tegthjy+/zdYhYNhcusVvsGVsNyb+uUqmaTQNyoEDAVj4s6zQZPEjk1E6AMpbF0qcXgUFy2bdjhiEGdFtyun0RN8KJyaJn0YeL/JSp4AilRe7I1Wa/ekuCrLwI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Dev Jain <dev.jain@arm.com> [250821 11:14]:
> 
> On 21/08/25 8:31 pm, Lorenzo Stoakes wrote:
> > OK so I noticed in patch 13/13 (!) where you change the documentation that you
> > essentially state that the whole method used to determine the ratio of PTEs to
> > collapse to mTHP is broken:
> > 
> > 	khugepaged uses max_ptes_none scaled to the order of the enabled
> > 	mTHP size to determine collapses. When using mTHPs it's recommended
> > 	to set max_ptes_none low-- ideally less than HPAGE_PMD_NR / 2 (255
> > 	on 4k page size). This will prevent undesired "creep" behavior that
> > 	leads to continuously collapsing to the largest mTHP size; when we
> > 	collapse, we are bringing in new non-zero pages that will, on a
> > 	subsequent scan, cause the max_ptes_none check of the +1 order to
> > 	always be satisfied. By limiting this to less than half the current
> > 	order, we make sure we don't cause this feedback
> > 	loop. max_ptes_shared and max_ptes_swap have no effect when
> > 	collapsing to a mTHP, and mTHP collapse will fail on shared or
> > 	swapped out pages.
> > 
> > This seems to me to suggest that using
> > /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none as some means
> > of establishing a 'ratio' to do this calculation is fundamentally flawed.
> > 
> > So surely we ought to introduce a new sysfs tunable for this? Perhaps
> > 
> > /sys/kernel/mm/transparent_hugepage/khugepaged/mthp_max_ptes_none_ratio
> > 
> > Or something like this?
> > 
> > It's already questionable that we are taking a value that is expressed
> > essentially in terms of PTE entries per PMD and then use it implicitly to
> > determine the ratio for mTHP, but to then say 'oh but the default value is
> > known-broken' is just a blocker for the series in my opinion.
> > 
> > This really has to be done a different way I think.
> > 
> > Cheers, Lorenzo
> 
> FWIW this was my version of the documentation patch:
> https://lore.kernel.org/all/20250211111326.14295-18-dev.jain@arm.com/
> 
> The discussion about the creep problem started here:
> https://lore.kernel.org/all/7098654a-776d-413b-8aca-28f811620df7@arm.com/
> 
> and the discussion continuing here:
> https://lore.kernel.org/all/37375ace-5601-4d6c-9dac-d1c8268698e9@redhat.com/
> 
> ending with a summary I gave here:
> https://lore.kernel.org/all/8114d47b-b383-4d6e-ab65-a0e88b99c873@arm.com/
> 
> This should help you with the context.

Thanks for hunting this down, the context should be referenced in the
change log so we can find it easier in the future (and now).  Or at
least in the cover letter.

The way the change log in the cover letter is written makes it
exceedingly long.  Could you switch to listing the changes from v9 and
links to v1-8 (+RFCs if there are any)?  Well, I guess include v10
changes and v1-9 urls..

At the length it is now, it's most likely a tl;dr for most.  If you're
starting to review this at v10, then you'd probably appreciate not
rehashing discussions and if you're going from v9 then you already have
an idea of what v10 should have changed.

Said another way, the changelog is more useful with context and context
is difficult to find without a lore link.

I am having issues tracking down the contexts of many items of what has
been generated here and it'll only get worse as time moves on.  We do
our best to keep change logs with the necessary details, but having
bread crumbs to follow is extremely helpful for review and in the long
run.

Thanks,
Liam


