Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23873F94CD8
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 07:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F93F6B008C; Wed, 22 Apr 2026 03:56:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9F06B0092; Wed, 22 Apr 2026 03:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 023AD6B0093; Wed, 22 Apr 2026 03:56:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E02586B008C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:56:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A0236141051
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:56:46 +0000 (UTC)
X-FDA: 84685435212.26.F51EE76
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf01.hostedemail.com (Postfix) with ESMTP id 29D3C4000A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:56:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hmEMFjEO;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776844603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmiAiriqucTvsbcNcvLQkm5rA0pwswcxb8vEjO0oF58=;
	b=KMVBwsl8beGekmg1U2WZJDMniT3e8Wjb4/u8s+Xj34q+64tR+7bAGqMRXghT9OCxslgHNi
	0a9uxInMiRqIJb8lor6rpuGA4Hg0fYvucoc0+zZH3j49hU8EABAXseJGD/b9qazJ8R3UVk
	efUIamGFSz3p0R1CiwqY+jd7sg45hZo=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hmEMFjEO;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776844603; a=rsa-sha256;
	cv=fail;
	b=BRp1YLqcgYkku8zfkVfSoYJJeQiWjq754eFGyQmshM/KQeeHeBUgcYo/MOhycCotrr/gqU
	XzDPLLnS9qwv9vM5W9bU/8TH6wYlQR6mAnXOR9f2HY44qwED9ip9VqYumrvsbjPC0HSJJ/
	IkA0oZXTgIhlKK7GW2622QCdYQ/vcFo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776844602; x=1808380602;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KmiAiriqucTvsbcNcvLQkm5rA0pwswcxb8vEjO0oF58=;
  b=hmEMFjEOd7lQjkfi4P5TzkCR/RURauTuFPWPyWIh1N2qP7r7GjvGRtUi
   cD6RBx0sRJOvP90sED5hGr1gHyv22duCnEHMFi+2BkFArVy9+SnuqK5X0
   YVQugOvtRtmq4HaqLf0lRLedzGlt02rXMplkpQEAiXhTN5c+GBnw+XDWc
   tY3vmudtJWrY40qEFWzfcTHMmCVIA13miSlOISZnsm80wSt669Ze8dWNW
   G/pG2F4RxgnoKPh4EreFRhVUN8lmf9CjPbAQ1TneNtRbwTpa78H/uGMr+
   nrRCAE6owLEo9QgCbYdt/lCE4fYyU2HmHeM5OunAW9XnXCCoPpRBb2JtK
   w==;
X-CSE-ConnectionGUID: yPgYSgg5R4yAHbQZT/m0Dg==
X-CSE-MsgGUID: wu0CKBlaTgmomMBXeRA6vQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11763"; a="76954622"
X-IronPort-AV: E=Sophos;i="6.23,192,1770624000"; 
   d="scan'208";a="76954622"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 00:56:41 -0700
X-CSE-ConnectionGUID: dI+XLMCASj6hkzCmZEUqqQ==
X-CSE-MsgGUID: sH3DPK/JQfq27yqQgIpSzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,192,1770624000"; 
   d="scan'208";a="237282859"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 00:56:40 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 00:56:40 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 22 Apr 2026 00:56:40 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.34) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 00:56:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PtanL01DxIhjjTr4bOfXXGrMsWqDx/fdMPJE+e4EXba7zTc8vpH92/5XVYLfoR9Y4pECWqYS6C/prKeJyo5eczQJwF28yhd0sy5gX2XP5YiPzv0DFQ/6vVUejlxkxVwhnSSWB7LGCs3YFVHGvF+O31ZddMAeUQ4KJXJ93s7mKwNVGYxcVP+L3ji/nDQ+XQEv+RZ3GYtqttqcJL3dmxNoH7szCdVdDYDzS6eqvcRM2okbOxL/3/CTbhEvYl1fQ422gQCkK1rNjgYE4yui33iqdxIoj/ttd3eGT0klR180tcHeRY8J1d5neYTbK7IujphfX0v+8Aok2nhoA3S7hIeNOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KmiAiriqucTvsbcNcvLQkm5rA0pwswcxb8vEjO0oF58=;
 b=kX9faL2cuJYZ/Fxt3uX6IMu8LYwhVgDZgojd5goorh4FldXdCbHgEwgHMreUNhAB7WSC49deZ6QI6TFqJ34dNuoTT5+l5M8LTtm38gZmBNcFGOTxqUqjzxypYZyTUrON0WieLLiQmWzjlnHwEkuyOSOa47btTSqtWjmUwukXZgvmdw77X71tMot8OOMqkfCehNJJM+vlbXxeTNKi/MUV9ljYNqYj/dvoy60w1GvD5w35EWRrFYd2yD7gn3Y40sen2197Oq8uUX+USFxzRCS104V1BCiFVcfeSs5gGCYddaEycaQ9HMQHokjZY+SJni9lY2fB9IIBW6RMCPaGIbHPYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by PH0PR11MB7423.namprd11.prod.outlook.com (2603:10b6:510:282::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Wed, 22 Apr
 2026 07:56:32 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%6]) with mapi id 15.20.9846.019; Wed, 22 Apr 2026
 07:56:31 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>,
	"Zou, Nanhai" <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	"Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
	"Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>, "Chen
 Zhang" <zhangchen.kidd@jd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 0/2] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Thread-Topic: [PATCH v4 0/2] mm/memory hotplug/unplug: Optimize zone
 contiguous check when changing pfn range
