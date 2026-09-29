Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24AB3CA5FAB
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 01:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD08D6B0088; Mon, 28 Sep 2026 21:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B81F16B008A; Mon, 28 Sep 2026 21:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A21E96B008C; Mon, 28 Sep 2026 21:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1716B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:32:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F30191C29EA
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:32:18 +0000 (UTC)
X-FDA: 85265074356.03.1B15808
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011057.outbound.protection.outlook.com [40.93.194.57])
	by imf21.hostedemail.com (Postfix) with ESMTP id 33B5C1C0006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:32:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FsqJYPA3;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790645536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pf0GkTnLlHiWt4mL8a/7+3oGCx8v2zLK2KW2fRFVQYw=;
	b=TTwxY/VVedsmkbZYuSV60Tecxw98fNgxDV7PF6o284o3l99AX9HH8uySlKfwsaFWqKpN+I
	3jChEed13e/luUs+hFt+um+MdzI/5YMBD53nHZ5iydQXiDjP7pLkTFoaPmEuvmisqrLVUZ
	NCWTLf3LYDi+dHRwOFnj8fxEZNTZoV4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790645536;
	b=FJJugF2IvyTU/hfBPX+bFg6eYif4MHIld9fXsGUvhQw2z7lPkCIeRAWxgqgMmxWbMAgJd4
	2RpTxyKEPLwDCaSgphEn4xnuv26watcMTwsN3rcrwjyaja+wDshV3SiSxralyGdCA8JPad
	FwFXHMisEHjQr9udD/kKzvb7sUvKBTE=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FsqJYPA3;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Voau+ZjtAe21d+UAhwY4Hw3WzZtC7lXdfigu3ObljTMqvo6wK1waSGDAQIT2D/18TFwXSkx2Q/kGlE/t5C+NXl01U6YNc3p2OkZe4sfNkBfNxMPXof/yXu7YqfWhaTUBjPRSNtknl5MdX1MRzHd4OygYi6/zAYreUVemtBeb7LqLJK0U2iIMq4ABY7COQmKX/5LizfBY72Bj6bPv15zFdRGMRsqiAPLPVqMrze/nePN3Nkdj8AepiLa/x4u6P1EQ7wn40AeRZjTzVF40jod31WDuLxcFkE+Y/VG53VvaOYCcu8pbfxPy2jiz65e1I7PAZ4AFTLJcnZvPTYPpTe4QJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pf0GkTnLlHiWt4mL8a/7+3oGCx8v2zLK2KW2fRFVQYw=;
 b=cYj0qaP2Y/lwygPq+Edd/kTrJgX/+ypGy68khh5Uq8TuILeIsyUHAUz2RmyLkOIF0WbDk9nxX73dUXnsnRq6ev8T9S+kf5UFaL1mBqld+dhNLGRWYUknHzrzlOx90mahMRcwQ8BWjzj8D+zcBkIeKb+kN7G2WCG7MVxQA9rCL8t+n7hyXqsuQCm+2A++wavHJ6J4S+iS/MZWHXKPkzzxwTQ1sYHU24evkCS9tXlZZZXFj8/WHOKWYYZ/Z3mJZ0hhV+ww+lqrkZjL8tCzeoHoJ+LtPc33jZpt554EowCZxUxo4h3Mws009cZaxZnELyrYhAEkBvfhHeH+avjgwcqxkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pf0GkTnLlHiWt4mL8a/7+3oGCx8v2zLK2KW2fRFVQYw=;
 b=FsqJYPA35I6jOI9IT7YW+E+4zrgjrm0W3H+0nM9qjHky4SeeSled6X01rgbss+9dPHDoyWEBN2WmZVLLwn0XnYKMFnJC/ncNs22PiU24EcUmuPEW8FHn6WBo5ALGPXksu8+0EABFrs0mznji0fPuwXkTfdY4SIXdCjLYEaIWLhbch/Tha2/AOETvqiK3Nmc60xFGxnZVgZt5HxrbSTRkK/R4v9DlEwDwYiUXiIX8w4DXttrjW8wKyKEWyFEXrPiureFn2jJZDiFMXk8Pw/vEJKIU6M8brnqwLfpy862rbKdXrnu2lbrkzy7wbJHRoQxYf/RSkgVyBmhLxufi3UvSYw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA4PR12MB187965.namprd12.prod.outlook.com (2603:10b6:207:105::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 01:32:11 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 01:32:11 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 28 Sep 2026 21:32:09 -0400
Message-Id: <DLREV455LG7C.2RKNAXC92UCCN@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v4 05/13] mm/collapse: state what a collapse may do in
 the policy
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <kernel-team@meta.com>, "Liam R. Howlett"
 <liam@infradead.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts"
 <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song"
 <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama Arif"
 <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Jann Horn"
 <jannh@google.com>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>
