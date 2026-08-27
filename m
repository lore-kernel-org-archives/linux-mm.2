Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59FF9C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 15:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60CE36B0099; Thu, 27 Aug 2026 11:03:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E4BB6B009B; Thu, 27 Aug 2026 11:03:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AE096B009D; Thu, 27 Aug 2026 11:03:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A48E6B0099
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:03:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 98B5680495
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:03:27 +0000 (UTC)
X-FDA: 85147368054.21.9B1885B
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011054.outbound.protection.outlook.com [52.101.57.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id A0C0080016
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:03:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ee+o/sOy";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787843004;
	b=qRdm9xSrTpyzS0RVJUj3hhM1Olx408dzfSaugqRufGHhLkrVagMpx+hBr2OBJywai9JlvP
	ACkwqjF1OpSWwnRyj7AxQdayiKNdkOfZxBtYlWj+ZhNQCs2LHday+YvtXldD056qP291UQ
	RMz212SGEgsq7dFJoSsBd7zngrWtPuQ=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ee+o/sOy";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787843004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3KlvgrmY/IkLrM0v4qwBaz5zQimUvD/5vogqKr1f9lk=;
	b=2lwpQfi6h9gFeGgm5qgeah5NfysVngXUSt71ZoZfkoHZ7Qkkx1llbsGeJkzKSgzxPhk0RI
	9Y/nbIL1bPS7AucUTXWq9ItCQH2DaYHhvFfuEnj+NgD6paxTjaAUAZSfj4Ed+4Nr4Y3Xhy
	YHhhz8VxnKWr+sXLziTxMCCh6a06V2I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aPDTCzi0xMvrePRf0foPsFGHNwBJGniPL/hdOE3k6wF473smPpI7s2lmZ4oVhRk3jyC2CdXj+wE+H5kt8siLnc00H8o8tgpAXNRNRT/R6qsVZTtoUt0keh21vlaraak6prXF2DsePBO7uU24rbXwAPFfY6ohW5LpoqWDsLJ8Jii926GGHlJRzP0mhB8YN0RWrq0z83dn7PrhIHABzejlwaHodC/i2dq7rnMFR2H+8XQADl4yruoWhZ1G549Wn9g/gXkiYyk7WSMUDAtczEB7mIdWLqorui1UqMY3bhgSEzQsV+Z3yFEQ/Mb3HJZb46cW1Ixa9LEXkxpU7SZB5AaZ5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3KlvgrmY/IkLrM0v4qwBaz5zQimUvD/5vogqKr1f9lk=;
 b=BArCwqDQVCnqXvp+HuBV7AscsUXckx3hFtw/8RWCvhlgWeyH+9a6BeDAIh1NvGm4p2RG9NXmoOmtqeCWwslauFhBTl7wI5YCEWQLhu6RJLDu3tMJsUcLJSDc9aUFbE4FZPzkG5izdqeLnDpeXntTFqIalSjOTKxQU7zfVrPoXCwfK//AKStddhYgTVNDtlGXXyjpLMkbEB3VHiJlNXYdFhve2FWODfDD0+FF3Kz9uWAq8cUqRwmt+0nQ7vRcRPIdRbGOx4vqh5JYzF2rwry7kUQAtYW3kt9nhSJBE5tzM6ExV43vI1eIiD7jdMMNlVo1KQ94MC0btOSQtwsoXSt9mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3KlvgrmY/IkLrM0v4qwBaz5zQimUvD/5vogqKr1f9lk=;
 b=ee+o/sOyRiHKe46/sr+cs0z0RBaMvjTfYp801CSoWt9ywRS6CAEq4JUk76NBZFa+I1ZwRap3q85AVhxRod0bgTI2txcXz/x0hiquPGrzocINiFZC87mIqvyuxNII32/6RgdQkpbkh1xNJu/pA5z6xvHDdWYBS40uQsUvtuRYhgfnxfPuuNMXCmrEAUa7+NVrJlnB9qzRfYFwSPbIHyAkUOxHzIfxt1ySuf/nsqppgItELLczUVTKPTPLzrQlk/v8vaCq8kXzKD/CM4rmMKzBGDDxbcfMfAHXZwZF+CO6/OAqua2gYgnINotiixVXCHZNQ9NelaUXsomRT28ta3a01w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SN7PR12MB7107.namprd12.prod.outlook.com (2603:10b6:806:2a2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Thu, 27 Aug
 2026 15:03:19 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Thu, 27 Aug 2026
 15:03:19 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 27 Aug 2026 11:03:17 -0400
Message-Id: <DKZTG6MI4EI2.35PCXKS36M1DY@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 2/2] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts"
 <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song"
 <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama Arif"
 <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Shuah Khan" <shuah@kernel.org>, "Kevin
 Brodsky" <kevin.brodsky@arm.com>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: "Yeoreum Yun" <yeoreum.yun@arm.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>
X-Mailer: aerc 0.22.0
References: <20260826-fix_split-v2-0-71153c7f579a@arm.com>
 <20260826-fix_split-v2-2-71153c7f579a@arm.com>
 <0107447a-7c1f-44f8-94fb-109b0f850677@linux.alibaba.com>
 <apAVAvfxZSeEvf50@e129823.arm.com>
In-Reply-To: <apAVAvfxZSeEvf50@e129823.arm.com>
X-ClientProxiedBy: YQZPR01CA0173.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SN7PR12MB7107:EE_
X-MS-Office365-Filtering-Correlation-Id: c0cb2a3c-b74d-4dc6-3f77-08df044c549f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|6133799003|10067099003|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	0HRUbRkfXTieK5hE773gH9vjrDwbz6195xiq6km07h73Uf01jY8lqxBR3bfTdztPRcn7zY5V1NQm+h80vW/orsVDxzy9zG5YA+KeQapxydjo8gmsvdB8Y0QdrDORGd5Kg03o2C0LjsL3C6HzJ7+SP2CO3JBzQtTeVY43Frg9b8Q+lf2kMM5JuIV3Oexc/9sVoCvtvfgUcRwpsvO8ODyEl+MIdq8txwqGAfGXFOvlo2+GrLXzkQmA57EyZ9eC7Jt4MK/U+1UJ/qkZTxissBpnrS0jrtgowHMt0Ji5slCheLLD7kh3ctpXeTb1ct0A+Nvuk++dA5MfnJxCzxVGVIZjoQq1UwtQ4KpbUicyY+79YWcC0BYiFgdkv55/Cf+6aB985KDjuiqfRXa11JBzXuJ+76tGArYN3kprxj7+OVLJ4jST+V+CDw1sbK6iYWIJAlxAu8cQXLSeN6hY0D1LQeaMbdY2G+LSE3FCe5syTRMWTlSu4ZETNrVwdJ6CCydPqc2t5cI0ZMPBvrLbXNmJvSlNxEL9c2omy4X0IU6el6G9xjW7zmoZVFYwSbEKI5IsXW6fveuo+rKEJg+gMq/olbkR1kFfGb8hBJIpbpgCPcjcbr2HBa7y4/7ot+JuU5+r4lTjwgVSMr3GvT8yAupVMYyaxcOSRFSF9W9hJiIbjBiXj1U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(6133799003)(10067099003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ck5xT3ZrZmdmQmJhRktMT3VNcmR5QVp2UThYNEJqK2FCaFZRZVE1N0NWUFd5?=
 =?utf-8?B?cnZsS0hxMGoySXpzWmdMN3ZwYjVnUmNoa0RQckw1M29tZFZSWXBEUmJINFAv?=
 =?utf-8?B?c05NOW5vL0lBNFVIaTNVUE01RFFITDNpa2NINkNoSWJvR2JHOEY5NWc5UU5l?=
 =?utf-8?B?S3FDSHR2WUpydHZjMVFaazlGUk9hSDZJQTVWVXU4eHlKcTZMYm1GdmpBckg3?=
 =?utf-8?B?USsrL0xnNEZCZjFtNzJiNGg2NmlZUzJuOEV2aW1BZHdoVlFaVC9ESmlQZ3pE?=
 =?utf-8?B?blhhRDFlS3pIVDR2a21xeG9WZTk5clhZZ2RFODhwaGFBaDVKTVNSUVhzaUkx?=
 =?utf-8?B?cGF5V1JMM293MUh1dmMyWllQOE8zbzhER2d0K3JmKytTTzBmM1UvMTdHaXhi?=
 =?utf-8?B?TVVBU1BQNHM2OEhNT0V4K1p2TDQrVFNpdnRJK2Y5djUrWjlHN21rS1dsaDlX?=
 =?utf-8?B?VUZ5OTlDMFpmdjl5ZURNVWh3R202NzU1c3ZsOW9BOU4rOVYzanVFL2tMcVhx?=
 =?utf-8?B?YkZObEZ6ZzYxTUVBMC8rTDdlY0drclV0ZENlR0t5eFRuclZQUHNZRkFiS0xZ?=
 =?utf-8?B?SHpXNGxPcU1ONytHbVJCK2gzVy9kSkVrakRMUEpURkhVQW50LzV1Wms5UzdW?=
 =?utf-8?B?VnRZbXAzdGI5b2s4TisyUkZmNmpldU84Q1V1cmpubTZheHV0aS93cndRenhM?=
 =?utf-8?B?VCtkbTAzNTBJMVJRTDMvSTlmN0wyYTBkZC9jTFJJMEF3djhROFFYYzlnQ3c0?=
 =?utf-8?B?c0NUU2Z5bW1QVHJFZThKamdOTExZeDJVemxpK3ZZWGNkSGNMdzVHSWV4cGFx?=
 =?utf-8?B?dkEzZEFiVFYyTXErbVBDVE84eVgrbHVmWkQ3cVdOdzJpVUpIeFR6VFZIZ1JQ?=
 =?utf-8?B?alN1YmxGdkNiWDc3WFNJTTBRSEoyRHA1SHJIVVg0Vy9mWm9OdGw2SUlsSVg1?=
 =?utf-8?B?dFR1R3dCakNtLzUwejB3VjdaR1RlZkhZZTdSVDdJM0JMWXNuSFlCYldCZjRu?=
 =?utf-8?B?eXRNYU9ma2VadU5rcklzeUhkcm91VUY1ZDBiL29rbXZQUWExM1d5V3lMZHdG?=
 =?utf-8?B?dkp4U1Btc1Nzc1NVU2FtWGNQNDV0ZnpjdWNRZ1Q3MUU0S0xIdkVpSTZtUHdD?=
 =?utf-8?B?U25KNEtyUS83SnR6ckdBZElFbFhGU0NTNm1yUzVZa1k1QkRKWUhmazh5M2sz?=
 =?utf-8?B?Y2U5OHUvL1ppeW81RkZKeTVvMHkwbVBuWVE5UWFTK1ZCZklLU1hMdjkxUEgv?=
 =?utf-8?B?ZmJPbG9ENEJUd0NOQU8ra3p0UTgycW5sdFN0Yzk0YTAzbzBpcllHblpaemhp?=
 =?utf-8?B?bEZzWlhSdUJEYzNxZmJXZ2ZQNkZRQUY2eEJ5eHNOM2hRVkFONFVLaEg0R2U3?=
 =?utf-8?B?bTVyZThzTEkxcWd6KzY3dTZ2eERteFBNZGVsUmlLaWJBYjltT0dXbHZKZmd5?=
 =?utf-8?B?WXhtR2tlNmd0cFhBcTVIL2toNmFwWHhpTnlLTVEreEdLOHhLOFVJem9Ea2lW?=
 =?utf-8?B?VEZ1N3lMcm5zeU85QnF4RlhPNC9aT1BwSkMwd2Z0L3lvQ25KWi9OZHUrbmEr?=
 =?utf-8?B?RTdvekdIUmVtR2xnM0padFhzVHpVL1FPd1krZ3VzNjhBNS9zSWduREMwRHVO?=
 =?utf-8?B?RjdCd2YwMFlNTXF1ZFYzNGl2MzJaYWR1OHFMcG5UUlNranorTFg1SkFNMFJm?=
 =?utf-8?B?bFZMdk1wNXVQNHQrR2wwbDJ0TkszTXRrSU1YaS9OMzRva3VIYjFNM1Q5TEpv?=
 =?utf-8?B?Vk54bXZ4RFYvYnlWL3JmUjk2cnhkdytzTmNRV2xqKytjZU1kazVXRnlyWmxR?=
 =?utf-8?B?K1NUd1hDakdRR200UW5MY3V3L0o1WUtZYTJIdGdmZGU3YU1QLzNwMUFMSGI2?=
 =?utf-8?B?MVVsbW9CUHQwbDhudW9oNGtVZTZzbTBZNitVU1B4WHdBZW5aVjhTaEl5Rysr?=
 =?utf-8?B?WG5McHV2NTJFT29rSlZVNjhiS0t5ODlhbnhiVE5jQ0hsY3N5VWFDb0Y5dmwv?=
 =?utf-8?B?T1VwVUJyQVdUYnM4SS9ha1Q0dkFXSWRTR000TzRqZFZ5ME12cVRUM2tmbWc5?=
 =?utf-8?B?dHhFemxLRlVUQXFRYjZUM3BtaGQxVUI2SDVKeStNbUtIQ1FXSDRRN08xUmV1?=
 =?utf-8?B?eDBnNzBJaXM2ZXVtRW5zNmVIU0J5MWNvRVA3UitWc0tjS3U2d3pNbHNFYUlt?=
 =?utf-8?B?cyt2MTBKU09MdzJtOS9uL2xOVy9DOGtDZ0wyVkRtOFdMcXZHODdpdHBYWjRG?=
 =?utf-8?B?OTc3cHErYzdQUldBOGt6aU1pcnpsQkhlSEQ0R2E1VDU2YWVTOWdqZTM5c2lQ?=
 =?utf-8?Q?s61pB44QY36XCFNsct?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0cb2a3c-b74d-4dc6-3f77-08df044c549f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 15:03:19.5241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j+v2TUiDGobIPeKtLPOMnkr3cqYzwgJ4yanleCCKh9xU0Q6WXm/qC3VKz2pOfG9H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7107
X-Rspam-User: 
X-Stat-Signature: ktus6tgdyfh68x5b59hjxs9h71ypgfo6
X-Rspamd-Queue-Id: A0C0080016
X-Rspamd-Server: rspam06
X-HE-Tag: 1787843004-896783
X-HE-Meta: U2FsdGVkX18T+vjPrCqCFU1YC5OrcCSZz9bagIn+vqam00PBe8F/RdkHuGqYGX2bcmwEM/SNBKFtfbd57cEic+DP4rQ88T2pnJBQ2EzGi0lgEnTKrEVspPOl0N7KUqjSOdJCX7mAQnNPCLED6U/U5gbkNSwaQcpmByZ2/NxcttbwduyOTnYXtWXcmNc1anf04mNVOtZLPCIj0paUrltzqhWGeGSWK2QJKPqOryIAEW6Uau4cMeh+KOPnCex4OTcVmkeSkL3XI9wJ2Ln/6OaUlsDTErGlfjtqCxI7Ht6GnlWTVTlKzIsflGzQf2JnZhvlmNKTUIatn8Rr5A/URcbWodH0c/RYsbmVI0H4fxKCqcSpeXbw/xQOMSjhvtLJ9mkbofIHOU1pDHNjqhCSs1d0u6l8NVJcuHrTz97ChTKyysMi6k9b7nhazMHBZ0+abmJkJVQd480/VeyTXhyyQBynmirNuZhh7aZ+fmXc/lFYb5HpAnY/1QaWSpOju3TawNGE1jul5xAvQF8lmT61/MmZbQJ7EStRB/8b1WOg9YeBVe9+ewHl5155a5zeWqCVJjY4PbJeCOwWdSX3QReD3p4W19pyTmhsq5K9NU5JhQ8tRan10ZcVji5IK8oGOariwb198tmHceUg4PDgH1/6tRdFeMtvo/jx3DL76Lp3xomlj0LGM1a323mdL4PWYzfEXge/M4rYnyMstEv8LYMBwSq3x6I4MN73EFHXBerMh1336Lv9ugFbCDUDWiD+WYLT968sMevgvZpT9SdiTR69Hsf3zeoY6Uesd3ZhMFkQA8FVKTOAUOX00esslj6/R6oJKLv+Jsgx8XBzvDpuQK/OdTokF0eENjC2UL6DXOGBvPWa1y7U1V7HYF23ExpyG44n72Pxwj6UjTkCJeknxmVO5B9hW6vclg4zT/UIsPJXoBcDUEIIbDu8KUhdmgv7wvVhXM3gdW03ApBDkI0MHxapzLO
 /tg/pA1d
 Sa8l/aA4dt3rjwsr2fBPRbEDiIoEgYqVjXx9G98sT5TeCJaLFf+FTKagVLX5tueD5j15g7vgDg7z2MO0fkkNIY+6DovsGmJB8U6UoSPIfRD0lornUXAHH0F78JaL00YEpSDwa6J0ZFdz2+Vufl7tRuxa7hNe9g0QmmGM3wacqCyPkPNU0T0csGmlbuZNYQKJtOcgVikwdI5Orgq922QApiYyg4nKqmSVrkoSmi/diuWdVkhEf5jTFTRCHO3qKhKayDiaUDH5zEZhfj6odo/VLs1PKlODtK3V51iTfRcYXwHpBLPRMwMi0pOpTwGn40yyi84Mte02lo2DclZo1lD6XxUugkwF3rNiXGtb2tGS8tV7/WccMhTg0XQL5or9D2giQCWu8rvb3qA3h28NgvCVw8VyrZtuUWWd7ZjJozs7aRBalXB7AcT4fx/Sdgu6t42ZloTlBNWjKBAqlV27BU2irM97B/3OsrAkVdv50lckOvrCuVCENu8WBtZf4t/Dj2LJQxhkS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 27, 2026 at 6:44 AM EDT, Yeoreum Yun wrote:
> Hi Baolin,
>
>>=20
>>=20
>> On 8/26/26 8:24 PM, Yeoreum Yun wrote:
>> > Since glibc commit 321e1fc73f (=E2=80=9Cmalloc: Enable 2MB THP by defa=
ult on AArch64=E2=80=9D),
>> > glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocatio=
ns
>> > made by memalign().
>> >=20
>> > The underlying VMA may start at a different address from the aligned
>> > address returned by memalign(). Furthermore, a subsequent
>> > madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
>> > already set.
>> >=20
>> > This causes split_huge_page_test to fail because the check_huge_xxx()
>> > helpers incorrectly require the address returned by memalign() to
>> > match the VMA start address reported in /proc/self/smaps.
>> >=20
>> > Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
>> > /proc/self/smaps to detect huge pages.
>> >=20
>> > Reported-by: David Hildenbrand (Arm) <david@kernel.org>
>> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>> > ---
>> >   tools/testing/selftests/mm/vm_util.c | 130 ++++++++++++++++++++-----=
----------
>> >   tools/testing/selftests/mm/vm_util.h |   1 +
>> >   2 files changed, 77 insertions(+), 54 deletions(-)
>> >=20
>> > diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/self=
tests/mm/vm_util.c
>> > index 4821a3563036..1d0959b3b9e8 100644
>> > --- a/tools/testing/selftests/mm/vm_util.c
>> > +++ b/tools/testing/selftests/mm/vm_util.c
>> > @@ -351,31 +351,13 @@ char *__get_smap_entry(void *addr, const char *p=
attern, char *buf, size_t len)
>> >   	return entry;
>> >   }
>> > -static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages=
,
>> > -		  uint64_t hpage_size)
>> > -{
>> > -	char buffer[MAX_LINE_LENGTH];
>> > -	uint64_t thp =3D -1;
>> > -	char *entry;
>> > -
>> > -	entry =3D __get_smap_entry(addr, pattern, buffer, sizeof(buffer));
>> > -	if (!entry)
>> > -		goto err_out;
>> > -
>> > -	if (sscanf(entry, "%9" SCNu64 " kB", &thp) !=3D 1)
>> > -		ksft_exit_fail_msg("Reading smap error\n");
>> > -
>> > -err_out:
>> > -	return thp =3D=3D (nr_hpages * (hpage_size >> 10));
>> > -}
>> > -
>> > -static bool check_large_folios(void *addr, size_t len, int nr_hpages,
>> > -		uint64_t hpage_size)
>> > +static bool check_large_folios(int pagemap_fd, int kpageflags_fd,
>> > +			       void *addr, size_t len, int nr_hpages,
>> > +			       uint64_t hpage_size)
>> >   {
>> >   	int order =3D 0, pagesize =3D getpagesize();
>> >   	unsigned int nr_pages =3D hpage_size / pagesize;
>> >   	int orders[MAX_NR_ORDERS], status;
>> > -	int pagemap_fd, kpageflags_fd;
>> >   	bool ret =3D false;
>> >   	if (!nr_pages)
>> > @@ -386,15 +368,6 @@ static bool check_large_folios(void *addr, size_t=
 len, int nr_hpages,
>> >   		ksft_exit_fail_msg("invalid order\n");
>> >   	memset(orders, 0, sizeof(int) * MAX_NR_ORDERS);
>> > -	pagemap_fd =3D open(PAGEMAP_PATH, O_RDONLY);
>> > -	if (pagemap_fd =3D=3D -1)
>> > -		ksft_exit_fail_msg("read pagemap fail\n");
>> > -
>> > -	kpageflags_fd =3D open(KPAGEFLAGS_PATH, O_RDONLY);
>> > -	if (kpageflags_fd =3D=3D -1) {
>> > -		close(pagemap_fd);
>> > -		ksft_exit_fail_msg("read kpageflags fail\n");
>> > -	}
>> >   	status =3D gather_folio_orders(addr, len, pagemap_fd,
>> >   			kpageflags_fd, orders, MAX_NR_ORDERS);
>> > @@ -405,48 +378,97 @@ static bool check_large_folios(void *addr, size_=
t len, int nr_hpages,
>> >   		ret =3D true;
>> >   out:
>> > -	close(pagemap_fd);
>> > -	close(kpageflags_fd);
>> >   	return ret;
>> >   }
>> > -bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t =
hpage_size)
>> > +enum check_huge_type {
>> > +	CHECK_HUGE_ANON,
>> > +	CHECK_HUGE_FILE,
>> > +	CHECK_HUGE_SHMEM,
>> > +};
>> > +
>> > +static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
>> > +			     uint64_t hpage_size, enum check_huge_type type)
>>=20
>> The original __check_pmd_huge() is only for PMD-sized large folios, but =
now
>> it not only checks PMD-sized large folios but also mTHP large folios, wh=
ich
>> I find confusing. Please keep its original semantics, and only check
>> PMD-sized large folios.
>
> But, It seems to valuable to check other page-flags than checking
> the large-folio only.
>
>>=20
>> >   {
>> > -	uint64_t pmd_pagesize =3D read_pmd_pagesize();
>> > +	int pagemap_fd, kpageflags_fd;
>> > +	uint64_t pmd_pagesize, granule;
>> > +	uint64_t categories, kpf;
>> > +	unsigned long pfn;
>> > +	bool check_large, huge_mapped;
>> > +	char *start =3D addr;
>> > +	char *end =3D start + len;
>> > +	pmd_pagesize =3D read_pmd_pagesize();
>> >   	if (!pmd_pagesize)
>> >   		ksft_exit_fail_msg("reading PMD pagesize failed\n");
>> > -	if (hpage_size =3D=3D pmd_pagesize)
>> > -		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_s=
ize);
>> > +	if (nr_hpages > 0) {
>> > +		check_large =3D true;
>> > +		granule =3D hpage_size;
>> > +	} else {
>> > +		check_large =3D false;
>> > +		granule =3D psize();
>> > +	}
>>=20
>> This is incorrect for the mTHP large folio check. I already hit a selfte=
st
>> failure. Please test your patches before sending them out.
>
> Since for a split case, large folio can be as-is but only remove
> the PMD mapping only, skipping the large_folio checking seems valid
> when nr_hpage is 0.

