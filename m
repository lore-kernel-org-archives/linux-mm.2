Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FFD0CD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 13:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B50AD6B00A1; Wed, 27 May 2026 09:57:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B01876B00A2; Wed, 27 May 2026 09:57:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C7FC6B00A5; Wed, 27 May 2026 09:57:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85ED66B00A1
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:57:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F2EC161A9E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:57:06 +0000 (UTC)
X-FDA: 84813351252.22.E29207D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf10.hostedemail.com (Postfix) with ESMTP id B3249C000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:57:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=P4fxLnjd;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of aleksander.lobakin@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=aleksander.lobakin@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779890222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QRiq3wfKfxFGcDfK9VhmKifq4jqr3S/u+giZKJSdHvM=;
	b=MoIuCTCRrxzMkxUexJEUNw3yINWbJ68VFl/hbvkWz1uhusTz2927gYdk8/rgbCx5PAJjOR
	4rnPmp0/WY+vlfTJEmfJ/OsTNVk9rQAb6pKSxU4YQ1+IxOujdBrtZ96TmA/m6RAZWdGZr9
	vhIE1+Inh7UbXx7+tfODrN7XkVjyKfg=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=P4fxLnjd;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of aleksander.lobakin@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=aleksander.lobakin@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779890222; a=rsa-sha256;
	cv=fail;
	b=HxyQie1doLhvqtUY3Y9gUqdmgDDPonf+KW7X5W7UZJgqXewqvFK8VgdoHkBXg3X7uagIOh
	SUDvxi1xCEY3euaBTVc5Nf1GMH9UG3qodFNXGMD15bw1zWIxeeBQBy8b0g90ZJDlIH2lZZ
	rxfltXO5c0trufcF19wV1C4YforR/+0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779890222; x=1811426222;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DkYiM8sq0k8yg+6Pdo/XG2ryPDAVvKQOd6mXWs4Ma5c=;
  b=P4fxLnjd6nSxVIX2fIuppCZQKsQdAdF/kor2fFKzgPLPoqBCBFcTBdHQ
   vZkO5FocskcU2pbSO+JksnE/6ufhD1J/76H+SpfgzCv6732mU2KQ6u4PY
   cvwHTialdlCnd6tT1Y23RAhBrSIaWthkUyraf1khJ0j570u6DXM/LkURS
   KFguWDaL5FVqf/Re64ZAG/r7rntVtyh+x5iKAG2WT1Qi/DcSJiStX/ZzB
   chtoQys6HEd5xGkhUQMCXHXUsaieuybypR0qkrh5KddfzEzMr03+6QHDg
   7ivYvhEcyz2eaP2HBFJRhYuQKeVpjYQlwj2pEvj3Xp4be+c7v3DkmPsSR
   Q==;
X-CSE-ConnectionGUID: Y8azD6hYTfip0HTVnOPryQ==
X-CSE-MsgGUID: HEs8gBIdTEeMu+dRM97Ktw==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="68247060"
X-IronPort-AV: E=Sophos;i="6.24,171,1774335600"; 
   d="scan'208";a="68247060"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 06:56:49 -0700
X-CSE-ConnectionGUID: ej5XgIWJQl+sRsufjLxp+A==
X-CSE-MsgGUID: CEJIL31RTh2y0iPp0FfuLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,171,1774335600"; 
   d="scan'208";a="266134681"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 06:56:49 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 27 May 2026 06:56:49 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 27 May 2026 06:56:49 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.15) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 27 May 2026 06:56:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b4ZizW5VF0KpMHZIXjdqaIyhaOQEii31zuGgRFLP+kDbECv6SFxJqTXK/+oCwlEG3xhLMsFGt4SMr46SaeHuAUiWO4pD/jUQUL5fpbFxycr0czX2OdtH0/2DGCFp3UqntwCC9n2VgwZ8fDtegGjtgL6mfQ3ogMsjw6s8EB7bM68cwzP1HzcUJA0ldA2oaFkZWdVX+yECBzduJgGsUnqD04CFBNtuLP5efelSVv8f65cLi/bXJiBsxSP5xnr6DHUgCJ3PslXPkv2ZT9Ld36/HMedRiQqPfMNqkXyVjbJjf6CquD9zh+s5PitVo9c1qD64uVyjn5lpqtZ/WT8/mOVB5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QRiq3wfKfxFGcDfK9VhmKifq4jqr3S/u+giZKJSdHvM=;
 b=IryyfhqfRD8Jwzo4qoTgwpw9qUb/lc/xBRJjAy+5q713G2eGjekmLDREmY7BIjNHlZk38DPed1O88lwUU5QgiZh326OR7Xy+aHtZ/vlECTSsA2PvQjxfZG3kUy0YwBQURm4uTMMJjN0j+Ujb4aXgIWJl9R5jq4nBv4r9yTjEEiJnputBG8Zq3pgHOdeUvutmot9/W7xh9moqXNoRrN8VXtrPtMJdKkIgCtmqT/M1hyUhL9JfhJKTVymMpLZI/klKroGYVzI26B1NoKqXeu5joDrVE4TTn3g7fatrn0GCMi/yA6h10Rw5Cs9vwbxkmuI8Xw6iu01NhePWFPdwQ6QANg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB8718.namprd11.prod.outlook.com (2603:10b6:8:1b9::20)
 by DS4PPFACFC9C99E.namprd11.prod.outlook.com (2603:10b6:f:fc02::47) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Wed, 27 May
 2026 13:56:46 +0000
