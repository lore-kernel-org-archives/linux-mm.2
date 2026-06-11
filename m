Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E6B6CD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 00:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 515736B0005; Wed, 10 Jun 2026 20:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C6446B0088; Wed, 10 Jun 2026 20:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B4366B008C; Wed, 10 Jun 2026 20:50:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 26AAC6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:50:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A8BA6C14EC
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:50:15 +0000 (UTC)
X-FDA: 84865800390.17.8973FD0
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011058.outbound.protection.outlook.com [52.101.52.58])
	by imf27.hostedemail.com (Postfix) with ESMTP id C23294000B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:50:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=i02KhlZx;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf27.hostedemail.com: domain of apopple@nvidia.com designates 52.101.52.58 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781139013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MGqSskc1tdiw5KwAYMCYnjfClrtaamPv+pVEZLDpD8s=;
	b=r/EkA/GX0eg4NymuqWOzwaIoSrFckXukBqOMza5ItznstPEj5u2W5Xq/NJOOLkVf5LF7xD
	N8PJNUZqC+rbhmrp+VK3juXf9gn7sxkkXRhARh9xzvNabxV9lrJklcIqlUvEubPrDKzuyq
	FebTDy5WnXPxvS5UsJg8QfwRJocJoxQ=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=i02KhlZx;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf27.hostedemail.com: domain of apopple@nvidia.com designates 52.101.52.58 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781139013;
	b=ohZpIFJOyDI79VabjH3RCXI9aUOo6nxTlQZjECSllQcgam9i9pyV0CWOngxmDuFxv1wmwR
	imMpkOuUBlpS07zEJ/AHcHl/PBXlbPIxcSsbrK6mhkCi/VfmBmkm4L9JUf4/qfPVik8EFe
	JMfp5cvvEsQeBcMygj4yPyL6b23U2OA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ASt5ZnX7hgekzKfPHGyUS4iVLXlwXGcN3RUg8+ghieUXUAohy/19bjpQoVLBX1fbKuIRO8U6a7OGaj3oZ8FJZI4vKZT8j99HFf9+gUTrhD2qRy3Zh/+ZVrhwdDe5mbP0m+mAfhrygpB1XLcSo5otzyim7deqp/pCpbYlsbLep8lW/AGR4cJ7aI+jYMWmTmAWXrirYTWJDDZVMXzgxb8Z0Ln1i3vGXkl6/qGmGkUOdvFuZA8D05j1+eHAQKZy6Xnvpvuhfy9yhjxcUlUtfTTr+LyGW3GUYrD7Xu606MyiUqSlDgH2+JpM77JghJNyD7qKOosxIEyn1RyDyfbyxu10ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MGqSskc1tdiw5KwAYMCYnjfClrtaamPv+pVEZLDpD8s=;
 b=Y/kqUV93Mqzc2akZMQtiWTWlc+7Nm6gpvSHXKVFCRdd2vGq8Rzm0reEqu4PJ1mtlVwZxoGWVqLsBBDpe7VgrEA0Coz/98kivHxmFJDxlvDPQxLHi/ltsfXish6NJNBFbvD8x0CVUz5ZVBmK7Jxs0KqzvC7VH3nNchOp+Kej5Org4MlJOZBH6u+bAupV/SjHzdhQzL2HZSB1TYWd0cPoSrZhQ3P4tcTB2t0vWeIbN3FhoAw37jxhrhEMGQyPHfsi3ZU1eYx78k7GS9bn8SoxYzlQZDUX0vaBSVnD2d0DGjyXKF8yBhv9BAudjp15bnvdDtK67rCOYWkuoqgHPIu51rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGqSskc1tdiw5KwAYMCYnjfClrtaamPv+pVEZLDpD8s=;
 b=i02KhlZxLKPVfU/8imMcs51641WK8CKqvXC3A6RWwAYTaX0HwJCSCPFhGpcZsqNr/Oigvmv0w0GK75phhWnjz7foT32Jl/zEkerE3rWCTQNqYn+EDeBfhq2/6YTV4hZdfF7oK6Jabo5rQw+ORd2hlw5XdjHoRGle4tY5TzX4jxhDnFUZm699XiwGVyuKLgv5t2OmscHzJASf5ajaJBLzUjVzj1vSTtn5dFoIpUAs0kOYfuFOGjzUtflsDru86ZhLImOs/S6NKUK1pwsmwV7qHZdW2eOiNytAGPk20C1E9Il8O5pmmW/E55aKJ82kBOldK+D7tJVacA9Bw0S7iY9fFQ==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 SJ0PR12MB8138.namprd12.prod.outlook.com (2603:10b6:a03:4e0::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.11; Thu, 11 Jun 2026 00:50:03 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.21.0092.011; Thu, 11 Jun 2026
 00:50:03 +0000
Date: Thu, 11 Jun 2026 10:49:59 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Balbir Singh <balbirs@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, 
	Sourab Gupta <sougupta@nvidia.com>
Subject: Re: [PATCH] mm/gup: fix GUP-fast fallback for NULL-mapping order-0
 folios
Message-ID: <aioFswTdZCdPGjag@nvdebian.thelocal>
References: <20260409014647.397515-1-jhubbard@nvidia.com>
 <4d6c1af0-dee5-4f1b-b74c-2ebc23de7baf@kernel.org>
 <08afbec2-bbe7-4e8a-8d99-8a5eaecaeee7@nvidia.com>
 <aiJbJVbD4W-y1XDg@nvdebian.thelocal>
 <5aae8c80-e886-47b1-a1e1-4e91771f3492@kernel.org>
 <7A8AEDE1-C28F-4490-8A2E-72E4E8D0E78F@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7A8AEDE1-C28F-4490-8A2E-72E4E8D0E78F@nvidia.com>
X-ClientProxiedBy: SY5P282CA0073.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:203::8) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|SJ0PR12MB8138:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e00ea45-9a86-4645-16b3-08dec7535f5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|18002099003|22082099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	zsS7ianN2BXR5aymz3U4FVmWBby0DPOKjnT/tyryV20s9HrPhb6ceylQkZy+NE6TG8bzOx1bckuJggXG+mRpbpUFdn2A8SgLvUuMPKRF2NVGvb0ldd6+WUhjLRQcoz1LV1O9K8LeB93in4cCCQ7HDOQJUlcchCD+wQqF74aZDCOdrdXgRtDRe5UsbWUw0AVcfDXDw0Z+U7fndpYFaAkFvcvrYPkBHMqvdvucQopHGbjenuv8kkC4Gftql74jveOpmBb+8ktgI1rghZPkdWrDhbwuv0B01f+rEC7FMa9w0dkbDLmyfphL/JTS61RokuBFy5ReAZnJY21wWxMACrPSiQmrelqadRwXr0LQ/I38mxVajfzjIq8ocAx9dFzQ6bmnQ0NS7Ipwq4qezW7agUBl3WakfhsoLFHETIqb1JqVUAxaLbR5ZHhDC7WcPOAoHnVxML5SInUxgHBiZ+mY5DpA6L/uQmcqm7KuvuyTAxig/eAiirs419TX4m2D3z6eIGJ7k1BX/5Qh9lthMD83TwyxeiJYDBhcYAXmOjFisYrB3Aw0G+iacU3mmcr/NA7ofOO3yjjrzhnfKdfN7nDSL8MxUJA2yfpKkkVdMnFCg/e2T9zgVrap1JXei+qbyD251AT4fGPgYWLmzjSsCitngjMcjralWHLODfxFL9aB79Peo0Z0gq7axK6BDpZMJRdB/s5Q
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kI3A/dN9PPvaacKjctH+TX8He8PSAnmK3BloarF2V/WzncAdYJpuLcnZtgWT?=
 =?us-ascii?Q?iOhzEZlR4qh6JYBSmjNt7Upy9srAZmr7obs+mZ2O/p6M6hO5Bd1NNrm/KP1Y?=
 =?us-ascii?Q?vjlHO1f+cKKczOmXva+suApaCKpfC24+YGjPopwpo7yMkkTElKBRrN4qx20O?=
 =?us-ascii?Q?GRYulqRyVCmhvC2I+FJvEVf1cKFPGT888dG/x8Hv+uQwP/tw4WmqjzfPExHF?=
 =?us-ascii?Q?SpCXuRwUH3cCQYnwfkVGm1tDt67JdpY1bzqijIXngKPe+FjSdh3BoS7zkAYv?=
 =?us-ascii?Q?IeAjIjnJBIX5/38YL65yKahVHHWNb/GSQ5QkdtPzNUAoYVhnWN2KUT1E8u5J?=
 =?us-ascii?Q?+htNRnk7i3CbfcFGF9nlHJG2z6OkMAXVk+g94h+X31baE81lCy4RF4hsatd4?=
 =?us-ascii?Q?fLa2dEwovg1mpge+7d0KPSlVChNXPDYsxRcjB/0tLGrKnA7sOPXIbuF1WAeR?=
 =?us-ascii?Q?XuEgBuAbYlxbuYXPBULWgJZR4MNTRRSMTi8w3F/K6g2q9cxnjQmM/K6Dm9tT?=
 =?us-ascii?Q?Br7sG7809MMdxsMR9GXQg3dQ8leKT6BKj1JQpx4xEcXKwblEtcc0P6Qm8hyI?=
 =?us-ascii?Q?xKTvU3VLx5kaeWczs35fpKKXZht9+PXxdILX3q/rYHuSq3qPUnKejA019amo?=
 =?us-ascii?Q?idvv024eWM+Vf25s4GC/2fI2fggs+ONFW1VSB0PF9UbIBQi9k9rnf9VvvbSI?=
 =?us-ascii?Q?IlUp/iNpr8122EjRMOoHNofx5vSoN1WQUAhJDVAhePSYTjl/fgSrqHAzcsQT?=
 =?us-ascii?Q?uzL9KMGsmrcSSlsd7ti7D6GKF6hqdnwCMF0/KubU8UqlryVp6MvAWc1YoCgb?=
 =?us-ascii?Q?Jv0/08wW/lb5pCLfZysWzUTXj/VdUKvxOsH4cJCWOBoVFlB9SVB8GBrPzgFl?=
 =?us-ascii?Q?1jpVQ5zMMWIV0kuqca0o0VHrtsGxNAZB4Uqdojdrt3tvfYtGftKNXQgXe2PG?=
 =?us-ascii?Q?aHXmQptjEcZV1rGjpe9aTN8eHwn4mFiOGiyfWgqeOsQ9yBkjKw0fYq3SES7W?=
 =?us-ascii?Q?Rn6ymCcteFxaqyt6Weoe7cGjamSsPEI3WKT0qZC5u+Tvs9sbJsfNXTddgc/A?=
 =?us-ascii?Q?TtPjQYNhryvHpndRXLjTVfj8i2QxIPrs6u3dhlTCM4//KC/7onnhiIS+6fTM?=
 =?us-ascii?Q?Fh3oD/r+k6KK9382zo+MsUWOiOJXs4ixV2FAqbaX88Ensk8M3rpNPFTApLxb?=
 =?us-ascii?Q?cEAnj58JO9xQQSood+0XY0YZMU36FTTTw+txSkGLNwrlC06D9+9XWWjkSBhc?=
 =?us-ascii?Q?7QWtF2k/iuynv0TX+sd9T0DpIVsjc5KgGW3pn68+q4ghudAAM76wYc9nNPs2?=
 =?us-ascii?Q?8bynNuA9wmEqeBHpSTKbbxUitofHMJB8oLadEhQYw6j7k5biQIH1alLwzptV?=
 =?us-ascii?Q?vOkMp83DU/NEcHJoiz7Wemt0ZqTkAXhiXXm5rRN6oLJZOC2eS1tp6nZmQcCN?=
 =?us-ascii?Q?PSGC9VgKRKrTj0ftZ8KTEpirZE79TWDg/cpD7dZ1I78orB/nDlJixu7cO6fh?=
 =?us-ascii?Q?YRwdrDr1iFskR4KpzwYTLFH2/mmaTZ3fYsRSbDBdGrV0zY04BbhlwxPdfidA?=
 =?us-ascii?Q?hAE9QmQJGnxVulF1bZNus0YQenutFihAiYBmELMCEN2MeZy5XkbvC2r+2nOY?=
 =?us-ascii?Q?sRmvJp+Yip7nt1sYAGa13JeBMl14ft7dMX1Bb21G8dgpw+vI/C5AO5TmQyZy?=
 =?us-ascii?Q?dWUn/TV4Xhs9EwT3XMZo0tZ0zVY7BwxLL9eav90dGgJ5UfcIx4dTTW2u6+IC?=
 =?us-ascii?Q?68dlJnK1Ug=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e00ea45-9a86-4645-16b3-08dec7535f5b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 00:50:03.1483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KWycjNjNhEW7wdiyfh89XdKS0HLPEUmY4hyG+lYCFVZ5r3FDrkIECvMivv7vbUdnpVu6QdDPoWn0qOTcftFc9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8138
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C23294000B
X-Stat-Signature: 5fb75p69ppcow843neh97esobz8gkcgt
X-HE-Tag: 1781139012-761101
X-HE-Meta: U2FsdGVkX188R0kAy14FCxX4XFo9QZ6OR4R+ujA9NKp6rEnUnwheyzrr1KJVVWn1/SIVQm020q7BAqkZboXGGUVaIgBJuclaGSIaL1P6+xgnPI6mfOcZcne/ScEaV8hlujy5y+5jHKlJX9lv/pqkyL9DSEpGZYVUavwzF93nKELuTD7Qw0agEHDtPQ6YPFPCUwlii3MOoMu1X19OVjFGTlChXsEv1hschDMB/qHsNh4dxkS0HsHS1dpTuiNV8NclZOKG70rWIVAGFU/p66CM/ekmLSJd1ndjHOLZv3E3Kbhqbv+mEQTn2aARTknIOgnhYu5Y74X1y33LMLLoqNns/ibuxBndKeTaxAoA9qo+cwVrFOeybd7SHcsa3zDEL/FD5KWQneLA+KsEQCSBkORuYxbA2BvRb6n8l3r10Z34a2BF6FYgFxMvULiKteXH1YnyRwyfx3DqEM3mXsb6dwp7ZVyGJhzPYbLq5l2n8Q4AuyUvTIMh7zU8XAJeZxzsHKrwi0zy5cEVnRDnzmao8Ir3VujV2rVvJkDRkY5yzdrrmym459E2J+87DjpgwygaAUJqvlGhK9m6C50fa3kdonWR21I6f7yEQsH0s28IkDUKI5npxdpNMacNWgVbjZNye/kD1eAkMBsdUWK0TlqJt6ab/xQFzCgaa0zOFDEL0vMy+ipxcjg30oxX/LU/B+ZyBVAaD+0e4aL+5VbtZLY1G9/wskN37T0d2PhpIQ/n2/dvl/04yo2w0iCFGtMt+shiAaZNQHyVYkE/7y4P4tHdeK55CPtqnyXfhsb30wveN0lmhcnyBpLyiXH5EazfYJLx7/6d2w0YDSSKLuK3i/2kUPOfRZA4tDMhoeHbOxdSR+2e6tADsjrCuhZV4TIhYOZTAbcRpqdQBi6j/NIg4Iq641HhrTEhcTWvTkjUsXDb7V10FFDZ/pHKMyPmjG3GIdukZt2UbtJdE7vE5UYP5Zq3nB8
 3GwYyDIp
 x7mHT/E+pK0QDQ5k88WrgZ6tsY+NPh8z6RHVsJC41H+pnyArGxc0mWeFGA8gh9QZmByK7C9M0D3WPeJal1kMJFqttrbLeZVPCv5/iLCmb9cxsPZb3+uF05nVlHE0ea73W+y9hJXC0Gpzw5lqZcUGcm/VuD87iIdAZORMOpnO6jh7giiWtxRhSJqzngv+PloR9/fQL3oKjFY5nfQC7pPJ/olrxyIiEdtVftQ9oMpLsSUa7+ZMiblpQdy4yiwY00LtIuH3UtfteXDZVwZSjA/GtTL8BAc+MVRgRtj6QUzACysbnCyO7RweFeOdjpnbMfq/28Ww8wc5nU7T0ZTAtNcbcf/9LMuv+1RyyoEJQk+VfXM+XuBXA9lFzBrwAC+tDTnWNTG+OhxF0SYvNB/U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-06 at 02:20 +1000, Zi Yan <ziy@nvidia.com> wrote...
