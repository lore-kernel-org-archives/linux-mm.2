Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7BFDC44515
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 02:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E88F6B0122; Fri, 17 Jul 2026 22:32:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 499136B0123; Fri, 17 Jul 2026 22:32:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33B216B0124; Fri, 17 Jul 2026 22:32:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D820E6B0122
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 22:32:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F333160301
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 02:32:26 +0000 (UTC)
X-FDA: 85000323492.02.614D174
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010047.outbound.protection.outlook.com [52.101.201.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4CE9918000D
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 02:32:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IQufl9Ov;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784341943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7u32SvWnmg92sF70UYVL465Y9YPZVIlMLC9Fiw7ziqY=;
	b=0i9/E49Tm49xadJYWE2vkkP5i4ckDUyjP7Tn7vKXxEEMT/fl4I++j05IrCnFYKzgPuesWl
	nx4s+CWjiL90q6g6H4r+h7yK8qiOESdVs89b7RyN/nZF4+yZFQm/LycQHx7uBf/vbh8uwz
	8hq6RclKPaLuxHiajUiSjAfx7ZFEwY8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784341943;
	b=y+k+b08fbijhHITi+VXYIpTLTTNmNhULaGSc2xn6WhydpOkkPSHy7PkNDYRlQgLkS6Skjg
	yTp8nB/CdnfJwxURXuJ+t7tbA/wF9suyufcfhdJYjJK0kT4L9ZY7BdABnCC7angAkj7uso
	Z0tuVDhdAMBe306gqmWIkrobVueJFt8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IQufl9Ov;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TjVWymu4D6Y/rAb8jww/iXdqhmWJ9k83EY9bVFf8a4sZv5nwYy8owEr24NfwVKZ6ZDxrjJxlsQoKtfc7i9XkQo6Q/t4EqQLYoAiLqClKaGTqf7mpBS8FDroQYxt75sWm5p5K+qyVdcNhFgn1lj5snekmfQRTM72j0ok/3FR92/LenhZnvCIOSOFeE9iVzrbjm4c+Up2kOL6S3KTFv9P1vw23h+qEjla+4Xowjk+6yx4GcY5CKGS7vzXpSIundkiH5PLh6OwI6mwsseMXyeDJ2foLEs72FtwcBiFoXffiiJeGiQaOXC4nEdoY8vqjB7RkG5T/lyjzv8VRHq5ntp54rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7u32SvWnmg92sF70UYVL465Y9YPZVIlMLC9Fiw7ziqY=;
 b=guLVwHOQD1N5iePDaVp5Z6JDPd7DHBaHhNxnp64I5maykwxHMLYRYjrJmicKIPG/OBPQZhws8IqogbosAvzKOs7vVO3Wy4CflVWfdJEsSQ+i2bTXQmAYjJ5/CXT66GBxPXvwt6yX1yEpwWDny3ehh2IVhAX7Jrc1XJUQQWtXWHTTGCJ3+IW8XmENsrQ0TYwTzWNsB7SLOwUwwYDjsqnprmAdX3O/lEuqqeVSaVC7FBjfxJTcctSvFt9TSZvCm5qCBeFmj8n0nSqxqUt32AHzaWG9qpxTuZTtrOb7Jp1RcuJcecvPbBQQLGh9ofd/egXgfJOFDK7cjceoHK07TBGccw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7u32SvWnmg92sF70UYVL465Y9YPZVIlMLC9Fiw7ziqY=;
 b=IQufl9OvFgI9IC6H26JU0Fu9nlJKXBEfO4dWMjpLo1Hem6j1CAJPvCO5CTAEB7Y3/KflcvmtJPoODe/Cp0wYxNYKV/phXUqfPqW7IyeXU9Bav2bKUpL3IQ6bWO3iZ1c7qWpXdUhA0mSIuGs8Bs2k0fLGbom3PvgORcrfrpTRB3MqBt3pBpeEjowOohKjR0cgfyHC0tE8j+jw4bDoGKACTfaFa1wAu18D9k6P7TIOJ+AhG044LOslOapxbDZ6fljJzDsY280EO4XXrn43Orur+RLnXEM+KtySozwZslU7wQCA7WQQQ3ze2sx4B97Ub9nggGBpQjJM1uHHngEE3P5Xkg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV9PR12MB9782.namprd12.prod.outlook.com (2603:10b6:408:2f2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.13; Sat, 18 Jul
 2026 02:32:15 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.012; Sat, 18 Jul 2026
 02:32:15 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 17 Jul 2026 22:32:04 -0400
Message-Id: <DK1CF7SVAHCV.235UT1PZ8ZYSN@nvidia.com>
Subject: Re: [PATCH v2 02/33] mm: add kdoc comments for
 vma_start/last_pgoff()
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
X-Mailer: aerc 0.21.0
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-2-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-2-2a5aa403d977@kernel.org>
X-ClientProxiedBy: DS1P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:8:454::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV9PR12MB9782:EE_
X-MS-Office365-Filtering-Correlation-Id: 909b2983-f2a5-441f-405e-08dee474c7f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|22082099003|18002099003|10067099003|11063799006|56012099006|4143699003|921020|6133799003;
X-Microsoft-Antispam-Message-Info:
	L6bPRPnjZKCz43AQU9EsaE3en8GriayD23Lj+m0z/1bmu/6upgx13pCy4P6qvzaW2YLRnTJJNpY3TWo55EHktW758d1AkLcZ5qYarj/+EtqCbREyFEsDRmj2fGaY472dtJAf3Z6pNUb2zJQ31qw5XFOtC+FoP14ATlVsQHUNgMaVVTC5uKivlnpo0Mi2CZg8OXAruTZoA+umozylN9BG+dc0CNRJPH+i+t6kD5q18IGahoDY0NKh0yYHcLd2IC11Frgth1fFBeiUVeSUqJxYPo6dtLILb3a58xcXa7H3MYpHB5QwzHYZCCTbvI7OMBR31NdIabNCZk+QcpKRhPEFIaWCw3OQ6JgeZgT9HrDjiolvBoSoGmkxkLE2fkL4KIlpY97COmcpWP0UuV7nkAUKZL7+cLVts7RyN+SwTWWEJOuGyfLT9RjYvncLo8SMDMarPIlFaui8kacmndL53S/JoGXdj+yK6uSQS/IWcpEuSD8PytNSZoeakRFmR1OG9/lDqRaSBh1zxlJD55NkqNhgk3QvWbl2iRuhdfFX66vEbVyKueHTAE7nonKJXLRL5AaKt/gxl5HNJ4z6OoQWNGwKoOwAOur0sfA8Po1pLXtV0JUZTT/dOM18ylZUzzEO05Q01yp79jU/jGSbfz9fpym7Q59aKSFS3aWO6VTHJnGtZHFddCsYNQ/1V9TYiGWMFUZCOqGIka07tZi3zFxl4yG3EA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006)(4143699003)(921020)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bmpQejY5UHJGeUdBOHBxYStOZHRqQVBXUlVmZ05EMUJ4SWFVTHRBVUhybmU4?=
 =?utf-8?B?MlkvemJiTGMvQnJGVVUzTEc5TStCRzR0bFVtSWY2ZDhvOTNSUGVEVHVHaTAz?=
 =?utf-8?B?a1ZGL1ZXL0owWWYvQ3VBdm1MR1plNFVCd1c5YWpiWmJ1UjJVdzZ0TzFTV3pJ?=
 =?utf-8?B?dXdtNTNMNVdJTm5Sc2V5NkM4aklRTEE2NkM5R3NzbW9DMzBaMng4WXZ0ajlL?=
 =?utf-8?B?ZHd6eXgzdzBYRU5CQlpkRXJxQ3BYbjMzeWhuS2FDUGFSNnBEQ08wMkdFM2dE?=
 =?utf-8?B?RkY3c3N1d2k5NXVYYVBnR2hXcWVuSXNpRXJVSGVLY214Y3RZVHBEUkJNckVN?=
 =?utf-8?B?MnV4ZnN0QUZmaEVnUWtZYjVyMzV4ak1vakpwbmUzeE1WZFA0dVBCNVBWV2pS?=
 =?utf-8?B?eWV6dXZ5MTRPd2U0S3RNR0dMSmxDa1hwR3BIMTV2MTJ1b0VlTWxQZ0ZDVUtm?=
 =?utf-8?B?RjhZK0tybG03KzVBY3IvRzR1M2ZROTg3dHFLaTZjc0tiMEZVSHdJSXBIRzVJ?=
 =?utf-8?B?RnFES2hMamgxZjNGaFZqLytidUkwYlNCbEFmOHRXMEdmckJTZkdPYmxyQ3c5?=
 =?utf-8?B?ck1MOStqNXl0V1QrZjc5d2lzaFFhZG1xVXg3MnJjUWxSUUJ4L0xUcDQ2WHhr?=
 =?utf-8?B?eHZkU1cvL3JPL0cvMS9WYitzSVdOZVJRZ3BmSU4wMHRpTXNReThrSzlrU2pk?=
 =?utf-8?B?NjZyYy9HSEZiZUt6SzdiQ0xmWXgwSkQyaTd0VXlWR2UzaGttMHRFckV2Uzh3?=
 =?utf-8?B?N0t1MlBsYW95WVhZekJNeHpIeGI4VnZDc3MxdU82bDRLTnlrUU5iWWFsWU5j?=
 =?utf-8?B?ZW9tMk9PMU5CWlFzVUxGeU41MDFDVGhFU2FsTmxFUCtoZUhEbVRTcUx2R0tH?=
 =?utf-8?B?andOVXJpVjZ6ZGdMUHNjVnVDZTJwaTNPYmdzakpRWEtkeDRXYmVDSlM2Rm82?=
 =?utf-8?B?eG15T3IvMXZKSmtQd3hsK3BReU1sYmp5U0s1M1YvbCtuN2o3VVgrS2poZHNo?=
 =?utf-8?B?NFZWanBZejdRTFlMK201M2podnR2czhnRzdXaEtHOTdzNVdWUXluUDVBQTlx?=
 =?utf-8?B?TloxK1hxZUhtVVBlRVU5eTkrdE52SmZHczg1SVpzRHR5S1A3SHVPaWNUUU9u?=
 =?utf-8?B?RkY1K1NYc2xmSHRPSzNCTGJWLzRvbUdIUFFzemRKQ1RacTdrR0NuRE4yc1VS?=
 =?utf-8?B?OEtSRXhubFJUY3RlUDhFcTkrZDRqSW81ay84SGpuNXRjRklnNWJ0TXNLR1kx?=
 =?utf-8?B?WmUyN1RYOFZUdmNIcWFuQWc3TFJGcWhMSXljZXZvN2QvQWVqWmE3bmNSMWx5?=
 =?utf-8?B?L2E0cXdSMjlRbENnOGVtQjRic3FYSXpsMHpoV25EUHhoZE1vWE1mZDNjZmk4?=
 =?utf-8?B?SW1rWUJZRnVWbzNNaWF0TDdNUGFvVFpiWmRCRlB6QTd4Q05yaXJ5ME1KQzFp?=
 =?utf-8?B?c2ZTWUFKV0hIeEl5ZmFSL3ZrTlVJVzRzcjVUS1E4aGM3Um50cXV5OTQzWnBo?=
 =?utf-8?B?V0wySmQ0YnJsZzM4TmZvb01OaHlobHUvWWFqUjZvbDJnNGs2eHpPcEszakVj?=
 =?utf-8?B?M3o4bytWdGs3WDNob3RWU01mZDVMenFzS2R0eUJ2N3JERWZaVGxIVmtaQTF3?=
 =?utf-8?B?eDBBVEZyandnNnYrTGNNcEc1dkozN2prcloyV0MzNDRBS0pDRFdZTWUvS0VY?=
 =?utf-8?B?cnhIR1FxK1FpN2R3aWYvcG9CN0NZSG1YellPdU94eXhQYmxOcVM5bkdienJn?=
 =?utf-8?B?Qll3TkFaNU4zZ3l3NmpFbi95amZuSy84aGJkNXpBSERIYmVWRDYrSDdRM0I4?=
 =?utf-8?B?UEFoOGxLWDIwWDFnZG9meUhsS2t6Skw3TkNiWWloNGNCdUVBZml4YUM5UEY3?=
 =?utf-8?B?NlNtNHRxVTYwVVNuRTl1THNiY1J4Rk8vOC9DMUxxYkg4SkcwKzBzOWs5Q3F4?=
 =?utf-8?B?eVRpdVJtTXVnWGxlOWRqK3JjSnhqc3g2Z3dJbGhwVEV3VXlPUGhZMXovaXpu?=
 =?utf-8?B?dlhQWlNxamkwb1A3dGtheTd5SitLbXdjY2VoY21JdzlYcngrZmZueVNRRG9U?=
 =?utf-8?B?d25VWWN2cnJ5eWFjS1NNRDUzRWhIbmlMbDZrc0VSWVpMZ0d1ek5lcEYrS3Fr?=
 =?utf-8?B?VHNHWnpoeGpVYTM4bHFpYm5WMzhTQytBaGpCS3BxNzRKR1dKVjcvbExLaWNo?=
 =?utf-8?B?SUpxaXRIS2dFeDMzZzVWTjZmcGlJUDUvTklpVUhWQkU4ZVNkd1RTNHR0UEZ6?=
 =?utf-8?B?ZkZGdGRwU2tUR2ZLSk9qb0Z6NGxrMnljaFNEU1B4MEp4dE80aTFCNU1HMGor?=
 =?utf-8?Q?wT7z1YIbJMYGupDv13?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 909b2983-f2a5-441f-405e-08dee474c7f1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2026 02:32:15.6243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Bj9F6SnTKb81dS6lC4gA3Byl5p0cfXLqtSnYCk3MX6G+LW93TdW+KC2Egp3PvQx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9782
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4CE9918000D
X-Stat-Signature: h8ai4ett1t4kmhk65zfzp88jbfqy4yh4
X-HE-Tag: 1784341943-429285
X-HE-Meta: U2FsdGVkX19iWahx0xGhUj9FVgH+uxWtZ5NokVqahGbGS/MH+zcW0s0Xc/UcNuTu9joIP3LDOurGJ48ofbGx2340rz8CsXNCooWYMfpktPLJDeZr5HNLV9IQ/Cb6wjAPrOCsmyvcmtP0+9dbq3yuncBgr+jiM2C7TE0XmS96pbHiZk0iB+KpCvKEsSMvyZj96P9e7PiYn7g6mqar8rxwIqwSyuozWUJay83RJCDTyOKCdajaJ3MfHlb4+eG+lmrnAz1syvCobyNky4FuSaj1jDBpCt5n9RsMRsPUyIpblzu48/Fxzc+hdJH2S7MLQyZcfKPF2kckRpguIiEXjRFRz8W69S2BD7cGdwNEXoHz3oEFng4VzM5x8ykXJzJiiNF9wSkkjP3+mvhtDasUY76g8muOqYius2NYAlqnb2jMp5ZaNqoTyr6Cmy+dMWN/LcJGZuQ/8i8c1dvy8CDIxKoy7x4R0pIq1IkEHQalKHg8vQsLZS4ZQ8ioEooo0DbLnwEUs/RVRciGBpThmoxfEmTZvqBRjIsTMAG0MG+0BK2iinDuEQBqwD+qYPdwMYiCaG01IUCg0bgdO/WlNLrlBzOO4MEX9KZVlFCtkySp5NWghCy8SyJLj6JXMzEiCQXUlE37+oDgZvPjtAsFiMFDpLyyPx2lpr24n0v1BgXUr0hL0JTEmyorFhPgerJaNbQGIlgPApi3Vlu+PYDllbuB9++Liz8eqWyff0LobGr++hV51dvMAwU6shrfs0k3GH/2eW3OcEZISN8JMVmbp+Q3RHEBKFEu86kl5gO/OBfIhZ995LApl0Dfu6HJl63zH9JJD9VnJGYPq0PlUg9XBVFkmoCryliPmXMO78Mo080dQ1MDA12C+RCKTPXA+9QV6Q5yCLhWgcWMNzqd5fiR8FCqdjRi9dQNYpvEeteXhukTPnYrsz3XWvwEJXXf4XYkRWPvbPFZv9SJW/6j05/qckfyNWX
 P/l9WcSy
 JuYRXwBQXptjTIH5qxWd4xn1ezqtJsW76sG73wdyWu30cv9r0kjGKOsw52+QoJS6diFAaY2f2Bk/UJJyyiNSE9FYitcawgWnnqBwRSVhKE8TcxfuFHDhOxTQ6QJn/soyNAo0NgdJ/Wtz0ut177aACskNUUS/YuNadq7Inm5QcMmbnW5704N/AdjJmbJwN/BeI0IqKYzBENhfDdiwPjMK7WoCzNTy4zwV6Y9cl1Re1DrrtQDe60LFCZpjVz81BoOMiWIPMDOLPuEkpqNRECJmVS2D+TYFdy4U25lfraOxHAp9825TlH7Z0VPpUg8aBq+8Nu9JCwhEtyGoeN8BkEB4TUSWvTKt/p9l6bLvqB3A0eArqameiCDmFQ+adikLvyDK8GcYRnc5O0U381P3ELmjo0wKPl+ZnO6Vlr++fi3VGOsGUVFRtS7aiL09NC95RilBtUfAV+isZBCb6yAwqSWwMCG+r9ZHY3p5R9cX0EBoI2RBNqBxo/XV1FJqwI5oSgxHMfB4L+go+jKD0V/K/PP1aSNS6XIITb7KSO/TQBjo0R9dvDjJ8I+m2NxkxJJsgHZHKBVtaGJR29U3J0RGlI5iZIQFvPchIPXrQioYjmbDyd4Hozy+icVQfEW/9ANq7so5lQjEFcPOZzQJfGak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 10, 2026 at 4:16 PM EDT, Lorenzo Stoakes wrote:
> Describe what vma_start_pgoff() and vma_last_pgoff() actually provide in
> detail.
>
> This is in order that we can differentiate this between functions that wi=
ll
> be added in a subsequent patch which provide a different page offset.
>
> We go to lengths to describe the edge cases that can be run into here.
>
> No functional change intended.
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  include/linux/mm.h | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>
Thanks for the explanation.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


