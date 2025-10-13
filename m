Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70610CCD18D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 17:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B28318E0038; Mon, 13 Oct 2025 13:58:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFFE58E0009; Mon, 13 Oct 2025 13:58:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C7748E0038; Mon, 13 Oct 2025 13:58:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 860EB8E0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:58:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2EACB597CC
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:58:35 +0000 (UTC)
X-FDA: 83993850990.20.C8CF4FD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4A78020004
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:58:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AZtRaFpL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760378311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qfUDq0pDteVWV5bXAXOV5tIxD700LJZ6G+6ZJ4dkt1w=;
	b=nA1FmgmrsZCv+QjrvcjQLmotKK/slHeG2x2GMXUvFuCuAMMytqechOEbirMB+IqBwsNGzP
	2PjhSObrZ4RmZVZqMP/8Awh5nsh55fec0qdJWUF5JVI9DZ0VoJiXtSoGR3vKxZXl1Gxn7V
	/RBJOHKmBGtrQmepVL8Jrw00HBtXCjY=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AZtRaFpL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760378311; a=rsa-sha256;
	cv=pass;
	b=qx5X0em8kEbUvIPv+Ea8K+zbOi+zpgwWx3HhPCmW69QAxnN3z2QLhp7ynjEGq6Jl4fwLM4
	JiDbsHtdlqq93yKxAPDz9llX7FMj4+O+M06dAmLW37xnNnTNu1eUJc6e8b18W7nfehA+75
	o7Ci91ep4g4uuIXoSdmrfAtWDor/uzI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760378311; x=1791914311;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7de9qCIlzhZ2Imo5/7nZhuhxUEjJeJ4fwUNnuBQDY28=;
  b=AZtRaFpLUeo8HETHKtAXlLSWtCyL9tBti3KMYhf/4c5lWiou6J+B7Q9O
   reahKK9rVmuHZREwLTJz45QR4lVAE2JpQefZbMd6Kfus+Jt7MgamuJk2X
   dGuFv2hfmhRR7EoT/fcoK5OYJciN1dI0V506z/ynhDeJaqsiJmU9pYoPM
   YtvDkBDYOErs+IYjUtN8kYI4Jz0ltVQ4Og0WI0vaPXlP/mLVpTgjqzgJM
   fifsQAXqTDq+wHN8TtZXaxrDZCqhZOqXRyqWcQguAmF0N8ePsxRUZ34WD
   pYsvV04RrTuwWpb3ajf0Lj12u5DM+o7dcVuj5VyL0oZ/R7wG3k1WWnkrC
   g==;
