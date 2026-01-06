Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C48CCD042D
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 02:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 721AB6B0088; Mon,  5 Jan 2026 21:15:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CF396B008A; Mon,  5 Jan 2026 21:15:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54F2D6B0093; Mon,  5 Jan 2026 21:15:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BE826B0088
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 21:15:30 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C50998B411
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 02:15:29 +0000 (UTC)
X-FDA: 84299922378.26.8802033
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5820C4000D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 02:15:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D2casrWT;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf12.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767665726; a=rsa-sha256;
	cv=fail;
	b=HPtCJ4OAdhWWRUUHlNeCBkSX0uSnGw2R1mivsb4tEF5WPoXrRqDfce5ZlO+McNTGXd+bjs
	cLpu5eLz3VAEH7DmkLrLMjmY7k6kt8g07xD0s8aWggeSkWI7S9gStH4OO6rvyLhjxpk8Aq
	ZroEQ0Y6IXdI3w/dZOBOXgs2+vd4304=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D2casrWT;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf12.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767665726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nSx8xQb1YUtqjxJygJhYPYAZbkOmmWQPjix+Wn8SKNE=;
	b=HPyXL07V8rS/gJFTkh3F95HB5+CvxjDPxl0hmixi5ARiQzbfUZv1NAv4xnRUnvDig8FZRC
	5prPOOSlDL0J6wyyO4ReFsYfpfmK3tSPawyodr2wQTnYJDnLA+cKsvPMG6KdQeSNPwU5Ov
	n62VD35f2CNwOBu35NLaTSZe3aVg5Wg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767665725; x=1799201725;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=DKdiu2nKM88lTZcZ0q2yOLL8BnpJQzaqRDdLsDKRTFg=;
  b=D2casrWTcZnMYqZUW4NGxPHBnIXuPVzGMe5uU/Xnh3NGKZ98rPxpeTSH
   W1CWrztBvmmMYu94IM+njadru2rUhGFXYZxLGHR5B34LrOr3ezGPSyR/f
   IYlKdUsK/SogU/JkHmmhify9oUdxTBtYWkxeTaFkr0mEtzbcdsqlALAw8
   hc8K3VvMMjGIdsBJ4kHfcX991XNk+VCLRmV4kpgB/8kAMtKoVV29/kGzD
   sStAK5WGzm5ud642eEbHYJkRI/5F7f7niEb/o/Jk7nY1/9Df3iKAEuqyZ
   JL1RxvRCWE45Qf7txswXgz+wVgQ0ueH5ybvlIP/ExbzHhVukX/wLk+RZL
   g==;
X-CSE-ConnectionGUID: pjjQmi1zQXiO1qHEZ4KWeg==
X-CSE-MsgGUID: 63k/qyhLRYqKGdcdFzUtsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="69074655"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="69074655"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 18:15:23 -0800
X-CSE-ConnectionGUID: 1gEwpOEmSDuuXrA96z5J8A==
X-CSE-MsgGUID: h+g6J7LfQcS7LgNjzzB9Yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="202545265"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 18:15:23 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Jan 2026 18:15:22 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 5 Jan 2026 18:15:22 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.36) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Jan 2026 18:15:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KqsnplMxLCw2Aq2coUKMnkFFiaWsuil18+uIOnDyZQiC/g9t0HDbiORkIfTHXhShfbWy4kwX6cktDjojvMXR6zMAxIzclVNHrzjIlP0kPlqUJblGJlrmj2SMa7G1IY2gQvZiwYek286apeVJNm4tPCVpClc/zWhUIoQLybyGpwHgjVJJTqMYxTkZVuTdQwoXOP/jjKC5eR7VjfwIT3tNlJG32QR9GMXVqgRSWGSRiLZ0YcgKrGVQ2N0yGadK/8anLaTto3/TBMfxAnKmZi3k3/P+rECkRh0iCzGcOE6f0xxzWOYs6aHbJvw+BVWyYyLwDPcO8cdvwUb9sIHIFTIOKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dypUMhh8vGqKk3rynthz9STs8oijgIQ+ROsf2AUb5WI=;
 b=mIlJ8wvR3400rh1k4BzdtbdWI95Gn55tvcrv80iC37aSd98iUr+oOz0hawXgH1WH39ViSJKMubIInR9M1z364kFqDVaPuo0e5yxoinWjlIzdF6WVIZw6GkDCZCi+z0u8v+8t9Ns4Tkzj1OP+XMwe91PEzGfSztQcYkIi5m/P/oK66Kvp6fb5MnzR4otyOJWwAyygLd3Rp0rKcwqpo6IifFp5sYLRpk7gg9fma2onpUR8MmFQJ51qtDxLmSJoM59EYilc+COjXAzQVwyyYM6gW8oXaXqM2wnkOyJ7O8JI9qCkZpy56TuI2iSUUVqxGWMG4ncfQeLSxEfOpySZYazVMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by IA1PR11MB8149.namprd11.prod.outlook.com (2603:10b6:208:447::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 02:15:14 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9478.005; Tue, 6 Jan 2026
 02:15:14 +0000
Date: Tue, 6 Jan 2026 10:15:04 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, <linux-mm@kvack.org>,
	<aubrey.li@linux.intel.com>, <yu.c.chen@intel.com>, <oliver.sang@intel.com>
Subject: [linus:master] [sched/mmcid]  77d7dc8bef:
 will-it-scale.per_thread_ops 10.4% regression
Message-ID: <202601060955.b7b9ad22-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SG2PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:3:18::31) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|IA1PR11MB8149:EE_
X-MS-Office365-Filtering-Correlation-Id: 3100ab2b-2b5d-42a5-dfdb-08de4cc96d32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?fV9s5PkNHV8inpIe+gpb49domNce4K4TpQN8EIg3Suy/BALq6BLgZfOVh1?=
 =?iso-8859-1?Q?qdfKq+eHZlfJMgO5AKyJVJHn7Am9aRwrRtHFO1HmdwLVAgRRkA6TMoFp7w?=
 =?iso-8859-1?Q?eTazog/gTj7YBwMnzNHXibCh4MMkAVij/8+4suhMI9o5LkRTup82ge7eeK?=
 =?iso-8859-1?Q?pxYcdCwVhBeVMVHy1etF3IhcjucylAXOeBN16vd+1KcDISB9Bi9Ce8ITaI?=
 =?iso-8859-1?Q?v+DpARdj9j8z0cKDAyUsYajPrmqSbU7ElvSwafgcUDgJiso5pi3sTOYUgl?=
 =?iso-8859-1?Q?9mybQtSAgXqr8bLKkPb+Mh8ilW7uBA1LZGPUd8tAaY5sMePcEFKbC+7F+q?=
 =?iso-8859-1?Q?v8y1nBreq190tuCvoLfjMDng04asYK00NpqEp96e1QN6H+i1HaqEsM2V9u?=
 =?iso-8859-1?Q?mDUByzz56Qw40sEZDAW3RWKnRK4x3imfUtGxMDys5bB008Q2jwaFoedfQe?=
 =?iso-8859-1?Q?nssfedLO0R54yZPIgr/pfQsT2+xLbVfFpNQqdNdG6Wy+qKTKlitmMnHDxq?=
 =?iso-8859-1?Q?lGXzzw2kb/roTmKIAnu6rmqaZjSiKKAjPRbUC+d2yZmAou9QJIVPBCcq6y?=
 =?iso-8859-1?Q?XfkmljGGL38WEfvd3kjhpEZuKZH8Bd1fUG9uvMxbdEVM97+uCIlxMQ+EgH?=
 =?iso-8859-1?Q?fSs0GOQh9c6QoXgETfP/etMgnm1RCJ+h19/BQPFngWCwgh6XRL8saHzxDt?=
 =?iso-8859-1?Q?b+i4ryK55ynX8NOKX4pXfjf9RMRXVx8A28bb9Dy1ve9TFmEcICG3lOnHcT?=
 =?iso-8859-1?Q?qwcibE3lfFmtN8QYHGefrW1EQu2XO60214NudoAzh5MrrJBGIado0078lF?=
 =?iso-8859-1?Q?z1awlYCqghW0c2vO+vPFhEruA9wJry58Yz2Y74owCx4p4j3b95tQxlgX5S?=
 =?iso-8859-1?Q?YhtJ1wftE9ytXAcD/XlpOvHRiOVi+GQ3J5O8cUFgsHF7DymPRqQ6DjHgdC?=
 =?iso-8859-1?Q?Wq5JLzzL3e7iOmC9C1NoDKqF2OmtbtOdt9+iFJheBoQgh+tVVDxZu8XUbk?=
 =?iso-8859-1?Q?FyA2ejD67gGUz2qmXjPKxg33mSPl4OwHeobopsAkEpzsLCIZwlD8NOBnm2?=
 =?iso-8859-1?Q?JBBeXeCP0QwgPfhj/3q+cVeuWMqSEYC5p+xIOT+SDmjUGyi/yom7/zthGM?=
 =?iso-8859-1?Q?Lqhbj4SLCLeidYBfsadj07REytqxZ0dpJeJvfPm8z/htwKDOfdAfhshi+r?=
 =?iso-8859-1?Q?QJlW8isQwprPRpKrLi4bosnnWDTt29nPaCNYrD2C4HEDVLcIh1TSMvF1o6?=
 =?iso-8859-1?Q?TVvjQaDkkfpcJp5O6lFvZKpyYI+VH3r9/f7yLGpm7Wp/2GDc1Bt+DBkFOB?=
 =?iso-8859-1?Q?GVwmNaCHNQG10W/wPZuNWo4VVcarmYH+bIvmhDlv79Y6gGOtpMsLwXFCbb?=
 =?iso-8859-1?Q?lM/J4pLd3B4d0rsu78TnuhaKngvXuW4z5+fOIDjBqPw3QSPmU5BvAwNUR2?=
 =?iso-8859-1?Q?OwHcy1wW1JpMvxnNITS5QLiGxo/fvKKcQeVB+A/mEsAOFzFredQNhmktPs?=
 =?iso-8859-1?Q?ao370XRGuHaIklI1C4Pa3HSc4z9fxXs7stGKx6UNd4Og=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?5oradV/xnb0Kazf9XMhaPSGVjs3o5vWxIg1ztFvFPtEA2WGFbB789P3TXi?=
 =?iso-8859-1?Q?FSV7Hne2UqImWHZ4scY1X+w4F75bIg9F+J+nJAFbq+NyJwetHgCYCy61o9?=
 =?iso-8859-1?Q?lgIzf3++N4x1wTNkfHWjWN06yhdFSsJorh7gIl0w+AR7YOsEzpVGPuVmCn?=
 =?iso-8859-1?Q?551ntKAGKKQ1TTnppExWdcWf3SgL9EK2gLcnqqRkfN9kRcQid/4v51A5Qv?=
 =?iso-8859-1?Q?0vrshCOPf9CQiTQyCjjPNJx968mjw9QcuwiuA3dSoYjrEHMfRpdUbuCDxa?=
 =?iso-8859-1?Q?U1hLFaY2zrMHidAJVif8uAZ6werX8e144MijvBI3tvYgkffd4Uac3+9zwd?=
 =?iso-8859-1?Q?vqSJFJDy7UY+dR5ofw+x6H0V0DQrIdrkj7/EEtYQeA0+3eJVMZZ+A31y8g?=
 =?iso-8859-1?Q?s1P9T/9P7//CJtOCkuDrTOXVgJarNbX41Uq1BRcgwwXyE8GjQDLsj4FjPh?=
 =?iso-8859-1?Q?HlGoY63RHpZwD6rHGMmT924xT/B+xBcTk6tNNduMy8QP4StryFHuAiCaHi?=
 =?iso-8859-1?Q?KG/JhQBhigz/x79v+nOwfmGv2HGrlFDX7bRia7yCTa28gMPudw+FM+fbMb?=
 =?iso-8859-1?Q?LKICxu3dLLmhmpzrAkXabLSSzwB8dAEO2459ndOzAqR9zqZ8WZj1ZVZebv?=
 =?iso-8859-1?Q?UxTjwfHI6pc+Ef4V81BQwOQR0iV2AM0EiHyvXfOymtjC9Kw0w7UK9Mnd34?=
 =?iso-8859-1?Q?rDu42rCXTIZofGTCahq0/WdMCyTaEYIBGYtKV5Q2/lovoj7mUHZFOXMBZr?=
 =?iso-8859-1?Q?wjko7IVtBEMkD8Zs5KAEWgiUBVZ0YQZfwtTD/vOxlNRCt7CwYbxjav+8+3?=
 =?iso-8859-1?Q?Yc9IjzjkqTXDG7powpUftN7lVaBco3ALmmXA1Vs1Iyj0BV4/A5MlltADZ5?=
 =?iso-8859-1?Q?w+9QLcbz/LpqFFIT+PaZ0LMlfW1sefS/unBH2/VN+lLN3WOpyqmvnFVmGz?=
 =?iso-8859-1?Q?SjQ6JyQ+jSKKj954TT0jdTZYOFAC9TPWfVcQiU7/BgBlslfyoVeghEH/QA?=
 =?iso-8859-1?Q?dQ1meSvozXreFSUiwV9+b3fizPwAvWoYQAIENHh+S5RF3mIqp4BETEL1gX?=
 =?iso-8859-1?Q?hvhy4KPBGnbA3JCvzFuwg1M7a/cp9G3JITHG3MQSGcdaIplXd/uBhzAfZN?=
 =?iso-8859-1?Q?N32r1B8en8f9OaMfuaBugyqQ9+JHrC7Xte4o3LMU0uKi6Y5jyi0b9/pz5S?=
 =?iso-8859-1?Q?pwEZ7USW2AWDAC5kxKnP4BYSZFjKelIOis3TALVyWdNR+UZScSZCVjCcNx?=
 =?iso-8859-1?Q?J5IMXNenwWV4FzGGBQ0C8xuqKsl9hRvL/yOtSh1tpN5CSHXo08cGiD3a23?=
 =?iso-8859-1?Q?p61JHgphuMS6Ybj5IvJHDF6DFwkrY+K2SJq53iP/ZSJ1VDP8bvBuVtITg4?=
 =?iso-8859-1?Q?/f7NTJ8XZAS32ZCHdmHwCHfDu7QsX/+Z7FS27I7SZNugukND0qk8sj99WR?=
 =?iso-8859-1?Q?9Y2Hpdm9B8m5IBR6Ilfzbom5M0Ux6ARM/eZRWXg+yCZktt3DcW26506Z2s?=
 =?iso-8859-1?Q?bdbrucumFdGO31wbm7mxgiZ/iQR4qRFnlge4QDpKN5grLYVr7Gs6TGKRIi?=
 =?iso-8859-1?Q?MIwzLgEw1um9hWEBygL7oA2ypK9MoN6lvGIrIUkfhvliz/8TvLYsRKUhXr?=
 =?iso-8859-1?Q?G4Um9vmircJakvwWOnww/IT1On6/Dxrj3TInaxpexQAVQObFoX+hD/i8sp?=
 =?iso-8859-1?Q?BMhgrQsTpiHRGdUjhLXjvEVJl8lPyPgwrSZOUCPOkOSuA4T6W9p4aqkf3v?=
 =?iso-8859-1?Q?JtVBWUxWpdkTzxvjmcoOPv41bBZGluF2PmJwyoPA6Ktz72kLw9MD2xDXr/?=
 =?iso-8859-1?Q?ryG9FzUKNg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3100ab2b-2b5d-42a5-dfdb-08de4cc96d32
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 02:15:14.3446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xJDXQU4bjAfYpmWYO4sdXsPvQedVLUcAyO3rwEPkiWWylf6VdmNLXc18tikeBX1LXM4m4OvLunjOw9w3VsRvfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8149
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5820C4000D
X-Stat-Signature: pqaffwjsaubsu1r9umqmq3cc8dzc4hpy
X-HE-Tag: 1767665725-175876
X-HE-Meta: U2FsdGVkX18NWWk3AdXvhlqa/6FGAL66kcd4ZY/uNNXBdVf9gMc5I07yM2pK34ecP4AxV/AYoXuWhxi3yI7l5A8VoaX3/djzOOIRpXeavVKt6PlF18VU/j5yLkctAUF4L+uvkk3pINSjP/hEiOKY8i5+zCe0UTeexIvwUZcuRti99CU1ADSbTwsD4F14YBH/+35TibYhmYR2EBpTa6GvndL/sGiX09+rjaPM1YD6Tq5sEUGYezQFMf1EqrEZYg+qhNlIAYsVhTcxWcNsqISca/Wdcq+tyAGApP2CzkRtn5G/4LCYX57mqX6p3No+YPUDyLXy/wdHccjMNcwkAQkrbZbLjX/hN1VqOjLkOJcwSZ67oPT6m9R+Gpz8EDzAMEzoRcX1+YmyMsOLKJHa8fM36BeS50/e4LNRkuLqzgVy6454+5gpGSCbBq4cWKWbJiasD6Pj63h2PTskKKjGGeHA3krl6V346XP1xBoMdh1S1wtyJzYiiuwoQnQGMLdsJTzQXYANpx9lo0ZCDMpn4KiZXXQRW7ZdOgftGgpQQ45BwGZtEpLbyJVWcIn8E37dsoioAD56IHRUywRsXtEpWYOlQKWVGrWoE1/6jyxE5v3VNUHKC2z/hgx0PH2tuvAIMCqoPEmt4D2PaNo8Q7exyYT+/cFQGiX/aiC4IdsFhdScqV0TuYyklSqWy40kHZ1zRuyIQzU7Q2X3yESF0M2rZLOW77ho7gamp+FChq4vRCzj9BEomcT53CuWwdkaDeCQSV7qz02gJH6XU/cC7Mi/sDNEb7ZkHB55I19WBCMyJ7h1efpYs1dvZCwlUu7SbaaiP4i4zHiaGlcZV1v/46LUrdx/wZTMkQU9yO+ehHqjbKkuX3ZmSycdP8aMWhmE/rOtJArwh2iq7Wt3oa/rybN+bNZyeZavQWUucIk8/0ImPwkO1+o5Uf++ihR8PS16S8wsyYCygC6leajeXb6eQytdsdm
 /xWkGye/
 vnOG74jVziNs4IVJLQZeriRwuI5mhGxvj2n7zT2TUtbUKmcrHlWjvgiCDfm4x0Fgg2g+ECdjPE/RXNnRqy2FuZY9D31DbfBD6NQCYn/Dvboi+Na1VkR7qSsD/IuQRfcm+Z2k7XzEOdIELhGPd318VIpJTl2CNRuMIF1z0ktHKxlaZpqKK48yOS69eqs/fjcjQEAeKtQZ11u0QbpTyn/o4NkuDQU3ri04Xs7TJShGogwf1AvXHIieaeLKrvMxsegl/7jb9TT0IBSLBgDtb+p+WZUMZwrdp7ZUighzGb2Xf4UlqvXSQTpyVvbuHh6Gb6SANCyyum8nmhnhGdAlzmt2DV00tmfw7HgPaC8angseAUKhuhLH9/QlX0rlApYwAGZAK+tCOFQ/9mRfZKD2jfoVBz2bdbTWC6f/yLaIs+rXZSuXWPtCBBbGWbXmkBdYFRsHSUIOPEQeCIGEQeJMEta2dFawVb7UmyWry2dG0fmoNRWxQ5WwxT2kmEvCOO1BaZDbWzh/5pLNmbxaZ6uIMdGOUipcB6tURWM8Z89tWfeZxrXXKfI7dN1AFjNH+Hr1vjN+ypuX3xDFurBI2Ctdfxx5e3Kaoqj/E8wOUoY7BAA9ggLj4LxkcR9kUFYi667Lovkai+GgzaC7AiyReH7c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,


