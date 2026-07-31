Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95FD0C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 07:49:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 889196B00BA; Fri, 31 Jul 2026 03:49:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860F76B00BB; Fri, 31 Jul 2026 03:49:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7014B6B00BC; Fri, 31 Jul 2026 03:49:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EC346B00BA
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 03:49:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C8243140175
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:49:34 +0000 (UTC)
X-FDA: 85048297068.07.C73221C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7E25FA0003
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:49:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YRnsVDWG;
	spf=pass (imf15.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785484171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=geGiDFII9SHPfeHnb76tUhpHX9A7oFsZz4HkM0/+y24=;
	b=ggoPiMZGjLkvndMJhqa1nOHXbzdy1jDnUA/9N3xVVgxnK+EZ/7w/KFfxBKuAYHnFU9xRq/
	J0sz3vU8UjRAsTUR//f8Fwku4b4bsqAlzVEGYYT7pp4c8eNq0U8VbSSSnTibsmcWn85wab
	tD5ngknqdnndUi8XoJLJ8AQbPtK5KLk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785484171;
	b=NzULj1zzBI5f0Q0ClnafL5Gju5uehZKkgTlnfSBvxMEyNHIjWc8tVeZlHftMO1HxYdYGyS
	A2HcNlMad34XUdqkZF+z8kXHBt+FX2I5xDeKWnSwMndVoyMlSfPLSQofIo02/x8UDW4HzB
	bdzyOkNL+zYjKv0vaqiGfs47b1t/b0U=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YRnsVDWG;
	spf=pass (imf15.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785484171; x=1817020171;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=ueOH1f0fQQ+pnBRPQ3c7IpxKGp8P/iLwLF5bDPRFSYA=;
  b=YRnsVDWGuiiXWREh0bCXDK3ScYes7RJfxEqO36I8XAJSe6qnBvHOwzhl
   WwIXr35RediLlgaPh+eOs1vfqtUjIzrcS+CZXmcU4RllrDmhOnc7GmsQd
   h4qUT7ErRNxrnLlQ/SEAuZqclDN5a4t31TQczLUkmbtFsyAmJkwZMxgYY
   m1zPXCoqCF2FbJ5WHySBblAOFugwemFMr8Hd3MniXA3eFW0sf36VQ9Cst
   XqaiiOza/0lbkrX27tMLOUo5ry1/LdsaGb+v6NA0nK6vJadKYLw/C/qkw
   oZDDl/Lh33eOJqFZa1GDL5vAxHlptbSo6++PNFMyCPiksZhIvZA7YLabW
   w==;
X-CSE-ConnectionGUID: la7UrZC6QAmlqxVkHlvuTQ==
X-CSE-MsgGUID: 2wRkYciQSLq2CWK5lR4/0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="96465564"
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="96465564"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 00:49:28 -0700
X-CSE-ConnectionGUID: gv7JLO5iT7WHv/W2l8hGyA==
X-CSE-MsgGUID: h830DFnARI2bmonO72krjw==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 00:49:27 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 31 Jul 2026 00:49:27 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Fri, 31 Jul 2026 00:49:27 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.65) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 31 Jul 2026 00:49:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gHthVedQwFiMmp3v/d22yj1TQUGz0gKsF9fPD0Y/zhx/Rm1hTV+tz2gvZpXCEe/q8TJSxNuEPxBhCNOwhCRoa/zqs0v2FBDjOrVJG+A+AbaFrMLjuDphaVwscYGuIPbTtvgeUnDRG+JbunwE2R5zQr5IfvQpBl5ZzUvgrNCZIFgjaQr/u92NkRS1n4Rbvpzy6TMJkIM/D2crFk/k9r8rpNdlytYJPes0DQ+IhEd7J+26aUF3j7WOAy5+02tH5xOHfdj6MThkvb75L5Jy/k4VgVd1MIuiPzOyV+MdCn3JnUjgI2SU5kjdoM1q+ySYm75FRjw2iCU2dEh5yYa0F+MFmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=geGiDFII9SHPfeHnb76tUhpHX9A7oFsZz4HkM0/+y24=;
 b=dMMB2A8xdqMo6u34iRUly79Lg8YKZVw+Ll6mhMwjEp9QfjUfORBz0xhfWqyXQ+/Wj796sxZxD7j6wIXd+M2QQh6IHLZfH0iH6NIfQZEEa4s7k22bXfSVxXq0QSXB81ja/G6kb1FFf/BvGhorIWFVlzgZCKgMImFB1FbMI4espsW+DanOq+9ix+MQYrmZ3e3f1sAuWZL3j8bN7riEfguXTAiPGuKo4m6HLq5iaKTf75YjHj66e0bkQnXC6KDhBJTtcPW17e+NCAOosuBiHF2oSZQpTeOUWzVDVtRPhQvt4GqI+Pts7NZuyHgotWJmYO6NOaaeI3UecJI0YNkbs1Cm8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by PH7PR11MB6747.namprd11.prod.outlook.com (2603:10b6:510:1b5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 07:49:22 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 07:49:22 +0000
Date: Fri, 31 Jul 2026 00:49:18 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Dave Chinner <dgc@kernel.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, "Qi
 Zheng" <zhengqi.arch@bytedance.com>, Roman Gushchin
	<roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
	"Mike Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	"Michal Hocko" <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Subject: Re: [PATCH v6 1/2] mm: Introduce opportunistic_compaction concept to
 vmscan and shrinkers
Message-ID: <amxTfjc4I16J3q9P@gsse-cloud1.jf.intel.com>
References: <20260617032218.1165929-1-matthew.brost@intel.com>
 <20260617032218.1165929-2-matthew.brost@intel.com>
 <ajnA83DxAFqeJ-sv@dread>
 <ajnOvdbT5/J6q3IN@gsse-cloud1.jf.intel.com>
 <ajoaikDrKz7JGr5h@dread>
 <ajsCNu8mCGVS7ZwB@gsse-cloud1.jf.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ajsCNu8mCGVS7ZwB@gsse-cloud1.jf.intel.com>
X-ClientProxiedBy: MW4PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:303:8f::32) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|PH7PR11MB6747:EE_
X-MS-Office365-Filtering-Correlation-Id: 97a38d4c-7c91-435e-ce3e-08deeed83c16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|22082099003|18002099003|10067099003|6133799003|5023799004|11063799006|4143699003|56012099006|3023799007;
X-Microsoft-Antispam-Message-Info: zgEmxtku6ZZIyPqJsERiebg1KtG5tlsrto634IIBKANqnndhiCP5XE+gzUWFq16B+FBCWuJVbRJ15JivhtedgONo5Fycu26IxvQk9pkZZ3EzxVA3mu8lCaEtCX7ycNp8dLNdgFKFKL1s+8k5YA566Bn/pn02sq9GuMdYaUhPAhTY7XZr+Mav7kWW7P0EJ8977PVp5tByGcgem1cNWFpgldtNmHNF3KXhFqmYaaDLMD1BSx96ZdTPIdpMxlHzMcb8tE0O1t9NT32xpzOJVwiReJnU6p/YwqRFnzlvQFH0eae7pzHnDqR4noGImLH30g/GzW2VRgXtQtk3urMbRI0AHsdSvttixTTg2RKGOWqIeXvfIuULSTZpvyub6yrzaytxXZ3U0YbW0O6KvabE/izFuNOBsrNPylaFAVDj8VJyP26gQjvJDNfVUHXiBq0qI9IBhlO/M8diu6BwAA2joaJZh+hnVlONZl3pxX2LmzY+ILgyivQUZWXMQVgKIeeHWBPSw9NSCOXmLkLOg5xPw4KX1bOBiYCeQz/zIwOJBGLdjngp7ZDr3fgqzjTXfLszOiuK7UZrvnxEa/2fHP9O6LVwN9v74ZJtPnz4uG9q8vEhN3P/6x17xTjZM0SQCkzcv/5NjzD2Co9UQ5cyagnPJGMjKM81ixgWD1SIG+l9XJ8TPVo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(22082099003)(18002099003)(10067099003)(6133799003)(5023799004)(11063799006)(4143699003)(56012099006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0FLakk1QWE3ODQ4ajZyd1NXYTREZ2lESzM4WVZRNFMzeUo2OFlScWFGMTlP?=
 =?utf-8?B?NGZTaDFmT2thWExTemoxWHd4aThMbDQ5dHdQOXptZzNHUkRIZ291NjdFZzYv?=
 =?utf-8?B?QldncGZvZnorN0krYVVORklxNFA1cEl0MTIrd3NGbDFEUWZzVHFmYTNZSnlo?=
 =?utf-8?B?L3c3ZThySmtXU0RhRmJsNmZxVTFWa3hHZTM5Y3NSMFJtby9TQnJkMzlPa1Zt?=
 =?utf-8?B?NWJwSG83ZGp6dy9zUHRLTDE4NUR0ZXBRdGNoNWtSREtESFhISUhOQ0o5UnNU?=
 =?utf-8?B?VzBjSGdVUmdGYVlnQ3RnRDNGZ2xJaWFXVjhuRWNHU3l2SzF4aW1jUUdoZ1pO?=
 =?utf-8?B?RnltbXNoS3FNZWU1Tnd3RE9SV1B3TEFwT2dyOXpXUDk4c2NjUTZZTzlyeTla?=
 =?utf-8?B?YWlYVUJGTGVSd2J4MGVYbXo2eitkWGFueGc0ZzlmbVphNnAvRU80NWpodW56?=
 =?utf-8?B?ZnZHeUhOeDhJNjdpY2NlZS9tZnNPS0tJYVUyWitPVVBNbVgzSTR0dW8wVlV3?=
 =?utf-8?B?akFaeW91NCtFZllnNG9EV0I5U2ZXNEo5TXFLdFo3Z25YNFdFSlhWK1Q0bnZK?=
 =?utf-8?B?Z2NWaTlLdlRMMVhJRFlDc0tBdjJYazBqM25qL1dKcmNJYU9zeTh6MGxMZ3dr?=
 =?utf-8?B?Ny9rajIvUjkvdWRnck5HaUhybHVHMzdLMU85a0s2UWFPakVCNFFNVmpVZGJV?=
 =?utf-8?B?V21NQ2V1ckRaZzNEeHk0cXgyK3hZc2FBbE5hUGY2Tnc1czNWZnJSUWVJUEJw?=
 =?utf-8?B?emZGUEVTUnBGd3NZdUE0cUYySTFSQ3RQQmd0Y1BiNiswbWN1VDg3RkltcnVO?=
 =?utf-8?B?aUFlYkV4R2M0aG1SaVV2UG5sdHZTVXF2Y05VUEwrSVVmNE4rVkt1OUJrR1Nw?=
 =?utf-8?B?MER2TmN6cVpreDRwcWZ4ZzQvVUFMbTl5cDBrM3gydVUvVDlnZE9kS1daM3hh?=
 =?utf-8?B?S003bHZUNGdGbUJJVFNyT0NRdXpuN0lpR3MxMUxEdXNQb05GQWg3NWFISXlV?=
 =?utf-8?B?dFl3VVFqWU9mWHF4K0dubzBjWGpXUkFJNGtWNDVldkZBeHNNSm9QUFlGRVhX?=
 =?utf-8?B?U2t2YTRBTVg4cmF1STl1Q01rNkJPQlkyN3QyVnB1N0RLTTVMSXM2cFFZakFQ?=
 =?utf-8?B?Y01RblEzd0dEWFhBZW5wVjV3cmdVRnFvc1VMaWJqK3pvUUVhbDVkNHVOWFZp?=
 =?utf-8?B?L1hVRTJHWmVSbFNNRHlhNzJsTXRlYmJRb2hxTFBkYk9tV1lFWVlPMWcrbDFM?=
 =?utf-8?B?R3JhcEFBcmhHOTNVYXpRNGxnQjVYbDFOTmp3endvbkh5RnRBanNqNVA2Ymg2?=
 =?utf-8?B?YUttTU9tYmg5TU9YTTk3OHpTeTFEeTU2RUtKeHVTUzl2Y0lkRHIvYjVwZ3E2?=
 =?utf-8?B?VUlmNE5iNk1nOThHZnhCZ3dBYy9JcWlQbjlWaFlYNWxIZ3UreFNaY1hIOEdY?=
 =?utf-8?B?Q3RsZWhMTnRKV09LNGlucE9adG9GWHRITnRGU0hnK1hUdEVmdWpEUjBPcStE?=
 =?utf-8?B?UTlQUy90OU5OWTQyMFBWVlFaNHdsSXVBL3hISWZic2pPVmdNZGFGUGFNUGNL?=
 =?utf-8?B?bGp3bEoxU250WXJBQU8zY2J2MEdDekRQWjNTU3ZMbFNYVVBWYlozRXc0SGQ4?=
 =?utf-8?B?S3RpWkhWcThGQWdGNWFtN2hsUDVON05kTDdsY3RQTTJIaEJSWlVvZm5SNGZ5?=
 =?utf-8?B?RWV5MW1qR24xOEtkNDhzaVNLWVcxN0t4ejlzT045eTc3dVlaMFEzWDdBcjQw?=
 =?utf-8?B?ODZKTFhYVU1GTTBJeFBmZUh4eHpLM3dwckFVSjVlSG1jbWxpT1dVckpTMTlM?=
 =?utf-8?B?UEtnek1KUEJacFJJUEl6YWNBWUJLNXFaK0FKbG1zSXdyQlE5UzluYTZEdU9T?=
 =?utf-8?B?azVlQm1kMFNVSG5qSG9IRGFCQjRLYjFldmZnNlU5RHRxSDUxd1k5U1BzTFY2?=
 =?utf-8?B?UU5Sd2xwaHI1L3FnMGdyc21FSVg3dHc1VGR2K1pCN0VOUGhzbDk2NmVzODUy?=
 =?utf-8?B?OUVZSndnWHVMeThsU2hDY04xTnBUa3BjTUl2UHdiQ2RqYm9PcWw0SHUrSHo1?=
 =?utf-8?B?WTNrdDZQdmFGMFBNR3FVTXdtR1lOVnUvNVNRZXNyNm5tRkVKazZCWlROQlov?=
 =?utf-8?B?czEzV284UVBTc0YvM2dtQVg3OFZzOEhzaERENXQ4dW1EMGJYa21OOThTSkxI?=
 =?utf-8?B?YUUvcHd6MzV1NEtQZHVybDcwaWNvaHpzbmdaNGVQR3ZkTjg0dmlrV21qTjdQ?=
 =?utf-8?B?ODBDdjNvOGZ5UG0yekdxOW9renVRQzRFaHkvaDQ1a1JNUHFiaEJXVHJ3KzRM?=
 =?utf-8?B?c2h0dmIwVFRxN2xrN0JHQkVzWGlocDhZeDc5RkFzN20rSGtSM1hsaVQvalE0?=
 =?utf-8?Q?LjTkWZ7vQQhw3gVY=3D?=
X-Exchange-RoutingPolicyChecked: XhgsHbVKLfZ5XN0RSgzCDLZ3/HTsHqaXpK9wzzdh7Z+pBIaslqDkZdnhE81OfCPQ3btGwQzw6DANmIHqdtNf2EIBu32bRaIyUx//yteM4amhx8QpGhsr5px6TTMAuQ3ZfSSDSUmu0MEMUTJd7XHYKHKgXpQnQ8P0sIA/RDZN6J2JjOJrsyKylThR1ZS96rjeadaIvckkvI0a1glQPG0bBt1aVJtYrtJ3ZbVfG+c0tMk9dmVTw6OS9SmZwbsEM7afJCQkO8BbXyJSWcL+/M1/e+KxMqHpxRe4nOezYyDxd5FYhkf8FZEWxNSvjHdH3GM3Q3t9f1Xg0UxFQsRryWggTQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 97a38d4c-7c91-435e-ce3e-08deeed83c16
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 07:49:22.3834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n8fxANzcfj+1Cq1Oe318FeuWGZsAlAUWfXp4U+ZK0oNmPiWkOQEOPjgvxqiwEft5+cD09JqJtEwayg4sAOHFdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6747
X-OriginatorOrg: intel.com
X-Stat-Signature: mmpeas17ikixsgrb96jqe5kxhdcab9fb
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7E25FA0003
X-HE-Tag: 1785484170-990096
X-HE-Meta: U2FsdGVkX18f3uhcYJar+DVhrumJ6p67Bv1tbatWQh+/K8xkCszX8kZ8+sHd7PefvnO7Q1qjzmce29MGw1NsIVY2EitWUxRFGFyHanWQmI3uiBP5jx69Ed87Dpesp8mpTDVd3T65xZT7vPgh3ReSa2Mxjm2TRrWpILFUaH5IjtcuBwfuxfUVF8mqS0M6eD4Xd8ws0PVESfJZ9cEl/v5foenfCOS8BqIbexAhcw70b4JOChOJCL1ihxvpjIgb3ht1RRczHysB8RjcBi6TBzWf0rmGVWmogayWYZF8rS9VkIaDsox9vkPntg73oxCmLVS3KcKTNlBH1DkgWUpkW51scsaTd2tq+vYaG9ko1/cuQWa56TLXRU2ZeXQweyS3U9LuM18uCljtoTs8e8g8st9vVbYMKJIey1btyRGjixz8yFjy5JLgWZOK5Dssnth2vxkqZ3lLTdGVjCfxKy5D2BEIkjS8ksgnvre9NYcqxkVsFXTKv7Rtw58LFKRUITVVUqi/19+9NuAi/krOf3Kxf0imlUKvT+Ay3TMPDNmLBUM81UQA8idt3TE3qlFkCYXcz7gB0rrY/BLbf3vrtSNZwScxijFM0SFkoonnz0+4jLvWw3vUW2NxG9riuEI/G1L9gQBwVxnImofBUosfVFbiM3oeNaQ/F0Aw3NiXfDn5c/BGtsSXY0iKuodysWCRca6S+a6KMjyCCz8X/qzmhZh+QD0exzFsnciHTw0L9exbC4d0IMbSpKVIWuLNDCIZNnzPMPoRii63b1Moig8jws1eQm2ItVqh77ufcULA+gk9RYwUyaonII1ts41V4dzG0v9oUIUoZX3wyY9BYmaZO6zDJDR3W+TCOe8MElbQmSSBLXBfq6qppBN9lz3eqBKG/tpu0kdFrJ6hH7mTIqmr29skZkrEZumilWG4XHzs8y+8Q9h4dTuAZxejRBRHFqvmmrI5n3sfTgjy8mlJNEoxf0gngsc
 sfT8iGr8
 aTUOZn2wr5PPF3STXQMF6wEKKBFKh0s9JtgjVcjVkDgDcOp8qqr5U1sIHPGTtZpiXwfJzlSbLw77WOZgdeSH3PlJwZDDwybhkFuUT5GQGRcD3A/1ggchZVrVBhrKG2K+PtQlTyVUD94DAlof6FaodJWP8cdhNbjCDCWTwI0IhPXLtRFafzs5JiSBvu52hT8J1dAYIVGrrWjYi+89b0XK+ogOfbabeV/eagPFN5BnohrJLmtkuJoZp9CQvUX3AGRt99mENDxDJVeTQDY1OijLBtNP7eQI94+NmXYUZ3w0YKsetim13+qsfdhBFbqMkMZUlXn/NXeXANEedI7UxHjRttY/CTLrz3EwQEG2YdjIwGBQiaftdAcHPiB+lRz38+QicUnweWzXOzI2MOEEYGLiG/EjlUQ6YEykQk5RRat/UW4uy4YxAJBp+xesTmqE6HEyMi/J6T3GcEWbTTas8ZC5pPRIwkyA1hqz4A/lSiZ//3NL7mpWCUgr5HR0x/zM3DggFSf8QolUF8jhemcJzOLIrIbeJ4DmLqauGPh+lbkb34DqwnuJyRvSpeLzin1SFeSX+hVL8QKOD+Vdm7rrRa8NQTS8q4c2cyc6+uq0/pcLkKazqgfrAAksXyZgHCbYXvYoPydpZQGyzFsMtRITeMgV9iW2TKa0kC2fd7bgru0j77Wia2WInkaRLy96Xdyguxbr6Z4FzBp6U8I35PM4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 03:01:26PM -0700, Matthew Brost wrote:
> On Tue, Jun 23, 2026 at 03:32:58PM +1000, Dave Chinner wrote:
> > On Mon, Jun 22, 2026 at 05:09:33PM -0700, Matthew Brost wrote:
> > > On Tue, Jun 23, 2026 at 09:10:43AM +1000, Dave Chinner wrote:
> > > > On Tue, Jun 16, 2026 at 08:22:17PM -0700, Matthew Brost wrote:
> > > > > High-order allocations using __GFP_NORETRY or __GFP_RETRY_MAYFAIL
> > > > > are often opportunistic attempts to satisfy fragmentation-sensitive
> > > > > allocations rather than indications of severe memory pressure. In these
> > > > > cases, reclaim may invoke shrinkers that aggressively destroy working
> > > > > sets even though reclaim is unlikely to materially improve the
> > > > > allocation outcome.
> > > > > 
> > > > > Some shrinkers manage expensive backing or migration operations where
> > > > > reclaim can result in substantial working set disruption despite the
> > > > > system having sufficient free memory overall. This is particularly
> > > > > visible in fragmentation-heavy workloads where reclaim repeatedly tears
> > > > > down active state while kswapd attempts to satisfy higher-order
> > > > > allocations.
> > > > > 
> > > > > Introduce an opportunistic_compaction hint in shrink_control that allows
> > > > > kswapd to communicate when reclaim originates from a high-order
> > > > > allocation context that may be fragmentation driven rather than true
> > > > > memory pressure. Shrinkers may use this hint to avoid destructive
> > > > > working set reclaim while still participating normally during order-0
> > > > > or stronger reclaim conditions.
> > > 
> > > Thanks for the input - this is a tough problem.
> > 
> > Yes, that it is.
> > 
> 
> This is part of what makes this fun.
> 
> There’s a lot to go through here—I’m going to start actively working on
> a PoC, hopefully today. I’ll likely have more feedback as this gets
> coded, but let’s continue to stay aligned.
> 
> > > > To be honest, this seems like another "push a hint through to the XE
> > > > shrinker" mechanism under a different name. You seem so focused on
> > > > fixing the XE reproducer that the -systemic problem- that -any-
> > > > high-order folio demand causes is not being acknowleged.
> > > > 
> > > 
> > > I'm not exactly sure I agree here. Communicating via __GFP_NORETRY or
> > > __GFP_RETRY_MAYFAIL with a higher order implies that the caller can
> > > handle higher-order allocation failures, so the shrinker shouldn’t try
> > > too hard to obtain a large page (e.g., evict a working set). I agree
> > > that Xe is currently the only shrinker making use of this, but other
> > > shrinkers could also hook into it. This information simply isn’t
> > > available today.
> > 
> > Right, but "we are doing compaction" isn't information that tells
> > the subsystem shrinker what it needs to do. "memory compaction is
> > occurring" isn't a well defined action like "count reclaimable
> > objects" or "scan N objects and reclaim as many as you can without
> > blocking".
> > 
> > Directed high order object reclaim should be much efficient that
> > trying to use general memory pressure to age out enough objects to
> > reform contiguous pages. We need to help memory compaction, and we
> > can't really do that by layering heuristics over reclaim algorithms
> > designed to maintain working sets efficiently.
> > 
> > > > e.g. we use high-order folios extensively in the page cache these
> > > > days, and there are -many- cases where memory compaction driven by
> > > > high-order demand cause significant performance regressions for page
> > > > cache performance. To date, every single person who has wanted to
> > > > fix the problem they are seeing has effectively attempted to -turn
> > > > off compaction- via GFP flags.
> > > 
> > > So does that mean they clear __GFP_RECLAIM?
> > 
> > Usually __GFP_DIRECT_RECLAIM, as it's the overhead of direct
> > compaction that causes the performance problems.
> > 
> > > That isn't really what in DRM or Xe. In former case we have pools of
> > > lower order pages in TTM not in use that can be shrunk, potentially
> > > freeing multiple lower orders pages so a higher order page formed, and
> > > the later possible BOs (sets of pages) in Xe marked as purgable (not is
> > > in working set) which can also be shrunk. Other DRM drivers have purging
> > > concepts too.
> > > 
> > > I’m not very familiar with what other shrinkers or subsystems want, but
> > > presumably other shrinkers have pools or caches that aren’t currently in
> > > use, where they can say, “OK, I’ll give these pages up for opportunistic
> > > compaction, but I won’t give up my working set.” Of course, as mentioned
> > > above, if someone else explicitly requests large pages by avoiding
> > > __GFP_NORETRY and __GFP_RETRY_MAYFAIL, the shrinker should then give up
> > > its working set.
> > 
> > Most caches are slab-based, so there can be 10s of objects with
> > different life cycles per page. There is no almost possiblity that
> > shrinker reclaim will free pages without substantial
> > amounts of the cache being reclaimed.
> 
> 
> Yes, I agree most shrinkers are slab-based, but there are at least three
> notable exceptions that I’m aware of—potentially more (let me know if
> there are others which are aware of):
> 
> - The TTM (the most common memory allocator for DRM drivers) pool
>   shrinker maintains pools of pages that are free (i.e., have no
>   driver-side references).
> - DRM driver-side shrinkers maintain both non-active pages (marked as
>   purged by user space) and active pages that are either idle or
>   short-term pinned via dma-fences.
> - The deferred_split_shrinker, which holds pages in larger-order folios
>   that have been partially unmapped.
> 
> All of these can free substantial amounts of memory—sometimes very
> quickly, and sometimes with a delay (e.g., when waiting on short-term
> pinned memory via dma-fences).
> 
> The deferred_split_shrinker in also seemingly has an issue where
> it can worsen fragmentation in certain cases. For example, if we need an
> order-9 folio and it shrinks a partially freed folio of the same or
> smaller order, this doesn’t help and may actively make fragmentation
> worse by shattering folios. While we’re here, this likely should be
> addressed—unless I’m missing something.
> 
> > 
> > > > I've even done that myself inside XFS to work around kvmalloc()
> > > > issues with a lack of GFP_NOFAIL support and doing costly high order
> > > > allocations that fail and trigger compaction before falling back to
> > > > vmalloc().  However, these issues have since been fixed in the
> > > > kvmalloc() code, such that it now does the right thing for most
> > > > calling contexts (i.e. tries high-order kmalloc() without triggering
> > > > compaction, then fall back to GFP_NOFAIL vmalloc()). This has made
> > > > kvmalloc() more performant and better behaved for -all users-, not
> > > > just XFS.
> > > > 
> > > > This is not sustainable - we need compaction to be robust and
> > > > performant in the face of high-order folio demands, regardless of
> > > > what subsystem is generating the demand.
> > > > 
> > > > So with that in mind, let me paraphrase the comment in the second
> > > > patch in the Xe shrinker implementation:
> > > > 
> > > > "Shrinker reclaim is based on implementation specific object sizes
> > > > so it is unlikely to ever acheive contiguous page reclaim in a
> > > > manner that will measurably improve compaction rates."
> > > > 
> > > 
> > > This might be slightly misworded—what I really mean is that I don’t want
> > > to give up my working set for higher-order allocations that are allowed
> > > to fail, but I do want to give up my cache.
> > 
> > Right, that's the core of the problem - compaction is the high-order
> > reclaim trigger, the existing shrinker infrastructure reclaim is for
> > the working-set maintenance reclaim algorithm the subsystem uses..
> > 
> 
> Ok. We also need to consider how direct reclaim and compaction interact.
> Shrinkers are currently invoked during direct reclaim, which I believe
> is correct—this helps with compaction and is desirable. More on this
> below.
> 
> > > > You also say:
> > > > 
> > > > > No functional changes are introduced for existing shrinkers.
> > > > 
> > > > Consider how many shrinkable caches the general statement above
> > > > applies to, and then think about the fundamental impedence mismatch
> > > > between the affected shrinkable caches and what this patch actually
> > > > fixes.
> > > > 
> > > 
> > > Yes, as mentioned above, I’m only addressing Xe here, and I agree that
> > > this is likely an issue. Do you know of other shrinkers that have pools
> > > or caches which can be shrunk under the conditions I’m introducing here,
> > > but also have a working set they would prefer not to give up?
> > 
> > The first that comes to mind is the xfs_buf cache. This cache holds
> > cached metadata buffers that have different sizes can each contain
> > up 64kB of contiguous pages. The allocation algorithm uses
> > optimisitic large folios allocation, but if that fails it falls back
> > to vmalloc. The working set is maintained by a prioritised
> > multi-scan LRU so that more frequently accessed metadata is held
> > tighter by the cache than less frequently accessed (e.g. btree roots
> > have higher retention priority than the lowest leaves).
> > 
> > It does not currently track buffer objects by size, by if there was
> > a benefit to doing so then it could be implemented. I'd much prefer
> > to have such tracking separate to the working set maintenance,
> > especially as they will likely need some kind of balancing to
> > prevent high-order buffers in the working set from being thrashed by
> > compaction demand....
> > 
> > I know there are other caches that have variable sized objects, but
> > I'd have to go look at the code to referesh my memory of which ones
> > they are...
> > 
> 
> I'll have to look more here to be able to respond intelligently.
> 
> > > If so, a
> > > link on elixir.bootlin.com would be helpful so I can take a look. I’ll
> > > also try to go through other shrinkers myself.
> > 
> > cscope is your friend.
> > 
> > fs/xfs/xfs_buf.c contains the XFS buffer cache and shrinker
> > infrastructure, but looking at the code without any understanding of
> > the filesystem structures or how it interacts with the other XFS
> > shrinkable caches probably isn't as useful as you might think it
> > will be.
> 
> Agree. Looked at some FS shrinkers and got lost quickly.
> 
> > 
> > > > For example, what happens to slab-based caches if the XE cache is being
> > > > excessively reclaimed under high-order page demand? e.g. the slab-based
> > > > cache may have tens of objects per page and holds a system-level
> > > > performance critical working set of objects. How do these caches
> > > > handle the excessive reclaim demand being generated by compaction
> > > > thrashing?
> > > > 
> > > > Yup, they don't.
> > > > 
> > > 
> > > Agree.
> > > 
> > > > In the case of filesystem caches, the "reclaim and repopulate"
> > > > pattern you describe causing the XE perf problems causes internal
> > > > slab cache fragmentation. Not only does this not improve compaction
> > > > rates, it also results in more memory fragmentation because slab
> > > > pages get pinned by a small number of long lived objects and they
> > > > won't get freed until the cache is largely emptied.  IOWs, things
> > > > get -even worse- from a memory fragmentation POV when compaction
> > > > thrashing causes the working set of a high-object-count-per-page
> > > > slab cache to thrash....
> > > > 
> > > 
> > > Got a link to the code which you are referring to?
> > 
> > Do a lore search for "dentry cache defragmentation". You should be
> > able to find discussions that go back to around 2006 about
> > discussions on identry cache fragmentation and approaches like
> > slab-page based object reclaim to support internal defragmentation.
> > 
> > The fact that we don't have slab cache defragmentation despite many
> > years of people wanting such functionality should tell you how
> > complex the problem is.... :/
> > 
> > > That seems like a problem similar to another issue in DRM/Xe. We found
> > > that the process of shrinking actually drove fragmentation by splitting
> > > folios down to order-0 and then backing pages up one at a time. I have a
> > > separate fix in flight for that.
> > 
> > Possibly, though the life cycle differences I'm talking about can be
> > a few milliseconds (temporary file) vs weeks (long running database
> > instance holding it's table files open the whole time it is
> > running).
> > 
> > > Could the filesystem detect these hints and avoid shrinking in a way
> > > that causes fragmentation?
> > 
> > Not really. The fragmentation problem is caused by physical object
> > placement in the slab pages at allocation time, not the act of
> > reclaiming the object.
> > 
> > i.e. we don't know what the expected cache life time of a dentry or
> > an inode will be when we allocate it, so it just gets allocated in
> > the next free slot in the current partial slab page. When you get a
> > mix of dentries that are pinned by open files in long running
> > applications and dentries for access-once files in the same page, we
> > end up with reclaim freeing all the object slots that contained
> > access-once files. However, the pages are still pinned by the
> > objects for the open files that are in active use.
> > 
> > IOWs, LRU-based reclaim can free >90% of the objects in a cache that
> > held millions of objects with mixed lifetimes and still not free any
> > memory at all. There's nothing reclaim can do about it because the
> > problem is created at allocation time when lifetime is a complete
> > unknown.
> > 
> > > Alternatively, could it perform shrinking in
> > > a way that doesn’t shatter folios, or detect long-lived objects so it
> > > understands that shrinking isn’t going to help reduce fragmentation?
> > 
> > Referenced filesystem objects are not on the LRUs, so the shrinkers
> > aren't even aware of such long lived objects. And, as per the
> > "dentry cache defrag" comment above, we can't ask the slab to
> > reclaim or move objects because we don't track the owners of
> > external references to the objects themselves.
> > 
> > > 
> > > > This isn't isolated to individual subsystem thrashing.  If we run a
> > > > file-based workload that generates high-order folio demand and hence
> > > 
> > > What GFP flags are typical used for file-based workloads?
> > 
> > Mostly GFP_KERNEL, with a mix of GFP_NOFS. non-blocking paths also
> > tend to add GFP_NOWAITS, and memory reclaim sensitive paths often
> > use __GFP_MEMALLOC to prevent reclaim recursion. Some filesystems
> > also make extensive use of GFP_NOFAIL (e.g. XFS).
> > 
> > > > compaction (e.g copy tens of GB of files between two XFS, ext4 or
> > > > btrfs filesystems), that will -also- trash the Xe working set via
> > > > the shrinker being hammered by memory compaction try to free up
> > > > contiguous pages for the page cache.
> > > >
> > > 
> > > I could see this.
> > > 
> > > > Similarly, if we run a Xe workload that generates sustained high
> > > > order folio demand, that will trash the working set in the dentry
> > > > and inode caches and any other shrinkable slab-based cache.
> > > > 
> > > 
> > > I could also see this but DRM / Xe will set __GFP_NORETRY or
> > > __GFP_RETRY_MAYFAIL on higer-orders so those caches should be able to
> > > not trash its working set if looked for this hint. 
> > 
> > This relies on all the allocation code everywhere always doing
> > exactly the right thing so that memory reclaim "behaves". That is
> 
> Yes and no. The original issue was a DRM/TTM self-feedback loop, where
> we need some shrinking/reclaim, but not all. In general, this feedback
> loop also occurs on CPU/GPU client paths, so running XPS alongside heavy
> DRM/TTM with a client part is a very unlikely use case.
> 
> > what I've been saying is not a sustainable approach - all it takes
> > is one allocation or one shrinker not to do the right thing, and
> > we've got another mole to whack.  i.e. memory allocation should do
> > the right/best thing for the system with default parameters.
> > 
> 
> I agree that another allocation could shrink DRM/TTM buffers, but when
> DRM/TTM reallocates, it won’t trigger the same feedback loop since it
> uses the correct GFP flags. While it’s true that two conflicting
> allocations can ping-pong, we are also working on a DRM/TTM reclaim
> backoff mechanism and a defragmenter. However, if a self-feedback loop
> exists, this effort becomes ineffective.
> 
> > > > Hence the abstracted case of the problem we need to solve is this:
> > > > shrinker reclaim is based on x-byte objects is extremely unlikely to
> > > > acheive contiguous page reclaim in a manner that will measurably
> > > > improve compaction rates.
> > > > 
> > > > This is a problem that has to be addresses by the high level
> > > > infrastructure level, not worked around by individual shrinkers.
> > > > 
> > > > IMO, compaction shouldn't trigger shrinkers unless the shrinkers are
> > > > specifically flagged as being able to release contiguous pages of
> > > > memory in short order. I don't think there's very many shrinkable
> > > > caches that even hold a significant quantity of objects larger than
> > > > a single page, so it's clearly questionable as to whether compaction
> > > > based reclaim should run shrinker reclaim to begin with.
> > > > 
> > > 
> > > Yes, sort of do this in Xe by changing '->count_objects' based on the
> > > hint.
> > 
> > I know. That's the problem - it's relying on the infrastructure
> > passing down a specific internal context hint in an existing
> > interface so a specific subsystem can work around a specific
> > problematic behaviour.
> > 
> > Indeed, for compaction we don't actually care about the count, what
> > we largely care about is whether the subsystem has any objects the
> > same size or larger than the current compaction demand. Efficient
> > object reclaim for compaction has a different control variable set
> > (e.g. find objects larger than, objects physically near to, etc),
> > and this can't really be properly fitted into the existing
> > count/scan shrinker reclaim algorithm.
> > 
> > Hence I think it needs new shrinker methods to implement
> > effectively.
> 
> Looping back to direct reclaim above—would these new methods also be
> called during direct reclaim? My thinking is yes.
> 
> > 
> > > > i.e. a subsystem that can track high order folios in a shrinkable
> > > > cache should probably have a "->compaction_scan()" method that is
> > > > run directly from compaction context to try to free high order
> > > 
> > > When you say “compaction context,” which parts of the code are you
> > > referring to? I’d like to explore this option, but I need a bit more
> > > context.
> > 
> > kcompactd does background compaction, similar to how we have kswapd
> > to do background memory reclaim.
> > 
> 
> kcompactd doesn't call shrinkers - this is where we'd call compaction
> shrinkers?
> 
> > Direct compaction (part of direct reclaim) via
> > __alloc_pages_direct_compact() that will be called before direct
> > memory reclaim in the case of a high-order allocation.
> > 
> 
> So maybe this is where compaction shrinkers fits in in direct reclaim?
> 
> > > 
> > > > folios. This provides a direct opt-in mechanism for a subsystem, and
> > > > it allows subsystems that can track low- and high- order objects
> > > > independently to efficiently free objects in a way that will help
> > > > improve compaction rates without impacting the entire working set of
> > > > objects in the cache.
> > > 
> > > 
> > > Does this help if, for example, the cache is holding onto two order-8
> > > folios that could be freed and merged, while the caller really wants an
> > > order-9 folio? This seems like a possible scenario in caches and is
> > > certainly true in TTM pools.
> > 
> > Depends on how the interface is implemented.
> > 
> > IIUC, the direct compaction code will return a right-sized page
> > early if it creates one via compact_zone(). Hence if that path can
> > call into shrinkers to do high-order scanning that results in two
> > mergable order-8 objects being freed and merged into an order-9
> > object that fulfils the compaction requirements, then it will result
> > in compaction succeeding where it currently fails.
> >
> 
> I think this answers my question above - call compaction shrinker here.
> 
> > And I think that kcompactd will run until certain watermarks are
> > met, so again having a high-order shrinker that directly impacts the
> > high order page watermarks would be much more efficient that trying
> > to use general memory pressure to randomly shoot down enough objects
> > to reform contiguous pages.
> > 
> 
> I think this answers my question above - call compaction shrinker here.
> 
> > > > IOWs, this patch to inform kswapd about it's trigger (doesn't it
> > > > already have a "reason" parameter, though?) is likely a necessary
> > > > part of the solution - we don't want kswapd running shrinkers if it
> > > > has been triggered to reclaim pages for compaction. This patch would
> > > > allows kswapd to elide normal shrinker passes when it has been woken
> > > > purely for compaction purposes. Given that the compaction code would
> > > > be running the high-order reclaim capable shrinkers itself, this
> > > > would avoid trashing the working set of most shrinkable caches -by
> > > > default- under high order allocation demand....
> > > >
> > > 
> > > I’m trying to parse this—are you suggesting that, one way or another, we
> > > introduce a heuristic where shrinkers can act on a hint (whether it’s
> > > what I have here or a new ->compaction_scan() vfunc), and then attempt
> > > to fix all shrinkers in this series?
> > 
> > I don't want existing shrinkers to be touched at all.
> > 
> > What I want is for memory reclaim (both direct and kswapd) to elide
> > the shrink_slab() calls into shrinkers when memory reclaim is being
> > driven by high order allocation failure.
> > 

I went and traced the reclaim/compaction interaction in detail before
replying again - I don't think your suggestion works. Let me lay this out
in detail with examples.

The premise of eliding shrink_slab() is stated a few times in your
reply, e.g.,:

'shrinker reclaim is based on x-byte objects is extremely unlikely to
acheive contiguous page reclaim in a manner that will measurably
improve compaction rates.'

This is true for some shrinkers, such as slab-based shrinkers, but it is
clearly not true for others, such as TTM pools or GPU driver shrinkers
that reclaim purgeable or inactive memory outside the working set.
Additionally, XFS appears to retain significant amounts of memory
through folios and kvmalloc allocations.

This is somewhat of a moot point, though, because producing contiguous
memory is not reclaim's responsibility during high-order allocations.
Compaction is responsible for creating contiguous memory. Reclaim's job
is to free enough pages for compaction to run in the first place.

That's not my reading of intent, it's what the code says:

  include/linux/compaction.h:62

    /*
     * Number of free order-0 pages that should be available above given
     * watermark to make sure compaction has reasonable chance of not
     * running out of free pages that it needs to isolate as migration
     * target during its work.
     */
    static inline unsigned long compact_gap(unsigned int order)

  mm/vmscan.c:6064, above should_continue_reclaim()

    /*
     * Reclaim/compaction is used for high-order allocation requests. It
     * reclaims order-0 pages before compacting the zone.
     * should_continue_reclaim() returns true if more pages should be
     * reclaimed such that when the page allocator calls
     * try_to_compact_pages() that it will have enough free pages to
     * succeed.
     */

So the designed pipeline is "reclaim supplies free pages, compaction
assembles them". Scattered order-0 freeing isn't a failure mode of that
pipeline, it's the input to it.

The part that makes this concrete rather than philosophical is that the
free page supply is a hard gate on compaction, not a soft input to it:

  mm/compaction.c:2394, __compaction_suitable()

    watermark += compact_gap(order);
    if (order > PAGE_ALLOC_COSTLY_ORDER)
            watermark += low_wmark_pages(zone) - min_wmark_pages(zone);
    return __zone_watermark_ok(zone, 0, watermark, highest_zoneidx,
                               ALLOC_CMA, free_pages);

  mm/compaction.c:2525, compaction_suit_allocation_order()

    if (!compaction_suitable(zone, order, watermark, highest_zoneidx))
            return COMPACT_SKIPPED;

and compact_zone() bails at line 2563 on anything that isn't
COMPACT_CONTINUE.

Below that threshold compaction does not run at all. Not "runs less
effectively" - COMPACT_SKIPPED, before the migrate and free scanners
are ever started.

Now let's consider two examples:

- A memory-intensive GPU workload has run and completed, leaving pages
  either in the TTM pool or on the driver side outside the working set.
- XFS reclaimable cache is holding onto large amounts of memory.

If reclaim elides shrink_slab() for all high-order allocations, then on
that system:

  - the shrinker-owned memory can't be reclaimed at all
  - LRU reclaim alone cannot lift NR_FREE_PAGES over
    watermark + compact_gap(order),
  - so compaction_suitable() stays false,
  - so compaction never runs,
  - so the high-order allocation fails without a single compaction
    attempt having been made.

Today those allocations succeed, because shrinker-freed pages clear the
gate and compaction then does the assembly. So I think eliding
shrink_slab() for high-order reclaim would regress high-order/THP
allocation success rates.

Hillf made essentially this point upstream in this thread and I don't
think it got picked up:

  "compaction works only when there are enough free regular pages
   available, with nothing to do with shrinker directly"

So my thesis is that shrinkers must run before compaction. We should
give shrinkers a hint indicating whether reclaim is being performed
opportunistically for high-order allocations, in which case it may not
be worth evicting working set data that is expensive to save and
restore or if shrinking actively makes fragmentation worse.

I audited the shrinkers and found roughly ten that could make use of
this hint. Perhaps the most important is the deferred split shrinker,
which actively increases fragmentation when it runs.

By the way, I have the heuristic wrong here, since vma_thp_gfp_mask()
will not trigger the opportunistic hint, even though it should because
it has a fallback path.

So I'd like to post another revision of this series that fixes the
heuristic and also wires the hint up to the deferred split shrinker.
Then individual maintainers can decide whether and how to make use of
the hint in their own shrinkers.

Matt

> 
> I still think compaction shrinkers need a concept of “opportunistic”
> versus “must free memory to compact” to avoid the self-feedback loop I
> described. Without this, the DRM/TTM self-feedback loop would still
> exist.
> 
> > i.e. high-order allocation failure should not generate shrinkable
> > cache memory pressure because shrinkable caches in general cannot
> > return contiguous memory that will allows compaction to make
> 
> Yes, I agree with “shrinkable caches in general,” aside from the
> exceptions I outlined above (though perhaps I’m missing other
> exceptions).
> 
> The risk of what you’re suggesting is that it would suddenly change the
> entire shrinking model across Linux, and we don’t know what unforeseen
> consequences this type of change might have. Nor could a single person
> reasonably test a change of this scope. That’s why an incremental step,
> like this series—which fixes DRM/TTM as opt-in—may make more sense. As
> mentioned above, the deferred_split_shrinker is also a very likely
> candidate for being fixed. That said, I’m going to look into your
> suggestion as well.
> 
> > progress. The existing behaviour has more negative affects on system
> > performance than positive, so we need a fix for "everyone".
> > 
> > I think we should provide a new opt-in ->compaction_scan() method for
> > compaction aware subsystem shrinkers that is run from compact_zone()
> 
> compact_zone() appears to be called from both direct reclaim and
> kcompactd(), so perhaps some of the questions above are already
> answered.
> 
> > context. This allows subsystems that can manage high order objects
> > to optimise the return of high order objects to the free space pool,
> > thereby significantly improving the chance for compaction to
> > succeed without adversely impacting the rest of the shrinkable
> > caches in the system.
> > 
> > Further, we should not kick kswapd because of compaction failures
> > because kcompactd will already be running ->compaction_scan()
> > capable shrinkers from it's callouts to compact_zone() in the
> > background that will do this work as efficiently as possible.
> > 
> > > I’m open to trying to fix other
> > > shrinkers as well. Do you have any particular ones in mind? I count
> > > around 45 shrinkers in Linux, so it’s unlikely I can fix every single
> > > one, though or all shrinkers need to be fixed.
> > 
> > They'd all need to be fixed, which is why I suggested a new method
> > to be added. Avoid calling the existing shrinkers in the adverse
> > situation, call the new one from the right context where it actually
> > benefits compaction and high-order memory allocation.
> > 
> 
> OK, this seems fairly reasonable on its surface despite my concerns
> above, but see my comment above regarding “opportunistic” vs. “must free
> memory to compact.” Without that distinction, I don’t think my original
> problem would be solved.
> 
> Given this scope / risks, can I ask for one of two things:
> 
> - We move ahead with this series as a stopgap fix, or
> - Allow DRM/TTM/Xe to implement shrinker-side heuristics to break the
>   feedback loop
> 
> while I work on this larger refactor. This is the type of work I enjoy
> doing, and I typically have the flexibility to work on what I think is
> most impactful.
> 
> > > On a side note, I just noticed that struct shrinker has count_objects
> > > and scan_objects as individual vfuncs rather than using a const struct
> > > shrinker_ops *ops. Should we change that? The latter seems cleaner and
> > > is typically how things are done in Linux.
> > 
> > We probably should - the current structure is largely historical and
> > there's only ever been two methods. If we are adding another method,
> > then it would probably make sense to add an external ops structure
> > to reduce the memory footprint a little.
> > 
> 
> Let me look into this as well. I don’t know the exact merge flows for
> tree-wide changes, but I can figure it out.
> 
> Matt
> 
> > -Dave.
> > -- 
> > Dave Chinner
> > dgc@kernel.org

