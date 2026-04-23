Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5282FAD41B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 06:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49DAC6B008A; Thu, 23 Apr 2026 02:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44E626B008C; Thu, 23 Apr 2026 02:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33E196B0092; Thu, 23 Apr 2026 02:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 23F9E6B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:16:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 931DA16047C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:16:51 +0000 (UTC)
X-FDA: 84688812222.05.2116BA7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8433A80010
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:16:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bg3mmi+h;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776925007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yYj4utOR/2ORCuzsxgKV1M1p/J7aYD7p8B0A6oOviek=;
	b=EHr0FSytvcAisZVpCB197mGdLjtKd4mSCjYRNUMosdlXrjLF27XH3eJ/LJDJ+iFhErDEy4
	0B2cSau5PO7z+2Xfa3UaDVkDp6P6ZfGY8O6sJbuX0gyrMJcbbiUbULNzXJODOkrI3V3fAX
	jDN3Es/+Ftg5e9vIH3iIv/hLN2dsq5E=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bg3mmi+h;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776925007; a=rsa-sha256;
	cv=fail;
	b=xFGtl2GjitjjKQxbqzzfz4NCw23V/cXDOJQEMD5cW11hZPY8T+eXEoRPqmu2znEy3zg/u2
	eTeOtxpJI+D7skIWA0MuAffUrDZNIZXaomtN0lJ6PfE93rUvSAk4hGsY8aLWWvVSjHOW42
	7BOO782R59P0nv5eTjZTOkxi+L8NXeE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776925006; x=1808461006;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=3JI1/w5OnKaCmAB6eEAkSchtNe2/ENk9qynX0lzETDA=;
  b=bg3mmi+hY4UgVap7DBiOhCnp+Mvj9FsWglhc4Ev5htGk/kNLIN9Uho6J
   /HmsOyFFXxzBEJeiYZzeACzE6eBDTXk2BkbEv7cQfWAQN/2tdlgJJEvrX
   LKwa2vfUPjampX5a4mmgg3IZu0vYLnVahCY+LN1UT/SA6HR5ZAsvqGSTa
   aRRxx1YRiMnw640s4Fj5XGSckz5HvtEm34PQOogxCK0uPUhx/ecmPvRJR
   tMk1bPO3ExrunpNNWzjdv89l/8g61xCQcl8cjJwilRj8739frtLPGzFf6
   /MqDJVG6SIsUKroR/HkmF1UndxdNG8Ub13qilmaHQBJpu/YPgtA7ogstL
   Q==;
X-CSE-ConnectionGUID: owGTp+xhSS63Teiojms2lg==
X-CSE-MsgGUID: 5e462NZyS8idMwftEo7c+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11764"; a="89275696"
X-IronPort-AV: E=Sophos;i="6.23,194,1770624000"; 
   d="scan'208";a="89275696"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 23:16:45 -0700
