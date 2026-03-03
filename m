Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4496EDEBE3
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 18:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E12336B0089; Tue,  3 Mar 2026 13:11:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF736B008A; Tue,  3 Mar 2026 13:11:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC1466B008C; Tue,  3 Mar 2026 13:11:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B85756B0089
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:11:00 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 67B9E1A02C9
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 18:11:00 +0000 (UTC)
X-FDA: 84505543080.13.BB38EE7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf17.hostedemail.com (Postfix) with ESMTP id AE6764000D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 18:10:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WlPOffb6;
	spf=temperror (imf17.hostedemail.com: error in processing during lookup of matthew.brost@intel.com: DNS error) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772561457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XqSC+JX0p4GixmlNdCyzIbYuYE8y7haVlVr5yEgTQzQ=;
	b=id1BGc8j7psQvfe9x1F8oWN4vcAE11zA6YHgBN1zOOanSIvXScOmMVDDv7I7119vyymhKH
	XdmvBCytO0mGiixLaT/0TA2a+HAdhVKn5hkLI2Ha8YgI3YrWUrPYAhP91A1009dO6VQ1H0
	Mv2OrCN1PuEHICK2aRTsbrZo6k0XUm8=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WlPOffb6;
	spf=temperror (imf17.hostedemail.com: error in processing during lookup of matthew.brost@intel.com: DNS error) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772561457; a=rsa-sha256;
	cv=fail;
	b=kdwFZdzLXd+TT2eT+37uYQMRbWi7cj8pyd5lW/wVvxu2dG9B7DsFztTtGQDglnDH9kGAtr
	u3mqjFBhDkwV2RcAL98zLMR9f06gmqRXjYCnXHm/zbAGBUnPF4XiQEdVgImDEH6O7/xooE
	+SJ5bGoWL2Q+jsGr4o/bOdkw8A0LefA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772561452; x=1804097452;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=a5DaVx6KbW6/VtCHzamGHCLoEpBJTD/dr8qakjBSmSE=;
  b=WlPOffb6aBwDGsAgYo5c/gJB6d+WUhQhQuALrCkJNJtiTS3qMNu6mC0V
   BFtwJ8K28v/ywzCT/ieropgBHi4GxZA4o0DdWxS7KPPlrLkeCp6TQbdQd
   dyO+gpUUWU+IvISvYMJpusy7NoqhB2yiuvdCqnNgyTq+E4tD7T9w5zgzr
   8Z26IaJ0ay91IfqKD+hBR/2QGN+SAXtnYHcPbqZLzcNJipqATehv0mm9w
   NP3WzXCpvX9K+nSNgmBH0uxoWJCQLcZmil9O4r4MMxeQzqGTL+bZ0plT3
   5Rf9mc3dYF1mYOq3B7ohzYkrYAb2StD4dV1Tu1XfV85kyzpL2qx4dK4/Y
   g==;
