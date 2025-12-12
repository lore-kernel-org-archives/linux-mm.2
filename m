Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 839D4D43367
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 03:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9845F6B0005; Thu, 11 Dec 2025 22:27:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934FD6B0006; Thu, 11 Dec 2025 22:27:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D4F66B0007; Thu, 11 Dec 2025 22:27:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62E956B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 22:27:49 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 104A15240A
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 03:27:49 +0000 (UTC)
X-FDA: 84209384658.21.CC2D79F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7F0EE16000E
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 03:27:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=f5tRWpql;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf08.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765510065; a=rsa-sha256;
	cv=fail;
	b=yte2l3QY6wclIMEz6l5LrG9CFB76ny/Fk93ZzFteP68pgk4fNZnxTmyilooI3coatBpYl2
	zrSnzd8Mv1Yw7DkjV4oGcm00Iq+wkkrjyf4KfC7QPmVey+H318JTqUC5Lk0C4h89ovifyM
	d7vGOyn9uvhF90jj72lPRjRTlbZvmpw=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=f5tRWpql;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf08.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765510065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+9ZzQ7WonMYWzEXOvrBV82wSK0IiysYAYWeBQCyEyoE=;
	b=Ge9B7EvefAdxrGXvi+AkcyVNxuVMMJ2V/XbJ7FgDiBnrlLFrkmapQu2rYt/Q0qtY9Ngh1o
	2DMGXSknsjq8oodQNd3oZsg9SSYCVTA9cKHrIQ58zFNNDUjknzOaCTRpldjYAdGyVT1QIN
	e+Eyywjq0Z9WU2pQgaFmg8N9blhhjN0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765510064; x=1797046064;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=q+eAiHhT0eQD7XU06gJO5j6pRGWAXuMeudJpcqcBchE=;
  b=f5tRWpqlh472W4BRAa8PB+laWUZuu+n4F0LR7eNwmQPrXKfMwL+nynp8
   awrPgLrxvlJUbEfRYYrtqMZIodGA397TqEJefSUmxQ+9Ll1lfH6EfGPuc
   k7MVFNDhaV5Kj7ho0jxd1nEYHxM5UI+bPmXFSDYK2B6TdN3KV4FypdUW+
   MjTrgeK+mAgMhvKxbNjQ6rpzrM62Pbust71F/pefmMIov/5cOTWBCfnjF
   N2gIZyMaE5Q7zj6sN7lH5luWkF12Y7StnENCKBV0T5PF0cfJ07OSQMOuH
   YZqZ7YMTHEQfZO/xFGnTMfl0U88V6Mu+T1t6wS1o+cwLbuf7pUUZwwnfr
   Q==;
