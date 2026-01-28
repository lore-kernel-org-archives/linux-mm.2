Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96272D3F06D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 14:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE2786B00AF; Wed, 28 Jan 2026 09:17:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8F726B00B2; Wed, 28 Jan 2026 09:17:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3CCB6B00B4; Wed, 28 Jan 2026 09:17:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B22C76B00AF
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:17:15 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3999B1B0BE6
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:17:15 +0000 (UTC)
X-FDA: 84381574830.16.44AE691
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6263640013
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:17:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KdH7lw8R;
	spf=pass (imf07.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769609831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=phqoFRyr1n7Yg3oidaEx8ksG77duudVM2RzFRMWmyvA=;
	b=cjj8wO8MjCQyJ8TIu2ETw9G/j4JHvWkdTiFPL+XkEhxLPVJDuCIRtW2oKQlVT97SlQ7gKh
	oaivrIyW/QA/STrxmjmcP+u1kMIkI4wNSVv3WVk0x4/vcElEudOtZypNxIfuWKj2QC1wjQ
	kVpvowbkVVzWszum3dmdJ+JAuNg8Dkc=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KdH7lw8R;
	spf=pass (imf07.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769609831; a=rsa-sha256;
	cv=fail;
	b=X5hDtZEyu3/jZsHCzG1NP2CzWYYm2AgQpyHE0WraoOoGg4s4o3gvMwr9iLAgARcAVTbcR6
	Mbqo+lcHkHpUrhXzGp9x7Usky+ewdIs4AM7qDvjoqJS6jaI34UvODIATb42I5yRxNNsQNe
	6VaLOmJEszIEG1jq1b6oklxmeUDUt1g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769609832; x=1801145832;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3C6ROLDFS7zKM0nOD0j8tX5oFT9yrq6xQ8mmXyVMo48=;
  b=KdH7lw8RkcKQ3XhZnUyLqUi1Wkuxm65xcLrOjAMcLDckN30S59D57W2e
   TCfcBIBVjtBRLaxblr5xBbKRlvYR8N5T6ZhYBoufU2s+qfkqD0BZCdth5
   mrF4tPJKM9fBSL3MbeCyvtweWI7Y+Qyg8KUTjYRmq4pjqmhobR2bBQ1u1
   /PL5dQrxhbICJ13VRLww1tZzeCFR9ZP63HOLVzOFqtiwBi8iMXEjaDeoo
   zWnPWdGFiM4yZeqHbg2hqDdnuG+4NsZGrA02Buj1OpAyr7geYnE+Nlmiw
   LLSCNqRIrujSRGivrVNwiBlRBt2oqEjdzPn9kZ1xCoRmPJ2IL35FlDnaa
   Q==;
X-CSE-ConnectionGUID: aYXAJTDuS7WLvc3otbJZzQ==
X-CSE-MsgGUID: AQxuhrEpTUmToKJlt4eWfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="81453644"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="81453644"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 06:17:10 -0800
X-CSE-ConnectionGUID: IR4hU/y3QkK6euirq1sYRA==
X-CSE-MsgGUID: 4a/0E3mCS1iOOGIyrzepQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="208715983"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 06:17:09 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 06:17:08 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 28 Jan 2026 06:17:08 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.5) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 06:17:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JpeWtKt12/4fL5gw2WYJcr79qOPbFy6ch4b7c0L4f/Qjvzi6OJfqwuVqCiHy1VponI7y2QMDsvaeY6g1ArDNqtQO6i1E2eYLwtnJhXOrr/shUpxcYiVB1cxh1oDKdeGADgJybwaKFfa3pusnUyqN8ss7ZaQRxHKPvqsqT6uU+PWOXIm2dYRnYHI37piRquu5WUiUZZ8+LVrfy0Vfymlgd0daMKSVFnlv7YrmbxADvkzV968pnPl66mGzEmIN0dBo9zKtLJg6FkdLaNNGkJun2OaXmO27WlQNGdvcnEg/ljZcgr3Efi/0eugWuGM2yPMA/a491w1OkE5EEgF5HJI5Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phqoFRyr1n7Yg3oidaEx8ksG77duudVM2RzFRMWmyvA=;
 b=bIrXg1nlNhFwz5bkLc2u/oDheu3mp0RTfTI0Q9HIRScP9G5gHok/7QHo0PKq3VfofB+6IcEJKm44pWQFwQEPUxIJJzRDG3vr9yW2o7PHj541s7w2af6uJNTB2Z8J6XZqu/Ko12tDcrIwjsV4sRjVkkiX86Jg2jAx2NUj49zr6FKbIi6G8mqR9mxdL4EuMYiXBhA5nxKrEoOXslUgEIagiBYedkvr0hczDOgw01XozE5ZxqBp75RAl+w78UKk5H8wW7MIa1rSdgf9cfm/e9NVAHld38LP4QXNrR69chFXQ+f8vOR+iXTtFJElLBEiMq8KtrfE6ugLEaNETbvnr7IzBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by DS7PR11MB6127.namprd11.prod.outlook.com (2603:10b6:8:9d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 14:16:59 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1%3]) with mapi id 15.20.9542.010; Wed, 28 Jan 2026
 14:16:59 +0000
