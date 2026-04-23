Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EA54FDEE51
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 22:22:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 653036B0088; Thu, 23 Apr 2026 18:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62B076B008A; Thu, 23 Apr 2026 18:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A2F6B008C; Thu, 23 Apr 2026 18:22:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3E8646B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:22:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C6C421205C3
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:22:01 +0000 (UTC)
X-FDA: 84691244442.25.CF915B3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf20.hostedemail.com (Postfix) with ESMTP id 82A1B1C0006
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:21:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BIxvYpNf;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf20.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776982918; a=rsa-sha256;
	cv=fail;
	b=eyK9JGJZXvr2bACJ/AtuArMqRnUOHGKBnm3nnjQqzW39V/NvRmq7PVP7ykSZBOK9qal0Au
	sz3ZxURHHl6qpDsXYZLrJyuoTe77D00jmsuKqZCcsrZ4HrxJENOzbEnmh05gU4NZyAvNwY
	HqwmKpsYYIqTWDiTMGn6WMZgBApqdn8=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BIxvYpNf;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf20.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776982918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXls5ISlaFHTwZ6/O75+HnaB6ojcYdKIJwTAMQZ9xPA=;
	b=A1UvngHOMrWTdr6FSJu29qgEaFm0fmjqPZjj96+HjTby63TIZ3hPb3V2o+HTlgLva+9Z7n
	iwkIR3JFvkYyThjgJ72LLTU66c98xv69z5lBVaWF0O/mvSQvoaO8OatAWzuibuEBbeyhXM
	LQdvmVk6p34Hs5c2BXrxwCn7/RobRbI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776982917; x=1808518917;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=3LgQafyv2w6cmF7eS/YwFjaJ6HZffe4tqM1IVp6FXDQ=;
  b=BIxvYpNf3NpEGQQSycII0digvY/fgSYnyHm+kLgMMxYh9I0TmmFUoQms
   5A+ZtZxcr/fdzxt6WEK2aLevYic1+ay5L+agPzXDIDyK604skAknuZ/Qj
   puJdSmU6hqga0PdAQ1/Edu+V2mDsQFPYE0j0Pm16KwOUas4utGXtiwXY5
   DACfXNPG+WJxDBku/M6OHLUjJbDQF3hS6bwQm7koi61UaknCC7FumaIZ2
   6SK+ZEXJgDDLR2J7ws91FN//XNK1cayXiglExRqyCAD6+DyHfwoPdrfAf
   iEhka4+xB/EiG4qZdXHB0I1h4uo+NA3NrrYhWeel7H1mUac2Taczb6UQr
   A==;
X-CSE-ConnectionGUID: loFtzAXUQ1yEQNIZZc0ZGQ==
X-CSE-MsgGUID: 5GA/G899SIKOvVqfTRN7lw==
X-IronPort-AV: E=McAfee;i="6800,10657,11765"; a="77844543"
X-IronPort-AV: E=Sophos;i="6.23,195,1770624000"; 
   d="scan'208";a="77844543"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 15:21:55 -0700
