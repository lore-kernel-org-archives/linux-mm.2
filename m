Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1A87D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 14:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6F706B0022; Mon,  1 Dec 2025 09:48:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47666B0024; Mon,  1 Dec 2025 09:48:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0EDD6B0027; Mon,  1 Dec 2025 09:48:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9A2776B0022
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:48:07 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9287D57A86
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 14:48:05 +0000 (UTC)
X-FDA: 84171182130.01.6ED4025
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021121.outbound.protection.outlook.com [40.107.192.121])
	by imf30.hostedemail.com (Postfix) with ESMTP id B18788000B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 14:48:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=B+Tszxny;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.121 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764600482; a=rsa-sha256;
	cv=pass;
	b=IXiOS3a3c7+juPAAgKpimABPwQTW//rylzBFXBS+T9P+OCxk4/Id1XZMqWrWPXMIw9bH+1
	PYMDIgeqgRrt3tSgaym3ApMF4TYsAE5clwpd5RijIktQ0r8qdgYdNiGFVKk7Z4onx6NlZN
	q7c6lqMOop+zWKJBQeyBEDj3zRTzXV0=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=B+Tszxny;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.192.121 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764600482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hlBkkpKg0qZqPMipUAWmpaH0vFsy4NUE/aWCrqMna1w=;
	b=Z9DU81B0eatiynm0op/YrZWL7sivC6yMTvz+fkYf8JG2+WUca/Ifc9u5NH5gW5ZKRzt9GD
	5GWlgRzByq3t9SeAuDXnCLT49kPIW8e2EwKrPNouueB4pvwUNSwPRbL7Tp53UZ7pwx0Gq5
	hIZQAW8ciPwH9pnGQZd1F4AfBP5SfUo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ChEywuxJsJp7AQfz8AhZG4JXtE/aksDYTejE8UF3oxnLGEf/vK+YNn4oztLFFCstQohOOA/f2P4VkMDjCQmmi88hqsV8WW45cAf/oMktORbwMBxOGRtlII47JsiR9OoW6MxWQWOY6u7a86D0j2bQCMa/+lBjODueBVeeeZitzbhYM6GINFBMMhD8o6/9ZLbJMFxRrJkGlRCzCQdhzNts+4wUyRGRV2iYXRtcKMGH+T/G4TZKokR2cOfbGlxpgShwtVtHqvDGRilCvWs39dJRuidPVI22KKBwFPNmc7bvX0YxNRjrIEpO2HuswCOHbjxBW1n/mf3r3yJpkUtHTjsbig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hlBkkpKg0qZqPMipUAWmpaH0vFsy4NUE/aWCrqMna1w=;
 b=SXHXmdCFH2wQc8evBPcbQ3m254TPPrcclcQteezv9SqKVj7ev0BzjDYGDiBMoyXiTD3vp0Pu31QX/crROhraK0cH1605mv2pzywhkrHfQUojOE1dzmVGkLHm1F3p7VT+pz6Ak/TD76aEfNGRlLhrgW4IZuGXgKnkeCCg2xTwfvSOmfcoIvy/picdreUKdTWvZX9hJHYo1bdF+Dkr01QPR/1/Fr2Y7qypCk2uPN6s2ArcSTlJW5Oc13kTJhPlEOCruafVy4ods1RSDb+Z6LKK9tS+SqvZdj/l5mIMhoWCTQj5CsZW0pXuK5I+bg9y5SPTGrnGr9g39x6gUkaEpx6cuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hlBkkpKg0qZqPMipUAWmpaH0vFsy4NUE/aWCrqMna1w=;
 b=B+Tszxny2HMygiSPqKAW+LfBQAXgd2QUOxONZx27m9Zg9Gkp+rFNI8pAAiGn7tkatN5xTSyeQT8BnAvsFJ/uhB0tHFtAOzC42dP6aPiJSU9d6yMy2xitn3ODJFzgTdRYi4n6hkSIoIgx/sD1+eIT7uls1EUZjTdirvEte6ruuEtkpsVxfqB4mCVLLHabWFbtexH2mMyvTIA5dGdlLDsuwCrmUKcyODKb7zqAd4jNAi9wORFwsYHNEHm71aiKtdzIn41axSo9hajpGu4eCm+MR+VvsaEXRQrLR71U54TuMgjurkTUa7RwLrTgDWR5AB7C6bQ9WXhN5diHd7BrDuI66w==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT1PPF377CB8326.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b08::525) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 14:47:59 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::50f1:2e3f:a5dd:5b4]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::50f1:2e3f:a5dd:5b4%2]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 14:47:58 +0000
