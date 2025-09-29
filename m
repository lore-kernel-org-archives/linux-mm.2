Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0385DCAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 16:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 219638E001D; Mon, 29 Sep 2025 12:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C9598E0002; Mon, 29 Sep 2025 12:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043578E001D; Mon, 29 Sep 2025 12:30:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E04C48E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 12:30:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75069B9586
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:30:28 +0000 (UTC)
X-FDA: 83942825736.11.D175BE4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf16.hostedemail.com (Postfix) with ESMTP id 09C27180007
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:30:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ymu8+TVj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of qiuxu.zhuo@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=qiuxu.zhuo@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759163424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QRYN8GmfhK0Qm1m4C3o+jItBc70sDzXtFcAFoHHZsU4=;
	b=Hr8oPRg9wVmInVdyUOguqfgE1JKKums7mY6mLp3NJhmZU/7Lf8reoIFgwWv3FiRbzSoKOb
	e92eFi/9OI60WaBimnaLQ/Qc7NPheg7JTUpbi2sGT4qOEJm8FnJBh90VfXaaSZ0j3rX/Lm
	O6od+fAplGB1EggkW+N+4J78RAXU6xM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759163424; a=rsa-sha256;
	cv=pass;
	b=PoPdgQEjj+gEAwlIHuxZDGGQPUI5yGy9Wea3wHE+1P+WTyCi1D6n3YZ/RfTDpN9OmaE3hT
	7uMyR7brR0hCitDuwCvH6Z4kX14AadcRlr537hFq1wZC2NrL8W9i+717uknLWYacyaI2U/
	1Dq+037yeT7kv364Lw+FYbBSFu7y7SE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ymu8+TVj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of qiuxu.zhuo@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=qiuxu.zhuo@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759163424; x=1790699424;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QRYN8GmfhK0Qm1m4C3o+jItBc70sDzXtFcAFoHHZsU4=;
  b=Ymu8+TVj75jfRjSJJ5yoxeOMCKA86DWLWcHwhkUtj+Vl6W2fjLIqotR/
   PZU1KtF08CVHA2IyaMCMw1ZJlpzLmC59qaU6fncNNCoe7BzD+H7grgBt2
   soN8o7RMyJGDiMyqBdHZFWJmD+57KdT9L5cPKUzautRmkU+cAu2Eems0e
   1NotnlBtfjJ7kIm03PbhokuV8baESZH/C9Z8C41VP+JIsv6qrTPcvNLvP
   DCHbgI8ekzZQjBsnv9msS4CHHonYHG5TAE90j3f+bk8JRdgasXglk+Twt
   kqlie0IKLbeDg0v+XZtJQ1XO0CySlrExkEQu3+rMTjhewUFAF7ZuvqvqF
   A==;
X-CSE-ConnectionGUID: v/uUO3ZvTaW8w4hBGHq39A==
X-CSE-MsgGUID: Hql89wlARCeRWdFER0sipA==
X-IronPort-AV: E=McAfee;i="6800,10657,11568"; a="65264043"
X-IronPort-AV: E=Sophos;i="6.18,302,1751266800"; 
   d="scan'208";a="65264043"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 09:30:20 -0700
