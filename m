Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C649D72361
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 09:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2EC6B0494; Fri, 23 Jan 2026 04:34:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4FE66B0496; Fri, 23 Jan 2026 04:34:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A27506B0497; Fri, 23 Jan 2026 04:34:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8EBC16B0494
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:34:22 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37B96140408
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:34:22 +0000 (UTC)
X-FDA: 84362717964.25.D06D6C3
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012023.outbound.protection.outlook.com [52.101.43.23])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4D16280007
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:34:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="Dqcb/PzB";
	spf=pass (imf30.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.23 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769160859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GpnikKfPEXMKlz4JNeoRrVZdeHosTeAHVOokjEpFsGs=;
	b=W4N5TzCeZHbtM4l0ZC6DJRcSMcEPyDd3+7Pt/sVYo3WR/Hys/k9oKTBQLgnp/5NOGsmiGA
	fU/1uCaXGUHO9ajbaWbTQENfXea9MY6SWVW2UeQMigcBEtsWzKWPfT4ZR7lCVwXsOh4Tt6
	3Ch81WHdpRD5hyTjyC95jicoUxrvKz8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="Dqcb/PzB";
	spf=pass (imf30.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.23 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769160859; a=rsa-sha256;
	cv=pass;
	b=tCN3AZDKIlSsXxyoTpOF7BSadgYrMsfsIaf6AWwJMKsRyKYGXr6wccKlN2IEqLOsrGIJMl
	tCGn04q741tVCHtoQ0DkYN1JvdyydBrrGMqwEYxkQ61o2USAMdDt51Mmb5ok0FPHt39WgF
	tK93iOBGphY5/Hu4qA0T2VK2PCeqo2A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QeWPQfyzWSOzUk+5oKqlKUAsh/sCPOTmolAvKrdJQOSozXaeIEMyMIXIbQJNeZB+jQwG7JjhYiwYUx1joAxAw2dQHjSpfajZiw8ZfTDbhsFfRxjfuqE2SK177bxVm7LKgN/JQIJRKBpuz4DmzYeYpUSNOk24GmGA3SZlvq9jsb3sKEozB9AUrxSmRnOBDisFa1kewf5IUVbAeuuOVBi7nH7A+otGTRlz2UYHKGgfkT4hPS52Q74R3XebDAj/6cJB+u8hHUHTqfUkSrawJkhE7FR95nCtFworUNQ4gcvS8eTH0fVKFrsCNpQtJB6Mv/6AB5R8AT0UFMqg6N4A7jKqXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GpnikKfPEXMKlz4JNeoRrVZdeHosTeAHVOokjEpFsGs=;
 b=SLvO0IEBFg0t9lUL8YDdGyxJedhs+F+sw+4ZGg0w/5bgcVqC0fsCSk4QoS2Ev0LKXl91D7NpkvRiEuhp3Y4H787nIVqIuVV++s7e7ma/kYE4MYj++C2XKyoGBJwZQHCOb7ihdXPcFgaCvaJ6kIZtLDo1Y6yYPzYuBFba7UkiBbSYvw8JiuSkfSv8izmKdo36dmBQbUQyKU5E5cYQA9nM5jWzbLq1V63uGimMyTxi/OoW5fI3KES4g0/nzXejznTiOejcPcPv4djUw4TOOwzYbm01D6fqOYAuTVBnKsz0i3IPVrmfmsSUHFXssb/SPvMM6nOQLpGVjIVdZYLbTkHlug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GpnikKfPEXMKlz4JNeoRrVZdeHosTeAHVOokjEpFsGs=;
 b=Dqcb/PzBb8/UvRtNz9FBRjZxhYHyyfl4fV2oY+0+JrVQtofnfkpHu75GfYQbDIMesa2uUanHuHgko4DA/HXE+ISEOMZQdPhSS6RWZpboPstEwtsIRBANerH5vqIAoGyRBdEJUToOzF8fsjph/hGuSKfF4uhAKpMy3sYVQfcjF/0=
Received: from MW4PR12MB7465.namprd12.prod.outlook.com (2603:10b6:303:212::18)
 by CY5PR12MB6300.namprd12.prod.outlook.com (2603:10b6:930:f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 09:34:15 +0000
Received: from MW4PR12MB7465.namprd12.prod.outlook.com
 ([fe80::d8ab:cadd:74a8:5132]) by MW4PR12MB7465.namprd12.prod.outlook.com
 ([fe80::d8ab:cadd:74a8:5132%6]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 09:34:15 +0000
Message-ID: <ba4502f7-0c35-460e-a42c-d32dea9ab9eb@amd.com>
Date: Fri, 23 Jan 2026 15:03:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 5/5] mm/khugepaged: make khugepaged_collapse_control
 static
To: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Wei Yang <richard.weiyang@gmail.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>
References: <20260118192253.9263-4-shivankg@amd.com>
 <20260118192253.9263-14-shivankg@amd.com>
 <6486c6dd-2702-4a4d-9662-09639532ce6f@arm.com>
 <afc56f8f-0c22-4bac-a99b-b46df346334d@arm.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <afc56f8f-0c22-4bac-a99b-b46df346334d@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0135.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:bf::6) To SA0PR12MB7461.namprd12.prod.outlook.com
 (2603:10b6:806:24b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR12MB7465:EE_|CY5PR12MB6300:EE_
X-MS-Office365-Filtering-Correlation-Id: f8184fbe-5d88-4d7b-1b96-08de5a62923f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cEpBUTVvS3RSc3V2aDRjSkZUSHJDakZKR0t3ZkRlb29hK3JYRUdwVHI2amEz?=
 =?utf-8?B?M1pVZUEvUXU5K0Z2R2trRmxPY3JpVVVsNWRZZ0ZpcHhSS0FMQlFBa2ZZV0tk?=
 =?utf-8?B?cm9FS0kyYUdxdm10VWdRNHF1TkpDVFl4ZVJZS0luS2dpQ2h4QWNFR2hXTDJL?=
 =?utf-8?B?bUQvYlNYTmVzMW96ZldiT2VEYWZ4SmIrTDVVeFNSeDkzS21FV00xc0drWTZR?=
 =?utf-8?B?ZndXYkF0RnBCNkd6R3hOSkk0WlB2N0p1SlBDTFhyUDRjRk9GcUh5TGhVUjlJ?=
 =?utf-8?B?NUxjQlg4T1d2VC84ZVRFNTU0bEJ0aU9LeWNTK0QwNTVreCtjSTRyblFScDky?=
 =?utf-8?B?L29wdmsvN01zM1YvWnRzUUtYMXFkcHlnL2h1UjhTYVphLzZUbnFkOVV3NDNv?=
 =?utf-8?B?UzEvdUtKcHZoSGZ0OGlHTWxuVkVXZWtuT09RMjdtYndrWVhiZndFeVgrc29Z?=
 =?utf-8?B?bkRsUGZJaVNQSE5pN1BxMmtWTWdRbzRUZTRzZENFVGFiMUk4c3hHSGVIQzJk?=
 =?utf-8?B?YnBtTm1lNWhRdkVoTDFzMWkvSEMyaTUyV09XV1IrS3F4UnRQZUl5WEV1S0pp?=
 =?utf-8?B?UlhySlBEYXZGMWdGSnRPVnJTcWw0MCt5dW5iVzMrZEptTmhUNzA5L2tVd2cz?=
 =?utf-8?B?djhVYnJ5bU1xMUx1RmxCVElJaTVkbllKT2JQVUZYV0xhQ01Xb0ZwdG8zL1VU?=
 =?utf-8?B?c0FwWmVmTXNZa2FiTzk0TE5kOCtNVm1LVEk1emdnbUR4c0grajdyZXlKYzIr?=
 =?utf-8?B?dFNWL1NQdEhXdjJzZHNmOWpmSFFuY2lzZy9iNkp0ZDF5MmVSdE1MY2FvUmRu?=
 =?utf-8?B?cmkva3FaTVN4YWJrbkJjUWZyWWsyQTk0NGtKWlR5M1NjMHFsZFd5VElqV2d6?=
 =?utf-8?B?RnNKUFpXV3MreDZMWndUUkpCQldJTXZESGRJZkg4Y0lSTktSb2tDenVQc0RT?=
 =?utf-8?B?enkxT1UvS3pXMzZrZHE1SmhjOVlJVnRmSDFjMkYxR1Exc256RDlOMS8ySTR3?=
 =?utf-8?B?U0IrelpLM2kzdU5QTXl4cjROL3ZieWR2NnNSL0FISGhDQm1jdE5HMFh1R2FE?=
 =?utf-8?B?akFsYUVQZ3NId3JRaEM2UHQ1LzRjMXl6SzhhRlJ2UGRGR2ZYNTJLQ2pZVVMr?=
 =?utf-8?B?RUFVVVkwTjFYaWZwb2lrazAvSEVTNXk5V3FwTVdyTC9uSzNhUVJ4UnVPWDhH?=
 =?utf-8?B?MVlsQ3FMM3YybWpVblRqZC9Edy9yZ2g5WU0zSGRYN2ZuNjB2NVBqcDNuQ1FU?=
 =?utf-8?B?Y3JFVFJScGFXN0dOL0lQOE1DcFYwSFo1K3RNK3dabEx1c3Q1UkJwZFY0dUc0?=
 =?utf-8?B?bUFpblZ5bjIyQmswaVJDTHZnRGxFVXU3V3RwWk42Q2Y4NWpTb1lVdFFRQ3Za?=
 =?utf-8?B?MWhEMmhtMEh1THNWc3hUV3RVZElqUmdCTUpuWVJCTTh0WHBEVTR6ckNLaGZ1?=
 =?utf-8?B?Y3owNlBwTVUxcS8xSTNwaEJadGFUK01LYjBlczJBTHh5T3FwUms1MmZRSFRY?=
 =?utf-8?B?YXhKa082aituUUlCbVBsM20yWWR2cHJvMXhQeitJNDJQSWMycXVydkw0eFRW?=
 =?utf-8?B?S2toTTh0dEZndVNlNzZxYVUzTjJtY0hIYTRRems2YWVidXV3K29WUjlRdlA5?=
 =?utf-8?B?NGtjYlNsUXpNMW9PMjRzOHhWZ1JhcjBtaXRJbS9iWVlMVUdPL2lpWGJBZ2M5?=
 =?utf-8?B?OFN1eXdsaVNUSk5Wek50ZUNYNG9BNVRoM3pZZC9DWkFSMkFCcXVOWmhBSVRH?=
 =?utf-8?B?b1U3KzBjVkFyLzRyZ3hoNnl3ZzdibUdsMVZjVHZFU2RwenFBMVhPRCs1Tkhk?=
 =?utf-8?B?RldxMjNSenFFYVRBSjh5STRIL1FzOWtrSFRnVlVERTFjblFjUnJyV3JlL004?=
 =?utf-8?B?c1ptTGh0YXRYSVJiTWdaemJ0M2Q0K2pVekFtaUdyZ1NSWlpIQlcxd3VXUnBD?=
 =?utf-8?B?Y3gxMnJFSkZUTkkxaE5QZTlHdEdjbUhsQjZ1NjJYU3ZHSzBHTDR6UUkrZVNC?=
 =?utf-8?B?ak5JTXdIUmduVG54amVOd3hRK3luWUw5UmJrZHdtWXN5YXZsdnJUYVJHR1lT?=
 =?utf-8?B?ZEFGamdJelZ1REg4Tk9MWWVYN3FrOVZuK1hVaDZwTnlKMjBkNmZpbHdVZU84?=
 =?utf-8?Q?vm7s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB7465.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHp3OTYwZlVuTTNSRDRuZklYSW43RHRsd3piSjNvaE1TRTZVR2tHbElUTTcx?=
 =?utf-8?B?KzVJN0NVeG83UUExRjhiUTJmbkFDcFNncVV2bnJrU0NFZHB2b01FbkdrekhU?=
 =?utf-8?B?UVREQm9OZmRkUStpZDlvZDA0NWl0NWtxcjd1RlRDTWVMend0Z2UwWlBzNGFM?=
 =?utf-8?B?M0FuSWdNMk1NWDF2Z3NVUGNjUm1TcUNIZmVkUncyeDBRRDNxYi9lNjhCVmNN?=
 =?utf-8?B?OFhQSFFyOFhWcHg5Mmo5R1BvQytGeXFjSWpUdlh6eldSdVZaS09OQUVlSzly?=
 =?utf-8?B?QUt4WlB5N2R2VERCTnN5NEdKcExqbG5OWDY3ckpHb1BXek1yUzN5QXJZak9j?=
 =?utf-8?B?eFVZMFA4S3A2ektFNjlyY0t4NjlSWm1VdmR0eG92TUx4NHA1L1lzT014aG9Q?=
 =?utf-8?B?S3FDQ2tZZWNFOUtTNGloTStYcVNrMndVRVFoV0dwbmpycXlYQmFNT2lZckpL?=
 =?utf-8?B?NkJ4WllNMTd0YXRycE14b0x4ZWtRS0hBakFDbW9oWkh4c2lTcCt3SllxTCto?=
 =?utf-8?B?Q20wUHJHMkZuckZIdkc5aWdRZnRrMGxCSzZpR1I5UGJ4ci9HODhwTmNIYUVy?=
 =?utf-8?B?RzZxVlVxejBIWTE1ZlFOc0RxeGVFeTRGM2YzaWZsVzNUYUp0dTdhZDRtaG1v?=
 =?utf-8?B?RWYyak1SSjFGQ1BOYlRCN3lwL1I1ME54cjJZa0tFQVdBblEwYWN2TWVtNHRv?=
 =?utf-8?B?emNQTGFsOGtGM2hSc2J1UXI4b1AvNSs2S3hGd1pwL2pQN2swT3A2cGIwQjhn?=
 =?utf-8?B?UHNoQVZoUlpqNWVUS1NlaUNTcndRVndqS1FxY21aNm82ZStGSXRMR0tDazhC?=
 =?utf-8?B?QVNpZG1QZHp3WE1aS29ycE9vSFpWOWd4eWo0a2k5dHVLYTh2bk5xVUlsR2Zx?=
 =?utf-8?B?T3pvcUFlMStPZE5jc0tUMlE5T3JHNjR1TUFEb1c3bjlucndBY0NBa2RWV2E0?=
 =?utf-8?B?L3c2SU9sUzF2dkx0R0pqeFVSZHBxeFlySWdyOHdtSVZ0b1p5T05ZZXZ4dm1Q?=
 =?utf-8?B?Ly96RW55MHdJbXV3WmVFYU1lUHB6R2l3NllKbVlRMEt6Mzhld0pBVlBCNW1r?=
 =?utf-8?B?SUFsMGl4dTNSekN6UGhQcHFHbmJ3Rm90ekdaQVVhTDMxeThFQmd2b0hyK3hh?=
 =?utf-8?B?VjRMeTRMZGlFQjhSMmlCTTRQVEhOWk5HaTg4ZkpEejltRDNxWDhpN0dpRkhL?=
 =?utf-8?B?Ykl5YXJubzAySGtIb1EvNmxhajJ2Ykw4QmFOOW00UElpelFqU1M0SjgxRTI1?=
 =?utf-8?B?VUhFYWViZzlQWVZSN3dQT0pKeGsrT0V1MXRPQVdIUlRBUitNRGhXb2xKa2tF?=
 =?utf-8?B?R3g2aUNyNXdPOVE4T0NJS1VVcW8vaGI4djRmd1FMNUYvQzFiL2lnNk9TZVNv?=
 =?utf-8?B?SzQ1QWpRZzE0MEhQK1E4dFZIdGlEQWtwdElpY0ZWQzRZUWY3WVBiVWJoa2dh?=
 =?utf-8?B?UGRhWlQwMkU5NEpPWTVlZkc1T2xJQW94TlY3ZVdKQXNJcUlwSWVVYVkvRE94?=
 =?utf-8?B?WURJb25uVXZqU0FBQncvY0haREVPOWVNTUV6eHZKclBqamVCU085TTFsRGZp?=
 =?utf-8?B?Z3FFRDA2cGdJTkZmbjRxbFF3L3l6TzRIMFQ3cEtJRXBsa3F2dkVzbkRDTFJ6?=
 =?utf-8?B?ajZNOW10MUNIYlF4SENudHR2NDNoeHk5R1FiYUIyM3lQcjkya0dSejJZWm5h?=
 =?utf-8?B?cXJFcExSMnNtKy8zTnd3ZTBMSDhsZGRqZ3M1MENSc2thUnlqNFFKb0hYWVFk?=
 =?utf-8?B?VlZ0NzhxejlJZEtFc09ueCtrdCt0Y2ZIamxvVVhTS2RXWWdaUWxCMmRxNTFC?=
 =?utf-8?B?SDJEOEhrWmNYUHpwVnJ0VGEvY3FhMEVOSFowN29vNWs5WExBckl1MG9jOFcw?=
 =?utf-8?B?eFg1c3JOMVlJRkRLZDI1QzFvUVlpYVRzK29oazJpUjFCVUY2N0NYTmt3MXNL?=
 =?utf-8?B?b0hwTkk3TWhVMGZkMWRCS0RseUNSLyt2RGRiUmFhRDBJMUVlRDBhY1VoaUVn?=
 =?utf-8?B?N2pNUDh3Unl3NU1FVmF1aGRRWEVPVGpwVktydWlEa2JxeWhydGdCTFJUREp3?=
 =?utf-8?B?MEJqRVU5dlpsbzV0Y1ZXbHJvRFJYMmdqNXczeVp6OWVKdlh3NTVGWEd6dk95?=
 =?utf-8?B?UXpwSkVtU2pVTDRXK0tPUkdjS3FRMmhQK3lETE9vWGsxcC9WL212bWU4QU1N?=
 =?utf-8?B?aVJNQld0L3lmV05YVEc2Y2U1VjNQVjJGa1hoQ2FjQ0UxTUFLazFVTXJPZFRV?=
 =?utf-8?B?VW13ME15THhpaEJQZ0FCcDE1S3N4aEVaWU9GRjI1QWxsR2lxRDhheGh5S1BY?=
 =?utf-8?B?VlpWNDBKVFNEQUtpM2dERVoyaE90alJKMGpIamxGKzhraWdqenc5Zz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8184fbe-5d88-4d7b-1b96-08de5a62923f
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB7461.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 09:34:15.6455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RFWvlU2uz5qN+UmUv8JIcDodxLdwiIYG1R4f0KdTdKR4Tgu7jj2oSw0i7Ci1U2VNfzGkKcv7h/ObUtnOPwIq2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6300
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4D16280007
X-Stat-Signature: 5sizoxip5sqko61d6tow86ixw3x3a9gj
X-Rspam-User: 
X-HE-Tag: 1769160859-524207
X-HE-Meta: U2FsdGVkX1/z/7YCzOsJvULXtUQFH1hSOJphbhrJUwbRU5m00xkfvie5BPSDhesq9ZLIMe15UrHurS+KleclOBrYxy/XQTzexeWoUSB6iuCZxQxY+KSHRhf6ESlBIphv4QyUcHMpM5iDt+S5LF3PdoQ2aHhUGSzsnYAF/0JxOnWsgQBBmR4FWMz0eM0jJwO96W9ozIAPF4jrs84jWaNSfcoop8jSMOq4SM0yzJkGGMNIkejeR9mNxll3A12XkY3pe/Ngxj5T/j7xS9vEXAYFCvraXCdilJYgBhvM0Hvn7G8BQQ5nXfmGs1hi4zfQ+idMwIPrtNxFTnPSwtY76u9wv6iZJUCtYKzuPyIVOoqaDdxIcH6ysrf9JFiDEFyRkLW+3XChwegIrFgEO8ZgLYzB9OGbDV2OwG0D96ON1qFo2vRjR28rYOV20u+ftmHRwN3O2AbQTZsUGAbfDlqRWuli0fUBGwlMdv3/dquCoYTCjOFVNBXlOpk6b9YD0KM9uxr7hqiqF4/rPt31Gw0k5VWvi2YvOTSutdMcwYIpHrxwt+AGe74wz6JPiI5N86guI/ZYXjtGIwHSzrbbdNGnabrdKEq0wyz1gX9kK0eKQt7Vy5eLF0gVZkOomgirR6vkG6Ri8OE1vWhHROGkhHyPoqM2NvG+aWq/6pqmxOe1FFLHm/NIhsk7VR3osPIbz+rFpk7QKwHR8zcC6yDt6P/VsBe8ZDyQQK/Yj00oyfl4G1KtNMYjq5qXWqa1J1g4N6E4iIupokAsMaAyTGvD8eNEGRanYPOVRj6Fh5XZ28Vyj3ECIujln4ZIM+DaKtJv9U94dMmcWtZo/jexcIf8jo2vDKo8MG98ybHPCLSTlsKkR3CpPdjZeWe1ku6cThESlhuFhxXRqjFp0d4G164171yCsOEvElzv78mF0E7NEnIkdAZq/1qVkshOh43XiUCpsRS/QrwNqWhOahj7P1M1lxw39iF
 iDVOi4ZA
 xIDpxCg+W9XW/fu669+8QDZGpY417cPxMgcN72MWRWWPvbGDJuWlVJ6c97DNgXQYd0vw8Lsvla2IEGwT16voEPAlA5wN2B6e+fmLIc7OVl55EsZsZgHiWY9XeG3cm14x0UuaqFXdG4jwWO7CznzNuxYUsGa7wu27th4e7x8SLu20qbNLOPvNu73at5hXCVFl5ZhZ1ukZIOfw4K8nUkFCkmXQ7rqXmEazfxp1DG/yGfk4sIsUxO7jWb6R8AlVcWQy3I8DgDX9NCRVlSgHgTvMVNSUBBHs3i2YYu9xpvDFBA/ygr/agzlfGbj4g8ZcQX8LocVxwGnlymrsc3RCHTq8gRJQ8gVg198yN6hfrbEo6Ch0v9cxGLFfV0SDUEJXLsh7SZ83THm5ejxvp0EPWUxMqI84Pn+kByi3qe06/aa+HTDiWWprypsx1q2cw8y5yNtnKGgOsuEb4Vyt3MJPL5S1hWUOUhnPXf5Icj9AOSs/ka9v7AOxVzHnbCmtR/iMD+QUOwgwaqZIpe8Z1UCHteH9ePfXtNibwhYEg3/bpVYhVRzJV9PZcDHPQFm38+3zypufSnHXpnciwxoxhS6RRRs9hr5ipcEyspCP6UkkB1CC934UFO2z5q7ZqhHUPU7LjFjCDu6SuJO5C5lf2vi8spbwIu90ZJ1cdcWSlxhcMRyjFkE5dW2BRQROsD+Fumr0csO0CpPQ8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/23/2026 1:18 PM, Dev Jain wrote:
> 
> On 22/01/26 2:58 pm, Dev Jain wrote:
>> On 19/01/26 12:53 am, Shivank Garg wrote:
>>> The global variable 'khugepaged_collapse_control' is not used outside of
>>> mm/khugepaged.c. Make it static to limit its scope.
>>>
>>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>>> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>> ---
>>>  mm/khugepaged.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 1667abae6d8d..fba6aea5bea6 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -827,7 +827,7 @@ static void khugepaged_alloc_sleep(void)
>>>  	remove_wait_queue(&khugepaged_wait, &wait);
>>>  }
>>>  
>>> -struct collapse_control khugepaged_collapse_control = {
>>> +static struct collapse_control khugepaged_collapse_control = {
>>>  	.is_khugepaged = true,
>>>  };
>>>  
>> Will it not be better to just remove this variable? In madvise_collapse,
>> we defined cc as a local variable and set .is_khugepaged = false. The
>> same can be done in int khugepaged() - define a local variable and set
>> .is_khugepaged = true.
> 
> Since this patch has been stabilized already by 4 R-bs, it may be a headache
> to now remove this, we can do my suggestion later.
> 
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> 
>>
>>

Thank you Dev for the feedback and review.

I've attached the patch implementing your suggestion and sending this as a separate
follow-up to avoid disrupting the current series.

I’m happy to queue it for next cycle or if it’s acceptable now, please take it.

Thanks for the suggestion!

Regards,
Shivank

---
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 22 Jan 2026 12:36:28 +0000
Subject: [PATCH] mm/khugepaged: convert khugepaged_collapse_control to local
 variable in khugepaged()

Make khugepaged_collapse_control a local variable in khugepaged() instead
of static global, consistent with how madvise_collapse() handles its
collapse_control. Static storage is unnecessary here as node_load and
alloc_nmask are reset per-VMA during scanning.

No functional change.

Suggested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/khugepaged.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9f790ec34400..c18d2ce639b1 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -829,10 +829,6 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-static struct collapse_control khugepaged_collapse_control = {
-	.is_khugepaged = true,
-};
-
 static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
 {
 	int i;
@@ -2629,13 +2625,16 @@ static void khugepaged_wait_work(void)
 
 static int khugepaged(void *none)
 {
+	struct collapse_control cc = {
+		.is_khugepaged = true,
+	};
 	struct mm_slot *slot;
 
 	set_freezable();
 	set_user_nice(current, MAX_NICE);
 
 	while (!kthread_should_stop()) {
-		khugepaged_do_scan(&khugepaged_collapse_control);
+		khugepaged_do_scan(&cc);
 		khugepaged_wait_work();
 	}
 
-- 
2.43.0





