Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 648A5606A329
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 06:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=XCVMXdMX
Received: by kanga.kvack.org (Postfix)
	id 8B4866B05B3; Sun, 15 Nov 2026 01:44:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865306B05B7; Sun, 15 Nov 2026 01:44:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705936B05BB; Sun, 15 Nov 2026 01:44:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44D156B05B3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 01:44:38 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CEA4E8016A
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:44:37 +0000 (UTC)
X-FDA: 85436414994.27.0F754B8
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	by imf05.hostedemail.com (Postfix) with ESMTP id 58F3F100003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:44:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=XCVMXdMX;
	spf=pass (imf05.hostedemail.com: domain of "prvs=77227ccd7=farbere@amazon.com" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=77227ccd7=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794725074;
	b=nmKCKkGEVqtGbmUlhLrnB0tl2pBguxHMkz9pjCytPwYL5cy0xUV8e4BUumfwGhtPYme+FL
	ogFfmCEHzvNfU13cjPtqx2W41jSlL9Q59/Nx6FAhKPcqhN3HyFBNugXLeZQN5CYKLbxnd7
	SiLOjmfghuqTiD8uhOHT/jrLmROpC3I=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=XCVMXdMX;
	spf=pass (imf05.hostedemail.com: domain of "prvs=77227ccd7=farbere@amazon.com" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=77227ccd7=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794725074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TqAmFZhw5TdBDOEreyI8Il3K0CkQfJ/0HmqdlBC9Qzo=;
	b=e6JWqanZw+gj9CgVgrkqQRzNHDMi82tPPvg4oSwWVxpNwY8DCvihp3gTK5n6GODuO9A8BY
	IHtitS4Vm5RxFaprcm6l0GQtU60z1HdYV+9fszvpbAkVRFLtxxAkSkF9sM16Y0xrwiNnKE
	9denqkJ4vITGcgordfgjekeMRLsAZ24=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794725074; x=1826261074;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TqAmFZhw5TdBDOEreyI8Il3K0CkQfJ/0HmqdlBC9Qzo=;
  b=XCVMXdMXvqWYKXFxGiEJ8jdUCXGr+1/XCRHxH3Baad/SSI9bAHYImqjo
   TWpHxWjD8U3OIdeSMugd3p75YBzv7Q57L4B3U2vYBrfdQH8cAWhyYubRu
   EAd/VzfHrw6TXAP1A9CnhtbyBpV5cGK0YWIUEkAxUqaGa4N2PKb8AQwJ+
   K/ISP7mXFhp04mFJ8M8b1pudQ+9ccKvAh7srGfQxNb5gn3h6irfzmhFpX
   SNFWcLRooc6yAh0GmTQynhM6C+S1IuVkUpi1BWay0l5AcmH8AQ+zvFnz9
   Ddkni0ptKWKc97VyFYUf0eVpmLCvFdyTT347H2Mj0XSArqdvsrzFE9uqP
   g==;
X-CSE-ConnectionGUID: uI0fMPR+S+2BmTBt8tSsjA==
X-CSE-MsgGUID: BrauEixEQ56cIuWL1EVgJw==
X-IronPort-AV: E=Sophos;i="6.27,214,1787011200"; 
   d="scan'208";a="33821826"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2026 06:44:30 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:11640]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.12.127:2525] with esmtp (Farcaster)
 id 0b5fb190-9e8f-438f-8391-fe6cb359243a; Sun, 15 Nov 2026 06:44:30 +0000 (UTC)
