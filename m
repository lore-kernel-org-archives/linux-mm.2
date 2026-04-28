Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50845FF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 00:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B407F6B0088; Mon, 27 Apr 2026 20:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1A86B008A; Mon, 27 Apr 2026 20:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B9C66B008C; Mon, 27 Apr 2026 20:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86A3A6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:38:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 446941201DD
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:38:05 +0000 (UTC)
X-FDA: 84706102530.25.F41FE9B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf06.hostedemail.com (Postfix) with ESMTP id CD91C180005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:38:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KGvDd+7a;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777336681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m/4eRiOQ5v3hiUyGQKmaQ0Xo5VrD/L4HK+yrrNz60IM=;
	b=8NvdL5a7chYg9Y863XVaAtBQHtdKwHVGMSR4FjrqaWo5K1rBQAgffdwjvyOXez0OHnEDFf
	zU/Frt7XZd1zWIqY5tOP3wBVYk+jszOWyB/nqfctC0DPZUN+hPzMHheHuvwPRAbOg15W20
	7sSvZNxrZ5uDFkclu/hC3i86KzUSwhQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777336681; a=rsa-sha256;
	cv=fail;
	b=5cmmyOh0C288w90TMUaC9MZbXS2xcXutJGZEd4Q5SdFp0hWQrlUtxdudWlgXggYdWqB7iv
	CXISJ20D/kVoFfJvl5tHv86Oj12/wE+CDdVzTS5DTQPBr7Z7NZdkZFPLH+8DoWxORyrNbZ
	SN7YCOO2DPG5o7Ikmh+dC063f8X7faI=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KGvDd+7a;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777336681; x=1808872681;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m/4eRiOQ5v3hiUyGQKmaQ0Xo5VrD/L4HK+yrrNz60IM=;
  b=KGvDd+7akY08gR2+zJkJVWvQaBJxWVRpHgB6C1JZjzaLMCXaTny4lJD2
   fjGAP8ybTUWOJlwouZRxXpSFb++CjK9b5VP0beQjS0bdm2DhlmYIvmvuL
   66hg4Ph0OulBrS2b0JrB78t9s1PddanRjJFzZktYLMZ++sWYCNoWU+PlC
   ejI3EiKD3ATDN7VdiH/dJMWFTghfg2FgMzwp6+hEZItONbS7pZkVIV8Iz
   RWc1MeVwB+Ctvzfzz/jg/iJwFDFeDij6HTYMGUj3LNcqUMx3NZ9LWrSDh
   g9It9eLOh/2D2UoyDlkcYjm+EpiZDmniE7FlhvqHgyTtSSDHzXZKzE7ag
   Q==;
X-CSE-ConnectionGUID: AprH2cgGQCqhoUxc9OTJXg==
X-CSE-MsgGUID: TCwwErY/Q9yEutgVRpa/7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11769"; a="88933899"
X-IronPort-AV: E=Sophos;i="6.23,203,1770624000"; 
   d="scan'208";a="88933899"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 17:38:00 -0700
