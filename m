Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 184F4606D821
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 16:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=T1MPxUei
Received: by kanga.kvack.org (Postfix)
	id 0D8E56B05B1; Mon,  2 Nov 2026 11:53:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A296B05B2; Mon,  2 Nov 2026 11:53:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94586B05B3; Mon,  2 Nov 2026 11:53:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C711D6B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:53:34 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B981240156
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:53:32 +0000 (UTC)
X-FDA: 85390775064.16.D359075
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2D3A5C0004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:53:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=T1MPxUei;
	spf=pass (imf22.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793638409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IG58rD+N5rxEDb8Xoqbz/HwRkS53GMUG+x3Q6/ZN5qw=;
	b=y5VUDW4gp1D6270pjOQ47kjD8u33bS5HVMXKhNxXz1Tz3n7eGdMvwNHWA1jN9XEvYM1IXD
	EjK6MNydf1IBJNUwK63VPJ6m2LqvaKnBrgcF05e4dhPJ4tuHxuhRFG2xLR0R/LK5XKM/vH
	felX0csDshBs76jB/gT/+KfUm3azZTo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793638409;
	b=PAPB9a/fuqIuRaStXt561AuQb5k4JKV7yD1PZbKSkcey4X5hOecxLJjav8sbfl+MHH9Ctk
	5oyxvSy13rn+2lyN3IqVrn6tsMgEUHlZ058J9aq+rZmfsDmPkHZIr18RvSNwKMX4QjSXxk
	qOHKXsqS71pR4TmZaOszyTgkzlgKYiM=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=T1MPxUei;
	spf=pass (imf22.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793638409; x=1825174409;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IG58rD+N5rxEDb8Xoqbz/HwRkS53GMUG+x3Q6/ZN5qw=;
  b=T1MPxUeibzAd6aQimTUGiGtsGDkH4MemKbhQkRnw9mZw0GrG4uh2TgdF
   XAEpDKAo8VB9tbWQu7uXgxpe0vtsvNa2vDHnroXPD9qPVZwMli0cYhQkR
   VhrOQya/9+FQtHUu5u2h2mw55QgIGJOqc0ypKf0z3gqfFcfIMtO6nmcR3
   ZCZQnLGqcK8C5GydITXoWoQ5GxUsmpDsxe0H0GnGG2K1Zi4oLLb9Uf9op
   y6yy4lz7XC+/D+yYCOUmkVkb5QiykB1YnQSay5q2g7j8JO3JEYyNgd0wK
   eiKC4AJqBtQejkAOvbrmGB0T5kOAdAWtk9BKQTjkqtKxQIBs/jlkUVylC
   w==;
X-CSE-ConnectionGUID: X27pc5BMQTWaRa09znBtHw==
X-CSE-MsgGUID: t9mjubZFSY+oyu/2DMEWNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11954"; a="2242896"
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="2242896"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 08:53:23 -0800
X-CSE-ConnectionGUID: bvVZr1xCRF+ur96Whm6hbA==
X-CSE-MsgGUID: qGAk8NMdQx+j+BwT6uHMng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="6001600"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 08:53:22 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 08:53:22 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Mon, 2 Nov 2026 08:53:22 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.17)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 08:53:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BItiwlE5ysRGl4P4mbieLq28CqUp3oDz9vggXzzHCkTDTJscVG2X95ty0QTgK3FjzqHkLl85s5kPUDBa2Gmy99q03gwCwETr15vzJo3A4Bg3n115m4AB2XKOXhTgVpe3sYXXxNccWydcxD1t3c2AAXLFVNRgeUhodDqOkP2lrHCC/1wEdv2gJwcdika3NUXu9XKz9kUhzCMNs0ClveCmiQJ6+L15SQNqeQKGPKYIzXNjrfYgchl3Af7YQ69q1fea56ZJz6tvydADM/hzePTMKSFSdu/3HydTtAzwrMmR+u4E8llzxTmqjwixkm8S3BfP0c/Fi6jmotC4NA9iAlTHfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IG58rD+N5rxEDb8Xoqbz/HwRkS53GMUG+x3Q6/ZN5qw=;
 b=s1brpFc4P7v9KCiwJvnBSXAAhFRSzEL3C3lAXpRequ2fPfY6poEscwMF9qJI59+7tbP3jasULdbg9h5ie0HhCiamOgAY7d3+DjqDLe9OHSo0tNxUtM0NKZlQRR7rx6ibVLbwRDfBwqR8YI8qE3akYq+tS1KgpOUbSLAwA8j6si/diSfj1B0wrvTOhl/JBTVzN5XjuCseR1IONst6vm4we/CmA+qnbLtSO+LpawHat6f7FxLfmGCjubAA3NMcyw6HeIZ17fYjl9PH9aSII4BeLD9TOLYdVAxqbQoufmTfAzn4ru1VWgcygmIddUDg0aB0yyZpMIU+vu/0EqlLkUs8gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB634048.namprd11.prod.outlook.com
 (2603:10b6:208:549::23) by MW4PR11MB7078.namprd11.prod.outlook.com
 (2603:10b6:303:219::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 16:53:18 +0000
Received: from IA3PR11MB634048.namprd11.prod.outlook.com
 ([fe80::760f:f0a4:7417:6e57]) by IA3PR11MB634048.namprd11.prod.outlook.com
 ([fe80::760f:f0a4:7417:6e57%5]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 16:53:17 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "peterz@infradead.org" <peterz@infradead.org>, "kas@kernel.org"
	<kas@kernel.org>, "luto@kernel.org" <luto@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "andrew+kernel@donnellan.id.au" <andrew+kernel@donnellan.id.au>,
	"rppt@kernel.org" <rppt@kernel.org>, "pasha.tatashin@soleen.com"
	<pasha.tatashin@soleen.com>, "kernel-team@meta.com" <kernel-team@meta.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org"
	<david@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"peterx@redhat.com" <peterx@redhat.com>, "tj@kernel.org" <tj@kernel.org>,
	"azpijr@gmail.com" <azpijr@gmail.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "rmclure@linux.ibm.com"
	<rmclure@linux.ibm.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH] x86/mm: Define the zapped-entry checks only with
 CONFIG_DEBUG_VM
Thread-Topic: [PATCH] x86/mm: Define the zapped-entry checks only with
 CONFIG_DEBUG_VM
Thread-Index: AQHdatgdOWG1gcUTjkG6z8ShoYs60bca/56A
Date: Mon, 2 Nov 2026 16:53:17 +0000
Message-ID: <f20b6d4f4e9368885e187e208453f21a9b0a2140.camel@intel.com>
References: <20261102144001.342837-1-kas@kernel.org>
In-Reply-To: <20261102144001.342837-1-kas@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB634048:EE_|MW4PR11MB7078:EE_
x-ms-office365-filtering-correlation-id: e6a8719e-4de5-4792-3e86-08df3901cb09
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|6133799003|10067099003|22082099003|261102123227099003|18002099003|56012099006|11063799006|261022105027099003|261021121427099003|261026140227099003|261026121527099003|261009223027099003|261028144727099003|38070700021;
x-microsoft-antispam-message-info: qqnP8wF0sDCypr2WTi9elpMeVch9psFpAkf6pnifdgQXzLJP+zlP0YWUWJ9K1/X3QSOazMrXFrzahV4nWN0/kKOG93GQRVPi2mcJweEw4WlESmtu2WYvJ+GVJDfAGKH654ep4225sSjNBGlN5vpkjjiZRl7e6M/FLfemi+4Jetzyr4DpROlJoXkpglrp/nJFLg+G7iKyvtRkgfLa2GAiVkpDtLYhKkx7G39v/Cy77S10nWQZ/cAvyOolbNs10LdeUtEjmufQ9oGdEmOB8UfFHmaSRZkj6pZiWtGQDBRdXS99ych59vnUYZ2WUnPNPVWiPmMm8LiMficngya/ZUGzetovcz3UieJukx3vtd/wRoOMHIhhdMgqdnlfHd2NPTxbJfUX09+MSQi6Nmxkr3Wa20k1wrudhlUU3bFGaUiFfuFvc+DjvRVlgYvVIy6faPFfd7I02BmEFuWEahAZKjrhoICOgIoUc8O9o+0N1UDBzvq4FqR82TmYWS1RRon90xLLXhec9NPiiZ4ZWwBBPG7K9ZiqL8IXvtNHsptqSaWt2xCmkNYWaR3JvjVX3Jo0SctQlIJ4cZQSGr38uRJ3Pcb2DAyggIJV0C1r3BIsmFIU8t2j0HshSJF8btybhz0cmSQN/P58nu1JdWYVkfDf6RKTPjrsgTP5SkZzY9lbUErcVOImUohs1q6jvGPiEFP9rWNUjCxGEegy1zoWxrCtXLFvdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB634048.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(6133799003)(10067099003)(22082099003)(261102123227099003)(18002099003)(56012099006)(11063799006)(261022105027099003)(261021121427099003)(261026140227099003)(261026121527099003)(261009223027099003)(261028144727099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SzlVOFhxSnh0RnVjd2N6VXZrbTZmRWRtdHpBT1IyWEJ4d3FRZXRGWFYxUm9K?=
 =?utf-8?B?L21tU0t3aG1OaXJkM0JkUjFHbE1yL0NvNjNNQThCT3VxenpweTFPbGIraTc4?=
 =?utf-8?B?Um5SWkV4NmZvR0daYTVuNFNXNDYzOGdHM0I1M2FaZjNEbVpxTTg3cTZpKzh2?=
 =?utf-8?B?VDRWVGJrb2dxeHVCd3hiRWVVOGxWaWtJZjEvcElYVDlVLzA3SWZQMXVEQlg1?=
 =?utf-8?B?VGYrOHBmV0NYQW80Wjh3dEZwTldjUzVuWWk2VUhFWCtkUjdDZzVxUkpTbk1x?=
 =?utf-8?B?VVFPTEZXVFFmR3JpUGQvamFNcnJpRW1SZnlVT0JPUTU4aEw5V3RXUklqUkFU?=
 =?utf-8?B?SEMrM01tYWo1TGp1STRrZEoxcnlDWUJsRnY1L1JXN2UwdEM4K0owb2tSRjQy?=
 =?utf-8?B?NlVBSTl2ZDVmMHdZV3UrbjloNjFOVzJQMnRMQXZJK1o2dTg1OWVQN1JrQ0kv?=
 =?utf-8?B?aFpDSHJkN0E2S21mQXcvVlVSWnhwNG9KTjQ1Mk1vdlRsaUJNNGJKMkJ5ZzV4?=
 =?utf-8?B?ZzYvS2VRTTdtVGQ2bHY4NjVoNE5OY0dwNnE3T01RS3BYdk9NNk94Z1ZQSGlV?=
 =?utf-8?B?c2krTHczM3BMaTU2L3pDRWNBU2pVVlBLMHkrSXZ4cXhjL3hNdGVraFdNbHVP?=
 =?utf-8?B?YmJwQzgvQVVvcWtwY3U1ZE85UEVhbjZDeHkrTXF6TmZrNnJsZ1NKeXF6VU1K?=
 =?utf-8?B?bDJwa2JKcjQwajk3dFl4VEM1MzQ1cEd6TnVUa1dXNWozd0c0RXprRkZxc2x4?=
 =?utf-8?B?ak04V1VzbHlON24zWE95WURITWxkVFZwTlAzbXZLZ1FraktuVTRJeHIzRG9G?=
 =?utf-8?B?NGpjZ2p4K0xzSDl6TjE4b1Z3WXpoa1BRZzlTVEN5RjFRTUlZWmhWSjVSOTVK?=
 =?utf-8?B?UEM2OGJIbUJobnVKT0RSZ0t3dXZuSHVVaDNoNFl0NDhOaTgrQ0FoQkk1b3VY?=
 =?utf-8?B?THRBSzYwRVlwdkRkYTJ6ZTh3bnp3ZUZFNjZ1ekh2cFhJQU42NHl2SGgrSmd3?=
 =?utf-8?B?MDNhM1lrbUJRbGtNNmxWVVVRNzA0bDNFNXZmZEFvd1RPNEY4WU1WNnA5MlFy?=
 =?utf-8?B?ZFptQ3M3QkxIbUgrcm9jNC96Q3FQUzE4b2RBZi9KU05VRzZ0VTNxb2dhaVJN?=
 =?utf-8?B?UXliMW5UTUwzdFBzN254ZXNFSDhmMWlDRHZ0a0pHQy9KUjhkWjVFWnFXaXdL?=
 =?utf-8?B?ZnNkL1hnMTk4SElpaE1lYkx4YnlXMWxRYWdTVmJpVzVHL1ZWdCt6b0NxK3Ft?=
 =?utf-8?B?YVc5OHdSclViaDFwQ09ZZUZNUlR0Y25jODlNdHlyTmx6bm4wazRLcUtXbHZW?=
 =?utf-8?B?TUJOdk5wYThjWmY2M0RheDIxNzhET1gwTzNwYTVLTGcwaDJURDdNemRVT3JI?=
 =?utf-8?B?TjEwaGE2MU12dGpGcGhFcVRHeEU5UE9Hc3lpbXRkaTZPcU40Y1JRdXhUU1BY?=
 =?utf-8?B?WUI0QUhPbHlQajdGVytWWmhmb0hUcEszN1NDVVdFcUgrZ0lnYVhqVy9NMC9t?=
 =?utf-8?B?Y1ZPMCtFNHFDQVlkSXJueDJuNXpRUU5zRFhpR2VzTGlTU1N5dXBLN0JTTk5n?=
 =?utf-8?B?Vy8waDUyb2ZZcU9zWWRMQ1BDR2x0VGJFbGRYcUVTekhDbDlSbm52a1gxYjFj?=
 =?utf-8?B?anpDcGc5V0E4Vk9xZElVTzk0NjloSjYxSjdBdHQrZ2h0R09pQm1rSUkvZUV3?=
 =?utf-8?B?N2tneU1iL0I0SU5oRnd3aHZPQytVUlB1NzBnVSthMlVJWmEzNnhDT0JKVEhO?=
 =?utf-8?B?ejdxd3NweTNSNTBKanptT0NNVS9UdDdkbDEwaXFOa2pjeU1JeStuY3J2cnJ4?=
 =?utf-8?B?ZGp3eUIvbHhEcFpwT3phYWx6Q0xyQ0JpNGFZQzkwb0F5aW1yQ0VFdmNUSnI4?=
 =?utf-8?B?dmdOZUhDV28vMHh2cVFWMlhTRlNZVWZUUEZ0Q1pSdjI0Vk9FVHYxdlFMRGFK?=
 =?utf-8?B?OGc5dDZqdmpRS3JNYVZEeGZ0OCtHM3gwTWNSNnVtb0QrQ1h6SWVhTHQrUnRy?=
 =?utf-8?B?UTcwbnkwekViYlBrQlYxOE5ldk83YjZyMVpURk9zTGdVQ1ZBMHN3V0grN2pk?=
 =?utf-8?B?Z2tJWVVaZFV5bHhUWENFdlB4YlRuMlU0QXhtejA3angxdWx4cGx4VTdhUlNF?=
 =?utf-8?B?eUVSdWpZVHBkUm5jN05jMWpaSXlBRlhiUUZ5aXIyZ281c1RmcWxpUUVoUzln?=
 =?utf-8?B?QUM0MlVmUHFKeHhUNUdqUUg5TkhMLzVxOHY4S3lQanVNWUt6TUdlRytWWnZx?=
 =?utf-8?B?dkQvTkJDamZoOStkUVR5M1BOWGhHMXJMRzJLUTBwZTV2N09wbENhWDcyQWhw?=
 =?utf-8?B?dHNjbVZtTW5sSWRhZlkvMDkzR3RDb0gzeUVvMExod3ZDMVRVYjI1Kzh3L3JF?=
 =?utf-8?Q?+doIEKtN7ASdZpIw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE11A2055DD98E4EAC05DE3309EEBB1F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: clW4prbo2GRwp5eO//ALaHLkjKeJp5YsFVwF5AOXc86UTQJPuf+TDw6XXp8ukztTLAvce9eQP4kpEPCEqiWG680fNHr/EzatPuShynxqXsD0DzIcFKr5N/fw29ohrW4dQcDEHYyYD0lIgMgVMmUMLaKaTiSKDwLebrud4o6UxagMnyfi6r08DuUkmvCvq/vUC/T31/WtXicQDa82bBo08aCYe60HLOsLkru2lMgO8V8lm+i6UWgBzvJCjmI/8FP71zDq8gq+ss2eBXBSCR2GMNkFqnGYVWovSO2bT0axXtRBIxDiIYzMBfWXStqXzthSlYZke8/GBYbNDuIwRQ6oEA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB634048.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6a8719e-4de5-4792-3e86-08df3901cb09
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2026 16:53:17.3688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L/nwsI3eYEJhOLxhAtnWp4EvUKrr4oza5NHcQ7D8hg1rTDQuvP3cvwWUsbH2CS0kPQvzhw/R0v3v0w/escBnIS5FD7AsLQpXBKtXApPLwAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7078
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam06
X-Stat-Signature: nugwo6ppiqo8nz5ffkssuwcues76eyxe
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2D3A5C0004
X-Rspam-User: 
X-HE-Tag: 1793638407-542243
X-HE-Meta: U2FsdGVkX19e16HkgBx82gHvSJ+i8XQiY1HZfiJ+n5m8Z1rHQylPXyejUNBNrrdUmV700ih2S0iTp48Ir0E4InNJd7rrDPHfvTGorToIR8NtYOlwtUiJRflGbr9tmqQCiJilwsgpcAvk/aEwGUzg/1f6RiIvMQo2a8ZxqaTjd7RyOzTDTUgKcaewf3GU4C9ahx6Czd4OJffBfhwQpmQRX0hp2YeIqKsRW41cL+XASaFDjkDGxHwJlc7mXDA1ckQrb0uU5Y615+/8Ke40VS5ssFKyv0YY8fcpmB7nbeBAf1zxg4ObFC3k0BgGsOl7w/N+aY6yfgEf2zWv90LTYrMN/TTnOvTQ+Hdh82yct+avvyJwK2aHRj9d8II17VF27fRFVBEhcf+V0n316h0zZKqFfXfIJG4YzbOjOqaReV6T4Vhj7y94BCA/xeYfR1Cq+RaZP//HHJ1T9RfF8409FrSafBqZmgeHlJ+B36/IjUW0e+h3KEeweBHVGZM7G8UNkpZd/BciEiomBZsYTMLPWbyTUi+4HDPjh07et4ZlFWvkyLKtqfh78ghTZEApVw4yeHGxMytgDwetwdkVL/c2rNuOc4ChVwwYumRdCg20OFxNyrX9x3QTyqWB7/isteJ4Zn1MXua7jmizdjLRhbyK+HMCzElAEDVRmScSfk5/hCAtZIzkECdXGY7TME3zNsy5hih/fG5n5qIL6qy0JvxuZ1kKauk7l/HUaRvPHjHiDkpF3TAzoDmMZfF+r8qbvgV9q6nhMnALgf18JotVY+7YnYk+XTwFJTufyKmTvIjMHFiq9JhfyeipqaITzHeFfLvYf81P/dkEml2+Jp2mzDy5b6rqqOVuGbsn7YAnuNF9ZWtV6b3VQmf6Y+S43h7TROa1Fmve2Ec9GbY7+JO9SsfA77XbXHelZffE+hcBHej+JHWtEjwC+yObxAqrqzRvaAAreCyLdBrM1ZIEfspYdz4Z+8S
 VjLfIM+J
 qRlVVe6U8FtnNhrQFWAw2ZtfmWc/qQfis5do2NNk9LmDB2AYzqUB98PhNDInjAzxgHm8ExJOHu0xrs/B/dv8LlKV4RYdkeKh1/RFF6DtqyB5/R5j30Wg9ivCwdr9OmZwKBXvpqB9d0krX4a6fXfUB2DjDGhdslStfOt2DiygQK/gzQKE11m9vIi0pMW11IS2SexV+MivO7YpR8ppAkpCh1uHG4anwHbXe2Zycn0/DY4NWZug9MGWCtQHg1OyAZGT48XQP/uJGADq3GJ7cvQ6lkLgRGvhZ8bgkqAtSfYb/zvrhTqXbzmg+/14G6dx93+xP9K3uzbkcDnQvJLmEW4mztq6fhorExUVzePG4k8qYwer0UEnF5oBSNJVngsrk/4cJTnmTRbx8JDqLnnQLIm5iDAMNF5H2seqVwMwc/tSPKE7365g3NTzD2SnR+iZpFhAVRcOicfuXniKiVpcB637hX5Q0O5HYUOtW72vFI8d+jKXQuyZjWrbSjGUQmU0PzBgbBVl911EkHDev68bvs6EASJ0NXmLVTo8SvUG5WWBHkwYaRIjTEJKxAcCvzTlph026h6+vaOgqeCSgzi4/kp9GdhqSO6w6s3tXnRfwSImSMTN5Sy2Cq+Slbk3ZkU688xWsHoZsd62jiPM3XJIaSheOeecCvh3MMTSAJiiV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gTW9uLCAyMDI2LTExLTAyIGF0IDE0OjM5ICswMDAwLCBLaXJ5bCBTaHV0c2VtYXUgKE1ldGEp
IHdyb3RlOg0KPiBaYXBwaW5nIGEgcmFuZ2UgY2FsbHMgYXJjaF9jaGVja196YXBwZWRfcHRlKCkg
Zm9yIGV2ZXJ5IGJhdGNoIG9mIFBURXMsDQo+IHdoaWNoIGlzIGV2ZXJ5IHBhZ2UgZm9yIHNtYWxs
IGZvbGlvcywgYW5kIGFyY2hfY2hlY2tfemFwcGVkX3BtZCgpIG9yDQo+IGFyY2hfY2hlY2tfemFw
cGVkX3B1ZCgpIGZvciBldmVyeSBodWdlIGxlYWYuIE9uIHg4NiB0aGVzZSBhcmUgb3V0LW9mLWxp
bmUNCj4gZnVuY3Rpb25zIHdob3NlIG9ubHkgY29udGVudCBpcyBhIFZNX1dBUk5fT05fT05DRSgp
LCBzbyB3aXRob3V0DQo+IENPTkZJR19ERUJVR19WTSB0aGV5IGFyZSBlbXB0eSwgYnV0IHRoZSBj
YWxsIHJlbWFpbnMuIFdpdGggdGhlIFNSU08gIlNhZmUNCj4gUkVUIiBtaXRpZ2F0aW9uIHRoZSBy
ZXR1cm4gb2YgZXZlcnkgc3VjaCBjYWxsIG1pc3ByZWRpY3RzLg0KPiANCj4gRGVjbGFyZSBhbmQg
ZGVmaW5lIHRoZSBjaGVja3Mgb25seSB3aXRoIENPTkZJR19ERUJVR19WTS4gT3RoZXJ3aXNlIHRo
ZQ0KPiBlbXB0eSBpbmxpbmVzIGZyb20gPGxpbnV4L3BndGFibGUuaD4gYXBwbHksIGFzIG9uIGV2
ZXJ5IG90aGVyDQo+IGFyY2hpdGVjdHVyZS4gVGhleSBjYW5ub3QgYmUgaW5saW5lcyBpbiA8YXNt
L3BndGFibGUuaD46IFZNX1NIQURPV19TVEFDSw0KPiBpcyBkZWZpbmVkIGluIDxsaW51eC9tbS5o
PiBhZnRlciBpdCBpbmNsdWRlcyA8bGludXgvcGd0YWJsZS5oPi4NCj4gDQo+IEluIGEgS1ZNIGd1
ZXN0IG9uIFplbiA0IHdpdGggU2FmZSBSRVQsIHphcHBpbmcgNEsgcGFnZXMgdGFrZXMgb25lIGJy
YW5jaA0KPiBtaXNzIHBlciBwYWdlIGZld2VyLiBNQURWX0RPTlRORUVEIG9mIDEgR2lCIGdldHMg
NiUgZmFzdGVyIG9uIGFub255bW91cw0KPiBtZW1vcnkgYW5kIDglIG9uIHNobWVtLCBtdW5tYXAo
KSA1JS4gVEhQIGlzIHVuY2hhbmdlZC4NCg0KSSBndWVzcyB0aGlzIGlzIHRoZSBpbXBhY3Qgb2Yg
dGhpcyBmaXggb24gU2FmZSBSRVQgbWFjaGluZXMsIGJ1dCBpdCdzIGEgbGl0dGxlDQphbWJpZ3Vv
dXMuIFdpdGggdGhlIGFzc3VtcHRpb24gdGhhdCBhIG1pdGlnYXRpb24gZGlkbid0IHJlc3VsdCBp
biB0aGUNCnBlcmZvcm1hbmNlIGltcHJvdmVtZW50IEkgY2FuIHBhcnNlIGl0Lg0KDQpEbyB5b3Ug
aGFwcGVuIHRvIGtub3cgaWYgdGhpcyBwZXJmb3JtYW5jZSBpbXBhY3QgaXMgcmVsZXZhbnQgYXQg
YWxsIGluIHRoZSBub24NClNhZmUgUkVUIGNhc2U/DQoNCj4gDQo+IEZpeGVzOiBlNTEzNmU4NzY1
ODEgKCJtbTogV2FybiBvbiBzaGFkb3cgc3RhY2sgbWVtb3J5IGluIHdyb25nIHZtYSIpDQo+IFNp
Z25lZC1vZmYtYnk6IEtpcnlsIFNodXRzZW1hdSAoTWV0YSkgPGthc0BrZXJuZWwub3JnPg0KPiAt
LS0NCj4gwqBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9wZ3RhYmxlLmggfCAyICsrDQo+IMKgYXJjaC94
ODYvbW0vcGd0YWJsZS5jwqDCoMKgwqDCoMKgwqDCoMKgIHwgMiArKw0KPiDCoDIgZmlsZXMgY2hh
bmdlZCwgNCBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVk
ZS9hc20vcGd0YWJsZS5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcGd0YWJsZS5oDQo+IGluZGV4
IDAwMGZjNmMxY2EzNy4uOWIwM2EzMTZmYjc1IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9pbmNs
dWRlL2FzbS9wZ3RhYmxlLmgNCj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcGd0YWJsZS5o
DQo+IEBAIC0xNjY2LDYgKzE2NjYsNyBAQCBzdGF0aWMgaW5saW5lIGJvb2wgYXJjaF9oYXNfcGZu
X21vZGlmeV9jaGVjayh2b2lkKQ0KPiDCoAlyZXR1cm4gYm9vdF9jcHVfaGFzX2J1ZyhYODZfQlVH
X0wxVEYpOw0KPiDCoH0NCj4gwqANCj4gKyNpZmRlZiBDT05GSUdfREVCVUdfVk0NCj4gwqAjZGVm
aW5lIGFyY2hfY2hlY2tfemFwcGVkX3B0ZSBhcmNoX2NoZWNrX3phcHBlZF9wdGUNCj4gwqB2b2lk
IGFyY2hfY2hlY2tfemFwcGVkX3B0ZShzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSwgcHRlX3Qg
cHRlKTsNCj4gwqANCj4gQEAgLTE2NzQsNiArMTY3NSw3IEBAIHZvaWQgYXJjaF9jaGVja196YXBw
ZWRfcG1kKHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hLA0KPiBwbWRfdCBwbWQpOw0KPiDCoA0K
PiDCoCNkZWZpbmUgYXJjaF9jaGVja196YXBwZWRfcHVkIGFyY2hfY2hlY2tfemFwcGVkX3B1ZA0K
PiDCoHZvaWQgYXJjaF9jaGVja196YXBwZWRfcHVkKHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1h
LCBwdWRfdCBwdWQpOw0KPiArI2VuZGlmDQo+IMKgDQo+IMKgI2lmZGVmIENPTkZJR19YRU5fUFYN
Cj4gwqAjZGVmaW5lIGFyY2hfaGFzX2h3X25vbmxlYWZfcG1kX3lvdW5nIGFyY2hfaGFzX2h3X25v
bmxlYWZfcG1kX3lvdW5nDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9tbS9wZ3RhYmxlLmMgYi9h
cmNoL3g4Ni9tbS9wZ3RhYmxlLmMNCj4gaW5kZXggNGExMDVmMjgzY2ZiLi4zMzUyYmM2OTA0ZjMg
MTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L21tL3BndGFibGUuYw0KPiArKysgYi9hcmNoL3g4Ni9t
bS9wZ3RhYmxlLmMNCj4gQEAgLTc5OCw2ICs3OTgsNyBAQCBwbWRfdCBwbWRfbWt3cml0ZShwbWRf
dCBwbWQsIHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hKQ0KPiDCoAlyZXR1cm4gcG1kX2NsZWFy
X3NhdmVkZGlydHkocG1kKTsNCj4gwqB9DQo+IMKgDQo+ICsjaWZkZWYgQ09ORklHX0RFQlVHX1ZN
DQo+IMKgdm9pZCBhcmNoX2NoZWNrX3phcHBlZF9wdGUoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2
bWEsIHB0ZV90IHB0ZSkNCj4gwqB7DQo+IMKgCS8qDQo+IEBAIC04MjMsMyArODI0LDQgQEAgdm9p
ZCBhcmNoX2NoZWNrX3phcHBlZF9wdWQoc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsDQo+IHB1
ZF90IHB1ZCkNCj4gwqAJLyogU2VlIG5vdGUgaW4gYXJjaF9jaGVja196YXBwZWRfcHRlKCkgKi8N
Cj4gwqAJVk1fV0FSTl9PTl9PTkNFKCEodm1hLT52bV9mbGFncyAmIFZNX1NIQURPV19TVEFDSykg
JiYNCj4gcHVkX3Noc3RrKHB1ZCkpOw0KDQpJIGd1ZXNzIGFsbCBvZiB0aGVzZSBkb24ndCBuZWVk
IHRvIGJlIHRoZSAiVk1fV0FSTl8iIHZhcmlldGllcyBpZiB0aGV5IGFyZQ0KY29tcGlsZWQgb3V0
IGluIHRoZSBvdGhlciBjYXNlLg0KDQo+IMKgfQ0KPiArI2VuZGlmDQoNCg==

