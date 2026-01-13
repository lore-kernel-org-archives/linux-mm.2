Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5B51CF45DE
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 02:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34CF26B0005; Mon, 12 Jan 2026 21:17:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FB3E6B0088; Mon, 12 Jan 2026 21:17:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17DB56B008A; Mon, 12 Jan 2026 21:17:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0262D6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:17:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 950331A1504
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:17:02 +0000 (UTC)
X-FDA: 84325327884.24.FD3DE10
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf19.hostedemail.com (Postfix) with ESMTP id EB6F81A0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:16:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QfdzKfXC;
	spf=pass (imf19.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768270619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EL47MDkm5J42Rmv4VXhTs9Q3RZaRcIEUHpx7mOkGAk0=;
	b=EQWK9qjbJFAErDYH876hh9wrNwAH59hZTq80UXsv27AVQE/VcWUuQwx2leofaM4zZMoeu9
	BcH0X6ZldAvpEeYYqYO5MCj24E43kRX9hzNXGozz9fBgnUYy32gBCxn0BZZJcZ1tLBgNdY
	4NKHdvZamwtPC5EqPyJ7YVoGqUIGuhc=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QfdzKfXC;
	spf=pass (imf19.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768270619; a=rsa-sha256;
	cv=fail;
	b=cH+paFLd/Ssp8lbxt/Wwjlh5in//av0/0srhTTk0SIAUTtO3vDQINuFRcehVUuYfaf3BDL
	9Gd1n8LXqQyympLnwyT5I9tK2Q4Z6Z+/28109zYY/w76QJ61xYFwuuzCCKCJoESug0LBDb
	tu22TmxYpQUyqARlhhI1p2Qt5maj6eg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768270618; x=1799806618;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=ozHsku2BD4Z9uFaror7HhLk3HZVPDTht4/PfD9jkTGM=;
  b=QfdzKfXCTmN+O+hgYP3TD76lGqu+f6yg6E0Gzk117bvQwYkxR2UG47TF
   xq0OYOPkyAXRNig6Ph95JcQ76iRBADgUjBS9GlT4QROtIkL3kQDEYLvJO
   QXqCupPN6H9tlasCoY1wAjO9WH9Ocymap2EpdbZ+2eKjcTTbfioozUXc4
   kwr/B8Xwl1FhhVDlQXa+VCxRPmsHd+1qdFA6RlAo12CdQLOBdLiuh+IQG
   rr/RLt+qMJvsCzcdTLsLeDwMYwv62N8rAppKj4PzbVBPbJTgE6bf2sNF9
   dI6wQKSdaFZMTZG6q3zLN1qYnHcoYmfw3D+hPGF6l/9Cey0yiCZ7x7K3P
   g==;
X-CSE-ConnectionGUID: 2zv9IR1sSlmQrEFJXR+/5A==
X-CSE-MsgGUID: VTm8/n2CQs22l9MAOn8NxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="69711628"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="69711628"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 18:16:56 -0800
X-CSE-ConnectionGUID: CHz+GcHJRJSbeGnnMoqTtQ==
X-CSE-MsgGUID: gfwXBKY/SDKP0vn7g4bP0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="209085444"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 18:16:55 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 18:16:55 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 12 Jan 2026 18:16:54 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.32) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 18:16:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xWiRrE9N7SIXDIq/vHHk4L1jANy5a7qWBZOV/mt45+QXLvlC7RgPIemGze+bgNbICwSTCHbWzljSsQL411EjBq3029PhV6bdxbrY7bpoZiykVbphHdpuS9tkBDOnGupVxV3WA7LlNDmCYxi7UOouH1hug37yCdX9HCM742zc+E06DfYizi0aUnSFfkckyPe64YYZK+tBc7/VE5MDGHzT8eLFOld0xD185qLbYmpob+uH5b9nfSGj0+f72d5uzfOF3Hida55Gw7JqaDotuyPhB/YYtWkdC3Vs3vuhpLa/0+a7kltwbPHpCJVg0HtDHvQ09FmIPocxUUpFzIKgdzFMgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EL47MDkm5J42Rmv4VXhTs9Q3RZaRcIEUHpx7mOkGAk0=;
 b=mZO1lfX62rEVBR9mgwE07M2fK3lLwwr6sYhQXjGy8ckHIssF4jUaPh32FJusiEJJMNhQgQrnCgYLDtzugN213dXr8DXVdQ0+Ge2vpu5hAhwtuJNumOVBWhNfq4gMztZ6GfcsRQ2esUZ8jUrIHobregswseFoNDOJekXYpMsibqHLZkqfejREZDrKlGiURyMLBq+N3uPuI3o+JkbROHRT1t9tcWyYML+BNFeSUBno7LdDUeZg2xidWHycnS9ciD1JGvIl8I1bY9J0evZKSC6clxKsEOLtebD58gVHi6sIqujTUasJIo6NwIAre7LFX7mmVhzTqUVkuuJ3qCXenH/mqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by IA0PR11MB7883.namprd11.prod.outlook.com (2603:10b6:208:3de::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 02:16:53 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9456.015; Tue, 13 Jan 2026
 02:16:52 +0000
Date: Mon, 12 Jan 2026 18:16:50 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Alistair Popple <apopple@nvidia.com>
CC: Balbir Singh <balbirs@nvidia.com>, Francois Dugast
	<francois.dugast@intel.com>, <intel-xe@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, Zi Yan <ziy@nvidia.com>, David Hildenbrand
	<david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, <linux-mm@kvack.org>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/7] mm/zone_device: Add
 free_zone_device_folio_prepare() helper
Message-ID: <aWWrEtUvlqTVKs2N@lstrano-desk.jf.intel.com>
References: <20260111205820.830410-3-francois.dugast@intel.com>
 <706ba3a6-5be2-46d7-9e7d-d613f2e061cc@nvidia.com>
 <aWRLeoUJAYAWbLD3@lstrano-desk.jf.intel.com>
 <k25qmqrfmhzkls2ngdaq4wdk3xtl3epv4z3dvukon5yj2cb2hl@yci7xdpvauh7>
 <aWWQhOD8g8oLz1vX@lstrano-desk.jf.intel.com>
 <ntawk3mmrg2qihe24dk34pevtlgj3cdxnshau3wgyi5lygtuvo@jcsz5hmt4xth>
 <aWWaxakpRiapWw5X@lstrano-desk.jf.intel.com>
 <bgbjzeqbvdrlusnt2gexc4joosukgxddca5w5zzq6dz44rjkfq@nt2qd7eu5cak>
 <aWWijsq6CohElWVV@lstrano-desk.jf.intel.com>
 <lwbeop6muq4tbrdauwfi42nw5jss7yvgbmls546sxvygivpcwg@persiopzpqed>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <lwbeop6muq4tbrdauwfi42nw5jss7yvgbmls546sxvygivpcwg@persiopzpqed>
X-ClientProxiedBy: SJ0PR03CA0060.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::35) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|IA0PR11MB7883:EE_
X-MS-Office365-Filtering-Correlation-Id: 550077c1-dc9b-41da-4a9b-08de5249d113
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?azdEWjRFNjZOR1BGaWhyVm5PbUpDdzRycDVWUXJFMjlGN0NQS3BiOUFhdG5y?=
 =?utf-8?B?cnFmdlBkV21JZXdxMm1yTmIwdmFhT3JpLzV1cDBQKzZ5OE1Zc3EvU0EycFBZ?=
 =?utf-8?B?dHVQUVcrNGY4akswMzl0dmViUUJnRERVck0rUzdiZUV0c2hMR3h3VjU4VnAw?=
 =?utf-8?B?Rm9FWW9qaHQzOHBuYkNUdFEyc1JHT09GSzBpdWZWSVhpRXNSSHJMQVV1Tmxh?=
 =?utf-8?B?RGY3RkhKTHV2N1dzWGlFWWlyVExWMlRIUjdVM0gwYWU4VWFNbGJoU3g1M1g1?=
 =?utf-8?B?L2JNbWMwN1kwNkViaEdvY2EyY1ZOa0hFb0V5cG0xMzd0by9Cb0lPeXlGR1ZB?=
 =?utf-8?B?U1A0TC95azJnZG9kRmhlWkkxcmR6MDQ2RDVWWHNuazc2N1pXSWMvd2YvWkJr?=
 =?utf-8?B?RjY1NFNoak84Z2szR1MxeTFyMzBBcU53TzVYcDZXMktHUENmTzhkcXVsZHlN?=
 =?utf-8?B?R3dCa2JuVVltUzZCN3ZPVVVqZXE0U2tFZHpoTWFGV1czVW9mRi9tQWp4TFVS?=
 =?utf-8?B?TUV1cjk0UUJaUWZwUTUrU2JGM0JlMnZOWk5WWHljK3lVZzVuMWgydE13aHJI?=
 =?utf-8?B?RVVnVnRBRmViSTEzc2dLalBEMGt6OW5yL1BOVzlKY2dkY1BJRENkS3FDN1Jr?=
 =?utf-8?B?Um5Kd3RRcS9yTjhRYm53R2FoNm4xZ2lnMjd4TnY0N0x0c2FuYU9DU3lDUkVD?=
 =?utf-8?B?MURZWUZxSXhrbkIyNFl6K1FsYWY0ZWtqNy80bXkxRVZOVUJUOSsrZzg4MmpC?=
 =?utf-8?B?NUgyaEpLcTc5Z0xLR25DQW9SQzhaV1RJdC9OcGc3aWdFZFIxZzhreHMrQVdF?=
 =?utf-8?B?UjRPTFZYTGZCRG1sU2s3VEkvd2pkV3ZITmhDZFpHWUg0TFNzRGR0UXB1cExC?=
 =?utf-8?B?UTNCVzc1L2pVR0pBdnhsOUpJaHN4WFptZTRFVTJ5ZFJxVldxeStqUnYwWHEy?=
 =?utf-8?B?VVlvMVpWWFNvM1NDYkNxbWZ3RGF0bjVSWFlIRWpTNHBaNHp4bHo1WCtBVEYz?=
 =?utf-8?B?czN2WnZhbjRaa1AwdERlOW9LUWFIdzNkSWlyNHBSQk5uK205VUtNQWxYTXA5?=
 =?utf-8?B?SUdvVXdsVThMaVg1cTBqNXNlS1p3Q2NKZm5kSGNDUVhPMGNlWFZBM0g0VU4v?=
 =?utf-8?B?bTR1RUdZbFpCSGpWR3RjZWtWZW9CWWd1aXZTeVQxT09DMU1JUG5WRTFSOHpU?=
 =?utf-8?B?dWU4WFkxTXBuTitSTUtmdm1pcVB6dXRVRkhZTU1OS1FTb045RmZFaEFwVXpE?=
 =?utf-8?B?SC9sWFdPTjFYbGZORWFpRFUybFUvNVN1N3JDYlZPTHE2cURUSm5pZkFEM2Fz?=
 =?utf-8?B?Y0lPSkRiL1psTGIxS205WE9kWkJNS2JibmgzS0tOcmlQS0dHZjN3Mi9uc2pu?=
 =?utf-8?B?UTNhdldud0NDNFlvdVdwRjk2ODVLanBkNnpUWnp3K1hRWmRyRDhQTHBzREtE?=
 =?utf-8?B?Sk9LbGdJM3lydGlCRjlia2ptcjhtQzAveXFLVldkaC9majhtaDA1b3p3d2pB?=
 =?utf-8?B?ZitTMnpiQnQ0RzRiQnk1WkpmOFBDTW5mRlgxQWVXb2MwVGJCcGZ6Z3VwQ2pt?=
 =?utf-8?B?TlQxa2N5b3Vpdlg4Q0JzS3JIYk5yRUJJK3Q4eWIvVnAwSjM5UGFuVlc2VVY3?=
 =?utf-8?B?eUxsTFAxSHYxam9XWXdMczNDYi94NzE1bUVJMHp5dytkOU9LVVU3blNRZHBr?=
 =?utf-8?B?ZkVPUjNNYk5YaTFkK1ozbzI4N1BCOFUrMXprZWtsbUFBenJrei9VUG8xYnVM?=
 =?utf-8?B?akFlc0NzOXB5eUtiR05MRFd1dExXNHNyT0txQ2NYbVpwcFlDVnRyRmQ0THZT?=
 =?utf-8?B?dVhyWWEreXkzMTZKeW1WRDE2L0w4Z0FSYkJScVJPNGs2RUNCcE9HYXV3V2xq?=
 =?utf-8?B?NjF5NWg3ZER5UHRWWXBYSUhnY0hkVHNXQTJTMVFma2wyNldwd25NQ1dSL0wr?=
 =?utf-8?Q?ow3Ehp244ZR9f+I6NuTPb1sDsSJfDH9W?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzQ0dno5TXZaNXp6bTdwd3V2RFJLaWlzYW5pc0lEdWNpUkdQZjY1K2U1YnF5?=
 =?utf-8?B?QWo4ZXVHTHFBMERpTVE3Tml2Y1JqZW1VWTBoaGVGZUdzNzZkSERFaTJEQ2d2?=
 =?utf-8?B?dkN3WHIvRW56ckZDV0I1dExiSTMxZzRkZVVTNkQ4ZFVtN3Q0bDFZWnFsVGQr?=
 =?utf-8?B?L1hRQ09RQ25sd3VYL0JMcld4b3I5U3JiT3dNRDZKamM4ZkY2WC9kUmxYbzdz?=
 =?utf-8?B?SnBVME9BeG5HeW1ILzExR0VQeXlLZDI4TjlJVjlQeno3TGNpQnVlNWxVL3RS?=
 =?utf-8?B?OVZLM2tVakV5aXlscjhSaE1wMzFiZnRnSzQyTnEvazFDS0V2aC9DZFVtYytv?=
 =?utf-8?B?Q0tKaHZNOFFDRURkd3BvVFU3K1NiRVRzS2JrMmQ4MkY0Q2pObW1zbm1lUGli?=
 =?utf-8?B?T1ExY1pQbkpiV3lSVVpEcmJVUlprL3dKMm9WdmpEbklZUnFZNGVzeEptMGlm?=
 =?utf-8?B?ei9NbWwyZ0hVdER0c3MxOElXbVB6T25tQUw0cm5PZzJuMytQMWFhZ3NGY2tR?=
 =?utf-8?B?ZGtjaGE3OXprNVY4MkFNYUVHVU9WSkN0cHkwS29sdnd1bUwxVnJFdXYwOTZ5?=
 =?utf-8?B?Yjh5cUNUcE5CZjh4RWlvekZObkN1VStwMWswOUtXUUNkbFR5b0dIRWpGMFNl?=
 =?utf-8?B?Zm0vaHIyK0tIaU1qalBNbG1WR21rM0cwY2ZBRVhLc1NvTWZjcjhJVFk4TFVQ?=
 =?utf-8?B?am5JbnRhRC9BK2FGK215QTBob29SZlh1amJWZ3ZnYVZ3Zkpkdk8wNHFoMlBq?=
 =?utf-8?B?MDd5VHlBMGR5cW1XdFlUNTlJTmxOb1J4c3JUNW9NMTA4b2dleUlQZnE0eVFh?=
 =?utf-8?B?Tkc4bDBObkY2NUEvZy96OTErZzRKZWhGRUREN1E2TlZWVlJOWkphU3IwQnRV?=
 =?utf-8?B?UWhBSENRakRjalZvR21HVmJMRWJXMVlxaFZvVHQzRjVGQ2dGazZsc2ZCWCtP?=
 =?utf-8?B?T0tXWWtTdHhwcU81RFJaV2dhY1MzaGNwY0g1TmplR0NYZ3U5bFF4WjN3MDh4?=
 =?utf-8?B?ZE50NGo2cEYzKzZWT05vRVplQ2xOTTVWZ0l0OWtDWnNlRVM4VXQrVTVGb3N0?=
 =?utf-8?B?alQ5b3JQYUo0bGllYnllMWxNaHpFSU1kc1Y2cVhHYjZWNlJUeWxOK0s4VVdR?=
 =?utf-8?B?ZWVQTG5GMGpweG9CQ1grU0ZENHVESlF4T3BNck8yY3IzL2ROOERDTURhWTFo?=
 =?utf-8?B?WEtZOUlZSHJSc1JJendnaDVVL3NiSENCU2h1QlNuWk00bjhRQ1ltNGVYdjYw?=
 =?utf-8?B?TkQxRHdpNFBSV3dLSGs3UnRZc1l0dFVXT2VtMGY1WUFuYlkxOWpRUWNxWDR0?=
 =?utf-8?B?cFVXaHcrUnRycnZHMk1sR2JNOS9yYlpNUXdvanJ1S0w5aGk4bGVGc2JwTzgy?=
 =?utf-8?B?c242d2VOQUFzcWVrVEplK2kyQWN1VjVHOVc2L1RvSEpjVWRoTzBmQ3FBMlVj?=
 =?utf-8?B?ZWUzc3A4d3Vnc1dHQ1U0YmxjcHhQcXhPZ0xsOXZJeDV2UkxhNXoxR0FTcXBw?=
 =?utf-8?B?TTVFK0pQWG5wdC9IRG1jR3ZzMWduZjBjTmhEcHFBeDRqdzJvcmthSHFFS3RH?=
 =?utf-8?B?aFFaVkgwV3hKWDVXbW43UUwrbVhQWE1waW1OVlBKclF6OUdzVmwzUE1ncDVE?=
 =?utf-8?B?K2xnVGFYM2kxbTl0d1JXd3REbno3VlIzdFAxTk04a0tGeDBPTFRLQ1FyUHFR?=
 =?utf-8?B?MkJWbU1yUE94UDZ6YkFuODRNcm1vSGpEK0pBTWwxTmVPa0lQcEE5SUJQR3d4?=
 =?utf-8?B?dTF3MkloUk1vWlhHZG9QMzhjS1JFb0hjaEppS0N4anQyVEtmWVkySmpXVTFn?=
 =?utf-8?B?andIZXN2alE0bHNzbmdhZDhwVWxYSCs2dDAraTZmd2hhQzRSQkFlRnpxQTNR?=
 =?utf-8?B?MTkzM3lVUDBlVmJ4L2FkeVd0T3ZuZUlCaUxEK2xIZUk1dFgva3pZZXJSMGFK?=
 =?utf-8?B?b2ZZWG5Jd2lWd2NIL25rUlBrQkNRdFIzT0ViQTY3NDUwT3FpdjlJZHN4eDB4?=
 =?utf-8?B?OTZlYjF6UnJya3JIVHZsVVZtaTdJa05CM1ljYWtpSURKVCtDcUR5QTY5Qnp5?=
 =?utf-8?B?elVpN2NSNGtkK3l3N3loUTlJamhtYlo3LzlHSWtNLzZzdTRMVEMyWE15MTJO?=
 =?utf-8?B?SnBMTjU3cDhrcWdsdnZlamlWb3Ezb0hZUXJjaHJvc1dsZXFobmZGU2M0VEl1?=
 =?utf-8?B?ek11OGtPcHhrYy90WUhvbmhBcjlBNGpkTXQ3ZEJ0c2tmY3lrV0hwY1NmdWpB?=
 =?utf-8?B?ejRFWjdCSnM1NTRjUHNvUWRlcUsvVFI2Y0dUNit4WnRlMTc1OWxZN3NKdFNN?=
 =?utf-8?B?VVl2Q0w2dXRJMmROb21IaUozZENNdmZTUTFESGR5c0thVjVwT2loTHM4eGNM?=
 =?utf-8?Q?cGRxyJL5FVQXzUNM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 550077c1-dc9b-41da-4a9b-08de5249d113
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 02:16:52.8977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3eUGhn67CRafxaiAzGRQbMUgG0MLq4Bu3eiUOJ+KKvZ05cJ6G5nzbsDyjnOBQ6kLwPlOf2Y7/BhWQkvCQIJg9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7883
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: EB6F81A0005
X-Stat-Signature: hpfpnmykait3rguwkgkr6x43efoge7xd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768270617-766322
X-HE-Meta: U2FsdGVkX1+ppHA6JxXJ61BYtQWCkjkblX2JzukzpF4BEpw+B+/2lndIfLL2ZNn+GRD8sEPnlTlkDoHsoOKzCoKPey9P5ydEe1BHZl2VPIygFoXFOLal3gNFb3DWFH3++BHemOW/lct99v7jvagF/v5up7hPfcEHDSxZyBqBrWnWb3ubeh0iClP+mAYGaGTDi1BwJfqw0THh+saG7ekPFS7dHxdwoX4tkRHxxJAKnf/30fldpocZnXVWleDDKpQjg/4oRXqmm5yM4bsEEEneDpLyB+HTUoV3nBaWIlBN2Do8C3iLVsrPPEZKYM+nAeKLuH7aySuJM9g1hR8i8cYG5orwfBa3jNnq0PxL83jltff5yZdvCWaCD0R4D0KymZfaJ4+EOdRBAY5cDUGfBVLr3tgj871GZz6N1ObO0IbEhUOXwa4TWwLfuTqzgi9KTx4AHhjuOLSmB4Mi49Za+cqoc08KOGHGo1W1QzQwbkft6cUr6aJBv1gKake1uVhD0QlfZTV58oniWIFOtoqRiFjpWbCQFMQzUmvN+d36ZyoWD0eV4Gf+tn87/J2A/QB0x0aVIn6IkmNJdhtneIg1MiJhwXcYBEJt5u1IK0tPXpT2GgU6IJTVMTrIwo3NGlRP0iodxWnsqGymk4x3CuOFjF/AjhYxTKvLBBzSFlVlLEaM75wlEzHGpYxMmhNRobo4m5nYBaA1AkZeZUGUnfebvwlc7zU9VyNH7PCyK5vhs47C9Bv3z7Mfiepwg4fwl7dIWLblAZgQK9IO3MssPeCCzdkEZ5+M5sedDV43EmEPjMMY8DBbmqqgsMxjxv7zi9WHVCnY7yftFCIm4qIa3tEC82j20cUGbQcCG8PTTRzzA8SyDdI33WsTj7DDhlVKHdnbH4doAzXQSxsP6EAu/NhdK+GfV77+BciN5jVRe+gfekUuzj2K17zRwbXH1B6xAqE5Z4pqBDBVUNXZyXr4IiNGRSe
 WLTTuc4o
 CogX9UuQHzaFNw1B66139Opmo0AsKhFRMMJxB93qPzZ899xR3K61cwFB+lFpaE9t9TpAECt7pVxBRVf4xLOC+vy4+W7VKw1DbpeVMGgHM0bF4Oh3u4YgRgcb7Qmx85VeVcsTCo9cAG1U96m7cBjkp0vxFmUTyf547yPdoIpR2jyrFlc0Y+oyr1khu8JEE451Khu7xlslDlcJ4NWQCNeikfKk4yqEAUmUGxLnydTFXirW8bhH1G2NVesIGHHgEmsZcjU6hK6tEeczaBwa/FGSa/OTgSwGbw/cPvb1gOn36T9HM9ggqol2NCZCPmsxqHs//TW1H8KTbqd8rmsX2Hq2WnGm+ZMh1Q+WQgu2RpJLOYi920HCV7jYJUyNQvYdvkHwtlE+oVmOkQ3NaCWUEx5lEXYiLcK9rk99XmR6kjJ3+kGS3bYxXEtiGdT4ly2GHEzjn4azjBfc4axsAF/JrRYFEEV9IKcJktYU8DWFtRHqK6HWhQWOKh+l3K369oonRRb2YUZuvtpbFLdZd81q9Wpj0UolZqKn5skEy7+mVzLiwMEWQoEFNE9jRYl6a+fME5k99R8vUqEfx7elmgOB6r08CZk3wu8xV9Kie0agR+qdv/v257AZu+c3FvC5rrcXAxKYaRjVTnFsiXp/kKmm7ua5x3kV+o0PP9/RjaIumc0a4G/Ev6SZJxuUB3qIjcUZT/CZU8z09irfZ/eG7Odbd1qvnQU7zbHdy2WlPmlzvDoXaTHat3rFM3BPSRZNX08kimmkH6pbsPMAgsQtGSBOBtRdAcyRCk78wv/SwEIUsbdEquhsV12djnXu2JXGrAYmsWW1yRoAtRiSikEfxQ9dX6iqRjca8D1BIlWHibC6p1LnsDwdsLcvYIttihiK3D/bsmeGhE2+rfE60JPr/GVcMLztwl3g3oQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 01:06:02PM +1100, Alistair Popple wrote:
> On 2026-01-13 at 12:40 +1100, Matthew Brost <matthew.brost@intel.com> wrote...
> > On Tue, Jan 13, 2026 at 12:35:31PM +1100, Alistair Popple wrote:
> > > On 2026-01-13 at 12:07 +1100, Matthew Brost <matthew.brost@intel.com> wrote...
> > > > On Tue, Jan 13, 2026 at 11:43:51AM +1100, Alistair Popple wrote:
> > > > > On 2026-01-13 at 11:23 +1100, Matthew Brost <matthew.brost@intel.com> wrote...
> > > > > > On Tue, Jan 13, 2026 at 10:58:27AM +1100, Alistair Popple wrote:
> > > > > > > On 2026-01-12 at 12:16 +1100, Matthew Brost <matthew.brost@intel.com> wrote...
> > > > > > > > On Mon, Jan 12, 2026 at 11:44:15AM +1100, Balbir Singh wrote:
> > > > > > > > > On 1/12/26 06:55, Francois Dugast wrote:
> > > > > > > > > > From: Matthew Brost <matthew.brost@intel.com>
> > > > > > > > > > 
> > > > > > > > > > Add free_zone_device_folio_prepare(), a helper that restores large
> > > > > > > > > > ZONE_DEVICE folios to a sane, initial state before freeing them.
> > > > > > > > > > 
> > > > > > > > > > Compound ZONE_DEVICE folios overwrite per-page state (e.g. pgmap and
> > > > > > > > > > compound metadata). Before returning such pages to the device pgmap
> > > > > > > > > > allocator, each constituent page must be reset to a standalone
> > > > > > > > > > ZONE_DEVICE folio with a valid pgmap and no compound state.
> > > > > > > > > > 
> > > > > > > > > > Use this helper prior to folio_free() for device-private and
> > > > > > > > > > device-coherent folios to ensure consistent device page state for
> > > > > > > > > > subsequent allocations.
> > > > > > > > > > 
> > > > > > > > > > Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
> > > > > > > > > > Cc: Zi Yan <ziy@nvidia.com>
> > > > > > > > > > Cc: David Hildenbrand <david@kernel.org>
> > > > > > > > > > Cc: Oscar Salvador <osalvador@suse.de>
> > > > > > > > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > > > > > > > Cc: Balbir Singh <balbirs@nvidia.com>
> > > > > > > > > > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > > > > > > > > Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> > > > > > > > > > Cc: Vlastimil Babka <vbabka@suse.cz>
> > > > > > > > > > Cc: Mike Rapoport <rppt@kernel.org>
> > > > > > > > > > Cc: Suren Baghdasaryan <surenb@google.com>
> > > > > > > > > > Cc: Michal Hocko <mhocko@suse.com>
> > > > > > > > > > Cc: Alistair Popple <apopple@nvidia.com>
> > > > > > > > > > Cc: linux-mm@kvack.org
> > > > > > > > > > Cc: linux-cxl@vger.kernel.org
> > > > > > > > > > Cc: linux-kernel@vger.kernel.org
> > > > > > > > > > Suggested-by: Alistair Popple <apopple@nvidia.com>
> > > > > > > > > > Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> > > > > > > > > > Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> > > > > > > > > > ---
> > > > > > > > > >  include/linux/memremap.h |  1 +
> > > > > > > > > >  mm/memremap.c            | 55 ++++++++++++++++++++++++++++++++++++++++
> > > > > > > > > >  2 files changed, 56 insertions(+)
> > > > > > > > > > 
> > > > > > > > > > diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> > > > > > > > > > index 97fcffeb1c1e..88e1d4707296 100644
> > > > > > > > > > --- a/include/linux/memremap.h
> > > > > > > > > > +++ b/include/linux/memremap.h
> > > > > > > > > > @@ -230,6 +230,7 @@ static inline bool is_fsdax_page(const struct page *page)
> > > > > > > > > >  
> > > > > > > > > >  #ifdef CONFIG_ZONE_DEVICE
> > > > > > > > > >  void zone_device_page_init(struct page *page, unsigned int order);
> > > > > > > > > > +void free_zone_device_folio_prepare(struct folio *folio);
> > > > > > > > > >  void *memremap_pages(struct dev_pagemap *pgmap, int nid);
> > > > > > > > > >  void memunmap_pages(struct dev_pagemap *pgmap);
> > > > > > > > > >  void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
> > > > > > > > > > diff --git a/mm/memremap.c b/mm/memremap.c
> > > > > > > > > > index 39dc4bd190d0..375a61e18858 100644
> > > > > > > > > > --- a/mm/memremap.c
> > > > > > > > > > +++ b/mm/memremap.c
> > > > > > > > > > @@ -413,6 +413,60 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn)
> > > > > > > > > >  }
> > > > > > > > > >  EXPORT_SYMBOL_GPL(get_dev_pagemap);
> > > > > > > > > >  
> > > > > > > > > > +/**
> > > > > > > > > > + * free_zone_device_folio_prepare() - Prepare a ZONE_DEVICE folio for freeing.
> > > > > > > > > > + * @folio: ZONE_DEVICE folio to prepare for release.
> > > > > > > > > > + *
> > > > > > > > > > + * ZONE_DEVICE pages/folios (e.g., device-private memory or fsdax-backed pages)
> > > > > > > > > > + * can be compound. When freeing a compound ZONE_DEVICE folio, the tail pages
> > > > > > > > > > + * must be restored to a sane ZONE_DEVICE state before they are released.
> > > > > > > > > > + *
> > > > > > > > > > + * This helper:
> > > > > > > > > > + *   - Clears @folio->mapping and, for compound folios, clears each page's
> > > > > > > > > > + *     compound-head state (ClearPageHead()/clear_compound_head()).
> > > > > > > > > > + *   - Resets the compound order metadata (folio_reset_order()) and then
> > > > > > > > > > + *     initializes each constituent page as a standalone ZONE_DEVICE folio:
> > > > > > > > > > + *       * clears ->mapping
> > > > > > > > > > + *       * restores ->pgmap (prep_compound_page() overwrites it)
> > > > > > > > > > + *       * clears ->share (only relevant for fsdax; unused for device-private)
> > > > > > > > > > + *
> > > > > > > > > > + * If @folio is order-0, only the mapping is cleared and no further work is
> > > > > > > > > > + * required.
> > > > > > > > > > + */
> > > > > > > > > > +void free_zone_device_folio_prepare(struct folio *folio)
> > > > > > > 
> > > > > > > I don't really like the naming here - we're not preparing a folio to be
> > > > > > > freed, from the core-mm perspective the folio is already free. This is just
> > > > > > > reinitialising the folio metadata ready for the driver to reuse it, which may
> > > > > > > actually involve just recreating a compound folio.
> > > > > > > 
> > > > > > > So maybe zone_device_folio_reinitialise()? Or would it be possible to
> > > > > > 
> > > > > > zone_device_folio_reinitialise - that works for me... but seem like
> > > > > > everyone has a opinion. 
> > > > > 
> > > > > Well of course :) There are only two hard problems in programming and
> > > > > I forget the other one. But I didn't want to just say I don't like
> > > > > free_zone_device_folio_prepare() without offering an alternative, I'd be open
> > > > > to others.
> > > > > 
> > > > 
> > > > zone_device_folio_reinitialise is good with me.
> > > > 
> > > > > > 
> > > > > > > roll this into a zone_device_folio_init() type function (similar to
> > > > > > > zone_device_page_init()) that just deals with everything at allocation time?
> > > > > > > 
> > > > > > 
> > > > > > I don’t think doing this at allocation actually works without a big lock
> > > > > > per pgmap. Consider the case where a VRAM allocator allocates two
> > > > > > distinct subsets of a large folio and you have a multi-threaded GPU page
> > > > > > fault handler (Xe does). It’s possible two threads could call
> > > > > > zone_device_folio_reinitialise at the same time, racing and causing all
> > > > > > sorts of issues. My plan is to just call this function in the driver’s
> > > > > > ->folio_free() prior to returning the VRAM allocation to my driver pool.
> > > > > 
> > > > > This doesn't make sense to me (at least as someone who doesn't know DRM SVM
> > > > > intimately) - the folio metadata initialisation should only happen after the
> > > > > VRAM allocation has occured.
> > > > > 
> > > > > IOW the VRAM allocator needs to deal with the locking, once you have the VRAM
> > > > > physical range you just initialise the folio/pages associated with that range
> > > > > with zone_device_folio_(re)initialise() and you're done.
> > > > > 
> > > > 
> > > > Our VRAM allocator does have locking (via DRM buddy), but that layer
> > > 
> > > I mean I assumed it did :-)
> > > 
> > > > doesn’t have visibility into the folio or its pages. By the time we
> > > > handle the folio/pages in the GPU fault handler, there are no global
> > > > locks preventing two GPU faults from each having, say, 16 pages from the
> > > > same order-9 folio. I believe if both threads call
> > > > zone_device_folio_reinitialise/init at the same time, bad things could
> > > > happen.
> > > 
> > > This is confusing to me. If you are getting a GPU fault it implies no page is
> > > mapped at a particular virtual address. The normal process (or at least the
> > > process I'm familiar with) for handling this is to allocate and map a page at
> > > the faulting virtual address. So in the scenario of two GPUs faulting on the
> > > same VA each thread would allocate VRAM using DRM buddy, presumably getting
> > 
> > Different VAs.
> > 
> > > different physical pages, and so the zone_device_folio_init() call would be to
> > 
> > Yes, different physical pages but same folio which is possible if it
> > hasn't been split yet (i.e., both threads a different subset of pages in
> > the same folio, try to split at the same time and boom something bad
> > happens).
> 
> So is you're concern something like this:
> 
> 1) There is a free folio A of order 9, starting at physical address 0.
> 2) You have two GPU faults, both call into DRM Buddy to get a 4K page .
> 3) GPU 1 gets allocated physical address 0 (ie. folio_page(folio_A, 0))
> 4) GPU 2 gets allocated physical address 0x1000 (ie. folio_page(folio_A, 1))
> 5) Both call zone_device_folio_init() which splits the folio, meaning the
>    previous step would touch folio_page(folio_A, 0) even though it has not been
>    allocated physical address 0.
> 

