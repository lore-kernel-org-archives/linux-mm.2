Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B537CFD376
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 09:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C62526B0026; Tue,  2 Dec 2025 04:18:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C12926B0027; Tue,  2 Dec 2025 04:18:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4816B0029; Tue,  2 Dec 2025 04:18:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 94B3E6B0026
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 04:18:43 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 34E8C1404F6
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 09:18:43 +0000 (UTC)
X-FDA: 84173980926.05.89C27A1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf16.hostedemail.com (Postfix) with ESMTP id DB707180008
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 09:18:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FugwcYyI;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf16.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764667119;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OC7zITKVFsDf5TSeqXovisQZJiydFJTbiCxotBdWX0I=;
	b=H4xo1y2U2hYwBVcDRERE67DtZN3+YV3f0FpzVH0n6fOMCRy1gUwcnS6Ow+Hy9OFTmlVNHr
	n7UxHCjBWKrJGyYqsZ9H9bPOgkoR+As5aG3nCRCccja1vwAIh59aNmdocshNka+mBxA8Pz
	rSRa24KbIE8RkKXEHhjRkuDe5kC9Uac=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FugwcYyI;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf16.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764667119; a=rsa-sha256;
	cv=fail;
	b=fqkKSmcxy46/PYtkQEtp5e7eGUjr+l/3zMrfvetcvX76tEz3n+TvVGrIE6AJNzcgQd4Zp/
	D5z+AEeV2Nl8XNX6qGjgrHHesjuGyAgaRhwi+s3WhafIbmQnq+GbZP1Cx+9uhHnyhOa0Xx
	a1QwqOfwN5KsRw1u5WtdNvurmZvglWg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764667119; x=1796203119;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=OVV40PoFrC/QX4kuaghgWzgz3sLQUWhC+/+1Vpp6PWE=;
  b=FugwcYyIXHymOxznTaZmiFlxhrQhtwartxj9+9QHJOxTPvFDeBtiYVoI
   WZm0iawG6B1770lahEjSbmysfyioYHLccTgkvVAFzamR/PMfp88SPQp3k
   /miDEeef2IswZ/SkgQrAdJ0KHe/bAjjaXvRnz/pSljVK9ur0AP3W7i9aA
   AHWu7DzzZh2GCdHekd2mCJlS+4b0c4zyy1UFolpGVzuHBMbNd8x9nUDf5
   olfdKyFnyu2Rus19wsSM65B3GlSyO/YM3/z4jSrt89ih3B5wI0bKrEHY8
   hQxBZjcN4K2LfbgdCyuacSQrKOVjWM8hkZ12l9LD/5qpOxmc6bU9IeAPO
   Q==;
