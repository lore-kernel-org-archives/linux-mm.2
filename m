Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EA1FCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 23:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B6BF8E0005; Mon, 17 Nov 2025 18:17:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 567328E0002; Mon, 17 Nov 2025 18:17:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42F6F8E0005; Mon, 17 Nov 2025 18:17:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6DA8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:17:01 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4249140307
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:17:00 +0000 (UTC)
X-FDA: 84121661400.23.8FB223E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf02.hostedemail.com (Postfix) with ESMTP id B0BB480018
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:16:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Vy9WWRWe;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of adam.c.preble@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=adam.c.preble@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763421417; a=rsa-sha256;
	cv=pass;
	b=aX20QXtAhf1ezg2Kk7X+ejcEANGd5cno5xeQ/8F4TmiuS6OWwJZAkIyHPAtW3VN8lPB00g
	pt10LBLKKZC/DXPcsJebGt3+PBNnSJW7TgBfaGTaI62czJQ+jQONN8SHn+LmjMjnlCxCFK
	VgLGRhszLL070YM0RA9SWGk4/OTHhB0=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Vy9WWRWe;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of adam.c.preble@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=adam.c.preble@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763421417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/7F4orQQuKTOUnNHUikViTnHPVOCs2MJPqsrHru5ZjU=;
	b=pXyKGjTYKeTuyEOOPgjPD6AAIQxl7o/yT8vLC5ZTcQpWnmabYNnyMgR70eunTf/VqS8DjS
	CILV5uem3ppdHn4XUjYltPmh0dAo+lVCRh/7O1uyEWu9oBLVXYawIeZyScD4QyyYyIuRUv
	ZExUEqWkAnr8rZZkR/Cx7erQMqukQZo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763421417; x=1794957417;
  h=from:to:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=di/4b/CaJJCunAnWDYCWQgTFu46hNMpCkrvFIbsdFz0=;
  b=Vy9WWRWeulGekM6v67LUTasWMn4Ius13scByrf9nAK12JfMZ/6Ss7l68
   e5ue1MaS5APeAKOxdI0/ITSfB4oCys4vK4rn0gqyJvgPyGkH6KcEJH3GD
   rU4tizjA2XgrU+Yi8aSN5vwXKzgacz0IWC90j+SAqFVr2HoDftid+M0+l
   y78mmt/xFXA6FfS+uFE1AyCMSnJ4urLibeMitXMEfjiNRWnndpyoSuXyn
   JSZPZqOLdt8YHLJ26ipBZhpI0E1spVVNIoFRlptbzzbwg6G1zT+YPYjJB
   1xOxExW+Gcnr4ad1xICqOMTm9QkKozyClWkCnuA89atT/uRCLLeSCEuBX
   A==;
