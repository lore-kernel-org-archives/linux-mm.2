Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13F17C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 05:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DFD96B007B; Mon, 27 Jul 2026 01:07:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769F16B0088; Mon, 27 Jul 2026 01:07:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E3346B008A; Mon, 27 Jul 2026 01:07:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C29F6B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 01:07:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7BF10160559
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:07:23 +0000 (UTC)
X-FDA: 85033373166.27.DE3386B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0426520008
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:07:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aSibD8t8;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf03.hostedemail.com: domain of arvind.yadav@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=arvind.yadav@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785128840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ZqtE4+NboA2Ka20pZMKc53CapZyZRXQlfHBoLFtdUA=;
	b=3w81L2unGmmmE2KB79tNSiqS12JEqlIvfgYIGD9Hmh5iCg7H+8527thgAsxJWoqKO1mG3e
	16MNTfS9oxWxQ4GVkgrvQ0C6znSIUUHxPuYF5VVDRrUhJXzYeLZt+I7MqcEzKs8r2S8pAl
	D2pBzQc7jZNTTIkocsicDLDihQcekPg=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aSibD8t8;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf03.hostedemail.com: domain of arvind.yadav@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=arvind.yadav@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785128840;
	b=OTK1GN/2JEMRit4G+hdtzIFOiJ2RJdlBEw3aWFKj+vSCwyFZXVmSlQwvWJdu/RSa8wIMOR
	njj7Lv5XCzG1Dp0YWy/Sc9pmjSNfdSOhqIeWKLK0ucj7XSLlskf1WRP17YlgdAZOyMKiJO
	uAvL1wfdQnP35wx/O7ep6PNxlzTB4Vo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785128840; x=1816664840;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oA2gSjLHLQA412aaRoo5H7G6/aL9+by8CJvqeLjQZ90=;
  b=aSibD8t85pxzaVYuwL2wBkaSyTaoGBrFxeC+Jq3jdoTqD6QhU6CioFji
   rRqg1Wckb/IS6c3B8xDQFt850l1yz4+bNz2gaWm1hqo3s5E8ffVECcqY3
   nnGIBiAT24CiaHHBgIzjhJPq/+6co1qCTduXj58CPvI84wB9mfUVHEsCU
   ZuuX306P5wCpz7jeCwuhYqK0Wv8jUCAJVCKLhExIzRSZQkrNo1zpCN19/
   UY/TYqPfIjksv4C4/bv02nrNklwDPKD0sDdCk7fSjr5RxMELl974BmYcb
   tGw8N1hnm+W2P0rjoRudnLfeXGvxF2lI444enIcaJOsqfpGoUj4t40a1c
   Q==;
X-CSE-ConnectionGUID: EtM7l+noQ52d0r9/l41sBA==
X-CSE-MsgGUID: j0A4GrXxSt2FDGAn8ZLlNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11857"; a="85634596"
X-IronPort-AV: E=Sophos;i="6.25,187,1779174000"; 
   d="scan'208";a="85634596"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2026 22:07:18 -0700
