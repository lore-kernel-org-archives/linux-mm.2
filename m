Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8982FFF8864
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 07:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD88E6B008C; Fri,  1 May 2026 03:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D88996B0092; Fri,  1 May 2026 03:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29726B0093; Fri,  1 May 2026 03:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A68BE6B008C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 03:09:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 619CC140348
	for <linux-mm@kvack.org>; Fri,  1 May 2026 07:09:33 +0000 (UTC)
X-FDA: 84717975426.04.BFA4D56
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf07.hostedemail.com (Postfix) with ESMTP id 991F44000C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 07:09:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NpIYB177;
	spf=pass (imf07.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777619370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=szDM6KSxo2KfKFOfzHuCtMxAoiNKFkii01Vci7kbHBE=;
	b=IYbq4apVrbIQRnrIRuPrkjMZ9NOqjxGe+qL+iQj3I20PaC3Uj63OvKmGgFbkKF/j1PNxup
	+3JggHbD/bGsPyl3XnWwWcSVB3t8jJiZWOmndXpr1G4zs8+mq6iaPxL8XQ9B+85s5tR3FC
	UwLHiCbPshdHQzTW6vxM/gs3VCCaLdM=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NpIYB177;
	spf=pass (imf07.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777619370; a=rsa-sha256;
	cv=fail;
	b=3lVeA6M5qd66oZ0CZ2uBl0zaBrQ3Ude4amEGaezoB0X8iCBcGiCXGsQJxaLGqcDQ5ifo/G
	RCXxfcrSXSw5g2Cdgnb7Mz+Y0i8rG9HWF7SI8boWfi9xnDdu8hiWpefhD42oJFFOEutMnK
	E5Tjt4Bf7xbhN5fbHbls/QdDYIMcXls=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777619368; x=1809155368;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=RJEZO2sJKGvqGlQS24CweENDdN6W6EZ7hnN2r/OsZSk=;
  b=NpIYB177FToIziqe8KQdhG/tlLLD5ebrfo/oBZFeBsnfp7qbRCZAyJk4
   AdD0Unh9JRntjRO7JYK4odc4aOWN0R2IQmpVxNO7Vu8PGvd3NP56nsffR
   0wF82MHSRXRHpUZJp8LSYrxddJ6DPuCF+v5Bv7hz5SgU4PtbqWWQQMZFV
   PHhBnBgIdSgo+BjTwgQTqSafADKQWs+4l+SUf+/Tg037tjfxpgE0b3p1R
   7SBI567d6pE/9t61CF12OMjeQDIeWdglcbIn6qnlqVBmtR1/Ez1yxxeD6
   Gy4UhaUvAsjIWHZqPiw95xo3PLCYj/ZjU8AFZIzHPjKygCd/HWrqv8O8L
   w==;
X-CSE-ConnectionGUID: yrcand0GQ8igWJkrV49WrA==
X-CSE-MsgGUID: aAJntCxlQkmRrZwFgen1kg==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="82437214"
X-IronPort-AV: E=Sophos;i="6.23,209,1770624000"; 
   d="scan'208";a="82437214"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2026 00:09:26 -0700
X-CSE-ConnectionGUID: Vu3HT3qGS12OPfbAmZnf1A==
X-CSE-MsgGUID: Ism16KGCTAG1qaiurgxefw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,209,1770624000"; 
   d="scan'208";a="236598114"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2026 00:09:25 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 1 May 2026 00:09:24 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 1 May 2026 00:09:24 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.56)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 1 May 2026 00:09:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z6cGkpx3oU/50oFv1m+WWB0MCbSW/PNll9D1gXzS2KxhDx1S8sYW0mZpLGj+15Ty2AsWdAE2nV2odkP8rkXjrZwu03vLOCyvIp17tddtgDDmchcn5IG6g8P6BoP3R7SKONoXDRpAFIx3PLiFqvnKJKfWdCR9VXRRGRvK4kFe5i+gJOd+5XrP0LPfC6Qf8Nv/EXyCpD5geXJYxWdicKfdA2Yk/E2dE9EEtE4/EaIG5JCxwJfZty/kl9MFswIQ5iN4Ikw95cJZwTmqmRJsYZjqHWzDGhnMu8rXfUUjNoR6yYz8GMaLMIK1vKzogx+yEUTuBfgKHsa8CALbF7wKEE0FFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=szDM6KSxo2KfKFOfzHuCtMxAoiNKFkii01Vci7kbHBE=;
 b=PRatQduqLWw7SGqiEAqDR/FvRhChLoLwzupU8nrOF7pZIfECH4BdQPVztEm2M83QB+44LV2K6yQd1REQ5FcR02d4ooRDlxpvS+EtujlUcZ3Nr1r2OcRuk4JhQo4pbAVhjXwnarqAl48qn65ho3iKZFKTtCszswmFuQiNv0OMNGUA6Lbc3CUSssKEtoqwAWCDA7+CgWoBN61SD83//o8i6SSmnX+KyKC+bHSZ0NREVazreolhSyZAfgydRutCNcvJKPL6CgAYzQbwm/NVsBp6iK66wF5ZrXTCfZ6R+aARuSDXTEwe3AoOzG+2SHD4fX1/Rd9DX0M0WgaS02mOSC7qrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by MW4PR11MB7079.namprd11.prod.outlook.com (2603:10b6:303:22b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.23; Fri, 1 May
 2026 07:09:14 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%7]) with mapi id 15.20.9870.022; Fri, 1 May 2026
 07:09:14 +0000
