Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD6C3CD4F2C
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 08:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E55226B0005; Fri, 12 Jun 2026 04:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06516B0088; Fri, 12 Jun 2026 04:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4A26B008C; Fri, 12 Jun 2026 04:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD1C86B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:22:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53433C22FD
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:22:47 +0000 (UTC)
X-FDA: 84870569574.30.B05514C
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010039.outbound.protection.outlook.com [52.101.61.39])
	by imf11.hostedemail.com (Postfix) with ESMTP id 756CD4000A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:22:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nbWpzpVp;
	spf=pass (imf11.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.61.39 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781252564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cCkWijr9+FmHTTNd5tVOF+na/i5xAL7Oi5Gr5nK1Y/w=;
	b=FNKS59C0Gbe3jogox7iKXoAsGRoVSMPY60bB8ei8Z5easnnHBT7658rrAud/PUEl9PY9Jn
	AQzxlEiWKrSfDLmZwFiA1fBottBjicBZq/F9cu/3tXRfz6o+8AdM6WtFEJIHo67IVv3+EC
	F1cLV9bSnQ/noOHtzgb6ziuAeiM4Pl0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781252564;
	b=t25iH/OIIFnsPNU13YPAl2g4gUDhZocdC8jVPq/OqsbdDhj1M/GGZeZKIzpClABPlh0+Qc
	m3ROUeF65FCPSyklYHSD1TObU+vQcMt1SVwhoFldKcQ/kkRY/KrBR5QzeUlzOM7qW5bXeu
	ulUMvy5v5I9pr/+t3rI1BY2z3CKTGlg=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nbWpzpVp;
	spf=pass (imf11.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.61.39 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nCueoHLqn3LwPXYIeX5qI1pQEkfcNBvCaMguXZVhHb6qUpUVNDyAOC5UAsqNEWnAeoDYf6AKkZ4xvFdEDDt8YvH1dIGSXTTm9kgP57qGZqNsJSeIAtCPj8nGfL+oOIuTJEvgHUihJhR1itqOB6REsZWzXOKcHsEsckfyRPnc9wqHqQeqpLLEEYK/efmqYwgOsqoAl1A96FYICHFfPD2FVnFv9C61PQFkYkbUmB3Fr71J+dJFG/QoDTSWn4NTXFjZ1npcIodwOmbYXuvnJWOJwIxyhAK4f7VR11iDgpjg1VlkOlu0RPdeHd4/FYVKc8RhERdIFEgzy+YFXE6L8tZYnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cCkWijr9+FmHTTNd5tVOF+na/i5xAL7Oi5Gr5nK1Y/w=;
 b=BEOKv5jBeqQvS7MV/CweG4PNS0+Imm2c3MQrij72h5K3WCGWwG9GH1Dv7GkpmRz9PaSbktf+R9s/qTWY1Lr2MFmkP3Igy7zB3q3usseRqYm8RQzNn50cbTIfca/Ul+Bj7Ri96+U4H10ZRZVRqFL6poDQq8gZaLTucw64ys9PMENu7jh1JFM8SkfVZH17Mbv7FIKLlaTqWMH7Znnh9qcgkKoN+KeF/PgA9XufImMGrqWaCHi6fTJ28rXr/ttiuFFcc9Nzc3tZMDCy+bHRA/FPAgVYJWGEliFu5/qL/qF3Z46szBBbgCsbUDdarpYfy6SE59XYT9e9rTp/r5MjXW9Ndw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cCkWijr9+FmHTTNd5tVOF+na/i5xAL7Oi5Gr5nK1Y/w=;
 b=nbWpzpVp2fIC37D9eEaYX4sf9NisA4/OYGBzpS4EGNCQLnj4CRGxz0FAQ2Xjv2aSdV10mGCaTQ/Zh9IcNtd3oeW4XMr+LV5/5PQgKPAf0FC6gw8xkGY4E/5WCWm0atVnPBxle26frnLOQ5S/hr1YE+uD3rU7YCOJzeWXDVgvV1FEpdenTDM5h3kkyZIuddUgu6iAhxomHjHWfvpk32FcQ0WsaMPUK0BTLTVZy7uEFD++SqFEjYelEffdlZB0VPCiRvVJLkmXxXEsiuLVtDx5Oq/glu4agyuRrxNz7HlLd/4jeaZ9GGsx6YNKrcV7xNG2whE2RokHHJm5HIGxT36INQ==
Received: from CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18)
 by SN7PR12MB8129.namprd12.prod.outlook.com (2603:10b6:806:323::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.14; Fri, 12 Jun
 2026 08:22:39 +0000
Received: from CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe]) by CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe%5]) with mapi id 15.21.0092.016; Fri, 12 Jun 2026
 08:22:39 +0000
