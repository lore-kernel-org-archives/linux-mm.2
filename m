Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C26FFCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 126986B008C; Tue, 12 May 2026 03:46:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D6926B0092; Tue, 12 May 2026 03:46:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE0666B0093; Tue, 12 May 2026 03:46:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE60D6B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:46:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A72A0403EA
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:46:40 +0000 (UTC)
X-FDA: 84757985760.04.C18874A
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011052.outbound.protection.outlook.com [40.107.208.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id C7CAA180007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:46:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Wz2XZkCc;
	spf=pass (imf16.hostedemail.com: domain of apopple@nvidia.com designates 40.107.208.52 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778571998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iSPJF0vUMC3d4eM4YeuzYER5mfkw6M9wvNeh2dU5K2s=;
	b=FZoCq4bzBHUnmQR9ipggw/0lzQFjiRgbdP3MrmFmyWlthsb/Wff5Bk1OOTGg9HL/ZxelBt
	FrvVJeoLylM1bp50MDQXOdgaUorwvUCG+wuSakPuzvFS+Ou6E+vtYeXXMYRf0pyrODrwIv
	TKDcUyNrBl3Yo8YMs0XSELcdTto0Bos=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Wz2XZkCc;
	spf=pass (imf16.hostedemail.com: domain of apopple@nvidia.com designates 40.107.208.52 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778571998; a=rsa-sha256;
	cv=pass;
	b=1YvtMY7l5QmY2VXRCmePe3QihIOr0/becFwAXE2fLASgbhBs7Gq9+7VUJgwfzmVtSvZO0P
	samkJnYsEPMpmYE1I0wUXSJlfnW2GhY0bwv1ML1ttTyfDQYhwfJ6ZX3s7uqi4zo5yFjcbC
	weRF90hc7AD4ZQxv+OPliYV5wRob8wY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oZPVIjQ5GN3fsVqgkf2miXX7i7ZFBnmEuM4CVYjEILxnowJ70XRUlVLWl7rOVTTJ0apNdK7IAOYcQBAt2fR/dUl5uXaLsil7zfyVx+qbbMaFST2BTJVlpxa2z+T8Ung+FkYob/WoWqK433hXimOECnGRBQjfTH35o8QzLQf1DgICTQlrKd3pJkfzxSIuZKekInD27HeTCLFJhEjzJNjsP5WX037x/iWoQSDsZ6sWgsfefJ6c/Y1yS9F6hjkZ8n2w7Fqz9E+53uzkZr38Qm3I5wDvM58iqXky3dPArbl2GcicuL8GorqM5DV5NjnKpCBD1VsrbTLeM0hyuAgz3jQLhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iSPJF0vUMC3d4eM4YeuzYER5mfkw6M9wvNeh2dU5K2s=;
 b=vUWMsWLegFP0tZYKU3VgnQeJTbfXyaDAqim25fAFF6srFmMsFWT+RWy6X8PxQYXFvj8xza449Zk7IIGJopDoUshSZXqh6qWJdziQ37/QbdiNOj0lVSk+4PYyL6ouzVkwazzXP00xe46azZNRy0s3zXTnGrHeX539Cg0pkPtGlsO7eCjwczN+2XonHUsPCeU3g7Ys0yi0QVwz5strc4yzBCyor+Rhd9vV5xs9qR4yOVGWEj6KqmByoZSuZZxk88EbOPxmK/VgXgl0RvcL5v0sGade+IxptTdf57QJHQAXnqAdOogePOovVOw2SaeDLJQNPr2XhQEJBJq+WswIDg+ruA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iSPJF0vUMC3d4eM4YeuzYER5mfkw6M9wvNeh2dU5K2s=;
 b=Wz2XZkCcKDaBx1ewGrUUvEMDP8xGGZ9dkGGrzC415ONrRO+v+eImT7Zq3R8WCJtRBMp5UGC1gnXLvfuHoG245pBq4VY/kkW0dQzJ26sw7ZHTJO0/QNcebqqW6jsPkPZvldWcVvLeBDY4Qj8VsRgPV13mkZQy6gKiiTeEhV81yAU6lQTmQLqXOrJRklFncgGSZq1iQM2ywPE2WeuM8CmW3BKZD+FuUZfbl8mXQZs9OwfvhwfP2eiA/+/qV+uah8pMds1+GjqeZEn/MC85c52onGXWHq4OXp9Epc7pNuROZwjeWNbl5fSMb7KgBkIqFhV8xpEKz7h9LiJLiTqjcQksUw==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 PH8PR12MB6889.namprd12.prod.outlook.com (2603:10b6:510:1c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Tue, 12 May
 2026 07:46:29 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9891.021; Tue, 12 May 2026
 07:46:29 +0000
Date: Tue, 12 May 2026 17:46:23 +1000
From: Alistair Popple <apopple@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, jgg@ziepe.ca, leon@kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: Re: "alloc_tag was not set" when running mm/ksft_hmm.sh
Message-ID: <agLZ_BlwTuSZrORF@nvdebian.thelocal>
References: <be9a8bae-9223-4966-bba9-2cbe39c8f4de@linux.dev>
 <10e4565a-b416-45d9-a8b0-cd32532b2630@kernel.org>
 <2b46241c-158b-c9dd-9b81-a98366b2c9fb@huawei.com>
 <c16350fa-2f74-4517-8d97-4772def97b78@kernel.org>
 <dff84fe1-ae17-410a-93a2-c5fb921e7f8f@linux.dev>
 <agJ9762r0HwKSsb7@nvdebian.thelocal>
 <f7895374-b43f-4ce7-8a26-112ad30c9273@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7895374-b43f-4ce7-8a26-112ad30c9273@kernel.org>
X-ClientProxiedBy: SY5P282CA0099.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:204::8) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|PH8PR12MB6889:EE_
X-MS-Office365-Filtering-Correlation-Id: f41eb0fb-1a01-4ffa-f21c-08deaffa93cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|11063799003|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	muB33Mibf5fKRh3pPCxhKL8U3otMN+ZSJv9dJEz1GU9WdevAz0n3y87bl7BzjB8tkdXusF5Sy0RA3ZmSA58fo+WDyHE/wfsWEbHUvsfhLKThiWKjEc2P7p47aAIug96hyra2cOL0qHhuTpDlyM62lvfDwmom1wlLJaqRccNRpUx7zaTuC5wjFPKUCRGosAcwgtyM6G/eZH+oOSUDIlgTtbzSM3qgPnpXoEAKzuxNA4TkdJenrdoUMHd4r9nrlNN1vcaxznco8PcWL8RHy33Ib/n6nDGCb4zhLUftCYTqu7TyZ/9A92AjLunFY9bWduMh+NHBKICBml56jJ9DwdJwp1lpTqrx1yAq7P35ylIaDiNwqODIKd70EQM8Y+sdQYhPghAiqradvk48h+P+3N9mtQ3SSY5hpR/otvpUqlP8mz+JOOFFtX4yZsMQrI8rO6U1YwW594AXaAjTWcFYyhgejK7zGXf+2xI76SIbZK8GMJbjQMhTbzkaajlP4KS2vB432TlD+cCHtnHgDPZLJ7+8TrMiO5BBsxREk1UFk1MnLTttNHydy794ieRfE6SqEWS3jFJp50/8OcDyMvNkpfBCDTo7VGWQR66uV6ojht2iUc3pA7JFO9uS9C+NcDRGI6E0qGDU2BEkfEhmqyIxU0mDcyoz9z8Ja50Uzd4xDQzw0eF+H4hDIIudi96d/2OIyrR5
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(11063799003)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LVHFQvTQIeKMCloD/RJMQp4vBYlj9opinwddvdsnAwfjvowErDCIdg4xJeA1?=
 =?us-ascii?Q?xtR2N/5Vb7zDQndc4Ktb8+zR4m7Lfbr3CbXomsHUzrUYyuJjmBtgBrZB7Qy4?=
 =?us-ascii?Q?xAORbkfoDu2fSuwchWyWVm+x/Fksfd1RN/gzQl96MlP0ewltN846BMw46vdz?=
 =?us-ascii?Q?WkLKP/4n1wwggVz68BuWugERpRehzusP6gnpVl7GWaeuHxPTnQiD+7oCGCHd?=
 =?us-ascii?Q?33EaM1JCbIxHejiYJsEKapFEFYWhkZK6hVrZ819bLxrWlCB/PBQrv2h/VP45?=
 =?us-ascii?Q?76fsTKOvXbTwutt3o6zd6TdNXwnXfEgOGjvapGNoODFtO7CwWsUUCkgN37IZ?=
 =?us-ascii?Q?oiyoHd3n4NPWkBiLeAZ1U3qaiUEtn6LlM1vpzR+GaQPFnilSDCTA2IGJYWGf?=
 =?us-ascii?Q?3/yAT+9dcAx/uMquB4BmNNLxrEtlYhC3HKxZyHKvZ5ZXCJM6uz7XoFsNWJOM?=
 =?us-ascii?Q?Tk1vFPJxtqhDRdL63+3kfE7ohWy0HaVtq8VTZHtfk3DU5kUeW/Rjy0caTSCz?=
 =?us-ascii?Q?O6sKFtJNtFGPW09JhudCezCOrA/tENxz1Kcr2ndNQRTnUY/ypJKhCOq3fmRg?=
 =?us-ascii?Q?9XNTvBaYj+EGbbRJH+zuUyh6WN6G6S8YQu8UmioSmdeIX7s86XqZMnZ3kHG8?=
 =?us-ascii?Q?XLxwP8rJhGOflkJZramqAddPmSSW1E3aNoGXSdK1qWOt+cBSSrI5goZgoRJI?=
 =?us-ascii?Q?B+RirawwUZHSlkCd1A7uQawcuVQk1kn0Vmdktc8rKAYlbvW5Fs4+cKVndIVM?=
 =?us-ascii?Q?gncz7f17cCxyLc19R/bY8n/FNHfADpf0LCdWYh7MowV+yHz4KqLirYRtiR5I?=
 =?us-ascii?Q?GSUAUsZmLZefj6Z8K3O6PM3niF6f5wuTVjkp6fJ53Vhuw3U81CDIzkBQfNPB?=
 =?us-ascii?Q?Zp9gGRGX+u25P8JeJuVlccLtNhd644sL/gM3WSFiHJezFubrNwM509c6QuKm?=
 =?us-ascii?Q?7BlUfluj/qBlbnB+hDgMexhzDtzexarNMtPukVSob/iZlgFQbAgng8zulVn2?=
 =?us-ascii?Q?+2IwY1IZow54YCswgtRSNrznGjSg5SE/EkbYppBK2JYKwm4CBg5oQlTrMObn?=
 =?us-ascii?Q?YoemK+qkl0I0xN1DMiT5oVFHd5wOAfLmNDw/OhuCKAg51zdVUpzQwcwVvwgY?=
 =?us-ascii?Q?Yww8asoP36besUycJl/WBUm4QredGjFaFD8h1aR00I6l3Xr/H4QNzx1B2UF4?=
 =?us-ascii?Q?zkHEykV//welXSnrqr7b3GbcHzxNx7z0c788gr5Y3XGologYC8SAE4Wneu0R?=
 =?us-ascii?Q?tNxvvAWyNsoGMVdv1Xy+/srfM71YWAzubBn2Uw5c16eIT0QykSJn2/FaZpud?=
 =?us-ascii?Q?lhtgU/oPctB8WlVD25OsCm3PWan7ou7xCwymkwPu+1zQcjQQ4azcqikFvwVd?=
 =?us-ascii?Q?rlXjdBHlWydeIVE2qtzdZPwNJu/++xiuv66X6ouBYoqZalKNKZkwj91GYjPg?=
 =?us-ascii?Q?fFzgk9hQ6vsIZHTfcc1Z0loH+yFpb2YdbRE3GJGya7btQ22FxAS55TEUdyJi?=
 =?us-ascii?Q?AoQm0V6aHCxc/RIznS9tA+AQu6sk++Oq6bMNhFCV2ASKfTqEywALqJ3634OU?=
 =?us-ascii?Q?Ev1QNouCeu+cQXlXVd2qhEPkc6Pcs7rc9muwY9V1TsC5Omm2OfaIUCGSIPtw?=
 =?us-ascii?Q?Pw9adX5cuSyAEdfBeGGxYu6VopgXoSMgUMxNQG+h77nDfGZwYAZN6GXSELTm?=
 =?us-ascii?Q?mgtnL5MR+NPD0DVD2E0cxICN8NdUukWEEOAMz7Ytc87+JaMHs6MVdUcCCbDO?=
 =?us-ascii?Q?9oVCwKkuDQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f41eb0fb-1a01-4ffa-f21c-08deaffa93cd
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2026 07:46:29.1147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y0En1WT2+ua3f/fH43NB+fLDX7DfK1pl/9Vw1HZNprGjOt28cAa5Fs6QJrca7QlkS4CFnwrwjJlsTAOgqBV1gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6889
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C7CAA180007
X-Stat-Signature: j8ddqcktm1jj4sd6cxujdd7bq3hkxynw
X-HE-Tag: 1778571997-848717
X-HE-Meta: U2FsdGVkX190kOYypzpbvcJEwi3yTRFzwT02mGu8fqGEOUs72x0jVKdwRXPB8V+5Kv1pgdbhn+oyj/trv5lLPlEhd6zOchOzK+yPilVkTZQFu5TMnmw5oiOQzEBfKiNDyMyqqbOYJhVUNbH56LHL8u9s9WcutkFbhLphvoYxF7FrDKJnO15xB+FpFkD+Lsb8mUbALDfSgtlQt5AXwh70H8p/nTc4c3K0GhKyW7v7g158l/rNGdjfqQH+U0kTP+IP85UTIJu4D0//2Kh5HFOy4aV80I+0TQxV/j1+kEMDpvnXZQOu+sSvuf+JK28bIOWm1ilShno40tMOXG0B2UzxP8+gn/S38R4GOvNS5/e/bH1DqbNpjcGd6A9AR86TXzx8+D9xfRNEFvb3wc0FOfhwszdHbiXO642SHSO4YJER5Cd7qslVj0aqM/5HaqVL1u2eKtLR3vojBu944AqNGT8M/ylqb2f/G0jYJNkrBnllGwnv+OCf15406pmpVOq3oSb6cDcnFC7MDUdX1FVUTNWfSg/HfsKYgD1iQ7dwkOTWrt8KPNFyKAYFb14pC/2/vATtNApYd3pTQcarGnVHIaPMAceKkoC5NWWjFxJ3gxaeuBYy2q1TkyFAOR/PjPkbZLkvF7b9TitLFjINnujXjFdhdwfF3JdGIdisIQ9ORCB/mVJ8Fnn/KmwV8/BqyooOyVwf7NjJ+1cpEbNDeh223RY62zR8UFGm13FMepno1fquGoS5x4iN4gnI+JszCW/iYUIkMNPkpcoigGMtX9pFju6l5gPwOEKUvHw2PsomArJvt3wdgrCw+qiRLXTEamvv5D2yElD3OuVpBbi3H/bqb+Qs6Y1go3GbIbvqb7nBi02qOYozy2rHj7J7PbxXjS3Uj0AYNTiWsJoRrPxvle7iTtFe1BDys/9pmSBE9wrT3ShOLHCOiAHT9CPS4ktn8rFlw9McWciKpHpWhebRVCaT/JD
 2LzN64rB
 2DDUTOiccbOgcw6wie8tr01+2rLx4m0Qufv6i7LvmYiKq7E/piFQpNkIxcHYjdlaEkTJ6S2UfTEVBC//NCqTmnHOL7Cw/8zObBywfLfzpnCvLB3W+mQ6X6jUzgZu/ZyS4XeI5xLvJncMvmA21i6Mj7D2Bv1SHh5nKBM4p+am8CptJ5Pa+4rQY23Vb4pwjyvP/7xSOp4YcwFabPQZLyvM5JGHX7AWViNVZgb96JrFzUpzUcEPOoKshY6qVTIG/b7l6vdVMcDjc+L2HXOh3eWry0i0cFeFpoLnAUGBBpozIVESaqrDzgynlTflgiUHUzRchJcbAKyxfEY5V3W9ihL2013P2tQRKikj2cVUL0ks4+WTS5x4JjR9DkdW4/RmL9LD7QoD/hqzqISYO7sCcxnWRuWno0JKuiDbvVDVMlv3NsB4ZCE5EOn5Dorp6aacHWs1v2zwz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-12 at 16:47 +1000, "David Hildenbrand (Arm)" <david@kernel.org> wrote...
> On 5/12/26 03:28, Alistair Popple wrote:
> > On 2026-05-12 at 02:38 +1000, Zenghui Yu <zenghui.yu@linux.dev> wrote...
> >> Hi David,
> >>
> >> On 5/11/26 8:47 PM, David Hildenbrand (Arm) wrote:
> > 
> > Thanks. I have reproduced it now that my fingers are skinnier.
> > 
> >>>
> >>>
> >>> zone_device_private_split_cb(), that ends up calling ->folio_split().
> >>>
> >>> We do have a call to pgalloc_tag_split() in __split_unmapped_folio(), invoked in
> >>> __folio_freeze_and_split_unmapped() before calling
> >>> zone_device_private_split_cb() when iterating the folios.
> >>
> >> If I read the code correctly, pgalloc_tag_split() in
> >> __split_unmapped_folio() deals with device private pages' alloc tag. But
> >> what alloc_tag_sub_check() warns on are real system memory pages (device
> >> page's backing page), which are allocated by
> >> dmirror_devmem_alloc_page()/folio_page().
> >>
> >> static void dmirror_devmem_folio_split(struct folio *head, struct folio
> >> *tail)
> >> {
> >> 	struct page *rpage = BACKING_PAGE(folio_page(head, 0));
> >>
> >> Thanks,
> >> Zenghui
> >>
> >>> The zone_device_private_split_cb(folio, NULL); is then called on the first folio
> >>> after looping over the other (new) folios.
> >>>
> >>> I would assume that __folio_freeze_and_split_unmapped() would already do the
> >>> right thing?
> > 
> > Well you know what they say about assumptions :) Although in this case
> > __folio_freeze_and_split_unmapped() isn't called on the backing page anyway
> > (it's called to split the ZONE_DEVICE page, not the page simulating device
> > memory). 
> 
> Now my brain hurts :)

I have never liked this bit of the HMM selftests. It has always made my brain
hurt.

> > The problem is we're not splitting the tag associated with the backing
> > page for the simulated memory.
> > 
> > I came up with the below fix last night, but I suspect it will quite reasonably
> > get NACKED on the basis of the symbol export so was looking at other solutions.
> 
> I think there are other problems ...
> 
> > 
> > The simulated memory should just be used like a bare physical address range. So
> > there really is no reason for the backing page simulating device memory to be
> > allocated as a higher order folio. Using the struct page to store some metadata
> > for the simulated device is convenient though to avoid creating a test-specific
> > data structure for this. So I am looking at going back to allocating the
> > simulated backing memory as always order-0 pages in the test which is what it
> > was prior to the introduction of large device pages, but that was causing a
> > crash I'm yet to debug.
> > 
> 
> ... such as doing a folio_page(folio_alloc()), followed by a __free_pages().
> 
> Why are we even allocating folios here and manually splitting them?
> 
> Looking at dmirror_devmem_folio_split(), aren't we using folios here for
> something that ... is not a folio?
> 
> Likely we really shouldn't be using folios here ... :)

Exactly my point, just more succinct :)

I just need to make it work without doing that.

 - Alistair

> -- 
> Cheers,
> 
> David

