Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7839E606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 16:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mDKeqO69
Received: by kanga.kvack.org (Postfix)
	id 997D96B05B4; Thu,  5 Nov 2026 11:10:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96F426B05B5; Thu,  5 Nov 2026 11:10:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85EB36B05B6; Thu,  5 Nov 2026 11:10:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 629D96B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:10:50 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79B4940B26
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:10:48 +0000 (UTC)
X-FDA: 85401553776.01.1001850
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013003.outbound.protection.outlook.com [40.107.201.3])
	by imf30.hostedemail.com (Postfix) with ESMTP id A2AF780016
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:10:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mDKeqO69;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793895045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s9WCm9t0e/JQnnw8DKPRHqRxNcbpq5LB4Q7+plZFBEY=;
	b=KAM6KVZ7gRVSUH2vAfZ8hHxFodtx0twpkDeRrckDyzZYV2FqmWS662V5UTMTvCLZfE9rCY
	BefCNV4ew9xJKCTPOhQ7Dpgh4u8wo+YUHBF9gzUQsD+V0DTNwi0rUBthrdONG2+84HCTfD
	Tr5NJH1Khzwv71PzeLJ9DJ+alA6iAyw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mDKeqO69;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793895045;
	b=qxPDHepDJDeqtz37AvlKZCU7vPfsisvFpFpmBNMUDWte8h0WSXTWll43mBTqiotaOmu//h
	JW+JVqhHaBY/0msOSqTy0KhilfBlDka/3dYVqbYImppIJXrRTa7C3Y1ekARO5Q2L9CeMJd
	NBYDiAGJuqkFDK1j1a3P9HasbQfgCPw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZKrLfYeOYWZ9fnAAxVn6fFXLMn7uMFxKPEJ9XSf1EaEGLNefmrhOFG0w76OfXWtgrBOF1ihHY71ursp5Wb5/Dk6XDB2VtaDeDBU0VhpE1rEPkdqU+Sb96gc6LKL4FUPphiO0ODgrKYXqhtnqesCRLQY4Vk/ZY6el7vZ2xyNX5MLkK0YmRTEL2iWPDamNpWElTaI/oNW1PY9X/Cwe8V3jXBj43Z5pjilrUba5eODGcHmxICKmdRs/AfytthmUljZ2zeZvK8MlUyVREQoz/ka5xzpo0+tTXgdRSHuP6iPTUW628zUVQT072EilqQicXo+d2zyy0YRfSasL6aW7XOFImQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s9WCm9t0e/JQnnw8DKPRHqRxNcbpq5LB4Q7+plZFBEY=;
 b=LfGB8Eneto9FRyKAqY2Gzp6exfX3tC7I0vwEqGKKErtPkQz2Pkd9RIv7unYu3RPXGt6XltR0ZESvDo02wmMuITB597WocnmiYmkCUmH8fmuEYnDpLK7KCq5Cr8Scr4mPGRTHaTbeeOsgHeYfQq5GCS7z7In2GnPU2YjvPXYSgX42FtoxPAkFgWUR5+DjyX9q85O4Qxe3CMZ3gVbOxD630EliF5xpjovseee7LUbX9u2rPT/kajOaALtIddmBRbvLB8AuEKZ5gOfqex1k7ktsFOFF54NssVXDts7Op/7kry0Ov7QVNMwdvxve6hJIZCO4Us3VGaYBE7JqUA6AJt2FxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9WCm9t0e/JQnnw8DKPRHqRxNcbpq5LB4Q7+plZFBEY=;
 b=mDKeqO693u3NCdGCfF1gclq5uGnTBB1VZ6flbgZLqR+eIYKAT6mHGtvMAv+tioqvuMEngayb51OgJ4vjmyBAR0K7QxxiGIuFUNWKEijCH3a1lQhV/Rt86eNCyTTp3D7IoQCZ3FjHA+BsVbHCFKORMsoZQYfL2V1GTtXwQfod+Es5hesBXCiclWU3TpQjA9KqftqROQIl/UHK1/COBGZuKkQpWWmAhrw1jiyty+vlOjZHZbD0rRqKeqcSuz0yMf47UQLHb4k+2pitcbpIeAr9ohlqS8BsG0oB2ScjZITZmgOA9/OOGY8vgqmz6EOkfyf+91xHVRlrGsTjEqlMQY6zlQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB8765.namprd12.prod.outlook.com (2603:10b6:8:14e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 16:10:25 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.007; Thu, 5 Nov 2026
 16:10:23 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, akpm@linux-foundation.org, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev,
 baolin.wang@linux.alibaba.com, rientjes@google.com, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com, muchun.song@linux.dev,
 osalvador@suse.de, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
 bigeasy@linutronix.de, clrkwllms@kernel.org, nathan@kernel.org,
 ndesaulniers@google.com, morbo@google.com, justinstitt@google.com,
 Bessel.Wang@huawei.com, jiang.liu@huawei.com, mgorman@techsingularity.net,
 anshuman.khandual@arm.com, Josef Bacik <josef@toxicpanda.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH v5 02/12] mm/page_alloc: keep the pagesets of an empty
 zone