Date: Fri, 1 May 2026 00:09:10 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Dave Chinner <dgc@kernel.org>
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
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/6] mm, drm/ttm, drm/xe: Avoid reclaim/eviction loops
 under fragmentation
Message-ID: <afRRlqA2bdZVoWAi@gsse-cloud1.jf.intel.com>
References: <20260430191809.2142544-1-matthew.brost@intel.com>
 <afQE-2JOzfOm8enM@dread>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afQE-2JOzfOm8enM@dread>
X-ClientProxiedBy: SJ0PR05CA0172.namprd05.prod.outlook.com
 (2603:10b6:a03:339::27) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|MW4PR11MB7079:EE_
X-MS-Office365-Filtering-Correlation-Id: 710b5948-8105-46f1-623e-08dea7508d25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: uLqhwztd2S2iwhCaobMUd3WxS0hWrDChTu+8x8ypPko1fNl3X9PrQ/fcE7oor2v6r4Y0/5/7lddJE9Dqi7DcvxRx/kxfq6Q8478SRN62Pn592JTIsx2/C6fSLEakdWKT6fbHixRwbfAcvd97OAyJ8tKhMarcWkzyRpOMMFJJ/ErbUZ5SGYH+BwD5eWdF2vDAYHWjXZOJiS8+3XN9OjW8DD/b8DpsMuQbyd4Z/2pyYnSnKenFsz7U3MAypLONCEEyLNbJoiVaN36JjDu162zLHc876vjhqP63lqyZ7snCg1KMLuVwarMY4nQLcGB53E+zJkM9vGsD3T89B3NNGQhAA5ymgnuWXwUdwGgM6DPrg+LliN0F+BXq5XWdhjU7QtQxdOD/O5hGMFKpcf5ubHYEcRN6KfYNVo1Hl7goaTw+LUhbWMfhy5CYjk9ZP0EkngYApoyefifV805zQZTOps33qTz6sL81EXGt13vdgmi32+x0r1bIt5lhRavu2c0WC54MjWH++zQlq70P68qhu+vgK4iohkzVsdP1jsR/XFftLQG/2pP4cBY+a+Fc9ij5zfHmtZC5NxBXw7CkDKvFrOdl1zR7M+yZZFt+EMjnLDzbAfzglsh9ffmCV6pOv/j/TJx/Cv3dWcIZFh1G0fM2872WZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXFac1dIMWR4Vm9JSHM3K0s1NDZxUlowOVE2dXNUaTRBNFlCTmhjNVFZQXNI?=
 =?utf-8?B?cTNzM0ZtbXF0ZnJKV1o2dHdBVnhsMWhwdG9yOWtteUVhN0lEYjBOTnd1Z3dR?=
 =?utf-8?B?cWRPSkJiR3VnK0pZMWxCam8rMDB0WUdBelJUNW5La2VseElWTDA4QWoyTU9Z?=
 =?utf-8?B?TkdaT2I5SjN4OVJtUHlFU21velZvNVZKL0JWV1QybWFCTlBiN0U4ZFJ4M2hu?=
 =?utf-8?B?WU1QT2E3U3NRVDc1SEJTZGkzZDFEWnU1c1ExNnNIa3k5Y3F4Mmphb0tqT21w?=
 =?utf-8?B?UEg5bGlQRVJ5dW0wL3RxZXZQNUpRUjlyYkN1djNLMG9QUmNXOEFNY3owKzdw?=
 =?utf-8?B?ZmZ1S0xMVEoxbWdTSTI1WURWbTlYZmNTYWFaVGttK1E2ak40RHFvcVZMUzla?=
 =?utf-8?B?V2pmRTBOZDg4TWZ1cUxzZjFRZUZaTzZpQWttS3hLMDZKL2xOZUxMbWtYbk42?=
 =?utf-8?B?elYrMFJ2TjdXcElaT3YzdXM4SVFtTEdKRFNzblJoY3p2QWtEb1M1aGdIV2c0?=
 =?utf-8?B?NitrSGpNR0RZdlB4WityaDdnNjM4bDF4alhhWEs4VS9LUWwvMTIrYUI0OTJq?=
 =?utf-8?B?czJkOEtmVXRrR2Q2Y2hCNGhkcTNaaDUzMFJUQ0RLT05TNDFPNlp0MnVmZlFH?=
 =?utf-8?B?c0wwengxVlRLS1hRbHQ0Kzc1bDRWV0hoeWE2eTZ2dWxyTW1BRnFsWWkwUmtU?=
 =?utf-8?B?NHNuT3B0cGowaC9ieEE2Z0NhYWQ0ZUdVc0hJVmlaQVE4Y1piYnhhYXF5cURL?=
 =?utf-8?B?YWl1UTFDTTBValVUMXBwL203NmI1VFdhenpyOW1Od1BQbVVmaDF3NjVUc3JL?=
 =?utf-8?B?YXFLakNrYytRU29wNXBTaTZUczFOb2pOUUU1T2doY3pmdXZrLzF6NHpZd1pP?=
 =?utf-8?B?RkJlTWcrdHczQnhheWdtRHdnT09BWEJlbVhHVnI1NmVsRmFQTkx6cmxrQ2hQ?=
 =?utf-8?B?dUEyN0RxblhycmxjY1VNRWhjd2dnY3MyZGlEWDQ5eHgwa01maTF6bXJ4VEVN?=
 =?utf-8?B?K25jb29oY1lGdXluLytnVm1pWkp0eFk0M0xBUTk0RWNxc0lmeUw2dUppVkwy?=
 =?utf-8?B?WDBZbGJ4Rkc4ek1KM1RpMGpGaTZOcy8zOFFzUzFMOEN3RGFVUWNWdXFPYmI3?=
 =?utf-8?B?SXhvbFBDRWtma2RDK2lHcjJkWDl3dnpISXI4K1NwMG44Z0FLUytIVU9EVWNG?=
 =?utf-8?B?YXBTWXpKeXZVbk8zNlZDRDlMMWVDL1ZvMzRvQTFvaThMNWNFTDZOenkwWVFO?=
 =?utf-8?B?MFhmRzRsZnVJNjhHSVB6ZW9lbGNJVW5qQkxsV2VHV2I2SzBxNVlMdWZKYW5Y?=
 =?utf-8?B?S3EyQnZBUEMvaStBbXRWZVdmOEdrRU5zc20wZWlxSzFiTVJoT253MGp1NUFn?=
 =?utf-8?B?N25MS2VycWZNQ040eTdXTzZ4RzUwU01Pb3VGSTZEelYxM0dzK3JxQTZaa2VD?=
 =?utf-8?B?N0FtMGtKRzBaaWh6cnF4VkZOckJFUC9JWFJ5M0VsQytpbkdEdmszN3hkRVl1?=
 =?utf-8?B?QndoZWFWSkJvVXFyTTlsc1M0ZElRSCs0c3BhZU55K2tSQndFTC9XK2xyRE9j?=
 =?utf-8?B?eVpVeUk5L29sMWhpaS9QbzdHbDRtM2ZiL0l1eThUbG92MmMyRGdCbkRDM0w5?=
 =?utf-8?B?TlpRK3lZT2RPRGdhNEQvME13SzkvZGZ6UVBhV1lEY3BBUUhYSk9uMjBLUXdF?=
 =?utf-8?B?QzlVTmNiZzNRdmwwMlRVSmpoV2FGQkxkOGN4WFEwQm5iZ3FRTGFZT0VGQk9O?=
 =?utf-8?B?ZmwxNmcxc292clVHU2xLWndZVG91TE01N29YejJxdTRVUW9UK3ZBTmpmdlVz?=
 =?utf-8?B?RVBCaEpGelp0cWlocCtsUkoyeWxRZnJLZ1Njb21pbFdNSE5rRzg4SEw3NTdM?=
 =?utf-8?B?YmVyM1FtN2wzN2tXU3pURnFKMnFnbjZjWm9NZmJDTUJhVG1ScDB6NzJyaDVw?=
 =?utf-8?B?QTNsaityaEZHOHFSU1JpdWlqT3BEUTBLRG9QRTA0Tk5yaVhNSEkyWEpGTmRi?=
 =?utf-8?B?SEhia1JSejFtbTBNK1ZHYVpOWnlxUkpuc29PSmliS25GZWdFUUs4MUZOcGRL?=
 =?utf-8?B?aEl3YUJvaHQ0MEFLbW1lTWhKWmZyZnhpZGtPQjQ0d0xVOEs0NkpXdCsvanc3?=
 =?utf-8?B?ZUZWZHBTdDdUTDkwOGlORjEzU0FSdHlrODZxdExNTUF4SGFUdjhUdVFwUTEr?=
 =?utf-8?B?RGtySEhmYVNGZE5DS2VNOHZKUUdjSjdBTEpNNngrSmhsVFZMcnF2M2lOcDdS?=
 =?utf-8?B?MTlDWkpyVGVRcEtuSUFRS2k5SXR4Y1hldjlQUEs5dlV0R21KQ1RuMGdrNVhX?=
 =?utf-8?B?SStnSVB2Y1l4TnIyVHRzSUZKdGE4aFo5WU5YT2IvUk1hVDk4VGwvb3UxZEtP?=
 =?utf-8?Q?AaBs4Sw5xc3RJB1Y=3D?=
