Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67AACEE3695
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 16:09:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 560136B0005; Thu, 12 Feb 2026 11:09:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50DF36B0088; Thu, 12 Feb 2026 11:09:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39AE06B008A; Thu, 12 Feb 2026 11:09:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 23A886B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:09:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD16F8A5E0
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:09:52 +0000 (UTC)
X-FDA: 84436290624.17.28E6A71
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012036.outbound.protection.outlook.com [52.101.53.36])
	by imf01.hostedemail.com (Postfix) with ESMTP id D11534000F
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:09:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=O9+KidQk;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770912590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=evqE8Ffqlz5UpMG/fLw27x8yjJkfghMbTkqYfpOXqw8=;
	b=IXX1W1lE03lK4VSKusMbawAMYeVbN/XAOe6x7Ednm/+NeIzEhkdCK6EjYMJMtd98HyLYRR
	MD7OyrIxkWKEDLPxgrzcDMnkO8uPVU8OlJwACjwn9xiHDs9VHdfCYOSDeEAdB9+aILdzde
	j5BotqRW92U9wnlUxmmPeigwB3kQVrw=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=O9+KidQk;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770912590; a=rsa-sha256;
	cv=pass;
	b=1KolOJQba3uJK2q5GBerBRYaVPRl/auwW/OJMhafH1ZNxNcWd2kf97BjzRp4oObYT/kMaq
	55xSwFKAm229wA2zcV23wuRfRJRVNYFOpOe3kvRJiUXC9TCfoXcsDdgkzydSrEOaav6Tgi
	xGT26NSxrsPHfv/zDyJr5QifSCGcsL4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rbh+4iYkce1OUOXN4tCo7og0hTLkyUHpswarr0NaGwKpH2QL7OUvHoz2NJpNvrn7q7x9uTKhR+Gn6qhbFfQRQ2hn+eIOfJaqyU6wVKDWMDK2rODO2dDtq4Qp3h/1hHPWrFUUM+15MlQlquCxQSgLeyUxIxIdFJxYsU1Uvrxy5aZPtuK/O7mFjeCD+LVsewwUI2olTrBFyjyR5WOsOpJHH3Iubgug1RL8zbWo2uR0HsS3Djo5pqvIK7DyLqi5B/iFmZ5XzNPSvVXWDs2O0ogAGDm6tGBdmEev2/bv0bsj638VBpjPJJP1Zc5Zq3KRvuLen8s+DYVqf9o+QNPwz9JiqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=evqE8Ffqlz5UpMG/fLw27x8yjJkfghMbTkqYfpOXqw8=;
 b=aqgWhPQKtz80g+Oy1AkqyIaixrrdOxCtemAUXd9BRmF9FeHElFD2HExTqTHzwYbAoHvT/uipRfcP2uwuIYZOCXuInpQSxIv8tLpxRTtvgKZSUhI2heFJdtSpZK21iCLwzenvZKt2EqDne3G0LF/jACQuGsBpxSoWmRnvSfF8aBNTU6bi61geLhawvZ8f1xbswx1QMmibCs22G4bsPmEauBfd4rHES1K9Q2cOZT9HrVLByJBxMtJu8WlYbLqPwoRG2Q4wSlsRRmhC7EGw83dN13kcPy1NO4YygHjq2d/BtV6ck2ouHQSq0Cxa+XvLaPi3ifRfNqxLQzW9/W+nJQwaew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=evqE8Ffqlz5UpMG/fLw27x8yjJkfghMbTkqYfpOXqw8=;
 b=O9+KidQk9bvybaxGDCIPJig4lmqmIfK4jOCxzvuSAC0OE06JKWFxKrb1WxJimoNzvmlcitV9KzNX5u0QQVrDyxOEQ3BmVB38BvOoisV9YZ0/F69d7MXD2sF5KDyUkVj+CYe6fpdNwdE6Px7cLS8loUoRH5IWJoGsQF1/gVPEZces1BJ6WwzEkkgvrpUWTuTQhoito0foFT+7dK5HrJbR9cH2wplk0oGQMQPTKz/0xjvP+JXqGykYLUOP0+RA78AY4xnHpPwBYWHqi+FWbjg8NvE15/P55HmwmipPTcLmjUTzZFRqSknXYLvTPSjUoxPSBZDT84R5d46T9Ae0l8Fq4g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB5594.namprd12.prod.outlook.com (2603:10b6:510:134::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Thu, 12 Feb
 2026 16:09:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9611.008; Thu, 12 Feb 2026
 16:09:41 +0000
From: Zi Yan <ziy@nvidia.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com,
 jack@suse.cz, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v1 1/5] mm: consolidate anonymous folio PTE
 mapping into helpers
