Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20CC8C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D9FB6B0088; Mon, 14 Sep 2026 22:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B2BE6B008C; Mon, 14 Sep 2026 22:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C99B6B00A3; Mon, 14 Sep 2026 22:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9C106B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:13:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1200B16029F
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:13:33 +0000 (UTC)
X-FDA: 85214375106.05.9ED4285
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011049.outbound.protection.outlook.com [40.107.208.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 26005160007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:13:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OoaANltP;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789438410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F17wByKd8svqGXYvVX5yqWhs9EXaFnB6+/zLUYkf4KY=;
	b=y238q/Jn8hyDTC8v3JGCtm3C2Kai2Oqkfjah82PNoEvRfnz4gDfDSLsGo1FkwyeZQ3ndJP
	jFdDzj82ixSIJJXaZ/b0STr9QbqstIoLbnDW/CADvUGzfmrXnkPTzNVrOyVhZ31RORTr1+
	J50ZpfC/jVfh0WARCZP58p++lALGF7E=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OoaANltP;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789438410;
	b=1BNfZpleIMHnxkCbtSEHxi0+/irmoOM929AywS1pVDjeD6iU6Tij9TxPRth/OUebzFCCIv
	hAL1EGc2P9WWfJKA6ujPHJPojEL0R9GIioCSa3/GICGiOAfdVEj7q9NWHBXzuGCFrvEZ54
	lx2XxbI/iYdmK6rO42Djd58kW1/lblg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YViOoxHn9ZL5AcWD8KzI0VWPNIZDT5lWBUKi41X/IIwTBzo9+f5prkrK/bIbjz/H6No4t2JCpkRAtKeQUhFAGpI3/GdsL3bRB7RXCXQ8jlHIiFEOji2OjkZ7MNPhzUyZ4oHCVw5RqwA511h9msZ2wgBINElwr9/68WoX3taoa1PqvsVAabBaKbytIarvK5u/xuk3Wn558min1FIyb1tBkHnhsTOEjgYRDYr4YW34UzR8qtcUHdlrFOwLD/cYDXgD0ckQ0HehzpbfzgUVlo7mvKdFva1ixeC4THEt01q77ZrTOkqZIRo6corkqCTU3/VU4DESTaVn48QhL2z98rSRPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F17wByKd8svqGXYvVX5yqWhs9EXaFnB6+/zLUYkf4KY=;
 b=JZBFf2WYfqCpifGU4L1fwiArN/Vf29HKY4WYmH720t8kNzGdcez2KdJ0pakgdodPgFdCfCNBZfwmwKMULwGWLEPHa7fic8cEbwT5xP2+VovbMxFvvwKGwUgutAmVJvUTuV0efk6sqQiaRrodMikXgC5h72StvveJz+VUN+fSi/lFFwJRttYgYDIHxILbgmC/fbPhykHPkOUR3Oyvrb6XtD4zm5TnAlDOFkJA9tIZ7qhdntFjbORykPdtkKD758hRnmPiGfv7LIwmcfKZNGEHb6huOw+BlpVImmLExI3/mNl1KXwskSStiVkI2+CuYa8ZiQHodu1P1OXG0uQwB3hbgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F17wByKd8svqGXYvVX5yqWhs9EXaFnB6+/zLUYkf4KY=;
 b=OoaANltPW1fPocGEHz07nsXu6RI/7JhJglEhUdz1cH9MrEWYlIc38/vhgPNhGkv6xrATtj/G9A74X87mBzQRs6N18OX/1G1VuO7aZa18HIVEitRWabVaT1b+7+ATwLSA7CbDm+4BEi1KC9rweJTGxG8+RASBtYgN0PwMIS+m7QmRytHXdPVRbN3Q9ELTnDnSLjGzaIF99SQGDMYziONxOK8yxTAxNQTaZVdYlW+H15FDt4880vq22qd+c7jV5ydXT+D0xJSLosADv3Bk+wxlzXiLD/hZRStC2WeW6lyi0AdOoh3k6BbSqHJ1dOZoV63PRqXkyVU0Hy2D8rSO8I0ISg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS5PPF5E0E7945E.namprd12.prod.outlook.com (2603:10b6:f:fc00::650) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 02:13:23 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 02:13:16 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 14 Sep 2026 22:13:15 -0400
Message-Id: <DLFIYY1VZWYD.15RG8EIQ4M749@nvidia.com>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>,
 <linux-mm@kvack.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Gustavo A. R. Silva"
 <gustavoars@kernel.org>, <linux-kernel@vger.kernel.org>,
 <driver-core@lists.linux.dev>, <linux-hardening@vger.kernel.org>
To: "Kees Cook" <kees@kernel.org>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 1/2] mm: Move default_gfp() into gfp_types.h
X-Mailer: aerc 0.22.0
References: <20260914223212.i.829-kees@kernel.org>
 <20260914223219.901347-1-kees@kernel.org>
