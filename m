Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3661DD10375
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 06:09:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74D306B000E; Thu, 27 Nov 2025 01:09:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D6C56B0010; Thu, 27 Nov 2025 01:09:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 576C36B0011; Thu, 27 Nov 2025 01:09:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2EB6B000E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 01:09:48 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97D6513BDB0
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:09:47 +0000 (UTC)
X-FDA: 84155360814.07.C82FDD8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf18.hostedemail.com (Postfix) with ESMTP id 86F271C0004
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:09:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WseWrNoU;
	spf=pass (imf18.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764223784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6J6jkMwHx9IjuGOANXTvI98pnX10rHdkUua+6v9p8Vg=;
	b=IktlCpuitYIu2ZqJhSd48jhaW0CiRqrCRk5Pd2+IM2De5ZIXdz0Jb34TQxWtyBG0Dxdz45
	jQMykI9pZr3cAwoShsp7lXKyCE7Q3hvV9LNoy3trM2gGpOy4rK/+ThloDGOdd9w2HI1ROn
	Th4rA36R9heNxj8zrWjwPl0OdVN0dj0=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WseWrNoU;
	spf=pass (imf18.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764223784; a=rsa-sha256;
	cv=fail;
	b=VAhCLfdcISbMDULNqKq7nVBXT5wROvZuUeuryUqNbPnggcRKnSTuljqCkPJhLvgww+d5mE
	KADuazPnFctBh6tOIC4tLMcZBDVTBQ4kAQqN8KH0z2rKIK+RQq45qCKztpAa6Y/ay5OQqU
	V6EhD2Dhe7epm2cjFWgeocQFaqf0H6Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764223783; x=1795759783;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=0Z4cHs5HU0oBqmyhGXbVbp+I2G1IRthOZdb96xq8pNs=;
  b=WseWrNoUPGB+20aDw2vzFFxcQ2jhvY+OIo2AWTaFSbBYodnHjF58z/DF
   OTw+Iq3q7OOJ71ZR6613TMjqEvzrAoevrkyQPNJWSIXa++uWyy9X9f1fW
   kbXzV6dN71O9NXYzNvyFoZOwtz3mc5MPSjnCqZBEwa4+CvvBdQK76wDed
   LE2UlAHOCDiu61EVyuevpzR6by2gDwLm5cAqL6IrPkjkU154jBuq+bCWk
   B95vl8KYaOy+lCBH4mgIHSRnm7+XwyW8SS6wQ89rJaOrMOgvtN9QJr0zz
   otJBUJm8sk295c1GLQF6h60IvidbYG3er6VsXn+cgVGx+wpYDes5hnJq3
   A==;
X-CSE-ConnectionGUID: YX11RopOThGMJZqnrX51Rw==
X-CSE-MsgGUID: xVU1wHYYTn2qLLqEddEFkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="69888464"
X-IronPort-AV: E=Sophos;i="6.20,230,1758610800"; 
   d="scan'208";a="69888464"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 22:09:42 -0800
X-CSE-ConnectionGUID: sh05CEivTIKrC2q+ceohTw==
X-CSE-MsgGUID: AkW1sDbmTDOrH6DE3qPjjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,230,1758610800"; 
   d="scan'208";a="197297997"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 22:09:42 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 22:09:41 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 26 Nov 2025 22:09:41 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.14) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 22:09:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P69vTKj5JkkSd7u686R4ASYq0xs4z9zWp4NS9lBzebzdO2Qe79nSz2dBagqP5xMAyUObRjlXKkqBFL/M6xV0BWFsiP+54X2VG92jRJBeHynQ4xgSTxHdXPFT+YzORjC08iARaR3fut0HoRUDECjMUVV89gcy1jK4WJlwOxCGUUIGXbr7GR736BMdd9gnvMPXCRmGp3mhap76xwS7aZV3QWhYCJqrHzzvLB1ZZsxfqPuGW8vIFPjZX1JERQR/x6WN6SgC/43T7h3KDLWOyYOC2R6tBo1WSefyENMmmeXBTLQKdx7shKbojGUbWS/9bLKD7N8pfAdFh/8BBIggD/AmEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6J6jkMwHx9IjuGOANXTvI98pnX10rHdkUua+6v9p8Vg=;
 b=n0L8Z55mpPJ1v+wxpPW9AJRDRbrG1+0F7fXAVIplhX4xgiWwdEh/SM8qxq0XTjsZMOPEuqc+0ANoGfyDDfCgm1HEBnQ+QyJqtJ75Hsx8H2N2KCtM/nrpHA+iZ4cmHQ3Vqgn/FjPXmk2bCJILosene1WnjDLZ67PZBATbuLr571Bz7DwZ2+Qc+sUZUd5e/S0IRx3WQ0eE+7FxyLc26/aekBKxD7EzAr3D0sV7YMrUFQdJWbtx7JY+mmq81mHqHAOUyAgUZ3Ad2bWB5RZr9g4quR4LbZCNsxX0oFGHAnIKY1NwP9ErB7Fmqg2Z5VVODWNDvpmJceB+jr1Ctx56O+gBKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DS0PR11MB9454.namprd11.prod.outlook.com (2603:10b6:8:28c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Thu, 27 Nov
 2025 06:09:39 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9366.012; Thu, 27 Nov 2025
 06:09:39 +0000
Date: Thu, 27 Nov 2025 14:09:31 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [vbabka:b4/sheaves-for-all] [slab]  d39c8adcd0:
 WARNING:at_include/linux/alloc_tag.h:#__alloc_tagging_slab_free_hook
Message-ID: <202511271337.a31e6a9e-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI2P153CA0009.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::18) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DS0PR11MB9454:EE_
X-MS-Office365-Filtering-Correlation-Id: ec8bd706-ea5d-4c67-c819-08de2d7b8c41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?hhD5KA68nzVJwgFJp+oqa5TyyNsVtUTU/qyULIt4q+yEotgCoxK9TNI32O8/?=
 =?us-ascii?Q?ap8PmqEyGYdLTeBFlJny/Y7Z3X9jkgl7irK2VKPXYsL8T6ApGPxpIaRigFXR?=
 =?us-ascii?Q?VTE2KTSSR4cytIEDMCNgDhtwPnCugEJhJCtZQ+IF1/j4oeaXf8PMjoRtCnlm?=
 =?us-ascii?Q?ZdwNyjYYZ6+/+kQ4MHhu17TqFdWP4MUUWjmoEq1OboebvaM3l9UrJyTuxreY?=
 =?us-ascii?Q?p7QP+bfzCC+/vG37YwukcLi57M+3GNr2UnDDiQzFJyDxops5g8HZCdMsI9/S?=
 =?us-ascii?Q?naHtBSZZwk9BVHEmz6UXuBR8mH2KvcTRbKEL8d3UNexCFsP6iMg2fEUTf8on?=
 =?us-ascii?Q?3wKB9r1ukdWzWcz84B2CrCPtBbCz1xnYknZI7cFfyiZfzfgTDC2uhyICE8gO?=
 =?us-ascii?Q?IY2URY2TcgKHp9aAf3b9ngeqSCImKk5AtArVBsjm+iy1DZWCNvDmkfy/iK5Z?=
 =?us-ascii?Q?bVJIg0DISbnpa56KSuIXZGBedsnYbfMP1LsKDvDV1hkCbADqAnMUc2jkC5rT?=
 =?us-ascii?Q?PYX7PQTAtFLQE4X4TZnxMAW5dM3421EB0pltkqoQ5/W0bw9yCBnEGhJ3EI8x?=
 =?us-ascii?Q?19ieRDjhmSus2ypRtIqOQySlecjKWxN0hy6V1G6piIIoi+lEvNh+eYHGLQ+0?=
 =?us-ascii?Q?fxb2wJcPoNr8o1AFIRSg8CsMzmqxlmaTNVb1vPXS4y3FipTI9c2nP+e+4mxV?=
 =?us-ascii?Q?n0FqpldxfTHdymSQ3HDrLwAYJTnjWiZGv9ksQALAmoxJKyF6SpJTW1ZoNj3q?=
 =?us-ascii?Q?iXH2LFJDzWbkIM2NmM68zgdXPwdVmtsu18gJixD4BqFrnJETZG1JJVn/Gjep?=
 =?us-ascii?Q?O5xZ7J1yLkau1DJooA0tYAF7eYxt91WMzVaoURANM+zt3v2lXrgfP5OfMzjb?=
 =?us-ascii?Q?bxwObIrlHiUAE9wqg5UVgPBjHCiB6pVTglew6mOtAA41tTjJNjZ5e5Ieg0H4?=
 =?us-ascii?Q?6lQ9US6FK+bKa+OiYkeyhwZ2vf+HpgVLJiz5OkUsdVYP5EFcJp7oSBaOKcyJ?=
 =?us-ascii?Q?teVzx7OhQ9pJ8pzKRyFGYQ7xystwxOkV0dMSA9fzZTGhsnM/oU5ZwYjRDy2q?=
 =?us-ascii?Q?WFhFtU8XTNM1s9mrGjWpTLUCqjfUgsifdp6p9I0nls0JmWFA1FOCc6KWvJLt?=
 =?us-ascii?Q?bKK7yBaq2dMAxSwRLFtWBpX+dL0amcL6yjTxN3/1XKPcXa+kII7Guszona9N?=
 =?us-ascii?Q?sh2KkeibErg6XbDEOFm5fEghNAUtOMrOfkbgug5cY7orpn87VnqpRDVNxSaq?=
 =?us-ascii?Q?lQWCQCcH12UO7ywxpTjvXhHiC4WSvIHCdtQ2vBKTc8LHsewqALWnRGXvo21U?=
 =?us-ascii?Q?luDu1xAoGaUCktzsTW+Dm5MjGhqVBbtwKoBY0ooaiF3m+tpRBG3eei7PQKAQ?=
 =?us-ascii?Q?nVpSqERg57fjyPZ3kgIfAleEzf622B+Y1Gi+6ZIqgelKDP/HmvQBL0SyAxen?=
 =?us-ascii?Q?6jPWfPQi49MuMCTsuFmK6XqljRxV6HTZwb6bJxfuYHQKXD7bHz6LVw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gyLTKUQnW2xnAtd+Sj8BuwK8MAZm5G1HU/ltABBvp4ccWsaipK7aSxszNzO9?=
 =?us-ascii?Q?Mj/gqGhaIJ928R7mh6SMhChRuHEwVxzLsh1F08pTVM+K3qbmo1hEds3FgBrJ?=
 =?us-ascii?Q?Fd53kLXn4g+8yEdXk+zND5eK2xN0Z8lwPKYGju0/IfqDXvWEfLLRRf8bQrNH?=
 =?us-ascii?Q?Cj7em3OYLtCvpj+ZGd6wLmPLjMe/+c62mgK0Rkhk9nlTb1Fc7kEzyrVy8kt6?=
 =?us-ascii?Q?/nXFV80h38HKbfemEMrhdZm8WJI/cVqYnCrd0vN/4Ydj3vk+v2OZwbT9Ykv4?=
 =?us-ascii?Q?foJzpJRJj2P+1rXYcVS7140aJDSEkuxc69+c/FnVtnQTTZ7SRn8jBVjX1Zwf?=
 =?us-ascii?Q?aRUGsz6GR4KVuUPg2EPpGRG/TH54S1AK82DzuVaO5lCWZx1RGn8mOYDOYc/G?=
 =?us-ascii?Q?sKV9ZMHv9gevAwjWKVfI1gTulP/qM4/myKO+X5RQzAkm2ntOYdityZOz8T3Z?=
 =?us-ascii?Q?SMN+vDw566ggH9tYMOfGsJV+EaUYB9e/0HKMdBn7W1zNTVDcQyw1uf3tjWbA?=
 =?us-ascii?Q?XzPz7jSj/Q+IFgoBgau52Dfnv0M1DhBTikH8TQm5ZkBKyX3DMoFTn0KEA8Qn?=
 =?us-ascii?Q?bhnmzW8RYSgK2or2uX0DZAN9mVmumCxZUA/dFQ7lpTzH67nPvuRN8rOZDQ+P?=
 =?us-ascii?Q?iga/3q0VBT/9vQkUhzErOJ5HLwYDc3YcuxIo7QPUixBpGxzPEYeAodXr8xPR?=
 =?us-ascii?Q?ZRfAFLwMF+LuMrfElIuGdTlrt/JA1tyrBnEYYCPRpQL+4w9TrO6dJo4akEG/?=
 =?us-ascii?Q?rNxc5khXmV9rfgxhvN+hs1kqHVW2WNfOaAweqARkI/rrQQow2vjoUe5oFRP6?=
 =?us-ascii?Q?bsYODDHnMip3uV5m/azt/+LbMhL8QFgo4VplKRoPM71uQmXjdNf1Gcj8upi2?=
 =?us-ascii?Q?P4KbPtT8+KlG/UOy64HZv79MXVTMFYPFM+3mLjRBzVQAOWJTRZPTgEbE9u+G?=
 =?us-ascii?Q?aK53q77soaYrjHLujWypdQ7BEth2Ig6uagK7NuBNMXUrmA4Ioy+prb+iE0ip?=
 =?us-ascii?Q?pL+8xAlODavmqoGRBAEsRlFUrSIw0QhW1vmWKH48dv3Ih5VWe/wBTEFByaSE?=
 =?us-ascii?Q?Gt+XVrouBT1OwsFcfu24fgw7CFBJ5TH4bfcSqtmkmdKtwYoXgs13wwPzloCr?=
 =?us-ascii?Q?jO6+ba6w9nKYVFXDBN1uVoMoHfHcH8gWMVfnYcsxYlk59oZpQ9+oH8ot3fTn?=
 =?us-ascii?Q?9f9lrjI9kR5iBRzxcM2y33vx5wZJRFqDCBkkmHuapYa6Vw5CZrsdOzYtWA00?=
 =?us-ascii?Q?q4Ioe7Zuwar3Sf0jVLR44qYi5nVOfRxvfGNQIapkeSaLIY2fpInSqd5C4oM7?=
 =?us-ascii?Q?/3RAOE1i90jXfQmHwNcjn0nKKanwZ3n4CeKuBOUbR3B6JExQfgXE2RsbVO6D?=
 =?us-ascii?Q?SCCmGbRWcYPztLge5FbiHrErPd2aRyBh/ue6jm5ILJotKSGbIvfPhO2YxoEC?=
 =?us-ascii?Q?+6JmaUxM1ui/KImb6U3pdgEcvaOYoG7aU3WkhhysSDQrum8LqAPS+Fempuse?=
 =?us-ascii?Q?3zf0yx32pYCdPCAsLPR4UaKBj8k2jXADXIE+49P5J/X3kC4tAmvzm+SOKWpG?=
 =?us-ascii?Q?c7sZBO19k3OMeV9VfHAuxGcn5LxEzxbsAm8vSgJr26XC62wcS31V8IfTZdvK?=
 =?us-ascii?Q?3g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ec8bd706-ea5d-4c67-c819-08de2d7b8c41
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 06:09:39.1941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JMkJXke9RKhvsxAsqYetY0CBZm6kAjCSJ/AUS9OvQnSt1vQgTnUw4JRJP1OMnGA+2qeF2hjVphdl1PmM3bUCkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB9454
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 86F271C0004
X-Rspamd-Server: rspam02
X-Stat-Signature: 6i3snbjwkyyswg4qn5a159s9k9tzqc6z
X-Rspam-User: 
X-HE-Tag: 1764223783-879744
X-HE-Meta: U2FsdGVkX18p1n1BfX+HBexI9OLBirlnLRbUhFagBIKbuCY9jJEHSJCXqSJ8iQPSo9H0Xf1dj2oDs4Pn6dW0w6MzcSnsiRYiYrx6DIXlWNLBPvsf4FI56QyFuXL85ar6+jtmLoX6uqygpWuV13nBMk5YMU94pWtfXBqdoV2LVKD8tdEkRlN8xftZ5tiK/ti6P8KZQUHU6eJdzvWI6JicxbLLMZstrPmTSuPRzDFMNDvWOYyCxQFCz3BnTAMkMylCAqJTgvrAxIcSaPTxao0vHjVCXqU4yd+pEVGoQvNFmb07y1C1Qr3Vxy7T36FMp+WYEJQdRN/1PJRHaYLtjDorItNXfpVhpoQm0KclX9+zTJNa7OlLUPxi0xhRp10QOhlLZxRPxiZavzerERS9vgNn6O++p8uKaj48qWFQVO2/gMZdnbg6YJt68grdvtwpJypuT+Bz4cvFQq9we879OJeKq66fhTlkoFDC/fMW5AXKPuDKm9DoQtKHxOgSgfOS/44q5RvGPMaGYXrfzI87C5F1sd8uF3D+PquWdr6+Crdc+6XZkDH2zEMd5nVY76YeVllbX1cI23hEZQlgh0T4GHQ20/tMFU39iBXV+uxQzw+uosbAcasQX1+IDsGFetpn19VOWmXryDUmzins5U7wIORwho4vib19unqqTZ3HC7vfqFC6nZbT03OOU3wFTYUkTJOv6+PzhGNarEOtvDVvjZjjmt/dzv1caQcoO0qBcJMTt8mH1X9i5EGlWHW6Rbs4uGV+Ra9kbXODQ5yAB6DrZf7LhDLPATMXV6Birb9XNALA+wRORB0S562ARNahENgzQlsfGwHvz5fbN8FJkOOVAE477jW3Nk4/QYkdsteIUZINIRypPh6p30P7xHIIa9pVkOeeaui5PxymRQURLpUjhlz54O8GYb6x263j++Ct9J4Y3HnwvkRbiLYQSwITN+z+3lSrdUiEBV5//5Wg7da/1zz
 xFryzV+J
 WjUqf94ILGAdGH/pWdKPCyzyBobmrL/gAH56dv1ExgenkGXzsUjAk90em730fIJRFMVRSlHIdq8KPCaW2BGjV/i4C2XyW3oWKzefOleOY4Fqs12Ga9z67DJxIOgFVJ1BKpjNaPVBRBwcNMH9Dr7CHXAmwjpNRh2FUf7/jHWWT2otPNhsI1m0NqlcmhkX59PEcMGrV8SdqygsnAHl/BiufMBO13N14obz/xPaISfY/fNiskQgENA8QIPLJbWLgBEj1l7CEuzadNJbsXkfsHPcAIrCEXlcdmZ/q+YXkh8kh9p1lFUetovVCJj16LzFa5xl2GlPT/TlrLmxPQjb3ktZwlsN9KQtXfO+wAU0sK1Em0MLG8IfARvLM5Hc7AaX6uvicbIgJ9YPFwpLrPibVdJn15L49WoPoQdARwCxqCfzq/kLZli8KI+a+jqFmOeOSBuOCv5Q6R+KRz3iDuBM4jdD/BPZmNGZCDaL6uQDuHTYmfjZTsP0BH6XY+hzv+vAzM26Q+YcT+/ZmiPDxBYItQvHJK2BkHmPF+Xmqk11spCucrKl2ADySw/4GG3PE2SbTh3C4ZA+zII4UxQpE81JzvWgjEm3BYvHpCb6lpJPXUpjGlW/lfYMF++WbDYjsho7fRECF6T0gfDgbLfAwS2UbDhI2YwcKnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "WARNING:at_include/linux/alloc_tag.h:#__alloc_tagging_slab_free_hook" on:

commit: d39c8adcd0d209da4a303ba4735b120e406155b6 ("slab: handle kmalloc sheaves bootstrap")
https://git.kernel.org/cgit/linux/kernel/git/vbabka/linux.git b4/sheaves-for-all

in testcase: boot

config: x86_64-randconfig-071-20251126
compiler: clang-20
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+----------------------------------------------------------------------+------------+------------+
|                                                                      | 75b6163a4e | d39c8adcd0 |
+----------------------------------------------------------------------+------------+------------+
| boot_successes                                                       | 6          | 0          |
| boot_failures                                                        | 0          | 6          |
| WARNING:at_include/linux/alloc_tag.h:#__alloc_tagging_slab_free_hook | 0          | 6          |
| RIP:__alloc_tagging_slab_free_hook                                   | 0          | 6          |
+----------------------------------------------------------------------+------------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202511271337.a31e6a9e-lkp@intel.com


[   32.935987][    C0] ------------[ cut here ]------------
[   32.937847][    C0] alloc_tag was not set
[   32.939292][    C0] WARNING: CPU: 0 PID: 168 at include/linux/alloc_tag.h:164 __alloc_tagging_slab_free_hook (include/linux/alloc_tag.h:164 (discriminator 23))
[   32.942621][    C0] Modules linked in: intel_cstate(-) i2c_piix4(+) i2c_smbus intel_agp input_leds serio_raw fuse qemu_fw_cfg
[   32.948018][    C0] CPU: 0 UID: 0 PID: 168 Comm: (udev-worker) Not tainted 6.18.0-rc3-00058-gd39c8adcd0d2 #1 PREEMPT(full)  bdf622f0b5325c8c5bd714a08cbc1497cefdf693
[   32.952307][    C0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   32.955489][    C0] RIP: 0010:__alloc_tagging_slab_free_hook (include/linux/alloc_tag.h:164 (discriminator 23))
[   32.957639][    C0] Code: 48 89 3c 24 48 c7 c7 5c 39 88 86 48 89 d5 49 89 f6 4c 89 44 24 10 e8 18 8c 5c ff 4c 8b 44 24 10 48 8b 3c 24 4c 89 f6 48 89 ea <0f> 0b 49 8b 04 24 48 85 c0 75 a1 e9 05 ff ff ff 44 89 e8 40 0f b6
All code
========
   0:	48 89 3c 24          	mov    %rdi,(%rsp)
   4:	48 c7 c7 5c 39 88 86 	mov    $0xffffffff8688395c,%rdi
   b:	48 89 d5             	mov    %rdx,%rbp
   e:	49 89 f6             	mov    %rsi,%r14
  11:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
  16:	e8 18 8c 5c ff       	call   0xffffffffff5c8c33
  1b:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  20:	48 8b 3c 24          	mov    (%rsp),%rdi
  24:	4c 89 f6             	mov    %r14,%rsi
  27:	48 89 ea             	mov    %rbp,%rdx
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	49 8b 04 24          	mov    (%r12),%rax
  30:	48 85 c0             	test   %rax,%rax
  33:	75 a1                	jne    0xffffffffffffffd6
  35:	e9 05 ff ff ff       	jmp    0xffffffffffffff3f
  3a:	44 89 e8             	mov    %r13d,%eax
  3d:	40                   	rex
  3e:	0f                   	.byte 0xf
  3f:	b6                   	.byte 0xb6

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	49 8b 04 24          	mov    (%r12),%rax
   6:	48 85 c0             	test   %rax,%rax
   9:	75 a1                	jne    0xffffffffffffffac
   b:	e9 05 ff ff ff       	jmp    0xffffffffffffff15
  10:	44 89 e8             	mov    %r13d,%eax
  13:	40                   	rex
  14:	0f                   	.byte 0xf
  15:	b6                   	.byte 0xb6
[   32.962145][    C0] RSP: 0000:ffffc900011e7ac8 EFLAGS: 00010246
[   32.963469][    C0] RAX: 0000000000000000 RBX: ffff88815dcf3700 RCX: 0000000000000000
[   32.965735][    C0] RDX: ffffc900011e7b40 RSI: ffffea0005775c00 RDI: ffff888100059c80
[   32.967567][    C0] RBP: ffffc900011e7b40 R08: 0000000000000001 R09: 0000000000000000
[   32.969288][    C0] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88815dcf3700
[   32.971009][    C0] R13: 0000000000000400 R14: ffffea0005775c00 R15: 0000000000000000
[   32.972730][    C0] FS:  00007f10b1ea5980(0000) GS:ffff8887961d9000(0000) knlGS:0000000000000000
[   32.974659][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   32.976089][    C0] CR2: 00007f10b2e71009 CR3: 000000015af2e000 CR4: 00000000000406f0
[   32.977809][    C0] Call Trace:
[   32.978628][    C0]  <TASK>
[   32.979381][    C0]  ? rcu_core (include/linux/rcupdate.h:341 (discriminator 1) kernel/rcu/tree.c:2607 (discriminator 1) kernel/rcu/tree.c:2861 (discriminator 1))
[   32.980391][    C0]  kfree (mm/slab.h:632 (discriminator 2))
[   32.981300][    C0]  ? rcu_core (kernel/rcu/tree.c:?)
[   32.982308][    C0]  ? count_partial_free_approx (mm/slub.c:2781)
[   32.983549][    C0]  rcu_core (include/linux/rcupdate.h:341 (discriminator 1) kernel/rcu/tree.c:2607 (discriminator 1) kernel/rcu/tree.c:2861 (discriminator 1))
[   32.984560][    C0]  ? rcu_cpu_kthread_park (kernel/rcu/tree.c:2826)
[   32.985742][    C0]  ? __tmigr_cpu_activate (kernel/time/timer_migration.c:1059)
[   32.986944][    C0]  handle_softirqs (include/trace/events/irq.h:142)
[   32.988020][    C0]  ? do_softirq (kernel/softirq.c:580)
[   32.989032][    C0]  ? ktime_get (kernel/time/timekeeping.c:295 (discriminator 512) kernel/time/timekeeping.c:404 (discriminator 512) kernel/time/timekeeping.c:826 (discriminator 512))
[   32.990034][    C0]  ? __irq_exit_rcu (arch/x86/include/asm/preempt.h:27 kernel/softirq.c:722)
[   32.991093][    C0]  ? __irq_exit_rcu (arch/x86/include/asm/preempt.h:27 kernel/softirq.c:722)
[   32.992151][    C0]  ? __irq_exit_rcu (arch/x86/include/asm/preempt.h:27 kernel/softirq.c:722)
[   32.993202][    C0]  ? __irq_exit_rcu (arch/x86/include/asm/preempt.h:27 kernel/softirq.c:722)
[   32.994294][    C0]  __irq_exit_rcu (arch/x86/include/asm/atomic.h:23)
[   32.995343][    C0]  ? irq_exit_rcu (kernel/softirq.c:714)
[   32.996370][    C0]  ? clockevents_program_event (kernel/time/clockevents.c:336)
[   32.998117][    C0]  irq_exit_rcu (kernel/softirq.c:741 (discriminator 5))
[   32.999477][    C0]  sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1052 (discriminator 6))
[   33.001256][    C0]  asm_sysvec_apic_timer_interrupt (arch/x86/include/asm/idtentry.h:697)
[   33.007296][    C0] RIP: 0033:0x7f10b2d43cc4
[   33.008693][    C0] Code: 4c 8d 05 df 12 19 00 48 8d 15 02 da 12 00 bf 07 00 00 00 5b e9 7d 84 e9 ff 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 f3 0f 1e fa <41> 54 48 8d 05 03 55 24 00 66 0f ef c0 55 53 48 89 fb 48 83 ec 40
All code
========
   0:	4c 8d 05 df 12 19 00 	lea    0x1912df(%rip),%r8        # 0x1912e6
   7:	48 8d 15 02 da 12 00 	lea    0x12da02(%rip),%rdx        # 0x12da10
   e:	bf 07 00 00 00       	mov    $0x7,%edi
  13:	5b                   	pop    %rbx
  14:	e9 7d 84 e9 ff       	jmp    0xffffffffffe98496
  19:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  20:	00 00 00 00 
  24:	66 90                	xchg   %ax,%ax
  26:	f3 0f 1e fa          	endbr64
  2a:*	41 54                	push   %r12		<-- trapping instruction
  2c:	48 8d 05 03 55 24 00 	lea    0x245503(%rip),%rax        # 0x245536
  33:	66 0f ef c0          	pxor   %xmm0,%xmm0
  37:	55                   	push   %rbp
  38:	53                   	push   %rbx
  39:	48 89 fb             	mov    %rdi,%rbx
  3c:	48 83 ec 40          	sub    $0x40,%rsp

