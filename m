Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F2BDC5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 19:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6406B008C; Mon, 24 Aug 2026 15:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7E8D6B0092; Mon, 24 Aug 2026 15:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6D196B0095; Mon, 24 Aug 2026 15:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CA816B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:25:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 093D21A0227
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:25:53 +0000 (UTC)
X-FDA: 85137142986.04.32A61E6
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012055.outbound.protection.outlook.com [52.101.48.55])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0ED461C0007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:25:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kWWX0xYm;
	spf=pass (imf21.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.48.55 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787599550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jay5eZFjg4CWyyDc0JKQ8rfXRBb0O6lhKaeWP3PMIXM=;
	b=JM9vZHPCORJjd5XNvEsMAcAKvdl/waC5xe01i9Li4Qc1pXQqa9/5+xaWiu1RISSpNH285b
	rIa9Mvvmrj7/IICOaQr902TTiGql66Tymm9l+Xw+putTkoWtOqzRkx1HYE9FeQMI76BB3X
	T7UKbksaezc5L6tq4kETgzy2F/knE+k=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787599550;
	b=2xkIliLfP5ayqoTmaSFZQajytvMz3iVRgE1bMa6xh/cRNJVZ4Z+SSeTEDa6lcSyJwzrEAB
	feMwW3dIoqxTNdkmugEnjde9ZeSe+v+O0sx2j5+Q0TPDJrdETxwKbV3QmQj/3KTr1wyjsS
	KQgY2oIoB9Lv8oaHYO9bYcCyCzRf2Ps=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kWWX0xYm;
	spf=pass (imf21.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.48.55 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qt18V1qAyvbgZDJnYogMa57Ybvl9DAqRCkC+99o3tnj+riB9MfbWppIUmVh82Hexwy9tPz0mII8c8yX2mKfC6VncjgXye5hM8wz2nonB5IjuwXOjDH/pj8gH/ZITF/tmCIkhFiasUCluNbxnyuVmxWSlNZF4qYmm9TdkSiEOyHEnyrfwVbO/OvVXPMu1fwjks6LZyRPixhCw3SiY8fxP6Za/jQnwvahJL+aRw6aSgTNu8ime8c6rn45bUbtdpavZIo7r4XYQkfMEBViIhfKmlQKwpAL6zCafJ5/MI/VLw4/yTOXGt/n2EKF7tROaZRevvEVnDEkQyv3ILmJZ5dLehw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jay5eZFjg4CWyyDc0JKQ8rfXRBb0O6lhKaeWP3PMIXM=;
 b=tAfwQADHPUOd0va++whM9Fy0pwl2CvaXwH3zvR+HdV05qGXZzGRzC6bPDWpY6RhLf3kkFHm6VOQN8WUhbm//pRWF+xn1mSAsNUhBAhjLA9SalLBqZW5VZpNPwngFpyqBRcuUiSi455RsZRPYbDvz9OQ7TDNSVqr9ObHeOXNuyQKypCpqYtt7COc/xsnwzmG50qLWCONDRrZvtX6atinNmEj6gyCFt3Oef776jsbaPHK36h4JH6iQQENherQZUTBc7NV02LCKzPkcXLfLfeunD6ndrRELisLYhzEL31KOc8rt0fvlQo3COsBUhcjFkP0CKZdEUNMeC/jWVDgH97uSEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jay5eZFjg4CWyyDc0JKQ8rfXRBb0O6lhKaeWP3PMIXM=;
 b=kWWX0xYmigzZkojQvjWQz7BtlVs3s5u7d5+FRG7dJI7e1Hq1nNann4khAe4agglfIeqSMJaviKy/KB0lts7K5OJ9ltBeNZZm2PtcMGLhYyPHV/PYXgp/N3nvcqE5YK9ZhfpGPY5oIwwnAqMxh8uY/C+FgObIY09GQmRSLi2/0novSJWZsz9jq3UMw0LhUqTtGQP2lb80v3kAy0Ue+vLTRak8/e2NEfhG923VsbTVnoC/0mcKR8wSj7uvwdknmTjvhCdoMLF9Cs84Xi3j1OECrUHdTRT3ZXYjfNzjk9cwxg+u9yjWqFa9Lc59/Fu61Se70WeNyRerrcFD+nM0ZOLQLw==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 CH1PPF4C9628624.namprd12.prod.outlook.com (2603:10b6:61f:fc00::60d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Mon, 24 Aug
 2026 19:25:44 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%4]) with mapi id 15.21.0339.012; Mon, 24 Aug 2026
 19:25:44 +0000
Message-ID: <5f4ed03c-e91f-4641-8964-cca0391971ba@nvidia.com>
Date: Mon, 24 Aug 2026 12:25:42 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: Removing ->dirty_folio
To: Matthew Wilcox <willy@infradead.org>, Pedro Falcato <pfalcato@suse.de>,
 Christoph Hellwig <hch@lst.de>, Jann Horn <jannh@google.com>,
 David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
 Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <aoyWln-Gt-yvZQkE@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0023.namprd10.prod.outlook.com
 (2603:10b6:a03:255::28) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|CH1PPF4C9628624:EE_
X-MS-Office365-Filtering-Correlation-Id: e3e72e29-f1b3-4edb-a62e-08df02157e1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|921020|11063799006|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	LSboEcZixpk29s7Q2+HgjWkukV+M75bRusihV8k4EDo6YFaM+4GMFIB/wtJpPgiVKB+nTlGhPGCWMmD7LyZF9XYgkGZQ8cPnP0mm2bz0l+Trt/yFpDIQ/k06FfeHjKCTW0g91ITPuVTbRrFcC2XmSRPT5OMvGVhBPtgoM/pmcFdrU+Hh8UM1hCJso5EBmt3iciZB5B+vV+ZLH95TGRmcaVDTqktiUNN1CX6LRQucAR8qRt9u36nH114lnvH9D7bP7J4id0MXt6kRVqaJVBgBqtqrqBq6RPsdGzRFdTmqYs7aprNUpuZbl2Yv2eh7PGxiag5pHpUyPMZUs+C2GTWSr7J0iC8kC8hAPf0PdaTF9/oAuS/kWFSXLkdI701g5VGNxofdyadkOvh5bf8361l3+On0dZdYoH89ifBphka1trE4CQIsyLstnxjEZ/DTr8p+K0ySU+d2ZzW7LSFSwOogdsacSL/JXC0GJl/fuQFfu6LxkD9KJjz0SGkjiQ3R7XH49lzVfHBwmrpiVcoBjOTAPzE7IdX1GV8lKsKwu+SrDqn47bzheH/E68CvlntzqFf1qwdovKKdD95lGq5A3JfoKHTxs59vIv/2LXajXI8qE8frouB9FD27IdFnmiwup9qaO2HoJvbJmYP0B+ccoVbhUq9emfgnU0EyyZov0xG12dxTo1rgi8kY134fzQCbspRzZ5KtQ3pYAYZ++2Bz64Qt4A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(921020)(11063799006)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WjgwZEtKQmdweHQ3VEF2b3ZzdkpmMVp2OHZxVFpMZXFKWDI3TThjdXN5cGd5?=
 =?utf-8?B?SXlmQXQ5OHhIampWWmVnVDI5WkdTRGQvdVNidUhlMWdBS2VNeUVPZWVYM3Z2?=
 =?utf-8?B?ZFFVSFA2UXMvN2dvUGxCRStIakdINkdQN3RjdUp3SFl6R21SS2REeFJFanFv?=
 =?utf-8?B?K2hUZGtzSWY0RmF2SVJsU0hIbVo1SDkzcU0relJEU3JSZHBQcE9TakxMS3ho?=
 =?utf-8?B?M0RrMVdKZW8rek40YmNkUExQMngwZTIxT3EwTHp4ZW9wcmtXMHdQek5ZZ1Mv?=
 =?utf-8?B?ZHdCWkF5cTJKTWIzWXZNcEloRFRVc3Y2SEN1L2lZUTdMUjFFdytHWnN6ZE8x?=
 =?utf-8?B?bVJlRUFOcTNjWFVOUm8zRFB1aS9oNnVacGx0VTRUK2k0Ni9BMUk0WTk5TlNr?=
 =?utf-8?B?QlZFc2VhZUJWUmVnWmxmR2J1YmVrd2VUUHZadDVVYlJCRUdpTEFqWUc2bU5G?=
 =?utf-8?B?dGJoSW1Ja0lRZnpQSlEyazJ5V2JITWFkS2I0c1JuRGRIUlNkS2xTTmlpRk4z?=
 =?utf-8?B?cTcrWlhrMVd3em5URDJxV0pjUEdnaWtBeEdxWTByWVRWc1RQeDNXZ3ZlcklU?=
 =?utf-8?B?YjZDZFpEbnF2S0NJbkxPODlQUWFCR3VXeFVTV1ZZTkxFTnpvVTNxdDIxT1py?=
 =?utf-8?B?eUZmUDBPMHNrRlBSZCtHb251UkhMUG1UQTRlSjUwVWZTejNGcGNpbS9PM0Fi?=
 =?utf-8?B?bU94RXlBelVDYjlWNm5FSzUwNDZiNmNQdHpxZDNvano0cDNaSGRXUWZXN2RX?=
 =?utf-8?B?Q3ZkdEI4cFM5ZElqVVRkM2NVa21CbmhLelJ4WHErMmZ0eUFKcVcwaDc0aEVZ?=
 =?utf-8?B?dlloL01XeHo4eWpHK0s2dnJmeGdLeXhyZkxCdnhqYnFnUkhHUTg0UDN6cElT?=
 =?utf-8?B?UXVKcnIySkNiMWFNZGZib1VIRVFJcjBJbmlMR0hJeXRvQldyYXR3Ym1RQmhy?=
 =?utf-8?B?cXRIQitHOCs3WTE0TUVUWUdqZEFsejlnS05RWm5vcGZGL0RpKzhkMWw2TVlX?=
 =?utf-8?B?eWtQZU1DVmM3NWRjbkc3YUNKRmVpbWZOQUFaZzhxVWw3c0lqcUpXdWhHNzZw?=
 =?utf-8?B?TGd2bURkTFEwM3g1Y1JEUHZLd2poR3E0VmcyODJuWGhPMkxSVGhVK0pQVFRl?=
 =?utf-8?B?TVZVSWg2bHNWbXRqQmJwNmpHNUdxTWJtSXNsYWZwNkhTcngvRzhzdDRHQk5B?=
 =?utf-8?B?N1NzQXNUL2lGWGFCY3hUcjdRd3d1V3RESTNWU05QU3JrK2t3T21ucnNEb0gy?=
 =?utf-8?B?TlhlTkE1bUd4QnRrNEwza2VoNWVTM1AvRk0yNW5aZ082bnNQOXBzVUVNNmZm?=
 =?utf-8?B?REE5TUdIaDd1eVQrSjRubGN4MDBIVGNMY201UUtzZlRRV0c0eU9zUnJNdFZO?=
 =?utf-8?B?enZTTDBYeVgwTkJ0bUFjNmNZdEFtUlViSlNXdk5FT0N1S1cyTzI5U20zT3U2?=
 =?utf-8?B?SGtuRXdoRnNucFhnOHE5YXFielVLN2dMbWh5ZHk3d1hRK0FyU3YrbGZuSWhQ?=
 =?utf-8?B?YzgwaFZmNVZpeG8raFgwdWtOUE1CbVlhbElFYVhab0lCY09DWjdybnh1Z2ZS?=
 =?utf-8?B?cUt0dzRQbkIva3ZxZEhjT2JzdEx2dHRpSml5ZGFkWS9vd2ZhK0RDUVB4UWdy?=
 =?utf-8?B?NjFhZDd4TldZbVR0YUtmY0RoU2FINE5HVUxPdnBLdHNZNmdYUm1ReFBoM09N?=
 =?utf-8?B?V0pPajl3cGdKR1hXSTRKcnltaHRNOWs3alMzTVpOcXNRQXN4R3lZS0VjdXk2?=
 =?utf-8?B?NkxxYnpkS3lrckFEckxmQmFkQis2VGozSzFlV0EwbDJtTU5UMmorQ2ZTOEor?=
 =?utf-8?B?MndrU1B3Z2FQNDR5U2dOdnhiRzVVcUdGeHVkRmFITjZCK2ZqckwvcFVROXVk?=
 =?utf-8?B?NFNJN1FxajZ6UnRYVkY3K1c0MTV1NTV3UVBkSWcyTHhTTzFFaHNwb3hLNndG?=
 =?utf-8?B?MysrRzZxNW1TYWwxWVMwR3hJM1k5eG1rbEZpV0QrTkc1U3J2VjlCQ1FyVEZq?=
 =?utf-8?B?RzgwQWJiVmtSc2s4bVkxZDZQdVY1ZzkzdXovL1hnaCtvREpYTWVSMzBDM3F0?=
 =?utf-8?B?SnJuM09BdVV0ODVUSGFLTlZoSnNNSWNuNUhNRGRKUUZpNU5SV3ZUaHhPKzV0?=
 =?utf-8?B?NzVvVGkwQytyaE4ybm5EUEJhWWJoUHdLSzRZSXVDZFlVaDVLeHZYVGVjRCtD?=
 =?utf-8?B?Si9CZWhnbk9sWHFFK2Z2RTh3TzFTQ3YwbG5saVQ1RE5seE53UEp4U0xlaTFM?=
 =?utf-8?B?U24rbGlFUFdvdXJoRjFZYTc0S2tma0M2emFhd04wcTA1eE1EQWdTVzZZNWl3?=
 =?utf-8?B?MWswTWc4R3h0eG5LRGFsMTVJNHc5TXhTeEJJblpHOFZ5TytHeDFmZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3e72e29-f1b3-4edb-a62e-08df02157e1a
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 19:25:44.5763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rKH2LORzYQsAx8PKy37tUK12lnfE9EVcfzm0smuCrsm6qJX0utE7tucgkKN7/cHHD4QqU7ZpaIGQMp6COt3YSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF4C9628624
X-Rspam-User: 
X-Stat-Signature: 9du9o86qbntycbjpfjrui7wo7p4i1j6q
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0ED461C0007
X-HE-Tag: 1787599549-838204
X-HE-Meta: U2FsdGVkX19tYwAWhGasZLNuJ9ciy1nUUAK4+0CbN6Ht8EmiQyVum10StP5n6BY36fwk8+Fn41ZXjDqwn//nFRSW6CRZPNMu/F8smdakFLtHp54U7UZ228Zf7Mk273Q4pHj+ysM3aMd7Vw4Wim1sgyTvmWKyZBIGsQ8qO6sbIaBGnvXgNrnuVZ2iP6LNVhyDwvjRzs1754SKX2RiGmGJoN8JnREbcEuE7doSE6fvH1kv7XnHfX1QSZofTFxtMwR9esxHXFsTn6mXl5tf351AGUFjTTX0qx9ZQQNvxtka2XwSkzU+8yCOyn84tYnvyO8MoJ9wHsXcoKzPYgSGiA5oZhAZ0SO1LfAh7ApyPphpvsxphfKxX2Stvgmw6JRgcyIu6a41gNkwq48OGRrbssczv7RLsj//JaBgtwiR8W/X3U2/KzEznrV3zoHAOgy5rlu9UWs6JgvoOP93u6L/nnYUy8d14bhD0Po/94ERSxWzhC7WtwzYEQjrxTWcNKyQB5mRThVoQNmhKY6ZXcULyPOiOWYMsijdHZ2zX4faiDIAXuP5tLiOMYlEd+nWXaSwsihKcbgoI+B/plZ1TSo+LDiWVIK/O+xPLH+Cjd5aWcbGlhg8vVKDfeX5Tzr/Pbb0FGae5bOY092Gg9SKCG/l+r8Vbka3jVmxXM0exEkhiFICt9WicCG5MKf6nZwKfniCo+hzoO+Pj3s8GilvPKg7N2ZV60di/9Gi1QJclWJ4HrCWuL5irtHpctPHwsaqrSfpK6lmz/lvim+v8j32uG1+BfNpOrukrmZ+cWKb+RagiVU1wz6bt3YXxLeZJUWLcfk8O86lDBbknDtgkamoXuiCtIo8lPPlgQlbcRbAf6ZOJG0Trtr2Yy8y3KhcLC5oHheao6zrJlmn2H3Saa6lW4c/B+E1tNyVyQCiaV/RhdDuxBcwKrQYWuDBdIavdeNC09kpclHKSEx1F/9wEZfXQtilU+r
 8fV+NlaN
 fPxVznKtu70+JtzYzRSk8TPN3glCzQDEuPT6X/I0Sin5NWdiyjaCK37PTpc0mG0Kx2pQsCRni/Wd93t7lJCxozk0LJtcD362MBmmkbKPAwDJ7IVuDrR+SPSJMuNuL4yIX4ZiK0okQSWmzK5ybRK1WFTKuFcV2WmlUMe/D6Ya6mZMr8X4Nkm/Eu11zv9Dmqz+M+1o7kyCIbY7VW43eWGCRNoS4qdDDyxbcwiioKofYqkK+jJezIFEindKyPFN3ze40sfbXwSc4f2YPh72GwaoXj6nZUMX6gMOxmNrOBfQxPZ3pYDOuQvEXs/tJCK630xZcbu/oPoZZEbsE2P5yGp0zOeohde/t4Ykmc7ie4HxSbugZCojxMOnbHF5twcVUNELnvxKSzxUX7C/D8jFaajD4kBgfp9gOhlyF2Xux9H2yGxv7dRAz0e5k1lrbrGlXywHcmVGt/o5lcVmTr/c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/24/26 12:08 PM, Matthew Wilcox wrote:
> I think it's time to remove folio_mark_dirty(), ->dirty_folio() and so on.
> 
> This is not how filesystems want to be informed of folio dirtying.
> It was fine for ext2, but anything that's journalled or COW has work
> to do before the folio is made dirty, and it's hard to do that work
> under the page table spinlock (not all callers hold that lock, but the
> filesystem has to be able to handle the cases where it is.
> 
> Filesystems want the page_mkwrite() entry point to be how they find out
> about a folio being dirtied -- and that works great!  Except that we
> can writeback the folio for a number of reasons.  If it's been dirtied
> due to a shared writable mmap, that's fine; we map the folio read-only
> and any subsequent writes will re-enter the page_mkwrite path.
> 
> The problem is GUP.  We have no way to force the GUP caller to go
> through page_mkwrite again.  So instead we make the GUP caller call
> folio_mark_dirty_lock() which many just don't, and generally we get away
> with it.  But it's a bug, and a bad interface.
> 
> There's also the problem that GUP users bypass the folio_wait_stable()
> mechanism.  If a page is written to while somebody is creating a
> checksum over that page, the checksum will be corrupted.  If we want
> to fix this, we have to bounce-buffer the page.  There's no way to
> prevent or delay a GUP user from writing to the page.  Enjoy your RAID.
> 
> My proposal is this:
> 
>  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
>    If it's true, do the writeback, but retain/recreate whatever data
>    structures you need in order to write the folio again; behave as if
>    ->page_mkdirty() had been called again for each page in the folio is
>    marked as dirty.

Yes, that would work nicely.

>  - The MM behaves similarly; we do not clear the writeback flag for
>    folio_maybe_dma_pinned().
> 
> This will have the effect of writing pinned folios back every time the
> inode is scheduled for writeback.  But since we have no idea whether
> the folio is actually dirty (because the GUP user won't tell us),
> this is the correct behaviour.
> 
> I'm probably missing some stuff here.  Let me know.

OK, so working through the end of the pinning, I think it still is
correct: device finishes writing to pinned memory, device driver
unpins the memory but the page has been left marked dirty the whole
time and still is, so the next writeback still does the writeback,
but this time sees no pins and so it marks the page clean.



thanks,
-- 
John Hubbard


