Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F7EFCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 05:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7F6C8E0003; Mon, 17 Nov 2025 00:47:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A573F8E0002; Mon, 17 Nov 2025 00:47:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91E928E0003; Mon, 17 Nov 2025 00:47:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 822338E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 00:47:53 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DF8ACC023E
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 05:47:52 +0000 (UTC)
X-FDA: 84119017584.24.EE637B1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf27.hostedemail.com (Postfix) with ESMTP id ABCDF40009
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 05:47:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WDNyX0w0;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763358469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1SPnBOGy9qWys8N4IFZsLqJvNqagUJzxTRhfyZmvf4w=;
	b=qqE1LvCdgf61XZbl9TNLzWnt/ycXD2t1l0PS/LRV9j0Se3LtSkoC9HnDM4c40GRXnGo19N
	s1zote7zJlscKcAp70UfN7WA5nLqTSZiGRS1brUGyGiwmWNsqW+3Wr0i/QRS4yPnjeE/OL
	GMCjIxrsg5JaSwDjMAP3SYRnG42/Y9c=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763358469; a=rsa-sha256;
	cv=pass;
	b=5z+d03u5Siz/9MgCmKyrjTcFr5vArJxKWYEt6Ymf8eQNlBTIayKlF7VT9PzQOURmbGdQDN
	OY3pkwhSCMj2cCkmLQYhjkDxtgzmZZupyUUQoJZLO4wtkWZLlTUNqa7ctvzg2uWaCRhNqX
	CHjn4rkbqLQ1Piqb+7NIWcF53zZNStY=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WDNyX0w0;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763358469; x=1794894469;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=slLgFNRHAPbToqwXiynYDftNCrg3Jji/AMtk38eAwn0=;
  b=WDNyX0w04hFVixNuGq83dbRgbLwC7hqBxZE64HZzUW6rJ7fVMeNSzMHF
   zl9dOSdvOT/fYuyR4EKLmxFDsyWAR7cLvqnUOMXM2YF+UHjYwasEh6//x
   w5SlIc+nBx92HsV01MInjl3jyTO6KrSvz0A0/dGjY7hTmczfC0+R6NKK9
   PjTIkB+/9DodZkXfk8xkjXHSGAH8KqMdk1lY8rj2W6OQ9Y4O+/nqUeRs7
   f5TNMMg7nt+AlQM+Hq8UWjwA4v40WXGGoOilI7Q9QRCH9gbchhS8V7oBN
   ge+vFaDX6uC8QdFNTYRGuGzKu4sNJZ1XkZ0Y1fLRzzbWq+rOyF/S/6s76
   A==;
X-CSE-ConnectionGUID: gFlxvBUpRt2CM2HCsFvOpA==
X-CSE-MsgGUID: f5ZGo+0uTJ2cnEtWuiHaGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82738525"
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="82738525"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 21:47:47 -0800
X-CSE-ConnectionGUID: v1iepJzAQwqZOo0ALtQJ/g==
X-CSE-MsgGUID: ri1KHe+6S+uKg/y7caAzwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="190154532"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 21:47:46 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 16 Nov 2025 21:47:45 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 16 Nov 2025 21:47:45 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.38) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 16 Nov 2025 21:47:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mya1u1tDsxnRrzBgvyNVd2042IN30LsaqBPem5crK2tA5RrECI52ILsMfecYhcvI4fgk5TdOY9vEJgIfnM/fK7QYTnjTjCiq8k9clDf5hwB1EOeQL5tP4B3LZUFdCI/upkFYLiE8vgWTRLnZszeCuG6/9WCDSIR1B+L91K04Mw6FbHIatMC2TnB8hBApyosQ4OHiEtCjMtaQuF0lkmeRK8ivguXODLnV+Iyhk9+HzhNdF5L3zhYT9rjNDUqjZfNin718WbajPk4ZPqGFvRCCZYW3CNLvhXsavTtFP+4vO6t0jgw5KZk7gv4HwW5vSXgHBKtcv3ON7mobApy3jrecaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1SPnBOGy9qWys8N4IFZsLqJvNqagUJzxTRhfyZmvf4w=;
 b=y32U1O2650o4Puo1qlyNcTjEIIQRDMUswPHCsKD/IRqFUZAHnaYAJrr8EFmobaazYh5awi/6W8fRAde2GKtuvUkqNIjWeQhJxCbsebI9XujC+3gFtK7cNvAD8hUna5oqmvJ1d9rVfJ9aUezy6ntFVdJSZYCWKDmWU194psQ5LKL+k8ew2GNtkfFjDMdOhx5D/ivFA2qnRh68AV8yXcqnORnWYG2jY5kHExTS0j1QEUpjKZ//SafwkVnRhVHLXDGmk42KyqVRYj/1Pi2I+pUQAsJYSR3PkbvUAlEdZqcHdhxu5n5S8YDSieGdQ6piPH8s7WLewrQ7znhYoSXMxz8PEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by PH7PR11MB6649.namprd11.prod.outlook.com (2603:10b6:510:1a7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Mon, 17 Nov
 2025 05:47:42 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::1871:ff24:a49e:2bbb]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::1871:ff24:a49e:2bbb%4]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 05:47:42 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "senozhatsky@chromium.org"
	<senozhatsky@chromium.org>, "sj@kernel.org" <sj@kernel.org>,
	"kasong@tencent.com" <kasong@tencent.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v13 13/22] crypto: iaa - IAA Batching for parallel
 compressions/decompressions.
