Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDE88C531FA
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 23:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B07906B0088; Thu, 23 Jul 2026 19:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8E76B008A; Thu, 23 Jul 2026 19:12:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959506B008C; Thu, 23 Jul 2026 19:12:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3C36B0088
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 19:12:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA42412020F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:12:00 +0000 (UTC)
X-FDA: 85021591200.01.B0B59AB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf22.hostedemail.com (Postfix) with ESMTP id EEF7CC0005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:11:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D0PbTUaF;
	spf=pass (imf22.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784848317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ydJk2vn2JZufCtqE9oBhjzudniYMJ0nTgCMbVIhJuSo=;
	b=sii6cnZZ8oady/qikmB5r4BZjhVm2noovDAsirnfzMBwdY8NokEKwr7inDi2+IaWjZKf8l
	5OgjaCcBnChLo0aOeDUhZbvkZcJg39tMvK6P3ZFuKVUA3E4iBbOEAvoSBdYLMPw3v0e/nD
	6FyAm3hFUXEbjsqn7gOowtx8zBqdNd0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1784848317;
	b=bwmy8qsG7D3M3xP4J43St1RogF8dfIxVa/H9kkKQfXOs+84QeEIhuR6dHHqWFSnHwYPzQg
	UbMeWPb02csX2jhGl9aDLyFPIT67x9EV5JI8vXhcM7lP9nA4LwY82flETzzqTEjc8/i02Z
	vN5PjGR9zWhVVg7XfcAXdkx7Nffy4ME=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D0PbTUaF;
	spf=pass (imf22.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784848317; x=1816384317;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=icZZ9FqLsahb7GHFCSI7DNu65EEYOtBQDZ3fsBhIQRA=;
  b=D0PbTUaF1WikqIxGi+8/J9DB8+EVoRntvg07HdKrbSZP06UUvYwTQsGS
   B2qC2B+K1G9OWpS0qqMssi5BtR8zK9w7W8P5nNZL2PhPFFpFLhGY8VA+C
   irBr89qXW2hJGE18ZYr5B5n7jERVxDJbzLXIy5mgzLoLlrD3sF+2WH2Jp
   dgrvNhyItm1YpqjoxhVcIy2RWwepGNcqTocZspyVIpZMCIA2mRLIxlLaH
   syJDPJzIS/2nmcXXISDo+6o4E7RhLSG+fQ8oR7da2r1MEN7/Tv8EAK34r
   HFIESeVY8fhC5qT/SpbQjdQcG+Lbbnny6qlig0gPcTTe21ARX5L1KYGJd
   A==;
X-CSE-ConnectionGUID: oaw4o5RETLKETMzrGZcMng==
X-CSE-MsgGUID: 0HwqWPK8RtWPMkPzwm4O8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="103059016"
X-IronPort-AV: E=Sophos;i="6.25,181,1779174000"; 
   d="scan'208";a="103059016"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 16:11:55 -0700
X-CSE-ConnectionGUID: wj74OVQFQBC4TdtNSV2YeA==
X-CSE-MsgGUID: q3dQ3KQQQECQ121lzPuxgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,181,1779174000"; 
   d="scan'208";a="255906968"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 16:11:54 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 23 Jul 2026 16:11:54 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Thu, 23 Jul 2026 16:11:54 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.57) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 23 Jul 2026 16:11:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KqG2UqhpCr0+PbKX+mFaLYN+g4T37INwRjZ28SX5gt55ermqQEZ2bgNExoFJdFt0beTqBl35nl1ewwHSwZ/QDJRzj/u+tzf7o19qqiZzTWZIrCXh/0+SxYALnsGgmSIRp9f0KUm/m/dlHwzgNP1/MrkhQSCfSGgjMtf0m5PaPeTLGV4cqV9A7qusrvyb97u3r7zxa1AaemHvi3MrWNR6JW3DQsO5kmibuBOqoM9Qsyq/Y5nh7ac2pJJqY4ykS1oYzLdYVdzxO9Y4daGIObdZA0uTWaXma1tpRBHJm7HIYSlX8i8lV8S/dShqk/8grFCjhAF0zzJnYYy0pyVx6FIzew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ydJk2vn2JZufCtqE9oBhjzudniYMJ0nTgCMbVIhJuSo=;
 b=WUj41vJRLRu+hUPjVx+/2l8lSdhnYUTCAWK99Ypes+KiMlb3ST3a2lcEBAUx9AYgnIUw63VXcRz8l4myaNie9GGApdlCkieAnpnA6YQT0RHQpLm9x1NoRvk0VP4BI97rM0m7iJstZk8QFEVrPH5HzuD5rsqcHXzmm2H5ZPhY70QxJtBcI9Qi6Y+OQkiXR98cgFFEVxYHOuPxAmNWDSyX5hsWZXYA67q3ek+ICu+eAXr9f27iRN1jCStkaYw5cHHfgq3ZFhJniUImHdTC1ErLbS2SiGYPEhH1Y/1+FoGOPaipgiVnH5OvyHqaIbi9FH/lXvRgV5VXbQbkw0vsOtXqUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL3PR11MB6508.namprd11.prod.outlook.com (2603:10b6:208:38f::5)
 by SA1PR11MB9875.namprd11.prod.outlook.com (2603:10b6:806:4da::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 23:11:53 +0000
Received: from BL3PR11MB6508.namprd11.prod.outlook.com
 ([fe80::53c9:f6c2:ffa5:3cb5]) by BL3PR11MB6508.namprd11.prod.outlook.com
 ([fe80::53c9:f6c2:ffa5:3cb5%7]) with mapi id 15.21.0245.010; Thu, 23 Jul 2026
 23:11:52 +0000
Date: Thu, 23 Jul 2026 16:11:48 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Nathan Chancellor <nathan@kernel.org>, Mark Brown <broonie@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
	<mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, Usama Arif
	<usama.arif@linux.dev>, <linux-mm@kvack.org>,
	<dri-devel@lists.freedesktop.org>, <linux-next@vger.kernel.org>
Subject: Re: Semantic conflict between 04b177544a04 in drm-misc-fixes and
 0b6b1bb28482 in -mm
Message-ID: <amKftG6NRZy0Ii2/@gsse-cloud1.jf.intel.com>
References: <20260722225605.GA1910198@ax162>
 <amFPJc1NQbuYWlSp@gsse-cloud1.jf.intel.com>
 <20260723212724.GA999236@ax162>
 <20260723160942.b58b065d771401aba117bc77@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260723160942.b58b065d771401aba117bc77@linux-foundation.org>
X-ClientProxiedBy: SJ0PR03CA0079.namprd03.prod.outlook.com
 (2603:10b6:a03:331::24) To BL3PR11MB6508.namprd11.prod.outlook.com
 (2603:10b6:208:38f::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR11MB6508:EE_|SA1PR11MB9875:EE_
X-MS-Office365-Filtering-Correlation-Id: d2bcc7d4-e3d0-4577-e38e-08dee90fc837
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|56012099006|10067099003|18002099003|22082099003|4143699003|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info: WAoykKdQI1G3K/Vo6fKt47PZ35wmZXTnlqWW/JGp+vbiF/Syk4tyBRiFrMkn7ZlpYxkjiqBKMUTliaOpHZ5lXRn6fcL1Bh9EMfcacMl6AeGfp+79KJKdEbwDwyXceOjya7Grljee+FDwjSphp6GrirlO6meLMsheIipPbJmgrv+ju1OCA5FY46aU3rmofUdYLkY1NyGG469no+PKAObKrDhhkjAoMd4JVi3IXuZAE+QZnUuoB/B4yi0dJ126p6KUkFEHC6RCT6JXmIWQDTYnJJV8fYqBiT9rtsivqnHZRQkgZqJgQeKhjCYJUA++cRhnnql4VfcVp1q4kt+xQJTeRMb+OSUiYYKmhCgE6piK+vJqb2u8cACZ8dg3pShJ7IbFW18JhYyfVafXhTsH9sSIeNxyqdySTkilXDCZRVcBAq7Fi3L0QALxuDOoRjWdouzS/0rQ10+GEnUf5122slS8aNrjNcihFl53OzJPyo6mbPESJTxB4juv1a8W6Zy7l5uOcBRN6YEyJYG2XImHMJUm9dNMKwS3yiCfA41pzCIHeXAoby+igsoGjdAY6R144dKktuOjEOyOgvN/P8b787vqBmTYzI8Zw7aIMFtJaHI+7aTtwCuieEb2WUSKZg8Klt4BxKKSQUN6NizCM1GjoFF0StU7gPia7PJteqjuuV0sRpY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR11MB6508.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(56012099006)(10067099003)(18002099003)(22082099003)(4143699003)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tiu6arO7//Ogzw4MYiNhDrgwrcdcNdq2GsPos1QK+MGiha5J4RD70c+cS2la?=
 =?us-ascii?Q?cSakHrAZBL0E4gjA6jvoB0Kfw9XoZTBdf5WHYB4nwpdgrbdPvm1fhDXSfSta?=
 =?us-ascii?Q?Jb96dK8tznHZzyHjFERTj/2Bpk97bNuauEhucV+Fg4EyGwJoPBWB5lGVoJwz?=
 =?us-ascii?Q?lAQAQ+otQ3cinXdFhQLTKmNhl5t1+YZYgwmHOp54tr/2TYNRL2C4NMHbqe+x?=
 =?us-ascii?Q?1eVmjtWtR2SoPwmv4+a2tdzE71ci9vp5x8O1z1az+ZAO+iecB1b7ld3vcyg4?=
 =?us-ascii?Q?PHDtYvxTCTcpnSwKqqIfNjk6qHY4kwcuqlVXZIn23BPRwp71BAKt/+AacPX+?=
 =?us-ascii?Q?6XBvdZFpo4kKETTTD3M/KU96LDQTIx5C7LKzbiLE1GNN++SDykPU53xLkoYa?=
 =?us-ascii?Q?F9pgr/Dm97oHQ9maEQHNq6OWy0Dn9c2DqJEUl02Lnw27nb2AhsGuhI+Bs7Us?=
 =?us-ascii?Q?hNyyd5Mg6drrzl2UzCtdls4gbNBGdq0sCrT8baIPVif4UBDKTMmygRgWXSPB?=
 =?us-ascii?Q?d/rekimcRdcAnuOTDubbW+UL1rqES6k0GrxLQoFxjZU/TgcO6Ch17aX+1pau?=
 =?us-ascii?Q?3bT+6049bQt/yOKGbCInafSQEdZnb/6H6W0AmbvRkdeUZVKyG92OWYNSsksu?=
 =?us-ascii?Q?nY3bLY2RbXKPs5y5spBFUQNBUE01urzQxcYmp+Ng/DCiz6aWLJNc4oTnjODg?=
 =?us-ascii?Q?Ea4u07k2Ejb+lSzEyN8guZzJ87wejvH2/Yq7eXlGF3Z4KB9MMcI0ReSIS1yK?=
 =?us-ascii?Q?Ocdl/UfOkK+W1m7KBnpn5pi3dOzE540MICEUtcV2hDe0UL6vJ8+LxnlYGg8U?=
 =?us-ascii?Q?M1yDd7ujyrIhwCbKDdQEObvVRFngMoaP1Vy71BoJeYsUBOPKNsGMSPf9rEr8?=
 =?us-ascii?Q?w3iRREbbn6jexfo2hPon8V+gWzIse98UjGA6a+twjHTC7mTAHv6UhtIJE+Mp?=
 =?us-ascii?Q?i399BjQi9jkZz26CeOy5B4JiG2woOzGH0678aJ6/QsXJV8kVCnYh3rE6qs3T?=
 =?us-ascii?Q?hEuh82Rt0LLGEb5EEHAwpRb8rfTQ/ldyaZvE8SYoks8rWhRE4iDSYZN+skEv?=
 =?us-ascii?Q?hGfmaKcrPR/eH9dKzUFrWr7uhjYyHfmcrS7lNfGskRmp44PkpJttHbDEvRHa?=
 =?us-ascii?Q?4huE9bOvaqvkNRP304SgDsX1SaxVLB8KK7CEj8BN0+theYHY3dtWrza7Rx2F?=
 =?us-ascii?Q?mIyyF6PKzuWuiQpInmAIIbC0+SI7svgl3uF3sukb/dRuWZf7Xvhzw0N8Og/M?=
 =?us-ascii?Q?H1rZ9TQRBbXk+q5F6KfDCmLdC1uZqZcqzFimYi8AW0Vi0muF3RF5daLfpgUL?=
 =?us-ascii?Q?U9s9DUisRP4UH/HLtO2p/q2a3rwNYaeOfnoWGF3H4SjlmlQ8BFjkONyNOduP?=
 =?us-ascii?Q?Ess39g3PK4RAuVv2f6ahYLQYxoEPhcO03evJREmLPhl7vQVNtA69BliawBs7?=
 =?us-ascii?Q?zX9XLf9/p0LnvPGLpLS7A+I2JrlUF7RB8Nsow1aW69mLrKV2azl3v2/YyTP3?=
 =?us-ascii?Q?+ULuL8/8tfc90hcIBNPBAk0NdwHtjPvHUgVXmO5TB55zBuOn2knh+pzQONop?=
 =?us-ascii?Q?02KcW3DWtHCJaSF/vDVdNVW5RE/BeeNj87JGBVPUcZqS2nCnmqUZJ8p/1oMQ?=
 =?us-ascii?Q?UTzK8DFokrlUB+UxegROXdTSlv+qo08O9uueTZ1+NxprwaDVPlcLZ7qQZbgi?=
 =?us-ascii?Q?cCVPl4CE+VaVFF47XIFHniVVFUYCXp4Ra/FtyXbEQQZDwupJwK07fSRyoN0o?=
 =?us-ascii?Q?ETSz9Cb0Kg=3D=3D?=
X-Exchange-RoutingPolicyChecked: HK8UL8fH0zgbzEOtNNGqWhl/YM8/I4inFXjAM2wYohGrCqK7XMYQ2lZjraqQq2PAIrWrAcokK93K6hZ1qGETxnZZIsRsiJv+sts4+FiCuDiEMGHHkr6c1DxLNLrSl10xUGBllLNoVtFV4petcQFYOg3Z/pqHBs1Uyu/p8vpaRR6Hwpt4Ga8M/avC6WPSBdaJqqj1oDeEpJXpiuhTDOjIU2BJzoPylT8xuGF0aFyC8ugXGGbqUiIwtLFfrYNCjkX3zQ1v2GpBrn3FzaAWTtH8FQ/vmc6zT/Y5ExMw8ad0Q795em0LOPSv/DoZXM1FV7XQ+YBiUIzM/w17yEYyw4GOmQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: d2bcc7d4-e3d0-4577-e38e-08dee90fc837
X-MS-Exchange-CrossTenant-AuthSource: BL3PR11MB6508.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 23:11:52.8041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zomlB26Lf6sRVzTY2tMJXq0vSg1doOuz/i2DNreXFLDT3Z+L6RHcegdqZL4w7VSTOy8O3AOGZ58NPTDQznkByQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB9875
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: EEF7CC0005
X-Stat-Signature: n3akgj9w8tdu6fhohgrpp1pmoicr59nn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784848316-768856
X-HE-Meta: U2FsdGVkX1/SQHAriHXMY6zBbFDnvKHAK+Ck2k02gO0ptlZD+Peg9e4drem0O+EW3W3ElbiFe9/Q1rYRGsN39nNkIr4e4Ofp9sAdkxU8cUXArCByvyb3qA5sXT5cDkCAChHLuXbNiJlEPpmKHVpF3rbcj8pGVvzumimfjAAR/2/7m33eAeM5s8nYgRIHxmmLJm7rJtNPnRjdw5YtpeDLhynkmWT8CTHHousMpbliw9ZPy4IZV8MZ8RLkmYdUrqk2WzT01UnNXYPuCsg99Pa/mV4N4PtvEvEFrBdlJG9ckeGgZwanOjHernUL9T+384R97YV+5MFy7DPOGngEHlnNV76wKW1rwWp0dKTh8ytLEJeBFLy7WuP4uk2EXdwwy8FJaBCA9SIcCD7U1jxAivwzRev4ygZbyWsdsEZf+HKgeA+jHBHE9piCo6L2tnxvS+LKaFsmIScUqacTJNwf4kX2opw8SeSsDsp7uPdh/MMBTI9Pu/dYhKPZlcvdJZxkR4aRVsBDeOjJIzpep6vShV42Snh/oB9WYWl9OKMFyY0RxWG8xmY2RbS8RoBIKw9xDrPn8r1Z8fVLA3IC/TEGvk8Y9RjuEf9IzZ4VX4UNluOv+ou2nJbaS6Mugh21f0YyfZdWPvcVGr4qFnd1AegUUJx/G9F8bthNU9b2MDWp98oBtp28Zl76DzdnxyGIPse8XChfilgrrRmJQeVRKyUPhLK/Y5H4qBqlK5VUK/cNKzwXHqGwedlOkewpS4INlJ/sAaggjcBjFz6Od7Ydp1ZNNfjI/9LRQoKl9mjmsx5pmi1tAFOaDefiZk6WqS9PlkC0NciGs54WOg/tIz9FPO6CLa1n9YCPZYUj5hJXWhevDQ1l95sKIBZEGpuMJ+oh1v84yaFyxOYoZZNtiOL5mqGP0NhTtlhg1PV/rxkqAdqDDelyI7MVdbJKQgT5fBLGMVFb4FMiUezCo0540fk5rB3en7L
 8ak7KtmJ
 gImYZc7AKtw+HmnEhYy4E0tr33TlB4j9gM4qsUwfpnzX98A9yJqZzMYOJx+PPTzlbGnmWH2HNBgJQanbhvgi2Ks+yyvqL9GIrFp1aLSu7VwDvsSQsT4BDQnBcLP4Nfy1hboOoF7q7ydtke4/dn+QY5mQPpw4Y6bcO2avU8zZZy93DYPyhU/+THK8OZTqzeR/in2CHd0Ec0cdHKcvDtInTf/qj/5r4QhLfI2/2HTWe+QTpz/lhXP2zzyRtv3sjKOB2akHWB87Inrht1+q8UK0R18JH1NrLMFo+P3s8yBYQ/3x685mUiEjd5Ucz1fPoYkXSdiUNkoAwAZdjGj0hToSbNqWp+x5QcegldXQWHf0H4NNM8y2iwYuwJQXdn1xjSqyDCl3taUANbUfE330CAVJzKyhdFFrGyCKAavfgDff9a3mlniBy1v/HMZafgX9Ehjw6HDSbHK0BjHgBUfm3IaOMACpVEZmPf4Tkg4ysDW5JJsp1QcG2uqWNkFlHgZpednuTd3IY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 04:09:42PM -0700, Andrew Morton wrote:
> On Thu, 23 Jul 2026 14:27:24 -0700 Nathan Chancellor <nathan@kernel.org> wrote:
> 
> > > So the drm_pagemap.c code could be:
> > > 
> > > -#if IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION)
> > > +#if IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES)
> > > #define DRM_PAGEMAP_PMD_ORDER        HPAGE_PMD_ORDER
> > > #else
> > > #define DRM_PAGEMAP_PMD_ORDER        (-1)
> > 
> > Ah yeah, I probably should have looked at the bigger picture there.
> > 
> > > This Kconfig has been around since 2024:
> > > git format-patch -1 b979db1611a63
> > > 
> > > Would it be better for everyone for me to change this in the DRM branches?
> > 
> > I believe that would render this conflict moot and seems like the
> > correct thing to do anyways but you could wait for input from the mm
> > folks.
> 
> I'm fine the drm people changing things ;)
> 

I'll jump make a DRM change so this is all worked out when it gets to
Linus.

Matt

> Otherwise I can disable "mm: rename ARCH_ENABLE_THP_MIGRATION to
> ARCH_HAS_PMD_SOFTLEAVES" for now and fix&reintroduce it into mm.git
> after drm-misc has merge into Linus.  Or something like that.
> 

