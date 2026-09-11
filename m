Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CED09C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 09:46:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB6C16B008A; Fri, 11 Sep 2026 05:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90246B008C; Fri, 11 Sep 2026 05:46:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B56E56B0092; Fri, 11 Sep 2026 05:46:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CB416B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:46:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA1C61A017A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:46:51 +0000 (UTC)
X-FDA: 85201002222.02.D6A97DA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf15.hostedemail.com (Postfix) with ESMTP id 84455A0004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:46:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JZaZ667O;
	spf=pass (imf15.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1789120008;
	b=kPZmRtlBowQPO/iS2tY0zz3v3Bwgm1q7PklBglxSwbh6V2JfrIwu5pSK+/os6dgyaYGDM4
	f1qQlYtBA6kj4nMY0pg9btB1T0r5duazikV5WGUH1AsvmvRIDeQJuFFT78cP8tqiW3QbK7
	hx/7EfYhHGkzo6z7XV9MEWn01YR7uFE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JZaZ667O;
	spf=pass (imf15.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789120008;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mXCeD7af4CqN4w3BHA75JQpTrzDCJWHdDp0N+KgWt1s=;
	b=pE0aEYqxfuDt78oucxhgGg/lyt9WADOkB49PsS9BJjGJKKand7g7+urMH6Q53oQdebHaf1
	nRxYMh5PeNVNMQ8Htp99xf6o1BgRyEXw6xTLGdHTDjCvUvG2q6bX2hFEB0QU6UiZuFW3zD
	Yhm/2D+7Sajt1A7GLUa77I6hbXt+uGU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789120008; x=1820656008;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=DIRkyzoPl1oOiPvJHQDi5/e45JQynfbJjFZdhbYSZb0=;
  b=JZaZ667OnHTjyrA56jqOJCAGVSZfEsZCQxqXh3+YdCgLX/q97VYz3m3+
   ri4qQYLMnq/ihcJsBmZgvIRTmwBTxKfXhmKZwfu8jpDvrrzO6nhTIa6QL
   iFxbefkUmK0OYV8cNPFpK6OxIQcasnz34q61clOMHBGanEpqerBOR9l4j
   V1+jfOWnXD+r1ivoGRkOqpexwcphl4XUGDtdKjjhj7knnEQsaAUXViFNt
   tVbSTd4OVWIZEwy/xfUnmHLpHPgubQhISrnfFlFwW+slaIdOA7vNlvVUk
   mcdqx1zbQwY/TYQZvNMNLq/kM6I6kYzlXe7vnzi3zq166v14DvNVePIzz
   Q==;
X-CSE-ConnectionGUID: RjsAkzYNRKGdM1a8mAioqw==
X-CSE-MsgGUID: zxupkZghRRexQCR9d5Lbpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="115121362"
X-IronPort-AV: E=Sophos;i="6.27,97,1787036400"; 
   d="scan'208";a="115121362"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 02:46:46 -0700
X-CSE-ConnectionGUID: Qq3FtTbpRJSRzH2zSHCqHg==
X-CSE-MsgGUID: QMoPsYZ0S6WMwtyGso2WMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,97,1787036400"; 
   d="scan'208";a="296860041"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 02:46:44 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 11 Sep 2026 02:46:44 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Fri, 11 Sep 2026 02:46:44 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.11) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 11 Sep 2026 02:46:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=al0o8OCZWCIOuRSHGurvYj0/q9Z/R+xVcIa1l5hpobARZxqqnPr9Wauk2+HwqI3rxW1FurjycQswhDT5uXCbj+xcCYjqKEqLygSWFk9i+W1K2Ozxl5vEHP3HDEIS3Xm4mKUm6cZ/mVwXnaTyqSqkmX/i5aQ9XD2lYaevGpZ8VlUsFl3K6eZVFhIRmKk88KSbkeQYwjrSZXRAZxNVaPwV4+S7cwCmA2elznHMQ24LkGJ1c3liFPb1uALpY3jrX+5jdtwSKFycVxm4SkEQbW/9p4cQQtF9UmoHycRaqVnvJeFcol3t1neoqkc690Hkjdv0cJPFjioAzGF4JY/GDzDMuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mXCeD7af4CqN4w3BHA75JQpTrzDCJWHdDp0N+KgWt1s=;
 b=XkSqchKvn2NQTLYpk6X5gFLLRW2waHwQWeI3pS7v0qc3elhN0tZZv/XyCl8mJuCTqdfJ822ZDnHlc5UtU8qTc5QFPAXA2MtG5UFagH7+vsF7yEEsGesvhFSEnsYYv3m+/OwtsXFElUepHfjTQ58mtlNKKKjcqQizIBq57z3bBO/TSwhg5ZTLyZHXjqq6Iqor9z/tgKBzBf3S/W7la80nG26rwahFLYvSNrTHBkNoobi4gHVrbXvrKnbzZX8dJhN06KiF0t5fukgK0pYC/9bMjaff5UTvlqfMxtnqEZnFWJR5SZr8GaGPjmOzNkHUEPc0VmeCTGtup1xD0jJqTwtDNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DSVPR11MB9579.namprd11.prod.outlook.com (2603:10b6:8:383::17)
 by CO1PR11MB5060.namprd11.prod.outlook.com (2603:10b6:303:93::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Fri, 11 Sep
 2026 09:46:38 +0000
Received: from DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d]) by DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d%3]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 09:46:37 +0000
Date: Fri, 11 Sep 2026 17:45:51 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: <ackerleytng@google.com>
CC: <aik@amd.com>, <andrew.jones@linux.dev>, <binbin.wu@linux.intel.com>,
	<brauner@kernel.org>, <chao.p.peng@linux.intel.com>, <david@kernel.org>,
	<jmattson@google.com>, <jthoughton@google.com>, <michael.roth@amd.com>,
	<oupton@kernel.org>, <pankaj.gupta@amd.com>, <qperret@google.com>,
	<rick.p.edgecombe@intel.com>, <rientjes@google.com>, <shivankg@amd.com>,
	<steven.price@arm.com>, <willy@infradead.org>, <wyihan@google.com>,
	<forkloop@google.com>, <pratyush@kernel.org>, <suzuki.poulose@arm.com>,
	<aneesh.kumar@kernel.org>, <liam@infradead.org>, Paolo Bonzini
	<pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, "Thomas
 Gleixner" <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, "Vishal
 Annapurve" <vannapurve@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song
	<kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
	<nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, Axel Rasmussen
	<axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
	<weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, Qi Zheng
	<qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau
	<kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe
	<jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
	<peterx@redhat.com>, <tarunsahu@google.com>, Randy Dunlap
	<rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka
	<vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren Baghdasaryan"
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, Fuad Tabba
	<fuad.tabba@linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-coco@lists.linux.dev>, Xiaoyao Li
	<xiaoyao.li@intel.com>
