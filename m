Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA638C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 185FA6B00AC; Mon, 13 Jul 2026 12:30:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 139006B00B2; Mon, 13 Jul 2026 12:30:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 026996B00C4; Mon, 13 Jul 2026 12:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA2406B00AC
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:30:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C64C1A0211
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:30:50 +0000 (UTC)
X-FDA: 84984292260.27.1DDC65A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf04.hostedemail.com (Postfix) with ESMTP id 59EE740002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:30:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LFTGJLmh;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf04.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783960247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=shJFAyHrud5YcV5uquL8TTVZ94XzsbEgXibQPpr2JOQ=;
	b=0noYkAkUnZAu2fMU9JngpEuZhl2unYkB3ZHCZ4aKdsY1tBwt1LA07nJtdXnTeOvcl6KkLf
	0elChjJNriU8mC2lKjsV2PFLquEk3Dpl+yZ0zhjvC7uUNvagphiAdVt+6b772YB2zTaKIU
	MjbM/+hEtAGTNSwzEdnn9yxG7vqKjj4=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LFTGJLmh;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf04.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1783960247;
	b=cdfGgqUTzmNwu249FmEXAp+OZ4UtwOarrMk5uTv+BVYI+zD/vWmiR+8YIMu/BYWIeeRGGo
	gHEVAtUyIGSJMsP1/fskMCJWiz6jFBDOQNXcbCsjOd9NQTLGHRxLWRy9PcnWqdkJxIq3D1
	3cgNFPNmMgIBzGJC+LdUq26cPl8rDCU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783960247; x=1815496247;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+iM7UMlTI5Awm5KGCZHGksDQhUXyXkHsyWUwQTroEf0=;
  b=LFTGJLmh7fQ7MIhXkWdnOH1qgip4DE3O/MXY9dH8WBcOsAveiaNA6ema
   qc7teJK2eUqHy2YQ8aTpMyX61h+02wKHGRDbo7PDKoVROHFkDuryjuz9C
   1cTCT5yTj/vVymSkYYZQCDIUgQBax4DYy4AB9Yg/N6xQY+9Lfr7SQ5YTi
   +sgtLPLYqpcRvx3fCFPc0DeYkPmNbFvZtnMWyCGVD6YaSbTJmKqcdabUy
   +2EZNg9myGjhwKXZI+gJOU0ClmxffMRDb6v5rjoJNX4Ym24zFCCoeSgUM
   2jXVd01eMtYnQkju4j3mkmATbG+cYGU7S1vEAPK7xE2YQbCeJm3aVqeNO
   A==;
