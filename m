Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEE7AC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 19:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6391B6B00A2; Mon, 31 Aug 2026 15:26:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9EE6B00A4; Mon, 31 Aug 2026 15:26:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414256B00A5; Mon, 31 Aug 2026 15:26:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06C1F6B00A4
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:26:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8DB30A3A27
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:26:14 +0000 (UTC)
X-FDA: 85162545468.13.71F5E3A
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013067.outbound.protection.outlook.com [40.93.201.67])
	by imf09.hostedemail.com (Postfix) with ESMTP id AD45314000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:26:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Ttqsa0F/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788204371;
	b=nubvEqA3HsgFZtPcRVKBaGai+tusBtCCd8W8nGHjbmAsA3iT+B9Ddv9toOKhjHBSb8esM5
	So570isMKpkVNrQLM7bgY/gAXNVn0tISIRVkBCCNjc2eRriNH66TUkw2a7VT9ZtlBs2034
	XLCfhrISjiQOIuCMWtcBNFI7KT5ybkQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Ttqsa0F/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788204371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gmKfHB335PFvYjEbUGYN25bMarf1tk9j1nRdQmA714U=;
	b=KWtxR6Tg1zjnhuTVTRFfC2/x/hEk282rCmAeYEvleoNehbeQZbjLB0UNdGSAqDsm0NEKDZ
	VxpNDFGXPlXuJ2RAwlQGuIWewEcRb1AEj4IW/PVQLQ0YBHh5scXqyi1UESlLBMxHICUudH
	Mlpzat3WZB+S79/eU0kZpHBCfa9Cwoc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OkJ0bSMOyOf3HN4E4BLVEg55iFa6NuEJ5IvQTAuAwCxZELhsOoc8TchdjoMyNCOsRfQJ/UGgjc8IbGWdgQMmIiP1n6V1bDlG7rR+rZ/q+YuhOWivTtXxlJ6lIYol2I5tpd97jd4Ht7MWorQgWMxvxmUoM6EtbDR99RUWIe8LIJrg/6+tJfKJBQLUXidLB4eY1RCnVKlvhyBoYrWxCdz/TODXBgNBzawSvldc6OuMdJl2SmwmzJz3zgCp9XgCSySroUODxHVPQQbfG+d3SKyHqmVZQdY0zd4ScQy0cEnlG0APizCMvOm6wYqxf+ilyDoLlT11JPFWZxYuMTfkBghMSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gmKfHB335PFvYjEbUGYN25bMarf1tk9j1nRdQmA714U=;
 b=WUbkmMoeTk1p5CdL5Wy+E1bTX+kf8cfwOXEBExqPyiYIznMXV4oYTI0u3ofusnnpapQEfXbd4FOW5uD/Z1aJ0pDmO+saMcwH5D7I3jMpjcJrTlV+6cIwzlSd4YRsb4SZDwOyorRK5CGDCq8WfDQbwXP0L3G4GOJ49iu3zymCgiKeIZqKLzZSZmymmJM+UNUjPyzALchzNLPkVJbQiLHxZc+7B8v/fBHx3BFmpJmjzGg0biwtA5YNoMIGxsPkvb3BO0CQQNZRtqsaKC7UbRuybKeoXBgcI0JqG5ynSRtXaONTGZXaDX61lPGUw43Ie5+WO2XvoaLLeAkiQ3R2rgAgfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmKfHB335PFvYjEbUGYN25bMarf1tk9j1nRdQmA714U=;
 b=Ttqsa0F/QDFaape9r4uUt4I01dfXz1au0hAxhJ39Rbb5o8OFfMyZW9bwB35grvzxlKCPxD52QVzaGPaNC7cIsdjFpjfy20epAWRgGazsnedHINWEEZbD2hhtyH3icT1E7HZakvd9jDcy8ns0PVyIhX+VpgmwJ7Rv+7/9r/DcqyZNXj7Fr9dXxiH1xc/DHBBt6D4ayHIq6LX6+EuK3PB/anI6BEctvO0dA1KzThaZMvWYuV2UlLq4ryaypN8qx7p8JK3IZ07kTSl12bLYJCl/mfAXTUtgE5GxerpnwSz8/x5ds2PMJp7hOQEof7V0PJDSOkevzlS012Af3gORHn2X1w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ5PPF0C60B25BF.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::98a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 19:25:59 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 19:25:59 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 31 Aug 2026 15:25:37 -0400