we reported
"[linus:master] [sched/mmcid]  77d7dc8bef: stress-ng.enosys.ops_per_sec 2.7% improvement"
in
https://lore.kernel.org/oe-lkp/202512041521.6bdcad6-lkp@intel.com/
(still recorded in this report along with another improvement)

now we found a regression in will-it-scale tests. report again FYI the
performance impact of this change in our tests.


kernel test robot noticed a 10.4% regression of will-it-scale.per_thread_ops on:


commit: 77d7dc8bef482e987036bc204136bbda552d95cd ("sched/mmcid: Revert the complex CID management")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[still regression on linus/master      b69053dd3ffbc0d2dedbbc86182cdef6f641fe1b]
[still regression on linux-next/master cc3aa43b44bdb43dfbac0fcb51c56594a11338a8]

testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 256 threads 2 sockets Intel(R) Xeon(R) 6768P  CPU @ 2.4GHz (Granite Rapids) with 64G memory
parameters:

	nr_task: 100%
	mode: thread
	test: mmap2
	cpufreq_governor: performance


In addition to that, the commit also has significant impact on the following tests:

+------------------+------------------------------------------------------------------------------------------------+
| testcase: change | will-it-scale: will-it-scale.per_thread_ops 3.6% improvement                                   |
| test machine     | 48 threads 2 sockets Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz (Ivy Bridge-EP) with 64G memory |
| test parameters  | cpufreq_governor=performance                                                                   |
|                  | mode=thread                                                                                    |
|                  | nr_task=100%                                                                                   |
|                  | test=mmap1                                                                                     |
+------------------+------------------------------------------------------------------------------------------------+
| testcase: change | stress-ng: stress-ng.enosys.ops_per_sec 2.7% improvement                                       |
| test machine     | 256 threads 2 sockets Intel(R) Xeon(R) 6768P  CPU @ 2.4GHz (Granite Rapids) with 64G memory    |
| test parameters  | cpufreq_governor=performance                                                                   |
|                  | nr_threads=100%                                                                                |
|                  | test=enosys                                                                                    |
|                  | testtime=60s                                                                                   |
+------------------+------------------------------------------------------------------------------------------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202601060955.b7b9ad22-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260106/202601060955.b7b9ad22-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/thread/100%/debian-13-x86_64-20250902.cgz/lkp-gnr-2sp4/mmap2/will-it-scale

commit: 
  80adaccf0e ("rseq: Delete duplicate if statement in rseq_virt_userspace_exit()")
  77d7dc8bef ("sched/mmcid: Revert the complex CID management")