Message-ID: <cc1202c6-4791-4206-ac9b-c283652a7f55@intel.com>
Date: Wed, 28 Jan 2026 22:16:50 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/3] mm/memory hotplug: Fix zone->contiguous always
 false when hotplug
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
	Michal Hocko <mhocko@suse.com>, <linux-mm@kvack.org>, Yong Hu
	<yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu
	<yuan1.liu@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo
	<qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>, Pan Deng
	<pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	<linux-kernel@vger.kernel.org>
References: <20260120143346.1427837-1-tianyou.li@intel.com>
 <20260120143346.1427837-2-tianyou.li@intel.com> <aXIHG8MQhMRt7M5d@kernel.org>
 <804139fd-e210-4387-9a63-ac76f4df66c7@intel.com>
 <20260126135849.a32235e3f326b45642f02b2d@linux-foundation.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <20260126135849.a32235e3f326b45642f02b2d@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0015.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::21) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|DS7PR11MB6127:EE_
X-MS-Office365-Filtering-Correlation-Id: c38ed3c2-b62b-4f81-6c2e-08de5e77e65f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZnVXT1FUZUl2VHhXUy94a0dPc3RiM0ZlcDl5MHREQk1HNDNiNDNjeWFhaFhS?=
 =?utf-8?B?dEhTTS9DQ0lVaTRzc084K1I2N0FaRnVjTGtXMFZMZUFMTk41cjhyWTB2cEM5?=
 =?utf-8?B?WjlxSldqMXhFVXRXM2kva2t5Z3dCcTBOT3pvSnVPL3F2M0lNb1JYSTFXWWdW?=
 =?utf-8?B?N2tvWmxUTmd2ck5JNklnWVFZbWQwQ253REZKdS9NMGVWMEZYYi9HN25DWG1p?=
 =?utf-8?B?RWZOandnNFhjeEkxeVIwdG5JQmtWdzdnRUxMSGp4WWtsckZldmZUM0tPcmtU?=
 =?utf-8?B?NXd2MDF5R0NOb09YOC96V0I5bENJRHVidmM0NE5iWEFWYm80MkI3bGdOTmJz?=
 =?utf-8?B?Tkl4U0h5TTdKNkd6QmoyemZKUHRRNVNzYmQrY2V5em9CNUNrWGpTVzJvV2hn?=
 =?utf-8?B?VnJKRWJNT2lTSDU4c2VMaGkxOG4vWVZqek5maHhoa0NtNUNYak40NHYrbVBW?=
 =?utf-8?B?YmVXWXpTdWJWMHU5ZmtPUzc5WkRoUnltNjRob2IwbXZNYzYrVlhQbkx5cVVl?=
 =?utf-8?B?OEFJeHBqeEJsU2Q4Vm8wOWc4dW1EUW9tKyt6ME1CSDRtY2hqNWQrTEpCbW1l?=
 =?utf-8?B?emxpRXhwb2pTRUVUWDRaeFFxVStSQitQSHFDVXllcGtGMVFTYVdiM0wrZ1pi?=
 =?utf-8?B?VFA4NDJGYSs4TnpxNWROQkwyRldIQ09uRi9WTWxYR3NBVjlIWGt2aFNZcTRs?=
 =?utf-8?B?b1p6QzF0c3Z0WWVTazFGMldmYlhnQlFsZ1JxelpjcUpIczIvaDg0UlhsUDdP?=
 =?utf-8?B?YVdqU0N6ZDh6WWlucVdUNEhVUnN5R3MwejZkNDNETTl4MjNwRG9qZjF0azAz?=
 =?utf-8?B?N1Vyb25COHBFZ29LWGtWZTBVWXJzUHlpYjg3eU14OWgzV090Z0JGRzV0c05Q?=
 =?utf-8?B?aW01czZoM3ViREQ1ZjVlUHdySmZhZ2d0Z1hYc0xra2dURUFZc3dFRXgwNk9L?=
 =?utf-8?B?S25ndHQ4dndUak1EQnFuRG5TUnVEaE9iS29zbW5lcTJhTW1LUFlCMWxQUEpw?=
 =?utf-8?B?eVNyRmFjL3NsNlNrSFBtZXN3MlZQUEJ4OG5zZnhVblNZUjZzQ1AzdjdWeG1Q?=
 =?utf-8?B?eVVzT05Gd2RRamRCb1dtaHl6VHJRdlM0ZDc0R0pHNVpmb3MwdGE3bW1nbFpm?=
 =?utf-8?B?dEVSKzVoZmNtdi8zM0o4L2s5ZlNjcVdyRDlId1dieHRnZVI5RWJaWWY0aU9l?=
 =?utf-8?B?cXorVkk5WkdIWUZyT1hHWFYxZlMyZG5QbWpGa1U0cG5OT01GWDU4WlVaekJp?=
 =?utf-8?B?ckJsNHEyV3JXWU5YRkFaOU13ZDlyN3JydmEzTjNyb296cjVnaVpKNTA1bmtP?=
 =?utf-8?B?QkMxdTJCS2ZCQjVidGV0VU92Y2lXNmhrb2hCUG1CbzA2K2hQVnhHdUtjWjZ4?=
 =?utf-8?B?Nkh1bGtLM0pnTzYwV2lnMUd2bUZmTW13WU1lMDFraVJuMVhDV2tIMWpsUEZV?=
 =?utf-8?B?VjhMQm81UlU1YWY2NVdVeDZTTUNiYUowWXZMdWk5dDRFQnFJZnpqL0lTWXBh?=
 =?utf-8?B?Nkd3RXpvK0ZRSi8rU0JRMlQrWmM4MjlzelREOFpsbjNSYTVmREFNdmJrd3hi?=
 =?utf-8?B?cVpsN2VrY2tGdGJ3Z2ozQ2NMdDNhSjVuOXh1ckxmZDRsb0hDaUJvdnNadGgr?=
 =?utf-8?B?WlBkRUNCdzBMMEt4emdZOFBpQ0pjbThhaFFtSGgxQVJRRWZqQm9TdjdqVU50?=
 =?utf-8?B?UzY3NWUxTkFKZkhxT1gxQW1VQ2c0TVdpblM3aUZ3eERaZ2hoMkl6MkhhREN5?=
 =?utf-8?B?MUVLd0FSb1Vua2JqNCtIMllQV2JuY1JtVGgyR0pCU1RENHczZnVGMTFSSjd0?=
 =?utf-8?B?L25TbzR1RE1KQkxVZlIwQmJCS0NzaFI0aDFvclhJTkpNdjRDN0RBY25QNXlk?=
 =?utf-8?B?eUFVc0hCMis2T2orSjR2M1lqK0J6enhFRkMwbUhLR3prcWlEQ3hUVWNxR0tF?=
 =?utf-8?B?dkxSS0RiYkMzYUdzMFkvcUxxYlVTZzdRaEZzWGpjSlk1L3hScUlUK053S3Bt?=
 =?utf-8?B?a0V1bmpnUHNOTkJ6NS9oRlA4SlVNcFNOdGd0eHpKNnFVY1U4VTZvWXNkMGdV?=
 =?utf-8?B?L21oOUtXdldobzNUVU5TeHZuMG9ya3FLM3JqUmk4OVhyRmpFT0R3RkJSTStn?=
 =?utf-8?Q?BSd0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDZUTFJNWkZpNENEZXJnUEQ0UG9USFZGQnVJVGtsNU9uM3ZSTUtHMWZGWVEw?=
 =?utf-8?B?MFFhcC9iU3UvdURuWDNheXR2ckxncTY5ZnZYdWovRm5uSHpHSk9BV3FGOXIr?=
 =?utf-8?B?anR4eXJrbXFDT3ZMdFR6bmM4SjdmWHRKSmk5T0taVVN1UXBmUXkyOTVXWjVy?=
 =?utf-8?B?TE81ZlhHNlVrUHl2SGU4bVdzUXpSZHVvY3N5N3djUzhkcjFXdk44Q0l3d1Bk?=
 =?utf-8?B?WGNjQi90Q2V0Q1lCd2pJOWNnMGNPK3NqZjViMjRjMFZ0ekNmMnJsTUdjaE9O?=
 =?utf-8?B?OFVwVnkvbTloNjA4dlVZbDJSc0JSanNaaHRMRGlLd0hxZmNVV3ZncGo4dDJC?=
 =?utf-8?B?M2FqRFNIdEN0SmJyTlMzZi9BL21ONkJKMWdoOGdUa2N2NTVwTEpYbFgyVWlL?=
 =?utf-8?B?M1VUOUp1Vzd3aUJNNDQwTGFHMElQZlQwTEVIRGNlcHp3dDBFWnNQZEpvbTdm?=
 =?utf-8?B?M3VoMC90Q25NNTk1b2RvYnJrL3R4RDFhY0tyUnFVd2Nua0ZWSWtVcktCRm4r?=
 =?utf-8?B?aUNaUEtVTmJESCtIVWl5MVRYc09DTjdBTjJveGlQMTN5R0RYYTBnb2FrU3FK?=
 =?utf-8?B?ZDk2TWo4Wm5DRVN2ZHBqdkt6WHBkRExyaWRwNFBQeGxCWlBjUCsxSE9oSkd5?=
 =?utf-8?B?R3NhZElObjBsUlhWaXpsT3hQbkM2QWJPWXlVd3h1MjRFdExMSE8wVllmcVlp?=
 =?utf-8?B?NGZ3eTB1T0h3SlNZM0tpVGNEMEdxbnp2VnVMSmpKUjVGZitQQVg1aFFjSGJB?=
 =?utf-8?B?YVhBNG1aMUJmaC9OTUpSRXVSUVBzOXBDUjdYNXowQjUreldyNE5BamZhODIz?=
 =?utf-8?B?Zk5VdnBQbWpZYmIrYitGVGJabC9Fc0d5NUtPY3NQNU9KVVVUS29nek9MNkZE?=
 =?utf-8?B?c2RjeDgvNjk0dFVpTHpid25hVTRla2IyY2hwS0NnTThZSE1PN3FURVYwTVQr?=
 =?utf-8?B?V2dRNUowbVVwZFJvTUFINldLbCt0WmdVL2IwMEJDZ1dmRmJkNkZGR3JCQVVZ?=
 =?utf-8?B?UFBiT0VhdDluUTRrdlJITGJwcjcwTlY2SG9IeVEyRUEyQkFKMGwxbGFWaGl3?=
 =?utf-8?B?b2dKaFdqRDUzWE5SNkIvU0s0Vjd3NzFZN3N1Y3pNMThkY1pCUERLRkFTa1F1?=
 =?utf-8?B?YXM5WnRFOG9DT2lCV3FTTHd2dWFCa0dLbnRNRG8wN1FmbkIvMGd4THJQdGRL?=
 =?utf-8?B?cVRRY2QyWU55dWFvdkJBUG1yWXNhWlpvOURpdnFQckk5SjNWUDVndkkxUzQ0?=
 =?utf-8?B?MEozb3pETm42d3RoRkh1WXdhTW5Xak1wY3UwZXFZM3k4RTcyVkIzc0FTWGVz?=
 =?utf-8?B?elNQOTl1bzY2VGllT3dBWnc1eHNnclpoK3JrSTNDSGthZEF6emlaRlZSaTAv?=
 =?utf-8?B?WWdORmZ4Q0JJV2pNZXhpNzhlNE1SV0xPeGZxVERrcXJLMEkySHJTM3orT25W?=
 =?utf-8?B?RExoTWVFUm9abHA2SEQxLzJ2dSs0WnZOMU9PMDNXNVE5WTY4Zk5PNEFZSEFM?=
 =?utf-8?B?UXhpbzJwRXFhQ0hrcUs3bW5iT1hYUUpVZDFnK0ZPRTVhVDhUQWt2ZXNnVzN3?=
 =?utf-8?B?S2hWdS9lK3hpcU5PektYOE9QSE9uSmR4RTJhbUdaTkg2UCtJdEtMODNZNlVD?=
 =?utf-8?B?VitSWUhSWWJsZkN2czRlaTNBS2p0QUVtRHFGYStlWWtWYysrWVAzdkRONWhl?=
 =?utf-8?B?U3p6cXRmQ1ZBQXliMjFUR0lzZTJCcGpYL0JSNkJEdzBJQUlUN3VSTEFreVh3?=
 =?utf-8?B?bllLbUNGS1RlZG52Z1pxRWpGcGpiNmhJazluLzZFcjRtWVNrVG9DUVo4MnlE?=
 =?utf-8?B?aTMxVGhwM0FQK2RSQ1VqTzhxTUJFdEpyVlRDLzJZZ3NtQ2xEeDJ1NUFjd3VS?=
 =?utf-8?B?TWU2TXR3UUZMbVAvMmtqbmlLcUt1NDQ1WXhzdERLa29vY3RsZTYxTlcyQjdh?=
 =?utf-8?B?b1ZjcW13ZGJVeFpBNHg4ZUI2ajMrVVNNUE5Kc2g3ajI4aGk1TkorVGNkS3R4?=
 =?utf-8?B?d011ZHZCeEZYVmNyR29VaEpiNk1yTVB1TiszNUtUMVVMYXBtT3c2YVlIK2ZI?=
 =?utf-8?B?ZlNCU0IxVGZDTkF5cThGZ3JGc0NVZDN6UnlUWjdHMCtGMnloWWowclhob09v?=
 =?utf-8?B?ZjFOUXJkQWNzSmNXUnUvbkdKUmhNRzMrZ2NSYW0xcFVZQjJoSFJRV2dSY01E?=
 =?utf-8?B?REVmVGJEMGwrUTlQOUFXVXFBdmhrSW5Sb1crTXQrVGdnYkhRMnNwVk83cjBz?=
 =?utf-8?B?MlNiUWx5SWsrM1FZelJoSmQzUjRYcnZsSnpXdFFjcitRTUJsd0lBWHBZTGNH?=
 =?utf-8?B?L1krM1drdXpVOUJjczc4UWtZSDlxOTRabzRLMjJjWjZacGN6TXlzUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c38ed3c2-b62b-4f81-6c2e-08de5e77e65f
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 14:16:59.4932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G6CICJD/8evOXFsiVVRg20afYjCtBwL10awu33fDgyFV4w/Vk8EaNkV4d/ohgCs3lBbLew+oa5MD1NvKvqojwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6127
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam11
X-Stat-Signature: hkpsmwipagf48cwi4g8hewhmnagcafyf
X-Rspam-User: 
X-Rspamd-Queue-Id: 6263640013
X-HE-Tag: 1769609831-4991
X-HE-Meta: U2FsdGVkX18QCRuucZvvarmaO54J0CziFvRjNEabmzZ3BSRZhQcSvqN2Jz2q+Lbha8ptQC1WGLWjjKVLxU8O2LkUUrngx7VJbEEHzZ1MNSI8AOhZNW6H2RpjfshuvbkISFLlzHPDHF7oog7fYGLUOaI0lQA6OzJ+VfXuANYuEReeVlNqLqfEQ5NXU9FiS/9Hz0v9LU55DB0MkoaAzW0P5JPm8ut1I8aQHXwBhYc6XS498Zy+TqeT5ZTM1HBb4TRiQJiy6g6JuLiryrqtniMr/yUAdOqhTFvtk0zC5O3AbR3A5/Q1GWWISdmmd9LJEYPTjyxT/l+pazQ0Wa7QhiiT0c/AtSWrf0HliSrQFSdVGujAmu1Nv2zhj5k+TfXwiJrPao1dEJUOxEn4mLN3359xiAQSYWDYBre8Bt/B/s2//P55vleglH82aobumWlUAQK5eU2xLK5elGi/iau2qrvmIsseOH7zTE18w6GOl0k+XNzGsUUSskSFdJbZR0vY4kQCuWRttPXo+GWj3T18hhxVw7gJBOcHa6d+v60PVlNGibei8X4oNhQSlEewkJqM+niyXpxi6TYRqO3F7ERRjLu1BordedheluiC6IEYIxZsHspJoiCHuL2m9J4VImoiYKozvJrYkDtJxmh3UkKSCsQSmZzJq+ARXjkRSxWkdjK7MA2aCikcR9dgaGZbRewXFYG072/l9BNrMqLiTiEsO2oSHlYKg2CuYfbP83T4HcXDlZajNpz7De43CDYH8SMov79i5Stq4rHtDBs2Pt8RhDQqnRcTsQ6oBnhCwUYVor9Ce91UU10KlDFIcaLNvegl11/FHPMx7ZkodTxmUp+KaLwya2uLQWOHl6XmG1gM3hRpOYOt3uYYjG2Tgvnb/1wMY+ZiWqDowY58SPbyIEdN0p1Nsg9/psg8p42c0+TezNiBAd/ZWgctvQ5KqTFJlu9zwwHX6nU1TP5d0ywX9Wv7FSm
 JyaZRHQy
 BFElfuqv3qJCvfNP+Msey/qXsQnYT1SKykh8vJms6waTGQn7No3grC7o/12gf/5w4JP3/k1AKN45aG4b+DelP6+z5XamNCvT87W0xkeI+StvhxAxPVGMJvzswrH/YUp2Ye7wjZppLVCLYJpb/KhAxHxAdJD8qRRjZIJvq8QBJvbNBqOZQNuTHdO05Us5lJlOAtO5Amy3J573EyfgD0ynZ8kNDZ5uwOmrddM94Z7ArZPN6qirbtf9dOh1i/9xf5w2lY51ndsOEI8k9MZkooxg5w4AngMDZ3evvNEqYgTGT4/eQOOEyVY6tS/2PQYW7HLRB6R5EUHGuLGJh7E2YfpK11ouk6AdBO62CxhbwDqPqwACUjDRx3eOZAWEEh6A7uAte+4k66TzJZjb4S6y2xffgu76iMZ/5RGPAyZnYOqsaGFkHwjP7SnaBcvyQ2ZHWlvzZZGILZ/1fAugB+ZAzUOChpF/xFVPhUj3gpwlMKuSY59p3DtIie6WkXhSTfKQhDoFQ3PfLmCryLgoFYcsRImS3xcbYvTzoopYhg/sXhmvdhh0lGmhOlLHnxMKbfWs+0l85aAc5bm5RqNUN/xVT7h0DcBrdnum+rXq5NULp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/27/2026 5:58 AM, Andrew Morton wrote:
> On Sat, 24 Jan 2026 20:18:39 +0800 "Li, Tianyou" <tianyou.li@intel.com> wrote:
>
>>> cc stable@ perhaps?
>> Yes, will do. Thanks.
> Please separate backportable patches from those which target the next
> merge window.  They have different timing and take different routes
> into mainline.
>
> Thanks.
>
>
Appreciated Andrew for your kind explanation. My bad. Will separate it 
from the patch set in next version.

Again, thanks Mike for pointing it out.


Regards,

Tianyou




