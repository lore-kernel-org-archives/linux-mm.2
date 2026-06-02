Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C801CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 14:52:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86AED6B0005; Tue,  2 Jun 2026 10:52:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81B626B0088; Tue,  2 Jun 2026 10:52:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BBE86B008C; Tue,  2 Jun 2026 10:52:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DFD36B0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:52:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D6791401B5
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 14:52:01 +0000 (UTC)
X-FDA: 84835262442.18.9F3FDE7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf06.hostedemail.com (Postfix) with ESMTP id 85AA7180007
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 14:51:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GUAiMKlQ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780411918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BMtQ63xBCDtk+8C7erATPpvdSQ1C3poFQf7OYEKixp4=;
	b=rv3QwdZpH+XlA9hsiim3ijQFSe6iAiJeCRahz+JvN1kJgg0UpLa+x9UToJI3xXlprYu2Cu
	EyuL2Dg3vdD45NSFvcPl3JYi0ZGMWwVHke9OFerd5/pVzrEZM7ILZhtqOvfVD9/ergSvDv
	CxhB0ftIEBuJgDplcsCoCbiwv0ly8uE=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GUAiMKlQ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1780411918;
	b=wfjCYjLsds8D7hKJ+QJFqM6E0oECGpoSkdaYfB4s/EvTcdAK2nGN2ZkDEQBWSfXY4deWbn
	pzvask2Ciij5VddUzok00K1fEQF0LdwR3olKbpfLRg001QFYwVs6ti59ToGmqI6H4PibtR
	Kut9iXJCDL2g1plADVGqsf3yniZ7S0I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780411918; x=1811947918;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=kfOh8ct3vgGLqlZF2gvcwLbP/f/WIcDplu95bsayTys=;
  b=GUAiMKlQVnx3OuJuafLxcI8ybCGJXgClhVfeCNg494qGuUaZr9+79kuW
   6y5c0ALG/9oEsqQZdgeUBWWhBe0Frfa1ON9RMvGlMXGYTWBdwjW0LeZDb
   680JW54pxu7fPb/3sue/daguXmO46s4la+w20qwMGQR70YGyNeW3KdfOB
   46LWcms70gUTiJMKMTK3NxRL1BJO41i32mE3n6C+OfY6nx/XsZrazvP6A
   g012FBVGMBd/TD4CyNcKJ/UDXer+3Qnn9fOjf+eohZRiHwgETgagDE87J
   41v2p8/NgyefV1LwU+viBZ+9pwSxz4u8fHu8/9dC0xEGaGpQclMI0NQE9
   w==;