X-CSE-ConnectionGUID: q93PDmAkTO+U66uWycQbyQ==
X-CSE-MsgGUID: Lv8emtX2TxGGwEjC74jcTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,194,1770624000"; 
   d="scan'208";a="232415756"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 23:16:45 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 23:16:44 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 22 Apr 2026 23:16:44 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.51) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 23:16:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g4Zk4gh5H97SJjrUHRPw2DzqbIIqOEi4ZD+INYMklCKtiKv2tY5+koZ+rT63Ekh3kTkXOuVSgB+v9NVhh7BRE91oOfXPSKdBz3tUk8s/G0J8QUtlbjURhZHgzPZtOMSz3acEZCXPXhsSCfqe0glDcPAzZFciy/wQ7B9riH7NSXPb3+cEr0gK9oIbdfi7JRUE9Q+HxPRfo0gY8vQh5TTa1SXI4zkk9amYKUAp/Ay9g6dXZqonVinUm+hpr/F+1Jt4NuiNfLnMJPP9QvIw3ixf27guAppW7sEqGM1EYIo/Hf2LDkEqxRQRVjtp0lBZeugbEjCEhue8wj0GrKK10j7epA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yYj4utOR/2ORCuzsxgKV1M1p/J7aYD7p8B0A6oOviek=;
 b=eNEIksG17xsSpYbm3SjYAfa+7CwuiRjcKQayzPyV76ZTFocv0nC4bovhWBcDAOSDYTi0iAt8Oaai4tsxBeCRoux4KJ8XTY3TUB062LtMJGUt89+vmBk9EZJLupaWcswleClcLGJxUl8/12JBIjOgxxB4iotglkQBWLILkd2tY2fl4PgznI0hlCMKMaUhsHiLymG3Bw4ZIG5yur2ua6Ge7/59GKFwa7E42LJJ/12spg7Pw2w9SYuxaSjr8tlw3Gw7lqKHHW4m01Q9V5v5c4ZCIUzoGoa+RbWJpG4w1xFTiPpbGKQqxAFfNfodkKuxteHEgTrgQEFTFvxRsMuOWZZriw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SJ5PPF1FF629472.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::818) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.21; Thu, 23 Apr
 2026 06:16:40 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%7]) with mapi id 15.20.9846.021; Thu, 23 Apr 2026
 06:16:40 +0000
Date: Wed, 22 Apr 2026 23:16:37 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Balbir Singh <balbirs@nvidia.com>
CC: <intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] mm: Introduce zone_appears_fragmented()
Message-ID: <aem5RcHbj5zcKbsw@gsse-cloud1.jf.intel.com>
References: <20260423055656.1696379-1-matthew.brost@intel.com>
 <20260423055656.1696379-2-matthew.brost@intel.com>
 <b0bd6cdc-511e-4fad-959d-3fa75c865aa8@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b0bd6cdc-511e-4fad-959d-3fa75c865aa8@nvidia.com>
X-ClientProxiedBy: BYAPR01CA0063.prod.exchangelabs.com (2603:10b6:a03:94::40)
 To PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SJ5PPF1FF629472:EE_