Message-ID: <355143c9-78c7-4da1-9033-5ae6fa50efad@efficios.com>
Date: Mon, 1 Dec 2025 09:47:57 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] Optimize rss_stat initialization/teardown for
 single-threaded tasks
To: Mateusz Guzik <mjguzik@gmail.com>, Harry Yoo <harry.yoo@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Gabriel Krisman Bertazi <krisman@suse.de>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>
References: <20251127233635.4170047-1-krisman@suse.de>
 <f1a1b7ba-c084-4e41-9242-8255f2664b76@efficios.com>
 <yvghqmbugs3oejsvbh5rrw76rvtr2wfwqysjd7tw67z4tzpdbp@6zehhuzumiez>
 <CAGudoHEyX1gdwG_MVf-M2KMHBE1Juo6VbfSyp3rbXoS+5JaNtw@mail.gmail.com>
 <aS1wPxSdd-WcU__K@hyeyoo>
 <CAGudoHHeqvtK83ub1FPuc4JYk4XMxPM+Es=Pp3V0Zq-EKGBs5A@mail.gmail.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <CAGudoHHeqvtK83ub1FPuc4JYk4XMxPM+Es=Pp3V0Zq-EKGBs5A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YQBPR0101CA0183.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::26) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT1PPF377CB8326:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a5e1ef7-8698-4d46-edf1-08de30e89ebc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Wjk3MzdKb1JLNzFIQ0VBaFBDMHVZRmNoQ1Y0U0tQdVhGanNKVUMzNzFuVDlG?=
 =?utf-8?B?QmhYcnRHZ0hzK0VIczZ4N3kxdDZmNmRPV29yWjNUZmJwWjl1SFRhcGVZUEx1?=
 =?utf-8?B?UCtxOEtlTlc3Ykl4YmdLYWFOaFdYQXF2OXk0TUhIa3RhdlU0c2NabTcySzQw?=
 =?utf-8?B?eDk1WTR4RGEvaThWdjNVM3pJRE0wbjRRU2tYb3JVd0ovK2VjSExMalVxcGZV?=
 =?utf-8?B?eWl4V2ptSXZyd0tVYXRhaXozUkpaMmlJVFFncHZkMUNXV1RnTHB4d0J3bGFu?=
 =?utf-8?B?OGZuMkEzZ1A0eC9mTHM0Yy9pSXFtL0NlZDhSeUEvYk9OQXRwVml5bCtXYjFQ?=
 =?utf-8?B?eHd4VUxHWkc0MXNNMmhyVUJRRXA3OStab0NnaVdOTU4zaHBNdGR3c21aRzF0?=
 =?utf-8?B?bnFxajhRSTdmMUczb0ZQQmFLR2tQNHFlT3p4SEpuWDFBQ2N3OVRFSVBwZ1dD?=
 =?utf-8?B?aXJUY1B4UnYwM1FKczRZMW0ySnJ5R0g2MVVIaFZiMkwxMzk2MEJSaFVaZTJC?=
 =?utf-8?B?a0M0Q0Y5UUFGOFgxUU90U2s5b1V5TnZmcHk4UHM4MkwrVUJEUkFGYnRDQ0Ja?=
 =?utf-8?B?bnJob3FHY0ZQT0pValJkdUV4bERCVzZUN1lNL2lOa0lxcFB3eGFFbGQvaW9S?=
 =?utf-8?B?Z25PWVpTTCtyTUFVZFQ1MWtrWGo4U1lnQmJIbzN3amQ2cGFhclpuNkV0S1Y4?=
 =?utf-8?B?bENNV2c3VDBqNzAvMGtORFVzY2pVTmowS05oUWlPdFpNTFEyOFpZOG5Sdlkv?=
 =?utf-8?B?SmlKUzZvZlpJT1BNa0ZjY0RHTE5uNHlZOXJ5U3gvZSt5TkhBMUF2ZW4yaGhL?=
 =?utf-8?B?Wkp0OHJHR0pYS2NVdzg5cVJXaXFyb2xMeXFDVU5jZ0cvRUgxMm40dnpPYk5P?=
 =?utf-8?B?WHlGQ1FYQkhqMnhTS0lkT21xaCtDZ0JMUGppTTJ6LzJiQ2JoOSs3QmRLVUdz?=
 =?utf-8?B?UGlVbW9HNEd1VUtyeHVwakUvOXZZOERVc1N1bzZMT3h5KysraVZ3blJtbFB3?=
 =?utf-8?B?RnBsUURhNm4zeFhhS1B0cE5ZODIwRzhwcjcwSXV3Z0NEQ05VbGg3eUt2T2Rm?=
 =?utf-8?B?RXpRenpla2tTS01NVUc0T0ZEV0xzQkdnakJlYVZOZDBqVzdFTjVQejlOcVhn?=
 =?utf-8?B?eEw4U1J2em9ZU2NvaWtTRlR2ckJ6UUtWS2trcmRTRGhURzZpOG0rZStaVlNU?=
 =?utf-8?B?Y3h2b3dxVEVDT0d1SUtjSnV2ellFc2t4M2RvY1IvTGxFUDVpUW1HRmpqN0JF?=
 =?utf-8?B?S1ptSE1OS1FDZW9QZVRwVWhPUDRwMktOVnlxK1RBc280MlBueVNmaUt6bTVK?=
 =?utf-8?B?aE1kTjA1Qk44OFlrSFNCZDZoTFZsejJzbGIvRzluOTFLK0FiZHNDN0UrOERs?=
 =?utf-8?B?YUMraUpacWFYc3NVZzFZSkUvZlZYbUxDNSt6M1hCdEhCNWpkM3ZDOWp0ZGNz?=
 =?utf-8?B?V1ExeXJ1U2VyNmVBSExVd2RoZFhFS3QrZEtKeFFSZnAwb2E4TE5tQVNpSWFW?=
 =?utf-8?B?ZDhaYnJIbENwdml1bm9HejRNWk5kdlRYbmtyaEs4LzlIZDZYbTVzSEdIQ0VP?=
 =?utf-8?B?cDVTU2I5emhzVTdIMGxHdnhkVUxhSSthaGI1eU5BYXpmc2wwbUVUZ0JRMGd1?=
 =?utf-8?B?WVNqckp0U2tVVUJocU5TOGNCU2ZwVXhWQ0R0YlpxMXU0ckljU0FxczFtd2ti?=
 =?utf-8?B?TC95VjNwUjh4aVI3OHhDNURJTHYxUlNUS2h1bnFxY0crRlpPaXpNSk1BNHhQ?=
 =?utf-8?B?SmJHQWw2THk0Y2o4NEdPdVV4WFJoU3B5UFllRXJaUlVIUU5jalJMc1NHNm9P?=
 =?utf-8?B?aG16V0gvNEVPYlIvSGJwZTdGWlVSQyswTTFaQTFSSXU0R3p6VDJMbmErVFpE?=
 =?utf-8?B?WkxiVytFNzQwN3JORDJjWUVrM2NUQTlnSlhVTndhekIzZ1E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXppWitUMy9YQ0k2K3orSWxxNDd2dk0vQkJFU2RvczNQb0NkSkZVVTFZNENY?=
 =?utf-8?B?bEFYQStnc2N6MEFRdkVnN0pCcktrWU45bEVCV2hoNWJESGZaa2hsQ214YnhC?=
 =?utf-8?B?U2hrNy9WNEhvT3NoQy93SHl6MEZOaklXMHI0ZlhJU3hKbHI4eHNVTHNYYUVX?=
 =?utf-8?B?M3lpMjhZZTI3aTkrZmJDZzBEalZZMUdKZG5IWFBHT0l2c3JKam1HazFXRHJO?=
 =?utf-8?B?eWdFbmFJLzQ3MThrcnV2VjVGS2doMFBPV2wrcUhKcUZSZmQ2SXBYZ0FSUVI2?=
 =?utf-8?B?d2lPVFA3YTA1NGlQdUd2cVhvS1pTbTlDMlRSeU9EckNrdlhFdWc1VVNXVkda?=
 =?utf-8?B?YnFVZktydTE0T2ZMN3phZkcwY0JBNXZUVXQ4YVJybmkzL0F0b2VxT2gvOUM4?=
 =?utf-8?B?WjYydnp4QktaZW1FYjRQeHJCd05PdGN1ZlJWa3pxZzJIeHQrKzFCMk5KSzZv?=
 =?utf-8?B?V1MzQkVIVHB4dmNPVFhpVjFzM2JtbThGdkF2dkZyN202Y2pwU1JKZ2k5eWRn?=
 =?utf-8?B?RWk1TkNUZnR4NkVuVUZ6OXAwR3VFYkNvTUdsb2Y0U0hhM0lQbFkrNk9ud3pH?=
 =?utf-8?B?TnlDNEtYNlFnVDkvelRqOFlIbXFXbDY3eXB1cU1nVFl6ZUhEU1YvNEZEZkR6?=
 =?utf-8?B?ajM1K3ZlQTBBQnhUN2J0UnlaVDRUUGpZL0RqRyt2bUlDaTFTekZWSXpBaGNQ?=
 =?utf-8?B?bms5Nlo5M21FOUNTQlNJc0g5dnBlSEJWcmQ0TGo5SUhqM1ZZdlNveUtoY1VH?=
 =?utf-8?B?VmVxQTllZVhaVStRWHdDMUFtWEsveDlMbklHL2tjaDVaVndZMU9oQzQvZFNr?=
 =?utf-8?B?V2lwOFdESjJUM050R1YwUUF1Slp3Vll2R3RaazB3VmxTUFZTcHdETmpaRHlm?=
 =?utf-8?B?YmFzMWdyQUQ5WmEvSmxFenlRbGdFV3BZYWNFNU10dGNQTVpSQ1dhalN2YmhC?=
 =?utf-8?B?YW5QTndXRmYrbm5JOXlKMEk4VGpHMVM1SWdweWlNQ2V6d0d3N0dKUkxnUUJ4?=
 =?utf-8?B?QU5rb1BsYUNpTnpEUG13NThmS3hiODA2QytPV3F6cXNsaVFVcW9hL2RLRGRN?=
 =?utf-8?B?LzJkSDJQUlRIUm01V3M2eFlWR2lycVVrRkgzeVN4YkVHQ2lwdkx6Rlk5K2NT?=
 =?utf-8?B?TjlJUDhrTHgwUE91RDFSNlZZT0NBVUd2OVc0TkJBYVc1SmtzZ1F5cGpxV2R5?=
 =?utf-8?B?TENkOEYrVXdrUU10WGdvTGNWRVBFRXFNZWZRTWo0MDI3OW1NTVdyZW9wa0RO?=
 =?utf-8?B?bHJzMnNSVit0Tm9pL09Yd0ZRVG1nKzI0Z01FTkdHdEFMZjJFcjlzWjB0VnFm?=
 =?utf-8?B?eWVkVXlST3gxRnBiQm5YclVDcTdvNysweDFPREFQUkVOT01QS0JRd0VMekVM?=
 =?utf-8?B?UjFZaEo4TzMzN080QlFPVlpVeE9HN2xZeU9RRjZ1aUNDYzIxNllhVVFTMHUy?=
 =?utf-8?B?bU9leVNHa3dYUis3ejhlSk5nMzlLTk0xbXZGc2pjbjkvbURmUUo1SUVGTWpL?=
 =?utf-8?B?cVF3cGdyVm5LTGNUVU9BZEkweERlUUNPdmhqZGczdXlQRWxRTWt5QWhBRUw4?=
 =?utf-8?B?emJyT29OVGFqTVFSdTBjMmlQVkhKd0tqOXdRYjNiRHRoUWFEZDAxTEtvcHhm?=
 =?utf-8?B?Ui9uTCtZa3VCSFpNK1lWamhyNGVxNU84QmpBVEFmcGJSRHI5VnZEdFVPZ2pK?=
 =?utf-8?B?dGlvZjMwRjAwV0wrTFN2SXpVR3ZPcGF6WWRnN2I0VjErUDlNd1IwOE9QUE5I?=
 =?utf-8?B?WmtrbzlDZERzb3djcXhtWlRodVZDcUJJQURGdyszWWtjdExkc1FvbEFFNE9E?=
 =?utf-8?B?bnN2N3pIQnlXdXpHSkZmODZZakdRMHJjYnVNbUtTNVBFd1JEenhyeGt2dldS?=
 =?utf-8?B?bUI1MWtINE9reGJiem56Y0xlM3RYQndKWk56R3FQY2NlTnZUNS9HNkNvNmxM?=
 =?utf-8?B?N2tIU0FnRUVoZ0pzZ0p1blhyYVlJMlRUQzNJZ0YvQjFOOG1DK243MExjVkR0?=
 =?utf-8?B?OFJZMlRhSG5QenI3cEYxUDNJb1dGZDFMTWx0Rk02dTJlTGRwWmRwSTVrOHhH?=
 =?utf-8?B?UXVna2hueVQ3VVhKOFIyQW9QbUpIK2I3Z0t4SEFHVWpDQ29TaCtFK0UzZ3dw?=
 =?utf-8?B?djQzclJaUXlseFdJM0dITFh1ZDlFbFUxRWtIS3V3RUh1ZmZOc3NRdnBpQVh4?=
 =?utf-8?Q?1+8lHgZgwU5cSZGnlm1g2R4=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a5e1ef7-8698-4d46-edf1-08de30e89ebc
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 14:47:58.7894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g6q2tVoWCaOUaPk4PQYQRQsecWKfDae7rFGKgC1t8HOTdMWLi4armQQppgeZaGPeBRDP9A0Uc/afP/obg3iAXSYrjYPERh4CMYEpFXRWXd0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PPF377CB8326
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B18788000B
X-Stat-Signature: h8r1p83t43krj3ko1quju71a7uif5hhc
X-Rspam-User: 
X-HE-Tag: 1764600482-484415
X-HE-Meta: U2FsdGVkX18PwCVsqZcED0Jxy50arqDD+leGAmsgBV7A+qMSvNJLcmMxutV3I0txE3NWgbLj3nZpi1huIEU3/c+RTB+rDbmG3EieZJAJiB2Lay8LCd55q6WEvtSqpvNCrgBf6Tio3YLTOyJgCqJ+3OhGhb9x4ZorS81jquDc8UIlzBynkkR7DbsXjT5bNbSMtTgjvzdJahbuvawssn3CkjH+IhReo22+6ZrjmV5/22WE5yhKCViXsALpYrTBubVauc+EIaDL3vf7R+/Gz6qjpQgYrpEC+VOG4s1LW3c9SXGulOk/8TgHNlvD/EWYwzsMwAE14mpOjqph4GZQxzQjUvmGjsT/fSJT4pNcBymC2tbSr1wn1U6Ug+dOGpKC9acCYgTaDQVBD1lI8Pg5cJ54XIhGUFfYGf1Pu3PRESsV5mh3t9Mt7ssinGROMNu4AE3y5dIdk7vgzhxvvvIadOoDTxQ0x+yp1MPErDcorwMgFeuaAm1V8Kj+arkRdT/CoChIKOsAfvUFPZ5OzWDq0Be0CRAsHpK8XMwTOep97Om5g6q9kPWgiMVtEmr0YnqCQidzHZde51b3NG4WNJqND6mdoZsoUjkw7eY5syU6p30gUw6Rw2We6zo0j/E458X6xm5iJFRksOH7u5TvNTN3ECRqUvi5074v4GTIIxp9njnclGU99kap05PufDC8DsuY4hn4lHEfVpCJPnyWAv0SNsIpK9FJuvcGpxw+YQoR0O2iu8V+B1qReuSm2bH+l3IFwJbqcO0bq+62ZNCRy5/tW2OKBjQ9/O6uBJZ9cGL7hmGuzWETtw+joN7qNjAnMh06qeog8UaFSl0UHAm1GMExklH2jzkEobRFQPrleKAiKQgp+4OHrNcCHKkBVdY4FJK9Y+tVpgdOXmPE7BK2KUf0ErhxppvigqkxnPbz8gGCIc6ZTIFcr8TD6dD+V6aSXbgmfe8sAh93JzW7RTB8LbFrZXK
 dmfNf0FA
 H6ORa2xdbCA0Ff3V/aqwcufhJHCdfKuPFSBzgjfbkXxwWnPQHRfHvpUi3BeTKXzaKSsbYwe7MoFSqk/4tBxXCKs5bQ/o1kySHjO75A8+uQK3zEjYTYi8zOP6LEkDAqFnexLzIG4GM0POVUuNkFbNTfifA+pNYZbDDDu21shYpHCM1VjVCjLodB1deNGy3EhMi/VyHEgUzAUPKY3O4PJMDhXGydoZGg8P6fLlCF2R8DL5SwJeEnlRcTi6OEtrQ2neCXz4FwfzPzumIFmXpQdUVR0Bq0iX078uWEiZ31iUpy68GpFWyHmXt6EOdvRnQnlWxe0pI7SdXdI7EMOlxY0+AiCCpz1cf7SnhYLkuuORojmMj6wa/Gzveyr6MrIy49aJkj5LoA7qQ2OcRWRm/82WsEcGLgzHaCg/lCCOlGovkoOCN61hN/i+VpfZDd2+7dmQKzWU4KgVU2/OHc5IyL8nMZ75Z6y73GPiQg2j0GmT1qpzFKrEOPoIZ9ez8RzaK+yKCcnQd1ICsGnyTy53N2PlYMo8kWisBQuX13eyWmfCn5Rhl1DS/U7yqs7Q2q7hAdSFUP+cBulb4MtII0agSiuh54injPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-01 06:31, Mateusz Guzik wrote:
> On Mon, Dec 1, 2025 at 11:39 AM Harry Yoo <harry.yoo@oracle.com> wrote:
>> Apologies for not reposting it for a while. I have limited capacity to push
>> this forward right now, but FYI... I just pushed slab-destructor-rfc-v2r2-wip
>> branch after rebasing it onto the latest slab/for-next.
>>
>> https://gitlab.com/hyeyoo/linux/-/commits/slab-destructor-rfc-v2r2-wip?ref_type=heads
>>
> 
> nice, thanks. This takes care of majority of the needful(tm).
> 
> To reiterate, should something like this land, it is going to address
> the multicore scalability concern for single-threaded processes better
> than the patchset by Gabriel thanks to also taking care of cid. Bonus
> points for handling creation and teardown of multi-threaded processes.
> 
> However, this is still going to suffer from doing a full cpu walk on
> process exit. As I described earlier the current handling can be
> massively depessimized by reimplementing this to take care of all 4
> counters in each iteration, instead of walking everything 4 times.
> This is still going to be slower than not doing the walk at all, but
> it may be fast enough that Gabriel's patchset is no longer
> justifiable.
> 
> But then the test box is "only" 256 hw threads, what about bigger boxes?
> 
> Given my previous note about increased use of multithreading in
> userspace, the more concerned you happen to be about such a walk, the
> more you want an actual solution which takes care of multithreaded
> processes.
> 
> Additionally one has to assume per-cpu memory will be useful for other
> facilities down the line, making such a walk into an even bigger
> problem.
> 
> Thus ultimately *some* tracking of whether given mm was ever active on
> a given cpu is needed, preferably cheaply implemented at least for the
> context switch code. Per what I described in another e-mail, one way
> to do it would be to coalesce it with tlb handling by changing how the
> bitmap tracking is handled -- having 2 adjacent bits denote cpu usage
> + tlb separately. For the common case this should be almost the code
> to set the two. Iteration for tlb shootdowns would be less efficient
> but that's probably tolerable. Maybe there is a better way, I did not
> put much thought into it. I just claim sooner or later this will need
> to get solved. At the same time would be a bummer to add stopgaps
> without even trying.
> 
> With the cpu tracking problem solved, check_mm would visit few cpus in
> the benchmark (probably just 1) and it would be faster single-threaded
> than the proposed patch *and* would retain that for processes which
> went multithreaded.
Looking at this problem, it appears to be a good fit for rseq mm_cid
(per-mm concurrency ids). Let me explain.

