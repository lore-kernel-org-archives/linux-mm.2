Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8478FF885A
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 06:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFD3A6B0088; Fri,  1 May 2026 02:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAE796B008A; Fri,  1 May 2026 02:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B75DD6B008C; Fri,  1 May 2026 02:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5B1F6B0088
	for <linux-mm@kvack.org>; Fri,  1 May 2026 02:28:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B5868C032
	for <linux-mm@kvack.org>; Fri,  1 May 2026 06:28:21 +0000 (UTC)
X-FDA: 84717871602.11.AF4028B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf08.hostedemail.com (Postfix) with ESMTP id E861A160003
	for <linux-mm@kvack.org>; Fri,  1 May 2026 06:28:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=b70NL9Mz;
	spf=pass (imf08.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777616897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jz3oaff/x/3Z5v0YFyguA7nWKQwM+G+t2jcU9wl/W9E=;
	b=qcmxB8VStw1xeQ/4vMiEmx/NJMiGf4K9d1/nOiXHkBcxMDHaFeE0nZ8KIdkmlpAk5tgh48
	PKeUEuTFbrnYw4iXQKV13jjoO4S/uk6qlu2PqLfOTe73qPPNOwnwf0woG3Pe3kLm8dUjRM
	bwMk2pKHIrpESpDUeWzJbblnf9fYf88=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=b70NL9Mz;
	spf=pass (imf08.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777616897; a=rsa-sha256;
	cv=fail;
	b=CCJEeOadgw2kCatpIiNhuWKvv1Kp9C7xq8vRhag7GB4SK0sf402UCA04Tf5/WULoc69cg2
	dTJ8vDoqcQjONxwkwTGWDrhQM6LJTmkJTQPmx2C1RWfEOOoPrbfnj1UdSQ9egb4jCN2vQb
	Im9Zwy6VxU5/ja4Rqi6pMienfEADOqg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777616897; x=1809152897;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=ZojGBuk+Lj2e7UnJ2m9lEv7gbbi8PYeIJyWufk7VK38=;
  b=b70NL9MzUx7BOUkjNoQJPMHqb6kMG3/hPqcwMI5JAWghyXmvI7cmHQqw
   b1S2zpusOZRS1GeOIzZa4/gPV6o6DGtdqlYmgZG4mjhRmuCrbYkpLkakM
   0Pao+2RMS5l8BGc85ga+RgQu/dPTSgc2oZOUjaVOaFXUZ2ozXhURwyRJ8
   flHOZcSyvCDfxvJt6a8cYq5iJqxU3UXmMlvTTqaBnUL424cO8XUdWLcG+
   AB81RFmmM+7cRE1lO1qFljx0DsK/mBCsHM+TIesXf2mzdJgF7A2MPkGMI
   MJSTQ+c7RJ3PAj9C4OiWwxO8/Vz4HepQZob3nnwh/oBS+DOjek4GOMafo
   g==;
X-CSE-ConnectionGUID: /tpS66t2T9OYWDNWbeyicQ==
X-CSE-MsgGUID: ibm0s0P/SRCTk16i4o9/Eg==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="82186848"
X-IronPort-AV: E=Sophos;i="6.23,209,1770624000"; 
   d="scan'208";a="82186848"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 23:28:15 -0700
X-CSE-ConnectionGUID: rwdNYWguRXyS/mGLkejTNw==
X-CSE-MsgGUID: lI5TxS3nRRWbHzb3BZBssw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,209,1770624000"; 
   d="scan'208";a="234855057"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 23:28:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 30 Apr 2026 23:28:14 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 30 Apr 2026 23:28:14 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.31)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 30 Apr 2026 23:28:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C512PChmntfh/JraFSg0QVBIK1ch3Eef4VBC06damNNRklQCsxbf3XEngFyOBwBCLkxWMu2Byi5CU8bMxvw8eKykWta164lApxPa7Nnis7X5ONhKPAoJlyUs8wZ/gTKkvhz2tc9Sepf6vLWLsxJBhnWRI9B0iLduNvZmdWsvM1d5aays0n/sj9hXdiKeN7sp6DoSr0WrJywib7gBQ11VsWB12/xUgmpA0UixQMZrjfcodlC2Adbi+0RedjFXUv9VFB+lcf3ublgzF1Z2cGcQdCgA87saECmTB1wWDqM0sy21+i3PG5eyv1Sskwhr1Mv6ysTnCayKSJgtgrBqfCDMVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jz3oaff/x/3Z5v0YFyguA7nWKQwM+G+t2jcU9wl/W9E=;
 b=FOO2ZePuN2LdfxSXD8IS+zBRqgc57XqAwpKWbnzKl1gcpFWK4Jjpl9zVxZ2uyE2SNY5m2klXLE3yGAmavelPtq4xxWsER93ex6eBvxvNsqZ2gs4r6L6hyxJiZW4BLtTWjCU2xP3r9GY7pT+brcqVyL7WGjQU+cwY8ergSJcXs/3NbtqdPLJ3lQWZmMD1YqDXi+Geg8+p+g4heYxEI0FV7N0Zj7LJP2hcq4EWiHL57RESZsk5uM5kMq45amReRgQ3cMIKxXWTVK1iSWFLWMBdt8FCyiWw5Uztv2JTxfRE0bFEHH1+ll/RVM0baxFbLePHqWB/r0ZeFaUCQ+LWqrrhCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by MW4PR11MB6887.namprd11.prod.outlook.com (2603:10b6:303:225::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Fri, 1 May
 2026 06:28:12 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%7]) with mapi id 15.20.9870.022; Fri, 1 May 2026
 06:28:11 +0000
