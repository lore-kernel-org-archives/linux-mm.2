Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78825C624D7
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 19:46:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B6886B008C; Thu,  3 Sep 2026 15:46:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 667B66B0092; Thu,  3 Sep 2026 15:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52FA56B0095; Thu,  3 Sep 2026 15:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 250B86B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:46:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2049C064B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 19:46:07 +0000 (UTC)
X-FDA: 85173481974.12.47789BB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf28.hostedemail.com (Postfix) with ESMTP id 654B7C0003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 19:46:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nlqWvV2x;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of ehab.ababneh@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788464764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bCd2KyfDIN+aEpN9X4Thph/z/sMVVppEKsBFpYxS2xg=;
	b=rlD27m5ZupIZ9Ee+7cgrS7pIeTAaExgH1NzRCcpYXwMbClum1vbkXQFXPPpkjN60TW96FM
	L5ziJ1f+PHeqMu7D/xP21eCPgQXB3uqVPmGJPWeF2qhu2KuEoC0WJcaRSLn/LyQbaHtlfx
	qGm4WDmoKSuhyWMTpMBrHAiNqa+q3sM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788464764;
	b=7csXGvNZJCAaa/mLJh81D9+Twmjh2ZkcX6inPI90m8HZ4pqmgTgUgO0Dey575iyGGH/iGY
	cxWJXZXmwo0oCBa427zB+/Gy3/E/9H9ADwg4kARswnNlyDnlsrjD+u63/qIaEUReZ75XjJ
	3z6lCMsFguusuLxQeOlkch1mD/+WaWE=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nlqWvV2x;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of ehab.ababneh@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788464762; x=1820000762;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bCd2KyfDIN+aEpN9X4Thph/z/sMVVppEKsBFpYxS2xg=;
  b=nlqWvV2xQ/TAFAco9HFj8mv4fMC6G33estGWDd/gzherHc9h5cLp13Zq
   nEvxBQFGjls/L5uDhbUXop+I6OFdQfhMqhi7QjGQ8YXAgq2+qFCA3+1Tx
   yWFL96ijvoyhgWwiqTPOmRF+y7V3PuUbFEviiWEEaCv+FNJwedB6SiUtu
   pUlB0kQGTTQJrsApDCzMX7Z0xtdD+dk4M2PazI3eZ3qxBATt8YeZEr0Ko
   pN8Bxc11dEHTvNqnNlTI4SIxTmbI/RgJmE/nmXxXqacdsv+gj5WqqEgcm
   6C/xTY42Xy88eR21/Z3G4x8whNCLuRdmCkH73YNNK8dMsGa6gQ08+z/B2
   w==;
