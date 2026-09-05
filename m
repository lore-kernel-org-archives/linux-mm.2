Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C470C624D6
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 18:05:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 608A66B0088; Sat,  5 Sep 2026 14:05:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BA0D6B008A; Sat,  5 Sep 2026 14:05:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 481B26B008C; Sat,  5 Sep 2026 14:05:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18AE16B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:05:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 16ED2803AD
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 18:05:24 +0000 (UTC)
X-FDA: 85180485768.12.4C63910
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010029.outbound.protection.outlook.com [52.101.61.29])
	by imf27.hostedemail.com (Postfix) with ESMTP id 47BCF40006
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 18:05:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bKuPv6dC;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788631521;
	b=pk1Xz/PGOf7tcLHXcrOByp+HPW7V7XzUIc2USPJHNYM+laQyINiqOSIFPjMQV9996+OczI
	SFrbSwpWQWxxuyVIp7D4m1+50ybNVFCVJblw7DrkBToh73xSLWQeMQpu9/9MDU152JCA3W
	D9OApe0KbSQ7OZSOHg8Ai12f353Xf24=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bKuPv6dC;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788631521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K2mWRlAIKQZcRyeUUayxPmCpgpnNtOu3g3TGFuv4o2E=;
	b=wrcY85X245u0uovmGK5d2KUCYISDyGpPgKkGC4npJA9dOocxtN2OwqSzI4XWytaZlLUKtE
	DhPgAk7QKEeOppcvUbkb9VqHpw3w80/bfoL/Hwzu1NFswon+jFkAyJVVX0DNQpLwFHXuPe
	M02EcZH1xoiyxiIJ0WAnbR37AVxv7gI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bZHVolYJI/A6ZAhWPrmZ0i+7dIicAsd1bTdNYZQEtrrmzFCQ4tYT6dtCfrixC3vpM5XjUXp2jdw970CpAZlQjiLp083EqkDSE6NaYILPs1ynPayp8AiyHw2ll9GX65Nox84G/WHnkKs9oxQDgE1BtrKHVPsja/gga578CK1ggloLDUzDFfdnGFxuYOSXurnHk+SfTIGFmU755OLPB1qmiWyx1sxCq19QURMHGJun+wbMIu+rHyCWwUbkyBbP7tZRKhPdz2Zi3Ofc/wp1oE40qRBjpnDQKMUywt9xZdTkFsR5BPuHhfZlqkMq4E7nJQypiZWTW0ANvXBHcEy7z0+yKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K2mWRlAIKQZcRyeUUayxPmCpgpnNtOu3g3TGFuv4o2E=;
 b=eofIQhntZ3k3heBvv5me8KpBtbLHBG7eACSJjkAObfEe2Q9SuPPP1vRuRvu0CVkeDXVSL50lPJ/iuPCDwmgR1hib7dOq5A1j75QZbdISaSoFIc/FqKi8A7D07+aG7G9Of3I/Oc2DsDCzkKVI2VHlVORm5bCRT/5JGk2jRXEpBD/2NEFz3BCYWtAcHSvV8soyH7qDhupbBfDIcAy9emxbvqP91kpDscvYe+OSERy73u2hyQFUzGzeraChPCTdgAhBtWgHgLnbO2F6VTEtFc7AOl7WnV8vP1T3HicUerB4BG513UGUrdK2oENEj2FNZOW6kUUaC+18RxbX//9qUMvgrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2mWRlAIKQZcRyeUUayxPmCpgpnNtOu3g3TGFuv4o2E=;
 b=bKuPv6dCavM4NWv5C9dWXly6CosiB4ksd6fmwGu1yFcV3x9Ufp1wVoGSiNSy6g4wrc/91/LM7L2+xzycVm664AKVMNS2mx6lVutmSkQ1Y8bD8myuQrOn+9BlMTc92PbSPCTCGY88vhQOHxVG4TFfN6pOquDaGXNfkQLPoHAweLGqEnIVjPOPNhmQCOILWZPWVAgRadpzu0sjadqw9NDJA+DRCdVp+HKaDu5xewQjGIwFlQjpUqKflyQxRAkftmHG4HcQ8XXYIp0HUehwk+F7nT6zzroPfz+8lqWLs2lkk3cyTlvEIZgzgOLUriPFdRCQseQ0j85tUDPmREtJNVqUiQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CHXPR12MB999246.namprd12.prod.outlook.com (2603:10b6:610:2fc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Sat, 5 Sep
 2026 18:05:16 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.012; Sat, 5 Sep 2026
 18:05:16 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 05 Sep 2026 14:05:15 -0400
Message-Id: <DL7KYELLVH5U.Q3PDS544DL5S@nvidia.com>
Subject: Re: [PATCH 07/12] mm/collapse: name the per-table scan reset for
 what it resets
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <kernel-team@meta.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, "Nico Pache"
 <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain"
 <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang"
 <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Jann Horn" <jannh@google.com>, "Kiryl
 Shutsemau (Meta)" <kas@kernel.org>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <cover.1788533997.git.kas@kernel.org>
 <ec3d193817dfa5d0e4fa2f31642c066ebfdd3151.1788533997.git.kas@kernel.org>
In-Reply-To: <ec3d193817dfa5d0e4fa2f31642c066ebfdd3151.1788533997.git.kas@kernel.org>
X-ClientProxiedBy: MN0P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CHXPR12MB999246:EE_
X-MS-Office365-Filtering-Correlation-Id: 24acf5bc-3a15-4e68-a1c4-08df0b783d37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|1800799024|376014|10067099003|22082099003|4143699003|56012099006|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	Tn/TtsqV6cqPj7HHAnfNDO4tBGlUBXTSC1cGCNreE/L6Xd06q2eFfhh9R4QPQwi5vlItRbLPh5wu7l/fT2HG/KjH+P9v04hWbu3LbWjVOC7YzpWEC3JhvAP2oc/gbQbzmSwlcgVFL7wKYHQ2Kv9EcLSE8i88vdZBw9MlSAncwMG5mpR/zQB1wIWGXSivT1DICX6t7LjSrH2DNrU1LcKB+n4o4ccOBuRvLjpFD8Xt1L7LZzFf77vzMvAZSUgDDxfnml/O0xukaTNV2tWiRbrGVrE5cCb4uB200PUvVD2G3t1jsMrdpRYjDzaU54ALlmC43C4I4Hfjzjpbp0EwjJVCqrT5/Xq17SVYTtRC9RQ7LKHtd1to/3Tc7hUOtGK38qIUuSTIMtve9hSQMuHmbi3aQJ+4vIF4FXj/vHkZxUlrDZ0m/0MxDV95/ReWIxFCtA2pf4CKpffZUJjli9yhJxou7efegO2kZgQq8C5+4GwemhmvizJIRCHzvzctydVt4i4mXQB3wwIngh3REToD0QqQRHDtPFd9J3Bwws6v3pG6rucVojli/C7GDMR5lYiSNNEk+TQ9Hg7Soh5HgpC0ADBkuHmxjsTOrQM4yxdsq1/IPLATb+hRqJB76tuyUp3SnRmBsaIrtnR7U9wvbjYHoBfNB1L6c8R5NFTMKYR1Q21//P0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(1800799024)(376014)(10067099003)(22082099003)(4143699003)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SndaT0x6RXZPZEM2VDB2amhST0x1a04zK0JmWW1NWTVjcjBoTUVJRkFnQXdE?=
 =?utf-8?B?U2pUczhPUjlxOURmMm5BSTRXeUl2cTRNaU53K3phM3dhMUNDNkhVOW1Ma1ZL?=
 =?utf-8?B?dm5CWERoVkVpa3kvbk5TWFhNUVJyd1hmbW5SdVNndXk2Z2dNNjY5WlN6blpG?=
 =?utf-8?B?TU0rOXhRMENNRWlsUmFBU3o1bW5JeXVVUVp1THRDNHlmY3pzQ0lXL2FFYkFj?=
 =?utf-8?B?OHJGdzEzQndIUzBidE1BazlWdGRzeDczLzJGWnRqcjJTL1JCcGVlMmxVdWZ2?=
 =?utf-8?B?azRUYS9mOW91cVRwZitqbmh5bmkvLy9WSGM4TzFseUJSK0MxQWxFME4xLytm?=
 =?utf-8?B?THRzQmhQbEtwTWRDOHltd3l3U08yZzFRaHdubUNvNGFyTHNkR3kwTDlhSjZP?=
 =?utf-8?B?cncwM3JRVU00WEhMaFcyREx5Q2Vib1FERXpna2wyd2VWZFpJRnlUTFhPWU5H?=
 =?utf-8?B?ZlhmdDRNL3pFWEJtUmNVc1Z4SVdDVVdWNlpVSmpveEV2aVBYL1k2MEZWZHNX?=
 =?utf-8?B?T0ZvdWdBNjliRy90RmNjaDlRZmNvZDlTQ01XcXB5NjFwZHlNNE9SWlVzdHVJ?=
 =?utf-8?B?WFNCVUJBMUQxWmVYc2F4RFpVRC8wY0pvM2w2WlBKamxFWHJBRkxJcEd4YzFY?=
 =?utf-8?B?VG9aTkZHTUlkNjNFbnVnajFYeEQ0MEd5N1FGUVl2Z2R0dXZoT1psK1IzNlQ0?=
 =?utf-8?B?WTMvcVFTdk5xQVNFK1BFSUFycTFsb1p3c1ZJL1YrZExFUDlMMHpWMFVOVG0x?=
 =?utf-8?B?RUlXTkw1OTVLelpaS25VNHlhb2NCZ09mV2l1S2VQOE5qK2RPK1U3TFpaZmFu?=
 =?utf-8?B?UzlxazM1VjhUYnhGWUxaN1dtQWhJYnRQVXBCMHNwNGJNeW5reXJkMHZQSTBh?=
 =?utf-8?B?eERxVmNra2lWNnBUNDlZT1dERGRjajZUelkwdGYxSGtTRXdRbllSTy9NSnBM?=
 =?utf-8?B?MHlOSW1aY2t1aVBQaVNiRHJpVTNORWJ2ZkdwM0NmbWtnYlJPMXlUMDJDL3I5?=
 =?utf-8?B?YnVLOUJsYVFEWi9CVFd2SU5oSWZIZGpaMEJ6VEE0UEttVHQvSW90dW11ZVBk?=
 =?utf-8?B?blRNM0FLYmZKS2hYemkzckJyL3JLdzFScjVaMCtmQ1FqN1JCRTdReW93bVdn?=
 =?utf-8?B?Q3FwN2hGWndTWU9uTkhzdTUxWk9zNVU5Q0VsM2xJMFdPclZpYm1qcGxzVjJj?=
 =?utf-8?B?WXQ3aWUvUHBJTlIzYjJHSlFHek5kcXA1Y0ZCWHVpMGNIU2Q1VUVPa09pWTNX?=
 =?utf-8?B?cFphTXlEK0RCWWlhNlJ3VllEcGdZcjEzdUxWbzBUdnlnMWNCUktSZFlMV1M4?=
 =?utf-8?B?dExML0d4T0pSVHV2a2lMQWFJNGxVKy9JTThxSS80bEgxd29odkZEN2dxYWJj?=
 =?utf-8?B?OU8zdjdyWlAxeFYzb2tNNml1b3U3L2VuMGFmamVsdXU1aWRjOXlLSlF1cTQ3?=
 =?utf-8?B?ckJHNnFuak96bm1PYUVMa2k0bC9yQlk4OVZwclYrUlhqTVNhMTNwTDFBRXJT?=
 =?utf-8?B?cGtLK0N5ejAwS3JuU0w0cU9DY1pIRFNXYTFSVDFBaDdkN0RzeUJINXVNUjBS?=
 =?utf-8?B?VFFuUWlRcUJLZDR5bnBhVGFhNm5lTGpOaXRXNFFxKzgzMERqQUx4cDJqR2pr?=
 =?utf-8?B?aUducnAxcm1vaVpkTkllZjNZcjdBTmdGZzZFL2NCNERxemNCb0ozWjZsdis3?=
 =?utf-8?B?K0MzKzdwSWxCUUhCZGRsQWRSaTNWZjBNSTkxRVAzWVpTOWhOSHhtRGM2YTJV?=
 =?utf-8?B?bkx1RlQ1N240bktyc0pLdDA5eWhlYXdTTGZCT3VnY0dONUlwSm54bkZEeHY1?=
 =?utf-8?B?T1hGY2hlS2tXWGpLSVdtcGI1dlJCM0JEOEZ1eGN1M0s2Rk45RFBadzJhZytW?=
 =?utf-8?B?ZUdjdjkzOWhhcEFIc0gvTDhvczJwdXFtaFpEYUc1YTAwWEFZc0NLUVJMWTFN?=
 =?utf-8?B?WWlTSndBcmUwK1IrTlpHSHFpY1FjcFJZUmNnaldYbFBKUDI2bmZDM1I4Z2RC?=
 =?utf-8?B?V29OYmlOZHlVZ3NwdTVYSEt0eDdLeVp2MEVDVU45aXhRc21CVzRaNFFYMG1z?=
 =?utf-8?B?VEF6eEpxNzlhV0VpSm5INXpYcjgxdEpVeUhnekFqZUZ0eEYyeWIwZWRObG0r?=
 =?utf-8?B?NXNvSmlFbXBJTytpd0VMcTZnWGxDT2FJNFh3eG43MVphWUU0NFgzWnZCMjMw?=
 =?utf-8?B?TmJHZ2libXZBQzVGaUkvZERTeEhwZUhmVXlJaWN1UEFPOVhObWJHZU9FMjV1?=
 =?utf-8?B?RG9nUlo4SnhTdGxnVngzMmVPdlhSUklsUjV6R0hvQlpOYXhGTWhTMW5mQmZu?=
 =?utf-8?Q?p7UwXvOzcJ3rK+w9jF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24acf5bc-3a15-4e68-a1c4-08df0b783d37
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 18:05:16.2754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GJqy1lgvaiK6t1zFtJSt66kpPCNV8WGy1sVdtvQEQTWKMVgkeLdAe5B7+Dl8gf9y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHXPR12MB999246
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 47BCF40006
X-Stat-Signature: c791k4hmgtxp4w9e1um6cqgxgjnoigup
X-HE-Tag: 1788631521-111877
X-HE-Meta: U2FsdGVkX1+B8bKmk6sgovl9DeErZQQbRAwvxA9FAjesoK3zfiAnmZDDq2+tYSaOM++uuAbhdwE1n6irma4JDf4rS4/zA4Hev6/oYJ8un+URvHXk6OGVGWjCGJxvAEM/1cGTfcyVSYPvoQl+mWKb+ZM2iWlm95xiwshI0AnElLxzXqV50kSSEwVWG1eFCTRhX+49GX/E4lpO0aeIdSp4FJPoq8/yBVTFUtCcn6MXMFDqaUQKxVQo29ugrx5q7TCvo0FI9M+ju2QkOQZHUm6IX5h4vQj+4ojqwJ4AZrBhX/Vfrj+l2z1vqhpuI4C2xxtlzMFU2tL6kW1YXjEldP2SC2slyKFwvFlrRey3g9oDuPBPXSfcZioZQwdvH59ffvqX0T1BoHPuJPWMz15kAcnOvBR4HORContrHYhlQbxigtBNqtZj6iTanVS4USe9vrb4vBaTXIajdz5x32IdD24GEzveO++bOnpS++s5rVTU+gCMgpyflY/Af+H9oxQrYXkl0admbjL/tXhJ6NIljjvorku0Q3PDUKcsr9V9GPGZ/mrAVgrY9NhwLQ5y9Ekbh1eI/dUMoPQGIp0jtENKAYLVCzlL8rXH9xRJuA4VeCMV3GLQ21Vz+90HyxgKVoSqG+x+Zu8If3rhxL1ZXgBFEiXN3yoK82DuYDPH+1aqSKdKUaqvgwYsXPU6RUCtk5tinz7NhP0X/Hz2pQiBsoZ8RESzfQgD2HrOypvfLIK015ycFUqmxs7WBK+IGTqGJGivolB9cizv5XWptUg0oMLzC7UscQ3lrn+dfJ8rlzsoRBreiU5uYpkHZ2jrwqigbhLt720jL84GKQQ12a7L8/G6TjqqZDT6SvWPVpMAM1Rbh/7/NE2QQnto5OJDwvahvU0ame901QlBEoLXLp4ChKc7YGB3/757yvDXFlPYdFtGNt7jh58fk0lLZZv5Y6g7hOdmAPwQLpwoXtJxjk2OXmCzzsC
 cuzyKoQJ
 lfOIA4p4omY3bdmhqq3/4sBsLrJ6rRO5DRkVvNU2N+xQY5cfCP24vyVdPoV7pXjyTZ3EVpHPsHatoFaqV9kDyfJBvdwj1bVpYI/Zx1W2ISlgx4ghbPvp3mBKAj+YrBvgzkmJlfwSQ9VZaWegf2vaXQYdmVFKnYU/Xs2X/qOiDhhnNcb5tw1NLPpPjVAV04ZfD+sVhbq2R2jgnJ31q4wtEJDK0pLyxQQJLR8dcosbrZsIwcnKYh6xwylfcDBxrnr3Rrj6hDR4HLx2CkVnCl1I1jD7niSxtFmhfXzzosA+3RRrGUrSs+SFwxJDEbXgGE72S/UCPG3alocMr11bMfk0X9PNRTJ4NlKSIvsbmP64Cd6iENyzpQ3d7+HWpf+mVfQSjf0YlKPLEuLN9o5kPKO4nd3HgNBR2/J/oWIw+eThJIiUSjQE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Sep 4, 2026 at 11:10 AM EDT, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> collapse_control_init_scan() resets what one scan accumulates: the node
> load, the allocation nodemask and the eligible-PTE bitmap.  It runs befor=
e
> every PTE table a scan is given, not once per control, so its name points
> at the wrong thing.
>
> Call it collapse_scan_reset().
>
> Preparation for giving a control a real init and release, run once each
> for a whole series of scans.  Two names a word apart would then stand for
> two different jobs.
>
> No functional change.
>
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/khugepaged.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


