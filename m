Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4696D711CC
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 22:55:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3AF56B0088; Thu, 18 Dec 2025 17:55:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE8BB6B0089; Thu, 18 Dec 2025 17:55:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C922C6B008A; Thu, 18 Dec 2025 17:55:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B496E6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:55:21 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 664EFB7E55
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 22:55:21 +0000 (UTC)
X-FDA: 84234099642.14.2555C30
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9238DA0008
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 22:55:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KZx2zH0D;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of kai.huang@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=kai.huang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766098517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=11JRg8hA1v7YNjJralMXf89DsbK9tM7Ga5+JRPe44ss=;
	b=jlXyO9JmZJPTNaVue/xBP29lERK53sTtzn/BeTM/rUGCF3tUN/UsSD03dtv8zw4C525Glv
	lXl//pFkds7Xt3QiGWrTWIgA6wWdE38vFYMF3D4AtCYz0aPmuQBBz6WxZYCuru6eD5lIOv
	2/EPM3bmfxt67Qd2Tgtww7MGplXgL6M=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766098517; a=rsa-sha256;
	cv=pass;
	b=cl9VgAErYYljo7fNKL3G+isHqs7ukpjmCJsSscFhwM4yj+kUSl7XmOIFz/YpSs9dTto/sc
	7e2jwrlX+e9d4zD7znj2G2XY8P0dLXHONFu/QD5TA1PjJoUa65jbfvvTozsGxV2hhotFC4
	BezT1Z1fJJwmD7Sw4etLW8/coG9tOe8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KZx2zH0D;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of kai.huang@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=kai.huang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766098518; x=1797634518;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=11JRg8hA1v7YNjJralMXf89DsbK9tM7Ga5+JRPe44ss=;
  b=KZx2zH0DuMkpG2RWufSHCWDxhyN4pXSMK+f9RY8lljpk3zjq2yfHw0kb
   q8ERxUu1G+G4IW91SrXgPUDix+4f2/wzhXOD8H6SMtzf7iVVkEWO/7dBh
   TA1cRu1GSqHxMDKSXU8ncn3XADgMpdUDRTE/ciBZo8Tl2snxbrDiwkBHX
   k39iQAjL1BDGggg1qWbGAF+8N4eW3aVM6cK1dADcdhZwOXD3tlsciC0ou
   E7qIxNvZKSxR5vDjDd+0VunVrcLgFbdG96UfQC6HKaOQKOUK+KL/UYk4K
   V3Ki7n5edEoVI7tFwj9zvhZETW1ZhzCDxF/INF3FgR5t+4yI8DVDpInMq
   w==;