Thread-Topic: [PATCH v13 13/22] crypto: iaa - IAA Batching for parallel
 compressions/decompressions.
Thread-Index: AQHcTWszo/WY4LO3fkO1jxkjgF2nErTx/98AgAO1Y2CAAI/5gIAAHUdg
Date: Mon, 17 Nov 2025 05:47:41 +0000
Message-ID: <SJ2PR11MB8472311D0C7B0B7CAD11B601C9C9A@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-14-kanchana.p.sridhar@intel.com>
 <aRb9fGDUhgRASTmM@gondor.apana.org.au>
 <SJ2PR11MB8472EB3D482C1455BD5A8EFFC9C8A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aRqSqQxR4eHzvb2g@gondor.apana.org.au>
In-Reply-To: <aRqSqQxR4eHzvb2g@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|PH7PR11MB6649:EE_
x-ms-office365-filtering-correlation-id: aed0951b-19b5-49c3-3ca0-08de259cd31e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?NrfA+DBtqO7nN2SrSLl4RCYR1fmFEVFI15cg8U+yhZa7nVxU5QFndahM0k?=
 =?iso-8859-1?Q?9ra3H8hoIyfYblVrXyS+3nyh3M3Fbuv0W746M/BY6IOPCc1pD/M0NbCERI?=
 =?iso-8859-1?Q?KsJBUOX+9o0cGOdkDUF6nDUq/r+In3IIBgGxOWDAt3SmFiqpFTcKtQZyFk?=
 =?iso-8859-1?Q?9+9saCifICsjguLnCjNSvHBWknZY6mcezVgT96D+cj9EKbkUj6pmWdT50k?=
 =?iso-8859-1?Q?n/kAk4+pUAdvVDh7Mam9lwfl+9xq+X/0i9QsyMYC9X4L/M9rR6MMKCu0BL?=
 =?iso-8859-1?Q?ZXKjcEl1IMsDsHhSXDoJZ7JwgaMU4MSkLH59hDWR+9UPn87IU8JKTMsOgs?=
 =?iso-8859-1?Q?xAyXpaHMiuQWXgLCjF0uCV2l5136Ofg6QGjuPk2bNASsfEI6tBgTHfEvBt?=
 =?iso-8859-1?Q?bYvBoejZYT8vLavTB/C4afm2JPSsK0ccKQhxyXd0PTEeOtOHetu/TWeMry?=
 =?iso-8859-1?Q?E2bnCvfIX/1N2LNPiOuqjo4lAD+vHHlWJ5Ovmqex/GOk7tQv0QiOYs6IzZ?=
 =?iso-8859-1?Q?uX5heu4iuDu8FYaQa3m7A1iAtVMDdQAPKbPXWSqImRT5opEdgLcF1Sy0OL?=
 =?iso-8859-1?Q?TITUT9Aw20+k32fiF/MMeXndjUwDWswygAQwoNeuX/IogdMCZ+f2C7gd0M?=
 =?iso-8859-1?Q?Rr4ygeXpFDFIXP7ofDgEuZ3zdr/TtjY8DdcumbZkEiNmPKABiZT7IC/rS9?=
 =?iso-8859-1?Q?/DCr2TYckRkJRbU95NMWojE/zk1EKK0tHMq6dHfq8rAypJY+uKg3Y86iQ5?=
 =?iso-8859-1?Q?CiMLlvYiBv5rosbTQd7Am0/FELQFQLYJ6YMrnh+rFOcv9nJ5ZqHZCAzyh7?=
 =?iso-8859-1?Q?lNxgirTSlB3TOGsDxGexGygD3boUSrVBMjHM9LzheSzwZrJg50YAzUTNYx?=
 =?iso-8859-1?Q?ECUFOmQB2JcOyGspWZxp/ISEcTPbY8pYc0NDSkfbY25rnmO9FYVzLgWYoK?=
 =?iso-8859-1?Q?uprS93zyu/y7fA1YFTHqfOdIUNlF4oI7oQQe90ViAE3HyXccqPaiL0Okxb?=
 =?iso-8859-1?Q?GYk/5f+G793/E/1qiQ30v6Qrusi78A9malNXSIPxm5FNletb5uX0n8vh9X?=
 =?iso-8859-1?Q?+owqbW0cPuMNolOFv/JUthhBbEhFHX+sRJ11j2apQZ4znx2GFGqwjDNGut?=
 =?iso-8859-1?Q?uLS4VAqb/nMiL8vN0oYEbfVKU4PB/Yt6xMxkFY/B79BUozLCboYbYHpWEn?=
 =?iso-8859-1?Q?7dYtj01jgqLQJ6E6gAi8nNwnKo8KEFvo91GMiN3zZRQkobHUc74lLqtIYl?=
 =?iso-8859-1?Q?oWII3A5LvhaD21u/EdNVlT+lKVuW5oSjGBmr5TfCoTI5zsbrXnMV+0/Qqd?=
 =?iso-8859-1?Q?8e6xG505XYR7qwOG+aJg0pg1Tm6J4o5VGUeZOYdnYHK+J2EhgDZaaUZulR?=
 =?iso-8859-1?Q?u7ke6GhPPGUvcxldRQ2P+9YxfOIT6jyNws7zh7g9aHZbD3B6pB5QLB470y?=
 =?iso-8859-1?Q?imcBUIwUDsu6t8BCEclnk3zNPZq9PUQp5nOm3XR9Zs/kNOdBAFanfhpnig?=
 =?iso-8859-1?Q?q21xPKt8aAjp/R9FuoVzVOXCXvDr7dfQRlgsuiX/9ZSw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?lGvOEw/qo/jr2maIPoEq4qXgPr65etfzSlo1KQXy4qerIaTgRqgMoRa7g1?=
 =?iso-8859-1?Q?mUopaa9PmBZ4PEykONuWYmxwDFEz5Hv3c0Nn1N/fKasmx1xGBnQFGuaYlc?=
 =?iso-8859-1?Q?sprZj4mPWn5U25VF0hmTwKHHLld0g4UJ/k05jqgKiNHWW8fbA3/Saf6Br4?=
 =?iso-8859-1?Q?d+sdwP4pWeA82mN8BurYABYHgO565yNvq+JkD0lIDzcmz/TUc8niSG1Rxh?=
 =?iso-8859-1?Q?Esf/Tef6/EuZUPB4bA5CtgB/Ih29eP41Yl6UZ3xhjYuslSnFo68KHWR3mX?=
 =?iso-8859-1?Q?ILAdlM6kkXlHOepEZwx5JecYhIIBv9CYE0xdraD/BY6RdBn8kryR/+bTX5?=
 =?iso-8859-1?Q?5dPp6faNw+DHGczpxVmOfcPgyjr3Di9/Zrd0xZQydV061I1LP3bjZqYFjB?=
 =?iso-8859-1?Q?bBmjKdtOLFSTC+4vR8OzrqUVyejuH4wLJ76cDTDW2CrMu0UX0fuqTZGf3S?=
 =?iso-8859-1?Q?tWlnAIJnCh+09Q/ktkcEBU8JKefW+spMs4VlPMJZ/KLnwMn6sNjG78E/9q?=
 =?iso-8859-1?Q?QzEH18vK6LOspbWaiV5bVCxer3sOD90lnr+dzxf2mSI16JRihLxl8K8c+6?=
 =?iso-8859-1?Q?m6ho6dTrD8MAWxch9Veu0Hvfw2yP9+mMqD/9jEuBtMBaKtjgsXbVNg5Mns?=
 =?iso-8859-1?Q?wmU/DW9atTrn+C1LDuEy8WOUBNR5TmpqB43LV4/FiEwkiMHwpTiuIQ5h+P?=
 =?iso-8859-1?Q?XjcGNYhQ5W+JnCNEym0P82q8dMoi8fRlDCe1Wwmp37WYzTouh7AtOCb60K?=
 =?iso-8859-1?Q?cjjsev1PDn4uL3FuP1DxkcFpln6As8l/skiyhVbiM2eOkD5eNrqhgjPZ0n?=
 =?iso-8859-1?Q?Oxj+7B6sj5XIPtfRky+xgHgiOYdD5rQIMiQphnnDCRpgJECI/DM1qMMgqu?=
 =?iso-8859-1?Q?f5zyNT+IDD9VNgSrjuRuIi7Ukl+uUUMho5VgSBq1mqhqEiAOGux6DIM3sz?=
 =?iso-8859-1?Q?d/H68h0pw9WMsWaR23AzO6g050RctE9R67pq0vgoGzO1B5aW4A8AQrq3Pj?=
 =?iso-8859-1?Q?DMSaqtn8T5QLCa5XUt/Yl2o15fsj6LU6qxujl6lb0KDrQuabyDlRiYtY4H?=
 =?iso-8859-1?Q?P4k1q3s9hzqSURTDc52/kvNFQRpUepy+fMUj1J7d1QYhdv88OUywdA5Del?=
 =?iso-8859-1?Q?F+Jwtk3MGi8sM7MOwESfBxqqGjbpXOzw9Nious+t9uWhjciL/auB27Voz8?=
 =?iso-8859-1?Q?cENvIboh+/YW8R+IoaUBUT70b020dXSPYAHX3x2EbiZsFlJ3Yo1i2mY7uM?=
 =?iso-8859-1?Q?AYABpuSotGa+C1P27jlMg1VwpCn63viGfyPjwmg0Gxr6znso3w84DEPW6D?=
 =?iso-8859-1?Q?ULDq3MhhZmctYTNuNpf/xlpTT6JVs+ZJKuE5Xuvag5/lDSf/qe/ezCqjXr?=
 =?iso-8859-1?Q?cy4WXpsCflVvM0WJ98koCT8wJ9I/NpE9oHp3Gt+RZ0Do5JxBvcsrifOMmm?=
 =?iso-8859-1?Q?3Pdgra4lSXjfoo+CqlUal5MHpNX6CwZolW9DUd15v8HGIL55c0SzZrJ3Ca?=
 =?iso-8859-1?Q?UWn494E9NiOq3NpQTJFcPdcEU3ivKm/m0vNwSLJwX54Hjlhi/4lQ0kdaOZ?=
 =?iso-8859-1?Q?8HtB53UokblPHq9tt1pdFIp0vrMn3X5i8kyStKASbj13QLAg97i828H3UN?=
 =?iso-8859-1?Q?3lixMFWWaquFFJ65/pLb3Fdfl3I8/iCaXZIQ8G4uI5TTh+Adt0hcrXfA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aed0951b-19b5-49c3-3ca0-08de259cd31e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2025 05:47:42.0070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eDdiGtkqwQ+b9J+OOdRuoKRGn4xeruX8cspPzyg6/6W8ZRRLNxF+p+v3DAkd/IhY4C6earZuNJ2xwqn8kNKYSjDxX7SG+OvUFXh+QotVXf8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6649
