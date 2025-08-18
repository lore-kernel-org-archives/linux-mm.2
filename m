Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E343FCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 05:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 585596B00C5; Mon, 18 Aug 2025 01:49:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D6A6B00C7; Mon, 18 Aug 2025 01:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE296B00C8; Mon, 18 Aug 2025 01:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2AA466B00C5
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 01:49:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A14B7C07AF
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:49:02 +0000 (UTC)
X-FDA: 83788799724.18.F84DBB1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5E9E480004
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:48:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=h84m0fh9;
	spf=pass (imf02.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755496139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YdUmjFmdtMqR+CA7VMMWRCXE8ju5dYfC+FsDVb69klE=;
	b=ag9D1xjYFhV9GpLrQBkn4kkoCe1iWkc5AyaInTpc64Hgex2f005lps+GqGYAZLFCW3/C5h
	gR26aQWaCt5XMCdD5BdQwW/69eGLxZInNFBe7tLFR6Az1O3ZdzyhAVVihx24DCZVwE0HNU
	M4v0MOZwxGYAqx9uY/EkdL1ujiRV2n8=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=h84m0fh9;
	spf=pass (imf02.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755496139; a=rsa-sha256;
	cv=fail;
	b=xYFYsdXxif2qmR7z6c+5Znp/pAUHWfrUTNqL5ljmMt2MgFSu+sKvnbcaEKVv0KbaSE5JAc
	5TPdeLulM3YrK55RV9f/bUCwtjEFt0RLTPO3vw/0QbYrav7TC8dnSgrSwT9xANgeByvGAJ
	4fug2aMfV8jOk2JQYwJ92EFX0OvSkLo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755496139; x=1787032139;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Kn8EBSG83tCsyqEmCQtqM/0/FAmA20Chvg2IX7P/avI=;
  b=h84m0fh9uGzXQIxk1qkVccqapy/kf3LhFrw+sBfAqiPfVhQOZQzmdC9p
   E1v1LpFZX47fV8wwMH3T+NJDeTtXf6ot2xmaDb/9JApYPul+CDYo9gfkz
   Os7HiXT/FBbfD1/fpWKQ64Omuh8EQyEp1xH1BqHHVJhCxHi36mNsmVCnS
   /WFbYkwV2s1jtnJYGWgCcphlg1xiTVGQxnrH016cxgpbnhE3HSjpG91v4
   r32O/IM+nf8DF7YYKms0Y15FkqOedSGaWFCfY9a+NdAdnSOL//K9Hv5lh
   QwLuE6GtK1b08PYq+yGYe9iNC/CUvPKWlJ8ZUvk+rNmCGyMPQYusCt4Yx
   w==;
X-CSE-ConnectionGUID: vqYE9RH/Rs2wsWgRH2xF7Q==
X-CSE-MsgGUID: A2V2V/HaRSKP6fnHVCzLbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="56740625"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="56740625"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2025 22:48:56 -0700
X-CSE-ConnectionGUID: 7F1Aqh9URgKZ57e6ZER3EA==
X-CSE-MsgGUID: Lo8bMffcSk+JaDOAKQTJSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="166718654"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2025 22:48:55 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 17 Aug 2025 22:48:54 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 17 Aug 2025 22:48:54 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.58)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 17 Aug 2025 22:48:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MuIFG9EmIFday4lcIL0eGsi+CHfpQEZfUYc+Cor6rhEega/EWrEzN8kzzFcLX8+pKPI2Cnzj2S72p6Bo8pwhQSZgbk225MLYiMmrn62QvAFrsAP8zZM007IkBfIspb/VN+sS1RB6wZ2Vgx0oH0xLr58+Mm7X7nZSmQco8RWLZs8+9GVyU6WMV/8UQzDpKwmh14mt5FeKeq0KVYCNIuufrZt6tlCQS8PWQQy8swliOFmcCa5SjAALrt3ke1t8ll0TcskRNORPYsMlBpWzH0jz5kjKeI/RSCPJThsrbnSWNCnR5EpJEW9priBtuKKGL0VAc879FF6rNFeXdVu/VrsaWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=496JEvK9IiuMJA+AnA57foYZDwfNly1U/h8UhaR1Ox0=;
 b=is/WycuBpkUByW0QOxkqt9rFFsjib7iKHwYtU6smB/Wskb4RoqhNR5jhNoYgNqNKlCesK2k/Crtffkk3xYqNa8w95nPNfIUVg/3n5rPoW+Un3g8SlP0XeIV4vZFhx7GMzCyPshWetqU91sD1fgl9HcImg3tD3uJbFqiGf5DlokX3Tq/WSTojsTOMn5eDZJcYmek0yy7nMtQBnLYjWSAawk9f2xmZcrtrV3XDumhYrpXsDKc8GSOfJ/ugxB3e6rVfMpVjAzV87Rk7d40L1l0s0yhgQNF5KDZ4pW6Zp0uZF/8owKpWWPI/qeADRCNcHUl48bC3Cewn7XYjvkuYnu1adg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3934.namprd11.prod.outlook.com (2603:10b6:208:152::20)
 by CH0PR11MB8087.namprd11.prod.outlook.com (2603:10b6:610:187::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 05:48:51 +0000
Received: from MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2]) by MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2%6]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 05:48:50 +0000
Date: Mon, 18 Aug 2025 07:47:09 +0200
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: Mike Rapoport <rppt@kernel.org>
CC: <nathan@kernel.org>, <arnd@arndb.de>, <broonie@kernel.org>,
	<Liam.Howlett@oracle.com>, <urezki@gmail.com>, <will@kernel.org>,
	<kaleshsingh@google.com>, <leitao@debian.org>, <coxu@redhat.com>,
	<surenb@google.com>, <akpm@linux-foundation.org>, <luto@kernel.org>,
	<jpoimboe@kernel.org>, <changyuanl@google.com>, <hpa@zytor.com>,
	<dvyukov@google.com>, <kas@kernel.org>, <corbet@lwn.net>,
	<vincenzo.frascino@arm.com>, <smostafa@google.com>,
	<nick.desaulniers+lkml@gmail.com>, <morbo@google.com>,
	<andreyknvl@gmail.com>, <alexander.shishkin@linux.intel.com>,
	<thiago.bauermann@linaro.org>, <catalin.marinas@arm.com>,
	<ryabinin.a.a@gmail.com>, <jan.kiszka@siemens.com>, <jbohac@suse.cz>,
	<dan.j.williams@intel.com>, <joel.granados@kernel.org>, <baohua@kernel.org>,
	<kevin.brodsky@arm.com>, <nicolas.schier@linux.dev>, <pcc@google.com>,
	<andriy.shevchenko@linux.intel.com>, <wei.liu@kernel.org>, <bp@alien8.de>,
	<ada.coupriediaz@arm.com>, <xin@zytor.com>, <pankaj.gupta@amd.com>,
	<vbabka@suse.cz>, <glider@google.com>, <jgross@suse.com>, <kees@kernel.org>,
	<jhubbard@nvidia.com>, <joey.gouly@arm.com>, <ardb@kernel.org>,
	<thuth@redhat.com>, <pasha.tatashin@soleen.com>,
	<kristina.martsenko@arm.com>, <bigeasy@linutronix.de>,
	<lorenzo.stoakes@oracle.com>, <jason.andryuk@amd.com>, <david@redhat.com>,
	<graf@amazon.com>, <wangkefeng.wang@huawei.com>, <ziy@nvidia.com>,
	<mark.rutland@arm.com>, <dave.hansen@linux.intel.com>,
	<samuel.holland@sifive.com>, <kbingham@kernel.org>,
	<trintaeoitogc@gmail.com>, <scott@os.amperecomputing.com>,
	<justinstitt@google.com>, <kuan-ying.lee@canonical.com>, <maz@kernel.org>,
	<tglx@linutronix.de>, <samitolvanen@google.com>, <mhocko@suse.com>,
	<nunodasneves@linux.microsoft.com>, <brgerst@gmail.com>,
	<willy@infradead.org>, <ubizjak@gmail.com>, <peterz@infradead.org>,
	<mingo@redhat.com>, <sohil.mehta@intel.com>, <linux-mm@kvack.org>,
	<linux-kbuild@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<x86@kernel.org>, <llvm@lists.linux.dev>, <kasan-dev@googlegroups.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 07/18] mm: x86: Untag addresses in EXECMEM_ROX related
 pointer arithmetic
