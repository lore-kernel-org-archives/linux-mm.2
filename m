Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43ED2D43361
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 01:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A751B6B0006; Thu, 11 Dec 2025 20:07:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A24FE6B0007; Thu, 11 Dec 2025 20:07:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C63D6B0008; Thu, 11 Dec 2025 20:07:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 73CDE6B0006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 20:07:22 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2556B899ED
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 01:07:22 +0000 (UTC)
X-FDA: 84209030724.01.D40CA90
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf01.hostedemail.com (Postfix) with ESMTP id EA8144000B
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 01:07:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cQCj5Sx0;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765501638; a=rsa-sha256;
	cv=pass;
	b=M7bhIgL8iVVsBilPM+Ve+mS1OZxPz0VOyi+FIEv/FK3s0L8JQtpMouedTtC2BVseJ/4JV/
	pqtUQhlxoJAOYqCazNwM6+LGlTUH8uaLl6+gb/+C76RzysHRLTPgPOy0V+s69FJX8O6z8U
	zR/69q6aHqIN7PWra5Bqj2jwBMeokC4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cQCj5Sx0;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765501638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SO+Zf/oVrziJOPC6V+J962oBoEze9Uj2guxMzyAyDTM=;
	b=eUVa5ubT60H2aRiCx7XcHHME5SxAgh1y6x8QzbM8ALpMoL0ydn6MbPuYF7bnZtZ1UPp8ZB
	17QFr8Ii1QRuJbJjBX9ILQk3eJyAc6RpoTpfOetQMGQ+5h7UqpVWuo9gIoX+sRbr+OpZS/
	SzDgZU1NLeduuwPw65PJNdMZgmnwZjU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765501638; x=1797037638;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3GUjEYA52a4nqh4enT0r9LqBm2G8b9hglm5b4QRLhqc=;
  b=cQCj5Sx05K2czEokwrkm9PR+wS2UxMcwcvKPL48uk4O1nUPcLTfwB0B3
   8Pvc1SAuotFNHZsrYakAcT4WfayIkUlCvDCz4HJ9FSQQtxWyd20FZE7jW
   m9dtH4w/jNWYdbsG8ygGVX22N5b2vs+E2Rx3P7voyIQNNRQ2s43voaLQa
   RnJ/Hk/oR6Qdvv2rGaX+FQ+vGN9ZBm8rjz20BtFb/dBb/EBE92yGglThL
   9Zkwm2Nl0szVURNymTbcdLVX5Y/5cUbceguyswnV5HJ9IEGH22JdT70Jf
   bD3VTZH8KWfRz/Qjp462oMH6jBsjYAmNXuTnaUEGOWpd1yjt7jeQt2MOy
   w==;
