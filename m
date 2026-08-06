Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D104C55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 07:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 153536B007B; Thu,  6 Aug 2026 03:24:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 103C66B0088; Thu,  6 Aug 2026 03:24:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE87E6B008A; Thu,  6 Aug 2026 03:24:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F94D6B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:24:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2890880697
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:24:05 +0000 (UTC)
X-FDA: 85070005650.01.A8EFA78
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf09.hostedemail.com (Postfix) with ESMTP id BE341140008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:24:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UlGCqeOK;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786001041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I3ktlcBX6RTQGl6uTVQItkfF+afjQqjLdUJ9T/G2aAc=;
	b=DAmiDdhSLuekfiWeNnwiGlvvT692ot6I7Fs3cx7YjB/xJjDSpx0oxtKXrilYhjPCrZU5ah
	KZruZv/tl/zvXw+silPio70iZpF+BoSVcQAIu7WdDc6Js5Qhkd3SJURLEwNN1Mq7VOk6mJ
	dxBgMCPwPw5t9Hdc/WPEOkzkvYHj86Q=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UlGCqeOK;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786001041;
	b=q4jx29jpZHG37yx5JCF40MBLY//hIGDe2VfIED5srGjGaUP+xwC0qqnaD/4NzxK5D3dxUW
	/5475VXV/4oiBQHvhOZ7OM61lfzXFaq908L6b/vOzkqi0Qfwzihuz5inFzm/tX6BqK0XHT
	PF86I7ei60FvrXFDKNaYYqJYC7nAgP4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786001041; x=1817537041;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I3ktlcBX6RTQGl6uTVQItkfF+afjQqjLdUJ9T/G2aAc=;
  b=UlGCqeOKnkG+BqU6a7DBWIlKpykHKL84xDU+zVQf5V3JV0/Q8IsKpyEY
   2r291C5fgEyklkLl149VDR8fLX2jc5jRBAen0XO8lKBbdHKE4Vapifvex
   nxANERmbSwErB2n1B9rp0sZbXaV34we0IzFOlSsOlqILhBIv4ieRWPpCX
   32fBnhjuvNA48eUsflftyJtkSImA541SajMt/oG8SLzESjE/XOLr91ccM
   E2PDPpuhRRIFZ4t126C71ThBdsfKTsBpQdTNTwEqPZeQxpuNbefJm+DIV
   ga4K4Z8iy3RS1mqXjTeEQ3wUql524SBC8du0slHZTbQN1GUXzDmAzUwRI
   Q==;
X-CSE-ConnectionGUID: yzsUGAFSQam4Jl/eX7mgcA==
X-CSE-MsgGUID: B7gtmpFWT42DiDcGWOMd8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="96935880"
X-IronPort-AV: E=Sophos;i="6.25,208,1779174000"; 
   d="scan'208";a="96935880"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2026 00:23:59 -0700
