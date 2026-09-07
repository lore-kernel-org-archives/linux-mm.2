Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B52FC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 19:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A96AE6B008A; Mon,  7 Sep 2026 15:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A47D16B008C; Mon,  7 Sep 2026 15:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90F346B0092; Mon,  7 Sep 2026 15:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5015C6B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:40:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CBACC02B0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 19:40:24 +0000 (UTC)
X-FDA: 85187982768.20.2189FE1
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013023.outbound.protection.outlook.com [40.93.196.23])
	by imf23.hostedemail.com (Postfix) with ESMTP id AC48C140007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 19:40:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="hD5aIU/l";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788810021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wdU7bkSCScN2wCEEga1PGy2gf88Z+4+QrkkYu4Dhk3k=;
	b=bPhu1Y++0TBxAmj8Rq5+kuXDUytqegFaPCzP1bzkWPERzOFlGfOigqD22aGHarvw9hP7XL
	oUY77IdJhgaNtqhhOkWZ5xMnbRgu+IRT41egwmMRU3TnOc/8kZXBCNGIuV4M7wb9EDjXEs
	HludWaWNIweWRXA2w/tCj4tAAmPX7cc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788810021;
	b=Ap7gLPOvP7ci1B0LNG1UfuEz/chIKtn0iFo7MEbowHzBQAeXWNtsbk2GnJjHtr0ThLSrCq
	g08S3A0y8ScYD4yrAHpJPoh4xOzk7kbAW0HtchbjIR3sAukckjeEsLrZJhxtF/nTPCAvCv
	Jp86Voy1HSf/B31h4F5jqf1laoi93kc=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="hD5aIU/l";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GyPIrnxp3GqbQmc8GiLKlGKpMO5lCvjnwDArJ35Bm4UZ1QjMuH4L/PS9c/gDZbcs7u+jcobVRKzLJgBuqh0Gw6Agh0SrrUaeGwxZv8E0FJy9lR4PtRXswS+wziie08vr/LaWPTnmsNCArJUigj/uyYUgXOXUT+fpgWfGa/JSOf9er/WeNcSleSTakCNP/Rlr6iia+90K3fnCD1ClLgUINXM4XGAbsU7qjny4oloARhrPkQR9fGwqkLBghWkf5sar5axb9+rNin23h/OEmCvp9tlYg5XO1dGlq969Vr97ebFuPoPUm0lEBq20xWUP4YGMcpgo5aYtGOiDvzKVZMrGPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wdU7bkSCScN2wCEEga1PGy2gf88Z+4+QrkkYu4Dhk3k=;
 b=PVIfjsaNkgbw51YaeLalndp3Zv5RTA8obyC/STLj9W+kTuN+NtC6PUdEU5HKQlwTBpn8OoqDC73HRdjLWC9Ki7yUfBVYUzySxU7GPxYzseZ0eKqNQdQJVMgjqtsOSWp0+UpNhRPAFNiUitoW46S6KLO+TiPBPhdwqZf6/lYrLhEg4nzyD5R717R9oGNItpU49ssMM6ZdmkIukZM9etmmcC3lkqba3aeNJRpvc99B0bWtUVs8KU95bFU2ulaAwJw+IXh6Xb7HmL6VbjaW7LzsJQZIuEb2leJfp5uxP+JzRIv9RzBQfOwtxNp2e+AwLE7Xs0N6kDo724oEuBP6yH1c4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdU7bkSCScN2wCEEga1PGy2gf88Z+4+QrkkYu4Dhk3k=;
 b=hD5aIU/l/WG3domrSf6+TNTIhVuTmdx3O38RSxynIhG0VO3W5i11T0FkA2uReWo8n5blqeF7uj3kn2+srhSPQegafoBMifWg+i8ibVdQwo10NPtrU6hWDZhPa4nNMyWdMWKihvebechlcIAz8CfRUr+ovqla/efgYyrnljDrxj/zwkxcr0jmUh+psqFnXXPiXtr7RkebMM60yWOXI2TnS0NsMnr2o4D7d9EDk19QayyjmG6QScNdJD2DKRgokLFKioaFM0lxtfT4VJoTF1PY4K5uT7EAk56dke9uiX+YUSsP9B7b/t+/GQDUQ/bF4UsVxmMWhD22soqr2ZjjhAcsPw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY8PR12MB7315.namprd12.prod.outlook.com (2603:10b6:930:51::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 19:40:16 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 19:40:16 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 07 Sep 2026 15:40:14 -0400
Message-Id: <DL9C887ZO3AG.956ZEVFA3OHV@nvidia.com>
Subject: Re: [PATCH 05/12] mm/collapse: state what a collapse may do in the
 policy
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <kernel-team@meta.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, "Nico Pache"
 <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain"
 <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang"
 <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Jann Horn" <jannh@google.com>
To: "Kiryl Shutsemau" <kirill@shutemov.name>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <cover.1788533997.git.kas@kernel.org>
 <b01681c3cc945a7f7c3c7ca1de502f7cc0e93fe8.1788533997.git.kas@kernel.org>
 <DL71DSES00K6.5JMVM0IJLPHP@nvidia.com> <ap6Wa6h_4HznOzSx@thinkstation>
In-Reply-To: <ap6Wa6h_4HznOzSx@thinkstation>
X-ClientProxiedBy: YQBPR0101CA0317.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6c::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY8PR12MB7315:EE_
X-MS-Office365-Filtering-Correlation-Id: d59e1f6b-2541-4a23-bade-08df0d17d7d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	cILYqhAflN4MbnYPtiQUkR9WapzalzCrgpXkfXXkV2mwVvcZYnoVkysXJRa8NHetTy+2J2xiKVCAqTMxDxyxzT7jW+Tmt2Db5U/TtndPankDvPMfadg34k9G9hjpHcXx+zgXAZj4JNS8Gliuzz0iYcSGtyb9E+ScYaWLxFqBaJ/4tfX4EMgBi24eVI4mg8xtGxBIzfar2bk7FtGG/7nEQHf4AimXIqiCx/9jGcLKX6bbRYZi18/fCr648cakVMIhMUanKv8pJ9g3Gnbn95AZUUHTLroAamPdDS37xghtI38F4HeiemS9kt4vdI9IdgfJE5/6XySykBN9uWAQhlhPTIBk9RmWktYEJtQx8F/CAYAYNYQbLuEQ848eP4bH3lSlX0AIVmB000C+SlxuKzpdHKV8WJPmdqlI7UeT9ULVO/zhpLGYNJOK2L16pXgFbiOfkaSZTpyWCvCXvSu1RYGc8WVBI5PK2DA2058CpRYGGlAeQJ9DGNxPPuOn7NO8jYr0abUb9/yInC4UxU8YpXQfjDSOQ2JXdHJKmYUXhyS/rT0Tr/nczwCjnMl3ZfC1hPR49nse91lr2otKYV0DYr6H6HU+vcvWveaBATVd847mI+muVOvTcl60g5VN08Gts1QILFjolmWHl3VjSjjIp1mktdUfDIZVEN6e+ZRgUD/t98I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDhnM1pNZnJLdHZTZElaQVpoelpkN1JXNlU4cXNzYngzNVBZcGZaM2FWT3Mx?=
 =?utf-8?B?QWRmVnRvc0tpVGdaR0RXTXFoc1NiMG9xaWxZdmY0elhmY2hPMzExK1piSUtN?=
 =?utf-8?B?dWhRNFdZa0Fod3k0T2ErOGhLakpLUldIbEdiOG5XYWJoQmxKY0ZVSHg3cVF2?=
 =?utf-8?B?S0lhQjV0aWZLWTYyZnU3TWRjU0k0UlJZbUxUMVBKc1ZBQ2w0bHdPSEphcThF?=
 =?utf-8?B?M2Jad1dVK1hDTmVrZE1oMHVLNFBCRURmSlNDRzFrNTU4Vk1CRUNkOHA0c2g2?=
 =?utf-8?B?UHNHUWVQdHpGQk1TNUF1Z1FJaE8vNXl1RUpGM05OaTFwU283WHh3UjBtZW82?=
 =?utf-8?B?ckhjWjNnY1ErQjdDSGxjUjd4V25wQ0VQeTNSN0RSMkI0UHRZTFY2MWpvVmNv?=
 =?utf-8?B?cDZsNFJDUEdqTHp4bk83bnlEZ3FoTjQzVlNZOFRtNk10aTJLWlM1QVFLRUN2?=
 =?utf-8?B?R3dYUFoyUGR5bHIrZ09lK3pFTUVZSGJFc3NGWVlwdDZLSDNiT05OamxHTzN0?=
 =?utf-8?B?VlNQQitGZmRka0htOEFvN2xlcXQxSkF5dWhrQ3ZvZzNqTGFteE5MZ0FqTXBu?=
 =?utf-8?B?OTFvajY0QW9SUHAzUzF2QWRzbDA3NGV6bFNPeWhBbkt2RWQxQmtiM2NjSkxK?=
 =?utf-8?B?cENvV2lzQVlWOVgrWVZSWm1zcThQYUVneVA0bGg1azNOOGQvN0JzRlZaNHFm?=
 =?utf-8?B?Y0JtV3BCNlF1VGQzc09HdXJ4c2czMHg1ZVZSMUFTL2czTjhLdDZjamliM0Nt?=
 =?utf-8?B?NittS1hkRjJmRFo5a2NMZk9tYnBlcExGNlpOdGlVRmx6UVN3d1BnVnJiVTJT?=
 =?utf-8?B?ZWNxVVJoWUNnMC9ZK3E3QUVIS1p0NWQ2SjlaV21UM005aldsV2d1aDBwbUtG?=
 =?utf-8?B?QnlwcUxZQ0c2eUpHblJEclhyMVE3dWtmRWFVTnFzUTlTd3oxSXU3RE5peVdt?=
 =?utf-8?B?amFwZy9tOWlJN3daNkhkK21rbVc2T0ZvWGJPTnJDdXNYN09sMzZSMUFjbk9i?=
 =?utf-8?B?eE1ZZmx6YUdoM3N5WFVuRW11VHZOU0lmWUZ5bnhOY1FaV2FDbTJvR2liQjBr?=
 =?utf-8?B?Wlo3SitJaTVMY09KeTlRSFRYRjJhN01Dc2VHajM2WW5ZSzc5a0xONmlKMFVX?=
 =?utf-8?B?Z2JCajBkV05WOXhFQ3lmTjNjTjVPR1E5WkxVV3FmdktJN21qaUFCUms3WjVn?=
 =?utf-8?B?WWdLRXRPMDdoYnl1U1JlYitBb2xVMkdhMmdFTzlJZFNTc3pSbTZRenZjNzdQ?=
 =?utf-8?B?YzR4cVdXVGpiSGk1WU5qRFpLRmFVK2c0M1JqZWtnK1NLWVRhSW94aE1wVmxH?=
 =?utf-8?B?U2czaElueGIrWjU1RW5mMEd2WjFyck0wWDdmNzFMTWNFVElMdGcvNytXOEQr?=
 =?utf-8?B?OFV6S1RZQVo2ZnF0MElXb1hCK0dVRE5MdDlmUDVmcEhNWThHT3JFdG9SaGw5?=
 =?utf-8?B?KzF5aCt5T0kzNHBMUUhQd3BWYXZrTm9tSUQ2Uy9VUWNCV21hOWtPeGJzbGVr?=
 =?utf-8?B?TTdQTWtuVTdPc2UzVnQvZUFTQjhEMmNvK3E0NlJxWWduQU1ITEI2OXRYalJ2?=
 =?utf-8?B?Ri92RUFWWEZaU01MN0xtWklkMG5XZElsY3B2cUpoZGtFbDBSMUxxeEd1UmhM?=
 =?utf-8?B?UmE4Qm4wMkR5RTc5TDNhVHUzcUZwTEtsYWU0eitXQlNQSEtLRm42V2M1azJX?=
 =?utf-8?B?blZZa2x4ZGN2dGFEcGFsWE1iRUw5MHdqakU2RjE1Y0xseEM3VXQ1QldpNTBh?=
 =?utf-8?B?a1VDWEIvZXJXTmtxeXZlZ0NCN2FlVmRRdGhLK3JnYll4dUJwTVZHOTZsR0lB?=
 =?utf-8?B?OElCcDd2TVUwY05mUjllNitsaFY1M0EzeEJONVEwMHdwT3lOMFBySEtlQm81?=
 =?utf-8?B?TS9oNzJNT2VIWU04LzdtM2h2aGV4SWdOOTNDYUhZclBKekM0UU5jMjBmUXFx?=
 =?utf-8?B?WGdmak5EWUlTcUpheHIwYjB3VVQrMiswaEIyRG0xQ2F5R2o3Q0lEOVhqQmJB?=
 =?utf-8?B?bzZVVExlb1FNNXpkOGNNZEVZL1R6WUFBMWpxR2NVRk1udUJNVC8ramk2Wlhq?=
 =?utf-8?B?eCtDd1N0eGlRd3VLYlJnRHRYZGRYbStGNlBBYVZ3TWFISllXZ2pkQmtQUFdO?=
 =?utf-8?B?MzY5UkV0cExzZGNDb2FPVU1uNDlDWWNhbjFYU05hb0NDMXc0U0hkS1NaYUdi?=
 =?utf-8?B?cVhuQlVPTWhpTzA4aXZ0UjdqQVEzUUdNdEZ1ZHpCeEVjWm5jWjEvdkpUQmZ0?=
 =?utf-8?B?TU9EZk83TWhUcWdmVU9DM2ROamVEZmNEbnFnTDFZa0pqNSthSzdxeTNwYkdu?=
 =?utf-8?Q?m9PgnVqf5NThXLj9ni?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d59e1f6b-2541-4a23-bade-08df0d17d7d0
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 19:40:16.6922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GOxE2hnzgMDbZyXX/MwoWJKfToWGaXecfMTPI2tITt9zVaxcEsNXh/IUWGVp1vF6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7315
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AC48C140007
X-Stat-Signature: bgw8w6aeifhhqdngindqat8hqbipbw71
X-Rspam-User: 
X-HE-Tag: 1788810021-679474
X-HE-Meta: U2FsdGVkX18/47lIU8cD9PrsRsHPzJ5wrhqmJAKKPQ1CSkyJlUa3EYaN2iYpXDP8aVyp55yhWpPTJI+KKfy4K11s/rlZ7KuDmRPycDi4HqL9Aj30FmIt9y7lcYRlQwr4j8sw4lwu/rSYhwPwIdkNz3b2IUnBNwL7Rtv/8kQHVSVrkVS0Lvj49S2dCXJuYQ9g1ri4sdjVbM9PfaZm2cbW77540+KtHWiT0ukJzDzCHZcTE66AfZMx15lIuivoH+2yvqbliDD0L5q4eyl2YygPIZ11JuteF9VZnPiuvgjHbNJiZVZbTvwgCIfOGNhIzDw2+FE0GOo+eGg2xiv/98EH54PwMrezLF4W4pMJ378UyjN66TNK48P+8HaD9QB+CSxjzWZs1TzB+wp6+3XfrfBPHPB7TsSnORjnlvmME9bf125T4UMAe+W3b588xHio0JNsg8Uof+LReE+jJQAuBwN+stYUGO0DrndYnOgnSP8Navn4ug4I3g3LVInmaq01yE5GXXmiQf/NKhIOs8zb1sGXz+hnPYu8vEKVI3NHaaHtoyfGYXcYzciKZ2HMyBHV77PFBd7B4Q7qTGgozylaPALwXmdQP9hneZG4NqNvvyA2F8Q6MURl7fKXuw0WGuJ0CggyGOf0CTJZOOSeUzGFAs4fXrAP7q/CXQAoy68QHbP7UqIxLG4WKOM444IOY7r6tsFHxqfg+TlygYU3BUGacDJIWSelyMme/9AvHQR7lfSKZw6RTwGohyJRPqKK7fLi9I/zVesZE47zXvnrPS55delKrkzo+13n7fb1S7tvNudhETod6lQP9z19OlC/UdBjPukH0yha7+qWs36/LOxCI/nmCkLNYF0IBItV4g0KEWckD0BfF6HfSUoW2X8U8fwoELXkXBW9HPGjrf+TW+4TFVykFoA8RXqgzumfJdSd1Gc1T07n/Xwr8NHdcUOxyxJLaJLsbpKp6PdoGU5AIIy+QDq
 M1kvzDJi
 iyLM2oDx3Re58cxdNf298wBRNXTY21x/znSq7/hNPIvHlqOyBahARxzCHye6NPPoD0GMCRzs+QLqnu40tteGbY+WteCpOFpCfz7DBecEH8oEiATc/M2PHjDGe3HdFBZzE5iHC/fgrB1DFtfatFoPm4KXts26eUlDyibH59tPziHvcJCKBmC74iL7hYU1sY4bs/QWgFnQAnsgaZbIdKDu3SP5Qu4UEw4NJ3wAy/pzKgLVh8tq448YJhELO5/oojwnepwuysWLjUDNwSrXbIbCy+ld03PNaNRQ1Rt56RbWcydQ9RvQZgEr2IJhztbOLqw3rq15hpeM3mDNBWwCDeyOM87USWxaNHXOcQBj7NtQ2SJbc10EvUijAwPqSQZWAMeLs3SKf6mHpEB+VzeYsgAR743TvCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Sep 7, 2026 at 6:49 AM EDT, Kiryl Shutsemau wrote:
> On Fri, Sep 04, 2026 at 10:44:58PM -0400, Zi Yan wrote:
>> On Fri Sep 4, 2026 at 11:10 AM EDT, Kiryl Shutsemau wrote:
>> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>> >
>> > Tests scattered through the collapse path decide what a collapse is
>> > allowed to do by asking whether khugepaged started it.  Between them t=
hey
>> > settle:
>> >
>> >  - which VMAs are eligible, and how hard to try for a folio;
>> >  - how many empty, swapped-out or shared PTEs a window may contain, an=
d
>> >    whether a sub-PMD window is held to a stricter rule than a PMD;
>> >  - whether a range has to look used, and whether a MADV_FREE'd page is
>> >    left alone;
>> >  - whether the PMD is mapped as part of the request, and whether dirty
>> >    pages are worth writing back and retrying.
>> >
>> > None of those is a fact about khugepaged.  Each is something the calle=
r
>> > decided before asking, and the collapse code should not have to look u=
p
>> > who called to find out.
>> >
>> > Add struct collapse_policy for the caller to fill: khugepaged from its
>> > own settings, MADV_COLLAPSE from the fact that a user asked explicitly=
.
>> > Every test becomes a read of a field, and cc->is_khugepaged goes, havi=
ng
>> > no reader left.
>> >
>> > khugepaged fills the policy once per scan pass, MADV_COLLAPSE once per
>> > call.  That is the one change in behaviour.  The max_ptes_* limits and=
 the
>> > defrag setting behind the allocation mask are sampled once per pass ra=
ther
>> > than on every table.  A table scanned early in a pass and one scanned =
late
>> > are then judged alike.
>> >
>> > collapse_file() also drops a NULL check on the collapse_control.  It h=
as
>> > one call site, reached only from collapse_single_pmd(), which derefere=
nces
>> > cc unconditionally, so the check was already dead.
>> >
>> > Assisted-by: Claude-Code:claude-opus-5
>> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>> > ---
>> >  mm/collapse.h   |  40 ++++++++++++++++-
>> >  mm/khugepaged.c | 114 ++++++++++++++++++++++++++---------------------=
-
>> >  2 files changed, 102 insertions(+), 52 deletions(-)
>> >
>> > diff --git a/mm/collapse.h b/mm/collapse.h
>> > index 1c40229b9554..05282eed9a35 100644
>> > --- a/mm/collapse.h
>> > +++ b/mm/collapse.h
>> > @@ -48,8 +48,46 @@ enum scan_result {
>> >  	SCAN_PAGE_DIRTY_OR_WRITEBACK,
>> >  };
>> > =20
>> > +/* What a collapse is allowed to do, decided by the caller that asks =
for it */
>> > +struct collapse_policy {
>> > +	/* Limits, stated per PMD; HPAGE_PMD_NR means "no limit" */
>> > +	unsigned int max_ptes_none;
>> > +	unsigned int max_ptes_swap;
>> > +	unsigned int max_ptes_shared;
>> > +
>> > +	/*
>> > +	 * Hold a sub-PMD window to a stricter rule than a PMD: no swapped-o=
ut
>> > +	 * and no shared PTEs at all, and max_ptes_none as
>> > +	 * collapse_max_ptes_none() scales it.
>> > +	 */
>> > +	bool strict_sub_pmd;
>> > +
>> > +	/*
>> > +	 * Collapse only where it looks worth doing: require some sign the
>> > +	 * range is in use, and leave clean lazyfree folios for reclaim rath=
er
>> > +	 * than collapsing them into a folio that is not lazyfree.
>> > +	 */
>> > +	bool skip_lazyfree;
>> > +	bool require_referenced;
>> > +
>> > +	/*
>> > +	 * Finish the job rather than leaving it half done for a fault to pi=
ck
>> > +	 * up: map the PMD over a file collapse before returning, and write
>> > +	 * dirty pages back and retry once instead of refusing them.  Both c=
ost
>> > +	 * latency the caller has to be willing to pay.
>> > +	 */
>> > +	bool install_pmd;
>> > +	bool writeback_dirty;
>> > +
>> > +	/* How hard to try for a destination folio */
>> > +	gfp_t gfp;
>> > +
>> > +	/* Which VMAs are eligible, as thp_vma_allowable_orders() spells it =
*/
>> > +	enum tva_type tva_type;
>> > +};
>> > +
>> >  struct collapse_control {
>> > -	bool is_khugepaged;
>> > +	struct collapse_policy policy;
>>=20
>> Can it be made const since it seems to be read-only?
>
> Not as a member: khugepaged fills it once per pass from the sysfs knobs,
> so there is no constant object to point at. And madvise has to
> initialize it somehow after cc is allocated.
>
> It could become a const pointer to a struct the caller owns, but that
> adds a lifetime to track for a struct that is written in one place and
> read everywhere else.  I would rather keep it embedded.

Got it. Thanks for the explanation.

--=20
Best Regards,
Yan, Zi


