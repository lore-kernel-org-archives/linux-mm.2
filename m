Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A64E0CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 04:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7C426B0005; Thu, 28 May 2026 00:51:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2D726B0088; Thu, 28 May 2026 00:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CD7A6B008A; Thu, 28 May 2026 00:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86E436B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:51:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 253521C052A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:51:03 +0000 (UTC)
X-FDA: 84815604006.19.7146C47
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf10.hostedemail.com (Postfix) with ESMTP id C11FCC0011
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:50:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="gKl/cGzn";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779943859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=7fceLIm3cYfKMvUwL1abHiFPKtpbe72Ltj1YSgtSjjE=;
	b=meJVAmFiGCASb3RNcMmAqtxtFsFLrhXzIcz61HbpSuiHNmxoEts8LtWg84bt8DFgDrl+zw
	G5jY6KULs/ByWKZRRK0j46KdgC3z2cUFrmmfWjZZNcdVI+mHb93b7avTy/ERx+rUDCZP4f
	lUKkM34gXz1uoKSm9eFYrc6zoOxHCPU=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="gKl/cGzn";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779943859; a=rsa-sha256;
	cv=fail;
	b=dK6E7e7yLhA50OjGzQPyyZP2n8V081NShFdTSJh7isLvvEJziitIw3bV0n8u6C+2KSqVp9
	5wfF/Jhtd8dSDT4v57PwPXG8ciIeC4jD4NSunbFJbavBAjeJfKEfh1vbGfMFMDFd1FN7A/
	TfkKFQn87YucK7TKfisXtNav+qmLITE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779943859; x=1811479859;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=9q8D3ogYzVmoHb1dF43BvbSVFralEy473u1nIPea0DU=;
  b=gKl/cGznyTqyoFUbFv0ShpZkpMKZVqraljUCTShDbWJRlAf6TFKB4Lis
   t45fq9L51aUQCm0R2MHGVMCBXKRJPbgVjuWnZOz6fhOofTcU6wukCKlb5
   ZIyrAykfhimcsngiWNiqq22t8/cq5iuI62Wj5i81DEXlkG6cXz1U2Ppi/
   aZuHl7lECvjev1Qg7oVIvRbKV1Pi3UCL9L8B5kDH+0UOuSUrJwBQsT5I+
   KADKS2OvXqN7wUya0AAKOX8UMM1yN6vroBExGdiJke7Qnhvc0pSy05wXY
   tuhJuONMTRDXlD6x6yr1lkZpirJY5O9edQQnjtrQ5mqCiF3986NPi3gbX
   g==;
