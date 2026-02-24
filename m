Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29142EFB810
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 08:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 640496B0089; Tue, 24 Feb 2026 03:40:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ED876B008A; Tue, 24 Feb 2026 03:40:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5006B008C; Tue, 24 Feb 2026 03:40:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 328D16B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:40:36 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B0ADB59160
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:40:35 +0000 (UTC)
X-FDA: 84478704030.27.3935C91
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf08.hostedemail.com (Postfix) with ESMTP id DC12F160009
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:40:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="XG7+/jN2";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf08.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771922432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=N0ShOM4GudxfwZhXwVoOANk3yFVCqHNVqvZYk9wlenk=;
	b=PJACoh2nXNLaDgL7D7wpLHXqcRneRjGjURYM4Ph5fTgJZ9v6+lnfqef52BQyt9hByBUh1Q
	ecvpYJh8tjChZqtfKPZrPI+M9TSurkuxLie5+AWgjpsJ+V2tWW87C6bbmGcE9UrIOTbYgA
	/mzJ6EkLiDOGl0+97x+7FMuRQxvzrLk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771922432; a=rsa-sha256;
	cv=fail;
	b=4TuaF+o2yEh/6TykiXyTCutIqaqYQanZ+hZu/GftdgjpZdn9bUB3GwZVMU3bY6gxEFmpE8
	iKbyGK+JqPZzBAwcB55MM9R1r/k2BMtCESkRJfSPz9hTDoy3zo9CS2hr1zAoh567SyURw7
	AWnVRPw+VRmPYBWKJvJxyRwJqxn25to=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="XG7+/jN2";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf08.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771922432; x=1803458432;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=Fdd3XZajSJj+TrW6D6CC6aFLAJTX7v/DsV1x5xWLHfA=;
  b=XG7+/jN25QkmgZb2F/LQ7KHIlx740tDf2H6AVNCRCuehY4u4Ljr6PHnQ
   aoKjoe6UPOn3tVctq2fheQjC6Mc25Vm4NYu6U8wmZWQNKsmnJ+0y2oczr
   oVh2wu9WcrleUWV1gvTcu0dKGw9UWGM2Yj/SaJIBw2m2Jqyn6pRg/ZJKa
   /+9VHLp9OWfRreCQQVoQZJKEzzL8GW4CgmXu5hCy63f92BSxH5s2mXggH
   u74mLwf1RNp87ByJxv9lIgwntu2/tLfHpDUv4uAh1agSQJYufawa9ymnK
   j2QsxixIh2NlrVF614lM7yOIf5FzaZ5InWs4cseLNvSCEPUN/0QUIRySo
   g==;
