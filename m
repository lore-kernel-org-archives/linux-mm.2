Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58D34CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 01:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8E246B0088; Wed, 24 Jun 2026 21:21:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3EFD6B008A; Wed, 24 Jun 2026 21:21:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C05F36B0092; Wed, 24 Jun 2026 21:21:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8ECC56B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:21:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D1BE1C5F27
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:21:59 +0000 (UTC)
X-FDA: 84916683558.04.A8FF3BB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf14.hostedemail.com (Postfix) with ESMTP id E195D100002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:21:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iek+IAs3;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf14.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1782350515;
	b=cvIMrn337nEdaIQ9WkTDhbi3kYnri4224ZysaKHUqX5o9jFPWKn20qr4iKh12tBDRIRyPS
	l/X0UEm9iK+O2jfqrlpqfUzlEgSLO1bAsjyYNMs7psqO2T94wWiUOXyK7tGAZB5xPvCoC3
	rXy442a2RP/QVqCHg9XcD33WgZRjkHI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782350515;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z7PqDqL3q6cC8iMDYNhSqhahbCYYzb+Za+ugS7TZrm8=;
	b=Ot0nG2gYCUbEDj+Qj67bvmaGMG/PsxxbRCOCgmvfXZTIMCeyRvDrL0BjIUxlcRZFFGS/G2
	Lnw1FSJ4ejlUyso9xaQ3Ux5expTun4gezWS1E856oaJXaDm4HwZOCJyW17Buvv3JN00k8i
	xIPWJQKSk8YvJiQTJ0Mry904agXv6EA=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iek+IAs3;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf14.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782350515; x=1813886515;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=JUPl/lonhMVopPN1anxgGnqraQDyswtTJltSGWom5GI=;
  b=iek+IAs3Ebl/4qCI1sxMDfGBxYT2+DFpvVO9j65nBYWYjXrVHAOm8VWO
   KWaS5LvjET9xVJHRvgSa9thRViKTTZxjVNB86Ec2RX/Sq/1Qb6obs47Nj
   gaRpzMIfJb+yiB8idAD34oK+ZlJ9hhGNEEnzyj+Goq9kk9a5qLdgX3m5E
   Cxb8xykHftlZ2N0bOE/OeDEjD9wJ9vwxp6YgqM7cqPDvtDXMKRnb+uJal
   /QNQg5SkLYz2qW8JJZ5tHKGYcvQvNopfPS41Z3oBVVCdP/RVuATJ11Y4l
   jcU2/tfvK4rv0F2xiHlWqxY8I2X6B7xKyeKf5e05sCpW40M8elI4wxrIy
   Q==;
X-CSE-ConnectionGUID: GpU962yLTt6Df+vM+fsfAQ==
X-CSE-MsgGUID: 0pC48oXISS2vB53I1n0XqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11827"; a="86802283"
X-IronPort-AV: E=Sophos;i="6.24,223,1774335600"; 
   d="scan'208";a="86802283"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 18:21:52 -0700