X-CSE-ConnectionGUID: pusFl3ocT+yArLe43b1LtA==
X-CSE-MsgGUID: d2pUwjLORwKP5kvUqNGx9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,195,1770624000"; 
   d="scan'208";a="228219296"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 15:21:55 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 23 Apr 2026 15:21:54 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 23 Apr 2026 15:21:54 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.71) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 23 Apr 2026 15:21:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FDy/Est3FEdwNnT8oL0wXjnMsFbwKCDnsMjk+++OHgYa+TIotgfGc3B7v4loE2H2QVGz3lc0uWMmwEl/5+5ODzog2p9H46j1XHBHD4bvCOjQzsdTFkdvRQtmFsRmPV6YfSB9Pk/DslNhjEqskIL6U9WkLigPKeNQCUMeRogITg7X1kQLODGsYrjGDPzJFVTm8IzzRVkSXxL6qisYIHQPTd1hsXrK7NJQ622zAFsEA5pgBi6SjRhNLIa6b0WpJiXucYwSHUz5RowtoV8lfjMRSNhUBcobl//S5JFPkrlX78bsPUfz7PyWh7okoUgnYhSgfatKuMPuc0IB1dhlaDBnAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WXls5ISlaFHTwZ6/O75+HnaB6ojcYdKIJwTAMQZ9xPA=;
 b=jdGR724UeWh8k7eBoCeiaHH4M1Q6bBKMEGO3fNSSFweI8Ya2s/ul5fzA3JNtpNaHvWngTKaJv/RFZGFNFQ4asI4XA3ublV4bIzhPEvfhPXKMGk31LfOIZAN6W1iz08gnpdWU8NCbLPSBGbOnNYHck4xGQryTPkKbBS/y7j4qNBPN3OIfGS+leDefLz1eh+hSODXHbwvOWLBYVLHzkcVGIGfU5Ivr3234G+wDIeKqDUr26yaKvMZD3gjcrZvbQoZFES7CcUhfURdLrEXpSiuS5+AH6dVqd+pu+zcER9SBq7DYGrQBSGPgmC+zgkHFrIQJ+KBfwJLe1wNROyAMuPj33A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SJ5PPF5B09F0799.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::82c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.20; Thu, 23 Apr
 2026 22:21:52 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%7]) with mapi id 15.20.9846.021; Thu, 23 Apr 2026
 22:21:52 +0000
Date: Thu, 23 Apr 2026 15:21:47 -0700
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
Message-ID: <aeqbe/9YRKNyYuWY@gsse-cloud1.jf.intel.com>
References: <20260423055656.1696379-1-matthew.brost@intel.com>
 <20260423055656.1696379-2-matthew.brost@intel.com>
 <76191a17-18bf-4e9b-9ab5-dc9a48abfabb@kernel.org>
 <be42059924cde9bb16a087ee2a5abb0b9d850d68.camel@linux.intel.com>
 <aepuNL2fwp47P1Wi@gsse-cloud1.jf.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aepuNL2fwp47P1Wi@gsse-cloud1.jf.intel.com>