X-CSE-ConnectionGUID: swZa+sqlTcCCtkQkpMUvnQ==
X-CSE-MsgGUID: gzcIrAPJQ/q7PiHw+9u3zg==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="70242897"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="70242897"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 01:18:37 -0800
X-CSE-ConnectionGUID: zm+VIKdOQWKh0Z/BOUUfNA==
X-CSE-MsgGUID: BVHFOeaOSB+cYPi++9YGqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="198702498"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 01:18:37 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 01:18:36 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 01:18:36 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.71) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 01:18:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HYBJLln+bV/LAj6vlKdz5cCzrB9O0EAwT2FFGk+BdGYUULMhXNfMsDeus0sQAY5UDNx1lAmWnFESUtZiyDkVq12g24GRtYUE8cpVzSG8UfCO7CkyEJyb1YPhloBKa6s/Xy8ISzeXmHfZnZUtx7d3R3yO22lV2gyYwxCTBFXv5xWkEWtssttjqT85FDVtKctfE0D2b44pJI/MHiuS78BMvb04pwMvLyym9nsQ1GZRP+I8BwXMiDaNbkmZHARTRT1PvG9SAnOwgdg6nn4fx+2RWqZZAac9MihRGswc8bPdR/2X7WL3gx0w0GiEjiBy6xKz4j9zdglop+5DLYy53y+2Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OC7zITKVFsDf5TSeqXovisQZJiydFJTbiCxotBdWX0I=;
 b=Nvku1eDPs0QxxphtyectPpZkNZ5pyhic4VBLCWVuRh9DrWi/fFvfE1HRxwzz0mHJjse+iedpVMa1eCbE6CU3ZSWH8j1DWy9o2Yu4Rp9KxbMEFVsSVSk21djAAqwsUeWg4pETNB0xstcKBwpCDzxhLmeioQ9jx54SSk0esGuCfJwYm3iAWdoa1Ek8cUa07XNuUz1XCrCfpMP1Ldgb/+nQKrpw1ffvXlcrV+1N7v2LD8jciKGlmDjufyTQWBeXCH5CRrrgFf6fbdPcZ8q2WYC+wOj1eTh9STzmm86KhaEMDnSmXzIfSmQw1ekoKoBdNLhhQHDl8JEQYiWK87agW9/03Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6989.namprd11.prod.outlook.com (2603:10b6:806:2be::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.17; Tue, 2 Dec 2025 09:18:33 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 09:18:32 +0000
Date: Tue, 2 Dec 2025 17:16:37 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: Michael Roth <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<ackerleytng@google.com>, <aik@amd.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH 1/3] KVM: guest_memfd: Remove preparation tracking
Message-ID: <aS6uFyCd0+qSKeFf@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-2-michael.roth@amd.com>
 <aR7blxIx6tKD2xiQ@yzhao56-desk.sh.intel.com>
 <20251121124314.36zlpzhwm5zglih2@amd.com>
 <aSUe1UfD3hXg2iMZ@yzhao56-desk.sh.intel.com>
 <CAGtprH-ZhHO4C5gTqWgMNpf5MKvL0yz6QG2h01sz=0o=ZwOF0g@mail.gmail.com>
 <aS0ClozgeICZN/XX@yzhao56-desk.sh.intel.com>
 <CAGtprH8kVtyMiZeF+40hSpkY=O_HD0K+1Gy10rPdi8-mNLr8Yg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH8kVtyMiZeF+40hSpkY=O_HD0K+1Gy10rPdi8-mNLr8Yg@mail.gmail.com>
