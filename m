Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A4B8D1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:19:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F276D6B0089; Thu,  8 Jan 2026 12:19:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAB496B0095; Thu,  8 Jan 2026 12:19:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D38316B0099; Thu,  8 Jan 2026 12:19:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BBD136B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:19:51 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6BD0316018C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:19:51 +0000 (UTC)
X-FDA: 84309458982.23.EBCDB3C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id EF07F40016
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:19:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KSz3NtMh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oFCRDQxW;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767892788; a=rsa-sha256;
	cv=pass;
	b=OEEoFhDuEbPjKiwEuOrBbzPWJynyroI+jCQs45l6oWvnHw3mSzS6ndJDt8dTffsyEJndlr
	HU2NhcGcrtEqgfLd5uhzfZzP0AuxikVt6u54QczDiKxy8fOUr7XJrWsrBmZ0Mbm9DSDvTl
	GXeU8POIt7ib1Keb9Wa0Y33dMQ3ZrlM=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KSz3NtMh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oFCRDQxW;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767892788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RcMgDSe29BQUkAVz+nIbUeO664MT21WBeBhkXa9QDCg=;
	b=SBGKIVo5DoOc8j3prmexIIcIWup7akvuF6y6+3JQ0gzR1wR/2UCKonp/uMmwhq0LfN35if
	KkHGsD6bjInrxzTxeXyM5xPaIvMId06xbK/Nc9pMwDgRPerw6fNGBw0n7Pc1w7YTz1L+TD
	Y9Of715iPAXjpVrEn+frfB4CSlbWSls=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 608GtSnq984549;
	Thu, 8 Jan 2026 17:19:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=RcMgDSe29BQUkAVz+n
	IbUeO664MT21WBeBhkXa9QDCg=; b=KSz3NtMhhchPIoD46EucSDrG3bTaLxACoJ
	V89n5eQyk2ayfu240tvuoA3sG6WnzmYs8/iK8Y5cjWoJQL4AZsbjPsSYge7mzyx9
	5WdFB/yR/u/I8VJGO2lTYsl9JkWAiDR5t9SV8Ut+8DjIoKDupB3h63ZYE1JMXepH
	m7qkg73lnl0hMZR+HYbbQshlGfhZQi4KgxQ313x3V/phRKpLjDbQhWTpxIvZnAZj
	1LBwNLFfqbcxyjuFA3o9aW1GMUZmEtGOhm2CSG9rFozBojq+H5HuxRfvOErfOWiq
	dZyk1781mmPVbCf41ad3thrNoLsU5z8GNU9VxA7jB+Kq03Vq01IA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bjgh6r19k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 17:19:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 608H7JEL020382;
	Thu, 8 Jan 2026 17:19:11 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013009.outbound.protection.outlook.com [40.93.196.9])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjnbrg8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 17:19:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XApnjfHKZlL3V3qT1M+P6ypWuxeZEGjSuqu8L5xtg9i5N09+C2CaH8OutQxPTFTr9Bx5We5Ye7N1jNtxgF4NM+HTpmamvTddORdKo3hop3H0As2xKU/7GrWcNLBmKK9kpedSzAW6ZtGF02rh4W3AS0CN8joJlqzDt2qWsAHQF7+VZc6DIxxdeUm01oVtnO382K9uhkHC8B7gYbSHZUr8KIPiNtqNr/DWbZVuoHVIV8Ad7IE/9zT6P4uGqN3dNN9VrDm2nzP8HTf1M+hucNsTahxC3QseRGtuoqAewEY+L6HKt5+AASedzpQTREKiSj2WAkbGK02OvXPga9tfnYnkDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RcMgDSe29BQUkAVz+nIbUeO664MT21WBeBhkXa9QDCg=;
 b=Rfc8cdE6GgqONgTVjzCuPLvXXVwp1ROc/vMKD/dsMXRETHCCRwMwbaDLkEPRIj2/36e8imURsHxruX4pxarbygnykwUIX1hEtpvtc/O3qO3JGJfGDFp8ctPjXzA2znDeQlJCAPpmb0rtuqHFkmn+DPqEOKxasGTF0U/ftnwa+/lNd63WowjOhYodfWKjhSoIu3xfYg1RIl1Gxs+esniWRolK4NQyCvzdcPh8gEKrwSByoX9OqB3OQryziHlXmRIUZgc7nrPsd9u/8o33c9zibEdBhrsLVRn8e03DGEnKXbnpVJocjlDGSeIFHY8yFAsKoQvCggzVjmz3+qPN+DoT1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RcMgDSe29BQUkAVz+nIbUeO664MT21WBeBhkXa9QDCg=;
 b=oFCRDQxWVGwdp04RONlra11GN0jePJJzlpOtD0WM1rccfzbznpMlihNudjAObX/yoW0kBvGeExnw2meWZe7tH5JHH3t6frzsJ4MRNohUjqgjV1TyrERs42E2fqNwLBFxgDDJ9IBl53wp0dxNv8XJ8EsXlLo7sNfljA3huqJ3xM8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN7PR10MB6524.namprd10.prod.outlook.com (2603:10b6:806:2a7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 17:19:05 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 17:19:05 +0000
Date: Thu, 8 Jan 2026 17:19:07 +0000
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
Subject: Re: [PATCH v13 mm-new 00/16] khugepaged: mTHP support
Message-ID: <e54b6ade-e2a0-4a68-93c4-23af85479567@lucifer.local>
References: <20251201174627.23295-1-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201174627.23295-1-npache@redhat.com>
X-ClientProxiedBy: LO2P265CA0440.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN7PR10MB6524:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c5f2e77-6c4d-4747-a1cd-08de4eda066c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JX66QBxUDkf2Nl0HQ/73Vr1IFTX8TiSn6gMKw9eByOf23m9TXwK4kaZGVZPH?=
 =?us-ascii?Q?m0HX3SxCOe2qAZwGHtpUejty3WUDXShlGRID97al1X/tHVkOv1TOqpQ8rSRC?=
 =?us-ascii?Q?4rCGESdDv7Rq1Jsa95M1ehY5sPYar4FeEellbwj3eNDfpLYdGML4Bgo0wG10?=
 =?us-ascii?Q?IsWdDESJiWY99+WgXJXaIFOOeuhgK9l9MvMxdcqaECrW64I7onRSkyngS682?=
 =?us-ascii?Q?7WcH3NgJBM+Ff7NBVzDCJNPCbvaQbEO550daiqgtwPYVCCJ7fCzMRo52cFFt?=
 =?us-ascii?Q?4xCZLWoBOYJ1+H12A/+RywLY2fojE2NuruKd3kTDk0UoEMzx10PlZlztuGog?=
 =?us-ascii?Q?yX7iZcMFBREhPkl8UPS0ixCFT6bBpNgEp+vDxH6kdCR2svwAj/KCG4tZ5wPp?=
 =?us-ascii?Q?ID+BapjY8Uy85cCLb203Ki5btAEE12iHlWEuCG5rNcQ47GTLzMpL+jTgzcnQ?=
 =?us-ascii?Q?ej/HWVL4RquRNG0HCnP0Q/JA6+QlCZEnQyZAyIGBe5zxwQ2D7wCzxBkXgLAB?=
 =?us-ascii?Q?O/+LJtpcJ8OmkZGy+ecsrVLDN779bYnTt7btDFP49abIGsqGLECgg5H7KlIA?=
 =?us-ascii?Q?L0kknJeLCvM2EF1e+v8bELzroxrSDuJXiak0bTnG+mHcm6KnczHIEpS8t5bF?=
 =?us-ascii?Q?nmVdNv4lYYvpIZ6GBoz45+4Sj3btNHGkoJ7z+6E8I/U8B+waSB6b7r7ptAy3?=
 =?us-ascii?Q?5IvMgTxbbReYoU23wIcNn6nMBs0D27dVqBoEyMj6hp1W6Cbb1319Vw5K8zrK?=
 =?us-ascii?Q?MbuSh/feSH4HHgvDfGylqZdtCESAI8kOA7GJNjPCmYLDOZzxc/UnG7vUgXSW?=
 =?us-ascii?Q?MmPNYuhAaJMyzCW+61sWlAffX/Y9k35HQ2rJ6kGTKRQ8Vol6udKkYpV5aEa6?=
 =?us-ascii?Q?V0Eo8FJJOYcIXMRYYaPJMnwzzyY+NvfGMueszXQAsTQOctrTsEo2Ufv/PZ1k?=
 =?us-ascii?Q?uPa6Edgf44tVaRK2Wkh5hWEJ1EOqpLaTD/C0AeRhxbgBzVMUEqWdlfmcx2MS?=
 =?us-ascii?Q?tdLa0W919fJrDDyTAwwYgow6bL3PYKnO24jOHgPOgnkM1IeCnko/YUSUlcYs?=
 =?us-ascii?Q?VZo+A5vCSqjIZRLBVvdwVXJzi2xzmv9L1tk1P5eKtxAUtzBZR2B7qcUAE/EN?=
 =?us-ascii?Q?L7Qkf0pugRgJEdvP/4THB0qPtLSekfBzYj6Wkg4ocKSM04aFcaCAXjattID3?=
 =?us-ascii?Q?giBvJjN89d/UxriczQTFgiSM5GYlHZJxUW9Qae95s/bFbIZ6DuzeriMXOPmc?=
 =?us-ascii?Q?L4m+2un4kClY+lSP12lJ7N52+rqe3bCLa39TK5Gz7xYrp6tb82Xn6zh/yz68?=
 =?us-ascii?Q?W/HbnP25Bn2SW9Y37zI2M4p+q3b//Wu+3CIhjgf4VZw3rZ0i0ETzYJ4JJwBQ?=
 =?us-ascii?Q?OM4mc9N3FwZ/kvG08g523cdxOJfT0LnbgTuuiS6X8ivja8zWDOJxG6p/ahaV?=
 =?us-ascii?Q?oqHcmJQSs4NhLPas5Z/BrmWqTZPeddmNPIsfoRxaAo2Qzf8fcypdkg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vKY7/k+r0tZr/0elM5rzT3wI6mGMw7mqk2ahymWA4i+/BFTjkTmOaDKXIbUD?=
 =?us-ascii?Q?FqTMFaTdHBadObZ+vT6hewZk+rAlgUmKQpwRoq3EGAT44bfJJRWrxpfZLywI?=
 =?us-ascii?Q?ZePA6r9wvvb1hM6elMYPB5abZEXYxKy8wZCdbcUsuvJKRSVLSKSZNunoUtwS?=
 =?us-ascii?Q?ADZ6uYhvokQ8tOhYOSg4H2MMUJfEEAdm6c0GeTtOMLA6IXLNBxsmW7TZbEG1?=
 =?us-ascii?Q?FwHEM6QBs6Q6I9fKvJmhHU0s4ejMEZvRa4U6nyMxplpQSbfeGUCs+6tbC8mY?=
 =?us-ascii?Q?vcc5SA93YXUCHO6UkwshKK/YVQXGUI20QWHLZV/5pjRErhttLw1zuspul0sN?=
 =?us-ascii?Q?FSA7RIFOvFI3F8FzsEn7j+fU5QAeDgAukU+P30uX8S+92fAeDUu3V741EX8p?=
 =?us-ascii?Q?Wfm57EXDfMYVnTETDuvuBwoA/v+JjcEz8CfjZYjBuwXfoZHVEqvtgqP56tJC?=
 =?us-ascii?Q?59jPOf7eXnMOAqISJqc3x4KUy9GaTHJHMrxyIFsXQv0nd6o2rULouUeqCID0?=
 =?us-ascii?Q?9VoM2PKv5EX/cNZ8mizUj4GuyXPM1Z+FlsfXjJwdKJP2mU8S5Gy9Sy5mxZ6d?=
 =?us-ascii?Q?HFU2+EPnNVBcA5vNLf8SHd0KVpDcDsD0Fl84BFN6Knofs/KnkAoK22mScKeB?=
 =?us-ascii?Q?9Z2Ytk3q9A7yYSzc9HN2Wq2oULKVAgn/CETHve+QEY0XtPYp0+aGwlvJxJ7D?=
 =?us-ascii?Q?7gc8Nbt34R9oWLlE81bnBTmSMVV+PslFs4CAVx/1r4cJBQgVbwd6bkFJrXHD?=
 =?us-ascii?Q?2e3njhvyf/NbJBqXGtNi+csS55w0D5Ltk/lAYRNNhwhsNggV/2WuSXD2Zr6Q?=
 =?us-ascii?Q?cbszXgWCFQfB8m03LzF6792BhM6hWUEierBvCJ54BYmMbH9fsd+jU83d6XkD?=
 =?us-ascii?Q?SwEUkryn7JN57kJnnhbQwlhhMwoNoN/pepoCgnfwsSwD+T8hDgKgjURjoDLb?=
 =?us-ascii?Q?gtftS/a0TQXHRTuXFbcfnqcrpZRyvQRmlCpUpOjk8IPCscM/B9tI14G5+dCG?=
 =?us-ascii?Q?5NuGov/HHLq5pmw4i19HQURaQSJ3VcV8tYVS8O6XZq8EtLHrYD7lbOcZ3ooS?=
 =?us-ascii?Q?a3bn5+2MB/1HagWiRK2cqPa2+dxfJaS/EWCs75fRjwEeruueuadbEBjrvIq4?=
 =?us-ascii?Q?3Hwm+fwjU4b6RB8tuIWpeV5Vg5hFZPbb63qNcHEJ0FGob7wntUtqxJQ9SY4k?=
 =?us-ascii?Q?SMN/XKDg39AdlxRoGvqSJgjRy5NnV3KbcyymkI5xp9Hdu8VkfTH8qrOLoV8Z?=
 =?us-ascii?Q?37dt81Z7fxEMBqGKOwZl1MyyaGAEKIBWirNNGXPjGK4B2e5HYXvyTHdYdBC9?=
 =?us-ascii?Q?qbxUtWicgLbQv0cplcEwfD+Z6drK8upee+QSEXTs2rdcoRHiroHjGCEC/uaG?=
 =?us-ascii?Q?LBPu2CwcSjx1gPA85bKGkxAHSRRkPVyF0C7vsZSMG3LvvPhbOLtAIKspYf3a?=
 =?us-ascii?Q?6gExuaZEesugWQ7o4hhqz2RVbMTJ3DEEjePbV4iveX7jPIrByqY3rIxXiup1?=
 =?us-ascii?Q?zydYQ3b8VTCvmq3C/x5vvvF3vReJ5uFsJaWSIAtVZhlu7a2n73xZUgHva+jw?=
 =?us-ascii?Q?mwmk0IJSSRTKnZAts1woqIlTWuXUVTWo22spoR3mGyJoY7kRK9afL1GnbyyS?=
 =?us-ascii?Q?ljzd0W47uKPmmbRg+SSRavFNqqljCxoLeiUmdkYH8IDCZhhdWA7gRZcYxOZV?=
 =?us-ascii?Q?gxI7ZV+Mq8ONv/Ade2dG8sCR7KxYivHcnpxSL8xa4C9FdkEcQmxyPxMl5bxE?=
 =?us-ascii?Q?jU9T6TUgzU4ukBBVk+uifdGmcLbXT+4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hK2HWRz/V4rXxaZle7lKMG1gH961iRb58U5Y0VJVyjRiqFtaoS+B8JH96/HEFpYDp2+pWxmmOjnlj9E83WQfT1HgfFj+U3yo1yf3ZT8Or0atHA+FKjitFhAcXicZNOPI0eBNnQH/mSrjAlupJT/EcrBB7r29PqHsK+CodZCK2jSbfmErk0etJFj9KG98HJfvePqUpD71ep2N13k/r8rbazMXyYUFnJaLXSZWXPtJIWHctpbYMgmQV2QTwQK/n/VuM+QaiXeWMxnEBzScZltvCIEPZH8e5+ukJnDjDpq1kYlYMWlpvJ8xaAKjNf12e273L2rUjVRcn1TY+2bOLsSUtx0PE2pObFZZk7rRBNMcXKEnTeuj/3zv7T9CrTAkxVKwFXyDKUP+Rnpn25+50HPF8zRaTfrLUCa6qFOX1e4MJnuB+f12SuZP491N5kZU38hJ7lD5u9/Pbc/3Gz4AYulfyZXhlALHuXT56hFdRVEMEZ9ohtHKtqRN8reN6zyngiUQuJ8QnET6n+qTlzYfeBfUGbOzDLUnu4V00B403PHvjSsE+PeFn98inooQ8l/DYfZdyFfm2WxpOa8WCP3r2nheiq1nrCB4SIpQPpUA/GYXVtA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c5f2e77-6c4d-4747-a1cd-08de4eda066c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 17:19:05.3078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wt2kNqCLOP3S/AJTmy5v84hdQOLYseCJ/ZufwUwA/Tg3b+qwlzPbFcQgUAXqa2giTdnEtZUHucnyTyrbaOvU6l9dAhfFbB6cYRYlYKBaGB4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6524
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_03,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601080128
X-Authority-Analysis: v=2.4 cv=B5i0EetM c=1 sm=1 tr=0 ts=695fe711 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=p0WdMEafAAAA:8 a=feYJxv-PvuhrjdhfU70A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12109
X-Proofpoint-ORIG-GUID: hwO2s7sH7JB_zEVuz_V-6vZZWuD1v7KT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDEyNyBTYWx0ZWRfXyL4mMRlMuc1G
 jy+aC0EwfQA84xLat/KFmrQ4Xktl5iBG4pOGw3e6O5cpLlrqMJB7Z2oTKFg12IMlTPogmkhBxF3
 Ik7D7lXJf6+TG1PlzUW6MbcMiO+T5uF198lKlqgP3J1t0YqGHHkguPuxkUuw0DT7ijOaL9n8RUa
 lW2rJMEfctXgB1YgqbUfJESWr6wBZGn4f5uPzHmNtskFaG9p9XwAxV/Wmt9UOHDjJqH0+eZSYyf
 3ue8/yp1RCPmXI8frvDhkN+NWiSLvaJs4MPxcWmyT4pj7pY/Uxl21Ix1kY1t9sqZ0DwfvJT1EyN
 mqqJ0jp4qjYtBSenP5iAddAv/ci1mMwgjesCEw6xrGtZx8yuay2Xwvvd3ZmZOZmMnZasgwZ4M8u
 tFEZb+KL4m9F1isQDlnTO4bmUll+4x+TyP3YXZDbH18fQUiAclC16wWtCo002ikgDKmHam3Pc+j
 vy/+sazlr2uPuGEAWvOdC+1QGaEtfxYZMZaYwY2I=
X-Proofpoint-GUID: hwO2s7sH7JB_zEVuz_V-6vZZWuD1v7KT
X-Rspam-User: 
X-Stat-Signature: f99yz3a6qhp64w71dwmqbksr4qum9363
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EF07F40016
X-HE-Tag: 1767892787-95014
X-HE-Meta: U2FsdGVkX18Jp6aSn1RalGdhyinksiEFIPwL4PqMNlK0EEu+fAtaVrYOt+xSH+7hQzelgLNoMRGc5Yt6nATeo8rjVkBsGWebmuZTxF1RjN7eGDrzPk+b0jzHfgLTNg6WlKl4mgHfBA9IbwjlZ0htGQtLemUFP+KZ8fy2m/OPKQWvecddlnl4UZ9GtZDe3zwfi7hUsRO4iwUdXygHjoWq6fK7VFAbUDNQrJRBR1bh3P/iBOck4sPjjanTuuXq0srvAGc8Sc0yy/Lx4MIUJGktYCduADFpyC38IZbsZE+33ru6m3rbrgKs1AscG8r0+Dyt9Tra0q1WSi+eBVA0+jrNAx3UrF49twjAOsd7L46VOy/3Btx22jqZQOJti0WneMMyASRpBGF3zUe8wpWX1U6uiP2Kobq5nEye9caPEfNPQ9vjxU3Bhhvzf3dliEdOM95y0bKwvu9nngvmx6aAevLkjxlw+TboUye5pjXdA7wJhUT2ar+S8WhVO3cK9vka+6SGOg8T6czCZKt4WJXYa1uH7w3t6KpGFQPY7WZtFWtMVd9piqp0VyWyKynRI/G5+ETA0ZaJnxxMgSiNk4LqG8FKcX58q/Bnsxlu2M5ZrcL/bR7S+HHqpXB9H4F602ovbbEa9qRGLKn84TjpdZsmjQplpVd3kv9DfZ7CTcZZr3dqnIbMtgLT4548I5NXAvr97H/A61RoEu/r8ePZQln7XLD3w8poTrFRlgwG07uv9rCghRnSB3kQmGSs32AW9M5g4qxNLSlNdKRRVpENIwYrg+n8vQIKZt1gb67pkh9CME/j6zvo6a3f6CmRYP1dCUlBOi1p2gtNCB8nSdTFMeRFBJno8lt14PEJ7QlHow/4YDeMac3vhFGXfIDa6eKd3mjxgwNvZXfpbRILgYPD2y/SPFAIn77/aU8Tc36I/5X6flTD6DAWprRwR9pq5WhGo/FyFid/7Q4J0YDCaG6sNR2qExJ
 oI4rwO1h
 SxALxV9zadwRVHEYic53rdbnHq9dcaY8u4u85qh4AppNWtSRSu25bk9CnRZvoPHNidjadO8BJnHmHkX/ecve9/mkvtC+LCWVIa4KtjibuKnD1EeMfj14QFM4LG6IJPwpk01U0b+gHFlgghHN2u9h2inQUZmZDAB/tN0FoBIM5oNwv6VHuRE+o3CYswGC8AsjEzvGG8D4wP0A4Z3pMMl4+wJ4bOSpaDbZ3B1mGBVi07vuBe9W5h4cBtVP/gracAU0YFMmUu/VSrFTCx6ZVfya+4en9V+tswTgtK0DDjaRHY+pf4+K4v+rLLFvtWaXaVSeVmgU6REpfnherdNZ4RqiCVPjvBpPuXbYxNlr+YQ8SKKcBMwP0G78dERprnpHnT+klkeQ0GFlO/K1/Z4XUgqJC/OxRzlMBxyzZI2Lvn9qW0WqjvwQ+yd3FpCS6gSEGMnHhSF6XBLlP85v/dJ1MH93Xdv9goahB1apNVlA3RbfrCTONf20eZlLLIicdSjnH8ApnM4MdkUIAsIvDna083kmHRsXy40DFR/3Cl/09CQ6k7KUhMSxvWJX2EL69Vb1TiSHTmuVpNScZDZrwZ4cKu9y8XrPpGM0uErBvfHgR67XhqFFln1TafcUuJSpcy4eWnMWnydIjRwM0DjamMsB7Y2ZF5zYZGeTq9STmCbJbVKJQKs+RSuC50nN1PdQULcjeReHpYj5jnXKFndvdIP93YAkG7F+072UqL5MaNmtQ0lBb1D8XjD8r+dEM0X6h8x9iu4w0XQEzMccaMt8xGf93Xj2Vnw50HWavwt17XYpI7S1GoNrcRns=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(Sorry for multiple mails replying to same, lei/lore are broken again so my
setup isn't working properly).

I tried to fixup the conflicts here to run tests locally but there's too many
and I messed it up.

Could you please resend this series rebased on mm-unstable please?

Thanks, Lorenzo

On Mon, Dec 01, 2025 at 10:46:11AM -0700, Nico Pache wrote:
> The following series provides khugepaged with the capability to collapse
> anonymous memory regions to mTHPs.
>
> To achieve this we generalize the khugepaged functions to no longer depend
> on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
> pages that are occupied (!none/zero). After the PMD scan is done, we use
> the bitmap to find the optimal mTHP sizes for the PMD range. The
> restriction on max_ptes_none is removed during the scan, to make sure we
> account for the whole PMD range in the bitmap. When no mTHP size is
> enabled, the legacy behavior of khugepaged is maintained.
>
> We currently only support max_ptes_none values of 0 or HPAGE_PMD_NR - 1
> (ie 511). If any other value is specified, the kernel will emit a warning
> and no mTHP collapse will be attempted. If a mTHP collapse is attempted,
> but contains swapped out, or shared pages, we don't perform the collapse.
> It is now also possible to collapse to mTHPs without requiring the PMD THP
> size to be enabled. These limitiations are to prevent collapse "creep"
> behavior. This prevents constantly promoting mTHPs to the next available
> size, which would occur because a collapse introduces more non-zero pages
> that would satisfy the promotion condition on subsequent scans.
>
> Patch 1:     Refactor/rename hpage_collapse
> Patch 2:     Refactoring to combine madvise_collapse and khugepaged
> Patch 3-8:   Generalize khugepaged functions for arbitrary orders and
> 	     introduce some helper functions
> Patch 9:     skip collapsing mTHP to smaller orders
> Patch 10-11: Add per-order mTHP statistics and tracepoints
> Patch 12:    Introduce collapse_allowable_orders
> Patch 13-15: Introduce bitmap and mTHP collapse support, fully enabled
> Patch 16:    Documentation
>
> ---------
>  Testing
> ---------
> - Built for x86_64, aarch64, ppc64le, and s390x
> - selftests mm
> - I created a test script that I used to push khugepaged to its limits
>    while monitoring a number of stats and tracepoints. The code is
>    available here[1] (Run in legacy mode for these changes and set mthp
>    sizes to inherit)
>    The summary from my testings was that there was no significant
>    regression noticed through this test. In some cases my changes had
>    better collapse latencies, and was able to scan more pages in the same
>    amount of time/work, but for the most part the results were consistent.
> - redis testing. I tested these changes along with my defer changes
>   (see followup [2] post for more details). We've decided to get the mTHP
>   changes merged first before attempting the defer series.
> - some basic testing on 64k page size.
> - lots of general use.
>
> V13 Changes:
> - Lots of minor nits, cleanups, comments, and renames
> - Bitmap function simplification and more helpers (Wei, Lorenzo)
> - Max_ptes_none (0 or 511) restriction
> - commit description expansion
> - list all reachable enum values in mthp_collapse()
> - Fix ppc64 compile error due to using HPAGE_PMD_ORDER (replace with
>   ilog2(MAX_PTRS_PER_PTE))
>
> V12: https://lore.kernel.org/lkml/20251022183717.70829-1-npache@redhat.com/
> V11: https://lore.kernel.org/lkml/20250912032810.197475-1-npache@redhat.com/
> V10: https://lore.kernel.org/lkml/20250819134205.622806-1-npache@redhat.com/
> V9 : https://lore.kernel.org/lkml/20250714003207.113275-1-npache@redhat.com/
> V8 : https://lore.kernel.org/lkml/20250702055742.102808-1-npache@redhat.com/
> V7 : https://lore.kernel.org/lkml/20250515032226.128900-1-npache@redhat.com/
> V6 : https://lore.kernel.org/lkml/20250515030312.125567-1-npache@redhat.com/
> V5 : https://lore.kernel.org/lkml/20250428181218.85925-1-npache@redhat.com/
> V4 : https://lore.kernel.org/lkml/20250417000238.74567-1-npache@redhat.com/
> V3 : https://lore.kernel.org/lkml/20250414220557.35388-1-npache@redhat.com/
> V2 : https://lore.kernel.org/lkml/20250211003028.213461-1-npache@redhat.com/
> V1 : https://lore.kernel.org/lkml/20250108233128.14484-1-npache@redhat.com/
>
> A big thanks to everyone that has reviewed, tested, and participated in
> the development process. Its been a great experience working with all of
> you on this endeavour.
>
> [1] - https://gitlab.com/npache/khugepaged_mthp_test
> [2] - https://lore.kernel.org/lkml/20250515033857.132535-1-npache@redhat.com/
>
> Baolin Wang (1):
>   khugepaged: run khugepaged for all orders
>
> Dev Jain (1):
>   khugepaged: generalize alloc_charge_folio()
>
> Nico Pache (14):
>   khugepaged: rename hpage_collapse_* to collapse_*
>   introduce collapse_single_pmd to unify khugepaged and madvise_collapse
>   khugepaged: generalize hugepage_vma_revalidate for mTHP support
>   khugepaged: introduce is_mthp_order helper
>   khugepaged: generalize __collapse_huge_page_* for mTHP support
>   khugepaged: introduce collapse_max_ptes_none helper function
>   khugepaged: generalize collapse_huge_page for mTHP collapse
>   khugepaged: skip collapsing mTHP to smaller orders
>   khugepaged: add per-order mTHP collapse failure statistics
>   khugepaged: improve tracepoints for mTHP orders
>   khugepaged: introduce collapse_allowable_orders helper function
>   khugepaged: Introduce mTHP collapse support
>   khugepaged: avoid unnecessary mTHP collapse attempts
>   Documentation: mm: update the admin guide for mTHP collapse
>
>  Documentation/admin-guide/mm/transhuge.rst |  80 ++-
>  include/linux/huge_mm.h                    |   5 +
>  include/trace/events/huge_memory.h         |  34 +-
>  mm/huge_memory.c                           |  11 +
>  mm/khugepaged.c                            | 696 +++++++++++++++------
>  mm/mremap.c                                |   2 +-
>  6 files changed, 618 insertions(+), 210 deletions(-)
>
> --
> 2.51.1
>

