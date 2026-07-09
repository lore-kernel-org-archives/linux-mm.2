Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21328C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 02:16:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7A9C6B0092; Wed,  8 Jul 2026 22:16:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C516A6B0093; Wed,  8 Jul 2026 22:16:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1B1E6B0095; Wed,  8 Jul 2026 22:16:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80F456B0092
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:16:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B6F3168E98
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:16:35 +0000 (UTC)
X-FDA: 84967624350.08.D4F84F0
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011001.outbound.protection.outlook.com [52.101.62.1])
	by imf27.hostedemail.com (Postfix) with ESMTP id AC37C40006;
	Thu,  9 Jul 2026 02:16:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bHZcwpI+;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783563392;
	b=47xyE5nluNdVivPlRmD1bCN72TCFGY6P8od7UFZRV2FI+vdGzwiIOo0DMxKkbW4uxeT7x/
	+2uljCRl2A8NhRMrIV2FxnPV2WVXuA1o3kU857iH2GlP+T0h6vFxdwt4GE23ljuWMictm4
	Ng2ovt2uxUzv4pHOVEchqCxSp7RLwZQ=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bHZcwpI+;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783563392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S5i5qm0dl3MCZSJwPGMqY2iZ6ROLBDxLPpqAztLM+CY=;
	b=OIvfnSZAhqlvyUiqT5s73kdVV8kqZGMhUilSbkP6NMfqCTCsUQ17lk2Y+q4mPsFk0U5SEM
	Bkt4QxRzrYF5KosrunRFcuU0Zuh/WJk6iBHt7fWspVle6Ojp6pVgrWXPfG5uqoDZQWwzyo
	cPH87jfzyXdyuzc4fyvZ01GXDE8eYTc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eyOSMQU34qH0irxWvkoLCDtGZ1UCOv2FP3TIdkjUL6cIIZtMLmFfcEWXWEVVl5pDhuoMLWReyRQ34KJ289gUJboS65RfFwpQFbDONEK7Qrvo3aG2QxPPEgNf0SN92NddEMkSaL1H8myAs97QQUySCLlGcmy9JaesSCv1XG9BpxgJTHOY+UuQtQxj4lg6wrSnNTR7Ekj+nuoge+zx9UPaWKWeSUfYAlDNcMlU2zF/N3yhXbzFgoESWAge8YoqPnHo7ZDXucGz+AscVZLszduKu+wJVqOOh5HpggvyuZXXdbcGpRuxW8q+X0ezM4Snx9DlznIc+AjrJuxlmuZL5AQTzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S5i5qm0dl3MCZSJwPGMqY2iZ6ROLBDxLPpqAztLM+CY=;
 b=bCHPR/RV8Gj9GMyEp5oUg7KmQ6qWmkgAwwa3lEJItGaV9dlvmY0OMoRpRX5gO2vvSaOmvaQUYnowRrecLHt+ZpKMbaXyowcecIjejbrF3kHp10exaqHBKvvvoiUgCxYzgJ2pb5gT3I6/z0Qojgwp1bkCk5qVTqsmMbzsqDomYMbefSEhKN5K+3lFWwN3zs6gWhPMJ6ZjwqHgO1zcQwujOI7ADbqypKLqe40y31UQSxp52YsHxQDrRzhRw8AuZeBWfPOiYUhlE/3PNqJ4qclHJ9tBe2DXnOJiKsiuVZZ0AmvjmgiGgaGCMM9egI6Cd5jJDiwyVuJweVs0M/4w1v1Ppw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5i5qm0dl3MCZSJwPGMqY2iZ6ROLBDxLPpqAztLM+CY=;
 b=bHZcwpI+S11ZA79kzFiR6KGkaKIsT9myHkoayB68XrDPMByjx6QnyFUnvtfYGw/WgWy+dJ1OO5pLHDCD2nTo6Bxt/TMGvqLintLXWoDmOgQdRIhefaRUvEpCjL8O/TTSfKz4sV2H9AfMeNr97oteFBgQlM/6zqD3QOEhMskwqx4jprhi9Hf9Z2M81SRZnZ+6CDLxMnzxPHcvaaPIMce+a/3aT7FGv02bonp5re6kXvpUAs86v/oidBI27IBLU/8b2RfFe64yRz13IqXQkh4GU4en4WCM39YM17NaFvdLSyioEeeD2CV0KVullxNRdHEX8juZLvRxXtc2U4KJZJESLQ==