Message-ID: <5i5x54pntwjhpmalenhemyra5ybnqrransk5leukpmj3o53e6l@jgjiy4ycduhz>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
 <aa501a8133ee0f336dc9f905fdc3453d964109ed.1755004923.git.maciej.wieczor-retman@intel.com>
 <aJ2Pm2XzcM3H4aTN@kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aJ2Pm2XzcM3H4aTN@kernel.org>
X-ClientProxiedBy: DU7PR01CA0026.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50e::22) To MN2PR11MB3934.namprd11.prod.outlook.com
 (2603:10b6:208:152::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3934:EE_|CH0PR11MB8087:EE_
X-MS-Office365-Filtering-Correlation-Id: 6eebce60-6654-4aa8-7912-08ddde1ae862
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?0Qc2OeMSq3U1zgCYrlCVtdEhwt9fi7xfR8+JhlvYCbVqDK2xYUmJOknn80?=
 =?iso-8859-1?Q?8hU8vbLLOfsN2gAjwOEBPY06/AlAfeKMsTyaE7/+zrwu7G2Sdp/IQYSyiD?=
 =?iso-8859-1?Q?oD+qH/WgXFZF65qrLquSLnJUEjXHQ08a9jxPbkbTY80aujKVevm5XAJQb4?=
 =?iso-8859-1?Q?dLkzBfWr812yj62c7iR9fNeE/95Ds26WCyFYLmtzUfgSXpHRo9sQQte43s?=
 =?iso-8859-1?Q?A0WLjWtOkFUsCIaiQi33peazR7yj8oX9oS4ufmV3ysyIN8xa6BOdz2Rj8X?=
 =?iso-8859-1?Q?NGYoM+mIwUV7qs51WHbRi1bIS6J3Vo53+UKX/jxWiknbwwrmhGPsUlfKD3?=
 =?iso-8859-1?Q?6M0gEQPEpVYt77wQ7ZawuUFgKz6I4c9ZgdcvA6cWDkVoETEoqdymIK5VRF?=
 =?iso-8859-1?Q?7Fl5B+4TkkdjSjIlg0SND7/Oqa/K3CNzdFUsZhjhuKIwP5dNE7LVy5243f?=
 =?iso-8859-1?Q?qlGTLIG1CAYPKLyCUDuR7E/ptjpV857uttdvCh6kFaKh5oP58XA/aWgxun?=
 =?iso-8859-1?Q?2Zm5EXFeicWTHnQrpSBO8nFnt6sDjrt4qPvYQkxVpq1Qn+mfW2Ic/nlCXJ?=
 =?iso-8859-1?Q?YLETH1sFxPpzSJwdC5BNDti0456dngmZwxZakeH3jpcs4TTIqP9ohdeMwA?=
 =?iso-8859-1?Q?U64WrwbSlFamCst9zPVcy+yvTkM7Ub5qgdGtWDDvlAyiVaOmhOMjN9bECP?=
 =?iso-8859-1?Q?kSmHcJjNl8Y1R6mhGCjGJ7OqiGrmNJhlMFElpAacUNSIdvB7V4U4j1zKFv?=
 =?iso-8859-1?Q?4wPReegCbh6pTYybEiXBGTXYZ+UFxhQ8yUycnywWQSDYnbs33GonPbl9uB?=
 =?iso-8859-1?Q?nr0Qd/p1zJOzPQNoYpmTGvlgqhcvhHbh+4+AWcE9nLgW24eCH4KBSimb0K?=
 =?iso-8859-1?Q?aMaGOGSr+LjL5ybd8/io2geIIi7ZeVIOUpuCb+TAEJopgNPKy6tVqaJ1MM?=
 =?iso-8859-1?Q?Niio/tHwYaeJFHBupaycdDVQvONFyTlUO1Vw3IX43XuQMnHTnPAMiH5Z8j?=
 =?iso-8859-1?Q?OMEeC31W01laDJ3JDWwZ98QvUOWVZLefJTCat0CbtJivxF1LH8jyBmmL3O?=
 =?iso-8859-1?Q?VYnrpghZ9Sxo2/xPwJK9EGsQzX/koMlUMDXkH0ln3+W51Jbbe+z+2zEHvK?=
 =?iso-8859-1?Q?YVApb4ONUadbrXEhTZ1h/qdTk20t57HkBmPncPII1THC4rb6lPdAc3vpYr?=
 =?iso-8859-1?Q?F9/ObjaHnYzyQt34Ks9o8duvKEJeVoPHABvWTRcO3R75VLy4ZhviW/NRLp?=
 =?iso-8859-1?Q?PaebT87S0SAafA8W0sAQ6S4ZLm/OrutJ/zlGWq4S1H1qjsYTkDveP3P3O1?=
 =?iso-8859-1?Q?uk8WcDA9eYlySaPNPkPlSqIkVz/MPGaCLGsY0o1+QYBoeqfW2q4Y3kS3wJ?=
 =?iso-8859-1?Q?AJFJkvADFyWtbfmYfqA5VJac3zkPlcCV9Z/io8oo3AegxbBHNJl9kjD3sX?=
 =?iso-8859-1?Q?INFIdY0FNwuKW7w6lh4Dg1BLeBnyuboXKbFwsct1RJ4fKAkDix1m5HG7xn?=
 =?iso-8859-1?Q?8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3934.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?dUPl7vQwKSlHCp4mrNBmviNz3mnEEKXEE4A9VoqcxNj3mytmceznX1G8Kr?=
 =?iso-8859-1?Q?gs1L0lCtO75XLPhE6ubmw09peUaKdqlWKsntLWSZCaerxfvasE94H8+X/v?=
 =?iso-8859-1?Q?2DXBJ24b5k7DDDIihdVrujFW1jSrlJMb0q/bINr4YIca1wQpFlvqdAJZdT?=
 =?iso-8859-1?Q?SryzS9pSAwbZ9IJqFFMJ6S2+thftGGjwJpENnwi6I5NrPPUEpsLHqUc4CV?=
 =?iso-8859-1?Q?WScMG/tC5WZ+5mhqH6oJyQIMQy7h6TZNmFxvPa8H89IXk3nl74SD96mkWX?=
 =?iso-8859-1?Q?X7DDmLv04MtXVPJILDv2noQ1w0edZPr4FDS9LnbLDr6H9W1uZHVyRqFApk?=
 =?iso-8859-1?Q?hy/wrz9yqj4bO9NeeP79PvR79OY6rAyDteXkvgLHpOKGeewDayb1WfrSNg?=
 =?iso-8859-1?Q?Dn1rHjClM5eOICrEq+q9Fp3Xx0lihpdD4xz+Fch9zg2jwG/C3iB6F2gSh4?=
 =?iso-8859-1?Q?IG8BZP+XsxSOVNhahwGaA+bwLL34FInxmqcLCsrRwvk/WmiKuRctGhb1z9?=
 =?iso-8859-1?Q?1btPLY9NvUT52p4wMRhg+MjqSFC1Ag+TtmpIzftslO6liAHQxuyl5XJEyg?=
 =?iso-8859-1?Q?+NXFDHx6OGIww7Pg7PQ6Xbss7zs3BmisVPRj3RGEdTCmxdlojuVP8SYro0?=
 =?iso-8859-1?Q?Vq5l2+Yc5Nj4CfBE8NDrkRvxl4lenZULWGConmiSMsXwQg7NVqEjEBh9qE?=
 =?iso-8859-1?Q?SvgrmQjh7zTed966A6YLVqKwAIoRjmBSWKw+uwAo+wwHOjrb2BXkLsZFLi?=
 =?iso-8859-1?Q?KRuWm/KgNZB/CcKjPLjI6eWN6TzZ8YShVLUA81LeQPovreIVccf4qemJDs?=
 =?iso-8859-1?Q?xWh9QnWerDMMQtDPhkoVb8gLFdbNfQ994Bj1qOfhP56MCZRWS5j+quhm2p?=
 =?iso-8859-1?Q?m4xuZQJN9RQ/gJMxiy3S3K9JZCiK20op61sbtgZlRAWzKdl4cmQWeVqi6k?=
 =?iso-8859-1?Q?jjZiLPiwpiIDd+BzDKnyk2pesE+/c7C9mqq4+n9PFJZWEGuKz8k/XRoavp?=
 =?iso-8859-1?Q?RkodIWdoGcbz+8QtTOMMNlb4kZkoVl6yLGlj/ALfJX/7xL+9l6QLcBuVzR?=
 =?iso-8859-1?Q?rAANRx3pKAOyU/U4m75FfGb3vRii1enDajvvVdtY/aWWZOQNp/mNBlfXdP?=
 =?iso-8859-1?Q?nWf9IhbQ1dPshpga+PGlyuGocCpKvkz8pdVFbYqf7hYiTKTfzWkXEgwv6j?=
 =?iso-8859-1?Q?Kv0MhN+Vyq1wwTS0NxpQPK0GBF9tKHUhUPjz4QyTdjxFRO5U5PZQJrYfnN?=
 =?iso-8859-1?Q?9bBQarPGj0MUkpqseFY7Mzwql4KWZUxthn4ZOsJkh/IwILF0f/fon/0MLa?=
 =?iso-8859-1?Q?y1wr5EA2KeYfClvU4vZcEkN6fjdSwbG+A8gD/8qicl+oyEzaclOj3+j4vB?=
 =?iso-8859-1?Q?H1otSNdbyqmSz6sniFJp9/lfQql4XOR5o+Mp8dWMFDrWtGSjhm7rEQ0zC2?=
 =?iso-8859-1?Q?O3W2EVOrBADgr3ld0eDZG7cjx9U4OGgQRAhO/B/WrFvQmf8gy4tj7sDd7V?=
 =?iso-8859-1?Q?C13smeX2K6zGkc0p1iVmHGbIgDuINv8ze37W0rhK2bVTwQIk6gNu8c9TiZ?=
 =?iso-8859-1?Q?WC3Zc6RarTb4FqFqCBDxOhQRdEcGl9RpCSGIaXbcj8BBpAM1DU0spN4mEr?=
 =?iso-8859-1?Q?bC62QcklCkiF18h+LxnRhx4JSLlmpF925u1tQ28rkKBaWt55MzDNuh76sz?=
 =?iso-8859-1?Q?Ur/8ze8IyZ+t7RhXGCo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eebce60-6654-4aa8-7912-08ddde1ae862
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3934.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 05:48:50.7832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cJ0LR1H7cizuKmGManYTD4AC8VXFJuPlhALO0+ogJ1gLcE8FQdPjD5DRliyav1B0BZrzBaS1mmFRpkX1NAPfHcIhmhZ5sNVuxMwC8saeU1Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8087
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 5E9E480004
X-Rspam-User: 
X-Stat-Signature: mwopknkmpmmzdtjhdbdkioqotgpkciqx
X-Rspamd-Server: rspam09
X-HE-Tag: 1755496138-926481
X-HE-Meta: U2FsdGVkX18VXf/FXK27t660lVqur13YlE2XZFWR5IkTf+2eMNDgLaYwlr743bPXxUbrVU9rqMZueCidV87bcTDF70Q2ErPJ1/poHkwk6Ne9fxH8YlKejCBRfAJ1ouodI9Wri8FVKvimdcMa45BbcIEOj/FOyeNsemnPEAQ8oftoFCKMCyu9QatuJo7SlsDRL2H4Jx0zhcE4xdeTLArZtZ0kdZSPvFzLRcUOEsWXvFmU7NWCzTNA0gf91R92DML8OLh2nR0j9NjfWdWIlryAFtfouIfVN/eyaka0niC72nhHUzpap8PhDRkOQlZDgzXgt2WIWYkiqdm5tZG2uXXJVJl5MtykQPGtLrWyDs8AMCmfMf3zqn7hUB3cI95qp2a7uU2QvES8WpYGzSsmIyo1DMWDh8Dr0VlPLcUvEP4p1r4DfpOwUDTtXdkUGP5Yc7CS/3eB3E/hC94TWEAzcGHbs1/TGq46a2SZXsCKC6NsQk+/fERN3OdB4Ye+RHturL16byBPpa6L3c0faUYt+qGA7cMj//iEFjCWt+eXrTWHbZlP0+VkVy8rO13vkPmBDVl/EdxGyAKkpXX29dbLuGARZiGl7udPV7aR5vSdP8AoVaFYdBxlcLGo+HTMQSraR8m70/58n43VQHUnDr1gn+d849h33cc3fn+0mglipKFpIu0QfrrV++pZM2pU44OEa/gcHC9bEp0ANGs+D9CkuzW2lVjhs0Li1EWqAQjLXZ4oKmF5zm9qiHaQcaeB9wVFx3UA2S4bzUUL91qSWZcz58BDifR1lTG4vy9RUz0Czzba9cQnAWSZRrxcunLmguKgWpr0wopdlIVtnz4uv5rcWV3jrw5cN8ojjMVAMKqW17d40tq+IKZM6M/K2U5bEJ3KiBQJPaaggi8DFKpa33G6aobHeOuFb/y1i5GDsfOK5Pd98pKQmt+Gm+A5BUDASmYECS0Yq5lSi7t5fiLi1qDolnr
 sVlpoLVr
 l9t4y26+zXko3Y7AxDvTvo8aZqSfDWZbua37UmngLoDTgLY5DoH4ZQYrdI59zCkTei8O3w022a63ofbk9qx4bbFxya4UoM9VTbB8uF/G07jFWLI6zqsxHRx/vOU+I+hyOR8a8WMg6C7wwMvLrQooFWVWB36skvdL0fKT6hRwlm24CGa+XDz+qvU8LCLrKOizampjZwfB2lsGikIf6cLHWch8/kwP1DlTWw95CNgk7FtCIEZecVGHTCj2QK2oze3EqsZkRxbO7060ycf0A2dr7dmZa+IwWdCK8py+avxROvqrWzX5Nw/R9SGg569gQVH76bDoI6pTz1zDt3TTvxmJ3jSJ0BkAZdzimuzQui1YxoEFanJ19Bup03pEVZbcevLuYN+7RMnwaUqwrXhrTFewEc6hrqWQuKdBQTDhD/XLmt+8+Z+aXNFtE4c8b3jbYo4VKsrFXoffuTziUhSLDQLRQ4FIFtKioCAwlLnc92IQ7g8FLO4f6dwTf00/Fcw12jM2u7TCC/ltZtKLJ0r6PAgazH683AgdSxuePPqu6FqWpg96jsbNwSKpP9BD6zTjTHU785TJu9ldSCMKOXT8fon/9TcI6Wq9wFqYo0501CbwAvbpsnteeGrI7jeY6bBazv7ZkxKfyWb97JBEo8sVDqhTkXHdoN+dVgh3DcJvUpA2qT1VgenRsEcb3yVWJd1+YmN6/qA2hl6dNjZCOa1f6CuAt4Odr7n+TvWlhkeA01Yfr5B55qPo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-08-14 at 10:26:19 +0300, Mike Rapoport wrote:
>On Tue, Aug 12, 2025 at 03:23:43PM +0200, Maciej Wieczor-Retman wrote:
>> ARCH_HAS_EXECMEM_ROX was re-enabled in x86 at Linux 6.14 release.
>> Related code has multiple spots where page virtual addresses end up used
>> as arguments in arithmetic operations. Combined with enabled tag-based
>> KASAN it can result in pointers that don't point where they should or
>> logical operations not giving expected results.
>> 
>> vm_reset_perms() calculates range's start and end addresses using min()
>> and max() functions. To do that it compares pointers but some are not
>> tagged - addr variable is, start and end variables aren't.
>> 
>> within() and within_range() can receive tagged addresses which get
>> compared to untagged start and end variables.
>> 
>> Reset tags in addresses used as function arguments in min(), max(),
>> within() and within_range().
>> 
>> execmem_cache_add() adds tagged pointers to a maple tree structure,
>> which then are incorrectly compared when walking the tree. That results
>> in different pointers being returned later and page permission violation
>> errors panicking the kernel.
>> 
>> Reset tag of the address range inserted into the maple tree inside
>> execmem_cache_add().
>> 
>> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>> ---
>> Changelog v4:
>> - Add patch to the series.
>> 
>>  arch/x86/mm/pat/set_memory.c | 1 +
>>  mm/execmem.c                 | 4 +++-
>>  mm/vmalloc.c                 | 4 ++--
>>  3 files changed, 6 insertions(+), 3 deletions(-)
>> 
>> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
>> index 8834c76f91c9..1f14a1297db0 100644
>> --- a/arch/x86/mm/pat/set_memory.c
>> +++ b/arch/x86/mm/pat/set_memory.c
>> @@ -222,6 +222,7 @@ static inline void cpa_inc_lp_preserved(int level) { }
>>  static inline int
>>  within(unsigned long addr, unsigned long start, unsigned long end)
>>  {
>> +	addr = (unsigned long)kasan_reset_tag((void *)addr);
>>  	return addr >= start && addr < end;
>>  }
>>  
>> diff --git a/mm/execmem.c b/mm/execmem.c
>> index 0822305413ec..743fa4a8c069 100644
>> --- a/mm/execmem.c
>> +++ b/mm/execmem.c
>> @@ -191,6 +191,8 @@ static int execmem_cache_add_locked(void *ptr, size_t size, gfp_t gfp_mask)
>>  	unsigned long lower, upper;
>>  	void *area = NULL;
>>  
>> +	addr = arch_kasan_reset_tag(addr);
>
>Shouldn't this use kasan_reset_tag()?
>And the calls below as well?

Yes, my mistake, the kernel bot pointed that out for me too :b.

>
>Also this can be done when addr is initialized 

Sure, I'll do that there.

>
>> +
>>  	lower = addr;
>>  	upper = addr + size - 1;
>>  
>> @@ -216,7 +218,7 @@ static int execmem_cache_add(void *ptr, size_t size, gfp_t gfp_mask)
>>  static bool within_range(struct execmem_range *range, struct ma_state *mas,
>>  			 size_t size)
>>  {
>> -	unsigned long addr = mas->index;
>> +	unsigned long addr = arch_kasan_reset_tag(mas->index);
>
>AFAIU, we use plain address without the tag as an index in
>execmem_cache_add(), so here mas->index will be a plain address as well

I'll recheck to make sure but I had some unspecific errors such as "page
permission violation". So I thought a page address must be picked incorrectly
somewhere due to tagging. After revising most places where there is pointer
arithmetic / comparisons and printing these addresses I found some were tagged
in within_range().

But I'll recheck if my other changes didn't make this line redundant. I added
this first which fixed some issues but then I found more which were fixed by
resetting addr in execmem_cache_add_locked().

>  
>>  	if (addr >= range->start && addr + size < range->end)
>>  		return true;
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 6dbcdceecae1..83d666e4837a 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -3328,8 +3328,8 @@ static void vm_reset_perms(struct vm_struct *area)
>>  			unsigned long page_size;
>>  
>>  			page_size = PAGE_SIZE << page_order;
>> -			start = min(addr, start);
>> -			end = max(addr + page_size, end);
>> +			start = min((unsigned long)arch_kasan_reset_tag(addr), start);
>> +			end = max((unsigned long)arch_kasan_reset_tag(addr) + page_size, end);
>>  			flush_dmap = 1;
>>  		}
>>  	}
>> -- 
>> 2.50.1
>> 
>
>-- 
>Sincerely yours,
>Mike.

-- 
Kind regards
Maciej Wieczór-Retman

