Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36E75C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 20:26:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94F796B00F1; Mon, 29 Jun 2026 16:26:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 925736B0119; Mon, 29 Jun 2026 16:26:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C4E86B00F1; Mon, 29 Jun 2026 16:26:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 423D96B010D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:26:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B30DEA029B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 20:26:38 +0000 (UTC)
X-FDA: 84934083276.30.CA95D91
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012028.outbound.protection.outlook.com [52.101.43.28])
	by imf28.hostedemail.com (Postfix) with ESMTP id 317BAC0006;
	Mon, 29 Jun 2026 20:26:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aYnFAIn2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782764795;
	b=2O2+KEE3oizrkovknh0jSGMCW5Mr/a41wkcPEGLjoeZKSrGh3+VDW7hxEeloBEWduItafI
	AuPjkba8PAarDC1BxEuRHxJZPFPeNVaHpuYrs8Zz0aXk0QY546/YiQBKVpvC7tDPKjX5pT
	uGE34hK7HMa3/EPyaPa7P6ZsWRhvPOw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782764795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UjOcawimHyWmxgix9NetNoPKlptEq1gcNWDAjaT9jQw=;
	b=saTjLfEfobX6rL/uhsN2+y9Qc+/jw0SIqALVm8WAY7eE20oNKCpxizaKVdNRKVI8e11AuE
	3I6wtbf1Ub7jwutmbhmrBOSwAnQnaSdX26UTcqQFjDK/jXJbzcXuyRUR7M4I4qR44lnCnW
	uf+19nurpn67ClRGkN18JtMr4dOrKjs=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aYnFAIn2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T/v44OCgZVv8TnwMyFEqZ59yu11oCB/L8D/YmJ45y3NQvoZQNhrxzCH34Xr4RtJnlmGEbegSVMRmMjurJ9k44Z0/gng+ZdY6mFprMUoGrSiOIiBPpTCnIzNz7C4PAKic1QMjjhB3wrZhwhZWvYn8GEMWsnjwJCqvDm0xSVemHrfuoO+LWQ3P6OJXsI6Q7WguJ8UxcHY5cf3FpmmnpBsQWjSzqxFD3CQYu4gMk9u6t6uC1DIwIwB1teUbMbQf4Q8hZmMYkUC7uOHG7VX2amk9Ekjy/AEO+CuR8vv6qVeoSSMBMi4p0J6sHcCEnLZckLWf+ZiWQ2cdDcfH3MKASIkBKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UjOcawimHyWmxgix9NetNoPKlptEq1gcNWDAjaT9jQw=;
 b=ETjNpAbP7ey+4SFFarO0HFFa58CsUMqTPhTZ6MoEu77yNuv4XlJ7z3qHfH3wTBDxqWfKmR1eryM06/wAPJhYsEGSkpOH1e+zrVfLpV7gTfVNHMv2XWr4LoMAzE6xqFlTDtjubMihZQ4daGCdHxAcmjZ6U3ZkRMFN9whuNWqz+kx2MURGE9CXq2XBL08JCwvBzMyfIav1tWO3vSUJdC/R8nHwqSB9Q7xd7DobDUmWZsd+2fGSr41wxtOt00KtskVCttuCm/WLc+ss4CRZqD1t6b/yJQkHchvV77pB42Thcv1Czd3D2i/HEOuOd39PjMIdMgZqFPxRPF0ADL7YZuJEQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjOcawimHyWmxgix9NetNoPKlptEq1gcNWDAjaT9jQw=;
 b=aYnFAIn2X9xFXp3Fs19l/6YLTYATk0NbcZ68EnMprL3spbrD7OTb6WKPkVm3IDu+1b67fgyFwo2ywI5nr0JLH8dFvemEbfWOqMDPcJ0SRokU7U960JH25I7aq/aXIytsuh+SAvoaScfzHXZqJ1KLvbE0frQpLu7XQ81i5xO9wMFQM+XhAWzbrAMV6Wgm7KvK+uQlpFVY3NFDs9c80F4Ndy5zMVpf2DBZmYM1asChhVA/SAK6YBw6g61oj8S5j4CMJkUGMor7NCUA3QJbWJy7Ea5FbzGl0z6UuXdhOeT8AVUeKTgEC6Cu0UBvlnTLPjJkJ3PePzU5itCa1iBHsubWeQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB7551.namprd12.prod.outlook.com (2603:10b6:8:10d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 20:26:20 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 20:26:20 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 29 Jun 2026 16:26:18 -0400
Message-Id: <DJLTDCPWMXDL.4ICZ77A1LPZZ@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 01/13] mm: introduce vma_flags_can_grow() and
 vma_can_grow()
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
X-Mailer: aerc 0.21.0
References: <cover.1782760670.git.ljs@kernel.org>
 <f2e8c32515d328db62279cc8bab8398ea278d74f.1782760670.git.ljs@kernel.org>