X-OriginatorOrg: intel.com
X-Stat-Signature: ido9g1pq5r1ynzstituifrtdc34dttzr
X-Rspam-User: 
X-Rspamd-Queue-Id: ABCDF40009
X-Rspamd-Server: rspam10
X-HE-Tag: 1763358468-888189
X-HE-Meta: U2FsdGVkX18BK1XiFX7sqJwH/D0eMC7X6oPsvqxxuonplv66az1f9by6q2tv2/pP4m8zCifWqCCvxiK6etdu0R8MUTR5SrJNsql4qghyT9JXqYEN5yXqY7JX1qnOilkc1O1b3S8vuWj0WL99yPncLAqkauPmOAqlVRNh/qDexFW6kkptJBhx6Jb9AQm2QOy71w2Ve7aU98+K/eivcChx8dRCuyWRpKpausY5DlJ/DSeUUGR0ujdqZe1VDQE82HilT1GzG8tKLV5XXfbBmmbmKb6nPkGVvM0C8+SQDYEGWocOtyU5JhSPmSbYIkrXhhQq2kLCW/YJ1LNSz+Dly5WhIVyZXkscUYLRRB9Ll+Yz6ReU7ldJ1NAHfk04qbi4cBf/UbuSmIFFJYh0sUdmUS91r4FrZbdkBnNJVDlQLv6Xb46B2+aw/h4/t+5u1C/k7sk+Z4mBidKTeSOskAnwYhvarahtm6QCq3wRqzNsrZFPCwP5nHVFn5uASvIrwaoG+PDHVx+3vIw5B5cvHXYWk0G3LM1eFAp38/AuaLVp8bCeE2Los7q5Tl7MFZsv+4tT0olj0Iz9Ch9bLmzTWhKY9qXlEZxPrR0XtPidNBDIEWDJ6eOZy+AHRHkISYK2ivHrn0TslqGOa0FdnYa1taCInIsaC18LOn9s5NrImDv3Tg9zXXNiJBVNi7TdeliUSKe3KlHhg/dyjH2s/sSaxOUV8QyW3G4Fb8yDgC+Iah2joCJlOcILbupEO6rw3q5OYdzD8sYFlSB5oCN3+piHauLUzGNcE/qG0U+ey+Vm1yWpgJ/Ke0h++tujewA4WLNARS6B+Ko+hfGoaWr8q/xrCMLD4PxsjvdzAnoL41uvhPU8lw1a4x3gauX/aL/o5O3SiNdiFX75SY5fRdvwa5VU7aAZQR72HJ5V2vCWxmwYGWsjJIr82EDRw1cOHABWnz/3dC+ESqxxWrG/7guBWJpfI+96u0L
 QlzaYqlF
 pGoHukBkK3b2JaA3GCW6vDO+PO22XHwVUVqPYGBC02ZUwJHw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Sunday, November 16, 2025 7:13 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; yosry.ahmed@linux.dev; nphamcs@gmail.com;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.com>;
> Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v13 13/22] crypto: iaa - IAA Batching for parallel
> compressions/decompressions.
>=20
> On Sun, Nov 16, 2025 at 06:53:08PM +0000, Sridhar, Kanchana P wrote:
> >
> > This is a simple/low-overhead implementation that tries to avail of
> > hardware parallelism by launching multiple compress/decompress jobs
> > to the accelerator. Each job runs independently of the other from a
> > driver perspective. For e.g., no assumptions are made in the driver
> > about submission order vis-=E0-vis completion order. Completions can
> > occur asynchronously.
> >
> > The polling is intended for exactly the purpose you mention, namely,
> > to know when all the sub-requests are complete and to set the sg->lengt=
h
> > as each sub-request completes. Please let me know if I understood your
> > question correctly.
>=20
> The issue here is that this code is being plugged into the acomp
> API, but it isn't implementing the acomp API correctly.  The acomp
> API is supposed to be asynchronous and you should return immediately
> here and then invoke the callback when every sub-request is complete.
>=20
> I know that the ultimate user is synchronous, but still the driver
> needs to implement the acomp API correctly.

Thanks Herbert, for this explanation. I think the main problem to solve
is how to signal the callback with the "err" of all sub-requests, noting
which of them are still -EINPROGRESS, vs. having completed with
error/success, set the sg->lengths, etc. I am wondering how this can
be done since I have already returned after submitting the requests..

It seems there needs to be a polling mechanism after returning from
crypto_acomp_compress() once I have submitted the sub-requests.
This polling would ultimately call acomp_request_complete() after all
sub-requests have completed. Do you have any suggestions on how
this can be accomplished?

Thanks,
Kanchana


>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