X-CSE-ConnectionGUID: mpk3LfA5Q8G+HDn+whUVjg==
X-CSE-MsgGUID: 2IjR3ID7SsO2MlIlMpNUTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="80841170"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="80841170"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 21:50:57 -0700
X-CSE-ConnectionGUID: pHNSTi2gS8KM0HGDXsYrgQ==
X-CSE-MsgGUID: y0IKFYr8R6+kwLitEqsHRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="239867906"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 21:50:56 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 27 May 2026 21:50:56 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 27 May 2026 21:50:56 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.39) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 27 May 2026 21:50:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XdLZZzREk0hQUlKWQMitowLLt400/j3HRfwNMx2Tu0fmT2Hsi7fsgFu3WbCPkXrCaYmhEn3mEX3qFtdNffjN+5zp5OfNaFyK1ak0rJNTlkoxIU+e8eXnG6+F+tvi6+yCWwQwGJWLaNBWU4Aoe9T6IC+jE0hw1MrNXKfHDPCN2f50XyKzva0fcVfhmJ56k+SFMO/k/zaOaYjlhwVtIdpZ2jTRTTzVpilizbaXXlvGgETO0im/AoSVqYwq44DgktIbxRfp1PwunaGZtE+Sx8BujVrOeoDwbLYVKyMQcrZ1tN0HqU8XWgQlmkdUoFhtrRyGjmXWfYk7sqOaxCsnRAL5FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7fceLIm3cYfKMvUwL1abHiFPKtpbe72Ltj1YSgtSjjE=;
 b=p5yaMg2mYzjT75b6i0gDtH/Btho6tLwjRhfKIEPzsT9IYgb8jck+MPS+WmfIxymWLB/NW2y2Gf+NP0ntegr6x6BIjszsPaWUCpXPEOTcJ3glWq8HDXHrvd2KuE5xysTxTLfiSwWmC0iSjW2Ye8X36uKtXb9dOV2pe0RYG6u7svdcpYZrTjlsMJx8MoWE3/4r85UmKP6hAtE4+Zc51rUnFFbZahlKDPvMKguvwmPxQmBZoRKwr563azAveytwxkM5/DmZp4SFsfshBbz/iOzfnUIW8WR3RmL+q2nf6F1yCY4zFl6JvDIFgCAaft5Mb1zzrg5f8ibbd78xu4i10umQug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by DS7PR11MB6063.namprd11.prod.outlook.com (2603:10b6:8:76::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Thu, 28 May
 2026 04:50:50 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.21.0048.019; Thu, 28 May 2026
 04:50:50 +0000
Date: Thu, 28 May 2026 12:50:39 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Xiao Feng via B4 Relay <devnull+xiaofeng5.xiaomi.com@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	<aubrey.li@linux.intel.com>, <yu.c.chen@intel.com>, <ltp@lists.linux.it>,
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "Juri
 Lelli" <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt
	<rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman
	<mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak
	<kprateek.nayak@amd.com>, Andrew Morton <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, Kees Cook <kees@kernel.org>, Felix Moessbauer
	<felix.moessbauer@siemens.com>, Thomas Gleixner <tglx@kernel.org>,
	<linux-mm@kvack.org>, Xiao Feng <xiaofeng5@xiaomi.com>,
	<oliver.sang@intel.com>
Subject: Re: [PATCH] sched/fork: Fix timer_slack_ns inheritance for RT tasks
Message-ID: <202605281011.2ba77cc3-lkp@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260520-sched-fork-fix-timer-slack-v1-1-d4fc937245b2@xiaomi.com>
X-ClientProxiedBy: TP0P295CA0046.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:3::9)
 To PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|DS7PR11MB6063:EE_
