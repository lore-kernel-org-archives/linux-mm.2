Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44625C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:57:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4336B0100; Thu, 16 Jul 2026 10:57:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CC2F6B0101; Thu, 16 Jul 2026 10:57:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71EDC6B0102; Thu, 16 Jul 2026 10:57:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1BD6B0100
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:57:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B2D171201E5
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:57:45 +0000 (UTC)
X-FDA: 84994944090.13.2F78B21
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011038.outbound.protection.outlook.com [52.101.52.38])
	by imf28.hostedemail.com (Postfix) with ESMTP id E262AC000B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:57:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AwjbvAM8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784213863;
	b=tRWXwjhUqoM+kpxIH6yE9+ovJyK/MFsrdTC77Ck4y9QEtBpiICJEbbEQsCaSwLJGHAte5q
	O1ePL3+7qcEWRUaWOco9n6fUun4E7p1a5gIStHTDuoyPDSURTyqgSSxnC+1zUOpg486VKV
	ESspqnNvQUK3wVjBD0CZRj+Cg4jlCxA=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AwjbvAM8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784213863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+W53cKzWrRy3FKHAjCN4aIPaMoTdezs+LIoJNi37C8I=;
	b=7WGpjwCJ+URmdnWJnSQ3jPibEla6GvCR9+G4W8I5x+sGz6+4POX7Fli/sAFK1peRI+6I3W
	aR2St9Vp6yOz00ESBFZVaNqLdcnA6+BcWUlJdvWF7k1smVZgp/6YO7E/ECxbMwSCfr8Vlr
	8RN9mM8GsoLh/PFN5ZEmTDH196frUtA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R/ek/SUzJLKHHIHRq5B7Fu6fI6oeZW5KIEqTORM24QPmq05ved6rLAz0MCcR1MQDykCOaL3YfbZnqZunE/JibNjG0UximJWP9HnQbvFgatbxbH4/nj36hXMrJ/oX1pPkc4wk4kI03iiuUlYiR0LR0LeMNOcrrLpS4EPKklKyzmZGeNYuKwGKtzq08EM8WibDu69+6gFQYjCSy3xcbmjYMNjCWlzbDix3lmwby1BlzoXnWnPdg3yrlzogSwJlxyLmoXR3OZPbxfmXHb7TrDLrf26XsaNfR5stfiyU58VjoaHEdCJAcuKQtkr+vCC65c/yxnEZqg1VZsZJE/CMicN8Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+W53cKzWrRy3FKHAjCN4aIPaMoTdezs+LIoJNi37C8I=;
 b=aDJjiImq27HgZNAxNIbjopj6f/eJ1foWmc9nH9LYgcxC6VT6siAFgaY0MihXjrWXyWbcTMfnyxiiy4V6SAew0mc1pLowIU/vsvBd+FBCfy+yB3MgufsP/g/ddLNeN183xNEzk68j5+FoQ2oSu4f8IO3oFbDRG7GUdtum+RxmqzfVthotjrOqLmUqWxRH+/ubivmJELz41rq5EyudcOQGXqiJYSobzqZNEbmqQHQiy9ppK1kfkW592PwNwfsliB0/3w42eYGDRhTbklbRo7X7f2eiCG2AsF/RGIovdlMUsEnapleJ8Y5rFBwBodKT+W2LtwZSulOjI0OQFs1Vg6a6Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+W53cKzWrRy3FKHAjCN4aIPaMoTdezs+LIoJNi37C8I=;
 b=AwjbvAM84StAtCPV7yaDM4gVLtR/ytkUvl6EcfQjFJTCcxZddNa8KqCwWSAqlh6arMAQkiSwVh18schwauZXiMrmJAHvg9btJfimQ+I8Tsbvz5m2cE84AUHAni5GEpjNe5hyOtv1uHvvJuvtK/moiCKxqdmOBBFry4MhdYRVZYEts5dTdTR4SXhI0XxY0TX/F5lLK8y3nAl8DPFlQ98sYMZqfP9tDXaZV3QtftuDOUb5HEroqctgMV9NRio8hTS/lwsKPPMfflGXoxegdvZ02VR24AaaDUfa69jn7NeQ6g1gdHyyqmblWX5DJ5ILAF4qW7R7pQoInKGDvMa510ZY+w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB8524.namprd12.prod.outlook.com (2603:10b6:8:18d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 14:57:35 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.008; Thu, 16 Jul 2026
 14:57:32 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 16 Jul 2026 10:57:30 -0400
Message-Id: <DK030VL67H82.2DC0CNE3BJ9KX@nvidia.com>
Subject: Re: [PATCH 1/2] mm/huge_memory: remove unused can_split_folio()
Cc: "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <liam@infradead.org>, "Nico Pache" <npache@redhat.com>, "Ryan Roberts"
 <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song"
 <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama Arif"
 <usama.arif@linux.dev>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260716100345.473473-1-kirill@shutemov.name>
 <20260716100345.473473-2-kirill@shutemov.name>
In-Reply-To: <20260716100345.473473-2-kirill@shutemov.name>
X-ClientProxiedBy: MN0PR02CA0023.namprd02.prod.outlook.com
 (2603:10b6:208:530::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB8524:EE_
X-MS-Office365-Filtering-Correlation-Id: ab6d81be-7a85-4e53-530f-08dee34a902b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|56012099006|11063799006|10067099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ue/MKl0M+t9FNv6INUMn/dplS1c/XSMR5w12iipooWEaWn5hC0KuOBzXulonk+gDm2h0Q0edp5DIArBAxWeuLui4nIJ10a7QJ3OHH3XV7fVyr0JFDI6IGkKqqJGslWicUi6RzBPDwU3Cuy6pgaRcgNkX6RJzOsnBI0rb+G0+P90F3trqKrqQpIGaiYtqGI9jicO0AXFvHBVx/YZm5hwB9l8FtS/Z3lZjvoFrDbxEXKXXwHgn2D6m5hs7bxceBNu+HnPg8D7/1QXSvjba8gofz7xssi2qWYQPvS6S2xxV31B3H6eN0qbTjHtsvcIYN+MgJtD7sbc0Nk7YCdZM5HDzPi+GsxVlHw0ALJYe9Zo6MdkckzQEDsPeraKBzRoEYJG02UeCL3ocM+A3h24U+8Nzz147AXILITAjjHFJ3vdlcd2rAOd8Eq9K1Gn9EbuzZVT+4BieREsaM4RX20cdakS1RB/n3MGma6SCbhj3Bz8UL3mlA4iOSLlfQrtXE1z4NOSF8xkYoxO2slemZ/dyUibaxDMv9xVhLMvycEShv/02xqzZm/Zy3iOKMZZquMY2/V4kv30E5wb27RbNrrdr4BiG/Po6uO2o6kZ2JBru0piL3efpq9OMtaW7uSYWXRblESXJWDskJzpWbOKggM2DEQpa1pJYzlUgZfMXCG4nC70gSd8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(56012099006)(11063799006)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S1JGMGhtbzB3Rjg3TzAyMmozK0pjZTkzaDM5aC9ONkp3bFNySUtXY1JtRUVk?=
 =?utf-8?B?aDN2cUN5WjNvUWk0cVNBYitzQU1hOXo1RTZPUVIxU3h3OEpES3ZHemkwYkxK?=
 =?utf-8?B?OHF5TWxUSzN4SHFJSWJsVk8xZklRUlVQMHNHMHlmMXBHSGw1cVJDMjJtNHpz?=
 =?utf-8?B?dzJiaDFEaWloMWdGNzFlMjVna0JxSVFRQXVtMHRXRVV0K3dPQlVaUGZWRWtr?=
 =?utf-8?B?OFM3S2M3MWV3S01pR0FldFZUdzJIOTdVMUNzb1h0UG8vbWhtcVkzMExEcDVN?=
 =?utf-8?B?UlI5TmQxcU80b0ZvL0dZUjRNUE9lTTdZOU90Ny9xbmEyeVVrNU02U0dTb09F?=
 =?utf-8?B?V1dDaVVsMHVlK2JQMFBLKysrRjRkS3JMMm93eURaSVN1eERFLytsZUZUR05y?=
 =?utf-8?B?MVR5WjhHWGZSYmpQZi9Tei9lZHFFc1VZSlIvcExSQjQrYkc2aGtLWWpiTFd2?=
 =?utf-8?B?SjFnNDRZNHdCVXQzb29qUmJpYVhVSlR6aGFZcFFXNzZQbE0wYUdMNXg1UEp4?=
 =?utf-8?B?aG9mcFQzWFllaTdGc09uRnNZMmRsUnh3QlFqclIwVThZRCt4b3NaRk5waVFo?=
 =?utf-8?B?UUgvQ1c1bWJkdmcwaUREQTQxRmJWSUZ2UjVMMDE2K2lKLzkyN085SXM0VkFD?=
 =?utf-8?B?bk5CVC9NRHFLUk95M2tiMkMwNmF0OVAzUzMxdE1pdHFnbWZrd2gxM1JqUC9a?=
 =?utf-8?B?YjFmN3hzZnAwQyt4Z0d6dnNvaVdDYXkxdEwyd2hDSTRaT253SmMyNi9TdW0r?=
 =?utf-8?B?YTZJbWhzTC9peWVBQi80VVErV2ZKNXNCcTh6THdPeEhlbFFJdFpTdFVJZldN?=
 =?utf-8?B?ZGNMc2J5TGR2THN1U0duRC9ENit5YW1Ra0pGMzFrWDVHWE1JbmNqd0xjTDFh?=
 =?utf-8?B?dGx1c1U0WVRrQlluSlc1L0lkUmZTL2llZFQxS2xkczdBYnBQcmVsY1hlMDFU?=
 =?utf-8?B?NzNLTVBJU1ozQVVwM1UvNmM3NlJIS3FzSkRoMFRjMlVhdHo5WTN4cW1abVpr?=
 =?utf-8?B?SmZCY1lvVzlYeE92WVZzSWZSVnRFZFQ5aTU0Q0hVTElmR3BSYlgwWlM2dVZn?=
 =?utf-8?B?Nmo2enN5ZitEV0F6YlNCcFJRdW5paFdlNDlpTnBYTEkyR3lMbjcyMU1mVDVR?=
 =?utf-8?B?eDA4MWNGMmh4d1U5UitrRThyL0ZYV2t1TFR1RS9DZXNYRU1xMXpNcnI0TXZ1?=
 =?utf-8?B?OEllN3IveC8vbnZQd0xyQU01OEQ0dW1DL0JQeWZRNEY4cTA0MDVUMXMwMnF2?=
 =?utf-8?B?ZGxlb3JTZzBzOFoxY2FydDR1VHRTcEhKcEEwZEZwUDhOUnhxVGhmWDZENEJT?=
 =?utf-8?B?MGlwWktGS2pURjRkc3BKL0c3UFp5c05TalQzb2FtU3pnT3d4TG04QTdvMlBp?=
 =?utf-8?B?RndTc3VlZzBMZ1RNU01LL25KZ2Q0YVNmTmJlcE14Vzc3T09NakJ4ZmhnaGRM?=
 =?utf-8?B?cVJUUDdBWWtxcWc5RGgyNUxvZXluRnNrQU5TSU9WOWlmUDB1TmdQa2F5b3RE?=
 =?utf-8?B?K3orSFVDZXlZQURjL2FPV2FVWGRRL2VXOENvWWlCVmRVbExBVjNWSmc0ckUr?=
 =?utf-8?B?K3NDcWJUVjlVRDRWeXNPazVTdGVxVktsZ0JVTzJEUXhTb3g5dVA4ZmxZbkhB?=
 =?utf-8?B?bGxmdmYzREdJRnhzS2srYkg3UHdwTzhQT0RGMmtOcW9JNmdEWmtNTmZ1eklO?=
 =?utf-8?B?QUpXZUU1YXIrRCtPK1hIVE1Nc1RmeHIvOFBKZ0c3SlRyVEdpMTRmS3Z4SFBm?=
 =?utf-8?B?QkVQc0tMeHdGUlY5VG5UbzE4SEszY0Y5NTZXdDVHeEpORmVtaFhkbEZTaXFF?=
 =?utf-8?B?WlBEMzNLdVhGWHJxNGZ1OFZCZUV3eTJIT0pXUzNSdjA0dGFnWmdKTU9jbTJr?=
 =?utf-8?B?SDdKZ1VIUHR0aEoyY1hSVzNyZk0vbzNrcXFvSEFnV29Wdk44WW1DNXB5RGY0?=
 =?utf-8?B?WXNUdlVSMm54NkFqZC9XcGlZaGFuWU1RQXE5U0FYZEFYNDhuT0VLMWt2UFBC?=
 =?utf-8?B?RDlnSVNBNlpGYkkzR0VkM09xemZmQmI5Wi9obkplRXoxZDdDTjd5aE9BbHVp?=
 =?utf-8?B?ZFZSY3NGU09nRXFCSFZMeUxBZnhxaWpOZHRkZ2JUdEZmeE42VDNMRDgvZ2kz?=
 =?utf-8?B?YlhnKzBJbzE4SEptQTd1QlMxbnlpOXVadWFYemxnL3hEUC9CRDV4NnppRXJz?=
 =?utf-8?B?dkNObnNOMFErQzRQc3NBSXU1WVMzay9DRld2RjdVNXk2ZGsyTEhOd2NJNjRX?=
 =?utf-8?B?WHl4aDYyY0o2aVl2dVVGYlYxWFcxU0NqOUlQeUtzZUxFa25kYmFoQkdjK0tX?=
 =?utf-8?Q?nIh4uDEnRI8c04fyN9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab6d81be-7a85-4e53-530f-08dee34a902b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 14:57:32.2045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B32kblZjuo0cwQuzlnjaMiFFgx4W8f4lDm78KFYsoQgL5JK7hhrmGerTBFrmzyJp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8524
X-Rspamd-Queue-Id: E262AC000B
X-Rspam-User: 
X-Stat-Signature: rbauayzbit8jaqty4wb6p3zc66px4epn
X-Rspamd-Server: rspam03
X-HE-Tag: 1784213862-375541
X-HE-Meta: U2FsdGVkX1/pvubGhqlPd5QK6bXfmoaTpra3Jijhw1LN8wB5QipNLGo96xh/Y8NIwoeEcGCvcOhbfYm9bnOE285e6zXhylO8IwjazeAL1VBuH23QpbzWcQbySsKHdyHyPDD4iIaZEb2RSDs1ejqCwj3sP4tfBxfdgDnyQSQGfMVo9LxJMahTJGkXjAJja6meff+LJDLrW7eslczqfT0KY1Lfv5hZKFblhgZVvcC2g/FvLX0kJFwsr9lt/NRLyCoR9TIAb/wQf6ptUPzymIBB2ERpDQaVe/yRlNT4drSauS392nqsUWw9/4o/f+0cW8zJb2e5DJRy+CIGCjHAiwTnB17SGn4TlOgeB6QklizZbGVN8cI3XoejvU4Ex/faq8VYnlhmO1oGTLetc2Qt9AOfavHPSqSrPWhf0rMrEVhLVe6By6tXR/owwut5sREF5mMHBjbegsE4rw+8SxJpSsZa4OTzBqn90dgrrXnK64DjfO5MumfkVKhCBbmfCDOXqPX0YnbGL8cc2VzAx5dN/0PdAJ8vUE1AMnSgBAroHtlzF7HlFaItMOkDR3TDGiRML2f69bRX08zZzCbgpcs0cvyBhaYNYrz2CM+ofxRjo2xo84PlIQMuBYy72/cTbAOM/trHe1/2TXZau+eQyGP7+dTdSWITkdDbmuYbZk7TJMaHHnXSFswxunfzOU2nHpjafJ2vAoQXN9AM3lIBWEtHYwa1UTmi1hMxRS5Kb0FIE3xuG+mA2LfiuNQ0R9BAxac3+iOBh/MBnB3fm/EoKx3nWd5B30zQMGZAqUS3IGM4/y65E0WzAzOcUbE6+1M2tr9f8V2HjEEmvpJhFypdpaDWVI14Y1bRAZI4nGBD3FtrZMp+Paa+n9NsMEV4J93gXbYYH4cDIQQNZqU+FieEq4dZg5hylHopuL6r2ygfLD+HCjf7P/AOoFFz8fbcSCHGNC/R838EdsrdIvqFIRXjfyf6ufF
 mZ+Fw3qb
 Ez7l7GN7pRfNUTKw4x6yVdoFktb9jDKqrM5um0jWQNszPo1ZjMjsuNAvi6RlpAvgRgMN4bOqd+UM74Z2nYqglu3BFWhnUEoaSJNiQh1YXTAsbXiQMDw5+cQ29DY79hGkTgX1mC0LwYU7XTjXd7iGHOgjBSdxblC3lYWQVi/XUnSqo9Ro0cHrfn6CE3auFrtZnxEmyMHgv70Cdq/93O2HRpG7D5+RswuVTw/sUSGVWb42rUUN6d8a4wjpwa0aukSd3wXdC0iPiYgU0Ny+xPeA94hvNXlOgs+SLymhprfu1FY/cbYW47qUNPhGEItrUvCp43jXV4sDww6wJWH9CVlO75x9RYl0OePNDFwzvYy4BxYHdIS2gjedzn9pHqvsY4k9xSKV9HhoFyRjDNYbctCL4OkAVc+vRyxhf4sRIKDtiloV1/1zFZmmioryu4P3IKdilqnnNqqPDX4s5CaqBwGN8zpZnZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jul 16, 2026 at 6:03 AM EDT, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> can_split_folio() has no callers and no definition under
> CONFIG_TRANSPARENT_HUGEPAGE; only the !THP stub remains, left behind by a=
n
> earlier cleanup.  Remove it.
>
> No functional change.
>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  include/linux/huge_mm.h | 5 -----
>  1 file changed, 5 deletions(-)
>
Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


