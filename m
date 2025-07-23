Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 136C8C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 08:46:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A139D6B009A; Wed, 23 Jul 2025 04:46:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EC0B6B009C; Wed, 23 Jul 2025 04:46:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DA876B009D; Wed, 23 Jul 2025 04:46:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 723FF6B009A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:46:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E5C511130E0
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:46:48 +0000 (UTC)
X-FDA: 83694898896.30.49BA673
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf02.hostedemail.com (Postfix) with ESMTP id CB5AF80003
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:46:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Aoq5aszf;
	spf=pass (imf02.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753260405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YE1ykVrfaGnMlMxDjp+fh6xXwsDzApulV5yRuH1mv0o=;
	b=pVqFNqcvVxERATyyzizZ9uzPvILy+bVSROhjTfBNgkqMd8OS5XJ1uG6CTlgKsBFYWNpUJ6
	Py8Uuj4X/9hYlrhWibxnYqpvkqyFYgmqH3Rs1reZrYhiD/EWxUtFs34/pyFmKxx3lbFHue
	WnyJsh7tA/tevBbnlpxY2IaOnHPY3Zs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753260405; a=rsa-sha256;
	cv=fail;
	b=TqNfkgXc5WLYq7iMQADma7hWZUoOVKPQ34U2JlNHCYbL6qzygGdoBLh7z22NMDXoeQlcHk
	UE6kuSRn+KHf9pYhPz/TGocMwkvpItLfULkQW3fKuS4NEy3IJL9yh0hpqabTi6uQZoCJQN
	OaG+WLR+3rjkYMZyRejyi3xo5Y/Nw8A=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Aoq5aszf;
	spf=pass (imf02.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753260405; x=1784796405;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=gEA/0Xj4uDw2+zHkVSynyTUXp8AxDRWVnxu41DT7DXo=;
  b=Aoq5aszfNi9MKrgBMbzIMWpUq6ghgTrdt8aN3SW0UV6ps/PX4a0TYEIM
   VGwOvA9wwmu/6YmdceB+YPLK0xSjN2ee40l4NzgpBvcrMuBSfSBmU5jyZ
   OJO5jYa7vvHOMRAxxYsGNqMlQKito3bqITQIxCtAAC4kPOdJBeKRl16FZ
   03HCyZO0fAgtLfLTaoyoIobQ2UNoYXAF4L22aiCu5TAGzUVLGfwAD9g55
   fNGCB3IxRGOp9trt+WFbCdu1KXOY8owRI/tMk6QfeHV6bt9ApDv+t9qSJ
   irGTPand/MqhrvIXwTc9mTwBN774GW6GEKB/GBBjX2qCcvNy5w9/AdTp6
   A==;
X-CSE-ConnectionGUID: emX4UO2IR6quqmq8U5LacQ==
X-CSE-MsgGUID: Wg6g57xQQmW9v6X9jGKCyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="66874233"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="66874233"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 01:46:41 -0700
X-CSE-ConnectionGUID: 2a+gATTOSEO9QS5vjwlMlA==
X-CSE-MsgGUID: s+s2Z/JPTsOaxRURO4BbSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="159768324"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 01:46:41 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 01:46:40 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 23 Jul 2025 01:46:40 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.86)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 01:46:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gVlVnmL+ndQXg57sbdv8zDxfF8elNlFnbC2GH+Uda6Ya0XOUreBtfxw45rHzzEcC9700EyzXRoUVi0ZykclrR5qDhSboKwqKNXLiwsldUk13IN9glKI4PxRDImco8kX/VGdo/VxuMEFiN1JzRHicMaQ0+X/C8OhCmwBvemIP6b2HuV+ULMV6epa40OmSKJlBgzCwOPfHgLYppoLsLkG+N8xJcSFI3d/xGjLjNeVrjK0vO2BDzBKdpeUvF+Z0xgfyxPSUWYhFiK+YhBolK5YB+LE6qvUCey4yVQD6E7Yha6yLJo4/rOip54c6aKc5RxQi34LLaGoqjLfzXgdf80d7Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YE1ykVrfaGnMlMxDjp+fh6xXwsDzApulV5yRuH1mv0o=;
 b=r5NElwFvQYOXkXuh/pwjasL+l9P4buLdKCk+s2INEuIh96KEtCb7qOfo/hTzh7syfFaGjXRrXlCoXY2l933ZY8dO9If2ERB0jFekKYGfngUoQUAI5uXXKRvN+upQ7Pb/neJy+sBhFpjlHGFha/7VglOJSVHovW2wkGOvl/YFNPEkpHtIpAU0bPMX8ZYU+/P8mNwaOSCBnvqrWrjy8HULqjVcvixOuePqitnECPtPA4clImIUU3WTbtAXiCxscJsSQ8gH55pyZlqfyQ/Cx7DuOnNr616n0KvemxWmLSxVuc1kFj7PdgS+fAKqyg8xkxi1PwQtoPE/9Vua7dG2mS89Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SN7PR11MB8110.namprd11.prod.outlook.com (2603:10b6:806:2e1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 23 Jul
 2025 08:46:24 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%3]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 08:46:24 +0000
Date: Wed, 23 Jul 2025 16:46:15 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	<linux-mm@kvack.org>, <ltp@lists.linux.it>, <oliver.sang@intel.com>
Subject: [tip:locking/futex] [futex]  56180dd20c:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/nsproxy.c
Message-ID: <202507231021.dcf24373-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI2PR02CA0035.apcprd02.prod.outlook.com
 (2603:1096:4:195::22) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SN7PR11MB8110:EE_
X-MS-Office365-Filtering-Correlation-Id: 7503bd98-2c45-4c07-118b-08ddc9c567f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?txhw37KVwXu6UTBeP65SrrlBAoFg2kym6egdMX1B72aJ+hNd+evNfyP/F+n9?=
 =?us-ascii?Q?+imA68i3UNN9QZYhUPMM6mv4ON9oIIaG79r/DlyTNQbrjnKIJUgCQNZmkUJ+?=
 =?us-ascii?Q?vrYLwjbe+jGPd11aGFAPqRWjnOWILQQtoSdnGbxgh3nvjQv8xlp9cL3AkNLH?=
 =?us-ascii?Q?Lhgyu6tN7pz8+h5Lq1je7IGrICA+nABbtt8IG6LdwM3+4svgWr9b/wMEAMlX?=
 =?us-ascii?Q?11iH9O81NgKqFVazkaTKfPgsgOsnFyqrQPd4s/E9lPk+A8b8Rj5/RBKSSjfG?=
 =?us-ascii?Q?oJ0eY5yeD/YAG1aRu9fYj5SuH7ip9ZJ3f7ajnvolDk+PMWTCr4219hi75Eb/?=
 =?us-ascii?Q?90HTeBJ5Oe2gMInrE+rFI8a5g/ecgt0EqCT3P5dnHAjNGTnw6AFdGYTrkrRb?=
 =?us-ascii?Q?W9FuM0H9bhXIrCfl/0X/oXdthCNGBKMt7tHRWxtHJqzE3vkFVlTj8xrrFSO7?=
 =?us-ascii?Q?4qlOGGmJlslQ7/P8jMMfaA/QMyjENGv9TxkLK77XqPKq6jtzwe2QBBjE5flI?=
 =?us-ascii?Q?uhLXSdLwH8h36EdIt/8cW9SZNnyJ/lV48g4O7wZsSqZhP6xvtjcGDqGGsslj?=
 =?us-ascii?Q?I8lcnb52lDjfVraQjp/Ib/QmNZKNQOl/5R4HX3VqmGNNFqJz0oMXQvL7ZJP5?=
 =?us-ascii?Q?/9nTcrSDJxFDIgl1QzQJt4MFRkBvRuQYHCmlsBxVAp1sV97IJ97LZ9QaS/mR?=
 =?us-ascii?Q?Orv8EJ8jftwUE9fQ4dtaaeVBVS0yPu8h9fBDIPfQ+T8tqXHrU5eY5D3Gzuhx?=
 =?us-ascii?Q?bArcZaADVlpp4v+UxVqpB2SL6yrhy84rBwmnswJm34sA78ANRVBS7sTK6ceV?=
 =?us-ascii?Q?HB8waA5xy3wfwP4W7rl5WslZhCRVYRdCDzaiBujfVgzfGBRdHKi5ZA+7SCak?=
 =?us-ascii?Q?z3Nv9x32H449V4Q7C7TH+f2fIMEp9/Qi7uen8ZHryxq2N1hHlh7rJQkQDJ1G?=
 =?us-ascii?Q?Apzx5Cp/1mNpoEzyYTkb5ta7usoXRZ/5GfbKQ+Uy/Z4s+jz5xpYcrdzw2/Zx?=
 =?us-ascii?Q?Mu9Xl7RKY9peF6Y29wqjez99519zpFLw7bMs7kAeLWvaNzMlIYJPLq5hbhVn?=
 =?us-ascii?Q?OHWpiJ/VvyOKSo3/oNDdlJNwyaZU5BK9fHrh6WEOJ/ov/jAJFqvoqA9NNI7x?=
 =?us-ascii?Q?eo8OhapPy9mMn7/9IgGdvrbwr8JYkXaJrbxSLILxUXP9IblBvV4sJ9eSZgS+?=
 =?us-ascii?Q?kSli+RYmmHpaRSh6HqnANq2T1C0TsagJi1ko++BBR3AoYN+fp01xrIJhshyS?=
 =?us-ascii?Q?Gb9vAqBIhqmyOKiYQ2sM3VSPzeQ4omnE1eJvrFOTCIWAl6wXl+dVac9j50u+?=
 =?us-ascii?Q?Bhb3bYpm9FrXQChvBqYnSDdxqsEfYLpta7eEJON3v97bLaNKhZgNfouvT13M?=
 =?us-ascii?Q?S+sbxo9e497nboihL4lVDVjW8/pm?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V9JMNJgmAEcHzBi3KKWUq/kHtrswFx2hBOE3QrAbrnENZ7o6juFVg23kPje8?=
 =?us-ascii?Q?/AwmPzpEcubh2FKCgGbPcnk9NeMQCoW8+QYNDTCGsaQ/MoesHfBcLg5sdIij?=
 =?us-ascii?Q?OY131AvjtA3opo6QjBShfQnP5+FaR0y95twSPiy97AVdvgWHcQsL4vY1nUId?=
 =?us-ascii?Q?Y5QQHjEMYYiH6rD2QM4UPKROURtWnJYoNCfxHaBryXISSCV381VDrR8UXr+c?=
 =?us-ascii?Q?72f9flDSVfSJoEPUeyH/elaQ+srZfd0q9I1sd/OXh5RzvuonDU2hyuacjBRa?=
 =?us-ascii?Q?Ill3/u0NUndiTQadEg8nvrSgEEni+Dp57yViMa+K3tJGs8B6Mky/T6jJjC1G?=
 =?us-ascii?Q?4fDHY4EFYkMUbvGyJ3HrI+CxggSrZDYdQymoIsXLqPpGGsr86dABpT9iiSKy?=
 =?us-ascii?Q?IdI3aVLtek0KIGjYC7ZchZ/6Cv6QPM499osnctP74Nfy3jEW3OG6k4st5Vmj?=
 =?us-ascii?Q?vt3pEhNiR7nlZspyslSTI4IkoEeb7rdHOGLIOrRdHZpFoEMzZpVyUUuMzV8Y?=
 =?us-ascii?Q?zhauFZSBuis1lr5MGDVH9/iMqLrYlzW8q7/CxybgFdgVmP4j2IHCgej83y+F?=
 =?us-ascii?Q?D1ArLEyIeeCwbuEMyp6xH39Ah5mbhSF0IX01VS10+NGOklEHkstw0yj9z49t?=
 =?us-ascii?Q?3jBzaeyVastKzLaRHdOaebFFhup/MGhbK8QEcTJfctjQqrMS3BKeLWxCPcAH?=
 =?us-ascii?Q?nwgEBuhOfmSqU6dqo5zee0DYQdP22Emn4PalCikoMuqWmXiDJWbUm2z5Dwdo?=
 =?us-ascii?Q?Uh8xIvaqd7GLE1YCplVZXLkxIRr/FTm5zU6CKQceXQ4bF8GBA6UwS7+Y2rK5?=
 =?us-ascii?Q?doYmelTH3AEaYAtbGIhYGWTAF+/2ILiUTQQdgR5TKuyjm6dtU0yLz3zAvOh3?=
 =?us-ascii?Q?bRQ4BF7TglvpMwfroFg1vHZqOu1XwAT0665/tZpbFdQ5qRLpA+y3gW6c/+27?=
 =?us-ascii?Q?BOdivMiiKqmOAbS1Hl1eMdTm3Q7fUdXXf6gygh2DAigN0bkUXpKHb3EBINHE?=
 =?us-ascii?Q?KiGhoErCcWUkcXxmSP7QiH6KYCv/EcNRrviWusMngFRMUBWNyXfwR+iC41i+?=
 =?us-ascii?Q?e67OJrvFAY1jSJAovE4/h6Ilx8V6ZbIYHAY0MWgWSKqlsV0N3xKIbqItJ+hR?=
 =?us-ascii?Q?njDoc9G4DByIZKTbkwgC9tE3axxahU8QpnY7cHdeWKAqf2Dc8d298XhSto/2?=
 =?us-ascii?Q?+Iovhrc7oWuFzLmHnx10FE6LwZjdkGsH71ESdmwFDW1TViHorAVwFynEccvk?=
 =?us-ascii?Q?xxUE+Pmo7fVNnziUPCKUo+dMc1UeDcA7woFvjUlwm8pLNj66XIOQqkGC6byH?=
 =?us-ascii?Q?z5xxWiFi7cvcONaZXcoQTQ/JVDJNKMRVfLaTmJDiFY79SDBGfj6aeDqK5Ckd?=
 =?us-ascii?Q?TKWCQN/0QWbPP5e8Resc+ZsK9ezdfkwcriWo8nqzoF9EQL6I1WmQiX4F/bls?=
 =?us-ascii?Q?uBQo2nvdn5n0h2wJSwL+LhMy1fQ0ZW34AmB6rz3fVHrMjNoh01PBtD/Xdl05?=
 =?us-ascii?Q?GwsRtFECEq06Bvzd+3hqOsPNJ/KkJ5evaUO8yEgrZ7o22GvtgdnEoVdQYK+i?=
 =?us-ascii?Q?/uwMZo/CbV3F3AMAjT9HaP6oijo9quASI2W1aG3QRo6IMOIHCBvgN9IhRgIr?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7503bd98-2c45-4c07-118b-08ddc9c567f8
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 08:46:24.7729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v33Z0FggZ97JwZaYrc3Ild53Z/0gzXMLbeqd3MGhUaxwuI/D52RcICtXeN3pAEj2+vh8SdZaLUf0jkHADfOyuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8110
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CB5AF80003
X-Stat-Signature: 5cjrtaarxoodcmsfddu51z95hq5fzxxz
X-Rspam-User: 
X-HE-Tag: 1753260404-623810
X-HE-Meta: U2FsdGVkX18bmD6ktlZN80Mfs+9DAnPYV8qGjopKi3FdxabjPuAq6DJCXmD4ClmVhsbJ5dvoA2P61e+G0XbKOvS+mTzeqvAJblrRNyC5c0KVM5rV71qgeNi3Mg2mMtzaZq8R8p4iOZV02pCu24eJSxzc8dy7zI/Yl4Z37USSFI0d1Vs3xCjJ4dCXFxsGIk1w6ER651DPp7ZbKwuJL+l8Hf4+DnDp5obKsU+KKK5MjcoASQ0Eak650B2WZdiy714Iut7cpUrve8uD9YOwnAddnRSmzMyirkWITd2JMdccz/UHTfQhohNxo9tdlKTMd4gLYo6A7mct5353Lgi/THT1qjynZTKokv+gwnND3V19KVThaAVInsT7kpCNSiCrRZvshzrInVHHkZb+UKVK/165aeBLQuFFRG90OTRc62xujEPS0cZA4gS9m7OPFjaCsSSB0SX1aPt7gWneX6tKQYrQBHvCNYBJGR3VI6qKfRUuNUdePmJlbA4/eSBtRXRcZsJdt7dFH4POpaltayieTXYvyHPP257Ym1Lx+nOZCVT2+1WQqCUaydblLkpSlG4bWnrB52U+X+YVAiVabb97HXNM+Ezspe3PybI53Ft7mMDz0yxzWsrbpTRSrl8lQ3/GaJTDGK29eDeBcUmrEysJjFg2PGaJePLZ29lUgw3wcWsCZbQezMcg5BEAsrgOjvVwahOTkI3hoeT9vBtJHXMCAzW8d6EnZaf1uC/vCnAaa1Bqyi89gfMol5X6Fv/2lZ1Lul9i2gJ8pH0Oe6m7Tww3hipj7ziJMbbO7lEluRUZWsft3w8o6/jzibhR16DQaT7nHXyHItzQ8MHCfCLqc69QoutLJVvDmUgDY+5kMyNTICQ0ls0BVrMdNXq4DNWVJznlEFWpP4SjTG3R24w7rqbGUi6QFVPAaC1kvrEQIJT7RXHMVeM2ixAE+b5I9b1ebXOPsbNxaUx6SJMUSJhA022LOI8
 k8wCTsZs
 mqfYrPTViBW2Wd828tnwEDmTZpGyV7syN0hiSeP0izJLarewqsg+lKztw53K3X0V8g1l5l/7qmYsA7dBqER3OO9uGScl/eNUc/wNO1nhXyAvWa0If5qeFNu3jzFulikaJTjupRzftkeUit+KjwDKYtDsjw/sSeUQ9y2TPGi9rpVoXyeq25k8VSiJzxAbAp/K68gJUacwBRVhNhC3n8tIu5pZ4luOlobyXFk2kdN9qhDtqYf/KWfIudespGukdjB9Ng+rkFn0rbuXsLBRsPEU0lFJ65fUMeHEHuAVyhBYPVVn0jHJzXxvjDzDHfOzLqgUyOELbz86I4wHXWat9+OfDd2FTy30yStZaUEQI8v0l375MwOniBx99YJL8qG4JSI/DziWYujTW0fASyVestPtjyexbUij+btmPpAgUH0TqiuVjN0YD/dbqOSJYcMTQ4nHGeHFifiNmTa/ZIjXpU9rmNpDX+4mFStCPQ6NRC14IX9D0DUSyWsmE2i50+gpw4vaYxtbuPrW0/6adbUHRJKFUQBt92kjpXbG+ugEvnnPJxgL05wpVmHZ7A2dfUD9n0FtzLmV3F9WZwjX66sjYy/wfsXLNCwrIelYyQq5nZr764bOqUJ65HclRs5QICQAjb+NIIth2+tUIvlPXIsazM8YdJ1rZPRwTo72X4gLbTyJ3KhSbdL4ld49pP32PasI63tVHW2pO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "BUG:sleeping_function_called_from_invalid_context_at_kernel/nsproxy.c" on:

commit: 56180dd20c19e5b0fa34822997a9ac66b517e7b3 ("futex: Use RCU-based per-CPU reference counting instead of rcuref_t")
https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git locking/futex

[test failed on linux-next/master 97987520025658f30bb787a99ffbd9bbff9ffc9d]

in testcase: ltp
version: ltp-x86_64-81ba405df-1_20250719
with following parameters:

	test: mm-oom



config: x86_64-rhel-9.4-ltp
compiler: gcc-12
test machine: 104 threads 2 sockets (Skylake) with 192G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)