X-MS-Office365-Filtering-Correlation-Id: cfed058d-4252-4c85-eb5e-08debc74b0ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099006|11063799006|22082099003|18002099003|3023799007|6133799003;
X-Microsoft-Antispam-Message-Info: MAPW62WWrs6DhgWpU/mA1UOd6LNQbk/FxTTqEcszXfBO+JQd26x/d9T1N5l3UX7SSSfayhfX4Rx0oWyiX4vQ/sO+W+zhgdOeWvXWJqUTZVrYiObf3Kxk3N2VDg/tJ9c9MMJa4a5DudG9GWOFnwCO8+ZBfyEcF3DqgEhaqgGN1DC6JayiHbCr/Pftx90yO2noUG34k1m2HRGDAn6fF4dNAwQQ5f5X8Vnfd6ezXb200plPPl407SMDCcHSDzCjiAR1qCTy7loVBDZmzt9qP+rulZnZhDKS9rWMTIeaDqm2ftbe5B8Bj7CaRivmtPBWuk7OQ1qfS2kkjC75or0xIBNH4Pv27EicIFRD/WoyYvpql0ENT//YcP2nXYejmEo3dGoC6WNWrdl7TRzXCiix2+JMXqBHHGQs3ntRQXB5LrqdPKFw9Gftv/SXIRG29mWwrOa/7FxmnM6G2HOYnGKKcIDXqCeTj4rtZhhrQUKPd6mTXnLH/OYnd5cwmTqCM087pLJ9xpZEmgD/DSrrlmY3LLOQfGOuq1EvuqF3AAxwRpBdP9guA3cXg1wcmhziR+dMcYw+a53pJxV7GDCeN63u7wkWF+MBZheLQKKrSIvQ+wdZbEJFC6oehqaJpwmXP1yeub9s6g5kpmDxt5LXEDVWWkVQ2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099006)(11063799006)(22082099003)(18002099003)(3023799007)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2VqK0h5U2ZzRGliakJhaWlBWXNlVXdFV1kwcVNGRHZyN0hoZmd4djA2R2Vk?=
 =?utf-8?B?TDR0bnJWUXR3cjJkaHJLUjZLNHE5Y2h2YncxV1JDTEQwQXR4dXBIeVRMRHRC?=
 =?utf-8?B?MTVrRWNqQjhaS2k1ZGREZ1puM2N5QlBZd1B0dkg1WWp5MUd0enR4ajhjYnJm?=
 =?utf-8?B?RTd6M1NFU1MrTTRQOXFRQzJHc2pDOUZDUXBXRTU4S1RvbExPK3ZwU0tZSDkv?=
 =?utf-8?B?Z1djNU9hUzNab0RmNzFFOVQ4clBUQjZJY2o2czJSeFV3Z2Z0YStidWVPaEla?=
 =?utf-8?B?MjhVMFYvZStvM0ZLdFo2clRUcHBZR203U28ydSttR3NzWXk1UGxxOGkzNmY1?=
 =?utf-8?B?dGUrYkxzQ0hCa0cyUURxb0YzRmlRcGxPRzBaeEZSN2NFaGpuZVlPV09YSHdT?=
 =?utf-8?B?dE1tS0JPOWdGNnQyanZxRjJQQXdpbzAxOXJKRURLbU1EcENNMXFITE5WK1NB?=
 =?utf-8?B?V0w2amVnWXRkSDFSeDhuc2VkOWU2Rk5vWENza2lzekRrRUhrY0FXVUhhcVBl?=
 =?utf-8?B?RzNxUnhZeEJ2aVZGeFU3MllXakMwdU5FVGkwbGhMa0IvVmxQZEtxOEMwS2NS?=
 =?utf-8?B?b2FBLzNNTnRCR1NlenFUREF0Zi9VaHpTcWJDTDFBNVhhMjRIcEZNbldVb3dL?=
 =?utf-8?B?cVMvRFlYQ3lEL1l0ZEw5M0VMTDh3SlRyYk5aeFU0TWdldk5kaXAxLzI5bWhu?=
 =?utf-8?B?djJZREhySnl4Y0wrSGdPdWd1T3MzK1lObGVEUW5lVFFCSHpLek40eEt1VVBz?=
 =?utf-8?B?YmlVS3pBaFZZVlhGWjFmVEloVGtRcjBCTXV6UmJyR0FpSGhHdVRQeE5VWlNp?=
 =?utf-8?B?aFFYelFtbXRnM09PcWtSangvdlYyaWdxMnZvNUtITC93WjZkQUtlVDd6dDJm?=
 =?utf-8?B?N2YxWVljelhzTUhJU1RpR05lS3o4N3JRSFhra281NjJEQWY5UmxnMlllQzVz?=
 =?utf-8?B?NEVCVUhrSndPb0JUd0x0b1BQVTFpUVZrNkhyQk5yOHRJZWZjUTFTR1NGSy9x?=
 =?utf-8?B?alZ1TkhESXlCV0tsVHZnRWxOVjZuWVZpQnRRM3dySytpU3k4cml6dWZBOVVp?=
 =?utf-8?B?UlJUWkY2QmZpYlgyNHpxUlNYUHRPY1BPZ1hsdGxUVFFWQ092RFdOZ1NJRFln?=
 =?utf-8?B?LzJLZENGMFFWNzRjRnpRV0hoTVJnSlg4QnpCZFZNUUVJb1F4YmhMK1lIeFg0?=
 =?utf-8?B?dnlmUzYvckxaN25rRWFnK3BZMlpPTVB0MmhMazRZam9pQjU2TzNVcFhZa0Nu?=
 =?utf-8?B?Rm51YzR6clUzckZYbU1yc3VYS0U0cnQ2RnlhVTY5R1BRRUZDaGRRRTNIVmN6?=
 =?utf-8?B?U1lPRXY0bStxZDJVcGlJNWx5NWxsUGdRai9WZERmTmxkNStaVTJSaURHdDZE?=
 =?utf-8?B?V2xBMnlHdmNQWVZTanNiMzhUazdJS0x5b0ZJVzR2T0QzZmZEeTJCOVlHNDd6?=
 =?utf-8?B?dXBTbFVYUWJ4amxJNE4vb3JpTjdsenV4Nlg2Y003eHJHM0FQVDVqM0lXSzF1?=
 =?utf-8?B?SUdYZi9OS3M2bVFSRWE2Si9wOW9LUVc1cVpLaFJSVUh0Zjh3T3RiVyt5Y3dN?=
 =?utf-8?B?TmtNWjY2VFl0cHlhM1BxZHRSUXRBRFEyUENCRFUrR0tjUDkxaWhBMHVsNDFO?=
 =?utf-8?B?TmpIbGZkQWlEOHg0eG1wekV3ZHZuVGYybFdtM0R2MjQ2WkU3WVNsMXoyL1dD?=
 =?utf-8?B?Z3Q3ZnRqRndWd3N1Smpuc0NQOFlUVzNpYWRyYzZCcldnUlF4R0IvY0hrNEgx?=
 =?utf-8?B?VlpKZ1RnMUJhYUN6aFZNdCtreEp0WjB0R3BEbjZTYjVSVndHT3BsbFFHeDYx?=
 =?utf-8?B?WWZiTVQ1bFhqQnRDS2Zqd0xnVVBhVXRuR0h4dnNBRVRJSC93cVBNZUEvejQz?=
 =?utf-8?B?VndMNWRHWGpjYnZ4NlcwMnNRaXRFSXAwazVJNUJrMkNxN2UvQVMydEdmQXdm?=
 =?utf-8?B?YkNNbVNLa003Yytwd2ZjTEJSSVRKWU1JaUdoeWF3Y3p6NlVwQWp3Nm05Nzli?=
 =?utf-8?B?SHE1ZzVUTzJpVFA3bGJ6QVNYRHFmMWFTQ2FTNzhNNTRsVXZlUjNEemE5cXlW?=
 =?utf-8?B?SVRpVDd5My9xWjFaaVViaWg0UUt1M0xZYkdHaTcvT2VRRDJoUnZMaDRKdmti?=
 =?utf-8?B?N3hNYXhyd3dNU2tEbGUxMm9TZnNRU3B6dnpLU3JWYldjdHFRNXZWczYzejlG?=
 =?utf-8?B?TVhSK1Z3SkhQQitrem1GUUlmMkNyR1hwUnNLOTBaU2FxQ21nREswaVhtZUJw?=
 =?utf-8?B?elNuWm95VFdwV1NKK1c5YXpSRUxSY1FUd1ZEVHZzOFhMRFkyd3NGZ1hCelcx?=
 =?utf-8?B?MTMvVk1sVFY2RHZiV2pOVG5FaXcxc1hjWTVobm51aGtaQkV3cGNWUT09?=
