Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CD15F53D69
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:02:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7FD26B02EB; Mon, 16 Mar 2026 12:02:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A40C16B02F0; Mon, 16 Mar 2026 12:02:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F88F6B02F2; Mon, 16 Mar 2026 12:02:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F6E36B02EB
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:02:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 254F01A0265
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:02:23 +0000 (UTC)
X-FDA: 84552393366.09.6844D3C
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010006.outbound.protection.outlook.com [52.101.85.6])
	by imf27.hostedemail.com (Postfix) with ESMTP id 168B640011
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:02:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DlcJ066u;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773676940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/wEaGMYke7+vjlkxbh2iN6aIMFtd9WvZ11X4TJzBzFY=;
	b=QNuEdRUeOP/IinMH4jQpu4+oh9C7Jjpybs1nHC8Wn1Qk2BGfvlY5DrXaUocIs3ZIjb0BLW
	twFoCPWbK1hThd5P2h0NqGTHdutJCLmcPRMalRfpQy45uL96t/QqkxxbD4vBP2uj1iEJij
	woZlx8D7vel7KIHe5yT5kctYvTZ7NBI=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DlcJ066u;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773676940; a=rsa-sha256;
	cv=pass;
	b=IKgdzCI/x3WitGtVeMXpr3y+UkMrBsQi6PHEU32d//9IOV+O9FATqEbIDoIKDDV3Cuoshy
	CZoB6Bon+Wr21afJhkYe2mtnzRFC23UMKcDQrkng8Ysk7guLY166vhuFrpuRJumPF0GUlf
	/8U4LZ+RwWXbczwc9fwaHTzm5Hf5g6A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c3lURQrW6JYRFoQfDGLIxaozHl3U9DINjFeXx3QVaQc04z7aH50cXXo5PfYmFkfBtpRigV/VtKsHWkInHVCrc1OacoMVcEWjNPAn80tVUa5wjHJBT5oR9NnJD6VpCblf733hE6fOE+Rdg7Pnji45PEqeGv27HBOow8bEoi4rFucOPgZxeh9EEkj6QWG+qCsY3/bwPNVTfD68wCS5BKDcDuU0xpOH5CmMgVyYCBe0znevUKIMh7qm0Ym6cKvGyS47y8mYg5tozwEpaCbeXDCJudugzH5wkoXYq1J48gMFbhXHrfgpczEvTQecPvorCsgfMyT+w+CrrEHGeZo54vqJ+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/wEaGMYke7+vjlkxbh2iN6aIMFtd9WvZ11X4TJzBzFY=;
 b=HJmXxsWM0rQODPpS5s2F72dXRwrfrGf3Dz5zf/dM2cqO8Hmi5sSNKpAB+rSeHJxDOqts/uEBnOOA6qSCulTq4tG92W1flx2xqps8Xbq2tdeiSaVM8rQWvp5tqmmwjZbeoj/OPze33gACKe0dnE5aBBNIRuF2ZKsRMH5fvBGw0S1bTXmsz/KROkd7QySPjei7RUmZTalb1kfH1T62xVl2s9g+bTxkixmhC4xl+WAa2wpQA1G0fWjHeM5GNE1RgiFeXtTSyZJWP+nGOrnWwIWgszg4P2BzSmtBYYh/eF4vzqdif/5Iscydwq9jt4ZxfQ4QvcuW44HUM3i+Ahv8i0ZUGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wEaGMYke7+vjlkxbh2iN6aIMFtd9WvZ11X4TJzBzFY=;
 b=DlcJ066uRDADJKJU+VMIV2reA2caUrJ7cHdEOE/7IdnKLxnA7ACznplFk7foWZpHFOXJbLcYaA9U4MzC3eNRb5vTjnJ41vgy3Ti1U2eHNfd9egrbJzTmzn2Cgxb/eaRkIXuV62WQF5f5KGcG6ZIR09gVIw/gixdhKaUIlkBr7i9Iw5UTpjupRiKeZZQSKU1LxEVuba3AVPrf4U7/DzW2w1byXgp66eCCAnGqeaCIkUAi5euTxCeQ0gIGKHZxYaNVw7WR/bfmIaNq7/kiCT03BesmCOd60qS9f3qtz0TmaN5JlddYimHRuWLO6Nq83EexBEOXHIuV09kwPYqp7zpBdQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB7567.namprd12.prod.outlook.com (2603:10b6:208:42d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.17; Mon, 16 Mar
 2026 16:02:11 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.016; Mon, 16 Mar 2026
 16:02:10 +0000
From: Zi Yan <ziy@nvidia.com>
To: Vlastimil Babka <vbabka@suse.cz>,
 Muhammad Usama Anjum <usama.anjum@arm.com>, Ryan.Roberts@arm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, david.hildenbrand@arm.com
Subject: Re: [PATCH v2 1/3] mm/page_alloc: Optimize free_contig_range()
Date: Mon, 16 Mar 2026 12:02:03 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <703BB8CD-23D9-4012-8333-366837D7E95A@nvidia.com>
In-Reply-To: <220e97f0-dc82-4f37-b833-7160aee46cea@suse.cz>
References: <20260316113209.945853-1-usama.anjum@arm.com>
 <20260316113209.945853-2-usama.anjum@arm.com>
 <220e97f0-dc82-4f37-b833-7160aee46cea@suse.cz>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR05CA0107.namprd05.prod.outlook.com
 (2603:10b6:a03:334::22) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB7567:EE_
X-MS-Office365-Filtering-Correlation-Id: c6cf7ca7-e201-4464-7c02-08de83756193
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	qwF7YFx02HmugEQ/VBXWtnOlQUzIGpEb8NDDLM+t7ZHXfT0hidgFQlnu7lte+UnQ7UZkPCL3y7qmWQOShy7Q8ul96e+FE0rMYdbsbYlIScBSWdaywq9E8Ei/KbfkHxalEhELvLsc7s33Esiy0zHas12fDfd/SaIbHnW3I8o8HcHNWGIB5Roahuoe1zk/p7NS8p0kj1LqIPtqcfOk/UQWSwQPph0ds5gXJet7vxL+5DPouGYiBDmEg7XxpNWXPeZPQrctBC/ddxNMBWMFbrVajohxdskxjgI4E9V/ZlgTEOjG1sp3Or0DXU0e6p/6RHCXQFKBqAUa+pb5WarvNioYQDL8sjMdUiI/Nt6ezBWbectDg1i2a9aM6g37tNQMxbvhXTUoRqaAxOTC+jo3V2jkSevV6SF6amzxin/IAL2XGCBLz6uSPgZdC4GvY+RDLWjx05hX2sYh0XCPvEr0m83R70ym19vrWcAwbbcLAF/Cfn+/GfPjqEeHu0LrBRvUq+1zYmntoJm56cmfnp7wMcy6ypKHQ0C4rtEeDBVOi6UdeiMzMJ91GO9cMuaUkbw8ynskR5ROYxPxnOG6XbaBcb6Wh1yxqFgQlT4EEBdt6iSLb+9Kb2KwGLzPQpk0WFfNO9+aqpZ6PiiNaDn9LN3TGj9gMpfOe5QdDD6Z9FBJtK2KI6yWBCWtMifYEvUCU/eHuuIDyxdpab/cIdWehGPuRjdPY+fAiwoNtxfaMsDhyKqVHys=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GXoUWoVzkri7sTFwoE0hmq2vAHJ7Db0xRpNuAU1FxkwJx6a1ETBZ4Hpur0ll?=
 =?us-ascii?Q?bFN30nJT3BENg84W585y9+9h4uXdm1CNOrNtHLv9Z06vdvidaoHdZvig63FX?=
 =?us-ascii?Q?YzxHSLO7Oz2FR8dtySAuFf7iFkZug9eePM0P6OOgIMKYHHGJZLmc9UPsHWvw?=
 =?us-ascii?Q?iVfbytMA7GCvSnJCiWY8GCoXSOT4+ySGkZbwn4ZA+f2nesjPitmi+qC7+4DF?=
 =?us-ascii?Q?GsHHgfdHmGppL7ptYQ5v0wR/X+ilUW4409XzohPTcupze5dfqtU8hgy/35be?=
 =?us-ascii?Q?vt8uW/ms0IPD9mhpmnwCldMQx7gYfJ1K2lvWkSRjWUEy78p9hOJyfMHW2tyt?=
 =?us-ascii?Q?sziGjMwGY9q3FNZbd45lP2346BTcb0Y2fWlmnIK6kuGdZCxR+wWQtwE5NBJ8?=
 =?us-ascii?Q?Y5gGLMPS/w+hlnlL1jw+qSJ0SDGXH/byyRapEAzIM3smLijNHMxnMa9dypjZ?=
 =?us-ascii?Q?qCkrkK4vAuy+/cYY7L8I0TfBBW5WIAmBAhcoHuX6Uy+y8Oc+k9+UO2f1dyNS?=
 =?us-ascii?Q?L2Z1GDofxL3Of5fmScCzZqorl1wVhQKPdR89e0R9YRYjud8/4GupaGuAtRmL?=
 =?us-ascii?Q?iNWjHfja6fycTD7li13Skajpt/eR1yjBoD2V2xxox9S/bxfuBEpnEc3G6vCD?=
 =?us-ascii?Q?rp82054GLlC3X5mqF8NY7A8jlwCo0aE+6Do7bpjePG/CjCIJVFw/vHoKeYPz?=
 =?us-ascii?Q?zOAcGam5ZHuD1xkhn9y8yzHLujVm2e42LnD5gnQh5HEMKHhAW/5yewvoSgfc?=
 =?us-ascii?Q?ecoOnGKREHQAQXe8danSS1hUzlB6kNX8ITuA3j0822AJJckQS+aBPoMNaYXL?=
 =?us-ascii?Q?NP4KSOhf/rS+ws+L1utl9/aQ6b6728WXr7fKXYmJmh+nMvNx0d3NFpTT0laK?=
 =?us-ascii?Q?0MCFDpxEZP49RfOHFVpdNjpYsrVHKgbTR5fcrVsilx7WOiRaNvhUH3XpS9qD?=
 =?us-ascii?Q?XWrZrcdLY6K5BA3yOgt9CeuMorxi3fJ0gaalG1+A8G/grZROz+dBbHVTFZIJ?=
 =?us-ascii?Q?yHm65u5JuxaQhAlfrrlgm9JMuR2VoF0VeOMJqH/j0YlalFdfEyuFrQEVwk5I?=
 =?us-ascii?Q?qvdOmu3o1yqa2aMKYpBTtq/3bjogppQpWEcwcgV0DL7p3OLCkx/C25UbA4u/?=
 =?us-ascii?Q?8i1sOsABfw8MhRE1r2mPVFroNx8BQGxk7Yp1Epq6xVZLaziaIX2nQpviG7kA?=
 =?us-ascii?Q?1e1Abu8oApK/FUx4qHaaLR1Il1DBmuq56xccKm3O+Ql1l4YoZp3QOnwvudpq?=
 =?us-ascii?Q?D+SJ3luBVDNWHGXtaHnc1Nhdk9Hu3qt3ey4v6kPGInIzSAsPPHfTx30UrQGE?=
 =?us-ascii?Q?HKcMMbSD/zd2p0FBXbmYajCk6MP3fHHJRkuLxF5es4/RRuVlzt8T2nzREsR2?=
 =?us-ascii?Q?+kJ939zeIPtwL+HFeZ/PSlAml3QFBnSEziag8Ma/z3WourA2/f0wbPViwsN8?=
 =?us-ascii?Q?tVHxfmUAnMnO+TTNIGzRMtnOxhHcEPCEAQ+l74RSwvm6eBM/P5LBXEBf+Qlj?=
 =?us-ascii?Q?qTTfYrztVT9sqj5acQ8CwRueBn7/ycY7SzRuxDiDYsK7PP8SQu9IRLGkxE6Z?=
 =?us-ascii?Q?LBz0AJX8ram3eNiybhnb1YtxZWIeTWUiou+yoVsS6NzReQ/lOSoyEBr99CV3?=
 =?us-ascii?Q?dxTpN+/Ep5d3tx+p+4WELWLnqM+g234skeX3eaI/EDA4voFBKlYZbI5RusPD?=
 =?us-ascii?Q?RobrwNgzP2lz6GfKSz8NttCdhdFyF4HhaDXH+KQUsym8m1Ki?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6cf7ca7-e201-4464-7c02-08de83756193
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2026 16:02:10.7955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5KWljkYqJB3sYWkatQNEJ2bENLUIZL1m92Bfu69zPqNNScq3hDPH9eJkvNBZs6AZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7567
X-Rspam-User: 
X-Rspamd-Queue-Id: 168B640011
X-Rspamd-Server: rspam08
X-Stat-Signature: jeuopb5m6idcjkd3e99bqwwyu511acf8
X-HE-Tag: 1773676939-378966
X-HE-Meta: U2FsdGVkX1/K9UCTVywEAzHqu7hcZI15c65MT8N7dVugQcLHSggsbB0d8ICYDjDSWdDYc4v3oa+HO6vaO9CaIVHNL5e/zEuuJI3Mdo0Y+wsX8k9D+iE57zgNqk5SdKbpVn6CQSDrAwfG1GERFXbQ565CEBLIcm80MpCba/KkJ5mKl9gykmN/IrUxp4rOZ1iLHdlCeB3DRo0W3nsHcTjzFIzp8JNltcsp0SwNJ25I1kzGR3o6Dhmqxvq43HftRVugZQtL6339YoMDe9Of6cV/omnL8Q29cCHG6DEQNaY9gnRNY3PZr060EyTx9AbdwjfephD2UpdL6RPFzvSgM4m67Y0y+npTxJvl3VIQLn/tWRDgNpGgSylpANUGH/lOPdnRhL8HvxHc3c725v3OGjudu47jLgZu503UZMG1GhiDk5YWBfvuNC7//NGWGe92tSU5TbyY9cRr2BJvc+omGCwbGpDQIMThkNTkrZDk+s1YUccli/C2CLr9DZhnuL0Yk1ksHAS8KDH9rlXK/7yvmyQXrl1w2dtwQWr0DXf+rEYGriZKpoWbfb6Zef2xoNuYOLiVlQro2AabqgvSVlDIXXQy8Nqi6J26yZ4ucQH6f9NZe+Sq9cmr60ScMIS2I5X15hD3671/LZVJagO9MEd89dd2FVdKo2lhaxarSNtKnZeth1AozNLgOR5ebfJeX/cvosDkTlVyKal1d0Oc21bduCav+Yu1Iexhh2zUIFu7Cv7LNrJKWDoPqFyC61mY8jqEsXagWEebMvw7aCGPghLo8R5+damoVKC91JgczTVOBXTJnRloPP5KimhrJ72VlxLzPp+Z4K1dWXvNhmhQ37YoFmqCX1dW+xGxbgY1Bg8tWzoKvbJX7/VSfuUDbwVqgt/XUiuoxei0Yz/e8nfDcD6ie27zS6VjyiGEDY74P/qpTRRAMowrwZpEuPZFJ3uGkpDz1132PmJZ3C+D6m02txS5mnB
 5XkUQfwX
 uuPRDubRsM5GVrWs0bdgpdzjAojUVTNsCvYQbuiMIr8vvWkM7A56+hYy+XKOWWk6vJq11Nj7G+G89af8Up5iZSwwnWMVJfhxcx/Cvr2noBnYDSJNqfaI1Fh7XFck3dqX7Z6SF6l2gCdel2Ln3LGyxpqn3ldQ9h2wbphlnhNQqGgXmipE9zxrSQnTxUZXYSWH/vJkOMvntKa8c9ics3q8zZabhEDf6SC7RcW96xKFD0bqk9C+skBqhSZJPYOLyAtaKb1pbrv8yAMDVOiMH1fC0tui0x70r5EZxrE3sj+O0gNn56vIIiGC0dkq1a+x0AsZk5BGWfUnB6UJ1DQ4aPDGAK35qot1UGhZMWbapXej7aNyitpt0NTu8YfOzZnDk51Ky+eE2cgDfq7BJ+k7hC2LmBOrfwCuFiaKKf/cEWO98AEpt0+ExWlcQaotdYiDF5qwZ63mzfLTRN1WlFFhCD2oDlmqIuntICN6gkum2a51TNhrtiPTD58+SSxdSUQngA0C1P5hYPjOaV+hNr8La8IO2DuzaUEf61CIi5PtJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Mar 2026, at 11:21, Vlastimil Babka wrote:

> On 3/16/26 12:31, Muhammad Usama Anjum wrote:
>> From: Ryan Roberts <ryan.roberts@arm.com>
>>
>> Decompose the range of order-0 pages to be freed into the set of large=
st
>> possible power-of-2 size and aligned chunks and free them to the pcp o=
r
>> buddy. This improves on the previous approach which freed each order-0=

>> page individually in a loop. Testing shows performance to be improved =
by
>> more than 10x in some cases.
>>
>> Since each page is order-0, we must decrement each page's reference
>> count individually and only consider the page for freeing as part of a=

>> high order chunk if the reference count goes to zero. Additionally
>> free_pages_prepare() must be called for each individual order-0 page
>> too, so that the struct page state and global accounting state can be
>> appropriately managed. But once this is done, the resulting high order=

>> chunks can be freed as a unit to the pcp or buddy.
>>
>> This significantly speeds up the free operation but also has the side
>> benefit that high order blocks are added to the pcp instead of each pa=
ge
>> ending up on the pcp order-0 list; memory remains more readily availab=
le
>> in high orders.
>>
>> vmalloc will shortly become a user of this new optimized
>> free_contig_range() since it aggressively allocates high order
>> non-compound pages, but then calls split_page() to end up with
>> contiguous order-0 pages. These can now be freed much more efficiently=
=2E
>>
>> The execution time of the following function was measured in a server
>> class arm64 machine:
>>
>> static int page_alloc_high_order_test(void)
>> {
>> 	unsigned int order =3D HPAGE_PMD_ORDER;
>> 	struct page *page;
>> 	int i;
>>
>> 	for (i =3D 0; i < 100000; i++) {
>> 		page =3D alloc_pages(GFP_KERNEL, order);
>> 		if (!page)
>> 			return -1;
>> 		split_page(page, order);
>> 		free_contig_range(page_to_pfn(page), 1UL << order);
>> 	}
>>
>> 	return 0;
>> }
>>
>> Execution time before: 4097358 usec
>> Execution time after:   729831 usec
>>
>> Perf trace before:
>>
>>     99.63%     0.00%  kthreadd         [kernel.kallsyms]      [.] kthr=
ead
>>             |
>>             ---kthread
>>                0xffffb33c12a26af8
>>                |
>>                |--98.13%--0xffffb33c12a26060
>>                |          |
>>                |          |--97.37%--free_contig_range
>>                |          |          |
>>                |          |          |--94.93%--___free_pages
>>                |          |          |          |
>>                |          |          |          |--55.42%--__free_froz=
en_pages
>>                |          |          |          |          |
>>                |          |          |          |           --43.20%--=
free_frozen_page_commit
>>                |          |          |          |                     =
|
>>                |          |          |          |                     =
 --35.37%--_raw_spin_unlock_irqrestore
>>                |          |          |          |
>>                |          |          |          |--11.53%--_raw_spin_t=
rylock
>>                |          |          |          |
>>                |          |          |          |--8.19%--__preempt_co=
unt_dec_and_test
>>                |          |          |          |
>>                |          |          |          |--5.64%--_raw_spin_un=
lock
>>                |          |          |          |
>>                |          |          |          |--2.37%--__get_pfnblo=
ck_flags_mask.isra.0
>>                |          |          |          |
>>                |          |          |           --1.07%--free_frozen_=
page_commit
>>                |          |          |
>>                |          |           --1.54%--__free_frozen_pages
>>                |          |
>>                |           --0.77%--___free_pages
>>                |
>>                 --0.98%--0xffffb33c12a26078
>>                           alloc_pages_noprof
>>
>> Perf trace after:
>>
>>      8.42%     2.90%  kthreadd         [kernel.kallsyms]         [k] _=
_free_contig_range
>>             |
>>             |--5.52%--__free_contig_range
>>             |          |
>>             |          |--5.00%--free_prepared_contig_range
>>             |          |          |
>>             |          |          |--1.43%--__free_frozen_pages
>>             |          |          |          |
>>             |          |          |           --0.51%--free_frozen_pag=
e_commit
>>             |          |          |
>>             |          |          |--1.08%--_raw_spin_trylock
>>             |          |          |
>>             |          |           --0.89%--_raw_spin_unlock
>>             |          |
>>             |           --0.52%--free_pages_prepare
>>             |
>>              --2.90%--ret_from_fork
>>                        kthread
>>                        0xffffae1c12abeaf8
>>                        0xffffae1c12abe7a0
>>                        |
>>                         --2.69%--vfree
>>                                   __free_contig_range
>>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>> Changes since v1:
>> - Rebase on mm-new
>> - Move FPI_PREPARED check inside __free_pages_prepare() now that
>>   fpi_flags are already being passed.
>> - Add todo (Zi Yan)
>> - Rerun benchmarks
>> - Convert VM_BUG_ON_PAGE() to VM_WARN_ON_ONCE()
>> - Rework order calculation in free_prepared_contig_range() and use
>>   MAX_PAGE_ORDER as high limit instead of pageblock_order as it must
>>   be up to internal __free_frozen_pages() how it frees them
>> ---
>>  include/linux/gfp.h |   2 +
>>  mm/page_alloc.c     | 110 ++++++++++++++++++++++++++++++++++++++++++-=
-
>>  2 files changed, 108 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>> index f82d74a77cad8..96ac7aae370c4 100644
>> --- a/include/linux/gfp.h
>> +++ b/include/linux/gfp.h
>> @@ -467,6 +467,8 @@ void free_contig_frozen_range(unsigned long pfn, u=
nsigned long nr_pages);
>>  void free_contig_range(unsigned long pfn, unsigned long nr_pages);
>>  #endif
>>
>> +unsigned long __free_contig_range(unsigned long pfn, unsigned long nr=
_pages);
>> +
>>  DEFINE_FREE(free_page, void *, free_page((unsigned long)_T))
>>
>>  #endif /* __LINUX_GFP_H */
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 75ee81445640b..6a9430f720579 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -91,6 +91,13 @@ typedef int __bitwise fpi_t;
>>  /* Free the page without taking locks. Rely on trylock only. */
>>  #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
>>
>> +/*
>> + * free_pages_prepare() has already been called for page(s) being fre=
ed.
>> + * TODO: Perform per-subpage free_pages_prepare() checks for order > =
0 pages
>> + * (HWPoison, PageNetpp, bad free page).
>> + */
>
> I'm confused, and reading the v1 thread didn't help either. Where would=
 the
> subpages to check come from? AFAICS we start from order-0 pages always.=

> __free_contig_range calls free_pages_prepare on every page with order 0=

> unconditionally, so we check every page as an order-0 page. If we then =
free
> the bunch of individually checked pages as a high-order page, there's n=
o
> reason to check those subpages again, no? Am I missing something?

There are two kinds of order > 0 pages, compound and not compound.
free_pages_prepare() checks all tail pages of a compound order > 0 pages =
too.
For non compound ones, free_pages_prepare() only has free_page_is_bad()
check on tail ones.

So my guess is that the TODO is to check all subpages on a non compound
order > 0 one in the same manner. This is based on the assumption that
all non compound order > 0 page users use split_page() after the allocati=
on,
treat each page individually, and free them back altogether. But I am not=

sure if this is true for all users allocating non compound order > 0 page=
s.
And free_pages_prepare_bulk() might be a better name for such functions.

The above confusion is also a reason I asked Ryan to try adding a unsplit=
_page()
function to fuse back non compound order > 0 pages and free the fused one=

as we are currently doing. But that looks like a pain to implment. Maybe =
an
alternative to this FPI_PREPARED is to add FPI_FREE_BULK and loop through=
 all
subpages if FPI_FREE_BULK is set with
__free_pages_prepare(page + i, 0, fpi_flags & ~FPI_FREE_BULK) in
__free_pages_ok().


Best Regards,
Yan, Zi

