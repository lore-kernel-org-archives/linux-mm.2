Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8128D2D105
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 13:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BAB46B0005; Tue, 13 Jan 2026 08:58:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267E26B0089; Tue, 13 Jan 2026 08:58:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CB066B008A; Tue, 13 Jan 2026 08:58:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E26AB6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:58:06 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8423A1AB02
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:58:06 +0000 (UTC)
X-FDA: 84327094572.29.3018182
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf05.hostedemail.com (Postfix) with ESMTP id CD14E100004
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:58:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cDcSMs95;
	spf=pass (imf05.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768312683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vDGQm4xWkgCJSwJ9mhhp2/unyLYtkDLq/pPMJrjrm6o=;
	b=pdZfEEjMmUi+1d3vPGsUcpFy/CDUxl9UL1LD2s4H+v4Ms6F6TRQKsgsnp4Dxfh5GvxRMW3
	IpJ3M9vgtqMw5tJD0nJqPZ/ACKeQmm/0U8PZDEZA8QiMHUD+qbgCG+0+7PwgZUpcImGmKo
	ai0GZGTaNGbc0tei3HJDpZ3uaCTvUMU=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cDcSMs95;
	spf=pass (imf05.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768312683; a=rsa-sha256;
	cv=fail;
	b=2FJfkQNE2ZnphF+XcAhsDIDurQnidSSBk26RaeSJ4zto8z1SPu1Gh/LxoaQLyyEjPw9RZw
	7+6nv2/S4Te0WZccQ9qJefXJZvb2JgU88Bx3nqdkOlp+5GOBKAiHKIXIIKtJORFMe/F2QY
	a3FgJtKP1D/HFJs8kGhsDy9CnFA4ACk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768312682; x=1799848682;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=LCLMS7Rl6ad2bmSb9ZFl3tfwuXh03zmXWzMsyjASbuM=;
  b=cDcSMs95WAvVYTfzIs8xgpXWNB8yPIqioEeb5x4NNJTk98kBX45R5ulY
   2EGjRSnrI78gAV90qSLGGXypZkSRTX2gpCzodOIscox1BP4OPO8V3VCtj
   8q8sUj3w6LKMv9tOh5Cuf4gvQh0ADtw3q8JhGS1pe6CsCnRn4bBThNasX
   p7XkZqC4m30xbq6nANpVRVr75p9Yc39NUdFzit2qflGpFLYkQcodFjZ1U
   zDhpNAaDmq+3vj+PWLJDim4cAoeBZ8aNSXezZvKfogfUxGSDS6MJND+95
   a8GfPaXdsEz5G0qbt3QjOVYGfEKKokObnOkG/Qhl3h3OtKDLYwc8L2Y4X
   g==;
X-CSE-ConnectionGUID: tTLk4OA2TOmiS2EkB8NYlQ==
X-CSE-MsgGUID: OUCWOf1fTySAXTp42TFXBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="87178857"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="87178857"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 05:58:00 -0800
X-CSE-ConnectionGUID: 0aCJbA8KTq6eEVDDvdbY+A==
X-CSE-MsgGUID: ISZg38u8SxOzXqBp/XNngg==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 05:58:00 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 05:57:59 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 13 Jan 2026 05:57:59 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.5) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 05:57:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WZXXYdPRvvjT6xJ8KWq6SVp4bdXvSi9UVQ+ceXYDDxcMuZkPodWJ00NvhC6GTacTaT7V6pOfWfqDSV8p/R3WROMQ3OPGwSpvULepF2jWs2rDtEQxEBjOuuum1cRPBphACFZYOT2KjNloHLSKJ2agcK0J0RBgZCIBb4aA2hdq/jglPhcTWwuDcmvnX452NgkHSSA2ZKUQs8KqSOmL1OsyI+52Bmp3lFMlm0bD2QiEEM41y2bJO3Rdsuv8dygYG3ATrRtPUHraYV1bLG6ysMzq3NYFY3UgaXOeLUhrkWMBXvIp4r8gn5+Ro6yYlYx6iu3IgIsoM2VPoyyJYbhE2WwkHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6lXUrXvZQTPmswU98Ni469ZqyN1UPDM02+49lODDtpc=;
 b=QdjTkNWY0m316JCjX11SDPABPZZksSnTArqipC0vM75lCYOTzoS0IbpnLcQWstOZMokQIoRTYHtK8HlDAgYtmMXm0iFkUVbYel1188fj2jkb0EErkBp+8tmrZJFI6AlHfOW92EKkxUKgnPG1zLJqAFxUFyXm41uPstvU3FN6VonI4eonhMFz4u63J26uQqXYxk3mLyT975Ou1JjonEo2ktFpmadpV2mReU1wtas9c3gR9rj83MjVkHLYffmeNsUSOxIw56LW2E75VtH5uXDCvKkZ+E7wUj1ivL3qZrcc7fFhcZV7Hr1FdOmZxYs7ACzTyAthl7MosalDlNBF+V+pIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SN7PR11MB6828.namprd11.prod.outlook.com (2603:10b6:806:2a3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 13:57:56 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 13:57:56 +0000
Date: Tue, 13 Jan 2026 21:57:47 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [vbabka:b4/sheaves-for-all-rebased] [slab]  aa8fdb9e25:
 will-it-scale.per_process_ops 46.5% regression
Message-ID: <202601132136.77efd6d7-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: KU2P306CA0047.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3c::15) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SN7PR11MB6828:EE_
X-MS-Office365-Filtering-Correlation-Id: 4853c90f-d1cb-4edd-aa60-08de52abc0d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?1b+rH1jqFGZLc6+ndle4QhjYx2m6Ec5XA1fmCsDI9HSjmY5GMWwf+spOP+?=
 =?iso-8859-1?Q?zV41V1FpgBTcEBFrogwhguwA2kMxwjlXrBJISnEhmchpG/mNec/jVF7LlP?=
 =?iso-8859-1?Q?svDB33R1TEwvystMigyQfn25Jgq2c2Yndp5XyR4NujAHywyCBdxBDjMlQV?=
 =?iso-8859-1?Q?ecfelzuFh0a5C3c2jeGTJ7qMmy2DiA06aHWDZtQho26pguAqH59uLpPb40?=
 =?iso-8859-1?Q?wODrhMinuUkldwOaPSDiWwffKZqrr97Fg55mX/pgbjogyKC2DynStMBFcY?=
 =?iso-8859-1?Q?mv9r4LrgNNcknrS169XGWwsJ06iCmhtHOL43SW21BdiHA5eBRaHhFBnmuZ?=
 =?iso-8859-1?Q?LsRdpmiEtJJDaz3EGeqcaVY2bjzoQ0LACOP4X2Oy4sfAJgysJMHOv3sll1?=
 =?iso-8859-1?Q?0zE2e/xD3uc5sXQAcLOcdv1l/nnjOiZpNht2TIlL+jCmth8i6IurWovhFD?=
 =?iso-8859-1?Q?+7oN+BSbeveuiaj5bsqEWS7GFHOYZLbxlrSOlNCe6qnWOtP8eR+6bvtjWA?=
 =?iso-8859-1?Q?ib6P6suD2KYs5xzXy/F2OAAkCP6ALPUkVOmMmLzJYkzn66tjE90Fosh3yb?=
 =?iso-8859-1?Q?j8KzlziQdRFgzy9dp4UCH5oseC8pivq1FRJtry0ZNb14YGuepS6Lq+mGFb?=
 =?iso-8859-1?Q?z/tIXwQFGvFEg8YyLat8w9v9kJ5UWMxbS+AG5aHo+gbLICRlyzMF87beHe?=
 =?iso-8859-1?Q?2Uj7HSWdGKG6WR6zdnTW90DL5bZf2CA8xDc6lgyjZmSpTzBC+xVNPRMgFg?=
 =?iso-8859-1?Q?J2GsK7sp03eZUWLfVZFtiEmISVJQvv7hhnFsPdSW4boasSPQQOZxPJWNxq?=
 =?iso-8859-1?Q?t236r9gGskr3wtxuszGiXIstqmrmXMQ/imonZwNWwFBjMpyJqr5pgsgxh3?=
 =?iso-8859-1?Q?oKDvxNzQZ3KBMZwxawi1JSdgJowKJSf5CiizV3zdLWNSov625sWjG102XE?=
 =?iso-8859-1?Q?6BeSke1GL6tkO2OYLgecMES/o9HX2LkBzxN/PzWYvl60zWhjKkcGyB91/E?=
 =?iso-8859-1?Q?OiJE8uvaxwHw+coA14OWj4mssmbXy6bBSG1LqygGfUY0QG9jHtdU6ywJAN?=
 =?iso-8859-1?Q?AZy1YgnujrmksQ5ulK6oer1qquHHykclhxhuruzfFGjQpGNTDZTffmMj2R?=
 =?iso-8859-1?Q?R7wwcbYKg+GHoXT9/fFZVGnQQlA+8PTr+3lnLZtOcIYKKR52uj6BOBnGUG?=
 =?iso-8859-1?Q?iiSNwMbkwvaD3G4aMIjhk85VqfhkSup35HlbwqDU+gp6pVNUwNaRXTt1dO?=
 =?iso-8859-1?Q?q9zWXXX0OUWu8P9EIMraBFr+fVqIeLMlpaVJ3kbJaAtwAT2FqnZ5XWUTuF?=
 =?iso-8859-1?Q?YLD8CAJSBMsaCICqkjtfTVpUJQUVkEjopZEHL8x6z5broH6wum0NPBOCN9?=
 =?iso-8859-1?Q?c8mINgN5slduDujE3/4jSoZLQd7cB3VS1QdlRMb4SZBx/P6YRQRzhYIfVt?=
 =?iso-8859-1?Q?ixMsBet8aSpUDBJ29G8q5NRYHzGfQwXIszNFqcGpxhcdnfLzmCL7+1EchL?=
 =?iso-8859-1?Q?1BWjAVeumNOCmFvaoqjdUYKShQhrP4TE9in1YFtXbGYQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?vH6n9M0X7061JvA52yrLGrX+76z6xgFhrrtb1hSchCH5l8wxU8e4swDr5x?=
 =?iso-8859-1?Q?w2dx/X9bsTypnE2+lhG9+DaMvHXG4z4dETycWxyYXY12YoX6RJyPliCqNx?=
 =?iso-8859-1?Q?KnaKNb0REL4+DUjAplYt5uO7l8mUHKk4sTH9hvzoAVhQio7w4kXXKBFkgn?=
 =?iso-8859-1?Q?s5uZmI9Fb4oY3q8unJAdCTalL++35L1tvcK/ldRTHWnuOHl0CDHgmkhsHN?=
 =?iso-8859-1?Q?H7WYVi9Jp69Apn7hWdtN+C2qxohcjfAcgXiCu9ABUUG+l0MQCMB9uOzaPn?=
 =?iso-8859-1?Q?64ykRHTWsJHlJmxBVcSIaQYm4YlYhCLLbli63gOlw7wn3zlO3CBu1CZUcI?=
 =?iso-8859-1?Q?DL301W+GgeTyXKj8q9JksepqEJC6C2p90SRA1IrZsaeo54oKbHGzVVdfSw?=
 =?iso-8859-1?Q?sZr29LQ9ObxRvWU3d5KMv0OJflPfcC8hTok4lFxBdMqNOzHPzqVMgxEtjv?=
 =?iso-8859-1?Q?XWTMH7e1y8CRHWVJPwGI/qcuRWa3uM+992F94CZob0aop5u7TY2XDmpznb?=
 =?iso-8859-1?Q?xWkEXDYveMJxh34fNP3FWtoGZhmRCVVcY5ib1jWhQNcSwm6snhcuIvpoM5?=
 =?iso-8859-1?Q?bO41PeYy00JfkjVqtbn4pfXXWu+KsdOzJxn+5OhSvqOpMYLORRPsXE+6Tb?=
 =?iso-8859-1?Q?1pqoLVtmL0Kn4bd9zs2PZ29WRdfbG070r/Cl5mNrG+Tav0/3lCenOaokcl?=
 =?iso-8859-1?Q?+gVTejT1y2lq67I2KmqjxcIOfDlAXFNeMJyfpogpmSd/7eT8TRRJlQmNaT?=
 =?iso-8859-1?Q?5/Zlch8+3lwUeb8RiY9u5H0emBj7vQBKPtZKzCfxwxjIcs+9XUjdQNmIqs?=
 =?iso-8859-1?Q?16q47QWExmvIWyg5UEdNOzz5ghYTjh7sPAExlyFBVsP/3sQh5Mc22UdafZ?=
 =?iso-8859-1?Q?pVr4EgSMcLwd6IiQiETnLN5mihQ4+djCg1IGtPbp1az1aFdKwyXMDuj7hf?=
 =?iso-8859-1?Q?U+F1hr5c1Ru4wY0Q9nQLK5FLl2DQ1DNF67bEay/LGcIpI//HQ1gTtxpphY?=
 =?iso-8859-1?Q?K67BQ8aujNFFPDUdREdTXjqP4NszwjLN6Qr21YxKMSfOWhQwePi0IVizcS?=
 =?iso-8859-1?Q?1PK/KPPpuDv6hjoY0hSAuixWKkuOIKoJlEly61SeAeVMbB88Blu3BDghMy?=
 =?iso-8859-1?Q?dV1ePK3IBopMrCC+YTkXRGlI0Rlo/kpMfUXtpPG05RWxIRsu67Wxig4vlj?=
 =?iso-8859-1?Q?Sr/3A1ndvKi0T3vzP8yA2aEAaSSFp+TopSpWJRok3EYgrWp/3KRo9csLa3?=
 =?iso-8859-1?Q?PnA9o8VFsj/kjN9h9mBNJz0GPdBziZWng+YqB2wjOEx1yMgZnGugPJGaK5?=
 =?iso-8859-1?Q?/fOy1pBa0LpK6Y6oIRsg1J78/PSLrqknpAcK8Phov+UwCZpjUseS4Ihu/7?=
 =?iso-8859-1?Q?06DhhHtlS0QjCyc/pAIckxC8KVPT5nO2SsCUVVESP+Oi8+hlXvIsGbiqnn?=
 =?iso-8859-1?Q?GIKZYFXrDvajI3bqVCk5yancI5wRlrlUqoQyHoupqpuHTuBTn7faCx9NPh?=
 =?iso-8859-1?Q?NrmL71MHSlCzsIOY2J1qFJzOYpvJBU7nt6crL9NDiOcU7C/PwsNzhvuzj9?=
 =?iso-8859-1?Q?Pb+RPIErRoPoEfw3LkgWq1XTqwim1g+TmclJObqo0+tABav6NTKynanC2u?=
 =?iso-8859-1?Q?3O40s9oHu7zC8ck5Hp2CFhuJafDRS3IOKvkljX80vhM70k72eXPBiSQmLw?=
 =?iso-8859-1?Q?kAIUQ6m5R9POCdlJqPUQblDVkVhw+6gncbpWli6ibgKgMcOA000HXWQ1EP?=
 =?iso-8859-1?Q?PhDxi0z1idcTsSeh9kSNQm3ciEqoABp7//8kDa6dDbOj4ztQEH665YAfNl?=
 =?iso-8859-1?Q?veYxCrzrmw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4853c90f-d1cb-4edd-aa60-08de52abc0d3
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 13:57:56.7843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ka/gJxaIKUO/RkzTWRM07UxceB+LP8KtIs8p98M6bPlFnh0VnC8L3pzbw63UeH3h7J/5OwzmBLy0f2z7BxZDcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6828
X-OriginatorOrg: intel.com
X-Stat-Signature: t4f3ssgeyofbugtdnokt7dc1kn1sqmqa
X-Rspamd-Queue-Id: CD14E100004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768312681-521320
X-HE-Meta: U2FsdGVkX18z0R8NTnwurLq3sfTr4y3GKxY62kmB7MHIBD7jtkB/NKDMHCLP+aUl2w4AR49LqlM4yjGq8yGWViAQ3UoOWbo6RCNKIEKJHPxt8n6AhDe9OWwd09+d2+qgiT/yPiXrL9BcBcn0vVkEXtRWBKarqwhzEqOG2bo+w3K0W218h4jgcGfkSDd6QQB+Bv8kuKDQlg642lhreB0I0B2ybP+Z7y27ZGzv9Pl/UVkevgTivzSOctIu3E3OZX0xBkqseJgF/ex8OzYy6yVgQR9sG5Swi9qt0gOZoexX/nHvNo5Stj+NGVK5hql5mlGVzJ37A05HmfKa5BUuWklwDtyh5cldV2+3ysp7+WO3oCWkflQw5c1+p+KybXt3ZBKnAE+9OBmEEQTuDpmyHp1DI+SAL7COXGs6kx7a34Tyah0VZt+GW398k7U4gOEZYelm2z+fLR9hPdbvXXTk2cPhuT8s9HvBqhSjt0THwm87qb2r5OT+vBkJGgUC4ECtCFU8UCnRVWyjuhH1bE4F9WxUxsA4jo9hu/u0zc7DXgYd6vODFIivB6r6JwFeUpgT3uv+scsSgdjlye9+Adk4a1oMVHNa7hz4fAK0M90pGk00E5Ju2eoTaaWiqpV4Xqu2yP5UepizsCy0HmJPIXjJ6fXlKSeakA2lByaKUc0hAV8w2MZC8cwRxfBqK/t0JQWHLpdYWzl0bExzPT1/++FK4/GmomFeJAKLmVPQb2vEWl23/HeWSQiZQJKf71iV9oSz+1CZ7LcBMIIFEYLL9SChqLEFf8zPxJzXrs5bFOVPvZ8NdjxYyvm7xZ0pIxBsqqvkmumZ0wTMtVH18c5IWYzPDwQEfEQXzDUHimcm/kuJ0wecIGMkKqpI8hjfEYZYdK2/zWNrXZlHQz+tfTno3llud3zD5haTyGbGTq+3mmAuK2RMtQH+wsa+9qcfRgls99VS5ZsCpD14c+DARBuTEVMvr9N
 s1uFaQlE
 7TGC38+Ixgbx/ku9n77TuUh/ZKpaeddpS1Lc6sXzeYHvOQv6fcYEyfFLsy+zeP2GyikpXPPiT+4tJhUvwkXON0swH7106AhWnw1ltW6tmSMgdcu4iIY7plbn85NscFpJxGYNstd3VMaK0F8/K1cHHgoJedVrIwS0qbe5jIfFdhEGtW+cVZYvEIDKNRjhsSef7dn18T34IdiaaWL86x/KDYowa5nkLQKsGqehs+Vg7AWBF+MiRtrrNYONyGJI/PxNzeCC0rwaohXmdInWXWpoYiL7rry8b89o+5FrJ1CjKnNfOa/r9JVkJ9GPhcdng5tHBVLvmoxdeuQUDcUqIJU27oQAx6BicEMcyeIVZbQlo3oZ47cc6mR/km5+4M+vYGJWGymn0epLphY7AQlmZadUSIVxCz9SYTuVQsswepw+G0j2EVeAlDGY7Z6QvIZBPkf1AwLixDAzjUgSkEQbnrQEyJt3oZeT13KSZHocgsjJ525XJNibAchCe4uRaqXQo8CJK5B11PpTxnKgQOpMee0tqlgpXg5VfAt6Z6rXvoPD0CrPBUgBCFVqUYlIfDU3PU8Pm5584Dv73JlYt7t6VOwbRTJ1tI/u9wfnSeo5AH0rsFjiyiX4tmuPZd4Hkvg/i0Plwmv+BCCQuMpwX/t0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 46.5% regression of will-it-scale.per_process_ops on:


commit: aa8fdb9e2516055552de11cabaacde4d77ad7d72 ("slab: refill sheaves from all nodes")
https://git.kernel.org/cgit/linux/kernel/git/vbabka/linux.git b4/sheaves-for-all-rebased

testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory
parameters:

	nr_task: 100%
	mode: process
	test: mmap2
	cpufreq_governor: performance


In addition to that, the commit also has significant impact on the following tests:

+------------------+----------------------------------------------------------------------------------------------------+
| testcase: change | stress-ng: stress-ng.pkey.ops_per_sec  28.4% regression                                            |
| test machine     | 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory        |
| test parameters  | cpufreq_governor=performance                                                                       |
|                  | nr_threads=100%                                                                                    |
|                  | test=pkey                                                                                          |
|                  | testtime=60s                                                                                       |
+------------------+----------------------------------------------------------------------------------------------------+
| testcase: change | will-it-scale: will-it-scale.per_process_ops  32.8% regression                                     |
| test machine     | 224 threads 4 sockets Intel(R) Xeon(R) Platinum 8380H CPU @ 2.90GHz (Cooper Lake) with 192G memory |
| test parameters  | cpufreq_governor=performance                                                                       |
|                  | mode=process                                                                                       |
|                  | nr_task=100%                                                                                       |
|                  | test=brk2                                                                                          |
+------------------+----------------------------------------------------------------------------------------------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202601132136.77efd6d7-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260113/202601132136.77efd6d7-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp2/mmap2/will-it-scale

commit: 
  6a67958ab0 ("slab: remove unused PREEMPT_RT specific macros")
  aa8fdb9e25 ("slab: refill sheaves from all nodes")

6a67958ab000c3a7 aa8fdb9e2516055552de11cabaa 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      4342          +310.0%      17807        vmstat.system.cs
    254632            -2.1%     249196        vmstat.system.in
  37383532           -46.5%   20003486        will-it-scale.192.processes
    194705           -46.5%     104184        will-it-scale.per_process_ops
  37383532           -46.5%   20003486        will-it-scale.workload
  13704685 ±  2%     -10.7%   12244063        meminfo.Memused
   3930129 ±  4%     -46.4%    2107850        meminfo.SUnreclaim
   4077598 ±  4%     -44.7%    2256779        meminfo.Slab
  28750536 ± 35%     -51.2%   14022086        meminfo.max_used_kB
      0.20            -0.1        0.13        mpstat.cpu.all.irq%
     37.67           -18.1       19.55        mpstat.cpu.all.soft%
     59.17           +18.7       77.84        mpstat.cpu.all.sys%
      2.37            -0.9        1.43        mpstat.cpu.all.usr%
 1.544e+08           -65.4%   53459373        numa-numastat.node0.local_node
 1.545e+08           -65.3%   53600318        numa-numastat.node0.numa_hit
 1.614e+08           -65.0%   56529387        numa-numastat.node1.local_node
 1.614e+08           -64.9%   56588026        numa-numastat.node1.numa_hit
      7274 ± 13%     -27.0%       5310 ± 16%  perf-c2c.DRAM.local
      1458 ± 14%    +272.3%       5431 ± 10%  perf-c2c.DRAM.remote
     77502 ±  9%     -58.6%      32066 ± 11%  perf-c2c.HITM.local
    150.83 ± 12%   +2150.3%       3394 ± 12%  perf-c2c.HITM.remote
     77653 ±  9%     -54.3%      35460 ± 10%  perf-c2c.HITM.total
      0.92           -43.6%       0.52        turbostat.IPC
   1027292 ±  7%    -1e+06        0.00        turbostat.PKG_%
     64.83            -6.7%      60.50 ±  2%  turbostat.PkgTmp
    464.74           -11.6%     411.01        turbostat.PkgWatt
     25.39           -11.8%      22.38        turbostat.RAMWatt
  59906794            +2.1%   61151854        proc-vmstat.nr_free_pages_blocks
     34605           +10.0%      38075        proc-vmstat.nr_kernel_stack
    971757 ±  3%     -46.2%     523132 ±  2%  proc-vmstat.nr_slab_unreclaimable
  3.16e+08           -65.1%  1.102e+08        proc-vmstat.numa_hit
 3.158e+08           -65.2%    1.1e+08        proc-vmstat.numa_local
 1.277e+09           -66.3%  4.298e+08        proc-vmstat.pgalloc_normal
 1.275e+09           -66.4%  4.285e+08        proc-vmstat.pgfree
     18.04 ±  3%     -78.7%       3.85 ±  5%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     18.04 ±  3%     -78.7%       3.85 ±  5%  perf-sched.total_sch_delay.average.ms
    150.38 ±  2%     -62.1%      57.06        perf-sched.total_wait_and_delay.average.ms
     20506 ±  3%    +307.0%      83458        perf-sched.total_wait_and_delay.count.ms
    132.34 ±  2%     -59.8%      53.21        perf-sched.total_wait_time.average.ms
    150.38 ±  2%     -62.1%      57.06        perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     20506 ±  3%    +307.0%      83458        perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
    132.34 ±  2%     -59.8%      53.21        perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    615321 ± 36%     -70.1%     183936 ± 54%  numa-meminfo.node0.Active
    614931 ± 36%     -70.2%     183545 ± 54%  numa-meminfo.node0.Active(anon)
    368379 ± 51%     -99.7%     976.97 ± 82%  numa-meminfo.node0.AnonHugePages
    503778 ± 42%     -81.2%      94740 ±  8%  numa-meminfo.node0.AnonPages
    515242 ± 41%     -79.4%     105999 ±  6%  numa-meminfo.node0.AnonPages.max
     17646 ±  2%     +10.0%      19408 ±  2%  numa-meminfo.node0.KernelStack
   1999992 ±  4%     -45.3%    1093661        numa-meminfo.node0.SUnreclaim
   2064532 ±  5%     -42.4%    1189588 ±  2%  numa-meminfo.node0.Slab
   3575860 ± 10%     +22.6%    4384082 ±  6%  numa-meminfo.node1.Active
   3575470 ± 10%     +22.6%    4383698 ±  6%  numa-meminfo.node1.Active(anon)
   1908870 ±  4%     -47.3%    1006765 ±  2%  numa-meminfo.node1.SUnreclaim
   1991799 ±  4%     -46.8%    1059762 ±  2%  numa-meminfo.node1.Slab
    153718 ± 36%     -70.2%      45877 ± 54%  numa-vmstat.node0.nr_active_anon
    125968 ± 42%     -81.2%      23674 ±  8%  numa-vmstat.node0.nr_anon_pages
    179.85 ± 51%     -99.7%       0.48 ± 82%  numa-vmstat.node0.nr_anon_transparent_hugepages
     17648 ±  2%     +10.0%      19407 ±  2%  numa-vmstat.node0.nr_kernel_stack
    505861 ±  5%     -46.5%     270818        numa-vmstat.node0.nr_slab_unreclaimable
    153718 ± 36%     -70.2%      45877 ± 54%  numa-vmstat.node0.nr_zone_active_anon
 1.545e+08           -65.3%   53601656        numa-vmstat.node0.numa_hit
 1.544e+08           -65.4%   53460711        numa-vmstat.node0.numa_local
    893990 ± 10%     +22.6%    1096173 ±  6%  numa-vmstat.node1.nr_active_anon
    479194 ±  3%     -48.2%     248075 ±  3%  numa-vmstat.node1.nr_slab_unreclaimable
    893989 ± 10%     +22.6%    1096172 ±  6%  numa-vmstat.node1.nr_zone_active_anon
 1.614e+08           -64.9%   56589247        numa-vmstat.node1.numa_hit
 1.614e+08           -65.0%   56530608        numa-vmstat.node1.numa_local
      0.81           +19.0%       0.96        perf-stat.i.MPKI
 1.233e+11           -43.5%  6.963e+10        perf-stat.i.branch-instructions
      0.09            +0.0        0.10 ± 20%  perf-stat.i.branch-miss-rate%
 1.032e+08           -40.7%   61185481        perf-stat.i.branch-misses
     49.31           +12.7       62.02        perf-stat.i.cache-miss-rate%
  4.48e+08           -33.1%  2.995e+08        perf-stat.i.cache-misses
 9.107e+08           -47.1%  4.819e+08        perf-stat.i.cache-references
      4173          +325.7%      17767        perf-stat.i.context-switches
      1.09           +76.8%       1.93        perf-stat.i.cpi
    223.77           +92.5%     430.85 ±  2%  perf-stat.i.cpu-migrations
      1364           +49.0%       2033        perf-stat.i.cycles-between-cache-misses
 5.642e+11           -43.9%  3.166e+11        perf-stat.i.instructions
      0.92           -43.4%       0.52        perf-stat.i.ipc
      0.40 ± 15%     -24.0%       0.30 ± 10%  perf-stat.i.major-faults
      0.79           +19.2%       0.95        perf-stat.overall.MPKI
      0.08            +0.0        0.09        perf-stat.overall.branch-miss-rate%
     49.22           +12.9       62.11        perf-stat.overall.cache-miss-rate%
      1.09           +77.1%       1.92        perf-stat.overall.cpi
      1366           +48.6%       2031        perf-stat.overall.cycles-between-cache-misses
      0.92           -43.5%       0.52        perf-stat.overall.ipc
   4624244            +4.3%    4822893        perf-stat.overall.path-length
 1.224e+11           -43.3%  6.934e+10        perf-stat.ps.branch-instructions
 1.024e+08           -40.6%   60870902        perf-stat.ps.branch-misses
  4.45e+08           -32.9%  2.984e+08        perf-stat.ps.cache-misses
 9.044e+08           -46.9%  4.805e+08        perf-stat.ps.cache-references
      4123          +328.3%      17663        perf-stat.ps.context-switches
    217.00           +95.7%     424.68 ±  2%  perf-stat.ps.cpu-migrations
 5.601e+11           -43.7%  3.152e+11        perf-stat.ps.instructions
      0.37 ± 14%     -26.4%       0.27 ± 10%  perf-stat.ps.major-faults
 1.729e+14           -44.2%  9.647e+13        perf-stat.total.instructions
  18753172           +22.2%   22922183        sched_debug.cfs_rq:/.avg_vruntime.avg
  18959408           +26.5%   23989376        sched_debug.cfs_rq:/.avg_vruntime.max
  14142111 ±  5%     +28.4%   18152087 ±  3%  sched_debug.cfs_rq:/.avg_vruntime.min
    388239 ± 11%    +148.2%     963709 ±  5%  sched_debug.cfs_rq:/.avg_vruntime.stddev
      2.69 ±  4%     +40.2%       3.78 ±  5%  sched_debug.cfs_rq:/.h_nr_queued.max
      0.21 ± 13%     +98.9%       0.42 ±  9%  sched_debug.cfs_rq:/.h_nr_queued.stddev
      2.69 ±  4%     +40.2%       3.78 ±  5%  sched_debug.cfs_rq:/.h_nr_runnable.max
      0.21 ± 13%     +93.5%       0.41 ± 11%  sched_debug.cfs_rq:/.h_nr_runnable.stddev
    494388 ± 81%    +273.6%    1846967 ± 26%  sched_debug.cfs_rq:/.left_deadline.avg
   6717106 ± 48%    +253.4%   23740414        sched_debug.cfs_rq:/.left_deadline.max
   1440488 ± 63%    +294.1%    5677019 ± 11%  sched_debug.cfs_rq:/.left_deadline.stddev
    494379 ± 81%    +273.6%    1846957 ± 26%  sched_debug.cfs_rq:/.left_vruntime.avg
   6717025 ± 48%    +253.4%   23740319        sched_debug.cfs_rq:/.left_vruntime.max
   1440465 ± 63%    +294.1%    5676990 ± 11%  sched_debug.cfs_rq:/.left_vruntime.stddev
     33226 ± 65%   +2177.9%     756855 ± 38%  sched_debug.cfs_rq:/.load.avg
    479692 ± 26%  +10683.4%   51727275 ± 38%  sched_debug.cfs_rq:/.load.max
     85011 ± 43%   +6510.2%    5619465 ± 38%  sched_debug.cfs_rq:/.load.stddev
    551.61 ± 21%     +53.8%     848.36 ± 15%  sched_debug.cfs_rq:/.load_avg.avg
      1.44 ±  5%    +150.0%       3.61 ±  6%  sched_debug.cfs_rq:/.nr_queued.max
      0.11 ± 35%    +253.3%       0.39 ± 10%  sched_debug.cfs_rq:/.nr_queued.stddev
    494379 ± 81%    +273.6%    1846964 ± 26%  sched_debug.cfs_rq:/.right_vruntime.avg
   6717047 ± 48%    +253.4%   23740386        sched_debug.cfs_rq:/.right_vruntime.max
   1440467 ± 63%    +294.1%    5677009 ± 11%  sched_debug.cfs_rq:/.right_vruntime.stddev
      2097 ±  4%     +41.0%       2957 ±  6%  sched_debug.cfs_rq:/.runnable_avg.max
    200.20 ± 10%     +66.4%     333.16 ±  7%  sched_debug.cfs_rq:/.runnable_avg.stddev
      0.23 ± 89%   +2760.3%       6.49 ± 45%  sched_debug.cfs_rq:/.spread.avg
     43.58 ± 89%    +626.1%     316.47 ± 29%  sched_debug.cfs_rq:/.spread.max
      3.14 ± 89%   +1031.7%      35.50 ± 32%  sched_debug.cfs_rq:/.spread.stddev
    701.97 ±  7%     -15.1%     596.03 ±  5%  sched_debug.cfs_rq:/.util_avg.min
     54.04 ±  6%     +16.7%      63.09 ±  8%  sched_debug.cfs_rq:/.util_avg.stddev
      1237 ±  4%     +16.0%       1436 ±  8%  sched_debug.cfs_rq:/.util_est.max
  18741310           +22.3%   22916446        sched_debug.cfs_rq:/.zero_vruntime.avg
  18951538           +26.6%   23983182        sched_debug.cfs_rq:/.zero_vruntime.max
  14133757 ±  5%     +28.4%   18146576 ±  3%  sched_debug.cfs_rq:/.zero_vruntime.min
    388690 ± 11%    +147.8%     963119 ±  5%  sched_debug.cfs_rq:/.zero_vruntime.stddev
    525.43 ±  2%    +275.4%       1972 ±  3%  sched_debug.cpu.clock_task.stddev
      4548 ± 14%     -71.3%       1304 ± 47%  sched_debug.cpu.curr->pid.min
    962.66 ± 30%     +53.3%       1475 ± 13%  sched_debug.cpu.curr->pid.stddev
      2.75 ±  5%     +38.4%       3.81 ±  3%  sched_debug.cpu.nr_running.max
      0.22 ± 12%     +95.7%       0.43 ±  8%  sched_debug.cpu.nr_running.stddev
      5122 ±  2%    +208.6%      15807        sched_debug.cpu.nr_switches.avg
      2701 ±  2%    +167.1%       7215 ±  3%  sched_debug.cpu.nr_switches.min
      5212 ± 10%     +55.8%       8122 ±  9%  sched_debug.cpu.nr_switches.stddev
     21.86           -21.9        0.00        perf-profile.calltrace.cycles-pp.__refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
     37.63           -20.4       17.26 ±  3%  perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     37.62           -20.4       17.25 ±  3%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
     37.61           -20.4       17.25 ±  3%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
     37.62           -20.4       17.25 ±  3%  perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
     37.62           -20.4       17.25 ±  3%  perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     37.17           -20.3       16.90 ±  3%  perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
     36.75           -19.3       17.47 ±  3%  perf-profile.calltrace.cycles-pp.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs
     36.11           -18.9       17.22 ±  3%  perf-profile.calltrace.cycles-pp.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
     35.16           -18.4       16.78 ±  3%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch
     34.64           -18.1       16.56 ±  3%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf
     37.63           -14.4       23.18 ±  2%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
     37.63           -14.4       23.18 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
     37.63           -14.4       23.18 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
     10.17 ±  2%     -10.2        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
     10.06 ±  2%     -10.1        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     20.47            -8.6       11.91 ±  2%  perf-profile.calltrace.cycles-pp.__munmap
     19.09            -7.9       11.16 ±  2%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
     19.01            -7.9       11.12 ±  2%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     18.72            -7.8       10.97 ±  2%  perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     18.71            -7.7       10.96 ±  2%  perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     18.14            -7.5       10.65 ±  2%  perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
     17.77            -7.3       10.45 ±  2%  perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
      6.70 ±  2%      -6.7        0.00        perf-profile.calltrace.cycles-pp.alloc_from_new_slab.__refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      6.52 ±  2%      -6.5        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.alloc_from_new_slab.__refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      6.32 ±  2%      -6.3        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.alloc_from_new_slab.__refill_objects.__pcs_replace_empty_main
     10.74            -4.8        5.96 ±  2%  perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      9.30            -4.2        5.14 ±  2%  perf-profile.calltrace.cycles-pp.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      5.88            -2.7        3.19 ±  2%  perf-profile.calltrace.cycles-pp.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      5.70            -2.6        3.09 ±  2%  perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      5.14            -2.4        2.78 ±  2%  perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas
      2.99            -1.4        1.63 ±  2%  perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      4.39            -1.4        3.04 ±  2%  perf-profile.calltrace.cycles-pp.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      2.62            -1.2        1.42 ±  2%  perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff
      2.83            -1.2        1.66 ±  2%  perf-profile.calltrace.cycles-pp.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      3.99            -1.1        2.85 ±  2%  perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      2.21            -1.0        1.22 ±  2%  perf-profile.calltrace.cycles-pp.__cond_resched.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes
      2.15            -1.0        1.16 ±  2%  perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      3.53            -0.9        2.58 ±  2%  perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
      3.48            -0.9        2.54 ±  2%  perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      2.02            -0.9        1.16 ±  2%  perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      1.94            -0.8        1.10 ±  2%  perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas
      1.96            -0.8        1.18 ±  3%  perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      1.90            -0.8        1.15 ±  3%  perf-profile.calltrace.cycles-pp.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      1.77            -0.8        1.02 ±  2%  perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.vms_clear_ptes
      1.74            -0.7        1.04 ±  3%  perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      1.43            -0.6        0.88 ±  3%  perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap
      1.40            -0.5        0.86 ±  2%  perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area
      0.68 ±  6%      -0.4        0.25 ±100%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      1.72            -0.4        1.31 ±  2%  perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      1.73            -0.4        1.32 ±  2%  perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      0.00            +0.8        0.79 ± 12%  perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
      0.00            +0.8        0.81 ± 12%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.kmem_cache_free_bulk.kvfree_rcu_bulk
      0.00            +0.8        0.81 ± 12%  perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.kmem_cache_free_bulk
      0.00            +0.8        0.81 ± 12%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_monitor.process_one_work
      0.00            +0.8        0.81 ± 12%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_monitor
      0.00            +0.9        0.89 ± 30%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
      0.00            +0.9        0.89 ± 30%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      0.00            +1.4        1.43 ±  6%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_work
      0.00            +1.5        1.46 ±  6%  perf-profile.calltrace.cycles-pp.__slab_free.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_work.process_one_work
      0.00            +1.8        1.83 ±  6%  perf-profile.calltrace.cycles-pp.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_work.process_one_work.worker_thread
      0.00            +1.8        1.83 ±  6%  perf-profile.calltrace.cycles-pp.kvfree_rcu_bulk.kfree_rcu_work.process_one_work.worker_thread.kthread
      0.00            +1.8        1.84 ±  6%  perf-profile.calltrace.cycles-pp.kfree_rcu_work.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +2.6        2.57 ± 17%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__refill_objects_node.__refill_objects_any
      0.00            +2.6        2.58 ± 16%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__refill_objects_node.__refill_objects_any.refill_objects
      0.00            +2.6        2.58 ± 17%  perf-profile.calltrace.cycles-pp.__slab_free.__refill_objects_node.__refill_objects_any.refill_objects.__pcs_replace_empty_main
      0.00            +2.6        2.59 ± 10%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_monitor
      0.00            +2.7        2.66 ±  9%  perf-profile.calltrace.cycles-pp.__slab_free.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_monitor.process_one_work
      0.00            +4.0        4.00 ±  5%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.kmem_cache_free_bulk.kvfree_rcu_bulk
      0.00            +4.0        4.04 ±  6%  perf-profile.calltrace.cycles-pp.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_monitor.process_one_work.worker_thread
      0.00            +4.0        4.04 ±  6%  perf-profile.calltrace.cycles-pp.kvfree_rcu_bulk.kfree_rcu_monitor.process_one_work.worker_thread.kthread
      0.00            +4.1        4.06 ±  6%  perf-profile.calltrace.cycles-pp.kfree_rcu_monitor.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +5.5        5.50 ±  7%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__refill_objects_node.refill_objects
      0.00            +5.5        5.52 ±  7%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__refill_objects_node.refill_objects.__pcs_replace_empty_main
      0.00            +5.6        5.56 ±  7%  perf-profile.calltrace.cycles-pp.__slab_free.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +5.9        5.92 ±  3%  perf-profile.calltrace.cycles-pp.process_one_work.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.00            +5.9        5.92 ±  3%  perf-profile.calltrace.cycles-pp.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.00            +6.6        6.58 ±  5%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.alloc_from_new_slab.refill_objects.__pcs_replace_empty_main
      0.00            +6.7        6.68 ±  5%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.alloc_from_new_slab.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +6.8        6.84 ±  5%  perf-profile.calltrace.cycles-pp.alloc_from_new_slab.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00           +13.3       13.30 ±  3%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__refill_objects_node.__refill_objects_any.refill_objects
      0.00           +13.4       13.36 ±  3%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__refill_objects_node.__refill_objects_any.refill_objects.__pcs_replace_empty_main
      0.00           +16.9       16.87 ±  5%  perf-profile.calltrace.cycles-pp.__refill_objects_node.__refill_objects_any.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00           +17.1       17.06 ±  5%  perf-profile.calltrace.cycles-pp.__refill_objects_any.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00           +20.8       20.84        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main
      0.00           +21.0       20.96        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     41.48           +23.1       64.56        perf-profile.calltrace.cycles-pp.__mmap
     40.03           +23.7       63.74        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__mmap
     39.95           +23.7       63.69        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     39.57           +23.9       63.49        perf-profile.calltrace.cycles-pp.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     39.12           +24.1       63.24        perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     38.64           +24.3       62.97        perf-profile.calltrace.cycles-pp.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
     36.37           +25.2       61.60        perf-profile.calltrace.cycles-pp.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
     29.49           +28.3       57.78        perf-profile.calltrace.cycles-pp.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      0.00           +28.5       28.47 ±  2%  perf-profile.calltrace.cycles-pp.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
     23.95           +30.1       54.08        perf-profile.calltrace.cycles-pp.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
     23.34 ±  2%     +30.4       53.74 ±  2%  perf-profile.calltrace.cycles-pp.mas_alloc_nodes.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
     23.31 ±  2%     +30.4       53.72 ±  2%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma.__mmap_region
     22.88 ±  2%     +30.6       53.51 ±  2%  perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma
      0.00           +52.8       52.82 ±  2%  perf-profile.calltrace.cycles-pp.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
     22.07           -22.1        0.00        perf-profile.children.cycles-pp.__refill_objects
     37.63           -20.4       17.26 ±  3%  perf-profile.children.cycles-pp.smpboot_thread_fn
     37.62           -20.4       17.25 ±  3%  perf-profile.children.cycles-pp.run_ksoftirqd
     38.56           -18.4       20.16 ±  2%  perf-profile.children.cycles-pp.rcu_core
     38.56           -18.4       20.16 ±  2%  perf-profile.children.cycles-pp.rcu_do_batch
     38.57           -18.4       20.17 ±  2%  perf-profile.children.cycles-pp.handle_softirqs
     38.04           -18.3       19.70 ±  2%  perf-profile.children.cycles-pp.rcu_free_sheaf
     37.64           -18.2       19.46 ±  2%  perf-profile.children.cycles-pp.__kmem_cache_free_bulk
     37.63           -14.4       23.18 ±  2%  perf-profile.children.cycles-pp.ret_from_fork
     37.63           -14.4       23.18 ±  2%  perf-profile.children.cycles-pp.ret_from_fork_asm
     37.63           -14.4       23.18 ±  2%  perf-profile.children.cycles-pp.kthread
     20.82            -8.7       12.10 ±  2%  perf-profile.children.cycles-pp.__munmap
     18.72            -7.8       10.97 ±  2%  perf-profile.children.cycles-pp.__x64_sys_munmap
     18.71            -7.7       10.96 ±  2%  perf-profile.children.cycles-pp.__vm_munmap
     18.14            -7.5       10.65 ±  2%  perf-profile.children.cycles-pp.do_vmi_munmap
     17.78            -7.3       10.46 ±  2%  perf-profile.children.cycles-pp.do_vmi_align_munmap
     38.64            -7.2       31.46        perf-profile.children.cycles-pp.__slab_free
     10.77            -4.8        5.98 ±  2%  perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      9.33            -4.2        5.14 ±  2%  perf-profile.children.cycles-pp.vms_clear_ptes
      5.89            -2.7        3.19 ±  2%  perf-profile.children.cycles-pp.unmap_vmas
      5.70            -2.6        3.09 ±  2%  perf-profile.children.cycles-pp.unmap_page_range
      5.53            -2.5        3.00 ±  2%  perf-profile.children.cycles-pp.zap_pmd_range
      7.03            -1.9        5.14 ±  2%  perf-profile.children.cycles-pp.mas_wr_node_store
      4.93            -1.6        3.33 ±  2%  perf-profile.children.cycles-pp.mas_store_gfp
      3.00            -1.4        1.64 ±  2%  perf-profile.children.cycles-pp.perf_event_mmap
      2.64            -1.2        1.43 ±  2%  perf-profile.children.cycles-pp.perf_event_mmap_event
      2.90            -1.2        1.70 ±  2%  perf-profile.children.cycles-pp.free_pgtables
      2.62            -1.2        1.44 ±  2%  perf-profile.children.cycles-pp.__cond_resched
      3.99            -1.1        2.85 ±  2%  perf-profile.children.cycles-pp.mas_store_prealloc
      2.16            -1.0        1.19 ±  2%  perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      2.02            -0.8        1.17 ±  2%  perf-profile.children.cycles-pp.free_pgd_range
      3.48            -0.8        2.64 ±  2%  perf-profile.children.cycles-pp.__pi_memcpy
      1.95            -0.8        1.11 ±  2%  perf-profile.children.cycles-pp.free_p4d_range
      1.96            -0.8        1.18 ±  3%  perf-profile.children.cycles-pp.__get_unmapped_area
      1.78            -0.8        1.02 ±  2%  perf-profile.children.cycles-pp.free_pud_range
      1.90            -0.8        1.15 ±  3%  perf-profile.children.cycles-pp.shmem_get_unmapped_area
      1.75            -0.7        1.05 ±  2%  perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      1.47            -0.6        0.87 ±  2%  perf-profile.children.cycles-pp.mas_find
      0.88 ±  3%      -0.6        0.29 ±  5%  perf-profile.children.cycles-pp.allocate_slab
      1.26            -0.6        0.70 ±  3%  perf-profile.children.cycles-pp.entry_SYSCALL_64
      1.43            -0.6        0.88 ±  3%  perf-profile.children.cycles-pp.vm_unmapped_area
      1.41            -0.5        0.87 ±  3%  perf-profile.children.cycles-pp.unmapped_area_topdown
      1.03            -0.5        0.56 ±  2%  perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.90            -0.4        0.48 ±  3%  perf-profile.children.cycles-pp.vm_area_alloc
      0.62 ±  4%      -0.4        0.20 ±  6%  perf-profile.children.cycles-pp.shuffle_freelist
      0.78            -0.4        0.38 ±  3%  perf-profile.children.cycles-pp.zap_pte_range
      0.84            -0.4        0.46 ±  3%  perf-profile.children.cycles-pp.rcu_all_qs
      0.71            -0.3        0.36 ±  2%  perf-profile.children.cycles-pp.mas_prev_slot
      0.48 ±  3%      -0.3        0.16 ±  6%  perf-profile.children.cycles-pp.setup_object
      0.84 ±  5%      -0.3        0.53 ±  5%  perf-profile.children.cycles-pp.mas_update_gap
      0.77 ±  5%      -0.3        0.49 ±  4%  perf-profile.children.cycles-pp.mas_leaf_max_gap
      0.60            -0.3        0.33 ±  3%  perf-profile.children.cycles-pp.d_path
      0.62            -0.3        0.34 ±  2%  perf-profile.children.cycles-pp.__build_id_parse
      0.66            -0.3        0.40 ±  2%  perf-profile.children.cycles-pp.mas_walk
      0.51            -0.2        0.27 ±  2%  perf-profile.children.cycles-pp.perf_iterate_sb
      0.52            -0.2        0.30 ±  3%  perf-profile.children.cycles-pp.mas_next_slot
      0.55 ±  2%      -0.2        0.34 ±  2%  perf-profile.children.cycles-pp.kmem_cache_free
      0.50            -0.2        0.29 ±  3%  perf-profile.children.cycles-pp.mas_wr_store_type
      0.65            -0.2        0.45 ±  3%  perf-profile.children.cycles-pp.mas_empty_area_rev
      0.79 ± 10%      -0.2        0.60 ±  3%  perf-profile.children.cycles-pp.__kfree_rcu_sheaf
      0.43            -0.2        0.24 ±  3%  perf-profile.children.cycles-pp.prepend_path
      0.49            -0.2        0.30 ±  3%  perf-profile.children.cycles-pp.__vma_start_write
      0.43            -0.2        0.24 ±  2%  perf-profile.children.cycles-pp.up_write
      0.43            -0.2        0.24 ±  3%  perf-profile.children.cycles-pp.unlink_file_vma_batch_process
      0.41            -0.2        0.23        perf-profile.children.cycles-pp.shmem_mmap_prepare
      0.40            -0.2        0.22 ±  3%  perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
      0.37 ±  3%      -0.2        0.19 ±  3%  perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      0.38            -0.2        0.21 ±  3%  perf-profile.children.cycles-pp.arch_exit_to_user_mode_prepare
      0.36 ±  6%      -0.2        0.19 ±  3%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.38            -0.2        0.21 ±  3%  perf-profile.children.cycles-pp.touch_atime
      0.35            -0.2        0.19 ±  3%  perf-profile.children.cycles-pp.__pte_offset_map_lock
      0.27            -0.2        0.11 ±  6%  perf-profile.children.cycles-pp.__alloc_empty_sheaf
      0.25 ±  2%      -0.2        0.09 ±  4%  perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      0.26            -0.2        0.10 ±  4%  perf-profile.children.cycles-pp.__kmalloc_noprof
      0.35            -0.2        0.20 ±  2%  perf-profile.children.cycles-pp.down_write
      0.33            -0.1        0.18 ±  3%  perf-profile.children.cycles-pp.down_write_killable
      0.32            -0.1        0.18 ±  2%  perf-profile.children.cycles-pp.atime_needs_update
      0.34 ±  2%      -0.1        0.20 ±  3%  perf-profile.children.cycles-pp.__vma_enter_locked
      0.26            -0.1        0.12 ±  4%  perf-profile.children.cycles-pp.security_vm_enough_memory_mm
      0.22 ±  3%      -0.1        0.08 ±  8%  perf-profile.children.cycles-pp.get_page_from_freelist
      0.28            -0.1        0.15 ±  2%  perf-profile.children.cycles-pp.fget
      0.46            -0.1        0.34 ±  3%  perf-profile.children.cycles-pp.mas_rev_awalk
      0.28            -0.1        0.16 ±  3%  perf-profile.children.cycles-pp.fput
      0.29            -0.1        0.17 ±  3%  perf-profile.children.cycles-pp.freader_fetch
      0.26            -0.1        0.14 ±  2%  perf-profile.children.cycles-pp.up_read
      0.32            -0.1        0.21 ±  4%  perf-profile.children.cycles-pp.kfree
      0.22            -0.1        0.11 ±  3%  perf-profile.children.cycles-pp.remove_vma
      0.14 ±  3%      -0.1        0.04 ± 44%  perf-profile.children.cycles-pp.rmqueue
      0.22            -0.1        0.12 ±  4%  perf-profile.children.cycles-pp.prepend_copy
      0.22 ±  2%      -0.1        0.13 ±  2%  perf-profile.children.cycles-pp.tlb_finish_mmu
      0.20            -0.1        0.11 ±  3%  perf-profile.children.cycles-pp.freader_init_from_file
      0.21            -0.1        0.12 ±  3%  perf-profile.children.cycles-pp.__kmalloc_cache_noprof
      0.17 ± 13%      -0.1        0.08 ± 19%  perf-profile.children.cycles-pp.strlen
      0.18 ±  2%      -0.1        0.10 ±  3%  perf-profile.children.cycles-pp.tlb_gather_mmu
      0.18 ±  2%      -0.1        0.10 ±  3%  perf-profile.children.cycles-pp.copy_from_kernel_nofault
      0.14 ±  5%      -0.1        0.06 ±  6%  perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.18 ±  2%      -0.1        0.11 ±  3%  perf-profile.children.cycles-pp.current_time
      0.17 ±  2%      -0.1        0.10 ±  3%  perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.37 ±  2%      -0.1        0.30 ±  4%  perf-profile.children.cycles-pp.build_detached_freelist
      0.12 ±  4%      -0.1        0.04 ± 44%  perf-profile.children.cycles-pp.__rmqueue_pcplist
      0.18 ±  2%      -0.1        0.11 ±  3%  perf-profile.children.cycles-pp.downgrade_write
      0.15            -0.1        0.08 ±  4%  perf-profile.children.cycles-pp.__filemap_get_folio_mpol
      0.15            -0.1        0.08 ±  4%  perf-profile.children.cycles-pp.__vm_enough_memory
      0.15 ±  3%      -0.1        0.09 ±  4%  perf-profile.children.cycles-pp.mas_prev
      0.14 ±  3%      -0.1        0.07 ±  6%  perf-profile.children.cycles-pp.vma_mark_detached
      0.14            -0.1        0.08 ±  4%  perf-profile.children.cycles-pp.vma_merge_new_range
      0.18 ±  2%      -0.1        0.12        perf-profile.children.cycles-pp.hrtimer_interrupt
      0.19 ±  2%      -0.1        0.13 ±  2%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.13 ±  2%      -0.1        0.08 ±  6%  perf-profile.children.cycles-pp.mas_wr_store_entry
      0.13 ±  2%      -0.1        0.08 ±  6%  perf-profile.children.cycles-pp.testcase
      0.11            -0.1        0.06 ±  6%  perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.11            -0.1        0.06        perf-profile.children.cycles-pp.may_expand_vm
      0.18 ±  4%      -0.0        0.14 ±  7%  perf-profile.children.cycles-pp.__free_frozen_pages
      0.18 ±  2%      -0.0        0.14 ±  4%  perf-profile.children.cycles-pp.freader_get_folio
      0.10            -0.0        0.06 ±  8%  perf-profile.children.cycles-pp.mas_data_end
      0.10 ±  3%      -0.0        0.06 ±  6%  perf-profile.children.cycles-pp.perf_event_mmap_output
      0.09 ±  4%      -0.0        0.05        perf-profile.children.cycles-pp.filemap_get_entry
      0.07 ±  6%      -0.0        0.03 ± 70%  perf-profile.children.cycles-pp.free_pcppages_bulk
      0.08 ±  5%      -0.0        0.05        perf-profile.children.cycles-pp.mas_prev_setup
      0.11 ±  3%      -0.0        0.08 ±  4%  perf-profile.children.cycles-pp.ktime_get_coarse_real_ts64_mg
      0.12 ±  3%      -0.0        0.09 ±  4%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.11            -0.0        0.08        perf-profile.children.cycles-pp.tick_nohz_handler
      0.10 ±  3%      -0.0        0.07        perf-profile.children.cycles-pp.update_process_times
      0.08            -0.0        0.06 ±  9%  perf-profile.children.cycles-pp.free_frozen_page_commit
      0.10 ±  5%      -0.0        0.08 ± 10%  perf-profile.children.cycles-pp._raw_spin_trylock
      0.19 ±  3%      +0.0        0.21 ±  3%  perf-profile.children.cycles-pp.perf_session__process_events
      0.19 ±  3%      +0.0        0.21 ±  3%  perf-profile.children.cycles-pp.reader__read_event
      0.19 ±  3%      +0.0        0.21 ±  3%  perf-profile.children.cycles-pp.record__finish_output
      0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.get_state_synchronize_rcu_full
      0.14 ±  2%      +0.1        0.23 ±  3%  perf-profile.children.cycles-pp._raw_spin_lock
      0.00            +1.8        1.84 ±  6%  perf-profile.children.cycles-pp.kfree_rcu_work
      1.08 ±  2%      +2.0        3.04 ±  3%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      1.10 ±  2%      +2.0        3.06 ±  3%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.89 ±  3%      +2.0        2.92 ±  4%  perf-profile.children.cycles-pp.__irq_exit_rcu
      0.00            +4.1        4.06 ±  6%  perf-profile.children.cycles-pp.kfree_rcu_monitor
      0.00            +5.9        5.86 ±  4%  perf-profile.children.cycles-pp.kmem_cache_free_bulk
      0.00            +5.9        5.86 ±  4%  perf-profile.children.cycles-pp.kvfree_rcu_bulk
      0.00            +5.9        5.92 ±  3%  perf-profile.children.cycles-pp.process_one_work
      0.00            +5.9        5.92 ±  3%  perf-profile.children.cycles-pp.worker_thread
     59.20           +15.8       74.96        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     59.04           +15.8       74.88        perf-profile.children.cycles-pp.do_syscall_64
      0.00           +17.1       17.06 ±  5%  perf-profile.children.cycles-pp.__refill_objects_any
     55.81           +17.2       73.06        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     54.93           +17.5       72.46        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     41.80           +22.9       64.73        perf-profile.children.cycles-pp.__mmap
     39.57           +23.9       63.50        perf-profile.children.cycles-pp.ksys_mmap_pgoff
     39.12           +24.1       63.25        perf-profile.children.cycles-pp.vm_mmap_pgoff
     38.65           +24.3       62.98        perf-profile.children.cycles-pp.do_mmap
     36.41           +25.2       61.62        perf-profile.children.cycles-pp.__mmap_region
     29.51           +28.3       57.79        perf-profile.children.cycles-pp.__mmap_new_vma
     24.05           +30.1       54.12        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
     23.96           +30.1       54.08        perf-profile.children.cycles-pp.mas_preallocate
     23.34 ±  2%     +30.4       53.74 ±  2%  perf-profile.children.cycles-pp.mas_alloc_nodes
     23.09 ±  2%     +30.5       53.60 ±  2%  perf-profile.children.cycles-pp.__pcs_replace_empty_main
      0.00           +45.4       45.43 ±  3%  perf-profile.children.cycles-pp.__refill_objects_node
      0.00           +52.9       52.90 ±  2%  perf-profile.children.cycles-pp.refill_objects
      2.70            -1.2        1.48 ±  2%  perf-profile.self.cycles-pp.zap_pmd_range
      3.40            -0.8        2.57 ±  2%  perf-profile.self.cycles-pp.__pi_memcpy
      1.75            -0.8        0.96 ±  2%  perf-profile.self.cycles-pp.__mmap_region
      1.75            -0.7        1.00 ±  2%  perf-profile.self.cycles-pp.free_pud_range
      1.48            -0.7        0.81 ±  2%  perf-profile.self.cycles-pp.__cond_resched
      1.41            -0.6        0.78 ±  3%  perf-profile.self.cycles-pp.mas_wr_node_store
      1.02            -0.5        0.56 ±  2%  perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      1.02            -0.4        0.58 ±  3%  perf-profile.self.cycles-pp.__slab_free
      0.88            -0.4        0.47 ±  3%  perf-profile.self.cycles-pp.mas_store_gfp
      0.56 ±  4%      -0.4        0.18 ±  5%  perf-profile.self.cycles-pp.shuffle_freelist
      0.68            -0.3        0.35 ±  2%  perf-profile.self.cycles-pp.mas_prev_slot
      0.72            -0.3        0.40 ±  3%  perf-profile.self.cycles-pp.rcu_all_qs
      0.65            -0.3        0.36 ±  3%  perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.75 ±  6%      -0.3        0.47 ±  5%  perf-profile.self.cycles-pp.mas_leaf_max_gap
      0.64            -0.3        0.38 ±  3%  perf-profile.self.cycles-pp.mas_walk
      0.85 ±  2%      -0.3        0.60 ±  4%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.54            -0.2        0.30 ±  3%  perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      0.51            -0.2        0.28 ±  2%  perf-profile.self.cycles-pp.mas_next_slot
      0.48            -0.2        0.26 ±  3%  perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.49            -0.2        0.28 ±  3%  perf-profile.self.cycles-pp.mas_wr_store_type
      0.44            -0.2        0.24 ±  3%  perf-profile.self.cycles-pp.__munmap
      0.48            -0.2        0.28 ±  3%  perf-profile.self.cycles-pp.__mmap
      0.42            -0.2        0.23 ±  2%  perf-profile.self.cycles-pp.up_write
      0.40            -0.2        0.22 ±  3%  perf-profile.self.cycles-pp.unmapped_area_topdown
      0.39            -0.2        0.21 ±  2%  perf-profile.self.cycles-pp.perf_iterate_sb
      0.40            -0.2        0.22 ±  3%  perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
      0.41            -0.2        0.23 ±  2%  perf-profile.self.cycles-pp.mas_store_prealloc
      0.38            -0.2        0.21 ±  4%  perf-profile.self.cycles-pp.arch_exit_to_user_mode_prepare
      0.38            -0.2        0.21 ±  2%  perf-profile.self.cycles-pp.mas_preallocate
      0.38            -0.2        0.21 ±  4%  perf-profile.self.cycles-pp.__vm_munmap
      0.37            -0.2        0.20 ±  3%  perf-profile.self.cycles-pp.perf_event_mmap
      0.38            -0.2        0.22        perf-profile.self.cycles-pp.mas_find
      0.34            -0.2        0.19 ±  3%  perf-profile.self.cycles-pp.vm_area_alloc
      0.30            -0.2        0.15 ±  3%  perf-profile.self.cycles-pp.zap_pte_range
      0.28            -0.1        0.14 ±  4%  perf-profile.self.cycles-pp.__kfree_rcu_sheaf
      0.31            -0.1        0.18 ±  4%  perf-profile.self.cycles-pp.__vma_enter_locked
      0.30            -0.1        0.17 ±  3%  perf-profile.self.cycles-pp.down_write
      0.28            -0.1        0.15 ±  3%  perf-profile.self.cycles-pp.down_write_killable
      0.27            -0.1        0.14 ±  5%  perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.28            -0.1        0.16 ±  3%  perf-profile.self.cycles-pp.__mmap_new_vma
      0.27            -0.1        0.14 ±  3%  perf-profile.self.cycles-pp.fput
      0.27            -0.1        0.15 ±  2%  perf-profile.self.cycles-pp.prepend_path
      0.27            -0.1        0.15 ±  2%  perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
      0.26 ±  9%      -0.1        0.14 ±  2%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.29            -0.1        0.17 ±  5%  perf-profile.self.cycles-pp.kfree
      0.27            -0.1        0.15 ±  3%  perf-profile.self.cycles-pp.fget
      0.37 ±  2%      -0.1        0.25 ±  4%  perf-profile.self.cycles-pp.build_detached_freelist
      0.25            -0.1        0.14 ±  3%  perf-profile.self.cycles-pp.up_read
      0.26 ±  8%      -0.1        0.15 ± 10%  perf-profile.self.cycles-pp.perf_event_mmap_event
      0.23            -0.1        0.13 ±  4%  perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      0.49            -0.1        0.39 ±  2%  perf-profile.self.cycles-pp.kvfree_call_rcu
      0.22            -0.1        0.12 ±  3%  perf-profile.self.cycles-pp.tlb_finish_mmu
      0.17 ±  2%      -0.1        0.08        perf-profile.self.cycles-pp.free_p4d_range
      0.19 ±  2%      -0.1        0.11 ±  3%  perf-profile.self.cycles-pp.freader_init_from_file
      0.36            -0.1        0.28 ±  4%  perf-profile.self.cycles-pp.mas_rev_awalk
      0.18 ±  2%      -0.1        0.10 ±  5%  perf-profile.self.cycles-pp.do_syscall_64
      0.19 ±  2%      -0.1        0.10 ±  4%  perf-profile.self.cycles-pp.free_pgtables
      0.16 ± 11%      -0.1        0.08 ± 17%  perf-profile.self.cycles-pp.strlen
      0.18            -0.1        0.10 ±  3%  perf-profile.self.cycles-pp.tlb_gather_mmu
      0.14 ±  5%      -0.1        0.06 ±  6%  perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.19            -0.1        0.11 ±  4%  perf-profile.self.cycles-pp.__kmalloc_cache_noprof
      0.17 ±  2%      -0.1        0.10 ±  7%  perf-profile.self.cycles-pp.do_mmap
      0.18            -0.1        0.11 ±  4%  perf-profile.self.cycles-pp.downgrade_write
      0.13            -0.1        0.06 ±  6%  perf-profile.self.cycles-pp.atime_needs_update
      0.11 ±  3%      -0.1        0.04 ± 44%  perf-profile.self.cycles-pp.alloc_from_new_slab
      0.19            -0.1        0.12 ±  3%  perf-profile.self.cycles-pp.mas_empty_area_rev
      0.16 ±  3%      -0.1        0.10 ±  3%  perf-profile.self.cycles-pp.__pte_offset_map_lock
      0.14 ±  3%      -0.1        0.08 ±  4%  perf-profile.self.cycles-pp.unmap_page_range
      0.12 ±  4%      -0.1        0.06 ±  7%  perf-profile.self.cycles-pp.__build_id_parse
      0.15            -0.1        0.09 ±  4%  perf-profile.self.cycles-pp.__vma_start_write
      0.13 ±  3%      -0.1        0.07 ±  6%  perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.13 ±  3%      -0.1        0.07 ±  6%  perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.13            -0.1        0.07 ±  5%  perf-profile.self.cycles-pp.vma_mark_detached
      0.13 ±  2%      -0.1        0.07 ±  5%  perf-profile.self.cycles-pp.__pcs_replace_empty_main
      0.08            -0.1        0.02 ± 99%  perf-profile.self.cycles-pp.testcase
      0.12            -0.1        0.07 ±  5%  perf-profile.self.cycles-pp.copy_from_kernel_nofault
      0.14 ±  4%      -0.1        0.09 ± 12%  perf-profile.self.cycles-pp.shmem_get_unmapped_area
      0.10            -0.0        0.05 ±  7%  perf-profile.self.cycles-pp.security_vm_enough_memory_mm
      0.09            -0.0        0.04 ± 44%  perf-profile.self.cycles-pp.unmap_vmas
      0.19 ±  5%      -0.0        0.14 ±  4%  perf-profile.self.cycles-pp.kmem_cache_free
      0.10            -0.0        0.05 ±  8%  perf-profile.self.cycles-pp.vma_merge_new_range
      0.10 ±  4%      -0.0        0.06 ±  6%  perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.11            -0.0        0.06 ±  7%  perf-profile.self.cycles-pp.mas_wr_store_entry
      0.10 ±  5%      -0.0        0.05 ±  7%  perf-profile.self.cycles-pp.mas_data_end
      0.08 ±  5%      -0.0        0.04 ± 44%  perf-profile.self.cycles-pp.mas_prev
      0.10 ±  4%      -0.0        0.06        perf-profile.self.cycles-pp.may_expand_vm
      0.10 ±  3%      -0.0        0.06 ±  6%  perf-profile.self.cycles-pp.perf_event_mmap_output
      0.09            -0.0        0.05        perf-profile.self.cycles-pp.vms_complete_munmap_vmas
      0.10 ±  4%      -0.0        0.07 ±  7%  perf-profile.self.cycles-pp.vm_mmap_pgoff
      0.11 ±  3%      -0.0        0.08 ±  4%  perf-profile.self.cycles-pp.ktime_get_coarse_real_ts64_mg
      0.09 ±  5%      -0.0        0.06 ± 11%  perf-profile.self.cycles-pp._raw_spin_trylock
      0.00            +0.1        0.05 ±  7%  perf-profile.self.cycles-pp.get_state_synchronize_rcu_full
      0.00            +0.1        0.06 ±  6%  perf-profile.self.cycles-pp.freader_get_folio
      0.14 ±  2%      +0.1        0.22 ±  3%  perf-profile.self.cycles-pp._raw_spin_lock
      0.00            +0.2        0.16 ±  6%  perf-profile.self.cycles-pp.refill_objects
      0.00            +0.2        0.18 ±  5%  perf-profile.self.cycles-pp.__refill_objects_any
      0.00            +2.3        2.29        perf-profile.self.cycles-pp.__refill_objects_node
     54.93           +17.5       72.46        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath


***************************************************************************************************
lkp-srf-2sp3: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory
=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp3/pkey/stress-ng/60s

commit: 
  6a67958ab0 ("slab: remove unused PREEMPT_RT specific macros")
  aa8fdb9e25 ("slab: refill sheaves from all nodes")

6a67958ab000c3a7 aa8fdb9e2516055552de11cabaa 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
 4.001e+08 ±  6%     +54.0%  6.163e+08 ± 11%  cpuidle..time
    156947 ± 16%    +118.4%     342823 ±  9%  cpuidle..usage
   4331943 ± 61%    +160.2%   11272469 ± 34%  numa-meminfo.node0.FilePages
    870538 ±  7%     -18.9%     705628 ±  4%  numa-meminfo.node1.SUnreclaim
    979599 ±  7%     -17.1%     812545 ±  4%  numa-meminfo.node1.Slab
  27817379 ±  5%     +12.3%   31236755        vmstat.memory.cache
     10123 ±  6%    +130.8%      23360        vmstat.system.cs
    475556            -2.9%     461553        vmstat.system.in
  17747754 ± 11%     -33.0%   11895491 ± 15%  numa-numastat.node0.local_node
  17831118 ± 10%     -32.8%   11986853 ± 15%  numa-numastat.node0.numa_hit
  29067129 ±  2%     -38.2%   17954639 ±  9%  numa-numastat.node1.local_node
  29182842 ±  2%     -38.1%   18062464 ± 10%  numa-numastat.node1.numa_hit
      2.45 ±  9%      +1.7        4.14 ± 15%  mpstat.cpu.all.idle%
      0.30            -0.1        0.23 ±  2%  mpstat.cpu.all.irq%
     19.77 ±  4%      -5.9       13.83 ±  3%  mpstat.cpu.all.soft%
     66.39            +7.3       73.70        mpstat.cpu.all.sys%
     11.09            -3.0        8.09        mpstat.cpu.all.usr%
   1083627 ± 61%    +160.2%    2820009 ± 34%  numa-vmstat.node0.nr_file_pages
  17839136 ± 10%     -32.8%   11986742 ± 15%  numa-vmstat.node0.numa_hit
  17755627 ± 11%     -33.0%   11895381 ± 15%  numa-vmstat.node0.numa_local
    209983 ±  7%     -15.3%     177924 ±  4%  numa-vmstat.node1.nr_slab_unreclaimable
  29194095 ±  2%     -38.1%   18061832 ± 10%  numa-vmstat.node1.numa_hit
  29078573 ±  2%     -38.3%   17954008 ±  9%  numa-vmstat.node1.numa_local
 1.178e+09           -28.4%  8.427e+08        stress-ng.pkey.ops
  19634814           -28.4%   14051726        stress-ng.pkey.ops_per_sec
    265455 ±  8%    +120.3%     584676        stress-ng.time.involuntary_context_switches
     14980            +1.8%      15243        stress-ng.time.percent_of_cpu_this_job_got
      7757            +6.7%       8279        stress-ng.time.system_time
      1245           -29.2%     882.14        stress-ng.time.user_time
    167683 ±  3%     +37.8%     231015 ±  8%  sched_debug.cfs_rq:/.avg_vruntime.stddev
    112.17 ± 91%     -85.7%      16.00 ±148%  sched_debug.cfs_rq:/.runnable_avg.min
    224.70 ±  6%     +25.0%     280.94 ± 13%  sched_debug.cfs_rq:/.runnable_avg.stddev
    162.74 ±  8%     +14.1%     185.74 ± 12%  sched_debug.cfs_rq:/.util_avg.stddev
    167731 ±  3%     +37.6%     230810 ±  8%  sched_debug.cfs_rq:/.zero_vruntime.stddev
      3513 ± 10%     +58.0%       5551 ±  3%  sched_debug.cpu.nr_switches.avg
      1611 ±  4%     +51.4%       2440 ±  6%  sched_debug.cpu.nr_switches.min
  24416569 ±  6%     +14.6%   27972054        meminfo.Active
  24416553 ±  6%     +14.6%   27972037        meminfo.Active(anon)
    948184 ±  2%     +10.2%    1044872 ±  3%  meminfo.AnonPages
  27174415 ±  5%     +12.7%   30633367        meminfo.Cached
  26095784 ±  5%     +13.6%   29638241        meminfo.Committed_AS
    726034 ±  8%     +29.8%     942096 ±  8%  meminfo.Mapped
  32569469 ±  4%     +10.6%   36020482        meminfo.Memused
  23472099 ±  6%     +14.7%   26931049        meminfo.Shmem
      3.25 ±  6%      +1.8        5.09 ± 12%  turbostat.C1%
      3.19 ±  6%     +54.8%       4.94 ± 12%  turbostat.CPU%c1
      1.38           -25.7%       1.02        turbostat.IPC
    469589 ± 11%  -4.7e+05        0.00        turbostat.PKG_%
     60.67            -2.7%      59.00        turbostat.PkgTmp
    483.34            -9.9%     435.70        turbostat.PkgWatt
     23.10            -3.8%      22.22        turbostat.RAMWatt
      0.04           -25.0%       0.03        turbostat.SysWatt
   6088135 ±  6%     +14.7%    6981165        proc-vmstat.nr_active_anon
    236856 ±  2%     +10.2%     260993 ±  2%  proc-vmstat.nr_anon_pages
   5640903            -1.5%    5554633        proc-vmstat.nr_dirty_background_threshold
  11295599            -1.5%   11122847        proc-vmstat.nr_dirty_threshold
   6777790 ±  5%     +12.8%    7646722        proc-vmstat.nr_file_pages
  56774242            -1.5%   55910274        proc-vmstat.nr_free_pages
     35659            +4.8%      37370        proc-vmstat.nr_kernel_stack
    180794 ±  9%     +29.8%     234610 ±  8%  proc-vmstat.nr_mapped
   5852212 ±  6%     +14.8%    6721144        proc-vmstat.nr_shmem
     47795            +4.0%      49717        proc-vmstat.nr_slab_reclaimable
   6088134 ±  6%     +14.7%    6981165        proc-vmstat.nr_zone_active_anon
  47016156 ±  3%     -36.1%   30053690 ±  3%  proc-vmstat.numa_hit
  46817079 ±  3%     -36.2%   29854503 ±  4%  proc-vmstat.numa_local
 1.463e+08 ±  4%     -50.3%   72679091 ±  6%  proc-vmstat.pgalloc_normal
 1.325e+08 ±  4%     -56.7%   57326779 ±  7%  proc-vmstat.pgfree
      0.44           +18.3%       0.52        perf-stat.i.MPKI
 1.653e+11           -26.6%  1.213e+11        perf-stat.i.branch-instructions
      0.10            +0.0        0.11        perf-stat.i.branch-miss-rate%
 1.702e+08           -24.0%  1.293e+08        perf-stat.i.branch-misses
     53.44            +7.3       60.79        perf-stat.i.cache-miss-rate%
 3.563e+08           -13.8%  3.073e+08        perf-stat.i.cache-misses
 6.643e+08           -24.4%  5.019e+08        perf-stat.i.cache-references
      9933 ±  7%    +137.5%      23593        perf-stat.i.context-switches
      0.73           +35.4%       0.99        perf-stat.i.cpi
 5.999e+11            -1.7%  5.899e+11        perf-stat.i.cpu-cycles
    532.61 ±  3%    +115.9%       1150 ±  2%  perf-stat.i.cpu-migrations
      1714           +16.6%       1999        perf-stat.i.cycles-between-cache-misses
 8.274e+11           -26.8%  6.054e+11        perf-stat.i.instructions
      1.38           -25.6%       1.02        perf-stat.i.ipc
      0.43           +17.7%       0.51        perf-stat.overall.MPKI
      0.10            +0.0        0.11        perf-stat.overall.branch-miss-rate%
     53.79            +7.5       61.32        perf-stat.overall.cache-miss-rate%
      0.73           +34.5%       0.98        perf-stat.overall.cpi
      1675           +14.3%       1915        perf-stat.overall.cycles-between-cache-misses
      1.38           -25.6%       1.02        perf-stat.overall.ipc
 1.623e+11           -26.7%   1.19e+11        perf-stat.ps.branch-instructions
 1.671e+08           -24.2%  1.267e+08        perf-stat.ps.branch-misses
 3.521e+08           -13.9%   3.03e+08        perf-stat.ps.cache-misses
 6.547e+08           -24.5%  4.942e+08        perf-stat.ps.cache-references
      9668 ±  7%    +140.0%      23203        perf-stat.ps.context-switches
   5.9e+11            -1.7%  5.803e+11        perf-stat.ps.cpu-cycles
    519.80 ±  3%    +117.3%       1129 ±  2%  perf-stat.ps.cpu-migrations
 8.124e+11           -26.9%  5.941e+11        perf-stat.ps.instructions
 4.938e+13           -26.4%  3.633e+13        perf-stat.total.instructions



***************************************************************************************************
lkp-cpl-4sp2: 224 threads 4 sockets Intel(R) Xeon(R) Platinum 8380H CPU @ 2.90GHz (Cooper Lake) with 192G memory
=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-cpl-4sp2/brk2/will-it-scale

commit: 
  6a67958ab0 ("slab: remove unused PREEMPT_RT specific macros")
  aa8fdb9e25 ("slab: refill sheaves from all nodes")

6a67958ab000c3a7 aa8fdb9e2516055552de11cabaa 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    482268 ±  5%    +474.2%    2769004 ±173%  cpuidle..usage
      5608          +527.0%      35168 ±  5%  vmstat.system.cs
   4055429 ±  3%     -41.6%    2367093 ±  5%  meminfo.SUnreclaim
   4204255 ±  3%     -40.2%    2515845 ±  5%  meminfo.Slab
  20631562           -29.4%   14569336 ± 10%  meminfo.max_used_kB
    181.50 ± 17%   +6369.9%      11742 ± 17%  perf-c2c.DRAM.remote
     36602 ± 12%     -31.1%      25221 ± 11%  perf-c2c.HITM.local
     33.67 ± 24%  +23228.2%       7853 ± 17%  perf-c2c.HITM.remote
      0.81            -0.2        0.62 ±  2%  mpstat.cpu.all.irq%
     25.48           -12.9       12.54 ±  6%  mpstat.cpu.all.soft%
     69.98           +11.3       81.25 ±  6%  mpstat.cpu.all.sys%
      3.17            -1.0        2.22 ±  5%  mpstat.cpu.all.usr%
      3454            +7.2%       3702        turbostat.Bzy_MHz
      0.47           -36.2%       0.30        turbostat.IPC
    298.04          -119.9      178.13 ±  5%  turbostat.PKG_%
     32.63            -6.7%      30.45 ±  2%  turbostat.RAMWatt
 1.124e+08           -32.8%   75518130        will-it-scale.224.processes
      0.12 ±  3%     +26.8%       0.15        will-it-scale.224.processes_idle
    501772           -32.8%     337134        will-it-scale.per_process_ops
 1.124e+08           -32.8%   75518130        will-it-scale.workload
 1.224e+08           -63.6%   44526750        numa-numastat.node0.local_node
 1.225e+08           -63.6%   44595833        numa-numastat.node0.numa_hit
 1.247e+08           -64.8%   43916474        numa-numastat.node1.local_node
 1.248e+08           -64.7%   44011639        numa-numastat.node1.numa_hit
 1.224e+08           -63.7%   44470373        numa-numastat.node2.local_node
 1.225e+08           -63.6%   44552932        numa-numastat.node2.numa_hit
 1.198e+08           -64.2%   42880598        numa-numastat.node3.local_node
 1.199e+08           -64.2%   42983939        numa-numastat.node3.numa_hit
      9.79 ±  8%     -85.1%       1.46        perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      9.79 ±  8%     -85.1%       1.46        perf-sched.total_sch_delay.average.ms
    116.90 ±  6%     -70.8%      34.12 ±  2%  perf-sched.total_wait_and_delay.average.ms
     29376 ±  7%    +457.0%     163637        perf-sched.total_wait_and_delay.count.ms
    107.11 ±  6%     -69.5%      32.66 ±  2%  perf-sched.total_wait_time.average.ms
    116.90 ±  6%     -70.8%      34.12 ±  2%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     29376 ±  7%    +457.0%     163637        perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
    107.11 ±  6%     -69.5%      32.66 ±  2%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
  43891245            +3.5%   45412620        proc-vmstat.nr_free_pages_blocks
     42571            +4.1%      44304        proc-vmstat.nr_kernel_stack
     11026            -3.1%      10681 ±  4%  proc-vmstat.nr_page_table_pages
   1023111 ±  5%     -42.6%     587142 ±  4%  proc-vmstat.nr_slab_unreclaimable
 4.897e+08           -64.0%  1.762e+08        proc-vmstat.numa_hit
 4.893e+08           -64.1%  1.758e+08        proc-vmstat.numa_local
 1.988e+09           -65.5%  6.856e+08        proc-vmstat.pgalloc_normal
 1.987e+09           -65.6%  6.843e+08        proc-vmstat.pgfree
   1035692 ±  6%     -39.7%     624584 ±  5%  numa-meminfo.node0.SUnreclaim
   1058283 ±  6%     -37.1%     665752 ±  7%  numa-meminfo.node0.Slab
     41586 ± 66%     -73.5%      11030 ±103%  numa-meminfo.node1.Mapped
   3109692 ± 44%     -54.5%    1413986 ± 23%  numa-meminfo.node1.MemUsed
   1010583 ±  8%     -41.1%     595132 ±  7%  numa-meminfo.node1.SUnreclaim
   1070684 ±  7%     -41.0%     631765 ±  7%  numa-meminfo.node1.Slab
    974105 ±  7%     -41.5%     569763 ±  7%  numa-meminfo.node2.SUnreclaim
      2867 ± 17%   +4632.2%     135676 ±107%  numa-meminfo.node2.Shmem
    995610 ±  8%     -39.4%     603137 ±  7%  numa-meminfo.node2.Slab
    986763 ±  9%     -42.8%     564018 ±  5%  numa-meminfo.node3.SUnreclaim
   1031401 ±  9%     -41.7%     601587 ±  4%  numa-meminfo.node3.Slab
    246455 ±  6%     -36.4%     156760 ±  4%  numa-vmstat.node0.nr_slab_unreclaimable
 1.225e+08           -63.6%   44594040        numa-vmstat.node0.numa_hit
 1.224e+08           -63.6%   44524957        numa-vmstat.node0.numa_local
     10428 ± 66%     -73.6%       2748 ±103%  numa-vmstat.node1.nr_mapped
    234207 ±  9%     -35.7%     150515 ±  8%  numa-vmstat.node1.nr_slab_unreclaimable
 1.248e+08           -64.7%   44009980        numa-vmstat.node1.numa_hit
 1.247e+08           -64.8%   43914814        numa-vmstat.node1.numa_local
    716.36 ± 17%   +4634.4%      33915 ±107%  numa-vmstat.node2.nr_shmem
    224298 ±  7%     -36.2%     143071 ±  6%  numa-vmstat.node2.nr_slab_unreclaimable
 1.225e+08           -63.6%   44550930        numa-vmstat.node2.numa_hit
 1.224e+08           -63.7%   44468383        numa-vmstat.node2.numa_local
    222072 ± 10%     -36.2%     141724 ±  5%  numa-vmstat.node3.nr_slab_unreclaimable
 1.199e+08           -64.2%   42982546        numa-vmstat.node3.numa_hit
 1.198e+08           -64.2%   42879206        numa-vmstat.node3.numa_local
      1.29           +51.7%       1.96        perf-stat.i.MPKI
 1.196e+11           -33.0%  8.019e+10 ±  6%  perf-stat.i.branch-instructions
      0.14            +0.0        0.17 ± 25%  perf-stat.i.branch-miss-rate%
 1.498e+08           -28.6%  1.069e+08 ±  6%  perf-stat.i.branch-misses
     33.64           +26.5       60.19 ±  5%  perf-stat.i.cache-miss-rate%
 2.079e+09           -44.3%  1.158e+09 ±  5%  perf-stat.i.cache-references
      5465          +543.8%      35186 ±  6%  perf-stat.i.context-switches
      1.41           +61.7%       2.28 ±  7%  perf-stat.i.cpi
    430.92          +175.4%       1186 ±  5%  perf-stat.i.cpu-migrations
      1090            +8.7%       1185 ± 12%  perf-stat.i.cycles-between-cache-misses
 5.413e+11           -33.3%  3.612e+11 ±  6%  perf-stat.i.instructions
      0.71           -36.7%       0.45 ±  2%  perf-stat.i.ipc
      1.29           +53.0%       1.98        perf-stat.overall.MPKI
      0.13            +0.0        0.13        perf-stat.overall.branch-miss-rate%
     33.65           +28.0       61.66        perf-stat.overall.cache-miss-rate%
      1.41           +56.4%       2.20        perf-stat.overall.cpi
      1090            +2.3%       1115        perf-stat.overall.cycles-between-cache-misses
      0.71           -36.1%       0.45        perf-stat.overall.ipc
   1465595            +1.5%    1487296        perf-stat.overall.path-length
 1.191e+11           -32.8%      8e+10 ±  6%  perf-stat.ps.branch-instructions
 1.491e+08           -28.5%  1.066e+08 ±  6%  perf-stat.ps.branch-misses
  2.07e+09           -44.2%  1.155e+09 ±  5%  perf-stat.ps.cache-references
      5439          +545.3%      35099 ±  5%  perf-stat.ps.context-switches
    428.68          +176.1%       1183 ±  5%  perf-stat.ps.cpu-migrations
  5.39e+11           -33.1%  3.603e+11 ±  6%  perf-stat.ps.instructions
 1.647e+14           -31.8%  1.123e+14        perf-stat.total.instructions
  27898253           +15.5%   32215787 ±  5%  sched_debug.cfs_rq:/.avg_vruntime.avg
  28320859           +17.8%   33369238 ±  5%  sched_debug.cfs_rq:/.avg_vruntime.max
  20058481 ±  4%     +23.3%   24736033 ±  6%  sched_debug.cfs_rq:/.avg_vruntime.min
    655489 ±  6%     +49.4%     979168 ±  5%  sched_debug.cfs_rq:/.avg_vruntime.stddev
  12547618 ± 35%    +151.9%   31606527 ±  5%  sched_debug.cfs_rq:/.left_deadline.max
   3553201 ± 37%     +81.6%    6453093 ± 16%  sched_debug.cfs_rq:/.left_deadline.stddev
  12547461 ± 35%    +151.9%   31606425 ±  5%  sched_debug.cfs_rq:/.left_vruntime.max
   3553163 ± 37%     +81.6%    6453059 ± 16%  sched_debug.cfs_rq:/.left_vruntime.stddev
     38375 ± 43%   +2505.3%     999785 ± 45%  sched_debug.cfs_rq:/.load.avg
    392259 ± 39%  +16269.0%   64208761 ± 24%  sched_debug.cfs_rq:/.load.max
      2140 ± 12%     +44.3%       3088 ± 17%  sched_debug.cfs_rq:/.load.min
    101800 ± 34%   +7070.3%    7299363 ± 31%  sched_debug.cfs_rq:/.load.stddev
    580.87 ± 33%    +102.7%       1177 ± 14%  sched_debug.cfs_rq:/.load_avg.avg
     13113 ±  6%     +37.3%      18008 ±  6%  sched_debug.cfs_rq:/.load_avg.max
      1.64 ± 14%    +434.4%       8.76 ± 48%  sched_debug.cfs_rq:/.load_avg.min
      2024 ± 20%     +36.0%       2752 ± 16%  sched_debug.cfs_rq:/.load_avg.stddev
      1.36 ± 10%    +129.4%       3.12 ± 20%  sched_debug.cfs_rq:/.nr_queued.max
      0.14 ± 20%    +110.4%       0.30 ± 29%  sched_debug.cfs_rq:/.nr_queued.stddev
  12547461 ± 35%    +151.9%   31606429 ±  5%  sched_debug.cfs_rq:/.right_vruntime.max
   3553163 ± 37%     +81.6%    6453072 ± 16%  sched_debug.cfs_rq:/.right_vruntime.stddev
    242.06 ± 21%     +56.6%     379.09 ± 15%  sched_debug.cfs_rq:/.util_avg.min
    464.83 ±  5%      -9.4%     421.15 ±  7%  sched_debug.cfs_rq:/.util_est.avg
  27882255           +15.5%   32212264 ±  5%  sched_debug.cfs_rq:/.zero_vruntime.avg
  28305796           +17.9%   33365700 ±  5%  sched_debug.cfs_rq:/.zero_vruntime.max
  20048781 ±  4%     +23.4%   24732987 ±  6%  sched_debug.cfs_rq:/.zero_vruntime.min
    655026 ±  6%     +49.4%     978931 ±  5%  sched_debug.cfs_rq:/.zero_vruntime.stddev
     42294 ±  7%     +29.0%      54565 ±  4%  sched_debug.cpu.avg_idle.stddev
    939.51           +45.0%       1362 ±  2%  sched_debug.cpu.clock_task.stddev
      0.22 ± 11%     +48.5%       0.33 ± 25%  sched_debug.cpu.nr_running.stddev
      4751          +443.2%      25812 ±  5%  sched_debug.cpu.nr_switches.avg
     21779 ± 17%    +130.7%      50250 ±  3%  sched_debug.cpu.nr_switches.max
      2615          +383.8%      12654 ±  5%  sched_debug.cpu.nr_switches.min
      2351 ±  7%    +304.5%       9510 ±  3%  sched_debug.cpu.nr_switches.stddev
      0.00           -51.2%       0.00 ±  5%  sched_debug.rt_rq:.rt_nr_running.avg
      0.33           -51.2%       0.16 ±  5%  sched_debug.rt_rq:.rt_nr_running.max
      0.02           -51.2%       0.01 ±  5%  sched_debug.rt_rq:.rt_nr_running.stddev
     28.25           -17.4       10.82 ±  2%  perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
     28.25           -17.4       10.82 ±  2%  perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     28.26           -17.4       10.84 ±  2%  perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     28.24           -17.4       10.82 ±  2%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
     28.24           -17.4       10.82 ±  2%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
     27.84           -17.3       10.56 ±  2%  perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
     27.21           -16.7       10.53 ±  2%  perf-profile.calltrace.cycles-pp.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs
     25.64           -16.3        9.29 ±  3%  perf-profile.calltrace.cycles-pp.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
     24.89           -16.0        8.88 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch
     24.62           -15.9        8.76 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf
     28.26           -13.1       15.19        perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
     28.26           -13.1       15.19        perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
     28.26           -13.1       15.19        perf-profile.calltrace.cycles-pp.ret_from_fork_asm
      5.98            -6.0        0.00        perf-profile.calltrace.cycles-pp.__refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
     13.29            -5.9        7.35        perf-profile.calltrace.cycles-pp.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
      9.69            -4.2        5.46        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7.32            -3.2        4.12        perf-profile.calltrace.cycles-pp.vma_merge_new_range.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      6.59            -2.9        3.70        perf-profile.calltrace.cycles-pp.vma_expand.vma_merge_new_range.do_brk_flags.__do_sys_brk.do_syscall_64
      5.85            -2.7        3.19        perf-profile.calltrace.cycles-pp.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      5.21            -2.4        2.82        perf-profile.calltrace.cycles-pp.commit_merge.vma_expand.vma_merge_new_range.do_brk_flags.__do_sys_brk
      6.85            -2.1        4.70        perf-profile.calltrace.cycles-pp.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.48            -1.6        1.84        perf-profile.calltrace.cycles-pp.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      3.57            -1.6        1.93        perf-profile.calltrace.cycles-pp.perf_event_mmap.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      6.15            -1.5        4.64        perf-profile.calltrace.cycles-pp.vma_complete.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      5.82            -1.4        4.46        perf-profile.calltrace.cycles-pp.mas_store_prealloc.vma_complete.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap
      2.91            -1.3        1.58        perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.do_brk_flags.__do_sys_brk.do_syscall_64
      3.68            -1.3        2.41        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      2.66            -1.3        1.41        perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      1.94            -1.2        0.75        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.brk
      2.49            -1.2        1.30        perf-profile.calltrace.cycles-pp.mas_find.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
      2.42            -1.1        1.34        perf-profile.calltrace.cycles-pp.mas_store_prealloc.commit_merge.vma_expand.vma_merge_new_range.do_brk_flags
      2.11            -1.0        1.14        perf-profile.calltrace.cycles-pp.clear_bhb_loop.brk
      4.84            -0.9        3.92        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.vma_complete.__split_vma.vms_gather_munmap_vmas
      1.91            -0.9        1.00        perf-profile.calltrace.cycles-pp.mas_walk.mas_find.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.05            -0.8        1.20        perf-profile.calltrace.cycles-pp.vm_area_dup.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      1.74            -0.8        0.93        perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas
      1.72            -0.8        0.96        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap
      1.43            -0.7        0.75        perf-profile.calltrace.cycles-pp.mas_preallocate.commit_merge.vma_expand.vma_merge_new_range.do_brk_flags
      1.36 ±  3%      -0.6        0.72        perf-profile.calltrace.cycles-pp.perf_iterate_sb.perf_event_mmap_event.perf_event_mmap.do_brk_flags.__do_sys_brk
      1.59            -0.6        0.98        perf-profile.calltrace.cycles-pp.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      1.29            -0.6        0.69        perf-profile.calltrace.cycles-pp.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      1.26            -0.6        0.68        perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes
      1.18            -0.6        0.62        perf-profile.calltrace.cycles-pp.mas_prev_slot.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      1.15            -0.6        0.59        perf-profile.calltrace.cycles-pp.check_brk_limits.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
      1.26            -0.5        0.72        perf-profile.calltrace.cycles-pp.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      1.12            -0.5        0.60        perf-profile.calltrace.cycles-pp.__memcg_slab_post_alloc_hook.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas
      1.21            -0.5        0.70        perf-profile.calltrace.cycles-pp.mas_update_gap.mas_store_prealloc.commit_merge.vma_expand.vma_merge_new_range
      1.19            -0.4        0.76        perf-profile.calltrace.cycles-pp.mas_store_gfp.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      0.88            -0.4        0.50        perf-profile.calltrace.cycles-pp.mas_leaf_max_gap.mas_update_gap.mas_store_prealloc.commit_merge.vma_expand
      0.98            -0.4        0.62        perf-profile.calltrace.cycles-pp.__vma_start_write.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      0.88 ±  3%      -0.3        0.56 ±  2%  perf-profile.calltrace.cycles-pp.__memcg_slab_free_hook.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      0.92            -0.3        0.61        perf-profile.calltrace.cycles-pp.__vma_start_write.vma_expand.vma_merge_new_range.do_brk_flags.__do_sys_brk
      0.82            -0.2        0.60 ±  2%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk
      0.89            -0.2        0.69        perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc.vma_complete.__split_vma
      1.46 ±  2%      +0.1        1.58        perf-profile.calltrace.cycles-pp.memcpy_orig.mas_wr_node_store.mas_store_prealloc.vma_complete.__split_vma
      0.39 ± 71%      +0.3        0.66 ±  9%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.free_pcppages_bulk.free_frozen_page_commit.__free_frozen_pages.__kmem_cache_free_bulk
      1.79 ±  3%      +0.4        2.22 ±  2%  perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk
      0.19 ±141%      +0.5        0.65 ±  9%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.free_pcppages_bulk.free_frozen_page_commit.__free_frozen_pages
      0.00            +0.5        0.53 ±  4%  perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
      0.00            +0.5        0.54 ±  3%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
      0.00            +0.5        0.54 ±  4%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      0.00            +0.5        0.54 ±  4%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.kmem_cache_free_bulk.kvfree_rcu_bulk
      0.00            +0.5        0.54 ±  4%  perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.kmem_cache_free_bulk
      0.00            +0.5        0.55 ±  4%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_monitor.process_one_work
      0.00            +0.5        0.55 ±  4%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_monitor
      0.00            +1.0        1.05 ±  6%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_work
      0.00            +1.1        1.11 ±  6%  perf-profile.calltrace.cycles-pp.__slab_free.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_work.process_one_work
      0.00            +1.5        1.46 ±  7%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_monitor
      0.00            +1.5        1.52 ±  7%  perf-profile.calltrace.cycles-pp.__slab_free.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_monitor.process_one_work
      0.00            +1.8        1.78 ±  4%  perf-profile.calltrace.cycles-pp.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_work.process_one_work.worker_thread
      0.00            +1.8        1.78 ±  4%  perf-profile.calltrace.cycles-pp.kvfree_rcu_bulk.kfree_rcu_work.process_one_work.worker_thread.kthread
      0.00            +1.8        1.79 ±  4%  perf-profile.calltrace.cycles-pp.kfree_rcu_work.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +2.2        2.24 ±  3%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__refill_objects_node.__refill_objects_any
      0.00            +2.2        2.25 ±  3%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__refill_objects_node.__refill_objects_any.refill_objects
      0.00            +2.3        2.25 ±  3%  perf-profile.calltrace.cycles-pp.__slab_free.__refill_objects_node.__refill_objects_any.refill_objects.__pcs_replace_empty_main
      0.00            +2.3        2.34        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__refill_objects_node.refill_objects
      0.00            +2.4        2.36        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__refill_objects_node.refill_objects.__pcs_replace_empty_main
      0.00            +2.4        2.41        perf-profile.calltrace.cycles-pp.__slab_free.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +2.5        2.47 ±  3%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.kmem_cache_free_bulk.kvfree_rcu_bulk
      0.00            +2.5        2.50 ±  5%  perf-profile.calltrace.cycles-pp.kmem_cache_free_bulk.kvfree_rcu_bulk.kfree_rcu_monitor.process_one_work.worker_thread
      0.00            +2.5        2.50 ±  6%  perf-profile.calltrace.cycles-pp.kvfree_rcu_bulk.kfree_rcu_monitor.process_one_work.worker_thread.kthread
      0.00            +2.5        2.52 ±  5%  perf-profile.calltrace.cycles-pp.kfree_rcu_monitor.process_one_work.worker_thread.kthread.ret_from_fork
      0.00            +4.1        4.08 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.alloc_from_new_slab.refill_objects.__pcs_replace_empty_main
      0.00            +4.2        4.18 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.alloc_from_new_slab.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +4.3        4.34 ±  2%  perf-profile.calltrace.cycles-pp.process_one_work.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.00            +4.4        4.35 ±  2%  perf-profile.calltrace.cycles-pp.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.00            +4.4        4.39 ±  2%  perf-profile.calltrace.cycles-pp.alloc_from_new_slab.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00           +11.5       11.46        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main
      0.00           +11.7       11.66        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     71.31           +12.7       83.99        perf-profile.calltrace.cycles-pp.brk
     65.80           +15.1       80.88        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.brk
     65.43           +15.2       80.67        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
     63.58           +16.0       79.57        perf-profile.calltrace.cycles-pp.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
      0.00           +16.5       16.54        perf-profile.calltrace.cycles-pp.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00           +19.4       19.42        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__refill_objects_node.__refill_objects_any.refill_objects
      0.00           +19.6       19.60        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__refill_objects_node.__refill_objects_any.refill_objects.__pcs_replace_empty_main
      0.00           +23.2       23.16        perf-profile.calltrace.cycles-pp.__refill_objects_node.__refill_objects_any.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00           +23.6       23.60        perf-profile.calltrace.cycles-pp.__refill_objects_any.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
     43.10           +25.3       68.41        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
     25.61           +32.1       57.73        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
     20.04           +34.5       54.56        perf-profile.calltrace.cycles-pp.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      8.83           +38.1       46.98        perf-profile.calltrace.cycles-pp.mas_preallocate.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      7.38           +38.8       46.20        perf-profile.calltrace.cycles-pp.mas_alloc_nodes.mas_preallocate.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap
      7.31           +38.8       46.16        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__split_vma.vms_gather_munmap_vmas
      6.47           +39.2       45.68        perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__split_vma
      0.00           +45.2       45.23        perf-profile.calltrace.cycles-pp.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
     28.25           -17.4       10.82 ±  2%  perf-profile.children.cycles-pp.run_ksoftirqd
     28.26           -17.4       10.84 ±  2%  perf-profile.children.cycles-pp.smpboot_thread_fn
     29.03           -15.0       14.06        perf-profile.children.cycles-pp.rcu_core
     29.02           -15.0       14.05        perf-profile.children.cycles-pp.rcu_do_batch
     29.04           -14.9       14.09        perf-profile.children.cycles-pp.handle_softirqs
     28.56           -14.9       13.69        perf-profile.children.cycles-pp.rcu_free_sheaf
     27.97           -14.7       13.31        perf-profile.children.cycles-pp.__kmem_cache_free_bulk
     28.26           -13.1       15.19        perf-profile.children.cycles-pp.kthread
     28.26           -13.1       15.19        perf-profile.children.cycles-pp.ret_from_fork
     28.26           -13.1       15.19        perf-profile.children.cycles-pp.ret_from_fork_asm
     26.68            -7.4       19.28        perf-profile.children.cycles-pp.__slab_free
      6.18            -6.2        0.00        perf-profile.children.cycles-pp.__refill_objects
     13.34            -6.0        7.37        perf-profile.children.cycles-pp.do_brk_flags
      9.76            -4.3        5.49        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      7.37            -3.2        4.14        perf-profile.children.cycles-pp.vma_merge_new_range
      6.64            -2.9        3.72        perf-profile.children.cycles-pp.vma_expand
      5.90            -2.7        3.22        perf-profile.children.cycles-pp.vms_clear_ptes
      8.15            -2.6        5.52        perf-profile.children.cycles-pp.mas_store_gfp
      5.56            -2.6        2.97        perf-profile.children.cycles-pp.mas_find
      8.26            -2.5        5.81        perf-profile.children.cycles-pp.mas_store_prealloc
      5.32            -2.4        2.88        perf-profile.children.cycles-pp.commit_merge
      9.46            -2.0        7.45        perf-profile.children.cycles-pp.mas_wr_node_store
      3.51            -1.7        1.85        perf-profile.children.cycles-pp.unmap_vmas
      3.58            -1.6        1.94        perf-profile.children.cycles-pp.perf_event_mmap
      6.33            -1.6        4.75        perf-profile.children.cycles-pp.vma_complete
      3.06            -1.4        1.66        perf-profile.children.cycles-pp.perf_event_mmap_event
      2.70            -1.3        1.43        perf-profile.children.cycles-pp.unmap_page_range
      2.67            -1.2        1.45        perf-profile.children.cycles-pp.mas_update_gap
      2.40            -1.1        1.27        perf-profile.children.cycles-pp.mas_walk
      2.17            -1.0        1.16        perf-profile.children.cycles-pp.mas_wr_store_type
      2.13            -1.0        1.15        perf-profile.children.cycles-pp.clear_bhb_loop
      1.41            -0.9        0.52 ±  2%  perf-profile.children.cycles-pp.allocate_slab
      2.08            -0.9        1.22        perf-profile.children.cycles-pp.vm_area_dup
      1.79            -0.8        0.96        perf-profile.children.cycles-pp.mas_leaf_max_gap
      1.79            -0.8        0.96        perf-profile.children.cycles-pp.zap_pmd_range
      1.62            -0.8        0.86        perf-profile.children.cycles-pp.mas_prev_slot
      1.58            -0.7        0.86        perf-profile.children.cycles-pp.mas_next_slot
      1.67            -0.7        0.97        perf-profile.children.cycles-pp.its_return_thunk
      1.09            -0.7        0.39 ±  2%  perf-profile.children.cycles-pp.shuffle_freelist
      1.94            -0.7        1.25        perf-profile.children.cycles-pp.__vma_start_write
      1.39 ±  3%      -0.7        0.74        perf-profile.children.cycles-pp.perf_iterate_sb
      1.42            -0.6        0.80        perf-profile.children.cycles-pp.free_pgtables
      1.60            -0.6        0.98        perf-profile.children.cycles-pp.kmem_cache_free
      1.30            -0.6        0.70        perf-profile.children.cycles-pp.zap_pte_range
      1.16            -0.6        0.60        perf-profile.children.cycles-pp.check_brk_limits
      1.42            -0.6        0.87        perf-profile.children.cycles-pp.entry_SYSCALL_64
      1.12            -0.5        0.59        perf-profile.children.cycles-pp.__cond_resched
      1.13            -0.5        0.60        perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      0.99            -0.5        0.51        perf-profile.children.cycles-pp.__get_unmapped_area
      1.34            -0.5        0.87        perf-profile.children.cycles-pp.__vma_enter_locked
      0.95            -0.4        0.51        perf-profile.children.cycles-pp.security_vm_enough_memory_mm
      0.81            -0.4        0.40        perf-profile.children.cycles-pp.init_multi_vma_prep
      0.88 ±  3%      -0.3        0.56 ±  2%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.48            -0.3        0.17 ±  2%  perf-profile.children.cycles-pp.setup_object
      0.75            -0.3        0.44        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.68            -0.3        0.40        perf-profile.children.cycles-pp.down_write_killable
      0.57            -0.3        0.30        perf-profile.children.cycles-pp.mas_wr_store_entry
      0.60            -0.3        0.35        perf-profile.children.cycles-pp.__pte_offset_map_lock
      0.50            -0.2        0.25        perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.76            -0.2        0.53 ±  2%  perf-profile.children.cycles-pp.__kfree_rcu_sheaf
      0.51 ±  2%      -0.2        0.29 ±  2%  perf-profile.children.cycles-pp.perf_event_mmap_output
      0.56            -0.2        0.34 ±  2%  perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
      0.46            -0.2        0.25        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      0.41            -0.2        0.20        perf-profile.children.cycles-pp.vma_adjust_trans_huge
      0.42            -0.2        0.21 ±  2%  perf-profile.children.cycles-pp.mas_prev_range
      0.44            -0.2        0.26        perf-profile.children.cycles-pp.mas_prev
      0.41            -0.2        0.23        perf-profile.children.cycles-pp.can_vma_merge_left
      0.53            -0.2        0.35        perf-profile.children.cycles-pp.arch_exit_to_user_mode_prepare
      0.38            -0.2        0.20 ±  3%  perf-profile.children.cycles-pp.static_key_count
      2.23            -0.2        2.06        perf-profile.children.cycles-pp.memcpy_orig
      0.35            -0.2        0.18 ±  2%  perf-profile.children.cycles-pp.x64_sys_call
      0.30            -0.2        0.13        perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      0.45            -0.2        0.28        perf-profile.children.cycles-pp.up_read
      0.35            -0.2        0.19        perf-profile.children.cycles-pp.sized_strscpy
      1.75            -0.2        1.59        perf-profile.children.cycles-pp.kvfree_call_rcu
      0.75            -0.2        0.60        perf-profile.children.cycles-pp.build_detached_freelist
      0.33            -0.2        0.18 ±  2%  perf-profile.children.cycles-pp.rcu_all_qs
      0.34 ±  7%      -0.2        0.19        perf-profile.children.cycles-pp.obj_cgroup_charge_account
      0.31            -0.1        0.16 ±  2%  perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.33 ±  2%      -0.1        0.18 ±  2%  perf-profile.children.cycles-pp.__vm_enough_memory
      0.38            -0.1        0.24        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.25            -0.1        0.10 ±  3%  perf-profile.children.cycles-pp.get_page_from_freelist
      0.37            -0.1        0.22 ±  2%  perf-profile.children.cycles-pp.tlb_gather_mmu
      0.36 ±  3%      -0.1        0.21        perf-profile.children.cycles-pp.refill_obj_stock
      0.35            -0.1        0.21        perf-profile.children.cycles-pp.tlb_finish_mmu
      0.30            -0.1        0.18 ±  2%  perf-profile.children.cycles-pp.__kmalloc_noprof
      0.30            -0.1        0.18 ±  2%  perf-profile.children.cycles-pp.__alloc_empty_sheaf
      0.35 ±  2%      -0.1        0.22 ±  2%  perf-profile.children.cycles-pp.kfree
      0.27            -0.1        0.15        perf-profile.children.cycles-pp.mas_prev_setup
      0.36 ±  3%      -0.1        0.24 ±  6%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.25            -0.1        0.13        perf-profile.children.cycles-pp.mas_wr_slot_store
      0.36 ±  3%      -0.1        0.23 ±  5%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.23            -0.1        0.11 ±  4%  perf-profile.children.cycles-pp.userfaultfd_unmap_complete
      0.25            -0.1        0.14 ±  2%  perf-profile.children.cycles-pp.remove_vma
      0.30 ±  3%      -0.1        0.20 ±  7%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.25            -0.1        0.14 ±  3%  perf-profile.children.cycles-pp.vm_area_free
      0.24 ±  3%      -0.1        0.14 ± 11%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.26            -0.1        0.16 ±  2%  perf-profile.children.cycles-pp.vma_mark_detached
      0.20            -0.1        0.11 ±  4%  perf-profile.children.cycles-pp.strnlen
      0.22 ±  4%      -0.1        0.13 ±  2%  perf-profile.children.cycles-pp.__account_obj_stock
      0.22 ±  3%      -0.1        0.13 ±  9%  perf-profile.children.cycles-pp.update_process_times
      0.20            -0.1        0.11        perf-profile.children.cycles-pp.free_pgd_range
      0.28            -0.1        0.19        perf-profile.children.cycles-pp.downgrade_write
      0.16            -0.1        0.07        perf-profile.children.cycles-pp.rmqueue
      0.24            -0.1        0.15        perf-profile.children.cycles-pp.unlink_anon_vmas
      0.17 ±  2%      -0.1        0.09        perf-profile.children.cycles-pp.anon_vma_clone
      0.16 ±  2%      -0.1        0.08 ±  6%  perf-profile.children.cycles-pp.security_mmap_addr
      0.18 ±  2%      -0.1        0.10 ±  3%  perf-profile.children.cycles-pp.vma_prepare
      0.14            -0.1        0.06 ±  6%  perf-profile.children.cycles-pp.__rmqueue_pcplist
      0.15 ±  2%      -0.1        0.08 ±  6%  perf-profile.children.cycles-pp.mm_get_unmapped_area_vmflags
      0.15            -0.1        0.08        perf-profile.children.cycles-pp.unmap_single_vma
      0.20            -0.1        0.13 ±  3%  perf-profile.children.cycles-pp.up_write
      0.16 ±  2%      -0.1        0.09        perf-profile.children.cycles-pp.__build_id_parse
      0.14 ±  3%      -0.1        0.07        perf-profile.children.cycles-pp.rcu_cblist_dequeue
      0.14 ±  3%      -0.1        0.07        perf-profile.children.cycles-pp.strlen
      0.22 ±  4%      -0.1        0.15 ±  3%  perf-profile.children.cycles-pp.vm_area_init_from
      0.13            -0.1        0.07 ±  7%  perf-profile.children.cycles-pp.__free_one_page
      0.13            -0.1        0.07        perf-profile.children.cycles-pp.is_mergeable_anon_vma
      0.12 ±  4%      -0.1        0.06        perf-profile.children.cycles-pp.___pte_offset_map
      0.12 ±  6%      -0.1        0.07        perf-profile.children.cycles-pp.cap_capable
      0.12 ±  3%      -0.1        0.06 ±  7%  perf-profile.children.cycles-pp.may_expand_vm
      0.11 ±  4%      -0.1        0.06        perf-profile.children.cycles-pp.brk@plt
      0.11            -0.1        0.06        perf-profile.children.cycles-pp.__x64_sys_brk
      0.10 ±  4%      -0.0        0.05        perf-profile.children.cycles-pp.userfaultfd_unmap_prep
      0.12 ±  3%      -0.0        0.08 ±  6%  perf-profile.children.cycles-pp.finish_rcuwait
      0.24 ±  2%      -0.0        0.20 ±  2%  perf-profile.children.cycles-pp._raw_spin_lock
      0.07 ± 15%      -0.0        0.04 ± 71%  perf-profile.children.cycles-pp.cap_vm_enough_memory
      0.10 ±  8%      -0.0        0.06 ±  6%  perf-profile.children.cycles-pp.is_vmalloc_addr
      0.10 ±  3%      -0.0        0.07 ±  5%  perf-profile.children.cycles-pp.khugepaged_enter_vma
      0.08 ± 12%      -0.0        0.05        perf-profile.children.cycles-pp.testcase
      0.10 ±  4%      -0.0        0.08 ±  5%  perf-profile.children.cycles-pp.sched_tick
      0.28 ±  8%      +0.0        0.31 ±  7%  perf-profile.children.cycles-pp.cmd_record
      0.20 ±  6%      +0.0        0.25 ± 10%  perf-profile.children.cycles-pp.reader__read_event
      0.16 ± 16%      +0.1        0.21 ± 11%  perf-profile.children.cycles-pp.ordered_events__queue
      0.16 ± 14%      +0.1        0.22 ±  9%  perf-profile.children.cycles-pp.process_simple
      0.15 ± 17%      +0.1        0.21 ± 11%  perf-profile.children.cycles-pp.queue_event
      0.00            +0.1        0.12 ±  3%  perf-profile.children.cycles-pp.get_state_synchronize_rcu_full
      1.01 ±  2%      +0.2        1.19 ±  2%  perf-profile.children.cycles-pp.__pi_memcpy
      0.70 ±  9%      +0.6        1.28 ±  6%  perf-profile.children.cycles-pp.free_pcppages_bulk
      0.78 ±  8%      +0.6        1.39 ±  6%  perf-profile.children.cycles-pp.__free_frozen_pages
      0.72 ±  9%      +0.6        1.34 ±  6%  perf-profile.children.cycles-pp.free_frozen_page_commit
      0.00            +1.8        1.79 ±  4%  perf-profile.children.cycles-pp.kfree_rcu_work
      1.14 ±  3%      +2.4        3.50 ±  4%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      1.17 ±  3%      +2.4        3.54 ±  4%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.77 ±  3%      +2.5        3.27 ±  4%  perf-profile.children.cycles-pp.__irq_exit_rcu
      0.00            +2.5        2.52 ±  5%  perf-profile.children.cycles-pp.kfree_rcu_monitor
      0.65            +3.7        4.39 ±  2%  perf-profile.children.cycles-pp.alloc_from_new_slab
      0.00            +4.3        4.28 ±  2%  perf-profile.children.cycles-pp.kmem_cache_free_bulk
      0.00            +4.3        4.28 ±  2%  perf-profile.children.cycles-pp.kvfree_rcu_bulk
      0.00            +4.3        4.34 ±  2%  perf-profile.children.cycles-pp.process_one_work
      0.00            +4.4        4.35 ±  2%  perf-profile.children.cycles-pp.worker_thread
     71.34           +13.1       84.41        perf-profile.children.cycles-pp.brk
     65.92           +15.0       80.97        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     65.55           +15.2       80.75        perf-profile.children.cycles-pp.do_syscall_64
     63.69           +15.9       79.63        perf-profile.children.cycles-pp.__do_sys_brk
      0.00           +23.6       23.61        perf-profile.children.cycles-pp.__refill_objects_any
     43.14           +25.3       68.42        perf-profile.children.cycles-pp.do_vmi_align_munmap
     28.16           +27.0       55.18        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     28.78           +27.2       55.94        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     25.72           +32.1       57.79        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
     20.22           +34.4       54.65        perf-profile.children.cycles-pp.__split_vma
     10.29           +37.5       47.74        perf-profile.children.cycles-pp.mas_preallocate
      9.46           +37.9       47.36        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
      7.40           +38.8       46.21        perf-profile.children.cycles-pp.mas_alloc_nodes
      6.68           +39.1       45.80        perf-profile.children.cycles-pp.__pcs_replace_empty_main
      0.00           +39.8       39.83        perf-profile.children.cycles-pp.__refill_objects_node
      0.00           +45.4       45.35        perf-profile.children.cycles-pp.refill_objects
      2.24            -1.1        1.16        perf-profile.self.cycles-pp.mas_walk
      3.85            -1.0        2.87        perf-profile.self.cycles-pp.mas_wr_node_store
      2.10            -1.0        1.11        perf-profile.self.cycles-pp.mas_wr_store_type
      2.11            -1.0        1.14        perf-profile.self.cycles-pp.clear_bhb_loop
      1.74            -0.9        0.87        perf-profile.self.cycles-pp.__do_sys_brk
      1.93            -0.8        1.10        perf-profile.self.cycles-pp.mas_store_gfp
      1.72            -0.8        0.90        perf-profile.self.cycles-pp.mas_leaf_max_gap
      1.65            -0.8        0.87        perf-profile.self.cycles-pp.mas_store_prealloc
      1.59            -0.8        0.83        perf-profile.self.cycles-pp.mas_prev_slot
      1.58            -0.8        0.82        perf-profile.self.cycles-pp.mas_find
      1.52            -0.7        0.78        perf-profile.self.cycles-pp.mas_preallocate
      1.46            -0.7        0.79        perf-profile.self.cycles-pp.mas_next_slot
      1.34            -0.6        0.73        perf-profile.self.cycles-pp.its_return_thunk
      0.94 ±  2%      -0.6        0.34 ±  3%  perf-profile.self.cycles-pp.shuffle_freelist
      1.38            -0.6        0.81        perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      0.98            -0.5        0.52        perf-profile.self.cycles-pp.do_brk_flags
      0.85 ±  4%      -0.4        0.43 ±  3%  perf-profile.self.cycles-pp.perf_iterate_sb
      1.17            -0.4        0.76        perf-profile.self.cycles-pp.__vma_enter_locked
      0.77            -0.4        0.37        perf-profile.self.cycles-pp.init_multi_vma_prep
      0.77            -0.4        0.39        perf-profile.self.cycles-pp.unmap_page_range
      0.76 ±  3%      -0.4        0.40 ±  2%  perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.77            -0.4        0.41        perf-profile.self.cycles-pp.__split_vma
      0.78            -0.4        0.42        perf-profile.self.cycles-pp.mas_update_gap
      0.70            -0.4        0.35        perf-profile.self.cycles-pp.__cond_resched
      0.73            -0.4        0.38        perf-profile.self.cycles-pp.do_syscall_64
      0.73            -0.3        0.39        perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.74            -0.3        0.41        perf-profile.self.cycles-pp.perf_event_mmap_event
      0.62            -0.3        0.30        perf-profile.self.cycles-pp.zap_pte_range
      0.77            -0.3        0.46        perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      0.72            -0.3        0.42        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.70 ±  3%      -0.3        0.41 ±  2%  perf-profile.self.cycles-pp.kmem_cache_free
      0.56            -0.3        0.30        perf-profile.self.cycles-pp.commit_merge
      0.71            -0.3        0.46 ±  2%  perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.51 ±  2%      -0.2        0.26        perf-profile.self.cycles-pp.perf_event_mmap
      0.49            -0.2        0.25        perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.49            -0.2        0.26        perf-profile.self.cycles-pp.mas_wr_store_entry
      0.46 ±  2%      -0.2        0.23 ±  2%  perf-profile.self.cycles-pp.__kfree_rcu_sheaf
      0.50 ±  2%      -0.2        0.28        perf-profile.self.cycles-pp.perf_event_mmap_output
      0.75            -0.2        0.52        perf-profile.self.cycles-pp.__slab_free
      0.56            -0.2        0.34 ±  2%  perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
      0.43 ±  2%      -0.2        0.21 ±  2%  perf-profile.self.cycles-pp.security_vm_enough_memory_mm
      0.44            -0.2        0.24        perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
      0.47 ±  2%      -0.2        0.27 ±  2%  perf-profile.self.cycles-pp.vma_complete
      0.55            -0.2        0.35 ±  2%  perf-profile.self.cycles-pp.__vma_start_write
      0.45            -0.2        0.25        perf-profile.self.cycles-pp.free_pgtables
      0.42            -0.2        0.22 ±  3%  perf-profile.self.cycles-pp.vms_complete_munmap_vmas
      0.75 ±  2%      -0.2        0.55        perf-profile.self.cycles-pp.build_detached_freelist
      0.38            -0.2        0.18 ±  2%  perf-profile.self.cycles-pp.vma_adjust_trans_huge
      2.14            -0.2        1.95        perf-profile.self.cycles-pp.memcpy_orig
      0.50 ±  8%      -0.2        0.32 ±  3%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.38            -0.2        0.20        perf-profile.self.cycles-pp.unmap_vmas
      0.50            -0.2        0.33 ±  2%  perf-profile.self.cycles-pp.arch_exit_to_user_mode_prepare
      0.33            -0.2        0.16 ±  3%  perf-profile.self.cycles-pp.x64_sys_call
      0.34            -0.2        0.18 ±  2%  perf-profile.self.cycles-pp.zap_pmd_range
      0.40            -0.2        0.24        perf-profile.self.cycles-pp.vma_expand
      0.43            -0.2        0.27        perf-profile.self.cycles-pp.up_read
      0.36            -0.1        0.21        perf-profile.self.cycles-pp.tlb_gather_mmu
      0.34            -0.1        0.20        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.40            -0.1        0.26        perf-profile.self.cycles-pp.down_write_killable
      0.26            -0.1        0.12        perf-profile.self.cycles-pp.__get_unmapped_area
      0.29            -0.1        0.15        perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.30            -0.1        0.16        perf-profile.self.cycles-pp.sized_strscpy
      0.28            -0.1        0.14        perf-profile.self.cycles-pp.mas_prev_range
      0.29            -0.1        0.16 ±  4%  perf-profile.self.cycles-pp.static_key_count
      0.30            -0.1        0.17        perf-profile.self.cycles-pp.mas_prev
      0.32            -0.1        0.19        perf-profile.self.cycles-pp.tlb_finish_mmu
      0.26            -0.1        0.14 ±  2%  perf-profile.self.cycles-pp.vms_clear_ptes
      0.24            -0.1        0.12        perf-profile.self.cycles-pp.mas_wr_slot_store
      0.24            -0.1        0.12 ±  3%  perf-profile.self.cycles-pp.vma_merge_new_range
      0.24            -0.1        0.13        perf-profile.self.cycles-pp.mas_prev_setup
      1.12 ±  2%      -0.1        1.01        perf-profile.self.cycles-pp.brk
      0.23            -0.1        0.12 ±  3%  perf-profile.self.cycles-pp.rcu_all_qs
      0.27            -0.1        0.16 ±  2%  perf-profile.self.cycles-pp.kfree
      0.24            -0.1        0.13 ±  2%  perf-profile.self.cycles-pp.can_vma_merge_left
      0.22 ±  4%      -0.1        0.12 ±  3%  perf-profile.self.cycles-pp.refill_obj_stock
      0.24            -0.1        0.14 ±  3%  perf-profile.self.cycles-pp.__pte_offset_map_lock
      0.20            -0.1        0.10        perf-profile.self.cycles-pp.userfaultfd_unmap_complete
      0.19            -0.1        0.10        perf-profile.self.cycles-pp.strnlen
      0.21 ±  4%      -0.1        0.12        perf-profile.self.cycles-pp.__account_obj_stock
      0.27            -0.1        0.18        perf-profile.self.cycles-pp.downgrade_write
      0.22 ±  2%      -0.1        0.14        perf-profile.self.cycles-pp.vma_mark_detached
      0.17 ±  4%      -0.1        0.08 ±  5%  perf-profile.self.cycles-pp.__vm_enough_memory
      0.17 ±  4%      -0.1        0.09        perf-profile.self.cycles-pp.obj_cgroup_charge_account
      0.18 ±  2%      -0.1        0.10        perf-profile.self.cycles-pp.free_pgd_range
      0.20            -0.1        0.12        perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.17 ±  2%      -0.1        0.10 ±  5%  perf-profile.self.cycles-pp.check_brk_limits
      0.18            -0.1        0.11        perf-profile.self.cycles-pp.unlink_anon_vmas
      0.14            -0.1        0.07        perf-profile.self.cycles-pp.unmap_single_vma
      0.15 ±  2%      -0.1        0.08        perf-profile.self.cycles-pp.anon_vma_clone
      0.20            -0.1        0.13        perf-profile.self.cycles-pp.up_write
      0.17 ±  2%      -0.1        0.10 ±  4%  perf-profile.self.cycles-pp.alloc_from_new_slab
      0.14 ±  3%      -0.1        0.07        perf-profile.self.cycles-pp.rcu_cblist_dequeue
      0.16 ±  3%      -0.1        0.09        perf-profile.self.cycles-pp.__build_id_parse
      0.83            -0.1        0.76        perf-profile.self.cycles-pp.kvfree_call_rcu
      0.12            -0.1        0.06        perf-profile.self.cycles-pp.__free_one_page
      0.13            -0.1        0.07        perf-profile.self.cycles-pp.vma_prepare
      0.12 ±  3%      -0.1        0.06        perf-profile.self.cycles-pp.strlen
      0.20 ±  4%      -0.1        0.14        perf-profile.self.cycles-pp.vm_area_init_from
      0.12 ±  6%      -0.1        0.07        perf-profile.self.cycles-pp.cap_capable
      0.11 ±  3%      -0.1        0.06        perf-profile.self.cycles-pp.may_expand_vm
      0.11 ±  3%      -0.1        0.06        perf-profile.self.cycles-pp.mm_get_unmapped_area_vmflags
      0.10            -0.1        0.05        perf-profile.self.cycles-pp.mas_alloc_nodes
      0.11            -0.1        0.06        perf-profile.self.cycles-pp.___pte_offset_map
      0.11            -0.1        0.06        perf-profile.self.cycles-pp.is_mergeable_anon_vma
      0.07 ± 14%      -0.0        0.03 ±100%  perf-profile.self.cycles-pp.cap_vm_enough_memory
      0.23            -0.0        0.19        perf-profile.self.cycles-pp._raw_spin_lock
      0.10 ±  4%      -0.0        0.06 ±  7%  perf-profile.self.cycles-pp.finish_rcuwait
      0.13 ±  3%      -0.0        0.09        perf-profile.self.cycles-pp.vm_area_dup
      0.07 ± 10%      -0.0        0.04 ± 44%  perf-profile.self.cycles-pp.testcase
      0.07 ±  5%      -0.0        0.04 ± 44%  perf-profile.self.cycles-pp.__pi_memcpy
      0.07 ± 11%      -0.0        0.04 ± 44%  perf-profile.self.cycles-pp.is_vmalloc_addr
      0.08            -0.0        0.06 ±  8%  perf-profile.self.cycles-pp.khugepaged_enter_vma
      0.09 ±  4%      -0.0        0.07        perf-profile.self.cycles-pp.rcu_free_sheaf
      0.11            -0.0        0.10        perf-profile.self.cycles-pp.__pcs_replace_empty_main
      0.15 ± 19%      +0.1        0.20 ± 10%  perf-profile.self.cycles-pp.queue_event
      0.00            +0.1        0.12 ±  3%  perf-profile.self.cycles-pp.get_state_synchronize_rcu_full
      0.62            +0.2        0.78        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.00            +0.2        0.18 ±  2%  perf-profile.self.cycles-pp.refill_objects
      0.00            +0.4        0.43 ±  2%  perf-profile.self.cycles-pp.__refill_objects_any
      0.00            +3.0        3.02        perf-profile.self.cycles-pp.__refill_objects_node
     28.15           +27.0       55.18        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