I originally implemented the rseq mm_cid for userspace. It keeps track
of max_mm_cid = min(nr_threads, nr_allowed_cpus) for each mm, and lets
the scheduler select a current mm_cid value within the range
[0 .. max_mm_cid - 1]. With Thomas Gleixner's rewrite (currently in
tip), we even have hooks in thread clone/exit where we know when
max_mm_cid is increased/decreased for a mm. So we could keep track of
the maximum value of max_mm_cid over the lifetime of a mm.

So using mm_cid for per-mm rss counter would involve:

- Still allocating memory per-cpu on mm allocation (nr_cpu_ids), but
   without zeroing all that memory (we eliminate a possible cpus walk on
   allocation).

- Initialize CPU counters on thread clone when max_mm_cid is increased.
   Keep track of the max value of max_mm_cid over mm lifetime.

- Rather than using the per-cpu accessors to access the counters, we
   would have to load the per-task mm_cid field to get the counter index.
   This would have a slight added overhead on the fast path, because we
   would change a segment-selector prefix operation for an access that
   depends on a load of the task struct current mm_cid index.

- Iteration on all possible cpus at process exit is replaced by an
   iteration on mm maximum max_mm_cid, which will be bound by
   the maximum value of min(nr_threads, nr_allowed_cpus) over the
   mm lifetime. This iteration should be done with the new mm_cid
   mutex held across thread clone/exit.

One more downside to consider is loss of NUMA locality, because the
index used to access the per-cpu memory would not take into account
the hardware topology. The index to topology should stay stable for
a given mm, but if we mix the memory allocation of per-cpu data
across different mm, then the NUMA locality would be degraded.
Ideally we'd have a per-cpu allocator with per-mm arenas for mm_cid
indexing if we care about NUMA locality.

So let's say you have a 256-core machine, where cpu numbers can go
from 0 to 255, with a 4-thread process, mm_cid will be limited to
the range [0..3]. Likewise if there are tons of threads in a process
limited to a few cores (e.g. pinned on cores from 10 to 19), which
will limit the range to [0..9].

This approach solves the runtime overhead issue of zeroing per-cpu
memory for all scenarios:

* single-threaded: index = 0

* nr_threads < nr_cpu_ids
   * nr_threads < nr_allowed_cpus: index = [0 .. nr_threads - 1]
   * nr_threads >= nr_allowed_cpus: index = [0 .. nr_allowed_cpus - 1]

* nr_threads >= nr_cpus_ids: index = [0 .. nr_cpu_ids - 1]

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