Subject: [PATCH v2 14/14] mm/page-flags: remove PG_private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-remove-pg_private-v2-14-3668159cd9e8@nvidia.com>
References: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
In-Reply-To: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Baoquan He <baoquan.he@linux.dev>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Dave Young <ruirui.yang@linux.dev>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-ClientProxiedBy: BLAPR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:208:36e::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ5PPF0C60B25BF:EE_
X-MS-Office365-Filtering-Correlation-Id: b1c89649-0ff1-41a2-d995-08df0795afbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|6133799003|18002099003|22082099003|56012099006|11063799006|5023799004|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	yH6RBIwMfB8nK8nl5tZ890F8T/DQJgFJC7Ybgvqt4FcVSdqtV/uoM1dlxYXAdKmNvOT+AxV0gvNrSwjGu6PGxAA590uYHMlwOCmgFpilWqiulfdsc2hrOn2pVd2yv0zv18XpldAJZn3fBF9fwG/kuROO2cMyfCUmC+svj2v08bXKxZUkB2GU7iIWCFpMrGc1bz3Faly2UKeNQSrdIiI0CNuqofaNw7z/m6yW1XDCgHnNRHckw3WXDgU/roUpX5u5xD0vlEVhFIsrolMpTse+g63uxIs39ZYtgRe7Rtfd4kc5o9EL/Aoj3ThxYHMCzX4Ec55gLq/M1dizcPRiLVYdTOtI9VfMY1I6KCm/7lcV6zfWVcgm4Al7fsUvF9DN5vlkkZEL2bgPRd+unghwMfOojGAJEjRrNatD+qwIlYvmQ8ySMnrE2ofBFIy7ySrlVRi2RJOA51tx849rNlfWLT8orrjRi+KX0DFOsFo/5ytO2tNd3n/1Loo7I94gY3PWOidmVx3Y0Z1g1xE6H46x/Lg7Ya9yZhQj03Ch6yxg07DF0CLRujK/AY5MvvPQdKEnAskw6eL5mRbhndOtBGRF8oX4R1yFCojBc7w4jVKOyA9Bgd925hqgCaj5+LxTUR/j7xFFlfmDP3fhnxVQe+I7R3n6VBegF1f2OrW7g6LU4eUs/wHGRbk8fgo23gNG7fo8krVvHHIucwkq2tANHGFY5cvjsQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006)(5023799004)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVFmRHZXc0hOZjhaNHpnOHpJcVlacjV0WFYwUDRiY21QeW5XaHkxYmFLTU56?=
 =?utf-8?B?a1lKbXdKOXlKaHAyMWRHeHg1ZVNBN1R4UHpwc3pSZk9zWm9FbWUrU0QzUW0r?=
 =?utf-8?B?d0taNGo1SEFuZnhvQ0tZSTVVYmFhck1wUTVJaWhZTzViTEFSRCtudzc1aXMz?=
 =?utf-8?B?TWtleWViTDFDd09RVkZmSTNiNS80UlU0NjRYQ21oSDdYZUU0NVhXQkhhb1lM?=
 =?utf-8?B?SUxUL3YvZWJMYmlPK2FyVU11N2U5NnF0TFMvWkZvaHBNZk9lR1UxaUJ0TzF3?=
 =?utf-8?B?THE3RUI0MjdKd1RMQ1UrallWVTVEelZMbGhHYTJVZUtlbDZPRS9iekl6MUg3?=
 =?utf-8?B?T2NVRjFvT0FwalpGSXJyUFRYUUFIdVdXcnRJdUM2YkpnRDd6c0d2U2trR3JN?=
 =?utf-8?B?TG1aQTdCK0ROeHFJN3NMcXhNdnVaZTFGbUNZNVhLa3FyeVhPZGxDeDVsYWZ1?=
 =?utf-8?B?aVh5aWpsd0lPM1o4T2NITDQ0Z0FUUVVJSHNGcEFKWE5jaGhPTUZJZ3A2UkhN?=
 =?utf-8?B?SEhRZ2VKbzZueXNPY2kyTWZvYytEb25mczRpajRkaTVjSUhBTS9mN250N0h0?=
 =?utf-8?B?djFLbXN6QVovTVVTYVEvQUJNN250VTNkdUNHcGIyUUJVaXFRUHNFS0dEMVlX?=
 =?utf-8?B?eGNSdG9MTkFCT3AxMlV1a2IvVHRXZ0N3cWdYWG4yaHlXcU9rYmhpVHNRUy9D?=
 =?utf-8?B?VzI1S0N2MFlJQkpXWFFoVGxUYmp2RzZrWEtWMVJ5bVNSQWwyTXBpOEkzR04z?=
 =?utf-8?B?dkJZZHJyYmJ6TU9nRndwaGdmYXcrWS94d29yL25jbTJGNVVGWVZ4N0I5Y2FW?=
 =?utf-8?B?SFI1b25NOFhwZExkMCtibWJBMGsyRWkwZVY5N1Y0aS9kWDRhR0dwSzlkVjFx?=
 =?utf-8?B?bDBCS2p1U21nZkdPTGVjQVlKcEgwT3B0djJKRzY1Z25YbzdnRVdUcmQ0L3Zv?=
 =?utf-8?B?UjVjN2tUQjd2cEllcDc2ZTF6WS9NV1NGZjNKWGNQa05tSTFJSGNhdy9NcXpK?=
 =?utf-8?B?VHJVbkVkaExJczFSWmQ5U1ZHNlpwU2ZKVVAwQjQydG1yU212Y3RqKzdSam9t?=
 =?utf-8?B?UGNRTVZaWjJXN1ltZWxFTWptVWg0SmRZVGdIYWZrbG1HeGowTi9qakhCdDQy?=
 =?utf-8?B?ZzF5MlVCSy93cjlINWJLRENxMFZ3NlkrWXNzVkpKK2N2VmMrY25nYnVyWGdV?=
 =?utf-8?B?SkhyZm9YR2ZuTTd2K0tscXJhLzJXVkRqcWtlY3l1Z0R6VFNuaGVZWGg0OGNs?=
 =?utf-8?B?QVQ2MmZJbHh0bUZiOVZHaWNSZUx2dmJHNkhwUE45NDNRUFN6U0Vza2lhUUt2?=
 =?utf-8?B?WWxnbXFFVktWTWdCRUpuWWN0K2pYRzNvUURtT0k2VmhQSkk3eHdwNXhCTkd6?=
 =?utf-8?B?VmN0cVBjVHJEVDJOdVhoRW8wZlFURnJNZ0JTOUx0SndtMVpjWFoxUVlGYkUw?=
 =?utf-8?B?QW9LK0tzNXB0QUZLaEZ2RFZLKzZTd2p5aFlqMk0wY3hJU3ptTW5MOG5SZWcw?=
 =?utf-8?B?RUZiVXFCQ24wM1JDQldaM2ZyNW1QOHQ5Ny9KajZrK1lKTnhIZ09kbGordGlj?=
 =?utf-8?B?cStkOW95ZEdWejVLVFFWZlhhdTJRNmgyK0RMLzdyeWorRGNUdit0aEs3TEth?=
 =?utf-8?B?bll2VktXVEN0bit1U25DMndHRjdYbWtqaFI1OGpDS2tsdFVNamJpa3doV2Uv?=
 =?utf-8?B?TVJ5Ky9iQUkzLzVCbDQ0Z0lCQnI5R3dNMHFNVmtxWDVUbysydzNzMDZZVXNJ?=
 =?utf-8?B?NGZUNEQxRGVFRGhFRVQyQWNTU3IzN25WV3RtN1UwSXl6RnlNcURISHMxcml5?=
 =?utf-8?B?TmlOdjd4QkJtZmM2bHREWkF0TnBYSjB0OVVDZFg3c0lOM25nbVAzL0lIK3NB?=
 =?utf-8?B?dW5ublhWS0p2bUg5YXV5YnpPdnlIbFpsZTJIelgrNS8wcXQwNjd4QlNHUEFO?=
 =?utf-8?B?blU3bDFtSWk5dXJzOTFTemkxcDFuektKTGhmaHRzVXA5RVhwdkdUV2YrWXUv?=
 =?utf-8?B?aVRVa3J5WGhtdFk1Qm8zWXM5Z0R4VEFGV3ZzVnBkMFRsQUNUT2xkRmNWVWpJ?=
 =?utf-8?B?bkZ6anRvdTd6d0pua2IraGFRZ2hDdU5ZdEZUeWxVU085aE9MWndwQ25xMGFW?=
 =?utf-8?B?MVJCOGJFcWJnS084VHZIcEljMERhWGZTV1c5a0V6dFZ2TGI5ekRyLytUUk1h?=
 =?utf-8?B?MU5wNE9DVDMxcU9PSlc1bGMyUUhoUkt3Z09ENmxUd2FOekVpdGZDdWNod21V?=
 =?utf-8?B?VTRxb0gzWGRnUHVpb3ltRGhuYVpvcm1qSHhremQ5VWNQbGRqWEZQWG1wYUE0?=
 =?utf-8?Q?6uUnT1ETAhpwHZFJg1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1c89649-0ff1-41a2-d995-08df0795afbf
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 19:25:59.2423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CHy2tnvWWo4sErCdmDvmN7g4PzCbS7rLMbcqy2wm/Xf9zilKseRwnBQVtB6qSUE7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0C60B25BF
X-Rspam-User: 
X-Stat-Signature: kiasokaqmxmu3iribuipyy4e3yodzd1r
X-Rspamd-Queue-Id: AD45314000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1788204371-69385
X-HE-Meta: U2FsdGVkX1+IjmV/jsOlhHVo7spdf7/oJbWIwRiqJJNW7/3sk+DdsFN3TTUDrNnZWmZ1yo1p/cUf1nfwlngbb+MB4jF9wH8tc1ztkKAu+PXbbn4Tm6TvGO2Py9pWFLjZHiAhmXevUIDOQ0hOOeslXQvmpJoRy4j5otOAZcAAyBuTRqcXU6BbGqjKuEPCjZ+vyV9IzdqY02SwU+FVZjAFKHJBDj3Myak1yDvNwbMiiuVqG6voTQCi4akie6mZ7fD0VCb3uMveg7WAZisyUumPBNneKmdBPvs4GUXBJ2AijVGSLUOjTm9jN1qeFuln6aCOO1Dp/mwFYhbgLDYqhwZOeIcBHOHYTCsIYCtFgv4RbqRcKOdUrsxbcAL+hlnllYI9ToKYdSYXwcyLbVi8sX+2i9zmE2Jg0bJC72uy5UwVeQNv8Xe9FsGZqhNfU2S/nbuhcxRIiMuqefxqCpl0Sd2VZQRWXx+NYhXOAtKwgbYRCwkET0+SslB2hwpVM3o/qsk1ho6ZXf0UywKPhUuz2zXeKERwwbS/5dfpVgrdjzT3KjEm4LyI2ULUZiTZJvrZDkm5pBnczzjTXH+ivqVNT2rq6EWcIaj5l1XZC+1mQlgVZRBhfPf4czMod9Get5v+fnKg9t5MH4rqY1W6qD6uZnBm6ECkdLS5188TsM75Rq0mokjlZlcZYVEbxy/Kt/i+Bez5tut6IoFEdVpsQpwsvPoNTw8lihBJD3mkv1UxnMju436TQpHH6rVw89U2jCoY8764iHwGjhR/EpcJAmYdhPqhsamihL/0g/9oKmnQxtH9jabFsWM4GSdAVx+sCA4Ky3oaNuZdduQuYatLg4Ks+hKwGrEJ8jx0ZIYdfS4589gTOb/pI4gmAl8pbjSRECs+4W37sI0DIGGPh0JwqznZi5ImpQpE2Nvv8hk9qQwAZEz5x3ZmPwyqHK8a+68V8do09GUejDOWd4Zbzvd6eFw/jQB
 nEkc7uA8
 Thq6FHUMZJvE4YzapQgEpu/+6Hk4+NQU9RNU1CmGuLtlWNLF3ky70N74sCdRPtqWpqIw0llRwGNk6pzYO764yRqg90SS9g8geRRcx5TEx3Hf232R56R1IrjO6HYXTRQ3rx5DIgRDenLNEpwaBxmfS7lqz89VG68e7wZK+YXj1GdffotjrAtGWUCi+jliovYY8Hby6DLUdVXWslqy/gAbdTPUQVKA+65odSbskYPFk+rANFLnwfcX+3sFD7NKpQ3Voc9OBdLaJzZfeC8iGW5NnPmxpF6i4pH1zQvXXEC0uKYBAklJgBURw/GGaMe0gkVWLTHqGAMzcsnmT97bAHvCZ3WvUwDdnYW3Ms+sxXEel8OKPsmj9RafUcnUCLnTwSYPD+vm0iSUWzoxy/5A4eaAe9HIeQzzyLc555N8WR2vq3MS7IOLVdJCsgzDJF+9lFKjIFUviRqgoXiiSxCgwkk117rfU3Q37+ouEwkpsmOfveCh9TiFFnTJ4ALMdZ/otFyF1EiQN65b9ZgOMCNitTMu2HNlhRVkM7JqLoN+u2q+A/Wvsh4wLyN99jNY9xM2c8ScQIIsuEIRpqRZblf2OV1SnLRNsWHbdCEWnlxT1VYpYKCVM85z8tRyOTLoXTGAAQO43szgACvd5gCn6SHiHSWwvg/wt1zox8jzmiNkiZaIaVd+LkUrdsafCHexg68WDiQowyjuxYm80HVVQCyTd97v8m/L6G280iT+Xk6qYVRWfWaZJGCehbo67ChVPyPQ+xOzfX9r7wyncKzHpYok+4hVuzGLPNQythGdjXmvjKYvsZMshWQ7Kvk/yW6mbXELZRX8AX4fmbdg0vcbNcKHYRNIaSmpYwBMYsRBPCf8pAMFqwvCmIHCq4ZU/pWetIr7RsoJok1GsIgsVJCmKckmBCzlQ/Ju/qHT5snaSgB2duKDGMsz29A50HPIjxpbDmm+SkRsh1WWWNnIjd3VtAfdJl/6U17bulahj
 x2uw2e9w
 DBc0D1n8KcSWKNNavTUsmxYuK1jPEs3cDJRYfRLm/SQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio->private != NULL indicates a folio carries private data, replacing
