Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71DE9C982EA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EBC36B00E3; Sun, 20 Sep 2026 22:28:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 175346B00E5; Sun, 20 Sep 2026 22:28:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0173E6B00E3; Sun, 20 Sep 2026 22:28:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C7B036B00E3
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:28:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B97D120558
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:45 +0000 (UTC)
X-FDA: 85236186210.04.8927CD5
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013012.outbound.protection.outlook.com [40.93.196.12])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6E6A11C0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=g+d7GYk8;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789957722;
	b=o5EOMF/XYucSf5fiZR1+pwc+9po5irtgV4bLneRypBc2jxniHHGG2wNWLbZOnf5eR51wVn
	gc2+ME+JJvwTHheY69f/mwYh7+88tLuumcmcZv1abrsahz8xyI3BWB3YYCkx6kTQPWibgh
	Ey07XY9qjvjgZPot0uIc8XzYvxNGT3E=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=g+d7GYk8;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789957722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jFPdvSUP7nFS+Sg4e7iNiBmqdaTXK/HCklUfC4M3bUU=;
	b=u/cduiRn9mmR4Ipagl61UR7knY/5B0rTWr2LDmLan3qQ4gmkVQUpGjmvJaXaKpzyj8J+5R
	2dbho/L5FnCwT7zjxNN2LV33Yc5zivtSQvSwg7jcT7QjFKqH7y1zL52p7jFf7Wg3Q1dCz7
	D2jycxdexy9H5BlSu3HsKW6F6AJtwhE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K2a/E8/aT78Hd831bXVCei9ORV14o9PHuxHxGYVzC/c/R1Nj/rh3YSjl2613AgC6FvgUUUvfrXoUiFmNlnQrlI6vnJcye+7XVFRV80iK9eY1nPy3V095wjP+oJzqsjuoKDgvYfDUdnjnhaXetmTnv4vrZoc1Kbq3Ow7joRP33XE7eYbJrMqUzUvecikhl5iZXIKJnhBobioaXjJnmiwSs3ztrwNcc1XJc/qPwmcn1c25VQ6OQOMh3bisu9PPXKq/F3dPP5JRUSQfOsMURPKfso9SYhROcBM0bAO87TiKBFZGg7ZImCHTtMZiBSxCihwvMYlhLvjHMVOtrAXXcr0PrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jFPdvSUP7nFS+Sg4e7iNiBmqdaTXK/HCklUfC4M3bUU=;
 b=FcePS0wvEp1bPZFHvymvjcXMCKxi3AJrT2DDKnlegQ3ZhkGpNLxOYCSwscrYNoo6BFW6/B8t7uj7JMFPukSUqsNEEol4f6wDdhLuucPEStHabk782knyO6A7y5aZt3+JA+MB81w2xs8D/N5wRLtNrU4pJwKlENPO1mRHvyg9p/4oJ/VkGF7v3nOjTpv3O9A3Uo5gmLoRgzicJFtSKWL6JYq6N5Yg4DK1n+JcvRTwDZloZw2+wcSjCoA/1KEBSbrTJVI2fpXC3KlEO6fV/mui7btm1RhbVSdqbRE2/awT5xZqi5+zxEY0l09EvJ0l6LvEVDlnfX7PqehhT4T6i/FkJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jFPdvSUP7nFS+Sg4e7iNiBmqdaTXK/HCklUfC4M3bUU=;
 b=g+d7GYk84BgXRKvp6uuzWjSdGSHOyh8/JZw5LfywNU3z9tgMlAGsgppyNSo+Rq3SsHUocKufu0H14FRk49Mg1SZr46ZPaepR01iELV/EbIGnE1CO95nXQkDC+q0YlHZtJ4s1Zh2Ci2nkQcD3SquCnn5vyHw1JKphzhidA3j4PpT8MeHfcR+oLlhQg7HXR+kser7msTO15obEX3nLb2g5GKVMMBd30uhT4J7lgDz/N4wtJyIwT38y41+nSj5OZeLNEJKkpmcOOb6rQFigoVpv6Z8OTsuyB6lmVtJXPZZx9kM6piBSLqCLZpsWN5PnQjenH0CRVUoimvOWzNMyevlCjg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 02:28:27 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.014; Mon, 21 Sep 2026
 02:28:27 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 20 Sep 2026 22:28:02 -0400