80adaccf0e1c8c8f 77d7dc8bef482e987036bc20413 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    269391            +1.1%     272263        proc-vmstat.nr_active_anon
     63504            +4.4%      66328        proc-vmstat.nr_shmem
    269391            +1.1%     272263        proc-vmstat.nr_zone_active_anon
     11.95 ±  3%     +17.4%      14.02 ±  2%  vmstat.procs.r
     20097            -2.9%      19516        vmstat.system.cs
     29044           +11.3%      32338 ±  3%  vmstat.system.in
    103612           -10.4%      92803        will-it-scale.256.threads
    404.17           -10.4%     362.17        will-it-scale.per_thread_ops
    103612           -10.4%      92803        will-it-scale.workload
    189.50           +19.2%     225.83        turbostat.Avg_MHz
      4.87            +0.9        5.80        turbostat.Busy%
   8599483           +10.0%    9458122        turbostat.IRQ
    458140 ±  3%     +23.6%     566357        turbostat.NMI
      0.08 ±  2%      +0.0        0.10        mpstat.cpu.all.irq%
      0.11            +0.0        0.12        mpstat.cpu.all.soft%
      4.55            +0.9        5.44        mpstat.cpu.all.sys%
      0.03            +0.0        0.04        mpstat.cpu.all.usr%
      5.78 ±  6%     +82.1%      10.52 ± 16%  mpstat.max_utilization_pct
    102074 ±  3%     +52.3%     155501 ±  3%  sched_debug.cfs_rq:/.avg_vruntime.avg
    164773 ±  6%     +44.6%     238248 ±  5%  sched_debug.cfs_rq:/.avg_vruntime.max
     42856 ±  9%     +58.7%      68001 ± 14%  sched_debug.cfs_rq:/.avg_vruntime.min
      9382 ±  9%     +27.7%      11984 ±  8%  sched_debug.cfs_rq:/.avg_vruntime.stddev
    102074 ±  3%     +52.3%     155501 ±  3%  sched_debug.cfs_rq:/.min_vruntime.avg
    164773 ±  6%     +44.6%     238248 ±  5%  sched_debug.cfs_rq:/.min_vruntime.max
     42856 ±  9%     +58.7%      68001 ± 14%  sched_debug.cfs_rq:/.min_vruntime.min
      9382 ±  9%     +27.7%      11984 ±  8%  sched_debug.cfs_rq:/.min_vruntime.stddev
     66.73 ±  4%     +22.6%      81.81 ±  6%  sched_debug.cfs_rq:/.runnable_avg.avg
     66.54 ±  4%     +22.7%      81.64 ±  6%  sched_debug.cfs_rq:/.util_avg.avg
      0.48 ±  2%     -17.2%       0.40        perf-stat.i.MPKI
 2.558e+09           +18.0%  3.019e+09        perf-stat.i.branch-instructions
      0.46            -0.1        0.38        perf-stat.i.branch-miss-rate%
  11694311            -2.4%   11409165        perf-stat.i.branch-misses
   5886398            -3.0%    5709133        perf-stat.i.cache-misses
  96855626            -2.8%   94170475        perf-stat.i.cache-references
     20173            -2.9%      19590        perf-stat.i.context-switches
 4.908e+10           +19.0%   5.84e+10        perf-stat.i.cpu-cycles
      8540 ±  2%     +23.1%      10514        perf-stat.i.cycles-between-cache-misses
 1.248e+10           +18.6%   1.48e+10        perf-stat.i.instructions
      0.47 ±  2%     -18.3%       0.39        perf-stat.overall.MPKI
      0.46            -0.1        0.38        perf-stat.overall.branch-miss-rate%
      8347 ±  2%     +22.7%      10245        perf-stat.overall.cycles-between-cache-misses
  36264471 ±  2%     +32.5%   48054452        perf-stat.overall.path-length
 2.549e+09           +18.1%   3.01e+09        perf-stat.ps.branch-instructions
  11648745            -2.5%   11362824        perf-stat.ps.branch-misses
   5861219            -3.0%    5683399        perf-stat.ps.cache-misses
  96503727            -2.8%   93828560        perf-stat.ps.cache-references
     20100            -2.9%      19519        perf-stat.ps.context-switches
 4.891e+10           +19.0%  5.823e+10        perf-stat.ps.cpu-cycles
 1.243e+10           +18.6%  1.475e+10        perf-stat.ps.instructions
 3.757e+12           +18.7%  4.459e+12        perf-stat.total.instructions
      7.69 ±  4%      -1.3        6.36        perf-profile.calltrace.cycles-pp.common_startup_64
      4.55 ±  4%      -1.1        3.44        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4.34 ±  4%      -1.1        3.27        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
      5.25 ±  3%      -0.9        4.34        perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      5.25 ±  3%      -0.9        4.35        perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary.common_startup_64
      5.25 ±  3%      -0.9        4.35        perf-profile.calltrace.cycles-pp.start_secondary.common_startup_64
      3.25 ±  4%      -0.8        2.41        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      3.75 ±  4%      -0.7        3.02        perf-profile.calltrace.cycles-pp.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.81 ±  4%      -0.7        3.10        perf-profile.calltrace.cycles-pp.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      3.21 ±  4%      -0.7        2.52        perf-profile.calltrace.cycles-pp.rwsem_spin_on_owner.rwsem_down_write_slowpath.down_write_killable.__vm_munmap.__x64_sys_munmap
      3.18 ±  9%      -0.7        2.50        perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry
      3.09 ±  4%      -0.6        2.44        perf-profile.calltrace.cycles-pp.rwsem_spin_on_owner.rwsem_down_write_slowpath.down_write_killable.vm_mmap_pgoff.ksys_mmap_pgoff
      3.20 ±  4%      -0.6        2.59        perf-profile.calltrace.cycles-pp.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary
      2.44 ±  5%      -0.4        2.01        perf-profile.calltrace.cycles-pp.cpu_startup_entry.rest_init.start_kernel.x86_64_start_reservations.x86_64_start_kernel
      2.44 ±  5%      -0.4        2.01        perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.rest_init.start_kernel.x86_64_start_reservations
      2.44 ±  5%      -0.4        2.01        perf-profile.calltrace.cycles-pp.rest_init.start_kernel.x86_64_start_reservations.x86_64_start_kernel.common_startup_64
      2.44 ±  5%      -0.4        2.01        perf-profile.calltrace.cycles-pp.start_kernel.x86_64_start_reservations.x86_64_start_kernel.common_startup_64
      2.44 ±  5%      -0.4        2.01        perf-profile.calltrace.cycles-pp.x86_64_start_kernel.common_startup_64
      2.44 ±  5%      -0.4        2.01        perf-profile.calltrace.cycles-pp.x86_64_start_reservations.x86_64_start_kernel.common_startup_64
      2.09 ±  4%      -0.4        1.67        perf-profile.calltrace.cycles-pp.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      1.46 ±  4%      -0.4        1.07        perf-profile.calltrace.cycles-pp.up_read.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      1.86 ±  6%      -0.3        1.55 ±  2%  perf-profile.calltrace.cycles-pp.flush_smp_call_function_queue.do_idle.cpu_startup_entry.rest_init.start_kernel
      1.85 ±  6%      -0.3        1.54 ±  2%  perf-profile.calltrace.cycles-pp.do_softirq.flush_smp_call_function_queue.do_idle.cpu_startup_entry.rest_init
      1.85 ±  6%      -0.3        1.54 ±  2%  perf-profile.calltrace.cycles-pp.handle_softirqs.do_softirq.flush_smp_call_function_queue.do_idle.cpu_startup_entry
      1.84 ±  6%      -0.3        1.54 ±  2%  perf-profile.calltrace.cycles-pp._nohz_idle_balance.handle_softirqs.do_softirq.flush_smp_call_function_queue.do_idle
      1.44 ±  5%      -0.3        1.14        perf-profile.calltrace.cycles-pp.intel_idle_xstate.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
      1.30 ±  4%      -0.3        1.01        perf-profile.calltrace.cycles-pp.up_write.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.30 ±  4%      -0.3        1.05        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      1.34 ±  5%      -0.3        1.09 ±  2%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
      1.28 ±  3%      -0.3        1.03        perf-profile.calltrace.cycles-pp.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      1.23 ±  4%      -0.2        0.98        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      1.25 ±  5%      -0.2        1.01 ±  2%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call
      1.19 ±  4%      -0.2        0.95        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area
      1.20 ±  4%      -0.2        0.96        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap
      0.96 ±  3%      -0.2        0.74        perf-profile.calltrace.cycles-pp.rwsem_wake.up_read.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      1.03 ±  4%      -0.2        0.82        perf-profile.calltrace.cycles-pp.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area
      0.64 ±  5%      -0.2        0.43 ± 44%  perf-profile.calltrace.cycles-pp.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      0.99 ±  3%      -0.2        0.79 ±  2%  perf-profile.calltrace.cycles-pp.rwsem_wake.up_write.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      0.96 ±  4%      -0.2        0.76        perf-profile.calltrace.cycles-pp.mas_rev_awalk.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown
      0.88 ±  4%      -0.2        0.69 ±  2%  perf-profile.calltrace.cycles-pp.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      1.19 ±  5%      -0.2        1.01 ±  3%  perf-profile.calltrace.cycles-pp.sched_balance_update_blocked_averages._nohz_idle_balance.handle_softirqs.do_softirq.flush_smp_call_function_queue
      0.77 ±  5%      -0.2        0.62 ±  4%  perf-profile.calltrace.cycles-pp.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state
      0.78 ±  5%      -0.2        0.62 ±  3%  perf-profile.calltrace.cycles-pp.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state.cpuidle_enter
      0.66 ±  4%      -0.1        0.52        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      0.66 ±  5%      -0.1        0.57 ±  3%  perf-profile.calltrace.cycles-pp.__update_blocked_fair.sched_balance_update_blocked_averages._nohz_idle_balance.handle_softirqs.do_softirq
     45.59            +0.7       46.30        perf-profile.calltrace.cycles-pp.__munmap
     45.48            +0.7       46.22        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     45.48            +0.7       46.22        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
     45.44            +0.8       46.19        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     45.43            +0.8       46.19        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     45.92            +0.8       46.69        perf-profile.calltrace.cycles-pp.__mmap
     45.80            +0.8       46.60        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__mmap
     45.79            +0.8       46.60        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     45.72            +0.8       46.54        perf-profile.calltrace.cycles-pp.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     45.66            +0.8       46.49        perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     40.75            +1.9       42.66        perf-profile.calltrace.cycles-pp.down_write_killable.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
     40.40            +2.0       42.35        perf-profile.calltrace.cycles-pp.down_write_killable.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
     40.49            +2.0       42.46        perf-profile.calltrace.cycles-pp.rwsem_down_write_slowpath.down_write_killable.__vm_munmap.__x64_sys_munmap.do_syscall_64
     40.13            +2.0       42.14        perf-profile.calltrace.cycles-pp.rwsem_down_write_slowpath.down_write_killable.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
     35.72            +3.0       38.76        perf-profile.calltrace.cycles-pp.osq_lock.rwsem_down_write_slowpath.down_write_killable.__vm_munmap.__x64_sys_munmap
     35.43            +3.0       38.48        perf-profile.calltrace.cycles-pp.osq_lock.rwsem_down_write_slowpath.down_write_killable.vm_mmap_pgoff.ksys_mmap_pgoff
      6.36 ±  4%      -1.4        5.00        perf-profile.children.cycles-pp.rwsem_spin_on_owner
      7.69 ±  4%      -1.3        6.36        perf-profile.children.cycles-pp.common_startup_64
      7.69 ±  4%      -1.3        6.36        perf-profile.children.cycles-pp.cpu_startup_entry
      7.69 ±  4%      -1.3        6.36        perf-profile.children.cycles-pp.do_idle
      4.55 ±  4%      -1.1        3.44        perf-profile.children.cycles-pp.do_vmi_munmap
      4.34 ±  4%      -1.1        3.27        perf-profile.children.cycles-pp.do_vmi_align_munmap
      5.25 ±  3%      -0.9        4.35        perf-profile.children.cycles-pp.start_secondary
      3.44 ±  4%      -0.9        2.57        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      4.33 ±  4%      -0.8        3.52        perf-profile.children.cycles-pp.cpuidle_idle_call
      3.77 ±  4%      -0.7        3.04        perf-profile.children.cycles-pp.do_mmap
      3.66 ±  4%      -0.7        2.96        perf-profile.children.cycles-pp.cpuidle_enter
      3.65 ±  4%      -0.7        2.95        perf-profile.children.cycles-pp.cpuidle_enter_state
      2.44 ±  5%      -0.4        2.01        perf-profile.children.cycles-pp.rest_init
      2.44 ±  5%      -0.4        2.01        perf-profile.children.cycles-pp.start_kernel
      2.44 ±  5%      -0.4        2.01        perf-profile.children.cycles-pp.x86_64_start_kernel
      2.44 ±  5%      -0.4        2.01        perf-profile.children.cycles-pp.x86_64_start_reservations
      1.95 ±  3%      -0.4        1.53        perf-profile.children.cycles-pp.rwsem_wake
      2.11 ±  4%      -0.4        1.68        perf-profile.children.cycles-pp.__mmap_region
      1.46 ±  4%      -0.4        1.07        perf-profile.children.cycles-pp.up_read
      2.51 ±  5%      -0.4        2.13 ±  2%  perf-profile.children.cycles-pp.handle_softirqs
      2.38 ±  4%      -0.4        2.01 ±  2%  perf-profile.children.cycles-pp.flush_smp_call_function_queue
      2.19 ±  5%      -0.3        1.86 ±  2%  perf-profile.children.cycles-pp._nohz_idle_balance
      1.63 ±  4%      -0.3        1.30        perf-profile.children.cycles-pp.intel_idle_xstate
      1.32 ±  4%      -0.3        1.02 ±  2%  perf-profile.children.cycles-pp.up_write
      1.93 ±  4%      -0.3        1.66 ±  3%  perf-profile.children.cycles-pp.do_softirq
      1.31 ±  3%      -0.3        1.05        perf-profile.children.cycles-pp.__get_unmapped_area
      1.28 ±  3%      -0.3        1.03        perf-profile.children.cycles-pp.shmem_get_unmapped_area
      1.23 ±  4%      -0.3        0.98        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      1.20 ±  4%      -0.2        0.96        perf-profile.children.cycles-pp.vm_unmapped_area
      1.19 ±  4%      -0.2        0.95        perf-profile.children.cycles-pp.unmapped_area_topdown
      2.47 ±  3%      -0.2        2.25        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      1.03 ±  4%      -0.2        0.82        perf-profile.children.cycles-pp.mas_empty_area_rev
      1.04 ±  3%      -0.2        0.83 ±  2%  perf-profile.children.cycles-pp.wake_up_q
      1.01 ±  3%      -0.2        0.80        perf-profile.children.cycles-pp.try_to_wake_up
      1.51 ±  5%      -0.2        1.30 ±  2%  perf-profile.children.cycles-pp.sched_balance_update_blocked_averages
      2.34 ±  3%      -0.2        2.15        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.96 ±  4%      -0.2        0.76        perf-profile.children.cycles-pp.mas_rev_awalk
      0.89 ±  4%      -0.2        0.70 ±  2%  perf-profile.children.cycles-pp.__mmap_new_vma
      1.00 ±  3%      -0.2        0.82 ±  2%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      1.09 ±  3%      -0.2        0.93 ±  2%  perf-profile.children.cycles-pp.__schedule
      0.67 ±  4%      -0.1        0.52        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      0.41 ±  5%      -0.1        0.28 ±  4%  perf-profile.children.cycles-pp._raw_spin_lock_irq
      0.58 ±  3%      -0.1        0.45 ±  3%  perf-profile.children.cycles-pp.downgrade_write
      0.51 ±  5%      -0.1        0.38 ±  3%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
      0.58 ±  2%      -0.1        0.46 ±  3%  perf-profile.children.cycles-pp.osq_unlock
      0.84 ±  5%      -0.1        0.73 ±  4%  perf-profile.children.cycles-pp.__update_blocked_fair
      0.65 ±  4%      -0.1        0.54        perf-profile.children.cycles-pp.wake_q_add
      0.59 ±  6%      -0.1        0.48        perf-profile.children.cycles-pp.__irq_exit_rcu
      0.69 ±  3%      -0.1        0.59 ±  2%  perf-profile.children.cycles-pp.schedule
      0.49 ±  5%      -0.1        0.39 ±  2%  perf-profile.children.cycles-pp.vms_clear_ptes
      0.46 ±  4%      -0.1        0.37        perf-profile.children.cycles-pp.__flush_smp_call_function_queue
      0.44 ±  4%      -0.1        0.35 ±  2%  perf-profile.children.cycles-pp.mas_store_gfp
      0.68 ±  4%      -0.1        0.59 ±  2%  perf-profile.children.cycles-pp.sched_balance_rq
      0.57 ±  4%      -0.1        0.48 ±  2%  perf-profile.children.cycles-pp.sched_balance_domains
      0.55 ±  3%      -0.1        0.46 ±  2%  perf-profile.children.cycles-pp.schedule_preempt_disabled
      0.39 ±  3%      -0.1        0.32 ±  3%  perf-profile.children.cycles-pp.sched_ttwu_pending
      0.52 ±  5%      -0.1        0.45 ±  3%  perf-profile.children.cycles-pp.sched_balance_find_src_group
      0.52 ±  5%      -0.1        0.45 ±  2%  perf-profile.children.cycles-pp.update_sd_lb_stats
      0.40 ±  7%      -0.1        0.33 ±  4%  perf-profile.children.cycles-pp.tick_nohz_idle_exit
      0.34 ±  6%      -0.1        0.27 ±  3%  perf-profile.children.cycles-pp.mas_update_gap
      0.34 ±  5%      -0.1        0.27 ±  2%  perf-profile.children.cycles-pp.perf_event_mmap
      0.48 ±  4%      -0.1        0.42 ±  2%  perf-profile.children.cycles-pp.__pick_next_task
      0.32 ±  7%      -0.1        0.26 ±  3%  perf-profile.children.cycles-pp.mas_find
      0.28 ±  3%      -0.1        0.21 ±  3%  perf-profile.children.cycles-pp.__vma_start_write
      0.33 ±  3%      -0.1        0.27        perf-profile.children.cycles-pp.perf_event_mmap_event
      0.45 ±  6%      -0.1        0.39        perf-profile.children.cycles-pp.raw_spin_rq_lock_nested
      0.30 ±  5%      -0.1        0.24 ±  3%  perf-profile.children.cycles-pp.ttwu_do_activate
      0.46 ±  5%      -0.1        0.40 ±  2%  perf-profile.children.cycles-pp.update_sg_lb_stats
      0.28 ±  6%      -0.1        0.22 ±  2%  perf-profile.children.cycles-pp.tlb_gather_mmu
      0.50 ±  6%      -0.1        0.44 ±  3%  perf-profile.children.cycles-pp._raw_spin_lock
      0.32 ±  2%      -0.1        0.27 ±  2%  perf-profile.children.cycles-pp.menu_select
      0.26 ±  2%      -0.1        0.21 ±  4%  perf-profile.children.cycles-pp.down_write
      0.40 ±  5%      -0.1        0.35        perf-profile.children.cycles-pp.schedule_idle
      0.27 ±  4%      -0.1        0.22 ±  2%  perf-profile.children.cycles-pp.enqueue_task
      0.31 ±  4%      -0.0        0.26 ±  2%  perf-profile.children.cycles-pp.mas_data_end
      0.25 ±  6%      -0.0        0.20 ±  4%  perf-profile.children.cycles-pp.tick_nohz_restart_sched_tick
      0.25 ±  5%      -0.0        0.21 ±  3%  perf-profile.children.cycles-pp.enqueue_task_fair
      0.28 ±  5%      -0.0        0.24 ±  2%  perf-profile.children.cycles-pp.update_rq_clock_task
      0.18 ±  6%      -0.0        0.14 ±  4%  perf-profile.children.cycles-pp.mmap_region
      0.23 ±  8%      -0.0        0.19 ±  4%  perf-profile.children.cycles-pp.mas_walk
      0.07 ±  6%      -0.0        0.03 ± 70%  perf-profile.children.cycles-pp.check_cpu_stall
      0.33 ±  4%      -0.0        0.29 ±  2%  perf-profile.children.cycles-pp.pick_next_task_fair
      0.30 ±  3%      -0.0        0.26 ±  3%  perf-profile.children.cycles-pp.sched_balance_newidle
      0.06 ±  6%      -0.0        0.02 ± 99%  perf-profile.children.cycles-pp.timerqueue_add
      0.25 ±  4%      -0.0        0.21 ±  5%  perf-profile.children.cycles-pp.idle_cpu
      0.20 ±  6%      -0.0        0.16 ±  4%  perf-profile.children.cycles-pp.enqueue_entity
      0.18 ±  7%      -0.0        0.15 ±  2%  perf-profile.children.cycles-pp.mas_store_prealloc
      0.12 ±  6%      -0.0        0.09 ±  7%  perf-profile.children.cycles-pp.hrtimer_start_range_ns
      0.16 ±  5%      -0.0        0.13 ±  2%  perf-profile.children.cycles-pp.dequeue_entities
      0.17 ±  5%      -0.0        0.14 ±  4%  perf-profile.children.cycles-pp.dequeue_task_fair
      0.12 ±  3%      -0.0        0.09 ±  7%  perf-profile.children.cycles-pp.rcu_sched_clock_irq
      0.16 ±  6%      -0.0        0.13 ±  5%  perf-profile.children.cycles-pp.tick_irq_enter
      0.11 ±  5%      -0.0        0.08 ±  4%  perf-profile.children.cycles-pp.ttwu_queue_wakelist
      0.16 ±  6%      -0.0        0.13 ±  3%  perf-profile.children.cycles-pp.irq_enter_rcu
      0.12 ±  8%      -0.0        0.09 ±  5%  perf-profile.children.cycles-pp.mas_wr_node_store
      0.17 ±  5%      -0.0        0.14 ±  4%  perf-profile.children.cycles-pp.try_to_block_task
      0.10 ±  6%      -0.0        0.08 ±  6%  perf-profile.children.cycles-pp.__smp_call_single_queue
      0.10 ±  3%      -0.0        0.08 ± 10%  perf-profile.children.cycles-pp.rcu_pending
      0.12 ±  5%      -0.0        0.09 ±  5%  perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
      0.14 ±  4%      -0.0        0.11 ±  9%  perf-profile.children.cycles-pp.smpboot_thread_fn
      0.15 ±  5%      -0.0        0.12 ±  4%  perf-profile.children.cycles-pp.tick_nohz_get_sleep_length
      0.11 ±  8%      -0.0        0.08 ±  5%  perf-profile.children.cycles-pp.cmd_stat
      0.11 ±  8%      -0.0        0.08 ±  5%  perf-profile.children.cycles-pp.dispatch_events
      0.11 ±  8%      -0.0        0.08 ±  5%  perf-profile.children.cycles-pp.process_interval
      0.14 ±  4%      -0.0        0.12 ±  4%  perf-profile.children.cycles-pp.update_rq_clock
      0.11 ±  6%      -0.0        0.08 ±  5%  perf-profile.children.cycles-pp.vm_area_alloc
      0.13 ±  5%      -0.0        0.11 ±  3%  perf-profile.children.cycles-pp.vma_merge_new_range
      0.08 ± 12%      -0.0        0.06 ±  8%  perf-profile.children.cycles-pp.unmap_vmas
      0.13 ±  6%      -0.0        0.10 ±  4%  perf-profile.children.cycles-pp.dequeue_entity
      0.10 ±  9%      -0.0        0.08 ± 10%  perf-profile.children.cycles-pp.read_counters
      0.13 ±  5%      -0.0        0.10 ±  7%  perf-profile.children.cycles-pp.tick_nohz_idle_stop_tick
      0.13 ±  5%      -0.0        0.10 ±  7%  perf-profile.children.cycles-pp.tick_nohz_stop_tick
      0.18 ±  5%      -0.0        0.16 ±  4%  perf-profile.children.cycles-pp.ktime_get
      0.10 ±  6%      -0.0        0.08 ±  7%  perf-profile.children.cycles-pp.native_sched_clock
      0.12 ±  5%      -0.0        0.10 ±  5%  perf-profile.children.cycles-pp.tick_nohz_next_event
      0.07 ±  9%      -0.0        0.05        perf-profile.children.cycles-pp.mas_preallocate
      0.08            -0.0        0.06        perf-profile.children.cycles-pp.__build_id_parse
      0.09 ±  7%      -0.0        0.07 ±  5%  perf-profile.children.cycles-pp.update_irq_load_avg
      0.11 ±  5%      -0.0        0.09        perf-profile.children.cycles-pp.free_pgtables
      0.12 ±  8%      -0.0        0.10        perf-profile.children.cycles-pp.touch_atime
      0.08 ±  6%      -0.0        0.06 ±  8%  perf-profile.children.cycles-pp.entry_SYSCALL_64
      0.07 ± 10%      -0.0        0.05        perf-profile.children.cycles-pp.testcase
      0.11 ±  5%      -0.0        0.09 ±  4%  perf-profile.children.cycles-pp.__get_next_timer_interrupt
      0.12 ±  7%      -0.0        0.10 ±  4%  perf-profile.children.cycles-pp.shmem_mmap
      0.14 ±  3%      -0.0        0.12 ±  5%  perf-profile.children.cycles-pp.__update_load_avg_cfs_rq
      0.13 ±  4%      -0.0        0.11 ±  4%  perf-profile.children.cycles-pp.mas_leaf_max_gap
      0.07 ±  7%      -0.0        0.05        perf-profile.children.cycles-pp.prepare_task_switch
      0.06 ±  7%      -0.0        0.05        perf-profile.children.cycles-pp.freader_fetch
      0.06 ±  7%      -0.0        0.05        perf-profile.children.cycles-pp.mas_next_slot
      0.10 ±  8%      -0.0        0.08        perf-profile.children.cycles-pp.sched_balance_softirq
      0.08 ±  5%      -0.0        0.07 ±  5%  perf-profile.children.cycles-pp.select_task_rq_fair
      0.07 ±  7%      -0.0        0.05 ±  8%  perf-profile.children.cycles-pp.update_se
      0.07 ±  5%      -0.0        0.06        perf-profile.children.cycles-pp.__x64_sys_execve
      0.07 ±  5%      -0.0        0.06        perf-profile.children.cycles-pp.do_execveat_common
      0.07 ±  5%      -0.0        0.06        perf-profile.children.cycles-pp.execve
      0.06 ±  6%      -0.0        0.05        perf-profile.children.cycles-pp.ksys_read
      0.08 ±  6%      -0.0        0.06 ±  7%  perf-profile.children.cycles-pp.nr_iowait_cpu
      0.09 ±  4%      +0.0        0.14 ±  9%  perf-profile.children.cycles-pp.update_cfs_group
      0.23 ±  4%      +0.1        0.32 ±  6%  perf-profile.children.cycles-pp.task_tick_fair
      0.08 ±  8%      +0.2        0.24 ±  3%  perf-profile.children.cycles-pp.__vm_enough_memory
      0.16 ±  6%      +0.3        0.47 ±  2%  perf-profile.children.cycles-pp.percpu_counter_add_batch
     45.63            +0.7       46.33        perf-profile.children.cycles-pp.__munmap
     45.44            +0.8       46.19        perf-profile.children.cycles-pp.__x64_sys_munmap
     45.43            +0.8       46.19        perf-profile.children.cycles-pp.__vm_munmap
     45.95            +0.8       46.71        perf-profile.children.cycles-pp.__mmap
     45.73            +0.8       46.56        perf-profile.children.cycles-pp.ksys_mmap_pgoff
     45.67            +0.8       46.51        perf-profile.children.cycles-pp.vm_mmap_pgoff
     91.60            +1.5       93.08        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     91.58            +1.5       93.07        perf-profile.children.cycles-pp.do_syscall_64
     81.15            +3.9       85.00        perf-profile.children.cycles-pp.down_write_killable
     80.82            +3.9       84.74        perf-profile.children.cycles-pp.rwsem_down_write_slowpath
     71.16            +6.1       77.26        perf-profile.children.cycles-pp.osq_lock
      6.10 ±  4%      -1.3        4.82        perf-profile.self.cycles-pp.rwsem_spin_on_owner
      1.84 ±  4%      -0.5        1.33        perf-profile.self.cycles-pp.rwsem_down_write_slowpath
      1.62 ±  5%      -0.3        1.29        perf-profile.self.cycles-pp.intel_idle_xstate
      0.55 ±  5%      -0.2        0.32 ±  4%  perf-profile.self.cycles-pp.vms_complete_munmap_vmas
      0.50 ±  7%      -0.2        0.32 ±  2%  perf-profile.self.cycles-pp.up_read
      0.67 ±  4%      -0.1        0.52        perf-profile.self.cycles-pp.mas_rev_awalk
      0.80 ±  3%      -0.1        0.66 ±  3%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.51 ±  5%      -0.1        0.38 ±  3%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.43 ±  4%      -0.1        0.30 ±  3%  perf-profile.self.cycles-pp.downgrade_write
      0.57 ±  2%      -0.1        0.45 ±  3%  perf-profile.self.cycles-pp.osq_unlock
      0.65 ±  4%      -0.1        0.54        perf-profile.self.cycles-pp.wake_q_add
      0.32 ±  8%      -0.1        0.23 ±  4%  perf-profile.self.cycles-pp.up_write
      0.18 ±  5%      -0.1        0.10 ±  4%  perf-profile.self.cycles-pp.vm_mmap_pgoff
      0.45 ±  6%      -0.1        0.38 ±  2%  perf-profile.self.cycles-pp._raw_spin_lock
      0.45 ±  5%      -0.1        0.38 ±  3%  perf-profile.self.cycles-pp.__update_blocked_fair
      0.32 ±  6%      -0.1        0.26 ±  6%  perf-profile.self.cycles-pp.down_write_killable
      0.27 ±  3%      -0.1        0.21 ±  2%  perf-profile.self.cycles-pp.__vma_start_write
      0.28 ±  6%      -0.1        0.22 ±  3%  perf-profile.self.cycles-pp.tlb_gather_mmu
      0.26 ±  6%      -0.1        0.20 ±  2%  perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      0.26 ±  2%      -0.1        0.20 ±  3%  perf-profile.self.cycles-pp.down_write
      0.30 ±  4%      -0.1        0.25 ±  2%  perf-profile.self.cycles-pp.mas_data_end
      0.21 ±  7%      -0.1        0.16 ±  4%  perf-profile.self.cycles-pp.mas_update_gap
      0.13 ±  4%      -0.0        0.08 ±  5%  perf-profile.self.cycles-pp.__vm_munmap
      0.18 ±  6%      -0.0        0.14 ±  4%  perf-profile.self.cycles-pp.mmap_region
      0.23 ±  8%      -0.0        0.19 ±  4%  perf-profile.self.cycles-pp.mas_walk
      0.35 ±  4%      -0.0        0.31 ±  2%  perf-profile.self.cycles-pp.update_sg_lb_stats
      0.07 ±  6%      -0.0        0.03 ± 70%  perf-profile.self.cycles-pp.check_cpu_stall
      0.14 ±  7%      -0.0        0.10 ±  6%  perf-profile.self.cycles-pp._raw_spin_lock_irq
      0.24 ±  5%      -0.0        0.20 ±  2%  perf-profile.self.cycles-pp.update_rq_clock_task
      0.14 ±  5%      -0.0        0.11 ±  4%  perf-profile.self.cycles-pp.__mmap_new_vma
      0.10 ±  6%      -0.0        0.07 ±  5%  perf-profile.self.cycles-pp.__schedule
      0.21 ±  5%      -0.0        0.18 ±  3%  perf-profile.self.cycles-pp.cpuidle_enter_state
      0.24 ±  5%      -0.0        0.21 ±  6%  perf-profile.self.cycles-pp.idle_cpu
      0.13 ±  4%      -0.0        0.11 ±  6%  perf-profile.self.cycles-pp.mas_leaf_max_gap
      0.10 ±  6%      -0.0        0.08 ±  7%  perf-profile.self.cycles-pp.native_sched_clock
      0.06 ±  6%      -0.0        0.04 ± 44%  perf-profile.self.cycles-pp.__mmap
      0.11 ±  8%      -0.0        0.09 ±  5%  perf-profile.self.cycles-pp.update_rq_clock
      0.08 ±  6%      -0.0        0.06 ±  8%  perf-profile.self.cycles-pp.menu_select
      0.08 ±  6%      -0.0        0.06 ±  6%  perf-profile.self.cycles-pp.vma_merge_new_range
      0.08 ±  6%      -0.0        0.06 ±  7%  perf-profile.self.cycles-pp.nr_iowait_cpu
      0.09 ±  4%      +0.0        0.14 ±  9%  perf-profile.self.cycles-pp.update_cfs_group
      0.11 ± 10%      +0.3        0.41        perf-profile.self.cycles-pp.percpu_counter_add_batch
     70.44            +6.0       76.42        perf-profile.self.cycles-pp.osq_lock


