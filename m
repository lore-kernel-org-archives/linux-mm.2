Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48AFAC44501
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 02:29:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0A7E6B00A0; Mon,  6 Jul 2026 22:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A883E6B009F; Mon,  6 Jul 2026 22:29:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 928D56B009E; Mon,  6 Jul 2026 22:29:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 489586B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 22:29:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B9EFA1C1130
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:29:18 +0000 (UTC)
X-FDA: 84960398796.18.D69F3CC
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013003.outbound.protection.outlook.com [40.93.201.3])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6F830140007;
	Tue,  7 Jul 2026 02:29:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sdtzh+uf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783391355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NP/BuSbRJgWDe0nuHRuoz2AG2Ll3dQalQ3DDTSWWWfQ=;
	b=jYU3oS6ix/W/bTUtgDBGTetsdul/I9tyMpSnxvRxfmug4KGrYRUWHnpiKzUeDpn/OYOuBk
	iBpt9h9jgOJJs8rBAJ26vefG1SmC9PYvCeyM1Y1EF7Q/maTQkheCO6bKlgj1FCs793b/qE
	ZFcXZ/BNGK0UEVun4KAOFe1BnSZqIk4=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sdtzh+uf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783391355;
	b=0Pv9as/07TbctIz7JktBtomLKlbFxXPGQJfzNHD9Q+3D63F9MThkRNQ/PXeHuXtSkPVNUz
	7LHCRn2YN2f2C4o1SV6IU9q8m7HDiZQFn7ljkTHIx6ceVrFyetu4lmjWeeK3r2Bs2fb+Js
	fUO+8iVy/g8MZ9Lj11KusDI63Iy4HrI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xmlAi4x/h0BdLppJ8Mj5hXhgDSENpDkIxMWA67G4JXMMcHtvb8Xg4LSHbPen0uX4xfXOXzv1aaXbSlKNAgx1ZshFhvADg4PcYNtiQhrLHqK0ubu0200KKjhkYgQ5S4Cp0vpzBLP/deDyXnBLQ/6RKfr8sgLPx499uCiKs5oc82a/aULgIU0m/rzDIthuVfwkFPrwZR2gH+hv1crsmlGEXOq/4oI3J+FqZWjBNczm3vPkiWC043qBZChlorNJwIQbNHUHTLCGI9GrEwU9/E3sLhtrsyt9iDvJei1DYYIPJXYc/Evc1ZYEvptu7k3jhmbWWu/ry5gHuKzfkKFDavsGFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NP/BuSbRJgWDe0nuHRuoz2AG2Ll3dQalQ3DDTSWWWfQ=;
 b=w+3NC4HXIpHJSPiqgCNAzkoSGpa20qsmOTVWxNwRqP76T7+rizeRKzQfosn12IpN8TtU7+i6IMgOXb240aBZVuGAVGAMRxA2+8CUsmdqByKI8HHE9izk1eKKXATspDTBB6ZYiw67gnlBCldkM0/L8l8DF7+XdLjDn/13UEsJ4EeBroB+vJRS4lZaGTSCgiY9dtFL7DVvyn2XfkUlsncEnjWKx6CF2nzRNlovKxGi/bnFsLqeQBITNRDv4FG07DfDliExe3nG005lWrCwOK9w5cIC2kwNz9XVRcieqaIxADl0DspqrJ3gP1JoFY3Z+sSTEbyW02dOvaA4O0X0XHkjJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NP/BuSbRJgWDe0nuHRuoz2AG2Ll3dQalQ3DDTSWWWfQ=;
 b=sdtzh+ufO2Gzl23/ze1OAe5OBI9fnBQVDz69Mw8RSoYuIZENYyOY6CVnCm5fBpL0xgnwtMgpmAVzFKX6rnq8Hkmy7ELJigHI7cGJ7xDgJ/8FFkM6G9AXhWIk7qWibugQ9UPQOdJTIOxODn8f7ahc+J8oGy3IppZQWkTwZPhmXVDxsdVartH2ZiwQ8K9fCJNhTL+PXlceeo8rQ7NjwGKE/SaC7s0bY1V99NVolmrssbuzIFGVMb4OC4r+ILCJMThz/lHkt7JuUMhzdMbPZ+ll8W7dsUKCYmR6sb2Zuc/KTc5PU+PsB/RTzkLx0Qfs713oESnblCBkCJxei72wp9/ylA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB6275.namprd12.prod.outlook.com (2603:10b6:930:20::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Tue, 7 Jul
 2026 02:29:03 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Tue, 7 Jul 2026
 02:29:03 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 06 Jul 2026 22:28:24 -0400
Message-Id: <DJRZGEZU5ESV.3IP5LEAUQJCBK@nvidia.com>
To: "Lorenzo Stoakes" <ljs@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 03/13] mm: convert __get_unmapped_area() to use
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
X-Mailer: aerc 0.21.0
References: <cover.1782760670.git.ljs@kernel.org>
 <b1ad7c4443f5cba622e4c48c5a9ef15427001a93.1782760670.git.ljs@kernel.org>
