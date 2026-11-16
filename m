Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 197D3606A339
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D24D6B05B6; Mon, 16 Nov 2026 09:40:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 382F96B05B7; Mon, 16 Nov 2026 09:40:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24B406B05B8; Mon, 16 Nov 2026 09:40:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDDF76B05B6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:40:58 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 868A880116
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:40:58 +0000 (UTC)
X-FDA: 85441244196.30.1C4765D
Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020080.outbound.protection.outlook.com [52.101.195.80])
	by imf31.hostedemail.com (Postfix) with ESMTP id BBF5E2000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:40:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of atomlin@atomlin.com designates 52.101.195.80 as permitted sender) smtp.mailfrom=atomlin@atomlin.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794840056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VqfbOwrlNXH7MBy2kO3Dzp0ect/wJh9Zs0CWKeehpek=;
	b=pkpmXW1aLJV2fge8TgutAvCzk5j1JvQBxHY2fOTdZcf4vhsvWFd4IvN6N0WP3oJWTVGhmO
	UtAJMIGPsYffqHDjCCqlWJ9tA463s/k/hcB27ulTNCz9w1VT7uvvR+gfbkfViqjTVML9oB
	NcYo289b6LNXbMWsaq22DnSZWsSS/ro=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of atomlin@atomlin.com designates 52.101.195.80 as permitted sender) smtp.mailfrom=atomlin@atomlin.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794840056;
	b=I3eu0MAJF6vS+wDf5uwVMQfw8oKTiBC3M80YRG1emPAZ4JqOWghQzFgaBkQyi4N57X+dhs
	rrprFCIaadgGIR7a1RVQfsyq2zRbPFIlTrkQcx/e2iotLIdvc1C/HADb9fD1YP3+f9OT2c
	iSPfDetzp8ZU/PVmlmgmGvSxFJoDG5Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ft/dWdNaSiMMZeKCbBWmGb9KFvkClp7eEVM6sIQnei5Fexkau1B4tMjhUmYow5qwu96vxyIL46IFjNlACdnF1yX62RGE3A+ntFC+AEmC8VH7c8Ehls0pb9rB96dCFp/wzwMAIGrjabeioNKDGubxfkJsZh6IL3za5EpjujVuZ2CSsdoctO6fyFJUMxXzIS87ht/pDWR1C+i3kgJW2PirJnQk+jpVBdelS9eCtUvBFvMYivqYJ1Rjl1Nk8G5FkCWnqS1QSuzGZtwy0GpQjtJ+Fi6OFimpmv6Wdul2QG8xdNSFvUViigU2ZhYit3OrJm065QX9dIDF1XHUdur0Unlp5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=VqfbOwrlNXH7MBy2kO3Dzp0ect/wJh9Zs0CWKeehpek=;
 b=u8vpHq7qVWoCnB8tBnmcnGiFRPu/QJneohVhRD2UL1usyEUq7MTGynBmHHS0xW2VyKlAaXepldW3Iu/6c06lZkqstgJjvoeQ01O3gRc9nMlBLTH3ACTI9+BQ64SA64LR2wS7lPgAVWRn1vEDvQuq27ddwfN1vGTEG4qWPriE3vc44AJRoIWx2fEfRYYdO2WiyOF+QeZi6yvCnU/R9HOazMIsPKg1nM2NWVgUiKGJxmiHG25hokgDkHPfPW2mVIqFdWJLM0x7RQlfU+W41xKBUUeLGGDBvR98cG8CEvQcaYjQuCW3kVsvgvDb23I96JFOZqJR+gqmF2tF6sV34Xut8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:163::8)
 by LO4P123MB6596.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:278::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 14:40:48 +0000
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a]) by LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a%5]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 14:40:47 +0000
Date: Mon, 16 Nov 2026 09:40:43 -0500
From: Aaron Tomlin <atomlin@atomlin.com>
To: Thomas Gleixner <tglx@kernel.org>
Cc: pmladek@suse.com, john.ogness@linutronix.de, rostedt@goodmis.org, 
	senozhatsky@chromium.org, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kprateek.nayak@amd.com, akpm@linux-foundation.org, 
	baoquan.he@linux.dev, rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	ruirui.yang@linux.dev, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com, kees@kernel.org, 
	anna-maria@linutronix.de, frederic@kernel.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, 
	bigeasy@linutronix.de, clrkwllms@kernel.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev
Subject: Re: [RFC PATCH v2 3/5] timers: Avoid blocking on hrtimer_cpu_base
 lock during Oops or panic
Message-ID: <cg4idz5t5eh4yptrte5xvyhpk4jrp7ckch3iezeto2enkai7id@jqv4w5gkpagu>
References: <20261103024453.922373-1-atomlin@atomlin.com>
 <20261103024453.922373-4-atomlin@atomlin.com>
 <87y0b1tzbi.ffs@fw13>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87y0b1tzbi.ffs@fw13>
X-ClientProxiedBy: YQBPR0101CA0226.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::26) To LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:163::8)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P123MB4190:EE_|LO4P123MB6596:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d329549-b645-4dac-effa-08df43ef9a1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|10067099003|5023799004|4143699003|56012099006|261021135927099003|261022105027099003|261026140227099003|261026121527099003|261021121427099003|261022075727099003|261102123227099003|261028144727099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	AHJueKg3zlZXsei1W/PzCTxRFm0PfcX5K+p3amgfJ/Qnv26F9C3ehWIVwVmZFaujFEaI2AayiZh/k0WLXP3D0UgqCqcTrYs1LqzXTTgTmZJ7Z+7d4YD/ij0V+s+JU7x0mR8n0A/KjubvvomJgGEABZ2u5S2x3rxqpNs/AFzfkiDpuSs///2bk/6zCtgSOiSkVXmqlLm0g0LHOR9mvWfI6ArTM8JKIa8W/1KL0uYCqpyMLPt03akeGzQqjAPpFbdG/rCjzEFM3e0+Y7OQ04fTqVaWPigkrs7326Bwu2a6xVu6Pyff+bLzNuBzgNArGXigHlrcng6za0ZDREj0SdnKljV3lRfQN0/HfoaEvS1x2LRf5Z6jlseE0wkxeWgGkTYQc7I+mrHTPxt39WskEpIUTUYITucTcOvBoxGmcH7zhP8Fn/YiiWWhAh7+gIH89+mMv2gz9OYLgSubQ9DKBViBjvUMvJgS6VATFUmqswvU5JuXeLaLTMZ/NBKhYjC1YfTBstsHwYHM94S4wJbLK38u7pNG4uI5U1BnA/cfbN/zKZRgEnfErMHj2L4ty4fIpPw9PGg3sB25q5ylBlKzJD4Iwn9dK0jMPNBvTWov1+9ecW59rNpvxt8ukpcafg7oQcxIBStUYkCO1Wf1QuybUCodmok+oxP63t4veMr1aHwPnRs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(10067099003)(5023799004)(4143699003)(56012099006)(261021135927099003)(261022105027099003)(261026140227099003)(261026121527099003)(261021121427099003)(261022075727099003)(261102123227099003)(261028144727099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZjlWcmlNN3ZVb2dQOFhMU3ZnYmtualhaNUt4eDIzbGw0MUN6N0pPYTB2Y0Y2?=
 =?utf-8?B?REtoR0xSWjF1eTJKN3VhdXFXRGlWZEFaSlpYdWtLeTdWTHo4bzE5ejJXR3NW?=
 =?utf-8?B?cS8rWGZIMXFnaU1WOHJrU2ZGZDlxaTR6dG5rZ3J3eUhuTnMrOFZEbFk0TkxH?=
 =?utf-8?B?RDUyeFJobWhNTWdRbHp1RGw2UWdURTlFcmliN2VZK2EvMXZ2aVIzSGdHRWNX?=
 =?utf-8?B?bEhQcFkrWllZd2k1Sy9WRWhQQlF4dGFvSy9PazVrRzRRMGhkSDdNTkJyWEVL?=
 =?utf-8?B?VDR0a1JvQXZVbFZvOTJGaVhmdVNSQkFHMGxzanM2V3Z3Nk5KaEMxVFVOSkRX?=
 =?utf-8?B?WGdPOERkL1VmQS9VajFJcEtxVkJ0enkyKzNTdm1neS9mejNwY3ZZTzZkL3lP?=
 =?utf-8?B?bFpGWHBtWjBTZE5NbUtTdGlQYzJyZGN5MU9UakFaSy90cmpXVkdKaTdZVGE5?=
 =?utf-8?B?dUNFb2dPK2t6eXJwTFdqVWpNOXdFWE1qQloySlhOS3ZGa0g1eXVIZXB1NDFl?=
 =?utf-8?B?ZmlPeURCWWxPL0hsNzVVY1FGN3FFa21CQTJsTklZN0hIWkZWVEVUaFNsSmZW?=
 =?utf-8?B?b2RDSndTYUg5YTRMT01zalQrbmRMTHlNbmdhZFp6WG5Wd2Z6NWRnT0RwaU1G?=
 =?utf-8?B?dktzVUNoM3dteFRxRWcrV3RZRFNhS0NZdHowMk1XN2ZadnA2T2x6aUcwSWJN?=
 =?utf-8?B?dlV1ZmNGZnFhWG9VekdzN1p1TWZkS2xvL2xKcTI1a01tSm1YcllWWEg3M0p3?=
 =?utf-8?B?a1VGYVU1TzRHZ0FEYnJFWnFEMU9EL0tTZXpLbittMHJERmZNWEg1TDNuUmY2?=
 =?utf-8?B?WVpLOTE1OStOTUUzZlgxMk0wMU5STWcvL1QwN1ZUZEhNVytqOHdyL0tMa2Qx?=
 =?utf-8?B?VEdxMVU1VmUxTEFyVmFBNk1XL3dDbnR5SCsybmhOSDZ0YU5RcDN1WmRnSFlR?=
 =?utf-8?B?WVYycytEZDQ4VW9OaFBEQjJNWHREd2pyTURZZWtTWlR1S0pjRkpHa0IwT05P?=
 =?utf-8?B?QTBBSERYQUhDQWlHbDhwSmZ2NllLN05YVldKMmlUMlVvdktkTVRySWZjTjB5?=
 =?utf-8?B?MnprUkNyV0J4aEhkWDdUK0pDSDdtendiQVhkZXQweGdvaVdQdndjekVXR1R6?=
 =?utf-8?B?MUloTTdCbFVwVDBhTEU1VFFrYlA5UUFIM3MwbklTYk5icjJMNW9maEFNbFMz?=
 =?utf-8?B?YTFFZDJyYkJGTU42a3l0WUl3U0Z2bzAxTUo2bHlpSVZ3elQ4bjBqalUvUnEv?=
 =?utf-8?B?ZDVDaUVWeUh6Q1BXem5lTEtxazZKOXhaMStNUnEwUVdITEJHV3NMVE0yb3BL?=
 =?utf-8?B?eXd2MHlLL1FhVzhaOEdpWFg4NlIzSmVVMXdZcUIrZHhiZERpY0RhbUtXY2p5?=
 =?utf-8?B?Z0ZlMS91NGY3Smc0NWc3Y1lHSnpOT2dNMkNGbmhEZ1czeUpyOHZzOTNSZytu?=
 =?utf-8?B?Nkk4dnpzRkJWS2I2emIzcFh0WWhib0drcC9ST01ESVc4VGh6L200aE00MHU5?=
 =?utf-8?B?a2JObUhtNERQby85TDNsaHFzdnJ5dzkzSzlBMUc1T1RPSnN6NjYzUzY4dHpW?=
 =?utf-8?B?eUl3aG1mTzc4dVNCUTlLeGozTUdDTk5TbTdlVklLWUtueW1ITExtY1RaclJj?=
 =?utf-8?B?bW53ZU1iMVE5Sm9zYU1XdVNMTFpUNW9lUHA0bHZPV09wRTZYbS9VV25QSmVn?=
 =?utf-8?B?WXpnYTR0Tmd4S2JuNjdTYURPWXRTZFJoWGwrYTZlVmp1bnRoZWwvMkl1dG15?=
 =?utf-8?B?b25WeDlBMWlBd3VpYm91bXIwTFQ3NHdnU1lBR3kyQnVXWDRia3J2amVnYXJW?=
 =?utf-8?B?VGJqL2JYUUVZUnJNaTcreFE5dERLbW83djNVMzFqWUR4YUtSN1NRYVQ2cEdO?=
 =?utf-8?B?WHBjVTE3NXF5dEhZZmZCZ0hZaTFyZ2tXYWZmUG5kdWUyV0ppeVNxdDYxejI3?=
 =?utf-8?B?aFVTTTVFSGpNT1lqMHVYZloxM2NudEZPMlZQSjlCQThFLzVkRkZLWk1hQ2c3?=
 =?utf-8?B?d29BOUVRTUV4ZDcwSlFHVGxnRTJvSDFJOVpWOFVKQzE5SjhibkNPbTl6REtq?=
 =?utf-8?B?VlNWQjUwQnQwUEw3Y29VVFNpdlZKdmY2WGJrNlF0TGhsdllrZjlYWkR1bHdT?=
 =?utf-8?B?Z1hPYkwvMnd5NmgyZzk0aXBXSWNpZ3oxZ0NaWFRiNnhmTTVTbjh2eG15M0JS?=
 =?utf-8?B?N2dONHZlUk9HblBpWDdLbEI4WUhwcTFyY2c1Nis5bnRwSTRxaE85WCt6RVZp?=
 =?utf-8?B?dkR1M2dCa1F6Umg3RUpkT3I0OGdSdlEvS1hGNkhQUjFaa2E5dFhZOXlzWHpW?=
 =?utf-8?B?OVBzbGFZbytscmpJZXY0T2RCbTFjUUJkOW53SG9WL1ZrYnYxQTRjdz09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d329549-b645-4dac-effa-08df43ef9a1e