X-MS-Office365-Filtering-Correlation-Id: aac67cf7-6e13-4ed8-774d-08dea0ffe200
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: mLy3aJe+kU2fO4heCpvjyGHksV2NywbFkBwbqF6vpJS715LMjR58saVfbRsIcBjQmA5URN/m/p2cZg7Pur5gsW9FQBMkS/ZOHZ0MVKfxICxTGT+VW/PAyKXeXlovFFx8j2xKL5VHYMYPtnE7KEmvgMZUiLvDNb5i91BuobMtMjsfe48d2aPVZ9UtOL/5/w7ZsMbc+c/ialJ2hdcpQxGt+XD8hWlKESmHzJP8TQO2LUEGCHb+xxrHD1D02UAd1tUFUNe17Misb63wDDbdmGz2rg6dO6CSYLW+On0MXzY83abVLBfyCYe0YxhHQjDNQ3H6uZts0yVzvZOmoSammAPbmU/3f+qYo41JcjjSix7XWgLjbCeD3u4z1lpdw1B4I/oAo2uatxdpNp9KgZBTxuNTWxFHCWoZ6XMy1Rr6pTtdNZEi0NZB4mcmEweWAwlC084t3RbmjtkxlAFoHYkuw4TjnJXIF6KVpLcY7scU1vbKBp3MicR02mC78LyjVMGC+ncf92zUPCSRKlC3tgAeffL7ryyb8wzolxYPfL3/eqQ4gtKgu9j98dEFo0lJJFLbMNZuN4zwddaUBOO18pgTzBwUE6k1ZMWiNJ4heTujGG9/IoG43UCRptQjbXt7yibHJYVs6fa6R6QY2EBUFGdQr4GV25jSD19rYUZqRPqf18XHRujwlfJ2Ssm9qjOK4LhWAsMu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnUvSE1ZRkxnRVpWS2xnWHBROUFCTTk5bEJIU1oxWVNZMzVBQ0pBdStvMVls?=
 =?utf-8?B?ZHpSd3BOTlVQbnRJeVRtUWNUMllSYTY2V2dhQnE2a0FzanlBT3hhc05iZng0?=
 =?utf-8?B?R2YxQ09SaURjWjc5RWdvM2ppRmhXRjB4c2pDWldMTDhRVGtFNlpiclREbmxN?=
 =?utf-8?B?N2FDVmhaenNWVG1aMW9SNk56MXVnSVFvZVBSR1ZpckIwWEw3czAzN2RIU0I0?=
 =?utf-8?B?S05pcGlCSWF4WE5hMG1hRERTaGxKZW5qUUs3d1lVVmRjdG0rTmMvbUh5Rklu?=
 =?utf-8?B?bXNSc2N0cHFSblBQQXNQdkI1T2lYazdBcktlN21CVFNTNlBrREZuSWMvYUtz?=
 =?utf-8?B?VVpLZlFwb0VlcGhLL1hkVmFDSmlwdzJLbWc0ZlNCYnZyTzBZSjY0dlhXNUxz?=
 =?utf-8?B?VEJwZk0zdnQ4MTVWS0toNU9Pd3RIb1l5dHVzN3Irbkh1dVBaOXJWMW9LRmth?=
 =?utf-8?B?cnNVZ0RUVkdLZkFmWmllcTJTZTNTVVhHS3hMZFl2WVp2YjZpTFYwQjQ3TWEy?=
 =?utf-8?B?RzNsemRPeUpNVElMWTFFWGI5SGJqY0FMMTUyUktOVGtsQzRGOWlBcDVKb2tN?=
 =?utf-8?B?NkpBTHpGdnNQaEVPa0I3S0ZrWFJoVXpjd3hIL3R5MHNIWEZ3akYzSG9SSENQ?=
 =?utf-8?B?Qm9GaG1EbEh0U1VQQ3RlUzMwTVFsdGJFSVQxQk1aYXFNc3FPRzJIckM2VlRk?=
 =?utf-8?B?eUxzcWkzQjVtOTZIQUR0dU9IUnNUUSsrVzVISUpBMWdFY2NIOHBKWEtSRG5W?=
 =?utf-8?B?TlhnaWd3TUdwUTh5WU5Gb3VCMnRjcndGc205VFJ5L2djLzlvcjk2OFhkMW01?=
 =?utf-8?B?d3FLSzhxSEhnTkhlRFRQbFBVeW5BdTQwWXp5UDFzanFWM09IZ0w4R2tWbGpw?=
 =?utf-8?B?STEzZi85OENYL20zMGJFWjFsKy9Id01hNG5Jb0hCNCtoN0R0amxJbzRXN1RU?=
 =?utf-8?B?UjIzZis2NFh4d1dJRmUvekdmVXdGSFNybU40NHVxMXJ2Y0NEYkVWOEdhODlG?=
 =?utf-8?B?RlA5cjYvTWtCZG1iNVpnRHNkcHZwRURUTTFZaWpGdVlndmJxd0k0SkJLaGhl?=
 =?utf-8?B?WnBYMXJPNEEvaU1NaWphY0c5N2FZT3JuSGFoeDZGb1QycU92QnpQbVVIK2RF?=
 =?utf-8?B?elh5aVlsNm9FOEhQMmcwZ1ZLKzRNZzhzY0RqWXVhWC8yR0xvSEVIL015Nmw2?=
 =?utf-8?B?aDNPZ0xTQW14TlJnYjFrenpRREdRY0s0bTVCcitOQ3RjeHBWL2R3MlUxL3BV?=
 =?utf-8?B?ZGQ3N0h6eHpvRUNFdzVXcitQZ3BoYUs5aU44TGt1TzBIeWRCRG0zNFBOWnVZ?=
 =?utf-8?B?NUw5RDU1STRmc3BvMnlYa3ZvemsyR2lGRWFZV2lJT0ZFYnJTdXVqYjkxTWZZ?=
 =?utf-8?B?L2M4NEkzOGt1d2JNeEo3RkF5YzBlVWZ4K2JXajY5MkhKbTkrWEZtK0hJSzgv?=
 =?utf-8?B?Y1NLUEsrS05PaXFxTGhSMGhQZHRxSm1uQjF4K3h2SFZ6VjRvSWt4NndFQ3Y0?=
 =?utf-8?B?OVdMWTJOK1oydWlmZkdJOHMxTXNCZURWcXZ2RERKdWRicU5JVWUvTk51b08y?=
 =?utf-8?B?eWowZngrYXl2MFJvV2xqYkVtYjU0bGxoc2hLZ3lqRWdOVW5uUkVjTE1KT0Vq?=
 =?utf-8?B?dWx3RHpvaUVUakxTelVMSTZGVjgyem5TRG5aZll3LzUza2kwcElpVytGZklK?=
 =?utf-8?B?azRlWG5GNGtCK0RiOFdVQmRoRTlGWlRFQ2RabzF4cEVLNXl2M3hLVHdqTjVR?=
 =?utf-8?B?OE9VRDllNzNSYkJrcDMwZDliUmg3c0w1ejhLckNzTS9TSEd5d1pnQko4Vmsv?=
 =?utf-8?B?UWxKNXJRcHJlZ0gveS8vc1FadzNVNEp5UTRyQndyM2ZoNElZR2hOR2poSHZ2?=
 =?utf-8?B?aXlpVU95Q1RsTzFOSFJOQXhKUFRXV0tpR1pGZVkvMWNPY3ZuTDE4bXNFVzlO?=
 =?utf-8?B?MlphZDFVbUR3dDJNQlNOU3lGRHlpUWQyTEI2bnU5TEhQekdtVmJyTzIxQWJV?=
 =?utf-8?B?R1JIbkFoYWlNNlNHbU1ueWpLVG1MbENpZzNlamliV21IRW1HMDRtNWMxbjJ3?=
 =?utf-8?B?RjVwWm9aaUNEUE1KbXpvNFE3eHlvMHVqVDJTOHBNQ2RReFdDS1M4aDVnbXdQ?=
 =?utf-8?B?Z2VteVp5YnZrZVVCTm95azRXbjlDWGxNQ25lQmJDeHNnR1pSWE5UejZ2cGxv?=
 =?utf-8?B?czUvOTFQUmFnd3V4eGJzSnptaHk3NWNjaUpJbkI4SGNLOW9TcmNSdUloYnQ1?=
 =?utf-8?B?MUZkVk41OU5PaCtUR3ltODdJdVZpbG1aLyt5YjNxZjBFYXBsVTZlV2pwTUlX?=
 =?utf-8?B?MGJhb1dVQjllUHVNTmpUOEZiMTk0MWZtWExoa2VjN0t3cXNoVE10UT09?=