the issue (1)(2) happen randomly upon 56180dd20c.

a255b78d14324f8a 56180dd20c19e5b0fa34822997a
---------------- ---------------------------
       fail:runs  %reproduction    fail:runs
           |             |             |
           :50          48%          24:50    dmesg.BUG:scheduling_while_atomic    <---- (2)
           :50          48%          24:50    dmesg.BUG:sleeping_function_called_from_invalid_context_at_kernel/nsproxy.c   <---- (1)
         50:50           0%          50:50    dmesg.Mem-Info
         50:50           0%          50:50    dmesg.invoked_oom-killer:gfp_mask=0x



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202507231021.dcf24373-lkp@intel.com


[  286.673775][   C97] BUG: sleeping function called from invalid context at kernel/nsproxy.c:233   <---- (1)
[  286.673784][   C97] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 6748, name: oom03
[  286.673787][   C97] preempt_count: 7ffffffe, expected: 0
[  286.673790][   C97] RCU nest depth: 0, expected: 0
[  286.673794][   C97] CPU: 97 UID: 0 PID: 6748 Comm: oom03 Not tainted 6.16.0-rc5-00002-g56180dd20c19 #1 PREEMPT(voluntary)
[  286.673801][   C97] Call Trace:
[  286.673803][   C97]  <TASK>
[ 286.673805][ C97] dump_stack_lvl (lib/dump_stack.c:123 (discriminator 1)) 
[ 286.673817][ C97] __might_resched (kernel/sched/core.c:8806) 
[ 286.673824][ C97] ? free_pid (kernel/pid.c:147) 
[ 286.673830][ C97] switch_task_namespaces (include/linux/kernel.h:61 kernel/nsproxy.c:233) 
[ 286.673836][ C97] copy_process (kernel/fork.c:2450) 
[ 286.673846][ C97] ? __pfx_copy_process (kernel/fork.c:1922) 
[ 286.673851][ C97] ? _inline_copy_from_user (arch/x86/include/asm/uaccess_64.h:134 arch/x86/include/asm/uaccess_64.h:134 arch/x86/include/asm/uaccess_64.h:141 include/linux/uaccess.h:178) 
[ 286.673859][ C97] ? copy_clone_args_from_user (include/linux/uaccess.h:401 kernel/fork.c:2771) 
[ 286.673865][ C97] kernel_clone (include/linux/random.h:26 kernel/fork.c:2604) 
[ 286.673870][ C97] ? __pfx_kernel_clone (kernel/fork.c:2563) 
[ 286.673877][ C97] __do_sys_clone3 (kernel/fork.c:2907) 
[ 286.673880][ C97] ? __pfx___do_sys_clone3 (kernel/fork.c:2887) 
[ 286.673886][ C97] ? _raw_spin_lock_irq (arch/x86/include/asm/atomic.h:107 include/linux/atomic/atomic-arch-fallback.h:2170 include/linux/atomic/atomic-instrumented.h:1302 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:120 kernel/locking/spinlock.c:170) 
[ 286.673892][ C97] ? __pfx__raw_spin_lock_irq (kernel/locking/spinlock.c:169) 
[ 286.673897][ C97] ? recalc_sigpending (arch/x86/include/asm/bitops.h:206 arch/x86/include/asm/bitops.h:238 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/thread_info.h:126 kernel/signal.c:180) 
[ 286.673902][ C97] ? sigprocmask (kernel/signal.c:3259) 
[ 286.673906][ C97] ? __pfx_sigprocmask (kernel/signal.c:3236) 
[ 286.673910][ C97] ? wake_up_q (arch/x86/include/asm/atomic.h:93 include/linux/atomic/atomic-arch-fallback.h:949 include/linux/atomic/atomic-instrumented.h:401 include/linux/refcount.h:389 include/linux/refcount.h:432 include/linux/refcount.h:450 include/linux/sched/task.h:134 kernel/sched/core.c:1082) 
[ 286.673916][ C97] do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94) 
[ 286.673923][ C97] ? __x64_sys_rt_sigprocmask (kernel/signal.c:3341 kernel/signal.c:3318 kernel/signal.c:3318) 
[ 286.673928][ C97] ? __pfx_rwsem_wake+0x10/0x10 
[ 286.673934][ C97] ? __pfx___x64_sys_rt_sigprocmask (kernel/signal.c:3318) 
[ 286.673938][ C97] ? handle_mm_fault (mm/memory.c:6254 mm/memory.c:6407) 
[ 286.673948][ C97] ? do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94) 
[ 286.673953][ C97] ? exc_page_fault (arch/x86/include/asm/irqflags.h:37 arch/x86/include/asm/irqflags.h:114 arch/x86/mm/fault.c:1484 arch/x86/mm/fault.c:1532) 
[ 286.673958][ C97] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130) 
[  286.673963][   C97] RIP: 0033:0x7fd4206da889
[ 286.673967][ C97] Code: 31 ed e9 44 ff ff ff e8 25 e9 00 00 0f 1f 44 00 00 b8 ea ff ff ff 48 85 ff 74 2c 48 85 d2 74 27 49 89 c8 b8 b3 01 00 00 0f 05 <48> 85 c0 7c 18 74 01 c3 31 ed 48 83 e4 f0 4c 89 c7 ff d2 48 89 c7
All code
========
   0:	31 ed                	xor    %ebp,%ebp
   2:	e9 44 ff ff ff       	jmp    0xffffffffffffff4b
   7:	e8 25 e9 00 00       	call   0xe931
   c:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  11:	b8 ea ff ff ff       	mov    $0xffffffea,%eax
  16:	48 85 ff             	test   %rdi,%rdi
  19:	74 2c                	je     0x47
  1b:	48 85 d2             	test   %rdx,%rdx
  1e:	74 27                	je     0x47
  20:	49 89 c8             	mov    %rcx,%r8
  23:	b8 b3 01 00 00       	mov    $0x1b3,%eax
  28:	0f 05                	syscall
  2a:*	48 85 c0             	test   %rax,%rax		<-- trapping instruction
  2d:	7c 18                	jl     0x47
  2f:	74 01                	je     0x32
  31:	c3                   	ret
  32:	31 ed                	xor    %ebp,%ebp
  34:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
  38:	4c 89 c7             	mov    %r8,%rdi
  3b:	ff d2                	call   *%rdx
  3d:	48 89 c7             	mov    %rax,%rdi