X-CSE-ConnectionGUID: N8HJEtbBT1Grc+1zr9gPtQ==
X-CSE-MsgGUID: s524yuM+TliNPtlx9yKksQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,203,1770624000"; 
   d="scan'208";a="232785485"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 17:37:59 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 27 Apr 2026 17:37:58 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 27 Apr 2026 17:37:58 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.25) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 27 Apr 2026 17:37:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lXwQbZVqVaf5T7h8z6Vlpt1SipbX3SgUec12nJ2gm0XxRzyytbjAEmcC/Wq+xGE0PVUEi2ZVchyQdrNRoG/UK1PWED/AkG5BuAh76WDDVlsit+8RdmArrxZBa6VUjC2NW+CR6qs+k22ZVlqvJQxC8xuNrFG0tI57ifwt1BWVGRVTEvD5h9E1ATNMOGQzTrB2yTCXG6lprTCLlHp3QpVtg1jHqd6rudjncvLkgWB9mAQDfUtfiVys7UxWJJx5SX3JJq+CGTSkOVOJJmvjmE3hpvZ47+qwsrhVuYJmL8p4ZQi3l2wODX7xHeuGDfsbwCYHY8v/5/9KBX29NoC1Dd5u8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m/4eRiOQ5v3hiUyGQKmaQ0Xo5VrD/L4HK+yrrNz60IM=;
 b=PoUZtiCik+MxGX1qtgkjvpFkhxQGusoTO2IQbA0BbFz2Ko1KsOk1qzqqs2UH6a2uRcPhPxDtEyB5rGH5/HxLeOFXpQX8kI7b8vAbpRsOKrrUVdpfOjoE3+Yv+ZXy6if4u5RmQvEzbUmDOutTzra87UXk84c05qu0dZI/r5OpT6Ctn5iU+9B6tMdC6g2VPGepLqE8v4mrYpCIGv8ft5mQ2oAEJx3WfHeL+7zxKVfJ2VeEnra6OqYTvLHhMjHGxehtzVSZHfz/ABaiSA/Z4hAWh7uFUMaKyC9H5n/HPSlIFRFPJeF22u1PafVlbsPHJX625BUWh9ynjswFXxlzqwEwYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by CH3PR11MB8750.namprd11.prod.outlook.com (2603:10b6:610:1c7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.17; Tue, 28 Apr
 2026 00:37:47 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%6]) with mapi id 15.20.9870.013; Tue, 28 Apr 2026
 00:37:47 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Mike Rapoport
	<rppt@kernel.org>
CC: Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>,
	"Zou, Nanhai" <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	"Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
	"Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>, "Chen
 Zhang" <zhangchen.kidd@jd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Thread-Topic: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Thread-Index: AQHcxwYPPar5wabLkEWQfiO/Xde9s7XUxrUAgAIIwYCAAAfiAIAHUdTQgBWS2/A=
Date: Tue, 28 Apr 2026 00:37:46 +0000
Message-ID: <MW4PR11MB6936DE80EA8D49E46A297C7CA3372@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260408031615.1831922-1-yuan1.liu@intel.com>
 <17b821b6-0176-43d5-92f7-fe2a0c4f70cf@kernel.org>
 <ade6RVeXxDt7ImP4@kernel.org>
 <e86fee84-08d8-4563-8596-e40d8e196799@kernel.org>
 <MW4PR11MB6936CA77BF02BF498BBEAB1CA3252@MW4PR11MB6936.namprd11.prod.outlook.com>
