Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80A2EC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95256B008A; Wed,  5 Aug 2026 21:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6CA06B0092; Wed,  5 Aug 2026 21:08:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35666B0093; Wed,  5 Aug 2026 21:08:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59C7F6B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:08:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6CFCF4061A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:08:28 +0000 (UTC)
X-FDA: 85069059096.22.9892E97
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012071.outbound.protection.outlook.com [52.101.48.71])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8C91340008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:08:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jFhh1Eo1;
	spf=pass (imf04.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.48.71 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785978505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xy/ThrqRZYR6IRoFYVDK2Tb5oVjSNj2/rJzHkqhEB8=;
	b=lNZ4MBeDTO+m579UYo4YLZ2Dez4me2Gcmp++pKw2oOP7BZH3s0spv1bJqvJS4bZswzObhw
	xpNU0FSa15KQwlw1G28awHHd5tot8qabV3kTWbBM3GGBnS3Mie02KJVHCGwUIAU+Vhz2CB
	7ww3DAWUcfMcr+jiZ9xv7dpkJf2PKDU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785978505;
	b=O5zrfXMbeSc8cjRwAc2MNqpmsFkpoVWG01CqBOpI3avvN9Um62Qdhez0q7I0w+NZg7YonG
	stEwiUpP9TVe4rJecN8fxqOdWaOBWpnjYOFczzkK1PAmu8G4iANzz/ieAyYxINpg3maIbP
	DkwgBSMEXW/SpCsRti+7JarLGUJTR6g=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jFhh1Eo1;
	spf=pass (imf04.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.48.71 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jy7GSsnDKxOfMutwmhhtCWLqK39iFnSf4rg6Nu6jd9DAdogovOnUlXX9JBkVi+sfhPfpWsotYAkwH9PV50MacsZJQt1lQ+8Y5Z0Xn5pkS+1efUSF2dD4WBQgZC+OW9raAVzrwKU+4AExlanjitv0BP1EHfV0rWGDwgnRkmH+DxTKvybBYQzu0orGsWlucMSb+W0xmIeTySaKlqNpMUOM1pTe/96y9dtGNYSibaogVtj6RZF1ZRe7zHT9c9fXL3tgRo/T8sFaOzMrhfwbthl6ibJrCkSqRKBocSX8dUZtLlPQoMusTDLeQiYgudIkrx9b8FHYEmYFQMa/Vc0OPtev3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6xy/ThrqRZYR6IRoFYVDK2Tb5oVjSNj2/rJzHkqhEB8=;
 b=haKjLL24cac8u0nckEAetQHoI57Dh9uQTK0VNQsP+mrM84eC6TxyJVVz2zUue7X4o+x06BM7/ofslMBcixdfUE4kLMmg5xXygodCjyO4TX3bBaUWzkaOo/LxV8K+EIb1ffi1hvuefXwoli+7CWP6JSyMq6DbDlDBi1KJep/Wy01tLdAlvEngBYBGyGIADyIeU09fpjnzEL7oMeCmjzVKj+34wNfleN3f6Yhlcl/2jrLOEMyRyhGyFogG5rGqjzcFpCPK9aYZNaecxqu0/Jk0aius6B8FWzkWX93jQTOeip+/Igc+fD1yrBQc4hFq8YpYCsM2ju7bOCc92dFNiVIuXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6xy/ThrqRZYR6IRoFYVDK2Tb5oVjSNj2/rJzHkqhEB8=;
 b=jFhh1Eo17+LDcR5KseNAodrERduJLYFKRRCPWLYAGD24B5qeDhhm5nBXlRtcJxH5g3wYzPyXYLAIcXBh9YEoGoWN9BnHDBCewL3OSIksbMoENg+Q1KAE0Di/5uvKFadH5YEDp7wgUw4d75QGTSsP6ERXG4jbjvTYxEf6VWKAZB5EdYp0HR/eE0ppxoFxJWraAnaOr2xGetiKN1SvD8LZIDTq1I6Sh+lo8N5KGo/poTf9oz5cRJ8Y2qkiCIo/U8Hl850ZbZTHcvt2nZzsPZYad28ceTKG7v+ILumNjKLUfSnGU8pyWg58LTeZgWbsI2gz4PUg2+oKlNSmHAWAldn8rQ==
Received: from LV3PR12MB9412.namprd12.prod.outlook.com (2603:10b6:408:211::18)
 by PH0PR12MB8821.namprd12.prod.outlook.com (2603:10b6:510:28d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Thu, 6 Aug
 2026 01:08:15 +0000
Received: from LV3PR12MB9412.namprd12.prod.outlook.com
 ([fe80::c319:33b5:293:6ec4]) by LV3PR12MB9412.namprd12.prod.outlook.com
 ([fe80::c319:33b5:293:6ec4%4]) with mapi id 15.21.0292.018; Thu, 6 Aug 2026
 01:08:15 +0000
Message-ID: <0159349a-41f2-467c-b91a-3775e56a660f@nvidia.com>
Date: Wed, 5 Aug 2026 18:08:13 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: debug_page_alloc: fix NULL buf in
 debug_guardpage_minorder_setup
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260806004556.2633049-1-ye.liu@linux.dev>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20260806004556.2633049-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0014.namprd21.prod.outlook.com
 (2603:10b6:a03:114::24) To LV3PR12MB9412.namprd12.prod.outlook.com
 (2603:10b6:408:211::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9412:EE_|PH0PR12MB8821:EE_
X-MS-Office365-Filtering-Correlation-Id: ef1dcbd3-0f50-448a-3ba5-08def3573199
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mrSWd1RbS/XDGX311m7xWir0FHflV7bP8XlYzplqd9jLO4Fd5UuM8ZILi38Wxmq9xtSrQu1ccpzm3+Uaqpi2FmE8+X1AUoCKwOjoveQdihuhrgC5FkGHiRw8X+GsfWvpwPVGiXYtKayJ4ILtrccym/jEHQ8TsuXs5Pd68ITIVOc2M7NrTZSVjMw90yvIy7V1bXodBQb59f+JpdkfGXXQdjGq99sKiyknIgHBrA3l2FguwQAhCy97fRByk8Nxr7Q1KYm59oFC/RryvK1YuUv5lvjuZQvELofb4gNEwDBUByeRuLDAsKZoZWGlaqaaDvex3Ry7zjVGzO7vndiPOHXgXLybrjwaZQDdnmtpR9vL0XyYe4hlDXsCuWVGHPFCHI2VhdA51zL6RBB1iAGd3Ms4roUtrpOfydrjn5MXc4NN9P2GVOfm/+lHFIAQgZIRo0wA6XiiLTzAY6z5S9nw6pJQAjgjfHVuTXpjRFJBDkcxekcgSD8xB6XaRCuWPbSCFH9S6xa7dAsREKnc9Ni10efSiy8RlEyalg/JPv3GqO1lb9R6RqzjlzkwB1jxpdyQwgFsMAunWmrr5FFo9ThKPvY8OjWNX/tdpGtFLISqpEtjayGJq2S8irskSF/kDZb2MYwOi36I8IB9ESdhb9zCEqVhlAhvHXbCEdotnzAwPcOPTbI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9412.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c3lYaU5WalE0SDVPQ3A2TW0zbCtKRnl3Nlp6bFoxdS95b1ZkYVo2bm1GNjFV?=
 =?utf-8?B?ZjRDV0J1dFpLMHFJQjc0aENHMEpkeEhlTm1VTks3L2N5TmV4T3d2OXhYZTVO?=
 =?utf-8?B?NlI5NTZVUDJqZjdoYzVtR0tBSW5kR20rVHJ6VEtwcUFjRWUwbjZvc3pXS1h2?=
 =?utf-8?B?eFZpYTdVdGN0YXFWU29yUmRBejBLamNwNVpmdFF0M2dSUjVrZHVNM1lqdTg5?=
 =?utf-8?B?U015elZlZnl5VnBzUzV4eTlkR2drdTFGaGt0ajBCVnFHNE40WXRMYnRWMmIw?=
 =?utf-8?B?ZXEzdlBXNk01WStVbGlLbDZ4cEVRTDlUdVVuTXRTVmpndTdtQVpkUElaeWRK?=
 =?utf-8?B?OVg4UFQ3ZlI0MzNid28xYTFhM0lXN1hpVzN6YXlQbS9FQjc0YjBEam9BdmtJ?=
 =?utf-8?B?d25PQ1QwMHorNndYRUZjM3VTc016NXhQUlNLb0hyUTd1SVpqeDhoWWkzZE1Z?=
 =?utf-8?B?Vm55TlY3OHF3L2liTTJ5Vy8vR0Y5ZEVvb1RhYXVtc0l4bjZmQmRIVWRMdzJZ?=
 =?utf-8?B?MFBPWHhjWVhtaW8xSk5NVVpxaWtBbXJ5QTBsZHdDRUVHUGRDYm4vRW9jdUhM?=
 =?utf-8?B?VkZTQUhiZEdhK3FKOTFhUjJvM3hoR2xXTnJoYVlyQXo4dEtOSENWbTFmc2FR?=
 =?utf-8?B?MGZoc1BxVnlSZGhsWWZzUVo3blpZUlJLRjBPMU1KbC9WVC9ZdVpsT21LTkdJ?=
 =?utf-8?B?WXdOWGxmSU9SbmsvbWMvbVNYM0s3T1pRTm1pODFPTGFhSzlvYVc0Wkt6VzF5?=
 =?utf-8?B?RUlJUkdybGk1ZWZsWFFuRFNpbGJ1a3pqSy9yS0s0Tm5xRWw3V1NNK1NhY09k?=
 =?utf-8?B?REx4SVJ6WnV1bTVTT3Q4QlptWDNLV1VCK0dmY0dvWlpoVllwM0pTSnM1b2hp?=
 =?utf-8?B?YjV2NHJIQWRhR3pVaExBdkd4cUs5bzdhT29CTW5yRXkyTWY5YTVpTllodytl?=
 =?utf-8?B?Tkg2WlFHd0hzY2lZS3ZSekw3L09aZUptWHBzRmkxNkRMM1dSUHNuVVRJOG80?=
 =?utf-8?B?SWpvS042SFoyYkxMZm44MC9jUDFNaDF6Z095VU5YNlFMNFladVY3S1Bqa3Uw?=
 =?utf-8?B?Unc4UHdkN082VVdWb2RucWdERnhlZ0wwaS92TEhxVGRvMFgvVXZmVlR1dDFZ?=
 =?utf-8?B?aCtZVnlLUHpjbWo3ZHY3ZFFid3FJT2RJOXRhWDBFeHh2VDdwSDM2YkFlQUFC?=
 =?utf-8?B?Nlh2c2NTMk5ad2ZyY1N3MWwyWFBLMFNDb0RxV2tobzIyMEFncWMyaG9BQUh4?=
 =?utf-8?B?bzNtNlZmZG41UDZLRHNIYU1OS2ZqekZ6YXJCY1NneUdQWTh6RERRZWo3aG5J?=
 =?utf-8?B?M2ZjTmh0Szg5NFJlOWtpTzh3L01oZWhKd0g3MS83L25DWVBtelArTjdnNWYv?=
 =?utf-8?B?NHVwMmtacjhBTXovQXNjRDVXYzdwZDFDQXE2cjBtVC9DODJldE1MNDdDSTd4?=
 =?utf-8?B?dTV1NTNIa0RxMUVlTkpvYlpDL2NKUVY3K0VvVVVwcHY4WUZiQ1UxQ09xdU9a?=
 =?utf-8?B?V3BrMjAzVHd6YjNrdFpaYTRHY1FKU1pSd1AzaTNKaHQvRkU1RVJuQkZ3Mkt3?=
 =?utf-8?B?UjNJd2duTzRPaUZLcnZPUXF3KzFoVDFJTXEyTzVVaVh6OXNQekUrQlB1SStJ?=
 =?utf-8?B?dSs2SUxkMmtnbFBNSSt4N0NlNXJnRlhMVWVRWG8vZWIzVmhHa05YbmthaTBY?=
 =?utf-8?B?L3Q5ZGZzYUV4Z0lHaTByTW5pUW1BZUhkMHlCclF0Um55cTZVYmFrOGl1Z01F?=
 =?utf-8?B?eTFVUVBkZDMrNE5oUjVmQ2syOFBMQkdiR0JleC9HcldCTmhvazlrWTlrZm1t?=
 =?utf-8?B?SEtWQndxM3c5NG92Si8zK3BvTS9xKzhYWU5jSTB4V3ZvZGFZWjZwdG1lay81?=
 =?utf-8?B?aEVoUVRVZE5ZK09lL2hXTUlnSHZaOGxZb2dHSEUxckRTNUlJTXV5WTNWVExQ?=
 =?utf-8?B?MjdpMmlTWWJWQThlOXpLUEJhTktNWmM0QXc4UHpDbGpYS0w5dGs2VkpOS3BC?=
 =?utf-8?B?YXhNYytnbVRSVytLd29leDY1MWM2ZWw4YWN1YlZrUVI5NWxyMFpSczh3SU9M?=
 =?utf-8?B?MysrTTd3U0NybTFIbjFOL1RzRXF0ZFhHa3FhVWplS1lSUUZFRHZmdzM0MTR5?=
 =?utf-8?B?KzBnU2VsS0EzZ3NYV0RVSGlrMlAyQ1JId1JmQVBxcmVrTC9lS2dyUzFzR3BG?=
 =?utf-8?B?TjhSK3QwcXZLbU4rRjBhVkFDaHJ0cnBoNUl6YVgwNHZTRElubWg1UGNqQ1Zm?=
 =?utf-8?B?YzQxRUVIdGhzclZvc0RpeWhYaVNwVHVOandJelVXV0lnMXV3alQvMXRmU0Jk?=
 =?utf-8?B?MFY2ZVBuYmQ2Z095UHAxaWk5empCRzd6MVZHZ3BpNkU0elh0VkVLdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef1dcbd3-0f50-448a-3ba5-08def3573199
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9412.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 01:08:15.5506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LgtVRQDXFqIPngY09VHYeJ14job7NCQyBJG7ld9AgrxLulSgFoLHhwX/rDmZBehQt4O2652Bpbwds/7Jn8fobA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8821
X-Rspamd-Queue-Id: 8C91340008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9u4trcybadue16ihq59jtxn4tw43nsbh
X-HE-Tag: 1785978505-601448
X-HE-Meta: U2FsdGVkX18Q7yYgqQZhb8tUk2/FHOVmSOcMlw12zU619f5uaBKl4yCYmFSCMZqQeFz1PZHsn5KW95ok3PcTL0tolOI7hPmw2+NF4QhVmffP6OeG6O+ys1BCGwO1FHaoEFqINSgES+lB3w1MJ/WMJcgew2eG3LoRMf8TvTFp8oxQ3pF+KmuA3gIlvrQ5A7TWpXFG/peDRJB+WJRJKbTWmU3dDvkQ9Lhm9RZw1BfAmHt5jzERnh34bq4h1DhIdCjb8KgUn2gIFQgLWAv6AM06/kdXOVDPTZu8VLBy3MLACk70gQqnO/rpWJVW76aR3pUpOR5bOgAYyvH8j0QbdxzYyvpaBPQHdi6TcRjngA9QFYznBSMvpy6x6A8iKtGxWnaFZ1ADsEXkaa7of49O7Q+yaOAkXwA652keSPSzBNdsdnMM4PmegAW6eTH1Jld7TeGhwaZojPFNlwflUGz67H8hAgwl6iC84gUfm/A7Z8LDsh8gdtKMmsh+zvGf2thV3IrI/oCZ+YKJXTipI0JNGnmiLrujgygfcPTqrGqSyAeSaBfx20UfWGQgGwbQWXKHlHqD9uQK4keRXIcV6wxj6o2M5zO5qVM/LQMyo/d8eEZLEmKG+mlk3lhLonFLRY64bk7Mz69guh/DV3Gn7AdsEJSp15R4E/3hHLIOEVi/kivj1RzC/h6cvJUK7aICMayBx00x0zJMXAMDSmy9hn7fQJvDmtFidsQKELlFFZFbdbUwVtkqQjsfE+ldrcZjZsY05Hzbq/Csq4fdV+Y310PzWiobqIy96VPPdCwFFJe0iPMIMlRBDiIYYls39P2zBEdneAxshq7nOySo6uj19AbVCYHUj5/010AKzMExvRz//XpFqAJztV1Jg6LlId+XZqDE+LEi66qdYoa2guEmtlzm+nXYoKbAFgtpa7M7sBQnRqBlW21XFwwV/enzWwlZUDI2zaTTmTsNUUdLcpwE9gx2MaF
 QRm6A0bx
 0kXAXhkvfJ+YDHUVNaunhjzPInSnTDNYuIrLfiFp6DhmtNMgGV7NAwCgEzs35DUqgpKYiZcnoXb3fVue2FNsXUHxXgRn4vGZiPzfono8WSTsa+HNoKCWF1Ossbzrb1byVBIyF1JyjZb+oqpeqNQA3vRGTatEYaHrxLvJzPNoSZ7agnlsngDsQpKBrtYEvx6dg2PZXWgI9wHSd+TKjE8V8Q11zwJBDQU06gDuWO2v5dwuqd/rWzpYw2duDWOnZqUuJVbhgIWjvv2OreP1FJHpIcsc3/U3KSVxdHLOY+rZm1Oqp/mNJCtNHpx8piWtsQsQCz2uMyokGniXM2ZL2lBYYYSh5gI1G2DxEWBZuYpJiIOsDooAQM9gEkwbhhwhUS+B4D6WI7OlInO0d66rtDNeSG0ubMd9YCbSGO9OnIFTQ6gym96VqQ9NWvNjtv7gyVuAoEQCe+spn4ZJEv3E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 5:45 PM, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> If the kernel command line includes "debug_guardpage_minorder" without
> an equals sign (i.e., no value is provided), the early parameter
> parser passes a NULL buf pointer to the setup function.
> 
> kstrtouint() does not perform a NULL check on its input and calls
> directly into kstrtoull() which dereferences s[0] unconditionally,
> leading to a NULL pointer dereference and early boot crash.
> 
> Additionally, the error path's pr_err("%s", buf) would also crash with
> a NULL format argument.
> 

Maybe a "Fixes:" tag is called for?


> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/debug_page_alloc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/debug_page_alloc.c b/mm/debug_page_alloc.c
> index 41e3d1f1ad96..fd2664c3c86a 100644
> --- a/mm/debug_page_alloc.c
> +++ b/mm/debug_page_alloc.c
> @@ -22,8 +22,8 @@ static int __init debug_guardpage_minorder_setup(char *buf)
>  {
>  	unsigned int res;
>  
> -	if (kstrtouint(buf, 10, &res) < 0 ||  res > MAX_PAGE_ORDER / 2) {
> -		pr_err("Bad debug_guardpage_minorder value: %s\n", buf);
> +	if (!buf || kstrtouint(buf, 10, &res) < 0 || res > MAX_PAGE_ORDER / 2) {
> +		pr_err("Bad debug_guardpage_minorder value: %s\n", buf ?: "(missing)");
>  		return 0;
>  	}
>  	_debug_guardpage_minorder = res;

thanks,
-- 
John Hubbard


