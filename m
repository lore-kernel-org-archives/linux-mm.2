Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F623D4A5E4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 02:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FF4F6B0089; Thu, 15 Jan 2026 21:07:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AD6F6B008A; Thu, 15 Jan 2026 21:07:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630296B008C; Thu, 15 Jan 2026 21:07:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4CEA36B0089
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:07:08 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4B6A1AD6B2
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:07:07 +0000 (UTC)
X-FDA: 84336189294.16.7851D70
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf24.hostedemail.com (Postfix) with ESMTP id DC188180003
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:07:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ckchjLpj;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf24.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768529224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=71dX88VNdG5b7mHB9usnnumQuPo47q6UolSC890TBgo=;
	b=yBD0LUbZLSYP9jACL/HTEbALvVdnuToLa5Azc7UEm4ITG9EnNoFqIbhTlrtQHcWy0IMDHY
	ZHVLYHPeiVZOJQiPB7XtF+bBS+0pKkWIchgr/xCZzv0X05mYN6sqz2wPeJGNslLCnBfVCN
	16edl/S50HUm6EQZi/+4litiUFtA8dc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768529224; a=rsa-sha256;
	cv=fail;
	b=LustyEex7rVaZaoWT+5XDylREfw4y8i2RFDzdxpGeMXLxH3hwQcepGsCQ6ncbmAgT9G1u3
	ZwjFrdKW9jO1apGrmAccLCsmpHiGqJVFS3ABAwrMt7IZQ4ztd4GxaZ9+2Fyz9jt7KX8O2c
	OGgbZhm2XzKjUt8VB5v9xGd99Y3soJM=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ckchjLpj;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf24.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768529224; x=1800065224;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=M7dh3ul8NtbJG7QVqgKDrL4+b1ibW8AUiLKF6eEom4w=;
  b=ckchjLpjufJK17tpx9c5s/xrXL5+axElAU5Fz/7W9DjwyPckaQtgkd81
   zvJxFCrWicdxwF1wZeRaI5MGoFazt4b1svzaFoQFHXFW7XBRjGDgj7OgK
   okaf1XohJ6bEkTpkIBz1gBPC4GHcVbio1HeRvlmPjtwjjlpTlBJJ4dhUW
   uAL7+Vu6dBZ2X80NJZiQdGbstYIyDgrRYKI/azidplQBqy2OyadL/dvG3
   36PfMtAVAYX2jNBRBSwLZ0XGqiVZwtCYgWXn0S2o7Wqw9i1H0pDgTfdv4
   LAKxodEpMjv49WfH73oj+NXBMinbIEKvLVnjbcR4tGzg088ZmgsUT2jVE
   w==;
X-CSE-ConnectionGUID: UQPf+sFUQtikpuCvlBKQBA==
X-CSE-MsgGUID: 2TYW8kCjSTG1uglyQre4iw==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69895609"
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="69895609"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 18:07:02 -0800
X-CSE-ConnectionGUID: OMa6NePEQUStK0o5kW+X5w==
X-CSE-MsgGUID: URd51PZlTFiYxVP8/AJiNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="209602664"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 18:07:02 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 18:07:01 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 15 Jan 2026 18:07:01 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.0) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 18:07:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zo4g82idWEzQ+WnAxQvlMkjW/fndx9h2BGvJmvPfbsHVWTQ0nzWmsg6aB+YQCfD/J+40CTxQSxPPIddU9zUx/n8KYGv1V5PHPAoYMyhq99Jp4lIP8Rj53QvB9Xgt22MXowf9Kcm+s22hj2jTdtnO0ZX3P+emfdVkWTe5YVkHhmxHSUGAw5HKeoPJ01pK5ZpvZfcHr5ADcbqP5y7tsBzI4XXN4XvxlggRtMo3FIUVWoPsX1u7x56tJ6HOi4wBbQyPKo8UNtVs0EgBaB152s4gzocG4gcxb+Oz3dZOKDh12y89ycEzE4GPEoX+x0tgVl5K1UGRozNDTMHbjXglOOoG/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XwUMuhWh3KV6GNDYnZePliBHVymPUtFb1DnjpTXOCVA=;
 b=yWgXKd/To7uk1dIyobOf7TIUVXjQgTZ4yF3xne1sZPh48OYEvJIFAYEo6/P/k+bOCN2IyMDnn0d9s8G3LOltf0wGjG4P4MYqumjsDw3wT10wy5L3myoumn8xBpcNki71n15HGTq2eWco7VZ3beVIU9FspSV618UwNEbvFR6NqWjHnd4bFbjsuP8szEaf8fTsfroiFrgWKoxa05tjF8WE+rY3K/mhJ2Z9GNPDzu9Wumrn+frRqZUwKg4p5EH27zalq0x54jAX3KnRp2aPg7UQhiARwSZAjNv4BqoDNy/woYhsDXcIf1s7wvCR6/Sg5//4emU/FmuZjl5w5R444TucAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by DS0PR11MB7214.namprd11.prod.outlook.com (2603:10b6:8:139::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 02:06:57 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9456.015; Fri, 16 Jan 2026
 02:06:51 +0000
Date: Thu, 15 Jan 2026 18:06:48 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: <mpenttil@redhat.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, David Hildenbrand
	<david@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky
	<leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>, Balbir Singh
	<balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH 1/3] mm: unified hmm fault and migrate device pagewalk
 paths
Message-ID: <aWmdOMOYomnJrJWQ@lstrano-desk.jf.intel.com>
References: <20260114091923.3950465-1-mpenttil@redhat.com>
 <20260114091923.3950465-2-mpenttil@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260114091923.3950465-2-mpenttil@redhat.com>
