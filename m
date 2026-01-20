Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97711D262B0
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 22:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED1866B0005; Tue, 20 Jan 2026 17:49:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7FA56B0088; Tue, 20 Jan 2026 17:49:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D61436B0089; Tue, 20 Jan 2026 17:49:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C8F186B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:49:30 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6A246B9CF5
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 22:49:30 +0000 (UTC)
X-FDA: 84353835300.28.0BD4A45
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011069.outbound.protection.outlook.com [52.101.52.69])
	by imf11.hostedemail.com (Postfix) with ESMTP id A0C6F40002
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 22:49:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pzFjVKPY;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768949367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NK7tgxfamwfCveW5PV0ogxgKGLJi8Ylh91Unv6sJGRk=;
	b=XXb+HsVQpPwmeiFnDxWbq9bQyHHdw2J2VDIkLNRE1C0t68FIk8yjIaUHY096Mn6pdhJ3sY
	T79qHWkvJdkTYavhEMVQbDOIUa4+U4JI4RWNDqVyvRPfiT5sENVgHInfAHk4nYWv/2XX7A
	x1xLapJvKMiGubeT4Dy3ozynGn+kx4M=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pzFjVKPY;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768949367; a=rsa-sha256;
	cv=pass;
	b=yAH94Wbg/ucF3arxRhVyvbXNQ7YUQfAtdwETno0e2xGNxNAdshwX88T/6dRTr5XhVJ8tMf
	q5SqzjOe/DjxhiNCX69XMB5x6N6WEGuvWFOyWwM/RViGfMNlT+8+0NDeNhaa6BRW3rDV8X
	RtCwTV0xN/52Sbxj0cM3yLEUw2cnK64=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tZ+zeAhgS4wXx/6XGGsxkI5irHoY4Y8bAhaTClVK58QglU/P7mfDzf95EpijhFwCgQ3kX03VOHW1rOH3AcAzXq3CVbpvua4AaskjI71jSBJrWHt6loTHXOLDL2TU4QY2/nXKLXR5AkEQr9WAgknwL9lFWVB7EEkR/lFTQPaWyiSjHMR9Nt230/RqWB4gk0U7Zxs24waqWSw2Uqvokmp2NWcUZdJnV+pcyQXA11IhJD7bcugLsarCATtVSNZVAflREWkNl3y+qa4l46kgmCqO7nNSBqjLJ4siGgpudvdhlDE8RyIQyjbIsSET3rsENMScIS3spBFYsB2/mSLPgYIe7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NK7tgxfamwfCveW5PV0ogxgKGLJi8Ylh91Unv6sJGRk=;
 b=VlMeg6CRkhiss/ECgHSNybDjtvBOJ0zms5EYsDxKyg4DSyNk8EWL+uhLZkyc/aNUaisWd5ds9z0cyNjg0kAVd3+WLRbZ7dGDkUjTdk93a7ueRsbDxKAhsOD9aFHO8zM8RveC7nfJ2miXxvrPWFofZCNMNB/mHfP/FwRKJc1y1iAVvQkJQhng01z47JesVGd7JJUmCdL4SHE4bJpTD9DSqECd0v9hfZi+9CNZS07nvjAZyvNM41OQPdrO1nR+7G9mdtCjRfKAoolMpObCpmdTCgXB742urQhTnkUeNAwiclj/pGvIJateLPD0ZckyYcmjMVrtsd+Bm6Tfz9HQd6WPGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NK7tgxfamwfCveW5PV0ogxgKGLJi8Ylh91Unv6sJGRk=;
 b=pzFjVKPY8aT4JpFWXnKVC0yoRGJuRF66JhAa3nynD0aKt6WIBhX0Z82iXxN4azU1n47lRgiiuX9N1wckn6Y7z/UDBJEuoXFXMF82yXtgkp03u4p4lnKe6I3k4iCUBk1L5J3B8nVcZ8rz+5/abdVbIowQ/V5pozxOPa8ro2Cb+5BAEeilFswgZt+iO857aB5QLEPQ81JD+m6KHdDD9ZaZYl53FWxTbLh9nLG4r2BhyD48lOLthJsOydsnfhY5pV0N7YXtkHOXGuIPFWyseChr+oS0Yzw5qnEprICvoHwybxqKanloay6KW/A+6Mp+ewUK1gj9vg1TFD7bfyd7Bs1S7g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA3PR12MB9090.namprd12.prod.outlook.com (2603:10b6:806:397::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Tue, 20 Jan
 2026 22:49:23 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9542.008; Tue, 20 Jan 2026
 22:49:23 +0000
From: Zi Yan <ziy@nvidia.com>
To: Jordan Niethe <jniethe@nvidia.com>
Cc: linux-mm@kvack.org, balbirs@nvidia.com, matthew.brost@intel.com,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, david@redhat.com, apopple@nvidia.com,
 lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org,
 airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
 mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org,
 linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org, jgg@ziepe.ca,
 Felix.Kuehling@amd.com
Subject: Re: [PATCH v2 05/11] mm/page_vma_mapped: Add flags to
 page_vma_mapped_walk::pfn to track device private pages
Date: Tue, 20 Jan 2026 17:49:17 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <4784318E-D6AF-471B-A2E0-8B04EC0A238E@nvidia.com>
In-Reply-To: <e28edba2-889c-4590-ab2c-6ff377c36f05@nvidia.com>
References: <20260107091823.68974-1-jniethe@nvidia.com>
 <20260107091823.68974-6-jniethe@nvidia.com>
 <FAA66997-D211-4145-A49A-8A21E0FA0376@nvidia.com>
 <e28edba2-889c-4590-ab2c-6ff377c36f05@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY5PR17CA0001.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA3PR12MB9090:EE_
X-MS-Office365-Filtering-Correlation-Id: 88f83e99-4a56-46ec-d745-08de587627e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WOOZhAtYZbUOU/WrKzghqmarwNWA5H+nNF3TgUgYSNIctKSoYr3t6edNqSte?=
 =?us-ascii?Q?vO975lMi1QmYlZxxHvo4SmKuKnYWcBeDfSUltP39BGLsfDzJQ29fCs7it2ib?=
 =?us-ascii?Q?PXzN/Jicr9hdP3QspQfqScDZkwp7AMebSrrCS7v0NJQ+sQgGpWSz/HwV9tM0?=
 =?us-ascii?Q?aLuDSe6xrAnWRa3jDYKsC/+5AaSNlfIWw7F49TbEEDVVBV8h5+1wZ8ktmyFJ?=
 =?us-ascii?Q?3lS7uLK4sPpd0q8BKCkeQGrdBP+9N5S67TYPZrQidNKnHF5hG0ht4urmohyP?=
 =?us-ascii?Q?kyHmWorRr0suQdVlOaSlsjIeDX1lCBiSU+/wNdAyT6lCr2tiDtZleLfjGwcg?=
 =?us-ascii?Q?nR0/PS5g7gJB0u16rtY0sn/HAeTx45X4FEaYDOn+u4JsDPqq+OWt4IFxvaIM?=
 =?us-ascii?Q?BckHKAifw71MMp5u0nLjGzVg/SMo9/IfeyXvWi8AbcpZi4MOWSfQHbKmkmG+?=
 =?us-ascii?Q?XLfSGo3QaX3CL9I8VkUlfHuz1uOAzctU9qKZv5p3o1ZuTrxGFenhsAkedySo?=
 =?us-ascii?Q?QAo+CKMXzwzjUKrERqWYwjz43vaUnRvj+j+aJPWeTjjQOl5VOPstdbnf9seA?=
 =?us-ascii?Q?ebNztqfpG3PMZDyViRFUl9vsgsFJnz6Cvcx97bzB9VNGXdweu2dq00deLhEW?=
 =?us-ascii?Q?KApyDk9T7bJ1eeZa4nlz2AffN4bEkf6iveiTo2XcFrgqeFQ1HAepIYw8eUF/?=
 =?us-ascii?Q?lXTLX2zO/QR/CLVlwvQPGyNa2kCxUZpJkMZb3ymmup6sNL71tHROJWVrw+9b?=
 =?us-ascii?Q?oPLYZPvN2jY816p3S5ofiQdb2MTaK3qGKT4pesgWhmTuXW5+s7OO7juqqtS+?=
 =?us-ascii?Q?s/BD8TFPEzJ+IlM6iFmh42XbCynEe8ynYL0nmo5YhBSPHE8OPLdm2z58zwyt?=
 =?us-ascii?Q?TFmiXlKrOFGp/w43JOvZ4h67aVtJpoJ1jmkh0wUWPnHvsOMe7XOrdaZhhsOl?=
 =?us-ascii?Q?2ne5w95HYpaad2CZPDUYGSgrh9QKPCMlz8wPk7FbudliJhBmbGA407azI5CL?=
 =?us-ascii?Q?Q/DoRcII0GvbraKUykhRqL6qoSZrSy/bGXzrqFie6h+FEK2yjggRWcP52/a+?=
 =?us-ascii?Q?v5BMiIoDlJmn4zgZw6dhhLy3Ho31n9gTtW6VOIw/8vTGlLDNgtdTqXcrz5X2?=
 =?us-ascii?Q?mH3sjIQr973ZhoSLU+O6JK4Q8VCAUU7XhToZxn/4Usd/YZmX+tl8p016e86z?=
 =?us-ascii?Q?a6s04uhzzFm3pJNEVptoW3iW9Rjxefm+ltyDkKTIbjiUKHn8iSIR6giyglaa?=
 =?us-ascii?Q?v++q/VRFXh9ZA3dDB8/9a+k4e3H+EUSS0883kCDDTj+RSNDsuPhbyQEVr7wH?=
 =?us-ascii?Q?ncxr/onXtQsWCTavH/gFGBJBiYZ+FCmhkChaT77kTquOEtm66RMhsa99EgJP?=
 =?us-ascii?Q?Jdpl8IxasOxDRq/7YpGrAZQqpnmSrCshuzPXzwkcX0QlbjjDv8tnmFxzwLug?=
 =?us-ascii?Q?zKjlgBp7hBcgBh1FMlbnjX7+f16YBM+nqpB3mgUnxYWI5IOgh8ma7SZEWPtO?=
 =?us-ascii?Q?qRPHE4Av1SUjg5MVXWNBop9E7kjhDJLrphY3goeI0CHBEHh058rQ8dMGycOV?=
 =?us-ascii?Q?c6utOhB+UijCs4Ax/U4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yWhf/MPnzJbn6582+BGRRdL1yzCRRVOP78s8T8E7HLReSy2DHznDDUwGdxas?=
 =?us-ascii?Q?xn/Reig/rtBlRtPqS6HfI1QUcrlAfiWLRfgGNgoxeNBJg4Fuod+4Iy1f7dHS?=
 =?us-ascii?Q?r8pmREmZ7QNd+1nvpkHFRPeGPa3oLpjp87FfKX+j82HvfeLWqOxFvNbuNhpc?=
 =?us-ascii?Q?usgVYA+GEwSadTEp9m0v35eNVAfJjzQKxY6cyk/dWN7BJaD/SWKci2cXBhSf?=
 =?us-ascii?Q?dt1Fb/jcNUeObIpvdLtfRUqB60chRZqVrqiHVP9KtDKrDmr/RNdR1Qj34/PF?=
 =?us-ascii?Q?rQbJvlveev0kCdG9OkGuiWtJrSV1vjLx7z73z62ZCwUnw699fi9HBcR7J+jc?=
 =?us-ascii?Q?nawrok7KhpRzbdArXxfIKA8wj37oQFC6L2L94SYzdh5TQoYBgeVAfnlzt4lY?=
 =?us-ascii?Q?mFjgYNTU0JWx28X5a2x6DCMitxsPtfEBcc6U9yZ9xKRrO3p3ds7bL/6BqT+7?=
 =?us-ascii?Q?6CbC+qIhhahakhBeLybggc+CRSrNrC9SnO+Ed2OlbpKi5KK7wNA3K8EEeO9J?=
 =?us-ascii?Q?neYcDNlaIpAT8tLJwO0z62SuzNIjpIisB0Yas2dR02lNKDmTWHSzf+KVaKfe?=
 =?us-ascii?Q?kIsCAI/ZmO6kIk49x+oBEOeMigpIsNN/NKbefyKoZZgczewxvfBZNeJ/nnQb?=
 =?us-ascii?Q?xHt1X3Bqg46GVNXXW8i47IY3XCBo5I2/ZkQUU7XZ0tqLP0h/i5b54yHbJbV3?=
 =?us-ascii?Q?9mIWKcyLUW9D07K5oUwUlEGrZdiM9lI4n0tSFtuCV9CZ7hSLyBb7w4TxFUjP?=
 =?us-ascii?Q?g1KOA1rtOWFHqEiAE7RV8tLixGbKV+pnyUi1nqToGMagxkAdeAxnl9D5K1NS?=
 =?us-ascii?Q?+R/Oip4si5BH3E/Quhm7vLTvZBvalM7r7d+JALYoMn36zkK/HzlQzKYkxYn8?=
 =?us-ascii?Q?IiPFymq8K2zqrtwJQE3lIIwFWTi4fnAbc4FkOPEeoWtt5526VROItW8eiN1s?=
 =?us-ascii?Q?MpiZbRjtRF96aiqRe417WLA6TJ0sIIU5wFPOnrh4M8ph7B/aEP+96/FVfygQ?=
 =?us-ascii?Q?Tg/Ve9uHdYGtQxyyHVDnebe9KVdNFCU2Q+/Dfh6wLIcBRA2pknS/obkY/ezc?=
 =?us-ascii?Q?+xaVyh8NirDnIYMsvIwVWnx/FCm56ej7mZJjpEyG8ITPu1GGs8Rjnkqw8sIT?=
 =?us-ascii?Q?RoDi0fIW/8rCv4Eh8bt/5D/6N6jeIh88d1buT4oZnmMEbk1kSu74ybyIK8ZG?=
 =?us-ascii?Q?fSE8wzQV6+TlVJdZE9tJ5MXj79Lu/DzwCrv1+vEb9YxkNQ0eeclRazCWXVyY?=
 =?us-ascii?Q?lU4uqnV8EU50Rqsn9+Cd8NETbVtQ/UZQ5N86cMhCdXVW0BezpfkA0cUsCsio?=
 =?us-ascii?Q?cXSLpN5KBaCBvZiria31y7eP/yLbRLUOMtnrKls9rfskPfStHUFxJQTuubK1?=
 =?us-ascii?Q?JDHaI8IGBPn1pwE6Rtsc2DeBaPUwXxp9yyiieFViSM3/Hsuti1SW+n4EgHJ1?=
 =?us-ascii?Q?jG2V/brNCHokl20d6Zdhn/wq/p/CiPHQffDhNq70j3zmcF/vqWjYdGDT//0r?=
 =?us-ascii?Q?RBFidg5m9IKHWbdSmRqkqZa8b3L6TAAe/e66DV+xSaAGunNqevM4hL/4i3wb?=
 =?us-ascii?Q?jLn8jXpv9pfQaEKB4FmObD53Pw+JZgy7DUeDvX7ZCTAq0tJu831AE+2mOQN7?=
 =?us-ascii?Q?UajyrOG99r/fZBDVsI3MDxocRWmf9zA/3xkIn8feDP4Cos31yJEufoKdrqON?=
 =?us-ascii?Q?CMtjcEOnxWPHimqLvyT3ryYJPN5XVr+0BAmDQ7/V0y0Y0GhS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88f83e99-4a56-46ec-d745-08de587627e5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 22:49:23.3443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bVy+A6oO9C8bdfiZTCzJDUKJB8dvMbyroDG4FKqmd8baze8Qz/et3Gq1btzvP6jR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9090
X-Rspamd-Queue-Id: A0C6F40002
X-Stat-Signature: edfuzymkm4oq4g7ce988wbx4fih5xohw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768949367-417685
X-HE-Meta: U2FsdGVkX19u7I26/t9dCxWNJEA4uN6cwfNAayDaLBGn0wsK6l3qAgC/rTleSWsy/2ke1RToKIGBSpngtq/BWQVrvegYI/Mclsn7+Op99IjqWKbYCwFOYpGcB2yFKCepn4vR/Lg6+ECk+O7iCXSGAo1DgN4rAVO2z/eei8wH8JFDSCFDPyHQCjic4faAWYTYldrBoDo1/i0/k3JEBd5Tf+GI3N4vMJ96JIgG7wnbuKeNOpZj0kgsPH+hpFPSJy6MHLMeOHNMwZyVLneyXTGGl+KuJ0uarpMw5dLoEBf4fLwFEJQrBQf9lJ7a99wjsbvGEetvW2rADhbPKmVuX5eTZetqHucq/3pUTbHRzngf5NhCxcJ2pDUxunMuF64OfjkHPKpLjQrjMXBBv/gmMStTi0LqzqNPf7X+BqHuxerJYAWSYFOE6ZGQbKV7wUJOZwMLexjrY5AwTHQ7vgeeONLluZpPPB9A8VhJmIn1rPcyS4Vb5NdOXks1mVHA5ffLl9hv7mR+0GzYDvN/XpCuRh5eFxvAtSu6l68iKr7Cxa+xnAEA+fpZLWTEftTB800LTrvG0+RoLd4rkeyQLGwLurj1S4aFjGz2vOQNg+iWjxJshb6+mmv1CoqxQUMF4XBqZjk4EcK5Un7z5Fxw37UqEEVuoN0UI+jLDsKJ47wcPO8PRQEG6+2/r+Q3hPMmrkPnE702zwLrHNzGDZsU1kDhg+CA/XXswbv6pw8v1mPVtmhs4YLUynQ4FsCjJg5ylIjnHxQuOYvJzwc8/QRMhgwYXoub4yRwczWCLcGK0ozqRTMQh1k0uTMYKtEZGdR80HOqFA2swYWISJ30NUAqpvVqk1YiYGmojC2JmJUdZ15lRj6g3oIdXyku/qtxMgJntG9RQuAeDBh7v/LdOKXZpBubSaqBU+iWZgf687u/iAOKNd4l8cLHL7D3QF4q3qLLnyp5HcOiBrOV9v1a86xf121gD6p
 YxSw737l
 GzEGW+QG6w2un4rwt6Cyr+8LKk/Xfo8jnuEFnIOqoW2n2ConP2w8U4FnjQjzOhpyoeXJ10wao9EN5BkJK4+HyFZMriVIhzPt5pLPZxxQ+j3+uAvv2QCPHXVqeJPopxp7qM2S5j89UP4HteWjUBGY+eR3F139GsNLD0OtEPIC596whA/FtHMwC9wlstgXHqmkDop00nxmiqBn1T0QCroFuI13HufMphu21Y6mKcy+ctrhk21cNKo32QesG2GHrnfykh5/69sYHj/iLXyBxtDjj1n8lbaWzY7KhgVyXD91oBKvIXkqDagFRF3GQ+Z8uKj9Xo/HcVkiHjXNfSMCAKfOeBASl8nfSTlBqbvpbtn1+UUNSty6+Gmgii35nF2XPgoq3nsQyBvIZGu2Snu12NND2sOP5CN90Fs6SOuy194Sw4J2WkvbNwHj0/o/85X2G4J/5T5Q7l3Ucb2Z5PPinT+0/a9v0Eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Jan 2026, at 17:37, Jordan Niethe wrote:

> Hi,
>
> On 14/1/26 06:44, Zi Yan wrote:
>> On 7 Jan 2026, at 4:18, Jordan Niethe wrote:
>>
>>> A future change will remove device private pages from the physical
>>> address space. This will mean that device private pages no longer hav=
e
>>> normal PFN and must be handled separately.
>>>
>>> Prepare for this by modifying page_vma_mapped_walk::pfn to contain fl=
ags
>>> as well as a PFN. Introduce a PVMW_PFN_DEVICE_PRIVATE flag to indicat=
e
>>> that a page_vma_mapped_walk::pfn contains a PFN for a device private
>>> page.
>>>
>>> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
>>> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>>> ---
>>> v1:
>>>    - Update for HMM huge page support
>>> v2:
>>>    - Move adding device_private param to check_pmd() until final patc=
h
>>> ---
>>>   include/linux/rmap.h | 30 +++++++++++++++++++++++++++++-
>>>   mm/page_vma_mapped.c | 13 +++++++------
>>>   mm/rmap.c            |  4 ++--
>>>   mm/vmscan.c          |  2 +-
>>>   4 files changed, 39 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>>> index daa92a58585d..57c63b6a8f65 100644
>>> --- a/include/linux/rmap.h
>>> +++ b/include/linux/rmap.h
>>> @@ -939,9 +939,37 @@ struct page_vma_mapped_walk {
>>>   	unsigned int flags;
>>>   };
>>>
>>> +/* pfn is a device private offset */
>>> +#define PVMW_PFN_DEVICE_PRIVATE	(1UL << 0)
>>> +#define PVMW_PFN_SHIFT		1
>>> +
>>> +static inline unsigned long page_vma_walk_pfn(unsigned long pfn)
>>> +{
>>> +	return (pfn << PVMW_PFN_SHIFT);
>>> +}
>>> +
>>> +static inline unsigned long folio_page_vma_walk_pfn(const struct fol=
io *folio)
>>> +{
>>> +	if (folio_is_device_private(folio))
>>> +		return page_vma_walk_pfn(folio_pfn(folio)) |
>>> +		       PVMW_PFN_DEVICE_PRIVATE;
>>> +
>>> +	return page_vma_walk_pfn(folio_pfn(folio));
>>> +}
>>> +
>>> +static inline struct page *page_vma_walk_pfn_to_page(unsigned long p=
vmw_pfn)
>>> +{
>>> +	return pfn_to_page(pvmw_pfn >> PVMW_PFN_SHIFT);
>>> +}
>>> +
>>> +static inline struct folio *page_vma_walk_pfn_to_folio(unsigned long=
 pvmw_pfn)
>>> +{
>>> +	return page_folio(page_vma_walk_pfn_to_page(pvmw_pfn));
>>> +}
>>> +
>>>   #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)=
	\
>>>   	struct page_vma_mapped_walk name =3D {				\
>>> -		.pfn =3D folio_pfn(_folio),				\
>>> +		.pfn =3D folio_page_vma_walk_pfn(_folio),			\
>>>   		.nr_pages =3D folio_nr_pages(_folio),			\
>>>   		.pgoff =3D folio_pgoff(_folio),				\
>>>   		.vma =3D _vma,						\
>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>> index b38a1d00c971..96c525785d78 100644
>>> --- a/mm/page_vma_mapped.c
>>> +++ b/mm/page_vma_mapped.c
>>> @@ -129,9 +129,9 @@ static bool check_pte(struct page_vma_mapped_walk=
 *pvmw, unsigned long pte_nr)
>>>   		pfn =3D softleaf_to_pfn(entry);
>>>   	}
>>>
>>> -	if ((pfn + pte_nr - 1) < pvmw->pfn)
>>> +	if ((pfn + pte_nr - 1) < (pvmw->pfn >> PVMW_PFN_SHIFT))
>>
>> Can you add a helper function for (pvmw->pfn >> PVMW_PFN_SHIFT)? It is=
 impossible
>> to tell why pfn does not need >> PVMW_PFN_SHIFT.
>
> Sure, something like page_vma_walk_pfn_to_offset()?
>

Just page_vma_walk_pfn(pvmw)? Since the code is comparing with pfn.

Best Regards,
Yan, Zi