In-Reply-To: <b1ad7c4443f5cba622e4c48c5a9ef15427001a93.1782760670.git.ljs@kernel.org>
X-ClientProxiedBy: IA4P220CA0010.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:558::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB6275:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f901e21-3c2b-473b-6289-08dedbcf828e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mg5fB033NKmoDrnf/y8yyjwvnIuBaVrwxC3bbsW5zIfx6Oq/54M/qqv/idKcreMEeHtpxtaqG1tqizZvKkICDQh7XIsDiq6cCvHJpVZbTyF691UacLptENcmjZRMdk4cPqMMfZG8J/lR3RRaXow+tcrPjcjUHCVGffTqdVRZqLyqelGmSLPiY+paQNzrW2rcfAZAuWOyHugry5+kL/SHrYDamHC1HL7KGKXRqp/X2MMhvG1EqPqJfoRV+GF9T3T7ZWaO61jA/h9pGuX7ICplO/XAT81LG53Be6+GdsXamGYgnZV6NegxlRAZHn3cqu+o4xtEfDhEe0fM2u78qCS+4OSPF+wSQbT4HlqkHVoLDLO6LPuseEIKgcY24eLT4koojUEP1Jwe9B7qBw26F/b7lCkGgIaf3zkbalIW8Khk2naeEIPjtbMh3sRjL1bkgfwSfObRlfE6LVLWhmxQ33nRRFQraNLENG0SsVn81oibIvlkrL1NLof73saHNOSFqLbRWLK61ydQY/cCIpEQr7strsdDU4kt6ruQB1hmbqq2ubfGCX6oHkyurKoMv2LRF4QPfqwdxD1tJk82LQq+yCKKpsFV6ZSa2Dv4L7Z0fuDKT3Q4N55umUaT8997Jsf0wBl4eSHHhEJPp00rWdod+QHXakHvHduTmYoa50IPqmJLqMM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TnU3aUd1YzhFNGFXcGw5dC8wU0xKczlKVXczNUE4a1RHY3haUGIvT2REUXBi?=
 =?utf-8?B?RDNrWnBsKys4ZUhPQlJKVmdhZUU2WkdjOXRqbW5QMmZHUXlxZGVBMlVQVDJr?=
 =?utf-8?B?NzNsN0hpbXY0ZW0yRVlTV1J6aWs3T1ZWcU4xSWxyQWdLeFlwcWdaSUF5VVF2?=
 =?utf-8?B?OEFQWDlrbENWUzQ4aEdSNUpwd1lyK2ljV3NtY3N3VG83d0RlSTRqUEZlQmdy?=
 =?utf-8?B?MGhsd0llWjdCNm5wNHlUL1RMSDZVZWdTVWVITmV2c3FwNXFQMHAycFJWRlk3?=
 =?utf-8?B?UnlvOXZjYndhMGlXNCtWTHRSTjZudXhyWjBuK0xzeXUyQTJwYjBsWC8rb0w5?=
 =?utf-8?B?RWVDQ3d2U01PQUlHUHU1em9MS0JsMTFKQjFhc0dLVXRHaFUvdG1jdjRmUkFq?=
 =?utf-8?B?bHc4b1JNRHRTZDFBMU5BTzMyUVlNYWlYNzZuZUFOVTVFRDBJNEZsTzVqOWJm?=
 =?utf-8?B?Y1lPYnpGODI4WnFodTBlYVRmbU5TWUw3alg5ZXcvRmw4YlRwK3VOWEp6RmM4?=
 =?utf-8?B?bzUxL01KSlVPalJZMW5RcWlkS1Z5Mml2NHdoN0xLTEN2RTVCL2xYSjhpZlQ1?=
 =?utf-8?B?OEdZak44NnJwWHV4TGl1NzVzVzJIT0czdzV0V21LeTVmVVQ3TmVmRXRUZktX?=
 =?utf-8?B?azJyVEovZXJqZTRDS2ZHb3hiTkpCd2FpczViOUtlZENUK2xwL29Kc21jUHlI?=
 =?utf-8?B?M0E1OFV6dWVtWjBzUEp1a3JSZmdieWNWY2lDSGIyNTJIcWEya1N3NGhQWllv?=
 =?utf-8?B?UFRQRXE3eVYyYVBhZ0srenR5eExlYk81V1NReUw2Y0VidDBmNVR6eTJBZklt?=
 =?utf-8?B?T3E2c0FmWTFOaGl3Q1QwOGVaWDVaN0E1OFpoTEtxdExwdjFTdXVOVmlmMXk3?=
 =?utf-8?B?ZFJKdnRZVlVaOUZUM0ZyVE9KQ0J5WTRrVzM5RXBtU291aU5GZnlQVHRMczl0?=
 =?utf-8?B?VzNCU2h1R05aRHRDMmZ1ZnJEOFdqMkJJbzhXbkJ5c2tuUWlpazdYdlRKb1FH?=
 =?utf-8?B?cU5pTnQ5UHp2b2NuUW9KUjY2MHo0dzl4c0ZoeXR2SzBWV1MwSklFOVpZSXR2?=
 =?utf-8?B?aEpzSFNGVDNlaWM4Y21taTBrcldQb2YzZklFTDlKMFJMd2hITGxsMnk2L0dm?=
 =?utf-8?B?Ymt0N2F6cHpwYmpWcnJPRndZa2lmR2hpYmxyR3IvL0Q1eUFZSExidEVEcjRI?=
 =?utf-8?B?WG00cmVJN2g2TXFWaERoWSt6aUVmM25VZm5TeGlEdG9kYlhOR2RUOUI2b3pj?=
 =?utf-8?B?bURpRHVkT0xuY1lyQVEvQm1vc1llSTNTUk1ITjFmZHlscXhHZUN2b1dYSlJX?=
 =?utf-8?B?ekE5TjIrOXFZemZ6RFhLd3BSNXMxYXhlcWcxeExQZUttdkNLN0JVdENxcGlw?=
 =?utf-8?B?dlNXMFg4UXB5c1YxK0dxNVpBdXZkK0xJRWp4K2lLUUpZNG5HRkY2QkU5T0F4?=
 =?utf-8?B?cVlTdEY2cTkxTHVkWWJzYVovbFBNc3I4bjVsMEExeUN1MlUwUmVSSXY2Rld0?=
 =?utf-8?B?Z3VOeitYNVJZMDNtZGRCcEFqNGdyeG41dVloZStZcTBWRVp2ZVVtbzhIZ3Rs?=
 =?utf-8?B?YnhMSlcwb3BwaE5aa3o3TXc0TEowQmd1dE1TRmc0ZDVOejlKRzRacUt2cFlP?=
 =?utf-8?B?NXZhUmFpczdjNE04Sm1KY2xIMkJQeGNWVnBIVkwrK1RpZ2JFU1ZMeVFFL2pa?=
 =?utf-8?B?OEwwNFBhYmxmWkpBY0dzcDhRcHpxWHBLYU8vNjJhYVFrWktpN3B4OGp5RG9j?=
 =?utf-8?B?SVF5RS81V09WNjJka2pkQnVjSzJNcmZxOEZRR2lEbHdZUVJQV2NvRStlUGlp?=
 =?utf-8?B?NFR0ejFFeTkrSWpVVFFlMTlZTTBOaWU1by94RjlTQW9KYUg3ZTF3Qzc3K1l2?=
 =?utf-8?B?R2ZJcER2cGQ5bEp6RW1UZWpySzdpdXlqeEJEbmI4MkpJallWOFg1NVg2Q0M2?=
 =?utf-8?B?WjIveXdDSDJReEhMc2xkNWVlSnl1VEpGUE5DT0dMSVpsaTFkYy9Jd3VOMUV3?=
 =?utf-8?B?WmgyZFBQQ3lmUm5qWjRDdmthUFZWM00yU3Vpd0xTejRvVllyYlNvWUNoUDUx?=
 =?utf-8?B?czA4ZEFubFhjL29QVzhtd0dzT3NiamVPRFJhMGlvWFgvNWRKeGY2cWF4NXlO?=
 =?utf-8?B?dEZtOVVsd3BpMVE5LzlQc0lDM08xQ1VHdTNkOU8wY3cybUNpcUZYbUl5cHNw?=
 =?utf-8?B?a2ZVUmtia3Ryak1VRmVNQVJwL3pRYTh3RGVIckhaK0VRN0MxU1pYdGlWWU11?=
 =?utf-8?B?L0Y3R2ZWMEhsaWt3bmNtdElPdHE0UnM4bGtJTkpYMU84bkdlL2cwcG1CR2VS?=
 =?utf-8?Q?iO+t7PPHPo+MYYH/97?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f901e21-3c2b-473b-6289-08dedbcf828e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 02:29:02.9604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OrcozU9kg7QUVHKR5NUa3NywiQufeN8cogHHwrBlpSTgLxy09vcd6ru3IyBR1eHU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6275
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6F830140007
X-Stat-Signature: mertu8b4xys5mpw1xohhb3wb9i3f8eys
X-HE-Tag: 1783391355-124558
X-HE-Meta: U2FsdGVkX1/OgpecO3gjskSsG0rdOZkIy/hNi+pRydNAJYkg9/iiav7b6LqmVffVwfUxRV/mVL97k4TkEYsZe+8AhY0VYPu+V6LviOCEwGSXLr0J2f6rT5fX/jFSixkLxRJ8tgzrzS/Xl/F1zbcCFdU4ZrERPYSue7hPUKm536GcwAiNeGVEzrO8UiQ1gFprfMOUxA7e6hzUR9xLlzspYIl9WSpNoU/x6VoKLLGh2gXRAIwKZArYAjvVQYyxXgTQMv1HEJEP8xb0kwXFPyfk9kbO/PyTigJTE3vBOUPC6C5ZzrpyP65qhIis4oyAu75wbw2t2o8asJuIVb0MZRt39qpULQ6qMiWHVXtzcnK/vAfT0bRoSDMBk/H4gpVb/Fxb6PkNQvXR1Oe9HTIhbHT3B+vILIzv6qRFThKcI70Se4E2vzvFyCgV1ACbwazEaV+HK6TeiPnccufRaTjgsI2xkl7U4MG9HIGzqFyFfE8EKv2TKR7piegP8eyIKOoWVkULv4nSn1XOY4n3TqARQsb09DZZD2w8j7dOWOaZbTKdD20Oa3kaSCM7jp/fa+HfaR6DwTym0jaTpkcHJZwy47nKFqeouJVkgBDCvxtSv0WWmFVLxL7z26sxGE3CDvecNV0iJnFU5Q3A0tdHzNHIDuAFX/FPhLj/bb/CI0en75eMSXtCneYmUOtNlhFkHmZn4yi7cwLOgIT9zGJusOOGElIrIIfyX4WzLkZpHhpsynDgE/synEiWEfyGH6zr6azHn3fU/SwQ2E6NFDQnXmHqNLVqyWRQn5FX1JUnNqzGFC8M92HpCndqqqjiazhcvqRO171nwvs9oYP5hgJU2fSgHZ4NY5qBEgUxMqnklgQoJ8QiMdWZEWZ8YKdjrr0AP3thAi93egfVIam6g/NMpATf8OPY6i8DCDhZCZc3BSJd9+p6SZ7qnTQjAel+QIStO6C1AeWUtuipL6Fw6zrHe4WjzZI
 T8Xqje84
 4x0AsgEUKuuzVKdIpVljhxNGK9aHAxfhNd3PJPhVQhLgKUp1Pbm5yicYBMWKH8QnWGco1tI3cXWsTZnrTo/DGXCo6mk4Xtyh0FtaISnsxkv5NsEHqrie6uAOW/zU5IHL0IYK9QteWKPVBF433IBxt46xqgEcHMQNHOkQGVVZ8kyTfAgyYSHul6GiHo+gfsrgE73u0cCTppO+RPAkjx3WMpgRF54F0lMRmEnaUvrgGXPszQxb9VGIY5CmxNPcj9RVryBnbTX2EtCMvx/41bVocctJaUKXyW6ZWmwri/O7J2mhyEJTw62pQgHT27HsiPzpvSSQMOfcRUDGEJigjl2JwcT/BlASty8LQWgXVgkCiZ49N+ud0mMHQUFkAK4dEyQAyNf2KDjZBYuIIF9seYNP0wdXgJYJwhpH+tp6sNmIqg2LMx6etkcL6IGUVKo5/ulE+QYqK/3So0+EjtCJJNis9GmXCTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 29, 2026 at 3:25 PM EDT, Lorenzo Stoakes wrote:
> Update __get_unmapped_area() to be parameterised by vma_flags_t rather th=
an
> vm_flags_t as part of the effort to move VMA flags from a system word to =
a
> bitmap.
>
> We cascade the changes up to arch_get_unmapped_area_topdown() and
> arch_get_unmapped_area(), where, for now, we use vma_flags_to_legacy() in
> order to propagate the VMA flags.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  fs/hugetlbfs/inode.c     |  3 ++-
>  include/linux/huge_mm.h  | 10 +++++-----
>  include/linux/mm.h       |  6 ++++--
>  include/linux/sched/mm.h | 12 ++++++------
>  mm/huge_memory.c         | 21 ++++++++++++---------
>  mm/mmap.c                | 27 ++++++++++++++-------------
>  6 files changed, 43 insertions(+), 36 deletions(-)
>
<snip>

> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index 95d0040df584..b301ec90740a 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -193,12 +193,12 @@ unsigned long mm_get_unmapped_area(struct file *fil=
p, unsigned long addr,
>  				   unsigned long len, unsigned long pgoff,
>  				   unsigned long flags);
> =20
> -unsigned long mm_get_unmapped_area_vmflags(struct file *filp,
> -					   unsigned long addr,
> -					   unsigned long len,
> -					   unsigned long pgoff,
> -					   unsigned long flags,
> -					   vm_flags_t vm_flags);
> +unsigned long mm_get_unmapped_area_vmaflags(struct file *filp,
> +					    unsigned long addr,
> +					    unsigned long len,
> +					    unsigned long pgoff,
> +					    unsigned long flags,
> +					    vma_flags_t vma_flags);

Want to use two-tab indentation while at it?

<snip>

> @@ -812,19 +811,20 @@ arch_get_unmapped_area_topdown(struct file *filp, u=
nsigned long addr,
>  }
>  #endif
> =20
> -unsigned long mm_get_unmapped_area_vmflags(struct file *filp, unsigned l=
ong addr,
> -					   unsigned long len, unsigned long pgoff,
> -					   unsigned long flags, vm_flags_t vm_flags)
> +unsigned long mm_get_unmapped_area_vmaflags(struct file *filp, unsigned =
long addr,
> +					    unsigned long len, unsigned long pgoff,
> +					    unsigned long flags, vma_flags_t vma_flags)

Ditto.

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


