Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4268C4450A
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 14:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375BF6B0088; Sun, 19 Jul 2026 10:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 326026B008A; Sun, 19 Jul 2026 10:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EEC46B008C; Sun, 19 Jul 2026 10:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3A7B6B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 10:24:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 064C91A056A
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 14:24:43 +0000 (UTC)
X-FDA: 85005747246.12.72BF59A
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010018.outbound.protection.outlook.com [52.101.193.18])
	by imf06.hostedemail.com (Postfix) with ESMTP id 16622180002
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 14:24:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AwvvHq6g;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.193.18 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784471080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EDgHmpcji39eywc/pKdU/gu8iYvlFVGk07U8THYzPn4=;
	b=zGPaXQd4j3b/kFltgS3Qn7GWWojtlU09sAj/+e1wPhvSXWlmeabJOgPR0GyViK0yarB0Nr
	paqRA4RZurr92bmFq9af6MLSfjTNVk0Dk7y3kxhx4GhTDt9PgHAoxrVYXmlwEF91gu/31G
	+xhuwJ2oeyA+lQWG5ghw9iUcPmUnSdU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AwvvHq6g;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.193.18 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784471080;
	b=Di920EVuiPb5SXikDLzzAj8GWHOEkfPednEHUsf7Q9PmCgwDcke/Wa43FNNJyDRKZ4SCR3
	6oaGmSu/eAADV1XSfK9ovAHQClS7XXwngcQu/n3P2U+qxIq8jabqYf5okLeTJc30cwI1PL
	aKXnaT/wSDCifgxmxhvjcTzUoIt50Tk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r7Z7fxwnSUE1Ywm8taQSLgne5tjJwTFw2OaAJiOckqxhNN7cgF0AZzqmlHOlfuf8677eamXA/tVvqvwgaGk6qfMPOOOKrjCV8AcpgyAXrNPkQkRWjjmgUkKJUmTioEVIFi/jbkMeaTyWoVaWKayp+/1aVKNvnRiWSPWqhwuDcj+z0BuSPj3sJVH2hgHw+XP66NbII8oQXlNCAJ/bN3haHdO7Yl1lNvu9L/iy75gSsJGYimd/HjXyE+Rg1i9u/8hPtFirrZy2g08vGNJ2Uj7v7qAQA7M/g34wBSP643somfP2B8CdKLZyelyrbfJsdj3VkPQIXsIIJabSwu5BH0b0Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EDgHmpcji39eywc/pKdU/gu8iYvlFVGk07U8THYzPn4=;
 b=gRqrV2rY32gFjeJV5OKp9nGyKv30Z/QWJwU0dgqKbsIvHgtkDkx/pOTpak0jnQ6myQQcI1iSAanEMR7BQwtI9iXxW3yow0G308831ta4p3j0XEhtfiFbW6EOrMbvX7gJpQ5jOaQWOXFPQIuj6+tlTHHcCNHUnWQWHsoPDNGywiY35Z+wgTy6i1+U+FZbN0QSA4JP4Nf0/Wa/YemFNzeukeUOMYBqSumEI7oIbUvqKCFDgK4pKD9Vxrecm74aZiPvLv8d6dIytqgDwRRQO0zHgk0HLuPQsKqW4Q3WWeHvou9S2X7gGkdyAhEyZhY7e21RSAEMgnKeNO/7G6l842l8qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EDgHmpcji39eywc/pKdU/gu8iYvlFVGk07U8THYzPn4=;
 b=AwvvHq6gAiR5MLH7iywhPTYRe49aYLFK8UPDjUolkOSwRligfB7oX19nUDQStFlC9pzDqcMmtOPwLSMqM4thuhrw8gCTNCbCd7bmFGqpjFdfPf/q+Phu0FkXiKIB/xCjzDTnH44C6vyAvSKFGuY8GuQBomkNTso9D2FbCHXsdndE/OAXQMJGL6MeYVowYsOwpb2bIZ5paabtPsKao+mzG2mfNpM9TRSbCflVQsqR34NTGoDDtTwMtf+xpSLkwHdR/yfeyHOHlo7idGEohaOkNQZkT4/cI/AppmYfqV7oxCkj/VDejratbSYVBdHnEUpollgfZF5x2cxGuykRMiv0fg==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by PH7PR12MB5855.namprd12.prod.outlook.com (2603:10b6:510:1d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.15; Sun, 19 Jul
 2026 14:24:34 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0223.015; Sun, 19 Jul 2026
 14:24:34 +0000
Date: Sun, 19 Jul 2026 10:24:31 -0400
From: Yury Norov <ynorov@nvidia.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: "Liam R . Howlett" <liam@infradead.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Burak Emir <burak.emir@gmail.com>,
	Eliot Courtney <ecourtney@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>,
	Tamir Duberstein <tamird@kernel.org>,
	Yury Norov <yury.norov@gmail.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benno Lossin <lossin@kernel.org>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Boqun Feng <boqun@kernel.org>, Carlos Llamas <cmllamas@google.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Danilo Krummrich <dakr@kernel.org>, Gary Guo <gary@garyguo.net>,
	Lorenzo Stoakes <ljs@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Trevor Gross <tmgross@umich.edu>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH] rust: bitmap: encourage using xarray/maple_tree instead
 of id_pool