X-CSE-ConnectionGUID: 3iSk9LrrRtiZoiYiFciGmA==
X-CSE-MsgGUID: 7touvBgvSCyFE+Qq9zrd+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="84901214"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="84901214"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 17:07:15 -0800
X-CSE-ConnectionGUID: CO5UOvDkTSia56/0rfqH3Q==
X-CSE-MsgGUID: ssDGI1dzShOBGMzcgKiwlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="196554690"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 17:07:14 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 17:07:13 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 11 Dec 2025 17:07:13 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.18) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 17:07:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GBgazJlI5esKWZtZNNptekfCLfa2VCcYDh7jVeDpciUJamyQw4PTFEwcqxWH10DB6JU+FmjEHEfyfmXk9j0RYyLlbaeAmXTSohhamrTusfsrcfhcdhvRFcJtS2Ok8SpUIkj96OCV80FpKPpAnIi3P41bfL8qTDoc/sfFRjY9bo7q20OH+Y/PsgPQNr8NFk0VrICNgXLsUT9zr4CW8a582JLKsnjkFMrr+4e/xxrFf27ruPPr3oi6aUFa5wmsOsFRCUCuuPcBC0fJCPkisx4IbIuEWd68uNIraXzuhXGpK+ywEGAHk7RknMb2BRp5NcQJYfd2hWeYqHQbJfhXF4+zCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SO+Zf/oVrziJOPC6V+J962oBoEze9Uj2guxMzyAyDTM=;
 b=WSKHdLrvfdab87OhWFReAHT4h14OgxwYx4SIxWrbF7n412bex+koPej+4kk5wKukZDfz9s2DtmAldf+SVG3pxv3aCtvFwwYA0gzxqn+2HrGldockIYcDfQks5psScG6I6Nj0yH1OMxirZjnnXLO7zmKxu3FR0xBcl/CZwMaRilXAvlIhQp7RfoEU3dZjbpzsNZU96s5CpwUkerGpCeChGNV68CAe8XZ1ytEf2mH5oLQTPoE2xjz58mK99t38ardQ6xfEny1wfilWUQaaFCSiNZnW0tF6iBoXmZYUGMWBAG1J9U2YdsC6V66Pv6JZcDPPpBPOINctg41n7IZfRc0b6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by DS4PPF69154114F.namprd11.prod.outlook.com (2603:10b6:f:fc02::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Fri, 12 Dec
 2025 01:07:08 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 01:07:08 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "sj@kernel.org"
	<sj@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v13 20/22] mm: zswap: Consistently use IS_ERR_OR_NULL() to
 check acomp_ctx resources.
Thread-Topic: [PATCH v13 20/22] mm: zswap: Consistently use IS_ERR_OR_NULL()
 to check acomp_ctx resources.
Thread-Index: AQHcTWsw1XYYd7o4XEunpNppvJypWbTxHIqAgCxPn1A=
Date: Fri, 12 Dec 2025 01:07:08 +0000
Message-ID: <SJ2PR11MB8472CBD23CC29E5E896E07F9C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-21-kanchana.p.sridhar@intel.com>
 <dcpuzzl4bqnuhf7tshead6fatbjre2uo5kybdzllsjwkpvbv5a@kqbja24fetlb>