PG_private. All PG_private users are converted. Remove PG_private and
reserve the space as __PG_folio for future use.

Also update files in Documentation. hugetlbfs_reserv.rst is outdated and
left unchanged. It should be rewritten.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Baoquan He <baoquan.he@linux.dev>
To: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
To: David Hildenbrand <david@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: kexec@lists.infradead.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org
---
 Documentation/admin-guide/kdump/vmcoreinfo.rst |  2 +-
 Documentation/filesystems/vfs.rst              |  6 +++---
 include/linux/page-flags.h                     | 19 ++-----------------
 include/trace/events/mmflags.h                 |  2 +-
 kernel/vmcore_info.c                           |  1 -
 5 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/Documentation/admin-guide/kdump/vmcoreinfo.rst b/Documentation/admin-guide/kdump/vmcoreinfo.rst
index 7663c610fe901..5f1df6d080508 100644
--- a/Documentation/admin-guide/kdump/vmcoreinfo.rst
+++ b/Documentation/admin-guide/kdump/vmcoreinfo.rst
@@ -325,7 +325,7 @@ NR_FREE_PAGES
 On linux-2.6.21 or later, the number of free pages is in
 vm_stat[NR_FREE_PAGES]. Used to get the number of free pages.
 
-PG_lru|PG_private|PG_swapcache|PG_swapbacked|PG_hwpoison|PG_head_mask
+PG_lru|PG_swapcache|PG_swapbacked|PG_hwpoison|PG_head_mask
 --------------------------------------------------------------------------
 
 Page attributes. These flags are used to filter various unnecessary for
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index d3a93eec3945f..dec7816303c6a 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -649,8 +649,8 @@ Writeback.
 
 The first can be used independently to the others.  The VM can try to
 release clean pages in order to reuse them.  To do this it can call
