Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4351ECFD2F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 04:10:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE0886B000E; Mon,  1 Dec 2025 23:10:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7F46B0010; Mon,  1 Dec 2025 23:10:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA67E6B0011; Mon,  1 Dec 2025 23:10:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C9E076B000E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 23:10:51 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95A98132155
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 04:10:47 +0000 (UTC)
X-FDA: 84173204934.11.6E183EF
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010031.outbound.protection.outlook.com [52.101.85.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BC99EC000A
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 04:10:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eMnLiD7R;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of apopple@nvidia.com designates 52.101.85.31 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764648644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MFQAooZtdhmYeNFNa0c+LM0fzN7ob7MxTE1RV3RNgqM=;
	b=42OSYriTy+zXOqXAAcZzgOU5vNvKe4uipDMPfQPIu9jrqJ/JbTAMILoLOgO9NrBRy7yqaU
	MapwUKPVqpSRT/bxW1FnebBbErme0/Uvimrmk97ZkofePXqmdCwKKMk8bi6S3FiTP1wZ/d
	yxGvul4WsorR6+dhqMROned8D7ciuLM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eMnLiD7R;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of apopple@nvidia.com designates 52.101.85.31 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764648644; a=rsa-sha256;
	cv=pass;
	b=mnlhuSWvVXdBSWcZWtzFwpJ9fqLp17iw2sonZVxpTkadVJYfalqQnet8nEEUNv2hYvlbqd
	t0KQQ82Z2U/HyC9/bGC/916QW92+5nbJCkMC1juhUY30QaS9Uv78F0cRlofohqUl0G1Aih
	JCA4kJeX90kDH0Q3PONXiE2kFABM1nM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ejKHkhVyeAEOmUPg1V3YtmVsNZEfKGsTM7JvOzNHb8NJvKf9G/xPiaAREVX5+WScFr0lFnyMiTLLJkoikO+uxOtG41/spQZlqZi670NYKSRf/tSh3FaiqAko0mSdhizDhNk9eyXn+DmJi7PIUkGCHV4QlWbY7zYGIhM1D2XCHRuX42QnwMFCLATBIuomCLwZIUdTOroRdjnY5HskCxyLJKboAD5bKd3YhKOvJdLALQ1cvklLsMgzNprWg0TwZjSfp0hA0D9PdInN243oGTY2FKvzQpLxgRX5SyidE0Q6ndc8vefzDy4yWmSDKAOA82+QQH15/i/ioPuWZy1EQIkhzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MFQAooZtdhmYeNFNa0c+LM0fzN7ob7MxTE1RV3RNgqM=;
 b=JBd1Q5mAdvOUa+UBmgeVAJIGZeMQGdLjXbRovQxZffQ8LUda0Yx0TayERfeOT3ZkvU77yRvfX3vi5vzY+59rzsgM+GqMD1yp4Ta6++3XwEChfDOsLCJBO0WNnqo0SXfw5zkO8WKxhjoIk7CMewZWQ7qnkmZrvPjpiLRKqHHzoEV39Nd3BQhI5ifF0fW4C2Qtk0G/BPK2kjhnhGCEDoYNzpmUtlg56VV6g7CGSZVrTvA1A/UrETPxUtPqC+AIpx0F1xAtjH5/tU+zpJN1o8ogjwSVbFPQPS1o2/OkluGOOA7F2plmsU3749ehwF2aPAvTYBFO5cS1/1bm3u8KsvxpGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MFQAooZtdhmYeNFNa0c+LM0fzN7ob7MxTE1RV3RNgqM=;
 b=eMnLiD7Rs128w4IqavyAe/NQlaWkovFnA45wCxB36Q3assLb+J/hpOS/w7PkPbWdFJVb8Exhcs1PILdm2eXoE5VD+XgYth06Auoq2whlKI++ii4H6Eworbg64L65Z8icOTN+Z0JLxvoHRj6FYkOC12b90Jsli161ihrX+57DxUJVfTZnqeQUBKBXJNdcFNJfX+NQhdaNbhl5hoh8/9czdUEio1qg9AnQpfemYLE+l5y2htIcRB3+3oy+mUP0cn3Sd9tR8veMfJs8+qeV8uqLGc6VDKFpq1RccG4HzydC3sJasCiiSo98VQdyiz6cHIhspnhbq85sbJP0ohGDNqo7rw==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 MW5PR12MB5598.namprd12.prod.outlook.com (2603:10b6:303:193::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 04:10:40 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe%4]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 04:10:40 +0000
Date: Tue, 2 Dec 2025 15:10:34 +1100
From: Alistair Popple <apopple@nvidia.com>
To: Jordan Niethe <jniethe@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, balbirs@nvidia.com, 
	matthew.brost@intel.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, david@redhat.com, ziy@nvidia.com, lorenzo.stoakes@oracle.com, 
	lyude@redhat.com, dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch, 
	rcampbell@nvidia.com, mpenttil@redhat.com, willy@infradead.org
Subject: Re: [RFC PATCH 6/6] mm: Remove device private pages from the
 physical address space
Message-ID: <hurxchozs45ufuvp2qhj4d5qfhknfygeadmzgm35yzpdsfjccj@e7rulaymjhf6>
References: <20251128044146.80050-1-jniethe@nvidia.com>
 <20251128044146.80050-7-jniethe@nvidia.com>
 <20251128175108.GG812105@ziepe.ca>
 <1d4cb6e3-38d2-45d0-8e27-4f2b9dccd6cf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d4cb6e3-38d2-45d0-8e27-4f2b9dccd6cf@nvidia.com>
X-ClientProxiedBy: SY6PR01CA0082.ausprd01.prod.outlook.com
 (2603:10c6:10:110::15) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|MW5PR12MB5598:EE_
X-MS-Office365-Filtering-Correlation-Id: da51ae53-9af5-49fc-8998-08de3158c0f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1GWvHSOybU3MBRvh5nszzW6CbWbh08WQU5LLO/Gto0pUXs1RHw/ync5d6dsL?=
 =?us-ascii?Q?5NgdZL6gu1hiMm0z3N++/GUnJuZ8FipBbwusrxG6F+m3GmoxrmDSWwSiBz38?=
 =?us-ascii?Q?Hwl5rcUdKsCMrE9UHM2KcBdaoI4fQRCPoEv7OzqlM5F6HaFuseud1nPwk6G3?=
 =?us-ascii?Q?GqS0DsjgmB5urncsjMFAL4OsBmwMCrDO7vPbY+1IdDEGUEQujdRaqPQQZBjQ?=
 =?us-ascii?Q?IgSqwiFToOolOSIc2Bl7fr6+pz4ZakXFHaSITc5cCoCuNW7w7ofl8P3Iodgq?=
 =?us-ascii?Q?vZpSMZiNd9xUSWAZT4REW9re0y2N/AvoHj8i9dcMheE3cmvA6IPgPQB5td5q?=
 =?us-ascii?Q?Z28linAyzd99JwNJiq5Ghc1dyZ2n0rtAMgIU4Mo7aHP9iea7ZJq6LHDjL4uT?=
 =?us-ascii?Q?uaSSUQoC9Fci7QeBMWI0i/BirY9C25nbwJEmG9FmUPrFPdV/W2SSfRLnOgun?=
 =?us-ascii?Q?yKnCp6KDxQrh3H6HhJVBxi516rWSvG+wOPD7IQn3CYYYNX0rrRsPcrAnl2p8?=
 =?us-ascii?Q?TpgFwSW1XRH52BcWETYKxpwdY775hC4BBMriTsQd6goUEefTePqmVSlPlZsq?=
 =?us-ascii?Q?cfCFN8Q+CmWdBDjlxkBdmOXztCtGWjeUP04Lw1MV1cFNyco70MFp3s0zCZfW?=
 =?us-ascii?Q?XVmunOJ9+27WbCwz/vskiMrjDR0/HuPb9uRxStvp+aif/CoF1mkWucSXgy0s?=
 =?us-ascii?Q?zP2eAf1y1FssuUquUezXQb1tEjP5WQWDqRpcsGPdmAQz58bxILH+o6+CadJQ?=
 =?us-ascii?Q?QomsEeLufwzO6Ng0Zx3Qe5L/aTPUhBWFN++DuNPy6HvQEb+sMMf9LdDbV7G/?=
 =?us-ascii?Q?bmU2xb4AJytrDXa30EKxe9WvG1YlIfxuOrNYvvqCLSPvxV5skx3EniGN9cPx?=
 =?us-ascii?Q?v/RuvutZgpxqBwQBcIQIS1xui2EXD/rUp4w8N2qxHdqxIjiXK+lkRr8rPaqc?=
 =?us-ascii?Q?rop4lTRUICfjzrwm6ZrH30bTwpOaLImU07OXyvzoSaDIA3iBldCZ+rhYAfts?=
 =?us-ascii?Q?W2MWS/DxWibcVYgUfoIebzrGvZP0g2qhfmTMk/74HuIOr4HuBbRvJSgn6dk1?=
 =?us-ascii?Q?L639+C8O6dt+2elol8klPjj+6EEj164VFmDAGp6tw01S5M3Hu3NDJr30Lr9a?=
 =?us-ascii?Q?Ax98tTLDCNuuKYBgqw9QJgJihD/axqGtCwwd9PukmBdoiDuaceC5/oidJzPF?=
 =?us-ascii?Q?QBzYYHsP9LeiyLLIzRBa3ACiI35GgIjE0Qrpzw5mDbV5xuUMbzFIV70EB8k5?=
 =?us-ascii?Q?fizUPPbdDE1YWf1m6VeNYLgWMXDvoiR8jpqq8K27HkN8t66GZSzdwwFZoS8J?=
 =?us-ascii?Q?nhoYuCAZk8uSY58yYe1c+kSqdl0QrFovCrLmorliOPyX2knurmuG8bWNfTEB?=
 =?us-ascii?Q?QBd+slnoAyCqX0UZ9J9Ck891r5aTuZmLmomdnEUcKYSIdKD8O2ckWkyWdciT?=
 =?us-ascii?Q?gB0v//QsimpucUgd2egESbIgIBLCKpc5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ASbIa39U2kZolE00UdgoRJR9yRq8OLo/kIKDN7WODYHL5ZgWnVdYsev4Xqo7?=
 =?us-ascii?Q?1DBAvNofh0DS3gVGJyKyZTa/7O2YfMFuTdldIdIDXUHLyNqsUusk57QeAxNq?=
 =?us-ascii?Q?TfiYWfTpXJGrJ7Oe1GCxiFEvSiB/o0CCROBm3hShyI/IKqDTP3fZA8Zk3QCM?=
 =?us-ascii?Q?E/UbTICuYUYaZCUBBx2niIyUG2VxXnhs3tgHhpz/TQF2Rz324xE2gRXZOfX0?=
 =?us-ascii?Q?VhDshNMThWKtr7CI0H/oY8IDdxMys9cnyg3fOs7z39I7yl45sjuTGYW2UsbY?=
 =?us-ascii?Q?qmr1FEcEt2WSPThVqOmjMBIZ9rxhUaclkthCFIvVDxPgmY9IDIw18+kXHQVC?=
 =?us-ascii?Q?EWtBDttNKZMsL7bawtxz/bM2vdhjgvGE8pzc4pPEymOMdCywF+VmlJiDqKVq?=
 =?us-ascii?Q?tMOScJ15mlKcwqG66owYBE97hi5bk2RFiMIERTFMVrglJu0r6+Z7yBM4YIAu?=
 =?us-ascii?Q?JfDczINkdpAGJkO/PNEDW+ZQpeo5wFLTWzPuPEnwdJXSX56od9pvBh5NS79V?=
 =?us-ascii?Q?Q6VLvBhUMvYBQmv/SCwvvdXHhD3uIM9/bHVeIINKT/X3LMh+AbrajFyKPgE4?=
 =?us-ascii?Q?0dJSoQQiVjoZo65KxwbOGRrKb2eZPlJC/fxozNSWZ3N5Q77UKymqKtiwbSDS?=
 =?us-ascii?Q?UgD0dKfv/qejoNDYuokhmcmWX4VwuMSb5Mkcs1hqHz4VjkP9vEqaXPP06MUy?=
 =?us-ascii?Q?T9bU7YP9b4OaTJk0jQxZ1ZXGOr7E3ZaY4ZHgsGXybVE6Omjnnj1eMJlPaXTh?=
 =?us-ascii?Q?wBiV8S9CJU9Sl9MPbHmkjQToUOrNW8DBwQlPh1R2aORdfs8UBT3kq/fqDPJA?=
 =?us-ascii?Q?gIhKUgAtmpTnWLvr4xkC2KVGbb6RKyf6o+0+fQt7kmFcLZTTYcuqZ8fExRsj?=
 =?us-ascii?Q?aE7Pr0mryvHgkgG4Jkt44xk73i+jaanMY3Ai6ASHOaYNFGRvYUj4qMEtNQc7?=
 =?us-ascii?Q?BWa1WW7Mf8j95YDD5jUKUs6JYjmBEzYzxWiEMLNf+jC5SdzBslyqnaqUSCgA?=
 =?us-ascii?Q?lMzxz/3pF3pJ+lr83Opj3pG8pKGWp6mHaBZEz7EQ+gacZvvoGAk1iyggFOsI?=
 =?us-ascii?Q?su4/iOA5EjrKToEzoOwB2VQ1v06vIyipjKB09tkCImSPwakWeFUzcU1fi0/h?=
 =?us-ascii?Q?Nt0iNut0SEqI7TY/M9cssXUNDA/MGOxOnhx8X/kg579+hQn1oM6jb9lhQUwC?=
 =?us-ascii?Q?UmZ2F4bgCO5b2RyH3UOdglxRmWf6KDIzkcMlQ1TDAgASBo45bclrxUUrCqBd?=
 =?us-ascii?Q?1m9baQ58NlWcfmCi1v8zzEeFLEnx3P1EPPemZ5j9r2bo4NlTWNMaeII3i3ip?=
 =?us-ascii?Q?mGM+3SF5wVKPpyhxznhb2kmUTQovDkAcnz9eleOg1J9hZmgCIoLITlkGiIj3?=
 =?us-ascii?Q?9CMMaoraMNUJzZ4uoWuarBPGV4b1JTB9wbLePlqcgywW9xMH5PBkWjN5aCD1?=
 =?us-ascii?Q?MtfWPCUM/1csb8QhaXMiK+ij0Yt/GTC+t1pl26k3NxdlvnxRF2VlUNX4Ouui?=
 =?us-ascii?Q?qaWPwpiVapsqG3TyDXusa+V2GbAYm14kJ1LQXd3ca38iuKbBVexwzJh3zBjm?=
 =?us-ascii?Q?R9lN452Qwldi01t6Vjd5eWB01uVfCVDFpPmNv0tR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da51ae53-9af5-49fc-8998-08de3158c0f7
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 04:10:40.1246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qSy9AfsliBJQd6rH7rXjYN+7zpngYXrhKxO4c1MjIHUOoWClpHRqHeRt3GfchKMGqlTMnKpPUdGdgjnfzUf2xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5598
X-Rspam-User: 
X-Rspamd-Queue-Id: BC99EC000A
X-Rspamd-Server: rspam11
X-Stat-Signature: fp8z895mswbwfqipwxred78nmcewxpkd
X-HE-Tag: 1764648644-723358
X-HE-Meta: U2FsdGVkX19sM1T55/Caw56U+lom4V9Coq5bZEPWopyxzL/865w9vy9ba7vMdpq2Ia/kU0tlHgM+GkP4rxxn7m0KhKRMlQFBLo5Sq4hvPFHSBhR8l1hQxolekvZrglWaJI+KN+0J+qdNlhmA+yxZEchB4tpO2yZq6P5tgnDgHu5lgX1IuU4yjBwdrMdSN1ATltdqjNaAFyQmQeYxiiom+2Lb+UBrOt5NzWZe2CXq8AaA6+Y7/RiMW+R6DdqUeuFe49tMwZqcxG7TCudokUvu6NDycmQgtzT8edgD4/HXxgfsKiuFFA6uSYsIESasCqj836au95VULEIh+xHGwgLsgsaEvkHZhiCNzneTjNsxmtFY4dQDXQP0K9XgokDtZF/Nf1sk5G4QpBS9w2a2CA3jX0qiRReUariJhieqGK7NubKodpuuxmMVZyr6IuLjDgrZlYPOqOwoVM5Be09zOZWBZz1cMYKr0bBMfaxCfBnNX2nKrL1XaCoL3MF7SjBpS5WYmQEkAGxMaohzESdTpsw9/7cabtEEfPaKuEWthhKhU/joyCLLurcMg3cJTlOpyXqbJosTac3y2HJy+UzspIJq25hNV4+uALWUSwFOtUia6G4V5ySxvB2vNZgJfHVVZvFnD0gopVcRpFgZ87d6tDQ3/vMmJglm5dkc1tbVx5OTlLQGztV+kFA+zTppa06qqwYvjGWOwgZbjO2VCEEGAd1dNMF2CfeO+2bidbhP5mCdtGkTPRhkdW5GA7M8t6F9SnH/Tf4B8JOJHroqxkQ+OSHi5GeCV7tOzWmJaubtEbe8Gcv3V8aN30PfVLFFQB+laA6cHN6Dt8+l4OLrRt/ohYDB0dj7fUkcAsgTXTLq7Pc1/62vZDNufB9cqsB4tuDYXStXaDs3KUqE/Kra/LPsPpjKGjC0/loYkoiJlgob6/sqyBoPWvOUOJoFqVtgK9dKZXfuNB4UqSXRNewgQ7hWoac
 dhck1btX
 5pNthWipuee8Th2EA/mJ2hcw8I6PTju5JDJoAu/R3Krzk7ck3eK9IpZUDKbNONi0OMfE9nJKP1s06j2elHtIPVhBQo+s5/XPha8ZFJ0CkGGuYEt0ZdkiyrzQN7vLkSTOm4QpUmqZmrWTexAiVMMNNiuc2rI4Wi9U31ibpWYJZIlGVO+EyfYr10Gzntp1Df96cdR8Viy2unbsippONd7OipYa1pkXYnAFxUR6fZ/MeRbr+64bB+t6eEtbBfkFULu0C8VFqRlkdUKof0YeQ8FLWgqhoQexa5dBqEmn+BwnZjmCWs/Am8ux/KxvXPcCgGcK1MJ4QmtO0F2AWpFVAJA/78Trh4rKLVW88ThEBir0PQC/k84ilW2KR0PbX5pJdw0fQNMmsNiMb3xjT+FzYY71iQ1omMSHncYRnUgDtYihK+7+vmxCYRFdgxakeFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-02 at 13:28 +1100, Jordan Niethe <jniethe@nvidia.com> wrote...
> Hi,
> 
> On 29/11/25 04:51, Jason Gunthorpe wrote:
> > On Fri, Nov 28, 2025 at 03:41:46PM +1100, Jordan Niethe wrote:
> > > Introduce helpers:
> > > 
> > >    - device_private_page_to_offset()
> > >    - device_private_folio_to_offset()
> > > 
> > > to take a given device private page / folio and return its offset within
> > > the device private address space (this is essentially a PFN within the
> > > device private address space).
> > 
> > It would be nice if we rarely/never needed to see number space outside
> > the pte itself or the internal helpers..
> 
> Outside of the PTE itself, one of the use cases for the PFNs themselves
> is range checking. Like we see in mm/page_vma_mapped.c:check_pte().
> 
> > 
> > Like, I don't think there should be stuff like this:
> > 
> > >   					entry = make_writable_migration_device_private_entry(
> > > -								page_to_pfn(page));
> > > +								device_private_page_to_offset(page));
> > 
> > make_writable_migration_device_private_entry() should accept the
> > struct page as the handle?
> 
> That would be more clean - I'll give it a try.
> 
> > 
> > If it really is needed I think it should have its own dedicated type
> > and not be intermixed with normal pfns..
> 
> One consideration here is for things like range checking the PFNs, the
> logic remains the same for device PFNs and the normal PFNs.
> If we represent the device PFNs as a unique type, ideally we'd like to
> still avoid introducing too much special handling.

Right, Jordan and I went back and forth on this a little bit prior to posting
but in the end I thought it wasn't worth the overhead of a new type for such a
limited number of use cases for which the actual logic ends up being the same
anyway.

Getting rid of passing the pfn to make_writable_migration_device_private_entry()
makes sense though and should address most of these cases.

> Potentially I could see something like a tagged union for memory indices
> like ...
> 
> enum memory_index_type {
>         MEMORY_INDEX_TYPE_PFN,
>         MEMORY_INDEX_TYPE_DEVICE_MEMORY_INDEX,
> };
> 
> union memory_index {
>         unsigned long pfn;
>         unsigned long device_memory_index;
>         enum memory_index_type type;
> };
> 
> ... if we wanted to introduce a dedicated type.
> 
> Another possibility could be to avoid exposing the PFN for cases like
> this.
> 
> For example if we went back to struct page_vma_mapped_walk containing a
> folio / struct page instead of a passing in a pfn then we could introduce
> some helper
> like ...
> 
>         bool swap_entry_contains_folio(struct folio *folio, swp_entry_t
> entry);
> 
> ... that handles both device memory and normal memory and use that in
> check_pte().
> 
> Thanks,
> Jordan.
> 
> 
> > 
> > Jason
> 

