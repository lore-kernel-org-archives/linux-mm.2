Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D89EFFB5175
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 00:59:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8CF36B0088; Mon,  6 Apr 2026 20:59:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E645A6B0089; Mon,  6 Apr 2026 20:59:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2BA86B008A; Mon,  6 Apr 2026 20:59:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BAA126B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 20:59:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 51716597CE
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 00:59:43 +0000 (UTC)
X-FDA: 84629952246.22.8A33226
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id C2F00180003
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 00:59:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m68D0ja8;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775523579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AUY3PK4iujftZJWbtGuT9c+gmdvRRHiCzCXtMg9PExs=;
	b=l4pSAhagoZt0dFhwrFaiueDpQ3w/Pt0fHREz2I0PrQDUyuj8HsEJGuwIP96rw14IZSaqMS
	3+S8C0P03XmWVFi7t7RjkbPcXXdBEQ6BYBZNm6EDGbmUmwEjuR3Oq5sPJzHSi1rU/7mY3k
	qV8uNPV9eYX3NAJGimPwxEyymt6V8hw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775523579; a=rsa-sha256;
	cv=fail;
	b=fmqz8ojhZG3sSNvuiGNQNonzTW6y9TGBG3i+eTQ1+TDS4aHqORUZYG7XnIBFiiQqK2HAEZ
	cZBsh+RpvguRqbqfXIDuppRJBr54R7g7EdGV3b1UU7cFpDQ9Y//p8/3WY6vSXRUDpeWxIy
	2V581c2jSXA+jBgnImvEDRB24ehy0fc=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m68D0ja8;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775523579; x=1807059579;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KZSQO38i5R5kso5k9xjENH2Y4ExUUH3Uv2MLPHo7z5k=;
  b=m68D0ja8DHpX3TnMVGmrWQcEkfmXB9F3TnTiT35dQzDbYu/bewpZOcbb
   K6OLA/jOKugqnTjBZtIaXiPMiWcZf5qan60lXG7eYcq4wfoZLvZfar8vV
   z7Famv9NGQ4c07xgbV1voCfoKdJQoBHBo/17/dP+uU/SziPS9wNSnxoUJ
   UGGrSJga9qviCICIPKd+acvhMMQQonyzWQHT9ho0xY6fHRtI6dqfp+/nP
   WEvTTTecMUgx92fI70uXzAayZvx9+pSFnS6BjdRT9WjVs6zpvHJT+ykbT
   rHTOKDfeapqORudaJ+nL6lXyqqE2hDKAq93Dr8NmA/UkK6ST9jW3rb7M/
   w==;
