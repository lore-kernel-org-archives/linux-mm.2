Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5F49F5A8A2
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 00:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05AE46B0088; Mon, 20 Apr 2026 20:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00B3D6B0089; Mon, 20 Apr 2026 20:00:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15566B008A; Mon, 20 Apr 2026 20:00:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF5766B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 20:00:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63866BCB66
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 00:00:45 +0000 (UTC)
X-FDA: 84680606850.22.D6BE6BA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf18.hostedemail.com (Postfix) with ESMTP id EE0341C000E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 00:00:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A37kCuk3;
	spf=pass (imf18.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776729641; a=rsa-sha256;
	cv=fail;
	b=PXLr7Cq6O1tzVInEWZ7uWoyIfPnfsWEvKhMa8fnZOglmz7BI6SW5UQOlkBGLDF5gkVzvGa
	jKltaW0ZclxbWFhwfPMoK2NH8NGpTqFwRwfMu3d6g8S0vEXEPx7TupLurXmCeonI6Wd5R5
	wWj8uXTDNAKlJlp1i5hgDNpUDFMOdUs=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A37kCuk3;
	spf=pass (imf18.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776729641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dSIA0jus3U3jsvkKZGhxW6X/yu0dWsYsYKMLpN6gFNg=;
	b=6pQ39Ek4tYSXBpALLK66P9OUbAMrn4t6vxudFp2ESptj19FkZ09RvOq+kA+5Jugzq3yIKX
	hMo2sfvQ2f4IfJ/FdvXeO5lpxS3bf/EF0u5EWtFY6KFDcBCXETFl4wvFPazZ6/WAdDyiP5
	r6n5IqiREYkCwx9ElGAdUIAGn0XkmXI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776729641; x=1808265641;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dSIA0jus3U3jsvkKZGhxW6X/yu0dWsYsYKMLpN6gFNg=;
  b=A37kCuk3rXiQdRwuipAzPuuzMBav4AeEzzCV+hSvq+7WGsKGHnxb7SZ7
   nGgk/wWaojY4FF54MCrbPoxr7SzUFAhGo0pJSkyyQziBthprTmkaSS9OZ
   zp7SWj1rYfxA4KXYztte5JMQ7dmLtnI6tX80+VnxEXJHFvma7ITWHX89z
   woF4LQHl2wPoN96+m5L0xjfRlS0VV2NxWrb0GpF4B2iWmhM7EWzdC/kir
   0N2PRr+DOOyuqMkF3JXFMj1LcBY5LS6Kexe1y6GnV7hx2n29Q5rxWzd2u
   UK7jQg5qG8Lov/vk2bDSrUhspQVjd4yUbCcK5QB+9v6EwJrCOy6ukoqx5
   Q==;
X-CSE-ConnectionGUID: Jx9dCdIHRC+BFK89o2gdRA==
X-CSE-MsgGUID: ntpb82+CTr6ExYOoDoL1Cw==
X-IronPort-AV: E=McAfee;i="6800,10657,11762"; a="77727338"
X-IronPort-AV: E=Sophos;i="6.23,190,1770624000"; 
   d="scan'208";a="77727338"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2026 17:00:40 -0700
X-CSE-ConnectionGUID: m8ho0OIySaapRjjxHlT0gA==
X-CSE-MsgGUID: ljULkOotQ1KeVFaEUqkwpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,190,1770624000"; 
   d="scan'208";a="230822299"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2026 17:00:40 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 20 Apr 2026 17:00:38 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 20 Apr 2026 17:00:38 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.66) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 20 Apr 2026 17:00:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PnbbKEGaoQDqkB3YOdvaMvidawJdxdhswiKEOlNEHak0EQQ91lDPASyvv/m4J4A9KVoSF2BcyERG4L/sNPpXEvB/2DN1IBpTG36y1OSev8HP6CymeoSw32y7nGZDXse6B5X6kank5G4I7+HMW75jC6eW4GA/CBb5SJT5o+ZTMD4kryFTYbaoiZk5tqR7fFQx0w4XGCGpwCoH2MhPVFKR44w7ywWr/4WzE4eSLx699qfBJB5o+e4879cEdxWaLxFgp+EV5zxQd8ErWyhz3DK6wJX/xstVg0bMjhS2BdSS+BVm5oBBKRokoTcbfrMr4lSrYhXLE7vsHAASrDrr2AhGvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dSIA0jus3U3jsvkKZGhxW6X/yu0dWsYsYKMLpN6gFNg=;
 b=GLn/8lGscn7jQGBbqgMpKq2XLMrfTf8DY7qx3lq0AhnPI2IeIxM35P1rIFLj1qGC0cjKhxfw4suAElKjTwQTLb0E6oLUytKsgnFOfvTkgZ0ibBVC0wgfhEuQ6Ey/1xO+o6gMktxV9ICv9EJmb10MplDCYnauWagYPFIpBKzBkwUr/pn08VIeOWSTpKAc83sIQwMpIxJl/0b62rhM4Flq3hQExQWNYRaaAV0FfjnFGrdN7doha3wybn/+UwT+geNrxo2J8iSSqNR4wmOnJcmFacAjuSRdWoTxqg4elUn+MhW54q/ZDDbWOO1cUsyfpT+lkdHUTiCS6za6c5JUzbibGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by IA1PR11MB8151.namprd11.prod.outlook.com (2603:10b6:208:44d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Tue, 21 Apr
 2026 00:00:31 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%6]) with mapi id 15.20.9846.014; Tue, 21 Apr 2026
 00:00:30 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: Mike Rapoport <rppt@kernel.org>