X-CSE-ConnectionGUID: IH0fIojkROiJANvYLXGgsQ==
X-CSE-MsgGUID: 7V4aAUjoS72Xu3r4FuhTJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="72637890"
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="72637890"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 10:10:47 -0800
X-CSE-ConnectionGUID: um57q27ZQASsjzOwOjk/0A==
X-CSE-MsgGUID: 38uxAIfORneW/0RWWhPEVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="222230702"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 10:10:47 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 3 Mar 2026 10:10:46 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 3 Mar 2026 10:10:46 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.24) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 3 Mar 2026 10:10:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OX6doG+HbQY1etBFZoUjoWGw7RwfL3c+Y5xDB4nbMCnFVgPEgnnYjASLjqJqG/ebDE2OD84YnVhMmWrrSndXtWU4wc19cAaxzK2RBfTv5wnjKvIvxL0Qwcw8qrIkQwhrmFPCbe4r6XOYGGmI9xgfRz51pPSyAyf8Th8cO3wmYJ0lq4D5OaaavfXYr6E4GTivZ48E+mOTY8TaXt9PECF6Ss077C4yXmgS7Ap/ihOHMCVdvUa4XUAmjZH/MemAiESBs1AA6SJOtzoaCanZ3ep7Vqdo/HweWH2BLadEzdZGmeJL4cUusaO6cf2BoD9A2L5mPp6LZXHeY9M2WKIrTiFthw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5m1nhJkycM+WuldT3meehZVdSSa1Jeu1xM87hiTuFUo=;
 b=tpZpIMe+UP6JA3BAs10QYape5/ep2MCMVBgqwFNpjc32e2SAEem2J+3lCNuVArdTvu2POzrxy/91kMtgn/WKuZwYHglqUie2V9IjnaZP3o7RyC+y+TGKcFOjNHq21xj/434nG3fIrKQLFK8gkOcPX0GOzeTLH7QtkEsyIKX7yxPA5wOFdsbOMIVwC3wHXO23hG5i/oMDRfG5qNY3AGSDSvDcoynSg05OyCkXaveJ+PtD+6cvOzm5/D/0lKm8i6UeYEshhWwAKtX6ABXB6tnxpNSJwN5p9EAHUxTW7K4D/5JlPyVelW4V37/L+5YmCL0PzasaC7UrcMLz+uuAN/q5yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SA2PR11MB4907.namprd11.prod.outlook.com (2603:10b6:806:111::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 18:10:44 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 18:10:44 +0000
Date: Tue, 3 Mar 2026 10:10:41 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
CC: <intel-xe@lists.freedesktop.org>, Christian =?iso-8859-1?Q?K=F6nig?=
	<christian.koenig@amd.com>, <dri-devel@lists.freedesktop.org>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>, "Simona
 Vetter" <simona.vetter@ffwll.ch>, Dave Airlie <airlied@gmail.com>, "Alistair
 Popple" <apopple@nvidia.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/4] drm/xe/userptr: Convert invalidation to two-pass
 MMU notifier
Message-ID: <aackIUS2XnYOe2vy@lstrano-desk.jf.intel.com>
References: <20260303133409.11609-1-thomas.hellstrom@linux.intel.com>
 <20260303133409.11609-3-thomas.hellstrom@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260303133409.11609-3-thomas.hellstrom@linux.intel.com>
X-ClientProxiedBy: SJ0PR03CA0388.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::33) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SA2PR11MB4907:EE_
X-MS-Office365-Filtering-Correlation-Id: dd4e8698-3858-4f05-de34-08de79502ff1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: /1L4C8QQxQAq1LDDUlqPCYrAj8i/KFv97/7r9U+2VO27VDWplXJl8NOM8SMi1SX0EZHKvZChAmbQEI1WsYVe+/zaKGla5zi4HVqNiM+CEUHpWvrlq5GPBbp0a8+ACxNtQt1eeqPiGiTbK9HEB7JaKV6zEOs0WrK7RyFi7Tw/mwZrNGp867sXrW9thAxKKa2OPFxD2uJSx26F0mghDIsOK+ki7OT714bPQRjD+cq0aXMNSwd+45cV3ZpiaqUdHofSh4OiAfnPwaaqHoCMZzczsdIDTPqxQotm4AMTjrSXAQQLlWyPmPv05X1SCh25e0Ju0u21+8a7q6PWdnupLji9KDJJc3iy9W+WTA4YSPLkskG3q9J+khwPKt5M2SqXXzypsLh++Utk8eaGk8XtJq2I60iJ9wq7wtItOKxY1mRpzhNSEOjL4lKuZVaPZNHaSViHBjsYRgGgLoNICpq6ON8C4/GNGR2IXaDeB+zu2clZ275FTNetol0cp7WhZxxqreDOWMUklGJObhKyrrNlAkrrk3KWmp71RIvubbkRzdfbdVm25630RQrj7+xCNGciT7pdNwbRkgSvqFy9S8K8jksEaD4Dz3BSZ4BSwWdYcptb/Azm95VbeXIJeA+nO9tM/XWHBL546AEQ6iy1lZ7SJQ/iIicdhkESBvacwfgfZZ+dO/JrDJckX+AtdE9SAlp5MMhihY5ZuT6PvVVitWujbUDJiIltKl8cZtZcHETvAHv70Vk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?+85HGaP3UZ7AhhcST49IgHfP588+jzjR5z5jfH5raG5iDkeZMr7QiDlTlN?=
 =?iso-8859-1?Q?3VRIbkXIQ90UFHxkIPFs2VPvLq1PMGe8ePL9AjG8yJ3K4CapGvbEZxth5z?=
 =?iso-8859-1?Q?L6fKspdQQNzcM0oOIxUHwQyZis5Ifm11MAYSQO1edSyQaMBArxUWDoznog?=
 =?iso-8859-1?Q?5JSMAFgYCZsCdaWapDmunh+bKt6KQ00kT6dVzEU703VxXqgkAqh+0McNAz?=
 =?iso-8859-1?Q?Ir0a6lqMDwF4Q2z/BacCKL5kJzRo718VN6hwmw9XH8dF0FKSw/w8alG8+6?=
 =?iso-8859-1?Q?ktVjhyMzOGOX73/ZZpNRZFIFIwNVIJ1/5fTCeGS3Wqy/j4TQf43cLVXcHp?=
 =?iso-8859-1?Q?3gLxtWyQKOC6GFUScKgh+h8e6Kie0hkuigNq3nZ+RCVb7EIyV9yyAHgv+O?=
 =?iso-8859-1?Q?12V+mTeMT6+chMchrKBwpmrH1TIjl9UekxBUOq5Q8wU4BYW+1DbuT1B28x?=
 =?iso-8859-1?Q?1rtgepqmlnQlRLB8pEc9YKrEQn6owsTugQGRUW7Z544foJ7fQRSzo2Ikju?=
 =?iso-8859-1?Q?2vCHWnLCrqMnY/YEkP6w/8CUUi5VohNx88/dKF0lny/3zBRt91b0b47mL+?=
 =?iso-8859-1?Q?Okuy83LkhCCWm7rGc+pkARUT/nywDhPzKC/UaEIJSnkA1yi2XwKN00J/eU?=
 =?iso-8859-1?Q?IjFGfL9xlMxQyWo+q5TCZ88Lz9taxQApKBEetjOa2xzhn3n7JcDuYdt+oF?=
 =?iso-8859-1?Q?QHPqIdkR6j1xCDMndA0ppqGuZMSil+AgPikz3Iwl5VEMmnfaPDeLJK08LK?=
 =?iso-8859-1?Q?KitqvRxwtiMYTut9EJYbVK+gfdsLyOla4B9OMjzNZMCunDJo0xXCMiNhMv?=
 =?iso-8859-1?Q?JynZCvFR7m0UofT255k1epuunikHeyM6vqeDzZNRBSzEAbjdwep85z1FNQ?=
 =?iso-8859-1?Q?zU9yAZ1OPlBoV9a5cQh8zSow+2fbpJ/77peAX7C5oIwu5yt6AZiMQhZqYd?=
 =?iso-8859-1?Q?q/k1bpU+XBSXcmrT97X46xIxLx/X/A1pkj/cG41yYIsmoz2/S4d2DNuB4s?=
 =?iso-8859-1?Q?tq16OwUegwTzsrez+VpkK97PzYudTkQOiBWl8n3e8pTU+P+8de09a6AZAX?=
 =?iso-8859-1?Q?nifShmY54bDAGjx5o2DyOLRcYY2xdsjcuGj7oVE3FDhkUq6B7J8VUknqgf?=
 =?iso-8859-1?Q?nlkhbJoZFUqe3RwRjCbws6PtWD0zex4/8R+Vs1fa2o1tkHofy0pucU3uA4?=
 =?iso-8859-1?Q?jLdHT85M0cBeD2h8XZpLysMEdLMHaWPG7PNbPvrP9MQdudzQJlf4KCeoR3?=
 =?iso-8859-1?Q?8IMqRdUF0mxYwgumWPtId5lIXnLXnBfIwoFDGxuQXxY05wvWa7fY0HuPWd?=
 =?iso-8859-1?Q?R00jBN30WmJER+gkEOeGStjwwK+6zSfth9ezAlu5HIGFwyDR5pdGOLbwL+?=
 =?iso-8859-1?Q?W3Ptz2n/4wsILgUl/hJqn0ZX7kFkpKkfCHNtRs2Ts4wlBuzoWOyJQrdG0T?=
 =?iso-8859-1?Q?5mDfTre8WjcOh1/OSJkPL1GsQ0yeKw6MSBVwkznrIjodc5yWsa3ETtV1F4?=
 =?iso-8859-1?Q?1EZZkUFtHhzkVnwd0NLFynxRLfmgJIeYReQ0UFweQOc/EZW+5fVRtyJ4Co?=
 =?iso-8859-1?Q?toG8R6hA0ifEe1JHtjwKe3gOH0neWbqB3J6tT43JBK15LXKti3oQcTFmru?=
 =?iso-8859-1?Q?KL33bHwFvcuk29Esi+LwNTIYcqVgLFcUZXIUbPn/wpv50sbGBwL3hyaW80?=
 =?iso-8859-1?Q?GM5I+y8l6kHW95eeb1iRX4GKjq9TGckJr2m1u4Qa8pKcVQc0C+xEvfCGz4?=
 =?iso-8859-1?Q?bMKl8wVh1BmqYAtA6xLCd/JszUGS5/ZT0FpbSIBaqQHg5HKtrE3rVeOhfh?=
 =?iso-8859-1?Q?FdxJPczCnetoAsFJDLC52pB/Kn4s0P8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dd4e8698-3858-4f05-de34-08de79502ff1
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 18:10:44.3925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6TmJsB7Nn4zqMUp2/aVTkZo3Z1X6IyzgnF8TElWYNDD1Wg8jUrg4Y/hunYO/fQSHNWOLA5zwTb8ehnrWB3AQsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4907
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: AE6764000D
X-Stat-Signature: kq6okkqahe8uq9aa5thyzu5b7hwj5o7e
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772561451-461908
X-HE-Meta: U2FsdGVkX1/vzfzPtlPJiMyT9qrDXz36CiCFaDIs1ShE5ITH1v3uqRMEVhHL3s454TXgd1tK+SmdKC2OlGnfgpqtoL+eDNjCAyifA2tEe/ljg4JrOvCAvlndxfIoH1W0sruP3ZJucd8SN1GRtQZPkmU6BvLM7QlnuqH0jtHBFrX2UjuvhYWW6pAXkrV0FCaNVFZG03XQjLpJI4l4xJ0CIE0A+BcBUCtwxWPs3HZh2TG3T0q63q7wTCaLrBSAAGJrSP+SwNZ6tpVtEvrXpLcakNYRsruEMj1oqZvG7CHyQyW64iN21+dmAYHcpn9BVgsQVXpXLPDiZr3Qj+oWJ6TfRvdLqx3cPzSdEBxpB1wtH3B+TA3AxEoWFA9U88FYPRCwERYL2QsV+42Yqb6C28tPOUmkGU2O+2xmYnLCN8/rRcdv8zxb0Uv20FyoHLHomcd022dNyOnW9UX7K2GoWR4I19w6eClptoNhRW0N0RxNNGtImIRah01HNUDuRGUlyY72E9xJ/yqz5esbLbMm2JezEgOc13r1e9IPqUasEAczEWwzSXkm1R//PB+gH/fzOWWsfWJ+B1apKR9OKZfZuQcCUopuC14TAcx6gYhMCdBW0ZAn/HDr6HqyZQZKAKhZWUGvst6WyB8AFSPk5DTGwRJX7bRAbik7P2CQvuuDwIGbACUDhBxWtRR5CJr7b97aDjMd7ptq0rEDRJ1NzyZ484PDvNDJUDtoAw6yQp1Ywuz2TCWHg1hSesWPxwLMljjfJ/na7oE+Wh19T3Pp/XjuNUcA8PrRbFYIy4X4s05ZL8r8sOh4KYcp1vhL8aQjSMI4mNFumG4Fugy8jLq0xGun3PskFTvn7pPtARnKql7X/XMZgrnhnoLlFqg3qkHvzMWLpdHGs7lACOXSWfemjnNv4EUtRTh+jUAATfZWnt9W3FJeHObR90ZSteAuAiyhxQC7hKbYTGu6AqhyZTzq+BtioEX
 /+FvRjw5
 9PnDWfBqq3j4+Ci7vMsyLr/sA4NYuxWtLRWSRjdE+OgViZBwAzCIYVR315WpC2xmQGrXne0y0yW4mYynkiCoisA7JJk8/WDwapEM9B+QI8H60JythWVf65nhiuqVDWxzujYmIgoIEY9nweCN4ZZoP05iCSJwX8fZ04G3i8CuYSYEHmTb1Oy0x+6yXnJ2uW+YnTECkvhS/WszrU48ydLsUv9YOqnNZ+cl/f7Qp6anGDWP2quZIL/bYBZpzbW8L27wWnt8XbOO4RMf+0na1Djw1GplymDzVkbFpz+O/MZeRFnXKGwrmVhpn6fUf+DSIl6fgcolHHy3hRIOksnJRJmXvzN45HUocXWGpefdmRLIJU7FUvxqedOTB0zZwNKA6J6gG8dbfKpx4hCIOPppE+kN3ht9n+DHWSLWqiH26SDUX6UB0xNNq1KTls0p1c4kTe62NYwQxKb6iHBurL1tYQ4dAVq78LS6UJA6WopfnxPP1ae4z09KQqhF29/a/NooBN1JMPeYaT4D4elmDYX/kBrRKvzgaRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 02:34:07PM +0100, Thomas Hellström wrote:
> In multi-GPU scenarios, asynchronous GPU job latency is a bottleneck if
> each notifier waits for its own GPU before returning. The two-pass
> mmu_interval_notifier infrastructure allows deferring the wait to a
> second pass, so all GPUs can be signalled in the first pass before
> any of them are waited on.
> 
> Convert the userptr invalidation to use the two-pass model:
> 
> Use invalidate_start as the first pass to mark the VMA for repin and
> enable software signalling on the VM reservation fences to start any
> gpu work needed for signaling. Fall back to completing the work
> synchronously if all fences are already signalled, or if a concurrent
> invalidation is already using the embedded finish structure.
> 
> Use invalidate_finish as the second pass to wait for the reservation
> fences to complete, invalidate the GPU TLB in fault mode, and unmap
> the gpusvm pages.
> 
> Embed a struct mmu_interval_notifier_finish in struct xe_userptr to
> avoid dynamic allocation in the notifier callback. Use a finish_inuse
> flag to prevent two concurrent invalidations from using it
> simultaneously; fall back to the synchronous path for the second caller.
> 
> v3:
> - Add locking asserts in notifier components (Matt Brost)
> - Clean up newlines (Matt Brost)
> - Update the userptr notifier state member locking documentation
>   (Matt Brost)
> 
> Assisted-by: GitHub Copilot:claude-sonnet-4.6
> Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>