X-CSE-ConnectionGUID: iLFaXBx3RhO6OrSKFgDO0w==
X-CSE-MsgGUID: 892glDABRqqTPVb/+SiHeA==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="65464422"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="65464422"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 15:16:56 -0800
X-CSE-ConnectionGUID: UIqydcDvRZGzoeNhazsKbA==
X-CSE-MsgGUID: M5wP5qGiQFGcWzJRQDOfEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="221495130"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 15:16:55 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 15:16:54 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 15:16:54 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.45) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 15:16:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KwinLSgvkGtCwLdg46norCprAfExgMOLut9ZE0+m7zJLt1D5sgbrvBBkZoEnR0Yyf++8NE1yGG8AQcmDoq6yoCjn3Yh+Cyse4E48EeyFbIcZb7GaNvPWdXnkYNkweSvkwULLijmrOQ18m/YWIMYn+Q8NihZi53mfH8K0PkPs0a9VxSG9rDOWHPx9WQK8u3zbSYacbeoy+N4OFzxRe81jWD04fUKSuh5XGU+lutNyfKycpXfhkCOJ/X/N0xapZ8h1VScl4CRBa+hkb2Gwd7eL3NX8sSKDOMsVIcJZcWJXDF568wEgr/cvjDmvnuBGLKYgjJpliXPctomgsssjfVLDdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/7F4orQQuKTOUnNHUikViTnHPVOCs2MJPqsrHru5ZjU=;
 b=VGOqtyebuFecET0ap/2S7bMKhUe+FtJKYE5n2PiHmSgiRWJXVBF9FI8a2NhJ+SaccO+TBtJL9vdflpRSLVN+Tj/4hgnFEI9jro4VTnJ4MZM2z2fkmBWkC4aUXRxObnAdOb7pcdE9li0Ano4HKQwJ7ifMdU4/HPPxJ+hQyzEYlKWxbxVdCbhGBgZqv+WhTozV6vks9FT9TVy8FCdZBt53+dFFNJANbHQMoijmTYS+yXm9Nhw16LT2R6cKXJczPTQhf43KnimsYz5IegI3q2podf/5tw0GMZMipt0vW5xqJot/1XyVNEMPw8dXDDJR1pov5mBRAyumkUsku88cXUmK4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6523.namprd11.prod.outlook.com (2603:10b6:510:211::10)
 by BY1PR11MB8030.namprd11.prod.outlook.com (2603:10b6:a03:522::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Mon, 17 Nov
 2025 23:16:51 +0000
Received: from PH7PR11MB6523.namprd11.prod.outlook.com
 ([fe80::fffc:36ac:37ac:1547]) by PH7PR11MB6523.namprd11.prod.outlook.com
 ([fe80::fffc:36ac:37ac:1547%4]) with mapi id 15.20.9320.018; Mon, 17 Nov 2025
 23:16:51 +0000
From: "Preble, Adam C" <adam.c.preble@intel.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Understanding profiled tagged allocator growth in a stock kernel
 that's just idling
Thread-Topic: Understanding profiled tagged allocator growth in a stock kernel
 that's just idling
Thread-Index: AdxYGCtDtjwVOPyeSNicTIEIbszh3w==
Date: Mon, 17 Nov 2025 23:16:51 +0000
Message-ID: <PH7PR11MB652386A774115119B0DC7B38A9C9A@PH7PR11MB6523.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB6523:EE_|BY1PR11MB8030:EE_
x-ms-office365-filtering-correlation-id: 44f6c9c7-fd42-4401-a5e5-08de262f63d2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?ZAiO42sLT52YDN5BSYbLx0BZnS9Zok1mWq0XmRYwP8Yx9Eafjz/KZpxxTsQN?=
 =?us-ascii?Q?E8VuQ9fpD6XpwuV1vpCDrwVLzFCcOdiDAbYgtYuWZEscBVTL254O4NmcTyOR?=
 =?us-ascii?Q?YmFYEPx7E6pTZ4Y7TEmMxY4OP0AY9Rqjl/hnwImz3w2wXf+MgGZOHNADZFLb?=
 =?us-ascii?Q?7y2+vCAzHNeQmjRE38aX4cXvQg6VhRxn37JQRGYpYNSajGkvMlPEpaWKEPQK?=
 =?us-ascii?Q?/tYHnuZkKCo/jf3F8zCBpTOzdMLKi3F3Yb/yH3UEsdTYdQwDV3ZdFRajsum2?=
 =?us-ascii?Q?xYmmzJUSV17XX+jzw/ErC+WvO7f8z2bHNUzJWdXgr+kfD2mraENmlNIMr4As?=
 =?us-ascii?Q?K7vTHGd1GU3/1vvrMomhRp984LUK2ofkRWdy6v0Y+L8+dHxX4GjhK0DLvtDg?=
 =?us-ascii?Q?BCMDgxXr5JLlP85QqBJnNG0H2RNMNFtKcKX3/3KiCj0+3wXAEhGfQfV56fcF?=
 =?us-ascii?Q?GdBV4nTUdEUI5D0qob3nSVCHxK+1oQgv44iGEpsBOEGEKFvrusYAWwJ+xMRa?=
 =?us-ascii?Q?PQhHUDZF/8ePsbSzmuy+NPcc8n96nC+oIOzvczcDFBzZxZ/E63Eo1wKj4iBM?=
 =?us-ascii?Q?ba+K6rwweOdkOOwBpaDAo2484n2fq/f1eHeGU9K22soSw/8rGrdaQNCln63p?=
 =?us-ascii?Q?rUAXwpZxyvpCRtM0FnxC8RwbASKvexq6ybusZWH7MxdEX6Vz05biNtiIFPbv?=
 =?us-ascii?Q?72FTCEnB7iUuBgbbIBer5TiuE4IuP5HoCQseB0Maf0chc0kbb7e/zBlgNsGp?=
 =?us-ascii?Q?Sp94PlkUqh8guQ+mgp5wSZxJnaDWjVSAI5lG8VjuUq2Mgu24zR8BtODdZ0CR?=
 =?us-ascii?Q?yf9BoPCvaEx6MRrVGz/oJ3aYRpdYYfxRTXUnzSNuvZim9HdIdfXgyf3wmjhF?=
 =?us-ascii?Q?ppajND+4q4D7jrg6IZgHVK1xkH2Wh2h8+Z4+t2jqZ0+oPVjOCDiehs4HX0d9?=
 =?us-ascii?Q?hEgwx1dfLZB2qowc3w4sCCHWxm4qI7BIdSu11cije7IrQIGuPCHtAxS8d0BZ?=
 =?us-ascii?Q?OYYISL+Bofn1HTV7nk3s/zlI0H63UaOK1T6d2ONo3BgLTcD3NPVZHone5OGL?=
 =?us-ascii?Q?3X/xpJZHi+8FC+3DS4f4ZKK+EpFRVUDBj2+XMAIiz8U6mBS2AZjXwcz5kKtw?=
 =?us-ascii?Q?iyjbAKXI8+MkPKcnv7PVderwi8CaDBcw7y6VCIGd+JMbxE17y6k7Pg/pgwgQ?=
 =?us-ascii?Q?Cwn+CWuC2qP29Fuyy+VD2YyZz91Zx9QGDK+b5FZBxZMFlS/WxgbOIBmr1gQJ?=
 =?us-ascii?Q?pDVN+W/wXJMfVdKJfc7Ybqr08Hxj91lc/ph6dRcg8SYh42kTIyiMg6V2HH9n?=
 =?us-ascii?Q?h/15/pPk6/0Sg+NKX5zinkeKyQvcAcEEVnnf5g6Q7TyeCL7aQ9bAlAvpIASi?=
 =?us-ascii?Q?qn7u1C71/YOPBdi92SbQotna2AGshWzZKLIP6Mc6Xle/EFxDZzVFZmegl1Ri?=
 =?us-ascii?Q?OnXuKUwQamQLk3pcDOF8Y9/Na3Tgj4TV3BZ3hn5T9XoU7CWYt9ZoWn94dfLe?=
 =?us-ascii?Q?7KdfUBbnyiRq+QBSO3nCAcFYGx91bZDRq+42?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6523.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?a6kumH3c9IXCjk5cclLCWvP255SkjBXP7d3ZUcce/2meNUu2LxXjOolnklkl?=
 =?us-ascii?Q?vcp1rr9+olwCaExx61tlFLxggg/dL/1Tdc1TUNbqsrdv2bVjtjFCIZJEFs/k?=
 =?us-ascii?Q?F3zZUJTx1ms16qh38sXelVZKfgcQAjgqf5/CZnah+SA01dPsmnfSTixTWi1E?=
 =?us-ascii?Q?ogvbWPMqHmwmRjftEaiSsA2MnHYk2lcHasgO8D7LOV7V9Pti/cSOwQqZ12Vc?=
 =?us-ascii?Q?MTyBIhsxUx32nln7QYr+tv4pYJ3S2Z3k/WVMfIbw/9ypGhVSxy4g24Y2Irlx?=
 =?us-ascii?Q?DM/aYfaEoeKUgu3yz8MPiyvAESyrnZYj9grYU1ZxNFiOHfNj8cqrrB7lV0bl?=
 =?us-ascii?Q?7+c/7lrg2ie1zrtDdxT5ploP+impT3ZiKu7RZ3YkZeyHL+grbTH1X4K9e+C0?=
 =?us-ascii?Q?WRUa5lB2+5Yro6QQmaUoHRqKsLKdL2vL/UIkC93BCH8g0evdsiPVLDo6tWm/?=
 =?us-ascii?Q?c1F4RLqD6v4EJDYbO1K42XiObJkUXwuSWq8QkDMjC1ajCjWprpeZHtJ6gZxY?=
 =?us-ascii?Q?iHyvFx4/KeF0iLsW+nos7XVfr7n94OzjuME9LT0xyQ0DrKVx1pVh0PcIMest?=
 =?us-ascii?Q?GUCKkLgvb2rLJb92zadQw2VC1uWuM+73UUJ+wp+hqrJBYoUKvppjryrRyxho?=
 =?us-ascii?Q?dwfruCCfOxdoxK4xVWRrrkjNnIhHLHtnkI+36x1TRhh7QIlmp6z98VwETjem?=
 =?us-ascii?Q?hctjI/GjD8CiKId5C6D2vbY8DLXx0PMHVDmlFRPMxLq1pmkjC5BTBmCBGxs5?=
 =?us-ascii?Q?NFvZEFVzEkoS6TlG3oiKTKrlvmxpRS8S4eOFM/CQJFYhsFZHJ0f88nLi9TtN?=
 =?us-ascii?Q?HX7U8sn4snLQ8f0BPCu6U22pVFfC8dProqsVzq8ihHQma+5pxvm0Qvqy5jnq?=
 =?us-ascii?Q?e9PAHVuqzAJLjUdHK5MIsKXgro8T8yZI5tri3UzcA+GIjMaydR+wLzahKlXN?=
 =?us-ascii?Q?6dq3qzCjc5dAp3NfcXC8tk8PNGAwYFZn2Y+62uhQWxVl45TNY6+CJ5LbaNPW?=
 =?us-ascii?Q?L6Aptiwu/Tuegd5mpWiNWyu8CU+YKz5moutF22tmXGgd3RnfDp9Oemd/dxSU?=
 =?us-ascii?Q?+cax8gEZ6F98fBWpeOKqAdUrpDIdOQDv/Lyt/ZuAkmhnAaDw9ar9A1Sfy6IE?=
 =?us-ascii?Q?JjTNBziuvlSF+WtMaBO/X2hWJdiqWinTY2RgnygfhvIQpCg6Smt0pOzI1V/r?=
 =?us-ascii?Q?rNPkKDIXLJVZEFe50AobTfrRrddCTCGoPPXz712l5WDelk8bNCWdqc4ZCNlb?=
 =?us-ascii?Q?ncGf2Ijv3oW0ahRwOpdY6sDzgTTlMMNz+bQQdHM6jAIiKDF1lOfTGH3U/jpT?=
 =?us-ascii?Q?/xbdW1tjRbUdqh2RzhOyKjIV2UY59N2a9YrImnIdU4/Rw0Ke7phhiFSzukb5?=
 =?us-ascii?Q?V9I5B2j3iWvtk5ITgV/IflLffEuy37RHBg6P9N78dmCZE8VZPkPx6ns6Ws5a?=
 =?us-ascii?Q?tkxqFmF1RjBC4ciodVzPflxAmTdPnK7ftf+rgpO5ECnwRWcKIRKvjUIEjjiN?=
 =?us-ascii?Q?a2eStztAbxQGtOzWKYQt3WD2mNX+5nehFbRzVHV1swBSb5kzyzTr4+BegeQJ?=
 =?us-ascii?Q?1ENDkc4J+RdBTd5gw4vy7uL+FVpyaR1YmhF7pB2n?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6523.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44f6c9c7-fd42-4401-a5e5-08de262f63d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2025 23:16:51.2989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b9wUNuSL8UWC/M+Y35SH0qokV5cudxhPQgmbtn2sN/ANxHNfOvQg6wuwrT6gHM3p72ExbWiQzKW+QndMnMhb9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8030
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B0BB480018
X-Stat-Signature: 7joyjy41ik8pdb3ddmj3gzb345j57qze
X-Rspam-User: 
X-HE-Tag: 1763421416-954534
X-HE-Meta: U2FsdGVkX18GROWOWx3pRWlg0UvxJ7xqZt5v5Roa4LN7c1GixpWdSCwb6Oph/yU5xAeSfKq+XbQEkhsp5ROVCMEaVqlvmKN5NgnKpTEsx1qVxBu+h87kT6BKnxwNFPzEckcFkdilH/UEsggy9sQr49gPQXkKGMN1UhX7FwXgCSTfDq0xQdtngoDcF8MhVcbnH/4Qnt7A33yD253M+dwS+mCGDef/BNy+H+V0TBZvLA3z2n59AwBrSvPwEpjY/y3ODJr01DisvnLcchZVnSTD0IuYNGXUQ6r4+tDVH05Wal3lg83aT+AZgNAu/MlDMvAyRvqT8JqZJRGXsJem4Cu9DqZiDLgTVD2G/xPoz/h4ClVMJA/zbV2Y9aH0P1GF+y33lHyxkQYp/C8AW09339Pf5RnaBroBRTAnR/ccsQBB51EXyg5hSLov2KVnv62Gvvyyaf1ivdIJm6PrMF3fSRxvn7IKl+uPWEgQiNa7/EjOBca8tvWAyKCzoD7siRjzXdpem3tPmW1518QNT4D16wJ1Y9X+DIriB/6ZQGOoTzRhH/0zKufPYJaY/aqro0Tpls00sN8fh0p17aFDpXPsVCkpFuWTd4paOyNDBSiACXAq9D89T/Cw+FuZ+fvx4xYxlqB4WtL49SQ3IYW/YCcsYZi3wwaiIL7raSGAJ9ZTYtrV7jAzNx01Fld1yVQoanG52nHeHMsYJeT9vB9otSDH1H3uZEJPtYlX6JPk8Aux1hcwpZfpjLVDJyOkAl0mKnk3gvmug42qONZbjPIEghazSiR1NIk328/eU4Nw4SclVkn5OaG1Uz6uYy5OPNixC1Zim2CsOMTetdmMibSeOCiLImi+r7s2xRhKF5xBaL/U9PWpmpDNJmYJXCEURnniKYqD7FbTmGl23//ZPL+eLAj+nep6CN3c7oeWI4xJeMUYTzDOqLbm9SyZd7k+C4cwXKPvY/dpE8D5s3ZvEhGeu6ETQgg
 hf7MLXbw
 +QHxlsaPDP1pzod8R9Ui0rXX9lg+6H/ycvt88nYASVAmU6tEd/Vj1pUHQbbFIxzVlOk1XRCTabagdrwVoXa54EaPgl56WVrZK8545/GS2+jy1JPeDKvc1laPUnQK7M2kyqmklZ0ZqRdQXQ1fGAkWdnAc7CTryc/W3/OSw9+wdeQ/ElU2fvgY75I0q6rnwiF81WV7kb0+BUE2NHWLZGa1PcRB8JUQtE9/fDdL3k0GWWW6HoaxnKMYygKBZqOIe8RtjJs9Gkb0tndB0LerM0m4Gkg7Jhn50OnFi5LpJPc0rIQBproRgnm42qilJvTkwcR5IO4CKCBa6acNPZb9J0YerqQlTetdD4n9k2BwXtP5QVYHPKZb9b0+TCG1r7o+aL4fx/tluRFt47jNKSZuwV5iXeVMtaah5vEuYwDK2xMFOb6t1NSthP2+eNFzs5Wq2kEFepv0KqOQO/mY2tkc73t0wx5u2UNjOb4shZYXs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000008, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I had sent a note to the list a few weeks ago about a situation where my vm=
ap_area allocations were continuing to grow and I couldn't account for anyt=
hing in a kmemleak report (it was completely empty). This lead me (thanks, =
Lance!) to enabling CONFIG_MEM_ALLOC_PROFILING=3Dy. I then saved /proc/allo=
cinfo before and after my workloads. I then used a script to collect the tw=
o reports, determine what grew, and sort it by how each tagged allocation g=
rew.

I got a bunch of suspicious things, but I couldn't trace any of it back to =
anything I were doing. For example, I tried to collect kstacks with bpftrac=
e by kprobing any of these functions I could. I mostly had to get near them=
 because a lot didn't have direct trace points. I haven't tried with manual=
ly-inserted trace points yet.

After multiple experiments, I took it back to a stock kernel (6.17, tag v6.=
17 commit e5f0a698b34ed76002dc5cff3804a61c80233a7a) and just let it sit idl=
e for a few days. This still generated some growth:

    Growth    NewSize TagInfo
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 676085760  820760576 mm/slub.c:2492 func:alloc_slab_page
 591151104  672784384 mm/filemap.c:1981 func:__filemap_get_folio
 528635360  532319824 fs/ext4/super.c:1384 func:ext4_alloc_inode
 187793408  325976064 mm/readahead.c:186 func:ractl_alloc_folio
  95700288  103415040 fs/dcache.c:1690 func:__d_alloc
  29970432   63787008 mm/slub.c:2494 func:alloc_slab_page
  20316160   39485440 mm/percpu-vm.c:95 func:pcpu_alloc_pages
  15044120   16415048 fs/buffer.c:3025 func:alloc_buffer_head
   3116224    8994768 lib/xarray.c:378 func:xas_alloc
   2138208    4317472 mm/percpu.c:512 func:pcpu_mem_zalloc

I don't entirely know what I'm looking at with all this yet; kernel memory =
management beyond kmalloc and vmalloc wasn't really on my 2025 bingo card. =
I only listened to a talk about folios after I first saw this stuff and did=
n't know they were a thing before now. There are a few things I can still d=
o to try to normalize my setup like taking it to a stock Linux image of som=
e kind in QEMU, but I was hoping for some advice before I keep slashing awa=
y. If there's one quirky thing to disclose, it's that the file system is ex=
t3.

First, is any of that information actually relevant? Like, I wonder if I'm =
just looking at some records that are known to not have their corresponding=
 free operations properly correlated. Second, would any of that actually be=
 relevant to progressive growth of vmap_area?