Code starting with the faulting instruction
===========================================
   0:	48 85 c0             	test   %rax,%rax
   3:	7c 18                	jl     0x1d
   5:	74 01                	je     0x8
   7:	c3                   	ret
   8:	31 ed                	xor    %ebp,%ebp
   a:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
   e:	4c 89 c7             	mov    %r8,%rdi
  11:	ff d2                	call   *%rdx
  13:	48 89 c7             	mov    %rax,%rdi
[  286.673970][   C97] RSP: 002b:00007ffe10129188 EFLAGS: 00000206 ORIG_RAX: 00000000000001b3
[  286.673975][   C97] RAX: ffffffffffffffda RBX: 00007fd420659ef0 RCX: 00007fd4206da889
[  286.673978][   C97] RDX: 00007fd420659ef0 RSI: 0000000000000058 RDI: 00007ffe101291d0
[  286.673981][   C97] RBP: 00007fba8a9ff6c0 R08: 00007fba8a9ff6c0 R09: 00007ffe101292c7
[  286.673983][   C97] R10: 0000000000000008 R11: 0000000000000206 R12: ffffffffffffff78
[  286.673986][   C97] R13: 0000000000000000 R14: 00007ffe101291d0 R15: 00007fba8a1ff000
[  286.673991][   C97]  </TASK>
[  286.674639][   C97] BUG: scheduling while atomic: oom03/6748/0x7fffffff        <-------- (2)
[  286.674642][   C97] Modules linked in: intel_rapl_msr intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common skx_edac skx_edac_common nfit libnvdimm btrfs blake2b_generic xor zstd_compress raid6_pq x86_pkg_temp_thermal intel_powerclamp sd_mod sg coretemp kvm_intel irdma kvm snd_pcm irqbypass ghash_clmulni_intel ice snd_timer rapl snd ast ahci intel_cstate gnss soundcore libahci drm_client_lib ib_uverbs nvme mei_me ipmi_ssif drm_shmem_helper intel_uncore ib_core pcspkr acpi_power_meter i2c_i801 nvme_core ioatdma libata drm_kms_helper mei ipmi_si lpc_ich i2c_smbus intel_pch_thermal acpi_ipmi wmi dca ipmi_devintf ipmi_msghandler acpi_pad joydev binfmt_misc drm fuse loop dm_mod ip_tables
[  286.674732][   C97] CPU: 97 UID: 0 PID: 6748 Comm: oom03 Tainted: G        W           6.16.0-rc5-00002-g56180dd20c19 #1 PREEMPT(voluntary)
[  286.674738][   C97] Tainted: [W]=WARN
[  286.674740][   C97] Call Trace:
[  286.674742][   C97]  <TASK>
[ 286.674744][ C97] dump_stack_lvl (lib/dump_stack.c:123 (discriminator 1)) 
[ 286.674748][ C97] __schedule_bug (kernel/sched/core.c:5958) 
[ 286.674753][ C97] ? enqueue_task_fair (kernel/sched/fair.c:7030) 
[ 286.674760][ C97] schedule_debug (arch/x86/include/asm/preempt.h:34 kernel/sched/core.c:5985) 
[ 286.674765][ C97] __schedule (arch/x86/include/asm/jump_label.h:36 include/linux/jump_label.h:208 kernel/sched/features.h:66 kernel/sched/core.c:6689) 
[ 286.674770][ C97] ? __pfx___resched_curr (kernel/sched/core.c:1094) 
[ 286.674774][ C97] ? set_next_entity (kernel/sched/fair.c:892 kernel/sched/fair.c:5553) 
[ 286.674779][ C97] ? __pfx___schedule (kernel/sched/core.c:6667) 
[ 286.674783][ C97] ? mod_memcg_state (arch/x86/include/asm/atomic.h:23 include/linux/atomic/atomic-arch-fallback.h:457 include/linux/atomic/atomic-instrumented.h:33 mm/memcontrol.c:562 mm/memcontrol.c:587 mm/memcontrol.c:566 mm/memcontrol.c:707) 
[ 286.674792][ C97] ? _raw_spin_lock_irqsave (arch/x86/include/asm/atomic.h:107 include/linux/atomic/atomic-arch-fallback.h:2170 include/linux/atomic/atomic-instrumented.h:1302 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:111 kernel/locking/spinlock.c:162) 
[ 286.674796][ C97] ? __pfx__raw_spin_lock_irqsave (kernel/locking/spinlock.c:161) 
[ 286.674800][ C97] ? __memcg_kmem_uncharge_page (include/linux/percpu-refcount.h:174 include/linux/percpu-refcount.h:332 include/linux/percpu-refcount.h:351 include/linux/memcontrol.h:782 include/linux/memcontrol.h:779 mm/memcontrol.c:2872) 
[ 286.674805][ C97] ? do_task_dead (kernel/sched/core.c:6802) 
[ 286.674810][ C97] do_task_dead (kernel/sched/core.c:6808 (discriminator 15)) 
[ 286.674814][ C97] do_exit (include/trace/events/sched.h:335 include/trace/events/sched.h:335 kernel/exit.c:941) 
[ 286.674818][ C97] ? __pfx_do_exit (kernel/exit.c:897) 
[ 286.674821][ C97] ? task_work_run (kernel/task_work.c:230 (discriminator 1)) 
[ 286.674825][ C97] ? _raw_spin_lock_irq (arch/x86/include/asm/atomic.h:107 include/linux/atomic/atomic-arch-fallback.h:2170 include/linux/atomic/atomic-instrumented.h:1302 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:120 kernel/locking/spinlock.c:170) 
[ 286.674831][ C97] do_group_exit (kernel/exit.c:1086) 
[ 286.674835][ C97] get_signal (include/linux/list.h:218 include/linux/list.h:287 kernel/signal.c:704 kernel/signal.c:2912) 
[ 286.674840][ C97] ? __do_sys_clone3 (kernel/fork.c:2907) 
[ 286.674843][ C97] ? __pfx___do_sys_clone3 (kernel/fork.c:2887) 
[ 286.674847][ C97] ? __pfx_get_signal (kernel/signal.c:2800) 
[ 286.674852][ C97] arch_do_signal_or_restart (arch/x86/kernel/signal.c:337) 
[ 286.674858][ C97] ? __pfx_arch_do_signal_or_restart (arch/x86/kernel/signal.c:334) 
[ 286.674862][ C97] ? __pfx__raw_spin_lock_irq (kernel/locking/spinlock.c:169) 
[ 286.674867][ C97] ? recalc_sigpending (arch/x86/include/asm/bitops.h:206 arch/x86/include/asm/bitops.h:238 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/thread_info.h:126 kernel/signal.c:180) 
[ 286.674871][ C97] ? sigprocmask (kernel/signal.c:3259) 
[ 286.674875][ C97] ? __pfx_sigprocmask (kernel/signal.c:3236) 
[ 286.674879][ C97] exit_to_user_mode_loop (kernel/entry/common.c:113) 
[ 286.674884][ C97] do_syscall_64 (include/linux/entry-common.h:330 include/linux/entry-common.h:414 include/linux/entry-common.h:449 arch/x86/entry/syscall_64.c:100) 
[ 286.674889][ C97] ? __x64_sys_rt_sigprocmask (kernel/signal.c:3341 kernel/signal.c:3318 kernel/signal.c:3318) 
[ 286.674892][ C97] ? __pfx_rwsem_wake+0x10/0x10 
[ 286.674897][ C97] ? __pfx___x64_sys_rt_sigprocmask (kernel/signal.c:3318) 
[ 286.674901][ C97] ? handle_mm_fault (mm/memory.c:6254 mm/memory.c:6407) 
[ 286.674907][ C97] ? do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94) 
[ 286.674913][ C97] ? exc_page_fault (arch/x86/include/asm/irqflags.h:37 arch/x86/include/asm/irqflags.h:114 arch/x86/mm/fault.c:1484 arch/x86/mm/fault.c:1532) 
[ 286.674917][ C97] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130) 
[  286.674921][   C97] RIP: 0033:0x7fd4206da889
[ 286.674924][ C97] Code: Unable to access opcode bytes at 0x7fd4206da85f.