-->release_folio on clean folios with the private
-flag set.  Clean pages without PagePrivate and with no external references
+->release_folio on clean folios with folio->private set. Clean pages
+without folio->private set and with no external references
 will be released without notice being given to the address_space.
 
 To achieve this functionality, pages need to be placed on an LRU with
@@ -674,7 +674,7 @@ filemap_fdatawait_range, to wait for all writeback to complete.
 
 An address_space handler may attach extra information to a page,
 typically using the 'private' field in the 'struct page'.  If such
-information is attached, the PG_Private flag should be set.  This will
+information is attached, non-NULL 'private' field will
 cause various VM routines to make extra calls into the address_space
 handler to deal with that data.
 
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 9b585e68127a2..eb2961ed61018 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -44,10 +44,6 @@
  * Consequently, PG_reserved for a page mapped into user space can indicate
  * the zero page, the vDSO, MMIO pages or device memory.
  *
- * The PG_private bitflag is set on pagecache pages if they contain filesystem
- * specific data (which is normally at page->private). It can be used by
- * private allocations for its own usage.
- *
  * During initiation of disk I/O, PG_locked is set. This bit is set before I/O
  * and cleared when writeback _starts_ or when read _completes_. PG_writeback
  * is set before writeback starts and cleared when it finishes.
