Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C2F0D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 10:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E69CD6B0008; Mon, 15 Dec 2025 05:07:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E416D6B000A; Mon, 15 Dec 2025 05:07:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE32D6B000C; Mon, 15 Dec 2025 05:07:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB55C6B0008
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:07:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5DAF0C02D3
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:07:56 +0000 (UTC)
X-FDA: 84221279352.27.1F62378
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011045.outbound.protection.outlook.com [40.107.130.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id DF92440004
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:07:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ni+7SixG;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ni+7SixG;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf07.hostedemail.com: domain of YeoReum.Yun@arm.com designates 40.107.130.45 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1765793273; a=rsa-sha256;
	cv=pass;
	b=h6wkmtJi6cHLayq6rBpxkapGYu0L6HhEcy0ywxo9yOhcfpP5FD34WLCBzouAWVPTZxsjin
	I8zkCj6GMc8R3XsCMvXUErfzyiblggNUsAlWoUBPMlVm6U5x/A9ATI1gL1qz0GuTbdW2vu
	lqNU0TbTf3EgCGveb2lziFodtdbXs2M=
ARC-Authentication-Results: i=3;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ni+7SixG;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ni+7SixG;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf07.hostedemail.com: domain of YeoReum.Yun@arm.com designates 40.107.130.45 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765793273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KGIRq0E9K4iLo5rVR6sOX3z6XnMD3R4ajv9E7JKv9jA=;
	b=5li59/NjPkJ2TQXNZvg6JNecA5kJdnECcwoYUfk0F+cYHxuyxMp/n5fxXTNlj+F+pyEIyb
	J0Bww8hb9eMs7sLyuWEjg51Ld+BzY6A0/sj+OdhCsQ24X6sre08GTjHlJw69axPUENKYQH
	Q5Gq5EaByWSUV0jVeX9+AgCBNiX6eDw=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=AoDc7Qlsl1OhxAkYrKni0MSg5yegjqG1TCeHLc9eekeAmPm5oOpr7xN6Vhxe7JIRqgWc+0Eoj70oDnczMoFDFLYvoHZYdoZd/EVIiWolVfKWZekfYiWPJbL5yoU3+3P/mFJs9wP8F+XgAKUFt6kU26GUzW+kdRspvbshnQWzmq5Rvw04IPF28AywPgsVibZ9n/akkxsRBiKWZMI7eBIo8wLZwXktqC1lB+ig0n45Px4eZLWbIjejxCsPeaUkEGLpn+zani7eXuktA2dw2J6KHhDgY9igZrKtZpr/2QYTafumBaijgZu4Kj0OhBH+b/E5PL7t0ObEcm1k0WLC92j9nw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KGIRq0E9K4iLo5rVR6sOX3z6XnMD3R4ajv9E7JKv9jA=;
 b=xBy933rBtanxVbMvlSgm4FiW8fullH6w+tPf6X6ZqTIlozIlzRGX5gpqSyku+4mR1oGUTGILRY0TFjTSRIh2XMiB8M5MOrC2fUBKAaZ5yZ0qzhQBRFyFRK36twnI+dwqjk75+nsy7nvwbzHGBgUBO+j0rk/6HgAIREOPSH5VupjN0ANGHCBrezt3ekOmNuBoyvGUND6XLXzZf/ViFsuiUAoqn0EVUfNuQvbF+cqK81eRV0qiv+114x1ah/Th/sO2kzKBAD9juY8L1jY60xuwEy3kTrBQXbdkDclkVF2E3TrsqN/V8ZJIN4EGRw4pJUqcV+XJ9IOKQ+dz5xvlmuYSSg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KGIRq0E9K4iLo5rVR6sOX3z6XnMD3R4ajv9E7JKv9jA=;
 b=ni+7SixGYmO+qgVXC/RJlqSEYNtFU4q8/wZsWKVPTpA71tCXnClZDdSu2h4jvLqiTQZ+uYTCCdBavY7NrcdZYt4EAUG7k8yjYrjX+y+0nLM+gPVN3n35deXBptxFfHzSVwUPyppgtcxAfzNGEOu02nRSRsDoppdFzWpHRo7sOyI=
Received: from DUZPR01CA0280.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b9::26) by PA4PR08MB7642.eurprd08.prod.outlook.com
 (2603:10a6:102:260::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Mon, 15 Dec
 2025 10:07:47 +0000
Received: from DB1PEPF000509F1.eurprd03.prod.outlook.com
 (2603:10a6:10:4b9:cafe::85) by DUZPR01CA0280.outlook.office365.com
 (2603:10a6:10:4b9::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Mon,
 15 Dec 2025 10:07:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F1.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Mon, 15 Dec 2025 10:07:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NyccDOf6BBG2i4rGzfJqK41BGpgZClxFfnZAtLU7z3PjeubxIkl2T8Jj+UsOurKSs8UrsrObSyEYZSeLYL53jAk8NiDcrg3PNQ0ZspOCZPwrb8KRwQ8HDF3Ar1KCXYgtaUz8MhI7B3taRlnCdSMz70pgQPobJX4scOnQly7ERTNsbNWRVhzIvn6RtYUZlxDOSbilh2J8nE7DuN/LYdq2dHTmmaXgtzRD3UCzjukayLRUzXRrCCDE54AJJ2FyLZ54wVVb6zhuH2LbQ+kLWr83NtHSWla+gQ3We9ChfXxqY7ed6zdziLSXnIjeGYP3KB2jJB4VxirIWqgdTeWwEOkk2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KGIRq0E9K4iLo5rVR6sOX3z6XnMD3R4ajv9E7JKv9jA=;
 b=o2lcTFovJjSi5TYkT3bstlgdT6upO9/CFclAF2sDfmxDMZJ+zNQ0IDodDuvxTqMwJ3TGXkBmzRUmPnsJ7hU8IgAJaaNzuLPsPMrQAVVOOPjhJxpahx82X09IrkWhyUXjp0BK76sbZXpjs3+3/jCTS118JknZOlx3uF+6mEsRmjSvieYxtJMXUvykOoaT5OBTfm07h0m2g4zasuJiJVwYc4FrxBNKNqmjtJqmnay1RkAQc7S/bCUM6OzPqrC56nc8ohXDxo0pS2iTIEHHpPKoWHYAKyh3aTq+JVHmhboU8DNX5fJT9R25NLCzWxldF9sbdliBjaNtBI48GQ5IQNyKVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KGIRq0E9K4iLo5rVR6sOX3z6XnMD3R4ajv9E7JKv9jA=;
 b=ni+7SixGYmO+qgVXC/RJlqSEYNtFU4q8/wZsWKVPTpA71tCXnClZDdSu2h4jvLqiTQZ+uYTCCdBavY7NrcdZYt4EAUG7k8yjYrjX+y+0nLM+gPVN3n35deXBptxFfHzSVwUPyppgtcxAfzNGEOu02nRSRsDoppdFzWpHRo7sOyI=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DB9PR08MB9804.eurprd08.prod.outlook.com
 (2603:10a6:10:45f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 10:06:43 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%3]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 10:06:42 +0000
Date: Mon, 15 Dec 2025 10:06:38 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ast@kernel.org,
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
	eddyz87@gmail.com, song@kernel.org, yonghong.song@linux.dev,
	john.fastabend@gmail.com, kpsingh@kernel.org, sdf@fomichev.me,
	haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
	ziy@nvidia.com, bigeasy@linutronix.de, clrkwllms@kernel.org,
	rostedt@goodmis.org, catalin.marinas@arm.com, will@kernel.org,
	ryan.roberts@arm.com, kevin.brodsky@arm.com, dev.jain@arm.com,
	yang@os.amperecomputing.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] arm64: mmu: use pagetable_alloc_nolock() while
 stop_machine()
Message-ID: <aT/drjN1BkvyAGoi@e129823.arm.com>
References: <20251212161832.2067134-1-yeoreum.yun@arm.com>
 <20251212161832.2067134-3-yeoreum.yun@arm.com>
 <CA+i-1C2e7QNTy5u=HF7tLsLXLq4xYbMTCbNjWGAxHz4uwgR05g@mail.gmail.com>
 <aT5/y3cSGIzi2K+m@e129823.arm.com>
 <DEYOI8H2OESD.1H56D3H8HKILB@google.com>
 <aT/WOAr4osoJWaMS@e129823.arm.com>
 <DEYP7JSVTB9D.3EFN2KEHH3O79@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DEYP7JSVTB9D.3EFN2KEHH3O79@google.com>
X-ClientProxiedBy: LO3P123CA0005.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::10) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DB9PR08MB9804:EE_|DB1PEPF000509F1:EE_|PA4PR08MB7642:EE_
X-MS-Office365-Filtering-Correlation-Id: a26f722a-8b62-479f-26e3-08de3bc1cbb8
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?OGNTU05FTHNaZTAvZlRQVXhrNUUzTEJSdng4aEpqcVIyQm5VM3Y0OGx5MXZw?=
 =?utf-8?B?Y0FsdXNWcTYyNlFVRTRwamdvNktjcUNIOEY0bUtmWVduTmptZWFlUEVCS2o4?=
 =?utf-8?B?bUo5aUQ1ZnVTT3ljSVhEOVU4U0NSeE9OMHg0QUVnaXdHT0U0K2poN3pqMEJZ?=
 =?utf-8?B?bGYzK0RUYVIvRTYrSzVNYXhFSGlIR0dNd1hOQ3I3MDRtdHhVS2ErVFFEVW5s?=
 =?utf-8?B?TEV6WXZQS00yY2RCcUZqcGt2Q0lTSmVmTklITU03WUFaZlA5WllLL0hlak5o?=
 =?utf-8?B?NVVKczNoa3licHd6YzhKdWNlQ21WQWo3aUtXbWVWQmpPNHJYQVVjdUFDNG84?=
 =?utf-8?B?NHIxRTQwTi9xRi9DLzUyYWluZTRRazdvc2pYS08xUlRhM21FNXp6MUowUzN5?=
 =?utf-8?B?eFprdWMzMU13dUZiV0NFcXovUy9Bd3pMUENKbUtmcVcwRHRYbkw5dC9mUkx6?=
 =?utf-8?B?QnB6SkpsRThGYUM1bzZ2QUNSUmt2aFRhTGVFckcyTFV1QWZzUmRhZHhmaDFI?=
 =?utf-8?B?Q1A5aEFHcU16bi9EcHQ5VkNQbFdmeVh3bFd1OXh5WkhnUmM1WVl2dFhuY004?=
 =?utf-8?B?ampMVHhUbHFYREhJN1pBU1BMMnVTN3BPZVNHYUlPQkJIYzJ6ZktmR1hLdzU2?=
 =?utf-8?B?NldNVm9IbWdIUzVHUlFyQ25DMi9IRlZuVy9XYWc0NEJWZ094TzBuWHlBU0ox?=
 =?utf-8?B?SXZQQ1AzaXV6dnRPNE9FNDhsTWFTR3FtSFJrN2o4UXlRRWFSQkJCdHJCVWp5?=
 =?utf-8?B?WjdXSy95THRqMDhBVlpPUTdJNHpsRFlGeE4rVHRkNmRZcmJBMXZLUGxVK1Zt?=
 =?utf-8?B?MHBxdmYzY3EzRm5MK0JSSUh3bFpDYkpMQlJrTWVjdU4rU1lMTHBVR040YVVr?=
 =?utf-8?B?ZUttYjcvb1VxblpBU0JlS1M4VDlUUExzTmQ2cFFKajc1V2s1MUU2MXhYNHZs?=
 =?utf-8?B?M3JhNjBzWEpHQmoxa09sVnZNNXpDaitGMG9Cdjk4cXZWQW9RRytsN1hZclg4?=
 =?utf-8?B?MWFES01JeENPUkxhQk0yL2l1RmQyT0c5YzI1L2FaZUk2Nk1hd01TTnhNZGVa?=
 =?utf-8?B?aFMxMzFEcGRhUk4rQmtaT1pPK3MxWWNQakRaMHR6aSs4dE5FQXlSLytKMzVP?=
 =?utf-8?B?S0dNcU9oeWZCWnNuQ3ZkaGdSUlhvRUtid25VaUZYZlkzalNhV3oyRWlGMEE3?=
 =?utf-8?B?T25jeGRKNVBaTHYyMHZab055SndJZnp4WXgyaE16eXRQTkpBTHlWeVdTWjZE?=
 =?utf-8?B?WkpKZHZSVzMya3lGVC9VbURFSnhtSWlVQlZGalR6NktMRWtZWHBvci9BOG1K?=
 =?utf-8?B?UCtTU2JDb3RmOE5HZVRwWnJTWnNMaG45K2tlMXNKYW13ZWxISDErOFBFRUV0?=
 =?utf-8?B?Rng0VTJjd2diaGlEQ2UxMWp6U2t4K1BqMldmbG1qcGZ6WS9WQ3IzdXBiL0dE?=
 =?utf-8?B?dGxlMnltODgwbkZWWExJY0s2K0c0K2QzcFlpMHpoUEVVZGdJSlJRQTZWcHNq?=
 =?utf-8?B?NkxNelFpaXQrTVBuSXZKZzJwRTl6NERsK2FGdFI5SWYvTmJlQlQwOFFVTzcv?=
 =?utf-8?B?NUNjQVpZdlhKSGE0RGZjK3h2MkwydzBibFpMMjF2ZGIyYU9sYkg3dXE1WlQv?=
 =?utf-8?B?elpqRExYbmF5cWU4dEVsMGVXT2dSYU1PbVBMalhDQ09XMURZd0xEcUowYjRr?=
 =?utf-8?B?VXVEUk1hWDBSSXcxWEZVVDF0QmdxWlJTSHZTbjltK0krc1I0am1BSXRsbWlH?=
 =?utf-8?B?MHVLc3ZkWWZDandZcHpXSHZFdHFIQjZFUU1NbXZrQ2J6WHNMR1lMak5COHVW?=
 =?utf-8?B?ZTU4TmE3TEdsZisrUjFqV1VSSXlGT3VzSGlXK0JqVmtYOU51SkhTQUxheEtO?=
 =?utf-8?B?L3N2T1I4ZVVLcWhKeGh1emIxTUQ5ZWlnd2wyMW9OSTNVc0dycVk1T2lZemNV?=
 =?utf-8?Q?SVkaxDxbUnHlg+c8YaDmilvEWQw2houn?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9804
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F1.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6cba7bb2-7d07-4016-7506-08de3bc1a55f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|14060799003|36860700013|35042699022|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dXNIeTNKK3h4Y0Uxdi96NUJ5NzdLVnlRN0FhSnY3dGdiNFVNUVZiOFpWQ0VM?=
 =?utf-8?B?VlpQQjAyUGVJTjYwVzc3eVVHMUFoc2lhaVlwK2hETVJ2ano2d0c3QWRkTDU0?=
 =?utf-8?B?N09JdlJLZUdOQlpkOFJUQ25iRmVaMk5OV2VsQk80akpQRm1lblJUOVJJazRt?=
 =?utf-8?B?cjhXZm83djhNSCtxSzZCVXJzelhJbmJENFFldG5PcFA5MVdDNnZnMC9qU29I?=
 =?utf-8?B?SDRrdDRVYU5QNHlDcjlwWWRVeXBMQk11a0trTyt2eWZqZ05WWXVZbmlEL01M?=
 =?utf-8?B?Sms5REhydDRhNGJlTlVOczFVaXR4OG52K25wRDlxZGdtV2QrSm5aSjZHTW1l?=
 =?utf-8?B?ZW1sdWhpaHdTd2pkeXZJRkUyKzVTWkd2NHZFVTNFaWpwTVZWZDVMMkJscHI3?=
 =?utf-8?B?SDVDWkpQZEhPMGpkUE9ybnk3R1FwT1BPZTFqOFZUUFZHZzBwZ0svRVUyaDdv?=
 =?utf-8?B?OURXSGdKazlUYnA0UXFRS25jL0Q1dGdRRzZnRDVmbVhpU09ZbHMyWC95YWxF?=
 =?utf-8?B?bFlkSkZwbUxSTmpuN01PZ2NGOGJOeFY1V05STGtaTVJIcDJibVE0OXVBRmVK?=
 =?utf-8?B?cGsvQnh4MW0ybllldHFDMWJZTXNTSzk1NkU1M2RaM0szRmVtWUpNTWt3eU00?=
 =?utf-8?B?VFZ3SUZ3aWpBQ3JWbHhIZVYrUTVVYUN2U2pRY0djQ1g4bSt1bE50WnJCODRK?=
 =?utf-8?B?ZmM2YzIwMTlGWlBoaThCdW9HYnN6TEFwTkdycWN6UENUZEdqbVpnSUtaeGN5?=
 =?utf-8?B?QU84VWwxWU1EVDBrUXdibzJPVnVrb0NKVXVmZjNYY1cyMjZYZWVQbHBPeXRZ?=
 =?utf-8?B?NlJHV3M0bTBYejdDZzlnMTdHT0RsMlZ2QitGYmYzQzNYSVZaK2cwSU50SXo4?=
 =?utf-8?B?VStJMzk2bHdyd3BqSWYzd3NTSlBUelJoY0dDZnIrdUxRRDlXd21qbTgwcjUv?=
 =?utf-8?B?QUY5OGs4WDVvVTNVeVhLT3FVNWphSkNpQUJLQVlVS2xDVTAvZVpqTTZXeU5L?=
 =?utf-8?B?V1lEdTkyeWMzbFc4cjFYanBhNHpKbGVSVjBPY1lYYkVaSEtJZDVzMkhxV1pv?=
 =?utf-8?B?dUZUZjUvYVdVTlM1U1FhSjdoeUErTzBHUnJOUkVGM0doMEVhVE9scWxYK2Y4?=
 =?utf-8?B?aFFQSlhicm9ieGdCeEJIaVF4N0NMeVU0QXc0ZEpaVi93YTBwcFlpdXQ0bnpr?=
 =?utf-8?B?MTd4SmNZb0NDMnJzOFk5VUZrMTI4WDk2dmJRaUc4ME0zKytWUEdDUkxCUlA0?=
 =?utf-8?B?S2lwcWJWNmExQmZuK2hGeUN2K2tTejdpNEh6Y3JtQ0Y4V2c3NVhGa1BmVTgx?=
 =?utf-8?B?N3pOVjg5N2d6WG1ZLzEvZTlBMzhCQzRqSDY4V0hCR0tROTllMkh1aWdlQXdV?=
 =?utf-8?B?WmJqRU5vbkF6SXQrcmE3NEdKNEdUZUtXS2o4NXVjL3dGRzJoQVBITER2ZjRB?=
 =?utf-8?B?WTZuMGZWanJqRkhxVXZEYmt5TkR2MXFVTEZuNzdsTG9mRFNVb3Z3VUlJTW4y?=
 =?utf-8?B?QlpHcUgxek13MzNGcGVsVkFVQmIzNm5pSE5ZclhnUlNVbUZHd3M3UHlHQ1NC?=
 =?utf-8?B?bDRab1FuNnNibFZTRkRVcWtJZ1ZrVit4LzgwbHZSVUZMdFEzQkZtejh2c3lF?=
 =?utf-8?B?VmRNcFNhcVlHdVpGV1ZWVHozSXRmYjE1UW91c0lGTUdGZkhWejI0b01IMVJC?=
 =?utf-8?B?TStqNk4yS2psc1o0UHNUcXl5UEtlQ2krSHJqMUNGV0pNRWkzSVFpTURydWhY?=
 =?utf-8?B?SzlYT20zeDg3M1M4M2p4M29TZkx6OWJJMFltZ3NYN3E5WjB4OHhyMW9Nb2tT?=
 =?utf-8?B?aDR5S0hmNTFFUFZKTGdlT1NkWTVSUHBVQ1Nxa2lCNUYvODloYVFiZkFrOTNa?=
 =?utf-8?B?QzcxY3R1UjUva3V0Yi91NmtlT3pTQmhhcXplb25QazNmR1dKc1FCSkxkV1l0?=
 =?utf-8?B?bjFmd3RkaU5RYWJKbFQrdWU1dFI5cVk1Q2pWYXR6RzVNOVpxdmhrMFNRenhp?=
 =?utf-8?B?M3ZLeUlRSm8wdUY0eXF6dEJOZi81dW1Ic1p1NzU2NlVXWWY1VDN6SzNHa2dT?=
 =?utf-8?B?dXhPYld3NEs2VG9vN1lHZ3RKZElRdFZBeEdyZHNzdm9DY0R6V0k3dzNyc1V4?=
 =?utf-8?Q?xtbE=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(14060799003)(36860700013)(35042699022)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 10:07:46.5160
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a26f722a-8b62-479f-26e3-08de3bc1cbb8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F1.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB7642
X-Rspamd-Queue-Id: DF92440004
X-Stat-Signature: wuopq9id65rp9y4axh8e8jp9g8uzohy8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765793272-398759
X-HE-Meta: U2FsdGVkX1+92FqQW7Wfxp/jFbmC7SqjcdTxfuAqGg1RBJ7jMx0eG6Hvh5Q8SbQVgc2liDGaR7flUns63XpwfWCdraVQ2KkGKVQ/sFq8lVH4wIqA9gP+y3bC6LUXIEY023XJ9+io/22gpbwGFb1QX9ZCpzmgIxrdn4DMc7p2njK9W8DOSocuUNJEEcw2NiKAG+lLYjnltRzH60NCK2WkSXdlqUKjG+UO1keYUhRS/E4EYemXdwq5/ygGintm7Y22VMkKou1bo8DU94tyiw/bEDIyZqsBfFXj+zKOyJBE4CrbrohNdcGGnSUnCCQCllCDjdBqDkvm9dWsztwL3SyQ4ZFdQYlToaYbzSL+3O8k0cCZM/+fsJAgQXpZknQKqSviUKCSGFqtbpxljQjqG2sTYYHVA0sKfXTkQefeB/zjDhrhslLERuHOyp0p+NG6YGtdGRxjgu5MURx/T2iCu8w5GKc9ZX6ERMheR9JyZbTIuDIJm/izdJKcb0ga8cO7d0kyniis8c4kOjL5tdy76x87OpgsdnYAM3kUXXT0NizXwiBbHsG06p4Ca6xnqHOA1RtkAPCft6azY8zzThCmrjQlC/C0Km+DO7XcuTMUqcli67LrFtKECh7G96B2EgpdXjcs/d3BIpIjqrsi9alNZAk/K/VK+sdam5x+xLSy0SMhMLIWmqNVsg1VA6Cfhz4RrgRhcT7zUAl8RvxxcUdrpTAmzQu/JYw6agssvTsM5a/njrplXZiKWT5Oj53s4KvgKm6Zqrq88t3bQ0No4SNBYE8oFOHWNoTWytQSeJM+cWCooRzVhzC51XRs6tbDfOKScUYNRQFoFZKYwU41AgV/1w9M+g0+YmRTsgWwAZEBu/mi2bq9U4yxVXXvQQDIDt7iSS1hlWsNFWTGsKpPV+JJr0yaSEsltL5K8a/KDKPoUjTSBQJ6jyRTbZDD6gwmeMO3pG4vOBBXGNqz6PMxI9b+HXI
 0jCEUl5W
 tvK7N+e1gcFB6rBzu/X1n6hl1nAVk9zRfrDpz1GNh7KV50PY22OcQRGb+gU3OLY43ryayoUjqoysReSQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Mon Dec 15, 2025 at 9:34 AM UTC, Yeoreum Yun wrote:
> > Hi Brendan,
> >> On Sun Dec 14, 2025 at 9:13 AM UTC, Yeoreum Yun wrote:
> >> >> I don't have the context on what this code is doing so take this with
> >> >> a grain of salt, but...
> >> >>
> >> >> The point of the _nolock alloc is to give the allocator an excuse to
> >> >> fail. Panicking on that failure doesn't seem like a great idea to me?
> >> >
> >> > I thought first whether it changes to "static" memory area to handle
> >> > this in PREEMPT_RT.
> >> > But since this function is called while smp_cpus_done().
> >> > So, I think it's fine since there wouldn't be a contention for
> >> > memory allocation in this phase.
> >>
> >> Then shouldn't it use _nolock unconditionally?
> >
> > As you pointed out, I think it should be fine even in the !PREEMPT_RT case.
> > However, in case I missed something or if my understanding is incorrect,
> > I applied it only to the PREEMPT_RT case for now.
>
> Hmm, I don't think "this code might be broken so let's cage it behind a
> conditional" is a good strategy.
>
> 1. It bloats the codebase.
>
> 2. It's confusing to readers, now you have to try an understand why this
>    conditional is here, which is a doomed effort. This could be
>    mitigated with comments but, see point 1.
>
> 3. It expands the testing matrix. So now we have code that we aren't
>    really sure is correct, AND it gets less test coverage.
>
> Overall I am feeling a bit uncomfortable about this use of _nolock, but
> I am also feeling pretty ignorant about PREEMPT_RT and also about this
> arm64 code, so I am hesitant to suggest alternatives, I hope someone
> else can offer some input here...

I understand. However, as I mentioned earlier,
my main intention was to hear opinions specifically about memory contention.

That said, if there is no memory contention,
I don’t think using the _nolock API is necessarily a bad approach.
In fact, I believe a bigger issue is that, under PREEMPT_RT,
code that uses the regular memory allocation APIs may give users the false impression
that those APIs are “safe to use,” even though they are not.

--
Sincerely,
Yeoreum Yun