Yes.

> If that's the concern then what I'm saying (and what I think Jason was getting
> at) is that (5) above is wrong - the driver doesn't (and shouldn't) update the
> compound head (ie. folio_page(folio_a, 0)) - zone_device_folio_init() should
> just overwrite all the metadata in the struct pages it has been allocated. We're
> not really splitting folios, because it makes no sense to talk of splitting a
> free folio which I think is why some core-mm people took notice.
> 
> Also It doesn't matter that you are leaving the previous compound head struct
> pages in some weird state, the core-mm doesn't care about them anymore and the
> struct page/folio is only used by core-mm not drivers. They will get properly
> (re)initialised when needed for the core-mm in zone_device_folio_init() which in
> this case would happen in step 3.
>

Something like this should work too. I started implementing it on my
side earlier today, but of course, I was hitting hangs. From an API
point of view, zone_device_folio_init would need to be updated to accept
a pgmap argument. In this example, folio_page(folio_A, 1) wouldn’t have
a valid pgmap to retrieve. It could look at the folio’s pgmap, but that
also seems like it could race under the right conditions.

Let me see what this looks like and whether I can get it working.

Matt
 
>  - Alistair
> 
> > > different folios/pages.
> > > 
> > > Then eventually one thread would succeed in creating the mapping from VA->VRAM
> > > and the losing thread would free the VRAM allocation back to DRM buddy.
> > > 
> > > So I'm a bit confused by the above statement that two GPUs faults could each
> > > have the same pages or be calling zone_device_folio_init() on the same pages.
> > > How would that happen?
> > > 
> > 
> > See above. I hope my above statements make this clear.
> > 
> > Matt
> > 
> > > > > Is the concern that reinitialisation would touch pages outside of the allocated
> > > > > VRAM range if it was previously a large folio?
> > > > 
> > > > No just two threads call zone_device_folio_reinitialise/init at the same
> > > > time, on the same folio.
> > > > 
> > > > If we call zone_device_folio_reinitialise in ->folio_free this problem
> > > > goes away. We could solve this with split_lock or something but I'd
> > > > prefer not to add lock for this (although some of prior revs did do
> > > > this, maybe we will revist this later).
> > > > 
> > > > Anyways - this falls in driver detail / choice IMO.
> > > 
> > > Agreed.
> > > 
> > >  - Alistair
> > > 
> > > > Matt
> > > > 
> > > > > 
> > > > > > > > > > +{
> > > > > > > > > > +	struct dev_pagemap *pgmap = page_pgmap(&folio->page);
> > > > > > > > > > +	int order, i;
> > > > > > > > > > +
> > > > > > > > > > +	VM_WARN_ON_FOLIO(!folio_is_zone_device(folio), folio);
> > > > > > > > > > +
> > > > > > > > > > +	folio->mapping = NULL;
> > > > > > > > > > +	order = folio_order(folio);
> > > > > > > > > > +	if (!order)
> > > > > > > > > > +		return;
> > > > > > > > > > +
> > > > > > > > > > +	folio_reset_order(folio);
> > > > > > > > > > +
> > > > > > > > > > +	for (i = 0; i < (1UL << order); i++) {
> > > > > > > > > > +		struct page *page = folio_page(folio, i);
> > > > > > > > > > +		struct folio *new_folio = (struct folio *)page;
> > > > > > > > > > +
> > > > > > > > > > +		ClearPageHead(page);
> > > > > > > > > > +		clear_compound_head(page);
> > > > > > > > > > +
> > > > > > > > > > +		new_folio->mapping = NULL;
> > > > > > > > > > +		/*
> > > > > > > > > > +		 * Reset pgmap which was over-written by
> > > > > > > > > > +		 * prep_compound_page().
> > > > > > > > > > +		 */
> > > > > > > > > > +		new_folio->pgmap = pgmap;
> > > > > > > > > > +		new_folio->share = 0;	/* fsdax only, unused for device private */
> > > > > > > > > > +		VM_WARN_ON_FOLIO(folio_ref_count(new_folio), new_folio);
> > > > > > > > > > +		VM_WARN_ON_FOLIO(!folio_is_zone_device(new_folio), new_folio);
> > > > > > > > > 
> > > > > > > > > Does calling the free_folio() callback on new_folio solve the issue you are facing, or is
> > > > > > > > > that PMD_ORDER more frees than we'd like?
> > > > > > > > > 
> > > > > > > > 
> > > > > > > > No, calling free_folio() more often doesn’t solve anything—in fact, that
> > > > > > > > would make my implementation explode. I explained this in detail here [1]
> > > > > > > > to Zi.
> > > > > > > > 
> > > > > > > > To recap [1], my memory allocator has no visibility into individual
> > > > > > > > pages or folios; it is DRM Buddy layered on top of TTM BO. This design
> > > > > > > > allows VRAM to be allocated or evicted for both traditional GPU
> > > > > > > > allocations (GEMs) and SVM allocations.
> > > > > > > > 
> > > > > > > > Now, to recap the actual issue: if device folios are not split upon free
> > > > > > > > and are later reallocated with a different order in
> > > > > > > > zone_device_page_init, the implementation breaks. This problem is not
> > > > > > > > specific to Xe—Nouveau happens to always allocate at the same order, so
> > > > > > > > it works by coincidence. Reallocating at a different order is valid
> > > > > > > > behavior and must be supported.
> > > > > > > 
> > > > > > > I agree it's probably by coincidence but it is a perfectly valid design to
> > > > > > > always just (re)allocate at the same order and not worry about having to
> > > > > > > reinitialise things to different orders.
> > > > > > > 
> > > > > > 
> > > > > > I would agree with this statement too — it’s perfectly valid if a driver
> > > > > > always wants to (re)allocate at the same order.
> > > > > > 
> > > > > > Matt
> > > > > > 
> > > > > > >  - Alistair
> > > > > > > 
> > > > > > > > Matt
> > > > > > > > 
> > > > > > > > [1] https://patchwork.freedesktop.org/patch/697710/?series=159119&rev=3#comment_1282413
> > > > > > > > 
> > > > > > > > > > +	}
> > > > > > > > > > +}
> > > > > > > > > > +EXPORT_SYMBOL_GPL(free_zone_device_folio_prepare);
> > > > > > > > > > +
> > > > > > > > > >  void free_zone_device_folio(struct folio *folio)
> > > > > > > > > >  {
> > > > > > > > > >  	struct dev_pagemap *pgmap = folio->pgmap;
> > > > > > > > > > @@ -454,6 +508,7 @@ void free_zone_device_folio(struct folio *folio)
> > > > > > > > > >  	case MEMORY_DEVICE_COHERENT:
> > > > > > > > > >  		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
> > > > > > > > > >  			break;
> > > > > > > > > > +		free_zone_device_folio_prepare(folio);
> > > > > > > > > >  		pgmap->ops->folio_free(folio, order);
> > > > > > > > > >  		percpu_ref_put_many(&folio->pgmap->ref, nr);
> > > > > > > > > >  		break;
> > > > > > > > > 
> > > > > > > > > Balbir

