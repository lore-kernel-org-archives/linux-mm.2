Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16B39C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 04:49:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F29966B008C; Fri, 31 Jul 2026 00:49:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDB526B0092; Fri, 31 Jul 2026 00:49:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC9006B0093; Fri, 31 Jul 2026 00:49:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4B4F6B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 00:49:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05EFD80324
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:49:13 +0000 (UTC)
X-FDA: 85047842586.10.35514A9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf17.hostedemail.com (Postfix) with ESMTP id D148540009
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:49:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mWpUzNxa;
	spf=pass (imf17.hostedemail.com: domain of arvind.yadav@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=arvind.yadav@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785473349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OO/wPtINfLytUMA17He9ZljzRrR33u/djuiUrTqfuYc=;
	b=V2LxFrdyvE1snAxmgWp8WqltkljEyaB1pIxWVDzCbatZ82WabDX0Le4YJKPX/ZY1wrHZK9
	cYL1vc+XsLSS6GavoWaEZ7yru2OWeGEKPJmkHxiSRtVbFpjZNTn3oH7vz2yJhvVVuoRuLd
	8ZE+6/66b7mkY8TK1+qFEvj7/EsvVXw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785473349;
	b=szXx5UWiDRbQav30TrpA+FRlflH2AS2maBsEzNHqa2NMpvuAUiA7yoLrqPzd4w9gZ09voo
	BbSbguiU3x46dtCziV3qyayXOOm1WOUicKuQwfxQtG2hhe49eQJfbJclJkvt/KxA740I8C
	4BTq049LWz5vatFLUaqYcutQPxVdQuk=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mWpUzNxa;
	spf=pass (imf17.hostedemail.com: domain of arvind.yadav@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=arvind.yadav@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785473349; x=1817009349;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cujvupvGarfcr8EIXniP/y3MK5OmfUMVt6nadOjNwLo=;
  b=mWpUzNxaHPUDpkshN9R/jLwZ6O7Ere8vInosCts7yCF0uL3ri8JCcraa
   Ut9ZSFyiUkS3R5PRQhVd2wbiWTAX/FjAlU1i+PSLcSG6f5abGZW09JDAG
   s9aI/bNyKtcL3kUlNvcJ0YlX9u8nPgLOYh4zg/gCsbr0Ie/Re17w3Ef4s
   Y/lTjAeIbJEkTKoInYQeumdKRLkVCM2GdRXxOCUYPFSi4FvgUZSa3DvKE
   7uJDsF1PqvGnfQWP7ye5l8YNaX0kgO+JWXhQC3Niuf2rsmJpceu3p4FUb
   R9kyz7X5iS1URDBnwq86cZqlV2NLDxY8UdeOtEhU/hlQsbEW9icRz6INy
   g==;
X-CSE-ConnectionGUID: +bae8fMZQYqAgqisSEXbJQ==
X-CSE-MsgGUID: jvwRRBJJRQeUX9QWQ9IbSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="97255054"
X-IronPort-AV: E=Sophos;i="6.25,195,1779174000"; 
   d="scan'208";a="97255054"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 21:49:08 -0700
X-CSE-ConnectionGUID: T5yt/EGqTqSm8DXy76Rf4Q==
X-CSE-MsgGUID: KMMy3elSTNeYHci+ndC4TA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,195,1779174000"; 
   d="scan'208";a="298688143"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 21:49:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 30 Jul 2026 21:49:06 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 30 Jul 2026 21:49:06 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.26) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 30 Jul 2026 21:49:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zvvp9WnKooH0meG1fRSKZOB0VGFRqp1KjBXQalSbXjlbCjEDm75my41bLvEYs1W/JqN+/HHX7rd/MmbmJEYAMhFYPNjGZOhAUgzTa8G/NaRITwGRaimiYDNe/33K4IlJypBv/e+xB7hDDmVPHofPMqsmrWGyo8xZMopC7K//33nCu2HesFxl5Q5ys2x8MgKMUsofeOwajCjyjY8eyXiJHVa8wbQzVbtHSvVhFWNZSM8ZPCxKYiJlQZbh12UriCfSC8T+wAt/65uQa9jancL3FEDIl+mRgFI6lo5jSau7Q0+GlwM/tOLj4Az6z90h/p6LHzXGkz/J41SmSbA2qYaUWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OO/wPtINfLytUMA17He9ZljzRrR33u/djuiUrTqfuYc=;
 b=OF3mvlux5lmKitGdKoZoi85Sdx+Ukc9YYkox77UngNHE9zIiZH+7BW/m955cIb0GeryaosXzViyrv8lPQ/JY+y/JCB+XkJjgTVDFcJaJ3zhV14ZhkFXTWJFuGOhLwHVcO0UP7mSBgoro6CQK1JsyjaGVcxdbvXx6PGwfbOYLVhKUi1LDYoiPwX9RTHAKlhMDGuzynjprU4snvdcNxkaD3tLjh699gfujwDN+YOqpzsInZW0mq7X0vNtiMYi+qTJSSJIgiWCMpZv9wSXNsOi7MuGVohTNeM3qP4uMiSSfYqxmRBLyP6kypO8acuvPd6lIdQBaPydT8mLgLNT1Ebp8GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN0PR11MB5709.namprd11.prod.outlook.com (2603:10b6:408:148::6)
 by DS0PR11MB7384.namprd11.prod.outlook.com (2603:10b6:8:134::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 04:48:57 +0000
Received: from BN0PR11MB5709.namprd11.prod.outlook.com
 ([fe80::ad31:3f30:20b8:26c]) by BN0PR11MB5709.namprd11.prod.outlook.com
 ([fe80::ad31:3f30:20b8:26c%4]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 04:48:57 +0000
Message-ID: <cc5658b3-b5cd-4cc8-8b50-8df8d62815d0@intel.com>
Date: Fri, 31 Jul 2026 10:18:47 +0530
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
 <d2480581-52b5-445b-b56d-af1bb9d71608@intel.com>
 <86119f7f-bd70-428e-a6e0-eea7cc907bbe@kernel.org>
Content-Language: en-US
From: "Yadav, Arvind" <arvind.yadav@intel.com>
In-Reply-To: <86119f7f-bd70-428e-a6e0-eea7cc907bbe@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0087.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1d8::16) To BN0PR11MB5709.namprd11.prod.outlook.com
 (2603:10b6:408:148::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR11MB5709:EE_|DS0PR11MB7384:EE_
X-MS-Office365-Filtering-Correlation-Id: 012bd823-cc50-4ef6-fb39-08deeebf07fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|23010399003|376014|366016|1800799024|10067099003|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: HBLT9dGWC6weHMtoMdmDCRmAlKWo2V7Ctby+xZjFIB1t0+WtvYlPBiCYCWhaUdpfX1QVQ6jA65YWPG7hsjgU8/AtvjD1QWUhe90Bw1BJNDcrhs4Nl4pdsRg4GB04XWdhjelB2VCmLaPdEyveOPgFMcHXqHkv1wWPjnzB7TCduMrVfBL9B4sKluga0E6Q6ylIi8zAJY5QAvsGzfX64y9tYBc21XSZ3XZWLA8qF2zae5i46N2NG93TLCsECC8HcpbdVeR7+2Krb1OMCTCaO8skD8/X1bqRBz6e0qzv/1NVF+kO4QyhZnWAb55PcfveHeLI+JU0PHD+0ugSULwivOzrYx+xE+vuDuAKSrSNBz5wi8FB+4zWYaaNU43sLN/f3JF6BFbmveRg1tPZhJhv5KySUAW8rvdbunsQFobS699edSfkreR2R9YRNnBe93nPxNrDEPZZWkvBF/Y8g3ZkcbZOTHHRCxndrTE/SVJ/ez+LFOxBhT98od8kQv8gBbMDbScYREppR21e+JppLF0my0gfFg2coeYwTMpL/nFCOikjXThjmo/iDwXOBiKU671GP4/UABYV3vZqxIDM5XIOrKGFGF1b20JWK2Fju2iBILUw7Lp3WGHN32eruc0Q3GtlpvSmMefskqCLn7SFXwQ8GmzxY4WWxBC4/XVNHqseIvLEPp4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR11MB5709.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(366016)(1800799024)(10067099003)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmNSQWFneHhMY3JHQlNieWdGZkJETlpsalNoTW1FSDNDYnRtenhjZ0RQY0Jq?=
 =?utf-8?B?bTd4T1VYZFowcXRYMWkrRlV5Z25VOUtwYkxHR1ladFAzSU90anZCT1dFZk5F?=
 =?utf-8?B?RFA5WVlZbE9UTWpxVm04SThZMUhWZnpya3plNjR5L0xsczluUWczNmFzRDNj?=
 =?utf-8?B?cHpMQUFCS3Q2RHVqelNHRFFpdk5wQjVQV25idldNVElHcUI2T3c4eXlsd3RT?=
 =?utf-8?B?RExxOGYyNEpxODZzUGY3bEd2ek1PQ2xMVkU5RzcxRU00aXFsUzVsNkZjZ0VE?=
 =?utf-8?B?UEdPWmNRejRmMTAvTDQ3MzFxRXN4TXdLd2RSM3c4M3lQbnl3Tnd6UFJZc2pF?=
 =?utf-8?B?Sk1BVkRDT3lBYlUrOHVGdURHZCtMaDN3OFlGSmR6bGsxV1NMQ3dxOXhEL1Fu?=
 =?utf-8?B?UlRCSjhUbWVhT2pnRkZwTDBvTFVTaFRpZ0lzNnZBakdaaDZuVDR2eTYrTTZD?=
 =?utf-8?B?OUFoeDlxS3FXZXNBd0duQWdvWGt2clc4VG9vcUNOZ0JUL0dnMlhSaTdhUWVH?=
 =?utf-8?B?R1BtVEowM1RpOVQvNDFsRDNINWtOejR5Ymc2OXJNQlduZDBVUTZDUmdvVUIz?=
 =?utf-8?B?eDdKbmhKRHN0WVVwcGV0YVRvQnp1ZkR6QUJyanBlbXdLWWt1QjdRVVdiWStB?=
 =?utf-8?B?T2ozemM3VDlDdlhYdy9SRjhWWFNMSE50ZUNubWpmVUhRTFNGYTd6WG9vdytm?=
 =?utf-8?B?UkRCSVZ0aXd4V3I5MnVySU5NK2JZdTk4QSs3NEE5QkxhZkV3ZWpVMHA2UWhI?=
 =?utf-8?B?RjMrQUZzZWFhK1dKMXpjYjZUd3JTdzM3Y2RyOTJBWExGNytYMGFDNU9FdzRi?=
 =?utf-8?B?dFAzWGR6b2Roak9STHRZTnRraHNrSUc2REZLZngwWGVjSjBxNUI3S1MxcXl2?=
 =?utf-8?B?RzBSbEtuNms3bFZubXdBays3NGQwRUNjZGhBMjFES2YvLzJ2MGpidURZVzRp?=
 =?utf-8?B?akdyMW9VWjVKM0FZY1RVdk1zWHd0bzJqc1J1aVo1bXc5cjVpQmpKR2xhS1RI?=
 =?utf-8?B?KzI4Y01qbnV6L2xwam9ZSmVSa2lCdnpXSUJodmovcjlLbFhEQ3dNdXV1R0Fn?=
 =?utf-8?B?RzFDSUJPNGozNUNVY2JHKzZTbVB1T2ZNYmYwd0xnN1pEc2RXR0pXNHB1bzhD?=
 =?utf-8?B?d2VUWkJ6SVNjcGNldEFhZkYyOHd0NE91MDJWYnBrOU1CVm1oQjNjUWhGdjRm?=
 =?utf-8?B?WmxXYk9reXdQRks0MFZYYklWUmpYT3ZDb21aOGR0ODJ6U0lOK3VpYlVNZkx0?=
 =?utf-8?B?UFdpaldqazBGRXFUMnBjdXBsWTdzaVZNY0VFTVRhUmVEVjVSOEY2OUk2QTV0?=
 =?utf-8?B?NnBqOGNyZDFialI4UWxWWk4rc2JJcnoyWXFWVnljOVEzVFNhdTZ4eXpCYW5j?=
 =?utf-8?B?T2I5OVJxc1hmczVnSERUWitoMC9kRnlNNmdWK3pIejBGWjV1d3UxeHhDck5W?=
 =?utf-8?B?RUxLWWo0dkh3OHB2M21QY1JIK2ZRTXZHdEVNaTFmVEJLc2RmUGM1bHg5bEVq?=
 =?utf-8?B?Tlp6ZENVS1Zkdnk5WnNoWkpMREh1bXBqUVh1ZmVzdDFhQjFOZW9RdFg3cFVn?=
 =?utf-8?B?dzkxcWYxMHFncXVJMFRBclBNaW9Xd3ZmU051YmRheFduV0Naek1VdkR6REhG?=
 =?utf-8?B?VVoxajBmaFY5MncvbzVVQ0FMbFIvbkU2WVRWaHZFSjJlT1NIMzFEMjZ3YkVu?=
 =?utf-8?B?cDZOMG8xaHBSeU9TY1pqNW9KYW9VaUxVaFBBMElLdGk3UEJ3Tm9saWUvSUkv?=
 =?utf-8?B?OUhXdXRVOGJWeC9VV1p1NFd4emxNcmpMSjlmbnhxOEdwWUJ6aVZ2V2JkVjJ4?=
 =?utf-8?B?K2RuWDhFNW01Z1g3RTFBQzRlK3hrQUpkTFYwaXBiSUQrYUZvR2RHNkEwV1Fq?=
 =?utf-8?B?ZlFSM1kxV0c4RGtZWGE4ZmlhTXBZallWenVzVUxUUVRBY0MvYmN6eDRONENu?=
 =?utf-8?B?bTI1T2tzOHYzWVZXTHFsenBxMnhES1NWTHhhU2ZPUStrTUhsRUhBRnhXNStP?=
 =?utf-8?B?RFVpK1NvRG5qbE1OMlgwaWpMZzZxYXc2MUhjTDhmOWtqbnhlZGdGcVR0NW1V?=
 =?utf-8?B?VGdUZHJhSmJnY212aG1QRy9HenEyd3Ftd3JzM3huM29xSUpYWnMrNmVMbjNI?=
 =?utf-8?B?R0ZUcFNNbzhXc0NNbWVZMlF2b3JlOGQvQjVVVzRkeFFTZUpvc2ZVdHFIWmNx?=
 =?utf-8?B?N2FpYkJEbzh6bnpRNGE0TzZVR3o3K1JLWVFmWlpOc2pYb2M4VXFzM2RJNEx4?=
 =?utf-8?B?eitxU0U1SktBL3BhTWE4dkIwdWVBcjBZRWYyNTR2eFJHenZhZHZpVGlxUEhk?=
 =?utf-8?B?VFBBZElTQ0JMdVJ1c3Qwa2dTcHY4eGVGNWFHSkFpVnhBYkVYNjkydz09?=
X-Exchange-RoutingPolicyChecked: PnwtOHsT4dLE5e5p95SseJ7ugR61Ee5icJAb4ge078Lyc/ZVJz8FRV2cxRSKxyiA5op39UgJN76ZbVZ1jA3VVYaUmuoztHsni0QRaN+42Z+X3NsVi5I9vlT9dvJlJdLAQFmP9b3ayyBOZ2fdwz+xGpk+454Bu3kNHEQ0NfDKJMVEijzllvWq3QUallvEAa/j9/IHDVeMoeEUehxj4fRfWRQ8+Ey9ymnjAZ72nFpUvFWREW9FNH6b6deOZv8t9etV33Wclmx+84YfFUcAjy9nS1Ny4hDWg5LkJW2btekjX6cdQX7tYiZ1KGF3JjFdnq5Rt4F9ny0w4rvh7kkfEFvhgQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 012bd823-cc50-4ef6-fb39-08deeebf07fe
X-MS-Exchange-CrossTenant-AuthSource: BN0PR11MB5709.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 04:48:57.7646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OV+ZF9DB6Q1w1SoaO9x38XGSg7qnrfh6YpHHZ0yhxmQcRz7Oo0LUJX1d6FpCOVuDUqLGDrWYYuoQiWF8rPPmpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7384
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: D148540009
X-Stat-Signature: h4mwqicprj8mzkrgi747qcdy1xozxono
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785473348-374167
X-HE-Meta: U2FsdGVkX1/JlMGB7pCx3MbgY0K7oFvOOmHNfoG8mJ0EZV+fjePFCg6xDRU/X5RlTDkEMFy9nGSoVWnGXnhD/vrgv9YGuMBffGFzfG/eSHL/F/3piEsaQglbIoDZuV7+8X6oxYP4z9QsWoHBOkMW8v9h4e1ZBJguN4AMUqUL8hfM5OpkCiwGNRT1UezNhByJVFjPVMs78SXgGzCe1JtKUJ18LBHJVgArQ/KIWCPU5zf+ZhSWXwoN2fpn4LGdRzZvAtYCvCARNKSVNsCDwjtb3ppDDq+pSv2ryX3XFuwutunsfUXjoYbDQKkkqSpFbnCZg5ojybgXYGLNpsGs7PAVsMD2/etCVY3xK7PrtOH/yEuANWl6APnONyjUCR69RJM6lrOy/go6Z+4woWmOB1fG/0hOgnO2NT28D12f3L23LxwZCnF+2nlt9++Hptg28ub36ycNtvDclgb4wM6vOUtH8VwgjQGo4VfdlA5AR0ZZ0W6BghCxHzAYsaLh9nW8zsiR+RPw77Yaiftft0e2CnCaxcXw8KikvVkyJL/bAwq0vtKbaDB3R8OeD2HiJBwwWS4BuYVRFxatakFCosju4TyIDEF2GT7UNxr2x6+flsF4d9NPpP+T6cWUX/xScuX/ql4fA2idQxi7KHaQ459rHvBNGvQk1yrtIA62Pa6Z0pOirod4nai8H2B9ezrm+OtayFCb2vGtct/J591TFnsu036lmBhvIA3z/mX347ruPrf8zxYEe6MMfpEYay9Whvy8ewGHuzGBhL0q/IJyllzg7iA70IlnDUn+tGqYlGlemO6HtxubXnOouSKoQfI5vIPpCrU3zCW/P2qG9o2vNGHOBh4B3JGnc7/40LrQ9/I+kh+SM0vtxgqC9frcqEEg5l/PEXNTYMS0d8X2HlAncs3+zMBM6hg7jPId1ujkDjibB+fbtW73keLcThzZDx8TtJzTR8UbdbJdL/PAPB+Q/0kaOJk
 x3YMuKgG
 TwE/K92QIG81lX+TWbNJfS6Htfhi/vzYc1Cs+rW7numfQ00ABIJCUkmJZ8Y70CMWRAOzGVVfveav9Tfyk+ul22IWUbn15JKwjvA12o5wnEYNjtPdm0Cl1wZO4I1zVW+RokRFVTNNtYBlIPkv6gSY4Al4GmhZJMLtj6Uebm0/9h90u9a30WXt/GP7nBerXcdPCFEZ4T9pNK+aEo9vO/p//19CYCF6zkjhTqae8fXLtOr5EgChC7A4YUeTMBusuS9bND5X3exDKi4VHcp8dCBPeSsHSEYqOKETJuD0w5OZGgonbmDjxg7afmUGtVXQWVL0uAQlSzIIOYZQPp2IvrA7f17ILvzhLuXgS39hfjfHmGG7cR0iuBjqHrDrwiZeRjpVAkYXBETzr8GKO4RPJQi9gftP6jyeuGNnZodfvU+pRbcMuQG2HYB0kgHYOjh+hlKJnR6ZCOtFw5wiUR47mzUuFG3J2/KMVUtS5Q47w9mPFUSx62PQeSBmP90m0VIRRchM8jgLYpAhr4BatmANTkQHdb7UWyIXKpOrIOmbg5mP9o8S2CtH/V+NeSfJ/eQSF5NbgY6bkwXPCFCzC9Su1VoTDl6t6AWWl32BWoayA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 30-07-2026 18:17, David Hildenbrand (Arm) wrote:
>>> While this looks good, I do wonder why do we have to supply the mapping here
>>> at all?
>>>
>>> Is there a path where we call folio_migrate_mapping() and the old folio (folio)
>>> does no longer have the right mapping attached?
>>>
>>> It would be a lot less error prone if the function would just obtain the mapping
>>> from the old folio.
>>
>> Agreed. I will make folio_migrate_mapping() obtain the mapping from the source
>> folio and update its in-tree callers. Since this changes an exported helper, I
>> will send it as a separate patch in v5.
> I think it would be good to understand why we currently pass in the folio: was
> there ever a reason to do so? Or why do we pass in something that can just
> easily be had from the source folio?
>
> But note that that should be a follow-up cleanup to the fix.


Thanks for the suggestion. Once this is merged, I will review the 
history and callers to confirm whether any path intentionally uses a 
mapping other than folio_mapping(src) and follow up with a separate 
cleanup patch if needed.

Thanks,
Arvind


