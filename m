Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A157BF357DA
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 10:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D369A6B00AF; Wed, 25 Feb 2026 05:20:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3256B00B2; Wed, 25 Feb 2026 05:20:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8BA66B00B6; Wed, 25 Feb 2026 05:20:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A54B66B00AF
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 05:20:19 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A34F6B9EAF
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:20:17 +0000 (UTC)
X-FDA: 84482584074.02.0FE0D56
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11020143.outbound.protection.outlook.com [52.101.69.143])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7C6E9A000C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:20:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=DNYIemqv;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.69.143 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772014814; a=rsa-sha256;
	cv=pass;
	b=YUr7vX/Wn6imj0j8E+MofagQd7etPp5i5BfaKNOCCDWdeG6JgqBhdYm48iJzhM+9YMT3zM
	s32ozaZSvD6AFiHMExB/jfwsd0QFDFq6uL/Lvf9TmbgqJQA3KpLq71dUJH7MRtpp9r7qj6
	byUZJ+SNzj/sfOrVzOc0P728gyHZAsI=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=DNYIemqv;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.69.143 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772014814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kp8UuoW01GFoR1QZ4+Zd9S/T7KW6QEoRSHA/AnVdU3E=;
	b=RP5ehxhEpne1/ZheuLTA4U4NRvMX/kGX+c4ZwDc5fekMrdW09xP3ZBN9j/lcUiqqhSEXXF
	WucVNxJIbiir3KJdgumdP9R0c5etVJOUooTnOoFlzV5yjQgrxN0S9kpJKszCvYvipwdL90
	Rmtdg22Stm2PkUNWeLsF/HKry9WQl0A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MKGwbxqVOMw5xwaZLbVNnNsmlbAOUwoYxeF9DN8h+uEdz0QAQNb94nuhWrV7UCiAmEQWvcuHwzDC82A12s6eEEgZ36jPx9qF3YalrzZ8o1XZCh1OepulHm7lfMR2gb8HDctIJaztxYYGBSB0W6gpX41jxkBKspTPpugaL2Yv2Kbsc8cfq0xENszuhvx4WlBtbmmgY9VLFFtMEJN+2G6is/s7w8Ad0kf87ENvVvGHlAR/HFS3aunf+23ucD04w+p+b6y1e/nW7fMWYe8rgoFysjVgD6gkxP4XOgUzfkXrS3Clte8jtuvWg/9f2gntun2hIYFowZE8YW/iqH42xwwVaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kp8UuoW01GFoR1QZ4+Zd9S/T7KW6QEoRSHA/AnVdU3E=;
 b=BYAIrNCAQ0tGnmFWKer6IReyPAL/rHjREd4AuTaf9UAggun3HixSRRWpeX33YyiaOcJuB6d268FFSaGa9IUdpHgBbhZCplPQLfKIIYO05TVT8QofvAB70KDYOYTkhc0709QsPxHukUjEptig8zAcTSB+TKVskOoIO3MQtgSpY6QUQeduZ+cLv0Eqy5eoTZ+lltU8EfbkYKuWAj8F1u1JrSkAykYlpGSVS8pnQdlhN+eHnsoeoSqfajNyI6kx34/pXNs7IozWYSDHd8k4A9+up3U+vWyPN97MEA9bulNgZ2SG9GjgSHIf3giw3TUwwtpNJpSp3viLVYox8MNgtyp57g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kp8UuoW01GFoR1QZ4+Zd9S/T7KW6QEoRSHA/AnVdU3E=;
 b=DNYIemqvM5zPqRhKQj0uOWpjFRorwDzJwgFFXajUYhR4bKnDshAN2RWt5qOwN359Kot/0sX9iycI7su0n8Mssc/NCn4Z6El/PGpYiHJ/SlLZY2CMgz77Euu4sbkM27eUBem+HrlajeakQJdKBFEprlXtBC6b5UFejNMjrOyHXRRdXx+0z3p2yE0/AvIJyuA8BWRhI5LcfjXYvAyAyYuZY9bMAcEuQp0LiTPT7H1S0NqkmGSW7sC8eqY/9djutkHr2JmJVuUUUOSqn+XrM71AVKapwEd8/GIzY00CpG3cMBtaXtwX38dpYMR2Sa5gx605kfaVdx2sAn9Lh6zvUdALzQ==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by AS8PR08MB6421.eurprd08.prod.outlook.com (2603:10a6:20b:31c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 10:20:05 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 10:20:05 +0000
Message-ID: <6269de34-203d-47b5-922b-342671573b7f@virtuozzo.com>
Date: Wed, 25 Feb 2026 11:20:02 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] pid: check init is created first after idr alloc
To: Oleg Nesterov <oleg@redhat.com>, Andrei Vagin <avagin@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Jan Kara <jack@suse.cz>,
 Aleksa Sarai <cyphar@cyphar.com>, Andrei Vagin <avagin@google.com>,
 Kirill Tkhai <tkhai@ya.ru>, Alexander Mikhalitsyn <alexander@mihalicyn.com>,
 Adrian Reber <areber@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260224164852.306583-1-ptikhomirov@virtuozzo.com>
 <20260224164852.306583-3-ptikhomirov@virtuozzo.com>
 <CANaxB-znXjfh5s9ro127TGONsu6PieuaJ1vB3PMVFeV4Eo8pkQ@mail.gmail.com>
 <aZ67mwBEbRtdaWp2@redhat.com>
