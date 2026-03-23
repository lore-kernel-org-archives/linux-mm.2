Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 350D5F483D7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 17:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99C7E6B0096; Mon, 23 Mar 2026 13:59:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94BC36B0098; Mon, 23 Mar 2026 13:59:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 813DE6B009D; Mon, 23 Mar 2026 13:59:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AFC26B0096
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:59:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C3C313C197
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:59:02 +0000 (UTC)
X-FDA: 84578088924.03.F9806CF
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011071.outbound.protection.outlook.com [52.101.62.71])
	by imf26.hostedemail.com (Postfix) with ESMTP id 50E2114000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:58:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Vny2K3eQ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of jgg@nvidia.com designates 52.101.62.71 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774288739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T2Xo1BTiEzYMySYv0xvmi8XAdvLUNqsakJOaorvq6KU=;
	b=LDWgCYebCpgWn/tWfuzicPO/5mDoznCMK1ECacbgKdxVUvqH95bOahTKag2POAJXFFzV0r
	CxewzlhzVWqFa7ZBPByzsoygYhIOZoxx95WG3BWBbtdA7NH7tzt+xmyULkPZ519Q1or2Vv
	qsHWUoe3gv/pEpGpP5E+CoyqbQhHM00=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774288739; a=rsa-sha256;
	cv=pass;
	b=Zkr3chUdUDY+crzat5QaHZcqUlmc2sz1m0tmPhuChi6H9DWx8111AIXDJwlm0BWPDwAxCR
	7XeQ6RLCiOVYwj+souxDVXam5Na8n3H9HoIepVTL5QInGVzk4ZCgY4tRvFvwNVr/+9xNW8
	dkDC1u6SlsarmnTQRK3MYsUiePep2PU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Vny2K3eQ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of jgg@nvidia.com designates 52.101.62.71 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UlIq/e326tiKmigkdBrXsU3O5OgxXEg1QB5GMdLULLVdoNpPNXkoC1c9y5vE96FAYPjojkiGurxwY895mhmkWblig6Uuy0gNJWi/eGmFGluG78w8+KXn0k7AxEAFujhgw6eDwWdQsjdedDljvpgThqyP3SwXa9zNStVb3uYoCrY7bPj63Mz1SMTJbvlBVqZ1I9ROdd1En7Xilx3PHBjADel91FP+gZgES2omniafobl0Hau+hCSdGI5cN2WGFKwPlCorNRTbncKgDQv3z85UIxg+KRajRDnY97xKsLf/77UR5jiOnTwUD1KRxUA0fWg8HSuQ/2hubqAF2DPZ/sMP/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T2Xo1BTiEzYMySYv0xvmi8XAdvLUNqsakJOaorvq6KU=;
 b=kazhKLIYi/IAdV60dWXwp56xPn8lJr1o6DhFyzeb+wRoO/zLH/pQw6yLnuP8ogsQHGXWtjcBqDWehiZC0PaytuQDwrq0j7luvAvZNeXND9AQ2Y+zvY0SY3BJuAi7yj7Nj0h+9LnmuufMDKpkgw+uSRZITuVIKXhj+uxKV6bMJ0GoD+ud1BN/9YPoSddwBKac4YrtUEIbXDceGZ3dW5/z4mdUowPoc9Xz5FDmpPf7zo6p4i38tLPdOUONa9ge+zXxcfahxabiGbHF2kLbXa7P8qXqpa8MkTiyWjYNBz8iV312Pb9wlvozXhAu9R6Oy9GwS67Vk4McF8MoTlylyFA0nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2Xo1BTiEzYMySYv0xvmi8XAdvLUNqsakJOaorvq6KU=;
 b=Vny2K3eQfqXpLhKSqP3QoHT+aEBfk1Y3XJrpZCzQQQZqJK/YbRq++M4gfkBdvo5lDPWE9KoI3U+kyIVRSLZy879rBNJrG+9LiUv8a5TARm4+c0nU5PflvsDncmZRIIpEubdlMaQBzyazrpdMQgTe2HoiTfmc6D9Cr/Euk9dB/Z19T9nRoC/LmBVlcMX+cJMvoXW4dcFX73a4+q8BEiEBeXVZMZcWutf73Nc30vj2QmZSg+0kuY+0Zci2KozKeU6j4mNZQTN128Jvnz0L6zkSag3rDLmGTwf1Qyio5oMsn1z6Qguqoj/17QNdCIqHjLauryuC5JU8sMfB+ax6Pr5kRA==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA0PR12MB7601.namprd12.prod.outlook.com (2603:10b6:208:43b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 17:58:55 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9745.019; Mon, 23 Mar 2026
 17:58:55 +0000
Date: Mon, 23 Mar 2026 14:58:54 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Leon Romanovsky <leonro@nvidia.com>
Cc: Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: Re: [PATCH v5 2/6] mm: Add helper to convert HMM pfn to migrate pfn
Message-ID: <20260323175854.GO7340@nvidia.com>
References: <20260211081301.2940672-1-mpenttil@redhat.com>
 <20260211081301.2940672-3-mpenttil@redhat.com>
 <3c0578a9-ce1c-4d26-86d5-681cae4b8200@kernel.org>
 <59d3c0e5-23fb-4a30-825a-d90fd07bd34e@redhat.com>
 <20260317134509.GZ61385@unreal>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260317134509.GZ61385@unreal>
X-ClientProxiedBy: BL1P223CA0019.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::24) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA0PR12MB7601:EE_
X-MS-Office365-Filtering-Correlation-Id: 409210c7-c7ac-4d96-ffe5-08de8905d97f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|18002099003|7053199007|56012099003;
X-Microsoft-Antispam-Message-Info:
	tAsVKS7AYqesTtV2fnMRs1HcU42yp2fElRf4wBX8td6NMkN5SzOFPGMBj+ogVvgXhSmKxTnd2gbHEDrpapu9eSmyzJLt7U4qPEFZh+2rPZurRCt4+eklDp7tL0KmwpXvvpo0MBXAr1CHatNm3h6QqqPdWvVHZg9ZC2XkO2AlALyC2eJt8l9T9TweWR39IPDdFnD/vRSKknS2kYwo0SntvXfNa8WXzsicJmEZ5e9HVF05C8PDVroka7kvjHD3CkGlsEEWTyTzZNzz7247Elw3NIqVWppc6O6FBRSWF1YMcTaurNH2u0J4vqhNeel118eBTchFWsL7auzVuiE3CoOQ0HampLFofJ58rF5F+gyTuhWjcx8Pb7xKRgHT/u5bhFJWsXO54olrFAT+VH85JfEWhlD35/S2diYkOxpk+h/oIznQIWlCGstkGWVpOX2Xo2w+p6YViOxclHmwhhlRDhg9O6rbTBzqJxOsurHimeGWMnrXOigoEYjSJv76pdTSTlNJhDoAHi76lvVhLrWzRlm/fLz6+N6m7XYZJ1O3K8y8gAbu8eL4PhdpfT70tbRcO1/RgRSXG93sSdIfu2dIro8YWJDaPV8lKIDlM9b2oS1OGykOrgOM7grijKs4zd4uv39DOK2Ymhg3ElPekFBPIz4eibwquapUXxwTvFjCEejXWfu5JrkIUpn+Px983pPW/f5Jbms0Zn98y1JCiWRxYki1b5TQ6aviIB1aPtrxkR762WU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(18002099003)(7053199007)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1BUNE43Z0x3bTcraWJKV0haWklLdUg3UGlMaG1TUU9VTFkzRVJUcmg1Mk0r?=
 =?utf-8?B?UTZNNzZvdGxnL3pSOGlWeGYxaGxmZFB6V3c1UkllVWlCLyt1QzlzMVNVUDRV?=
 =?utf-8?B?VytURjFYYXp4bS9qQlM3RzBSeXB6Y3k5ZlJHSnk5UVFUTzBpQmxjaXZsNHVC?=
 =?utf-8?B?bzZzVFR0dVJqM2FwclBwKzIzVWdaaWJzNVFDa3lwMWc4NzNaV1QvanYyenZE?=
 =?utf-8?B?MlZnK01QYmF4QnJLNU03dEVvaFlrelBXTERtYlV2dWtiMDNuRDlueHZ5QnFj?=
 =?utf-8?B?bnc2RDZaOSs1YnBSMUFMY1RlWjZwOUpoU3NnU3RIREh2b2JDQVpiRTNHQ20w?=
 =?utf-8?B?UGwvSEFETS8vNjVrMmh0dDdJd0p0WDRuQ1lDUk5kMGxYVm1ZQm9tamJwQml0?=
 =?utf-8?B?ZS9lMW9Gb21WWitCd3NlVnRqVVFLZlVERzN3ZVlPWmYwUEExSlluZng1cUow?=
 =?utf-8?B?RmVyRWNSNkE1R0ZxL2lhemhuNWx4dGFEMkxxREIrNUlOcWxGb2h4SWVaRG52?=
 =?utf-8?B?K0sxbU5ydmxtdWhPY0ozMUR5Y0U3UzRncG9MQUt4VXBOMExsdk1xaGRhcmJQ?=
 =?utf-8?B?YkI5Q1cycEYyNXRnQ0dSOXh2NmI5Q3B1NktsV21iOE9yNmpVWDQwN3E0UFhS?=
 =?utf-8?B?V1RwbzN6RXl5UE84K0V4REhEV0NTMmw5am42eTQ3TkJPTE1vWTdobUJPcTN1?=
 =?utf-8?B?VTloZFFtVXA4azZRWGZWTFZJeEZoNVVNWjB2OXdHWCtkUVdsMHVqT2hPRStr?=
 =?utf-8?B?TUJseHJZdGljdThJbXhkUzhidWRhanF3UGhSakk1LyttZzloOHJLblVIWXNJ?=
 =?utf-8?B?Zi9KbzRyOC9qMU11ejZ1Q1VkYjdTSVpZQS8wNUZMeUZlUnF0RUU0Q0lFa0JX?=
 =?utf-8?B?N3ZFVnE1OEt2ZVkxcTBjaG5Cd1g0Y2pwaHYvQ1FpSkVmOVNtVVlQQTBGTVBI?=
 =?utf-8?B?ZXJaSUZKMEd5T3U4UjBuMWJ1d3RtRkdLL2VKM00wNlhUMnJNL0xpUW9vUTVq?=
 =?utf-8?B?NXRJQTVLOTRvR1MwKys0WjZKK1JVQkNjUWg1Rkx4MmlXZlZsd2JpQW93SDN1?=
 =?utf-8?B?TDZFNkU0OE9hR2YrTlFJR3Q5Y2RSdE56Z0hzVUhZcC83OW9FSWVtU3V1WjVL?=
 =?utf-8?B?MEo0SmxaS2puV1pHYlg2bm5OUFVkbE9OUndrYXBtd1o3VGxpLzJ0cE5VSk5p?=
 =?utf-8?B?NUcvczBsZWhsOUFvbGdROVhGVTFpRHBRNkVveG5hcUxkSzkvUkNXOG5VSC85?=
 =?utf-8?B?VUg0L3ozUVBBV3hCQmx1V2lpNjVURUFZc0ZTaFNselBEM2tHQzB6a1N2L3Js?=
 =?utf-8?B?Vy9CMmMwZEZHNUlkdCtlT0dvVTIrMDFXbUFBTXJjVDQrL1JDNGY2M2FMWTl5?=
 =?utf-8?B?WHEwZk5jZFJiblhtZHRWNGtvVUlYeWZsV3FPMDdBclN4UVZLbHVKSjFQVkZG?=
 =?utf-8?B?SU1wZGFhOTBHRXpUODNjcW4rVXdQeFkwSG5aZUU4dFFDbmZ0VWxUK29Nekc3?=
 =?utf-8?B?YURPZXJXc2c4OHRvV1djM3l0V2x1amUwd0RydzhjNHNiSUhjeU9rREE2bmpW?=
 =?utf-8?B?WnFiTWtPM21YZXYrS0VZVTFOME1WOXNWWUFmMVdYNFlsQ0VUK1pZZFZWVWRO?=
 =?utf-8?B?a0tVSGlOVXBwcjhHd3hDNjAwclNOcHc2cEZveHFJaTJQNlhKblROalZKMUdt?=
 =?utf-8?B?azRzVjNNMEFLYlE0SGNCd3RFcDUxUTZhVXNoU2tIYXdNcXFxcUxrTnI1OWRq?=
 =?utf-8?B?YTFHU3B5VUMyRSs1NHFnaUhSUFNNK2FZc1EvZHpRK053cThGRCtOMXBvU29D?=
 =?utf-8?B?V3I2REZISXAzeEZRcTRsQmhkVDFPblBFcHZ4ZEgzVVF3Z2VNZ0IvRTg3aTJx?=
 =?utf-8?B?U2YwZ0tIQ0NabVJScnh5ZDcrSGJqTXF1elg3d3NkUERLaDJCSndQbFZ6K1k1?=
 =?utf-8?B?bHdYeVkvOWpxMG03ZW5nMFpEcXJIMUN3RjFvNHMrSkUxOUl2aUtINUpTWi8w?=
 =?utf-8?B?bTZydDBSL3FRWkJFc3FqWEtFMXlqQUZQb2dSZ1JENTcwbkhMNFdka0VINEVE?=
 =?utf-8?B?ekhjN1lBUngxcHdwc0plc3RDVnJYamJUSTQ0NXNQMGtWOGsxdDEzNVhub0tN?=
 =?utf-8?B?b3pDTENjbG1kQzBremxhT0FSdEhISXAvczZDLzh4dHFBT1dmNEMwbUkwa1py?=
 =?utf-8?B?Z1hMdEJQZldtNHF2S3RMZnFpeEhLZWo4eUtkTFhpalZxNkxGN05PblQvZ0VW?=
 =?utf-8?B?ZSt5Nm0zb1cwUVNwcyt2eU8rQzFqbzV3Wng2UDI1d1BmdzBjQzIrcFdIQVBz?=
 =?utf-8?Q?Lj2lgk/6LjWwVqONVq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 409210c7-c7ac-4d96-ffe5-08de8905d97f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 17:58:55.2233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nYwd13NTH76WCPCaI2y/Ult8Z+k9+4atbTJKI6timJzKPuqkzuwa1Sp9tW4N10c+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7601
