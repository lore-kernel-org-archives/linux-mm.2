Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C85ECC53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 09:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB1AC6B007B; Mon, 27 Jul 2026 05:49:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63046B0088; Mon, 27 Jul 2026 05:49:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 929946B008A; Mon, 27 Jul 2026 05:49:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 654636B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:49:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED2F64049A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:49:50 +0000 (UTC)
X-FDA: 85034084940.24.C0C4FB4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf10.hostedemail.com (Postfix) with ESMTP id 46BB5C0006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:49:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NkzKtWAG;
	spf=pass (imf10.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785145787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HUxQWnWgoCv3yh24r25B/RN77fMavLtR00IQNtdmHeA=;
	b=ABhVglCCvlublxlfmt7Faom4oCAshmyqU0gqwOi7JvOp4AP7+rIXRTcBeqoBIM7bNnfF1e
	PdxilYP0rtyg1qgDIRbyWMabQEHvwZMCgnKyse+0glgr02Oeum6wyhQm4qCkF6MFvWTRyB
	1hgQHIPLFoh0vsnBOlyM7H7md2jIFGM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785145787;
	b=PYDtSFY1Ff84Ra65JCBFd8BAy5hjFTuSxDXCXRf18CmtStPpK9ZclcStOjmgYFeWSnKObH
	TtEG4Xfae0JHgXKVcj4chDkObInZieuaJfOb0Hiu+/jXWAcarjERMhFr3+BPWUuvYSK6UI
	nmdwKYu3AU74dIUBiSqx0WE51BJmNk4=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NkzKtWAG;
	spf=pass (imf10.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785145786; x=1816681786;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/qXfOkqi8OrPKRoUOplBYyn1MrfGr0hN8BwgQu9mWy4=;
  b=NkzKtWAGGApjMBIbG1hBQGd1BldhTN6HWASJTE7MG6OiHsSdR7aLMsqK
   +0aKTYRxi/b+2aqMCdMbKQYU7C1XkcWHWFzCSYxHp60P9w+Os9A2hoLHK
   hyCyj746ugQwLVDDfLnb6txF3jWpGUKYreSjTuqw/KvSAwHEsOmOVGuuI
   MlhZl6s1sRki6cTyx6IA4Kn+K9Xj++qUGOq3m01uNbeM7dHe39cqkRpY5
   H1ldnbvYy1SOcIUWHYkk/XNnKvMBaygMyVqfPNrg2pVYeaI6f/0EnDVjo
   V6DrWRrlltBLjfgns0tcil+s4D47CmbqCiRcBYoKBJtkSUHlIVGPo34oY
   Q==;
X-CSE-ConnectionGUID: FbnKMg/BRe2vzjS2WscI7Q==
X-CSE-MsgGUID: oauPonqBRXON861gpYzNeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11857"; a="84834849"
X-IronPort-AV: E=Sophos;i="6.25,188,1779174000"; 
   d="scan'208";a="84834849"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2026 02:49:44 -0700
X-CSE-ConnectionGUID: cjnkiC8PSkC9xTHXEhmzog==
X-CSE-MsgGUID: NpYT0QUrQ/+XoXrv4J74NQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,188,1779174000"; 
   d="scan'208";a="253038970"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2026 02:49:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 27 Jul 2026 02:49:43 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Mon, 27 Jul 2026 02:49:43 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.10) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 27 Jul 2026 02:49:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I5UHgrRjnJXC2z/4LkmfX5HAZhbp0ntbIWj/zEP1/iZOadCbZo9KbHpCwD52u6PrmLgjL7vtHd5ZehOpHmVhaVbqp6byiNiGaYn4RMvxS/OSmNbomv1rYLY3qakK2o+wh9JR9inSdFJpvLGOAwFDUUgwRQ4v9erlHwMlvXipJjEEnyg7gJYW4fkfmYPtuY+MdfwPenU5Qz0AwvYVuQGhC1bbATfsmsfm1g3g9htABhXBMMsjvPS3IvgtCTxBY1ZL34tx5yFylyhP/zuJSGun/xD0om4y2rRobTjd8iZ/XLkgX0mlEeuevpaPflcLXN09KC+TBK+zOmh629YanDEWXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HUxQWnWgoCv3yh24r25B/RN77fMavLtR00IQNtdmHeA=;
 b=OR3QCl3J/7yxTWRPlBX1dSIamfzX3vukE4GwgqI0r/z3SvZ6VWTFjNbxOqJsvaOnZsCa12QWPDcwTdrGjK6BFcsqgTQcwd84HqWdfFtGyOg4BRRUfjGBnM12CHZWIElrzTj9OiB023iet/rOYd5dppnpjH6q7fkJgPmdQVtbmyVZrW85doWgkIjLzGZ2SFPQjpM23V9EZYR1EQx+jYAi0lsuWdYsLW/UETz+X1xEKfyUu4NyK3nZg6o0LbkQEh9lHY7j8Dq9/oZ/iusAXw9Hz/yZYpD9EG4kki6Q4HU5r09V3z6JEMC/6H05k2jMrLP+UJr8CdS3eoAs/oNez4xsfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by DS4PPFA58A7783B.namprd11.prod.outlook.com (2603:10b6:f:fc02::42) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 09:49:40 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%3]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 09:49:39 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: Wei Yang <richard.weiyang@gmail.com>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Zou, Nanhai" <nanhai.zou@intel.com>, "Deng, Pan" <pan.deng@intel.com>, "Li,
 Tianyou" <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>, "Zeng,
 Jason" <jason.zeng@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 2/2] mm/memory_hotplug: improve shrink_zone_span()
 subsection boundary checks