Date: Thu, 12 Feb 2026 11:09:32 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <048C7077-3E54-4DFE-A25D-05D3CCB132D6@nvidia.com>
In-Reply-To: <20260212021835.17755-2-npache@redhat.com>
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212021835.17755-2-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY3PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB5594:EE_
X-MS-Office365-Filtering-Correlation-Id: a2fe8e59-707d-4d2b-ec29-08de6a51212e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qk5BbmZ5cnFEcXdtNUhYM1o1NEhtZGZmUDZLYXRZRTRVQXR5T2VBVlZnYjhp?=
 =?utf-8?B?T3haUVlIeEd4YnVDa3Q5T0liaTFhK2JFd2ZBajVCd3FLUFU3UnVFQ09xN1Zh?=
 =?utf-8?B?YkZST05lWmIxV2xPamxsb2p0Um5hZGh2UW5UT0JMREF5WVlCSFFUYVlWanVo?=
 =?utf-8?B?NHp3elBPemtRczJzVGY3UzZSSk1TWlBQQzFVOUVLOHFCNHk5cjdpU0VSdGJE?=
 =?utf-8?B?bXl1Y01XVEl6RXR1UnM1QkNpQ0RwdFRUdTZmc0ZPYkdUeldnR3pVeGZ6NzVn?=
 =?utf-8?B?azhKY0JGbWFkcmdLbWo3Q2w3dW1FcDNVVUxsRXJtd1BiMytYUHZkRzYza2x1?=
 =?utf-8?B?TFJ0d3l3S3R2dm85K2JIVmxCNFI5WWtmRS93N1l2TTVzb3AzczliVXJ5S1py?=
 =?utf-8?B?dUhpUHluaSs2Y1FUSnR1NTNTRlRGWVNqMGc1Z1ZEWlF1aUoyMjNOdi93OUNN?=
 =?utf-8?B?OS9XMFh2RWlGVFJSQTFoYW9semdIWTNmS2RNMWRhZEdBNU1sZnRGZld5bW1k?=
 =?utf-8?B?WVMwNWNUUmtrODVCMFFCR094TkdGVlJVakFFaDRDRi9CK1lBMjY4U1RNbFBG?=
 =?utf-8?B?SkpjSEhKbmR1bm5oK0dRa1dmWkJ4UTEvRG5vLzJmY1k3aHZKSGZkbW9qaHJM?=
 =?utf-8?B?eGM5MVhvZDNEeGc4TTY4VlliOTRhYXVzdjdyeVlmY1VUN21wZ1JSQmY1NU9i?=
 =?utf-8?B?V0xoTENpWmtDb1NCb012Q1l1TGVFbElQaFpzNURSOHFURFF5a1djOUVUbU9p?=
 =?utf-8?B?NEFlbzREckZPeGZ2QmhjTHV2TWdNOER0S2E4d0swL3JENmFFWGNaZE92NGhE?=
 =?utf-8?B?R1ZiT1c2VXNtdUJJWTBwOGN3RG8zNEJHVlFDOFgydWI5eWJkdGdydVhmMlV6?=
 =?utf-8?B?bU5QYkRPdEF3SHlSb04zcDlSU2ZDYVNlVm9ZOFpaTjBkWUlGU2RPQmpxWjZ2?=
 =?utf-8?B?U2hTNmN2QW9WZUV2NkcwWVhMNXd1NjZKaVEvenVDNVo5cFczaXozbGJVUDJO?=
 =?utf-8?B?RG5hZFZDV1ZQd0RWNGR1ZlVjQ3hQZ2VVRHB4REhKRk5uZXZsL1ZPcjcwcXJp?=
 =?utf-8?B?dVJlYWYxWVVFVGdyc0Y1QUVwbHFxZkd3bkdqaU93S3hSN2hSbmVKOXJyeUFW?=
 =?utf-8?B?RVUxWm05YVhQdW91ZVpCeHZrOGZXZU8vOGsxUVFGcHlWOC96SzJNTWYvdDF6?=
 =?utf-8?B?dTcyOTJuSDFLd2JuSTFFNzVkTmVRVDZ3TWt3K1NNYytPeVZmWDRqZllPcFBD?=
 =?utf-8?B?NTEyT2J6bTdOdFRsSklDYlI0TjZ1OWZFbkpRU2VybEN5NmZOTkVvNkx1WFR6?=
 =?utf-8?B?MFRzRkQrSTNZMzdjNDhLbW5zLzFZaTd4N1h1WVpIbjBsajN0RkFyY0E4VUhl?=
 =?utf-8?B?V2pYWWNJd3h1S3VheVExWDJpc01aWStjUTMxVC9CeGY1cDF0ZERlQ0oyeTF6?=
 =?utf-8?B?VFJXVnh6YTJRRXN0dlFJSEQxS21EYzJNSzN2QVk5dkR0UWdkS3p2ektOcTZL?=
 =?utf-8?B?U1I2Sk5JV2p5Sm1yZXhEZGlLajh5eGppZHpiaGZ0UXg1RnFaRVJnbUQ1Y2dx?=
 =?utf-8?B?N2xzQkRTaUx3QVVaSWJnZWd4SUhrOFg2b2xIcWpVMFV2a3E3b2J6dVk0QTBm?=
 =?utf-8?B?RmZLL1dkRG5OQi9IdUQwOWFVaFkyTDVTdmp1K1QveTJBUkcwYXhkWnVCSXhK?=
 =?utf-8?B?bW5ZRWY2VkFGMWlqbEZuMnpXa0ZBS0RlQTVEOWFIakFuSzA2Y2FrZisvclBT?=
 =?utf-8?B?ek5wRG15a3JKZ21zdGd2d3FIZnRmV0RLYnBnQ25oeTF4VXFHK0V0OE0vQlgz?=
 =?utf-8?B?TXZYRllQTm9GTnJ6cGdlczJpWGhWbzhMSVhHVmJzL0tJTThEMHovSkdrUW9Q?=
 =?utf-8?B?NXpVT2ZzUm5odjVxWDdnYVhteGMvNDJjdkFHblBLMFpGKzFvWDNSN2Z3dGd5?=
 =?utf-8?B?dHJvdU5VbUlUYmMyNmlpZ2RZMDdqL1RIVER2VTZKb0FCMHM2TkJxRHVLTHZW?=
 =?utf-8?B?SE5scEVXbkVmU2FuWHdhMGNueEFWdEZjUSswVm01RitlcHByMlJhOU1yZG5Z?=
 =?utf-8?B?TFZ2S3VvbG9EOUlHaUUyNkNuZnJ0SjUzSk1jK01mNUU1THAvL0xNM0M5dmdy?=
 =?utf-8?Q?qDOw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T1dtWlFZYm5DK1crUzJQL0d1MHhiYTRZMi9aOEZmcW91ZnlIWUt0bko3d2No?=
 =?utf-8?B?eWw0a2VaZHRtQXZRWnNVaVQ2K2ZML2JIZ0ZhbVFkRFRHUzEwbFR6LzBQMk1m?=
 =?utf-8?B?MjFKMk04b01GWnFCbDh4NzZseVBjdTJvZGV2UFZPY3pTMWU2dmtTS0Q4QnR2?=
 =?utf-8?B?UE1yYjlOeUxPRkNFdm9RMjVWQlE4Qzl4dElFMmFQMkdFNnh4Ri94WHhpZU82?=
 =?utf-8?B?UUpObVlxdm5ZYktCRVZqSSt0MHB5U2kzV0RTWGcwclRKdkNhQXNhTHVNaHFS?=
 =?utf-8?B?WXFSak01WThlUzNqcXNUNzNJKzAvcWh1SGY2ZFFSeUtmMldBK1ZrZTVuQWJ3?=
 =?utf-8?B?Skg4REk4MWdDMi9naFpuVDB3YURLcDJpNWxSb1FIdEdQamFCS0ZIMjZyUDBZ?=
 =?utf-8?B?dVA4MTNkNUszNTZzRGNnTUlzZDRqbkxUazBRaDlrUi82eGhQSGE5azN6NzNw?=
 =?utf-8?B?RGtBN2huK1g5bEozb1dlZFVSMDllQjUrSUg2VGV5Zld0S2orbGJQQ2JLL0lL?=
 =?utf-8?B?Ynd1VVhXeEhPLzNJYVVYN1l0cFdUaFQzRm9pU2kvR3pFYXp4N00xMnh3QUpr?=
 =?utf-8?B?N1Jma2wrNU9MbGt6aWQ0TWJMOWlyT1oyM1Uwc1E3bkxUQWd1SVE3b1ViaWRW?=
 =?utf-8?B?d0daN0tnTDZZaGJQQXlRUzhGMlBBYTY1RHRzZkR5dy9nV1N0MGNTWGNlME9B?=
 =?utf-8?B?VC83MlFWQUJlak1yZStKNVNnYWIybFNWVVZHaHFvZ0dqSFdoN2phZmhBQk5p?=
 =?utf-8?B?ZE9BRWl1cU5lbkZ4VnNpQ050V0NhaEx2RVpFL0RHZUhOWHBEYk4rSUdKemNU?=
 =?utf-8?B?cTdoTUZ6cGE0TDQ2NlNqV1dEa1FXWkdQVTd1NDBzWkdIVUFwS3cxRkh2RkQr?=
 =?utf-8?B?VHlXVC91cTEvbXlRRU45YzhHN3RTNUxTTGJMSVVVQm1lMlJMMFQvb0QzaStM?=
 =?utf-8?B?OXpRMWc5UnhqSkVzdk5aSVdPV2xtdTVJYk5pOW43enRoSjllUktMSlVzaHhi?=
 =?utf-8?B?WlR2VjlqSjljbnc4WlNzeWkyWWpDaXhmZjVlQ1Z5MWgzQ095bGFEQnprejdn?=
 =?utf-8?B?alJTZ2d1U1lRTUl5WW1pSXg0WFgySXBxSlJEbk0zaUo1ZTZndXZGYnZyTmdR?=
 =?utf-8?B?R2tKVWNVcWp5SXZ3MFNlbnV4KzFFQlhQdnpjL1RES1FibWRZeHJEQnJuMjRa?=
 =?utf-8?B?bVQ3eGx3N0VYTlF5L3k3b3M1NXFDSDhwcGZlQ090ekZvZTlOVTIrSzJwSDRS?=
 =?utf-8?B?Vi9FbE8xU09vQkp0R0hsUFlQekJ0QXV6TzJndTBJTEJsYUU4NTVsZXVUSm5P?=
 =?utf-8?B?Ymo4bDZnSy94L0ZNcHRNWHNLZ1BOeENEejdWQ2tHQStjUnVHRVM1LzZGZEV0?=
 =?utf-8?B?R0NpYlM0bUlRVzdSMVBpTE12eWViUFIxSG9ZRzVOTU5pTGNvcHZvRERQckRz?=
 =?utf-8?B?L3lWWjBJZCtLcnB6L2NUT1FQWlpiL1NmTHZvcWNoWVNqaGlML0dSdE1vaUFs?=
 =?utf-8?B?RHAwNnNMQWlHa0pNSVZNS3pkU0dCLzk3UU1RNktjWTZKem9IcnEyQk9hSXdw?=
 =?utf-8?B?c1gxakxKRGwxVDBPZXlMaUNvTjFqREU2Yi96WlhYMDBZNWoyUVh6ZTdsalpl?=
 =?utf-8?B?azJaeTJJWVpraC9qSEN3bHhhamZsQVZCc0NOaGZNNlFmSFJjcWdWRzY4eWlG?=
 =?utf-8?B?aE1EeUR4U0dwUmw4VDdocmNUbklHT0NQTlNuNmJ1Zk9tUFN5U3dUN3p2ZG1u?=
 =?utf-8?B?UmFOaHhkdFdOWEZwMGZ2akE5MW1RWU5xL2RtdUYzcFdQcnhzemh4MWRUOWc4?=
 =?utf-8?B?d0loRlQ5OVFyY25zSnhMSGNqWTRYTmszKzlod0NMNDRlT1VsdThJU1duMW9u?=
 =?utf-8?B?bTRNZFY0eUVUMEc3NVh5ODNPSXlIT2FzblNvR2gzZTB5MHlmZ09Yb0RrZHZO?=
 =?utf-8?B?UjBOWkUzc2FpVU9ndEZ3eHlyelBBMy9hNlNiOXFuNUlZbVJBcFd2RkVkdUJp?=
 =?utf-8?B?VnEzSzZDU3pXb2puVHlOOHRJaXErNHI4MjgwdjJwNVluSU45T0lyMWJkY0Nk?=
 =?utf-8?B?SzJ3QnlWRy9UNUxaL3YwYkJnWDBXd09KbEFwMHBmVW05SDR5cHZjVlBWeWY0?=
 =?utf-8?B?d0Y3OGV0ZWx2MEFVL0dVdWR3YVdsTVJ3T2llSERDU3BYTEg0b240cUNLSHMv?=
 =?utf-8?B?Q0VjdEFzbXV2STdreit4dEh4bndpb3lsR3R3eHJYL2ErV2RjaURtLzFwajlK?=
 =?utf-8?B?REY5NUc4ZXNZZUxtV2FyY1RhSEhSb1dLZzlnOUdyUEdyWi9TYS83WlZYaEh2?=
 =?utf-8?Q?wdVzMrDwP6xpkKJdLG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2fe8e59-707d-4d2b-ec29-08de6a51212e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 16:09:41.6582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oI8yq5A8V2ZRRsWcFfth0gCXm9X0O32rti9+tfBQ+eHLr0sWSLHVg6wHta7hwsy4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5594