X-Rspamd-Server: rspam12
X-Stat-Signature: n1s8a7nnnsmc77tri9ouj9was8389i1t
X-Rspamd-Queue-Id: 50E2114000B
X-Rspam-User: 
X-HE-Tag: 1774288739-262196
X-HE-Meta: U2FsdGVkX18amnMTxfzh5gbgOVtjpiPNV74NraXI/FWnmj5SYL2k6dfIHdxajTHmDhk1zUZE46skZxk0tyEChq0gIbc1CLob/7TRk6jMerwXA+yb8CETojjc8As7nS7j20kMTlwK6BZC/5ZT9f8QxV16MmfodcmEU8NHYnx+cTfGiv1vF3NLlWfGEIoQEN+JzkK3jTx5kN9t5djFQ7DLLjdiSuKDpDIAEOzenRE/mkG/Fuv1QU/3JBN7AGWv779sqXQZ6yzaUjI3xPNMfgrld6/MRq/X+/fg7gw7xsWT0+7KrAQsEvvQ/yhge+gF9baod/140pn3eJt8Lc4uTpya7lpfFpXKwP6mE+Ef1ubvuH8wX6fS1CP/qKEQecEzmlJA+mcMbcQTcJgYAeUNJ0PFfSqDnAi+6fGqAXcD6IvTvAcsClkC7t0KAl7yPRGIZzrPui2an1JKgnQBMDiUW72R+OfEEN/8DRfVOEQcthSrEIBAcO/Mr8UxU8GiqnjIjMgRmWIi4cxg4ar3xW1Yva3IcHlwDzhYIijyDqqAxxy65HGffb/sIUKWCZuW8j3BVs9khm4xEU6iPl9eEU3mJGlV/D0z5Cxdmuu37fCf+jHEMQ7sk8e8VEayM8AZ3DwoL/LSfFtr3vE6//4TlZyVQo03waN0dsYgDIyhONTvZ3KDyKC6wMLJnRPlLCiP+zjKtL+d11HGzLicEBlESvwfYXZVZCVahGKi6f03TZGjAb6QeDvt/JDvIx1t++mu8f+oZLt+5ht1/RsLU1DuuMdLNnwPJK0AqwRXBQf96ZbCmIoMOqoVqZVn2DUWivOvpfFT6OEu3TqVeKuSpcUKQ8KMqKdbuvDWdRKfliXGbN6Y3HAvyl5BnG3FQ2mqfwFCg3ygBTb9nOY04y24PBaPmhNprazJd4nQVU0PstqToInwLgaKt6ZBhtWrb8pxDvEWJ2hKVhNKlRra8TROOrsxP/tAy5U
 ht5Rd3ip
 ptGQSxh62WfzfIWR/XLVxlqOvQwBWGEXw1pCbC4Jm6pwE9ijgDf5X0VVbEr2+rb26QNj9u6WHj3vx0FN1mImAVpTSOWE+998nC1xk+BbuKjXHl++WXVCVst69KLcYD3JrR5mQSPMXA3tiEeVPdClHeQWYbSwyFD62Ip0vMGMYfw9qppvK6pegywGTIsalOmA7nS7u8ZkhfjeHLKiG+5m51N5SDVP/GmjehrUTLKWURB+uJb0jVsWeQhQTdt6FFPJtz9U6kpIKQsn6EpnqgCua9jkQUXgSho/wKGOC8IFv8KjSWzLY+9ABv3oerKsK/cGLEFPZj6/8tJim1gVf91ce3gMfPQv1CFcQngHH8e3Rv5zGspO0VB6FdELTKDIUmToe+QZCjcqrB1z0MOwYYO3OMZ5pDZfMTORIjJoP3/9ZdcNasi4557xKpEuyfo36J+TcOCONNMLZYOaf6UY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 03:45:09PM +0200, Leon Romanovsky wrote:
> On Tue, Mar 17, 2026 at 03:01:09PM +0200, Mika Penttilä wrote:
> > Hi,
> > 
> > On 3/17/26 11:05, David Hildenbrand (Arm) wrote:
> > 
> > > On 2/11/26 09:12, mpenttil@redhat.com wrote:
> > >> From: Mika Penttilä <mpenttil@redhat.com>
> > >>
> 
> <...>
> 
> > >>  enum hmm_pfn_flags {
> > >>  	/* Output fields and flags */
> > >> @@ -48,15 +50,25 @@ enum hmm_pfn_flags {
> > >>  	HMM_PFN_P2PDMA     = 1UL << (BITS_PER_LONG - 5),
> > >>  	HMM_PFN_P2PDMA_BUS = 1UL << (BITS_PER_LONG - 6),
> > >>  
> > >> -	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 11),
> > >> +	/* Migrate request */
> > >> +	HMM_PFN_MIGRATE    = 1UL << (BITS_PER_LONG - 7),
> > >> +	HMM_PFN_COMPOUND   = 1UL << (BITS_PER_LONG - 8),
> > >> +	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 13),
> 
> Please don't add fields which are not flags to enum hmm_pfn_flags.

If you are adding a multi-bit field then use GENMASK not shift

Jason