X-Exchange-RoutingPolicyChecked: rA1DQaf4A4Vj7/NTnoeyC39NlXHh4KYv7GF9iAv0ez/yRKz/AgTtu9S+Gdst42+B51JbjDwOGEug7RpU85b/7zjodUgTLJTy21Qd27LVF2LstLcjWx+psm1+0cxmnjqGGKDgG1TTcImxdG3+hcZmUZJrrOuRMda58T3vSxdLwrTSIhZiGKhCJoU6w2ZteYOZGxYYHqw5eLTYYK81TNk0irPeWQHHtFvY28L5d1uxz52QhpCsEAQSs4wkEEVfH+rRe/i4nBVjscxVCWslKiSu4AJKvaTH+KDe0JFboTk0foK3QHHgHJWo3Q8f3aHDDVqD90Q3RqpTgL00LrhZImSPaA==
X-MS-Exchange-CrossTenant-Network-Message-Id: aac67cf7-6e13-4ed8-774d-08dea0ffe200
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 06:16:40.3849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CBpyHPLzuehK5/TT56TJoE54PQzDphF+53lYRmq16ZujZ3UAQ6vPd+UFB74LVfeOhWK4jPdTYrr8v/bE+n8PgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1FF629472
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8433A80010
X-Stat-Signature: 6o13sghwtw46t8ayie75ohnb6dzt7tet
X-HE-Tag: 1776925006-648475
X-HE-Meta: U2FsdGVkX19raMBr9HoyYzXSCAaG+YCfIfjC8OLaAhgfvBixC/SCqeRA1xbUDo5UlGKCb57PE9ivVxwtT3DtJWDswrdbYKWEpHeCi+MkvBha53xJI/R7ijUiGubOq0TqhSrhgm7VKkukdxxV1TPamoZqFm9gaH63c60TvH/5gbGfTHH2cByxsY1vojvPdQskc4Ox3PHvygYvodKvbHu+mmbv2NUfnnkE8iw1dz6TdooWMHXRd+t0BEXlmYml90JEj8RFLamCre4/twRwtSMXsHLMsKz2Qsvl4RllK6KsbM8yaBUIuXav39etNCoG5tGR93sQOilebh4AMmqDrM9gIua05ShlOnN2dHBGq2YvOb9H3x71kR19p6qr1rltfgpjW3Kiejsts1DlFe+aK7j/HOPKeRR/bHOqxNj1chaHqdV7Fqf80WUVSXXAP580b+R1BCAbmZQ+EAbs4+UB9/xe7MEHQQeYElIFg3uWxN9qFowQH2asMSsK8dUhH8JqB+ZNaVD+zZQnwd0cvlQI81xvQHq2YXeLIC4iCUnprHcTL/1L/fD7Jutg88LyCDn2u0nQa5clhPsTecXpU20Nw+yFRnl6e/Ns3U5ran5YUI2YbLzLxsnFOuo716yOpl7ksz2qN/3Y2PFc4EMrGW4dPBbdwinC0+8rXBz8yoSHtxt6PL8eq+tjcCAKTtor/7R+aw1yVWB3kxvLh6OQgpMd2CvfTb26ZdByBe8ZkT45SG5eG4xP1//Q8/LzH/Pb0azF1C7DIMC+ybFToEAiG+dN6svWn7a6+pud9dape7Iwn/IzWAS21X6UL/Z9gmYZZ2vZEVKTGIKhzEtbLEd335ljBV6y2/B5H+GYyepWt2kXbPC7YXNq4u9nAfejDKgCOTjWlDj3hkrRIi7I/Vx1MD+biurpHBgDjJU+W/Bw69a1MpY30JlNvRzQ3fHjbwbesyT/nLseV5SDlV6Jt/tTjea2LLh
 /M8bTSyE
 HWjdsjjSrKH/8vzQYYaKpYnXG1ven/PBw4gPl3tWhd32bqdSWe0/flq94LFOKSq/4V9lBowVYEpcz6LSGSkwmIqjf+qhDKL5wl08xrOFEUMxT5wan7LKixpkwGeKK5siBhmmczdfNV131C3VsL1JGxRDmSEbczuoE5fyxx6nZKPvuIGpF8K5wggJTjhAbJyNcA6SJUcIq6Cim4vgzllervTrTrJysq4/YggQrnY/3INBSRaMdfiR+s5UToOByF/9YVGC3rjFfpMUSg6PF2kx3uRO2AdioKRgtbdm6ffc0cLHoqN9JPGEXyUhUaR+HfRfZPA5Tqrk1ILGFKxAiMM7UuaRMHsnEX0Lqp/xFRMSFhBzvRLvGoBvMLOAzAIh9eIE7Diz4kE2d7XYAOElY7LTfTAZwdvKVp/uXUb7SaudYWW/deSMF53e25sflThh+UrPkNwAS8aXiqsnDmqp9e3s9rN/7LuOPDdQgfJ7B/850C4GFT2QaJSr3zBERt5wHqv8knuMZOrdScr/uO0fzkdi39SRX0rkXFouUHyiAwtG5gDMIfS+9jSiW7yLqGu5UKniF62bYdfqbyAvZmbrCjYYPJbzMhOF9tWCPKR+BhfqIQVJB+1YwL+e+UJlHoURmZP4kDW0lWXPH4BQzmNst1PHLZHozE0/fWetOBRZsE6NTUa++UU4LxsFSst8zya7Hrx4GbHdTgsIiuj3/pDVgy86U3Gn89zTeW//2akYXxXaFIvfAB2Wah1bYSGnHs6h0PpJFEH+3z0rEPWOeYoYIfdx8ByL0xbnN2BGV/kQ+sZE1gzXPGYkP917VsDszURSHUi+/bDDIvmwlcbFTGA1ZJ5PJD7QF3ttCbL5vpU0kINSUSH5KibTgsTxvS85hRu71fUSdq8fR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 04:04:32PM +1000, Balbir Singh wrote:
> On 4/23/26 15:56, Matthew Brost wrote:
> > Introduce zone_appears_fragmented() as a lightweight helper to allow
> > subsystems to make coarse decisions about reclaim behavior in the
> > presence of likely fragmentation.
> > 
> > The helper implements a simple heuristic: if the number of free pages
> > in a zone exceeds twice the high watermark, the zone is considered to
> > have ample free memory and allocation failures are more likely due to
> > fragmentation than overall memory pressure.
> > 
> > This is intentionally imprecise and is not meant to replace the core
> > MM compaction or fragmentation accounting logic. Instead, it provides
> > a cheap signal for callers (e.g., shrinkers) that wish to avoid
> > overly aggressive reclaim when sufficient free memory exists but
> > high-order allocations may still fail.
> > 
> > No functional changes; this is a preparatory helper for future users.
> > 
> > Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> > ---
> >  include/linux/vmstat.h | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> > 
> > diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> > index 3c9c266cf782..568d9f4f1a1f 100644
> > --- a/include/linux/vmstat.h
> > +++ b/include/linux/vmstat.h
> > @@ -483,6 +483,19 @@ static inline const char *zone_stat_name(enum zone_stat_item item)
> >  	return vmstat_text[item];
> >  }
> >  
> > +static inline bool zone_appears_fragmented(struct zone *zone)
> > +{
> > +	/*
> > +	 * Simple heuristic: if the number of free pages is more than twice the
> > +	 * high watermark, this strongly suggests that the zone is heavily
> > +	 * fragmented when called from a shrinker.
> > +	 */
> > +	if (zone_page_state(zone, NR_FREE_PAGES) > high_wmark_pages(zone) * 2)
> > +		return true;
> > +
> > +	return false;
> > +}
> > +
> >  #ifdef CONFIG_NUMA
> >  static inline const char *numa_stat_name(enum numa_stat_item item)
> >  {
> 
> 
> Without any usage/users, this is hard to review. I don't understand the heuristic
> or it's logic as applied to fragmentation either.
> 

Sorry—it’s always confusing who to CC on cross-subsystem series. Last
time this occurred, we agreed to CC everyone listed in the cover letter,
which I did. Anyway, let me provide the Patchwork links...

Cover letter: https://patchwork.freedesktop.org/series/165329/
TTM patch which uses this: https://patchwork.freedesktop.org/patch/720036/?series=165329&rev=1
Xe side which uses the TTM helper: https://patchwork.freedesktop.org/patch/720031/?series=165329&rev=1

Matt

> Balbir