X-CSE-ConnectionGUID: bPOdTBoQRPadcJz66sDOsw==
X-CSE-MsgGUID: hlvYKXjwRJeTI6GLHA8JEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62459548"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62459548"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 10:58:23 -0700
X-CSE-ConnectionGUID: Vg09ttkVTD+zTl9y9xgVzQ==
X-CSE-MsgGUID: iBNPTEa5QJ6ElyPnLoQEMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="218788078"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 10:58:17 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 10:58:14 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 13 Oct 2025 10:58:14 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.15) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 10:58:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MuEKz4Xk8NC/NoMSS8o21Dq+G+iWQvH1IdjazDiIX5RTH7Zevp9+Q7TwMEdcXLWw6Su9ffIoU+Xd4zWW8ZNRW4wLE6WYpgPx1DZcSOLwQgFPUmkYPIOCjwA3BICSr6lG4HWFfw2A35+jeQ/OJavPTp3tchPOMpG0t+i40Td7Bq2Aw8ORkim3ZHxe4iCr5kDFw+dDGpLA3HYsxKNQ5cN4aRsiG72GCTLBS5q/A9AGscCYYzF4BelwW+4p54wyjbRERfYHMhgV/lyn/idvqMBoAgibyXY0lfV3F6+jRhJSD8d+6HJsARv6BQsAYrQnAHz0xt11tue5a4qD5hKexKt+sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qfUDq0pDteVWV5bXAXOV5tIxD700LJZ6G+6ZJ4dkt1w=;
 b=D2oUsP1OCSUBcIH+oydyt5lwRBWoTJxEyRmUnIK+UHUnluYpUBjFYat07zP7uD96m3jdIpg2WmP7yZetn8PzymDgRMvBO9VAsMhEVxiQhNA4Bl+Gj+nvmiJ/46NTA+AzNRNuFLN72koxFt3rqw20n3e2iXBbFeO7vkoFGu9qg14twWnXzn68vZl6Rxtp5lH0Jld5jNrE+FGsUuOTGC97OHmJV4JJNtIfeQb5NgP+0VAnT3Ivjc6YDMg5driSpBzXfrpqAF2BuhHOjGOmcQY8AKUbvRXgCTOgbdL+frkk+5TzZI1Bjw2PGrL/tTkJSDO88ZIUb9nwg63mrErMmjonTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by SJ5PPF6E07EBAE7.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::832) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Mon, 13 Oct
 2025 17:58:11 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 17:58:11 +0000
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
Subject: RE: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Topic: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Index: AQHcLpaY70ekQ7dio0CIg97nnm1fBLStgQgAgAAW5fCAEt3R0A==
Date: Mon, 13 Oct 2025 17:58:11 +0000
Message-ID: <PH7PR11MB8121A8735058103B02EBCDBDC9EAA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-23-kanchana.p.sridhar@intel.com>
 <2qvfjavbepw3sq2pvvcez6jsc3bxkxej27674l4ztfdza7jqaq@xi6qndkj5xhh>
 <PH7PR11MB81216AEDFD10B5BDCBCE1F19C9E6A@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB81216AEDFD10B5BDCBCE1F19C9E6A@PH7PR11MB8121.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|SJ5PPF6E07EBAE7:EE_