Date: Fri, 12 Jun 2026 18:22:34 +1000
From: Balbir Singh <balbirs@nvidia.com>
To: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Ralph Campbell <rcampbell@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Alistair Popple <apopple@nvidia.com>, Alex Sierra <alex.sierra@amd.com>, 
	Matthew Wilcox <willy@infradead.org>, Sayali Patil <sayalip@linux.ibm.com>, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] selftests/mm: remove hardcoded THP sizing
 assumptions in hmm tests
Message-ID: <aivBqhx7gDMOEzua@parvat>
References: <20260611034102.1030738-1-aboorvad@linux.ibm.com>
 <20260611034102.1030738-3-aboorvad@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611034102.1030738-3-aboorvad@linux.ibm.com>
X-ClientProxiedBy: MEVPR01CA0002.ausprd01.prod.outlook.com
 (2603:10c6:220:204::19) To CH2PR12MB5001.namprd12.prod.outlook.com
 (2603:10b6:610:61::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_|SN7PR12MB8129:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bbe4644-9e41-4d26-6045-08dec85bc41f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|18002099003|22082099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	UTakmnDw0nOVbGiRixWBoo2yuvdnZ0n5Yzymmm6QvwPPtQAT52k2VNnMDv6N9IXXyrs+qPJlFgMYo073eERMbPlttN67sFRRS1guUTpyjfWQKbvvclEm5XDlk6spJEbSvRibNBI4VAh+RRoN6OWw+hhC3Y0/ot9wablmWdeTJXSY0Gbwk4UpZEvwRwgmhZt2MEEgzLtgBkGgqRmMH9QaNl85PnJuMPAg6odJi7PzRhbQtiRICSF0qwkgFTx00fqhJBUc8aUwLeprYmfWaVHQfZc95/52LY1ilsQtcXGRwy3p6onS1Z5Ec0FDxSk35Lzv2fs9GUYhzNwPlcr+5EXovMK7eyzsFmnxbVx1SHa9xPEUGo+ePgHV/+qm6R+RMOGpFe918KO56sKBLUZ9kYgW5EUzg1SAVznJyv6K16/ExpLXWwJklu53fsV+k9nVMQmoPkfnYNXnCctn7/0mahLujxbtwB2/Yh5PT+Tk+93Jm4KWfAQuxXErVkoZ065Bf+b8Y70E4kZCa+Lw4o2ANRHRrN712IR7gDeTbtf/CuXaWf4PkdgGEEwqEdWu7Niqwck2Ig0S5PmrJLFDcMPCktgfPDaKLVl0Vu29NJ6YLfDBZ9iODIe6+z9GsWiV3Hg1yQXahKKNfmnOnkZo4Z8OxO7teHmibx1suCT1HGVG+LRmYscH5RbcGkc1ohJu+YEQTX/2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB5001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ilYBLLK2hNu5dB64RO0vyn8WyktQ7Le0G3ZsP2+1+vuUxEZYghensUudP8lJ?=
 =?us-ascii?Q?V3Upu5Nl4PnrrqlUBuoOKZ4U/qa9whTELE2E3onMqjswWqcaTE90I76EioWk?=
 =?us-ascii?Q?m4o1q5CBiaK20ANJ65o8oCVVu6KnVC8hQYH+0rAWGwd4oTn6rcZ8FqcIXI6o?=
 =?us-ascii?Q?1e2TjzsqU8sWzcI09oiuqMG0Gb35qKF05xoQAeHobTlc+XbLl9uuye3Y6leG?=
 =?us-ascii?Q?pPJEJgwdz04ozBd9QIVoGNqz8KPQZtxR2l5tC81VEh7x9DI17jT9CF6WB0Bh?=
 =?us-ascii?Q?mxpseXfkZUtFjUWSBuypeW+OUVguokU2kq5YKnM/UL08OnaMDe6/j65h0zFI?=
 =?us-ascii?Q?/ezWlpF/uA4FlMg9Yc/wrXE44onJJtDu82DdlJMmoa1+Bo3GLXpFnP5cg6+D?=
 =?us-ascii?Q?PaGzd120IFuLS6UhrI8zhyzGMjOpUe1dSa+q3aym7RgITcf+E6btiDjAKRzM?=
 =?us-ascii?Q?jLlzFDzfV2mPttZYQMG3kDLeVenKmNyHyC7yQOjx2HBIf3U268QDKYCX0WLj?=
 =?us-ascii?Q?SThISj7AeDRpJvzO25d/uvs9Lq3e0GYmkUqcNjHBR/ZRlMDr9HyBWHrEXPMT?=
 =?us-ascii?Q?E+HxnIic+s08TuFDBuyzqsFrtcob9HBhpWNKBwv2TSrC2PBnure/djNiY1rY?=
 =?us-ascii?Q?O1QMX+b/VrE6UXl8l2Yfv0KxDqoV2U48cumK+Q3wI43jF4HJqmX5A/UTMQUq?=
 =?us-ascii?Q?FCIZpzANatvzLnM77kn6pckuBiaEF2+JG7ZYLap73qc7kvIctoSvJROx2djV?=
 =?us-ascii?Q?S5FjfJsvbyJVoz+g5HtUoBmUCr21v3F3BSRVNS3Cgg7zDlQX5jnI/KpAAYeq?=
 =?us-ascii?Q?GeQLxn6wZJHb+g8gnO4h0Wsz+3TwxJt2RVTlXJU//S2mvUJGRbIfVWpIb5kl?=
 =?us-ascii?Q?dSw1IvN+02DsgG4mx0yaKFMOLM0y5s+TbtHV4nvobGuaEIITS/MRFTY9Np6Q?=
 =?us-ascii?Q?FL211fTcYSzHoRYYPNxdH+IZ94yLeSPe9Ivf+1dwXGEFDEoq+f7kybbxN8o0?=
 =?us-ascii?Q?T4E3hN5NKUNrxqbhHb9mBl1g0rgAx+x9TTO+AECsGiACnqQ889KW6/ya2zjq?=
 =?us-ascii?Q?ENocJjChZYhA+fIFC/H67nAoTuBQ1fSFmfnDKRVhcldlLFODXEj7Czw8jnhg?=
 =?us-ascii?Q?pRoNef+ujYPmbPRzaIr81psO7An3AP6CgBuh+dl1X75cDd4FhMZ9eKgAA1wx?=
 =?us-ascii?Q?bJoLC/V172fdY4N9BEXx+imKIeisY6vZ6DDWd2U/byK4H8CpZWv46xSj3pGp?=
 =?us-ascii?Q?dS7Yz2ys4lC7UxJKd7NO2DgK7S5OjU1Vsl6jERrt1U71kRAM9C5gW7oWS7Q9?=
 =?us-ascii?Q?7Sshv0SenEXmdl4RS0fgNerqGYByUKj57kg4jLoEmKovf/PrbOuAiEdy9S0/?=
 =?us-ascii?Q?AuvtRtEaoj3KO54ItAErViJFKdE84r57tDL7ZVll09ZoKtlvRuWimRh3h/YN?=
 =?us-ascii?Q?9DLSd4GLjwqUluy5r4eBGvucUkrMDBYR0CdBczRfjtpoxm0fzG7wpEazKuIO?=
 =?us-ascii?Q?xTzseY2AoDaMS/QfxZODAECh/1QtkzkcPmBn2X1r4w8ZAgzZUVRHotzL/ovA?=
 =?us-ascii?Q?HW2hOvgQe3Di1Y2vp0t0Pv8pZtGL260FQDLNNau2kGkgEqyCvcepMwQ0aECB?=
 =?us-ascii?Q?advsnywWCoUM6A5QUhLEFxPT+hQTQcr6lEyxWXoOP1+WSHtKSAscfFMSr7nm?=
 =?us-ascii?Q?cMBCqwvXkIwwN5F8LEjG3bXjmhFLsUuvlhwL/sWlt4k/bLTliRHpXuwn2Wxl?=
 =?us-ascii?Q?AaWDKUcmhA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bbe4644-9e41-4d26-6045-08dec85bc41f
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB5001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 08:22:39.2960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UHOQusaG2pXFQos7KAvAFKeLJ4FnkjTbJWXkMz1OWxBPAdOgTN7JmVfT/HjmAwC8iQI2wmh4vHJfyIuU2fk4hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8129
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 756CD4000A
X-Stat-Signature: 7pusbwm5dfj3rq6bz51n65oibig4da83
X-HE-Tag: 1781252564-824474
X-HE-Meta: U2FsdGVkX1+YTLUSFaWEqWWcDeEr4V+ocpa0yTksioQoe38A4AZ0HA6//cVON1rKd5jnoPBiv/KMyPC/Ngowf/DpUzM6ywyIPUNalRO8mX5+syQHPDfb/blMTL8URdGbKcq52Mq8Y+ZaoGudL+2ABSEvuMJuWOEski94uIJ7NavHL8WZ9XmducamyAgISnI242lV7LUKQhRqN8V4HAOKkhtYBP03+OPKbnRxC4X2h8727bhg1FGA9ma65VjcDVcCQ2gMGfvn3yoIGQ4U11BhgQ8PGvc0U24i7/xDW1rVdEupxuY6WXh6lz+QJ2+a8+qOyyH7MtneexFIP75FQf4MCxYjti8u5PWb+ny6qLvbbmGhx9KVXnEwNIxlfqnONCb/m4v9vU/tuH5YrcJBnIT1mHwqSaQNt5Cszslee8A9suPMV/zXfpgjQO3iuq92DXEFfZgRNwqJZ6uk6J3Vw61+9AQ9CXH1tcFysgmp+8cHH80WEmVRG3ebLSFuzd6LdI1lRTisNQq91onpnXkJhfgg4w9i5SJbyWGsEnBj5zi/MIcFGsn0YdmU8bx7lVqTI7zzpG2EnKKaNHHTiMkquTtU1vEr0zcq5phxVmoBsTNlaXKzin/omjrgXSa7lBQkm9RCNCMMXpHAuPnurghTPE28LRz+vaotIwu95NnTmUZpyEI+d4qCaC6vVkTuQ2M6kGbm8iRTf1QRZuZy8kbtpJv0O0VTCd+NrnX1FyenDocF+1wR33RWr3UimdpIglo1sxwIIdVz0pGH7awmnoGRoqdk9LzHKiWeuqCjzxRrFpm1zipPvpcyBrtlZ0bhySxsWlcvqgyJOqCs6TVrp9D5ikXuqk1fJpkj+1P9bX4IW6fKIkCVHrV08rG7Ee1i5aPOcguY2+BruIEznYUy1iYXu1kh+eYnaTk9bwOmkZj8xVX81kpX4BJshPxJzl1pMHPL9W0IqEEqf0kpboAaigYVMZ9
 RIePqdLZ
 2p00v+7ZDzbU3qTaVbVAJUuN4pvubs8FfEXocCyhM7t0/+HIvZS4PcMlChSBBog6XHBaIpY/3iLpTMbfGBUHanOI0zeyuUdPdH+jsa4UYbZmIArlhvtlqx4LmhGsliucRIIOOMIlZrhZezfvxEEKzZzRdWtvoNJOMNiioeDcbJ0+8YoxTBA6tZsIc/LkNBbEvkeOtfEAlhZDoyHzUUZmBMqwsU2VCNpaUdWZe2EklL6lPkAXcP3tMPxOEXNj2AZd64/50WclOsvPJI27lVTzgVJRnO+l4Fb5NTSrafXiyutxzXY1J50/ysR0DW8nqhhahyp2AJepyXjmws/Y0jn4Gyl1kpdVaB2o8V1RiquimUmkUNyMNES38PTjUHMLcHOrfAYwwlQScJoUpy/6+bFBfHur4qxj8DrzGHIejj7h7d/SB0Hmu11jRpcWaG43rIe0UYwXJpgJrRVAR9Co=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 09:11:01AM +0530, Aboorva Devarajan wrote:
> From: Sayali Patil <sayalip@linux.ibm.com>
> 
> migrate_partial_unmap_fault() and migrate_remap_fault() use
> hardcoded offsets based on a 2MB PMD size. Similarly,
> benchmark_thp_migration() assumes a fixed 2MB THP size when generating
> test buffer sizes.
> 
> Derive offsets and test sizes from the runtime PMD page size returned
> by read_pmd_pagesize(). If unavailable, fall back to TWOMEG.
> This allows the tests to adapt correctly on systems where
> PMD-sized THP differs from 2MB. Also replace the fixed 1MB unmap
> size with a PMD-relative value derived from the runtime PMD size.
> 
> On systems with larger PMD sizes, computed test buffer sizes can exceed
> INT_MAX. Skip such test cases to avoid overflow.
> 
> Fixes: 24c2c5b8ffbd ("selftests/mm/hmm-tests: partial unmap, mremap and anon_write tests")
> Fixes: 271a7b2e3c13 ("selftests/mm/hmm-tests: new throughput tests including THP")
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
> ---

Thanks,

Acked-by: Balbir Singh <balbirs@nvidia.com>

