Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0943CC44500
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 02:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B80C66B009D; Mon,  6 Jul 2026 22:11:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B035C6B009F; Mon,  6 Jul 2026 22:11:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97C996B00A1; Mon,  6 Jul 2026 22:11:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 560A56B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 22:11:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B416D8CFAC
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:11:25 +0000 (UTC)
X-FDA: 84960353730.24.E25B647
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012031.outbound.protection.outlook.com [52.101.53.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 53C5A160002;
	Tue,  7 Jul 2026 02:11:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Rqgyb5dt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783390282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZWTKtclRrOfAi6ihxJKjALnLRbRSlyjEScPsGFqTuY=;
	b=b5JUgFOUPCPX2ZlOQiQcc5i5EMUoJeOJdFliAGRqPkJQ+eCleBzqxwJgdyrtz4orvTwU6a
	p1t4f9DhfBpuFwr3JLNaLkQM4OKOqNPaAGUDweODwXQsR2cFP3V3LP+5JfwfwGpSWuHllK
	rVRdtETZLjdmBJp4MBGmXHxqi814hc0=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Rqgyb5dt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783390282;
	b=2EuwydCKfNRgxHV1yyjXVuiGI7MTVt13HGs5B9xd7Q0s1OYevfv/DzsWwSeKDrSVGrPods
	LKsWLKqVgBXEWRixOiqjT7pR87wnRZHa1Hw1DaKcFgxPe/M53oIoJgUy+BbqbrhAP8uwjm
	FmkComsn3XsFrQ7dPPlu2XsLLi+w+7I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wto1kG7x0lEigIZjZ69KzWs14cA7cKiTp/PLlUYQ1SbEn6vaSZvcPqgLnvs8uwlKZqvcSYGJhRpvFX5UHgIHDnncQCsBSQjYfQjJVguZaHEdE87aDk3nE2nrAKQqqQmFO4KsePviBaZmU6V9PPCdkT40T8XYYrNkLiC98LTc7zphww9NBz4YrLfAYTa7HhQQzL8fBCq8QlxsI9VxcTUvEc/OcTzZEBxSAy0VPiXnG8LzWHLkoXoMMmax6mc88IMZTiEzYoACoz/7vrJL1B0RBw811K1HfmjUGgn5MKC874AbjePd3kq5OoOMXCK6Er0CbfeE2RY8JSZsAPkEWp1dFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OZWTKtclRrOfAi6ihxJKjALnLRbRSlyjEScPsGFqTuY=;
 b=rOp17A2cjBZEQEXbDH2sBM6PvUTJtENgAj5XN8/fkoSg6bAFrbdy5Y6OHlZiiwBMYh9GdhXLB+FPEevN0ewpRoWB7XBrtocviJ8FKT5r9QUewzAcHYkasjQpkysBZ5slVb9OMqsGbnYMOtDzj2WjxvpMekP/iX+Ci3Ru0k44y9xq3UUJWANTOB7V/4JZT+OmaSI1vlNApSXNSKaIaw3RDSSQSIILaOYmHbjVl9EnuXNmZaKgMZ1sBdIC5g1mp08ZB+Vr53zB44yzjNwAvwxmmmOTXZv0lp2ATm0cl6pWBfLEbCnLBswhE+tzTPxA3Hu2vkhoAvYfEFQTsMn1hHdC5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZWTKtclRrOfAi6ihxJKjALnLRbRSlyjEScPsGFqTuY=;
 b=Rqgyb5dtBICsv78jQL9CwbjetB2CWZIlnhEcFGW1C9li+Ru/Uy+5fcKr6zrgltXGzrsIT9vMr8bMZssBqUgNwQGhb6qwRGbNRJQQtGQJURWS00Y7bBaPCYRCivowXwIJ0y+POE3CPVtBs6JzNlSzoT+z9aUcEJnL3CaluTQeU3AkbAVrJMv1FqmGq1mHhXPUsHPuzFAEflLIqRz9Z/gSfROp3V6fJm7o7ld/RFlNgV1oj7u610vnR1FRoZkoZryJ2/ABNDr0exj258xjZxGp4OD4zM2TVCaeOwUzd/c+FqTBPTHawE3xLuapQa2olUY7dc6YqlmJLzBQA0MO6p5hbg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB6177.namprd12.prod.outlook.com (2603:10b6:930:26::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 7 Jul 2026
 02:11:13 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Tue, 7 Jul 2026
 02:11:13 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 06 Jul 2026 22:10:32 -0400
Message-Id: <DJRZ2QCEIVA6.1AZF5S891NKS4@nvidia.com>
Subject: Re: [PATCH 02/13] mm/vma: update do_mmap() to use vma_flags_t
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
 <e0ac58ad2b88ff7e2f0024e3286b2e786f79ca32.1782760670.git.ljs@kernel.org>
In-Reply-To: <e0ac58ad2b88ff7e2f0024e3286b2e786f79ca32.1782760670.git.ljs@kernel.org>
X-ClientProxiedBy: CH2PR15CA0023.namprd15.prod.outlook.com
 (2603:10b6:610:51::33) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB6177:EE_
X-MS-Office365-Filtering-Correlation-Id: a46e7ba9-5394-4512-992e-08dedbcd0520
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|7416014|18002099003|22082099003|56012099006|4143699003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	2eWtQE73CZSQ5v6QF5lztmsrSjPVumC5SvOZh5US96jgFfWckz/iaPIzlQl0IN4B9SRX7EbdnQoB2ClMvwl3QnklzfP+cGwQ0U2ns95Je2jZD/TuCMCwu5dHfriEqwM+rRiG4co9f5lLSn4hRTkZntECv2ITNa8uwsi1FGDLfLh1NgZDL34zp92+yucm7lzpv7R4c98FmxtXF4I19kqh/5gkPp0amOxupLrfWChopAaqL0WnwPeDgFuz7rp4vVYJaLVCAG/zzlIxASIecZH/ps72iemw8N49bkbCOZOtH7el24e84fYs++uhUvTUqxevuoamYcqyFaoptWPsZ9eHTMpXIXHfHbrbsTynVAdpH/zn72gFl0wtqm4h6bcRq8wDitcVQXoFoO/5ZnyrpwsLFlcQ2dNt30h0ZR6I3FuD1F7wubUbX0C2AmDmHwe8Y50zhllp/1es1GAb770bORFA+5rggFnE+F5ijvSsNz4S1fZ67ntonEVJ8R6IWT7YOBEVAzmpG0n8HWcncN/W4BU9qZgFzJSpmeUmWLfLt18PuVgrLucwmPQqb1nAf0lS76MIGhy3CYNWcJXXK9sSCzWA8+LZmqPmuiC5l8YNyjOf0m48gbj79Ur5Fsmi+Onn4al4JTWG3RoHqS4h+19gFkHjf0A6Bmz0T+OTx8atHnXM2eo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(7416014)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2tKU2lvSDV6bmNzb2V2alBFSURBSVhXcW54RHhWWklmYlFCYTVOZzdHaHpX?=
 =?utf-8?B?K1NWbjNDN1dQRW82Y0ZYUVlTc1huSTA3RnNQMmk4TTJmT1REVzdmcnBqTHo0?=
 =?utf-8?B?MTJzZk10LzdsMlNuMm9oWk5FOFBpWm10dGgxS0dMekZZbnlPUDhwWFFrUzdk?=
 =?utf-8?B?azhPMktCbDhjNDRHWHRxSk1KM003RXFPWlBNbmk5OGljL0dKTjJ3cXp0cmZZ?=
 =?utf-8?B?WlAzd3l5c2cyMXVOdTRmN0l0UUVUbzdrakxXMTV4QUtrSU5ZemdUSUM4blJ2?=
 =?utf-8?B?Z3BVTnVYSTZ5TnpBOEpqQlA3LzB6Rm55Q2FDUWFmbnNSSitpekR3MFFIazhX?=
 =?utf-8?B?NlBSa0hYaUpRWHdrYXg1Sjd2MjcyZlZ6dy9hN0wrejA5dzk5V2hjYXFIMlFz?=
 =?utf-8?B?bUt1SWYwb2VZY2o2eS9qQ3ZUSXpCWHR6SHBoYkhaOEpYNFp6R2VRdE5URGJs?=
 =?utf-8?B?dkFtR0dybjdnS0FUWjNpSWVCWmVyQ1RFVGFTRVZlYnd3MDVlZGZ0ZU9sMVNm?=
 =?utf-8?B?cGJkUmxIQmdGSDZCaTBNUkZoN0JlS3Iwc015TjhBYTlDL1dud3lEdFJsRzZC?=
 =?utf-8?B?bjRKSkwrWUtlNWdQZmRYbTBxNTlYVmdHQ3hkUWNZSGpqN2duMUVrdFRSSkNM?=
 =?utf-8?B?M2l2RVpUUlRqUzNYVzU2T1VFaGFJdmVaV1Q3OWpBVDRhSmxpbEVaa1ZrbWNw?=
 =?utf-8?B?MlhNUDJsQUh4b3BndHNFZGFmYkRUOFYvbFM3NkJJa2JrRUxCZWNjSkgvZkVr?=
 =?utf-8?B?OUp0Sit6ODlDMmEvZ1UrTm94T0VEaHEvYmRuZGtrREptTXpYbHVZZTNaTUNL?=
 =?utf-8?B?SS9IY21UWEJ5eW43SnpEamVCeGNybGZKQXcvZHBlSDJiUTZFdlZEaUtUdS9C?=
 =?utf-8?B?ak54OVRxWlBuWWNFOVpEVnlaN01iZGZ5bmtPOFRwbWtaRTFZc28rUkFQMUhp?=
 =?utf-8?B?dSthYjgweWZjaWxBSytYQUZFM1AzSnl3bDNPY2hxQXovVGVzV28vRzJ6ODhM?=
 =?utf-8?B?NmJ0a3dNeXA4UE9uRkVQZjU5Z0JqaURMa0l4OGJHS09oY3dpUm5DRkRJSkcv?=
 =?utf-8?B?SWpxME9OMUJHVnBkYXZaWVZNOE5oTnNXVlBNSlg3aUltN0FIdFNLeFNaYTd2?=
 =?utf-8?B?WjlWNGVXQnRuVkRaK3FuTXU5bVc1c2xNMFdncjk4MEdPN0RDSEhZMEErSXVn?=
 =?utf-8?B?ZktUTnZzYXJQUUZ4SWVseHpaLzhHc3UyRisxTnIrdXI5WHFtOGhwZ0QvQTA1?=
 =?utf-8?B?SEcvNk5xUjMzVzhBWWVsYjB1RHVPbUZ6R0xackxRNktncWIwY0xqcTE3aWRv?=
 =?utf-8?B?RkdmR3IwZjF6UFd4VFQ1YWJoWUYyT2FNUU4zZ0tmZWtENlVSOTFRNTZIc3N3?=
 =?utf-8?B?S0J2TzdvRS9OSWtLeVRKbG5JQ2dqV2tRVGFSYUhXYWc4c1NCVlVjbW9rRlhv?=
 =?utf-8?B?OG5FREJEZjJHc1ZyK0MzckdoQThnSERaYm0rdGlqRTYvUFo5OVAveFduWkxm?=
 =?utf-8?B?Y3RoNVl6ZVRHRjBEWG8zdEpXMDB0UmtOa1prUWpKenFMVkk1Y2N0ZXc3c0ls?=
 =?utf-8?B?VnIzdWhZWG01ZXJCQjFhdUlEMlE0WGxIWVVNREJpcUhLNHhLS2d6clltdXJX?=
 =?utf-8?B?S3RqMEpyTXFQeUJ5UUU2WEJKQnVqc0pycjdXZVRzOUk4d0pjWEt3L2NaUEpw?=
 =?utf-8?B?VGRBVjBzZU5OS1RMMG9NckdoekxOc041Y1pJWUo4Mmw2NXRNV0o2SnZXdHNX?=
 =?utf-8?B?MFNnM0pLbU1tZWZiWUFxS1AwTHNpVE9jQ0tDY0Nqd0xSWVYzQzMyQmpWNVIv?=
 =?utf-8?B?cFhsYmdZdHBIamVNcUJOVkYvc2JrUHZGZUg2QlR2K2VjMmhObjFUMHkzUkw1?=
 =?utf-8?B?cUdNYW83N1phOHpDRkhjd204a2V3bFk3cFRud2FVekdKcWFBelBSSi9lYnFR?=
 =?utf-8?B?OHNBcjVnaUljdzRlYW95a2p0dEp5ajh0d2tLVFExVWtJUDFTZkFGSWxSRWRE?=
 =?utf-8?B?dXlLWVFWYU1IWi9ucEx4bUVMZVJNdFpwbERmOXROWjZWSXVMQnQyNDV4TWZQ?=
 =?utf-8?B?ckQ0ZWY3eGlscFZSSm9lREpZTzJJNExuSnJmNHdNUmhYZGVMbS8rU3FROER0?=
 =?utf-8?B?Rkd3VHhqQW1uWGFtcmZMSjR1M2hyNHl5N0tuWEFyd1Z5NUhZaWpibHhZOXo5?=
 =?utf-8?B?SVArbHRFcnVBVFByVmEzWUZzZW9qaVE3RTIrTTVUTG9rUExlbE5jcE1GS01O?=
 =?utf-8?B?bXdvNnZSWEFlbVVET013VHVyWUFiY1NDUGRRdUtQWVR0OHpPM0ZRK2xIb20x?=
 =?utf-8?Q?JDrw2oFXXOPm0reTxK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a46e7ba9-5394-4512-992e-08dedbcd0520
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 02:11:13.5375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PkW8PLSCAM9OoBbuQEoPHlbtWH7slCizpMnfj3r3at8+bkAV7ft0tvr+nIf15jXf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6177
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 53C5A160002
X-Stat-Signature: 3axcbirrbq51zapa8rbui8q76wc8s1j7
X-HE-Tag: 1783390282-269415
X-HE-Meta: U2FsdGVkX1/m9wmViT7CHI9rnKkIYFunjJv4VSnhN3IFCF1JyiQRWjFqAHA5vXE8abF30o0j2op3JTw/wHr5fkDtRNrNU3w56ICvRmyOCAITZ8hHDACv0CvhGp4r8s8cbk6YGXO3cbqCRvMAmmVMgSRwDGReVzG+SDAHHyPLUPyDzjNHYnG6n0FSDPXGmcgdZlw4kGxK0k0WsnMVVb1ssc6XPRk4HocN2b717SgRWPXrW+cSVOvwvAY6ZMjH3SRCtB+5sRPLxOm0N6MDbu0+tEDQsDo1YEcCJQTP8JjTNs1YWb/pj4L4I6OLTqfFCDaTxI9PbONDpOSp3oEFMp4SwJWvD+0qiPgRF49pRSxGZLolWGJiGw9V5oNuYcmdv+mWKJeCV5QD4/fckeecHC57bk0z29xHCT+vcEXNmFUwU57q+f3nfCdeZE+NKq1SM//Swf0frVpYisJJuyg0/zWyBlsDAg/BeE8+FyACNPswmKHQImXEnJQoJnXHIk6EHjzFj9ec1T4ka35n0NMynw1+EXcIehFqIixabQV/1aEvtKawZZC8SIqExfK7yuZLs59DxRZOly0cpCShyCl2vhknq7pY1LQs+ZxUPA4aS3hOOOG4TlBABonansdCgiKeAPw5AWXxpUYTyhUN14w1CjejjvI2yS7/TKBxDUm09O66oU7zIfIeIta5+H6C5m/kK3ZBXD+WasnCqJEZgXf31qLWTpKUnka3z60d4D6Yd6/qthtI/Qb42NVPEl9LnEsyRvUgTZXh3MweuSxzMv+7b+ShjV4Kre9VGKWdm6lVU3XzB2E5vmOrph1gbcbvj1qLrZ9TLS+hAgvEDFwpRAy0vB/uIRbr221pJXIFklbzKk40/Bgf3fh5Bkqt3OEx5mLTHbudZVoDU9kLoSUKIpGKKzMPjhVIwE/YhMOdvyAJvN3OZd9HRqFZ5948iITLl0JYvuot3d9KzBi298gA7MSRhtp
 cd8Up0eJ
 1n9mvtwKW7XPhjKpa6d56s8X5AvuUMSbwpcfhAgp502BnZ6dlt0jhabf4zsR2+G6DMbo9UqvYaotIdgbbYyVOX9XuaafZNQZhaz0wTe2LRzxnMOaT6g0GkqsxoWOD/1tFHeqEaIioWnis/crmyLpFZB2SwFgpPuUMgMGvXNpRVuzPbMvbfDXA8F6QCPq83gcTeBWhFxafeQgp9PvP2J1v7TAtW6SV2kGSDJ3R5yPkXURTHECA9EJbifzwV0C+BCoc1/beKNMoebloxltzEL5OBnqWfn1uzgcCIJrqdrJiIGiPyktDKneXtPLUxorNhwHJ/TbuMeAoiZY1Aldc/Kon3woUHm+tPoVHiAyCHHfaToxwi7HfmbFLrvKhg6f0NahegOtyG7qeNYGrMf3pDcgw6W03w3I3TFMYqcUd/ZccTQ8MGg9RMAzgK2rKAnnhz7rqeMcSkz4MbN1XSZkI/Jy7n0K5pA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 29, 2026 at 3:25 PM EDT, Lorenzo Stoakes wrote:
> The core do_mmap() function accepts a vm_flags_t parameter which it then
> manipulates before passing to mmap_region() to do the heavy lifting of th=
e
> memory mapping.
>
> Update do_mmap() to instead accept a vma_flags_t parameter, and adjust al=
l
> the logic within do_mmap() to manipulate this instead.
>
> This is as part of the ongoing effort to convert VMA flags from a system
> word size to a bitmap type which allows us to unrestrict the number of VM=
A
> flags, as well as gain control over how VMA flag manipulation occurs.
>
> We do not cascade these changes to all functions which accept vm_flags_t,
> but rather use vma_flags_to_legacy() where necessary, specifically
> deferring converting calc_vm_prot_bits(), calc_vm_flag_bits() and
> __get_unmapped_area() to vma_flags_t.
>
> Also utilise the new vma_flags_can_grow() predicate which correctly handl=
es
> the case of architectures without upward growing stacks.
>
> As part of this change, introduce VMA_SHADOW_STACK so we can correctly
> handle the case of the shadow stack not being defined.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  arch/mips/kernel/vdso.c |  4 +--
>  fs/aio.c                |  2 +-
>  include/linux/memfd.h   |  6 ++--
>  include/linux/mm.h      |  6 ++--
>  ipc/shm.c               |  3 +-
>  mm/memfd.c              | 15 ++++-----
>  mm/mmap.c               | 67 ++++++++++++++++++++++++-----------------
>  mm/nommu.c              |  3 +-
>  mm/util.c               | 10 +++---
>  mm/vma.c                |  7 ++---
>  mm/vma.h                |  2 +-
>  11 files changed, 69 insertions(+), 56 deletions(-)
>

<snip>

> =20
> -static int check_write_seal(vm_flags_t *vm_flags_ptr)
> +static int check_write_seal(vma_flags_t *vma_flags_ptr)
>  {
> -	vm_flags_t vm_flags =3D *vm_flags_ptr;
> -	vm_flags_t mask =3D vm_flags & (VM_SHARED | VM_WRITE);
> -
>  	/* If a private mapping then writability is irrelevant. */
> -	if (!(mask & VM_SHARED))
> +	if (!vma_flags_test(vma_flags_ptr, VMA_SHARED_BIT))
>  		return 0;
> =20
>  	/*
>  	 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
>  	 * write seals are active.
>  	 */
> -	if (mask & VM_WRITE)
> +	if (vma_flags_test(vma_flags_ptr, VMA_WRITE_BIT))
>  		return -EPERM;
> =20
>  	/*
>  	 * This is a read-only mapping, disallow mprotect() from making a
>  	 * write-sealed mapping writable in future.
>  	 */
> -	*vm_flags_ptr &=3D ~VM_MAYWRITE;
> +	vma_flags_clear(vma_flags_ptr, VMA_MAYWRITE_BIT);
> =20
>  	return 0;
>  }

This function alone changed its original behavior, since vm_flags is a
snapshot of *vm_flags_ptr, but after the change this snapshot is gone.
But its only caller memfd_check_seals_mmap() gets vm_flags_ptr from the
input parameter of do_mmap(), so the overall behavior does not change.

<snip>

> +		case MAP_DROPPABLE: {
> +			vma_flags_t droppable =3D VMA_DROPPABLE;
> +
> +			if (vma_flags_empty(&droppable))
>  				return -EOPNOTSUPP;
> +			vma_flags_set_mask(&vma_flags, droppable);
> +
>  			/*
>  			 * A locked or stack area makes no sense to be droppable.
>  			 *
> @@ -515,23 +527,24 @@ unsigned long do_mmap(struct file *file, unsigned l=
ong addr,
>  			 */
>  			if (flags & (MAP_LOCKED | MAP_HUGETLB))
>  			        return -EINVAL;
> -			if (vm_flags & (VM_GROWSDOWN | VM_GROWSUP))
> +			if (vma_flags_can_grow(&vma_flags))
>  			        return -EINVAL;
> =20
> -			vm_flags |=3D VM_DROPPABLE;
> -

Lance pointed out the reordering of setting VMA_DROPPABLE and checking
of can_grow, but these flags are not overlapped and there is no parallel
writer to vma_flags. So it is still no functional change, just not
mechanical changes. :)

Otherwise, LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