x-ms-office365-filtering-correlation-id: e22ece43-b19d-4acf-609d-08de0a82132f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?wLsJrwZ/XMbCn39VN43jpateYGlAsOTxf7+TLQg+8/NpzvfMASWdhrrAYUw5?=
 =?us-ascii?Q?in1tNCrTpZ30usbEXkKT6R8Rv7RBPqpXiDfz4Uj+sYJdv/1nGzRb4v8Dft98?=
 =?us-ascii?Q?7vMA1YOdGUtYZzw5pmLxrvndbsBxULIz0FuvJKJpqWsjglY+HOeaHf7sdFvB?=
 =?us-ascii?Q?vi+e50RbM6DA6GByLe741BS4hGJq4C/gY2VrC1KEEU5JXVIXFR6VdOL1EBXh?=
 =?us-ascii?Q?0LFkjXMh7Bice4mnDTzGwwSEJOL0Q0HH4J6GmzcizMv+l9mSMeDAt0HZ/BN5?=
 =?us-ascii?Q?aB8P7UIjw8YMLCmCHyi9/kMoXOAh8IgClXiz2n+DRkqo7qqZzzKn0hU9REXb?=
 =?us-ascii?Q?l1ZGz0W6Zzbok9+Tt20flMr/eKqH66U2e3pdySAdDOyQ67kzVO4apB6AAQ9G?=
 =?us-ascii?Q?lZNei+2gSAmLOr6jo7jMsUlBGJBOspzi44w4lg9BKobirImOF8c5oBwR91QX?=
 =?us-ascii?Q?zdHOjNGwMXstZ0kJC8FIO25B4/DfFkUivOOfkp+WE1IZnL1UG9/SqeWoC//O?=
 =?us-ascii?Q?t2jPun+DlQKmoPjhiX2WKn6XnEnAI6jl4iBqWI624UAguv++MdCuHeseAHeU?=
 =?us-ascii?Q?2zI02kCvDB1n6DC1xvawD/R/cG9OYikP9v6228e0zJ0l8u0zLtUJeezmWAMJ?=
 =?us-ascii?Q?BEe6nHMesl8AnY6jY1Ho3P905uFCruplOpM3l4Eoz+t36EegJuLnmEeXUlkc?=
 =?us-ascii?Q?yiKbavh6z0H5IKMGThAXLt1bujoQh/XCXViRmRFZTgP0nv7i/ee/+ia9mShj?=
 =?us-ascii?Q?ejTRXQnzBoIRk4hs+eNFnl3lbWzp1YCFTg1aO++6dlDnCDA2pPxUPciYeq+K?=
 =?us-ascii?Q?Yr+troiylYYt4R2jrmy/MVeqVOkr8UfmkEc1nDaIlFDUVjdNybliZervB3QT?=
 =?us-ascii?Q?fMHXxEydLZv7kS5QRdpNf5DY1hWSB5+tUE56eVWZzfotmRn8ys/sjL25Geyc?=
 =?us-ascii?Q?HfnFq04nLG4C1oYx19rEnjYOoopfmcDTIHlCntFmzNMvRqtgpM+WI+uX+wb0?=
 =?us-ascii?Q?/s+nNKPZKM9m4QiPLqSoIKnAqPIr4fRYUzq3irHJ0jH94Hqsetl2nnfEIbGI?=
 =?us-ascii?Q?WIDMy9PBcbTDVTU7p9J6ZNhwzBQd455ki8/YAcJ7RaNLPPSfy0QOyUzVJlc1?=
 =?us-ascii?Q?YJUdEipH4VCWHRcvfHdZsw+KEFC/YzyHNTbVZt0pCjC0RtQWbmCxLG5vwjH1?=
 =?us-ascii?Q?gwZDk2b/GkzdKg8ZxsAUT3E4tYuU8E7f9wssvab3NajCQdVyw+CT5SoaatFr?=
 =?us-ascii?Q?LTvaFpnWSY8UmW6YHgqGGunIVspF3pB7z3W+uVb77AGTS84KHhqDtNejAfUl?=
 =?us-ascii?Q?YnN1VsQFOG8wOmnOn8TXmANbv7hnHkZsZQSme+qynOtPGzbckMjbwhLsn9Yw?=
 =?us-ascii?Q?NG5cGoUeTIl96DT3TcLeFC/Ca95m4cY3lL1WwMxa2YCkyp2yf2iySwhz2l5w?=
 =?us-ascii?Q?fv3tZ3ekrS3aMynjJrIXP9ACICw/gJHfLPpkSvUvVTl8Vmi+hJBoIopCyjWj?=
 =?us-ascii?Q?A+t+c5DaWCULmlXo7UztI6ZCKF7AP1yZJg3N?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ehmb6x5JinRQSYvt+syGnjNyXds8dp8dGPhSc9bdn6PdakSwGBMD8U7Lib5c?=
 =?us-ascii?Q?Aw3NHtaZu/vlbkQrVmradu7xPA6IzIjkhNs6HiNbup8CpSGSIciPXCr+VKOq?=
 =?us-ascii?Q?WTVI5tR7OoqE6JeUg79mOBC57ly7Jasgq3MkHSoDD9bnLStsFeHiNMNKjCUF?=
 =?us-ascii?Q?7dsfF+vxK5UCRHevN5nioUtag5UDoJeWdtqOnGPTPl/QNm8pN41/tEkY/PnB?=
 =?us-ascii?Q?IrHV1cE/nT/mlPNcFv6hWU/1vM1yU28/zisdcDExwZW6FFV8Fu58fI534a1U?=
 =?us-ascii?Q?YYjzRrMW0YWeQ5ik4+b2QUTbLkvCzd8YCNpyJ+/IM9rlIEqYg6EALkDDqktV?=
 =?us-ascii?Q?TzBM6WldrGH2Gn2aHEj0gLNgH7M6HhdN2nSC2AgB079uKLNh4cX0Q3xSX220?=
 =?us-ascii?Q?6qUnhEWHCbyRlUpxlH8ovrSfhPYD9JLeuxLQ21GvWr3OGIbyoP9zVqhdc5wP?=
 =?us-ascii?Q?gzWj9whkSb3PWknvOnGth1vh9FPUlm85vTguUqKoLf3LTGDAoSHY1MoZ0ORf?=
 =?us-ascii?Q?09e4i8gkNyUaMO7t2v693PDvBWkN1+wCrG8AjDA08xLLLV2qkbOed/y8xDbV?=
 =?us-ascii?Q?05d0eXzyn8cd3goRqDug7PcLgw4hEWfxn9/3uP08xSE097gmmvBJUFws3Qjy?=
 =?us-ascii?Q?lFRaZY+LBdCtWW66bvtg2sTvcjuI8iS14+Jvq1cOwST1zuAvvLxGKorG5xe9?=
 =?us-ascii?Q?iotj3DctyyktAMC4anDFUda22g4OO5NuH4sqECqUBG8vBuMhle4h+yh4hU0Z?=
 =?us-ascii?Q?kQPwGcMNtWp2a5UsCbGNZEDDlm/VRd3S+g7zghRkTAaQ+c6hihTuJz4mfqmU?=
 =?us-ascii?Q?clMVKm4aMYhxz6SWn0ZAkXLpWkHqAyyH5ltu26LF8lz3Grjcb1IvkuMBalJB?=
 =?us-ascii?Q?DoZsK1bCqUHUh5hAxdKZ328J5IafVhdOdLJSy+Cad18dK6c9NYhLmlAddiVd?=
 =?us-ascii?Q?5+eQ7DUpKJcRCXuzb1ryFO0afnU0TO+x40qwD9KeHf3xEipKjXDKnFeF94Qi?=
 =?us-ascii?Q?gcC6F+mPjPpuxzd+oaCVHz6S9NY33RLXNbEgUihJNLd0DY2N/NQf3Y2/6Kxn?=
 =?us-ascii?Q?UFOqUliIL9zBSYYjOEKxQUDoOe8jk3cUuFbbTfJ2u/WoIzMZyKQe/hwffkXZ?=
 =?us-ascii?Q?FhdbRARQporqjDhznRd6SfFooGgObCPNBbL6OcklWtMgwpbYsjnKqtTgj4lB?=
 =?us-ascii?Q?+euzwyb1gx+jeAlpC1UByhyIlv5DhbyOLBpABUhDGWtN7vWvu/tdzURj9Sie?=
 =?us-ascii?Q?ic82xIZ4luUhxoBUTw+5wJ8i3V+loUmpU9KAOxBraJIzJD3JrbV6I/fSBUuW?=
 =?us-ascii?Q?zf+K4JW3J/qA7R7cUiIhBzA5FjijoYwfqBWZ7Yg5+yG2HgiisKkdllIdiIou?=
 =?us-ascii?Q?vfR5ZUKvJLrfhfRaF2gPfXRqhhz1MdmCnaMbq+WJ09dwVa1/5Yj70QSBXn1F?=
 =?us-ascii?Q?g3gVDGjhFvtwMqH0EmEfSuHmcQZMSE+6uLAVi6W7+PSCTSwrEJMluvA8uUP9?=
 =?us-ascii?Q?jjggiqJm4rC98kqNcZ8SKbRJRJR8iwQ5luzfb9YAhXAnSvGJqz6/l6GurMng?=
 =?us-ascii?Q?wTFTmJ16tZR/dfSMwNlN7qgDtoHDbacS0L82JIW4rTX/h1SXBz6PcLtoty/S?=
 =?us-ascii?Q?RSHRHvLWCmzwqwoIV3Jm/+HmdY2sYiB2RzF7t8MdLCA0hHpx5+mBetLHYC0u?=
 =?us-ascii?Q?NDDtSQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e22ece43-b19d-4acf-609d-08de0a82132f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2025 17:58:11.6679
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8dR5x5EwDvQBCBVRdtYO+vtmzIl3U2YRKqGxCJmysggnYlovHkHaS1YbJC8tHh/x6wOoUMzFieS2x6334Sakb1nlqddvPprq2BuoL8qetWc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF6E07EBAE7
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A78020004
X-Rspamd-Server: rspam03
X-Stat-Signature: 3qb6snoeyznkqprimj87raz5krgcbtsj
X-HE-Tag: 1760378311-724139
X-HE-Meta: U2FsdGVkX18euPrWuAl8f7fu3k2ilrFkFEmgFd0rtMXwQNR4C3znZCAYO7FTlauxOFrUPPk966wcPinxyt0tl0mAITKp8TqQl9xe2OcaUrL0uJqC68sllvnzYDvuKIQIOreBDZ7OB6JrSa5148HVr1S5PUDira7J3ivOlEV5aM5eq2jAsqc3jV03aJduhE+LXiVdPJk845CdDQ9pxBy59KStrQVuk6agNRmLaApvf/DsqI8Fe8MTIrKLcvxOpIP1nMjxcJ5MhV9mApJicknBfDriOCrAxYYflrw+pt9zLHagxXbUgHU0BQ1U7gO722DdApTXkSPUp0tx76OK+/kw2bPiWM9QJkEx/R90tO1RZGxIKsFucuFNGTEREMA5xVV5sO1n7CVStBNTrWueY2Z1fuBH5moNZglPNE9PcHvULNze6BWRdCJhN+F/QUIEmJbWUA1qWAzayAlVSqfpjUAviqXhWcWSZELQ3xwCQ5E5ac+5MmQjqu2ecLq/N+GZwejLqob+cwjIa9TpfqGPMNeTaf30N+oNiaWOKDeeRMbUC5KCa5T+DZdUJd6+lIDemdaNciir2lx16y0WTAZHhQ4vvCpNdr+xidOuwyou58kZs3wOtDnPnHse3BxErI650CslNakzBghyATavVKxhBbzSl5AbO5EcB6WXzx6W42ooNUAy1SR3gOkTOU4pie9Mhy6roRMzQw9H80mDg4Xn9JS3xJZgdZC22PcymU+UqtID4/LsSvC1/rT+mdIiQqR8l2GY1RsLUJNYVuFovYXoFkaJ2+/r6VnuaViYHKuKGtvS1rLmaR+vqMKhsTV+upcnPExJjis/gyhVp3xrcRM35zVlykQLmxbFmrhTTTdCqSJ4kGwNP5qkcmXBq/w1kpH8+8Pil2CMwX5w9k1gmsl79fVRvoN43D70/cQjvm9Ovm3sLvr7yld6IyGBq2caCOb6g1UX2CDgqv3RXHOoVJG7Oe9
 +E8KCJG6
 /CTalJAOF1UTdZBeJxMh0KvQ90RhwqpZg24Tu7FhbHV+vcV1S7AdLG4UdRwaC0sFf3qKuOe3X5iU9mopGfGYUhzsEz+64LksvP0FXe22POrxk1bvij0b1pctSaB8x6CFIRGLiHM1Fq924BYGpYM124wZN75OkCMmNa+x1wW8aDRIHpssrimIyl+bNXqH5AoZvJhbZ0F0aleO/6uSfcNgxwDmm2BMEJuOULht5kVwpbC6UmDN5hlaLkmKDMXjynC/Ui37D34M0eXBYHwAGZOKcmR7yAuZ4QVRlaFxJ5OFLNf9L4G47NuAXwhes6m4wcuvMuBa955quQZnXjeTQ2g+S45ltgwvhGE47UVcvSiOh2XwQCbgjFcgFXGzIm0CDM/rFjY1akJmMiFTWM2Q5bq+tIHC4zsxSUHgTJ6eG+O5YXtM7r7vepUeGaBKkACp2FhEmLIKlJsvhVvIqzU+0uTGVuE4+mftMnSu7rqNX+2M1toTVp4yjb9JHSrRjqTEo4ScWOI4pqQpiF7QJLeV3o43DWz5Mkz/xCi0qz3UkCbxuMTXlQaQiUrSO+XA+9LZ2AM4eD39oI9rMYq1dvcwr4h6MT9SpCfmHZhMsJlElixjZeFdXCHH8UA3j1FzBj0zS6CYfZecn4w1WlJ7wtdkyzmh2N2GlTuHQYWI1PTAmmyRaXjH/5IkLOTxPHBG5WYZMQPVCxi8apPbeDJUJb9OOXsjZa7czG6y9uktqLIFyJdssYLPo/TzhTHiA1jHLFUS/b8ZhAkGpAHiYrGd1YbXjvdizCQJnk3M+poyJnzBVKw/sZoJeLk4MvryCb8YUnOsmesVZfZDwYBrKX2lD+xQBV9+AL9Sn690sfDRHTxfgo+5QOzjJUJiFoJVBMYJVhKcaUQwRFWkrZ1RzTOlCQ6X9xccxIzTMKijphRNk+W8TGMoXWNJ7d/6WrEnCqITDsqOU2+Oyx05qSvBK5Irr/GxfsOCXGVqHi6vo
 Cld4/Izd
 ijUtqC8auq3mXqtKuSVpHjRjxHADRvuZXrBD7qdiZb81WTA5mgqFmSOsnS2o2vgIB59QMjC1/junGIcm/KZf9JZqK4YtVjRE5IYiAsXHnAnR+JhFFW+fbriwE/lMjhqi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> -----Original Message-----