Date: Thu, 05 Nov 2026 11:10:21 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <264A6055-CCB9-44CA-B638-D38A3993FF50@nvidia.com>
In-Reply-To: <6c5f3ef1-188f-4a5d-8775-578dc2c84c59@kernel.org>
References: <20261101021340.2251928-1-gourry@gourry.net>
 <20261101021340.2251928-3-gourry@gourry.net>
 <DMK59DO8M3AP.3OTG2YR62D9WO@nvidia.com>
 <489b668a-033c-4161-93e8-15d6b9b28b51@kernel.org>
 <DMLPC0D7EWRW.EVYWUONVO18A@nvidia.com>
 <6c5f3ef1-188f-4a5d-8775-578dc2c84c59@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: MN0PR02CA0026.namprd02.prod.outlook.com
 (2603:10b6:208:530::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB8765:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b69d8b0-5998-40ee-1369-08df3b574bfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|22082099003|18002099003|6133799003|10067099003|56012099006|11063799006|4143699003|261026121527099003|261028144727099003|261026140227099003|261021121427099003|261102123227099003|261022105027099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	iSXN64PPiS+GJIdw7JS5nKfZIu/02WL9g+sZPH7SMqtZmnm/d4YgrlopJTg7LTC02diraEavGBDatGACuLM9SzBU8MQJBwIRSUW/AikPBprpZdbcMa/QP7vvQTEPgRB3dV6tt9DJHMcp4XiqRSN1UjM8PUiAiYJ4YUZeY9/TzgfaB1hoN1SU9JG2fV4Zb8pB4TJRV2XQjTBnf2IL2xmKs5gFslz+cntOK5fQgJcT1gFB+rc2U5HD5xOwRnSgZSTHCEusN0H/HFmz2+EoKH0E8r3AQqNz2EG2zNEUMPSlRjInRNaAteFmpGqYnPFlZAjCrydVLhAlkkN34aR5k3aChD5dPGvTspdSGgHbA4lz4wwJS3ftAFjCsesyUv3sHbVWDI12IQDypuKA3Heo6ngDJE+Dtqq44RUfbaUC+DKNqrUQ/4REXbcC6WjHvsjOML1d6pQ4zC3OenSGdv75CNducGvSLrYlvVX2bRqbmdW+I+uu2Onosz7w43dTrqIAvf5FWz0oR1B1yZUW+5tMhsrhsBfB8Xnxg628Ba3G8qEV+AEQzxgLGQ5D/xhS4W5vsrCcY0zzNwFcKvxatqAuO7cJULO02hc/ZMjMvJETFGILLq5fNZ0Lwk0ZBXwI0ewPu+CPEs7GVpzmylk7dQ01Zr32pGzN/Hx5Ye+7GdIyHQzy3EM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(22082099003)(18002099003)(6133799003)(10067099003)(56012099006)(11063799006)(4143699003)(261026121527099003)(261028144727099003)(261026140227099003)(261021121427099003)(261102123227099003)(261022105027099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t8myJywt+gKTaJjUrAI3l9fZFUZOAXataWFMGDjGzcbkXtU2XwnZRevTw1Ml?=
 =?us-ascii?Q?G17KKSHHW1bhPyDFKe9xb/7SyXgzVqlcaAn5BryDShDXgJLh5CG7XqLEmTMQ?=
 =?us-ascii?Q?rd+t8GOBbaknp3ejA6S67nur/YbBmBGuVY2fMbE7EUPmTpKnigS+CMJ/WiUB?=
 =?us-ascii?Q?2ilLyUcSNeox/+xbcYeh/4da7t6nnhQb/7dBpH3Aeq+AFmtf2PxI4J2EW4wM?=
 =?us-ascii?Q?W1XZQ5j/HYMHaqHl/XfdBvNPhcia4h+uRiIfthD1cU+IhC1HvSXC+AAFQk5h?=
 =?us-ascii?Q?KduEJjKOyzgZFocIS/TORN3rR8Id+xOXtnHy4ORGHuaSqp43xOloHkrdu76P?=
 =?us-ascii?Q?L2f7U6hlK7enxhMy/gVTPIZYnn3mWsQfqUoRKd6uHj0OPFaKfRiNri92iiKu?=
 =?us-ascii?Q?5pWWFBC2ZzcXhBrxxnQar6j88H65MgFgZSTCjn9epK6HcBvOz+6V7Fa32P0Q?=
 =?us-ascii?Q?mMEJWxaxiEddTUlCu7TQT+5nSHlBt7/+/gWM1pxtEJGumJM4+gAqBQGcgHJ+?=
 =?us-ascii?Q?kG5/iPAbkr3lVYbXTPdRnK00X91T1iDa9eJm0xszG4SZ6g0rzv93F4G/I+lf?=
 =?us-ascii?Q?tBldoCvuf+AADmQsFXc7GrWtm8D8ZWurN4+Lc66V1QNuZEtqZgB0pqINm/lu?=
 =?us-ascii?Q?DOqvbdJYHjeJ3Y/RrxE9CoqjSsgOGvjJEj+hsOS2LgjMIlIXM80aoeBHywYt?=
 =?us-ascii?Q?Kq/IbTGU42NEzolbxIz6BQe11LpNXPWqU0cEQR+/5wHVSppJbo2WI4c5irqg?=
 =?us-ascii?Q?qJ/UKuRwUF8LfPTaWQHe9Jet4ZJiOm4ioGhFlHj3tJkRYRGLYqwTYlxL0Fzu?=
 =?us-ascii?Q?Ngf6RY9/th0EaELwET3uEftiieeRsG3P2xuXGkfjdd1iEoEo6GdsWhFudHng?=
 =?us-ascii?Q?Eh4VZaS1/6K3QWiprvsllK6wWG1exQ3lh4+o1ii+amaR5txVkW0pCCkk1V1B?=
 =?us-ascii?Q?a+iE3qaESlqpw/RQC3xwRpw5Scd8LpsgoqMSQi97/9t7AzjrYSuT7aqQpWGM?=
 =?us-ascii?Q?eq/SnXtlQKgGagdll40Mya6Ks4v1dqJhod1PUqlptCfsDDQGcJHIUn5WMldz?=
 =?us-ascii?Q?VtPFNRQ2wt1a7X5BOTAqpb7e6Nd+H9ZVpEsm/XCr8LRfKQtqcIccQtAE6wUj?=
 =?us-ascii?Q?scflHIGPf+i/TV6Gyctqfp8jAZ0u59A96o/99q7HaOffeDqcw4GWxRSpt73B?=
 =?us-ascii?Q?/jHa+D57y2z35KxyS5NLg9658maVHXw7Nl4GRXxT5G4ovaYckrIJHn8yDBxR?=
 =?us-ascii?Q?Dvle8mmuy2zTBt/Yzu0eR+D5NnKlzlamdOzISP5/MEG2oWzMgU3FiFP/Suaa?=
 =?us-ascii?Q?gwrY67aCDWqiRjWxZunpjzaHwuGxohZR92Pw7UhWDWn8j8WDVtQ4hFKEDzv2?=
 =?us-ascii?Q?j65u+nT1Lb7xLKEvrtVu9jxSJa9AD6+nKaMjXyeKzOgjl4wm3fR0L0nGAC7v?=
 =?us-ascii?Q?CpgRxoo6OQk0BpGra0F50t4s4N9JFWvruLLDIgpuuw5J39bWpfIZhQR9ZmsM?=
 =?us-ascii?Q?zRbY0xEVV7vwFHtTG3pW55XrchtFfNJG+Iexw7K82kW/I7fEj7URcudXleQv?=
 =?us-ascii?Q?TdO8iBUSllWQHN8+FgEi+/DOUqPoPhA5Dr084mXqxfrSW5Ngg12pn+2Q78jL?=
 =?us-ascii?Q?FIqhSTEnfu3cxbfGlkyV+UpSOowcuHNTm16G0/x5KdAALv6K/MzHrQHtlGZa?=
 =?us-ascii?Q?NB0o+QnKUTiaTIe2p5MiUsLaxHzpdLVO7vXorAmxJZVfHNEX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b69d8b0-5998-40ee-1369-08df3b574bfd
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 16:10:23.4206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pv90dRN8qL/ZkeU2fkLU1Elq6QP1RVLvYfeQ7lkpICeJ1XKXPeMhk+GJpvo5/e0/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8765
X-Stat-Signature: gk6d1q5kueth4zqebh4xrif3gnykq58w
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A2AF780016
X-HE-Tag: 1793895045-570908
X-HE-Meta: U2FsdGVkX19fNQiod1Ka5jrGSFpAFYzPgeGLK6g7WqIMatQ/svQLbG4aoHF7VZpE8OO7SdFQtyOS/fv+TBugPTzSMp9of6jnVRzB9n8SS3ypbvSSfhTzYHTjKHVK8EnoSse1/V8IQRVMO4XR3Bfb1WkMULjaI0stXk+UzywDtGYLwiQMYAeLoo20VLI0paKs/suIrp4af9vT0NM+hikX0bQQbD6S5g35qnWm2Xmi9zNandwBAZpWe5RNLlKRq6YuUnjd4PzFi8K6tM8J1viDy8TpaCEaiLvsfyJnO6TjP72Yb790eHasdZ5rfFSLNFjiwFtsAZf3zVYTstBoIo1xETSD/62BvDwTQFJwzXppfsEIAlVcBAjuFY1r1suE9u6Fc2g6Gz+ee0lIR2VfiJ4eJT6NASXEsPbsRDaFJ2rpXaARBoJmZy7aKCRAmtAwLZtrc7ljcr4D6otYTlWZEoe3a/RnXJNWBqFJVQV0HDj9DMuHXRpevdop8GeDATed17pl8WpZcLkbaxVJTMmk413ZvP9isWb/9VjQfpXGO6zoB4zV/9dUcxHd8HhAdXAdh+VZKM2aWuY4ZjUVKVM7uI07kkVCjYwQWmLWjZkKRiIhBdluh3YFQO9qN008akFIIqqINDpV973wnABDbtmJjxFjvCq1fQbOB5I1aGmkvZWhadLbV07nyJY7vt2CPbdn3wCy3ZMEAc6SoWcLhvt4BByMPZLsp6Fo0FQJsZemRt794Uh2Z0Cd+I5Ss2evp4XvOFI/XRwMVFSIKPhHvT5hRqEBS3Bpzxo0Ozg5VuJ6Rj3wyAGR89Y+mfrY1JSvzFJ51xUvOH1LcHrE190Hk3ONLixBAY+3E/vDgwWl3ANfl0Z1JAdwmgRipcyvZc8r6Dn4TvP1BMbwHVwlwjbfa/XAyOP+PqirnsCdeHOggjbObnxASmGzoBiNlKKLkLVQYTEpAFXU49HhicrUM+uEcv03YwJ
 p0U9W06g
 Gfe9El5wEgqTzvvl2J+XIfC5pSMKDIzKhU3a+36SVFztiT8SUGoy4Ql8psAKSZudE5TlMDXwTBglfcgidSYgV7QCeCLdvAdq5tR9wYWAvc5PBb5+w2ZKDsw4hLWfbfLXRxLMLryIwTHjIQ9IZIFxEwp5eMwLpge18U5luzh+MbzYtfUXHNzFFxpoDWdpxDsaYl5kXy3hL3aT+ybWMP1f/bK2ybbcX3V1s2ntOtF4cfC75mwcY44eBJbFwLAlNjToLk/Tr9DFBkIBhpCsmd8GcH2prRqQZuWgWtiW2DeHpUeujB1K3JsjNiMttASIZPJCbw8GkcBsFAAEe8CGXcl2dQas+6XYbMB7uq6QQ5vdipEeAKPYgFogSyjNlExaH8de/KEU3RSrnmArWg49ftKeVg5AmLFsHuLEHR/cPvndJllr6XbbXNwan0uutN1/oHZASet1cluhjQLggC0GzrzO7pGLv5vVvQbAKTmcsKapXCEGvjTM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 5 Nov 2026, at 4:58, Vlastimil Babka (SUSE) wrote:

> On 11/3/26 17:04, Zi Yan wrote:
>> On Tue Nov 3, 2026 at 9:57 AM EST, Vlastimil Babka (SUSE) wrote:
>>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>>> index f1048168c90c..1850a41f24f7 100644
>>>>> --- a/mm/page_alloc.c
>>>>> +++ b/mm/page_alloc.c
>>>>> @@ -6308,6 +6308,10 @@ void __meminit setup_zone_pageset(struct zone *zone)
>>>>>  {
>>>>>  	int cpu;
>>>>>
>>>>> +	/* The zone has been populated before, see zone_pcp_reset(). */
>>>>> +	if (zone->per_cpu_pageset != &boot_pageset)
>>>>> +		return;
>>>>> +
>>>>>  	/* Size may be 0 on !SMP && !NUMA */
>>>>>  	if (sizeof(struct per_cpu_zonestat) > 0)
>>>>>  		zone->per_cpu_zonestats = alloc_percpu(struct per_cpu_zonestat);
>>>>> @@ -6400,6 +6404,10 @@ void __init setup_per_cpu_pageset(void)
>>>>>
>>>>>  __meminit void zone_pcp_init(struct zone *zone)
>>>>>  {
>>>>> +	/* A node which is added again, see zone_pcp_reset(). */
>>>>
>>>> it might be better to explain zone->per_cpu_pageset can only be NULL at
>>>> boot time and it needs an initialization.
>>>
>>> Hmm.
>>>
>>>>> +	if (zone->per_cpu_pageset && zone->per_cpu_pageset != &boot_pageset)
>>>>> +		return;
>>>
>>> Shouldn't then the check be just:
>>>
>>> if (zone->per_cpu_pageset)
>>> 	return;
>>>
>>> Because if it's == &boot_pageset, we are just setting the same values that
>>> area already there?
>>>
>>
>> Right. And zone_pcp_init(), called by zone_init_internals(), becomes a nop for
>> free_area_init_core_hotplug(). Then I wonder if zone_init_internals() is
>> needed for hotplug, but that belongs to a later cleanup.
>
> Yep, that's for later cleanup. Right now the minimum that's correct and not
> unnecessarily misleading is enough. So I've done this:
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 1850a41f24f7..20bfd11c5851 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6404,8 +6404,8 @@ void __init setup_per_cpu_pageset(void)
>
>  __meminit void zone_pcp_init(struct zone *zone)
>  {
> -       /* A node which is added again, see zone_pcp_reset(). */
> -       if (zone->per_cpu_pageset && zone->per_cpu_pageset != &boot_pageset)
> +       /* This initialization only needs to be done once */
> +       if (zone->per_cpu_pageset)
>                 return;
>
>         /*
LGTM. Thanks.

Best Regards,
Yan, Zi