X-ClientProxiedBy: BY5PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::19) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SJ5PPF5B09F0799:EE_
X-MS-Office365-Filtering-Correlation-Id: 491f8d3f-8995-4bf2-a440-08dea186b7fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: 61BJTGOalWoCXf/2hXLSqYqI+LP7oQUwKAXkRa58ogJz1dMxYjldGkAJ9TnZ0VB4OppgYB0Uj+XR/Msx5az0EsDjyXJr2TuOls4LOA/PtlPYHzm31uVXlsW6obVt3jujzfYDGss1LOhhLEOYjC2aCFzsafsE8SosPFnPsBUYP3sNz/APXVTKlBD3FcvAFkwdtUUn5H9qLbWn+kJHJX2vshhjINr0+O1iHDETAMJxjYZmJwVABPfahtoN3jAgN+kitUS2BiLYLcbwGBNVl4y14k+IXlyA4DqxTcohqAsLPpMuFYj1yWB3CVLbRiIxbnb3dB/xQIQ6ovR6VCYxm4dmPVlDeib2sNH04/B8XYmoPRPVtotIg33gYH8s3WABURqnlifyqYENFGAvKwDqYuN6Nkr5yMPR2aFzKIjlc+VHUs4EfqHubfqILsvvgdKPAAZ0GHEKiTIMDYID01cbMtda8X4I6d9x0d4wZvu+X9Y2Q3+qvTTtw5cEcPDuljB+FjOFzFE+jEGm2a2Ls437gYkmUgUCHq6+n1M5ST65LK1InBB83p6YHsNdI0A6hcEJGaXV5shn2BpvenFalIw2lGWfkdxFW19KhZVUV+E23Oz9Yvo/EvLGXbYfrgkIHrBzhjLY91harvwcgy8v8T/XDQD291rfIp9PQ4aDDhnHs5iZ1AEGz7xVShjbfa5VhzXpx17J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzRPQmlpbjRTQStjUlFCZXgySEc0cTR5ZUxFd0tEa1FDK256Q1JqS1Z5QXN0?=
 =?utf-8?B?c2xEZHRMK3pYZnhQL0ErcmNiSm9FRGVrZUR2WXVoVEUyaWQ3dndNV2NjbTM0?=
 =?utf-8?B?NENKU0pkUGI3NDBXQ1N6Z2ozYVpQdFlYclZDVTYvVGZUbmFMSVAxMERuZGt3?=
 =?utf-8?B?YzBWRFNOYnk4dGdRYlJUSkxOSThyb1Zld2t2VEltdFlKalJ4cmlnTjJvV3JZ?=
 =?utf-8?B?MU92Wmg3akZ2MVpuUVpmZkJoY2JVUUhFZURscmNZTHBHa2NOV2hqYVRRZXlY?=
 =?utf-8?B?QkhuWS9XeGNzcDl3SmsvR3VBcFlnSmNLZGxhaEJwd2ZPQks4U1RzcG9tSlp1?=
 =?utf-8?B?YnhEZnlNK28vSXdOcGRBS0U3UFhmVEhzWDEzRlRmL0ZMMTIvMnlkcFFKY09u?=
 =?utf-8?B?UHl2dTN2L3pMSVgrUmZaVjgzdlVlTUtKQjR1bGNLNEhneE94TkFib29oOXJt?=
 =?utf-8?B?ZHpEdnhBZWJDcGdZT0h2SjlFWmhyci9xeW91YlVLY1hCYVg2R0cvcnZZa29m?=
 =?utf-8?B?NkxpMXNaRTZXNHpOdVpKQ1BFYUlZaFdUZ0Z4UzNLbnlPOENqcm1xUUVHc043?=
 =?utf-8?B?R0NHZ2k3Rnhod2tSL2pSeU9HTDQ5dGhqUHg4Q3F2N1diSUx2T3FQL2ppejZZ?=
 =?utf-8?B?NUc0SFlXMTdxR1dBM01WbU1yVjBXbytxZUZtVTVYVGpuZ2ZaZnZSU0RGZXJ5?=
 =?utf-8?B?ZThCSjMyaVNuME5hWEwra0VDa1N5TjJwaW1jVm4zcGJ2QW16RDRIbmpSa0c1?=
 =?utf-8?B?bVFybkM5cmFhb2NqMi9JTFJJMklpT2JWSUYwSStOY3JCam5pQklGelFuTG4w?=
 =?utf-8?B?WWtIT1RscS9iZlY0STUyRDJya2JCMnd6N3IxVUkrL3cvMmVuc1VTdXZLS2VG?=
 =?utf-8?B?RVpvdVN1UjljWFJPZjJkdUFKM0VxOWZ6RTFEOEFQOTJTQlJSQUdLWHI0VWI0?=
 =?utf-8?B?TkJoVXRJU3hRY29mS3pycE9NLzJMRlFaY3VwVDlDQkswNW0wNjZoTFdlZ3FW?=
 =?utf-8?B?VVFEYnpjb1VsZ204cGZsVjh6NXlPcktPMXdQeHUvcGdwek1NTTdFQmRqYkVi?=
 =?utf-8?B?TmZBVXZmZ0h4R3lSaWl6K1k5K0MvNlh6ZHVLK0llemlFMzk5dTVGMGNjN1FQ?=
 =?utf-8?B?b1k2UUNCQWtLYm5VYUFlcWwvalQ3RUZFd012NDNBV3Y1aldsQ2FJdFZIQzJr?=
 =?utf-8?B?V0x0OWE4SDRXL1dnbGJBZXdBOGRVT2lDNVNJeUNQVGp0eGlheTRMMnRkRFpq?=
 =?utf-8?B?MUg5YzNiOCtTV3JjWlp1bEg0THg5KzFLNWJjRHEyOVpnSE0vWHZoWEN1SG9M?=
 =?utf-8?B?TVVwMDIxbzZ6eWJhZ3hJZHI4a3JMN0czMU42RExqeTJ5ZEhXdmlxY3ExdXZ0?=
 =?utf-8?B?MisvQzR5cThueW4wSFc1QWhSRWVicmZKWll1RFBDU1I0VThSS2hKdXkwN3BX?=
 =?utf-8?B?ZWs0VFB5Um9VKzhvbmxmUEl6ZVNMNGovbXoxUktOWkNpeVZlVEV1RlhvZ3lw?=
 =?utf-8?B?cjV5V1NoQkRpd1hpNnQzVmN3MkFIUUlCVWYyUnNUTDBES0NaeUVmZHRpcnlm?=
 =?utf-8?B?NG9hK21nTU9TbDMxa21hTG05UGI1dEJHMktRcDdDcnBPUVdQTWh1aXBlbktB?=
 =?utf-8?B?T2lLSzB3STY2NTJrSThQSDJZODhIMlJYc1NZTVJNdC94SDRBbTNIRmdWdVEx?=
 =?utf-8?B?c3NUTFJYeXNHTFJibVFGUmhnTktSRFloTHBTalhPL0JoVG42R1RpR01uTHZS?=
 =?utf-8?B?M21Td2ZoTGl0ZlhzS3BFVERBR3FpbHdYME1OSnM2RHB1ZmtTcUtYUG5aaUpZ?=
 =?utf-8?B?bFJ2SnpIL3NhYVFUWEVkQ2NBY095SXZCUCtkMlVWV21JQVRZeC9lNXA2ZDh4?=
 =?utf-8?B?N2VyUjdVYXhqbVc2Y01BNEN4elZQOXFsRGl4cmlYTHBkamVHZ0kxa2FFSFZh?=
 =?utf-8?B?SFRPdHZ0UXdtMXlEUXhQT3lIeGpxQUhZMGdxYURTSExTdWxQcXk5Mi9aVElq?=
 =?utf-8?B?QkpqL2lWRkNvRXh3R1lGdE1lMEJGK2VRLzRiQ0ZMVXFHSE4zVFUvaUV4L2tF?=
 =?utf-8?B?MmRxQmRYT0luQmM0L1hNRS94WFdIbTQ3cG1KelBqTGl2WGxTZENQM0FPZURU?=
 =?utf-8?B?MnAzWWRLSzJxYUgzVThEN2toR0poc3dLQXM0T0t0MWtVSEdrVElyZTVDNVZQ?=
 =?utf-8?B?YlRCNjFCUkhOdjRSS2l1QlREQ2F1eE53clZZaHFhbStKYUhlRG00Y0tzdmVl?=
 =?utf-8?B?WC9ZTjc2Q2Yrai9mUWVoOVVZQkFVZ3NoUkE3M0wyTHp6Tm54ajZtbVB6aFE3?=
 =?utf-8?B?OEZod3JDeDY2L1lNNk1hTldNYUFhRUg3TXlSa0ZTaGZEZWVZMUhGRFUxdU9x?=
 =?utf-8?Q?jUaVVK5RaPpRy5x0=3D?=