Content-Language: en-US
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
In-Reply-To: <aZ67mwBEbRtdaWp2@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0235.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8c::10) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|AS8PR08MB6421:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dae5041-50ba-4a24-64c9-08de74577187
X-LD-Processed: 0bc7f26d-0264-416e-a6fc-8352af79c58f,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	CICxItfC3DO3VpqXj/TDmcY7rqNEt4tpQyxeSfEB6y8rlfQeuGOiku2hVSEX6FeQcSxtNuBmd+55ToNPkWqof2CYw52qPQDlsGWr/+z23olm3P2UbM5jfRAX9cPHx5wMVsOsxx6ENjB6tcd1F3T/h1vYbrUOqumL+MObJ6hsarZ1e/ocB9xTMexuAb+Q1BliK8pQk05WSiyj2UBpd2mmAL2g2PL3O9hs3oJwHseFVRVNDpzEdhRKKJJZ08Q4B8Kb4lDnZy5hHcCjWW8yZF7mve+t1BUKp7q+ZMpRUYVsScLw/RWMNdN9dUYv3OjuLHP9imlRvispEpP4Nl8nhfOH3SsSCPNu1IoITpBgxaLJt6UBNBIdi1cYwsJxlJ8H8uST4DIBmR8szz9h7jBaEA604pK/+3K5Nrd5rEoTZ9EiKzBA4DTah3jSaKLVe/LjFZW7XBQ8LBqcKvLbncK+9MIxDAK3x0nyrw+Sin+gKa2ujytsXLbdt0rHENGdqufZPesFi36yK68upA1axgn+vaJ3gHW9HYCtyPME3Dy5X4oIi2tTHhJ+ClRBWwLHKZ1al6HmgLS6r6gNld89z9zfKtn2jztJ9QLNmQWzBANXXih3gjOSXSnTMhogCs0hWZcRvWn2zW0B214V/pn3APxZmonwYq2VD6f0BsMbHkbyZmCKbuQvfeauhQiTC61h42VC7p5ETiOGyC8SDP0vzcu8GxEdn6SnDpmR3VbC8fh+HGDRdCY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(10070799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V3lmQU1VV2J2TWxJSVlxc1Z0YjlSb3oxZS9ReGNycmZwUEx4dmpBRy8zdmdD?=
 =?utf-8?B?RXR0dlE1WXlUMS9oenRoRzUweDF3U3dickIyYld0RkVnQWZxVXFjY3djUWR4?=
 =?utf-8?B?UjdGbmY2dVl5RHgxUHh1TE5WUnJlbDg1bzJsZVVMSXRiUU5lb0hIaWdsYzI4?=
 =?utf-8?B?eVo5cTg0TWNOUm1wQVRlU21kQm95R3FFNk5iSFhLMnY5TVYzd0QzOTdBOFcr?=
 =?utf-8?B?MHZEUDdBN0tCNjJGR2JBYXVsaWtHYUlKTGhJMjQ4U0RsOENKYVp1d2Y4VXFL?=
 =?utf-8?B?SnR1OXVyUW00WFcyYUxmL1RmV0l2UGh3dll1Qy84bzIvS2dWanBPUThGT3Z4?=
 =?utf-8?B?cVZjdk8ycWl6eFEzUEZOVG5jbGZhTWdSUThFSEhTR2RYdTJoRzMvRHo2ZUkr?=
 =?utf-8?B?TEFscnpZeEtvMFlkVmJRR1RTYlBUczhaL2pkUmZkOVJMMEoxS1QvcThlTnY4?=
 =?utf-8?B?S0JZVm1mMndUM3gyaWc3eHY1d0lHbHh4WGlDSjFUeUhZUVNUemRhcnYyMjlK?=
 =?utf-8?B?VlBKdkpKcGtsalVvOTZyZVJvcE9TQkF6MVBLamU5L25HY0paNXdSRzMxcmF1?=
 =?utf-8?B?RlcwOHVpS1dSclJpTS9yaVdhNkQvcVZ3Y1JtMzVEclVuMHozUWV5US81N0RQ?=
 =?utf-8?B?eFAzT3N0RmlFV1B4RXlBZmRjNVFTaHYwVXhqWktLSDVhdU45QnpDdWlMb1M0?=
 =?utf-8?B?WWhLN0U0Q20vVGdhdS96OWRYMEkydlhybDBGT1lBczhWWlRaN0I4Z0RMd2tz?=
 =?utf-8?B?K2phdG9hR0lkUSs2QUVFSWZxa1MxQ2NFeEw1OU1taWhYK05ZOENQb3FOejJU?=
 =?utf-8?B?Q3d0dHlwaWRncHF6ZGx0Z0JKVlp6NE50Z0Q3Mk9GMmtUZ3M4N1pqaFlDMEFm?=
 =?utf-8?B?eXh5VlI4Vm1nZDlGYnh6bTBRdDFrdGZqdG11SlZtb1NxVGFDb0p4VU1IWVlG?=
 =?utf-8?B?dTBGTlVIN0p0bDk4WVFJN2pqY0tYRnRyQ2dySEwvSCswbXBkdnJwQnRwMTRX?=
 =?utf-8?B?UlhVc2t0ZisvcmtJbGZGOU9oakwvOGxVeldMZXJUbC81a1B6WlhFRmk3NE9B?=
 =?utf-8?B?RmpSMVhmYWZqRy8rZW1oYnJuQ2RYTWJsOGdzZCs3THZSNStOeWZPMzVRUCtX?=
 =?utf-8?B?cWZlbDdwWk94WnZVL1dueGdKRmVhaVpSMXdQM3Uwc2dlVm10SnViU0JHR2s1?=
 =?utf-8?B?Y3dsNlV1NklqNVlvTEliYmdMZDk1dlp6L3NnM3VTUWlxRmdETjRJTGVZNHhs?=
 =?utf-8?B?ZTlaVmdwQXVqMlJIb002SWtKcFk2WTZWaXBIUVpPdDQ3WllLd0Y5QXloKzJK?=
 =?utf-8?B?RmtLekdvcGwyOXpDUHd0QlRjUzFobUpEK0ovcXlOUGpMdGhmYktTSSt5bnRh?=
 =?utf-8?B?SGtqY0J0TUVFM0Y4K1lmYXA2NnBDMlMzNnNDZDhuTUZMdFJEVW96bWVtSVFv?=
 =?utf-8?B?Z3dUWm1ENHNLZFZySmNkUjFzaDVkN0JQWlZ3ays4Q3NMb01hRDJVY0RNK0ts?=
 =?utf-8?B?RkNOUDNWOTRmaEUrbnVhYUtJcjVLY2lzT1VzWjJPbUZ1ZkJYOWE2MHBMcnBY?=
 =?utf-8?B?STh2YUVSVHdLRkFxQ2hoYlgxbXVuUjJZVnNYKzVuYk8xUWRhR0xFejNPOTdC?=
 =?utf-8?B?WHl2OUhkSDJrMnZJUUo3TDludTFXVmJRWnlscFpxMVAzNWhaMDBjWlpSWmZN?=
 =?utf-8?B?c2piK2pXdUVKTTByTEoxL2JJK0V5dTltSGZ2a09ETUEyRzY5R0lMNUNrd0h3?=
 =?utf-8?B?bGVtaHA1Zkp1RFQ0ZDRxUlpPVjFHM09HckZhMUxCa3lwc21VbTdHT2RTZ0FM?=
 =?utf-8?B?SXh3cG5EWTV4LzdDaWNxTjhwMlN2Z0h5L2RiaHB6YTQwM2NNZURkNW40Z0g2?=
 =?utf-8?B?VCt6M3hvOWpWZDZPTWp5MDQvRElxUzNMajBCVEhYZFJJcFRSYlN0SWVNYnFW?=
 =?utf-8?B?aDhuMmw0aGdlMVBmMjN4bko1ZmhJL0lleFZSd1JudlJ2ZTdxU3JZZlY5OE43?=
 =?utf-8?B?bVR0MmJQWVZuUXMzTFhTWGtkWUJvamRNMVNIcUExRWxpUlB4QytFVnJwdXRY?=
 =?utf-8?B?NVFrN1p2WUcxTU1NWVZ2LzNCcUhJcHZrNHF3VFJ0T3dKOWtrem1OL2FNUmhL?=
 =?utf-8?B?emRGNFNubisyUHVRUkllR1NHaC8yUjJ0Q3NvL01oWXMrMTI4WkxEOVNjMDZJ?=
 =?utf-8?B?Z0tyeDNSTVF5cXJwYXNMOWwzVGhoWm1rcE5ZSlBmQWl0T3U3Q2dna3Z0cmlo?=
 =?utf-8?B?NmVkWlQzTGdneEZnbHRXcWhyM1UyeXdFaWpXSkV6eG11MTVjelVVeDNQcEo0?=
 =?utf-8?B?Vk1LUHB2Sk4ybFpTdWJidzJibHV2VzNYL1Y0YURHTXZSZS9pL3prZWpUQW56?=
 =?utf-8?Q?du44PaSumeW2Bo3qhhReBDK+rL50JDRKqVqZlEKp3kfdw?=
X-MS-Exchange-AntiSpam-MessageData-1: iKpstG3OeDshoPpraEsCvsL+mfodrfCLE+M=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dae5041-50ba-4a24-64c9-08de74577187
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 10:20:05.0340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +VNzw1GltW6sV5Mt+F/YzvZJwjyK2CevVGxfU+B7unkI5MYV/nvclOGwgm9hqF6TSU+yEihoFNXUCQvsGN9+lIg8roFHwbeQW67qUqQLsms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6421
X-Stat-Signature: bqo6erk5fkdjkic4teati7zjtndf6zyf
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7C6E9A000C
X-HE-Tag: 1772014814-637928
X-HE-Meta: U2FsdGVkX1+PB2ATJFrMdEEUSjTLBcS6B8oDTmMYWF4tsTz+gcHUVWpmJBSPsQvobSgY3BSIz01fllKKbqgip3Y2BYHl++ZCNTkvBs1TajOwYkOIFxFa6TmBHqLkZjmIByA2j2UbcFn93dWqur5sk7mq7vx2Y9I0P2B0MwyyHZ5nL6YPTjrB4V6qPxYYmfnGzsPyPLANAdKh/6JqDgyC2jIlnDSBma5klkrHSg6diVTyMXXmsM33fQZNieAImjEuqfm0bjLPfIszPjjPkEyy4NzcQ2ixqBAIgoBcyZmKYPyGr/wmc0TDcvHDuxLM0TkFO57QETH01DQinji2NBfYInc+WJpsI9keYdtL+ZbI5KnXjl56fQI1bHQh/zgLsBvW7847arPJyjztjLx6Yr3POX031HdngckGeR3CFzVJ3yZTUtdzWyXMk7DOVRKBJaP2YY7vdOlcdMHYY9yPbRzeF07XxebB5bGJB70V74z/Ff2F3CaAKEGcJAGYfALGrdSfygf+wKHPdPCL8d8UW4ToQ4QFUCxWJZzBvduHcJOrK1TH8oFFqwN+GWj7Xu5USrJ1yMXdhdiFVI6tbBoAkkKRGTQCAZz+o9fSLS8SqbbqIWDHELmC9bubJQY43iM6xl+LsrtMmUDDCmH/flBSbkqqkchb7rPGfhVJg3Qngl9+sr+MDyFUFDhstS1RX94ulBdmp9h6y+l3cCSR6Og+Ai9uvlOK6BFL5dluRWJ0h8w5DtxPb7Vw/Zc5idzMl1UL864BaXtaYi7Tq0b1yda8BJP/q+a2pH3bQB6HCAz/1KUJsXlmw3A0JX/+31/4UH4u2o3q4Il/QOtdFYFsOyuBg5gxR8uWn8mmJ0b8jQIN0gG1nVLf2haV+dG217lrsjdkCXn6J2ns7hRIO5SOV8bDIl05lyqoHmC+tIut6sSeOOtpVM0lQ3INP1Zr7dIFyxy4mz2ecogwRJZebf248cvMuEQ
 4PE/mnlv
 7eZy7FeIMOMlhQSems02iRYZArRCMlEmMbecRSDZOs1y5T/v0vEGCbDH1Cpqs1ajIxKwWRztcb2UGE0f19aYJceMUqfo8mQIYwfSeVMuRealVlRIF+/h6KsmRImwJY13GFzfiwrB+FqRMnoY1u1AME7w2UdNdM6yMsiN+9f5ACPeLLsO7oJsLtPUfVlw5o7b/DIjLE6t7tDMpi1sWTIPugy+LF7Ijv+4bJezXeztsJ9HZ0TsHZicR7/5sn2TW0ijfAHz4T5OHO5xQP+49MWCte4EU2/POb6s09p6v8Cycl6MxWIeTemeXOE1ie6w016ES8EH2l5LUkeppBTCFJ71qHNINxvFL6BRXBHy8yX1wvdwdIIF+TJCUU7YhbEYjlV46/m0Ynqb2pKiqtYkAxHc+MawQo5yjjcHlbKKZWo+1mNN28lznxaMnfuag7HF6teYF97NK2oBWykuqYfZDKWE0pOlQ+p9fYWoD8VP36oirlZ/HytUi6knpzd0iBPgn46Bq/Kav
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/25/26 10:06, Oleg Nesterov wrote:
> On 02/24, Andrei Vagin wrote:
>>
>> On Tue, Feb 24, 2026 at 9:02 AM Pavel Tikhomirov
>> <ptikhomirov@virtuozzo.com> wrote:
>>>
>>> This moves the condition (tid != 1 && !tmp->child_reaper) to after idr
>>> alloc, so it not only covers that first process in pid namespace has pid
>>> 1 in case of clone3(set_tid) requesting wrong pid, but also if idr
>>> itself gives wrong pid for some reason.
>>>
>>> This could've been the case before this patch, when creating first
>>> process the alloc_pid()->pidfs_add_pid() code path fails, so that the
>>> idr->idr_next is non zero anymore and next process calling to
>>> alloc_pid(), will get 2 as a pid from idr_alloc_cyclic(). Effectively
>>> leading to init-less pid namespace, which is a bug.
>>
>> I don't think this is an issue right now, as we only allow one attempt
>> to create the init. If that first attempt fails, free_pid will disable
>> further PID allocations in the target namespace.
> 
> Thanks, you are right!

I guess it means that we should change the commit message a bit, e.g.: replace
"Effectively leading ..." to "Though thanks to PIDNS_ADDING logic, free_pid()
disables further pid allocation in this case and it does not lead to any real 
problem.".

Please advise if I should resend the whole series (v4) for that?

> 
>> This isn't directly related to this patch, but why do we check
>> "ns->pid_allocated & PIDNS_ADDING" after allocating all pids?  Wouldn't
>> it be more reasonable to do that right after taking the pidmap_lock?
> 
> Perhaps, but alloc_pid() can drop pidmap_lock and retry, so we will
> need to re-check PIDNS_ADDING.

Maybe it was this way to consolidate the (->pid_allocated & PIDNS_ADDING)
check and the (->pid_allocated++) change in one place for readability.
Code reads like: we don't want the increment if the flag is unset.

> 
> Oleg.
> 

-- 
Best regards, Pavel Tikhomirov
Senior Software Developer, Virtuozzo.