Thread-Index: AQHc0Y4fvsNctkwngUWvH8b5jJmZiLXqtS2AgAAChWA=
Date: Wed, 22 Apr 2026 07:56:31 +0000
Message-ID: <MW4PR11MB69364107F48CFD6D35AA9771A32D2@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260421125508.2317429-1-yuan1.liu@intel.com>
 <2fef4fae-b7fd-4c27-9a76-994076e27b5f@kernel.org>
In-Reply-To: <2fef4fae-b7fd-4c27-9a76-994076e27b5f@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|PH0PR11MB7423:EE_
x-ms-office365-filtering-correlation-id: cdd9905f-b6ae-474c-a5d7-08dea044aaf0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|38070700021|22082099003|18002099003;
x-microsoft-antispam-message-info: 5VPyLyoY8+foXDf1eVapxwez9jXxk7s9zZ+X7gyzQ9dN75ensWFfmboL1OdFYe5ck1F9H7sS2DOQnB2mZYwpshhgHF9olrYOymY9BEuPbeqfHZNNnLOE5cFW6GTIsUrFlNxtLzuFWoRMDDpNm3jUu6uEuIMSd1R0Q00HtuJ5RVC7K3aqqQeMMbFIh3+2efEpL8jok7DE/QcjGmtGtXODtfOptEH71PrinABOFIl7r0WxV0SmrJFZGqx+pEMJU1o3P1Jm8vRzdsCb56Kyh2i4LuPWEQGrCjzjxNKuaNJ/sJebAiu+5DvXA1iFWH06kuUp/UdVnSs9bV07SJxhECF25NapUel+DaVZDqExLB11E16tVSvGtAwqi4hpqAvLZDOetVtZSR62Q+JvHrH01EkQQYXSHtCbNKgs82j8/Kfgp43Z0XRYZa6lGYi2l2XJG64F7qCWgI9JgDrOmjWSgY4MQd9WA5XLtKJJ9nCZOOhMIQlvn9ES4Cmqx/jfafN3+0cFEUF54SAL7l38omdfSEdM6NWKpX0Gaim+VjyyhOktLoo8S6Uqx/Rz/4pcJYuOSXtkSY7dw0yUKh02zX6lxENZY3m/qsVTAUI6h3RE4QEUho93DhLzKH57PuaDTgwrrt6n70Mi5mivwX5wE0C0TLMXmp8en52vHT8tWfnKjA0dkftKEqxVBqrzxVSE3vbMlbMLAyIDQIs9sczcGG+2fG2G/uwnvVDXt5Kha58BrIaM1+++BIDa3BljAmjoWsHPpIp/8dDocicrUcArn2MC64XC9yoFijMESnSrvZKBzbBLwdiJdJLXBqD9vIKo2YnD5Hqh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(38070700021)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a2hTelZpeUIwUXZGSVJvVlBIU2ViU0ZPU24wUWVvL0lXRmpETGVsRUdJcmR1?=
 =?utf-8?B?YWdiYXZYdFFiaEpaMDNsRkdrUk1rTWt2blJLaUdpSmhNMGdaVFFRS2QwWGth?=
 =?utf-8?B?RDJ4bUQ5VEFLWHA0ZTFlN3JsOE5CblJvZjR1MzRvUE1TLzQyeDYya3FYZGk5?=
 =?utf-8?B?c2syTVRzMlJJb3o0bTJKMkRNSmRIY3NwajIvTVZ3V3RNU1RTQlpTUGowZlJs?=
 =?utf-8?B?eTdvcFlqcTZNNi83WS9HSkxvZlZDb29pZmUwRXJSSjF5ZkthbmhsRzZZRWR1?=
 =?utf-8?B?UEhVTkNSZlBBOVF1Mks2NFFzaDlkYWQ3RUNnS091WnpmY2VQek95WDZkVHRv?=
 =?utf-8?B?YkVsME5jblcvWXlKMzEvd2M5c21OdCtHVVdUd0w5Ym1ZZmRLMjhubXVIVWdI?=
 =?utf-8?B?YWw5NkxUc2hsOGNCOHFzNURUZDlvZkN0Qks4K3ZhN3VDTmhUWGFXT3QvTGNG?=
 =?utf-8?B?WXI2SXFZMVJtcEhYQlB5TGtqdWp6NGhzTGRuMkxyM0hhcnQwaEtvZGM3Uzl2?=
 =?utf-8?B?VjNxZmFwSmNnazN4cnZnMHI1Uzd1MzZaSDRxaEVhSUl6ZGpCUUt4YVBrNUd5?=
 =?utf-8?B?VnJrbU9xUHROTG5HVHNONmZwekhKVStTanZ2OEVYdkZudXd2S1ZRT0Q0em5P?=
 =?utf-8?B?Q3UrazE3Z3VDdkYvclRyVGdOSjg4MEpkRkMwaXdMTkY4OFRqaFAwbnYxN21N?=
 =?utf-8?B?eG9RdGR4YVlmVUZXcWFEOGdJTjlNUFp1RnFaVHlWa0RHSmRZcFlLanMzTk8r?=
 =?utf-8?B?STB2bGdaN0gzT1dVankwVk81QWY1enBpRVdHU205QUtFK2s3cERnekFFUDNB?=
 =?utf-8?B?enQyU2wrVnJXWGZ4ODZLNnV3bWpVRzJhTzFFY2haZTlGMFNmUktxVjF3Q0xt?=
 =?utf-8?B?ek9rWUQ1dW1zemdocSs2UDZ4S3BCK204K3NjYW1KbzltUkVZWXFLZjdlTXZM?=
 =?utf-8?B?ZWlNVTFnQWJUeVZNR2xYVzNOK0h0RFh6dHJPY2tyaHp0eEhJV3p2dnpXMmtp?=
 =?utf-8?B?UmtEa0tDdXRCVTdLcEF0U1RZSjh3MUNsNnRJZ203Q0RWTWhmdGgxV2tlMnRQ?=
 =?utf-8?B?QXBVSUZMUXFDVWE0ZEhNNTRxN3hMVHVCUk9tRUxHY0Q5VDVTYkhpeTdGMFZI?=
 =?utf-8?B?VHNSNWhjT2VUTmpYTFc5bjBndUdnRnJ0T1lLa3pFdm0rWm9rSnMvL3A1N2Fw?=
 =?utf-8?B?OHBYSGNnN0l5LzVOT0xCYWdBTWJ1cldsR0pyNGZxZllnZ2ZYNWE4VXZhUUlw?=
 =?utf-8?B?d1ZMei94RWJjUE9pMVl0RmdlUXQrRElrOCtsb1JwQ3hCa2xyRGIrQitEcjV1?=
 =?utf-8?B?OXRvU2NVY01qajhicXMrWnlBaEtuT0JkWS93Z1JsTFYwaGJvRUJHTm1zS3l4?=
 =?utf-8?B?di8walk4NHlKWnBTL05tcVBrV2hEeThTc3REeEVLMkdSd3NxaTlVdGtGbFFJ?=
 =?utf-8?B?WldpVWdHUkFKUEdtNlVGOWg3a0dxaFpPS0FWT0lCOFBPSzVGUndwZ21xNEZy?=
 =?utf-8?B?c0F5MEhiSWJZNm1sNUpCQkhrZ0o1clJNTng3WnRGWkxLRXVraUh5aDhRSm5v?=
 =?utf-8?B?aVRDQzYvZXBhRldzMUhPUHhqMFN1LzJKcy9ZRStZWnZvZ0pZMWVlcnFKSk9u?=
 =?utf-8?B?djRFWmFoYjNkKzQwVW5oNVFyREFTSG5mSW9adnlGZjZkL3o4Q1NjcUNRY1dq?=
 =?utf-8?B?YnJqeHRxOE9VQ2hNeTVCa3RiV1ZKVHpYRkR2ajhMNis2RGFqU00zS1d5ZlRh?=
 =?utf-8?B?NUo0MXMwMmdMWWZsVzRSVEs2UnFkS2FrTlBqc1ZJS0RKM1h6S2Z3Mkt5NUt3?=
 =?utf-8?B?TDNWTExlTWJUSXdjalFKOXZkOGpLa0FRUmV2b3YzbytmbXhOc3FxRTh2cUpu?=
 =?utf-8?B?V1g2U3dwUjFQeDVhbVQyZjRYWWw5V0xSdmNWREtWV0RIQjVHWDMvY0ZGVENL?=
 =?utf-8?B?WFJackd3OHNVd0F0QW5lZ3dMdkkrK0IrWkJsT2lQdGhNUUNMeTFYa05iMSt0?=
 =?utf-8?B?NnI5SzlRWGpIRThPb1pjQzkwQUNBTmdxYUNoa2N5NFFDaU5YZFRHeGp4bnh4?=
 =?utf-8?B?UElXUHF5U2RXSHFGUE9xWWZSUUQvVFJybTljOVk3a1d0YVZtdlZOZG4wWHp1?=
 =?utf-8?B?YXZnUWZBYXFxUEtvR0NqZUVlcGYwS0hMMDhrdzhDeHZ0YlhuN21idGpabTVv?=
 =?utf-8?B?NmRkeXhIU1JNUy90ajdNZTFHc1hZQ0tyLy9kNnpTUmtoQVIxYjJQS1VrbFgx?=
 =?utf-8?B?QnhoU2hCSm9LTXRCb1dIVUpHWjR2eElzUGZ6UjdYMlVJTDZtYmk1WmlTQ25o?=
 =?utf-8?B?ZG52QU9HMzJlMFQ5eENvNkpCOG0vSHRoK0ljSytpU0g1ZTRFcGJPQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: BOKskkPidYdwArE8T44vH5FR0oVOc/CG7gfPJV1lATt6U0iEjlQW7+rnMvXL62/SSGYCD7IpY78pSQ+tcJG8V8vwocFRbQfT1V2kuLr2Mnsu02YJ/a1YI26NpH8serjoGOAxtO7kswm0kYms+L44PSXXukkTjwgSbVfsAJSWXYYYX4adaIr7dHvG2PZjgIV+Axc+aNjBJIp0N3BQHSoGjZWn7nRJf3JtBcx9JaYczaN4nDwKQyRzAtsZbHFj85qL182hmyig3IG4S8rg6Ykb7pjmoH1PVqO4untk+bl+RpcpnDNrFX6dXGR0MNjO7EufPwF2ZpMpo7w3QvqGrmS/Tg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdd9905f-b6ae-474c-a5d7-08dea044aaf0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2026 07:56:31.9220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CaaiiQWY66p/DJgQ4u195iKwEp5g1N4Ej/P8X/Y5RM6ywbaBfF0JtQdUSy2o7HMZhx6qvHuf3iVr9MgW1AlqcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7423
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 29D3C4000A
X-Stat-Signature: h8h7trwsfy4jh7b75ke7memkrdofbi98
X-Rspam-User: 
X-HE-Tag: 1776844601-669686
X-HE-Meta: U2FsdGVkX18uO8Ku6JibdzKQydWoiYVnGN99I/ccRap5Hl+niVMpZ/5U+QRwY8oqbxKg8rgfSbdxAhaVyhTwbYIhGzX/23AdM+KPNba9k4zbxqoyfivUkSiDSfRBF1cfXTEYSopJ/O5vpxwaQAU+iUPbHyNsE8KhOczXhQYX/1Fp8TCSb4VQY/rDu3iCSpp+n2s/mM56XHEtkseWRTZgLqCMOsg7TuACgXvUs1nzjx0nLLNddE/dZDm0Z9oT4GCThmD0HMS32m05VCULC3d9vaOHm6fpUi20pY1pDF8a1Rl/yjr7D6q125y9cQ6r4NOklKSdvecVgW+61xjWrGl2wIIYE+/xxQ/pTLPG3zZeLpeHgSjfG5nzuCT6ruuTu0yape3hElbhkijobexw0tXKaROBjpSm1sNfKgkT1J+4wX8jN1wAwCiIoPG9weWxPhYnXNNjyixw/Z9XsaBQGlIejtEKDs+4AhMXBZfv/ZhtPW3LHVONWSWuIKWaAVZnTmO6U6HdgdsnO8w7vqX7UINIquhLsOj7rYhmZvIIxi3MsqTV8YZGMym+BhbS31WAKdw2w6vYBVfy4qJYt3OWt8q3+ghjYy349Vun9ZlJsrmEoz7OOrRCd1JFx0NmbQia8NMTXHmDsaVvbYqCupJEySAkCWY9w5cGgrretHasMgDj9hz/Vr9Oe3KXGPZWoSjVh0CcVWySjRm1nkcya+1WDnD6KDm/r2qhofJNZluT5THhNnoCWHq4LKqJPE7TM/7NUKy1nNH2Idm/JqPt1vm/SglTmumk5jVJPKiNtu7cf9SKtxrbzHlx8Pf5trlTP/e7DFK8IYJUlbldLoGASBVjIdAJNnoNVMWbB2AOwg5BMr8gtzMEJ36EVSNb8XP4kbzUz4/4vveAnEMPP8zwOxPFAxQ9EJBom/u8LrZToVCKypNKfccBmIcy0BZ1B183uTMCI0/mAhJPOJnDsp3hOSREaqD
 IW4uxEW7
 6++qk7JArAbgp6Zk+CHUWQSgLNrQvBF/bCcz2B3ClsrvRCWyAjkN2W6EkQU8xN2cR98zQv5nTM9boNhF8cGKb+88oQZH0YvQZ+68SGxl9uWjtYLKcnyP7TOk4VEgXRZLX8+KN+qSlGgySGKqdNeO5QUfdgvfD2MNJ9lzGLppzHauSFf4JcNG3iA4SSQTArqBdR67y7Y58AnkFSqenrcpR0RcAwiArZULKwzeodntei1vpNEwuCnsJWSiZzTiSKNhriJ1WcK7j33/3hwJUa4Vi9HPnwg1eWsh5fqNzzXlweUF1VHjnkE3JaH/lgM9FiK1taS5ed0aHzVUC19/cvkkd1BZ6NMkUSCqmg9fvkMEs2u/g3IXqUR/uzhSR6eVelkV2S1PWwDuw5E4x+NHq5+cguA/RoyGVVlU5k7YHl5F/wfk3qVsseKXcCCWh20AU1H2/gOJjFSBYtTTiLUEtM53xYMcKsofWUDDXZkpK352/JYSkt3NGviWzUljQFDs9qaCtl4v4tjc3amCea83LeO5Ju72KDqucmRzL5qbMtARDS0U8EBYi7iu5gzybl3uGuHWXloDjmw7+Uv8WKsz8yj0OMQkHH1A+OaPuv3CA+Eq5fLl/hH/LjEugjPrifz8TZ7AiHQBnymVSBkmM/1oMSQBze/Ayq/HwZthWX/+RYe5b1Wkt/MV4E35b/lng9qNNstTxRJP6nCIowTPrkqtDarntmdOousV4GnUB/3CtfkKeRW3evRD7a4jHQXOEPHzZx+4DoEhkP9kGmUaEZbjics4DoXuOc4DxGbaSs2nUEU4POyyC4KCkSXViwvhz2qFc/w7CQtrA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBIaWxkZW5icmFuZCAo