X-CSE-ConnectionGUID: PLfWd5P4QYiOJTBZDtaX+A==
X-CSE-MsgGUID: UoomlEkAS5qXOH+beywNCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="88992798"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="88992798"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 12:46:01 -0700
X-CSE-ConnectionGUID: RB01szC6RhWBiIa+zLYuCg==
X-CSE-MsgGUID: kWzQBDWmSn6yaus1Q9q3/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="293333121"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 12:46:01 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 3 Sep 2026 12:46:00 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 3 Sep 2026 12:46:00 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.25)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 3 Sep 2026 12:46:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uwA/Xt6eVkubYLCPegQ/2H228Wu2q+PYUT1CkBnTD0Y5G9+AEz/D9+6kwDNJX6jcEwVfEql91D5XDPu7KZbAQg3D97ZlnhQ2rsOfndRgu1OBxOiShTYNuxNLDCVSXcO43wgY1J3bP85rtigLuZCXcLJFui5fIIBy98gqGC8aaWEEvD2kmb3vrriEGqN51Y2IOQHfzd2NSQf87kGZFap0PM2HGMB8iilqPNqrz2oNPm4YAcgNm8GuxOywTgYfhdGcMB+K5yYtUycDtyu/sXj+vVGWk6u1BhpU2QYb5NIl4YtNzR/JSlFZeAZOjkTYhvioiirA6ZdFY5YZbZ54lw3D1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bCd2KyfDIN+aEpN9X4Thph/z/sMVVppEKsBFpYxS2xg=;
 b=QldWzu45mzwe5lkJSsJbY3Dt32WsJ6GXNgLKGsErLKFHxHOJZjzbhYGgC4palup9VULkP99eWVbdCYUD2bCltdBWg4hOzFA/MJ3ETCGjTvboqGd8mVPHYunPuxw33fTxD63QicA/2N0IqgXJFXiukk5HIN++ka/5mY1/TYIpkwB5SzFlWFd+YWkdf3q0zXRKci/D27+0XNwhPTZDW/wkrEuMoHG268lyA1lTHAkgb6K+n4uwV2FmDKx8EGPbZ9Lv73/cCKNU/IbaKzU2bAHMGMv3jVEMsWIeUbR297tCd3n/z/Cr0eEfJJqCn3WHm6D9vEp3s/riSeeDO8b9EHvyEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6105.namprd11.prod.outlook.com (2603:10b6:a03:48c::21)
 by SA1PR11MB6806.namprd11.prod.outlook.com (2603:10b6:806:24d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 19:45:50 +0000
Received: from SJ1PR11MB6105.namprd11.prod.outlook.com
 ([fe80::28d9:5273:4572:320d]) by SJ1PR11MB6105.namprd11.prod.outlook.com
 ([fe80::28d9:5273:4572:320d%5]) with mapi id 15.21.0360.008; Thu, 3 Sep 2026
 19:45:50 +0000
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
Thread-Index: AQHdOjxqaRSPWT3KQUCvH7lHJPZvdLa6CN8AgAA+YQCAAYnQ0IAABs2AgAFohNA=
Date: Thu, 3 Sep 2026 19:45:50 +0000
Message-ID: <SJ1PR11MB610566E5520AFF142D8C45168CB62@SJ1PR11MB6105.namprd11.prod.outlook.com>
References: <apcVhWzEwkwHYjB1@KASONG-MC4>
 <20260901220430.79810-1-baohua@kernel.org>
 <SJ1PR11MB61051CC2791B67C97BEB2D4B8CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <CAGsJ_4yRJnr4xXdokVHu85b7XPe0p6rZ+Lzv4sE_gCWdOF4YAw@mail.gmail.com>
In-Reply-To: <CAGsJ_4yRJnr4xXdokVHu85b7XPe0p6rZ+Lzv4sE_gCWdOF4YAw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6105:EE_|SA1PR11MB6806:EE_
x-ms-office365-filtering-correlation-id: 7cd1e6f6-6758-4dca-38bd-08df09f3f4fc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|23010399003|366016|376014|22082099003|18002099003|11063799006|38070700021|56012099006|10067099003|4143699003;
x-microsoft-antispam-message-info: cBlkXvLiG7/IMbkgWasgEov9JSAYEb66mpVVwkUu3+Eopib64Hi/76qeQPgIKbGwOqwHxDvrUvQ4xBLWDAYb/MJyZyuD1mF8kgqBJkS15JXWYlzTiU2KKK2NVYQ8e11me5ad8ys0qOrVfhz1DWlLrBVjF2qFJNwL4vgwwTLsHEgf5gYCh5h1WaIf6A3QeBIvZXSSH9jdSgNIpSAxgRClnSbMNu4tRYE+5s/m4+by4OaFTS113oHMmzrKqlGOIqVIyQkWPEa8KT+t4RfEqDs6y2cOrHwbKrHuVQkXHn6Y0Z6VibLZHFIwQUW0yMtmJcGykDWrVQUwLHlpxXPcNDwsCJFR+g5Y5LEgTzvVHpDiMj7EaDE3U62AuqEqnuhjCNw4vqXE4Wqli1pRhK7NUkyk+dvykc+RFeltqA7Sbz3h6JjnEtAW0NZ+C2EHuEDa3aTYsQ8sK5GC/NytXg5pPkDptXwoUFQgWIw82hxdUkeQSUZypXxlHTdlqOMUFOgsX6pnOh1dIV7K5NQOWKs+X1g6xnad5ubjm726lapP5hmreUrT9ze0yNLnzAz5x8PxFvafFIndKZqtMiAx7ABC/Y6M1uedaj/YmihAtagUKlgialYS8PEcMWnKhI2eewex4WziUo5xI3TD1Z7zV58cv3gFdmKpnBEGu1la1bs+/wskd7Fc5JvqqqOpteOMkthMwxD4HVTXB7h8C9SgR0cX7P1gupAqMmGKsrwmJfXs87YVxCQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(23010399003)(366016)(376014)(22082099003)(18002099003)(11063799006)(38070700021)(56012099006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UFg0ZDZySDBEWExYSndHMk4xTlZBMDNEWUw2bWxzL1RGbnU5TnR5VG0rL2tG?=
 =?utf-8?B?c29vdzBqdEx5L2RHMzhwbGw0QjV1TGlabHlRSER5Yy9ZWGluQmN2aHdZeDdy?=
 =?utf-8?B?bk4zUWNubHBST1A1RlZFQTlSOU9RR3YrRFRaQkpvbUU2UFVXSEc0MkpPbm1Z?=
 =?utf-8?B?T29IWFlkalpXTDNOaU5LbGpvSXhkeVg5MXZmUGN3SVduMmF0NnF2dGhEUUJz?=
 =?utf-8?B?YlpZUXlnVXJUbGtYQk1HQjlJMHZrdldCVnVRa1d3cWF4QjNOOVIycXdPNVpJ?=
 =?utf-8?B?Rm5TN2VYLzNic21XeWQ3OGptS1g2WFR1OWRRUG1ZTnZnbG4zdmdiZlREZ0x1?=
 =?utf-8?B?bU15WllOay9Da2IrVlIrYWpLQ2QwK1JOOGdhWXkxUWk2MUtMSmQyZmVoTDVu?=
 =?utf-8?B?bG1ydjVNMUdndVEwUVRBVUZleFFIUG9KT0FvRkVSeUhxK3pLdG1Ydk96WThy?=
 =?utf-8?B?YjRDblhWbnRmVk0zbG9ucFkwSVEvb2NkMk02Z211ZEYyN0NJZGNOU2toemNu?=
 =?utf-8?B?T1FxQ0FOeXdiS2h3NGdLWjlhR3V1QjJhODNMZXpIdms1QSs1TEVENmdDUjND?=
 =?utf-8?B?Qm9GRUlvUEtiSmhXM2ZkSGhGWDc3bWs2b0poMWlFTWRWNURHaUl4YW9wbmlT?=
 =?utf-8?B?aEhzTHJFdE5qWUJ1RW9ZbVVIcGhsMWIyL2xYWm5hREd0bm5kSDZLTFA1UjhR?=
 =?utf-8?B?L1lwWHNuMWJEOEMvSXZqVkpaKzBZQ1hBNTFmaFR1NHVHY2JoVnVqT0VIZUlF?=
 =?utf-8?B?UDltanB2ODFhdEdWeHliV3BwZ3dLd2g0QnJuOG1PYUNhd2RGeC8vNll1bDJp?=
 =?utf-8?B?cjQwQTE2NTZNSzJsaUVQSFl0SUM2ai9hb216Rjd4Y2VyQU91dFFOU2tSRmJW?=
 =?utf-8?B?V0tLQ3ZpWmJmZHFNUGRURStpbEtUSWdsUUZLUmlRdk1Qd2Z3LzVyKzRLb09Z?=
 =?utf-8?B?d3llV3Q3aFBzRklGaE5VSEp1ZXM3NFJVL1NHY3pJZ2RLV0hSM3NZTkVpMzhQ?=
 =?utf-8?B?NEJUU3RaYkRjaHFuWG8vVUh4cXd4YlB3S0RSOTg0SUJKT2N4MUVaZTVybzFF?=
 =?utf-8?B?dWgwV1FUMGZxVU5nTTJzVmgyYUd6KzVWbWdWOEpyZno1cVJBWmVyZWZnWHFq?=
 =?utf-8?B?anlGS2owQjdybGFyRjJqM0hBOXZXRnJTYUFjUzEySGFGbjBvcVJxRjJOSzNU?=
 =?utf-8?B?OHdIdDlYcmgwczZrTm1KQ1ROUUF2ZnpFQ0E1aEhDWXdIbmFPSExVdTBaZlFC?=
 =?utf-8?B?WjlhNTNyODFpdUdJZTFsZHFqdXI5NkpHU0Jja295b3hRbjR6UUF2bWtYQk4w?=
 =?utf-8?B?dC8vK2hhR21hSXZTZ3dsNlBYNEY2RHIxY1lOYURJQUcvTWRYbTRNZ284MHVD?=
 =?utf-8?B?eXREaWVqbzZZL3lob0Z5MTBRL3NUMzNGTjA2MWN6bWxINTFib3dVaFIvendk?=
 =?utf-8?B?Y0FiZy9PblFBRFZrZ2lKNGJBTjJtK0IyOFQrMm9rL0ZYNmNFZ21MK2RtR2lU?=
 =?utf-8?B?SndqR0pRT2dIM0tVY2FnN0ZMV0xkc3g3dVZkaWlXQks3ZDNkZUJPeFdkN2tT?=
 =?utf-8?B?dE1ZVDRnTE1XVE8rNzNVR3B2VXlVd0JGTFBjdzdlWXl1L0FTaHFTZ2lLd1pO?=
 =?utf-8?B?aWU0RDFDaDNYWDYwVDBITitpdmlGMkZCZFgrMFAzaE1pRndSY3I5SHIzSS8z?=
 =?utf-8?B?dmQ2WkZ2dTcwWWlnN25taVJtTk1aQ3FOWmlyVTFRUTRwSTFlTklOSDBpSElM?=
 =?utf-8?B?Sit4NGcxaVowM21LeDMvOEJZMlpLUTJzWU9OU3ZmQlBqeFpkYjV3QmtCOHd0?=
 =?utf-8?B?WjdRTURwSkh4Wk1CSEtCVWFBK0w0dHlGTC8wZnFuNzAvTElnODdiM09OV2I1?=
 =?utf-8?B?SjAwaHZWb09mWTlwSkZJS2xtRTAyZFc3VXVqbWIySFRCZ2RuY0dTcXk4eGs2?=
 =?utf-8?B?cmoxWWN5cDlZdC96aXBHeHRYV1YxYXBNN0xhVlZKeEdQVUNSRVhyaE5FU2hv?=
 =?utf-8?B?V3FSMkNmcTNhZnF4MUJZQjF5UWpVVWxtajBBR0hwOW90OS9IQk1sT21wQTlj?=
 =?utf-8?B?a1h1TmwwbEtGQnRYWmtWdjR4bGRmaTNncXZJcXVDREU0OUVTZDAxYi9BTDcz?=
 =?utf-8?B?RWhCUXFCRnpFelAxbU1iYllsSitNeW05Mnh0RXR3YkU3djllcVJJaytoMk10?=
 =?utf-8?B?WVhEaWw4c04vRHJBMDMrVUVPbGROeDhNZWJyZkVOU0psV1hGRHNpWWpkenpG?=
 =?utf-8?B?Yk1QeHFlTk82OTlPbzFUNFdJKzdzYjg2ZTNVT1NzcnlyQ0d6alRwbEhieVRX?=
 =?utf-8?B?Sk1QaE5MemdRZSszcmhLQjRmOG5SQVQweUhCdTZtdVNLL2ZDRkM0Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ZbTnY/6nhc3vxDZs8H41FMaY0QJ63BAJft+FPqQHD2v0hrS0OQAD5ePZAiwdqNUIJ0DjI/8TRAKizXVkLoJ/Nl1Ei4P/XpbsWrmNUvptAKGxe1h5ixLnysQkwkqloaOwEGOydiXyGJoqh970cFxxjxEjuDAYqol07iZgpEJ8irhdSINlDpvtBD6cKZq6Yx9dArZGflSf/NsL2ypmlXcM4ZbGx0q2XwIfnBGeqgFWEgDfniUkafQOIuL07E6yqmHzGoeVkw97jyrmOOUfafKNQcuUMedZuca2PP23wDXDy/rlxLeAgQm2rY5RnFViLX9zOuX4DVscgsPxMIor/SiNuw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cd1e6f6-6758-4dca-38bd-08df09f3f4fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2026 19:45:50.1228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZWjjtFIPKXUXkOa+u0beC1WXrjVXysv8NbSNqV8KNfGwnSSBkPVRYanUnuSob4IxP32Ee8aAhfmUdYdn7z2p6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6806
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 654B7C0003
X-Stat-Signature: kyxmzeungpu5nfqw1gepuzhkhg7m3nzq
X-Rspam-User: 
X-HE-Tag: 1788464762-188838
X-HE-Meta: U2FsdGVkX1/8ZvESYgjQsFo6OQUHUHTRNh+RWGIAepvD+Jy14rIzJ0ilS7E8jBw7uVA2aVa1xa52u/0axxnlp80x13XCyJ8ABL6ZsV1CLmpLb1FeD2neEZ+uNNRLZfWDc0jyBp5fovqVMRsWkqTYOLzZY6hY32wtYiXaQKc50lI/JwRP9VEPGpycR6xH3wv/unf4fVPEsNQAHEWR+sSw7OeoC4GMUVAlt9oIAPVgAca1/+F++5mlxFuMtTgvNJtMDm6McYHngWxWvUL8SwnXGXQzgry9ERMTB6fDp8Bgv30s/sK1i7+vYhFEtHm+/mGL6iLBrijlESLr+z7h19DxC7u2mqTRRuNZtt6pe09T12IJLI4X8RVthAj6v5fA0W/HCxcSy+zLtBR0AIQtvGy2MdrnwM3aVKIcyRo9jrAZpN3rF1c6dsC+GjsaQwJ53Uh1sd42jYW1FZM5NAGoTsQZBDOz67gYi5TELE092USNNpxVzs6D2Mi2/PRQtlOyoIbD7frwieXtGjEto9iwOopxnp1mhUh7fer42V67txaoGSO8W/s2DsD6sKZ/P7z2xO2qgkvWzPYsQzXOb0cGzf1/alShnkFr5meyff4EX/wv6lckcNA+HBHs7kMVGdayccpN6az/pWDucF/zZFzGn7oNniCKv1k5FiHXl7mrN0DIsiHExej90b4/vsOYYzYQOs42nf8c5dOQw0oHzVmJpX9bfbzf17GmRI8HGSOp2tYOaRJmmPfxJqIak95JHOqX8jb0ha9wpLkYvvKYAv2jgAlsswA11TRsBKNVTiKeXqXsvcsBw4eySJQockuvBdKjkPcD0OavsSojmit934p1H4WDsCdEvq0kQqDcltX0xEj4h7sWqt/YANCwFvUj4ZQgTVJxAJk2Y2lBf2BalZ0j51KwBOHaUBRPFLLlwhNRIOGYSzh4Zga0ui06S1BbvnvzGTm7lnuTcxCKwwNroz76qdv
 pVIMPY2A
 4hePUV6rfqttueCcUEFr5BukGoM1q3WCExsskNaWq+41/yDMxaGUHuP52IqAAuefv9zjsi5Jbb5vBGKoriroW7MnH42OMP8k124JN5JPNR/cVcQnCh/YeFeEey3+kSpWIuAKj43UC/ZFtlzo8DlLsIbHdo2pP7VVSjJ6lv8xUGRCN/HZnI0lqtn50AUufDH7pDKR/ZaXFnxwcIXQ76cc8/TDLQfX9cgCHq3EiN+Cc7oLKgpfF0UpeTDYAGbcjbuuE4GjY/lihAbKq9ZMRtdNnU8VUQZvUq0JYWQLJuQD0BwVq46gE5kAzhRHF5sBY0MmseqPqRy1/Fa6NWJgHwUhMB1RhRugsdAlbzNJ4CtgSIYyO4kCgpjPbeBhPH5uvuDUHc5KOHUO+RlEHGu6jUCu5/hgKs+e09YqvlpbOp7VctKpqUpDT5NqexxTcxWqjCMsNZ5PviyD6TVycTF4jqpcgiDoHqApmryMMCcosZa/JgBzguIsDfPPpsEfVUWYzEAMvSM2PDrsaownLhjLEfGAS9hiERyDVpS+to/DyG/6YyFkEcRtSEQJ8nbMZ2BYEZRUHemeGrO8/pN0ERTW4RjfVrUNsAANlRs0ALJY8wAT0BEqKjX26WknYl6JaIxjSoSp6buBSXGBaQy7N6WvhcMm68kjKSKzWYlURMf9XK/d6IHcDmDoGTnH1LPXR3TcZlHKg2lwofo4ne5HZgNy/9YcCtqCaS2TrnyKgvQtAD6HVMrz7RykIQgG/CfErQSYu7yC/Su/x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCYXJyeSBTb25nIDxiYW9odWFA
a2VybmVsLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCBTZXB0ZW1iZXIgMiwgMjAyNiAyOjU4IFBN
DQo+IFRvOiBBYmFibmVoLCBFaGFiIDxlaGFiLmFiYWJuZWhAaW50ZWwuY29tPg0KPiBDYzogcnlu
Y3NuQGdtYWlsLmNvbTsgYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsNCj4gYXhlbHJhc211c3Nl
bkBnb29nbGUuY29tOyBrYXNvbmdAdGVuY2VudC5jb207IGxhbmNlLnlhbmdAbGludXguZGV2Ow0K
PiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7IHFpLnpo
ZW5nQGxpbnV4LmRldjsNCj4gc2hha2VlbC5idXR0QGxpbnV4LmRldjsgd2VpeHVnY0Bnb29nbGUu
Y29tOyB5dWFuY2h1QGdvb2dsZS5jb207DQo+IHl1emhhb0Bnb29nbGUuY29tDQo+IFN1YmplY3Q6
IFJlOiBbUkZDIFBBVENIXSBtbS9tZ2xydTogZHluYW1pY2FsbHkgcHJvdGVjdCByZWFkYWhlYWQg
ZmF1bHQNCj4gZm9saW9zIHVuZGVyIHJlZmF1bHQgcHJlc3N1cmUNCj4gDQo+IE9uIFRodSwgU2Vw
IDMsIDIwMjYgYXQgNTo1MuKAr0FNIEFiYWJuZWgsIEVoYWIgPGVoYWIuYWJhYm5laEBpbnRlbC5j
b20+DQo+IHdyb3RlOg0KPiA+DQo+ID4gSGkgQmFycnksIEthaXJ1aSwNCj4gPg0KPiA+IFRoYW5r
cyBmb3IgdGhlIGZlZWRiYWNrIGFuZCBzdWdnZXN0aW9ucy4NCj4gPg0KPiA+ID4gLS0tLS1Pcmln
aW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+IEZyb206IEJhcnJ5IFNvbmcgKFhpYW9taSkgPGJhb2h1
YUBrZXJuZWwub3JnPg0KPiA+ID4gU2VudDogVHVlc2RheSwgU2VwdGVtYmVyIDEsIDIwMjYgMzow
NSBQTQ0KPiA+ID4gVG86IHJ5bmNzbkBnbWFpbC5jb207IEFiYWJuZWgsIEVoYWIgPGVoYWIuYWJh
Ym5laEBpbnRlbC5jb20+DQo+ID4gPiBDYzogYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsgYXhl
bHJhc211c3NlbkBnb29nbGUuY29tOw0KPiA+ID4gYmFvaHVhQGtlcm5lbC5vcmc7IGthc29uZ0B0
ZW5jZW50LmNvbTsgbGFuY2UueWFuZ0BsaW51eC5kZXY7IGxpbnV4LQ0KPiA+ID4ga2VybmVsQHZn
ZXIua2VybmVsLm9yZzsgbGludXgtbW1Aa3ZhY2sub3JnOyBxaS56aGVuZ0BsaW51eC5kZXY7DQo+
ID4gPiBzaGFrZWVsLmJ1dHRAbGludXguZGV2OyB3ZWl4dWdjQGdvb2dsZS5jb207IHl1YW5jaHVA
Z29vZ2xlLmNvbTsNCj4gPiA+IHl1emhhb0Bnb29nbGUuY29tDQo+ID4gPiBTdWJqZWN0OiBSZTog
W1JGQyBQQVRDSF0gbW0vbWdscnU6IGR5bmFtaWNhbGx5IHByb3RlY3QgcmVhZGFoZWFkDQo+ID4g
PiBmYXVsdCBmb2xpb3MgdW5kZXIgcmVmYXVsdCBwcmVzc3VyZQ0KPiA+ID4NCj4gPiA+IE9uIFdl
ZCwgU2VwIDIsIDIwMjYgYXQgMjoyMeKAr0FNIEthaXJ1aSBTb25nIDxyeW5jc25AZ21haWwuY29t
PiB3cm90ZToNCj4gPiA+ID4NCj4gPiA+ID4gT24gVHVlLCBTZXAgMDEsIDIwMjYgYXQgMTE6MDY6
NDNBTSArMDgwMCwgRWhhYiBBYmFibmVoIHdyb3RlOg0KPiA+ID4gPiA+IENvbW1pdCA2Y2JkZDk3
MjZmYjUgKCJtbS9tZ2xydTogdXNlIGZvbGlvX21hcmtfYWNjZXNzZWQgdG8NCj4gPiA+ID4gPiBy
ZXBsYWNlDQo+ID4gPiA+ID4gZm9saW9fc2V0X2FjdGl2ZSIpIGludHJvZHVjZWQgYSByZWdyZXNz
aW9uIGZvciB3b3JrbG9hZHMgdGhhdA0KPiA+ID4gPiA+IHJlbHkgb24gcmVhZGFoZWFkIHRvIGtl
ZXAgc2VxdWVudGlhbCBmaWxlIGFjY2VzcyBlZmZpY2llbnQuDQo+ID4gPiA+ID4NCj4gPiA+ID4g
PiBUaGUgcHJvYmxlbSBpcyB0aGF0IE1HTFJVIGNhbiBwbGFjZSBmYXVsdC1wYXRoIGZpbGUgZm9s
aW9zIGluDQo+ID4gPiA+ID4gb2xkZXIgZ2VuZXJhdGlvbnMsIHNvIG1lbW9yeSBwcmVzc3VyZSBj
YW4gcmVjbGFpbSByZWFkYWhlYWQNCj4gPiA+ID4gPiBmb2xpb3MgYmVmb3JlIHRoZSB3b3JrbG9h
ZCB0b3VjaGVzIHRoZW0uIEluIG91ciBDYXNzYW5kcmEgcmVhZA0KPiA+ID4gPiA+IGJlbmNobWFy
aywgdGhpcyByYWlzZWQgcDk5IGxhdGVuY3kgdG8gYWJvdXQgOS4yLTkuNSBtcyBhbmQgY3V0DQo+
ID4gPiA+ID4gdGhyb3VnaHB1dCB0byByb3VnaGx5IDQxLjhrLTQzLjZrIG9wL3M7IHRoZSByZXZl
cnQgcmVzdG9yZWQgdGhlDQo+ID4gPiA+ID4gd29ya2xvYWQgdG8gYWJvdXQgNS41LTUuNiBtcyBh
bmQgNTEuOWstNTMuMWsgb3Avcy4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IFJlYWRhaGVhZCBpcyBp
bXBvcnRhbnQgZm9yIHNlcXVlbnRpYWwgSS9PIGFuZCBtbWFwIHNjYW5zLCBidXQgaXQNCj4gPiA+
ID4gPiBzaG91bGQgbm90IGJlIHJldGFpbmVkIHdoZW4gdGhlIHdvcmtsb2FkIGRvZXMgbm90IGJl
bmVmaXQgZnJvbSBpdC4NCj4gPiA+ID4gPiBUaGUgZ29hbCBpcyB0byBrZWVwIHRoZSBvcHRpbWl6
YXRpb24gd2l0aG91dCBrZWVwaW5nIHJlYWRhaGVhZA0KPiA+ID4gPiA+IHBhZ2VzIGFsaXZlDQo+
ID4gPiBmb3JldmVyLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gVGhpcyBwYXRjaCBwcm92aWRlcyBh
IG1pZGRsZSBncm91bmQ6IGtlZXAgdGhlIG9yaWdpbmFsIGJlaGF2aW9yDQo+ID4gPiA+ID4gYnkg
ZGVmYXVsdCwgYnV0IHRlbXBvcmFyaWx5IHByb3RlY3QgZmF1bHQtcGF0aCBmaWxlIGZvbGlvcyB3
aGVuDQo+ID4gPiA+ID4gcmVwZWF0ZWQgZmlsZSByZWZhdWx0cyBzaG93IHRoYXQgcmVhZGFoZWFk
IGlzIGFjdHVhbGx5IGhlbHBpbmcuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBUaGUgbWVjaGFuaXNt
IGlzIGR5bmFtaWMgYW5kIHNlbGYtdHVuaW5nOg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gLSBhZGQg
YSBwZXItbHJ1dmVjIHJlYWRhaGVhZC9yZWZhdWx0IGNyZWRpdA0KPiA+ID4gPiA+IC0gYWNjdW11
bGF0ZSBjcmVkaXQgb24gZmlsZSByZWZhdWx0cyBpbiB0aGUgTUdMUlUgcmVmYXVsdCBwYXRoDQo+
ID4gPiA+ID4gLSBjb25zdW1lIGNyZWRpdCBpbiBmb2xpb19hZGRfbHJ1KCkgZm9yIGZhdWx0LXBh
dGggZmlsZSBmb2xpb3MNCj4gPiA+ID4gPiAtIGtlZXAgdGhlIGZvbGlvIGFjdGl2ZSB3aGlsZSBj
cmVkaXQgaXMgYXZhaWxhYmxlLCBhbmQgb3RoZXJ3aXNlDQo+ID4gPiA+ID4gbGV0IHRoZQ0KPiA+
ID4gPiA+ICAgb3JpZ2luYWwgYmVoYXZpb3Igc3RhbmQNCj4gPiA+ID4gPiAtIGRlY2F5L3Jlc2V0
IHRoZSBjcmVkaXQgYXMgZ2VuZXJhdGlvbnMgYWR2YW5jZSBhbmQgd2hlbiBhbg0KPiA+ID4gPiA+
IGxydXZlYyBpcw0KPiA+ID4gPiA+ICAgaW5pdGlhbGl6ZWQNCj4gPiA+ID4gPg0KPiA+ID4gPiA+
IFRoaXMgbWVhbnMgd2Ugb25seSBwcm90ZWN0IGZhdWx0LXBhdGggZmlsZSBmb2xpb3Mgd2hlbiBy
ZWZhdWx0DQo+ID4gPiA+ID4gcHJlc3N1cmUgc2hvd3MgdGhhdCB0aGUgd29ya2xvYWQgaXMgYWN0
aXZlbHkgYmVuZWZpdGluZyBmcm9tDQo+ID4gPiA+ID4gcmVhZGFoZWFkLiBJZiB0aGUgd29ya2xv
YWQgZG9lcyBub3QgbmVlZCB0aGF0IHByb3RlY3Rpb24sIHRoZQ0KPiA+ID4gPiA+IG9yaWdpbmFs
IG9wdGltaXphdGlvbiByZW1haW5zIGludGFjdCBhbmQgd2UgZG8gbm90IGtlZXANCj4gPiA+ID4g
PiByZWFkYWhlYWQgcGFnZXMNCj4gPiA+IGFyb3VuZCB1bm5lY2Vzc2FyaWx5Lg0KPiA+ID4gPiA+
DQo+ID4gPiA+ID4gQmVuY2htYXJrIHJlc3VsdHMgZm9yIHRoZSBDYXNzYW5kcmEgcmVhZCB3b3Jr
bG9hZA0KPiA+ID4gPiA+ICg0IG5vZGVzLCA3MjBzLCAxMDAgcmVhZGVycyk6DQo+ID4gPiA+ID4N
Cj4gPiA+ID4gPiAtIHdpdGggY29tbWl0IDZjYmRkOTcyNmZiNSAoIm1tL21nbHJ1OiB1c2UgZm9s
aW9fbWFya19hY2Nlc3NlZCB0bw0KPiA+ID4gPiA+ICAgcmVwbGFjZSBmb2xpb19zZXRfYWN0aXZl
Iik6DQo+ID4gPiA+ID4gICBwOTkgfjkuMi05LjUgbXMsIHRocm91Z2hwdXQgfjQxLjhrLTQzLjZr
IG9wL3MNCj4gPiA+ID4gPiAtIHdpdGggcmV2ZXJ0IG9mIGNvbW1pdCA2Y2JkZDk3MjZmYjUgKCJt
bS9tZ2xydTogdXNlDQo+ID4gPiA+ID4gZm9saW9fbWFya19hY2Nlc3NlZCB0bw0KPiA+ID4gPiA+
ICAgcmVwbGFjZSBmb2xpb19zZXRfYWN0aXZlIik6DQo+ID4gPiA+ID4gICBwOTkgfjUuNS01LjYg
bXMsIHRocm91Z2hwdXQgfjUxLjlrLTUzLjFrIG9wL3MNCj4gPiA+ID4gPiAtIHdpdGggdGhpcyBm
aXg6IHA5OSB+NS44IG1zLCB0aHJvdWdocHV0IH41MS45ay01Mi43ayBvcC9zDQo+ID4gPiA+DQo+
ID4gPiBbLi4uXQ0KPiA+ID4gPg0KPiA+ID4gPiBKdXN0IGFuIGlkZWEuIEZvciBhbiBzaG9ydCB0
ZXJtIGFuZCBlYXN5IGZpeCwgd2hhdCBpZiB3ZSBzaW1wbHkNCj4gPiA+ID4gcmV2ZXJ0IHRoYW4s
IHRoZW4gb25seSBwcm90ZWN0IGluX2ZhdWx0ICYmIGZvbGlvX3Rlc3Rfc3dhcGJhY2tlZA0KPiA+
ID4gPiBmb2xpb3Mgd2l0aCBQR19hY3RpdmU/DQo+ID4gPg0KPiA+ID4gSGkgRWhhYiBhbmQgS2Fp
cnVpLA0KPiA+ID4NCj4gPiA+IFRoYW5rcyB2ZXJ5IG11Y2ggZm9yIHlvdXIgcmVwb3J0cyBhbmQg
ZGlzY3Vzc2lvbi4NCj4gPiA+DQo+ID4gPiBJJ20gbm90IHF1aXRlIHN1cmUgd2Ugd2FudCB0byBy
ZXZlcnQgaXQgZW50aXJlbHksIGFzIHRoYXQgd291bGQNCj4gPiA+IGltbWVkaWF0ZWx5IHJlZ3Jl
c3MgdGhlIHdvcmtsb2FkcyBpbXByb3ZlZCBieSB0aGUgY29tbWl0LCBzdWNoIGFzIHRoZQ0KPiBr
ZXJuZWwgYnVpbGQuDQo+ID4gPiBBbHNvLCBmb3IgZXhhbXBsZSwgS2FpcnVpJ3MgY292ZXIgbGV0
dGVyIG1lbnRpb25lZCB0aGUgTGV2ZWxEQiBiZW5jaG1hcms6DQo+ID4gPiAgIkkgYWxzbyByZXRl
c3RlZCB0aGUgTGV2ZWxEQiBiZW5jaG1hcmsgZnJvbSB0aGUgY2FjaGVfZXh0IHBhcGVyIFs1XS4N
Cj4gPiA+IEludGVyZXN0aW5nbHksIG1haW5saW5lIE1HTFJVIGFscmVhZHkgYmVhdHMgQ0xSVSBv
biB0aGlzIG9uZSBhZnRlciBhDQo+ID4gPiByZWNlbnQgY2hhbmdlIGluIGxydV9nZW5fZm9saW9f
c2VxIHRoYXQgYnVtcHMgbmV3IGZvbGlvcyB3aXRoIHJlZnMNCj4gPiA+ID09IDEgdG8gdGhlIHNl
Y29uZC1vbGRlc3QgZ2VuZXJhdGlvbi4iDQo+ID4gPg0KPiA+ID4gSSBndWVzcyB3ZSBjb3VsZCBp
bnN0ZWFkIHRyeSB0byBtaXRpZ2F0ZSB0aGUgY2FzZXMgd2hlcmUgc29tZQ0KPiA+ID4gd29ya2xv
YWRzIGFyZSBuZWdhdGl2ZWx5IGFmZmVjdGVkIHdoaWxlIHByZXNlcnZpbmcgdGhlIG9yaWdpbmFs
DQo+ID4gPiBpbnRlbnRpb24uIERvZXMgdGhlIGZpeCBiZWxvdyBhZGRyZXNzIGJvdGggb2YgeW91
ciBjYXNlcywgb3IgaXMgRWhhYidzIGNhc2UNCj4gYWN0dWFsbHkgZGlmZmVyZW50IGZyb20gS2Fp
cnVpJ3M/DQo+ID4gPiAoVGhlIGtlcm5lbC1idWlsZCB0ZXN0IG9uIG15IG1hY2hpbmUgbG9va3Mg
cXVpdGUgcG9zaXRpdmUuIEl0IG5vdA0KPiA+ID4gb25seSBwcmVzZXJ2ZXMgdGhlIG9yaWdpbmFs
IG9wdGltaXphdGlvbiwgYnV0IGV2ZW4gcHJvdmlkZXMgZnVydGhlcg0KPiA+ID4gZ2FpbnMuKQ0K
PiA+ID4NCj4gPg0KPiA+IEkgYWdyZWUgdGhhdCByZXZlcnRpbmcgdGhlIGNvbW1pdCB0aGF0IGNh
dXNlZCB0aGUgcmVncmVzc2lvbiBpcyBub3QNCj4gPiB0aGUgb3B0aW1hbCBwYXRoLiBJIGV4cGVj
dCB0aGVyZSBhcmUgbWFueSB3b3JrbG9hZHMgYW5kIHNjZW5hcmlvcyB0aGF0DQo+ID4gYmVuZWZp
dCBmcm9tIHRoZSBiZWhhdmlvciBpbnRyb2R1Y2VkIGJ5IHRoYXQgY29tbWl0LCBzbyByZXZlcnRp
bmcgaXQNCj4gPiBjb3VsZCB1bm5lY2Vzc2FyaWx5IHJlZ3Jlc3MgdGhvc2Ugd29ya2xvYWRzLg0K
PiA+DQo+ID4gSSB3aWxsIHJ1biB0aGUgQ2Fzc2FuZHJhIGJlbmNobWFyayB3aXRoIEthaXJ1aSdz
IE1HTFJVLUZHIHBhdGNoZXMgdG8NCj4gPiBzZWUgd2hldGhlciB0aGV5IGFkZHJlc3MgdGhlIGlz
c3VlIEkgYW0gc2VlaW5nLiBJIHdpbGwgc2VuZCB0aGUNCj4gPiByZXN1bHRzIHdoZW4gdGhleSBh
cmUgcmVhZHkuDQo+ID4NCj4gDQo+IFRoYW5rcyB2ZXJ5IG11Y2gsIEVoYWIuIENvdWxkIHlvdSBw
bGVhc2UgYWxzbyBydW4gbXkgcHJvcG9zZWQgcXVpY2sgZml4Og0KPiANCj4gaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvbGludXgtbW0vMjAyNjA5MDEyMjA0MzAuNzk4MTAtMS0NCj4gYmFvaHVhQGtl
cm5lbC5vcmcvDQo+IA0KDQpIaSBCYXJyeSwNCg0KVGhhbmtzIGZvciBzZW5kaW5nIHRoZSBzdWdn
ZXN0ZWQgZml4LiBJIHRlc3RlZCBpdCB3aXRoIHRoZSBDYXNzYW5kcmEgYmVuY2htYXJrLA0KYW5k
IHRoZSByZXN1bHRzIGxvb2sgcHJvbWlzaW5nLiBBY3Jvc3MgdGhlIHJ1bnMsIHRocm91Z2hwdXQg
d2FzIGFwcHJveGltYXRlbHkNCjQ5LjRLIHRvIDUwLjNLIG9wcy9zLCBhdmVyYWdpbmcgYWJvdXQg
NTAuMEsgb3BzL3MsIHdoaWxlIHRoZSA5OXRoLXBlcmNlbnRpbGUNCmxhdGVuY3kgcmVtYWluZWQg
YXJvdW5kIDcuMCB0byA3LjEgbXMuIFRoaXMgcmVwcmVzZW50cyBhbiBpbXByb3ZlbWVudCBvdmVy
DQp0aGUgYmFzZWxpbmUgb2YgYXBwcm94aW1hdGVseSA0My45OEsgb3BzL3MgYW5kIDkuMDI1IG1z
IHA5OSBsYXRlbmN5Lg0KDQpUaGUgdW5kZXJseWluZyBpZGVhIGluIGJvdGggc29sdXRpb25zIGlz
IHZlcnkgc2ltaWxhcjogQSBjcmVkaXQtYmFzZWQNCnN5c3RlbSBwcm90ZWN0cyBmaWxlIGZvbGlv
cyB3aGVuIHJlYWRhaGVhZCBwcm92ZXMgdXNlZnVsLiBJbiBteSB2ZXJzaW9uLA0KSSBmdXJ0aGVy
IHR1bmVkIGNyZWRpdCBhY2NvdW50aW5nIGFuZCB1c2VkIHBlci1DUFUgYmF0Y2hpbmcgdG8NCnJl
ZHVjZSBhdG9taWMgY29udGVudGlvbiBvbiBtdWx0aWNvcmUgc3lzdGVtcy4NCg0KVGhhbmtzLA0K
RWhhYg0KDQo+IEJlc3QgUmVnYXJkcw0KPiBCYXJyeQ0K

