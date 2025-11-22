Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 967EACFD2F3
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 21:26:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEA196B0024; Sat, 22 Nov 2025 16:26:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9AF06B0026; Sat, 22 Nov 2025 16:26:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62A16B0027; Sat, 22 Nov 2025 16:26:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C286E6B0024
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 16:26:56 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 57C95130A69
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 21:26:56 +0000 (UTC)
X-FDA: 84139528032.02.188B9DF
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022111.outbound.protection.outlook.com [40.107.193.111])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7236940002
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 21:26:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=hMstoJMK;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.111 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763846813; a=rsa-sha256;
	cv=pass;
	b=7K44YqlrKABRVbOTsia5IGsJJn7BiBLYy+xwSL/OZgAJLfKQk4/ohxgu/HxV2RWEID9Fi/
	jIykYEFqavyIoMxffsNoxDKAj3usOzSTkM3rvDx/DY8bPzCRPQQZVnNvcNDjhuCGBb1y5l
	WsdpehMrNLVm6Pg5CIhNVpzQY+HRL44=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=hMstoJMK;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.111 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763846813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hykKQCuZ2eIhXReQYlOZ02Qc0g6cKm/Sss7742mrWZc=;
	b=mB9rGn+RYVyANGj9hBMHy9t7nclSzQd4jUlumD5eE89TXOIgZM1gBsnIbJOxZOAsB959De
	qPb6ghuIIKi1ZuxqrOkuIS/FrJNFEeI/P83hhrwfHBqv6+8OoTsRdag4bcckPwJpnSRc8r
	8N/zJJHX5vceQyRUueRtnALWt1hZt00=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RDIrtaPxRqJXGgxDoFyYGn4ASD/Lp5vh8UhdO+b6xoshPxMX3NxS+xhkUs+LDQW4LYVmYWX+CUK77dTFe/Wc+2sbundira0uywurnU+/uYTAe2ZafeAR/5X9DsS8ziSWuTsvPUpuBHqhKc6axajgwCQc57Z3YLj3htUMdPr9Y/x5sSthYXZiDazU2W4zqizKEaR5E5czdACnQUg85YP3AADEREGnc0mBalZy0RnYOeAHxrQov0r8xHG38pOZhLc7qarvxwPtG03hAyUdOhC2zGqEFJh1R0WuUfB3vPMUuKeeo8ndqHsjP4N80zCDdYTDe8ddKCjrodVXndkkvOW7eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hykKQCuZ2eIhXReQYlOZ02Qc0g6cKm/Sss7742mrWZc=;
 b=TwwvqFXK/ClORbpEGk+sOUIsaqqaZhnDUh0MDaLGqg/sAnPyvjDH56GvZZYsK/VIo3CnrhZdM3K0Uan7Wks9lKUpatcvSMy1pHRN9TnrOpUC8br/HQ6foBBc7B2ZdsDa4oYo6FQyOAAoUw3ZPxX4jgaqAxD7oEUVYkYPsebHgb4lq/GEQWgk1ZoeAuKOchGrgElzjawxj2NazVszn68rwZ4kr/QKSj6eFFZzBMii08AVh0INcCs1ed/WGx1Bl75woyR6E3TH9tLcein5rjARQSxwivJNiL58ReDqWCJrstvhP/aKygbJ+cKbUNBOLb7QOm85VvPKvRYAffs/0Czu0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hykKQCuZ2eIhXReQYlOZ02Qc0g6cKm/Sss7742mrWZc=;
 b=hMstoJMKIfnP1WZ7i0163P0ICaUX5QmH301Mc6cj9kxVcoDQg5OYrIOZ+/Fspsf/AZ4pXaewcg8lDx5CI1n5Yg100QvmPge1GJ3MfZuHoFRls4p/4Sli1NR6Ha8zwvGhBB3+9g+eAjRND80xG5CRcpEIajLizu0wAI+OgegP//T+dlYu4qWU1Hd2OR33KrfEHrqYumKrPyVv2LHkc63lJvFH2qL2KAlwUpWuVyL0nZ6m1ywjRf6Gk44N3CVZT0rKsMu/AvN7hSt4Kub7s8tLTv99zHq4lxxwBVg/15Hv296p+6AWMwrmH1Ws/OaVX0X5NvN5UV1yTSDrl/CllVtXXw==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT3PR01MB5512.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:64::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.15; Sat, 22 Nov
 2025 21:26:49 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::50f1:2e3f:a5dd:5b4]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::50f1:2e3f:a5dd:5b4%2]) with mapi id 15.20.9343.011; Sat, 22 Nov 2025
 21:26:49 +0000