X-CSE-ConnectionGUID: mgd+nFb1SMmaX+UVdgVnMA==
X-CSE-MsgGUID: 9WPq+X6UTWK5jAL6VkR5QA==
X-IronPort-AV: E=McAfee;i="6800,10657,11751"; a="87865533"
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="87865533"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 17:59:37 -0700
X-CSE-ConnectionGUID: M0z3PsZwQhyVtZKqwgDl4Q==
X-CSE-MsgGUID: Uvt1z4EzSgGpj/+3Vpvhig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="228282431"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 17:59:37 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 6 Apr 2026 17:59:36 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 6 Apr 2026 17:59:36 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.40) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 6 Apr 2026 17:59:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DHjD7Iw+IB7o5tF/pXfXt2qIrKltRWM02bK4V7jl7bRJfnyLQbKCosrvcz7lX957pKb7wlGndOb8z58bb6hgqaNjkzyNH2EAfIi+a0sc0Ub4t7Wc01AeWqUJXxuZunt+sPzqfDaP6zMPxh7oTb2taBlHGBRWSsJmb8gC6JoGaxvY8kTY72ZRrheI/uqDEWfQaaeYPINbKxSM9/Ob2fbWiVPswu4ec60z3WtHraysbVeGKQcrZpqnu0fGaOSEPYOZD0GmOJATVM/dlcT8l99+3A4sbSosLkJdMI9pahk5cAdAYxKsRHMw/6wRN46hCNejapJENHdtWEGXzrGB4QAKzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AUY3PK4iujftZJWbtGuT9c+gmdvRRHiCzCXtMg9PExs=;
 b=H1xbQyHtlObcJs+TC53YvyrsLQe19Bd5o6FwQ+nMD5Eu33imQaQOKbmXAq6XvWSAifd2cvj5Zs9kxKWoODfTGA1deLdnN8UPZ2st4627cbzSt9wqkmD2f6ZTSriCEYs8H1867WDqw0OQ3dcuRN9iSDnGukks1tj5njgmED6zloFDu7/vi5g2NHyh3tD7FUD8veVWF5eXNYQZItU48i+GAzuaFGtjlWFAKREnuBMBz6P3cIDCUFy7uXjUdwkeDpgR55X4u+VgpZsh5dT7iJ+Zr2LohWlk+Pi/hDDeg30OfWpD9yHeNxtnxNc60L55flDz31IcCj40nJsWGp1Y0WmEFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA4PR11MB9009.namprd11.prod.outlook.com (2603:10b6:208:56f::21)
 by LV8PR11MB8677.namprd11.prod.outlook.com (2603:10b6:408:1fa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Tue, 7 Apr
 2026 00:59:27 +0000
Received: from IA4PR11MB9009.namprd11.prod.outlook.com
 ([fe80::eaae:cab2:868e:4541]) by IA4PR11MB9009.namprd11.prod.outlook.com
 ([fe80::eaae:cab2:868e:4541%4]) with mapi id 15.20.9745.035; Tue, 7 Apr 2026
 00:59:27 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: Mike Rapoport <rppt@kernel.org>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>, "Zou, Nanhai"
	<nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, "Zhuo, Qiuxu"
	<qiuxu.zhuo@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>, "Deng, Pan"
	<pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Thread-Topic: [PATCH v2] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Thread-Index: AQHcwaVq/SNiFgNFUk2W6EN+QH1DjbXOxGIAgAQGyHA=
Date: Tue, 7 Apr 2026 00:59:27 +0000
Message-ID: <IA4PR11MB90092416B620C48682C35332A35AA@IA4PR11MB9009.namprd11.prod.outlook.com>
References: <20260401070155.1420929-1-yuan1.liu@intel.com>
 <adDx-FYHY-si07mW@kernel.org>
In-Reply-To: <adDx-FYHY-si07mW@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA4PR11MB9009:EE_|LV8PR11MB8677:EE_
x-ms-office365-filtering-correlation-id: 32f3e073-2ad3-448f-b25e-08de9440eb04
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|38070700021|56012099003|18002099003;
x-microsoft-antispam-message-info: N2ahwsRgonGqmvDEDvAfNpSCcT5XhQgXrppQARNIGUN/RimaidzHb3PcoUVzdDILPPl4W3jsMOw1fRpWdxx35Q4ZAbl4dL1Gh5J4brDIRrsKxSr+t2gWpAMnuYWm2l6cY5EizH+bsTwCCnp6vuNeAMYFj7tQjeaL1DBGRgiPNbgBECePjdtWweUkZTVD0PUU3jXoyyby/fKOC+s6qBYZxrr8Mowt2oLVxFqD+KDTP8W0vb3/90HWQ5n5ldG0AvW5hrw2ZRyyC+BidbJlzXghwy6AbYfJXHd+C52xKGGgXOkXCNjmVHFNrOlmV5dwpzE8xb6gKcsJS8oVQ5yOC0q2SUuJWNMaxe2EjNjNt6SRo2qmRG6WL2YX1EL20l+MuKQhE5ON5O7pvUFrwkxwmz9Zo8l/oGYXP4AuFnn/YjlJfl+P5oXlrl9DXU97HwpGHI/VjYkrevpNzqQby8Ca3gawrOKHJKvnAFDoxsegBnyPut3B2GrN+AWFfM0xSktC69d0BEe+qVjAXtbsEuV+gY1QtYxc37B4UEyPTdXfSOS/erYDDm/QXnef6vIxircJo1fP1jBPiCy/01IMVGzFykhla8+xLeSQZvslgAzLHAPPt+R6F/CUWJk86CrQFmhj7RTFAvjFq1yKgLXUxga+RswI6qvsKf31crNCiOMEu00SvYilJXFhJyZdF/j8NPbGDGKG+rBktVCFU1pRI6+1vo7h2XxvkCNoBG12szeh6kV2cAnEG6VJtRGY0igRTff5tZ3VkCawsLmOin+rI4+EUsjl1aXXk3qPUIwFd4t+/Hs4Wvo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9009.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(38070700021)(56012099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RNSQv4nhB2kadhzLt/SB4IsX/ZhJFb1JnJ8OugF3FOgSMZVA2p+IcAxv5R6z?=
 =?us-ascii?Q?RqrHV9snm138JOzQZljkcRuDfRxZXkI2OWmVYfMKNAcBsqt7XECYNLsMKVp4?=
 =?us-ascii?Q?RYEczsRa9DHkIMpeOgxUHQIXVWMUROqzQQP/I3KQ62l75oEB4HfKd9wWdPs7?=
 =?us-ascii?Q?h7iyYOIdKWSBaERa0398LemFH8K9DUlHMO1XYznMKdCkzzRQzBMbuuRLjb1V?=
 =?us-ascii?Q?Z0uik9HlOnKTdl1IL+VooU6+5V91UYgjW4uNmpVNTPqegJc610z0hpWNxSjE?=
 =?us-ascii?Q?WrPFHWrfVnIMI3GGTqKY4Gn7O6oqgTQGnGkkorPQlmIqxs/QKBBUGZwLKn2n?=
 =?us-ascii?Q?Rmddb2Zo/x6z8zuh903guecIHMEw8Qdg5b/ir6/7ZTqsp3nhRCY3Ppj2UM6Q?=
 =?us-ascii?Q?LksgjBckByYQytxWbRyy0nOWEtaVTJ9JRjp9+DHe1jJpf77gC2qQzJR2eOpi?=
 =?us-ascii?Q?VywKjzk2DGQgV2ZZi32FAGMAlOgxONDkNfEqwem82GxJLE/bnxjJNMm+MS4H?=
 =?us-ascii?Q?E6Uc7jtFIOVGqjIZEFSc49mAmc1BiQ/GXjPINjG2yuu5WptFuvNXnlFqmRYJ?=
 =?us-ascii?Q?5pXXzqWzh5uqtV7hraXiIPqUKauSUqJIwLh52y63PpQ3GHJ62TlUt8C+yDey?=
 =?us-ascii?Q?QVzkXqnVwbIAbBm6V0g0DjYWHIHlcmjZfzKSr7QXcvFlhyrh9PU2oGFGIPqh?=
 =?us-ascii?Q?B1YqgfAQK9M0kdRSYJrkl5uO0n6MlxCK/CtA8mwAZuJm3ry7bBWJU6PgyxaK?=
 =?us-ascii?Q?bg6D56cB4EWMdHySUc/uuVm8IUavwYTiKyutPA1W6VogSfjBfv0DoSlIzkLT?=
 =?us-ascii?Q?L5fzt5K185+RSqoAqY4oV9Da8e04k0C0ImtRQieVMLzIcqpvPD+3wxHrzlN4?=
 =?us-ascii?Q?8Ge9ESuOSVhtc3H7dcV1dkLsDNEpeD91gQPF9I+imh3JiTjYSCoa9hJdynv2?=
 =?us-ascii?Q?5PEIYPGM1p4nir0snuLwEmpHfYsGuOD0BF7nODmIHhyNsUyx+RawMLAM/2oz?=
 =?us-ascii?Q?KHTLUGVWG7aEFZry0qb0VkmKWPR/Hjz4wLhBlWr+0q+6tnVJYYTXVMGBRo5Z?=
 =?us-ascii?Q?HJbrK6iJXmU2Zb/tEPi103rr0bBPLwLBp7L0GaoXaB6fiWg08DIjk/h7xWxN?=
 =?us-ascii?Q?8cbMx5+xGtiyuO9lTmtY0TsNIFPIRs1z0nOP9Ke5xX68J73yFgjF+OSq6zUp?=
 =?us-ascii?Q?xD+z6UJMDHCD891sOd0e8Nn1vTIr8tgX1NdujkyoN2bwTWnGpPFvqlCpOW9p?=
 =?us-ascii?Q?sUhM1uaZ29m842ctQmRdhjmXb9R4HZwcWkL0ca8A17U0u0vtYi77PjLpdsVw?=
 =?us-ascii?Q?XsNdNzR02r0WZIZd385XUZdKH84Jyw+8ctoZ8hVjUbGMaNxPfAz+o0W3S7A9?=
 =?us-ascii?Q?+mQ3G3r6UAfOP48nK2jquLtxEX3pkBdjhbm3C3c2Km5R6C8LryPNak0YMaWV?=
 =?us-ascii?Q?ofFNRyr50H0q4ZBuWq5WHOXqCIFhGwnkhCDLK3wOFIRSXZqbuqQIFgk6nnvg?=
 =?us-ascii?Q?ssjX+i89hLj0azOprM9eAPJgpzgsgS89gnRZfnVm6zNK0HwtzlWLg5tIUfjb?=
 =?us-ascii?Q?e8xAjTYKJ9xD+Q6YtlcZ/wxBRSxK7W7DIwgAZHtOyu6Fku6r1UiOR19gB1p5?=
 =?us-ascii?Q?sKAgUcuVhO0JSQUAL6QBNzlVIDzq0smMMkRhx/25m/Pe008OpUix2LOWY/0Y?=
 =?us-ascii?Q?cxOiwzUOMgLIWZf24sszOUGgWRqAbAdY6+ACM++ZQAAUs4AG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: jYGqBKyYXHi+0bm16ustMC3EyADsMGRLDqNPSJb8HFpHvNBVrAXqAcxu1+jNt+JCKh44YCvL0yGWCkDZzybUbPIT3YV3WtM2Nq/PRyjlK/AuwAV4sjMMJdLBJ+cOqfS73u6/9GLpJib8IptyyK6URPZtO3QcyWSlw6oKAcpU0aEvjjy1C5H5ErXJvLIOiJJ3o89ov/paE8iXbEzBekLIIa2ebxTiviIOJiXatx68wia62PM25/83ZF4WPEVG/h34Wj/iQRNeaY9XFUYIvIJEJGig3DxmRLvfLNIvnEi+CFQCrlhmEZce+ycrSoNnoE0ETmKIvd7/fuytMhdrGoVg1w==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9009.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32f3e073-2ad3-448f-b25e-08de9440eb04
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2026 00:59:27.4670
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5UXNYJmJdQsYQm8mUZmwGsmfy7UbV0bmZrHV5iAtoHSb9bt2kQCyOq52sNF0CEekbWlRZar8fLdgdCDSNrxtvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8677
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: C2F00180003
X-Stat-Signature: sbgo37g8f9ez15df6uu76rht3m1xhr57
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775523578-613178
X-HE-Meta: U2FsdGVkX1+S9SrdJavBW5rhfEykCjmVp+e0A8Q/oEizjSxVdKZ/yPJ8IG08yzz5W157ebwn4Q5y3c1yom3oURLNSPyNzVCrM3wudj1Ge2xYEAVtYLsGEl9YCzJyMQV35ktpRGu0gcGFVWqSrWZi9wmuO/5NU1kYs69QPPZFVpk38P6Hr2OWQ/GHl9uCYSFv4LDIAW6keM8geWAcXcdPUxMeFfHOAh87rmz9LygPyMdXvUHY5hNFYiS8eKHmZHIzVowHE/EHUndTGxRX38xjGk8o0uTQgB4wJ5UzziaORMzsEelMuRl6IFHSqkr5Clvl9rPKFSWJ4K8clOsnAl7xKfAg9+t+EKP6PxuhW6lW/DZnI3x+9OPUWigfDlwlDtYvwlLmyFjiLq3j+e+VUjWsgacV0v82T3VToVO4wyrJ3ECuJ1PA/XsVKJHV0kt4S5lRRdAyZNFjPofw1RzJqxAmAQQGQI9noDrqGKRV82CJ0/lU33QeqcUja9baRtQ6Ck6BzOmwIAMUrXWGpxmhO3pzFgdqBlQ92BTyIZye9W/KdB07tYXzbHOHZlgmvCF0ivkxjlBIHGlLmnVraTHRZf9KWeMRizJf19AH8i140sp97aSrqMkMK1crbsA0mI0A92G/MgXduorHlkv1G+/YVOruH6uQtmF+JCxSK01bnuREpnsyMnL7OZREsQkmkJVmwXVJrCx5ZkC8bavCmMAon0pzVpznAtWx9fHz7p7qQ+LqjPR17RLRk1DUL7PIZAINAUjbOEzVYLvQ/De/R79991a+7yne+T+9hwyPtaFvCRiQ4HIk74/GMVQdPFNaIYs4JnqUoy3p3RfvbVKjR31qGB9Tk3vUhShjUVVCyCtt/JIq3c2pN25D7RtBXAOJ1XvhgTMtDHzZwiO18ON04B+lKnX6NBKqpFhKRB5InvYooomES49NsNQDecf5PQFyjMHkx+rkba39Nw1x8nSzPgB+Y8Z
 Mu1KrLnm
 TFl8zNkvhxtUXXUuAOI4ZDq7DduL0av/jiGSQdJtD57lwQ7abOzO2PEAqmSJbDOout9kq1nf1cRxFLGuWKjBEABXm2/wIkW4AyYVU2ZPfD97HnTVIEiTP8d4ykZj4YitkzUNlcZs9+X7YEwmENo4rlj09jINDUwdSgr6qq5W14FPNYe3D5E16lETLtmsqipH/2FIq3mQywHW489S6r5yGjFekJL9kkpZDk7ZNqRqja6ZJEuVBC5/WDraaCe3HCNcBERb6mjznZUrardZOI58wa1Vj9eZMxUnBsmF0BVySGXKIVzNjxaCpidxTAnSPmX85/q0G1Ca30PD2HePpg7giiICDwHSpgxynP+rH48rb4tvXRHhl1hhkAZiNkrVVExynguiLo60DdlqUVUwQu5KBCjVH7IlvgnEa18DjKHB0wRfG/BsPQjJQEM5TMpU3FLUJW+jqBOTPTpYJyfyKGyfdmrIda1t7CC3iRmGxKpzOeOlB+/OOpNPIvD/jkk5dkkVClsE3u7NqR6agEKcdsLXmxAYF/Rfan+YCEp2hSbuWTEyqZ2ATV3bgXlzGC7DYn8W19dpeQxeL4XEJ8VI2Hb1++vq0khuVuyF7IfeImMFIhDpnqK+fubAxsXMURtbt5/lLh+OdCBZlPchmJTgId7BybBUSAGx4okyEhU15SvtKIGRgjBQyigcgvydxy9LkK6JPBg4rk8zaV8zpdljF2yfB7x7AJ/NMAaVWNOZvjWMn8p63HNI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -----Original Message-----
> From: Mike Rapoport <rppt@kernel.org>
> Sent: Saturday, April 4, 2026 7:12 PM
> To: Liu, Yuan1 <yuan1.liu@intel.com>
> Cc: David Hildenbrand <david@kernel.org>; Oscar Salvador
> <osalvador@suse.de>; Wei Yang <richard.weiyang@gmail.com>; linux-
> mm@kvack.org; Hu, Yong <yong.hu@intel.com>; Zou, Nanhai
> <nanhai.zou@intel.com>; Tim Chen <tim.c.chen@linux.intel.com>; Zhuo, Qiux=
u
> <qiuxu.zhuo@intel.com>; Chen, Yu C <yu.c.chen@intel.com>; Deng, Pan
> <pan.deng@intel.com>; Li, Tianyou <tianyou.li@intel.com>; Chen Zhang
> <zhangchen.kidd@jd.com>; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2] mm/memory hotplug/unplug: Optimize zone contiguou=
s
> check when changing pfn range
>=20
> On Wed, Apr 01, 2026 at 03:01:55AM -0400, Yuan Liu wrote:
> > When move_pfn_range_to_zone() or remove_pfn_range_from_zone() updates a
> > zone, set_zone_contiguous() rescans the entire zone pageblock-by-
> pageblock
> > to rebuild zone->contiguous. For large zones this is a significant cost
> > during memory hotplug and hot-unplug.
>=20
> ...
>=20
> > diff --git a/Documentation/mm/physical_memory.rst
> b/Documentation/mm/physical_memory.rst
> > index b76183545e5b..e47e96ef6a6d 100644
> > --- a/Documentation/mm/physical_memory.rst
> > +++ b/Documentation/mm/physical_memory.rst
> > @@ -483,6 +483,17 @@ General
> >    ``present_pages`` should use ``get_online_mems()`` to get a stable
> value. It
> >    is initialized by ``calculate_node_totalpages()``.
> >
> > +``pages_with_online_memmap``
> > +  Tracks pages within the zone that have an online memmap (present
> pages and
>=20
> Please spell out "memory map" rather then memmap in the documentation and
> in the comments.

Sure, I will fix it next version.

> > +  memory holes whose memmap has been initialized). When
> ``spanned_pages`` =3D=3D
> > +  ``pages_with_online_memmap``, ``pfn_to_page()`` can be performed
> without
> > +  further checks on any PFN within the zone span.
> > +
> > +  Note: this counter may temporarily undercount when pages with an
> online
> > +  memmap exist outside the current zone span. Growing the zone to cove=
r
> such
> > +  pages and later shrinking it back may result in a "too small" value.
> This is
> > +  safe: it merely prevents detecting a contiguous zone.
> > +
> >  ``present_early_pages``
> >    The present pages existing within the zone located on memory
> available since
> >    early boot, excluding hotplugged memory. Defined only when
>=20
> ...
>=20
> > +/*
> > + * Initialize unavailable range [spfn, epfn) while accounting only the
> pages
> > + * that fall within the zone span towards pages_with_online_memmap.
> Pages
> > + * outside the zone span are still initialized but not accounted.
> > + */
> > +static void __init init_unavailable_range_for_zone(struct zone *zone,
> > +						   unsigned long spfn,
> > +						   unsigned long epfn)
> > +{
> > +	int nid =3D zone_to_nid(zone);
> > +	int zid =3D zone_idx(zone);
> > +	unsigned long in_zone_start;
> > +	unsigned long in_zone_end;
> > +
> > +	in_zone_start =3D clamp(spfn, zone->zone_start_pfn,
> zone_end_pfn(zone));
> > +	in_zone_end =3D clamp(epfn, zone->zone_start_pfn, zone_end_pfn(zone))=
;
> > +
> > +	if (spfn < in_zone_start)
> > +		init_unavailable_range(spfn, in_zone_start, zid, nid);
> > +
> > +	if (in_zone_start < in_zone_end)
> > +		zone->pages_with_online_memmap +=3D
> > +			init_unavailable_range(in_zone_start, in_zone_end,
> > +					       zid, nid);
> > +
> > +	if (in_zone_end < epfn)
> > +		init_unavailable_range(in_zone_end, epfn, zid, nid);
> >  }
>=20
> I think we can make it simpler, see below.
>=20
> >  /*
> > @@ -956,9 +986,10 @@ static void __init memmap_init_zone_range(struct
> zone *zone,
> >  	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
> >  			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
> >  			  false);
> > +	zone->pages_with_online_memmap +=3D end_pfn - start_pfn;
> >
> >  	if (*hole_pfn < start_pfn)
> > -		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
> > +		init_unavailable_range_for_zone(zone, *hole_pfn, start_pfn);
>=20
> Here *hole_pfn is either inside zone span or below it and in the second
> case it's enough to adjust page count returned by init_unavailable_range(=
)
> by (zone_start_pfn - *hole_pfn).

Get it, I will refine it next version.
=20
> >  	*hole_pfn =3D end_pfn;
> >  }
> > @@ -996,8 +1027,11 @@ static void __init memmap_init(void)
> >  #else
> >  	end_pfn =3D round_up(end_pfn, MAX_ORDER_NR_PAGES);
> >  #endif
> > -	if (hole_pfn < end_pfn)
> > -		init_unavailable_range(hole_pfn, end_pfn, zone_id, nid);
> > +	if (hole_pfn < end_pfn) {
> > +		struct zone *zone =3D &NODE_DATA(nid)->node_zones[zone_id];
> > +
> > +		init_unavailable_range_for_zone(zone, hole_pfn, end_pfn);
>=20
> Here we know that the range is not in any zone span.

Indeed, the range here does not belong to the zone span.=20
Thank you for your review.

> > +	}
> >  }
> >
>=20
> --
> Sincerely yours,
> Mike.