X-CSE-ConnectionGUID: /NFcVNIcTDCWSRUX2JF2UQ==
X-CSE-MsgGUID: jafKRAnyTpieqZMdVh3fQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="84292891"
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="84292891"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 00:40:28 -0800
X-CSE-ConnectionGUID: q0P7uX1nS9eXYQKaVEPR9A==
X-CSE-MsgGUID: 629LXJwRSyGT02nf/9azUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="220835277"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 00:40:25 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 00:40:07 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 24 Feb 2026 00:40:07 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.58) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 00:38:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QLvt+dzWhcA0V8d81aW6zC8afD6Iw4cwPaL8hkokFVVkm50/zLVFWi9R/L+coasVNMP3A+qCzoIJB1omrxr+1JuU/0miR6KzuP0OAnRwUaJ5ElvwAx7kGDHO0qqdKhtJJIfobmSKW3Vi+kCFEWj9XwlUK0nVfyf7ZDebHpfiSJ+49Byq6tLHJMLVu6mF1kBnGFhwcnaTuw5Ct6RPVdNTjndAeyGZUiQkBcdIOHDkAmaAanHkLd/S970LoGh1NTdultR81s7rdPUz9Wb5D1UQ6uJrZTp59iyn3yRuKbo70fCwQWEDIuCql5PYbLg99PvkqIzSvwLaruojDoxdTNOpww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XlIbAFcaE3sam1+JhCtRLDt04M4FHCthJciSz8zyZJk=;
 b=gfm3UBvzC0HxjFrgMbGf46fbTCf/8XAwPlgLwtrAaKEpCv/EWgTQCzD+c8h3UjT+MCXt4MKI7Nt/0f+6vAFrireGJaLrljkWVu1ZvO5fWgDpcz6ehrMkV0QDwiz5Wktbm2eHsJAxiuzJJFzY4GQWHVL/bNRqcY2HQboy2632CHYS9z52D+gRV7s8sHbCcKMnN6mxhefES7HZ0zcsrAvvGQn0oSgwHFgdKSs9SSQdRfuNUEhZgW04jRZHlJ9bLnbynHOP67Peyg3wfxmoKETOyXHtOPuXSDXhottw4BoJHvk/6SczqjiNK2P+wdHBa6EgrpIT4rNnfJ22UmTFx01uPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SJ2PR11MB7547.namprd11.prod.outlook.com (2603:10b6:a03:4cd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 24 Feb
 2026 08:38:53 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::e4de:b1d:5557:7257]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::e4de:b1d:5557:7257%5]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 08:38:52 +0000
Date: Tue, 24 Feb 2026 16:38:42 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, Hao Li <hao.li@linux.dev>, Harry Yoo
	<harry.yoo@oracle.com>, <linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linus:master] [slab]  ed30c4adfc: stress-ng.timerfd.ops_per_sec
 13.5% regression
Message-ID: <202602241519.7f9aea41-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: KL1PR01CA0115.apcprd01.prod.exchangelabs.com
 (2603:1096:820:3::31) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SJ2PR11MB7547:EE_