X-ClientProxiedBy: BY5PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::35) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|DS0PR11MB7214:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f7915ef-ac57-47c2-c351-08de54a3e9bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?GKarkNpgJT+vfutiv5jKMMGeUavYI/wNWBTG98uXA85kP0YArPMdXScYqg?=
 =?iso-8859-1?Q?hW3xHIfIOGo8CmmCtl5qZWUNk9BGDW0ykvoBWNTapUu77XJFcCrQrpM6/R?=
 =?iso-8859-1?Q?Q9KYHrHc+DWpYjPTg3NN+tnwc24b0nIe8taUV5yxbuj72sLKHnQaGAl+8H?=
 =?iso-8859-1?Q?97bBtVbhr/l1LXKA1x54e2hcA3bczmzGfjbnVfIlyPo96ZPs0Zbb6dzYLY?=
 =?iso-8859-1?Q?LMbhTLYtADIUboUGKcUoVKSBTLtllATOTJJVUxHXZI//Q2n4G/KYgXQw4u?=
 =?iso-8859-1?Q?tbrXbkPwPs6XUDgI8ZX5ZAbewaRU6/+zCQ25/huYrjEhGI9OdHqioBvYpg?=
 =?iso-8859-1?Q?nak+Sx4HPuBLfWOvNaaP+Orn2PfPvqZ4brnGTV/NYx2ztmWAvwnWi3bdHo?=
 =?iso-8859-1?Q?F6cWAtbKs4GgyujNoBNKaqkEjWugMt5856sG6/52UyjTFNS3ncf463uqeL?=
 =?iso-8859-1?Q?UQIuuS4c84GyHse1qZrvChbauk01kXrODYmOYdgiEjqcntHkXZa2HVg3Yz?=
 =?iso-8859-1?Q?69ky+vLBrKVKTDoMGoS+YM9mqYTf8vX5XI60c/Gz37pJo6nIPYbcVC2zqo?=
 =?iso-8859-1?Q?3Knen3+4k0C1xeXJSeIKNmKjCyzMvdizPTmXPrbWGfAKoap2Ls91YLYoCo?=
 =?iso-8859-1?Q?rfScwYGEgLrK4xk6qIRkI9vnYa0lwhMKjDKCZdfT+dGRstTm9RAc7dVX7y?=
 =?iso-8859-1?Q?s41T9iuCirkNJ2YEnY7VNTPEi2Qjyxu4bgf/znExgyQ8hJvD9DcXfbjthD?=
 =?iso-8859-1?Q?caXT342TnTd571DprY42/6Ce1vqjwXDEygpn5I2WKmmUIw0v82qrHka2f1?=
 =?iso-8859-1?Q?lOZLT2FEqX0VGKTFcyQgt/GwfpT62B5sDWZMgUGoO/CRqeBvDc3Sd7pKMC?=
 =?iso-8859-1?Q?Jrdi4Ldy2NHo8Mc5YlNVIty73S2ms5L+EwYFIyUzx3qxRfhgrgM3D+A8ZY?=
 =?iso-8859-1?Q?09yzi4eWCmhQfgcW/RIEARDy+/NtN2gDPd2pluZmhi0ALpMSeIx67A15b2?=
 =?iso-8859-1?Q?1yRgisvNTjHwQsRJARsmy7dSfJot5aOZNSGJ/BlJm/bjS+Co3OnXDpkeuu?=
 =?iso-8859-1?Q?IQwC7SbZuopQwEJkReyRZOx040SMivIs5B4zrTLnQq7hiWdkf8ZR3ZBJoW?=
 =?iso-8859-1?Q?hIpZtT88RRIhKN3DVs4v/atuMV/Q5Sh1oaXVyNNMkTuYoxLYSi8AsodFpm?=
 =?iso-8859-1?Q?EV5yMUVWUhprvHbA/OrExZIfelURvBrKuGG3Zv16lm2wayY+CUa5oDyXzp?=
 =?iso-8859-1?Q?8PuKGE3vGDbl4hkz8cIfQMHevMO2PMcJ96TeqF/AneueGhfMV88m4SGIA7?=
 =?iso-8859-1?Q?LOOlM/VXTmnmN1rutfwk4Y3kJb2guktLEr73VwFCRxQ22YOi7Ulg7OsHbZ?=
 =?iso-8859-1?Q?J0kQ3dc5Ff2sV6cKAkITwyVzPjcpyXnMzNzikT/C8JAHVpcmjLMe+hwtZl?=
 =?iso-8859-1?Q?7AmljOD0t/zE1CxUY7ww6FmQGM4YkcWBs6RGmleanUZLzxW002I+kT12ni?=
 =?iso-8859-1?Q?tvKa0DxlXtoxv7lKM/rxFQARgYIuJcCpk7/Od5lkr1gP2EfDce+LvqRxeC?=
 =?iso-8859-1?Q?6h4vsGbhQ90iP2h8MXaaJfik7bxDLaVk8y6B+khGO/uMFqLPyGPaLg2xA2?=
 =?iso-8859-1?Q?42/ucA+SXYYSs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?1DcO6FtwbwVf7XMxhTmHSl6d3uQizeAlOqrZmswQf0C8w+WW83WNRmt6B/?=
 =?iso-8859-1?Q?IieuPhWjqM1+U77a5ex6GIYlScT0WCwkuTV5uOhpzJm8JdpQew91+PIFok?=
 =?iso-8859-1?Q?FNkBan3zUU7lUgnfg8bmrBXRxIPegvwVnTQreOgKUg97nAIMIjMOoNV9LZ?=
 =?iso-8859-1?Q?o/SHhNTBnaCRFHZOB3Zve8bVL+FM5b4a2F0OG0LdbKN+m15gUYeSp8Sf5t?=
 =?iso-8859-1?Q?ObgRKxmwPpU0sUlNS4gYcn+g3I3m3d82fCQ0Va94csWseUuPwUnw4PFvZe?=
 =?iso-8859-1?Q?W5plcSMTpS8wapY6Va+l4kPO2tPNDatuC/SfhmKJSFFKsxuNRkcjWc2TeB?=
 =?iso-8859-1?Q?V9MQ/Ne06wgWxnikwQJKpqfqCMWlNKGjkJ0ZZjm42zhrrTrueXSJyIxplK?=
 =?iso-8859-1?Q?vV2/s0kI3LOS0rov4XGlZOOTuVSX5pfFnKiNU9DUUT+FcmrorW/ly79BjS?=
 =?iso-8859-1?Q?akUBsAg2ujRVWCMe6DOUU3S89GSxi+HlKOWpnZA2p01zNFh4NF/Q1/fxxE?=
 =?iso-8859-1?Q?lJxBGtV6FMTbIP8MkYCB/SseaWZwWNfWu56dgcvcO30M8hOueOALX/GJi/?=
 =?iso-8859-1?Q?udrEG1a3CfbKKZF8s0fzICqu9FharqrJboW63bYoLkJ69OFrzOHYvQI1a4?=
 =?iso-8859-1?Q?abbXF6XNqCUVKDiXbtvjrJB17wrPY2hKrLFmlKuzaXjUYHEMFK+0qyGGFz?=
 =?iso-8859-1?Q?z0uvct7lrqtE/n2JKXui08Hm+YGqLfNMGABmtHmieb9d7htB3aesmpBneH?=
 =?iso-8859-1?Q?ql/Ngf8mtYJmT38ucwODR0y9s7xAhlsymwPWRryN2qXVSv6g0mcyWLIBvk?=
 =?iso-8859-1?Q?fS352/ptGh2/WHKdZBngcr98qtO3MqGwK0Em0J305bF2RjPkGVDstBoJrI?=
 =?iso-8859-1?Q?3BVjp+iM8RLfhOyaxEs6AQFrWaVIbNJVoxpTZpy83SmJBauoOQveemXaaJ?=
 =?iso-8859-1?Q?XpsFZybRIwZPwp10np7zJtcDz7uLRx8mpDF/kqrfDNcVLuUa9a0b8gS2zx?=
 =?iso-8859-1?Q?uxap3RtWlQ5QJOe3EPd4mslWq0CyXKbM5Ikq46VEDnvfuKZ080Fy8dM1xf?=
 =?iso-8859-1?Q?nhkpmQUkSRZwoxYXI6pJhNG3ZbvyTnhRgS33TSFJXAdrPXVKUdzkIl0DGh?=
 =?iso-8859-1?Q?m6Pb0DgedIKYaEGot4f0LXH0PaC4jB5qVi6d+ry0bv6I+n3yhsB0PR8os0?=
 =?iso-8859-1?Q?JWaoNcecREeE/ZRMnqfu/ItiXZ2kPhUrL75l5jT9n7rH2pi388lHwVxSdk?=
 =?iso-8859-1?Q?RavDiPjp19UdSjmwXlvnfmgvXSg5MIakwMLOQxt/krIRsmepac4MzhtJaB?=
 =?iso-8859-1?Q?ibgvMhMgqFrRQi/vMg0V7VZSHIojrDswOehR+qA6u38ZzSNjtfAolHoOBb?=
 =?iso-8859-1?Q?qkIzoYr8SdFr2nvoMxg3/BWCa51DZsy0HDLYZbiKDEw5uRAqBvN1mk34pD?=
 =?iso-8859-1?Q?qd+Hn6hUG8n2A7HYaPST+hB9PmCSehK4IiinZK/KFc0AbeDMRWDazl+C0j?=
 =?iso-8859-1?Q?zE9XNFK2oi/H/vT4yRQny9CWKwq1vl4YAcXZ4Jgfmzz40CiT5trzT168wn?=
 =?iso-8859-1?Q?FZzUG388z7MKsg8ae+n8x4/p+M9xVPlmR4jOzFoQkeCVRuooBudoOrksNC?=
 =?iso-8859-1?Q?Mp5K9+MNPvMr0huCRuAuwDh7kqz82BUC3RFOR82GsJu9EDDdLUqWfMELmN?=
 =?iso-8859-1?Q?nPt/4CiWQUxtd/YNJAl7UD/bV8+smgJ1qMt53pfcmPrWWmN7u7S59mvXHX?=
 =?iso-8859-1?Q?i58SDlF80Ldy/VuLbJlUcK4Lsj3oy5XQJTLEpkmbS457N5xnlsgvmINyal?=
 =?iso-8859-1?Q?nhZquLlrvg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f7915ef-ac57-47c2-c351-08de54a3e9bd
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 02:06:51.2593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z/h4cDfsp+KvEUUnYXUTLbU/lmOOvIRi6qDfKTl8GF9a8HiAgqQGFWR47n+TC8bLQsZwsVERvvH52EeMHmq8iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7214
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DC188180003
X-Rspam-User: 
X-Stat-Signature: bbgsz3pitwzdp4icjiae9s91gm8ts84t
X-HE-Tag: 1768529223-75716
X-HE-Meta: U2FsdGVkX1/I/qq8y0IH5GG+aWPm2nvmpmrz5MCYomMemKuwf+6xciMe9fgC5oOU+kYpuRWHg2OYp+KPuijRC1DHezL+DSdBnaCwDCwyJyetFws4JW4NnfW4beL7E6k6zU0z4sT6Jp7HLHfcVsz99xUm/CR5kfDxQoTyDJKVb/6vW/KJ9aDtWhXaWlHAhETqkcR9IrQYLUYre2cRgBumTv7uaNm1bGpztOqhpaK9wXOB7BFzE+oZsYIN9K1odVettz9VSG2uXHuJtn1cs62nsTvfSlyw77Ln4qmCbVxImYIewxkiS2kTgdzN5sqjg79fhhofC8Y6T6z2SEAfpEXJz+KFHEznRv0uBjYO2epZnBLK1wGBxJfrAzsPAVFCe+f0CMy+VNIVULPYnMG/ARhvPo1wxDp4G6y0FAt0ZPHCVW2aZXnhwJXnymvXHZGOMmSF5mdL7MoQ7CMIxHUwdpZAyH7R7w8s4X1eCZ1NPlGlECahkBo9qXVeIDOuOD+9NXJwfB6cv8G2LqCHgmPULOlfGsgRJCYEM/9sSLsxhxMgW7LZZFVM+RT98nwBSQoBgO3zBC1pFNsVy7WzI6A4LZuu+A70hbUXEkP5pTmPfTUJE3BRPDU845WK/mTJFhrDA9No3Y6WfJ6J+hj2skpErQXF8bS71xXXYhu8aGAx7lbY0+J9VWC4WC/ELXPV7QXjZg6CD0VL8YIKHNq6I59PXtgK42oy16KRFO+rrEIVLK5xu9QCHZHXoj/NF8ETQnqQsXi5OhEBwfib8NIToFZ/3fCEKuT+O8Al/6VmHr9ZYglCaatW+9FIdVKJv1eXTUqnREPyLxP/xM81rEDgYB535JgmH6Y5G0blf350XsBpixKTDhLmsBu+pmRyMXsjmO1TkfVZ//m0AKNo1KPHiD/dYrJAUT3vaG/IeUnp2PiHQc2h0B6kbMHpSF5j4e2UkBKyQ0KDHkKcoiGp1hqilv0uLDP
 83HOPj7G
 /YKRxuajYc2FfZwpsbvZHBYhMWdNyztB8vCo78Yf49EzC3fM/vD3Huyn8K4256q2gGLyvzrV2JTvkXnz24sidUgjJwEMXUtgZGbC1GFGLi4Et8mYDkaQ3YEodb2OrLX863HhntulJCreO9jXF316NrUfTsFEwHllAc/8/yNt/FH/zPMoFwYVEJAzhP14aJKLb1sCUYiAZlddbsqOzcfV1Tx0D2hqWZlHWUG46vENQNRK/RfouNEQDF9SoCmob/brxhFCjERSdLQunPm4x1iVG3mO9AlkNYN6eANpgiBZ880oka8llN1Y9PrN5V3sa6mZKYcOsJP3mzksnLeWXz2MhpMwtwY+I9urMqQryITe7N+vmNhDditsAIKfydZrnPTPTVbL60+/B1zUsU7agx45DlOdyUJ50pBIQmwTG9hdndJlWumKEZXNiHOHJmuoSBh6e94wkcRjMYHscXVJ8Z8ShHVuwdHlFwiJCk+J7xM1SqyTwAaZFDWiOf131LjXF8KWYN1hpXyaKFrt02RZ66I+OUHo/zA5o2yuctOXxozkkiyShuzANWvopdX0Kwv1LTWxmeZd0KvCzf3CuGR/8eWbbXpB6D8WimSy/UgenM720ei2oOTb8rk8036uVt0pbo8lvmCcR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 11:19:21AM +0200, mpenttil@redhat.com wrote:
> From: Mika Penttilä <mpenttil@redhat.com>
> 
> Currently, the way device page faulting and migration works
> is not optimal, if you want to do both fault handling and
> migration at once.
> 
> Being able to migrate not present pages (or pages mapped with incorrect
> permissions, eg. COW) to the GPU requires doing either of the
> following sequences:
> 
> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
> 2. migrate_vma_*() - migrate the pages
> 
> Or:
> 
> 1. migrate_vma_*() - migrate present pages
> 2. If non-present pages detected by migrate_vma_*():
>    a) call hmm_range_fault() to fault pages in
>    b) call migrate_vma_*() again to migrate now present pages
> 
> The problem with the first sequence is that you always have to do two
> page walks even when most of the time the pages are present or zero page
> mappings so the common case takes a performance hit.
> 
> The second sequence is better for the common case, but far worse if
> pages aren't present because now you have to walk the page tables three
> times (once to find the page is not present, once so hmm_range_fault()
> can find a non-present page to fault in and once again to setup the
> migration). It is also tricky to code correctly.
> 
> We should be able to walk the page table once, faulting
> pages in as required and replacing them with migration entries if
> requested.
> 
> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
> which tells to prepare for migration also during fault handling.
> Also, for the migrate_vma_setup() call paths, a flags, MIGRATE_VMA_FAULT,
> is added to tell to add fault handling to migrate.
> 
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Matthew Brost <matthew.brost@intel.com>