Subject: Re: [PATCH v13 00/44] guest_memfd: In-place conversion support
Message-ID: <aqPNz00MkV5piTyc@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
X-ClientProxiedBy: SG2PR01CA0186.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::14) To DSVPR11MB9579.namprd11.prod.outlook.com
 (2603:10b6:8:383::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DSVPR11MB9579:EE_|CO1PR11MB5060:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bbc4e4c-ce09-4655-7710-08df0fe9928f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|23010399003|10067099003|6133799003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: YwqIEbxu4RgKFSc28FM1rd8ymkSWWNGh8C5qMTipL3h1swy6y0eymp20rlNzIpJ8NZXRsdMHLFDPAquP4YWrTY3UL0bh7PM2dI5QM01TEwik4TKjIqKhvDXx7LvV5bKwCkJ6KodLIps0IOZhVn9pKLHE3w+RMSGY+u+v2lQ0X6fHsnq4eWFNBnuaSw/zJEOoK18fWjHd27Tqu1D2WsuTHncMkjuAIaSdaGRFGhOVFHa2LUbTQ9Qf4zAjCdhcsFLjVqCVLiNyYNIslKbpoAxWHx436H4e4CERAKZKiHLlUqm2OclDrqLm6GAxFWXnZpQy9Tn1mVR83/Hzb/F2KFiu3No73VTd+hiCDFF09Wgu9u00JjBXued851Una+eyQteKdWCPUDFOVQdfFBHjhELRchuX7GLe+iytxUjSSF22v/y90PeQRGZaNS9a6WMUzYFC5ajFgKplnbsz/7OiweUh5LxisUs6EdOg7d3zi9zYAJ0XtR7yZGGwfIZ8P3WL15vfKdguTn2UdHVlZHch9p0P5JQlOii7fT8JO3co6ev8+plPoFvaP3Xcu2koNi+Attq9mz8gWSiBg4zqJVpuahOzn5FOxX/8JNINYnIM+TcYrKiFu+R34BVVmjqGudmf5NDd356zwd7jHiVq7/r0E1g0AeU947q3IYWea0aTtprm9is=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DSVPR11MB9579.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(23010399003)(10067099003)(6133799003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y5UDoVOsLzF31zsJtdqqwphxUuvJtHmZtdDmDMrcq3oLC897PGH00pgN3I9d?=
 =?us-ascii?Q?o4Etr/VoKCMG3xIljF0cBNQQuatbgWVxjgFya3KknPaWmxyhze1CBNCc8Um+?=
 =?us-ascii?Q?RJlaW1uLGXANRT3ErNWHcflHqK/2J/nHrUNVLY1tKkgmnQ7UpY+rP4/Ai/tl?=
 =?us-ascii?Q?zPVhWCQIrtMUTR5DPGp96D+pL1X0Kl9xAoOFElAtc12kcA6RkVTHqbPMTc0l?=
 =?us-ascii?Q?6uKiX2o5psJXOBjQ8szaQXK8VNrXq/0dfeFfageW2tPTMsgoAvYGGFH8dKCw?=
 =?us-ascii?Q?YPVzcwnVCD2WqPwYF59NkQZBtsJM74P2gC0q+n73dLc0PkfTW8Tv2Aqsv2+x?=
 =?us-ascii?Q?ogq3c2pQiLpakFIz1OMlthWVB+IK3b588HcarMYKPc9OeFi9t0OVHgNbMvlj?=
 =?us-ascii?Q?D9suuZMNAOt7r06IpUyDhkxY2OCgiaLxaj4SmiXf10P4VA1EWg/H2ie7nmq1?=
 =?us-ascii?Q?ESM/27BGrCIUKHLc35e6c9hAGuevcQkmi7cfMA3NGzkEjjBvpkDwpUL1QKZm?=
 =?us-ascii?Q?zhj+W3FGw8jg1oLfwBuJffep8lbXqPhqMizhnAUTVLhoth2k5FaWumI2OSCU?=
 =?us-ascii?Q?VpsI3OqTYCHEt3m5IeXMfT7K1Iu1CGeOZeub0C/C0WIwy1KvPI1TQZunsKJZ?=
 =?us-ascii?Q?T/+9Bb8DqaL0CCTwtLfwYNXzYCidNum9f3Oppki75kQ4wM3Us7gis9ywfdMy?=
 =?us-ascii?Q?3jg2x2oE6S+4+O28J9fRuHspu1XwbjC+vSXAMlypAQOBIn1V0t8mmgESJLfo?=
 =?us-ascii?Q?mFn8rKDGwlx2MRtkwhiaeNSij6FaACHCaOf3j7vH7uxJQWyTBZvqTdFNOJJS?=
 =?us-ascii?Q?lWkfH2V94kQDv37tahZuRKo4x/unh5XiDFH1h9wXN5hLT2PWYGYV/qQ3+m0M?=
 =?us-ascii?Q?FNa7+5WOExF13pzJcIyUCo1QWYOmFaVYWWygHqauOaunfQoRYl7V4ykZtfAf?=
 =?us-ascii?Q?ky6V1X8KtTPBJDeZlDCbRaQ6tAPcTiCSuLNAllzeglXSALpjxofnHIHLxReG?=
 =?us-ascii?Q?JJpZodgMn3Kuk5fkigEilVZGzVfLBFLmP6ji2REi5I/ABmxqtTP/YO6PgkRC?=
 =?us-ascii?Q?2G6z1uJHAKcFR8rrT+3CKYJFhOhkh4bRt+2joF0KyhHZ0x2e93azI9ux9T87?=
 =?us-ascii?Q?sbk8YWEJ5ra1Omr2FlPNQAEv/icT6X86L+jF0yk5oEtbLNQipjEEnFMX3Pb+?=
 =?us-ascii?Q?6bu+s0D9OBfxIhMjCDqJ+qd8gwN3KyXCmFMdPxPojT88+Kx+w4aIljCNRbcu?=
 =?us-ascii?Q?OU/x/moAwbTbwwb8Wu00Q6V0+55vyt6+W12Z98tEPMfPUN9LzAoWbtgp622H?=
 =?us-ascii?Q?jmn/aoV8c04XyvRjzk5LqWEmaO42R6BW1wrKWmRbt35CK525qaoRdqiDIh4D?=
 =?us-ascii?Q?ycQu4maT4w8IKXyYpvrIJ3PWUU9Y7N3y66MG5EPnR2FsdJWjUD+T+A6p55Mw?=
 =?us-ascii?Q?fXyCysw8JXiIYhH1+0Bvrgso80TPF8EW/Zs3wcCA8BLzuGLTLvMagWqPtwMw?=
 =?us-ascii?Q?w6rGi9YF491sY8AWKT7tm7Orx/SvenkB5Srzlke8pRG5jeMDaMT0JZFxNSXj?=
 =?us-ascii?Q?Ws9veySehVx1t9oO1LdID2QWXCwcRRvrCg7KmRp0lJJPy1328ltqsMEBSMWs?=
 =?us-ascii?Q?aXIdeWCbZLwCHCNk5wR79bpFcSPBsm5T0l+SCUkZ0JsaSAwMLAN7og0skvM3?=
 =?us-ascii?Q?+ztFADNJ0XQDNMDYAHzAB3Z2kSINg363+RsdzwEbbHtLtIF2Rk6jYLcchnE5?=
 =?us-ascii?Q?XbVqlecMBA=3D=3D?=
X-Exchange-RoutingPolicyChecked: qXlKzRjHjQNRGW/YS9TxLKSrA8xVBqKvJXzkfG4MO3rd7/p4FyF99H40HlrV8GDRqkp7sFioSyfNkNVkFNfI7Dgk0cnYEudL4CEZ5wGMvCVA1bo50XmkSDoMv+qsNT13HtBTVAIRo4zBMybeSl5doBFBcUegbJnrYUsJ4l1u0dym096Rv+ta5podEd9+b/mrzAUdQ6vm55C3b8cRwtF+Pm+CiUGUHcEqe5SmPbsssua5/bO2UHGEcm5YyB4Sx8YFMifZ/qGvhdOA9oD+FLTJUkd7yknsFr6B16l6XsGNQSVRx6IKUmlOTG9sZz1CxK1FYsKwSZbrr8kBwG85ZvyHVw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bbc4e4c-ce09-4655-7710-08df0fe9928f
X-MS-Exchange-CrossTenant-AuthSource: DSVPR11MB9579.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 09:46:37.2334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sU2sh2dVk/3NYEwKz9tJL907uuq4XCcBV4YfFm53bK6GI686U4tmeh2Fx6QbPUhA6AXFymep1Yd3ObqPrCB+mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5060
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 84455A0004
X-Rspam-User: 
X-Stat-Signature: g7yus5wds9gofgym5ufj8mfzzyx4m4sz
X-HE-Tag: 1789120007-560801
X-HE-Meta: U2FsdGVkX192LocyZUsI1aiysIn5W8yUaPgOKaeyip447Payslr/i84g+/iRqln+S0+ISeP/DYQ/DrEkYsypGdnNhfchbQf7ADiKC4iGrP5ejpZj+a7eNfFFpf+0NvHtcZkIMfyo6VPRagYbXVvZt8MuboKoi3nJqMkwqslE8UmIxvR9xMsq80aIh06EnUxz9/oFoR22X4A0aZjKBqBoHxKu+BM9r3Qhq96dPciRYo9bLOZCViCQ/ZU+dhPHpMxfmlpmuc5KD4GAcJcIAHnkBtkt0eAgbNyqpwfegQjhcRv+lXx8bYxBj0AfxZMlnb5qF0YNVWYtgGbX6q6OPHfoWKyysvb1L/LgxcCiPd1XL5oCwX+vdvg3/TeWhEiMGOQw/Dra6DbC2zn9EePRKH3Q7euJUXfeJ1JoYBe2/K6ckrwLPA726zGKZstbspv8IpdjshP4sbiAiGRgLi0yGFNEswLIYgkcOvlQUxyvYB27BZ15XPQCCQK4JxyykvuIadhweyANxzlU5Shx1yGY4tN2WFt2N6hcgd118l40YrWW2mxqjplt6u/Pq5WSwlwWIG+N+TKL1+fue/zRERVjEEclUcyee6JeDDmGTm4gZzQvc7ZSwqmFvlioy3EVVfluDAQpMiKXHFJYrbrOwjPcZx3wsoojkjwoz3v96VUu8OvWNT2vObBLjcNL3WDk6pASxYiVym202avHFL5d9MhxRqHir+xKycH2W+YU7t7lwW3D+IaYVJKhqpUpI7PK/ixTGVKDBSPashTE8aFWjhtM7VMQzLsb363NRMsmupw7Mof1SESU+GEmSJYsS+F2ClHZpNsGSp6o8NCGP157TBa3w62IVQsvz8go7RU+PQbhNzgZyHOmCkSlkfPzm7YPH9re7+lAV6F4pvNtNR/WrjRNzPVpkC4o2Hgb1lH59OVAi9MMEe/k8hCeYm5VCVMc/whmMuu9FkomTYEoMo6y8hBH33w
 N2T/jfpi
 ea+Jv+DFv2vUbLOhTJpUnjK3grkBEPSved9evlx+I8AsqikbLkxSmfGEvlZ7VOLfRinRJAcOSF2VObukNTwkO/MPggK2mhL72egJRPm4q8TTUJbg1CCFJB+mslF7lk5/SOx9jh48AlrSOzoVH5Kzd2/9lF6QpMnL8lehOmthPdgPw8abiOGQl9Mfg4Nk2mf6oJpHgk2GUdzD8biX1Ot7UfWNDo7b53RX10Rmav9/LdSyL0AKEcTFev3yQ683fAk0s3ujsLO5WAJkM2KdGx4ZuLv1uAXjKHG0NIuGjff5mOKPdwAhc8bGxsWzx9LiGNhJDr/ZlLB1gQ+1oUQqXYfcMvALS/eGIoGxxA548qSso7WLUIbGA7DjKLAuQAeuQ972dp3JzbCvPZ2huWwLyV8GDAjUua3WgC9+AboxnKQ9bQIth/jXBs7Sx0Rbw9FUcCfCrlsj4wQvJYcGbD87coXH96nBxb5OFcFFy5qx5mXuEUAS+C7KPaBaQ2ICSyWsUlEI0zWihgwa0s5lk2yZiHYKeAnobH/ej/CTbKjv3g8UoDXyMlzxKo+VfbK2q1mhn/umcDsrVoLZZ/rWDbMVKX53Y/ozgNhzAJZYL4J4/CIK2oPiRyXob62ROHI59kTYHaZiHqrLg4A0XdS0Bi8J1HFv8LzBeknCOcrcmUS6u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 04:55:26PM -0700, Ackerley Tng via B4 Relay wrote:
> Here's v13. Thanks everyone for the comments and fast responses!
> We're now at ~3 weeks to soft-close at 7.3-rc5.
> 
> v13 is based on 7.3-rc2 and:
> 
> + Hugh's patch to export lru_cache_drain_for_folio()
> + Another series [1], which makes kvm_gmem_get_pfn() NOT return a
>   refcounted page to KVM.
> 
> Here's everything stitched together for your convenience:
> 
> https://github.com/googleprodkernel/linux-cc/commits/guest_memfd-inplace-conversion-v13
The following configurations were tested and all booted TDs successfully:
(1) gmem_in_place_conversion=1, in-place conversions + in-place-add init mem
(2) gmem_in_place_conversion=1, in-place conversions + out-of-place-add init mem
(3) gmem_in_place_conversion=0, out-of-place conversions + out-of-place-add init mem

Tested-by: Yan Zhao <yan.y.zhao@intel.com>


