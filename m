Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35511C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 10:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C2A96B008A; Thu, 28 Aug 2025 06:49:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79A276B008C; Thu, 28 Aug 2025 06:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63AE16B0092; Thu, 28 Aug 2025 06:49:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E1A26B008A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:49:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C76DA8548D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:49:42 +0000 (UTC)
X-FDA: 83825845404.20.A4FF30D
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013014.outbound.protection.outlook.com [52.101.83.14])
	by imf15.hostedemail.com (Postfix) with ESMTP id BB26BA0012
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:49:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=RaHprtTI;
	dkim=pass header.d=arm.com header.s=selector1 header.b=RaHprtTI;
	spf=pass (imf15.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.83.14 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756378179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ql9/9cIuopnWRN0Ew7GmlRm5CWjD5Nr0GFyrsoPTDFs=;
	b=3ub0LU+WdDfn3RehCFU80uw21FXGiQb/IcM6FSCVgXBUeQUrWa+y6tnZRKNFSOUDihiUJd
	Q52hnCSgbDTm0X/wX0Dfrwnox+4mNYpyYZ35TEsKl7MFpmveQ/y7KIhi8qNYJbIzCdTFfD
	1InRwkriJd7eOU03WuXEzd1UOW4N+98=
ARC-Authentication-Results: i=3;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=RaHprtTI;
	dkim=pass header.d=arm.com header.s=selector1 header.b=RaHprtTI;
	spf=pass (imf15.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.83.14 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1756378179; a=rsa-sha256;
	cv=pass;
	b=KINfLscI+3GsSCasvbbACxv11Vrc7us9O/epdq8YqLVVSEpl5azbfzlYjeLS/ssdz6tuNg
	oBMrPST2sqHqx/DxFQGvqTNvY+v79CsA87ob1nNqVhzNA2MImTgMCO5FVeq5hz1gquyauD
	5+6jU/0frPAH6blddsRqQWUisiFDlKc=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=W6cdJizYg/Qo8q09ynkhbIP2AWsbyWb8kLTsFQyY9DaVTuai+oxcEEiqQ6uyp/njLv8v9o2MGAFqWQb/j1DGFPWrVVvm06x5bBCUABrZjeIHbTArcwWRbyOAwXfHvcf5XHQEKfbLvmoUkHSf2CtjegVfSMwO7vpbiG/mnjGZKj3m97dGoMbAXPhBovlLiCABTXTDWWy2vZNIE3ZjkJeYw5c2WcWy/rhv+UzkZaoAsGVm8yLTVUJLAs+NMmGWMICPJ8lEsCe4OxF8QKWTe6++CC8J88zOT8ud1Vk+CRc1N5rdzbotXY6y3VqB4DHbK17m6KIsz8HGXXuYwYj689wiDA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ql9/9cIuopnWRN0Ew7GmlRm5CWjD5Nr0GFyrsoPTDFs=;
 b=kdWtplf0lsHPwIsnvi6Y1g+c4TNalT40+SF2PXnRrtthFeFsLtGlW0wUWY2/Tiia8gQD68rLDRXl/+uuPzf3BhGhS5hs6GkyssJYcO6yEzSerpGopLHK6uTOxGnjBhLalYBgsNJsCppiS8hY2m6mCV5009nsIeRA7IchLGMK6s0wS3y1oFlUpAS/gzW4WP4fo+TzKTf7iFA7XkteTSES/Qjk/TJpDrJRvG8y86nAvmaNzQPZyd59nKTH2iGBQemFtAm3k74s4antkUY1MFuMYDsv0FA++8Mo1rBSMLZjt6GRd/Po009GRoHwNi5TduhiioufmPgziNmvTXNcdnCnAA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.alibaba.com smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ql9/9cIuopnWRN0Ew7GmlRm5CWjD5Nr0GFyrsoPTDFs=;
 b=RaHprtTIUZCxBjwh+yW4LPfeBkEziflNSg7AjnzkQJErKl4AIGRWilTw41QpLZgJ/2wkjuuzcmnYrDY31B7umjNmRzNgcMRYdzKGRq/fb8f6+cQBfJoQqxPY9p37wFho4YqE8R5i1bexuwNXs3caNgjBSRbMsZCmaBPYQ/IC2Ls=
Received: from DB9PR06CA0002.eurprd06.prod.outlook.com (2603:10a6:10:1db::7)
 by PAVPR08MB8800.eurprd08.prod.outlook.com (2603:10a6:102:2fc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Thu, 28 Aug
 2025 10:49:35 +0000
Received: from DB1PEPF000509E9.eurprd03.prod.outlook.com
 (2603:10a6:10:1db:cafe::e9) by DB9PR06CA0002.outlook.office365.com
 (2603:10a6:10:1db::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.16 via Frontend Transport; Thu,
 28 Aug 2025 10:49:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E9.mail.protection.outlook.com (10.167.242.59) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.11
 via Frontend Transport; Thu, 28 Aug 2025 10:49:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jmM9LOgE1zCPyiDcxlddWiE/fzC+yC5AGNXqHkv+EGnKNi98qcv64OLG8ZblwEe3zQf5UgyKYoS/lc70WVpVXI70XRsjQMrbxGqsl8+0qksLEuWNc0UOcbh76sFTjQj+BP7WFUUFBTgViNhp2OmRRvzCJaWIohOpbw5l4KN+1df66r2CQ967WP9Zh9AC+cqUstg83Ledt2JE8KJptEd73HNGo4vue+ttc9tnaadzy+MJQDhcctNU6wbXoXcDE8CaWIDBXUKA9XnhH46mTQ/zXrTH58hDrtYzwkiwdlLEu+XGzVmnxKUVY9hObbNVsw42KgRBl3xv8lG8fAOfTKHRGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ql9/9cIuopnWRN0Ew7GmlRm5CWjD5Nr0GFyrsoPTDFs=;
 b=L2hEr2GMUo4c7UGUxnxu4h8KU8GaDEMM+0+76qKSinwqdr84AyGmW2KZMANcAK9rzOL5lcGsDxgceUSTw85a9IxXP7QmiwYuJDHHeZd17ksV3INg6T6ISE/FEAyd5G8XfuqFVlWr6/+OaDAyhpKWVjz/RcJo+ZFiVqTTghLBpCMHdw3r1ec5lnofZy1B21wrFA/5aaqI8ezq+qCZozjpGPzhge15EtgEjZJPMtSFMzgrcaDYXOj+uoSK1ah9O8u0cPOR0pxQn0IrGlroCXbTbkoD/90YBbCIHo9hwIUQ6gFqlLoMl+FAotDI5YQHGOf7hcwgyO2mCeS/9FHC7sB1DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ql9/9cIuopnWRN0Ew7GmlRm5CWjD5Nr0GFyrsoPTDFs=;
 b=RaHprtTIUZCxBjwh+yW4LPfeBkEziflNSg7AjnzkQJErKl4AIGRWilTw41QpLZgJ/2wkjuuzcmnYrDY31B7umjNmRzNgcMRYdzKGRq/fb8f6+cQBfJoQqxPY9p37wFho4YqE8R5i1bexuwNXs3caNgjBSRbMsZCmaBPYQ/IC2Ls=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by PAVPR08MB9435.eurprd08.prod.outlook.com (2603:10a6:102:317::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 10:49:01 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9073.016; Thu, 28 Aug 2025
 10:49:01 +0000
Message-ID: <c8c5e818-536a-4d72-b8dc-36aeb1b61800@arm.com>
Date: Thu, 28 Aug 2025 16:18:48 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
References: <20250819134205.622806-1-npache@redhat.com>
 <e971c7e0-70f0-4ce0-b288-4b581e8c15d3@lucifer.local>
 <38b37195-28c8-4471-bd06-951083118efd@arm.com>
 <0d9c6088-536b-4d7a-8f75-9be5f0faa86f@lucifer.local>
 <CAA1CXcCqhFoGBvFK-ox2sJw7QHaFt+-Lw09BDYsAGKg4qc8nSw@mail.gmail.com>
 <CAA1CXcAXTL811VJxqyL18CUw8FNek6ibPr6pKJ_7rfGn-ZU-1A@mail.gmail.com>
 <5bea5efa-2efc-4c01-8aa1-a8711482153c@lucifer.local>
 <CAA1CXcBDq9PucQdfQRh1iqJLPB6Jn6mNy28v_AuHWb9kz1gpqQ@mail.gmail.com>
 <d110a84a-a827-48b4-91c5-67cec3e92874@lucifer.local>
 <95012dfc-d82d-4ae2-b4cd-1e8dcf15e44b@redhat.com>
 <bdbb5168-7657-4f11-a42d-b75cce7e0bca@lucifer.local>
 <e34e1ffe-c377-4c9a-b28b-ca873f3620ac@redhat.com>
 <db2320ee-6bd4-49c1-8fce-0468f48e1842@linux.alibaba.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <db2320ee-6bd4-49c1-8fce-0468f48e1842@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0054.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ac::6) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|PAVPR08MB9435:EE_|DB1PEPF000509E9:EE_|PAVPR08MB8800:EE_
X-MS-Office365-Filtering-Correlation-Id: edb5cf43-3ce7-4da9-d577-08dde6209371
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?c1FINW13d1pSTDRLcjFIR3NhYUpUZ09Pa0ZJb3cvaC9BejlPd1Uvbnp6SDJz?=
 =?utf-8?B?TW5DaFplQ3EwR2luWmlRRkdmWVlUeGhQL2J0elpNT2o0WjRQb1BXcjAxVm9a?=
 =?utf-8?B?cWRubGJQYm8vaklUbEFJRHZCWEJaWjhQdmgzWjg0QTlvaHF2amZrUVJEYkRh?=
 =?utf-8?B?WVpoVXRZZzdFSFBFSXc2THBCaytzY3JVcmNtOUNkbi9DYThwNlRmeE4xYnZY?=
 =?utf-8?B?THhzejhsZzhjR1d4VTBGVC8vbysrazFMNFR6WHk4cjlMdjRYckFBdGRHUnlh?=
 =?utf-8?B?eEJzYWFCYVVuUE1XMjlxek9zR0VvL3NVQUJXNWVhQkJydTl5RGZvcDZLR0hG?=
 =?utf-8?B?S0tiQlJHdndEOVBDNmpnQTdMdVFJYU90MDR0bWRCMFdUd0UvNUpZZWZ2Q1ZL?=
 =?utf-8?B?cG5NMXBuZFllWDhjN0lVVGNDeDJnM2tleDBmZ01zeXRObENHdkdlZjR3VjFv?=
 =?utf-8?B?WFk1N01QeVJuY2Z0dmJDcUJNNDQ1MzVpK1h5R3Z2YUg1L3Q5cjFkMUN4a0cz?=
 =?utf-8?B?aTRxVFBRNVA1clRzVE9nQ0NrcHg0THRoSGNPQVF5dXRwMndrQ1pGVVRjbWRm?=
 =?utf-8?B?NndMYzJYM0s4S1VlcUY0OHBqNlFjYkd0dGR5SnhtMnR3dDY4UWtURTRiQ1gv?=
 =?utf-8?B?K3ZVcWlxQ0lESFpCSXRQQzJRQ3pXZzBlTG5Fa1BvUmxoZmdISGFud1llNXE0?=
 =?utf-8?B?eWRTcTRRNzUrMUw4K2ZVVTYxdFowdURoT3Y4OTZIK21oYUZ1cm5LalQxZ1Vu?=
 =?utf-8?B?UzFVSVpYeFB1ZGNISHhBNGp3NlZ2eXp2ZjBIcGl5eEpQeFIyU04xUzhsWnpx?=
 =?utf-8?B?VVNRNU9lbTlUTjVLY3lBMGRsOFlvWGVnNjNhQlczZGtVbDBkSm9lcW0vOEw0?=
 =?utf-8?B?K0J5Q3E1anVReEkvYnU1K0RWNERnbFNKUkVtN2t3SGhlcGlMdWVRTENZNlBH?=
 =?utf-8?B?eDQvbHhWY05MbWxCbDA4bTUxK3dnb01NV1dCMW1VYmlFY3lpb3ROa09jWkgx?=
 =?utf-8?B?RmlHQUpFM1lWdDRwKzVVWGFNNS9EVkJ1OWhSMFd2K2RQazBpS3crd1dkdmlN?=
 =?utf-8?B?OW9aSDVmN24ydEJ0TmFMWCtsRmFGYmVySG4wckQ0VWQ3bjRJMWpuRXN0ZTEr?=
 =?utf-8?B?S2p3ZUZGUU9DOHFXUWZLRVRLNGh4SjhleHVNN3JadDFLd1poM3hZUW1rdUt6?=
 =?utf-8?B?Y2dPQzkyRXg3aDZNQldobWNHNTU4SGJsbCtBV3JlbzFYSWx2eUU5eDZpRUpi?=
 =?utf-8?B?eDdvdjVmSXJ4M3hUc1dDYzdpcUkwSDE1Q0QxK05uWTI3ZlRHZnhlRkIyMFFr?=
 =?utf-8?B?Qlo3ZkZ3Q0o0cDVPcGpoY2JCdTFuSWpwOG1pK3p3KzF0a0pudlorakxFclRo?=
 =?utf-8?B?QmFMQVlqZjY4eGhGMzhkRU51WVNpampkbHVrSTZlQStVTVNrYzQxWDVnZno1?=
 =?utf-8?B?OWZZWHhLNkN5NmJZdUE5UjFyZ3N0UG5EZ3AyQTNOdjhsSEw1STk2eE9OeFJp?=
 =?utf-8?B?MmpvVkxjalBJWklFTHpjYUFZenBqT1hRbFZ3alVVNkhpdjJCLzJma3JqM1Uw?=
 =?utf-8?B?VHlpYytKWlk4bllJV3VKTkk2TjB3Zkx6YTV4SHpuOSsrVm5HRmRSUzdxZ1ZS?=
 =?utf-8?B?TXliYWZPNndqa3NkcDBSenBNa1JLcUY4TGQ2V3Fybk5meWc4SDFoaEMrcHpC?=
 =?utf-8?B?dlU4Smp5KzczeUd4a29IR05neDNpenltb2s1cC9OcjlNMytQTDBCSFdSNG54?=
 =?utf-8?B?eXFBOXMwdnFqME5Ob25Ta0ZZa0FzV21kUXpybklMMjB5aWdNMm9QdWlVam9C?=
 =?utf-8?B?OEdmUWRXU1VXMCt0c1BEaEFYbE1BTWhxaGs3T05LeDBUbTF2ME9Fejg2YUdE?=
 =?utf-8?B?cXhERnp5T2lWTUhJd1BmWjJBdVd0UTVObUlTL3RMalJmZHJCdWxjaVRjRWVh?=
 =?utf-8?Q?HInBuVxgxP4=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9435
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509E9.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	86b1e054-879a-404e-b4eb-08dde6207fac
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700013|1800799024|7416014|376014|14060799003|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OHBaWndPWUV1SzFkL25rWDFJemVtNDhkdm1MY2JuUlVxbUUxMnBQY1FOQkd2?=
 =?utf-8?B?MXJtZWduL2xwODZvMHFSN2w4dnhERUM0UnBOM01FTXFZdEhzTVIweWt3VWUr?=
 =?utf-8?B?cjVXVWhUWHpzZDBRSFc5YnNZdnJrV1NrTG1tbHpUdEcrR1VyUnRad21sMEoy?=
 =?utf-8?B?MnBleitkVXFhTWtNTCs1dTFRSFJHbElpRExFdElvdUlNTUhQbEMyYWxLdGVC?=
 =?utf-8?B?UnYzSTE5aitFbHB1ZkFlL3VicW5nS0ZsaUV3ZWZlRjJuRGhURmpSUWwweWY5?=
 =?utf-8?B?SEl1NVVmMjBqaWtueGFQUXJLeGo0Tzl6Z3FvRUdYanVsZ3lOOHN2d2VDWm5D?=
 =?utf-8?B?bjEwNmwwWVZXVk1jVW5FTWZlRGcrc2RqZHYyTG9waitJT05QYzBaL1BvdEJ0?=
 =?utf-8?B?MmZCcTRGMkNtRTBjeWIyaG5wbGNaU25IQ0FlbWNuQjhhOGRRejR6MHFUTmcr?=
 =?utf-8?B?aDczK3JaRVBqRS81YlI2YkM5TWNjVXlZSWFNZjU5ZmFvZHlVdVg2emRRZnA1?=
 =?utf-8?B?c3Nkd0ZuQk1hVGovbkdyL0NzM0xwbkxQTVJQS0ZURXFWMFc0TTZoMlhFN0x5?=
 =?utf-8?B?ck5Bdm0rdHB4YVBJcWFadFpqU2JOV1FGZTNkY09zS056bloxV1VCcU4yN2dB?=
 =?utf-8?B?QnFWejZiQlZlRGtVU0hhUzIyV2hUU2JXUlFRZHRnYklSVVRuazQ1aWlwQzdM?=
 =?utf-8?B?NUdaQnlWZG5INlIycGh3ckdQazZSeFdJNk5ZUzFMNVZySnFqdmlNMWdaZjZC?=
 =?utf-8?B?YzZjaU12a1hUWmc1TWN5NFVrY0RxSDFEMTBrTlZhWGFCSFVpWUZMOUJhLzFY?=
 =?utf-8?B?QTRMVEc5WEJnRGdZVXBKUXpuTXg4QkV2SjJ2KzBXazJ3NVFGdVJCdWdMbXpF?=
 =?utf-8?B?NUxOWWV6QmxkNk56TnFvbVhKZXhyKytiNnd1MVVxYkhrelBkNm4vMFB3c3dX?=
 =?utf-8?B?US9hSzJjTXZUaHZIOGw2Z0k5STB2SEkxa2ZVUXdGRkhjZ2ZXQyt0aG9qaGVO?=
 =?utf-8?B?dUhOenNWVmtsNi9JWm8vcjlITWhqU3BVK3o1MFdMd2VLNG50UnFDemw5UzdB?=
 =?utf-8?B?cW5DWkdLVk9hL05xT0thNEgwMUxrdFN4bGNIZmcxaXR6RFljT3hGZlJkZmZv?=
 =?utf-8?B?bS9pRGtOUThJeDcvUlpwVUNjQ216SUgrZmJxWkNtZFFoL1BicVpvZkJheUNT?=
 =?utf-8?B?U0ZvZ1htenB6VTlieW91RE5VaG9nZXlNeVpVcXNEUmdHa1VPeHFiNGhYQWxz?=
 =?utf-8?B?VFpPYktUWDhxVTB1NUVOc3FiMUN3RDBNak5rSkJiblBKaVhPdnVLTmg1cVZx?=
 =?utf-8?B?aUMvNTZtZGJiVUNlT3MzTWx5dzdYd0FiMDNmL3Z1a2kwK3VJTU5WV3d0NTQz?=
 =?utf-8?B?aHFtQTRIVkpOMHErUVlmd2ROdEFlcUtKQVpnOHAyMDBBcERXRXk4bXZSdmNZ?=
 =?utf-8?B?MW5PYlNxSitKU0UyUUJXYUhmR3VjR3gwTzhnS0psOG5XbFhIRk5rbDBaazZI?=
 =?utf-8?B?Y0xkMG5KdEJRSnRxdWI2OTNMcGRFMWxBbTcyblhva0puU21sQ1oxUVpNV3BV?=
 =?utf-8?B?WTMzL21zU3Y0RXA4aCtJc2hWZkpTR0hTWDlIM204SjRVaXJPa0FhczVsTWtI?=
 =?utf-8?B?NWMwVktReGpPMkZFMytFazE0QmZxYzNlUEhyUEd3bjZUZXN3TGwraEpLU3FH?=
 =?utf-8?B?QTJRRGV5VWErWnl3Wms2K2I3RmRTbzBOZlBGRVZvZm9scldzLzk1WmpjSXZD?=
 =?utf-8?B?TjVidm5GaTlRSFlRVitIa2xnRDlEenIrd2lzUmFiR1NSaHBuelVoOGlQVUZa?=
 =?utf-8?B?bituYWNWODZac0dqMjdOVE52Qkh4RUg3bSt2UHlETXlSNmFqc1pNbVVnSy8w?=
 =?utf-8?B?MFVJZlROeWxXNVJxZFJIc0F4TFZBUjBWSUFMcmlkeVdFcnNiNDBSaUdIRVVp?=
 =?utf-8?B?WFFFdTN1VWE5WUJnQmxyMkQ0UFpueGFpOHJqZ1hHdnR4UXlHVlVmaHdTUWJr?=
 =?utf-8?B?Z0VoaUNjekVNV2tlS0YyNHFDNDBsQm9WT3ZXYitxQS9iTlZ1Z2FYanBWaGlt?=
 =?utf-8?Q?fb12am?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700013)(1800799024)(7416014)(376014)(14060799003)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 10:49:34.2669
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: edb5cf43-3ce7-4da9-d577-08dde6209371
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E9.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB8800
X-Stat-Signature: 46bio59oc8oaybskane9htrn1ac5zpn9
X-Rspam-User: 
X-Rspamd-Queue-Id: BB26BA0012
X-Rspamd-Server: rspam05
X-HE-Tag: 1756378178-517720
X-HE-Meta: U2FsdGVkX18nA9UPsGlzAaGOSTArelKg4q5ntdbmN6euzt1Yb7qHSaPVzJf4LmmtO+JWYbTx4igR6U9q+SKb5xkvPkY0JKC75hpxfEcjSdxl+Qef7lZ5I8QumkstHyODJs7FeGiGUeCfidxtelKqOV4cId0uhENJ7IPfk4GIJcXpFgPTWwXLLub6UKBCSKc4+Rv+AHTewJTabSzF/AhFqfvOVvEBDe89efRKa3VEtsPi3d5rwwCv5aQ7QnjnYu0t3LQCvWDERat3tzNCmc/u1mJH6mQsQ6qgceFObp7KMGC64HMfVRcIT98HOaMQ1qFmByegXHchjWvlbbbqsqlDMruJvC4IMd0bcveveqQyWGqnAKb/+BKXfarPFj4DdNqRG3lFBy2KLMrin3nNx/nGwQtDQyXa1tVxpbz8wWMJ/uflKJjJQM3v/2NZgW/A63TOQANPBTpuWa4IXvqZf1+BcqVfh33vhQ8lELMGgdViDM6eLyZuYpNNFJQfz61B5iC2FMQwDD4yx8pTdnT0sT8N1BDJKdbu6G+KOPmw6IYX/PvFNzNH9rekYWPcUc6BXx1LyrS/W5Q2pPcu19qlduKm5TAcDhe9rAytfn8Qu43mFKC9EHqvYY7OjhI2beSXUmJmNM+n+HGfNvi11REv1OUMhqblaXJ1ArLVlPWI3IqaYgEwEwXZM/1fH5+0rJw9aK1Ewokzd4cfF/ZSuSd9aeSq/GhIEJEbiuWbme1JljUgKqk/JAR/XEhH8W0YpzD5kqV4i02KECWz6dArioZkwSEDNlN7n+u6cCzlHsf8DR5AEyyAHgh+QG2PcT/CvVVztoS3L5rrFrg9n5TPAP4qZNndeoPzOO/1fCQEdYSwnnD9mvVCe1UIFf+a/aW+cKyycXm8TyWY3avVA72KQDCoexKCn+bWcJyWnpLo4boW2f6P/INoh+bKN4+PSoXR+NJxvOGDfKvshwBBvKp5i2257O9
 K23vK8Db
 nIy3HZcjccgPTnVpSMITyNAkhnkVcqQK8zdMngOHda9J5OYon50aCoV9v10eU3zgQeIBFx4yWPM6DguPpboSAsluuzyLmDKvQPhAcDejJDg+RiLxvOHsyz4Gi9iVfih5Y/f+k1a2zWDeqiP7xUCIvMHPtYWBFB+3etiDBBbjBxhEP9SOM6BkC6JePN+5sPUindheoVKuUSN0E5chnwU93VMyqqkeg7e9SgFGzVRgKJzTmmzgp3L904C32Se6zqp81ft6ASV0Xt6EB4LsNVHlIPFNF4g8MRfBOfWoD57rW626iC4x5dqIDlJ8NjHymZ/301Kx1a3Bk6FBTXCwi+chMzuuEHYowPckYx7vg3qvrCC7dB+zWdSlbm6UwiX+ekSLybnldajPqYQKEHtH1omIKust40+n7FUJ+KfjMoUCnd4djFX00aR2JQmNJqRm8/rJ8ZTTvVs78jmR6DsluvnWMQLIkmNujVDLXkwC22vX+T19VR0kYk/GFLiz7CGurzBcU9kqmgyjTJowx+hIggn0Mv5iYpGxq306+wzhSDHnovAXlyEwJX25f5HiFC0dorpemdLdLvEA6PLS8oQyXPJOx3HQPKTGO9uNJ4RX+pNbN+0DTvYJ/WoqFbCpEoNKOSPRAPtUv1r8Sd8BcadBIkrCoDrBMGjwl9GVu5/v6GQpX9ichHio/w6v+AcAEPYOk34pQmXiuSwZknTHOeg3mS+lXjVBfd7W4JQubDFrv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 28/08/25 3:16 pm, Baolin Wang wrote:
> (Sorry for chiming in late)
>
> On 2025/8/22 22:10, David Hildenbrand wrote:
>>>> Once could also easily support the value 255 (HPAGE_PMD_NR / 2- 1), 
>>>> but not sure
>>>> if we have to add that for now.
>>>
>>> Yeah not so sure about this, this is a 'just have to know' too, and 
>>> yes you
>>> might add it to the docs, but people are going to be mightily 
>>> confused, esp if
>>> it's a calculated value.
>>>
>>> I don't see any other way around having a separate tunable if we 
>>> don't just have
>>> something VERY simple like on/off.
>>
>> Yeah, not advocating that we add support for other values than 0/511, 
>> really.
>>
>>>
>>> Also the mentioned issue sounds like something that needs to be 
>>> fixed elsewhere
>>> honestly in the algorithm used to figure out mTHP ranges (I may be 
>>> wrong - and
>>> happy to stand corrected if this is somehow inherent, but reallly 
>>> feels that
>>> way).
>>
>> I think the creep is unavoidable for certain values.
>>
>> If you have the first two pages of a PMD area populated, and you 
>> allow for at least half of the #PTEs to be non/zero, you'd collapse 
>> first a
>> order-2 folio, then and order-3 ... until you reached PMD order.
>>
>> So for now we really should just support 0 / 511 to say "don't 
>> collapse if there are holes" vs. "always collapse if there is at 
>> least one pte used".
>
> If we only allow setting 0 or 511, as Nico mentioned before, "At 511, 
> no mTHP collapses would ever occur anyway, unless you have 2MB 
> disabled and other mTHP sizes enabled. Technically, at 511, only the 
> highest enabled order would ever be collapsed."
I didn't understand this statement. At 511, mTHP collapses will occur if 
khugepaged cannot get a PMD folio. Our goal is to collapse to the 
highest order folio.
>
> In other words, for the scenario you described, although there are 
> only 2 PTEs present in a PMD, it would still get collapsed into a 
> PMD-sized THP. In reality, what we probably need is just an order-2 
> mTHP collapse.
>
> If 'khugepaged_max_ptes_none' is set to 255, I think this would 
> achieve the desired result: when there are only 2 PTEs present in a 
> PMD, an order-2 mTHP collapse would be successed, but it wouldn’t 
> creep up to an order-3 mTHP collapse. That’s because:
> When attempting an order-3 mTHP collapse, 'threshold_bits' = 1, while 
> 'bits_set' = 1 (means only 1 chunk is present), so 'bits_set > 
> threshold_bits' is false, then an order-3 mTHP collapse wouldn’t be 
> attempted. No?
>
> So I have some concerns that if we only allow setting 0 or 511, it may 
> not meet the goal we have for mTHP collapsing.
>
>>>> Because, as raised in the past, I'm afraid nobody on this earth has 
>>>> a clue how
>>>> to set this parameter to values different to 0 (don't waste memory 
>>>> with khugepaged)
>>>> and 511 (page fault behavior).
>>>
>>> Yup
>>>
>>>>
>>>>
>>>> If any other value is set, essentially
>>>>     pr_warn("Unsupported 'max_ptes_none' value for mTHP collapse");
>>>>
>>>> for now and just disable it.
>>>
>>> Hmm but under what circumstances? I would just say unsupported value 
>>> not mention
>>> mTHP or people who don't use mTHP might find that confusing.
>>
>> Well, we can check whether any mTHP size is enabled while the value 
>> is set to something unexpected. We can then even print the 
>> problematic sizes if we have to.
>>
>> We could also just just say that if the value is set to something 
>> else than 511 (which is the default), it will be treated as being "0" 
>> when collapsing mthp, instead of doing any scaling.
>>
>

