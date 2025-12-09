Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1CD0D3B985
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 17:21:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFB826B0006; Tue,  9 Dec 2025 12:21:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD33F6B0007; Tue,  9 Dec 2025 12:21:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9B0C6B0008; Tue,  9 Dec 2025 12:21:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 986046B0006
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 12:21:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3EABD1401FF
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 17:21:18 +0000 (UTC)
X-FDA: 84200598636.09.77702E2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0C7DA20006
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 17:21:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TLIWdtCK;
	spf=pass (imf13.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765300874; a=rsa-sha256;
	cv=pass;
	b=wJtmxzWXfMI0RJvypO7F6Nz/CAnrcS93D2AXlZm4NO6ocJNPpFQtRRCv72VuhCmQyXN499
	lpi4g7cAauWyJUbOB7ROGm8NjyqVb9Nl9WyVa6kuLe1egS99KJpwRbRVzMc5UslNBboHTH
	wHIltTiOEzFG478/gvexJn93PK7PunE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765300874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mApKG2aFt7WyHSxB3tGpzXy5ejsbaFajrtkk4AxjnVw=;
	b=aLhYqV+sKNtN7B2KCHfCtiEqshkAzeajU1dcV8gtdJGi/EBcfpGqX3ENKpth+kSI32IM24
	UBC6vJ20llwGajOqXU8NJrtE4BXVX3J67UXatntjhZ13i1G+hmcaXv4H4hgaScV2KXheKN
	lyDiwkU3+M8fkRycXHGFMKQU8xK5qPw=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TLIWdtCK;
	spf=pass (imf13.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765300874; x=1796836874;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b6HYI82tBv6c+YGO4RsT2E5yz7kelWmy21YK1sRQneY=;
  b=TLIWdtCKbjAXFPULVq8RJMjZZdP5lJ4vs7Ad3FkcHl7rzJcbyUkRZ5Ua
   W26xsAYqdlfVDGXgzDXa5os5f/JMv2/Mt60oYOeBzpMobsvN0AGZ7h2uS
   Vx9snbivQCLvRLVOupkLpkdP7O0JRyZK+ch9WGHvhh8kJdZcPAae+Lns3
   QczppApb34Rvl9v+OOVcG8SQa1FdQgDS0FTLxLSp3TXcTD+CU3emL8Mew
   Cunh5wUDvf4SQcPjvMK3Mjvp9kksE2acov1VHWdWBWhhCGrkKdP62DMwX
   pc2EiBohSF82MSADGFVNUKc0rUokmgJbvJ204AqksDE96LUv0bENS+2O7
   g==;
X-CSE-ConnectionGUID: BkGdug9GTL6pl3xSzRtAzw==
X-CSE-MsgGUID: FDKjJUKdTVSV8rKyFpNkMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="67340254"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="67340254"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 09:21:12 -0800
X-CSE-ConnectionGUID: 1p7Pi1HcRritCK5VqbcXSA==
X-CSE-MsgGUID: 0pAwIWOMSL6iZMfvWVlGhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="196037389"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 09:21:12 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 09:21:11 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 09:21:11 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.31) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 09:21:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mdFVbVnwW6ts6H+KJ6zGmSeORxP14pQ8t34nWBwuh35uBq/16LQfSWrJTv9U9aOIqjQci/+ja+tte43elCTpiVDhtWLWLLsFUsecvEMmzMKI9sVKsC1jaz0hK+DT+pWg/xHYReUjT+mOQUU5MXXUPZQhJZpwl0yXb7g4s9qccT0IxB/aw+Iy7PXmVLF8zUs4YIEuzsSwzV3fSMHvI5cEqzvD9Loa/gRUg4+nm6nWku8QDMePdjoRkzYNVnEOOodP0IjlSJYZ0SQxGyye8S75K714DnVdKYWo4Kj0IDUyBC/nqLNqy3oR5nYHGAAfCsMxaJ/VoD8/zuPer2mCDZ4CCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mApKG2aFt7WyHSxB3tGpzXy5ejsbaFajrtkk4AxjnVw=;
 b=nw/qXNJ2GnZUc8xC9UAUHq8JFvxr4n1AJnSbvVqL9jurNwONQeJk3wNgJAw99+02+48gl70mAeUi4H6rUu8+zpFuTSk6D9q9MRuIgKk7aCVo9pMVxpcxLdeug7Cu7fdQjl+SakjcDY6b4hURs7hcSRj2jJglsiM52q6uPqwqRZWP2oWFOZKh3Mb97AJooh7k7OJcYXtES1WAvpRpcl+7cUyLFsti9WHiu0vJOcLmxcbF5wLvrcAYdDbkH/AHn7y3u+HWuhOUzptqNiPuvFCJdSGVokQOf5rYLBaVeA/MVvd6uZnA+MfZIo6Fn/uj1UEUqNpA5AFDSGxw2GHohwMxDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by DS7PR11MB7835.namprd11.prod.outlook.com (2603:10b6:8:db::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.6; Tue, 9 Dec
 2025 17:21:07 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9388.013; Tue, 9 Dec 2025
 17:21:07 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Herbert Xu
	<herbert@gondor.apana.org.au>
CC: SeongJae Park <sj@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com"
	<nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "kasong@tencent.com"
	<kasong@tencent.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Topic: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Index: AQHcTWs0Qo3eNl0w/UamTXF2PMbCz7TxL9wAgAAcuzCAAG5HAIAABzqAgACcWYCAEjbfgIAADVuAgADeg0CAEcgegIAAC4yggAAFRoCAAV2IAIAAFZkAgADxCICAAAPuIA==
Date: Tue, 9 Dec 2025 17:21:06 +0000
Message-ID: <SJ2PR11MB8472CE03A67C1161469CDE9EC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <SJ2PR11MB8472610CE6EF5BA83BCC8D2EC9CAA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <ygtejnrci7cnjkpomoqhz3jdtryjffmk3o2avatjppylirbbem@qppr4eybud47>
 <aSaUUez5J1w5WyE-@gondor.apana.org.au>
 <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
 <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
 <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>
 <aTeKNEX5stqjG55i@gondor.apana.org.au>
 <j7rqzweklga72b7hdebljs7nziz7bs7kzvevkuhnbwi3uespkt@rmkdqlpku2gh>
In-Reply-To: <j7rqzweklga72b7hdebljs7nziz7bs7kzvevkuhnbwi3uespkt@rmkdqlpku2gh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|DS7PR11MB7835:EE_
x-ms-office365-filtering-correlation-id: 10a56716-336c-4452-16dd-08de374756c5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?1zQixbh9Y6FissEH5OOl/ks7EA7F5tOmTv5lBu8g/e+kzol4iKXGTTDsDm5y?=
 =?us-ascii?Q?FH7MOUwDVMxpnVdDqkQ9+AGvJ2AEuhtXFoM+AaBGZ6YRfGOGpfy17z9KoQAI?=
 =?us-ascii?Q?MjxM6W/H+CWjkTQpmLORLwf4tOCW++b51WVjR8nHgck5ljtD28nOdJxZ3HFd?=
 =?us-ascii?Q?l3/Scg0PHl2hkhdVgwc6+yi44KKUDOsjvMwf/1AQdHgvU808rGA4K4oje6sm?=
 =?us-ascii?Q?Q+hVqZtinQJJQnC9kS2QmL12fQPgqxuQhGLzZSLIcy9aLFtmKS4SrLwj4tyN?=
 =?us-ascii?Q?AfaJRtNW6A6BGgZPfwIJthrTlmW7iCqXkm6qqXOmYwR97DwiAkOBrD+9rQ6V?=
 =?us-ascii?Q?ZbZ7Jlh8LJtOKGmXX6My/8NhZQfnp/wMPmwq37tXww+OdvUyQ8ILw82TlGkr?=
 =?us-ascii?Q?PQiZcAvwXUcTYgY9qvoRjHOzHFPTdUTA0RgCFKqHBaYHFGyxFg7rGYDFuEFd?=
 =?us-ascii?Q?Zf19A0zLc94lyZltkApbHsS64GiwOE8kkbXDDKQxy+cQCCZpBgJeo1q4JG/O?=
 =?us-ascii?Q?2BvcmdbiWWt3OYbu1ZDYlS0bmgihlR2Jy9s61U53O4Ei8ngJ6bVFUCmC2Zv/?=
 =?us-ascii?Q?bR2MWya/KYqNZS6CJAT72+rYQzaiX44r1vrFUCXLtTpQFPlmusQlvgCvJYvN?=
 =?us-ascii?Q?b7YQ2VDI3NQ/1EvdmYGwpGVfr+mPicai+novulq4oc92ZRrv32HxwljwncNl?=
 =?us-ascii?Q?przH5+bwwii1RWmHPZSCesJB2ykaG/LXb+ImoOtSczJYNZEZ/HPUx14aAbjA?=
 =?us-ascii?Q?lv228YdpqvdAe3afSqABSqE4U0tt/LxxDthMiM6bRimymI4W76G7xbwsq893?=
 =?us-ascii?Q?PbIRImv/62Qk+Xh+3bz8CWTIrBBmwI6oZlmawfA4D63ufNBikfD9hrIq9wy7?=
 =?us-ascii?Q?177Y2ttuu6KUhNTJUUCSvO3TNHedEq2++qd5hig/wjKa7Jbrj/TyuG+PrWhM?=
 =?us-ascii?Q?HUujqYZkBmEVKMlGsL2np0XLTxl9vTUw6gfxfwS3Srfb9k17DlXz9gDHaddG?=
 =?us-ascii?Q?CDAKsEwZh6g1YJ2rDCJ0fbjsdNLb3Lnd9wMcQeEuACJ7r++J98lo6iUCsnfv?=
 =?us-ascii?Q?NC4Itfn12Uua4khtEqW7MdFyZTK5WBVPQ5yn1kDQ/4spYOvK1FkDbUyrYV+s?=
 =?us-ascii?Q?dc5pZNvzd26CEFkF6ueII0xOHaydxZDeEil4lrHnA8rAxFxJYkwQXUvKCr+O?=
 =?us-ascii?Q?Qmd6XF4XNyfuMaF19lX7pnnIlBwviBz+50RLODprEoQIYZUHPgmJxclcNZjF?=
 =?us-ascii?Q?j7pVX+N3p0HUfG2cSfMNIp42elnVm5J6Hr01sWuL1IA4RRsES67MM9mkr2bu?=
 =?us-ascii?Q?t8ruls8eTHRrV/Zi3HlrnaOGgxvbWBwnoED8VQeouU/WjjzjzYOsOAPVK57c?=
 =?us-ascii?Q?Ee9rOAB3H+Dldew742NcUBnawV7K/hHiY8CtT8EHIrUGQCVc9+H9IsluUHoY?=
 =?us-ascii?Q?BVE675ch/atfcSgFmh6U43bu3TThF7DglyuYucsK775nzcPRhMWKYg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?H/TrONTq0xzx4Saa/WO+1Sh13UEBWV7D1NnyNuZneghrAEc4OQZ/1bUM4Qh8?=
 =?us-ascii?Q?bM5KATpWuzd6faxN9Hqb+bY0T6EGze/di4OdFQpSSYlJF41z1oEvHFwbdnX5?=
 =?us-ascii?Q?oflkoLp2+J9/nGIwE0xFlBQcuYl5Jipra+KmCs1jpKSkbWd5wFQp1GHQux/I?=
 =?us-ascii?Q?c3MiO+iJdesKeJVDFY5e0VAYmcUk+e2nsTndAHKbyZdU26bnkMA5pzdTRLIB?=
 =?us-ascii?Q?m7XD1kOb82JcPvGxDDNfWWDgUyVZrYDf05qVg7M0rXlNDIzrs1d4a6p7RYVr?=
 =?us-ascii?Q?HLcpLEsGvrGpLumtqGhByrUn0VfWdghE4f+ngG+4E4BGWhb2WcnhNfYTiHlP?=
 =?us-ascii?Q?KscmfgiLcqaVrYKSdPB3dTM3N4krkiGgghxkcT0XnUmzbIsrP3G7lwxDqrg0?=
 =?us-ascii?Q?VDskGdLaGM6AUrXq8GvXi1HcRkhejTOBhwN1mSy5Amwb6qB11OrjnsJ0bv7T?=
 =?us-ascii?Q?6qibfB6hYGUq2oxJ8M94yDSgEEOM9voQI+GdSgUEHtBfvi8lI5AB7Fj3TBus?=
 =?us-ascii?Q?58bG9E6BmK8u2muckYv4JwhhROEanUVLDylpv5i2XpM9biTcPOcyd+RkErCA?=
 =?us-ascii?Q?DJgCJ2HKYoJfPxVqpLlEHAG5iIbbJD8WCk92RzmxGSVWEJfIzYPBYrVT2yDQ?=
 =?us-ascii?Q?D7ngaNdndGHQoW4g6axMehv3u9E04cyy7SOqbeGvrsf3sRV24g4RrR5wykYp?=
 =?us-ascii?Q?oAR732vE0CFdWE5eyiMKos8nuPXA/NJfn6ocpdsG6qxPw/G//vT9jynGVikT?=
 =?us-ascii?Q?74Q6aFtwEaAnZVsTUYpFHQUhk7wD/Ln4E4fBIsbJls6DcMaswAy7YffHSKP3?=
 =?us-ascii?Q?RL2UDAuC0mTMNAvWbOq100GgGa9SkJX2nAnppIui5UOd8jixHq/LeH4nV1Ed?=
 =?us-ascii?Q?6KOEs5u+WGYcpm1FDEXB+y6Ozc2p2Ee4HToLdQHM/tr1PTz0OT05B6hikejp?=
 =?us-ascii?Q?lu+Y/2VM+xdd5IudirHOfvnB9ZX2IsL/a5JP54JT8fBTJv7YzpKEzVOBsMJN?=
 =?us-ascii?Q?03OxrawLXUNEcSiXu8uDzgZPkfOk3TT/VpHX7TH8iwziqHjB8evydiSYFrnD?=
 =?us-ascii?Q?x9GmdsFPzVZl/9EWp4AUuxMME5OCfIR/FlJFY9ZOZLgLLwn0qS0DCnmeeSYV?=
 =?us-ascii?Q?VL2m7J9sLp/sc0XL9vjNlL4W3tUZylHAnTyY7ZBEgwpB5L/6je7KxX3JY1aR?=
 =?us-ascii?Q?AxHNBH9/7DSkXb240wqA2KbbDligxM03OSjnBt9FB7K1GMZuYSN6z9lgtalM?=
 =?us-ascii?Q?xKQupW5ZXk2HH/P/dW3NI1fAsJ1Zqlqrr5++aqq2HZrdzXv0RCr9UL3bGd6m?=
 =?us-ascii?Q?sx0FnVNdIGVRMe3h4BiudvEoD0lx/uTHpMGEmbvdjgzO6VKM6sKE4Xi/6kpl?=
 =?us-ascii?Q?rI9fNcN9FBzewDptMF0jf4vMCv9gNfoMcHuZMw3RiBtl2vzM9CBBe0oLDR4c?=
 =?us-ascii?Q?IkC+5EAY7SbZLwByccVbH/8TZFblgFW1LiCvO5b/5PouQ3lLISpmsjoDEeth?=
 =?us-ascii?Q?a3HQtdMRLmXP8AfA3+51a8HOUPnWWqTIC/bdNQES8GQEFjMYDzCvKPE6d7o/?=
 =?us-ascii?Q?rEldm5xQRmlHZR7aquB/wKOS5BmvoM+O4T1BQ5gmFP59A8Cd24UHOE0XLUWO?=
 =?us-ascii?Q?eQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10a56716-336c-4452-16dd-08de374756c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2025 17:21:07.0613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TUVSHxTojBJkPEZ6S9K4814WKbPAshKI48Z0jGWNOhJA9CO6soQt7wXcnG5Pt/PVJ0FGF5QXO+HymzKb14Fgb7+seWTaZriTY9ffswmLf6Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7835
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 0C7DA20006
X-Stat-Signature: bmakdbbzyi8161noi77bbacfexb4nim5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765300873-557648
X-HE-Meta: U2FsdGVkX18kRp9m7gPKbtGhfNJl7OI6ZLPIQkm3Pdw8RUrD5JcP2S8NCpEZL7s1we7nFDhCHYsyLMVOc4IoqDTFTP7alIeu1je6dQ4Mj8HtJTlekX8c6uCard+eNFT1u1uKf4tIQAxrYHw3ScBWxwPNJA3r5y4B3ZQC/dDMYJDsvjkAqPmHZ7SkHdY6kuNg7AlrPqxLnj/a7GbIEKZKXKGV+Bw+U9Xv8bHfTfwbYqhWGliCB36TY8Xt+QM38MX+GI54bvi0qYYpeszTTf2eLPdKi/Py3iaEkBpoUTUeVPYGxn6dnA35yzIJKGJ9uarLfyK0WCd7N3nbzLhS3PIuVUhIB6jh3DvIuqGKEhOCvT2L8W1GXf/XugRzZoX71yQ0EP6aE4mvvdjv9r3bbmYuxYbpEHckQ5qu5BPFjxt7wbkDZscuIF4GbF0TC8hIx4C5SYAWl7i9Z4SItNQ4qXRZ2IUeN8rm9N32IOJAyAYa9VY7+EK0y4ji/zPOFjKUE5j/8hpAwOqPDHe6wMlVr+hhMhGoTU9Q3wED2qki7b2kRHQeQ6jKhJy4Z9vCeaTGPh7/fOFatrmZQ620npI8uvu4hdTL0IjOak41nAATs5+CBFm7jYNSh3Sv24zv71b8mR3jysK7ia5C7eX3UXXMoop2FPrpZIGVLliPmAMRXc7+/pcZd1W6s4aDeBW9pxZCZZKxqRZWyG+aO1a7pkNRcUiWy+8gg3hWvqlD3W3stSKPwtlp/Maq9Ay/zuYRHqe8Uy52VQS1UHLietWOFQa15LLcEBfnbxCQeR9ewZT0IEzbVSBTBpVj7f/jAa1VgPw5MQ4JswcmFhw4Hqc1Hkn7ddP0ta+P8nzaSJ+eH5S7lHMX6Za6OfSN4n/zixY9QzE0y6M7sWZR58ysDR6+YkwA1zVrZQT9KYfZeCTAKJgDrwnxS5T9kq/8Ao/a6XpjPNr1kqhhr9sQJjXJF1oXIq9jvEn
 9jX5gdRO
 xyoC/OkjTIY1aRo6jDovdm5hLX+rNS8N/XaP1YrY+gGw3IUz9Ko2znedoYVUjlBlQYit1CGHzA8EgvmJvf642sNfoOzoR17u75j8pK9N7w0aCKIFaal6v/6jsiNa0pN+E0lVJDU+Kj/GisyTKo8qR89P/2T9cfS+rVc1d7meklqtR4s9VCQTSkc9yvd60kf2IVZwrZRSmW/6B4BtbEdEDGZS7qn4lXkomInpx3QvcbnGh1vK3KfJMddq/Sh9qG/ZeIwo7+Obr9nC+yoNnqmPqkjHd3EdkNWQjYmIrvG3snNwcEDn7rlPSUlcGawH8tYESuuOPAXurRu1HJ04PllcUgzwZKO4Gw+rNTd5eeyDUuEmx2CIFBpfUeWrjdak4SDJUmEo7wNS/D1nHh3nq+6zcTIpB3etzLrbSED94qwHUAtDy0maV9mNGk8d0e9pvBvpXSdbteBlLp982fipElJ0mBaa0lcXdEs1FKnomqKNBWHmKnSvVvDda+4KN1IxPhuEFV6+kJL15C4uvAzwDQD17xZLja1xayKrJ05u20Qz3anoomKrErSB2DDOmBeck36AtN3R07K9pMU5ACKVPqNWOcG9rmoz5ABSQJvU51M225lqbCvadgWndDowXP53Wjyu3a+YwUBjqIhTlNVciopGcKDxuWy52Epq31T5CkFouifzQ20Uwiwj3KF8ueiPZ8CSruAOVScmMn/gEXbrfxQYI0nLpDEzO6HR1SGEMJqK8Rr1E8aKNvIQSYzFsoToBqTtFekdcL0AUuLF1k7CocQrmQwt7DGjMZhamJO7LSUgw54ehiIweMxHWBPEcz3p0UAL3IHDZsNC2POxNjmGtaUhaLd/nKJkVV3d1EvXo8zXM6jRRsgangVN6LUeMYmsPmz/FrsunwKHU70oLMQHJA9q5A53mcBSoveksERDlVRqR7bE85bxNu5iKCfDeiHiL3lVuMLlT6tASNmv4ffV+m9wnKAGeLL1C
 urRkFOPW
 n+OZmShzIhWTeuyt36DINygnAywhGmZvop5UT1MMkWY3DdVP7/AKaLbYUlUnIqF990FVW5UEMzMUaxr+UAj2HmmTeoUyHJO96IOW1wFXy/TE46PBv+C+wQkO2e5nltkppNIZ6S81p14=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Tuesday, December 9, 2025 8:55 AM
> To: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>; SeongJae Park
> <sj@kernel.org>; linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.com>;
> Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
> compress batching of large folios.
>=20
> On Tue, Dec 09, 2025 at 10:32:20AM +0800, Herbert Xu wrote:
> > On Tue, Dec 09, 2025 at 01:15:02AM +0000, Yosry Ahmed wrote:
> > >
> > > Just to clarify, does this mean that zswap can pass a batch of (eight=
)
> > > pages to the acomp API, and get the results for the batch uniformly
> > > whether or not the underlying compressor supports batching?
> >
> > Correct.  In fact I'd like to remove the batch size exposure to zswap
> > altogether.  zswap should just pass along whatever maximum number of
> > pages that is convenient to itself.
>=20
> I think exposing the batch size is still useful as a hint for zswap. In
> the current series, zswap allocates as many per-CPU buffers as the
> compressor's batch size, so no extra buffers for non-batching
> compressors (including SW compressors).
>=20
> If we use the same batch size regardless, we'll have to always allocate
> 8 (or N) per-CPU buffers, for little to no benefit on non-batching
> compressors.
>=20
> So we still want the batch size on the zswap side, but we want the
> crypto API to be uniform whether or not the compressor supports
> batching.

Thanks Yosry, you bring up a good point. I currently have the outer for
loop in zswap_compress() due to the above constraint. For non-batching
compressors, we allocate only one per-CPU buffer. Hence, we need to
call crypto_acomp_compress() and write the compressed data to the
zs_poll for each page in the batch. Wouldn't we need to allocate
8 per-CPU buffers for non-batching compressors if we want zswap to
send a batch of 8 pages uniformly to the crypto API, so that
zswap_compress() can store the 8 pages in zs_pool after the crypto
API returns?

Thanks,
Kanchana

>=20
> >
> > Cheers,
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