In-Reply-To: <f2e8c32515d328db62279cc8bab8398ea278d74f.1782760670.git.ljs@kernel.org>
X-ClientProxiedBy: BLAP220CA0026.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::31) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB7551:EE_
X-MS-Office365-Filtering-Correlation-Id: bcdbfcab-ac89-4e05-59d2-08ded61cadfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|56012099006|22082099003|18002099003|4143699003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	xUj0Wbi7enOgdR8SfgVuT5C73lXoevgkzScl9VL1vsj0miycsDySQxzOAN6+yVwlaeVhGLKqkIayPxmq1HCPnZhRw9vOk0gDDPPvKfEOz0ZESjcbEs2cEZs+hdnh1i6oSi+6AXAZTLt3IC4T0HDKPuXI4C5I7J7/sY1eAn9xAt7rXgSTZZtq7IPZUawDx5rf/pGGcPoP0WbHVGYEQxe/34QBIUrEPJTadYzWQ6LUdRd7P4lrz0HdM37EY6/SdwgCz4BT+XqhdE8Xk9yIbGKKoq9a1mR4/qDOHqdpxghkHsLKvAh4kMHvncz1akgnhR38twHjIjyWGz5BLMeX/aVmnb5qxlyvFDm78GZ7ImdEZeL53JW1o8KwzX4mNIZF/c3zaupiC5x4htPFwOTc43ztfGKot0S5JrSyb+dQR2v9OK2EHhkGUjCPmyGfWXm1r/2C6x6zAcOukC0FS4O0eeOKmRwDGrRxFVgXiQh+QbqyhEvF7FpPwf8Bysr1zlerwRkHyc/66RHdmHSD7dIUzmBBKD6QiONcCzV3YPuK0oklR2Fm4kKr5Sg5ELEzaT6wKluIZ5441stoCvpJiPxZec3UMiuJ9lNzczUR+PvqcWFEAE1eEnXBbjPwCJpX38bIlBAIjfH6Py1HcGoT1a14UjGCntdei7oGEa5zchpvlGderDM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(56012099006)(22082099003)(18002099003)(4143699003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2FSYUZmZVN3Q25LK0llMFRzY2EwNkZRQ1lMWjdiT3U1Q1RoU2c5NUZuNjJC?=
 =?utf-8?B?VWllTW01dWZFZ1NVVFhDQXVXT0ZZdXBNLytTc3RySWlibWREOGJsYkNNKzMx?=
 =?utf-8?B?MC9DekxkRnAybzNZVVhlZldFYWlhRW1JYnpSWFRHR1NsOGh5T2tqNmY1MStZ?=
 =?utf-8?B?ZHptdS81RGorTFB0dldWZkNvSlRYTEtPay94UkZTVnF6eFNOZjJRUVB1WHVX?=
 =?utf-8?B?clNneWFrVlNiTU1zRXBBOEVHSGpGVkdUM2hoNElUcElOVUdlQ0wvbHZjNXRH?=
 =?utf-8?B?TlRGenUxUHAvUENnMUIxc3pucGVpMHJWODBwVjcxRmRER3BYVnBSdGljSjlu?=
 =?utf-8?B?MXN5SUJrVjNvVGxzYkMxRlFlbU00QTRURnJNUmJCK1pWVmxla2d3RHpWaFpz?=
 =?utf-8?B?SHgvcnFtZUdTK2hMMFRDR0lJRFEvYnRFSnBReTF4SXBFZ1lwMUJyOU1xVzd2?=
 =?utf-8?B?ZWJBMmwwUC9KRFZQRkJwaFV1RHJlTG1iOC83TWRZRlcrRUxjSVk1RHdTZ2h1?=
 =?utf-8?B?bGUvS1RFcUdLaC95YW5PenVLOXFPUVM2MThSMUkvQWx2MEprZHNHTS9tNmRF?=
 =?utf-8?B?RElqcFZlUGpudlJNVUZPZHBXNWdzNGEremdlWkJzZG5YbjVrTWJ4Tld4bHlK?=
 =?utf-8?B?eVF5aEswK2poLzFUVmtmQ0JtNG5vbzBNZTNtYjRaVWIxcmxrMjVHTEorUzZY?=
 =?utf-8?B?Q3Y2aThOTzIxdTVrbGVwZ044L1Z1NkNaNXgrSXUvbFBDak4yYXhOT3RTTXFN?=
 =?utf-8?B?SnpkS3EyTkk1TC8yOFBTNVlBMkVsZ21YZzlObDcrS1ZPSG1KYVNnZDVCYWV6?=
 =?utf-8?B?cnByMVVwWVU5MExBTEpFcGxmRGlWOHowYS81QU1IaElqL0hZZU9zclZxR0VV?=
 =?utf-8?B?UWNyWTFnLzFRbCswSWVnNzNDL08yQS8rZU4yVnZMQm9pVDQrdzEvZEttQUp0?=
 =?utf-8?B?b0VvQm5vUHUwTzJTVDU4dHFaY1Jkc1RBakNxK3VZdVZzd2hVTnZ5Um9XWDIv?=
 =?utf-8?B?cFc0d0F4dzM2c3NaMEZRajBRTkF4MW9wQ1gzbTVnNm1aSlNaVE5YS295dUxH?=
 =?utf-8?B?NzRnMjA5MXRCcVBIVURVd0VqWHkvaVg3dUtwR0Evc0Y5RUUvWjEzS3hzTWNj?=
 =?utf-8?B?Qm9DSXRqTzh1QzdkQ2s3OW1wNlRTZUx0cUFpUkhoc1FpOEpCZS9RdkRvaTk3?=
 =?utf-8?B?aTd4THNCZUlpY2VBU2c1SGVzYzBvd2R0dForRWZzUnMyMzdYUkljTHU1aktK?=
 =?utf-8?B?OXBKTmV2NUNpeGZjaTc5ODhLM2JMaEJaM054UUF6RTdHTndTbDY2RHZxRy9i?=
 =?utf-8?B?M1NiNGRZQUZOWnVJYXRtcW96STVNbHhScndhZmtLVWlud0FCdnRBMjhENTRN?=
 =?utf-8?B?cmpsb25CS2JaNU9WY2pPNDdPNXJmaTVOVlIrWGJxcmgzMERuRDZzdmhRZGRU?=
 =?utf-8?B?UVN2RlRqSzhVN1BLMTM3R3JDWGpOWWVBUFRFNGV6dDRuZCtoSjM0K0s5UG9W?=
 =?utf-8?B?Z2FybXh3enRDcUxPUGNHWjYvMVdiaHpVQlFyenRReFprVXhhQWNsZU81OFd0?=
 =?utf-8?B?OW5XRXlEZ20wYlBLWlZsYmFobDBJVXNSeExVMmM5eTgwTGcyQ20zZ0lWcWJ4?=
 =?utf-8?B?V0d1OG1STXJ6T2U5eThmS1AxTElCK2lZK2lCcWZ3OFJpZmtldndsTDFPRVMz?=
 =?utf-8?B?TVk4STNTU0V5MDFMV0xhOFRTbkxhQWJXdFpEYWxtZTdyWVUyK0FpQkpXYnhN?=
 =?utf-8?B?SXgvMi8zUEtYRTFNWmdTMU90cUVTNGhrZjBZcGNlYVBHSytsOVlJcndSdjU0?=
 =?utf-8?B?YXFrU1ZZakRMeGJUVGdvekhQeFl0ZVNINGFkTjZRbSt1bUorTzI3cDgvaFNP?=
 =?utf-8?B?QmJuakREYjN5bllIMVIzeWd0ZCtza2NwS0lESzNNZkdhamJYRXhMNzRaVGNh?=
 =?utf-8?B?c25kMko0VlRqTXdJT1JCOHBOK1N5ejV4bm54MkQvRW5YcHRnMVpPOWtSaHpL?=
 =?utf-8?B?QldRbGZxZHUwRGlNaUF5MnNvaXFNeWlhV29aRUcyQWRKZG8wVXRjbHR6anZu?=
 =?utf-8?B?c04wV3Y4RHBTU3M5QkFVVXRYVlllZG40eEZlVWJ4UmtSdEs4eDhsMEx0d2ky?=
 =?utf-8?B?NmdKTzVUWlduS0VDODcvakRvaURQMllyQys3OFl6Q04wVmR0VWxMdzNJSnEw?=
 =?utf-8?B?K2xXQ0k1SnV3Z2NaaUFIbk1PUGI2ZTkrOFV6NVBaNURNMnJRNUIyTDZoaXF3?=
 =?utf-8?B?aytMQ0tLdENFU1Y2ZUZ4OUw4TTlGcFJFR25MaFhTWkNsME03SFIrYzFKcVph?=
 =?utf-8?Q?+t2YN/oXnRlwZEOT5Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcdbfcab-ac89-4e05-59d2-08ded61cadfd
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 20:26:20.1258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZeOF9AEynETVEVXKwzskEDGmMEHuAC1VcI7guFM1cBS66AuhSMQ4skmiFHWDXKMV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7551
X-Stat-Signature: pezwk7xfgy355g91wogjixky4oiq1o9z
X-Rspamd-Queue-Id: 317BAC0006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782764795-868961
X-HE-Meta: U2FsdGVkX1+RNTO4xj2wrzd4cgZz4fS4KrarBtFEwapHb8yo9maz0MPDfnvz6xNRW2y1ogwcw5eMRLlI1aBjDAbr+J57z1lwO7aooRtNpmhMkz8ZTQEFas2a0qfcbE4ep3/1uYRYcG+o+M+fgA3UQo0sNaSRE97CbPB1nU5r1bbpOTDxlS7yXC++jtcB8TDrjX4A2RuwsQjcjehEgd50bBbmoWx24a/iy4yx7Sb4cz9baqe3bwHiNiTMF1kMAR+YOjAPL8p2wKBLZHEO3nG1X4gDBjtJiM4zNRdu9vU0WvO5h1eJYkSV8GDvHJjGJBbOe0hRKdQEn43UEarUuvrK6X7yG2Ijxs48LmxgvmhAlW4+epyKiKPirobGMzHCTwUh68Xuf8K/28MPhhXXIQ/DnKDQJtz84VENOw3Jn/rDpjfK4+ri2FpAWwjv9awe/pLHfO+T+gOqXMfVctsGv6r5c4RYhN/dRY+RWwlae9c2mOUoYrcL0XaHBoDhdbBlzuLg9Tu/DLyHaBNxYX2O2TziiLivtEUgdvhUafjpwTtIzEZcLzLB0pz2mk4xnRUB4DqDpCWKw1cmkmbDrZXb6acUDODafH16U+IIkfErageqdlJxPIa0qNQb/X1Vl/4OJvTtoASj1nazYYMhXKzsgrV33KMwvYD3ysw5FCZpMt7/VTKEWP90kZmRTIaoKTpFTfrIljtqA8UF/ywLvF+wR/vg9snaP1dy6dsQ2wv9SCdWeNHc1hBWWb6V3IAB/RGYCLByEYDayu0i8fQEiBOmNm0/dyXf4QZQYvlDZLIqfJbboIUwLhUVcPya3C4EB9K2BZg5CVDIw7qqPNY9gj69OHy+mGDkWp+F9wkLqRRQazDJhMUsEPhprtjs9NdwRxcgEOzzsXqr2SXF56ISEFM6Vl8QB+qZK5c5tox70AjUbvvk8RQ1VG0RuOdlE2DyJTLJXapFdofviTeVby4sTi1wBuH
 TLxEJt5r
 nTv8Di4EJnxwIagQXPm9cAJkJRhwrwYmuCKIRwrdk1jVxvU7ff+A0e3gGoBBB2INIXnk3SRA2prAtZLLKP1XUeaNv79jnRKt9M5A7k9O43e0LWF09RbZ5+aCnCVGqq9U81QhcAkiDfOl1KvfBWdUaDfvjO86y8R5RcLgwQrIGGi2u9qaPiPJpwqh2KE0izptmxE4iUaRv8q2qIa0RQBuImQbHIr2NbJIGqhCFh33IxNWyiAcGY6Rqhgd0zDeieHHq4PfE5x0jsESk0Dg/fjjAXg0x/Vs6nLrANmsUUuS10qlI0wkKLUimBjs/Ous9Xie7PtR01vlSlSU2fSAf6ks5UgNpRONdlTPfJG14id7ktUSeE5PbCSyku9mdlIDziKkdyEmXYOep1bTeBYd1/g0S4TO/++aFpvdvUhvENurXJW8XR0dn0cVp7ZiKHA5HDhooOoL2m7pHdw9yxQO5neSlvWWOY2PRd2L53NAa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 29, 2026 at 3:25 PM EDT, Lorenzo Stoakes wrote:
> These test whether the VMA has stack sematics, i.e. is able to grow upwar=
ds
> or downwards depending on the architecture.
>
> In order to account for arches which do not support upward-growing stacks=
,
> introduce VMA_GROWSUP whose definition depends on the architecture
> supporting it, and use vma_flags_test_single_mask() in vma_flags_can_grow=
()
> to account for this.
>
> Update the VMA userland tests to reflect the changes
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  include/linux/mm.h              | 21 ++++++++++++++++++---
>  tools/testing/vma/include/dup.h |  4 ++++
>  2 files changed, 22 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 868b2334bff3..cf7df1569052 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -472,6 +472,7 @@ enum {
>  #define VM_SAO		INIT_VM_FLAG(SAO)
>  #elif defined(CONFIG_PARISC)
>  #define VM_GROWSUP	INIT_VM_FLAG(GROWSUP)
> +#define VMA_GROWSUP	mk_vma_flags(VMA_GROWSUP_BIT)
>  #elif defined(CONFIG_SPARC64)
>  #define VM_SPARC_ADI	INIT_VM_FLAG(SPARC_ADI)
>  #define VM_ARCH_CLEAR	INIT_VM_FLAG(ARCH_CLEAR)
> @@ -483,6 +484,7 @@ enum {
>  #endif
>  #ifndef VM_GROWSUP
>  #define VM_GROWSUP	VM_NONE
> +#define VMA_GROWSUP	EMPTY_VMA_FLAGS
>  #endif
>  #ifdef CONFIG_ARM64_MTE
>  #define VM_MTE		INIT_VM_FLAG(MTE)
> @@ -1563,11 +1565,24 @@ static inline bool vma_is_initial_stack(const str=
uct vm_area_struct *vma)
>  		vma->vm_end >=3D vma->vm_mm->start_stack;
>  }
> =20
> -static inline bool vma_is_temporary_stack(const struct vm_area_struct *v=
ma)
> +static inline bool vma_flags_can_grow(const vma_flags_t *flags)
>  {
> -	int maybe_stack =3D vma->vm_flags & (VM_GROWSDOWN | VM_GROWSUP);
> +	if (vma_flags_test_single_mask(flags, VMA_GROWSUP))
> +		return true;
> +	if (vma_flags_test(flags, VMA_GROWSDOWN_BIT))
> +		return true;
> +
> +	return false;
> +}
> =20
> -	if (!maybe_stack)
> +static inline bool vma_can_grow(const struct vm_area_struct *vma)
> +{
> +	return vma_flags_can_grow(&vma->flags);

Would it save vma_flags_can_grow() if we do below?

return vma_test(vma, VMA_GROWSDOWN_BIT) || vma_test_single_mask(vma, VMA_GR=
OWSUP);

I find these two functions when I am reading mm.h.

> +}
> +
> +static inline bool vma_is_temporary_stack(const struct vm_area_struct *v=
ma)
> +{
> +	if (!vma_can_grow(vma))
>  		return false;
> =20
>  	if ((vma->vm_flags & VM_STACK_INCOMPLETE_SETUP) =3D=3D
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index 5d7d0afd7765..6f5bcd7fbcd8 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -245,8 +245,10 @@ enum {
>  #define VM_STACK	INIT_VM_FLAG(STACK)
>  #ifdef CONFIG_STACK_GROWS_UP
>  #define VM_STACK_EARLY	INIT_VM_FLAG(STACK_EARLY)
> +#define VMA_STACK_EARLY mk_vma_flags(VMA_STACK_EARLY_BIT)
>  #else
>  #define VM_STACK_EARLY	VM_NONE
> +#define VMA_STACK_EARLY EMPTY_VMA_FLAGS
>  #endif
>  #ifdef CONFIG_ARCH_HAS_PKEYS
>  #define VM_PKEY_SHIFT ((__force int)VMA_HIGH_ARCH_0_BIT)
> @@ -315,6 +317,8 @@ enum {
> =20
>  /* Bits set in the VMA until the stack is in its final location */
>  #define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM_STACK=
_EARLY)
> +#define VMA_STACK_INCOMPLETE_SETUP append_vma_flags(		\
> +	VMA_STACK_EARLY, VMA_RAND_READ_BIT, VMA_SEQ_READ_BIT)
> =20
>  #define TASK_EXEC_BIT ((current->personality & READ_IMPLIES_EXEC) ? \
>  		       VM_EXEC_BIT : VM_READ_BIT)

Why are VMA_STACK_EARLY and VMA_STACK_INCOMPLETE_SETUP added here but
not in mm.h?


--=20
Best Regards,
Yan, Zi