I'll try to test this when I can but horribly behind at the moment.

You can use Intel's CI system to test SVM too. I can get you authorized
to use this. The list to trigger is intel-xe@lists.freedesktop.org and
patches must apply to drm-tip. I'll let you know when you are
authorized.

> Suggested-by: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
> ---
>  include/linux/hmm.h     |  17 +-
>  include/linux/migrate.h |   6 +-
>  mm/hmm.c                | 657 +++++++++++++++++++++++++++++++++++++---
>  mm/migrate_device.c     |  81 ++++-
>  4 files changed, 706 insertions(+), 55 deletions(-)
> 
> diff --git a/include/linux/hmm.h b/include/linux/hmm.h
> index db75ffc949a7..7b7294ad0f62 100644
> --- a/include/linux/hmm.h
> +++ b/include/linux/hmm.h
> @@ -12,7 +12,7 @@
>  #include <linux/mm.h>
>  
>  struct mmu_interval_notifier;
> -
> +struct migrate_vma;
>  /*
>   * On output:
>   * 0             - The page is faultable and a future call with 
> @@ -48,15 +48,25 @@ enum hmm_pfn_flags {
>  	HMM_PFN_P2PDMA     = 1UL << (BITS_PER_LONG - 5),
>  	HMM_PFN_P2PDMA_BUS = 1UL << (BITS_PER_LONG - 6),
>  
> -	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 11),
> +	/* Migrate request */
> +	HMM_PFN_MIGRATE    = 1UL << (BITS_PER_LONG - 7),
> +	HMM_PFN_COMPOUND   = 1UL << (BITS_PER_LONG - 8),
> +	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 13),
>  
>  	/* Input flags */
>  	HMM_PFN_REQ_FAULT = HMM_PFN_VALID,
>  	HMM_PFN_REQ_WRITE = HMM_PFN_WRITE,
> +	HMM_PFN_REQ_MIGRATE = HMM_PFN_MIGRATE,

I believe you are missing kernel for HMM_PFN_MIGRATE.