X-MS-Exchange-CrossTenant-AuthSource: LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 14:40:47.5868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UfPoetjicRaqC1hoj+RXU49LhpVUf9IWxS+hjajxJvUASfTQF41x7JWV5syIx+GaA8VocSMyXulpcyo3Sq7hUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO4P123MB6596
X-Rspamd-Queue-Id: BBF5E2000A
X-Rspam-User: 
X-Stat-Signature: 715wmfap7bdwu5pbiymrtqkjjdi4utme
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794840055-271882
X-HE-Meta: U2FsdGVkX18Mo7DCEptwkVIQNblezY0ef4wj/ogmy8BWtKkSsLXCcDP81OZe4mPDEJDNgehxWSfsl/J29gO7Err3Joy8FOnhR9aQAHURhJh4/UmRtuSRY2C6bnSrKBIaNYx4/7VdJM9/xdj6JcscxNyuX/tC9SclcX1COTlDrxFxINCVBekt1AF/ccKqD52Dqk0HA5vrPvYoZ5KUx3gYcn6yjfw4YlkGpWN9PSK5stQgloJhYFyr6GiAct38g3d3zcnK1007Emmv+2US7z7XzEEia/D7FaN38rvFuR5DQINnSP+RyrYtmmNwU0RmgDDGt/9kwKYSTEV/yk+mKctLx8kKnINte0KkyJpBJxa8GeVTzCd01nSwF1yJVJbm+k84O9yf0NVH8B8FfekLcn+2ZkSv/FFfjkxwFJXmLwU8RtF5Vdjr31xZSMf5PplX1cN+osFO3+5VXXL7yVfkBSF7Sl8QC5sHqCpQhcnyLSp1hxs5/sIPDGQAF2CG1qybFwDwejRNZgkzU+O5GiFx36dOhy8F+7j//Z/e4XOb54RbDwF+yzlPXuk3rYvYo9VLMciIRnTQgQ8bnECmMWOTorOY4qsdw2N6QHQfTGX/r4vE1zWUTQUEAqj6bqKGhluN0o7RBOosNi1r+JnLvenlYv6jmBvOk6rS9EG9ghas0jo6cEwB19rM6dtvp8zeNsBJu2E1fKEQRg4nWGgxlLLQSiaSyQimc9PoBjix3eTTNrmTbkGiKEyf+pjNglXsmEeX7C3fonQP40YAli6xHIgT4nVKW2GicOw5tkpGv4DIsp6kj5qoLdWQLNQ8qu8G5hZWXMlBKP8rWHLUAzjI4k4JqTx2OiJbLpkNdR/oqNR7sobn3gec5BQPo6tVrFUa2hQ0yeO6XxuYWvlazk6wlOPiuZeim8F01MczOs2t1sCA8E+i6KFxNBqKC4LrMnGeHWm8wvpom6QESpzZJG3xEUCBfVp
 06+LM4dq
 4v+3F2ZQJoSWcPqwq8JpfrUGzfIbeaacRWt3qtP+8e/Ffrz9PyISSjzrtr7heRCFuWoknt3P1vDMiEdxMD3ycftgUeU3+rTZl5xxmJSXv3ns7xvuDvbPogzP4EGUj4u1XbO/gqnvdBwBwmEIPJBgB8t+BatPJm5iZ020a5HVi/5l9y2gxzUE2W1JW5bwfpgCM1sSUX7DnI9kAORdilxqIzr++uuuGjWRZuYA/615W6zeYTIv+p/7tnUcGf1QVBSXs8QZcTnw3Yw9oetGJQG0qV8hWzpwUl4OnwMyj9/N8b+/WPK4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 11:28:01PM +0100, Thomas Gleixner wrote:
> > +++ b/kernel/time/timer_list.c
> > @@ -68,7 +68,15 @@ static void print_active_timers(struct seq_file *m, struct hrtimer_clock_base *b
> >  
> >  	touch_nmi_watchdog();
> >  
> > -	raw_spin_lock_irqsave(&base->cpu_base->lock, flags);
> > +	if (in_nmi() || oops_in_progress || panic_in_progress()) {
> > +		if ((!IS_ENABLED(CONFIG_SMP) && in_nmi()) ||
> > +		    !raw_spin_trylock_irqsave(&base->cpu_base->lock, flags)) {
> > +			SEQ_printf(m, "  [cpu_base lock contended]\n");
> > +			return;
> > +		}
> > +	} else {
> > +		raw_spin_lock_irqsave(&base->cpu_base->lock, flags);
> > +	}
> 
> TBH, that's horrible and unreadable gunk.
> 
> Clearly the approach of all of this is:
> 
>    1) Pick some existing code
>    2) Invoke it
>    3) Hope that it works
>    4) If not add bandaids to make it "work"
> 
> Seriously?
> 
> Each of the callers of sys_info() knows the exact context in which it is
> invoked, right?
> 
> So the obvious and clean solution is to hand exactly that context
> information into sys_info() and further down into the invoked
> functions so they can make informed decisions and eventually omit
> pointless information which is otherwise emitted in proc/sysrq-t.
> 
> Something like the uncompiled mockup below should give you an idea.

Hi Thomas,

Fair point. Probing global state ad hoc inside individual helpers is much
uglier than passing the caller's execution context explicitly. There are
only a handful of sys_info() call sites in the tree, each of which already
knows its exact context.

For the next iteration, I will introduce enum sysinfo_context, plumb it
through sys_info() down to the consumers, and refactor
kernel/time/timer_list.c around struct tlctx and lock_hrtimer_base() along
the lines of your mockup.

Kind regards,
-- 
Aaron Tomlin