X-Rspamd-Server: rspam11
X-Stat-Signature: pkdfpxstmhb6uxjjug4esuj8gcdxyt7z
X-Rspam-User: 
X-Rspamd-Queue-Id: D11534000F
X-HE-Tag: 1770912589-650607
X-HE-Meta: U2FsdGVkX184Q19qDJO8dNh6LdSuetu/21OnQ0ixUdDMfZUlXw4Oju/E6mObdl71OAA9kQkgD2vh4lZQ7wtTqNTMCY1s2f+DeyfNOIPN3AJfcDKq89XT/gffmDMyf8G2mtRRjhSITp7hu0vCxqj/lB/Xm6l2e6Cqw8ra7TTMgBUow8VZ49ItiK4UiGxf/80duHazoOncEaUaFrs2jN57EXRl4nEsnOr6PzP1R4NVfR8rSm1hsw4lOb5XMT5tIB6dEabGqaAIlyNeVPz31l9te0x83kTfo/DlPpRZ4eszWiQARHVxegi7K1uTHgVnXO78P8MHGIYAHCu5uMR6btMyBotw6F/ti6vDXXPCf0S6mRIJiqJuLjS3mNeThPsfEkQQ1MCT894WpiblSl7cGuJuL7lqhDCrrns96NuWsMY958hKYjWGwlxuhANmijh9/eqKvDmafWUJzXs0kDb6bUi+l2XvvpdVeXUpY0nTbAq0J5B2i45czQ2Mz5/cg5/jS/MXFVtsnEGU+VbCZ7cCgj+MJbrJMAcKNVov+bwHAysmoYn1GzrwSb9bFY7CBxa7j3F5mfk4k0qgwG9C5Q/mnCRcpp8PsQbUtdzi5h39z+mR6f/aTU4ZnfOmGUIL0VvGKPehdOoe43UEKUOfPp0UV9voeynSHK8dLB5jgTFkfbiM5R36j7rS3d9A+KZ4MvuQZH6b03IvAHY4idpT9YIkkuKLuD2SDBhA0jUiO4JOkQLZ6PgXB/TYIEG83VPYIA+QtoEbiHlsNWZAPNtM8KWLSmJTXHVvKGbkGuXic/WPoS6fvkaYgrOybj/Jg9oHvuDgQNEyyVJQrQ/UNqjUuKqqgAsUjkHiO0fuYpSIbuepODxEIpE22bJ3rHlKtwm0ZFGj2/WU/sQdgLsWU3Sm8Zs4HxCNl4wogvUIKD1/KCRj7jzJ4OhIJ4ooX5i/xegO38h72rqGDof1ZfQQ69PWAnUefr2
 jIphZBjl
 HiOvHm7/i2DzJfp8qdFvN37H77lWljU4m6lfw1/LWCEPD0Fx9fGVj4CPKDz59fuuN9QAVqmaseqf2nwJ0O3yDsqMRP79GtAybX3PClxzR461oL2l7b1qdzIHduA+9UDd721UUwhknIfKQ0nCL+7rcNEwLKix0Z43ZGLb/WWxqTUdXN1TIl4uaLr/n7TrSeu+I4wrxRE8pIH38vRbFlwmXSrD2qaHxYBcClen2RLsV54uBvyS12CgpZv/TT6/7358IGiQfplU+aio5UxAm/Om57a4Ju6J10bCaGBeoEqKrOh5EOa996jy24BLUcf9JTAg0FNRkKUCBXTpxEJLsJjkCpAfJqIjIEYwXY42PI0dSfcD9Vw3Crpz/PbtcobiJ/YCi0lweNJukcfvQb15Og9CoZQ4P7T45dFXxhCj7bYI6F63q4NeUgRCiNGT7hw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Feb 2026, at 21:18, Nico Pache wrote:

> The anonymous page fault handler in do_anonymous_page() open-codes the
> sequence to map a newly allocated anonymous folio at the PTE level:
> 	- construct the PTE entry
> 	- add rmap
> 	- add to LRU
> 	- set the PTEs
> 	- update the MMU cache.
>
> Introduce a two helpers to consolidate this duplicated logic, mirroring t=
he
> existing map_anon_folio_pmd_nopf() pattern for PMD-level mappings:
>
> 	map_anon_folio_pte_nopf(): constructs the PTE entry, takes folio
> 	references, adds anon rmap and LRU. This function also handles the
> 	uffd_wp that can occur in the pf variant.
>
> 	map_anon_folio_pte_pf(): extends the nopf variant to handle MM_ANONPAGES
> 	counter updates, and mTHP fault allocation statistics for the page fault
> 	path.
>
> The zero-page read path in do_anonymous_page() is also untangled from the
> shared setpte label, since it does not allocate a folio and should not
> share the same mapping sequence as the write path. Make nr_pages =3D 1
> rather than relying on the variable. This makes it more clear that we
> are operating on the zero page only.
>
> This refactoring will also help reduce code duplication between mm/memory=
.c
> and mm/khugepaged.c, and provides a clean API for PTE-level anonymous fol=
io
> mapping that can be reused by future callers.
>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  include/linux/mm.h |  4 ++++
>  mm/memory.c        | 56 ++++++++++++++++++++++++++++++----------------
>  2 files changed, 41 insertions(+), 19 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index f8a8fd47399c..c3aa1f51e020 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4916,4 +4916,8 @@ static inline bool snapshot_page_is_faithful(const =
struct page_snapshot *ps)
>
>  void snapshot_page(struct page_snapshot *ps, const struct page *page);
>
> +void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
> +		struct vm_area_struct *vma, unsigned long addr,
> +		bool uffd_wp);
> +
>  #endif /* _LINUX_MM_H */
> diff --git a/mm/memory.c b/mm/memory.c
> index 8c19af97f0a0..61c2277c9d9f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5211,6 +5211,35 @@ static struct folio *alloc_anon_folio(struct vm_fa=
ult *vmf)
>  	return folio_prealloc(vma->vm_mm, vma, vmf->address, true);
>  }
>
> +
> +void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
> +		struct vm_area_struct *vma, unsigned long addr,
> +		bool uffd_wp)
> +{
> +	pte_t entry =3D folio_mk_pte(folio, vma->vm_page_prot);
> +	unsigned int nr_pages =3D folio_nr_pages(folio);
> +
> +	entry =3D maybe_mkwrite(pte_mkdirty(entry), vma);
> +	if (uffd_wp)
> +		entry =3D pte_mkuffd_wp(entry);
> +
> +	folio_ref_add(folio, nr_pages - 1);
> +	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
> +	folio_add_lru_vma(folio, vma);
> +	set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
> +	update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);