Message-ID: <alzeHwmGJsmK4z96@yury>
References: <20260711-id-pool-move-bitmap-v1-1-cd5b7efc2c12@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260711-id-pool-move-bitmap-v1-1-cd5b7efc2c12@google.com>
X-ClientProxiedBy: BY3PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:a03:217::8) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|PH7PR12MB5855:EE_
X-MS-Office365-Filtering-Correlation-Id: 5968f01e-5252-44dc-20c9-08dee5a17457
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|6133799003|18002099003|22082099003|56012099006|11063799006|5023799004|10067099003;
X-Microsoft-Antispam-Message-Info:
	Ax34+BMNp4rgko1X3ZBFgBXTZL+FpSCJsZu5e6ECkmRfLW+zKHmahJX3jhP1DRdwLty9h8uuruE5aiT4R8JsL2k8xVhX3W38rDuqoHMXTXVhUSgPoZ7qt8X0gAh7eVJxlv6Lyf4h1oSm57GrUifFchoNs8QgkGcEf4pPQYaUeOd0ELZFTFnTjd/aKo79lpJ3kjLNNFAWiWh3Vj95I8ti3wxcOG9cTp0JeZ2CLGZ5H9PqzfQ93RZxGDK7qXyEfHXBOQkhPtI8mww2++KUImLHyaP+jfYAl8t3qc+vSrU9qK2bdvhmCv7keMiNwVT3YaXAwpsjK9KJLyePbbi0MA//3bqTYJRE2soOVhmIhUJhn2XUHSQhm4VrYYS1MQOdMlbzCuMge/fk+NM8tn1DTI/zPmQ8R70xWbTEFANwRK91DWWlVZcaZjaBXvpqsiuZO5AIDGw9oAE2fRuqV5tZ7wuzbYKfS3AeoUJg910Eu0+AME/EtdHEgGVikGvj59JzdNUD7jkD7cvr3hzSTeRWjwFO0fqvSpoQleGk5r6imd83ZalxUtQkgU+CLfjYxSpyPxXZyzfetjp12vOk5fuIfjUGPSaqfRJncRL95L9db2+7byUjwt2umQE98u3n63RgQEf1dkd3NmV1uqXI/CCBCoYVQ4G9dIVVd6eP/Kd4ZCbZ5q8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006)(5023799004)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+SbY+oKhiT6gABe7jSdz1t8rKw3gA0i6xHWhfDla+Ok52ZoZkGvh5n1WlXSk?=
 =?us-ascii?Q?vZdZmeeK7o0E9SbMIzPpxQT/WHitJiE0vRQhwDaJvQkoGiGE4vIBwb0uz1oq?=
 =?us-ascii?Q?7F6yBdZe4pncUYWXNxLOdIzpq5Wg35Ty7Iqcq+UU/vYLOnLXpp/QPfWRthQA?=
 =?us-ascii?Q?kw1T8K9t9GaRyyoLSpkMY3p/xak7dDng4t44mReB2RdXPiiOONqpmTxnBADX?=
 =?us-ascii?Q?WZONb4RgR+UXqB4q1/GSZJ5CuGxifqeOfZ831bIYzFTc8zdQsFxuRwsSdVZF?=
 =?us-ascii?Q?SLH1xuVVazEG/a/1EVzq5UvdsS7AF51cj5hH5CAXI3YLl5letC4EKDTTeCKJ?=
 =?us-ascii?Q?5u6KNuGrJXluBaB9Bco4pdcmg+pkPUM0i8JJdh6MBqTxOXWTYjlAWnaOo4mP?=
 =?us-ascii?Q?xDFWafBoDHCE11GCdLb5wt4hUkWvTPrQivEdGzO1d8Iht5tJL5KABHBC2BKl?=
 =?us-ascii?Q?Qu9jiVo+cStvPDT97NrA26O+VQI/UjIX2FwBdOWuks3xk/g5bHF8yFvG4IYJ?=
 =?us-ascii?Q?QDgiqUoXiq8IjHqeySZxAuXxB0H+NIIWKnjNbytx7ORz3Q+YY2p+CoSQ8bXr?=
 =?us-ascii?Q?c86BqYNTtcQ2oMw0t0kH5bSp2KWavsH96jCixzSyvIy+7mVgkglca6mHpG/k?=
 =?us-ascii?Q?G4QbfNhAmuSo4lpiNSyXKJptNovoRQsql2OQO4AS0kEF1xg4IPo0b/Ip6WKX?=
 =?us-ascii?Q?WWdXUeEFD0IHc+uo39J8aqy6kI9BmarRKvCX+CEXIcmNilYIHhSg2hsoTsK6?=
 =?us-ascii?Q?2LPWbwm05g1rfhigyvlWJXk4L9iRIMqC8ff60Pf9bgApVtLslvcJfGtI1pYC?=
 =?us-ascii?Q?AtbW1M+dNIVEC9TJELijIAV8pKVe3P2kVXsrDS14H0B4G+Rhjl9DG0up3YIo?=
 =?us-ascii?Q?gQwIMPEV4sHjf+FulVLLwOkT1T3fc/tNqM7GOIKvZnRs+Cm1sl7EYqNBdvp2?=
 =?us-ascii?Q?b0fkFwvrjOTmRpDSFNzwviP7266f+jJGUdknhd/oyHJbtiM6h9mMtSPiZ0Mn?=
 =?us-ascii?Q?bZ46HXOi/OTWk3Gk1aJGwff+MXHYTEjOnzr28lXedx8gbDv/01K1VTX7zoZv?=
 =?us-ascii?Q?q9rNPrn0qCx3iED8f/nMA30eMrwnLyEwPgdo84sEmw730LtPNEFg1aq5GCbt?=
 =?us-ascii?Q?wTsfRy/0OSbZ2qHfl3LuIesA+XhcQYJGR4WiO+YbIiJJ/E/1L+gaEs1GYU6z?=
 =?us-ascii?Q?cMH6fvEwKfmc9QoszORqocYbJWDMupVV/xV7VnrAoAAlUbIgU9r4IfHI5Vwt?=
 =?us-ascii?Q?hmM5SSwna54leipkzbvsMY7j8d3vEDzxX0nGGyQ01VHymK+wBNeo8DNbR0Gn?=
 =?us-ascii?Q?2VoPhfEo43bUcBu6NDCsgx4EznTN+W1gkKNiwYEs7ERZ5fj1ci2WgFGVwbwA?=
 =?us-ascii?Q?LdmEMsODfRxqHgC9bdUd+PAaoxT1QsLHityvch1ULvxCfL6ciRaoBG4gya93?=
 =?us-ascii?Q?/Dw9heZzYxzyd7Ys+XyyTrYazjBatAe5WlTBoEDHciZx21Jv0hMR8z7dxNac?=
 =?us-ascii?Q?O7yGy72PcIX/Vr6MUJ7YG58OCWUI+ZBc/TrMvh+EZoTmO7ltz1WZCdjfUqs0?=
 =?us-ascii?Q?h2ueEtPXWHeuY/9TSVyjETHg/hfyPIeU5F5dTJJokRDNqMDQIrpvh9lIHy0J?=
 =?us-ascii?Q?gz+KDmPTc+YJpKtYeESZYG4FLpf0e1CPbIpC1jpEy7oC37GJer0VLoe5x684?=
 =?us-ascii?Q?4NDq8wffJswvDs8t2TsET/77annpjzrphN4Svw4otTsn+ZdUVhiRpf5y/lNv?=
 =?us-ascii?Q?G/Oy+5hayQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5968f01e-5252-44dc-20c9-08dee5a17457
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2026 14:24:34.1699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C9mpO0jeWce/mybB97b//MrQGbnveTxp/wYG8EszoxolUzFl4hd/b3YhY474wHUxtH/mX1JPvoymRmG0ni7hug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5855
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 16622180002
X-Stat-Signature: wa9dqke57qhrtf9zb5tdfbn54875uxgo
X-HE-Tag: 1784471079-789862
X-HE-Meta: U2FsdGVkX1+yoLAZuEtr/6FXLteMnN4kZsKcL6Nwqvvb9nUMmrQ2vbqgOq/SxBaCAFEvdtPb/K32DWrp7GOQObMWe0r17VFFCvF/ueRdxojB7bt/GsT4qQG0bFhY1khEW475ZwxnyJpbKMwC0oL6IZGkx2KwXzkfGcpuY6hz87JARZJdNMxgxnZucnVFuVbXPVPE+pQz8mNBUEnE37hLEBMOPM1+szY7C4dwPnv3z6Pan7ebs4Db0OuQENezYxntztv3sRmjeGFm0B11Bdcj9zcPhcpJUl50FGOHQcP6PiLeVT4hB1OIy8IUBliEXusqRTWRRmXunvSlcVvVxsljG6nts7gTsEomf0gcfYTWtk/Mkg+lLw8gzDgOtkHDJC7D/G2iLYolEblp5oRWg2ACgLIAhDriG09Q66OUzmmj1C9ZiegNbuvhT/9fSgzYhqu4ZWLZ5uOATPcP+bOQpbqgHHi1Y7KpI7DlNnXqLFBgMDtliIxuwvq0cD2TrQJCAU5Tm7O46RZGtlKBDoAH6BSBW8l6FwLZZ717kyE6htoIRmdwyZpK6tbhcO9YF6XlhXgysLIGHA6sPk7XDbcFVMI8+ZTgruZGDkcsysw9iFSClsDIRGUB7QHV6s+rV54/0W/9QKNSAAnhGQPudLfwtJPkbH4Uuz1yPASutG81noNDYfgqpY3975t/P7X8GSgbqhnbBL0PfUv5hOA4bkLEEGEah5vr/GbHiX0+7/w7XWwrhLh4seKnNEsSNTyBkZW4rLxSCBzbUv9+OJw5p7firhq+xX7Pc1XXoSKQ5VnJxYaI5v9cpS56bUP2kTxvhDDT2O4L3TQq3NpuhMhv80R3F3w4oE3FQTnCpXGNIudX8iqoCcgozM9hSUvshMEwRuL8rGapR/S4pK64rNdsFAkCQt9xLhSaBy5aqbnzt1d4wpshgT1cloUspH6cItxuu1LZwBJE1dIZTKzdywn2lhA50oK
 +snkk35P
 eVr/yMGdMrv2zfh+QT7Rvmr8mDToaKP4D5m+xlglRXb7EEAzRL98jo/XwxgqcAVAO0EcsF5LN3evOjhqgUAEpqTugAFZzJr2MQtGJNS7H/aMujk4Vau9oSD6tkRP2tHwbe6ALSYmnmjiH6M+sI30m4zr7FYdmyd1ZYvqKzRDQ+HWXuTrtll+uqNpcaLJYlNylBugTQYfADVkcx3r/zZZw7CY/HtDuY4z6/02noj33XHoUgoKEE+NRiaQOTlEeON7BMxCaWae9LW+EuvrhoSKpx11lCgMp/LHjFY9iRy/Heb7vVPNJaNefpa1bQni95hWQzHkWQSFC+3mAo0gmOM1ArgFTde98mVgZVf3F7EyC8fiNwW7PJvFV13NBWBUcZWThQugjMyYTORL4rFhafW2T7XN0hXXOV8lKv9/qwOIrBd4oYBxTC0u6sd8R6ZR63mUrEm4OpBWiOKgc+UgIwvkWu+CfvxjU5Xyse4QggjjYXXVGKfbJi05Odjrox5iLyD9JPy05bnML1JounQK5Hs/D8dEZfjDjLDBZnEORWHPuI6bxojLwMBYBh5EAtZYj1pcg3g34NeDbOhZBk13xXQQewBpF1MTUoMyQAAXKyGT7Bb0XSfDAzqsKG7h2HQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 11, 2026 at 01:13:05PM +0000, Alice Ryhl wrote:
> The id_pool.rs file was added for use in the Binder driver, which is
> using a bitmap rather than the normal IDR implementation due its
> specialized needs and performance/spinlock requirements. However, its
> current name as kernel::id_pool encourages using it over other IDR
> solutions.
> 
> To discourage choosing this pool when you don't need it, move it to
> kernel::bitmap and add a comment recommending the xarray or maple tree
> for generic IDR use-cases.
> 
> Please see the below links for the discussion that prompted moving this
> file.
> 
> Link: https://lore.kernel.org/rust-for-linux/2026070334-dollar-hexagram-e49c@gregkh/
> Link: https://lore.kernel.org/rust-for-linux/84bc8bd2-e292-4b84-9580-a1b5df4c5bdc@nvidia.com/
> Link: https://lore.kernel.org/rust-for-linux/20260711063602.426311-1-ynorov@nvidia.com/

So, the 1st link explains why id_pool needs bitmaps, the 2nd one
explains why NOVA needs bitmaps, and the 3rd one is my non-rust test
that just provide numbers.

None of them explain why bitmap needs id_pool, neither that id_pool
is the part of bitmap. Because it's not.

ID pool is a user of bitmaps, not a part of it. If we move every
random user to the bitmap directory, that would be an immediate
maintenance burden on you, Burak and me. Not sure I'm a fan of
this idea.