In-Reply-To: <MW4PR11MB6936CA77BF02BF498BBEAB1CA3252@MW4PR11MB6936.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|CH3PR11MB8750:EE_
x-ms-office365-filtering-correlation-id: 679d8522-15c0-4693-f81f-08dea4be5e8a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info: Hdh3BlfRQnsDjYXCAdUOQwm2B8ApmVTiLqkikc6mzqlby4n0GnLoo11bPCj66rVb5cv0a+2ceP7eA2J/E+DNaUCQ49pDUis2YMEcXu05Ng7hAbTFw70KINPRL9CJMS65xoWKLJN4lJuluv595ZH40Bf9NS8+XpizeYLR4l071YaPO1tGLpSAGeen7HLpFpITiyIRf7gO4qUpKRsLm0BNq5dzOgccDgqPkUY2K/h7rsjO/KSvtqumsIb+Ufq6WP1BwHPAPqmFtTHaQWPYQ88vt1aHfXIR/KOzup5kBm3hz2viY9Ax+GmdobMLm57gmdvusGDZQpTTJd3/mkbKqVGL5puK3nEwqp6G8uKKgmVBdFgFfNztcZTxsRB9gRcjnlKP8hQP68Gas2C7kNsabeSjq9EAR7XU1gu8MuocMUKWTf7UlaStnrYhCz4MPIqk0lUjgjZkf8MZfyTyr0rFd9+DLpTE5Q+sbgp7Cm9a/wJRT1k47t1TP5wQnaiE/hdLAwHAfBMpa2y+wZ3qzZhCPmLhCD0KQ3kOrx4t5cdhmNcK0EP/+o110PunY1JLeoCrhG8uZP+1J8BW4kyWu0GTM4aCRYDAusLjzdyIdsiTjnTRnVv/Y493kzV8mbMCPZIpE3UBWmaXAiCEEXCtQtemABUCRjMw9XUekryy4BhStWvBOCBuPGrunENx1JE0Eb0MgV9Is+oTzuANk8mgZ3t23uHg1tXe7XqqKRlp7tiCL7j8kYjbFHfINCUGITNIgz7zDUyNobTmnQyi8FcEQSyLU82Am2b/Su8MPjB7nydACEmJskk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXhxcStma2o5bmlWU1RhalArczAzekxLQWR2UHpENHVwOVlWMnJJeXB1VjhZ?=
 =?utf-8?B?MnZ2VUcvT1ZNQUYxc0F1dDEzSWtiQWNyRm9qaUY2bXFmekxLSGxOVGdvejVs?=
 =?utf-8?B?QTVPUGZiblIyRUN3RTlMQ21tVUpkR0FtSERDSEJ3TzVwd0lNL2h2djVYenBi?=
 =?utf-8?B?R0l1ZGFhUFdZTmFyTGhWTDE4Y2JOMzJDZXBVMlVjbDM4V1JxdHpGeng4bEtJ?=
 =?utf-8?B?QURscUQ1MEZuUHN6VDZSVkR6QzZxcHl4Sk43OHhiOTNpTUl3QVJla3hlUk84?=
 =?utf-8?B?aDVTNk5kMEVGS1gySTVsVmRKbkt5eERCVzRkeThzdkNtYzdPRkt1MEErbGsy?=
 =?utf-8?B?R21LTzJ1cDFhVW5jZUlMb1JUZVdZSmRORkhkMmdwTkFhTE5XVVAzR1hHbUhH?=
 =?utf-8?B?MllBNDVJMHprUzdoempudzZRbFRDbVFqeDhmOWVnbDdDZm5ZYi9hczJabzhT?=
 =?utf-8?B?dUVTWjdRanN3ZklSMzFFWXhkV0o0aU1oYTBQOUdndVZ1RHNkSlAvWnlEZXdx?=
 =?utf-8?B?cVdOdXF2Qit6RlRjemdJZDFXLzhEZ3FTbHlKVThIa2RzK2VhaUJSSkI5MGN6?=
 =?utf-8?B?UTZybmtNblhXeVNyYnNSMlRtc2NrS1FEdCtoM0kveUFsaXhIc09WZFMwTjNR?=
 =?utf-8?B?MlIxeVZILzlwcllpeWxOTU10MEZuYVBSdWptK21VWUhRUG4zaEM0NkZUdndJ?=
 =?utf-8?B?bW16NUFkemNMT1lDakRrQjkzS1MwbEJ3N094Q05jQkM4Ryt1am16cmxGL3BK?=
 =?utf-8?B?cURlV3VoZFFNNGJsZEdCQlQ0N2piT3Q0TS9GK0hGNXoyOVRIeFppYytNTW52?=
 =?utf-8?B?K3hWRU9XNGQxV2VlcGNYTzVGajllYk12VU01VlptMUFEN29yd20yODB4NmpY?=
 =?utf-8?B?ZnlnbjhmSTFrUGkrNzZWV0xMdmhqV0Z2TXlJTnIzTFArQjFJT1Qyb1Y0RWVF?=
 =?utf-8?B?emF4ZGFJcysycGhFNFd5Yk9ZNUJIUGVKU3E2M0dNSjQ2RkJTL0lDbFlyZ21D?=
 =?utf-8?B?Yk0yTWxibFhyZGhrOUUrQkFRQWlqbjBuN1FUcmttNmZhVDAxZTF0QXZlY2lN?=
 =?utf-8?B?TjhLdmFmbGI3bDU5NEFydzA5T0N0Q0ZQQm1Eb1N0cXFqYW1pa01CRnpkRXAy?=
 =?utf-8?B?Y0RMS1ptMEp5c2hzTmRaOXJlT1NLaTBGWTFCTHJGRFNnQkI2QXVrSUtENmYy?=
 =?utf-8?B?dGFPeWVLNzYzSldERHJSclQwRDlIcXZSaGZUKzdkN04zc1JQL2YyakxDeE91?=
 =?utf-8?B?Zk9VNVRpRUxBZzRyU3NrYVVTUkxTWmhjeFhPWVNETFlveU1uV1p5bVNHQkhW?=
 =?utf-8?B?Zk9qWURCS1MxUmd5bUxxaVd6YktweTIzSjErbWhOOHNYVXhJUytzeTU4UlBm?=
 =?utf-8?B?RG1RWGo1NGxlcXFIVWQvSVBKcW13MGVhaGlxTXA4WE00R1E5bDR0WnVtQk1J?=
 =?utf-8?B?SUdxdFVHZE1ma0ErcFpmNlJ2T2E3elhlRVVLU2d3dEk2QXl4aU9LTm5Cd1R0?=
 =?utf-8?B?bjZ1ZWFuQXRzVGFVbjNSRG9XZWxRRXFWbzJ2a1ZnaEd6dGdrckJ5QW41V2ZO?=
 =?utf-8?B?WkZCZzgwVjNnWUNDdDV5Zi9zY0oxTnFCTkhyNzdqa3FrWm1JZ2lkZkJwRVV6?=
 =?utf-8?B?YUFGbHVWM0R6QXc1bjNONXowSm9KMjlQVTFycDAzTEFtcngyM1hIK2Q1cHh6?=
 =?utf-8?B?Ky9FaGtRckVLdDhhV2ppendxeUZNaWRpcjZYcS9udkxsNDRzZ29UQmZtR21l?=
 =?utf-8?B?UFhjNEdDQURseVJhZnNMY3RpbjVoMnhXYk5tNTRKMjVqeVlkellDdFNaZC81?=
 =?utf-8?B?NDZZUXA5VTdlclVzY24wbDU4L29IajdwaDJ4WEN4aExRV0FSdUIxUWF0b2NU?=
 =?utf-8?B?ZHJCK3dQV2Q5TitObEVNb0J0RXdCSUpBWUVuYVRtSHFpckNRcGlWTVVXbUVI?=
 =?utf-8?B?Y3dZaENwRkJycGd0NUFjTTRrM3lsaXJpdmlwUkVpR0FqOXpkSnoyOUVYS1Zz?=
 =?utf-8?B?N1JFbWpPRFRsZVBwczVGV3N5cVpqbTJSczhTQnFuT1Q5UmhaUE1IUGt2a1pS?=
 =?utf-8?B?UjNqVm5uWEI3ZGwvZDkyMEhWb2x2SmZQQTFVNkpmUEd2SWxiNStzaDlxMEND?=
 =?utf-8?B?Z01hN0RFOUpuODdxOXBjSm9LdWhuWEZzZW5kV0JBdmNWc0JHVzYxQ28rU0Yw?=
 =?utf-8?B?UUlWcUxBUXIxajZ3TmtndlVrN3RMVWVXODdraHRLa1dtUnJFeWNkR1NIMTNL?=
 =?utf-8?B?U1A4ZTVMc3lQekdlWVFlVEh1WTJEZVJLVEpKRURGVmtMazJkM3U0SzdWRW1G?=
 =?utf-8?B?QUJOR1prMmVrTG1CZ2xPbm9xd1JnQmJDS2kwVkRwZUJQTEpxS2x2UT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: FqJPsQjS79HYaqAFgqoTYqANUxvUQaVa7PWYOt0haVCVuO686Ue6h6w6q7UXnL6Iikit7L32AqEET13D9/Yi9cyj4QToBeptWAKTTTUXH50jqXL+R7tfrHY4JHYNsy7g+FskAtbBy1Ekp1lCdPtmWmZeGSueSqugSGmQnW+wxttXEs15zYBMQHNE4b2s7UcX619/IbMYwxWsQfS2UEkw4MZtx1szKdjgrgjriQMXr9fF6Bw2dijfSbABI7MP0wFnLLgD+xc+5AJfNMJEth7lr78PbF/HlaSuK8ZvL3w/fWQxsG/OUnUcG1FpjrVvEj+BfusBxgznmRo4N1LhYPmEUQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 679d8522-15c0-4693-f81f-08dea4be5e8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2026 00:37:46.9956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wYYjD/S69I2QZ6oDN97/ul9EhZZW8Z3JFKTwdqGu+KodwEvaMOPNnzceD8967V6k4ZAfnIO0emcahvLKLEJ8hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8750
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: CD91C180005
X-Rspamd-Server: rspam04
X-Stat-Signature: benhouexqte8sy6pn9cgqbh4mh3q5iwm
X-HE-Tag: 1777336680-587501
X-HE-Meta: U2FsdGVkX1+3fpziC1SHUPTFWF11/Yue2FROaba65vbky/cErSD6ecmHdark1XeoONecdj06xqRYmrHxfo/ZqRTfXzaj8AecEnKyvJBoSINlIgumvPKaSa6DxUpMzyjZnqGhPHVWKuEXDi33OEHKsYbtDYTgxfs4oaSlzp8XdFpFbzjOc5gE4wItw7ttvxulJpaaWmpbGG0wj8KkN+ftmkElohmmXnNPdXrREuYWtIYmanZJ+Nn0BmPw+J4zFOJw1ctGKReUbzynF/NuYVyepNoF2V8Rl07FHDVHMjtk9L5zePkzzMGSR4bOMC3vnFaAef799jWJywFGbXsnPNPh0JMHzg+cgjzkB6BV+BRm3QauxttAs1WsUEWQ4WT20j7Y8wggVtorBTawEoZuDY+h9oIXWOt1nOoqMujnROyckDfgXUXG7aBqjn5VQXFt8Vq8i1M4ml5DvU85rT0FAu7cAy3aRZGoGwJAg+fxXaGvvigtvPX6BNJjVv/nj3iXkSObBW7kNJiKrhBku5qHfDCqfeMJeHbx1D6lKy1FBneRApLROvlF5YVfTY3ZL+JTrqB00MEsXEMk1GIYC9hbnhwWvyWp1q8ariFmvNl6AA4HSGUheHIyhDC0kt68QHVfSs+jTORJXqGyx2tmU3q+90MhyRJnSanoqs3pCJkvnoG2tNmN4slNFnlHf8it9wGnV7ZKHvsDg7wkCuWc3LMBvjvVHFj/CBL2lXj+ExxUwqDAkCTpq1H8RJWsH4w5JgDLKUJP+UhIt2mqbA5qwFkuV5Y+Qp1IphsTFdE4BsWgNavnh7z7PbgZ8bC8YMg3uluyZMZ/yg70a44y/rSilPDgT0S5U0lU29d4ptF6rruuqBGDYKlG+eYPXI+j0boW9myaPS/nJmY3Zdevr+MDrPeXctiNUzOSdHQdiwc44JSIHLGflLiiRGNO5oFCE8vKkbXDfbKZJOhaGuJ5phvXAv09taF
 L779SCZ6
 Uf5iITbz2MOaZqbmnp2c6Ce2qUU4EseIiDN0BRHnYf+eZwEC6BSuqmMTSnkysLSqT0immybTzujxGXhXXvv48G5QaeTzpeQI5MWYL6FT2qdD2c47+jvoE3d2aUpfHatlwDdRPWVNkyfegaJ+OLREZwAdK/nqxFAIbEpMU385ywwbqAjXr0XlyPEoJtnYocchxuKi9te+Wo0eVlQ9e1+kMnfplVdQFiU6eE/l7wPQQJGRKNNMQ1iAkgEVaQkmr2c/cBeDILXG3+15b4X+6k0LBY02a7YUmNHpCkGdzNssP9dkZc//xSoBCwxgUKB/Tu2UD7Wv4E+hE4GAlYPKw8zOIjo2DLOxgo7iS0SNP+w+8bfQ6Er2IVcyavbOZhfwFg4YcyG11MfjLFwZIWOXURviC4w/ZE1in7/QD5gp+sEtxs6T4ND13IjFPi1VfYO6t8to6/1TzFvnYMcMb72EYyEoWChDvYVuRVi+2jV9mVKx7iQ8A5bko12ubMAsg2ATWs8bwXI8xIKqK4YcJ29RaTHjbS/o6fM7qyPQ9hQFDqUzn+Xv+U0yY07LJFOsjHo4TZU33GlRYEq8EH6S/MM9HPM0TQgYEJ4mOJTANRLB8vL/SseHzw4vzx96/+CPgmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Wy4uLl0NCg0KPiA+IFRoZSBzZXRfem9uZV9jb250aWd1b3VzL2NsZWFyX3pvbmVfY29udGlndW91
