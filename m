Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 553C2CF2591
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:16:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2BC96B00A9; Wed, 19 Nov 2025 08:16:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DC736B00AA; Wed, 19 Nov 2025 08:16:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A45B6B00AB; Wed, 19 Nov 2025 08:16:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7644B6B00A9
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:16:35 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 178C8140369
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:16:35 +0000 (UTC)
X-FDA: 84127405950.27.0A66D1F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4D59D1C0004
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:16:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MiM3mBR+;
	spf=pass (imf20.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763558191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EG5tU9QCBYm4MnM4NJdckKlWnhetToSJr0LU1ya6fuA=;
	b=dNQgFbce3OCgeqiD4A4YLgldkm5iYtMj5BuNkZA0YOLRPfp89jnXLfoaashezRjcAAnUsX
	PZDtAoVG97U+hCVH9fkJ6V7QI68nVk9j14bwIeYu9WvPvb857Puoa+dhmfRcVSJutlKxUl
	oMLFPMf/jRWyRbGLxITE/kfzKZMG6kc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763558191; a=rsa-sha256;
	cv=fail;
	b=jTmVhVrLqIrpVMPLAX6gbroFNz3LQr5DdXkHwVDN0+1boIqSMEiMGyRaVkqwgoIeeDumFA
	XjOrLSRq8CgxTIXiPOSvUJKS7rKCzxFzOdUy/eeZ3In/W7sE8XQPbUAcDe/egNLjk/PJPr
	3dQQR/ChhIzFA1C5x4MeTfhVX0hruiw=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MiM3mBR+;
	spf=pass (imf20.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763558192; x=1795094192;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+FA8UifDbuhTTje/P093xcL71HE/KFNsrUXshNQwoXs=;
  b=MiM3mBR+QixwXedwwbB8g65Q08AtXseqY00FeLcEa6klz+MGwL0FlK0y
   csKb8q9Rja4JwI3UW7aK8DKNtaZ2zyLvm5iEyuGH+ZADX6iXAtJMqj+6u
   f4gbjz5ldTbGaQCm4IjEXdYfhO6aDHQo2FhD3WOb+FVVEgsFWUUGzVZ14
   VdmGxzPEdm5arKX+o6VQhDl7LIOFbSvfy0nScMQVTJx1C6XsAV5zGOz5j
   cKGK8CSwjrAHqTpMyD4b4nBhd8Gwyc11gOwfH/qCqykPVwZmc+FmskG0T
   Cp8n9RU3172hNHv/7KPHlApucdZ7wQb+AFti695T1nJbVBf+MrhpRhdqm
   g==;
X-CSE-ConnectionGUID: Jb7d0R42QlCUFeuz/OtRGA==
X-CSE-MsgGUID: qnh/B6FvQ7mQRgL5GpHndA==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="88250687"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="88250687"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 05:16:31 -0800
X-CSE-ConnectionGUID: SXxCA3kCQUSIAGYqveeKDA==
X-CSE-MsgGUID: buQ5IauBQPiFw8RDJJu7Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="196189201"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 05:16:30 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 05:16:29 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 19 Nov 2025 05:16:29 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.62) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 05:16:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qzYT/g5Fmkk70xaERSTK0tOwPe4i8z755yIo81pB/Vrd0FXrewDTC299V9kBuXs4UQAvu+t64Ew0kHlCYrgOG8FU/8FI9dNdDnn+a2nXI5nOajyfAabv/87/a1jhe3uTkS9tUZbEkuaEb5Sllb3iACKiB7FRVDj1Bwy3P4kCca5PtWmpOKpmTFtsIpGiWDeDcpU5WxtFdWELF/jsvAzQnoeyUuciEE/VTNTIfDZakCOII6GrMuUUpOZWJ48AphtFmI6EV2twv+LlSeCVsjU7INQ+B3u/zKKkfpf5Z5Jb3H6EPNpyCoj9ehoQNWb1cQMbbBW8iAib8N0uMp/rhvQJFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EG5tU9QCBYm4MnM4NJdckKlWnhetToSJr0LU1ya6fuA=;
 b=Fpqeerg254nNsfSpUWiPssnRjwd6n3rg0weqodkdvnmHz1yT/WiELL+b5OH3+CiSQdPyWz1s1o7mv3A8PJvq1fxunxX7Ov7IT2kEDarQKFLvFPO9Oe3a9a41RQdBnnKBfdaoKcgEShV1zN0bHOCTOqOpmq/f25SgnZaWtSgh5lFymdFSmiAm+JgPygGjRvDI+AIgxjAmgzEFJ50WSiHlbVB1T5BatIabr9DUlm01oVwT+mDi9kvHNh8D4KYaAGMPcUl0AOmp8gtR3bB7Zn3PRqx4OMPASP6aF0ZlEYcigvRejdLajQFac7obNx7MiQwyD7iYo3IbJj7N5uakpWWm2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by DS0PR11MB6470.namprd11.prod.outlook.com (2603:10b6:8:c2::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.15; Wed, 19 Nov 2025 13:16:27 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 13:16:26 +0000
Message-ID: <cd4e1cc3-ce95-450c-80a7-58053f1deb5a@intel.com>
Date: Wed, 19 Nov 2025 21:16:17 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when move pfn range
To: Wei Yang <richard.weiyang@gmail.com>
CC: David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>, <linux-mm@kvack.org>, Yong Hu
	<yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu
	<yuan1.liu@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo
	<qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>, Pan Deng
	<pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	<linux-kernel@vger.kernel.org>
References: <aRwAjSQBby614Itx@kernel.org>
 <20251119040718.2735199-1-tianyou.li@intel.com>
 <20251119114252.oykrczprf3ecd7ak@master>
 <ca02b44b-fc3e-4626-a331-d0348ad5e9f0@intel.com>
 <20251119124418.nhzgjweamqb6vjig@master>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <20251119124418.nhzgjweamqb6vjig@master>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0140.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::20) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|DS0PR11MB6470:EE_
X-MS-Office365-Filtering-Correlation-Id: 0813b57d-97c8-4e16-6c1a-08de276dd7c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cGVJYXpMd2dUR0d2YzIwdnhEQUNueG5oT1dkU2hXWTJPYzJDN0Jvc3lURWpH?=
 =?utf-8?B?QjJzQ0pyWmtwV3ZKTkF2dVJJc2hGVldhVFR2MWZGdEtrZmhxclIrMWRwRFhs?=
 =?utf-8?B?NW90S1JYRGh3d2ZsaCttWHFpKzM0V1A4R00ybjNvR3c1QUM4OENaS1RwTTk5?=
 =?utf-8?B?RkNvdVU5QmpEeHhyTUpsR3YvcVVNaVN4cWZyUy92MHRKd1N6TXNyRFY2bUhJ?=
 =?utf-8?B?NldBU3dzLzJKeXRkTDZobzFMdkVjUzRmeFYvMldCMTRWKzZsQVlJYXBoVFNu?=
 =?utf-8?B?TXVQRHBqZENyd2RiRE1DQ2xTUm0vQ2NqS1JQTCtxR1lMNXBJb2pDRFhQdENq?=
 =?utf-8?B?dVRsajY0VWwzNWNUSmRJWnVFT2hUUjQrWjNyVFNySU11VWNnMHFEQy9odHVO?=
 =?utf-8?B?NHhGWXpGMXljK0xqR3RHUmsveDMwbXZqSWFRM2JqQmpyZ3U4dlcyNExQbm5p?=
 =?utf-8?B?SDE4ZFY5MWFKWk41eC9rYW5VRlFoVGhGYW9jc1oyanZGYnJyMDF1ODhib3dO?=
 =?utf-8?B?M1NGbFpuNFM1bjJaRVhuUmdSV3BjR0dJc1VLRXVEdXhOSkV2RzNWU21WWG0w?=
 =?utf-8?B?RlBVNXBhU1VyWVlXYXYrNytIUGxLYSswTjZyUzdoUS85bFhxcjRYc0N3OEJa?=
 =?utf-8?B?ajFadkVSazFLSUtTSzdjSkpYVGUzak43bmFKcVhSTXYrQURYRnkrRXBucnl0?=
 =?utf-8?B?R3lLeDhyOEV6L0RSK3pSaTFWbDBDT1YwaW9kMjJwWDhLeXNkZTJVaHVONGxL?=
 =?utf-8?B?K2tMdWRXd2xiNlhaY1JycDgrdStZajk2ZC94TG1nRjhRNkVoZ0NiQ1pqQnpY?=
 =?utf-8?B?bUNXa0UzRzE2bVBoWjI3RStzbXM0M291QTdFZEFXNFEzaGlzVlVXb0VxS0Jj?=
 =?utf-8?B?NitIOTRPNWY1RlF2ZnloejBSU2g4RVoyZ1g2OS9ZOXZHbmluY2tqTzdPcE1P?=
 =?utf-8?B?QlR4YW1BTjh3TjlobmExMUtqWllHVTF0RFlLenVrL09KVzFBcGFmUmxnSmo5?=
 =?utf-8?B?aS84dEszV3kwT2RzS2Z2alBLUUNRUHUvTjZmSGgzVUJKRE1ST1ZQN2lva0xa?=
 =?utf-8?B?MXNCTHZiZ3cyNGUwRzdqemJWZVNDVkxDZUFvU1NCMEZ1MFJFeFQvQkxqY0Y3?=
 =?utf-8?B?clVaZDRpdm9nclY3VmRyL2drYkt5L2c5VkhOdmtmZERYSDZhcWNYZC9KQ3lW?=
 =?utf-8?B?aWJlenpiY2pkTURldGVrVS9wWXd0dUZTZUk5NmJxMUdPaDhvc050UkJ6ZmYv?=
 =?utf-8?B?U3pPSEVwUlRQb0lLdk5sMFc3WkMvUFcydTlqWllaS05Sc3FYK0RPNWlXVnhP?=
 =?utf-8?B?RlY4dFlKVkFweWM5THUxbmRkT0Q5OTIwdUZhTDUwaGd2RDh4Q2Z6bnA3UitT?=
 =?utf-8?B?eW95c25xSWM1Y2dRWmkxN2tCTlJaYU5FRmR6ZFlTQVJlQ3VRU2VRMnhROFNm?=
 =?utf-8?B?MHY4blJKeGNHVjA2Z2JZUkRHaTRpaTNxU1ZNZ0NoY1N0R2NqbnhnMWxaTnp6?=
 =?utf-8?B?N3NhR1NkbFh0OVdjL1UrMFR3cGtrM3ZTa1RiMUZHd2FHb2FOVXBCRW5EWWZY?=
 =?utf-8?B?OGxYdWlkOFdRc3E3RmhmV3pYL3dtNVRsdklNQlF0WFljL09lRms0NFllbDJo?=
 =?utf-8?B?YjJUM2VLRURRMVg3ZEdxcDdLYlYwQ1doOEhXRUpXRDNHKzVMWlA1MlJEUnMr?=
 =?utf-8?B?cWpaNFlmQmJOY1FrUU5lVDM4TUJHNFZ2WTBkS3ZZbGkyRzcxZ3lkdlQ2byt3?=
 =?utf-8?B?SmdlRHRNM1lmTnltclkvdld2M0p5bkttdDlvcHN5NWNzSklSaTlxMnJKR0dX?=
 =?utf-8?B?Z3cwcmxYMEp1aXlZaThSQVE1ZFpNK0hhY3FDUVJsS1RIalh1UmRXR2tXWDB6?=
 =?utf-8?B?S2J5MENLWldFY2JPeDNBY0djcFlST2FsY3FzNGFUK0VPMFRLTDIxQVJzV0J0?=
 =?utf-8?Q?iJIHZEDo51iD8l2RBkx2Jr0jGJuYRgeL?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QTUzSWlBbVE3ak8yVUN3S2s1dnJ4TUt1ejNlRWo4dUMvdlhuYTFIdGZKZ2pE?=
 =?utf-8?B?M1N6eU5MaDU0b2VXRDhqQ2lVYS9pRnZUVytYSXFPNzNKTmVSZzhvRm02YlZE?=
 =?utf-8?B?TnRvV2xoL05UTlVsVU1MWHV0cWhqTmJ4eUtYRG5xYnlTVEpLRzRPRVBuWE5B?=
 =?utf-8?B?Lzh4VW1OT2pRS291NnVxekFoRDg2OGlCVnlPOVkrdUN5QjRFTzJCQ01xS3h5?=
 =?utf-8?B?T0Y2ZkFnTUZaL1ljWk9tVUhqRTVqYkNQTlpXZkloMUZiUXp2RHZwenU5MXNa?=
 =?utf-8?B?T0tkNmtnQVk1czRJWVJyL2Fqd0d4WmNFV0tLaFRhalVRdmo4SktieEdkN2tl?=
 =?utf-8?B?c1hpak5SWVU4czNRRUowdnhKQldOZms0UjdTRldVbTI4Z3JtUlprL2Jpbjc3?=
 =?utf-8?B?RXZTS3NoN3RCTDU5dzgrbnhFTUkyUWFZcXFqaVpKQnk2RndaSTI4T2pIWUdC?=
 =?utf-8?B?NmswRnc0Lzk3dE5hb0NOZ1EvSmViSGVLQm9POU8yekEwcmo4VFUvcnY1aklL?=
 =?utf-8?B?S3c4VytFZEhwSCthb25QMnRzYVIrYklOSTZxQlgxTUtLZ2NEWDBJQjI1MWd4?=
 =?utf-8?B?UkR2eVpZb3FNbFNoMnk1bXVQVGQ4eEtaN0ZHWXNYNGMxQmw3RUVjc1RGSzha?=
 =?utf-8?B?dVBCVktLbkJCeVBvV0dxWFYrQTNBRlhUWk83aXhlZ2p3WWRMc2tieUlCYkth?=
 =?utf-8?B?eXptUDFMSkZNMGtqWTFVZ3prTDVDZk0zanMwQjhsVndGeDhoeWdTbG1pSXpt?=
 =?utf-8?B?cTh4Q05ncjRPN01sdVJnZzVXRy9wdTVRTU80NEhlajcwODZ3cmJrSkZmWFJW?=
 =?utf-8?B?Q043aXl0OEFtelhNMUNZMjB5cTByZ0IwT2pGZFFGdjZLQ0huU3EwcGtqRW1C?=
 =?utf-8?B?aG1uUFVIWWVxbGVRZkxWNWZ5elkwZlRGVU9OMzRDWDREc0VFUis3bC9pYWdM?=
 =?utf-8?B?WFFLUEJ1YnlLUkFFTW1pOXFSc1A5eTBJNnZOY1lOS0JoLytxdXBJRWNoT05C?=
 =?utf-8?B?Y2RKNTl1bVQ1cGhTWjY2VTZkclA2eWZDNC9IUkR0eFJTUnU5clhGaDdqK1hE?=
 =?utf-8?B?eitiYVNaUjJpTFJxTWo2RWF6M0NpTW9JSVRES3ozV2RZQlhvUzFCT2ltbHhJ?=
 =?utf-8?B?OER5aE5RZDRNcDB4Ujl3VlZBa0FjOWJMczA2SDJFYng3c25wOHpSMTJpbUR0?=
 =?utf-8?B?VHlCeTB1ZWVnc0ozSExDRXNJMUlJWVBEWXR6TjZMMWZ5MkhxWC9TZmpQRHhU?=
 =?utf-8?B?UlhXREV3ZFFDLzdFV3VzSDJGQ2RtSXJQOGpzYzdJQWdoNUlDMTZHdUdNdWRL?=
 =?utf-8?B?OUhQS1JjVnovekJaRCtNcDJJQ2tzZWFmQTlXY3BLS2pXNG1vZy9ROWh5UHB1?=
 =?utf-8?B?d1BFQ1Z2aGRYWjJoZWp4VzJ2R1VjZCtUQmYyVDN2V2hVdXJrbGFkeE5jUUlO?=
 =?utf-8?B?MDdLUERWWUd1WEpjMEhRVmNubE9SdEJzWUJoTm01WkdKNFl5WEltS3VSMkY0?=
 =?utf-8?B?NXN5OVdoQldieHIzcEJxSVdMVnRCU0dpakZRVFMrUVBFdHVoVW1yd3dLakc2?=
 =?utf-8?B?YmF2Z3VYWlVNY0xNdGJLZHluWVJYWitiTDJEdFFmT1hidndkeU9Xd3hCZFhh?=
 =?utf-8?B?LzBVZE1TeVFwb1UzNFFJSVBkOW4zVSs1OVdSc1RKazdDY2laRE51RXlRNmRo?=
 =?utf-8?B?WUxVTkg2a1JyWkFyeGxRaDFJcmdNbjlCODJ3Y25VMVkyZjU4QjhqTUU3RUJF?=
 =?utf-8?B?SUwwUENaaEUwSzRNSE56aTZ4RVcxMnFDV01ZMitZRStTYmRaM2M5ZXRiTkE1?=
 =?utf-8?B?T0VGc0pTSDAzTUduRHZVVitCRExIcnBjOXBQaTN2Z0tnVWVRa0ZaYWkvckxM?=
 =?utf-8?B?M1d6dEJKc3U0N1hEVW02aDR5YkxUVHFPTlhpS1VKeDM3bkJvZGxpR2NJWWtv?=
 =?utf-8?B?QkxndExVWGlnSm1VVTlqOE9Od3pnMFQ4WFV5NjViM3pacE9iR1RWdHh3Vkgr?=
 =?utf-8?B?a2NqNnR2RlNlencxUXUrSXJjaGZnYkVOVVBuTWdpMlpDeTdvcjlOSlRSd1hm?=
 =?utf-8?B?bzlMcnhMSjBFYXh3SVpPVDZUUDR2REtYc2xtcWdJa0F6WWljSm11NzR4dnhC?=
 =?utf-8?Q?7zj3zHDpdKn+kTV3pr4dpuysP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0813b57d-97c8-4e16-6c1a-08de276dd7c6
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 13:16:26.7747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 107lBxO6bMvlDvHvLIzEOfY6WHQ/+dV5BnwUjQ5DH7UCPAgm0mo17Oec1sEVEKyx9l8rfj2cCyHXbWR1XBpo+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6470
X-OriginatorOrg: intel.com
X-Stat-Signature: gcs33nmq3dxmditao1ct5d3f4tkiy8dy
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D59D1C0004
X-Rspamd-Server: rspam01
X-HE-Tag: 1763558191-271814
X-HE-Meta: U2FsdGVkX1+Sofv2cKI/4YGC/Ul+nWLZyz7DLpiMqJeVgQH6KU00rlD8Ok3HGHTZOT2jhpI/KQWMFWkEgq/TMMEiyFogMOQEMH5BmmMUTeqlIObkCR2DF+a+5jtA1x8kHtyOOVTimDA25D0Z+34iJqa1IU6HOgUIr4eHWYpjYdgwvldZX9LqRSTjKy7iKwkWpwe1+J3EeL8pmsqLLldTjuLyC6uiY/ExMXlOB+tAJ+Hs0tOObUY+RIRyUREIxqjXynZ6F/qKtDOfsgmm+KQ3WxrQuFfwr7r7zeVgIerJFE9SRPTuAEoF2rIPM0XF/12jq9ArU6eBnuRmQXK/hy77O6t9tJoT4RNZZFMgOy9JPKIK7T71jPJDrMteCkY3baGNfFUjk2aCRckgPc8cKZIuYSJzzbXFokTmn1TgHyhr2kbP0cv/NRyVQzflDOlLvx1NSgnweo4GpgOUDBy2wu4nUSj/Igcb/tN3g8W8yjK97DkaTxSHYe6Udb7b8qfAbwcNblGdwNm4PqfvIk+u5WsSaA+QQ7hNnBH3zUbigTb1qSwsBkc0L3K0Jl1MnRqXKiCvNyatcI7Idamoei5NvwexamhwHFD5SVpbHZml9vTcjrD0Hqaq5QFPiK5b5Rcf09PhuAa/QjMKFMuHdUBXkFcbkJFl0aNJW09tnkiIdbD5gdxUc0Xa+6wORLhv51xfvvkS/uOLnuayfObl2HQ7ldbtVTnG3PgsiBBLvIZ69a14t9HC+/Y1SLuFVrUkhIR6qNhMVdunCihcZrvVWndbiC6E3nyih6l8rp7qRVPN+nGgRXb6yXYLEx3PVxB8jlOCWa358zawPOh8dQAbOBBXi6hlbFx8NFJo3eZMrMmUckY4W+dkMirUzdJLw/E3WH2HfRUgCXIDy07AX4DSICqzqlmaoN76vjIrleLAnPtOFhdDIYqirsnrLrWxyQ9TudkDmUoSht1uVfIswNLF8eMnyqP
 XC8aSMk6
 L40YWNIq4ONHJ+rD0vj7cOFyEXmAJYA9Aon1C5SemFOo3B3IBinfWThKETm0B8hcDb86e2igGY6zcfYcx7Bg0fir3ZrBTNbqZ4WymugSsT21gsBIJiw4TUxzvr+TdrfAOEtAnItlVDC24dubWWcUjT7qyngpXp7UrwR8ANFD6xW46sp2jG92/zszzjQBQN75Snc19kKNpr/Dm0QAXW/oSL7mEea21PqaSUI9HiXYCIJosxy4G2HVsG2ABXfvIJPpOSHV6zooZFX5cKTooxFTOu/aue6aktlUHUeUEX2R1HWSwlJkJQD4KtUrFecE/WEX7rFubdFrV1rIFgztgJ535v42tFUJti7FKjOTuabXljXH1ww9VR19kQhEAlJ4V60I922z+hIZ5kKiXXZGLs0FW3yCWZWFwwgAI22MxB/1+hlNlGsr3JCFzBIGsWv0UDDr8GrXxeU7ddPOAyA9Wcj++SJsjRMbYBEwM3Cy0KGXqRCRnAsRba5J85GqnUNbLy+VPeeJxfCDJjC/dO8OEvHzqx97AwNyMEYrGVFJCDZtjg0dOI98ebT+ZM20c4A7l3hjH1bxGA8aUmedKL7j4Yu9/dKKZ91QNUXcEITDv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/19/2025 8:44 PM, Wei Yang wrote:
> On Wed, Nov 19, 2025 at 08:41:11PM +0800, Li, Tianyou wrote:
>> On 11/19/2025 7:42 PM, Wei Yang wrote:
>>> On Wed, Nov 19, 2025 at 12:07:18PM +0800, Tianyou Li wrote:
>>>> When invoke move_pfn_range_to_zone, it will update the zone->contiguous by
>>>> checking the new zone's pfn range from the beginning to the end, regardless
>>>> the previous state of the old zone. When the zone's pfn range is large, the
>>>> cost of traversing the pfn range to update the zone->contiguous could be
>>>> significant.
>>>>
>>>> Add fast paths to quickly detect cases where zone is definitely not
>>>> contiguous without scanning the new zone. The cases are: when the new range
>>>> did not overlap with previous range, the contiguous should be false; if the
>>>> new range adjacent with the previous range, just need to check the new
>>>> range; if the new added pages could not fill the hole of previous zone, the
>>>> contiguous should be false.
>>>>
>>>> The following test cases of memory hotplug for a VM [1], tested in the
>>>> environment [2], show that this optimization can significantly reduce the
>>>> memory hotplug time [3].
>>>>
>>>> +----------------+------+---------------+--------------+----------------+
>>>> |                | Size | Time (before) | Time (after) | Time Reduction |
>>>> |                +------+---------------+--------------+----------------+
>>>> | Memory Hotplug | 256G |      10s      |      2s      |       80%      |
>>>> |                +------+---------------+--------------+----------------+
>>>> |                | 512G |      33s      |      6s      |       81%      |
>>>> +----------------+------+---------------+--------------+----------------+
>>>>
>>> Nice
>>
>> Thanks for your time to review.
>>
>>
>>>> [1] Qemu commands to hotplug 512G memory for a VM:
>>>>      object_add memory-backend-ram,id=hotmem0,size=512G,share=on
>>>>      device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>>>>      qom-set vmem1 requested-size 512G
>>>>
>>>> [2] Hardware     : Intel Icelake server
>>>>      Guest Kernel : v6.18-rc2
>>>>      Qemu         : v9.0.0
>>>>
>>>>      Launch VM    :
>>>>      qemu-system-x86_64 -accel kvm -cpu host \
>>>>      -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>>>>      -drive file=./seed.img,format=raw,if=virtio \
>>>>      -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>>>>      -m 2G,slots=10,maxmem=2052472M \
>>>>      -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>>>>      -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>>>>      -nographic -machine q35 \
>>>>      -nic user,hostfwd=tcp::3000-:22
>>>>
>>>>      Guest kernel auto-onlines newly added memory blocks:
>>>>      echo online > /sys/devices/system/memory/auto_online_blocks
>>>>
>>>> [3] The time from typing the QEMU commands in [1] to when the output of
>>>>      'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>>>>      memory is recognized.
>>>>
>>>> Reported-by: Nanhai Zou <nanhai.zou@intel.com>
>>>> Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
>>>> Tested-by: Yuan Liu <yuan1.liu@intel.com>
>>>> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
>>>> Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
>>>> Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
>>>> Reviewed-by: Pan Deng <pan.deng@intel.com>
>>>> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
>>>> Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
>>>> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
>>>> ---
>>>> mm/memory_hotplug.c | 57 ++++++++++++++++++++++++++++++++++++++++++---
>>>> 1 file changed, 54 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>>> index 0be83039c3b5..8f126f20ca47 100644
>>>> --- a/mm/memory_hotplug.c
>>>> +++ b/mm/memory_hotplug.c
>>>> @@ -723,6 +723,57 @@ static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned lon
>>>>
>>>> }
>>>>
>>>> +static bool __meminit check_zone_contiguous_fast(struct zone *zone,
>>>> +			unsigned long start_pfn, unsigned long nr_pages)
>>>> +{
>>>> +	const unsigned long end_pfn = start_pfn + nr_pages;
>>>> +	unsigned long nr_filled_pages;
>>>> +
>>>> +	/*
>>>> +	 * Given the moved pfn range's contiguous property is always true,
>>>> +	 * under the conditional of empty zone, the contiguous property should
>>>> +	 * be true.
>>>> +	 */
>>>> +	if (zone_is_empty(zone)) {
>>>> +		zone->contiguous = true;
>>>> +		return true;
>>>> +	}
>>>> +
>>>> +	/*
>>>> +	 * If the moved pfn range does not intersect with the original zone span,
>>>> +	 * the contiguous property is surely false.
>>>> +	 */
>>>> +	if (end_pfn < zone->zone_start_pfn || start_pfn > zone_end_pfn(zone)) {
>>>> +		zone->contiguous = false;
>>>> +		return true;
>>>> +	}
>>>> +
>>>> +	/*
>>>> +	 * If the moved pfn range is adjacent to the original zone span, given
>>>> +	 * the moved pfn range's contiguous property is always true, the zone's
>>>> +	 * contiguous property inherited from the original value.
>>>> +	 */
>>>> +	if (end_pfn == zone->zone_start_pfn || start_pfn == zone_end_pfn(zone))
>>>> +		return true;
>>>> +
>>>> +	/*
>>>> +	 * If the original zone's hole larger than the new filled pages, the
>>>> +	 * contiguous property is surely false.
>>>> +	 */
>>>> +	nr_filled_pages = end_pfn - zone->zone_start_pfn;
>>>> +	if (start_pfn > zone->zone_start_pfn)
>>>> +		nr_filled_pages -= start_pfn - zone->zone_start_pfn;
>>>> +	if (end_pfn > zone_end_pfn(zone))
>>>> +		nr_filled_pages -= end_pfn - zone_end_pfn(zone);
>>>> +	if (nr_filled_pages < (zone->spanned_pages - zone->present_pages)) {
>>>> +		zone->contiguous = false;
>>>> +		return true;
>>>> +	}
>>>> +
>>> Mike's suggestion is easier for me to understand :-)
>>
>> OK :-), with the clear votes now, I will change it in patch v3 real quick.
>> Thanks.
>>
> Thanks for your effort.
>
> While maybe wait a little for v3, let's see other's comment on v2 :-)


Thanks. While I am less worried if it might change back -:) In the 
scenarios we tested, the overlap case did not happen. I agree Mike's 
suggestion do simplify the code and reduce the maintaining efforts.

Regards,

Tianyou


>