X-CSE-ConnectionGUID: SklGwS12Q1mCh/zI2owHEA==
X-CSE-MsgGUID: iqxfVbf8SiSzrAKZwDALpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11646"; a="68100619"
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="68100619"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 14:55:16 -0800
X-CSE-ConnectionGUID: ecfdZ6xuRgatFMdlU4mzeA==
X-CSE-MsgGUID: ACR3HXISQ22P/YHX1BaZyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="203612293"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 14:55:15 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 18 Dec 2025 14:55:14 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 18 Dec 2025 14:55:14 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.24) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 18 Dec 2025 14:55:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vtcanZ38CBMkgEXxD705PC/Sozf2DthSUUd5rORwqx9E+uWHhnMU+ygIIne6scNmcA8B7Ak4wUlrCdN7pLtyfdZOT4iT+A/ELywZUpD4o0tWkADt4B4vJzdb7bgmetzgaTzzjIiOoaBBmWUPHG624uTlAu2bCE40gmXhB8JIZ57mE4QfojWSlGIAlhn1XklNDlIeoUm7KAYdqBn9VgrVquvTAbxCRfijNAUo9Riz/LbVJcocEklPvhdC2gox+LTAkJiv7LazjfMhJqw7aiDiTyj0D+amRC7BQnQRQyCGJIujP4Au1PNKYZxoF8FJKhUt1nwXj4vIjdPvaKeF37l1UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=11JRg8hA1v7YNjJralMXf89DsbK9tM7Ga5+JRPe44ss=;
 b=N9LEWXUeZF9/houBP4kCoSD13VhwpAeQttwwz13gOy+5nZDZtnJTtGqFBpwjR7++uVBRZP/QCQiAWl2bm8uKFdkMfFPNQfgmrxTZ/Fs3O9U11M0dAKTOFoikUfJK8QfA4XhJnf/0QiYomBP3n2WXBmPawTcp1K+i2FB65Z5kaPOgYvIbEobyeqwxDuLGMNHUd+eEzsJUzj1Tglvz9w84urN6RdJb9H+MI8YitBlAZWzzx3loQNaXEw/VvysX2JQ+UPg3Sq62h0E3AvtweFtqMRe/Cpe2HOC25iO2+aqnSkORzrAHRxh1uVtOI1SeJrVuawKelRLbczbOBeK1yUEyiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS0PR11MB7444.namprd11.prod.outlook.com (2603:10b6:8:146::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Thu, 18 Dec
 2025 22:55:10 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 22:55:10 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>
CC: "david@redhat.com" <david@redhat.com>, "liam.merwick@oracle.com"
	<liam.merwick@oracle.com>, "seanjc@google.com" <seanjc@google.com>,
	"aik@amd.com" <aik@amd.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v2 0/5] KVM: guest_memfd: Rework preparation/population
 flows in prep for in-place conversion
Thread-Topic: [PATCH v2 0/5] KVM: guest_memfd: Rework preparation/population
 flows in prep for in-place conversion
