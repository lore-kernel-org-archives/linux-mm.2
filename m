Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3142C4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 02:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34C16B0128; Fri, 17 Jul 2026 22:37:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0C3C6B0129; Fri, 17 Jul 2026 22:37:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D4F26B012A; Fri, 17 Jul 2026 22:37:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C2506B0128
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 22:37:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E3FB814024C
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 02:37:44 +0000 (UTC)
X-FDA: 85000336848.27.FC5E799
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011043.outbound.protection.outlook.com [52.101.57.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id 201C7C0009
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 02:37:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OyaCi7mF;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784342262;
	b=e78dyG2N5w4xqBVBom/8OJNnVYZuIFBwH4cTxKnN6GA++NqL/ZyOsoqAafHtVvTm2rQYkS
	1/sE2jx6KP3OwXURoFXOZg9aE1ydxw6aZtfDcGfcXNXjiaDCODqeDxlanCYUysJBNK6RbC
	vlVn0mEwy1fCjr7uBgh+PNI5OMx+Ny8=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OyaCi7mF;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784342262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DR/oJFuRDPkSyVNyFpSraBTM8YaOoiPBBNNfaatksfk=;
	b=QerUmDPavYICJ1IF9PunqahlLDwKrQO5Q0SqaDxLHsz8oGqFmqEg3KYIbBniE58E8bwl8R
	wjr1uly8Wq9ozp4jgDs3zcgj842dnMsAqU+Gx/WMg5ssA5W/NrbGQMOhBVsCzHhyLUj0WV
	P0+OJHGhHGdViOVDl+k7ydPwiqCHQ4c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WUhKJQcZimDYMFPzBTHLmnSDBWwJZRn12MTsszRnMb5HzFoG1bNtCJVDFRxIGyQOp+3ZV92IiOh2+CmFQOQZrJST20xcmIXfOak3cBAz3bUyxBRxEw9K7kVyUVNPGi3z4l7r139DhLojd+NPaoS4tbOKXKAPXUP8Ea8oCUfIGYpXM2JKj23eD8LV6yd5iLUiYJ3L9826t/x88+eMDmkspEyQ6rqyGtgwU9TCzClCRZb2dvAulxa3dcmwj0AcvytjIv2JQj2rXH7zdChQpcAs7QjA3bkk806g+se/GWJI9TpUyvcXCJIPTuZUY8WDeNUHYCmaW+m+wla0rdYiAp/DHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DR/oJFuRDPkSyVNyFpSraBTM8YaOoiPBBNNfaatksfk=;
 b=CLJqB8GmAi6nHQEr+qVrADsXHNluxDQNDc63GNT+qzYPBnoWSXrCp1en738H/CheCfvkMVldrlVniRJjzuX0klRhlyaakF9Z0114g2F21Wz3rUtOse+pYhT3AmRI8GQnA35y46v41hNbsC6rxRUv/63YBmhWQY1ilBVtj0XL3cd90UqKiBuPemR9JXPReN6kbzzjejHCLj4ZN8pB2eDuUJx5x5J7b2swlXOIl1hzEpoXjMjsNmKjYFPWMq1JlDC3kWlfgtQNMFAydyuAR1HVswbK84ARUSeYSMZWeEjUmXiOH59roEd/11L9aEGw1oHLAUuNDMAXqaOuNlmoR46FcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DR/oJFuRDPkSyVNyFpSraBTM8YaOoiPBBNNfaatksfk=;
 b=OyaCi7mFPqDuCy4YSozt/2Ps/zbxsdEfyjEgY0y9Y2Z5iqPqRvkrMC5qMBCFB0Y+JrtEKjV3SiICqBojYGensIOXzVj244O8pgnG3Z6+4VXjZrprTGz6oyXCRh3sb3w43MsAqTpgUuLcqQ5aUBhnFUw/yk6urwmGe4BuWiNQEwp+8qvM9IFoLLJwCG2sjCxukFJEt4agIdUwlUAbIbymJQa6Y3NJusvaTsJ8rzRr1tGF81VkpZYYKR/QQLYdnsuCA6+IigkGHfEtxkA5aBZJNMxo83DXCOES0hi6KJRlTRFD9b8BlK1VwoqwXC1wIPmW6R9JXYAsLnb0maWG7qQU+w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB7571.namprd12.prod.outlook.com (2603:10b6:610:147::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Sat, 18 Jul
 2026 02:37:24 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.012; Sat, 18 Jul 2026
 02:37:24 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 17 Jul 2026 22:37:21 -0400
Message-Id: <DK1CJ9GBQXI9.1EP8BKPIRK3PZ@nvidia.com>
To: "Lorenzo Stoakes" <ljs@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Rik van Riel"
 <riel@surriel.com>, "Harry Yoo" <harry@kernel.org>, "Jann Horn"
 <jannh@google.com>, "Lance Yang" <lance.yang@linux.dev>, "Pedro Falcato"
 <pfalcato@suse.de>, "Russell King" <linux@armlinux.org.uk>, "Dinh Nguyen"
 <dinguyen@kernel.org>, "Simon Schuster"
 <schuster.simon@siemens-energy.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Helge Deller" <deller@gmx.de>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, "Dan Williams"
 <djbw@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Muchun Song"
 <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, "Oleg Nesterov" <oleg@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Arnaldo Carvalho de Melo" <acme@kernel.org>, "Namhyung Kim"
 <namhyung@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>, "Alexander
 Shishkin" <alexander.shishkin@linux.intel.com>, "Jiri Olsa"
 <jolsa@kernel.org>, "Ian Rogers" <irogers@google.com>, "Adrian Hunter"
 <adrian.hunter@intel.com>, "James Clark" <james.clark@linaro.org>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Nico Pache" <npache@redhat.com>,
 "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>,
 "Barry Song" <baohua@kernel.org>, "Miaohe Lin" <linmiaohe@huawei.com>,
 "Naoya Horiguchi" <nao.horiguchi@gmail.com>, "Xu Xin"
 <xu.xin16@zte.com.cn>, "Chengming Zhou" <chengming.zhou@linux.dev>, "SJ
 Park" <sj@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul
 Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Hugh Dickins" <hughd@google.com>, "Peter Xu" <peterx@redhat.com>, "Kees
 Cook" <kees@kernel.org>, "Marek Szyprowski" <m.szyprowski@samsung.com>,
 "Robin Murphy" <robin.murphy@arm.com>, "Andrey Konovalov"
 <andreyknvl@gmail.com>, "Alexander Potapenko" <glider@google.com>, "Dmitry
 Vyukov" <dvyukov@google.com>, "Steven Rostedt" <rostedt@goodmis.org>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Jarkko Sakkinen"
 <jarkko@kernel.org>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Thomas
 Gleixner" <tglx@kernel.org>, "Borislav Petkov" <bp@alien8.de>,
 <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Ian Abbott"
 <abbotti@mev.co.uk>, "H Hartley Sweeten" <hsweeten@visionengravers.com>,
 "Lucas Stach" <l.stach@pengutronix.de>, "Christian Gmeiner"
 <christian.gmeiner@gmail.com>, "David Airlie" <airlied@gmail.com>, "Simona
 Vetter" <simona@ffwll.ch>, "Patrik Jakobsson"
 <patrik.r.jakobsson@gmail.com>, "Maarten Lankhorst"
 <maarten.lankhorst@linux.intel.com>, "Maxime Ripard" <mripard@kernel.org>,
 "Thomas Zimmermann" <tzimmermann@suse.de>, "Rob Clark"
 <robin.clark@oss.qualcomm.com>, "Dmitry Baryshkov" <lumag@kernel.org>,
 "Abhinav Kumar" <abhinav.kumar@linux.dev>, "Jessica Zhang"
 <jesszhan0024@gmail.com>, "Sean Paul" <sean@poorly.run>, "Marijn Suijten"
 <marijn.suijten@somainline.org>, "Tomi Valkeinen"
 <tomi.valkeinen@ideasonboard.com>, "Thierry Reding"
 <thierry.reding@kernel.org>, "Mikko Perttunen" <mperttunen@nvidia.com>,
 "Jonathan Hunter" <jonathanh@nvidia.com>, "Christian Koenig"
 <christian.koenig@amd.com>, "Huang Rui" <ray.huang@amd.com>, "Matthew Auld"
 <matthew.auld@intel.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Yishai Hadas"
 <yishaih@nvidia.com>, "Shameer Kolothum" <skolothumtho@nvidia.com>, "Kevin
 Tian" <kevin.tian@intel.com>, "Ankit Agrawal" <ankita@nvidia.com>, "Alex
 Williamson" <alex@shazbot.org>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Usama Arif"
 <usama.arif@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 05/33] mm/rmap: update mm/interval_tree.c comments
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <linux-parisc@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
 <linux-perf-users@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
 <damon@lists.linux.dev>, <iommu@lists.linux.dev>,
 <kasan-dev@googlegroups.com>, <linux-sgx@vger.kernel.org>,
 <etnaviv@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
 <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>,
 <linux-tegra@vger.kernel.org>, <kvm@vger.kernel.org>, "Russell King"
 <linux+etnaviv@armlinux.org.uk>
X-Mailer: aerc 0.21.0
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-5-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-5-2a5aa403d977@kernel.org>
X-ClientProxiedBy: BL0PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:208:91::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB7571:EE_
X-MS-Office365-Filtering-Correlation-Id: b20562c3-e7a8-43e3-7928-08dee4757fdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|921020|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	z+Pj09Yayo7/DK/V0JZG+KZJzu1BY3joe60TJfq9mci2SjnBF9Gy9tKhV3VuAsaert1WFxkR/A1dvPdIqU92rGMv/RMjsZHTJJluAUlyaoPeMUlV6G9qq9olAKNldBotvyqp8T6Z0ToUbjNTs3ejLqcixwUwVBnj/zultYiGBjQMOnxE2+xnU/Yb5wRNvHSgbe/7Rx6mMCvSmvGCYY96zgfId/FHwuZ3lvrF6oFQ7/WJERmvHwR6dTF53QnENnBFeVdOg6QFc14Q0EGrEiLyjE2SaSFFruVnB4iiWv7vhmsfgjOVU34VRcMkuJ69JhNHsUKMEWpw7jsGt9y94ko64KVVdP4GyCXt7FPJ1N4QIcx9lPaig/hpUzGb6JNXqa1INicjKLZg9Kt/3MXX8NfOOBCpV6u6B8XxixqvzDCaELMh3Lvgm9CYwleJdYBgKrSRoHHwxss3LrW5MP1Ot1LbHw6P3gsGyH573ZK8Ovh7KI0BhtaR9kkPY0YqrDzr/2b31YLlxsteB7AoYtlg/d4tIl8qlCyPcyJX023ohVQUN6ySeL8/Dmq0asjHVDTFArIdZol7V58nnWdb0066HeKrwC8ZtMFVFPgLBywntTjLth6+3A7ra72V/KVLrzY+OM/6d6VAewqumEu3ElQ4/j9M+MzuGjMVhw1o6r3orf6e/eoxwZDMBWsQORdE+K4udmUOXNTssH33CusVUhY9v+dk2w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(921020)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0RSd1V5Vm1KdzI0OWx2TUxiVnphb2NIcWFTYUdralBPaldWcjZuejBoMC90?=
 =?utf-8?B?b1F0cnJ4cjM1QzlXZjc4L1hGSVR1bEtvM1RvamE4OXdZVzlNRHR5TTFkdEFh?=
 =?utf-8?B?RzE2alZNSVQ2VWhKRlRTeWNBaGFrYjBwWUtFYVYxQ0dQRFhka2pTaXNBVzds?=
 =?utf-8?B?ZUloTEVPZE0wTFdqM3lEL3FWNDU2bWJIaWUwblBuWnF4aDBkZzlTdXJTTmR5?=
 =?utf-8?B?aUt6OHcyTFV3Q1VXelVDQi9NNWdnSUVZRXpXWEladG1iZG1OSzYxZUtrYWh6?=
 =?utf-8?B?cjNOSUtqL2duWXBQVXZuNUR3bWZxazVtN3lKRDNPQ3hSRDlWWGMvNEtGRGh3?=
 =?utf-8?B?YlFRclJPWnlRT3UwNFBGSTRXVlR5TTZYait2Z2wzTWJhbWpnSzhzaE1zbHFi?=
 =?utf-8?B?aWwreG55UHVJY3REdS9HT1VtYTlSOXAxWFprWGlCTlFjeFViZVZyL1NXWUFQ?=
 =?utf-8?B?N3VLekhmMzB4blMvVkwzelNESjl1empadVVJNERXQjRTOERPZHE2M21Va0lo?=
 =?utf-8?B?a1dVNmRCM1BYT2U3QWZYS3VGV0VEemx6SW1QdkxGMmU4SC8xZW9uZ2E4ZXBI?=
 =?utf-8?B?cndWdmtLV1ZFTUF4MVFaTlF4em1wVkxOSjIrY2dqa2VEVXFjZVRNT1FFd0VI?=
 =?utf-8?B?d0NyS1QxSFhUSzA3b1BkVVE1QzJQYXRTSEcySFhwUWlZZVRKUUpWb3BsRTZ2?=
 =?utf-8?B?NUk2YitYSmlKYnZZS2RGaEs5ZGxIRDZXU0l2dlZ2dFF6VE9wU0JRUnZ3SURB?=
 =?utf-8?B?bDAvdFJzcDlmQTErTTlqN1ZPaERmRm9WdXpWeit3ZEl1dW0vZGtJR094TVBa?=
 =?utf-8?B?THRzWXNES3A3M3lYUGszemNBTldhSWJrL0VaT2kxZW0rNld5bjRjZHk2L255?=
 =?utf-8?B?VTMybjRhcUdHWUNBaXZnaDBTaWpNK1NmNTNWYWZ4YlpPa0dvMlJHbkROdi90?=
 =?utf-8?B?RkRrYithdmh1R2o3bmU2SmlEdFV1L0JpaEoyalBTaHVvYzFwUnpPSUh6NFNC?=
 =?utf-8?B?UWJRcS9XRlkrRjhWMzZPNlpmRXdUZk84ckJ3SkJ5SG4zQjlldGpVUnNsUE56?=
 =?utf-8?B?bjBQbkQ1Uzg5VG1ITkdtN3RyMFk3STFnNDZoTWJiSEFtSGlmOHFUcjJTSWJv?=
 =?utf-8?B?YmE5Ui9wWWFsVEFzekU4WFIrK2dEY2Q3bkVIQnFzR2xSY0JhMFNJaW01L01s?=
 =?utf-8?B?QXppSng0R0IzY1QxcGFKUFFjWE0wVGNFTzU2c1kwT0FneVV3RWZieGgwSndY?=
 =?utf-8?B?UUtDcmkzM3owTkUxT1VhbU9LeUVRUjdpaWFyeWZBZGM5ZVY4aGp4VnRvWU5I?=
 =?utf-8?B?bytLanZkYUptM0hiR3Nhby8vQytpL2pwaFhnZFJDMTMrU3d1K2hDQXlVQUZE?=
 =?utf-8?B?V1FGNVBGYUhtSDQxaWYzT3B0dC9UY3ZNc2RJdUxqbTF5NlkyRTBDQnlnV09i?=
 =?utf-8?B?V1FNWmhIbHdNMjRKQXZaeERHV1ZKRWFVRHNkUHhFc3F3R1pSTktGUGh6ZkRm?=
 =?utf-8?B?YXR6dlAvUFpXakdVOUVja01pOWUvbGFHTTF4a2RoVS84YTkxQXN3bUtxZnAy?=
 =?utf-8?B?eXY3Y3VmTjB4ajlrWERKRGI1QkdJMEVrT3pzQWdoK210NG9Db0J6UlBnK0tU?=
 =?utf-8?B?RHJWTmFnZ1o2czIxM2xSK1FDa1FpYVp3bUFhZWVQK1QzQWN3b2U5TUF0MnJu?=
 =?utf-8?B?NE1hN28vR1ZYK3pvSFQ0aHphaGsvVVM2a213WHlUL1lLd3RuM215S3JoZ2hZ?=
 =?utf-8?B?QWV2R2tBSEM4cldRRlVJUXVXVUI4S29RbktyN09McGt6RFJXeS9JYk5ob3pC?=
 =?utf-8?B?V2gzUzVIZnp0QWd3b3VCMTJ0dk1KSmtxdlhsSkFsOUJwSEI5cHZLUjdYNkdr?=
 =?utf-8?B?Ym45dk5mVzE5T09LRG84dytOZy91a0RQRUFBUWRNZnNRLzdEd2o1OHNNdnVY?=
 =?utf-8?B?L0RKSnh6QjJ0WHJud2JzR1dybzQ1QUpaOFZnY0dCbjVuR3QzTkJjRlc3ampM?=
 =?utf-8?B?N1RRbkNlQXZ1M000ZmFaNnFOc1p5UkFRUjNmSWZYWUhwVDFNQTVyd0laWkxM?=
 =?utf-8?B?WmtaaWxPVGNjK3hsOFdIWDFBT2tvc2tBeU91UVViVEFRMkNNQi83NDhiSWJ1?=
 =?utf-8?B?QnNQUXdTd1RFQXNCQ0s0NWU0TzJ1bEd1Z0JhVkxNRDhjcjQzcWUyZ3R5WGNT?=
 =?utf-8?B?VGZPY054Tnd6Q1dDQXM3SmJSUXlzVXhjbkVGdThDVzY4U3hiVDdodnV6TVhB?=
 =?utf-8?B?T2Yrbk01aHhRUGJPeG1WREVGclNEQkZhUndJSnRROXJ4Yzg2ZHFTbGFkZXE4?=
 =?utf-8?Q?itarxlNkIGOHx31fvG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b20562c3-e7a8-43e3-7928-08dee4757fdc
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2026 02:37:24.2323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d0Xh1Yp+bzp3TNzw48Us3ZZH5ieUrF2dIVRAgSNHD6x4oMJVkJVjReA7xNd1rUGg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7571
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 201C7C0009
X-Stat-Signature: x19jdgfi6cm8iohxjhc6o3ha5o8oeszr
X-HE-Tag: 1784342261-344514
X-HE-Meta: U2FsdGVkX1+LxArr1xHBT51PPNhPwlEWE4jVURjoguUuL0GFmqmHVoVnJxHyFYI8v38dXk1ZHgzemUUhMSIzH371XqrOsGXL8dhxnOShXySj2yttyLAk0gnHEgM8PXPRxrVqUyTN/HtrsP2yw5oaqMO1c30ro4ktsrWhrFAbdIbrKV+4eqQhXsWK9S04QIxjb1pe+gewRdwJdg4ZwsqWp8xHfSuEZqwpfHbiv4Yi5O4Fn8IVtQenbtZxwErQxGVbg6JRXeGe2usWl5ZBfNg7z64exlXXsdTbL8DDpzDc7C/xoR4y2BmJOU0pJEa6Sf36xdxpMAez1rIKtk9u1xZuhQPR+9k1phD05uEazNNjPhvDSe1zXKSYweN6cG96RfPEibIO3ZapC7qADIqgYnVN1r486ieiuop+uAM9P9a+/yX/wMqFYJWiykUjmtyeRZUcBsKHmqSmFdDPAw+pflRh3p3HEuZ3xtVcGOSSa4Pe6HQxB7Gu3X4AxrTeNPbraeq2ZMeUdO8YxCFKDCJiQIVU6R1yiAtd23nPSndmjlD0F40Dgw7oS48iki2E5MWFUYpG0F7kpnZYkLMNB12j9q5A9Q8EfzDWAWkCb4O8kPaA5yD/Cv8K3PrkVzOx92Ra0leflf/eH1rLmhcswxGQi9cWUzxizBYkBfOIPAn/r4rnMzwYzJ5qY6bMpq9bkZJHdrtQD6o8KQYMnQ1Sp/STJGlbzVLYKWkI7c9vXMkxcC9GD/2u56rOkxoB/37V+JI6heD5d4zRfBlRX6Id1MXIVeFmd0Yc/bYEpdjtyIMA9LOQdNymv/KQiOmu3/2NNAxiAxbrckznTbk0k3Iwo/VM+/XyT6lcY/c/82PUxuZXNfotY+j9w3LoVxr3xiaeMhXgfgm9FXSWn4Abd3Pbbw2Uognq0Q+r78NqsZ129+QtBstD3WrCkGnAQ+rl7gX122UtmL2c85h5fcf26AP6rRNXW4T
 yCdr9I+4
 abPmwkdSeJBWIzQpkNRCcK1o8IMKWYMFAeRW+gQPsRr9SuOvG4NGSz2BO8IIUpyvTHwGae+a/YewGmXLnSBz/aXoFfbBNsZsVVENHmrbO8VOf9Lh6cZhjTZsxxek5RawNT3mpcF8DgsN+8F5C/9ymDIP+stB2U+249wz/ZnCTU/4ughwFc/Itvs8AY+/QYhel6YXNCMjQtgcuEWk+fxYA3RMcPFxo7XpgMzBRz5mZIzdos+q71Ph32e46OHaFdwrR7UC+nrTooWDB/S/SnHCQP4CNdIkvKHFbnK0rvHpIF7zLEC7G3Xy0lBV2ZPFX9ptKn8zGg8r0gtfUTM0WZw35gfGO7ig8u6BXiheNZ2AH0xDYhv92lJRvH2ZZ6vZQ+CuY4tbuCMaR65JlQiXXuV+8KdKdjPOCOHFeJJBNLZFGjoZyBaI2g9USCha8ap3jXHZNm0epBssjjMC+REDE9jev+Xj0+TavixAJlZRZpS+ewObrxTaiyIJGsP9c4DgOJK5/3cefPQJb9RFjGG07MDV/G9+mzDY7P8d1WjvV8+jrvpsv/n+/B8QAqmo0f2vOBDSUqkSV0URK5N+C3G7ZO+obQVBmH3OfTR7vqmSXcTlJE4FRyKrweqdyPQsEdxIZc8M5V3arHXsP5QZFKNVFTm01iXueBgihc+yEwrjEdf63Gpvx+sJkxBbP8DZTQT+K+/z1P0x6lhTM2GBAd9A0dBjSRFCiI3n+Fm8C+zIxq+vIvrWmnommGYiBGa5ex/rkAn1+lbaP1Gv2DwIHaURZnok62A8oH7Aq2/9lr42HCFDWDwOEkwq4IsKAG1wETIlpQIx4LTWP3lC0EOsAPn2tIxOHgUtE4smjGTbBbTVZHfEQ5dyhdsbxmAAcg6rdkw1WkQzg14X5ZLTEWFrNP3MaGlngmMzFY2xRwq63ks+2VbOWgYgHgmOSdnavC/Y13MgG6xVvP1jvn97NinKp71++uN0WJPWRouW2
 rUETPBE9
 djmQV35DD1c88ad1ufilbcbf4TrKzDbDV9VrKGEx2G7s11nR06AYfV78ySXpUo/wx7aRBpUmslYZf0gi15BsJIuLF2KzGiDBYStRn5+gmy/uDZBB8m12C+2d9n7kzpZY2hloZKhzFIJeCw1YgWlYnNv7fgfS5eWgcPSvJMDlS66IP2Od0dauFUz9GyzelA1p+UzpClhjnh7W2QIJFe9F445i/qs7qtzAAWrZuP82Rvacgs8kx8YkgQzU6X0VGCYXrS2mIExj3YaKuqLNZ7Pz+CqlAoxgmpXla6oNNCvg+mY5kog0J5S6cxKAAya4HP0uj/dlX9EeFrsiSEnGQoJ56GGPjz72JuXk0Sap0YESnmCPPf//+uvaXbhMy9X12w48X4WpJRWFPFGr1KbrR8O+LkGkTgaF6ocEEWIUe4gmvr6nr1+zYAmjG1OfXCvXNrcWLosNzDhV7ziycONBpB9thNNBiGeoMAhDdo+LZbxj37vfMbuHph0iV4zf8A55WixTBpG1xqasKfoK+HvF9fcGVmJr77nc1Yb3hV3oqBKDwUegfDBkkiz5IztMYRM0woLp0RgLEBn0hI+4VL+JsuA7m0RFgPtHEC5P0tcyTA/omHQ7EjBmKPNoGvAfeFADXaOcQTiI9IfnBhqFSwCB7xC+0YB/aZVlM9UoGGamVLZLeAM6IBkx9r4sy4C3MmCTwxvAQFzL6YtiuvQ6A5gnXeYdebFqhjhbgFLYWNWf/s9zlKEazrA4DUU4b98glNlBDa/ZMcOgbMdmcYKlDOBfstxgk3vgRnNOEkqx0r7Lc8iZU0ByZ72kwfKAeWRbPeY6S+TbsDXmQ077FFSqmGlmsCHMaVIQkCOzum1ZlD+YObDkH6XjdoV1DVMj7lZL0QqMu9Nifp1ZyAaUedMDbX/oE8jx1B6MqX5zT93Id7u+seVgLzOGPCN+pqtU0WFkHc1GMefu7IGLxqDKSQUB8PQtIIcxe/cv2y/Ll
 C+LMJALX
 t+xCok/uisXAScQhvPdUZTtTVpAfJOt3g0w3QdJ18EMq66iG+iBy3C2IW2eaEE6m/kg2oJEWFNbAKgUNPjhN7wq6jJn9Gg8r7eJb4btmTTeUFksa3188gFC8f0jlhSEs+sfUz8agxXj0XG+TYvEnR+5eZ656Bzyw69hv0Cul/CzHmsa7V03zomPGcVmX/d+ubi+bJ4gJHyH8gKNrNLBjpBuXUbxqGreT1ir8O+xdwd97Nx8ZKUrQuP0L0PFZ/UogCc/ZDnuapTVQsTQshzgT1pF2+IHRAmnUcTKWOHhWo8e6FGGl61bLj3Yt9Y1INwmos1T7F9UFlX64jcHDtflARglwVjuSWiY4WlV47XkbkhwayP7q5GOsX7GA5i05vWmfZjvU1nd0xhN7T09XD6s55duoEcGxXgCL162cryGU7hk/M6QfifXD1xnIqbjFICsOKndt+ParXdsvP9/gaL5WenOGiF3ygfEda6Cx6SgrCNsuvmxdVkAjp5Ow7aTGH2t9W/+4BONHmfixGrmD+aDbGeuIhkoGVOjABYIxTxgHz2Yu+qTxF6uIoeC1EJuh4j/mNYBWJOWzwaAv2WvHQitHyb5iTpLr5fUkoUEd5Q9iIm8b6GqFYbOr9qBCWt0fni6I1oIlr9QoBLBjf3z+J6Ox4RKXXu5C4DRa0RDEH+0jSd/Bpvpu3hcIDI+xCuRUPCWE27GKjD9ph1Yf7ZGV9I3UIOq5gB1/slMkON0zOUQZAq+Kzqjjydy6RKWvXl53Nff6UlwYphkyF9RXowS5N8Bec1jlaasXlYwaTw9oOUXABm0MRUfOqkpejhBWX80hqMwPDANw158KBZQlBxAx9V6l8Dg2WXvu6eJv+PBlOOWRcf0nuRj8/MvOt7TlaGmgpg5/11I6vdqQeDLFWaa/q0HMvuovQJvM/Fj1LZQoD00wpUvSppxi19Hmq0kkQkh6yuO//9ywaXTOmKeIrKN+Kw6u9RdFiiY5u
 LqjXWb33
 F3F22HyxrA0OZNT5P1xmcqEooN7fEPKZGENiD3qKSSc2wlOI5enit1TNbum/h86JilAq/YKX3QwOG//3IN2KRw7WWf17WdyP930TQG7Eh8rG0CWyzPVNMz9SjddptCwEjsk6MaYTq6gzc0GGn0my/ho9pmOSbCeU+wpKdGg4ROzqzel+J8uZpNk+LFSM/k9MSrKgkmdywl60O/bKoOoJ6dSQU4atCDgOVIdX0PKZQnVeUf1XKYDFirHiTyWgYFq6+YWlK81i5T2wDw5z28TgFRRkxIB3EKDYXtcrMXVyXx6xR2lVj47JvxB8rCUvZF3Z4FaBJ4KPyJEfC9Ho6G1h8m9MIcov5Nu4lJP9XesrYCvOKZw2BDll/+52QDxeF6BFI+ycThdchGQi8Zk23nfqGToUh5x9xXnIAq3/5mn3qQyvKUEj2X7jXyqUoK302XWvbV/+sAT0VoOky2eaojNM4ukQalxU7+ZNPAI4G78X9QQg0OfXyz93s6WjRF0pQU/ec6o14KXgxrwmZD3eanP+itz16sa/qIUiFSsuU037IiXAMtANER9aphPLPkHJPBeNfmcx6aRyVRlPhMwnrKDHUinVT4KBk5/vcoF6rJTdkpBIQjHHIdabtnFwXNsKlgRk9FfyvQWM8sZ0+0TauNffmeJmtjTfi4MlviKSM7FqdPPaWH57fQIpqKeOig0kIrDrthFLW932Tjx+DLwKuYV+pgCK7TR4Y8zCk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 10, 2026 at 4:16 PM EDT, Lorenzo Stoakes wrote:
> Update the file comment to clarify that both file-backed and anonymous
> interval trees are provided, referencing the relevant data types for
> clarity.
>
> Also add comments to indicate which parts of the file apply to each.
>
> While we're here, convert the VM_BUG_ON_VMA() to VM_WARN_ON_ONCE_VMA().
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  mm/interval_tree.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>

Thanks for the comments.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


