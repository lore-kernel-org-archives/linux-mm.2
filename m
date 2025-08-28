Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F557CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4CA18E0019; Thu, 28 Aug 2025 12:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9D3D8E000C; Thu, 28 Aug 2025 12:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A17078E0019; Thu, 28 Aug 2025 12:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F4C98E000C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:23:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 43CC183744
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:23:07 +0000 (UTC)
X-FDA: 83826685614.21.F1320B8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6C4A2C000B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:23:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jCc6TzVQ;
	spf=pass (imf22.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756398183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldZAXgC4Cmklrro27W4twvDznpcYB2GxO8AtAkUYRIU=;
	b=XjYYF44hJLTLoP/K2YwWoBCregDMyg/1GdrDW2DfHU7YcmNse6bEJRmR52gfOz8cFTinsY
	/PBP7Uim/CQNaGDZ93TTOeUGm9pVPP4MK/lmFvJPxwBf84DCFxIn/rmHXbkOsfYAeHOm/P
	dwc4VWKxgjYJHUYdGNt7BS2N/wFb8oE=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jCc6TzVQ;
	spf=pass (imf22.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756398183; a=rsa-sha256;
	cv=fail;
	b=nCYyUCRtUuEH694yZdHYEAN8We9j9gOhGOqGRX+YBe3WSM6D/xTl/ZuiymqcvYHRjK84gg
	jscY+CEVnr5ozdwX4v2XDjRyhESq7qKn9DoNdH3Oq7mSRn79XEkYeeCy+0mdP5zT5sNXFf
	5KFcOUg0naOVv7QP1a/HJjVRod+bJnA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756398182; x=1787934182;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=4sf5JRYJABAAAcdmbi24nvCB0Nqpc5BMN6SAbHZh8GU=;
  b=jCc6TzVQI6IT4CLvRgCi+SSyjqJ3dpxiSAbdoxUdX0xKX8HZ7J0+A53o
   sunw05YZVaw99ey4yTVDszUKkYeHr7yqEznaSZ3Qoni1JUkoDb6mXgm22
   aBuZF90wZ6Zu+fjjOF0ffyrH55tpv3ZFNeeJGtTUcqMWq9cY1kPtoBixq
   oGnm0jtlrN/Msv0FbUevEdHJUrkbQHV1P53O9CE/WfzbFslFKvU9tyv9D
   TAZpKl1SQDK9QbG+79Nr0y4Z4kq3eIg8+ccPrBi/j9BXr6cf20U1n2D8m
   0tUXTUmojjRotagHqwbjpxtN6/2nCOC+a9XnwRPHoJSx/0nSqcNfuvC0v
   g==;
X-CSE-ConnectionGUID: Pv5fMeYtSGm6k0w0QB4S/A==
X-CSE-MsgGUID: ShVyB/UySSKIUxpwEvd7zg==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="70114508"
X-IronPort-AV: E=Sophos;i="6.18,220,1751266800"; 
   d="scan'208";a="70114508"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:23:00 -0700
X-CSE-ConnectionGUID: /RkdbtyJSquvWyRRU2/rPA==
X-CSE-MsgGUID: c+Bmqq2pSdSniNE3ssVZVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,220,1751266800"; 
   d="scan'208";a="170066601"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:23:00 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 09:22:59 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 09:22:59 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.74)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 09:22:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fpDFPNl6VitZNIuFEZ16F/+fpgsakWu4NZA6Ap+Wmj7Vudic0cQaNckxywfpxzWWNReW4XMWdfb/LH6t7qYrjzF71qsANH8GXL+WRo5bPd/HdyPTV+AIwyXxMm9JpuwrssHWrq7PU+803D67sMVO0irbyLgZWyO3DYnrAFPJLVxPvgy/ntN7OQVUX2DVKtugBLtkrCnUf+jwJ0ywjwS50oIuYOE4GqLTyIzjxwsVc8ZaMGLZYP9yp0s6u6QZ0h6iKEHASG0nn8x9SzBgIOjqdg6czyK/HJ767VEfblVIDd3hZsNkvbBO7lHn/YD8AJAKQvfXwAHWw54xa3/ZOh5ARA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NY1E+HEpRudnoO5ALXqo3ZkeRafkLOj99owFq1zILhU=;
 b=oQzF7/Cr0jQmTZBFd3Vba0XgdjiLrdnYU0JKMvTgW4kjvdMTWPB1cux8GDE9+q5MtXRKwvhDzzWhtJ/hZOAxELPORzMp+dSanPNkWU7UWUwM29v7MaIQeZFsy2pgPnzEUh7qgKtpQiIAKH+1+2JBrkSlRjfY234Gy3LG9V4IINGfcIPhO4FdVM3iO82PgOtN+tFvyxF2qnn8OX6L9lhJYaIEhXVQSl5xmmn1nkocZvbXmJgxqz/+IAj2e2qJG57sGsr+d+S+kzIeB0AvgbMP/BNbE7Oz4Nb0sLr78f4Jf9mX4AlbC1/l/iPT3Eamgx00uN98toCO11EBQX3HVqm1nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3934.namprd11.prod.outlook.com (2603:10b6:208:152::20)
 by CY5PR11MB6162.namprd11.prod.outlook.com (2603:10b6:930:29::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.17; Thu, 28 Aug
 2025 16:22:48 +0000
Received: from MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2]) by MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2%6]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 16:22:48 +0000
Date: Thu, 28 Aug 2025 18:22:02 +0200
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: Mike Rapoport <rppt@kernel.org>
CC: <sohil.mehta@intel.com>, <baohua@kernel.org>, <david@redhat.com>,
	<kbingham@kernel.org>, <weixugc@google.com>, <Liam.Howlett@oracle.com>,
	<alexandre.chartre@oracle.com>, <kas@kernel.org>, <mark.rutland@arm.com>,
	<trintaeoitogc@gmail.com>, <axelrasmussen@google.com>, <yuanchu@google.com>,
	<joey.gouly@arm.com>, <samitolvanen@google.com>, <joel.granados@kernel.org>,
	<graf@amazon.com>, <vincenzo.frascino@arm.com>, <kees@kernel.org>,
	<ardb@kernel.org>, <thiago.bauermann@linaro.org>, <glider@google.com>,
	<thuth@redhat.com>, <kuan-ying.lee@canonical.com>,
	<pasha.tatashin@soleen.com>, <nick.desaulniers+lkml@gmail.com>,
	<vbabka@suse.cz>, <kaleshsingh@google.com>, <justinstitt@google.com>,
	<catalin.marinas@arm.com>, <alexander.shishkin@linux.intel.com>,
	<samuel.holland@sifive.com>, <dave.hansen@linux.intel.com>, <corbet@lwn.net>,
	<xin@zytor.com>, <dvyukov@google.com>, <tglx@linutronix.de>,
	<scott@os.amperecomputing.com>, <jason.andryuk@amd.com>, <morbo@google.com>,
	<nathan@kernel.org>, <lorenzo.stoakes@oracle.com>, <mingo@redhat.com>,
	<brgerst@gmail.com>, <kristina.martsenko@arm.com>, <bigeasy@linutronix.de>,
	<luto@kernel.org>, <jgross@suse.com>, <jpoimboe@kernel.org>,
	<urezki@gmail.com>, <mhocko@suse.com>, <ada.coupriediaz@arm.com>,
	<hpa@zytor.com>, <leitao@debian.org>, <peterz@infradead.org>,
	<wangkefeng.wang@huawei.com>, <surenb@google.com>, <ziy@nvidia.com>,
	<smostafa@google.com>, <ryabinin.a.a@gmail.com>, <ubizjak@gmail.com>,
	<jbohac@suse.cz>, <broonie@kernel.org>, <akpm@linux-foundation.org>,
	<guoweikang.kernel@gmail.com>, <pcc@google.com>, <jan.kiszka@siemens.com>,
	<nicolas.schier@linux.dev>, <will@kernel.org>, <andreyknvl@gmail.com>,
	<jhubbard@nvidia.com>, <bp@alien8.de>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-mm@kvack.org>, <llvm@lists.linux.dev>,
	<linux-kbuild@vger.kernel.org>, <kasan-dev@googlegroups.com>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 07/19] mm: x86: Untag addresses in EXECMEM_ROX related
 pointer arithmetic