Code starting with the faulting instruction
===========================================
[  286.674926][   C97] RSP: 002b:00007ffe10129188 EFLAGS: 00000206 ORIG_RAX: 00000000000001b3
[  286.674929][   C97] RAX: fffffffffffffff4 RBX: 00007fd420659ef0 RCX: 00007fd4206da889
[  286.674932][   C97] RDX: 00007fd420659ef0 RSI: 0000000000000058 RDI: 00007ffe101291d0
[  286.674934][   C97] RBP: 00007fba8a9ff6c0 R08: 00007fba8a9ff6c0 R09: 00007ffe101292c7
[  286.674936][   C97] R10: 0000000000000008 R11: 0000000000000206 R12: ffffffffffffff78
[  286.674939][   C97] R13: 0000000000000000 R14: 00007ffe101291d0 R15: 00007fba8a1ff000
[  286.674944][   C97]  </TASK>
[  286.705993][ T6788] oom03 invoked oom-killer: gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=0
[  286.707733][ T1358]
[  286.709933][ T6788] CPU: 48 UID: 0 PID: 6788 Comm: oom03 Tainted: G        W           6.16.0-rc5-00002-g56180dd20c19 #1 PREEMPT(voluntary)
[  286.709942][ T6788] Tainted: [W]=WARN
[  286.709944][ T6788] Call Trace:
[  286.709946][ T6788]  <TASK>
[ 286.709948][ T6788] dump_stack_lvl (lib/dump_stack.c:123 (discriminator 1)) 
[ 286.709956][ T6788] dump_header (mm/oom_kill.c:74 mm/oom_kill.c:468) 
[ 286.709964][ T6788] oom_kill_process (mm/oom_kill.c:450 mm/oom_kill.c:1041) 
[ 286.709970][ T6788] out_of_memory (mm/oom_kill.c:1180 (discriminator 4)) 
[ 286.709975][ T6788] ? __pfx_out_of_memory (mm/oom_kill.c:1113) 
[ 286.709980][ T6788] ? try_to_free_mem_cgroup_pages (include/linux/sched/mm.h:339 include/linux/sched/mm.h:440 mm/vmscan.c:6710) 
[ 286.709989][ T6788] mem_cgroup_out_of_memory (mm/memcontrol.c:1654) 
[ 286.709998][ T6788] ? __pfx_mem_cgroup_out_of_memory (mm/memcontrol.c:1634) 
[ 286.710005][ T6788] ? cgroup_file_notify (kernel/cgroup/cgroup.c:4570) 
[ 286.710012][ T6788] try_charge_memcg (mm/memcontrol.c:1677 mm/memcontrol.c:2404) 
[ 286.710018][ T6788] ? __pfx_try_charge_memcg (mm/memcontrol.c:2306) 
[ 286.710023][ T6788] ? folio_alloc_mpol_noprof (arch/x86/include/asm/bitops.h:206 arch/x86/include/asm/bitops.h:238 include/asm-generic/bitops/instrumented-non-atomic.h:142 include/linux/page-flags.h:867 include/linux/page-flags.h:888 mm/internal.h:755 mm/mempolicy.c:2444) 
[ 286.710029][ T6788] ? vma_alloc_folio_noprof (mm/mempolicy.c:2473) 
[ 286.710034][ T6788] charge_memcg (mm/memcontrol.c:4771) 
[ 286.710039][ T6788] __mem_cgroup_charge (include/linux/cgroup_refcnt.h:78 mm/memcontrol.c:4788) 
[ 286.710044][ T6788] alloc_anon_folio (mm/memory.c:1073 mm/memory.c:5014) 
[ 286.710050][ T6788] ? __folio_batch_add_and_move (arch/x86/include/asm/atomic.h:23 include/linux/atomic/atomic-arch-fallback.h:457 include/linux/atomic/atomic-instrumented.h:33 include/linux/swap.h:391 mm/swap.c:195) 
[ 286.710058][ T6788] do_anonymous_page (mm/memory.c:5071) 
[ 286.710063][ T6788] ? ___pte_offset_map (include/linux/pgtable.h:347 include/linux/pgtable.h:624 mm/pgtable-generic.c:289) 
[ 286.710070][ T6788] handle_pte_fault (mm/memory.c:6069) 
[ 286.710074][ T6788] ? reweight_entity (kernel/sched/fair.c:3836) 
[ 286.710079][ T6788] ? __pfx_handle_pte_fault (mm/memory.c:6026) 
[ 286.710083][ T6788] ? __pfx_run_posix_cpu_timers (kernel/time/posix-cpu-timers.c:1403) 
[ 286.710091][ T6788] __handle_mm_fault (mm/memory.c:6212) 
[ 286.710096][ T6788] ? __update_blocked_fair (kernel/sched/fair.c:9813) 
[ 286.710100][ T6788] ? __pfx___handle_mm_fault (mm/memory.c:6121) 
[ 286.710109][ T6788] handle_mm_fault (mm/memory.c:6381) 
[ 286.710113][ T6788] ? irqtime_account_irq (kernel/sched/cputime.c:64) 
[ 286.710118][ T6788] do_user_addr_fault (arch/x86/mm/fault.c:1337) 
[ 286.710127][ T6788] exc_page_fault (arch/x86/include/asm/irqflags.h:37 arch/x86/include/asm/irqflags.h:114 arch/x86/mm/fault.c:1484 arch/x86/mm/fault.c:1532) 
[ 286.710132][ T6788] asm_exc_page_fault (arch/x86/include/asm/idtentry.h:574) 
[  286.710136][ T6788] RIP: 0033:0x5597027a6fc8
[ 286.710139][ T6788] Code: f4 ff ff 48 83 f8 ff 0f 84 96 00 00 00 48 89 c5 41 83 fc 02 74 2c 41 83 fc 03 74 6e e8 91 fc ff ff 31 d2 48 98 0f 1f 44 00 00 <c6> 44 15 00 07 48 01 c2 48 39 d3 7f f3 31 c0 5b 5d 41 5c c3 0f 1f
All code
========
   0:	f4                   	hlt
   1:	ff                   	(bad)
   2:	ff 48 83             	decl   -0x7d(%rax)
   5:	f8                   	clc
   6:	ff 0f                	decl   (%rdi)
   8:	84 96 00 00 00 48    	test   %dl,0x48000000(%rsi)
   e:	89 c5                	mov    %eax,%ebp
  10:	41 83 fc 02          	cmp    $0x2,%r12d
  14:	74 2c                	je     0x42
  16:	41 83 fc 03          	cmp    $0x3,%r12d
  1a:	74 6e                	je     0x8a
  1c:	e8 91 fc ff ff       	call   0xfffffffffffffcb2
  21:	31 d2                	xor    %edx,%edx
  23:	48 98                	cltq
  25:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  2a:*	c6 44 15 00 07       	movb   $0x7,0x0(%rbp,%rdx,1)		<-- trapping instruction
  2f:	48 01 c2             	add    %rax,%rdx
  32:	48 39 d3             	cmp    %rdx,%rbx
  35:	7f f3                	jg     0x2a
  37:	31 c0                	xor    %eax,%eax
  39:	5b                   	pop    %rbx
  3a:	5d                   	pop    %rbp
  3b:	41 5c                	pop    %r12
  3d:	c3                   	ret
  3e:	0f                   	.byte 0xf
  3f:	1f                   	(bad)

Code starting with the faulting instruction
===========================================
   0:	c6 44 15 00 07       	movb   $0x7,0x0(%rbp,%rdx,1)
   5:	48 01 c2             	add    %rax,%rdx
   8:	48 39 d3             	cmp    %rdx,%rbx
   b:	7f f3                	jg     0x0
   d:	31 c0                	xor    %eax,%eax
   f:	5b                   	pop    %rbx
  10:	5d                   	pop    %rbp
  11:	41 5c                	pop    %r12
  13:	c3                   	ret
  14:	0f                   	.byte 0xf
  15:	1f                   	(bad)


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250723/202507231021.dcf24373-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