> From: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Sent: Wednesday, October 1, 2025 2:21 PM
> To: Yosry Ahmed <yosry.ahmed@linux.dev>
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
> <vinodh.gopal@intel.com>; Sridhar, Kanchana P
> <kanchana.p.sridhar@intel.com>
> Subject: RE: [PATCH v12 22/23] mm: zswap: zswap_store() will process a
> large folio in batches.
>=20
>=20
> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Wednesday, October 1, 2025 9:19 AM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>;
> > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v12 22/23] mm: zswap: zswap_store() will process a
> > large folio in batches.
> >
> > On Thu, Sep 25, 2025 at 08:35:01PM -0700, Kanchana P Sridhar wrote:

[...]

> > > @@ -158,6 +161,8 @@ struct zswap_pool {
> > >  	struct work_struct release_work;
> > >  	struct hlist_node node;
> > >  	char tfm_name[CRYPTO_MAX_ALG_NAME];
> > > +	u8 compr_batch_size;
> > > +	u8 store_batch_size;
> >
> > I don't think we need to store store_batch_size, seems trivial to
> > calculate at store time (perhaps in a helper).
> >
> > Taking a step back, is there any benefit to limiting store_batch_size t=
o
> > compr_batch_size? Is there a disadvantage to using
> > ZSWAP_MAX_BATCH_SIZE
> > even if it's higher than the HW compression batch size?
>=20
> Thanks Yosry, for the code review comments. I had a discussion with
> Barry earlier on these very same topics as follow up to his review commen=
ts
> for v11, starting with [1]. Can you please go through the rationale for
> these design choices, and let me know if you have any questions:
>=20
> [1]: https://patchwork.kernel.org/comment/26530319/
>=20

[...]

> >
> > Does it actually matter if we do the initializations here vs. right
> > before inserting to the LRU (current behavior)?
>=20
> Yes, it impacts batching performance with software quite a bit.

[...]

> > Seems like if xa_store() fails we do not cleanup previously charged
> > objects, pool references, zswap_stored_pages, etc. Instead of rolling
> > all this back on failure, can we do all the xarray stores first and onl=
y
> > do the rest when we're at a point where no failure can happen? Would
> > that cause a performance regression?
>=20
> It would make the code more complicated and thus cause a performance
> regression. I have tried to balance code simplicity (which impacts
> performance)
> with correctness here. The "store_failed_idx" ensures that all partial wo=
rk
> done
> in zswap_store_pages() for this batch, is cleaned up.
>=20
> The rest is handled in zswap_store() when it sees an error returned by
> zswap_store_pages().
>=20

Hi Yosry,

I was wondering if my explanations to the above comments answer
your questions? Please let me know.

The bulk entries alloc/free comments' follow-up is covered in the other
email.

Thanks,
Kanchana