Date: Thu, 30 Apr 2026 23:28:08 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, "Dave
 Chinner" <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Tvrtko Ursulin
	<tvrtko.ursulin@igalia.com>, Thomas =?iso-8859-1?Q?Hellstr=F6m?=
	<thomas.hellstrom@linux.intel.com>, Carlos Santa <carlos.santa@intel.com>,
	Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>, Maarten Lankhorst
	<maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>, Daniel Colascione <dancol@dancol.org>,
	"David Hildenbrand" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
	<vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/6] mm, drm/ttm, drm/xe: Avoid reclaim/eviction loops
 under fragmentation
Message-ID: <afRH+KUNw9zap4sp@gsse-cloud1.jf.intel.com>
References: <20260430191809.2142544-1-matthew.brost@intel.com>
 <20260430160105.a3b74ec3bb316bbfbf8f9808@linux-foundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260430160105.a3b74ec3bb316bbfbf8f9808@linux-foundation.org>
X-ClientProxiedBy: SJ2PR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:a03:505::28) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|MW4PR11MB6887:EE_
X-MS-Office365-Filtering-Correlation-Id: 629a5b77-bee2-4af0-618c-08dea74ad161
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: +5tbvZ5Ri6VP8NzbwLY+lnJtXiJ+IdPGiBK5FoDC1NxaOwBYYqUw9YlrRfyqRgcdDLUVXEpF2Eecd/j1YQR9fFAqn0jotZxKIwdCkdWtl6178u+RnBbHO6J2NGSTd0sZpWjlbKWNi+mK/EHPhJb8Ytg47HSh4NqkbOB2OzNSiRepj9Vmz6DmVLU3uvqhVyUAOFXaAZjdzyZBWJtu9O3UbN7bMVeAK3UPfCIYC0IVyXmS0WW/4xntFWqvKwkjqKPp5cKn4S/WkTJJD1tQVn4bZuJe/wlGsIK55/wqw7TEWw4/Z6XSQGIEPTiuxUlZlLC+nTgBkfc3r8t6Qz+Sz29qm98sftRiiW4/8e4a3rCjYekyO82nqxqoeKsuGECAVVM/aQg1y5HKq3s/IY+pmxaZYSWsSASQXlsc06qA1NxYJRgkMc4lAlg25V7FsWSw9C2FftOvwXMihf2AI5Iv4uw2J2iBWdZ0IKEmk7fPNgtVmU6yPhgzbhD30Dw2bGN8hnkq29S7E4d81U3K2nMvIOmfSxiJrU53O5rvVn6AntjFv1WHfVum7cSha9U8UN/3clFTjUu7YWreyyI9aEmYWJQo+/GNYZAFzHOXwE16v3l0EIMER+xuEHPV8fxccNYpl/6vJ/08SmQM9B23a4iMjfYfdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1RGRmVMdmtIRlVudjRPQmJYazBlZ21DeEtwbkJSZGU5T0xzS2E4Z3pJVEhy?=
 =?utf-8?B?bHlLbXJOekZxUi9MOEdRWHNrV1lvRUNqMmMwSkZ5NjBhN2ttdzRPNVBzR05h?=
 =?utf-8?B?aVNrSzJISDEzbzVDR21kVzMxUGllMDE3blprSGZ2Nkt2allicGJXZ0J4eEVt?=
 =?utf-8?B?d3E5VnQwTFptTTZOTS94eVVZdHMzVFk2VTl1UVpLRHd1VU1nMVNGdzBHWEhJ?=
 =?utf-8?B?bkNidmxPcVVydWYxNmlkSUJ6SWxlQjVFQ29JUXhkVjlXUXVGcFk2YWlxMHdv?=
 =?utf-8?B?Q2NUYkc5VVN4ZkFsV0tyUWlsK0VFTlk2TGJKMTN3MXZRZVNXbWsrR0ZsT1l1?=
 =?utf-8?B?TEZ2VXJWK3NDQkR0aTcwUExES2doekt2NFdFMnNraHg2OXh3eXpvaWREdU1K?=
 =?utf-8?B?UExZOGhjdWwwd2t6bnVKWWsvcm44V0ZDY2IvbHlCeTFaQVhDaEpaV1ZuZ3JQ?=
 =?utf-8?B?MUtFcHArOWRzMzhYdC93dFFQYVM5VUVFSStiRlBqRlVNTjNnc0R0M0ZIN2lN?=
 =?utf-8?B?NWZMakxncEJWVHNNYzhpK25TeVN6RDVaQTZxMEdhYUg5akl3NFZqR0orMms3?=
 =?utf-8?B?aXF6OGU4eUN6cjUydnVWT2RUS2ZaelRRcXdXR0xVOTRuWFBjZk82cUNGZU5h?=
 =?utf-8?B?eUVDK29VUFRITHdEaEVQczlqQlc0UWZNdjVkMmp5N3EyZmluRXpoNGZEdVRz?=
 =?utf-8?B?ajFrVjJkUEgwUURFY25kc1p5VjBNMDVWRUtRTEx5aTNYNVpOcXFLaDA5SFl1?=
 =?utf-8?B?d29pMzFDVGtaSXZpTUd2V0pETlllRVdFeDJtOVcyNjhqQWVabzFpYnlreU13?=
 =?utf-8?B?WjF5Y3I3UDgvb2xPdEE5V3U5dFVSOHNXNEhLOTZCYUQyWGU3dWNhMy9uTEk0?=
 =?utf-8?B?THZLblB2R1Y1SWR0Mmlsa1BBaitVLzh4OHlBWTMyaXFjL0NmTC9qYUNkUTZL?=
 =?utf-8?B?RUd2ZWYrOVl4VW1Bd1N4VnpIRHhmTCtsQ0ZTSUVNbS9aUGdwc3gzdmdzRDB1?=
 =?utf-8?B?alUwUVdLeUY3eFFUWDMzOXNJNXkxN294SEh3WlBVZ2VHMGtzaWd5SVVoRy81?=
 =?utf-8?B?ZXhDZUlGV3BlbTVsbEdtN2U0dTFDaG8yOGxhY1ZYN1dmYXdnQlFGeEFFZUlG?=
 =?utf-8?B?MWh6Ui9IOGE0cWZZWExWUEZZQ1Z6cTdRZkRxZkxvT0JubHdxbTFiM1dneDBB?=
 =?utf-8?B?aElzRDFSYkZUWFFnUHcwSkJZSUJMSHBKTGJ2c2xxR09WRENaSWRqRGVrK1NP?=
 =?utf-8?B?L0hCR0YyajNMSEMxYWNpL3IwdGhqS25UUHNlWnRLWVhXTTlHeU9COVoxbUZ2?=
 =?utf-8?B?Z3ZJTU5PR3IzWEN2azBDOGlSdTllc3N5Ly9lMUVIU0pzaVZVOWtDTzl1Wmhs?=
 =?utf-8?B?MlpqR1BlRXBFeGdIbU43TVFkZVlVUUIzRmFtOUpRa3RpNk9tM0pPbXl3bStx?=
 =?utf-8?B?MU90ZkpJVWZ1cWdxNkh4KzcyNmp1R0Z6bjFPRlpHWWhPa0tVMGJqVFlHL0cz?=
 =?utf-8?B?UUowRTVSSXJKQnpFWjhqZFBhODU2NjhMWGVLS2RGL2JLS3VJR3I3eVoxc0JX?=
 =?utf-8?B?WHE1VWJTQnFlaTBoYlBKZTRMOUpNVk1vRU1keUw4bE93SDBEcUlFaHhKSFZo?=
 =?utf-8?B?U0VnQ3Vtc2VZdGJxYUtPaS9WK2huUjZJbWEvWDlXeWJyNnljMVdZLytHTFpM?=
 =?utf-8?B?S1lKSWNwajhQZUpTVmdBSUhtQ0xqVHdTMWRjdkJpdWxTbkVhUmo1bHhYdERo?=
 =?utf-8?B?WUo5UDIvVGF2ei93U2drK3NFTWtWQldTamxkQThCeW5tQ1hJUVpJTjFwaDRL?=
 =?utf-8?B?TklJSEs4ZnFTWGxjYlFXcEpvV0x4SlZLM3hEa1R3VHFrcXRmcU9VdVNHd2RH?=
 =?utf-8?B?U2RuZXhNV3dRcDNHRkdqc1YwTG5JNEJwTzVUQWdoZG93WnVraG5zRmt5ajZ6?=
 =?utf-8?B?MTdjYlEwckZySmlrbVQwa1U3Wmhtb29CSmlFMnZ5YnFXNVZZNDhya01Dc0wz?=
 =?utf-8?B?N3MwM2REeDlWbi9OTHd3YjAwQ2lXcE5UK1IveHh2UWRnQkV5OHIzUUV5eVhX?=
 =?utf-8?B?MG1sQ1hUS3Fjd1RYSXJic281WWFzamxrZ29MeHFwWUZPTWtvTjdtSmhZMEN3?=
 =?utf-8?B?TmR2aXd0dG5tWGtRVmRkaWFsQWt2MmdIZi9LNHVRKzVaQzlHWWp2T05VUENS?=
 =?utf-8?B?OEZwTE40Z2ZwVEtGc3VwUWlZK0ZQTTZOMFMyS29rZHJHSUpjZDBwelFZT3Yv?=
 =?utf-8?B?VXAzN0p1K25maU5VVnlvY1dYOTZGTWJDOWtxYnJia1U4MkhvZzBLRlNDZGl2?=
 =?utf-8?B?eVMwcVIrdVk5cGlOYzBibHhBVHQ5aUJWYW04MEJWZnU2SkZhaGpHdz09?=
