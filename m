Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B885E674B1
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 14:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC08F6B0088; Mon, 22 Dec 2025 09:07:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6EE56B0092; Mon, 22 Dec 2025 09:07:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25D76B0095; Mon, 22 Dec 2025 09:07:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9A3316B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:07:06 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1EF2F1601B4
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:07:06 +0000 (UTC)
X-FDA: 84247283652.29.6A7EFF7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2FC1D160014
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:07:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TknS9+wg;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf08.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766412422; a=rsa-sha256;
	cv=fail;
	b=sVqZ2mWx88pwKENipSYU6BxpLFsqVJ2WHJzE4mUoTqiuvTFobzXsVcEDGMF4I+5b23guU4
	i0yvEnntlvoymAtTpit2a1eLWC6c/TosH1b7MHALGfLcp38LsycOwGC3lzt0JwYxrqThrn
	yzuAcDsveHKj4UVzrWWytEmVU8ILZ+8=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TknS9+wg;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf08.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766412422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=86lcj8xedhW54n01oxweVKHHhQEeWpIY2bH3ot3sV80=;
	b=NsE8+KD/Ut/oEcBzWzBzfEFLe8S1xaaGqOmx8Q+AdI0jL9DTl6+QV2LhEo1KZSE+69PDHN
	bdVTHDqqBcM/u7JCF1Og5N+S1IayzfcvZGoliAH6dv+IC/b9j+4JHe6DDDHK3qpbNC/XLx
	GxZ4LK/B7oFKI2iT+NUgAFCXR3OsuwQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766412422; x=1797948422;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=y/tK4m0fBzeZMctDnvr9BMFR/tusGIg+l8MJxdDS5Qc=;
  b=TknS9+wgnmm+xGEz+ga2gbclF4T1WwmlU6r1QKpY/nN71SI/fWtMjcdc
   3UiX141dp7dXux7pjNlIjQWeXFJN9iLmBQ8ATPSGZ5F8eZ+qsxUbPOpDp
   73Mo3CyfE4CMiG1ObGiIwOmFcQP6CJ0Vf7xJdGiLkZHK8KgAoxkPvB1UR
   8MbJE6sa0okPsLot8BDtPkKcY/Fp/rOqIjW+3yQFMU+HapisPnYp7dOPq
   o7NLuoCsXqPGoGDAHYa5jVMk8r5hDtu8vusG7Y/oaJ8OHt6/TRVlzbr8o
   IQ3Siot65hzsj0L4oxr/dk3HQKmTVKx6KeGtWUVpI72LoB5ixpkmb9I3V
   Q==;
X-CSE-ConnectionGUID: Qh6/MjocR22B2QW6UiaOiA==
X-CSE-MsgGUID: uiMBf+3+RfyHnBAZxAFv8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11650"; a="68309213"
X-IronPort-AV: E=Sophos;i="6.21,168,1763452800"; 
   d="scan'208";a="68309213"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2025 06:07:01 -0800