Reviewed-by: Matthew Brost <matthew.brost@intel.com>

> ---
>  drivers/gpu/drm/xe/xe_userptr.c | 108 +++++++++++++++++++++++++-------
>  drivers/gpu/drm/xe/xe_userptr.h |  14 ++++-
>  2 files changed, 99 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/gpu/drm/xe/xe_userptr.c b/drivers/gpu/drm/xe/xe_userptr.c
> index e120323c43bc..37032b8125a6 100644
> --- a/drivers/gpu/drm/xe/xe_userptr.c
> +++ b/drivers/gpu/drm/xe/xe_userptr.c
> @@ -10,6 +10,14 @@
>  
>  #include "xe_trace_bo.h"
>  
> +static void xe_userptr_assert_in_notifier(struct xe_vm *vm)
> +{
> +	lockdep_assert(lockdep_is_held_type(&vm->svm.gpusvm.notifier_lock, 0) ||
> +		       (lockdep_is_held(&vm->lock) &&
> +			lockdep_is_held_type(&vm->svm.gpusvm.notifier_lock, 1) &&
> +			dma_resv_held(xe_vm_resv(vm))));
> +}
> +
>  /**
>   * xe_vma_userptr_check_repin() - Advisory check for repin needed
>   * @uvma: The userptr vma
> @@ -73,18 +81,46 @@ int xe_vma_userptr_pin_pages(struct xe_userptr_vma *uvma)
>  				    &ctx);
>  }
>  
> -static void __vma_userptr_invalidate(struct xe_vm *vm, struct xe_userptr_vma *uvma)
> +static void xe_vma_userptr_do_inval(struct xe_vm *vm, struct xe_userptr_vma *uvma,
> +				    bool is_deferred)
>  {
>  	struct xe_userptr *userptr = &uvma->userptr;
>  	struct xe_vma *vma = &uvma->vma;
> -	struct dma_resv_iter cursor;
> -	struct dma_fence *fence;
>  	struct drm_gpusvm_ctx ctx = {
>  		.in_notifier = true,
>  		.read_only = xe_vma_read_only(vma),
>  	};
>  	long err;
>  
> +	xe_userptr_assert_in_notifier(vm);
> +
> +	err = dma_resv_wait_timeout(xe_vm_resv(vm),
> +				    DMA_RESV_USAGE_BOOKKEEP,
> +				    false, MAX_SCHEDULE_TIMEOUT);
> +	XE_WARN_ON(err <= 0);
> +
> +	if (xe_vm_in_fault_mode(vm) && userptr->initial_bind) {
> +		err = xe_vm_invalidate_vma(vma);
> +		XE_WARN_ON(err);
> +	}
> +
> +	if (is_deferred)
> +		userptr->finish_inuse = false;
> +	drm_gpusvm_unmap_pages(&vm->svm.gpusvm, &uvma->userptr.pages,
> +			       xe_vma_size(vma) >> PAGE_SHIFT, &ctx);
> +}
> +
> +static struct mmu_interval_notifier_finish *
> +xe_vma_userptr_invalidate_pass1(struct xe_vm *vm, struct xe_userptr_vma *uvma)
> +{
> +	struct xe_userptr *userptr = &uvma->userptr;
> +	struct xe_vma *vma = &uvma->vma;
> +	struct dma_resv_iter cursor;
> +	struct dma_fence *fence;
> +	bool signaled = true;
> +
> +	xe_userptr_assert_in_notifier(vm);
> +
>  	/*
>  	 * Tell exec and rebind worker they need to repin and rebind this
>  	 * userptr.
> @@ -105,27 +141,32 @@ static void __vma_userptr_invalidate(struct xe_vm *vm, struct xe_userptr_vma *uv
>  	 */
>  	dma_resv_iter_begin(&cursor, xe_vm_resv(vm),
>  			    DMA_RESV_USAGE_BOOKKEEP);
> -	dma_resv_for_each_fence_unlocked(&cursor, fence)
> +	dma_resv_for_each_fence_unlocked(&cursor, fence) {
>  		dma_fence_enable_sw_signaling(fence);
> +		if (signaled && !dma_fence_is_signaled(fence))
> +			signaled = false;
> +	}
>  	dma_resv_iter_end(&cursor);
>  
> -	err = dma_resv_wait_timeout(xe_vm_resv(vm),
> -				    DMA_RESV_USAGE_BOOKKEEP,
> -				    false, MAX_SCHEDULE_TIMEOUT);
> -	XE_WARN_ON(err <= 0);
> -
> -	if (xe_vm_in_fault_mode(vm) && userptr->initial_bind) {
> -		err = xe_vm_invalidate_vma(vma);
> -		XE_WARN_ON(err);
> +	/*
> +	 * Only one caller at a time can use the multi-pass state.
> +	 * If it's already in use, or all fences are already signaled,
> +	 * proceed directly to invalidation without deferring.
> +	 */
> +	if (signaled || userptr->finish_inuse) {
> +		xe_vma_userptr_do_inval(vm, uvma, false);
> +		return NULL;
>  	}
>  
> -	drm_gpusvm_unmap_pages(&vm->svm.gpusvm, &uvma->userptr.pages,
> -			       xe_vma_size(vma) >> PAGE_SHIFT, &ctx);
> +	userptr->finish_inuse = true;
> +
> +	return &userptr->finish;
>  }
>  
> -static bool vma_userptr_invalidate(struct mmu_interval_notifier *mni,
> -				   const struct mmu_notifier_range *range,
> -				   unsigned long cur_seq)
> +static bool xe_vma_userptr_invalidate_start(struct mmu_interval_notifier *mni,
> +					    const struct mmu_notifier_range *range,
> +					    unsigned long cur_seq,
> +					    struct mmu_interval_notifier_finish **p_finish)
>  {
>  	struct xe_userptr_vma *uvma = container_of(mni, typeof(*uvma), userptr.notifier);
>  	struct xe_vma *vma = &uvma->vma;
> @@ -138,21 +179,40 @@ static bool vma_userptr_invalidate(struct mmu_interval_notifier *mni,
>  		return false;
>  
>  	vm_dbg(&xe_vma_vm(vma)->xe->drm,
> -	       "NOTIFIER: addr=0x%016llx, range=0x%016llx",
> +	       "NOTIFIER PASS1: addr=0x%016llx, range=0x%016llx",
>  		xe_vma_start(vma), xe_vma_size(vma));
>  
>  	down_write(&vm->svm.gpusvm.notifier_lock);
>  	mmu_interval_set_seq(mni, cur_seq);
>  
> -	__vma_userptr_invalidate(vm, uvma);
> +	*p_finish = xe_vma_userptr_invalidate_pass1(vm, uvma);
> +
>  	up_write(&vm->svm.gpusvm.notifier_lock);
> -	trace_xe_vma_userptr_invalidate_complete(vma);
> +	if (!*p_finish)
> +		trace_xe_vma_userptr_invalidate_complete(vma);
>  
>  	return true;
>  }
>  
> +static void xe_vma_userptr_invalidate_finish(struct mmu_interval_notifier_finish *finish)
> +{
> +	struct xe_userptr_vma *uvma = container_of(finish, typeof(*uvma), userptr.finish);
> +	struct xe_vma *vma = &uvma->vma;
> +	struct xe_vm *vm = xe_vma_vm(vma);
> +
> +	vm_dbg(&xe_vma_vm(vma)->xe->drm,
> +	       "NOTIFIER PASS2: addr=0x%016llx, range=0x%016llx",
> +		xe_vma_start(vma), xe_vma_size(vma));
> +
> +	down_write(&vm->svm.gpusvm.notifier_lock);
> +	xe_vma_userptr_do_inval(vm, uvma, true);
> +	up_write(&vm->svm.gpusvm.notifier_lock);
> +	trace_xe_vma_userptr_invalidate_complete(vma);
> +}
> +
>  static const struct mmu_interval_notifier_ops vma_userptr_notifier_ops = {
> -	.invalidate = vma_userptr_invalidate,
> +	.invalidate_start = xe_vma_userptr_invalidate_start,
> +	.invalidate_finish = xe_vma_userptr_invalidate_finish,
>  };
>  
>  #if IS_ENABLED(CONFIG_DRM_XE_USERPTR_INVAL_INJECT)
> @@ -164,6 +224,7 @@ static const struct mmu_interval_notifier_ops vma_userptr_notifier_ops = {
>   */
>  void xe_vma_userptr_force_invalidate(struct xe_userptr_vma *uvma)
>  {
> +	static struct mmu_interval_notifier_finish *finish;
>  	struct xe_vm *vm = xe_vma_vm(&uvma->vma);
>  
>  	/* Protect against concurrent userptr pinning */
> @@ -179,7 +240,10 @@ void xe_vma_userptr_force_invalidate(struct xe_userptr_vma *uvma)
>  	if (!mmu_interval_read_retry(&uvma->userptr.notifier,
>  				     uvma->userptr.pages.notifier_seq))
>  		uvma->userptr.pages.notifier_seq -= 2;
> -	__vma_userptr_invalidate(vm, uvma);
> +
> +	finish = xe_vma_userptr_invalidate_pass1(vm, uvma);
> +	if (finish)
> +		xe_vma_userptr_do_inval(vm, uvma, true);
>  }
>  #endif
>  
> diff --git a/drivers/gpu/drm/xe/xe_userptr.h b/drivers/gpu/drm/xe/xe_userptr.h
> index ef801234991e..e1830c2f5fd2 100644
> --- a/drivers/gpu/drm/xe/xe_userptr.h
> +++ b/drivers/gpu/drm/xe/xe_userptr.h
> @@ -56,7 +56,19 @@ struct xe_userptr {
>  	 * @notifier: MMU notifier for user pointer (invalidation call back)
>  	 */
>  	struct mmu_interval_notifier notifier;
> -
> +	/**
> +	 * @finish: MMU notifier finish structure for two-pass invalidation.
> +	 * Embedded here to avoid allocation in the notifier callback.
> +	 * Protected by struct xe_vm::svm.gpusvm.notifier_lock in write mode
> +	 * alternatively by the same lock in read mode *and* the vm resv held.
> +	 */
> +	struct mmu_interval_notifier_finish finish;
> +	/**
> +	 * @finish_inuse: Whether @finish is currently in use by an in-progress
> +	 * two-pass invalidation.
> +	 * Protected using the same locking as @finish.
> +	 */
> +	bool finish_inuse;
>  	/**
>  	 * @initial_bind: user pointer has been bound at least once.
>  	 * write: vm->svm.gpusvm.notifier_lock in read mode and vm->resv held.
> -- 
> 2.53.0
> 

