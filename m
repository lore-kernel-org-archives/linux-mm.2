Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACBB7C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 17:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7541C6B0088; Thu, 24 Sep 2026 13:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72A9D6B008A; Thu, 24 Sep 2026 13:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CCA16B008C; Thu, 24 Sep 2026 13:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2BFEF6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:54:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A706BC0465
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:54:42 +0000 (UTC)
X-FDA: 85249406004.12.8E724FC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf04.hostedemail.com (Postfix) with ESMTP id 13DDC4000A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:54:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=intel.com header.s=Intel header.b=Evpi+dvA;
	spf=temperror (imf04.hostedemail.com: error in processing during lookup of ehab.ababneh@intel.com: DNS error) smtp.mailfrom=ehab.ababneh@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790272471; x=1821808471;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dqFgKQUrdzyeOlv4Fw9To054gJh7k8801RoIUWeoau8=;
  b=Evpi+dvAy4vvV7P/bPixGxdRYErE+sMzPLQp2I+DvqvjUYMDv8HrPN5k
   l62w+b7GmSoeO8sPvPYLkDDPenESz7xTUZrGCKeBNfMFIsbCOZaf6sXUj
   m/j3YiX3DnPPcwcyzqpFS9fZwWbrbHBaNLPTTowHjpmwIHlWEdcDtxyoP
   L39Xqqz3eu9+gJXHDzvcXqgbl91x/g2NQ1C12Ixealj+Qh1sHRu/aP7Ru
   DCfzMWpIxQlasDN6pdoOVvQqVyxyjvrXqObWw74FIKpVCFh71Bgb7jnwW
   IxG8mBJ5veGHjnaSZHGYbo5VnPBvriuUTvoKGjziOxjxTVhFDYz8O6vRY
   g==;
