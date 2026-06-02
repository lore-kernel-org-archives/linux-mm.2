Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6126CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 13:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DADE6B03B3; Tue,  2 Jun 2026 09:18:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B2806B03C9; Tue,  2 Jun 2026 09:18:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2376B03CA; Tue,  2 Jun 2026 09:18:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 383196B03B3
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:18:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 090021A08AE
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:18:59 +0000 (UTC)
X-FDA: 84835027998.03.D01A7E5
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf07.hostedemail.com (Postfix) with ESMTP id B64D940014
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:18:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RfNoClah;
	spf=pass (imf07.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1780406335;
	b=wyWLG3zUgf33k5Hmb26GDmhZHJcb1igcpdNGu2raAk0pc+Jum2OauVDq6XZdub8l4WcHF7
	j/fVMPdJc/vUyhN1eu2KrZjgzKhJl4RC51bxXjrWB6/xatgPvuMF0fPt7E4UCer+ZN7s7+
	TjDb3Lzu7aB6lSLO/DXAIL6XIj4645c=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RfNoClah;
	spf=pass (imf07.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780406335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JQSIlR+kjpvE4G2/4d0H1utbNhArblcnXK/88PtoZ2E=;
	b=m792QtbgsezO/rL5Nk7NZRh+T56ME52RBW1SNSlQItPM/Lio8y0uibnj8qrUZkQ4G53PUd
	mqIFVULXitNO0i+9Hp2nBvlE4T4KNT8Y3R3IJtNH1nemjnlzEdm1t6YySgzcIU3Cl2j+LU
	xel0yAuhT+4wTxzyh3Kv6Ft4G3OOxwQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780406335; x=1811942335;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=qmu4hKvbR9IFA6IeNcy3xQriHSMRFejpCXuvHkTlS64=;
  b=RfNoClah4wf+mwaXHDlaUQXEuiyMbX5Y3Ht8zQuWzY3xHXV90bUD/05l
   PO+O1HI7q/NsSQsekD6IxibrcZHbeC8yTVDZ5udka8SqZgEI4SzvBNicn
   9Xvdw8cbCLrvtpnfkqfR0JGB5RqHJoRK6Lr7NtnPeTcWLrGEQ0d0cMMwI
   8JMkGMUrPLrjpChhTaR/i4f4uMujo1SZWqG5H88fTXCVHi4V8KY9uc1KM
   90o5c4cFEryZlCqZ3En8ZSdOF5f1ghEzqw0+tUm0GS2pm2z9mnnL+Pi2Z
   M9RKlEg2Fi6BAlI36XetjKZcWibawUHsUIUGd5X4M4D11J4O7/qrHv5El
   Q==;
X-CSE-ConnectionGUID: Z5dnbZX3SwyjXa8NGY//qQ==
X-CSE-MsgGUID: +x3jXnTtSKO+QFngroYkBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="91764945"
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="91764945"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 06:18:53 -0700
X-CSE-ConnectionGUID: W6dMSrGUQFG/myaNIsNVow==
X-CSE-MsgGUID: khunKnJUS8Khlh6ye0CDCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="245712953"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 06:18:53 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 06:18:52 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 2 Jun 2026 06:18:52 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.37)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 06:18:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WmHaBvNZx/P+qXgnk1ZGGuL5LpHrM3E8nNp7ua6kEjkNgUdQbVLg/Ks3fYBtygI2/u2a76J/uTtU2ryeSEYMc46DLuN8jZVZaB+q+fXiZ3aQfNxzvVHV7x1xyk+AWu6x3ovXCVHhPe8BovPca9EV1kyyO3hiZvIKXnZf9TBcGJiifA/X6zyy95wTPZ5QaSZZjVgsfl+rtiklTT+5pWSnM6kgTMvtNe4KpXxWS1l8imQzl2Q6+slDSxK++gE8ZAzZsghENDTRSNn1+FXbS+GIqRN/c+H2iWLMC8rGy8wae9M/UXVtnCzuHFLiTaREqfOz2UnaorHPJvbeCxBJbqR4+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xtPyEqz4N/vs7GVd2q0+h8ijL7zfSeAIAo6GsqPxszo=;
 b=FRJwqem9rNJMC9E1ng20wTfSNsRFrku4G5+Pxq8G+feOm1aLJVzzYukNtV+R0UiF7kSbUrVp+PXO39dx2cDyXGDo8uYgSEgz2H0wNg9w8/umZ3UEB6P6pm/GkjqbgkyB9Njgd2at6njlRiVd3gEGK9z+Z8Lhf4Xi7AbHfJu3P/7pAykh2I0tBgOMAWkdOf60mIfCGt6rq/Euu7kS0CJn4a5uT+L9Y0UowvkLuqYP1wT4uUZYzMpOESO8FU5L0B45Tz1jng3ON+tr8W1snkbq225WOXlbGEoYtxlVFCQXlNuU8Lf7e26z7BcQmB94wa95fq7Lkind/GFVA+hUZvSoCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by BN9PR11MB5321.namprd11.prod.outlook.com (2603:10b6:408:136::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 2 Jun 2026
 13:18:49 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0092.006; Tue, 2 Jun 2026
 13:18:48 +0000
Date: Tue, 2 Jun 2026 21:18:36 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Ryan Roberts <ryan.roberts@arm.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, Muhammad Usama Anjum <usama.anjum@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, "David
 Hildenbrand" <david@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	"Brendan Jackman" <jackmanb@google.com>, David Sterba <dsterba@suse.com>,
	"Johannes Weiner" <hannes@cmpxchg.org>, Liam Howlett <liam@infradead.org>,
	"Lorenzo Stoakes" <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike
 Rapoport <rppt@kernel.org>, Nick Terrell <terrelln@fb.com>, Suren
 Baghdasaryan <surenb@google.com>, Vishal Moola <vishal.moola@gmail.com>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [vmalloc]  60ced5818f: stress-ng.shm.ops_per_sec
 7.2% regression
Message-ID: <202606022131.112319f2-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: KUZPR04CA0022.apcprd04.prod.outlook.com
 (2603:1096:d10:25::14) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|BN9PR11MB5321:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dc1ac4c-1eff-4ae4-3af1-08dec0a97b6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|6133799003|18002099003|3023799007|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: oekvD1D9Lxk1F2CP16ISkIgkPcKu9W8cQlOoNu63APLCr4rpgMETJSGLr4DKW6BVzfl56Q4wBXbsQUOaaDJSKK+YDjIJPSNhJtc6D43tsor3qB24h0+ma20mCunKDjZuO6uA4kWq91MmTmWkqnAx6llaSoKbDiEHyGN7hjLsH5UysAfd8S7Rnab2xT5U9AYmCUYhn4w9ZObxhhMnsfdgGiV24UN+5Z2ixQQ9tjtXmBSkqNidC/Ywos73iiszWEyGQltXBlKAomFi/h/viRfCVEac9C1DoOi8LShBSi/rY9jhccxfyABgnV5ejN+u896LA82WSPSnUfQ/8g4x+H8NJMXgRm/mgo1R5EGpMXBFR8/CoFcR44cQupKAQHZEMNjCTH/zOuc4Uu5JvulCrNRpqRAfeDcq2lq0mupaTa94WaOb9K7BoHk6mlR8G+raKXX02x49AoU52WimTrNNKQRAOVcT2ZTBX5tH4U4oyuli+h9/kpPJEweqIattTJp9FDIFszBks3W43a2djjBJYq3/tGpeyR05ps9vJhnJAHrCdFtKNgNc6bPQHIw7lnfHivRnBflzDHnY4KqkQQZi2riL0qKDO368OhsmLKRJOmWg3jD/xx61Gl7uX3xbtSI4n3AHRea6lfcWUJ7OFIYraZgpsIFUMggddO+ASoSWHx+7oHGSHdZJAnJkk6pWH3zWygGhHk8MWYJI/arX02UUEZC53A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(6133799003)(18002099003)(3023799007)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?tryctfv5q/V4x7fEv/8EtO6qpIMloCKfktCtsaAIs/B8Y6s6NaR0fYY6fN?=
 =?iso-8859-1?Q?50hE7ZjPBkivEu1U23Qr+jtOGT01U90Nj74du3NvVSsIkovva/qeIub/7x?=
 =?iso-8859-1?Q?uCMvasGwTNxnLnXGx3cl7KDwS5YW7P4fHULT9/IC9+CKvEVwu/6xeBUiI4?=
 =?iso-8859-1?Q?2QebqiyTYBLS9542u9tXX0OauKuTXXsYlCqlr7/x0v8V/sMCjS728LDcq9?=
 =?iso-8859-1?Q?lAAZQ1gJAWQ2tLeigcmEp0Oe3snPj5nWZHfDWRMi9Dvaovl930Xm5FZgxt?=
 =?iso-8859-1?Q?ExUzqc2Bjy9jKzEe5CVw8t5dDeXQ8xCKB3dJSB2kGZ/TQMzRFcSpaarXyD?=
 =?iso-8859-1?Q?K08OwZHxMvNn+7F8BVD9wFkz/Ki4cjMC8K7ezCNB82D40IcdG1/Hj5aG5Y?=
 =?iso-8859-1?Q?VIhpOGS9aw2b8MyRgqXRRBm3BTSja6eIbsLqLwoOxBI15e23U+Lt9oEOVL?=
 =?iso-8859-1?Q?aQfVd8+uWYswn8ty+lER1iiqLJB0z29tCbl9QOgOXHijXen5hJFkz4lgAA?=
 =?iso-8859-1?Q?xzPdDT044ZlN9Gha2nbh90BXb5PsO56SII+VeecmKpq84XtJ9P9VO0wHze?=
 =?iso-8859-1?Q?bkEicjswN39El2Ggu9kir9QdABR9lyuXbNPK0aW/V2/PCSOWhKCwQ2yPE4?=
 =?iso-8859-1?Q?f5vPN5/o7AVGz9TZOChR4g8quwhAnGbMAEM1LmFbLtsqndURhBSxyY03Qj?=
 =?iso-8859-1?Q?n34+idcb9rI6BsnTrnaIUqycxdRUTjeK1SYAnLoZ+grtOeWGsYsqr8q604?=
 =?iso-8859-1?Q?uZPxGU89o2kd+pGWOWhr067Uitg83MLzcYkWend2r/6SVoRFHikNRseZ9g?=
 =?iso-8859-1?Q?YiI+mpHpNMpTncR+2whCQZnQTNe0ioFXjYvJ/vMA50sDdvqVaP0860Jnl2?=
 =?iso-8859-1?Q?7WBvPc2wzgjVAkxijQxEqmLp83S+WvCe2MkRYJ81AtPGF/Mi08VYmRUd5G?=
 =?iso-8859-1?Q?iCMQJZyAQ6MeFYgayylMhbr84mASMTyIAcNgXwh76EVMXBjBQePHfz/NYi?=
 =?iso-8859-1?Q?fHC8ksKV2sC3M9mEvOSzNw1NCYFZSDdo67jCDfVQA2+d6N4zECnOSlFvUo?=
 =?iso-8859-1?Q?1696FoHfzKM9sUHitUBaIkJ5gkjyG1TSaDFW7Q6mmdOkAogKAcv332kKEs?=
 =?iso-8859-1?Q?EVWX/MgLzxaS9pFZUT3+fv/sSwKQbv0SZwtt+DNV7eZTFjc/6Pa+vY52Fd?=
 =?iso-8859-1?Q?Fsat0wskLKbSlYnLp7y9dm14GlYDeIdtdfg93jq4+mlz6qvoD4jN7IaFPl?=
 =?iso-8859-1?Q?/WHeuESOAWfFpXzIbMggnqax23mCl8dU0SItM1gqwS6YhhJaGA2CFc+I+/?=
 =?iso-8859-1?Q?gNx+asckXCiODB0Hon3ICAREdXK2WcoWnQSh3MqLXrXZVI0r9miyUrIUCD?=
 =?iso-8859-1?Q?rgoq2F7FhFnFOItGytn1yEYgfyg19AZD+l9CecI6NyjzOKRsPUCxpksoYs?=
 =?iso-8859-1?Q?mQFlEFJycElQfMamsnkbiKIj7G9K74DwvhgVeo+4z2U2HfjjKqorZOx8aG?=
 =?iso-8859-1?Q?p503hkemGPjsWrJYlxXZaHQjvC8x2/IDnW9PUnGGzsvwORgn9fyoZCu91C?=
 =?iso-8859-1?Q?ASRoVnSrKfDPYrvjM+/6+VVuo6MUPXUkzYLLPlumwHtGpEaLOqK+HaxOi2?=
 =?iso-8859-1?Q?wiZeMJx3vLQ5szgNU7Vic/ar0pxF57HO1pteQPuik/H45HqAIEey7wq5Z4?=
 =?iso-8859-1?Q?7wkUwnWYK+htqUOnp+fnnUh/70jnP9ki2PxonySVsx+BQbt++4z6bLRFBr?=
 =?iso-8859-1?Q?aGBejlNmMWfzm7t2Gno4PgETMXcoOit0JuyIkmSNgHGopn+d1zRUuWsQZO?=
 =?iso-8859-1?Q?O7YZTtHkXA=3D=3D?=
X-Exchange-RoutingPolicyChecked: rczO5i9iTysnb5uj47jOrCSLHDEAiOk8BTSzpI/aNZvEHZ7pXb6Q20jw73t/86I9A/njft2v9SdbOX0Xocbj9rfwA6uVPB53KZNP8Esh9RHG7cT75x2U2OCA6RSh+Glem7FN2dMkP9rxZo5MRbXdFlKNGEC4/H+MD5iXHPPPagVm9KSPcuT2W7ZNCsZEuf/CXaXsTFLAUGkfc43ulweDc24F/HR587M6rWK7kbeiXEeCKpK4na6CgFNl8gmouI3PIjL+ZarSKdp8+LQl923ylcWv+2LRNsyZR/lZ/6V5Gi3IGADe0JTQGDZ62ic05fyjVM8GrR/481D1Gh9GgE1RnA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dc1ac4c-1eff-4ae4-3af1-08dec0a97b6b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 13:18:48.7824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nDUfiSOKNr90aISN8t5tuiw44x1+NnOqy7wh0h9SVSdl9rIH7BPjrnlTWUNLm6Wlq3Qm2qFCFs9QmF9XsgYBiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5321
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: B64D940014
X-Stat-Signature: xztnn3bhd4zupiggtmw5epccxi4gys4r
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780406334-856642
X-HE-Meta: U2FsdGVkX1+L6k685bSLcgRc6a9dDy3X+4c5clvdvqAQLB7Ls0usIX/TZQGyhkeYxwAJjxZeSrmeFPY6v8CB76fxgI4697LxjGPaNL/UQmuE5+LikxnKvScGoBDmeCx0nzdVd/GNQe5lfjDQAnvDvIXQOc3hoBVbqTHKf1xXtw6xRghqJE+fTs+8aq0oCsz8IPNpGy7u0CH6xAcHm57hZ/ASqm3x1mNqLJ6P3fBxdPTKlie4mjaRA2CjnlCL/dcWrcLN1k/54Woy/XBJWi0zTGSpVnN/GDVtBl+0e3O6kJkogfkGT2CgkwOsWrj5lmTbPZBANZWZChmddOcQgU27fAvlL/+ovabtPjqeL0EPuc/flalVU+EZDoHIPqmo5aHBALNhPs3OFNVCJkxK4xjboiUVTh5RSmTBpw7TNGoqypzXKBoLjzgeJQxHT/XMDcWri2Svkzti12BaJrKAJLuBFLZF2DFqueml+IzRb2xHa0y72A+hOSj+JZOeIsXruOpN5qHcIrsrBCQLnK+1/J0EwnDRPctO9Z4MwTy+AYGz7OZiDNd1pTooG7YN2+QH8z5syOsDGFe2IzQdIVjYy1Dy3U2jglcMeMqwMP3nhu1UnKhVaq4rJBJYKF8KhRUhtpWsVcz7/hJJvVfIoXHox7phaVFthiuO1xiEmlBL2FGfJC0WrulF9efjW7kK6/SJAXNxg/k+s2TplLuOyxuDZP+X6bm27L86pga4HvXE0Zbt9eoLBNXO/q05TZ3ZMDkCtdC6eBbXIXWC6e0DOPVnTWWFtV31L+rD2Y4/EtvcLcYDvyhN8o2AehEX/koy8kowb1C9X86XIVpkqbkg+ymeX+3J4QESPkme2TgamCFvw3wTflq5dNYcnMa8Hl6k2JLc/GkG07NwaiVSYCGqnL6n/ohKW2LL9kJf8cNS/Mup4D/7IvlDZQRr0oIu2h4Xz0ph7OREu8EArh+XVEJV+N5NA/P
 s8zTeKTP
 hh7XIiAEA1h+Kt6nhjJxTmIIS+o/i3Sr2a8R2cI52VB5QrPaxa7GWMoJJ5ZDq+V3+2+kCIAxYy26SyY4u2s6UtS8HwyyfMpOpPqvkrliQwiZ+kTB1Zg9z15KmCopZydOW+DlxACVb9618+XTqS6389MECn5AZIOGaV6EUtj88LWO2l9IJJWizEi4LZePDcCx/rn7zUaQHiDZ4iyc8tWhXTzJvqMSFaB5b/v591inf72yvgmaAOndhuuwJqgGoQdQX/yBmVXW4VqZhPHMJGUzbza8d6NFLKEFImFCIkVp9jpQ9CCAWo6IKylCcwxkRbYR47a1z/PlIEmpGJJx5coQcphf6BxY6J+8pVQrzcfs9u5NH6M1qFn5ZFuLbj6M0UrPx/zl4V0DNiuA+p6qleO0DRObZEF78w39/5C1Yyq3pcbrSi6trj69zEyWGx/CbsdMY6LPM42LgMVgeluZETgajW/iVTc7zske5HBeq1izBC91U1tTIOj1h0GL8u/PUhF20sqwtO3Qbv6OAxr8+SMRyOsptylbIko1J5PA843PEniZfIh8dcaJ+UfBiePkUcP0Wcw5bUfNkwouw+qNg0V/6VNZCuXXnvlfjCv+W24OK7Amqxsjzk+b/VXgxv9LKNcG8WWkzt54dMK8MUgvcGcVnjfQkLdCyVrfA4TSe826+ypRkZlZX8aJQMN5uP/L65XthRvItQl8ytKo5XDPK0mlrhzISfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 7.2% regression of stress-ng.shm.ops_per_sec on:


commit: 60ced5818f64ac356620d1ad3e0d473c457dbf5b ("vmalloc: optimize vfree with free_pages_bulk()")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[still regression on linux-next/master 7da7f07112610a520567421dd2ffcb51beaefbcc]

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: shm
	cpufreq_governor: performance



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202606022131.112319f2-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260602/202606022131.112319f2-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp3/shm/stress-ng/60s

commit: 
  4aa4abf1f1 ("mm/page_alloc: optimize free_contig_range()")
  60ced5818f ("vmalloc: optimize vfree with free_pages_bulk()")

4aa4abf1f14bd6d0 60ced5818f64ac356620d1ad3e0 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
   1103082            -7.2%    1024016        stress-ng.shm.ops
     18394            -7.2%      17072        stress-ng.shm.ops_per_sec
   2084775           -23.1%    1602693 ±  3%  stress-ng.time.involuntary_context_switches
 3.076e+08            -7.3%  2.852e+08        stress-ng.time.minor_page_faults
     14759           -21.1%      11646        stress-ng.time.percent_of_cpu_this_job_got
      8806           -21.1%       6946        stress-ng.time.system_time
     86.08            -7.5%      79.66        stress-ng.time.user_time
   2799689            -1.3%    2762252        stress-ng.time.voluntary_context_switches
 1.125e+09 ±  6%     +42.3%  1.601e+09 ± 13%  cpuidle..time
   2089564 ±  3%     +25.6%    2624591 ±  2%  cpuidle..usage
    360.33           -22.5%     279.35 ± 44%  turbostat.PkgWatt
     36.35           -22.6%      28.12 ± 44%  turbostat.RAMWatt
    198.28 ±  2%      +9.2%     216.55        vmstat.procs.r
    131962            -6.3%     123686        vmstat.system.cs
  14039730 ±  2%     -18.1%   11503879 ± 18%  numa-meminfo.node0.MemUsed
    175943 ± 13%    +114.1%     376780 ±  2%  numa-meminfo.node0.PageTables
    184811 ± 13%    +105.7%     380127 ±  4%  numa-meminfo.node1.PageTables
      9.32 ±  5%      +3.2       12.57 ± 11%  mpstat.cpu.all.idle%
      3.69 ±  9%      +5.6        9.29 ±  4%  mpstat.cpu.all.soft%
     85.37            -8.6       76.73        mpstat.cpu.all.sys%
      1.38            -0.2        1.19 ±  3%  mpstat.cpu.all.usr%
 4.555e+08            -7.4%  4.216e+08        numa-numastat.node0.local_node
 4.557e+08            -7.5%  4.217e+08        numa-numastat.node0.numa_hit
 4.493e+08            -6.8%  4.187e+08        numa-numastat.node1.local_node
 4.494e+08            -6.8%  4.189e+08        numa-numastat.node1.numa_hit
    193547            +7.4%     207908 ±  3%  perf-stat.i.cpu-clock
    193547            +7.4%     207908 ±  3%  perf-stat.i.task-clock
    135837            -8.5%     124266 ±  2%  perf-stat.ps.context-switches
   5141774           -11.4%    4555341 ±  2%  perf-stat.ps.minor-faults
   5141776           -11.4%    4555343 ±  2%  perf-stat.ps.page-faults
    194174           +12.8%     219047        meminfo.KReclaimable
  24232028            -8.6%   22159275        meminfo.Memused
    354997 ± 14%    +111.6%     751255 ±  4%  meminfo.PageTables
    194174           +12.8%     219047        meminfo.SReclaimable
    563220           +16.5%     656030        meminfo.SUnreclaim
    757395           +15.5%     875078        meminfo.Slab
    350188           +11.4%     390033        meminfo.VmallocUsed
  26142507            -9.8%   23588567        meminfo.max_used_kB
     43483 ± 14%    +119.0%      95246 ±  2%  numa-vmstat.node0.nr_page_table_pages
     43257 ±  3%     +12.4%      48605        numa-vmstat.node0.nr_vmalloc
 4.557e+08            -7.5%  4.217e+08        numa-vmstat.node0.numa_hit
 4.555e+08            -7.4%  4.216e+08        numa-vmstat.node0.numa_local
     45890 ± 13%    +109.3%      96035 ±  4%  numa-vmstat.node1.nr_page_table_pages
     44555 ±  4%      +9.3%      48699        numa-vmstat.node1.nr_vmalloc
 4.494e+08            -6.8%  4.189e+08        numa-vmstat.node1.numa_hit
 4.493e+08            -6.8%  4.187e+08        numa-vmstat.node1.numa_local
      0.16 ± 16%    +707.7%       1.30 ± 44%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    346.29 ± 85%   +1061.2%       4021 ± 38%  perf-sched.sch_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.16 ± 16%    +707.7%       1.30 ± 44%  perf-sched.total_sch_delay.average.ms
    346.29 ± 85%   +1061.2%       4021 ± 38%  perf-sched.total_sch_delay.max.ms
      7.34           +58.2%      11.61 ± 13%  perf-sched.total_wait_and_delay.average.ms
      4478 ±  6%     +49.6%       6697 ± 20%  perf-sched.total_wait_and_delay.max.ms
      7.18           +43.6%      10.31 ± 10%  perf-sched.total_wait_time.average.ms
      4477 ±  5%     +29.7%       5809 ± 17%  perf-sched.total_wait_time.max.ms
      7.34           +58.2%      11.61 ± 13%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      4478 ±  6%     +49.6%       6697 ± 20%  perf-sched.wait_and_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      7.18           +43.6%      10.31 ± 10%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      4477 ±  5%     +29.7%       5809 ± 17%  perf-sched.wait_time.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
   1975577            -4.0%    1896474        proc-vmstat.nr_active_anon
    973349            -2.6%     947803        proc-vmstat.nr_anon_pages
     46138            +3.1%      47546        proc-vmstat.nr_kernel_stack
     90193 ± 14%    +110.0%     189399 ±  4%  proc-vmstat.nr_page_table_pages
     48563           +12.8%      54769        proc-vmstat.nr_slab_reclaimable
    140817           +16.5%     164023        proc-vmstat.nr_slab_unreclaimable
     87646           +11.2%      97438        proc-vmstat.nr_vmalloc
   1975576            -4.0%    1896478        proc-vmstat.nr_zone_active_anon
 9.051e+08            -7.1%  8.406e+08        proc-vmstat.numa_hit
 9.048e+08            -7.1%  8.403e+08        proc-vmstat.numa_local
 9.069e+08            -7.1%  8.421e+08        proc-vmstat.pgalloc_normal
 3.538e+08            -7.5%  3.273e+08        proc-vmstat.pgfault
 9.061e+08            -7.1%  8.414e+08        proc-vmstat.pgfree
     29261           -10.3%      26241        sched_debug.cfs_rq:/.avg_vruntime.avg
      0.58 ±  5%     +13.8%       0.66 ±  4%  sched_debug.cfs_rq:/.h_nr_queued.avg
      0.58 ±  5%     +13.4%       0.66 ±  4%  sched_debug.cfs_rq:/.h_nr_runnable.avg
      4034 ± 33%     +53.7%       6200 ± 13%  sched_debug.cfs_rq:/.left_deadline.avg
      4034 ± 33%     +53.7%       6200 ± 13%  sched_debug.cfs_rq:/.left_vruntime.avg
    583523 ±  4%     +13.7%     663177 ±  4%  sched_debug.cfs_rq:/.load.avg
      0.58 ±  5%     +13.7%       0.66 ±  4%  sched_debug.cfs_rq:/.nr_queued.avg
     14.14 ± 22%     +45.5%      20.57 ± 15%  sched_debug.cfs_rq:/.removed.runnable_avg.avg
     67.99 ± 17%     +33.5%      90.77 ± 13%  sched_debug.cfs_rq:/.removed.runnable_avg.stddev
     13.66 ± 23%     +43.0%      19.54 ± 14%  sched_debug.cfs_rq:/.removed.util_avg.avg
     66.93 ± 17%     +31.0%      87.71 ± 14%  sched_debug.cfs_rq:/.removed.util_avg.stddev
      4034 ± 33%     +53.7%       6200 ± 13%  sched_debug.cfs_rq:/.right_vruntime.avg
    554.59 ±  2%      +8.7%     602.90 ±  3%  sched_debug.cfs_rq:/.runnable_avg.avg
      1553 ±  7%     +26.1%       1959 ± 17%  sched_debug.cfs_rq:/.runnable_avg.max
    266.15 ±  7%     +25.4%     333.85 ±  6%  sched_debug.cfs_rq:/.runnable_avg.stddev
      0.03 ± 76%    +526.1%       0.19 ± 31%  sched_debug.cfs_rq:/.spread.avg
      2.81 ± 88%    +377.6%      13.40 ± 48%  sched_debug.cfs_rq:/.spread.max
      0.24 ± 77%    +426.2%       1.26 ± 34%  sched_debug.cfs_rq:/.spread.stddev
-6.962e+10          -329.4%  1.597e+11 ± 20%  sched_debug.cfs_rq:/.sum_w_vruntime.avg
 1.654e+12 ±112%    +407.7%  8.398e+12 ± 18%  sched_debug.cfs_rq:/.sum_w_vruntime.max
    106852 ± 31%     +74.1%     185984 ± 11%  sched_debug.cfs_rq:/.sum_weight.avg
     29261           -10.3%      26241        sched_debug.cfs_rq:/.zero_vruntime.avg
    516.36 ±  3%     +85.2%     956.40 ±  3%  sched_debug.cpu.clock_task.stddev
    551602            -7.0%     513143        sched_debug.cpu.curr->pid.max
      0.59 ±  4%     +12.6%       0.67 ±  4%  sched_debug.cpu.nr_running.avg
     74120 ± 14%     -29.8%      52067 ± 25%  sched_debug.cpu.nr_switches.max
      4844 ± 18%     -36.8%       3062 ± 31%  sched_debug.cpu.nr_switches.stddev
      0.08 ± 47%     +83.8%       0.15 ± 20%  sched_debug.cpu.nr_uninterruptible.avg




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