X-CSE-ConnectionGUID: wAX/csScSlCZQ7tvWL5rGA==
X-CSE-MsgGUID: 8bDIuXwyR3mbXJ7U9CzAkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,168,1763452800"; 
   d="scan'208";a="199171593"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2025 06:07:01 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 22 Dec 2025 06:07:00 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 22 Dec 2025 06:07:00 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.14) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 22 Dec 2025 06:07:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AQ1fW19AsKgxpZZPY1KsuAnzTrs9ts6lgxhzD9JdHNrOvCkBTwyBi3o9PTC/I2aJYZK+RXWeGbqsG8vAUuAZemqsYa5IBchCaueswfLiRA/kd7A0gLDb2WPIr8HkZ9eHEiLvQ5Jg9TiDF45h3MEfabcSe+d/xjuTWQTAHY/sA97C0MyYZY1rr+LPSg2c7HJlP5pWJeF1/zmPp48GiWA1x1VQj0TGM7m4bhjzF/XXB8S0MDktsJO9h+BAwPNO6WjoHO1bZ2r1ygqa5q3s5cVUAz3hmIMOUSNfFbfwkKLcKNKkZ1HERU/CoViTYtRyO1ZPvSvNC6ivb8d8RqF4nmU+7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=86lcj8xedhW54n01oxweVKHHhQEeWpIY2bH3ot3sV80=;
 b=gle3qnAi04QNjprE7LmEvGuR2GY2nBN+uDXW6/2GrhXJXSrixvxCFNMw41TwJgg5E4hKM/n9iqvyWjtQqNfI/KDepLymuxe/VN0NUZKHGL22o+JQHyaKfVtzBXfsX/0WoMqqiXV2Iv0nAkoUd/093wMMjqT2sATdnEL7WlHoOyXhRxvkJvPp7Ck5gKTv0ax69hk0Pe+U8U+WEsMEZgnPSI+3FhxpHl51SfbhwVV2KHkaGiI+sCwVLU4ElqTKAKdsrnRGWw9b3MiXxtFgIi0C1rs5dVQP7TOAXU43NrlorE+Mwu7LCHRoS9XoX+sufMhiq2YVf/o2E8SLlZ2uuOZw0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by SA2PR11MB4810.namprd11.prod.outlook.com (2603:10b6:806:116::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Mon, 22 Dec
 2025 14:06:58 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9434.009; Mon, 22 Dec 2025
 14:06:58 +0000
Message-ID: <0b166dd0-c368-4586-9c4b-16f5e104108a@intel.com>
Date: Mon, 22 Dec 2025 22:06:48 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/2] mm/memory hotplug: fix zone->contiguous always
 false when hotplug
From: "Li, Tianyou" <tianyou.li@intel.com>
To: Mike Rapoport <rppt@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	"David Hildenbrand" <david@redhat.com>, Wei Yang <richard.weiyang@gmail.com>
CC: <linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20251215130437.3914342-1-tianyou.li@intel.com>
 <20251215130437.3914342-3-tianyou.li@intel.com> <aUUc9BNgUNguFS9K@kernel.org>
 <ee63f7c4-0adc-46ec-8e14-277609af6243@intel.com>
Content-Language: en-US
In-Reply-To: <ee63f7c4-0adc-46ec-8e14-277609af6243@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0011.apcprd02.prod.outlook.com
 (2603:1096:3:17::23) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|SA2PR11MB4810:EE_