X-CSE-ConnectionGUID: TB0+Fw/BQBCSEC/Hr505+g==
X-CSE-MsgGUID: N6E3OQdnTfynzPO5sZx3kg==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="89916958"
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="89916958"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 10:54:17 -0700
X-CSE-ConnectionGUID: Nyt2QovvQaGO6mmGRiSsvQ==
X-CSE-MsgGUID: Z6QvoKExQbSMaDfdxJLywg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="273196494"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 10:54:17 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 10:54:16 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 10:54:16 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.70) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 10:54:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pOs6He7rPUlm0N1ViWKeSbAWqJ8Zg3R2ZCbuAlceTphgYHJp2Vboz5b4G8VQj8ROWjnp8gAwAXLWuNn6dLD86vncBGieGzi8YASE3kiKwPi/FHUIpV2eCReUKwhhNcSKTciNplPCqX0DjTNpKbwSCvBUfOq8+ecgBT+ow6GnSElRSmuOruFG1A6PLoWjDei9i3Veq8aR4+uNPM6Ty8dTYehhs9e8OYdt5DWXvQjtvgiZ2sd2g50d7/OguiLBpJLy72nEN/MRtEy+RVshrbf3OGBTI/VjVAnjm6B2K+1nhO88zudXZJQlPDQyf3mXHD+9H2wkA/ITYiMQrHK4oj/99g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dqFgKQUrdzyeOlv4Fw9To054gJh7k8801RoIUWeoau8=;
 b=ZmwnirnkIwaYpWOTDoMYjhLSV8heOw0Dgb7uNRTd06Y68wwhN2ozys63HaebZPWncxmjXw+YpOF50R2CZn/YLuulV5Vw9A4lcfSwOEqeB2IP55is3g+u0TSSDJavzHs3Cr6eVWffjwzJ2VZ/nJO+XMFfBmwdsS6648yqH0k8rkHBQebDBI3Ejmgi7joI1RAP1qmCOzt2QP6fAeHhS4sda+sPbaO5TLQEFDXW0dI1MP11abLpq9NfM/xjKzHw8hd8Dqnm4DCEfnkPwTSvLVkRQCmrYPHtY+zesN9P6WhZIR46oWZSyfZDh8cqYfv0/Hj8LYLAvAQl/6LWxWGq3deapA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6105.namprd11.prod.outlook.com (2603:10b6:a03:48c::21)
 by MN2PR11MB4582.namprd11.prod.outlook.com (2603:10b6:208:265::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 17:54:14 +0000
Received: from SJ1PR11MB6105.namprd11.prod.outlook.com
 ([fe80::28d9:5273:4572:320d]) by SJ1PR11MB6105.namprd11.prod.outlook.com
 ([fe80::28d9:5273:4572:320d%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 17:54:14 +0000
From: "Ababneh, Ehab" <ehab.ababneh@intel.com>
To: Barry Song <baohua@kernel.org>
CC: "ryncsn@gmail.com" <ryncsn@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "axelrasmussen@google.com"
	<axelrasmussen@google.com>, "kasong@tencent.com" <kasong@tencent.com>,
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "weixugc@google.com" <weixugc@google.com>,
	"yuanchu@google.com" <yuanchu@google.com>, "yuzhao@google.com"
	<yuzhao@google.com>
Subject: RE: [RFC PATCH] mm/mglru: dynamically protect readahead fault folios
 under refault pressure
Thread-Topic: [RFC PATCH] mm/mglru: dynamically protect readahead fault folios
 under refault pressure
Thread-Index: AQHdOjxqaRSPWT3KQUCvH7lHJPZvdLa6CN8AgAA+YQCAAYnQ0IAABs2AgAAAX2CAIV5sIIAACU+AgADjkEA=
Date: Thu, 24 Sep 2026 17:54:13 +0000
Message-ID: <SJ1PR11MB610584E71CD980C9F85952F38C812@SJ1PR11MB6105.namprd11.prod.outlook.com>
References: <apcVhWzEwkwHYjB1@KASONG-MC4>
 <20260901220430.79810-1-baohua@kernel.org>
 <SJ1PR11MB61051CC2791B67C97BEB2D4B8CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <CAGsJ_4yRJnr4xXdokVHu85b7XPe0p6rZ+Lzv4sE_gCWdOF4YAw@mail.gmail.com>
 <SJ1PR11MB6105505CAF620B23978FBEF18CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <SJ1PR11MB61057EF65B62E06E2C2049008C812@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <CAGsJ_4yHZ5ck1hk+Lo-7aQudApm0Nx=4yssUDrRTz681PuW=tw@mail.gmail.com>
In-Reply-To: <CAGsJ_4yHZ5ck1hk+Lo-7aQudApm0Nx=4yssUDrRTz681PuW=tw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6105:EE_|MN2PR11MB4582:EE_
x-ms-office365-filtering-correlation-id: 67a4385d-a258-4698-4adc-08df1a64d871
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|4143699003|10067099003|11063799006|56012099006|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info: 37OgirdiM8ksIdezmhBIq/AvJMBnJWZRpE89G4s4KRA2TnmPv05yjo0j0YRuQ0mgFNUqQalkyQ8rT2g5aJ2xfacZcNTERblug8EJzku/y0A+HFBWalIvPLDli30oVT91Lmr+1N1ajPSexA4q5MQxYx3fvhWtk9yDXfFfMT4D9m4vcjfPwYAudkVnbUrQpqiaWksvAAjfmyY+ibsXitNFbptlaHMFwDewMmURDFrHJ3ej29ThoEwTknTMNOEfpG8mdI6ICuBUQLF76I4E2VMeRV20CWXe7u0b64LL14x0Z07qlWLnwu6jwoWZRPvJZ81O6A/aOi6OqpO13qW4pd5lDqOodoa9hU3ajbzIPmuNoVtmI1cy1ReNSpK7Mby4VZ5/o4JVP7JJjxS7+pI39zRgQoUo+rXiyNxa+/8ohgSQ1kSP/TkwBL3G6SuoynMxp5wDUjrEhJLo71OhKucbIvGFOZPXWj3jyHCCqbkb8VwpB+YvUVwCUAf15srENgQ+tDum9KdCxkV5Rn1XZ+23CNcnxjfqoZAKatPuvevJMTjyZ6mJqFHMnkQErSf4e5Gg/1MyhAvN9KSYEnsoThNBMELgJ67lrR7aq0DvA6OQN0YvxJAQ/YJpRS1k8Y6K8suYsiAkSIZ8woKIt0kt9YPf5hS7zapZ5eEgo6ig3Hm63bIaSci0q2Gh2sh3geabipNyPkXg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(4143699003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDZxMC9UYTA2ekJFYTZxYW56RE5FYjAxRjlxOE1LcHdla3VLbldtZHJCTy82?=
 =?utf-8?B?dTlNbVZxNkJFRUJPaDNwS0o2K1JyVlA2NTIvd0xpLzB1VXk3UC82czc3aGVI?=
 =?utf-8?B?d0pNZDBHcXZkcTgrR2U4MEsyb2JodFcvbEJCRUk3aGNmRUhJWUg3a0FRTG9R?=
 =?utf-8?B?VzJOODNVY0lONkxqU09CMmNNNjl1QXUydWZFNkwzdnlETk1mUTd3WlBuYnNQ?=
 =?utf-8?B?MUpiMWV1UUNaSkpFa3ZLdGl5cW1QYjQyV2tnaFBTNG1NZ2U2aFNRZnlPOTRB?=
 =?utf-8?B?NmFmQkc1anZ5ZG9jZWdhTHd1T0pXcXRHazNNNXJFZU0rUE1wMitGdjJtcEU1?=
 =?utf-8?B?cXlqR0ZHTUVNMWZtVVVub2p1M3E1WFRPdmU1bWVBcTI0akJTZmozTDM0WEls?=
 =?utf-8?B?VU9ETjJsM0JrbU5nK1VKSFFFdnFPa1pCQWsxMUJoaks2SkJVYVFIemhYVzc3?=
 =?utf-8?B?SzJ2SEJBN0N0WDZCd3oySDFBVDNRSTNpanozYSs0VGlCenBDOFJxSEh5ak5u?=
 =?utf-8?B?b0xnQVUyYnpwTDNoWERnVnEyZGhoUVNmUFpTMnBMQThjS1hnTEwrOW9zaFdu?=
 =?utf-8?B?OVRvS2VVSyt0dWM1SlRPcTNvSll4bVFiYUhGSHhqaWVPSDV6R2g4OUx4MnFT?=
 =?utf-8?B?QkI5SFh1dE9sRWV6L3VEN2ExTG8xUWtjTmZTcTVaeE52YmJaVE1wY3dSUGE1?=
 =?utf-8?B?RWRzMTl1bXY0dDJGSlB6OFBra0Juc2xUYlZQdCtUbkhMdnFRQ1JMZ2hHVU1m?=
 =?utf-8?B?YmIvcUdKU2JTNXVDeWlkWi9sYzBFelRPOUkxWlhPMDBMVXArRGx6bmM0SE8x?=
 =?utf-8?B?Q09kZ0s2RVBMSnIweGw3Tm5KS0xoM290MVZqQXZZNEZTMnhhWVpSbHJWTFR2?=
 =?utf-8?B?Y1daRzlUYTVmRHhFVTdFOGE1RnN4dFdrd1Y4Wi9MR0hOVURLWTRYRDlYNDFY?=
 =?utf-8?B?T1RGRHB4SWpuMHg2TEpydTZmcTJLU2wwa2xJbGRnbksvdDY4dms3dEc5QVRE?=
 =?utf-8?B?dkFNYmo1MnhZT0g3bUR5aHBmNEZ2bU5mMnhOU3g3dmc4RTM2cUI1RkZja3Bz?=
 =?utf-8?B?d1ZQNmcramR6dTFrZVY4cExZSy9leFovc2pyWUxkYkhqZS9leDFPKzVhaFNU?=
 =?utf-8?B?RG9JMFl2ZlZLbzNFb3pReGR6YytueUpNU3pkOEFndTdmbUJHMkdJZ1NRcVF2?=
 =?utf-8?B?QjVIN3VJa3puT253cU1YOVZaU0xWUHRJS2M1MVNPSGUzeGRoWHE2N2Y0Yldr?=
 =?utf-8?B?ZDlhZU9KR2pOU205MTdxbklhOFI1Q0xwUTBIS1JsUTlYa2Q2eEZMcWF2TmJh?=
 =?utf-8?B?alpOYzgyQU1QMmtHRnh0bEZUeGZObUFVZytwK2tDckQxQU0zanZBdTdwcDBa?=
 =?utf-8?B?UnpmbmRBN051VHFKTlZhZ1BzV1NPNy82OGxxL0J5RlV2ZzJsczdKM2hYWlcr?=
 =?utf-8?B?ZUFZYzRtdWg3NUd3VGZnWFA3eDlTdThRZXJpQ0xpTloydEZ6aUYzYXZ3K2dH?=
 =?utf-8?B?N01weStNMXVxNUFJbEI5eHF1eWtCSjQxaHRTek00d1JFZUw2WVZhMkt5NHJL?=
 =?utf-8?B?dkxvOXp3VWd1b1RORm9WbXUvZ3Rvc0d6SUJoSnlSNHRnTTdreVFlMnlIc0ZP?=
 =?utf-8?B?OXFHQ3k1WUVVSG85VlFSN2hpN2RXMWJ2dkk4NUhZOENxdSt4OVhOb3YvSjEx?=
 =?utf-8?B?eWJmOHJTaGRVdE1CeTJSMDZRMkRYYlZDNGdWNzRmQkZSZG9WelN5cjgwUHpL?=
 =?utf-8?B?V0NHa2lmalFBT3oxT0c3azNXamw0MXNiSEFJN0pyZW1nOEphOUo0TERYd1VJ?=
 =?utf-8?B?bHRaVDJ3U1U3U2dXRUozRkRpbGNWZXhuWHp6RkFIc3U2OFR5KzB6N0lXcng5?=
 =?utf-8?B?MzZ6K016MHBsQ0NKckhFRHJBZUl3RDRxdTloK1BNSnVaclJKZmdyVDBhU0Nj?=
 =?utf-8?B?NzRucWluNXFqSzNQbUxxVjVCSXRnYUlGeElyKzVLb1RLOXprNWhORmJXRFlP?=
 =?utf-8?B?TDM0aXVpQW9hVVdxeUIrRmgzTW9QelNvL290SEVGRjVsT1hqVUpvUjNVYjVD?=
 =?utf-8?B?ZjNuV1JLSTZVMkY4azUzN015eXZRNFFqUU5pdFAzdWwza0E0UDhDRGVVYit5?=
 =?utf-8?B?WnMrb0oveEtNQTZZSURUUVB6V2Z1L3dXakN3WnpEYjJJNVh1bkI2Z3ZsdHpt?=
 =?utf-8?B?cTdwaVFLR0FhQzRvRVEvNE5tYloyQzhFaUhYaGJBWW5CZGFPdVRSWmdvTmRm?=
 =?utf-8?B?d2V6T28ybWhEcUhnS2VmMUl6MWJLa0ZHdnRZODZEMXJDb2lORk1oUnlUZVFM?=
 =?utf-8?B?SDZNTElrU3dIWVBZTWtMTnBYOENSOTdqWlA0V3dtWEFjYUd1MzYwQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: yQhjXTCg+aQDfJhmbtdvvd4wr4pokmSwNvnWJ33ajXQuQpc5hQaqSmbRdVYgcKjpW0o3Bn0auBuDhOBCTrehTXwjEno2remPmk7ZN8xUIY+VyuMH0qsVqyGVAzWdVD1Ia8kYoqMUVBJhDISZTYRv08xK5Kusm5Qo/lXTN0W9VrrA66Etju4aQgHIPTbAGyubLmoE+CYRvpOHhYHvawg3aR6ZeQpqi3KNt/oIplba8zxrCEsAQoKJuGvtrLB/9oFOfpUqCmIBQ3VgeppfguHrrgfe2p0y0cwwo7L1GdzbY3cXBqahBeEQwpCuKjNCUfLGtXUudMmyhF4cc3KPjmw8OQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67a4385d-a258-4698-4adc-08df1a64d871
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2026 17:54:14.0118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 456NjjHrGL+7UOrGKDDyVy9tQN+Be7SX9Z2ITMhcPiPbinllYiNZuwLyaSeqNqy70TzKHcAjT7gM6TDDNMGVZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4582
X-OriginatorOrg: intel.com
X-Stat-Signature: rtsdxcfr9xsdoz1t139hk9fojfnckyix
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 13DDC4000A
X-HE-Tag: 1790272470-459962
X-HE-Meta: U2FsdGVkX1/NLDOtZubBoH8KjeHVXr4VXd/wcq7Jo2rl3R0FTiweXID+4AabyqqgUYHVw/B0doJlAdlz5sHyKh+jVpEM6EUwUlaXjsDkYcykFf0vR/0q3N8vmMcE589St9d1YxfrMjmMufQZZ2uP8oEwxqMBDPKlB6tguIa59vNeQRl1JpgxcopVdv6xafjU8TuKjXIa4OJso8UDrxCfNr290aE3gEji5xC5HHfP0j8lMRUisULULlfYb3LM40hpVaB8flJSB7W7LNfH7xIIP7Qc304WWzjQp9Gcj274HJ3esU/qO9AZJsHlC60c83eeIj/jcy4IMLm1szjJ/cZyx3DScswej0O1CThXI/trv9Ff0arvCTxoHaM4FnrtyIeEPm4s8+LVx1XuqrzhrZ8B965eXrpznejEvO/ZlXAAM5CrDQaSApAmG1ebjV++lLKvUfT1jdW4KvhX4RzUJM0NoHPasCOsyWixx+I9IDlbg3Oe5OB2zbTia66mhLnHUxaMcAW3OFfs0oSx6QunaTnrTCSd9VTSTCLjuyz28khEe26STEJpi2/E+wwh1CW5jBeBgtYYMGN8P/QZ8Qaa5JNYAaXFVCu4bv+QCpSThjZhpEifC7KmnLM4Pdd7V2u7uuA0t4p1rTkKHDan/dSwJElDzjewdsb+dLYxmThagPz70arR7X/HMshUE/7htyycmDucKLTtlcksAVAPG+4KLjJmxGXJjsaqSiyJpAM2j4X0DUcea/7vkSKtYmQg1nwnAL0kVYeen8JV+E5vE0MInsK2WvvaqBK2r+Z0pa8lC5LmkOIowLQxg3HuVjwBLDY0UsPzvbpHp4fGG976iUGSZ4MYy/j8AWOAyn77jGhDNWHv1z5A1hkzUuvs1jz4F4ddRNavKAi8MEEVV4ZKQ4N3Iyk2YkS1DQIrha20XxjA7AAoYKaXaO9XQnLZliFNzcKqvrBvyhZE3mo4IRuryy3gKIb
 Jz3GiuIo
 bG+qJ4Oe3AvMez5/IsqOT9BmcqW0EI9OVNs+o/pZulL2PbgHAyPPENzo4D8zG3+0FWJXD3DK3PgKLylM9jxemRqpdlz+6B49tsAPu4S5/NvTn57QXE7DhSJKV0g0SI5xHq1ReA4oPH5VX8wJ++FSqYLfMuG3czorJIi+bAI40jdInnE06V1c2ezQ9XhN4H0UxHR7/TcbQsdcP0Je1FRG1qnUr2YGezQ/H4FHa6R4h9Xk2MWC1i7iwTuf8yZPCm/nQnd4U2YZmmdlvsk/QerTjKI+DXnD09q5j+KukEef3bMAnoEbZ2w3CgY984VzucWBKxP/UlAxFizpJzjfqXab6tKXVTZYFpJCTTSY2oIuHE2oMfzaotl9MQzgSN0Hh0jfIoEp/cXtPODiACCzeslT4f1MQmKC1gr2I/nUCYoAhkjpOwEA/GokE4HBDP+X3h/S4/7e/TnPMpMaOKWA9DljzZ7v2MMio8t5OHfyBunFDkpDkcX2nOo8OFvHQP4yj6dO8u9ljT+zKIyNTZh/QfKJ95enbrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgQmFycnksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmFycnkg
U29uZyA8YmFvaHVhQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IFdlZG5lc2RheSwgU2VwdGVtYmVyIDIz
LCAyMDI2IDk6MDggUE0NCj4gVG86IEFiYWJuZWgsIEVoYWIgPGVoYWIuYWJhYm5laEBpbnRlbC5j
b20+DQo+IENjOiByeW5jc25AZ21haWwuY29tOyBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnOw0K
PiBheGVscmFzbXVzc2VuQGdvb2dsZS5jb207IGthc29uZ0B0ZW5jZW50LmNvbTsgbGFuY2UueWFu
Z0BsaW51eC5kZXY7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LW1tQGt2
YWNrLm9yZzsgcWkuemhlbmdAbGludXguZGV2Ow0KPiBzaGFrZWVsLmJ1dHRAbGludXguZGV2OyB3
ZWl4dWdjQGdvb2dsZS5jb207IHl1YW5jaHVAZ29vZ2xlLmNvbTsNCj4geXV6aGFvQGdvb2dsZS5j
b20NCj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0hdIG1tL21nbHJ1OiBkeW5hbWljYWxseSBwcm90
ZWN0IHJlYWRhaGVhZCBmYXVsdA0KPiBmb2xpb3MgdW5kZXIgcmVmYXVsdCBwcmVzc3VyZQ0KPiAN
Cj4gT24gVGh1LCBTZXAgMjQsIDIwMjYgYXQgMTE6NDPigK9BTSBBYmFibmVoLCBFaGFiDQo+IDxl
aGFiLmFiYWJuZWhAaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+IEhpIEthaXJ1aSwgQmFycnks
DQo+ID4NCj4gPiBBcG9sb2dpZXMgZm9yIHRoZSBkZWxheSBpbiBnZXR0aW5nIGJhY2sgdG8geW91
IHdpdGggdGhlc2UgcmVzdWx0cyDigJQgbXkNCj4gPiB0ZXN0IGVudmlyb25tZW50IGdvdCBjb3Jy
dXB0ZWQgYW5kIEkgaGFkIHRvIHNwZW5kIHNvbWUgdGltZSByZWNvdmVyaW5nDQo+ID4gaXQgYmVm
b3JlIEkgY291bGQgcmUtcnVuIHRoZSBiZW5jaG1hcmsuDQo+IA0KPiBObyB3b3JyaWVzLCBFaGFi
LiBBbmQgdGhhbmtzIHZlcnkgbXVjaCBmb3IgeW91ciB0ZXN0aW5nIQ0KPiANCj4gWy4uLl0NCj4g
DQo+ID4gPiA+ID4gSSBhZ3JlZSB0aGF0IHJldmVydGluZyB0aGUgY29tbWl0IHRoYXQgY2F1c2Vk
IHRoZSByZWdyZXNzaW9uIGlzDQo+ID4gPiA+ID4gbm90IHRoZSBvcHRpbWFsIHBhdGguIEkgZXhw
ZWN0IHRoZXJlIGFyZSBtYW55IHdvcmtsb2FkcyBhbmQNCj4gPiA+ID4gPiBzY2VuYXJpb3MgdGhh
dCBiZW5lZml0IGZyb20gdGhlIGJlaGF2aW9yIGludHJvZHVjZWQgYnkgdGhhdA0KPiA+ID4gPiA+
IGNvbW1pdCwgc28gcmV2ZXJ0aW5nIGl0IGNvdWxkIHVubmVjZXNzYXJpbHkgcmVncmVzcyB0aG9z
ZSB3b3JrbG9hZHMuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBJIHdpbGwgcnVuIHRoZSBDYXNzYW5k
cmEgYmVuY2htYXJrIHdpdGggS2FpcnVpJ3MgTUdMUlUtRkcNCj4gPiA+ID4gPiBwYXRjaGVzIHRv
IHNlZSB3aGV0aGVyIHRoZXkgYWRkcmVzcyB0aGUgaXNzdWUgSSBhbSBzZWVpbmcuIEkNCj4gPiA+
ID4gPiB3aWxsIHNlbmQgdGhlIHJlc3VsdHMgd2hlbiB0aGV5IGFyZSByZWFkeS4NCj4gPiA+ID4g
Pg0KPiA+DQo+ID4gVGhhbmtzIGZvciB0aGUgcG9pbnRlciDigJQgSSBnYXZlIHlvdXIgTUdMUlUt
RkcgZml4IGEgdHJ5IGFnYWluc3QgdGhlDQo+ID4gc2FtZSBDYXNzYW5kcmEgcmVhZCBiZW5jaG1h
cmsgSSB1c2VkIGZvciBteSBwYXRjaCAoNCBub2RlcywgNzIwcywgMTAwDQo+IHJlYWRlcnMpLg0K
PiA+DQo+ID4gUmVzdWx0cyB3aXRoIE1HTFJVLUZHOg0KPiA+ICAgT3AgcmF0ZTogICAgICAgICAg
ICAgICAgICA1NS4wayAtIDU2LjVrIG9wL3MNCj4gDQo+IEkgbm90aWNlZCB0aGlzIGlzIGV2ZW4g
aGlnaGVyIHRoYW4geW91ciBkeW5hbWljIHJlYWRhaGVhZCBmaXg6ICJ0aHJvdWdocHV0DQo+IH41
MS45ay01Mi43ayBvcC9zIg0KPiANCj4gSXMgdGhpcyBhIHJ1bi10by1ydW4gdmFyaWF0aW9uLCBv
ciBpcyB0aGUgaW1wcm92ZW1lbnQgc3RhYmxlIGFjcm9zcyBydW5zPw0KPiANCg0KWWVzLCBJIGNh
bid0IGV4cGxhaW4gdGhlIHNsaWdodCBnYWluIGluIHRocm91Z2hwdXQgYnV0IGxvc3MgaW4gbGF0
ZW5jeSBjb21wYXJlZA0KdG8gbXkgZml4LiBJJ2xsIHByb2JhYmx5IHN0dWR5IHRoaXMgaW4gbW9y
ZSBkZXRhaWwgd2hlbiBJIGNhbiBkZWRpY2F0ZSBzb21lDQp0aW1lIHRvIGl0Lg0KDQpUeXBpY2Fs
bHksIEkgZ2V0IGEgdW5pcXVlIHJlc3VsdCBpbW1lZGlhdGVseSBhZnRlciBhIHJlYm9vdCwgYnV0
IHN1YnNlcXVlbnQNCnJ1bnMgYXJlIHZlcnkgY29uc2lzdGVudC4gVGhlIHZhcmlhdGlvbiBpcyB1
c3VhbGx5IGFyb3VuZCAwLjEgbXMgZ2Fpbi9sb3NzIGluDQpsYXRlbmN5IGFuZCBhcHByb3hpbWF0
ZWx5IDEwMC0yMDAgcmVxdWVzdHMgcGVyIHNlY29uZCBpbiB0aHJvdWdocHV0LiBJDQpkaXNjYXJk
IHRoZSByZXN1bHRzIGZyb20gdGhlIGZpcnN0IHJ1bi4NCg0KPiA+ICAgTGF0ZW5jeSA5OXRoIHBl
cmNlbnRpbGU6ICA2LjggLSA2LjkgbXMNCj4gPg0KPiA+IEZvciByZWZlcmVuY2UsIGhlcmUncyB3
aGVyZSB0aGUgb3RoZXIgdmFyaWFudHMgbGFuZGVkIG9uIHRoZSBzYW1lIHNldHVwOg0KPiA+DQo+
ID4gICBSZWdyZXNzaW9uICg2Y2JkZDk3MjZmYjUsICJtbS9tZ2xydTogdXNlIGZvbGlvX21hcmtf
YWNjZXNzZWQgdG8NCj4gPiAgIHJlcGxhY2UgZm9saW9fc2V0X2FjdGl2ZSIpOg0KPiA+ICAgICAg
IHA5OSB+OS4yLTkuNSBtcywgdGhyb3VnaHB1dCB+NDEuOGstNDMuNmsgb3Avcw0KPiA+DQo+ID4g
ICBSZXZlcnQgb2YgNmNiZGQ5NzI2ZmI1Og0KPiA+ICAgICAgIHA5OSB+NS41LTUuNiBtcywgdGhy
b3VnaHB1dCB+NTEuOWstNTMuMWsgb3Avcw0KPiA+DQo+ID4gICBNeSBkeW5hbWljIHJlYWRhaGVh
ZC1jcmVkaXQgZml4Og0KPiA+ICAgICAgIHA5OSB+NS44IG1zLCB0aHJvdWdocHV0IH41MS45ay01
Mi43ayBvcC9zDQo+ID4NCj4gPiBTbyBNR0xSVS1GRyByZWNvdmVycyBtb3N0IG9mIHRoZSBsYXRl
bmN5IHJlZ3Jlc3Npb24sIGJ1dCB0aGUgcmV2ZXJ0DQo+ID4gYW5kIG15IGZpeCBzdGlsbCByZWNv
dmVyIG1vcmUgb2YgaXQ6IHA5OSB3aXRoIE1HTFJVLUZHIGlzIG5vdGljZWFibHkNCj4gPiBoaWdo
ZXIgdGhhbiB3aXRoIHRoZSByZXZlcnQgYW5kIG15IGZpeCAoNi44LTYuOSBtcyB2cyB+NS41LTUu
OCBtcyksDQo+ID4gdGhvdWdoIGl0J3Mgc3RpbGwgYSBiaWcgaW1wcm92ZW1lbnQgb3ZlciB0aGUg
cmVncmVzc2lvbidzIDkuMi05LjUgbXMuDQo+IA0KPiBXZSBhbHNvIGhhdmUgdGhpcyA6DQo+IGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LW1tLzIwMjYwOTAxMjIwNDMwLjc5ODEwLTEtDQo+
IGJhb2h1YUBrZXJuZWwub3JnLw0KPiANCj4geW91IG9uY2UgcmVwb3J0ZWQgaXQgYXMgOg0KPiAi
dGhyb3VnaHB1dCB3YXMgYXBwcm94aW1hdGVseQ0KPiA0OS40SyB0byA1MC4zSyBvcHMvcywgYXZl
cmFnaW5nIGFib3V0IDUwLjBLIG9wcy9zLCB3aGlsZSB0aGUgOTl0aC1wZXJjZW50aWxlDQo+IGxh
dGVuY3kgcmVtYWluZWQgYXJvdW5kIDcuMCB0byA3LjEgbXMiDQo+IA0KDQpZZXMsIHRoaXMgaXMg
ZnJvbSBiZWZvcmUgdGhlIGRhdGEgd2FzIGNvcnJ1cHRlZC4gSSBnZXQgc2xpZ2h0bHkgZGlmZmVy
ZW50IHJlc3VsdHMNCndpdGggbXkgZml4IGFuZCB3aXRoIHRoZSByZXZlcnQsIGJ1dCB0aGUgb3Zl
cmFsbCBwYXR0ZXJuIHJlbWFpbnMgY29uc2lzdGVudC4NCg0KVGhhbmtzLA0KRWhhYg0KDQo+ID4N
Cj4gPiBIYXBweSB0byBkaWcgZnVydGhlciBpZiB1c2VmdWwg4oCUIGxldCBtZSBrbm93IGlmIHlv
dSdkIGxpa2UgbW9yZSBkZXRhaWwNCj4gPiBvbiB0aGUgbGF0ZW5jeSBkaXN0cmlidXRpb24gb3Ig
YSBsb25nZXIgcnVuIHRvIGNvbmZpcm0gdGhlc2UgbnVtYmVycw0KPiA+IGFyZSBzdGFibGUuDQo+
ID4NCj4gDQo+IFRoYW5rcw0KPiBCYXJyeQ0K