Copy the comment
/* No need to invalidate - it was non-present before */
above it please.

> +}
> +
> +static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
> +		struct vm_area_struct *vma, unsigned long addr,
> +		unsigned int nr_pages, bool uffd_wp)
> +{
> +	map_anon_folio_pte_nopf(folio, pte, vma, addr, uffd_wp);
> +	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
> +	count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC);
> +}
> +
> +
>  /*
>   * We enter with non-exclusive mmap_lock (to exclude vma changes,
>   * but allow concurrent faults), and pte mapped but not yet locked.
> @@ -5257,7 +5286,13 @@ static vm_fault_t do_anonymous_page(struct vm_faul=
t *vmf)
>  			pte_unmap_unlock(vmf->pte, vmf->ptl);
>  			return handle_userfault(vmf, VM_UFFD_MISSING);
>  		}
> -		goto setpte;
> +		if (vmf_orig_pte_uffd_wp(vmf))
> +			entry =3D pte_mkuffd_wp(entry);
> +		set_pte_at(vma->vm_mm, addr, vmf->pte, entry);

entry is only used in this if statement, you can move its declaration insid=
e.

> +
> +		/* No need to invalidate - it was non-present before */
> +		update_mmu_cache_range(vmf, vma, addr, vmf->pte, /*nr_pages=3D*/ 1);
> +		goto unlock;
>  	}
>
>  	/* Allocate our own private page. */
> @@ -5281,11 +5316,6 @@ static vm_fault_t do_anonymous_page(struct vm_faul=
t *vmf)
>  	 */
>  	__folio_mark_uptodate(folio);
>
> -	entry =3D folio_mk_pte(folio, vma->vm_page_prot);
> -	entry =3D pte_sw_mkyoung(entry);

