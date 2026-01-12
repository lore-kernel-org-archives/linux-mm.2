Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F685C9EC93
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 14:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C23416B0088; Mon, 12 Jan 2026 09:18:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFA656B0089; Mon, 12 Jan 2026 09:18:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4F66B008A; Mon, 12 Jan 2026 09:18:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9A96B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:18:17 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3ADA51ACD2E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:18:17 +0000 (UTC)
X-FDA: 84323516634.13.0A8C349
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf26.hostedemail.com (Postfix) with ESMTP id E7E1A14000A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:18:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ntFs8NOy;
	spf=pass (imf26.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768227493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qBWyLjr/d7u8wMFMjz5LxSl0WC0PBy5yY3aQ2C0B4Uc=;
	b=MEwKOoqotP4TJL759uJAS4sLHc8R+oz+T77JYzaYkypO5SWsXfZBDXGbdh09q2i8nZWscM
	13Q/l/uFSCmxgXD1lP45s69gZYHtZIzPOPU+TdTo8ZMljKWiVotJ5Rwk2PPoC7W8Nkqa58
	5LeqEWs0G4dFj3Mj5YIl+O1qMu/zcw0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ntFs8NOy;
	spf=pass (imf26.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768227493; a=rsa-sha256;
	cv=fail;
	b=6SQ2Z2OrSfG7A8g/Fa+/2iNuRdfLxWW1yfBXXlyo2IPz6zH5Zleka06hyQARkHU8PMUj3C
	T9BOzu+ew9wZydl95t2hHqJTin7tn5yYgkYup0BX0YUq+9/l844/6R2DmXK8d6zuIp8MBL
	JjoK44ounypJjNKr1VRJ0D49iUYu+Ig=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768227493; x=1799763493;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nnCy3ZT9nb+t13BBPJzL0weXveoZhW9a27gjHMr0BUk=;
  b=ntFs8NOyLTxoXFLtVlS6vVPZkJHIAvvxpYylFRaW28QgsuHNha/RFYHX
   QZZQUCV7fHA47sYyEffkhIec2BMjD/cfoLF1hPSdQnJKgBCF7SjK+vXGx
   36J3RRdq0DjJxo8+xOtRirf0dm3x0XAgYbPAjl+MqeWQY/ffvS6XO1GkS
   WwYIValUEWHlGD/YkKg9HUiD4/dgjxyQu79GAppk+5kte9vfeOiFh6YWH
   nE1k5OIMnuBkwJvT9Dtj72jvyuBr4InZs33Oa3yt/ScOcNuB+l4RJ82EC
   6oN1/gfZh3kI+JBllLK1rCaIOplmZ5ErrxcJI3J3UiLYd86w0md2usNzD
   w==;
X-CSE-ConnectionGUID: RvGMXnKDSpuTukjrTI3+CA==
X-CSE-MsgGUID: D7qxLq96Q7yaDZFx14MdTA==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="86916626"
X-IronPort-AV: E=Sophos;i="6.21,221,1763452800"; 
   d="scan'208";a="86916626"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 06:18:11 -0800
X-CSE-ConnectionGUID: 8x/DYWLfSG+ke9+HlTIMBg==
X-CSE-MsgGUID: Pl7coaHyRqCY6S4IWpNXJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,221,1763452800"; 
   d="scan'208";a="203905711"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 06:18:11 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 06:18:10 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 12 Jan 2026 06:18:10 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.16)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 06:18:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a+GOrE/y8dRrA0G7JW69deIfaFYAF33Soy7EZaxp5jM6RHVQ9V/0oGlVwPbVB49sL4+h31UoHBAZEV80WQaJbE8kuUHTSgCTLpxxUmkUibzoH0DPJSvqmHi4LntnegeCPZwjzFNa2a4tuIr6Y+VMaECIy9XN7rhPE4VGkynYYl4xiC+SksMnVrHBkO1oOjDqR9kRUENvKHm2iIqGuta9mX/6C3MDggs89SbuIfWyVMZ/1k1vNTZWC8em2IwRLgKZ1FnskXky9opqgbq7cre5Bd91XH9jFs1fFL9T4mczgY7FAF68vG+wNZXxaRHLP5AAwTMj7Gf8YdwjvE0sLOMotw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qBWyLjr/d7u8wMFMjz5LxSl0WC0PBy5yY3aQ2C0B4Uc=;
 b=cekgotxqQiye/lX9rz7FYkTwRqAZXZ0oszrOqwTS5DjuXoFsKSYAjYq6zLpXojtmX5nmRaB9pBPgxN/6j3DRayWrjg1h5wfsO8W80qMddlHhixLWieE3yLbMLWn1Huu3CB8Uf+KeXuu+URfRcBiawE2F5cZrgX1u2n9Owo/nSmMp1KeqL6Yz46KdWTYK10MTers+QC7R+NK0bhMfCOQ5IdAdz/u34FkW5C6Qu5QOR0gC+1a3BQmSjqzPaVOjniyE6m9NAAIZ60OX7Ubva5ILI8qA6DpVUs4V2/GnciKjFJpa2tEmDGp/LVEG6IkcxgTfI5jjmWjSkbBmg1dvKNGf3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY8PR11MB7828.namprd11.prod.outlook.com (2603:10b6:930:78::8)
 by PH7PR11MB5957.namprd11.prod.outlook.com (2603:10b6:510:1e0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 14:18:04 +0000
Received: from CY8PR11MB7828.namprd11.prod.outlook.com
 ([fe80::1171:db4d:d6ad:3277]) by CY8PR11MB7828.namprd11.prod.outlook.com
 ([fe80::1171:db4d:d6ad:3277%3]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 14:18:04 +0000
Date: Mon, 12 Jan 2026 15:17:45 +0100
From: Francois Dugast <francois.dugast@intel.com>
To: <intel-xe@lists.freedesktop.org>
CC: <dri-devel@lists.freedesktop.org>, Matthew Brost
	<matthew.brost@intel.com>, Andrew Morton <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Zi Yan
	<ziy@nvidia.com>, Alistair Popple <apopple@nvidia.com>, Balbir Singh
	<balbirs@nvidia.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH v4 6/7] drm/pagemap: Correct cpages calculation for
 migrate_vma_setup
Message-ID: <aWUCiRvO25iBFP5J@fdugast-desk>
References: <20260111205820.830410-1-francois.dugast@intel.com>
 <20260111205820.830410-7-francois.dugast@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260111205820.830410-7-francois.dugast@intel.com>
Organization: Intel Corporation
X-ClientProxiedBy: DU2PR04CA0232.eurprd04.prod.outlook.com
 (2603:10a6:10:2b1::27) To CY8PR11MB7828.namprd11.prod.outlook.com
 (2603:10b6:930:78::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR11MB7828:EE_|PH7PR11MB5957:EE_
X-MS-Office365-Filtering-Correlation-Id: d677ea19-3584-47ab-aac4-08de51e5662d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?lu6g8OPQkkP9V0kyFwifCPPzz+LaguK4cZ9sdw8patzLmtFxEX4ZxwYUV7ij?=
 =?us-ascii?Q?e+UYHknlF5lPotKr0wjXOazbz3e4eY9PqXuhXhhpc/5Zq2bivG+0QLRCKXxU?=
 =?us-ascii?Q?vJY9f+we7eKHBbN/VE9qj4uxkSZFVEkf4yViRcGV0o3chnc1WZ+16nRLbG2y?=
 =?us-ascii?Q?4LgK0kSA7uAQYtn2+LPuaZaEvoZZ3EUYEofM7J9aCKaxa/zQjGcZR1rWyJ6A?=
 =?us-ascii?Q?10ugsJOD4ceeF8l/vJx9mUL6hbcBUzm5+CkSp8jvjHDkX46Gh5g1dKGPWfJl?=
 =?us-ascii?Q?ii7qjJ0la7iDgtS7vUFTS0//7IE1G3cYp2RvTvsJFVkWweQQWqzoAmF59QPa?=
 =?us-ascii?Q?Qxo0pEXIXrSEDKC5K6S7+M94SxeOgyfVTLede8sgRqC5Hf3b6SOMa6MfKjRY?=
 =?us-ascii?Q?cHIF9ryQ6HDsiYH6p3ZN/jUypeEKnIxGKjMkfHwPDOh/U+Jje6UHTuus/dJ4?=
 =?us-ascii?Q?yDBfm/iN4mA9w3SV1Z+L4xtEBi7VZXPE/jnhwYPS/NnnbjR9s4/VJq9sOaWN?=
 =?us-ascii?Q?3Wm2bzHylx7H1qSjhzZUjEwQtLdP98Sr/VlL1U+JgSXKp+PaUza+L4KXv5/k?=
 =?us-ascii?Q?wTtkpC/0kWkJRgzHLoF9VtPk19ECFqR5Bk1MqJT2UbtV3v87yjp2PBzneQ3l?=
 =?us-ascii?Q?+KWiDkqXwysZ57CfpQ3bYtsVdgmSgpCQPPoqa9+GZ0tCCQH7bI2Nm8Old/ga?=
 =?us-ascii?Q?VtuZ7gx3RdlQXWw3LKbLcUg/kaN161pFimYeY2UZ/kAe8tRoV6zMRcgf1V6y?=
 =?us-ascii?Q?ln0087jdSm7MvaEqXrbvNdpvM2CeRVwUggzLnA6kNWTjIjMQgtkQrAVfeFVb?=
 =?us-ascii?Q?lJ/a4t4k4hTHzcQK9guMoWpZbXzJv0bAHUwdgN/jYc6LjDLYeZpXmm6wwGoT?=
 =?us-ascii?Q?rdg/N0jjK2gPEzIRDBLgvH2v3LslQPu/cDJNqg7yuYKl14cBwTkcEvJ5x4uU?=
 =?us-ascii?Q?euNEBgBrf2p0Zx+qC7JOrohqJdZ3Ui8810bLepkvK42LRavwS8MTDOzVtUUa?=
 =?us-ascii?Q?GcFq4GKlzCgNDrlSqtWCq2l4Nfa9fm4xnuKI3M4XGt+LVswcqW0QxRg/v8Mi?=
 =?us-ascii?Q?e0UTHCJVQ6+C9radxZhXKoLNyFTeVtD3T5L6FuygkMcQfaruKH9kdsTd0aeF?=
 =?us-ascii?Q?OZxz5Ex9wHLGnI8q5hZelHlbhC3ahqaH1HJT4J3tMgTo4C4qIhvzWCbryds3?=
 =?us-ascii?Q?R5tBOjb1iOAZuG1E+6AY6YHNfu6EanoQfdrTemztFgZhnChODoDvpvX+r2/N?=
 =?us-ascii?Q?j75soZeJYmDinmyJp8z148eCcF58cJsfvm1e54CxIubJAUbgoX7DxT76hGbo?=
 =?us-ascii?Q?XQwWP/9QPOy1TfZ38DspKXxePCJ/3ASXC0HoqmQueAfm0rqtd4gCAWkjzcjB?=
 =?us-ascii?Q?7zt/07PCsOndW9IWH63eZ/vPEAwI6wjhhaKZpJ6mIH00uq0O+BNjUbqnXQP8?=
 =?us-ascii?Q?bDDflVvjwDLigAOhLr8RlDpvoBLWHLKn?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB7828.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NTBmYTEcEMTeMinhcND1WPR/oZROSlNSY907rTKosDOFPtBINV7zqoErLAPz?=
 =?us-ascii?Q?WAKlwrsyu7AvIcwIw7jb4CYohZRYOzFGoAhQ3r8wjFWGilNRzNx44rQN67ha?=
 =?us-ascii?Q?IJkpba9XGsvrgE/yf1NQdhddGhOhaVk0C2LQNGx1AiRIjpEQVQZwcsspOzwu?=
 =?us-ascii?Q?8BHaiFjXGdmaMG6arjgCa75f8J+2oCfCs59aoEaqA6hQT5fwsd9j8dNS0Cf+?=
 =?us-ascii?Q?zqAxORGc2lrVXU62gj3H6ru89dw4WoSbZgPZy+12B7aeo+bMYY9N0F136OGE?=
 =?us-ascii?Q?Ezo4MZnLJLq5rup8dwGQvQ/P1cSJYsXIMZrISTEXzeR1hXum8EsiXKaEVCaP?=
 =?us-ascii?Q?Wzt3A2PV1wVVn5XLfZPKLAzEd3uTxdqLgfZZf8YtjzRdbJp9Exr/5dnyYKdA?=
 =?us-ascii?Q?+2WIO0McDOvXDmVNbJWZVAWzmKRHHn0Xux8ZIUi6NMKTjnP7HnDiy/nOmfor?=
 =?us-ascii?Q?K/xVuOFS6T4ChltOo269al72ZXL72Rt2rx1bPEKWdWyXsB3fMefUsgRoKll6?=
 =?us-ascii?Q?x6N8LEz4b2XxIpa9dKFwSU43Zbjjo6VY7+fnFEIH5MMGYlEUj4pXmSR2Zt6D?=
 =?us-ascii?Q?XrOSpT3RdfmjYn/Vk+FfYSA3QJM+RB0fnj5R2NzK0LxzeJByxYXvoBaG7vwh?=
 =?us-ascii?Q?NLlD5LKXGmChwfsQlUffo8DB4h9jPxyFprSSsyt2uZZYGbaUzYPDMRKx69sp?=
 =?us-ascii?Q?Dbk12OFVoreE5pL3WKcloo3DsQnP5B/6TA2XqJJNRB24P3dBZ4grl8JPAqzS?=
 =?us-ascii?Q?+CGA3LucacPWfKLuK+9vasVxfflv1sQCVFrE0z3WL6yNW8ekdOrGu8R1WxYM?=
 =?us-ascii?Q?Z1POrf16Pr8pg+Pg+OzMV293HsU6xSpU4NXMCjZ0WLhTXC5a/SjeEhzZ1zA6?=
 =?us-ascii?Q?BZBPIx4GT4/r6ViJcn8QCNB0Iw1QRU6iYBKlQPk1VpApuq86l4d2BvA02Iuq?=
 =?us-ascii?Q?P1UdGevEU00dNI+5SYkHpCAV03Cy1+CAnxtuPJReeNBJNfXLJArRqTu6zpsE?=
 =?us-ascii?Q?K+t/eQv8CacT/ceKJD8kmzw+JRj3Um9Ri2FDHk5ktoNX175DwcFlmVjA+rzW?=
 =?us-ascii?Q?AYUYoQ5J0FDkFE1cghYNlhpiE8wjvI5P2rodYvjXD3YpqffbKmlVPNoXIcVW?=
 =?us-ascii?Q?Siy9RFFrXykIpVqIUc722nyp7rlyV6kI+I4o03HNf33OTCZ8oXGO45hLnfFF?=
 =?us-ascii?Q?AJJKCep38panpItimK5LTl1ju7dcoNM2x/aYe/h4JpR76jJTUQkTCrq71r81?=
 =?us-ascii?Q?MH5VJyHmKkZu/fFIProvouvRXRIUoXRgYkhD6PjyZw/pfiUuvYtFmdW9dLDz?=
 =?us-ascii?Q?4Q3sVDlIQ3EL/mRd6YvNbhiA8Zcqa+0OLj1S5D5UrmZPSLBPFt9i7LbTpDRz?=
 =?us-ascii?Q?4BBIsKJHfApPHKM4HlW5CcqfoJ8jt0Nsy5Ly9iSgdVwapg2GqwKoVdqhpsVE?=
 =?us-ascii?Q?hSZtmcPOxgjTZ8ByDBlDKjS+iv5P6VV+6ZwGFrDpQD9tVkRflV+2haF7pEJc?=
 =?us-ascii?Q?SUhDtrTIxgywPB8Hx534NvZjHdmEsI8QMvB48PWdLivH+P3xaaQjz4dYo5j7?=
 =?us-ascii?Q?TvnqnAhQv56XxrFF45KeP1jGw9KD6omAMNasWX8SBBMdCK+BVAAyi4WXefDY?=
 =?us-ascii?Q?EGoXvambaaKb9hp3o2mt549FZaaLgN2uIug5AftKPeM4dkcwz1fvy4ly94RS?=
 =?us-ascii?Q?qVKIZm8XlHXu+YZWm3lQGoZV1hVokpE644a2DFlThCTSFyCEkCgHiu3eUjCx?=
 =?us-ascii?Q?bkWULUVbgfmBb/rjqwoj9u9dxWVk3as=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d677ea19-3584-47ab-aac4-08de51e5662d
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7828.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 14:18:03.9000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oSkr+AOFBXOSy8YHaYeqIy8xupl7q0yKJHFBrsTASn43iubOx5M0yWHRyAvWkJzi0IZjt1Mm/0BNsuLpJp+VviS/0PGNd7kBYeve5J0Meoo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5957
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: E7E1A14000A
X-Stat-Signature: wpq1zcncdbdot73p9ax9uueumcwref7p
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768227492-84216
X-HE-Meta: U2FsdGVkX18EsqImF5CZpkrIbVtpHMXDk3w5FKkUVQbpOGgL4bPqtLk7xgCMkpywfJKkSHsCMvdi7I85vWoid/uQOQnsisrfsSKj3YWVjO0Lz8CsypXXOjIr9J4TjJ+RSvx0Ru+TdHkYypRTRiB3qY/b2IM9OzkXnBI54vRiGdyVfBraVNnDN8Y0bRdVk9ivQLmRTRrFOvrCR+j+4AjpHt8Pk7EFFqf8RouP9QDHLveT4z5MYUld96A7sIjCCahxqjNeNb7FQ24lNGduxfbWGx6j2NlZkvf6OionfYm/8AszgvT+odRduIIvigytm0dcc4HvjFSU1vVzRatmonrVHHdfrwxa3orK/s41NG0bY9zuyDKf6rl26Gs/avw10Baa+CrEnGhq9adQh97Qj0n6zCtW1n9r2agFYpb9UEvivjgUdEKO/jgaLdHPKTwphTDjUHT1KezrNaNERUq5loORtbW82xbcfHSJqcpYVHAQfch4NzStDyu5Hh+ZKp6OzkP9x2FvR5u/ksz8wowTf79MNXQ5DCTQJupffjusIk1dnN4ubSwlvjPSuwhLnm0xy2kaejhLF+ZyElXuEkCT7ss8NmhP8trgsFJAu2XfTBJ+3y2Tr6B/I3xtGxNSFZiBxTtEaqz3j9W4naW7G8R4yj+kPyp2OWvpoI+9tbaCh3XD7mB0gPj731OtoAKYaPAaGbSuzRuTE++a78qwfxiljsTlRE/2X9GLNvbKFHzVSeJQmuRMQyo3/O8tI6HLqSWWXOVMwObChfmZVuBPdWVmqFTJj5Vqrq1SjGI8bd7pzZevHaIlAdsl8ulbVKnMmmHYWtpboAwjWxofqG0KEpchjJWDFRQI1mOjp/vf2czllLT+A3eQ0sCP+v0alnggkp/POdKlzuFFze4yddFId5aoFQYHrHGln9UoGQh7cIY/XT8iix4gRgTc6en6dPyug1kInBGnRb00kfPO8LoxlB6ITIk
 VK2LSU8F
 mqvH5xeL7OM4EziEw/J0GvEPN9zIlgpt9qHHJ8fPJ9mJUCMhMgXDQkXg4Y7K9DpP2YuHPMNq89qEDgD2BVmuM9sP48cm/u4zw7/JkrSfv0Xh5JNCJ/iuOY7vf6xVOMo70jt9/YimPvHNIAiNuS/ZVz+LSKYoCTYeRNv0OMyo2sVE8l4QzVkc30bdTuVxREJVgvslW2I+w4MPwdVjWURBWzpJBsuOkr4hEoODEhFd3IH8kJCLVEd4LpoJBHNZczD6gMdriXr/7Q6m3M9Wgcp06JXt4IP+zluctEVAD6vgyfw7bIYN6JjwMBFWNP399Xs9iu963ytldubdkUpKelBk3E1DyK3e58U6VVwZQ1XrRd6fS5IbE7+Fi901CWbIu42Lp9tk5z6kA8T8otMsLY42Lo36aPmaoaJ5OR8e35x72a09Ir4NFX66FI3naxBVDzhAd/n9y3EmGbqb6dhEQhUX4mxMDk+xBJPfoFhLpwxwEnrdKVH92V95t9WUC12lIuih04kDuhFg4+FtS2+N/MUlCmEcpoJlixwMpSxfzKHVP4WQB4zKrRUYrHOTx8NTKXKxa9dCsuimFUBvoDe4oRGjJ3O5J95Bz+tfEnzFgtdy1815a0z3reX3LlF1AvtHFd351K95JLCZ6XCJ7D5qLf6t/Ri1w6Nms7Ww4Qwdbem+lM0Lx9QHccr1TLHKaE4xcHD+V/V6blLakOM9dRf8UiPdOcwMLW0sr1M0nP12VRkeQW8oNYHv1M5W420iHkoo/2RxUAyTugkHz44QG4yHDch87unH0s1MLU74U++UDNzpxUElKZyM+9g/d1FZkzgnMJTHzqeZzORvITxjRhs0oth1i3UgLRCYQY1Mb3zF/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 11, 2026 at 09:55:45PM +0100, Francois Dugast wrote:
> From: Matthew Brost <matthew.brost@intel.com>
> 
> cpages returned from migrate_vma_setup represents the total number of
> individual pages found, not the number of 4K pages. The math in
> drm_pagemap_migrate_to_devmem for npages is based on the number of 4K
> pages, so cpages != npages can fail even if the entire memory range is
> found in migrate_vma_setup (e.g., when a single 2M page is found).
> Add drm_pagemap_cpages, which converts cpages to the number of 4K pages
> found.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: linux-mm@kvack.org
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> Signed-off-by: Francois Dugast <francois.dugast@intel.com>

Reviewed-by: Francois Dugast <francois.dugast@intel.com>

> ---
>  drivers/gpu/drm/drm_pagemap.c | 38 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
> index 308c14291eba..af2c8f4da00e 100644
> --- a/drivers/gpu/drm/drm_pagemap.c
> +++ b/drivers/gpu/drm/drm_pagemap.c
> @@ -452,6 +452,41 @@ static int drm_pagemap_migrate_range(struct drm_pagemap_devmem *devmem,
>  	return ret;
>  }
>  
> +/**
> + * drm_pagemap_cpages() - Count collected pages
> + * @migrate_pfn: Array of migrate_pfn entries to account
> + * @npages: Number of entries in @migrate_pfn
> + *
> + * Compute the total number of minimum-sized pages represented by the
> + * collected entries in @migrate_pfn. The total is derived from the
> + * order encoded in each entry.
> + *
> + * Return: Total number of minimum-sized pages.
> + */
> +static int drm_pagemap_cpages(unsigned long *migrate_pfn, unsigned long npages)
> +{
> +	unsigned long i, cpages = 0;
> +
> +	for (i = 0; i < npages;) {
> +		struct page *page = migrate_pfn_to_page(migrate_pfn[i]);
> +		struct folio *folio;
> +		unsigned int order = 0;
> +
> +		if (page) {
> +			folio = page_folio(page);
> +			order = folio_order(folio);
> +			cpages += NR_PAGES(order);
> +		} else if (migrate_pfn[i] & MIGRATE_PFN_COMPOUND) {
> +			order = HPAGE_PMD_ORDER;
> +			cpages += NR_PAGES(order);
> +		}
> +
> +		i += NR_PAGES(order);
> +	}
> +
> +	return cpages;
> +}
> +
>  /**
>   * drm_pagemap_migrate_to_devmem() - Migrate a struct mm_struct range to device memory
>   * @devmem_allocation: The device memory allocation to migrate to.
> @@ -564,7 +599,8 @@ int drm_pagemap_migrate_to_devmem(struct drm_pagemap_devmem *devmem_allocation,
>  		goto err_free;
>  	}
>  
> -	if (migrate.cpages != npages) {
> +	if (migrate.cpages != npages &&
> +	    drm_pagemap_cpages(migrate.src, npages) != npages) {
>  		/*
>  		 * Some pages to migrate. But we want to migrate all or
>  		 * nothing. Raced or unknown device pages.
> -- 
> 2.43.0
> 