In-Reply-To: <20260914223219.901347-1-kees@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0265.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::9) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS5PPF5E0E7945E:EE_
X-MS-Office365-Filtering-Correlation-Id: c0021f77-47b4-4720-27b5-08df12cee783
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|23010399003|376014|1800799024|10067099003|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	tuIm/3rRzQ9A9LEoQM/oUPlzk1hfmTRDI1veQ9Yu7EESWGWwRhKDLdXHd2rRz2EFAOuIsT9VBOoGfQzrao5oMuOwQ/CQ7LLAtUS4ZRZd5tco1isZveW8dMxW312D+s+OJ09K5OKXTcboMgXMFIZf0XqVLl3f4O6EpjrajpYKIT425g4uPJeu9st92K87QBhzlrpg2+n4gbq1c1MfAYTljWTrnBQ1uvpsYH9ZORlX6UJvuMySHwGyo7R21eejl5tpWlXCxONbL9SB6y7uOG9quLAaDzIqxlLJ5dGj3/tVEZIXcO6o1nJ58wAFW/FRpEapwd+7sQUEhSZzakhQyMnMrob2i0g4l926I/e5r/lNk2lDNH/TDoRDNDXK1x/MpfhKahSC+McFmLIAYnoBu/PM2+GlnLFinuZ2drqozZnYkeslqhpyRvt5+rMhEcXN9ocQzDGIvlZm7tug2J0qUxIloqSdaZiEPPLlbIdi6MgOcp6347wfxrEHrybyhY4WhX57ZKSS6B077aoshzhv7E8VMuHY2RS76dRwWxASN5CG1FxaCm8lHUmQJvKIqIfwdhebWx2AlAwTz6ipHfTlWbJd/bwDao7CXB7h40tM8cOJWF+47ElUZe0ZpWoByxr8XPo1NSKaw+lnZT3RhAvtFqDKW30MDlsgzmHshA1VLyrh+qE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(23010399003)(376014)(1800799024)(10067099003)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aXJkcEM1c3kyS0hzOFRlT1VsejhZN1VhTjd3ckhYYzZ6OElMbXU5dlV6OENW?=
 =?utf-8?B?eEZiZWdMQVgvSFRlTzQxLy9aYkUvZ1pOZkF0bWU0Ui8raGZGSW9lKzBIRklJ?=
 =?utf-8?B?MnYvSmdDVDNPQ25PSFNNZzFNL2xRclZKcy82ek5IMnBEb3FBVXhnMDhMVzZu?=
 =?utf-8?B?S2NZMldDR2JURzN3dkM0MUl5U1lHMU9HMjBJWXFrU0ZzR2tJSDFFNlZSSXlP?=
 =?utf-8?B?UkZESFVmUmcrdEVSU1V0RjAyYWNMS3UwU3lVeVh1MU1ldDlNOGNnWFBPUU5q?=
 =?utf-8?B?SDA5WjRpdFdRcFZSUnp3dXh4dUFMSUoyYXJtaktSNVRpSVVYYUhYQlN4Q1Qx?=
 =?utf-8?B?bDZjYUptWFJGeVdKR3g1dW0zQ0JjWWhKUGx1U21aT0V4MG5jdjh5WDhMUmpU?=
 =?utf-8?B?NDFERzdvbXdETlI0T2tPSm91UHZrUHJ1WEJEc0NBNXN4YWk5ZS91dVowL1FZ?=
 =?utf-8?B?QjZ3UnNGekNBRlR4MHFXSWdLS0loQUdicXh2emVzangwQVFCTzcrQ3F1ZlZY?=
 =?utf-8?B?WHVxQlBZZGpxSG9nM3lxbm5uSWtkdDNMOTFDdjJONXVnVEFNZG9jQ2ZIdjZh?=
 =?utf-8?B?SGlzY2p2ZG5GUkZyY3B5cGpzZURGQkpXRGh6L2swQzVTS0VRUUF1dE1tbEZx?=
 =?utf-8?B?NEcvOUlGMnNnS0U5YXNLVUxDV0lDbmpHYzNmSVhlOGtCMFh3OE9yQTl1ZW9K?=
 =?utf-8?B?KytrcFJKdVBlUUlqWDhYRnJvQjR2MlVGYnB6bWZia0lHbU9Zc25aNGQyVFNo?=
 =?utf-8?B?ZXRMNWlRR1RDSUZKbkVvUDM5UlhCRExKVnZnN3NVdkVSckZvalVDZ0NjZzdS?=
 =?utf-8?B?TnNncllTVXRwZHQzQyt4S0RwZGR4QkovQnJ2K1k4NHlqQ0VnWkYvakNHUnpr?=
 =?utf-8?B?Y0ZnSVdITWZCaGhNTEQ1TGRmUXBBeFlYUkV2VFFKR0lKNTRGTjFTU01PY2M5?=
 =?utf-8?B?Y2ljRDNaMVNpTmhTOHFRT2NTTEtWam80SGxSUFNuQ0dEN0Exb2dEZ1lVTVVi?=
 =?utf-8?B?bnkyeDE4YUVXZTlpWStWNnhjTitHbWtOb1huUDhJTzVFekp5QSswMGk0REE2?=
 =?utf-8?B?VGNBelJwelBXV1hyRy9uVjR0L0ppV0ZsS2dwUjZkZkNNY25JT0ZHTWJROUYr?=
 =?utf-8?B?UkhyaE9mVzJVZ0xUUGhqaXd2TmUvNGNOSjFWWFlNOVVxZnV6NmY2Y2VFMHg2?=
 =?utf-8?B?bjFyTWthSzc1a2hIcWxKV0ZQK01VSzY1bU9XTm54SXRTRENoaDJxZzFURURV?=
 =?utf-8?B?bVlMOGRReUluWlFkM252dDNKUTdqRGZzRit1Q3lDTHc2RzJ6b2Z4Y2N6Z1c0?=
 =?utf-8?B?c0VTK0RjcGxmb2pmbXY4T3dHRUlXUTdLNHdOR0JJUGIvQ3FrMWhZQStCSU1J?=
 =?utf-8?B?Ynk3c0RaWjl2MXkxK2VCTFZqOW5ZSU1QVzE3d1hpVGRPVGVJNmZtK2M5RXFi?=
 =?utf-8?B?V3RmeVJrbDBwTWpsMlhMdkZ5d0phNUp1TkdGM3pVK3dIeGp1a1dlaGJuZWEr?=
 =?utf-8?B?dlExR0czUUxWSk9CWWNHUkR2YkRVRzFEYlBJZXZZbzFaakN1RzA0UEFmSE85?=
 =?utf-8?B?aVRWKzZoU200YmwyZVBlVTQybUI4aS9vTjZrYlJ0YndiMzNlVXFWWjZCYXJH?=
 =?utf-8?B?UnNKVUhnZVk2bTdrdUJQRkR6WkxzdjJ2Um11aDNpVGRqS0svUjR6bXZ5cnJO?=
 =?utf-8?B?aE1TeGdlbHpuNE5kS3p4RkxDTlllVWpCOEhWQmpQNi80S1lUdlRYMnBPUk5T?=
 =?utf-8?B?MUptZnBxd2R6VVVEcXVEMFdQUm9SRVNQNlg3RWVBVjJNTnEvMUJnNHJPbzJs?=
 =?utf-8?B?RTRFWEJhUDdVcS9rRHp1dEhTRFJMdDdxVUpibDY2Q1hFejUweXFvVEVzU1hL?=
 =?utf-8?B?LzBTZXF2Q3NVd1I4ditFNUtZZUlpeXZxRzJKRTNxWXlBaUZNcWQxdjBWWjlw?=
 =?utf-8?B?RDdVa25KSXlpRDY1VVFVN1lDck8zNFVSVkZnZGdpazlnb3RUejdxV1JuSWJE?=
 =?utf-8?B?MkJXY2Y1LzhRbXJzVUM5K2xGeW9kNTc3UjB6Z0E4bEtjQ0ZmdHdVNEN5MTl1?=
 =?utf-8?B?TU04L0xUSGRWc0MyanlibVROSzdhWmExNTR4UFhWbWxtQVEzZWhYQzlSSFFL?=
 =?utf-8?B?SXZXWTdsb1pkTWNuR1RFZlFBTDB0Z0ZoM0Y5ZzVVNHNzOTVZWU04VjFOSE1P?=
 =?utf-8?B?QTk0SHZXVHd6ZVdNZlRIY2FHZDk5Zkp4bWJZUUZHTXBoS0d3WGg0eWh5UENU?=
 =?utf-8?B?QkNlcHFNRks5cUg4Q2E2QytEd2hvSVdxNVB5aFVIeVJtdzdZQTZBZjYzSWhQ?=
 =?utf-8?Q?25RBBiSSyu6mEOg6BT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0021f77-47b4-4720-27b5-08df12cee783
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 02:13:16.8193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kcLrU2mSk67mgmYXzDjqbBXLEesz8eJAInseNSsZZgNiSobCZDrSnkw/FqboiFB6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF5E0E7945E
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 26005160007
X-Stat-Signature: 6qd8mogsb5wspfm81huarcuq6bub7n4s
X-Rspam-User: 
X-HE-Tag: 1789438409-489311
X-HE-Meta: U2FsdGVkX18s3onxwOhdVaadQ1tVZ4hTrPidRo+Qya00kyXnRccsXzb422GX5IIIcE8aPiiAR1JIjD3IYbAnMb7h3tnglUTsdnZlFTYXB07n4fTwdbIeSbnNKHj8dDVJjRfhKEOfDuR6FewsbDT81pR6ZPfNqyjjet9P5r72IdPFwZD4jWWFzC0Z6vVh85qgDsyfgNWnniqnG2jns8cYH6o+UKU2H3Z7w1hbij3DxKEu9HIDyNJcnW3JeCLJHLy7wGAFnXO32EnofyknVoNORYGfyxaXOrF1u1jqtchWvWFOqROn+mFcP2KEP2mHNjpE+rWDSxfaMSagUcddxOZoRKKvMayNL4zl6H52/dmwfv35kDRE/hTyGcsYVRqL0dlYQeH8x0QwPBc6LyQ2lvVjO4l8XPkbwXLOQ1m0KGkSGIOIqu6G+ruOl04/eaMn1cPtdeqJ/fS0bn6pc4PNM7UlyoAp/7Kv+albbfljOrNg7VfpWoy6miJK5T45y3CN4uvbfEJTyOgSOC7kB3z4VMnkeUtCPWuOMACl2lYalhSL4sgEvkH8KHMvgJPCWB1GTWK6LL/VdtS+CqpLAZWzAvikRRrhm8F1miWOiyDGkxTwZy9EWmVZhwg5RxMTXgl+bt2p/jjP9KlJIftiJJfFIfJ/qS6ttFBjVzYsv+vSIPwTGShBFAx7AAYctRdm1sqGCct86i7kiCftcJ3OeiOwxRmbQ+kx6icWoCFsGW7YjAK3ARsktrl4MrfQ0dX/N2TxiGFQ9ZcjBbV+XgyeFwls7FPVUvsSidA6XNKBq/uzanvBb69OrMTnHtiBJZnLCuqB4w61dtn+dT/PbXj9NRuneeufobP+yNG+pJEz9GvRBLnfwq/WB17L5lyUB5GGldLEExyiC2biE5ttWiGD45O5szi91oWAvQb9EM//N1tizEZg4XQQaQeaolZZr0PqgF3nSXWDxPhKPxL2I92oucmkcnU
 9/2cCz/P
 Sit8CWuBkR5bhGG3x0fvemmIgRwpXOzvfeRGiQjzHoIvC/iOMW8opeXUx4DMUlSEaRqbg4fM6ZydfXAHYzchCJUoQi0nyxtMbYLLrW7wHNaDQ7N20m1YqdDNxB+1Z9KhVSF9gRgQPueJFgfhH67vrubti0kJmwMSzl75MiemN0NiMiBe3f7KuQWHtQZSkwZM0e9yBBvs9vOKr27LyBUDYaWjKds+ESFMTf/OCSdsoc1bKdYZ6puwxuJM3O8ejnoeSLRDNhJTei4oNf0LqJnsngJnNuHU1p/VNa9G89vjF2UvNwBPPoMZ+T6mp+cdqIl4U4+cY4t9NeK68QyZJRSqzkFqy+xOGkEQC0N13tnDucK1fz8rgL+AmHdm4rtt8V8LH5FOjTRGGIgMdSnKx3wu2/FmNvXvWECJkde1dE/gqC5uLtUK/ZeYhUW+j1rS9i88Ms03DG5lDx4bIgoY7c9f3GlNOVNTO8s3kaJm9gPwrpk75tdpShuacNnej/qmi7iB7fNwa16bDRALi2UFO7Qo4tiEKGymaKUK+jnweFCOUUZNOSExYR+9nmG648CBXCJNacsiF/H/TyWIB9YRkcXIejriQZ1Ausnh+UUhaMetFGI6TFdDcvVrlnyQkqGPWCzXJopVP0uKLUa6suBo61D7rD4+mjdE3IAZ49Ypes+Z+rToihuA50kw5BUgZ4Wx/maL7HUbPvl5/Yj6/bxXU1hiZoVfPvZns01SKABXUmAfnoFRNW0KDKJwY6hCvuX27hTOZrgpKQBRJ+S1XBKuit4ZEh36CFyD21pl+iSBJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Sep 14, 2026 at 6:32 PM EDT, Kees Cook wrote:
> Using default_gfp() only depends on the GFP_KERNEL value. Move
> default_gfp() into gfp_types.h so that future use in devres.h doesn't
> require pulling in all of gfp.h.
>
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Brendan Jackman <brendan.jackman@linux.dev>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: <linux-mm@kvack.org>
> ---
>  include/linux/gfp.h       | 4 ----
>  include/linux/gfp_types.h | 4 ++++
>  2 files changed, 4 insertions(+), 4 deletions(-)
>

Makes sense.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


