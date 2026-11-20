Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53BCD60A2605
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 00:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=neKemMt7
Received: by kanga.kvack.org (Postfix)
	id 58E176B06D5; Thu, 19 Nov 2026 19:07:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53EED6B0715; Thu, 19 Nov 2026 19:07:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42EDE6B0716; Thu, 19 Nov 2026 19:07:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 123146B06D5
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:07:20 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 81932160CDC
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:07:19 +0000 (UTC)
X-FDA: 85453557798.04.EEA7675
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013070.outbound.protection.outlook.com [40.93.196.70])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7339D1C0002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:07:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=neKemMt7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795133236;
	b=P6LFtojyfsNVPa5es5kOT5ig1J9K5R6dxnAWXFLHFVkxy1eHczJlvKTRk9Zf75hpDxtGJ1
	TYtWe5refY1nZSWsTq4u0nDym7BXZKUW/+OWaWv7om1e/LIJBcXnwjTo/3RwvjOn1htDeV
	cWoJxYHeNnCCgzAJgUsL5a9q9kV/S68=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795133236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PTrogx8b0HXDtc/pJASUwz9HN2QUuwrhEYRQpwhH2EE=;
	b=Ad2fqWHRupmW3PxM89aHAXwZUe3mT0N7hLvMfM9Kk+SPtdCh7IhfhGjvfvRMr9fSGAKyuM
	4RqsX+9kwqIdMn7i9FOgLsjjLsQME2EjreiFcJy+42kVYgJIVSbjRLSlwEH/kRRogcfGK0
	U3BV9HBYRE9hB1wC0MeC/eEPkCYlYU4=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=neKemMt7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bYR3gSMTgH5wz7SwP6VLbwu5rcPz66cdbGtvDa9s+yuNf6JRNpGt151m86dzbF9xaKOswsNkM41t2kVLUGVP111W+PfEAcfSIAffGe5QaIz00zOMWaegTAf5pQIemqzkzPaQlF/TrFEQAhDGlQb9Mn+TERdgs4855p5Y3C6KYU46fAMI3PyeaJfpZ5zYtDVRRtpa5T9qhDh0VHtYgC+8AueA73fxQE1amy8xHFjksORAv1OIgm86oSkxYbxA/r8hqxIhYeaKkhtXaZow6LqGSXB6kr/P3SGujAQ2fYZWZ4WmWvWskJyLkyjUmiasAsPc1kZrqGYjCVIeaO8kxqW4Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PTrogx8b0HXDtc/pJASUwz9HN2QUuwrhEYRQpwhH2EE=;
 b=gdHThVInlbudjC7LuRUDE/MC3txE0gTWxxC8GFa+FTtOx1ek8DB/zGZQEeEave7avtIMcoSJv+4R5C7JJOCarPDs0PNZjKe5/ug8qjW95lh0rWssUtcjeGueH7IjLIJ80kHR5lA720cyCwXL6c2TyZL/ku76bi6Fb3xlnkH7LwRlop+8J2PdD6qM4Xv//358ZtVNxLA7mh5z08tMitKRRoANOec9fgc7VnMfF/qCcWwnqmc7K9MpKK79j4pR5iq9JZtWWjREfriI7GnzrsCT0Mj427RIH/RQN1Wbqa2OzqbWkdor+mSOv+UPT6AtvxkDODcfmmcOdT6rt5wWsJMiYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTrogx8b0HXDtc/pJASUwz9HN2QUuwrhEYRQpwhH2EE=;
 b=neKemMt7s//9ikV1y3MI5LHOq3JKA+7dDc2vbjOxDFzo1SqAh8Wngvo1Sqo3YaLAYsDuxcIxcU9IimE56CpSlyeGpMnKyGik6D7S6Vg+g9itOT7jo23+SAgkpWo14p6DxtztFDBb2LaqqQOV5ON3X9pD/qc1Yiu5KEisnr61BYvHesjNgGkm5AihSQReE9w6hyUx+DIsvZq7QJO8DUhSuf6LSRmwtYhW/Bal1OhzBc66SBed4ZOhciT7CjV2bJ2s3ICX3pskQBwIy9SDeajXma82szBoWTATMFr9mSljF0YnqGPYJgJvuTRygRWPdMnXcO02w9ZYM8MK0ws3SfzvQA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ5PPFD5E8DE351.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 00:07:11 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 00:07:10 +0000
