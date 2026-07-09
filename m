Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A8CBC44507
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 01:42:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA2266B0088; Wed,  8 Jul 2026 21:42:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C55926B008C; Wed,  8 Jul 2026 21:42:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2C16B0093; Wed,  8 Jul 2026 21:42:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 652526B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 21:42:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5D85140344
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 01:42:30 +0000 (UTC)
X-FDA: 84967538460.14.1C5EBDC
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012035.outbound.protection.outlook.com [40.107.209.35])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7E54CA0004;
	Thu,  9 Jul 2026 01:42:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iFipjYQT;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783561348;
	b=elJHtaT+2uL9ypH8PHbhjwa3NbmgcDngyw1bPG+W9rWGlNeHPJw7vu+WJjaEuXYa+2qeAO
	IECoGVlL1ExJ/eLab63MqIITneC7xgVQrXyroq0nMXlTspq7l2KKAGUx5pGsh3CkRcybH5
	erK2M77EGOltnZJ19jtVslB2Cnk6A3o=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iFipjYQT;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783561348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IVIBhTpOaROuHvF6ahUTy2dAvqf31/mKwSHQfgbL6Lc=;
	b=RL5sNDbopAgEuaeet/XrUhiJRh9BOdrQjeKlX05WYj/eV+QhAI0XVD2Sznwblc+pRbHi3+
	QriN+5QR6jcEu/hfybgGuwwRJS+rWVS5epiwFYXBCkqVUwQL+jtRRf9O8K3gzkp15NTEeX
	hi9X9Z9Lq7tBTn/pTB4BT5k8aiNoz0U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fCnCdcuem4tBr4eLP8PMKQdgNKerX7CgiAvMpDZWUsFdk1Jxp46amCYW+dY/3Ll9YaHbMzPHFm9bOjBZhJ6nsTBt9qYKvJW172gTm2VBLleTAEASxXBBAHqg3SxHkxY9wo9fV8mG2iDmS/LFN5D+ydAxn8E42UEVk/VKFvGWpmc7BTIrTYvB7KjDMoT/rhFWDqr61GgPyFDQVgagQITqsjUdoV8g27Dn3rf9sRBbE3xtcJdYivpOBgb1VibUMwNrtIWZHUCg7jvm4/EJQSPu3v/xh8YJylqhD2+K3s5KXUWpGV2JSIipS5lYs4l53Wx3InTLhqx1Ulk4D2FHku6mIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IVIBhTpOaROuHvF6ahUTy2dAvqf31/mKwSHQfgbL6Lc=;
 b=j/oiZbB/M25WbfMqsPt6SHbr5JQ4GB+AFyLON/P31iBmGtiboVQqMcWOnU50MfRNEO5eSOJ3vysQLSXiZW8Qcq89GP/smkMMQyjEm61vls/3G6kCaiqFSLCzZIULoEdz/5XYa8cb8+EvfPr1XxsY4eAGdARFI2g34P6zjrRol6sLUVGM4NEXvC/nEIm6LbOFPveDkZWOP+vQLK5s+lHfONxstZVvqkSGT1ZpUI/slvs7nboryTufpF0enGgASfw3TrSctSQO9d9okCYmrNHz+lXvx4QOstkpSSmKH7HQy7Ii245pFrqnKZk440zWN704ujQcN+xWTUTN6i0M5n8eYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVIBhTpOaROuHvF6ahUTy2dAvqf31/mKwSHQfgbL6Lc=;
 b=iFipjYQTQqq5fs3iPcZaoPZB2RpRe/63nnG/HHtinAA4RbJ74R5DDWhY3HfUrZ5j3vtkxu9apljHFFcztnDLUoLK5xYC0wjSNrdKtvtO3Z6Hb4BRYYwXhZrD21VKBWo+L9xKO+9HB5oTIj3mUDOb43IAIx6bshVIy6tf3uvKDG3dadt//2SlIErRR1mGmgVVPprXfECxL14IBBU/xxoIcOMwSGV7ccroZbIrZbFD3SnLuq7MerZQjR22Q6fmZyaBvf1qBrO5iyQkji/D2s2DexANMU6g/XHjeBMEBWKd4UKx1kUwLoJTIJkZlRBZcwy0pRsCT7YSgnKEVi8jbG7FMw==
Received: from DS7PR12MB8371.namprd12.prod.outlook.com (2603:10b6:8:e9::18) by
 DS0PR12MB7581.namprd12.prod.outlook.com (2603:10b6:8:13d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.10; Thu, 9 Jul 2026 01:42:13 +0000
Received: from DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a]) by DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a%3]) with mapi id 15.21.0181.009; Thu, 9 Jul 2026
 01:42:12 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 08 Jul 2026 21:42:08 -0400