Message-ID: <c8001c6c-cedf-46c8-81e8-ac27f0d0f0a6@efficios.com>
Date: Sat, 22 Nov 2025 16:26:47 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/2] lib: Introduce hierarchical per-cpu counters
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 Martin Liu <liumartin@google.com>, David Rientjes <rientjes@google.com>,
 christian.koenig@amd.com, Shakeel Butt <shakeel.butt@linux.dev>,
 SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <liam.howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Christian Brauner <brauner@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 Yu Zhao <yuzhao@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Mateusz Guzik <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>
References: <20251120210354.1233994-1-mathieu.desnoyers@efficios.com>
 <20251120210354.1233994-2-mathieu.desnoyers@efficios.com>
 <20251121100308.65b36af9e090a78a66144c6c@linux-foundation.org>
 <a3652f6b-cd3b-45ad-a3ad-e92369cf4068@efficios.com>
Content-Language: en-US
In-Reply-To: <a3652f6b-cd3b-45ad-a3ad-e92369cf4068@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0352.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::21) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT3PR01MB5512:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b07b503-d54a-4b17-5de8-08de2a0dd876
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NndnYUh6azQ0MmdxT1JzWTNTb01zTkM0TEs2TkdSYVJIMFJwZjR0bmJUUHhR?=
 =?utf-8?B?VVlWVXM2MVVnNXlDdkpscGxJRzBMNmFScWhLUHowdHpSZkNHWXdWelQ3TXMz?=
 =?utf-8?B?azVkTGEvV2pYT1VIeFl0U096WTFtdk0yNy9PaXZLYzdXWjI5S1JHNlBzNCtn?=
 =?utf-8?B?TklvVjB3WEN4WGNCdkpGSTdMWm5vWFVIcER1WkhPeFdaUnQwVDFQdjMxOVJx?=
 =?utf-8?B?c0Y5VUdkZVY0bnc3cnBPaEdpSVBmOVU3L0UyVWRyQi9GenBNUDRINWppUkpa?=
 =?utf-8?B?UXlDTWxEN09tQlNxR21wSWN4UWhaZ0xOaSs1Q2FkN2psT3FhM1RVazFkTnhD?=
 =?utf-8?B?V2w4QWRINlRNZ0tuQjFiU3dTODA2cGd1Y3Z0dWdVOG1LZUt1bi82WnBCT0tI?=
 =?utf-8?B?eGZ5VkJsOTNtbkN5UVpXZHdpSDNwR1FndzFPdXNUckVvWXJnSlhzZnBYeWxH?=
 =?utf-8?B?S1BzKzRYYXUrRHQ1Um1SYUVPTmUzWFBaQUlEY0lJRkh2TnUrUS83NnJBbTd3?=
 =?utf-8?B?Tnl2UWw5ZHJtWFVFdXpUditDWFNuZVJUakYwR2dZaWo0WWVwcjIybVRzZVNG?=
 =?utf-8?B?SkRzdWpkTVlrUmcrWHhLSmhuSmVBRFQxckI2RlgxdTUrUVZwdjdFNGtoUEll?=
 =?utf-8?B?N2hLckRoUGtvZ25KdmpKTlphek1qREtBeVhTU2t4MWIrQUh5YVo0Q1NFMnBR?=
 =?utf-8?B?RnNOM3ZSaE9sa3hEU1VLckR1bGFlWllBRE5VZkFGUnZGOTVIMzZDaERtOFhL?=
 =?utf-8?B?RUpPZW9CVzFRaVNzYjFneTVtL1pzNjRQbmhJOVh4eXYwRXBRN01XbmprV3kx?=
 =?utf-8?B?aFNiMmFNd1Mvem1RN0tIUFFLcWppbnQwZXhTVTU5d012T1orOXNCVmRxOHp3?=
 =?utf-8?B?RGRNMkVmb2xibjR3eGhYZDNqa2J6eVhxeW9iemR0SXh5d0diQ2gybEZjSlNZ?=
 =?utf-8?B?V3dGKzZwbHpMS3BIdm4vb20zWUJaWGE4Wk9FZjR3SFJaQ0MyQmp2NUxNdXNh?=
 =?utf-8?B?RDFZV0ljbFNRR0NvSzhKNU5aRkVtUU9MeWVGRjdTMkFjOUZHb0U5bUw3bUhL?=
 =?utf-8?B?Mms3bERMUGNIQVBDYVFub2E4RHViZ3JsNWVMK2tpMVI5OEM4eE9nS2U5RjVT?=
 =?utf-8?B?RmRtMUR4eXdZdmpUWExtUkpja0VhSjhYMWl4U21BMEJIUFBoelRSVFpwQmJh?=
 =?utf-8?B?cEN0UHZFYjdYdXpkODU3T3lOV2lJcy9WOEEyRDF5bzFFdzdScHpvN3ptUjZo?=
 =?utf-8?B?T0JxZjd6Skx3d1FUUEREN2tvcC9WaHJTTHI1WjQ2dnRrNm5wS3RJMldNZzZr?=
 =?utf-8?B?NUJBN3hURlBmS0FOcVhTWFhFVFBzV2JkbmVzMkdQbDZ4dWZKdTNpWTRtbnNn?=
 =?utf-8?B?dUtTT0x1NmhzSm53TGI2KzNFdGNtOGhoS1F1S3dSYWczYlNubUNkeEZUTXhk?=
 =?utf-8?B?anI2ZkZ5eFhYdE5jL3RhdXNaTDBMNmY5Z1huVjBaa1YydEhCazhxU29jN0Yv?=
 =?utf-8?B?MDhyQ05iUko4VEJyRnlZTVgrTkRYeThLWW5XQUk1UWFNeCtUNnFRSng2ZHMy?=
 =?utf-8?B?bGxBb3NVOHdzNDVGb0N2Rm94UUNVMzBVbEVQUkgwckNCVHN0ckxhUVJBQmo4?=
 =?utf-8?B?RlJEZXN3UTBPcCs4cFdpd0poTzFDSWRYaEc3eFNxcE5qREFrUDUvWFRFK0dm?=
 =?utf-8?B?S05WZENkVVNER1JWVmFVRWN4VDBGYXJlM3FCb3dEbEQ0VWxLM0Y0Q3lSdkFB?=
 =?utf-8?B?WUErcmd2ZEpHd2VmQ3VrNlV3Z3dDL1ppUCttRDYwMXErTjhXTFZObjUrVnAr?=
 =?utf-8?B?MXRwa3FjYXEyZXF6Snkrd2F6SVhUbEU0NkJlUWs2dHdwbVczYnJDeWxVVEti?=
 =?utf-8?B?QjR3K3MyZndxaWVESmJQV0xwN2lOZVpWVjB1V3V2b2E1NFE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bnZKcnVRMFlzWUhwTGdaK1kwZzg4UUVEZnN2YUpINkN4RXg0T293dTh2UmZu?=
 =?utf-8?B?YnpDRVkxZnRPaGJWUURrTVUyUFFtRyszZWswZnh6aGtHalpGbm5zREtOalJU?=
 =?utf-8?B?c1VlNEJjNGs2WFk1Ynh0ZGJua2QraGdxTzZqWU53L2RxcUlxY0d1U0lEQWZR?=
 =?utf-8?B?Q3NzcEZJMnlXVy9mQ29NbEVaSlkzaW5UMVk4cTk2ZTBqR3JZR3RKVTBoSVI4?=
 =?utf-8?B?TEgzcFpxdmNHcnVBSElEdmlMNEMydDRORGRIcVRETG1hQk54VzhMdFJYN25n?=
 =?utf-8?B?T0prdnlUTFU1Z2JHYnpDTkVaRk9udStTeHlpL056b1E4bituUFNUTXgzZzJF?=
 =?utf-8?B?U3VwQXhxeFg4U2tOYlA0T2JYWlNDeDZjV21Uemd6VEJHVWJ4SHJNRmdzSzNZ?=
 =?utf-8?B?dnJ5Vzc1dCtGZEJMdmtOZWtkcldjek12S3RNVGtRMjVRcHNOZGZIRjVNQU1B?=
 =?utf-8?B?TU81Wk9rM05JZ2hTNHo0TTB3N2lvb2hmSkFiMWN3aDBtanBCbmJyQU51anQ4?=
 =?utf-8?B?aEcrWkZsNTVwNFE2eGNzQUZnVW5SMmozKzhLY1YvbEFERit2RUo5UXhuNjZo?=
 =?utf-8?B?eWN3aXEwWFJSMTNoQlBTS1Z2YzZoR0dRUkY1Y0FQRUdpeG1kWTBLWW5majR5?=
 =?utf-8?B?TWdGaWN4WWJsRVRwUGZETHVRbmYzRXBub0ZmdmVWcnIxamxkcXdpVEdsL1Uz?=
 =?utf-8?B?bkVJcjMzU0hYdUViaEUwWG5RRVlMUnlmaVNNcGxiUGg0TWM1ZHkyRWZubnow?=
 =?utf-8?B?aTdVSTJWOS84UUJvc29RR01ndnIyZWlrcGFvNXB5eEtYMHQ5aFZEM29PMUIy?=
 =?utf-8?B?Z0hLeFdDWnEvZmtvOHlNcDZwOG1peGZZWWhBbHdqREEvUFU0eGdVSkEybjBs?=
 =?utf-8?B?N1luTFZhYlMweFBvYUIxT09LMWFvYlAwUTFZODVIUjhIZmZVVmZEaEdaZ2FH?=
 =?utf-8?B?V1NwQ0FSL3Z5V3dWSGQyN3doZE5pVm1aU1lUMVFHRlFkU1FBcTBUL2VFQlF0?=
 =?utf-8?B?ZFRlK0FrT21ycGthNFpXSjY3S1RueTdHMzRXbXMvZ2x5OUdvK1JyWlR5M05G?=
 =?utf-8?B?SXk3c1NnN0hqaVlic0xuUkkvY0YxSVUzT0JuZ0lUTXIwOTN0akE3VWNrNktj?=
 =?utf-8?B?UmwvWDYyemE2M2txOU5hQTBnSGtqVUlQaVJSVXVvRmh1bFpRUk1SYmFrZktu?=
 =?utf-8?B?QjMxaUZ2RWJpdldhdHhOZTh0ODBpYUVxZlZRbGJDekxEMTVISWVzVVA5dFVJ?=
 =?utf-8?B?WFB3RUlpaFJkdHdkTUkrc0lGdTN2bGZ1ZU9ibVIvdk1GUmRaelVaKzRscGM1?=
 =?utf-8?B?akRSMy9pSVlQZ1ZJeEdWNEZHc2RwWml3OEk2RlhRbUZhd08zU20yRXMvSG13?=
 =?utf-8?B?TDlTb2kxVnJNRDQwK25DSGMvWGRhMGlmMnZ0M2thTmZQOWkzcnFUMVJ1enor?=
 =?utf-8?B?YmZDVlpQOWNkVFJqbGg3WVRRN2tqVG01OGZIU09Dd1RuVVIzSVBIQzQ3alR3?=
 =?utf-8?B?djRhNEt0bHFwL2szVFdBRGN4cmxTeWF1azBiSkNYZUFsZzZnQUdFVkFpVHRz?=
 =?utf-8?B?YWJQVWlQY3JSbWFYTS91aVQ1OC8xQnk0US82M2hETjJjVE5FcERFaUdtT0dY?=
 =?utf-8?B?Z2VNeFdZdXA3NFVhYXdqSkNiOVQ3OHdMZVdZRko1QmUreDFoc09GZXJSRm51?=
 =?utf-8?B?SEE1MWgwVzVRbS9jYWZ3ZDAxNndPVzRiUVBFTHRZK2xZaWRMV21IY1huaTVv?=
 =?utf-8?B?OUFhcW54T1FqNGx5L05zK1Z2QkhvQXFFUDM2dEtaQVJ4N3padXRtcXNtTGpK?=
 =?utf-8?B?MExFS3hZdGZ3bWNQQVA5aGpQNjc3MENTNkxOMDdmKzVOTHBsc25Ib0RVSFVG?=
 =?utf-8?B?bUdaMWE1c0prR0cxSHE3R1R4K3hOZVlMdmFGRHhkQ1RxZFQ3eWFvYXZYc09l?=
 =?utf-8?B?Y200eW5mM3Z3QnlmYVJTUFBnT1BDM1VIMWRQWk1LTXVQbnJ1M0MxbjdQTlV4?=
 =?utf-8?B?bmlJWHRDRWFCeXFXWHdjb3RzSXVJVE13bmR0Y2ZxWk1xeUtuc1hlWVpFNy9w?=
 =?utf-8?B?MERpVnpZcGZaK0ljNE0xYzFOajh3M3Q1ZFNEOTJBRXFOSlprM0gzdi95SzZt?=
 =?utf-8?B?OE9WVUQvZ1MxZWNYNE4veDdYaFZCQVloV2s5WXphaEZESUxtZFl1SFZseDlo?=
 =?utf-8?Q?R0GCgdkiEZtQn7iRFuDxJdA=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b07b503-d54a-4b17-5de8-08de2a0dd876
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2025 21:26:48.9546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: klUc6QaSadqkLQzva2IvASubHKlnqnc5pvX+e3zT/aA4cE6ov/42/VIdH7HtzlRH/4ptZMN+GgnTgQQC0KGC/rXx/WydnVir8ycrQFv4lQs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB5512
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7236940002
X-Stat-Signature: r44kapcykafi8btf111ysb4wtmme4973
X-HE-Tag: 1763846813-260717
X-HE-Meta: U2FsdGVkX1+I5IuT5S6pLEFRoATiDdny+LPVM+wrmV9DstXO/Wt/orNV40FhhUK724PQyzNT+muxJ+Iwb/sMM5fWSMOWeFaVCAWZRihr9oHygcD4QYEuUChO1IysG2ZUN8345TPE0KfnWshxxrz5efAKDt28TPcdAF1TCS1R6a+ompcadowtv8ilX65s+S3AQNyiS7RZxAcfpVBEL4YmZN9z38/NpcSnPea8N8jOL+EIwpQKIpg9w4U/LHHrSnYfPmj7dU1VvYDvwHV9IBN5Q2ELSABQ1woCuPnTdhfFXcaATiBov+YsK6UVgd6tnaCFPeR+k2fXRV2kyg/IAANDkE9DRyVOuo8HoLk1PnZEuPDnrHTY0AQfWC3qdRxgWZfGZ57w6zzkrgHRHkfapLrGe5EycaYMMKZhGFcrcWRctP63noHB2zmhhOyBIiic+eTFVcfWUHv0pnnLhtmp2X4AOBtY6rkjl+kIXt7uSBdzBmTW04zexycpTjpOiGx4kvlRl/g18YugdCnQPBvRTlJ8C3wVa3XLcqjs8JK7d401nhAArpsua7KaUW7cD4Qsd4DiKSi1kCWOXzCz4qhxOXgjB68UNlecgs2k5WqSrfN5JWJWJ5PH+skU1h9wBTX/2d4Ntz9g+vGnWaesJjcVqX6VecoMJ/1E0vXbvaVRaq99veda7atWorl8l7nVxizEPdaSWg5BYqrAM9ElTaKw+3fS1xh4jVF/FU9hjs7yL1NYf9/O4pDDRVEfj/3IYyul8yGBvfkeEpPo5mTQX/le7QATEJXkU3kdVdhLEIzPAlEs7Iy7Ik6fw38mDUcyulaAnRn/7IZ1v5f+TwZv8gpi3D3jqWtBkcQTjlMIj/zydi9NuBBuwuC8lRaBk6d/Y4FGzl5nZJacgDwS7jNkwDOmHORdGCACu3nLJUDlUCrJ4/S9Yu/Na3bXZSKnHWA4rMPPc6dUHIEmvzSvUspJTTiLLhO
 CT2HBRiH
 HjuUsYXbEiXcYKYQhl4XIz0b1w1zmycERYg8R8/qlEaD+vIBqjvG/Be9A4G7o6GCf4vQJF6VXNx8j0A9rAX4XAw6MnO6myDHMVb6hbHeX9iLyT4JaoHqXcnlOYoVfN/5ODq0PecdP5cPP1Gr/UEF/p5osIbMGFhAv5Gj1kLZdk4Mz2DjuOwAuL0auHXRoN1iydVv8vtOtcZEGzHCXMv+JpyLyIDLFR/o3/qkNrbrXnnhibhIdU18OOUz5InCklaha2QhFGEu6AKBaqzdLS2UED391NL3N/YYxZAAG9PS3aVfRNG0TuJ1gpyt0zroSkgmGi+8G5qQzitzrBi0h285STv3i9eKzw9nRtlEduUkC6jhs1QiYyAdfDvJG4Cm84kPqnoLth6yg4h0QDJgWExBYhP5t13I+AA5ws+P6fhXLel/Pp4ut95b3LjWI/jmbyPgIyn9pmEHlkHKteGZ8KZbMq3hgdYEQc845oBpgppxypEfHlupDihU6XRTuGCJrduRW0c/A2DokWYmtbg/OvquDAE2E8uJ9NL/VunMjtBlp5EVfOOA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-22 12:15, Mathieu Desnoyers wrote:
>... 
> The fact that the max inaccuracy is bounded means that we can perform
> approximate comparisons in a fast path (which is enough if the values
> to compare greatly vary), and only have to do the more expensive
> "precise" comparison when values are close to each other and we
> actually care about their relative order.
> 
> I'm thinking memory usage tracking, runtime usage (scheduler ?), cgroups
> ressource accounting.

Another use-case worth explicitly mentioning is accounting the
resources (memory, CPU, I/O) used by a given entity (process,
cgroup) and enforce quota validation based on a configured
capacity limit.

This is a comparison with a limit which can be much larger than
the current resource usage value. Therefore, because the inaccuracy
is known, it is possible to enforce the quota limit with an
approximate comparison, and only use a precise sum when the current
value is near the limit, and rate-limit the frequency at which precise
limit validation is done.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