X-CSE-ConnectionGUID: 3omQB+ZMRdqy04JX4mBikg==
X-CSE-MsgGUID: am/CONX/QImMSeVjdZKwPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,302,1751266800"; 
   d="scan'208";a="182557391"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 09:30:20 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 09:30:19 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 29 Sep 2025 09:30:19 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.19) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 09:30:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FDfVNjB5gcfYX9UsDLXvLbtcWAjHhYqd/R+iOhIrwOhrpSHx9BgvPE6/dfSb+lxY7c8JjPDL4U9l02F4GiLeAfYukrKyJxK10DfRMVUd1nkRwkBWV44b/KahQif8qvsvLkLNiqY7j5FNvM2RffH3axNgBDvh8oPRLdierv4VzSap3uCdpIXq/LrsrLJMm2m1PtyKn0fyD1mThB8Ed5fizAlO3TSFAvLxQ1MRW5NdrKzf/ACXSuJuUHiUWz58zExhBoKWD0OTzTV8gbyKObmiTw9nNb+e8FfTd4jxwlx9sYov/E7vmRPWDYCRhWviaCeQ8zb1Y7vXuPdKJRhCKz2ezQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QRYN8GmfhK0Qm1m4C3o+jItBc70sDzXtFcAFoHHZsU4=;
 b=OPqRe2+qdl2XRKsFQYaX5v8zxjX+kNhUHRt2VK0PK8kJHfGh+Nu/0h4gBWzgRWMMDDd6EfQxQbcIibVlo6lQaMAlqRfXo+1YVe9N/Cn6wrvxheUz+M8iHhosGzftxekOSnBhugLKVfHpD6BKhVDA1/jyMwGj9OrxaJVILc1oKpp1axro+MU/4hmGYxUF54h01KurhuYT7T+E2svrW5sltNM15urrkT5CBL5x1Ss1nkDt/QgdDtQp91QiYd1l1niuGHQ7fTn1KT2E1vCJ9w58pGnyAiibQ0idV6RgHNXsDl+Yi+uJ3DEPvU0W6sorMmi3+I8si3pl2X7hHVzx/1Ce+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB7130.namprd11.prod.outlook.com (2603:10b6:806:29f::10)
 by PH3PPF25FF87461.namprd11.prod.outlook.com (2603:10b6:518:1::d10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.16; Mon, 29 Sep
 2025 16:30:16 +0000
Received: from SA1PR11MB7130.namprd11.prod.outlook.com
 ([fe80::fc98:7fe:bac0:f2d4]) by SA1PR11MB7130.namprd11.prod.outlook.com
 ([fe80::fc98:7fe:bac0:f2d4%5]) with mapi id 15.20.9094.021; Mon, 29 Sep 2025
 16:30:16 +0000
From: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, Jiaqi Yan <jiaqiyan@google.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@redhat.com" <david@redhat.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
	"ziy@nvidia.com" <ziy@nvidia.com>, "baolin.wang@linux.alibaba.com"
	<baolin.wang@linux.alibaba.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "npache@redhat.com" <npache@redhat.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com"
	<dev.jain@arm.com>, "baohua@kernel.org" <baohua@kernel.org>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Andrew
 Zaborowski" <andrew.zaborowski@intel.com>
Subject: RE: [PATCH 1/1] mm: prevent poison consumption when splitting THP
Thread-Topic: [PATCH 1/1] mm: prevent poison consumption when splitting THP
Thread-Index: AQHcMChLk4bOL1ruf0K10LKRmZ1XGrSpJMYAgAECE3CAACrBAIAAB1NA
Date: Mon, 29 Sep 2025 16:30:16 +0000
Message-ID: <SA1PR11MB713082CA93E9B1C5F22CFBBE891BA@SA1PR11MB7130.namprd11.prod.outlook.com>
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
 <CACw3F50ijQ20Vg8ycMROSCccf_XtjB_fFvLGxvQZ7eaNQoLwGQ@mail.gmail.com>
 <SA1PR11MB7130ABC25E060D2CC4749E45891BA@SA1PR11MB7130.namprd11.prod.outlook.com>
 <SJ1PR11MB608350E5169EE77F86A51E2FFC1BA@SJ1PR11MB6083.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB608350E5169EE77F86A51E2FFC1BA@SJ1PR11MB6083.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB7130:EE_|PH3PPF25FF87461:EE_
x-ms-office365-filtering-correlation-id: 34f402e0-b920-4d54-ce1c-08ddff75793b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Q0kvbW5oSHVlTDJZQ2N6S3ZDMys3T0h2Q2tybE9TMnI3dm93MWdHTVc2V3JC?=
 =?utf-8?B?MEdMMmJyOGl0c0VmQi9KdmZGSkd5ZzRMeU9NY2RMM0xIRWtGbG9DMzlvR2tG?=
 =?utf-8?B?aC9RMkhUblQvVFQwM0Y0N2tVY2dudnMxZUhpZ1JaVTNGQkw2TDJYUll4aXZ0?=
 =?utf-8?B?R25MaG15K09DWnBTS3QwWFpqdWU3Q0RwOUwySzNTbzJGYnVkcDlYYVhCaEIw?=
 =?utf-8?B?Y2VuamljOUpWWlpveHJCekNJc0RVZzFiU1lhZVZsa3BwRjdsaTJScWJQcm40?=
 =?utf-8?B?VkZldUVXK29vVXdCNElZdTlWbGczdWtaeGY0K3htZlNreU8rSVdVNG9VQWZm?=
 =?utf-8?B?ekx3cTlNeGRLTWJLeHF6UjZ6TVczVnZ0RlpGQXFPZnRldFVCT05IUW13bVAy?=
 =?utf-8?B?Z0cxbk5rTHBuRFArV2QzYVJTSUFpRnIxWUNEU29ZV2tTRWloZVN5dytMMDRx?=
 =?utf-8?B?QkZvQzROcUNzdmpHS3BFdFB4cHJHUFhaVzN5UUJNSVVFeGorT2lzMVlsekVM?=
 =?utf-8?B?VWcrdy8vUXRnSlFjTzZ1QWRFdWdtTnh0TVh2QTNNTG82KzhWcTJLeDEvN0Fs?=
 =?utf-8?B?alFtMnJvK0JTYlBUZUVNTjl4aFhHajFocnpma2ZWUFd3KzRQUFVUZjE4VUli?=
 =?utf-8?B?YnVnTVdiN1NiWVhmNTVva3Y5dHVvQ3kwYzNyWGFjQjVyK3hWSVFhYWNSWkx5?=
 =?utf-8?B?cklPZzBhSWJiQlNISjRXWG8vWXgxTmUyaFg5QmlQSzRubml4UEVHS25Mak4r?=
 =?utf-8?B?MlQxU3VpSkdPc3dCV2Q2SXFHMGhrMExjcWttSi9SUWQveWtXWDgySmxnNVRs?=
 =?utf-8?B?U1pwRDhIWXRDYy82RUlzcXlVbk5tSUVhSnRPQ0FTT2lVNEVLR0tYUHZ1ODhJ?=
 =?utf-8?B?SFk5dDRvdlF6VThiazNMOTdDSElmU0x6aWdoSTBZMm1GQklxZytSU3ZyVVJs?=
 =?utf-8?B?ZUdjSUZLL0xvdlk5OS9ObVI4cWpmalp6eE1Ea1lGY24zV3VEZ3p1dlVIVlE1?=
 =?utf-8?B?VFB2Y3Fyc05LRndYY1ZNUG9HQ2FyM0FTdjRwT3FqNTZ0VjJNRWhUQjRZbmtx?=
 =?utf-8?B?SUZCK2lkdUo3ajFzSGNZUTgvZm1hcUFKUlRCclhGVXZTZzlqSkdicFE5Mno2?=
 =?utf-8?B?Q1pjT3pNM3doazFXQSt0MGxwUWRNQkw5Skx2dk9VNlo5ZCtRUjJRTG9yZDZU?=
 =?utf-8?B?YXlXcHpUNFJkOHF3T2hrNnZ3OVR0WkZaQlQ2SWNlOXZwL2hsM0pZd3RpaU5n?=
 =?utf-8?B?bkxmVVg2RHU3YUQ0SWZuQnhINkVQdWs0MlNjTnhKbDRTajgvWVYyRkhwWlZV?=
 =?utf-8?B?aE5wdUxYSXFscnZiYnJZc0hWN21kZWFuRkd6dVpQOEM0NE9LU1JQUnhDTWdW?=
 =?utf-8?B?cWxQaFpISGxZSVhmaTBwSFhDRHZ1OWkzZ1RLb2c3YU1kYXNxUUdqZjQ2MWh5?=
 =?utf-8?B?TS9nWkpDSHlxWUZUdXA0d3MyczE4UFlKUjhmY29PRlN5TGQyV2x1ZHJ4Z3pp?=
 =?utf-8?B?UlFodmdsazJKbjZ0MFlqeVowWTNaSlZDbUk0Qi8xZkUrZ2YwV2xyc1NYY3Q0?=
 =?utf-8?B?blZiMWF4RGxJcXFZWFNzOEJUejFVZFpLcEFiYmQxU3FCa1QyUU9tRGFsOUo2?=
 =?utf-8?B?VmRvRkFLbldaZ080a3VrU0hGOXlLK25tb3YvbUNpRExwYWJSc05pRHJsWDNm?=
 =?utf-8?B?cWVXQVdmWEFmS084UjFCMm8vUmNwZkdvQWQyYmNpRkVVTmtlSFV1QzNQMUgx?=
 =?utf-8?B?TGs2RFhOYzJYeEk3eDhYYmxJRkFub3YzaDJhbmNXb0cxY1FiaFJhaHJIQ3Vm?=
 =?utf-8?B?ZUdaSVJEN1dTdDNrd0lCbHV4cDB0ekdWZU10TDAyd09yVU42cDVHN05TNU9u?=
 =?utf-8?B?WnRrUk90MDVaQ2wzMTRLSS9NY0p2M01DdVRPcERFa0t1RU5Xd2FYcUcxVGor?=
 =?utf-8?B?MzBKcWtZS0Ntb0x6c1dBRXZGd2g0M2RoVTJ4M05Na0ZxZXlGdmh2WHFqSFN4?=
 =?utf-8?B?MFp1SkRsUEJpTmNWakdPcXpnMlRYdGJCeEttK1N3U25DMmNkMnk5T1RETElv?=
 =?utf-8?Q?A6p7Me?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB7130.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RmY2Ti8zMCtVd1dkUDhpdHMzQzlpYTNUazRlVVV3T1kvS2R6MGtMb1Bmbk8w?=
 =?utf-8?B?MUVxN1dXTFZ0ejBsdER3QjdIZXZZeGRoM3A1czE4VWxNSml0M2RNYUZBNmxx?=
 =?utf-8?B?YnkvZ0lPMEduWURwS1IreXc0amkzcHNIVkV3K004Y2NOMXllcWhYam1QdXN6?=
 =?utf-8?B?ZzJVYzl0WTJaN3hBSlZyNkU1RVFpVXlWV1U2ZUFDanl4RE5qWnhlekRJb0tN?=
 =?utf-8?B?V2tKRmVMUHRLcUZQTmVHV1hnRDN6cVN6UTB1TU9HSkhNSUxSMGNLdWJCUmJo?=
 =?utf-8?B?elRSMnBQam1DYmptVDVZaFptUkhsaEhKNDA5ZVNUbU5HWUlpOVFDTzc4bnRQ?=
 =?utf-8?B?Rkw3QisvRytaVVNhOHhoaENsYVpzNFZGTEJ0L3VqUzVyK0swVWIydVpJTTRN?=
 =?utf-8?B?aUd1bHlSRXV6NTRaUWlqdFZ1Sjc1cERsUXByaFVtbWtEbk4zend1QmtiZFJu?=
 =?utf-8?B?NlJQMTA5elN3UzhWUFZ3dmNINUdWR01HSkNONkt3NGE0TmwxZjNyb2pFVlJi?=
 =?utf-8?B?alNwTlJQZXJIWlRHYTJuUnYxVWJLMVQrOVE3YkYyQWhzQUVoMWpmR3psMlJU?=
 =?utf-8?B?cklrZEpkOVB5elpYdDU5V3BYaWJCdTlpY2JMNUtVdngyTGhnRndNcFczbU9z?=
 =?utf-8?B?cUJlNDlER1lSRXdUOURWN2kwcEVMaTVKN2dlT0FoeGNCbG9tdE1SdDloME1D?=
 =?utf-8?B?elJuMldFTWdXdWMyWno2dEQrdk0zQzcvcGZOTW42Y2ttQzg2bytuTjlSby9W?=
 =?utf-8?B?OWdRVUE2T3lBMjFWeTBQbEg3SlRlN2pxaVg0Zkl0MlluQVY1VXN2U1luWG83?=
 =?utf-8?B?ckZxeldTMFcrR3RFMGxPNlAwZndhWlNHZ1ZBbUN2dENoOHpKL1JiYnhVdTdj?=
 =?utf-8?B?ZXlNNXdjc21Sd3JjRUdUMmNiWGZPem9HT0JCcmRwSEUwT0NwVStRdnNFUmpL?=
 =?utf-8?B?MWNBQzVnZFVHcENCSWZWaTVrTGFEL3plaFF2c2tmaXU1VFJwZGZha3BhVWRj?=
 =?utf-8?B?cmxaTTFaLys0aUJxdlJMQWRwNmVWa3J2NnJFa2k5OS90TW9OOTRsQmpwc2M1?=
 =?utf-8?B?bXpjVXVEUldBMTJ6eDdHRHFodVRvWXU3dnpGeHRrMWFmaUd3MFFKVTNVeUZM?=
 =?utf-8?B?V0VwanpPQnZ4ZThmSm9sVlppL3ZnTy9jMDV3SE1rQlJhdjlIQXBDSDF3RXFN?=
 =?utf-8?B?YjBxMDRLMTBEQTQ3aWwzeTYrczh4OGhaemxBNWk3NTltTVBRcnJiMllxaGZT?=
 =?utf-8?B?TUE4anluZG85SFRvbjJua2lFeG9seFdUSWdyMzFVWmV4USttRTNGK1FDL0Vx?=
 =?utf-8?B?OVdVcDU1MVJZcTNTaFFIQVVCQkRVb1YrR3ROOGV4eUk2TDJRUytMZXU5SWsy?=
 =?utf-8?B?cElWUTE5UUNHanV5UUh4a1VEaGFZbHIxK1pmQi9MaVNCNS9UNFdkOW1mbVRv?=
 =?utf-8?B?OVNkVDdVQVBhVTRYeWFuMmNTSmlzMVhZTDZ2RlJVZWtlK1F1RVhZVWxGVDhr?=
 =?utf-8?B?ejRlQjlrVGI0K3NhV3RDZ1ROeGdrNEZQZk5HVkNoUEpHU0RuRFlkZmFLMkox?=
 =?utf-8?B?cnN1TlhTbDRlOHZadjVjcUpGY25pZURvdHJaWmxDejN2UHJRWE9iUHdYdjA2?=
 =?utf-8?B?cmFCZUNsZ1JCTjZJNmowWEM2dGN2K3Bma2d4VGFoSzk0cTl5WlVzcEQ0ZUti?=
 =?utf-8?B?Q2dBbStNYm55RGtPUkQ2MUN2bkhpUmE0dG1NdGlkZVIyTE9yajUzbFpjYklD?=
 =?utf-8?B?dmxPaCs5K0JkT2U4a2dpZnlKY3dHdjBLS3BzejY4ZDhscE5jeWdWUGh3Y0ZN?=
 =?utf-8?B?bTU4MmlVQ3BSM2JCeFQ1cXovZW5wVkFkYmNGQkJFZnAzQ2VzTkRIckRLYlJa?=
 =?utf-8?B?a2tWTWkxajc0dkRpcldadm1YTks0VGdiNnRxazJaVXZHQno5YnJLWEQ2b0py?=
 =?utf-8?B?Y1krczhFQVdrd2JjQlNhSTcyVnFaU2MxQ3plait3NEJ3cW8xWWFydm5uazI2?=
 =?utf-8?B?dmVKVGUveExNZS9MZStUMmZDdDZ1QWlwL0FjcHVrTlcvd3hxUjNQNHdDNVZt?=
 =?utf-8?B?WlJBb1JZQXc4NVBuTTd5SW9HaDZmQTFKaWxabHR4WXdoWVhhbzlPeGQ3S2Ny?=
 =?utf-8?Q?4ts10akaoS1qdj87lFTsIK+2h?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB7130.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34f402e0-b920-4d54-ce1c-08ddff75793b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2025 16:30:16.6513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GWGrIl/QSRFhnZ9xcnxkh1KRoHNevLYL51lOmGpQKoQeLLecBzHzuqkhwlW8wLTDDo9N6DmlzaAtEuB2+Wxa9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF25FF87461
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 09C27180007
X-Stat-Signature: 6x8i61td7meru6nt644s8p7sata46qs5
X-Rspam-User: 
X-HE-Tag: 1759163423-458548
X-HE-Meta: U2FsdGVkX1+2k8NHbpEIJTB4F9Gv0sUZi1novHW5SirgwvsY39VwSZLQl6JQyKvAXrJE6NHu6Y0kSoGJjiHP/7IgJPndkWoM/XFPEmJiMShVcds8dLCRrv5DvzE1Ibx566jTX+WX2VbaDSMlNQpszVcsHCs6O8xeApmG+AhU/jSrrFMgb2La0XOrKakRx3UNJcAyJ3AQJFEQIHi7HYIVis2YkCSVlx3B2x51+z0BLXfGmDxUaqIcCjL/LR/n3wOsheLODt3K35UrVlMHWyhi9huajyNihBsN2S8+hZSUvU/OvGImmlnhM79rLOkPtXjWJWhcHPkFPoHqW0YaeesNYHt8jQ0onQSIReYnEQteD6RfpyoKbHOu/Tvab9TkU8kkX7+gXai1y1Oy+A+hTZ/fm5Eh/NdZEmGx/sibKGrhw8prgoE4EY2jV2BNikPn+lVZ8lUp+n7ihRT6NJL6mzbGdlRI0FqjenSGxrhaxE+C/UdxVNoUVANuWZWUHeyq//q8qzwWCX3PX2btFZuLWV54JDBOb+JJrptrJDAwwn9rNRvptvtZ/BBYMQDY9wNSfItjZrZIJl3nWnOXJF4JSMZ3XlLVotTToEbf8OkH6HJmVk3o9d4pgMYj/oWGhBWwa2inuezzZ+HQdueAnCFVkBTfdyTOObU3KrBYpYfvlG+0JVjGcPuUSWiXYrBVFlZKhhKetv53bu40AuU9JErysfFWd1o1Hq7ggEQI+sF/C+KAOzQpqA/2AAftkuNXZNmKylzh3hY3eKncpfbZvphHdPIOYTy+RfDmAVt7vKK8WB9OgczutULzTnT492f4s2qiHmDHhDy8dvCIlt5lE4J+vgDf8AMBTRq9hmiN9oHVY7I3wH++/YkMPZFss+s4JP9lspr+QhnpECpp47334SOqCL3RNzgscp4Fzv8v1Y/zxWS/h8JUOzbsLsmMe2RKVKOUz3+NSYDsLn5O8OOfwSh28fd
 FEJmmPCs
 fAwtUZNFz0ON0UuY0xYejeNFnmrRuCBZbkGr7kYum52MMIejD2lMJnuRSLbbnUEZhaV8tU1UHsSCBTY1J+5v4pcmkcbDJj0tWp8hw97moQAWBGAXuevNzolR5cKJCtsJZmcyR64G3hkv0qtKtFVsMsmxlS/uoMJQUS0JU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgVG9ueSwNCg0KPiBGcm9tOiBMdWNrLCBUb255IDx0b255Lmx1Y2tAaW50ZWwuY29tPg0KPiBb
Li4uXQ0KPiBTdWJqZWN0OiBSRTogW1BBVENIIDEvMV0gbW06IHByZXZlbnQgcG9pc29uIGNvbnN1
bXB0aW9uIHdoZW4gc3BsaXR0aW5nIFRIUA0KPiANCj4gPiBNaWFvaGUgbWVudGlvbmVkIGluIGFu
b3RoZXIgZS1tYWlsIHRoYXQgdGhlcmUgd2FzIGFuwqBIV1BvaXNvbmVkIGZsYWcNCj4gZm9yIHRo
ZSByYXcgZXJyb3IgNEsgcGFnZS4NCj4gPiBXZSBjb3VsZCB1c2UgdGhhdCBmbGFnIGp1c3QgdG8g
c2tpcCB0aGF0IHJhdyBlcnJvciBwYWdlIGFuZCBzdGlsbCB1c2UNCj4gPiB0aGUgemVyb3BhZ2Ug
Zm9yIG90aGVyIGhlYWx0aHkgc3ViLXBhZ2VzLiBJJ2xsIHRyeSB0aGF0Lg0KPiANCj4gVGhhdCBI
V1BvaXNvbmVkIGZsYWcgaXMgb25seSBzZXQgZm9yIHJhdyBwYWdlcyB3aGVyZSBhbiBlcnJvciBo
YXMgYmVlbg0KPiBkZXRlY3RlZC4gTWF5YmUgTGludXggY291bGQgaW1wbGVtZW50IGFuDQo+ICJp
c190aGlzX3BhZ2VfYWxsX3plcm9fbWNfc2FmZSgpIlsxXSB0aGF0IHdvdWxkIGNhdGNoIHVuZGV0
ZWN0ZWQgcG9pc29uDQoNClRoaXMgc291bmRzIGxpa2UgYcKgZ3JlYXQgc3VnZ2VzdGlvbiB0byBt
ZS4gDQpMZXQncyBzZWUgd2hhdCBvdGhlcnMgdGhpbmsgYWJvdXQgdGhpcyBhbmQgdGhlIG5hbWUg
KHRob3VnaCB0aGUgbmFtZSBhbHJlYWR5IExHVE0g8J+YiikuDQoNCj4gYW5kIGF2b2lkIGEgY3Jh
c2ggaW4gdGhhdCBjYXNlIHRvbz8NCj4gDQo+IC1Ub255DQo+IA0KPiBbMV0gdGVycmlibGUgbmFt
ZSwgcGljayBzb21ldGhpbmcgYmV0dGVyLg0K

