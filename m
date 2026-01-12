Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58CA2CF45CD
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 21:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCC076B0095; Mon, 12 Jan 2026 16:25:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9FC06B0096; Mon, 12 Jan 2026 16:25:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5B8A6B0098; Mon, 12 Jan 2026 16:25:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9499C6B0095
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:25:00 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 18CF81AF1CB
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:25:00 +0000 (UTC)
X-FDA: 84324591960.25.AC4E033
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf04.hostedemail.com (Postfix) with ESMTP id F0C7440003
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:24:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Yg04wPJ1;
	spf=pass (imf04.hostedemail.com: domain of dan.j.williams@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768253096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FCNW7/Qf3nV0lDrOYgCFtv6+to7vwn9BQQaRg1GOqiM=;
	b=oI/mQ1kDLIJ+QuhkV1dBL9P6XyK8BGUBFn60GnOyJihpXJk2tVIBAKaOxc4rVDVzziRFh4
	km5kjZM8VmVTOb9t/6QMVSpXBHaed/+09hVPksEHawyJxqXY7z9q8n7wQ5yAbUz+rUfOhT
	ISQJLJjaC6hVUmIiwI63ubLESYRDHac=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Yg04wPJ1;
	spf=pass (imf04.hostedemail.com: domain of dan.j.williams@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768253096; a=rsa-sha256;
	cv=fail;
	b=npDJDvMpRDz1+pt1S161JoXXdhDnUVMi+e9if7nGub497EnBltBh7TeKJZyZEaZwtPlHOk
	c1P2GnkgvmFJ+2YBVr9K9DmFjqaZh53Xhw41o9cwqWETmwyL0xtZXL+puk+RRX5SWo/bYT
	4g/YAVPnBVm/gs9wjfRTFw8SL8f+a4s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768253096; x=1799789096;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=xsTo1XMwkDbG2vJvjEwGVtkjQPE1nPANwco2ayreoCs=;
  b=Yg04wPJ1Y+l1muBDyRzfMj8FfXe2MoHANoO8lXgL6m3NpM2M6Eku2whJ
   USNfmidFwcnN48A5S4EblDcTh5oot1FSHbh8IQOPtzrJjrNn73Jna/aP+
   zpk+aHiE1zHQ8b8Pq+uTSgm74bHv+cs3l00jJBSGRflCxotrhwPfHO4ze
   GG/Iu2VO1QA0dL34SJKOLLsdedZVf/1nbrNILf9w+/njfP50p0+90als6
   qtosZqSVcB5d5Bw2LsGT/fgHqLYnPEudYCWZoJq2MiRnBvsUwcFkzJ7HQ
   TeXnDW7BHvG33FvLNcYxVkvcJcwjDafmgkl9odidKi2fH1I7s7UwTgiYy
   g==;
X-CSE-ConnectionGUID: PznunW4aRtSSnGRZ/kj0LQ==
X-CSE-MsgGUID: H2DVMcgRT1SvG+8b0ziV4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="69433261"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="69433261"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 13:24:53 -0800
X-CSE-ConnectionGUID: gH+N+CxjTxaRjjq42lVH0w==
X-CSE-MsgGUID: NjMdhAFyQ8+4jCZmx2PXUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="203358857"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 13:24:54 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 13:24:53 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 12 Jan 2026 13:24:53 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.0) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 13:24:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kh7a2ZdT/6bvCvUhP+Jt5tsllaTFEe6UTVq/4hhVXMr7VMt4Lso04rzDxetcOwJ0UeMfnWk5JtR01AKSvEwmleOhsUrTRB/HSR/YJG0YNiDMb0J/2LJ5uc6AR8fet8zIpFws5nBTaSXxt1BMHuEtZLF20dUVa3B4v4naIn+EBO8PCdeBWuQDGKW6Curcs6QeXhFhxVhQ1qOmfX+4RLhKPVEuOHsOKKbeGlwiNafnVekE+zVORB+ogCUZUelqNNtGFt65YpLeVQpxiJz0VoA7gkkFMKp3s3cs6X4IxfDJDo+Q7lR/8ru3GoNdG08xk+hrqYojNGg30lbsIf9R3037hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FCNW7/Qf3nV0lDrOYgCFtv6+to7vwn9BQQaRg1GOqiM=;
 b=CwfnCEPf8Sq4DIRt3h4jPbgmtsbsdbWc4BsGTa6iQhhwSrEZItMxEUujUA5yQXwqcDvF5L4jr34Ps9MyWTtXMqaqdBDTQe3/2cGgS67cbi1EJeoSp4RaexXqByghE6kRshk6ZZWBWV+p36SI+GGwsSFzNCNIfyP0LQeQQ2O9ppGetdrGM4OPH62ePhR2hZG0p8pRC2IKe8qWSZR5t+BLhrdFI2AccXFvApClNY0sMFZnPwUn7U05OuL1H867UEICZmmdQI+uscdB5A6evoerBsH3pvH46oAj2zrOXrYuMSrVv55bmZ6W3/kGC1xNr1el6cpJJJ81CLN8jfxVsjTbQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH3PPF4324011F4.namprd11.prod.outlook.com (2603:10b6:518:1::d1a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 21:24:50 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 21:24:50 +0000
From: <dan.j.williams@intel.com>
Date: Mon, 12 Jan 2026 13:24:49 -0800
To: Yury Norov <ynorov@nvidia.com>, Gregory Price <gourry@gourry.net>
CC: Balbir Singh <balbirs@nvidia.com>, <linux-mm@kvack.org>,
	<cgroups@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <kernel-team@meta.com>,
	<longman@redhat.com>, <tj@kernel.org>, <hannes@cmpxchg.org>,
	<mkoutny@suse.com>, <corbet@lwn.net>, <gregkh@linuxfoundation.org>,
	<rafael@kernel.org>, <dakr@kernel.org>, <dave@stgolabs.net>,
	<jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>,
	<akpm@linux-foundation.org>, <vbabka@suse.cz>, <surenb@google.com>,
	<mhocko@suse.com>, <jackmanb@google.com>, <ziy@nvidia.com>,
	<david@kernel.org>, <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>,
	<rppt@kernel.org>, <axelrasmussen@google.com>, <yuanchu@google.com>,
	<weixugc@google.com>, <yury.norov@gmail.com>, <linux@rasmusvillemoes.dk>,
	<rientjes@google.com>, <shakeel.butt@linux.dev>, <chrisl@kernel.org>,
	<kasong@tencent.com>, <shikemeng@huaweicloud.com>, <nphamcs@gmail.com>,
	<bhe@redhat.com>, <baohua@kernel.org>, <yosry.ahmed@linux.dev>,
	<chengming.zhou@linux.dev>, <roman.gushchin@linux.dev>,
	<muchun.song@linux.dev>, <osalvador@suse.de>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<ying.huang@linux.alibaba.com>, <apopple@nvidia.com>, <cl@gentwo.org>,
	<harry.yoo@oracle.com>, <zhengqi.arch@bytedance.com>
Message-ID: <696566a1e228d_2071810076@dwillia2-mobl4.notmuch>
In-Reply-To: <aWUs8Fx2CG07F81e@yury>
References: <20260108203755.1163107-1-gourry@gourry.net>
 <6604d787-1744-4acf-80c0-e428fee1677e@nvidia.com>
 <aWUHAboKw28XepWr@gourry-fedora-PF4VCD3F>
 <aWUs8Fx2CG07F81e@yury>
Subject: Re: [RFC PATCH v3 0/8] mm,numa: N_PRIVATE node isolation for
 device-managed memory
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0382.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::27) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH3PPF4324011F4:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c77a6b2-a64c-4fbb-3b6b-08de522104d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZzlIZ0dsdG5rTUlHOFdTVlRWSmJ2Tnd1NUtWcGozWC9ONWFYOG1UcHJSYU1l?=
 =?utf-8?B?bTZ6UjNOUEh3clkyaUhldjc3bXpMdmRRbTJMd29ncTFBU2FYWDJiR1I2MmVk?=
 =?utf-8?B?WDFVRUtTVG03MUIzS1ZPRFZ3TVhQSy9LamE3a3QyZGF6eExRUlpXYWFmQXNT?=
 =?utf-8?B?d1ZWc3ZueFJJUmxWT1VFYkJmbnFzTkhpK3FCZm5rVzk3Yloremx4NHhHVU1t?=
 =?utf-8?B?MjBxczJLTFBnZUUwTHkxNVlKdGNieUVwVlNLZ3Fod0w5UmRKTGtDQkVSOUVi?=
 =?utf-8?B?eVBZdkxJRkx3dGtBRGNIWDFjUkxnMmxHNE1GSUVvUmxkaGpLZzJkTzNEbnQ3?=
 =?utf-8?B?eWxheGhUdGVGUjNtdkhmSE5rK3FsL0xuOGh3cVpUZnRTR2FLT3JtNnJ2R1o4?=
 =?utf-8?B?YTMxb0htenNIU0prbHVLdTh3N1BVKzdXVEJkTHpyTzNEcHVIRUJxY2w3QTFF?=
 =?utf-8?B?aFBhNkcxaTFOb3h0bHZaekExaENLbWw5TjlWRHVDWU56TnZidHpZVVBWeldI?=
 =?utf-8?B?M1lIVWFIY2ZyanprV1c3WHpHYm15eVR6RXcwNHplUnczbktnM1V2NUJIUnhV?=
 =?utf-8?B?OXR1V0hMc0x6RWZHRDhhZ04yazc4MzdEOUVDUmRnSkRPRnh0SXRxeFZRcnda?=
 =?utf-8?B?T3hUeVJoMXpqK3VXUEJDaC9aT0pwN2NvdFR5QjYxTGx6VHVHL3RKaFpLakQy?=
 =?utf-8?B?TytjRjJWWG1CaElQelBQTjE5N2xPWlBYT1FwQTFzVFRzckN6cXNjM0ZVejlt?=
 =?utf-8?B?SVJ3cFJLdkJnUGlTVHJvSWEvRVMvNTZHR2JjRlhNL0xnNXBvWWhNNk94ZXRW?=
 =?utf-8?B?NFB4NzRTOTJaTlpRZGZrenZjUkU1b1cwcmlQdm5hUVJnM216YTZ0bjhpanA0?=
 =?utf-8?B?emFLTDl6aUZlZjR5c1hRWUFHbmR0NDdZZXM1YlRFNXZJekZaZ3dkekltOURC?=
 =?utf-8?B?cUw5c24vOUVxT0VpQldlMXRpWlBJK0tkb0ZqRTVqNWZvaGw1S2pJYWNZeUFX?=
 =?utf-8?B?M0ZxMHBUamVsRWE0QUNsMEJnbnQxT3FYTDBnbGdPeVJQbGs1OU9GZGlJenRM?=
 =?utf-8?B?ZE9KckwybUJPWVlLME5GelhNeXAxeXN0akNhaVNhcGdUTU4xUXJNQWFPYVRN?=
 =?utf-8?B?emRYQ3RlVlp6b2VYN1NjR1gyN3NkdHJhL01zRkQ1NmUvNWNNbmdoRlhCaXpX?=
 =?utf-8?B?OStnSUxQRFhWUEl0M3c3YlYyRlE1R1hTNFJPQXZKL3NTaVdiK0RQNlV5MFg3?=
 =?utf-8?B?b3J0NWxBSkE2Q0cvOUx3ZGVPSDNPQlZ2cGc5bklrS3hveEdadUpaR29nc21w?=
 =?utf-8?B?TXpnQ3JQV3FjVWNYWGRrbmNQMVBMUXZ0T1pMeW5RSk1xYTNQWTAySXhZK1pj?=
 =?utf-8?B?VUZxUDZIVWFyNVZKMjhVS1Jzd1VLaWJ1MCtjRDBPOVlzZDBIUVpBVFdZSEQ0?=
 =?utf-8?B?dkNKbzZmcXVGWnAxaW5pY1BaZzg0T3VTc0xXbHlpSDU1N3ZFdDRNUU5BQ21R?=
 =?utf-8?B?SDdTVWs0Y1RTQmNub21YNTZmdk45WGp0eEEyeFY1YWRvNWEweUtMY3RkQURn?=
 =?utf-8?B?SG5qaGVhb3QxSk5LRjRPaWZvT2FoRHRaZlNzTjdvU0NDU2cxbXRSRFM2R2Q5?=
 =?utf-8?B?SzFSSnhwb0dDTmZCM0QvRXhLdXgxRmRGT1RBZjA4K0RMNDdvMzB6VWJUdDQ5?=
 =?utf-8?B?akFkbUpoWE4rV2hBYjYyV2xNejZSc2FwTnlybE1GUmZ2WHpZYTN1ZUhON05D?=
 =?utf-8?B?Nmlsa3F0eEw5VWg3dEljRFpIQ2pkbkRLZE9DUTNDRnNCTGRBL2c1RFBNMGc2?=
 =?utf-8?B?dmgrY3N3TU9RYVZNaDQwRjVjeFhWT3ZRdUpoak9TNmJub3kvUWNiSjZNbnVU?=
 =?utf-8?B?OXNRdHVDZnhjZUVqYkdPL252aXUvaDJkUHYvRk5CK1RmVTR0d1lNZ0Fsb2lK?=
 =?utf-8?Q?mYEOEqq0QyJdjumQnw/A5LCcp6Hs70RC?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUozVUwrVG1Qa0JXb0h6dldkdkJIRWE1enpnVER1TWtQNnFPR2l4U0U4STB2?=
 =?utf-8?B?dVVnaCtVVDhrdUVVMlZrQm9OakV6ZkpGQXREMFBJWHVBUjBMRWZBRW10c00v?=
 =?utf-8?B?aVRlcEFMaXcveUF5Q0VJWGVhY2RGa1l0NEVmVUFxV2RvRy9oMGpyRzR4T1I4?=
 =?utf-8?B?U09JMWFKNG95Vi9yU0JkSkw4QjhCMk9Vdy9tS0l5ZVNYTHNxNElvSUppeG03?=
 =?utf-8?B?dEptVGxlMHpGczdJdGZSNTZQM2J0SWZ6MUpFOVZhdE1LREtCYU1GMHJaL0cw?=
 =?utf-8?B?WU9ob3g3SUpSeU54MHVvRW1Ddy93VnRoWHl6S3MwdElxQzZUdEJXSFNLQ05E?=
 =?utf-8?B?S045aWI0MUNGRDJTWGp0d1VnbEF3N0Q0OXV2a3A2a1NSeWxpWlhSOFI3UXZ2?=
 =?utf-8?B?enZwb3VUQzhNOVhxRHBueHNXYzlpRm11NUpyc2dQV0JhWFphZ29Yem5WejZq?=
 =?utf-8?B?V1pJUEJWd2VNNm1Cem03VVRlTHBiSWNMMWRaSWZjbkN3M1NTd3EyM1h5NEZG?=
 =?utf-8?B?c2h2ejNGa0hIVEwzMUdabzl0NE9USDFOelJ2d05pb0ZPd2cwR0t1SEM1K1Ux?=
 =?utf-8?B?dDZrS0c2aHhMdXhOdEE2WmU1Um5xSnJEazUvMzIwRW4vcEFUeUgxZEp0blZZ?=
 =?utf-8?B?LzZPS0wxaENrc3lkb1JWODZyeVVSajVuV3QvRklkaGpnRmZOZHRodkxpOHNR?=
 =?utf-8?B?RUJhZjJ5cXRiOE9sb0lLcU9ZUDhLdjRQSXYzYkcvS09Ub3dUZkZINXZCcnpq?=
 =?utf-8?B?Q292TEhwSS83b3BuNlJ0b2VKemhqN0xVSkFYM3FzcFpLSXc4T0N0MFFSbUpV?=
 =?utf-8?B?djRxVHNTM25EUVBuc2VCZG90NnNjRVdjWUkrYXF2ODZVL3NwVG42akNnaG1n?=
 =?utf-8?B?WitwSStqNDl5YzBSUzRhOHQwWlZJMkltQ0VkVnNiTjRpRi9JL3dCWnlZaWor?=
 =?utf-8?B?QlhBYVZSZ0pYa0o1dUE2dGk0d0JZb0RzaGlXdk1CMGtEQzg1U3NKRHczYjRy?=
 =?utf-8?B?MXIxQ0Y5bURmRGprcEl1R3p2TUJHNjNUSGZmSHFtOWhWTUNUWktBaHd5Um1Q?=
 =?utf-8?B?M1dqb2RzbWFSaVpYRDR4VmVGVjlmcEhHTktUa25HWlV3Z3AyckRmUHhrMWt3?=
 =?utf-8?B?Y2dqc29PUHZVNTh5alFiTnV5QXdEdzZrSXh0a1JQYXExWXhCL0JiL0x4eHpX?=
 =?utf-8?B?RGhpL1pwYjd3di9iUnNHTkJIS0tBSXh2R3dBcUh5bnhtVmVWbmNrdHM3ck5o?=
 =?utf-8?B?eEVjMzMra3h5NXRWTHFteTRKeWdYUmtWZzM5eVRHeW1pK1ZoVEd5VTViM0Q0?=
 =?utf-8?B?SWR6RmlTQ0dyekJua05WOUlhaW5VRkRCSXN1Q2trRW16RG51YnVvMWVrdzg5?=
 =?utf-8?B?ZlFFZVVsL1kzMyt1NE5GcjVSVU1waCtBM3NPdTZEeS9Ua3NZUlpMMGdZZFBL?=
 =?utf-8?B?dUN6bFdLNFpJU1o3ODN1WWxUOFFGTDJXT01iNmZQRnR1TnQ1NStYUGRpTkl6?=
 =?utf-8?B?TnJHS0ZrZkFFeWIzbllzbjRxK0FBcnl1dVdtNTViUUU5STBkT3hkMkJJelFK?=
 =?utf-8?B?RDMyRnRKT1VxQ0picWF3S0lKcktRcHRKYkNsckJ2bDlzQzJKY2RxK0tqK3lD?=
 =?utf-8?B?OTNGeW1QZmJSbTJMa0dnQVhvMFE3Z0lWNjJ2blo4S2N0SE1lSVBZYjdIZmNx?=
 =?utf-8?B?NytOaU9pVStUY0dzUWxycHZFeHlJWEFUbHVjSjhxdTcyL1J3QnY3VGp0VEM5?=
 =?utf-8?B?Q2lDOFBRaUNoREZiNnZKNWh1dTAzWVJ2MFgyRmZNUWFmcXhubWJTcjUzaks3?=
 =?utf-8?B?b2NPbVBtdWJXZ0NXU0pBR1lGUzcrNlBML2RKYVpCVU9ndWp6aDY1M0Q0bjVE?=
 =?utf-8?B?VjdPRHM0N0tMY2UwakI5WTlYb0hvUU92OHNJeDFoTmttN2thU3htUzlLckNL?=
 =?utf-8?B?U3pkbDFsS1NxQkpKNGhWNzVKSGl0Y0c4RkVwNkV0UTdwckJTTVV6WXhuUzE1?=
 =?utf-8?B?ekdENitGNnF4UUVWSWtZOWdJTWhlNDZSbVNJQzUvZjVGcnp4Y0NIRmFxVEgy?=
 =?utf-8?B?OXlmdE1DVGV2OFUrVktZbk4vTXdrMmgzSDFIa3VPOUp2a0UyT1hJS0VhTy9x?=
 =?utf-8?B?Wmc5U1VIYVVzODRXTklEc0I3eG13ckduTjdxT1RIR0gvNWFVT0l4c3h4TDdE?=
 =?utf-8?B?dk1kRDFGOGtOc2hnYkl3aU1JRVlyVjB3dmJRRGt0NHgvVmhLUUtxbkRtdVlF?=
 =?utf-8?B?VEsvUk16N0krUkJobVJrN1BHTXlSZDZtWEIxMDY0UE92cTkzMDNZa2NnT20y?=
 =?utf-8?B?NWIwdDc1bW1TczZEUHFFd1NScXRrMzlUTzd6enMvTThXb2N6U0hXYkhISEVO?=
 =?utf-8?Q?u217Rk3tOxm7q4y4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c77a6b2-a64c-4fbb-3b6b-08de522104d9
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 21:24:50.5030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9yYxqcE3AOK61LKVnzZn4gBnNUleJiWI0ZEXZRdj9ABg4slJropc+Mh+Y4ueQBaogbPZMJQnNlKGpKrksapnLB4S66DM3oy8y8lTwBTOlc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF4324011F4
X-OriginatorOrg: intel.com
X-Stat-Signature: i5811wah6gxqw48zxju9yw5wm538bpdx
X-Rspamd-Queue-Id: F0C7440003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768253095-757857
X-HE-Meta: U2FsdGVkX18unHzstpOfI8NB9aLuux/KqlxzJQjRkXFpmc2zlAiFVvr1ah2gdTG3h0HsbeceiLDlrxzl6BzMKQHirC8YZw43mfTlggN6xWNAcxcaJmf9kBE2/pp7yyhj7lgAUelGKuyO63vX3r+la9tZpPmTZfTnYbStUsVv3oCNya8f6wOf2JtpjMFa1md+bH5o4EViA/Dcg7vanWiFClBRzZg/tEGK6Ij/MhFWpqstnX/JOZYDpqRR2rLCi1HjA3CslwogdUtnYKkZZ1knIaeB671pSRtjwd9/KJpIqpKAnuhpg1tPk59roP01KK7YAwXy4Xx9pGzMCUQoA4UzCMyqS+txI9dgnZoyDZSaUQk0iV8NTMYcoP88LjNEEPqF3+vl4pqM7+DSviTGChLyKExputCsRYsm0AhhftVbZNFfnHIPkKv+jlciBVvhxaeqFPsITuad2YDnHTDNEyabJuxzTxG3r28IOUDrEBH/iFk4kc52lC2DcZX8iTSVtNMKkuQOwxXP/HI4YLKS5pO+jjqi34GzGETAJ83TDgdGD6SFKRUsA1W/nrVxcqfM4Mj6v1M/2UHf7IDCFl5Vnu2pr8DxG1jkZw1JqGUG7lXQfW2ruM/tczXzcoHMOLT6qSINNENal95+t1dtQmLrvboEUnrpLE9arbZFsOz9Iex3+FLMv0Md3sFtfdscqI0CTVji4pXd27o3AD9fqGkiuh9i92B2UPrAcYjp6hOSN4SibD87qWvLAC2+pUwLqKSRCQZUKL+mlPLXM8GR6p2SLFja+I2WM0R2Wyep+JNDjrym7mD7UrhZfni4TjF5wyDfX/6IGkQ+OzMrp72sf795j8yeGWNWlciGoDmZzgqj4Z0P/s9Rl1SHQHH7NXYzfNsTnLo9khUr4wSM1VAgt1rhzJsO+adJxkPHDZkc372jaUyGkBw59mgeAgDPcE69B6BnqB/ErCFRXKSbR3nWI2Xc84N
 srGXYrGi
 KfGYudUBU38lOfovkllbRqUA3yoAR7nWrKjS6HTs7FZMz+fPoCaNeU2z4/4taXQallmPvYxRmKnpT99hIImXrwlb0Fe7avFQgdqEoLcO1uFEV3yypl/1vhSHFtjR5GjAEHkvHp2Wooi4km3bJ+mTuXYLjWuVI7CN8z+izxNouhhG0B5y1PB1zIm3BUuj9n5s5aVceKrZw/W5jwrOa3l/6CyhyJ6ouvVAyI6xPeGK8bIPiwNsth+1pVTPapD6SW+VZcEcnjN5igt+2CjXbKR0a87D1HQVwveAPHAKQOdBwKPh50Awhzsmth+wUlC2zrqFAT1rso6/Xv9MzHyOSW1qJlTjcL7raEh3nWtlTmuOfqYV6wVKHFd4QRaXdlZdHhqnKxPSehlcvzTJShGIoJsnm+HspBT/CryCu51999occjGPW8oNgP1MNRCDr4/uykb0d1NJhLZRey4NXgNBI9DQ9vsUsLI8q9jIw0kdL/DV88l/gdpB4Pdf5eRqTQtGqSQ1KwILnr2nzXNYuKZdwBkkd+SP6woNHq+3boVW/zixpulTVP5c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yury Norov wrote:
[..]
> > Dan Williams convinced me to go with N_PRIVATE, but this is really a
> > bikeshed topic
> 
> No it's not. To me (OK, an almost random reader in this discussion),
> N_PRIVATE is a pretty confusing name. It doesn't answer the question:
> private what? N_PRIVATE_MEMORY is better in that department, isn't?
> 
> But taking into account isolcpus, maybe N_ISOLMEM?
> 
> > - we could call it N_BOBERT until we find consensus.
> 
> Please give it the right name well describing the scope and purpose of
> the new restriction policy before moving forward.

...this is the definition of a bikeshed discussion, and bikeshed's are
important for building consensus. The argument for N_PRIVATE is with
respect to looking at this from the perspective of the other node_states
that do not have the _MEMORY designation particularly _ONLINE and the
fact that the other _MEMORY states implied zone implications whereas
N_PRIVATE can span zones.

I agree with Gregory the name does not matter as much as the
documentation explaining what the name means. I am ok if others do not
sign onto the rationale for why not include _MEMORY, but lets capture
something that tries to clarify that this is a unique node state that
can have "all of the above" memory types relative to the existing
_MEMORY states.

