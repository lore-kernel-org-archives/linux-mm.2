Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F08BDC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 14:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E640E6B00CD; Fri,  3 Jul 2026 10:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3ADF6B00DE; Fri,  3 Jul 2026 10:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D03026B00E0; Fri,  3 Jul 2026 10:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A11646B00CD
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:52:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 21B00C05D7
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:52:35 +0000 (UTC)
X-FDA: 84947756670.26.B5412AF
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010009.outbound.protection.outlook.com [52.101.56.9])
	by imf16.hostedemail.com (Postfix) with ESMTP id 523B618000B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:52:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rR6Ylh22;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783090352;
	b=woMffFrzA+zk/cEtHyV8gZJbwUVwDhWLVG8dz3Kl7HqBFjg9/zREZGA3EWLzBYPAlAhHwh
	oVBca2xbXxcmNssbUhEUC75KnMjYmOw6bTBAUrOEhMnR9vMU2gt/aoUG8pkASZB9ztwiwe
	AuuYKplTwurBZp+LMLGXCmDs/GfuRc0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783090352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=13ldJ0K283TytbWx/mOvlI7DkhWT4w5ruBQ47oL1M6k=;
	b=WyhsxHp8vuo3lQDQQOpFhPvOXMW0s/iPmJOXoCPNbhyBDor7Us67SPIfXHKL0hnywUa+y3
	4ymn++yq6rqN3J76ENoWo3z0S2Decso3tz07znzWwObupIy13DaREIdNGnkad9rvJaNNNZ
	53bvyvrCNov6t4H6QnNrxSSJflV0bsQ=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rR6Ylh22;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=agQsM9QyJahbL2giH0XO98tLq9lpapn0BjTSZRTFX4jznTejGrMcd/eXw8M5AjLEr9NW4MBUbCSea8ny35/VUbX6TGDPKAwwtSC2LlH6Yz27yzV7ReB6idPXJSeW+JH8/GMuYemLWOI6QeN/5AuNU+tKlwTUY6pQtTCmWuZiII4juH1XwUcaJbrKBsVw4sXlYulCrP1cJClfUzJU+vpeUAw6/4C1ZvBTAVXaZMz3Zwd9A2fVoHK3x2NpkaA4J8a6+JSPJDpXG5TTS0q4Wx5pkutmjwwtAlHd4//2qu1xUl5hAxGhcr0xHCJsjMgiANfe6I0jPfwiDLzQF6vAXkh71Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=13ldJ0K283TytbWx/mOvlI7DkhWT4w5ruBQ47oL1M6k=;
 b=cnHRQC+Gu31WlUpTThW1on72FFcounVf5sVPtcrrWTWcV3sDbAb6aqiZivkbbArWNGcsjCJMiPs/hmdfJla2zWl9ato4bRYTr/PqfN0yvJaEoFQMgna7c4DQ/RhyVq/mGqrQMmgkq+7OLbZFX3qctjr6ZChEdQWnOoVoQDAnHcPxXQ7UTsNh8T4zPlqUKLcukZ+0VecFbPPa+27DV4FZzVwf/EEJRmfyl0EPprgAOc0JzWlw4fpjmJ7hylIa6EQgEQN4iifarMWMr/KQ2kL5yg62Lii0rGhRtgwTpnL0w2t4ZU1CbqCBB5o7+26AgL0fa5hRYerNRb7GcGoAQfuCiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13ldJ0K283TytbWx/mOvlI7DkhWT4w5ruBQ47oL1M6k=;
 b=rR6Ylh22WcivqvuCyJBrGilkXMm434wjOA9WfW7kNT8f9uqCNSA1GAkbOLPl05EpFB950Z1uPaH4F/B2zpAOIDQd/36FY1+32evITTcZAFI8VnL3r83rqW2/pJFasHZjDmx2KhiAFfdDyTEPTLggHfhivwScorjsMV0im8n9D3jzUGnRQ6mGh4mNBdZSDg7oBY5E4Q2oAu02X8wyEu9IKxRiwHmzBlRAQhH7+8MxaK42RhDKYP2uEjqHfWZQWccmAl40ufiC/ZqDva05YYUrRPeRbXEkdvSe2AS4OGGC6JjWAk4ETkaqIK5i7aspVpPNQZSJCXxh4+WgWas3T0/zLw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH2PR12MB9520.namprd12.prod.outlook.com (2603:10b6:610:280::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Fri, 3 Jul
 2026 14:52:23 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 14:52:23 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 03 Jul 2026 10:52:19 -0400
Message-Id: <DJP0RTH411K1.3S9HHV01U16S0@nvidia.com>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Hao Ge" <hao.ge@linux.dev>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>, <derkling@google.com>,
 <reijiw@google.com>, "Yosry Ahmed" <yosry@kernel.org>, "Dimitris
 Michailidis" <dmichail@fungible.com>, "Andrew Lunn"
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>
To: "Brendan Jackman" <jackmanb@google.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Muchun Song"
 <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v5 12/18] net/funeth: Switch to higher-level allocator
 API