> On 5 Jun 2026, at 5:22, David Hildenbrand (Arm) wrote:
> 
> > On 6/5/26 07:17, Alistair Popple wrote:
> >> On 2026-05-15 at 10:09 +1000, Balbir Singh <balbirs@nvidia.com> wrote...
> >>> On 4/9/26 17:52, David Hildenbrand (Arm) wrote:
> >>>>
> >>>> Hm, what if secretmem folio just got truncated? I hate to rely on some
> >>>> handling in the caller to detect truncation differently during GUP-fast,
> >>>> but this function returning "true".
> >>>>
> >>>
> >>> Can secretmem folios be truncated? I assume you are referring to
> >>> ftruncate(), I am looking at the setattr implementation of secretmem
> >>> and it does not seem like it can be truncated.
> >>>
> >>>> Zi is working on a way to distinguish folios from non-folio things: that
> >>>> we can identify whatever was added through vm_insert_page().
> >>>>
> >>>> Because that's really the key problem here: vm_insert_page() pages are
> >>>> not actually folios, they just look like a folio today, but looking at
> >>>> fields like ->mapping does not make any sense.
> >>>>
> >>>
> >>> I still think this is a short term fix worth having until we get
> >>> Zi's fixes
> >>
> >> Agreed - this clearly results in a performance regression and we have customers
> >> reporting it as such. I think Zi might be out of the office atm but when I last
> >> spoke to him he agreed this fix should go in for now and his approach will come
> >> later.
> >
> > He should be back now. But yeah, let's get this fix in.
> 
> Right, I will work on my solution soon. Meanwhile, this change
> is simpler and can be easily back ported.

Thanks.

> BTW, should it be back ported to older kernels?

Yes to any with f002882ca369 ("mm: merge folio_is_secretmem() and
folio_fast_pin_allowed() into gup_fast_folio_allowed()") - we have got bug
reports as a result of the lowered perf that commit causes.

 - Alistair

> Best Regards,
> Yan, Zi