Subject: [PATCH v5 06/17] f2fs: stop using PG_private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-remove-pg_private-v5-6-bb68b6a21869@nvidia.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
In-Reply-To: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Jaegeuk Kim <jaegeuk@kernel.org>, 
 Chao Yu <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQZPR01CA0143.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::29) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: cd715e63-6b5e-4cd3-761d-08df178804b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	rJAWPKE4kF+t5waFgrgvxEyDpeaATlwwFdQCm2pcY68pQrSw9yJMJFPPMHTlYWoVH8i2GKG9lbCuTS/sSG6Vaw38Ppr22wBudOGwHyhWBxdz58ZVBf63tQNEeNzNzjSMXOmodLyv4Wq3xOq2JHNG4hbGJmzh9Om3U5eSYTGjM4293/iQgItDCBHbo0jcgkRhx/kEa7ZwmzM8N1QtXfamSCiO4+EVSka1DrH7J54r/v8wTgClLo//Hs2fbK8xKldSimmGMcTYDAEMzCmeOLE8fpvu80jbI0Z0HvfdusM3jw7WXn6D4CIfKdw6/uJBs6MxYjtyT0etrIlLyTxpU1m+JVXee6NCeyHDoqhetOYRcCPqhH1zNgNa52nuvs7Rr923XHTEjBb3disLKRWstvKRjvcaFSnFmeS4ZE44PSeBy182/pM+Yo6zsdYqZWjhh002ob4dpIf/4I1CenrPZega6TKrFR5yZpkDI/jX2XbafFaYD1Lq/4Vzxa4kEyjEI/UxYnBdKeAeG4TUB+ZKbXGSB1ZoA+vWk24ypLfCN7PTB6GhFWPNsaAe40k29Ahj8fcvR79nkvGjoUDVkQUIL9l+jd7HHsHtpC42NjgDSoFD2nOzaNzHiozar9patYGxmHPR1iuTBb+CdahjxrEifLwo79vjjx1wgbICAfXW2VXk90WVZnKSGSpHqDO902pTh8e//hgemlMF+uxDYTFhTMS48A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y0gzMTUyZDNlVEUrQXRyT1Qxby9hSzRsZlIvYXMzby9DS1RUVTNtSStXSUVx?=
 =?utf-8?B?UWszNHBlanRjNGZweFNRcHJ3QnN4TThpNHVDdUFOa3R6VzdsU3ZGZ2JWK0dH?=
 =?utf-8?B?Y2lJK1ZOdXQzRkRaRHhLTDUvQnFaNDd5MjhXbDRESjBWeWpEK0FXd3ZWdGRo?=
 =?utf-8?B?OUsrNXFNak9hV1k4Sk1CeUhCNW5oVFVBWEVaK1M0azhna2ZsQzFmUDhIblEx?=
 =?utf-8?B?bDZqYmFTRktCZ1piemd4b0pYRU5KeHIvZU5RWk5aRlhxQ3ZnYTVvcjM3R0dV?=
 =?utf-8?B?N2U1aE1qWFo5RlJNNzNHRFM2ZDJzZ2s0VkpvQkx5NkFDdzR0U1pPQW5teTBR?=
 =?utf-8?B?M1FNbE1DZXp4dGRpQmllZmtZRllwckFoMCsrRDJjSUFqM2FvMGJQeFFLSGJi?=
 =?utf-8?B?cU5pTTRzQU5sYk9TM0JKd041UEVoK0ZVcE5NQk95NGhwUmJjMkFGRkpSd2Fm?=
 =?utf-8?B?blBBTUlCRWVhb3VXanJaczdzWGx6MTV2SC9QZk5xSXNFLzIrd3A0ZzViY3kw?=
 =?utf-8?B?NEtiYkFUY1RRMnFDRFdxMHJrcWlNeFAwNVpBdzQ3VEdhZ3ppRjJJQTZMY3Ju?=
 =?utf-8?B?OGJhQVNuNVRSRWtWNUVSckJnRVpaLytGWWppMnVvTDNsWWNmektCWCtRc3hu?=
 =?utf-8?B?L21qNUZrdjhZQUpxMnBLZklPUVJnSnd6Z3VZY1dHVjBHWUZBa3RqTlFUNVBH?=
 =?utf-8?B?dHJxNDNlYkVtOW9oRnllUmtGbnJQbFVjL0pSZTVCcS9aUFBia0FMMTI3eTRD?=
 =?utf-8?B?ZXBSZnJubldsc0xTZHM3OHVYN1ZIOGFBSHhwWjhmUHRwbjRxNW5IMy9aOWJP?=
 =?utf-8?B?VFdYMVQ5S0t3bEJPcjZ2dFhacWVUUmpJdEdBRVlGNG11R3ZIWlg1VEZWalJK?=
 =?utf-8?B?VUxZN2ZnL0E5VGFPNjh6bjQyMm5CN2hLNE5RNFZRaDcrVEtIMWJmdld0dVRy?=
 =?utf-8?B?L0NDaGhtRXVKMHplbHl0d0hITWRNdWo1QzhtdUdiY2N4ZkxRaUxSNnZ5Zmdh?=
 =?utf-8?B?d3djS0t4RFdJTmxHK0gzTC9DWjF5cFkyVUhjdFFhM3JCU0VQdVNHNGVjRVpr?=
 =?utf-8?B?VGNKZ1M1SFlneFhRZWVybFNhSVVtc2k5SGw5VTRnYzRLQ1UvK0dtSHNxZGtW?=
 =?utf-8?B?cmFNSHdMN3dZeDQ5bzNSbUNRTU9XMkNCVTdOcU1xdEk1d1hYUTNySzU1NDk5?=
 =?utf-8?B?WXlkRkVSVFcxa1hPaUJvaGdJQnkwK0lvYW1seS9Mb2hmaVVtOTNYdDVvMjFt?=
 =?utf-8?B?aE5oYjg5dzNnTmp6emtBV2R6WC9ZRDhHaVVrbWRVRjZOeFN4bUlPR0xnbUVC?=
 =?utf-8?B?NWNJdUsxQTN1ek1peHZ4VFNxTm5SZGgwdWd3M2IxTVBjdnpuMzNnWkQwNXNo?=
 =?utf-8?B?YWh6UDVSMjZDOE9ra3BzUDFibTBONS9aT0FPblZWZXpQMHdzT2RuQ05CZTdk?=
 =?utf-8?B?U3FxcGswRUJNejhFR1IzWnVRZFIrMWI5TjZZdlN4VUdaOSs4SzZINHB4clFQ?=
 =?utf-8?B?MXREb0pEcHMvZnhsT3czMHhFbGYyMUkrV3E0SkVOM0hDYWNndExlZnJiemdy?=
 =?utf-8?B?ZEwwZ29GVHZjRHFrOWRGZHY3bjN3ZzcyMy9ZZk81Z0hWbGhRT2M0QzlJbUhZ?=
 =?utf-8?B?Zlh1WU5kTUZybzltZTROU3hobEQrZUEvTm1pT0d6c2lQUHl5UXZVMWh6bzFt?=
 =?utf-8?B?Zno4ZStRNnhtaksySWlpRksvNGlhdzJsS01jeXk1WDBkN2pMb01YTEVEZEQ3?=
 =?utf-8?B?NkorQm53N1FIdFl2ZTAveGRnNkpiTHdML0NoK1BrRWMrK204YjBpUDlFWEg3?=
 =?utf-8?B?ZkhHenk4TXRxNmhGL1UvUTdldGNuNUVLcU0wU3E5emVON0tCNFJEME1HZDE3?=
 =?utf-8?B?RDBCTmQ4enYzaE1rZTg5LzVLWDM0a3V4VFZJeFIwaExyakFGazJKcFNoTEFL?=
 =?utf-8?B?d3lmdzdWNWhJb3g5TGszM21rUDVuWHpTMFJtS0NEL09pRzY5dVJUWmIvbkw3?=
 =?utf-8?B?dlZHSWZOeVVhcDJPaHdCZUxUNUhCWE5xcE9LMkNDZDBuK2JnMGlFZFR5RU5B?=
 =?utf-8?B?QmQxbHBFZE9zeGdNcEVSY0NNT2VPR1pjOUhVZHp1dUNlMWx4VGhNNlJEMk9m?=
 =?utf-8?B?d2ZidzRaa3NiOGlwRkdJaFdrLysrWG10Zkl6TEdTUzVHbXBMQ05LcnA4Q0cr?=
 =?utf-8?B?U3dwOGFaU1BKMGozVlU1eWFvRmkyQ3RWQzJ3QzZnUnpBWW1lYzYyNERiRnMy?=
 =?utf-8?B?WjlnVk85VllmeFlOTHYrL3NtOGtNVXFRWGFKQUZySThUdzNzbDREbGJSbHNt?=
 =?utf-8?Q?DOGEd2TkU9hwn8Dk5Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd715e63-6b5e-4cd3-761d-08df178804b2
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 02:28:27.2918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WD/9sMQINiceqU6AGxsN/CVwvD8RC/8liVN0eEb13GQM3G3CBh9MuAf7rEcrA89S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6E6A11C0002
X-Rspam-User: 
X-Stat-Signature: xrcotq614x61rwgqz9wphwy9bjcd3qto
X-HE-Tag: 1789957722-282163
X-HE-Meta: U2FsdGVkX19jt0jQuq4WbtAZ+mpVpjzwliSVSs2Rp4zRm99kZ0WrKGNjh/KImzSkFYygwXstDViWkl2gUxSluFOSmJaEypcaIHKlxMMN5SSsLY0BvI8mTXAUPlCBTEjj/2KDr4XUoNk+bI7vh/HTaneos0NNNV/1ksYXcHRgft7Yq3abUFI0c2eH6t0EWS8+Q8rTJ9wlGSgsJIkzqKVOyzbSBMaJBABW6tK/cJ8RqPOp8V5lQ2nxPNdSxDowPnMy1Op9ueZC5q6KvhqxYHu5iz1qj/c74FWMXs4+BCiW+OoCPHv+uqm3mGIjsxBKYmc/fEMWaFyK5jQ8wR3x0S0BrG9oj/Wt3QUUHDqoUOUBM1k46AUK+dQKH89tatVPPRcJyTk/KU6ISX8pbNbCCaecFgx6/e3j2IgUyXqvTrv2kNtwNLQ8KJDnnKBcOdwCC8/PjnBIIPRutwaS/vakj7Y78iw0aWYy1754CHBDX5TLU1k0dk96mPebeI7NU4g1oRoDdKYiuIYRlhBlua1AVruvr2Cl81YiczzTMxG+eb/93K+goj0Iv+N7MZZ5S4CMoeH35EH+7VvHCTHKYaO4oZzVEKJIdzVW3Dv6pELHYXg8QF2L+Ta6U7hr09WGoXUUDs4Nw2cwt2ibXIvoUfNhaH3f1S3zcAQYIN2uW8vO397QlIb5yVaiEQNOpXMHU/lzQkJOUf0fyLb4EczxP1xuhk2GtNusbUWnAcrz9VQ3NiQc1n0Ugw4ZHI7rTDtAPLMjOI/RzwjJeb6/aMywl+D2TOlp2RHJkiHuy1y8cZnM12AHVcuR0SETE+WNHm9VjVm/Muww4e3Ltl6o55yEMYWSrobuOhjIAD6HDfyFD8q1ioGl0ZlugyiyDM+QBJfRb7rtM4Jlc8AKYM3V96V/A6Hg+Zi3SwqcPB6XsI0nhd1cNXZDFmt9GADZuc4m7jvybNbLc8/NLx73DF7YU8lfI33uevB
 YgCJz8gs
 KWjsvzZTci+9ZXn2Zuo2a86lwklrW8Y35rhSS6JBdnsPfu73kSkVDzn+3fBPTngqknBxi5F49a8uzVKkAQbWJ+EeraBsB97eIfpaQ3w1SmibWVz0vdwgypA6njLfO/anzcou2wy4sUWLDRyNF15KenoUkfRveUu8OOsnb8BfGfAz8dXD2DDzdATyQ44D4A1OEsaKXPsqcNs9d9LjQ+bnaspUfaQpGuRfPcy1bxD4ez6730T/UFeKqAzjO0eI7X7VPEAN6kLdHG7u/5C4VRcM1jFPqe0QM9N9Pg3/4118C0sK00kEMo4lDzcnoaxHuMkG2RW6sg22JwlIcYZFcnyuJYgFU8IYTf6WAaNvArwrr0FJdbIC13uPhQmVmB3DcS0roRhv5z5LacrQ1gSs2+Y5eKH6NlP+LcEBerKYqOMQ1/I6FeSHDsMRii0AtLP4GwGli414RP47XLhXUKvd0jIoNPYoFS2NeDbTCxdA1K5BiEmWEDmY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

