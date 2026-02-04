Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59104EA7943
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 19:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C23DE6B0088; Wed,  4 Feb 2026 14:48:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCDFD6B0089; Wed,  4 Feb 2026 14:48:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA27A6B0092; Wed,  4 Feb 2026 14:48:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9ADB56B0088
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 14:48:23 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D0C9C1419
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:48:23 +0000 (UTC)
X-FDA: 84407810886.30.0A361EB
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013040.outbound.protection.outlook.com [40.93.196.40])
	by imf15.hostedemail.com (Postfix) with ESMTP id 53A8BA0003
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:48:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ureXZQBF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770234500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zpRrnPLlno2rvzaP1mRJFswLDrb6mYPsAxHQwgyH00U=;
	b=6enJoxnH3YzJk8MyjZI++QSOsOqeUmN8BFhlJ8qr0M/G87cvFTxw+1ltBM+kGijequiEBH
	Mt8R1Cha5/nH9JnTcZwBlyziI2l+lLGscXSOl0Adrb0UjluzV9wFZg80E8g88KTIEDZ0+Z
	1hXgBSTpSgSUKfSK+MeQUmEpmTpOBzw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770234500; a=rsa-sha256;
	cv=pass;
	b=MwlQwSCysW9Q+XJJHpEcOBgQufrEYN3bRwcIgjC7GxHhMhiXdLbr0e4jcxwZD6QTnUeael
	YL6uurtIGolLE9QB4hOE/D0an2I0B5zzW1GD7IzutzwafVclF3YAStGdPLuSBxNfs5KRgW
	LDSqLty4i/dOYmyIFTXgrjXwMh38kmk=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ureXZQBF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NJJqC34vVFOth+tdclmWBh29W58hP5vHfgU/N45W/h+HtfEhhYJejfpbMkiwhvbFc7qPL8B1TyTDQmCwsySfwMbtyklLF45y3qg+BN4rL+auqY58IOkzC3rzMbzhicWH0Iq1cCH2nGfVP5U5EJxUAxcs0bHm7QVgiGvMlb3oPdw1O2D0XWhKAaKSXWt+mPSd7SnWoZJbVAgvqK5204jE6n1y4C7qIzOnMHZotxLO5XEGPoEYBjWU39k59Z11uMemJ+hsZwMTvxonOPDyLAk8AJFyKk4rElZfUSuuxnuJ4VSEc7OiiLUvl45bhD0d3euxP3XiMcVUCEetUexX1B6KxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zpRrnPLlno2rvzaP1mRJFswLDrb6mYPsAxHQwgyH00U=;
 b=oRHUo5vieHI/0jaUy+G2o68lEBlZX0cddy/jYWi4qn75brHD/FpeWP+jjJ/fdpTBUJnNasVlk7iAohqdRPuumeA0YBgMLsrN2Pykh//UVtODi2kpuTcxAJXEfAlwCSDpgR5w+t3F/UtP4fCfeBCoVN+3eWu1ksXlqTRfOl+ALxiczg6QlRutol7IJUCl3tJVSTvkWC/bfII3d9VzxLsgWmWVzGL9l0pqUkpZLIleBDUODSBunl1ZvuohpNDJpZW7vcCF6RhuIyfK32msDG/Wyh7wH3cFQ7OlLdUowo9rdYV1vB0yLdPQ9nhkJDgf2K7mEuUixnLB7kxzbrU+8fRZ2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zpRrnPLlno2rvzaP1mRJFswLDrb6mYPsAxHQwgyH00U=;
 b=ureXZQBFLwsvAYddyfy/xhZ6JUKvs1XYiuQerby8/SW0OR7aqI18+qZ1mohHxAFrzqncWEMUUTdZYi/yxLLxnZMqPSOavH4jSbNSG8ViQ3XOATxLAqt7LZ16yGwQxOQgahjPhENIJrkldAVR77gXLfF05YbHvXz5Rn0R+AUlmfL36ed1D3cBi15r/QHRuEmsy7MWqaY3QTiqpxsoKVTFaW6IEiUrECzzGlrgrfcSV2msUrgKV6SiGoCq7WomMow1E0n/GU98VNstdFcv/ET2XA7nOb3MY932calE8qO2ZsQqELlvCLVLVScEMNwSTZ2MGSes6wqRRghQlt7Jj2juvQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH8PR12MB7205.namprd12.prod.outlook.com (2603:10b6:510:227::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13; Wed, 4 Feb
 2026 19:48:16 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Wed, 4 Feb 2026
 19:48:15 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: =?utf-8?b?5piv5Y+C5beu?= <shicenci@gmail.com>, linux-mm@kvack.org,
 linmiaohe@huawei.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Subject: Re: WARNING in memory_failure() at include/linux/huge_mm.h:635
 triggered
Date: Wed, 04 Feb 2026 14:48:11 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <9E046323-740A-434A-8B60-B8A32D0955C0@nvidia.com>
In-Reply-To: <e97d5c0c-b8ec-4da4-b838-7a308f8a6327@kernel.org>
References: <PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <b9e89c85-807c-4a8b-aa5c-8c1325e75445@kernel.org>
 <1db245a8-f9ab-42e4-8cc6-cc7562961921@kernel.org>
 <48978612-6933-4897-85DD-6740B6C8570B@nvidia.com>
 <25CA4D90-A24E-49C6-92D2-08080EC81466@nvidia.com>
 <032058DC-CD8D-406A-B986-740E41C834B2@nvidia.com>
 <e97d5c0c-b8ec-4da4-b838-7a308f8a6327@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH8PR12MB7205:EE_
X-MS-Office365-Filtering-Correlation-Id: c9fa8803-11e1-4d1c-cdc2-08de6426568d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RivGGnNU6K+yGWEvyDqtdbn+5/1tYxGmFXxlsISPH4NTGI27xd5/yCMwo3r9?=
 =?us-ascii?Q?orULYWNu99ADsXauZ7e+nRpczdN7g8rl26CiqFX2KYuNtC15VXteCZPOQO4I?=
 =?us-ascii?Q?LSLypSUqASrQTztVkOECiPw9q50yVMAsQGducFYfb9KaKBqt6heWwbCAyu9G?=
 =?us-ascii?Q?0XG8mzTPW4wV6WWW83vcfBnNs5cbLUboYOy+SWLuA2ln5Dyun2gVIfMUuqm5?=
 =?us-ascii?Q?e25j1b3bs0PedmTetjwCNJisEDX1qaqI0WNh/LALbUXSnub4Yt3SAO8SVEQv?=
 =?us-ascii?Q?7nZCPaAOLr4cegKbg33iHwBlcuzuzt7znrCzehJ0Va4y9kH861iZMZDgMqhr?=
 =?us-ascii?Q?0VcvC/gbxQRissGCnoWv8Z3QE6mnjq4iI8bxwLDq7WxHk+EgudBivAFY6MxR?=
 =?us-ascii?Q?fp1QUAt07ONeFiAzwGz85+w9Y1eGTCameH3vQ15czmzbIMI/nfwvQBqvjMgn?=
 =?us-ascii?Q?eoSyRd35sVW/+bA+fZenj+PeWGfsKBiW9wDH8/ezGfZHYg2XJg6Y/LpY+X9O?=
 =?us-ascii?Q?yxGD5Vhc+2EBAtqK20UcYjjYIutXuLS0EqgBQ6ZJrs2xzj2oMURpcUrE8no0?=
 =?us-ascii?Q?avvJ5j2jBgw2+7k/DldBcslI96ypRbzk9cR5exHbGMzIzk4R6XoD+OFdtNgD?=
 =?us-ascii?Q?Q7znshKx8+Cz/6QvCbg69bKE/Phgvz8BRTw/GcOR9eBwhmGtyU5z+bUtsFCI?=
 =?us-ascii?Q?RxuUg3rzKsyemK7kmtpp35qfaSaW9Y4WliPIr0p8DfgM19J1VuTIgOlbL7LD?=
 =?us-ascii?Q?q42UpeaVhlpdYemTakvTMxtFJ+35GGdJAvei5uEtIEJAEcbCD8CzFSCgZhJV?=
 =?us-ascii?Q?JSzgWlA3X8THChFtSXVrR0XdUVl6jrd2Shsm9j6UXH1/8c648Nhi0gFkbc+/?=
 =?us-ascii?Q?5WObqoCv5lFXgJPso9w+sfBOpyuBHe2ucVZs5YJr0cP1Qh/N8WrIyWGqDfgn?=
 =?us-ascii?Q?eH9XnONwse9dyuyk7rMRoJyamgGRF4geNdjwlxckKVSIfto3EqPA9hxhlsDY?=
 =?us-ascii?Q?TxUEIiSO5ga9cFm1i0853DHZG3NFN/2Qcd1Y+I/q/byZdGM0ShIeEiMXKFl3?=
 =?us-ascii?Q?VSI6brACj2Np3Cb+MRfwK1HpLs9m6jBYQPYlMWYvL/VHL5+QNB6RwwWGTsmi?=
 =?us-ascii?Q?MZpDhSMfwvzFEHjF6QcMNYZnofIX99/Uhdab5K/Neocpas3Src/AItKDi4h9?=
 =?us-ascii?Q?N/rebSyWkUzJBG9WwliBrpY7fdvWYkJTfBVwDOWq6qK3aciA5cvBFHB4zOHd?=
 =?us-ascii?Q?rF+K660In5JndwlGoSIc75R9qtIz5gYjcQWTuTqLeSd8mVg/82vGEauJMtTc?=
 =?us-ascii?Q?B+sNA7ptCOXC8mp808LZ3tAFtXEsue6Evo+tWjjuFHyC4f6gZF4LskoLtF+4?=
 =?us-ascii?Q?aolqjmPIZPp+x9I/NW3kB2QldrcGy+nqCaSRFlHRUT3uelD12+1WdrXouv6N?=
 =?us-ascii?Q?pyrsi0c2wZTGiDML7EY0BkLWmFiiJiq0Q+d1kZ0bqs9WoNf9tQ7GC/XIwDds?=
 =?us-ascii?Q?369mdj/l8bfxrkumJBhFzZxAYaptta5zBietvJng5T2HUgZsKC3kmVyzcKY9?=
 =?us-ascii?Q?D/Kd77SBluY0wEYyTb4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GMCSea0YFtSJH4eDaZg9TVqu8pDAmfWVmnOoi3Aq+qijujp/r4XRkG7EzllV?=
 =?us-ascii?Q?EJbFiSp1/TId4hpXSrMpcnJaxKoISNl5Er+o2cYkyFKO4Bz+jkRfoVUpcY2x?=
 =?us-ascii?Q?VGYkvGZGE1bqeUAD3PdvwJdX1OdZFoKtsuUwWOWHV0aDU4NJUPFCj4Gfa0st?=
 =?us-ascii?Q?SnydQHsRhksCZyxDwN6ItKA8GmldC3o/Donp5DxK0UGEmYHlMHM16NKtAZWB?=
 =?us-ascii?Q?t89NRkkbt4bpgFiQzpbc+DWfdHvR5ni+pfNMnGvFUYnHoNDTl4QRHMx8XJ+h?=
 =?us-ascii?Q?KQEc/jk3qp9qW4g5BFwgV8x/gAUfu/40tToAYQukiALUfn0sGs/DRByl6Fdu?=
 =?us-ascii?Q?n7LC8sPkr8OzgmIxuYgcSKjls9t8VvANFTPeB58XF5iGeE7sKZs3PNb3Tzxv?=
 =?us-ascii?Q?yibQdSB8H1NsPsGOXs4gfY6c2jI3KNssYR5AH3+x/WYukhyudw9c+RarxHd6?=
 =?us-ascii?Q?eGBXUo+wK04WJwXgE2eeYey21YZmi7ZhElhoU3NpBZhXLh23GO7s6ZDrRl3J?=
 =?us-ascii?Q?dcuzNi2G4QhCR0nMI6kDLkdyMSrylvEJ+93N2ICXkjJhnG0kHDUUues6KFWb?=
 =?us-ascii?Q?C/k3ILsWErKd7MUo+/sK6jI3cZQc2dUTcDatHJ1ycJmT0Oe//uEWhSpaM0RR?=
 =?us-ascii?Q?PjfJjY4m4X8elDnu3IjLCbtMyAtKWFXXE9l09la2UqvcRtAHTViK5rjirHk3?=
 =?us-ascii?Q?iFMsIoCnw3kbw3hkp1IUKT9a6strPtwhAryA9P0AizaIe4pFw5IMm0eYWms4?=
 =?us-ascii?Q?lWav8dwnd7ojgxxlrdy3/BzOGaLU1qcRdBkDJAtdOCNV2Q5Fsk9ceJVBXFnd?=
 =?us-ascii?Q?HgkWF4jWZl/cq90Ug/WG8ZwaJkN5XDdMl1GocRouRrmdvUWgw3H70wHDDnb0?=
 =?us-ascii?Q?akx47zPdi8cDVQcdRtMwbqadSFnCcUreBXLTuV+3nQzGpkyrWiz3PW7DdxbA?=
 =?us-ascii?Q?6/ucL/2PuxVpwARWQJahpkerEXW7hyZtCc7Srwd8/cL3fvHTKT8D1R4bJEnW?=
 =?us-ascii?Q?1RsvCJwwlanYsFEmp7fL2ecDJpj9Y5Pn1hkBkx6KERkWASVN5Pt3BKSfHh47?=
 =?us-ascii?Q?VPVZbLta4uvp2aMpTuHYfCVdO/BQjee+ShdWXohnyysB4cX0tXlpYPylXXoi?=
 =?us-ascii?Q?W0GmuEm+IouBjiPt/w27Zxu20gMcOAHsfp7EKMEA/zd57jCyD+3roWzx0gmr?=
 =?us-ascii?Q?9U8tYdQDHp4y7706YKkroiuU8cpstzv2vll8rgy7db3Llxi0dtm0TBvohFnM?=
 =?us-ascii?Q?s8PihbJvcf+t4tocTq2obdjte+DRLKFgIjSd2Dd3USdOTdY4ypiX0u+Cd+EI?=
 =?us-ascii?Q?l0+fKEGcKcHATaAY5s7BCqRsE17evCbO+CTd2/AhEP7miCfAqu6zbjQnIsfv?=
 =?us-ascii?Q?D6qEWZxGUArT+B3bP96Hdx9gDkcebhrTusIpNsYElhjZMDqdduw/D4ipM3qZ?=
 =?us-ascii?Q?66aRBrqf9FZk+uQNPoRrKaq3hXun0iIOvxv4HyT8JpEKAElk7aN4ZaJAQb4z?=
 =?us-ascii?Q?k6zcdFO7DriBbg8+hSRHdlMg3QwaPg7FCZkPdURveV47BOlf+jYpq8Ag6vS7?=
 =?us-ascii?Q?EERNdtCvk2aUr0gEas2QqJA9o7eDBl1yjNULzDe5UvMHV+C7+nVfOKt+2QHK?=
 =?us-ascii?Q?dtuyvF77VVAEi8WKLPa3ioGHRZY1hdC6CskMROiQz2u+3iaqiI8mvqAEwczw?=
 =?us-ascii?Q?osfKzqABxYcwkHAwfQTK5usVeg88uHn5m9YvD7mU+AXvHHjY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9fa8803-11e1-4d1c-cdc2-08de6426568d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 19:48:15.7989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6txAPRuF4DtCjpuFNojaVHuunblPt+O0+d8rJvpSczZ4EMXJo7JzJ49m1kTcgv2z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7205
X-Rspamd-Queue-Id: 53A8BA0003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: eysh5bw5p1re1kknmgxpdzft853bdbq9
X-HE-Tag: 1770234500-109023
X-HE-Meta: U2FsdGVkX1/vt8sZo51kv7SP8vedCW6fryl4r7y/u0ehtSjmRlKwxBOCSAwr4N919msbPYj6xRZAKUwOugOgwgxTJ2d+QiIS1svPtgd5VDJA2KTkepSxN9yAlt7clBGYQaRAbeGlF3hMDPmbi3PKzetsgBVNFFV/z7tyK4xe5uyb14PBHf8v+D1/2sSMZiTraFTMyJlatHVaMiECZkTt6jayt8tX91X4YJEgSkAQjYborGQiJuV8j6LgYXpJcb6K+iZ05y5ugULkMtKRItYj2nYHCfDYUhLjCbEzSNG8VbryeVKyVt4BNNzlB/Qqcvl0SCyGDxVndoir9SKJEoyRneIMDOoahkYnCY9Xc6EOkn8EKE7iQxdgN0/V2N37IlKbc/lPa9I3FrFVvA4Szv7pQ1V6WQdks65uWE9XeMocFdAKH63qxGorF6lIHdiSBByX2ydiEonbvDOyuurvMlk7oCRYRuNQd7hHaHQks92Dt72aooqu1PvJup6NoP7RnYfyzp6D/cuXAajqIAKdlPl3+c+/KYGVlzQ9ueG88Myor96iWv691TE/xMMgKGjqdq/RBmMIHVIHleVzV7iPAwpOtuz3L6nT2D+GcmXnQH/kmdIs3JDu5XY15rBqdKI92kL1PFGG4OFczGliFBHjGRCZozV1OcgjcegozJidViFOlk79ByOUhkpKWyEcwmuWZLhU7X0YDGKEx880b/q84NzUixRRx31oNxU90V2FN/IiMe1eH73BRa9TbvSJa8eRGP+dCsXensc8YeZi/EN/NW5aGIKuOEyVuNdB+cn7nVaNtzruiraApg/kNebjE9ibaWPN/OyguIa+QyKsCYBKjD5DLY7WW02RhCv9IUvjFFKBSVWEzW52zDnQG5un3z33vy4Wdj5jGKz5ab4aAb6JpzKElcolWku/ICQ2tm3kkW6CZiyABru3jXzG1JNRx+C4kXV2+YCpAnZ5yK/YPER06Z+
 wQ5KlVLn
 gr5JwBKcfSsZIqFplG6F4Intq816cm08X5eJQVNzUcZlCHtoP4mkzI92cuGdykXhLLmvq/ifKjauE46Jn1ESiFDB/fF5jRV+ynpGLT2qj9zglY7j7R6JjTtDQETmiwoLhzY/oeWd6u4DG92dQVaGrz0GLPcUdeU23vY1HVjlRJWF3KP7F2LvCfG6Ub19WxdwLNbKbMYQOz0fXYyptY2eNmtYT542IunyOtBCWiu+3p0O9VKlFFiC5RQ+gSO4E2vISGg25ewHBa4isjPzffG4UNpwSgKprlpTXFxJqGGxwTmqXshZlVsMD1NGVp9dLodhqFe6rgmnulob+GNj5uRbOr2XEVkr4vLzTSgQayjFqqXNun+CpwyiaSC6qdx2MJpEWqSMfYS5i27vE8X/ia/5umpectw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Feb 2026, at 14:18, David Hildenbrand (arm) wrote:

> On 2/4/26 18:41, Zi Yan wrote:
>> On 4 Feb 2026, at 12:34, Zi Yan wrote:
>>
>>> On 4 Feb 2026, at 12:23, Zi Yan wrote:
>>>
>>>>
>>>>
>>>>  From the C repro above, syzbot opened a dev "/dev/sg#" and did mmap=
 on it.
>>>> Is it a device driver issue?
>>>
>>> OK, it is CONFIG_CHR_DEV_SG. And the driver allocates a compound page=
 at[1].
>>> Since we initialize folio fields in prep_compound_page(), it becomes =
a folio
>>> when it is inserted into a VMA.
>>
>> More details:
>> later at sg_vma_fault(), the driver just handles a page fault by suppl=
ying
>> a subpage from a pre-allocated compound page[3]. We then get a large f=
olio
>> without !CONFIG_TRANSPARENT_HUGEPAGE.
>
> We can identify such non-folio (but compound) things by looking at PG_l=
arge_rmappable IIRC.

What do you mean? Changing memory failure code to only handle large_rmapp=
able?
large_rmappable is a folio flag, memory failure code should see such
non-folio but compound things to begin with, IMHO.

I think we need to be able to tell between raw page (compound or not),
mappable page (compound or not, especially for those used with vm_insert_=
*),
and folio.

Best Regards,
Yan, Zi