X-CSE-ConnectionGUID: UkMLBWCwRgu21fROkXfkjg==
X-CSE-MsgGUID: gZaM3pEtSmmS4Pjd2QMyUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,187,1779174000"; 
   d="scan'208";a="282641395"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2026 22:07:17 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 26 Jul 2026 22:07:16 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Sun, 26 Jul 2026 22:07:16 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.3) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sun, 26 Jul 2026 22:07:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dM9GzJHBN8/+iUmoM7DBjhr6eMhYhVAkxvEgvtR+fGTApMFPUCCkCW8OPacgz4BSrCN3YHAEjmYMII16YACZ5jfejCDPO3KLv113kngFWp93jBZJqP9/8kYAY0COuQmFd0AojF6aC8vRjR7JgyBCC0fmKPNC+PAqs2AU2CuBBc5XhN+cftkbxxxMxMYLOUVzWbIJfdqhmNDHrIoq1nmK5sOKGvYItmiQy4WfaY4eqKB124s5mEuAyik4N3Lbe32nN7l6hp33Trh64ufnSMZLsQkbn1zMYT7rUfuMRaDYkBAoPAzsBKoNApGtCLHXbiJ6GyZLM868cW0SB4L4i6zXPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ZqtE4+NboA2Ka20pZMKc53CapZyZRXQlfHBoLFtdUA=;
 b=K99N7TXcC0qzaCaEIG0CfD+e5cqHkQDiLPmzV3YhoP+ez4IXnL9jntN7X1i0fLkjdSp5F2FWP8NrEiP8z9TAfajjatqE0haWvwIbBAKt+2b+7kNDplL9HCCq4COvqalKl1vPbcm9u+rYh7Zt7WZ+hzpDS+ULejcAF5LIsy4poZHhYiMO/QuGZhyQ8BRvbza9V9fJQl411sTzM5IkJhzurRMeXOj6WT3LQ944uR/TRnzhCisuK0ScYTiwKlNeonVY/lQLsAM7NAnbggAQqeX4cKw7xF4rj6upJI/n9rdBOBjif+YRIfL8Lj6tMONZIhAxDVoL6H2Y1YvyPo6maaazSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN0PR11MB5709.namprd11.prod.outlook.com (2603:10b6:408:148::6)
 by PH8PR11MB8064.namprd11.prod.outlook.com (2603:10b6:510:253::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 05:07:09 +0000
Received: from BN0PR11MB5709.namprd11.prod.outlook.com
 ([fe80::ad31:3f30:20b8:26c]) by BN0PR11MB5709.namprd11.prod.outlook.com
 ([fe80::ad31:3f30:20b8:26c%4]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 05:07:09 +0000
Message-ID: <b24a5e04-9972-44cd-aebd-8ead81d9848b@intel.com>
Date: Mon, 27 Jul 2026 10:36:59 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate_device: Clear stale mapping after freeing
 swapcache
To: Zi Yan <ziy@nvidia.com>, Balbir Singh <balbirs@nvidia.com>, "David
 Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>
References: <20260724082702.2531024-1-arvind.yadav@intel.com>
 <20260724214307.a50ed52cf78fdc73bc42f9bf@linux-foundation.org>
 <2b2fe98d-1a7b-4aef-a1ff-0fbe43339180@kernel.org>
 <DK7YH5O0FS58.3OTH04TI72U0Q@nvidia.com>
 <c3532789-6b6f-4cc7-9d4e-cfb05cc88264@nvidia.com>
 <DK8Z3GD8IX2S.2GMOCJYCT3BAS@nvidia.com>
Content-Language: en-US
From: "Yadav, Arvind" <arvind.yadav@intel.com>
In-Reply-To: <DK8Z3GD8IX2S.2GMOCJYCT3BAS@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0342.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:21f::9) To BN0PR11MB5709.namprd11.prod.outlook.com
 (2603:10b6:408:148::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR11MB5709:EE_|PH8PR11MB8064:EE_
X-MS-Office365-Filtering-Correlation-Id: c49676a9-7067-452e-9cae-08deeb9ce900
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|4143699003|11063799006|22082099003|10067099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info: 16qn1c7ivKvt3YI2CDo2O5xWYhVXKL/NiDXhMH+f7H+hFgQYO6z27aKw4fSt2fcfAk6w2/GmvH7Hu9frmUqId/7IzwLBG7HuGApzLh3jITUZl969LD4r+Lgfp2fQhbwp/jxD/3J+9aeQVypWQ9C3sLoTiPDHPw2EEFcNGdc0e9Mr+l5OMxf7yiEFHdLf+rE2FfVbZHGZs9bnCKFqMMdUXJ5aLoOTSCO/1XVeE+FVszWHQFyuyAs64rFkkL2jlSAHy3Xas9397wTIMk4LmvbM6NPfTE06F8y1IzYLrHbULoIlBHMekIeC+oOmllOmOGBFo0cXQ+NRPCkRiuNtZe+JtEjW2X5K9NLdzxZyMU8aCo1ZGQ168xQ0qvZJquVg482mgEaYbt4FaHeSp6ZSL6bv+trud1PNIMvVmaYQ+CpEMXvIapd1SywPA/nTZTTuDhO8oTNVLmQ0MYndZTV0613SLKpSn0MVkhz4sDP+0zSrRJWIOx2hdTtm+YWF4hFanAdQRtWrExJb0S5g3dXZCTWjFg+NYKFXA2d9lmOwCygyAfczu2OVksGhbOvlI/MX5o+Y+Ys6uKC4TH9CaKBJwJ7j+PWWv65166OyEFW3HQr+3qs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5709.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(4143699003)(11063799006)(22082099003)(10067099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDZ0dWJBQUZGNGhOTi9YbERvcE9wRmZVM0lsbXFseDNiOHU0ZVJicVZFZkF5?=
 =?utf-8?B?TmoyV0dRam0xM3d3OUI2RFBOTnlKeWRUR1pKWitCQmxxUjNob1BlRFp0Q28r?=
 =?utf-8?B?RFRpQm90Z05iN1BrOUtxMUVyaUtMZHBFdjRSQzZ3cjVPdGliOWI0NXpoRlRD?=
 =?utf-8?B?N3JWTlRteE0rbUZBUUNYWG0yVWhvZzRYeFI2a1RRck1uUDk5RGtNaHlCK1Rp?=
 =?utf-8?B?RTU2QXNCOFhEWS9hK2FheE5rOW1oeXdYM1dkL0picHYxR1FjamZ5VEx5OHMz?=
 =?utf-8?B?NjBDdmhzeVBEMWV5SE1tdS91L2dZZ0VoMWh4bzQxR1k3T0JzeGZoaTJkM2dO?=
 =?utf-8?B?VDl2R1NXUXRUVmtGSjh1SlZlbnF6OEpnQjFidVFFaUNNYkZRWURxekRjYjRl?=
 =?utf-8?B?VCtMYXJoSHBiOWJObDZJNjcyYmVMVThRMUpMUjNRRFFKQTdQd0h6UHpDcldU?=
 =?utf-8?B?bVNQNWxrYVdwZGVlR1V4YjU3M2o0UStQNGkySHNkSWl2ZHJZUUFXbGZCcTFG?=
 =?utf-8?B?TkJzMUlOa1hBRm9KMXE1c0RRd3lFdDY0ODFNQ0FNYmlRMVZuZDdySEtDMUZW?=
 =?utf-8?B?MUxWdGVuY29ScG9rSWc2Z004Q3diSUpJamorMStBRmt1QkpTUUVhRGc4ZmZO?=
 =?utf-8?B?M3dHVTJHOUEyVGQzenFEM0R4enVqaDVTNGpSdm82NFJ4N0FFRXJ2UWFpcWdC?=
 =?utf-8?B?WmxZOThPVHM0eTUybnVLSC9CcWY2U1RvS1JqNmF5QXlyWW9YY1p0a1pkdEpk?=
 =?utf-8?B?OWVKOTFpd0Roa0JyOEJOaWZIQ2hvTlEyRHBHUGhTWUQvNis4OWxkWWJOTzZa?=
 =?utf-8?B?MHRiRmpUQURSZi9EYzZZVllKb3kvYktjN3hCNC9veDRjRm1oZDEwcENhOG4v?=
 =?utf-8?B?S0VBTk5GZUkwWjRxVzRyQzRXRFVUY25qenFncHFWVHhKRWFRcFVxVHRjR3BQ?=
 =?utf-8?B?SFJMVUU1Z1dKUGRGOEp3VEhPVDBPaDBEZDBjcmJQZGppbStXbUNkUFI2dHYx?=
 =?utf-8?B?Wmc0S0xMWTRUME1LOFNrUGw2ZllxTjBlTHlLRjFvYUlWMUpHMDdVV3NkRnNW?=
 =?utf-8?B?K0VXQ1lqTkNPQi9XU0ozL2pNVFNGYXB3dkVkSjMyWm9OQzhVcmRTNjJwL3Ex?=
 =?utf-8?B?aEhIU3Q3d2FSN0FtWEZ0MXo2OUlrTnFwZmxKQXljdCtWdnZDcTdpK0lZZkdT?=
 =?utf-8?B?TERnMTdncE9ZY05kc0M2TEVQZEhjVWRtZjd6TkxUNHJGZGNvcFBpdGJHV2hP?=
 =?utf-8?B?Q0Y4SHZjaGIvQ0JVaDlBVlc4R2RqdjdIb1BERTQxc2UrYzVQTEs0SWtPdk9i?=
 =?utf-8?B?SXZsNUpxeTA3a25nZm9qQ0tobDcrMzZZcWd1UmMvSUl3bFJNUnhMSGlac1pm?=
 =?utf-8?B?a1JKbnNCZHJqcDFLc3ZoUXBkbHFqMXlWRUcza082bUk5c3p0elFoWkJHTnUz?=
 =?utf-8?B?L2cvZThoQ2ErbmVZZWMxR2kwcWxnOVdPMkFzWHJhZ3ViYVRuNDVzcGZSOUJN?=
 =?utf-8?B?M2o0b0dCdTB4SHBYMXJOSUdCZXZOUlNzbkV4YW1xQTY3NHdtOWw2Mm9icFBY?=
 =?utf-8?B?UFF4cHR1cjNwKzAzRnhhMkovd1pEZ24zcGhvblNFWmZrTjJyeDVxTTdPVHRH?=
 =?utf-8?B?SUZOR25yRWFWKzE4anpzWldUN1FxbHQ3QmFWSzdIS0o0VGlZSUlDN3JoYVBC?=
 =?utf-8?B?N0l1eVJ5N3I1NDZid2puNVJvK3RYanRZalc5d01pVnpNVEUxMTFkSGpZYXFu?=
 =?utf-8?B?eUV0eEgvdW1CS0xtczhnYk55Sm5ZcTMvSy9OaElPcWpMVTJIa3dhVUhJcW1t?=
 =?utf-8?B?U29NSjdXMHNLRlFhYlczYng4K2pzSmZraGljcXVHZGJmN2dWWkI0SjhYcjlO?=
 =?utf-8?B?QjFCVE9NdjZ4RFcwdlgzSXZyUmV1alNZeWRHekpmMEsvRFA5SjlDT1pzOUIr?=
 =?utf-8?B?MXdNTENTVmJrMGhxbnVFNy95R1poSDRkYUFXbS95ZFhxd3MwYWE1NENNWUd5?=
 =?utf-8?B?MG5XY3FLZ1lQeEJqWGVRRlE5dFFNWG9JM2JYL1VzNHdrdHFSUGViZ0hRUTVQ?=
 =?utf-8?B?MkxqajdMV2pEMFk0N3dYeWZTM2xJUThtRW1GRDBFMmxqbFNsbnNwV0hDUHlD?=
 =?utf-8?B?Yjl4TzJJQ243ZDZYb2ZXVzlQc3l0ZkgrTG0vVmJnRS9YSURHL1dOV0IvK3Z1?=
 =?utf-8?B?Tk1wcHEwTklzQlg0ZXF2THE3MkpXOEZVSGFsbXdjOE41Z3VDVkw4dGxYVU1T?=
 =?utf-8?B?UEFUNDFXWS9PNm5Rd1VrNm92c3AyNXJVUGtXa0tzYTIwVEpZbXFEMmJGa3Nq?=
 =?utf-8?B?MGNUS2pEU3lMZnFjYmIyNUVVNnhueC93S0FTeE5wVkMrcUJwaWd4QT09?=
X-Exchange-RoutingPolicyChecked: NmTJ7uwEU+JvCjbf23Cj946qoR3UcObEk6CzJaWjiIF6Kq68LnMPkxdfjDENaDsEe7IfVLmb5SnneQ3ADpKWYmp8a8wI2AaPe9W3g0buKlBnNERgab6fDqPLJaifSmy7GLbhGBiP05zGxrT7bjeL8hi80s+ZxBYTwlKcqVwnsdL/5VlOAMspjmEdnuLbRvFomv0ZotAQ1DW7ALMgWZudGEaXYzum5b4hzW9eF11uk4BtF3RCqFqrwjyQyf3cKtVUGFyBanvJj4QM9bxzuoC6VJxXE4plENUgsxkL5YTxLqttJquiUPYoKwWe9oINZQpbtHdv7UxYb6CE+vH84c0ZpA==
X-MS-Exchange-CrossTenant-Network-Message-Id: c49676a9-7067-452e-9cae-08deeb9ce900
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5709.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 05:07:09.2066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QfpQBgl8fIb+X2ra0Dr8sRboaq6+WzpYMlZJA/FI9xfDf+0xwOEWrAQUWaj4xw/3e8MIX6m3Pcw1hoPrYugwRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8064
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 0426520008
X-Rspamd-Server: rspam01
X-Stat-Signature: 4ozqhgz46hh76tn4mbkpm5m7bbwjq65z
X-HE-Tag: 1785128838-525727
X-HE-Meta: U2FsdGVkX1/JpZ5XcJwo8Tv21fqt40vzGZhXp/mZRsx81fanQRizsRZNCsDCLUt7STzL0ui8ptluQXieaXDpPRu8c3eNZRSpLOWQXSCmsUGA1i+uQQlH7GQzJ2UyHRE1wLKX9qeHOnLpt2T2ZPwrqhw+4sFMU93wUzNqjGIdizUNgH3iUVtbHBul/KJhrc4GA0N6ESdbqUutcd10Dx52JHnX81jLC0lPeVdmKU/D7Y7s9KdXBK+894oQeziQyFEqNvuII/ayAKLX+4J8xEqpxfqT2e0wnO5E8BcEP9acUZftcGF/1Ki3V2C3TvLitHGxCpjrct4Ejhfv+Gh3OOZjjGr1BvaQm7kCN1N9q53dnYx3qwWfPoA7KAtqdqs+RskhtpXRTruf2xeKFpQtYW55b+s4rf+0HryZudsnStYuN37fb4tnQVPdsAtWpJ3tFuazcSy0VM8iFsHaqcY4iPMQv7eCSoGNmKGSbMrVGUNQ8ZVNB7lj1MVyVC9gE1pZh+OG1fH/pjONHVja2IMY48iWWJFGYrvYqYYm1z+2pGevZb59N8wTQcUMtv9UhOvtcXe7rWQNpDBLmlb/YK/pk2HvsZf9E0oSf+ASv2dVsAineSuh9gYhGCSmQBQoDfHRG4ve6qhsATQl3UN42Z6QGOoRyPbmWiZeI+KUvH7FGr8QRp9kP0P7EGuEQ4SqDuRfNKPY5NrtCG52MZ5aZCLC0IXhh+YcPl4SB4fiavtAsxn6hbpigmyvzaVPcUQ2fV1Sngc30pdnSBqktwlCL7cjXinI/dkHR6wZGCBhH+EkVV79u4wU1c47eBFmeUnDDdRPXJQZ4YQBWxrLNcZqEwE0gJRvKum94TPavW3LDkrYVI1bX119k6kZkMdcWeSIsD8hNOrM21FxPEQtKEiErVcX6/wdXkZvBW2MOR+VBlh74OD2UVNmvJ3WpXHg5P8V5WRa2Mj0YybiOVovMaMt1aNEZLY
 G7WGa5Ao
 Y1dECO2wnJtwFhQBeAlOsL/hZlm4jfesNGWq55tSscABor8034x/4qnFXnmJ237yG+L1ylcZVYXSeDZSdTZn9sm5hp6qKxrJUEOo58aghLb0czwowYQVoPczJpfYerdliFuMALoPGOlxgCw2sOYmVWeEnjFQejOPfNFJxdShsRZqS9gHiiuoKIVT3rXK0ZvZtTOMujNEYI7eMUIiNSv456pJ37GXiW7ak6se20dkWG3whZ872Qj6UxmHP8njqZ6Vrgoz8gRhzRBF+GOK8uCfzmsERA2xYe9Y3N4QwB2A3v3jIpn3to8CCb20LpngRC6q67B837afR7MNwl3eDeGm3zSs3IJ7THinCnxNG0moBnDrsfnhsFMOVdH99PpNdKVLDcOLOA0gbOgHUkMMgdXhFA/rqX9EhmcIwij8Ex7ZvWFe7oeODEM5dhxkI+W0/ZyxHodVg5ONVBdV1/F2dpAhSOGXL1izs4/suhCACHiix8kwEM+JUZg0x7QWOy3c9X2FU/Jwwd76g+8EBVTm2d+1izK5e6gn8uPScdROvyGkqJpQAVqpwQsgnXZuSVtAeihqbzywub7ngVV57BH69xwuLrNX3JRVQU5L0P3aD+WnngOyt9fc4iKX/L9Sxb3ENAJcDL+vjBKpdE7OQiC8SQqu0ASSNZ0IaWS+E8CZRVQSJT1NsG+mZHwTxwwNZxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 27-07-2026 07:16, Zi Yan wrote:
> On Sun Jul 26, 2026 at 8:38 PM EDT, Balbir Singh wrote:
>> On 7/26/26 7:05 AM, Zi Yan wrote:
>>> On Sat Jul 25, 2026 at 3:36 PM EDT, David Hildenbrand (Arm) wrote:
>>>> On 7/25/26 06:43, Andrew Morton wrote:
>>>>> On Fri, 24 Jul 2026 13:57:02 +0530 Arvind Yadav <arvind.yadav@intel.com> wrote:
>>>>>
>>>>>> __migrate_device_pages() reads the folio mapping before calling
>>>>>> folio_free_swap(). When folio_free_swap() succeeds, the folio is removed
>>>>>> from the swap cache, but the saved mapping still points to swap_space.
>>>>>>
>>>>>> Passing the stale mapping to folio_migrate_mapping() makes it take the
>>>>>> mapped-folio path after the swapcache reference has been dropped. This can
>>>>>> cause an invalid swap_space lock access followed by a folio reference
>>>>>> count BUG.
>>>>>>
>>>>>> Refresh the saved mapping after folio_free_swap() so the current folio
>>>>>> state is used during migration.
>>>>>>
>>>>> Thanks.  AI review might have found an issue with this.  And one
>>>>> possible pre-existing issue in the code which Alistair and Balbir
>>>>> worked on.
>>>>>
>>>>> 	https://sashiko.dev/#/patchset/20260724082702.2531024-1-arvind.yadav@intel.com
>>>> Yeah, this might need another careful look.
>>> It seems that the pre-existing issue can be fixed by resetting nr to 1
>>> after split is successful. It should also complete this patch. Something
>>> like this:
>>>
>>>
>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>> index 18d097c388530..4a77b6c86ae4f 100644
>>> --- a/mm/migrate_device.c
>>> +++ b/mm/migrate_device.c
>>> @@ -1193,6 +1193,11 @@ static void __migrate_device_pages(unsigned long *src_pfns,
>>>   							 MIGRATE_PFN_COMPOUND);
>>>   					goto next;
>>>   				}
>>> +				/*
>>> +				 * reset nr so that only first after-split folio
>>> +				 * is processed below
>>> +				 */
>>> +				nr = 1;
>>>   			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
>>>   				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
>>>   				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
>>>
>>>
>> Hmm.. I don't this error condition possible, migrate_vma_split_unmapped_folio()
>> will VM_WARN_ON non anonymous folios, but the design contract is for anonymous
>> folios only. The enforcement comes from the callers of migrate_vma_pages() and
> folio_test_anon() returns true for an anon folio in swapcache. So
> migrate_vma_split_unmapped_folio()'s VM_WARN_ON() does not prevent anon
> folios in swapcache.
>
>> migrate_device_pages(). Also __folio_freeze_and_split_unmapped() checks if the
>> folio has a swapcache and mapping associated with it, prior to split. I think
>> this is a false positive
>>
> NULL is passed as mapping to __folio_freeze_and_split_unmapped() by
> migrate_vma_split_unmapped_folio(), so the VM_WARN_ON_ONCE() there will
> not warn this.
>
> None of the above arguments is valid.
>
> One thing prevents large anon folios in swapcache from reaching to
> __migrate_device_pages() is migrate_vma_check_page(). When
> folio_mapping() is not NULL, extra pin count is only 1 +
> folio_has_private(), which happens to exclude large anon folios in
> swapcache.
>
> Regardless, adding nr = 1 here still makes sense, since why should the
> code below process the old nr pages after split is successful? It might
> be an optimization for current large anon folio only case, but it is
> more like an issue in the future.



Thanks Zi Yan, this makes sense.
After the split, each page is a separate order-0 folio so setting nr = 1 
lets each folio go through folio_free_swap() and mapping lookup 
independently. I will fold this into v3.

Regards,
Arvind

>
>

