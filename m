Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56CF8CA0EE4
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 04:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E0578E009B; Tue, 26 Aug 2025 00:56:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B6F48E0090; Tue, 26 Aug 2025 00:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87F038E009B; Tue, 26 Aug 2025 00:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6DF8C8E0090
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:56:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C2E884703
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:56:47 +0000 (UTC)
X-FDA: 83817698454.02.15AF8F0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5304740005
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:56:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YdZVIjMm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756184203; a=rsa-sha256;
	cv=pass;
	b=uiToRbwJpzORrbKQAZcraXcbxl9zNYxCFOXoCns+jTlw8sPn2Q64Uhb7ASj4X9I8rs5UbK
	6yMGeB73jKZMMyhRtx6YoWfmPO79e/amhpngoxj059kS+x1A7UgFoKP80WLW5n9U6H2Ieh
	5lYiucgH0WtNMkqFd1rCIJdUf5+8A/I=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YdZVIjMm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756184203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBgrdCHObylgu2QAAje6fu5tJbb0SvKeRUTQ+LNdLR0=;
	b=hyIeCW+XKfd07/VusIjRlX4lWAfzi4SLOsQfeL3KHKpA76d52vPsPRxCO2kXa2S2OTshKC
	O24dHhatqUJwk7O+LcJpmTcQ63z+3xMSvRksGAcVlB/SElVSoU58abXne9T/mjGrvmpcB4
	zbo027Nlr6WE82BTIWY3PDRa8HkBwas=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756184203; x=1787720203;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pBgrdCHObylgu2QAAje6fu5tJbb0SvKeRUTQ+LNdLR0=;
  b=YdZVIjMmtxjM/JGOkHJGA//EL48JGgOZCdsJvhR+4AzOG+e93CtaFhxp
   ko10znx5WF3FpJ/gSwpcTOGHaNEy4MojnnOW2WMe2W0Jgg5brP+V2uP9P
   QH7U25USyAPGpi1JOQEyAYgXOkmsL3YYwayLe3urh1XfBEAgelcf3lLh3
   4573Ta9S+QCf1NVw+bx+Dk5/wg8caU0cLaD0vXRZKHdGvj269O5Wd/Q9w
   Zj0wsmkHhWamgTsMHI/Ammmjr+UFu81Oh/YmFI1VP/m3RZVx3jV9l0tdx
   h6dF2KANa4OAL/EOsD3fmVl3qW+FfezwCZQagAtMrhpScpNfSbYLdDXh+
   w==;
