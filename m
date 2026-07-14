Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA273C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 02:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 884E66B009B; Mon, 13 Jul 2026 22:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833E16B009F; Mon, 13 Jul 2026 22:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D51B6B009D; Mon, 13 Jul 2026 22:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D5B46B0099
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 22:47:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4892A0269
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:47:03 +0000 (UTC)
X-FDA: 84985845126.11.EF01E99
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011037.outbound.protection.outlook.com [52.101.57.37])
	by imf16.hostedemail.com (Postfix) with ESMTP id 495CA180005;
	Tue, 14 Jul 2026 02:47:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cOUZIdER;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783997220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=feoIft/TLZO5dAhIHPg4039QYB9mwrIWxTuA8pa59uw=;
	b=1xyv8EiO8wETOQvPc3CDQllG8r9pPbY/bPAci89FkmW2+d0dqOwBlhv8GEZmzI+yB4Nn/s
	H/0l050EKD6xrndUMiVfYD6+R3T/B24KZwrtMMjRXgb7KULP7+TM2S97D8NXBD80F+KYO7
	JvxFKUGjUKvUKrko39l0z5Esb85azb4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783997220;
	b=8ddyXkdVNAbVQcVOp2Su8JQYL1T8hw33gk0UF59JXSEQqnNBrEDJ1VNZcwQom2ilUbGCVH
	7NNSBOHy883ExMln0nsGtEUQh/vdvd+6ka0R2MdNuXZnpymN9hn+HgOksQ4fG0BgqxaN6d
	1U7U78gfzitt4irpVGVHooLUJRJFUZc=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cOUZIdER;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zE7+KsZQQV1iRbogED6kqqSbDBxNJ9jxwKu6XWPkG0GSZpmms0KWPis52BtvJqzhNm3aVdPulkpKsoPHUa3sDTle/ffziZX5Tzvp2fjYbQ8QogoLbiKfaqLC4C+3omLaXUbL1ULP/Cd6/F97Wc2yhMwuYSOgRusDfJQ63oHxXg+1xLcV20CGNSVgiBYwWqJGkiRg+F5xIedh++c8CtdW1tD0j4dnjjP1677QRkrTAWgaraxePJ/n5W9c9xEImb1G+mjIR78zqQrSxknpkgB2Lb6N38UkoWwqzfG1D1iczM/Q+RhTEg5IKwBh5I/K8YvAEoZdl3VzUKix5yCBQKR7Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=feoIft/TLZO5dAhIHPg4039QYB9mwrIWxTuA8pa59uw=;
 b=TNhPwswseZss5Gych3ttTHKSW12ot+F8D8thV0U87mPrelQWF29y4bKvaQrTeHlqH4bsW7V1FSO7LOVymiqo3jvA1gCOsddKoFgpne2EBdNX5k6ZA/R5xv5OWJr7nHOjjqlzyYFk2fJuhh2Zxc0UZsl0YloQNYYDwBV9m/G0mhxRf99ksaT9vVNiYHhMRniWNfXRxkC9VTZ6VimMnvKKWeq2361+pHdRa2T3Ra3j7biDVZXAX5ikfxjUyodDWcit31WlMdKD0iORbie28nhbE+OZIA2f1Qq3GmlNowFIBgwjEZ8hKVJOgUwnSCh/JJXA3AxBvxvcdij21UZEq0iCjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=feoIft/TLZO5dAhIHPg4039QYB9mwrIWxTuA8pa59uw=;
 b=cOUZIdERf22OunYxGqRWV0nEc5kxavp7gwUfCeG0vobu5aBFf74lQYoucZmsfnAGgzhISe+WUE4j8bv2KJVSxSVdTAiZ+XUDBar7iVDqZHYFgULe1wlG/+IJUwdxYx8DO5Og2GP98TaOXI3hcH9AJWVUeWiTk7v8n0TWq+8E64MTfW6HNB99hA9/VCDvtzCwgPAHFQqK6jri8k5D1xlfQNyG2umuf/mJJHitSR8nzGK60xO5LTp6ZHdtzTY6wkPNOKWCwRTvBOdC+p32lzC9cOa+7CEM4fBZePtZTMIouAnuRqZ/J1CStrJEfX1TyglwiCT2JarokvOS6rk1JSkMBQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH8PR12MB7136.namprd12.prod.outlook.com (2603:10b6:510:22b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 02:46:48 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.019; Tue, 14 Jul 2026
 02:46:48 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Benjamin LaHaise <bcrl@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Lucas Stach <l.stach@pengutronix.de>,
 Russell King <linux+etnaviv@armlinux.org.uk>,
 Christian Gmeiner <christian.gmeiner@gmail.com>,
 Inki Dae <inki.dae@samsung.com>, Seung-Woo Kim <sw0312.kim@samsung.com>,
 Kyungmin Park <kyungmin.park@samsung.com>,
 Krzysztof Kozlowski <krzk@kernel.org>,
 Peter Griffin <peter.griffin@linaro.org>,
 Alim Akhtar <alim.akhtar@samsung.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
 Rob Clark <robin.clark@oss.qualcomm.com>,
 Dmitry Baryshkov <lumag@kernel.org>, Abhinav Kumar <abhinav.kumar@linux.dev>,
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>,
 Marijn Suijten <marijn.suijten@somainline.org>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
 Sandy Huang <hjc@rock-chips.com>,
 =?utf-8?q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
 Andy Yan <andy.yan@rock-chips.com>,
 Thierry Reding <thierry.reding@kernel.org>,
 Mikko Perttunen <mperttunen@nvidia.com>,
 Jonathan Hunter <jonathanh@nvidia.com>, Gerd Hoffmann <kraxel@redhat.com>,
 Dmitry Osipenko <dmitry.osipenko@collabora.com>,
 Gurchetan Singh <gurchetansingh@chromium.org>, Chia-I Wu <olvaffe@gmail.com>,
 Zack Rusin <zack.rusin@broadcom.com>,
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
 Matthew Brost <matthew.brost@intel.com>,
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
 Helge Deller <deller@gmx.de>, Kees Cook <kees@kernel.org>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Boris Brezillon <boris.brezillon@collabora.com>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
 linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
 etnaviv@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
 linux-samsung-soc@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
 nouveau@lists.freedesktop.org, linux-rockchip@lists.infradead.org,
 linux-tegra@vger.kernel.org, virtualization@lists.linux.dev,
 intel-xe@lists.freedesktop.org, xen-devel@lists.xenproject.org,
 linux-fbdev@vger.kernel.org, linux-sound@vger.kernel.org
Subject: Re: [PATCH v2 12/13] mm/mprotect: convert mprotect code to use
 vma_flags_t
Date: Mon, 13 Jul 2026 22:46:45 -0400
X-Mailer: MailMate (3.0r7017)
Message-ID: <E797FDEC-48B6-4D64-BEA1-3A15D5379652@nvidia.com>
In-Reply-To: <20260711-b4-vma-flags-mm-v2-12-0fa2357d5431@kernel.org>
References: <20260711-b4-vma-flags-mm-v2-0-0fa2357d5431@kernel.org>
 <20260711-b4-vma-flags-mm-v2-12-0fa2357d5431@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0280.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH8PR12MB7136:EE_
X-MS-Office365-Filtering-Correlation-Id: 98d9eb02-44c9-41a4-6336-08dee15226a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|18002099003|56012099006|4143699003|11063799006|22082099003;
X-Microsoft-Antispam-Message-Info:
	g+UbA5RRGDxSjnEBQGbFA5Nzzl9skoKxx2Ji+Y63lvF4XNPGle/YwlqvU87ExSpIfBBaroYHg6lwNRb+5FCqrRqLVDR4t9PoC9WMLwUdLRWqGyDFmicU8MjQI5dj0efQlbPBN1wzsk84ZWFx3o3fv3AyLSQbPXCx6h/lKFHvSfJh+Ck88TCsk83Exfr/eIp0PcomRtd4IHCU2LDQhOgyMSTJNV7cmlhpglZIYp+CgjD98xGL48CaSIbbiXTfr98jdRv809b8lJeGCGsyLM0pkdLobMewUTSaTjEPhKJig8rbhQHuc7Rpf2Wru0+5MAk1nfANNL14YOXM9/0Dldugd/2kROMLLgi17TvpwM85cjxorQ2nz6tOWxtG0I/XrGoT0hz//aR68s+aA7JaFASLTzJbMJI+JdHPdCKVKAS+jrxTMWXNNyzBK3hZuYJxkvbS2M6OMTMOJQMbArU56BU4IDYjBZOSFYUqbE8OeDtX+3HYm+9ANCBEat87DXmbxpAXKqewMRPrioM7q1OVYfIsCqjzB1gXX8Mnk48PtCsFhgdsd6e2ZCgxR+13ebcXjRaVn9FcANGXXwfea0VikL3pjLFdOK32EMb4nYEbn3S9SeHG8twJ3+2lCzOKnUkhlDNqG5P8wh7BvMcN/VwZx76N5NMrEJ646i4OPLrXe7Hs0ig=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(18002099003)(56012099006)(4143699003)(11063799006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vbCWyyx2FA82sXVNPKB4JfuJPnluc8V5q7vTn2rk1np1pMisQ32P4fICD6IT?=
 =?us-ascii?Q?kT7J1blQ86FTj8QsK1YzTa1LVrY4sTJ7zO7uaj+Fwko08P5G6oY0BQo2yd/D?=
 =?us-ascii?Q?86QyOmE6aGFVbsYcLRYea2MG8seNkNkfd1pNaJca9hy2nk8pOtxqybMpLoBk?=
 =?us-ascii?Q?XSOGei0I+fqqhMDaJl0E9I5QvWs3RKynjdueNGlm5ipdo278MEaNzckZiNf4?=
 =?us-ascii?Q?8jtv2IJd0BMb8aOkXurh3K8c2Mk/yQYDBEpQnR5b0QSxTA1zZ2ad74k718Z0?=
 =?us-ascii?Q?QiHLiT+8Ac4rikcXSUXVRNPllSxDmHZfTUnnWIiF7eF16kDx6RcfAZ1khrGP?=
 =?us-ascii?Q?+DYZfqcfdKr0iIZvfXqq8XLQTcW7LA14SZTl4tUCpIGqTXQc+ooGD2yWdqtD?=
 =?us-ascii?Q?uMlM79iQPCMxwoYSWvqQcyBJNPYzO4npwa+4ROdFtRaviwrQnLSR83RHCCYQ?=
 =?us-ascii?Q?ReOEI4nN8CW5nscd0F2nXoBVpjTvKU9ZZbn8Zs8L/nBUKboPVca/kMoScLaI?=
 =?us-ascii?Q?og6X/ilIrb+dqldrr7x2uz180DmriJXMafQjuQs67TICNF2crG7lsEIrxywj?=
 =?us-ascii?Q?fw0vMBAXddMjgECGOQ2wHCKgoaPKNaEZlhdWX16ZGXTCQISzQ2b0wBbShW87?=
 =?us-ascii?Q?7SLNOs+rDcNZqzRDlBXaS44ZTizjlzzIerNhRFLSCxC1j0V7RwU4gJrWZcil?=
 =?us-ascii?Q?PapVxG+LFW9ITOm9YNTnqzai7nfl4oE4/oU1mCEe2HH0Gql/1UVM0oBFNlUy?=
 =?us-ascii?Q?AaT1MR8xCYznZphoXZ/lQ5F4fCJAr3pfGPP/W1bsc6SSFmcQnHMA0BCBy40u?=
 =?us-ascii?Q?uagioAk/r8buuFRdvBc/lIndPfRWSWZlZ+RtupQ3NlVBPQiJriDgmXUkHRla?=
 =?us-ascii?Q?3oqlfHERHZ0oOYfSXbUyfQsBgu8ihE+QnsmW3Yk1lhf0im7PW060Gq/K171T?=
 =?us-ascii?Q?Jam47U2XbImLlFkDaF5xqvdkVu8qjuePtYbaFLni/ot9ke9dOVwhKAEpN1HO?=
 =?us-ascii?Q?hN5+dDC8CyKXuq0ebVz7UrLcusBTHWp9Tc3I2kft5CNz/o3JMuBx7QGfzZU6?=
 =?us-ascii?Q?AH0rXEdeBaEadZakzs71dO3Pf6U8pCpmN3RQM3LM6TACQxOgal9wgR2osEM5?=
 =?us-ascii?Q?kW63q0DqjF//S0CM+p8wimC6BoujtnjB6NUoUHcfnBUdUbsBaXPzO/D3p+F9?=
 =?us-ascii?Q?/7kJ7kq7VzL4Z/Kk8YWPwiXAnYbuBFca5lKQQchHTQzp6MR59B6jd1Y/tiuW?=
 =?us-ascii?Q?qT5PJy/v/awW88y1hEKabOlLdl2yYkm2mW2YoFxOiLK/zfufgl7qUuhuN/P2?=
 =?us-ascii?Q?JB6N01+w8hGVjNrQvir77M56la4FC31hAEfv6ESNd3ClOkMBZ/6WoIxSdQmG?=
 =?us-ascii?Q?nswstxJC8yQZKEd4JetK9nisacGAzjQAYb1xRxZGfRpujPVBCgo5NwbraYNi?=
 =?us-ascii?Q?bJ07R5kxdI4Ry3tfeSA9d5CwtWkWbguGr5zMA+9rDuFcvWhHCW34Ub83A5Sc?=
 =?us-ascii?Q?kMK/qMa7G0DD8+I6fhqW8TlyzLtp28m+16x+SebPd8PSIQeNJteD2HEc3eR6?=
 =?us-ascii?Q?byJb05MwIgM9eI5Wx7ko1UcvBAl2AaRXPH3WlvO9qJ89bsJBh4b/lYWYZ9aA?=
 =?us-ascii?Q?We1RsTwRCiH0tB0yq4Ah2NxIvNAqyp2Q6NIZbhjBfe5vjIYIOyZvMSsWS0nf?=
 =?us-ascii?Q?L7UeJ0+jSXn5FYXakjzK0aA4WT7zLlUu7EBFT5kv/NvBy/T/oqlTBCRFt5aV?=
 =?us-ascii?Q?+LnaLHJPaw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98d9eb02-44c9-41a4-6336-08dee15226a7
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 02:46:48.6918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W7pmpah1sUuBVKsr1lh5nsapbyM94r/p/x7AVSFyuwMEnfxfSNJnSrS1SOk6gabX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7136
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 495CA180005
X-Stat-Signature: c8ecjy5zoi3rb4i68f5rq37ytr5r1ezu
X-HE-Tag: 1783997220-778128
X-HE-Meta: U2FsdGVkX1+g2MUADbt74WR+4+qZYpqkagk1djMQ3woKwL695k8PQrLSGpGAub0k+8dqNW+u+Sh2F/IGvWxCAFKuSzDBIqbVhexA8OR6D1OYqp/twbX0rOQ1uOZFYnaJOT4Hy6Zi1gswr92Xh+oHCJ8zAuqb0F4r/+xi3KM4ioMA9/IQb09fB8UduE0t4SacTZt0u/q6NzNoT6uaL+qWheKqzA60bZQbDuJnKcOiML0clMdmVt+QaEMZLmel+VNNYVIGsG18uNj2I7jCYoeFsrNuQb97OTXf+ewojCIqlz3+yaQB2+1ocKttsMU4hLDvqAPKve2VLToBqFwwnOphWabBebpL+OMNI9/3kvM8zNGJPescqh7novSLQn/Kye0Zexv16MqjYx4x2QV/l+i6RT7yQ5aYJCCYDNC+YjlS4qHutqbE2ft021m6Ox+Rc8f5ZjrGWHKdfX8frqFJlnWqrYNC28+nCc8quOcBXdxQaJGiAgj541iGAx3aObHYKQxWu1hcUiFzwe02cZlI463HCpHtLifkmz7B/lqmw8LhxwVLHEv5YL/+s3+ETRz/XhOEfKLOxQamVZh3GZU1beu9jfeY+7izQIzvMPKWgqlzTbNfm6HisS3y0WCikSRHeERhLF6K4jGVmocdGW/ukzAYgxYPMrjfUMCVi1MXYRfay/jFZ67njCJan1PaV+rdM2UwxZBL6mOp9SRciJ4R1iUGLU9xl+JchzPvXvzbhDqaV53dgVrcXLLyOiAdTLrtTf+nyaB3TG/Nfi9zqnYZ2McQcFSSFnXxiSV5+FFN2BlpCbyDNfElQejJ601v/r+FcxWYd4LKEwRQt9gnykw4Jyf/1mXbEbGYP1n9iY/MfrK/59Xp62HVFx7LdQ87CN6LeI/URQZKYo7yYAaE9C+D1o0OmtwGHMA6wm6j9mjrdDR4rlxAZHlmhiYPUQWcJ/GFr5hn8wMSFzKWJurJNa2i8Yj
 rVp+lUzd
 Z7OagYjZcU4TFuNVukES4a3p7QJRXGzAR0t0Ub1z5UYXXB7irVg5wk5w84BMr4iu2V47UZ9JtvT25xClSnY1PmFQ0QkrWoO4eDR723eC20DP59YDRiZ3a6YcRl92oZlmXHYR3l2eskXBOuB3CnYbox3X6ZWeccI+8W49sa5odviqgS3aztQ5qM0rajwYU22yeOcOjdKkLlNDvoZUb91SNHFa5Ym8cJouY1+kngoKzPDxLf1BS3FzPpNejby0rvFhQouoxUm40JZXUZBFsrdv/Qj1bOB2VMy3Fbj1TPrQaGcMEWO5CpBdzwhngAVqiKGlE5RBaFqgwEPF0PntNJPFvTx0B36zyboL36vOJA2HWUzvPshutsxTLADBeek3OE4BuU2LrlOLMR+Pyayv54fcObs0bJ2++4tchyMLfCM+WKC7m/BHA0xvNqA2M6aFXqATa7AZiWUQ3hR2/1kbSmLikSnARPx+DaKOToN/cN+Pu7BGTZGDTWagLwsfezrwc7IApWmZNvviT43ED0NfBVXq0OhHE7RmPbNf2BPlqEoaSoQgY7dqrn+6UZR/n1r1o0zm5ppKP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Jul 2026, at 14:45, Lorenzo Stoakes wrote:

> Replace use of the legacy vm_flags_t flags with vma_flags_t values
> throughout the mprotect logic.
>
> Note that we retain the legacy vm_flags_t bit shifting code in
> do_mprotect_pkey(), deferring a vma_flags_t approach to this for the time
> being.
>
> Additionally update comments to reflect the changes to be consistent.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  mm/mprotect.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


Best Regards,
Yan, Zi