Message-Id: <DJTNQ2XBNZRN.1BXP2OD707H1Z@nvidia.com>
Subject: Re: [PATCH 09/13] mm/vma: update create_init_stack_vma() to use
 vma_flags_t
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
 <34689784ee6856f100c02ad4eabeaa4db643713a.1782760670.git.ljs@kernel.org>
In-Reply-To: <34689784ee6856f100c02ad4eabeaa4db643713a.1782760670.git.ljs@kernel.org>
X-ClientProxiedBy: CH0PR03CA0432.namprd03.prod.outlook.com
 (2603:10b6:610:10e::20) To DS7PR12MB8371.namprd12.prod.outlook.com
 (2603:10b6:8:e9::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB8371:EE_|DS0PR12MB7581:EE_
X-MS-Office365-Filtering-Correlation-Id: ddd5ea09-0887-4050-e353-08dedd5b4c5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|22082099003|11063799006|18002099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	iDiRatKBFoWIm6T/kdGH9JywwyvyG75N7yZRXTZbHUKMqVc1qvxFNnu68X5+uwN/CjEuQ/Gw4UQyVdn3yPjee0lKSj3nPN0fRsAGEm0qrb2gg0JD5HsexinLGxYmgz6ZDgQrTUZHs4hticK3iPXOEsmSSZWI+QJjB69HSJhpgX7LABIju2O45PgqIV7mwRtn7BuieWeENDld82vKJ5quL9UZbWAgFwVzV+JKsQplbNdprqYOJd3W/pzhsJC6svOh9PUCIJtYeCk/ts2Q82cDX9GTUwc/JC9t9UcihbiGycxMgiU4F9bZdineBrPg4OWunXCQ+i9EKyBPuU2qPap/SI9uygh17IuNdAepzg4MmYWVjX/HhXKHaezFVLJtOJau15rsp+xzeLXw9xRruLFMdPB9gjA6Z/E8ET8XQ5U8AyMrley3aFby3Lg5u3ZJRN4wVteOIUdj/nMJ7QvkDtDg3t09r8cA64L26IX3mbbJr+dulpy+jxVUlO86ayU4Uijf1dkmRabMWJjK14R92nUawQJtPIISmKO6wlT7eaosuRmbLQSZaGt9tA7sXgfKUQt9O2eBQXO7sLJ5/5lW141ItfXF8avRCEClgkd+rj9mDlpuKbXJMcdMdCKotMToohdv2kB2KZH8CSX3mTG166Mf9ji5/yobdynoNa6Ptg34DNU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB8371.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(22082099003)(11063799006)(18002099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UTJiUVhXUkZOSklCZnAxQ2xvNng0VXhpNDhucmorb1Nac0lUNXJlUzczaWRO?=
 =?utf-8?B?NERqb3NXaHZ1Z3pEZ0RLVU5TUCtyS3ZqR3VWWVpBRGpvckVCNnlmalIrcUFY?=
 =?utf-8?B?eWdzd2tlOWNuNGxsM29oZDZneFZXcVJkK1g5R3M3L3BHSU91aWZmZ01NOXkv?=
 =?utf-8?B?Sm1ncTNyZTREb3lrOGxEaDRqWnR3bTRSekZQdmxoTTZYQ0FjYTc2SHhkUTA1?=
 =?utf-8?B?dTNoclVkUzRHWnhUM09Ka1VHQmZ6c1p1SkdIQ1dhOFBJVmpQZDluSlJxdVhn?=
 =?utf-8?B?WXgrQ2R3TjBIK1NROEUwU3BEK3I3dDZ6WlpkWEdNZDh5UisyZDczMlowT1Zz?=
 =?utf-8?B?LzFHa0hKVyszeUxNaFlOZkhMcUcwbEt4YkdrVXMwcHR6dnVPQ1l3ZFFkdk9i?=
 =?utf-8?B?YThWdHR5a3RUSTFMaFVRQS9wZW5YRjlOSE1YUGowanU2bGE4RjQ2MitSZlAw?=
 =?utf-8?B?eUFQZ2lXOU92TVBHQ1Y1bTZIZEpCcHFJSlB6WTcxYWJtL05MZ2lvV3BsY3c3?=
 =?utf-8?B?Y2x5TzhjcWhzYmlGYmtsT21sb1d6clpJS3FBQmFiRGg0VTJ5dWwwbklXeWVy?=
 =?utf-8?B?STN6QzE5SStYNzVUekNaYmwrWGJvT2pTZGNrdERuck9JRklHQ2NsaHN0SXY5?=
 =?utf-8?B?SmhOTERHNWpCcEF1QnRIZkRzSTk0SXROb2QxQmRKTURDa3JnZFBWMStpVGhP?=
 =?utf-8?B?bjU1bUtyT0N1Q0tXeTJEZDhCTERZWG9HSWtmb3ZNNUF4b0FUVXJGeXozZnU4?=
 =?utf-8?B?RGlreWlBKys4OXVnNmYvNjl6MU8zTk9qdjlIS3dHcm45WGtsQlNMR2pkVGEx?=
 =?utf-8?B?UzgvUDdDVUFvV0dKdWlrRU9MdDFPaVpMQUFCa1d4N0FnelhFTVR5ZjJSOVc4?=
 =?utf-8?B?b0xtZncwWm8xSmlTRHZTNERJcEpYb0lTZWF2enByY2tvNFdVaWhuUmVyWHpF?=
 =?utf-8?B?WUFtSGs5SUhzY1NnTjYzL2xRRlJDK3ZNakovUXZBTUZ3TkVDMCtMQjNMbU8z?=
 =?utf-8?B?WHVLVEoyL21NWkYybzBHM0Y4czA3VWtMNWM3aEVzdnY5R0NlR3E3RDhxR0lD?=
 =?utf-8?B?TzBXN29XQzFBelMyNWhNUy85R0pDbk44RFFOeXFvdDF6Y3pwTWZNRHhUSHA2?=
 =?utf-8?B?M25tb1pMN01mSDd2Zm5Ycjd4RlhiVkJNV1l0Njg4K1djN01ldHkzdEZLQTk4?=
 =?utf-8?B?SUFjU0FpZ3dLcmtmSDN5QzRKOHRFZkhGZWI3eHgzVi9TV1c5bG5EWkNzditM?=
 =?utf-8?B?UVZhcTFCMWEvaTJRTVdrdmExSDdWRlZ2aXNUdjVBVVZFajZFRG5RT0RTMFh6?=
 =?utf-8?B?cS9HK25CRDlWeGVMTFBHbW1KRGxFOXlQbFRvV0g3TEI1QVBGTzJOaDFzdlVU?=
 =?utf-8?B?NThMSUJ4ek95dS9XZ1BhamxrRE5JRHkycW1ZeDdVa28wYnlzRXpGcVhuT3ZN?=
 =?utf-8?B?YnEwMVNmOGx6SVB1dzZjM3dseUthVE1RQ1hMd2ZjUE1wdGdkWVlzSmNSK0Vl?=
 =?utf-8?B?eVZnZzVmcTJkV285WUlIZHJPWXZVcHBoeTVRNGhIWkxXbDRaOUJWOVFqVyty?=
 =?utf-8?B?WHRTRGNMc01hRWlSZ2ZvU0Z3K0ZsY055dHRvTjUweC9jblBleVJoQ29tamFs?=
 =?utf-8?B?UVZXcjdKUjc0bDJHQlBSWFBTSUN6S0RVcFJDdFdtTmkraWRCMWhRY3ladjdJ?=
 =?utf-8?B?S1h6UGFKV3ZqUmxCeWtPdnRvazM5eTltUHpBWkpVL2lEcExDNWF4ZmhLN3lt?=
 =?utf-8?B?UVZtS1J4bHY0bm5UT1VDL2tWMmZHR3dEbEltak9TQ1B3SFJzemVuc2VnNGdI?=
 =?utf-8?B?TmxzRTZOTmVDeSsweGFBNkpUMC9qVk0yWkZuSitNYjI0bTVmSXp3NXRpajM2?=
 =?utf-8?B?MWNlTThqc3F3M2JQcXJuR3FGUmtxSGFWbXZkQkNEc05pcG8raHZhQzlzVHBm?=
 =?utf-8?B?UmNOZlloOW93Vnp4czdEbzhYN3FKd3pDenMxeUg2OXBQeTAwVlJjVm5sQm02?=
 =?utf-8?B?ZVBNeE5Dbyt6Z3Nxa09DMGEzYnNML2NRc2lsMnBJSGlnQURkKzZSMEF1WCtE?=
 =?utf-8?B?LzFCbWhNS1pnUERGVHBtTDg5Q3dKZHhGcEYvZFNCeXF6Z21nQmpWVDM3bi9n?=
 =?utf-8?B?dzNaYTN2RDJZMFFhM3BrbjVPVHlab01EbHJveTh5aGtyS3BLcEF0MytHd1c4?=
 =?utf-8?B?V3F6bWg1eWlZMEs5ZVFHOUtIVjdoTFdPSmxTVUpPOHBFV0R3RW9kSzc0R1Y4?=
 =?utf-8?B?Ym4xWS9PWXZ6dVhTRjBiSG45V3VIZE1aRHdXN3ZvZ3paRkpheDY3V2JQaTNz?=
 =?utf-8?Q?YkDc304XKvg8CW2By8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddd5ea09-0887-4050-e353-08dedd5b4c5d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB8371.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 01:42:12.8101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: koNURsUO6db1sQKHwoSjxAarTfnslf461+ZBpMIr7QAlsBVvHV1isp9f2QO8THZW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7581
X-Rspamd-Queue-Id: 7E54CA0004
X-Rspam-User: 
X-Stat-Signature: 3p63wwhkrc8qheqrrjydy9oqnu965eaf
X-Rspamd-Server: rspam03
X-HE-Tag: 1783561347-665312
X-HE-Meta: U2FsdGVkX1+WFJgciH11E+16LRQwy22Tnl0L5UJmNgId7lpNN5fcEBp7LlhJxWMCMad4RdoeX1MvzeDvm1HzYyrfWaIPh1j/Y5QfeDa5DAgrLiQ74BcOu0B1RWRHer6THCcBsrq6H9PW134ZNlfSHJQaqXAjtm0aTdnrwC6opVPd6ZtajmhwtW12NxvQSsGpdQEK/PFLA3XhrxdPK4JDOqYrR7WCpfX8VidQAIXd6EYjxWV32Ox+SA6Dl2Ustidu6On4s06VyKXmO4LNacKeh+T2QCrLH4pa3ZgeWY/pUHKqzHfGDVIZ4HLS6rcfHEhbdZ8oAi4cs2pjaKO0AVewbiX+Phb22JmL/aRBeko4MpXnujgf9pXjPjiOQI15EdZe0rAG4CweYPIscQpcaVoeIEo+ErnQpta5mtcGJ/0WoUG+PmsWDKPTqrS3ZFPtbhu63klFAVb//soIc370UIp3+WEbvpBAFO2/LCxvudrAYWxnvhI9sobE9mGZ2Sv/W0XnEZysooh70X3IZAoOGJ9JcyTlM6KUzXqlxe2fUbgoCXZ9Vr+hq92NXkeaF7G3kdZ1sVWANoGoAkaIZJBU0hjmXWw87CQLtZhMyOg80T7RMKtreqw2obskY5freGSYm88hK8zug1E2CtwaaD4wdvWpBlWwyK0jN6YLAQ+byjxk2G8+gRJRw409yyTQP9iRU20T6GxmPRSaCh02kCv50YCNx2o2blrQsRD0goj+Bzw1whgkF+Hk6DmOleiQRqKQ65CPaVdxpFLNMyfJ2DSFo3fHavnJaz/qG0/MrNwiGU6xtrvCiNtp+i/eSBt0dlQ8cmwaESfD+6wdHMQh4YBVs/PLmpTGTP239rIpmS21TGjlsFOePc5m/KLZG2tDW/gD6RF230Nm/xLFn4wqlmJgFcbXGqgnwQzCgtBIoJYmjsiH/OWFkRLdCp/BoUq05SMlx7A5uyejYSNZN7rY3yDfwub
 9zr6K1XL
 tkfYnaoOPQCkm9Hd7CBMQ5YI1pzK6krsKVccm+ZRKPEF91gT+ZS695n78b0iMkh3FRevvUvlLtZ1TO7ADHkcf8e0TYiLiFHghD8jZDvUFgdGMJskUU5ZDkFfNL4QIieD1qxwqX7D7s3dVvWfheUlOJmHbCWmbHhANG24YTcVe2z/Zmc1tbhUfqQr1cv7G8K2wOwUbXiccMfRY2RrXJKtj7goVe8ykZ9yKdErypbAWMfKpz5IAf+tJz8yENiXlLsnCCTY6pygaveVwHeDAph/F7eydMOeBT2G30SWJqtPIzeDJxBDCOeSBJD65CJ0LSoS48fBQwYc5bsTK6oJI2360YYY9rxtHJPjvz8M62UuAPrJ3vwTgThO3rLU/E4/3+0tBQeeOj+9BZbIY6DXqlwS/AeSGp4kscruu1XJH6gbdRHkOzhEuEU8yAsQSIRBZj+xGIXRVNBlkl98NwxWZT4O77/3QBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 29, 2026 at 3:25 PM EDT, Lorenzo Stoakes wrote:
> Replace use of the legacy vm_flags_t flags with vma_flags_t values in
> create_init_stack_vma().
>
> As part of this change we add VMA_STACK_EARLY and VMA_STACK_INCOMPLETE
> vma_flags_t defines, and slightly rework create_init_stack_vma() for
> clarity.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  include/linux/mm.h |  4 ++++
>  mm/vma_exec.c      | 18 +++++++++++-------
>  2 files changed, 15 insertions(+), 7 deletions(-)
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


