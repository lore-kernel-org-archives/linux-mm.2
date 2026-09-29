Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 862A0CA5FAB
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 02:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C5486B0095; Mon, 28 Sep 2026 22:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79B896B0096; Mon, 28 Sep 2026 22:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68AE96B0098; Mon, 28 Sep 2026 22:03:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 442A26B0095
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:03:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B37561A0390
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:03:05 +0000 (UTC)
X-FDA: 85265151930.25.DAE4D79
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013001.outbound.protection.outlook.com [40.93.196.1])
	by imf16.hostedemail.com (Postfix) with ESMTP id DF4FA180002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:03:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SzhguVo1;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790647383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vn88zn17EaquzrdiueCh4RNu8EDulJOiqfhCCaH5w80=;
	b=av0qqG0eU4Ddyw3bt/CnRfzg9AWHe9yQzVVlUgEMcg21xRCI8g3QamPxAYy/BdcoK7yaqR
	FbOIANCtP2kufvEVEmewSJK+Jl3SOzCIDnIcVAqoUwdDUoz+YqahSadL0IgvvJG7TejsA4
	zLYb5ThgaajSoy3bQ80gtt6sTY8QhY0=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SzhguVo1;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790647383;
	b=sLiIFlI/ACIPhuMG47+8a5P4jUWYkezodO0Y9wZcfaUzka6QvjRctl3M9UE63tsball+cY
	cFSDmeCjWSM0XoDIN8EK0QvrlPY+f97Dc0Bu87tF1gmwMGbTYCOMXb+fIR96q7+kzHUCuH
	vDIROQb4qmA8REAHfUxCXK8kp05ql+I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=svUh/8hHCegUaFlkJm2cM1BTp3b1YcZeA5DW9DhC4kpWzOSmFZQEc2SMqtjVF9Mal9xPZVrbXft6YAedjR37dmCjWBzPHjDAKwuIbbEWPmo3SbKglTy0NeUbWftp3m47G+h3rlwm9HpEWHt1V2NSTh3AoQoPEmEDVYAvEuVp/fDrQfp4+mDlc4vzyobqkrGNHqXArM7gu2yC7bdA6eQZszEk/DLiDqPhX6BsTcSeo4Ghf0/CAJt9Ur8o+bNeTXu6dUFHpV21Uwdhwgb9fMVddLudxMg+0EeEds0XpWq+tDShVLfUCp2LB2dm40ONQr+7BtSt+siBuv5lJix/F+n2PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vn88zn17EaquzrdiueCh4RNu8EDulJOiqfhCCaH5w80=;
 b=QRdUf8bUD3r3+1Rk+qvzkVEisTNo4d2dDukRCsvDVJJwNDBpTQBQYRRc2LmZpilUmBugIpXuLvrck10tedfgD2SXpN3OxHJ66ydeELQxEqnallUVLeoQUEW08trFBeQpdYpXxAQbZtWhKFNNJTtrOGrGvEGktJyOnT6g4Z4KM+EJEggqvJ6695WpNt7y2B22zFJQ6uNK2hfmZGp1fr4pcYjDzXJB4XvXgQVsCCztKGpQ9Kz39HqWJNxH2PbHIRHk3YMx3ndMH9aZe4EwjonSGfJGb5xncIRojjeWQzBlr1w6xMcis1ie9F8qnWl82L2kR9oCR3c5b33f1VdmCwls8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vn88zn17EaquzrdiueCh4RNu8EDulJOiqfhCCaH5w80=;
 b=SzhguVo1zPOwEWDLDNWDrH8QPJKDgOz8jbaOsjgyOaWYUObCqvN5E5f8hBNdAJ69c64Akc7cvJaJ+JgFWTkHDL5SaYWudKNzjkYKsvP5fh4CKYFmZ+W7kHYCWoddOJpldvdeNWxGyXdK5Z3tp8Na8y6jqLmDxfev5ynOxVH1714nUrvGTwlnfa3KXUY15E4QblYEO+/P4SQqeVDZ6ewhdFCi7OCPNARHOYNeI9WD12AD1L+NL0z0ZIhtYdOeat3RVEyDoUnU+VFIRDxOpzMHP0BjGn6LD+OCP1cLJ7pJKwiU8QmnrEw37P3iX3BrFO6IjoSP2/V+fFU9jpishuDDQg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB9313.namprd12.prod.outlook.com (2603:10b6:610:1ca::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 02:02:55 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 02:02:55 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 28 Sep 2026 22:02:53 -0400
Message-Id: <DLRFIN07EBY7.1WKF4WLJXY0IX@nvidia.com>
Subject: Re: [PATCH v4 12/13] mm/collapse: declare the collapse interface in
 collapse.h
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
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260928100630.21870-1-kirill@shutemov.name>
 <20260928100630.21870-13-kirill@shutemov.name>
In-Reply-To: <20260928100630.21870-13-kirill@shutemov.name>
X-ClientProxiedBy: YQZPR01CA0120.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::26) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB9313:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f4f60f8-418f-47d7-76f7-08df1dcdc6d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|5023799004|11063799006|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zZvST2V0D6xOkAd5cWWHpv+kntyirGneec7dh8FkS3F1l5dlch26lKyXbhqLVepCiHL2ObVmLhsnwH4FwP8idSobMyPQ4BT2ehnF0H6RdFBFtRjrxwLvXO1PaZ15S3Abz76dfhdVmBb3I/TNlswddrD/OJ3cgpUFn79lltc7+uXe3++hRttUUITZHLdlaq6lgcU91Ut0pv9AMmkyo7Yz8kmSYx1MCqmZUIuNGk21pxaJ73J+ODHvCVwg6UrMF9N76N5izcUjqpxC737CHX2Gz5zP7KPpI2VmG+iLU6hcnnHH7Ws0ZFeEJcFwCngAb9B/yhhmC0kfwjVTS/ISuYlCD6tac8qc7czHmccMYIVHmAiDDe1Vt1Lj8UgAtHcCNZyMs59GHuHXwJo9AvlODqJwULxA2eDVSaHQGIXsMY3MZMyp9u3JX1ISUsieo8JVBUSh36lwAE9lFNb1HYAEjTnF92qwe2q85+1E4CTgV0xDahgan9pANabGY9KElKLib8CQYQplqlUAP95lXHxYRQ4ZYaE+OwOSlPatD7RS+2km6XW5ppd9Y5Ww5Zg0VG7Kfd76lVdazzX1bBZ/tRZ0zAkROKxfU3ig9qKsLz0kw4CjRYzrwngtujnfjwHvJ9xWZ4DyyWzlMfZnoPJPqBXWMZHDh8ZDTiCVl5mfg5nBa0iIPyw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(5023799004)(11063799006)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnJBTFRUZmZzeGoxRFRvYURsT2s5ZFc5amtHVzR6UEJkSUNDeWUvcG9NVVVN?=
 =?utf-8?B?QXpYQnNqZmExdVVUWWhQWW9GQTJRK2dBTEFtUzdNUU8xU0RlemlCWHJRMFZ2?=
 =?utf-8?B?cDNvN1A3NVN3T0oxNjJRKzc1SGZaME44OXJGZlJnZm5wKzZRb3NrK0VaMFNZ?=
 =?utf-8?B?OURQcnhRdlFYN0pwSFl2MSt1SFZCUjVKRk5Ga2FtV0FxRjJSVnc0TzhEV2pt?=
 =?utf-8?B?THRMWlJrY0lFYk5tUTFZTTU4MERyKzhNZTVDNlJ4akRBb3VTZ1pCSjhYajV3?=
 =?utf-8?B?M1lacnRYWTk3NmU4NnFGVklKZVMzMUxpMFhzMWNvZlprMzl5YThHWkx2Q0ZH?=
 =?utf-8?B?UFlyNk9RbWJFSGk1TTVJSWEyL2lpUnM5TU9vM3JkbTFacEtUSVlHNTRlaUJO?=
 =?utf-8?B?U2lJVDVWRitiZHJPbDhHUWIwa2RnYlB5aXBuTnFneXhlTlQxc2UyeEdnT1BO?=
 =?utf-8?B?RjZCY2lReXFnUnE2RmVQMk1GdjVOT21MS2EvbUw5OE9Kdm9GZi9wUHVUOFVB?=
 =?utf-8?B?empDWmZQdENYR0Qrem9HdkRVa1cvRThXNkFlbWx0UzVLWDMrQ1AwUHJOMWtk?=
 =?utf-8?B?Y1RNR1ZTNThNeU9OSnlrOXAyRi8zaVBZKzZBNXJ2MHRETXArL2x1Rmh6Wmgv?=
 =?utf-8?B?SkNZMnRoT29QYkFEUndwc0hZZWJFalA5RXRPdEcyNTFCbGR0a01LRzU5cVYw?=
 =?utf-8?B?Q3FUSTNKUTdFb3o4MGlTTDl0NzBuTitCMjZBcTZJRDNkdWRjVTlXOGVLeXU0?=
 =?utf-8?B?blZTSFYyT1gxdVJkRDZyWUFXR09JeUQzaWYxRmJ4aDA5UUhtZ0lQZE9kY2NM?=
 =?utf-8?B?eDVNSzhXa3N1SkNOdDFYVXc1eCtYQUpGcmg4L3E3UlF2bGI2WWFJOVU3Ny8x?=
 =?utf-8?B?NkxFRWZpZ0MzbXRuN1FEUWJ0MWJ1dVowRHI0MUJyQ3BVZGRkTDNBWFZTSHF3?=
 =?utf-8?B?WUFtL0cweGNkRkJ4ejZLRUFPTWFoalkzY1lKODBvY09DN3NTd09PRnRkaVlu?=
 =?utf-8?B?ZGJMVHdKeGF4dEdCSitsM05Tb0VuaFB6bElqOS9JWWd4SVBmK2Y2SU1EWk14?=
 =?utf-8?B?SDNzcGZna0M2SENVNHBwQUJZTG5FdGRDdmlEUGZTTHJPcUpNL1RGMkh3ZnQ3?=
 =?utf-8?B?TEQ3UlBPQmw5RGRrUHpEQVlON3N3ZjNzcWVtbjFJNmQ1TThybFd2KzdiUHFi?=
 =?utf-8?B?N2hXUUNJcGQwWlhMcWpEWVZZbWs2MmtxcGpPRWprRlJieHVmOWVlRlQ0T2tl?=
 =?utf-8?B?YUpXWno3b1JyWHNrcHBMSEZZVER4UkNteS9IZncxc0x0bmdwclJ3aExkczdq?=
 =?utf-8?B?eTVBaVNCY3dCaGkwWlpWdDRmVURkN1ZhbGtLMjhwa1kzcm5NLzNQdnZVUnM0?=
 =?utf-8?B?eTI1SVp4L2haRklSak4zL3JIdWR6ZE5EK2JoSTNPT0wzNjJaeFd4Sm9Za0RU?=
 =?utf-8?B?OEpTMVo5OEtFejhvaHN5L2RSUkVKR1lZNEtnWlRVbzFJVDZaeEtKSFhaeEZm?=
 =?utf-8?B?OE9qOUoyMU9VSHJYd245M29mSzlaL1V6S0FWeS9qMS9oVzEvYy9obHR3Y2dJ?=
 =?utf-8?B?ZGs3T0kzdE1YZVRPQnFDRUVhWHpFaWdNQTl4S21tek5BQmRTNGxhUVFHSkhu?=
 =?utf-8?B?TWl1eldOckhVQVMxSHhscUhuYUdHeVBjMThKUnBnTHYyc0JoaHpva0ZwMU5j?=
 =?utf-8?B?QUk2OXJoMnd5aktjRTR2WDdqbzRoRnJKdUlzciswU1c0NzM5RTlFbU5wU2Na?=
 =?utf-8?B?cDVlNE5qQVYreEhscDM1aEo0dnBFRVMyMXdCdHdLQVQxWVNBZDZab3pXNHBG?=
 =?utf-8?B?bTA3RGxIWUlqajV2bnNSVDQ1MlZCUTMxTC9uT3EvNGJTckhJSHU1SjI2clBi?=
 =?utf-8?B?SExOWkFmazMwem9XaDh0NjhYK0F4RVFKN0RzT0FNRGEzZGcwajhLcXIyWElR?=
 =?utf-8?B?K0d6aG1wVElKc25xeDUvbzV3NEJ0V3NSUzA1T0FrUVpISTcya2JPSHMxb1gv?=
 =?utf-8?B?RU1GYnAyWjFURk8zTi9lS2NJZnZ2WVJVKzJMS2MyOWpIeUcrOTVlUGRZQjRK?=
 =?utf-8?B?QmIwQ3FRM3NoMXlHbGlQTzA0amhNaldDQjhQTFRaaWZBaE1EOVd1dFpHdkJi?=
 =?utf-8?B?aWRaeWtpbVRpUHh2RWp6ZnQ1aDBJdGxZc296RW1hSDFueFkyYjE5K1ZVV0Q3?=
 =?utf-8?B?ZExEZjRiclp2S0p1NndPOUtwa1lNdEEvZStwNldVNFQ2WW9vSUZicWZiaFU5?=
 =?utf-8?B?VUZqeGxYeklTWDBvZGI0dFlCUlZHRWlFdnhHSjU3WXBsSkgrdkI5UExNVmdo?=
 =?utf-8?Q?Z2+/tzENW153vPSc3d?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f4f60f8-418f-47d7-76f7-08df1dcdc6d3
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 02:02:55.2582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cdMHMRvbqzEttnsDKRpF56pIo81MH2cmaKOTCucFGsk/ystfPgYQ19JRXJ4h69MU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9313
X-Stat-Signature: gt643tqazrycgceewzbgtoa8xz37ir1x
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DF4FA180002
X-HE-Tag: 1790647382-790709
X-HE-Meta: U2FsdGVkX1+LdiTLfARGuyx2XlJvyfoBDqRb1nnAjrpCzpnMecCPQ9fyXspEGa/saCvION+SNAhOfjATOgT/oduP/J+n10/ar8iPI0k7cJdsq0NwRZmOODeO1wrRIMXZc9hk+tYvAtdJIj29HIGKxE61o8HhGM5rcg7PsU5q38yqCgbMMHCcbO3FGUoIN4aRcXXuX8haDXPGSHd35coaGdVubFO9SGyT7CRIUXPKhSrtVDsZgO6FBeEpj1leUAnmawOLzG8Ol+stb7dt2QUiWIovw9K3tI3QcI1hSXHA8SDNrmsm/Tdeq3VuJpeU1mjdJAl9k+c/YXZITurQsso6q8TW9nhL1UxghY0COTe7b8ORBmCO103/UC9lHKwfsT+YJ+5G9rIsVV8+jslj6LfpqQ+STI1M+JyWEykbexq5CI6JYphQt4ycMKsT2cakjzt5m4H6mtAsVxvqaTZHcoblMeR9dZTsEsfQgQl+alatNr46FTYL+NaYI94SBfWJXOVg9E6/QxQ016yDRL1wCqZgpsAueUT87OoGmOu673Mcl2iLewk34JU22dPSxbPNuHnu4+EpgYxKp4M5NEDrWJ8m1SlQ4F3s0ax8TA4sTMliZpBa/8ffEAaitwR4wstRRHiIUXb31CaPAkc9GhP0SqnRjCTsqTi5EOGBcTZfWf6z/bTSPB/rpCXR4Xj8L5eaPPGURlAcoaYkg4T3O3emQatRt/kWRTql5LkGwohjIo1kMlwrBQ3NWZ4DEJaJ1Jarc57fih8C3wBB3Feyc0MuGfQ6SsK2sBAP4Kjtvnq5Olk+hLVl0k3HyHh4gwZMQbR2C/LP1CCODSueQ6LZAKX2QKviR80UBb8Of1fAdvW7vDK2SdVsODj57A9tRl24Uwe28OQCkMq9kxHP5RHXCvEMFNKpG78zYRBeEA3/6dp9UfLGdiRO5T/c0WczG6Ci4Aru1Y2pI7sJ6Sj5gPiST25JTVx
 dTvX/7ya
 Vb1jekgGDfCfmFJNkBsS1trqfTVuK2+tSB8ccbNqnDqjjfffMgmhJtij/Zan9pBEte8/0Ho2hC9UwCRmNS8eEHkr0ttn6ZlSHw34NG8XJaBYVSIVU6xxla1ia57LagaNkoEbVLjW1sCy7Rut7Q41q+jxa3HhnvLqmYrIBoChqXg/hXiHoah7VIiBeS6W1AW0491ywK/+VSxf5vNt4t+Aqspc2y+9SJWoe7YGo5XH8baZyC3RLx/rrDcWHa8GKOAMsacGM8W/FRKbE6jCbL6qhLpurtnG5klWQVY3qxPpissJL/7awXy5dbDMQs5jcrEHaOr6a4QZ0hh9+hyUrvdqS7tRGh+UPFyLD5wFkLxzrj7oS2NPRM72SGZ6jwcvCNGn+TqfOGZvcWhuFvy8lM+tkcTN4CTEWtc1ncuezRFDPaIncTKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Sep 28, 2026 at 6:06 AM EDT, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> A collapse takes three calls:
>
>   - collapse_control_init() - set up the control a caller carries;
>   - collapse_scan_pmd() - scan one PTE table, under mmap_lock;
>   - collapse_run_pmd() - collapse what the scan found, no mmap_lock.
>
> All three are static in khugepaged.c, as are collapse_possible_orders(),
> which says what a VMA allows, and the revalidate a caller needs once a
> collapse has given the mmap_lock up.  No other file can ask for a collaps=
e
> without them.
>
> Declare them in collapse.h, with a comment stating the order they are
> called in and who holds the lock over each step.  Each function gets a
> kerneldoc comment where it is defined: what it takes, what it does, and
> the lock state on entry and exit.
>
> hugepage_vma_revalidate() becomes collapse_vma_revalidate(): it is part o=
f
> what a collapse offers now, not a helper of the daemon.
>
> Preparation for implementing MADV_COLLAPSE in madvise.c.
>
> No functional change.
>
> Assisted-by: LLM
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/collapse.h   | 45 ++++++++++++++++++++++++++
>  mm/khugepaged.c | 86 ++++++++++++++++++++++++++++++++++++++++---------
>  2 files changed, 115 insertions(+), 16 deletions(-)
>
<snip>

> + * lock it took to get there.  SCAN_SUCCEED means there is
> + * something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page cache
> + * already holds the PMD folio and only the PTE table is left to retract=
.
> + * Both are work for the run, which is handed what the scan returned; an=
ything
> + * else is why there is nothing to do.

These are implmentation details and already documented in the
collapse_scan_pmd()'s kdoc.

> + *
> + * The run is called without the lock and returns without it, taking wha=
t it
> + * needs in between: what it does -- allocate, isolate, copy, flush -- i=
s slow
> + * enough that a writer would wait behind it.  The caller gives the lock=
 up
> + * first, and with it @vma and anything derived under it, so a caller ca=
rrying
> + * on has to look up again with collapse_vma_revalidate().  The run reva=
lidates
> + * for itself rather than trusting what the scan saw.


The run does ... would be sufficient, since the above is the same
contente in collapse_run_pmd()'s kdoc.

> + *
> + * A scan that found something has to be run: the file side takes a refe=
rence on
> + * the file while it still has the VMA to take it from, and the run is w=
hat
> + * gives it back.

This is a repeated comment in collapse_control. We only need one.


Otherwise, LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