It is removed, can you explain why?

> -	if (vma->vm_flags & VM_WRITE)
> -		entry =3D pte_mkwrite(pte_mkdirty(entry), vma);

OK, this becomes maybe_mkwrite(pte_mkdirty(entry), vma).

> -

The above code is moved into map_anon_folio_pte_nopf(), thus executed
later than before the change. folio, vma->vm_flags, and vma->vm_page_prot
are not changed between, so there should be no functional change.
But it is better to explain it in the commit message to make review easier.

>  	vmf->pte =3D pte_offset_map_lock(vma->vm_mm, vmf->pmd, addr, &vmf->ptl)=
;
>  	if (!vmf->pte)
>  		goto release;
> @@ -5307,19 +5337,7 @@ static vm_fault_t do_anonymous_page(struct vm_faul=
t *vmf)
>  		folio_put(folio);
>  		return handle_userfault(vmf, VM_UFFD_MISSING);
>  	}
> -
> -	folio_ref_add(folio, nr_pages - 1);

> -	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
> -	count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC);

These counter updates are moved after folio_add_new_anon_rmap(),
mirroring map_anon_folio_pmd_pf()=E2=80=99s order. Looks good to me.

> -	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
> -	folio_add_lru_vma(folio, vma);
> -setpte:

> -	if (vmf_orig_pte_uffd_wp(vmf))
> -		entry =3D pte_mkuffd_wp(entry);

This is moved above folio_ref_add() in map_anon_folio_pte_nopf(), but
no functional change is expected.

> -	set_ptes(vma->vm_mm, addr, vmf->pte, entry, nr_pages);
> -
> -	/* No need to invalidate - it was non-present before */
> -	update_mmu_cache_range(vmf, vma, addr, vmf->pte, nr_pages);
> +	map_anon_folio_pte_pf(folio, vmf->pte, vma, addr, nr_pages, vmf_orig_pt=
e_uffd_wp(vmf));
>  unlock:
>  	if (vmf->pte)
>  		pte_unmap_unlock(vmf->pte, vmf->ptl);
> --=20
> 2.53.0

3 things:
1. Copy the comment for update_mmu_cache_range() in map_anon_folio_pte_nopf=
().
2. Make pte_t entry local in zero-page handling.
3. Explain why entry =3D pte_sw_mkyoung(entry) is removed.

Thanks.


Best Regards,
Yan, Zi