Received: from DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::6aa:411d:4bfa:619c]) by DS0PR11MB8718.namprd11.prod.outlook.com
 ([fe80::6aa:411d:4bfa:619c%5]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 13:56:46 +0000
Message-ID: <777c7229-4285-4c7c-9340-dfaebd2ab291@intel.com>
Date: Wed, 27 May 2026 15:56:38 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
To: Jesper Dangaard Brouer <hawk@kernel.org>, Christoph Hellwig <hch@lst.de>
CC: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman
 Gushchin <roman.gushchin@linux.dev>, <linux-arm-msm@vger.kernel.org>,
	<dri-devel@lists.freedesktop.org>, <freedreno@lists.freedesktop.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<io-uring@vger.kernel.org>, <kasan-dev@googlegroups.com>,
	<bpf@vger.kernel.org>, <netdev@vger.kernel.org>, Matt Fleming
	<mfleming@cloudflare.com>, kernel-team <kernel-team@cloudflare.com>
References: <20260527070239.2252948-1-hch@lst.de>
 <20260527070239.2252948-2-hch@lst.de>
 <e4dcfbc8-2666-452c-90b2-25c4b2c50c9f@kernel.org>
Content-Language: en-US
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <e4dcfbc8-2666-452c-90b2-25c4b2c50c9f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR06CA0141.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::34) To DS0PR11MB8718.namprd11.prod.outlook.com
 (2603:10b6:8:1b9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8718:EE_|DS4PPFACFC9C99E:EE_
X-MS-Office365-Filtering-Correlation-Id: 22260642-327b-4c85-36a9-08debbf7caa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|4143699003|22082099003|18002099003|6133799003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: z5y06Hw1R4qcLbCRqMeIsz+K40lvtOxWI68yQWF56krbV+5HfAyWniWwid/jC54TrNabipBa6uEZddX6WhmQ5saRZtcoI3X6po+ndqYdw19g/K10aVb85o2r8zBuA9fP2t17aP3ST6jgpvboyoYPF7YZbZRps6ycmLjku2C1ozo/XN+QrO9rlg2hQLoxL6o58fjFILBWv3IPQPVXrSWsRd5zuF9Z86uR3ySpoHlIrO7+iTpLo+8BQzcC4kvbgk5+4ZhuUQV9p6BsyxerxhuTJVkk5vcmHmHwKp2YFPflQkDsIXEicINi70VlHSMbPt8ADRwjp19kUaBs/x1XHAxhxlm/S41rk1F+bnfgnwWVOpXRXEmFNaA0cMkw2m5R1Gbyk7Isw2y+y/+bB/+M3nYi4MKwEO6VsS3TWdixOnUV9YH2lLle5KVtyEsKKiw+XeWiJ//oEHlgak/EQmTocJPYtYTQTjhsbmkvCMqbQNxW/SteB3Pg4pBkJPGo6slmG8810x3YaZh1VOtiaiie735TkaxZx9eROaifbEv4eXHB2zoKFlOCdx97kvr0SsKw/PxKKXt8nda9mLOT0PuBIOdkW6VpPahi4fOimC1x4SCCvS65bcBVXfJqgOam1mz4hodP4xMc/TGP/Oa7Egg6EGzTm7PAuUTj26oSN7hqM58wphS7MdlI7xTAjhQ6+CkjJoc0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(4143699003)(22082099003)(18002099003)(6133799003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TldKN3o5bGhNeExLU3YzWUhUSEROTmpGMGErMW55bk1ObTM2dWVPd2xBZ1ov?=
 =?utf-8?B?ZG4vOEhyMHJkMEF2SEYrbUduU0o3WnFtQUFicVpvMjhncTQ3dFNCbldwQmh1?=
 =?utf-8?B?aDBCT0VuK0w3NS9DbjZyTzF4V0JmMCtiWFc0TXdaTWVMaHMyT3ZhRlNPSUly?=
 =?utf-8?B?ek1kaExySlNTTUUvckkwOUFyeFYyWkJ5UFFVbVA3Tmg1Z3JPeFpZSm4veUZ4?=
 =?utf-8?B?WHYvZm1OZ3pZMlRCYmFUZFhiS1Y1UGtFMGcrdUl0UnFSczZSNEo1NEpIdXF4?=
 =?utf-8?B?ZmFORjAzeE1MR1lZK2ptTlZGMDFxdDc1MU1mQ0Z5ZGprekhUQkJrZkZQMHpN?=
 =?utf-8?B?dU01T29YNmZLM3BlazN4U29VamdQSVlPK1JhcVgrUkNNcExScU92UUxJQ1B0?=
 =?utf-8?B?VW9EVm93UEZ6OWt6VmFvTFFpdE8zTU9wS3lIMXUremRsY283KzU5eG9kMjl4?=
 =?utf-8?B?UnN1Tk56SnJJSUlNaTdJd0d5REk1ZHdtR28ydXArTVBuT0dieWozTWpkdEpH?=
 =?utf-8?B?cStKcWhGMGttS0Q3OVdKYWJSTnlwS2NUb0hhR3dGK3k0Z2RsQXlGSWNQekVu?=
 =?utf-8?B?ZDA2VnhBa0crQzROSVJoV3Z6ZWwrUzk2dzhzWktESWpzbC8yQkVxUHhnSHIy?=
 =?utf-8?B?QWRGeDVkUmxRUjc0OFhSNG8wQ1NwTnB0aEZNdG5zUjgyZXdFZElSSUt3VjMx?=
 =?utf-8?B?ZzVwMEFzenJicndHTkJGMWF4bXdTTDk5RTVNaGs1TzJucEl1QkZwcVBJbWFo?=
 =?utf-8?B?U1JyclYvcVp2YXNCeGZJYWpVVzlmSi9kRGVxdTBiWkREUzFlWi9TR3JrbHhJ?=
 =?utf-8?B?bUhUak00RDdUTll6UjZldGZZVmFoeDIyYU1UMk5hSGVQL3RFbzJRcHlUVUhW?=
 =?utf-8?B?bVM1S3JhNno3ZXozVmd0NWw4ZjNUWTJVbFJCMlBUODI3R0F3TGhVd0JGRTl2?=
 =?utf-8?B?bjJYejl6MnpuR3RIZHc0VXVMcnl0TVhTM2hRcDFJVFlxcXEvY2dIaFhNdzZP?=
 =?utf-8?B?UUxoK2VYMHF1WG9pM1Z1Nko3Z3hTTWRvbVRYaENkMXNLRmlQTndCQWRDTmlN?=
 =?utf-8?B?TkFWaWlMWGxweWZiSFhycno0aXM5R3ltRHVGQ0twaGhHQzRXSHdFNlpYaE5H?=
 =?utf-8?B?a1dLamhLNnEwWC9id0EwSVhrenIxZkFoT2FIVzVrcE1RMTdLbGFIajZINmZ1?=
 =?utf-8?B?RTdsTmplYkxFbVFPcVhHU0kyTjBwWS9nc28xb3pFSC9icFE2VlJBc2ZBSE9U?=
 =?utf-8?B?akxTNjNZRTkwZGhZTm5WZXVvYU9QdzV4VU9RUTdIa3IzVVZuSytwaHBFU245?=
 =?utf-8?B?QUhTTEswQSs2RjEwZTgyWmZQNE1LRW9uMlVkcVdhSjVQbHkvY2grTjlnODFy?=
 =?utf-8?B?czA3eXVDaEdSK0E0aXQxVWpqNjVsc2hDZjBsZ2tCa2w2OUhmU2dUWGRQZkR2?=
 =?utf-8?B?RFRUdVFMeFhVSkNRNVAzWm83T3owWmtDVitUVG8zTmRiR3RxblFQeVJWVjla?=
 =?utf-8?B?RUdWbnk5TlVrSEN6NUlyeUt5ZzlqR2JKNVlPR29sNzhFUFVnU0JOTFQ5YzFi?=
 =?utf-8?B?eXlIT3Uxbkc3UlkxQ3dJVU1TMHUrUDRqUm9NeDQ1U1JVSTNKZElPeEN6MzYy?=
 =?utf-8?B?Z1ZyUWdvdDZtbWZLbCs2U0dWbTY0NW5XZFBVN1BwSW1VVGlKQ2R5aUZJdzJa?=
 =?utf-8?B?KzFQb2s5RkhZUUJ0eHVnSXZKWXgxNks1RFJPQk5DYlJUQ1JUOHV3by9BazlK?=
 =?utf-8?B?QTN5TVFoaitFTXJJRzMraHh6NEdBc1l1N1hrOFdkUXNuUVF2aW5zVU1XYlVG?=
 =?utf-8?B?QlZMU1plakFQS0dmRHZxemJSTi8zcHlzN2I2T0tzT3dpc0lLd0pkL0E2Mmxr?=
 =?utf-8?B?T1JzMHl5RjNLTkJURW5vd0E5WTNhTU9QRTdmc09janFqcDJWN3ZmMGZ3Mjl1?=
 =?utf-8?B?emhrWXlINlRZYVVIVEJRaklVMysxS2NIUGdnYUhTalRMWEJHeEFtNE9NZUlk?=
 =?utf-8?B?MTNQaFQ1ekhmZXpSUVEyd1BKQW5wZzIrK2hoRFUrWU5KZUFaSjNKUVZmWVVY?=
 =?utf-8?B?eFhkNllScWdNNTBBbk1vOWptTmN4b2ZIMVlJRW92dG9wNlFSTkR6eXJ1Mmk5?=
 =?utf-8?B?RElkWC9tdFQySDFPU2toQmJMMjhIMVRrTXQ5LzhTVnVxUlBTOVFyM2lGdno0?=
 =?utf-8?B?MVJORzF2YXRNR1pIVDVlRzRoVmtieDByTHR1R2ZQNFNFaitsYXhpU0h2OWZF?=
 =?utf-8?B?aDhTOVpzOTVhVG5qY1hRZGVXNytWVVgwRnRMdGRXRzBVTGwxNTZWZ3lXeDVl?=
 =?utf-8?B?a1YwTDYrYzFFVFNqaCtNcG96TWlnZ1d2M2pUY3kzNjVGRWJET1hqSXlpM0tZ?=
 =?utf-8?Q?lOah9O0AIumLEilM=3D?=
X-Exchange-RoutingPolicyChecked: KUf1+GBHE23V6fy6A7rzLpUHD/GdCOgPqCgZ8qBb/TL2ErG0RZLCIvtxZD9GyQpuEKTW92qUqHY12+yd5Lm8xLcgTpAniPWo+q0w0nu0bnAalZEbdWy4K7fE1wHP0iefoaogItAOGo89JH7PvpYd6WEZai0T5Hu0G3P1iHUCBLUw6saaTfMya3Udtu0ej/YVRdbhYsKjwvWhv9Ph1UwD86NejDCpqzRsMZ42vMUIef9rKDHAxTe76ske3+f+1tITCiXCknmVtbOuJl7gv7hXzYG6+rBlSZS8QaPocPi58Qj+TFWmdWHf6XJO2s9yGwBKyu+aa7p1noqMNcewSY9BCA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 22260642-327b-4c85-36a9-08debbf7caa8
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2026 13:56:46.7137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0dux8gov4SlQ/vNFv7DjQGblmnibxlW2uTCXdMURqjIAJEEStHdc9vrbdf/PT13K4nZ8GAiAixGe21skRP1JNN7IpH2Eb8C7rRxAijFg3SE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFACFC9C99E
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B3249C000A
X-Stat-Signature: qwd4matnwe1gr7f1ngw8hyf3g5jze9ex
X-Rspam-User: 
X-HE-Tag: 1779890221-359683
X-HE-Meta: U2FsdGVkX18Z+4kHp0wwHaOqD1igKMNNX6BzwpNfT4wn+0iYijR0L1207i0zk/0GtGJdlbW9LSZ56/rf+LQyTAijwsbRMvS2zujMlwljmfr+Ppl1e0hZw8fxw521qZzHDX6JHo5jR1Znhbj0khBGq6Jr42UxjjqdTx3OggHrp4A+Qc7BldPt0s/xQ6DzN25EtzF6Jz8SOmJel3AtvarkY+xhfer6EWk+RQI+r0eEN1dPgF7N4mBe6ThqvxYmV0WQSoy6DF5lHjipJi0MDQz2aAChTZEl+tlczgzwCr6AEXZS0bhM7fbWCBpx6v2Uqb2L8SRFnLC8cLweLP9dmgjq93JSiSNo4Lovrgyp5N69RGnYRjQyHx47NCpvONYjTDClzB/IuBrLwt9Law+5LcYE7jlXukw2LuRCNpeDV8+VQgXXD3JASmrSmAEwGUALmqLG53tXtPdHNxBGxCGDUhOVde17kLqOyv6R1Oa14HtmDqvXIwWmrOR8xy/G2XWvFG1xwF4usiFYkSSiP1DqeE6bKhfC8H7ZU7UgF0UP+dyIM6SxNp0X0E2vIcWrJN3Qs6KVKpSEdWZYj+QsNUrKiM18jv7FYIyC0rVVkXrMcuZapyQ0f4nEcLbA2CgR8EFDx1zCRxtuuwE52SUQAia4PbFSi5NC/p364zqFC+t6/LiAIrRJTVqBU0vlZqCaQV7vtzDFu0ImRiL9t64swhJRyfR6kludpLuYogi9+tefmKIDXcgjs7TJljXhbZs9pMNp7BFg/SE/Vg0vd5+hEAHgW08HqsHG349WQYz4TKSw3KQd0CDPMMzzN+hA/z0skwNdKTNxZGRvq80icdsjslA+BNDCmS+frRAicMUOmecF4htz9hnqCJI1DAb7VJ7WjVJsVnvFYQYyrr7hyPF3oKnW1rxOn/iBMEEcBckS0BjWhIHmm0001U5GDa7OF4oIcPXmAXfFCs9CM+hAF41TEccGqWD
 ozZi0mg/
 KOk+WVHptskO8mCM2tLGswQSSFbK6YYhA4POwUeLSu/m/4otg4js0HqXGUMD+afCcrWr/Dd8/0QTzlaxXXaeAioos3sptsU5iHSkrmMwR0IfU89QyC7679wfVnGyfsJrUu5J2EZqF8pnSBZmitoyCfDJkham52UAhqYNfVryAqvf7MFyu4A8WCkHD3A+cv0Oy8ODJYBx29PMUl12nrg5SfZ9MLc7MO8YU2AQJCm2MDPyKLc+kU+k1k5NtgT07pw7G/DBCAtUnNJwDQpV6s4ZinxvTKV62gjFg56UYbAfZHEUoAaT8TwTGSbZPC8xF85ZoEjsX2ajG9HkRbSpgJMrScGU4bYZJyApDXaz3JdG1/OR5pRUAxejikB4oF0qzHN88sQjAsCMiQFAvaAEpQtc3tpHGMfclah37koGty2su5kuEjQRJ1PjAIy01FKPhNH6j1+7donNgll8h7ACTz29CIFHl8QfOIDOx/1+342DKhzAiqHRF26MsZyJjQ3X6tYJDZPruj9z51hczA9JIqNVT/lqEqxpXBQ3sz6MruA63zVQV1/b0N/4ppvsCskFXBBNnvbwTur20PmhJyn634CvCb8YB1RTZcJnTIa8o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jesper Dangaard Brouer <hawk@kernel.org>
Date: Wed, 27 May 2026 10:51:42 +0200

> 
> 
> On 27/05/2026 09.02, Christoph Hellwig wrote:
>> The kmem_cache_alloc_bulk return value is weird.  It returns the number
>> of allocated objects, but that must always be 0 or the requested number
>> based on the implementations and the handling in the callers, but that
>> assumption is not actually documented anywhere, which confuses automated
>> review tools.
>>
> 
> I remember, this API behavior was requested by AKPM when I developed
> kmem_cache_alloc_bulk.  I trusted AKPM's decision, but I cannot explain
> why this choice was made.

I sorta remember that when I was reading this function, I also noticed
that it always returns only 2 possible values (0 or the requested
number), but didn't pay enough attention or it was already after I
introduced napi_skb_cache_get_bulk().

> 
> I kept the netdev code usage below. The current napi_skb_cache_get_bulk
> have a retry logic that assumes that a partial bulk number can be
> returned (which it cannot as Hellwig explains).  Cc Alex/Olek please
> review the changes below as you added this retry logic.

As far as I can see, the diff below doesn't introduce any functional
changes (but allows for a bit better compiler optimization). The logic
is still the same:

1) try to allocate non-zeroed skbs into the cache
2) if not enough, try to allocate zeroed skbs directly
3) if still not enough, return less than requested

