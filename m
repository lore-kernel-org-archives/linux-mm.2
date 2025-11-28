Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AE40D116E2
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 16:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 962336B002B; Fri, 28 Nov 2025 11:47:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912326B002C; Fri, 28 Nov 2025 11:47:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801A76B002E; Fri, 28 Nov 2025 11:47:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 704AD6B002B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:47:32 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1AB831606CE
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 16:47:32 +0000 (UTC)
X-FDA: 84160596744.11.B8AE314
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf08.hostedemail.com (Postfix) with ESMTP id B3D2F16000E
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 16:47:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KmAZ4sqi;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of jan.sokolowski@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=jan.sokolowski@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764348448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7IzoeqO6yT+n7HBQVouCQ3uIYtIcZmnzbXaGfirnH6M=;
	b=nwu22H0akQjvz+wHnufNeWMBhpiZZJIMGatpNuUVPIVCCjUg9OdqJbTjUjfwtI4QKOYnJP
	zEgKr3gJ3jQErIzNULesXgh8wBKAYhjBW4vqfeNhMl8g6OkqO5SJgbk1ClKHXZxZJJWrp6
	kkBdekDx+aPikvW5LeGJ+qpOdMF/cwU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764348448; a=rsa-sha256;
	cv=pass;
	b=PcrmSXqVnhNOLgavB3q2qmTCJ5qPCvCMip+0xGgsazXOMKXpQcR+osyTeXnhN4qDid+dVG
	EXcL/W5lXRzORtk9slpOwk4+tQGVBM62OBnGZ2/HZRiR8ADSyCLvU6O5HjAkrZ2n1ENXa4
	eZuFUe36HUXwL181Q/khemvwiSuu+wg=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KmAZ4sqi;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of jan.sokolowski@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=jan.sokolowski@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764348448; x=1795884448;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QNkclCEIX88UnR/guwyP1vJgoB+uoDRA3Q+ZK0PTn1Q=;
  b=KmAZ4sqilhceb+zqjWD8M/7lvxCC60Duxob87YjTVCWD0MPUiX2F/+ch
   tRXfa6fPss/ePGGIKnY5rCJLwJGNYdd422Wk7BtcOC1D4oZFdz30yI75X
   RFfMeRqozrlflyL4VGNE/a+bZeHxzc9sEZIUVHVQIYV9RXKoNIFrtfDKB
   +8uNYIB2xuTZQZJgMYRo6fClBI3tvSKCGFh+qjU4nrYHjYhwA4b7y5m+r
   /3+TGugAQLOcS3QauMm2xCesWVo9bBKeHDi2mSbdi5dp2pmYpR80tF5Fj
   H4EIKLYuVYI92BmPenII22QtMPu5oCR5AjWi5gp9n/jTkZ/98N/8/eIbn
   g==;
X-CSE-ConnectionGUID: l1pTMaPLTzim2jgwzFXnJQ==
X-CSE-MsgGUID: QTg5/rIHSkimC+t3DwzyNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11626"; a="66412138"
X-IronPort-AV: E=Sophos;i="6.20,234,1758610800"; 
   d="scan'208";a="66412138"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2025 08:47:26 -0800
