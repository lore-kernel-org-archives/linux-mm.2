Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C55CCA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 20:52:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E34C68E0007; Mon,  8 Sep 2025 16:52:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0C498E0001; Mon,  8 Sep 2025 16:52:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFB438E0007; Mon,  8 Sep 2025 16:52:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF1DB8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:52:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 601F1B7C6D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:52:04 +0000 (UTC)
X-FDA: 83867280168.29.3756E03
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf23.hostedemail.com (Postfix) with ESMTP id C5B33140012
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:52:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NTbeWoi9;
	spf=pass (imf23.hostedemail.com: domain of dan.j.williams@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757364721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6XLUQJhltPN69pvSs/M6yMDb1tk3Q3ks/oKhTiQjoO4=;
	b=5fa/zlwRctFUeBYIHs+CX/Z6Rs51iLcnfxAhAU2e2oatmJXtGPhklHiVzXjlqmCcJjDJ7/
	UQi0Fvh+xqW825C52lcQuc0hCNB6U1OHZ0DmhqmpZmC8RqK+3uoyHkP302bR/MbOpHdrKw
	5n1eW/f7EvXpjQ1RkDl9Im1LL40QQZI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757364721; a=rsa-sha256;
	cv=fail;
	b=FNUsgveYCTEBn2sbazYx1KV+XHw1IMtUqqCey/gNqELlrAxqLXHNB06HBMPcRn/Pp6Z4w2
	kr4HurCf12kgqWF2dyN/YsKqXQfDKctfa56n4ug8npYIdCIoFrOiP7GOVTvLsLIz8GaCNk
	IvNDIVgm7CE7ubgDgdNUEEsc8St1TKw=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NTbeWoi9;
	spf=pass (imf23.hostedemail.com: domain of dan.j.williams@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757364721; x=1788900721;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=XDTGQPv3GMy/rDFKiGCSVGEv4DA2m19Ywy5Jftyp14c=;
  b=NTbeWoi97AvpwXgB4aDwP2CAsda6+Tzp4E9KqDprd4oFfISkR/8rGGis
   9KsPalvKkTeoqfg/ijDce9LwjAd2iLHrHJwSbpCnoCrJhUa9l2qxE3htG
   Jd+IRZ18SbPaQHP1UPPgWsKHZrOI4us0WQv0YiuVYcS5/ZAgW4NrBNcH4
   MOKM+BNs1NwqDwmqQbHuY//6szi/45CXH1wYCqOKOrMs9u4F/0XJmCR6G
   TmgX1e1q50SWANzyLxIjUfFlYrRFCx/VaWyr7WcwwNKGvP0uTlBDk8Zms
   2cIFgIq08poW6Xk3zswNB382+7QJBWHkgPSf/NIEdi2ssEN6Xp3op60v5
   g==;
X-CSE-ConnectionGUID: 9tCOwnjUTYWID3lcVb4wfw==
X-CSE-MsgGUID: 6/4/oBSySxidXr+pe94Kgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="58849332"
X-IronPort-AV: E=Sophos;i="6.18,249,1751266800"; 
   d="scan'208";a="58849332"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 13:51:59 -0700
X-CSE-ConnectionGUID: tuBW0B3ORAKOtv8UAF2ddQ==
X-CSE-MsgGUID: Mrg59IGLSaWkHbLmJ8m0FQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,249,1751266800"; 
   d="scan'208";a="173022814"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 13:51:59 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 8 Sep 2025 13:51:57 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 8 Sep 2025 13:51:57 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.43)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 8 Sep 2025 13:51:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pNUZasKgMgIaNnmA+qyygbB8VFrfEZ/K6+y1h/Ze5OvwYK1ch6v4vBQD6IxpH/cf7SgiKA5PY/swwHNbNYr+GUuGgAG4fuYK5fcYbeQYomaZpFkbD+uJI4AIMTaRzhwDhpo8N/89toyO+MwFZ4sckQquMkXpaFwNKdeoDJze2Vu1mrwFImrA/ZmtG0rnccr730H8D3b4R2WjPsOG1J3EyqGG6wxrlqifEya/b/FX1D1Yli8aOKvD+pgJAvilyX1jrOCyn4xsg3Sa3mUlKt1Y+jn+JhrXMsD5icwK0/WnuMRFw9JpVf7/jy2+sTYbnDHAIinMqm3fKwYGIsNWpw7WDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6XLUQJhltPN69pvSs/M6yMDb1tk3Q3ks/oKhTiQjoO4=;
 b=h008UyGj02gUnmwSDNtgn/NuDrS1w4AHIgE8PSLeEPPScJHcy26GLp90JE5eeIoTEsYi/kAOBZynQlwF0lwDN9wnbIaKNUEWNosPUHcC4wvvpjLhXBVzdLqn9S9w04B6foJjlrqOFgTgvCkbdp4rRWBRQPmvOGubJHF+0rwT/ZVHrYGrNPSdsXIBOZNBaeu0egOvRWGimpHwTDxCdrSgpAifqWL5i2/zAnNGlDi6w1qUvPMxkYcMnNL74mLe4g7OBjOXq3KUdf+we8WZAXTch/907oEfukbyik7pGCNMWsN6RIsMyMn657qF4EbvtV1eVLceLtuqQjn3xysWiw6qkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA3PR11MB8118.namprd11.prod.outlook.com (2603:10b6:806:2f1::13)
 by CH3PR11MB8343.namprd11.prod.outlook.com (2603:10b6:610:180::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 20:51:54 +0000
Received: from SA3PR11MB8118.namprd11.prod.outlook.com
 ([fe80::c4e2:f07:bdaa:21ec]) by SA3PR11MB8118.namprd11.prod.outlook.com
 ([fe80::c4e2:f07:bdaa:21ec%4]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 20:51:54 +0000
From: <dan.j.williams@intel.com>
Date: Mon, 8 Sep 2025 13:51:52 -0700
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Catalin Marinas
	<catalin.marinas@arm.com>, <james.morse@arm.com>,
	<linux-cxl@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-acpi@vger.kernel.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, Will Deacon <will@kernel.org>, Dan Williams
	<dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "H . Peter
 Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
CC: Yicong Yang <yangyicong@huawei.com>, <linuxarm@huawei.com>, Yushan Wang
	<wangyushan12@huawei.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, "Mark
 Rutland" <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Andy Lutomirski
	<luto@kernel.org>
Message-ID: <68bf41e8b726a_75e310099@dwillia2-mobl4.notmuch>
In-Reply-To: <20250820102950.175065-3-Jonathan.Cameron@huawei.com>
References: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
 <20250820102950.175065-3-Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v3 2/8] memregion: Support fine grained invalidate by
 cpu_cache_invalidate_memregion()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::28) To SA3PR11MB8118.namprd11.prod.outlook.com
 (2603:10b6:806:2f1::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR11MB8118:EE_|CH3PR11MB8343:EE_
X-MS-Office365-Filtering-Correlation-Id: 28812f89-57a1-4aa1-e53c-08ddef198b20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QmVlMUlNeVZLWGt2cVhBVWRUU3BuendRRHAwMmZIZndmZ2RqQ0RGTVhKRmIr?=
 =?utf-8?B?eWJMREpyanlHOGZWN3NGVGY3MXV3TXJ1b2R5WmxURThvZm9Tb2RBamtDU1Y3?=
 =?utf-8?B?dWhxdThxSzFiZTNSRjJVVjRUd21vRm0rc3F2djNTTVpPeitYSFV0OXZBRGJj?=
 =?utf-8?B?cCtnWU9zUU0xUWIxZ1Rzc1FrdXplU2p1MklXOUtLTCtoRWtKd3loMjdtYytU?=
 =?utf-8?B?bUVlNTc1QTVRRkk1R0ljY3crQXA1bkdrWTdJdEVRNncydjVaQ0NwWm5mZFZ2?=
 =?utf-8?B?bXZabGZISkdDMklvTUZoVnBLazNmYVgxejFDbWt0cnUzWFcwKzRLV3BuNVhF?=
 =?utf-8?B?Z2FDL0JFSDJvMGpYVStpQ01pdXVTeDVFZ0d3NG8xSmNiZDE3b0dxZWNJY0cx?=
 =?utf-8?B?WTIxSGtCODVOcC9oR1BpWTNKcklOVHpYTFFrelp5ek9NUXBldHZIWS9hMThz?=
 =?utf-8?B?Z0JGVFBRYk5ZSk9tc1JvK2dOYlBCVEEwak1PbURqMWVjak92Ym9qKzJyS3R0?=
 =?utf-8?B?Z0FiQXN1TVdaNUdBTklyY2FhZlN1VHlscVpQMkhUblZzeXo4UUZCWjdzaHhQ?=
 =?utf-8?B?VXRxM1p3TkhGbVB6WGZIU3NFTE9wOW9tTWNRYUQzelVEZ2ROVmVwb2xoQ2R5?=
 =?utf-8?B?c0xubEN1T2lGNEJEcDRxNld1WHhkUW9HM3FsejdKazBCaElxMlh0eGFoL2M5?=
 =?utf-8?B?T0RtRmlSZGhkcFhIeTJwai9xZDE5T3JLMVR2SjZsNTRERWkxcUNZTlRPcVc0?=
 =?utf-8?B?eDJidnNyUkFYOU9mQm9SaFJ0KzZaYzRwRk1WeWtxY0h2WkNleHBlQ1FHRktV?=
 =?utf-8?B?dURMWjJQeU03bUkydHdpSDZBU01Fa0c0Zm81bTFEUUZaYVdKbC9CbFNFM3Zt?=
 =?utf-8?B?eTRLOTgzZ0o4SXd5OFR5dk14eFlqRG1vQlMwL1IrejJTYlR4V2hDbmxTanMx?=
 =?utf-8?B?VTNLc1ltdDlPY3BZZU15RFdDL2ZlZ2tWRG9adTdtL1lXSDVqNEhpOHBHQzF1?=
 =?utf-8?B?TjB6UlljdFhMZXhITFRKYklnLzByWVdvRUIvODhHVC9SRkR2VnF1L1cvQjd1?=
 =?utf-8?B?VEtxNUhjS29TeXlTYVNQMVhxVmVocllDQkZqanBZVkR5UlFieDB0eUNFVlkr?=
 =?utf-8?B?Zzk0M1ZkZ3NWUkFncW1LY3R2R2JiNjFtc0NqSC9xQm5sRW5SL2xla0Z3Slpo?=
 =?utf-8?B?MkdCakRoWE5HODhyalNQbWVEYnZtSk9xaEN2aktwWFEycXZNVmY2dU1CNmJn?=
 =?utf-8?B?TkdoMGhYUTB3aXpGaTVyNllZNW16TFlHRHdZeC9DakNBOEZPWk1hZ2xNQWEy?=
 =?utf-8?B?cDhLWHRUc3p1SitYT3AwR1dLcmhxSCtIa3ZmWTlLN0xKcHNsM3RjWlFRVWNw?=
 =?utf-8?B?L0lsYU00Rzl0Ry8vL3hXMWhreTV2eHFhc0lhTFZvTzJQWXdNZmFQTHNxK0Nm?=
 =?utf-8?B?dVd2SEJRd0NHYXQyRTRjQzAydWlGQzJVNDM2Tlp2QWFFc2x4NDVDNlhKWGZJ?=
 =?utf-8?B?Zmcrb1FZd1hqUnlxekxrSlJsdXJsOVp3cnFWV0xqTkJUK3N4bDE5eDNHR1I2?=
 =?utf-8?B?cWxyWHNhRmV2QnJJYzlIckJBWlJRdzNlTUpaZEpCV2xncXJqeE0xNStNeFJS?=
 =?utf-8?B?cUhPZW1DMmRMY0VQR1N5NnZyRVVaODc0U1FkMVNXaHN2djB4ZnVvRzlLUUU4?=
 =?utf-8?B?S3hSSmUxUHFwOUVrdGtOd2djREVnTDJEK3hmcDB5L2xWZGFrWTJLaEkxaXR0?=
 =?utf-8?B?KzV4Rkt5QVZDRnY1V2U3dGppTG15ZitrNlhidnFwQUhJUUZGZGJXMmxaYjhp?=
 =?utf-8?B?bk1oejZ4cTRBRjVpTVljSkNxZFhweXV2N3RIcmhmUXVXazA2OHRzaVBrRnVE?=
 =?utf-8?B?akxYN0U2UERSL1d0ZkNhTjNhby9BV3Uvc2dsLzR2WnIxN2FwWWdPWWJMcStz?=
 =?utf-8?B?M09xRTVkaEh1dmNUbHJVNW51WW5VSHhKZGtkR1FheC9hSU5XMkxJR015U2h5?=
 =?utf-8?B?bTA4UlNYc0pBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8118.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3RGNjNVbE01TnMzZ2hUVmNmV2MrT0NHUE1LVDV6RmRxTmk5Z3laMWMvN2Y0?=
 =?utf-8?B?eU93d0NxRjdYczRRUW1FQzdSZC9WemVVU3NUd2NnTDl5OG5iayt3Qm5qbUgx?=
 =?utf-8?B?YjRqUTRqaUZWUlQ0eGNzcWFnLzV5Ym5vajArekNkcW00d0hhQlk2S1Nxbjh5?=
 =?utf-8?B?ZmFnNjU5NGwreGNlaVBiRUZVeG1WVXJ2YTZjOG5UZGc4WkFnaGcrQ2ZQdGJw?=
 =?utf-8?B?aHNJZHdhbk1MdWFiSFhHSlQ4SUR6aTVVUGhGc2VVdGhzZVl0QllWd0RlUUc4?=
 =?utf-8?B?MExlNkQwUU96VHJxZVBqL2tyZU9PVTJMMW1QK2dpcjN5T0kxQmdBamMzUW1s?=
 =?utf-8?B?V1dzRXFHRllGRTQzclk0NElPdXZSNWl6OWVMbUI0dkxpQWJTSmJNc1NsRnd1?=
 =?utf-8?B?cmUxQU5iSWlHRWFVTU1COTlnY3N4OUZnSW1ZbUE4OXdpTEE4QU1CaEFxWUZj?=
 =?utf-8?B?K2tFMXJUeEVIWkxGTlN3TUdxVk5WWnJ2VnNoUW5qdlk3bkJVQndkWm1jRlM1?=
 =?utf-8?B?YTh3RUlkZkluLytTd3lrQXpvNnhnOEM4Wksrc3A3OElTOThoQWZna2svT1ZG?=
 =?utf-8?B?N1RnZTlHdVhHUm12L3k2WVdUQkN5VVRzTC9uRFdER0dJRmRoaGtqTkZ5a2VD?=
 =?utf-8?B?dHF4aTd5aDQ4SkR1THQ4blNRWWhRdGVoOTdFU0tudkVZa2NtTFNyOTdwWmNt?=
 =?utf-8?B?SHRHaTVCN0w5dlQrYVlxV01RV1hGWXQ3eUtyWVBhNHZEV3BRRXZtY1dpdFNC?=
 =?utf-8?B?YkJaZ3lKdVZCYjNsVEVrY2RtR1R3dHhTYStJbE1YVU9NS1RoMTlGM0Zyb2tY?=
 =?utf-8?B?WWp3eFArenV0TlM4eDllemg1TGdRa2FFU21BRXlwYkE3a0hLNlprc3NQNE10?=
 =?utf-8?B?KzczeGh1Q0xxeTRKTUh4SnFGVlBIMCtkS3lkM2c3cEQ3cXlPc0s0ZlJGeWRv?=
 =?utf-8?B?T1BIV2Y5VWVXV0cxSmExa2VmbmVycWQwU21zaHVqT04yUFJpeWdBZHBRSi9U?=
 =?utf-8?B?clYxRVZtenoreVdWZnhxM3ZQOHBIMjRKK1c5WlZPMDJMd0QrZEFvb25rVXlL?=
 =?utf-8?B?L1FIS1JFeUhDeWRETU1NMG9acGNERDlpQ2NLYk82NFN0bW94OW5iZTJqNlZ4?=
 =?utf-8?B?NkNSLzFNTms4dDVyQm5XNXp3cVZMSXUwYXQyUDY1UUIvRzR3SDQ5MkRWOFI5?=
 =?utf-8?B?REFQM2JXeFFoMVlSWVFOTlphMnhlN01STGJkTjBVeTB3QmJ0dFVWemFNM0Zi?=
 =?utf-8?B?OTltdEZDUXR4Z3hHUEpRZ1VENzgzUURtViswTHZZSEFXNnpYMVd0T3lFSUht?=
 =?utf-8?B?cjh3SmpWckczME5lbTFUR0daK1E5d2h0d2hXN0NtRWFKZHhhS1MzVTVGSisw?=
 =?utf-8?B?a2FQVm1Ia1pEU3dsOWc0emd4bU1MZC93NWxDcy9BS3pIWjhieUFydDhmY3BH?=
 =?utf-8?B?Y2QzS0JvVFBXblQzVGxrSmRSVFFyS2s4a2hVbitBT1MreEdSdWluQjZXaG9W?=
 =?utf-8?B?eGJNWHRHa1BmVm1TSkpKZGp5d1N2Q3RWWldKK244M21GMnFWQ2ZsMld1ZEth?=
 =?utf-8?B?MmtYQXpHOGFHbnhjd0lYaTkrWU8vSkhVbWl6bjlRbnY0MGFnTUFmNEd2UDFI?=
 =?utf-8?B?eEh0R0RsblQwTTFIdm1hektXRHp2R1pkZW95OFUvWEJvNFdKcnE5TVVwUHhl?=
 =?utf-8?B?ekRnY3VubXZXYlN5OG45aHVXaFBhT0xqNkFkbloxMFBnTkFDRnpuYVowdVJR?=
 =?utf-8?B?QVcwNE1PYXlUY0lMUmUvZUJzaURVQVpVa0N3REtQT2JON0VYSVVQL3hXeWQ3?=
 =?utf-8?B?SmI4L0IvWmgvYUJQcE42NG9Gdjc3Qm5MNWF6dkhuRmV0RjM3MVo2a0VUM1NK?=
 =?utf-8?B?UmdDb2Fab0FQaUZrZXRENU50dHBiKytGWTA4MCsvNmpsdUFBbXNNSVNsdHVF?=
 =?utf-8?B?ZHdhQW15V0FVQUwrTXgvSy8rNXRqYVNwRm1LYkF5K3crMTFJN2JaVTRPaEYv?=
 =?utf-8?B?YnJOTHVFNW5sdHRuYTM3YThYT1hMQXZkd2FuQUhZK0grUkZ0LzhYQkErbi9N?=
 =?utf-8?B?SmVkV3I5STF2SlU2R1FIbWFmT0VBTnJNZ2Y1OWRDUWg4M0pPc1RuQ293Z0NS?=
 =?utf-8?B?VzNzSFUvOTUvNFQwcWFtclpKYmVLVCtXd2taUU1tYnMrbkxLRUVuNkVERDMw?=
 =?utf-8?B?QUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 28812f89-57a1-4aa1-e53c-08ddef198b20
X-MS-Exchange-CrossTenant-AuthSource: SA3PR11MB8118.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 20:51:54.6261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O9HYleidMJk/KKLg0UaQ7A+XTgV9a54bAaXNjaqEmB71N0X3hw7s3u+dsra2Tb8j9KvUweXEo3KG0ueZYNld9Gwk+w7uLXpK/8Vmr6NZIPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8343
X-OriginatorOrg: intel.com
X-Stat-Signature: eost7xtjdh1pkbn6eoiet3recupsxio3
X-Rspam-User: 
X-Rspamd-Queue-Id: C5B33140012
X-Rspamd-Server: rspam10
X-HE-Tag: 1757364720-262358
X-HE-Meta: U2FsdGVkX19VzuXmfsUHhLqOd0rjZK9EojyRSXik6jhswH15Czxh+UjmrSobUDCwkqfhl8ViT66UXd3KIs/jwF5YvTJ/WpZTjSJkQ3e4+JtWbnZoW36dBtLFNRRTJlQSaMIl+8asrr4H5D8D55DmKP7Q7LKP79fk9aF4zvECRkXna2ts47LZCwW21p6EPwndSWQtqHuCxSPIfgN6VfoD9Q1WiiGtj6g/i0CxTBMDnShlob5iAhQW8CKiXACcA237SmoaLJTGrbna/zoTIV0Mguo0cMbb+iFD5zbhCrKSDnxJvWBTllAfyCWj2NQDV9VrtTcvROgPl725bHPQd8gq+ZeZ9wQ6qCR43jfSb7WymV5uv3TmXmEAeFq4ocx5RRlsocgNfpX+yv+kyUU5VN+Q2NpEuDtL1l5MKakdXIMhEPBKheK1y6U84++GCUoHlbMqaj7Mbng2wCtSZOLyRDMMV+HjX5Iz6/GXthSxJp9MACn8CU7XZdJ1t9nhBs0+D8OKRNjtQw9gyAsQk3e9wVI+unRjWdXhquFRYBz8tSyWw90DS/gHEACS55qkBEvjno2qpDY6Tszr0DeKlLOWiejBLFEfEt30KrNNzOnKUGovVuQh6Ew/HQ54gDuqosfbsK4A8zgMDAX45MWyKWv8fVap6UAvoD3R57e/5aaLuv0ZTkA5lGhUGuLIMV27/yeHWrJjTGtsBKJPx9NErthP9s9DszGavyLQm713wa79dUFapSCpfPYjFZe23QgYt1ffN2QNECf7ATty6HMDaSdXO6TttyDGDqrZocinOKPcSMSLzt1g4PDwlbuu8xg/3JIFJn+Rk5Htd5ln+w7F6OBLbFhs/pEjFynbS96lR65Pvh7EmBFmhSzMRc9+g8mhvM/0a+OuJNjGdGGd60Q73JJaLvx7Ez4FRfveU0DUSH0dkolDwS3xiHmD5hpKI7NCwQJf4XyURmVBhG98xMWYfdJoEVW
 eMABl8RK
 GL8xEK/b8v25mlxsA7Wzi35NLPso2FEWpGY6O9hAYMlBHEPwHdV/LcF0It2HrY3iWdgnZ/YwDigQwdYmhJqSn4Ez3Sa6O77gXIz2LvzA9lQ+VJsSg5GgecZq3yk5qcKQny2j1fKLkmi6+u2bxjUR4ec8Af4U0/9PiWccZq0Ra+t7wPt9a0eGM2jw1fD0BVFLN/jILyzseHgyBElljZ2uwLMxbx3Gvr+O2FcYhzM4yqRr39u5fcbJfZhJcgGUSNl8r8p2tdeKBUxc8ZGhA/OdgktuHymCo2y4Ngkwn4YMNMXAdprcytRF3d9g/aCbOnVISGEL34oWxSkHzYAI1xaIJqt8kCfSKQxouX1sqjVCiXwQJOi8B3tgSgBStZteosJ0Fy/rEjwX/tx7HzlU2Q+0mbgpx6/c4gYjLhQA90JCOJldLPeoaNtwA5a0IhHQxnDdnIRsvtVLjaD/Ip0YTGqMTT4I9TiwyWBFpk69kebqBHicYcVNSumpxDA9o91mO+elnkiHxR3Or2RqeJum/EWbzT6RIKjjfPM/E61GEDmiqjq4kTOdo9bMrMA0phdNb7WStjorg13WSoX/ABzEsyRG6u3qL0/ggYcOnoYVB2MlYyZTDMIbs+AYavLtJ6zszzZqbkqVKD7C2AKb6vwXik8vrqD3kQkQ0JuvogcwDRMvwiyj4R56F8otu2JoEX4MWKH7br5AHpMBPo9PU0HaZqEhkNFdLX2oLVfluwTz5uAFLECmferw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jonathan Cameron wrote:
> From: Yicong Yang <yangyicong@hisilicon.com>
> 
> Extend cpu_cache_invalidate_memregion() to support invalidate certain range
> of memory by introducing start and length parameters. Control of types of
> invalidation is left for when usecases turn up. For now everything is
> Clean and Invalidate.
> 
> Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
> Acked-by: Davidlohr Bueso <dave@stgolabs.net>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

I think it might be useful to have a cpu_cache_invalidate_all() helper to
replace the open coded:

    cpu_cache_invalidate_memregion(0, -1);

...just to document the places that do not know a range to flush. Not
critical though so if you spin to add that, great, if not, ok.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

