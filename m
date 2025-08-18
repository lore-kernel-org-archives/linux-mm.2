Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC93CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 16:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81B178E004C; Mon, 18 Aug 2025 12:46:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB8B8E0048; Mon, 18 Aug 2025 12:46:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BAF08E004C; Mon, 18 Aug 2025 12:46:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 58A148E0048
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:46:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 205491A0A27
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 16:46:05 +0000 (UTC)
X-FDA: 83790455490.30.E90F600
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf01.hostedemail.com (Postfix) with ESMTP id 90FC340007
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 16:46:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nkH5ZLPE;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755535561; a=rsa-sha256;
	cv=fail;
	b=td6Xugs5lvPFa3cg05PtmcamncTSjZvwoqDTZy61mTynpD668u8UFI1DA2oFSRGSiX9G+R
	SL9WMChhy5kIirO+m6x+bcNgImd5bzlvXN171VcbnOUay4rmxIl8kKcLF/bUko316hw/SG
	HNeltbDnKnV2jr1wi/TMfHxO239L+jg=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nkH5ZLPE;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755535561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Lql8J8exOs5Z/7s/qmy4s2u0jPDoxUG3QCJY28cpBk=;
	b=VB/+2F9Rh0BktMFLKIk5F5rxlN7O3NJD6ZBSllVXVpkVyWMtx2WuKmF5YHlvMSsvqSDSak
	rRl8D3OntQQ+2sg3XF3hkcJ2KftlD682p/8l9JoDRIa4fXeCo9i0UZpDM5NGEfwXGB3F3Z
	h290xpbznqAOcCJ/88Ql/eix1Poq/sA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755535561; x=1787071561;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Y9LSj21QvMFCPQMZ4a/C0wnGt9FLek5iG91lDwpuwPo=;
  b=nkH5ZLPESw0U6cJtk7LLUEPPWluk9FahYziitN17ZtsUUAjUlWvAfvBB
   huuWvTGYCqZGQ6S+/Z5iXMj6nc5YZ/wAaUrytAui26MrYk6SGEXs9IkHT
   LuKpuvz0Sw0BaZvmXzOCztF72Phm6WXEojmq+BAHSTETowUxn+CDykqfV
   1ccST55evYPpVHtWo9y7ZEDZp2YUtttynnDlw+rgeYpBp0VmLB4QAiGOQ
   C4J20YUQd6nVkYur/UV7NCnTMME5m/6iYnJqt5NHUfTFJ7HHT7/UcVnhG
   ww3zR8VVwvTRcbomugK/96I7Sr9lMcYarZAPrkO904P6QxjENaYBt/z+/
   w==;