X-Exchange-RoutingPolicyChecked: L8rfItM/+MP4HWIn4uCEtYW1ILvgAK0ynGTZNU/SgfvIE/Mo36aqhw4rNH+tqqQWIYfVHd3m49mxndds9fzLqd6thCAYgkmOnh5nDKGpLQ6R6+zBec4t0bz7mI7Cj+bmmJe7vL8RZ6ClmV7QA6pf9NiO8Yb0qzdJLrL9gocq4ZEiNqmRovh3RfR/oQwvqlHorYTZaSnMzZTEVq7s4DCa/q+/AxMXXiT7BKxWvwxbzCDlP+JFdJoXOxmDV3liFfxZb+fM3e46aXB6W5cAbgKPnOt5zYXhnQdy85PruD/Fm9e8jvTYlCFpxJtb5Ma4UMpyuZisYXgBxPmrWyufLfzu7A==
X-MS-Exchange-CrossTenant-Network-Message-Id: cfed058d-4252-4c85-eb5e-08debc74b0ce
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 04:50:50.4481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ql1LXwOo796aofLjjV9BnM+Mz3iVlHu+AaVRodEU8dY66NhJKLzHHxliGTXCw/OXJzGTvfyU+FkWi+arh1b/uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6063
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C11FCC0011
X-Stat-Signature: ozdoqewwprnf3y9k39mqohfuxmstorqr
X-Rspam-User: 
X-HE-Tag: 1779943858-740232
X-HE-Meta: U2FsdGVkX1+NxXy0FxbQ4HF9KXUfuAFm5wOz1pmmT+gSE0zPnr3NqHNt4uV/Mvj/U9uTAoHmOKKoFXJ9kS/F5qX4C/itD+0xZbaZ9uSbLQCbhHt1yMS3auWaqQb7reIa5Z7vCKIVMee61Y42A1Q1aKYlFxieFLsUmiHqAidVc+BH7mulbYw5NSW87MXMZGyVPyNIsYOq4JCua2REKrjaM6LZwBPZDkbjnWbeeNPsIspONgojFF4zYuVdq7bgFPYb8zTHK7E4c6I/3L+4Joo6JjHhzUh/2b74j2eRkxuOHBjcTrv6CHrR+dTlcSpQ64MeTyQduSWKN27pIQ2CG/r9k7i/qCkmdG7B5lYf8vzvlUBnfNZvaART42TKSJ7ouTOTVGVy2nQh05aark5uvhqymctbFK4cd+ihRw7jC4Qw3X05DDDfuxsM/Bt7VSik8DpHgtDVrzOq2sEQallUi88/U3sBqr/mtDXgnImbBfF3wJuzcfzA4txzX9sYbSIELGX7z1OPm6MkAeeHsiLdeB09Jbdta8WzVtdIHNr7siMGjJa0tGO8uIMwURBhiSaKwK6gdP3LIfeGfgDCPjdFhbBoryAI04RsEvJji3o0KoFSLRicxn15EqNifqFEu9qvglBcvL6X1QgEQr96k1xwd7FzwaKOOGzJgWkIndScXNxct3h6EcZG2SzwEY9t81pj2QdmSyexfTuZu70gay0P8Q4vszEoNlTtrRr+layQFiCyX0wUlrXTcO4AtuR4/yiDvOyGtkpVYoK324N3Aw2xUbcq5HkNyOpnxWa2yDzVO2SoabvTvSLSJW5u3bAMiiSBpg0XPwXbMrQinDchRbm80/s49J3Cy9gHhDaVegSvz0OLGyFidQTw0Fsj1TR+xJK4IALad1GjT+tFdpKu1pdxkBKcn2sp5gaT2Tr1Ug6fzfR8B3PJNM13ECLjNx8x4kGJB8ieXziDyvnypEXfddIUu4m
 pxAPxQbC
 lFqMeCTyLgU3PtTsCV55d9eCXeUXVZJ5/dTm8sOszpBOzoKHLoi988qR/9Cec1dLp6LeBb5VTyM2gs9qK+INM0bd6Kdx96ncD2FkGbUizFg0tSj89Mlsn1oKA5qTEdBoIxvGhsKwCuco24CkOuMHHtQ8g7717EayML2jcIBOpyPuRW3oGXhbj7K7N5A9zHMaQbtRm6NiXsNB1R5dj43+FWR8xhu0pDXrAvgh6FEvIzMQIx3h8oa0eDaFFYsoF8FBArE7Ww4V5mVYlJL7ZHV006LGSmNlXyVbOcTjR9WYE0hIzUqPRk3bNo+qkW+R7pYLsYndOm8zRrm4DR81bHsbMTndC5a5wow6bdphIABVgzMr3JShnOE5x7QiPQPUMZoKVfFbDzpP/wSvr1SboBE5sGIzmF/ovNjqV+GlH2Kt+ScYiSJpKHyjz18meMtJnr065bVghYn2F/y7Cf2VQDUE/MDsPLgD8fJsLPNAZVBafhUXb9czKvYrZg8xTzUuI5oOD6KuLTrfG4Yx0sMzS6/LRVOx0mCtTT5Fc4dFop3SSF8w4Z69NO6e7x70oC45es7kn2xtXIKkpeOYJnxsuZ4/LLl7Y9i98/utwSf4VcNCGOwYjj7TBghV7+8Vm2XvrFoprfbUG1BExGX5mUZiA5zr80TfDf56NLATyiuEFEvPFac8av8IjFwWFrRCUtJMOUC9KDMrbwMUeixyt2ncn7JPKLp1sjEJARVlSE3On9Y3T1AwlLg6qFE2U3DzL57u/XceB+cdrWxWlMwfclJs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "ltp.prctl08.fail" on:

commit: 2aa2f0a955c7459279e861f62c770f5f81d64f4f ("[PATCH] sched/fork: Fix =
timer_slack_ns inheritance for RT tasks")
url: https://github.com/intel-lab-lkp/linux/commits/Xiao-Feng-via-B4-Relay/=
sched-fork-Fix-timer_slack_ns-inheritance-for-RT-tasks/20260520-210956
patch link: https://lore.kernel.org/all/20260520-sched-fork-fix-timer-slack=
-v1-1-d4fc937245b2@xiaomi.com/
patch subject: [PATCH] sched/fork: Fix timer_slack_ns inheritance for RT ta=
sks

in testcase: ltp
version:=20
with following parameters:

	disk: 1HDD
	fs: ext4
	test: syscalls-05



config: x86_64-rhel-9.4-ltp
compiler: gcc-14
test machine: 36 threads 1 sockets Intel(R) Core(TM) i9-10980XE CPU @ 3.00G=
Hz (Cascade Lake) with 128G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new versio=
n of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202605281011.2ba77cc3-lkp@intel.co=
m


2026-05-29 16:17:35 kirk -f syscalls-05 --tmp-dir /fs/sda1/tmpdir
Host information
	Hostname:   lkp-csl-d02
	Python:     3.13.5 (main, Jun 25 2025, 18:55:22) [GCC 14.2.0]
	Directory:  /fs/sda1/tmpdir/kirk.root/tmp0lg24sa6

Connecting to SUT: default

Suite: syscalls-05
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80

...

=1B[1;37mprctl02: =1B[0m=1B[1;32mpass=1B[0m | =1B[1;33mtainted=1B[0m  (0.01=
1s)
=1B[1;37mprctl08: =1B[0m=1B[1;31mfail=1B[0m | =1B[1;33mtainted=1B[0m  (0.01=
1s)   <---
=1B[1;37mpreadv203: =1B[0m=1B[1;36mskip=1B[0m | =1B[1;33mtainted=1B[0m  (47=
.775s)
=1B[1;37mprofil01: =1B[0m=1B[1;32mpass=1B[0m | =1B[1;33mtainted=1B[0m  (5.0=
05s)

...


Execution time: 9m 8s

Disconnecting from SUT: default

Target information
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80
Kernel:   Linux 7.1.0-rc4+ #1 SMP PREEMPT_DYNAMIC Tue May 26 16:01:55 CST 2=
026
Cmdline:  ip=3D::::lkp-csl-d02::dhcp
          root=3D/dev/ram0
          RESULT_ROOT=3D/result/ltp/1HDD-ext4-syscalls-05/lkp-csl-d02/debia=
n-13-x86_64-20250902.cgz/x86_64-rhel-9.4-ltp/gcc-14/2aa2f0a955c7459279e861f=
62c770f5f81d64f4f/0
          BOOT_IMAGE=3D/pkg/linux/x86_64-rhel-9.4-ltp/gcc-14/2aa2f0a955c745=
9279e861f62c770f5f81d64f4f/vmlinuz-7.1.0-rc4+
          branch=3Dlinux-devel/devel-hourly-20260521-050335
          job=3D/lkp/jobs/scheduled/lkp-csl-d02/ltp-1HDD-ext4-syscalls-05-d=
ebian-13-x86_64-20250902.cgz-2aa2f0a955c7-20260526-26280-5dbkeb-0.yaml
          user=3Dlkp
          ARCH=3Dx86_64
          kconfig=3Dx86_64-rhel-9.4-ltp
          commit=3D2aa2f0a955c7459279e861f62c770f5f81d64f4f
          intremap=3Dposted_msi
          acpi_rsdp=3D0x36983000
          max_uptime=3D14400
          LKP_SERVER=3D10.239.97.5
          nokaslr
          selinux=3D0
          debug
          apic=3Ddebug
          sysrq_always_enabled
          rcupdate.rcu_cpu_stall_timeout=3D100
          net.ifnames=3D0
          printk.devkmsg=3Don
          panic=3D-1
          softlockup_panic=3D1
          nmi_watchdog=3Dpanic
          oops=3Dpanic
          load_ramdisk=3D2
          prompt_ramdisk=3D0
          drbd.minor_count=3D8
          systemd.log_level=3Derr
          ignore_loglevel
          console=3Dtty0
          earlyprintk=3DttyS0,115200
          console=3DttyS0,115200
          vga=3Dnormal
          rw
          keep_initrds=3D/osimage/pkg/debian-13-x86_64-20250902.cgz/ltp-x86=
_64-8cd7644a5-1_20260514.cgz
          acpi_rsdp=3D0x36983000
Machine:  unknown
Arch:     x86_64
RAM:      114660756 kB
Swap:     0 kB
Distro:   debian 13

=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80
      TEST SUMMARY
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80
Suite:   syscalls-05
Runtime: 9m 4s
Runs:    189

Results:
    Passed:   1293
    Failed:   3
    Broken:   0
    Skipped:  38
    Warnings: 0

=1B[1;31mFailures:=1B[0m
    =E2=80=A2 prctl08

Session stopped



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260528/202605281011.2ba77cc3-lkp@=
intel.com



--=20
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