X-ClientProxiedBy: SI2P153CA0015.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6989:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b9e91a6-bad6-48f2-147c-08de3183c3bd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Tk40aVJMNy9Ra1BKUWQ3RWJhdDhBcTd4VDVtM2hVdHZjOVNiaThYSFFiUlIy?=
 =?utf-8?B?RXZiMzVrRzBGOHAxc2pKZldaeGNKZ0V2YXRTZWNac3U4QjRpTk9JK0ZBMmJY?=
 =?utf-8?B?SGFqeGVOK255OHpOWS9oS2NKR2V2OTZNNFlWK1E2TGdsYVFlM3lJcTFGNDc2?=
 =?utf-8?B?NittUTdSc3hyUkptaUJnL25XY0d2SmVzcEg1VkgvUWl6S0czZlZjUlJnS2xw?=
 =?utf-8?B?eGt5akdIaExYS1BRaXVhZjJ5Vnp0aGErWkVzT3YrTmU4RSt5Ynk5U2ZDZExu?=
 =?utf-8?B?RVczbW1SakVBdWVKeDM2TUJDcnFIUDhzeWJmMHBaRjY5aWlYTzVMejM4WlF1?=
 =?utf-8?B?N0w5RGFqRFdaOWk4OXJsVHlPM1JCYVlXWGx4VzZ0bUVsTGI1V2lWMWh5dUpY?=
 =?utf-8?B?VzZSQjFEWHZpRnlQN1BNbk90SjU2ZUk2WTZjelF1eFlKYVVYZGR2YmVVMTJv?=
 =?utf-8?B?RGtTSVlUSTVmWmJvTHVqTXBFSnNMajVreVJHenE1SXJwYmpQT0dFRWFSd3dD?=
 =?utf-8?B?NWpFM2RrZnBieDFrelJTYjZKMkpCY0R1UFo4ZStqUzRrK3V3RmNUZ3BuNCtJ?=
 =?utf-8?B?dUJZdTJQNkE4V0xydEdLQWgyQk1MS2MwRWRJc2cyYUFRZGRVY0RqOXpJWUZi?=
 =?utf-8?B?QXBEbDVDTmtWOXFyZGlxUTNPRnpIY2wyazdtbmliWGlzQnZ6dEdqMkNqVHVr?=
 =?utf-8?B?MUcwbkpYdFJRbkFLSFk2YmlneGYyMmg2Qktla1ZIY3phdEgxYkYyY1pHUU03?=
 =?utf-8?B?Z1lQTUhWcjNtVExIUSt1WHdZUDR4TjFDZldyMXJCa2d3ZlNQNkg5MDBVdlZ5?=
 =?utf-8?B?SEl0ZzY1dGZPcEt5REJIRHNUWVVBbXplQ3V0OS9vVGt0S0F3UWlnSEdFMFFI?=
 =?utf-8?B?YU1wOE5CZ1BQcWlYVjk1eGprWHJHNnU0RG1PZVBncGZMWjJCVkpmMzNVRG5p?=
 =?utf-8?B?RDdmaFRxQjBUR29QOHJhYTQ3aUN6ZWpFRlVndFV3Z3k5MlVLdUZnSWJ1R2lR?=
 =?utf-8?B?ZEFDWmFKYWNRbjNSaHRMUlcvdnNZSEk3NVlWblFKaU5vcTdDQzlGV3RuQ2lq?=
 =?utf-8?B?R1lweHdhNWlONW5nRktwT0JnUE5NN0QyT3ZHRFRRdS9sbG9tWHpRdWdHSnFI?=
 =?utf-8?B?aSs2YXJSbStsanFIejNFWUdta3d6T1dvWHo5VkdSZ0UwMHZ4Z0M0ekpBUlBl?=
 =?utf-8?B?alRyV25LM2VpamFicUhtSmY2eGVsWVUrOG5lNy9YNzVjaEU0VThuc3VmdWVm?=
 =?utf-8?B?OURvRDREbFdyYUZOcjFmU0RQUnoyelVzeVRKbTRRN3lFVmFReXBIUWt0Qkhq?=
 =?utf-8?B?ZWdjSHJ3ZGVkRVllL3Q3M1Jmb3I5bGIwOFpSbGEvRjRRK2JwMHFrWEpaRnR4?=
 =?utf-8?B?Y3JhU3ZwL0lUNmFDR0ZibGprcTYwNE4rMEFCMDg4ZldrNVVzS2pmQ29nSmU3?=
 =?utf-8?B?WE01T0hOSUs3Y0w2VUhrbnArZTR3UHlWUVJRTVNmdHlHeXUzWFlhdTNhdGEr?=
 =?utf-8?B?RmV6aHdOZ2Y1M0UweFNCdVdHdWF3SWlrNzU0aFZsY2R0aGhpSUh0eDNsTDkz?=
 =?utf-8?B?OU54b1lCUzB0RE1zQjJzME9kQlVmZ2J3RlUyWkU5WHBjYklsdTIyS3dSbjgv?=
 =?utf-8?B?S2llQjlnamROSWhtQitDbWI4UkpCSDdURzR3Ymd2U1diQlQ4SmlLMTZQekdF?=
 =?utf-8?B?QkFmTmdSako1MUJOOHE1TllrU2dZcDRwSnJYeHBpWGNzeGRTeE9LcURYODF3?=
 =?utf-8?B?RVpZbDhyRERzaGk0UlNyT2tBc09qMllmbG4vSFIrNHh0bnN6dm0zcEFSeXRT?=
 =?utf-8?B?bDF5ZllVS1lxNmRnMXljT05saE53SjUxQk03ckpSNlN1TGZjTG5sUDZFdmpm?=
 =?utf-8?B?QjV3OVRmNFZ0R21xNHlFVmNPMGxwek5OZGcrb2pTakJmVWFLMVJWcTJ5MEVu?=
 =?utf-8?B?K1NNVlAvcElsVFJZcEFJQXV5Z3lTSGIyaDhvdUJ0Rk5HbDJPNGhBSVIvRkFr?=
 =?utf-8?B?SDRxY1FDYS9nPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VU5WWTVEMjBaTnRyUnkxQUJTQUgybElBbm85cXlyQmdCWnludU45SnB2STN6?=
 =?utf-8?B?RDF0Q2NoTHVaaXJadW13NnpYWnBvQldDUVZhQXpHUDF4OVRlWUoxQmVqclU3?=
 =?utf-8?B?KzJGcUMzOGZKOUdKenN1TmswSU9JazBTb3Bvdy9FMFhkWEQrU1Q4dWlCMVZk?=
 =?utf-8?B?OHpJcjA1M0MxdlVhd2hTMkpkdGV5Z3NDVHJLcm85REluZC9SUGl6MDRmTXBj?=
 =?utf-8?B?TFBxc1dieHF4QkxEa3lRM09nN1E5Sm0wTTdheGdDeUN0WDBHRThJenNZMHZv?=
 =?utf-8?B?SWtQbmZ3OFhnYnlpVUpoZmVva2REeFN2YWZ6cmRXcE5QblpURkY3YjI1T3RX?=
 =?utf-8?B?RHBCcXlVT3N2VnF0djY1dStqZWY3SlJFM0ExWEQvTzFhWmVBanVkOENyajdL?=
 =?utf-8?B?eVdEWDE4aTcwUFg3RWdsWVUrU3ZobUV2UU56UzJtbC9IRFg1VU9ReUIwR3Na?=
 =?utf-8?B?VVhLZXd4NUNJc0dUNHBpOFVvNUFhTVBmdVJ6RlU1VGI2WlcvNFV2aGRMMFFx?=
 =?utf-8?B?S0dDcFNSYnM5YytxYmZvcE5jMXhxc0gzMFhnaVJBZElzUitoclBIYTNsM2Rw?=
 =?utf-8?B?MkRlZlI3ckdEaEU0VkZ4Z25Md3FzbllueXFmMHlySHBPK21SQ0NCS253Rk5s?=
 =?utf-8?B?SDRBWDJFWGtXR1k2TmJmT0N1RjlkVExYNzhUVWdYaEdySHM0cnpiTzNIaUxH?=
 =?utf-8?B?VEVhanVRUDhHNkJISkJYRWd1elFSUU9zT2xldGdCbFduYW02bjc3QjFEU2Y5?=
 =?utf-8?B?bTNlUFNycGNmTCtidmNzWU5jemxYMFJHMlVrenloWGRuY1F3Vk1WOEw5UW52?=
 =?utf-8?B?dERCTXBEYlBJN3JkNVJCckVOSW1GSnArZ3IxYXoxd3d5eEpxY21obVd6THgv?=
 =?utf-8?B?OUxnVGtiZXkyUGhQd1NlWGRkUFFqbG45Ung1WDEydVFMcG9YOTd4Ulg1RzBM?=
 =?utf-8?B?Q3g2Z1BQRzByQ29KTUVOWDJVeW0zMEZmVHU0ZnhyMGRpRTRxZGlyekdmWFVq?=
 =?utf-8?B?SzFjaEZGbU9sTUxKTHUwYWc2cDVZYmNWdHM2VHViUWx1Qkt1MFVoMFpIR29D?=
 =?utf-8?B?dGh3ZWJ3TDFTenpCcm9janZ1YnR1YUtFU1c1b0xSSEN2YVFpTThPMVZkN21m?=
 =?utf-8?B?R1BkaFdRNzhvYitKT2lKY2sxdkVUM2lJbmt6c0xkMWdNUEt3bFhnMXNNdkhz?=
 =?utf-8?B?QU9ha3IxQk1IV2pCT0w0Wk1uWmRoeGd3Q2lIc0l6enp1eUJ4eGJwQmYvWjN5?=
 =?utf-8?B?VWE0QVdVek1qc1dRRUlCUzJ4Z0l0Y1A0d0R0ZkJLVGVhNkxBUDY4NFdjU1RN?=
 =?utf-8?B?RDhmWDkySUs1QjQ3RnpUTXlGN1VLQlZPbytzaVNISThMaStIdFBUTEVDa1Ax?=
 =?utf-8?B?VTR3OHpxOHkvZGthblpWRGFkTWRIdzZETGdLRUNjaHlid3ZKRFBBdVQ3ckJk?=
 =?utf-8?B?V2pWVVh6M0V5aWI3QmJ3empnMjBQaEtqK1RqUysvZ2FSQUR3NktXZW1lNjdz?=
 =?utf-8?B?a2I2cThwaGtJQld3dkVzZWViUDBLS3BHa2p3dHg2czBsM3gyOURVWTJQWCtt?=
 =?utf-8?B?YUhYQW5XVzVTbDcvTmVnUXhLcU82clV3WWg0UGxOVHNVQUxNYTdxQi9GMmRI?=
 =?utf-8?B?bTJMZUxTYUhCdVpjdjZmNjJleStydW9QMHZuTCtqS1BFeHVDcGNyU0JhaHJu?=
 =?utf-8?B?S1ZiT0R5a1NMQUxuNENzSjl2K3N6Ujk1Zk81OWZSMXRtVkVzRnkxQlJ5QStT?=
 =?utf-8?B?cU1LVmZBbFVXUjhlWFQzWG4rRnQzNjFwZmRkMzJ4c3ZpeUZ6T1pCc0lkNGFC?=
 =?utf-8?B?bWl4aWFlRW5CN1l5Mmw4TEdOSWxQSkVndTdyMVZwcW5ROWtCZCtIeXp3OWU1?=
 =?utf-8?B?M0k3elp3aU9JOWV2dkdMVGxHc0tPeHRkL3ByK1hpMloyTkFnWUFCeU1kNGdv?=
 =?utf-8?B?b2w3UnRMdFFnRXo2cUx3NHJLZ2xFZmEySTVzRTNUMzFvOEdtRjlBMy80c2NZ?=
 =?utf-8?B?SkVvTU9qZEZyVUM0UTIraWhsOWJMdW5sSXh2SmRrSjB3YkRnNlBGTXd0bDh4?=
 =?utf-8?B?RU5nWjF2dnRaTXQyT2ZHQUxxdmp4TUVpdjMzU01JMEFmeXY5MEJPeTZEVE1m?=
 =?utf-8?Q?M0Tc4YEVnRaIiyTeIWYhXlL/q?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b9e91a6-bad6-48f2-147c-08de3183c3bd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 09:18:32.9057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KMQWhUqcXe9lcfpoyY1a1oP++GnpxsoJraxR1OSTHodPUT+pauhZAGkZ33XaMbnn+CMGJngf5XJ5+7dTgoaVXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6989
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: DB707180008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: u4aqhitt3943wfgmozx4jo73ci9d9sm6
X-HE-Tag: 1764667118-768333
X-HE-Meta: U2FsdGVkX19IQFaCLBDWMTx906P33c88nwYiBeWgNeib+y2/6d899sfT3/KmQBVJBhtUqaWhhtKpojN8wBEWMab8uZGBcoiiomWgVimpj8tZhEcEv84DRTLhCIUodTNSKdM5lA7c+q+COiYvz/sW44oQ0S20QGL0fh82NeJZtnfmNbjgQ26m/gSoPAodjaiCEZ8B5sohMnqaILRIpGFPCGUbbzpYdJbcMHUPsVHK5ke64dj0xWfA3IrVz8fN4RieN2kiRDyz4RrGo6bCx9xkzKYiBZhFTfeJ0726HluFY7uQUHeXWdZ0THsmzX5hKIu08cJIIQ08LcXKBEV8AwkF2LIv+WruoiE0PLs/NwaVuO0VP21vCyx+a6nx1t9u2LPgmntLTfOAhCyiHdtZwdR9XJzjBA1N+PDdx1W+yN22La68qYor/IDaFHvJo3UeiW8ffkRzYc8XxCtbZrEJckQJkegFHdH+4vDhOhTGrrxB95lRaLwRbnHMpXUvN5Ej3r/+SvDkrfkAlXATfEeQwJY+rw/h/fxW6vmkSzpKXBrxC+M5EbjYAYnIOpL/+IkT24nOI6lsl3hpxiUgALcwbhKRA2OIr8z0W1OYCeDPAPZktTyaMWZGe5/5o54L4YRkeQXuEw5H3A7pbdeGQjirysOG9ZZ5oOKpWv8wZwzjh/Lkoh/dDt9e8J7oSAJr4Zo3mddfn+877l4/Tjkcmzr24An7bt46E5fw9q73kHU2WJgPtHegSsMDxxZSyfv7LOu2oPRxIXlNDQO8pXsJAzcm4VhMiB6R8fh7jddZVqYh1DGrhiPgM8T8EU0nIZpxqzIJ32mUb6FDpwtVMa1XZwewMEhuC2ocSj3Kmg+ULLgv04gr1KkMjZJ6l9my2POyqXagaN4dR1BxPSrVWSfHvBGaQ3iSu7na6ixCcfk5rngPn2FlznBbHGdGv9A517Fg1bY3RvaYnek3j0ig1T1eN0qjU/T
 8ry7lqiv
 7JHohZQ65zgr+ZS2LcumuzDD7UskIlsozEFrFxXaQRQaig+cJaK5mM1GWKcYbLB3dh/U+HLbbZM5/QMRFj+9rqVWQ4znRiyYUEUN75E7pfkFiv9//CcS0EcWvC/EGZv/nJEDEnbkLkfZ9+M9PqpcN1DUgXvDGiXGVwI4R4fZL7CJqQP8/QRUNjvfMLo5QNc9n6lJOGUkt3wxYd+auuocKWrPkJU3h3Rrs9uzkZJQjG1e4exU3NU69VCV9PgSOQmbcn0YHD452ct2DH44G8QtuRD2ukAfz9vZoExcag6WyH62iul8iGDKZnpkKU4PGNcTtlIeKLOxx+Pd5B2RCEM/q9Y50SRzrkfvwSxu3YFPBxS6Wl2OP/Q7WgWd7xjsh7k6TAJ3eXv426zOEIcTTMwjJgEmzLKbo9QsxvoXjnq5JSg2fb0K0TxMz9lYttOWZB4as3f/jL9Wtq3Cf3h+/zSeFlSXC91fFK3eFV2l3Zxjw+b2fittR++ZiiNZodMYcfzPtftB7QpD/OvRRGAH0CxwVhy4gGu2WSgZSF5XNWEXK+fIaDejtncz9/zsmEVsz8aXZ4MKUREEQzv1HFnakDq38IOO6ipjUSzStig/ee0SUPV+CCYkMldt6KjpcTsRV9jLvJmamcGe5KLBzxeRMPMPf92KxpNWadZv0CHXiEQmepBUhpHPtex+enGC2G44uBvPiKjwy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 01, 2025 at 11:33:18AM -0800, Vishal Annapurve wrote:
> On Sun, Nov 30, 2025 at 6:53 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Sun, Nov 30, 2025 at 05:35:41PM -0800, Vishal Annapurve wrote:
> > > On Mon, Nov 24, 2025 at 7:15 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > > > @@ -889,7 +872,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > > > > > >           p = src ? src + i * PAGE_SIZE : NULL;
> > > > > > >           ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
> > > > > > >           if (!ret)
> > > > > > > -                 kvm_gmem_mark_prepared(folio);
> > > > > > > +                 folio_mark_uptodate(folio);
> > > > > > As also asked in [1], why is the entire folio marked as uptodate here? Why does
> > > > > > kvm_gmem_get_pfn() clear all pages of a huge folio when the folio isn't marked
> > > > > > uptodate?
> > > > >
> > > > > Quoting your example from[1] for more context:
> > > > >
> > > > > > I also have a question about this patch:
> > > > > >
> > > > > > Suppose there's a 2MB huge folio A, where
> > > > > > A1 and A2 are 4KB pages belonging to folio A.
> > > > > >
> > > > > > (1) kvm_gmem_populate() invokes __kvm_gmem_get_pfn() and gets folio A.
> > > > > >     It adds page A1 and invokes folio_mark_uptodate() on folio A.
> > > > >
> > > > > In SNP hugepage patchset you responded to, it would only mark A1 as
> > > > You mean code in
> > > > https://github.com/amdese/linux/commits/snp-inplace-conversion-rfc1 ?
> > > >
> > > > > prepared/cleared. There was 4K-granularity tracking added to handle this.
> > > > I don't find the code that marks only A1 as "prepared/cleared".
> > > > Instead, I just found folio_mark_uptodate() is invoked by kvm_gmem_populate()
> > > > to mark the entire folio A as uptodate.
> > > >
> > > > However, according to your statement below that "uptodate flag only tracks
> > > > whether a folio has been cleared", I don't follow why and where the entire folio
> > > > A would be cleared if kvm_gmem_populate() only adds page A1.
> > >
> > > I think kvm_gmem_populate() is currently only used by SNP and TDX
> > > logic, I don't see an issue with marking the complete folio as
> > > uptodate even if its partially updated by kvm_gmem_populate() paths as
> > > the private memory will eventually get initialized anyways.
> > Still using the above example,
> > If only page A1 is passed to sev_gmem_post_populate(), will SNP initialize the
> > entire folio A?
> > - if yes, could you kindly point me to the code that does this? .
> > - if sev_gmem_post_populate() only initializes page A1, after marking the
> >   complete folio A as uptodate in kvm_gmem_populate(), later faulting in page A2
> >   in kvm_gmem_get_pfn() will not clear page A2 by invoking clear_highpage(),
> >   since the entire folio A is uptodate. I don't understand why this is OK.
> >   Or what's the purpose of invoking clear_highpage() on other folios?
> 
> I think sev_gmem_post_populate() only initializes the ranges marked
> for snp_launch_update(). Since the current code lacks a hugepage
> provider, the kvm_gmem_populate() doesn't need to explicitly clear
> anything for 4K backings during kvm_gmem_populate().
> 
> I see your point. Once a hugepage provider lands, kvm_gmem_populate()
> can first invoke clear_highpage() or an equivalent API on a complete
> huge folio before calling the architecture-specific post-populate hook
> to keep the implementation consistent.
Maybe clear_highpage() in kvm_gmem_get_folio()?

When in-place copy in kvm_gmem_populate() comes, kvm_gmem_get_folio() can be
invoked first for shared memory, so clear_highpage() there is before userspace
writes to shared memory. No clear_highpage() is required when kvm_gmem_populate()
invokes __kvm_gmem_get_pfn() to get the folio again.

> Subsequently, we need to figure out a way to avoid this clearing for
> SNP/TDX/CCA private faults.
> 
> >
> > Thanks
> > Yan