Thread-Index: AQHcbdhnozmOvIsW2EmNsgKlh+EZubUoBwSA
Date: Thu, 18 Dec 2025 22:55:10 +0000
Message-ID: <2fccc3c69b20352a7a1558e12991a9b37c582dc7.camel@intel.com>
References: <20251215153411.3613928-1-michael.roth@amd.com>
In-Reply-To: <20251215153411.3613928-1-michael.roth@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS0PR11MB7444:EE_
x-ms-office365-filtering-correlation-id: 640b69c6-45ca-4993-b331-08de3e887f27
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?S1Q1ZXRSK2kvT0FjVTFIbmNucE93eHhwWEdJOVJBdTZBdzZqMlVvdGZ2aWF3?=
 =?utf-8?B?U2NJOEZaYThKa0RmRFdLbnNLRG5pMlhtcVN1YlVtaDFsS3NKQzVQNVAxRDBs?=
 =?utf-8?B?VnV4THN4ZHY0UGRsZ29ZUDErUnJnTWxXdzdwMEV5TlpMOUR0Qjg0TC9iVnRY?=
 =?utf-8?B?OFF0eGxIM1ZZb29VcjFBaCsyRmRpL0xKLzFVVjRMQ0RUdWhJTFQwbDNsS2lU?=
 =?utf-8?B?NjdmWnhia2xVQ2JNWTVId3RndVlXMWN5endJY01mR0tPUHZMQWF3dVMzVXNj?=
 =?utf-8?B?RWh2aGRWd214OHo3TUl6SW53YjlNcjJ0blZXOVhsWlFHdU1TWjJSMW81cS9G?=
 =?utf-8?B?c20wZDMxbGQ2eGFtMUFSTE96eXU2aXo2UjB6cFl1TmtZMGJFdnNEQk1nUEY2?=
 =?utf-8?B?Z3psK2k4Mm0vcWszVHcxS3JPRnVMamxWSzlyMkFKcHZRWWplMXBCaW56NW5R?=
 =?utf-8?B?SWFCR21pNTBIMENlU05NK3VoK1ArbzJsZW1Nek44a08vTFppbmN1SXJNWUhP?=
 =?utf-8?B?WkhjVjhUclppdmMwR1puSCtpRHBFNUhsRm85ckdDbE9GYVpCSUlxWDFRN3Jo?=
 =?utf-8?B?bEVES1ZnRTBsMnVlbmt1bDhWU1daODJucDcxeGNlelRlWVllU21aSlM1dVFq?=
 =?utf-8?B?eWRNMUZuVEhIYStlcURHOUwvYUdNN1ptWXpJWlF6a2VCT2lrdVVWY0pYeXFk?=
 =?utf-8?B?Y2NDcUlVZXZwQ0JxeUNWdUdUTDhvMEN4bGQ5bEdualRzN2k2cUg0MGtjOWdx?=
 =?utf-8?B?ZFpZaHNqUTJKQ1Y0dnFJM0tFODVyb3Nvdm1ITTh5LzVMNG1WVm9wRko4b1ZK?=
 =?utf-8?B?UVl4L2xjdkpMbjl6K1BMblpnUVdJeHRPQ1puZWxjT2NaWmNKb2xUN1JNdFQw?=
 =?utf-8?B?amxyM08yd1d2bVhWWGVnTExRZEs4K1UvLy9FdFdoVU8rKzl6dTF4ZXNCRUZV?=
 =?utf-8?B?N2JUMXQ2WWJvaTNDdm04T3BsY2JNejBCbC9aaElYaVZhYUVZQXVKSlREYUhW?=
 =?utf-8?B?Z2xmSXVza2pVV0FHMkdHUzgrS1loVTQ4Mk8yZjhCejBFVndBTlJ2QkFtMjha?=
 =?utf-8?B?YW42NlRwRzVUTHZDdEdXckwxRWx4TUI5RnIrdmlSVTR5TVQwMWpsQW9yUVNp?=
 =?utf-8?B?ODdLQUlLR3dueTNZNWRlWHB6aUtUQlM4KzVmTjB2UktuVDV6QlNRZkNMYWFP?=
 =?utf-8?B?NHYzaWV3SWE5eXlQN3NqOWp5c0VBZHdON3VHRUpvY2podWk2WUY0NUNJczZT?=
 =?utf-8?B?MlQxWVVmdFc4NjQyY0hqWW9CdFFQRHhQSStmUmppMlFrYmZHZ1BDZTF2aVJU?=
 =?utf-8?B?NEc3RjVwbVU0S2xkSWNabGJtWUtoYXNTU2k5TWlheCtVWnJzblpEcEFlcFcy?=
 =?utf-8?B?bnVubURmNUgzTFMya3BuMjZqN3NZY1FiZyt2NUFaN2R4SDl1MFFybExiTWRv?=
 =?utf-8?B?ZkQwMlAzd2g5Rkl4aEx5eFRZVFdtc1RKQUdGeDlORkxFUGhVT2xJcFhJS05B?=
 =?utf-8?B?N2k5NjA5Z3M0VklRL05xZnlmSjhjL2dRNTJvTVBCRFRzdHlXY3VmeHVnc3ZT?=
 =?utf-8?B?MjZ6V21BcWtpMTV0U3ZaclNISVlBdFdQSUtuNmZPb3JVckllZG83SktIS3li?=
 =?utf-8?B?ZzgvNjhwOW5yVnRsaVdncTFvZUF0NW5iVG81NzZuRFZNeGxubnBacVBCVGlu?=
 =?utf-8?B?T1hxU0hwTXFudTlHQ1FpL3czTnlYM2djNU9SUnRBU1o1R3ZlOHZQWHlJcHZr?=
 =?utf-8?B?SmZ5RWVCRWJvalY1aWQyZGxIaURiOXZrNFg3RWRPdXZ3ZWdxK0x0WDVVU2h1?=
 =?utf-8?B?cnRRNlhxZEYvcWxWSmxzc1Rmb0drVWZaRStOQ2pPYVo4bFFsNXdwTElnK2ZT?=
 =?utf-8?B?UzJxVVpYRFI4ellTT0RLaVB1YU0wYytubVM3OERPRm5lUFlEemRpTmJvdzVH?=
 =?utf-8?B?bDlGL3FWMHBlMEZFUUJIL0dudVZUWVI3QnJaeXZub0NMZXFSUmNHbnNXbjVZ?=
 =?utf-8?B?ckJpVnlUY0hkeEpBbXJtdmVqWlRla0RIWXBIdWtPMG9OZTYwSTUzYm8xczZB?=
 =?utf-8?Q?OanDUL?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmZyWEFMdXhwaVR4WE5pbHJUeEYvN0c5aTN0QjI2cXdITnppTXBjdkpTNldl?=
 =?utf-8?B?eElxdFpFOWZ1RFJnQXIxclorYUtwMng2eng3ZEdyNzBhOGJCSUJ0Z1BwOWxO?=
 =?utf-8?B?WnJ6NUxweURNL1FrY3NUK1hDNjdUN1FGSjFNQWNFVWQvWU52M3NsbERsdXFH?=
 =?utf-8?B?Y215a3FtSTZTYTQzalQva2tTbHgvenRtTm85VkVXaUhCVnlsM3pWaWlsSmZM?=
 =?utf-8?B?VCtTV3NGajFBM0RJVFg1THZLMXVuYVNTNG5ma0RvWE0yR0gvaDB6Q0Nhdklk?=
 =?utf-8?B?WE9nSE9NOVR1aUE3QTNvc0RuU0RwVE9IMktkU0NsVHRUeDJJQzJ5dVIrYlBS?=
 =?utf-8?B?SmhMSkkzUjhjdWgxWWpCRENzN3JrZmpBWGtYeDRzL1luWG1OUWltTHJYakwx?=
 =?utf-8?B?eTZ5Zm93ckZvZ0R2eldLb285NUMyUWtXOEZPd0xELy9pRnZvSFdqRWw4blVJ?=
 =?utf-8?B?RUFoUmprYktKNTc0Z0lOcC9CMDFtU0xVZUtBTEpFTUhRN3YxeGJseVdUNTJm?=
 =?utf-8?B?Vkt1TW9DaUpJNXcraFRVK0hlWHU0UDcwUkNCMk1zUWszTFRpcmU0Ky82cE5j?=
 =?utf-8?B?eWFlN0t6b1ExcFNHaGJHaGIzd2syNEtWR1ZwRmcvYU5mWC9GekdiTWc4R1ZK?=
 =?utf-8?B?WnltYXpvZmNpY3YyNjZWc05Vc21pWWxubjk5NVVETDJNd20zalZRUE1FWTVH?=
 =?utf-8?B?emNjYVMrVks3aGZJZG1YeWhLMFlsNXM3TTJXVzRoWnlkMzU3Q3R5WEdQd3kz?=
 =?utf-8?B?OElhOUZNZGJManArU05WeDlGT3RkK0VnSjdmNWFtVThhY2RiM2hwclVoc1JS?=
 =?utf-8?B?eHpwN3cwSml5VDkyaDJSSnh5OEdmVm40US8vVDRQRzloODlrdFE4b2JnWFo3?=
 =?utf-8?B?RDNFditrNXhLVERmOXRuMFJsTCtlTlF2TXZ4VjVFRERtWlFsTU4yZlBuanV4?=
 =?utf-8?B?TnJnV2grV0VLVE9hQXhkclE4VmJLWTl1THpRcGpORVdkcmhVNnVIL0JpVThP?=
 =?utf-8?B?NFFheVVDdi9xSk4yWmsxaFJ2ZDRCclhwRzdCMTRmOURwM3hnUmtMT0VieEx0?=
 =?utf-8?B?bVhhanNCMnVpZDhQR2xSM2IvRWxvT3M1ZTBHU1QyY1dldlpZSnlSalYwdFZO?=
 =?utf-8?B?dkVoZFdNczRmSlZEbXdVR3pyYUJqL2gzeGlZZ3NPNWM1ZDVFd0tRZFpmY01Z?=
 =?utf-8?B?SHdaK2pnSGNIY1l4RVdmd0RYc09CamZTYWtER1dkZDRid2hwUGdWMlY1d1JN?=
 =?utf-8?B?S1pnYUFPREZvZDJmblBEbTJYcG50T0VYVUIvV1VsUmw1djlWNEp2cmQ4OGxk?=
 =?utf-8?B?U0tmREJMT3JjZXArSytqNnR3cGlHaW5EcERvclZuejlJRWtGSGRuV0haWEtk?=
 =?utf-8?B?M3cwNEpGTG4yME1UdklYSEtUemRxUGh4T0FkdklkQXljSXZaNjNHM01NbmF2?=
 =?utf-8?B?dEpSZ3hmWFVtMHVtRnhaQTJ6WVNpVTlNajAxWmNXNVpDVlljVk05UDhrZ3ZU?=
 =?utf-8?B?Qjlvc05aVlNDL3V4ZFBwZUN0NTJmY0I4dDhiRVIzUldybFNSODE0RGxaRjFn?=
 =?utf-8?B?MWRlNkk4NlhuMFBWWGQxa014d2E4V1pSWVh0eGhMeG90ZmNMbUplRWV3QStL?=
 =?utf-8?B?aTVOVDVCa2xBLzQzdnd4aFQ5ZnFxY0xSR1d1dUI3bkYvOTUwYzJHbmYzeUtM?=
 =?utf-8?B?cU5nWUlMckM3WkNaNUorVUdYNlZ4VVpvZ1kyaVlBZGVqd0k3VG1XeGlXb1Zk?=
 =?utf-8?B?U1lHY1p2dDM2RHpINCt3cUtIZmJPV2tWbk5xdG1UTGlwNkY5TCtwZ0pRVldB?=
 =?utf-8?B?a3dXQ08zQlpsM00xSldHZ3YwOWQ5RUtSUmNoWkNiNFlaa2Y5MUVraW5XTVZY?=
 =?utf-8?B?UlpGUG5Za1dPOVZ2Q05sNnlHL1NITXVZUXBnK2ZoQlltVzgrOFErd0tyUlhV?=
 =?utf-8?B?Q2ZsM29uQWtxUURUdk95dUFZSTdZaDFXR3ZETFlPTVM0cExzZTRRWlhRZGgw?=
 =?utf-8?B?ZWZJWHUwSThINmRRQzY0N3hrTERiWndqL1dtTEI1MG9FUC90ZC9WZEV2L0Mz?=
 =?utf-8?B?aUhMVk9DR25iQ3NXai9OT0NuNU5aYVplQ3dXKzB6MjZLbFRnWDV0QmlsaGZo?=
 =?utf-8?Q?qyanznRvCw+eIt316uAQBIfst?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <20A66209422981448EF0B86ADAB301A0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 640b69c6-45ca-4993-b331-08de3e887f27
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2025 22:55:10.2848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JiLEc1Uo+2OPknH/etPQ5fjR8AicgGOyFJNQhSObYeWMltTDYvrjrZsBS0IkntIH47DYlKilZZDBWqZJo3Wj5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7444
X-OriginatorOrg: intel.com
X-Stat-Signature: fbpupyk48gcecw18ucbc91ttwgqa16i8
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9238DA0008
X-Rspam-User: 
X-HE-Tag: 1766098517-46409
X-HE-Meta: U2FsdGVkX18YYu8gBG0H0GVCMUEU1k3EP2s2vNDAMAPsdYzCrQ7QCS/DqxvDbqlMV0OBSO+xI8I/RX3XrXofhgI1OwgL2QA0HV83o+LA65zPao8YXpwINbT5PgApA7jXfzHLjcvPW9Ypno6B3g2PjNvVrE/KsSsqI31cU1kZjSRS8pomZ/2fbgRnonPgycqDIhJM9TmEyKEjkJPfe20Rve+CwaV/eqJCcghZnq923UZtp09+7YAXOxlZC3dPpvoJbKf3oi5z28Ow3L064r1Rf9d+nLnMWzQ1zM6nlud2/Zf584LhiUQUKPQ1PwyDZGaE90IP9NOeXPNvsKADeEcfywmm9Ka/mvVB0+YqBdiuDRkHf0ng5/e2hAc46Z1eUikN4GDluVJ2RsBdsDmpkZFglaMZCf5uuMHVvshSnUFafXMeEF2baoyWPXb9BrAXf96pmLt3ZwIt7+JiDlV6AJWLNkAojGGlKdWaCllZC9INIyj9j0aucKM2ALrwcYaof/KBK3bjbN4rM9llChthYUxSHXBQUJa5RK5YP6qnNS7XmcOiC8Yb1BLFyY47uTE9abrj03nq0NUuMXNCHjPrraSlQHfyp4TQx/KpjAoAbiRPeZeqdxwJ9lnDCJzzGY3CcYF9FiOhzkcjrYM9CqLEFzvU7oN0uNJ4MQPib4luQuYXOIC5pK2DsB1wXm3/6UCR3+oN9Js3T9KcxU8OQvcdEu/a0gU2J8ZuvJQ5YjbcB0d/oV4p5fKcrh6t57xTKWLF+WxFnGtPlG184aeAnDkRSFX9ngfCu1rO+s6vyTfKDjO31k077yxJSbLOJHImCX72F21bSKOq1Qug0/+M2ZbsNLJTQxZLLn5zRZHiosD1nWzvWwiwoJrzzafQIbtTrWax/NgU7LSOCb7CyQxCgh7lNge1B0X1Lb8VIYhTf5nbxwVun4PZLS/UJIsc48TgC/mhewm7JEqt1pJkhggIRNnNLzA
 fRLrpIHK
 L6BHQnw8pMSNfXKoCvyaXuCoY9RXjjQafqFU6d5v81pKKZqiOzUYtjlfJ/lWrDpXCzgZ91EJuNPLuYgyguoI3ApbcjwAUjLRillXcr4YAGdfDJEsUu0CAtNmNnUCOv47KoLMInuexRd0od9kAXXSAjr6wNvtjdWENCKyNutW6Tl1eAW0NGKqKT/LQR6F6ZJ6pZgqLy1ebeeMXkQUt51ILJQk6MtrOCs04ZboiY+toTl3ny4pXD1HaGP3dY1XKJadv1JE5BpsJRdTYYA5qb30c5m0H09Dy6Lb4yRGVXIloN0pq9RZOdj5S0XBTPZMC9kI0OFT+kwyd6iH77pgaJVwz3s4cC7Z+qLrJRyjsRByt+SKy3TFd07X1XCpzGsYBzZvLMf1P+m2e77a1nknrwebl1+4H/X5ODfB6FIkuTd/9MeCSzg3UoIe7j3rdpMLNdJO4G0QTwgTr+UaBsxspdpwSEV5sRBWV/5s0INW7Q174hjMvlBf5DeMONzaK9YSNQa+E9AaHRY2PC9hIy3Zil+fm3SjKvDwr1rkNtocBbJct8Dj4vi/uezFfZ/oBnTtUe6RgE0i/ZVP7c4CSiKE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gTW9uLCAyMDI1LTEyLTE1IGF0IDA5OjM0IC0wNjAwLCBNaWNoYWVsIFJvdGggd3JvdGU6DQo+
IEtub3duIGlzc3VlcyAvIFRPRE8NCj4gLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiANCj4gLSBDb21w
aWxlLXRlc3RlZCBvbmx5IGZvciB0aGUgVERYIGJpdHMgKHRlc3RpbmcvZmVlZGJhY2sgd2VsY29t
ZSEpDQoNCkFwcGxpZWQgdGhpcyBzZXJpZXMgdG8gNi4xOS1yYzEsIGFuZCB0ZXN0ZWQgYm9vdGlu
Zy9kZXN0cm95aW5nIFREIHdvcmtlZA0KZmluZSwgc286DQoNClRlc3RlZC1ieTogS2FpIEh1YW5n
IDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K