The logic is still valid even if kmem_cache_alloc_bulk() return bool --
we might have some skbs in the cache (but less than requested) and then
the first allocation try may fail, but the second one succeed (as it
allocates from a different (the zeroed) zone).

> 
> 
>> Fix this by returning a bool if the allocation succeeded and adding a
>> kerneldoc comment explaining the API.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>   drivers/gpu/drm/msm/msm_iommu.c       |  6 +--
>>   drivers/gpu/drm/panthor/panthor_mmu.c | 12 +++---
>>   include/linux/slab.h                  |  6 ++-
>>   io_uring/io_uring.c                   | 23 +++++------
>>   lib/test_meminit.c                    | 19 +++++----
>>   mm/kasan/kasan_test_c.c               |  5 +--
>>   mm/kfence/kfence_test.c               |  9 +++--
>>   mm/slub.c                             | 58 +++++++++++++++------------
>>   net/bpf/test_run.c                    |  7 ++--
>>   net/core/skbuff.c                     | 24 ++++++-----
>>   tools/include/linux/slab.h            |  2 +-
>>   tools/testing/shared/linux.c          | 19 ++++-----
>>   12 files changed, 93 insertions(+), 97 deletions(-)
>>
> 
> [...]
> 
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index 44ac121cfccb..73045b688385 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -288,11 +288,11 @@ static inline struct sk_buff
>> *napi_skb_cache_get(bool alloc)
>>         local_lock_nested_bh(&napi_alloc_cache.bh_lock);
>>       if (unlikely(!nc->skb_count)) {
>> -        if (alloc)
>> -            nc->skb_count =
>> kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
>> -                        GFP_ATOMIC | __GFP_NOWARN,
>> -                        NAPI_SKB_CACHE_BULK,
>> -                        nc->skb_cache);
>> +        if (alloc && kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
>> +                           GFP_ATOMIC | __GFP_NOWARN,
>> +                           NAPI_SKB_CACHE_BULK,
>> +                           nc->skb_cache))
>> +            nc->skb_count = NAPI_SKB_CACHE_BULK;
>>           if (unlikely(!nc->skb_count)) {
>>               local_unlock_nested_bh(&napi_alloc_cache.bh_lock);
>>               return NULL;
>> @@ -353,16 +353,18 @@ u32 napi_skb_cache_get_bulk(void **skbs, u32 n)
>>         /* No enough cached skbs. Try refilling the cache first */
>>       bulk = min(NAPI_SKB_CACHE_SIZE - nc->skb_count,
>> NAPI_SKB_CACHE_BULK);
>> -    nc->skb_count += kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
>> -                           GFP_ATOMIC | __GFP_NOWARN, bulk,
>> -                           &nc->skb_cache[nc->skb_count]);
>> +    if (kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
>> +                  GFP_ATOMIC | __GFP_NOWARN, bulk,
>> +                  &nc->skb_cache[nc->skb_count]))
>> +        nc->skb_count += bulk;
>>       if (likely(nc->skb_count >= n))
>>           goto get;
>>         /* Still not enough. Bulk-allocate the missing part directly,
>> zeroed */
>> -    n -= kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
>> -                   GFP_ATOMIC | __GFP_ZERO | __GFP_NOWARN,
>> -                   n - nc->skb_count, &skbs[nc->skb_count]);
>> +    if (kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
>> +                  GFP_ATOMIC | __GFP_ZERO | __GFP_NOWARN,
>> +                  n - nc->skb_count, &skbs[nc->skb_count]))
>> +        n = nc->skb_count;

kmem_cache_alloc_bulk() allocates `n - nc->skb_count`, but here you
assign `nc->skb_count` to n.
Ah wait,

n -= n - nc->skb_count
n = n - (n - nc->skb_count)
n = n - n + nc->skb_count
n = nc->skb_count

Correct :D

>>       if (likely(nc->skb_count >= n))
>>           goto get;

Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com> # skbuff

Thanks,
Olek

