Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67D70FB5E88
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 23:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C626B6B03BE; Mon, 16 Mar 2026 19:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C033E6B03C0; Mon, 16 Mar 2026 19:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADB3B6B03C1; Mon, 16 Mar 2026 19:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 966976B03BE
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:26:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D88F89037
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 23:26:44 +0000 (UTC)
X-FDA: 84553513128.28.0793292
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5A631180011
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 23:26:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SnDEH6b2;
	spf=pass (imf06.hostedemail.com: domain of sohil.mehta@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=sohil.mehta@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773703600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JrucdzwnxIKKwmu7bDQRimXHxJmaeJjB3pPEuGkmfPM=;
	b=qVadS4BptLCeSrKcpHpM/s+hUz35jTTfPKUH+t86BN6vxv5HL44vWQJ1VJEW3/aeNOwuCG
	GdlRijS6gvpmTb4VkKWGfCN/Nr/1ZJh53cBWxn5yB68Zk7qFDcv4e67N3FBAohWFZy2xhp
	eiOP4ke0VKN8xtRGkSpsFXF5GyFjz7I=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SnDEH6b2;
	spf=pass (imf06.hostedemail.com: domain of sohil.mehta@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=sohil.mehta@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773703600; a=rsa-sha256;
	cv=fail;
	b=3HcMIouUnaSiFDeKpUdwYmgInWvsc9xX86GjOddDyzjUbPTFJySWiF9tjzwUtndS8SWoiS
	5mZbTwl6B7w+18gkjeu2BaWqOt66HYw2N8b8f8CMzDKvlPa+TL6KDzu3CWfTH5ZLr1CxGE
	LxN0cE04cjfk34k2NfkqamHMEh9DsDc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773703600; x=1805239600;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ORUvh6gDfYZ/5UVKfQlZvY47UCUoHf25EmMfDq1R9aU=;
  b=SnDEH6b2pJAB5wD038g/GU93mnQGh9bx6apXD4hkrvKTGbRy/X2r2ga3
   aZkvA/d4kmy0hggcFEp+j1ZS7M+pzKQFhNcUXfgwoEDPpOoC1MOxaVnqn
   PJD5OzoaJuXvqI0MI2d3iIoLe0FkwOv+AjOL+9oNawLcGjgqAr+T33TK8
   peUn0PVBeh7ymEUF2Oo97Cwo7S4cHSRyBQQc3vX3RQ58grOKygCjZPEjv
   /CvWk7GXjuDJi3Yx5U2v9cPb4maRZKfEBgqfgOR+Wy4xvZqm8wtdbbz5U
   fz2W73rL5ssspODx9nK4d7svUrbTO4wVCkyyCm0U7HqXzb9B9kG96/8Sm
   g==;
X-CSE-ConnectionGUID: M6pNf50dS1OzR2xmEXUn6g==
X-CSE-MsgGUID: C2XTe0p4QQaQUiuPTpy6/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11731"; a="85047438"
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="85047438"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2026 16:26:38 -0700
X-CSE-ConnectionGUID: 5qbcDUMqRmuJbBsGcjm8Fg==
X-CSE-MsgGUID: SPKJPvlJSSSs2jfnTql6LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="259966769"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2026 16:26:37 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 16 Mar 2026 16:26:36 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 16 Mar 2026 16:26:36 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.38) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 16 Mar 2026 16:26:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KKsq/fjMW0n6BSARVqzD/BK1vEG5GWVUvA2RviAP2ka5ht/NIlPWVGpw+pPI/TjteB1OEm2yMQIwfaMxFmb8Y24so2dBb/ylul0gS5oguzL43XcLJZEsM2JyFIRM79Rr7vVCYoqC9lCpUcIf7kK+06lb8DpFtdZuOcfrB61SIg594n5Se8KUcUxETtUljxRhGV2+GRL1f+/vRWe4Xs1Sj4zp45/6wu8q+L6WdtsXSlPOuX3kRG2k94daE/UdoVxkld19VfH0GlAB5ZoP2Bn2TEetg0dUrdGPU0fHUlswfKAcOUVIvdQSd/imRJVbnPkFixTuGEpDtH68CMkzF1tmdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JrucdzwnxIKKwmu7bDQRimXHxJmaeJjB3pPEuGkmfPM=;
 b=jgO0W/yKMm7RU8PIrcdBD6Yt3hfbG9I0fH8LN9PLz2tLEpk10mRjKBQldYYefUz0pPGca4vxdjgaxb8VLVKOSZxg0ayz+F5V32XYwNDbhOHWlb44CsPIgQrGzGnLUuu1CZ7/g5aDTOzDNjHafwlNInTSLGcep2nOZ9rq/1F5r28RR3VIgREzbBHdZ9PsXqcovpo1yi1b80f/eLV9pjKje7lOZ2dhD651s1eYc9K2CZJq2yd5ASrJffIdJEOA7zl5EZ1wF8njk2yykFCwFp8Bzw92EPZVNDpbdSBb0OAhlXLgOGSRJGGHPrhxRy5vZO321I7W2iksnpe0W25jVo/ROQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7997.namprd11.prod.outlook.com (2603:10b6:8:125::14)
 by DM4PR11MB6504.namprd11.prod.outlook.com (2603:10b6:8:8d::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.16; Mon, 16 Mar 2026 23:26:33 +0000
Received: from DS0PR11MB7997.namprd11.prod.outlook.com
 ([fe80::24fa:827f:6c5b:6246]) by DS0PR11MB7997.namprd11.prod.outlook.com
 ([fe80::24fa:827f:6c5b:6246%4]) with mapi id 15.20.9723.014; Mon, 16 Mar 2026
 23:26:33 +0000
Message-ID: <a503cbfc-e7d9-40f0-99ef-d640a0b5d78e@intel.com>
Date: Mon, 16 Mar 2026 16:26:30 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/4] mm: huge_memory: refactor enabled_store() with
 change_enabled()
Content-Language: en-US
To: Breno Leitao <leitao@debian.org>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, "Ryan
 Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
	<vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <usamaarif642@gmail.com>, <kas@kernel.org>,
	<kernel-team@meta.com>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>
References: <20260311-thp_logs-v6-0-421e30d881e0@debian.org>
 <20260311-thp_logs-v6-3-421e30d881e0@debian.org>
 <322f6f2f-840e-462f-96b0-b603b9c88582@intel.com> <abfVLky1zanZyEx8@gmail.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <abfVLky1zanZyEx8@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:a03:114::38) To DS0PR11MB7997.namprd11.prod.outlook.com
 (2603:10b6:8:125::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7997:EE_|DM4PR11MB6504:EE_
X-MS-Office365-Filtering-Correlation-Id: d661549e-8628-412d-dbc2-08de83b375ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: iB7xc6K3R95IkvegpeX1Dqt2nejaq8jk3E5HxtbW9pQEgSvZXZv/LIAZM1mWAuCjgAWbOv/PMPz7Tevbv9JQ9yD23CLwYEf5CQZ3eL1I8uC9ztoGxRK++lIFbur5k905Q3Cm4AlarBMErabMafa555h3IGPJuboXJ//ssXkyAdnnd/VvVyBBNr1Zxt07FKMzErBdky5T64aFHCBEJdOXBuI8+MASqMb86JbsaRagt2oYlIxaHT2Ua0wsEu73Qv1GoX60DPAVUlDliWVl13g39xrZfR3BSwkyxqTdxoEnHG1CuF990UmnIV32/+DjhqaVuYr6HiN4cjEttwX085d+83zio3+3fQdw7LDbhAvQeAd/g2UfVybwu8nSFY8GMGc4k0XEEB4wcF1F8jAMTzgaPgMfKhpESVW0Cv+9gfBnmCMoMp+c0N12zSubGNlNOFHMHoqA6gRVQFlcUFOXi/wdpFgf45YvpwzqoAquAO+/oSa7Qgvq62goVhMUywsU34jKtrJyoDIWG7Z+gw4kHSO0pusf0qWLkykYgFFCG5N2a3dhFZ+f0fpMu9LYYph2c41QcWpKzOz5AtMpXdrMrsO3RawcfTzU6ntiymYyHXerA1IkbTpbZmeV/Q+ZcrEDk2b/7c4gxVpSmXxcZdV4HMG9xVXT6NNWacWcZaPorVAvsyDDX0bVMXeEDaG2rnXbjTNos2C9sj8IVGvjEIt+bq+U/lVWNHIoWCjmO0d20i+m+nU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7997.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nm16RzRReHlON29kMFIvSFMwODlpRGNTOU5aR3BqZUUwVndKUDdTcGZVQVVi?=
 =?utf-8?B?QkdHMkZ1VW5BTCtTcHpqMFM4dDgwa05yRTdjb1R1L1RqbmptMTRULzJqWk80?=
 =?utf-8?B?OG9VVk9CYnlHVVJWeWpRZkdtZkN0VVVOcitSdnFuSnBORkRicENRRTJGWnBk?=
 =?utf-8?B?K00yb25JMi83VkQvQWFjSTA0aWtUOE5pVlZEaU9JVU5tbEJMbzJOZnl5RnFH?=
 =?utf-8?B?YUZJNWRGVkxWdGVWTWtkT1RMbytkcVdGTThvb1NlWXFmbzZxYk5VaWJOSzZO?=
 =?utf-8?B?cEdVR2R6dTBXVzFndVZJb2dlamczV2FXRmgxUGkxbUxnU1RFOXFSNDRIZVBJ?=
 =?utf-8?B?NVQxcEhwMWpXa3BEV3h2RFBTOE9ZemxhWDYxNi96K1VWQllsWC9MZHIxcTBx?=
 =?utf-8?B?OEpYTVI3ZE52cVUzRHQ3V1IxcG5kdThEODRhQ0VxSU9iTTQweXFmWUxuaTgr?=
 =?utf-8?B?V3pQVTFRL1daTDJ2TWdzVU5ybkw3OVFNcFRkU3MvaVdhTkNodzFJU1E0OTFI?=
 =?utf-8?B?WjNRMnRjMkxOV1ZTcFl4VWRuWXEraForNHk2aWIrejdTUUVEa1hLZHlLRDRE?=
 =?utf-8?B?MjNaWFVEOUQ1WlZldVFreTBjdytOUWtuaXNDdzdRV1Y5L0tBOUY5SFVhQzBi?=
 =?utf-8?B?cmluRS9GU2dBbGlta0U2em01WXkvSEhsYnErSHJaWENLM2hHN3ZTSy9peTRF?=
 =?utf-8?B?WkorcXpGSzBvYnVoaFRjdnFtQWwwQnFQRHdVdTZLZWY4clVIcEI4cnJVRGQz?=
 =?utf-8?B?U0QzMVNQRWViMmFNVVlpQksrSC93aVdTYWQ4R09rcmQzMTBPbDlveVlYVUsr?=
 =?utf-8?B?UHcrU2cwNE9NUWNNQ3lmMkpvWkZpYVZDb2Q1Y0w5bEtiR3hwRVNNdGhkU29N?=
 =?utf-8?B?WEM5MlFpNGpwMFEyT1hjNlpVcnhXOVh0ZmEwMTF1YjF5cUxIcVFIWFhScWVX?=
 =?utf-8?B?bE5LRWxGaisxS2FwQ1hLWElUbjNxV3BSOEdmZThtdFpxbTlkV0huZ0FKb3pY?=
 =?utf-8?B?eFczVjVIRVJBdFAzc0NDWCtRRzhhOUtXTVovSkEzWVlvZDNFcytxTUYrZmJQ?=
 =?utf-8?B?c2hYM2NnQkFuQ3UxV1haRHVOYk5zTkJVZEo3SnBURWpUMlRDZlpYV3F0Mi8x?=
 =?utf-8?B?eGJ5QkVmMENXNXE0S0pBbE95Vm1nRmtRSjFBSFFRODVsOG1QTk1nSUVudGVU?=
 =?utf-8?B?NllSMmxVcFE3SDZmYy9aQ0w1aFdqWGdpekdzU2ZDN1JDdGZiRlU1ZHBiellm?=
 =?utf-8?B?cjNzek1Td2MrQ1hrM29pbzBNR2FlSjN3aWZXdGRsWDlYTlZ5TGJ6MllCVEZM?=
 =?utf-8?B?ckcwNjlkRjFQejFxWWZESUdIRTkxRVc3S0dZblhINExEVXZaOWozYWlma2lw?=
 =?utf-8?B?VXNWN25DTWthdVJ1RG5DblNKOEYvL0twMXZoaUdmSmhnZEEwNG9aS0FmeGNZ?=
 =?utf-8?B?SmtnQmhvRitvQkh3c3R0WGI1UVJwL0czUHNnVGVsMWpKU2E4U2J0NUpKdUJn?=
 =?utf-8?B?bnYybkpNQmRFcjJtcG56ZFVjMUdnRngzQzhhZ29YTHFhdEJ1VytxQm1HVzVZ?=
 =?utf-8?B?ZkZkZzF1NFp0QlhQaGVMdXJRRHRhZjlkSm56YkFjM20rR2ZMbVRvS2xhTjVD?=
 =?utf-8?B?NUZEbERzZzNKSnp5QmdQdWVMcUFOZzFPOVlyelhrdzl5UDkydmNsSHRtR3Nx?=
 =?utf-8?B?enpUNEd4b2V6d09LNEplNE5DL0FCRnV1Wm9Db0oxbmhiREFzQXFGZjZCREpl?=
 =?utf-8?B?T3VYb21BbllHa0U3RmNZcjJ3L1V3VWh0ZlFlZjNXbld4KzA1NVNsVDhYMS95?=
 =?utf-8?B?R0tWSkVDd2IxY3hyRTF3bitWQVY1VDBhNzN5cDA4TTVKQmxQTmFUZytraUZp?=
 =?utf-8?B?NnkvNjFQLzhZZVZnV3VUcFZwWWJqOExnUWZUY0FQM1A1RERIT0hocmNBRysv?=
 =?utf-8?B?TXRSM3BjSzJLdDFQeTB2aDRGUjRvVFF0QmkweTRqOVplT01DTk9rTkxnSWxl?=
 =?utf-8?B?ZzNKNVN0dndrREFQRDBEc002d0ZhMk5Va2Q4N1k2WmFtTDd1d1liRitKODA2?=
 =?utf-8?B?OCs2V2RBUFRzZjNtTXFaMHN4bHMzbEdvM3p4QS9ybkM5SCszUzUyaGlLSmVp?=
 =?utf-8?B?bEVoZ2lMNDc0V2k0S2FlMzM3Qk9WcTBiVWpBUnY5L04yQzVEN2srSXZiWDZm?=
 =?utf-8?B?NU4rSy9WZFdDN3h2MkRiM2RzU0xCZFQ0WDh2RDJ5R2h5amY2M2pBOEpTRW1w?=
 =?utf-8?B?WnpqWUZ2MnF1WUhaTlJVYlRzVWpPZTdvZkMzTW95RHlnZXdkWmVBNmtNZk1q?=
 =?utf-8?B?b0o4M3V0V1pmSk4zaEdGZFVpZW5ELzhKK2tqbzFHeUhNR3BxZjRXQT09?=
X-Exchange-RoutingPolicyChecked: GxhxKh7Ex1R9amAFF3r3D6BIMbDVyIW/RF6WE6jO3MdDNmlUAwIKW7F5vygNMS1+hRk/f0XCKxERzymsQMlxvv9/bOmt52DOEUW9mr3PF1NWqzDvSa7OVlbvEgDYazlxZ/PavKkMYmAG2hrXaQuQq4jPfyaukUthKZIUU6FFgOARnYTLGm/nLUk6LG+IvhCbEZaFh7GacsPh5VGPmM9E6XUHzro7gZM5GdjdwpmIFCK6djUQ2jsy5/IhpDpkiEnq5YBbUf6kBxuBrW1V3JBhaY8pN2q6UWzIt6Bt7T0XVLHljHRUHk111l952FyUR4X9Tqo+wx6UwhQ9/LaE/LF9EA==
X-MS-Exchange-CrossTenant-Network-Message-Id: d661549e-8628-412d-dbc2-08de83b375ec
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7997.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2026 23:26:33.5505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gW7xpctGgGH6sx7wFeOvqrSmbsYV8wUmxjQhTgvimMBJ8aLv2dubfMPjP3jmIZK04dQ2pz3wREuP+R/kHldxYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6504
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 5A631180011
X-Stat-Signature: iu66xys4d788m5ruijhg59dwgueuxfak
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773703599-708438
X-HE-Meta: U2FsdGVkX18nzDeoe78j8R9Mf++6YHNfr8SGjDM/YT42jvQ7K3Qh4qX8TzZWq7RdWsZgu+w4jS613yJd2ReI4VgYzdWv26Io14g2bU6fiZrbEs8fX/j/2nDsHQ4w7nN7i2garOepnYrGQpQu2G2eBUbgvJ7lYBJ3lQC4QPxRmMT31PZKz0haySh+TY0xmQjqaJXsDdDlzJvQtq3PgPLiakPf7n0/8gVn5L94fEVcFZJvef9qwaewOlRvdyLRUehtjG2N0Igt139Vz+wMKCclla8LODMK1PlyM3f+xMVVz4WNzCqIAZi/eaSx6z3BkejgaLy8Hc6IoJEuh+YEBZGoHAN7SgLa7TlyEWMjDhw9lS6RcyoEOXuIlw9Mckpfl9IVvWRC9pDMrZ90rPaZMMQv+wZt596SxFep3HMNZIxd2Hv1SZuwKNjKz5iBMnyJOvjQuz/bwQ7Xdnhd+25gE9ZHVeumXPwzHuD8wZkstfBK19f3Is3X/OvdrOEWoCoO3G0IdV1Y0bxC3jZgaMw6j+nP+kNIIgkDlzqETQwSjA3BflV2JYOBVmXfRs9AyMmSce2WcUOQz8Y43bw6ZOuHx20CVkLHp+poZwX4cbfaNb4prQuemxz1KBYq1bHIqvN6qQh+XNsT3WDM+E9k2ObphfcHmDBh0R2epD8jCM0exbgEORiRC0G/G4C4aEdPRgAsMzIYGNupp56/JvIVC3AbD+xDu86vM5pR/aH96j7g0Vvo1W76Jomsih5W5IYCUehfaui9yfLvCBFo/MPVlv/j7o8GHuJ+XjYFTFpzYmaxosy33lhrladx2OtFclePvLSV2hRKJ4sUBQUxxDQRE/G1lbJWzGu29ImVgiBKyvurI9F6gdz1FBfWNqywfYXanHHkWDXgOdVH9MLeigl6mIMQr19oOvvzMp3C+3oW8pRiwqWGQRuhFOTldIMriPMBkCRCyrUGDQXQugS8BeG3AhGdlwL
 eBAIwFAf
 YEsPE0WQdemYreG5Yazrbx4jCTIzGQe2cru36dybTTVj/oAAzGzUiP0ethbTQaP2ph8ua7Et8yNQUEulRFfSGUpue6Km0rdxHs4ZhFKP4kxvZxmEJR6l5UYePf5XKnHUgjrku3KZ0XS4/1e2YsE8LzuR4kusD3FxaD0IJguNkx7hDiV8Z3tK/NhrIqbQCi3B5+OkUZC0qhdYtuflflX96xWwFd7WPSGquVtB4zDaXMNv4u8pxRyQ4d5LfDKeW0MwdWQ5vxYbuQ2KqlxDgxttHf8C5JTt8nUwZ9hCswpo1Ywf2LgMOVmgtZNMMjNz88ZCmV0gX1NLlvKOnGkHYECKEcsHqAKhSSMpFRpuZK6jqSnbt3+J/h2WMEK8oNP1FvzIiOpW3YgWoJXPC4x/94+5WA6zKNNwcfGMPv6J9s5FBym7R80Q685hzrfVXu1Esm3HFDVD/0ISQV5Jnlvg5C1NQV/F2GfDgYnVzUZaKoUlkClPGhsTm9qz95s9bcwioh0JfiLnNwYct0odK9CjzdmqtwXhP27Im1FsuQUgGyavYNSs8e6Fu+Q9Y5+o8YFRoZB91wJwYyuA6BOm9JHB4zQ10eFJKNN1SNmGCHIeq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/16/2026 3:12 AM, Breno Leitao wrote:

>> I am not a mm expert and typically do not follow the mm list. Is there
>> an issue with the usage of non-atomic variants here? The commit message
>> says this uses the same pattern as set_anon_enabled_mode().
>>
>> However, set_anon_enabled_mode() has a spinlock=>huge_anon_orders_lock
>> protecting the access. But, transparent_hugepage_flags seems to be
>> unprotected in that regard.
> 
> I don't think that the atomic vs non-atomic will not help much, given
> this is a compoud operation. Independently if this is atomic or not, it
> is racy with anyone changing these fields (transparent_hugepage_flags).
> In other words, Atomic ops make each individual bit flip safe, but
> set_global_enabled_mode() and defrag_store() need to flip multiple bits
> as a group. With atomic ops, two concurrent writers can still interleave
> and leave the flags in an invalid state.

You are right it is a compound operation. So, there is an existing issue
with two concurrent writers which can leave the flags in an invalid state.

But, I was wondering if there is a slightly different issue now due to
the non-atomic part. Some updates could be lost depending on the timing
of the operation.

For example,

CPU1 does:				CPU2 does:
set_global_enabled_mode("always")	defrag_store("always")

___test_and_set_bit():
// Trying to set bit 1

old = *p
// reads flags, sees defrag bit=0

					set_bit(DEFRAG_DIRECT_FLAG)
					// atomic: sets bit 3
					

*p = old | TRANSPARENT_HUGEPAGE_FLAG;
// writes back old value with bit 1 set
// DEFRAG_DIRECT_FLAG is lost (reverted to 0)

IIUC, this issue didn't exist before. I think it might be safer to use
the atomic test_and_set_bit() to be compatible with the older code.
Though, I'll leave it up to you as I don't have expertise here.

Overall, as you mentioned below, protecting transparent_hugepage_flags
with a spinlock seems like a better, long-term solution to me as well.

> 
> That said, Although I don't think this patch is making it worse, I think
> the is a racy issue here that we can make better. 
> 
> My suggestion is to move the rest of the helpers (defrag_store()) to use
> sysfs_match_string(), and then create a thp_flags_lock spinlock to
> protect operations against transparent_hugepage_flags. Any concern about
> this approach?
> 