From: Zi Yan <ziy@nvidia.com>
To: Nilay Vaish <nilayvaish@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Balbir Singh <balbirs@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Zenghui Yu <zenghui.yu@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Alistair Popple <apopple@nvidia.com>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lib/test_hmm: fix alloc tag leak when splitting
 device-private folios
Date: Thu, 19 Nov 2026 19:07:08 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <18A2667E-073E-404E-89FE-7C8DD5E1B3E6@nvidia.com>
In-Reply-To: <20261119233119.1721789-1-nilayvaish@google.com>
References: <20261119233119.1721789-1-nilayvaish@google.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: IA1P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:464::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ5PPFD5E8DE351:EE_
X-MS-Office365-Filtering-Correlation-Id: a75774d2-71b5-4f49-ad77-08df469a38f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|22082099003|18002099003|6133799003|261009223027099003|56012099006|261102130727099003|11063799006|261022075727099003|261028144727099003|261021121427099003|261022105027099003|261102123227099003|261026121527099003|261021123027099003|261026140227099003|10067099003|5023799004;
X-Microsoft-Antispam-Message-Info:
	74m6o+44DO7ZtJr4HS6ITw3PaBGzc76enUw9Ip+N+Jj6o4Q1qnw/Ga30m0JJmcTGawWk21CU8a4O4tvHbwB4JbWvV+sc0W3GmKBsDrlm2j8Y9wWQhkWSm8FjrOVr7oqd81jHxfjUwppdrvSOispsZORaI6N917B2ny+UZGGIb2nV4fC3vwqMYPgUk3qmBNHAF+pbZHW2GRiILMEWEhidCAg6zac2NyLjDT7z86/FhxuDSbKgoRfBft3i84MGHE0FQywRkuypJWCsWv2u2FALf2e1pZ9ok8ea2IeiyoSnFXdi/+xpVa8sX9LqRPLBZe8f46UuW11s9O2bJIhr1vSS/EFQ+ks/Lu5srY/vxXjb4U/VuL+DtMaSNv+D2OWFa3QynWKiSK0Wcv935YVeYZ3UVMvgVdHslhUe9lQ4fxxgS3niavUsqxeW91VzM4b9VFc23/MVoXaHh4AGKZMxsanjMKq/ir6VSuz9WzA93tRvuNh085dPxlEmmV2unglbkCRMlqoL/41CnFHLpqSLczUARc2mSWkP4VkUJtISPTSRtrpYaS7SRIleWvZMkFsGYRAVoKQX1HimctZYdEf26P4NXyq4mdom3jFnyM4KZLfSrZw2GTsDZZ80EIUKBlrQDBaLf1gDZv3yhqtHPkPCGpp8oj8Fey+CkDt8DBF1VLVqBRY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(22082099003)(18002099003)(6133799003)(261009223027099003)(56012099006)(261102130727099003)(11063799006)(261022075727099003)(261028144727099003)(261021121427099003)(261022105027099003)(261102123227099003)(261026121527099003)(261021123027099003)(261026140227099003)(10067099003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YgBdPD3t09MHnx3ekFVzWMYRIuknkw8aBc9MFcB9f5P9JS5kbQ4T7YB9jIxh?=
 =?us-ascii?Q?dNohq4PKz5lijC0IzGP9cxk1ML9S0z13qWqxrRbnTFgMcstdd+nZqcdrpxFm?=
 =?us-ascii?Q?rnUSsvWWo/xIQAoWKq4glRKEYNH1R7YWS0cEigD7qYyzRGoHIMdu5RoYd4Sj?=
 =?us-ascii?Q?33d5sBDGIhy8ubjukeqPaIzvGOJVqmojm0kP9voI4tTnGLqn515TW/kjCe27?=
 =?us-ascii?Q?WeBejcqLpeiRUIbzrifzV0TYd1L0cefq3wx+sgBfT8eEQdtjCwybXYjyLYSP?=
 =?us-ascii?Q?lkXXO5nIvsYavHBzralk2IujA02MpfXipc8UWJNcC6a2Ch4eyv7q2W8/zSra?=
 =?us-ascii?Q?bc8vd2VNe5DgBNSJXTmZAzSoNao61q3l3/+hw49ZqTHImzv/256EioA5L4s4?=
 =?us-ascii?Q?C/3D1XnpNur9ZXICItJKiuOAr2OeoMTsFwmsbp5wt/IwCwZ3a6oTAd8Ll9CY?=
 =?us-ascii?Q?c7dTT3Lf1+gM/cmTU8RL4kEZs5EQfGPwbgIhY78hI/dQRg/Q2lUhifUmA0lW?=
 =?us-ascii?Q?sIWOpnp6YKp6+rrc3BD+7y4yt/SfCnJ8bqpcsELTLi9j3yUk01IbKNLdKilM?=
 =?us-ascii?Q?/LyREFk2Kr3Phbst4X4GYys/45eIo5BaVRln7H+oG5Rop1B70ad+WWDa8Iv8?=
 =?us-ascii?Q?JpBUsNMFVPncr0tq7ThmLDaNrXVu6mn00q2aZTLLyEOEk07PyXZR/sx8WoJ8?=
 =?us-ascii?Q?OM8fkyNTiBrdYyBPypenhJopOmpB9U4zv06JRK4t35U7lkEVrDmaGsCVlf2L?=
 =?us-ascii?Q?qT4tfoIDPol2MKLTkRY7rZTuYJOlk+QF5b9CxJ9OzjJo/csNRQAcq0q1ioRo?=
 =?us-ascii?Q?jKz4u/8gF5wrpCQO8cS7xJU1oMpOda8+S5m0q4xq/xRLMEHyL266E7yVOb2t?=
 =?us-ascii?Q?+YKhZ4NpENQUxA4Zpf9tDFuuvdvVrTYW94/2uvQRPpj6Y0NEecJNxE6GEl00?=
 =?us-ascii?Q?rPpbvpQ4+jpeVq/XgvyG+d3l+Yy+JNBFRDyDpb85kEOaR4KLanqVw8lKbcF1?=
 =?us-ascii?Q?kSqKNfzUzqNjeK+vNTYAt40LYs89iqNJvvSMwTCrb+XBk7TjhRKy+GN9zNuS?=
 =?us-ascii?Q?YSags4GZVh3QMkDOl2gYE+VrcSezTP63SUWQeLXVjuvUlivUp580EPoLWfVA?=
 =?us-ascii?Q?MAKBklv5WKVtKhczYSn1ZlcUwQ+XRic4bK442MA8ql0SPCD12uWTC3SzrOBb?=
 =?us-ascii?Q?76VjyfLqBOb4bmY/FB2CIty9JgFMTr6ss6YfIObl5IaxvathEhVpiHhadFbQ?=
 =?us-ascii?Q?uQscSeWGXqC8wusRAFLk63GUMaWIAq+dUQqpa4Y35D5qHmY1NDHiFdC5tZSp?=
 =?us-ascii?Q?jmzkJR/jH0AnOMfqfkxuTRO5BBaSeukQm88f/vreiFYAzd4SxXYDC8ufj02D?=
 =?us-ascii?Q?Jh78OASvRnibgcVlVBA4ReP1ubjU17D3qchK7Svrefb4UuLIkUi07nSM7dak?=
 =?us-ascii?Q?Vd6tWw0DuGsM+f3qfSWtomd7BV4g4CXeMqOqmvTi//17Jklhsnj6WoYTMms3?=
 =?us-ascii?Q?KnCgJotvsHLyxGaRmhT7XVXUEvRUC2SdbPFy9JFbWkQlfl6TfHIhH5HwhsXY?=
 =?us-ascii?Q?1h7fUb/3YUcxjGcmnwUJD/NfAE1cVEjynU6kY+RDkb4NdkrXGEV8glNipDNd?=
 =?us-ascii?Q?kmxduNimUJ14nVnTn8e/JWVIslpRFgxWdGb7ABSIqoxQTOR+qseGgC0VHoTh?=
 =?us-ascii?Q?dUhVvRYyRLCR66NuLi0v2qkhPtju//mFiXv6eBGOMqCCSXQQQaRq4shmok5Z?=
 =?us-ascii?Q?nNx1QjvuhA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a75774d2-71b5-4f49-ad77-08df469a38f1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 00:07:10.6615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qBUZbvLLkR92NGKE5p4Hbo9vSP7tfdj3KaNm76g35jGJZivMAMG3a3qUKNSRSSiS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFD5E8DE351
X-Rspam-User:
X-Stat-Signature: nzmbrr447hw7bs6gj4r5xecf5q7pzdqa
X-Rspamd-Queue-Id: 7339D1C0002
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795133236-518294
X-HE-Meta: U2FsdGVkX1/0k1CjcWPlVUs09vGjzHDLOzdp0pgu8J4FA/dO8+RgIpifF6MTzQ5Y9jbIJ/+RnZoqUkTptd79IpvD1IR4hgdRknyWiI3T+QFB5qvXnvziUpKktA0yiIiAYvwciGq0Mz4f4AxmQdOKVUFJ6CvJZIJj55+B6LXgMLdjKwnRJUFTLD+81RV2+rcx9/Zmkily4AEKpVLWVHOgLGvU4K3JNsApEqxD8yi9IdLJfI6b2HueiVc2uaBw+U33+hsXuiC8btbRrG9UbFX32bH+C8/D2YHdDlIAlpRMvEzQDDRNlKHZShC4HLf6D10ovXXvUQTckLFKtk2r0yuaUKsQznC1kvpG7BpVEaPb3kC/+U1MOQhDh54oskw5PFlBfcoLNU2E0YdrEd96yyqied4z7P4A71bI/V+6m1+YC6ZaSbEoFI6hNp9W3rB/fipd3yxrABmBQgSw09FcS91X+WDO7psZG+53SJ2FLwJsmzQbZda0yc1Ngi9QjkRBs4v344jLT8KhpBkBTlDkicXB0zBJCwPVknD+A8a0urEjs8EVdrXrKvDpxTTurOdP3N3eN6QMc/xmFZy0aCdmKa1Vn7A12tlDF2TGS6tq1V1URZBqUd5zZ60ZXFpe3Ah2rVpe3OwyeswLMEFakdDqeh00Al1mU0v8yO6GagMoteDjXvfOKRONqcT/J7T42D8OpXaWZuDxqj1zQPT2mUV0+JvzcxSw67WgidpAUsdx0CqLjXQknkApyeFCbNE5h06V3xsgFaxuVCnXi0dtF4HzyLQrvy6SjuAtP9ID+8ufkRmQCXh3yChdKCIJHn57gZxnuSKtp7iSB23cv8ldlRhALuFmchUvuhcdMcMqHWK1F4gQsFJblWIhVlJUZVlIAPKqDC67b7lFVw6tZru4/EfW0qVxX5REnoTEPZBGU3c2ua9mtuArPXGlTn3GthnjwHuuN8pxSCWyUXzyHDApaozVT8z
 DHWfLoFe
 XFJc9p5eiUI/HeseZFPG7ABf1wMIX3OWWZnHIT2cxiowQD4SKkfQUc5oZu8f0WW/HO4/wIavwOI4ohfzWW//jXEhORj1GKvuVWKTJ8MUESLz7B0VriJ8Td0BEDQMm+XsopI3chE4Cwp2y4TQFdRK5nos7g42DB5A+dbR8oZwFjtC/brvyPiIXLK9EVNerPWrE3ZQ0oQ2Mv8fT8CV2w/mhyFur9gLTQJvc1d+ynpsHyf1v4pzL7NNi3e9a69P8/eiARqQpEEa4CcW0QmMoWiC1+zw671JHI9UgDRArylHrl0lqePPLHvTXG9yvwWHCYDvwQnezclUz0qpE6R5eBQD+t0WIp8QGg5pLlKEsm8OTFvrOm3lkzIVZVjMMy1khsLi13C5InAPr8432T6I+vsvld++jqznHJvLJLl938nX0kXFfT2Zzi7P4inK6cuRvLVTa1jovyS2lwsGTx2eXJc7lBeC/hhqjiOW/WloBGT5SNcRmEabRE1SBqia3M7wja/wfoCdP1F9JxgWDqjr7Jbl7kjliHZuyfeOWw2l8vgVNP1fFbDjUjksKtYPZXErtGMbpk/coMkACfg7B2AqZZtRVC0mZMrEVd59rmc4z5KN4qaLm4iaA71iMlT484zhS/p5aTWWCRYu9pv02Obvg0OVFAS0PVPeIDsuSdDrApKe3oHElJDxbQCEFPxOvQuektd6HIXIYM8lEVj379a9asqpHlq0y/VUKCPUuo5ak
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 19 Nov 2026, at 18:31, Nilay Vaish wrote:

> For device-private memory, test_hmm backs each fake device folio with
> real system RAM of the same order, allocated with folio_alloc() in
> dmirror_devmem_alloc_page().
>
> When the core MM splits a large device-private folio, the driver's
> ->folio_split() callback, dmirror_devmem_folio_split(), has to split
> the backing memory as well. It does that by hand: clear_compound_head()=

> on the tail pages, folio_reset_order() on the head page, and
> folio_set_count() on each of them. dmirror_devmem_free() then frees
> every backing page as an order-0 page.
>
> This open-coded split does not split the allocator's metadata. The
> allocation tag and the page_owner record still describe one high-order
> allocation, and PG_head stays set on the head page. When the pages are
> freed one by one, the tag is debited for only one page when the head is=

> freed, and the tail pages carry no tag at all. With
> CONFIG_MEM_ALLOC_PROFILING, running the HMM selftests and unloading the=

> module reports the leak:
>
>   lib/test_hmm.c:808 module test_hmm func:dmirror_devmem_alloc_page has=
 16744448 allocated at module unload
>
> and with CONFIG_MEM_ALLOC_PROFILING_DEBUG freeing a tail page triggers:=

>
>   alloc_tag was not set
>   WARNING: ./include/linux/alloc_tag.h:164 at ___free_pages+0x2a0/0x2d0=

>
> The backing memory is a private buffer of the test driver and nothing
> requires it to be a folio. Allocate it with alloc_pages() instead and
> split it right away with split_page(), which splits the allocation tag,=

> page_owner and memcg state and is already exported to modules. It is
> still allocated as one high-order block rather than as individual
> order-0 pages because the driver finds the backing page of the Nth page=

> of a device folio by offsetting from the first backing page, so the
> backing pages have to be physically contiguous. Every backing page is
> then an independent order-0 page for its whole lifetime, so
> dmirror_devmem_folio_split() only has to point the new device folio at
> its backing page, and dmirror_devmem_free() frees the backing pages one=

> at a time.
>
> As the backing pages no longer form a folio, take the order from the
> device folio rather than from the backing page, and index and copy the
> backing pages individually instead of using folio_page() and
> folio_copy().
>
> With this patch the device-private HMM selftests pass and the module
> unloads without the messages above.
>
> Fixes: 56ef39899643 ("mm/memremap: add driver callback support for foli=
o splitting")
> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> Closes: https://lore.kernel.org/linux-mm/be9a8bae-9223-4966-bba9-2cbe39=
c8f4de@linux.dev/
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Link: https://lore.kernel.org/linux-mm/8ef6e92d-4cb3-444e-857e-fdbf88c0=
35ea@kernel.org/
> Signed-off-by: Nilay Vaish <nilayvaish@google.com>
> ---
> v2:
> - Use plain struct page arithmetic instead of the
>   pfn_to_page(page_to_pfn()) round trip (Zi Yan)
>
> v1: https://lore.kernel.org/linux-mm/20261118230044.683221-1-nilayvaish=
@google.com/
>
>  lib/test_hmm.c | 40 ++++++++++++++++------------------------
>  1 file changed, 16 insertions(+), 24 deletions(-)
>
LGTM. Thanks.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