In-Reply-To: <dcpuzzl4bqnuhf7tshead6fatbjre2uo5kybdzllsjwkpvbv5a@kqbja24fetlb>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|DS4PPF69154114F:EE_
x-ms-office365-filtering-correlation-id: 74431586-4329-42b9-35ec-08de391ac5e2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|10070799003|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?piJtCgrn1P9tiGQzfM274AE+h2du07PvcEdLhWs5KV6IKNA3Ou/xvqMNGwYO?=
 =?us-ascii?Q?o8sX0rzdI4Ed4/yW+4bBwJRKglHaJPRB9q+x/V5Iyz21T0fuIIfFpBqC1UfZ?=
 =?us-ascii?Q?XrfF+6p3jjHNbY49gJwsJQVfm1zI2/o+jbWc+ZqS27fLt7XeSbPZz38mruJI?=
 =?us-ascii?Q?q1W7uVxQPvqLrMvkFISGpfPv4s7hpv0rsSZv6oR9biSDzRbzqBIM5cLZHc59?=
 =?us-ascii?Q?W4XLMpPAqb0/xO8w5f+Ofh2+AR8uCjSyxzUrty8jEJH2/5QtdVSeZmcFlrX7?=
 =?us-ascii?Q?8pkWmEMbIkOabY7y8FidAa2rdxWsZjnY4VRFIy7U5utpRMpoW7JZikDnX1UB?=
 =?us-ascii?Q?L2slZEcNwbTU9Ly5qxV5jG/RCxEg9Hs0xQF4MJhCv1dMqFAvUQAKdEfYH6Q7?=
 =?us-ascii?Q?YF4b/xVtTd8DSj5L29LSGSx0njEEyaRrUbhOmHTLOJw2d05xo+WmQ65mRneW?=
 =?us-ascii?Q?B5ZA9RUn1t9A+XqHJZDqSEeD8QS7vooP7lMHsE3eGAXohrWtNJhTsf8368HA?=
 =?us-ascii?Q?QGwnyp9S+so+jifcwsqtomdCjth55yaMsIGRUy7a1togNfrgteh3/s3zukIM?=
 =?us-ascii?Q?cf7JALsyKESxlUWpxk8P4LiSOqMEbhkbGsf/aSQ4t54KSIHRB9w+2ea8xOMI?=
 =?us-ascii?Q?uGS1ov7hqxgwRebDkAftGgWoUtoNBUtMGsB6Ay7hJrDvd2s98mrzmXfT/DiN?=
 =?us-ascii?Q?vKkuUyl6B0/U5C+Ni7AZ6ezfkPpYyN3nnu1SdXvdaxFDhzxbQLol/9wukaD2?=
 =?us-ascii?Q?8z/4yPQspltkId/E+tdIYC4hupNwTPptuKwG6YYpMd+rg16iWq/ArBEW7bZX?=
 =?us-ascii?Q?PfZb0BK0bLuHhZOvsg6K33u5OqpvGQEDqBVIZddYuNhai+nUEhp5j3RBXJSs?=
 =?us-ascii?Q?UTSFmfW4ULsm3/4kOCWKhC8Tqa8GJmr62A0jXSednGWhAh9u+R5kZLbBjE6u?=
 =?us-ascii?Q?Tl0xQ0uPq2kuSTuKmQk8zC0KkpvRg9Xj5Q8SvVq9CUuDrFS18DTM9hEiVfzn?=
 =?us-ascii?Q?z7n2SHdKylHvMs6bXcoztY+upT4mKBm0PloCzYYo8fWCR/4Zz9k+Ujjir0hI?=
 =?us-ascii?Q?ZfRVw20VVf3V0+l6n/9BhoLLQ5b2GE945yFXuY8op3DCmNS+X+Ltvl9chGZc?=
 =?us-ascii?Q?nIGfMfUJM7XacQyNoeySvph1pHYt+6qoj8Z7rFSAD83iaiOjwIGZHgzGtlft?=
 =?us-ascii?Q?CqCXJD5DmimBeb8s8Exm8vCiWhm33LeiC94IsneCM9SwUcwnFWLk/SH+MEPV?=
 =?us-ascii?Q?CyS9aM7ui8vv6vZW/V3o/95kkui9eP+NbJxc+97x1q5JoHb/yTGCs90A1QJd?=
 =?us-ascii?Q?Owh0au1/ADcp/ABNK3hMBJXEyalxwkejI8okMvt22DfNJwmS/1qnQ1AnCUyn?=
 =?us-ascii?Q?8QvIF67wX/ZnCN66VsvYEJYmm3m2bgZ8Vs7k4/6aK2HxedylRzlqZWiUGwE1?=
 =?us-ascii?Q?yHtfiFHYacH3Ra5kVkF0wdzuK9QFsGVLYydtdRii/C7MM6q3LwnjuVu3hRwf?=
 =?us-ascii?Q?j7lAwz/lI2ZYDRKvZcdSWhLiyhVhGog4u1VA?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(10070799003)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3Ws1tvPudOOBzL6Wbso/L/pBoT2W4Gd11WE5H9q1Wkf6xxfGXLk5M/Og9YA6?=
 =?us-ascii?Q?WlnZCtLcEJSF5ETkVU5CO64jOaW25Jlr+Y6sC8t6a7cQQx4PMqSL8IOwFSBu?=
 =?us-ascii?Q?4U7PvhQM3pCLywEUFZePy+rEBZkCUpXtZDvOyM8WArY1lQB6vfJdn+vVwzgG?=
 =?us-ascii?Q?hgxOMMYXbR/YV1kowpNHsaBja5Cleq44BdNFSnLn9Ks1vcZDxdTVskp7q6MX?=
 =?us-ascii?Q?3Meje3VkyPe/KrhH8tSrvyifyVbb2xPKJOktDPXxuR9EueMO48onlfiHZexZ?=
 =?us-ascii?Q?/O/x1HoHg3CsH7wfEUwaqsRD9oraQIFeLwhKr6ErOZ+QFANo6MaAj9HIrx7M?=
 =?us-ascii?Q?CjXzygG+PP3AZIr9tN6p1LMoJdGOcVWadEF0gpc0hSqUe2mMa9FoJ45/ZTDm?=
 =?us-ascii?Q?3WN0hztD3vrp2uTNJ9SzD6WEJWHw0+lroNpOAy59D05t4ctqMnnn6tvm6Cwi?=
 =?us-ascii?Q?pUzgRUL3dNZe0fFZtlsQl75b/s6Rc2L+lLdsWss0GsFreqzLr5Lb3jEZ+Ldm?=
 =?us-ascii?Q?KFnpdkWtbw4DCe0WH56omq+VBhFoGytdIEB++7SSrOiE8fAFVCfmUMGT4jZA?=
 =?us-ascii?Q?wPWTzKUvdYhf4uQCmNVo/xMMv2tr5iQ3sSc4LcuYqFEOfqJFyOkHXmDhX9ke?=
 =?us-ascii?Q?aNtvcXXfQrp3ntN7jQY3fch0qiABepjY4NJvxhq2QfaQ+OfDYSUbZImQdK2x?=
 =?us-ascii?Q?xMH5sN9hFBpybaiiXkkKaBK9PHw+xqamHREGdR7HAryWb9UsOL9V6BcEpLah?=
 =?us-ascii?Q?LfNXDEPOHk/X6L19uLB15FvuNj5auwIXgjoqvGvnw97+3Xb30KDGW1adRO9E?=
 =?us-ascii?Q?zGTQqxOb0kVGwhsXZ5YK+CE9ZgzqMs5Sv65IDjRVvCTclUX02Qx/iRAdNCcr?=
 =?us-ascii?Q?aYX27VSpuKT67mcirYZWmwEvn/+P2opbHBfIGHJTH6NDuk8psIML+L4730j7?=
 =?us-ascii?Q?eokV5xIoQ+JjwS/1+4PS8gk6dAXy8/H8MUzAmW4rK+6+aVDMxJREa+KKBixT?=
 =?us-ascii?Q?1hdWg8hbqFSE75QCCEPeIyBUoVcOl5GIZ0MJ49rt5tkB7B706bC9M0zoJqrg?=
 =?us-ascii?Q?oxNbYtCODX/7DO+vZuAt8zevmn0nyrWJAAvn8YSbK3UX0Fg9jGwJ2GQR0eWv?=
 =?us-ascii?Q?18gSmDWRUkfG6c+8XlQ6F7xXGGCfuK4uld3HoOiAVOJMjg1FMuvaRmy1lLW2?=
 =?us-ascii?Q?DcNnYrAwwnLz2eSann6uCkykOUqu5ezcvimZyikmoEyhlnJOcNjP5oBzQHi5?=
 =?us-ascii?Q?lxODdhzz7bQqgshOegX0Xxl1+0/oPlcx7iV5+NIuGFCXH6pD5Qg1+5Bj9e5e?=
 =?us-ascii?Q?PDcu83v8InNXsOXrZulic0K+LIUwx7P8be1upVXFjWENqAezv2o3wqTWnH30?=
 =?us-ascii?Q?CYpR5J8rF3yT5dE9ARKl8Wk8PDuzuHEUus+nIsYlboMHwj+9HcJINTro95cW?=
 =?us-ascii?Q?LiqpeB38XU94tSxwQ8Igr+x3GRlSDIsvVB9/6IvY6xu6ZNPfxWlAJtaXUdhF?=
 =?us-ascii?Q?RLXBqFK3sRiB35fTWk3NU1g4kDDz1f8bBIpyBFC64yR68k4nvkAWlLl8Skxr?=
 =?us-ascii?Q?S/EGHlnwuzVJGQ2lzXwiwOhho9F3vCMYgJghj0YGhecvRvf0iuiiYu8llER5?=
 =?us-ascii?Q?hWmImxrfY51t9jrdXWOh5A7qp/PoBLHjD7mo+BgFgXHUAcWltni43g2v+xNv?=
 =?us-ascii?Q?IIDCAQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74431586-4329-42b9-35ec-08de391ac5e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2025 01:07:08.4930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XrQJ8JSo+SqdYbYsvegoMpiFnpPJJBChZ7COkbfP+OLHA7OleaOnz1+756JrB57UcmVyV3Dzk4I5AZRta//ZiRW1+M6rFHrtBBEtWqWWAtE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF69154114F
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EA8144000B
X-Stat-Signature: o7rd8q7bpqz3szufjnd81d8yojhpbpqw
X-HE-Tag: 1765501637-437840
X-HE-Meta: U2FsdGVkX1+xDvligZZJSE7qNyJGflRHVIOqwCy8+TBrxt6WFoAd3LCVd9gIxwv695Sj2icxbDQVLBBOkpg6LoAkxdrcFB+IqczR1pLciX6pdkKEqLRX7SFsPtC98zEUmLGIvD4NPWj4ADO/Wfv9TLrov/TwLWYVxpdYB6wgfTF5uXlne4+zF1IbiewllhJnl+JYi14SKkJO+qQbgm2O01Ok5YsR/xGPKRaKtZCqfh3ywcUxPaoZJJYVdkFmNcHbK8g+lnTI0xU+1GLL0MY9UPXaJzs9qMtszCQ6uKBnfjUcjBeRSka/RpCnO0qDbE+8qUJUBmpmRRQbAZxV38tY+lv6/g45rIxXOhjJ2LvAWvgNhdP0rilzej3pGzqvo/0RWXLHQuOv8dmVAUcF74A5dYbOAf4RXqnW1T8GEN+8/tc+qibiDLuRaCVReOVyQhU69o5TmJOv6gMQAUf36ZiVDM0gnV55ma/rfnbp8J6fUnLYheWTnMlggoCL/R8jtqtdtL6JZ2lHTjjMdzhPz+nuH4hRP4BtPmL9XNo72xpAHUZku8pPd3kIDdkN6t7JgpRZDoiDsihUE4YmV344yngQ3F+YeTtZDvYYXnInuYk9IqtaGgRzn6y6jL7dQ+/7nrz8J8vLPnNF0/5AwNQ+6nCYp1RKxsL+Sn251eXlNDu3Dvb+1wVuV4CpHHHGoE5c5Iqf56PgVKLY1JmFim7BcSah5cHwdWu/zswkfVdk72mNTfrTzMyZJq4TpOtO4fRGBupTlL/oLWEAqEaGyUwa+IxKiw+5rrBQlq7jkdPKbEmVz5MiwoF/mCixh1ZngoQ2oVLgQQPtNKlDmiTFhFAy6sbc2YWDeax9soCK5MYziXLi2BP7Asg7IPTfCPrcJusTYGlRDrPS5mITcx65k7UGM3hadjdMn4GqN+o/mhqKT58Jd5uydEzZJ9AoHFSRLWm9TI2rbt+fPBevOOzwp3nuHni
 bfRDn2AN
 YdEa3a/e7A/TdyXg4SpEiSjPUC/DzlxIO1aJhnNwmk7P6o9aRr/k5spB3NchLM4wJ2B6IdQ9cxjVv3nhTdqRB1noesDL0IVpnINYvdA4fwoWDbbPUBRHuP3ucxNHn7wxclAWSZvGfRzbzhlju8foAhQP2DeA60aZ89UWyRFzAGANuqITRZjNUBW7snMeB16JGeXoZEgxUIRS439qPiZ3fbCsJrSTh/ZpEVMJ5uYxJm7V/L5vNOm+vlBmg9faNmFrPxBJVzvoqt8KuA8wxwRyv6c5HoO+IQrEC4KcjSOG8kPEw3YtO9rdUokMNTfPm3Cl2RyQOZLFQUvQ65jtd6RfXxpVlVjJpVo8vwODlFe7swvTcJwjvQEASSM1d4axvFfpb5civPSMhgj7tPVa/h6O9u2z5ODiXZldfhuYl8h1AFxQ2P0n6AQnBRBDrYV6KkfHHUP9lRMPJJ5g5EMdAiLPTCf+WLAU3Z/WKHWiej9cMh6eDP2M7WgvBPPujSerKcNGCvhKblVYE/2Tng3VuhoTpVdfZk1MnwqaNIxSZO3RTzKIpgWqnMHlmyxLeHMCLRHP8LYo1VPkNLBPfukuvLqByOljC+goDNCeIqZI1QhO0RY4CbUhNes8L9wTg9CMObSARdurqCBLKdeP++wO1BAv7ULOoE1RU7+J1YubsdTTBOwTKoDjvW2dAyzWNIoDy1dHcMwlyjZ0C6YyMpQTNf4JgBh4KSQOlvr+dHOYlVeEvfW2sOsHMqteZ8gxHpYDxGe403HHFYgYoK/qp7v8RBa98nYETcs1/Q2unVO7aGZPUW7X4ILAQzBA9G4oVQddV4dvQF7rXDvDgN7uxXIDPfdigAys/wNxFG2eUwWMm5yLgznnMiH32sGAaaaCftxzvpq9x7UDTMFUHa6rCVtSsNLzup+9ZQrSENT8FmaFtZDmqnQLRPhdQdsKWKOckScgzckBO6LYfcY9oma+TkjV8pWppkqcQqhzH
 q4RTMmFy
 bHGvLMIKxX+ZJXOAC10k+VNiqif1KpX3TPNRbVZzaGBtjeC0JtJq9RzRaCJ6aWwoQUF6p0e++1vTf3AUFd/arxuj/11MlgylBl8QCGgPMOfGShNIKR73exEX8WCIc1r5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Thursday, November 13, 2025 12:26 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>=