Message-ID: <bfqimycwy35iilpjwvx7vtddnpkdrlzk6r4o37l7ro2mintcr3@tml6cbbum2w4>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <c773559ea60801f3a5ca01171ea2ac0f9b0da56a.1756151769.git.maciej.wieczor-retman@intel.com>
 <aLAmW-UV6hv9k1LT@kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aLAmW-UV6hv9k1LT@kernel.org>
X-ClientProxiedBy: DU7P251CA0028.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:10:551::12) To MN2PR11MB3934.namprd11.prod.outlook.com
 (2603:10b6:208:152::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3934:EE_|CY5PR11MB6162:EE_
X-MS-Office365-Filtering-Correlation-Id: db945b96-7571-4a51-e1fc-08dde64f2053
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?JbyeV051BmVnrDwuQyZ7ekPK/iGKhpRdKNceChpryL02yiLah9txI2X07U?=
 =?iso-8859-1?Q?XnLGFby9zh8MAhxQD/2J6b+bbDfx6FHycNiemRAzoVUm8yDJG021EeujS3?=
 =?iso-8859-1?Q?GuILaNvCTFITB6Bazy2aQdcOh5ds1ymmZ9+Czpl7Hl2MCrCdWoCf++ogwg?=
 =?iso-8859-1?Q?afTe8zkjMrNpGticwXrhnLJx2NsYSxqZAx0JdoFwwDjD0LXUZ0Qr7vvs3w?=
 =?iso-8859-1?Q?exRk8QQC1gTOdB6twTA8REZA1PwZOUDyr4p3oMGIs9LvfDZQuNkC9jNjtC?=
 =?iso-8859-1?Q?3kXAEZ9VDPT+e/x+m+1s30w8K3+3p/Xcw4J6dbTLl+iv1hPxL3ivRg+B4+?=
 =?iso-8859-1?Q?M+gji6q/uT6lqfb9NXJDrE8J0mjJSDiYP+5YBrqHCBJaeAJu5D+Uq4XtiY?=
 =?iso-8859-1?Q?JLjCa1jSZn971Cmw8LWMoNZu/6ZzGR7lr9JF7lQweBhc0w7i9lUq/g3eq1?=
 =?iso-8859-1?Q?aelcJflmyIr1LeW4Ruc386e7GbFzMpIjycAHTfxRzWCFXLW8hs0lk+Ar/H?=
 =?iso-8859-1?Q?aqwu3wJR0OzIwUQWiYmaoSdfbt+QqhJ0dRflJSyj1RtpsUbED2PGuVB0a8?=
 =?iso-8859-1?Q?tki76qgFp3yxnVo2iss4ZusdLLjtZBfLSv9zIATMAlpk4l471ZjFDzxm97?=
 =?iso-8859-1?Q?7C+/jXB1w1k5b/8LF9y1zFZdiHpYRO8vOyrRPY+Qn9VyUKjWX1W5FSYWpd?=
 =?iso-8859-1?Q?+BNpM7HTmX2nHKaE1vm945bM2EESUCW72aeH2LOfmMgfAB21hX9TFF6th9?=
 =?iso-8859-1?Q?kLdRK37PwbhQ+1Xq9CVGc9hrrNUs5OF20JhJ0JkbO9DRWbmxi4uAIpAJwa?=
 =?iso-8859-1?Q?IOlWGfJcFyaEZFX8dYKA+Qwr2sI5KPteTDBNILyvy7yX0PyfcRVe4o5ozK?=
 =?iso-8859-1?Q?ex+rCsJZAG1pWqlsmgB47E0wCKY1h0tqGFiYWu7bItZUb72Z28bfWEd60o?=
 =?iso-8859-1?Q?gYgzwbSjJxVHExOTh1u3YUa/35yduFQ//AOoRgsuEBC2Pe//SSCwpSfeTZ?=
 =?iso-8859-1?Q?bvHB0D2MraTiECWW90oWiPxrHNO1slZljaJWhtW0aD8IiBMUxjteXZpBeR?=
 =?iso-8859-1?Q?P/+3N3yWg56MftHXsUTYgu+MSw8eMFN5fjpZioIXodIHtzxl3xB1VutqGM?=
 =?iso-8859-1?Q?T28X2+t080/Pb5+qFaKJX1tcYJeTI6SfxVsxmSIebnUbPLVpS+TewEpLL1?=
 =?iso-8859-1?Q?myOfdI7+DaZplOxAiECBf4XnsHqcU5c7zQyxllK9HZ/JIR2AsAWBD7/ff3?=
 =?iso-8859-1?Q?6z8P07dvHFBCugJTczvuer8xXn0z5wcN0gmUFijJVOpaoaI+FJX9oVP98a?=
 =?iso-8859-1?Q?1vuz0M5+4stHLzeFxtNUSOYoGa5t4uU6QicryD8N8Si+nAd1I4a7MfHlb8?=
 =?iso-8859-1?Q?JbcSa5oijRVpZYUDbuCTgYULW2iAfq7VdzDdEn3/Mmoaas1t3k7tdQ/wgI?=
 =?iso-8859-1?Q?GVybPi4XsAGQAN3IRMQ711BAgZ9MQu/k2QGWrPaWsrvzuX6sRByGT/HT3p?=
 =?iso-8859-1?Q?I=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3934.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?L9bH3fh/g39CfF9draqGbsozksZ5jzN8UfPX3PKElXXNQPP0qRAopkRwho?=
 =?iso-8859-1?Q?lSy2sdEQxWAOHe87AOybOsiMoo8b17mRmTOG9rAskp37PevRf+XFIHRSCP?=
 =?iso-8859-1?Q?fG+6bBdn20RaAjhs0s2Z+IjN6nnksUYogz1DDHEyz0B/bYVGJdsZFna4n3?=
 =?iso-8859-1?Q?GpaUnk3zRxjtVNyiN0ZtOmAPMQ3fQkQNAhhxZKTbdLnykie3aATBW1FX24?=
 =?iso-8859-1?Q?zGCqEvTbY5H0nYSHzdcic9mM/D8viR/IgoFiVck+j+wN54eNRzesUWqglM?=
 =?iso-8859-1?Q?0s9I7731gXJyayWYIcDWQHTZ/w9P2fY72EdSxlXad8pyQUdMU41eqB7SY/?=
 =?iso-8859-1?Q?txui2OMvh4mt13wL/wrPRC0XOScxvoyv7cDiD7X5tW5yCW908T1nHu79cm?=
 =?iso-8859-1?Q?j7LCGlZuSizmmWZbLysTd4KFcMP3+L43CXb+pvHjCIFETr7Iim4uz6zhZl?=
 =?iso-8859-1?Q?pX7quZI6lBVwDS7Mccj2gdq6V1K+7uMo8RyooW+PLb6VC/CpyP0zNUQscw?=
 =?iso-8859-1?Q?dxTpz2Xj1l0Y3HxFou+oqLFbHBTYsjF5t0lHKzn5/iRhDQMLyKtzqMnqbH?=
 =?iso-8859-1?Q?DrKzLkwDxYF4Qm0vOyYJITnbQmlzalIC7OabLCfFz77qwAFUBhZ4Tx4iFG?=
 =?iso-8859-1?Q?MTuzYAyvyoSXuHx9U3Oa/G7kO40U3Zi8y1cs0Qq+8o07icT1SE1pqgO3w4?=
 =?iso-8859-1?Q?/teK5XiYCh/T6sTaSJ6vNLyihLu4gMd4HpdRsXcbC/9GbJR7WdcguNcZZx?=
 =?iso-8859-1?Q?EBVRWRHAVx0lf3DRmsfHomVMINc4+q1Q8ahtYgPqop5Am192OWxRCl/hUS?=
 =?iso-8859-1?Q?dRrYTSTL34z6g1GBPfBToQMWAE5eLsv0gPUFkHiHuz5+nE/v69hUhrNOeW?=
 =?iso-8859-1?Q?UQJDTiSS9ysNqL+1PhVXv66jwMBBuzqEkxPdomaiCLnnBAn23IngDIB+mq?=
 =?iso-8859-1?Q?eCkffY0jBTV0TBnXyUzLUH5C69phiJzBQdc09RgMTobgGSonU4usdqLGVh?=
 =?iso-8859-1?Q?4KQzDf+jZktoaR5jL4JIUeLjOHadrDOI+GEbvF7oOaMHRfHz1FUYZxrqtO?=
 =?iso-8859-1?Q?exfe/v/TTpZQGbb3EDcmyKDmTXiao+UfHmcWRQ4z+Nf4Zj7A+P13ZMRD8Q?=
 =?iso-8859-1?Q?XV+jq1DhwDl/Gg561fD67YcLfak2zE5AuM23Lsi1l3CwDMDDwmJyaUg4uM?=
 =?iso-8859-1?Q?Pv6qzXhtyGjfpUox9t2l9Oka7dlCeZN7LIs/UOhO+3HVDfdMQFn/BEvUnS?=
 =?iso-8859-1?Q?/KqIOzvds7urcqEb4a6gKFb0Yfk8Er2/16Bc4CxeL2/BeJp5xnJBjPRaj6?=
 =?iso-8859-1?Q?aAO0LyUH2ESqNCDHpTrn4ocY1Q8+h6jeNn7dcUDBGq8jemrYyI99c6d2r+?=
 =?iso-8859-1?Q?ZNQ64MSLbHBmaChyxVn9aN7Wi54x8lofaZxMkeMT5kJAdDAZI6luNuiv24?=
 =?iso-8859-1?Q?kniIfRHrd8xpPua2HROG/Kk/QdkOFjp/HzaU/GVUsj/fqQDKJ4jNnqpr99?=
 =?iso-8859-1?Q?tmnfE4MJTqYm1bBlHckTl4laWwKSixEgA35P9WHCH5UJymI9s9Ls1XU6s4?=
 =?iso-8859-1?Q?1dk0HgmfjlEsLzZkSuaZQA+o0LnUnbeYMnGjJfswTutKSs5M54rGoMZz1i?=
 =?iso-8859-1?Q?fyYVObWjGguIkf3JuIokZ8FrMpZWrF60snN++aSbUe6ZICff2qcyU5V2C6?=
 =?iso-8859-1?Q?tNLOHfb8+Pc1zA4/Kv8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db945b96-7571-4a51-e1fc-08dde64f2053
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3934.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 16:22:48.2523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YrjDUde0RdDyFEF7c3yDXp9SABzMcfh0HYrQUyCuQdNCjT8GXr1be5zP9mOohEwv2jYhk5O1STAxD4e/z/lrdc17XwFSJ+LilLCBvpTS7mk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6162
X-OriginatorOrg: intel.com
X-Stat-Signature: 3ezpd78fapieke9foppqf8ieq691jt31
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C4A2C000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1756398182-548904
X-HE-Meta: U2FsdGVkX181NF36mqFDxDcU+TxHCG8wci+6FbhQzWvQQghhRjZUgB6uty0yYVERC+uNigpzd15Gvb3tgrBxiDeztMrSkVTPVEOEE4Ubn5lDMHYQHPAUC8ckYoQfIhwf7rgBvf1+unF6tiV0Y2VJMd5cSUGDUL8ZR3SHY8oshHcA2pDsTrELP/w6khGAh8udBRj0k1M7O9Tc/hBdj+MNzSqfcmCRGnupzicuY6pf10amWHMJmk3U9cAq1TljOFt3/7Op0PPSfCeS8PFgf4nrPpYDPvjA77IlzeCGbvRnVfwJVF1wDDMjLAumnN2DUAwqchjrRf8p3DmH7xeFQlqkRDQ3+kUqLm0qYSh+LHAr5AOw54z54wA6kEUpfRZLcjMHwxWMkS++d080dokazrtWRdJzdO4AcyNJ1h3AcMTKhj3T7/s6pcea0l3iCouXYHGlEiy54PTo3lh5CnQ38ceadxO3NqszC7wF7BsszxDUltHgFGS/PkXLyAlMvPa1G9pp+UikK81uJxAQ8ja5ggfREFUGZyXLLjLzcthuc9o4gCRCFdc9HswZzXdfj1+czwEphu3WCLmt6KDK5BRAotuJLaczEiPXNHdO406rt8lyw8WQeTDEbk8/lPieytH8sO/yqs+AJp3e2S7ialUR7JlnDQdy2mLI6By95CyUMpjKPoyqlSIIsjLoByHA7Z8UXBFbdgUHyrRAPWPGlWMACx5sxlLsNYjN7eNd8Ox3pU//73EPrskJ2zU91FXvyueHaWf6ROMjIdO90mOrpDHEOOcJOrg3rgMG3FQOYyvu5h4p3lxCuOo6/aQyh3pszaUBaWuyGI0cx803NqDzVfXJ9tcLQj4vbBP9NMtRXw0Sl8XJMihedLhgEijviaKZMgt4qM6t8I5jO81aLy73iH4P1R8a/scoUS5a371bQgDZ41oa5QSBFKcDjapabL9IqZ9+uZnuCVXXuFGsSiq/O4z2qAa
 WIH3M1kT
 cO2zFMTY0paI28s2x4kDXjJ4xkH4S+hz+qhtJbTIFJH1s5ZpNEO7yOjLB49E15vZn6UdS5OsWqkgtcIFvc2V7KZrVzLl5ob3/IU/aDmlUBuyNawA4tE3Gy4PunsTOY1NfClFzy94oBTy7SQZb+tLlatWn3mLPxyYwB9nc/BQnwnhCVW+HsG6z79WRrqLlXqjbwTJp+pANvuPmT+x1V6ScK9Z6KvXaGldm5Lbrc/6eJyucALFKfsCGQCOUIctOEBr1wkhRLtn60QxmBUCViVtFTnO2191yaFUU178Oe5O73+32H0ViuvqTUxVsfqMH+BSOxB0ab+wpHvDfsaz2qIH6wWcKnpaDXpbxq1QzVNf8/dY/4lG31HRjRah1jt4GVKCigefCaMas/EbUERDSurIMEQr4GhhpTp22fhmMlDqFQ+2juRiSSgsZ2AnFe93Lbsdi3j8C36gfjinMuy69h0wOYJqz24LI5XmLMxkUQP0HJVQFoEMhA/7ci+M/SmxRgr/IvPYH7lpDqHBN/WZRAzpmnA/rjw3hnXeUyNdhbtyadRhvJye+hRVLWsQjUMAslxevPTRqR5tzNOzfCMZe+/zqnkcwPE5nhuUgJ7eFlKC8AhKTAnqdH+GIBHEo5BkOjSr9Vwmjh3iA0s6b5ygUZFM0CcTZbCtPha8Yr0jljNyUWNVeYs82cMaymd8HAF7Om5yFg2q8+Jr1JIq8KnRqHu7mVeoFAUBZRJy6VkEBI+eAGMzszjo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-08-28 at 12:50:19 +0300, Mike Rapoport wrote:
>On Mon, Aug 25, 2025 at 10:24:32PM +0200, Maciej Wieczor-Retman wrote:
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
>> within().
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
>> Changelog v5:
>> - Remove the within_range() change.
>> - arch_kasan_reset_tag -> kasan_reset_tag.
>> 
>> Changelog v4:
>> - Add patch to the series.
>> 
>>  mm/execmem.c | 2 +-
>>  mm/vmalloc.c | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/mm/execmem.c b/mm/execmem.c
>> index 0822305413ec..f7b7bdacaec5 100644
>> --- a/mm/execmem.c
>> +++ b/mm/execmem.c
>> @@ -186,7 +186,7 @@ static DECLARE_WORK(execmem_cache_clean_work, execmem_cache_clean);
>>  static int execmem_cache_add_locked(void *ptr, size_t size, gfp_t gfp_mask)
>>  {
>>  	struct maple_tree *free_areas = &execmem_cache.free_areas;
>> -	unsigned long addr = (unsigned long)ptr;
>> +	unsigned long addr = (unsigned long)kasan_reset_tag(ptr);
>
>Thinking more about it, we anyway reset tag in execmem_alloc() and return
>untagged pointer to the caller. Let's just move kasan_reset_tag() to
>execmem_vmalloc() so that we always use untagged pointers. Seems more
>robust to me.

Sure, I'll test if it works and change it :)

>
>>  	MA_STATE(mas, free_areas, addr - 1, addr + 1);
>>  	unsigned long lower, upper;
>>  	void *area = NULL;
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 6dbcdceecae1..c93893fb8dd4 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -3322,7 +3322,7 @@ static void vm_reset_perms(struct vm_struct *area)
>>  	 * the vm_unmap_aliases() flush includes the direct map.
>>  	 */
>>  	for (i = 0; i < area->nr_pages; i += 1U << page_order) {
>> -		unsigned long addr = (unsigned long)page_address(area->pages[i]);
>> +		unsigned long addr = (unsigned long)kasan_reset_tag(page_address(area->pages[i]));
>
>This is not strictly related to execemem, there may other users of
>VM_FLUSH_RESET_PERMS.
>
>Regardless, I wonder how this works on arm64 with tags enabled?

Hmm, good point, I'll check it out in qemu if this function is called on arm64.

However this issue didn't pop up for me before 6.14 when EXECMEM_ROX was
enabled, so maybe it just didn't hit tagged pages before? I'll try to recheck
that on x86 too.

>Also, it's not the only place in the kernel that does (unsigned
>long)page_address(page). Do other sites need to reset the tag as well?

This place is special in the sense that it does "start = min(addr, start)" and
"end = max(addr, end)" just a few lines later. And start and end seem to always be
untagged, while addr sometimes gets tagged. So with software KASAN and vmalloc
support enabled it would get the final start and end values wrong and then a
page permission error would happen someplace else.

I don't think all other page_address(page) sites need resetting, but I'll double
check if there is any pointer arithmetic there.

>
>>  
>>  		if (addr) {
>>  			unsigned long page_size;
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

