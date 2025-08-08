Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A07FC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 09:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BB5A6B008C; Fri,  8 Aug 2025 05:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 192FE6B0093; Fri,  8 Aug 2025 05:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033F26B0095; Fri,  8 Aug 2025 05:44:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E5DE16B008C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 05:44:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8B7B6BF176
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:44:25 +0000 (UTC)
X-FDA: 83753104890.21.98A7293
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf25.hostedemail.com (Postfix) with ESMTP id 58D0BA000D
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:44:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CMfnO0va;
	spf=pass (imf25.hostedemail.com: domain of francois.dugast@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754646262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LBewJsXue7oj/d5VsvK4i7126GFALOMdb2qMaY3T6jM=;
	b=c99QN6CO9FJzEp7TkL7eZ6243Lx116vkSaSFpjKmncNfM2NYUyt2jVMW4zxUrUE7HESeR/
	CS45+ZKCL+AQyMOcR8hn7wJQFfIqLu+c3a3qmpkKQbhIp7ZgkagXcIaqb5OxUw5K8s/Spz
	Fxj62pXUgR54VCNGv/LeoMUsmK458Uw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754646262; a=rsa-sha256;
	cv=fail;
	b=hyZdG/F614BVl5acqsnHY/6OF3XRMEAnHyFwmTVqdgmX0bqr4yODOmmVLyxEcv6emXtvAS
	4APTFtbW0YM36ILnEUrkrZlCjyG7he5CiczR2oohqJni4pag3dIueFVrO8RCsed+dQS9ep
	2azB5X45b1DnJMXuOiMw1fhekTUyczU=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CMfnO0va;
	spf=pass (imf25.hostedemail.com: domain of francois.dugast@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754646261; x=1786182261;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=M5LdgDxb+OwH/UxqjIXTSZDXVBtzkO+QhympreT1LgU=;
  b=CMfnO0vaHdh6WBHvRWryZ/qNtAQ1Qudhhb2ONQP0xeWk1GpBK409qzAv
   fAaI+fD/qVn10BWPHdS2mtAXRL1VkzzueIy18tCLdIlnDyMqYSqA8BTK4
   Y7sxYuggGKrz3JMZ8KpNA1x5BC5yiny5ThJ6w90jmnF3PE13QlhvCIND0
   JEjIIfFNQ/pEKhgRz5w89UiAQgclXD7R3yd9zB+A3yMmWzv0DcVrw2Rnc
   6WPjyx9COkGWSehJCWw/6mhqnLiiHM8PWvjfioTdezM8F4UGrabQIm78P
   iISvwqoGcV90MXptNAooR1OtB4Ktk815MrCUgXvH5OgtXgEiDDRpgMVjh
   g==;
X-CSE-ConnectionGUID: vhWJdqiNQMuIzlJIODgdeA==
X-CSE-MsgGUID: sq/6gUxiTZKryWp3cnXNXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="82436482"
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="82436482"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 02:44:20 -0700
X-CSE-ConnectionGUID: mc5YC/wBShq1mY4MVtMzSg==
X-CSE-MsgGUID: MVGAbx8ZTXiLODbeCmyAKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,274,1747724400"; 
   d="scan'208";a="170673226"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2025 02:44:20 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 8 Aug 2025 02:44:19 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 8 Aug 2025 02:44:19 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.42)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 8 Aug 2025 02:44:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q16fsM4un+vwR51Xd+gBwbfI5Hhfw6XDa3q1SAHge1tMlCY9678ZGW31YcSi4qmaBSV+BKQ41uMEyREYOEwNIEEW0Y8KRIuGpGx5DProlJWIDwku5kZjnlidDw5GLcCjCcIdYs2TwRDv4C2oXQPiCwZAAPS2Gvx6nxwWhjZguyjg2zrsfgOnIslgCa56NMnqQzIKUb6HJuMxRjxMFMhGFZieuTPzRyFmR4/UBi/5Y+ZNM214d5q6rKGBncF1oy2vWFVVB+9Exavw0aJO1RpL1pTW6GijFROsAe2IOJuCIietkVtrOkV5SozRA58alSPNISTfrrVlLOAu7hIDdAW4iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LBewJsXue7oj/d5VsvK4i7126GFALOMdb2qMaY3T6jM=;
 b=kBNKeteOjqiTTWSBPTHXx1PBF0ktupt42eCAbsxs72L7GrAM1cmlc7tm192JKE9G6Sj3bbzXfTevigwkR7PZVFsRn7E1dm9Cpy/dG0Tq36B/XaAYpFFbQl3gcNfAvuVfp8GXJPL15N11dVWgGTfq8yPfcadb50/GNuTdvq0vNI1HOeOGAVjzyLOkh+Mkr4/bSRPbEVj2BI+f86hDkmcF98ozriL/9n4ySY5odPiMgQvN4toLutbFrsKYD0w8zgZgCwqpQJj+ln5Ti9iKF2PbMcmHaa8iyhPZhLze6vHLelOmkmxJZA3U5Jz4wWfm0TMSgba1egGNaG5cYWf6pncMsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY8PR11MB7828.namprd11.prod.outlook.com (2603:10b6:930:78::8)
 by BL1PR11MB5237.namprd11.prod.outlook.com (2603:10b6:208:310::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Fri, 8 Aug
 2025 09:44:17 +0000
Received: from CY8PR11MB7828.namprd11.prod.outlook.com
 ([fe80::5461:fa8c:58b8:e10d]) by CY8PR11MB7828.namprd11.prod.outlook.com
 ([fe80::5461:fa8c:58b8:e10d%4]) with mapi id 15.20.9009.017; Fri, 8 Aug 2025
 09:44:16 +0000
Date: Fri, 8 Aug 2025 11:43:58 +0200
From: Francois Dugast <francois.dugast@intel.com>
To: Matthew Brost <matthew.brost@intel.com>
CC: <balbirs@nvidia.com>, <airlied@gmail.com>, <akpm@linux-foundation.org>,
	<apopple@nvidia.com>, <baohua@kernel.org>, <baolin.wang@linux.alibaba.com>,
	<dakr@kernel.org>, <david@redhat.com>, <donettom@linux.ibm.com>,
	<jane.chu@oracle.com>, <jglisse@redhat.com>, <kherbst@redhat.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <lyude@redhat.com>,
	<peterx@redhat.com>, <ryan.roberts@arm.com>, <shuah@kernel.org>,
	<simona@ffwll.ch>, <wangkefeng.wang@huawei.com>, <willy@infradead.org>,
	<ziy@nvidia.com>
Subject: Re: [PATCH] mm/hmm: Do not fault in device private pages owned by
 the caller
Message-ID: <aJXG3qerCxIGIiPb@fdugast-desk>
References: <9ae3e014-c7d0-4d58-af0e-925bcd9e4cfd@nvidia.com>
 <20250722193445.1588348-1-francois.dugast@intel.com>
 <aJVDGSUzuKgy0PtK@lstrano-desk.jf.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aJVDGSUzuKgy0PtK@lstrano-desk.jf.intel.com>
Organization: Intel Corporation
X-ClientProxiedBy: VI1PR04CA0130.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::28) To CY8PR11MB7828.namprd11.prod.outlook.com
 (2603:10b6:930:78::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR11MB7828:EE_|BL1PR11MB5237:EE_
X-MS-Office365-Filtering-Correlation-Id: f4919238-bed8-4fe1-6472-08ddd660240b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?H40lRiTjWlMaUd8lxm4sAnqTJxr5H2A1iM4B0kafrbh7UuC+FhWQGlszUV8I?=
 =?us-ascii?Q?tL1ZohrbsTHpQs9EIiT9aQJKGsXPoDMEA7/6qoiv4OgzR+dOrUjBvFj5v6A1?=
 =?us-ascii?Q?TvzbnB5q1NKfhw2w9ltxRlH9V4bogfh18LtT6eLNFYx1wv9Bkdj+1wQYvIQC?=
 =?us-ascii?Q?zP/rt/rSYMpD3EyM4hCx8IpbFBUUobhtipxmGo7mkMAKtUdRUXzuAmFKO7Ec?=
 =?us-ascii?Q?agmZsDNiK58fzmgBXtOO2+h5SYBvW7OAL9yAnpGzcmRhTgXEPZhYWwX9j2YU?=
 =?us-ascii?Q?KkETTWk+WgJkvzGyrJKBhWKOOVCAVZTGThSnidFa64l/91f36d0JWGRIPU5z?=
 =?us-ascii?Q?FXPP0Iifk3YaSZR1zvPo40xcRHDZOS1I5Xam/AfRl6DCwPQQZwTgYGjo6D7w?=
 =?us-ascii?Q?lcWnGC94Rerl5fl1iTh8B918P9dSDkDbgOSfq1K7YJU0QLzeHoJnTh41olfO?=
 =?us-ascii?Q?7bnXA/3t8u3/ze9aMtL8O20pw9nmxhbz11Bb8ZxIzGLeY9inHMxKqbuXUFlp?=
 =?us-ascii?Q?4IN0u8wefiO2G6ruUD3Y7zgb4MAvnBDrrnvna2Nr4zV5/d7L33YI8vW0raDW?=
 =?us-ascii?Q?Q+YYX6hyWmxuc7K50z9lGMpvRpnWfn29hEfPjKv4SUX2Uhh/P3Fc5NLQYv+K?=
 =?us-ascii?Q?1KI+OlN6YkM/sJULQxUJWqoq230+PZtK6xKbkgGzaPRO3zEPbqvYX/ZyIGII?=
 =?us-ascii?Q?o5pQDcbgX9Q5RZut+NFrcEWBjva6MvRGVhrPP5//Z659VtJKWjcuC6ocGynO?=
 =?us-ascii?Q?PNa/C3n4HIcEBZ6bSvdR91JnHK0D2fN+daLfuzxyWiz3r1XTc9WB9oXi5IbH?=
 =?us-ascii?Q?UsTGwTtM/iddyydSl7UqhLNhjz6cKB5kqhPuHn7mb019Lv3Wp4fr+rSJMp1T?=
 =?us-ascii?Q?g2sFq84/tIdoZV+vw8I+s4sNQBX1a17iW30x3TfOdEw08gqVXi5AK7dz5hsX?=
 =?us-ascii?Q?tDoSxedydnv9dnTwz8MFT4Xwz21kIgCDL49TA99aWUrpKttoulLqU33FP1BX?=
 =?us-ascii?Q?xdeoFWUD1JjRGMhhxsfLxXxGsN51UHqUJajXX3rNSrroTG2EOQyJoKzmQTC6?=
 =?us-ascii?Q?hfAMpdKs8GzXtwI/p5TWF3UNL+kGtkW77o/wXHs73IGsHcc3SjyUa0+bvhlH?=
 =?us-ascii?Q?yq1KXKJQ8vd0O5Lz5pRUX0LW1AH1poYkkmO3toSfWnxeP+rVGr5KQO53chpv?=
 =?us-ascii?Q?4RG60IT9DHvGXJkfVNizx7eVVakb3SjOEB0qaIRy1ziQuQqwFP9fMD0RSCbZ?=
 =?us-ascii?Q?dynbXlGh8AlJJHHA6NipDioO81CB8nvMry5HI3l2L6vy0evIzB9sTZGBIEp1?=
 =?us-ascii?Q?hRGOp8NrhCW6D9db7lpZiIKQPVCLgY64pxrIUjSOB+1tT3K1RnxD00HtqPVu?=
 =?us-ascii?Q?6o5xQ9GTHWQeGgFSMUyCDPfOnaWNdg4dE8tJ07MvIpwsWhHdFQOpIp/FnTyK?=
 =?us-ascii?Q?Jo2JjMcCt80=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB7828.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jkHyUS4DA9JmW5ZwFiukrT7GQSMSLpFBGaaqIk8GzkBQ7hQdG0oopwUXfzUI?=
 =?us-ascii?Q?jhwMKSKY4NhyQ2SI3Z8uqBlAR6ebtAELY99/RVowGAg2ca0QZ8a6Dzm50HsQ?=
 =?us-ascii?Q?GRr1dA4hc7GGi47zFt1Bld2UJ9fJ2D0d/JwxHPNfpRB1uL17ghCqlSMJXoNg?=
 =?us-ascii?Q?4XwM4nskyYL+lBk4m5FBcr2OxOAoNh8BgaqgTaLZ+Zr4mDBucIomx00JiZrD?=
 =?us-ascii?Q?7AxH1gnXgXL2ojE4S4rwf3uj7NOeomPYzJpjkY/t/QXT5QQoeWIzkOZHfgyW?=
 =?us-ascii?Q?WqqiuOJSDxu5PwJ9ujOP5MbYxfKTF2Al1oOYWUh1C5UsIRHO2Q5+foZfNsgz?=
 =?us-ascii?Q?CUyJIase3gj99fhEMECjfUryWHqhY/tI7ni+lo5DMZWQkMo5mZYAJa6wzEEf?=
 =?us-ascii?Q?GgqYLFwPGg+X359EB6BXhQvcbeMpI3vPfqhrujkNCRxgfHOX5Dkc3Z0ABnhF?=
 =?us-ascii?Q?qvwBCtBB/sW8KN0nKI49DcHh0/ZdklZB1xgIJLuGqxzhSeSzUoDF8+solQkH?=
 =?us-ascii?Q?Dd5LbXE3ZPmTOo8AxD5N7zCVjLLW6HnlHXLXY6yd9kVyG0AVqVxvZ7DEb+O/?=
 =?us-ascii?Q?7Sq5cGyzT74V6rWIicmRz9KwyzH0x296jJhEA5XUE2V5qA8HyjDhaR0LkR6j?=
 =?us-ascii?Q?HOCH+4fN7IBkDoSYdJ4mhK1sBYqTKxRn9tC/uL3ZdDyAMmBlWh0EjpP/fR0M?=
 =?us-ascii?Q?6J2qpk4Cy/3GKI0MlN8abMRZ917fbbISFW45sto5XE9h9OA1U/kWVqzEdgPM?=
 =?us-ascii?Q?O3bc+nfsnImJ3MEvqrtnFTE2Vub2GHWDdBgTWZtTLTYSMViie0G7CuK0fk0G?=
 =?us-ascii?Q?a7+aFaOiKd/MGEif62/HaDaFW3xfM3qxGVIsiohum+0em+bl+Mj+pvYNRGvc?=
 =?us-ascii?Q?5DFk8cX1R9HErprFfM5J6NfXjXASUnuFLku7vbvrsIdq+N1VJSyiYMHT3U1S?=
 =?us-ascii?Q?PTpnZjMLny60mZQarpr8XWAGY4xMGhpuIPnT54TiYx/WoCfIRlZeCF2WR+aE?=
 =?us-ascii?Q?0jKUEksA5037PwlsBG1trgntVhncvB1YPdHGHVjf854UNsr+xev9542slzni?=
 =?us-ascii?Q?lhjgkMFEcA8nZnP+J8Lg0/+PoFEq5uBtRPy4yamNz/y8YaXL+HTf2ZL2zaVD?=
 =?us-ascii?Q?unQtvKr3oqkxMkrsTGpvaq534UQnQFT1+w+Mzck9T7hqDnBOXTo4HINLAS+c?=
 =?us-ascii?Q?gjd74o03UN87IhMdrFz58ciSZmTYSuasMQ0KNIWRWK2/inTRaeBwOaCCBZjs?=
 =?us-ascii?Q?H1uWxOtJb7niIyD8DTC+ooQr26T7lGtOuxDqmeklc6uOxU14lOEhUxIWlGin?=
 =?us-ascii?Q?Fo/bPTnRV2/HUgfbIK7vs+z1OtfPF/fwcCBulYM0vqlGOMz5cLBADqLvNd6f?=
 =?us-ascii?Q?+QcXjbvpMrR1KBdcaEggVHUl34z4v/9M1RVAL9ZHOoZvto8dgcjT8yzhEcmk?=
 =?us-ascii?Q?gXNF5FW70VXgQknfdB2m2J7fH9oZGhoXyarE6eIAGXElceu8qHZF0nJJZL77?=
 =?us-ascii?Q?SlqzWb+Zss/8jYpoh4jz1VLF/tQxcqWgiWP8VX6nhmUxE3XdmvS2v5iiK3uK?=
 =?us-ascii?Q?avmFMxAOv5RpaoVJ2FTLBhs7PCsGapyllw+VdZZjm2jrXRw5JHArpmJeQzwi?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f4919238-bed8-4fe1-6472-08ddd660240b
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7828.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 09:44:16.8820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /LDgNiK0Din1Tgge3yyxIDjHq5+o4DxCscuJLZJWqPsuoWDJyiAqeUEoZi4EylvY46VPCFKIXiWTUMpOgtgTT+vVgIoyRZjNbq5npB617m4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5237
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 58D0BA000D
X-Stat-Signature: 56ha4donbrofgosqqzf91hkxs5fmdxjm
X-Rspam-User: 
X-HE-Tag: 1754646261-123458
X-HE-Meta: U2FsdGVkX1/gVz6o+mhjmenmk5kzjsAPyAFbhXRzaWjmUKspW913NLMOWcjeaK86Rks4swaYGWMVdhC/oFM5mp88CDXlKM0skfn+IghciOV8/tmuiI5AG4DeMbb336dTRnMUIV3/ZM+dWtuxvIHziQLag3NnFekivTmPpghIHCOANelEpsEhKOPbxCTfBBjBDTk1g/15drkY9OTDuRQqtztNQJqISxPnI0KbJIeO35L3dg9lwN2o+ZMrzJ+6NdkZml1LVhNpYEJD8XHojyvo2tmrcLG3S2WNGLVx7wHAzgPUbH53x0ecdYlj+bJ6rOMF63/3hHQZThPIghZubO03Yz75iOIhH5FEdF4tsWIpXK1fZF+CQNZ2jr4yeyRKCT7zL1ZuwZTbayWU/8F2y8znnr9DpWmdQRYNR+IYjTdYiScZuIpe7+8Finu8IFtZKByzwORhNbEzqwutJplpMhe5dejZuo0SD/MvlrqVhqVqueecndZ06idkofCH79vrlGfdOd2r5j9OXN74yAw5o3wnd36yoEwwpHOxUl+Tk6wCDUJXUgIrgcvIEYPacOdN1DtFRQHY2Pf2XBPOipsiFEJXkJNLR5mP5/GcLU68ckgueaVRIqDQ7KIteyZaxxuDoRjPyWkgPtpe5Mkcmf4s9lM2PPj+7Hl229Rgct59ym9T9UPkHVzUVGEYfrHLEXWazHzmeZY4kcD7nBhZ1EMXIWsfTayVgpyLYzefJ7tqdsMUszdDnRqZpIApzvGlWsPHro55eUi7jJhW7Xci5RmQ9pCc/EFAT5Pa5ni0MQF47OxRbDPCPv+qyGR1X4tV3nIHN3eEx42rZGCGWn4w0qfHqqBL4h0RRl9rlipkxKL/DcxGXfeM+uvn0CLub/j+KjesAbMeTlbQ7IPYIjBO6oGLBixR8EVZJeHNDjzPQGTZWsEeQ3tSSX1NlyrYvqR7MLplEUjAGLZ5YhEN5DL2GAxFJa6
 JZnV15KY
 T2utXzNeI0eKpM5c0qaFVc414avjYaanGCFPNfIy36B0wLT6VrTeEFpNv8/UmFr+dTeqJD+w0ic9Apb12xBlyzJAH0iL/7vgZ2bRc9IOeKElvvKfNhr7BMiy4GWNImYHiSovjnK4WYJP3Bui/c5iqSyyHaAr8+swy4G0+2PGs2xYGQyPCoQFmvBtx0GgQqQnzcJyP4R1DtTGeXkzsbXyXiLIJ0/TqlT2LPrGx2zrpWKDMCIe3d7PfgcJ2zJmm7Lw+1uLLszPZc4gFwtMcxq++fR6WhVyhTPl/N5cN1/+CwckHDJDfi3EbRGWGtbQiRCM3/9pZ0eqDkgvZkgYu9SnAzIFKNy53KMG8AoO2EZ0jFd2HNslc5+R/RWXOvhx35Da2QrpO1aL9lHyqYjM/iVXYa6f01EgGqwoWszzLislN34YrFgPyIpDbLbklLns3ihc6C+0mRzY85N4PRI8kOgcd0HNDpC5+VuuAoBXsfzvLhkZp0DDTgoE4QiwB6OLKxEvbpcSVq7Jd9QydcFi7a8fUqBI1P2u2KFN4YkUpIVgYyUI9UL1xqvAy/tCFqL5BSv896+WTmidicpLt131GzAl8+hRxcnGLRInfg/MENX0qirncVXn3YjHasW6014AAfxfRosQA2068r+vszML2gWAmZJ38wSt4EaXONZon
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 05:21:45PM -0700, Matthew Brost wrote:
> On Tue, Jul 22, 2025 at 09:34:45PM +0200, Francois Dugast wrote:
> > When the PMD swap entry is device private and owned by the caller,
> > skip the range faulting and instead just set the correct HMM PFNs.
> > This is similar to the logic for PTEs in hmm_vma_handle_pte().
> > 
> > For now, each hmm_pfns[i] entry is populated as it is currently done
> > in hmm_vma_handle_pmd() but this might not be necessary. A follow-up
> > optimization could be to make use of the order and skip populating
> > subsequent PFNs.
> > 
> > Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> > ---
> >  mm/hmm.c | 25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> > 
> > diff --git a/mm/hmm.c b/mm/hmm.c
> > index f2415b4b2cdd..63ec1b18a656 100644
> > --- a/mm/hmm.c
> > +++ b/mm/hmm.c
> > @@ -355,6 +355,31 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
> >  	}
> >  
> >  	if (!pmd_present(pmd)) {
> > +		swp_entry_t entry = pmd_to_swp_entry(pmd);
> > +
> > +		/*
> > +		 * Don't fault in device private pages owned by the caller,
> > +		 * just report the PFNs.
> > +		 */
> > +		if (is_device_private_entry(entry) &&
> > +		    pfn_swap_entry_folio(entry)->pgmap->owner ==
> > +		    range->dev_private_owner) {
> > +			unsigned long cpu_flags = HMM_PFN_VALID |
> > +				hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
> > +			unsigned long pfn = swp_offset_pfn(entry);
> > +			unsigned long i;
> > +
> > +			if (is_writable_device_private_entry(entry))
> > +				cpu_flags |= HMM_PFN_WRITE;
> > +
> > +			for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
> > +				hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
> > +				hmm_pfns[i] |= pfn | cpu_flags;
> > +			}
> > +
> > +			return 0;
> > +		}
> > +
> >  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
> >  			return -EFAULT;
> 
> I think here if this is a is_device_private_entry(entry), we need to
> call hmm_vma_fault.

Yes that seems needed, thanks for the catch.

Francois

> 
> Matt
> 
> >  		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> > -- 
> > 2.43.0
> > 