@@ -105,7 +101,7 @@ enum pageflags {
 	PG_owner_2,		/* Owner use. If pagecache, fs may use */
 	PG_arch_1,
 	PG_reserved,
-	PG_private,		/* If pagecache, has fs-private data */
+	__PG_folio,		/* Do not use: reserved for folio identification */
 	PG_private_2,		/* If pagecache, has fs aux data */
 	PG_reclaim,		/* To be reclaimed asap */
 	PG_swapbacked,		/* Page is backed by RAM/swap */
@@ -576,7 +572,7 @@ FOLIO_FLAG(swapbacked, FOLIO_HEAD_PAGE)
 /*
  * Private page markings that may be used by the filesystem that owns the page
  * for its own purposes.
- * - PG_private and PG_private_2 cause release_folio() and co to be invoked
+ * - folio->private and PG_private_2 cause release_folio() and co to be invoked
  */
 
 static __always_inline bool folio_test_private(const struct folio *folio)
@@ -584,17 +580,6 @@ static __always_inline bool folio_test_private(const struct folio *folio)
 	return folio->private;
 }
 
-static __always_inline int PagePrivate(const struct page *page)
-{
-	return !!page->private;
-}
-
-/* no-ops during transition */
-static __always_inline void folio_set_private(struct folio *folio) { }
-static __always_inline void folio_clear_private(struct folio *folio) { }
-static __always_inline void SetPagePrivate(struct page *page) { }
-static __always_inline void ClearPagePrivate(struct page *page) { }
-
 FOLIO_FLAG(private_2, FOLIO_HEAD_PAGE)
 
 /* owner_2 can be set on tail pages for anon memory */
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index 935893e5ea53b..caf090cd6f85e 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -144,7 +144,7 @@ TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
 	DEF_PAGEFLAG_NAME(owner_2),					\
 	DEF_PAGEFLAG_NAME(arch_1),					\
 	DEF_PAGEFLAG_NAME(reserved),					\
-	DEF_PAGEFLAG_NAME(private),					\
+	{ 1UL << __PG_folio, "folio" },					\
 	DEF_PAGEFLAG_NAME(private_2),					\
 	DEF_PAGEFLAG_NAME(writeback),					\
 	DEF_PAGEFLAG_NAME(head),					\
diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
index 8614430ca212a..5a417f8a922ab 100644
--- a/kernel/vmcore_info.c
+++ b/kernel/vmcore_info.c
@@ -216,7 +216,6 @@ static int __init crash_save_vmcoreinfo_init(void)
 	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
 	VMCOREINFO_NUMBER(NR_FREE_PAGES);
 	VMCOREINFO_NUMBER(PG_lru);
-	VMCOREINFO_NUMBER(PG_private);
 	VMCOREINFO_NUMBER(PG_swapcache);
 	VMCOREINFO_NUMBER(PG_swapbacked);
 #define PAGE_SLAB_MAPCOUNT_VALUE	(PGTY_slab << 24)

-- 
2.53.0


