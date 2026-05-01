Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AD00CD13DE
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 00:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A17656B008C; Thu, 30 Apr 2026 20:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C7AD6B0092; Thu, 30 Apr 2026 20:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88F516B0093; Thu, 30 Apr 2026 20:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7254F6B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:51:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17346C074B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 00:51:13 +0000 (UTC)
X-FDA: 84717022026.12.CA67333
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9AD58100007
	for <linux-mm@kvack.org>; Fri,  1 May 2026 00:51:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JXJcYXhu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of carlos.santa@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=carlos.santa@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777596669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+D9FB9s+ZjGpZuQumoEm7h8ERw59r2vJsR0Rrwho9o=;
	b=GL5bL2DyTicbEYPDbFpLontvjbMJ3d45Qs3JMU8SSenldjOVt0USg1kq9IDnbNV86yA2Lc
	mGddp7oytn4P/wCrafnNltBZ/eBSFTJ2qvcyTd/4MQDddhZNq3pp0g+xAS8fEZ/y++rtPc
	YMwwJOAIjkrsWXtaJaaMxUBjH50z4y8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777596669; a=rsa-sha256;
	cv=fail;
	b=6OAVp5VR25QvmgENwQKdrnR70C64LJYQGGcNrhkw/65a38wAOn+Mgc6V5dSPtcORshTr3Q
	JEoXW3zYjYb8+c/6atnkienzshQ5Yxly/z/+gtWK+BmuW/fvP0oD2ioZW+OrtSQhrHB469
	48v9FxcRsV0Tl4d/HWuDWdVVZEApJl0=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JXJcYXhu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of carlos.santa@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=carlos.santa@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777596669; x=1809132669;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9+D9FB9s+ZjGpZuQumoEm7h8ERw59r2vJsR0Rrwho9o=;
  b=JXJcYXhu1zDECwonzcYEf0EWyem5ogcPXZNyal1X8/rdCZ497gJv7rk6
   vVHdo3bm/h0jrhnlB+GdkyvuEl8P8CBJhAftAN6sM6bdF295dCm6mx5Ey
   KLf3ZOHCIZ0KuSJfGGF1+b8ggu4rES0jlPlrJtBYArykW8SXQyL/hLwm+
   fTT6YmcAcFKfp+tKcLGGxsJyfzyzO5V7sg/YKtYb3RZfMq7t0ESAkpnYI
   RrIppxRrABiGM6YkNMjwnr6z998GnlxGl/XTGHFPrCW2K5EmEZppkTdmz
   XFe4gwbUhR4agDIY+KObaRpEurOriM8DYapQVF2GrlUhGwsWaFJJlzVqv
   g==;
X-CSE-ConnectionGUID: Bf8qYy5DQzuJOiL4MTI4Pw==
X-CSE-MsgGUID: x41aDBNGT5yNKXbW13Zkww==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="66099712"
X-IronPort-AV: E=Sophos;i="6.23,209,1770624000"; 
   d="scan'208";a="66099712"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 17:51:04 -0700