X-MS-Office365-Filtering-Correlation-Id: 782e8203-5b3b-40ed-491e-08de41635e90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UnMrc0V0bURRbWZwK2lJbUtxaDNrS1dXOWZSUS9YVWQrNGlWdGY0cFc0ak1E?=
 =?utf-8?B?VkR3UjZzUHRsZTZRQTdTUnR4eXdiZ0ZiMHIzWFJiVnZDUGJXSWJYcGlrZ1Br?=
 =?utf-8?B?eWFGRnBXV2JoNXVRcndHa1hUMjFxaTM0SlZHYTlCakkvYnJqSEhnQ1lKQzlN?=
 =?utf-8?B?QjVFQ1RXTW9HM3ZXUisycTgyRE1CY3JHVnB3RmplaXZCdnNsakh0RlMrM29t?=
 =?utf-8?B?ejAyKzJraVF5L2dmUVc0eHlydFZJWGsySHlLRXBkRzF4Qm1nUmF2SEgrQXVk?=
 =?utf-8?B?WDdGYmJieHBvYVNkL2wvdTVBS3VCZ2lwYllBQUFLeVBCM2RjUmwzNkZvTWZq?=
 =?utf-8?B?elF6ZW05bVVmUzdTOTh0MmFDbi9qUjR1cW9sclZ0bG1oanNYVXlmUExDMlJG?=
 =?utf-8?B?T1JEb1diNVZvU2wxZW5GZC9HbC92SnpsaDVyNWwrSjN1ZmJzcUVUQmkwS29r?=
 =?utf-8?B?dGZzU2hnZnZaL0tndVRrR3lZRE83bjNtRkRrb0pLeWJFNTJJOWNxRmVQdUFa?=
 =?utf-8?B?TUNQYkN4WGY5RGEyclFaTzRiNHFMWWIzN3JucUw3dUlTb0Z5TGFLbk05cWUr?=
 =?utf-8?B?SGp3dWQ1c2k3N29Jb1k2NmRkOUgveFF4VFdWRkxreVpCSGxudGRzQTg2eEN1?=
 =?utf-8?B?d2Q5bUpEdGt4SnRFdXh3MkhSM2M5Rm00cm85anVYVmh6RGlPRGNjUjUrdkRV?=
 =?utf-8?B?ZTc1WU0vdWtCV21VWlV0V3hxWHFIbGRKWVBoVStwOUFsa0VBTDVucHRIQmQ5?=
 =?utf-8?B?clI2S1pSUTNESHppUmF0TlJMMHJNN2k2MjZrcHZjd2E0NnVHQk41ZnpTSmVr?=
 =?utf-8?B?MzltWkpxbENabE5WOFh5STlvSU5BenU3djBMSDF2endyVk1UTEx5eDlITm53?=
 =?utf-8?B?c0FlNmlzUFdsTVVkZEpIMDdsVCtKeWx3SWtwR1FBUHRnZVZwaWhKWHR4NDdZ?=
 =?utf-8?B?YW1MNkVWMUZuSTNCeVNONm11cFZJVkQ2bWpTY1R2V3JjbEUzRDUvcGFIc25w?=
 =?utf-8?B?bzhMcGNlV1VLT21ZeFVZRXpqNXAya2V0Y0tyelNieE1lRlMzZlBMY0w3RXBR?=
 =?utf-8?B?ZlUyT3R3dW82S01Jei9IZkNIYlRmekN2YW1hM084QUZya2xWY3dLeXRhU0N4?=
 =?utf-8?B?bG9ubnNPbEVDcjVsakR4NS8zbWp5MnBSZktpZjQxdzhicnZFNXpWSmw1OHRY?=
 =?utf-8?B?QXRVMVNDNW1qTlB4MTR2V054eDJRU09OQndkVkh2VTJmQUdFUmhsOHpMSytv?=
 =?utf-8?B?dDJUY0xMNXRRVW9mcFlWVjEzU0JUL1gyNG82OTBZcDRTb0JHcGlvV3RXbHVH?=
 =?utf-8?B?cXRoS1lqTktJQWRsbXpLdENFd3FZY1RxdE1UclFIYVpNcnVSbCt3TkxzeFZI?=
 =?utf-8?B?V0twNnRub09ZTGZqWThsSTdYU0tLekpEZGc0L2duOXRKUjF4MmFKeWdqVUoz?=
 =?utf-8?B?R004YWZUZ1VxL3l1aE9pVkh3UmZHZW8xYmRlUTVtcVh2blFldHlXUUZIZGp0?=
 =?utf-8?B?d0pCcDhGNkFsa01UVXhFME8wUGJSckZpY21QRFl4dzQ2a0JHRkx3RjExMm90?=
 =?utf-8?B?aTRMcVhzdzAyYWZXbkRTV0dFN3dQL1ZLYVBzVnU2TjNHNjVZK2dvQ0lyeGZ5?=
 =?utf-8?B?Z0xiZFlWY2o4M2RaODRXTWFieDFMYnAwZWxXMGdPOGF2Y1NoelZVWUxPR0dD?=
 =?utf-8?B?VFdIcmpTU0NOVWNSY2FBcjNnWlBJdUU5OU9WNUpmVEw5d3dVUTk3VnZMUUdi?=
 =?utf-8?B?SHlHZ2Q2bldOUzRnamhwVHNON3I0cEc2UEJ5WitGYXQwOFZEMURBenNDQVFl?=
 =?utf-8?B?VlBLZ3U0L2VuY3ZGQUp0QjdaY09WMVVRSHJ3aUJnY1lWUkJVeXVBNjVKVUZV?=
 =?utf-8?B?bW4zV3RWc0FSbkZlWDUwenlQeGMxRThjbEJSeE5FZUlyOWZENnJyWWtHclVk?=
 =?utf-8?Q?B0d898ePhzAcfIqcvRZq7FDBL+RD3VU3?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXo1MG4vaVB5Tm5Na3VaOXdLS3VLeEorOG4rdzhpVnFXLzUydGlqTVYybTV2?=
 =?utf-8?B?L1U3UUxGeTh5SktHZGErckptRmZLQ1NsUU1VTm8zMDR2dHIrVFVMNlFGNzVX?=
 =?utf-8?B?OWh4ZmhZVmhqcTU4MXpaT1haOHduQkVWMis4M09rSDlNNlMyQjRmbTY2Q3ht?=
 =?utf-8?B?M0NrUFc0TnQybkpCdE10UndKcmJWSmNEbmN2RjdKWFhHWkMrZ0Y2OXdhTHNT?=
 =?utf-8?B?MFhzSjh5YzFSYnBabEc3ajE4TlRWMjUyZkV1ZTdlVnZWaXNNUExucnBOeXQ3?=
 =?utf-8?B?Q084SCtBckJRbmlVNmNCaU1NaDBsVUVyWVFMeFgxUDdnWUQrRXV0ZStkMUMv?=
 =?utf-8?B?UVpDcEkrSVU2eEdodHd0a1BOanV3MFQyY3lBcEN0YnkyeFJ1SEVUbllpOW5E?=
 =?utf-8?B?M01hNzZ0aGFEYUhwdzlpdDljZEFaaTJ0UlN6bEJKUHhpbW5zNCt1V0tFOXM4?=
 =?utf-8?B?VCtCZWtDYmo4RXFlcUZCSnhWN1gvdktLQzZjRFlpOXIvN1hsb01YZ3I1aUgy?=
 =?utf-8?B?dDlCV0ZDamhTc29lM1BJRUlxRDJmV2Fva2p6eEtqRlE0dVhZYW9pTzEwRk1x?=
 =?utf-8?B?L1cvTnc1cFh1SHp5NUlsQk43YWNrWGdKT0xweWltakV3d3ByUml4emp4S1Rm?=
 =?utf-8?B?azROejRxdWQvMytBcUNibFgxV1MrbHVaTFRmL1FoTHhJMmQwSFpidGRTajZ0?=
 =?utf-8?B?cjUyejdMN1pBbWluVFNaTzlPRmhWTEtva1BtMjNuTjJTb2hKbVRwYUk0TjZi?=
 =?utf-8?B?YmQ2anlGTE9XakZTb2R5MFhJRnB6c0RpbHFxOU05L0diSEZBb2VVQ1h3OUdR?=
 =?utf-8?B?Q2NpT2dWeVdOK0QrcmxCKy8vakxWRndPeDdDNGJzcXNwT2E2YnI2WmpUanlB?=
 =?utf-8?B?WnUwK1VTNDY5eTBZK0FPWnRmTTR5aktQdXVDZjV4c0ppUEc4YzRSZFJVVGlE?=
 =?utf-8?B?UnRtVkw5eEd5bURGaGRGd3JLeFFwd0pOQW1Nb2d4UFlMVlZCMGRTNG9Gakoz?=
 =?utf-8?B?K2QwR0RjNUFHZG5XbGhtRkhpYjBXWW4yNm9XOTVkeElwY1Q3R09WdzNWL2la?=
 =?utf-8?B?WHJxVUsxOWVFY2d3bzJ1NitUR3k3Mzk4Q3A0bGdlSkgzYWNJeGh5QjBud2ZV?=
 =?utf-8?B?bWpXYml0ZCswN2s3VEJuQXREUHZoRHp0WWExUTVyUC9QUFBXekVpVmJ5am5y?=
 =?utf-8?B?RHB0Wi9xL2p1akVXVFd1NlZtSjRHcmJGMjJsaFhaSy9GWTVMWFkyWU1HYVlt?=
 =?utf-8?B?a3RTS1RSY2VBTncvS0dHeTN1Um0zMkUwbTVxQXVSQzJubVhKNW1KU0E2NDlv?=
 =?utf-8?B?U1U1WWJ3YUdIbkhyZnVJSjhRemd5QnVZR1RrUHR6ajRiUFgzWWRYNmFpWGlm?=
 =?utf-8?B?Uk1NN0Rjc3kzckJTMDRpYjRqVTZTTXZzQSsvRVczTjEvbm43OTZnMlVpWGgz?=
 =?utf-8?B?VTdXV25tODV6Z0VaSWowNHloQU5JTExueVJwSkJGbTJSVENhM09GQ2FodmV3?=
 =?utf-8?B?cDZZaStBbmdTa0p2enZWbUdtQU4wNkpYOUNFTXpxSW9IMEwrZThhMm4wMUNa?=
 =?utf-8?B?KzAyTGpZRzhDZDgxUTlYRnhBQWdKaEc2OGFKdFFRaE85NW1EZHRMZjFXZ3ZS?=
 =?utf-8?B?QUQrNVo1azFoVWRIYWg3dDJmOG90NTJIUTNwQndvWlRPdGhKT1BUUnJaVHh6?=
 =?utf-8?B?TzY0bmZEMm93bi9YenRNbnJsOUtZaUVvUGNJcjlKS0JJVHhUa1NCaW82eW0x?=
 =?utf-8?B?QmltMjVqeldYNlYxWU80WTZpcFBvOXZSSU1TYXp6NmlZUVhVaW1ZWnBvVFBw?=
 =?utf-8?B?Z2VpMVFTNUpKa2pFaWhKNHIyMXc0Tk8xT212S3VVYmo4YjlPU2lpeEtwYlNt?=
 =?utf-8?B?QXJWU0VEL2N4cWwvU3BOcERDUW9yWUlFY2dSLytPVnV3YUd3Sk9Oc2JjeDlZ?=
 =?utf-8?B?M20yNnZYM2RVZkZTaUdhUHE5Q0FSOVpsUEpnWkVFa2Y4WjA2R1NVcExFR0tq?=
 =?utf-8?B?VW4xa0xoNnQ0ZmtvcytYRDkxS29xdmxZb0hkeVdOd0VlbnREMEM0RWcrMjZT?=
 =?utf-8?B?WllQd3psSERVQjQ1RCtkQ3RVMFRqUkphNlhsR21NVmZHTFZNOVl4L1doeitJ?=
 =?utf-8?B?T012bHdLQStVTmsybUFIRHM5MVY4VTAyb1VIb2VnMUlkdHhtUzdSRE1rWFU2?=
 =?utf-8?B?WUlpb0YxTGI2Q3BuUU1mSDlRazRRMzZnalRJMnZIR0ZjZVdKQWhCNmpVbERh?=
 =?utf-8?B?RUJTTnZDSnMwc1REVGpEYWxEbW9TaFRaZWI3NWVZNjA5TEhkc1ZDdjFCVUhi?=
 =?utf-8?B?WWVmNGlyeUxQTzNBQklxRExOS01hN1NzaFpoTS8xTVZwL1l5c08yUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 782e8203-5b3b-40ed-491e-08de41635e90
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2025 14:06:58.0624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CmhDURqHsrdEI+KcrHps9Bz7wkG2scG1CBWAWzdNlPJCL116RlDtar/PIQdGIFjWq+9XwRlTVMUGtLbd1Zvg6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4810
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 2FC1D160014
X-Rspamd-Server: rspam10
X-Stat-Signature: a4q5bfd9kqmnazhgiy38k7dqaatn8zzu
X-HE-Tag: 1766412421-596207
X-HE-Meta: U2FsdGVkX18RwDL28UxkMkvUEy/FWlnm817aNUVuMv9HUcbM1ilQQFIF7F7DNfW073Q1kkhOub82FmE1exy7hMPXY7oVjptKFjLMjSFVP01DXDlaQzute+jw0NwQpNvajGMyyPC9WMHaQNkh4joXFAtFUiCvL4JHgWXgIg4tQJI5SVMbprvMzwSFkBkxhW2THy9tdvU/T0Th10PucUXJ0owSc3tWBS4BA7j6Gseptn0AsbyUAp3V6Eox9TkR5GjYw+7XN7TL0rBv/B/Qa+eu3QA48Dp0077nNfl6Dj+Hgm2wKTnKkEVO9i8Hby8ls37U61KOiZ9Hjd91inwTKLUpycLYdzOSD/OdgpUcjzqOfl60SW0X0vQwhzYPoKSFe1OuvkfZIbl/3MWivIS6CnGOMV3ri7igrtTCuPcycdmUkxgzomwLE3VE3wCNqOKdrwGnvR6UMD2HiRCOdrHoWWloaogGv7GjvzzvoiMAVlKYoWY3a8KIYC6Zv1Y/HD20TR7wSTDY1E5csax5RmfppseF/feIXVanbRE78KHvwHni3UhSyoyUgjT5A7FamNIeUoDcHCk23TKSXSCAVD/AWsesjisWoo1uFPU+2cccpflXFDNAX93fA6fVWr9UogZt+NQeIwJGs5e/M2ajpIdTjbMcVWi0be897SwBovzg07DrLSL91d1gSE5Lg9jCTIiLk03hpeX5p0NtHWpGMtE3Ndm4DHO+WW7/r7nGoq5DD6j3issDY/WGUMtXKeRM+qPnGnVg5w/ThhXfiBzg3dzM1/3fZOFoOKr0vNDKLbSWqaguanXKGF8rgG9TndPP6n2s3oPL/xICtGW0XT151yKyt7bR6XQFCuhjT/c9WfIybleK7ihMuEmWUky+BhIPAuPu+sQvGZ2MO29kKBJcuZI+61SvknRhn3nUkyTz10GZta8uZrSs340OPL8GIOqwSaK//Jq4K2vSxO0N7TxaZIGp7UX
 df2Ln4hL
 3M4Jm73VLAckYpj1BAdAXunB1mTT02uIWgCGbKIIIdl9oVbMmiUI83jMRt/JFwuASoyaqdnEAtz/mv9VRWiSvuPtXYBMm/WESZwMoz8uJtAXidwn7wNyAQ3MqyEXd6dqT9RRC4z1jVv7FO3WofmXVlgse3dCwOIJ6N3u0fHC2b81Z+aKWJiqc1PcSTZQ0YYAEzTmXXoFgERw8lBCBm+KQ0Zr9AOB9cLil4X6GXAqdnMnLuIPvZKsdWRMvHfJtCyr9NAGxVvv4bNpcsOB38OERpyvkUu7/uPxmcNUSfxLrdsuQl/F9uRtG0ynwZuAlubIhmSr/bVdNxWrnbpuJk4zIe7YDh5/knT9t7qWaiYNS+hkbanzgemT3nF9qqoUWePAiprDbzu2GTeabxUYPKDyUJ03eNq6EQdvEEF2sUnqgy3/pibqXcIcD/C8Do/JiZwTDDEsYlV3A2ic2s+kZPFY9GERCUQXZYdt9GsPbRK2mtXcGGweFwbzaafH2NkI1j/83baBlHYnE83IAnwOzyxm/5y7BNBLpunItEinC2/69DfEzNar3koUEgpgGb6UcDEpJyFFED9L6x2lxKev3WtYEdBeVi3gJm0qcE5KK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you all for your great comments and suggestions. Patch v7 has been 
