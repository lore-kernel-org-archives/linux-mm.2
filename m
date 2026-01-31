Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8648FE7C6E4
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 20:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00B86B0005; Sat, 31 Jan 2026 15:32:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAAE66B0088; Sat, 31 Jan 2026 15:32:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D597A6B008A; Sat, 31 Jan 2026 15:32:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C4E906B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 15:32:03 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72385C20CB
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 20:32:03 +0000 (UTC)
X-FDA: 84393405726.04.5074F57
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf07.hostedemail.com (Postfix) with ESMTP id 78CC640005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 20:31:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YhA9fFiI;
	spf=pass (imf07.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769891519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U/+BEEPx+qD3X0WHe2ewT+7MK6bgCvCpBfMhE+0MM6s=;
	b=z+aw3r92SNqjhAf+WucEJxYlnMpy6yZdRyclOm/r6MkWED80VwJehnJaFgGomMkMVk4j3E
	JNpoMm9CmFrShB5y6HlNGTkA4VYrU6up7oaEfcfI0uMn49iUEi7sjFLmgl0zM6bDvnynpH
	sxwnVoeYaE1hv0UPCERDY3IfvOu8150=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YhA9fFiI;
	spf=pass (imf07.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769891519; a=rsa-sha256;
	cv=pass;
	b=ShLQa2WJevM1UPKoNKYd7udQJ8jyD8oWDM+VhHirNdHTb6BafbWyNuSpyIbapfoHgAeMJb
	FaPOGNHUPZ8AOGVzUeKcAwUbjsgADxEB3H2QndFyD4O2cFciW0fWD2/RKKzooJX+SeYz+6
	gq41Ui6xYpjkGT3+rTp5Tj87RtIGbH8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769891520; x=1801427520;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=U/+BEEPx+qD3X0WHe2ewT+7MK6bgCvCpBfMhE+0MM6s=;
  b=YhA9fFiIBeNtZQ82jL5Lc/FyfgONT1nb0kJECslubxsdabM6+MKpGyWz
   Fb2XBktq6wKsLeXYfIv1+iGKxi/EvlmkDHfnL1QkNa+yDmnAUfNZU0E/9
   27xVTz2F3I/k1YaLRilD2YMozHiItotLlLfuLBbudOF1DN/8nM+oKilGN
   URFu8PJaKagens/XCydQfNh1PDbRGvLkqIqIcxZqJCBH9xCh6NDPZqfyJ
   /gmPzRGbGT0Qs+EulPJ3iyYR3AMHCMiGWXI2K5Jgngg7KYPSxR2MoCpYt
   3o/jgMe8dB5cFTXojdMflvVqluq9QEih82DfXlB72WP+0Nq+9PYEwE2DK
   w==;
X-CSE-ConnectionGUID: lA4cO+QnQo+nrFwrcRXH4Q==
X-CSE-MsgGUID: C1MbqJ6USB+cdlcAGLw52g==
X-IronPort-AV: E=McAfee;i="6800,10657,11688"; a="70310968"
X-IronPort-AV: E=Sophos;i="6.21,265,1763452800"; 
   d="scan'208";a="70310968"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2026 12:31:58 -0800
X-CSE-ConnectionGUID: 6phBabXrTxGBbp52Tdv6og==
X-CSE-MsgGUID: 9GAosSBRQY2F5onGL9Z6cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,265,1763452800"; 
   d="scan'208";a="209537654"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2026 12:31:57 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sat, 31 Jan 2026 12:31:56 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Sat, 31 Jan 2026 12:31:56 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.13)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Sat, 31 Jan 2026 12:31:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oUfsb77VYQg22nEeGiG9dB0u8Sydm0T7msBwD69EWtCF9prMZbmzR9Tbwq6X53Dbletz88H791bLUl/P71mlzWC5WIhJXyD+1Xg0VYkJyHtshu2vwijW8hhQoM37AbFO+PULlCMzBYyJSfm3KYt2y3+jTnpO39FrZrFmYzpdFWNlNmk3MBGzt82k/sYMQcbxXMRzoImfyppktw5eFuJ5FaBdb1EhzRdIdQ8JO74WZtncpnOwGcEQ9Pfl2ksVhXHJNrUX64xCNLJo1qVSS7XsOj3QTWCdOEUAKfE720o/zAmT54mSWDEqyhS1PzPL9CNUKDO2qjo5llJGdhH2CgDCjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U/+BEEPx+qD3X0WHe2ewT+7MK6bgCvCpBfMhE+0MM6s=;
 b=OUzSRG4Vq5PnnkWBdFkUm96kNQwjnc7OIlQ4wA8I9NkmcOeDbdCf/Wada6A0lMIwa7ZVz5GQDhNp5Uaq5FfC+TUe8dlbSGh4TC2HRzWEY5CEKBTOavfkrlaTK+/7FJQjCut/2h0etGN14oDOw5Jo99LzthIyv5EeAn1vgfUuXCk6VBx9YkoxgxJBVrrCPRVZYQI1Xq6lp62FoiLVrZzBBsyQV6Tzj2ZX7w5fB5jNWEikU231Wuccq+YoNYE7oUlOJShtInMgpOEMSQAzwB/7/bQqJoDBh+C3gYLeBa8DgxnX46MAbS5lsorNeIjLa8LGHCruvR4SaTbqyKznBzvJ6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by SA2PR11MB5212.namprd11.prod.outlook.com (2603:10b6:806:114::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.14; Sat, 31 Jan
 2026 20:31:48 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9564.014; Sat, 31 Jan 2026
 20:31:48 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Nhat Pham <nphamcs@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>,
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
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Cabiddu, Giovanni"
	<giovanni.cabiddu@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v14 26/26] mm: zswap: Batched zswap_compress() for
 compress batching of large folios.
Thread-Topic: [PATCH v14 26/26] mm: zswap: Batched zswap_compress() for
 compress batching of large folios.
Thread-Index: AQHcjavINWdijqC6NE22B4mO/Dl5lrVrggWAgAFBfSA=
Date: Sat, 31 Jan 2026 20:31:48 +0000
Message-ID: <SJ2PR11MB8472E5DC16759FFE6E23EED0C99CA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
 <CAKEwX=PS7mjuhaazydkE2TOVa5DWQu9521FqH4aXi0yptZQaeA@mail.gmail.com>
In-Reply-To: <CAKEwX=PS7mjuhaazydkE2TOVa5DWQu9521FqH4aXi0yptZQaeA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|SA2PR11MB5212:EE_
x-ms-office365-filtering-correlation-id: c9bbb2be-f747-4b63-66be-08de6107c25e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|10070799003|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?OU9PRXMxLzZIei9uMStPODJOam9rSWN5WE1jNWd5bFlMRWtBODk1Q3NwWFhX?=
 =?utf-8?B?Tk1GUDVRdTRPcTVRd1lJVXpCZ09zUmFCNkFiSW40MnNiWEE0aWFPMTNsUHF5?=
 =?utf-8?B?WTMyZFk2cTIyTlg4Q2daZkx4eExmd1dvdUpFaWlaS2dkRkRpaHdDcE5OKzUx?=
 =?utf-8?B?SEp1Y1lGeml2UldXUEhudHFncnlTZVRiNmcrVk5VdnhhSjgzYXZVem9RZXBM?=
 =?utf-8?B?Rkl5V3BhSXZ3TUNhcCs3dW8waksvOFRnTzZjSWZQVzUyRGdyRnkrQ3pwSTEr?=
 =?utf-8?B?bUwrMWVjT0FacWIyVzBHWmZqY0R1Ti9BdVAxSFpsZCtBZjlrNlBCUU5ycmU5?=
 =?utf-8?B?Nit4cTloY253R2ZKQmhZbmFXdGxoY2tqVWhsM04rNVFwZVVabnBOa2xQR2wz?=
 =?utf-8?B?WmMyeWwyWlZYa2JTR2pmaGdhU1JyZy95Tm1BZzFwd0QrL3ZtbzQ3L3AyNXRl?=
 =?utf-8?B?TU5OOElDcmZ3bVVTcjRjUDZ3NzB3QlRHNlI0cSt6YlRBMkRTaHQ2WDJZS3VE?=
 =?utf-8?B?UU05ZFRjU1dYeXFUK1lGQ2w2dC93azdMSUZsd2wxMUg1b2phK21QMmhRaUpv?=
 =?utf-8?B?OG52MmdHZ2RZeUJEbThTRFJiT2pWUUMyM1hDa2pNek9LdW9mYW1xNG0rZ0VU?=
 =?utf-8?B?RlBCamF0b1d6NDhkTjEvUTZieG5scGU2VlhUSkk5WStvNmRvTGQ4VlFFTlpP?=
 =?utf-8?B?SWJYQUNJWjZPQ2RVTkUwMVduUDg4TkpPYkttODlnQnpHazhQTXZaa0lhZDY3?=
 =?utf-8?B?V2p0UEpsLzZZa2wyZ3Y5SkFzdDVYWVhHS0s0Z0ZtcHl2RERRWVhUUGRsdlA0?=
 =?utf-8?B?aG9YeE9BbW1sNUJ2Mk56TFFIamR2SklkcTNwSHVFcjhNbHFlczVvUVBJUVFW?=
 =?utf-8?B?R0U2VEczRkdaUWVDdk1QbXJQWGhlWE9LZ0k3bGVBY0FNNjhmN2N5UElES29t?=
 =?utf-8?B?dDE1QWVNdVArcVJIVC9VZDBzbS9IMkd6OGtQdllmWE45YlpsZWhINFdoWW91?=
 =?utf-8?B?SytMVVpzTU94SHFiaUV1RkNwRDJ1Zm9HUEx4djRjcnJrUWM3MmYvMGZhZVZT?=
 =?utf-8?B?eDlQOUNoeFJOR1pQK2c0T3VRdXV4YnhCb1JVOUdGV3BreHdtWlJSWFdnUFYr?=
 =?utf-8?B?UUE5T0JpUnNrQzl0M3VTRjdqUzZZamJLOENhMm9sWmRuYTUrMTFKY0p2R0lV?=
 =?utf-8?B?dTJ6eHBrNjBjQk5WWjhrKzFsL0g3ZG5pSEUydlB2MW8zWldYQXkvK0dPVE5V?=
 =?utf-8?B?cUdyMHViKzQ0bU92TGl0N09Ga0hrQlQwL29tTU5tMDZ2UU5HTGNKc0lZRWFr?=
 =?utf-8?B?UE45OEk2MUI3c0FWQjc4TnZUcHF2Zmg2VmxwZ0Q4YkUrNHFqRnY1U3ZnSExE?=
 =?utf-8?B?eE80aHpKMUcrVmNyb3ZIMXROYjhZWHFqSUNCeXgxYUg4dzFiWi9aaDBuRjQw?=
 =?utf-8?B?RE1BUEtvYVdsSW1wT3VJa2YwbDM1QkdBMlNkV0l2VkJUNkU2eURRb08zZVdw?=
 =?utf-8?B?b255RmkyTk9MR2JzRkNSdys3bTNCVXZPaUtCNklYTU5qWDNqREdKOVgrOG9r?=
 =?utf-8?B?N1FEQWpRSG1qd3laNStnVGVNbGxwZ05TWWE0c1c2LytpZC90b0FWY2l1bldh?=
 =?utf-8?B?R1I4Zk1aSFVlQ003NHgzOUFLaDRkTERhZWVhK0pYb3NHMnJYdlVzM1VxWjFE?=
 =?utf-8?B?aW1XaDVvT1RlZW5KZEYvRGp0YmtDcGNoYkQvcXdHWklMdDBmT3o0QmlvSm9F?=
 =?utf-8?B?ZHhRbFFodHNnSkVtOHZKaVRvd0ZGOGZSdmpiVlZETFpGV2ZNd2l4YktCV2JM?=
 =?utf-8?B?Yk5lbFlyZERQUHBrSHBoZHpTRVVQWXZaWVU3NzBYSVBkRlYrMDduaUJLV2x5?=
 =?utf-8?B?OHUyZDZ3TFFMUkpDTkwzWldKKzI0cWpodjd4dTR3eG5mVWU1SWsyQys3Z0pI?=
 =?utf-8?B?bWRFQnFWd0tlMXdvM3FqSEFoWjhLNWsyb2x1Y0lnRTVOYzREMFhuOTg0S2sr?=
 =?utf-8?B?SGZjNkZlOThwK25zejhoTzZ2WFJMaGttSGt2cUpBeERBbXBIOUlkeStKb0Zz?=
 =?utf-8?B?ODAwOUM3N0FoZnVPRDI1a2JJWnhVc0VTeDQzditiZldpY2pEaERrUWhoTndk?=
 =?utf-8?B?UWNSblFUalVjOFQza0hudVc0REpIM1ZXdjFUK21JWGc3T1pQT09BbElyQ1Vm?=
 =?utf-8?Q?j8owXOp1+C8Jgf60eGw+LRQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RmhvajBwbDBFOGVpeEFtNXB0QmNKdjFiZ2o2YUg1M0pwVHB0RmxXc3c0Wmxi?=
 =?utf-8?B?aFIyTGV1aTlqV1AzajdoVm9NWTJHS0w3bnY1NnlzaU5BajFSVVpQYzd2V1pu?=
 =?utf-8?B?ZFV5WTI0VEx6ajdYbjRGdkZXZ1JmSFpSVnZjSjdMU1R6OG55TTZHRHdQSHJV?=
 =?utf-8?B?eFVWc0FlR09FcnVNdU5RS2t2ZUNObG0yNWR4c052U0UySHN0U25zQVk3YjQx?=
 =?utf-8?B?dHhpTUhGbTdjVzM2c3VQSjUrbUpsa3pYODg4cVFzQXpTRUsyMlZDcS9hdEQy?=
 =?utf-8?B?WlpqYTdITGd0OU1neGUzUHl1VUFFZjdNM3dPeVl4cncvdkdxUnBPeUo3WnZ4?=
 =?utf-8?B?VHJzaC94N0JOUCtDM3RERWhNTmtRM3MvbTVVRnMyczJ2c2p2MWVHWEt5ZEdV?=
 =?utf-8?B?SVVpT202RjBYT3VTL0U4TTdBbGxRME94RFVSaUs0NGNWdWRoTlpGcldLQ09l?=
 =?utf-8?B?bEJIRGNGdVdkNG1XeHIrRHY3MXhaRG14aTdvbkpLOVRTMTg3WGtqd2RGMFU3?=
 =?utf-8?B?QThVb0pPdjM0SVNOTVJGWkhVQStMTjIrTmJFRnZKcHByZDRXY2tjY3RCUU1x?=
 =?utf-8?B?dEdIRmsvejlUdExUZEM4VUt5ZVNhVzBhMHM5ekF5UWxkOG9UTUhJZW84MzBH?=
 =?utf-8?B?NExpcmNaR1FLcmVVeHIxeEViODhlWGYvdUdEcnpTRy8zRUYyWW91cmJ1dE9G?=
 =?utf-8?B?YVF1NDBwOXpMMVJVQzJrOEcrT2VaTGFncGJSTTluNzV5aTl2TlFPVHdHaXlo?=
 =?utf-8?B?TzAyZ2NWZVlHdTBYVnhxS2hVcG1nNU5UWWFnbThvSjZEbjNGVThsVzZTRXdK?=
 =?utf-8?B?NkJBVDdPdEhPaSs0V01SNVB3WkJEQVlmTi9YV0IzMktxWE9yM21wQlgvcnNl?=
 =?utf-8?B?dTY5U1RQK3cwZmlVbUNISjFPZ3dKUGtJSUZjYUd1NzhCOTFHbnl2RjNnTkp6?=
 =?utf-8?B?a1VVWHRUMUljMWplaFMwd1k2Y1BRZzY4ZnN4UWkzWFkyc3VvVldjTHNER2I4?=
 =?utf-8?B?UTNEVkZEZ1hsSjZZOFFkdmNkbDl4aUdPTW0rc1B6cjlOdCs1MTB5RFVBWUFN?=
 =?utf-8?B?QUtYTzJCNWVVWHFuSXBWUmNnOWFNSGNCTEJhY2UrcG1hejlreHNJZGNsY1J3?=
 =?utf-8?B?Y0NYR3ZRUzEwRlZKRFBDUUtCaW15MDdrYk9FYTlBNEJrNDduc0M2Y2tFMzdV?=
 =?utf-8?B?cmg4OFRmanFHOTVsSHJsL0x4YXZqWGFicFVmazNqN0phV3dTWjAwZFlmQUw0?=
 =?utf-8?B?b08yTi9NZHhHdk9DdVhqZ25jK2w4aFBQNXJta0NrUCtld0FqU3U2YXJ5R3Zo?=
 =?utf-8?B?L0gyc0JVcit2R1hJWVllSWFyaFpOVWVWMFZmODFDeWE3VmdEcTl4Sm1xZC9w?=
 =?utf-8?B?SzhiNUlsejdrbkUvYzJCUFZ4RUhhVG4weThpajJYeGFyNVM5SmN3OFl6VEhv?=
 =?utf-8?B?bE4zMTdJOHBVNkNvK0EzeERrbVdoM1VhUFowMk1tNXM2WE1RaWRLUE9UcjZI?=
 =?utf-8?B?OVFvNGpUdTJ2TnB3Z3NFRWFpSG5aS1VtRWxGYXV4aFBlbVRaeXRLVE45THRk?=
 =?utf-8?B?bFdaWGkzVlQ4d1NjZTNtSUxFdUxzWkRKSUVjUkpKWHcwRjMrRWZnTk9kb1Vx?=
 =?utf-8?B?a3dlbTVZZEJPa0w2OGtBVWxKMTVRVHpmQW5aMEMvZzlyS2MwSkJTQUYvYVZq?=
 =?utf-8?B?MlUwNzFUUnRKL2ozNnkyeW1lTEFtbVNNYTRnbTZ0bWJiYW9uZUhQNTNBM1E4?=
 =?utf-8?B?VmRYcTBIYmJYT2hRa1B3UjZLVmtSMXprTStuMzU0dEVEbmJONzJNYXloOFNS?=
 =?utf-8?B?REN2azRCY2t4bW5ucFBFbkNwYlBxZVUwTWRnNVk3S09xZ3ZLb2l0SDdsM3VZ?=
 =?utf-8?B?bFNDUmtCZVR3Z1oxbmJXNEhla21TaUhITmgrdGMrOXkvejQrejl5RStWMFNn?=
 =?utf-8?B?a05odzZtazdXL2t1Ykt5cEhxemh1MWl1Q2k3NTFTRlZsdzlqcEFpb1EvTkVx?=
 =?utf-8?B?ZU5iRFhLc2hNRW1RZU90MkJDUVdLUk0ySDdwQm1OTnR2UmVjTklZRWxESWdN?=
 =?utf-8?B?QU10dFN4Y2NTaHBhR1RlWXlNSWNGL0hiUXFHUUh5VGZVOHlsd2t3T3JjL0x3?=
 =?utf-8?B?c08wd2FWSTc0cTl5N09nSnRzaWpkNlFOZXVKTURpNzVxdDE3anR6a1JQVXFr?=
 =?utf-8?B?M1pZcXdwN1MxWVdqYlNTWUhLRERUaEtqMGE2Z2RaL2pTeVQ0Vk9MZFM4SHFC?=
 =?utf-8?B?dHk1Q09NNllQMTlOYmgrY2N3N2F2RWxiNmluL2MvcE5ZQTgwRzI4LzJnb0dH?=
 =?utf-8?B?NUh5RTFqNHBpOTE4THY3cU5LM1hIcU1ucFpHKzAvcG5HcUJpN0I0NjFaYk9l?=
 =?utf-8?Q?YM8MJPC/lM5m7jd5xmVAUzHB1Q64n4njaEKasYOmzaa3V?=
x-ms-exchange-antispam-messagedata-1: ChFwMy+vWejXiIRQ0Q2shKVeuF8T8Q9F0Sw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9bbb2be-f747-4b63-66be-08de6107c25e
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2026 20:31:48.6419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J03TkZbAWwzf0KYQ9uozC6uyZOpMCRkbhwl8RoBwIT8/JZNW5/3ZB97xHPWapsFRHKP2S4Xg5o5SGo6nziJ6Ut5y8HmXzFrxre9P+kg8myw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5212
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 78CC640005
X-Stat-Signature: wkpzfkkfjeu7iecdqy6h1nmwhdwiyizf
X-Rspam-User: 
X-HE-Tag: 1769891519-339945
X-HE-Meta: U2FsdGVkX18Tz5F/0fFDh0QFgzKLZljMxNjPIGHiUUesnh2/EVVS6PG5Owc6WHqvCkeyMJnyBj3mhT+OTJxlXw8hXwPdUWvFv5wgTv6RVtjQrDGGHcFa7RZLl/wdbdBRUGTaA5bXjoQ4k9ic+9Lpmq2GlVTEgw+MsmlG2q8OKfRAX1824L2CQGAugNxdgJV4MiLL4ItFcfeCYlwLL+ck3fEhIgzbpI81BkGQRQW1zVc8ZDiItYwT+TjG2K754pI8SqB1krAjyfW6z1kf0oUapnwKr0QQskpZAEE74j+OP9UkScNO4VkNZlMThnWg/V7WFZfED4UaSe1xqHEQ7hW6D/u7/n2SruwebGbiVhtuSZRXZ1LOggSPYTB3whnpsaN+9GB0b6gtobo7S2o8PcxMmRGjHulJ4/rwk7ajmBs6FkMvHOgfN9LcWKBVef3AfunQOJDdVMLHmqAzsWvrmE0DzGOor7DGS0/yc4TbszGlCmfhRpatLpeoLWKU1nV4IaiP82oZXr1esP4+lVY1voceVaGFkveEWA7dze8qYq0GQCTPKaK9Gt2mAIiV482dgvCLpdufftvHxK3Kd2t7cOHFhjwWJFLQklUq7/xE25D3QAfYFLFabHkUJ8Uft4Fz0AYOvceSv9+X8U7rW9UnuYAH+ju6LmhR+ZZ3QoriJy6xS6nCPlitDTXJWLggdzpO4P3EEMZht8ZbstEdVP3FUR8faDkbGJG4qhZV46nY3QksYLBno+hJ6oTaii9sEB/6a2Wc86bXRbpWSzObZgr7amrPdNZqKhduXViSO1nXovyr+l1Y3DSKDSCl0F2ZYu5gq/xZUkfbSX3N+quhIKNtwcf2VqkUzzfSWA0CRoFltJU5xst3DA6NcYnYk06Ajhmgy0eiOzANDvLKMR2/nR0PVWpOQwkRMNc+VDEkZeawLxgNtjI1YwxEJrTt93otxOgWWONk9Ps3WvY4La+k04qvv/Y
 402AWOPP
 Tm1/Oi6z2bC6rBmhrHhApCWbh14jNgk4QByrwHNOZgYrmd0btZ8YL2iyQXRPNRd/GX2ZaMwGoHB9nN8ASCXrR1nhdERRU7ZJ0mmZR+vKAZo7RcGLjxSlUIcf9Y4zUK91cn5l8sALoZHGXfJZJeGYDpv+UFGg3MQ6mjvRmmR2Rs0xnpVbxm7xY7rmhKVRSMi8SMSrIAuWgRzJQPg979X7y7B8nmQUUkBaX7LDH84CEPmcI/8MvhBNBtHkai0eer54N+3aQw5jG9PPXvCpPZdCMM/KOxuKjCiFkdRkX9uI+KZKdBeOG1al59kh0sTCbX2xL6bDYcS7aDA1WcoLeCoXHFwoxous+kHxq+gxePmA3CMauUHtFwotbOn94v7SvfY+lU3NZWZPeKpInm8N+kg+qHZb5glnuWakq/efi68MOkkpnavfXWsjdRgMiAt5HCQPa6XKfgsh4Gkj0Hr7t7SarTmpj0aJXKJ8b6zYOhmONs0GFiY7vtybVdZVes+g3sTTbPvSe3dUSZVKOjSduPhSKJEO9snQ4MbZ4r6TKjre0LjHnhP3doHfHsS+wOZpUel1hlyb1/x1hH+HxtMUwXOcwr+HrGG0Ha0dVGS90PRChnWdpzPvTIqNrOdp5oDs+N67Ky0WbPVPJhfk4BMq8sws3w2wRTXsMZtjIkqvK8Dfq9keDSldIMXMzgr1cIBNxMgBWeiDIzr4U4/A2lfzZHxB2g6iy6mwTrnzE++qkr/nr0IJWCgMkBQ35L4NRnEZdbXVyd7i2jSRnUsMIllmFgAEcZcwNF9Nj70Dvy9RHJzmhmOt8nxMg3LPGamcLmMXfVFgMe05MO2MjW5w9suaYEZkCjD99q6jKpSf90hrPIP47G2zXFGYTtRwLZcsBtOoXzlIQEe7MDlmjopgCt+YMxRIPp4GxwtYsQZ9Z0qo7TmTUAGsEoxcOagdeniD70+scGx1u7y1aOeIrb7uIfnXOr9Nv2UOfIqZM
 hc7e8nKS
 yyChTgyhkYbL2W7MYHtjumn3dKmi4tTqid3ImOQjg9Ilo+jBiam8YBJRGYW/tckJHMD73eIhOPEK4fXiLiv8bdF3KmIUZwjbTMmVKzVFRMpkfNkm4XBOf85cE3XKhCcZCL2lqwUAYLoYVxUsISuYtX6bhbXtvnq1Gs3uNHCRjZI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE5oYXQgUGhhbSA8bnBoYW1j
c0BnbWFpbC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgSmFudWFyeSAzMCwgMjAyNiA1OjEzIFBNDQo+
IFRvOiBTcmlkaGFyLCBLYW5jaGFuYSBQIDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPg0K
PiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtbW1Aa3ZhY2sub3JnOw0K
PiBoYW5uZXNAY21weGNoZy5vcmc7IHlvc3J5LmFobWVkQGxpbnV4LmRldjsgY2hlbmdtaW5nLnpo
b3VAbGludXguZGV2Ow0KPiB1c2FtYWFyaWY2NDJAZ21haWwuY29tOyByeWFuLnJvYmVydHNAYXJt
LmNvbTsgMjFjbmJhb0BnbWFpbC5jb207DQo+IHlpbmcuaHVhbmdAbGludXguYWxpYmFiYS5jb207
IGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc7DQo+IHNlbm96aGF0c2t5QGNocm9taXVtLm9yZzsg
c2pAa2VybmVsLm9yZzsga2Fzb25nQHRlbmNlbnQuY29tOyBsaW51eC0NCj4gY3J5cHRvQHZnZXIu
a2VybmVsLm9yZzsgaGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1Ow0KPiBkYXZlbUBkYXZlbWxv
ZnQubmV0OyBjbGFiYmVAYmF5bGlicmUuY29tOyBhcmRiQGtlcm5lbC5vcmc7DQo+IGViaWdnZXJz
QGdvb2dsZS5jb207IHN1cmVuYkBnb29nbGUuY29tOyBBY2NhcmRpLCBLcmlzdGVuIEMNCj4gPGty
aXN0ZW4uYy5hY2NhcmRpQGludGVsLmNvbT47IEdvbWVzLCBWaW5pY2l1cyA8dmluaWNpdXMuZ29t
ZXNAaW50ZWwuY29tPjsNCj4gQ2FiaWRkdSwgR2lvdmFubmkgPGdpb3Zhbm5pLmNhYmlkZHVAaW50
ZWwuY29tPjsgRmVnaGFsaSwgV2FqZGkgSw0KPiA8d2FqZGkuay5mZWdoYWxpQGludGVsLmNvbT4N
Cj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MTQgMjYvMjZdIG1tOiB6c3dhcDogQmF0Y2hlZCB6c3dh
cF9jb21wcmVzcygpIGZvcg0KPiBjb21wcmVzcyBiYXRjaGluZyBvZiBsYXJnZSBmb2xpb3MuDQo+
IA0KPiBPbiBTYXQsIEphbiAyNCwgMjAyNiBhdCA3OjM24oCvUE0gS2FuY2hhbmEgUCBTcmlkaGFy
DQo+IDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+IFdlIGlu
dHJvZHVjZSBhIG5ldyBiYXRjaGluZyBpbXBsZW1lbnRhdGlvbiBvZiB6c3dhcF9jb21wcmVzcygp
IGZvcg0KPiA+IGNvbXByZXNzb3JzIHRoYXQgZG8gYW5kIGRvIG5vdCBzdXBwb3J0IGJhdGNoaW5n
LiBUaGlzIGVsaW1pbmF0ZXMgY29kZQ0KPiA+IGR1cGxpY2F0aW9uIGFuZCBmYWNpbGl0YXRlcyBj
b2RlIG1haW50YWluYWJpbGl0eSB3aXRoIHRoZSBpbnRyb2R1Y3Rpb24NCj4gPiBvZiBjb21wcmVz
cyBiYXRjaGluZy4NCj4gPg0KPiA+IFRoZSB2ZWN0b3JpemVkIGltcGxlbWVudGF0aW9uIG9mIGNh
bGxpbmcgdGhlIGVhcmxpZXIgenN3YXBfY29tcHJlc3MoKQ0KPiA+IHNlcXVlbnRpYWxseSwgb25l
IHBhZ2UgYXQgYSB0aW1lIGluIHpzd2FwX3N0b3JlX3BhZ2VzKCksIGlzIHJlcGxhY2VkDQo+ID4g
d2l0aCB0aGlzIG5ldyB2ZXJzaW9uIG9mIHpzd2FwX2NvbXByZXNzKCkgdGhhdCBhY2NlcHRzIG11
bHRpcGxlIHBhZ2VzIHRvDQo+ID4gY29tcHJlc3MgYXMgYSBiYXRjaC4NCj4gPg0KPiA+IElmIHRo
ZSBjb21wcmVzc29yIGRvZXMgbm90IHN1cHBvcnQgYmF0Y2hpbmcsIGVhY2ggcGFnZSBpbiB0aGUg
YmF0Y2ggaXMNCj4gPiBjb21wcmVzc2VkIGFuZCBzdG9yZWQgc2VxdWVudGlhbGx5LiBJZiB0aGUg
Y29tcHJlc3NvciBzdXBwb3J0cyBiYXRjaGluZywNCj4gPiBmb3IgZS5nLiwgJ2RlZmxhdGUtaWFh
JywgdGhlIEludGVsIElBQSBoYXJkd2FyZSBhY2NlbGVyYXRvciwgdGhlIGJhdGNoDQo+ID4gaXMg
Y29tcHJlc3NlZCBpbiBwYXJhbGxlbCBpbiBoYXJkd2FyZS4NCj4gPg0KPiA+IElmIHRoZSBiYXRj
aCBpcyBjb21wcmVzc2VkIHdpdGhvdXQgZXJyb3JzLCB0aGUgY29tcHJlc3NlZCBidWZmZXJzIGZv
cg0KPiA+IHRoZSBiYXRjaCBhcmUgc3RvcmVkIGluIHpzbWFsbG9jLiBJbiBjYXNlIG9mIGNvbXBy
ZXNzaW9uIGVycm9ycywgdGhlDQo+ID4gY3VycmVudCBiZWhhdmlvciBiYXNlZCBvbiB3aGV0aGVy
IHRoZSBmb2xpbyBpcyBlbmFibGVkIGZvciB6c3dhcA0KPiA+IHdyaXRlYmFjaywgaXMgcHJlc2Vy
dmVkLg0KPiA+DQo+ID4gVGhlIGJhdGNoZWQgenN3YXBfY29tcHJlc3MoKSBpbmNvcnBvcmF0ZXMg
SGVyYmVydCdzIHN1Z2dlc3Rpb24gZm9yDQo+ID4gU0cgbGlzdHMgdG8gcmVwcmVzZW50IHRoZSBi
YXRjaCdzIGlucHV0cy9vdXRwdXRzIHRvIGludGVyZmFjZSB3aXRoIHRoZQ0KPiA+IGNyeXB0byBB
UEkgWzFdLg0KPiA+DQo+ID4gUGVyZm9ybWFuY2UgZGF0YToNCj4gPiA9PT09PT09PT09PT09PT09
PQ0KPiA+IEFzIHN1Z2dlc3RlZCBieSBCYXJyeSwgdGhpcyBpcyB0aGUgcGVyZm9ybWFuY2UgZGF0
YSBnYXRoZXJlZCBvbiBJbnRlbA0KPiA+IFNhcHBoaXJlIFJhcGlkcyB3aXRoIHR3byB3b3JrbG9h
ZHM6DQo+ID4NCj4gPiAxKSAzMCB1c2VtZW0gcHJvY2Vzc2VzIGluIGEgMTUwIEdCIG1lbW9yeSBs
aW1pdGVkIGNncm91cCwgZWFjaA0KPiA+ICAgIGFsbG9jYXRlcyAxMEcsIGkuZSwgZWZmZWN0aXZl
bHkgcnVubmluZyBhdCA1MCUgbWVtb3J5IHByZXNzdXJlLg0KPiA+IDIpIGtlcm5lbF9jb21waWxh
dGlvbiAiZGVmY29uZmlnIiwgMzIgdGhyZWFkcywgY2dyb3VwIG1lbW9yeSBsaW1pdCBzZXQNCj4g
PiAgICB0byAxLjcgR2lCICg1MCUgbWVtb3J5IHByZXNzdXJlLCBzaW5jZSBiYXNlbGluZSBtZW1v
cnkgdXNhZ2UgaXMgMy40DQo+ID4gICAgR2lCKTogZGF0YSBhdmVyYWdlZCBhY3Jvc3MgMTAgcnVu
cy4NCj4gPg0KPiA+IFRvIGtlZXAgY29tcGFyaXNvbnMgc2ltcGxlLCBhbGwgdGVzdGluZyB3YXMg
ZG9uZSB3aXRob3V0IHRoZQ0KPiA+IHpzd2FwIHNocmlua2VyLg0KPiA+DQo+ID4NCj4gPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0N
Cj4gPT09PT09PT09PT0NCj4gPiAgIElBQSAgICAgICAgICAgICAgICAgbW0tdW5zdGFibGUtMS0y
My0yMDI2ICAgICAgICAgICAgIHYxNA0KPiA+DQo+ID09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+ID09PT09PT09PT09DQo+ID4g
ICAgIHpzd2FwIGNvbXByZXNzb3IgICAgICAgICAgICBkZWZsYXRlLWlhYSAgICAgZGVmbGF0ZS1p
YWEgICBJQUEgQmF0Y2hpbmcNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB2cy4NCj4gPiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBJQUEgU2VxdWVudGlh
bA0KPiA+DQo+ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09DQo+ID09PT09PT09PT09DQo+ID4gIHVzZW1lbTMwLCA2NEsgZm9saW9z
Og0KPiA+DQo+ID4gICAgIFRvdGFsIHRocm91Z2hwdXQgKEtCL3MpICAgICAgIDYsMjI2LDk2NyAg
ICAgIDEwLDU1MSw3MTQgICAgICAgNjklDQo+ID4gICAgIEF2ZXJhZ2UgdGhyb3VnaHB1dCAoS0Iv
cykgICAgICAgMjA3LDU2NSAgICAgICAgIDM1MSw3MjMgICAgICAgNjklDQo+ID4gICAgIGVsYXBz
ZWQgdGltZSAoc2VjKSAgICAgICAgICAgICAgICA5OS4xOSAgICAgICAgICAgNjcuNDUgICAgICAt
MzIlDQo+ID4gICAgIHN5cyB0aW1lIChzZWMpICAgICAgICAgICAgICAgICAyLDM1Ni4xOSAgICAg
ICAgMSw1ODAuNDcgICAgICAtMzMlDQo+ID4NCj4gPiAgdXNlbWVtMzAsIFBNRCBmb2xpb3M6DQo+
ID4NCj4gPiAgICAgVG90YWwgdGhyb3VnaHB1dCAoS0IvcykgICAgICAgNiwzNDcsMjAxICAgICAg
MTEsMzE1LDUwMCAgICAgICA3OCUNCj4gPiAgICAgQXZlcmFnZSB0aHJvdWdocHV0IChLQi9zKSAg
ICAgICAyMTEsNTczICAgICAgICAgMzc3LDE4MyAgICAgICA3OCUNCj4gPiAgICAgZWxhcHNlZCB0
aW1lIChzZWMpICAgICAgICAgICAgICAgIDg4LjE0ICAgICAgICAgICA2My4zNyAgICAgIC0yOCUN
Cj4gPiAgICAgc3lzIHRpbWUgKHNlYykgICAgICAgICAgICAgICAgIDIsMDI1LjUzICAgICAgICAx
LDQ1NS4yMyAgICAgIC0yOCUNCj4gPg0KPiA+ICBrZXJuZWxfY29tcGlsYXRpb24sIDY0SyBmb2xp
b3M6DQo+ID4NCj4gPiAgICAgZWxhcHNlZCB0aW1lIChzZWMpICAgICAgICAgICAgICAgMTAwLjEw
ICAgICAgICAgICA5OC43NCAgICAgLTEuNCUNCj4gPiAgICAgc3lzIHRpbWUgKHNlYykgICAgICAg
ICAgICAgICAgICAgMzA4LjcyICAgICAgICAgIDMwMS4yMyAgICAgICAtMiUNCj4gPg0KPiA+ICBr
ZXJuZWxfY29tcGlsYXRpb24sIFBNRCBmb2xpb3M6DQo+ID4NCj4gPiAgICAgZWxhcHNlZCB0aW1l
IChzZWMpICAgICAgICAgICAgICAgIDk1LjI5ICAgICAgICAgICA5My40NCAgICAgLTEuOSUNCj4g
PiAgICAgc3lzIHRpbWUgKHNlYykgICAgICAgICAgICAgICAgICAgMzQ2LjIxICAgICAgICAgIDM0
NC40OCAgICAgLTAuNSUNCj4gPg0KPiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KPiA9PT09PT09PT09PQ0KPiA+DQo+ID4NCj4g
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT0NCj4gPT09PT09PT09PT0NCj4gPiAgIFpTVEQgICAgICAgICAgICAgICAgbW0tdW5zdGFi
bGUtMS0yMy0yMDI2ICAgICAgICAgICAgIHYxNA0KPiA+DQo+ID09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+ID09PT09PT09PT09
DQo+ID4gICAgIHpzd2FwIGNvbXByZXNzb3IgICAgICAgICAgICAgICAgICAgenN0ZCAgICAgICAg
ICAgIHpzdGQgICAgIHYxNCBaU1REDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEltcHJvdmVtZW50DQo+ID4NCj4gPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0N
Cj4gPT09PT09PT09PT0NCj4gPiAgdXNlbWVtMzAsIDY0SyBmb2xpb3M6DQo+ID4NCj4gPiAgICAg
VG90YWwgdGhyb3VnaHB1dCAoS0IvcykgICAgICAgNiwwMzIsMzI2ICAgICAgIDYsMDQ3LDQ0OCAg
ICAgIDAuMyUNCj4gPiAgICAgQXZlcmFnZSB0aHJvdWdocHV0IChLQi9zKSAgICAgICAyMDEsMDc3
ICAgICAgICAgMjAxLDU4MSAgICAgIDAuMyUNCj4gPiAgICAgZWxhcHNlZCB0aW1lIChzZWMpICAg
ICAgICAgICAgICAgIDk3LjUyICAgICAgICAgICA5NS4zMyAgICAgLTIuMiUNCj4gPiAgICAgc3lz
IHRpbWUgKHNlYykgICAgICAgICAgICAgICAgIDIsNDE1LjQwICAgICAgICAyLDMyOC4zOCAgICAg
ICAtNCUNCj4gPg0KPiA+ICB1c2VtZW0zMCwgUE1EIGZvbGlvczoNCj4gPg0KPiA+ICAgICBUb3Rh
bCB0aHJvdWdocHV0IChLQi9zKSAgICAgICA2LDU3MCw0MDQgICAgICAgNiw2MjMsOTYyICAgICAg
MC44JQ0KPiA+ICAgICBBdmVyYWdlIHRocm91Z2hwdXQgKEtCL3MpICAgICAgIDIxOSwwMTMgICAg
ICAgICAyMjAsNzk4ICAgICAgMC44JQ0KPiA+ICAgICBlbGFwc2VkIHRpbWUgKHNlYykgICAgICAg
ICAgICAgICAgODkuMTcgICAgICAgICAgIDg4LjI1ICAgICAgIC0xJQ0KPiA+ICAgICBzeXMgdGlt
ZSAoc2VjKSAgICAgICAgICAgICAgICAgMiwxMjYuNjkgICAgICAgIDIsMDQzLjA4ICAgICAgIC00
JQ0KPiA+DQo+ID4gIGtlcm5lbF9jb21waWxhdGlvbiwgNjRLIGZvbGlvczoNCj4gPg0KPiA+ICAg
ICBlbGFwc2VkIHRpbWUgKHNlYykgICAgICAgICAgICAgICAxMDAuODkgICAgICAgICAgIDk5Ljk4
ICAgICAtMC45JQ0KPiA+ICAgICBzeXMgdGltZSAoc2VjKSAgICAgICAgICAgICAgICAgICA0MTcu
NDkgICAgICAgICAgNDE0LjYyICAgICAtMC43JQ0KPiA+DQo+ID4gIGtlcm5lbF9jb21waWxhdGlv
biwgUE1EIGZvbGlvczoNCj4gPg0KPiA+ICAgICBlbGFwc2VkIHRpbWUgKHNlYykgICAgICAgICAg
ICAgICAgOTguMjYgICAgICAgICAgIDk3LjM4ICAgICAtMC45JQ0KPiA+ICAgICBzeXMgdGltZSAo
c2VjKSAgICAgICAgICAgICAgICAgICA0ODcuMTQgICAgICAgICAgNDczLjE2ICAgICAtMi45JQ0K
PiA+DQo+ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09DQo+ID09PT09PT09PT09DQo+IA0KPiBUaGUgcmVzdCBvZiB0aGUgcGF0Y2gg
Y2hhbmdlbG9nIChhcmNoaXRlY3R1cmFsIGFuZCBmdXR1cmUNCj4gY29uc2lkZXJhdGlvbnMpICBj
YW4gc3RheSBpbiB0aGUgY292ZXIgbGV0dGVyLiBMZXQncyBub3QgZHVwbGljYXRlDQo+IGluZm9y
bWF0aW9uIDopDQo+IA0KPiBLZWVwIHRoZSBwYXRjaCBjaGFuZ2Vsb2cgbGltaXRlZCB0byBvbmx5
IHRoZSBjaGFuZ2VzIGluIHRoZSBwYXRjaA0KPiBpdHNlbGYgKHVubGVzcyB3ZSBuZWVkIHNvbWUg
Y2xhcmlmaWNhdGlvbnMgaW1taW5lbnRseSByZWxldmFudCkuDQoNCkhpIE5oYXQsDQoNClRoYW5r
cyBmb3IgdGhpcyBjb21tZW50LiBZb3NyeSBoYWQgYWxzbyBwb2ludGVkIHRoaXMgb3V0IGluIFsx
XS4gSSBoYXZlDQpiZWVuIGluY2x1ZGluZyB0aGUgYXJjaGl0ZWN0dXJhbCBhbmQgZnV0dXJlIGNv
bnNpZGVyYXRpb25zIGluIHRoaXMgY2hhbmdlIGxvZw0Kc2luY2UgQW5kcmV3IGhhZCBhc2tlZCBt
ZSB0byBkbyBzby4gSSBob3BlIHRoaXMgaXMgT2s/DQoNClsxXTogaHR0cHM6Ly9wYXRjaHdvcmsu
a2VybmVsLm9yZy9jb21tZW50LzI2NzA2MjQwLw0KDQo+IA0KPiBJJ2xsIHJldmlldyB0aGUgcmVt
YWluZGVyIG9mIHRoZSBwYXRjaCBsYXRlciA6KQ0KDQpTdXJlLg0KDQpUaGFua3MsDQpLYW5jaGFu
YQ0K