X-CSE-ConnectionGUID: uJpz0jZaS3aJ/apt2umbnw==
X-CSE-MsgGUID: 8d0OWaUXQxa1fxLakbpIww==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="80934808"
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="80934808"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 07:51:50 -0700
X-CSE-ConnectionGUID: JoVk8Sp9R0CXtgM6Gz0P4A==
X-CSE-MsgGUID: osJeNyUjRa6uhLqeditM9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="240928527"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 07:51:47 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 07:51:46 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 2 Jun 2026 07:51:46 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.51) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 07:51:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lnf/rPDHi4JSA7E82OKACB36yA2sxBQqeLD5t5xOXXD1m7kTSKRDIrtBSocifo9UCfKqBHl+0GAkND0T4NTB4MGwqM05W5oALxyHF+UiAbkx4H0MCG9MCJJ/UMQSkhjdh3b9g7hx985pjdyk8rNDvcuyhmu18bM/0zKKrvvJiGGdZywF6lnbwSexwbv1j0wSyOwv6wrUuacaTeIwS8sJmEzSKWfBuKMPyZBCtH9MfM4Yo7mhvc+iUJdQRe2ZtIn+K+KKd0ksNx1cGtz2NHWNpjJsEHzpqPKn18xyu6/Wn6MxEIwNeE8Kq08OpSE8xS6Xxa1IQ8b8tjNDie5N9mv8dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CsHLs9yF73JyRwl9pkVuqxgdjsj7XjPXv7lZro76tqI=;
 b=QbZQ3D/qOuSGkiefeXR3seR9HtpilJaYLa6kAvmeukFDodq7ZwdhsXQOcq9zVWlrRbds4zL0yuODD/zeZenOzgbGM5sUJV2lED5oz37o7o4KxR6HfE29H7CcKveQ5WOM/aoO+R8P288t+yb9bCvKYdy+2FgwAM5NEsaIv+X5CF+2rGB2t/AuczwetmkaQUq1M30+lTC2Ac/lQT4DsfWJWfILcVPHuKxzeq6jFBr/d1Bt7vmgr1rSPMaOf+nHS3t/iS+jCY7GGF5oSg/3TQLbdzits4WtFl5C/anoU9Pgq0EnvDtXAr26VQamXdVTX4KJiP4tWHsAn4UqS/KiZlE9cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by SA1PR11MB7697.namprd11.prod.outlook.com (2603:10b6:806:33a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Tue, 2 Jun 2026
 14:51:41 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0092.006; Tue, 2 Jun 2026
 14:51:41 +0000
Date: Tue, 2 Jun 2026 22:51:28 +0800
From: kernel test robot <oliver.sang@intel.com>
To: JP Kobryn <jp.kobryn@linux.dev>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, Axel
 Rasmussen <axelrasmussen@google.com>, Baoquan He <bhe@redhat.com>, Barry Song
	<baohua@kernel.org>, Chris Li <chrisl@kernel.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi
	<shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Rik van Riel
	<riel@surriel.com>, Wei Xu <weixugc@google.com>, Yuanchu Xie
	<yuanchu@google.com>, <linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [mm/lruvec]  9669b87065:
 will-it-scale.per_process_ops 37.6% improvement
Message-ID: <202606022259.84d08a1c-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: KL1PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:820:d::9) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|SA1PR11MB7697:EE_
X-MS-Office365-Filtering-Correlation-Id: a348a6bc-4bd7-4cc8-cc56-08dec0b67422
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|3023799007|6133799003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info: irsMCMt3mAjHCjTDcSwO4HWek4vuKXXu+8WWM44x1xDX7OZaV9oDUSOEswTX/QIiw+UamJQQUzwNqxnCNb+jjhbG8pNTBXa5+XrgcJUTbV5U7Sm1gQ03n3wkQWi1K8vt68niak0XU34rQv0+WdhwKhBED68QG4LBb0gBTxQxrP77mySOrQT3Q+e3/OmpakUuLKnrclPDFRm6uNcKcpHE/V4nwrJ4vaCJx/5+6jsV6ArLd+xAaZ9qPvJ4J/YUOOXA5OjvsRVX7LJAFYB6FzCEzs6kcOjJ8XS4Dd12okT6IC+w6ZpYJOrp2Trq3+tg8I2E/ujUHXkri0yKkHtOkNkUOAQxVss7CJ6HTKZzxT/lbhq2Oax+GGn3tm70a12+7IS+zXcz5q++ZMNkb/h7XxDNidzR74adWZNenmZAAL0BbA1uaFSb+fneaoFU0MflMj/ywg/vgZwj0tWmEUnv44kL37wRUd6pF5SGUtYw3dNoYEaYyYhXXfFCOtkyKtgVMLR40tZEeBv7xK13htOIv9E7sLM5MDNDZi3k4RqLK9D9NO0YhS0f1fbsuY5j9vnKR3xLw4jzK332s7l3iV52pD2jCbea4RQlVzetqiRnhej4aVBmgw01WB9FFLnsEtnxhL2UvJpRMiGyJbSR4CctJeiibbhFtXLY3/gLdiqEAa8Dt5e/V7Fx2gJsyub6FPP1/rpJPru8XPwL+yJyfBNK+lueXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(3023799007)(6133799003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ZGqRtLH4OFvZZGu4zt2GBvlV+5AbXfXRzSgnBm80KSq6uQOXOOwsh6ZXbs?=
 =?iso-8859-1?Q?BshPA+966OVlYOjdGDTTSUR09v0qkZNpK2R8O7CTvvfRs21ukDs8/snJq1?=
 =?iso-8859-1?Q?kYjQY/8a5iDuNR1pGB6st7A9PSPzVdbvVzfNisv5NQnbWFQtnnWe5qrA6J?=
 =?iso-8859-1?Q?zqmFnr6eS5u23Ud7exaeltfVb20SN6gYi9LCY7REZy5w4uu1HrEKs5k0uL?=
 =?iso-8859-1?Q?CclnR6wtKuYrmH4LL4hBIUD71asUG3xUoXQtaHYH792r7ubrpFBlKirdCB?=
 =?iso-8859-1?Q?OAI8owsbdWDr8I4w0Dem0PY2scVmUcQNrsFAXxMVdifxcLaYl6iRvf6Rzt?=
 =?iso-8859-1?Q?zYP2rTPE+9z6/U5KJ2Nwd0Zkq5GOjFP+twxoZNDEKLzmU7lsZoJU5X68t/?=
 =?iso-8859-1?Q?6bveq0zTQcDuym1MhckFmD0CqqLyVzgLX+AnKG3DvxRnK84rMC3GKXPeKA?=
 =?iso-8859-1?Q?xU06zK8cjNw0cMdJYVVP0gbm30EPzt/biSVrAxSHQdbhhGClH0KJzRBAUb?=
 =?iso-8859-1?Q?82gkRU/Y56AV11xudy/Xi9ueGgdArDLZCH53Cuxs5ncejGDJgc4d1JAxbn?=
 =?iso-8859-1?Q?AvjBcc3i1Gpf2rzBpe+uvf9H1Vu6HvtT9dXpDCvmqh67tRCerIf+ZYRcsH?=
 =?iso-8859-1?Q?XZlv9wx7AGA2jZjPh0BZTiSByyKAMBR1aGxQBrwJqCwQUWUYWvAnij9VDB?=
 =?iso-8859-1?Q?T5DHIql8pN+GIB2AGuvot/QGavCNLgEoLiS374qzEZLgjKC7SuVCb8XeOn?=
 =?iso-8859-1?Q?iPgzPDGvwaUEcdw4Fx20tKzW+TwfC8dZxMOknJD4H1VYclmNvJnodYGudH?=
 =?iso-8859-1?Q?9qnRzs0Sjo39Y4W93X87XmvbUi0gr/kNjBJJe4aLM5A7QrQ/NE5Mpoxg6t?=
 =?iso-8859-1?Q?+MqN520QKrw9LNb/XsYNG3l2FKu9Jtv+NcGNIARSjMJsJgmYI6x1R+PmKw?=
 =?iso-8859-1?Q?yntGWxhYR/thnOetE4hc0AwoafdjJg3ftDvp5f/84CJ34m3g9z67zmg7MA?=
 =?iso-8859-1?Q?zbJqOQ62H1uOkn0NEpvvHUGVf9lJTGLma9dpDZJAJb2tExGC+wsONyIpdl?=
 =?iso-8859-1?Q?1MkIgpek73IoLNqAijxgR/8IaAZdyvd4ItptQdh7UUbVXV06yDFWdL3C0n?=
 =?iso-8859-1?Q?GYuQ8c5bJI+lzB7KPPB6T3JY9MQK8z+VexwWY47R6NdxzK17UQe6QqUjN0?=
 =?iso-8859-1?Q?KK5s1yYk+xUH8azRqk7foUh7EF1HJFsLIubs1ohILcwbcOS0eYcInCCn2u?=
 =?iso-8859-1?Q?Ttn4tAL3QrnpmroDErit/bO3chpm7sGjJOh9J2QeU9dltRam5CL7c0LS4J?=
 =?iso-8859-1?Q?ytlKhGJeJyliZx6l/wgXdadEFN1ZEIdpljn2mUOGaFhUD4r+iKribe/eR7?=
 =?iso-8859-1?Q?sNRAT+y8NjQV67A3bYlxqwM4Ko2rE226fk+dJ0vWvGID+GZvSxrPZmttHq?=
 =?iso-8859-1?Q?NFNGUGrN4CwA+rDKuDaHAZniiu62IpzDBSX7+anDF33ofFDbSzfbhZAx3T?=
 =?iso-8859-1?Q?TEdpp6+6WOGjLJfEVnEYo2m3oMdHsyAbaRUjsJPfYAaoDaSKD8Qrh/6WYN?=
 =?iso-8859-1?Q?xN1jMEZmVb7xG3IRO5imZt9n6pAoEimvLh6OZgZSxIHLQGptqog3oDZRqv?=
 =?iso-8859-1?Q?wAKl0264NEjn19oVucWbIaU3QdV+z2K6K3BZoi2sYvTKIRuGoxuaueZdnh?=
 =?iso-8859-1?Q?7voaN9CFqJDLVoVc+wTInf9arVMU0xHtnrH0ziIDvQ10gJUk9SUE8Taszq?=
 =?iso-8859-1?Q?LPhX+d2jbLfR1uRvVkU2p3OiCqHLp8d/M9TFYIu+ifNm2E/0oF6cjXsypB?=
 =?iso-8859-1?Q?jyURNeZtqQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: iisP8kqZ7luUEx2EIrM3wZwY21HftNFsPR7qgyVu6v+udWu7vtXFuSatN87fdsThPPpaUTUs6oYZzRsJ8MPuguQWoc78qC+Ae/vPO5iEiORrSTkuG7lmm6MB7a/79HPZGNSkKWvlJdyCrgo1xJhtEDrUxb1ezElQlWajY6kvPpctbZ0T0780b1xBTmeZP0bCGnxO33uB9yWmKDPLfozS8j/xL6CA6t7DSOtBOKP69F9FdBQqLabC22ziNffuQXk3R6wES+BVmPjxIdspudSJle7DZQnjwx97Z+bU3iMm3/8YuXdVKyIsZfG7VULuHOQntJa5c8ru1F/qngyjOmzBxA==
X-MS-Exchange-CrossTenant-Network-Message-Id: a348a6bc-4bd7-4cc8-cc56-08dec0b67422
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 14:51:40.9168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7s7rEuvL7dw0v/m+uhzxNbC0ZhYlj6yl6ucqCe+gKaU61XWkM8IlDAIoQ0htgg3mbI2lBXJSx/gOHKrOmv9iKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7697
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 85AA7180007
X-Stat-Signature: 4u8dxd6ra5yma51rr71453m9bf685y73
X-HE-Tag: 1780411917-655687
X-HE-Meta: U2FsdGVkX1846lbHBdGC8fsoTHNah3ShlXnssld56Am6/5kciU4geFxZ6qXLG0NTMkLch2tfEBI6VPrszhGS7fIJ3tXN5bkE1i2i34fzYL2R8xOoJOQTZQmuyBdvsNTqgy7nKFzYHOZPEDs5Isgy3XcfNy3mnyMqRcw+BjXI3SgnSYgMsS4tRKl/pNlVudsM13SUrfmV5+qx0WdBXX8U1GvWpD2OoO93luoeZGOmlXGslw5nAqkaF3C2SY68bzv5jT2kdVkaZNZk5TH8Tcg3qI4xHne2vxxKVNaEc/pnWLHzj9SUv/OSmw9GDQ4X/KuuhH0z+sX7vxXPPT77LCR0vIywhGrmmYPzmVMQCNk/loJMZx49MnJXcj6w1Mz6lWccsdl0Nkk5gDnw4UYC39lACpZXni8KnO7S0luxbH0amHgakVsVsW1mINxD0BPovQTlPq0EXNsENx2T/ZnIBjbcP5011Z1UT50dbjXHtQ0cExHqzK1jk/o9g6YlNHToMPEAPBdjFKzBstNYSLfC0yqUKPih9uJsylNu9tCWYCyZ0Y7hJbA0sNolntv4htdVK9kfZlwBgz27rkOcSnFYNgpy2CV4Ps2jwU4ZODTIPFXc0lyG7PSdbKj78bj3EUa5ulvMSuT5Z6zJ1EiZ57Ky5eWMi8rP9ZZRaOGeEH1YxamQitLxUjp1sB+xXp0vvdoL6Yi/qM93KMn1X/Ze/BgGwNiros/XEbRwL2VRRXd3H2dAtp0zis2YI9/cOqoreqrUuZ67MmmFXNLQiUEL7VLQfNDF2dgEOXLe+mZ9jK+FGtnm6EZbI9iGncue2D/DK9vlLnKrVveiE/xABoWelg/C+B7WHjU0+sEdrAWlGQJki7alaK5xJmCS0Sk/jJMY5Wstq3xzaLJeLGw70iDEf8QUTkar/4pa24I8fT/3O7aWriZ4VjXb/Nbo+ctdfD8gsPRnjYdKpL3o0aTzFapUT8izKrt
 QfwOiqYQ
 wG2yESPiGQNIhkhMl36aUgZ0bEMyANPordET3dR8oCTTFelNv5ZNQqUBmRYWiflMC3OkXCk7zv1Ttiujy0DhI7xacab6Z8/iFd9f0pZ7CQl45f9r16X9e6s+nm2I/PMhpQ6ksUwvEzp6vfz8DrZwgcyNju+cTj+5uZg9gn8Km8ufkMngytj4eHXjR7iFc/7K7BAo/5GPqTRLEp9Jr+7eSocn9x66l1l7KgHhQ/v+igVs9kHpCGA4o3LzuhsMAfweNcv9GsjisPsc+PSuxmWDL5kJoWASdAtCJeY+QEdWce+uoq757nDFg5BTjiyn50Eerw/i8V2B/YDnXkS8zaYGf4mhECq+MWweDCOZ2GIpKmBtpznB+b5UAN5s3y+h2Zqxfkn8+QKtUGq9Q/2//GdB0PRGLzC0DXjG7Muatlb+k3J/ZctZKZ2b9hogee/3g8oUgo+rdrLb58Ml+RRKQbB89+3RXv1LWYZmOGBQ6kta3nJP4320xEhuTrkZyESVNxrOLu7dRdCRQKsyQplatdVI2zpl7oMl1ZQ7sWD0LXvHtB2liGhjVO7mACzEvb2wYDlnsO2CbvdRokXuYVS1u60sS/SbHoY2+8t1anBLVRPYhrAY5kxgL5iCPv6giKh870PRC29HgIL+D9a6C3vw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 37.6% improvement of will-it-scale.per_process_ops on:


commit: 9669b87065a6fe96198f3df2c3d125c5f5c1f210 ("mm/lruvec: preemptively free dead folios during lru_add drain")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master


testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory
parameters:

	nr_task: 100%
	mode: process
	test: malloc1
	cpufreq_governor: performance



Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260602/202606022259.84d08a1c-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp2/malloc1/will-it-scale

commit: 
  94e0bcde05 ("mm, page_alloc: reintroduce page allocation stall warning")
  9669b87065 ("mm/lruvec: preemptively free dead folios during lru_add drain")

94e0bcde055ee1bd 9669b87065a6fe96198f3df2c3d 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  16361135           +37.6%   22510227        will-it-scale.192.processes
     85213           +37.6%     117240        will-it-scale.per_process_ops
  16361135           +37.6%   22510227        will-it-scale.workload
     55049 ±  5%     -30.2%      38424 ± 17%  perf-c2c.HITM.local
     55334 ±  5%     -29.8%      38870 ± 17%  perf-c2c.HITM.total
   6630054           +11.4%    7384766 ±  4%  vmstat.memory.cache
     17561 ± 33%    +161.3%      45885        vmstat.system.cs
    262138            +9.1%     286107        vmstat.system.in
      0.18 ±  2%      +0.1        0.30 ±  4%  mpstat.cpu.all.irq%
     12.61 ± 17%      -9.5        3.13 ±  6%  mpstat.cpu.all.soft%
     83.85 ±  2%      +8.1       91.94        mpstat.cpu.all.sys%
      2.52 ±  2%      +1.2        3.73        mpstat.cpu.all.usr%
 7.432e+09           +37.2%   1.02e+10        numa-numastat.node0.local_node
 7.436e+09           +37.2%  1.021e+10        numa-numastat.node0.numa_hit
 7.378e+09 ±  2%     +37.7%  1.016e+10        numa-numastat.node1.local_node
 7.378e+09 ±  2%     +37.7%  1.016e+10        numa-numastat.node1.numa_hit
   1590910 ± 14%     -39.9%     955980 ±  2%  numa-meminfo.node0.PageTables
    598239 ±  3%     -28.1%     430277 ± 10%  numa-meminfo.node0.SUnreclaim
    671869 ±  4%     -22.3%     522302 ±  7%  numa-meminfo.node0.Slab
   2810313 ±  4%     +31.9%    3707192 ± 11%  numa-meminfo.node1.Active
   2810296 ±  4%     +31.9%    3707176 ± 11%  numa-meminfo.node1.Active(anon)
   1596852 ± 12%     -39.4%     967777 ±  2%  numa-meminfo.node1.PageTables
    454884 ± 13%     -25.5%     338832 ± 12%  numa-meminfo.node1.SUnreclaim
   2281438 ±  4%     +33.6%    3048845 ± 10%  numa-meminfo.node1.Shmem
      1.10 ± 32%     -70.5%       0.32 ±  2%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      1.10 ± 32%     -70.5%       0.32 ±  2%  perf-sched.total_sch_delay.average.ms
     33.46 ± 50%     -65.9%      11.40        perf-sched.total_wait_and_delay.average.ms
    117184 ± 51%    +105.8%     241195        perf-sched.total_wait_and_delay.count.ms
     32.36 ± 51%     -65.8%      11.07        perf-sched.total_wait_time.average.ms
     33.46 ± 50%     -65.9%      11.40        perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    117184 ± 51%    +105.8%     241195        perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
     32.36 ± 51%     -65.8%      11.07        perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     17756 ± 34%    +159.2%      46020        perf-stat.i.context-switches
      0.06 ± 41%    +189.8%       0.16 ± 36%  perf-stat.i.major-faults
  16265563           +37.5%   22371826        perf-stat.i.minor-faults
  16265563           +37.5%   22371825        perf-stat.i.page-faults
     17516 ± 34%    +162.2%      45928        perf-stat.ps.context-switches
      0.05 ± 42%    +190.2%       0.16 ± 33%  perf-stat.ps.major-faults
  16209375           +37.7%   22312874        perf-stat.ps.minor-faults
  16209375           +37.7%   22312874        perf-stat.ps.page-faults
   3307690 ±  3%     +23.4%    4082802 ±  7%  meminfo.Active
   3307654 ±  3%     +23.4%    4082765 ±  7%  meminfo.Active(anon)
   6480285           +11.6%    7234182 ±  4%  meminfo.Cached
    792861 ±  4%      +7.2%     849602 ±  2%  meminfo.Mapped
  19484530 ±  5%     -10.6%   17423704 ±  2%  meminfo.Memused
   3166411 ± 12%     -39.3%    1921109 ±  2%  meminfo.PageTables
   1051429 ±  7%     -26.8%     769228        meminfo.SUnreclaim
   2411295 ±  4%     +31.3%    3165196 ±  9%  meminfo.Shmem
   1198815 ±  6%     -23.4%     918397        meminfo.Slab
  23935722 ±  7%     -22.8%   18469941 ±  3%  meminfo.max_used_kB
    395563 ± 12%     -39.3%     239984 ±  2%  numa-vmstat.node0.nr_page_table_pages
    149391 ±  3%     -28.0%     107572 ± 10%  numa-vmstat.node0.nr_slab_unreclaimable
 7.436e+09           +37.2%  1.021e+10        numa-vmstat.node0.numa_hit
 7.432e+09           +37.2%   1.02e+10        numa-vmstat.node0.numa_local
    702597 ±  4%     +31.8%     926255 ± 11%  numa-vmstat.node1.nr_active_anon
  28011714 ±  2%      +5.6%   29591579        numa-vmstat.node1.nr_free_pages_blocks
    398367 ± 11%     -39.7%     240340 ±  2%  numa-vmstat.node1.nr_page_table_pages
    570370 ±  4%     +33.5%     761672 ± 10%  numa-vmstat.node1.nr_shmem
    113548 ± 13%     -25.4%      84719 ± 12%  numa-vmstat.node1.nr_slab_unreclaimable
    702596 ±  4%     +31.8%     926254 ± 11%  numa-vmstat.node1.nr_zone_active_anon
 7.378e+09 ±  2%     +37.7%  1.016e+10        numa-vmstat.node1.numa_hit
 7.378e+09 ±  2%     +37.7%  1.016e+10        numa-vmstat.node1.numa_local
    826814 ±  3%     +23.4%    1020634 ±  7%  proc-vmstat.nr_active_anon
    224982            +2.4%     230307        proc-vmstat.nr_anon_pages
   1619960           +11.6%    1808498 ±  4%  proc-vmstat.nr_file_pages
  57469659            +4.6%   60103415        proc-vmstat.nr_free_pages_blocks
    198145 ±  4%      +7.3%     212584 ±  2%  proc-vmstat.nr_mapped
    801530 ± 13%     -40.0%     481009 ±  2%  proc-vmstat.nr_page_table_pages
    602711 ±  4%     +31.3%     791250 ±  9%  proc-vmstat.nr_shmem
    263512 ±  7%     -27.0%     192259        proc-vmstat.nr_slab_unreclaimable
    826814 ±  3%     +23.4%    1020634 ±  7%  proc-vmstat.nr_zone_active_anon
 1.481e+10           +37.5%  2.037e+10        proc-vmstat.numa_hit
 1.481e+10           +37.5%  2.036e+10        proc-vmstat.numa_local
 1.484e+10           +37.0%  2.034e+10        proc-vmstat.pgalloc_normal
 4.927e+09           +37.6%  6.779e+09        proc-vmstat.pgfault
 1.484e+10           +37.0%  2.034e+10        proc-vmstat.pgfree
  24822146            +6.2%   26366396        sched_debug.cfs_rq:/.avg_vruntime.avg
  25109365            +5.9%   26588877        sched_debug.cfs_rq:/.avg_vruntime.max
  18770620 ±  4%     -19.4%   15131757 ±  8%  sched_debug.cfs_rq:/.avg_vruntime.min
    519698 ± 13%     +69.7%     881770 ±  8%  sched_debug.cfs_rq:/.avg_vruntime.stddev
      0.90            +6.6%       0.96        sched_debug.cfs_rq:/.h_nr_queued.avg
      0.26 ±  3%     +31.2%       0.34 ±  3%  sched_debug.cfs_rq:/.h_nr_queued.stddev
      0.26 ±  3%     +22.7%       0.32 ±  2%  sched_debug.cfs_rq:/.h_nr_runnable.stddev
   1225408 ± 13%    +172.9%    3343531 ±  6%  sched_debug.cfs_rq:/.left_deadline.avg
  23598315 ± 10%     +12.5%   26558196        sched_debug.cfs_rq:/.left_deadline.max
   4808932 ±  9%     +81.2%    8712196 ±  2%  sched_debug.cfs_rq:/.left_deadline.stddev
   1225395 ± 13%    +172.9%    3343505 ±  6%  sched_debug.cfs_rq:/.left_vruntime.avg
  23598069 ± 10%     +12.5%   26558031        sched_debug.cfs_rq:/.left_vruntime.max
   4808884 ±  9%     +81.2%    8712128 ±  2%  sched_debug.cfs_rq:/.left_vruntime.stddev
     52101 ± 11%    +120.8%     115028 ±  4%  sched_debug.cfs_rq:/.load.avg
    184604 ±  8%     +58.1%     291945 ±  3%  sched_debug.cfs_rq:/.load.stddev
      7.81 ± 57%    +426.7%      41.11 ±  6%  sched_debug.cfs_rq:/.load_avg.min
      0.89            +6.6%       0.95        sched_debug.cfs_rq:/.nr_queued.avg
      0.21 ±  7%     +48.0%       0.31 ±  3%  sched_debug.cfs_rq:/.nr_queued.stddev
   1225395 ± 13%    +172.9%    3343505 ±  6%  sched_debug.cfs_rq:/.right_vruntime.avg
  23598073 ± 10%     +12.5%   26558031        sched_debug.cfs_rq:/.right_vruntime.max
   4808885 ±  9%     +81.2%    8712129 ±  2%  sched_debug.cfs_rq:/.right_vruntime.stddev
    856.64            +4.3%     893.86        sched_debug.cfs_rq:/.runnable_avg.min
-4.259e+11          +207.5%  -1.31e+12        sched_debug.cfs_rq:/.sum_w_vruntime.min
      5392 ± 53%    +470.6%      30772 ± 15%  sched_debug.cfs_rq:/.sum_weight.avg
    616377 ± 27%     +56.6%     965187 ±  9%  sched_debug.cfs_rq:/.sum_weight.max
     54115 ± 38%    +197.7%     161127 ±  9%  sched_debug.cfs_rq:/.sum_weight.stddev
    716.86 ±  5%     -22.2%     557.72 ±  5%  sched_debug.cfs_rq:/.util_avg.min
     46.71 ±  9%     +24.4%      58.09 ±  5%  sched_debug.cfs_rq:/.util_avg.stddev
    201.49 ±  5%     +13.2%     228.09 ±  2%  sched_debug.cfs_rq:/.util_est.stddev
  24822134            +6.2%   26366372        sched_debug.cfs_rq:/.zero_vruntime.avg
  25109354            +5.9%   26588826        sched_debug.cfs_rq:/.zero_vruntime.max
  18770598 ±  4%     -19.4%   15131748 ±  8%  sched_debug.cfs_rq:/.zero_vruntime.min
    519699 ± 13%     +69.7%     881769 ±  8%  sched_debug.cfs_rq:/.zero_vruntime.stddev
      2005 ± 37%     -76.3%     476.09 ±  2%  sched_debug.cpu.clock_task.stddev
    703.64 ± 90%     -88.5%      80.64 ± 41%  sched_debug.cpu.curr->pid.min
      1634 ±  5%     +37.6%       2248 ±  2%  sched_debug.cpu.curr->pid.stddev
      0.00 ±  4%     -14.9%       0.00 ±  8%  sched_debug.cpu.next_balance.stddev
      0.90            +6.7%       0.96        sched_debug.cpu.nr_running.avg
      0.27 ±  3%     +32.3%       0.36 ±  3%  sched_debug.cpu.nr_running.stddev
     17419 ± 36%    +116.9%      37774        sched_debug.cpu.nr_switches.avg
     13354 ± 49%    +109.1%      27923 ±  8%  sched_debug.cpu.nr_switches.min
      0.00 ± 33%    +100.0%       0.00        sched_debug.rt_rq:.rt_nr_running.avg
      0.25 ± 33%    +100.0%       0.50        sched_debug.rt_rq:.rt_nr_running.max
      0.02 ± 33%    +100.0%       0.04        sched_debug.rt_rq:.rt_nr_running.stddev
     23.01 ±  3%     -22.0        0.96        perf-profile.calltrace.cycles-pp.folio_batch_move_lru.__folio_batch_add_and_move.map_anon_folio_pte_nopf.do_anonymous_page.__handle_mm_fault
     23.08 ±  3%     -22.0        1.06        perf-profile.calltrace.cycles-pp.__folio_batch_add_and_move.map_anon_folio_pte_nopf.do_anonymous_page.__handle_mm_fault.handle_mm_fault
     23.68 ±  3%     -21.9        1.82        perf-profile.calltrace.cycles-pp.map_anon_folio_pte_nopf.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
     20.06 ±  2%     -20.1        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs
     37.97 ±  2%     -12.7       25.31        perf-profile.calltrace.cycles-pp.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
     38.44 ±  2%     -12.5       25.95        perf-profile.calltrace.cycles-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     38.78 ±  2%     -12.4       26.42        perf-profile.calltrace.cycles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     39.75 ±  2%     -12.1       27.62        perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault
     39.62 ±  2%     -12.1       27.51        perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     39.95 ±  2%     -12.0       27.90        perf-profile.calltrace.cycles-pp.asm_exc_page_fault
     11.87 ±  3%     -11.9        0.00        perf-profile.calltrace.cycles-pp.folios_put_refs.folio_batch_move_lru.__folio_batch_add_and_move.map_anon_folio_pte_nopf.do_anonymous_page
     11.20 ±  2%     -10.6        0.61        perf-profile.calltrace.cycles-pp.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu.unmap_region
     11.24 ±  2%     -10.6        0.67        perf-profile.calltrace.cycles-pp.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu.unmap_region.vms_complete_munmap_vmas
     11.25 ±  2%     -10.6        0.69        perf-profile.calltrace.cycles-pp.__tlb_batch_free_encoded_pages.tlb_finish_mmu.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
     10.31 ±  2%     -10.3        0.00        perf-profile.calltrace.cycles-pp.__page_cache_release.folios_put_refs.folio_batch_move_lru.__folio_batch_add_and_move.map_anon_folio_pte_nopf
     10.12 ±  2%     -10.1        0.00        perf-profile.calltrace.cycles-pp.__page_cache_release.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu
     10.08 ±  2%     -10.1        0.00        perf-profile.calltrace.cycles-pp.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages
     10.06 ±  2%     -10.1        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs.free_pages_and_swap_cache
     10.06 ±  2%     -10.1        0.00        perf-profile.calltrace.cycles-pp.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs.folio_batch_move_lru.__folio_batch_add_and_move
     10.05 ±  2%     -10.1        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs.folio_batch_move_lru
      9.84 ±  2%      -9.8        0.00        perf-profile.calltrace.cycles-pp.folio_lruvec_lock_irqsave.folio_batch_move_lru.__folio_batch_add_and_move.map_anon_folio_pte_nopf.do_anonymous_page
      9.83 ±  2%      -9.8        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.folio_batch_move_lru.__folio_batch_add_and_move.map_anon_folio_pte_nopf
      9.80 ±  2%      -9.8        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.folio_batch_move_lru.__folio_batch_add_and_move
     26.11            -5.5       20.63        perf-profile.calltrace.cycles-pp.tlb_finish_mmu.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
     35.44            -1.3       34.14        perf-profile.calltrace.cycles-pp.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
     36.26            -1.0       35.23        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      0.90            +0.1        1.05        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      1.06            +0.2        1.24        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.__get_unmapped_area.do_mmap.vm_mmap_pgoff.do_syscall_64
      0.54            +0.2        0.72        perf-profile.calltrace.cycles-pp.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      0.56            +0.2        0.77        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.__anon_vma_prepare.__vmf_anon_prepare.do_anonymous_page.__handle_mm_fault
      1.18            +0.2        1.40        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.80            +0.2        1.03        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.__get_unmapped_area.do_mmap
      1.46 ± 10%      +0.3        1.71 ±  5%  perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma.__mmap_region
      1.64 ±  9%      +0.3        1.92 ±  5%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
      0.86            +0.3        1.14        perf-profile.calltrace.cycles-pp.find_mergeable_anon_vma.__anon_vma_prepare.__vmf_anon_prepare.do_anonymous_page.__handle_mm_fault
      1.50 ±  8%      +0.3        1.82 ±  5%  perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.81            +0.3        1.14        perf-profile.calltrace.cycles-pp.unlink_anon_vmas.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      1.73 ±  7%      +0.4        2.10 ±  5%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.96            +0.4        1.34        perf-profile.calltrace.cycles-pp.clear_highpages_kasan_tagged.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof
      0.67 ±  4%      +0.4        1.07 ±  2%  perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region.do_mmap
      1.16            +0.4        1.56        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      1.94 ±  8%      +0.4        2.34 ±  4%  perf-profile.calltrace.cycles-pp.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      1.38 ±  4%      +0.4        1.82        perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio
      0.90 ±  3%      +0.5        1.36        perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_complete.__mmap_region.do_mmap.vm_mmap_pgoff
      1.44 ±  4%      +0.5        1.90        perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page
      0.94 ±  3%      +0.5        1.41        perf-profile.calltrace.cycles-pp.__mmap_complete.__mmap_region.do_mmap.vm_mmap_pgoff.do_syscall_64
      1.48 ±  4%      +0.5        1.96        perf-profile.calltrace.cycles-pp.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page.__handle_mm_fault
      1.52 ±  4%      +0.5        2.01        perf-profile.calltrace.cycles-pp.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      0.00            +0.5        0.53        perf-profile.calltrace.cycles-pp.__memcg_slab_post_alloc_hook.kmem_cache_alloc_noprof.__anon_vma_prepare.__vmf_anon_prepare.do_anonymous_page
      0.26 ±100%      +0.5        0.80 ± 11%  perf-profile.calltrace.cycles-pp.try_charge_memcg.__memcg_kmem_charge_page.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof
      0.00            +0.6        0.55 ±  2%  perf-profile.calltrace.cycles-pp.lock_vma_under_rcu.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.00            +0.6        0.55        perf-profile.calltrace.cycles-pp.mas_update_gap.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.00            +0.6        0.57        perf-profile.calltrace.cycles-pp.mas_update_gap.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      0.00            +0.6        0.60 ±  2%  perf-profile.calltrace.cycles-pp.__free_frozen_pages.tlb_remove_table_rcu.rcu_do_batch.rcu_core.handle_softirqs
      1.74            +0.7        2.40        perf-profile.calltrace.cycles-pp.__anon_vma_prepare.__vmf_anon_prepare.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      0.00            +0.7        0.69 ±  6%  perf-profile.calltrace.cycles-pp.__mem_cgroup_charge.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      1.97            +0.7        2.70        perf-profile.calltrace.cycles-pp.__vmf_anon_prepare.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.00            +0.7        0.74 ±  2%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      2.00 ±  3%      +0.7        2.74        perf-profile.calltrace.cycles-pp.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.00            +0.8        0.75        perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.00            +0.8        0.76 ±  2%  perf-profile.calltrace.cycles-pp.perf_iterate_sb.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region
      1.63 ± 10%      +0.8        2.46        perf-profile.calltrace.cycles-pp.tlb_remove_table.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables
      1.18 ± 13%      +0.9        2.05        perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.get_free_pages_noprof
      1.28 ± 12%      +0.9        2.21        perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.get_free_pages_noprof.tlb_remove_table
      1.34 ± 12%      +1.0        2.29        perf-profile.calltrace.cycles-pp.alloc_pages_mpol.alloc_pages_noprof.get_free_pages_noprof.tlb_remove_table.free_pud_range
      1.39 ± 12%      +1.0        2.34        perf-profile.calltrace.cycles-pp.alloc_pages_noprof.get_free_pages_noprof.tlb_remove_table.free_pud_range.free_p4d_range
      1.39 ± 12%      +1.0        2.34        perf-profile.calltrace.cycles-pp.get_free_pages_noprof.tlb_remove_table.free_pud_range.free_p4d_range.free_pgd_range
      3.49            +1.2        4.67        perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.__zap_vma_range.unmap_vmas.unmap_region
      1.36 ±  6%      +1.2        2.60        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      1.38 ±  6%      +1.3        2.65        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.21 ±141%      +1.4        1.61 ±  3%  perf-profile.calltrace.cycles-pp.___free_pages.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      1.78 ±  2%      +1.5        3.23        perf-profile.calltrace.cycles-pp.__memcg_kmem_charge_page.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.pte_alloc_one
      1.60 ± 13%      +1.6        3.16        perf-profile.calltrace.cycles-pp.__rmqueue_pcplist.rmqueue.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol
      4.71            +1.6        6.32        perf-profile.calltrace.cycles-pp.zap_pmd_range.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas
      4.92            +1.7        6.58        perf-profile.calltrace.cycles-pp.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      1.96 ± 13%      +1.7        3.65        perf-profile.calltrace.cycles-pp.rmqueue.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof
      5.02            +1.7        6.70        perf-profile.calltrace.cycles-pp.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.44 ±141%      +1.8        2.28        perf-profile.calltrace.cycles-pp.rcu_cblist_dequeue.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      0.61 ± 85%      +1.8        2.46 ±  2%  perf-profile.calltrace.cycles-pp.tlb_remove_table_rcu.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      2.32 ±  5%      +2.0        4.29        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
      3.06 ±  5%      +2.0        5.07        perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.unmap_region
     42.21 ±  2%      +2.0       44.23        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
      3.16 ±  5%      +2.0        5.19        perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas
      2.37 ±  5%      +2.0        4.40        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      3.24 ±  5%      +2.1        5.29        perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
     42.40 ±  2%      +2.1       44.49        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.58 ±  5%      +2.1        4.70        perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
     42.68 ±  2%      +2.2       44.86        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     42.67 ±  2%      +2.2       44.86        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     42.78 ±  2%      +2.2       45.00        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     42.83 ±  2%      +2.2       45.06        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
      4.14 ±  4%      +2.4        6.56        perf-profile.calltrace.cycles-pp.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
     43.52 ±  2%      +2.5       46.02        perf-profile.calltrace.cycles-pp.__munmap
      4.51 ±  5%      +2.5        7.03        perf-profile.calltrace.cycles-pp.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      5.16 ±  5%      +2.7        7.90        perf-profile.calltrace.cycles-pp.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff.do_syscall_64
      8.35 ±  4%      +3.7       12.07        perf-profile.calltrace.cycles-pp.__mmap_region.do_mmap.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      9.72 ±  3%      +4.0       13.73        perf-profile.calltrace.cycles-pp.do_mmap.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     10.01 ±  3%      +4.1       14.11        perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     10.18 ±  3%      +4.1       14.28        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     10.23 ±  3%      +4.1       14.34        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__mmap
     11.13 ±  3%      +4.3       15.44        perf-profile.calltrace.cycles-pp.__mmap
      3.72 ± 65%      +4.5        8.26        perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
      3.73 ± 65%      +4.6        8.28        perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
      3.74 ± 65%      +4.6        8.30        perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
      3.74 ± 65%      +4.6        8.30        perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      3.76 ± 65%      +4.6        8.32        perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
      3.76 ± 65%      +4.6        8.32        perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
      3.76 ± 65%      +4.6        8.32        perf-profile.calltrace.cycles-pp.ret_from_fork_asm
      3.75 ± 65%      +4.6        8.32        perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     14.50            +5.0       19.47        perf-profile.calltrace.cycles-pp.flush_tlb_mm_range.tlb_finish_mmu.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
     13.49            +5.0       18.47        perf-profile.calltrace.cycles-pp.native_flush_tlb_one_user.flush_tlb_func.flush_tlb_mm_range.tlb_finish_mmu.unmap_region
     13.73            +5.1       18.81        perf-profile.calltrace.cycles-pp.flush_tlb_func.flush_tlb_mm_range.tlb_finish_mmu.unmap_region.vms_complete_munmap_vmas
      6.50 ±  2%      +5.1       11.60        perf-profile.calltrace.cycles-pp.clear_highpages_kasan_tagged.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof
      7.68 ±  4%      +6.0       13.64        perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.pte_alloc_one
      9.60 ±  3%      +7.5       17.06        perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.pte_alloc_one.__pte_alloc
      9.66 ±  3%      +7.5       17.16        perf-profile.calltrace.cycles-pp.alloc_pages_mpol.alloc_pages_noprof.pte_alloc_one.__pte_alloc.do_anonymous_page
      9.71 ±  3%      +7.5       17.22        perf-profile.calltrace.cycles-pp.alloc_pages_noprof.pte_alloc_one.__pte_alloc.do_anonymous_page.__handle_mm_fault
      9.96 ±  3%      +7.6       17.56        perf-profile.calltrace.cycles-pp.pte_alloc_one.__pte_alloc.do_anonymous_page.__handle_mm_fault.handle_mm_fault
     10.13 ±  3%      +7.7       17.79        perf-profile.calltrace.cycles-pp.__pte_alloc.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
     33.52 ±  2%     -30.8        2.68 ±  4%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     33.08 ±  3%     -30.8        2.32 ±  5%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     29.99 ±  2%     -29.9        0.12 ±  3%  perf-profile.children.cycles-pp.folio_lruvec_lock_irqsave
     23.07 ±  2%     -22.4        0.65        perf-profile.children.cycles-pp.folios_put_refs
     23.03 ±  3%     -22.1        0.97        perf-profile.children.cycles-pp.folio_batch_move_lru
     23.10 ±  3%     -22.0        1.06        perf-profile.children.cycles-pp.__folio_batch_add_and_move
     23.68 ±  3%     -21.9        1.82        perf-profile.children.cycles-pp.map_anon_folio_pte_nopf
     20.43 ±  2%     -20.3        0.12        perf-profile.children.cycles-pp.__page_cache_release
     37.98 ±  2%     -12.7       25.32        perf-profile.children.cycles-pp.do_anonymous_page
     38.46 ±  2%     -12.5       25.98        perf-profile.children.cycles-pp.__handle_mm_fault
     38.79 ±  2%     -12.4       26.42        perf-profile.children.cycles-pp.handle_mm_fault
     39.75 ±  2%     -12.1       27.62        perf-profile.children.cycles-pp.exc_page_fault
     39.63 ±  2%     -12.1       27.52        perf-profile.children.cycles-pp.do_user_addr_fault
     40.33 ±  2%     -12.1       28.28        perf-profile.children.cycles-pp.asm_exc_page_fault
     11.24 ±  2%     -10.6        0.67        perf-profile.children.cycles-pp.free_pages_and_swap_cache
     11.25 ±  2%     -10.6        0.69        perf-profile.children.cycles-pp.__tlb_batch_free_encoded_pages
     26.12            -5.5       20.65        perf-profile.children.cycles-pp.tlb_finish_mmu
      4.42 ± 51%      -3.4        1.06        perf-profile.children.cycles-pp.__irq_exit_rcu
      2.55 ± 47%      -2.5        0.08 ±  8%  perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
      2.79 ± 20%      -2.0        0.79 ±  6%  perf-profile.children.cycles-pp.__kmem_cache_free_bulk
      3.19 ± 19%      -2.0        1.24 ±  4%  perf-profile.children.cycles-pp.rcu_free_sheaf
     35.44            -1.3       34.14        perf-profile.children.cycles-pp.unmap_region
      2.22 ±  9%      -1.2        1.05 ±  2%  perf-profile.children.cycles-pp.__slab_free
      1.39 ± 38%      -0.9        0.53 ± 11%  perf-profile.children.cycles-pp.free_frozen_page_commit
      0.81 ± 82%      -0.7        0.06 ±115%  perf-profile.children.cycles-pp.free_pcppages_bulk
      1.78 ± 30%      -0.7        1.08 ±  5%  perf-profile.children.cycles-pp.__free_frozen_pages
      0.37            -0.3        0.08        perf-profile.children.cycles-pp.lru_add
      0.25            -0.2        0.07        perf-profile.children.cycles-pp.lru_gen_add_folio
      0.19 ± 36%      -0.1        0.10 ± 11%  perf-profile.children.cycles-pp.free_one_page
      0.09            -0.0        0.07 ±  7%  perf-profile.children.cycles-pp.vm_get_page_prot
      0.07 ± 10%      -0.0        0.05        perf-profile.children.cycles-pp.handle_internal_command
      0.07 ± 10%      -0.0        0.05        perf-profile.children.cycles-pp.main
      0.08 ±  4%      -0.0        0.06 ±  6%  perf-profile.children.cycles-pp.__vm_enough_memory
      0.05            +0.0        0.06        perf-profile.children.cycles-pp.security_mmap_file
      0.07            +0.0        0.09 ±  5%  perf-profile.children.cycles-pp.can_vma_merge_right
      0.06 ±  9%      +0.0        0.07 ±  5%  perf-profile.children.cycles-pp.__pte_offset_map
      0.06            +0.0        0.08 ±  4%  perf-profile.children.cycles-pp.mas_next_range
      0.06            +0.0        0.08        perf-profile.children.cycles-pp.mas_prev_setup
      0.08 ± 11%      +0.0        0.10 ±  5%  perf-profile.children.cycles-pp.security_mmap_addr
      0.06 ± 17%      +0.0        0.08 ± 13%  perf-profile.children.cycles-pp.__get_obj_cgroup_from_memcg
      0.07 ±  5%      +0.0        0.09        perf-profile.children.cycles-pp.folio_add_lru
      0.07 ±  6%      +0.0        0.10        perf-profile.children.cycles-pp.down_read_trylock
      0.08 ±  5%      +0.0        0.11 ± 10%  perf-profile.children.cycles-pp.vma_set_page_prot
      0.07            +0.0        0.10 ±  3%  perf-profile.children.cycles-pp._find_next_bit
      0.11 ±  4%      +0.0        0.14 ±  3%  perf-profile.children.cycles-pp.tlb_gather_mmu
      0.10            +0.0        0.13 ±  3%  perf-profile.children.cycles-pp.mas_wr_walk_descend
      0.15 ±  2%      +0.0        0.18 ±  2%  perf-profile.children.cycles-pp.may_expand_vm
      0.06 ±  8%      +0.0        0.09 ±  9%  perf-profile.children.cycles-pp.malloc
      0.15 ±  4%      +0.0        0.18 ±  2%  perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.08 ±  5%      +0.0        0.12        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.02 ± 99%      +0.0        0.06 ±  6%  perf-profile.children.cycles-pp.perf_exclude_event
      0.09            +0.0        0.13 ±  3%  perf-profile.children.cycles-pp.policy_nodemask
      0.07            +0.0        0.11 ±  4%  perf-profile.children.cycles-pp.sched_tick
      0.22 ±  6%      +0.0        0.26        perf-profile.children.cycles-pp.free_unref_folios
      0.09            +0.0        0.13 ±  2%  perf-profile.children.cycles-pp.__irqentry_text_end
      0.05 ±  8%      +0.0        0.09 ±  4%  perf-profile.children.cycles-pp.perf_event_mmap_output
      0.09 ±  4%      +0.0        0.13 ± 10%  perf-profile.children.cycles-pp.__account_obj_stock
      0.12            +0.0        0.16        perf-profile.children.cycles-pp.mas_prev
      0.08 ±  8%      +0.0        0.12 ± 10%  perf-profile.children.cycles-pp.memcg_state_val_in_pages
      0.08            +0.0        0.12 ±  3%  perf-profile.children.cycles-pp.rcu_segcblist_enqueue
      0.19            +0.0        0.23 ±  2%  perf-profile.children.cycles-pp.__vma_start_exclude_readers
      0.13 ±  3%      +0.0        0.18        perf-profile.children.cycles-pp.cfree
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.sized_strscpy
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.trylock_stock
      0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.testcase
      0.40 ±  3%      +0.1        0.45 ±  3%  perf-profile.children.cycles-pp.zap_present_ptes
      0.24            +0.1        0.30        perf-profile.children.cycles-pp.error_entry
      0.11 ±  4%      +0.1        0.16 ±  4%  perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.00            +0.1        0.06 ±  6%  perf-profile.children.cycles-pp.get_jiffies_update
      0.11            +0.1        0.17 ±  4%  perf-profile.children.cycles-pp.drain_stock
      0.14 ±  2%      +0.1        0.20        perf-profile.children.cycles-pp.pmd_install
      0.14 ±  3%      +0.1        0.20 ±  2%  perf-profile.children.cycles-pp.down_write_killable
      0.00            +0.1        0.06        perf-profile.children.cycles-pp.folio_add_lru_vma
      0.20 ±  6%      +0.1        0.26 ±  4%  perf-profile.children.cycles-pp.folio_remove_rmap_ptes
      0.00            +0.1        0.06 ±  6%  perf-profile.children.cycles-pp.tmigr_requires_handle_remote
      0.14            +0.1        0.20 ±  2%  perf-profile.children.cycles-pp.refill_stock
      0.11 ±  3%      +0.1        0.18 ±  2%  perf-profile.children.cycles-pp.downgrade_write
      0.27 ±  3%      +0.1        0.33        perf-profile.children.cycles-pp.mas_rev_awalk
      0.00            +0.1        0.07 ±  5%  perf-profile.children.cycles-pp.handle_pte_fault
      0.30 ±  3%      +0.1        0.36 ±  4%  perf-profile.children.cycles-pp.mas_wr_store_type
      0.00            +0.1        0.07        perf-profile.children.cycles-pp.task_tick_fair
      0.28            +0.1        0.36        perf-profile.children.cycles-pp.__vma_start_write
      0.00            +0.1        0.08 ±  4%  perf-profile.children.cycles-pp.ktime_get_update_offsets_now
      0.28 ±  5%      +0.1        0.36        perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
      0.26 ±  2%      +0.1        0.34        perf-profile.children.cycles-pp.vma_merge_new_range
      0.18 ± 12%      +0.1        0.26 ±  6%  perf-profile.children.cycles-pp.get_mem_cgroup_from_mm
      0.19 ±  2%      +0.1        0.27        perf-profile.children.cycles-pp.__memcg_kmem_uncharge_page
      0.43 ±  3%      +0.1        0.52 ±  5%  perf-profile.children.cycles-pp.__mod_memcg_lruvec_state
      0.27            +0.1        0.37        perf-profile.children.cycles-pp.sync_regs
      0.20 ±  2%      +0.1        0.30 ±  4%  perf-profile.children.cycles-pp.__put_anon_vma
      0.27            +0.1        0.37        perf-profile.children.cycles-pp.mas_next_slot
      0.26            +0.1        0.36        perf-profile.children.cycles-pp.up_read
      0.12 ±  4%      +0.1        0.22 ±  2%  perf-profile.children.cycles-pp.update_process_times
      0.26 ±  3%      +0.1        0.36 ±  3%  perf-profile.children.cycles-pp.__call_rcu_common
      0.25 ±  3%      +0.1        0.35 ±  3%  perf-profile.children.cycles-pp.__folio_mod_stat
      0.24 ±  2%      +0.1        0.35        perf-profile.children.cycles-pp.up_write
      0.20 ±  5%      +0.1        0.30 ±  6%  perf-profile.children.cycles-pp.down_write
      0.38            +0.1        0.48        perf-profile.children.cycles-pp.mas_empty_area_rev
      0.14 ±  3%      +0.1        0.25        perf-profile.children.cycles-pp.tick_nohz_handler
      0.35 ±  2%      +0.1        0.47        perf-profile.children.cycles-pp.anon_vma_compatible
      0.15 ±  4%      +0.1        0.27 ±  2%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.36 ±  2%      +0.1        0.48 ±  2%  perf-profile.children.cycles-pp.folio_add_new_anon_rmap
      0.44            +0.1        0.57        perf-profile.children.cycles-pp.mas_prev_slot
      0.91            +0.1        1.05        perf-profile.children.cycles-pp.vm_unmapped_area
      0.34 ±  2%      +0.1        0.48 ±  7%  perf-profile.children.cycles-pp.___perf_sw_event
      0.41            +0.1        0.56 ±  2%  perf-profile.children.cycles-pp.lock_vma_under_rcu
      0.40            +0.2        0.54        perf-profile.children.cycles-pp.pte_offset_map_lock
      0.40            +0.2        0.56        perf-profile.children.cycles-pp._raw_spin_lock
      0.20 ±  6%      +0.2        0.36 ±  7%  perf-profile.children.cycles-pp.page_counter_try_charge
      0.25 ±  3%      +0.2        0.41 ±  6%  perf-profile.children.cycles-pp.charge_memcg
      0.41            +0.2        0.57 ±  2%  perf-profile.children.cycles-pp._raw_spin_trylock
      0.30 ± 11%      +0.2        0.46 ± 11%  perf-profile.children.cycles-pp.__mod_memcg_state
      0.39            +0.2        0.55 ±  6%  perf-profile.children.cycles-pp.__perf_sw_event
      0.21 ±  8%      +0.2        0.38 ± 14%  perf-profile.children.cycles-pp.ordered_events__queue
      0.21 ±  8%      +0.2        0.38 ± 14%  perf-profile.children.cycles-pp.queue_event
      0.22 ±  9%      +0.2        0.38 ± 13%  perf-profile.children.cycles-pp.process_simple
      1.07            +0.2        1.25        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      0.19            +0.2        0.37        perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.18 ±  2%      +0.2        0.36        perf-profile.children.cycles-pp.hrtimer_interrupt
      0.49            +0.2        0.67        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.54            +0.2        0.72        perf-profile.children.cycles-pp.vm_area_alloc
      0.58            +0.2        0.77 ±  2%  perf-profile.children.cycles-pp.__mem_cgroup_uncharge_folios
      0.52 ±  2%      +0.2        0.72        perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.50 ±  2%      +0.2        0.70 ±  2%  perf-profile.children.cycles-pp.uncharge_batch
      0.59            +0.2        0.80        perf-profile.children.cycles-pp.entry_SYSCALL_64
      0.32 ±  6%      +0.2        0.54 ±  4%  perf-profile.children.cycles-pp.cmd_record
      1.19            +0.2        1.41        perf-profile.children.cycles-pp.__get_unmapped_area
      0.61            +0.2        0.84        perf-profile.children.cycles-pp.native_irq_return_iret
      0.74            +0.2        0.98        perf-profile.children.cycles-pp.mas_find
      0.67            +0.2        0.90        perf-profile.children.cycles-pp.mas_walk
      0.80            +0.2        1.04        perf-profile.children.cycles-pp.unmapped_area_topdown
      0.67            +0.2        0.91        perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      0.25 ±  7%      +0.2        0.49 ±  5%  perf-profile.children.cycles-pp.perf_session__process_events
      0.25 ±  7%      +0.2        0.50 ±  4%  perf-profile.children.cycles-pp.record__finish_output
      0.44 ±  7%      +0.2        0.69 ±  6%  perf-profile.children.cycles-pp.__mem_cgroup_charge
      0.20 ±  4%      +0.3        0.46        perf-profile.children.cycles-pp.barn_put_full_sheaf
      0.61            +0.3        0.87 ±  2%  perf-profile.children.cycles-pp.page_counter_uncharge
      0.76 ±  2%      +0.3        1.05 ±  5%  perf-profile.children.cycles-pp.lruvec_stat_mod_folio
      0.86            +0.3        1.16        perf-profile.children.cycles-pp.find_mergeable_anon_vma
      0.82            +0.3        1.11        perf-profile.children.cycles-pp.kmem_cache_free
      0.45 ±  5%      +0.3        0.76 ±  2%  perf-profile.children.cycles-pp.perf_iterate_sb
      0.82            +0.3        1.14        perf-profile.children.cycles-pp.unlink_anon_vmas
      0.20 ±  6%      +0.3        0.52        perf-profile.children.cycles-pp.barn_replace_empty_sheaf
      0.19 ±  9%      +0.3        0.54        perf-profile.children.cycles-pp.barn_get_empty_sheaf
      0.73 ±  3%      +0.4        1.11        perf-profile.children.cycles-pp.perf_event_mmap_event
      1.18            +0.4        1.57        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      1.95 ±  8%      +0.4        2.35 ±  4%  perf-profile.children.cycles-pp.mas_preallocate
      0.45 ±  6%      +0.4        0.87        perf-profile.children.cycles-pp.__kfree_rcu_sheaf
      0.68 ±  5%      +0.4        1.13 ±  8%  perf-profile.children.cycles-pp.try_charge_memcg
      0.91 ±  3%      +0.5        1.37        perf-profile.children.cycles-pp.perf_event_mmap
      0.95 ±  3%      +0.5        1.42        perf-profile.children.cycles-pp.__mmap_complete
      1.52 ±  4%      +0.5        2.02        perf-profile.children.cycles-pp.vma_alloc_folio_noprof
      3.00 ±  7%      +0.5        3.54        perf-profile.children.cycles-pp.__pcs_replace_empty_main
      0.50 ± 10%      +0.6        1.13        perf-profile.children.cycles-pp.mas_update_gap
      1.75            +0.7        2.41        perf-profile.children.cycles-pp.__anon_vma_prepare
      0.81 ±  5%      +0.7        1.49        perf-profile.children.cycles-pp.kvfree_call_rcu
      1.97            +0.7        2.70        perf-profile.children.cycles-pp.__vmf_anon_prepare
      2.00 ±  3%      +0.8        2.75        perf-profile.children.cycles-pp.alloc_anon_folio
      1.64 ± 10%      +0.8        2.46        perf-profile.children.cycles-pp.tlb_remove_table
      0.90 ±  8%      +0.9        1.85 ±  3%  perf-profile.children.cycles-pp.___free_pages
      1.40 ± 11%      +0.9        2.35        perf-profile.children.cycles-pp.get_free_pages_noprof
      1.85 ± 11%      +1.0        2.80 ±  2%  perf-profile.children.cycles-pp.tlb_remove_table_rcu
      4.30 ±  5%      +1.0        5.29        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
      1.49            +1.0        2.48        perf-profile.children.cycles-pp.rcu_cblist_dequeue
      8.12 ±  7%      +1.1        9.27        perf-profile.children.cycles-pp.rcu_do_batch
      8.14 ±  7%      +1.2        9.30        perf-profile.children.cycles-pp.rcu_core
      8.15 ±  7%      +1.2        9.34        perf-profile.children.cycles-pp.handle_softirqs
      3.50            +1.2        4.69        perf-profile.children.cycles-pp.zap_pte_range
      1.79 ±  2%      +1.4        3.24        perf-profile.children.cycles-pp.__memcg_kmem_charge_page
      1.70 ± 12%      +1.6        3.28        perf-profile.children.cycles-pp.__rmqueue_pcplist
      4.72            +1.6        6.33        perf-profile.children.cycles-pp.zap_pmd_range
      4.93            +1.7        6.58        perf-profile.children.cycles-pp.__zap_vma_range
      5.02            +1.7        6.71        perf-profile.children.cycles-pp.unmap_vmas
      2.21 ± 12%      +1.8        3.96        perf-profile.children.cycles-pp.rmqueue
      3.07 ±  5%      +2.0        5.08        perf-profile.children.cycles-pp.free_pud_range
      3.17 ±  5%      +2.0        5.19        perf-profile.children.cycles-pp.free_p4d_range
     42.22 ±  2%      +2.0       44.24        perf-profile.children.cycles-pp.do_vmi_align_munmap
      3.24 ±  5%      +2.0        5.29        perf-profile.children.cycles-pp.free_pgd_range
     42.40 ±  2%      +2.1       44.50        perf-profile.children.cycles-pp.do_vmi_munmap
      2.58 ±  5%      +2.1        4.70        perf-profile.children.cycles-pp.mas_store_prealloc
     42.68 ±  2%      +2.2       44.86        perf-profile.children.cycles-pp.__x64_sys_munmap
     42.67 ±  2%      +2.2       44.86        perf-profile.children.cycles-pp.__vm_munmap
      4.17 ±  4%      +2.4        6.59        perf-profile.children.cycles-pp.free_pgtables
      2.75 ±  6%      +2.5        5.27        perf-profile.children.cycles-pp.__pi_memcpy
     43.70 ±  2%      +2.6       46.26        perf-profile.children.cycles-pp.__munmap
      4.79 ±  5%      +2.6        7.38        perf-profile.children.cycles-pp.mas_store_gfp
      5.16 ±  5%      +2.7        7.91        perf-profile.children.cycles-pp.__mmap_new_vma
      8.38 ±  4%      +3.8       12.13        perf-profile.children.cycles-pp.__mmap_region
      9.73 ±  3%      +4.0       13.74        perf-profile.children.cycles-pp.do_mmap
      4.75 ±  5%      +4.1        8.83        perf-profile.children.cycles-pp.mas_wr_node_store
     10.02 ±  3%      +4.1       14.12        perf-profile.children.cycles-pp.vm_mmap_pgoff
     11.27 ±  3%      +4.4       15.63        perf-profile.children.cycles-pp.__mmap
      3.74 ± 65%      +4.6        8.30        perf-profile.children.cycles-pp.run_ksoftirqd
      3.76 ± 65%      +4.6        8.32        perf-profile.children.cycles-pp.kthread
      3.76 ± 65%      +4.6        8.32        perf-profile.children.cycles-pp.ret_from_fork
      3.76 ± 65%      +4.6        8.32        perf-profile.children.cycles-pp.ret_from_fork_asm
      3.75 ± 65%      +4.6        8.32        perf-profile.children.cycles-pp.smpboot_thread_fn
     14.52            +5.0       19.48        perf-profile.children.cycles-pp.flush_tlb_mm_range
     13.50            +5.0       18.48        perf-profile.children.cycles-pp.native_flush_tlb_one_user
     13.74            +5.1       18.82        perf-profile.children.cycles-pp.flush_tlb_func
      7.46 ±  2%      +5.5       12.96        perf-profile.children.cycles-pp.clear_highpages_kasan_tagged
     53.05 ±  2%      +6.3       59.36        perf-profile.children.cycles-pp.do_syscall_64
     53.13 ±  2%      +6.3       59.47        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     10.26 ±  5%      +7.3       17.54        perf-profile.children.cycles-pp.get_page_from_freelist
      9.96 ±  3%      +7.6       17.56        perf-profile.children.cycles-pp.pte_alloc_one
     10.13 ±  3%      +7.7       17.79        perf-profile.children.cycles-pp.__pte_alloc
     11.10 ±  4%      +8.5       19.56        perf-profile.children.cycles-pp.alloc_pages_noprof
     12.33 ±  4%      +8.9       21.19        perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
     12.48 ±  4%      +8.9       21.42        perf-profile.children.cycles-pp.alloc_pages_mpol
     33.08 ±  3%     -30.8        2.32 ±  5%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.23 ±  7%      -0.1        0.11 ±  5%  perf-profile.self.cycles-pp.tlb_remove_table
      0.29            -0.1        0.17        perf-profile.self.cycles-pp.folios_put_refs
      0.18 ±  2%      -0.1        0.07        perf-profile.self.cycles-pp.lru_gen_add_folio
      0.45 ±  8%      -0.1        0.36        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.47 ±  7%      -0.1        0.40        perf-profile.self.cycles-pp.__slab_free
      0.08            -0.0        0.06 ±  9%  perf-profile.self.cycles-pp.vm_get_page_prot
      0.10            -0.0        0.08 ±  4%  perf-profile.self.cycles-pp.exc_page_fault
      0.25            -0.0        0.23        perf-profile.self.cycles-pp.asm_exc_page_fault
      0.06            -0.0        0.05        perf-profile.self.cycles-pp.__kmem_cache_free_bulk
      0.15            +0.0        0.16        perf-profile.self.cycles-pp.zap_present_ptes
      0.10 ±  3%      +0.0        0.11        perf-profile.self.cycles-pp.free_p4d_range
      0.05 ±  8%      +0.0        0.07        perf-profile.self.cycles-pp.vms_complete_munmap_vmas
      0.05 ±  7%      +0.0        0.07        perf-profile.self.cycles-pp.mas_prev_setup
      0.09 ±  4%      +0.0        0.11 ±  4%  perf-profile.self.cycles-pp.vm_mmap_pgoff
      0.06 ± 17%      +0.0        0.08 ± 10%  perf-profile.self.cycles-pp.__get_obj_cgroup_from_memcg
      0.05            +0.0        0.07        perf-profile.self.cycles-pp.__pte_offset_map
      0.06            +0.0        0.08        perf-profile.self.cycles-pp.can_vma_merge_right
      0.07            +0.0        0.09        perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.07            +0.0        0.09        perf-profile.self.cycles-pp.mas_prev
      0.07            +0.0        0.09        perf-profile.self.cycles-pp.rcu_free_sheaf
      0.08            +0.0        0.10        perf-profile.self.cycles-pp.folio_remove_rmap_ptes
      0.07            +0.0        0.09 ±  4%  perf-profile.self.cycles-pp.pmd_install
      0.07 ±  5%      +0.0        0.09        perf-profile.self.cycles-pp.unmap_vmas
      0.14 ±  3%      +0.0        0.17 ±  2%  perf-profile.self.cycles-pp.may_expand_vm
      0.07            +0.0        0.09 ±  5%  perf-profile.self.cycles-pp.__folio_batch_add_and_move
      0.08 ±  4%      +0.0        0.10 ±  4%  perf-profile.self.cycles-pp.alloc_pages_noprof
      0.10 ±  5%      +0.0        0.12        perf-profile.self.cycles-pp.folio_batch_move_lru
      0.08            +0.0        0.10 ±  4%  perf-profile.self.cycles-pp.handle_mm_fault
      0.06 ±  6%      +0.0        0.09 ±  5%  perf-profile.self.cycles-pp.folio_add_lru
      0.06 ±  7%      +0.0        0.09        perf-profile.self.cycles-pp.free_pgd_range
      0.07            +0.0        0.10 ±  3%  perf-profile.self.cycles-pp.down_read_trylock
      0.11            +0.0        0.14 ±  2%  perf-profile.self.cycles-pp.free_unref_folios
      0.07            +0.0        0.10 ±  3%  perf-profile.self.cycles-pp.policy_nodemask
      0.07            +0.0        0.10        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.08 ±  4%      +0.0        0.11 ±  3%  perf-profile.self.cycles-pp.rcu_do_batch
      0.17            +0.0        0.20        perf-profile.self.cycles-pp.perf_event_mmap_event
      0.13 ±  2%      +0.0        0.16 ±  2%  perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.05            +0.0        0.08 ± 13%  perf-profile.self.cycles-pp.malloc
      0.09 ±  4%      +0.0        0.12 ±  3%  perf-profile.self.cycles-pp.__vma_start_write
      0.10 ±  4%      +0.0        0.14 ±  3%  perf-profile.self.cycles-pp.folio_add_new_anon_rmap
      0.10            +0.0        0.13 ±  3%  perf-profile.self.cycles-pp.tlb_gather_mmu
      0.15 ±  3%      +0.0        0.18 ±  2%  perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
      0.09            +0.0        0.12 ±  8%  perf-profile.self.cycles-pp.__account_obj_stock
      0.05 ±  7%      +0.0        0.09 ±  5%  perf-profile.self.cycles-pp._find_next_bit
      0.09 ±  4%      +0.0        0.12 ±  3%  perf-profile.self.cycles-pp.cfree
      0.09 ±  4%      +0.0        0.13 ±  2%  perf-profile.self.cycles-pp.mas_wr_walk_descend
      0.07 ±  5%      +0.0        0.11 ±  3%  perf-profile.self.cycles-pp.__mmap_new_vma
      0.12 ±  6%      +0.0        0.15 ±  4%  perf-profile.self.cycles-pp.do_syscall_64
      0.09            +0.0        0.13 ±  2%  perf-profile.self.cycles-pp.__irqentry_text_end
      0.05            +0.0        0.09 ±  4%  perf-profile.self.cycles-pp.perf_event_mmap_output
      0.19 ±  5%      +0.0        0.22 ±  4%  perf-profile.self.cycles-pp.mas_wr_store_type
      0.08            +0.0        0.12 ±  3%  perf-profile.self.cycles-pp.pte_offset_map_lock
      0.11            +0.0        0.15 ±  2%  perf-profile.self.cycles-pp.__free_frozen_pages
      0.07 ±  5%      +0.0        0.11 ±  3%  perf-profile.self.cycles-pp.alloc_pages_mpol
      0.21            +0.0        0.25        perf-profile.self.cycles-pp.error_entry
      0.11 ±  6%      +0.0        0.15 ±  3%  perf-profile.self.cycles-pp.mas_empty_area_rev
      0.08            +0.0        0.12 ±  3%  perf-profile.self.cycles-pp.rcu_segcblist_enqueue
      0.09 ±  5%      +0.0        0.13        perf-profile.self.cycles-pp.free_pgtables
      0.21 ±  2%      +0.0        0.25        perf-profile.self.cycles-pp.mas_find
      0.17            +0.0        0.22 ±  2%  perf-profile.self.cycles-pp.__vma_start_exclude_readers
      0.10 ±  4%      +0.0        0.15 ±  4%  perf-profile.self.cycles-pp.do_mmap
      0.13 ±  2%      +0.0        0.18 ±  2%  perf-profile.self.cycles-pp.do_user_addr_fault
      0.20            +0.0        0.25        perf-profile.self.cycles-pp.__zap_vma_range
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.mas_next_range
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.sized_strscpy
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.testcase
      0.00            +0.1        0.05 ±  7%  perf-profile.self.cycles-pp.free_pages_and_swap_cache
      0.01 ±223%      +0.1        0.06 ±  9%  perf-profile.self.cycles-pp.perf_exclude_event
      0.11 ±  4%      +0.1        0.16 ±  3%  perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.01 ±223%      +0.1        0.06 ±  6%  perf-profile.self.cycles-pp.cap_mmap_addr
      0.00            +0.1        0.06 ±  8%  perf-profile.self.cycles-pp.folio_add_lru_vma
      0.00            +0.1        0.06 ±  6%  perf-profile.self.cycles-pp.__get_unmapped_area
      0.00            +0.1        0.06 ±  6%  perf-profile.self.cycles-pp.barn_put_full_sheaf
      0.00            +0.1        0.06 ±  6%  perf-profile.self.cycles-pp.get_jiffies_update
      0.16            +0.1        0.22        perf-profile.self.cycles-pp.vma_merge_new_range
      0.00            +0.1        0.06        perf-profile.self.cycles-pp.unmap_region
      0.17 ±  2%      +0.1        0.23 ±  5%  perf-profile.self.cycles-pp.__call_rcu_common
      0.14            +0.1        0.20        perf-profile.self.cycles-pp.down_write_killable
      0.16 ±  3%      +0.1        0.23 ±  2%  perf-profile.self.cycles-pp.vm_area_alloc
      0.17 ±  2%      +0.1        0.23        perf-profile.self.cycles-pp.unlink_anon_vmas
      0.19 ±  2%      +0.1        0.25        perf-profile.self.cycles-pp.lock_vma_under_rcu
      0.11            +0.1        0.18 ±  2%  perf-profile.self.cycles-pp.downgrade_write
      0.22 ± 19%      +0.1        0.29        perf-profile.self.cycles-pp.rmqueue
      0.18 ±  2%      +0.1        0.25        perf-profile.self.cycles-pp.__vm_munmap
      0.26            +0.1        0.33        perf-profile.self.cycles-pp.mas_rev_awalk
      0.11 ±  3%      +0.1        0.18 ±  4%  perf-profile.self.cycles-pp.tlb_finish_mmu
      0.18 ±  2%      +0.1        0.25        perf-profile.self.cycles-pp.find_mergeable_anon_vma
      0.21            +0.1        0.29        perf-profile.self.cycles-pp.__mmap
      0.18 ±  2%      +0.1        0.26        perf-profile.self.cycles-pp.perf_event_mmap
      0.23 ±  4%      +0.1        0.31        perf-profile.self.cycles-pp.__kfree_rcu_sheaf
      0.22            +0.1        0.30        perf-profile.self.cycles-pp.__munmap
      0.19 ±  2%      +0.1        0.27        perf-profile.self.cycles-pp.mas_store_prealloc
      0.19 ±  2%      +0.1        0.28 ±  3%  perf-profile.self.cycles-pp.flush_tlb_mm_range
      0.00            +0.1        0.08 ±  4%  perf-profile.self.cycles-pp.ktime_get_update_offsets_now
      0.28 ±  5%      +0.1        0.36        perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
      0.19 ±  2%      +0.1        0.27        perf-profile.self.cycles-pp.mas_preallocate
      0.23            +0.1        0.32        perf-profile.self.cycles-pp.unmapped_area_topdown
      0.17 ± 13%      +0.1        0.26 ±  6%  perf-profile.self.cycles-pp.get_mem_cgroup_from_mm
      0.36 ±  3%      +0.1        0.45 ±  7%  perf-profile.self.cycles-pp.__mod_memcg_lruvec_state
      0.27            +0.1        0.37        perf-profile.self.cycles-pp.sync_regs
      0.06 ±  9%      +0.1        0.15 ±  3%  perf-profile.self.cycles-pp.barn_get_empty_sheaf
      0.28 ±  4%      +0.1        0.38 ±  7%  perf-profile.self.cycles-pp.lruvec_stat_mod_folio
      0.25            +0.1        0.35        perf-profile.self.cycles-pp.up_read
      0.07 ±  5%      +0.1        0.17        perf-profile.self.cycles-pp.barn_replace_empty_sheaf
      0.24            +0.1        0.34        perf-profile.self.cycles-pp.up_write
      0.25            +0.1        0.36        perf-profile.self.cycles-pp.mas_next_slot
      0.24 ±  2%      +0.1        0.35        perf-profile.self.cycles-pp.flush_tlb_func
      0.28 ±  2%      +0.1        0.40        perf-profile.self.cycles-pp.kmem_cache_free
      0.19 ±  7%      +0.1        0.30 ±  6%  perf-profile.self.cycles-pp.down_write
      0.31            +0.1        0.42        perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.34 ±  2%      +0.1        0.46        perf-profile.self.cycles-pp.anon_vma_compatible
      0.26 ±  5%      +0.1        0.39 ±  8%  perf-profile.self.cycles-pp.___perf_sw_event
      0.26            +0.1        0.39        perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.27 ±  2%      +0.1        0.41        perf-profile.self.cycles-pp.__alloc_frozen_pages_noprof
      0.42            +0.1        0.56        perf-profile.self.cycles-pp.mas_prev_slot
      0.22 ± 11%      +0.1        0.36 ± 14%  perf-profile.self.cycles-pp.__mod_memcg_state
      0.26            +0.1        0.40        perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      0.20 ±  7%      +0.2        0.35 ±  6%  perf-profile.self.cycles-pp.page_counter_try_charge
      0.40 ±  3%      +0.2        0.56        perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.45            +0.2        0.61        perf-profile.self.cycles-pp.mas_store_gfp
      0.40 ±  2%      +0.2        0.56        perf-profile.self.cycles-pp.__handle_mm_fault
      0.38            +0.2        0.54        perf-profile.self.cycles-pp._raw_spin_lock
      0.39            +0.2        0.55 ±  2%  perf-profile.self.cycles-pp._raw_spin_trylock
      0.20 ±  8%      +0.2        0.37 ± 14%  perf-profile.self.cycles-pp.queue_event
      0.49            +0.2        0.67        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.57            +0.2        0.79        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.61            +0.2        0.83        perf-profile.self.cycles-pp.native_irq_return_iret
      0.60 ±  2%      +0.2        0.83        perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      0.64            +0.2        0.88        perf-profile.self.cycles-pp.mas_walk
      0.34 ±  2%      +0.2        0.59        perf-profile.self.cycles-pp.kvfree_call_rcu
      0.60 ±  2%      +0.3        0.86 ±  2%  perf-profile.self.cycles-pp.page_counter_uncharge
      0.37 ±  4%      +0.3        0.66 ±  3%  perf-profile.self.cycles-pp.perf_iterate_sb
      0.46 ±  6%      +0.3        0.76 ± 11%  perf-profile.self.cycles-pp.try_charge_memcg
      0.73            +0.3        1.05        perf-profile.self.cycles-pp.mas_wr_node_store
      0.87            +0.3        1.21        perf-profile.self.cycles-pp.__mmap_region
      1.20            +0.4        1.63        perf-profile.self.cycles-pp.zap_pmd_range
      0.49 ±  8%      +0.6        1.11        perf-profile.self.cycles-pp.mas_update_gap
      0.83 ± 11%      +0.9        1.72 ±  3%  perf-profile.self.cycles-pp.tlb_remove_table_rcu
      0.90 ±  8%      +0.9        1.85 ±  2%  perf-profile.self.cycles-pp.___free_pages
      1.00 ±  5%      +1.0        1.99 ±  7%  perf-profile.self.cycles-pp.__memcg_kmem_charge_page
      1.48 ±  2%      +1.0        2.48        perf-profile.self.cycles-pp.rcu_cblist_dequeue
      2.63            +1.0        3.68        perf-profile.self.cycles-pp.zap_pte_range
      1.39 ±  2%      +1.2        2.58        perf-profile.self.cycles-pp.free_pud_range
      1.36 ± 16%      +1.7        3.08        perf-profile.self.cycles-pp.__rmqueue_pcplist
      2.60 ±  4%      +2.5        5.08        perf-profile.self.cycles-pp.__pi_memcpy
     13.49            +5.0       18.47        perf-profile.self.cycles-pp.native_flush_tlb_one_user
      7.26            +5.5       12.78        perf-profile.self.cycles-pp.clear_highpages_kasan_tagged




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