tested by Yuan Liu and sent for your kind review. Looking forward to 
your comments. Thanks.


Regards,

Tianyou


On 12/19/2025 10:33 PM, Li, Tianyou wrote:
>
> On 12/19/2025 5:37 PM, Mike Rapoport wrote:
>> Hi,
>>
>> On Mon, Dec 15, 2025 at 09:04:37PM +0800, Tianyou Li wrote:
>>> From: Yuan Liu <yuan1.liu@intel.com>
>>>
>>> Function set_zone_contiguous used __pageblock_pfn_to_page to
>>> check the whole pageblock is in the same zone. One assumption is
>>> the memory section must online, otherwise the __pageblock_pfn_to_page
>>> will return NULL, then the set_zone_contiguous will be false.
>>> When move_pfn_range_to_zone invoked set_zone_contiguous, since the
>>> memory section did not online, the return value will always be false.
>>>
>>> To fix this issue, we removed the set_zone_contiguous from the
>>> move_pfn_range_to_zone, and place it after memory section onlined.
>>>
>>> Function remove_pfn_range_from_zone did not have this issue because
>>> memory section remains online at the time set_zone_contiguous invoked.
>> Since the fix is relevant even without the optimization patch, can we
>> please reorder the patches so that the fix will be the first in the 
>> series?
>> Than it can be applied to stable trees as well.
>
>
> Thanks for the comments. That's totally make sense. I will work on the 
> patch v7, will rebase with 6.19-rc1. I will be out of office next 
> week, probably slow response but will keep working on the patch with 
> Yuan Liu. Thanks.
>
>
> Regards,
>
> Tianyou
>
>
>>> Reviewed-by: Tianyou Li <tianyou.li@intel.com>
>>> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
>>> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>>> ---
>>>   mm/memory_hotplug.c | 18 ++++++++++++++----
>>>   1 file changed, 14 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>> index 12839032ad42..0220021f6a68 100644
>>> --- a/mm/memory_hotplug.c
>>> +++ b/mm/memory_hotplug.c
>>> @@ -810,8 +810,7 @@ void move_pfn_range_to_zone(struct zone *zone, 
>>> unsigned long start_pfn,
>>>   {
>>>       struct pglist_data *pgdat = zone->zone_pgdat;
>>>       int nid = pgdat->node_id;
>>> -    const enum zone_contig_state new_contiguous_state =
>>> -        zone_contig_state_after_growing(zone, start_pfn, nr_pages);
>>> +
>>>       clear_zone_contiguous(zone);
>>>         if (zone_is_empty(zone))
>>> @@ -841,8 +840,6 @@ void move_pfn_range_to_zone(struct zone *zone, 
>>> unsigned long start_pfn,
>>>       memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
>>>                MEMINIT_HOTPLUG, altmap, migratetype,
>>>                isolate_pageblock);
>>> -
>>> -    set_zone_contiguous(zone, new_contiguous_state);
>>>   }
>>>     struct auto_movable_stats {
>>> @@ -1151,6 +1148,7 @@ int mhp_init_memmap_on_memory(unsigned long 
>>> pfn, unsigned long nr_pages,
>>>   {
>>>       unsigned long end_pfn = pfn + nr_pages;
>>>       int ret, i;
>>> +    enum zone_contig_state new_contiguous_state = ZONE_CONTIG_NO;
>>>         ret = kasan_add_zero_shadow(__va(PFN_PHYS(pfn)), 
>>> PFN_PHYS(nr_pages));
>>>       if (ret)
>>> @@ -1165,6 +1163,14 @@ int mhp_init_memmap_on_memory(unsigned long 
>>> pfn, unsigned long nr_pages,
>>>       if (mhp_off_inaccessible)
>>>           page_init_poison(pfn_to_page(pfn), sizeof(struct page) * 
>>> nr_pages);
>>>   +    /*
>>> +     * If the allocated memmap pages are not in a full section, 
>>> keep the
>>> +     * contiguous state as ZONE_CONTIG_NO.
>>> +     */
>>> +    if (IS_ALIGNED(end_pfn, PAGES_PER_SECTION))
>>> +        new_contiguous_state = zone_contig_state_after_growing(zone,
>>> +                                pfn, nr_pages);
>>> +
>>>       move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, 
>>> MIGRATE_UNMOVABLE,
>>>                      false);
>>>   @@ -1183,6 +1189,7 @@ int mhp_init_memmap_on_memory(unsigned long 
>>> pfn, unsigned long nr_pages,
>>>       if (nr_pages >= PAGES_PER_SECTION)
>>>               online_mem_sections(pfn, ALIGN_DOWN(end_pfn, 
>>> PAGES_PER_SECTION));
>>>   +    set_zone_contiguous(zone, new_contiguous_state);
>>>       return ret;
>>>   }
>>>   @@ -1221,6 +1228,7 @@ int online_pages(unsigned long pfn, unsigned 
>>> long nr_pages,
>>>       };
>>>       const int nid = zone_to_nid(zone);
>>>       int need_zonelists_rebuild = 0;
>>> +    enum zone_contig_state new_contiguous_state = ZONE_CONTIG_NO;
>>>       unsigned long flags;
>>>       int ret;
>>>   @@ -1235,6 +1243,7 @@ int online_pages(unsigned long pfn, unsigned 
>>> long nr_pages,
>>>                !IS_ALIGNED(pfn + nr_pages, PAGES_PER_SECTION)))
>>>           return -EINVAL;
>>>   +    new_contiguous_state = zone_contig_state_after_growing(zone, 
>>> pfn, nr_pages);
>>>         /* associate pfn range with the zone */
>>>       move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, 
>>> MIGRATE_MOVABLE,
>>> @@ -1273,6 +1282,7 @@ int online_pages(unsigned long pfn, unsigned 
>>> long nr_pages,
>>>       }
>>>         online_pages_range(pfn, nr_pages);
>>> +    set_zone_contiguous(zone, new_contiguous_state);
>>>       adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
>>>         if (node_arg.nid >= 0)
>>> -- 
>>> 2.47.1
>>>