;
> Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v13 20/22] mm: zswap: Consistently use
> IS_ERR_OR_NULL() to check acomp_ctx resources.
>=20
> On Tue, Nov 04, 2025 at 01:12:33AM -0800, Kanchana P Sridhar wrote:
> > This patch uses IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check
> > for valid acomp/req, thereby making it consistent with
> > acomp_ctx_dealloc().
>=20
> Instead of "This patch..":
>=20
> Use IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check for valid
> acomp/req, making it consistent with acomp_ctx_dealloc().
>=20
> >
> > This is based on this earlier comment [1] from Yosry, when reviewing v8=
.
>=20
> Drop this statement, it loses its meaning after the code is merged.
>=20
> With those changes:
> Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>

Sounds great, and thanks for the Ack!

Thanks,
Kanchana

>=20
> >
> > [1] https://patchwork.kernel.org/comment/26282128/
> >
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > ---
> >  mm/zswap.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 87d50786f61f..cb384eb7c815 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -780,7 +780,7 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  		return ret;
> >
> >  	acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0,
> 0, cpu_to_node(cpu));
> > -	if (IS_ERR(acomp_ctx->acomp)) {
> > +	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
> >  		pr_err("could not alloc crypto acomp %s : %ld\n",
> >  				pool->tfm_name, PTR_ERR(acomp_ctx-
> >acomp));
> >  		ret =3D PTR_ERR(acomp_ctx->acomp);
> > @@ -789,7 +789,7 @@ static int zswap_cpu_comp_prepare(unsigned int
> cpu, struct hlist_node *node)
> >  	acomp_ctx->is_sleepable =3D acomp_is_async(acomp_ctx->acomp);
> >
> >  	acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
> > -	if (!acomp_ctx->req) {
> > +	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
> >  		pr_err("could not alloc crypto acomp_request %s\n",
> >  		       pool->tfm_name);
> >  		goto fail;
> > --
> > 2.27.0
> >

