Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C4C8D111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 02:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D4A96B0011; Sun, 30 Nov 2025 21:53:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AC296B0012; Sun, 30 Nov 2025 21:53:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474016B0022; Sun, 30 Nov 2025 21:53:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 347BF6B0011
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 21:53:29 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C496FBE4C9
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 02:53:25 +0000 (UTC)
X-FDA: 84169381170.12.93A2E75
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf24.hostedemail.com (Postfix) with ESMTP id 681BC180007
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 02:53:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hgneUzr8;
	spf=pass (imf24.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764557602;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xGbwAORvuQeE8r1iH0yNxJtr7PuGFAju8lBAnCR7wh4=;
	b=Jwi4LDSV2tiKkbJ7HQhyupmD+dIjzXzVftKetRIYYOBgbakIHf8LID3rBRsGI37a2+EY1T
	X/qTZBqVaLD6ZB83kj/5JH9hWGvtGekAZFs8lVkQrRNzIh0VO9klMYi/bAosgCbG2J72OH
	5hxsJX4gIx92zMmkH0+WjKKlVBAlZRo=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hgneUzr8;
	spf=pass (imf24.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764557602; a=rsa-sha256;
	cv=fail;
	b=l57n6iOVUXSryzIV5nmXEPPMqTxndC4kgjUUN3C1Fk6JI5oBHq/2MBinAa06q3BEmIJkIy
	zlh+XGcmEA65OIgU21iyIAx4VReKufrW3FbE+y+zaPD5K80ULOsHVSlQ175IuRbDSQVVu+
	lyU1c79wdC8Db+O4gsXVIadqeO93pmQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764557601; x=1796093601;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=NbmymWaYigIQcEwkwDEEd5ekLGG2TZhICvu+CRiHznc=;
  b=hgneUzr88GZMlgVj+zC8qkoeT+4kHrCUZAFsvU45rKae+I/Vfoq5ex2x
   hpcOGlOKHAduyhlCrTWuIHD3umScP86maaZ/juCwDsQeTr/nV/RL9IMHO
   t7cN4LcC7lUD++ZycV/OUjalAbiAyo4aI7jlUVFFdKeu+5H+k/P3RlG39
   Hq3htWkM6doOzj66RkKHkjLcgb+x2Xo76WO9HGeovNdwFh1Rpr8fP+ONA
   e/vVoLLPQJV7oXGgVhMDSrX/faUCLWZBXHWBhcLIeiSwFLZSaUkDOYkIM
   W8ufmHFBAWb88OA/4cw4LJJYwVpMdeAB3Ge6P5HUQpt8JvdksjxQwb8ne
   w==;
X-CSE-ConnectionGUID: P1pgS/tKROimGbHPXKY7cw==
X-CSE-MsgGUID: Vy2EgqI7Qryj/S9lxhbNsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11629"; a="66446000"
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="66446000"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2025 18:53:20 -0800
X-CSE-ConnectionGUID: QdCAScWkSLuwG/oZGkUePw==
X-CSE-MsgGUID: 7grwdXFTQyesvTBOCBskpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="193753822"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2025 18:53:20 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 30 Nov 2025 18:53:19 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sun, 30 Nov 2025 18:53:19 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.45)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 30 Nov 2025 18:53:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lz9qT5XOpCFDLiMcyRA1GqZBYdp1w8K3gDRi4QDPVSTHQmLTPuCwvSS/QBF1Ac6nNAtSAg37VY5KwPy0zCjKnwnPC4p2Pxx7IGh20It1kIHnobVuaQ3ymrCv9ahm98bwkXdqpHYYfIGT7iv9krYak/Uv0OawdgQSYQBl0I0wvs1snQLeQkOcb6Gwx/gSLDQo1hTU7bMURn2Ads1C1yzHZnN8zcQiXV54BFRTriyChQbCHuVLq3xVNdnSR0p/pNJFHoYGTCzOHAori0yUUYEyZDEW3Hl2zolUcD8v5Y41J+CCoQiwQMK1Zx6zeFsaXXBfnd6dmr1EN7Juxi1QVhhWDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xGbwAORvuQeE8r1iH0yNxJtr7PuGFAju8lBAnCR7wh4=;
 b=Dn4ojOvm8Tgih/Ljio4FVY1BTrqnS2/lkYbCKMcmeA+Abf0W3U0VjTPhTcwPwJ4XpcX0NOopwePCkY1X+3AEJviJpyMSonYyP7m/obMV0TGKBmJEm/1o35RjZG3mcH/vE8RQBCS1i1faBSJcAVivOHuUdS4Pbp3SlVn6tE14WbpPIwFIeu8DHtkO4oMUKyparGVjfITMvLGj2QLyBEcF4hiNfegqUdahxT3xydoj4UVZtK7HIUllo6fGJcm7HBgu0MW1+dQRtix+QtZzvdKVa2u104CSfHRHiTMo0sd1e7A+qreCGiEWlscQdrecnoshwXun45I0beNmBlIFcEXReQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA3PR11MB7464.namprd11.prod.outlook.com (2603:10b6:806:31b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 02:53:15 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 02:53:15 +0000
Date: Mon, 1 Dec 2025 10:51:02 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: Michael Roth <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<ackerleytng@google.com>, <aik@amd.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH 1/3] KVM: guest_memfd: Remove preparation tracking
Message-ID: <aS0ClozgeICZN/XX@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-2-michael.roth@amd.com>
 <aR7blxIx6tKD2xiQ@yzhao56-desk.sh.intel.com>
 <20251121124314.36zlpzhwm5zglih2@amd.com>
 <aSUe1UfD3hXg2iMZ@yzhao56-desk.sh.intel.com>
 <CAGtprH-ZhHO4C5gTqWgMNpf5MKvL0yz6QG2h01sz=0o=ZwOF0g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH-ZhHO4C5gTqWgMNpf5MKvL0yz6QG2h01sz=0o=ZwOF0g@mail.gmail.com>
X-ClientProxiedBy: TP0P295CA0053.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:3::8)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA3PR11MB7464:EE_
X-MS-Office365-Filtering-Correlation-Id: 1818cf15-f3ab-4594-cbfd-08de3084c61b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TkZreTJaQW55NU9oZFY0Q2p4RG5mVElJUmhnQndNa2tiVnNLeXBHanlVeldX?=
 =?utf-8?B?K3FYWUNISmdEK0MvV2RCYjhLcjRrczZGbEd5VzdCalZMRllFZG5TQlhydmtC?=
 =?utf-8?B?NkgrMkRzcXNEa0owRkU2VjRiMzRVc0FNRCs4ZkJ2ODJkTlh5NjNVOXBoT3Yw?=
 =?utf-8?B?bk83YmQ2MFpZdkJNS1huYmpndk0zRk5xbjVWczRHRlRsdnpFbVNXTCtpWlp2?=
 =?utf-8?B?YkJacHRZM25pVEkyU0d6S3JpTmxINDZNN2VKdUM1UXc3enc3N2cxUWRRWTRP?=
 =?utf-8?B?TElsN3N4Q1pxU2xsc0R4TUg0UkdoaW4weEtaZmw2ZUxCOTVzZldSQThVYlZ5?=
 =?utf-8?B?UGl5UFpTeFA4UmVQR0JxSVdTRkNkczFLWXZxRzcwNUVyejQyNUFpM0FQSVdX?=
 =?utf-8?B?WXFoRE5YMXhFcGREdi9lZkprWHFHZmtXT2YwM0pxZE9oRVJTdTJVN3FHdmZq?=
 =?utf-8?B?eFNCVTFPSzZwbVkrbnA0NzA4L0xEVmJqcmgrMFFUQVJyaXF3dzRWMHg2blo0?=
 =?utf-8?B?Y0pMdXhIdERlWHpCblRvQnJZd3NBTW5iZzFUR2JZSVRDUjd1N1crU3VlWmxk?=
 =?utf-8?B?dWprbmRSamxWYXVoWWdkanRSYlQ4bDRPM1JFOUxrVm9nRUlrbVBrR200R0l0?=
 =?utf-8?B?OWcycWFOSTgrdkdJTG1ZM2F1ZlMzUnptZHVIYUlZcXFQeXpicmtlbFRzemZV?=
 =?utf-8?B?YURpNlYvbEVvQ1Nxa0p4T0kxQ2tLT0RTVm1yekZZOXNGTHpFY3BEOXpRODAr?=
 =?utf-8?B?ZFMyM2k2UUxESVFQRHhIMTVUOHhtalA1em9IRDFUOHpwTmhOOFVQeFhRL1Fh?=
 =?utf-8?B?WWdoODFkaVdEWXRUMkxYSGh3bE9MYWhqTG5IRWY4Y1lVZ2JrYmpjSm5hNWlp?=
 =?utf-8?B?YVV2a05KUG1ZUHl1bmZUbXJ6bmI3YXoxaVlJb2RvaThucmFmK0s5SXBDQmNh?=
 =?utf-8?B?dWJoWGlrb3R3RHo3WjZRcHVMMnlZc2xPZGdzaG9TbUdhV1hib1JzZUgwek5Y?=
 =?utf-8?B?VnFtZllLY25oRklQWjdYY3FnVDMwenNmcWN0bEJsVlpUWHk1OTREeU0wWnN2?=
 =?utf-8?B?QmFaS0liN2hkc2hKb1JGcTN5aG9rcHJrdCtKZlpKaTBMTzY1ZDhVUzgzUE44?=
 =?utf-8?B?Rm44TW5IZ3FCK2kvRG9MZVFZRDB2dVB4UHRCYTMyMDlZR0RXNlkrbE9ZcHBQ?=
 =?utf-8?B?eUdiY0xFYnNsa2ZlNGc2MmhKV2ZUNVVzbEQ2ZVYvbHVtZ0dMK3NGMEtiaGRm?=
 =?utf-8?B?ekxreHdLV3RPbi9EZU81WTIzZ3JtV0ZETVlXOUFhYUlKMm9KcGk2eEdJZXFQ?=
 =?utf-8?B?NUFkRTRwdFFlRHU5Wm5aQi9NVUxnaDhpd0p5bldhcHp1N2JrdkJCYUE5WlJu?=
 =?utf-8?B?amhNYW92S3NHa2lMUHMxWG51bUZNM3BvUS94bmJKVjN5bys1Y0t2aFFtOFcw?=
 =?utf-8?B?c1Q1Q1VsMGNnaHgvRXY5N25ySHRUWTdoT2JjZHRTYUFtVDA5QkV5WlZlVzJF?=
 =?utf-8?B?NzNPaEhXb0NhNmNkeGVhU1dPM2tnNXNJZE1OYWtDOCt0ZmNGL0hkN2JYR0pV?=
 =?utf-8?B?WFVEeWhqQzZlUzRCSGNuaGtsWHdRMC91TzBrTlExSkFFMlR5VDE2R3djT0R4?=
 =?utf-8?B?UnRVTitGN0dlZUJnUnlYREszVFJpZzNTTWxrcHhidldwZkFhV2M3RXRoSHhs?=
 =?utf-8?B?eG5sQTRlMjlJNFpSVXZ4UVIzTmtIU2xtbWNHY3Q1SktNck1VSjhHdTZVeEVR?=
 =?utf-8?B?SXBhMElycSt6S21TVFBlbitmTlEzM0ZpblVzZGgxSFozdTZueklJMWhxdFY1?=
 =?utf-8?B?cFp4akYzQ1pDWkJ1Mk9VcUp1VmVNWWUzS3dCRy8xYkhObzVkZzBKTHFVUzQw?=
 =?utf-8?B?ZU1iRm42M2JzQ0JHdlZrRHIxWVVBK1lrc2YvL1FHaU4rRHV2ZnU1bUh0UkY3?=
 =?utf-8?B?bTF2Ky9CL1M4bC9QQjJqVW91dmMzc3dzbGFxOEVxUWFDVnFqTWxFU1EwZzRt?=
 =?utf-8?B?UWxKMW9XRDBBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dk9JK0YvZThzTjJmT3lSSG91TUVTcC9mK2gxSVdmaE1TSVhpQzVweVphNGJ1?=
 =?utf-8?B?eUwzTzEwQ0RGTXpJNTl2ODFVMUVmeCtmbEYvdksxdEZ5bU1LNHpPUFN6ZnB1?=
 =?utf-8?B?ZUxXYXJBdi9HN2tsYkhzbUgxaHRRNFNTYVhZYlFRcWlQQURaWlZISmczZzY1?=
 =?utf-8?B?b241aGlLYk9rbjVGSDVDZjVCVHdFMVJuVUZxSi9qeSs0NkE2bThkS1RiYkds?=
 =?utf-8?B?RVBlL1czYmdzMWdTSXRCUmZJTHZvNURhZ2orTGo5UVRSRDRsRDYxbldXMkdk?=
 =?utf-8?B?SStRbzk4RjgyMVBxTUNBM2ZSM3phNjZYcElYdGNhejA5RnptaUtCRXo4MzN5?=
 =?utf-8?B?SWdGdnA4RWswY3pNbFZIYnEvNnFZYjNSZEgyYWVSZVNVc1FoT2ZnYkhncGJM?=
 =?utf-8?B?YWFHaU9Zb05mQnFUTFVoTVRVYlc5TElGWjlUQkNiQVpUcEFYd21zNThCWlpY?=
 =?utf-8?B?V2xQL3pQRkhhUTNvMlFnK05DREJSNlhLVDhUcWdMc29KU1hEY0JKZTJBSko5?=
 =?utf-8?B?Z2FlQ2JpSFJvcVRwU1Y2OWhRRGNyTnY3SUVRbTdOTkFZRmFSM3ZxbFZ5UldC?=
 =?utf-8?B?Y2dsOEE1THFoRnVjNS9kVkdOY2tjNFl4cDd6M2RiNko4TkhqdHZaSzlqSmFr?=
 =?utf-8?B?N1lHcENGUk9QckN2cTZIR3NzMTUxdFVPZDVtSEY4b0pSTUpEeEdkdU9tVXI1?=
 =?utf-8?B?WC9tbU9HWjNOMUM5UW9pd2N4dDVqcENIaXhNaDg0WmtIWUVKWVpOcCtGdG9o?=
 =?utf-8?B?WWlabkNhZC8zZ2RtTTdKTG9rQi9pWEpFTklZSGl3Z0gxS05CbGloYWMxeUR4?=
 =?utf-8?B?RU5haWNhdXlWYWwvM05CSHA5eEhjeFlQdk9wZnVnNEFTalVoNjJMWHpLNm1x?=
 =?utf-8?B?VnplcjEwUkgrVEpvZ2lwalZPb2pENmxyTW9mRTRWK2k1MjU4UEVoMVFPRXZT?=
 =?utf-8?B?UlVCUTlEamI4dkIzd0F2SEV4YmJmdzJ4WFZ0Y0FkeUdGMmdtc0FnS25tek9R?=
 =?utf-8?B?bGV3V1gxN3hqVmF1MW5pOXpwNHMrM0VHWlBVcXJCZEdhanh2TnEvVmtoS2lz?=
 =?utf-8?B?NzdsSWpsTEkzUG0rUHU5Q1M2MzZNeEJXOUkzSmgyU1JOUG9tV1RvRjJpaVBS?=
 =?utf-8?B?SjQ5VFlSMjlqY1UrSTlBU3MvTDZqcGxCMFU5L3h5NmVoOVV6NkExL1ZtUUZm?=
 =?utf-8?B?bHhBU2VyVnkyRXhFdEFuTnljTFJtT1pBMzJrWjhXOTNmV1ZUZG45S0xoc1dS?=
 =?utf-8?B?YjVmZTB2NnRKWnFQN1JadGxPMkdJaW51WEJ5Yk5qeFl3TVNJT2hINEl2UWZs?=
 =?utf-8?B?REhOSDIyOXRJcDJxdTNQY0dab2NzY0dkcnNBVG5KQldwWElrS3FPNWJhc0I4?=
 =?utf-8?B?dkNtYkpyWG9BOFFZNWx2Z241RnllWUxBWXFkbHdJN3NvS3UzTnE2c0lNNDRZ?=
 =?utf-8?B?c2taSjlFQ3lUaHJNb0dKSzJWWGEraVRqdzNWTWFmTXM1amJtejZMOUp2RUkw?=
 =?utf-8?B?di9pTFAzdzFFUi9MTkhwUDkzVXlwS2dPalFqNGI0QXhxd3pCOXhNMFBWWS9v?=
 =?utf-8?B?T2VCOXg2dnlDV21vRWlFNnRGVDA1alFOaTFmRUdBa0VxQ0pxUGFHRThITG1u?=
 =?utf-8?B?dUhVUG5RRm9TdFBKNXplOHhCYm01Q1c4RTNQK1JyeGtrc2o5S0dzOXhTQjhi?=
 =?utf-8?B?NFhIaDFadDYrUzVnQjR5YWN6Zlk4K00zMlg1MUhucG1DMWZUaENMMlcwUzRo?=
 =?utf-8?B?Ym1JVHpPYkdMSUE1ZUNWS05lalVKckIyaDA4L0kvL09LdTFZTXhzZ2Y4QlNl?=
 =?utf-8?B?clo5Wjh2TmkwUHMwM1MvL3ZHY2RlUUl1UnYxTkFKdUNacmQ0NVIzY3doaVZW?=
 =?utf-8?B?b0N5VE9LZUxSdUdxa1FZTGRsTWZMMVdyR3hYSGkwU282UFdWVFB0dVd1Z1pF?=
 =?utf-8?B?eDloYks3alI1cGtLRFUyZEZ6Z2laOXpwQjk3cFJER2QvSVExMVRnUXV5bGJN?=
 =?utf-8?B?RVhOajZ0cW1BbHZQclNqRWorMUN5UTIwNUhWS1REdVRHMGZBdFRxa1VISjFt?=
 =?utf-8?B?dUYrWmczVTY3UzRmSktQMGZKaEY1dkZ2cVpKazhQVi9IVWpWOTI1N2ZxUVVE?=
 =?utf-8?Q?sQoTbRrmp3PAo6JPAioEQSLyW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1818cf15-f3ab-4594-cbfd-08de3084c61b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 02:53:15.2835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HjZOhkp3p/Y4Xed6wg/tD0sxB1Vs4xbJuiZjg88bDBMlqJbgZcoZ54pOL1GnB33QoBhotHhWraYCDS96vIaqhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7464
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 681BC180007
X-Rspamd-Server: rspam02
X-Stat-Signature: anourzz3cd33bpm1yf9iquyc1nogg1qy
X-Rspam-User: 
X-HE-Tag: 1764557601-596687
X-HE-Meta: U2FsdGVkX1/ozX5f3KRFtez/lRM42WechE9Ep87eVSSSHeMLIBVhXbdCnSAhlyWKHl7E+7dtLHiYrPDbIMr9MLVQ1oKJtiKj08TuhvSSR7ATvjJaVr6NE5uEYNbbKDUfVqoGkQOII45xxCT83Q0IlPIL2sEimRDJfdIx/+ttroO0+56K+fm0BF2pwqRoyCL0c7zRgDelK5+Wsx0iE10qNuiemiawRbsYUt2xZxSbQ4DhWttFqrCgVkv0CZA6w9X/o4WH9/slBQGflNGu4yuf8ymKRedWjghNZkG+q6Mju6HjzcOSse+8ntvTcwVPPqWZinllK9FaHvdIML2EcWK+Je0pfscGPZ7nx75rjeI4vg7F/sxHi/WW42I+h94GojFvjQbhLpee+uWwMWeuCChkopAUZrziOzw16y1LBvti910eYzaVjXFRuDxcQPKrV2VGez5aGxxRNTIXFi+NvRLOPBlMKcsPBuIG1OJkB8P2XkoMXZNuD2yZedFguIk/cSpo139xb9jAI3JtQGfJWG+3arY8MN26EVrfDrcwTG9ypZvC4MIGQcj6klk6iBbY8hK+XpZ5OIAAJJJkB0WdR84Yfdt6KaiOq9t7nP00OZgPb1QRDtSw+PZBcN7ZEk0gaZRuZjZ8TFD2OOh+sQoZddRgy7//K7/O0AWNj7wyYWWDPuamgOdncFs8ylJ1YKuuMN9l46PtDLKtr1SN+YdP1EO6lHI9fz1pgjgJ519+mzaCdF29qLzwbN8vjj850sSOAHvSvMQLgd1yT4nUHO6cJSuKma8clff+JzuGhn+PQ6dyh164b3iBJk9HfNH2VmpUK7oYfQfzWhLpBVQC18jeidy3VldkJdqfE0HrjQJ5ZfgUSETGaKgC3JPm3wtT1IHXTH60ViNQq336Cg9jfFKDkesMju/kPYaibf/+a+cpkJ+8np5FqCtf3TxZcIUkvzKQbBwnGBgDjbpN7Q2J8bD5wpj
 98s+fqTT
 iTfpI9UHxHd98l2vSQpfNj1fzDLe64PqpNoyje0t8TsDVu3rpy3wG+CB1uBGf/xfTlOu6h3yTbx4qOCiUiB614Jx0gfHUi4KHMHypk9ftVxrh+Brs/Yls9dPnqWcIZ+2Z4EOv5nRl5MW3jzfY74k/q88a5W8FrL/DiwcRcjEA/u62OJtVIwpKzlULKgX6Nacv2y/oBUwEIC8xDumUFturkT+Q+uJvvgzCH+ueUjwb5vZBYdU86gam9rfZ775ODcF8B4O48OF+YUrd96Bjlc0Ml8cw2ZId097FODKtTUZmrVvjPjw4Av6JLtTFsmocnNJb+4mRYSrtoNbQr0CpntRgjM4UkaYFgMMVdrEAWwFcGtNCuNT8rYwdz2mzp7K4BbwGt6t8NjcEcwHfv1BqMLwyZERyKPa+vc0UV4IgcWYHVUS0hJB2BPS2IWDjhKtdpARv1arqQd6AjACFjendkUcHYpXp9x3WR8vggzr23wK8KJqzD9JrQQYbFh+/rzTYARPlKqjf65DT3a8eGchCsnvR4YxTSj50tBg6aE4DpIgj/MsHzXHJICwn/13FjmJhjFl6TXbuyt0hOyCEOkYxY6MPmDbgGG9oH4C3yzenQOIFDZ4A8HY7e5OJ0NQyAEk6NGgeFdAWEo3euhhRjErN7c0j+lrFqYH+lJS9nTIlCaYEmw/xtK8sMWQXwYChzMAX9ylqCBpk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 30, 2025 at 05:35:41PM -0800, Vishal Annapurve wrote:
> On Mon, Nov 24, 2025 at 7:15 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > @@ -889,7 +872,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > > > >           p = src ? src + i * PAGE_SIZE : NULL;
> > > > >           ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
> > > > >           if (!ret)
> > > > > -                 kvm_gmem_mark_prepared(folio);
> > > > > +                 folio_mark_uptodate(folio);
> > > > As also asked in [1], why is the entire folio marked as uptodate here? Why does
> > > > kvm_gmem_get_pfn() clear all pages of a huge folio when the folio isn't marked
> > > > uptodate?
> > >
> > > Quoting your example from[1] for more context:
> > >
> > > > I also have a question about this patch:
> > > >
> > > > Suppose there's a 2MB huge folio A, where
> > > > A1 and A2 are 4KB pages belonging to folio A.
> > > >
> > > > (1) kvm_gmem_populate() invokes __kvm_gmem_get_pfn() and gets folio A.
> > > >     It adds page A1 and invokes folio_mark_uptodate() on folio A.
> > >
> > > In SNP hugepage patchset you responded to, it would only mark A1 as
> > You mean code in
> > https://github.com/amdese/linux/commits/snp-inplace-conversion-rfc1 ?
> >
> > > prepared/cleared. There was 4K-granularity tracking added to handle this.
> > I don't find the code that marks only A1 as "prepared/cleared".
> > Instead, I just found folio_mark_uptodate() is invoked by kvm_gmem_populate()
> > to mark the entire folio A as uptodate.
> >
> > However, according to your statement below that "uptodate flag only tracks
> > whether a folio has been cleared", I don't follow why and where the entire folio
> > A would be cleared if kvm_gmem_populate() only adds page A1.
> 
> I think kvm_gmem_populate() is currently only used by SNP and TDX
> logic, I don't see an issue with marking the complete folio as
> uptodate even if its partially updated by kvm_gmem_populate() paths as
> the private memory will eventually get initialized anyways.
Still using the above example,
If only page A1 is passed to sev_gmem_post_populate(), will SNP initialize the
entire folio A?
- if yes, could you kindly point me to the code that does this? .
- if sev_gmem_post_populate() only initializes page A1, after marking the
  complete folio A as uptodate in kvm_gmem_populate(), later faulting in page A2
  in kvm_gmem_get_pfn() will not clear page A2 by invoking clear_highpage(),
  since the entire folio A is uptodate. I don't understand why this is OK.
  Or what's the purpose of invoking clear_highpage() on other folios?

Thanks
Yan