Thread-Topic: [PATCH v6 2/2] mm/memory_hotplug: improve shrink_zone_span()
 subsection boundary checks
Thread-Index: AQHdGn+x2uiqqGOqx0aLQy9y2I3YaLZ9i4gAgAOZewA=
Date: Mon, 27 Jul 2026 09:49:39 +0000
Message-ID: <MW4PR11MB6936598686BD5FA7B2FE9181A3CC2@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
 <20260723084946.189392-3-yuan1.liu@intel.com>
 <20260725024952.65lfm2s676obpoue@master>
In-Reply-To: <20260725024952.65lfm2s676obpoue@master>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|DS4PPFA58A7783B:EE_
x-ms-office365-filtering-correlation-id: 503195b2-9414-4177-c47e-08deebc4607c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|38070700021|6133799003|56012099006|4143699003|11063799006|10067099003|18002099003|22082099003;
x-microsoft-antispam-message-info: 2cdRIePdC3IydeLPhRL+z4Rzjb9j9pdy7E1C1DhNqbWzJxw+wuVVnQp0Zlgww0cFUcYfb+5Th8fkkXF6Pbf1qjSvzKUaZVVOLIBtIOk7q9wRaX2blJfTjv8DMQwjDdXWNV/g503yZm90rsKopXRrF209WDsT9fjgaBX+tos8R/ky1roTT694Qm12TojaPQK7opVktUyf16eobbdH0219Oe9LoxMt8YTA14rRpM0GhuVzf+ZKEloNQT7pY2iU/MYHBevxwz3dKhns8IgB5CCmnQUVd2os/XMdX5dJBaO90KmwKPA/C2SpvnhM5Fii/JWe7NcjjC1Dgn6ST9SUxeMqjh5Z4/xuINz9dAZq2Ywq7urdrXMVTWT2RCWaqT/+fH+Xs8wcIe5jbfqVAOtfy6ZtGn3pvhK5mdxYBiM6Af0zmMRTkmTvm1SY59DaiA0p+XxnSXdATiy4Gj8ssfWHzjVH5KRPqhhKEYNW3A4g1L74EKF+nHyBGRcEJybMQR4iAmlmCC/VA6DF29+W7CfjClsVLBonzNzkfuOO/nrnfki0IEwaeInr68xkJ3/2iyL6CMDvc/dblUPoxgSDDL6mRNqjPe2Ba7hEqNz2Xj4dqlzIGf2uIZvWLPELQZDGYS8O2x/cgcz0o66PZj/ONGtojz/rXWmFomSSdlg9CoOKMrCZLibTzr7SvH1+FUVLzy6847kAvV20EVnAvpKz/2DWD77wYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(38070700021)(6133799003)(56012099006)(4143699003)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TyIKQNkTf9y4Q4/Rm5DvgCfTnpnZmhafIheauynCP2EDQS+hvf0RC7ApYq++?=
 =?us-ascii?Q?dJZxdtzcNuZpaxHlwCQhht67GKiG7e6j3o+IsIEBzOLx2SGwZ0CmN2L6NsQs?=
 =?us-ascii?Q?A0DxBS2qh4UYkhpp8oICYQSPZN9zUftw1lbVB+DkvcZ7bqWPNoSjBTXg5T3c?=
 =?us-ascii?Q?8CBtnL+eLDu2DSwX/gZr3oeoV5dLF+7BbSB/DHC8IrYmMQ6ylP2OMyxJRKOl?=
 =?us-ascii?Q?xanWCaPAR+86KqQiST4WQsNFawTwPShB2ebfewWSMoaoUONmCdnJJucdP6d1?=
 =?us-ascii?Q?If9aQNIDnsoK8o54PR96HZZHtWjr1ztVao6QBpjvxUGC5nAaolLfdkZXCXx3?=
 =?us-ascii?Q?H/iTvDfNerBKml3edkWWhracteUstuGsspW9tr86rMko3Xca6CnQCvuV7/8K?=
 =?us-ascii?Q?N8lydNlopyManLH7UNpqXvLm7By6MFOszZxUQL432oH1rQhMi/psTFsa5wS7?=
 =?us-ascii?Q?IPi54Agl2HPFTQUUE+64EmbnY0Ii3u5/ybu8dtqu/eLaoCPsE8QitRXBcTrg?=
 =?us-ascii?Q?B75pFysP2FthitdapxMrab9v3bZ8VxqOM8O2KjwdFCrki1hKIO1vfi1D1wxn?=
 =?us-ascii?Q?Kniq2bCjwSRAx7Bw10kz01ITswvjf7jRZgGTYcBKjPWRFVlMm3HDfg4JUg10?=
 =?us-ascii?Q?mfsKSb7UpbLJpKe+N9TaU9RlqVjA++M2jqeMDk9gooMclrt5yFzMka7jbJz0?=
 =?us-ascii?Q?EjhPy8s91Y9Y4uz8+5zMx8BVUC+9vj4xqrHWh2QSLBzfkjMeOSApzKR/RNdL?=
 =?us-ascii?Q?ziPPcpT8M6svIX0JBKvDC1iG6hTTE/gVpW3I0AOqc9psY5FNxRoDpeRkzV2Q?=
 =?us-ascii?Q?CahP7M138leKWn39CGOJzJBdXHW5rT7Ob3oB/H5o6P2DRkOX2gSpncz5UHL2?=
 =?us-ascii?Q?iDhsHxUCwcbpIvcblNpT3iiZLOKQ6urXP5/US2HHfl+FUOH8dvfbR6fkT6Ef?=
 =?us-ascii?Q?jimvOKLwgVE/G5yeiOxcydvqFK5cwwElBrbPOlw3OGMabdXzH+h3a36jtznq?=
 =?us-ascii?Q?465PegF43bOWT2HfEfX+H62wpj9CedEWiAyboWsgCnIQQuTjU6b427LYHafK?=
 =?us-ascii?Q?L0kEWsIA5zMt2Bu8Sp41hCya3LRM6YsARFfFjrQWhVfoBSh2GY5lGj9FKtEd?=
 =?us-ascii?Q?XvhTZYrLLTTQGYL3rG91dyUYknpU7xLsr2UnRVtHS7fz7eBM1oWeXTf1uyHB?=
 =?us-ascii?Q?kX1vVDNdUueCfa1kw7TDPP8821fDxvBgeji9KAe+HEuF7ztSbbPmer1Spo0X?=
 =?us-ascii?Q?p14gLKXqDRmRQEgna1nnC2NZQe4roQ8rHMAsmU+26ycybDzFK92KTKgwtlIH?=
 =?us-ascii?Q?fzGEkxC8KCoErwdvql3yBB54wWWgN508FpaI7Nlpy3asdig9MFpDglq4CjJT?=
 =?us-ascii?Q?kEqIC2hfMh0pNewfJAwvsLikhQksAPIiRFerw2N/MwYusCMH+jdaf/IqyZOj?=
 =?us-ascii?Q?afu1hk0fD/3C4xTmq3xI9ZgX4NUTAO01azjV1zXYyGY44O6cHV3IXtyII+EB?=
 =?us-ascii?Q?3+YOBZ1/a7T5yJN4dZ0r9NoHfOFaD0nDvkHlDePH5VBPI+B5ox6sL9WYdjZd?=
 =?us-ascii?Q?+m5LicPnv64JcT3K0JTpQ3Oc8p87jLXc7pDZ61qtezZYY3P+nd/EN5i4zmzm?=
 =?us-ascii?Q?alvaJMR5G0d3vzDzXSsuyegSWfY77OJUfgKG1eZ15eTAnLzRyszpfo3JwoZj?=
 =?us-ascii?Q?GOJIVH3UQTJDAY2EUJX2JRcCoAXfM3vmzNeg6N1pTA2LQiis?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: OFZRqdEDC4BSL0eEGQLwQY32y/yFgv8MQ8OurD3pO52DAG5YF9W4ZvHofbfqYY3eplkYdfc+X7B/LtcZ60wR/xUmwUDi4L5zHU2LmErgcH5FXa/+kFGPUfFA2VaCutXv2y317xfy15z8wOXS/rfm1Z042cu6FDjhgY5L2hhk2+pY/jhkSwdfrk7+ZDf1j8Ef8ohsJv83JCiqx3b/JNf3wPclylrJgTKV2x8I+3CVCsX2RgYPZ2ZEsIQLkfoa9vpqPoSA/uFQej5oQGc7BVgnpmshWQm8F0/yIDZhSc3DyzWajO3Ap/23haP1AYBas52s/uhl0O+SeZho9JZ/PrjVwA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 503195b2-9414-4177-c47e-08deebc4607c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2026 09:49:39.7593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7+lDGYtvZtxouczTCbsTYWPXdlTOO2guDoaw2c1z0VNWlLv24up0xLFwCqr98WbBTrlqlFWuZxlpbaROraiBNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFA58A7783B
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 46BB5C0006
X-Stat-Signature: xfoznfyj78ky1ki8dyf9f5cu9qz4hu58
X-Rspam-User: 
X-HE-Tag: 1785145786-326022
X-HE-Meta: U2FsdGVkX18QgNmNac+g9NnfKNuPhKAu7NAvh569VfYMPFYtTUcbmpBMOLeDlHGR4Aw4A0rf0v3QVTCeR8u9ACSrmXq7qcdCvSAESNedMqgt1MUo5rhlr7pcKIA9PIBbofzJri/JgdPjYOrKVil8nNeTHPz80newjjOQPctYw7T66NkxTQvenkrXSNDRiLXfzBRyG9Ucx8hpJCf7bBTlvlUQmw5ruL/G8LXroEVB8eOT3oiK1hhoNu9hXNncgS1tlnrF/4M/GsJh6+xaGL7sjk9cOuFvy7RwwJbRFCTVnjrucA8cLb4UxvPIDVJ6VktiTmFdGlgUDK+NjKoR9SAwDyx9NXZGSDPeXJfMcqM4HcMFfHVDmTmUL3Djac4SdZB4oBZ+pG6DOhsFuWa4mfKCjMS+w8D4Z/68ZmPsqYRl4h/whw0OGoFM4bsRnUUi7YBs94I6s4KiijpndASXLt5Ny66XJDQzxLkROtzYjcXETwEzsj5S9LzGW6g5XztQdU54XPj6NtkjMMC1UwLqyC8bxXLJ4UgIaNjGxb2vxwM3ezDHocSJHP47iunHCtLE8DkNicCbGDl438DzsZ94GRv+XGH+oSzv0jF4QsjeXOHO9bgo6aLTPqryHy5FjJBjWyq94TDwR3m9NkaIXUbCYLbTarT49xt+1r5bHO1BI/8yp690nGlnXwF3IVf4guX7Ys0+SElyTxTdaNJWsvJWJGQaDQ/7mGJK/TIPcFOzUf/Lo050XfJric80BJu67Uo54scerywaDMory90r3Ur91B9royoeZHCdHCg8xplpetoqGh4GetXhi8ena4/vaO93uAIZw6QbQL3TKjtwxcR4ACWTzpQ8nfsHpO1GytX+bkQ6YJcwvp392zJyJj6Gn6J54aJRKrGeK2RbRuu56NexRtSB7B4TrVVgpi3D7t5NOKVEnTpk5ccbJ9LwFfFQGvoJVc7EwzFWNDy+/YU+HNc4Q98
 /QCY9jha
 QqoanVql0uz3W6y//16Gnb1ZM89BFXortARAagj1H0DKXH68dPkbQVl428j0UAa0NAi7SJa9joRqd/pxkAMiBNy8D03STjDAecBcB92nLBP6JFw30qJsJiAUw/Ap0OZZik4zEu7mCjGN9MC2PVJNzuMzBhsn4UGipJH3tV+dXbGi1g1KC0kOOGhX7OfkMN6sghDFtQKH1mqt6kYLfMwVPPieuEzCvXlRCGTyUWknDnT86njlAXKfMkPn/0FhbfFut6ouU1FHpvQ/EyyqCfn4ouscaZVJJdKlSHZtz91Ihcyg8ML6FFXYkSUFmxsMXHdyHdJce0CrfDl8uWaZez9QDLHt8kHeA+BnfhMMtx6QlCdI5BGM2V6jLTEto6zQNoaZ9Vyavk85+86E4QJaESg3Cm7ifS9h+AAXjhc0yMTUYdZIkleDF9goHFcxY7+ccaxD+yOgNtVpO7ykIDRvwv/zic30RH2uRoKAaDaqdaqGdqEQD8sB3dhCqC0jkiEEjbpTtyoUO8KtEW07/vguZ9Bpq6grLD8Puy2fPqTVK1mDkx5Iq5V3KeUXC8cX2I4r/nUNlcC/Mnxc/2H2Sy1HCf+Z2S3aqY8eKi8TTFtPDP4k/+zWArYnXhW7T9h6QcC4tGUA7ZSBt2CQyLbgD1IkQ19VszrGKphe2TMnhu8s98BYLjGtAfY2i+wPdZAESPTCodEsJg4p1VinhNOqLixfXUVao33gCjJw4zNcKLWc0w8rmGubRaWx7R1a2do/3ILDxFzEhKdpU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -----Original Message-----