Code starting with the faulting instruction
===========================================
   0:	41 54                	push   %r12
   2:	48 8d 05 03 55 24 00 	lea    0x245503(%rip),%rax        # 0x24550c
   9:	66 0f ef c0          	pxor   %xmm0,%xmm0
   d:	55                   	push   %rbp
   e:	53                   	push   %rbx
   f:	48 89 fb             	mov    %rdi,%rbx
  12:	48 83 ec 40          	sub    $0x40,%rsp
[   33.014161][    C0] RSP: 002b:00007ffc20e5c4a8 EFLAGS: 00000246
[   33.019447][    C0] RAX: 00005617e7714670 RBX: 00005617e77188c8 RCX: 0000000000000000
[   33.021918][    C0] RDX: 0000000000000020 RSI: 00005617e7723740 RDI: 00005617e77188c8
[   33.024389][    C0] RBP: 00007f10b2f63d00 R08: 0000000000000000 R09: 0000000000000001
[   33.026968][    C0] R10: a94ce8c078b7f815 R11: 0000000000000000 R12: 0000000000000018
[   33.029443][    C0] R13: 00005617e77146e8 R14: 0000000000000019 R15: 0000000000000000
[   33.031959][    C0]  </TASK>
[   33.033098][    C0] irq event stamp: 26060
[   33.034515][    C0] hardirqs last  enabled at (26070): __console_unlock (arch/x86/include/asm/irqflags.h:42 arch/x86/include/asm/irqflags.h:119 arch/x86/include/asm/irqflags.h:159 kernel/printk/printk.c:345 kernel/printk/printk.c:2858)
[   33.037554][    C0] hardirqs last disabled at (26081): __console_unlock (kernel/printk/printk.c:343 (discriminator 9) kernel/printk/printk.c:2858 (discriminator 9))
[   33.040473][    C0] softirqs last  enabled at (25216): handle_softirqs (arch/x86/include/asm/preempt.h:27 kernel/softirq.c:469 kernel/softirq.c:650)
[   33.043403][    C0] softirqs last disabled at (25293): __irq_exit_rcu (arch/x86/include/asm/atomic.h:23)
[   33.048190][    C0] ---[ end trace 0000000000000000 ]---



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251127/202511271337.a31e6a9e-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