X-CSE-ConnectionGUID: CpGS90JZQQKEv5ThtTjh3g==
X-CSE-MsgGUID: MdmjTuguRhKgwZ1HHC+wmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,223,1774335600"; 
   d="scan'208";a="249256022"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 18:21:53 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 24 Jun 2026 18:21:51 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 24 Jun 2026 18:21:51 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.20) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 24 Jun 2026 18:21:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iuul2ska7ITZoWb62ahDiY/bDr65aquUVG2Qc3VjWh90jBsk8AadsTj8ScM0h0VpEXDconIDFoTaAxmXr0gXuCYHLIIr3PVs1J5I9cgOu0BAH9lj5eebCxXyqlgSOtB9vDdQsy39MEPGNfpE5T6TLJtistjR95jjIIN+GJB0LRw7tusyiObd/mMRGEa94gVVrBN+5ndUSAeXwbcWnuIkkFh2Ijle7jWzt/PY5Zil/iCgiR0keSbKwaDGhj4iGp5fAV1VraLVRvnA9HA3UfyFqt8eYQ5qpkNZT2oSL9AIQQ2ci22dsUqlsifMXq9y6r71XolzS+XJL0lb+LUY7EFOPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z7PqDqL3q6cC8iMDYNhSqhahbCYYzb+Za+ugS7TZrm8=;
 b=LlxVzMpfnd0Sv7BCU9oqfjy6/xOWXYs9wujHQ+cqiJN7dA8HrtNr+vE8V0Wi2qZ8CsjZjRBiVn7gxUvp4qs6TZzQDosxw6Kb7hf90pVVadhaXU3Q5QmQKme9q/2C2JzrOZKL7LhPy1mQlEA4oODRx8MHS/DBoDy9PkD2a7qeSXZAbO2IKS06T/qnMJRkMsy6kivz+4TXr8dy2mNJs6jskEXdaxKUtjfrhDshe1FtJJjksfRrze1QAqL7T1M2Z3kkhcaDPNbHuxIWXRnNMZ89NGUEyDF6YhkqZCcqILKa8G0KCDeyBOSqxthK+PXE3+87lIr5YR74RAsHoYyjBCZpPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN7PR11MB7468.namprd11.prod.outlook.com (2603:10b6:806:329::21)
 by SA1PR11MB9825.namprd11.prod.outlook.com (2603:10b6:806:4d7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.14; Thu, 25 Jun
 2026 01:21:48 +0000
Received: from SN7PR11MB7468.namprd11.prod.outlook.com
 ([fe80::c17a:b7fa:6361:dbee]) by SN7PR11MB7468.namprd11.prod.outlook.com
 ([fe80::c17a:b7fa:6361:dbee%7]) with mapi id 15.21.0139.018; Thu, 25 Jun 2026
 01:21:48 +0000
Date: Thu, 25 Jun 2026 09:21:35 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <aik@amd.com>, <andrew.jones@linux.dev>, <binbin.wu@linux.intel.com>,
	<brauner@kernel.org>, <chao.p.peng@linux.intel.com>, <david@kernel.org>,
	<jmattson@google.com>, <jthoughton@google.com>, <michael.roth@amd.com>,
	<oupton@kernel.org>, <pankaj.gupta@amd.com>, <qperret@google.com>,
	<rick.p.edgecombe@intel.com>, <rientjes@google.com>, <shivankg@amd.com>,
	<steven.price@arm.com>, <tabba@google.com>, <willy@infradead.org>,
	<wyihan@google.com>, <forkloop@google.com>, <pratyush@kernel.org>,
	<suzuki.poulose@arm.com>, <aneesh.kumar@kernel.org>, <liam@infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt
	<rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, Jonathan Corbet
	<corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan
	<shuah@kernel.org>, "Vishal Annapurve" <vannapurve@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song
	<kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
	<nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, Axel Rasmussen
	<axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
	<weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, Qi Zheng
	<qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau
	<kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe
	<jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-coco@lists.linux.dev>
Subject: Re: [PATCH v8 24/46] KVM: guest_memfd: Make in-place conversion the
 default
Message-ID: <ajyCn0PnFtQK+Nka@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-24-9d2959357853@google.com>
 <aji/2svhcc84rn5w@yzhao56-desk.sh.intel.com>
 <CAEvNRgHYTFnHbsLLgMTCSitmnp1_j9Pomikm9qmpGTh1w8YE5Q@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEvNRgHYTFnHbsLLgMTCSitmnp1_j9Pomikm9qmpGTh1w8YE5Q@mail.gmail.com>
X-ClientProxiedBy: KUZPR06CA0014.apcprd06.prod.outlook.com
 (2603:1096:d10:30::10) To SN7PR11MB7468.namprd11.prod.outlook.com
 (2603:10b6:806:329::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7468:EE_|SA1PR11MB9825:EE_
X-MS-Office365-Filtering-Correlation-Id: a2207427-c5f4-4870-ce3b-08ded2582081
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: It9pnsPv6YWWQranJJmCRpA9hWqQhkdh1mJCuj2BZt2KIa+qoPBQaPNnrRBMT4hb7RmrBzpNHmpN55K2F/puvLwq2iXPIEuLvDrJm2a3GbV1PKFUqu8u9C2jLGt0zlWQ0LpZNVHkfwQsCM+PStZ11Nxas45RYaVvS6xnO7lsZybGrN5/ChPhUA2RD0BPn6ClT0w8ZEP0pXhZuxgyitZd/GmaDwUZg6ZTMIDXazRo95ofO6k9ID2Eh8gIBlKFAmYFLWXiBQaXAgQAcBKvM+LFFM1fEw/S6/2Ud3P/DbU7n3cAg3kI2cmmD9R6tEbE1fdUSSZ/XiFMrAQGAXZMGkjFnKnGll85sic0RFRja8XLT52tuvj175ZXB+llWqG+bGd7bK2G5nMwvO2v8KDvttzgh9TqTxhF3vBBIt3mCBK7B/GmDC3Fbb6y0+RQmoEY3WFjBrfvGM1vgVEbqiEDGkU/2WLvBDy5G94tGJIQq3q6ALJjwDyk5IwlaMUhfEF6sPyicN1eH/KyEUu0sWvq6QfvpQ0bv7pHJO+6Ym0fMIPEmcbq7MdEijXZCQc0N3J91L+V4nyBiaKRnzxMUl3ifn5AFKCT1vX/eHhjCgWVuyQX2O6xcdujUh7pQZMOnj9UpLhVDe84FpQxbA22Dmjy1GfNIslpCIYNDUGK5Za6WoLwNcI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7468.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sghNwSRR4rNLZZLC49dVCB0KqlixIydFTqdBKGqYNnNZ1WgZOs4f8HRzmfAU?=
 =?us-ascii?Q?v63GgvDu9bNF47qI0v3jFfEVoWHD4n25A5LyeJSn66IYIc0/e1JfdqO/Cj4L?=
 =?us-ascii?Q?xkTVAyJ3IlDMZBw+ymU2XvvzqIUL/p5qn6cW1zCXVPCo3pGPYQdflDekrvQJ?=
 =?us-ascii?Q?7ttBGcwbsbMW5g36QDHUyPOgQ4xgSrciVQN6pkFRungGkGmrmnzzz3Ia3CtL?=
 =?us-ascii?Q?nBZTtoSOUMjpNnETmIpqA81qrhroVnlYXqmaENba5iB9CDWzplXCas050eGP?=
 =?us-ascii?Q?3ij5lmqDXIi7tXRdyTy1hTHXuT9QjOA2Ien5BBJYUeHdA54rStY1VxtZORIG?=
 =?us-ascii?Q?CF071zk8hegSvUOTfmPAMuOGhCobMjLs5te7dFLoQSGYsxsG7zgVP/+8G+/H?=
 =?us-ascii?Q?nMPM8tl5It8V9wzuWkiSoQaUhssHb2kTgE5VGNEnxV3KkhkQ5QRZwhh2LT7X?=
 =?us-ascii?Q?eNPsemscEUACJJ0RdHW2kuUaPsp5hpNeQhQzhliD2cvHvIsVK3N7oausxGuj?=
 =?us-ascii?Q?THAvFS7L7H0rq/UwmpiF+B5QZ61B1fMTSZN3WVUW2Gw+bdeYt+kH4hOzh7Nv?=
 =?us-ascii?Q?SUvCrhxgq8wRpwUAKo3MLdPq85NLMeOpuS4C2jUDThVHBjWooDbtqfb9tgVM?=
 =?us-ascii?Q?adQJAqTNcQ9KTi5SsHPzubOwVnjFxTjUaSqBU3zkZh/+9JgE3Elhn1qauBI3?=
 =?us-ascii?Q?h0KI/W56GeBbr4+QEHS1VyZ51RDWNwS6/382PatZhUhbO3tdRa/4m+o878Ol?=
 =?us-ascii?Q?mC3e4e+nS9RbSyYJCUHqUqKUQh3IveUMBGUAak4BLinGVMnAgXd1k9RmigDU?=
 =?us-ascii?Q?eapwFJUFVe3WwK/LpXLNg5unXe2QXWn/EbpWaycLiamFqejYT0RDyggmtvI5?=
 =?us-ascii?Q?ZW6uq72h/dzQIKoaZYMVWS5WW/TQRnAp1yS5GvjmhzuSkVxPmOSt+O/nmKuk?=
 =?us-ascii?Q?ttYpgutpA8sE4OKValAlTAKUg3Q9s86puI0GGsLK3QqOarbMcyvMcrJUSHzi?=
 =?us-ascii?Q?SWKGDM3mX/sHI7r1FvVUITzj0s0Vn7/P+dHkj072h7QZg/QyzyfJ+kQBunsd?=
 =?us-ascii?Q?SdGfbZEO8YgYtItNPFviGp1x5N81tA91mnBrwklVIx78dKNxziWY2K7Jm+of?=
 =?us-ascii?Q?bW2LPygvzSbGspV4XDTYhSGZLSQHEx2mW/EoTfZDALWSw9WBb2QoGjE4K3JM?=
 =?us-ascii?Q?Gk190vnin936QoWNb489fJD8Ar2pqczU/tWtobjxUbPO+t+JFP3HNoEg1HAD?=
 =?us-ascii?Q?Y5hTsvGQWtfNH6UO/Nv/hVkDeNkgBU9T1QKVnoc6lyi9aQiUqxxn1h03aJrt?=
 =?us-ascii?Q?zxdttk64fAMDRP9Tx/uy2s33uigEQrchCaaR16rvC/gEtcJYzFPvV4fxQs5q?=
 =?us-ascii?Q?bFqoK7+nUQCjhKiIhklfpqzoBqBfTuYucWNIs5sdW0xjbJjBoMJ3keBKEeVZ?=
 =?us-ascii?Q?wNdSEZ9sNU8h3T9KNl+bEIPN8xfPOVpCiWLcsZfLhWX27Ei0VbEP64CMQiSb?=
 =?us-ascii?Q?LTfDL92LfqzcqFID7atgr2Lh/1JUgUMUg59pDjQuVz5F2QDqkADDnG4L0u7X?=
 =?us-ascii?Q?DfkknqjTEUijvkMU3ZblLnYHEVPebOgCqrRXqfKYHr803urkeVOasjHS2njg?=
 =?us-ascii?Q?Y4y9LocEaTVG5coRbTEv0ibe66VLvjG9XyaX5Im47SB8RiTM+X8tZsWzX/ml?=
 =?us-ascii?Q?BK1bv0ZxXblRz8LTalpsgJaYLtrnv2rF0bExQ+p1av2figg94/mZk4/TQD0r?=
 =?us-ascii?Q?YCA8p6/Huw=3D=3D?=
X-Exchange-RoutingPolicyChecked: PXilt8OgSuUejZRxTFUFI7KVmpgBtrakM8nc67wa2KdxpEaFrHqcYaEN8wk6vpinJP6rNsjkJaFKNG4JTlf8iwMWKL3XR+9qhKvYICFx0/Cx7bz5HDEEh7agPcZiL7gBz7poLPzSuKXfLLZsxiT5EJXKOHoQfcgreQm+4R8B66kKb6a57jXn9BUrMiYofBXBpjau4haom3XXbbENHsGHrWtNplOtnImMtgSAMsy00hXLcEy4Avz6kGjmVTzrxGAbWQsZ32ngk81N4VKtsXfemU85s7pGm9SjcxGUqXrVa9cs29g77iTXGDBMd8lcUqEmBX1XfAcx9G4zsSDMa63r+A==
X-MS-Exchange-CrossTenant-Network-Message-Id: a2207427-c5f4-4870-ce3b-08ded2582081
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7468.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 01:21:48.2554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zTUbI2yk+s15UoVc2CCzrx07BstD3rGlb5Bw+8ALRaBODx9cTlz52yqHSKj6ImTKUDvLhk3pyOTP7enAATk6JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB9825
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E195D100002
X-Rspam-User: 
X-Stat-Signature: ca9tebiauk8osydi4ep5se36nc41hcis
X-HE-Tag: 1782350514-739597
X-HE-Meta: U2FsdGVkX1/RY59ZRb6ZKueFitkfgZ0gixDtSw8pirUCMnY3MkTB5lbcvfAmsd+e2247jgVXENapxBQR1fh3uxPOF1d9Hu1+kyy3vT+UA4LjMoNvwoZUm1opjF9GUuzkpCZRfkjKl9sDfIRwED2vFgGxu2fxK6wiidOdQZ6yK4MLtPu3icePGctn/eZW0eh9WcSX15XHnwfzEOjx9TyDKXlKv1DIE6Or1E1yJUNuQQE/UREwo92aTXeUfUsvmH6apFiSssPPjYcjF43bF4QzBwdxf/MO1tJKlu+78lEsEKN5fjZFL+Od6zBm0sW1Wd7GeQ7HF3SwL/TCZ2jnx9GKdyCVKUQnJ9Co3oBhtVUgzkEpsNiDBekmOQrx8mI0vIU5k5b0pULU+/xjdXWRQmrhk8be8YkbQuqY/W4wX2YMw9SwHdgWsNoyMZr1dMMLXRmeh27KlXESVVohPyX/kNeoFrIgu5L75OY2aZukyI4zwDohYMkS0lxjtvqKEnKxCm+h8EdY9GfKDQyZwqbs0CYpaKlkoQ9DGXSryZGFkysBSCn2NtLbW+ng1RF5horK2ouXnQu3R4/8V4Y5yL99yH0mAjPA5LLKCp9mSSYkxpofK2wjdx8X3p/GDxviKkhduN1R1N/4Lv8Hd8TKrUOLINzT9i6gaGjawuAa1PM8dg7gOTPy5p0EetxrGvduAfP+v1CALGJjDsQRUE25svOKie6WiStaEhCddHeUnJ4at80ZkN3lQzpJ0Qs2pXDYI0aIKo3uQ31+//CjPRTskEAbY9uQIrELzk92Sv+toKj8NYVBgQUKFq33iL2XV1NNbK9fjQ9MYVcBTtRWO9v87VzFx6fMvYjfYSCEiYT0ZXHQvoaTVohke+QuRpDEupRs0NyfZfcnEc4YqH23sYfFMdjDI3K/vj2yoA3MVFAihuXd63mEkQISqe1cBDEx7uyWd8nDnWm6jB1/DRzbWprQ9Tmov1t
 aFhAWDyz
 wdK+ASGUSEiYKq+9bb77d+h6RdocjCEPm/4VgA4RoWZpOdf9VgqncfPo2FiNP+PEPtyVRA402I31jTBcHqcMMlmHKO2UkTWTYaYjjr57s2GH9f/O/pLBBy5eU7xxYvkzotoxnWBFvn9EG8QSOV4+rfaQ7GpocEH/JY3XiLuiE3gZ3eIZnullXa+KBtAPhUipSJU0/OR2mKq3bFzrz77W2O7tFIMq2rmmHdKyr9ARM+GhCrms/MGZSUUmBWRZFsPMSfKjlDSdl8ayW74qqa9XpmK1fT8M0vBneWGNo6h+aO8vHKpQVwOhrcB5Jrw0zlJiA3KR8Kq6Jm2Wqlm7BrKV6Ofc+cRfnRgWUmGCe0Ro3JPwK+yrcgXTdpmNDgU9ofaM5ca14pc9LjjdEyfxxk+QpQGK/um6n1OqZykA1VkjDankqs3KvDQXS3LbW1FTfwfhXNUctOiL0JuEvl54UTrMvjUwD2txFEQzsVT1TzgiwXbnXka7bjA07Td5H6sUqmR1lvTi7L0xQq9mIDMOJRp3DUTH0M2k9c16RssLur0mdVBmGB2oWX22KEvuaNzfyIGhzVmdu/GFRGxSsMMRCJg0VNlJQf5qnTQ0PC6N2H7EeBDiHvwtfFMNLNs+o8DK/YkRqoDowBo0N3vjt1E2gVTJwiQjrTAfMl54cgYEcE3rr4nHwF5IZMzJWTyv6Pom6WjNfxzbC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 05:05:44PM -0700, Ackerley Tng wrote:
> Yan Zhao <yan.y.zhao@intel.com> writes:
> 
> >
> > [...snip...]
> >
> >>
> >>  #ifdef kvm_arch_has_private_mem
> >> -bool __ro_after_init gmem_in_place_conversion = false;
> >> +bool __ro_after_init gmem_in_place_conversion = !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES);
> >> +module_param(gmem_in_place_conversion, bool, 0444);
> >
> > With gmem_in_place_conversion=true, userspace can create guest_memfd without the
> > MMAP flag. In such cases, shared memory is allocated from different backends.
> > This means this module parameter only enables per-gmem memory attribute and does
> > not guarantee that gmem in-place conversion will actually occur.
> >
> > To avoid confusion, could we rename this module parameter to something more
> > accurate, such as gmem_memory_attribute?
> >
> 
> I asked Sean about this after getting some fixes off list. Sean said
> gmem_in_place_conversion is named for a host admin to use, and something
> like gmem_memory_attributes is too much implementation details for the
> admin.
Thanks for this background.

Some more context on why I'm asking:

Currently, I'm testing TDX huge pages with the following two gmem components:
1. The gmem memory attribute in this gmem in-place conversion v8.
2. The gmem 2MB from buddy allocator. (for development/testing only). 

The gmem 2MB from buddy allocator allocates 2MB folios from buddy for private
memory, while shared memory is allocated from a different backend.
(To avoid fragmentation, only private mappings are split during private-to-shared
conversions. In this approach, the 2MB folios are always retained in the gmem
inode filemap cache without splitting.)

Since shared memory is not allocated from gmem, there're no in-place conversions.
The reason I'm using "gmem memory attribute" is that the per-VM attribute is
being deprecated, as suggested by Sean [1].

Besides my current usage, there may be other scenarios where gmem memory
attributes is preferred without allocating shared memory from gmem.
(e.g., PAGE.ADD from a temp extra shared source memory).

For such use cases, I'm concerns that the admins may find it confusing if they
enable gmem_in_place_conversion but still observe extra memory consumptions for
shared memory.

[1] https://lore.kernel.org/kvm/aWmEegVP_A613WIr@google.com/

> Sean, would you reconsider since Yan also asked? If the admin compiled
> the kernel knowing what CONFIG_KVM_VM_MEMORY_ATTRIBUTES means, then the
> admin would also be able to use a param like gmem_memory_attributes?
> 
> There's the additional benefit that the similar naming aids in
> understanding for both the admin and software engineers.
> 
> Either way, in the next revision, I'll also add this documentation for
> this module_param:
> 
>   Setting the module parameter gmem_in_place_conversion to true will
>   enable the KVM_SET_MEMORY_ATTRIBUTES2 guest_memfd ioctl and disables
>   the KVM_SET_MEMORY_ATTRIBUTES VM ioctl. If gmem_in_place_conversion is
>   true, the private/shared attribute will be tracked per-guest_memfd
>   instead of per-VM.
> 
> Let me know what y'all think of the wording!
> 
> >>
> >> [...snip...]
> >>