X-Mailer: aerc 0.22.0
References: <20260928100630.21870-1-kirill@shutemov.name>
 <20260928100630.21870-6-kirill@shutemov.name>
In-Reply-To: <20260928100630.21870-6-kirill@shutemov.name>
X-ClientProxiedBy: YQBP288CA0008.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:6a::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA4PR12MB187965:EE_
X-MS-Office365-Filtering-Correlation-Id: a3cdb189-dc1d-4d74-9f4b-08df1dc97c04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|10067099003|56012099006|5023799004|11063799006|18002099003|22082099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	OC6OsApnTVTOfq17uS43Eu9iueM6z0PXtPfxnxWN+u/wWlh4OmarmgHDnGXR+TluN8imr6evdDKSFTUXBspJSU3PPratoa+M0TsKd5GLaCEHWhrDcTenhUTnggmbEsghh+u7/OUgHB1WvoC//tSFxy69h/7Cj72BvB1JIs9SPyznc6Jq0MGNRINJC4mhpMFN5JXiehTOajv7D6k595EnI5Bg1xS2j4xc5B2b33aEdWZafhXhTBBHaS7QAexcyeiJgMzVoWbIxQwNzOdgRAOC320GOdU3DYUgFLpaUOiedMLZd7fzmbSIT9aHUNQzCRWv6Lct1YDngyyykxgRri+ZWE4VKu3vqdsluL/IvCQzcWKfV+HtkAqt1zp8UbcSMk0amBpQhVowgaDm1pZ/98WjAwOkfOji5QGIwVvoWx256jlyecaJlBFK7SZKIeUQifcmGcl11tS3aA1cGq1gg02O+bS6VnycrEEn8ULXrQapXzEnJAZV/D8VRd5TLLdZaWxsPj+AL43xd0KKWkz/MMaYjf355FhTcVIM0mIyjBcMAeq+8CvUlbjPK52NtjvzHtrTLcyycsvAqZ72WVx/6GmKOUW/a9TZAFDgr40gcvRepwv4yVOkoDzq5wRNTSXEh06JUMx1k9/4crPSJriFqHufQz4OIhABCkd2tINa2lKIXCY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(10067099003)(56012099006)(5023799004)(11063799006)(18002099003)(22082099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aW1LZkJtSDJEbTRodnpFMktTTXBJWUxvdzN4RXVlamJVNGM4bHlXcXdoYnYw?=
 =?utf-8?B?TXFzR09ZUlVZVGE0cWF6eDZoaGhmbFBFTzJwWDltU0Z2T0tLSzhFSWJDYmpt?=
 =?utf-8?B?emNzVW5yMmZqQUZWWnBOYWxEc2FockZHZmpGRjBRbWp2WVc0YlRyV3NvK0ti?=
 =?utf-8?B?RDFNM25rQnlCQ0tXTkRCdGRWRER4VXdBMVpkL0dMMkNESnFrbFVBRnpqYTMz?=
 =?utf-8?B?a0h0Y2R3NXA5dy8yVTloUmh4cGJjbWgwSFdpdUEvai9rTXMzc3FsSjVYZzE3?=
 =?utf-8?B?SmRBbGNKYWZPbURaa2Nnc1lvTCthM01uT2NoMXo0YWd0UE9qRHQ5ZjNyYXVn?=
 =?utf-8?B?WVNURTZtTlZVeS9yVjgvL0JVTXh6NHJLUmp0QTExbmpRWnlBZHp6OGhuM1RP?=
 =?utf-8?B?djZhVXUwRWJMZURxUVFicW41Uyt2ZnNtZFZMRnQ2L0hZbWdFL2RXMXoycTlh?=
 =?utf-8?B?K2FWMkJsZjRRYzRKcitCM1RiMlRQQWhtcUZieU5XY2x3UUE2RHRNd0lrS3k1?=
 =?utf-8?B?dGRZNitiU1dSZ0xGTWx5K25KcUlUeHdSSnVBRVBLYUdnTTFONDV2TzJyTDM1?=
 =?utf-8?B?WWdsQXlkdytZbVl0WXNpM2UydWtSbk45Snd3TXdoUWNPN2hZcTVPQitmelE1?=
 =?utf-8?B?d0xFMTdtZjFtODY0L3d4a1JTUVBzOTZjbnZCWVQwckxsck8zWEpXbnVyRUR5?=
 =?utf-8?B?c3dXZ3NueWZOMWJTd2M3bm9hWnNtbjY5QnM5TS9QRVdaeTM1Qis5MkZuK2NP?=
 =?utf-8?B?YUdQcWd3ckdINzFxWnVoTlFNNER1RjlOcmlaZTBoeUtYN2ZrRDJSWXUrZlV6?=
 =?utf-8?B?RnVVU3EzK2tJUlVtNkprUkQ0OVdqSEg3ZEk1T1k5N2cvQVFNa2ptbnVHQkR2?=
 =?utf-8?B?NVlwMXZrd3dLNVV6Y1JUM013VXRwYUMxTStyRnhhWFdCNnprS3Z6S25aaG13?=
 =?utf-8?B?QnR2Z3hZdmgxNXRJMy8yV2FseUJTSGtuVFZUWFFHVllna3hJNFVJdHc2VVV0?=
 =?utf-8?B?V3d1RkNPT0NSckFHbU0ycDdDTEUrNUZvK3BCNlRqWW1XMTVHYmN2eDdJYjFO?=
 =?utf-8?B?U2t0R0k5TzFzQVNiM2FZNHY2ekZONCtiK0hHZUpLVEswYXFEaVk0c2pDQU1w?=
 =?utf-8?B?bGd6WkN2U214NjQzMlkvbDIvZHIzSWhCaUtuOHJranE2RW1hODZNSnNVZ2pM?=
 =?utf-8?B?elVTVVFHa2FTUENkZ2tWQWJETmh3WWpIbWZ3aXhZR011UlN3K2g1UHhSczE5?=
 =?utf-8?B?YUtrZVZhYXhFOTRJY1RPbEl0L2Q3bUsxMng3Y3QwSTVXczFDS1M5N096Zitx?=
 =?utf-8?B?UWE0NGJleVB5SWlwSFI1YTRqSC9GQ3RiWDI4QklqUTgwVEt1V1JOSHhiWU1Q?=
 =?utf-8?B?QnF5RmdSSm80eUtmeTZxbUQwbUxpWjQxRDZZU3F6Sk5UOVM1SjhZNCtLd1g3?=
 =?utf-8?B?ZjkwMG83c3Yvd3ZkN1BadTloMW95dTFDbUdpMHd3Q0J5U3pNUWJvbTd3NVJa?=
 =?utf-8?B?enoxZHhrcmNUa1RSNTlFSzZIVTZNS2VXVkhWU1BuMFp3ckdHa2JQUEF4bTM5?=
 =?utf-8?B?RS96SVBYME51WnZ5S21SQjF4ODFKZ1NWdlRXWWtnQ3VBVW44QUg3ZitOTkd6?=
 =?utf-8?B?NVJSTzdvSDg5dkRoUDV2cjE2QlNSVmNCTC9GZnNyamRvSmQ1M1h2VFVmSnN6?=
 =?utf-8?B?cXhBZjdUQVhMTEVhVHEyZW9YSURMcG5Kc0R0aGlmaUdJWUFlYm1VMXVvdjVz?=
 =?utf-8?B?a0RrYktMY0lLZVNIZ2tCSTZwN2dKMFgrRm94eGtHclFiZ3I1YUxwcis5U3ZN?=
 =?utf-8?B?ME1sUnoxR2ZjY3F1MW80SkNXTHVaQzBwNmF3SzZWdFFPaThRdTVta01td2xt?=
 =?utf-8?B?QllZcFROSkg1cThFTUFkc1B4TVVHMk4vVnJ2QWdlYzJkd2ZhbXBObWNqeEUz?=
 =?utf-8?B?cjgzNG00cUVUQ3hlVzdIRExMckxuaG9xRkdwSVZiV2dNdXZSVm9lSW9lUHlY?=
 =?utf-8?B?M3FJNnlQN2dicXFXN04rYi8xT0trTFUvKzhvSEJIeTBkSklvUkQ2UXAzR2VO?=
 =?utf-8?B?dFhHMUhwVm81eEFLRHFjVFhUM1RnODc2TVUxdjVSYjI0dlhoNEQyMHg0RjZK?=
 =?utf-8?B?c1RudDl5VHZIdFE1cC9jeE1hUVpadWJvOWhuV0I0UGovVnZiMmZiQjNhQ3RF?=
 =?utf-8?B?SU84cEt2d2pVRklVNk5rSi9tc3YwVmx2bXJqWGcwZEtIY0xXK1NtUmNYWktp?=
 =?utf-8?B?UjhuRlhjR3YzUnhmUHFFUE9pd2FQVFNKc2JwK090OVFuYlZiQU9BRW55aFJT?=
 =?utf-8?Q?/FBTISzurvENYQD6Mh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3cdb189-dc1d-4d74-9f4b-08df1dc97c04
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 01:32:11.7732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1S0tNC5S0jSOe30vOzfq97s4td22QsdEAEFWJ7OApDa4qFqNslXjmLw6AsDubxtF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB187965
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 33B5C1C0006
X-Stat-Signature: z5ohmkx7mgdeeyz1i99pq4uyxj3g3rox
X-Rspam-User: 
X-HE-Tag: 1790645536-830991
X-HE-Meta: U2FsdGVkX1+boUiwEB5g0qQnOe5F1UBCeAYTCDjjSlZexlN/cJgmRF7idjESxSnUB5E7JkweaVYxo275ZrTN1tN9sxsrZbJuwTQO9nwG+zQCXufuYqosfk5wM1usuJGpaixrCgYAmmozyINUQr1ykgTxqVuMvx/hCymzqf0HTmWSFfqSgSgybngQWu+DNB1DjspqmlUAqNARu5DMQy4YzN3G2EQ2an0we81KSIhmUN4GHRdY5RhrIPjjw1d8ZHSI0zAhPr3L0fzRAQdIaRcL6lY2dvhCbsUw+OuIgSvymxVSvAdBRZ52xF7JhofGrcXWAZFTr9w+DBhpx1k7z59F3ymcreZCk43NW5OrXz/AOZ3C3jR225pDlqtPGuesuj4F2fj4anJ+SDJrhowFR5iJjpUMxXxyInUBxdu3cVUOp8cSp9bWqqA9P2Qxe6q4AjtRnKahXHlHuU6/MYzMk1ShGs1HY1Q2xd4zsGBLHiWQFol5ANrlg48Y19ttUBaRcenod3wpCXoR1su6TRbKrVxihvJjg/rHuUBTIP4JjpeVkqpOkMcTO6FhQ8uFS0w2Gg3Xdt1w1rDFBsU+LzksYhj9WbGqS9aq0w/ZdQmrDxSNyQDkgyejz5m4VYJ01s3r16HSmyHuP6wo1Qyu1J/bD6p68numvIaRua+zEkUrj0b3XPFrjfI221x2zh76WPwLpimvjUpa+3KE27+xgzpN0yTDt4bGDcU1BkjiTrlGZZ9UVyl2y/pJbxmLMkmKSsCdKgUMmRP02zCKokyv2Ax2/dZHYNGbHWUqprI5vTQJQu/xGb3vipy16s/a/yb+MqnTcGDRkXjaRugdFdEJB1bMfKA1GutPZStgMt/MgNof1zjv3nQr+uGI/4qteh15upqAX9MVZ2O53YUQPTP+8c5iZICFrC8wOJ31tJnSrFNSisnyI+3UhyW9d/G59QxV1N8H/dwR+6i7OhkEIol4ftgH4Kx
 iih75J1R
 yadRRmQPK54gph6LMajxh0OODd6wauyiNCWU6y3Iq1jKJvBl7elVMWO3n7gyGKMkX0X8UH0xPzUfQVJt6zumRCiBheEFEPrmHPosEid6aNL9h22icP5706qd2TrEYTkKOpYszJPOWxYuHakGA5RESvDxB6Z1Czx8XILc+dfmZ7q9qAMYOnewHkhnzQ9oVxTOZjDlEl+FjAjw2euY8DI1YEddd7KBj9kcxyaSblBpeVCkJQfoWHQGgAk8DCLifsgBMXIFyFI3j6AOM+j9r0ZyvFzxqTdAhaSofvu22Y+9EpiYVX6eu4+F8ziAD42XYq9NRFbWrAjIevNXclNWojVrxL2FtasdqGfr5EY1KKaVzOb/uOO9jMjAiohEvqxTlYtmHLR0WhgyJPyaYJmdKx2uCq24uqsWYrRKwT6PWCsWRGeM4T1w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Sep 28, 2026 at 6:06 AM EDT, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> Tests scattered through the collapse path decide what a collapse is
