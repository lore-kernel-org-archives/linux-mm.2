Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23D55EC1127
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 19:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8429F6B0005; Mon, 23 Feb 2026 14:41:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816916B0089; Mon, 23 Feb 2026 14:41:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C4CC6B008A; Mon, 23 Feb 2026 14:41:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 595916B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:41:10 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 172EE1A02D4
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:41:10 +0000 (UTC)
X-FDA: 84476739900.13.47674EB
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022135.outbound.protection.outlook.com [40.107.193.135])
	by imf03.hostedemail.com (Postfix) with ESMTP id 88C612000C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:41:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=DvhcWny+;
	spf=pass (imf03.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.135 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771875666; a=rsa-sha256;
	cv=pass;
	b=kAP9dCVSTbugTObyZIwqVJUN08oO+ngFYZLurmAuJ70hKBi3Ov4QfxR3oaWrPtcxoxPwnM
	zjDAnNnCHIWJ2R9jCZvBQvK/uS4YYRkowdAAZqOxG8bWSE5AziQHfze19xJGIa/H/AcEIX
	viH3vRyF+pbnSp2VkA+oredJHxcXAOs=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=DvhcWny+;
	spf=pass (imf03.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.135 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771875666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oz+act2cg97xQHdoFBHvSMUlBGG/nF/WW9S/pfiNNqE=;
	b=rDzl/YtaauwL5ND17NhUTIFMvXpdrQEX8qKoqRfC7ISYjLRQpf/21iqiH50rUHHyx/u9iI
	Avf4Bs42BL6k+/HsYnIwgBmcffLgctYxcuKtQ1ECUbWfmFcujOzvEWDnI73nhFaSwONDJE
	F8kMljnJxnRgIn6Yj73aqOz6T5786Pg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z71FIw6oAt9IcEmSKLLWOs5xssogYkXQJ6zBMbnS2IeBA+eA/52cFapkESb0bdfDVjVc0ULCbkg7hl9vQj+9ZQumoEZ++8i1Ce+HuicR5qLCEN+XWlmNY/JrRvnskYeBwxzGNWwPa/7LBk9XwQ1k68QHMsYoU0h71q3mLWlkBxNWl/4OgaKbSH94kEgWolt6Lz+AglkLqsTEFi3rwxiliruJ2SBkGUjvGFxvqZjUJ19pYvE0EwO+ve+0jhpqa2hYsI1360suMArv0XICSU3VxTKFpd7nOYv6vzmCGGnNh5CkbgdUroMRU7rcqdyxvyPQeUMULpicWs1NkZGGpWjkfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oz+act2cg97xQHdoFBHvSMUlBGG/nF/WW9S/pfiNNqE=;
 b=Zvk/Z7r2JTa4dk+NUWJFVtia45vPPYVw5SPRYbY6Vq8oPiFo/dOUoVaglJVXUN5ef2B6JYBt9asvHCxJBvdMOISwtQN8Ev+YaguXF15tKdd/TSdCkvyf/8fyLrr0HZKdYg513SInJC6piuC/wjTM04gdLPum3EIpmTJHrPYe0XBLETbG+aKaywoWCiHICiiASC1hTCIlTqb0MsOui9c7zKR3tbo0MP/K9/L+pRFpVHupgxACW7UQ4m87UU+eatKzWNCfyXQR3K9CMjbK0A+BZSi7KaTXEANRY37NRX9aq1Lj40cnopf9jI5Y51kOte7QSXOkbRY9wjYox5fPlHLEPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oz+act2cg97xQHdoFBHvSMUlBGG/nF/WW9S/pfiNNqE=;
 b=DvhcWny+d2TB1oS4xwFEPAGSc3PreEeNBrjZ0NLEuN/z4jNdw4LSAI+pr5QozCh1wvke6Y/XDIcrpmW2oELIR4Gh9CD+VKaPg3qi8c/DfRPXyT0+evGM0jmpRH0YJn/+RkUvYaXfzTOAvEslXUnIcz503TPqZwYn+cNQZHarMq+ZUMGHnivPA68Y1MCVgQ3esQaUuaJO26ZNtNMcgNlXRv4yP9o1xgkgpXUvJYUNcnci6MW28MSnli5DrDiDxQ3iG8yx6DfOORBhWP4O9vDhxa2m0iqRI0d7FRjTQRkl48YEFCahbJOUTVIkpCn9mlhhm7cvGXCbzPccm8WEt33b9Q==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT3PR01MB8964.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:a0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.20; Mon, 23 Feb
 2026 19:41:03 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%3]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 19:41:02 +0000
Message-ID: <ea95a6ac-65a5-4d19-b670-d19b4e0ff7d2@efficios.com>
Date: Mon, 23 Feb 2026 14:40:59 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 4/4] hazptr: Migrate per-CPU slots to backup slot
 on context switch
