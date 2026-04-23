Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB494FAD3E7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 03:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AA056B0005; Wed, 22 Apr 2026 23:18:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05AA16B008A; Wed, 22 Apr 2026 23:18:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E64DC6B008C; Wed, 22 Apr 2026 23:18:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEF076B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 23:18:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B92A1202E3
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 03:18:10 +0000 (UTC)
X-FDA: 84688361940.15.A356A55
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0F8F880008
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 03:18:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iOObif56;
	spf=pass (imf02.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776914286; a=rsa-sha256;
	cv=fail;
	b=OYFMkiCliAx3pEyxU88wg/v7c9v8zzWI68EtXEHCE251sWuoEbQVeQMJcmOSiboMW44akT
	cn7G1agDbIcqHrLKsm0UHELOE1EilwDLGmOyP4kNTEqHcVt/EKm7zu/58WJm5xYYvDqHYx
	Dk4RIy3VRU8FZ2Ha8IUBZfg2aTHHbrY=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iOObif56;
	spf=pass (imf02.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776914286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NR4xPVyLy8iC/a26lADikV/ZrQ+l7GZljQdyE3KHbpE=;
	b=h4OyMdOAl3cgIpBTnTRV/BBojbSUshA4eXTwhmwbux5Xu4Vbs4EdpQmziOLc1JM3qPV/OF
	6ZLH9sVFCH0ac20daqpUIGB0X8grPcsfQC0IqzYOUUetPrTyRrDtn0FNagF/UIlEaAQY9I
	SPSEH27Nkmc0aM96COJxzLJdbYFtp7c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776914286; x=1808450286;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NR4xPVyLy8iC/a26lADikV/ZrQ+l7GZljQdyE3KHbpE=;
  b=iOObif56cA2LtBRN5D38ro9KgOQwsScoWS6eaOWUptZuerB2p3ZM2cYe
   zylZQkyACvNBir2R+f98CFQC+DFnCT9UNZV/JJ1qYTutz/a8QSGUk5DfB
   DFby776wB/Y7FV5HqAP334HYXeTgEVv6qEJlStJgoUxyDmEPZbRxJURRP
   2RsDguweCzAQ2em9OKHc8V+8G7Bey/Zjv5NTSGhXdBwXlJLPonlPSsn9+
   /5ifPmzBd9R8MWtWykkrIZXAk8hoPDCv7mMnLI69PmfEp68wRM/mI1yM/
   uoV7skXoO6ipwpDyBk16BbmL0VZBiCVGeWUHOJC4FwJ55o59jrsf/H3Kq
   A==;
X-CSE-ConnectionGUID: 1bDzd6sGR/eMLQy3Sz2rpA==
X-CSE-MsgGUID: JSuBzZvvTTmUYYPmg+vreQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11764"; a="81485284"
X-IronPort-AV: E=Sophos;i="6.23,193,1770624000"; 
   d="scan'208";a="81485284"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 20:18:04 -0700
X-CSE-ConnectionGUID: PG7KCobiQoWguoaXTIB7Ew==
X-CSE-MsgGUID: cftKfEWDTKem6SMDkm6M+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,193,1770624000"; 
   d="scan'208";a="234321636"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 20:18:04 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 20:18:03 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 22 Apr 2026 20:18:03 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.40) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 20:18:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fxHjK53iOMzz2ptOG86FNqN44sgxQi+by3IrZgE0YHUEvFG5ryXSSaT0PkzuQvjD6G84AGYsY+Jl5UdhryoTTCGYZwpKRhSSMsSB/pb1UUXZ3UMPygaFhduCqwoHhQErTLSfP9mwWq0b0bxkJAHCFio/TePfM/L5BJAfLYtx8uc8ownx7eAnxSenIzXvtgZAw1GQvYSTGn+kxqgXp2SQGi4BjraR9g94IbqIgvF8lER6eZJ3lM5LYPUPIG5s1s7jNb9Mt8dTgHUE7m7QkZV87eSL46X6cTPUZd4RVRPkUoXxbs80/fhnxO4xLG2QxWcMa3uhVUZX0zDYm7L9xdQqUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NR4xPVyLy8iC/a26lADikV/ZrQ+l7GZljQdyE3KHbpE=;
 b=BNpcd1ociC2wCqIg5UlfX8e/bx+X4wgLAUlAOFB1eehraRKdw8N1N3W9G8jVPNA2U76qCb6gKp0aePJBqWFWXqi9iEIxTglVknlgDHUlHxSbbNluPdCrK0TCuVIZd4UdgJyEmIiN59dxGPjrdHZ7MgFnMzeoG1kO+nEN1MBXLs3WCXZqRmPgpprzpfWKlohT6TEyteICBQGRbn4Jygp45zaxO/iQtVajT9CjZVKOluGl1gUVwfRr6I1I8xdIoltC3yIYzq1Gy/nuWjeDVzbUTk9JuW9KoiBRsgYCvnVYwaLVQfezgbhI4L7Zeo2g+60TyuLnNi6SrvGo0SqaMkDI4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by CY8PR11MB7827.namprd11.prod.outlook.com (2603:10b6:930:77::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.21; Thu, 23 Apr
 2026 03:17:59 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%6]) with mapi id 15.20.9846.019; Thu, 23 Apr 2026
 03:17:58 +0000
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
Thread-Index: AQHc0Y4fvsNctkwngUWvH8b5jJmZiLXqtS2AgAAChWCAAL1dAIAAhttA
Date: Thu, 23 Apr 2026 03:17:58 +0000
Message-ID: <MW4PR11MB69364FD21534A13B79BAEFD3A32A2@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260421125508.2317429-1-yuan1.liu@intel.com>
 <2fef4fae-b7fd-4c27-9a76-994076e27b5f@kernel.org>
 <MW4PR11MB69364107F48CFD6D35AA9771A32D2@MW4PR11MB6936.namprd11.prod.outlook.com>
 <fe573e15-0ce3-40ac-957b-03d63fd7a5db@kernel.org>