> allowed to do by asking whether khugepaged started it.  Between them they
> settle:
>
>  - which VMAs are eligible, and how hard to try for a folio;
>  - how many empty, swapped-out or shared PTEs a window may contain, and
>    whether a sub-PMD window is held to a stricter rule than a PMD;
>  - whether a range has to look used, and whether a MADV_FREE'd page is
>    left alone;
>  - whether the PMD is mapped as part of the request, and whether dirty
>    pages are worth writing back and retrying.
>
> None of those is a fact about khugepaged.  Each is something the caller
> decided before asking, and the collapse code should not have to look up
> who called to find out.
>
> Add struct collapse_policy for the caller to fill: khugepaged from its
> own settings, MADV_COLLAPSE from the fact that a user asked explicitly.
> Every test becomes a read of a field, and cc->is_khugepaged goes, having
> no reader left.
>
> The PTE limits come as two sets, one for a PMD-sized window and one for
> anything smaller, so that the helpers pick a set for the order and read
> it.  khugepaged takes no swapped-out or shared PTE into a sub-PMD window,
> and empty PTEs only when the knob says all or nothing; the warning for a
> knob value in between moves to where khugepaged fills its policy.  The
> fields only one side reads say which: anon_ or file_.  David Hildenbrand
> asked for both.
>
> khugepaged fills the policy once per scan pass, MADV_COLLAPSE once per
> call.  That is the one change in behaviour.  The max_ptes_* limits and th=
e
> defrag setting behind the allocation mask are sampled once per pass rathe=
r
> than on every table.  A table scanned early in a pass and one scanned lat=
e
> are then treated alike.
>
> collapse_file() also drops a NULL check on the collapse_control.  It has
> one call site, reached only from collapse_single_pmd(), which dereference=
s
> cc unconditionally, so the check was already dead.
>
> Assisted-by: LLM
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/collapse.h   |  41 +++++++++++++-
>  mm/khugepaged.c | 147 +++++++++++++++++++++++++-----------------------
>  2 files changed, 118 insertions(+), 70 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