To: Boqun Feng <boqun@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Joel Fernandes
 <joel@joelfernandes.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Alan Stern <stern@rowland.harvard.edu>, John Stultz <jstultz@google.com>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Waiman Long <longman@redhat.com>,
 Mark Rutland <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, maged.michael@gmail.com,
 Mateusz Guzik <mjguzik@gmail.com>,
 Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>, rcu@vger.kernel.org,
 linux-mm@kvack.org, lkmm@lists.linux.dev
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
 <20251218014531.3793471-5-mathieu.desnoyers@efficios.com>
 <aUR9RfVChdcDncwX@tardis-2.local>
 <bd86f598-97f9-4fc7-b426-01f08974b945@efficios.com>
 <aZyGMp7JbXPfp8Kd@tardis.local>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <aZyGMp7JbXPfp8Kd@tardis.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0350.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::24) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT3PR01MB8964:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ed06307-6936-47b1-6e05-08de73137a2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L0g1NWZFcXdCS202V1VORSs3UG9Pc2NjSDdKUEdtQUlXZDRHdlc3RkJZSVhT?=
 =?utf-8?B?c2dVaDNYMmVWNUdrWkhnMURWSUVzb3FWRnFJVTFQZE1WQ0UzMFlJZlo3cDJk?=
 =?utf-8?B?SEJFaWJsOW5QeHNOODZzamExTkZIemc2ZXNZOCtvemdlVkZMN0hZVGVWeGFq?=
 =?utf-8?B?czlHZFVaUHg1OXI4c3kvYU4ycXBhbHVQL1M4Z0MzRVlva3AzRGpwcVVnUDlP?=
 =?utf-8?B?TXp5VGlkYldsWkQwSVd0ZEtQYzBPMXFsd2lqRlNaMEZWZ3lhS1BQanV4ZXph?=
 =?utf-8?B?dGRlN1k3VmVIanp2Ung0dGRrL0hHeUpXeGI0S2NQTEhaUXZhdm1aM2lYRlNX?=
 =?utf-8?B?ZGorWDlFUTZSWCtseG0vZlVDT1ZMUnhFYlNNRFUxcEVKRlBHYUtVN29abzZl?=
 =?utf-8?B?b0cxNlZXdTM5N3FFbkpoTmdlbW12SXJTYVdTOGVIaVdvV3Uvc0xqeUJtdUQv?=
 =?utf-8?B?bU9aWjZuVE1ISnZPNkp5VmNtcldTYzNsNmQzRWViWXVsNFVDQkx2RHhWKzBq?=
 =?utf-8?B?QTBKRXVDeUp3dC9QNnJqd0ZmTG84NGVVN25nMDlaT2hUUnlkQnA4VnB0dSs2?=
 =?utf-8?B?WkFkSWpKVzNrakRmWDRwclFWYVNEdGk1YTJNSFIvajZ4ZmhPQjUydjhjVUJv?=
 =?utf-8?B?NWJ6cittclRWV0xFNmtqVGd3Z0tRYlB0K2h6b2VKZFFuV2p2M0JGamE0Z0Vl?=
 =?utf-8?B?SEM0R2hhekczcCt1Qys4Skcvb2d2dGtWbk1FNk5ITE1NQmtveG52N3ZNckJ3?=
 =?utf-8?B?d0x5OTg4SVJ4aDJUTjNoM3NFMkUwZVFUazdZWHR0TDB6K1Q5QldaajVsTkhh?=
 =?utf-8?B?U2t2QjhHTnpiK1pTbkgrR3FxTmdiMmVCekZ2WE9neHJTODk0SGFaR2FlWExm?=
 =?utf-8?B?bCtsMjMrRjR4TUo3S3hZMzQvUVNDMXluUHRJNkpzR01wSjVKRjd5czRPYk8y?=
 =?utf-8?B?azl1QklUVmtaV1hVcVRaWWUyT09lR1A5UEY4a05RR0QxU1hCLzVhekhibHlO?=
 =?utf-8?B?S2xCTm95QnhsMnRuUnN4MVdUcmh6K1c2WjhqSXlnMFpyOWpJNXhUSzNpUE8x?=
 =?utf-8?B?QVdpeEgzN0xyRVRnbVVZempaZEtFWWNialMyL1cwcVQwMi9WZWo0UXh4UUJB?=
 =?utf-8?B?bkRyMFdXODBvNjgvMWpWbFdTNjd6SE1rSmN4V2lwWFBaMjZmOUtLUklwdFZ4?=
 =?utf-8?B?ais0NForUDRFR0hZQnlIMmNISnJuTEZmYmpTZzljRGx2blQxRk5IL1B5N3c2?=
 =?utf-8?B?elJ4OGJ4MUhJSmZPV2V0UjcwTGhZQS9GNkJWZHBaRjBjV2x2YmR4Y2hpMElm?=
 =?utf-8?B?UldZUERmZ3ZJVDZvZDJJOTdBZnFNMXFXc2duUGwzaUg2K0NueXh3ei9ObEts?=
 =?utf-8?B?Tjl6WjJmdm0xQ2Q5YS9RbFBzLzNUTmpMdzB2cE9FMVhqWEYwdFBzSUhLRngv?=
 =?utf-8?B?bWUxV2J1SGlTU0laSm0yb1pFenFDRmpjR201QllYQjBUazNSRXh2bWt0cjhK?=
 =?utf-8?B?N2E0TGpvaG93TlRDUEdBNENEd3RiT2UxMWpObjV3NG1vRFNxTDRWRGovK0ND?=
 =?utf-8?B?R0RFcGQwazdNZ1F4MkpCa2VrMlo1T1lYNmEvZjMvdVU3ZHNES2M5UFVvd1BO?=
 =?utf-8?B?b3dJZnRlbEgxcm1EeWlOY2J2bXpEaHp5VmlVdnNJOG52VENZTVJsSWVOeXd1?=
 =?utf-8?B?UVIxWlVIMmttYTU0WDBpZWNzTWNqODBWd0lXVG9sTGRsbEJia09mWE9YSWlm?=
 =?utf-8?B?MllTc0x4dU0wd0VZcU41RnlzUDZPdkdFZ1FJcEgxZ01NYWE2SE04TmJabExI?=
 =?utf-8?B?UTMvMGlSaDFiZ0xFY2J6b3A1MnZMSkN1TnRJYk42TXZwbGhxVFA4VkQyOC9C?=
 =?utf-8?B?TGtYZWJNM1VOYXlJenhwRVBEMk1GTTJLcTJsRzgxNTltb1JzcWN1a0VxNFJR?=
 =?utf-8?B?MEl4NlNwazNzeFZoQ0xpb29MWTRwR2s5dS9GY0dsNGgvTTZVcHdjVDl1YUM1?=
 =?utf-8?Q?GPfpaCbGLCkCycI/EAO3WvHsWDQZRo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(13003099007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?allaSUhUTDlnVUZsejVlYkZZR05pR1I4ZThPVmpCVEtUUVo0RTBscEppNFha?=
 =?utf-8?B?MU5kRFNXSXcxaCtSMkJ4SkhHT0QxOG5NSVNNdDdKN0MyQzQza1BpdnhiaS9q?=
 =?utf-8?B?M2tCcm5aU1poMXVKL0o4bHVuQ2grNEJKNjEwWXo2QTFYQTZYQW9zRzhobnJD?=
 =?utf-8?B?ZHlOZzRFNUdrRGRnQUZVcElOWWhGQkRtWkN1bzBtNzAycWhrNkNoM1YwRFIv?=
 =?utf-8?B?NEUrRURNNGlYV3VMU1N4RG1tU3FUTWc3V3dpcjNMT0oybEdhRFk0MXZ4S2RG?=
 =?utf-8?B?blUvdkR3b2gzVnZrc3ZoUEFxVDVSeVRWMkwzTDhaTVNvekpjMlhKaUpqWlgv?=
 =?utf-8?B?TWludGJZaW53MnFNRGZVbVNoRWZXZ3g5c2hHbHlId0ZON2hDT2ZIM2NEQ3hV?=
 =?utf-8?B?Qjl4NzErSHVXeUdIZjJwR0dSMStCamREZUhiOHQrRi8vSFNjciswV1g3UjFL?=
 =?utf-8?B?L2dVdzBjZjdKOUFVQVJEbzRwL3Fodng1UkZTanBqU05EKzlXaHprQW5lWnkw?=
 =?utf-8?B?Ulc2eDBKWUo3Njl0N1RUcUVEek1mc3hZNk91cVBNWlQrUzNOWDdyQUpVL1hk?=
 =?utf-8?B?UWJHbzV2OHRQUmRjb3NpVzVuZWJjeXk5OVNvUTI4S201eGMxdm1jV2RlVWF6?=
 =?utf-8?B?L1YwNGl6NGFicHprN2dJMnYveEJPeitaY0tWbGFlZGdtT1RqcGdRVy8zNTBI?=
 =?utf-8?B?QmpzVWVMWFJFQUhsQlFQOTFHMlg0dzhRU0N5N0JrZEJRWGtpc0twWFVPQWlF?=
 =?utf-8?B?S1FNNFdOK0owZ05iNC9rajRHNWY5azlsazB2bHJ2OThGekU0YlZuODJPUTdY?=
 =?utf-8?B?U3VtaUJ5ZVNyajN5Z1Q4R0d4ZVkxZEUxNS9kN0tQZ2tWYm1qNllEWWIrSTdz?=
 =?utf-8?B?WGhzN1IvKzRzNTRkU1dtVVBCM3FnKzRUUGhMTmp3ZkhBN1IxMzdXUnB1UFc1?=
 =?utf-8?B?K0JWQ1FjdUxIUFpHaHJVU3VXRUczWTZvSUZMMkg0dWJBZFB4VldkTjN4eWRC?=
 =?utf-8?B?UldRY0MyS0ZZZ3pmRjdqd05QQXR2TEFnaU4wUitBY1FUZjZNUjhsM0hJZmtx?=
 =?utf-8?B?SlhEdmxOTUlLTFN3dHNiLzRCZWpwRFV6dW5zNXd2SUc2Y0FjMXA1SzAyVW5j?=
 =?utf-8?B?czJ5WEo0S1F2N081dXdlNVA2U05FU1ByaHg2SzE1T1NYYmRHSlBEaVU0NHZp?=
 =?utf-8?B?MWVYbEVVQ0txZTRicUV4eDNtcG5NU1ltNG9FOCttYXJvVE8xYkVzazU4UUZ5?=
 =?utf-8?B?UVM4SStDY3F1TElHRHJodGgrT2k2dkhvdUVMQ2VQVk5xVVVobjVmaktEblFG?=
 =?utf-8?B?b05oZzR2ZkJzbHpiSEMrMHpVUWNXd0pMQm8zMHRYWXNWSlgrS2Fudy9GajFu?=
 =?utf-8?B?MHQ5R1Zmd0Jvb1ovZ3FSbVN4c3RNeTlRTGJnWEo1VTNNTjlLa21qR3VUaUw1?=
 =?utf-8?B?dUZiRUdwcGg0TldMYUN2M1BKajhFZFF1UFhYTDJWRHg4Skx2anpoTzJaUXpu?=
 =?utf-8?B?Y0hlQzdFZEJTYXJkL2ZMYVdibWtaWHNCQUpydFZ3Wk1nOEZoeGNsdEo2OHZZ?=
 =?utf-8?B?UnlTTWM4Umt4SUluTG9neksyTkVKVTFWcEhzQlluQk9mT3prL0JrVExvZDk1?=
 =?utf-8?B?cW53VVpBOGtRNWUvbkN0d3pZV3dzK2dVUWxsVTV4YmhqZzZDaGMrZmVDeUdl?=
 =?utf-8?B?UEhUNWY4TGJIbjFOQ2REMHBJNHU3US9PajVER1BEUm83M0N2QkNQUnA5L0N1?=
 =?utf-8?B?RzhUMUZidk5lN2FNZzQrZlpBK05QMWpUc3dnaGtXQndiN21NKzRJWmZoRnRT?=
 =?utf-8?B?djRkS1ZMOE82eGlmdlVnbGRFODZYS0FTZWRjR2tJK3NTRzk3R09nUWJmNm5O?=
 =?utf-8?B?Z0hmQjhVMEw1Skg1aS9CdVRvMkNlQWFla2h5NXJTUzNkb25zbTFkKy9Ga2M4?=
 =?utf-8?B?S243bUp6YjRHY1A4QnBuK3Z1MTh0SUhnME1ULzdjeFlwVXN3dCtGQ2I1QjhL?=
 =?utf-8?B?cXFjRWJEWVBFLy9rTWNqMEU2MW03d0puUTNZQVhWU2pOa3pWODNzTGVMQzE5?=
 =?utf-8?B?emFRS2N4bDNMUkxWVkx6S2pNVFNNQmQyRU5VVGdvMUpjekYwa1JGZk5EcTBw?=
 =?utf-8?B?ZkVreHE0cElOVEczZGI0NzBaSzkvbDZ0VEJXS1hweGFIUnlQQkkzL2N0TElk?=
 =?utf-8?B?a0RYcUVvNy9LeUd0dEVOVjVKb1hxYVgzWXQ3NlVGd3ltODVxRzRWYkxNQk1N?=
 =?utf-8?B?eW1zVWlJZHlDRXVvQVBZd3daNTFhRllEVEk1MGNhbjU2SCtpaDBtak5iK1RP?=
 =?utf-8?B?WldGNjIvTXhVMmUxU1JQSkljOVJkK3pSeUhDdVMvcnRVN2pubHRlQXhCeXUv?=
 =?utf-8?Q?aIya/tT4Los03q+I=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ed06307-6936-47b1-6e05-08de73137a2e
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 19:41:02.6413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fsffcqkdo/rlWy4m5wWpEmJBShC6JUO/6bbH38kJEuvvnmFftKElol3a5LWEByJkUaQl4KYKt2UwVKqm+jGDVw0i6CyliJkHCMmaNbaXVi8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB8964
X-Rspamd-Queue-Id: 88C612000C
X-Stat-Signature: 975o6iw9wxakmmqamhcuozpjjw415qqo
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771875666-398408
X-HE-Meta: U2FsdGVkX1+UqJ65ap8zepNIWh+xs9wwlgHn5soLkJ4inf2iPmzZg4MEigivB7MwDPuCBICdNMzJGQej88PlG9qnxB9IIaiwCVKF3Po0TY1uidYPK/eqxLLpwfJMpANHUQ15x45kjYK6FwZMDfilXFq3DlSNU5lcFbTbiF6bUCRWXv47JiMaBfkDIsc1WUqQ7Mk+EVSGS+Fnv8iFYx4sJTL7SfRedYlnGpY5b46w5t+25tV1XB1TcgXjv3TFhT4uVVLKmB86kjSKz5xs+WvcyVVX24kuI+ZepHqv6n1nJ6f1boEv49slmXygyFqXjgHy27WZarSxtqxHHAIYw/7F7wH1CzYFke20jhVL/tticYdsUpgGtinpHg0R4RzrxUq/cWL94wPp2KcDayqw3PsOAkeH5UPVR4EvR4ABMCcuPepRRg+X2jxxrfV4y0h/tc6yMw0DhOXiDpi26+0KB5xy4R8N/xF3823YkmXsXS+8eLzNLUtff+ovm8jl8sFQiMjV0n4b3Zvfk1VX4D7UaApKn19uMy30SaQTn+8XbOEUed8Fh1/MhoBSPtD/cjHH8vFlSSrBQv6aEM6e8XEll3vFhDsDjhenwyiRRIEVawhZpqEVnpQz6U8qMS/0MFYRVXUc8u47z/UoL7pARaRxkUtWB6XA3d2+Cltk9XCmbt7kbuq9KDTLbJRHdg1Eh/L3YjoDrA7RjWYCjSARejLYXTD4N2TW/18H2BDP/ZiJe4am18ezrNSmKGzXtqtsU/MHtiyeqQGNT41iLBPDyMb2A69lBpAn57FOAgKRLnwZ5pET2WDquNxWeFxfMGzy0YyBjqimREXCtHJQ0gLpIk6GgZI9z5uodxSY//gRdi0XV67imNxtFyoduIFmM9A2jznVCieage0y5vfNnls4TzIDAJEHvgPV/OopZES70qH4p4gBcQFbbp6MBi3HoK64+Y5vtjTaxAKtbCj8sOxjIXrvbCh
 1NRKLlVo
 C5rqjY8Km/4GksRtIaoAaJBZlGtk/PTt7nUqqUU0Kj0jGotSR3cEhePmgNmtO+2TnEIHlZXPXF5w5WGfHmf6odw56umJiG1GWXa8qEDfJQLtqeIH1hSelZnpJ88a9yEO9KMCyW83N8ySAUuZ84jHPcHYu0xCPpumkNgYmGl52BM/STi6WsHRadtgSR33f+ts+hCMzAhBkxvF2dcni62JTmY4a+wFTmyXcv+zwZppxUJAGQ3gw7yBDVyuA/WaNYq005o0nA2V7VgeaLWZmATj+v1+F5ATYRf8V9IN2yilV+gBphFkxkF7jhDqk2CDNURB3BVcwhmX6zEBXr4OwBfYk7px8RSeu1rr2JKMI4IOh5KwQB5Ssc30pssoC/s6bCoz+r9z0NC95zy7S0o9SKHj7YQ+46j4kXwPpqaT+DYG0f90aOPccR3ZqJO8yJ3hVFIwaNqwa1TFw05xXiaj4+XnEBneT+d7bNgpM6MlGtyHbkAOdwLljCBcbyTfmYBuG3/EHpjkqL9ztNxaDb/3UDYE4u8OA0v4w2KYfZgBJDU1oZNwL6GVVYL9OpSQ9NhHkVUm0y04+zSNq4oRQRqq2QLJLc7KRIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-23 11:54, Boqun Feng wrote:
> Hi Mathieu,
> 
> On Thu, Dec 18, 2025 at 07:21:28PM -0500, Mathieu Desnoyers wrote:
>> On 2025-12-18 17:16, Boqun Feng wrote:
>> [...]
>>>
>>> I would suggest we make CONFIG_PREEMPT_HAZPTR always enabled hence no
>>> need for a config, do we have the measurement of the additional cost?
>>
>> Removing the PREEMPT_HAZPTR brings read-side performance
>> from 13.1 down to 5.1 ns. So there is a surprising amount
>> of work that goes into list_add/list_del.
>>
>> I just noticed that I was running a kernel with CONFIG_LIST_HARDENED=y.
>> Reruning refscale for PREEMPT_HAZPTR=y with list hardening disabled
>> goes from 13.1 ns to 12.4ns, so not a huge win.
>>
>> I did not notice much difference in terms of scheduler
>> performance with a quick hackbench run, but I cannot
>> claim it is an extensive benchmark in any way.
>>
>>>
>>> I think you need to add interrupt disabling for chain/unchain because of
>>> the potential readers in interrupt and then you can avoid the preempt
>>> disabling in hazptr_release() I think. Let's aim for supporting readers
>>> in interrupt handler, because at least lockdep needs that.
>>
>> OK, I'll look into it!
>>
> 
> Gentle ping on this. I want to make some forward progress on this ;-)

Thanks for the ping, I was focused on other things. I do have an updated
branch to post.

> 
> I suggest we make PREEMPT_HAZPTR enabled by default and support readers
> in interrupt handler.

Yes, that's what I have in my updated branch.

> The rest missing part is an async thread, we could
> utilize some code in my previous patchset [1]. Let me know whether you
> think you have the cycle for this, otherwise I could add this into your
> series ;-) Thanks!

If that's OK with you, I could post my updated hazptr series for
feedback, and leave the async thread adaptation to you.

Thanks,

Mathieu

> 
> [1]: https://lore.kernel.org/lkml/20250414060055.341516-1-boqun.feng@gmail.com/
> 
> Regards,
> Boqun
> 
>> Thanks,
>>
>> Mathieu
>>
>> -- 
>> Mathieu Desnoyers
>> EfficiOS Inc.
>> https://www.efficios.com


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

