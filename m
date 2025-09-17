Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE963CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 19:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0CBF8E0069; Wed, 17 Sep 2025 15:54:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE46B8E0068; Wed, 17 Sep 2025 15:54:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD2D08E0069; Wed, 17 Sep 2025 15:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD44C8E0068
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:54:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F8B08626D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:54:22 +0000 (UTC)
X-FDA: 83899793964.19.6FD5B34
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf10.hostedemail.com (Postfix) with ESMTP id 03193C000A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:54:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aQB7IFxx;
	spf=pass (imf10.hostedemail.com: domain of tony.luck@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=tony.luck@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758138859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BjbzDrXqBlJpKAXjAy0G668i+JjK85/17jDi6aKDexg=;
	b=Eakgr2MdSgowC8DtZoUZC3ptF2rgRq9GXPb+Ocarv5geToP4lhmksdJXf2SdCnaJNDWRmR
	ZFBCgrM+C7gh643Rqo+VoNeTG0skDpYiFA79uCe/j2eh7WnMvStJ9KcFUbb2H9ptg6b1G+
	Uw69WLDAuIybZJx+TSRfjLdwB/EIuUw=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aQB7IFxx;
	spf=pass (imf10.hostedemail.com: domain of tony.luck@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=tony.luck@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758138859; a=rsa-sha256;
	cv=fail;
	b=tTTYdzMbRGToMyCEe2G+mIz/PfnF1KOIx4gRffEkpmO3go68tvRG8gMZLi2fbJCStpjLOz
	e5lVp6YjLCgAqIlVFNWSPX3g4lJnJNIFeTiFKJsfmHk0aWfGG9NP/sJJbCFKxUHd6FGMaY
	WO7lNSTKCjjVHT9Ca+dq+4U/Cpt/wII=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758138858; x=1789674858;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=NeWOajKF9JEeeBlQbH4dfr33hNOjJzIj0QUxb/hu+7k=;
  b=aQB7IFxxTAZSLqsLStcMf8Kjs2x1TR1y8rxgspJIaMIctOHjUy+xKatx
   N4FLIrdoGFNAfVw0OMfIg3GoBIwEwBKEBbbFymlODd9BOJLDL+HbYDlIm
   3gh3s2XZ4Ud4ZWRXP9HzEg9zjpsZNedFt4QpLdl0BVy7+22f6bLxilEfq
   e0KSmTmmTDsLoTnSa7fOZhcTseVXyY3s+75rFrCclmLV27TTUiMzjeAwg
   ml/Csl210dejHWQCoX5qil95YzckV8WrD64oMemHT/wtAEFCsm343PyJV
   e6tqM4gFz7pde9rBGAfICMhOoy8dUlNS9vI1UaOWZkYpqZwZVcs+Ex8QF
   A==;
X-CSE-ConnectionGUID: qQ+37IkpTF+JDc52tIuEZw==
X-CSE-MsgGUID: OKYsTzSlSv+ATI5w5RRzmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="70710254"
X-IronPort-AV: E=Sophos;i="6.18,272,1751266800"; 
   d="scan'208";a="70710254"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 12:54:16 -0700
X-CSE-ConnectionGUID: quOpwUCiQUqnzm3Ykv3TYg==
X-CSE-MsgGUID: WPhl8cezSkWnmCBARoV2Mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,272,1751266800"; 
   d="scan'208";a="175746499"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 12:54:15 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 12:54:15 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 17 Sep 2025 12:54:14 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.32) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 12:54:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fGDW/HZNZhLm2PMMSE0PL2JJonHMqhzyAS2Sj5v2ATlMUnx1Omq1O7X8oopEZE69EltJougONYlWc+s03t4OB8XZ73ESYEn+FwLujvDK3JmEBRISS26/D6aQfeG4rMgnFuaK/tFCoQPTitcg72oHLJL0aPSZcEUDZ/W5kRu6qTSmX/j0VxVHcNQIHK2QHSd7zzA5DybXSO6Uaeliqp6AiLXHhdpN/F/GXEE09ZG4vPtfeyctUlUu5d5CDuCZexpLxVI5f85GH54JFYn4wRhJC9L18mpEShKQ77179zFnormVelN7Bv1C18tclSW5YxNJTr+/EBGL9lXMFl0r34pK+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BjbzDrXqBlJpKAXjAy0G668i+JjK85/17jDi6aKDexg=;
 b=x/LQ0AYZaQ5ZDC52/tG6z2j4YuLZjlR3j/yTGedNqs/k09yR+Xnsw+WAi8qZrXdKScTTq2CQDFU/962hk6GoEYT+6WhSkBunFdHpJ9qn77YH0KtBk4DoJj1cYquwA2k9CT+ua2/7LZ85pZHZSjtgRjGvl545zIzNxLSzC2xx1hBpk1vxcMqZ4K7UgPOkd0VHK9Ih9UcdCGCsB4Xly8oSGK175iD5Qxak62NfUwn4v/l84j3G/ATcMOmjuQtx3b827oc8xnlQhDRrgBLU5oU6d0f4DI18iQYjc6Hwksi+RKZA8nlprvX5P4MZz1GAJO8jyZoyDYoEWz7szTBUQxK+sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS0PR11MB7484.namprd11.prod.outlook.com (2603:10b6:8:14c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Wed, 17 Sep
 2025 19:54:11 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9137.012; Wed, 17 Sep 2025
 19:54:11 +0000
Date: Wed, 17 Sep 2025 12:54:09 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Jiaqi Yan <jiaqiyan@google.com>
CC: David Hildenbrand <david@redhat.com>, Kyle Meyer <kyle.meyer@hpe.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>, <akpm@linux-foundation.org>,
	<corbet@lwn.net>, <linmiaohe@huawei.com>, <shuah@kernel.org>,
	<jane.chu@oracle.com>, <Liam.Howlett@oracle.com>, <bp@alien8.de>,
	<hannes@cmpxchg.org>, <jack@suse.cz>, <joel.granados@kernel.org>,
	<laoar.shao@gmail.com>, <lorenzo.stoakes@oracle.com>,
	<mclapinski@google.com>, <mhocko@suse.com>, <nao.horiguchi@gmail.com>,
	<osalvador@suse.de>, <rafael.j.wysocki@intel.com>, <rppt@kernel.org>,
	<russ.anderson@hpe.com>, <shawn.fan@intel.com>, <surenb@google.com>,
	<vbabka@suse.cz>, <linux-acpi@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>
Subject: Re: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
Message-ID: <aMsR4Tr9ov1pfucC@agluck-desk3>
References: <aMiu_Uku6Y5ZbuhM@hpe.com>
 <a99eb11f-a7ac-48a3-a671-c5f0f6b5b491@arm.com>
 <8c3188da-7078-4099-973a-1d0d74db2720@redhat.com>
 <aMsDJ3EU1zVJ00cX@hpe.com>
 <cd71fac2-bb9d-4e84-a074-2b695654e655@redhat.com>
 <CACw3F52p45t3iSZPjx_Lq9kBn1ZGTDZsxk+iQ-xFA1zdvdqqrw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACw3F52p45t3iSZPjx_Lq9kBn1ZGTDZsxk+iQ-xFA1zdvdqqrw@mail.gmail.com>
X-ClientProxiedBy: SJ0PR13CA0033.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::8) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DS0PR11MB7484:EE_
X-MS-Office365-Filtering-Correlation-Id: 0990d6e1-ba22-4f4d-a84d-08ddf623f8ce
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2cIyO/yAJFXyw9JDrQ2tbRe2otXph9SSvUyjji0kB+KfpvtxRv2PkPOt+AnA?=
 =?us-ascii?Q?cI1uWpkr0zcQ8Yad+f6TdeKe28b+w9eGQia0ZUSSKBVQYRJA/xxTUskVSTCY?=
 =?us-ascii?Q?eGa6iC4WiG4M+jVsks+An2wur209ZlVfjxfI12Ne1QD2guj/NCFcCXJjn8/k?=
 =?us-ascii?Q?eAxSv4eUdn9NC/GrOUg383Nyri8rpHSg/KvcHIMVSQRMXTfc8mxyJ2Oaon98?=
 =?us-ascii?Q?byLxZWLDlNcWguMck3e+C1FdpqENH9mZnGc6vP0GkaOvr7xjp3K1zxf0Nlq1?=
 =?us-ascii?Q?BB+H4qAhvgIza5bE4Hit/oEC4STomsy9pCTxeV71v3vsbymEQCeVOekkbzbD?=
 =?us-ascii?Q?QoOwhs87cxY0PSVX/d9UVXqBdxZEAXpHO2SXd6GUF3AHvRMKCXqJczyehf0O?=
 =?us-ascii?Q?TXjSHbl4HUQBKCQ/0hg2WEsu5qahKp6fg5tUfM9hNIzWpJdAuiHULqWyXlJU?=
 =?us-ascii?Q?+s7Txay6PoFd6h0YHerpdNuqfNPHtEwzfzUcJQ2gMaUJDr45tV0HDbjQXW4L?=
 =?us-ascii?Q?h5IGRe7/Zbu/fybXSJqP3W4Hy6hd7lzVvrdSKOXFUsmvCuPczhK6WdUQbH2W?=
 =?us-ascii?Q?oR/p0iI3O/6vjP8UB/Fmj6fZ0CAa6rBK0AVbBnLowTldCJ2znOjE53Xflc1i?=
 =?us-ascii?Q?WUi7ggMCuVz5tgro9lugnMj5XiTxhzC+UiM5MGq8qiSwKrrC/ryGymuNrp08?=
 =?us-ascii?Q?GFuodkwkCZBy+qykdk8SinLLkqoWC1uw+6je/kgNiez88FNDNVQ66EpRnyNm?=
 =?us-ascii?Q?vC4sQekf4G37wwH+6tnnqNqc9IitGPcGJZp1W8XXJEglNWnlt5np140VGo1G?=
 =?us-ascii?Q?Mk5YZ/06a6c8oXE/WRbQ7iGQkT83invJhPRpBiJbp4OpGRp7PndCnwYnqMcD?=
 =?us-ascii?Q?7HajFBAf3yCTG+JVhTcL08A3/43Y3DS8f8jL7tejabWN3bAVSKDQ2+k9GbOa?=
 =?us-ascii?Q?UdqJoV1YusKYdHL7GDWn7p8XP0mvwb3U87smhkPJA4prU5CweexyGOUR2ut+?=
 =?us-ascii?Q?BuYZO/WThcpxHC56fu5sAUfBarJacYgfTOr43bakFNboQoCAl6YH+UW1wA5O?=
 =?us-ascii?Q?uPUq1otKwrSEAhjurcs6r/DmDPfMXPMhAYeWs0FnzSsWmPAHPkHWOV0D2pDv?=
 =?us-ascii?Q?pBWNMirL/fhgJhm6eyXt1E/CNtwWhI7oF7Icm+bjS+C54fJ7RiCNq4j8ubhe?=
 =?us-ascii?Q?MLxl24bGPwaL3PskOXMOyzzIK9v5zS6mu/3jmuFLUSyl2+P1oJSCIA8Oei1z?=
 =?us-ascii?Q?ewWeDccpqHi3jL8MOnQKazM2f9Mz6Jq/W/vkDAyfwzbDbBh/OXCwVqioDKTi?=
 =?us-ascii?Q?zb8AdKBmxtHe9PzbMnAm4dLfEgOC01fBWVZFX1j2/M1SzdvJh6vJd/8L4vYz?=
 =?us-ascii?Q?BNzOJ9UQcKpQxBtcgtNKPe/ixv5ydslGM17iLwTLYcxrOsfeZg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M6crN171rxd77tvxSDiYuR3YHTjhSIm5WnhapKQVnOHYs37pfoiJqQ64GNmq?=
 =?us-ascii?Q?si4vKELwHFjH3RYAnQZ2Mb3LZBSIbjRsTGMMtC9+rG1VhMQuGpZXg9Q8IgHO?=
 =?us-ascii?Q?nhAChOC/Bhr37F9FA6uHwdyqOmPzLzLuGEy6Ygc/naKVCyorprScE2ePTN/D?=
 =?us-ascii?Q?vPYtMPg6ttOas3DBLh3M0QsR4zXokRMBdgAZ3mAt4sgOot9+z4E3tIQjWE+Q?=
 =?us-ascii?Q?+qQtF8+ORVefeYYM4qmUyldTAb9a/OxNnlyVnAtS4SN0vvtTHKDoI2BoEUtY?=
 =?us-ascii?Q?xHlFDUa7TnYOP++gGavGOAqsZudRjEKEMY2315v50jQcZnBl/FR60THcNT2Y?=
 =?us-ascii?Q?cWA3nYZolPfGNPyHc5AWkWls3Thh5r6MUvxHE7TGkgj9ujcu1dYupEpQrzE6?=
 =?us-ascii?Q?8Ks6/2gJHCuPMkukur2lWDckmZUeuPDnXXzvY5jzyFlA/4Xwq67AUd6kj0b7?=
 =?us-ascii?Q?Tk9n1gHs2z2KJBZk71ID5aidbecUDtHIbFIkT9N4snEqsQrljf+d+ddw28ub?=
 =?us-ascii?Q?U7/4wUdaoFVzssVsesmjrMdEPV6vt5cezbCbi8XoX1picJlCDJWi/DzK31U8?=
 =?us-ascii?Q?ROjLoyttYnSKE5DE+sOqdAPyB6k8L32CG9DDxdn4AcxnentEFSLgsgtfhJlK?=
 =?us-ascii?Q?71SPEducoogMUBXzi8jrH3SJCc572pgLXMg35sb5YqMQBSbltL7UL2ucck4Y?=
 =?us-ascii?Q?lMwUBduNCPx8SmllkgdsBjRQxpwstAjz1PUdsQdO9riZmBEMvJsQdiBUDge7?=
 =?us-ascii?Q?090RyhnVWD5P9S/AZuOP4aDHjKISMEBpf1KGqYtPfGbyAJZ65TXm+7EBTR1Q?=
 =?us-ascii?Q?OqSONzqJh6NbtBAXm52nYkAhAcCOe/qkXt51FNrZenRxIFoId5bvQ5ZjAn3V?=
 =?us-ascii?Q?huA2jjFH3GHGenqbpUR044131ENJXvZuJLBFQkJwB7aX838+nanXhzxxJdvr?=
 =?us-ascii?Q?4T8gGgXwbyymWL+1m0GSTfVsMyBvaJJIUgtcEoO8xtm2JrMtDc6jWtJs2mNv?=
 =?us-ascii?Q?gTZSWk39pdj5ZznWa4+tHyxmKcpB0HTJWY2uHAotjQT2YRsY7tTANnpHXy9R?=
 =?us-ascii?Q?xLkyd2iaPRm4+4eKyf4h6NWrpXK92kh1PhZ0LwKRPuu+RMS5vaZyiGAwupCt?=
 =?us-ascii?Q?vJm9cSUOj3TxNDOPMTGaDbuhR0vWCl0XzUga9fJAh6beM6BWm15N/UiLK9V0?=
 =?us-ascii?Q?VNOsKbgCrubLoh60gAg+CilQipbVqk4n9BnGDBxtnh2PyDiGztwC0vMAjiOM?=
 =?us-ascii?Q?Rd3M2XoIWYAQkxR5S/1Wn6m0i1k4JTEgSitd/F+UYjX5iab0Z3sZq6ol064D?=
 =?us-ascii?Q?ma1RhUBS9azF94lhbtU21KMS4/uFnSk8Wgcq334RmWCaCDsI+go17DkjGk2b?=
 =?us-ascii?Q?dBTAS9zgX2O0vy0kev/dSc9e8O+lF0uMyzNuVt3w5TDpGSnw/HNJzApOVrhX?=
 =?us-ascii?Q?05HxyMZ8uYVOIxGNi0nNndg85wuM84tPvNnBmOaDWoga4D45xY2KjhDTZuSw?=
 =?us-ascii?Q?Hez9yHGdnFE1dKo97/RwSsn1aMfFzjywW8eEtpCzp8wBfvsddOxNxkzNnluQ?=
 =?us-ascii?Q?Fb8hJ2F//pM8yqc4x58ECAHhBTqKPSAOdfzcVNQZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0990d6e1-ba22-4f4d-a84d-08ddf623f8ce
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 19:54:11.6631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1EM7GklcIJHLD+GvMxf8sJIxrtPXvUGGFdQv+56LNXimmjwIF3MUvKOiUhDBl/4l+J7oGNfpsp4UYHurQeSemQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7484
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 03193C000A
X-Stat-Signature: nrw7h4zgff7t7nckzn3edyah7bxajejr
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758138857-960579
X-HE-Meta: U2FsdGVkX18wY48fQuyuPMuLya43NG2E/ccErWCWWT4+lIoV/uwn4+5hPJoYf14AoZMdpym1XayWHheSatU/sKpcwX9SCH7N1Fn0bJMGV4EPP4Fh7qfEzIOJFibbLkmzHWQ+qTTb+WQCvImLg4JkzN2ewIhKNj6d0Ujb6OuGgc0FDtxh+xeUywgzJo2ih5LIe5WXZSc86tCGNTXgrdKDOVFajPEyqGrbwMwk0vnm2VwMim7xGJ4K3PEkGKt0JLZ6GbQasevVvp9IroWE38JeNUFdN6Wi2Q5P7HDUQonmpUugnb2h11n0Z01oVMoPwbB57JgF/0pxo9AK8fbIdK2KYbgAyuiKkzGH99iWR9POp0QTO7EZEMQ17Ukm5H5CS3N19nyF320+9/IE+hL3Adxshn3OK2A4m0CEvA4y6eUCSmTnQ5F7aESK8p4Tr0hl+uhGm18A3JSoAejgnH+yQNgA6q0Dp9r2aLXxwuXNFDWeaV8ZWGoUDf4/XU34pnYhLf0GJF4Y+y1pnKZiztZB5Ftyjo2zxmrE2vaGQamTbmPMDHl5Vl5Q86QHTDVI6HoJ0+jYTjqOT1gblOQpVnHQcQP4S0yld8a34Ivcptl8ti+aYpJDrTQfutpXEXyzDgyDaCH97xthdfcQ50ZoDOafNOKisWouyErZ5puIifisUblb95cXKaQCCgrdt9uCfnYzMihTUAunnsCq9d5E7N1PgtCvMNwih4bIhi+s2b2lRQoEzp3WFSyOp0wmdqMAIklHvXxyfXyaZi70250DbYELSE7kqfnUJAfozcyKMLuVdmJ4nWGinUHiTUXJHmPEQLYRQeJF2dB9a/N4A5ZyLrN3AX9lC+c0gFfP0Lrkp2RPmGGVXtvFtDtdFsy1GrrXzD8NAVwpGJ/CVWd9ydC6gDb1WGQw6HbEl66isQMWnBdjAxTWUk4UEyFYDNYDLswRTN/y3NRD5H7EICcrxf70Le9awAv
 BW4ucXKg
 OYecnuAbppdIakDH/WCdSeqX8RwZXh7EgHEml3ZYe9gti4d3qUXauHJymBNW6KBSoZqbRMKPfPvP6/psklcQvk2QrG4Q3d2v7p9carljiDaITodntC8UlCMo27IcPCazkAqDZrys+dimTKD5A6phoITjRSA/XTPfH9ukHOV9VmKBLO/nP3VEvXzwa8Av5x+JuVuYpZK5Z+7bfKeTi7Q6UAL5OC3HPU3E/NCmbCN8hzobaLMD+fwdGAVOeORQY8CXgqmfm0vLRhEb6O8/4MVIQOodZ0CMIFZ263R1EDjSnXTLBwIce2suoWnZZX1vEd7zaX0AMQf+aU1+7YczuCiVX8O40KFJUDPWaCLQ5ylie61BUbhVR6KqP4qVGRSIvsc3JczA3YFFCRj7K9Q7ZYNUT47E7mCV78i455VDkOwOCHD42sp2jFo3eh+b/FkRuSYZM0hroGfPPq5yJ1kD/vV2ucAKN1BzwXvfrEh7WzxwloYMKT0aTy7WmB1iXmIR7mgIdaQzGxyzsfx3NyC0OtT1myceNKl6jFSDVRd63P33uWTsGfcN85FOO8riQYyOOg1rF/tvsB8qBTovqUt5InUtAucRxZTWOuIsp/h+lmtQrDh3sMPJGd4dzeX7Dz++XZB6q2Mq0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 12:32:47PM -0700, Jiaqi Yan wrote:
> +1. Given /proc/sys/vm/enable_soft_offline is extensible, I would
> prefer a compact userspace API.
> 
> > would create a new file, and the file has weird semantics such that it
> > has no meaning when enable_soft_offline=0.

So the expand the bitmask idea from earlier in this thread?

Bit0	0 = soft offline disabled. 1 = Enabled (but see other bits)
Bit1	0 = allow offline of 4K pages, 1 = suppress 4K offline
Bit2	0 = allow offline of hugetlb, 1 = suppress hugetlb offline
Bit3	0 = allow breakup of transparent huge pages to just offline 4K, 1 = suppress transparent breakup
Bit4+	Reserved for suppressing other page types we invent in the future

Values 0 and 1 keep their original meaning.

Value 5 means: offline 4K, keep hugetlb, breakup transparent huge pages.

-Tony