X-Farcaster-Flow-ID: 0b5fb190-9e8f-438f-8391-fe6cb359243a
Received: from EX19EXOUWA001.ant.amazon.com (10.250.64.209) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Sun, 15 Nov 2026 06:44:29 +0000
Received: from PH0PR07CU006.outbound.protection.outlook.com (10.250.64.238) by
 EX19EXOUWA001.ant.amazon.com (10.250.64.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56
 via Frontend Transport; Sun, 15 Nov 2026 06:44:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X7EBnjmawMUM6LYJqcBdkaczEfZXtDkIFX3LDopBsyKFirL4R+ImlXZl3fLVyzA6CL8cYoEITFkWaN6mQCqahRsjCMT15RN0dpVLEiyHE5b3wFR+2Y7F2MmSRWgs7TI8nucH6JSUuN0hx1gvS/EiVJisNJj+H6V7oHDzytdDmeu60QNAEkgOR8pkvUw0slG5efwjUDy2va3G8fmdpAO1gkmJGqNPueZwT3wmRcmvJ6QSQOFZllcXdlUC74skChmNJtpcmBZTF/FKHK2YFqHzaIQNX3Fex3Xd6t29NKHJj62yqw9CMDLNuQ5Gv4jD5YPzspfx/y7jdafC/CR5VtxavA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TqAmFZhw5TdBDOEreyI8Il3K0CkQfJ/0HmqdlBC9Qzo=;
 b=xFd0X5hw1C6CzxxMP9sg3IWCUqRht5VnnlGGBH3mgFuFFI3/dervYbJW1AAfhnHLc/Ie2j5jq3GatwsmwtUmVp8MxgUcQ2iAaeCC/eGH6wfoYinjrig5WxktWmcrVlaMP1zbe8qciMy4I7NnIrVMElt57jQ4+kdVerpCOAYqKkp1Zc4rHHboyeo4/qvFbcHxGTnHaJ4YaBbySU9NQFppLxPmsxazWzGikKnVYhf3VuSllHCbQu025RKJehKTytLc6Czy/LiiysqMctRVKIeuZHn1hwJZ5suKk7hWS5c0ERGyxzEpenysmT41sH7XVbpwIZHPocBnF/KPTZsnnUDNZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.com; dmarc=pass action=none header.from=amazon.com;
 dkim=pass header.d=amazon.com; arc=none
Received: from BY3PR18MB4722.namprd18.prod.outlook.com (2603:10b6:a03:3c9::19)
 by PH7PR18MB5060.namprd18.prod.outlook.com (2603:10b6:510:15f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Sun, 15 Nov
 2026 06:44:26 +0000
Received: from BY3PR18MB4722.namprd18.prod.outlook.com
 ([fe80::e307:5f61:2694:b219]) by BY3PR18MB4722.namprd18.prod.outlook.com
 ([fe80::e307:5f61:2694:b219%4]) with mapi id 15.21.0615.013; Sun, 15 Nov 2026
 06:44:26 +0000
From: "Farber, Eliav" <farbere@amazon.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/4] mm: add vmf_insert_pfn_order() and vmf_pfn_order_ok()
 helpers
Thread-Topic: [PATCH 2/4] mm: add vmf_insert_pfn_order() and
 vmf_pfn_order_ok() helpers
Thread-Index: AQHddMzBx6iciwaQbUGBLSRNq/OSkQ==
Date: Sun, 15 Nov 2026 06:44:26 +0000
Message-ID: <BY3PR18MB4722713137ADE7A59A1EB81BC67D2@BY3PR18MB4722.namprd18.prod.outlook.com>
References: <20261111113045.35368-1-farbere@amazon.com>
 <20261111113045.35368-3-farbere@amazon.com>
 <a242ede8-71c2-4f75-b5e5-dcfa98ab25d3@kernel.org>
 <BY3PR18MB47227EB15146F8F16E1C005BC6702@BY3PR18MB4722.namprd18.prod.outlook.com>
 <29bf5516-36bf-490e-ac35-d89893fa61b3@kernel.org>
In-Reply-To: <29bf5516-36bf-490e-ac35-d89893fa61b3@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4722:EE_|PH7PR18MB5060:EE_
x-ms-office365-filtering-correlation-id: 7759828f-5fe1-46e9-e1e9-08df42e3e418
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|38070700021|10067099003|4143699003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261022075727099003|261009223027099003|18002099003|22082099003;
x-microsoft-antispam-message-info: 2MPWOHW2c9VucJVZapa+F49WEDX3qvXt7eljZ/Ye/tvQBS88V/H5Eoi2p+bMCghacojthcaQlfw1hbPVyW1ZW6gIcCve/3rYJZqvZWPdFKnrcOj5H9yGcYuA6fgal2+XnH0YkCsKUupqrbwEZMrkEoaxVwoHp3XKFjP3h9W8F+5NpltrzgvMGeDXeIqm53jeQjB/6/zg9sch+O7LiCND+kSeNyMfk+ZjEwNf9+eOPAbeBPoAxjT9KDJPXXKLc1JsE6X4pQODLbwJLGFQJLRHsPABJEDbnO2MF6+8UYzHHC9hK5pLa6LEK9+Zc79dCnY2Jn/iWOqV8ZcD+WLOi3jCrUcBs3TLgO/PAUw0AGsvKH8zWg5UR/lm6MMYnJTEBupMydtGEIncJDa6qd1e3lPBM8nOLO1uAj4iQWHW1IX3wURvBs+vw5byI6DQOc4/InW9MFB1yh879rHaasE0gQLL4w02LPhMCMSbrKiyNfh9hSDR1+1jwACUht0xHgz25uRRv3av5FAsD90ZDUU1vH5dj2fNLRDIHtrBrMNEBYpLzHzN/YT+fSArK4/TjNosfynfUfaqBBgCVP929WgqPfC5aDdgUfuGfSXJh+Wwr3bvSv8UaSvf7W+z1ccVWSyjpBNvJ+8KYtRzqUP9DO7uMGHIza+Xw2W7wqltliaOBNs8oPL4mtNTSoEhfoQN+QX8TbNQsitYmEvVNscAm0Nx3Qw4I0hkBGe2tc2hoH+bOLC+XMg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4722.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(38070700021)(10067099003)(4143699003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261022075727099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MktoSm4xaWhkYkFkeENWL2Y3Vk40Z29Xc0I4RlZUVDUvMHJ1ZEMzeWdjcERl?=
 =?utf-8?B?OFFkUVZJR1BxWkhQQnVWeW1sZm12RzF3ZGMwUGtibTJrUStZMDNPZW5rOGd0?=
 =?utf-8?B?UFdoNTJwTGdkSldFR1p4bFR3ZFpGV0laNW1IelJjS0NCZ0hnaFRFZElPczV5?=
 =?utf-8?B?cDNkQW95ZDRkVUFsZy83N0FnQ0ttdlFOSnhsMFVZSjFQSjRTMnFjenUrMTRz?=
 =?utf-8?B?akc4NkVRTVczc2JMbTcvQlNIcEtjWW1CZGYvZGZzQTB6OXo2VXpzbW9ma3FV?=
 =?utf-8?B?SlEzandJbUVJemFDdmZ6UGdabitiM2NQSldONXl1cVNVSXlxUjhTbHcvMG5D?=
 =?utf-8?B?aUxJVFV2dDdVdThWYjRlNXZlbjB2bnoxaE8vZjBUQTdKUzJMVXR6SVlBVDR6?=
 =?utf-8?B?bGtyODVPNXRQblhYV1dmK3JDdGg5Tm9VdHdETTExdU1MYXJLVHI0YXRjMkhH?=
 =?utf-8?B?MkIxTDgwZjBFbjY0VGhadFZRYTc4N3JzaUJCZkhIRlRFZTdBOCt6OXdQbkdM?=
 =?utf-8?B?WFNJZExiRTlEclN4SzdtNlY5UkVMSCtVb1Bkc3JoaHRBV0RSby9abkVhbldw?=
 =?utf-8?B?VW14L2I4N0VPZGpRTG5pVEUzbVI3SkVFc2RCSjVjdm05UmxrTjVCWDlaaGFR?=
 =?utf-8?B?UGphK2ROWExsNlo2TTIyQ1pjM0Z5cDBYVlExK0xmdjVWVlhLOFZiTURmTHZy?=
 =?utf-8?B?VlR2Ym92emEvcEJYcVFOdmVMcE8yQlprbmVFNFJXdXlCcUxmem00M1BUU3BH?=
 =?utf-8?B?VkxYYWlleHNoTDlNOG1NVkdxZFc0YVJSTzNLZE41RjE3ZkYzbTFYTFN2cXFF?=
 =?utf-8?B?SXJpZTBCaU5XZzdLRGIrRWEwNGh2VWZLcHViVWYvWEhMdFlySnYyZkdFT2hz?=
 =?utf-8?B?V0czMUJqWGFqcTVKZE5lcFowOHQ1ZGo1bFF1Q0t0Y3g2S3EwYTl5c2s2WlFt?=
 =?utf-8?B?V0F1bjd5SXREMm1WdzI5R3lRUGJPclNYYnlieU9IRGxaM3A4QTdHMWt6TGdk?=
 =?utf-8?B?ZTFqVkhJMGFVMFU1MUQyTk5pTzJJWmpUMElGZ0J1c2hvTjJtQmpOUW1haDhV?=
 =?utf-8?B?L0U2OEZNMStSSWF2K2p1RkVPVzAyUG1pOHdabldSNFZaVUhzSGFlMkNZKzdw?=
 =?utf-8?B?Yk5MeisydUpXNWNJTEZXVGRCS1VDY2JJc0lFb1VQY0Exc2NrSEptbUNtYWhQ?=
 =?utf-8?B?VnJVZ3YrN0JJM1VyQXU2TXRwY1NTc1orMjY2Smc4KzU5aTVQYm1KaWJLdDBp?=
 =?utf-8?B?RGEycW5scy9nbEtxbzlaM0cwNUM2cFcxNldDR3RXTk9hdTY0R2tvT2Ezdmtw?=
 =?utf-8?B?VmE3VWU2V2hLZmpNeTZoQmFXYWV2MU51YWpvWTJGbjdMRGJUTkpud2RjNng0?=
 =?utf-8?B?ZTQvcTVwZFFnOXRlTGQ0VVZsUjZ6bHpuRkxLbmkySzRtaXdRVjhCYUIzYTEx?=
 =?utf-8?B?NllZYnYzV2RCaFQ0Qm5FYkdKR3ViNzhmNGdCUVpsd1ZTcWpJVGtmaU8wSDZ5?=
 =?utf-8?B?UlVvSFE5bHRBd2dPenhoRW1Cck4wTlN2dWhNOWZ6S2xCbk1zTUhOV1BCdTc0?=
 =?utf-8?B?NnJPTjhwa0gwVzI3NkVjVm9PTWcwVWg1MDZic1pnN0x5ejFNM2Q3cUx0WWVu?=
 =?utf-8?B?OG8wUHplcG40S2svK2RkSUxFQk1za09EZWc4ZTNsK2dYY2lSdDNBaDhFZ3Mv?=
 =?utf-8?B?NG5BWUs5VTVnTksrcWNvUkkwcWI5a3U1WWZlMkJWOXdhS0MwMjFsNlRZWXNB?=
 =?utf-8?B?dHI1UEdXa2F2QmZoOFVDY1ZnRzdyV0ZqdmpKN1VwZjcyeGFMSFhRME5jOGl1?=
 =?utf-8?B?OWt2UTlrV3l1QXhtekIwWG5BdzZqUS8wVWloNWFVMnh0RkhHakljcEJtUlFa?=
 =?utf-8?B?djBJTFVsalpJcDJ1cWFpWTJDQzBkckFPWTRJNDhZUkY1TUlDN2dyeXVqdU1T?=
 =?utf-8?B?eU51WW02QWJHMjZKRkdOc0cyVnlrS2ZXeExTdVF1RHhsbTNpNFpHWVhySkFv?=
 =?utf-8?B?N0JJV3FsTGgzTmpvTW1CZDRWOTJLeE03NWI1Ym56OHdXOW94N2VnRlQ3NGNo?=
 =?utf-8?B?OVptUFNkcTZQOC83S3JHNVNVSkZweVg1czNkTDFFcWN4MmxhUDZlNzl2UnF1?=
 =?utf-8?B?bGQ0a1drYW8vL2ljRGtaWC93NERDUkNYMmUvWFJDSW56bnhaS0YxM1ZObXNk?=
 =?utf-8?B?WWdyaVJ0cFlPWm42cGZqMmlTSEh0THIzUjdtQ3pacWJPZUY1MzFZR3NVRkxz?=
 =?utf-8?B?SFZYZk1iN3NUd2pzcGJ1dkJxV1NKamNJbU84M2xHZUZXVEZEVWdwK1NoaW9C?=
 =?utf-8?Q?GpHFWSRdEiem/T1fuP?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Ty8RI9d1s41prJt9NS5np80zqlteNbdCI+Fp46L0l29h48EAkvTgXzdWKQG5782IgInclXQIk7562UuvpcHV41fWFfuxd/UTGnWzW+eNG/71fui1Elkl6o7BbXbADMZ+wJizUUk0lCLZiIMgMdFgqw1D/C2lx+umrTQLR+OENK/+ELlrBqEpbt/TMMkoi0QZfyEgH7vlz/PYlPwdNzhGKXZFxzwj9Mf58rSY+FfVrB0vDKpyAMe309KAWgzGFz+AgXhp1sm6H8PJJ9hCySOR1dLYtLV27l5BA5ljNBuB9MHDdpqUctmeK9EdIb3780VaU7Rqa9GTjVgR2x5o0XdlmA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4722.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7759828f-5fe1-46e9-e1e9-08df42e3e418
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2026 06:44:26.1200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PuRPurz5mbtQzISlK1JOQQoGild3hqEEZoz7aIXX4LdIbFoMEukDeviS/PQeFC6cX3oMr12Ln4/QcEexjF0tjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR18MB5060
X-OriginatorOrg: amazon.com
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 58F3F100003
X-Stat-Signature: dcib59n6m9xcppn3fexrnwj8ibb9ptfy
X-Rspam-User: 
X-HE-Tag: 1794725074-397591
X-HE-Meta: U2FsdGVkX19T+0HXAM4559lH6q6xydf/yuc9F4e+c8ER7bx3dfjcuHAjsAcsYTNZC5ZV/CA/UzI1mJE9qE86OCvO7b6in8d5rCIYJkvzetea8X2hSEVzqX+HSAicGhsU172tkMAs+aA8des9tg4fQKFYzcRZVKZyhmNz2npKyv5+sWklhGfN3lzRz+LAiBAE9ADxxtKblfxWJ3PvoCCLiLHSAzyrLh5d/8JnBge+oUGOzdoNh9ZHitvxhKKoAiXl4lJl+HUQk7zrP+cd02kYgQA6DM9Ey4nyR6vkyLNmUUGumYklLI8exBnsIFYG2aTH4fRihb4gi3WeJOlZrpSYKf2oMBAedO8z5sLIOONQ0sRsVOMMAudmhd5RkQNUwCQI8UjVQpz+hhIK8oEVIwGvxHZRSN7bR9lcrJNlKvQOd50nLM0eNqq3JrHN3yJmapwACXfdnMWWLN+/aQNMpx64F0BYwBJ7N9o1sh1OtqwdkUpiF4Trr+Dmlh1ozwd/iW9W4O5zn3YDwToTbjTbq39cUhIKOWDkGsJ3pUwJcwr/P03+NcdBqxdG4ikuJRK5OvFoFhhtap0+uDSni2DQAzPJFmEk4KmfYyj1IcEHXOiv13EeW4IdcD8Q4njve9Hw2JGIdpAPz12VdV+OPnjYHPrrpl9S4V+8QNgFLyCxCa6Ydu48dQKM7imR/Vyvo3FOMcTuI0Kt8ejQCPOXBj5Z+bN+OWhD1182Lg+EyTh2bfIUAqeIR5jIutVHxd9ANWoBEnmyW1Q44lAibisTekYP0v7L3LOwRAL52ONWIORfO4tAt7WRmwQafGenhdFLbSkcnQ3aYppvlKcr1kHRKcsuPokiPsTMldo7QXFNGHcmZphaX5ZhTySa5f/2+2ufRbj7A0Bidn16mb8D0+n2avrHxWVG3p/EPK7qAmGH4+RfxOb/o3HBfMpyPvOVuVuaM/Nm+vM66aHQ4zQeXkJyUMlzb52
 BDuUmwWL
 vhV3ytmqOYiw4Gt7RwhOpgzy1GZobfurOOsLAdrXp2sGZj/4yh+3xJlp3MXeMLmqvPdiWamocFgZkLaFix/tWWFx5DVEtWZfv0x+hjHh1AGuaD8+MPYweGL/GsgD1UL35Ej5C7K2VrKh9ol/ET9s+Bs1b/C+lJPc9eyYYd3cQdAgJ51oSFAZKdkcMJjrhHTEcUwqHwjFMXHUm2EAqGxu5vkCYNAQAMMyQJuOH88A3hLTbmhegU7B1EbHsAVQ3VSeoRN4fdqG2Hq1bKve63n/cq0pBi7POUJwgXo0Iob1RG7ZadENrsNM5s8vv3GDJ1Tf04U5Jc7FXIfkD/zIIkaIIAASrme2XgxMgjHy0LdNiZGquV5fH5p34QgA3aSXi7KKp07hJB57YET9QkTikGhfXhrb/bDqbG1SeFNiUurp8lOfskN6pni10cpUL60oKWE3aqz2tMj2luU7HA5R4eabF+htD5XoN6k7tK4oasgVx3HPFo+ro9udzOqRRBynnS7K07hn/5Ej/oQtVEITRfCAFFNMbbVKhYVQcJr8SFvBzWfdZB9kbd+Cuk3a0X39WHzXDL3BW3Scr0M9gw3Oo4rY1SyXXOdVwTqmdLNlrtle0KWlCWSgoMtlSoGRKEh+8+dJqoiT12A6Oci7FjAzJ6YN7UwEyWRJml0CF8yyEicldpvd9ov+2kgp1YD4gVrfxSo4HJD+bTDVU1GYUTDODahzu89n3ptynY/Se1jN4hc5FrN1zPzu8JaBWAXooPTDNeXWAPv873sGr7NOGGQJFX/nd0LM0NqngDFdQhuICmAcNh96d2TEcmfV8XdxsV4iq/5JWR1fVBVWiNXPLBbCVW8+229xnaRPRG3OQ/E6+UsKsVl6EIGWEYNVQ8p9/9BzsfEk7cCTU7gpko+d5UQzHPGlpWyEaG+LQ1SRpC+zZxmICaGuagl6MqtmNhv7RM200JMA7X+0y9KkE24bYENrzJ4t17SMl5aP1
 DBWkNWih
 zFK4izUkDgJ/ZakSH/ybTjweJxSgS6P7Vmmi1TnhJ4BOm0RuM0ylTA5KEW9p1/w6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gMTEvMTMvMjYgMTE6MzksIERhdmlkIEhpbGRlbmJyYW5kIChBcm0pIHdyb3RlOg0KPiBPbiAx
MS8xMi8yNiAxNjo1NSwgRmFyYmVyLCBFbGlhdiB3cm90ZToNCj4+IFdlIGNyb3NzZWQgaW4gZmxp
Z2h0OiB2MiB3ZW50IG91dCBhYm91dCBzaXggbWludXRlcyBiZWZvcmUgeW91ciBtYWlsLCBzbw0K
Pj4geW91IHdlcmUgcmVhZGluZyB2MS4gSSBwb3N0ZWQgaXQgdG8gYWRkcmVzcyBzYXNoaWtvLWJv
dCdzIHJldmlldyBvZiB2MSwNCj4NCj4gRmlyc3QsIHdhaXQgZm9yIGh1bWFuIHJldmlldy4gQWx3
YXlzLg0KPg0KPiBTZWNvbmQsIHJlYWQgRG9jdW1lbnRhdGlvbi9wcm9jZXNzL3N1Ym1pdHRpbmct
cGF0Y2hlcy5yc3QNCj4NCj4gIldhaXQgZm9yIGEgbWluaW11bSBvZiBvbmUgd2VlayBiZWZvcmUg
cmVzdWJtaXR0aW5nIG9yIHBpbmdpbmcgcmV2aWV3ZXJzDQo+IC0gcG9zc2libHkgbG9uZ2VyIGR1
cmluZyBidXN5IHRpbWVzIGxpa2UgbWVyZ2Ugd2luZG93cy4iDQo+DQo+IEJlY2F1c2Ugd2UgaGF2
ZSBtdWNoIG90aGVyIHByaW9yaXRpZXMgcmlnaHQgbm93IDopDQoNClVuZGVyc3Rvb2QsIHNvcnJ5
IGFib3V0IHRoYXQuIEkgd29uJ3QgcG9zdCBhIG5ldyB2ZXJzaW9uIGJlZm9yZSBJIGdldA0KaHVt
YW4gcmV2aWV3LCBhbmQgbm90IGJlZm9yZSBhIHdlZWsgaGFzIHBhc3NlZC4NCg0KPiBCZWZvcmUg
SSByZXBseSB0byBhbnl0aGluZyBpbiBoZXJlOiBkaWQgYW4gTExNIGNvbXBvc2UgbW9zdCBvZiB0
aGVzZSB3YWxscyBvZg0KPiB0ZXh0PyA6KQ0KDQpZZXMsIHBhcnRseS4gSSB1c2VkIGFuIExMTSB3
aGlsZSB3b3JraW5nIG9uIHRoaXMgc2VyaWVzLCB0byBoZWxwIHdpdGgNCnRoZSBjb2RlIGFuZCB0
byBmaW5kIGJ1Z3MsIG1vc3RseSBmb3IgdGVzdGluZy4gSSBhbHNvIHVzZWQgaXQgdG8gd3JpdGUN
CnRoZSB0ZXh0LCBhbmQgdGhhdCBpcyB3aHkgbXkgcmVwbGllcyBjYW1lIG91dCBzbyBsb25nLiBJ
IHNob3VsZCBoYXZlDQprZXB0IHRoZW0gc2hvcnQsIHNvcnJ5Lg0KDQpUaGFua3MsDQpFbGlhdg0K

