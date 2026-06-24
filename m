Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5C11CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 13:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABABE6B008C; Wed, 24 Jun 2026 09:24:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A926C6B0092; Wed, 24 Jun 2026 09:24:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95B756B0093; Wed, 24 Jun 2026 09:24:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6727B6B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:24:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB8B612034B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:24:10 +0000 (UTC)
X-FDA: 84914874660.13.DC92F3F
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010010.outbound.protection.outlook.com [52.101.61.10])
	by imf08.hostedemail.com (Postfix) with ESMTP id D8E08160011
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:24:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Dc94bJtD;
	spf=pass (imf08.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.61.10 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782307448;
	b=YKFK/f13AdEGhsssHW8ols/bKIZ2bcYLxgBb4Qj5/ooUfAfpWzC0bACwUeuy8I0nO9dCdr
	PF/r3hLd1hPPAQ02tcB5+osEPgDnTUp6gsJtAZ0mCkVhXfv0kU9J39kKXu/JqxdynTW3T7
	HUyafwACCCkgsQz3vxJrZvJdH5m68DE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782307448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d81CM1+AT4WllJ72uDv8AXVKFPVvGK8TiKbKmP7zRcI=;
	b=6ob3sWg6ElpqlcRshEEarnfUwgZdQb8rV3dC64i62du3rczZovC/DS1mGfGCUjW4J6Ik6K
	ytfw1D1e0HwNWenTcGLYSlzlvRq9VieNYGAInNzJecK9QX97q7C6aBkCbFAWUmDmqLNoe0
	2kLGf0re9YrHRSvL6v0LA8eedBm31rE=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Dc94bJtD;
	spf=pass (imf08.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.61.10 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tdaAv+ecVA6DZauEGCo9T7B1nQOcCSUU7hNraj6tRtvtEUHeUQj+rFIXvoWnfPqY2jhC6wTt7R5+xcBY+VelRctKrARIr4wFZbaANqvwzrGcUf8rtxtOhVqHYalcx7RfsOmd6Os93RNh+K5OUkebyCKH5NBEKXytYF2j5Rl+jRyvcQ+Gg7v73Tj8YrP+mR/51jOvdRVdZWEAYjMDLVFBpPhzlgphh9Ezf7NC47k8IaCF0Cb/w30LBjYjWpROP/SPaCTetRgg0ltq47Ri5yeOwV9IFjbZYyh7A9G7Qtv/+Nc4zu08kN5H6K8BBSZyZ3m2G2dF3Zq4uRjqZvsALTPMuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d81CM1+AT4WllJ72uDv8AXVKFPVvGK8TiKbKmP7zRcI=;
 b=sFfEVVxRwsOYnMcorSkPi3qRpCppWOTlauZ7YwzcPjJrepWy2banawSRiQaamujWLzH7Yovh7ENxhyducOetDdXtV1XFbL6iapW7G5HTFQCirdpvpTOYs0YHy+RcrflhBaARVWO1RdbVKvKoyb0fO3BmNMTIBGYfvpvol1u53nhVZ42cRILUOyxRtQ74yozN+rK428+aL8CCErpNEkNAh3+LLelktq5N4ng84SmLdBgXMssQz2zLSrS/mxXQQA3bLevLyLpOyjc+nB7gvgns33sblaC7Wq4xCrlSwG65uV7dd0XfLPQl5XraQD47voUHwmBSQWUTshtT8HLMy4gGog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d81CM1+AT4WllJ72uDv8AXVKFPVvGK8TiKbKmP7zRcI=;
 b=Dc94bJtDtzGF6zztoUX5l/0+u8PChmvdYrmw4RV69JMcqBPpaCuwM6m7FYCD96iE76/DFmIb1NLF2TM8ns09RKOhlAtoUYlKIt5NKISj2tBRmfTa33pXQr/2q01X23GhzczSPuaJVh7I8h1G2u/xxf1sPPYPTJNjJHQLYY2EQXs=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by CH3PR12MB7570.namprd12.prod.outlook.com (2603:10b6:610:149::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.14; Wed, 24 Jun
 2026 13:24:01 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.21.0139.018; Wed, 24 Jun 2026
 13:24:01 +0000
Message-ID: <cf8467c7-b98f-44a5-9cf9-60b43b5da711@amd.com>
Date: Wed, 24 Jun 2026 15:23:47 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] list: Add mutable iterator variants
To: Kaitao Cheng <kaitao.cheng@linux.dev>,
 David Laight <david.laight.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Paul Moore <paul@paul-moore.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Howells <dhowells@redhat.com>,
 Simona Vetter <simona.vetter@ffwll.ch>, Randy Dunlap
 <rdunlap@infradead.org>, Luca Ceresoli <luca.ceresoli@bootlin.com>,
 Philipp Stanner <phasta@kernel.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-ntfs-dev@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, audit@vger.kernel.org, bpf@vger.kernel.org,
 netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kexec@lists.infradead.org, live-patching@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-pm@vger.kernel.org, rcu@vger.kernel.org, sched-ext@lists.linux.dev,
 linux-mm@kvack.org, virtualization@lists.linux.dev, damon@lists.linux.dev,
 llvm@lists.linux.dev, Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
 <20260622040533.29824-2-kaitao.cheng@linux.dev>
 <20260622094242.64531b9a@pumpkin>
 <351a6b67-b394-4c58-aee2-88b6c8089ad5@linux.dev>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <351a6b67-b394-4c58-aee2-88b6c8089ad5@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0270.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::35) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|CH3PR12MB7570:EE_
X-MS-Office365-Filtering-Correlation-Id: 715eed2d-514b-4810-2f08-08ded1f3da78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|6133799003|18002099003|22082099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	vjRMDzmTxaLO3rG//AE977uAg8zKrEwMP6cu1AOblab8SZ491Cs0rYGIPxYvAFRNxWSVQ1WdRjVkW8uINOWaaO1LcWyt/wIKFnqXxociABOHsobehPc8e61s3GnfEfviv/vYUJs1BYtORVJs0+rNk2XGq+ZYcvNpXg6oKMgBd60P6S9UAXXOjUalPunVJcruSBXhU+03Db/ZLAvwRMJ4LkyKp9X8urTD29nI1sVli23YRzfr6f7QlYt1NE8z2tjj+tTOuaopcIYaTyRREeh1LTyJGLjXPTHttj/0qGSJWH0dbU2PQ16weT2vE/oUJQOd55L87wLEkz7iKzhzNzwmoRCxnEYaTxhqUK/d7fhbS49r2+o+otSyW6oXmfcTSEh+A13SwWrC412pRamXap2Sq7vEAcnU53bRd7aSf1zOxgJJbd60qry1G7yF8/wahybuHwktLDMb87yqpcxhBNlskColY6z/ieQl9ZLrsRjxsFjJ4g1BGfi6PGkW4cNzSNGwUDfb3g0kKQ3RXayJ1mvTgK+cHwyZAOuPrNH+rmrGsOoC7gIXksGzl1YSqQT/guiSOvjYJs2VkcDleBwpXa21FkM2F/IXE9BjHNUkTuuA2CqTou5m5AUIIvTJkWTeEcpphCrCfaZcRkBjaZAv/XpqW1HguK/RVMJYVXXsSyz8H8k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(6133799003)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YWxibmFPMnl4Z04zVXpKQXBkcXNhV1dTQ1o4RW0vQ3czTkIvQVQ4KytXc2dV?=
 =?utf-8?B?QlIwYmFNbGQwSVNPbVd3MXlQMmJjZWJNTXA3Z0VRTjZSQnVNU1FmejFKNzh3?=
 =?utf-8?B?ejRvMkY3NHNNSjNSaThtY0xPaTcvNU9BeldYNGx4VW8xZXJmSzJmaWNDV0Z1?=
 =?utf-8?B?QVdzQzZuUTljZUF6UXIyZzd4OEVwRS9oT2pFdWVPNERlUjBrZjVsSUZ4M1Aw?=
 =?utf-8?B?VmR2bFl4aFVEd2dmV2Q2NHNUWVE5d3BVTXQvcVFqR0E3blVnUXJRVUhKdmN3?=
 =?utf-8?B?U251WFF0SlhUc3J0MjdwdXB5UmFFbDRSeGxSckpQSHZ1RXlkTUV4RXZvdkxa?=
 =?utf-8?B?U1ZZK2NIWlB2cFZDUHNxL2J1MVEzRnp0Z2k2SzFCemtvN3I2M0htRUVrcWlE?=
 =?utf-8?B?TjVpOGhaNFdnUFR4Zk5WWGpEU2NObC9WM3Z6eHFsbVRkS0NxZGpENi8yR3Qz?=
 =?utf-8?B?Tmp0cEpqMFcrbnRhQStMV2xWYk1qTHhOdlh4dGtHQWNIS1VEVFJ5UzZXeVEw?=
 =?utf-8?B?RUc4aUtQS3BmMnlPTXVpNVFDcXJNbDRiR3FuWmVVLytDUm5CdFI3dGltV0xO?=
 =?utf-8?B?T25rMFhVNXpCaGxlUjM4cEJUK0ozdXF2SEdhRG9MLzNHdVphcDNGVjh3M1hj?=
 =?utf-8?B?YWozS3Nma2dZMmx2VmdhMmxaTXRVbTByalA5YklaM1hwVk9KNXNyQk1xbnli?=
 =?utf-8?B?eVFxWkIwdTJBckZuZFVsaEllNnl1cFhNdGkzeEdaeVVRckM0V0d1czZxaFRi?=
 =?utf-8?B?MmxjdHV1SjNnQnJieTE4K0w1YmdCK0FQbFZsL3QvcTB3dityclIrdHp2dFZo?=
 =?utf-8?B?WTV5Q043cFNaVm5keXZISjFLZXJzRDZKd3Q3R0pIYzVMZ2tBcDBvaG5vU2ll?=
 =?utf-8?B?b1VCOUV5VnRyVll5Y3lOTmE3c1RNbzlkWUFwVWRtWXdxSllWK3ZjOS93TUVw?=
 =?utf-8?B?dnMyekZZSHF1bHU3Q3kxVzZwWkZsWk9ndjZHV21aYzdlMDV2Q0MvVEFTWHVu?=
 =?utf-8?B?WkN5Qm9LOTZ1am5nL2NaYktHS0thc0FVNEtDcStzMEcrRWY3MDIzdklSL2I0?=
 =?utf-8?B?ak4xck1qd001enVONE1HeHJMc0xMa2tYTjRQTm9vMGZpNlR5WFV4KzA3aUhy?=
 =?utf-8?B?MitMSHc3MnFaSjRaemlZWDFRaXVEc0xEeHY4YlpoeHdxa0xEcjJrajVQYkM5?=
 =?utf-8?B?Qi9ISWE2ODFNYWV1aWNWQ1NGOExiM3E5YzhJODRjcVhOR3YyMk9IbFlFMG10?=
 =?utf-8?B?czFvWVhOd1UzQU1WU05ZYW1odXBrdXpObXZtVkIwcklLa21XNG5wSmphWHJD?=
 =?utf-8?B?aGJOajZqSTVmb2gvdHc0WTQySjlHQ2VIRWY3SHZScW1YUlBoL3ErdDFmYUFO?=
 =?utf-8?B?cTl6WHNGaEtZTVNvVk1sV1NXblB6WG0zRlZnNUVPV3hnSEJYRG10a3RhaXA2?=
 =?utf-8?B?WU82ZjFqYWdGaXZ6TExybGVNWTk2QzJRTlk4SE9WVUJtV1FRVU1tbkZlTnp1?=
 =?utf-8?B?bFhTczlvYUttdEU3bEZwTnp3ZjN1MmxQQnk4MGlMYk9Ga3h0YkdDUFk0bWJN?=
 =?utf-8?B?cWVmR1dWdHVWV1IveHlnWnBla3grZGtqWW85ZkYyQnhWSEtzTlRYa1dhenlP?=
 =?utf-8?B?Y3FDaXJxSkJiUjdQNktaNUpDVFk3eGpUYWNnOWtramhxZ0RWc0daaW4rY3BX?=
 =?utf-8?B?cEtsdG81L1lRNCtiTEMvYTNHcVY4MmpuaFZvVTVySlVpVVlkcTNQajhGb08w?=
 =?utf-8?B?WGFBNERTSGxLc3cvakQzZjRwbzEvMUMvZ2o2SnFzM3RHY1k1YWlYck1KQjJp?=
 =?utf-8?B?alVWRDFVYXFkOVBLRlY4MkRGQSsvb2Y4SEZ2T2pkemZNU3FnVjJTR2NWU2M1?=
 =?utf-8?B?RjVpMjdCemZBWXErMndvbkJkaFk5ZnJRck4yYXU5V2FqVzJ2Y1pjQkhSTUEx?=
 =?utf-8?B?ZmdFZ3lrc2JjL1lpb1R2alpYNUFidDVCNXdFaXdyNk9yWjl1Z2p4Y0FqdEZB?=
 =?utf-8?B?T0JmTk9xK3MwRGxrL0tqZGFWK3BXZlUyNWlITzBzUHY4ZjYzNkw4MW5ZVVFv?=
 =?utf-8?B?NFhsR2tPaEFKY3EwRDJOYlVhOU1LUUtDMVRqeVNCZXdnY2lML2k2VU9tbzFI?=
 =?utf-8?B?WlZOOXBScmUyd3B6bEl2eURzOVB2VzRnLzFGQTZaS1VVd0ZaaVplWExGZ1pQ?=
 =?utf-8?B?U3RTNWlFaitwNVRqREs4c0RHMFlKVjMyeENKbzk4bjIvL2FkRDExcitRdXA4?=
 =?utf-8?B?Yys0Rm5zUmtIRkpVYzVKSEhHNmlsbFVvZHpWTHl3SUZkdkxWNndJUUpENkl6?=
 =?utf-8?Q?cSgurPjmbMLoRmPxTI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 715eed2d-514b-4810-2f08-08ded1f3da78
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 13:24:00.9068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QVhBEK/2F/j8PEv/furwKNhQwAwxU3hZSEqW50n8SOx5hinzeiYl4lrFCu6sDpFf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7570
X-Rspam-User: 
X-Stat-Signature: qqy1yhgdf7jhm5y7tu6z8wqb6uu4fjrq
X-Rspamd-Queue-Id: D8E08160011
X-Rspamd-Server: rspam06
X-HE-Tag: 1782307447-679078
X-HE-Meta: U2FsdGVkX18nuefylU6WQWzFIWUD62Z/2o2EgW0HE+SUEaIxms8zPMMXbRHyTXTSVYUXi2mGXws05xv0HZ75kSUu8jGHaMmYB5fyu+dmr6Ug5mAwosf3P5EHS5kUXbuEstDd9v5ux4hxwYphUSM6H0kuGsKOjf9GpsqFbRD1rZb+1RqSjr+D1JVAK4XULzppL5GKOL9pmksNgre/fU0ygIN7F0JOyC+HZS55GbE2r1wzvwXT7Qni04FQ34ciK5qrUarb9YopxPky7innR90sERjcNkoPaSLxXuEoVPlqX5nIjWhKxPhB1z4LuFfxJETKNgqHz3lXgFmiepe8dxR/Dg2AzQQRox0/+WRyHRnBRWLBer8aXsdcD+HfkQRZzmw0KF20c/AbJNVNE9j8UN39Q8jNJBvE4H8g8fLYW7PZMXJD6Fj3hRMjNrpcOkL6IRXnzueoH2/A5RYIouwOCmXdBY8HhGsQ2GnBxMwXj/w1jy08n8QT2oXtTQ8q/2IAx3W7jZ0khSKq57XuCILshvdxDnBLFRfAncBvQDYsn5sBP2qXvyKmEJOD2nNeGndVoySkr8IOBsbDA38wxoOLXSYvpwf4Fu1/3R3axYgIkGjixcdcFQgoeTrVwTLnqIWguDsZlNCjDJGWFWpZq5dEjT8rcCpX7RcbUhVAAyLYihEYiDiCv8E31eGrqAp9OWO8Mm8A/E25emKtb2LyDLk9V19DBsCz03KI0NfGDkF1FxXkZ8ltiHNXA/WncnmIWEP4XCkHAZzG+bl9qLugPH1dGCtI9MW/8Liml9Ptx+dFUcMtlBgJkVTNeEHPn9s04WerYPI8f0VO8EaX7jaFvAtZR+3AsaXrR7rmavsE7xJHqGbDlqaeZhFN0P+U5t8o3CLkN0W54tF2w9BrIu1f7BfznQpR6mxYRfFNVVlRojQSTYTyNqdJyUxfTHgqqqk5W+Y07gSTqUoq1lvLfKjX69jSkkF
 dte7IeUl
 Nhn2SE5DqI77ZHEtVYxrMTFsGV5wWNdBgnNvkbfvX6jilBluc1GIYaJwc9sIDsSbBJo6XzKipDoy/AhGSQjVBglWmCzGOmHTok5yAqT8FsqVYY1i+gxz/6JyHxWuqzuO4z0WLI1xlfIwcuJWHK7va2d4pE5aevmH2amG7fFqCzyhfN8JBvNvpyoFNx+HsAFV8a5roTPcSGvWYtIcaoJHwV9mi2qcQuvi9mCfhfyrQtdpWQhLb3KTuIABK0H5fOWeKDirjLfW9vBaYCzc4/IQRcPQYZTHUdWp81i1qA0uLCKOUQZ5gYROuSKuje3Zjkm8LDuQJ1tsqGbFZphU4DJZuidTqmO91mycMaDHuwezYE/hcfN3Y+SfTCYk0BHkT845cClCFDEPV3eBnGOomASiy3LFK0RHXIzhHflyRIM26VRrqnoL/46ybhNOirAgq3wThLclaApd8k5bOq7JBalK/0VRgrZ3a4Wro2auWre6Ff1m5KEPDKLsrdloEZJY4KJnYym10BTTQbEBotzl1UEp5KiWHmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 15:14, Kaitao Cheng wrote:
> 
> 
> 在 2026/6/22 16:42, David Laight 写道:
>> On Mon, 22 Jun 2026 12:05:31 +0800
>> Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>>
>>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>>
>>> The list_for_each*_safe() helpers are used when the loop body may
>>> remove the current entry.  Their API exposes the temporary cursor at
>>> every call site, even though most users only need it for the iterator
>>> implementation and never reference it in the loop body.
>>>
>>> Add *_mutable() variants for list and hlist iteration.  The new helpers
>>> support both forms: callers may keep passing an explicit temporary cursor
>>> when they need to inspect or reset it, or omit it and let the helper use
>>> a unique internal cursor.
>>
>> I'm not really sure 'mutable' means anything either.
>> It is possible to make it valid for the loop body (or even other threads)
>> to delete arbitrary list items - but that needs significant extra overheads.
>>
>> It might be worth doing something that doesn't need the extra variable,
>> but there is little point doing all the churn just to rename things.
>>
>>>
>>> This makes call sites that only mutate the list through the current entry
>>> less noisy, while keeping the existing *_safe() helpers available for
>>> compatibility.
>>>
>>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
>>> ---
>>>  include/linux/list.h | 269 +++++++++++++++++++++++++++++++++++++------
>>>  1 file changed, 231 insertions(+), 38 deletions(-)
>>>
>>> diff --git a/include/linux/list.h b/include/linux/list.h
>>> index 09d979976b3b..1081def7cea9 100644
>>> --- a/include/linux/list.h
>>> +++ b/include/linux/list.h
>>> @@ -7,6 +7,7 @@
>>>  #include <linux/stddef.h>
>>>  #include <linux/poison.h>
>>>  #include <linux/const.h>
>>> +#include <linux/args.h>
>>>  
>>>  #include <asm/barrier.h>
>>>  
>>> @@ -763,28 +764,72 @@ static inline void list_splice_tail_init(struct list_head *list,
>>>  #define list_for_each_prev(pos, head) \
>>>  	for (pos = (head)->prev; !list_is_head(pos, (head)); pos = pos->prev)
>>>  
>>> -/**
>>> - * list_for_each_safe - iterate over a list safe against removal of list entry
>>> - * @pos:	the &struct list_head to use as a loop cursor.
>>> - * @n:		another &struct list_head to use as temporary storage
>>> - * @head:	the head for your list.
>>> +/*
>>> + * list_for_each_safe is an old interface, use list_for_each_mutable instead.
>>>   */
>>>  #define list_for_each_safe(pos, n, head) \
>>>  	for (pos = (head)->next, n = pos->next; \
>>>  	     !list_is_head(pos, (head)); \
>>>  	     pos = n, n = pos->next)
>>>  
>>> +#define __list_for_each_mutable_internal(pos, tmp, head)		\
>>> +	for (typeof(pos) tmp = (pos = (head)->next)->next;		\
>>
>> Use auto
>>
>>> +	     !list_is_head(pos, (head));				\
>>> +	     pos = tmp, tmp = pos->next)
>>> +
>>> +#define __list_for_each_mutable1(pos, head)				\
>>> +	__list_for_each_mutable_internal(pos, __UNIQUE_ID(next), head)
>>> +
>>> +#define __list_for_each_mutable2(pos, next, head)			\
>>> +	list_for_each_safe(pos, next, head)
>>> +
>>>  /**
>>> - * list_for_each_prev_safe - iterate over a list backwards safe against removal of list entry
>>> + * list_for_each_mutable - iterate over a list safe against entry removal
>>>   * @pos:	the &struct list_head to use as a loop cursor.
>>> - * @n:		another &struct list_head to use as temporary storage
>>> - * @head:	the head for your list.
>>> + * @...:	either (head) or (next, head)
>>> + *
>>> + * next:	another &struct list_head to use as optional temporary storage.
>>> + *		The temporary cursor is internal unless explicitly supplied by
>>> + *		the caller.
>>> + * head:	the head for your list.
>>> + */
>>> +#define list_for_each_mutable(pos, ...)					\
>>> +	CONCATENATE(__list_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
>>> +		(pos, __VA_ARGS__)
>>
>> The variable argument count logic really just slows down compilation.
>> Maybe there aren't enough copies of this code to make that significant.
>> But just because you can do it doesn't mean it is a gooD idea.
>> I'm also not sure it really adds anything to the readability.
>>
>> And, it you are going to make the middle argument optional there is
>> no need to change the macro name.
> 
> Christian König and Jani Nikula also disagree with the variadic-argument
> implementation approach. If we abandon that method, it means we will
> inevitably need to add some new macros. If mutable is not a good name,
> suggestions for better alternatives would be welcome; coming up with a
> suitable name is indeed rather tricky.

I don't think you need to add a new macro for the specific use case that people want to modify the next element of the iteration.

If I remember your numbers correctly that is a really corner case and keeping using the existing *_safe() macros for that sounds perfectly fine to me.

Regards,
Christian.