f2fs sets its PAGE_PRIVATE_* flags in page->private and checking
page->private != NULL is equivalent to checking PG_private. Change
PagePrivate() to page_private(). Meanwhile, in set_page_private_##name(),
page->private is first set to 0/NULL before an PAGE_PRIVATE_* flag is set,
but it can cause confusion when PG_private is removed and
page->private != NULL is used instead. Change it to initialize
page->private to PAGE_PRIVATE_NOT_POINTER instead and retain the original
semantics.

It prepares for a future commit that removes PG_private.

No functional change intended.

Assisted-by: LLM
To: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Chao Yu <chao@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/f2fs/f2fs.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 9940a6cecf1a2..2f7ab5888b078 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2691,7 +2691,7 @@ static inline bool folio_test_f2fs_##name(const struct folio *folio)	\
 }									\
 static inline bool page_private_##name(struct page *page) \
 { \
-	return PagePrivate(page) && \
+	return page_private(page) && \
 		test_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)) && \
 		test_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
@@ -2710,9 +2710,9 @@ static inline void folio_set_f2fs_##name(struct folio *folio)		\
 }									\
 static inline void set_page_private_##name(struct page *page) \
 { \
-	if (!PagePrivate(page)) \
-		attach_page_private(page, (void *)0); \
-	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
+	if (!page_private(page)) \
+		attach_page_private(page, \
+				(void *)BIT(PAGE_PRIVATE_NOT_POINTER)); \
 	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
 

-- 
2.53.0


