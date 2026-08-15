Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A0D3C5CFDB
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 02:25:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50F5F6B076F; Fri, 14 Aug 2026 22:25:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BFC56B0771; Fri, 14 Aug 2026 22:25:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 387596B0772; Fri, 14 Aug 2026 22:25:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 079C06B076F
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:25:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 81F191402C5
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:25:27 +0000 (UTC)
X-FDA: 85101912294.21.B04322B
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013013.outbound.protection.outlook.com [40.107.201.13])
	by imf07.hostedemail.com (Postfix) with ESMTP id B460840003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:25:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dtwPNGgR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786760724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MeNloO5Uwc/S3SfCj3EzF9dFJwGZ0hHvqYm81iiE2lc=;
	b=bBKsOP/0EReE1y1yOph50TOAO7jTMjbqtp+f+3F7VtXtKdsALrJGP0y7O5tz/1Wm90MpvN
	gn7lTTgx3Xx1aT0R0PYT4V+tXXKNIWqnahfqqbFfVICPNZD5BfIiCgpsuY476pck0qDHD0
	UUyHJj6LT+PwHNvutB3Mh1WqFhfSE6k=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dtwPNGgR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786760724;
	b=2SXS1N3NQeDjgzD61o3TXB1bH+aKB/H11sdc8qPYWMKxH3i8C7jYkr8koNtcm1UbNrvfar
	1KWr4kSjZAPzRV92tqfNUSbybJRHTg2hD50mLLuoo6cjBSXR1rcZRIN4VP69YVYpeiI+RO
	nFR2kMIQHihPNBM7QRPOWHmDy2w7bS8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hUOQXxd+6swPOR+p1INFvOtBSUmtoZEAUCNpsSTpVLIAALoN3NBY0ZoKiY7yGecKJFvZWR9DkI9E+8L+EJp8TsQ9JpOEJjY/SZy4tAEWfKCFiDHDy35nPWYeBJmKq1/4/sq+4jePD44UjiHNOQkqquRgeR87KD2cZP3cbBP7ejjaBPkWCvsWC9yit413Ws5noW1EbjAaM6wYybx/zuV1fFyeebwGpbwSAprIIN7ww3XSN12jXDVmKlor6JbmIuvzcox0+wWraQQkbjfyLen4AtKDnT72C3SLp04umBX3AfUWsqIGQ/FtPFmSH3aJVmLdCrb45Ys10NI6L+miQBV55g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MeNloO5Uwc/S3SfCj3EzF9dFJwGZ0hHvqYm81iiE2lc=;
 b=bRM2fgzcYPyBD7qp6GsVRLNiAUGywPhibLqeUCbCl86Rc2EOZQ8guwo2URuBjdejLbFgJCI3x+hhhW642g9wcikzjq4ehq2ZHKh8CVj49w0Yd9TE/qO7mE1YY9yyeJf3s4IukTSDcmGP8yq6IfM1MDYSoq+N+wH7ofqEpyjg56MT5eJ7IHbbZ9u4ixcriYtiDrFgQiX2sPF4iRKAFit/f+w+o2eM7R8l4REbc1GdBxOpNTK4kURw/MZADRfw1qL7FAD8R45bhneihI+ukLhhvJKf9DuMW5y938CxwWSIkhJ/RqX63rO20wK5NRNcDI42hBi/kN2W/FaVkjnd8Iofzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MeNloO5Uwc/S3SfCj3EzF9dFJwGZ0hHvqYm81iiE2lc=;
 b=dtwPNGgR7qIMtOiS5a1mi3uH0rN/XxdBEsHP58xN1CtMRnJW4se/QpukdhdKg0jxYnrpIv3XvzPzpxvoUFuIxfwlzURtzoBRkEAibItqYgVaCzkVtH7yBSOqWYhbcRnKxS6x4WhJ+TefAIjKlR+OVEHxbCi6oUvcwV7xWvTGeBSGl3fCNfyZJUNrB4KbhzZlP6AyCNm+0qM4cYMk8R1iGnBWc2PSlOJydxEDs+UVf/ALb95LgRIJzYN7vB3cr16Y7xKmgx+/KVC0XEXyxWqB+4tUyWIy4zbvzeUrIJPAakrX1PwsnERX/XRI+BhnJNK66c4Jho9+paU8rqoPMZ30lw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB8880.namprd12.prod.outlook.com (2603:10b6:610:17b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.16; Sat, 15 Aug
 2026 02:25:17 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.014; Sat, 15 Aug 2026
 02:25:17 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Aug 2026 22:25:15 -0400
Message-Id: <DKP5T8VXL8ZS.3MYBTP6QIXHRX@nvidia.com>
Subject: Re: [PATCH v2 02/17] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>, "Shivam Kalra" <shivamkalra98@zohomail.in>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
 <20260813-swap-thp-cleanup-v2-2-d2ee48c6aa49@tencent.com>
In-Reply-To: <20260813-swap-thp-cleanup-v2-2-d2ee48c6aa49@tencent.com>
X-ClientProxiedBy: YQBPR0101CA0173.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB8880:EE_
X-MS-Office365-Filtering-Correlation-Id: edf0227f-405d-4666-8f0a-08defa74723c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|6133799003|11063799006|10067099003|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	NDyCPd4xWHAok4RAeKnGJZ1VgTTfdV1xKDmLVQyVs7Ejctb7+anFAW+XkIYQFi/AGayjHzk7IJcYTWDSHE+xaqxqscFSGxYjM0osdzmTyJeKMldOJjAbD8Z1L3vEMiuC0z+YcuMHQMEVWDKQdupQxvOB5ZXs0tB3OaEqYOFAto7NKf5TItk2HQ/ZxgLSfRGZ3dhEza0MypjypXZpu9FAeFsB57Hf7V/wtB83xFFjviWWrwffdXNTULXUvxwnHCks/02te0dnIBnUHGhBotARp5GF1M5BreH94WTirUonIC678KUC7MtRIx7KvzziI2VWW3n0HIvF2eXPUHpbo6TZeT9UmdlE6GUAhCvAqQ1nLP/pKQOH4RK5MZktohUjs1IhOIPv+/RsbMuRExrDvLEgQZlVhxTtGnILAInEyE27veX7l1eledklLQo2VqIbhyHV4zivjZgRm8RtbufeWXvZ74LS3IcMyskMlQikVGEjWCk9Bk3YLw3Pjumdhlb6+OIO4/xWMz0Yqotryk1G/ujpsflomX8hBFeXKAhiw5LG8/AM4o/qjMPchfc0nxrUDLuyGHYJfB0xwj9JB7wuKjsvwD1/1+17ahwWTLOmjamPUn1nfZnXjjMgohvi/ZLCtsBKB3hal+FHQZNPKbRFVG055B2L90la8ZbbXVfY65as/FE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(6133799003)(11063799006)(10067099003)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3hhVnpaanVWYnNnWVdVVlhRcmhKSG5teTl6aXdnRkdPVWdCOUpwWkZkcE1w?=
 =?utf-8?B?elVNSGsrMjlNM0poeWIzYTV4ZTV0QXgxYktNa0xwS2hZTWx6OVI2NkNBN013?=
 =?utf-8?B?SnJvQ0FIckhCdzJQTnJnSm1uYXl4L1h1SEgxdUJ3UTlwYXh0bWUvSjFlemZi?=
 =?utf-8?B?bUVCQjV5a3ptejRIRVlOSXA5V3JhdnRhL01wSU5qYUUxZ1BqOEdNTDdCY0tL?=
 =?utf-8?B?cWExOXRodlZ6dzM2MjV2R1ZObEVud2t2MkFZR1drNGp4NDFtZHB2YlpZUW5F?=
 =?utf-8?B?bmoveHAxTGlxWUQvVzdZOXRGSUQya3lBZXREeGMyWVNDUnIwNmh4bEp3Vnkx?=
 =?utf-8?B?WEQyQmFHT2dMK05tOWRXUHpZOWs3WHRYNTUrd0tNekRsRnNGNW5ON1A4QWV6?=
 =?utf-8?B?ZzJzUmRpMVpObGRFcFFNa0FwdEtrakhtaTNwODdxNVlKTkduVVdVdlNoU01N?=
 =?utf-8?B?bEZsbnRrOVhtV3hjMHBTZ1pCZmhCb0VleUk4bzJiRlhoT2tkc1JiYzJWVTNI?=
 =?utf-8?B?em16WFdSSXh6a3kzT25IcndjdnZ3MGpGL05LeGRoUk1kVmV2bWlHTi82eXF3?=
 =?utf-8?B?aTNaQ2l3WHA0OFk2SXFrNFc3S1J2SHBVaDNGRWwvODNBdnZ1cmJrMjJFWFN5?=
 =?utf-8?B?MCt5cUNaVkt5MlV1S0VHRFBOcUxOMDl1L0V1SWdQb296aVNVdGRJdHErOUJB?=
 =?utf-8?B?U0ZQeEFvSzZrVUVWTFBtRjY5VWw4d3VuZ21IRnB4TXlHNUloZ3ZHeFVFSXlN?=
 =?utf-8?B?di9JR2xsRm90SC9KUFVBYzQxQXYyQkFKMm1aU09VSXNPUzk2NDJ3OGJkSGNt?=
 =?utf-8?B?UHRzMjBJeGNKZzNLN1U0WVhueUNOTTZrUHJSRU5WNUdML1ZNV1lUaHcyanIv?=
 =?utf-8?B?KzBLazhHTGU4RElCRmdRdWlVK2Q1aXlVTGxNM1pjMXA4K0p3WnowUWYyNVo0?=
 =?utf-8?B?M1lqRC9ZcXJnMGV6L2tVcUpDZ0wxWnpzazJvM21yYkJrVGZaQU9YOXZxMlZT?=
 =?utf-8?B?ZEFab0dneTNOMjFDZEN6MWRmb1RkMElkQlRFM1dWWERwNDk5ZkpibVlxU1M5?=
 =?utf-8?B?VUhKR21ZaEZzSlBsZGI3azFmeDRJa2NVaGFCM1EzWXphNTcrY1ZCVlNub3p3?=
 =?utf-8?B?QVFiVVpUNURxc0VxM1FzK1ZZVzA0MVpIcXJFNTRrRmg1YkFVSmkxVHdwUGgw?=
 =?utf-8?B?dXBRQkVubUZpdFZZTk1MZVdRY3I1UlpXclJGUG1aVEhMS0FPb0lGaXRDTDA1?=
 =?utf-8?B?ZDBIQWpVNTFjd01MU3pUSGJybGVBTXRid3FaYUdTQW9SeGlUN05UWHhIVjVQ?=
 =?utf-8?B?bXE2WEdwOWpmTVFpR21USm83N3BTZ3VaeWRVaW1pejNIUWpjdEo5WjI2WjZu?=
 =?utf-8?B?ZkhJVnBMRGdKQit2ZW1NTGtTdTNWaklJRU9nN3pGL3ZFODRIM0N5UWpIalZB?=
 =?utf-8?B?K2tOODF5OGpPSXAyUnUwMUMrc0VuRWhKVHdnUzhCWmd5Z0c2UVFrd0o0OS9v?=
 =?utf-8?B?S3UrbndPSDB3WS9XTkNmbVg3NC9QbXNLVHo0NXhnamw1TWlDcHM2YTFLdjJh?=
 =?utf-8?B?bDBhbDl1bFZXYnQwZlJSTU9ZNVJXejZZUXV1TGJlNDljcnYwbVIwRFdVbXRR?=
 =?utf-8?B?NTRZenpxTE1FUGF2T1M0S3hFSk44Qk4xK1hqMndqMzZQYUNpeFZuV2RobFB1?=
 =?utf-8?B?ZXl0UFhsaHF1dGx5UUUza2pUOWhPeFlyUkV3Zjg0aUJHUVdWditVK0l0eHFK?=
 =?utf-8?B?RFR2czJNMUwzQVl1dVNzUlFuMldXVmVZSlZSY2NhMHNsVlZqc2JrbVI0MWY2?=
 =?utf-8?B?Ulg0d0tVRGlzUUFJS2lIVE4wSWhKQ3dnWW1PWEE0dVo0QUFDdW1SZzU0eGwr?=
 =?utf-8?B?aFBKTXVreSt0ZVZQT1ZuZ096SW1wZksrNW1lMC9LeTFVWklzM1J2S3Nlb1FR?=
 =?utf-8?B?ZmFGTWtJZzc4MFkvRHJRbEFnRFU5aEN3aDhEOURkZ2JrN2dmdVVVUnZ4V1N0?=
 =?utf-8?B?c3lHSWU4NTRjTG80UUY4SjJyNGdBSm9MNnNHcEx2c01EVW5KTkhCVkhaRUJW?=
 =?utf-8?B?VzlRNXdxOEdUU1BmTzU0dG5TQmpNY2F2RHdZQmNPQlB4bDlHL2NteDBjYVFs?=
 =?utf-8?B?QTU0TzdQMWpTeDhBQWlmbFhqVXNkM1BjOS9yKzkreFZWWUU2bkxSK3RDNkp5?=
 =?utf-8?B?NFdMR3ZuZWhuOGwxOGlsSEZURjI3RlZqWkF0K09hMk9YRXF4SEs5dG5Zd0pN?=
 =?utf-8?B?R3pRRkFlUHVEbHhMck11aUV4cnZxalVjTE5FYzJaNU8wUFFPUGNDYmQyKzFN?=
 =?utf-8?Q?7b10WiACbcKGczXscY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edf0227f-405d-4666-8f0a-08defa74723c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2026 02:25:17.4592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tF7sdTaFgmYuh9GehDT2Ho2ocZNO0nQ9hooZNMAcE/FAvO4AcXG+QCZotV4xEj7o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8880
X-Rspamd-Queue-Id: B460840003
X-Stat-Signature: qzphf8cjgimrst6egnoh7s37j5iwffuc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786760724-380386
X-HE-Meta: U2FsdGVkX195MSn6+WPdRJU4eywRimBSChaWZ35B7sR9CDnzoJVR3p7QXlkWiGyq9Tu8FliN9wzc4MQm33GT+2EnBJ/qJk1VScTznzF1rTd7cW5JdUJEyEkbmhxuWS4Al0GaPba3B/aiusvzO0qhIaaOc7n8C9eef+J+/U5zSNIVY8Lq+PirlW2zveGIC5TnRLP3dqf/4oxmTdqY+wAE8uJzsmCBMaugvLe6sEQCjamzLJ/lyvniz9mcqRnOyqo3l7uUG7DNk2ZZCVZNQKyBAgdWfETKJBD4y10yWCpYBdM3hUnjrD9yXwpVpOoDKYtCrPGQyBXwH45XSQftkHp2zsmf/E0u92/WfnVbjE7C3nRNBKcQxK5TDVAbqAdjF7ipNO4Mn8GSHITcKPF8ypMNatSgGS4LsVqSt/6ZMM9uSgjd6ALLqWQhR1cONJ+GWvE6AMnWPa06qJDAef0EKJgZF+wpucn09TZ+JIlzg1O7lxmDLMQhyIgG+iCIMOt0YvDF3sSJ0ITFEYRyNMGXcFgFAXbm69ttotaTBnV/0U/6gLJdx/upDyAYxKz/0dSd+J1304LTAm77UqLlUR23mgfxUCGjCCWpMQX8zyak4PJ41yC3P3oeLENXNkFc8jdERZs8FCCs2nC0FXICFOlOfVH9ym6bKJDHtoe9HqLaui356qLdXdpfacgiCr6mirId5ukLkrUgBSX1kEsJ/Z5NcOQabQSA+2GNt5wlkWei4RZVNOHL2eAiRYHeQNshSnnsw8KwH3ve2zySqlvsS8zqNBNM9vZVgHwj570sL6/OCng+g3TRZd+NqlGuSaGnAVseyZiL04npGhRJTmGSix8JaDVcSJCX8TriZ06qs6HOCVBc9K5Q4YzLz+KnIQeH1aZrU4FrQGEp5agpD8P6osPnnXXEz8wzl7NivbH0t0qHd45TxOEae1A7PH0u47EItLeLa2X/tj2Vjq9QYtV+UXgXWPU
 2d/hlVr9
 9BkARWLUqLEI2xse3h9gALO030Tz6sOOSc80+P2anwJMA3/xvznc9NGCmsKxkHvki5mt0gkx4nLeC7BAl5aU2e+31pEX2lo0v970kA6+r3VaelRHAxkZHfbx6fF2J/3zp8B1sUtlAAFfaIawMgtzBIYBFvBNvYFzKhMylOu9LzGqcjhTZ8bsYzN72DGuR3xq/2CNflac5YGIq5PT+CBt62NemjCZ/Ty/iX2/S9SVzfIquzjl4ZnQtMv6hfurZkVFvVAiJC+Z9/KLgCsXHL1dh4PX3iipUpYCvsBCimcrOK+p6+Zm8veZ6z6+fTe7uVawEcKQhZ478PjIjiv3APFovhX8G4XBFddSqIh4zPgwg0+6wu+CLiAtL1iG7fZAr3MzbLITUUdTEoJND2WW5CpJBMmZRkLPkfrXoO9KnQX9WzHeO8cebvxqs0f2Bi/nZQ0gCkSPcGPUCQqoT3JXgC6Qe3P/ZlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 12, 2026 at 2:48 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> A folio in the swap cache cannot be split if it has a mapping (shmem).
> The split code does a defensive check for this in
> __folio_freeze_and_split_unmapped, after the folio ref has been frozen
> and the NR_SHMEM_THPS/NR_FILE_THPS counters have been decremented. It
> rejects the split and returns -EINVAL without unfreezing the folio or
> restoring the counters. That error path is buggy: if it is ever taken,
> it leaves the folio frozen and stuck, skews the counters, and fires
> the VM_WARN_ON_ONCE_FOLIO for a state that is actually legitimate.
>
> Check for this case up front in folio_check_splittable and return
> -EBUSY before any state is modified, so the split routine always backs
> out cleanly.
>
> Also fix a bracket style issue that checkpatch.pl keeps complaining
> about.
>
> Fixes: 00527733d0dc ("mm/huge_memory: add two new (not yet used) function=
s for folio_split()")
> Fixes: 714b056c8321 ("mm/huge_memory: convert VM_BUG* to VM_WARN* in __fo=
lio_split")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
>

The handling is an improvement. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