In-Reply-To: <fe573e15-0ce3-40ac-957b-03d63fd7a5db@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|CY8PR11MB7827:EE_
x-ms-office365-filtering-correlation-id: b317b599-8b22-4f43-638a-08dea0e6eb9a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021|56012099003|18002099003|22082099003;
x-microsoft-antispam-message-info: E1GNK6eF7yF6DrcwklzXvXt1NddRUKzD44p+Kpix52ctnwYt4KXeJemFI6OuwoHq56JxKXVJxo2gaEbOw/IULmXMp8HFW4hTeBYu7sZraZCfNbAN6ECSQNHXuq6Pbbvz7pgReRear9NhwQsq/PDvTLAKd+/+txdkv+tqeVj6WG2APYfL85vmhkk27OoG6AXFjtn6jkhgCVDT2Asv4YbHQqhi3t7OIgAvneCDxmucvjmuHVs4UnrmrnZ3ReilOldP114uIGmdCqOvMZOcxXk3Gc6KkryYXqJfTQaVMrJm2FIf2IKZk/jdkWTe3ZmDDMDEh78ms3Zfa32+IZyr/P2XrvIYb3+ucT4woqbyEhJcHUHhtlc0IKF6+0JnA9X95y2u+EnM5yH9UZWycJsEdPU8KUN/2F8fPinR1FL+QuextjxpYoVHUHx7Nrn/sqXSxb7LZR/JSphC6RHk8oabB6FiHvEnTJ/48K/PkE+kDDvZ2IX6Kf6AsoMfkyGr1OWIxnDSZnzNMmzDrdT9hasSJ6M4uOGZZLgYUvaEdmm7NUgPAlBOB8D52A304wGBPEMcfamgvACYAl0eQeF7xsinla3OsmUKy9sisoB+A7QP6B9nhtg20ak2M4sohoC7YLLvBCVzkId/EaCAqI8OHnsfEFbZZdskKzNHEn1kUxLPSviynFDxXPHrxH3RZpjwUGPlZd8oArdT4hI2BjGBRkzrVZjvE8DRs+Qh6/WP0Ng7CvYgEYmwdRlFwvrt1ul6rOdSA7yaARA+MIzCvi7VALz42+BZnhBmwG4Xa2uBASEfwOcxK409lr3DWiJW0kV3WkIMypRZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b1VPVXIzZ1NtZHAvQUF3Yi9mTjJIZjBBMVZjZXBBdHlxVk82akwrSEh0MTZt?=
 =?utf-8?B?OGNZc3ZjTGVLWm9jcVJlR21lVmtNN3Y1Mlo5cWovcC94S2VQZDBTOTczWWlM?=
 =?utf-8?B?VU03blI4bnJKQWh4Wmk4b2xGKzZXRmp0ekNvVjlXc2xTRjJzY0MxbmdjblV1?=
 =?utf-8?B?a0dyd1lZNGhwaGVIb292WTcvc2Q0MW5MeEFCaXA5eWhEUDBlOUJJY3BwOElp?=
 =?utf-8?B?YXhRL1ErL05lcnR6aUFRa0xIb1grcTFBcjhMd0x0R1pKRVZsalhnS3UxY1hn?=
 =?utf-8?B?ZzNkb2dyVkpoS3RHMHM4aXdYZVR4eFoxdXhPTnhEcWJHcE5yd0xuemZScTNs?=
 =?utf-8?B?dVRtQjQ5MmFJQmdxYTJRT0JlRW01RnNNZ2pYeTJZVVV2NE0ydkt1d2d1M3pV?=
 =?utf-8?B?eDJ4bVFRdmZpYnhoaU1rWVdJUHVIMnpnMlRjbFV0M0VtOUUzVWV0QVFSbU9J?=
 =?utf-8?B?TkdoRTVwRjBObkg1aG9yZFh3eDdmR3p0eHY4SkhDMGNVWDQ1V0lrelpoaUhC?=
 =?utf-8?B?WHFPNFdNWHY1WGVCZGMyeDJBeXQrZ1doN0NYTWdmS1JWdGJJNmViOTNOaTFp?=
 =?utf-8?B?NnVpWFJ2NzcwV25CTEQyc0xnTFgvemFMZlhUNWxRdlB0UVJQWnYySjFxNCtB?=
 =?utf-8?B?d3dZTDlTRllUSncrbW5qVzYxK3p5ZGNlbWwxbnM0K0NtMTJmOCtTeFhYMnNU?=
 =?utf-8?B?SkFGWkwvNEdOdHgyNHkxeS91S0lNSzYyVUpYaTBwazl3bnZCRXRwbjNLNnlq?=
 =?utf-8?B?VGo1OFJpTjRiN0kwTWZhOFlIVllWdE04MHVkb0FSREVveGxoWHRyRnIvYldw?=
 =?utf-8?B?Ukw1OXlYUUxwdDNxSEQrd3MvTmUvRlk0WUxIZURrQ2lMNmR5U0lBdGJCeWp4?=
 =?utf-8?B?RkdqWGlmSE1lbFdDczlFTkNZRTFnc2x1TEQrRGwxOHdwUXpZKzBmRExiNXlD?=
 =?utf-8?B?ZlFXTU95a3JGK0xKOVR5Z0VRL0ozc1NLZHZiYTJHcGpXUXVBQ0NBbHdKcWRs?=
 =?utf-8?B?OVVSaTJIU2VwajlZSk55RnVEMGJ3cGFsWE83Y0J2R1crRHNLbEs1Rjhqc0ZV?=
 =?utf-8?B?VjJjTEFGd09aMERtaEczOW9VNWFpWkJiNDNyV080alBKQmhXdTNac0ZET0FN?=
 =?utf-8?B?WEFURmNJZVk1cUNBUC9DaWVhekJZMTFrM3VlTk90a0FYSFFjdzJnUXp3aGdG?=
 =?utf-8?B?bTJUWDRiUS9WNTB6ckljZXNmTmMvdVN6VitzbEFKUytaWERsaHZYWEVZYmJk?=
 =?utf-8?B?aE1GVWFEZENRd29Qa0R2TGV0VmhydkVMSTkvaXBPdjlVYmJpT1N3RWg2cHRI?=
 =?utf-8?B?d2ZwR3VKeDcrTmVKdlY5Z0lrcktDMmJjeWkvSEJmVnF6azk4V3lZUk9DQ1Zw?=
 =?utf-8?B?SG9oT3lyc1Y5YlF6ZFNNbVpNTlhPTzRIT04vdGg5L3hpWG43NXZqSDNzSXpz?=
 =?utf-8?B?TWh0Z0paV1k3aGFVY3RCdzFCbVBxRDV2MllYNmVFazN6VWt0NW9tZ09vbDlU?=
 =?utf-8?B?M0xjNHVxU0IrbEpVQVJMMElQYXJYNnRBZkhCZGk0bmJJNUNsSFBjYTROSENi?=
 =?utf-8?B?c0tENWs5Mk5VVGYxemRjTWxyT2FLWDBBaDF0SnhVdWcxakFLTWJqTDVRUkJD?=
 =?utf-8?B?Y3hkWEs3UkU0dGgyU2tYWUZZMUhlRlA1c3RmMmRUVExCdXhzdFNxcVp6Qytx?=
 =?utf-8?B?ZERRVUFjSnZDa2JweHZhVlA1ZnV4UkRSdjhUZU1lUGJzOFdKOENwODcwRXhC?=
 =?utf-8?B?TWNFLzU1S1E0SHJrUmdaanpueUpNMTlIRlN1dWNtQkFUMWMyeGs1OUFqbFRI?=
 =?utf-8?B?NG96K3JuNWxUUE9xRGMxRWczazJOK1J4aE1nR05oWHFZMnRremF1LzBKZXBL?=
 =?utf-8?B?OThITnVHTE1rM1R1Y1pFSGh6Q25sUGZrOXNVOGFKUWhydEs3VTJuaVQ2eUN3?=
 =?utf-8?B?NmZkZERramZLWHE0M21QbDU1NU1hTkk2WTArejI1S3UvVGc1N3NLbmpqTUQ4?=
 =?utf-8?B?S1ZmRzV4cjh0T3hYMGJzT2Eza2ZmOWdnamVMeGw1TlNRQmRpdGxId2syTXpr?=
 =?utf-8?B?MGwrdG1VS2VnejRjZkFZbjFlclVBTjVRODUvaVUwamlha0syRWxROS8wWlZh?=
 =?utf-8?B?YlVGYkJFSHdkcXhoNDI4OXk1WmJ5b25ydU9abHoxbXZZQ3lRM0RkWWRyZ3Zq?=
 =?utf-8?B?NmlodnhZYis0cmR0LzFwekhZYnM3V3AzQVpXQjRzMVROUmNhUExoNEJJNXpt?=
 =?utf-8?B?L2hoUEo1b0xzbHBwS1pOWnBIQ3E3eWMrT2djVE1ZeDJsQ3VkRWVmTWcrYWJL?=
 =?utf-8?Q?Jdd/7vhMDGgQIQ04uk?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: qD/3BGKbJvrG3WwY6VJ40RPVCTx4eSYyrHOBjJ2SOAon2Lq9yIdzOkS+m1ESLpqDAtVZ/AoNPEzj6vLvxtGiqpcehb94Gtl6aDG9Scg6RCge58paqZul5P03jL4w8xp32EjfKQNIj+yMVw9EVZiAwM6oHQB2EPI8E9w0cvdSSRtooDdZpa9pXKlqM/fY26bz93BaQU6PdPC0hTHIEfjdY8FOW0fJwVI3gijsZzfIXGNVMQ/F2bDZeNKXTPObvC/tfh/SsHj3YKiD1dP3+P1y9UcoIEcyF2vu+2R9nUYWtLOLuDogL0uPdosWG5yfMrQg95D9tZlkPkdrZGWzk+K1Sg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b317b599-8b22-4f43-638a-08dea0e6eb9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2026 03:17:58.8803
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ArEPDZfw6oCO8ey3Yk18Xqw+KJYGs+kh7uUWiW7nO4wRda8lnqyybjs3V6nedimV9lcr0tHMkOue0Y41MS5xWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7827
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 0F8F880008
X-Stat-Signature: rfahpe4abmo7hmmp4gbjozmgntr7wfgc
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776914285-110705
X-HE-Meta: U2FsdGVkX19P8sZ5WibAQH5UmGbDuW5fZNzX+cSf8rljn+nx1T4IsKSjwCcE4K5nM5yr+vXQVcen5QAvB+3nD0MBljbGQLTX+ArvH7k1WMA9Tb0P8pW+8PorI/aed/oSaCwa8+qGvEunlhMYDxX0FIDuYvTSRWsaPFKSiLWTheqjiX8EVph236fAPWLyhO0A8yKhZ7Zjf9y05BI6creNtgkT6k1wqUCEYwgQ/U2/W9ywjQkSNCD68rYjqI0/ZS2FaNW5WN9hTW/aus2g60l0KVXt3p/2sVex9AqacOAVpL1uMZUyw6HeRk0abbeOVzkW77Q9xvmpSwJOUND1mzUnVRCvTmZB1LbWLB3zVSDNmBWTO3vTbxbywMDqBMoGO+EHFkch8OaatPl9jqRNJv//Jtm98TgTwWaBc98lKCYupvXWMddYdSoe0tTE/7yhvLhMo42TekWiGdsNCix2+RU2omJCSUnY//DUYbmkKsGOiM1nwR4Yfflhml4eacFH8Pq1Pc7MD/VYd0xPa6NtCDiFqXw3hJxRQdB1IiGRNfYr9EEpacgF9JyYSn8iaxZEgrVF9Ae3pNfAc621VRFw3lL8NluTZd9IZr5PN8KpwQw2agZ3b6ewyhDJ+K7sorzctEYvdP84Tlrh1K36kAl1MzYZ/tjTUe4dmqk30q/dWnvhxQPovMmQ9nd7UeUHsOo7B0G4S3qjUcn8kAvbsf5mD3kjodvQm51DdJjMeqb3nxuPhUYMzqAwUU5VkeeJk9Ean+dyMdATjhZrl4reUP9vlhrB9XIBqogbjo7Ffa468BwTwxuViGl9bp/VuVZfN12GHqNF2Mf5As6MK+wXqXbQ9Eh6IbXK0aCVB1Ix1OcnqcZH6zjGEz9v92BwBwtvlDuQR1B5q2acaXbrlb9nmmgTLozP/anFFCwyives0Z4FIcpxaiS+FhbyyA2n/1+gPEgAb+Tp19Th5chRF5bUy52dKlY
 cJ6Uvw8A
 q357502Ropt2pC+6jWl4ouSb8DdeQKDZ2zDAKqnJ9HnJQrrPeUGv462vPsHnydBqqhrAVwx6uJ9a7PTA1gu2k7woNqg9sbRgJsLJk86sTdmDmHoFlNZDrnKRHd28IZrbisQygFPqcTCNejLDaT08Ha/+rDPT7zxWS99PS1yHLP/Q4Uld3/syDZwzhf+Upq1FdydsXpURfhaj9q85tdIF1r0hy+1/YozaMC8wQUjWFoOQnmsno8OXPT1IWD52qrDs1gixm3+iNyMjBhdPiYF52xaAwDxjtYNmhj6edT/+3gxl69pr9O4kLkdc2FpUSiIG7RAmPPxV8aSJ95DMOmbzTXxJTMu7IK45kim5sirBDk/kdmkpGEJSD258TpgL2Ladm4vEA33qek+Kipzc4CpVkxT8Zs44/VylUpfgpC1vjrIhmKxrZ8Cvtqsi95BBPJn4GGcmUEYSZ+xLy++I3BmHbFf8ExOob8jMcPZ0FI4JqNW93OB1X38hD4/Ggl1NDD081JYyK8FyjojOFPW+xTAzsyLJ9BOgdJ7m9H9oLXOubbn0xun/CkrXg266lEPr2e1R91s0gWbdraZOSsG3dpNWm62SiWRJYoYmAThdjO/er9fEJctGnAHyhLYaBJX7Ou10yR22mADN+/1borCasmdybRzFKNs0EFGSUTHsvClG0rTdxESg0RBgiCqj+jtubDDbGxO8oiHSAzmn8NN8vnSTqo2jU311lFDYwQ1nGqiWNozvpV9nndbLrh+vgyxbI9V+0GqchDSrBWzsc74X90lAzrb9PnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBIaWxkZW5icmFuZCAo