X-CSE-ConnectionGUID: jIaBXdYuTDGJxwS0PEakcA==
X-CSE-MsgGUID: YGo5YqGCQMO19p8K45ricg==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84430193"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84430193"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 09:30:45 -0700
X-CSE-ConnectionGUID: Q9j7w+qrTO28zp7CylLXDw==
X-CSE-MsgGUID: MXcEJyz4T/2oo2OJ9YDiuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="280011461"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 09:30:44 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 13 Jul 2026 09:30:43 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Mon, 13 Jul 2026 09:30:43 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.11) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 13 Jul 2026 09:30:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dO+Df+r51vSGgJY4q24+uharpanMnAallz2mI3Wv9zfG5PtxO60Bt8csozdhkeaoDqyqcA2bYPTDm8kh1lPmCrAfKswqdgrMh6NbNGWsH2KKM41xkcVMUsOPpxwkQzuGgAKl0/67xL+CwJwxc2fZAEWwjZR6g0fSYx9vYjaul9ourHKj6LIDegLgIxAXT6M7nn3UnQtXpniIak5Oi0ojCxbahht9qBdhejfvYX043jxmK8IThuhX+mA9bSXTSDf7BI6pialtvhX3Tj7IkJfbsDzoF/d1dRg6x/heHBiA7dHl5vX9NobCowNEEdT2p6n1nrmNKC1Zj8lI2vVWsMjPVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=shJFAyHrud5YcV5uquL8TTVZ94XzsbEgXibQPpr2JOQ=;
 b=KiHV29us3ehwfKhFbqTR4jLDuqIRcBb1zdwKy2NrLh6jsYNcT22vlPjreBKR8HrtxSZUOUPAVYd7r7q2Kdqw/Lxjv2LCk7HQcc3Yxzh8ZBkPWKc7iQSB4OM5ynTjLzFk2Wn80ppvNmb2FzQOX8Mv/FllXmSzwzQY6KxG5A3kh5JobhiZbkVfPv7zrOYOa3EVKcIFPJZg5QaQRaTz8y7DpDu0eum3/+KXnanhEaqU8URb3CoaGpvFgneiaDQqlLm5b1sxD1xVS8tT2s9u1RTpjFGtvINDU2rLYlQLk1dEfHuwdzLE9VJpRx7lU314RbVe/09B3kvhg5QI+NG6VEZ8Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by DM6PR11MB4531.namprd11.prod.outlook.com (2603:10b6:5:2a5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Mon, 13 Jul
 2026 16:30:40 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.21.0202.014; Mon, 13 Jul 2026
 16:30:40 +0000
Date: Mon, 13 Jul 2026 09:30:35 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
CC: <airlied@gmail.com>, <akhilesh@ee.iitb.ac.in>,
	<akpm@linux-foundation.org>, <corbet@lwn.net>, <dakr@kernel.org>,
	<david@kernel.org>, <decui@microsoft.com>, <haiyangz@microsoft.com>,
	<jgg@ziepe.ca>, <kees@kernel.org>, <kys@microsoft.com>, <leon@kernel.org>,
	<liam@infradead.org>, <lizhi.hou@amd.com>, <ljs@kernel.org>,
	<longli@microsoft.com>, <lyude@redhat.com>,
	<maarten.lankhorst@linux.intel.com>, <mamin506@gmail.com>, <mhocko@suse.com>,
	<mripard@kernel.org>, <nouveau@lists.freedesktop.org>, <ogabbay@kernel.org>,
	<oleg@redhat.com>, <rppt@kernel.org>, <shuah@kernel.org>, <simona@ffwll.ch>,
	<skhan@linuxfoundation.org>, <surenb@google.com>, <tzimmermann@suse.de>,
	<vbabka@kernel.org>, <wei.liu@kernel.org>, <dri-devel@lists.freedesktop.org>,
	<linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
	<linux-hyperv@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH v8 8/8] drm/gpusvm: Use
 hmm_range_fault_unlocked_timeout() for range faults
Message-ID: <alUSq0o7CC2Pnr+H@gsse-cloud1.jf.intel.com>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
 <178371883977.900500.2198446134676328631.stgit@skinsburskii>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <178371883977.900500.2198446134676328631.stgit@skinsburskii>