X-CSE-ConnectionGUID: oG9f35fSR1GHuVTmEkc3/w==
X-CSE-MsgGUID: 90B0xXBJShuhQ1NtfPjXaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="92978185"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="92978185"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 19:27:43 -0800
X-CSE-ConnectionGUID: yHJZEEXCQs+pgynxzcwaSw==
X-CSE-MsgGUID: jr2mxgASSQ+6wYH7poXNsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="201444861"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 19:27:43 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 19:27:41 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 11 Dec 2025 19:27:41 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.47) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 19:27:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZCkcYGQn1t9kStBlVZ3wUGOzWjsVdnBpS4JNmNsjU1ucTavK4QXBCgvUncUKx1LYP7oXLLD8Q3nAWyn5NupuEDeFwBHUDftaCIJMGK3DHFiS23crV5kKMkuMRV0srWT7eSYXuqhPUTJeUi0/iqAxBrq3gY5EFjBEbd/1HqsOxWSyAlnjA2Yrrlic2WCG1qU6zCaZZF6BTe0+maZqr9bbwFK2MzSukQ8oSYBKWS1GvQrdldhFNtWw1HNa71+SwztySzEvpve7fONX0clKBaZtnbnzt1+Su1uR9OZJCuVwvAyPbP1EqoKVvRl9D8CRgf0+ta97W4r7XjwvKqMzhYV2YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UAhEipXVDl52V4/nRRc0z515EV3aYE4EzB+ddFlfZoM=;
 b=QkB0zmuinmeq1EXAVKcYsFDY+kpQaK265mlr2RUj+TxstteFwlgEWbOkvcQheEiIrjVun0w80IMoz3CWsNQmHZGmH0gGLGVp87vKyvMwy6i6LDVu5hB75pk78mzdu9ut/86uUPXJJ1AKznqUwThfFj4rb2jo0hTSZwOvbFp/i4DBFEZXiZcXqjrvEihAlJspkTeWrUqdj3F/gJxtEgUa0qVvWY+XxPwVznODhrtoNJRAXoCcavFMc/86r+CUaqPPFJsHu4NI2+JnMucXEroXUtbBtvz5ZcMgvcsrjz8UWdqqHriyJDUYsvt0EkYn2RcwB9jWBoHT/F/yQi+tODK/xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DM3PPFCB5A2AEE2.namprd11.prod.outlook.com (2603:10b6:f:fc00::f4e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.8; Fri, 12 Dec
 2025 03:27:38 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 03:27:38 +0000
Date: Fri, 12 Dec 2025 11:27:27 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Uladzislau Rezki <urezki@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <bhe@redhat.com>, Alexander Potapenko <glider@google.com>, "Andrey
 Ryabinin" <ryabinin.a.a@gmail.com>, Marco Elver <elver@google.com>, "Michal
 Hocko" <mhocko@kernel.org>, <linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linus:master] [mm/vmalloc]  9c47753167:
 stress-ng.bigheap.realloc_calls_per_sec 21.3% regression
Message-ID: <202512121138.986f6a6b-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0076.apcprd02.prod.outlook.com
 (2603:1096:4:90::16) To SJ2PR11MB8587.namprd11.prod.outlook.com
 (2603:10b6:a03:568::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DM3PPFCB5A2AEE2:EE_
X-MS-Office365-Filtering-Correlation-Id: d33c15a4-3cdf-49d5-4d17-08de392e6543
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?9syXsdB3blbTp/RN15KZpoPhRVLQBUo4hGXs2qSHQqmsSKM5R7sRkJQcVs?=
 =?iso-8859-1?Q?MAdN4DWsXczrOyvIEHO/lOd0eTraQZ0dGsXJabmcV5Qg+M9AD3Gv9QuWcS?=
 =?iso-8859-1?Q?6I9EUvauKnFzLdgPQWuQCxD4EemeD0g7i7KWS7Ngf5p/QwDuUF6rLpTbWI?=
 =?iso-8859-1?Q?aLNqXyaPpUaWMbDOvJLKiiezrGByOx1StQQLVDKett5nvOEGnpWXBqPasP?=
 =?iso-8859-1?Q?mu6cTRiXfnMLG2Yx8ihP8w0mxdV9Cpc1aP1kdz+iYhr94O7Kwv6eNm8Ado?=
 =?iso-8859-1?Q?B/GB7W7OG2pCeznncuKlChjcNbNVyIyJCNiqFZOYSo1cEO6FBW4Q2vAa8P?=
 =?iso-8859-1?Q?Z4Vx4fH4KguHpKG4GCaLKIXcHT/G3ZYrcmPud53nV8oMdJ1pAe7RfG/Pk7?=
 =?iso-8859-1?Q?0KN847v3wM/6IaZeAo16jWKMEmvBeDAYBzKMTlvHqhrUwKIsc3tasmix1e?=
 =?iso-8859-1?Q?5/78kAmWheozOn5G/NUZsdzJBYGWevRxWUopiKT+kmicnjXBn74PpjE2/N?=
 =?iso-8859-1?Q?UICFfh8UXPiHkwjBwmt7Ejzus+BGsfoRNGokNKYiLlH3DNoT+cI502lSMb?=
 =?iso-8859-1?Q?RhUpV2Q8mtGWCuJTsTFZM/1qFpkzPrt0hHMLV+wAbfITivPApWXtjmeJaW?=
 =?iso-8859-1?Q?vvbg1vUd4olSPjOkKncBo15hBLyFyMqKPLlkEA/ulL/vg+JcoOUIHz+7eW?=
 =?iso-8859-1?Q?A8ZNhYhdttRXl4/Bk1VuB3R+ZOx0jGZBbqxwLmu/5hJNNE92GWxE5AEDEj?=
 =?iso-8859-1?Q?COWg51wEvBc/ONSK86zXvZ21Jf+U5li9LqMQjTBq7pmgeNMZBjTWXH2rR3?=
 =?iso-8859-1?Q?kQIEmMbrVvAvLi355cOuzY8LwoLXVHfNq6aGCFGO2nzVM2TpBc8pdFGa4h?=
 =?iso-8859-1?Q?2GfQXj4gv3elw5Xd2OGTdAH6tshyis+lYNDFvEE4dS0C4erDecBpfExizY?=
 =?iso-8859-1?Q?r6U6i2ABGE8gJ396sGCMCo2kXKFIAfCq8cKM5BOFjLKHRawe285Lumc+6m?=
 =?iso-8859-1?Q?7lCWV+pvrSB1i/62bq8E7lyRepHOnDX/Njr2F3BYUvy7QakfIq7h+SxF8k?=
 =?iso-8859-1?Q?k5vOdoBIO993FsTQqd37ofw9eFGP2BN7lCGFNse6xf7VwwzqLOzJA56VYP?=
 =?iso-8859-1?Q?9/HIs9L+/id8HDGeWA7QNY/OA0OaxLyNrbRVJYR9ESRTPn/Gyk4H269f4s?=
 =?iso-8859-1?Q?Ejz9P8du5jxfH0S4R3qMPdVc0uKrwsHeQwJu2hXAMVYDr2xbRkvdG1/37g?=
 =?iso-8859-1?Q?DqDaITRVaGQj5POeaxMCI25oe7/gU35lEkXFgpLN1TpILTaUAGAO/85RyW?=
 =?iso-8859-1?Q?cJmjFQvAxvWPhDcP4IUVqwdj/dzj9fHzkgz+Gp9RFmwAYViMx9v5gme5F5?=
 =?iso-8859-1?Q?aGd8Ex3hBwOq424+AB3KlPrcLI43PFPiOLTpRNxV5jrfIb+dc7+vI3Jv8C?=
 =?iso-8859-1?Q?gtbyCRjiPc9WQFcdYEtRg4OcBsQ9HEJEEGbwQQvBlyWiJgwbKIOLnj3bJ0?=
 =?iso-8859-1?Q?yEHN2CNR9MSID/HMEUmV3IpRABkVh7zto6IstyGGNxVw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?FFf5K1FYXZpuoZv96VG6/V4v+vPK3DVCzLf7hM+WCHesNFkVQ3dZ4PmDrA?=
 =?iso-8859-1?Q?M/z4GjVQ7GLJP9EIexbwYmPNBdHYuT8zFnt80XRK99nZu5doSxe32LyDo7?=
 =?iso-8859-1?Q?7ZlbWOAw2FZbCYZ8cmPauCOiQPUUop/zUyxct6G0KeCzBx7sXwAKRUOWAk?=
 =?iso-8859-1?Q?Pt3iMzAJM/x6ZOzsvqeSIcoLbw7qk8KMFg/bYA3WQ73gLbgHc7B5z/mlkd?=
 =?iso-8859-1?Q?+A60t3fSypqvavJSG3V8eEPld1b/VlD4+tCrNuEq6YjJMp0b7tr4lSyG/n?=
 =?iso-8859-1?Q?emhjaJjJEUk60qqxzWza+I9IwcJFs5PBjhQc4MaHv/JQvW7BKCCTkeZGEa?=
 =?iso-8859-1?Q?mw0CQf8+nmiiytIMTZPQfWChkv4qW0aL6dtXR73BiJ0E43dzPD44Rnj9ga?=
 =?iso-8859-1?Q?lZWjrmBygLY0hYYaqmJHJ06MB7EAU69ovTEUPkLNqBbW0yXoHJ6Pb5ZBNo?=
 =?iso-8859-1?Q?XTv97OQlplgAb1EYJAP8KUIEbnMbLF2PqWnw4aH2eWHtEj5E84QvDK9cUK?=
 =?iso-8859-1?Q?YCzPhacqmqIp6I+DUsLHpTajcH6y77mecJDfky9b8OazAbzGi7d3Urrzjy?=
 =?iso-8859-1?Q?bhjlw+KKIYuM/ojJ4aEmb/QDF9dl+3fKS/42/V9hoHKgXBdFZVaGVoA6JH?=
 =?iso-8859-1?Q?OqbOKXnCef1HFOjh6DArmP46JHEtwFsMqgmEWOFF/SM5Z6jMhEPcw2PLNV?=
 =?iso-8859-1?Q?4CKOOjufoYshhVyz4WQmZiziqfOEQ722pxBobH+5LUOFJWFokehgmyzjaq?=
 =?iso-8859-1?Q?FAbJkJUuimPj47LYV1kaogGti/45NjB2pNZy61xUbVlsRq/yhTuXRjqcgu?=
 =?iso-8859-1?Q?3i+pDSHKK4hjoEiisVTO1SrmTNnnn7JJ6/kZpmlpd4zZQ8ldVUQNG/gEUY?=
 =?iso-8859-1?Q?Qz2ncftyUMaQGAaCODwMgvMY2Jy3z2OKeQ/w7hJlFKQU3RH+yuWMFgkwBv?=
 =?iso-8859-1?Q?AxUMcgK+kezGSfirtzzp+jy6lS+i2+MC1ct/Te0mNOLcm5xX6eT0ULOjY7?=
 =?iso-8859-1?Q?duv+1EnT11BLKH/oG/A0dglcW0FIJwQ2IR9YqdTpoUh3oIzscB3B/vn7f3?=
 =?iso-8859-1?Q?3pAzuAhT3FN7ytvZ/QHVT/Ia3I5XTgCxhNdY/nF/MorVgHUVV2R3JZtMJx?=
 =?iso-8859-1?Q?PK7a+GLyBQQlJ3fDnSQersEpS7J6qPGBgQjioYru/KRp1hfpKobFKvYOaa?=
 =?iso-8859-1?Q?DGrRgmRpiCD3cHyNIHBORXpao4pnmEXhu07ptmWGbn5YbwUuTLGt5I8bSx?=
 =?iso-8859-1?Q?DyrZcv8nlUwxclBItkkeuR694VnGYQLFMB2NjzDOBtzXMt5G1FBpO7vVsh?=
 =?iso-8859-1?Q?GDg11Q4mcl3P/tLP2TPHqDuijEjFzJONeaN/oyoSkf5q9FCV3zHm9LTFZp?=
 =?iso-8859-1?Q?Yy+tNsMra2YmTKWJH+YkHnFZClqtdrY+bvC3QJDTRrNgp09Ajb9DU2guUK?=
 =?iso-8859-1?Q?4lfr9yL7B6ZLD/68gyY2hxA0G7U3YoV6iGftBHzV5v15YtGPcdbeFK1pue?=
 =?iso-8859-1?Q?SCkQNTOUbWjnr8zclYw31EC5na6zOhnyE7bKX0Kqm66WQ43eAEnqK+qrVD?=
 =?iso-8859-1?Q?w4TgrYv2P7aR4YQdnkbABl8RgZ7rdDXjSck96IZe0Z0Q7aegYoaDKE4fYw?=
 =?iso-8859-1?Q?uEZNDwVF/4i7hUGyKHoxMKwH/8L5PCL9LUsursUDeV7yTgWR/1NO1VUw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d33c15a4-3cdf-49d5-4d17-08de392e6543
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 03:27:38.6442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UYQ6TGd0wsxpU/SABEjbWB7eH34tBe/Gn9gLAuG9Rd81m2q1DIOKQiom6HSP7pMj6DAQdRB50PYFv2uYY5IYmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFCB5A2AEE2
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 7F0EE16000E
X-Rspamd-Server: rspam03
X-Stat-Signature: cdah7jwqxmb44adynxzf6yaiiwnq94aa
X-Rspam-User: 
X-HE-Tag: 1765510064-686832
X-HE-Meta: U2FsdGVkX18PtGKSE1iH8xn1ulgdy/5cL3WlNdAXCDp9gXUzW+3DVlfBaq1BdUVCT7BZgwKF4rVLJY6F9rRpT8wrP2sL4P6LHIzXS9FwGk/3JM48QcpKTYrdzr24tXKnnB6aTSsysHW221cJ6dl5ngVPurAeOOsJoD9gP5lDruVwFgsBUs3uI4BdLsUn6uYM3UCrOKddAV4M4w3PY4Zc539C82o/ChOWKDhkaqCH1K0FYW9+tCgE/HnQdY95FBEwwt//eZkC46y5HIniIIcvQvSSUegwNO6Ve0FErEFht6Pe6Nly50hqwOH2IyN0EPZmVIrRTcwOAWKX69aRuInkyfH8qAnYqGOmrLktHYFAdfujOgwMT8tO4LbYUhb/HMtNI3S3NR0oM1vWzniVgNjr2M+rodPViOor5c6464lIsTNPZUbowJktR3ycgBQF41zPbLdUUwgw78sOvkYZWdbCyckkjb+j8PWDoL8XQ1wm8Bc9pMAgYBYhsYknGABr5u75Nkv7KnuNdLNMTGLZoWTBGieC7UsE2uTUcTHFZnLQzx6Aa4lM1eDkeJ/pjBC6FE+sK9uBlEDA2KItFciTJ09nsYx/PnOATf490RJN0pg2Ljn2JM1yzmkR7ND3KJMu/e9OnW9iMzjGizQVSbJXJMZROVvH1GBXhKpPYayNNSUGb+Zvzhggaca3cXlxh8FuhE4E7x/xZnu1pgZXhl2o2xCkfB4jlrzmNZHbnxiG5JuqGTe1NnfR4KLRz14HsS52+fMnUE2GUZOqS2ZcMaVawzcoZh9PA76IPzHusPHD4lJDZngXBPRnoPRKsZ/P1PPLOb0u6DZVm2t0haNHCa7ZeERCNqBPgIsh1Pn3ew85+/Iozn8tb7knNQunXa2u+CD2vRpAwbXqqWXxmBzajyG1KkZBxt9Pfttb3bJGsQVquJyHZ18bjfedc2xcNUZWrjFq2Ie6qSffLgZgvihY3d1697o
 KuX0QQiz
 bSYQkVakap5HMQelW+pULAHInl7ihPfYtp8y5oXTFp340NtCSvoec1T0Q9QMB8P6EtpeALhRyq7TnZxfj+D2OWR1veTbcvM48gPBuXKbs67/HqEXzYh4hIaBAiA0J611C/nVPIxmq1xRWQnrenuwDCC5yaMxXNPImkSwelkGfZawy0MNoXf5rbiz1bzIIrZGFaWt6CbnxmTRVPZBsrSz3vz9zKNsrZzRcaXW4CdEuPwyHjwvQpS2Ae4W/39VE+TCPcVveGgF5f221+m7w9RK6lx+V+IqxMdUu36lwTdXfTcW3Hu04uVOFEpNUkiEo93q4nleTC2CYTmZZZF2pYUGkunbvms4GDDj1orZ+7+atCi5flkmPQ+pVfTVzPVrr5C2SIJWLUa2A1BIjvDXisVOo3YG1AJic2sk4Kk93rQ6gcmjOnHOPlK+mkda6JzBq+v2a5LKnS8/Btg/wnDtJZjyQeIKLC9tKFd6Q6Se1Pr2iEjqbZbKwZIYk13ibUWpvudx3bzDTkQZw76U7dEZIN6J3fB7OSWydwici66oxZKuDpPvXo4Jh1j5jhw+SIyrt2Nwc7Bv1f+Fc0+PetF0WutW838J/U9tRcD6UDBMPiD5PqqZdXcM5DSKv70LXwJeM7JxT2Bb6YczYk/NiROjxKsERMP03q9O3VFY9ZhGcgRQfeS9S024nrNBl3z+FMVLX+zjJqaEWb+Arg+0/wFGwsDXbMWjhPY2JYBak2Cs5nJqSQDzUqKlhVAc7DJ5bzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 21.3% regression of stress-ng.bigheap.realloc_calls_per_sec on:


commit: 9c47753167a6a585d0305663c6912f042e131c2d ("mm/vmalloc: defer freeing partly initialized vm_struct")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[still regression on linus/master      c9b47175e9131118e6f221cc8fb81397d62e7c91]
[still regression on linux-next/master 008d3547aae5bc86fac3eda317489169c3fda112]

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 256 threads 2 sockets Intel(R) Xeon(R) 6767P  CPU @ 2.4GHz (Granite Rapids) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: bigheap
	cpufreq_governor: performance



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202512121138.986f6a6b-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251212/202512121138.986f6a6b-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-gnr-2sp3/bigheap/stress-ng/60s

commit: 
  86e968d8ca ("mm/vmalloc: support non-blocking GFP flags in alloc_vmap_area()")
  9c47753167 ("mm/vmalloc: defer freeing partly initialized vm_struct")

86e968d8ca6dc823 9c47753167a6a585d0305663c69 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    209109 ±  5%     -14.1%     179718 ±  6%  numa-meminfo.node0.PageTables
   1278595 ±  7%     -10.4%    1145748 ±  2%  sched_debug.cpu.max_idle_balance_cost.max
     33.90            -3.6%      32.67        turbostat.RAMWatt
 3.885e+08           -10.9%  3.463e+08        numa-numastat.node0.local_node
 3.886e+08           -10.8%  3.466e+08        numa-numastat.node0.numa_hit
 3.881e+08           -10.9%   3.46e+08        numa-numastat.node1.local_node
 3.883e+08           -10.9%  3.461e+08        numa-numastat.node1.numa_hit
 3.886e+08           -10.8%  3.466e+08        numa-vmstat.node0.numa_hit
 3.885e+08           -10.9%  3.463e+08        numa-vmstat.node0.numa_local
 3.883e+08           -10.9%  3.461e+08        numa-vmstat.node1.numa_hit
 3.881e+08           -10.9%   3.46e+08        numa-vmstat.node1.numa_local
  48320196           -10.9%   43072080        stress-ng.bigheap.ops
    785159            -9.8%     708390        stress-ng.bigheap.ops_per_sec
    879805           -21.3%     692805        stress-ng.bigheap.realloc_calls_per_sec
     72414            -3.3%      70043        stress-ng.time.involuntary_context_switches
 7.735e+08           -10.9%  6.895e+08        stress-ng.time.minor_page_faults
     15385            -1.0%      15224        stress-ng.time.system_time
    236.00           -10.5%     211.19 ±  2%  stress-ng.time.user_time
      0.32 ±  4%     +95.1%       0.63 ± 12%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     16.96 ± 41%   +5031.1%     870.26 ± 40%  perf-sched.sch_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.32 ±  4%     +95.1%       0.63 ± 12%  perf-sched.total_sch_delay.average.ms
     16.96 ± 41%   +5031.1%     870.26 ± 40%  perf-sched.total_sch_delay.max.ms
      4750 ±  4%     -12.2%       4169 ±  4%  perf-sched.total_wait_and_delay.max.ms
      4750 ±  4%     -12.2%       4169 ±  4%  perf-sched.total_wait_time.max.ms
      4750 ±  4%     -12.2%       4169 ±  4%  perf-sched.wait_and_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      4750 ±  4%     -12.2%       4169 ±  4%  perf-sched.wait_time.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
  29568942            -2.9%   28712561        proc-vmstat.nr_active_anon
  28797015            -2.8%   27991137        proc-vmstat.nr_anon_pages
     99294            -3.7%      95669        proc-vmstat.nr_page_table_pages
  29568950            -2.9%   28712562        proc-vmstat.nr_zone_active_anon
  7.77e+08           -10.9%  6.927e+08        proc-vmstat.numa_hit
 7.766e+08           -10.9%  6.923e+08        proc-vmstat.numa_local
 7.785e+08           -10.8%  6.941e+08        proc-vmstat.pgalloc_normal
 7.739e+08           -10.8%  6.899e+08        proc-vmstat.pgfault
 7.756e+08           -10.6%  6.931e+08        proc-vmstat.pgfree
      7.68            -3.8%       7.39        perf-stat.i.MPKI
 2.811e+10            -4.9%  2.672e+10        perf-stat.i.branch-instructions
      0.06            -0.0        0.05        perf-stat.i.branch-miss-rate%
  15424402           -14.3%   13220241        perf-stat.i.branch-misses
     80.75            -2.3       78.42        perf-stat.i.cache-miss-rate%
 1.037e+09           -11.0%  9.233e+08        perf-stat.i.cache-misses
 1.217e+09           -10.6%  1.088e+09        perf-stat.i.cache-references
      2817 ±  2%      -2.8%       2739        perf-stat.i.context-switches
      7.16            +5.1%       7.53        perf-stat.i.cpi
      1846 ±  5%     +30.6%       2410 ±  5%  perf-stat.i.cycles-between-cache-misses
 1.298e+11            -5.9%  1.222e+11        perf-stat.i.instructions
      0.14            -5.2%       0.13        perf-stat.i.ipc
    103.98            -9.7%      93.94        perf-stat.i.metric.K/sec
  13534286           -11.0%   12040965        perf-stat.i.minor-faults
  13534286           -11.0%   12040965        perf-stat.i.page-faults
      7.64            -5.3%       7.23        perf-stat.overall.MPKI
      0.05            -0.0        0.05        perf-stat.overall.branch-miss-rate%
      7.20            +5.3%       7.58        perf-stat.overall.cpi
    942.28           +11.2%       1047        perf-stat.overall.cycles-between-cache-misses
      0.14            -5.0%       0.13        perf-stat.overall.ipc
 2.678e+10            -4.1%  2.569e+10        perf-stat.ps.branch-instructions
  14559650           -13.3%   12627015        perf-stat.ps.branch-misses
 9.434e+08           -10.0%  8.491e+08        perf-stat.ps.cache-misses
 1.112e+09            -9.5%  1.006e+09        perf-stat.ps.cache-references
 1.235e+11            -4.9%  1.174e+11        perf-stat.ps.instructions
  12270397           -10.0%   11048367        perf-stat.ps.minor-faults
  12270398           -10.0%   11048367        perf-stat.ps.page-faults
 7.755e+12            -5.9%    7.3e+12        perf-stat.total.instructions
     42.85            -5.2       37.62        perf-profile.calltrace.cycles-pp.__munmap
     42.85            -5.2       37.62        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     42.85            -5.2       37.62        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
     42.85            -5.2       37.62        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     42.85            -5.2       37.62        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     42.85            -5.2       37.62        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
     42.85            -5.2       37.62        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
     42.85            -5.2       37.62        perf-profile.calltrace.cycles-pp.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
     42.85            -5.2       37.62        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
     41.78 ±  2%      -5.1       36.70        perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
     41.78 ±  2%      -5.1       36.70        perf-profile.calltrace.cycles-pp.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
     41.78 ±  2%      -5.1       36.70        perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas
     41.78 ±  2%      -5.1       36.70        perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes
     41.51 ±  2%      -5.1       36.45        perf-profile.calltrace.cycles-pp.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range.zap_pmd_range
     41.51 ±  2%      -5.1       36.45        perf-profile.calltrace.cycles-pp.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range.zap_pmd_range.unmap_page_range
     41.51 ±  2%      -5.1       36.45        perf-profile.calltrace.cycles-pp.tlb_flush_mmu.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas
     41.65            -5.1       36.60        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs.free_pages_and_swap_cache
     41.63            -5.1       36.58        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs
     41.65            -5.1       36.60        perf-profile.calltrace.cycles-pp.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages
     41.46 ±  2%      -5.0       36.41        perf-profile.calltrace.cycles-pp.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range
     40.84 ±  2%      -4.9       35.90        perf-profile.calltrace.cycles-pp.__page_cache_release.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_flush_mmu
      3.89 ±  4%      -2.4        1.53 ±  8%  perf-profile.calltrace.cycles-pp.si_meminfo.do_sysinfo.__do_sys_sysinfo.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.84 ±  4%      -2.4        1.49 ±  8%  perf-profile.calltrace.cycles-pp.nr_blockdev_pages.si_meminfo.do_sysinfo.__do_sys_sysinfo.do_syscall_64
      3.82 ±  4%      -2.3        1.47 ±  9%  perf-profile.calltrace.cycles-pp._raw_spin_lock.nr_blockdev_pages.si_meminfo.do_sysinfo.__do_sys_sysinfo
      3.74 ±  4%      -2.3        1.43 ±  9%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.nr_blockdev_pages.si_meminfo.do_sysinfo
      3.10 ±  2%      -0.6        2.45 ±  2%  perf-profile.calltrace.cycles-pp.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      1.90            -0.4        1.52        perf-profile.calltrace.cycles-pp.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      1.84            -0.4        1.48        perf-profile.calltrace.cycles-pp.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page.__handle_mm_fault
      1.80            -0.4        1.44        perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page
      1.70            -0.4        1.36        perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio
      1.43 ±  6%      -0.3        1.12 ±  2%  perf-profile.calltrace.cycles-pp.__pte_offset_map_lock.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      1.26 ±  4%      -0.3        0.98 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock.__pte_offset_map_lock.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      1.21            -0.3        0.95        perf-profile.calltrace.cycles-pp.prep_new_page.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof
      1.16 ±  8%      -0.3        0.90 ±  5%  perf-profile.calltrace.cycles-pp.__mem_cgroup_charge.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      1.17            -0.3        0.92        perf-profile.calltrace.cycles-pp.clear_page_erms.prep_new_page.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol
     44.15 ±  2%      +7.5       51.61 ±  2%  perf-profile.calltrace.cycles-pp.do_sysinfo.__do_sys_sysinfo.do_syscall_64.entry_SYSCALL_64_after_hwframe.sysinfo
     44.32 ±  2%      +7.5       51.79 ±  2%  perf-profile.calltrace.cycles-pp.sysinfo
     44.30 ±  2%      +7.5       51.77 ±  2%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.sysinfo
     44.30 ±  2%      +7.5       51.77 ±  2%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.sysinfo
     44.28 ±  2%      +7.5       51.75 ±  2%  perf-profile.calltrace.cycles-pp.__do_sys_sysinfo.do_syscall_64.entry_SYSCALL_64_after_hwframe.sysinfo
     40.25 ±  2%      +9.8       50.06 ±  2%  perf-profile.calltrace.cycles-pp.si_swapinfo.do_sysinfo.__do_sys_sysinfo.do_syscall_64.entry_SYSCALL_64_after_hwframe
     40.24 ±  2%      +9.8       50.06 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock.si_swapinfo.do_sysinfo.__do_sys_sysinfo.do_syscall_64
     40.08 ±  2%      +9.8       49.92 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.si_swapinfo.do_sysinfo.__do_sys_sysinfo
     44.76 ±  2%      -6.0       38.80 ±  4%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     44.44 ±  2%      -5.9       38.56 ±  4%  perf-profile.children.cycles-pp.folio_lruvec_lock_irqsave
     42.85            -5.2       37.62        perf-profile.children.cycles-pp.__munmap
     42.85            -5.2       37.62        perf-profile.children.cycles-pp.__vm_munmap
     42.85            -5.2       37.62        perf-profile.children.cycles-pp.__x64_sys_munmap
     42.88            -5.2       37.65        perf-profile.children.cycles-pp.do_vmi_align_munmap
     42.88            -5.2       37.65        perf-profile.children.cycles-pp.vms_clear_ptes
     42.88            -5.2       37.65        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
     42.86            -5.2       37.64        perf-profile.children.cycles-pp.do_vmi_munmap
     42.62            -5.2       37.40        perf-profile.children.cycles-pp.folios_put_refs
     42.60            -5.2       37.40        perf-profile.children.cycles-pp.__tlb_batch_free_encoded_pages
     42.60            -5.2       37.40        perf-profile.children.cycles-pp.free_pages_and_swap_cache
     41.93            -5.1       36.84        perf-profile.children.cycles-pp.__page_cache_release
     41.80 ±  2%      -5.1       36.72        perf-profile.children.cycles-pp.unmap_page_range
     41.80 ±  2%      -5.1       36.72        perf-profile.children.cycles-pp.unmap_vmas
     41.80 ±  2%      -5.1       36.72        perf-profile.children.cycles-pp.zap_pmd_range
     41.80 ±  2%      -5.1       36.72        perf-profile.children.cycles-pp.zap_pte_range
     41.51 ±  2%      -5.1       36.45        perf-profile.children.cycles-pp.tlb_flush_mmu
      3.89 ±  4%      -2.4        1.53 ±  8%  perf-profile.children.cycles-pp.si_meminfo
      3.84 ±  4%      -2.4        1.49 ±  8%  perf-profile.children.cycles-pp.nr_blockdev_pages
      3.11 ±  2%      -0.6        2.46 ±  2%  perf-profile.children.cycles-pp.alloc_anon_folio
      1.90            -0.4        1.52        perf-profile.children.cycles-pp.vma_alloc_folio_noprof
      1.89            -0.4        1.52        perf-profile.children.cycles-pp.alloc_pages_mpol
      1.84            -0.4        1.48        perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      1.73            -0.3        1.39        perf-profile.children.cycles-pp.get_page_from_freelist
      0.56 ± 72%      -0.3        0.22 ±108%  perf-profile.children.cycles-pp.get_mem_cgroup_from_mm
      1.45 ±  6%      -0.3        1.14 ±  3%  perf-profile.children.cycles-pp.__pte_offset_map_lock
      1.22            -0.3        0.96        perf-profile.children.cycles-pp.prep_new_page
      1.16 ±  7%      -0.3        0.90 ±  5%  perf-profile.children.cycles-pp.__mem_cgroup_charge
      1.19            -0.3        0.93        perf-profile.children.cycles-pp.clear_page_erms
      0.26 ±  8%      -0.1        0.16 ±  3%  perf-profile.children.cycles-pp.handle_internal_command
      0.26 ±  8%      -0.1        0.16 ±  3%  perf-profile.children.cycles-pp.main
      0.26 ±  8%      -0.1        0.16 ±  3%  perf-profile.children.cycles-pp.run_builtin
      0.44 ± 10%      -0.1        0.35 ±  6%  perf-profile.children.cycles-pp.free_unref_folios
      0.25 ±  9%      -0.1        0.16 ±  3%  perf-profile.children.cycles-pp.record__mmap_read_evlist
      0.40 ± 11%      -0.1        0.31 ±  6%  perf-profile.children.cycles-pp.free_frozen_page_commit
      0.24 ±  8%      -0.1        0.16 ±  4%  perf-profile.children.cycles-pp.perf_mmap__push
      0.38 ± 13%      -0.1        0.30 ±  7%  perf-profile.children.cycles-pp.free_pcppages_bulk
      0.55            -0.1        0.48        perf-profile.children.cycles-pp.sync_regs
      0.48 ±  4%      -0.1        0.42 ±  2%  perf-profile.children.cycles-pp.native_irq_return_iret
      0.37 ±  4%      -0.1        0.31 ±  3%  perf-profile.children.cycles-pp.rmqueue
      0.35 ±  4%      -0.1        0.30 ±  3%  perf-profile.children.cycles-pp.rmqueue_pcplist
      0.19 ±  6%      -0.0        0.14 ±  3%  perf-profile.children.cycles-pp.record__pushfn
      0.18 ±  7%      -0.0        0.13 ±  2%  perf-profile.children.cycles-pp.ksys_write
      0.17 ±  5%      -0.0        0.13 ±  3%  perf-profile.children.cycles-pp.vfs_write
      0.28 ±  5%      -0.0        0.24 ±  3%  perf-profile.children.cycles-pp.__rmqueue_pcplist
      0.31            -0.0        0.27        perf-profile.children.cycles-pp.lru_add
      0.16 ±  5%      -0.0        0.12 ±  3%  perf-profile.children.cycles-pp.shmem_file_write_iter
      0.24 ±  6%      -0.0        0.20 ±  5%  perf-profile.children.cycles-pp.rmqueue_bulk
      0.16 ±  4%      -0.0        0.12 ±  3%  perf-profile.children.cycles-pp.generic_perform_write
      0.24 ±  2%      -0.0        0.20        perf-profile.children.cycles-pp.lru_gen_add_folio
      0.21            -0.0        0.18        perf-profile.children.cycles-pp.lru_gen_del_folio
      0.25 ±  2%      -0.0        0.22        perf-profile.children.cycles-pp.zap_present_ptes
      0.14 ±  2%      -0.0        0.12 ±  3%  perf-profile.children.cycles-pp.lock_vma_under_rcu
      0.14 ±  3%      -0.0        0.12 ±  4%  perf-profile.children.cycles-pp.__mod_node_page_state
      0.13            -0.0        0.12 ±  4%  perf-profile.children.cycles-pp.__perf_sw_event
      0.06 ±  7%      -0.0        0.05        perf-profile.children.cycles-pp.___pte_offset_map
      0.09 ±  5%      -0.0        0.08        perf-profile.children.cycles-pp.__mem_cgroup_uncharge_folios
      0.08 ±  6%      -0.0        0.06 ±  6%  perf-profile.children.cycles-pp.vma_merge_extend
      0.11 ±  3%      -0.0        0.10        perf-profile.children.cycles-pp.__free_one_page
      0.07            -0.0        0.06        perf-profile.children.cycles-pp.error_entry
      0.06            -0.0        0.05        perf-profile.children.cycles-pp.__mod_zone_page_state
      0.11            -0.0        0.10        perf-profile.children.cycles-pp.___perf_sw_event
      0.10 ±  4%      +0.0        0.11 ±  4%  perf-profile.children.cycles-pp.sched_tick
      0.21 ±  3%      +0.0        0.24 ±  5%  perf-profile.children.cycles-pp.update_process_times
      0.22 ±  3%      +0.0        0.26 ±  7%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.30 ±  4%      +0.0        0.34 ±  6%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.29 ±  4%      +0.0        0.33 ±  6%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.39 ±  2%      +0.0        0.43 ±  2%  perf-profile.children.cycles-pp.mremap
      0.31 ±  4%      +0.0        0.36 ±  5%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.34 ±  3%      +0.0        0.39 ±  5%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.28 ±  3%      +0.1        0.34 ±  2%  perf-profile.children.cycles-pp.__do_sys_mremap
      0.28 ±  2%      +0.1        0.34 ±  3%  perf-profile.children.cycles-pp.do_mremap
      0.11 ±  4%      +0.1        0.17 ±  2%  perf-profile.children.cycles-pp.expand_vma
      0.00            +0.1        0.08        perf-profile.children.cycles-pp.__vm_enough_memory
      0.00            +0.1        0.09 ±  5%  perf-profile.children.cycles-pp.vrm_calc_charge
      0.04 ±141%      +0.1        0.13 ± 16%  perf-profile.children.cycles-pp.add_callchain_ip
      0.04 ±142%      +0.1        0.14 ± 17%  perf-profile.children.cycles-pp.thread__resolve_callchain_sample
      0.04 ±142%      +0.1        0.17 ± 15%  perf-profile.children.cycles-pp.__thread__resolve_callchain
      0.04 ±142%      +0.1        0.18 ± 15%  perf-profile.children.cycles-pp.sample__for_each_callchain_node
      0.05 ±141%      +0.1        0.18 ± 14%  perf-profile.children.cycles-pp.build_id__mark_dso_hit
      0.05 ±141%      +0.1        0.19 ± 14%  perf-profile.children.cycles-pp.perf_session__deliver_event
      0.05 ±141%      +0.1        0.20 ± 14%  perf-profile.children.cycles-pp.__ordered_events__flush
      0.05 ±141%      +0.1        0.20 ± 33%  perf-profile.children.cycles-pp.perf_session__process_events
      0.05 ±141%      +0.1        0.20 ± 33%  perf-profile.children.cycles-pp.record__finish_output
     88.59            +1.5       90.13        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     45.34 ±  2%      +7.2       52.54 ±  2%  perf-profile.children.cycles-pp._raw_spin_lock
     44.15 ±  2%      +7.5       51.61 ±  2%  perf-profile.children.cycles-pp.do_sysinfo
     44.33 ±  2%      +7.5       51.80 ±  2%  perf-profile.children.cycles-pp.sysinfo
     44.28 ±  2%      +7.5       51.75 ±  2%  perf-profile.children.cycles-pp.__do_sys_sysinfo
     40.25 ±  2%      +9.8       50.07 ±  2%  perf-profile.children.cycles-pp.si_swapinfo
      0.55 ± 74%      -0.3        0.22 ±107%  perf-profile.self.cycles-pp.get_mem_cgroup_from_mm
      1.50 ±  4%      -0.3        1.17        perf-profile.self.cycles-pp._raw_spin_lock
      1.18            -0.3        0.92        perf-profile.self.cycles-pp.clear_page_erms
      2.01            -0.2        1.86 ±  3%  perf-profile.self.cycles-pp.stress_bigheap_child
      0.55            -0.1        0.48        perf-profile.self.cycles-pp.sync_regs
      0.48 ±  4%      -0.1        0.42 ±  2%  perf-profile.self.cycles-pp.native_irq_return_iret
      0.14 ±  3%      -0.0        0.12 ±  4%  perf-profile.self.cycles-pp.get_page_from_freelist
      0.14 ±  8%      -0.0        0.12 ±  3%  perf-profile.self.cycles-pp.do_anonymous_page
      0.14 ±  2%      -0.0        0.12 ±  3%  perf-profile.self.cycles-pp.rmqueue_bulk
      0.14            -0.0        0.12        perf-profile.self.cycles-pp.lru_gen_del_folio
      0.11 ±  3%      -0.0        0.09 ±  4%  perf-profile.self.cycles-pp.__handle_mm_fault
      0.15 ±  2%      -0.0        0.13        perf-profile.self.cycles-pp.lru_gen_add_folio
      0.12 ±  3%      -0.0        0.10 ±  3%  perf-profile.self.cycles-pp.zap_present_ptes
      0.12 ±  4%      -0.0        0.11        perf-profile.self.cycles-pp.__mod_node_page_state
      0.07 ±  6%      -0.0        0.06        perf-profile.self.cycles-pp.lock_vma_under_rcu
      0.10            -0.0        0.09 ±  4%  perf-profile.self.cycles-pp.__free_one_page
      0.11 ±  3%      -0.0        0.10        perf-profile.self.cycles-pp.folios_put_refs
      0.07            -0.0        0.06        perf-profile.self.cycles-pp.___perf_sw_event
      0.07            -0.0        0.06        perf-profile.self.cycles-pp.do_user_addr_fault
      0.07            -0.0        0.06        perf-profile.self.cycles-pp.lru_add
      0.07            -0.0        0.06        perf-profile.self.cycles-pp.mas_walk
      0.08            -0.0        0.07        perf-profile.self.cycles-pp.__alloc_frozen_pages_noprof
      0.06            -0.0        0.05        perf-profile.self.cycles-pp.handle_mm_fault
      0.06            -0.0        0.05        perf-profile.self.cycles-pp.page_counter_uncharge
      0.00            +0.1        0.08        perf-profile.self.cycles-pp.__vm_enough_memory
     88.36            +1.5       89.85        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