QXJtKSA8ZGF2aWRAa2VybmVsLm9yZz4NCj4gU2VudDogVGh1cnNkYXksIEFwcmlsIDIzLCAyMDI2
IDM6MTMgQU0NCj4gVG86IExpdSwgWXVhbjEgPHl1YW4xLmxpdUBpbnRlbC5jb20+OyBPc2NhciBT
YWx2YWRvciA8b3NhbHZhZG9yQHN1c2UuZGU+Ow0KPiBNaWtlIFJhcG9wb3J0IDxycHB0QGtlcm5l
bC5vcmc+OyBXZWkgWWFuZyA8cmljaGFyZC53ZWl5YW5nQGdtYWlsLmNvbT4NCj4gQ2M6IGxpbnV4
LW1tQGt2YWNrLm9yZzsgSHUsIFlvbmcgPHlvbmcuaHVAaW50ZWwuY29tPjsgWm91LCBOYW5oYWkN
Cj4gPG5hbmhhaS56b3VAaW50ZWwuY29tPjsgVGltIENoZW4gPHRpbS5jLmNoZW5AbGludXguaW50
ZWwuY29tPjsgWmh1bywgUWl1eHUNCj4gPHFpdXh1LnpodW9AaW50ZWwuY29tPjsgQ2hlbiwgWXUg
QyA8eXUuYy5jaGVuQGludGVsLmNvbT47IERlbmcsIFBhbg0KPiA8cGFuLmRlbmdAaW50ZWwuY29t
PjsgTGksIFRpYW55b3UgPHRpYW55b3UubGlAaW50ZWwuY29tPjsgQ2hlbiBaaGFuZw0KPiA8emhh
bmdjaGVuLmtpZGRAamQuY29tPjsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJq
ZWN0OiBSZTogW1BBVENIIHY0IDAvMl0gbW0vbWVtb3J5IGhvdHBsdWcvdW5wbHVnOiBPcHRpbWl6
ZSB6b25lDQo+IGNvbnRpZ3VvdXMgY2hlY2sgd2hlbiBjaGFuZ2luZyBwZm4gcmFuZ2UNCj4gDQo+
IE9uIDQvMjIvMjYgMDk6NTYsIExpdSwgWXVhbjEgd3JvdGU6DQo+ID4+IC0tLS0tT3JpZ2luYWwg
TWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IERhdmlkIEhpbGRlbmJyYW5kIChBcm0pIDxkYXZpZEBr
ZXJuZWwub3JnPg0KPiA+PiBTZW50OiBXZWRuZXNkYXksIEFwcmlsIDIyLCAyMDI2IDM6NDcgUE0N
Cj4gPj4gVG86IExpdSwgWXVhbjEgPHl1YW4xLmxpdUBpbnRlbC5jb20+OyBPc2NhciBTYWx2YWRv
cg0KPiA8b3NhbHZhZG9yQHN1c2UuZGU+Ow0KPiA+PiBNaWtlIFJhcG9wb3J0IDxycHB0QGtlcm5l
bC5vcmc+OyBXZWkgWWFuZyA8cmljaGFyZC53ZWl5YW5nQGdtYWlsLmNvbT4NCj4gPj4gQ2M6IGxp
bnV4LW1tQGt2YWNrLm9yZzsgSHUsIFlvbmcgPHlvbmcuaHVAaW50ZWwuY29tPjsgWm91LCBOYW5o
YWkNCj4gPj4gPG5hbmhhaS56b3VAaW50ZWwuY29tPjsgVGltIENoZW4gPHRpbS5jLmNoZW5AbGlu
dXguaW50ZWwuY29tPjsgWmh1bywNCj4gUWl1eHUNCj4gPj4gPHFpdXh1LnpodW9AaW50ZWwuY29t
PjsgQ2hlbiwgWXUgQyA8eXUuYy5jaGVuQGludGVsLmNvbT47IERlbmcsIFBhbg0KPiA+PiA8cGFu
LmRlbmdAaW50ZWwuY29tPjsgTGksIFRpYW55b3UgPHRpYW55b3UubGlAaW50ZWwuY29tPjsgQ2hl
biBaaGFuZw0KPiA+PiA8emhhbmdjaGVuLmtpZGRAamQuY29tPjsgbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZw0KPiA+PiBTdWJqZWN0OiBSZTogW1BBVENIIHY0IDAvMl0gbW0vbWVtb3J5IGhv
dHBsdWcvdW5wbHVnOiBPcHRpbWl6ZSB6b25lDQo+ID4+IGNvbnRpZ3VvdXMgY2hlY2sgd2hlbiBj
aGFuZ2luZyBwZm4gcmFuZ2UNCj4gPj4NCj4gPj4gT24gNC8yMS8yNiAxNDo1NSwgWXVhbiBMaXUg
d3JvdGU6DQo+ID4+PiBUaGlzIHNlcmllcyBjbGVhbnMgdXAgdGhlIG92ZXJsYXAgbWVtb3J5IG1h
cCBpbml0IGNoZWNrIGFuZA0KPiA+Pj4gb3B0aW1pemVzIHpvbmUgY29udGlndW91cyBjaGVjayB3
aGVuIGNoYW5naW5nIHBmbiByYW5nZS4NCj4gPj4+DQo+ID4+PiBJbiBhZGRpdGlvbiB0byBwcm92
aWRpbmcgYSBzaWduaWZpY2FudCBpbXByb3ZlbWVudCBmb3IgVk0gaG90cGx1Zw0KPiA+Pj4gKHNl
ZSB0aGUgc2Vjb25kIHBhdGNoIGZvciByZWZlcmVuY2UpLCBpdCBicmluZ3MgYmVuZWZpdHMgZm9y
IENYTA0KPiA+Pj4gaG90cGx1ZyBhcyB3ZWxsLiBUaGUgbGluayBpcyBhcyBmb2xsb3dzDQo+ID4+
PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNjA0MDkwMjM1NTIuR0EyODA3QEFFLw0K
PiA+Pj4NCj4gPj4+IHYzIGxpbms6DQo+ID4+PiAgICAgaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
YWxsLzIwMjYwNDA4MDMxNjE1LjE4MzE5MjItMS0NCj4gPj4geXVhbjEubGl1QGludGVsLmNvbS8N
Cj4gPj4+DQo+ID4+PiB2NCBjaGFuZ2VzOg0KPiA+Pj4gICAgIEFkZCBhIG5ldyBwYXRjaCBmb3Ig
Y2xlYW4gdXAgb3ZlcmxhcCBtZW1vcnkgbWFwIGluaXQgY2hlY2sNCj4gPj4NCj4gPj4gRGlkbid0
IHlvdSBhbHNvIHdhbnRlZCB0byBhZGQgYSBwYXRjaCB0byBpbXByb3ZlIHNocmlua196b25lX3Nw
YW4gdG8NCj4gY2hlY2sNCj4gPj4gYm90aA0KPiA+PiBzaWRlcyBvZiB0aGUgUEFHRVNfUEVSX1NV
QlNFQ1RJT04gYmxvY2sgZm9yIGZpdHRpbmcgbmlkK3ppZD8NCj4gPg0KPiA+IEhpIERhdmlkDQo+
ID4NCj4gPiBNeSBhcG9sb2dpZXMgZm9yIG1pc3NpbmcgdGhpcy4gSSB3aWxsIGluY2x1ZGUgaXQg
aW4gdGhlIG5leHQgdmVyc2lvbi4NCj4gDQo+IEFuZCBpc24ndCB0aGVyZSBhbHNvIHRoZSBwcm9i
bGVtIHdpdGggdGhlIHN1YnNlY3Rpb24gcGZuX3ZhbGlkKCkgaGFuZGxpbmcNCj4gZXRjDQo+IHdo
ZXJlIEkgcHJvcG9zZWQgYSBjaGFuZ2U/DQoNCkhpIERhdmlkDQoNClNvcnJ5IEkgZGlkbuKAmXQg
Y2F0Y2ggeW91ciBlYXJsaWVyIGRpc2N1c3Npb24gd2l0aCBXZWkgWWFuZy4gSeKAmXZlIGZvdW5k
IHlvdXIgDQpzdWdnZXN0aW9uIGFuZCBpbXBsZW1lbnRhdGlvbiwgYW5kIHdpbGwgc3BsaXQgdGhl
IHBmbl92YWxpZC9maXJzdF92YWxpZF9wZm4NCmNoYW5nZXMgaW50byBhIHNlcGFyYXRlIHBhdGNo
IGZvciB0aGUgbmV4dCB2ZXJzaW9uLg0KDQpGb3IgdGVzdGluZywgSSdsbCByZXByb2R1Y2UgV2Vp
IFlhbmcncyBzZXR1cCAobWVtYmxvY2tfcmVtb3ZlKCkgb2YgYQ0Kc3ViLXNlY3Rpb24gc2l6ZWQg
aG9sZSBpbnNpZGUgYW4gZWFybHkgc2VjdGlvbikgYW5kIGNvbmZpcm0gdGhhdA0Kem9uZSBjb250
aWd1b3VzIHN0YXlzIGF0IDAsIG1hdGNoaW5nIHRoZSBiZWhhdmlvdXIgYmVmb3JlIHRoaXMgc2Vy
aWVzLg0KDQpUaGFua3MgZm9yIHRoZSByZW1pbmRlciwgYW5kIHRoYW5rcyB0byBXZWkgZm9yIHRo
ZSBvcmlnaW5hbCByZXBvcnQuDQoNCj4gLS0NCj4gQ2hlZXJzLA0KPiANCj4gRGF2aWQNCg==

