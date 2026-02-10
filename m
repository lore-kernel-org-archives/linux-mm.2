Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB188E94628
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 02:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBC2E6B0088; Mon,  9 Feb 2026 21:23:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D94786B0092; Mon,  9 Feb 2026 21:23:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6C7D6B0099; Mon,  9 Feb 2026 21:23:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B65BC6B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 21:23:00 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4AFC31C28E
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:23:00 +0000 (UTC)
X-FDA: 84426949320.06.B16BF13
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010016.outbound.protection.outlook.com [40.93.198.16])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5C1AA180004
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:22:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=cs2HlR4s;
	spf=pass (imf16.hostedemail.com: domain of apopple@nvidia.com designates 40.93.198.16 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770690177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fOWZ4bGy6vxKKJ+94M8fejwr9yf0h/BFMbfxCVhBilE=;
	b=I8hkNedFki3VCxTVCw7ZPnr3As90kw27VvyrZCmgMtufQakviSFZkC61hXZTeS5c8hC489
	jCsqw+/5M+mlqGY2GJv+QStUFkpKRFRWiZndVfvVzgGSKpCG+tN0TTWeTAMu0qxx1E+aGW
	a7rZtecc1F1sDEhZKW7KksBbU3eVosA=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=cs2HlR4s;
	spf=pass (imf16.hostedemail.com: domain of apopple@nvidia.com designates 40.93.198.16 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770690177; a=rsa-sha256;
	cv=fail;
	b=D5EvsyRr+b/Dx2RhkK98DG6ebHtQE8FoiIkj6iKEiqZemXzG96RMP/5NZAehzjr1SdzFzj
	3D/Ze80JdJWVFI9dtZuFq4Y00RVp9QtQCoCTFVPDZLo7h3DHOpnzcwh8tESR48wjTT+Tz0
	kdI9rrg9UXs4lgCi8X6vvgH2OmO+nkc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dNvcVD41J9xlT1VfuYZln3xKmSxTczsaJBQ5Fvx3b/HktJR+2tgDhIpc0wGcOGt28sEuNQ8HQzfxHPeCgHoC9IUsnTbd2SFYf79WXflnaqghOxJfB3V5CyBsoYQfbcp7claium498tB/kPbYu+L2zRwEM5qTG9FBHtEnn5tNU8G4ZvzGxEfNVs5RM0lpXq+nDDZX1ncp7LZyyiB4K0IJMuhjWGeTAaBxuooFi1pHqhXBK3yx74wgQYsrv6WviuaWkqxK+9/DGEQoOWDuFqZb5bp1g42zEFjQd7UDTo0peIKp4sQ0lLXHdktlZ/L01G3X+kbGEvh010SHiuPjwQzcZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9THOYNAvTGgHfju2GDz0wBeDBPi869vQqCFLI/eR8kc=;
 b=Tr7BZH44kG0YtiPaVq3W1P2ibx2wvssJznj8xsNwVFbX4XCxiTeYWG0f0RC9W5OeQ6IUsphk8++FQ/5bBjIVt0CMqF6H0HLrS6Z7ZZEUxpoV2s80/JKGxFHgItf6mb7Y9zoddjl4XlMMK9Gcha87tl05+bk5C9KHBmVdbJpj7SfbPombvjFZzz9gqdbBO7pdT1Tle0yEK27vJ6R70l2I5j+8/L6huQ8b9OHNQ39ZvoZB0fDuFRveqV1QSmyn1rmNQCcRU1ec9BHFANux7efoHUqgcgybUP7XI74+7VVlXPoo49btLfHXp7GipvO2AXzpIqVVwGMUixZ2nKo0dY6SuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9THOYNAvTGgHfju2GDz0wBeDBPi869vQqCFLI/eR8kc=;
 b=cs2HlR4sliR0J+7DzRexFw6eIhiGFtlgSQguY9EbCFtyPFT5buDceeU4xGxGv4eqVPlgJ25PX+o4YT2c8mM8t9Jf2d1qjdq/uhBg+/o2LpwOvgqM+vLyNNcV3yv+QcQwbk7oAIxpgw9BJwlPHzpASBqIBmizg+UvFwti0hmYYWvCqVgULSLkp2CNJzG2HJ7mvFsdofSplKKy+NLknodX+4xZ/Vr02VhLwwSDD/OkvUgSMd8ltaIqTQ8Gqp1IQAT/9ptIijNgsySUjIJdN4rOmbQLj/I/4RtiDIH9JfCVXH/fQoibBYIc5fKs6ENynFZvYCR+7Q0zCO8ytTqEtuNq8A==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 CY3PR12MB9577.namprd12.prod.outlook.com (2603:10b6:930:109::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 10 Feb
 2026 02:22:53 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9587.013; Tue, 10 Feb 2026
 02:22:52 +0000
Date: Tue, 10 Feb 2026 13:22:47 +1100
From: Alistair Popple <apopple@nvidia.com>
To: Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: intel-xe@lists.freedesktop.org, Ralph Campbell <rcampbell@nvidia.com>, 
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, linux-mm@kvack.org, dri-devel@lists.freedesktop.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v4] mm: Fix a hmm_range_fault() livelock / starvation
 problem
Message-ID: <wfnxfomvi5rxk3zeexpgumi52xrbwvo5fwtwyjeq7675mgnpbn@n4lk65p6lacs>
References: <20260205111028.200506-1-thomas.hellstrom@linux.intel.com>
 <89cb1d4744789702cd80dba8eb40dd50bf053b4e.camel@linux.intel.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <89cb1d4744789702cd80dba8eb40dd50bf053b4e.camel@linux.intel.com>
X-ClientProxiedBy: SY5P282CA0142.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:205::12) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|CY3PR12MB9577:EE_
X-MS-Office365-Filtering-Correlation-Id: 94d62886-e433-4a7d-dc4f-08de684b4b16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?7JysSraEVXTP63u3NmbDSpJ1026KDxbDs5twAHBnynPjcVdcgG9w6zrtkV?=
 =?iso-8859-1?Q?kF3ZVr6KINSqBZW7HzGPWxFmOgmqfEbHnHVbbEhNm1KM5Wc1uesCuPlrc8?=
 =?iso-8859-1?Q?TsO+knkNRlqsLi9KtlXQWd9Y9NBNgBvxHoXs4rvUJ2rZb70BN/MBtA11Xz?=
 =?iso-8859-1?Q?tJI0IFXnpG+BZU8z25BmoEreNP6t2a9xQUggasjTR9bpeLNLnCnLbWtnm0?=
 =?iso-8859-1?Q?5/7MP44w1pX+CZgFH+c2mN5I3Y9BnvGNGEJhci5Hf1RH/S7SbrndwBJGIU?=
 =?iso-8859-1?Q?x3dk6tnLNK2o2nlUQHVtPKfdfaNjkkVdV2F1UVnM6+Y6rcbcn3ESz75x88?=
 =?iso-8859-1?Q?QYJRBEJGs35DSExOB0qmp1yDwwigiaJJ/Lpe7EChXZ7zg6Jm4ogJ/CIKjT?=
 =?iso-8859-1?Q?v6TRITgIHSEkLrNzd4GYN/3lt7XgRZOPImZeW08KrxQPhy31Kxg39mVnF7?=
 =?iso-8859-1?Q?8D7fkz3GAyT1y9GQb0rDe1zcf98Pv5dD8dP9eXLUkAM4CSm3Fy85JE9nu1?=
 =?iso-8859-1?Q?wIopYfJ8J8/6Y5S2qYHmvaTJZ/fv2+eNpvhu/6fAjWYuiGzZR7p+IEqxga?=
 =?iso-8859-1?Q?c9nXUUGDhvc1slu9+ldXy7NN8EJwTZDX7Z+wwZ9Zx2mBadUH0ZkcMPVAf6?=
 =?iso-8859-1?Q?qNcBhDw2EghnkzvPHsVVequj6NpfaEtx0ecAmioWyERZ8TKNUjZ2tFQ76I?=
 =?iso-8859-1?Q?M+1JL5O03wYkh8qvQeuxld1eVOH1a3pn++U5cAJHPFZXJMD20L3nYBINft?=
 =?iso-8859-1?Q?uwkkVqOy8vg4LrVjqJ2B/i05gfcpH0O6gqN4zH457UOxtnJYW80b9b8lWL?=
 =?iso-8859-1?Q?hQT5tZY0KngBOIn7iFdc7G2/ED3zo2zl7F03ICLO26BMbiix9R8TYOkubX?=
 =?iso-8859-1?Q?4NSOrLFiTTOdo/76L07zcVO5mh241W8c/rmtdqN1NVtwOXM/PzzemfSLCr?=
 =?iso-8859-1?Q?Tvb1G0V5NKolwvjtkaUdJVAvD0ogRTmsKS+uPXfFhdMpQg0nr7VmGeSGng?=
 =?iso-8859-1?Q?umnkckUl/oMXweBhbpF3B9JMr+GLd2S/rY4kBnRIoNFcUAlq99mEGGW18w?=
 =?iso-8859-1?Q?91BwHiI+6UkatMOvDBw0+B0bprM4YS7v2lVTvDE2SEtF6fEWj6phqPcZ2U?=
 =?iso-8859-1?Q?/Wvjip/UVwYMWk5g6opwvp9onPd2v2VyIJDprNFYaGMw+nDtR/JOzvGkwi?=
 =?iso-8859-1?Q?fi7NfbWa9F0mnrf2eGJ1IlFoYwtng4bVWV+8gK1iXaZ90axy+C8Iu3W99K?=
 =?iso-8859-1?Q?7Lr98jx2McYQS5bAqwsbXYzfmEKga5EaHQDa99fXKG0t3Hv2QKtbutVvUB?=
 =?iso-8859-1?Q?Jt318exLui7ZQaNQ3pKl1TKQlWwoqPbto1lMS8cCTTZDmH5NWqr3/3uw6c?=
 =?iso-8859-1?Q?JWS+ndlabIvDTzg99561q7uNOWmaVl11voUX5Mtn69L0udVQMpCMgBvuZN?=
 =?iso-8859-1?Q?Fr2fYZiym6ililhiVgSv/q1bcMDMT1FeVzZ+d8YmJ8tg2DZqqDcUWKEAsJ?=
 =?iso-8859-1?Q?jLc68BFkLR7dynkXIvjgdCfS43manbccFms4Eb3lf0UBwH3MdxzGKvfbKT?=
 =?iso-8859-1?Q?YbRvRl2E9HcN3Qkc9rnWCTTgYKAaWvQSMX5O5e56t3lJla2dqA7xcbWZis?=
 =?iso-8859-1?Q?cvMrBC9F1+/to=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?Kn2Ssoqj1lL9WXe8SPVbhai9iqZard0oVlYK0MMlGgXnnW2/ePpq6NatGH?=
 =?iso-8859-1?Q?H8UgO9knNg8ufaSW5e2+M83/7euWflpm81VUwXQDw1JeHBgutEATfw064U?=
 =?iso-8859-1?Q?bYNaNPeCllxKl9PLLuc0O7RFUFMqDygILKnGQYul9B4vDCwitBRYOpAdyQ?=
 =?iso-8859-1?Q?hR/cqQNMhge0eNjzN/nsRcHNp2trZ1jLvdSBO8UaWkz+IiCkHhvogm2hRW?=
 =?iso-8859-1?Q?dGyN2oEYY+p1aIcIC0WM1ph26sjovhzBPzcNfN4ZlJmA4QthR+UheHaBRn?=
 =?iso-8859-1?Q?0iedSpzLzVnqPjHdXb2DkfjRkmzh8zAOJr2sCePzKhY8e0IQe0ZzJOtW4u?=
 =?iso-8859-1?Q?bKo8LpIamkeaLuKkIxUOnox7s472N2AKAgPqzkvopnfXBHSSJ55gdDY482?=
 =?iso-8859-1?Q?m2d1Ux+4yvLKD64+f+8/93k1eYY91v+PJw3piCih4/R602MKt8KS2+3QLC?=
 =?iso-8859-1?Q?in09EEcV3grM2R1SC2lE0NYk4ud5pCnHJmmxShrJeAo81meblhJUBpG18A?=
 =?iso-8859-1?Q?VqyKmvwpbMXB3Y6qD9fG9OkNjNaCLf4hM4vdcrma53I+wue0Dtrd79Zf8T?=
 =?iso-8859-1?Q?SwebOQ8uvBNankqsWVhgLUKcfLgLFiGVj7SUtV1/3Y1CsiXHTGFwGdhTX/?=
 =?iso-8859-1?Q?pqiiNOuZ/IARif3mtbxNAIB+4j7T11haHbsJanIwgZT04LjT5Fe4K5rlKw?=
 =?iso-8859-1?Q?xIOJFIvIeXOv5qwz3LfjH84mWJ6IHOQBGoyleRjorWU1GOTOkTwbtGDg0v?=
 =?iso-8859-1?Q?NijLXk83mSVLiyJ57Bw15n9+UqvLcNaFoF3duuIMbrEUA+/+c7e9SJvGA0?=
 =?iso-8859-1?Q?h8l1W5BEAnwxK8lPXP3s91klovlUYcz8fdU1vddP7V8vfpwwwrGXZ59bfk?=
 =?iso-8859-1?Q?qiPaBHbF1YMYVoaL1dtdPLe+ZuPzoxTdRNJ7f9ut9aUmAXZSJLeXPCeEVv?=
 =?iso-8859-1?Q?DXSq+uBmbJ12yeBv2KIbl95+d5lb9THsHP9u2N3RfRBX8ndjYrwnQEQrEO?=
 =?iso-8859-1?Q?5EKAsgSokpWELN9KkckiI95BARFhTjqA3J7YxJnT//Eml5rLFKDZ5YvBeW?=
 =?iso-8859-1?Q?5AZ7CbBcrW8jeELlexwga3WicISCg6glcQFn9ZvfRwjVM58enJp281oEFr?=
 =?iso-8859-1?Q?6hnUnmn4ybt/IbmNetZwGeFlUNEJ5xMSByvkowzER6pt8iR2qsRzeo6aMo?=
 =?iso-8859-1?Q?NmTOHysSsRESn1AKVDCTJh+CR0mW1fMFPXEkkNoNh6JR0TubTxHxrAy3GG?=
 =?iso-8859-1?Q?loBIrGlOV1r1xdqTM7Ddc0+6Ha4eiHlLurgfdJ7lii8hbBzpGtRRY7FohT?=
 =?iso-8859-1?Q?balMj5iMo5PA/sofMk4RABrZ94PVvmoLP3LEItfUn4PAOcq5ItdmW27s1T?=
 =?iso-8859-1?Q?DZwtYSKGxCIcXR2+tPu2b+MiKi4baT74HuNDFiQEGjiXOIyxmM5tadsg6/?=
 =?iso-8859-1?Q?ikG0O0knKTYprVvXMWJqU2qcEA8EVgTvpLqSigF1RIaBliR1VNhmcAfwoG?=
 =?iso-8859-1?Q?noKgQ02fSmKyWMdhAyKwU607AFDExBCqGy8vvxQlpPjLeDkaxjvOoJVS+C?=
 =?iso-8859-1?Q?/iE1KcPTppsAHIvnjFyn+mol38VoId/jHhD9+SX6RvHraxfuWvmFtj/pwT?=
 =?iso-8859-1?Q?SPFbjevNK2alLZK6zfVygN/+zxGFQe5NPKtEC2DIrx92awllMsJ3jLUhQe?=
 =?iso-8859-1?Q?lrf4C28nB655LeI3RzD9HGUXpaHYf1AXpf9zJ/8CravkEdnHJARbRvhvwb?=
 =?iso-8859-1?Q?NNR+ZhjsLyhHoyY+neTCRHV2cMM/GB2E/Xpsnpn51jq0maoUGTtt8HzwyZ?=
 =?iso-8859-1?Q?2KPFesNE4g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94d62886-e433-4a7d-dc4f-08de684b4b16
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 02:22:52.7110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2XdJQ22dji0w2CBOrX2eFoistWF0nWbP42Uo9nqYmV3PH5JCFeiuDTBvY24qDg5UnhT4qfyzddgxizptALbdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9577
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5C1AA180004
X-Stat-Signature: zz5cbjstot7p9gij5nm6iaykss7a1m66
X-Rspam-User: 
X-HE-Tag: 1770690177-267899
X-HE-Meta: U2FsdGVkX19gkf07SUhHmr2XGGsgU4hNxftO4TF0JnL0c2PgM8rNctiTKPs3vU+MCgtKQXWd4vNlstnKQPWhzQaJ1o+jjl6X+iOLIOLhwCP8itBjhPK6/ZCyHMeVMttLjVBnhVpW9aif0Sx6D4jnZ+9z5tnTd0PKAE6/U4kw9Bky4OmxytwU0fCXazBEU+xrWAPtEwjM68uuN+Pi9F5FdM8Dm9rC7okhrIyFkifeQUAVy3aIsuevHy+wRH0VQoeINmJTljoBkXQ3QsB6sIiKT5HKRJ3Ge+vd5zUc6sLb4bPOK6It4zIpMzMC3eRcPG2pJA89r+KSmZtJS8vOCeb+hLm2b/dMsfIS3scRDMMkvsLH9Lnk/+2VJXiyWojYvd1w5aKbbWpuIX3XGCBAOFnZ9vzydozbfUNXEl2nCAmTq7qod17+VFukjlYvtWnJb0cNLXI9w18LfZlCUUdohu2g75Z3yzHekLlG9IOEGbkJWtB8t5gFyjOWu96fgmVIp/ATEMtXUqETrRcnKRgB0FqnMg5sdKB6J0byY/RJYXFtTp4bQ+6FsO/8lIGgzFS2lCf+bbvLbQ+qNXBgo4D9Vtp32H/pSU+JIDBf1JEkIHpvso/Q4TWZvK5Aiaf2zwPzGin5agWcqpC7jYX7xAZmFMCdZnFVs1c8K/3yQdCnvC3kCEWrJXDWgD3RpoCkF8JehUTeyna9thKtnhmLJS/wTuVNDUO0aoo7z/totL/COWMSgFsl00Ii9QwQKdmkMZIY12EF22hCNU4VwTKhWdH4WHcIOD9GobD9At8+3BFVmhx6TvIOz+jXBfXlntaa+OpGhsppsbiFF1OfwyeKTU/T5nB1dT/gd2O+RFFBZIG6sAj9rHtbj9tLDdyDTq1D1JktAbMg3YmOGK9SRMqc4oYXliIXRYVGGwcuLG7HeqIuqSj3a2HCwNybgzeDyf9mElj57JYIznfIuZgYrHeTuiHfsQX
 TU6FPFxX
 me6opIAphMLlEMc5qOX36egRIdrHL3ENQC/zhH+eeN2fgCOQo1FcilWM3PemFSq67zUCaDNPi/DUnCFbLFiUYE5kgYpC6EycozvukhHSpZN+QeSNAsddiWNosDSo19gZ9wxUru8MMWrvlYw4d1r+30QqW2I0uNYeVigdVVj7KiClm+FyOtbcViSO4UJt53h4fEgXygCUdQVvMeOML47+phPrqTVaqM7bTA117tHM0CvU6bTUjdWN4SfA8KJE7IoITF07NY4ybC15xe1QLufpq6eluE8/meGgtqekx2PS5BaP3lNknaTrabeqtW7RimZ5JkGu5S1hAnQ7d4Md49FQJOCjI1yM6QAyRWMtbjrqaIWLBPSUh81Ok+7aDWnerI6xq0ncWMcAsap0OTmffcIkp5YJ1UWzdcVeS/nIPhpwA3ipqCA0K9GdLQs+FCwN9bJZjMMg0p8rdrnUAshjcQoR8HhOHQYDAecKhaenXnTZenXbkpjQdxbgIJo4J4l6EVVhb+BsmtkAW/g8Cvxf7Tl8zi6chRcCPiOor3u/3nEqpJlv2o8+SOXUzYyNon2aF9dVUMXm+BIHLHOpaK6rIwE4pOfjsO5yoLqRUpAsyllK+vEqMIOS0s7iBVE+A3kTQM3j/fVsF5EWlQRSKHayp07hGObbO/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-10 at 01:47 +1100, Thomas Hellström <thomas.hellstrom@linux.intel.com> wrote...
> @Alistair, any chance of an R-B for the below version?

For sure. Sorry I've been getting back to this but caught up with internal
stuff.

> > +static inline void softleaf_entry_wait_on_locked(softleaf_t entry,
> > spinlock_t *ptl)
> > +	__releases(ptl)
> > +{
> > +	spin_unlock(ptl);
> > +}
> > +

I noticed this just because we didn't have it previously, but I assume it's to
avoid compilation failures in do_swap_page(). This is definitely the better way
of dealing with the conditional compilation, though if I were to add a nit it
would be that a WARN_ON_ONCE() would be nice here.

But this is fine, and thanks for doing the rename. Feel free to add:

Reviewed-by: Alistair Popple <apopple@nvidia.com>

> >  #endif /* CONFIG_MIGRATION */
> >  
> >  #ifdef CONFIG_NUMA_BALANCING
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index ebd75684cb0a..d98e4883f13d 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -1379,14 +1379,16 @@ static inline int
> > folio_wait_bit_common(struct folio *folio, int bit_nr,
> >  
> >  #ifdef CONFIG_MIGRATION
> >  /**
> > - * migration_entry_wait_on_locked - Wait for a migration entry to be
> > removed
> > - * @entry: migration swap entry.
> > + * softleaf_entry_wait_on_locked - Wait for a migration entry or
> > + * device_private entry to be removed.
> > + * @entry: migration or device_private swap entry.
> >   * @ptl: already locked ptl. This function will drop the lock.
> >   *
> > - * Wait for a migration entry referencing the given page to be
> > removed. This is
> > + * Wait for a migration entry referencing the given page, or
> > device_private
> > + * entry referencing a dvice_private page to be unlocked. This is
> >   * equivalent to folio_put_wait_locked(folio, TASK_UNINTERRUPTIBLE)
> > except
> >   * this can be called without taking a reference on the page.
> > Instead this
> > - * should be called while holding the ptl for the migration entry
> > referencing
> > + * should be called while holding the ptl for @entry referencing
> >   * the page.
> >   *
> >   * Returns after unlocking the ptl.
> > @@ -1394,7 +1396,7 @@ static inline int folio_wait_bit_common(struct
> > folio *folio, int bit_nr,
> >   * This follows the same logic as folio_wait_bit_common() so see the
> > comments
> >   * there.
> >   */
> > -void migration_entry_wait_on_locked(softleaf_t entry, spinlock_t
> > *ptl)
> > +void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t
> > *ptl)
> >  	__releases(ptl)
> >  {
> >  	struct wait_page_queue wait_page;
> > @@ -1428,6 +1430,9 @@ void migration_entry_wait_on_locked(softleaf_t
> > entry, spinlock_t *ptl)
> >  	 * If a migration entry exists for the page the migration
> > path must hold
> >  	 * a valid reference to the page, and it must take the ptl
> > to remove the
> >  	 * migration entry. So the page is valid until the ptl is
> > dropped.
> > +	 * Similarly any path attempting to drop the last reference
> > to a
> > +	 * device-private page needs to grab the ptl to remove the
> > device-private
> > +	 * entry.
> >  	 */
> >  	spin_unlock(ptl);
> >  
> > diff --git a/mm/memory.c b/mm/memory.c
> > index da360a6eb8a4..20172476a57f 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4684,7 +4684,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >  				unlock_page(vmf->page);
> >  				put_page(vmf->page);
> >  			} else {
> > -				pte_unmap_unlock(vmf->pte, vmf-
> > >ptl);
> > +				pte_unmap(vmf->pte);
> > +				softleaf_entry_wait_on_locked(entry,
> > vmf->ptl);
> >  			}
> >  		} else if (softleaf_is_hwpoison(entry)) {
> >  			ret = VM_FAULT_HWPOISON;
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index 4688b9e38cd2..cf6449b4202e 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -499,7 +499,7 @@ void migration_entry_wait(struct mm_struct *mm,
> > pmd_t *pmd,
> >  	if (!softleaf_is_migration(entry))
> >  		goto out;
> >  
> > -	migration_entry_wait_on_locked(entry, ptl);
> > +	softleaf_entry_wait_on_locked(entry, ptl);
> >  	return;
> >  out:
> >  	spin_unlock(ptl);
> > @@ -531,10 +531,10 @@ void migration_entry_wait_huge(struct
> > vm_area_struct *vma, unsigned long addr, p
> >  		 * If migration entry existed, safe to release vma
> > lock
> >  		 * here because the pgtable page won't be freed
> > without the
> >  		 * pgtable lock released.  See comment right above
> > pgtable
> > -		 * lock release in migration_entry_wait_on_locked().
> > +		 * lock release in softleaf_entry_wait_on_locked().
> >  		 */
> >  		hugetlb_vma_unlock_read(vma);
> > -		migration_entry_wait_on_locked(entry, ptl);
> > +		softleaf_entry_wait_on_locked(entry, ptl);
> >  		return;
> >  	}
> >  
> > @@ -552,7 +552,7 @@ void pmd_migration_entry_wait(struct mm_struct
> > *mm, pmd_t *pmd)
> >  	ptl = pmd_lock(mm, pmd);
> >  	if (!pmd_is_migration_entry(*pmd))
> >  		goto unlock;
> > -	migration_entry_wait_on_locked(softleaf_from_pmd(*pmd),
> > ptl);
> > +	softleaf_entry_wait_on_locked(softleaf_from_pmd(*pmd), ptl);
> >  	return;
> >  unlock:
> >  	spin_unlock(ptl);
> > diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> > index 23379663b1e1..deab89fd4541 100644
> > --- a/mm/migrate_device.c
> > +++ b/mm/migrate_device.c
> > @@ -176,7 +176,7 @@ static int migrate_vma_collect_huge_pmd(pmd_t
> > *pmdp, unsigned long start,
> >  		}
> >  
> >  		if (softleaf_is_migration(entry)) {
> > -			migration_entry_wait_on_locked(entry, ptl);
> > +			softleaf_entry_wait_on_locked(entry, ptl);
> >  			spin_unlock(ptl);
> >  			return -EAGAIN;
> >  		}