X-Exchange-RoutingPolicyChecked: HKrRE1N5Muc4ryYi1ta1iUmfhSD1AJ2Hkpmq2UCpWRLxzIi0CckzC8gSdkO/gpUFX0RpKKlgVmumYVKWo0UhJwFmJvOw/TdW+UJSPkRrkzzSYzjkPQOCsdgMxpADe2+6R4dbhPydmj3iwSmn8noji8zPr4lS/mRQOakX338kKSIK1SJ4DMj3zT/u3fa41rVC6oCyrJyFipdTeWVX+Sj0xXvdaHvuFhUn+3C2EV6TUZ7+vzHPuvub7wS7dyn1qVt9YQBlWHCWhPN8D0bOdU2ILB9HVj0f670P8bCeWwt0rTpzcMq3WVUg3EiGqOrwT/dfsKkGg7lYKWdXvLAHwjpGzw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 629a5b77-bee2-4af0-618c-08dea74ad161
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 06:28:11.7264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m6lWkzdsWLr+T8VjFBZFFS5vsslbmwKxDrE2GcgabKbOt32ZzpkH1r9svDwEVeBkwFUWJFqE+47yL4Xq4UvGSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6887
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E861A160003
X-Rspam-User: 
X-Stat-Signature: 863r3jd5citc58d6416rxmwj9kub5zxt
X-HE-Tag: 1777616896-801139
X-HE-Meta: U2FsdGVkX194PmAF2a2Dl1RkhrE8S6800N1Utn/rGJAHtTKiPPlTli9tVt/ozjvpw9xHMqsUmsFRgqX1BhaUf0Lm8Rbebb9BVmaGgz5g8aY4v5PCePzYFgYNUGbWbEN2kwybSyd6n7AMBMNo4qoz5g61EdzLC6IC27eA6hxPgF9a77gWysMSvR74ZOlsOesf7t9uXwfSxm+4p/pSy8lJ8emW6OaOhAiZshJs7UtcZOcKyfX3QJnqM1LTWS5u492lWLg1H28LgMMr1/MU2JB8mFhLqiiyI4in4ZZ+aWq930ndGpLerWkt07hRREV5HZqg+SxqqIBPa8i3TKqweAl3e5QqWN5SeyNFMdEcQAEG42phxW5KQAlhzB9oIw0NEoNu9sjjs/UCltC/nilDIxy03PtX9Mn6ovJHosYh3TwsB9Bz8Z7Zz/xyJSsduvkNC1RI6r+7/P/vF5a1EX929i4wTR90fYOom00qUeZS0HiUsBmXhZxkncfqDuNoVd7t3ghpzlB2ByVcW5n5iYbo5r8Qu+Mxp1MraDDdQ0kvuBLT/10x895xeV58e2T0sn7nbmzNnWNolJxHPgOQpFjkXpqjrxlaz90em+H0VQSi5dTWZve0YM+tnP/8xT/wH1NsCvy33cn/OupI9FD9yG+5ipt71V0YNS8OvwrTzcqq/6sne+BCDyIiAQ4D3Kunv9YPcGHUNC5LXzmH2oF45esm50eU60ZDR/x3ruH9/9EnC5dvWfzny2bZvLY/xp0W7JIsj/LzuydR2vOYDACN5cEMLCTnQ1T5t8eQv0HzEOENzvfqoz1u4G4bSp/KAZt2IFVEdEn/OGnwik0DYgZtCiRsiumYXaUcwPRZNwc1/KqgqFvvJYdlZGz9Io0YPC8F57sILvu32AOk1GPxWjB+0LOg8Q2GsBtOphQIhfz3kOKqfTJSnJ16Xs6CA2ZHRTVeIoUbLl4kbLUrVkCQ8AS/8lIj3ew
 2dDDXBUu
 aPZxQA5AyXXYeDvYum8Z+aSwt9Tp/8v0XyXjM368KRq1lDIviI6Jc5bBr98nr2dntyDFOacHw+tuZQHccLJXASOHO/8NQdqAwu6lJqBPtYsM4vGObQAU5KrIC0dKuNl/mGkWoYlMGY7+vaHov7tR0UeDoYpwLK0MutSupAe98bBU2jXQczInM2LRBj1IuOVrUfQNJrDoNhG2WXHkRrjVbJTbp0PUtjbzKYn4CqdMff5VKkU/pOATKXaqbRrxRHJmcp93QthXwWhoQfd6JM8qVPiBs9sQoZ6ZHsUbOuR0EpUS09gGqLGVm5QAscstD/9yTIoiqab0fFKKx1XTGicrvdeuRVMTmfkoS0bzBVmcqxX7GSOoQo+G8vRPMPM1q2N/JQvOreUxoVUvMId1Z4tsQaCMcQhl5pwHA1N8XXCscnWmc3vyRs7QZL1fkcMxgfexFRGtUZCqzxB78h7S9HEOIRJfW4SJb5HoSAcffqpfYlC3UcsRCfCHhl6GUCnWNswQPa3xPHV9fF+6gtYnxqySOc50zvbdE8avv3NlXSUxJjFs+rOpgkeVA/G6Sr9Z4BYSujXVELrdzQBDA+ijQuIUW6VL04g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 04:01:05PM -0700, Andrew Morton wrote:
> On Thu, 30 Apr 2026 12:18:03 -0700 Matthew Brost <matthew.brost@intel.com> wrote:
> 
> > TTM allocations at higher orders can drive Xe into a pathological
> > reclaim loop when memory is fragmented:
> > 
> > kswapd → shrinker → eviction → rebind (exec ioctl) → repeat
> > 
> > In this state, reclaim is triggered despite substantial free memory,
> > but fails to produce contiguous higher-order pages. The Xe shrinker then
> > evicts active buffer objects, increasing faulting and rebind activity
> > and further feeding the loop. The result is high CPU overhead and poor
> > GPU forward progress.
> > 
> > ...
> >
> > This series addresses the issue in two ways:
> > 
> > TTM: Restrict direct reclaim to beneficial_order. Larger allocations
> > use __GFP_NORETRY to fail quickly rather than triggering reclaim.
> > 
> > Xe: Introduce a heuristic in the shrinker to avoid eviction when
> > running under kswapd and the system appears memory-rich but
> > fragmented.
> 
> Please cc everyone on all the patches?  It's kind of annoying to have
> to hunt around to find out how these proposed changes will be used. 
> Personal preference, anyway.
> 

Will do - we discussed this in the past and thought we landed on Cc
everyone on the cover then individual patches but will blast everyone
going forward.

> AI review flagged a few possible issues:
> 	https://sashiko.dev/#/patchset/20260430191809.2142544-1-matthew.brost@intel.com

Idk, who authors sashiko but what make it really nice if you could reply
to it to talk things out.

Looking at replies...

- 'Could this global counter drift significantly'
	this is looks right for multi-CPU which isn't really the target
	here, but will adjust

- 'Additionally, does NR_FREE_PAGES implicitly include CMA pages?'
	this is looks right, will adjust

- 'Can high_wmark_pages(zone) evaluate to zero during early boot'
	theoretically possible (?), but non-issue IMO, certainly a GPU
	shrinker which is current use case this is impossible but maybe
	add a warn_on if high_wmark_pages(zone) returns zero

- 'Is this description accurate?'
	I inverted the TTM kernel doc vs the code, will fix

Matt