X-CSE-ConnectionGUID: BO10gVzHRg+vHu1l3XBkXg==
X-CSE-MsgGUID: DkQBanNbQV+DcPrfUVF0FA==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="68679209"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="68679209"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 21:56:41 -0700
X-CSE-ConnectionGUID: frLSyWTJQ3SgsbhLoa6p/A==
X-CSE-MsgGUID: oZYVVckRS5aVq/ZWu9KNYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="168975267"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 21:56:40 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 21:56:39 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 25 Aug 2025 21:56:39 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.53)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 21:56:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ycswjf9sOUkseEAPWL/AYOCMiMFhMSNzI3gKxQjRfk2JlwIO+O6Wy51W7S6jauAyhR2mi0zdC1qaeMcsKOGBH5gWxGOgOtLLiQIaPDKzBWDQ2WJtgiuD0hEQsS8k4M0ZxYobCmuTZLJVPIGR+hlcTJDQgCraXQZo5FKs5SKKGac6cRqUsXLFOgdV29aYc4nCJfEMUzV4D831br+vJhtr6rekvQx8TJ0XdoDGaFBPmJk7rZuapM+ZLWEkkA4C3Mt8mhkPxVhNHLYb6vzoJk048ACaoOrdZ1LIfsOIhR6pdOxrfTSBqoPEaa6Hm3kLAhM1F7Kb8g9Jv+kTSLxBbFtlsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pBgrdCHObylgu2QAAje6fu5tJbb0SvKeRUTQ+LNdLR0=;
 b=eJErAbDMDyic3khjFKrgRlDhk6KaglO2bdIpXWlUkZi53ZKgvmtXLY+pArQBVjUw1MfVQmxPZcOtPFbB06qCLUztQtv/tPv/988aXnr2m7CWQtYdj+aiDWcti6y7KWD/BXtoM/km0c3YgnEFTqzZ6MjeIS/cZfMpqVwDKteUW1OO1bP7m9Eo4R6y27wwktonFAM8FomvIadwZ4A7fw4QGOUHbh3xluH0Gd1T8HrR6R2RsvbG6JVFdylDh/45qh3pHVCBunFqK6/NhSb/Kk4otvwsJHC3Rxdl2U/bt2fQw/loKcl+r/86qwBrLuyllvK821c/MujqV3mxysBK6sMwCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by MN0PR11MB6060.namprd11.prod.outlook.com (2603:10b6:208:378::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 04:56:37 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 04:56:36 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Barry Song <21cnbao@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: RE: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
Thread-Topic: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
Thread-Index: AQHcAp3rCQGkKHFe602Ahq9v7LnzVLR0czwAgAAISGCAAAbQgIAAAQVg
Date: Tue, 26 Aug 2025 04:56:36 +0000
Message-ID: <PH7PR11MB8121B86E65349F5CF854CA57C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-23-kanchana.p.sridhar@intel.com>
 <CAGsJ_4xRij-Vz_-dmL44YLvaQrYLKKnw7O_Skedrxj_YxuaT5Q@mail.gmail.com>
 <PH7PR11MB8121532CE4368DF5BAA6D46DC939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4xMuLPy3+mAxzOj6SfnFZaDf+B=WkmbrCNqv8gvK080Fw@mail.gmail.com>
In-Reply-To: <CAGsJ_4xMuLPy3+mAxzOj6SfnFZaDf+B=WkmbrCNqv8gvK080Fw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|MN0PR11MB6060:EE_
x-ms-office365-filtering-correlation-id: a701549d-2bbb-447d-7fba-08dde45cefba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?S1BRcGVvaHpqd3YxNVYreG9LOVZvMkkwNmVNbXZQS1p5ZFAzMVMzSTBURkJV?=
 =?utf-8?B?L1lJY3l3NjBsL1VtUk9DRUZnejFGa1NCZ2hTeXVJU1RjVEdmQnZVdGI2ZUE1?=
 =?utf-8?B?ZDRLYW9XTjlzTkhiVkVQUnV6bktlOXdWckFpeDAzbk4rMG5MRWpTT3hod2Rs?=
 =?utf-8?B?RTlxU3lPemlTZzc3Y2o2WGtyQWNzUEJmd0R6T2NBZ05EaWtYdlczek90Q0tt?=
 =?utf-8?B?OVhQb0NpYW9CTGZ1YmUySUo3R3MvUTc4MkZyRXNseW1UTGxWV0daT0hwS21m?=
 =?utf-8?B?RFg2bTFabzdkQVZkTGpRVjlUSmJKOGpWeVkxRmRtNTc1TElBa00rR1RmelVa?=
 =?utf-8?B?SWZ5Ti9pMWYzSktNbkNXcmhqQ0hOTS9vemhGQ1ZEU25LemFOVDFiSUJ0Z3p1?=
 =?utf-8?B?RGpIOVRKM1NGUm1BS0lVMGtCWXVsR3JoNXdhdE95YTlhVDlEKzVrLzRzZ0Ix?=
 =?utf-8?B?LzFCcDFuU1JPNlJBVG1JK3hZSi9IbVJlVnprTkZpTEtHTDQzMHRxcE5SS1lq?=
 =?utf-8?B?UldxeDBIcVU5L3pjUUQrNkoxWWNUUDBZc0Rjd1lQd1RaN2tFLzgxcTdGRjdj?=
 =?utf-8?B?NWRlSUtPQ3ZkSkEzdG9DM25sS0xnQm1yTDFSUDlDeE53cHMxNmplOTNOOU1G?=
 =?utf-8?B?OXpXYlZHcGxKQjVvbEFPbEZCRC90Z2lRdklDOEQzSkUwK1VwZXVKcTBlY3Zz?=
 =?utf-8?B?Rm1lMEtoTUhZcWlUVFU1ZDJZWEdOMWoyZlZwZ1hhelFJM0dKWUJNSEtaVzVT?=
 =?utf-8?B?WWJEM0x6a1lVUGFMQWh5NXc2Y0F0bXdZdFgwMEtxUnpjV1hCd2taZVpCYllQ?=
 =?utf-8?B?QVZhYU1nQm1KbHhoK3F2ZCs5dnoxWEtiVnpzTmlzb1dHN0ppM28vMnlJbnZ3?=
 =?utf-8?B?eElTZHIrWkpmalB6djJyVVpXQjNiVjJlR0lRSDBkRko5RUF0eC95SllPS0Ey?=
 =?utf-8?B?dE00UFJpTDhwYUZINDZCcTE0WmF1b3c5Tkl1WE5JK0N3QmFoaGNObU1PS2pj?=
 =?utf-8?B?NkluRm13blBNdjhXaUtVcUVaWjgvQk9ZWFh3SnVHekZwdTdLaW51Z0ZzWEt3?=
 =?utf-8?B?SlFsb3cxTEFXUWVqSXY0dVcxLzExc0RDQkZ5RVZXekhXSzNURG5KRkU1WlZz?=
 =?utf-8?B?UUhiRmY3L2xtZjlQTm9sOXplRk5pTStCa3R3N2RlVVJxTHQrMTRGUURQbUxn?=
 =?utf-8?B?WDBURG1NY285V0JvaDFxYThCazljdGxZZGVzM0dRa2xOSzU0TmcydUQrNHBo?=
 =?utf-8?B?aEZNa2c2cWxFV2I3TEhkTmVaSHpUVjdISnFBdFVQbWlVRW45eXZIbFJKYVI3?=
 =?utf-8?B?YWI3MGpzOUV5MnV2cGtkeTVHVG1CSFdySHdFNmlrVnp3aHJnbG1hdE11R2dy?=
 =?utf-8?B?YjhBaUJlUnZSREhFaWo1bjlmWXJFS1dQRnA2cmxNeC8wd0p2RmV4UEcyV2Fq?=
 =?utf-8?B?Vm1SRHc3RnJ2a1pTU3hxbWZMbGwwK014NHQ0UDg5VzhTMUltbVhsTGt2OWRS?=
 =?utf-8?B?YmJyMlZPdDZLbG40U2dYTUxBcE5vSHFETGUyRmRBaVpTOUI2YjB5bnFQb1FI?=
 =?utf-8?B?RjRlNHpYeE9iZ2ZWUEo0SGM2Y3pMZzBtekVtZmFzWHgvdWozSDU2aGU3UWNK?=
 =?utf-8?B?d1VLT3VjWGNHTlE0T21jUWREdUtENHdMMXFWTDJmNXdoUTBCRjNUKzMzWEMw?=
 =?utf-8?B?bDhxWmJGYzVJaEY2S0NuN1cyL2VGNDRVWkljTnNuYmJtZVBRbDdoQmwyanc2?=
 =?utf-8?B?SDR4NWo0SnVpVGU2czZ2R1RNc2dzS0pLWUVDeGNpZy9uYTM5MER1RmxPaElH?=
 =?utf-8?B?Tm54WGNxS0FyK1czWWd3KzNhbU8yc0RFVy94ODF5SzJjNENTSXNCZWozd2dr?=
 =?utf-8?B?Y3cwNkRNQ05JNUZsSWJUOGloTkM2YkJucEtQOFFOcERueWVydkdsTFMwZ1Ry?=
 =?utf-8?B?dkZ6SnlmTGJVbTRsbWd6S2FqZkliaUFxdTg5MTc2RWtjRlF0SWxacnZqeCt1?=
 =?utf-8?B?aDlwWFNEQ0lBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M0kyWlM5Qm42TUcvNzhHR1lGRjhEdG5oZVF0MjZvdEY4V0hZbTlnL2prc3pa?=
 =?utf-8?B?QUxRRnFwTHNRUHA1aVdCMHZGR1grdTFaRUwzS3grd05tUmk5bXNONWFkWk1Y?=
 =?utf-8?B?a0xoVk1VbnVmWk9sWmN3NWJnRVhYQldZd3JwUU1uSk9HdWpwRmZOdUlVUHIz?=
 =?utf-8?B?RzZKWFBWeWxkTjVrN095VWhOWWpGUlZwUVNuYkwxUjFJelc5Ym40Z3VZcXJX?=
 =?utf-8?B?aVZsVklFcmlRb01vWi9uUmxRcHJmYm5sbjlvUGFMWEFRZEVhLzF5L3ZpV1NI?=
 =?utf-8?B?L1JZTzF0TEtObXZHUEpwNTVCQkpZYUJpU2RMUndrVE96TTkyNDlzVExqYkxq?=
 =?utf-8?B?WVNGT0ZQNmk1YnVnZTBxZDVDWitXS2kzRkw5RTQ4N0I3Uk5PSHZRYVNZNkdq?=
 =?utf-8?B?azlUcVQzcFA4SktLcVRIM2t4azFiSExrb1RxUUFxQzh6NTJOYXlCblI3Tkd4?=
 =?utf-8?B?QVFPQVF6YXFUNjlNTGdHc3hYSVF1ZFlKR25XdVBXMVBmU2VRNjdBZEd4THd1?=
 =?utf-8?B?WVNxQmFkWlN1OW5sdmJhdkRHRVF4MVZHVHk2U2JjRlFFUkJyeVF3NDFxTVFD?=
 =?utf-8?B?L2p6Q28vYWx3N1hkREJJRTNiQ1lkNVNEM3dSWUt2Wm0vWHFRby9oMmlxQVF3?=
 =?utf-8?B?RWs5NE5xSFM5Q203SU5vdUdMWGFnL25UNzEvSEJyUXRmWVMyclhncDBWM3Bh?=
 =?utf-8?B?dUpMNUJZS3NVR0dzUUtBS3llSWIwQllFUkQ1YTNaSmEzUngvWDNHL2tENW1s?=
 =?utf-8?B?NlFnbjFJV0tsZFZVNXBwTjNuN1dDbHc1NmR5YVNmbEtaV3Z3elNDVmRyNkxX?=
 =?utf-8?B?Sk5VVm12OE5QaXdqREQyM203eDVNSVRCOXJzbjNEa1l1WXg4d2RObUNwdTBB?=
 =?utf-8?B?S3lxeXlEOS9WMkpJRklodmZLaHZNQmhHdDBMVXk2MkoyQ3ZvQW5FL3JEV01i?=
 =?utf-8?B?WUlVRnlsczJibnhxRlA5Q3NyTGlMS0tGNnpjVUpMQk4vdHhLdDBGaWNGa2FR?=
 =?utf-8?B?SFlnM1hSRllnOGZpQnZnMEZ3VFk5U3Z4YXcxbDNld21GZkdXTXV2akdVcEdh?=
 =?utf-8?B?K3VzRG5KblIwZndVeDFGeUpQcHU5MzBIVWtXUUpKbGp1T0xQckkyNjdkVWF1?=
 =?utf-8?B?VWhYWmhzaDRPUmI3bnBsQ3Q2MWx4b0pRUUdVcVZMbWZaaU5yMTh4blNSN3gx?=
 =?utf-8?B?cGtGSkdhSmxtWDJJemxxOEpoZkRIZDd6Y3puMUpTOE4yZ3VwcjhtekZKdGRJ?=
 =?utf-8?B?bWU1Y3RMUzcrUFpzQ1hPbURCc01ieVg4MUJFWGxDWi9KN3I1U2RYbjh4S2Vj?=
 =?utf-8?B?SzU3RjF4NVFaL29vdHdvMDB0aUNiMFRpNEhPVXRVNjdaTEpoZGRreTZZNHQr?=
 =?utf-8?B?eFRmMzVONFNPVXIyaHMwNWw3aTNkeklIajdzTi9GY0lhOEVQNDhEY1RMb3dN?=
 =?utf-8?B?ZnhwaG54dGFIdUFTcndTVFppQmFkK3YySlMxMUROaEt0OFBjSHlDN0Rhek1K?=
 =?utf-8?B?NHdDSFhIWjNiR1B5TGFtSWIyTE80WjlqcWIxZzdPWXpUaHU1bG1NVGZ6a1RP?=
 =?utf-8?B?QUI5ekhuV0VEam1TekliMWpoblNQb0cyd2dMMXg5SDl2TFJ5NlBPS3VWOTF4?=
 =?utf-8?B?MDJmWmJDMVZKcHVpc3dyMk02VnFwd2YxcGovU2wrajV4TEpxSktTeWFhUDRm?=
 =?utf-8?B?UDVmK0RySTlZdjE4T2Q3R1lhRkdPRHdxM01hbVZhMTd4TWtQbkVQSnNPd1pC?=
 =?utf-8?B?cWxwMzFRalExK05GYTBTNzY0Q1FMdHc0L2o2WE12QlJhR2F5NXAwRkRDZ1ZS?=
 =?utf-8?B?akxZRXp3c1l0akp4a0VQWlJzTzhRczBtT3NsTldRU3FzMUpoc3ZET28yRys5?=
 =?utf-8?B?aVlpOHRvQk5GNjYxeTZON2trVzdWT1dJa1JyczdwTjVHZHBqbThHTmNOT09t?=
 =?utf-8?B?d1ZodEI1R3VWUVN1S2lEYVRMay9zcG5vdnpEcmJ0SHdORDZFMWVBZXdEK1pP?=
 =?utf-8?B?VlZ0YWpNekdPVEZUeXlGd2w4VWhEbWF6YnFFeEd4UmlRZnB4R2NncXE2TFhR?=
 =?utf-8?B?QTFFNlpCalJGejlBOVhIenFyRHZERTNBbnVlcWRiRlZWdUl2TENEZGViSEtp?=
 =?utf-8?B?bkNST0VrYWJxM0dyK1phTlJENmpnSjRjeWFWL2ZXak51WmRSajFWWlZCemcz?=
 =?utf-8?B?T0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a701549d-2bbb-447d-7fba-08dde45cefba
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2025 04:56:36.6293
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EgzYRlHofY9xoTNBuq5tYEG5Xmx/QUd1i0bfDJsy7koIgiL95tvcUpTsnkN7EraSl+YmpWWbuC+g89FPMsP9MjTzD53dKwpFo0cW9UCAEME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6060
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 5304740005
X-Stat-Signature: 314ry7pxtp74xzt7ju17dynbxfzruhhu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756184202-96023
X-HE-Meta: U2FsdGVkX1/Sog5JLGaIh6cPqaEfBcVo5ZfKpZzHPdh4ju0lCdV6kzlqjafn5MailzUCdhgZihE+EkrTc7+H8gmbfmChqaZdWj1VIFOunnfbbm+uuwCoYaFGnUvV/UCdbH4R39RkjuG/DT5XYaPRJpjTXnOu4opDuUV143sV9XKQz9jy3Z4ZvjMJo0GAYq0Q2oiM+0NEO7AFT5wsNCSE6/xcyD7Pbe4hJPCciLqdK0gLtwen8ACGPGKX4UccHEvaeI2Ab9ZhBQhNraNBjexmmLtm8/mn88RrqIb/vrV6Anhlozo1D+WErPzGntTYlIxbzaAdns6UsuRv8/GPLpoJqLjynrUgfwa7Ni3kxh1VkS2z1aRiXtTNVBYzzwthcbgWnWBxHZi7H7krc88ITR+c7PnYxuFqsrgCMkDxpzaISyWenqMQU1jrd3c1b42UE1D2hkUquH0jGPhY28NBFve7CRIWCQoAwQcu0UrNB5yMfP1UyCtnfMm+iURfCb3Z1vWRn5C8Cb61peIdUPggGwxMK5yVXgU5ZhCH+oNDNxUvpuZ8D5iEO/kUdG2mRBnTxfgRitLXMJ8YnQjOdjDf0ddk9TMsCWt/USnKkWONV4gS+0mrlM5EKe36Q19BRB5RVmlZW2ZEMVBgV9SqSZevzGRxczG4xk/Ws9g4jX6qqW/qPowp0FseAkeREUzLvQVT7/BBulp1l47tc4rpTDYycEdFhvjS3Goo2fZPSNnUSvnthvEGIRWbF5VagR3CV3VWY80SY+eN9ssxgPKLFjUOFM3nuwtP+xVLwmzSkNHz9gV0DwOn86oLuS8UvwewxIh5+DtPvcR7kyIEGJHRBIYsJx4Y1Pg9IIkY7bLqRpik9+unkL0R3u3EaA6rwkrZqcsnHIN7vbQc95nvU8OvIX2rIX4LrFhZz08Dc7414yv0aDfKn6C+TSf8w/WJ6E1MhVDhkm8pArKdbquoFM+QxU8I+dT
 T8g7TNsf
 ZZ5Qrwm3h0uCOdKEZHCCEzsFVTUR43hcsfzn1WZmgEFKTbJAaVoxa7LHHqUYNck1GWc/6gU1sB8UDylwTX+7o4klz/yWx5C18X+T9eJUPzjUU3be0Ta8K4dUSqa/1IB+5TI/2UqDod3nFmYZpieNCW26BNbgDPi/h1HrDXGQ6O/Bq0QoFgZn5ria+pjvtnSjefsXREIvnT93SqKDOQoBFSK1nh9mfApter9MCGG3h9iLJ47zLhO83guOYTdJYOmkFPvy44zVV4EbORBRPGzxJOq8VyT+UGcTuDM4U+p4cVGgSn/JyUDIw23RnF574kmZQAkYNtoz+I7yVWUjDExwIlrhrGbEiplpGpMvH30bW+D7MsO4DQncwwxptfpLX2eS8deV5JTebrxwq61wMahKTU0j11PiaZx6W/JnsE8mDx9cnwtmKH09MjtVvixRZLBXgk+xKBVUnui+ls1ofFHWL9qcbyFtIbOQaAGjq6oE0dhmZQr32G5jbBlGCjFmYlTW7NNMOqAuK9Qrv703Abq4xvMgAwa1pG/6oWuQknYMa9CJjUtwKU6lMShEidIeWXdJjRDvKLoiE5yioB7jGgJiwheMqvwrHUGgF3zw5hZZrYPruCAEKb2GcrFxAmMSnfGCJsQsUNgE7JXIUiHKFDGHx8uD1r6SGz3iNefYbTA1oj622ZYi1FHfzJmZIGbky6fNOh96Ubj84La+5dFYSLu6rJ0Tasdy/gPKFEkVGpgyVYr67EZzM//Ky1pViNLQQGA5Vni6GdgR2bheEl58cPslNVGKRBYn8vp7ldM9Lk4aRWQPc8QHgVzkbGgXj6dxBCjCk0x22JKao5NoMq30keNww3/5796HQaYlxRxeIwOnhnqRfmYD+dLJHlqQmTJxFtJHvuArKupacXF6R0TpzCJsn7LT9Al7KDPjz+HmB7ifWcmcX/QAaVzyDfDMtWALacsJyoYabbHyJNMQgmuUY4EuBLVb/HDlb
 hpAjBHQL
 ZnEIOxk62XO+A83YZmQdFJ0MbDCqgRpLPeK60KlZUtvwRYW+35yee882nrV5NJ0gcH+4YmI5e5TZLMhgokn4sf9L1eWc+9Dw4H0JIHpsAXad1ec1dCvwaRq1J5BrQbhi0czKU9ChRCSLEtw/2jzd0P1FfDCf52r6qXVmuz1YROlnkXJeJRbmIXJjJLw0c483
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEJhcnJ5IFNvbmcgPDIxY25i
YW9AZ21haWwuY29tPg0KPiBTZW50OiBNb25kYXksIEF1Z3VzdCAyNSwgMjAyNSA5OjQyIFBNDQo+
IFRvOiBTcmlkaGFyLCBLYW5jaGFuYSBQIDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPg0K
PiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtbW1Aa3ZhY2sub3JnOw0K
PiBoYW5uZXNAY21weGNoZy5vcmc7IHlvc3J5LmFobWVkQGxpbnV4LmRldjsgbnBoYW1jc0BnbWFp
bC5jb207DQo+IGNoZW5nbWluZy56aG91QGxpbnV4LmRldjsgdXNhbWFhcmlmNjQyQGdtYWlsLmNv
bTsNCj4gcnlhbi5yb2JlcnRzQGFybS5jb207IHlpbmcuaHVhbmdAbGludXguYWxpYmFiYS5jb207
IGFrcG1AbGludXgtDQo+IGZvdW5kYXRpb24ub3JnOyBzZW5vemhhdHNreUBjaHJvbWl1bS5vcmc7
IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7DQo+IGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9y
Zy5hdTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gY2xhYmJlQGJheWxpYnJlLmNvbTsgYXJkYkBr
ZXJuZWwub3JnOyBlYmlnZ2Vyc0Bnb29nbGUuY29tOw0KPiBzdXJlbmJAZ29vZ2xlLmNvbTsgQWNj
YXJkaSwgS3Jpc3RlbiBDIDxrcmlzdGVuLmMuYWNjYXJkaUBpbnRlbC5jb20+Ow0KPiBHb21lcywg
VmluaWNpdXMgPHZpbmljaXVzLmdvbWVzQGludGVsLmNvbT47IEZlZ2hhbGksIFdhamRpIEsNCj4g
PHdhamRpLmsuZmVnaGFsaUBpbnRlbC5jb20+OyBHb3BhbCwgVmlub2RoIDx2aW5vZGguZ29wYWxA
aW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxMSAyMi8yNF0gbW06IHpzd2FwOiBB
bGxvY2F0ZSBwb29sIGJhdGNoaW5nIHJlc291cmNlcw0KPiBpZiB0aGUgY29tcHJlc3NvciBzdXBw
b3J0cyBiYXRjaGluZy4NCj4gDQo+IE9uIFR1ZSwgQXVnIDI2LCAyMDI1IGF0IDEyOjI34oCvUE0g
U3JpZGhhciwgS2FuY2hhbmEgUA0KPiA8a2FuY2hhbmEucC5zcmlkaGFyQGludGVsLmNvbT4gd3Jv
dGU6DQo+ID4NCj4gPg0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+
ID4gRnJvbTogQmFycnkgU29uZyA8MjFjbmJhb0BnbWFpbC5jb20+DQo+ID4gPiBTZW50OiBNb25k
YXksIEF1Z3VzdCAyNSwgMjAyNSA4OjQ4IFBNDQo+ID4gPiBUbzogU3JpZGhhciwgS2FuY2hhbmEg
UCA8a2FuY2hhbmEucC5zcmlkaGFyQGludGVsLmNvbT4NCj4gPiA+IENjOiBsaW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7DQo+ID4gPiBoYW5uZXNAY21weGNo
Zy5vcmc7IHlvc3J5LmFobWVkQGxpbnV4LmRldjsgbnBoYW1jc0BnbWFpbC5jb207DQo+ID4gPiBj
aGVuZ21pbmcuemhvdUBsaW51eC5kZXY7IHVzYW1hYXJpZjY0MkBnbWFpbC5jb207DQo+ID4gPiBy
eWFuLnJvYmVydHNAYXJtLmNvbTsgeWluZy5odWFuZ0BsaW51eC5hbGliYWJhLmNvbTsgYWtwbUBs
aW51eC0NCj4gPiA+IGZvdW5kYXRpb24ub3JnOyBzZW5vemhhdHNreUBjaHJvbWl1bS5vcmc7IGxp
bnV4LQ0KPiBjcnlwdG9Admdlci5rZXJuZWwub3JnOw0KPiA+ID4gaGVyYmVydEBnb25kb3IuYXBh
bmEub3JnLmF1OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiA+ID4gY2xhYmJlQGJheWxpYnJlLmNv
bTsgYXJkYkBrZXJuZWwub3JnOyBlYmlnZ2Vyc0Bnb29nbGUuY29tOw0KPiA+ID4gc3VyZW5iQGdv
b2dsZS5jb207IEFjY2FyZGksIEtyaXN0ZW4gQyA8a3Jpc3Rlbi5jLmFjY2FyZGlAaW50ZWwuY29t
PjsNCj4gPiA+IEdvbWVzLCBWaW5pY2l1cyA8dmluaWNpdXMuZ29tZXNAaW50ZWwuY29tPjsgRmVn
aGFsaSwgV2FqZGkgSw0KPiA+ID4gPHdhamRpLmsuZmVnaGFsaUBpbnRlbC5jb20+OyBHb3BhbCwg
Vmlub2RoIDx2aW5vZGguZ29wYWxAaW50ZWwuY29tPg0KPiA+ID4gU3ViamVjdDogUmU6IFtQQVRD
SCB2MTEgMjIvMjRdIG1tOiB6c3dhcDogQWxsb2NhdGUgcG9vbCBiYXRjaGluZw0KPiByZXNvdXJj
ZXMNCj4gPiA+IGlmIHRoZSBjb21wcmVzc29yIHN1cHBvcnRzIGJhdGNoaW5nLg0KPiA+ID4NCj4g
PiA+IEhpIEthbmNoYW5hLA0KPiA+ID4NCj4gPiA+DQo+ID4gPiBbLi4uXQ0KPiA+ID4gPg0KPiA+
ID4gPiArICAgICAgIC8qDQo+ID4gPiA+ICsgICAgICAgICogU2V0IHRoZSB1bml0IG9mIGNvbXBy
ZXNzIGJhdGNoaW5nIGZvciBsYXJnZSBmb2xpb3MsIGZvciBxdWljaw0KPiA+ID4gPiArICAgICAg
ICAqIHJldHJpZXZhbCBpbiB0aGUgenN3YXBfY29tcHJlc3MoKSBmYXN0IHBhdGg6DQo+ID4gPiA+
ICsgICAgICAgICogSWYgdGhlIGNvbXByZXNzb3IgaXMgc2VxdWVudGlhbCAoQHBvb2wtPmNvbXBy
X2JhdGNoX3NpemUgaXMgMSksDQo+ID4gPiA+ICsgICAgICAgICogbGFyZ2UgZm9saW9zIHdpbGwg
YmUgY29tcHJlc3NlZCBpbiBiYXRjaGVzIG9mDQo+ID4gPiBaU1dBUF9NQVhfQkFUQ0hfU0laRQ0K
PiA+ID4gPiArICAgICAgICAqIHBhZ2VzLCB3aGVyZSBlYWNoIHBhZ2UgaW4gdGhlIGJhdGNoIGlz
IGNvbXByZXNzZWQgc2VxdWVudGlhbGx5Lg0KPiA+ID4gPiArICAgICAgICAqIFdlIHNlZSBiZXR0
ZXIgcGVyZm9ybWFuY2UgYnkgcHJvY2Vzc2luZyB0aGUgZm9saW8gaW4gYmF0Y2hlcyBvZg0KPiA+
ID4gPiArICAgICAgICAqIFpTV0FQX01BWF9CQVRDSF9TSVpFLCBkdWUgdG8gY2FjaGUgbG9jYWxp
dHkgb2Ygd29ya2luZyBzZXQNCj4gPiA+ID4gKyAgICAgICAgKiBzdHJ1Y3R1cmVzLg0KPiA+ID4g
PiArICAgICAgICAqLw0KPiA+ID4gPiArICAgICAgIHBvb2wtPmJhdGNoX3NpemUgPSAocG9vbC0+
Y29tcHJfYmF0Y2hfc2l6ZSA+IDEpID8NCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBwb29sLT5jb21wcl9iYXRjaF9zaXplIDogWlNXQVBfTUFYX0JBVENIX1NJWkU7DQo+
ID4gPiA+ICsNCj4gPiA+ID4gICAgICAgICB6c3dhcF9wb29sX2RlYnVnKCJjcmVhdGVkIiwgcG9v
bCk7DQo+ID4gPiA+DQo+ID4gPiA+ICAgICAgICAgcmV0dXJuIHBvb2w7DQo+ID4gPiA+DQo+ID4g
Pg0KPiA+ID4gSXTigJlzIGhhcmQgdG8gZm9sbG93IOKAlCB5b3UgYWRkIGJhdGNoX3NpemUgYW5k
IGNvbXByX2JhdGNoX3NpemUgaW4gdGhpcw0KPiA+ID4gcGF0Y2gsIGJ1dCBvbmx5IHVzZSB0aGVt
IGluIGFub3RoZXIuIENvdWxkIHdlIG1lcmdlIHRoZSByZWxhdGVkIGNoYW5nZXMNCj4gPiA+IGlu
dG8gb25lIHBhdGNoIGluc3RlYWQgb2Ygc3BsaXR0aW5nIHRoZW0gaW50byBzZXZlcmFsIHRoYXQg
ZG9u4oCZdCB3b3JrDQo+ID4gPiBpbmRlcGVuZGVudGx5Pw0KPiA+DQo+ID4gSGkgQmFycnksDQo+
ID4NCj4gPiBUaGFua3MgZm9yIHJldmlld2luZyB0aGUgY29kZSBhbmQgZm9yIHlvdXIgY29tbWVu
dHMhIFN1cmUsIEkgY2FuIG1lcmdlDQo+ID4gdGhpcyBwYXRjaCB3aXRoIHRoZSBuZXh0IG9uZS4g
SSB3YXMgdHJ5aW5nIHRvIGtlZXAgdGhlIGNoYW5nZXMgbW9kdWxhcml6ZWQNCj4gPiB0byBhKSB6
c3dhcF9jcHVfY29tcF9wcmVwYXJlKCksIGIpIHpzd2FwX3N0b3JlKCkgYW5kIGMpDQo+IHpzd2Fw
X2NvbXByZXNzKCkNCj4gPiBzbyB0aGUgY2hhbmdlcyBhcmUgYnJva2VuIGludG8gc21hbGxlciBw
YXJ0cywgYnV0IEkgY2FuIHNlZSBob3cgdGhpcyBjYW4NCj4gPiBtYWtlIHRoZSBjaGFuZ2VzIGFw
cGVhciBkaXNqb2ludGVkLg0KPiA+DQo+ID4gT25lIHRoaW5nIHRob3VnaDogdGhlIGNvbW1pdCBs
b2dzIGZvciBlYWNoIG9mIHRoZSBwYXRjaGVzIHdpbGwNCj4gPiBhbHNvIHByb2JhYmx5IG5lZWQg
dG8gYmUgbWVyZ2VkLCBzaW5jZSBJIGhhdmUgdHJpZWQgdG8gZXhwbGFpbiB0aGUNCj4gPiBjaGFu
Z2VzIGluIGRldGFpbC4NCj4gDQo+IEl04oCZcyBmaW5lIHRvIG1lcmdlIHRoZSBjaGFuZ2Vsb2cg
YW5kIHByZXNlbnQgdGhlIHN0b3J5IGFzIGEgd2hvbGUuIERvIHdlDQoNClN1cmUuDQoNCj4gcmVh
bGx5IG5lZWQgYm90aCBwb29sLT5iYXRjaF9zaXplIGFuZCBwb29sLT5jb21wcl9iYXRjaF9zaXpl
PyBJIGFzc3VtZQ0KPiBwb29sLT5iYXRjaF9zaXplID0gcG9vbC0+Y29tcHJfYmF0Y2hfc2l6ZSBp
ZiBIVyBzdXBwb3J0cyBiYXRjaDsgb3RoZXJ3aXNlDQo+IHBvb2wtPmNvbXByX2JhdGNoX3NpemUg
PSAxLg0KDQpBY3R1YWxseSBub3QgZXhhY3RseS4gV2UgaGF2ZSBmb3VuZCB2YWx1ZSBpbiBjb21w
cmVzc2luZyBpbiBiYXRjaGVzIG9mDQpaU1dBUF9NQVhfQkFUQ0hfU0laRSBldmVuIGZvciBzb2Z0
d2FyZSBjb21wcmVzc29ycy4gTGF0ZW5jeSBiZW5lZml0cw0KZnJvbSBjYWNoZSBsb2NhbGl0eSBv
ZiB3b3JraW5nLXNldCBkYXRhLiBIZW5jZSB0aGUgYXBwcm9hY2ggdGhhdCB3ZSBoYXZlDQpzZXR0
bGVkIG9uIGlzIHBvb2wtPmJhdGNoX3NpemUgPSBaU1dBUF9NQVhfQkFUQ0hfU0laRSBpZg0KdGhl
IGNvbXByZXNzb3IgZG9lcyBub3Qgc3VwcG9ydCBiYXRjaGluZyAoaS5lLiwgaWYgcG9vbC0+Y29t
cHJfYmF0Y2hfc2l6ZSBpcyAxKS4NCklmIGl0IGRvZXMsIHRoZW4gcG9vbC0+YmF0Y2hfc2l6ZSA9
IHBvb2wtPmNvbXByX2JhdGNoX3NpemUuDQoNCkJlc2lkZXMgdGhpcywgcG9vbC0+Y29tcHJfYmF0
Y2hfc2l6ZSBoZWxwcyB0byBkaXN0aW5ndWlzaCB0aGUgbnVtYmVyIG9mDQphY29tcF9jdHggcmVz
b3VyY2VzIGR1cmluZyB6c3dhcF9jb21wcmVzcygpOyBkaXN0aW5jdGx5IGZyb20gdGhlIGJhdGNo
IHNpemUuDQoNCj4gSXQgc2VlbXMgcG9vbC0+Y29tcHJfYmF0Y2hfc2l6ZSBzaG91bGQgZWl0aGVy
DQo+IGJlIGEgYm9vbCBvciBiZSBkcm9wcGVkLiBJZiB3ZSBkcm9wIGl0LCB5b3UgY2FuIHN0aWxs
IGNoZWNrIHdoZXRoZXIgSFcNCj4gc3VwcG9ydHMgYmF0Y2ggdmlhIGNyeXB0b19hY29tcF9iYXRj
aF9zaXplKCkgd2hlbiBkb2luZyBjb21wcmVzc2lvbjoNCj4gDQo+IGlmIChjcnlwdG9fYWNvbXBf
YmF0Y2hfc2l6ZSgpID4gMSkNCj4gICAgIGNvbXByZXNzIGluIHN0ZXBzIG9mIFBBR0VfU0laRTsN
Cj4gZWxzZQ0KPiAgICAgY29tcHJlc3MgaW4gc3RlcHMgb2YgYmF0Y2hfc2l6ZTsNCj4gDQo+IG5v
ID8NCg0KSSBjb3VsZCBkbyB0aGlzLCBidXQgaXQgd2lsbCBpbXBhY3QgbGF0ZW5jeS4gQXMgSSB3
YXMgbWVudGlvbmluZyBpbiBhbiBlYXJsaWVyDQpyZXNwb25zZSB0byBOaGF0LCB0aGlzIChrZWVw
aW5nIGNvbXByX2JhdGNoX3NpemUgYW5kIGJhdGNoX3NpemUgZGlzdGluY3QpDQp3YXMgYSBzbWFs
bCBtZW1vcnkgb3ZlcmhlYWQgcGVyIHpzd2FwX3Bvb2wgKG9uZSBtb3JlIHU4IGRhdGEgbWVtYmVy
KSwNCmdpdmVuIHRoYXQgdGhlcmUgYXJlIHZlcnkgZmV3IHpzd2FwIHBvb2xzLiBGb3IgdGhpcyB0
cmFkZSBvZmYsIHdlIGFyZSBhYmxlIHRvDQptaW5pbWl6ZSBjb21wdXRlcyBpbiB6c3dhcF9jb21w
cmVzcygpLi4NCg0KVGhhbmtzLA0KS2FuY2hhbmENCg0KPiANCj4gVGhhbmtzDQo+IEJhcnJ5DQo=

