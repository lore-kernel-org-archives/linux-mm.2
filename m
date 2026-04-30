Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A116DCD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 130E16B008A; Thu, 30 Apr 2026 12:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108396B008C; Thu, 30 Apr 2026 12:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F128C6B0092; Thu, 30 Apr 2026 12:51:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9DE16B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:51:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E40121A139B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:35:02 +0000 (UTC)
X-FDA: 84715771644.12.D3C90AD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3E6F1C0009
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:34:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hYJgxP6Y;
	spf=pass (imf28.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777566899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kn3Scrl+PacS9XHf2sWlX+FDuQ+qOmuEkHPsVRRxv1E=;
	b=z/Wi3O9SP7LZQDEYRnXdRrTZ7UIjqNUqxrmVh4hpXDE5+2hRFX/3FNjaDhq+r7v/gSJddZ
	WDIoAn6Nkvh8hcdTMWTeECTEsx58Hxad1Si+4oF439pB+R0bc6fozYL9i+ctxwIAHeWyMZ
	6koOypMgn3QeFrHMbgpxM5diB+XOOCI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777566899; a=rsa-sha256;
	cv=fail;
	b=wDbP8IO8b7OT62vh29asfpg5DC+LDWn/o0jnY54lzZ0ZnLvZ5S80jj7/kn1atzj5lGosSW
	IPehIh/eJ2371eaDVYYaznUCYgyDbkUYmwSxTfHOqv1HsGS607ljOFZQimhxS9hf5FRNK/
	ROwGO1eG/JJ/0K06s3mmSlK0EemkNPI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hYJgxP6Y;
	spf=pass (imf28.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777566900; x=1809102900;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=jZtjHD0XzFJqGTYbOFut9phtl3pEfg8P5Izb2T8vZQE=;
  b=hYJgxP6YMptWYavcB2vYjBaZMMMGSoXHYgVDJP6r47Evqr8r3MWuLRxh
   6nm9IqVikaoEzbMLjq5Tr+4xeo/gwq9BDLsWBJ9XvmxQJmYIh3eGWqnze
   AXyS6Vfwo2pHfmz89PcN5fBwWzzRyXKr3LDAaWiE51uRyOXzfanzNwU5W
   88AfSy+gLBFkRVvgYbQ3/FyRttNEk8nI4oiB8qPIfyDBY4JRs+7UnT4ph
   eIsyuOjb5msqHUJjal68ncbmwnELu+JOFzi1Ri89emgqM3GZ0VpqbC52o
   kJpsoPiqlOl6DCptZG+NJ0AXoPwYdaaSxytFmyumCBixGSvdYsEpc6NUN
   Q==;
X-CSE-ConnectionGUID: 4JDxZkVNQ36gEe8l9CWKiA==
X-CSE-MsgGUID: wCmAe5W0SMmK/aia85TUrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="103978856"
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="103978856"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 09:34:58 -0700
X-CSE-ConnectionGUID: jWiayGrdToOsVxZMludnbg==
X-CSE-MsgGUID: mLPOG5K7TRetAh5vgi/JSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="231982318"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 09:34:57 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 30 Apr 2026 09:34:57 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 30 Apr 2026 09:34:57 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.20) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 30 Apr 2026 09:34:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FZY3GsZRrercAMqkdIEm/5dvjhGziZkWLhZGL75D6iqIUt57K/0coMKBXJjIJleyYIlveZgfyc/Ls/Jg+hX4KBF9OJQIBhfbwJbxxflY2ppIYzbtpxbTSKGdutUa3pUgOBJC1jhwYhh+Mdphv6oo5W1BLkA3S6wfkPDKuNkFdmtAHR+zrtnP3G6WvTeOrHG7kDo2EtOXetYMxqwG97odTXApIrtFdMucyZQGKuCMvq23WrABsGV1BpSdpJexUrj4XLrZD0HTlw48XgjrIXfSCv407O1sdgz2WRvcTg1hKKO76NYgqom8kvfucTU4Vg8IjYtlWDw/uiSutbhx7koe8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kn3Scrl+PacS9XHf2sWlX+FDuQ+qOmuEkHPsVRRxv1E=;
 b=Pwe20fKDfokMbOsb+3BmgRMFo8h5jEtgOIjeDKsFgspxtORJgGF127FN2WCkQL6qr7gTKvvh3Nmk7Jku7R3PGoSXjswvG8vmcFfnTZoJ/C5/sWSiIiPssdz7dPSi0tuRf/07O/vYU5iV38eOwd3YBpsyt5NJfm2wOGY2xt1d6/IEvy66TQOtYvEdkmOWgR//uHqmKFftadwUiSkX9hXaA2xtzO30ZFxhgGI6wYBDlu74f4s8yBRu9OkrCK5ViPrizDZ95d/1GkuWK1y85Lqc8lKB0aPmRJBKIEsneqoRmGDcEvEXiu2bnjZ0iYNHZ3Tdet+RRqtbcThJVLUBY4yHpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL3PR11MB6508.namprd11.prod.outlook.com (2603:10b6:208:38f::5)
 by CH3PR11MB8188.namprd11.prod.outlook.com (2603:10b6:610:15e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Thu, 30 Apr
 2026 16:34:54 +0000
Received: from BL3PR11MB6508.namprd11.prod.outlook.com
 ([fe80::53c9:f6c2:ffa5:3cb5]) by BL3PR11MB6508.namprd11.prod.outlook.com
 ([fe80::53c9:f6c2:ffa5:3cb5%7]) with mapi id 15.20.9870.020; Thu, 30 Apr 2026
 16:34:53 +0000
Date: Thu, 30 Apr 2026 09:34:48 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
CC: "David Hildenbrand (Arm)" <david@kernel.org>,
	<intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam
 R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 1/5] mm: Introduce zone_appears_fragmented()
Message-ID: <afOEqOZVWi/cNf9g@gsse-cloud1.jf.intel.com>
References: <20260423055656.1696379-1-matthew.brost@intel.com>
 <20260423055656.1696379-2-matthew.brost@intel.com>
 <76191a17-18bf-4e9b-9ab5-dc9a48abfabb@kernel.org>
 <be42059924cde9bb16a087ee2a5abb0b9d850d68.camel@linux.intel.com>
 <aepuNL2fwp47P1Wi@gsse-cloud1.jf.intel.com>
 <aeqbe/9YRKNyYuWY@gsse-cloud1.jf.intel.com>
 <291406b26b8badf2e565996515931d9ebe50208f.camel@linux.intel.com>
 <a1252167-63a1-481b-9f1d-2a7bae7a3b6c@kernel.org>
 <afLCwHaPZMu/dxqY@gsse-cloud1.jf.intel.com>
 <f4324084f3808b9a42b87ec27bef7fe920dde9ea.camel@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f4324084f3808b9a42b87ec27bef7fe920dde9ea.camel@linux.intel.com>
X-ClientProxiedBy: SJ0PR05CA0189.namprd05.prod.outlook.com
 (2603:10b6:a03:330::14) To BL3PR11MB6508.namprd11.prod.outlook.com
 (2603:10b6:208:38f::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR11MB6508:EE_|CH3PR11MB8188:EE_
X-MS-Office365-Filtering-Correlation-Id: 41fb0466-8f2d-4a48-12c5-08dea6d667c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: VL5JMkEfQ4TbmbUvYa5E7usklSdo8CibYFXQmk979Cf23eCSYYVbHuPSCvvbVtV4JviD9Bc9PMgKCO60UJ0Woxj54Fh1B2/TLQRoVorGTo1vwhyUG853IBrHfbH4+E7q5r/muCSyVvL6f0biS21y3m9d8+1IHTF3b21v2dbjsLCiCpt3oHSMvnbgo+lRVBplgJMXUFzJkSK1i2sNtJ4Kn1Gn7mTw74Uc4QhwY47e9id27HWsxSRwIcWD78WTf2e6D90FYz9YfZ/dyMVfWvL7QThewiGvKzfTHIEyGi+dVNAyXbU9/3McqkRrpAX6DgtGipIgsNoP7vx9AU0PseIlzm5XOGsUSsGKl4OIQAynfu71Kdb7H1RUxrvDWOHLXeEBN8CwW4NAz5q+bN+B3bZcBLfVrZ1Um7aFTFcvJeAhLfZ4sisuTj+Rg5+wxXGkDjM0zdWgflrN2y6Ky/krb/uh4gb2lWx9Q+mGbcOR7vKNTFqRxgZMvGS+PGtsOEov8sJJd4JRCMtemucc/IYQnAvNS3Bq2fS0ulS2idkwBMHiyU8tEp2RoeV1KcpVjPfbC3DozXsmh8s2T6oDkHpAwTMRzItsbSBSotM+nmR5spaJLOLxMlRX/UZYjOHTHDPba9JmUcaBsvD3w45LuBjZaAENL2kvZvtwGPdXMsSPRj+V0a4Z+4W7YjWkUXEjUqibRUN+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR11MB6508.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEQ2TGh3RWdFeW9ZNGJpSys3TXhHNjZZWTFIS0V6MFplaEs1Wk9SSDkrVTJj?=
 =?utf-8?B?Sm5wUmdSWXRRdFY3K3VaV0J6NVBBV3JuRkE1bjJLSVRWemxYUE8rU1dvVW50?=
 =?utf-8?B?T20vbmo0KzUycDEzU212UHFlem9JTkUrZUdRZkpHT2JYWDMxeCtyTVNGeGpC?=
 =?utf-8?B?azlJL3ZCYnQxWUtyOUtuQU8vbDJiaEt5dHpnQmJETnExdVpxdU95a25yMzZX?=
 =?utf-8?B?R2hkbEZJWDc3VVl1OTdjd0gwMUFwaVVXY3lRWlFXcmVwMHd4citTakc4b3Ix?=
 =?utf-8?B?aDNLTkxjbHAvbC80TGZLTVpSSHFUb3lGcE1pcDdSelozbTVzRVR2ZGNLOU5B?=
 =?utf-8?B?c013MG1qNUNKMTIvRTRIT0I1Q2I0aExhYzgxZWxTVU0yN2dBOVlONkdpKzg4?=
 =?utf-8?B?SnFvUzV0NU82LzlMWW1ldnJvejQ1S3FiZzJ2UjBTUU9qenJDVzhMVG9qMWRh?=
 =?utf-8?B?L0gya2Z5Z1M4Q1M1d1piTDk4am9xbDlqVlNObDhrRktWOE43Q0p3MitnQ3h0?=
 =?utf-8?B?K1hLbDNmT3NxT3BDR1lIc29VNkh0YmxGUU9uNnI4U29MS0VUMC9KNXYrMGw5?=
 =?utf-8?B?TGdiSnlaVFgwMFNmNmxZNHR4R3ZiRFE4bFVmdWZIcU9BeDdsbVpwazZXWCtU?=
 =?utf-8?B?KzRTaVE2WCs2bXZYYy81dXk1Y2FCeEduQzViZWNuU0VlV0NSSmMzM0VkYm5X?=
 =?utf-8?B?QjUreStSd1Vhc29YcXBqNnZIQ2FLTjgvMFZGMytFcE01c0RLaFRtZXY0SDYz?=
 =?utf-8?B?MG0wbzQ2NHRRQzk2QTJIK09SSkg1MXVzU1JBWHR2UzlacHBqQk1oZGlCMml6?=
 =?utf-8?B?Q29BTkZtcU5HcTVIbWtETUgxZ1Q0U3l5YUtIVlpGa2VEaTNVT3kyOXpzQjI3?=
 =?utf-8?B?MWxPYWVlVk5JbnFnZi9TdE5ueHB1SDJ5SE0xRG8yQk9HMzkxc2lCeXh1TXNm?=
 =?utf-8?B?SUIzcm41ZDMxUE5jZ2JjZXB3OVBsMGZ4K0FhZTgvMkl6dUEvdW4zTkFhdDNu?=
 =?utf-8?B?U1p5MVU1b1Fac1FQY0xuckxYaGZFNlIyRzRDdGxyUGZxUWxoaUoyRXhXd1JN?=
 =?utf-8?B?Y1pXMlRaZVYzbzlNV1Awd2JTQng1TDh1ZFI0NU5Sdlp3d2xGVHdWeDJvTVR4?=
 =?utf-8?B?dHZuVE4xcGgwSjlQTmpkQzFnNktMZ1FMaVJmRE5KZzlBUE9xSExTOHFKUnlP?=
 =?utf-8?B?TTdwc05idGlSMnZES05EUERPRVVzdDRES1VTei9mcDRidEI2eExtWU4yU1RY?=
 =?utf-8?B?RTBjaTJsa01YOGV0YjZGME5odysvdzJjRHNFRjB2dmVYL2NnRGJaNDBtUndQ?=
 =?utf-8?B?NmtNRUpiSWxWTnBZZXc1NXYrcmlTamFSYkx6ZGQ3MFpZRDlUak9ublBBS25F?=
 =?utf-8?B?OTBCQ0NiSHpaaHpEOThBNzkvYVllMGV1Z1I4dWJtQWVpMXE3Q29FUE9qNmIw?=
 =?utf-8?B?d204TXlWUzFYNUlrNGNoSy9SYU0veDBQaWJjcmlmN2tBK1pHTTdiaitFNXd3?=
 =?utf-8?B?WU5YZE5ZU2wwUlRFOUI2Nlp6aTdpdjE4UDlIWS9nRHhwQ2x5dU93SzY2QU82?=
 =?utf-8?B?M3dBU25iSmNXd0tFNjZEYzlnMnlBbG1xbWphODdQSjIrMEVvWGRIcWVYSFRl?=
 =?utf-8?B?ZjhiQkhNVVprQUR5ZmRiWkVoT1d0dUk0cER0RG1tbDZxSFlCbjFQSFllZGZ3?=
 =?utf-8?B?aW9JMktOWm56ak55NVEvb0ZLZ3RFVzlWc3RvZS9zR1k0ZUdnUUdEb3h4M1VV?=
 =?utf-8?B?bGg1dTdpaDlpNEtPdFl6UnE0cXVjRW9mOHlnclFlZ082OXJIRUNwWGFaMkhQ?=
 =?utf-8?B?c3YyWTRtQWR6a0JiZHpqNjRFbFVBeHZMUXM5MGs0Qmd0TU10V1NqYlFkMlZh?=
 =?utf-8?B?N0g0NnRRbTlTaENWMFFpSEFtZ2pUSExvNlNxdVp4WGk3ekhPamRrQ0hrTVNH?=
 =?utf-8?B?S3Fka2NOMnlzWERrRjI3N3J2M0Y4M1JvazRKODNXK3ViUFNab1lhbTdMeDcy?=
 =?utf-8?B?NUNiYldTRGx2VjluamdiVDFHQWh4TUFZSEpTQmRCOFhVdktQK1ZTRlRxRzlE?=
 =?utf-8?B?RnlpWjhBc09xRURiRHl0UzNveWRrZTlMeVhhTUN3S293M00vYzVlUHNQTXBr?=
 =?utf-8?B?ME9iNlp4dTFxRlRkZHZmNDkrMXIrZXpTRFlBM3U4S3VpamY2T2ZEV01wMDk1?=
 =?utf-8?B?S0d5KzQzbUdaWXZYUUFIeDAzRGFVWGpvbTlzZmJMbVB3ckdLYlB1em1NbmpV?=
 =?utf-8?B?VW1RU2pEZFVTVk5SRXd2ekl3K2tNd1Rkci8vY3pqQ2dnM2lncCswalQyNWVt?=
 =?utf-8?B?ZFUzQWhmS2lMMnFqR3RsbEtab3BXNzlub0dnNE9paHFraEttS2IyaEJJblVF?=
 =?utf-8?Q?bgHy8oeGx5pJeAfU=3D?=
X-Exchange-RoutingPolicyChecked: BLH+894pHTb9nlkTVzD/2Difyt0i16zM0KUhnVZBMpCbY8FOXm++7ksUffBqnHvdaXPJShfdrGJQzYWZCO0VwQ0Wy8t892A9XsCXFCU6uSaCAJ/8npmvNaCqXOOnLmLVfc06AOReEn27v1KIzsHub1OerG39v8L/iykeJA2JU8BVj0zD4tYlt/ynb9V+yBSUZmlyfArySucFSPRDIKhQaQ6nqL/slKH8pNSRDoLDp860z+nbWKcWKBOP0HzXNnNR9YeowM5YgrVTodDOibg/gjlN6uCGVCKriOqKw6CKXA2SVBHC2g7blUSXMw6IZs6wV0+ExyB9u5SaXph7vOtbpQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 41fb0466-8f2d-4a48-12c5-08dea6d667c5
X-MS-Exchange-CrossTenant-AuthSource: BL3PR11MB6508.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 16:34:53.1069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5s21dLUkzM8/HV8jrGSWCLJaBnrzjuwL83v/DbX/zpWEJLk9GiKUAYrkkWgeI25IUxvC7Dj3MCsPgQQuf01rGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8188
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3E6F1C0009
X-Rspam-User: 
X-Stat-Signature: jp47smznt1dh6gbquuz9taado3i4gq75
X-HE-Tag: 1777566899-586651
X-HE-Meta: U2FsdGVkX1/YWgEExd5RHdlwjIjyWjytDD8fJxkpo1b7XNZcTdCXnzqzhcqIL8cDqtDs/MYFg9dDJkzHtoz/i5ARCkiiP9rJJpG6vS9YMji2DDJIn4w/3C5dUc5ooHk3W3BaK5OA4Ynf0Qvx+bphAdKUVBnTs2G2DZt4/2aixxSdvQgcP+eYqfO0omJv5rFzE6dRYNm1Po0wfEsjBqsxubwxWWz2azxsstE+u4VIbnaMN23Q/zR42SpI4BBFem/3mF6w53u5onLVsmJN//z1p5uqFl8HDUHvkv81p4aPz0Tle3ZcnftjkHdw3jBJz4LOBgp+uhs7GOJjeFba8w1YqzfQ8OJuHOeOs6eOw2pZQY5/fdUVF/VOysvkaBHE3HNLIWXMuOdzUe2Lnp595CQBmmnRHoXX8gFIF+PX/1WMnTLt+CytBOLyqdWDmUxQe2GffyjdxtNIDS2jIPTvl6yFIkcurFRyf/kB9mB0DV1mXGTW+7Ok76GhHutkHnQtrtAsSrt7tL1iOwd8+asxiY0/0tTqgMPsMhHzGSwnrTQnAsel2eKG+Ohl93vgV1vM15+zVKmykvw/NBWHz64Z57WZ8lbD6ybtIJPEAN6wOk2aFgzyJ9oevkEapzBLgDYXriAjmeu/nkaFPtWSi05lgRghAC2GgT44RCZdJC4W9BzEkp+u9cL4XLfcO6yTREEwxhtr9gBi+bEp6nct5g80fdHhBcO1QbSpywjWDzbTfbMw3q3tsTdqa4BodWrbrPyWljHGjHSya/CHV0y+ipGkzcmA1Hahzh4eb0zIR8ITJU/3l6wT1nbEJKNrfVfmIREODsh0s6ghcit1rZtt+0lRigE0gckLoPYfzYbqD2ZtaeBT8MgeiwJoxYyiqkOCcdzxjcS0/n8JKf4pXGej+thup7DdGD09QT3eIy9cTjKbMQVNdB6p1uI0/AVGOn8PSCwkFo1B15mL7cYLE9sFBIQ+A6z
 vq2CsP1n
 4rwEsR2jijmKMZJFW6V6S0oue0+LHe9VmskjOOLOUVWkSu/Choj42q0j4Zy8R8XbkMtUxRICUO04lhiCLPWfUkoalx26aD5Va+aiZLzkN79VCE3zJY0hImig3aHRsXeSTvlVvboGr9ueYLUcrT8g6foz74ykwNLQZn+bS62ZoPM+1jDe1YgxsokAw9RHIw9qrdYtzPH1n2Aj3HsPgQH/jRPHu2rMymGilk+ZW67S6cfVVJ825cGPh3iJgnZoqYMr9Y770hnkp1F6heKW9XvM+ntfFxL+1DeB4YCzcIZT056AfneDWQI1L+NZhHZL25NqIJOsFONwWZ78WiD1JsTxcz2GLPQYy4uwl6GIGXyWKlc5f2OBflj+RvKNS5/DVA72FO85FGs5JdrIwO+e0c3yUNydD0UKbIHRgNEMAF4uFiucjtrJ5tCxNzkGYl1l/Kwb47pe/GmATIsNAOH52eDNEMgCNQl1gedi9YJNBkYtxQIsqNS7NfhhX2r37zEufVReX025hdt+scykvwI/RKIdO5EPJpj9nh906N46vv+sg1sBqz1OgQLw95TM7qZ5v9CNk1c+OxwOgmBbYN0EckkFwJ1nlWKbyecTwly8zj80JcACA8dM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 09:47:37AM +0200, Thomas Hellström wrote:
> On Wed, 2026-04-29 at 19:47 -0700, Matthew Brost wrote:
> > On Fri, Apr 24, 2026 at 09:26:18AM +0200, David Hildenbrand (Arm)
> > wrote:
> > > On 4/24/26 09:05, Thomas Hellström wrote:
> > > > On Thu, 2026-04-23 at 15:21 -0700, Matthew Brost wrote:
> > > > > On Thu, Apr 23, 2026 at 12:08:36PM -0700, Matthew Brost wrote:
> > > > > > 
> > > > > > If the order were included in shrink_control, there is about
> > > > > > a 95%
> > > > > > certain that this change would allow TTM / Xe to break the
> > > > > > problematic
> > > > > > kswapd feedback loop. This may also better express the intent
> > > > > > of
> > > > > > the
> > > > > > problem we are trying to fix here.
> > > > > > 
> > > > > > For reference, the cover letter [1] details the problem.
> > > > > > 
> > > > > > Any guidance from the core MM folks would be
> > > > > > appreciated—would
> > > > > > adding
> > > > > > the order to shrink_control be an acceptable solution?
> > > > > > 
> > > > > > Matt
> > > > > > 
> > > > > > [1] https://patchwork.freedesktop.org/series/165330/
> > > > > > 
> > > > > 
> > > > > It doesn't look like __GFP_NORETRY, __GFP_RETRY_MAYFAIL,
> > > > > __GFP_NOFAIL
> > > > > make it to the sc->gfp_mask flags from the caller and get into
> > > > > kswapd
> > > > > loop...
> > > > 
> > > > Perhaps that's because they mostly (only?) make sense from direct
> > > > reclaim? Looks like the trace is from kswapd.
> > > 
> > > kswap obtains the desired order through pgdat->kswapd_order, as a
> > > hint from
> > > allocation code (wakeup_kswapd). The order can be easily merged
> > > (just use the max)
> > > 
> > 
> > Yes.
> > 
> > My current thinking is wire the order into shrink_control as that is
> > quite straight forward + only call this helper + short circuit
> > shrinker
> > on higher orders.
> > 
> > > We do have the gfp_flags there, but merging them from different
> > > wakeups is a bit
> > > more tricky (and when to reset?).
> > > 
> > > Assume we have one urgent request for order-0 and one non-urgent
> > > (noretry,nofail, ...) request for order-9, we'd have to figure out
> > > a way how to
> > > represent that. Gets more complicated for more orders.
> > > 
> > > Of course, we could have some kind of array, and try to store some
> > > "priority"
> > > per order. But I assume plumbing that into the rest of kswapd might
> > > not be that
> > > easy.
> > 
> > Yes, this seems non-trivial. I was also on a call with Google today
> > discussing what Android (client Linux) would like from shrinking, and
> > my
> > initial feeling is that we will need to do some surgery to the
> > shrinker
> > core and GPU shrinkers to make all of this work well over the next
> > year
> > or so.
> > 
> > So again, I think starting with wiring order into shrink_control and
> > this helper is a good place to start, as it fixes an immediate issue.
> > 
> > Let me know if that seems like a reasonable direction.
> 
> +1 for wiring order into shrink_control, and possibly also the priority
> as mentioned in an earlier email.
> 

Let me look at how priority field is used as well.

> However for cgroups-aware shrinkers, The number of free memory in a
> zone might not be an indication of fragmentation-triggered reclaim at
> all, it could be the result of the cgroup hitting its memory limits.
> 

I agree for cgroups what is in place here is not sufficent and based
Google's feedback of every user space in Andriod is assigned a cgroup so
we will quickly need a cgroup story.

> So I think if we can solve this with a combination of GFP flags,
> plumbed-through order and plumbed-through priority, that would be
> ideal.

That is an idea. The other thing that came up is TTM LRU doesn't
understand relavence of hotness compared to other shrinkers LRUs (e.g.,
core pages) so our TTM shrinker may be evicting hot GPU pages while cold
non-GPU pages could be evicted which would create less stress on the
system. Perhaps priority / GFP flags will help here?

Matt

> 
> Thanks,
> Thomas
> 
> > 
> > Matt
> > 
> > > 
> > > 
> > > -- 
> > > Cheers,
> > > 
> > > David