What split care are you referring to? split_huge_page_test() always
splits the folio.

>
> And the failure of test seems because of unmapped area after
> changinng the collapse-order. Therefore, it seems to fine with below
> patch:
>
> ---------------&<----------------------
>
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftes=
ts/mm/vm_util.c
> index 1d0959b3b9e8..f174a76d2310 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -387,14 +387,14 @@ enum check_huge_type {
>         CHECK_HUGE_SHMEM,
>  };
>
> -static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
> -                            uint64_t hpage_size, enum check_huge_type ty=
pe)
> +static bool __check_huge(void *addr, size_t len, int nr_hpages,
> +                        uint64_t hpage_size, enum check_huge_type type)
>  {
>         int pagemap_fd, kpageflags_fd;
>         uint64_t pmd_pagesize, granule;
>         uint64_t categories, kpf;
>         unsigned long pfn;
> -       bool check_large, huge_mapped;
> +       bool check_large, check_huge_mapped, allow_nomap;
>         char *start =3D addr;
>         char *end =3D start + len;
>
> @@ -405,11 +405,20 @@ static bool __check_pmd_huge(void *addr, size_t len=
, int nr_hpages,
>         if (nr_hpages > 0) {
>                 check_large =3D true;
>                 granule =3D hpage_size;
> +               if (granule =3D=3D pmd_pagesize)
> +                       check_huge_mapped =3D true;
> +               else
> +                       check_huge_mapped =3D false;
>         } else {
>                 check_large =3D false;
>                 granule =3D psize();
>         }

The else is for nr_hpages =3D=3D 0? But it looks like we allow negative
nr_hpages. Maybe add a bool expect_huge =3D nr_hpages > 0 to make it
explicit.

granule is an optimization for PAGE_IS_HUGE scanning? When we expect a
PMD mapping, we just scan at pmd_pagesize granularity, otherwise we
check every single page?

At the high level, the function looks good to me, the rules are:

1. if hpage_size =3D=3D pmd_pagesize, we need to check PAGE_IS_HUGE and
check_large_folio() can be skipped, since we only care about mappings.
This checks for PMD mappings.

2. in other cases, check_large_folios() is always needed. This is for
mTHP checks.


I think the ifs at the beginning is confusing. Can we do something like
below to get rid of the ifs? I also moved KPF_* checks in a separate
function. Feel free to make changes if you find any issue there.

Thanks.



static bool check_huge_type(uint64_t categories, uint64_t kpageflags,
			    enum check_huge_type type)
{
	bool file =3D categories & PAGE_IS_FILE;
	bool swapbacked =3D kpageflags & KPF_SWAPBACKED;

	switch (type) {
	case CHECK_HUGE_ANON:
		return !file;
	case CHECK_HUGE_FILE:
		return file && !swapbacked;
	case CHECK_HUGE_SHMEM:
		return file && swapbacked;
	}

	return false;
}

static bool __check_huge(void *addr, size_t len, int nr_hpages,
			 uint64_t hpage_size, enum check_huge_type type)
{
	int pagemap_fd, kpageflags_fd;
	int nr_pmd_mappings =3D 0;
	uint64_t pmd_pagesize, scan_mapping_size;
	uint64_t categories, kpf;
	unsigned long pfn;
	bool check_pmd_mapping;
	bool allow_nonpresent;
	bool ret =3D false;
	char *start =3D addr;
	char *end =3D start + len;

	pmd_pagesize =3D read_pmd_pagesize();
	if (!pmd_pagesize)
		ksft_exit_fail_msg("reading PMD pagesize failed\n");

	check_pmd_mapping =3D hpage_size =3D=3D pmd_pagesize;
	scan_mapping_size =3D nr_hpages > 0 ? hpage_size : psize();
	/* Some mTHP tests check a partially populated PMD-sized range. */
	allow_nonpresent =3D (uint64_t)nr_hpages * hpage_size < len;

	pagemap_fd =3D open(PAGEMAP_PATH, O_RDONLY);
	if (pagemap_fd < 0)
		ksft_exit_fail_msg("open pagemap fail\n");

	kpageflags_fd =3D open(KPAGEFLAGS_PATH, O_RDONLY);
	if (kpageflags_fd < 0) {
		close(pagemap_fd);
		ksft_exit_fail_msg("open kpageflags fail\n");
	}

	/* PTE-mapped large folios cannot be identified by PAGE_IS_HUGE. */
	if (!check_pmd_mapping &&
	    !check_large_folios(pagemap_fd, kpageflags_fd, addr, len,
				 nr_hpages, hpage_size))
		goto out;

	for (; start < end; start +=3D scan_mapping_size) {
		categories =3D pagemap_scan_get_categories(pagemap_fd, start);
		pfn =3D pagemap_get_pfn(pagemap_fd, start);
		if (pfn =3D=3D -1UL) {
			if (!allow_nonpresent)
				goto out;
			continue;
		}
		if (pageflags_get(pfn, kpageflags_fd, &kpf))
			ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
		if (check_pmd_mapping && (categories & PAGE_IS_HUGE))
			nr_pmd_mappings++;
		if (kpf & KPF_COMPOUND_TAIL)
			continue;
		if (!check_huge_type(categories, kpf, type))
			goto out;
	}
	if (check_pmd_mapping && nr_pmd_mappings !=3D nr_hpages)
		goto out;
	ret =3D true;

out:
	close(pagemap_fd);
	close(kpageflags_fd);
	return ret;
}

>
> +       if (nr_hpages * hpage_size < len)
> +               allow_nomap =3D true;
> +       else
> +               allow_nomap =3D false;
> +
>         pagemap_fd =3D open(PAGEMAP_PATH, O_RDONLY);
>         if (pagemap_fd < 0)
>                 ksft_exit_fail_msg("open pagemap fail\n");
> @@ -428,18 +437,15 @@ static bool __check_pmd_huge(void *addr, size_t len=
, int nr_hpages,
>                 categories =3D pagemap_scan_get_categories(pagemap_fd, st=
art);
>                 pfn =3D pagemap_get_pfn(pagemap_fd, start);
>                 if (pfn =3D=3D -1UL) {
> -                       if (check_large)
> +                       if (!allow_nomap)
>                                 goto out;
>                         else
>                                 continue;
>                 }
>                 if (pageflags_get(pfn, kpageflags_fd, &kpf))
>                         ksft_exit_fail_msg("read kpageflags: %s\n", strer=
ror(errno));
> -               huge_mapped =3D categories & PAGE_IS_HUGE;
> -               if (check_large !=3D huge_mapped) {
> -                       if (!check_large || granule =3D=3D pmd_pagesize)
> +               if (check_huge_mapped !=3D !!(categories & PAGE_IS_HUGE))
>                                 goto out;
> -               }
>                 if (kpf & KPF_COMPOUND_TAIL)
>                         continue;
>                 if (!!(categories & PAGE_IS_FILE) !=3D (type !=3D CHECK_H=
UGE_ANON))





> @@ -458,17 +464,17 @@ static bool __check_pmd_huge(void *addr, size_t len=
, int nr_hpages,
>
>  bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpa=
ge_size)
>  {
> -       return __check_pmd_huge(addr, len, nr_hpages, hpage_size, CHECK_H=
UGE_ANON);
> +       return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_=
ANON);
>  }
>
>  bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpa=
ge_size)
>  {
> -       return __check_pmd_huge(addr, len, nr_hpages, hpage_size, CHECK_H=
UGE_FILE);
> +       return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_=
FILE);
>  }
>
>  bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hp=
age_size)
>  {
> -       return __check_pmd_huge(addr, len, nr_hpages, hpage_size, CHECK_H=
UGE_SHMEM);
> +       return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_=
SHMEM);
>  }
>
>
> If it's good for you, I'll repost again.
>
> Thanks!




--=20
Best Regards,
Yan, Zi


