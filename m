Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4351CC531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 04:04:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E101B6B0088; Thu, 30 Jul 2026 00:04:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE8936B008A; Thu, 30 Jul 2026 00:04:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAF696B008C; Thu, 30 Jul 2026 00:04:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E1FB6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:04:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C462A08A7
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:04:40 +0000 (UTC)
X-FDA: 85044101520.23.D3CA6A8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf04.hostedemail.com (Postfix) with ESMTP id 155C140008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:04:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CHFLeGjr;
	spf=pass (imf04.hostedemail.com: domain of arvind.yadav@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=arvind.yadav@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785384277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ImqZWhrD270TThTyIcP3SENcCyIIdEGVZYkLcd6LBDg=;
	b=JhYBNPt/TFZfWMkYHn4FWjCFovWy4X8RUGctoG5UAhBGGiAFADxYJemJjbfvChg0P83jjc
	8rb9WVy8Him35IAE3Jh/VJ46+aI2bkKnLkpOcf+ZFNJt5mPj7Cgga44raXtgnRJbLog3XA
	FXsIJJIIgpE/9Aw/29yHUiLXgM/4V8E=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785384277;
	b=dxlQogV/M1uTo24NwYh9DoiOjIRHg9jtlPN2YVyBaBL5zMYDetb5VyCroaSvl6Bk1Xkzmz
	yLmonpyniwSNoK4c4Us6Cy8J3Q9/kl55mjNtCDp+xNfW+GBeMKmYEL2pwE29M5Zi/GEsv0
	FTFaJuBouj/TB0iZrKKgceaABXx5e/g=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CHFLeGjr;
	spf=pass (imf04.hostedemail.com: domain of arvind.yadav@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=arvind.yadav@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785384277; x=1816920277;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3IPcurqQZ46ZtNNs2p1uuhLkL3TOCRKQVtBQzQNd8Qc=;
  b=CHFLeGjrPSTMla+G0zDjbCEYtBABHpZLp6sieDAz+eWrDR+cyRNX1cFO
   uWWmSgqRNh2mWverDoU5ZWP124aUwwn9lHqzbKmRicr7mBgb25DHEuwNm
   m9sbK57vhw7ZUr6e38ksdMhdRWC4sePgiEf8ZCJmBHXearw5DJd6ue6W/
   cVjgzwfoLPGzRZYuj2Q5Wl4gkXTgxcd2UZziJ7fNcx/FFRmucea8sJNbG
   Dp8uZn5RllGc1vJ2ogvs8DOgdfppI+oLY4AhmK4lq1XJdhueQrsaMY2H8
   T7E27T4zYmB3//KVC7tJOjTHUr1+W/LNWKvmaVCb+eT2Yne5O78LN+Obg
   Q==;
X-CSE-ConnectionGUID: xRhdB/n6SlaOfpxPB4G/ng==
X-CSE-MsgGUID: TjgY22jFQ1W81I0DDRIq1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="103402428"
X-IronPort-AV: E=Sophos;i="6.25,193,1779174000"; 
   d="scan'208";a="103402428"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 21:04:35 -0700
X-CSE-ConnectionGUID: zK6dN3OmTKis03OQ93Bjwg==
X-CSE-MsgGUID: Mi93aPpcQ6aD/mVQiQ/Hhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,193,1779174000"; 
   d="scan'208";a="264003108"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 21:04:34 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 29 Jul 2026 21:04:33 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Wed, 29 Jul 2026 21:04:33 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.26) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 29 Jul 2026 21:04:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UJS8ZRxXLGuDbvekUe0PbtDdNFosGXqmc4S69NpONqytMcV/nYrFeQ9eeUQo98bPM40jgJ2fX+9u+jvVJTsNuX7pDhu2IYNzTQANsELk3j1PuKB+EwfKYPfzNjLlEYGNGBRyT1Ya8UaSX36JukHX0S8PDHCMVmV303fkZTjVjWBlFltjxqpYGhkPNjpBBvKAu9tyjOzPzr09bGy9XKltZ7/lJjZxg+1m8E9i5s1aNNQZvJz98FsCR/tQ6svhYr7ZJwGuKYqGKFcmUfGqs8tbs4lsOOpgBebWX/LYtK+HCkTV3OGm+QQ6/ov9w/lWIuHqg+B7lpknMg0Ib0L/HtkrpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ImqZWhrD270TThTyIcP3SENcCyIIdEGVZYkLcd6LBDg=;
 b=ykxTd7V7QVAKXU+l36bQWq7RxxTHaCiyyimR3+NH4ctJVRQFgQnsru9EL/DQpPkX85VuszUDgs2Eljpz5rNZWeydwdkAMn3/7cGr8aID9n1F8fKO4zY5Q7hS7KgvvJE6vD7qgYjUKaWEqQaLxZCpyt/vV5PdmcA6n3WZb90m746RWEXRIZRMSvF7vvg/R9OCvzugYK97G0M+3hu7bVhP9lem3jqt7+17mYnxXJGsdDXQHjUWzTuhYevwjK+8PC3L6Zw+RKAlYYHzvcSSo6xeY2wliykKJJ+n0W0SnFuDzyXpjsUqBdm0quYkUnWQap4+K4H9l8pPzmR2jE3so9U1LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN0PR11MB5709.namprd11.prod.outlook.com (2603:10b6:408:148::6)
 by BL1PR11MB6052.namprd11.prod.outlook.com (2603:10b6:208:394::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.13; Thu, 30 Jul
 2026 04:04:28 +0000
Received: from BN0PR11MB5709.namprd11.prod.outlook.com
 ([fe80::ad31:3f30:20b8:26c]) by BN0PR11MB5709.namprd11.prod.outlook.com
 ([fe80::ad31:3f30:20b8:26c%4]) with mapi id 15.21.0270.012; Thu, 30 Jul 2026
 04:04:28 +0000
Message-ID: <d2480581-52b5-445b-b56d-af1bb9d71608@intel.com>
Date: Thu, 30 Jul 2026 09:34:18 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/migrate_device: Clear stale mapping after freeing
 swapcache
To: "David Hildenbrand (Arm)" <david@kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
CC: <akpm@linux-foundation.org>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <ziy@nvidia.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <balbirs@nvidia.com>
References: <20260728062832.1107127-1-arvind.yadav@intel.com>
 <8d50f94b-6d95-4967-aa1f-2c14333ffd85@kernel.org>
Content-Language: en-US
From: "Yadav, Arvind" <arvind.yadav@intel.com>
In-Reply-To: <8d50f94b-6d95-4967-aa1f-2c14333ffd85@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0072.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ad::19) To BN0PR11MB5709.namprd11.prod.outlook.com
 (2603:10b6:408:148::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR11MB5709:EE_|BL1PR11MB6052:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e7ddab2-d1e5-410e-a480-08deedefa641
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|5023799004|11063799006|56012099006|10067099003|4143699003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: lk6PXy6e1HjCRbbObSJcWx19OrBYR49l8bm1Ms1C1YMFShcOfccBxRQw74qcX5F1NU7k1xcIx9I+pUSL4gYoU0eTNX57UazrmU79LscNQjBM9hw/gTUUDznsxbU/DPg15r62raaYtd1SfFJdWJ62zUf9e6sgSNNmuJ2eNYZnBInxTvP0bVi7Gg7khFPZvY0dm2YibxVRxIqd3dGNnftS6Jg22rdcvYrNGfBPzDbEUqeKKfaEwmV/+XRz06K0yE0H/69Pr8nJGbki3OfDY7j0iRo+CQoD3bJHPZXFGPOyRk4v20VpcfUs5qv5xMRBHcmCI0I+sjXgJDjED94MPN5Tpxc8Gav7fmLLSnebc3DspLbiCKYBvbNpmcAFA16tNu3yP3HXhWr+JyTsa0NVtIQ8PKJDipM1b/Ej5DBwFsA8vBWjTwQVrxrz2k2JFVOIxh7PtzzKaT+rYmIZWXm+d0Xb9MhgWO2XSTEoVVQEWWso6euGC8xez1pFNUHi8Nu+5rj7ZiEv/9sBR0I08bRQNehWfXsm9lZFdrY+XnkdMoWrQ/h9AnGHOxM5ni84dGRUJBH26+EWh8ctUNHoxgU8lfF4n5nAewdu98Eipbb1tLUHN0JgbfupL7488Ai5KcHG9icK+5J2OuZT4DParDUhn7xAsr3H5pk6h+r1K4jaV3TXDGA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5709.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(5023799004)(11063799006)(56012099006)(10067099003)(4143699003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2hweHRibDBvRDQyL3J3enZucU9sVDBpTWcyR29oaFhrS0NEN2g3b2NJSGRy?=
 =?utf-8?B?TG0zS1hKOVN5VDFoODh4T2MvYStYSmFqU1cxM2xiVnNWMjk1bFZvU09wd0tC?=
 =?utf-8?B?OC9KRUJ5NE1yamo4TW5NVUFDK1dmblhDYWVaQ0t0MVIyS3A5M1A5L2hnOGZY?=
 =?utf-8?B?elpvTDdmVDJvQ1lXNHp6TGhtUnZlNFNYQmlGT002OExIMGhHNzZoY3lyVlh2?=
 =?utf-8?B?RWY2UWRwZERNdC9zUEhLQWJMWmJQVlVudDMxZTRPMUxRL0hCa2NKSlpkSmpV?=
 =?utf-8?B?Mnd3em5KNE9BWXhENDVtNnVPM09qb21vUDRXcEtoR0hxR2dqOXhlbVhPZWFp?=
 =?utf-8?B?cHZ0MytteEgyUXNPd3pHZ0hBU3BqanFJRGJWdUtESmI3NXRhZlEzMVFwSi9i?=
 =?utf-8?B?L3VzSWNXdXFXTHhWdXFHbC9QbVgvUVB0clBoSUNLWXU2d09jdEV4b0M2U2N0?=
 =?utf-8?B?VGZ1WUNLVDR6OEExY21OU0dvcDdETVZJbUwxZ1V6S2FxWm9kbi95Y0pQU1o0?=
 =?utf-8?B?dTNNUXVEaWE1dnNLVzhPczdhbFdIN3MwVll2d2dGQ0s0OXhZZ09idnZjaml4?=
 =?utf-8?B?MEdBWDNtZ1VnUHNBY1kvdXdHMU94YzY3cnJSM3IwcXFlQnh6eXZESW92RUpy?=
 =?utf-8?B?UkRPaGdZM2hTcXhRbkZJRW1iQkNBNUVtbDdyRXhhbHM3Uy9IeWhtNElyK0FE?=
 =?utf-8?B?c0dkTlZCU3pHTlBvOTBKMGloMSt0YW93aHp3TEhJZDl2MmRHRWxvMHJ3NTVr?=
 =?utf-8?B?MXM3MmlmZWFMOXBkOEM4ZVVpR0F5LzBTWDlkeU5XZ3RmSXh5R0pIL2Z1bEs2?=
 =?utf-8?B?b3M4U01ZTVFsNThmYVlvakx6VGx0a1B6bHhLZmE2dk1Td2lZR2VrSWtJTTFG?=
 =?utf-8?B?WmtQZE9RYi9ROEQ3dysyZnozcW1qOTBhZTJOQUtCbnEzRTc3azF2b045cUVp?=
 =?utf-8?B?Um1sL3FxclR1aHYxVFJhbE5SOGozM2NBTHBXbHM2eXRDV3Z5dVZYN25NeGtq?=
 =?utf-8?B?b1BrS1ZTWTVFM09yT0pIODlMRWlkR0JLTEVFeUxSMkRSNWhhUWF3dEdhYUo1?=
 =?utf-8?B?Y2Q4NURhT2hTQk9zd1J0Rk9nb3hpM1NYb0t4bktleTc4dkpjZ0hWQTRDREN6?=
 =?utf-8?B?RVRJNE1uY080NXJPM3IyazlpRnRTdG0yTjJ4aEEybE5sRlp0blplVmQ3TmNn?=
 =?utf-8?B?QnI3c3BzQlU3WjhObDdpcjFLcXJxeEtwOWwxSHpUQW9pUlV4WkJVUDZ3OUp6?=
 =?utf-8?B?aHdiNXhLUEZzM2ZFZ2tDNWNKS1BndWo4RkgzUHIyTkR4bFlvYzFHS2lQb1Bu?=
 =?utf-8?B?T0VNSmtWemZSZHpoQkszRjlnSXNyOEh0WldaR0lvNkJJQmx0VzBhZ1VCbXlQ?=
 =?utf-8?B?Skp4OFA2bHdKU0JBOHMzQkhzNjRLSkxSMWpqd1puT21zN01lSmdmQm0veWVj?=
 =?utf-8?B?Mi9XVGs4a2liTHFZdFpEU3MxYVdDSnBneVVjYnpTR21VQ3UzTGx3S2RLUU5m?=
 =?utf-8?B?OWZsNEthV1VtbXpFL1FTRE9tUzhnc2owdUF2YXRBM3JuZ3kybVVuWHFoTzJ1?=
 =?utf-8?B?ZEtITlJxb3plalk0Sm11Q29IOWZMMFIrK0J6TWNSTkdSWVVNU2RwejYrYWV5?=
 =?utf-8?B?MFFzM1RIRU1IZTZXTVJ4N1FWR3l1ZktVakpxSXRQSytxSFFsUHA2WTY4M2NF?=
 =?utf-8?B?WWNJNlpJOElsR1lXTkg0RmEzdW1nK0F2akRhVFZURGxhTzVtRUxjdnc5aG8v?=
 =?utf-8?B?elk1cXdDai8yQXRURVpHVHlOaFloVk5yZmFJUWNXZGVPZ0hlSmluNjNEckRS?=
 =?utf-8?B?UUVVbk9MbTE2R2xQdGpsWUlWS1c2dVE3cGhBdnUzUVdUajR5Wm0wem1HQVZa?=
 =?utf-8?B?d1pOTDVrRHF3UmlabnF1bWprWElEa0RlbXo2bXlSNWcwSUFGQ09yUzZTOUVC?=
 =?utf-8?B?eFBMbHl1WW5UTFVrY1pBZGRScTJQRGNxdEdycWRpdmpObFBHVGhsNisxWDM2?=
 =?utf-8?B?Y1JNR0cxSzdUUUd1dU5sS1lua2hEd2VIc2pPMzhlSG5uOGEwNW5YazRRUVpS?=
 =?utf-8?B?a1VuekFjMWNwaUdBcXY1UWlsUGV6WlFoR0NLWG1VRCttS1NqZ0RCUnltbjBN?=
 =?utf-8?B?akRMd1JNVG85SVd1SmhpV0pQb0M1NE0waG9GZ3IwOVFxeFNQVWI5Y0NsWVRh?=
 =?utf-8?B?S09KZ3FXa29EaDY0c01XMUxMUXFkWUFwOU5STkJyTTlDNXJLWkV1eEN0MWtj?=
 =?utf-8?B?dm02U0dUUXNVUDVOWDdWNG5MSGRGK2hnWlVIa3JtY3o0RkMxeVVyRFpHWmtP?=
 =?utf-8?B?WXZCeThCT2Nlb2VJSFg2djhaRU1uTzNFN2RCeTE1R015dnJwbU9iZz09?=
X-Exchange-RoutingPolicyChecked: BqYG8ss2KRJ+M82whKR33/9DTXW4EklOPn2gbHiW72CzkTVlKPVUemfpKt/6yHHUTIzAkLZj6kxvgjvEnPpf8tL2OMgHETAhWwaWK+UXxjHTm7b6CSyCpYP4/UgYGNUWXbSeGsdxg49/NyYXXedqD3XQE1WQDXjREXdPQlzL2Kx3vjh1rvE/hPFZbtK8sdYOGUMzUbJ8nyMhuF+wuIbzXfHMDens9xc3ZpcPEOk24udEKjsw3jmFDM21dCPAZE5ftoJ2QWAU1gLI1XGpYiiGuXXdSIyHFOMk8H3poElg46jyrLZovfi2Ggb9NzMSnhIzF9c4mlFu8d+FxcDg3Rrrrw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e7ddab2-d1e5-410e-a480-08deedefa641
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5709.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 04:04:28.1488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MLx5fyqMBolRO1qA54GOw5KkBLRumgxVKuIUf1H4keYiRBaiIQnbisqjxJJkkYyK3qZh8MkbWZRhBu6/WVPRqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6052
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 155C140008
X-Stat-Signature: uxr5ai85uj5np1brfeu18fb7rsgs81rs
X-Rspam-User: 
X-HE-Tag: 1785384275-190387
X-HE-Meta: U2FsdGVkX18vc5FoPC1AW4G1xWIarxUk7RIIxbVUs3Iblx26MBdyCu9vrkBiFaARPX2tQ7QYY8zWEPehkGwxB1TUJqXPU7pJJlwFArpKDbWYwxQS/OM8QCt+WZxpHprVnBIDImr4b46h6EQcxHdion8LLb6mQ+DhrANIaUT62cuKo9EZMCPQmrqMdFez+JWJA0giJWOVS4RYRpi0Us3m5E0kgX0gD5n1DhBNSFsByAm29YgHLwwpsffaqonH4uCAIkwuOIplBP8dsypdhMiXJsZm7IzCdE6uux1Du5AElt+H7i8O77d/ZBgzYgz8v61zBfsgOnZ0EMDQ+OqH38khrh+ZHyNr2Ne0RZLk3YpaXFiajiUNe8p8G0RvruRa9/KwMoKGl5WGwjWsBut1UVvMcRLoEcuC5jdkKq9h+8OuM50SYN81hnwaDeR99JIjC77gotojOeAZwMJTNZ1YWxIwn+Kzhh4XZSexjYjxSt8by1N45CO6nUGkbq2+0zRPNBpceHDcQm54Zg+QvwgSVj5B1jTHtv9l0e8cJLSAj5Ef0E7/fXxzJiUqxrLbwKEioEHUqGwHdKqftFoUV9RqXMAQFpwdzxM1Mm1BK5yVUKzks36pRXq8YzwtYzHYspA8H1g7+hLBm2Ru+2lBR/Czz6LCpB83LP2lkBA/LpHcozq/dXzConCPfTmkf8MGcomj419Jx6LTzNJtffqvLmAeYd75vHG1NRIS/v3jSKkaXL09giKerpnn7bYtl2WhSJG0pejtEurcUHQtWRu4xxT+XNtqzWhiCW8RR2Ac6kaZ2pPQGkpEiKWso0Wd6ms5DhKnC/9OcpouRpcpXJPmZzgNg3ru5GGD/we6NMOXH3apv/Eh1sAgz3gX1+rXvEMbnspMhDlEwNRHsaTRLFBuJg5wIzN2JfeM+0EPK3LUON1Zc5Ak64wfzK2V9jGny3dOkDsw5d5sHw4ZXdJtJotT6YESreT
 NiWyX3HJ
 pp007jl2hjfV0AcdIYnfsHJHQG1E3eQrUoVMu/PhfiSMVTYSiypYab+r+X3e1LHW5FZ6jO4POddFg40wNy9q/aJc3AQ8WBlSeM37QjGE2WRQ9LkNmyEYUCQ/HcT5+pjHqlhCasarxIrjBMO30LnUv508q/o1WL+8gzU0ROggsNx/PoG8WgW99M0Q8vtsBGObxjnh3eusPsoPKjRESvhu4RJnNRHACkzrPFKMC2um+0Gd8M2zmaAGEAs7GNoK94TZkgO8Fuhj++AOlPb0Ce3cZ07rRWuuEIEZyUkXPfq3O1Lc/HFL66AYAE3a5Nq3NDgtB4Gl1Xa7hCdsTezbKjQUIfiUN+vOA0SxejGIcGAi09SzZgBmIZI3R9xgmKrMHFWz/Cm+E+S/KldXuBXh8Xi7O/KSD+wN1TaIS2oPrwiYVQu50L+Gynle40UaIo53LaJ98vgZGUOE2uCQB80LbtkKYdMns7l7Z/fZmXxDjD/zfGVlNQ5s4RMn6d8nRTEsW0V4EYqMEfnR06R9LIESkoGl+pRS8o2NV6qSWRN6NNi+GGrsDUcy8L3FQ0mtGZkpH4WncYyi+0lZq7EY/vi94ZNbg2f1HV286zpe8LywB3rO6xICWziRkTldP/up5E0jVDnezGUwUhidKrqV/WH0VUGZmVHPjDIYx8TZJyv/iGB7m8/mgSGTxEBI7KehXXMsz4gOGTm6Vcbvt7pLBmEEqv5CfshhRjI9OYzIvnXdKBN5R6YNLuGH+tMZI96VDwj3cPXgOMLkx1dTaoHxogytUidDitM16F3W/3MI6lfhEVsDlnFpJpKZCVLyRK6Cn9N1SGWKOzA8EhIwudEjDc/0AIFW0yuM67ZnMuW6hy88R91a/ymFhMB5EZVh9oASo7JdsFKgWQ/cU5Zy4tgzxb90=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 28-07-2026 18:20, David Hildenbrand (Arm) wrote:
> On 7/28/26 08:28, Arvind Yadav wrote:
>> __migrate_device_pages() reads the folio mapping before calling
>> folio_free_swap(). When folio_free_swap() succeeds, the folio is removed
>> from the swap cache, but the saved mapping still points to swap_space.
>>
>> Passing the stale mapping to folio_migrate_mapping() makes it use the
>> mapped-folio path for a folio that is no longer in swapcache. It can
>> then operate on swap_space.i_pages with invalid reference accounting,
>> eventually triggering a folio reference count BUG.
>>
>> After a successful split, nr still contains the number of pages in the
>> original large folio, although each resulting page is now a separate
>> order-0 folio. Reset nr to 1 so each split folio is processed separately,
>> including its own swapcache removal and mapping lookup.
>>
>> Refresh the saved mapping after folio_free_swap() so the current folio
>> state is used during migration.
>>
>> v2:
>> - Refresh the mapping using folio_mapping(), as suggested by Zi Yan.
>>
>> v3:
>> - Reset nr to 1 after a successful split so each resulting folio is
>>    processed independently, as suggested by Zi Yan.
>>
>> v4:
>> - Re-read each source folio's mapping immediately before
>>    folio_migrate_mapping(), as suggested by Balbir Singh.
>> - Add a warning to validate the post-split order-0 invariant,
>>    as suggested by Balbir Singh.
>>
>> Fixes: df263d9a7dff ("mm/migrate_device: try to handle swapcache pages")
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>> Cc: Rakie Kim <rakie.kim@sk.com>
>> Cc: Byungchul Park <byungchul@sk.com>
>> Cc: Gregory Price <gourry@gourry.net>
>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Balbir Singh <balbirs@nvidia.com>
>> Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
>> ---
>>   mm/migrate_device.c | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 554754eb26ff..0e6f00190fd8 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -1182,6 +1182,13 @@ static void __migrate_device_pages(unsigned long *src_pfns,
>>   							 MIGRATE_PFN_COMPOUND);
>>   					goto next;
>>   				}
>> +
>> +				/*
>> +				 * reset nr so that only first after-split folio
>> +				 * is processed below
>> +				 */
>> +				VM_WARN_ON_ONCE(folio_test_large(folio));
>> +				nr = 1;
> This function is surely a beauty. (had to rephrase that sentence 3 times ;) )
>
> migrate_vma_split_unmapped_folio() modifies the src_pfns() entries on success.
> (and somehow assumes that it's always a THP, what? After a MIGRATE_PFN_COMPOUND
> value is set? What? Why the "nr = 1 << folio_order(folio);" in the caller).
>
> If we ended up modifying the current entry in such a way, shouldn't we just have
> retry: label and restart at the very top of the function, where we just
> naturally re-read the entry/page/folio and do the right thing?


Agreed. Since migrate_vma_split_unmapped_folio() rewrites src_pfns[], I 
will retry the current entry so all state is re-read.

I will keep nr set to the original folio size for the split-failure 
path, where goto next must skip the complete folio range.

>
>>   			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
>>   				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
>>   				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
>> @@ -1221,6 +1228,12 @@ static void __migrate_device_pages(unsigned long *src_pfns,
>>   			folio = page_folio(migrate_pfn_to_page(src_pfns[i+j]));
>>   			newfolio = page_folio(migrate_pfn_to_page(dst_pfns[i+j]));
>>   
>> +			/*
>> +			 * folio_free_swap() removed the folio from the swap
>> +			 * cache. Refresh the saved mapping before migration.
>> +			 */
>> +			mapping = folio_mapping(folio);
>> +
>>   			r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
>>   			if (r)
>>   				src_pfns[i+j] &= ~MIGRATE_PFN_MIGRATE;
> While this looks good, I do wonder why do we have to supply the mapping here at all?
>
> Is there a path where we call folio_migrate_mapping() and the old folio (folio)
> does no longer have the right mapping attached?
>
> It would be a lot less error prone if the function would just obtain the mapping
> from the old folio.


Agreed. I will make folio_migrate_mapping() obtain the mapping from the 
source folio and update its in-tree callers. Since this changes an 
exported helper, I will send it as a separate patch in v5.

Please correct me if I misunderstood your suggestion.

Thanks,
Arvind

>