CC: "David Hildenbrand (Arm)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
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
Thread-Index: AQHcxwYPPar5wabLkEWQfiO/Xde9s7XUxrUAgAIIwYCAAAfiAIAHUdTQgAAptoCABIITAIAFOesAgACkxKA=
Date: Tue, 21 Apr 2026 00:00:30 +0000
Message-ID: <MW4PR11MB6936401B1D63AB60DB12091CA32C2@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260408031615.1831922-1-yuan1.liu@intel.com>
 <17b821b6-0176-43d5-92f7-fe2a0c4f70cf@kernel.org>
 <ade6RVeXxDt7ImP4@kernel.org>
 <e86fee84-08d8-4563-8596-e40d8e196799@kernel.org>
 <MW4PR11MB6936CA77BF02BF498BBEAB1CA3252@MW4PR11MB6936.namprd11.prod.outlook.com>
 <12b8ba83-54b1-454e-b787-2d2e967c9b58@kernel.org>
 <MW4PR11MB6936E593C865F4E855CED602A3202@MW4PR11MB6936.namprd11.prod.outlook.com>
 <aeYyMFKvR8MZO6Tq@kernel.org>
In-Reply-To: <aeYyMFKvR8MZO6Tq@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|IA1PR11MB8151:EE_
x-ms-office365-filtering-correlation-id: 880ae7b3-c83f-4e67-f5bd-08de9f39008f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|38070700021|22082099003|56012099003;
x-microsoft-antispam-message-info: wxzA6yR5Ea86BeIy10NEtiXl3uK9Jt4EzAesN9JEGLXwl+/vHpVOmv68K/eke1JuW54xTv8y8rFVQGVS5nf4tisd0rSWbhIAiqr8Zq0bMDYHJJK2hw/BIFZKg+PstXSAdmwznsNCKN1zafqXJCcbYZWr04Vr+yuUsh2aUBoItptZ0juCXkeNcp+G7Q5fxV0NPDhE0MSNIrivBYbyHN0cP4igbr+caugr3qQAGnI0un3zQzAtjcmHA8cNUuT5KBS9xu3NJC1e6WmUAJgjEc7/Jz9JjKpzncxuP+UYjldCpQfY7W+QimYCfu4Kvmtg0HFK7XSWKv7hMDVIGlRKCTqotmcbHpH54vQ0qvjgHGVQYTd5nkPGrHv5Cl/AIDliD5oIjuiC1KAO+gPE1NS4OcRyXWaqfkaJiG9Op+1DqNmFxLCRdE85QiRSDCxXR/NdfXhqgEp70jMPq/SSOzM7hm6n/U8HFy7wvdcvwN29oesKcDSRcntmbop2MGXdiMvC6YiwoPI2SzzdVfH7WVwDlAbqFDtgTvwtPHO5uafz5PjaQyC8ipfKjrsne0oMusoODJqWKzug5dAFCuoRgQq+H56PWPjac0vYj8yHcn4oj4WPjmRWp5ZvIyBPcLLjRexHSHTX21KyiI5LPgnpiCWHYRDouVCrFdn/GvXbFEfwK4lLz1/H2yBMU29dLTQROsJVyH5zrRff1iucPmWPC3hWGJC3PfOAkwA82a1bxz6F6ZtTBGw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(38070700021)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RE9jZ2JTVnFzNmZxaUUwOHl4WG9kMmpKNHZtdCtmQVpIanhJUVdqbWliZW9D?=
 =?utf-8?B?QUhIblVDYVR5UDZOeHdhWG13UU5aM2dvcU9OcmcwR04vS3E0ckt6UGZ5enZD?=
 =?utf-8?B?RDVTelRFdGlDWTVJcDZ4VDdUMGk4bGViTEJ2NXY1TGg0VXN5UThhQThpa3Ni?=
 =?utf-8?B?QnVFMEpDa3R5YjZFdEVEWitGY1BtTVNXV012R2I3R1hyNUR5Q0ppZWp1ZG1H?=
 =?utf-8?B?M2RxbkN0Y0Nwd3hjM3B2ZkM5Z3N2NTJRcHlIeEVjU2xuY0JjVVMvUHM3NTNo?=
 =?utf-8?B?dDB0a3M1cHBVQ2Y2WjFRZC8rL29obVh0bVJpamswVS9RazRaUUVqUGZLQk9i?=
 =?utf-8?B?dUplK2tVelYxalBNMEZJd1ljSHBqeFdyM1pKdHYyS2FvbksxRkJ4NXdPQ1Za?=
 =?utf-8?B?WHJZczNKMUhxaWduQlVyeXo0ZnY3ZG1Oamt2YVloelcraGFYYUhwZ0ZNSlpW?=
 =?utf-8?B?d2xwR3RiczUyWGQvdFhkaWxteWRrL1hrWFRnRTl0bWt0Y2lJQmNtcmFnSkFr?=
 =?utf-8?B?a2M5UFh2K0RoRTBFYkJtNFNVS01iVlN2VmpFZ3pPMktlSUVZcEt1VFY5a2Fy?=
 =?utf-8?B?ZzNDMHZRU0RwQWkvUXk2ZXhFdUhGNmZ1VWNlKy9oRi8zdmxCS3h1TlFTMWwy?=
 =?utf-8?B?MnRscjU0SHY2Mk42R3FuQWVwMm5WaGJTeE9QMkpEWUk2TTlpQURPMzliSmlk?=
 =?utf-8?B?UkV1K2l5aGVKWFlnWFgybTNTQ1RmV3JrUWJmRVJDY2FZWTlvU2piODYxOWRB?=
 =?utf-8?B?c0N3cVZtK2VzbVVZdkppZTZ2cmF2WUcrRHV2bkI1UTZmSm1XanFhcXdWZ0lO?=
 =?utf-8?B?NUxaREZ0ZzVDQTN0QW0rcmNRK0ZQUTlUNTRWUEZwcS9pTEFkeTNkd0h6OUp1?=
 =?utf-8?B?KzJBVlh2cFpYT1hsakl3NFRnVlcxWm56Z3JxTmFUb09qc3pqb1dlWDZOaWNP?=
 =?utf-8?B?QXorQm5lOXMxK1NtZ1FlQzVrb1RQalhiTGlmWjVPWTZsS0ZyUlRWQzBmdUZJ?=
 =?utf-8?B?eEttNGZNd1E4WFlrODExRFVpTHBhTXlncEx2a2RpQlVudGdPWGJoajQ2QzBz?=
 =?utf-8?B?cElmUUVLSk9rclpjdk5FOXFXMzQ1R0xPMzBzSXBtblExazlRU2JDalN6Kzgz?=
 =?utf-8?B?ZWVOaklYWjhKTktSZXNsaEF6dElNQlNwVVJmU1FiSTIvNFhLSXRYdldybUNZ?=
 =?utf-8?B?MjlQaURBVUU0RnQzV0wrbUVteWNkY29ERU5yMGE3WkZsUlJIZWhveG5pc2tl?=
 =?utf-8?B?NlhSTzdmRExzWEVkdGxmejdIYS8xdmJ5NFpsUCs1c0ttWmpOenBQdm9aYkR3?=
 =?utf-8?B?RTZMWmgxWFJmWVdPK1doTnQvbmVkOEJCQnFJSkZpWVA0cm4rdXpCUU1ScGNw?=
 =?utf-8?B?dHFUMkZ2K3hxRnpRYitwclZHcjVPMUxTRkFxY0pCYmhaYlVtSjZhY1Y1MG1h?=
 =?utf-8?B?MjVwZzY2b2haOGdEdyt3bGE2NkZFcmpjMStPVFZVRm81QmhBek1jR2RXS25N?=
 =?utf-8?B?elRrcW51OU4wZDhWcUpoeGQwdGVOUkRUampIR1JRZExUdE90TG5Xa1p5bjVu?=
 =?utf-8?B?REs0Wkdoai9QOWpmeVZQZmdBem1VQWg5Mk5vOGo5Qk9CalNrL0FnYkt3VFFs?=
 =?utf-8?B?clhMbDI0b1hsb1l2M1hkSGtheUYzdGVFQWlBMElRQlhrS3g4T0hEN2x5WXcr?=
 =?utf-8?B?SU5ldURUNGNRTUx2TllMZ0FaQ21RNEF6TTdrL2x1YW5EUUprSk1SdUFpQVZS?=
 =?utf-8?B?UGxvZkVscXUveTdJNmdRUHU0SUUrUysxdlEyK0NHWUFaYjJkZ1M1ckFmTlNW?=
 =?utf-8?B?ZEorajZ5WWY1anVLWFR4SXpDeG5JNmtKdjVJNG9RV0w0WWdzeVFMSW9ScUlY?=
 =?utf-8?B?SnlLaXRJRERNYzdLcmZ1TUkxWjQ2Yzh3NXZzYytKM3FiUklub3A3Vi84cDF2?=
 =?utf-8?B?a2RpaFpUaDIrdFF3MXFMek9jTi9PRU9hNHpWdWU3MHk5eUwyTEhNOHgzMUN4?=
 =?utf-8?B?S2ZtQzM3VmM3aDBsdXdsSVhmbSsvT2tNMjdRcWY1K1ZKNDdnQWdBc0l5enVh?=
 =?utf-8?B?VjNrTW9LMEdxZVJBWmhTSzE5UWt2TUR6TEtpT053Q1pQNnZLYlFpcW42ejln?=
 =?utf-8?B?WVVYWHROU3g3d3NwaEtvRTFGdzFkYWRQZXRJS0J6NGRQUUVGc0pJU2pJdEhZ?=
 =?utf-8?B?Zkk2L2p2SHRMYnBxdVUraU5UZHNTNGhZV0Z4ZkphMVBySUFHZ211dHU3RWVu?=
 =?utf-8?B?cEpkcXRBdzdiTmczVkJJNlZCSzZxMzFJWUU3V05rWHR0aXRnZjArZlN4V2R0?=
 =?utf-8?Q?Y+Khm3KYS5EENNPyRl?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: HtooldwXI6MSgOSzUYowVkhIdYLgRELanY2oorwJ5zx0PMyQUzLyx+DCQyq3aO8EGxqpzSQWNpdN5Lscc93xwz3jarJqxKg8t+GvyViSgTA7GEiYl4+uK4ttIMWRb2GZK00NPQKsiKq8b90zwDTL89t7bUSh88KVXDI3oVzet4N/ia44XnADHxt1ej3YJ/DzBuE0FOb1uFXEsPJ9oRBxC82W7x6CALE7iEbl88SLGmD3VUksItjYrS00lsdFPghYHKC6YeNE5GOu/BwyJfwjaYn59QcisUJTrx8eEZEs3ocoYQ9jJSXPHn7n958fBIngASVpE/nv8UgE7ZhBScDjiw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 880ae7b3-c83f-4e67-f5bd-08de9f39008f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2026 00:00:30.4178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CeoZoX6yBe0IVBkp10JT8OGeQguV27P4mttl93N0XFl881h26HJml45hAyB0anSxvqmqXgmGQWF9J2AHXHy3ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8151
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: EE0341C000E
X-Stat-Signature: 8xz567rxgu84dqyijebw1t6db65kk3se
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776729640-496136
X-HE-Meta: U2FsdGVkX18FwfUPyGB7UufZTPYKNWezMzIDfnan8JaOMrvLkhxeQ/ngYcCn7YsYEoggejnwTOUeaDO3cF3SbiTT53oC4A+HNGmBPmZVh92I4bkiLmMjK0/J31iL49ewgthF7L4utRPckChvVk9nLZpaMZds4jvwG+ECriYA762mk8L0rwp+N03MDUy45/Bg5CSZg79vKKZMM5idilWpRLzuLHOnmCkDC80qoTJDzuhpgrDDXJFgjTEUwpGnNHcZC79BY5Uyt58sTfrJHYXXoZHPHagdNqa4gqyHKptSr1ClqD1TxMc5lFdswtq56DkVzHaDAtI37f9Wko4+tpHCezrzF1JcXTxVfKT7JfhHUvnjzVaY095+aAW/sJLUNfmp7RJ5KMuyM6+ScD/8+aO8Z4VHJOM8Iqx21nb8r3w4Nk7UD5FeV7cZgzkFnIRvHipgnwpUL/R3hrzTJfhVnIPbJXpFFqOzbOSBChzAdDnyT9yriSEqNWo3RLDFS0j/V3iukKTeExIWD2Zzs3vA3GGDGROpfyvOYSqcbn1kUUxx2pTmu9rHhhJdjX4/caBheY4HHN5n54UkZIR9xWo1bg3FpoOUjt7lczBlGslW+yU7c77bCIUw/mNwAxt52veObVy18UzKOoPYvOzUYwY47W04lk+EjguX8vGGQdSMUD/9X7aCuGx9uxT8M7+n46E6WGDOgEVIM70H+9XwaI5xJANLGzHn2TkpT5oTKHabQTZ055ViQk9XErgaHvHIKw8p9T0ElyQtM+OqHwUPOkIV4DND6sj4OmvM0zFhhxjmXNakl4qzKuKfLnewH7umE5Qo5FYjpdM3x6FROy9SSHDSyjrlNKBhlV2L0Mky7SZfJKraiOsgKeWeQjxRZJkpkicL7FnziA/9s8lA3YCUan8cbL8Eqp+eZgeFkFTR1azdUDHYl+xAJmFg6tujhDtoReS1OzSSIw8kag/dAIww6QO/OTc
 XKdbBaM3
 Lq67dg1EcDQF+xdmY5CVjc1PSZ/uKOR520tqaxLPBk2nTBhWvrwiyklcegNfkcTS/zFvtMgrk4/rGtL8Lvez1eD4yhyC97hnkTk6vNX7SqcWroI4ofGGixEWwxqBRhibZ7gzFZVtMakHahWdHoKKPrcTVCVepr8kCYf9roswOXDcoT8s7FoobIe8kXoO27NUJTy9eKNkMNU+u5VHkRgkH8RdWWTgi1jxno33Fpj8eAOus2gTydiM5fkgeLiXF7+yUVVXJEb8PO4wTZVt0G6EQtrBu4rcgNb5GkF31tPaHupPuPOUxPeYmuVhYikJg04QpnzQc2mMZnigi9ft2DWi/ySgVHESVBjFyv0PT3S6kZ2DYtS8kNirmVOZ3HOwGp+dStNCyzFMiAC6OTwgFXemqrOhW+tB2iyHC69w+y9oo/RRSMJ0s74ufbEqdjvhPI9rq4W0eYUz0oc10L5DA763uL6xDmP9eTVtQj1j2NMjr34jhfcfcvKaQTmwzcrSJD6Hc25YHFi6/RXMtyquAExmhvkubyHUhJhMBDmYCzQDGixPUSzveB2R+V9xhaywPAWscm4s/KI3oNIzAywcGEJIqFZcUfr+WGYLmgPyB/KJOd0gRQveAMhdKhLOdnmYaTP/m/bsNSdL+lD9JY3t0LvvZlvALDsd728zhWLTuC/rALRpIukMvWuOQYWZpMx/WQWS/lKTLsiFR8xK+HZad3W2Yf5Xnx8OeiG3nr21R561xg9X9GqYMZNXzFrve3i2ngoJMi8knACBpdyExjyzUX1T6jHNd5GQbyxMTK+Q+/7tsOOg+ROOW3XOUTmfAQjp61piMynbXzjGR5Kcwuhw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNaWtlIFJhcG9wb3J0IDxycHB0
