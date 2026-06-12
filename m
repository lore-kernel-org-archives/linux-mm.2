Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C6CCD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 14:57:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7569A6B0092; Fri, 12 Jun 2026 10:57:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707A46B0093; Fri, 12 Jun 2026 10:57:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CFBC6B0095; Fri, 12 Jun 2026 10:57:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 48EAC6B0092
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:57:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EBF09120162
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:57:54 +0000 (UTC)
X-FDA: 84871565268.20.BA7202C
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012025.outbound.protection.outlook.com [40.93.195.25])
	by imf31.hostedemail.com (Postfix) with ESMTP id 09C2F2000F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:57:51 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EKwkf+7m;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781276272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fzQlOfsXZ1vvrZVna77VtCq5i24QaZPmvUzVJFO7Ttg=;
	b=WSFczL7eobrXDMjo/sw+MRNTsgpmY+AbY/+Vas027WFWwJwKkHPPJIR8kldOoAyckxBOzr
	u8Z/fbr6+PaCcQWKIaJXphDcVo0GyfQdMKgG4fFvJ68wELmbgOGhYZgOWA0//8r9VkyuFm
	yMlre5ej0X5faKj/Qt2/hUQxxv0XzKM=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EKwkf+7m;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781276272;
	b=JIzpNfLjFgKvLSO8iQgqawf6ntZ89onXHFBp29WKvYow2v9HYAM8dsrB5BT4RZ1b3wE0sz
	AsQAHYP3l2sC9uklF8lHrKrUelyG2cn8PMFzhfmDFHry/10D3LQi0twrgHR5bREqECi41u
	FA1ebRHPG14PUtpCa52NTpGm4vo64Ns=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C42+YFTg1AaCaN2qO66/ctPmFnmBLuKvULVF4rQlXi1C2y7q8FR1K4M1lxvTBrPGO8IbI/GOl7CwFmb1dvabVX7k3U2wXGW5oMQIh3XsBKBAshaTh4gMSz7bVnSBE2SalVrPbkJh6mZLlvJuul1pmT+bMfvc/f1kHRwnOg+65bSSmdPtGz5UFpQpQhv3LQ3FuRu7eD8IE0fAyRyuWJIAAQW6T2Ky5u5yPgxi0tjOYQUZh5F38D/DpCEMZpu1g7lOQk9W/zVWbnVQ36nEUx2swvgACa6YCVpruJQyw/maHfJCakydHcWw0/5dfIpxDRPKDaqS06Snr6k8RiC+OjKVuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fzQlOfsXZ1vvrZVna77VtCq5i24QaZPmvUzVJFO7Ttg=;
 b=mlp20Zw7vOKEv737j9zT4hyMCNVcD6OzJDMU8oHevhHsOg9+yUuvtqn3i2wqteTiApPB/iGRPmCghqR2yyBLnNJS3s70EGRRHYGiqAdHjroxELe/ip+esPm18/5q4d+cnrwCe9a16oP2DgDmpIybSpFTMzC6IOXphwm5ZpzLCM5RbnSC6qCKHtlW8uyfiLOZsc7sWYby6OxHYyQYAakrO/JK5qfVwL3i/Oqx3kgNh7mBQWgy0BiScuhBBtiEX99dAonjQqPrKzOE+ZG7x100TBVPDjtzYP1MZurbALzzrNRvjDDWxdyJKVZqbRTedl52nLAMvPTOheUhsx2WjrHXJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fzQlOfsXZ1vvrZVna77VtCq5i24QaZPmvUzVJFO7Ttg=;
 b=EKwkf+7mpgi3WDrEKtb8H6xC8gGOb2r1nmUTxCTjNVU/yu1tsm1Qf47ilkFNfNgSTcwv7ScBFHCrS06RYYnqXoVpZlcKTzsPA7ftpthgWuhY/Om8yNq+JY3709gbEFP/w2nSRD4qB5PJMjRbRAwLobo0ok18SEt9+7i4rz+Z9z2RDkl/w+0UiDsNv6urM3OMC3XVp/ZFqpyL5Re/wPiooOXzK/UODlHrOEHH+lJjZpzE4N/7cCfvxjvWuSRsurBf/Sl6sazluW6yIAeVtxbgB/1WPvFsIMeQLD2OVx61d2x1qwtm/7zwN58+OPgciFu0UROiSHz6ba5bYFOndFlm3g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB9275.namprd12.prod.outlook.com (2603:10b6:8:1be::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.18; Fri, 12 Jun 2026 14:57:44 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 14:57:44 +0000
From: Zi Yan <ziy@nvidia.com>
To: Petr Tesarik <ptesarik@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm: reduce NODE_RECLAIM_xxx and change to enum
Date: Fri, 12 Jun 2026 10:57:41 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <951C4000-50D7-40DB-A3CB-7E6FF1AA575B@nvidia.com>
In-Reply-To: <20260612085052.59291-1-ptesarik@suse.com>
References: <20260612085052.59291-1-ptesarik@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0PR02CA0005.namprd02.prod.outlook.com
 (2603:10b6:208:530::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB9275:EE_
X-MS-Office365-Filtering-Correlation-Id: ce6d5fa9-082d-4c21-f579-08dec892f527
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	Vdb/GltoffbX0RCVCsO9MU5uEWS3Ypvo3qSkAxcrwVSbjLxtmni9RhVRH9U18Umw4JN4GE9iK1TsMFQTCF6fxLvr/zYye2AEVvt2EeZuiEJtVPZadBaS1nHLz7T0noLk4tjCBQtlEbFjUpK7vlKIHHiYq5DUhLo6bciu9Qn/FY6whVK1KTwK/0s98FKX2pkJ8sDJ48RSAkfiK5MvGSc9IqmY1agVKzuEkX6P2kdWokQ3XMkGA+oJkNFxMEuiG0gyPfrOH/amUPS9ZjvIKbHYOn1el0/C+Tk5FDyI07Mlfhmdzb9jq/OrvkeSu0TtIFSShPzPbCfX94u321HJ4M8ocDBJXD6nmf5Hck7DTcmUXG+MIIoTLqIR4axJSJOqCry9YiZ36GTMW0HnfX0qP/RJxhC0mBu9CvbL7WiLRhQg4Io9ga7jmuvj2sCWD5SiLjI5du4TO7ILobNaf/Uc8bFsxSoNAaXALLlvqKnD1cQPpgyFcfHlE3MkaKsqdsaDHTmCvN9wOG54sRrKhHnceG1yiwEpMUa3w4RsZ5mm5qdXolyvJ700Rkrfl+N0tBKpEgQX32E3fpZ8M6GtBenVCrOxtNFpkHYhr1b64sr4e6iYYtds3mSjO3eB5OvGHDJhIzVfRvHUDXrZOFS66TndgaclRkjYNLybouhlDmqbEWx3b65qujHMC81Pf2wP1+aRNu+B
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZnZTbzE4U3pKOUtHakRlQkhmWDhZTlZKL2s5eHRrU0QwTTk3UmNYMUsxSHJO?=
 =?utf-8?B?QzB2Q0U2Ump3Z3FsT1RoRlJ1U3BIVXhoQ1grQ3JsdGtQcmtZMm96MEUycFFB?=
 =?utf-8?B?b2VZMi9tbk94VytkT0xtUTR4U1RWcXNJYnZ4L3hoaEZFa3FISEZobm5yVUpF?=
 =?utf-8?B?NmI2YnZodzdGOTNPeUZZL3hGbFFvcTF6UHp4eXJob1R6MUlLZ1V0ZGozbksx?=
 =?utf-8?B?d1R3bGdXbklpeGg3TGtodkZ4SENyMzRVTTVYbVlHS2hlV1dLc0s4MDlsNVgw?=
 =?utf-8?B?bkJvWWxWMU9Tc3FxSmV1eXdFTm1IQ2RDeko1TzYrUnR0NGsrakRqd2dIc3R3?=
 =?utf-8?B?SGVidFdYdEtmUWtjWlNYckJLOVQzWDZMUkpKV0NodG1XWklmQ0s2Wmc5Qjdx?=
 =?utf-8?B?ZHF5cmNYazNhMGZVVmQvK1N0ZGNhQ0tPZE9kMXhOZGZNOVlDSXhwdzQ3cnMv?=
 =?utf-8?B?WmxzVjFabk93Zk9hK2hpOXdvRHd5cjgxTHVSdkVVM2MrMzAvaTF2cHVkWVZa?=
 =?utf-8?B?RWp5VFlhMm80d29YeUNQLzcyWFNRNkhKN0xEcFFlRzltczNzZEJnRFFSallp?=
 =?utf-8?B?TG9LMG5UT1Z4RTAvUWMzTUlYQTRjUTVvdkNZSjlTb1ZIVUhqeGpqTGpCZitt?=
 =?utf-8?B?VEUzUFRGWEVFZ0trd3NOMVJ2a0RPelRScU5UcTdzeDFkSWdBaCthTGpteWJt?=
 =?utf-8?B?Vll2S255V2NhL0RPWGs5TFNyRVZ1SjNLbTFJV0NYaGhWdGJxRHJNOWREc2cr?=
 =?utf-8?B?QkJ1VXNxRFBJTVZ3bWRKNTVFQkVUSDY3RDlkVW02cHlVYmlJVWZ5YlJ1RmFm?=
 =?utf-8?B?SFFsSGZnczhEMlp6YTNJbVdBSmYxamdsUHN1amw0cGtwMCtIOHV0dkRFTnhR?=
 =?utf-8?B?ODRMR2xSMWw0YUJxaVVxL3Yrb1R2bUZRclVKVzZ4amlEYUpqdTRJNS9yanI1?=
 =?utf-8?B?WW0rdGR6SHA1K3Zwd3h6WGJnU0loN2lKZytuSEF4UzdOb0pCeG9ZWGtOQ2Fq?=
 =?utf-8?B?djN5WllRRCttNnk2aVpnUFc2dG0wZ0wzYTRFT0FMOE56aEVXWkhrYjlPUmY3?=
 =?utf-8?B?c1lMMEd4dWJwbC9WWmNibnBvS1VITGpUd0JFZ2JzcmpNTDdHNUh3Vkx5RHRy?=
 =?utf-8?B?d2lWam4yMVZOT3E2MW1nS1lkdFZEWWtaSDl5WmZOSWJnd3JlS3F1MHNNbHd2?=
 =?utf-8?B?VFpKeFI3Tlp1bURmM3BuekY1WmJOSXdCNU8wYWJaOFFNYUdIZlpDQ3AxbmVQ?=
 =?utf-8?B?YTM0bEY5Ky84U25TcmRhN09zWTVpSk82SHBldXExWkxJZ2ZDVnV3RjI0Mytw?=
 =?utf-8?B?dmt4QlpJb2kzSzRNeVJWaFJVUm1NNytMbkV0N2lBcWl3ZHR4aXRjSjVFYXgr?=
 =?utf-8?B?NklWWER1N1FNQXhGR2xiOHd2a1lDYlJ6enhBQ3p0YzVyTVJIOHFwSmFvUEdG?=
 =?utf-8?B?S3kxbTBHSnRrYjF0MmdOb25KQS8xZXc4K2xTU1BRa2g2azRvTHZoWldNcFJP?=
 =?utf-8?B?TFE4V2ZQcjdhWWR1SVF0Z05NV1htQUdmUmltRjQxK2piVTFTT0lBTjdFdmVP?=
 =?utf-8?B?K3pQQ3djQmFOSm8zZllOZ2Z4UG11MDBVSzFJOFVTNk9MSTdFd0E5bXdQNEUw?=
 =?utf-8?B?aExDNE14dU9DWDYvOUpxVkR6dVZYYzZORXVHb1o4a2h4NnJOanhPTnJvYTd4?=
 =?utf-8?B?eVNKSUE0YzdzYzhvdytuT1p0dGxickJxUDRZS0dCWkRXdUJwSUZ6elNMVE9M?=
 =?utf-8?B?ZFJEKzQvWkpmTFoyZ2NjMWptL1ArOFM5aE8xaVBNTlM2Tk9rVk15andkRDFT?=
 =?utf-8?B?NEdTSWRwL1ZaQXY5ZnpUTzJtYm1XUkVqa3ZoY2IrZHgvYzhZUE5pMG9udXFX?=
 =?utf-8?B?cEhVajBrSEgwQ1lEYUFjd0JjcElqdVNkTDB0VUtubUNEdFZjUHJJM3duRzQ5?=
 =?utf-8?B?MEpBV0NWNVpCTk5IK2tSRTlpcFhEQlhHdVYrbVNMRWE5LzlkdHptUlNSNllI?=
 =?utf-8?B?aUpldzBJSEdCdWQwUXdEUEVqUUtlUjRvaTNpTmxYNit3SGFrby85aExpQkUw?=
 =?utf-8?B?eU9WYVNqMFpRaGNJV293OStWN0ZGam53UTQzZUdvbE9oQ0F3cXhDRFQ0RFF5?=
 =?utf-8?B?TUh4NU85eUlTVDRSeTRrVmVIeFE1dmtpSXlFakJ0K0d6NG5hc2pZRjBzNXZX?=
 =?utf-8?B?VlNCR1NwSGtTbGVoUHJGVUFvUjMrS2xJNUdEalJQUnM3eVBrZG0wd1dMQ0c1?=
 =?utf-8?B?ZUprNENoK3duZXF6ZkRJZjZmTDZOTlFCc3NoODlzSUQ4RE04TExaKzVzSEg5?=
 =?utf-8?Q?mjQMTi6fVydkfRSitn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce6d5fa9-082d-4c21-f579-08dec892f527
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 14:57:43.9280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M5z1T2nLL+83zVugfDV6WCmklzmToIKbLw6eRkZF1JxpnmwFjNc3UTFjTCKfJjtt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9275
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 09C2F2000F
X-Stat-Signature: m849c9z8cwudusmdskxmmamuyzn6bjh4
X-Rspam-User: 
X-HE-Tag: 1781276271-629847
X-HE-Meta: U2FsdGVkX1/2oNQEBvH8ZPatGF+Q0XhF1vvM1RQYwvfyMXbs8VhxiK71PjewVg+SSYpqvRKStRjNZ8yEV9GeNHW4BTiAH74M55AXSE69wLJW2ZGe01mcaqFKoShuUYqo9T5Y/ymOj4NBXmPkamC9UUc4w1QuyfQXczd9avkGK113nu2oyZNkJVpmr7hyCzuyLWXqj4CQET04cKT/Fhm9czEHzUj+W7xT8PQ/mDI4Umnz6Dsk8JSIElZi/rhvwq5vAkeGG6XZrYFBkhaq/9e3udGxX20Ck8WphFHWV24D2zuZGWGgSe/EEKGnBHMJlj1ZKGIXx24vimts1YHnZYezxG4PBzSNzVsN5J53L3T40+evi8iI4JUrPs9F2nrbT7wklDLc7uHx3FfL7uoi/GCKr6ciBawigTfIInPHt48O1irW4EUjjd6RY1SLbZCoKtW5957oZxGyskuaQs9IlcENsK2481DLaatFYZnPI+4GwMpd9V94JzgKboArYXKdfuabfeEBNfzhghCtWgYjP4LeoyWlzPdqaRKliXT3zqQSkLmVynL8h72Y921kkmpEwNkgd0a/dxfpX2mnzANQV+zUhMzMKh5CejzZM14TwJq1RDDmYhKiHJBKxL2M83ZClaEDdZ6Brny7TxE5d6kh1CP+n63wsVFr+42M4KyloeXDsCrZ7yTs4WREoXMjphzdbL4V1gxHSEwyOtPTBMIxjdsyOmpSJTPbeIRRuITSIqugn8wpGLFE4qlP9THiVv+0PZoiJKV82HFGNz7dXa8ONYOX+cmKgiaBa8We0UmJaBB6f2Dja4StSmh0ZhSb+Ar3YD/KrJf9JSbb7fHzPgenRjiwyy8K4FEpHNiXTdDYDlOpgdhZ79oe8D8kz+Cph72vZv9RoeJx6UZTURHI74Qv7F0O4I/9+A6rtibs1VSD15Cp8ZAYSQ/dnbS4HNtlAtkQbm44CvIEk60qXkyVtf0ADyc
 OBoXa0U0
 Ami/SGrz0gXe804sR5MCP927GM2inoXTFrHrGiybmPkBB4fPnkHdfxagYz3vIZ7FBh1g52ZfVXRKfxMWV9dH0C/qomKKXvIMBHS1OLfVPCie7as4ZM+HBsWbnSTdr+jqV1ty42bRGx5F35lNx57iJI0xNCEmNlmz4Rl99QJKVeDzodpFF44lB5rxFjCzShNHKcqPcExYIQ4N3g07snTZMkfFk0uWSesstgjIkuccwCOC8TKlSugONcQ14Ug3KqXDXEa+WIr7RUMhN4+R8fOCmHt0e893X3i/8QrjAiAaUCBEkXbmSjrE0Hy0PuR6e8bXv3siXwe3sYlK3KdeMazAWY/nXmyXfN/Zhm3FKCEnK/Ri2i3z9Sion9FLntJvhSqnQAJhpB+Squrehc+R7M6lco21kNKrkqifvuA2k8XeT2z5t2cRED0W009DF0upl3gF+lIRCzK8Ol6iv9Ikjy4ZT/2CVekaNjwnghQGCGTt3scqYo10aG1QML3igWgUkQDDvfDAc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12 Jun 2026, at 4:50, Petr Tesarik wrote:

> Change node_reclaim() to return an enum indicating whether any
> pages have been reclaimed, because that's all the information
> needed by the only caller, get_page_from_freelist().
>
> This leads to the following translation of the old macro
> identifiers to the new enum values:
>
> - NODE_RECLAIM_NOSCAN  -> NODE_RECLAIM_NONE
> - NODE_RECLAIM_FULL    -> NODE_RECLAIM_NONE
> - NODE_RECLAIM_SOME    -> NODE_RECLAIM_SUCCESS
> - NODE_RECLAIM_SUCCESS -> NODE_RECLAIM_SUCCESS
>
> Originally, I was looking for occurences of NODE_RECLAIM_SOME
> and NODE_RECLAIM_SUCCESS, but I couldn't find any. That's because
> they are typecast from the result of a relational operator. This
> seemed a bit fragile, so I dug a bit deeper and came up with this
> proposed cleanup.
>
> Signed-off-by: Petr Tesarik <ptesarik@suse.com>
>
> --
>
> Changes from v1:
> - use an enum instead of a bool
> ---
>  mm/internal.h   | 17 +++++++++--------
>  mm/page_alloc.c | 19 ++++---------------
>  mm/vmscan.c     | 18 +++++++++---------
>  3 files changed, 22 insertions(+), 32 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 181e79f1d6a20..89b0ea28051c1 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1373,23 +1373,24 @@ static inline void mminit_verify_zonelist(void)
>  }
>  #endif /* CONFIG_DEBUG_MEMORY_INIT */
>
> -#define NODE_RECLAIM_NOSCAN	-2
> -#define NODE_RECLAIM_FULL	-1
> -#define NODE_RECLAIM_SOME	0
> -#define NODE_RECLAIM_SUCCESS	1
> +enum node_reclaim {
> +	NODE_RECLAIM_NONE,
> +	NODE_RECLAIM_SUCCESS,
> +};
>
>  #ifdef CONFIG_NUMA
>  extern int node_reclaim_mode;
>
> -extern int node_reclaim(struct pglist_data *, gfp_t, unsigned int);
> +extern enum node_reclaim node_reclaim(struct pglist_data *pgdat,
> +				      gfp_t gfp_mask, unsigned int order);
>  extern int find_next_best_node(int node, nodemask_t *used_node_mask);
>  #else
>  #define node_reclaim_mode 0
>
> -static inline int node_reclaim(struct pglist_data *pgdat, gfp_t mask,
> -				unsigned int order)
> +static inline enum node_reclaim node_reclaim(struct pglist_data *pgdat,
> +					     gfp_t mask, unsigned int order)
>  {
> -	return NODE_RECLAIM_NOSCAN;
> +	return NODE_RECLAIM_NONE;
>  }
>  static inline int find_next_best_node(int node, nodemask_t *used_node_ma=
sk)
>  {
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index f7db8f049bd23..83a1caac5ac9c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3899,8 +3899,6 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int=
 order, int alloc_flags,
>  		if (!zone_watermark_fast(zone, order, mark,
>  				       ac->highest_zoneidx, alloc_flags,
>  				       gfp_mask)) {
> -			int ret;
> -
>  			if (cond_accept_memory(zone, order, alloc_flags))
>  				goto try_this_zone;
>
> @@ -3921,22 +3919,13 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned i=
nt order, int alloc_flags,
>  			    !zone_allows_reclaim(zonelist_zone(ac->preferred_zoneref), zone))
>  				continue;
>
> -			ret =3D node_reclaim(zone->zone_pgdat, gfp_mask, order);
> -			switch (ret) {
> -			case NODE_RECLAIM_NOSCAN:
> -				/* did not scan */
> -				continue;
> -			case NODE_RECLAIM_FULL:
> -				/* scanned but unreclaimable */
> +			if (node_reclaim(zone->zone_pgdat, gfp_mask, order) =3D=3D NODE_RECLA=
IM_NONE)
>  				continue;

NODE_RECLAIM_NOSCAN and NODE_RECLAIM_FULL both continue here and they appea=
r
nowhere else, so they can be combined into NODE_RECLAIM_NONE like you did.

<snip>

>
> -	ret =3D __node_reclaim(pgdat, gfp_mask, nr_pages, &sc) >=3D nr_pages;
> +	nr_reclaimed =3D __node_reclaim(pgdat, gfp_mask, nr_pages, &sc);
>  	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
>
> -	if (ret)
> +	if (nr_reclaimed >=3D nr_pages)

I was wondering why ret is changed to nr_reclaimed >=3D nr_pages,
which seems to change the original semantics, until I see the =E2=80=9C>=3D=
 nr_pages=E2=80=9D
at the end of __node_reclaim().

>  		count_vm_event(PGSCAN_ZONE_RECLAIM_SUCCESS);
>  	else
>  		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);
>
> -	return ret;
> +	return NODE_RECLAIM_SUCCESS;
>  }
>
>  #else

The patch keeps the original semantics, so
Reviewed-by: Zi Yan <ziy@nvidia.com>

In terms of the question raised by Brendan about the return value by
__node_reclaim(), I will follow the discussion on the other thread.

Best Regards,
Yan, Zi