X-CSE-ConnectionGUID: iHeVcYXBRBy1pi3kkD/S/w==
X-CSE-MsgGUID: KAsV6F/eTeyMTB0p6QdGLA==
X-ExtLoop1: 1
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 17:51:02 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 30 Apr 2026 17:51:01 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 30 Apr 2026 17:51:01 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.10) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 30 Apr 2026 17:51:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CbyU/14dwS9VdCQA5tJ+ixyn1Axo1hzuL7k3WOhpBGRVjwLC3QqsnKZLWmSb6sJDFNh/k4oxe0ymsD+3pCGAgwYaT6mhddv1HZnhESk5zU++enaeHWHTUH/WY6S12sCUyQ458fEhCKxxhU/An/yopLuYTCKm/Hq3ePdBnGrtU3gYHb/yx4SgPt/WNpX46tVrp5ncEEQsYFTUsyw1yNpQ5Ss9NI1KUW7r/jN/NPii088ng4NGRYzgqIVs3Zjqzj9SBEWQvt4+EEJ/rrVoBXIMfsgcPy/M9iZzOQBJ2YzEH+meZ6q5YAynx12g35AkhsPDmbE0Vyj1bAB25EXV2mKgVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9+D9FB9s+ZjGpZuQumoEm7h8ERw59r2vJsR0Rrwho9o=;
 b=EpBnh88TCdQPOz/1qoAvYlzk0HW+S8dfuzI0rUaZn6dJKmy5cQcdXmmNdVvw+jnX85CWlNIfVl518QWr9Tx8wGAeKOxj+/EfvgIEZ5uL2umVizdB0a4rT6mEhg3dVSBdMyI3PKvD+Anp86qlwrg644goBSL6sm9QbJR9ePRzC7zXapmEoVQXriyLI5tv2OoVoT78BS+BbOZ6IwIihj2ReXaCEsS17vepixY1yTSwkqSZGoC73fEku3bz2Mo49iq+PrBcdNR5fPgmjnwSwTeXa7n0nWRF/O+wjf7fWwfU7Si4hq70Sc6qFnIEDEYcviDg+5oAC4zOPqd/yFZUVUtOIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY5PR11MB6283.namprd11.prod.outlook.com (2603:10b6:930:21::19)
 by LVUPR11MB9786.namprd11.prod.outlook.com (2603:10b6:408:39c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.18; Fri, 1 May
 2026 00:50:59 +0000
Received: from CY5PR11MB6283.namprd11.prod.outlook.com
 ([fe80::fa60:e858:a245:4901]) by CY5PR11MB6283.namprd11.prod.outlook.com
 ([fe80::fa60:e858:a245:4901%5]) with mapi id 15.20.9870.022; Fri, 1 May 2026
 00:50:59 +0000
From: "Santa, Carlos" <carlos.santa@intel.com>
To: "intel-xe@lists.freedesktop.org" <intel-xe@lists.freedesktop.org>, "Brost,
 Matthew" <matthew.brost@intel.com>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "david@kernel.org"
	<david@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"thomas.hellstrom@linux.intel.com" <thomas.hellstrom@linux.intel.com>,
	"ljs@kernel.org" <ljs@kernel.org>, "vbabka@kernel.org" <vbabka@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "rppt@kernel.org"
	<rppt@kernel.org>, "mhocko@suse.com" <mhocko@suse.com>
Subject: Re: [PATCH v4 2/6] mm: Introduce zone_maybe_fragmented_in_shrinker()
Thread-Topic: [PATCH v4 2/6] mm: Introduce zone_maybe_fragmented_in_shrinker()
Thread-Index: AQHc2NYrwNSnOfWXSEquYFhK04QrFLX4V3YA
Date: Fri, 1 May 2026 00:50:58 +0000
Message-ID: <63cfdaec94fdbc6620846d98a47c18c0dfe3bc3e.camel@intel.com>
References: <20260430191809.2142544-1-matthew.brost@intel.com>
	 <20260430191809.2142544-3-matthew.brost@intel.com>
In-Reply-To: <20260430191809.2142544-3-matthew.brost@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY5PR11MB6283:EE_|LVUPR11MB9786:EE_
x-ms-office365-filtering-correlation-id: 4cc6832f-4939-4d1d-6dbb-08dea71bb5d4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021|56012099003|22082099003|18002099003;
x-microsoft-antispam-message-info: CuUXI9vD693CJb1bYOeZNh+B+Ja65dvuN7di8bMqe/crSYqVpTZWugAFmsQzt91BaWaZ5/sNH+WLTwzWqLFUF26wS/fOmfPEgeUHqw8MpaVxd7BBgicPJWPnZsNUFF2IiaFBmhBTT5jeUmwtZXN8g9U19v09V1HtJ2IhHlU5fBpKH4aKaqBfjR3vu1yaJdEyDFfG49rpNixp67dve7s0+/D6QiFWjIiB6VcGSWnNOQE7ZbbqIhtN19oIBcTMFd8qzP8yg2ZrsnX4HI29xMHXq347eFZcMy0g9IhKfbp2raaOCBE4zInkwyTrP0ELo7LM8gYU+LpFZMhhBddK7cA6AZjUR9gJTDIjTUFYYcJ2vl9rrKMDf6AwrAPUfWr04iNgMbdkybcEskhzxwQ+asexszgT0JnVhfA5heYxdlEztCeczVVoS1gxwkGV7Sww3x/FEg6vLJ1uhzPfAuJctXhpdj2I1zR3M8DzT3DZ84gR1ymF7CGGsY60WVDuSqjtfkGM8WJ6Vp0/RQM+r11R6KNpZQ13x5H0BTCp98JbM+XsaxUSKM78BtaRANtWMCqSFbZSunLuQ1UiDiaWaOCkKVDFFuhfRIuuOjHfiQpboRQO/35aUvLQNEgLp0WA1yUBsvfBflX7tJidQfMK6uCz/JV5sRHefVJNHrCJdg8/4y5qH4W43D7npBwGHuRgW0YE4Po7mUaWKsHMHoOpI13KQ+ct7v1lMk0wMyAkNK2ct/W+iLc6ZYfcpM1NhZeZ/xW1xCDv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6283.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SzF2RDFvS3YzcWx1ek50am5GTXk1OG93cTR2aXlHcUFUaWpvZlZnT1VYLzRQ?=
 =?utf-8?B?NzkrNzNNaThuVmtuWjBvNDlxUXJVWFB2QVdVcVloeTAwM0E4d1JrK2JTL2NF?=
 =?utf-8?B?cVM4RVVPWmlDYXl5NmVqb2tpYXM4bGR5VHVleGZhUHFrQi9IaEFqaHVzc2o3?=
 =?utf-8?B?R1J2SzZKaHhpTTRoVjd1T3pyY0FCeHNFWmRhWkdoWkZDK2xxcFBKTWlEemtk?=
 =?utf-8?B?NmcySnY1bHRoV1d5Zkt4OVplckRCN0dIL0JteFNEeXU5U25DMis1ZXlzSEVI?=
 =?utf-8?B?Y0dGOFpQS1V4Z3ZXMFROc1JMdFNsbGNqRjZoM1RHekpJZjhVcXRTcVRSVnZV?=
 =?utf-8?B?OVVkTHZmV3RoSVFvZnptRGNxeGhhc3FJT3A0TktSVW5OSjI0b1E0VDd6NGk5?=
 =?utf-8?B?YTNRQkZ1MUQ1VGhUY1QvblNCVWJoVTV0NlBjWjhobXJkNjJXblRwTmM3SThr?=
 =?utf-8?B?cVBVc1NvZjdwazZtVi9oN3lGUzVSbmhkRzhsaG9HZHBwc0lOWGpMMWd5akhI?=
 =?utf-8?B?S3RxOFo4Z3ZweThkODdDYmVTZUdtakdHcUJSajJhQ3I5dU44d1pYemgvdjNJ?=
 =?utf-8?B?c1FFYjA0T1o0bW9aRkVlMEdSVm53VWRrTWRwZXdndWtUK2Jqc1NDYWdGYVJh?=
 =?utf-8?B?OVdGK3Q2eFdncGdSMFE5Q2daVXhBTG5nMjNWYnVKWGp0a0JFclVSTWxlS1dv?=
 =?utf-8?B?UG1JaXkzNDJja1hhbUZWWFhuQktJRFp1c1VTNEd2N2RKNW1wQit2bDcxY2ps?=
 =?utf-8?B?aFRRNENQclh3eDNzSVdTK2FFbm9BY2RqM2hIWHJpN0NkVWlDUUNzTHRHMFZZ?=
 =?utf-8?B?OS8yY2hoaXFoVWdld3hFOGdWdWZqelV4eUl1Nnl2NDIyS3pTM3FFZnZpa05F?=
 =?utf-8?B?bkZnbVo3a21kUGIrUjgya2xxV1NTYnBiTTRidjdFMnozUDdWbW9MRzY0ekhM?=
 =?utf-8?B?ekV0dXVMb2JqaThxVkY1eEI1N3lXYXJUMGMxcDZ0dGRUNFNsRThuN1piczY1?=
 =?utf-8?B?OU9oUDh4VUJUVGIrR2Y3TVh3a2ZJaFFqVVo2WjZrOWM2ZGhkdTBSaWhjejN5?=
 =?utf-8?B?RW1oSHNtYmUxQ1RlTlpOdEVYeUxIZEh6Mkw3RnFpUmoyVW80bFdhTW1VTzIz?=
 =?utf-8?B?RUhKNWt0Y3VqLzZCQ1VTTEVMcEpZelJyak9NeUpLY3E4QjhyWTAyUjZIdnhW?=
 =?utf-8?B?SkVBaW1DODdkY1BFMkswVVZ5QUcwY2cxK2xKRWgxRzRqOVEzRmxobzI5Wkgr?=
 =?utf-8?B?MWlyemh6VTJuaTNZMXIrcVZOb1MxQ2JUMmNSdGhIY1VoaWZjUlh0b1hDbnBw?=
 =?utf-8?B?THVXSGg2NjFFUGxJd2VGT1dhUjMwa29BZEFjWmNaNGhZKy9yOWZiMW1FcVRn?=
 =?utf-8?B?cDNPNkJ5NFh4N3ovUDIydFV2cEd6R1pzVFdsN2FSK1Q1YWdiNXJrekEyTmVU?=
 =?utf-8?B?Y0xNTDI3Z0RKaVM2akkvRXJrVXcwcVZaNVJGdllQNk5xbnN6dmY5c0ZaV0dH?=
 =?utf-8?B?UVNzY2ZsVC9kSklsUlVlZ0hoYXA2UDdNSVRpSFB2ek5EODFkN1kyT1ZXeUxN?=
 =?utf-8?B?Y1JESUdMaGRVVFFVcG4vZnR0SElVZDBTOHkvN2NwTm5uU0RCMndlODNwcSty?=
 =?utf-8?B?L3N5OHVSclhOdkNzaGRLRjVncDN6MDRrRjUyZm9YNThGUmZXVklpcTR3U3dq?=
 =?utf-8?B?cTZ2SXA4TWNkV3dRY2svL0x2M2lCcUgwMTU1a1VqdW13T25yTlFLUTh2aUNO?=
 =?utf-8?B?OVppYmhmMXo4cDJUb1pRK0ExbW9ycjdlaG5oS1FGTHFvQXJxd2k5K0FydWRE?=
 =?utf-8?B?MTRpcmcrWFZZMDN2U0l1S3RRRm43ZENtd2xjT004MTZaZmRvSzFqYmpYcjhF?=
 =?utf-8?B?YnpJTzRYay9Md3N3L2VTUjV4QjR1aEdOc3puM3ZHa3h0SExZaWZ0SU1pdnNE?=
 =?utf-8?B?QXNTcnhMQzVZVlppbk5INGNma0pNajY1TjNyS0RUTk1VWnkxTGRFZkRaWXpU?=
 =?utf-8?B?NlVaQmFKdlhFSkQzUncxT1hkejhTaUtJUkRyQ3ppODlvUjhadkhycllkcWNF?=
 =?utf-8?B?MURIRzJPNnpMRCt1dDZvRzZ5bE1IUkRyTXpGb21IeXhGbUJsNWYvRkI5a3JR?=
 =?utf-8?B?QlM5Q0lRMStNb292cGhsbG1FYWY4eVlGM1pUc2g0bDluenNaWGc3UWxkOFRM?=
 =?utf-8?B?QllzSFBvNUhSQm1TNnZ6NUFVMWdZVlhSdDg1amh1UkVLaU03eGhQbllZMFdo?=
 =?utf-8?B?ekV4OGlrTnRITHNjSS91RFRNNnAvZTBHRVVtZFljbUhmdkhwUFZ0RnNrbjBU?=
 =?utf-8?B?TnRBNGlFbXk5WHRNc3BiRVR5WENEb0twaU4yVVY0MVFtV2tqcjNEMExLYnV1?=
 =?utf-8?Q?7wRYs7RR4Nx9u3Pw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <11B8BE2B914562409720674A53538627@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: PmtGepIeWKdohws2atJwu85ix4bh0nQHpaCqdvLZYQqapLQ7H4qezwRIAMtErwuJWeq+bbJDNkq/n3/H+qUzbe8inzos727TEaouVO27U8WPe1vNjkC75v6oc6FBoJaXbrc3yk3TsIlLfVpgkwnMyD9bfw+keFjXmrUkr1/aHbPHGI3w7UiuQ+vOOtF4Id3EULa1hKjUpElMYDi8oZLd4YBpmaDRLnzXUa2nu9keg+wIlrPHSAt8M7k6UkFqPHk/wGP/7/i+h+daPF0ssahuccaI0WxdUvFfmFBENYoH7AFea0nKSc4V3n4CxUX71cGCtPP1DssEM9XN49QoV2c8lg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6283.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cc6832f-4939-4d1d-6dbb-08dea71bb5d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2026 00:50:58.9310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZiAo+PmSD6TKHLvxDMxHQ0UZIQkFFNUXTWMGZVlfGJcPd7LwQ5grarTUT3S7/hBBTMHkQ+M8iMpmDUsAGmXDKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVUPR11MB9786
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 9AD58100007
X-Rspamd-Server: rspam04
X-Stat-Signature: 46sbtchhb58cenk6eyq6gxknq5ae9b6b
X-HE-Tag: 1777596668-221213
X-HE-Meta: U2FsdGVkX18PQwne9mWGWJaC3KjmXoaYHhYvOhyihRkfxp8iYyG4z5XnDe0OJqcgL9ATwmbTlHsijtUW06uo2LHMD8fcqLxSGcLWx3LOlG4rmSQ9W1XHzn8vRol0akvvXqpMEd6pl7BcwJ4sD+8nNmnTXU6NuuVFPwnaQL06bYBm+h9yepQ5PlYRZDkl23QQBgaM6I29GqGXsCuBi3ca0pMZoJqjnZ6Afxn2x3RpaXwVZRSaZ6U69+2drc6gjQbyhFhVTkj9etgKWNQiDqT8H3YX3rs/d6/HEop0D1sXHfKEqieolixghySXq6E0f8cle16bkj8y56hBOw9DCD+0ItBxtw4OCCfkWzFXvpzfO7lKuD8iwVqmzKEPjLSheSKSzKSJaClqWsj75IMZloAIdjoMWnzrTqqyRrPNE1vuSEGs8/F8ygwd87Zxp/JO7NVOMx4Nz3DOFuujMToPDbRMh+CEs8pRKkMoMHjDIk2NaZlPd6F2+JT+PQVWAmsG5esuhnFm6ECweun9GX/cyBD/gAyTn2q1LW0Uopn95rkW1BKFsuTOPjq5asUA2YTQvtAjEqfBtxpshBv4QXZ+gIbYQ0R9WCoHXkivVoVLiukMZNcVtMnjNbtw25Br9WNPggieM4DXyTp81tkVluyUtFWHgfkkHi3jyDhvwXsEZlQRxdkMxdZ3EtvEYYYK3cBnIIuERQEtplGFTzpSw+CQ/6X0S/Jp3gkGfDnafaZi6qNeieKNkoxvYhHFkbATqMUqcDLxLE4aWol8oHh1Pd2c2Vkr0UJyXNAro6EM+mOQTXIFf/r40d0hRhvTeHwA2lfgB1G1xcXGeY1CPR4+h3j7iVfMXbnQadU/nHxD2DixiYXwWQsGkPH2ehUvW/Uy5daVwhCT3yx3io/niFVDsYneJMU8Vd8Y6lJ7Hiq7PQ10f9mHu8zEUKX/7Gvmq1q+4E8ZTfg7Hkkf7T/jZAZMF+yTp5R
 3kLM1ghy
 qy1W7jqoY5Rb7qoMN3cOuiQHTAlMYOuLbcsR+W/Z090hloTP3WMFqE1/nn0U8v8Q1Oz8GXm37pElBiEbRMKkcLO12X3uC4gQ8X4hYgW2B4Mzp9/VcuuRj71Y9TLxU62ktAFyazs06DDNxz098dnK6XzSrvn0OU4Eu5X4D6V995XDG2ae8Dfuql+YVcoRxTH1Johzsw4LW0OaKVXmImyDhMq4ERIgKsJKajFR4+HapMUrAJGfND0SQKlJB21Ert2XxKOhag913WRS2n6gAKtdyvRxZuldNpSpE6az0aiNjVA1WIyUBGPqopnF1NGx+nRzSkOo3nCGPyFSGERBm5HUykshGuWUrHm4jAyY8vdhhGV6Hrvk889+zE9kx3Zz9kXOmyoNUisYpa9ZK3Pnw9tNqlyx+xj1W87XS7wSGq4G5qOqr16aFNbdYoj+RH2flOH41L+J73xOZgbmB2OEEUOz8Rud6LCZzFafW4fC48mdltxi7THWvn1RMV2Mt1/LaKB7iInC5b+jKKSe1a5H4ekznwW/LW6pSG/a90RwlqGClSLpr9/v2t/6vjLjXd5wTPa+yhMZs4ksQaVghpI7DRe6IevDxXfrJa8VD8v3FaFkkxIHulwqFOkNo57hHUnQII1x2hePybfS8g2d0k8AF1hYsY0amImfxiZaWMR3Q9F9IXhsXiQjvBZ0hotG0+ZQlT3m9QRGb5643UA65vP4WPXRnufivP8FxIeHoaaxJE4LRoq0J+4SZUWPk8o8Ym2258fmAjpTG0+PM9Cx4o7UNcQJnMkw+LiN7D9NZXJCqCcK4DBRqS6Id9kw9hMDsNX5JejjkFbA9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVGh1LCAyMDI2LTA0LTMwIGF0IDEyOjE4IC0wNzAwLCBNYXR0aGV3IEJyb3N0IHdyb3RlOg0K
PiBJbnRyb2R1Y2Ugem9uZV9tYXliZV9mcmFnbWVudGVkX2luX3Nocmlua2VyKCkgYXMgYSBsaWdo
dHdlaWdodCBoZWxwZXINCj4gdG8NCj4gYWxsb3cgc3Vic3lzdGVtcyB0byBtYWtlIGNvYXJzZSBk
ZWNpc2lvbnMgYWJvdXQgcmVjbGFpbSBiZWhhdmlvciBpbg0KPiB0aGUNCj4gcHJlc2VuY2Ugb2Yg
bGlrZWx5IGZyYWdtZW50YXRpb24uDQo+IA0KPiBUaGUgaGVscGVyIGltcGxlbWVudHMgYSBzaW1w
bGUgaGV1cmlzdGljOiBpZiB0aGUgbnVtYmVyIG9mIGZyZWUgcGFnZXMNCj4gaW4gYSB6b25lIGV4
Y2VlZHMgdHdpY2UgdGhlIGhpZ2ggd2F0ZXJtYXJrLCB0aGUgem9uZSBpcyBjb25zaWRlcmVkIHRv
DQo+IGhhdmUgYW1wbGUgZnJlZSBtZW1vcnkgYW5kIGFsbG9jYXRpb24gZmFpbHVyZXMgYXJlIG1v
cmUgbGlrZWx5IGR1ZSB0bw0KPiBmcmFnbWVudGF0aW9uIHRoYW4gb3ZlcmFsbCBtZW1vcnkgcHJl
c3N1cmUuDQo+IA0KPiBUaGlzIGlzIGludGVudGlvbmFsbHkgaW1wcmVjaXNlIGFuZCBpcyBub3Qg
bWVhbnQgdG8gcmVwbGFjZSB0aGUgY29yZQ0KPiBNTSBjb21wYWN0aW9uIG9yIGZyYWdtZW50YXRp
b24gYWNjb3VudGluZyBsb2dpYy4gSW5zdGVhZCwgaXQgcHJvdmlkZXMNCj4gYSBjaGVhcCBzaWdu
YWwgZm9yIGNhbGxlcnMgKGUuZy4sIHNocmlua2VycykgdGhhdCB3aXNoIHRvIGF2b2lkDQo+IG92
ZXJseSBhZ2dyZXNzaXZlIHJlY2xhaW0gd2hlbiBzdWZmaWNpZW50IGZyZWUgbWVtb3J5IGV4aXN0
cyBidXQNCj4gaGlnaC1vcmRlciBhbGxvY2F0aW9ucyBtYXkgc3RpbGwgZmFpbC4NCj4gDQo+IE5v
IGZ1bmN0aW9uYWwgY2hhbmdlczsgdGhpcyBpcyBhIHByZXBhcmF0b3J5IGhlbHBlciBmb3IgZnV0
dXJlIHVzZXJzLg0KPiANCj4gQ2M6IFRob21hcyBIZWxsc3Ryw7ZtIDx0aG9tYXMuaGVsbHN0cm9t
QGxpbnV4LmludGVsLmNvbT4NCj4gQ2M6IEFuZHJldyBNb3J0b24gPGFrcG1AbGludXgtZm91bmRh
dGlvbi5vcmc+DQo+IENjOiBEYXZpZCBIaWxkZW5icmFuZCA8ZGF2aWRAa2VybmVsLm9yZz4NCj4g
Q2M6IExvcmVuem8gU3RvYWtlcyA8bGpzQGtlcm5lbC5vcmc+DQo+IENjOiAiTGlhbSBSLiBIb3ds
ZXR0IiA8TGlhbS5Ib3dsZXR0QG9yYWNsZS5jb20+DQo+IENjOiBWbGFzdGltaWwgQmFia2EgPHZi
YWJrYUBrZXJuZWwub3JnPg0KPiBDYzogTWlrZSBSYXBvcG9ydCA8cnBwdEBrZXJuZWwub3JnPg0K
PiBDYzogU3VyZW4gQmFnaGRhc2FyeWFuIDxzdXJlbmJAZ29vZ2xlLmNvbT4NCj4gQ2M6IE1pY2hh
bCBIb2NrbyA8bWhvY2tvQHN1c2UuY29tPg0KPiBDYzogbGludXgtbW1Aa3ZhY2sub3JnDQo+IENj
OiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFNpZ25lZC1vZmYtYnk6IE1hdHRoZXcg
QnJvc3QgPG1hdHRoZXcuYnJvc3RAaW50ZWwuY29tPg0KPiANCj4gLS0tDQo+IA0KPiB2Mzogcy96
b25lX2FwcGVhcl9mcmFnbWVudGVkL3pvbmVfbWF5YmVfZnJhZ21lbnRlZF9pbl9zaHJpbmtlciAo
RGF2aWQNCj4gwqDCoMKgIEhpbGRlbmJyYW5kKQ0KPiAtLS0NCj4gwqBpbmNsdWRlL2xpbnV4L3Zt
c3RhdC5oIHwgMTIgKysrKysrKysrKysrDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlv
bnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3Ztc3RhdC5oIGIvaW5jbHVk
ZS9saW51eC92bXN0YXQuaA0KPiBpbmRleCAzYzljMjY2Y2Y3ODIuLjFhZDQ4ZjcwYzlkOSAxMDA2
NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC92bXN0YXQuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4
L3Ztc3RhdC5oDQo+IEBAIC00ODMsNiArNDgzLDE4IEBAIHN0YXRpYyBpbmxpbmUgY29uc3QgY2hh
ciAqem9uZV9zdGF0X25hbWUoZW51bQ0KPiB6b25lX3N0YXRfaXRlbSBpdGVtKQ0KPiDCoAlyZXR1
cm4gdm1zdGF0X3RleHRbaXRlbV07DQo+IMKgfQ0KPiDCoA0KDQpvbiB0aGUgYmVsb3cgaGV1cmlz
dGljLCBJIHdhcyB0aGlua2luZyBvZiB0aGUgZm9sbG93aW5nIGNhc2U6IGEgbGFyZ2UNCm1lbW9y
eSBzeXN0ZW0gKHNheSAxNkcsIDMyRyksIGhlYXZpbHkgZnJhZ21lbnRlZCAoZm9yIHdoYXRldmVy
IHJlYXNvbikNCmJ1dCBjb25zdHJhaW50IGJ5IHRoZSBJT01NVSByZXF1aXJpbmcgbGFyZ2UgcGFn
ZXMgZHVlIHRvIGh3IGFsaWdubWVudCwNCmlmIEkgYW0gbm90IG1pc3Rha2VuIHRoZSBiZWxvdyBj
aGVjayB3aWxsIGNhdXNlIHRoZSBzaHJpbmtlciB0byBiYWlsDQpvdXQgdG9vICdlYXJseScgc2lu
Y2UgdGhlIHRoZXJlJ3MgcGxlbnR5IG9mIGF2YWlsYWJsZSBtZW1vcnkgYnV0IG5vbmUNCm9mIHRo
YXQgaXMgY29udGlndW91cywgdGhlbiBlbmQgcmVzdWx0IHNob3VsZCBiZSBnaXZpbmcgYmFjayBz
bWFsbA0KcGFnZXMgd2hpY2ggc2hvdWxkIHJlZHVjZSBwZXJmb3JtYW5jZSwgcmlnaHQ/DQoNCmJl
bG93IGFyZSBzb21lIG1hZGUgdXAgbnVtYmVyczoNCg0KDQpNZXRyaWMgICAgICAgICAgfCA4R0Ig
ICAgICAgICAgICAgICB8IDE2R0INCi0tLS0tLS0tLS0tLS0tLS18LS0tLS0tLS0tLS0tLS0tLS0t
LXwtLS0tLS0tLS0tLS0tLS0tLS0tDQpIaWdoIFdtYXJrICAgICAgfCB+NDVNQiAoMTFrIHBncykg
ICB8IH45ME1CICgyM2sgcGdzKQ0KQmFpbCBHYXRlICgyeCkgIHwgfjkwTUIgKDIyayBwZ3MpICAg
fCB+MTgwTUIgKDQ2ayBwZ3MpDQpGcmVlIFJBTSAgICAgICAgfCAxMjBNQiAgICAgICAgICAgICB8
IDcxMDBNQiAoNy4xR0IpDQpTaHJpbmtlciAgICAgICAgfCBSVU5TIChGcmVlPEdhdGUpICB8IEJB
SUxTIChGcmVlPkdhdGUpDQpPdXRjb21lICAgICAgICAgfCBNZXJnZXMgMk1CIGJsb2NrcyB8IDRL
QiBwYWdlcw0KDQpJbiBvdGhlciB3b3JkcywgcmVwbGFjaW5nIHRoZSBjaGVjayB3aXRoIG51bWJl
cnM6DQoNClN5c3RlbSAgICAgICB8IEZyZWUgUkFNIChQYWdlcykgfCBHYXRlIChQYWdlcykgfCBG
cmVlIDwgR2F0ZT8gfCBSZXN1bHQNCi0tLS0tLS0tLS0tLS18LS0tLS0tLS0tLS0tLS0tLS0tfC0t
LS0tLS0tLS0tLS0tfC0tLS0tLS0tLS0tLS0tfC0tLS0tLS0NCjhHQiAgICAgICAgICB8IDIwLDQ4
MCAoODBNQikgICAgfCAyMiw5NDYgICAgICAgfCAyMDQ4MCA8IDIyOTQ2fCBSVU5TDQoxNkdCICAg
ICAgICAgfCAxLDgzMiw3NDAgKDcuMUcpIHwgNDUsODk0ICAgICAgIHwgMS44TSA8IDQ1az8gIHwg
QkFJTFMNCg0KDQpDYXJsb3MNCg0KPiArc3RhdGljIGlubGluZSBib29sIHpvbmVfbWF5YmVfZnJh
Z21lbnRlZF9pbl9zaHJpbmtlcihzdHJ1Y3Qgem9uZQ0KPiAqem9uZSkNCj4gK3sNCj4gKwkvKg0K
PiArCSAqIFNpbXBsZSBoZXVyaXN0aWM6IGlmIHRoZSBudW1iZXIgb2YgZnJlZSBwYWdlcyBpcyBt
b3JlDQo+IHRoYW4gdHdpY2UgdGhlDQo+ICsJICogaGlnaCB3YXRlcm1hcmssIHRoaXMgbWF5IHN1
Z2dlc3QgdGhhdCB0aGUgem9uZSBpcyBoZWF2aWx5DQo+IGZyYWdtZW50ZWQuDQo+ICsJICogV2hl
biBjYWxsZWQgZnJvbSBhIHNocmlua2VyLCBhZ2dyZXNzaXZlbHkgZXZpY3RpbmcgbWVtb3J5DQo+
IGluIHRoaXMgY2FzZQ0KPiArCSAqIG1heSBkbyBtb3JlIGhhcm0gdG8gb3ZlcmFsbCBzeXN0ZW0g
cGVyZm9ybWFuY2UgdGhhbiBnb29kLg0KPiArCSAqLw0KPiArCXJldHVybiB6b25lX3BhZ2Vfc3Rh
dGUoem9uZSwgTlJfRlJFRV9QQUdFUykgPg0KPiArCQloaWdoX3dtYXJrX3BhZ2VzKHpvbmUpICog
MjsNCj4gK30NCj4gKw0KPiDCoCNpZmRlZiBDT05GSUdfTlVNQQ0KPiDCoHN0YXRpYyBpbmxpbmUg
Y29uc3QgY2hhciAqbnVtYV9zdGF0X25hbWUoZW51bSBudW1hX3N0YXRfaXRlbSBpdGVtKQ0KPiDC
oHsNCg0K