X-CSE-ConnectionGUID: P9YSeBGiS/OOEhIAYbTFIg==
X-CSE-MsgGUID: VgJbBMbdRAylB/ggA8J7PQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11526"; a="57914256"
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="57914256"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 09:46:00 -0700
X-CSE-ConnectionGUID: GAU764ksRcqGEefmPsqS4Q==
X-CSE-MsgGUID: brepuIrVTU+HwNR4KWeoIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="167864220"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 09:46:00 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 18 Aug 2025 09:45:59 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 18 Aug 2025 09:45:59 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.78)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 18 Aug 2025 09:45:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lhDPH5t5PN7BAEfrQ63d/1zAIamuVQqiHUTqZ3/uey9cW6eeKeruhqOeksElYMcG8/3HlYKm/RlD8qEL1rfDAtVYB+W3QNqNKSVrU1SgoBcZDkl44qyUrLd5wDBm9FnbsTOUHzfwmYf/UrWOvnG4MluYzA8ptXpShsGv+rstbLFtu0nYkPtLf06xp0koy+RHvtmD+cGJPiXsOiAp+kEZPg/8HDOgIFOu9htRf5usE8Jr9+EwD0ro23dyl3ALT2z13pAQoHnK0N9c2izDU1ZuO8kJOeOd7xUpUkG1q/P5HlUAh+Qdx1ZFpHPPuNjodonQyNyMZxzQizTilIBc/DGJdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KbG8lJBLgkBWUnPIARIME3DShRU8c+HS73y+5NukOD0=;
 b=s15yJhWjz9nzkki09iVxnUoWMKREXCZjhbYkGJ925aZlJRdUibQQvXaCUbXZI4PgIOJXAdx/SuOJ3VTnU7mTHn2tGel5dG3tMMH96dhAEth9Mgxbe5117WEaPpN8gSmHN51iDKdfdIHpKc6J23kXjFsDhVGzWJEahUm9HhWY6FnUYYt7nW0FsnGyGJLkWmjSXKVX1hSyDSazWnx74ZZB2FI96CJANAeDAIkcbQTd7NDmyI+7K9uiA3uFWb5U72k8LBNrTPBuclZfl1qhrFvMwwLHHm2wqRwlAU4hII7H1VWy10SxvkS5Vth0hM7wCVW9MBJ0W0yLUuZzQ50Hj6Il8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SA0PR11MB4717.namprd11.prod.outlook.com (2603:10b6:806:9f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 16:45:57 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 16:45:57 +0000
Date: Mon, 18 Aug 2025 09:45:54 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, <intel-xe@lists.freedesktop.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>, <dri-devel@lists.freedesktop.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Christian
 =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [RFC PATCH 1/6] mm/mmu_notifier: Allow multiple struct
 mmu_interval_notifier passes
Message-ID: <aKNYwu+2xMXjRkiU@lstrano-desk.jf.intel.com>
References: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
 <20250809135137.259427-2-thomas.hellstrom@linux.intel.com>
 <20250818160726.GH599331@ziepe.ca>
 <aKNT8GUu0r3i4Ikq@lstrano-desk.jf.intel.com>
 <20250818163617.GI599331@ziepe.ca>
 <d34ba6c8c68a2fa85f052bdb4d27be15561f4861.camel@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d34ba6c8c68a2fa85f052bdb4d27be15561f4861.camel@linux.intel.com>
X-ClientProxiedBy: MW4PR04CA0076.namprd04.prod.outlook.com
 (2603:10b6:303:6b::21) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SA0PR11MB4717:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ac3ee1b-cfba-4f8c-a2d3-08ddde76b48f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?RxrBRBO4EqvVeTG9VPyl7/8QiRD9lAahCiqh/Hfm6rtT51enDi64wOWVIR?=
 =?iso-8859-1?Q?cHzP5iqtdn+BLHhLD+A3O+HLuClqxgytyJg0MFSopyLSjg+4zGNjSYhNTp?=
 =?iso-8859-1?Q?ZTVAxisUxWeRRwSw62U6ai6/E+q7oDeefjwCAzLjkI0EtaG2l4+FD3bYby?=
 =?iso-8859-1?Q?nzVFmSAc5rZraLa0/NeOY4RN1M1lOZumis/hjUVGVoXKWgaRlC6vytDTjd?=
 =?iso-8859-1?Q?S9EUGh7i+QVqqo/aTooIrEu81JVcaeE8bbCng+qaiWp+Q+ddCRymmO9QgE?=
 =?iso-8859-1?Q?4ZTpO2nN9NkPdAdB/dEUbVHdDiTZl0oVAt1MtPi+uxlHI3UhTWKUWoyTjF?=
 =?iso-8859-1?Q?2MUXEPiPzIaUFYHyOm0FDI1kUPt9/EuSbWbLPzkwhX7ET+ajfzsDbNVFZI?=
 =?iso-8859-1?Q?yjdv01P9uI9mjkP9U3GN+TZmkjs+n47Pelk8LH1nJKve0e2V59A71gCWF6?=
 =?iso-8859-1?Q?ISILtCCci4/f5J1IahKTxzNovnRKzH1mTFh613UyLrqb+tD1VHJMyWeozn?=
 =?iso-8859-1?Q?kUjbCU2jyrROhPnXjPv8G/Ihu2Fgg5UBfiUIfmNmdS7LeEYTKA/zVUMEXd?=
 =?iso-8859-1?Q?fQ7XKPeO7g4zpdi73TCFYsqk3x6UEQhGX8pKMpX8NSJpnyLVKa1p2zFS8A?=
 =?iso-8859-1?Q?3F1TkKUwjXbGqTmvr9aH9oMmHyP1CEQkO4TPbDwItRasoVbyFN+JFGREJ0?=
 =?iso-8859-1?Q?2/etboBdC/aV0tm60OTCiD21P3Py4vd8RKyJgq0ez/dTV1hhNhDkfp420p?=
 =?iso-8859-1?Q?W06ojb2DboCyNyX+gUjwYZtvVwjFOhkiWBdea1/pLt1d63DGY2viB5rgNS?=
 =?iso-8859-1?Q?X8MeQabTrPS4Tg43oyLzEWABEGooWP0N/wV7z1pilFqtjg5te606lkF8wt?=
 =?iso-8859-1?Q?L9B3VJ9JEdrDo12ozFK3/pSUgU7T7vOYVoenjks9BaJc7dlincJtmBH2eH?=
 =?iso-8859-1?Q?IKEIc2EFT71EYN08kfpCaVFJCp4VWrNDwELYAZYwAZgMh4gezO37CYLxf5?=
 =?iso-8859-1?Q?Ixl57VaLCvamsVa4qO5+Y7G17eYPJ9NfvuynZuxXvbDXp6nUARsU14n4Ko?=
 =?iso-8859-1?Q?ZZkZfW/nKDe4TUqmqrjHxBZeYKeQUA01imccc94F5sLgyj0BDRFuNkiRCT?=
 =?iso-8859-1?Q?5uQKTJxvd8d8E3NClFa7+690V3JHPUWAZ7lnT5F91xAXkw8LXl1Zw/l5d4?=
 =?iso-8859-1?Q?+a9/9NRO+AwgVGpUBAZNIATAxVofFatwtT4png6lMAmy752tRppC5z7eHB?=
 =?iso-8859-1?Q?QQyepmpg4tf2FtVPxnP3T+KBsD+LIfAAWYmhBIUOUABywgq18gsn3dbXt9?=
 =?iso-8859-1?Q?wisUgDZJFYPTiFjhhsj0Niy/rGjfQexyIGd0nPGY/XXmIrXklGwp4rF3qQ?=
 =?iso-8859-1?Q?75gKqvI4loegqbbVmSBjwY6tVKzIBGe4bGXOs7mBiMMWV3dv9j+dyMwvDW?=
 =?iso-8859-1?Q?ZlL0f6cZlQHDoprqLQyA80zP0jtZXuyZDwtW0GbOcqZJx/MWj7kt5/IOV/?=
 =?iso-8859-1?Q?0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?fU/Nobl5d2VdslG0h9bFIXa21noJ4OYDMTk4s5M4gobOO+/ycMF7Vmv+KD?=
 =?iso-8859-1?Q?43ZEo+0Yn3rW1g1Pps0QSxUIZm5tEk3P5x4Tb2a+BvBM9Pajtz1PHFvaNj?=
 =?iso-8859-1?Q?4B9WnrZUs09y17tyv8G2PoilLjgjtJ1+n2zlcoXd6+1oVd2O5fF6oNjXsI?=
 =?iso-8859-1?Q?HV004dyhqyKbtAApxXCzBGUB+vyDLFu0iNbVA/mTjUgFLn8PmRfMwcP9Fe?=
 =?iso-8859-1?Q?n0EgVGM88Fwnm31o5o1kLouPNzDhn1+S0anwA3dvJ8SaEXM369oXL9NLlH?=
 =?iso-8859-1?Q?xEIbeX+wZIeJp/fvT48wDGW0zG31nvF7LNgIzV3SoOprvhkoTvqgtsHKN7?=
 =?iso-8859-1?Q?2ko3mCKbN6EfyYEfHWRvC6oX2wkZNW+HyfQbSFrUC5rjgJIZGU4AhmfW/0?=
 =?iso-8859-1?Q?HLVi7WZP6rl6dnGoDBbkVbE7rByM/6Xs0pgECBmWxje/nYe+fGt47G6XQ1?=
 =?iso-8859-1?Q?VZ3aA1/MZIV+xa9640/g689pWod0UTiMmhaG34Cz+heB13L6Nmp7MqoE2T?=
 =?iso-8859-1?Q?kcvKT1xL2wXZtQnG+fKhHMazfLrc1gash73bDcmnfhXcHAxjye3MWOiYMq?=
 =?iso-8859-1?Q?Spj9sh9mjQRxcXvgXV0JHeRwoHN7wpZzaWeYhBTOtgB8nqxqGtM1nm9AGb?=
 =?iso-8859-1?Q?BySBSN8zoOvkUGFbBiSBcYQdt+DTrF5wJ3pkxwvs/PnSVrw6x2npt6ykJd?=
 =?iso-8859-1?Q?/d6NgZe4Hj9RcR3ahX0aEk9/Y/m17IaLKM04JH+xZPFFyIM22Ya65hpJ5d?=
 =?iso-8859-1?Q?0ObiawR+z7FRDgaYm2/DqOGe2n9DdKStk+pkgLgj3/dnO8oqPHIYN9LkEh?=
 =?iso-8859-1?Q?jReC+/t+t5wnLyQajUBGCp/wHgcJzxnTCL7sAOKA5caY76VJw6MIuHYsfV?=
 =?iso-8859-1?Q?HaRpofM/4/tTk7qkT8Up1oL3sDnbYSmhu6UeUgoMbLCgMTAoa9LqQ2irqa?=
 =?iso-8859-1?Q?fdeV+e0f9WogDJv1661i+KNjlsKa4ajYINpZVVchD8Y4P3g1mYinBM8qKP?=
 =?iso-8859-1?Q?64Kf5pcdCOfgjSkFCCMRot7+ztzXhf934W3zc6kwgkal85edX5VrY5aMw0?=
 =?iso-8859-1?Q?2+Rn74jrTkNHGjuwUCO2dOtKLOtNEKDpKs6gYSm8PPIBx6ey9Hw1wMqYRA?=
 =?iso-8859-1?Q?qV2c9KcLdBqZqnp8oq0cF1icnwVOejrjIydDr9JMC0bTYszV+Cq82qsXAe?=
 =?iso-8859-1?Q?IokHTBNBZY7FANn2vyQmBAZV7Jy+AdkAGukLOJ+2sfH9WlJfb0xwWd4L13?=
 =?iso-8859-1?Q?OpD9yBhvRQQ9YrwbuJrwg6NmL4Tjq7VSvH18Fcs4IuRjtasUkL1+3ogDky?=
 =?iso-8859-1?Q?2gC2vCVTg8O3IZZCLfIwkbnLqM4fCb038eQxvQ3KxkWeQ8KjEJVQTzydil?=
 =?iso-8859-1?Q?p6jIvtTsBkV0uE7sYKrpYERS1JqoYdEil7lz4rT6nli9hbUHnevz2uQ8s+?=
 =?iso-8859-1?Q?WQOnyPm1qoRBlCN9AoKaASlWfiou5vVWwAPyD2UIa6EwbXJIEtZbnIU+J1?=
 =?iso-8859-1?Q?kGeG7VLthj0g5qveMHovM8/J9tTw702bGE1PFbw5zCXHI1cF6Aapa/o+h1?=
 =?iso-8859-1?Q?ear4rEK90Dx5iJxdu63RT0EgiHXzYkFEIXsyFA28+nnKFTyXs4m+i+N0RV?=
 =?iso-8859-1?Q?nyy8duNMFzuWSl2tyihJ08ne6B20EFOUf2WBKo9Ch/MMDErGn3+fAz2Q?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ac3ee1b-cfba-4f8c-a2d3-08ddde76b48f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 16:45:57.4438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qw+HX5g3ps/YHU6C8LIR9ka1kmrohOwdq9bdzKnkI27uM1noSdqb8X2LBuxKmfHuvKY37yqHQvReKgBXPi2Kaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4717
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 90FC340007
X-Stat-Signature: byqtpiznd3ae6ztuwyjwiwnnwcj7txxs
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755535561-63920
X-HE-Meta: U2FsdGVkX18QrdIh3Q0dSZTU9aZzFmLjkdexmUFK3YXKCk9q5Y00MXkW8bsvE0j52ASuz30BDq94JhHveHAiJQHeHrA01CKlS9lI5KXbuDYfp4cqG3706fywSOaAuLgSwBuNMGg0c1xvN+vNOjMZO4IKwX8kmD4Tz6MN1nN6KbNjOTgg8xT36m916q+YpiotyrvglXLV7Y10mQXqXfptlJOTgs9y5bcJu4TYui3pEjHo24v/7jxqDprixOmHCCLmOojQDP4242CdKpl5jTdH3bRqZR2UujHyov5P8Db3ZsqburrfmaCVWr+LsP0889mov0on2ZRg7krB+DZC32UGE0KE+KKVFXFGWaYzas0J0jDn4b1kdVIQ4Jvv6xu6tL5j+gNZORfJsXiWT64cW4BaTZpNkx+XRDBW3cEdM6b9HA8fW/GkMoSp2eCCzwh8APYh2iuGn28+StyWJBP17YF3+KgO2nzH5Ljh4wnvkVTZzfXarz2FGkm+MqrR+ca7NLIijz94ZOVrL1bgcY9SgfHskSAW1RRNs1o8xp+PixrlcRdKCftBuef03gwyVHgvKYFFhxrjIy3hMKlnt7nOzX65cCBkoXcKcXx7e90EBEMpl5NErYfcWfD5Ir56dFOc9XR4yCGPwBMPiF6SbvKQdzeegdBb9KBmcMdu9NB6RaVag+o0dhVEyKbeedVc3FSmwVuPK13rKBYpfGh0QwewRZ5gsbs6kYLuwjoeNRXTECWi7YYjea5FcsugkcyW1hMf5jc99gnKmpPmnWCARpuexjoRTIkj6dM+klNEsvHwNVcGeNKcxq5LXFLSl/FfiV423/HSGbSuh69Q0s1Fon/bYTSbZ2phpVGh4zFhfrfaI/BPz6NqKhfWh+LrDB2lXQsO4KNJv/Woz+qpLlnyuZHXqlD8C5bfxGVX21copQ0AJ593cACmNnzcI0e8u/FEh/9qTFzS9/0qCIaol/Ug2YqUlL7
 Ay92RkQ1
 qIzQO1gwtCLS5UmZ8RjtAkN7WNUxL3HJsROU0E3xUEhHMmDfE11mVdKR4Cm9ouqfXASGwsYRFIio8OgpIrLKe6x2bMe7Av70Pr1kJ0Vb47gm4HoYM+cxNFKgAr7GeJEEIO5C47fJvHLG2f4S2j86Ud+RtnbuGg0kI902mwzyOJ4zUln3K2HBmL0SfQLoyr09m5cBZwMHKGqOszL1cwbC9R2AwiEkkrzCG4u752WjBehXfeTFFwYCRrwViRAOU0L/FS2F8Y8CSyC+xFeUx3eqOwx99pWHezYIS4zGTi2JWAPzw9tZneNaqzB0O36Hl6X46Y320gMbCTNzU57lDxaJUhCQaylp+xtB5okhrnsaG4lhbSskjjjFoSS93LfI5vVV0QHOhnjJ57KpY9oj57UD1hGWrlVxzp61/UH0xuF/3I8xJMMf1jsE4MV9v3ZLlVvH2E6hbcfXahLGjsmkYGSj0N0oOAD5Bqeep9vRa8mr8Xb2pYFLgwh6aP/oKucH8nyr6cBNuGAayCUV6xLd0GBu6yMVAHuwvyRMIPx2NSWjmyXJS2QJB5VSN69C0TawEL9DtS8d0Bq7AYPV52hMhZ3IqKFfHqTGfEqvvdv7b0hXJPXCIgGnWiJkro5OAj0YMnhr386Apbr2Nt9f59yg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 06:42:36PM +0200, Thomas Hellström wrote:
> On Mon, 2025-08-18 at 13:36 -0300, Jason Gunthorpe wrote:
> > On Mon, Aug 18, 2025 at 09:25:20AM -0700, Matthew Brost wrote:
> > > I think this choice makes sense: it allows embedding the wait state
> > > from
> > > the initial notifier call into the pass structure. Patch [6] shows
> > > this
> > > by attaching the issued TLB invalidation fences to the pass. Since
> > > a
> > > single notifier may be invoked multiple times with different ranges
> > > but
> > > the same seqno,
> > 
> > That should be explained, but also seems to be a bit of a different
> > issue..
> > 
> > If the design is really to only have two passes and this linked list
> > is about retaining state then there should not be so much freedom to
> > have more passes.
> 
> Actually the initial suggestion was two passes only. Then I thought I
> saw a use-case for even three passes and added the multi-pass thing,
> but I think it turned out we didn't have such a use-case. IMO we could
> restrict it to two-pass. Matthew, that should be completely OK for the
> SVM use-case, right?
> 

Yea, I just replied that 2 passes should be sufficient.

Matt

> /Thomas
> 
> 
> > 
> > Jason
> 