X-ClientProxiedBy: MW4PR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:303:16d::10) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|DM6PR11MB4531:EE_
X-MS-Office365-Filtering-Correlation-Id: 038359bf-0ffe-445b-af99-08dee0fc1388
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|18002099003|22082099003|6133799003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info: Uy1x/Y56yo0/5EKDU1d1nqG2fXHZ0QxWg6ItuwcJWEZMCPGFdxzVq4IVduoQ43AyvoEOXSf0MAcFVyehjDfhkCX0i7su/IPvsXyoiHoQZqQ8Dv2HP8AEikASNYLZS+IuysMzzEby6H35hsrYGzZLxH+b8fAOBaN8VtmfSXIA6G1UokKRJ4rzfBOpOvr1dw4ywMjWl+i08Z89lVK1z0pfygG/OyHAKRFGOoUvyGmmxyEd8zxEhs0R8SB9NuGcKp9f5i4obyAPiH9u8WtVWATwiDNkrBwI+zXe3P8IuMu7Z9XoKKaNxeDIHll/QX9KEiK8xALVEGWp2ell5clgbouxHPpS0+ycPFLOF/nqM5StqsL60slg18SnrJW6BRm3ht28ANMjSeYSo97dcbKxl8eMrqC0mUMPRlieyOUGiWtdASg9JNBjHSn9GzJhDLNWA+6wqL13Mh/Aqe2mkEWJiCd/tm8c/QZkNvR/jO1b766NF2WVIrlOw1+ubQcf/durbzxLQWlF18fUwvH1j7Mt7Tf3uTDcLhh7YaDZzgg5zrUkmdGdS7ChUbxAQEnuIR0sUqUjuq/zsmNaWzQKom+tBJ06fWfIxcBVku67npUvTgbFYe6nnYlmt2PK7pRzk3mfraIavKfx33wP3+/HKfJLkx7dsT58fS7ierfERQMCOaQcVxM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(18002099003)(22082099003)(6133799003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i35I8h1Qg41m/1i0+vp/K+Ws0I4HcXNsWMXEyeFo6j+ErcwN0vF89z7MxUJO?=
 =?us-ascii?Q?TfrEy1OS6JEn/HioGZBFBHqMvUpvftIHdDiwUwYTV8gF9b+PKGfNT9EofcIF?=
 =?us-ascii?Q?kxAr+JW68gMrgQmIG7HGYwrZtoFOxmxdXddl52+WqInjBuYKtuSVn+xrhh6w?=
 =?us-ascii?Q?ofmp/i+zvbrO5mMH8TbO5lA/XclWWPhlvRpDyywFuaR+h7HwimenEK/D4r2J?=
 =?us-ascii?Q?SRzl2LfbTeWNRDpQ3FvBE7RIql/eo0ErFk6cNc+ust6Agl71ywqyJ8AjQVSJ?=
 =?us-ascii?Q?GFNh7foo9S5O6TW/LDRUbbJPdkK12+mgZhYC2JvHVfZfuaOarttpXlX9pAs2?=
 =?us-ascii?Q?ZY0RbdAJzuD9/zud/bepmkd2hqWGAqKcfSJqTLStvlNFxZzZEWeQ4pja8BAo?=
 =?us-ascii?Q?KBJ4uudo8rNms//io9vUACgyxAWNop61RknymYk+8rHpcJ8IuvSNN5T0Z+Qq?=
 =?us-ascii?Q?NOWMy1oe5MiNIf4vW4pSQggeqUhhnQ74AMRj7d4UMa8dfxvHMTlhIawvp6t8?=
 =?us-ascii?Q?FllhpTRohH/fP8ggN0VbLme0iut14hrCXuWQRSv+4MqAAK4RVkknbHfDwobo?=
 =?us-ascii?Q?ZbB2E9d3YSyhUfeU6EIelh9y7VVKLkYFL73qOpjG3LkgjSkTWCBfZ5xeebLi?=
 =?us-ascii?Q?rdjXqwQxrU+0Kx50KRPDX+Ic2muPtZX+70IgW1PeXxScdKKd22nE0RxH6tbE?=
 =?us-ascii?Q?ccvGnfi2tMMGCqimetFGFAYHnnIqiWUH7UNK14z4eHXbW7nrAUyuRJ/e2Dau?=
 =?us-ascii?Q?krf4cONY2ro48k3e+4KAgV10esntGIZK7YrKfUW0ndihJSECe8lScTpfMYs7?=
 =?us-ascii?Q?5QL3Ce8S05doBSHzVOyCbTsfcX71a76H+0LkSO3WiKbCSx27kgpsxGk2FFh4?=
 =?us-ascii?Q?6X3buTsP4ZcSHsditXTWXjRjJ/0peZJwQ0p07Rbr3SCIdPcbpKeKpLBCD2Zv?=
 =?us-ascii?Q?M4HUcgwcHL4iOk331/rTlkyYl53Lj0OgM7WXXrYNKL5TUdmvEYmYEXnwxchg?=
 =?us-ascii?Q?YA+jQnptLkAm2bTb40fXKDZPD/TjejuZnk6j0LrsilzT0xK6xCRaP/rCLIMC?=
 =?us-ascii?Q?Ugt3jdORZKcHh5Kkc+raIpySlobyBJC+spPx8stKH5WprR41XpdxtQnIn3P8?=
 =?us-ascii?Q?XjTwnInZjmp11425f6WoOnN5XDuXOMnHiuHBVZ10ps6eUmOkH9Tp+eJc02js?=
 =?us-ascii?Q?XS69z9Qah0onHgzrz3hDooM3ohrBxwqoWZ7F0zK4pVJ6NZ1FKX4k6J47Fi3k?=
 =?us-ascii?Q?0TbNI7QzwU+zR68mhTg4iskc6DAz2O+Mkkhsph0IbOgPVpnAuNrZjw3Br/4G?=
 =?us-ascii?Q?qW4JpJ7skduIky6+IyaggiX8k9f2KZaAdE33Lg1rdngaAMzr5WjjHYjpgE7q?=
 =?us-ascii?Q?SNupJpp8Gt4mFJp3Ey39m0I83Bffw934wPJhgPyz6ate9+aub8ag+I/0Gt+o?=
 =?us-ascii?Q?sL1d18Ctv7dN0+jGMwVx6CQigMJJ6xLmL+rhCEerZv/q3dwvSYbfIwG1p9R2?=
 =?us-ascii?Q?ckZe1xvps6VZdexAYiiiTE2ROsZhB2XwF4iaXOQF89ZfatOqLED2zAm7fwdb?=
 =?us-ascii?Q?CuFmgwpL+8qGaEoimLEpYnk/huUgRlojFELYMCNs+bbHslcQUH45PsQnX70y?=
 =?us-ascii?Q?Z1cMiwmWGmULvi4pz2yFdwMVfwCnXsLoRPAEsLMDR8yuNQ4FHHoiHyRLVZae?=
 =?us-ascii?Q?GFBYFLNY6D351FPQrgLPoyvjLLUtTEIR7Wf62GeS17rEC8cADr5RfiKfC19L?=
 =?us-ascii?Q?7oeKnjo1Ew=3D=3D?=
X-Exchange-RoutingPolicyChecked: Uz3sd0ycUUqWQ5KTeaItux2tw84wrnYOP/bPowPxlfT6bc/PeHAaQiNH4SatJw6zGNjbWxRnP5sD5JjkASnq7ZMGn/4YlbOnQYuGzic2xwaJZ73QxlElHrcDQBw8eAaZjL9SgTgFJ3rLUvjdmcOoChpa0KJklBkDflFuClCRUoCNB7RnhiFzkmQ7SvDPPF+w8QBcWMHRJ4YVSLJ02I/bEYNvDvdqySeTHOyFIIUIKnF/Wp0fLaOLMOSSzKX+CQEOwaYg82YvkfeZzSg8ovKmw/Wfty+H2Psxbf+dXGJUkjHBurstLpZj+xGLusUaHP1JVgBzVFMsrRsTRvrW7Pd2lg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 038359bf-0ffe-445b-af99-08dee0fc1388
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 16:30:40.0039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qIzXeIH+EO/jPACPKgGCD2jncJwlH1gYdiRQ0zxBrmUz9WUoPq6pex720qNzBuYNYpO3uOuOpkf1T8bNrQpbpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4531
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 59EE740002
X-Stat-Signature: xf81poo4fhp5oatf8zwts8s3ueasp5ey
X-HE-Tag: 1783960246-539092
X-HE-Meta: U2FsdGVkX1/S0CLJteg7S4h/rXDGcKux9WlPBpxGJmVadYf+hfCqFXCYt6m4VLnnYAYdHkHCmVymLzzdrH//+0qcbIRAz2DemU5n6tTjnLApTClS76Pqq6pOCuEacut1RT0WzQE65b1vhK77pz228jn1cBZMcHsupLKXjpVLoVwHxp3dd7T2pg6RSyCGhPrLoBTpfxrt52a+3Prwzi0az09MSFBO41ia7ODihrE0KKNJv0mUCJX/WRHfEdFLatnD9gfHyp+m66OawBK6ByDMzm8yD2Qg+jL9sEmEL95hS+8XChTTCspDURNxs6vD4izFjRosp9rkFVoFd4poy+Bk1dSMP+TDziKHrpbesIzZ9Nxu6s/5CxFa7NCTsV0ZdtbFpVVqxlO7PQOGZtUIQVbY72FiYiPzcDuBIKgGDXrcR16teISKWx0Ygb/eJtIqQm3v/hvq5uEow7oSYUvROPS4v/oId6O36f6ndGwTLXLQ2Cw7avbGr6yyidfCJ1DQq62UzqTvyA2cqI/QmSZRN92AJmXrvByDSkAmVtz7bz5u8HO2AW9nf9nCDhwGzK7+9VP9N1LlVZZwxqWnJ1gEcahN7acNKjngExA4BJKAJ1zZner+svCdB24rqjqq0sZmo1IKvjF8dpO5fQ0nhD9hGcZyggMTceAUJhQu7f1hMtwi1XoMOhxOaRSoFDGzg0OsVEk9JGMYDH6peZJEHDVcYLv8FTqha4MbIuXxM3WAlxX2+uMYNA9v+0H1Yjh5NRtc3G9S3FY0nHPsXfCzmt7R6Jat/pJNHtuIvjs798TIFCz4Dt3WjNHdhOulpWxzpTpHZEf9V4GAGkFcFOwiMcV28oz0BuWTyiNXLGhR0prfz9sUQS1FZ1DD8dpM5NqanMaMI18yKgOJLgd4xqD05auPGTIXhx0HnK/KVrbkR8PK9SC5K61i1XwnfSZDjet/ins54aAf5Rh4ioUy3VGPggmmNef
 YSyZl8YZ
 WrPk//atYWDoqOMvAL68DZ4gmLY67sjQezVI/GJv0utfUSglpShRSOMEDXuIW+cZi3NG2H+UuSVqoV6rIQZ0Go8C2SEXkAncYjL/G1f09/pCPCeA5YP2rtOIMnRMe2APrF9kDRYSKXGLNj2zTgdK77FNCawmciE8pxrxX1NqnEOhJNJzVauvm831AvCX1ga5CvSHSO/2Xoylgw/ZSunzUaSRZ/agZ7i5vmtwcKI4vglRobVuNscKrTKS3JPrwL3CE+wQ50Pm0JzRG+uEWcNnsHGCeXhKina8y/xuMabypMcGfS68yR327pUkswhT5rPafJXuG9nPUCt2v513IuSM5E0aSD8pe/AhU45Hmrpeq/8zeuMhsk0NnTawcm/U4uMjGFZ3oRAWiQKUGPr8Ol5+w9iPrFeoTQMS0mdBdQ6UQgiqAOh0xtwu5DfXkcs7Tu37icqrD+Vz8jsKP017jK0q01ZxdqHErDVY1pCYK1AzLtxzDxadsFZDVCO1z1eRpUPrtX11ewPu1Y15kX3M1orz19xBL8SyYP42dZvae8ZtocT9s8CA4bOBFk/eczmqvdaPDqfvAa40j7RSbDzL5wHAdUmXM0QwTolZV/ubyOlxjyhkBqXRfnhdC4RL6Qx7H3ko1hixG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 02:27:19PM -0700, Stanislav Kinsburskii wrote:

Please send series like this to intel-xe@lists.freedesktop.org list too
as this will trigger our CI which expercises the change paths changed in
this series.

> Several GPU SVM paths take mmap_read_lock() only to call hmm_range_fault(),
> then retry -EBUSY until HMM_RANGE_DEFAULT_TIMEOUT expires. Those paths use
> MMU interval notifiers whose mm matches the mm that was locked for the HMM
> fault.
> 
> Use hmm_range_fault_unlocked_timeout() for those faults and pass the
> remaining retry budget to HMM. The helper owns mmap_lock acquisition and
> refreshes range->notifier_seq internally for each retry, while GPU SVM
> keeps its existing driver-lock validation with mmu_interval_read_retry()
> after a successful fault.
> 
> Leave drm_gpusvm_check_pages() on hmm_range_fault() because that path is
> called with the mmap lock already held by its caller.
> 
> Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/gpu/drm/drm_gpusvm.c |   52 ++++++------------------------------------
>  1 file changed, 7 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
> index 958cb605aedd..6b7a6eaebcd9 100644
> --- a/drivers/gpu/drm/drm_gpusvm.c
> +++ b/drivers/gpu/drm/drm_gpusvm.c
> @@ -788,22 +788,8 @@ enum drm_gpusvm_scan_result drm_gpusvm_scan_mm(struct drm_gpusvm_range *range,
>  	hmm_range.hmm_pfns = pfns;
>  
>  retry:
> -	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
> -	mmap_read_lock(range->gpusvm->mm);
> -
> -	while (true) {
> -		err = hmm_range_fault(&hmm_range);
> -		if (err == -EBUSY) {
> -			if (time_after(jiffies, timeout))
> -				break;
> -
> -			hmm_range.notifier_seq =
> -				mmu_interval_read_begin(notifier);
> -			continue;
> -		}
> -		break;
> -	}
> -	mmap_read_unlock(range->gpusvm->mm);
> +	err = hmm_range_fault_unlocked_timeout(&hmm_range,
> +					       max(timeout - jiffies, 1L));
>  	if (err)
>  		goto err_free;
>  
> @@ -1439,21 +1425,8 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
>  	}
>  
>  	hmm_range.hmm_pfns = pfns;
> -	while (true) {
> -		mmap_read_lock(mm);
> -		err = hmm_range_fault(&hmm_range);
> -		mmap_read_unlock(mm);
> -
> -		if (err == -EBUSY) {
> -			if (time_after(jiffies, timeout))
> -				break;
> -
> -			hmm_range.notifier_seq =
> -				mmu_interval_read_begin(notifier);
> -			continue;
> -		}
> -		break;
> -	}
> +	err = hmm_range_fault_unlocked_timeout(&hmm_range,
> +				max_t(long, timeout - jiffies, 1));

Unaligned indentation.

So I'd write this like this to avoid weird wraps:

ctimeout = max_t(long, timeout - jiffies, 1));
err = hmm_range_fault_unlocked_timeout(&hmm_range, ctimeout);

>  	mmput(mm);
>  	if (err)
>  		goto err_free;
> @@ -1736,24 +1709,13 @@ int drm_gpusvm_range_evict(struct drm_gpusvm *gpusvm,
>  		return -ENOMEM;
>  
>  	hmm_range.hmm_pfns = pfns;
> -	while (!time_after(jiffies, timeout)) {
> -		hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
> -		if (time_after(jiffies, timeout)) {
> -			err = -ETIME;
> -			break;
> -		}
> -
> -		mmap_read_lock(mm);
> -		err = hmm_range_fault(&hmm_range);
> -		mmap_read_unlock(mm);
> -		if (err != -EBUSY)
> -			break;
> -	}
> +	err = hmm_range_fault_unlocked_timeout(&hmm_range,
> +				max_t(long, timeout - jiffies, 1));
>  

Same here.

Nits, aside LGTM.

Matt

>  	kvfree(pfns);
>  	mmput(mm);
>  
> -	return err;
> +	return err == -EBUSY ? -ETIME : err;
>  }
>  EXPORT_SYMBOL_GPL(drm_gpusvm_range_evict);
>  
> 
> 

