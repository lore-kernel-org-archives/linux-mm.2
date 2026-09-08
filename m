Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4A8BC79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB5796B008C; Tue,  8 Sep 2026 08:24:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B66326B0092; Tue,  8 Sep 2026 08:24:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A31366B0096; Tue,  8 Sep 2026 08:24:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 733596B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:24:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EB1541C1E21
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:24:50 +0000 (UTC)
X-FDA: 85190513940.01.A81F40D
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013003.outbound.protection.outlook.com [40.93.201.3])
	by imf03.hostedemail.com (Postfix) with ESMTP id 12DB720002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:24:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XJEE4hwY;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788870288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/JebeRBM2yWEvaAKT8yxwdAismABECoKt1r+3mPM4Bs=;
	b=YXJ+jAh3nJSUqatB+j3wdpKoDhkU8W2M9/sjNtSQUYmpfWzOxHps9XvhU5Cwl4EbV9NLkJ
	kEruJoBVr9uj+cOfC72ZgAfmdqJrevVOtvHbc+mRdPNtUKLRzuwHRCpYZNBJusUVd2+i+y
	eWN7F3UywnZqUN1exAq1xJaGp2eAaBA=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XJEE4hwY;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788870288;
	b=RO4TE8aXGcVEK1gfjnyeaZnhtyMFekMHg3k66oyqvKjtbN7MuJe8++A/7AyeW00Myleu7U
	IEmE1E5SHTuUmyLdoP2n4XTIc60sMm7x/xVtCpt/QPUv52AEEw8dPkmMKAVwitKoSIi2WW
	4Xj0D8xMHsZP2cI4ZKB2cfcZLSu8bVs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FC6en/IlDpR7GllTXmD9mU8qRWQnLQDSpHRZI6z1hOTWk/U4IFuUnOxprD+So1QC5fmfuvSK8jvAXo5BBO4L0EKrLx5Ayk/ehe06XtxGKfBE3OGjyLQqG/6j5TcQUGKHOo+XqjumFFrNCWg5KxMfMsHqcqXbP9gqr3Ejf+D17pFL3gkgrfhpocTsIC4esWi0kvUFcw8gPwUpv9mp8A/4HRr8GOTafYtG3Io8X5YxATmOkySpBoGq6wNWO9Eu0CSOWAzSgU5bXRSXNVpDqkmT02Z4Va4/R8xKwH+69yTHQk0i9aeZqP8jHeYJTQyl/0HMfGbcEINCyy+iiIeUnK+Sxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/JebeRBM2yWEvaAKT8yxwdAismABECoKt1r+3mPM4Bs=;
 b=H621W3PAcT7LNa93CSZLvfFtArbcvSn0XMz00EJI8D5LeLQmF+bxfW62++WRKBWBj8//MwahJeJOF/aPtO8FouWCLX2SicjlBc2iJGVsEXN+QxRN11B8on/AFXHft/cZQ+uuxsIS7ltM5kqi9OH4KCn49HorxvfUWuz9eA2ReHAMTGDV7syaukPxIiqeQYH15BQCswaMX/XbXTe0F4fHYQnBwp+rPD3BfHFi2zf1v/q4gkAhPzcBYIHQLBt9Ue8/ustEKzZMZOWn8aZENWADEJfpbdGIwmhxqVVYg0o6BR7hjY76cl1lWDPyEctFDvtTCj6HzjFcaA0bwXGrrJiIEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/JebeRBM2yWEvaAKT8yxwdAismABECoKt1r+3mPM4Bs=;
 b=XJEE4hwYBXiv5bxcOYDW/bUS65Vj/lZsebd7flDuZMA8XZXlZLjnX9TzMaRwZPjKqMnc6jWvAlZe5Tb7BOaMf/2DPcUqNTO/bXWF6FwKPMgSwTynNqYyZ0gGx0JRhvSgu42OCBtYEMmgNll95LzJuC5eO3xD+OI69tnzptKe0cOkyUR6RfAN9s033mxUHf5ysCpqShiD9Ti2KDY9LJHDUxWhkEPizwfE2w5P44phxT7APqR83BVs3DPSvV8MfWVCxGXRliymenKDw+XtWxbCqqv6nmmRTRr7co2Q55qpMaa85+t8KOcbZRnzr8SOj6UoNL4L94/JoeHhR7ePSxzR2Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB5594.namprd12.prod.outlook.com (2603:10b6:510:134::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 8 Sep 2026
 12:24:41 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.005; Tue, 8 Sep 2026
 12:24:40 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 Sep 2026 08:24:38 -0400
Message-Id: <DL9XL8T6UG93.1T1NSJMI8PISK@nvidia.com>
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Cc: "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <liam@infradead.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts"
 <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song"
 <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama Arif"
 <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Mike Rapoport"
 <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko"
 <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Hugh Dickins" <hughd@google.com>, "Nirmoy
 Das" <nirmoyd@nvidia.com>, "Dragos Tatulea" <dtatulea@nvidia.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
To: "Johannes Weiner" <hannes@cmpxchg.org>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>, "Nimrod Oren" <noren@nvidia.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260901190123.3511535-1-noren@nvidia.com>
 <d202dcc3-d7d7-4e98-a9a5-3137cfbfd041@kernel.org>
In-Reply-To: <d202dcc3-d7d7-4e98-a9a5-3137cfbfd041@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0203.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB5594:EE_
X-MS-Office365-Filtering-Correlation-Id: b6e8e776-08a1-4486-e648-08df0da427ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|13003099007|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	q+tCZhs8EdEpG6weRS16+MNVz1xtKbeWznGKt0pMVoWX0GJvC8EeoiSmAt35t37tsGdlbK5N0xMEiY/5FGQQPLfBJATaERGbaWTua2pk2wxOV+vgcv9OlSLzLfqO0F2mY1iQwLm9/IvRqA2Em0kQjX9/ZOftkXINScx+mRtWU79nuNIVCoz9KvJBr4sD+Q2pXuL/NA+oW7GoatYWoyX9RcQjHLqBqwN3vaQn6H1LfNpdKcInlQo/Nh8dztIKmvSx+uOYvnwtbf4jHi7A9q9OSzOLlYR61rEDLgAaBieubgSOYSWnw6eUHct3yEQ2AsRPp6NEn2leLFQ8UqmF5kZXJHMDKttUGuCqR67N12AcOht+TNG1Fu5WSfCPKiRjJJXbPUpxI1grLKoNEHL/1XeN8hMirbFBIR6vq5Y014vnYjlFewkRdxbQZp1148Ct+rK5C+5FzjIxKLKUuP7yVjTXoYyKEqKnrWfHnDH51LFYqsjZMJgfvckArRZljtEfmEumEXpAp2EfCUT9PThSGaG8pEKrnvrHsjz72jHvcZ/6bF/x+JVjsgeJ8TkQRdVzydR30UpZlzETkZqGQkIfZgqe+lQ5JCCp0F69/potZ8Yt59p4zsgUy+sLOGK0qF/I20DNVB+VVYiJTt3uKI/D1IMl3Xo7AUxSrJHZR4ZGR1uXh88=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(13003099007)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c3FGNXVrb0NyRVArUW0wdEtjUGhTeWxhRlpPbjV3Z2k5TU1JUmlPdVlVbTRs?=
 =?utf-8?B?REI2REprN3NBeWowMFV6d2QxZFF0SWUzYXZWZmxtZTIwN3VBa3I4VDZLaHJo?=
 =?utf-8?B?OTRKa2F6ek9GRVIrUDk1OWV3ZUlVYlhhSUJBQW94WUdDNzNSL2p5MTVFQTZH?=
 =?utf-8?B?UUJ1Q2QwZmhWbzgycERHNGJRbEdNVUV1R091M25wWFRYQURuM2FuZE5ZQ1BK?=
 =?utf-8?B?QzVySzBBZkl3eTdBT3ZYMlJ5a3hvclNLQVBEbWFBdXNIT3FrWVBDbjRNdzBT?=
 =?utf-8?B?akVLOUErOVF3RTVybHZIdHR4TEdodWpPZ3hjVjUyc1ZwZVV0cllYTXBmcUND?=
 =?utf-8?B?N1NDOE91QldqS0s3Si9aNmdEU3MwUUtaSXhBYW5iT1VibWo4SncwUFA3bnUr?=
 =?utf-8?B?MWVuMDhnSVFJeWQzcUp6cjlYY243bmd4aVJPU2YzazhmZm9vWVJTZ0p3QVFu?=
 =?utf-8?B?OWRVbnViZjdCVmQ3QlpxUVdvbkg2WHhiZmJqRHVYWXZ6QTJGNDF5VEhUY1Rh?=
 =?utf-8?B?bGtLR2g3SkdKOWJXNmFxa2JRU1loMUJpbndueTZMWFFIYnhqZXlxbWovazZF?=
 =?utf-8?B?QXZadWlXeWNVK0RzTEVQajBrMHoyYURSY1dWanhrNUhVYWxoWkVFZ05iNGdP?=
 =?utf-8?B?TW9BOTZnZTgrKzJnZE9GWlRndjN6ektpRG0zTVUxMllXY2RwZk1LUkdHcGFI?=
 =?utf-8?B?TWdSR25RMXZaRjBqaXVJWXRVU0RkZ3RxZFlpai9xcDJlcW1oK0NqVW5FMm5X?=
 =?utf-8?B?UUxXbXMwbWJMcGpLMjNDVVNEK1VFcjgwYzk5UjVhYUU1cEVlMURVb3hhUHV2?=
 =?utf-8?B?cTF6TWZyYTAxaUc2NDRRcU1naUVtQ1hsODByVk1jQW1Wd1h3Q3AxMEFtNnJG?=
 =?utf-8?B?OVB0WGxYd3M3bGNSVzNyc09XM2VFa21UeTI5ZW9hS01yejUvaXhObFoxcEov?=
 =?utf-8?B?MlM3bTdmajRyYXBPbzdJYldSWEdhbkVQS3RwNHdWcTNMWEVzUnQ4SEN0eUda?=
 =?utf-8?B?Qi90cytZcHFUcUxkOWJibXdETkN1QUZHTUtRb2FZMUJkWndtTXpodC9VQ3Jr?=
 =?utf-8?B?RFN6eXYweldVVnVwOW1LRk9hdStiSlNRN0Y2WmRiNDUxZU52VXhKZHQySWsx?=
 =?utf-8?B?K2hHUzNjUlZWQm1paFJwVm8vdldSODJBY1l6N0o5NHc5dUxFdWVkRUV2cUxr?=
 =?utf-8?B?amhwRnRLd1UrM2x1U1dzYnU3SDE1UTd1QVpOR3RmVmhoNlgyaDBlTFd0UXdR?=
 =?utf-8?B?bHJDWFlGL3lmWG5mdnU2YVYrbE50K2IyNkNSeDl0TldqRGJVaHdQS0ZvcjJK?=
 =?utf-8?B?U1RyOHJPM2djZS9ZQUFLOEd5V3VHN3BDLzY5dExtc3V0Ym5NRzdCOStZWDFt?=
 =?utf-8?B?Y3NjT2ZQVGQzR2hlL2ZtZ0FKWWNxcGpVTTRyV01TZWlPc0x3d1RMTVVBaG1T?=
 =?utf-8?B?ak9SZm9nTWd3WDVLYVZwT3hxek54MmNFRGg5QThRdlRmV0FzWTRNQ1Rac1ZD?=
 =?utf-8?B?bDkrSXppNzk2OENwTHlXN1l4M0FSV05FTm1uZlMvd2ZwMFg1clFxb3BWTWcz?=
 =?utf-8?B?cW4ySE54Ym9UbnBSSlc5K3VPM0t0NUxNaEd5ODhnQmRNT21jeTYvVDNsd3Jz?=
 =?utf-8?B?TTc2enFhZEpNSGRJT3pneW9IT1pHMDR6cjFFc0xpRTMwSEhqSnJSdFZjUVhM?=
 =?utf-8?B?ekRPYWhyampMNENZNnpSNGk0bnZuTytWZjVRcEF1d1dEZWVmZXZvSVlWeUtw?=
 =?utf-8?B?T3N2ZWUxaXdocEJWNCszTFhZK2NzQlhxRlFyTiswQ2s4YW9JeWJjcWVtWnRQ?=
 =?utf-8?B?VDZWZHJudGtIbHp1R09OM2FXbUtEZnhHY2wwaFVYVVU5TzUvM1RkejZDSVpM?=
 =?utf-8?B?YjhTMm5nSmdCUEU1cFdEWEZidnd1dm95enNZL2tETjJYbTFCTEVBVjgwZlEw?=
 =?utf-8?B?ZkJSR1A1ci9iMTQvdjBieHEwME9IdkxPY2g3bDd2RVQxZ0M0K0hwTGQwRExt?=
 =?utf-8?B?SmtUSlErYU1sSFRJSVByM2dQK2Y3NFE1SVpaODNoZm1UNUJ2MnpFTVVsaENp?=
 =?utf-8?B?VmVtZFd1bDBVYy9laGd2ME1aczlNeGk3MzBzcGJuTW94YzdkZWFldTN2UkVY?=
 =?utf-8?B?aVc5TDhWVGJ2ZXN6UmI4S01lZjFGSHpWNGMweFlLdUsvR1FGNVA2OWJXbnRx?=
 =?utf-8?B?ajJjNXhJQkdWSWJCaDd1c0pJQ3R4Z1F3VWVqY21LV2JxWVh6d0xwNmM2MEtW?=
 =?utf-8?B?NW4xOFhzUFRWNTNBUGNLNktYYjdyT3JFb0RNaGVHYUhjbGZ2anJxd3FvQXps?=
 =?utf-8?Q?LRxEE0PjdtFn6O/hPy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6e8e776-08a1-4486-e648-08df0da427ed
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 12:24:40.7542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oR742Gfik4y/agxR4YiuT0hd1N5vVxxGynIw/g5Yqbix4dFRfDBSgBc/4+iNYcg6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5594
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 12DB720002
X-Stat-Signature: guft9cm9n5n4jwwnzdputn479wisx8sn
X-Rspam-User: 
X-HE-Tag: 1788870287-697646
X-HE-Meta: U2FsdGVkX1/KNSudT9WNQHbVfVN0fuaX7TeXNB4HhiGwXTw7wOpDnXvUQ4MMUYahgPzuxREKiE9C2+zAXovv7L+csk0y3Tncch5ZsCie3Nj8167LsrqUZND4+bzkRpordOLkRYE4DB0oee/YVd6Efr9IKptbFEao+wIn9Doi87Qbt9AKzT1otRQjOhpxEWf4W+KBqj7f5hZMW7ckEgPkLUZUzdEclus5LJc1SKH6JkPLh4AmsCuf4KOLNgcxekkb08q+tsJxVC6bdpV+0/0C27KASMjkNSCNJd6XItmqQQDAcuT+9TyvG9Jpk9pUqNVDHQDgLJ7EEzd8b2W9U5elKiVOAQy7zmHAPOowwbAkpp/PcawpQlE2zFx0yH2GGCaOZBY+eZsgwoFo+P8UefQDzCwlsUQQEC82exH8TRyJS1dw5sdI+CqZxXGBJTYkUMcfOdwbwTsNp7lnz6hUtLxDY8CGMSswRAJBZAs5FBqgQNZpJUWENRIKamG7G/rYFtAHuA1NpsX8z8GhIq5nkpu1UHwQI28IF1pNYevzOLZis0s5UVD6gL5dTYnnNoalYpl6gI9gJhUeA0I6yJkdF8cCMeHZKCS0tiw2jzdnV0fsbIot4vPZ0/paIR7pb6U/B5FeO/BdqTRhlXKk4XIQ8tjtma08/Pste8sx4gqFN5z1dtyyWKwJoLpgvSkfB7aO2Iv1B8ena51zY6zwToyH7UuHqlUky+rWrB+eQTnhueuARfJbyQ8yZ0tDw6BJkuxWtGoHDdvhxKlCsPtyFkkPGO7xJ8SuCZ/2fx0fAwrILTWHP8hA6ewxF+hOcFkczbFQDDl+tGYKKEjCQi3wL5/xjHyVh3zv1x8YRpLDO6vqC0aOa5KalAr4/ql+4IpTbILnjpfey+frKpB3tDgmv8DJW61N50A4uzWBb6+5qusGisrcPJgGzGShCFk1I6gZQcOe7UwMU4RL7L5DE1/Z9/3qHXX
 1jC/HHxt
 tZzbyEhYognSoERAS/iNzuPpdo5HMj6BgMaHDNyMgvym2RLkPDrIMHFT3156K+EPkgMQPrfYu2K0drusMvxMI7uJMe922lyIZdOvMxZhP+hUN3uoMdb4Bbl7CrdtczL07+89dMNefNq4dW/bqHNmWM+ivJzA7ZTlhJwiHJ4rwGFg9cnbUP1h5JjQteS2W4iqomsCzlVCA8vtU4forvyKO20/0alUBzU13R461MYyrtT2s5VyqaEltGAvJa/oFjlCDjDKdN+C0sFOsu1iM7gOEfsilPbMY67SQLpuMdeaI5vwyfCyBZZkaCoBnRZwp8AtMHsHSQRZLec1i73JRajmHvYSwd7JvS3gzlSI6OQ7wWKNlJVT5ugd7cjjir5uGvRcZhvQqO0XY8daKPeANSLTiP5yRtmy0z+YS2c+JYE/XDZiaftSNLDPEUOzd0Ld9SOLJy9/mrXUgBA20piD+uHYO2uaXOpDIpjdAf5q7ctVl0d0K9AQCS5ETi+iw7euM3KsFwr9c7mrBeM+WT+N6NcDUpOAJ7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Sep 8, 2026 at 7:54 AM EDT, Vlastimil Babka (SUSE) wrote:
> On 9/1/26 21:01, Nimrod Oren wrote:
>> When THP is enabled, set_recommended_min_free_kbytes() may raise
>> min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
>> Commit f000565adb77 ("thp: set recommended min free kbytes") added this
>> heuristic to help keep pageblocks free and reduce fragmentation for THP
>> allocations.
>>=20
>> The recommendation scales poorly with larger base page sizes. With the
>> default arm64 pageblock sizes, the contribution per eligible zone
>> before applying the existing cap of 5% of low memory is:
>>=20
>>   4 KiB pages:   2 MiB pageblock,   22 MiB per zone
>>  16 KiB pages:  32 MiB pageblock,  352 MiB per zone
>>  64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
>>=20
>> Even with that cap, min_free_kbytes can reach excessive levels.
>>=20
>> The automatic min_free_kbytes increase predates proactive compaction
>> and many subsequent changes to compaction. Given those changes,
>> increasing min_free_kbytes for THP by default is no longer clearly
>> justified.
>>=20
>> Remove set_recommended_min_free_kbytes() and all associated
>> recalculation paths. With this policy gone, min_free_kbytes is
>> controlled only by the page allocator's default calculation and the
>> vm.min_free_kbytes sysctl. Users who want additional headroom may set a
>> higher value via that sysctl.
>>=20
>> Link: https://lore.kernel.org/r/20260831075635.2244437-1-noren@nvidia.co=
m/
>> Suggested-by: Michal Hocko <mhocko@suse.com>
>> Signed-off-by: Nimrod Oren <noren@nvidia.com>
>> ---
>> v3:
>> * Replace the 1 GiB cap with removal of the THP-driven min_free_kbytes
>>   increase as suggested by Michal.
>> * Remove all associated recalculation paths.
>> * Make min_free_kbytes, user_min_free_kbytes,
>>   calculate_min_free_kbytes(), and setup_per_zone_wmarks() static.
>> * Drop the now-unused declarations and khugepaged's page_alloc.h include=
.
>> * Drop the obsolete v2 documentation addition.
>>=20
>> v2:
>> * Use a named constant for the cap.
>> * Drop explicit linux/sizes.h include.
>> * Update min_free_kbytes documentation.
>> https://lore.kernel.org/r/20260831075635.2244437-1-noren@nvidia.com/
>>=20
>> v1:
>> * Cap the final recommendation at 1 GiB as suggested by Lorenzo.
>> https://lore.kernel.org/r/20260728202014.2517142-1-noren@nvidia.com/
>>=20
>> RFC v1:
>> https://lore.kernel.org/r/20260716173504.760369-1-noren@nvidia.com/
>> ---
>>  include/linux/khugepaged.h |  5 ----
>>  mm/huge_memory.c           | 14 ---------
>>  mm/internal.h              |  8 -----
>>  mm/khugepaged.c            | 60 --------------------------------------
>>  mm/page_alloc.c            | 11 +++----
>>  mm/page_alloc.h            |  2 --
>>  mm/shmem.c                 |  7 -----
>>  7 files changed, 4 insertions(+), 103 deletions(-)
>
> Given neither of the patchset versions achieved universal acceptance, cou=
ld
> we try just disabling all the automatic (re)calculations of min_free_kbyt=
es
> the first moment the sysctl gets adjusted from userspace?

Sounds good to me. Johannes, WDYT?

--=20
Best Regards,
Yan, Zi