X-MS-Office365-Filtering-Correlation-Id: 946f472a-0831-4286-308f-08de73802353
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?7BpRH5XD7zrIvmpYCJaAvLXco+722qGkVnEZ0bDMwIBBjR2xt7PmS/QfSl?=
 =?iso-8859-1?Q?3RIEiia5XMV628xfLZe3PUIP/x+37K6ok35Qfl9docZNAfgyYdnkaTnu+3?=
 =?iso-8859-1?Q?0t1KxnesBztFMZgBjoXuK22gPhzEbeoeF1WcQuOvqIgmdID9kZIl1MePDq?=
 =?iso-8859-1?Q?kmqAIbN34+rhNvXYY9kq3VOpqj39GiuHm04YMlQXo0o9noRQpmOoGWHhN3?=
 =?iso-8859-1?Q?3TlH+CMsEJxhTVUzwG3gVssGcnvBAY2kkZkoKWsFBrNidU5z9PXphe1vP8?=
 =?iso-8859-1?Q?6PfnthkgK/9uBFfShFrLTtR1QxhesZDSCd11QBtQpTQuKEaXou0p1f6cr3?=
 =?iso-8859-1?Q?IYGh+fDzQqANlI3dfS+dnTRSBQ4Qsn6exJaaolw0r+LtzEH3EU7vGvNY5y?=
 =?iso-8859-1?Q?BUf0301lAKdgvqsidCKCHaHxlTLGyIhgwxA2Ur8/w3MLjjRDrcqlTvtIdv?=
 =?iso-8859-1?Q?dBJhLJRAL19ToVrqqPy5uQal3d8RQPAalYfxUowyvkp8mc8AfEWmcVa4Xd?=
 =?iso-8859-1?Q?UofBxyipWYpJxBwSr/+vAn2njOajqaiBB4oSyCtwMGfVHuA+0jTWFRTE+8?=
 =?iso-8859-1?Q?Cf4FHqKZtb9rM9Ssh/Qspx2PwGzyHtlFFawKnn2RHwtoPc5r/q7AaExamR?=
 =?iso-8859-1?Q?m0L1Dz5HHhk5c6LYske5cLCLCWfN+tpfOEuYdkoPN4PMxmvUy3JeExEw4q?=
 =?iso-8859-1?Q?xIvvYRI2gqMNhAjsdc9a80XWgYpkojIMIfsFR5a4RVpDFTtBeEDeevA8JY?=
 =?iso-8859-1?Q?nmof0y9raj/afV6HnS9MIrgruZaLKdTMIwpkNAivhlfPnUNv1b/0XhTnGQ?=
 =?iso-8859-1?Q?NzZfoUD6f24WePqCjd/RUmLWf96GGbrRNWp7KnlGiclpbtijLdvOfdo+pm?=
 =?iso-8859-1?Q?4e/dsl+PmB7MCi4jEk8ZokAA8RcM7nBE3p/v960WNXs05weosIOHMTwd1/?=
 =?iso-8859-1?Q?+yqsCXV4PrnnSxPTu/7ijXeAUJVVGhO60esyyg1kZAxiXr7LpjwfkZLMr+?=
 =?iso-8859-1?Q?aTX5GFsKm5af34eRAnusKaZB/iRv6FiZb/o4gY8NpYMtDylkWjiy/55/vr?=
 =?iso-8859-1?Q?5P8awUYA3fCViJEUEG5lildLwqSX3ivqnzx1y1cenekSuReIQ6QWs05VyE?=
 =?iso-8859-1?Q?a6A9RtztnNMIghzNZjI3LYsPeudZXQUiURN5qzUtAvBiJORqgi9rj6lqjQ?=
 =?iso-8859-1?Q?DFa7pMPyhT/ezbJQLLzjkBGthy/0ci3ha1AcPqRGKZJndFsv3sZ7wS1X+u?=
 =?iso-8859-1?Q?cZtDSvCjc9zgvP7Hiz1ELynuCp2xQ1zMAuFVUD+9qXgEx37EmfSFXriKxU?=
 =?iso-8859-1?Q?mSyYK8IFZXmDAUz5oPBYv/sNRL+aplyJtoH4Ou79fAkz2pasobJeqYwpRB?=
 =?iso-8859-1?Q?cW1ZaEhvxL4yMCdyIMGgiyHOjsbvdM6DVTW8kRRfOUK7sej6CEe1hv5FRW?=
 =?iso-8859-1?Q?RNZ81Og2+eIC2COidMqODfZmFqhqeLJhxbnPFjGVvZ17R8dBGA5oGjjJ6P?=
 =?iso-8859-1?Q?vVs845bhuhbiaQy5iPIZ3p5xKNpDVDvNp7OepiZlQFWC8l0h1a9ho5a+EO?=
 =?iso-8859-1?Q?yJIAkO1UePITxkCYMWqxmi1cfkL7rG/gsR8eTmBafJqrbXHzYmlmS71Fsf?=
 =?iso-8859-1?Q?ENsrYtCRrUbbaFPkLaKgyl8nScabbzOL+N?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?H5uBek7JIYZYoaEggrER3autsIfV6oryAzhTi5YNe6UaxAo/lw6bYc5Ait?=
 =?iso-8859-1?Q?dy6BkfxG5UxgVgmgC5fhL9PIT9ugbueZKiZQrOne90UJnrBcqzP0qtDsJo?=
 =?iso-8859-1?Q?2SzzViHYRJYtHncDS2iRG6UFiV5yfVaOLOWAlsDl3IjCJ70dseDqjWlEXA?=
 =?iso-8859-1?Q?S945xhrF5QEBvCEvq4pBzKE1xLfyls0zZoidjI32Hr4raTvRAj2i8qwuyt?=
 =?iso-8859-1?Q?FMyyUiL2ER4tZ5r6MifnKgUwEGE2XVsQfFIbhCXykAGVLscR27wwuG9qSH?=
 =?iso-8859-1?Q?qVk8dLDHwy1wtbCaDm9RQGCR/9nEhcbmkrvKISPTIZTUE3YNaUDriMj57C?=
 =?iso-8859-1?Q?Mid9lkwAHyTXTrNJOQnag5Qo85Fgdf6iV8M9EcJBjTyhSxtTh2iAZ/fQfa?=
 =?iso-8859-1?Q?P8XLXURCjecO/DdaCgy5R3DfwBlUK5UCX5dVyP88roqLo/YpBPM1swJdAc?=
 =?iso-8859-1?Q?it0XeieBCX+CrEev96ej/l5GuWV5RDUmOEV9Z+ggADBfcnVux/O/9Q/UGj?=
 =?iso-8859-1?Q?e0g5gG/yIGvnDrHFIA/jXAkJE6/UO+WWnyNKBEPpqa67h7wdnJVMPk4PIz?=
 =?iso-8859-1?Q?SsAP+zh7hfPFJkvjb1lz8+YJ8rMm29V83N5084xDO6VMJZpn4qvUG4PWEH?=
 =?iso-8859-1?Q?bwI073mzPnnfQc0346IwMBWVvvFQEZgW5oBbuvtPSVDZxKIu6naiJSWqJN?=
 =?iso-8859-1?Q?KsdJ6MhL5kVmkHKfT8D/92Z5JqalxkU6C51BBOFwOTC4ChoHlMgFWXcYxP?=
 =?iso-8859-1?Q?TPwuZDkI7kwg21V2vV1l1deXrNhn32st4xgAg8qnHYAzcG7nJtfRwXdVAR?=
 =?iso-8859-1?Q?rmolPcoEl3WnLfGbcPOmwo/PizQXZjAR1xrfYS2TZ+ho6nFdyRDSeck4HO?=
 =?iso-8859-1?Q?eG/wpMRtxqa+jfQ3fc9BWvH66N83sAhm4nrcWjV3PoRvWvcT01fpnGOlxb?=
 =?iso-8859-1?Q?s/4doWGHJcsdpA57K4nWNKWjFRXDyoUpfhieYR0hc5O2ZL4qJz60tWw9HU?=
 =?iso-8859-1?Q?eyDk3MVEBmWsYs/6Gs0cJ+msiMtCMTHcIkHY525OZ8O2Gt+aM2I2E0lisI?=
 =?iso-8859-1?Q?N/L1luGNoCw33oB0+ax8jdqGvtwipagNZnubLN6c+eTwdX2P5h7ZsBQm9l?=
 =?iso-8859-1?Q?+qFScK1I3RzPzzMzzazOcAXej0kcvPz6MszGDBKuHkPZvEa+dbS/tiSIPt?=
 =?iso-8859-1?Q?OGJ/QRa4n41b6+POGx+W+tRjl7/gjVKk7BL08JwukzWo40oi6IwURywVVn?=
 =?iso-8859-1?Q?uxyGWwbZAlTLXSFn5FGuiLiJKlYMZzZnUaAJNpmUFPukxB+hY914O+zfry?=
 =?iso-8859-1?Q?5nwEiIC60kzOri+kez8IasEihRb+e4b1yhoSjg9mNeapaVGk1c91Z151kt?=
 =?iso-8859-1?Q?FG9sIvdTK8/mFt/pBslwlcmlPFivcs4nrUJMuVuepdnv+DlPV5WRYeY0Di?=
 =?iso-8859-1?Q?7L6vxE1scHa3uKJVTmr4wLhFJPnmtTXPXOb3+HuN13AEiXEdCTHjAPhk6j?=
 =?iso-8859-1?Q?TZ3amlssKuX9dzJpFuTcW1WY1IiYb8vMvG4QLoIUCEDFsSBd01pPWOJjy7?=
 =?iso-8859-1?Q?Q9ViqoA1cKvRITIEmiWgolLO0LpLUJ8ieYlQSWRq+kzbv1FqBJ4h7Kt+s2?=
 =?iso-8859-1?Q?51haKOM5CB1SK7yp1XaqQ7x66+d8gP+U1Q6Ng3SOk5IzidkXlelp2xxAFq?=
 =?iso-8859-1?Q?uxyvrddEVIyOZceA6bWX3twgFCsW/3n2VEH+sfleYWRbBca1/n5/n0qd2T?=
 =?iso-8859-1?Q?6OxMFqf84t7hBhCwgkJ31i+MZGf6gRJLLAKbBemj25WLL1Qa6E//o76PUY?=
 =?iso-8859-1?Q?5UBtPyskgA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 946f472a-0831-4286-308f-08de73802353
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 08:38:52.0156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OHSEH7894D2SBsd14nRIvJIlmnuFieOnL7Qzuucp5alpr+MMfKY6QHHMVvnOUWzjn4G/uPwijg0FOjxg3Tad3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7547
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam09
X-Stat-Signature: grpxp6r14i449ik78pq7fkoqeg57hrc4
X-Rspamd-Queue-Id: DC12F160009
X-Rspam-User: 
X-HE-Tag: 1771922431-827068
X-HE-Meta: U2FsdGVkX1/F48fVXynZWqnIkWEB4QAGs6XY+wY9HAF/gnjgeM67TO3KVQcki082mXljILInY4a5nOhri0hA0gpQ5sF4ovuQ8hO4zp2s7zFKpsYbMDELmKeYnkeWrR96qTyzrStmDeons7nBN0h6pAckJG4hhPux7UObru3CvIYtwZUHuJ+vA9aFAHfCkwrMAdB/wB+yyTo/13FSHDcnwee6zjzzGzEu8xwtF2AonjnOzvrNj1htIAm4MNRpG+KLWIk7LQbWOb//YcTeRzkkzMM9C1hTLnyOHcuolhruElVaP4N/xB7gnOQsai6vv5TC8Lnt0fkIrfV8f2on6rAYlEa6x+rFunll6D9OzTgmupyPC54H3OnX/uz+MXtvcHLY3S1Ni6RSc9KXbdKixH/c02nUDlORToNnbO5aJkaxpvTt76GNeC9YsoHAsR14irKfRg/TEOgfVAzlnlDuuPfGkATRZRxHbrlep+qbUnsTZ7kJfMKVP+Y2BFnEBaGTzCeEv/PexCWEQyqO9KdV7VN1t8+EfSp/jM+3keXTVyMVMeyhrMgV16FWz8alLL0ZULyUWwXixmeLqrBw6V25hkfkjZ68OMj5ig0mgFENryec8n35CEsFWORQH2vVCxjHmQLok0iVQTFlwcjPx/cjaw1wWfxoreurQPz2AI0rc/XzEYiEJSbr3SgW+0jGec4ROsREM7QRjhqFZ0jrK7vur5oJcT+ahMb3mmgSHparDs6ZDiCI6Hg+c/Tz8R8gZ76M1HsJNmT7406XCQk63gp5FtTEM/HsgYJ3KCUAD1o6a7qgurAB41fxPvU1dh8QPkxFivJspjeplIhcBLf+ksLj/OjqA16Cssa0fgoWrotiWxQ7bNp9HCXs5B81pQ1/TFhhdCliUwCO03Oqx9n/lCiTK5EkEFyJawCwbH/9wLxTkK44PbiQEICiEkwLz2+tVt+obyO+R3BhXuwrg4BAONsC8fv
 YC0YpVEK
 cfGv7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 13.5% regression of stress-ng.timerfd.ops_per_sec on:


commit: ed30c4adfc2b56909ca43fb5e4750a646928cbf4 ("slab: add optimized sheaf refill from partial list")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[still regression on linus/master      a95f71ad3e2e224277508e006580c333d0a5fe36]
[still regression on linux-next/master d4906ae14a5f136ceb671bb14cedbf13fa560da6]

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480CTDX (Sapphire Rapids) with 512G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: timerfd
	cpufreq_governor: performance



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202602241519.7f9aea41-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260224/202602241519.7f9aea41-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-spr-2sp4/timerfd/stress-ng/60s

commit: 
  913ffd3a1b ("slab: handle kmalloc sheaves bootstrap")
  ed30c4adfc ("slab: add optimized sheaf refill from partial list")

913ffd3a1bf5d154 ed30c4adfc2b56909ca43fb5e47 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     17379            +2.9%      17891        stress-ng.time.percent_of_cpu_this_job_got
      7100           +28.7%       9137        stress-ng.time.system_time
      3397           -51.2%       1657 ±  3%  stress-ng.time.user_time
 2.162e+10           -13.5%   1.87e+10        stress-ng.timerfd.ops
 3.596e+08           -13.5%  3.111e+08        stress-ng.timerfd.ops_per_sec
     24.13           -50.5%      11.96 ±  2%  vmstat.cpu.us
     20.84            -2.2       18.66        mpstat.cpu.all.irq%
     51.25           +14.5       65.79        mpstat.cpu.all.sys%
     24.90           -12.6       12.34 ±  2%  mpstat.cpu.all.usr%
      0.92           -12.4%       0.81        turbostat.IPC
    114.75           -13.2      101.54        turbostat.PKG_%
     21.44            +5.0%      22.52 ±  3%  turbostat.RAMWatt
      0.02 ± 20%    +187.5%       0.06 ± 35%  perf-stat.i.MPKI
 1.146e+11           -12.7%  1.001e+11        perf-stat.i.branch-instructions
      0.17 ±  7%      +0.0        0.21 ±  5%  perf-stat.i.branch-miss-rate%
 1.397e+08 ±  4%     +16.8%  1.632e+08 ±  2%  perf-stat.i.branch-misses
     12.23 ± 47%     -10.3        1.92 ± 40%  perf-stat.i.cache-miss-rate%
   2332655 ± 45%    +742.7%   19656432 ± 53%  perf-stat.i.cache-misses
  16606819 ±  9%   +8113.0%  1.364e+09 ±  8%  perf-stat.i.cache-references
      1.11           +14.1%       1.27        perf-stat.i.cpi
    730605 ± 33%     -91.1%      65146 ± 48%  perf-stat.i.cycles-between-cache-misses
 5.892e+11           -12.4%  5.162e+11        perf-stat.i.instructions
      0.91           -12.3%       0.80        perf-stat.i.ipc
      0.00 ± 46%    +868.2%       0.04 ± 54%  perf-stat.overall.MPKI
      0.12 ±  4%      +0.0        0.16 ±  3%  perf-stat.overall.branch-miss-rate%
     13.80 ± 38%     -12.3        1.45 ± 53%  perf-stat.overall.cache-miss-rate%
      1.09           +14.0%       1.24        perf-stat.overall.cpi
    310396 ± 24%     -87.4%      39114 ± 34%  perf-stat.overall.cycles-between-cache-misses
      0.92           -12.2%       0.81        perf-stat.overall.ipc
 1.128e+11           -12.7%  9.852e+10        perf-stat.ps.branch-instructions
 1.371e+08 ±  4%     +16.8%  1.602e+08 ±  2%  perf-stat.ps.branch-misses
   2278016 ± 45%    +747.6%   19307920 ± 54%  perf-stat.ps.cache-misses
  16326694 ±  9%   +8118.6%  1.342e+09 ±  8%  perf-stat.ps.cache-references
 5.796e+11           -12.4%  5.078e+11        perf-stat.ps.instructions
 3.566e+13           -12.2%  3.129e+13        perf-stat.total.instructions




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