X-Exchange-RoutingPolicyChecked: IQYWptVNhZcirGvsbCnNXhBxYTb+qNQL9vJETCE3RK7/qKcxYEY5A3li0UhbG7C+zMbGHq66CSnV6l66mMN7oiwJ15Ali898jktUeDTWn2lqI4maG7i9/w3BSWB9ncz5+rStF83yE6kRk+8DD8fcxm4CFLFFvqNuZd/SdGUgQN8J95iGOGZJId7RLoajWsmCueJ/7t6sFRuLEVfnixTDeiDM24e3kLDNzatfXNytp5hlZ0ykkNgFcAScym8cCbUjhokHEjLwoznAfzr5U8cr+j0BQSqD3VBXI5A1XJ7XnByq22uiEv+FJ0QMTWNbF1mnGBJLkrLV5ZEfwX3xK4TVpw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 491f8d3f-8995-4bf2-a440-08dea186b7fd
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 22:21:51.9804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XHYzh70q/5oMFjbjtCD0c3KZ89gr9X5vBYXf6E83VhngGWGgZ4Ld6T+GASr55BClolYJcj3MHCt18yoNmI2Mmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF5B09F0799
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 82A1B1C0006
X-Rspamd-Server: rspam12
X-Stat-Signature: 93z5jka1hqg978a9rdo3kriccxtcywu4
X-Rspam-User: 
X-HE-Tag: 1776982917-418224
X-HE-Meta: U2FsdGVkX19lCIm0R7cOZGnDBkUfjyGxMPZmzCrOiK3SbDYebjPHIzjsqAPbyuUjKRejzU8mT1J+T1zL7Rca7nQRyQMvoy3b0aDbuLYAPEwE1yb1y5x6hOtuqy7A9vlwG6PawFfq2U2s3mOOyC1Co7yQ5ysvc0l5d1IcjhFcZdWyrU0ewm2F28K81ea8XAYkaYd1uKX2H9vGCx4c9jlg3xoIqVEx3CsJg25p36PSvVJA6YxVeR318W15sXUy0BG7005RYZCOVQiUQCff/+cniXPPqLkEuetUA2aBmUa1Tdgufn1k5mftdE8Qy4r5mlJS2fzneQ+ir8wNoTlggJdUm/HXQyRuvDFevAA3AjYt5SEVF3vAo6lYUJeeQuDPnxOgfZklOdGr3WHHJ6LvQMhVA+CMSwqBJ5f0AIi0f0e79CiKimJOMigLPfiIZTLUDXUiBTbva2qOMJ4DXZdQOiUnR6P5qDOLmMrMSzhM5agJL2rJ0/+h1CZ+15LsS7/eaqUsfEs0XhXB/CFgYMHrLv6LDkNlAS7AZXH2Km/xbP3+1nJK3LfwxvMUTD7qJECV7iaS8QE2dH56FBgClasNWjnK6H29G670lOiNzBhiluL1zzf6pBquUUFMbcGarUflLVpaLoKjZjOR7cznSnXQTAPU4adg9QJYnwmKUm6dWgxIz/0FOl3+qqqNX71GlnFDjAmA2klCIV7lffKMHvEjTvii9dEVshEuC5jEHiRV+YzC7n7RDVwRK6Pos8jKKh27xTlkLGU0rzJUZjEeLO0cZYExB5/ctEy13yHVuFXPOBaMFmSNyouwag9Z5sQgiv/n2y1odrCm7n97XoqoxxMLxehK+S8SbuXt4nb0wTXrgGrWYFL6m96PMGFQtiM6F9WS88H+XFHin6gD7bfHwfSd37oBIaiXJREVer6sj5uTH7Z2HQCWMN0oLvLeT+MBVT+T6FYYj97SNOfefLa3ovINhua
 XjuOHu7U
 EGoWqInWH4ql92w6Gvs5N6vYIqQCLLJgK4XkaDFL4W8Ls5IVC2V+6lD1+Hp5ZaDPNIjA+2j0TpsJm4E/9fS60DBhVFYHlZdpPU4ZXhOteuE0+kOBaPTNY77xKCF2efnKExQxh2xAaLjelpqspT/QvzRPqVHHwk2LZBaiOaZi9FK+mYpncJVtCYSl8RReMxzk8Wl6YSBklxT5EZUT/Uid2yVXUyu4Dd+GkBdsBEL9VdEd7IhGDmOSRs86RWTchRaEUvULzeKw087DPSeibcYEvUkxhUPkQtlknzrrUwcaiv0bBBn3XqEWAG7AO/U6RxUMVZ2Vy0O4zE35TuXEzhMLeJS1YIJ2xOBwvZz0aZY3M2Z4tFIaYZJ1Ks1PQKJM4ghhuoz4rNOESH8l8he+WZfT4Zq3E0aA/Sh5QpnN+F7TAuvZpUWWEmDZQITZ0N4Zcz0SHuas+tIdXxPWPY7IYpkA/CWJufMMtMojwyvgEbdDcpGHaWZWB1HsiR4n27vZ1ySj2dSS7A8dvJ9n9Vd1srox/nDC4pdeUlqhlW3hwoX5y8M56q1zGsSrHmTNV/8wAEqpfQTZ/zMm75oM9+3dGngpCdO9i3ZGpbGVrBC9l8KX59krksn8tDA83jLkKqLzWH6CpC7snqZ/a7GEOkEsiqTS6bZovh04YE8ysJR9a/2lRxFd+ORCTMxTakA/Z0oNhuJfTklVrX0Sk3ymRemA0m9rQaUqHBLm38BEt1+1Wv5SYbqlNWosrMqZTDvrkykBHUhGdUlnQy2s/YV6AL0993hVcy6DB6Oy9UjdC7dlUjPfw8UEu5sOjrdylSRfbSBoMXXI4FOOErGx97m+hTGs+mlFJnj1xAf5txj4g59VHKrweHa7xMhdqLUF0Pix3pu9Cp/CrotLc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 12:08:36PM -0700, Matthew Brost wrote:
> On Thu, Apr 23, 2026 at 01:27:11PM +0200, Thomas Hellström wrote:
> > On Thu, 2026-04-23 at 12:27 +0200, David Hildenbrand (Arm) wrote:
> > > On 4/23/26 07:56, Matthew Brost wrote:
> > > > Introduce zone_appears_fragmented() as a lightweight helper to
> > > > allow
> > > > subsystems to make coarse decisions about reclaim behavior in the
> > > > presence of likely fragmentation.
> > > > 
> > > > The helper implements a simple heuristic: if the number of free
> > > > pages
> > > > in a zone exceeds twice the high watermark, the zone is considered
> > > > to
> > > > have ample free memory and allocation failures are more likely due
> > > > to
> > > > fragmentation than overall memory pressure.
> > > > 
> > > > This is intentionally imprecise and is not meant to replace the
> > > > core
> > > > MM compaction or fragmentation accounting logic. Instead, it
> > > > provides
> > > > a cheap signal for callers (e.g., shrinkers) that wish to avoid
> > > > overly aggressive reclaim when sufficient free memory exists but
> > > > high-order allocations may still fail.
> > > > 
> > > > No functional changes; this is a preparatory helper for future
> > > > users.
> > > > 
> > > > Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > Cc: David Hildenbrand <david@kernel.org>
> > > > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > > > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > > > Cc: Vlastimil Babka <vbabka@kernel.org>
> > > > Cc: Mike Rapoport <rppt@kernel.org>
> > > > Cc: Suren Baghdasaryan <surenb@google.com>
> > > > Cc: Michal Hocko <mhocko@suse.com>
> > > > Cc: linux-mm@kvack.org
> > > > Cc: linux-kernel@vger.kernel.org
> > > > Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> > > > ---
> > > >  include/linux/vmstat.h | 13 +++++++++++++
> > > >  1 file changed, 13 insertions(+)
> > > > 
> > > > diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> > > > index 3c9c266cf782..568d9f4f1a1f 100644
> > > > --- a/include/linux/vmstat.h
> > > > +++ b/include/linux/vmstat.h
> > > > @@ -483,6 +483,19 @@ static inline const char *zone_stat_name(enum
> > > > zone_stat_item item)
> > > >  	return vmstat_text[item];
> > > >  }
> > > >  
> > > > +static inline bool zone_appears_fragmented(struct zone *zone)
> > > > +{
> > > 
> > > "zone_likely_fragmented" or "zone_maybe_fragmented" might be clearer,
> > > depending
> > > on the actual semantics.
> > > 
> > > > +	/*
> > > > +	 * Simple heuristic: if the number of free pages is more
> > > > than twice the
> > > > +	 * high watermark, this strongly suggests that the zone is
> > > > heavily
> > > > +	 * fragmented when called from a shrinker.
> > > > +	 */
> > > 
> > > I'll cc some more people. But the "when called from a shrinker" bit
> > > is
> > > concerning. Are there additional semantics that should be expressed
> > > in the
> > > function name, for example?
> > > 
> > > Something that implies that this function only gives you a reasonable
> > > answer in
> > > a certain context.
> > 
> > I think that test would not be relevant for cgroup-aware shrinking.
> > 
> > What about trying to pass something in the struct shrink_control? Like
> > if we pass the struct scan_control's order field also in struct
> 
> If the order were included in shrink_control, there is about a 95%
> certain that this change would allow TTM / Xe to break the problematic
> kswapd feedback loop. This may also better express the intent of the
> problem we are trying to fix here.
> 
> For reference, the cover letter [1] details the problem.
> 
> Any guidance from the core MM folks would be appreciated—would adding
> the order to shrink_control be an acceptable solution?
> 
> Matt
> 
> [1] https://patchwork.freedesktop.org/series/165330/
> 
> > shrink_control, really expensive shrinkers could duck reclaim attempts
> > from higher-order allocations that may fail anyway:
> > 
> >       if (sc->order > PAGE_ALLOC_COSTLY_ORDER &&
> >            (sc->gfp_mask & (__GFP_NORETRY | __GFP_RETRY_MAYFAIL)) &&
> >            !(sc->gfp_mask & __GFP_NOFAIL))

It doesn't look like __GFP_NORETRY, __GFP_RETRY_MAYFAIL, __GFP_NOFAIL
make it to the sc->gfp_mask flags from the caller and get into kswapd
loop...

 1182 [  394.049058] xe_shrinker_scan: no skip order=9, gfp=0x0000000000000cc0
 1183 [  394.049061] CPU: 2 UID: 0 PID: 110 Comm: kswapd0 Not tainted 7.0.0-xe+ #355 PREEMPT(full)
 1184 [  394.049062] Hardware name: Intel Corporation Panther Lake Client Platform/PTL-UH LP5 T3 RVP1, BIOS PTLPFWI1.R00.3332.D05.2509011438 09/01/2025
 1185 [  394.049063] Call Trace:
 1186 [  394.049065]  <TASK>
 1187 [  394.049066]  dump_stack_lvl+0x55/0x70
 1188 [  394.049073]  xe_shrinker_scan+0x274/0x280 [xe]
 1189 [  394.049181]  do_shrink_slab+0x132/0x360
 1190 [  394.049184]  shrink_slab+0xf0/0x3e0
 1191 [  394.049186]  shrink_node+0x2bd/0x800
 1192 [  394.049188]  balance_pgdat+0x323/0x760
 1193 [  394.049189]  kswapd+0x1c3/0x340
 1194 [  394.049190]  ? __pfx_autoremove_wake_function+0x10/0x10
 1195 [  394.049193]  ? __pfx_kswapd+0x10/0x10
 1196 [  394.049194]  kthread+0xdf/0x120
 1197 [  394.049196]  ? __pfx_kthread+0x10/0x10
 1198 [  394.049197]  ret_from_fork+0x1d0/0x220
 1199 [  394.049200]  ? __pfx_kthread+0x10/0x10
 1200 [  394.049200]  ret_from_fork_asm+0x1a/0x30
 1201 [  394.049202]  </TASK>

Will look into if this is fixable, but again any core MM guidance would
helpful.

Matt

> >            return SHRINK_STOP;
> > 
> > Possibly exposed as an inline helper in the shrinker interface?
> > 
> > /Thomas
> > 
> > 
> > 
> > 