X-Exchange-RoutingPolicyChecked: wYaj6gxOg1nptlMrsEWWnDt+4PeMYsG5T0v0ebSeAlK0Hi7tbuT85Kw5gMJy9oJd0rJuf1aKGt53NTkXtKKHRll25yDVRuhYxn2/xui7kb9YLKlDQ9nnMvzAdJ3NaAg+OxnL6e/fFJAPYfnEN1Sifx0x3W7auZP3+iDfksHsYY5Iekb2HdRaATZaxrdQM4u6SKhiIcih40s0sHcFW8sR3E+l0usvYN1OXWzz+eH/mjCtpD83x8loSGVNocvboSUsgdaKdEH6OmcCu6B3ouILr91aC+gFVhp4KOraItE4PfNYV7Be3CCbYwJsdSzM2DubUaEcedUsidAxBIfyPyH8YA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 710b5948-8105-46f1-623e-08dea7508d25
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 07:09:14.2114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6P9sVdrF3GuskHDxAUQ6dENDrOxaE/1MYuGA3RPwE8z2vEdU+hcJrw3alu13H7ia4mZujCir2HSGkNdByi66ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7079
X-OriginatorOrg: intel.com
X-Stat-Signature: mxe9wd581opt5ujsr1k6owz76zoufxyh
X-Rspamd-Queue-Id: 991F44000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777619368-31478
X-HE-Meta: U2FsdGVkX1+RyqmUA3nrZiKOx6xObMqcbmJkmZo1YRE5TuIL/wNIUv660TQJOyRGvhYxPiotZ93z9rxLt1uKO/PMXJYxR1ayQpO15RPIook05Ejq074kR9JMlUn9CKaFtkGYCQZ1QliWPHXbOhujoxg4OVWRFAdG+vWSvLWxFhWo9yH/LR8rp2rgmJzZ+rxf9kJsKgQ+c/xbE4yB9lUzaqJOWHIAP4JtbyeJRei7FZTO3czrEAqsTtSiNTYK+PCha6EqB5EJj4RkOknonGAFWR1+Q6cxY5SISGEGi+qXvB+z7pYw7IWrV6z4WKVshjnXFMkhONYhVzdLSShrm779cCBXKKcFfJgFI3Z7BLIE+MHnT7r/LGbdheitOrUpJ9V5AxNigYLzERxWgBoayPvhb9fJ045TO7fFSn+jr47EqAwBUbCGbhudqswWEYBuzSG+YtOFC7Y6rXo22DHBvguX1iMxSV1BoCCT7riFsjoN/tvDQrW0Zvd3dCn59YnVas1BTeUyZyzCW34NCvx/GkgDD1DB6t6LzSUexNZl3sECqsVDXM9O8NySFu6otE8aTECrjDgtIr1noE4uclZ28v5qchGvr1I6r1ogHWGbzIZdI8tC56gT1LRUxENK6BVuJVTwGUyDS5qJbik7WuAgRuwmQSnd52HZYDzJtXQqousiy0fOGJqSMshYLQYj8EIje6S5sm2v9Mml9DirVJLFwEje8xpxkyDPROuLzVc4l6wqN25GUB3EhNK3UeRkofBvOxUwWfCjiqkIM0XfyzG2QmFDEKh2sze9RzVMQvoONfRwcwTQFE8va4V/0Au/l3cMJTmijG9e9ByXee6kaS+9QiPVtkjzjMePpzNLkbjEA2Zgg3oHOdxnQRDZYFKLi/XuY8/IbAIaP9tYGWHqWBGHw1Zu8CRab7ZXG+4nKDQtEgnaP1J435Undy+zaYcj+PzYvJuzrUaxCZPTRWGyAx8yA+g
 Qt/9JSEI
 zaUJn5S42cFVQ9vBvJyL500QvtD4Oyf6zV87Bvu7Q5qVT/MPRKJUxO2TV78hO/fFEUqE27sA6Bj6eJmLcU1OwZaDn/T09hDP85kn5bS9qmdI4Dn6Rav7V6QNBJaMNg2PE5qtfMIvlp4Qw1WEW0MXiTqDH+kOwwRPlfErKOcoQnWAJPbSThUAv/B+Do41g3/rspWSPcbmfAhPIouUbAPNGH9BjrvIsGc61csjjnq036RmGQnXaPFBgfrOy8al/nJZY5Zmc3xVXP4p3XdMC4iTd/y/H9pd0ski5xFMnHHyERJ9I57a5LCm5iYThf5GSAPdVbo7uOEVhgGehMsVS6PsVl+picrs3ZcdAin+2C4WBAx9KItfcUqBSXqP4dr6YpAAvUlYsSOesgOVMwFQV4I4sX6zHDvsFDdafiG3qeelTXJD2mHL/xPx094pE0huBeDutXyRujLswH92hUr8lRChWCDwAbWFiq4q7kKvkVsHAmXy509fN959Vo5fCMRIUjQnp/J4V6rCQD2og8laxHv5Jsf9of1I3edmjG67uIJJw/hwZDShW1wbAIi0URZPhYtYEILs3+vsXMe6YUIIFnmk7XbcOCtyyw37UdN5BFyFboAb0j8c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 01, 2026 at 11:42:19AM +1000, Dave Chinner wrote:

Thanks for the feedback. I’m looking into this more, and it’s becoming
clear that this is a hard problem—one that will likely require
coordinated work between DRM and core MM to really sort out. That said,
I do think what I have in place is a reasonable short-term fix.

More below.

> On Thu, Apr 30, 2026 at 12:18:03PM -0700, Matthew Brost wrote:
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
> > This issue was first reported in [1] and independently observed
> > internally and by Google.
> > 
> > A simple reproducer is:
> > 
> > - Boot an iGPU system with mem=8G
> > - Launch 10 Chrome tabs running the WebGL aquarium demo
> > - Configure each tab with ~5k fish
> > 
> > Under this workload, ftrace shows a continuous loop of:
> > 
> > xe_shrinker_scan (kswapd)
> > xe_vma_rebind_exec
> > 
> > Performance degrades significantly, with each tab dropping to ~2 FPS on
> > PTL (Ubuntu 24.04).
> > 
> > At the same time, /proc/buddyinfo shows substantial free memory but no
> > higher-order availability. For example, the Normal zone:
> > 
> > Count: 4063 4595 3455 3400 3139 2762 2293 1655 643 0 0
> > 
> > This corresponds to ~2.8GB free memory, but no order-9 (2MB) blocks,
> > indicating severe fragmentation.
> > 
> > This series addresses the issue in two ways:
> > 
> > TTM: Restrict direct reclaim to beneficial_order. Larger allocations
> > use __GFP_NORETRY to fail quickly rather than triggering reclaim.
> 
> NACK.
> 
> As I have said to the people trying to hack around direct reclaim
> for high order allocations being costly for the page cache, fix the
> problem with direct reclaim. (e.g.
> https://lore.kernel.org/linux-xfs/adLlrSZ5oRAa_Hfd@dread/)
> 

I read your response. Maybe this isn't clear what is going here.

At beneficial_order: gfp == __GFP_RECLAIM | __GFP_NORETRY
At order zero: gfp == __GFP_RECLAIM

This roughly existing behavior, the exact changes are here [1].

[1] https://patchwork.freedesktop.org/patch/722247/?series=165329&rev=3

If this is truly a NACK, then we can rethink it—likely by disabling
reclaim at higher orders—but that has its own downsides for DRM and
GPUs. Ideally, you want purgeable BOs to be evicted when a higher-order
allocation fails; you really don’t want to end up in an insane kswap
loop.

> We should not be hacking around a problem in the mm infrastructure
> by changing allocation context flags every high order allocation 
> call site that needs high order allocations. Understand and fix the
> infrastructure problem once and for all.
> 

Well, I agree that we should aim to fix this in core MM, but as the
saying goes, Rome wasn’t built in a day. The fact is that these GFP
flags do exist, and suddenly drawing a line and declaring them no longer
valid feels a bit unfair. I’ll also note that Intel—and I
personally—have an interest in fixing shrinking, so you can expect
follow-up work here.

> > Xe: Introduce a heuristic in the shrinker to avoid eviction when
> > running under kswapd and the system appears memory-rich but
> > fragmented.
> 
> NACK on architectural grounds.
> 
> Custom heuristics in individual shrinkers to decide whether the
> should do what the mm subsystem has asked them to do has -always-
> been a mistake to allow. The mm subsystem makes the decision on how

I’m not going to disagree with using custom heuristics in individual
shrinkers, but I’d wager that most shrinkers sadly already implement
custom heuristics.

> much cache shrinkage needs to occur, the shrinkers just do what they
> are told to do.
> 
> If we have a problem where a workload causes excessive shrinker
> reclaim, then we need to address the problem in the infrastructure
> because excessive reclaim affects the performance of -all-
> subsystems with shrinkable caches, not just the TTM subsystem.
> 

Yes, I agree, and I’ve thought about the implications of simply having
TTM back off when a higher-order allocation fails, even when we actually
have enough memory, and how that would affect everyone. This series at
least fixes the “well, there goes my GUI” problem.

I do have another patch locally that prevents TTM from accidentally
fragmenting memory and triggering the kswap loop, but under enough
pressure I can still get the GUI to lock up for periods of time. With
this series, however, I can’t reproduce that issue.

> As it is, I can't review what you've actually implemented because
> you only cc'd me on a single patch in the series. In future, please
> cc me on the whole patchset because shrinkers need to work as a
> coherent whole, not just in isolation....
> 

Sorry about this - Andrew just said the same thing. Here is PW link [2].

Or:

b4 mbox 20260430191809.2142544-1-matthew.brost@intel.com

[2] https://patchwork.freedesktop.org/series/165329/

If you have any ideas on how to fix this in the core, let’s discuss. I
have a bunch of ideas in my head, but core MM isn’t my native domain.

Matt

> -Dave.
> -- 
> Dave Chinner
> dgc@kernel.org