I think, rust needs the lib/ directory, similar to the kernel's one.
Bitmap API should go there alongside with the cpumasks, bug.rs, bits
and bitfields, maple_tree and everything that normally lives in lib.

That would address your id_pool vs other IDRs concern, because it will
make id_pool just another API under lib.

In the mother kernel, we have a flat hierarchy of the lib, because the
corresponding API is exported via the better structured headers. We've
got no headers in Rust, so I think it would be reasonable to create a
structure for the lib where the close APIs are grouped together:

        rust/lib/bit/bitfield.rs
        rust/lib/bit/bitmap.rs
        rust/lib/bit/bits.rs  
        rust/tree/maple.rs
        rust/tree/rb.rs
        rust/lib/cpumask.rs  
        rust/lib/id_pool.rs  
                        
Thanks,
Yury

> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  MAINTAINERS                         |  2 +-
>  drivers/android/binder/process.rs   |  2 +-
>  rust/kernel/bitmap.rs               |  2 ++
>  rust/kernel/{ => bitmap}/id_pool.rs | 26 +++++++++++++++++++-------
>  rust/kernel/lib.rs                  |  1 -
>  5 files changed, 23 insertions(+), 10 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4a8b0fd665ce..d80377d06c3a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4639,7 +4639,7 @@ R:	Yury Norov <yury.norov@gmail.com>
>  S:	Maintained
>  F:	lib/find_bit_benchmark_rust.rs
>  F:	rust/kernel/bitmap.rs
> -F:	rust/kernel/id_pool.rs
> +F:	rust/kernel/bitmap/
>  
>  BITOPS API
>  M:	Yury Norov <yury.norov@gmail.com>
> diff --git a/drivers/android/binder/process.rs b/drivers/android/binder/process.rs
> index 96b8440ceac6..eec417604806 100644
> --- a/drivers/android/binder/process.rs
> +++ b/drivers/android/binder/process.rs
> @@ -16,10 +16,10 @@
>  
>  use kernel::{
>      bindings,
> +    bitmap::id_pool::IdPool,
>      cred::Credential,
>      error::Error,
>      fs::file::{self, File},
> -    id_pool::IdPool,
>      list::{List, ListArc, ListArcField, ListLinks},
>      mm,
>      prelude::*,
> diff --git a/rust/kernel/bitmap.rs b/rust/kernel/bitmap.rs
> index b27e0ec80d64..ecf8f194cf3a 100644
> --- a/rust/kernel/bitmap.rs
> +++ b/rust/kernel/bitmap.rs
> @@ -12,6 +12,8 @@
>  use crate::pr_err;
>  use core::ptr::NonNull;
>  
> +pub mod id_pool;
> +
>  /// Represents a C bitmap. Wraps underlying C bitmap API.
>  ///
>  /// # Invariants
> diff --git a/rust/kernel/id_pool.rs b/rust/kernel/bitmap/id_pool.rs
> similarity index 93%
> rename from rust/kernel/id_pool.rs
> rename to rust/kernel/bitmap/id_pool.rs
> index 384753fe0e44..d6440ec8f60f 100644
> --- a/rust/kernel/id_pool.rs
> +++ b/rust/kernel/bitmap/id_pool.rs
> @@ -3,6 +3,14 @@
>  // Copyright (C) 2025 Google LLC.
>  
>  //! Rust API for an ID pool backed by a [`BitmapVec`].
> +//!
> +//! The id pool provided by this file is designed for specialized use-cases
> +//! that need an implementation backed by a bitmap. If you just want a generic
> +//! ID allocator, please use [`XArray`] instead. Or for use-cases that require
> +//! contiguous ranges of IDs, use the [`MapleTree`].
> +//!
> +//! [`XArray`]: crate::xarray::XArray
> +//! [`MapleTree`]: crate::maple_tree::MapleTree
>  
>  use crate::alloc::{AllocError, Flags};
>  use crate::bitmap::BitmapVec;
> @@ -23,8 +31,10 @@
>  /// Basic usage
>  ///
>  /// ```
> -/// use kernel::alloc::AllocError;
> -/// use kernel::id_pool::{IdPool, UnusedId};
> +/// use kernel::{
> +///     alloc::AllocError,
> +///     bitmap::id_pool::{IdPool, UnusedId},
> +/// };
>  ///
>  /// let mut pool = IdPool::with_capacity(64, GFP_KERNEL)?;
>  /// for i in 0..64 {
> @@ -47,7 +57,7 @@
>  /// ```no_run
>  /// use kernel::alloc::{AllocError, flags::GFP_KERNEL};
>  /// use kernel::sync::{new_spinlock, SpinLock};
> -/// use kernel::id_pool::IdPool;
> +/// use kernel::bitmap::id_pool::IdPool;
>  ///
>  /// fn get_id_maybe_realloc(guarded_pool: &SpinLock<IdPool>) -> Result<usize, AllocError> {
>  ///     let mut pool = guarded_pool.lock();
> @@ -134,10 +144,12 @@ pub fn capacity(&self) -> usize {
>      /// ```
>      /// use kernel::{
>      ///     alloc::AllocError,
> -    ///     bitmap::BitmapVec,
> -    ///     id_pool::{
> -    ///         IdPool,
> -    ///         ReallocRequest,
> +    ///     bitmap::{
> +    ///         id_pool::{
> +    ///             IdPool,
> +    ///             ReallocRequest,
> +    ///         },
> +    ///         BitmapVec,
>      ///     },
>      /// };
>      ///
> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> index 9512af7156df..8e7717bb8b9f 100644
> --- a/rust/kernel/lib.rs
> +++ b/rust/kernel/lib.rs
> @@ -77,7 +77,6 @@
>  pub mod gpu;
>  #[cfg(CONFIG_I2C = "y")]
>  pub mod i2c;
> -pub mod id_pool;
>  #[doc(hidden)]
>  pub mod impl_flags;
>  pub mod init;
> 
> ---
> base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
> change-id: 20260711-id-pool-move-bitmap-5b0dc0d2befc
> 
> Best regards,
> -- 
> Alice Ryhl <aliceryhl@google.com>