X-CSE-ConnectionGUID: MPCNYOumQLGM0q6uKzRMlQ==
X-CSE-MsgGUID: dtgcb6JqSWiw2OO6DV0JEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,234,1758610800"; 
   d="scan'208";a="198438147"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2025 08:47:26 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 28 Nov 2025 08:47:25 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 28 Nov 2025 08:47:25 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.48) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 28 Nov 2025 08:47:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QtljXMZUDXlCpkZ2NvKtkCiSvF50gG1IZza++7ScWBem9ibkffZd91xTXf2KmFObnnDuTGA6uYWl5+R6h0TknIfbmXO6GCXlmMI+Es0GY5U4F4ks/w2D7oi3W1EVGx4N/cmICm6utqNL+lXLqBBf6u7A6hW/UMIIQavWsLM1Tpo54WfXRyzPFZShYHhrLKHCTuFN7rkfJePSqU1R+uoNZZJPAxa3tZ9MWE69S+5dV1M5XRKMq+uTaHqjgh+KRpUTi6jLrEmbZcJi8MnXQUAHlZzrvgN6vlQUCv9kDr8ibIqseJVYEw/cqulrjVYM8sg2l+KEWLsyF2GUq/wXpxJ0Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7IzoeqO6yT+n7HBQVouCQ3uIYtIcZmnzbXaGfirnH6M=;
 b=Sc3yyBKlAJl+VPqzDjncD/Wf7sHVW01Na7oqnRPoSe4/rwt7D5nWwHWAP1J9RIPAjZJzlfv2c/xk8KK5TY5JnzTY4zVgTO+1et2O43+piLAgFrmwwQ914ZE1+AAL9Llvl7b9LjFAOkDyHKhQilHRD/YKlyblp2zpZKXxgvLLfjUOUMeh2a6HYPfKcZeBEy3DAKbkbmvgmDO4P6x+y002AADiPwpqEZPK2g92EADfjdSCsrTfVjlRKkALBOArBamT9ti7jXw3BermUmOartfJD8UhnGDFdwWF5iUmGgXspF/UKMKAYmgHTjZJObpooOBcBE6omf11ZElTX/uiY5efxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA4PR11MB9251.namprd11.prod.outlook.com (2603:10b6:208:56f::13)
 by BL1PR11MB5221.namprd11.prod.outlook.com (2603:10b6:208:310::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.16; Fri, 28 Nov
 2025 16:47:18 +0000
Received: from IA4PR11MB9251.namprd11.prod.outlook.com
 ([fe80::6de6:5e54:b54d:8edc]) by IA4PR11MB9251.namprd11.prod.outlook.com
 ([fe80::6de6:5e54:b54d:8edc%7]) with mapi id 15.20.9366.012; Fri, 28 Nov 2025
 16:47:18 +0000
From: "Sokolowski, Jan" <jan.sokolowski@intel.com>
To: Matthew Wilcox <willy@infradead.org>
CC: =?iso-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [RFC PATCH 1/1] idr: do not create idr if new id would be outside
 given range
Thread-Topic: [RFC PATCH 1/1] idr: do not create idr if new id would be
 outside given range
Thread-Index: AQHcX3+gOgX7Xl6V9EiTdk2SZ98yUrUGi8gAgAACZACAAAInAIAADGSAgAEvz8CAAHJrAIAADxJA
Date: Fri, 28 Nov 2025 16:47:17 +0000
Message-ID: <IA4PR11MB92511BAEF257742C82ED590199DCA@IA4PR11MB9251.namprd11.prod.outlook.com>
References: <20251127092732.684959-1-jan.sokolowski@intel.com>
 <20251127092732.684959-2-jan.sokolowski@intel.com>
 <aShYJta2EHh1d8az@casper.infradead.org>
 <06dbd4f8-ef5f-458c-a8b4-8a8fb2a7877c@amd.com>
 <aShb9lLyR537WDNq@casper.infradead.org>
 <aShmW2gMTyRwyC6m@casper.infradead.org>
 <IA4PR11MB9251BBCF39B18A557BF08C0799DCA@IA4PR11MB9251.namprd11.prod.outlook.com>
 <aSnFME6-LqQXKazB@casper.infradead.org>
In-Reply-To: <aSnFME6-LqQXKazB@casper.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA4PR11MB9251:EE_|BL1PR11MB5221:EE_
x-ms-office365-filtering-correlation-id: e7e33fd7-a999-4097-537e-08de2e9dcac0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?onWJy3CZVyaMvlJ9PxbjWg7ssEVji4zelzNDWKT6298nlScrD4o0p09u0c?=
 =?iso-8859-1?Q?vCU78NA69p8KJErzZ96B+QwQMJmhiHuuj3TkvEiCsqlXTSepXVNIjlZwtq?=
 =?iso-8859-1?Q?db8ooKuLinYnQOh+PvmzxUddbjYFcP0d4MI4sMP9WuAnl9W78SxvJO455+?=
 =?iso-8859-1?Q?QWFFU9RcDl7y5kosdZfegXYc1geszX4f9AGe+boHIc+3OWJSpwqi+OsnS3?=
 =?iso-8859-1?Q?8Vf8BEgzAHe2QDPv7npshxXSSFFH7DbhunfVi2ebKTRynPWRPHOYJhJ405?=
 =?iso-8859-1?Q?I3jVGClXpeYAsCLZnN9zZxzQ6sIZwh6VJNfxsj/8+nIiS/m9IrxL+rKGgy?=
 =?iso-8859-1?Q?yUqxOZVvFEqxpbeRa7YDtpmSxSS6R+L9r3nnwurlVajP82hGqROGWlOdjI?=
 =?iso-8859-1?Q?J+2xoWlz4kocPSbGENjdPPSIPylEIiH4lQKkVnxz04Lqf2KG/liU3a+Z4M?=
 =?iso-8859-1?Q?Zh0Ifm0A/oQTo0v8JLSHNxXWbzFy5tf63CG3taJ47i3wD6Z4PffrvEM2sa?=
 =?iso-8859-1?Q?aJAWPKe1RLFUFrC5h19NL2KRHGME3Pf7ILUSWOT3E8jLR9rA/z8xhXsSmA?=
 =?iso-8859-1?Q?XrBJITnYena6jvNtGMkXQRxAKh0PEygNYEUeLpjPTqkkRUpO70WAslWaRn?=
 =?iso-8859-1?Q?Ue90I8ab0NxrO61za4Ygx5dfaNiM1lqVPAvHWW7fB1naiHo+VM6M6Myo8p?=
 =?iso-8859-1?Q?aeIZKnAKvD1C79F7+wZB1Zg7gllkDjHFtsuRT0NYQyYVLUWSpUpp9TPHAf?=
 =?iso-8859-1?Q?GywgQgYmCNspq1QvpLjIos4C+jHGKwA6woHB/bHfIU3IWTShnNFNU9MtQ2?=
 =?iso-8859-1?Q?L/wUTs3e17imzDAu/23BLQh7RESxqexkiHGYll2qBxzSWFnaHhVx1887Jh?=
 =?iso-8859-1?Q?XpQJNKPEkGephzx/rSJH4KFzPEpWjVamlBKcH6r21iiYqXcBbFA3xGn0nG?=
 =?iso-8859-1?Q?5RmtQn08YKH+plcLfRWiCd/Ty/bEtnssJCLicg88Tpxa/kX+cjDJlqrg9w?=
 =?iso-8859-1?Q?w+o0R1Yro8K1HaQHT7verGMHvWuZJKuTX0lSxQsTnUKUhmLUy43g/0rUtn?=
 =?iso-8859-1?Q?HeUIrQlYCrh37uLHUJyKGArZl1gerjWx4kPTbr+9hr0Bipi2jg2YCXvPal?=
 =?iso-8859-1?Q?dAIalr3hmzRH8SZtDvRXmPBqZ7w4DjcAizvDKlMqFtq+sLzEKfdlszE4B7?=
 =?iso-8859-1?Q?Llijau6y7RhcFngqi5aabCx+2s3JiyGfgn3p1wFtYM2YjcTGCUMpvT7hsS?=
 =?iso-8859-1?Q?aiSYkTA3kPFr222Ii8SkyXO3Um20C7VG0UTsdRn2riVm8DEDsPgCfzvMj8?=
 =?iso-8859-1?Q?qgF/KeVQ6e10fOnVpFrqR2EsZzFxBcCjW0nznKl4ZEUdsx7RX8A6G7aWo0?=
 =?iso-8859-1?Q?8cDVENy4kV+I+5PGf5lY61aDx8008wZjPgXaMHX5R4d/whVAjFCYM3XTQq?=
 =?iso-8859-1?Q?i9Vly4x6zZoxvQzFA/yjngzzrN6MsLVg1t0jd0z600Cl463zfUNLRVTZeH?=
 =?iso-8859-1?Q?o8HcZOT4tA7t0vuL7xSCy6Ia++3Fyxtu0NcoBc6UKGx91TdQxApPoq/5df?=
 =?iso-8859-1?Q?dkvSxkECClfJic1uiBAmf0+Bg9Vm?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9251.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?mm/BJpzpTxu30+pzPDKvDhAHxDrnOKLp0xmC4diznysAxo9BZqS5YjEipI?=
 =?iso-8859-1?Q?y1mAcRxJd/nRPvS+GZDwNCTc8jbl0bxy1qWc9dTl8X+SNXQxLMsUY/1hSz?=
 =?iso-8859-1?Q?VVwiV4uaXu0Aq0rXsZAtYSK0jm/0maxdnDKpHYjlyLFNe20vwlrKkPPmXS?=
 =?iso-8859-1?Q?p+dbB9e6+BRPHlUjlYp9Q2jjifn3DRojhtQHnbNPNMW6tBm0Hl2J5nVVOC?=
 =?iso-8859-1?Q?8JpTXPjT3hn5HA7ScK+Y//iX9OeJ1RadCoswJA+Gr5LkYy6kewf2tRnTDH?=
 =?iso-8859-1?Q?pAkt4DWMWeznVnLp6wOoA2buZBKzNEpTiCJ63Ll6Zo16EdU+eesXxdvDoH?=
 =?iso-8859-1?Q?ZLPrEkvlDGIDiKy9LbXIcTkgfQhrOJh1xJxbUuVTaybhn1Dcwrk1KSKegb?=
 =?iso-8859-1?Q?mD7euxb7nR+ak+FVow1TxLtalbxrtiu8mxd2ZqRXahbnP6p6f2i9RC2Eu+?=
 =?iso-8859-1?Q?R/QQYWTSco5E4PJ5mW/DaNGcnw/BOLYRt85Nug3dqGF0ksC7fSNxFRNBwV?=
 =?iso-8859-1?Q?x+eXFlvBh+NXcL0iAeNs18cg9vGGXRAxEQLH3UQHvDp4+lqkGMmUGPuoxd?=
 =?iso-8859-1?Q?XEZqSq5nN9vToF3IrJ3Cosy1hSnwESktakmrGElXyTJgHLzZfmrR2QIXEc?=
 =?iso-8859-1?Q?BQcItTBVuMRFYNDYXSI2eRUatOFLd2SbRupIGTqIvRA/SD8Ye3BksYc3wB?=
 =?iso-8859-1?Q?TAxqr1rBgZsIMjcRrjapX/5KN63Shdf3yLM65Ld/Gd2VCwx0O4ERm7inEY?=
 =?iso-8859-1?Q?gxy41N1r/nvdJWHiOJpS08W/Th/h0InLti5k4F/Jyk8uxnR58X4svYgAlG?=
 =?iso-8859-1?Q?/2xzJAH0ZxT9u2HQAnk4Y2iZIAyU29OfmXfdEkcJ1reW/MdBbEnkLdQGg2?=
 =?iso-8859-1?Q?xw0nuIkHVFdc8nl00szwMx4OmWSLwvXU1/u9U9aaeXLKW+ojqasafjV4MF?=
 =?iso-8859-1?Q?Ip5JVI+zsjbP/8ADliBfRbOYjrYaSJ58Gc9N+O451XbpLUivfpnKaiJn1U?=
 =?iso-8859-1?Q?k3nnqSVLBBwbCHuEN5xjSi5Hf3GkbLDeUJ27Y1zOEHVPOmSH5Fcz9BBmBj?=
 =?iso-8859-1?Q?+DvI1SnLjdXp6JGofIMVG4ObCB1ECouhGTwMh4kVazY5nI8mlxGtqh8jvL?=
 =?iso-8859-1?Q?LVOmihszHBDYozs7F503Te6AL8o9WfZ0hT613t7po1IH/CMbo8XumjRznx?=
 =?iso-8859-1?Q?GQ6HF9N58Y6ijZNw/mZ1PmnZ+7BwpyD5M3UIb5cJQQWwdH1Rw7zJtazf4s?=
 =?iso-8859-1?Q?YT0ZGoyBlOi5pET+U2utxYkw9mza32NJ/llCb+0UyY3hzXCJJLPxQXEgGC?=
 =?iso-8859-1?Q?TMgpzV5c/KNNXP7h/c4s85NjsG+uVwquEz7GxbA5OjPi7+yMsZV6YaONb5?=
 =?iso-8859-1?Q?U5MOYarPG7xYkiX4Bsl1qeneSnGiEBwHXSBvFprGY1qb/kAbCGc5uu+MaT?=
 =?iso-8859-1?Q?R8Lh2Nfwm7ewdINau9JeD9qpXXPf5uV3sYlWQmF9U10Fo8wALTRZR5LPLW?=
 =?iso-8859-1?Q?xorD5i1N9RoL/c4k4fBvmqMnBAlucgM9b1Whp3OqHnlEYAdc7f6t63PwQ6?=
 =?iso-8859-1?Q?BTcGGFkbsR95PGj0fXPvqHhkATNZwnRA3e+cX6AWAl15lGZR930sUy9tkz?=
 =?iso-8859-1?Q?tpk0m0bgQiltT5jvofGJT5ayUFJhzgfpjX?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9251.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e33fd7-a999-4097-537e-08de2e9dcac0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2025 16:47:17.8983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gqdBeY5gDi0Ne1MLzY9Zej8ztcLlWH7Z2uewKmFsf0jxrt8tuJcCXUsrYtock0TkF2tlFn4BhaeDwRQQXSAVDidFctFu2kRkNjYLOz1KA/4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5221
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: B3D2F16000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 66eu494x4f4rug9ywhsobckw4web1iru
X-HE-Tag: 1764348447-51099
X-HE-Meta: U2FsdGVkX19eGU39PHhKz8oyRPJsGamE15uZOfPaoRawKIIGS4rvuJvjxrdD2A8y60plJ3GeGZ1nrdJkd//cogybEz2LrRbXOK16a9jrmRL55X5urzcqnkLt3XLyKxzpc7sN70Ybk4ZP4YgsG5aHjUboDsXytOW1I2RQuEPkPDAYyjhZPKmf03zsWmGBWOIAcO74ZV3Fu5ObBczG852/F0mw6k79aXRhGrkRNgavENdU+gugtWIO8UU9LvJCjueR3Q2Dw8D3bW6Ds1yXKxKn5cLljwQJyk8vKCcfTnQrM370PS0B2QuaTRPBcJ8oNbffLAHcjIgovltP3xaaPq4QRavUth/JWOmOdhu6n1CyL8ZDrz2cRDtD+a5jFi8pphCdrXjH1ci+wwHJprCsYxMiP2hjApLLBK/L5HGT99OBVw73YBBSvnfPkrZW0aEeSe3WMkGb1Ikfda0yKHOq8Wd0v8jNmskHAakvdPMBJgYGdaJw+TgD+nCespahqLlNaRnpdNFGxX2ZCd5lPi1aSxB4EglpHSD2X/czIyIOxiV/5OuPUFgkU4MADBTIeODvTr+Shvv2up6j8McsJKCWe+259j3nIwJgBc0qQR+sbwFt6tg9nt/NsE3ggpnYsHngkD1Fiz16yrlGDXFHGODdEkkBu+P7yXEb/1bg0otM7lwRNCoIjtH0PTO/ROQg4mkgNVC0kaDLQjWVIEZ9FSU5BPHP2ma5LUKygplpqMsuk7HmEL+DPGtrMsL6r6MkEf+6q1Yzwv+Y1H3/EqdVaqoFfKFnLgM2UUJv5fxcgYXmCeFsu86Byo2rD4tsox+bI6O2ByrcrP1YR7YYCNlZHrDhyEJVSwBB1XscJMfP9a1227CzS7bIz29bU9bFsSSv1zAvF/Etw1e0HYItBU1JQsxMz2Qs5wyzpxGaJ0E8wj3dHZngvQPo0mh7d6rPXryCEo3fykazDTVQ5bmx6UDgjFo7Lpe
 KjPxDF4j
 G7xn8htujokQ79cj7hFOOhoa4aOy6oScpS6ldKH0dp9AvFMO88ndaoU7dL3KP61HcyNvpLuVfsOul9jl6pkE8sifjsnqS/PtoIfbm9nWqcL33agddgpAfxYH13A24UvB3PILx2wClJZylyZJIMmJrLpZEgQARwBuK1DdKcwJX9uOcpwiNfF2Gz+pCZpTAZWI/JZRUkTcqD0TQGVLP9EFZlyvipQPD6HW8KGRXbsrfL/zcEl6XsYyBQrGmbp/piclYV1rMeujqRNcE65fVkL90x5kKc6NHC0eSg0vqq7Y9JOlsU4U+D/QNxNXoUQgqXaLJBhBcOZykOXJKMWKij5sjktdJsSGr+C6+GMC1BMqnhILedmMGZq6KfF1dlGu57ZSoZiCpHvkTingIizScpTWE0dwgwidVWLhYA+eH5mKmmuZHenVTzLwpVnNpz9W6TiZaiiFYYav3Z9fYsXruO4eyF8+IukHn5UBF38TqUPY+Aj9deMpV9ahd/pMwL2Wh7cZa+m3840nIyHDUmGZrCewRFNX3zbGY0oUo9WtZfvhJCZNLyPehx2lGmVjd8uJyv8dWw+ec8SvuiDFjVscA8gwHsHQvbfwdvyWUPcz1VGEE/Z26ElfK5Tt86zthlaM5eM1urnErheMsp8GeD+pH0BkownwFPpaUfVQAqdglYgaUvTFbNdQ4gcoiItY6z+GJDaFqB8OqfpoTo8j/uCY10cJGbhMAoO/8IBYJJ4jQGvHD1CZT60YaxRAmfCipwtLkN90/Jm/qAqrUDzi+00GjD0PFOBbiJxBEbY5Xq9yd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> -----Original Message-----
> From: Matthew Wilcox <willy@infradead.org>
> Sent: Friday, November 28, 2025 4:52 PM
> To: Sokolowski, Jan <jan.sokolowski@intel.com>
> Cc: Christian K=F6nig <christian.koenig@amd.com>; linux-
> kernel@vger.kernel.org; Andrew Morton <akpm@linux-foundation.org>;
> linux-fsdevel@vger.kernel.org; linux-mm@kvack.org
> Subject: Re: [RFC PATCH 1/1] idr: do not create idr if new id would be ou=
tside
> given range
>=20
> On Fri, Nov 28, 2025 at 09:03:08AM +0000, Sokolowski, Jan wrote:
> > So, shall I send a V2 of that patch and add you as co-developer there?
>=20
> No.  You didn't co-develop anything.  You reported the bug, badly.
>=20
And I've sent a potential patch on how it should've been fixed. That should=
 count for something, right?


> What I'm trying to do right now is figure out what the syzbot report
> actually was.  In all the DRM specialness, you've lost the original
> information, so I can't add the original syzbot links.  All I can find
> is https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/6449
> which doesn't link to a syzbot report, so that's a dead end.
>=20
> > Regards
> > Jan
> >
> > > -----Original Message-----
> > > From: Matthew Wilcox <willy@infradead.org>
> > > Sent: Thursday, November 27, 2025 3:55 PM
> > > To: Christian K=F6nig <christian.koenig@amd.com>
> > > Cc: Sokolowski, Jan <jan.sokolowski@intel.com>; linux-
> > > kernel@vger.kernel.org; Andrew Morton <akpm@linux-foundation.org>;
> > > linux-fsdevel@vger.kernel.org; linux-mm@kvack.org
> > > Subject: Re: [RFC PATCH 1/1] idr: do not create idr if new id would b=
e
> outside
> > > given range
> > >
> > > On Thu, Nov 27, 2025 at 02:11:02PM +0000, Matthew Wilcox wrote:
> > > > Hm.  That's not what it does for me.  It gives me id =3D=3D 1, whic=
h isn't
> > > > correct!  I'll look into that, but it'd be helpful to know what
> > > > combination of inputs gives us 2.
> > >
> > > Oh, never mind, I see what's happening.
> > >
> > > int idr_alloc(struct idr *idr, void *ptr, int start, int end, gfp_t g=
fp)
> > >
> > >         ret =3D idr_alloc_u32(idr, ptr, &id, end > 0 ? end - 1 : INT_=
MAX, gfp);
> > > so it's passing 0 as 'max' to idr_alloc_u32() which does:
> > >
> > >         slot =3D idr_get_free(&idr->idr_rt, &iter, gfp, max - base);
> > >
> > > and max - base becomes -1 or rather ULONG_MAX, and so we'll literally
> > > allocate any number.  If the first slot is full, we'll get back 1
> > > and then add 'base' to it, giving 2.
> > >
> > > Here's the new test-case:
> > >
> > > +void idr_alloc2_test(void)
> > > +{
> > > +       int id;
> > > +       struct idr idr =3D IDR_INIT_BASE(idr, 1);
> > > +
> > > +       id =3D idr_alloc(&idr, idr_alloc2_test, 0, 1, GFP_KERNEL);
> > > +       assert(id =3D=3D -ENOSPC);
> > > +
> > > +       id =3D idr_alloc(&idr, idr_alloc2_test, 1, 2, GFP_KERNEL);
> > > +       assert(id =3D=3D 1);
> > > +
> > > +       id =3D idr_alloc(&idr, idr_alloc2_test, 0, 1, GFP_KERNEL);
> > > +       assert(id =3D=3D -ENOSPC);
> > > +
> > > +       id =3D idr_alloc(&idr, idr_alloc2_test, 0, 2, GFP_KERNEL);
> > > +       assert(id =3D=3D -ENOSPC);
> > > +
> > > +       idr_destroy(&idr);
> > > +}
> > >
> > > and with this patch, it passes:
> > >
> > > +++ b/lib/idr.c
> > > @@ -40,6 +40,8 @@ int idr_alloc_u32(struct idr *idr, void *ptr, u32
> *nextid,
> > >
> > >         if (WARN_ON_ONCE(!(idr->idr_rt.xa_flags & ROOT_IS_IDR)))
> > >                 idr->idr_rt.xa_flags |=3D IDR_RT_MARKER;
> > > +       if (max < base)
> > > +               return -ENOSPC;
> > >
> > >         id =3D (id < base) ? 0 : id - base;
> > >         radix_tree_iter_init(&iter, id);
> >