QXJtKSA8ZGF2aWRAa2VybmVsLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCBBcHJpbCAyMiwgMjAy
NiAzOjQ3IFBNDQo+IFRvOiBMaXUsIFl1YW4xIDx5dWFuMS5saXVAaW50ZWwuY29tPjsgT3NjYXIg
U2FsdmFkb3IgPG9zYWx2YWRvckBzdXNlLmRlPjsNCj4gTWlrZSBSYXBvcG9ydCA8cnBwdEBrZXJu
ZWwub3JnPjsgV2VpIFlhbmcgPHJpY2hhcmQud2VpeWFuZ0BnbWFpbC5jb20+DQo+IENjOiBsaW51
eC1tbUBrdmFjay5vcmc7IEh1LCBZb25nIDx5b25nLmh1QGludGVsLmNvbT47IFpvdSwgTmFuaGFp
DQo+IDxuYW5oYWkuem91QGludGVsLmNvbT47IFRpbSBDaGVuIDx0aW0uYy5jaGVuQGxpbnV4Lmlu
dGVsLmNvbT47IFpodW8sIFFpdXh1DQo+IDxxaXV4dS56aHVvQGludGVsLmNvbT47IENoZW4sIFl1
IEMgPHl1LmMuY2hlbkBpbnRlbC5jb20+OyBEZW5nLCBQYW4NCj4gPHBhbi5kZW5nQGludGVsLmNv
bT47IExpLCBUaWFueW91IDx0aWFueW91LmxpQGludGVsLmNvbT47IENoZW4gWmhhbmcNCj4gPHpo
YW5nY2hlbi5raWRkQGpkLmNvbT47IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3Vi
amVjdDogUmU6IFtQQVRDSCB2NCAwLzJdIG1tL21lbW9yeSBob3RwbHVnL3VucGx1ZzogT3B0aW1p
emUgem9uZQ0KPiBjb250aWd1b3VzIGNoZWNrIHdoZW4gY2hhbmdpbmcgcGZuIHJhbmdlDQo+IA0K
PiBPbiA0LzIxLzI2IDE0OjU1LCBZdWFuIExpdSB3cm90ZToNCj4gPiBUaGlzIHNlcmllcyBjbGVh
bnMgdXAgdGhlIG92ZXJsYXAgbWVtb3J5IG1hcCBpbml0IGNoZWNrIGFuZA0KPiA+IG9wdGltaXpl
cyB6b25lIGNvbnRpZ3VvdXMgY2hlY2sgd2hlbiBjaGFuZ2luZyBwZm4gcmFuZ2UuDQo+ID4NCj4g
PiBJbiBhZGRpdGlvbiB0byBwcm92aWRpbmcgYSBzaWduaWZpY2FudCBpbXByb3ZlbWVudCBmb3Ig
Vk0gaG90cGx1Zw0KPiA+IChzZWUgdGhlIHNlY29uZCBwYXRjaCBmb3IgcmVmZXJlbmNlKSwgaXQg
YnJpbmdzIGJlbmVmaXRzIGZvciBDWEwNCj4gPiBob3RwbHVnIGFzIHdlbGwuIFRoZSBsaW5rIGlz
IGFzIGZvbGxvd3MNCj4gPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNjA0MDkwMjM1
NTIuR0EyODA3QEFFLw0KPiA+DQo+ID4gdjMgbGluazoNCj4gPiAgICAgaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvYWxsLzIwMjYwNDA4MDMxNjE1LjE4MzE5MjItMS0NCj4geXVhbjEubGl1QGludGVs
LmNvbS8NCj4gPg0KPiA+IHY0IGNoYW5nZXM6DQo+ID4gICAgIEFkZCBhIG5ldyBwYXRjaCBmb3Ig
Y2xlYW4gdXAgb3ZlcmxhcCBtZW1vcnkgbWFwIGluaXQgY2hlY2sNCj4gDQo+IERpZG4ndCB5b3Ug
YWxzbyB3YW50ZWQgdG8gYWRkIGEgcGF0Y2ggdG8gaW1wcm92ZSBzaHJpbmtfem9uZV9zcGFuIHRv
IGNoZWNrDQo+IGJvdGgNCj4gc2lkZXMgb2YgdGhlIFBBR0VTX1BFUl9TVUJTRUNUSU9OIGJsb2Nr
IGZvciBmaXR0aW5nIG5pZCt6aWQ/DQoNCkhpIERhdmlkDQoNCk15IGFwb2xvZ2llcyBmb3IgbWlz
c2luZyB0aGlzLiBJIHdpbGwgaW5jbHVkZSBpdCBpbiB0aGUgbmV4dCB2ZXJzaW9uLg0KIA0KPiAt
LQ0KPiBDaGVlcnMsDQo+IA0KPiBEYXZpZA0K

