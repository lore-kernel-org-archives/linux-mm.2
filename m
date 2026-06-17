Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92B62CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:35:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B6AF6B0005; Wed, 17 Jun 2026 10:35:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58E2D6B0088; Wed, 17 Jun 2026 10:35:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47CD46B0093; Wed, 17 Jun 2026 10:35:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19CD96B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:35:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8BEF6A0437
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:35:25 +0000 (UTC)
X-FDA: 84889652610.23.D09D2B9
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011008.outbound.protection.outlook.com [52.101.57.8])
	by imf12.hostedemail.com (Postfix) with ESMTP id ADA9740007
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:35:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=P7F7FoWe;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.8 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781706922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ga9GHvt+ZuSPDEEta3Octx/7sr47N9srKBT2Nju/iNw=;
	b=ZTe9Prl9njThTe8wkVa1EhXNTdVJ74eNYoMR2tjjpYpn5GZF5gIxv4M41oXb6GgxJ+A74d
	7YmkqTEo8CQcSq5TSP8+eMNMqJeF75m8sbBPgfhH6YEgyf6xRsWKKfslr/QND7AdJpD7JX
	89aR6TEsGPKgO8yxwDRpkq1bTT57oe8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=P7F7FoWe;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.8 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781706922;
	b=w4w1b5wQuzFJsjB6185877VHMzpedvZmHQABiCWRFu0NWLoXTWuqxAS/m/XxD+8b/romtp
	MvpTuPR0ZBnWUbWwao+7bOGO4plw2alAWN7qcv4pM/Iqa7sS5aaKoHVPTMiA8kBr+5kOOr
	FfHhNFANboC/QGVWrfhqlwMFJgW2T4c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t/Oy8PWXxtUqDW6Q7W74ciSihYkIUCVSliR42Nei5SxqmYbtQYvOxQDUbe8Exv3ac7PFXL8jJ+apphKwojkQ0RJ1eCKlpv41W1BzCbHQxSBFZr+9/17pTLEZ5NJiLXYYMdMQSMgI1MaFeuEPOY+LZbIaHziYzU/9Gv1a4XxVVFlXz8anKuNIf4hh1HWFI8nJsLKHo/gLrBMoZ6mx4Eqz5EIeGJAVuzmBJD5S1PgFpQs0NkZ6JobqmnCIshjVXCPqrGdVnB2JDKx8k7iTGZwDCIIuzht58DYxelZnRippG0t8bMm/gI0t07AljsbIZ+QgVw+xkuAa4YY3T7u4eQcpCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ga9GHvt+ZuSPDEEta3Octx/7sr47N9srKBT2Nju/iNw=;
 b=X3PS6WA6KkPIxu9592Qe8ni12DX433qYXUisQp8t4+G415aYoLc8Eq87UFOjiDjS/OMaYubt6fM8jkD5u0of5Y1IXYdDho/+dC+lWxMbKdpr70rHzLjR6crzpMP0oBvNx/iiVi+3p0cbd1qzdrNNhD+XTfqpg69s4AaCAnY+6qnosa5iVjfEzMP+EvQhfXBULFTFPabpPmPPoULu5dcSZRuXYoGZthZ7QdB80Wps+2khoSIIdS2gu7G75zhAqqv9QAIt/PV/P37XrH9SBOfPRXuPiwEnTtom13Fr57iu7h8QYXpKY/HyDgy/iSjIownNfbsagtKc0jPXmXSu0BNxPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ga9GHvt+ZuSPDEEta3Octx/7sr47N9srKBT2Nju/iNw=;
 b=P7F7FoWe6HxOJk5EtRyIJNXcbjYywqs+wRRXG9incIn0hdQk2cs8uwVBRz3HYeJAZsNoziJkbGCK2SIbWC4L5+OQywyOZ1SgiokCFVoRhMdSIH0+v4NJu7Ad68XKr9/z4et+RuxmnRUe+tY1f0lOub7WNqob8qiJDJSwE3zbYCT3HeypqrU3di75K/mPPj6xq/emUezasjbdDHJDDsaF/8tFZRnPYzcYqKkuiMGVeyDhL/PscfBw8zEwYwb0s+RkAH7lKNMX3Ndq0fDoCX1Y0mwBgSf9jrdRPBXUIl3tAvkyuIkJ8kU2ynnay4Ew8xpwiYUZRuOmDOkNXyMfMAKmYQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ1PR12MB6073.namprd12.prod.outlook.com (2603:10b6:a03:488::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Wed, 17 Jun
 2026 14:35:12 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0139.011; Wed, 17 Jun 2026
 14:35:12 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 17 Jun 2026 10:35:12 -0400
Message-Id: <DJBEDZTSG9BF.1K3SNJEEH0VWQ@nvidia.com>
Subject: Re: [PATCH 3/4] mm: mlock: use walk_page_range_vma() in
 mlock_vma_pages_range()
Cc: "David Hildenbrand" <david@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Liam
 R. Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, <linux-mm@kvack.org>
To: "Kefeng Wang" <wangkefeng.wang@huawei.com>, "Andrew Morton"
 <akpm@linux-foundation.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
 <20260617082622.3397584-4-wangkefeng.wang@huawei.com>
In-Reply-To: <20260617082622.3397584-4-wangkefeng.wang@huawei.com>
X-ClientProxiedBy: BL1PR13CA0317.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::22) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ1PR12MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d343703-d0f0-4675-7ec6-08decc7da3f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|22082099003|18002099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	XGR3SEW6+3un6eQ7b79/sEVUedZGPK3hg2ygd4TIWBkdBBEdDInVcSvQhNvjTvCrKtZOE6d1O7ePEUhmq95anh+9Frx9WOPU3EZXZnuFIBmBaHpWyvlLXiH25pUV6RhT53jqhTyJ0j6+NB4+NSBmPaLvGT2NFwnUC6g28C4cUYof7HDIuqGyqCKdOEQNAtQ7443V6pkw4Xn+5t7IHrildErTkuORFRZGs3ea9AMN5jeVliOUpadqH13s2CKe8pz6ZQU9Es0g0asGn549DTWXbGfp/BW5T2IPQnw2g2A+uqFTq1AXelTirrQ/aZr0Mb0K+HQCq9FwlUIDK6OjqlcccuOBp6N995eR2z55GQ21sZ8pKaiQKIfnT4FUPl+SUnyQeHwSRLf636E3zLkjWVafl8lMVWkNXU2B7O7jeZXZyMvqk+ZhWDxFk8zRl5Ixrw2FSlHqQp7B5Uc4nkYACTJfyix1bwW3tpW+QkMnIWpPLotfD9J8zxpnrTFFLxbtPbue7imt5UAhLpyz6njxEW9SCfonqoTxEItHlAJ3gHZrjBNkdKkoLNnpQQ3aS8OvjuZXh/crnh+mvrVrmZzkpypKf0pXDmihV4T1iVOZaWq01OvRPHLkjF8Abt1rSYDBpMq8gxpJu1Ak4xSLtjsIY04YwzjTXO2CvgKb29ahGwJ3m5MisBpsFzjxPgVdy9x9RU6/
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZzJ1a0xoSjFmallLeFJrNFdhZXhQZml4aWFEME4vbHdoSGhGcnY4aTFnZFJK?=
 =?utf-8?B?YXJ0eXBGb0docCtsVzhja0o5em9KUFV4bUhLeUIwSlRQTkhKaTkxSGpTbGhJ?=
 =?utf-8?B?OEhpQnBkUy83aGtuZjNiV0N6bHlrUThsUWtVM01wVnJtR0tpMExVUFhGbUxP?=
 =?utf-8?B?cmcrbm1ZenBTcS94TnQ3UFdCZERpR3NYSmFnSmxqbTlYM1BxRnRKSlNkZUVy?=
 =?utf-8?B?RWF5OHZ3WnA0U1NidjRqbzJROEpDa3VkTGZJMERkbXZxTEk1M3hvMmFTK3Nx?=
 =?utf-8?B?RXJCb0lvSzdLbEk2RnY2UGdLaS9GR0JSRnl4WXZQTDE0M1dlYUQ2SlU3L3NI?=
 =?utf-8?B?VU5nRWxqd2NHRk1jUWJoSnRLSkZ2aVE2R0FPN1RiYXlJL2RQamVVNlh1aGQ1?=
 =?utf-8?B?YUFHelZjWjUvam8rb0k3bUVNQzYzMzM4QmprbjJLMEZrRXh4cmpBSUk3Y2ph?=
 =?utf-8?B?T1ZyZ3U1cE9hSnEyenB1V3FXK2RzVk9zc3FKL0hvSEUxazZZM2lzZXBIcXBO?=
 =?utf-8?B?RzJ0QURQYWJaenFUWEZnTzJUT2dmUnpZUHMyNDUzelRaUjBYbkY3T3N6cnM0?=
 =?utf-8?B?MHYrN2E0RGpXdDdYcTl0MVN3SndZNEpzOTFTRnUxTndOR2tDS0tZS2JpRVZK?=
 =?utf-8?B?ckdSTHJrU2hsR2MvRUs4Y1Q1MGxjMjVTanphUWw1bVNEWS9PVDFtZXBmM0hn?=
 =?utf-8?B?eEV5SjR5L1o4TUdmU3JpQTdrRnpDZHpxS0tHVnN2REdRcGxJNXRhMnFjRWhn?=
 =?utf-8?B?S05kUzlqcWlaZDlBQmJEWU9mWFF5T2kwdGlOdGhhN2FSK3lBaU1BRUlraUJ6?=
 =?utf-8?B?dlVCSnhuaFNlaTZzeWlDaGliUFZobWluMlROVkRncWQrQy9MUldRQlZDTTNj?=
 =?utf-8?B?SERCMkhoM05xbmYzWFZkTVVVNFVmbFQza1dtRG4wbE5SN2QxSHd6RXNZYXlN?=
 =?utf-8?B?VkNDWHV2STczdXBEZUFzMDg0dWZwZG82ZHd1SUlSQSsyM2Z3Z0xmTlBjS0o4?=
 =?utf-8?B?RzB5VHdlSFlHWTQxTVpJK1dmV0JSWVdydXF3ZkNYRXg3MCtvSlppR3NPVnly?=
 =?utf-8?B?WFhJb2FGbUVBTUZPN080YW5FY2g3QVgza1c5Y3YwTEpzUDVjejczMzNGZWNj?=
 =?utf-8?B?RVc3aXIyaHpUWkZEWENWaGYrU0JEdnhXbXFxZXlCbFZUY0RtM3pqQW94SUR4?=
 =?utf-8?B?cEtWNVFIZlNxRE9CcFFucW5walo5cjV0N0ZQNUlZYXpUSldyKzBEZjNaa1U2?=
 =?utf-8?B?V1RRZ2dSbGhncFJYOFlmbUVJNnNMZzVaOHE2aXVNRzJrVXVKS1FaU0FKNCs2?=
 =?utf-8?B?cnFXb3BYRkpQZ2NTZkgyYkdBNU1mSHdVMDNvQzRpQ0RBQkJXVERzbEpyQ0M5?=
 =?utf-8?B?c3ZYSUMvR3BWYmJSckdDeTMzVmdXMmxsNE0vczl5Y3MzLzkzVHBwZmxSbC94?=
 =?utf-8?B?bTBEZGhPUlhUaWVxSk11alhhcVJHYk1ZS2tTdjR4WmVpQ2pWaVBCNjFuQThi?=
 =?utf-8?B?bXVROXR1M3dQM1ZGenU0cUhmejhMcVlKcDN0SXVPbGsxOUhZekhXMUdFaDcv?=
 =?utf-8?B?Tlo4WDlpcm1LOERuWXpZS3NIRUsvSnYwQXk0akk2L0hrcVZtQVQ1a3pCaDR1?=
 =?utf-8?B?UHhqT0FZamplVCtlVHYvZXVyenIyODZ5Q1JLUnF5Sk01K2FvNHFmaEhwQlpF?=
 =?utf-8?B?QUUyc3o2M0dIcjBNTDVuck13UkZaSTZDVUJzc3E2ZnFETThPS0kybklBM2VE?=
 =?utf-8?B?bnpXS0gyd280bTJxK3lHUFM1NDByMktuR2Y3WXRaajl2SjJRbEsyMTJFNC9z?=
 =?utf-8?B?TG8vYnpXbGxKSjVUM1Q0bHV6YkN4aklscTh5L0VLVEU1RFlVUU9GTzA3em5m?=
 =?utf-8?B?dHlFaFFaNzdlcVRnTTNycVNGQnFNWVVpV3orMktoRUJTa3R0VXo4OE4xY0Ru?=
 =?utf-8?B?M3dXa3E1T3pIaEhLaXdIZU9ObjZyQytlazdqNW9vR2gzR2JPaG5QS2p3QUdJ?=
 =?utf-8?B?ejlkL0U0OFhpTWs1a3lnbFdoYW14aU1VRmhEWnJWK1hXTHZSTXk5M1Y2WFFD?=
 =?utf-8?B?UWRqZWg3OEZnUkJacDVFYnZ4eHlsY2txU1E4L3pyZktyQXE1ckJHZ0QySWF4?=
 =?utf-8?B?SFl6RzVQL3ZLdlZTQUJrczlBV1E1T01LZWZVL2dXZkZhT0wrbWFReVNETDR6?=
 =?utf-8?B?QTFyQW9ac3ZhcjN3cjBpMEtCWmtyRGNZSnNiV1lrNmVyOFpOM2NiS2JhVUM4?=
 =?utf-8?B?OXhiQ1d6L1NBQkR3aE96UTdta0x6eW8yekZiMGM3TWhpWFEvQzJNWUJpbG1m?=
 =?utf-8?Q?U3IWDzhMrMy/60nGWt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d343703-d0f0-4675-7ec6-08decc7da3f1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 14:35:12.7676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CkvtIx6Nc6tyEbk8gtQkIGIGKqwbk4ivYseWJgIu6NulfSeaHR2feoQKzHGK+rQ9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6073
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: abtoyobj76a15mj4e3ufe5addtqr9eaj
X-Rspamd-Queue-Id: ADA9740007
X-HE-Tag: 1781706922-508329
X-HE-Meta: U2FsdGVkX19N4L0l5acFodjGbXgKyPIyGMsWMZvoK1il92FIoctJO3sKNGG48A4b/a/8cE2ZdGCJvBKRYAwtnRigm+PYbEGNUloRy/xtqfDvQloVsTU0YbqkhayzAJBX7PjuKU/cBeEgm/pWS6RFXDiMIXek+iRNHxymAZTSbkIDegfCEa8Zdk2yFri1RvvdbVgBItvogGU8d5yMugSUKJDc25KGAdXLrXhjXusmSAId9l/v7sjQLUEDwFRxo7oVpmeDryEaz6dPVfNHj5IVWtZuT6PhVVXrF3o3cS8Rp4mVqOH8DV0IjyHtKDoIzZbKwD7GWC4mKSlMiG5XJbU4fvaDbQZy0Nk7pGA1rVozmQimKdqd3cmN6YJ7gjoUKJ5dmF9IyjBQ+gEJKt+mCzwVcMWHtMGIgLbwk+xwW3SMfCm22KpnabynVAddIOu9UHlC2GH6BzvLevW0AdQr3Qv+Ia50b8rLwD5BEQAH0h1aR+IpE9vmceBDjzN9kNXInZXRBe7sTbhFZcl0w1LBfAVpt9QzbkqZ4mqxVJW1W89pEVaXMmnfzcleAxXQGQEd1SSiH2lCclsXCyO8Ar+IzEU+cq3MI/nK5IyFPEJS0OtGDTsLS+qzU4xhYShVJmdY3QS7erpPGQ7sY97KE1u6NcV8cdqIeR8JBzqoM+Hh9v/MhOWKSlAnDQ14mb9M/ZhNnaXIuHyxBEJzHZXcz4zQ1QoEK6fuXdJsIUD0SBEyr7RGSQ+eyN5xm934I8Dq6fdfsDBeRGN/aoi7+GUSMgZh3LJS70GnDCJGRPNBEH+BoMXTIDzsC6zihH6In6X81DopZ5f8W6+ytf8ip07fZO9DYe9KfuoW9SkU7avqqe/DaUmPUPBmkPOonTztr9okrETJoZr6dFZ6StSsbS8yvIunC5JAaKgYURwoJTYaqqMmARZDF6IGWd7+xzC0TqeJOidNxx1CUl32D7dIKmRWZymeDcT
 EMw1z1eV
 IlR1JbDYDi+A/uwg3Y+I9ymqoOIZE/laFabMIwGBTkUv8wdWmIilDURSvtE8qavb14AQ940N+B5tc5AXHnl0YRY4Z+CLuX6j+jsN/1uuX683LAeHBqvD+2rudTnH8pF17CHFBN3iGK0eT7QwpSe277ftXAJSEalQEu1CxPORbZpAnY5SS55ssLbZZBI3PrW/s6XhfDk+6IufxYEEKMOeDpawSsg8ICY9+nnzDMLY9CxftgOGq4xeYQVa0kIPLzptBRufpGy19VqRwMJquM7psTWn4zQZvZHBXKHxSuX0txq2o0h3x0UrBhfO4JSEerN0gR7+lWbYWlg4nuP7IEHyCJThn03BAICjif5ld1oAsiPWAb0AMJ7OTy7NhZfY1LMuGIiIgoFRAhWj38YwcAaNRjPgEOmiwlUA6rLRIFcXQi1Anwkuv9to0KLh0MiL2xR8rNGATgFTlI5vkHw7SRVINdNOf0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jun 17, 2026 at 4:26 AM EDT, Kefeng Wang wrote:
> The mlock_vma_pages_range() uses walk_page_range() to walk the
> page table. Fortunately, the caller always passes start/end that
> falls within a single VMA, apply_vma_lock_flags() iterates per-VMA,
> and apply_mlockall_flags() passes the whole VMA.
>
> Since there is no .test_walk in mlock_walk_ops and VM_PFNMAP has
> been filtered by vma_supports_mlock(), it's safely replace
> walk_page_range() with walk_page_range_vma() to eliminates an
> unnecessary find_vma() lookup.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/mlock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
LGTM.
Reviewed-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