Received: from DS7PR12MB8371.namprd12.prod.outlook.com (2603:10b6:8:e9::18) by
 DS3PR12MB999242.namprd12.prod.outlook.com (2603:10b6:8:38d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Thu, 9 Jul 2026
 02:16:21 +0000
Received: from DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a]) by DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a%3]) with mapi id 15.21.0181.009; Thu, 9 Jul 2026
 02:16:20 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 08 Jul 2026 22:16:15 -0400
Message-Id: <DJTOG7IBZKEE.87TLWNXOCHR8@nvidia.com>
Subject: Re: [PATCH 12/13] mm/mprotect: convert mprotect code to use
 vma_flags_t
Cc: <akpm@linux-foundation.org>, <tsbogend@alpha.franken.de>,
 <maddy@linux.ibm.com>, <mpe@ellerman.id.au>,
 <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
 <tzimmermann@suse.de>, <airlied@gmail.com>, <simona@ffwll.ch>,
 <l.stach@pengutronix.de>, <inki.dae@samsung.com>, <sw0312.kim@samsung.com>,
 <kyungmin.park@samsung.com>, <krzk@kernel.org>, <peter.griffin@linaro.org>,
 <jani.nikula@linux.intel.com>, <joonas.lahtinen@linux.intel.com>,
 <rodrigo.vivi@intel.com>, <tursulin@ursulin.net>,
 <robin.clark@oss.qualcomm.com>, <lumag@kernel.org>, <lyude@redhat.com>,
 <dakr@kernel.org>, <tomi.valkeinen@ideasonboard.com>, <hjc@rock-chips.com>,
 <heiko@sntech.de>, <andy.yan@rock-chips.com>, <thierry.reding@kernel.org>,
 <mperttunen@nvidia.com>, <jonathanh@nvidia.com>, <kraxel@redhat.com>,
 <dmitry.osipenko@collabora.com>, <zack.rusin@broadcom.com>,
 <matthew.brost@intel.com>, <thomas.hellstrom@linux.intel.com>,
 <oleksandr_andrushchenko@epam.com>, <deller@gmx.de>, <bcrl@kvack.org>,
 <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <muchun.song@linux.dev>,
 <osalvador@suse.de>, <david@kernel.org>, <baolin.wang@linux.alibaba.com>,
 <liam@infradead.org>, <npache@redhat.com>, <ryan.roberts@arm.com>,
 <dev.jain@arm.com>, <baohua@kernel.org>, <hughd@google.com>,
 <vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <jannh@google.com>, <pfalcato@suse.de>,
 <kees@kernel.org>, <perex@perex.cz>, <tiwai@suse.com>,
 <linux-mips@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linuxppc-dev@lists.ozlabs.org>, <dri-devel@lists.freedesktop.org>,
 <etnaviv@lists.freedesktop.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-samsung-soc@vger.kernel.org>, <intel-gfx@lists.freedesktop.org>,
 <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>,
 <nouveau@lists.freedesktop.org>, <linux-rockchip@lists.infradead.org>,
 <linux-tegra@vger.kernel.org>, <virtualization@lists.linux.dev>,
 <intel-xe@lists.freedesktop.org>, <xen-devel@lists.xenproject.org>,
 <linux-fbdev@vger.kernel.org>, <linux-aio@kvack.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-sound@vger.kernel.org>
