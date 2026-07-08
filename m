Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCF17C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 02:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B862A6B0088; Tue,  7 Jul 2026 22:31:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5FC26B008A; Tue,  7 Jul 2026 22:31:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4CBF6B0093; Tue,  7 Jul 2026 22:31:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E77F6B0088
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 22:31:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 132A81A062A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:31:39 +0000 (UTC)
X-FDA: 84964033518.25.AB20EBF
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010052.outbound.protection.outlook.com [52.101.85.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id CD1D9140007;
	Wed,  8 Jul 2026 02:31:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JIPPvrzz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783477896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ttxfngV3H6lKnDvvUfKS5bkddGHszwBGKHpn0tQr5RE=;
	b=qwOvlOcH6OLJ1O54a+e1BYBxoPuXFD/eRERLs2euiZme+9qHDZkaUZAmVnrWnU25x8OkKc
	jfbijX6X3xEbUVdOFnAVIJ2uOcoI7dFiU8bgeZyp4auivmTkl791DuhDvnm7T+HjQSrRdL
	6Npch6/DwG7jfGQihZxpK3of9a4MsRM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JIPPvrzz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783477896;
	b=hgkUDzsf1loIWIxQz6z6QdM5ARiqJ6nu5dhK8x7BLelGejJPNy1Dubd3+YAHzyjeRoz0bj
	xiGdt8uQgNCmYuzZcUnbz0rJpfsdkmH/NSpU7NFYHEL0MjPc5067Lujpn+g1eIa1UZrQLK
	u+q3UM9TRPXwq4SoyH2qTtLCSPDbWU0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SonGZCQTfL4B86QLMg28+HjnMm4XXarTlNQe/Bl1VayW0rTNE4KvMGL1vb4/1z68SP5esKqvsDATtGeYj0TSdQqSvEofdIaCNB4RLrof+2OyaAgFY9eAL2CGY1qtGtJOGhFmvfwcr8dsMTgTF5fBfMsPUnejzZzsx705kgVSH3PydNkqdLz7PW3Q/RSjJQ1HmNfz642s9v972prGQI184HXl45fjtGGprYteL/T/JXWkwycIHGHgVcLjhNUsXQ+FMUbPl5VoH/7Z503G9UHOPXXpze6qz0uBA7jbSeH9XZPvRlS3c0Gn7FSSXuDq3EkXMOXZ1QoeKSW85dKB1bExhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ttxfngV3H6lKnDvvUfKS5bkddGHszwBGKHpn0tQr5RE=;
 b=fW5ZYoDK593YrhoaL/BRgnDrqzx56QLI7hX7jwS8PHqSWS4ZXTp0vIxBIt3+2CWwzeLMlNzKB7Tjk/N/UhbU85EKfTQY7SX1NwNlUS8NkqAGVnLePBRbxFoqRRDj8wntTR+bZ6oNtASkKtXM3n2DNLg94ysRdMei8tV4o81dv6xGDGx0bRs7m+dHMFFTiyO5kcHHYJJW7gG6je7DXUhK+iTGux39U2wQL8wf0pUrJwX2zFRDDNIkJD6uvKMsWC6VfqLg+G/7Ak7nMZ6Dqbuw/WpjZn/pFDlukEKIe85G3py2Kn0JQO5i+8tmi2nKBnum104bqdq9cOLW1WPAEScz5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ttxfngV3H6lKnDvvUfKS5bkddGHszwBGKHpn0tQr5RE=;
 b=JIPPvrzzvMNKQT/d2ads8Yp2iQI9LfaFy/tnTHGUQmtOyY4VAtJ2pdMjazY5ualqo57UFco5Ai3JsycxzgYlszh9z8tpjaqawKRFpGSYcmG/jl6q4ZnFSk80Rsk/WVpVH8EzdkCLl62ODFMF5CGmRLFTGaPyLSv1qU7Q9sgANOIYnMb0cRwMG+GFKm3igm3k4gL/Yk83S6Ix0iJJrWEmT0uO7kM/O7pkQFsH6IeEPnZU/PEXJn8vmosJg5e4snOCus5Od3m9aelPdSWJYe/zBcnwFq19Ybl+kylpqq8X6SVAKTSxSyweaoIeieRdm92pQkiPsfVaeFZV1L7G71pAkg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH8PR12MB6963.namprd12.prod.outlook.com (2603:10b6:510:1be::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Wed, 8 Jul
 2026 02:31:25 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Wed, 8 Jul 2026
 02:31:25 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 Jul 2026 22:31:20 -0400
Message-Id: <DJSU57KWRK33.19HLU7QCZY3B5@nvidia.com>
Subject: Re: [PATCH 07/13] mm/vma: rename vma_get_page_prot to
 vma_flags_to_page_prot
Cc: "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>, "Madhavan Srinivasan"
 <maddy@linux.ibm.com>, "Michael Ellerman" <mpe@ellerman.id.au>, "Maarten
 Lankhorst" <maarten.lankhorst@linux.intel.com>, "Maxime Ripard"
 <mripard@kernel.org>, "Thomas Zimmermann" <tzimmermann@suse.de>, "David
 Airlie" <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>, "Lucas
 Stach" <l.stach@pengutronix.de>, "Inki Dae" <inki.dae@samsung.com>,
 "Seung-Woo Kim" <sw0312.kim@samsung.com>, "Kyungmin Park"
 <kyungmin.park@samsung.com>, "Krzysztof Kozlowski" <krzk@kernel.org>,
 "Peter Griffin" <peter.griffin@linaro.org>, "Jani Nikula"
 <jani.nikula@linux.intel.com>, "Joonas Lahtinen"
 <joonas.lahtinen@linux.intel.com>, "Rodrigo Vivi" <rodrigo.vivi@intel.com>,
 "Tvrtko Ursulin" <tursulin@ursulin.net>, "Rob Clark"
 <robin.clark@oss.qualcomm.com>, "Dmitry Baryshkov" <lumag@kernel.org>,
 "Lyude Paul" <lyude@redhat.com>, "Danilo Krummrich" <dakr@kernel.org>,
 "Tomi Valkeinen" <tomi.valkeinen@ideasonboard.com>, "Sandy Huang"
 <hjc@rock-chips.com>, =?utf-8?q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
 "Andy Yan" <andy.yan@rock-chips.com>, "Thierry Reding"
 <thierry.reding@kernel.org>, "Mikko Perttunen" <mperttunen@nvidia.com>,
 "Jonathan Hunter" <jonathanh@nvidia.com>, "Gerd Hoffmann"
 <kraxel@redhat.com>, "Dmitry Osipenko" <dmitry.osipenko@collabora.com>,
 "Zack Rusin" <zack.rusin@broadcom.com>, "Matthew Brost"
 <matthew.brost@intel.com>, "Thomas Hellstrom"
 <thomas.hellstrom@linux.intel.com>, "Oleksandr Andrushchenko"
 <oleksandr_andrushchenko@epam.com>, "Helge Deller" <deller@gmx.de>,
 "Benjamin LaHaise" <bcrl@kvack.org>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>,
 "Muchun Song" <muchun.song@linux.dev>, "Oscar Salvador"
 <osalvador@suse.de>, "David Hildenbrand" <david@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>,
 "Nico Pache" <npache@redhat.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Hugh Dickins" <hughd@google.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Jann
 Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>, "Kees Cook"
 <kees@kernel.org>, "Jaroslav Kysela" <perex@perex.cz>, "Takashi Iwai"
 <tiwai@suse.com>, <linux-mips@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
 <dri-devel@lists.freedesktop.org>, <etnaviv@lists.freedesktop.org>,
 <linux-arm-kernel@lists.infradead.org>,
 <linux-samsung-soc@vger.kernel.org>, <intel-gfx@lists.freedesktop.org>,
 <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>,
 <nouveau@lists.freedesktop.org>, <linux-rockchip@lists.infradead.org>,
 <linux-tegra@vger.kernel.org>, <virtualization@lists.linux.dev>,
 <intel-xe@lists.freedesktop.org>, <xen-devel@lists.xenproject.org>,
 <linux-fbdev@vger.kernel.org>, <linux-aio@kvack.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-sound@vger.kernel.org>
To: "Lorenzo Stoakes" <ljs@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <cover.1782760670.git.ljs@kernel.org>
 <fc8ac30d03d29d236e76542b36432bba315aca60.1782760670.git.ljs@kernel.org>
In-Reply-To: <fc8ac30d03d29d236e76542b36432bba315aca60.1782760670.git.ljs@kernel.org>
X-ClientProxiedBy: CH0PR08CA0018.namprd08.prod.outlook.com
 (2603:10b6:610:33::23) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH8PR12MB6963:EE_
X-MS-Office365-Filtering-Correlation-Id: 35c05e9e-54ea-49ec-52a4-08dedc990200
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|6133799003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	6zKyg7WjKnD8NHUW7mttETO/Y4eH4we/E1sHMS0ytvmyx61z1DwP9ufk6c0tJEUYMPG6+jc8oM/TxoPAmcQ0jmsfCfDpWtLWfo8Ybq/X6Eq2xYl1ozonJjXPHKNxrCL9QL4zoW7v39R/GrOMku2OopmKutnX5y4HRYskg0wH6GkRNZoWn3zetDf7nthvPB4hQ0RvmCndtzlxbsNZLMntn2iHiycbmFQ5pr5XwT7hSOyxodTgR0IEVEIicRrduNzgGlFAIJXV92AcWC12zxAwsk7d6sSVbk6cR8Pu00D+5c7sqR+bWNw4nufj6eyN3GGIe2gOpu7klmj7sZ/gmhe+Kv4zIdcY5ftrpIFvoq1LuM0uc1P+l/q9r5p0GRizZ8L92p7UmF00woumt63jpCJ5xkfRZc1VvcSNY+FDROYGjAqEs7HrbiYSA26DiWXkHnJWz7rhTAM11ps2bLrrhiyP6hSouKyYXmUwGkwg2Mj0cDgQQK0CtJumnF3nxsTpVYsGHc+jH3Q+HBSZj/TeLjA2ee37eibTE714X7n92NPeode/rgqzXyBmWQOgji5Vdno2xtUnN8JGI+D1BNqdAdi6yG31Y63pEgHB0CKTbUehSDFQsgmh/0YYCQJvZnqYkO5F0V7wRilVzsm2VFpv3rzL/pzOCEJXa6opgisfRTMleXM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(6133799003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3M5UnVicVlCaS8xUzU0UHRRNVRKWXBPWUZFWE40UnllR2xOSERnZjVqblRF?=
 =?utf-8?B?Q2dUQVFocGMrZEF6ZnFraFFEVGNicjNYUUZReGN2TVdzdDN3cmJMZy96aG1o?=
 =?utf-8?B?RzBMK21zU1g0RUdIOVlIbjZ3Nk1uNjIwN3piQ1p5U0V5UnRGNmtjTSt2MGh0?=
 =?utf-8?B?eUs5bWtKWllwcm03S1NuTlZsRiszazFtc2t6T3I4Y05TNVFvUWhMVDVYdFFy?=
 =?utf-8?B?dkVQVStGeEJpdm5oNGxIb0lwTXFMU2c3U2R4NUdTWFlTN2FvTnpCWEk3aUNQ?=
 =?utf-8?B?ZGJFNUliSXY3Z2pVR1lETFlmNHhsdm5wT0V5Ykk2U3hsOTlBWFdzNkRxVFda?=
 =?utf-8?B?OXpBbmtURnJLMnh4M2VKWTdKZVlENkRsNVRuQXdWVmRPN2hUL0pGOGxMVEJS?=
 =?utf-8?B?VUVzYlNGalhZeVlqZDlzbnNWMWMzNEdhN3RGeTlVS25hdnFjUmhTckoyNHFK?=
 =?utf-8?B?RTgwUFhtbSt5aERYOWU2ZTRjelhkVE1KN2ROLzhNU251YXJIRTFWTnYwUHRP?=
 =?utf-8?B?b2dRL2FwdGNtUEtzbUJ5enAyMDJIL2FXOXp2WlF6MmhkRjF2RTd3bW1ydjY2?=
 =?utf-8?B?VVJ4N2RPZnNjdjV4VXA0aDVNTTIra3hmTy9yeVN0a3dSMmJHU21ERnVqRXlJ?=
 =?utf-8?B?NUFoQlRrelpNdkRFV0FmN0h1N0dVbm5OQWtRSzZZdHN5K0Q5S1lUV2s2VWNl?=
 =?utf-8?B?ZjFXZ2p6ZEMrQmh2UnVyY2xQc0tucGtZellLOWdreGM1VXFqdy8vOFVJWXd1?=
 =?utf-8?B?dVB2MldGamVTYngzbHBQZFdYL3FGTTJaajFxNnA1SU9HVzBVWmVldDY4cHls?=
 =?utf-8?B?bTNNRml4SFd0VzArSWdpSzN5Z216OHVKSStraUVudlUrNmJEUHZ0U3VNV2Z0?=
 =?utf-8?B?S1lEWEpXMHdKL0RURDdJZEFQTXV3Q21oRlhQY2xaMmhDWFNTYUs5RDhSK3dx?=
 =?utf-8?B?cUVEbE9lUFJEM1Jwc3RjVllPWlFxSE1vcDZBNDlnaGJBbDRqd1JVTTA3dFE2?=
 =?utf-8?B?ZXZ2OVVlN0RoM1NJS04va3dtY2JWbFIvSWF6RDVaeHhDTFlOK0JGNFF4RHZx?=
 =?utf-8?B?UjJ4RVlWYVFkTDFSRTB0YUZldTVaUFJraFArTG8wQXlIKzhLbGQ5U1FCZldB?=
 =?utf-8?B?SEhDbzhKVER0RjBvQWJ6OFZsMmtHTW1wR09YZldpSUNlR3o0SURLSHRNeWFR?=
 =?utf-8?B?eUxiY2xBc1I5QTFJdjMrVXVXVTFVeFZadlo0am5wTEU0YVk1TkVqSHp5S0dl?=
 =?utf-8?B?TGFVZDREWC9LaFlHZEVSNzRYSW5nNmxhNkh2c0czMUJqVUJyUDliRlBIMmdY?=
 =?utf-8?B?ODV2NEF0UTFGQy9RR0pPb096RnRzTUpobm1YVndEeFM5ZlRiOUVJMlBlZWJN?=
 =?utf-8?B?Nnh6SnpUUWN1bGtmZlRlUzhLRGZvTzVCMmtnZWgrRC82KzVCZXNoYUd6Sm9h?=
 =?utf-8?B?NzNYam1LYzR2QUh4ZGNsbHUwRkVGVWhsME1CVFBScy9JN05hMlFmb2Q5Uk81?=
 =?utf-8?B?OGVlQ0luaDJpOGUrNGdocEZhZC9qV0lQOUt2ODBaakQ2Mnc5YTFVajQ4WXJQ?=
 =?utf-8?B?R1psZDZmVGphbnZRc2U1eTR1a3h0RkppaWdpeWMwejJZNXErelhLdXlUTWN3?=
 =?utf-8?B?c3RISU01NXppQ2FtbUJ3M3FTMDd6Sm5JQVpDSHIyMFFNQU5UV2M0UjRqMTNX?=
 =?utf-8?B?WG53ZW5iS0cxN2g2b0xCeCtiQklITko0YlJySlRBUzNucEtwOXJLdE8zS1pp?=
 =?utf-8?B?dlFyZEs1aUhYblhJV0NGWitLSGpXVHFkblRIK2d5TnZIYUpUVGo3YmoySFVL?=
 =?utf-8?B?MlZNWUJzb2QybDd0MkVZVWc1L2ordEJtSE91Mjl2RFJSKzR4SkFTL2FLdHAr?=
 =?utf-8?B?R0N5MWdZQzA0dDdPLzUrc0VTMGgyaWZXOGM1Z2FiWVBDelE2cWt6OEJrUWFw?=
 =?utf-8?B?d0tkamJaMS9iOFBiakVtVW1iYmtIU3VrVkJ6U1c3THIyU2RhWGdBeFo4MG1p?=
 =?utf-8?B?SHg0MmRnQ3kvMVBKQ1FaT1VoT0NHbDdra09hTURYQkZVcC9ta0JNOTFrMUNK?=
 =?utf-8?B?aENJQlE5enZ6MldQWjZoK2VPelliYkRXMmM0YTdRNjR4SmRFMnVkMTFvNlg4?=
 =?utf-8?B?S2tZeVhNTTRMT1JvVHV6WnoyS1k2KzdTN2hDUytUZlFRWWl6YTkvSGFrRGRj?=
 =?utf-8?B?bjdab1R2Vk5hUnMvYzZvRGVBZjk3Q0d4Nnd2bUQvZU5OOW4zZ21OODQvbWdj?=
 =?utf-8?B?OU4xQXZYQzExTmxHenVIVzhSc2N0blhUOERlcis3bUhPQjdsNG4rbS9Qa2U3?=
 =?utf-8?Q?Kwfh2rNfvXERP8o4CW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35c05e9e-54ea-49ec-52a4-08dedc990200
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 02:31:25.6540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kKvUwlfFwMZciuGBJ3r8u8SzFQpEl+WufaAGMp3OfxQGrThdSXoUxmksrRDhps6V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6963
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CD1D9140007
X-Stat-Signature: 6zo1obgnridmahffx8ww988mwy64tky5
X-HE-Tag: 1783477895-236364
X-HE-Meta: U2FsdGVkX1+iOrgFrXTjibzwBrFdnIvtD6iqQFxMk7ZUUTwKUami11VwsOfJX9AEnATkBEmq4Lqykvp7yLVoXk842kaz/T25uVvwCeRJ86Cd9D0GwC7fBrBwTi6q1Z2/iYCUe0QvO3JjT8mOGOwpcRZD2oHX+COoRmSjHmy2Ow7JuWNzspzho2DVLeGXwqX+sbv+lMkGvNGnOkjWot/N9OTN0m52dK3JS17yjFbJqUJXvgKApz3dHkmEV/16z0O3+wE86HVJpq0MiogfYrCoIl/gYd68WlsWYhMVYTUA+vsF6k3YyA2BRHwlN/it9YaISrQPdtKKyTh0slKtyWoN2CgyrPtrvLcdz/3TNpJuXu1YKlSVAlz1pHhMjlo9obubzy1xc8n7IhOT+ZUSCEduoZyjmIWRjn2AFIGe10gGgJRsNt9zPTo8yAshTDk6XaD5m+AIqgEpq/sCYt34mFyw+iomSnEjPnBRktA8KrGZvY1WFCQjvxAxiWT/RjkVYNZs5o9ZB+VPoE69703WGYao9bldTw78h4PrvTEQc2M94aRKrrbE8zK6UoOb6vsd8WVdSoK4TiqJLDcNvUyMRkRjfK5UOHUpmm8bdjT3NCIEvSiG3WDuTM0tZ099iOboXMOA5pIUT1QbI/rKxeqhjegVzl9uHbDe8N0t3RkVI9S+AKRMf1tmS80GVPqMB5W8Fd1UmW5TMbNJk1oWgRSfWpOlOqyKro0cy3/eLjleVtvfOI6ri6aLC7CjBtR1LZxFyMWhUER3bDL1B3frPZLT/5X3JS0gnra6BaK+mRNOENrtu1ly++fT4MD9pfd0l0HRLKsZ3IvHW+jCyaQfZYyEhqectZ7WVmkd3M8raprZIJqA6kPNEfO47A/iFj855kgLNICmOhdTYZBK9C1npP+51knnl8e6KDuYnUEAvoHnUwkYjvk4Lq70ESu5TTsj8EzP/pTzUHMvCyNKoGh/bcZ1nA1
 iFHn86rf
 VaS9zVsX7PJYjsodPV4PWYAAD0kBYdu0KcOlRWlDjmO4C/aheIxVp1zOQjvz99YWh3m/kJBQD7Ci+52TfeidKJBK/US/0dye+JQe6YRmh0ff+qH7KnnhlA8g7yDRB3cD8sPZdm2/Pft9gsFmEmInw3k24T59B+8g65ohqUfYU/QUTjgPnwUkMJa8ePmRurjtCMmqSWjzjpUXntULcCNzNK3UAKK+jhlZZXGyEbEW/022lt9TYFP30OpdS0i4iQKiNhtNH7UkmIyv1Akgu0W5wqN2kUJnOeq2Mq0bu/8QSo36VJPoUpyC4oYM3oevlxDRa16/TwC33IvCJ9G8BwfVoDnt0mmMTD03IrcMCbKSNwHWV9+8/bNGZZTFD3ehoki3iFN5/JMmf2eVVTQedNFHTXXR9XgjkJMjXSuEu4DZCaDgZi3EL2ycXfbF3DDdNIzmPP/Fcdxx37vW99KdxOQbYtSjHHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 29, 2026 at 3:25 PM EDT, Lorenzo Stoakes wrote:
> Having vma_get_page_prot() refer to VMA flags and vma_set_page_prot() ref=
er
> to a VMA is confusing.
>
> Rename vma_get_page_prot() to vma_flags_to_page_prot() to resolve this
> confusion.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  include/linux/mm.h              | 4 ++--
>  mm/vma.c                        | 2 +-
>  mm/vma.h                        | 2 +-
>  tools/testing/vma/include/dup.h | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
>
Makes sense.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