cyBjYW4gYmUgaWdub3JlZCBJIHRoaW5rLg0KPiA+DQo+ID4gVGhlIGNvbW1lbnQgYWJvdXQgc2hy
aW5rX3pvbmVfc3BhbigpIGlzIGxpa2VseSBub3QgcmVhbGlzdGljLg0KPiA+IHNocmlua196b25l
X3NwYW4oKSB3b3VsZCBub3Qgc2hyaW5rIG92ZXIgYm9vdCBob2xlcy4NCj4gPg0KPiA+IFdlbGws
IHVubGVzcyB3ZSBoYXZlIGFuIG9kZCBjYXNlIHdoZXJlIHRoZSBob2xlK21lbW9yeSBzdGFydHMg
aW4gdGhlDQo+ID4gbWlkZGxlIG9mIGEgIlBBR0VTX1BFUl9TVUJTRUNUSU9OIi4gVGhhdCB3b3Vs
ZCBhbHJlYWR5IGJlIHByb2JsZW1hdGljIGlmDQo+ID4gbWVtb3J5IHN0YXJ0cy9lbmRzIGluIHRo
ZSBtaWRkbGUgb2YgYSBQQUdFU19QRVJfU1VCU0VDVElPTiBjaHVuay4gSQ0KPiA+IGRvbid0IHN1
Y2ggYSBjYXNlIGV4aXN0cy4NCj4gPg0KPiA+IFdlIGNvdWxkIGltcHJvdmUgc2hyaW5rX3pvbmVf
c3BhbigpIHRvIGxldA0KPiA+IGZpbmRfc21hbGxlc3Rfc2VjdGlvbl9wZm4vZmluZF9iaWdnZXN0
X3NlY3Rpb25fcGZuIHRlc3QgdGhlIHBmbl90b19uaWQoKQ0KPiA+IGFuZCBwYWdlX3pvbmUoKSBu
b3Qgb247eSBvbiB0aGUgc21hbGxlc3QvaGlnaGVzdCBwZm4sIGJ1dCBhbHNvIG9uIHRoZQ0KPiA+
IGhpZ2hlc3Qvc21hbGxlc3QgUEZOIGluIGEgUEFHRVNfUEVSX1NVQlNFQ1RJT04gY2h1bmsuDQo+
ID4NCj4gPiBObyBuZWVkIHRvIHRlc3QgcGZuX3RvX29ubGluZV9wYWdlKCkgdHdpY2UsIGFzIHRo
YXQgaXMgdGhlIHNhbWUgcmVzdWx0DQo+ID4gZm9yIGFsbCBwYWdlcyBpbiBhIFBBR0VTX1BFUl9T
VUJTRUNUSU9OIGNodW5rLg0KDQpIaSBEYXZpZA0KDQpTb3JyeSwgSSBzdGlsbCBoYXZlIG9uZSBx
dWVzdGlvbi4NCg0KQXMgSSB1bmRlcnN0YW5kIGl0LCB3aGVuIGEgaG9sZSBhbmQgbWVtb3J5IGZh
bGwgd2l0aGluIHRoZSBzYW1lIHN1YnNlY3Rpb24sDQp3ZSBjaGVjayB0aGUgbmlkIGFuZCB6b25l
IG9uIGJvdGggc2lkZXMgb2YgdGhlIHN1YnNlY3Rpb24gdG8gYXZvaWQgaW5jb3JyZWN0IHNocmlu
ay4gSW4gdGhpcyBjYXNlLCBpdCBzZWVtcyB0aGUgaG9sZSB3b3VsZCBhbHdheXMgc2hhcmUgdGhl
IHNhbWUgem9uZSBhbmQgbmlkIGFzIHRoZSBtZW1vcnkgd2l0aGluIHRoYXQgc3Vic2VjdGlvbi4N
Cg0KSSBtYXkgYmUgbWlzc2luZyBzb21ldGhpbmcsIGJ1dCBJ4oCZbSBub3QgZW50aXJlbHkgY2xl
YXIgb24gdGhlIHVzZSBjYXNlIGZvciB0aGlzIG9wdGltaXphdGlvbi4gQ291bGQgeW91IGhlbHAg
Y2xhcmlmeT8NCg0KQmVsb3cgaXMgbXkgcHJvcG9zZWQgY2hhbmdlLiBQbGVhc2UgbGV0IG1lIGtu
b3cgaWYgSeKAmXZlIHVuZGVyc3Rvb2QgdGhpcw0KY29ycmVjdGx5Lg0KDQotLS0gYS9tbS9tZW1v
cnlfaG90cGx1Zy5jDQorKysgYi9tbS9tZW1vcnlfaG90cGx1Zy5jDQpAQCAtNDM1LDE0ICs0MzUs
MjAgQEAgc3RhdGljIHVuc2lnbmVkIGxvbmcgZmluZF9zbWFsbGVzdF9zZWN0aW9uX3BmbihpbnQg
bmlkLCBzdHJ1Y3Qgem9uZSAqem9uZSwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB1bnNpZ25lZCBsb25nIHN0YXJ0X3BmbiwNCiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB1bnNpZ25lZCBsb25nIGVuZF9wZm4pDQogew0KLSAgICAgICBmb3IgKDsgc3Rh
cnRfcGZuIDwgZW5kX3Bmbjsgc3RhcnRfcGZuICs9IFBBR0VTX1BFUl9TVUJTRUNUSU9OKSB7DQor
ICAgICAgIHVuc2lnbmVkIGxvbmcgbmV4dF9wZm47DQorDQorICAgICAgIGZvciAoOyBzdGFydF9w
Zm4gPCBlbmRfcGZuOyBzdGFydF9wZm4gPSBuZXh0X3Bmbikgew0KKyAgICAgICAgICAgICAgIG5l
eHRfcGZuID0gc3RhcnRfcGZuICsgUEFHRVNfUEVSX1NVQlNFQ1RJT047DQorDQogICAgICAgICAg
ICAgICAgaWYgKHVubGlrZWx5KCFwZm5fdG9fb25saW5lX3BhZ2Uoc3RhcnRfcGZuKSkpDQogICAg
ICAgICAgICAgICAgICAgICAgICBjb250aW51ZTsNCg0KLSAgICAgICAgICAgICAgIGlmICh1bmxp
a2VseShwZm5fdG9fbmlkKHN0YXJ0X3BmbikgIT0gbmlkKSkNCisgICAgICAgICAgICAgICBpZiAo
dW5saWtlbHkocGZuX3RvX25pZChzdGFydF9wZm4pICE9IG5pZCAmJg0KKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBwZm5fdG9fbmlkKG5leHRfcGZuIC0gMSkgIT0gbmlkKSkNCiAgICAgICAg
ICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KDQotICAgICAgICAgICAgICAgaWYgKHpvbmUgIT0g
cGFnZV96b25lKHBmbl90b19wYWdlKHN0YXJ0X3BmbikpKQ0KKyAgICAgICAgICAgICAgIGlmICh6
b25lICE9IHBhZ2Vfem9uZShwZm5fdG9fcGFnZShzdGFydF9wZm4pKSAmJg0KKyAgICAgICAgICAg
ICAgICAgICB6b25lICE9IHBhZ2Vfem9uZShwZm5fdG9fcGFnZShuZXh0X3BmbiAtIDEpKSkNCiAg
ICAgICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KDQogICAgICAgICAgICAgICAgcmV0dXJu
IHN0YXJ0X3BmbjsNCkBAIC00NTcsMTcgKzQ2MywyMiBAQCBzdGF0aWMgdW5zaWduZWQgbG9uZyBm
aW5kX2JpZ2dlc3Rfc2VjdGlvbl9wZm4oaW50IG5pZCwgc3RydWN0IHpvbmUgKnpvbmUsDQogICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1bnNpZ25lZCBsb25nIGVuZF9wZm4pDQog
ew0KICAgICAgICB1bnNpZ25lZCBsb25nIHBmbjsNCisgICAgICAgdW5zaWduZWQgbG9uZyBuZXh0
X3BmbjsNCg0KICAgICAgICAvKiBwZm4gaXMgdGhlIGVuZCBwZm4gb2YgYSBtZW1vcnkgc2VjdGlv
bi4gKi8NCiAgICAgICAgcGZuID0gZW5kX3BmbiAtIDE7DQotICAgICAgIGZvciAoOyBwZm4gPj0g
c3RhcnRfcGZuOyBwZm4gLT0gUEFHRVNfUEVSX1NVQlNFQ1RJT04pIHsNCisgICAgICAgZm9yICg7
IHBmbiA+PSBzdGFydF9wZm47IHBmbiA9IG5leHRfcGZuKSB7DQorICAgICAgICAgICAgICAgbmV4
dF9wZm4gPSBwZm4gLSBQQUdFU19QRVJfU1VCU0VDVElPTjsNCisNCiAgICAgICAgICAgICAgICBp
ZiAodW5saWtlbHkoIXBmbl90b19vbmxpbmVfcGFnZShwZm4pKSkNCiAgICAgICAgICAgICAgICAg
ICAgICAgIGNvbnRpbnVlOw0KDQotICAgICAgICAgICAgICAgaWYgKHVubGlrZWx5KHBmbl90b19u
aWQocGZuKSAhPSBuaWQpKQ0KKyAgICAgICAgICAgICAgIGlmICh1bmxpa2VseShwZm5fdG9fbmlk
KHBmbikgIT0gbmlkICYmDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgIHBmbl90b19uaWQo
bmV4dF9wZm4gKyAxKSAhPSBuaWQpKQ0KICAgICAgICAgICAgICAgICAgICAgICAgY29udGludWU7
DQoNCi0gICAgICAgICAgICAgICBpZiAoem9uZSAhPSBwYWdlX3pvbmUocGZuX3RvX3BhZ2UocGZu
KSkpDQorICAgICAgICAgICAgICAgaWYgKHpvbmUgIT0gcGFnZV96b25lKHBmbl90b19wYWdlKHBm
bikpICYmDQorICAgICAgICAgICAgICAgICAgIHpvbmUgIT0gcGFnZV96b25lKHBmbl90b19wYWdl
KG5leHRfcGZuICsgMSkpKQ0KICAgICAgICAgICAgICAgICAgICAgICAgY29udGludWU7DQoNCiAg
ICAgICAgICAgICAgICByZXR1cm4gcGZuOw0KDQoNCj4gDQo+ID4gLS0NCj4gPiBDaGVlcnMsDQo+
ID4NCj4gPiBEYXZpZA0K