***************************************************************************************************
lkp-ivb-2ep2: 48 threads 2 sockets Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz (Ivy Bridge-EP) with 64G memory
=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/thread/100%/debian-13-x86_64-20250902.cgz/lkp-ivb-2ep2/mmap1/will-it-scale

commit: 
  80adaccf0e ("rseq: Delete duplicate if statement in rseq_virt_userspace_exit()")
  77d7dc8bef ("sched/mmcid: Revert the complex CID management")

80adaccf0e1c8c8f 77d7dc8bef482e987036bc20413 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     18.07 ± 11%      -3.9       14.22 ±  3%  mpstat.cpu.all.sys%
     47.33 ± 23%     -35.2%      30.66 ± 17%  mpstat.max_utilization_pct
      8.67 ±  6%     -16.1%       7.27 ±  5%  vmstat.procs.r
     64828            +2.8%      66674        vmstat.system.in
    302003 ± 26%     -35.5%     194730 ±  4%  sched_debug.cfs_rq:/.avg_vruntime.avg
    285099 ± 26%     -36.6%     180836 ±  5%  sched_debug.cfs_rq:/.avg_vruntime.min
    302003 ± 26%     -35.5%     194730 ±  4%  sched_debug.cfs_rq:/.min_vruntime.avg
    285099 ± 26%     -36.6%     180836 ±  5%  sched_debug.cfs_rq:/.min_vruntime.min
    101936            +3.6%     105574 ±  2%  will-it-scale.48.threads
     79.96 ±  2%      +4.8%      83.77        will-it-scale.48.threads_idle
      2123            +3.6%       2199 ±  2%  will-it-scale.per_thread_ops
    101936            +3.6%     105574 ±  2%  will-it-scale.workload
    629.33 ±  9%     -16.4%     526.00 ±  2%  turbostat.Avg_MHz
     20.90 ±  9%      -3.5       17.40 ±  2%  turbostat.Busy%
      9.13 ±  3%      -2.0        7.16 ±  5%  turbostat.C1%
      3.53            -0.4        3.13 ±  3%  turbostat.C1E%
     30.70 ±  4%     +14.8%      35.23 ±  2%  turbostat.CPU%c6
    103.13 ±  2%      -5.1%      97.88        turbostat.CorWatt
      0.15 ±  4%     +53.3%       0.24 ± 37%  turbostat.Pkg%pc2
    132.79            -4.0%     127.52        turbostat.PkgWatt
     12.40 ±  2%      +4.3%      12.93        turbostat.RAMWatt
      0.90 ±  7%     +25.6%       1.13 ±  3%  perf-stat.i.MPKI
 3.591e+09 ±  9%     -17.9%  2.949e+09 ±  2%  perf-stat.i.branch-instructions
      0.87 ±  7%      +0.2        1.05 ±  2%  perf-stat.i.branch-miss-rate%
  29809180            +4.1%   31036670        perf-stat.i.branch-misses
     22.46            +0.5       22.92        perf-stat.i.cache-miss-rate%
  14236478            +5.5%   15012904        perf-stat.i.cache-misses
  63584242            +3.3%   65678837        perf-stat.i.cache-references
      1.76            +2.9%       1.81        perf-stat.i.cpi
 2.957e+10 ±  9%     -16.6%  2.466e+10 ±  2%  perf-stat.i.cpu-cycles
    177.35 ±  2%      -5.8%     167.05        perf-stat.i.cpu-migrations
      2091 ± 11%     -21.4%       1642 ±  2%  perf-stat.i.cycles-between-cache-misses
 1.698e+10 ± 10%     -18.8%  1.378e+10 ±  2%  perf-stat.i.instructions
      0.57            -2.7%       0.56        perf-stat.i.ipc
      0.85 ± 10%     +28.7%       1.09 ±  2%  perf-stat.overall.MPKI
      0.84 ± 10%      +0.2        1.05 ±  3%  perf-stat.overall.branch-miss-rate%
     22.39            +0.5       22.86        perf-stat.overall.cache-miss-rate%
      1.74            +2.7%       1.79        perf-stat.overall.cpi
      2079 ± 10%     -21.0%       1642 ±  2%  perf-stat.overall.cycles-between-cache-misses
      0.57            -2.6%       0.56        perf-stat.overall.ipc
  50164531 ± 10%     -21.6%   39342813 ±  4%  perf-stat.overall.path-length
 3.579e+09 ±  9%     -17.9%   2.94e+09 ±  2%  perf-stat.ps.branch-instructions
  29712627            +4.1%   30936090        perf-stat.ps.branch-misses
  14188864            +5.5%   14962872        perf-stat.ps.cache-misses
  63371857            +3.3%   65460230        perf-stat.ps.cache-references
 2.947e+10 ±  9%     -16.6%  2.458e+10 ±  2%  perf-stat.ps.cpu-cycles
    176.76 ±  2%      -5.8%     166.51        perf-stat.ps.cpu-migrations
 1.692e+10 ± 10%     -18.8%  1.373e+10 ±  2%  perf-stat.ps.instructions
 5.111e+12 ± 10%     -18.8%   4.15e+12 ±  2%  perf-stat.total.instructions
      0.58 ±  2%      +0.0        0.62 ±  4%  perf-profile.calltrace.cycles-pp.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.68 ±  3%      +0.0        0.73        perf-profile.calltrace.cycles-pp.wake_up_q.rwsem_wake.up_read.vms_complete_munmap_vmas.do_vmi_align_munmap
      0.66 ±  3%      +0.0        0.70        perf-profile.calltrace.cycles-pp.try_to_wake_up.wake_up_q.rwsem_wake.up_read.vms_complete_munmap_vmas
      0.98 ±  3%      +0.0        1.02 ±  2%  perf-profile.calltrace.cycles-pp.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.68 ±  2%      +0.1        0.73 ±  4%  perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area
      0.68 ±  2%      +0.1        0.74 ±  5%  perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap
      0.77            +0.1        0.82 ±  4%  perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      0.79 ±  2%      +0.1        0.87 ±  4%  perf-profile.calltrace.cycles-pp.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap.vm_mmap_pgoff.do_syscall_64
      0.84 ±  2%      +0.1        0.92 ±  4%  perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.19 ±  4%      +0.1        1.28 ±  2%  perf-profile.calltrace.cycles-pp.schedule_idle.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      0.87 ± 19%      +0.2        1.06        perf-profile.calltrace.cycles-pp.cpu_startup_entry.rest_init.start_kernel.x86_64_start_reservations.x86_64_start_kernel
      0.87 ± 19%      +0.2        1.06        perf-profile.calltrace.cycles-pp.rest_init.start_kernel.x86_64_start_reservations.x86_64_start_kernel.common_startup_64
      0.87 ± 19%      +0.2        1.06        perf-profile.calltrace.cycles-pp.start_kernel.x86_64_start_reservations.x86_64_start_kernel.common_startup_64
      0.87 ± 19%      +0.2        1.06        perf-profile.calltrace.cycles-pp.x86_64_start_kernel.common_startup_64
      0.87 ± 19%      +0.2        1.06        perf-profile.calltrace.cycles-pp.x86_64_start_reservations.x86_64_start_kernel.common_startup_64
      0.14 ±  9%      -0.0        0.12 ±  5%  perf-profile.children.cycles-pp.tlb_gather_mmu
      0.06 ± 13%      +0.0        0.08 ±  6%  perf-profile.children.cycles-pp.security_vm_enough_memory_mm
      0.10 ±  8%      +0.0        0.12 ±  7%  perf-profile.children.cycles-pp.free_pgd_range
      0.47 ±  2%      +0.0        0.51 ±  4%  perf-profile.children.cycles-pp.mas_empty_area_rev
      0.84            +0.0        0.88        perf-profile.children.cycles-pp.vma_complete
      0.98 ±  3%      +0.0        1.02 ±  2%  perf-profile.children.cycles-pp.vms_clear_ptes
      0.02 ±141%      +0.0        0.06 ±  7%  perf-profile.children.cycles-pp.rwsem_mark_wake
      0.59 ±  2%      +0.0        0.63 ±  3%  perf-profile.children.cycles-pp.free_pgtables
      0.68 ±  2%      +0.1        0.73 ±  5%  perf-profile.children.cycles-pp.unmapped_area_topdown
      0.68            +0.1        0.74 ±  4%  perf-profile.children.cycles-pp.vm_unmapped_area
      0.77            +0.1        0.83 ±  5%  perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      0.00            +0.1        0.06 ± 11%  perf-profile.children.cycles-pp.mm_cid_get
      0.21 ±  3%      +0.1        0.28 ±  6%  perf-profile.children.cycles-pp.wake_q_add
      0.84 ±  2%      +0.1        0.92 ±  4%  perf-profile.children.cycles-pp.__get_unmapped_area
      0.79 ±  2%      +0.1        0.87 ±  4%  perf-profile.children.cycles-pp.thp_get_unmapped_area_vmflags
      1.28 ±  2%      +0.1        1.38 ±  2%  perf-profile.children.cycles-pp.wake_up_q
      1.24 ±  2%      +0.1        1.33 ±  2%  perf-profile.children.cycles-pp.try_to_wake_up
      1.22 ±  4%      +0.1        1.32 ±  2%  perf-profile.children.cycles-pp.schedule_idle
      2.38 ±  3%      +0.1        2.50        perf-profile.children.cycles-pp.__schedule
      1.83            +0.1        1.96 ±  2%  perf-profile.children.cycles-pp.rwsem_wake
      0.87 ± 19%      +0.2        1.06        perf-profile.children.cycles-pp.rest_init
      0.87 ± 19%      +0.2        1.06        perf-profile.children.cycles-pp.start_kernel
      0.87 ± 19%      +0.2        1.06        perf-profile.children.cycles-pp.x86_64_start_kernel
      0.87 ± 19%      +0.2        1.06        perf-profile.children.cycles-pp.x86_64_start_reservations
      0.22 ±  8%      -0.0        0.18 ±  6%  perf-profile.self.cycles-pp.vms_complete_munmap_vmas
      0.05 ± 45%      +0.0        0.08 ±  9%  perf-profile.self.cycles-pp.mas_empty_area_rev
      0.02 ±141%      +0.0        0.06 ±  7%  perf-profile.self.cycles-pp.rwsem_mark_wake
      0.00            +0.1        0.06 ± 11%  perf-profile.self.cycles-pp.mm_cid_get
      0.21 ±  3%      +0.1        0.28 ±  6%  perf-profile.self.cycles-pp.wake_q_add