> From: Wei Yang <richard.weiyang@gmail.com>
> Sent: Saturday, July 25, 2026 10:50 AM
> To: Liu, Yuan1 <yuan1.liu@intel.com>
> Cc: David Hildenbrand <david@kernel.org>; Oscar Salvador
> <osalvador@suse.de>; Mike Rapoport <rppt@kernel.org>; Wei Yang
> <richard.weiyang@gmail.com>; linux-mm@kvack.org; Zou, Nanhai
> <nanhai.zou@intel.com>; Deng, Pan <pan.deng@intel.com>; Li, Tianyou
> <tianyou.li@intel.com>; Chen Zhang <zhangchen.kidd@jd.com>; Zeng, Jason
> <jason.zeng@intel.com>; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v6 2/2] mm/memory_hotplug: improve shrink_zone_span()
> subsection boundary checks
>=20
> On Thu, Jul 23, 2026 at 04:49:46AM -0400, Yuan Liu wrote:
> >When shrinking a zone span after removing a PFN range,
> >find_smallest_section_pfn() and find_biggest_section_pfn()
> >only checked one edge PFN in each subsection for nid/zone matching.
> >
> >If a memory or hole boundary falls in the middle of a subsection,
> >that edge PFN may belong to a different nid/zone, causing the helpers
> >to miss a valid PFN within that subsection.
> >
> >Fix this by checking both subsection edge PFNs for nid/zone matching.
> >Keep a single pfn_to_online_page() check per subsection, since online
> >state is the same for all PFNs in a subsection.
> >
> >Reviewed-by: Jason Zeng <jason.zeng@intel.com>
> >Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> >---
> > mm/memory_hotplug.c | 42 +++++++++++++++++++++++++++---------------
> > 1 file changed, 27 insertions(+), 15 deletions(-)
> >
> >diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> >index 4c699fd9c479..3a281d595207 100644
> >--- a/mm/memory_hotplug.c
> >+++ b/mm/memory_hotplug.c
> >@@ -427,17 +427,24 @@ static unsigned long find_smallest_section_pfn(int
> nid, struct zone *zone,
> > 				     unsigned long start_pfn,
> > 				     unsigned long end_pfn)
> > {
> >-	for (; start_pfn < end_pfn; start_pfn +=3D PAGES_PER_SUBSECTION) {
> >-		if (unlikely(!pfn_to_online_page(start_pfn)))
> >-			continue;
> >+	unsigned long next_pfn;
> >
> >-		if (unlikely(pfn_to_nid(start_pfn) !=3D nid))
> >-			continue;
> >+	for (; start_pfn < end_pfn; start_pfn =3D next_pfn) {
> >+		unsigned long tail_pfn;
> >
> >-		if (zone !=3D page_zone(pfn_to_page(start_pfn)))
> >+		next_pfn =3D start_pfn + PAGES_PER_SUBSECTION;
> >+		tail_pfn =3D next_pfn - 1;
> >+
> >+		if (unlikely(!pfn_to_online_page(start_pfn)))
> > 			continue;
> >
> >-		return start_pfn;
> >+		if (likely(pfn_to_nid(start_pfn) =3D=3D nid) &&
> >+		    zone =3D=3D page_zone(pfn_to_page(start_pfn)))
> >+			return start_pfn;
> >+
> >+		if (likely(pfn_to_nid(tail_pfn) =3D=3D nid) &&
> >+		    zone =3D=3D page_zone(pfn_to_page(tail_pfn)))
> >+			return start_pfn;
>=20
> Here we are checking range [start_pfn, tail_pfn]. When we come here, it
> means
> start_pfn's nid or zone doesn't match our expectation. But if tail_pfn
> does,
> why it still return start_pfn?

Hi Wei

If start_pfn falls into a hole while tail_pfn still belongs to a valid
memblock in this zone, skipping the subsection would cause
shrink_zone_span() to shrink the zone span too aggressively, excluding
valid PFNs from the zone.

Since init_unavailable_range() initializes hole pages with the correct
zone/nid, the start_pfn check always succeeds here, making the tail_pfn
check redundant today.

That said, I wonder if it is still worth keeping this check so that
shrink_zone_span() does not depend on how hole pages are initialized.

>=20
> > 	}
> >
> > 	return 0;
> >@@ -448,21 +455,26 @@ static unsigned long find_biggest_section_pfn(int
> nid, struct zone *zone,
> > 				    unsigned long start_pfn,
> > 				    unsigned long end_pfn)
> > {
> >-	unsigned long pfn;
> >+	unsigned long pfn, prev_pfn;
> >
> > 	/* pfn is the end pfn of a memory section. */
> > 	pfn =3D end_pfn - 1;
> >-	for (; pfn >=3D start_pfn; pfn -=3D PAGES_PER_SUBSECTION) {
> >-		if (unlikely(!pfn_to_online_page(pfn)))
> >-			continue;
> >+	for (; pfn >=3D start_pfn; pfn =3D prev_pfn) {
> >+		unsigned long head_pfn;
> >
> >-		if (unlikely(pfn_to_nid(pfn) !=3D nid))
> >-			continue;
> >+		prev_pfn =3D pfn - PAGES_PER_SUBSECTION;
> >+		head_pfn =3D prev_pfn + 1;
> >
> >-		if (zone !=3D page_zone(pfn_to_page(pfn)))
> >+		if (unlikely(!pfn_to_online_page(pfn)))
> > 			continue;
> >
> >-		return pfn;
> >+		if (likely(pfn_to_nid(pfn) =3D=3D nid) &&
> >+		    zone =3D=3D page_zone(pfn_to_page(pfn)))
> >+			return pfn;
> >+
> >+		if (likely(pfn_to_nid(head_pfn) =3D=3D nid) &&
> >+		    zone =3D=3D page_zone(pfn_to_page(head_pfn)))
> >+			return pfn;
> > 	}
> >
> > 	return 0;
> >--
> >2.47.3
>=20
> --
> Wei Yang
> Help you, Help me

