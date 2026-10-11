Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89242CA9ECF
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 19:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2E36B0088; Sun, 11 Oct 2026 15:42:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0623F6B008A; Sun, 11 Oct 2026 15:42:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6D316B008C; Sun, 11 Oct 2026 15:42:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BAF486B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 15:42:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 06A6B1606E2
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 19:42:30 +0000 (UTC)
X-FDA: 85311367260.17.DC041ED
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020124.outbound.protection.outlook.com [52.101.189.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id DD42E160006
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 19:42:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=IFQgaxtL;
	spf=pass (imf08.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.124 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791747747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMVVSAfz5M54lz72oU91TCzAgpiJqyERLUOngmmAo1g=;
	b=tJ8CJNMVNpE3e5xaAnxlBclRJ9rYmYWvwm5FAbrA5OhbN/58qgUWH5oq4Aii2+a/mhfM/p
	DzSdd6DC7SO5ZPnE0uwNiU5yfVhXrXObPf8KzchpDtHLuGnZIkADdXO4quZ667BJiFgTZx
	Ol3My4Ac+jpQxDf7NeIrPc+nsEYG35g=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791747747;
	b=oFgNG7qPlKUKMNHhn2fF8m7SFhQLjM5n/U5dsDuuM50rk3vujmKOJiY4GVTCkvUUTMGiwq
	ZoaD3GmIPphdIwenX/0jJw4npyTIrQk3wzMclMYFwVVTj0a8DSR0SBNXpahYWnaRZ1Bj74
	e/EU+zqzlXN6KBkDqto+oXJ9Wg7l+Ic=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=IFQgaxtL;
	spf=pass (imf08.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.124 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QAn5HcAQFxmbTTouLy+k/t/k8UAJ5bfp482eCGEDRPSAyvFfG5atEy4YSjIOff5/v6Uw4LRWkxmEwQR/Qg0McpnCoICayumn2RLZSYytOVEJyTpD6PcwIQyO+0CWeVdSD7Q2QJQJoqpxotLzyGx7ssUsIitFbz7M3ve3Xo9exoiZHRtafy82h1q8meiWWZm7NNIoYGdFrbksYKqsRDUSoR+2iFPJwy6QqjsW/VMZzbfz7K4OtrfCdQJRxcIFd6hqXHDTbje8NFula3CJDw3HjW7rWDtYyPL9Fm6uKb1TZWrajnV+VOD6FkgTpN0WNRtVgrH5m0MiqNo41v/riLFi/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IMVVSAfz5M54lz72oU91TCzAgpiJqyERLUOngmmAo1g=;
 b=qoW03433XwMavgswAAfua50FxfHxUJ0L1nRfyB4PYsVh8Jw5LDV7WNFs5TiZQDEE7SmFoXNaugP1E3xzKjIcyJhAd6DRdx657KIiY68P6CNj9/Bf4vKszvEE+lYIctXbhAFDapTvIByuX1ehv6QlJEEcVmfphuMwRsfmg7D3rsu8SUgfEWR5P98s/n9bh67G3kmljZCJoPRsTg1AcfrJ1sttmVWb26bdDLuDpfr+0Eo2m94cyBeVZFzHAZeCZrM6cGeQ1/UmzRpSCQ3QazrIblCasyDfa+e+GmMtdSmsOEbcNev+jDEUMegK9urskXPWRIwNQkLZtbvJxD/Tmeyl1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IMVVSAfz5M54lz72oU91TCzAgpiJqyERLUOngmmAo1g=;
 b=IFQgaxtLatlTjyUHMb/9KS1YhfzJzTiEDSxGiVWepie5upvF3sKjbZP7E30eVelDE48vGl3/lGB5TwtRIpnOaAFGOYH7C/FbXNkBY7HtDXeTitDoU8uiLAj9RZDoVO2hnHIFnmMe4sgrmFhsoZlBGpdiUnVzdONGR1kLT8V1pJHx6JPpX3s3UntEkmSmKOsLgdJOlaK5VdxYMsWvQckzn/rdlXH6tmw6dIPDmL04ucqwtNR7jWa51sTmOnH00qzcPlSPglscX6eOgOOdQfECGNUb9rsLiXfxYgvK8xor6guBxJOrRAfzvmEoM73QUVKw9bIPL+pHe452QSmZkUoshQ==
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT2PR01MB11270.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:145::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.21; Sun, 11 Oct
 2026 19:42:23 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0496.019; Sun, 11 Oct 2026
 19:42:23 +0000
Message-ID: <ae7d5e92-2b64-4088-b3a7-a4d02176f861@efficios.com>
Date: Sun, 11 Oct 2026 15:42:21 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH hazptr v2 2/4] ptreq.h: Introduce ptr_eq() to preserve
 address dependency
To: Gary Guo <gary@garyguo.net>, "Paul E . McKenney" <paulmck@kernel.org>
Cc: linux-kernel@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Boqun Feng <boqun.feng@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Alan Stern <stern@rowland.harvard.edu>, John Stultz <jstultz@google.com>,
 Frederic Weisbecker <frederic@kernel.org>,
 Joel Fernandes <joel@joelfernandes.org>,
 Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Waiman Long <longman@redhat.com>,
 Mark Rutland <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, maged.michael@gmail.com,
 Mateusz Guzik <mjguzik@gmail.com>, rcu@vger.kernel.org, linux-mm@kvack.org,
 lkmm@lists.linux.dev, Nikita Popov <github@npopov.com>,
 llvm@lists.linux.dev, Lian Wang <lianux.mm@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>
References: <20261009182142.6311-1-mathieu.desnoyers@efficios.com>
 <20261009182142.6311-3-mathieu.desnoyers@efficios.com>
 <DM0N5L0LG9P0.6IFXMJX60P92@garyguo.net>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <DM0N5L0LG9P0.6IFXMJX60P92@garyguo.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQ1P288CA0009.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::17) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT2PR01MB11270:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f808eec-e2f0-4d5d-c778-08df27cfc547
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|56012099006|4143699003|261009221227099003|261009223027099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	1rRlFe8f7XoDVY+g8oCZIPD/EWsKPc3FxmKafLSQlkqTApsJZlBGE3pnPyNyB8xMZDc8+NUrgjg7VDvt2u7L+glEBIs6GvBCrOt050sL99ppRAw025spH1e0wvbdAZdFU0wyo+AbHsEbZasTU/7kukrFG/8WJHg+Wj+2PXZw98fOMm3IvMJhJfpEPvby1/M49gN6bsGQ58KY2end82YNDrZyLKXjAzo4LHS4OqrxfC7QMpF6pUcgg6hvJK/9T0488rjoMkb86c+PXsko8HYHyPTXu5K7tqohcDw7Uod9c3yS5V9Goot2tnmWkJrr5Z5wevqYRBRmVAKWsWsrrA1ItRRq9G2k2T3Eizds8ucFLcgxXttJEVju+d5q7MaMKIagGgRRWjvnDRPjcbHNsXynt7O+paFsR+0MUCyyOKmA/CmQVX735cxFGuH/AJ8XYrYoqTfoz0gxpDxv7BMBUnR4hCm9r7WnqzpgfmFAd+HMggqTzuc0LqbPxU5EzMhbSl0PDBnOnrMovIAd6sycpI9ZiN7WSI0tCibnW7s0SQ9WB+Olf/zNulT0Bt5k/2SxO1ADixmA5G1BGANKOsy5wL7ryjUNotlm09GnDwzY4PQoeq0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(56012099006)(4143699003)(261009221227099003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eFN1Qzhkc3lnN2VjT3MvTGQrTzEwbGZRam5GU09wVG5NYllOY1VRb2JlRU1n?=
 =?utf-8?B?bytpc29lYTdZZXg3SVdKOVJsNUprRy9FUVRNUE5VZkRTckxKODVYc1BCcUFR?=
 =?utf-8?B?cEo2ZjNFSE9Ra2pIT2MzSzJPMGRuKzlwdXpaSjc0Y3JhQUpVK0NKWnIzU0NQ?=
 =?utf-8?B?UlN2RmdialdmaHE3THczeWR0c1JZSWRiVDdLL1BsRVUxY29vZjZNakpKbWYx?=
 =?utf-8?B?djZsMXRFaWUrbitSTVdkU1R1bnYycUpmY282UDVGTlQrTjByZFNpTHVmQWVz?=
 =?utf-8?B?RVhKQVlsV0NySXJVKzVCbGRYVzlMdEpTcDFSdi80QjQ4S1BlN080TGdaVWZN?=
 =?utf-8?B?bkpNRzRGNkZJYzU1Ui9TNnl2clk0cjgyTW11K00zaG9QS2FZRFQ1Y2lCeXQv?=
 =?utf-8?B?aEhmZC95Vk44Nlg4c2NHUXgrLyswMTZDam1DUVNMaUJQVG02a0hIQ25UZXVm?=
 =?utf-8?B?TUV6QXVTUzQ4QU1NU08weUsydjMyNXFMMUhhSE80aWQ3UW0wVTVZUUhNZ0Qw?=
 =?utf-8?B?MGt6cnlBSFBDRG5RZ2F2MlhQMVRpQUpYbWxPWkUwUjlsY0VGUW12eVkyYzlG?=
 =?utf-8?B?WTBXQ1dJeTQza0hjL0tTOWpySGRPSGNPN1BNYS9pWjV1Ujl0Z3c1T1JnZGVj?=
 =?utf-8?B?N1p3RGdETFZFWDVpbUMrc1IvQlZaTUNZQXJCdjhReDd3N29NaWo4elVlbG9G?=
 =?utf-8?B?M0tobndPUWZQbVlTWTVDWmc5ck5tTlFkODBpTU5wRmd3MHJsVUVVUWlaeGhF?=
 =?utf-8?B?bkNkSjRQQVNkU0pURFlHRUdBREpkTmJwejVSbmZpZ1dES3pvYzl2NXZKL0xx?=
 =?utf-8?B?anNFaUNxN1hWVFJrdStoUC9LZkc5MjBydU4vejl5bzJwVjNHelpIK1NNWllF?=
 =?utf-8?B?eVRkSlo4bmxFa1VySlpRMWlhYm9SNkVGL3kyRUVQOVdTQmppNzkyams5MFI3?=
 =?utf-8?B?VnF1bUIvOE11ZHdGM0RGR2VpQ0tPdWMrRXhyMUFYK0JBeGlROTVHWmdtT2hY?=
 =?utf-8?B?T1I5NVdSUEVnQkRrR3IydjBNQmszeTFkTFcwQVNRbytDcUlNSjFsV1FHOGtm?=
 =?utf-8?B?VWtyUkJ5eVBXMytrbG9GQ0lyTi9QQ1l3ZWN3WDAxeW0rc3lRMkFmOWNWN2Jq?=
 =?utf-8?B?ZWtQVk5nTGh5WTNpYlROeDdsRy9TbEd5WU11KzMxRVdiQXJBQlFEM1NJekNJ?=
 =?utf-8?B?MHhpamZKWnZ4SklmNlUvSmxFSnJwSkRUdEIxelBGekVuai93OC9GaUFPUVIv?=
 =?utf-8?B?bnBBenBUempJemNZYm5pV25jclh1UWcvbEhmeUMrcHM3ckR6b1pUL0UwOEYy?=
 =?utf-8?B?eTd4S2ZTZzdlYkVGQnZtdjlUWHNpd0dGdFg3NnNySkZrWXZ0Ty9mQ0V1aERm?=
 =?utf-8?B?TWk2T3h6RFcybEszWitWT0VJT2pKTmlxaVNRSmkwMHlRNUJpVE94czdyTVQw?=
 =?utf-8?B?ZDhNZUQrQStQcHg3WmlMVDNIQld0K1dGWEZYck1NeWNVMVUyc1E0eUJ1VGhL?=
 =?utf-8?B?U1orSDJUNEFWTG1NWTdqYUZLMHUydjZJcjFLbXlpVXdNWW5kSkMxNUtMUDll?=
 =?utf-8?B?aTBQVHpOVXdNSXFNbTFNQ2c5VDArd3VmZ283cjdQWnRyYmJOQllVOEpsMmxU?=
 =?utf-8?B?T0JOQStvSFdEa3U4M29MaWk0Y2YwY1Z2bTFtd1Y4L0RrUGlDbjhGOVd3NlNT?=
 =?utf-8?B?L2t1ci9RYzhVdUN1N0ZDUnkvRFhXcm96cnpwYnFXTzhWS2ZBaXo1NU5ES29K?=
 =?utf-8?B?bFNpUW5nYVBmQUkrdm90VVEwKzJGdDdLMDBwN0hEVVFHT21wa0FaWVpKQzlt?=
 =?utf-8?B?SEVJRzRoUm1XUVd4Z1hrYXBsZmJ0cldMZEpVSUxlam9FSzhEK0tyRitCdytP?=
 =?utf-8?B?SmxzaTllak1uZHA4L2VYd0tDWlV5RkwrcEZrV0JNUFJBZEU2QXVsblpQcFNY?=
 =?utf-8?B?dGpiMHpWWDJVVDlVTzJTUTc3YjBHUUFPK045d1h4WUVhVHQ5RzJ3RG1HREp3?=
 =?utf-8?B?b0xieVRuREM4VWtvQUFMRGRYQmF3ZzBnd1B6Tzc4MFNMVzNqOUFjRzJWZ0hU?=
 =?utf-8?B?UVozMlFOczdTU2UrYnE3OXJxcXdjdTZTeEpVMFBONm5CMDZlcTQxaTdaNk9i?=
 =?utf-8?B?aXF3WnpMZlBEVlZ4N2xHMkN2ODU0VTdSWFVoUWsrcTY5OWVwS3dzK1F2ZnQ1?=
 =?utf-8?B?MXVtcUlWNm40anNESHlUc2JtQmI2OHBzZmxkS1gwcGExbnZVZEdQSWpScHp3?=
 =?utf-8?B?b1l4QzN0QmNtQ3dhZTJHbWV2SnpFeTExekRQend1MVFuc2F4OWhCRTZVcGhx?=
 =?utf-8?B?RWdEWlJBa290UEVRa0hZclRVL1JOYUdMUzMrRFN4UzlIUnhzaHQraDFPZm0w?=
 =?utf-8?Q?aq7/BEGCcBoOiM80=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f808eec-e2f0-4d5d-c778-08df27cfc547
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2026 19:42:23.2902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A4U4KhuOjxkf2dOxsJD8MiW8lZ+al/TWyS6bEJkT4fYDQ1v/ntNTwKIH8vBMqER6DmRurVPLuGU83mexHJ1AYhMt4lWVQuzGeGr5EN9M+UQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB11270
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DD42E160006
X-Stat-Signature: d4qkdm8rujs6a3q9exiyhc1q6rhuirhw
X-HE-Tag: 1791747746-771741
X-HE-Meta: U2FsdGVkX1/OGewBJaMfeKRWCynRNXfVWwVzoOtrz/JgT+w6zlmN0mBGYkdhVV2T0+g3jpJfRR+ewibJ2SrAOzIt1f+I5U8tGq91LQB3RrGnM7MYlKt2Nnr3E/GHVi2LYAyLzAKyhWebl8mxw+twMsjze3BBlPuyc2QbCAuL/Wh2wKO3ogskPYR36Eng0dbswQ9U5IJXnfgdnJiayL3PPOC+xcbSwWw2A+Ihzga2EIKqsBvJOHMjKkaUtRejT/uC7B9HlrrLXVyUtmjObnPMUzGZ+DYC6THpKrJofh59b7+fXcge79auQynfuSKDLgArAa1u2jZYMLRcIKxutExGa8063po3KAaOXKd2Xi0b8GcHwgAZ8VR0f0tzq2bC81qgN5USgX75BeHa9uoYy+9sWg5KkuXUXFC+H9yxLu+K0FHPQ91ckvcuiKeqDDwHayWYtIqBrrFl45Olqn0wfmW/FSnR6+42cufMDW9hVHuMJcLdXtmjwAE7fxHtObKvDPuFlEsqoF6kn7AsjKUDTYIieye2LxVzC51cXU18v187sp72D1pV3T83V2MKzirVIpelZR2tOlPkp68NXHfVSg0IC24ujzP6+epv0f1ndYX8ZGVuGoYukeIwHR33kXeXdbDuJ9LKPsvfP1XB6mUSSSJNdRE/CQtPdJ2vvW5BUp1lwsolivfjX0eyf2N0/oqa3C7kBjYun2y433WkLn8OSwEKXzAwzzAKQogYZg0gQ4XNPPGyAeOswxTHOwxDi2TW6L0B5kkjeRL5x4ASW2t2Ndh7lGK9KuuHqxVEwwmgMbC9tNyGYDb7yqH4IeH4aRnFOUWxHr0r0Bj43xdMq5Vycj4QRjKq5WUPJu/XxODHXsF4VzLdECllSRsN+KfX/V45fj5pngOJ2poTKMGEQqHoXg8gh5C8fopvywbI7lsQIno7TPrX6PWW+yXZ82VnF/fS+3lM7GWiZJxEumAYnqLWBtk
 5DJrMddr
 5xlzns+mPUVB1mEkGklu4Nqb5dn73RT11mFYexs1E5OdCdjbWlPBXQfWuix+dAYS9EV/Eg3k/ZN3Idr25rIAiIXeglf9+iR7wW9Nbp9OvYfJ5y3hWHqcB32OCra3tAvoLY2wEiKcLV4GDDYFq2UEForFIv6WGPMnpg++HRKcQT4PIGM38UOR+w2GNOlD4sBnHQrK0wwJv1VPeliW8iNK4CFh7O9PT9IYwm89V6PeL6bUwc7H8PK1xemoXH1R+MqxU0w3YYdIqu89NWdPFGDAc0m+AIhg8zWVRN3m4tIv2F95VmEAy0nVh0wIBDsZsSO3sG8vZjxQVyqsj2hCS5ugz26XC56mlLymRqwMqH4I/ZMl3wOFHA1zfQdSK4AxahuUSXn4/01T1U0duLAmVN7+kXBqA94mY1Z+bW/5bof5jmfudm5ifhSPajx5L+EKbhkd0KBI95AlVZ1NI6P2wRd3SuZDrvPIwAnxdIKUCw/NBEnSqvmhpKkAtmHHAM7ePl3QcfEv0sYep5rRI2Bf3K8vTk/kVbsFDns3HCOV2BPWQT+C9scwKhv5EyvnXge/Ct+KhxQjmjqWGl1Q98KkKpYgwWuJVWxYzX0J+ZlQ+XhzfyGOTnKR9jVIrpkpYSrEgS8gaiXivmwHVkc3zdaQC8fGK9PY4qvKj6mDIZhPAHLR4l698vckJMvluZ2DCPmNSXMkSoTUag9uEIfbDJQnO00B3Lvx2YKMByIUt2i30hMDFXqY0Ehz/3Tai23M8db/KoBhazmpEEQ4WcBTPHET8Rqky1xHIY6uQFmHp/fh+S3SHxP0BoElEdQkWM0JSTL/onBXc3wSJ5qvMHFjUXUUHvk5Sl/JNULN8Me/7apU9gkUMXxJo5NUJ2ipmC59qHHJFl7uLuBAFpste/QWLhiuHbgoiOZOTFhwl20u4B0tiE/YlLu9GyVCWonI6FsQb483/4PO3bqgwqk5sZAk88VJTIGgrBr/AZKrl
 rOZQaGhl
 PK3p7qexboH4YeD8H8KR2877s8f+D9TJXECXDnsXS2v1GIhHmMHe3OBBSla4+EpkdZ2NBEcoUKmcaUaTsmWIdCxxMp4gp1zQW1K2Pb4oP+gwfEYKAMc/3zM2wOeGgpVs46NaS5WgPEuFthH7qdstq/Y6rgQj+HVnfBSN9MjI6d/G2QgZcySzevrht9d0vealEPE71br4v4BPOrYfBuOwQbY/qUDF4uAdj11219rKDfsXzq7EQRq5783ac2tOo1fCbp4v3gxO50olSE4A8dmNiyTW9lG0RFU8BCEXkbTQvgD4f5labjfP1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-10-09 17:55, Gary Guo wrote:
> On Fri Oct 9, 2026 at 7:21 PM BST, Mathieu Desnoyers wrote:
>> Compiler CSE and SSA GVN optimizations can cause the address dependency
>> of addresses returned by rcu_dereference to be lost when comparing those
>> pointers with either constants or previously loaded pointers.
>>
>> Introduce ptr_eq() to compare two addresses while preserving the address
>> dependencies for later use of the address. It should be used when
>> comparing an address returned by rcu_dereference().
>>
>> This is needed to prevent the compiler CSE and SSA GVN optimizations
>> from using @a (or @b) in places where the source refers to @b (or @a)
>> based on the fact that after the comparison, the two are known to be
>> equal, which does not preserve address dependencies and allows the
>> following misordering speculations:
>>
>> - If @b is a constant, the compiler can issue the loads which depend
>>    on @a before loading @a.
>> - If @b is a register populated by a prior load, weakly-ordered
>>    CPUs can speculate loads which depend on @a before loading @a.
>>
>> The same logic applies with @a and @b swapped.
>>
>> The header "linux/ptreq.h" is the expected include target. It
>> contains the documentation of the ptr_eq() API.
>>
>> An architecture specific implementation of the pointer comparison
>> can be implemented by each architecture as asm/ptreq.h. The x86
>> implementation is provided initially. If no implementation header is
>> present for the architecture, an arch-agnostic fallback based on
>> OPTIMIZER_HIDE_VAR is included from asm-generic.
>>
>> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Suggested-by: Boqun Feng <boqun.feng@gmail.com>
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> Cc: "Paul E. McKenney" <paulmck@kernel.org>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Boqun Feng <boqun.feng@gmail.com>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Cc: John Stultz <jstultz@google.com>
>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>> Cc: Boqun Feng <boqun.feng@gmail.com>
>> Cc: Frederic Weisbecker <frederic@kernel.org>
>> Cc: Joel Fernandes <joel@joelfernandes.org>
>> Cc: Josh Triplett <josh@joshtriplett.org>
>> Cc: Uladzislau Rezki <urezki@gmail.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Lai Jiangshan <jiangshanlai@gmail.com>
>> Cc: Zqiang <qiang.zhang1211@gmail.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Waiman Long <longman@redhat.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: maged.michael@gmail.com
>> Cc: Mateusz Guzik <mjguzik@gmail.com>
>> Cc: Gary Guo <gary@garyguo.net>
>> Cc: rcu@vger.kernel.org
>> Cc: linux-mm@kvack.org
>> Cc: lkmm@lists.linux.dev
>> Cc: Nikita Popov <github@npopov.com>
>> Cc: llvm@lists.linux.dev
>> Cc: Lian Wang <lianux.mm@gmail.com>
>> Cc: Kunwu Chan <kunwu.chan@gmail.com>
>> ---
>> Changes since v1:
>> - Move to linux/ptreq.h, implement x86-specific comparison
>>    and asm-generic header (fallback).
>>
>> Changes since v0:
>> - Include feedback from Alan Stern.
>> ---
>>   arch/x86/include/asm/ptreq.h | 16 +++++++++
>>   include/asm-generic/Kbuild   |  1 +
>>   include/asm-generic/ptreq.h  | 16 +++++++++
> 
> I agree with Boqun that this should be ptr_eq. There is no need to save that
> character :)
> 
>>   include/linux/ptreq.h        | 63 ++++++++++++++++++++++++++++++++++++
>>   4 files changed, 96 insertions(+)
>>   create mode 100644 arch/x86/include/asm/ptreq.h
>>   create mode 100644 include/asm-generic/ptreq.h
>>   create mode 100644 include/linux/ptreq.h
>>
>> diff --git a/arch/x86/include/asm/ptreq.h b/arch/x86/include/asm/ptreq.h
>> new file mode 100644
>> index 000000000000..593b45f80451
>> --- /dev/null
>> +++ b/arch/x86/include/asm/ptreq.h
>> @@ -0,0 +1,16 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _ASM_X86_PTREQ_H
>> +#define _ASM_X86_PTREQ_H
>> +
>> +#include <linux/types.h>
>> +#include <asm/asm.h>
>> +
>> +static __always_inline
>> +bool ptr_eq(const volatile void *a, const volatile void *b)
>> +{
>> +	bool ret;
>> +	asm(__ASM_SIZE(cmp) " %1,%2" : "=@ccz" (ret) : "r" (a), "r" (b));
>> +	return ret;
>> +}
>> +
>> +#endif	/* _ASM_X86_PTREQ_H */
>> diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
>> index 2bc00c67dc54..e1d95dea09d5 100644
>> --- a/include/asm-generic/Kbuild
>> +++ b/include/asm-generic/Kbuild
>> @@ -47,6 +47,7 @@ mandatory-y += percpu.h
>>   mandatory-y += percpu_types.h
>>   mandatory-y += pgalloc.h
>>   mandatory-y += preempt.h
>> +mandatory-y += ptreq.h
>>   mandatory-y += rqspinlock.h
>>   mandatory-y += runtime-const.h
>>   mandatory-y += rwonce.h
>> diff --git a/include/asm-generic/ptreq.h b/include/asm-generic/ptreq.h
>> new file mode 100644
>> index 000000000000..db5a88628b1e
>> --- /dev/null
>> +++ b/include/asm-generic/ptreq.h
>> @@ -0,0 +1,16 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef __ASM_GENERIC_PTREQ_H
>> +#define __ASM_GENERIC_PTREQ_H
>> +
>> +#include <linux/types.h>
>> +#include <linux/compiler.h>
>> +
>> +static __always_inline
>> +bool ptr_eq(const volatile void *a, const volatile void *b)
> 
> I suppose this is `const volatile` to take advantage of implicit conversion that
> adds cv-qualifiers to be added implicitly. Might worth a mention in somewhere
> (commit message maybe) because I was confused for a second on why this needs
> to be volatile.
> 
>> +{
>> +	OPTIMIZER_HIDE_VAR(a);
>> +	OPTIMIZER_HIDE_VAR(b);
>> +	return a == b;
>> +}
> 
> One thought on inline assembly. For RISC-V, branching with comparison is a
> single instruction, but there's no instruction for obtaining the boolean for
> a == b.
> 
> One option is to do
> 
>      static __always_inline
>      bool ptr_eq_likely(const volatile void *a, const volatile void *b) {
>          asm goto ("bne %0, %1, %l2" : : "r" (a), "r" (b) :: not_eq);
>          return true;
>      not_eq:
>          return likely(false);
>      }
> 
> and then the optimizer can turn a ptr_eq call + a branch to a single
> instruction. This, however, would require likely + unlikely variants.
> 
> Alternatively, we can just not have all the complexity, and just emit one extra
> instruction:
> 
>      static __always_inline
>      bool ptr_eq(const volatile void *a, const volatile void *b) {
>          unsigned long diff;
>          asm("xor %0, %1, %2" : "=r" (diff) : "r" (a), "r" (b));
>          return diff == 0;
>      }
> 
> Thoughts?

If architectures end up needing the likely/unlikely variants we can
do that if it saves instructions on the hot path. How about we do this
change when we introduce optimized support for riscv ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