QGtlcm5lbC5vcmc+DQo+IFNlbnQ6IE1vbmRheSwgQXByaWwgMjAsIDIwMjYgMTA6MDMgUE0NCj4g
VG86IExpdSwgWXVhbjEgPHl1YW4xLmxpdUBpbnRlbC5jb20+DQo+IENjOiBEYXZpZCBIaWxkZW5i
cmFuZCAoQXJtKSA8ZGF2aWRAa2VybmVsLm9yZz47IE9zY2FyIFNhbHZhZG9yDQo+IDxvc2FsdmFk
b3JAc3VzZS5kZT47IFdlaSBZYW5nIDxyaWNoYXJkLndlaXlhbmdAZ21haWwuY29tPjsgbGludXgt
DQo+IG1tQGt2YWNrLm9yZzsgSHUsIFlvbmcgPHlvbmcuaHVAaW50ZWwuY29tPjsgWm91LCBOYW5o
YWkNCj4gPG5hbmhhaS56b3VAaW50ZWwuY29tPjsgVGltIENoZW4gPHRpbS5jLmNoZW5AbGludXgu
aW50ZWwuY29tPjsgWmh1bywgUWl1eHUNCj4gPHFpdXh1LnpodW9AaW50ZWwuY29tPjsgQ2hlbiwg
WXUgQyA8eXUuYy5jaGVuQGludGVsLmNvbT47IERlbmcsIFBhbg0KPiA8cGFuLmRlbmdAaW50ZWwu
Y29tPjsgTGksIFRpYW55b3UgPHRpYW55b3UubGlAaW50ZWwuY29tPjsgQ2hlbiBaaGFuZw0KPiA8
emhhbmdjaGVuLmtpZGRAamQuY29tPjsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBT
dWJqZWN0OiBSZTogW1BBVENIIHYzXSBtbS9tZW1vcnkgaG90cGx1Zy91bnBsdWc6IE9wdGltaXpl
IHpvbmUgY29udGlndW91cw0KPiBjaGVjayB3aGVuIGNoYW5naW5nIHBmbiByYW5nZQ0KPiANCj4g
T24gRnJpLCBBcHIgMTcsIDIwMjYgYXQgMDY6MzQ6NTBBTSArMDAwMCwgTGl1LCBZdWFuMSB3cm90
ZToNCj4gPg0KPiA+ID4gPj4+IHNhc2hpa28gaGFkIHNldmVyYWwgY29tbWVudHMNCj4gPiA+ID4+
PiBodHRwczovL3Nhc2hpa28uZGV2LyMvcGF0Y2hzZXQvMjAyNjA0MDgwMzE2MTUuMTgzMTkyMi0x
LQ0KPiA+ID4gPj4geXVhbjEubGl1JTQwaW50ZWwuY29tDQo+ID4gPiA+Pj4NCj4gPiA+ID4+PiBJ
IHNraXBwZWQgdGhlIG9uZXMgcmVsYXRlZCB0byBob3RwbHVnLCBidXQgaW4gdGhlIG1tX2luaXQg
cGFydCB0aGUNCj4gPiA+ID4+IGNvbW1lbnQNCj4gPiA+ID4+PiBhYm91dCB6b25lcyB0aGF0IGNh
biBoYXZlIG92ZXJsYXBwaW5nIHBoeXNpY2FsIHNwYW5zIHdoZW4gbWlycm9yZWQNCj4gPiA+ID4+
PiBrZXJuZWxjb3JlIGlzIGVuYWJsZWQgc2VlbXMgdmFsaWQuDQo+ID4gPiA+DQo+ID4gPiA+IEhp
IERhdmlkICYgTWlrZQ0KPiA+ID4gPg0KPiA+ID4gPiBJ4oCZdmUgc3BlbnQgc29tZSB0aW1lIHdv
cmtpbmcgdGhyb3VnaCB0aGVzZSBpc3N1ZXMgdG8gYmV0dGVyDQo+IHVuZGVyc3RhbmQNCj4gPiA+
IHRoZW0uDQo+ID4gPiA+IEZvciB0aGUgb3ZlcmxhcHBpbmcgcGh5c2ljYWwgc3BhbnMobWlycm9y
ZWQga2VybmVsY29yZSksIHNob3VsZCBJDQo+IGF2b2lkDQo+ID4gPiBjb3VudGluZw0KPiA+ID4g
PiBvdmVybGFwX21lbW1hcF9pbml0IGluIG1lbW1hcF9pbml0X3JhbmdlIGluIHRoZSBuZXh0IHZl
cnNpb24/DQo+ID4gPiA+IEZvciBleGFtcGxlLCBjaGFuZ2UgaXQgYXMgZm9sbG93czoNCj4gPiA+
ID4NCj4gPiA+ID4gK3Vuc2lnbmVkIGxvbmcgX19tZW1pbml0DQo+ID4gPiA+ICttZW1tYXBfaW5p
dF9yYW5nZSh1bnNpZ25lZCBsb25nIHNpemUsIGludCBuaWQsIHVuc2lnbmVkIGxvbmcgem9uZSwN
Cj4gPiA+ID4gKyAgICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgc3RhcnRfcGZuLA0KPiA+ID4g
PiArICAgICAgICAgICAgICAgdW5zaWduZWQgbG9uZyB6b25lX2VuZF9wZm4sDQo+ID4gPiA+ICAg
ICAgICAgICAgICAgICBlbnVtIG1lbWluaXRfY29udGV4dCBjb250ZXh0LA0KPiA+ID4gPiAgICAg
ICAgICAgICAgICAgc3RydWN0IHZtZW1fYWx0bWFwICphbHRtYXAsIGludCBtaWdyYXRldHlwZSwN
Cj4gPiA+ID4gICAgICAgICAgICAgICAgIGJvb2wgaXNvbGF0ZV9wYWdlYmxvY2spDQo+ID4gPiA+
ICB7DQo+ID4gPiA+ICAgICAgICAgdW5zaWduZWQgbG9uZyBwZm4sIGVuZF9wZm4gPSBzdGFydF9w
Zm4gKyBzaXplOw0KPiA+ID4gPiArICAgICAgIHVuc2lnbmVkIGxvbmcgbnJfaW5pdCA9IDA7DQo+
ID4gPiA+ICAgICAgICAgc3RydWN0IHBhZ2UgKnBhZ2U7DQo+ID4gPiA+DQo+ID4gPiA+ICAgICAg
ICAgaWYgKGhpZ2hlc3RfbWVtbWFwX3BmbiA8IGVuZF9wZm4gLSAxKQ0KPiA+ID4gPiBAQCAtODkz
LDcgKzg5Nyw3IEBAIHZvaWQgX19tZW1pbml0IG1lbW1hcF9pbml0X3JhbmdlKHVuc2lnbmVkIGxv
bmcNCj4gc2l6ZSwNCj4gPiA+IGludCBuaWQsIHVuc2lnbmVkIGxvbmcgem9uZQ0KPiA+ID4gPiAg
ICAgICAgIGlmICh6b25lID09IFpPTkVfREVWSUNFKSB7DQo+ID4gPiA+ICAgICAgICAgICAgICAg
ICBpZiAoIWFsdG1hcCkNCj4gPiA+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuOw0K
PiA+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gMDsNCj4gPiA+ID4NCj4gPiA+
ID4gICAgICAgICAgICAgICAgIGlmIChzdGFydF9wZm4gPT0gYWx0bWFwLT5iYXNlX3BmbikNCj4g
PiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAgc3RhcnRfcGZuICs9IGFsdG1hcC0+cmVzZXJ2
ZTsNCj4gPiA+ID4gQEAgLTkxMSw2ICs5MTUsNyBAQCB2b2lkIF9fbWVtaW5pdCBtZW1tYXBfaW5p
dF9yYW5nZSh1bnNpZ25lZCBsb25nDQo+IHNpemUsDQo+ID4gPiBpbnQgbmlkLCB1bnNpZ25lZCBs
b25nIHpvbmUNCj4gPiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGRlZmVyX2luaXQo
bmlkLCBwZm4sIHpvbmVfZW5kX3BmbikpIHsNCj4gPiA+ID4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBkZWZlcnJlZF9zdHJ1Y3RfcGFnZXMgPSB0cnVlOw0KPiA+ID4gPiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIG5yX2luaXQgKz0gZW5kX3BmbiAtIHBmbjsNCj4gPiA+
DQo+ID4gPiBJdCdzIGNvbmZ1c2luZy4gQ291bGQgdGhlIHJlbWFpbmluZyByYW5nZSBhbHNvIGlu
Y2x1ZGUgb3ZlcmxhcHBpbmcNCj4gaW5pdHM/DQo+ID4gPg0KPiA+ID4gTWF5YmUgdGhlIHdob2xl
ICJza2lwIG92ZXJsYXBwaW5nIGluaXQiIHNob3VsZCBhY3R1YWxseSBiZSBoYW5kbGVkIG9uDQo+
IGENCj4gPiA+IGhpZ2hlciBsZXZlbD8NCj4gPiA+DQo+ID4gPiBJIGd1ZXNzIHdlJ2Qgd2FudCB0
byBza2lwIGFueSBtZW1ibG9ja19pc19taXJyb3IocikgcmVnaW9ucyBlbnRpcmVseS4NCj4gPiA+
DQo+ID4gPiBATWlrZT8NCj4gPg0KPiA+IEhpIE1pa2UNCj4gPg0KPiA+IERhdmlkIHN1Z2dlc3Rl
ZCBtb3ZpbmcgdGhlIG92ZXJsYXAgaGFuZGxpbmcgdG8gYSBoaWdoZXIgbGV2ZWwgYW5kDQo+ID4g
c2tpcHBpbmcgbWVtYmxvY2tfaXNfbWlycm9yKCkgcmVnaW9ucyBlbnRpcmVseS4gSSB0aGluayB0
aGlzIG1ha2VzDQo+IHNlbnNlLg0KPiA+DQo+ID4gV291bGQgdGhpcyB3b3JrIGZvciB5b3UsIG9y
IGRvIHlvdSBoYXZlIGEgZGlmZmVyZW50IHByZWZlcmVuY2U/DQo+IA0KPiBMb29rcyBhYm91dCBy
aWdodCA6KQ0KDQpUaGFua3MgZm9yIHRoZSByZXZpZXcuIEnigJlsbCBrZWVwIHdvcmtpbmcgb24g
dGhlIHBhdGNoLg0KDQo+ID4gU29tZXRoaW5nIGxpa2UgdGhpcw0KPiA+IHN0YXRpYyB2b2lkIF9f
aW5pdCBtZW1tYXBfaW5pdCh2b2lkKQ0KPiA+IHsNCj4gPiAuLi4NCj4gPiAgICAgZm9yX2VhY2hf
bWVtX3Bmbl9yYW5nZShpLCBNQVhfTlVNTk9ERVMsICZzdGFydF9wZm4sICZlbmRfcGZuLCAmbmlk
KQ0KPiB7DQo+ID4gICAgICAgICBzdHJ1Y3QgcGdsaXN0X2RhdGEgKm5vZGUgPSBOT0RFX0RBVEEo
bmlkKTsNCj4gPiAgICAgICAgIGJvb2wgaXNfbWlycm9yID0gbWlycm9yZWRfa2VybmVsY29yZSAm
Jg0KPiA+IAkJCQkgbWVtYmxvY2tfaXNfbWlycm9yKCZtZW1ibG9jay5tZW1vcnkucmVnaW9uc1tp
XSk7DQo+IA0KPiBJJ2QgYWRkIGEgbG9jYWwgbWVtYmxvY2tfcmVnaW9uIHZhcmlhYmxlLg0KDQpJ
4oCZbGwgcmVmaW5lIHRoaXMgaW4gdGhlIG5leHQgdmVyc2lvbi4NCg0KPiA+DQo+ID4gICAgICAg
ICBmb3IgKGogPSAwOyBqIDwgTUFYX05SX1pPTkVTOyBqKyspIHsNCj4gPiAgICAgICAgIC4uLg0K
PiA+IAkgICAgICBpZiAoaXNfbWlycm9yICYmIGogPT0gWk9ORV9NT1ZBQkxFKQ0KPiA+ICAgICAg
ICAgICAgICAgICBjb250aW51ZTsNCj4gPg0KPiA+ICAgICAgICAgICAgbWVtbWFwX2luaXRfem9u
ZV9yYW5nZSh6b25lLCBzdGFydF9wZm4sIGVuZF9wZm4sDQo+ID4gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICZob2xlX3Bmbik7DQo+ID4gQmVzdCBSZWdhcmRzLA0KPiA+IExpdSwg
WXVhbjENCj4gDQo+IC0tDQo+IFNpbmNlcmVseSB5b3VycywNCj4gTWlrZS4NCg==