To: "Lorenzo Stoakes" <ljs@kernel.org>, "Lance Yang" <lance.yang@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <7ef626d8a12dc742cfc09d080be5dc09850e873a.1782760670.git.ljs@kernel.org> <20260701160917.91435-1-lance.yang@linux.dev> <akaIfhfbTCAdJm3H@lucifer>
In-Reply-To: <akaIfhfbTCAdJm3H@lucifer>
X-ClientProxiedBy: BN9PR03CA0752.namprd03.prod.outlook.com
 (2603:10b6:408:13a::7) To DS7PR12MB8371.namprd12.prod.outlook.com
 (2603:10b6:8:e9::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB8371:EE_|DS3PR12MB999242:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e8ab397-c07f-4023-39b8-08dedd601114
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|7416014|6133799003|18002099003|22082099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	uLHBbUaaBCio1ECS4YGmLrkocaWbvY5KMdUTJuW+iZD+ln0gcG2SL4i83FiYZObHQSD+WaX2bMzf6wX4TJuG7XeyC+ir6a0tIfy5As3gt613qbccdPXzF6hm9uqDD66zHs3/g1JsMYbZJpZOmk4i0uW1JgvlJ/NZw+ZRTk6u8gFzM3PSv0ek6RB2GQp3JnaRzN/z6s/lnmZnjESGE85LitccMeCSQPuPu85KN6w0CCyd0BwV4NogNxdlVXF7+9wZZCJGUvlJj6E9xSYxOeanOA9YCxDmKXnGkyLXCIO4wmBRUYm1C1QgOqHC3zv0LtnMWRuGtNkY8RXJzdZsOlZ19c7yLmmjd9zSAZHmj0UBOtLmkIYCpL7A4RVRyr/eg/9hMZUzuDTrZFROsQC77xul60Vt0FGMoiYt+woGcPFt2w+SZvW340KkNFE/JscKGfTgu5dCEErHoQLROdyFIql+JdjNqJyHOEPufGGVaeWm38nEhtD2Pqfng1ltXYVuEenwDiKCMGCjnHIpVzBvPM4X3Vxqyu6ruxe7io1c3izyYc4bzwny2Q8ZrLTCrOelubkCmRsqrjvzIa1vEmxvfVhg69fF9sxCpbbFJ/MOuLter66YJYEKbrgLdXruRujkrOPdkE6GmKdq9IwLYVVYuTwwK7N5NQR7ZdWob5icuN6/T5Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB8371.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(7416014)(6133799003)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NkZpV3dyVnhsamsxbkV0UHhoMndkRGhwdTFUbk1saVpJbmc4d0FwaVZPSGlU?=
 =?utf-8?B?VWZvcm5FK1h3dlAyNlNYUFhNdWhVSjE3WVpHUWw1TnFkSWVlVDI4eU5McHVu?=
 =?utf-8?B?dW5wR2t6dEQyNVZacTM1aW92VWNXdHFrdExDc1hSNE53YUJmMTVqQUJJdG56?=
 =?utf-8?B?UnVFZ1A1YmsrOVU0Y2JzbWswUnd1UHgzZnE5THE0V2haUElhYjBnWHQyNDZT?=
 =?utf-8?B?aXZ4Ukp1cXlVTEkwRWZ6T29Bd0lxMUUreXBFZnJjbFVseWp1a003Tk8vbWRU?=
 =?utf-8?B?L0UzK2ZNWjZiQlVad2ZDRmw2MEFSc0hOejMzMjNRWUxoam9QS1J2OWgyYXJt?=
 =?utf-8?B?NTUyUDRKNlVXWXZESnpQZDRWYTFJM1RFZ05DOXJ0a0JFKzUyQ25qWTAxQno1?=
 =?utf-8?B?T2V0MDZ5TUE4dFJQdXBYNmQwY09lVlM2MkhiMDZnRGh0TkN3YSswRjRJMnll?=
 =?utf-8?B?VzRyaG5YaFhQUm9QemFTODVaSXgyMzBzUFA3Q2l6Z2VUQzZPc2cvd3VXMmZH?=
 =?utf-8?B?SkVYMEJkTVBYR054QTdjVWZmVVJObVZUbmVaR1VqMFpyMUxqd2s1TW83MU5s?=
 =?utf-8?B?YXJ6aTYyV1J3QmpLNnFBMVhLNGpiS1h1eW5za0pUZ0pabVVac21pL3VKdjVl?=
 =?utf-8?B?YmRGaFBTc2J6Y3VjbTl6RlpvZHcxbE9lUnFpSC9uc0pVTFNKZFdkN1ZQcUd1?=
 =?utf-8?B?M1BjK2ZnNURIRVMzWFNONDFicWRudy9PSWVra3BXM3I2OEhpazA1enUxbVRk?=
 =?utf-8?B?dW5DNE1LUjMrcE1tTVh6dHN5bngzTU5FSHF2ZE9FTytWN1hPTEpvTWt3WVBN?=
 =?utf-8?B?WGtyV1BFK25qUTVWM281S21aNVIvaGMrdXVIcUhlcWhUSm9oYmJYOS83bDlX?=
 =?utf-8?B?NHhSSzdQdjh3VE5rNGhWajBFczg3bnFkTDBhU0tWTUQ3R3ZTMWFNb0VZN0R4?=
 =?utf-8?B?OUgra1c4Uys3aytWQXZ2T3dFako1WjJUTmV6TlhMMERWeGtidHBWSW5ZWDFQ?=
 =?utf-8?B?NnlKL0tzUW9ET1dJRGc5bDdDWmQvdDdxaDJtZXFuVzR3VVNwK2VEdmhnMTFZ?=
 =?utf-8?B?OGtGbFdkSitIMUZxQlBCTFhBWnRPeG5sMG5DcFZWdG9ISEhSWTJxRjU5M0tk?=
 =?utf-8?B?OGN6cUV5cVJ2QWJCYXBuMW1ocTlxMDNYcnloUC85RXJZMkFraGwxMCtBTy93?=
 =?utf-8?B?bGpVYWJndGIyYkQ0QWZodjgvc3A0RC9pNzM1MzBac0p2NHVFTS90SUtOSGJ3?=
 =?utf-8?B?VDNlYWVkTHMvL0JTZXJOU2I5ZDRqTVJWUFQvTXlscjEzak1ZRFBUbHJkdS82?=
 =?utf-8?B?amNqRkhxZGhvTzA3TzVZbityRWVvTTNhQWREdzgzQ1pJcVozNWR3VkVsa3l2?=
 =?utf-8?B?Zi9abWlXUjIxUWNReTFqRzJFbmJ1S0IweHpvUXBIQlREWEY5RnlWeDZTNExU?=
 =?utf-8?B?QUhBSWwxcjFoR3JRcTR3WUE4dm1ZaXRITk00VVV1Nm15aUVFdWR3eWw5eVFC?=
 =?utf-8?B?SEZOdm1KZjNFeW5kTG90VUNpWU5oR0xhK09Dd3pSMzV4K3VUd3g0OThYeWo3?=
 =?utf-8?B?Nm8wYTBJdzVsYVNnendQNUFBUHdHNmtaQ1pQVytiNHhTYVBaZis5SFhtVlRz?=
 =?utf-8?B?cTFxQit0VFZFOW4wYXZ0cWw2TXFFV1pLVGZIenpQSnpPc1FwZEFKUWt5VlRY?=
 =?utf-8?B?cndDOVZEajUvYUkwVXZDdlQvbm14dW14dVlGWTVNdzlMejhXZHMzNGoxRzJx?=
 =?utf-8?B?TmV5S2xoYm1vRllTZWFmc3N6NHAxOWtZUGppZlpQSXNTaG5KazdVOXdHRFpR?=
 =?utf-8?B?QnFKWitvTkQ1REpJU2Z0MytyM1Nab3NWaWNITWdGT1pSaFBlMUhLWDNEdXQ2?=
 =?utf-8?B?R081Z2txc1k3VlRvQkovVGgrL1FNYzZ2OFlFQVpCVDlVYWoyVlZHb1VxUUJ2?=
 =?utf-8?B?K3RUL05FVi8vQ2NTcTU1K3E3Si93bWZMWmtjTnAzNnVva0RlQ1ZkbWx2bVFy?=
 =?utf-8?B?V1RQOEFDZUh3bzZicHNRV0VVREl1NllCVEVZbmtyWWVkZThrM0xYY3F4V0d5?=
 =?utf-8?B?SEVSTnBCTHhMS2E4MW5yUlA2bW4rTjNldWprOGxRVkZleDdXQWlxTFRQZTcr?=
 =?utf-8?B?MCtXakh2dVNhWUhzOEFYR2xSaUhxSFJNNWVTajRLaVF6d2pyMFJxQTNJMnZ0?=
 =?utf-8?B?ZmJrMXh2L0d1akIwOEd4ek1qUlVHaTlTbWJUdHRHRW1SL1ZFOGdUeDZHdExC?=
 =?utf-8?B?c0x3R1FUcjNUVTZxTG1ubUlrcENtSHdvOFUycWNHdUtTVG1aZmdZSlcrSzhX?=
 =?utf-8?Q?2q6tPecz5MPiwDuOas?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e8ab397-c07f-4023-39b8-08dedd601114
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB8371.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 02:16:20.8381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tHgqFQVrabgr4tGpUQdTwGC4hTzqDSs3VNvEPC+iKs+7SVolHHj+RkZB5IyLfnTx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR12MB999242
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC37C40006
X-Stat-Signature: psep78rwe7q3bew6tn4f4jxdeizy4f8i
X-HE-Tag: 1783563391-374504
X-HE-Meta: U2FsdGVkX19FCcZMDUfc/Ga2fJLT10u+gH6WPcs+5GLIwdTTJLbT7MNM7UZ6J0c6yW3wa6sAWmfuy0L2SDmMJpckpw1fFmMgHFi5/qCR7pWqi/NeAhG5dlB37IJjsaPaXDAk58l3rdK8/pz+Yf/Ju65XCWIM4evhJ97juXTzznX/x8IfzUgeIMO50PiOUywxC+uQxdkBoyvF9tauIveOxFZaQTiv3sAoXeeA8ixnQk66UNO5g73z7FJ0tXj39N8vLyzJvAnH02kBdCk6CgTW1EJrDkwYyxy6o8dhbCeXkgPB96z1tGmG+v4tFTwRhiJ9qCCsgbfoF5Qlkw6GyyybcbsVcXlYdLwqJYpcOqJFFx7ItUS7A5hlZyhYbjvnrcS3wOqY6FSfCUcblk7Ho3tRM21wuZv148+Guv681xrizo/0m70yLnbeK/3m8RF2fX3D9MtjvvnKHihYxjpYKXvFx46dYGruHACMmp0X7N1KpFkM66dzl08bV+F6yUWftt+3d+SU+Fo4HXYWVD2kp4pV6+g7sgGHuitTw+unLuIc1/Sgh6dV/cTVoJNshOUms9RH2DViQPirFOGtWGKfrape9jKTK3GyaSeeuOfNEJLV3MmrqEuuwfmUqCLDmSdqC9SKYk67LqvjsZA2TjblM8u/VIfdOAtghF/Y+FLSqrQfLEqQ4IhfHkNlR/HChAZKtIwOOSDrgBqK/v15H3voRkoQjFY7KwZ/953GBuYE5WYesMtdFSOrCvvcftknJpG9bPgAMYgdtToFi8P4ACJu9LUsRXopgHh9BloBc2o1kEAvCvCzFmRCQGFfFwnmYJyjRhvO87neIMkVhwPrrVW2U0zS+KtkF4wjwyWI7UBP6I9oN9ktfGGJtQ1hPOnWlfhRoeFusRgzFVh4QawhtfJ90TeIrWlEDI23OSGXHFT3kuVOKSTAqAqv8kdCGjfqcS4EB+jb4jM2bt/IfRkoEkHFpq+
 sNfvAB4k
 YS7A1SghDq6d1+rc5YO4nI6NcxatrA5KLzM3AobSTahsI/aHXaRGSpZx4pp5xQ5XplxQdqnNeqVsXwO92rS3xb9wr11pO5MaVc/98oGFMDO2zNyrxmveDzHaKnXfc3xuxA4hSo0oaxu482Z8PCVThqZOBmRVkMCUfjJMPN8NAqfSpW1okbHVZDl9H6kZ2vcXpt2YTl8bQBym52wgCBb+ajpHskuKDh6YQBbvc//dWtLYJQExjq3NFfWtvSBhp8IL3a9+T3oaLh1GU80HJLhq53IX4SszEtcmaMS0LJLdAk2j4Nx8SKW/WLA33XRA6wALtP0XwAPO2IkBwZ5XTP15toNaO4ABoW8Pz2oNuLi8PQa9dJkxEJFxcoyyT1P/XxA5MabDeFR7Xqb5BagC9zHgTXu7p8bFZfEuOz0ar6QnML+BIfAHkwyawToRrxlSRebJKgS/M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jul 2, 2026 at 11:53 AM EDT, Lorenzo Stoakes wrote:
> On Thu, Jul 02, 2026 at 12:09:17AM +0800, Lance Yang wrote:
>>
>> On Mon, Jun 29, 2026 at 08:25:35PM +0100, Lorenzo Stoakes wrote:
>> >Replace use of the legacy vm_flags_t flags with vma_flags_t values
>> >throughout the mprotect logic.
>> >
>> >Note that we retain the legacy vm_flags_t bit shifting code in
>> >do_mprotect_key(), deferring a vma_flags_t approach to this for the tim=
e
>> >being.
>> >
>> >Additionally update comments to reflect the changes to be consistent.
>> >
>> >No functional change intended.
>> >
>> >Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>> >---
>> > mm/mprotect.c | 16 ++++++++--------
>> > 1 file changed, 8 insertions(+), 8 deletions(-)
>> >
>> >diff --git a/mm/mprotect.c b/mm/mprotect.c
>> >index 9cbf932b028c..c9504b2a2525 100644
>> >--- a/mm/mprotect.c
>> >+++ b/mm/mprotect.c
>> >@@ -40,7 +40,7 @@
>> >
>> > static bool maybe_change_pte_writable(struct vm_area_struct *vma, pte_=
t pte)
>> > {
>> >-	if (WARN_ON_ONCE(!(vma->vm_flags & VM_WRITE)))
>> >+	if (WARN_ON_ONCE(!vma_test(vma, VMA_WRITE_BIT)))
>> > 		return false;
>> >
>> > 	/* Don't touch entries that are not even readable. */
>> >@@ -97,7 +97,7 @@ static bool can_change_shared_pte_writable(struct vm_=
area_struct *vma,
>> > bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long=
 addr,
>> > 			     pte_t pte)
>> > {
>> >-	if (!(vma->vm_flags & VM_SHARED))
>> >+	if (!vma_test(vma, VMA_SHARED_BIT))
>> > 		return can_change_private_pte_writable(vma, addr, pte);
>> >
>> > 	return can_change_shared_pte_writable(vma, pte);
>> >@@ -194,7 +194,7 @@ static __always_inline void set_write_prot_commit_f=
lush_ptes(struct vm_area_stru
>> > {
>> > 	bool set_write;
>> >
>> >-	if (vma->vm_flags & VM_SHARED) {
>> >+	if (vma_test(vma, VMA_SHARED_BIT)) {
>> > 		set_write =3D can_change_shared_pte_writable(vma, ptent);
>> > 		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, nr_ptes,
>> > 				       /* idx =3D */ 0, set_write, tlb);
>> >@@ -811,8 +811,8 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu=
_gather *tlb,
>> > 		vm_unacct_memory(nrpages);
>> >
>> > 	/*
>> >-	 * Private VM_LOCKED VMA becoming writable: trigger COW to avoid majo=
r
>> >-	 * fault on access.
>> >+	 * Private VMA_LOCKED_BIT VMA becoming writable: trigger COW to avoid
>> >+	 * major fault on access.
>> > 	 */
>> > 	if (vma_flags_test(&new_vma_flags, VMA_WRITE_BIT) &&
>> > 	    vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT) &&
>> >@@ -886,7 +886,7 @@ static int do_mprotect_pkey(unsigned long start, si=
ze_t len,
>> > 			goto out;
>> > 		start =3D vma->vm_start;
>> > 		error =3D -EINVAL;
>> >-		if (!(vma->vm_flags & VM_GROWSDOWN))
>> >+		if (!vma_test(vma, VMA_GROWSDOWN_BIT))
>> > 			goto out;
>> > 	} else {
>> > 		if (vma->vm_start > start)
>> >@@ -894,7 +894,7 @@ static int do_mprotect_pkey(unsigned long start, si=
ze_t len,
>> > 		if (unlikely(grows & PROT_GROWSUP)) {
>> > 			end =3D vma->vm_end;
>> > 			error =3D -EINVAL;
>> >-			if (!(vma->vm_flags & VM_GROWSUP))
>> >+			if (!vma_test(vma, VMA_GROWSUP_BIT))
>>
>> IIUC, should this be
>>
>> if (!vma_test_single_mask(vma, VMA_GROWSUP))
>>
>> instead?
>>
>> #elif defined(CONFIG_PARISC)
>> #define VM_GROWSUP	INIT_VM_FLAG(GROWSUP)
>> ...
>> #ifndef VM_GROWSUP
>> #define VM_GROWSUP	VM_NONE
>> ...
>>
>> VM_GROWSUP is only defined as GROWSUP on parisc and becomes VM_NONE
>> elsewhere. But VMA_GROWSUP_BIT is the raw ARCH_1 bit, which is also used
>> for other arch-specific VMA flags:
>>
>> 	DECLARE_VMA_BIT_ALIAS(SAO, ARCH_1),		/* Strong Access Ordering (powerpc=
) */
>> 	DECLARE_VMA_BIT_ALIAS(GROWSUP, ARCH_1),		/* parisc */
>> 	DECLARE_VMA_BIT_ALIAS(SPARC_ADI, ARCH_1),	/* sparc64 */
>> 	DECLARE_VMA_BIT_ALIAS(ARM64_BTI, ARCH_1),	/* arm64 */
>> 	DECLARE_VMA_BIT_ALIAS(ARCH_CLEAR, ARCH_1),	/* sparc64, arm64 */
>> 	DECLARE_VMA_BIT_ALIAS(MAPPED_COPY, ARCH_1),	/* !CONFIG_MMU */
>>
>> Other vma_test() changes look fine to me: just fixed INIT_VM_FLAG()
>> masks matching their VMA_*_BIT :)
>
> Thanks you're right, will fix!
>
> Again I swear I ran claude on all of this so it's failing me here :)
>

Is it better to add something like below to avoid misuse these mutually
exclusive bit aliases?

An example for VMA_GROWSUP_BIT:

#if defined(CONFIG_PARISC)
DECLARE_VMA_BIT_ALIAS(GROWSUP, ARCH_1),		/* parisc */
#else
/* make VMA_GROWSUP_BIT a build bug on */
#endif

Hmm, these VMA_*_BIT are enum items, so the above might not be possible.
An alternative is to only define them for the corresponding config and
you will get build errors when trying to use them directly and the
config is not enabled. Otherwise, misuses like "vma_test(vma,
VMA_GROWSUP_BIT)" is harder to uncover.


--=20
Best Regards,
Yan, Zi