X-Mailer: aerc 0.21.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
 <20260703-alloc-trylock-v5-12-c87b714e19d3@google.com>
In-Reply-To: <20260703-alloc-trylock-v5-12-c87b714e19d3@google.com>
X-ClientProxiedBy: DS1PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:8:44f::17) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH2PR12MB9520:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ba770c0-74c1-49b2-79e6-08ded912b103
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|4143699003|11063799006|56012099006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	6mEVGXNzh8hNsyJsBOwIdpsf2CFz4Y1rfewevWQat0pH4qZSIcHzpJuEJAH9ivu30glvxG3YO4LUO7ilCX18IkPrpRw8SUK9UEBfp4sGPPVBfw6e+V0L3ulRssuH4pxZmO5hz9MPRUiNl6McuFGFa9BwPVfVLPFkhHzD89/FiF1kn+P6tN59wju39njwQX1T8tTPLIxc+7A1X3keUI+3X1SOJsuQdgIyFLiiMWHQJ8YZewYYZu6+nmOIekr1YZ/0XM2TkOPAy0ALDfaLFGJ0SQHmmZTj4Y/e5ARjxwczYOxO9ihyXRBUef1WKtAU99nNGRUU4fW3+lJn4jxKVQb/mmvFJ3WOHrVHtazj3yKSbqHl8hiYAf4xXnP+EOZiVgRG67x4iNS4bjStxFEwBwLR/0/8sAAWTUwlxWNSFdnTUeWmgvmvOOoTJIDj1IM9bZ+5MJsyS23HA7tYie0w9G5QXu8agS60LsDuDcc9hvkZTbmpO09pLs3O1fo/sb2/qmUx163Lu5Z7fMHWjczxsR2yTslcTOAzNSWDT9ts03CmeCp7C/AjuHRVs2+ea2QqhI9yCdleIbyWSO9QfBjgS5jBKpfiYvfaB3tjjsOWpLNXLGxib6e/pje+fxvjpPVzlR7yqKFb1Pv9lq/Ip+RR007OB4suVzuD5WcsW9RGuLOAye3PrpQOlDnCl+vE4hZXIWv64CXkuDNYWmJIOzhr0nn6Nw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aSt6MnZjVmRZM0Z3NGQwTXNTSXNoSllNcng5U0JCNmRhY1FIcXVqckVTNlNS?=
 =?utf-8?B?UHdYaGVBckx3TEo0cnhOaUxBMElHZU1VTFYvaGVNL3p5YkZxNmM4LzJ5ZDBq?=
 =?utf-8?B?bnA4NHI0Y3lJNDhwK0VXblRDTjdBV0t5KzlYb2h0ZGdHeUVVc09nVEdEY3g5?=
 =?utf-8?B?bjdDelNjcVBybzRENGpNY1NGcTUveFlSWE1mdFB1bTZxNVdiamZCc293aTlW?=
 =?utf-8?B?aThmZTNFRkdtak43R2E4L0ZlT2pGSXVIYWwzT1Q1ZkowN0xoMzZQazBuZk90?=
 =?utf-8?B?MU5IUVBReGlvWXBkcVFIdGluM3llRWxrUHp0ZkJSb1dlbys0bVFOV2MzUkx1?=
 =?utf-8?B?dlJCZ2JMb1FKZTJlTll1NEg0WWptYjY5WjVheHp6UEE2a05NSUNGRzF1WXhQ?=
 =?utf-8?B?WHY0WmtLcEk2WmhNdW1MemxDTGw5amI4RnhzaUdNUjZoZHJTcSs1Z0w5RFlD?=
 =?utf-8?B?RDRsU2hBd0grM2F3TERqUzFVMmZtSmRnM0hMYUpIMDRsTVBuL21ZQzF5YytX?=
 =?utf-8?B?UUhkSGcwa2VLdjF6c3V2YXJFUkFqUlZ5ZWFTUEZpckpzTTdIMEkzZmZlNDZV?=
 =?utf-8?B?azNMak9zM1lvcXdCV2NzQUY1aXdZVWxlY1FqVW9UKzZldXAwYmRYV2hLWjR0?=
 =?utf-8?B?M2MxK3Y2NlE3TExGek5NUGEwRms5S1cyVWJXUVc3Z3pwVUJ5TTNrdnk1b1la?=
 =?utf-8?B?S1paYndiUmpoaXlLSVdDcXpYQ25NdWpobUJ1VkdQYjBKTFNhYVFiTFlWOGIr?=
 =?utf-8?B?ZE8rSHZxbG1aNlIyYjQ4OEJ1VFFNTHY3TExKMURzejBldzZ0WEZKdzQ2dTA0?=
 =?utf-8?B?WlRzQ2t1Q1hRWGNDelZScUE2RnZJNklyU3JFcVpHdkdqNFBlUUNndHM3TW5U?=
 =?utf-8?B?bHJJT1VlV3k1bDdTaTVPNFNEcnM4NjNFM1lrVjNZTG50bFcyN1pFdjVJUnRI?=
 =?utf-8?B?VDU4VFdMWmFNaVNaMy9IWmVVUGFaaE1QODhsM3Vmb25NVEFCempPZExUNUQ1?=
 =?utf-8?B?a1VFS3VaTlNkRlFTWU4zcHZ0VWtrWXBoajMyUGk5YlkzWnFjVjlld3V3UUFs?=
 =?utf-8?B?VXlEVzk5MFRnbGRQMHpVVlBsRTlrTnVlQUduamQ4R1V0UHZDRzRuWmlEZ280?=
 =?utf-8?B?amRQSXlYL3g3Tnl0OUkzZzkxMkVKMzBERjdubW5ZOTdCRkxYaTZFRXA1cE5p?=
 =?utf-8?B?U2paM3ZRUzBPd0tHYndRSFdWQkl5Z1ZiNjRUSEpiblFzNGhxeTJ5UTMxcWNF?=
 =?utf-8?B?dXJiQzl2d2RpcmxzRXJVTnhqSEVGdDlmME9DeTMvM25TVTZBc0NkMHBtbWhv?=
 =?utf-8?B?ZWhYTDJ6K1VzL0xuV0FkbWJuSThaK1h1RmxCUkI3aStVK3FaRlJmNk5rNDFE?=
 =?utf-8?B?cUg4cDRKOUNCRVFEWUZhUTR0Y3RpWE9BZlFYcmdvUlhkdXJSVGZGNTgwODR1?=
 =?utf-8?B?RW5RNTRBbkxqYTNzTWhISlhhWnNGVmlUWDNOUUtldWhpV2NqRTJtSGNQa2ov?=
 =?utf-8?B?Vkh0TVZub0pKbVhtd28wZE11bXExU1R2SXljakg3Yno0ZXcrOTVDTGptSWpv?=
 =?utf-8?B?YnhZU1dFSXRMODdsSFpmSVBsYnViOWZ1NHhMVHA5cnlKcDdOUzlLTVNMZG1q?=
 =?utf-8?B?aEdKelNDalh5d294cjVMdXpuWVpuc09qR2l2QkdJTldWSWVWU0lDT09ZWUE3?=
 =?utf-8?B?SHlhaXVRVzZHaENhUXQ0bDZUM0hUTUVFMi84Q21PdktjeE1lTEhCWW53RUJW?=
 =?utf-8?B?Z3kwTEczbDZhZDRLd1VVRXAzSlh4djBBSFNrd3FRNlJhSGRYaEhmNFBMQUVJ?=
 =?utf-8?B?Zy9QSlpEcVBvT1dISVNJWVhDa1hzYTBJc0xyRXQzcGQ2MnJ1bnlXN2pFY3Fs?=
 =?utf-8?B?MjVxa2ZsVlpyaWFWcWhrU1BFR1lxbnpZdVJTbHFJTnpMbnpLa090WjJ0eXZV?=
 =?utf-8?B?b0RpSnU4clFnZXRRbkZpV0p5T0QvZ3E2SkVHblBPNUlkNG9Ua3R3Wko1RHF3?=
 =?utf-8?B?K2phQ1MzNWlGNkJhWnB0ODl0eTd5MHFWN1U1eWdDRW9NeWJLbkNkTFZycWVn?=
 =?utf-8?B?UHNBM3hsRk1ROGdCK1Y3SHVXTiszd1RzeHZyWVRIbkc3Z0xBNDNEaWUxdDUw?=
 =?utf-8?B?Wlo3NjRXTmtXVjNpaFc4YUx1ZlFpa2lkcm85TjJTYTB1cGZpbHVIRDhzUUNq?=
 =?utf-8?B?U0o1TEJyRUlyaVVMVzRCVjliUXBBWWZubGorajZXeWNiRlhUa1RueDB3cHR2?=
 =?utf-8?B?QUl1bEhYeDFXb2lLY0dyQUR1VnRkRndRMmFSMGpSeHJGRHNNeDBLMzBOT2VB?=
 =?utf-8?Q?IZXaBLlHAwZ5V1vsuw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ba770c0-74c1-49b2-79e6-08ded912b103
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 14:52:23.6863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cZkzgZ+ADkHd3wcQEJj/2u96ag/8XDug20urYq/X4QNc/fVlFLi6NfbxcFYiBsdZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9520
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 6ibbt13ic1mmj11d9xktgxierzsim7ka
X-Rspamd-Queue-Id: 523B618000B
X-HE-Tag: 1783090352-265090
X-HE-Meta: U2FsdGVkX18W64rVzWlv9E0W20OHyzn+L+QdG7xHtQGVI1MR5mhjXrSYSmgVFw9Xa36gn5hrwFXnplK3upNYcdtlzgazOliQ70A0UABPyXwwtrrwpcaF6ZTouoRHctn8kWiWthbNxWIZ49b583rn/4uf2m/LcyPqOebTZjpm8OPe1c8EtTpizqhVyKpc0rRgxC2P8AUgZFapEote7NKbyUbGoN61VPbBv82gMGV6AgMPGXFbwD4UIW8mN46rsVYT3XKpa1yG4Dh3a2hNytvuVcrcoxkXcNc/u/JMFvnxWQGcTSv6NF36lqk/91TvaWX8gAoma+6pDctGHcI2b81GxOxpBrXBdpsF88CfM4jw9Kjul5HS4NROj5jBvgMIudx+wa8+UjzqWIuqIajpyR3UTRaugCTcTDZsOtYIHQWZftvep96xrnOJnQ/ffmTk54aQUEglSNzFkJe33ghxvDPZ1X+mODLOYLi/V/fT1nHCezGtcf1QQIfuc+yAUM77mTSl8Iov19X6MUIMkqHeSTRJ6Uj3L6FfZ10CN2rlDHbTCeHsLM3zQAyR9dL4R97/vkVcZ54i8NXtzJnQsIAxgBI+6Hy1kxPRghNIOA4okbnTzC9KUbXItWdbj/SSorn9PYi9Eo7OSVejuAV919NDums5eut5TYBSn+Pq9lmXHMxlmqUWSPPt0Iig+RKPf1RlTRMBLir7lzkXXcn7r6RZ47Do0dnP00xtj+5nlSAl2Yk517wBfkuqcubK8105o5po9p02KulFXxduMXrsRcKkHwYK9aMUwdTH67wW6cVUkcit3q6gXOcYQxBmcpWJBHxVdsNyG7tixi6EvKRieVyGwZlkxjPsL6tpE7AKslQL+S6RwHq0jDErA7sBS2uvkCui3Ibmzv6+GrhSu2wOQIa+D/ulWASokoUMV+a5yvbmuRvfG7F1bKhkMRPFSn3cIQE017CuG+NoqgzCrmGnvQ3+NIY
 SDkTp0uH
 AYRtqP08kjiwoU+i6MTrunfnzVeKPzB2PhYJLr4PjAFVNXOZJl9PTmrd6eZ0joKnbCzUIXMB6YQMJFNGAjBkxxHQEHOr9NU93K0qDA3O5o17u0Uk/KUuOYFtS8k+v6i7U947vfn+IeXdX0NRz+c8aL/nTcj1QEW3aCrrTkgSBVjurRRPnldBik/V8KZ/kNjhEdzqtHwQWUNRg98sHHpYZkL0qKIJVvljo2fl0WXzH+zMpkwhH+rwIJiir2xf9048f2hlhnDxeTSRHEyvyWneb9dErO7KVKfGFWryaUGTbSe2obrpi3X9c0jMG+aqWSwkE5q8TpXZDI30SfrUqVenljTVRxgLw5Zc2ER3W8DG/5BtYttTWfC95DuVjvGHua1N5OonVvYJK4UoJk2IoGozbGbfJouFNFZsVoYQbiE985hQ8/euzA6y5I7aUvNZMgKUYDExNIM0RcbDfc4U5hp4lisq23P2uT7cW4YahtjYibHIlr8k8SLi77+XsQDZp0blehHpNbwzedIzpkuliAylCPTkW6V8LOSRp9fBGRWXow4OpQK/w/EBl1pFozFsCsQDNl4yAoN0ajV1gVKSEsPbHoVpX5DKYtVgWhkqhfgxIbIDe+mSbtBhlpzA0WIJM5Zc3nqI4dfdwrGvQwLu411Id4HUTC8Y5illm5kZoDkp7FgLWIRSH2ZECF/hbrPG5UKQjz2D3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 3, 2026 at 8:31 AM EDT, Brendan Jackman wrote:
> The difference between __alloc_pages_node() and alloc_pages_node() is
> that the latter allows you to pass NUMA_NO_NODE.
>
> The former is going away and the latter works fine here so switch over.
>
> No functional change intended.
>
> Cc: Dimitris Michailidis <dmichail@fungible.com>
> Cc: Andrew Lunn <andrew+netdev@lunn.ch>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Assisted-by: Gemini:unknown-version
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  drivers/net/ethernet/fungible/funeth/funeth_rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