X-CSE-ConnectionGUID: Ir2y0YFJTnOx+7LXIHnoLw==
X-CSE-MsgGUID: eSi5vuHBQVWPHlCpfzSM1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,208,1779174000"; 
   d="scan'208";a="262643417"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2026 00:24:00 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 6 Aug 2026 00:23:59 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 6 Aug 2026 00:23:59 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.29) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 6 Aug 2026 00:23:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BbuJ8Vewydk/YBzv4To0pYECzpJ4zEXCSm3KDjA9u4BCCOY/EEL4xUo3lDmbFobwG1LsC8IpP47xCAQX3vrA8C6vX1EKw4MoTPJT1c/Zt3XAd9cWu6UjEyZCVxuvQkLlfAW0J4bIZtL3mqgeq9twFgewPTryEpqy+DaZwlSfCuxh6M/TcrRE6YlK4qNFxzytZNB3dWa1KSM8/6fMRGNnlKBcE71KOhvV4vo5jZJi2Ovb7pk4Zu4RqcAvcNBSIX7qMV3a2iUtxiWik3OvdBuFEzv+C51JJ3O0PfDfTVDI9JXq85YaE0Or1FdnO252A7rUli5WeqY+Mq7XJWk+i198YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I3ktlcBX6RTQGl6uTVQItkfF+afjQqjLdUJ9T/G2aAc=;
 b=lCJYo4qOzIrahOR177L5y785btMEDdRuY4ZoFR3g16k0B5Mb6lpKZ/a/IHhaPLyl24B2VL5e/haN9mFqY25u1XpqOj9xoDOiJSYLhmmfwL5huxXD8RMSHAGSiV/NXNXF+QYlu2ufkEw3FydbuZc5Tb2UZ2IPggvSHA0waAx7oo/XO/y/3/WO/F9XaeEGZBbTaTZDyP0nE03f1SqTJhdrHlQMUSud6D0sx/NQRPfi1Uj8g7cC4fA6/na27OF1/sIPF41f2/bu9+SCYKf0IeG/dVjAq5sG+/8HIfntrNsL6kmQYpKZquRjJpGRkeAWqAyRZ1Xk/JOrsFFZJcTRED8bqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6932.namprd11.prod.outlook.com (2603:10b6:510:207::5)
 by LV0PR11MB9815.namprd11.prod.outlook.com (2603:10b6:408:385::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Thu, 6 Aug
 2026 07:23:57 +0000
Received: from PH7PR11MB6932.namprd11.prod.outlook.com
 ([fe80::cca2:8c49:b4b1:761e]) by PH7PR11MB6932.namprd11.prod.outlook.com
 ([fe80::cca2:8c49:b4b1:761e%5]) with mapi id 15.21.0292.019; Thu, 6 Aug 2026
 07:23:56 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "Zou, Nanhai"
	<nanhai.zou@intel.com>, "Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou"
	<tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>, "Zeng, Jason"
	<jason.zeng@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 1/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Topic: [PATCH v6 1/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Index: AQHdGn+xVv6zTQASmkebGsn1WtDYrbaPbQmAgAFEj3A=
Date: Thu, 6 Aug 2026 07:23:56 +0000
Message-ID: <PH7PR11MB6932A554A6D18A4F1A29E90DA3D22@PH7PR11MB6932.namprd11.prod.outlook.com>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
 <20260723084946.189392-2-yuan1.liu@intel.com>
 <a15107de-ab16-433a-a504-72c3e8dbf2a6@kernel.org>
In-Reply-To: <a15107de-ab16-433a-a504-72c3e8dbf2a6@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB6932:EE_|LV0PR11MB9815:EE_
x-ms-office365-filtering-correlation-id: d1c717d7-d461-42db-188a-08def38bad07
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|38070700021|56012099006|11063799006|10067099003|4143699003|18002099003|22082099003;
x-microsoft-antispam-message-info: HM+hY8POVZaWzhYOrd+vT/0hABR1Ox3OmJPBKF+CL0PnLA2fZExWVHgWL95uVl62/VJ6zaLwUpgzvV04WUbQSy9jKh4wGYWYyjDFcaLqcV61nXliTqxyM9vwMIVqcX86G0QEZ6TOGpQeZH2UVQZJ/n5/FoLQfi/sdIWXekKSWhK6lMuocRkCbQJBfsFnnPZ3UNQ7dO6+2CJ9KWoS/fwf1leZmA1IzHiApVP7pX5UBwW8q19/3tqqpDAlVn8K4go2Rt8gvSjZFt45ECA2N8y60qknv6WianOwn62ncTGcG6j7t/KGYxbuZlEvvxxXdW+fGPLgH2m9+1Fv5JVqrWw0kCA7KB03iwYFmJSIjo1e5IKZ1MLTlvkDviroy5Fa1H26PFnXLCW8GdHWj+JC4j1qb93HW+XvJ7xApMZ0uTgXE7k25C7qILmMjiB7mQLx8Rt60bkimfr9O/46+ikqzG9GLyqrQW5uR5QEtrva0h9WduwYMLP59i5YoVe6FUWcVsRrCNtRXXCQmabUH2VEa9KGXq2KhfOBJhAz9CPNhIEJGyfUrzd/1gM/aMwT9OhWlWyMMOpjNRDHOqp4MgiCLFqKl9Pyb8jd+vcyA6De1ej9SAG+/m1gz47xxpr2b9xygTKmM4C7/nZ8kVI75TrgxBkrzmOGLJ+S9XPL9nhNv+yPhZs/7xTGu6jdXauFYc38wV7mme2Df1IU+Rqd+76aegenhPKz5lfV2Q/p91QjU0QuMEI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6932.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(38070700021)(56012099006)(11063799006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TlZKL0YwRks0dkFxM2FYOFB2MzhROE1BdlNEbDhwRnpCaEd5c01CMDJWK1RE?=
 =?utf-8?B?SzFwSXNlWmcyMXhjYm5JS1cvemdzQVhoK3RRa3huYjgyTlBCYXNoZTFVMng3?=
 =?utf-8?B?M3J3MEtFVW94aEZ1NkNpeXlwM2xIWTNQZmx3MVI5YXdtTFVYM2U0NFM2NmNr?=
 =?utf-8?B?TnRGME44WWVQczd0MTAvQWMrNVhaVkJpQnFDdkZ4bWtUYjBYLytwSHVlQjl0?=
 =?utf-8?B?bzBtbWF0enZYbFdOQTgrVzFhN3RLbnJHcDMvS3E0SFoxb2Z2RS9IVXB0SURF?=
 =?utf-8?B?SUsvWGw1dmVvMVhacjZNMjdPenZDaXB1RVZYQ2w3Yyt0WUtkdmY5SklSUUU3?=
 =?utf-8?B?UDc1QlJleFpLbzI4VzkwMnBrMlVMaDB0Rk9DSWp3VUQzc0NXblRVSzI0OXR6?=
 =?utf-8?B?b25RcEpVZ2xQRDVKUldZdmFEQzNFcW9DVkF5czZKMjN2SnJtUFZhYStFZ0d4?=
 =?utf-8?B?NXVaYlhLZVpucWZVRzFia2dLSVd4R2NDdUJTQThLb0FwbGVHOXhKM1lpdGNG?=
 =?utf-8?B?REsyRHE1dVdzU2hZT1RjdlNWeDNDOHBIYWNZZ2gzSDBkQTVGNXU4Z3BsbTlv?=
 =?utf-8?B?SjQrNHVYdjlzQ3MwODNuSkIvV1BWcVdVc2tmbXQ1eHVZVSswbW94MzRacFVy?=
 =?utf-8?B?bGxLRjA2ZExZTklVRVpERFM2R0JHZXB1KzZTTU5iVXZqNTNYVmEzQVdFSGVn?=
 =?utf-8?B?dDdxRFFpQkJXSU45QVZ1dVRDb2JRcFJtZ2w4Vy9VeEdoenZkWnJvMWU2b0Uv?=
 =?utf-8?B?Y2gxQlJ6WXl1TmJGZFBVampTRzBKdU9CaTZNWk1uUU03NlZobktLbXlrd3ps?=
 =?utf-8?B?OXBVWjZEZTBBWDRrV3BteVRxVURJVy9qR0JXRHF5Z3RWd0F3Y1BWRVdndDJl?=
 =?utf-8?B?S3RBV2VzeWVwejZPanNuY3VnMU03YXEzd0pSc2VVekorYUsyWVBOTzc1dFBB?=
 =?utf-8?B?Z3k5YUN0VHFpdzVnNXFQUHpveHdSMHc4N2g1TWdyMUJhNTVOOXJVUUdpV3Fl?=
 =?utf-8?B?RFJXREFQQnZhV3V6aFh0b3EzaldjRmhLaXllN0xldFRmdnVOOWR4UXJ5eTQv?=
 =?utf-8?B?T2hNbm5vM0lVeHVnQ09hSkt0dFdBZC9NUGhFVXJIMzBuRFk2UWh6VStMVE9p?=
 =?utf-8?B?MkhxR1Z0Z0Z5WG1VZVBGMSt6WSswK3h4bk1XYU5CL3Zseml3Z216NnBqN2ln?=
 =?utf-8?B?L1ZtM1M1WHByQXU5bHdjY21HeXlhNDIzQ1VwVHFjNWVPcWRDejBjZlN2dGRk?=
 =?utf-8?B?UzhYbE1Hd1JJcndZVVVET25vWVUyVVpId2JDR1NtSHJhaHRQTzA4NkdQUEYx?=
 =?utf-8?B?ODZxRGtGalE4TzJSREtqRXM4ZnBrOFdyZ09Fd21WQkoyaG1QaUpFMDJBTi9F?=
 =?utf-8?B?Q2ZCTC9YalJ2VEFqdHQxaDZPd1BRTDNRWndGQS9YYzFySGx6Q096blo4bFpn?=
 =?utf-8?B?c2ozeXNWdC9EUDNLMEVrWnJqWHQvczZpK2d6WVF5TnJjdkpiUTNoNksxM216?=
 =?utf-8?B?R2lxbUcwK0dsUVlOdXRDUVZLbGxjYkJzZUtmTmFHN0pWWndkcEpybGN5Qmhw?=
 =?utf-8?B?YU9NQjEvcVlIZlNkUmtOcHgvVVpaV1laZzVxUmhjYWFCYmY4eVlRWjFmZUhB?=
 =?utf-8?B?ak9jL05KL1BDSjNsU1pMVkZCQ01lSFc5aUx3SlNBYkYzb28vRUtpODBxdTFr?=
 =?utf-8?B?dVpwZVVNT2RBL0hvZlFPdElLSmppWVNxOFBXM25HMmdDMVMvRjVrUVRFcFov?=
 =?utf-8?B?ckwzVXAwMklWQmlCSXZDZExreGhBT3FCSktlRUdtd01LaUFBR3lQU3llZTAz?=
 =?utf-8?B?MExyYWRKdDRYNzd1ci9hVlE1TC9pcllsSXNzN1RNcXZHWVpiUCtwZGxyTTBv?=
 =?utf-8?B?dVBGL3hVV3JEOHBnOFk3Y2kyMGhlSDlpUUNFTXd6TS9qS0hBUzh4V3NVdGxN?=
 =?utf-8?B?eGFTNHptMFpUR1Zac0ZiTm55RFVOMWpUV1JYUmUzdTZ1dlhCUjVBWEdkYmZK?=
 =?utf-8?B?NFNJNWRTWEJxMENmNFRkOGZlWnU1WGRwU2g1VHh3cndiYzdrM2JveHZpQ1NJ?=
 =?utf-8?B?WTlVOWx4ZXgxOCtoZjN4UzVRak1MZHM4by82ZXROWnk5dHFFNEhyTGxYMDZY?=
 =?utf-8?B?VHNaWDA2ZThyeEUzQkFIR04rMUVzL2lYckRJaXVYeXJjS0czcVRDaDN5SDFB?=
 =?utf-8?B?RjN2MnVIQkMzQ2pnQXBEaUV6aXBzNEIzTCtNYTYzQVUrWjFkTXZ4a20wL0di?=
 =?utf-8?B?T3dmQmF2L293TFV6N1lIKzh2NE5abTRFSEFlaXVRaFQwOTFmKzZmZGt6ZEM4?=
 =?utf-8?Q?ztALfiHRj7JzUAT1xP?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: WO8FuLZuQG3im2LMbHgD1eEO5h9zT3NFHzmeV6mk+dkbzJhYQ5jF4O9F7iBYHSSBYIyOU7mSilj4eAZ9USTwL8TysGHhuo7rgKrnSvJZDdQMsreZ3yHNfpptddQ1VNQNy54dXc6C9mWMubTyIKK+9Q+OjtMP1zXlw/8FrpTHin3vyrmY956Im0WXVLgKYjtlhVqLrLVpeTNwZHb2AyyvleBz3wdidMWfF0cqOHHs9FLh8HEnGIEDIxmxJ+59ieMLWLwrP3YXMzzdkTvzPlL56pUWHDjUaej5+8twLeJ9AJoriZLHp32cI4ByHxLjUGzr/6qZdSsdkWW7/C695b7FYQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6932.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1c717d7-d461-42db-188a-08def38bad07
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2026 07:23:56.1960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2OZtANZk8DW1kQpq71aVmmYfuP9A3NAFSZpTw/EM65ux/npbnvkMAQNKak4gAwKb3mdaNAfL6jCuzsAZxkJpTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR11MB9815
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 5rt43f58x866n8xt1jo4qgiepjp1k11t
X-Rspamd-Queue-Id: BE341140008
X-HE-Tag: 1786001040-76384
X-HE-Meta: U2FsdGVkX1+pQAgMisQHSuTWA/HbVfLOVjzXh78jUoyiJatuOhnVRyGux7Zldp4tFCxvbMKVIl6xk4l8ACOBtwr3tzlSqdSmXPdDdvfefkQI83SXbzv8uhvDXDjw+FJ8GqWriSV/dNszkCnE1Gulhnb4245EAv1wSK9G12nWkuaQvs3nbFL+hMCHZlDAuEpsbpIOtTTHcITWergUDw33rkD6u01KR2RSa3TEAdyjU1tynHDM1xyc3vAN3EzCj+61uuw03SAqjo834diBzRISqhCguc9Am5v5+7V+TqG0dsxwn4aV8+cO6AkRARbdmS2DS8YLNeLhTj/Fnb9iHr0pxUDn5CULZgK94aiCsL3onwgn9kO461eLrQa8hVzgLMmAO2RVOJRwLo9Ot+z0Qg+el9m9j0NFrUlVHipphv1d17nYCNS0tioV6lc8ULyOfuFcCaVah8EjtOgunB6NBoyAWoZfnYuB+RVH3mKEstXfJS4ko1wSGQ3MQK9cTDq3DQ8Pgbb+0551vtSzPk1eo68GKg5R2N0lx2F/2dCe/mw1awO0dfd1bUX5y19/4rZXFwYWoyp2UjqHoDOiyjq9dLcBuMcabZPIi3aTWzxeSWWdJ733IESFp7TFBxVzpFL2w5nuTFblYdUW6pLxzXUI1Nm+adJm/e1ZDc/hAij8CuYBB6/kGfT3HC0F1Ylq7QekLRJH+JGKZZ2FVJRRNYv36V1exrvjhYwU+MkiJXTbtaBk72DoNSksKAkMgpLKEOc4Y9gChyUYSyItNoiuPEhltED4ZPK00jHcStrGMhAsFSBBwQjXKmSgB1mb9+n/q1GY2MjM2sk9Zehd6TSTDezpkXUUylBbS1m097J5AtwJqKB4ij382uDoTHJtF8pY8aJFcbQKGFhL5YtcnpxR2l62h3Pni5VvFg+Dm9OdnMVJaLOwDsSBF1SuMZj7C9npf6GIaLPRcMYGP02AJcCZ5btl4ty
 LVbIA0yJ
 K/TqKWnV6s0OBH9fzFTWfXnpfJGmBsTJAWOLFLKreNt9ik7EVXDVVoPuuEq/nYrlI5RuJLfwLTmbD7Phutg7tfMNwvOfMQ0pJsADoHhx1O6/1dK0uylTFyOyeN3cOhKrBlVMX+Jgb8kgbI8UjXlUOyQz8fmoY+cnWenbCOnprO1fCJynht0pyaCjaMyjVDenDvVkGYNyqQ7wjijgHjhu29gFQgfPOJhvUzO6akwp2hPjmp43dLnwLvYOI9MxDM9Ya4bz3XnIlmEgXUGCY2N4kXOson4zX1BBBc6JmLJP+XGvWp2yPoYUtnJm4iH9Y4Dl7tEHLx7kUG2TkL4lW4RfekO+OKu8q2EFYFT/wI1JIKDCF0romiH246MzQp0RuaE7QfoFhtwgftnYpvpF+XYzUtXC+irYkJT00LsA+PuE3pjjhORmTtLb8ShFI9Ue379C2GNLlUIXzHufYh/C+zkyMObCN01Ll5W9YugqcNtGWPjQVrUikhKfYqYXSLWQ100J3VWCyXqeYRObikRH6mcWvy0bhgydPe0DoMhTDN7mba4cMIY6wFPrm+APRc+3IKWiz4siex/LVuTEsGMZv88HNV5ekmT1GaZsCfyrw0NoF1f77L1LMvC8yEsLpESdwWr9F9Fzi+fH3NyV+yjGcjLcQuraXeIhKx9Ua8+jPvRqg8B+UPly7+aEjrC64GTXe7fUrUqIpy4EeC1rurG9vRypAYkygeoWwCYsJl7f6y/GVt9dk9iJ5DI+/QgxlgdRKG74DBmuaxOY8jnb/r2HiSdSjFoWSJSiFyeL27tCEL5Twg1CGOTQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBIaWxkZW5icmFuZCAo
QXJtKSA8ZGF2aWRAa2VybmVsLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCBBdWd1c3QgNSwgMjAy
NiA3OjUzIFBNDQo+IFRvOiBMaXUsIFl1YW4xIDx5dWFuMS5saXVAaW50ZWwuY29tPjsgT3NjYXIg
U2FsdmFkb3IgPG9zYWx2YWRvckBzdXNlLmRlPjsNCj4gTWlrZSBSYXBvcG9ydCA8cnBwdEBrZXJu
ZWwub3JnPjsgV2VpIFlhbmcgPHJpY2hhcmQud2VpeWFuZ0BnbWFpbC5jb20+DQo+IENjOiBsaW51
eC1tbUBrdmFjay5vcmc7IFpvdSwgTmFuaGFpIDxuYW5oYWkuem91QGludGVsLmNvbT47IERlbmcs
IFBhbg0KPiA8cGFuLmRlbmdAaW50ZWwuY29tPjsgTGksIFRpYW55b3UgPHRpYW55b3UubGlAaW50
ZWwuY29tPjsgQ2hlbiBaaGFuZw0KPiA8emhhbmdjaGVuLmtpZGRAamQuY29tPjsgWmVuZywgSmFz
b24gPGphc29uLnplbmdAaW50ZWwuY29tPjsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2NiAxLzJdIG1tL21lbW9yeV9ob3RwbHVnOiBvcHRp
bWl6ZSB6b25lIGNvbnRpZ3VvdXMNCj4gY2hlY2sgd2hlbiBjaGFuZ2luZyBwZm4gcmFuZ2UNCj4N
Cg0KWy4uLl0NCg0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vbW0vcGh5c2lj
YWxfbWVtb3J5LnJzdA0KPiBiL0RvY3VtZW50YXRpb24vbW0vcGh5c2ljYWxfbWVtb3J5LnJzdA0K
PiA+IGluZGV4IGI3NjE4MzU0NWU1Yi4uMGFhNjVlNmI1NDk5IDEwMDY0NA0KPiA+IC0tLSBhL0Rv
Y3VtZW50YXRpb24vbW0vcGh5c2ljYWxfbWVtb3J5LnJzdA0KPiA+ICsrKyBiL0RvY3VtZW50YXRp
b24vbW0vcGh5c2ljYWxfbWVtb3J5LnJzdA0KPiA+IEBAIC00ODMsNiArNDgzLDE5IEBAIEdlbmVy
YWwNCj4gPiAgICBgYHByZXNlbnRfcGFnZXNgYCBzaG91bGQgdXNlIGBgZ2V0X29ubGluZV9tZW1z
KClgYCB0byBnZXQgYSBzdGFibGUNCj4gdmFsdWUuIEl0DQo+ID4gICAgaXMgaW5pdGlhbGl6ZWQg
YnkgYGBjYWxjdWxhdGVfbm9kZV90b3RhbHBhZ2VzKClgYC4NCj4gPg0KPiA+ICtgYHBhZ2VzX3dp
dGhfb25saW5lX21lbW1hcGBgDQo+ID4gKyAgVHJhY2tzIHBhZ2VzIHdpdGhpbiB0aGUgem9uZSB0
aGF0IGhhdmUgYW4gb25saW5lIG1lbW9yeSBtYXAgKHByZXNlbnQNCj4gcGFnZXMNCj4gPiArICBh
bmQgbWVtb3J5IGhvbGVzIHdob3NlIG1lbW9yeSBtYXAgaGFzIGJlZW4gaW5pdGlhbGl6ZWQpLiBX
aGVuDQo+ID4gKyAgYGBzcGFubmVkX3BhZ2VzYGAgPT0gYGBwYWdlc193aXRoX29ubGluZV9tZW1t
YXBgYCwgYGBwZm5fdG9fcGFnZSgpYGANCj4gY2FuIGJlDQo+ID4gKyAgcGVyZm9ybWVkIHdpdGhv
dXQgZnVydGhlciBjaGVja3Mgb24gYW55IFBGTiB3aXRoaW4gdGhlIHpvbmUgc3Bhbi4NCj4gPiAr
DQo+ID4gKyAgTm90ZTogdGhpcyBjb3VudGVyIG1heSB0ZW1wb3JhcmlseSB1bmRlcmNvdW50IHdo
ZW4gcGFnZXMgd2l0aCBhbg0KPiBvbmxpbmUNCj4gPiArICBtZW1vcnkgbWFwIGV4aXN0IG91dHNp
ZGUgdGhlIGN1cnJlbnQgem9uZSBzcGFuLiBUaGlzIGNhbiBvbmx5IGhhcHBlbg0KPiBkdXJpbmcN
Cj4gPiArICBib290LCB3aGVuIGluaXRpYWxpemluZyB0aGUgbWVtb3J5IG1hcCBvZiBwYWdlcyB0
aGF0IGRvIG5vdCBmYWxsIGludG8NCj4gYW55DQo+ID4gKyAgem9uZSBzcGFuLiBHcm93aW5nIHRo
ZSB6b25lIHRvIGNvdmVyIHN1Y2ggcGFnZXMgYW5kIGxhdGVyIHNocmlua2luZw0KPiBpdCBiYWNr
DQo+ID4gKyAgbWF5IHJlc3VsdCBpbiBhICJ0b28gc21hbGwiIHZhbHVlLiBUaGlzIGlzIHNhZmU6
IGl0IG1lcmVseSBwcmV2ZW50cw0KPiA+ICsgIGRldGVjdGluZyBhIGNvbnRpZ3VvdXMgem9uZS4N
Cj4gDQo+IEl0J3Mgc3Vib3B0aW1hbCB0aGF0IHdlIHJlcGVhdCB0aGUgc2FtZSBjb21tZW50IHRo
YXQgd2UgYWxyZWFkeSBoYXZlIGluDQo+IHN0cnVjdA0KPiB6b25lLiBDYW4gd2UganVzdCBrZWVw
IGl0IHZyeSBzaW1wbGUgaGVyZT8NCj4gDQo+ICJQYWdlcyB3aXRoaW4gdGhlIHpvbmUgdGhhdCBo
YXZlIGFuIG9ubGluZSBtZW1vcnkgbWFwOiBwcmVzZW50IHBhZ2VzIGFuZA0KPiBtZW1vcnkNCj4g
aG9sZXMgd2hvc2UgbWVtb3J5IG1hcCBoYXMgYmVlbiBpbml0aWFsaXplZC4gU2VlIFhYWCBmb3Ig
bW9yZSBkZXRhaWxzLiINCg0KVGhhbmtzIGZvciBwb2ludGluZyBvdXQsIEkgd2lsbCBzaW1wbGlm
eSB0byB0aGlzIHNob3J0IGRlc2NyaXB0aW9uLg0KDQo+ID4gKw0KPiA+ICBgYHByZXNlbnRfZWFy
bHlfcGFnZXNgYA0KPiA+ICAgIFRoZSBwcmVzZW50IHBhZ2VzIGV4aXN0aW5nIHdpdGhpbiB0aGUg
em9uZSBsb2NhdGVkIG9uIG1lbW9yeQ0KPiBhdmFpbGFibGUgc2luY2UNCj4gPiAgICBlYXJseSBi
b290LCBleGNsdWRpbmcgaG90cGx1Z2dlZCBtZW1vcnkuIERlZmluZWQgb25seSB3aGVuDQo+ID4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmFzZS9tZW1vcnkuYyBiL2RyaXZlcnMvYmFzZS9tZW1vcnku
Yw0KPiA+IGluZGV4IGJjZmUyZDlmNGFkYi4uMjM3YWNlNDM1MzcyIDEwMDY0NA0KPiA+IC0tLSBh
L2RyaXZlcnMvYmFzZS9tZW1vcnkuYw0KPiA+ICsrKyBiL2RyaXZlcnMvYmFzZS9tZW1vcnkuYw0K
PiA+IEBAIC0yNDYsNiArMjQ2LDcgQEAgc3RhdGljIGludCBtZW1vcnlfYmxvY2tfb25saW5lKHN0
cnVjdCBtZW1vcnlfYmxvY2sNCj4gKm1lbSkNCj4gPiAgCQlucl92bWVtbWFwX3BhZ2VzID0gbWVt
LT5hbHRtYXAtPmZyZWU7DQo+ID4NCj4gPiAgCW1lbV9ob3RwbHVnX2JlZ2luKCk7DQo+ID4gKwlj
bGVhcl96b25lX2NvbnRpZ3VvdXMoem9uZSk7DQo+ID4gIAlpZiAobnJfdm1lbW1hcF9wYWdlcykg
ew0KPiA+ICAJCXJldCA9IG1ocF9pbml0X21lbW1hcF9vbl9tZW1vcnkoc3RhcnRfcGZuLCBucl92
bWVtbWFwX3BhZ2VzLA0KPiB6b25lKTsNCj4gPiAgCQlpZiAocmV0KQ0KPiA+IEBAIC0yNzAsNiAr
MjcxLDcgQEAgc3RhdGljIGludCBtZW1vcnlfYmxvY2tfb25saW5lKHN0cnVjdCBtZW1vcnlfYmxv
Y2sNCj4gKm1lbSkNCj4gPg0KPiA+ICAJbWVtLT56b25lID0gem9uZTsNCj4gPiAgb3V0Og0KPiA+
ICsJc2V0X3pvbmVfY29udGlndW91cyh6b25lKTsNCj4gPiAgCW1lbV9ob3RwbHVnX2RvbmUoKTsN
Cj4gPiAgCXJldHVybiByZXQ7DQo+ID4gIH0NCj4gPiBAQCAtMjgyLDYgKzI4NCw3IEBAIHN0YXRp
YyBpbnQgbWVtb3J5X2Jsb2NrX29mZmxpbmUoc3RydWN0IG1lbW9yeV9ibG9jaw0KPiAqbWVtKQ0K
PiA+ICAJdW5zaWduZWQgbG9uZyBzdGFydF9wZm4gPSBzZWN0aW9uX25yX3RvX3BmbihtZW0tPnN0
YXJ0X3NlY3Rpb25fbnIpOw0KPiA+ICAJdW5zaWduZWQgbG9uZyBucl9wYWdlcyA9IFBBR0VTX1BF
Ul9TRUNUSU9OICogc2VjdGlvbnNfcGVyX2Jsb2NrOw0KPiA+ICAJdW5zaWduZWQgbG9uZyBucl92
bWVtbWFwX3BhZ2VzID0gMDsNCj4gPiArCXN0cnVjdCB6b25lICp6b25lOw0KPiANCj4gV2h5IHRo
ZSB0ZW1wb3JhcnkgdmFyaWFibGUsIGFuZCB3aHkgbm90IGluaXRpYWxpemUgaXQgZGlyZWN0bHkg
aGVyZT8gTm90ZQ0KPiB0aGF0DQo+IA0KPiA+ICAJaW50IHJldDsNCj4gPg0KPiA+ICAJaWYgKCFt
ZW0tPnpvbmUpDQo+IA0KPiBXZSBhbHJlYWR5IHVzZSBtZW0tPnpvbmUgaGVyZS4gU28gaWYgeW91
IGFkZCBhIHZhcmlhYmxlLCBjb252ZXJ0IHRoYXQgb25lDQo+IGFzDQo+IHdlbGwuIEJ1dCBJIGd1
ZXNzIHdlIGNhbiBqdXN0IGxpZmUgd2l0aG91dCBvbmUuDQoNCldpbGwgcmVtb3ZlIHRoZSB0ZW1w
b3JhcnkgdmFyaWFibGUgaW4gbmV4dCB2ZXJzaW9uLg0KDQo+ID4gQEAgLTI5NCw3ICsyOTcsOSBA
QCBzdGF0aWMgaW50IG1lbW9yeV9ibG9ja19vZmZsaW5lKHN0cnVjdCBtZW1vcnlfYmxvY2sNCj4g
Km1lbSkNCj4gPiAgCWlmIChtZW0tPmFsdG1hcCkNCj4gPiAgCQlucl92bWVtbWFwX3BhZ2VzID0g
bWVtLT5hbHRtYXAtPmZyZWU7DQo+ID4NCj4gPiArCXpvbmUgPSBtZW0tPnpvbmU7DQo+ID4gIAlt
ZW1faG90cGx1Z19iZWdpbigpOw0KPiA+ICsJY2xlYXJfem9uZV9jb250aWd1b3VzKHpvbmUpOw0K
PiA+ICAJaWYgKG5yX3ZtZW1tYXBfcGFnZXMpDQo+ID4gIAkJYWRqdXN0X3ByZXNlbnRfcGFnZV9j
b3VudChwZm5fdG9fcGFnZShzdGFydF9wZm4pLCBtZW0tPmdyb3VwLA0KPiA+ICAJCQkJCSAgLW5y
X3ZtZW1tYXBfcGFnZXMpOw0KPiA+IEBAIC0zMTQsNiArMzE5LDcgQEAgc3RhdGljIGludCBtZW1v
cnlfYmxvY2tfb2ZmbGluZShzdHJ1Y3QgbWVtb3J5X2Jsb2NrDQo+ICptZW0pDQo+ID4NCj4gPiAg
CW1lbS0+em9uZSA9IE5VTEw7DQo+ID4gIG91dDoNCj4gPiArCXNldF96b25lX2NvbnRpZ3VvdXMo
em9uZSk7DQo+ID4gIAltZW1faG90cGx1Z19kb25lKCk7DQo+ID4gIAlyZXR1cm4gcmV0Ow0KPiA+
ICB9DQo+IA0KPiBbLi4uXQ0KPiANCj4gPiArc3RhdGljIGlubGluZSB2b2lkIHNldF96b25lX2Nv
bnRpZ3VvdXMoc3RydWN0IHpvbmUgKnpvbmUpDQo+ID4gK3sNCj4gPiArCWlmICh6b25lX2lzX3pv
bmVfZGV2aWNlKHpvbmUpKQ0KPiA+ICsJCXJldHVybjsNCj4gPiArCWlmICh6b25lLT5zcGFubmVk
X3BhZ2VzID09IHpvbmUtPnBhZ2VzX3dpdGhfb25saW5lX21lbW1hcCkNCj4gPiArCQl6b25lLT5j
b250aWd1b3VzID0gdHJ1ZTsNCj4gDQo+IE1heWJlIGl0IHdhcyBhbHJlYWR5IGRpc2N1c3NlZCAo
YW5kIEkgcmVjYWxsIHRoYXQgd2UgcHJldmlvdXNseSBoYWQgdGhhdCksDQo+IGJ1dCBJDQo+IHRo
aW5rIHdlIHJlYWxseSBuZWVkIFJFQURfT05DRSBzZW1hbnRpY3MgaGVyZSBhbmQgV1JJVEVfT05D
RSBzZW1hbnRpY3MgaW4NCj4gbWVtb3J5DQo+IGhvdHBsdWcgY29kZS4gT3RoZXJ3aXNlIGNvbmN1
cnJlbnQgdXBkYXRlcyBjb3VsZCBsZWFkIHRvIHdlaXJkIHRoaW5ncyB3aGVuDQo+IHRoZQ0KPiBj
b21waWxlciBkb2VzIGxvYWQtdGVhcmluZy4NCg0KVGhhbmtzIGZvciB5b3VyIGd1aWRhbmNlLiBJ
IHNob3VsZCBoYXZlIGNvbnNpZGVyZWQgdGhlDQpSRUFEX09OQ0UvV1JJVEVfT05DRSBzZW1hbnRp
Y3MgaGVyZS4gSSdsbCBhZGQgdGhlbSBpbiB0aGUgbmV4dA0KUmV2aXNpb24uDQoNCj4gWy4uLl0N
Cj4gDQo+ID4NCj4gPiArc3RhdGljIHZvaWQgX19pbml0IHVwZGF0ZV96b25lX29ubGluZV9tZW1t
YXBfcGFnZXMoc3RydWN0IHpvbmUgKnpvbmUsDQo+ID4gKwkJCQkJCSAgIHVuc2lnbmVkIGxvbmcg
c3RhcnRfcGZuLA0KPiA+ICsJCQkJCQkgICB1bnNpZ25lZCBsb25nIGVuZF9wZm4sDQo+ID4gKwkJ
CQkJCSAgIHVuc2lnbmVkIGxvbmcgKmhvbGVfcGZuKQ0KPiA+ICt7DQo+ID4gKyNpZmRlZiBDT05G
SUdfU1BBUlNFTUVNX1ZNRU1NQVANCj4gPiArCXVuc2lnbmVkIGxvbmcgem9uZV9zdGFydF9wZm4g
PSB6b25lLT56b25lX3N0YXJ0X3BmbjsNCj4gPiArCXVuc2lnbmVkIGxvbmcgem9uZV9lbmRfcGZu
ID0gem9uZV9zdGFydF9wZm4gKyB6b25lLT5zcGFubmVkX3BhZ2VzOw0KPiANCj4gVGhlc2UgdHdv
IGNhbiBiZSBjb25zdC4NCg0KV2lsbCBkby4NCg0KPiA+ICsJdW5zaWduZWQgbG9uZyBzdWJfc3Rh
cnQsIHN1Yl9lbmQ7DQo+ID4gKw0KPiA+ICsJc3ViX3N0YXJ0ID0gbWF4KEFMSUdOX0RPV04oc3Rh
cnRfcGZuLCBQQUdFU19QRVJfU1VCU0VDVElPTiksDQo+ID4gKwkJCXpvbmVfc3RhcnRfcGZuKTsN
Cj4gPiArCXN1Yl9lbmQgPSBtaW4oQUxJR04oZW5kX3BmbiwgUEFHRVNfUEVSX1NVQlNFQ1RJT04p
LCB6b25lX2VuZF9wZm4pOw0KPiANCj4gSG0sIEkgZG9uJ3QgaW1tZWRpYXRlbHkgdW5kZXJzdGFu
ZCB3aHkgd2UgZG8gdGhlIFBBR0VTX1BFUl9TVUJTRUNUSU9ODQo+IHRoaW5nDQo+IGhlcmUuIFdo
eSBpcyB0aGF0IHJlcXVpcmVkPw0KDQpwYWdlc193aXRoX29ubGluZV9tZW1tYXAgY291bnRzIGFs
bCBQRk5zIHdoZXJlIHBmbl90b19vbmxpbmVfcGFnZSgpIGlzDQp2YWxpZC4gV2l0aCBDT05GSUdf
U1BBUlNFTUVNX1ZNRU1NQVAsIHBmbl9zZWN0aW9uX3ZhbGlkKCkgb3BlcmF0ZXMgYXQNClBBR0VT
X1BFUl9TVUJTRUNUSU9OIGdyYW51bGFyaXR5IOKAlCB3aGVuIGFueSBwYWdlIGluIGEgc3Vic2Vj
dGlvbiBoYXMNCm1lbW9yeSwgdGhlIGVudGlyZSBzdWJzZWN0aW9uIGlzIHZhbGlkL29ubGluZS4g
U28gd2UgYWxpZ24gdG8gc3Vic2VjdGlvbg0KYm91bmRhcmllcyB0byBpbmNsdWRlIGhvbGUgcGFn
ZXMgd2l0aGluIHBhcnRpYWxseS1wb3B1bGF0ZWQgc3Vic2VjdGlvbnMuDQoNCkkgY2FuIGFsc28g
YWRkIGEgY29tbWVudCBpbiB0aGUgY29kZSB0byBtYWtlIHRoaXMgaW50ZW50IGNsZWFyZXIuDQov
Kg0KICogV2l0aCBDT05GSUdfU1BBUlNFTUVNX1ZNRU1NQVAsIHBmbl9zZWN0aW9uX3ZhbGlkKCkg
b3BlcmF0ZXMgYXQNCiAqIFBBR0VTX1BFUl9TVUJTRUNUSU9OIGdyYW51bGFyaXR5LCBzbyBhbGln
biB0byBzdWJzZWN0aW9uIGJvdW5kYXJpZXMNCiAqIHRvIGluY2x1ZGUgYWxsIFBGTnMgZm9yIHdo
aWNoIHBmbl90b19vbmxpbmVfcGFnZSgpIGlzIHZhbGlkLg0KICovDQoNCkJlc3QgUmVnYXJkcywN
CkxpdSwgWXVhbjENCg0KPiBDaGVlcnMsDQo+IA0KPiBEYXZpZA0K

