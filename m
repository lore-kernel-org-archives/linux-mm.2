Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9FF1D711C8
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 00:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 141696B0088; Thu, 18 Dec 2025 19:21:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7A16B0089; Thu, 18 Dec 2025 19:21:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE7966B008A; Thu, 18 Dec 2025 19:21:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE9056B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:21:37 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8652A1A03A7
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:21:37 +0000 (UTC)
X-FDA: 84234317034.23.1DBB899
Received: from YQZPR01CU011.outbound.protection.outlook.com (mail-canadaeastazon11020138.outbound.protection.outlook.com [52.101.191.138])
	by imf07.hostedemail.com (Postfix) with ESMTP id A13AF4000F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:21:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=gYzoBwbT;
	spf=pass (imf07.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.191.138 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766103694; a=rsa-sha256;
	cv=pass;
	b=NaEmLlG+KJBi9ZcLmY0fBFrRIEcLPiYsTkH17n/1eNcDx8vmezVb6DMFwIWROwr3DbSSac
	cNqk7nr+Fi2ooZx7QUgzEvapXgbPl75K2hNI5zta+GwDWVdPYwKGM2oCQ7w3dYxnv+G+1B
	CwQQ2eiwRS99DgAP8K2PqC85/2u3shM=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=gYzoBwbT;
	spf=pass (imf07.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.191.138 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766103694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vMz2EVc6778iSvULdUOCIhUdIOfpggHwImU2imhM6OI=;
	b=KWWs4X4v6GhvbFO2lZGTVCj4DqiZilGWxfq/wk9kz1Fim4q3fS/90bnb74WjxFRjD+pQHh
	O4a8xazmfYLC4j4nvlJjh/f05IiKQ5Dhbzoz2ac+EmeBIPWGP6uuHYbgsqcnvPQ07i42QW
	LTBO9sSrK+hRdIEeHUxNpBj0AqUhou8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZjUGoRUcqJ9GPEDAgaeJ8vurWlGJvM8gbspJh9xTu+9Nr6Bgg+jv8xZ5Nrqv52MdAZrBtt6DmtE1v1OedyjKXqSKdoV1qqaQELwG+YSXyoylA7bqvI/hK9LyZeMQZfHxwpA82SLf0l5u4zkVwwbU1+5/DEtCaTQn0H2sDFRCSUzv12GYtaxvqIr/s4dhn+fkRxa61taVoBnzKUBUgj8Jjj5ag/72KrI8J0L4pTVXufagTsuXyRouErlv3aDxN3vP146HjLMEqKMAno5Ngiq5q7TiA/bdPK2Hf28Pusyg4KQPoIqXf3DmS3GgS/sUcFJjOEmFrkuCyZJ8Y2102ja1Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vMz2EVc6778iSvULdUOCIhUdIOfpggHwImU2imhM6OI=;
 b=xE7IT6GcxAdwi7ueZ3LEVGQOY5WfElAomz4Y3o3vPSrER2Cey5DrGMGAulelFedZy36qi4UeZgMk/E7K67Za80KaldzSF4ppUPNsImUTdcIHp8QIpZtTK+BflsrJaIwib7jE8dS8FUDwCUdTdh3y1Fi85s+d+5QzHy8HJrhLKZbDS3h5LdhfPdQ1EQPf6NK6+4ui29E+9vfag6iffusNHwpUvdelKJlfLGpt+/QNfP8olI0EMEhn8tFNMcBsl1UzoBd8mCxkU9Rup12G1f0e3Y4w7J/IMTFY0gJ69LKQzUTkCPYZJ9JZkeZSU5tQbyYGEV33lOHv0vLOKobooqNiaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMz2EVc6778iSvULdUOCIhUdIOfpggHwImU2imhM6OI=;
 b=gYzoBwbTrh1ovJ9NKjE0Ifg+IDD+vGHXq6vvKxPK/pHSUC/7GMPsxJMMaNF10+qtwDZW/NDmqLiQUrjmD4nWZYgcdUjxq+EgmbzOSfbHp4sVZmJh2j4amA9KME05+0/lWhyX0E5+PyS4geDuANtPD3OP23OYf58rVjb5U1a/whRFnuLhsNgCcsKqMKy/xyNgyhsryUORmQ+n1S76VWcURwBipa3tA5V1kz+x0fRvmJtf8uruxui5QFy6sT78z2VASwqs829gen0WnLz6xga+grHUnJxFrQHsYHaziGq/30OpggWTT5Y9vQsJBKOAMJvMouKxeyw8wfz++z4/jJM8dg==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT2PR01MB10504.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:75::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 00:21:31 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 00:21:31 +0000
Message-ID: <bd86f598-97f9-4fc7-b426-01f08974b945@efficios.com>
Date: Thu, 18 Dec 2025 19:21:28 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 4/4] hazptr: Migrate per-CPU slots to backup slot
 on context switch
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>,
 "Paul E. McKenney" <paulmck@kernel.org>, linux-kernel@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
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
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <aUR9RfVChdcDncwX@tardis-2.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0279.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::10) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT2PR01MB10504:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bb88b4d-4e50-4616-40af-08de3e948f05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NUxMZGNEaGVEZjFBVU51TW4zMWJyNnlEajVkMjJUeS8wWlljTzBNOXRJR093?=
 =?utf-8?B?RkxYbFNCR3gvdlNWZTdPSWxkdGRIbHpRTHpEWDBqMEY3YkVodloxOFl4akZt?=
 =?utf-8?B?WCtlV3JZcUVOSUt5VUtGUWF4bE43cFN6amhiN3F3OFl6OGNnZVdDc1JLSTVO?=
 =?utf-8?B?UCtjbUtRbWFQMktleUFnNVZEdy93MEJSOHA3aGpRc3IwQ1hpVzRTc21DSlVX?=
 =?utf-8?B?YUh5UVNnMUFQRnYrRG9JNTlyWmsrWkJqckpvVkJCeld1ZktVOUoxdy8yNWk5?=
 =?utf-8?B?VWJ2Ni8wMGI1UFd5TXpLL0VOd0t5ZnlUMytUdWdEZnhTeUN4ZGQwdGE2Vndw?=
 =?utf-8?B?TjBXUDRmZkpqL3M5VVFEbFZJVmVTc0xJRTQvcWtxdFFGcGtBZjd3UDBFMU9I?=
 =?utf-8?B?aGgxaWdZUlNqYjhITkhyTDdtWjdaYTFPb1hZa0owNTc5NTZqdEpKUjhPakxP?=
 =?utf-8?B?cDlRblNBb1cvQjdSc2poRHVrMWhNMncxWkJVRVFQaWtnaHNWazl3UGdiNys4?=
 =?utf-8?B?Nk15WTJnUzBNQko4VzFsWExYNDBXRkF0emdzL1NOKzM2OXM0SzZJNzBoeHhI?=
 =?utf-8?B?QnNxZmJ6dUdZTGpNK09Zd0ZNNTZOejVKZEhqNXJ5RmZnTjBsQTMrYWdldVJW?=
 =?utf-8?B?TXlSeTV0cU8vS3puUUtucEFPN3paOXN2dU5icDluWjJQdTZ0ejhSV3l3RmQz?=
 =?utf-8?B?YXh4eThzTzlWME9nbks2WVp3KzBJc29OTDg1OFVJYlgyTE1TVVB4UDZlcWd3?=
 =?utf-8?B?dDRBb0xpWXp3Z3hiT2tiQjRBYUEzcEN3TkF0cnZYU1JsYnFvWWxWakpycHlv?=
 =?utf-8?B?Q0VFUnhZT3BUZnBaNUZlVkpYSFhzRW5sN29RUEpCM2ZiK3dzRmJWdXBDMVpL?=
 =?utf-8?B?dnN4QjFxblBXWHRDWEhwTjBBVmVRMy9WUW1kaGlSVm8xTE40eFJPb3NmNWVR?=
 =?utf-8?B?dVIzeUtnTTZOTVEwTlVNTndVY0hpTUg5Qk43L0h4UEtsSU1BSXQ2Wisvc2h5?=
 =?utf-8?B?YnIvcnBjVTJQODJXTXMwM29NQ1JIYm5Uc0ZwSzdGdno0L3E0K3ZXK2IwbTFL?=
 =?utf-8?B?eHdac0lLdS9tWUF5dlBQbmdpOGxEYnJkNCtYR2tzT2VHcXpiSTV1bEdXOHlt?=
 =?utf-8?B?bTdiRlJJSUtmdXpzWVlOV0srQjN0dHYxV05kTGVHbzh4RHpqZ2dNUmpOdFFN?=
 =?utf-8?B?SmkrYkcvdUtYSngyMzlISEowUFZsS0tQaVRxS3hNNjY2QytLTnhsWEs2QU56?=
 =?utf-8?B?TW9ackNFdWkxNS9BeEdCcVhkbjRHTUkrK0lDMjBrVlJRdjZ6WktUbDVzRXli?=
 =?utf-8?B?dmNRZU9YRVNVSmtrd0NnWXFmdnVzQW9DNjJGOG1qTTUybzg5akw2RWN1Z2VV?=
 =?utf-8?B?LzJJOWZxRnBUOFhDTVFVZ0c4aWFZQWlidzlwY1ZwcXVGdmxaK1BZSmpaUXB4?=
 =?utf-8?B?eG5DUTBRanoyS3lIOEJ0N0NXVmdPOXFwSmpmUTB0MXlpdXIzOHh6U2NKZzd5?=
 =?utf-8?B?Q25SQXNuS1NGSlVzSHMxOFlQMW9VRzBvWTk0TzR5ZUVhRGZNUGEvY29GYU5N?=
 =?utf-8?B?aENNMWI1ZmxpMjYrcXNTOU95amRTVGhwSldUdnlKdmFMSUNXejdWRFVUc3NK?=
 =?utf-8?B?Y3l2czBTSkI5Vkx4MXNlYjczQnZRYkhSVjJUT0dybXNRZ3RRL3RadlcxcDVZ?=
 =?utf-8?B?b1NwYjE4REl0aDQvTlI5UzhyZXV6RHdZRmU4b1pnc3dSY2pqWlZLQi9yT2J2?=
 =?utf-8?B?eTJPR1hVZWZLSVgxR2FvclNlVXhsZ0xCQW9PcHN1RmtnUGMzOGhhTkExcXVj?=
 =?utf-8?B?M2VYL0h6Q0V5a05jQTFHaTU4Mm1BQVZQeDJsWjRxdTQ1Tnc0VzFLY2tDNURC?=
 =?utf-8?B?cFdZN2l5TE1ZRE9uNmtuZjArQ1dNK3pkSVhiVHhxeURMaHc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0FWdTFWRERheDRUcDJJTXRHN2kwcG5rNkNsZkdEdlBWYUthTk50azA1dFl2?=
 =?utf-8?B?WCtRV2duNmVQOE1pbzh0UmZqajY1YjhCeElYUUI1b3R0alNXSzMyQVBTT0lt?=
 =?utf-8?B?U2tYVUk4alkzSHpMelhoc2U4eGQ5b1hpVFVuaTkrckcxZFdmRnhlM2JiU2p4?=
 =?utf-8?B?Z21QdEdKMTdSNWY4a1hUVVl0NERPdE85c1BUSTN0dTYzRWw1RXhxQ2JTNTNR?=
 =?utf-8?B?TXlUMkgySGUyNTMwcGZEOFUrWUx3bTFPd0VQRjZpa3hBa3lDMHN3NmlYQVZv?=
 =?utf-8?B?ZUM1d3lJczFFQUlhWEVzNEdRNmYwa0FLQ0FyS21VYWpvTG1xNXNER2M4em9Z?=
 =?utf-8?B?TkxJSmlqdGR0djJJUTdHQWtCTm1zbU5oNVVrVFM3TmpUUzFDVzJpOW85bXJv?=
 =?utf-8?B?Uk5TVEhadWRROHJqUEoyUk1tcXZiVlBxdElPRHVMTE1HcVBZV3JiLy9EZFR2?=
 =?utf-8?B?eG0zUnlzam1IcUhnYlpNVk1BSFNpWTc3SkdXdG5VZTNwR3VOM3hRbVQvMWlQ?=
 =?utf-8?B?Ukg5S0hDYi85QnBvSkpLZ3ZrMTN5WHNZcVVxbStUd2FoYTY2VThsazVzZWEx?=
 =?utf-8?B?QThPL083RnFPcjhKQ0pIOWFqZFJjdHg5djFFWTd6a1ppM2NVR3RKWGEvZ3V1?=
 =?utf-8?B?SzZraU4xL0lDcko1cUNjQVhUbjRzN1FYRlg2bW5uR1VqZ29KeWJJam50SDN3?=
 =?utf-8?B?UW9RQTdEbFoyS01VY0pndENtNXZPcFRPblZINVY3R1pQWmlNZXR5WWRkVUpH?=
 =?utf-8?B?TWtVMGtFbE1ITUtSWjZtbDRvajBUNS9xMHc0eXZQa0NIdm81cVBhUE5kK0Nw?=
 =?utf-8?B?VW9aUVJVbG02Zmx6SmE2S0lXQ3NGU2QwT3dVRFVETGt1TFI5bXpraStONkZ5?=
 =?utf-8?B?eWFUVmRjV1VXaHREcnI3Y1llT2F0SDhHUXJ6Yy9CTmQxV3ErYzcra3QzdEdW?=
 =?utf-8?B?WDNKYVpCUkh3TkFrU2MvVlIzNkd4ZEY4KzdFbmRuR2RFdVo4bCtXcHVRTWZU?=
 =?utf-8?B?anRZUVBGb3pTS2ZPLzNvamxPanVTZnRCOW5pTkVmMW1yV09xWjBqNVhvRE56?=
 =?utf-8?B?R21JSXpxdWx4TGc0R3luMjhvd044TlhVbzA0emFrOUZTVXVTSW1KVlE3UXpD?=
 =?utf-8?B?MXJEUUo5aC82UE9ISXhBZFRUcnl4cUhUQW1UWFQ2VmJ0Y3owb3pKbytQekli?=
 =?utf-8?B?RHFtZ0t3UjVYT3IyUE9aQkJUTVliRjlwWU5BVllGcStVODlSbVRpWFJvbVhk?=
 =?utf-8?B?YkcxNGw3cVZQR0JKWk5MSjV5MHhLbHlEa1RTK3poY3FpdGlFemo1cUNsVTNG?=
 =?utf-8?B?NCsrdFpsNFNVbVVLMExKOEpScDlITFFxWGxJbVRNaVJ3bHQ5Zk0vL0VNdk5I?=
 =?utf-8?B?N3JYeVNyUTVOSzNtSzlzTUpIa1hySkp5aHp2SElOVWJyWXNVdlNiamovVjFX?=
 =?utf-8?B?ZjZXdlE5ZHpWVjRWMUFqNFNVYTRGVzF6UmxyYjF5QnlUeS9aaE9FQnlDR2I5?=
 =?utf-8?B?UHR1RHFvWEduVlVDZUFjR1dkZnhSNGFybmZGdjVuWVEvNEdOM1ZEcko5QkdE?=
 =?utf-8?B?Sk5ua0RaaXdhcVhvMXQ1WEY0bHlCVFBOR3RDRDRqeGpJUTNMZGw3a3FvUFpZ?=
 =?utf-8?B?UmZmZS9iTFZxUEJGWWhJbzUwZ3NHVThMNVFNV1JjRDNrSnY3TWpsRXR4enRG?=
 =?utf-8?B?ZjR3QkEyYS9rbWdFdEFMUklSL015US91SWxCZDJ0VjBVbmZZZS9yeDlkK0RK?=
 =?utf-8?B?WU1YTDlyU010REpoVUdKUWpudStIbFYycDdhcGFVNjNLdjFvSkY4U3NnTWZO?=
 =?utf-8?B?NnJPdTNTblFwOEdTb21zZ0tJUlJxdGdiRmJCRWlmemNMU3hvM1FWeThYaS8z?=
 =?utf-8?B?RVdRMnRHYnZGd3E5WEtmTFZqSk5hMTYxY3grRlBXYlh1UTUxK2dxUkE4MmxF?=
 =?utf-8?B?QU53aTNTUkxCRWptdVl6bW5XVERpb2dEUTFhTW5hVGdCNnRTb2JRZy91bVpN?=
 =?utf-8?B?UjZVTDNXdll6anlDaEE1cHh5UHNUR3JLYlh3Ty9rdVRNc0x1UmNVUEh6NlZi?=
 =?utf-8?B?d0RWUXAxSExuWWZ0KythZWNmTU9xM0J4YmNsMk5kS3J0MU9tZEI0eVJEY1dl?=
 =?utf-8?B?REMrbDFZbUVYdkE3a0Eyb2lMUXRoYisyeWdVQ2FBN0ZiTU5FRXFrdWVGQmp3?=
 =?utf-8?Q?ogrvdEU+DzSfYp9NmSMrwX8=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bb88b4d-4e50-4616-40af-08de3e948f05
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 00:21:31.0359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 19yJObHjNA0TJewjhbYgQ7S/WZEBt7K9pYGSvkOwdTf3G5ibzKP8QF/S1RYsitdp/JPj+O498ss+8tROqx7ifrZRpgTBSn2O/PWmv4CTET0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB10504
X-Rspam-User: 
X-Rspamd-Queue-Id: A13AF4000F
X-Rspamd-Server: rspam04
X-Stat-Signature: 6y7umqzk4kn18xyi5sr4rf9h8ohap3pu
X-HE-Tag: 1766103694-282076
X-HE-Meta: U2FsdGVkX19UdjaU/fzXfVtF4D12pWyh2VlraOY3CJgI+3HfwA34aMvar6DjPwy+Qx88ARx9DQP1ndDyAKowaUjIkVt94Z3tu5cg+CAgKVhOoScgjXkWu8H/cTwsF6qb44RwXbZPBM0Jj29JzH44rGPHyBJ9VRYndJ1oSdfe0G46D2kyJTlqld0iq5FEu1oox8QttuLR2QJQRWhsVChn1i5FfgjmFY2M7SM4VVkmGDSiBZ3OPVcvqOPaOX4ghe4E3+bu/xYEtYsorXcgs0twziYQtYfecFPGehhn9skLwWSx/X3HspGlcT3meDVh1PTRVpuZogUsXBD/5IdYT6J/UUQvuB+Qr3CiTdV34uou3GvU+CpGh8yelmra6kaQg/F7NyiSKXfAUQmSJf2qfnmAsAGXqsgZsbWeAwBkHKJ4apOYvSqGj94gTf2Egdt3jkhF4ntusJ7YSyCw8kxXfCfxn3XVuBp+bsF/662PTWSl4BDzu/WO1xdWQr85hqv8c9hL2D6rhZZWgPB8zNGgT6GYPqJC17u/q51XYTSXDfwB7HtItIZhE1NEdJAb369NqcUTUI9hW3yHqAtl1m0/bD+XhkllSa2ouLEnixSSXNrXR6GNJDtrjNG89LK9wHR3Wx8tCgdLjoq/h83V9VRXks3Otk0F+twKD+WhcFVrhtzfkva9W9iqKZG30sNCyt5SzmiDArSm2sdjvgV80UBL7eSQjgjYcXvA/2Eyna69TafPDZcvUSP4deFx31bgDKFrv4UdhwtM1deo6k8MVAfL+BHvvgiV4jlylAKlvhvj35BYYaVfwAgHy/MKQykZX28gHoAl0eApUmdn0PCAXEH0NhEmWBX8WhjUeoW14LMVQ9oAV1qdPU9sQZmqWQYEHk/fzTgszCQmKOnM52O0ZOKLwxy8rbrSNEmvUZVCr3yGuUnJXc/rkzXsvSsswi7/DnGBvPtI3m5Da0nfAmPUWuC9mpz
 0n9Bzsnc
 pjRa2NT6q/bfFGnmzZc175gI0HC1Phek44nyMdEYnlipzorZPb6op+tqCi5ZpD9ZdwvPfdngeAp62exd5p152fMxVy85BMP/WuPUagD59qS6xj0ecEeXmL6exMz3cVYBIGSLOdrJaD7NHE6aE5h+mG+q2PilEDRQZns8PGg3vjg9NF94DA3EuZV74QoofGOSnhDqIvuStYI1jLmhIa3+w8XstQMnM2H1iUvbCMHuKu/YV6I53uG10RyHAZrDDYQIGw2bHoXpVgeIAwKW4qHLqKsS+QgTs5/XwuXH+S53BHFyRiNmnMYHrOMaouMzTgMCa5wIngxYzNz+nv9ELRFzZbYj2il664mbZieUUq95z5GHWcXWfAePzq2xi1R/tAWBsdgxTKaaNGoQJ0Lv/lUi5h7bY+SVfJpJxS/ArJTdhMHmK0Bbh490omtDbs78l82T+uWSN7lrOXejGC8bNv5IxuzocFRw9dgDKk2YppVBBIZ1WYnmLSUHmGPeBwzWAGpyby2Sw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-18 17:16, Boqun Feng wrote:
[...]
> 
> I would suggest we make CONFIG_PREEMPT_HAZPTR always enabled hence no
> need for a config, do we have the measurement of the additional cost?

Removing the PREEMPT_HAZPTR brings read-side performance
from 13.1 down to 5.1 ns. So there is a surprising amount
of work that goes into list_add/list_del.

I just noticed that I was running a kernel with CONFIG_LIST_HARDENED=y.
Reruning refscale for PREEMPT_HAZPTR=y with list hardening disabled
goes from 13.1 ns to 12.4ns, so not a huge win.

I did not notice much difference in terms of scheduler
performance with a quick hackbench run, but I cannot
claim it is an extensive benchmark in any way.

> 
> I think you need to add interrupt disabling for chain/unchain because of
> the potential readers in interrupt and then you can avoid the preempt
> disabling in hazptr_release() I think. Let's aim for supporting readers
> in interrupt handler, because at least lockdep needs that.

OK, I'll look into it!

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