>  
>  	HMM_PFN_FLAGS = ~((1UL << HMM_PFN_ORDER_SHIFT) - 1),
>  };
>  
> +enum {
> +	/* These flags are carried from input-to-output */
> +	HMM_PFN_INOUT_FLAGS = HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA |
> +		HMM_PFN_P2PDMA_BUS,
> +};
> +
>  /*
>   * hmm_pfn_to_page() - return struct page pointed to by a device entry
>   *
> @@ -107,6 +117,7 @@ static inline unsigned int hmm_pfn_to_map_order(unsigned long hmm_pfn)
>   * @default_flags: default flags for the range (write, read, ... see hmm doc)
>   * @pfn_flags_mask: allows to mask pfn flags so that only default_flags matter
>   * @dev_private_owner: owner of device private pages
> + * @migrate: structure for migrating the associated vma
>   */
>  struct hmm_range {
>  	struct mmu_interval_notifier *notifier;
> @@ -117,12 +128,14 @@ struct hmm_range {
>  	unsigned long		default_flags;
>  	unsigned long		pfn_flags_mask;
>  	void			*dev_private_owner;
> +	struct migrate_vma      *migrate;
>  };
>  
>  /*
>   * Please see Documentation/mm/hmm.rst for how to use the range API.
>   */
>  int hmm_range_fault(struct hmm_range *range);
> +int hmm_range_migrate_prepare(struct hmm_range *range, struct migrate_vma **pargs);
>  
>  /*
>   * HMM_RANGE_DEFAULT_TIMEOUT - default timeout (ms) when waiting for a range
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index 26ca00c325d9..0889309a9d21 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -3,6 +3,7 @@
>  #define _LINUX_MIGRATE_H
>  
>  #include <linux/mm.h>
> +#include <linux/hmm.h>
>  #include <linux/mempolicy.h>
>  #include <linux/migrate_mode.h>
>  #include <linux/hugetlb.h>
> @@ -140,11 +141,12 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
>  	return (pfn << MIGRATE_PFN_SHIFT) | MIGRATE_PFN_VALID;
>  }
>  
> -enum migrate_vma_direction {
> +enum migrate_vma_info {
>  	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
>  	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
> +	MIGRATE_VMA_FAULT = 1 << 4,
>  };
>  
>  struct migrate_vma {
> @@ -192,7 +194,7 @@ void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
>  			unsigned long npages);
>  void migrate_device_finalize(unsigned long *src_pfns,
>  			unsigned long *dst_pfns, unsigned long npages);
> -
> +void migrate_hmm_range_setup(struct hmm_range *range);
>  #endif /* CONFIG_MIGRATION */
>  
>  #endif /* _LINUX_MIGRATE_H */
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 4ec74c18bef6..39a07d895043 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -20,6 +20,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/leafops.h>
>  #include <linux/hugetlb.h>
> +#include <linux/migrate.h>
>  #include <linux/memremap.h>
>  #include <linux/sched/mm.h>
>  #include <linux/jump_label.h>
> @@ -31,8 +32,12 @@
>  #include "internal.h"
>  
>  struct hmm_vma_walk {
> -	struct hmm_range	*range;
> -	unsigned long		last;
> +	struct mmu_notifier_range	mmu_range;
> +	struct vm_area_struct		*vma;
> +	struct hmm_range		*range;
> +	unsigned long			start;
> +	unsigned long			end;
> +	unsigned long			last;
>  };
>  
>  enum {
> @@ -41,21 +46,49 @@ enum {
>  	HMM_NEED_ALL_BITS = HMM_NEED_FAULT | HMM_NEED_WRITE_FAULT,
>  };
>  
> -enum {
> -	/* These flags are carried from input-to-output */
> -	HMM_PFN_INOUT_FLAGS = HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA |
> -			      HMM_PFN_P2PDMA_BUS,
> -};
> +static enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
> +{
> +	enum migrate_vma_info minfo;
> +
> +	minfo = range->migrate ? range->migrate->flags : 0;
> +	minfo |= (range->default_flags & HMM_PFN_REQ_MIGRATE) ?
> +		MIGRATE_VMA_SELECT_SYSTEM : 0;

I'm trying to make sense of HMM_PFN_REQ_MIGRATE and why it sets
MIGRATE_VMA_SELECT_SYSTEM?

Also the just the general usage - would range->migrate be NULL in the
expected usage.

Maybe an example of how hmm_range_fault would be called with this flag
and subsequent expected migrate calls would clear this up.

> +
> +	return minfo;
> +}
>  
>  static int hmm_pfns_fill(unsigned long addr, unsigned long end,
> -			 struct hmm_range *range, unsigned long cpu_flags)
> +			 struct hmm_vma_walk *hmm_vma_walk, unsigned long cpu_flags)
>  {
> +	struct hmm_range *range = hmm_vma_walk->range;
>  	unsigned long i = (addr - range->start) >> PAGE_SHIFT;
> +	enum migrate_vma_info minfo;
> +	bool migrate = false;
> +
> +	minfo = hmm_select_migrate(range);
> +	if (cpu_flags != HMM_PFN_ERROR) {
> +		if (minfo && (vma_is_anonymous(hmm_vma_walk->vma))) {
> +			cpu_flags |= (HMM_PFN_VALID | HMM_PFN_MIGRATE);
> +			migrate = true;
> +		}
> +	}
> +
> +	if (migrate && thp_migration_supported() &&
> +	    (minfo & MIGRATE_VMA_SELECT_COMPOUND) &&
> +	    IS_ALIGNED(addr, HPAGE_PMD_SIZE) &&
> +	    IS_ALIGNED(end, HPAGE_PMD_SIZE)) {
> +		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
> +		range->hmm_pfns[i] |= cpu_flags | HMM_PFN_COMPOUND;
> +		addr += PAGE_SIZE;
> +		i++;
> +		cpu_flags = 0;
> +	}
>  
>  	for (; addr < end; addr += PAGE_SIZE, i++) {
>  		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
>  		range->hmm_pfns[i] |= cpu_flags;
>  	}
> +
>  	return 0;
>  }
>  
> @@ -171,11 +204,11 @@ static int hmm_vma_walk_hole(unsigned long addr, unsigned long end,
>  	if (!walk->vma) {
>  		if (required_fault)
>  			return -EFAULT;
> -		return hmm_pfns_fill(addr, end, range, HMM_PFN_ERROR);
> +		return hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
>  	}
>  	if (required_fault)
>  		return hmm_vma_fault(addr, end, required_fault, walk);
> -	return hmm_pfns_fill(addr, end, range, 0);
> +	return hmm_pfns_fill(addr, end, hmm_vma_walk, 0);
>  }
>  
>  static inline unsigned long hmm_pfn_flags_order(unsigned long order)
> @@ -289,10 +322,13 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>  			goto fault;
>  
>  		if (softleaf_is_migration(entry)) {
> -			pte_unmap(ptep);
> -			hmm_vma_walk->last = addr;
> -			migration_entry_wait(walk->mm, pmdp, addr);
> -			return -EBUSY;
> +			if (!hmm_select_migrate(range)) {
> +				pte_unmap(ptep);
> +				hmm_vma_walk->last = addr;
> +				migration_entry_wait(walk->mm, pmdp, addr);
> +				return -EBUSY;
> +			} else
> +				goto out;
>  		}
>  
>  		/* Report error for everything else */
> @@ -376,7 +412,7 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>  			return -EFAULT;
>  	}
>  
> -	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> +	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>  }
>  #else
>  static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
> @@ -389,10 +425,448 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>  
>  	if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>  		return -EFAULT;
> -	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> +	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>  }
>  #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
>  
> +/**
> + * migrate_vma_split_folio() - Helper function to split a THP folio
> + * @folio: the folio to split
> + * @fault_page: struct page associated with the fault if any
> + *
> + * Returns 0 on success
> + */
> +static int migrate_vma_split_folio(struct folio *folio,
> +				   struct page *fault_page)
> +{
> +	int ret;
> +	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
> +	struct folio *new_fault_folio = NULL;
> +
> +	if (folio != fault_folio) {
> +		folio_get(folio);
> +		folio_lock(folio);
> +	}
> +
> +	ret = split_folio(folio);
> +	if (ret) {
> +		if (folio != fault_folio) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +		return ret;
> +	}
> +
> +	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
> +
> +	/*
> +	 * Ensure the lock is held on the correct
> +	 * folio after the split
> +	 */
> +	if (!new_fault_folio) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	} else if (folio != new_fault_folio) {
> +		if (new_fault_folio != fault_folio) {
> +			folio_get(new_fault_folio);
> +			folio_lock(new_fault_folio);
> +		}
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +
> +	return 0;
> +}
> +
> +static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
> +					      pmd_t *pmdp,
> +					      unsigned long start,
> +					      unsigned long end,
> +					      unsigned long *hmm_pfn)
> +{
> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> +	struct hmm_range *range = hmm_vma_walk->range;
> +	struct migrate_vma *migrate = range->migrate;
> +	struct mm_struct *mm = walk->vma->vm_mm;
> +	struct folio *fault_folio = NULL;
> +	struct folio *folio;
> +	enum migrate_vma_info minfo;
> +	spinlock_t *ptl;
> +	unsigned long i;
> +	int r = 0;
> +
> +	minfo = hmm_select_migrate(range);
> +	if (!minfo)
> +		return r;
> +
> +	fault_folio = (migrate && migrate->fault_page) ?
> +		page_folio(migrate->fault_page) : NULL;
> +
> +	ptl = pmd_lock(mm, pmdp);
> +	if (pmd_none(*pmdp)) {
> +		spin_unlock(ptl);
> +		return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
> +	}
> +
> +	if (pmd_trans_huge(*pmdp)) {
> +		if (!(minfo & MIGRATE_VMA_SELECT_SYSTEM))
> +			goto out;
> +
> +		folio = pmd_folio(*pmdp);
> +		if (is_huge_zero_folio(folio)) {
> +			spin_unlock(ptl);
> +			return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
> +		}
> +
> +	} else if (!pmd_present(*pmdp)) {
> +		const softleaf_t entry = softleaf_from_pmd(*pmdp);
> +
> +		folio = softleaf_to_folio(entry);
> +
> +		if (!softleaf_is_device_private(entry))
> +			goto out;
> +
> +		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
> +			goto out;
> +		if (folio->pgmap->owner != migrate->pgmap_owner)
> +			goto out;
> +
> +	} else {
> +		spin_unlock(ptl);
> +		return -EBUSY;
> +	}
> +
> +	folio_get(folio);
> +
> +	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
> +		spin_unlock(ptl);
> +		folio_put(folio);
> +		return 0;
> +	}
> +
> +	if (thp_migration_supported() &&
> +	    (migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
> +	    (IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
> +	     IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
> +
> +		struct page_vma_mapped_walk pvmw = {
> +			.ptl = ptl,
> +			.address = start,
> +			.pmd = pmdp,
> +			.vma = walk->vma,
> +		};
> +
> +		hmm_pfn[0] |= HMM_PFN_MIGRATE | HMM_PFN_COMPOUND;
> +
> +		r = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
> +		if (r) {
> +			hmm_pfn[0] &= ~(HMM_PFN_MIGRATE | HMM_PFN_COMPOUND);
> +			r = -ENOENT;  // fallback
> +			goto unlock_out;
> +		}
> +		for (i = 1, start += PAGE_SIZE; start < end; start += PAGE_SIZE, i++)
> +			hmm_pfn[i] &= HMM_PFN_INOUT_FLAGS;
> +
> +	} else {
> +		r = -ENOENT;  // fallback
> +		goto unlock_out;
> +	}
> +
> +
> +out:
> +	spin_unlock(ptl);
> +	return r;
> +
> +unlock_out:
> +	if (folio != fault_folio)
> +		folio_unlock(folio);
> +	folio_put(folio);
> +	goto out;
> +
> +}
> +
> +/*
> + * Install migration entries if migration requested, either from fault
> + * or migrate paths.
> + *
> + */
> +static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
> +					  pmd_t *pmdp,
> +					  unsigned long addr,
> +					  unsigned long *hmm_pfn)
> +{
> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> +	struct hmm_range *range = hmm_vma_walk->range;
> +	struct migrate_vma *migrate = range->migrate;
> +	struct mm_struct *mm = walk->vma->vm_mm;
> +	struct folio *fault_folio = NULL;
> +	enum migrate_vma_info minfo;
> +	struct dev_pagemap *pgmap;
> +	bool anon_exclusive;
> +	struct folio *folio;
> +	unsigned long pfn;
> +	struct page *page;
> +	softleaf_t entry;
> +	pte_t pte, swp_pte;
> +	spinlock_t *ptl;
> +	bool writable = false;
> +	pte_t *ptep;
> +
> +	// Do we want to migrate at all?
> +	minfo = hmm_select_migrate(range);
> +	if (!minfo)
> +		return 0;
> +
> +	fault_folio = (migrate && migrate->fault_page) ?
> +		page_folio(migrate->fault_page) : NULL;
> +
> +again:
> +	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
> +	if (!ptep)
> +		return 0;
> +
> +	pte = ptep_get(ptep);
> +
> +	if (pte_none(pte)) {
> +		// migrate without faulting case
> +		if (vma_is_anonymous(walk->vma)) {
> +			*hmm_pfn &= HMM_PFN_INOUT_FLAGS;
> +			*hmm_pfn |= HMM_PFN_MIGRATE | HMM_PFN_VALID;
> +			goto out;
> +		}
> +	}
> +
> +	if (!pte_present(pte)) {
> +		/*
> +		 * Only care about unaddressable device page special
> +		 * page table entry. Other special swap entries are not
> +		 * migratable, and we ignore regular swapped page.
> +		 */
> +		entry = softleaf_from_pte(pte);
> +		if (!softleaf_is_device_private(entry))
> +			goto out;
> +
> +		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
> +			goto out;
> +
> +		page = softleaf_to_page(entry);
> +		folio = page_folio(page);
> +		if (folio->pgmap->owner != migrate->pgmap_owner)
> +			goto out;
> +
> +		if (folio_test_large(folio)) {
> +			int ret;
> +
> +			pte_unmap_unlock(ptep, ptl);
> +			ret = migrate_vma_split_folio(folio,
> +						      migrate->fault_page);
> +			if (ret)
> +				goto out_unlocked;
> +			goto again;
> +		}
> +
> +		pfn = page_to_pfn(page);
> +		if (softleaf_is_device_private_write(entry))
> +			writable = true;
> +	} else {
> +		pfn = pte_pfn(pte);
> +		if (is_zero_pfn(pfn) &&
> +		    (minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
> +			*hmm_pfn = HMM_PFN_MIGRATE|HMM_PFN_VALID;
> +			goto out;
> +		}
> +		page = vm_normal_page(walk->vma, addr, pte);
> +		if (page && !is_zone_device_page(page) &&
> +		    !(minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
> +			goto out;
> +		} else if (page && is_device_coherent_page(page)) {
> +			pgmap = page_pgmap(page);
> +
> +			if (!(minfo &
> +			      MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
> +			    pgmap->owner != migrate->pgmap_owner)
> +				goto out;
> +		}
> +
> +		folio = page_folio(page);
> +		if (folio_test_large(folio)) {
> +			int ret;
> +
> +			pte_unmap_unlock(ptep, ptl);
> +			ret = migrate_vma_split_folio(folio,
> +						      migrate->fault_page);
> +			if (ret)
> +				goto out_unlocked;
> +
> +			goto again;
> +		}
> +
> +		writable = pte_write(pte);
> +	}
> +
> +	if (!page || !page->mapping)
> +		goto out;
> +
> +	/*
> +	 * By getting a reference on the folio we pin it and that blocks
> +	 * any kind of migration. Side effect is that it "freezes" the
> +	 * pte.
> +	 *
> +	 * We drop this reference after isolating the folio from the lru
> +	 * for non device folio (device folio are not on the lru and thus
> +	 * can't be dropped from it).
> +	 */
> +	folio = page_folio(page);
> +	folio_get(folio);
> +
> +	/*
> +	 * We rely on folio_trylock() to avoid deadlock between
> +	 * concurrent migrations where each is waiting on the others
> +	 * folio lock. If we can't immediately lock the folio we fail this
> +	 * migration as it is only best effort anyway.
> +	 *
> +	 * If we can lock the folio it's safe to set up a migration entry
> +	 * now. In the common case where the folio is mapped once in a
> +	 * single process setting up the migration entry now is an
> +	 * optimisation to avoid walking the rmap later with
> +	 * try_to_migrate().
> +	 */
> +
> +	if (fault_folio == folio || folio_trylock(folio)) {
> +		anon_exclusive = folio_test_anon(folio) &&
> +			PageAnonExclusive(page);
> +
> +		flush_cache_page(walk->vma, addr, pfn);
> +
> +		if (anon_exclusive) {
> +			pte = ptep_clear_flush(walk->vma, addr, ptep);
> +
> +			if (folio_try_share_anon_rmap_pte(folio, page)) {
> +				set_pte_at(mm, addr, ptep, pte);
> +				folio_unlock(folio);
> +				folio_put(folio);
> +				goto out;
> +			}
> +		} else {
> +			pte = ptep_get_and_clear(mm, addr, ptep);
> +		}
> +
> +		/* Setup special migration page table entry */
> +		if (writable)
> +			entry = make_writable_migration_entry(pfn);
> +		else if (anon_exclusive)
> +			entry = make_readable_exclusive_migration_entry(pfn);
> +		else
> +			entry = make_readable_migration_entry(pfn);
> +
> +		swp_pte = swp_entry_to_pte(entry);
> +		if (pte_present(pte)) {
> +			if (pte_soft_dirty(pte))
> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
> +			if (pte_uffd_wp(pte))
> +				swp_pte = pte_swp_mkuffd_wp(swp_pte);
> +		} else {
> +			if (pte_swp_soft_dirty(pte))
> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
> +			if (pte_swp_uffd_wp(pte))
> +				swp_pte = pte_swp_mkuffd_wp(swp_pte);
> +		}
> +
> +		set_pte_at(mm, addr, ptep, swp_pte);
> +		folio_remove_rmap_pte(folio, page, walk->vma);
> +		folio_put(folio);
> +		*hmm_pfn |= HMM_PFN_MIGRATE;
> +
> +		if (pte_present(pte))
> +			flush_tlb_range(walk->vma, addr, addr + PAGE_SIZE);
> +	} else
> +		folio_put(folio);
> +out:
> +	pte_unmap_unlock(ptep, ptl);
> +	return 0;
> +out_unlocked:
> +	return -1;
> +
> +}
> +
> +static int hmm_vma_walk_split(pmd_t *pmdp,
> +			      unsigned long addr,
> +			      struct mm_walk *walk)
> +{
> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> +	struct hmm_range *range = hmm_vma_walk->range;
> +	struct migrate_vma *migrate = range->migrate;
> +	struct folio *folio, *fault_folio;
> +	spinlock_t *ptl;
> +	int ret = 0;
> +
> +	fault_folio = (migrate && migrate->fault_page) ?
> +		page_folio(migrate->fault_page) : NULL;
> +
> +	ptl = pmd_lock(walk->mm, pmdp);
> +	if (unlikely(!pmd_trans_huge(*pmdp))) {
> +		spin_unlock(ptl);
> +		goto out;
> +	}
> +
> +	folio = pmd_folio(*pmdp);
> +	if (is_huge_zero_folio(folio)) {
> +		spin_unlock(ptl);
> +		split_huge_pmd(walk->vma, pmdp, addr);
> +	} else {
> +		folio_get(folio);
> +		spin_unlock(ptl);
> +
> +		if (folio != fault_folio) {
> +			if (unlikely(!folio_trylock(folio))) {
> +				folio_put(folio);
> +				ret = -EBUSY;
> +				goto out;
> +			}
> +		}  else
> +			folio_put(folio);
> +
> +		ret = split_folio(folio);
> +		if (fault_folio != folio) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +
> +	}
> +out:
> +	return ret;
> +}
> +
> +static int hmm_vma_capture_migrate_range(unsigned long start,
> +					 unsigned long end,
> +					 struct mm_walk *walk)
> +{
> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> +	struct hmm_range *range = hmm_vma_walk->range;
> +
> +	if (!hmm_select_migrate(range))
> +		return 0;
> +
> +	if (hmm_vma_walk->vma && (hmm_vma_walk->vma != walk->vma))
> +		return -ERANGE;
> +
> +	hmm_vma_walk->vma = walk->vma;
> +	hmm_vma_walk->start = start;
> +	hmm_vma_walk->end = end;
> +
> +	if (end - start > range->end - range->start)
> +		return -ERANGE;
> +
> +	if (!hmm_vma_walk->mmu_range.owner) {
> +		mmu_notifier_range_init_owner(&hmm_vma_walk->mmu_range, MMU_NOTIFY_MIGRATE, 0,
> +					      walk->vma->vm_mm, start, end,
> +					      range->dev_private_owner);
> +		mmu_notifier_invalidate_range_start(&hmm_vma_walk->mmu_range);
> +	}
> +
> +	return 0;
> +}
> +
>  static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  			    unsigned long start,
>  			    unsigned long end,
> @@ -404,42 +878,90 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  		&range->hmm_pfns[(start - range->start) >> PAGE_SHIFT];
>  	unsigned long npages = (end - start) >> PAGE_SHIFT;
>  	unsigned long addr = start;
> +	enum migrate_vma_info minfo;
> +	unsigned long i;
> +	spinlock_t *ptl;
>  	pte_t *ptep;
>  	pmd_t pmd;
> +	int r;
>  
> +	minfo = hmm_select_migrate(range);
>  again:
> +
>  	pmd = pmdp_get_lockless(pmdp);
> -	if (pmd_none(pmd))
> -		return hmm_vma_walk_hole(start, end, -1, walk);
> +	if (pmd_none(pmd)) {
> +		r = hmm_vma_walk_hole(start, end, -1, walk);
> +		if (r || !minfo)
> +			return r;
> +
> +		ptl = pmd_lock(walk->mm, pmdp);
> +		if (pmd_none(*pmdp)) {
> +			// hmm_vma_walk_hole() filled migration needs
> +			spin_unlock(ptl);
> +			return r;
> +		}
> +		spin_unlock(ptl);
> +	}
>  
>  	if (thp_migration_supported() && pmd_is_migration_entry(pmd)) {
> -		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
> -			hmm_vma_walk->last = addr;
> -			pmd_migration_entry_wait(walk->mm, pmdp);
> -			return -EBUSY;
> +		if (!minfo) {
> +			if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
> +				hmm_vma_walk->last = addr;
> +				pmd_migration_entry_wait(walk->mm, pmdp);
> +				return -EBUSY;
> +			}
>  		}
> -		return hmm_pfns_fill(start, end, range, 0);
> +		for (i = 0; addr < end; addr += PAGE_SIZE, i++)
> +			hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
> +
> +		return 0;
>  	}
>  
> -	if (!pmd_present(pmd))
> -		return hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
> -						 pmd);
> +	if (pmd_trans_huge(pmd) || !pmd_present(pmd)) {
> +
> +		if (!pmd_present(pmd)) {
> +			r = hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
> +						      pmd);
> +			if (r || !minfo)
> +				return r;
> +		} else {
> +
> +			/*
> +			 * No need to take pmd_lock here, even if some other thread
> +			 * is splitting the huge pmd we will get that event through
> +			 * mmu_notifier callback.
> +			 *
> +			 * So just read pmd value and check again it's a transparent
> +			 * huge or device mapping one and compute corresponding pfn
> +			 * values.
> +			 */
> +
> +			pmd = pmdp_get_lockless(pmdp);
> +			if (!pmd_trans_huge(pmd))
> +				goto again;
> +
> +			r = hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
> +
> +			if (r || !minfo)
> +				return r;
> +		}
>  
> -	if (pmd_trans_huge(pmd)) {
> -		/*
> -		 * No need to take pmd_lock here, even if some other thread
> -		 * is splitting the huge pmd we will get that event through
> -		 * mmu_notifier callback.
> -		 *
> -		 * So just read pmd value and check again it's a transparent
> -		 * huge or device mapping one and compute corresponding pfn
> -		 * values.
> -		 */
> -		pmd = pmdp_get_lockless(pmdp);
> -		if (!pmd_trans_huge(pmd))
> -			goto again;
> +		r = hmm_vma_handle_migrate_prepare_pmd(walk, pmdp, start, end, hmm_pfns);
> +
> +		if (r == -ENOENT) {
> +			r = hmm_vma_walk_split(pmdp, addr, walk);
> +			if (r) {
> +				/* Split not successful, skip */
> +				return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
> +			}
> +
> +			/* Split successful or "again", reloop */
> +			hmm_vma_walk->last = addr;
> +			return -EBUSY;
> +		}
> +
> +		return r;
>  
> -		return hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
>  	}
>  
>  	/*
> @@ -451,22 +973,26 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  	if (pmd_bad(pmd)) {
>  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>  			return -EFAULT;
> -		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> +		return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>  	}
>  
>  	ptep = pte_offset_map(pmdp, addr);
>  	if (!ptep)
>  		goto again;
>  	for (; addr < end; addr += PAGE_SIZE, ptep++, hmm_pfns++) {
> -		int r;
>  
>  		r = hmm_vma_handle_pte(walk, addr, end, pmdp, ptep, hmm_pfns);
>  		if (r) {
>  			/* hmm_vma_handle_pte() did pte_unmap() */
>  			return r;
>  		}
> +
> +		r = hmm_vma_handle_migrate_prepare(walk, pmdp, addr, hmm_pfns);
> +		if (r)
> +			break;
>  	}
>  	pte_unmap(ptep - 1);
> +
>  	return 0;
>  }
>  
> @@ -600,6 +1126,11 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
>  	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>  	struct hmm_range *range = hmm_vma_walk->range;
>  	struct vm_area_struct *vma = walk->vma;
> +	int r;
> +
> +	r = hmm_vma_capture_migrate_range(start, end, walk);
> +	if (r)
> +		return r;
>  
>  	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
>  	    vma->vm_flags & VM_READ)
> @@ -622,7 +1153,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
>  				 (end - start) >> PAGE_SHIFT, 0))
>  		return -EFAULT;
>  
> -	hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> +	hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>  
>  	/* Skip this vma and continue processing the next vma. */
>  	return 1;
> @@ -652,9 +1183,17 @@ static const struct mm_walk_ops hmm_walk_ops = {
>   *		the invalidation to finish.
>   * -EFAULT:     A page was requested to be valid and could not be made valid
>   *              ie it has no backing VMA or it is illegal to access
> + * -ERANGE:     The range crosses multiple VMAs, or space for hmm_pfns array
> + *              is too low.
>   *
>   * This is similar to get_user_pages(), except that it can read the page tables
>   * without mutating them (ie causing faults).
> + *
> + * If want to do migrate after faultin, call hmm_rangem_fault() with

s/faultin/faulting

s/hmm_rangem_fault/hmm_range_fault

> + * HMM_PFN_REQ_MIGRATE and initialize range.migrate field.

I'm not following the HMM_PFN_REQ_MIGRATE usage.

> + * After hmm_range_fault() call migrate_hmm_range_setup() instead of
> + * migrate_vma_setup() and after that follow normal migrate calls path.
> + *

Also since migrate_vma_setup calls hmm_range_fault then
migrate_hmm_range_setup what would the use case for not just calling
migrate_vma_setup be?

>   */
>  int hmm_range_fault(struct hmm_range *range)
>  {
> @@ -662,16 +1201,28 @@ int hmm_range_fault(struct hmm_range *range)
>  		.range = range,
>  		.last = range->start,
>  	};
> -	struct mm_struct *mm = range->notifier->mm;
> +	bool is_fault_path = !!range->notifier;
> +	struct mm_struct *mm;
>  	int ret;
>  
> +	/*
> +	 *
> +	 *  Could be serving a device fault or come from migrate
> +	 *  entry point. For the former we have not resolved the vma
> +	 *  yet, and the latter we don't have a notifier (but have a vma).
> +	 *
> +	 */
> +	mm = is_fault_path ? range->notifier->mm : range->migrate->vma->vm_mm;
>  	mmap_assert_locked(mm);
>  
>  	do {
>  		/* If range is no longer valid force retry. */
> -		if (mmu_interval_check_retry(range->notifier,
> -					     range->notifier_seq))
> -			return -EBUSY;
> +		if (is_fault_path && mmu_interval_check_retry(range->notifier,
> +					     range->notifier_seq)) {
> +			ret = -EBUSY;
> +			break;
> +		}
> +
>  		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
>  				      &hmm_walk_ops, &hmm_vma_walk);
>  		/*
> @@ -681,6 +1232,18 @@ int hmm_range_fault(struct hmm_range *range)
>  		 * output, and all >= are still at their input values.
>  		 */
>  	} while (ret == -EBUSY);
> +
> +	if (hmm_select_migrate(range) && range->migrate &&
> +	    hmm_vma_walk.mmu_range.owner) {
> +		// The migrate_vma path has the following initialized
> +		if (is_fault_path) {
> +			range->migrate->vma   = hmm_vma_walk.vma;
> +			range->migrate->start = range->start;
> +			range->migrate->end   = hmm_vma_walk.end;
> +		}
> +		mmu_notifier_invalidate_range_end(&hmm_vma_walk.mmu_range);
> +	}
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL(hmm_range_fault);
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 23379663b1e1..d89efdfca8f6 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -734,7 +734,17 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
>   */
>  int migrate_vma_setup(struct migrate_vma *args)
>  {
> +	int ret;
>  	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
> +	struct hmm_range range = {
> +		.notifier = NULL,
> +		.start = args->start,
> +		.end = args->end,
> +		.migrate = args,
> +		.hmm_pfns = args->src,
> +		.dev_private_owner = args->pgmap_owner,
> +		.migrate = args
> +	};
>  
>  	args->start &= PAGE_MASK;
>  	args->end &= PAGE_MASK;
> @@ -759,17 +769,19 @@ int migrate_vma_setup(struct migrate_vma *args)
>  	args->cpages = 0;
>  	args->npages = 0;
>  
> -	migrate_vma_collect(args);
> +	if (args->flags & MIGRATE_VMA_FAULT)
> +		range.default_flags |= HMM_PFN_REQ_FAULT;

Next level here might be skip faulting pte_none() in hmm_range_fault
too?

Matt

> +
> +	ret = hmm_range_fault(&range);
>  
> -	if (args->cpages)
> -		migrate_vma_unmap(args);
> +	migrate_hmm_range_setup(&range);
>  
>  	/*
>  	 * At this point pages are locked and unmapped, and thus they have
>  	 * stable content and can safely be copied to destination memory that
>  	 * is allocated by the drivers.
>  	 */
> -	return 0;
> +	return ret;
>  
>  }
>  EXPORT_SYMBOL(migrate_vma_setup);
> @@ -1489,3 +1501,64 @@ int migrate_device_coherent_folio(struct folio *folio)
>  		return 0;
>  	return -EBUSY;
>  }
> +
> +void migrate_hmm_range_setup(struct hmm_range *range)
> +{
> +
> +	struct migrate_vma *migrate = range->migrate;
> +
> +	if (!migrate)
> +		return;
> +
> +	migrate->npages = (migrate->end - migrate->start) >> PAGE_SHIFT;
> +	migrate->cpages = 0;
> +
> +	for (unsigned long i = 0; i < migrate->npages; i++) {
> +
> +		unsigned long pfn = range->hmm_pfns[i];
> +
> +		pfn &= ~HMM_PFN_INOUT_FLAGS;
> +
> +		/*
> +		 *
> +		 *  Don't do migration if valid and migrate flags are not both set.
> +		 *
> +		 */
> +		if ((pfn & (HMM_PFN_VALID | HMM_PFN_MIGRATE)) !=
> +		    (HMM_PFN_VALID | HMM_PFN_MIGRATE)) {
> +			migrate->src[i] = 0;
> +			migrate->dst[i] = 0;
> +			continue;
> +		}
> +
> +		migrate->cpages++;
> +
> +		/*
> +		 *
> +		 * The zero page is encoded in a special way, valid and migrate is
> +		 * set, and pfn part is zero. Encode specially for migrate also.
> +		 *
> +		 */
> +		if (pfn == (HMM_PFN_VALID|HMM_PFN_MIGRATE)) {
> +			migrate->src[i] = MIGRATE_PFN_MIGRATE;
> +			migrate->dst[i] = 0;
> +			continue;
> +		}
> +		if (pfn == (HMM_PFN_VALID|HMM_PFN_MIGRATE|HMM_PFN_COMPOUND)) {
> +			migrate->src[i] = MIGRATE_PFN_MIGRATE|MIGRATE_PFN_COMPOUND;
> +			migrate->dst[i] = 0;
> +			continue;
> +		}
> +
> +		migrate->src[i] = migrate_pfn(page_to_pfn(hmm_pfn_to_page(pfn)))
> +			| MIGRATE_PFN_MIGRATE;
> +		migrate->src[i] |= (pfn & HMM_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
> +		migrate->src[i] |= (pfn & HMM_PFN_COMPOUND) ? MIGRATE_PFN_COMPOUND : 0;
> +		migrate->dst[i] = 0;
> +	}
> +
> +	if (migrate->cpages)
> +		migrate_vma_unmap(migrate);
> +
> +}
> +EXPORT_SYMBOL(migrate_hmm_range_setup);
> -- 
> 2.50.0
> 