***************************************************************************************************
lkp-gnr-2sp4: 256 threads 2 sockets Intel(R) Xeon(R) 6768P  CPU @ 2.4GHz (Granite Rapids) with 64G memory
=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-gnr-2sp4/enosys/stress-ng/60s

commit: 
  80adaccf0e ("rseq: Delete duplicate if statement in rseq_virt_userspace_exit()")
  77d7dc8bef ("sched/mmcid: Revert the complex CID management")

80adaccf0e1c8c8f 77d7dc8bef482e987036bc20413 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      1.72            -0.3        1.45        mpstat.cpu.all.irq%
    359128 ±  6%     +11.4%     400016 ±  3%  numa-meminfo.node0.Slab
      2599 ±  3%     -15.3%       2200 ±  9%  perf-c2c.DRAM.remote
     16.86            +0.3       17.15        turbostat.C1%
      1.29 ±  2%      -0.0        1.24        turbostat.C1E%
 7.172e+08            +2.7%  7.368e+08        stress-ng.enosys.ops
  11968579            +2.7%   12297343        stress-ng.enosys.ops_per_sec
     93501            +2.7%      96070        stress-ng.enosys.syscalls_per_second
  47588033            +7.3%   51081361        stress-ng.time.involuntary_context_switches
 1.412e+09            +2.6%  1.449e+09        stress-ng.time.voluntary_context_switches
      0.14           -15.4%       0.12        perf-stat.i.MPKI
 7.113e+10            +1.5%  7.217e+10        perf-stat.i.branch-instructions
      0.78            -0.0        0.76        perf-stat.i.branch-miss-rate%
      1.02            -0.1        0.90        perf-stat.i.cache-miss-rate%
  49452856           -14.1%   42492832        perf-stat.i.cache-misses
 5.659e+09            -1.7%  5.563e+09        perf-stat.i.cache-references
  39101456            +2.5%   40060126        perf-stat.i.context-switches
      2.43            -1.8%       2.39        perf-stat.i.cpi
     20302           +27.2%      25834 ±  2%  perf-stat.i.cycles-between-cache-misses
 3.522e+11            +1.5%  3.576e+11        perf-stat.i.instructions
      0.44            +1.7%       0.45        perf-stat.i.ipc
    194.63            +2.1%     198.62        perf-stat.i.metric.K/sec
      0.14           -15.2%       0.12        perf-stat.overall.MPKI
      0.72            -0.0        0.71        perf-stat.overall.branch-miss-rate%
      0.87            -0.1        0.76        perf-stat.overall.cache-miss-rate%
      2.27            -1.9%       2.23        perf-stat.overall.cpi
     16200           +15.8%      18762        perf-stat.overall.cycles-between-cache-misses
      0.44            +1.9%       0.45        perf-stat.overall.ipc
 6.981e+10            +1.6%  7.092e+10        perf-stat.ps.branch-instructions
  48451570           -13.8%   41741420        perf-stat.ps.cache-misses
 5.566e+09            -1.7%  5.471e+09        perf-stat.ps.cache-references
  38495150            +2.4%   39418126        perf-stat.ps.context-switches
 3.458e+11            +1.6%  3.515e+11        perf-stat.ps.instructions
 2.098e+13            +1.9%  2.138e+13        perf-stat.total.instructions
      5.70            -0.8        4.90        perf-profile.calltrace.cycles-pp.ttwu_do_activate.sched_ttwu_pending.__flush_smp_call_function_queue.flush_smp_call_function_queue.do_idle
      7.05            -0.8        6.28        perf-profile.calltrace.cycles-pp.sched_ttwu_pending.__flush_smp_call_function_queue.flush_smp_call_function_queue.do_idle.cpu_startup_entry
     27.35            -0.7       26.61        perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_secondary.common_startup_64
     27.41            -0.7       26.67        perf-profile.calltrace.cycles-pp.start_secondary.common_startup_64
     27.52            -0.7       26.78        perf-profile.calltrace.cycles-pp.common_startup_64
      8.75            -0.7        8.01        perf-profile.calltrace.cycles-pp.flush_smp_call_function_queue.do_idle.cpu_startup_entry.start_secondary.common_startup_64
     27.38            -0.7       26.65        perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary.common_startup_64
      7.98            -0.7        7.24        perf-profile.calltrace.cycles-pp.__flush_smp_call_function_queue.flush_smp_call_function_queue.do_idle.cpu_startup_entry.start_secondary
      1.17            -0.2        0.98        perf-profile.calltrace.cycles-pp.__switch_to
     11.65            -0.1       11.54        perf-profile.calltrace.cycles-pp.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary.common_startup_64
     10.94            -0.1       10.83        perf-profile.calltrace.cycles-pp.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary
     10.83            -0.1       10.74        perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry
      0.70            -0.1        0.61        perf-profile.calltrace.cycles-pp.nohz_run_idle_balance.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      1.57            -0.1        1.51        perf-profile.calltrace.cycles-pp.restore_fpregs_from_fpstate.switch_fpu_return.arch_exit_to_user_mode_prepare.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.86            -0.0        0.84        perf-profile.calltrace.cycles-pp.finish_task_switch.__schedule.schedule.anon_pipe_read.vfs_read
      0.54            -0.0        0.52        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__getpid
      0.78            +0.0        0.79        perf-profile.calltrace.cycles-pp.raw_spin_rq_lock_nested.__schedule.schedule.anon_pipe_read.vfs_read
      0.72            +0.0        0.74        perf-profile.calltrace.cycles-pp.switch_mm_irqs_off.__schedule.schedule_idle.do_idle.cpu_startup_entry
      0.71            +0.0        0.73        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.raw_spin_rq_lock_nested.__task_rq_lock.try_to_wake_up
      1.36            +0.0        1.38        perf-profile.calltrace.cycles-pp.pick_next_task_fair.__pick_next_task.__schedule.schedule_idle.do_idle
      0.95            +0.0        0.97        perf-profile.calltrace.cycles-pp.wake_affine.select_task_rq_fair.select_task_rq.try_to_wake_up.autoremove_wake_function
      0.75            +0.0        0.78        perf-profile.calltrace.cycles-pp.raw_spin_rq_lock_nested.__schedule.schedule_idle.do_idle.cpu_startup_entry
      1.41            +0.0        1.43        perf-profile.calltrace.cycles-pp.__pick_next_task.__schedule.schedule_idle.do_idle.cpu_startup_entry
      0.75            +0.0        0.77        perf-profile.calltrace.cycles-pp._raw_spin_lock.raw_spin_rq_lock_nested.__schedule.schedule_idle.do_idle
      0.92            +0.0        0.94        perf-profile.calltrace.cycles-pp.raw_spin_rq_lock_nested.__task_rq_lock.try_to_wake_up.autoremove_wake_function.__wake_up_common
      0.75            +0.0        0.78        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_sync_key
      0.53            +0.0        0.56        perf-profile.calltrace.cycles-pp.prepare_to_wait_event.anon_pipe_read.vfs_read.ksys_read.do_syscall_64
      1.11            +0.0        1.14        perf-profile.calltrace.cycles-pp.pick_task_fair.pick_next_task_fair.__pick_next_task.__schedule.schedule
      0.91            +0.0        0.94        perf-profile.calltrace.cycles-pp._raw_spin_lock.raw_spin_rq_lock_nested.__task_rq_lock.try_to_wake_up.autoremove_wake_function
      1.00            +0.0        1.03        perf-profile.calltrace.cycles-pp.__task_rq_lock.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_sync_key
      1.23            +0.0        1.26        perf-profile.calltrace.cycles-pp.mutex_unlock.anon_pipe_write.vfs_write.ksys_write.do_syscall_64
      1.39            +0.0        1.43        perf-profile.calltrace.cycles-pp.do_perf_trace_sched_wakeup_template.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_sync_key
      0.80            +0.0        0.83        perf-profile.calltrace.cycles-pp.llist_reverse_order.__flush_smp_call_function_queue.flush_smp_call_function_queue.do_idle.cpu_startup_entry
      0.98            +0.0        1.02        perf-profile.calltrace.cycles-pp.perf_tp_event.do_perf_trace_sched_wakeup_template.try_to_wake_up.autoremove_wake_function.__wake_up_common
      1.49            +0.0        1.53        perf-profile.calltrace.cycles-pp.pthread_sigmask
      1.26            +0.0        1.30        perf-profile.calltrace.cycles-pp.update_load_avg.dequeue_entity.dequeue_entities.dequeue_task_fair.try_to_block_task
      0.70            +0.0        0.74        perf-profile.calltrace.cycles-pp.wakeup_preempt.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_sync_key
      0.51            +0.0        0.56        perf-profile.calltrace.cycles-pp.check_preempt_wakeup_fair.wakeup_preempt.try_to_wake_up.autoremove_wake_function.__wake_up_common
      3.54            +0.1        3.60        perf-profile.calltrace.cycles-pp.__pick_next_task.__schedule.schedule.anon_pipe_read.vfs_read
      2.39            +0.1        2.45        perf-profile.calltrace.cycles-pp.pick_next_task_fair.__pick_next_task.__schedule.schedule.anon_pipe_read
      1.40            +0.1        1.48        perf-profile.calltrace.cycles-pp.__smp_call_single_queue.ttwu_queue_wakelist.try_to_wake_up.autoremove_wake_function.__wake_up_common
      1.84            +0.1        1.92        perf-profile.calltrace.cycles-pp.ttwu_queue_wakelist.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_sync_key
      4.10            +0.1        4.20        perf-profile.calltrace.cycles-pp.dequeue_entity.dequeue_entities.dequeue_task_fair.try_to_block_task.__schedule
      4.92            +0.1        5.02        perf-profile.calltrace.cycles-pp.dequeue_entities.dequeue_task_fair.try_to_block_task.__schedule.schedule
      5.08            +0.1        5.19        perf-profile.calltrace.cycles-pp.try_to_block_task.__schedule.schedule.anon_pipe_read.vfs_read
      5.02            +0.1        5.13        perf-profile.calltrace.cycles-pp.dequeue_task_fair.try_to_block_task.__schedule.schedule.anon_pipe_read
      1.53            +0.1        1.65        perf-profile.calltrace.cycles-pp.update_load_avg.enqueue_entity.enqueue_task_fair.enqueue_task.ttwu_do_activate
      7.44            +0.1        7.58        perf-profile.calltrace.cycles-pp.intel_idle.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
      3.36            +0.2        3.53        perf-profile.calltrace.cycles-pp.enqueue_entity.enqueue_task_fair.enqueue_task.ttwu_do_activate.sched_ttwu_pending
      5.06            +0.2        5.28        perf-profile.calltrace.cycles-pp.__schedule.schedule_idle.do_idle.cpu_startup_entry.start_secondary
      5.16            +0.2        5.38        perf-profile.calltrace.cycles-pp.schedule_idle.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      4.24            +0.2        4.46        perf-profile.calltrace.cycles-pp.enqueue_task_fair.enqueue_task.ttwu_do_activate.sched_ttwu_pending.__flush_smp_call_function_queue
      0.25 ±100%      +0.3        0.52        perf-profile.calltrace.cycles-pp.syscall
      4.47            +0.3        4.75        perf-profile.calltrace.cycles-pp.enqueue_task.ttwu_do_activate.sched_ttwu_pending.__flush_smp_call_function_queue.flush_smp_call_function_queue
     24.62            +0.3       24.91        perf-profile.calltrace.cycles-pp.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_sync_key.anon_pipe_write
     24.68            +0.3       24.97        perf-profile.calltrace.cycles-pp.autoremove_wake_function.__wake_up_common.__wake_up_sync_key.anon_pipe_write.vfs_write
     14.61            +0.3       14.93        perf-profile.calltrace.cycles-pp.__schedule.schedule.anon_pipe_read.vfs_read.ksys_read
     15.07            +0.3       15.40        perf-profile.calltrace.cycles-pp.schedule.anon_pipe_read.vfs_read.ksys_read.do_syscall_64
     25.98            +0.3       26.31        perf-profile.calltrace.cycles-pp.__wake_up_common.__wake_up_sync_key.anon_pipe_write.vfs_write.ksys_write
     26.13            +0.3       26.47        perf-profile.calltrace.cycles-pp.__wake_up_sync_key.anon_pipe_write.vfs_write.ksys_write.do_syscall_64
     21.40            +0.4       21.84        perf-profile.calltrace.cycles-pp.anon_pipe_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     29.54            +0.4       29.98        perf-profile.calltrace.cycles-pp.anon_pipe_write.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
     29.93            +0.5       30.38        perf-profile.calltrace.cycles-pp.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
     30.32            +0.5       30.78        perf-profile.calltrace.cycles-pp.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
     22.36            +0.5       22.82        perf-profile.calltrace.cycles-pp.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
     22.50            +0.5       22.96        perf-profile.calltrace.cycles-pp.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +0.6        0.55        perf-profile.calltrace.cycles-pp.enqueue_task.try_to_wake_up.autoremove_wake_function.__wake_up_common.__wake_up_sync_key
     57.94            +0.9       58.84        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
     58.04            +0.9       58.95        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
      6.91            -1.1        5.81        perf-profile.children.cycles-pp.ttwu_do_activate
      7.97            -1.0        6.93        perf-profile.children.cycles-pp.sched_ttwu_pending
      9.17            -1.0        8.15        perf-profile.children.cycles-pp.__flush_smp_call_function_queue
     27.49            -0.7       26.74        perf-profile.children.cycles-pp.do_idle
      8.83            -0.7        8.09        perf-profile.children.cycles-pp.flush_smp_call_function_queue
     27.41            -0.7       26.67        perf-profile.children.cycles-pp.start_secondary
     27.52            -0.7       26.78        perf-profile.children.cycles-pp.common_startup_64
     27.52            -0.7       26.78        perf-profile.children.cycles-pp.cpu_startup_entry
      1.28            -0.3        0.96        perf-profile.children.cycles-pp.asm_sysvec_call_function_single
      1.12            -0.3        0.81        perf-profile.children.cycles-pp.sysvec_call_function_single
      1.04            -0.3        0.75        perf-profile.children.cycles-pp.__sysvec_call_function_single
      1.29            -0.2        1.10        perf-profile.children.cycles-pp.__switch_to
      0.59            -0.2        0.42 ±  3%  perf-profile.children.cycles-pp.__switch_to_asm
     11.72            -0.1       11.61        perf-profile.children.cycles-pp.cpuidle_idle_call
     10.96            -0.1       10.85        perf-profile.children.cycles-pp.cpuidle_enter_state
     10.98            -0.1       10.88        perf-profile.children.cycles-pp.cpuidle_enter
      0.71            -0.1        0.62        perf-profile.children.cycles-pp.nohz_run_idle_balance
      1.57            -0.1        1.52        perf-profile.children.cycles-pp.restore_fpregs_from_fpstate
      1.28            -0.0        1.23        perf-profile.children.cycles-pp.finish_task_switch
      0.62            -0.0        0.60        perf-profile.children.cycles-pp.__update_load_avg_se
      0.33            -0.0        0.31        perf-profile.children.cycles-pp.place_entity
      0.27            -0.0        0.25        perf-profile.children.cycles-pp.__task_pid_nr_ns
      0.28            -0.0        0.26        perf-profile.children.cycles-pp.__x64_sys_getpid
      0.59            -0.0        0.57        perf-profile.children.cycles-pp.propagate_entity_load_avg
      0.34            +0.0        0.35        perf-profile.children.cycles-pp.menu_select
      0.38            +0.0        0.39        perf-profile.children.cycles-pp.sched_clock
      0.24            +0.0        0.25        perf-profile.children.cycles-pp.__wrgsbase_inactive
      0.06            +0.0        0.07        perf-profile.children.cycles-pp.dl_server_update
      0.98            +0.0        1.00        perf-profile.children.cycles-pp.hrtimer_start_range_ns
      0.20            +0.0        0.21        perf-profile.children.cycles-pp.asm_sysvec_reschedule_ipi
      0.66            +0.0        0.68        perf-profile.children.cycles-pp.syscall
      0.38            +0.0        0.40        perf-profile.children.cycles-pp.put_prev_entity
      1.44            +0.0        1.46        perf-profile.children.cycles-pp.set_next_entity
      0.81            +0.0        0.83        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.33            +0.0        0.35        perf-profile.children.cycles-pp.__pick_eevdf
      0.41            +0.0        0.43        perf-profile.children.cycles-pp.avg_vruntime
      0.96            +0.0        0.98        perf-profile.children.cycles-pp.wake_affine
      0.55            +0.0        0.57        perf-profile.children.cycles-pp.prepare_to_wait_event
      1.73            +0.0        1.76        perf-profile.children.cycles-pp.update_rq_clock
      0.90            +0.0        0.93        perf-profile.children.cycles-pp.llist_reverse_order
      0.45            +0.0        0.47        perf-profile.children.cycles-pp.update_entity_lag
      0.34 ±  2%      +0.0        0.36        perf-profile.children.cycles-pp.update_min_vruntime
      0.36            +0.0        0.39        perf-profile.children.cycles-pp.requeue_delayed_entity
      1.41            +0.0        1.44        perf-profile.children.cycles-pp.switch_mm_irqs_off
      1.00            +0.0        1.03        perf-profile.children.cycles-pp.__task_rq_lock
      0.35            +0.0        0.38 ± 11%  perf-profile.children.cycles-pp.copy_page_from_iter
      0.84            +0.0        0.87        perf-profile.children.cycles-pp.wakeup_preempt
      0.76            +0.0        0.80        perf-profile.children.cycles-pp.prepare_task_switch
      1.33            +0.0        1.36        perf-profile.children.cycles-pp.pick_task_fair
      1.64            +0.0        1.68        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      1.40            +0.0        1.44        perf-profile.children.cycles-pp.do_perf_trace_sched_wakeup_template
      0.98            +0.0        1.03        perf-profile.children.cycles-pp.perf_tp_event
      1.91            +0.0        1.95        perf-profile.children.cycles-pp.update_se
      3.06            +0.0        3.11        perf-profile.children.cycles-pp.raw_spin_rq_lock_nested
      0.53            +0.0        0.58        perf-profile.children.cycles-pp.check_preempt_wakeup_fair
      0.63            +0.0        0.68        perf-profile.children.cycles-pp.__update_load_avg_cfs_rq
      0.21            +0.0        0.26        perf-profile.children.cycles-pp.attach_entity_load_avg
      1.80            +0.1        1.86        perf-profile.children.cycles-pp.pthread_sigmask
      1.72            +0.1        1.78        perf-profile.children.cycles-pp.entry_SYSCALL_64
      0.35            +0.1        0.41 ±  3%  perf-profile.children.cycles-pp.cpuacct_charge
      1.41            +0.1        1.48        perf-profile.children.cycles-pp.__smp_call_single_queue
      1.84            +0.1        1.92        perf-profile.children.cycles-pp.ttwu_queue_wakelist
      4.03            +0.1        4.12        perf-profile.children.cycles-pp.pick_next_task_fair
      5.22            +0.1        5.32        perf-profile.children.cycles-pp.__pick_next_task
      4.41            +0.1        4.51        perf-profile.children.cycles-pp.dequeue_entity
      2.98            +0.1        3.09        perf-profile.children.cycles-pp.update_curr
      5.09            +0.1        5.20        perf-profile.children.cycles-pp.try_to_block_task
      3.94            +0.1        4.05        perf-profile.children.cycles-pp.enqueue_entity
      5.03            +0.1        5.14        perf-profile.children.cycles-pp.dequeue_task_fair
      5.49            +0.1        5.61        perf-profile.children.cycles-pp.dequeue_entities
      7.47            +0.1        7.62        perf-profile.children.cycles-pp.intel_idle
      5.11            +0.2        5.26        perf-profile.children.cycles-pp.enqueue_task_fair
      4.37            +0.2        4.54        perf-profile.children.cycles-pp.update_load_avg
      5.21            +0.2        5.43        perf-profile.children.cycles-pp.schedule_idle
      5.86            +0.3        6.13        perf-profile.children.cycles-pp.enqueue_task
     24.68            +0.3       24.98        perf-profile.children.cycles-pp.autoremove_wake_function
     24.64            +0.3       24.94        perf-profile.children.cycles-pp.try_to_wake_up
     25.98            +0.3       26.32        perf-profile.children.cycles-pp.__wake_up_common
     26.14            +0.3       26.48        perf-profile.children.cycles-pp.__wake_up_sync_key
     15.53            +0.4       15.89        perf-profile.children.cycles-pp.schedule
     30.13            +0.4       30.53        perf-profile.children.cycles-pp.vfs_write
     30.55            +0.4       30.96        perf-profile.children.cycles-pp.ksys_write
     21.46            +0.4       21.90        perf-profile.children.cycles-pp.anon_pipe_read
     29.64            +0.4       30.08        perf-profile.children.cycles-pp.anon_pipe_write
     22.38            +0.5       22.83        perf-profile.children.cycles-pp.vfs_read
     22.51            +0.5       22.98        perf-profile.children.cycles-pp.ksys_read
     20.24            +0.6       20.82        perf-profile.children.cycles-pp.__schedule
      0.07            +0.6        0.68        perf-profile.children.cycles-pp.mm_cid_get
     62.50            +1.0       63.46        perf-profile.children.cycles-pp.do_syscall_64
     62.74            +1.0       63.70        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      3.47            -0.3        3.17        perf-profile.self.cycles-pp.__schedule
      1.26            -0.2        1.06        perf-profile.self.cycles-pp.__switch_to
      0.58            -0.2        0.42 ±  3%  perf-profile.self.cycles-pp.__switch_to_asm
      0.63            -0.1        0.56        perf-profile.self.cycles-pp.nohz_run_idle_balance
      1.57            -0.1        1.52        perf-profile.self.cycles-pp.restore_fpregs_from_fpstate
      0.81            -0.0        0.77        perf-profile.self.cycles-pp.finish_task_switch
      0.58            -0.0        0.56        perf-profile.self.cycles-pp.__update_load_avg_se
      0.19 ±  2%      -0.0        0.17 ±  2%  perf-profile.self.cycles-pp.place_entity
      0.26            -0.0        0.24        perf-profile.self.cycles-pp.__task_pid_nr_ns
      0.57            -0.0        0.55        perf-profile.self.cycles-pp.propagate_entity_load_avg
      0.07            -0.0        0.06        perf-profile.self.cycles-pp.try_to_block_task
      0.26            +0.0        0.27        perf-profile.self.cycles-pp.menu_select
      0.46            +0.0        0.47        perf-profile.self.cycles-pp.task_h_load
      0.35            +0.0        0.36        perf-profile.self.cycles-pp.os_xsave
      0.78            +0.0        0.80        perf-profile.self.cycles-pp.vfs_read
      0.35            +0.0        0.36        perf-profile.self.cycles-pp.setitimer
      0.39            +0.0        0.41        perf-profile.self.cycles-pp.avg_vruntime
      0.28            +0.0        0.30        perf-profile.self.cycles-pp.__pick_eevdf
      0.79            +0.0        0.81        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.90            +0.0        0.92        perf-profile.self.cycles-pp.llist_reverse_order
      0.76            +0.0        0.78        perf-profile.self.cycles-pp.try_to_wake_up
      0.44            +0.0        0.47        perf-profile.self.cycles-pp.prepare_to_wait_event
      0.53            +0.0        0.56        perf-profile.self.cycles-pp.flush_smp_call_function_queue
      0.32 ±  2%      +0.0        0.35        perf-profile.self.cycles-pp.update_min_vruntime
      0.58            +0.0        0.61        perf-profile.self.cycles-pp.prepare_task_switch
      1.34            +0.0        1.37        perf-profile.self.cycles-pp.switch_mm_irqs_off
      0.66            +0.0        0.68        perf-profile.self.cycles-pp.update_curr
      0.43            +0.0        0.46        perf-profile.self.cycles-pp.pick_next_task_fair
      0.79            +0.0        0.83        perf-profile.self.cycles-pp.perf_tp_event
      1.61            +0.0        1.65        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      1.30            +0.0        1.34        perf-profile.self.cycles-pp.__wake_up_common
      1.25            +0.0        1.29        perf-profile.self.cycles-pp.anon_pipe_write
      2.00            +0.0        2.05        perf-profile.self.cycles-pp._raw_spin_lock
      0.92            +0.0        0.96        perf-profile.self.cycles-pp.do_syscall_64
      0.55            +0.0        0.59        perf-profile.self.cycles-pp.switch_fpu_return
      0.21            +0.0        0.26        perf-profile.self.cycles-pp.attach_entity_load_avg
      0.68            +0.1        0.73        perf-profile.self.cycles-pp.enqueue_task_fair
      0.61            +0.1        0.66        perf-profile.self.cycles-pp.__update_load_avg_cfs_rq
      0.34            +0.1        0.40 ±  2%  perf-profile.self.cycles-pp.cpuacct_charge
      0.76            +0.1        0.83        perf-profile.self.cycles-pp.__smp_call_single_queue
      0.38            +0.1        0.47        perf-profile.self.cycles-pp.enqueue_task
      2.21            +0.1        2.33        perf-profile.self.cycles-pp.update_load_avg
      7.47            +0.1        7.61        perf-profile.self.cycles-pp.intel_idle
      0.06 ±  7%      +0.6        0.67        perf-profile.self.cycles-pp.mm_cid_get





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


