Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAEB5CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 07:26:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B6658E000B; Thu,  6 Nov 2025 02:26:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18DCD8E0002; Thu,  6 Nov 2025 02:26:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07C4F8E000B; Thu,  6 Nov 2025 02:26:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E772E8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 02:26:40 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA638C05D8
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 07:26:40 +0000 (UTC)
X-FDA: 84079349760.09.5D486A7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3C53940002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 07:26:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VRWbxA8Z;
	spf=pass (imf04.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762413997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5JnTVCtm6NjLj9kUxT7Ji1z7EOCQ4HYq6F/dpi+tdvM=;
	b=DDt15wjsbH7WGnjYuLPI5dtesYF0lRik/39tLFd/vFsPtntZgHD6D26ZIzazMhX7KQwyo6
	oXVPZ7tvFoUaG5d6TxbaDCcJMab+0q6OXUViZYRUd+bqmoDoIR1DvDPKm5mHmvTShq0uUI
	zwyhlWvzoNZt+EZm1EyySkIYpqwbmBM=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VRWbxA8Z;
	spf=pass (imf04.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762413997; a=rsa-sha256;
	cv=fail;
	b=73jesViJya0XI6qwLjoJihQpxLZaisUikKzogjVTOwb/wrwz1eHVvk8sumf4Oq15H6uFFw
	qq0vBND6Kf/wk+gNWGzQlPzwHsNyr+CiGlQGWd8An9Gpdpo2y7C7qEMToyXIkehBnj/UEy
	XlwFIJXNO3CPFMIZzfqIaBNLADXDWfA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762413998; x=1793949998;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=a1FKm+d1jYX2X/Ul3OGBnoXDrWuHd3lt737KsKJn0PM=;
  b=VRWbxA8ZfEgN1L4dVBbN+Ika+LizEAeS1eDepiWbfzJ0I6Mbf1nKMK4k
   tHaLwNxxjDhX69pkwe2n8jmG4f45Kzxi1IQXf/ymxKZsx/pCemoCoPGyw
   DaPkGyM2fhVNMVWmOoL9eOGc+KrzZLEWqsLvenIcdYDNJE2DUUMsGiM+D
   1R6z6mNOktxpVPPlQE38gLxNhaCN/OU5Mp/gAOi1DrXd1AjvTVGVLGTTG
   zfpWP07OA2qJk+P5OjS7OcaY+n6vlZDDzaBqwlELCEyAxN4z6mTnKwtTJ
   gyZwaER4EbDwtr8B6uCL8peBGnLpDGpgorO2qk7CyGo7zO5gyCylgmVAW
   g==;
X-CSE-ConnectionGUID: +/4hv2GXREasW9EpaBHIAA==
X-CSE-MsgGUID: uqswq17KTQue8bAZyX320A==
X-IronPort-AV: E=McAfee;i="6800,10657,11604"; a="74834709"
X-IronPort-AV: E=Sophos;i="6.19,283,1754982000"; 
   d="scan'208";a="74834709"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 23:26:36 -0800
X-CSE-ConnectionGUID: IYLEiNsxTl+pG82H66xX5w==
X-CSE-MsgGUID: NJNW1prCQ/GZHxCcMkIzlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,283,1754982000"; 
   d="scan'208";a="186971649"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 23:26:36 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 23:26:35 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 5 Nov 2025 23:26:35 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.61) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 23:26:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XbNFOmr2DHNe7V1Yj/xvSTxcXXjSA6l7d/IarrkQm2TNwUvcxHzQ0TDSGJp/9zFctjn3YOOr6A2FCFtitIx8Io1XZ4vIRz3BUGvhLLKXKe3hCXuao9ypXLnGk8QOnAQcXq3UAu5nSzXvoUSFSlKQq1Rc3Vrz6tjTEVH8ySPDlXlYDMUOLty5t40y/MQCOWYvhbiBzrooyCc5EbQnPkpfCmn4nTi6ZZH1hl9kTmaZCndD7bR73VYkUpbjN892cm/kHGfN0EMToQOJGpnUKMRFu95l8YIMu2Jn7F4WPPkez/2Zk5neySqEBH5FUHX2YCfRLTeICWKiHTNnTRsBv6IH4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cqQipu+8pXThSo65/PZskPQWnhjtVMZF1FxtxmVjz0s=;
 b=o2yWU4hKB4OMtSyflHHsLhat7rbg9q+LmJ7sJfoR9DU3ZF6dWo4kqt+F9U2KeeAqtJVM5WTqOPPGMwMONXi3k1OkSLdgk2Bmc5QUH5eqhfwyxhhsYoZF07v9p/vB32TuzWFjmuK80nw3nHZkS+uNG6eDsd+KGV44H3c1Uf+WLCYa6iOZV6wGlugNlt6qBdgjv9zKoyiVNGTYlGq3fEfPW7+91B1Qqk9E+5ydD2K7Idw2aIXRLECUjSajQK1veMEf/KoNofmUJZG2dimxDPChGP8C9NZZ996ejyZ1xAcyjuIl0uBhO18uEj1bWPA1kizbyZEFMlg/vDQKAx36XoQNbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8587.namprd11.prod.outlook.com (2603:10b6:a03:568::21)
 by SA0PR11MB4685.namprd11.prod.outlook.com (2603:10b6:806:9e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Thu, 6 Nov
 2025 07:26:33 +0000
Received: from SJ2PR11MB8587.namprd11.prod.outlook.com
 ([fe80::4050:8bc7:b7c9:c125]) by SJ2PR11MB8587.namprd11.prod.outlook.com
 ([fe80::4050:8bc7:b7c9:c125%7]) with mapi id 15.20.9298.010; Thu, 6 Nov 2025
 07:26:33 +0000
Date: Thu, 6 Nov 2025 15:26:17 +0800
From: kernel test robot <oliver.sang@intel.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
	<maple-tree@lists.infradead.org>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [linus:master] [maple_tree]  9b05890a25:  stress-ng.mmap.ops_per_sec
 3.0% improvement
Message-ID: <202511061420.a984bb7e-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PS2PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:300:59::31) To SA1PR11MB8594.namprd11.prod.outlook.com
 (2603:10b6:806:3b1::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8587:EE_|SA0PR11MB4685:EE_
X-MS-Office365-Filtering-Correlation-Id: 06b18ca1-63e1-40f9-0ffa-08de1d05cf5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?yIWPHSkeIjZCymGL7DfYHfQ+JEp2+9nTM/GMECJ+EuoHNR8MYxw1IJ1O/+?=
 =?iso-8859-1?Q?tz88vvIZOKxjbjdnv4FW3QFAte1QoB+rgsSTeoRbDWWqQPBzzU7zyfs+55?=
 =?iso-8859-1?Q?f825GFRNl9lo/a8bfHc0j0dP5R+BFBEYPJTIAxq4SAv2OlcATVhVy9nu74?=
 =?iso-8859-1?Q?CxDTVzkn9F+z+BDFBXD9cErEWVRXjn89XJSVQRoJePfQN0DLv+/InLMmAc?=
 =?iso-8859-1?Q?XpAEiTC7nPwjYMzcEOlF2qFDo9yqaKzC5jhg4k34KCNFmp8epK1ZdvnWky?=
 =?iso-8859-1?Q?uzHNNH+hRXM8K5dfYSBZwssTfjxXK8/26cze6yVUgIBSYxETwczfFNN1mU?=
 =?iso-8859-1?Q?XFLG1N+36iZssUN5o900buoHEBaYGPKL9NDdfwskdJrITIx8V6nti0J/ZR?=
 =?iso-8859-1?Q?HQSKXo+YkrT1YIZtRAx2/2RJzejQKqqB6IHKI7uILINvnnAvKqT1hsuYG8?=
 =?iso-8859-1?Q?PVHJ7H+d/AYl7lg5Fy/GgPuj1nXMtucZeqC7YJ7RER0tsyYvMUcqEVJ10U?=
 =?iso-8859-1?Q?qN1JtwR4NQWCdL7qpv1m0RajfiiwMKtMNCKiFdowKiWGOVrV1CZjh0Ep0C?=
 =?iso-8859-1?Q?R9PcGY6Xn0sL4heN0LW9qPzDwQ/+K5H9APP+9qjaTFaDVSg85qXPPt06yO?=
 =?iso-8859-1?Q?Yn0dt0ckIDjf3tNjpNt7sxjddA4zQIqrrGQOLyrSoNk2NHWYxX9maFlqHx?=
 =?iso-8859-1?Q?C/5PG3/biSsvqz6WWdRvAibLuu7z/wOScY5+R4C619xn7xhAXgljTNrCIS?=
 =?iso-8859-1?Q?fdFskkpUw/dne8ZqrLuW6KaeWk6Vwu/pufMcm/DbHF7A66LbvqWV26ClrC?=
 =?iso-8859-1?Q?1LI29DrvVoZf9hw0rxZViSOGFW/XI/jT+ObCeorT/1VA9q2adNZ8Xv+T10?=
 =?iso-8859-1?Q?DPYNVkph4Q5RDTmxwG7Kw3NnjiXXODQfolZo75rHPNJ7556ZJ9EKV74QQ/?=
 =?iso-8859-1?Q?YF6lUXfliKAvcwt+a3SfzWyXxJeb3mmokD5ywZYnWHLfZ6gF3PJJ8laole?=
 =?iso-8859-1?Q?WhqAmNw7xaA2QjGx4NPfBk3AWH2SZBI2KZB3HH0f0o2YReSWX/ChmTnuWQ?=
 =?iso-8859-1?Q?yFPIuC/Gy2SpvEda1Iv3tCXb94f8T4R+NlW7Fj4nSRO2Exq5PjoRNS+j2j?=
 =?iso-8859-1?Q?44aGq0KE9GweX7GH3DChmL/XnRFRk0buW8j3Pv6uSW5r5P08N2D5xNhdgk?=
 =?iso-8859-1?Q?NG7zat4FZf2+bFgu7INa0g592t+0ND4o2rfDLRpPDKwB17M84Ymdrwtsag?=
 =?iso-8859-1?Q?xxRRQv6DiWLTluAn64OU8OPABGtvdFnYX7wAQqeV6fsgKZ9035ddsjMnY6?=
 =?iso-8859-1?Q?m/lN6XjY64vfjPEf6yq50PTMSyITChZaAGNVkHBF7p8Xh5CMSqyymSYvZw?=
 =?iso-8859-1?Q?jzjMiN9EUyWeFvhA6FkCxraqKbqTUJ+rjU0yXErxJpCgIeqYZsjjPKdP6T?=
 =?iso-8859-1?Q?QwbyV+LooygRx5bvOtgk7t2l+v6BK3ps8eboXhsaVq8cn/p+QHTM916Llb?=
 =?iso-8859-1?Q?aqthkC99g+Ic5i2Y34ruwnO2vMZ/oMUbfRWUUzGnVZwQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Ihsk8eZPcp7Yrs9KFM+SZ9A18nZa0r7HtRVlnYDNpXUDAA5oi0xPT8e/eo?=
 =?iso-8859-1?Q?s/eG16Ue3tvBa5XpLa0qD3CxGcYGdWgfuWDn5EWaotGcCKnHyc/oS7TPFn?=
 =?iso-8859-1?Q?F0/1p1IO79B1JUQ0KfHBa76LWJKg7LvyZbQDKeegAfX2fO4E3UPugTnYh8?=
 =?iso-8859-1?Q?ELUWX2AaI5kyxbsXGlDHyN8LhwB77P/+RH3HR8IDuKT2RoSU13+KCqvJwb?=
 =?iso-8859-1?Q?Ox8TKVOmZkH06fxSsbSYL36WqkZf/fu7tBE6a5qzE7kMyPvGb8BTfncWZl?=
 =?iso-8859-1?Q?dZ+rKEudjJXdKOprkXBls9aO2b6agfh1CEiKQn/jC+gIHtLSELNGneOGNO?=
 =?iso-8859-1?Q?dBdcu5e1fHDQNO+2wsaulHsnMmObqv+zv9aTo8qO9jfrdIz0t1d2iS6Ak9?=
 =?iso-8859-1?Q?ey6RSY58TitYFfTkPVNlKbQSYXcRmcGH6P+eYlRyTQgs3Qt7b1GledaBhe?=
 =?iso-8859-1?Q?o9wPIAlZTDY1mXej3YcirAyRX8bvSlKg00Vl0PbqNjB0HBCztVDmuoEy51?=
 =?iso-8859-1?Q?cN32blbiqbsoZWunba8EtRc1uXByeoPI2I+1ZAA1xEAdO+AcPBBnXoKllq?=
 =?iso-8859-1?Q?itVKcfXSaa5fuO+vDgyJ3yuV3O5CLSjf2XC2uT7YCoPKdeNq5ehrKdkMLr?=
 =?iso-8859-1?Q?ucmCbwEgNsqGWbAfIe+s+7l3EsAglj1BKgbWyqzcoulUdybbmmS+vMaHZd?=
 =?iso-8859-1?Q?FjQF53eYsvHEy5nUr1MPnDQRR/WaqoLomuPEZ4gacnbBdhpo0+dkHdFjmu?=
 =?iso-8859-1?Q?ul5hIcvL+DtjxKDgFFlE3WA2CHU2kvhV6hpJAMVdj9/BxSK4kpYHGD1r6+?=
 =?iso-8859-1?Q?mWLocL0rxuRyqJkSLzorx1OYFFqVufIYH3WipNpYx7dRQ+LjKQiLratjFs?=
 =?iso-8859-1?Q?CdDlWz93EWOcstKmhVRKO1vIS05wSZO2SNa/3xqgBKEhc+ZZmy8f32aZq8?=
 =?iso-8859-1?Q?hqaEboUAut/09ZKXQ1f8yoG+Gh4cRI0hSEAJhE0USuttPKIRd2qdj0a99M?=
 =?iso-8859-1?Q?CZWot2i5thLTyoSUpkWkBDW8Od/bXLty1Aar4Lgsfwa/sr1uD0BK4TXwRK?=
 =?iso-8859-1?Q?H0VLd0TYgy2rQRrYammPLpn1IJWrrxhrCb7KiWxCP9tQkwXcuU0KsVxrCl?=
 =?iso-8859-1?Q?kslRjtapwrLZax3iBhejyKQd9mykjI3tNtgh+oRmv31WGqDnM2DJ0Heio7?=
 =?iso-8859-1?Q?bYZdbIVQ1VjUvhF6PDYjUyxxpIQn2zd2fgA+9KNhRsQKe48BB/iUI/wyET?=
 =?iso-8859-1?Q?XkdFKXAvgEnI38W+WQoFOWxeTqOseGDeDyltV7l/S0bRtjndRer0AxeLw3?=
 =?iso-8859-1?Q?QGFcJtuUezIj1GX+m+5l0ra3f/2OsWGaz/gITsl8oEuN7CgPQgtCXcpp4G?=
 =?iso-8859-1?Q?L2L2AeoIQ+vTO3GXClBACS8/xIlZdaUdleQGYexCXxrVu95QrZL7cpnuWZ?=
 =?iso-8859-1?Q?WLAaJTMZQqieVkM7z5D0u93yLNh3lg7NdQbgyLBztX/+lx+cdWsmduyo/g?=
 =?iso-8859-1?Q?GNIMBFrhrqhKP22rmn0fbaKFUjBke+dJJhcGndYiOrw6580qqrNxOT30ZC?=
 =?iso-8859-1?Q?4amw4FTfkUQPGux9VjFiza7Z6TaYD/nhyS1K9glSu/Kg96LXiVaX4xbm1+?=
 =?iso-8859-1?Q?2A4hh0c74q4I/R6SMRia5Zwh6+a84LyR70?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 06b18ca1-63e1-40f9-0ffa-08de1d05cf5a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB8594.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 07:26:33.4956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 95Pt7nUnok4LSzCETPzrotOD9J/o1SJehsP63yKwf9CUfskewBtwCg3IERMJzrLtQap8oW+Gkb0QhIpV6gHOYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4685
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 3C53940002
X-Stat-Signature: fbhdbdi58i6ikk48dfxuq46him6oe5a4
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762413996-463665
X-HE-Meta: U2FsdGVkX19XkoLm30Vs4kKP0poyNbnpJOjMGkIe1cDl8CRQkpx/LVkHyoYHHr0N80XyyMr7oadehKkgX2jQE0Zq0f8yEgLa5j0T1lw2AweBJ3JM4YYmomgOYd9F3yMAMprY6W+DS5occAesVwn8c+Rbb6rYlKmky/pJ/WnQEfyjK51G+bpXGEYBYuNipeT/8ciqhLvFYuj4bxfjZOs085a4+a2cphk0u+4z+DTxhBJ1ely+NnVRkxRUGejZRp1bDoV/rRCtxP9Cd0RIFSFHFHtwk/p4HUwpYMO9vk802Bf6sV7du7a2vTHbExddqkPD6G18zIqhKPrpulrOx4eF72EzIXB5YLZVdkNa1p8SlnBJCVgP09tpg6BxejIRaMsv63naoZHz1d2L+pqLJfLAWSNxFI9YnOHRBK/VlxqHlEynT7UF9mUzjw/PGzW0mRnlOHeZu37Echihff3xjEn4qwMz/BfGGavPafz+Jjz0MCac5GNHsXX8t5ZANU3vAt6VpMDSMGclgAYWiblXIZ+ex/f27133dBIzbPIrsyXxg82YkegzcbUAI5KO8W96FvqvJ/UFGcWEPVn7qyYvu/QExydk3NbuRTZYatuEqyW4SJWazqvFyGPILen65uvaWfgadfgRZ3Wvj0cPNATmWIshDKrBmdpBfGPyZYfEqt9L73ABm0aGLE5mekLDBeBo8OZNz4Qq29Q+DS/IL7Em7+lColBMsjQxMSBANSIPJIlUREHUtfWPM3GoFDpkG+SFQRuHeR5FpxqG8ioPVJMeu1lK7OPHXxNiRGQNnBE1UQvFARqFi8P0NIP38e7r6661d2Xdov3X/w+dIphw5WeffAxjwnXnxFCpHUmrxyWdyggVllqlv7zJ1XBWmS1NzWIAnBtsJYhFOuGyCMWPgUju85nvUTOhmEgzs6Jp1V4o0FiqE5uS/G44KiQV1KFtUAkrrxtMwGq79M9IFMOZSJI4nJ6
 ZBmj6HQk
 69mDX3DVD56BaGG39if9LTiKaYr5/TAov3uDv7tUZNp5KPbyw/qPpv12cygqueIxKntFwIkRQCN6d8toLkC70elJdjdlGv34P3wT8G+4OPC152VrM3LiJnFXyIp8ol7FKSgGIDmvL/v985Selzpov4mGplBZrq/7qwkufpURsNuAyvLrgiOEwFQJggLA1i1Yl/iIj0G80vnzv9kcq1exSn2gncJ3NdzNDHWSiPhe2k2wBfFjEucZV2vzLmJ702wdf2BFW1kTAaaxLbOitu1k1NlWlKmgwDdSPApISDddvXVEuJxmy84dmbDBZINOpu1x2MGVk+HG2Kloovm1xYg5Qi5Ogvv/oTVSehlmFr++JAOXWn8zea3FUGqvRVemT04nwTmog+LA6rDOqBBclfw537wlkXTVrPs6TpqJiwEl6UdiQVtOawRYA75UhLT5X1++L7noOWP3HyFpptjuf+pGtjSmMzos8lHFwbO91ToV0iLdSdSel2/teLw8lh9A2vUcTx9UeAMtzJtTSegHTh3W6U4tjqkH+/sjWqm0aTn0R1EjbJUXx/t91rj2YpHAleI5bjFjKUTeTOZhptxMnr+S6GhCHlOxWKIh0a1fLVjJQb+gHzu6ykKXa7struAnciK2hvyskwd+KOms5Cs96HFgTNMZVYAyH+TSr6ZA/9xg5v/jGhhU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 3.0% improvement of stress-ng.mmap.ops_per_sec on:


commit: 9b05890a25d9197e39fcf5b2298f0b911c323306 ("maple_tree: Prefilled sheaf conversion and testing")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master


testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: mmap
	cpufreq_governor: performance


In addition to that, the commit also has significant impact on the following tests:

+------------------+-------------------------------------------------------------------------------------------+
| testcase: change | stress-ng: stress-ng.tmpfs.ops_per_sec 3.2% improvement                                   |
| test machine     | 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory |
| test parameters  | cpufreq_governor=performance                                                              |
|                  | nr_threads=100%                                                                           |
|                  | test=tmpfs                                                                                |
|                  | testtime=60s                                                                              |
+------------------+-------------------------------------------------------------------------------------------+



Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251106/202511061420.a984bb7e-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-icl-2sp7/mmap/stress-ng/60s

commit: 
  fdbebab19f ("tools/testing: Add support for prefilled slab sheafs")
  9b05890a25 ("maple_tree: Prefilled sheaf conversion and testing")

fdbebab19f147af6 9b05890a25d9197e39fcf5b2298 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     14.17            -1.3       12.88        mpstat.cpu.all.sys%
     38.05 ±  2%     -22.8%      29.38 ±  2%  mpstat.max_utilization_pct
     13835 ± 11%     -29.9%       9698 ± 19%  perf-c2c.DRAM.local
      4110 ±  4%     -17.7%       3381 ±  7%  perf-c2c.HITM.local
      3.03 ±100%      -3.0        0.00        perf-profile.calltrace.cycles-pp.mas_alloc_nodes.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
      2.72 ±100%      -2.7        0.00        perf-profile.calltrace.cycles-pp.mas_alloc_nodes.mas_preallocate.commit_merge.vma_expand.vma_merge_new_range
      5.78 ±100%      -5.8        0.00        perf-profile.children.cycles-pp.mas_alloc_nodes
   7045634           -10.8%    6283116        meminfo.Memused
    807198 ± 11%     -67.1%     265386        meminfo.SUnreclaim
    429663 ±  2%      -9.9%     387130 ±  2%  meminfo.Shmem
    899957 ± 10%     -60.2%     358148        meminfo.Slab
    417173 ± 41%     -67.2%     136751 ±  4%  numa-meminfo.node0.SUnreclaim
    465472 ± 37%     -60.1%     185577 ± 14%  numa-meminfo.node0.Slab
    390418 ± 30%     -66.8%     129555 ±  5%  numa-meminfo.node1.SUnreclaim
    434877 ± 28%     -60.1%     173494 ± 15%  numa-meminfo.node1.Slab
   5573487 ±  5%     +52.3%    8486524 ±  2%  numa-numastat.node0.local_node
   5603800 ±  4%     +51.8%    8506515 ±  2%  numa-numastat.node0.numa_hit
   5715530 ±  4%     +55.4%    8881057 ±  2%  numa-numastat.node1.local_node
   5752421 ±  4%     +55.2%    8927246 ±  2%  numa-numastat.node1.numa_hit
      0.98 ±  4%      -0.1        0.86        turbostat.C1E%
    802545           -10.7%     716562        turbostat.NMI
    179.86            -1.0%     178.07        turbostat.PkgWatt
     16.46            -1.0%      16.29        turbostat.RAMWatt
    104549 ± 41%     -67.0%      34522 ±  4%  numa-vmstat.node0.nr_slab_unreclaimable
   5603946 ±  4%     +51.8%    8506697 ±  2%  numa-vmstat.node0.numa_hit
   5573633 ±  5%     +52.3%    8486707 ±  2%  numa-vmstat.node0.numa_local
     97906 ± 29%     -66.4%      32924 ±  5%  numa-vmstat.node1.nr_slab_unreclaimable
   5751995 ±  4%     +55.2%    8926887 ±  2%  numa-vmstat.node1.numa_hit
   5715104 ±  4%     +55.4%    8880697 ±  2%  numa-vmstat.node1.numa_local
    273239            +3.0%     281447        stress-ng.mmap.ops
      4554            +3.0%       4690        stress-ng.mmap.ops_per_sec
      9280 ±  3%     -15.9%       7808 ±  3%  stress-ng.time.involuntary_context_switches
   7742463            +2.0%    7893647        stress-ng.time.minor_page_faults
    933.17            -8.8%     850.83        stress-ng.time.percent_of_cpu_this_job_got
    534.72            -9.3%     484.88        stress-ng.time.system_time
    337713            -3.1%     327210        proc-vmstat.nr_active_anon
   1026876            -1.0%    1016123        proc-vmstat.nr_file_pages
    107891 ±  2%     -10.0%      97114 ±  2%  proc-vmstat.nr_shmem
    201980 ± 11%     -67.2%      66273 ±  2%  proc-vmstat.nr_slab_unreclaimable
    337713            -3.1%     327209        proc-vmstat.nr_zone_active_anon
  11358395           +53.5%   17435898        proc-vmstat.numa_hit
  11291191           +53.8%   17369717        proc-vmstat.numa_local
  35250051           +35.6%   47789964        proc-vmstat.pgalloc_normal
   8103365            +1.9%    8259384        proc-vmstat.pgfault
  34497114           +37.2%   47343827        proc-vmstat.pgfree
     13461            +2.4%      13780        proc-vmstat.thp_deferred_split_page
     41345            +2.2%      42260        proc-vmstat.thp_fault_alloc
     13525            +2.4%      13844        proc-vmstat.thp_split_pmd
  28491365            +2.1%   29102247        proc-vmstat.unevictable_pgs_culled
  28491780            +2.1%   29102937        proc-vmstat.unevictable_pgs_mlocked
  28491774            +2.1%   29102933        proc-vmstat.unevictable_pgs_munlocked
  28490836            +2.1%   29101721        proc-vmstat.unevictable_pgs_rescued
      1.87            -6.3%       1.75        perf-stat.i.MPKI
 7.634e+09            -1.2%  7.543e+09        perf-stat.i.branch-instructions
     63.21            -1.7       61.53        perf-stat.i.cache-miss-rate%
  67800530            -6.9%   63093634        perf-stat.i.cache-misses
 1.067e+08            -4.6%  1.018e+08        perf-stat.i.cache-references
      1.08            -6.0%       1.02        perf-stat.i.cpi
 3.949e+10            -7.1%  3.668e+10        perf-stat.i.cpu-cycles
    229.21            -4.5%     218.93        perf-stat.i.cpu-migrations
      0.93            +6.5%       0.99        perf-stat.i.ipc
      1.86            -6.3%       1.75        perf-stat.overall.MPKI
     63.49            -1.5       61.97        perf-stat.overall.cache-miss-rate%
      1.09            -6.5%       1.02        perf-stat.overall.cpi
      0.92            +7.0%       0.99        perf-stat.overall.ipc
 7.516e+09            -1.3%  7.421e+09        perf-stat.ps.branch-instructions
  66736273            -7.0%   62060020        perf-stat.ps.cache-misses
 1.051e+08            -4.7%  1.001e+08        perf-stat.ps.cache-references
  3.89e+10            -7.2%   3.61e+10        perf-stat.ps.cpu-cycles
    226.17            -4.7%     215.61        perf-stat.ps.cpu-migrations


***************************************************************************************************
lkp-icl-2sp8: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-icl-2sp8/tmpfs/stress-ng/60s

commit: 
  fdbebab19f ("tools/testing: Add support for prefilled slab sheafs")
  9b05890a25 ("maple_tree: Prefilled sheaf conversion and testing")

fdbebab19f147af6 9b05890a25d9197e39fcf5b2298 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      1.47 ±  9%      +0.4        1.85 ±  9%  mpstat.cpu.all.soft%
    598993 ± 14%     -36.3%     381625 ± 12%  meminfo.SUnreclaim
    689901 ± 12%     -31.4%     473344 ± 10%  meminfo.Slab
    403.27            -5.2%     382.31        stress-ng.time.system_time
      1800            +3.2%       1859        stress-ng.tmpfs.ops_per_sec
    315677 ± 33%     -37.9%     196080 ± 12%  numa-meminfo.node0.SUnreclaim
   1446782 ±106%     +99.7%    2889569 ± 35%  numa-meminfo.node0.Unevictable
    283500 ± 25%     -34.4%     186029 ± 13%  numa-meminfo.node1.SUnreclaim
    334463 ± 25%     -34.0%     220868 ± 15%  numa-meminfo.node1.Slab
    701526 ±  8%    +216.2%    2218043 ±  3%  numa-numastat.node0.local_node
    731546 ±  7%    +207.8%    2251790 ±  2%  numa-numastat.node0.numa_hit
    686642 ±  5%    +212.7%    2147291        numa-numastat.node1.local_node
    723003 ±  5%    +201.5%    2179707        numa-numastat.node1.numa_hit
     79111 ± 33%     -37.6%      49392 ± 12%  numa-vmstat.node0.nr_slab_unreclaimable
    731773 ±  7%    +207.7%    2251794 ±  2%  numa-vmstat.node0.numa_hit
    701753 ±  8%    +216.1%    2218046 ±  3%  numa-vmstat.node0.numa_local
     71014 ± 25%     -33.7%      47056 ± 13%  numa-vmstat.node1.nr_slab_unreclaimable
    722610 ±  5%    +201.4%    2178261        numa-vmstat.node1.numa_hit
    686249 ±  5%    +212.7%    2145846        numa-vmstat.node1.numa_local
    149703 ± 14%     -36.3%      95370 ± 12%  proc-vmstat.nr_slab_unreclaimable
   1457881 ±  6%    +204.1%    4433426        proc-vmstat.numa_hit
   1391484 ±  6%    +213.9%    4367252        proc-vmstat.numa_local
   2289318 ±  8%    +260.5%    8252931        proc-vmstat.pgalloc_normal
   2045446 ±  8%    +297.0%    8120146        proc-vmstat.pgfree
      6961 ±  2%      -5.1%       6607 ±  2%  proc-vmstat.pgreuse
      9.26 ± 71%      -9.3        0.00        perf-profile.calltrace.cycles-pp.__x64_sys_exit_group.x64_sys_call.do_syscall_64.entry_SYSCALL_64_after_hwframe
      9.26 ± 71%      -9.3        0.00        perf-profile.calltrace.cycles-pp.do_exit.do_group_exit.__x64_sys_exit_group.x64_sys_call.do_syscall_64
      9.26 ± 71%      -9.3        0.00        perf-profile.calltrace.cycles-pp.do_group_exit.__x64_sys_exit_group.x64_sys_call.do_syscall_64.entry_SYSCALL_64_after_hwframe
      9.26 ± 71%      -9.3        0.00        perf-profile.calltrace.cycles-pp.x64_sys_call.do_syscall_64.entry_SYSCALL_64_after_hwframe
      9.26 ± 71%      -9.3        0.00        perf-profile.children.cycles-pp.__x64_sys_exit_group
      9.26 ± 71%      -9.3        0.00        perf-profile.children.cycles-pp.x64_sys_call
      8.13 ± 92%      -4.1        4.05 ±144%  perf-profile.children.cycles-pp.free_pcppages_bulk
      6.31 ± 63%      -0.9        5.42 ±146%  perf-profile.children.cycles-pp.__schedule
      1.99            -5.1%       1.89        perf-stat.i.MPKI
 2.678e+10            +2.2%  2.736e+10        perf-stat.i.branch-instructions
     38.13            -1.1       36.98        perf-stat.i.cache-miss-rate%
 2.698e+08            -2.8%  2.624e+08        perf-stat.i.cache-misses
      1.20            -3.0%       1.16        perf-stat.i.cpi
    730.94 ±  7%     +15.1%     841.39 ±  3%  perf-stat.i.cpu-migrations
    606.32            +2.2%     619.60        perf-stat.i.cycles-between-cache-misses
 1.319e+11            +2.5%  1.352e+11        perf-stat.i.instructions
      0.84            +3.0%       0.87        perf-stat.i.ipc
    149.32            +3.6%     154.64        perf-stat.i.metric.K/sec
   4777975            +3.7%    4952420        perf-stat.i.minor-faults
   4777975            +3.7%    4952420        perf-stat.i.page-faults
      2.05            -5.2%       1.94        perf-stat.overall.MPKI
      1.83            -0.0        1.81        perf-stat.overall.branch-miss-rate%
     38.31            -1.2       37.08        perf-stat.overall.cache-miss-rate%
      1.22            -3.1%       1.19        perf-stat.overall.cpi
    598.57            +2.2%     611.83        perf-stat.overall.cycles-between-cache-misses
      0.82            +3.2%       0.84        perf-stat.overall.ipc
 2.451e+10            +1.6%  2.489e+10        perf-stat.ps.branch-instructions
  2.47e+08            -3.3%  2.388e+08        perf-stat.ps.cache-misses
    671.65 ±  8%     +14.3%     767.68 ±  3%  perf-stat.ps.cpu-migrations
 1.207e+11            +1.9%   1.23e+11        perf-stat.ps.instructions
   4374027            +3.1%    4507555        perf-stat.ps.minor-faults
   4374027            +3.1%    4507555        perf-stat.ps.page-faults





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


