Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 338D6D26D94
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 18:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 985336B0005; Fri,  9 Jan 2026 13:43:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 932316B0089; Fri,  9 Jan 2026 13:43:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B5426B008A; Fri,  9 Jan 2026 13:43:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 680066B0005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:43:18 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 297215A818
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 18:43:18 +0000 (UTC)
X-FDA: 84313298076.30.FA39227
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id 14ED114000B
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 18:43:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Kw7c7dyW;
	spf=pass (imf23.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767984194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1XkGxRnFIdgW9GUV1PG2rqjzBIL1bNCyLVX7X3brB4g=;
	b=B3YA9YZA8rGRYHIO/MzafxkrHv0tnpC3FKryB+ob0v+gyw9wC2xiAUeRzWDZ4TKbekIeXX
	5UcwKqcUhKmrYVDZPnOMHrmpdz9osEHx5mJXDvgTQUebc1okUpJXh2HFoP3eOHFCksVyjq
	ScG0JW9Qddf9eRlgqIPkGdauEALzaUY=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Kw7c7dyW;
	spf=pass (imf23.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767984194; a=rsa-sha256;
	cv=fail;
	b=L2Ca5W3bkAfDFcbrRaldKWVTaFcDxhV/3GJE+gPeAXfELmxYTS2SYbbk4EGBBnWtEQiM6E
	Jceb8lqdPP0ybGLl+wA+VCAJvksdak0M3upSR/rZMrWj68n57CO5vSXAdwQpPfFJFnvHwv
	8Xqi6LJj0x9nyEpwg2Te4aAIJ/rSYhQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767984194; x=1799520194;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tgCMNA0NeZkn0AbXoQtuOWznpBxmCFVSqq0N96axEOM=;
  b=Kw7c7dyWpcMa037zWM32/wuuXNriTx16jg1jraU5F9f3f5roWOtKKg21
   +LRsC19BBpglUzX0dhvTRVLL379ZIhT7IngJ73JH/w1ncguYhRz65rx8H
   TZnvF2XBmlIGkVh7eEBcvMbS1JBsQM56pqc9zt3S4V9bLC3Rn9wPdGEeS
   OEMbNNfMUFuaHToSImRj2Q+Amdi7Jf25z/96zNz5S+CsPqNXFXyAlRImS
   phAW2i6C/APaSuo4q1K/GUGb+uNEB3kX2Pm6Ld1m8hvAOoETekGsy4nax
   YYvKv2E5ru9rGz0hmMbw24ozfuzwhoXVtO/0a1PpiBgvBdXa9PV0JfZub
   A==;
X-CSE-ConnectionGUID: fS0OToUGSeO+W59nWMae/Q==
X-CSE-MsgGUID: wsKhfmt3SHyqVyKz3+ig+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="86787466"
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="86787466"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 10:43:12 -0800
X-CSE-ConnectionGUID: 6HnkSnpETouSYNUeKNuC6w==
X-CSE-MsgGUID: 1dAwbipiTySAFJKOkP0JaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="203546255"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 10:43:12 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 10:43:12 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 9 Jan 2026 10:43:12 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.35) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 10:43:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fHYsForb7X2dcrRxdEnfkCDxACW1dI/PfxbEOA7ck4W031Vz97eKhpY7HAbqxwpGDk0o1TrrWP1+cXDUoxd05GCRX4DAp9nj/Fz9uQzM2dgoWztpbMtHA29G64Y7g/LtpJ0Ccto07WxiukJCkTybvVJyAftRe4EMXVgulg9Hn1QLYP9TidfttxAcrWdItNabKe1fj7ok68CIwSJvQc+deq+BpcWy46Ur8I12dzBCYR2qnovdnvrFLWy048NdAWuIeC9cZxgcI5MFj+4GKWFyYJlsXLOWWAs6bLUEpbHT3Lkc7ZTQpsWZrKRaAmzZwLxLaOWU79kOX2UDRxGh+6qDzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1XkGxRnFIdgW9GUV1PG2rqjzBIL1bNCyLVX7X3brB4g=;
 b=bJjfLRjD+5h2qlltAZN0BuMFqhq/1G9odbtjunGrgz8f0G8VxUOQ5qtAR9vWk5dITIYYb3OeeJi6ifxnOgi/5YcAJglTJCQ8C+VJY8/evkbuGiUjUzmuF4odChPGq+zU7z2XbXvwmkOdSfJdo2gyMbqjQ1EfHYyjuRSSQqT/pES3CfjFznvpjQUKCipgU//R+Gg4IAWBwMJsEl/R2DWaeGIirBWv0upEoS4rNszT0Vjmwn57/GXOqJoktngutNxkc6X4QRsLUhzVFgh2abZA7ZSR/QYRXAMiyUlkH6da8giWwOXxbj8einekFgpXArblxIC9y+rqDZphgf/vR5NLJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by DM4PR11MB7327.namprd11.prod.outlook.com (2603:10b6:8:105::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Fri, 9 Jan
 2026 18:43:09 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9456.015; Fri, 9 Jan 2026
 18:43:09 +0000
Date: Fri, 9 Jan 2026 10:43:06 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "David Hildenbrand (Red Hat)" <david@kernel.org>, Francois Dugast
	<francois.dugast@intel.com>, <intel-xe@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, Balbir Singh <balbirs@nvidia.com>,
	"Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Alistair Popple <apopple@nvidia.com>
Subject: Re: [PATCH v3 1/7] mm: Add folio_split_unref helper
Message-ID: <aWFMOvGldokHHgIn@lstrano-desk.jf.intel.com>
References: <20260109085605.443316-1-francois.dugast@intel.com>
 <20260109085605.443316-2-francois.dugast@intel.com>
 <59fb1669-2908-4cab-b3c0-b97479da3fb9@kernel.org>
 <20260109103741.533c1b807f3ccf9a6f0264de@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260109103741.533c1b807f3ccf9a6f0264de@linux-foundation.org>
X-ClientProxiedBy: SJ0PR03CA0297.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::32) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|DM4PR11MB7327:EE_
X-MS-Office365-Filtering-Correlation-Id: bf94485e-9d4e-439d-da9c-08de4faeef79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?iqczwwGHWGp1YwR+ngbM58oITF9QJAKlUK7CEuJT6Od3vRWvfl39zYUgITNP?=
 =?us-ascii?Q?5hk/25XBH8wEsaNJnAt59AHOZdmhyM0nJp4bpnGxP5+9ASinnJbhgEsMVznI?=
 =?us-ascii?Q?0u2OcyJXAwHIT9JNJSaZlePy7vMH0SRGdm3aba6KWLAjM4fSXQhTY8Yaff1A?=
 =?us-ascii?Q?gQnFVXIbbOP9VSNlMrVTKu4mth95SnrV0cUzytSanvfWpulmk35+ytGzMkc9?=
 =?us-ascii?Q?HsACusgSOnhwL7G8122OEutziZCHdPeXUsFcIA0sK4chfH5T0R6c3qyz1UsA?=
 =?us-ascii?Q?Q7NLEY8cM/dEwWdqOScuWlzBxlRgnE+5Fs/oHHqsfnwJkBLdWdD6X2ufizWb?=
 =?us-ascii?Q?ZwmCHjXc8XPNDAFKU12c6nPKKUr61/6TPBFesqbbzWUJCnxY3Nz1ZO2WBw/8?=
 =?us-ascii?Q?7KC3Ho8SVJOJzAjl+q0buJAmgVWqJf4mWj8iTko302sfECoRheHOcnWlUesD?=
 =?us-ascii?Q?K+cyObgRWW0HJkjpdYgvClL2FD/wKV8ZKiGyYGiwZkOX5Iimbm6a0nhhGGAB?=
 =?us-ascii?Q?aLun2UpCPPLFxV47hxJOvTDlSXNi0AVVjU5qTNYtiVVG1LhYsUzF6P//rgIQ?=
 =?us-ascii?Q?Z3LxToqapULlwU6Inn/+1MTF+IPnZ39yBnDqMq9a5NJBupZSHFTA2AHv/ZZZ?=
 =?us-ascii?Q?IgJDKs6896pUkiVxtE3Cx2n65tWoydzkWA4U7bPXCmOZEHh2pQAHsD9Lal1w?=
 =?us-ascii?Q?dhUy2kdRJZq9K8LURAf/mDF2tcLHjbc/fwypJgwyZuwxBOKCtwfjW+xr4V7h?=
 =?us-ascii?Q?TiiWl63AXN22L1xWxwoHiVHTIoqvMmkMT1nO5xN953pplnGMaaBfuhOkUcrl?=
 =?us-ascii?Q?tCqKKDwjkouAazoU0+Q7LgydPEzafnE8x1Oovg+90yMOq0Y9pnL2vDBsLohl?=
 =?us-ascii?Q?6rOBAA70IzgObKuZTNXuZ9tnNy8DEfBr0jsUza9nYGHhLOVvN+XmgxxqOUy6?=
 =?us-ascii?Q?DCRtT2OjMGkc0kaMwrGp1Si4xDfEc/pqY8WAZhXNpQh6T6DPfUJzK0MvRCJv?=
 =?us-ascii?Q?t479fXCnmp/en8FOurbE4EYHLCZFlJH3pE9dEiVW7Ge14IwYAEGdJnUhYbfu?=
 =?us-ascii?Q?xL+jOgKd5cSO7BFPbrRo9pD4o3lX23CDRhOSvPD8iWrAi6G1diEbhAAedIPn?=
 =?us-ascii?Q?gw75Sh66qy5zZa9IswdTnSrUZDbr5m0fMcmztLzfj/Ec6JjRxY3os0XgT7me?=
 =?us-ascii?Q?WRJyRnJptnF+C5h9Y6itHpUEmMe4YY+S8Wy/TRGoJG9DpmXUZU3le5+0EFeR?=
 =?us-ascii?Q?hnTxygUg8jrz4KK5fWUaF1iVQTcXh+KZWkvFhYAZ6+E40eVA2zL+VKRXOhcP?=
 =?us-ascii?Q?M+wPF6QhL8VFzBGku568JsNdYguR7kK70p0Ae8oqmhpIUMfLLLFSzB7FVosU?=
 =?us-ascii?Q?WKDemOOHfa4RQkfrasypR/WZMhyzmUbuyCPyYFoUJKQp+PWv7g=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V5v4rLkUdNy8PhRobWGDqd7kyuZFOBtYYY4meHBS3C9fbLb17R+95IxRcGAo?=
 =?us-ascii?Q?QAkMc93g54NBh4a4XgZd7S/oPN2D+WvUjqwc72g69Ic46Jr82ks/JL4wkl8m?=
 =?us-ascii?Q?h2w/ANR4CXHXZhDvY9+nUO0K1TWEIHbYBTjR3BX0cQD1DYhE/s9mqK7dX8OU?=
 =?us-ascii?Q?wWfhtfFm5+WK7F2ZzOdIM1+9ah31/QsghghuVKf2tFXfZzO8Yqg0KFXvVvq/?=
 =?us-ascii?Q?prFknYVmNHejOSqbWoqOFbd6/jSMOw9IUj/HY7KIQIIN8emDVMwbQO0455Wf?=
 =?us-ascii?Q?K/sGDzvixMT/zESo2C3ecfy9tL21MX/D/Mwn4beJqi7mVnBrVszfU+Guj3uf?=
 =?us-ascii?Q?cVrBbUJjXqThUH2sashqz+0esKbkYYvKeQku5b6bYwTM8BK4zcTkBvTImJ0y?=
 =?us-ascii?Q?mRGPhiPpwVeZ26HwVdq1ASWE0TQ7RyFEggxzHN5SLjl5S1zaMzDick7p8syk?=
 =?us-ascii?Q?RIJJTvs82+Lu2YDAp9NwikJwqyZ2ya1Iu08vv7aBU/XIGIQZ2c5hTdk8sFqe?=
 =?us-ascii?Q?h9rqg0ma7GHhm+YBuD8N8Br3GLqJnxwEqdN+P3Kt1ddRFYwdJe4p+U4XQIe4?=
 =?us-ascii?Q?Ocj/WgF6hRGuhBFDWjgHryjPwon5HQhSLE2UeynmgriQGn1ffGkLc7BKpSZr?=
 =?us-ascii?Q?uD/4MtwUyP5Q5Y8aeG87XQNCUyc1WOWh5uI2/CaR/7Hr+vcpUbwIOc8OKhSh?=
 =?us-ascii?Q?uDXCJQxpirLUL0FHe/rtVLyFIsrm5oq11CZEUGpHJGoZkmRk8z/8PtJ/DgMN?=
 =?us-ascii?Q?aGDFfdvo9/QnVmVMR76zGpFk0moB+7XshpdROqGbPkWmSsWhsNqEObSunws8?=
 =?us-ascii?Q?bssvN69+aUD3MXevwZ+82QMxqrgpWr0wkuOC5Bz+JxUIHDRMMMea0RB8blNo?=
 =?us-ascii?Q?mo847O4+iyCY3f4ph5RfuhAsVGcDVZ1ZvZTrfBIiiws8tzDWXcTIG9oQr3Hi?=
 =?us-ascii?Q?2PzDxB3ZHoM+xgqgG0yns8qVG0bjkr0m2DTavc0YJuwjHfmk0xVdong3SVFi?=
 =?us-ascii?Q?sQhngWJzWzNSJGqSHTGLuLLb/l08LPPNR1AFKQ41/HLc4Lh2in1P+wCHRKaW?=
 =?us-ascii?Q?6t5kPiiNhKw3s0wzl+sVGYT0WEdhXHtmnit6dHVoRZ2o9qLFmgL52SLqwik3?=
 =?us-ascii?Q?q8BxpCx3aDsnQdrEC25RkcxiSUfqpVUELtD2Mtb4I2EKfTCOKd5wWq9HpWZM?=
 =?us-ascii?Q?ktMJ2Im58+frOc2bOsljKF0qp9Pp2akxAgSsNX+l73qmlfLQC1Ri1wDnFA22?=
 =?us-ascii?Q?zF4xSP90T5lskKbuDdgGFRJ90yDQJvw5MkujQEF4yLxuKPrTm7YLcxoH5HyU?=
 =?us-ascii?Q?9ysX4oc9Gxkj78aOVgGVpc6k++HBo38KncaC2YF2y54g/50qNa4vNSMDpoBc?=
 =?us-ascii?Q?vziTUyxKQSi28yHzqnATavQBDTTzkJJGndL1bwyv1kQnd2lplqBo+rLS4LVv?=
 =?us-ascii?Q?Ss6GnStopqfqU2a1J46kWvw5/L6Oxhxe0sKLE05RVwNB9tPQZaiir4+5dBiW?=
 =?us-ascii?Q?9CVGNBBQFxlk+SsgZz42P+xydubJiBTJ6v+EB5h1nt9HiYtVS8lwEp5gfOIJ?=
 =?us-ascii?Q?XGGvor9UyE73J1P5v/B3+ZKC64tm60J9Z2Na1QqUn5EAYQO1y4ydxYPyabOZ?=
 =?us-ascii?Q?HX8skohYYZD4UP0qyvsdjGqHsQKCg4ZE4zK2+YjBTQgmv/jUHRr1CHwGpXqz?=
 =?us-ascii?Q?qwwucenqabKNR/H6CFg9YpBWHahVdRjMXr9IlIoKw0xFSXr6GTr/sk0633tX?=
 =?us-ascii?Q?TTCuBR+3yQBDvuk4AHf2p+mLXHiB+8M=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf94485e-9d4e-439d-da9c-08de4faeef79
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 18:43:09.4529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N2FIoIZEyV+3qXbbe9/OCAKGDJQy3aDTlrYuhQAECJ/E/oKxp//f6XvgeOIPx/bnPNUicXzn2mp1HBTRyEKjyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7327
X-OriginatorOrg: intel.com
X-Stat-Signature: mugfmmfarho4fb366d3mq9pbhz79zfsu
X-Rspam-User: 
X-Rspamd-Queue-Id: 14ED114000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1767984193-204861
X-HE-Meta: U2FsdGVkX18HJuyoyDzwW3+jf1IP4I9qz6FALjKGtqp+nCP7Jqna/WEADVRJXXpWMYRNpw2CsQb5YeL5gOBulnFow1tNHg71Fk4tOphXnvzwOsoPkEM+BaFXbDs4dxRkmEDHPpff6bweYEQyfs8vhGeXJJOqklF39yVgV9YMKu95/nqqGcPjp0gwtdhRSCk14FuSSVRaNoMT1RfiEsRNVlHvk1Qi+KXPZV0KZTJZ9svto2L9fEFAyqhdFJ9KfNrtmrAKukqDSDXdzXjvaUeJ6FN5FQHmRgygb6vsJ5QxKwTslZztvzZSGpe4xJWa0+0IPwsqNNyaIlfWigr7wCcxP8M/LhMs3c2WI9M0tlY8TpFYVz6yhANV3E+uk9pegu/7LYqFvvWRir1Zkr8k0x7fhRssf3FQ+MROA2sbIyAGECK91xDo4J3Ik4JuqI8mO8sCCpBfqAXegSObYjqbZBhyWu30cy6vMff3oahR98V1U4hBymW7MwMVNOxIZ4avyHOVOphJ3fXKFCOrBYPVH0hTR5si8bPT56DU9t/MelJvqLS7JvLbDnYi80c2ft12Rtyvy9x3+jzJCxq02K46XhFQFWs8uqtRjbznWw0gvSNRawbLZh7ZhQwzUUMEppuAHkeYkTt1qTvnktqy3Ddl751/f3gBeXzmnIlzXVk5Vc5tk5lVGsZfnOWdcR1H3oQeLNmlboohFG+PEtBLN0hR6ynTk6jkADlKWb4aSq65hf+XPEvmDSGfWkMjBP36qkD1EAl54F8AxfYa0Dtxd5BXrlFJgYF62PIt1FeJ5vn7lxqFwU1r2qlK8D5SAEzdaUub1NhXgusLZBKGQ0HCxxt3SEJZF5TRzqWJ0h6qvfWUxEAdVXVNqRo0l7JG3WFg9LfvgKnUNYUo376d8eTa157yesnGd3JTMSCZkgWOt5v4nrtee8r+70We+MvCCfbNnP319R6NwJ57UvXEByvVcMwDvr3
 +Kmrmo1d
 6Z/9ZYhtBb8saYDCt+WLgY9y+OuQlkcJLOqEUJQxWegMGgNNtW4lVNihBy19YeK6fRqWbNpVZXxUVyhb25foAmeecEAoXbiwTYPUg7TEOd9g5HOf3ADREySmr5nP2WRx3WsUBIiB5HzV8kGkPqRu2UfaFVXKgxKdnW7Uia+dvvBQ1cAcoN75nYC+MQnAhLzdTW+z/M1YveRS7CTzSkzgNRp6evKyp1MjPs/h1i/HE1ux3AsD/8Z5whh9FyQ7Rtgh36wqfdRuC043nMT9wnKgM+txkcB6tj7ZFQKzjg9bovKlSWGQTmM/AJttYwKGMS1LL4fZuUXUcmqAC88hnzDSnL7eokwaPc0SfnRMuXve3U1+QiywjaUwKiS2snD59opH8YKmHnPXgWk7f63LQoGwwbsZ8ZlKeZ7I5WnlqjX7iqr6i6TkON6Dwc9rMrM/dwRQOMm4t8OAya/I6a6CWojfY97zUe0R00vndjbsWn18CnPOJRoFHR8KVDIB0h+mb1M/mxTLDghvdY3RBw+tl+2Q3TzHnEHtfBhbc4nTg1DRlklrRbNdPYABgx66Ax8YWh/GLEO+Xt1X8QS1/SfGjN9n+dN6SUTzXcVNUubqEDZ3MSYaNuGc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 10:37:41AM -0800, Andrew Morton wrote:
> On Fri, 9 Jan 2026 14:19:16 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:
> 
> > I'm not CCed on the other patches in the series or the cover letter, so 
> > I don't see the context.
> 
> Both linux-mm and I received a random subset of this series.  Something
> went wrong.

Apologies for the list workflow issues. Here is the link to the entire
series [1].

For future reference, when we submit core MM patches in a series, should
we CC linux-mm plus MM maintainers on all patches in the series, even
those that do not touch core MM?

Matt

[1] https://patchwork.freedesktop.org/series/159119/

