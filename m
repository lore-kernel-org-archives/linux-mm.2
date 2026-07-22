Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5D7DC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 20:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 985546B0088; Wed, 22 Jul 2026 16:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95C106B0093; Wed, 22 Jul 2026 16:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 824696B0096; Wed, 22 Jul 2026 16:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C5C96B0088
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:11:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C46DB1602D8
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:11:48 +0000 (UTC)
X-FDA: 85017508296.15.41484E2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf25.hostedemail.com (Postfix) with ESMTP id C29FBA0014
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:11:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hu4sPnYk;
	spf=pass (imf25.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784751105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uF02uWEvkBfEBTC4w6AQM9w9G5Lfcp805iGpAlPnpqY=;
	b=jEioB0kr+kzf2krHpM/PE4+6YW8hF9/7l18qCkoL9a9D9ka/cO9ZnrbeIpV5aRO7BArirp
	kXni4VeyfRIF59v04aLZsu1EBp7PHVzA2+sldoDKX2goS20Y/DMjt3aXw5SO3wIk5Qn1qu
	Z0BHmcyQYcPW2Kg3O7XDQ5MFQHitWzw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1784751105;
	b=ACI3W2FjWqY+6WjvSpioVz0fCqVcdxWRg6hd1doWoA4QrJvQeYFA65W/HOlrmve7AhdiSO
	EouqM7QtgMnJTNEGboDrM/LaL0qGoPupp/ovlJkF16BpIRz38FE1UmiPYZ6nprh3Wt+QuD
	b2BnVwc8uQg3LO3kIKKyyKZRtA2LGVw=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hu4sPnYk;
	spf=pass (imf25.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784751104; x=1816287104;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=IjJFC/j5Dv6owHucVacI8/QRsPFfVg99gMymh9Sv860=;
  b=hu4sPnYkBCMWAeuKlISWO3QuS77nFGssFonAc33EugTAn7bLuTbL+e6c
   YSomKwGVfeln4HzgyP2EBEU0VoMZJQSo1T4F5RcC0nuUwOGksRp7HMAs4
   6cW76V4PqqeHCN1xC25q5MUOls1g6iFnQoZyF7LY0uslUTxXpu77+HAQz
   M+SPPdoHw7VZDItUAqlPDk2BM36Fr18jVxDXYkVy2Lch2RxA5IHti5ZBE
   FfUg/eowq+zuc/e0+7Jj4SpPTU7VRwtvxAPru2D9i4J7mBxFoqk+v4XDN
   Z/GAa1L+o0oWKM5mzjRqXCUTAWr8gXhOAvj1SbQuZlXDCA0Lw2zpJL8hF
   g==;
X-CSE-ConnectionGUID: 6vC3fbxFQ7yrOLBSa5g1/Q==
X-CSE-MsgGUID: 3sxnKfz9TTiwMtQUcY9IHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="108187437"
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="108187437"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 13:11:43 -0700
X-CSE-ConnectionGUID: Vvoz+FpYRfexCzYDBfg5nA==
X-CSE-MsgGUID: Fou5NbEuS7O9pEopyUAN3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="261739309"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 13:11:43 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 22 Jul 2026 13:11:41 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 22 Jul 2026 13:11:41 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.24) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 22 Jul 2026 13:11:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j/f4zwYLVWLfSvesuuZMQkwhe6+mxJlD/nnrJ570krfRJ4LT1Uo2l62urFE+grNDiuA9o1/ftKGrRgTFwGRdQHiyRMOgkKNpRfnjyDcyZk/608lM3TTjKEuuUw9DVS7FHFrsuz5Hbhl1fcVUpQy3vHEXZ8htIiatdW1x4xnvPljEq1Bqk6RaRv0G5gyaizyDcsxNxqdgpYjGhGhGH8e7wlXaGcpdXQqCPDAFQe6+b7d08NZNC31mpx+6xf/RQ0BbTuZnnF0jsPvaH5/RuSoLHOTFo3Tuz5w/cKajYtSQBQC+gYLqHlKf6DoHuYzhB6AiaIEP4iNcpjUuHZaLcMtr/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uF02uWEvkBfEBTC4w6AQM9w9G5Lfcp805iGpAlPnpqY=;
 b=RXd/uCiXUoAR3AZTZP4hToAlE25tC9H5fp8J15IZlVJeaKfgM7+PC+XT6IV9q/Dhw4Zt2FURah2nIqMYeCOug7bpqdZDqRIj5zwRcjqsM93mg7CUbC0gg8yguCNzG4xPVIEmdV5fOVJQNhLjoh7kRFaAjSNYpydmWfayC27iyR3IIUc427ymbccVhEiiEzRtsRUgWIsRTj6zaUcPckF62qmGhUjbaY7a/Mz9ZgZaocdeHEmNKp+J+GmHDC6wEh0uwn/B6qBLzAalBdmlrTXkn5IK5jDrtbSbdeflVqqiqym57CTOJ0vsU/XrO2+tfOh+qpwphQ0hUwwYZoGDIUHrzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by CY8PR11MB6988.namprd11.prod.outlook.com (2603:10b6:930:54::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 20:11:32 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 20:11:31 +0000
Date: Wed, 22 Jul 2026 13:11:28 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Christoph Hellwig <hch@lst.de>
CC: <intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Hugh Dickins
	<hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, Christian Koenig
	<christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Matthew Auld
	<matthew.auld@intel.com>, Maarten Lankhorst
	<maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>
Subject: Re: [PATCH 1/2] mm/shmem: add shmem_backup_folio() helper
Message-ID: <amEj8GO4sz1Be5pa@gsse-cloud1.jf.intel.com>
References: <20260721174723.1039395-1-matthew.brost@intel.com>
 <20260722094350.GA1057@lst.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260722094350.GA1057@lst.de>
X-ClientProxiedBy: MW4PR03CA0282.namprd03.prod.outlook.com
 (2603:10b6:303:b5::17) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|CY8PR11MB6988:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e3f15df-b719-493c-4b5a-08dee82d6bb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|18002099003|22082099003|6133799003|10067099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: z7hvLZDjHN7jj4qoeQn9TPMElkoMbxAaPnzOd5k4Mz/CTnvjs3q2OcdrFISppAOOZe5+Zd4ZFfzBNepY4Nz8jMAjsWvNLPnvzibc4Yfs8SVaILfLiFhzChC7ZYcglG9P1Za/2B4pGi5CGNxOsAkqFj6TELdznvul7yezH69o/icF2J3xOuf08TLek8SQuI2xjJhKDYMph1xEoCf+4Tvdpj2gH72ESDYqJrhVNd/0StgD7kfFiRd2fL+kdcXyd/77vYV+lJXYavEhi3CUJJ27Fwk3yyQ8mp0jy8NxluNNmaiVWbl3fcoyXQE9NalEaXZrM2RejyL2+utlgkcI7qgQ0kKPJrfbLKSmh5bZ1jcqsUxsGlGrmxW9NwkcD8Iv91OTz4HvR0Bk/DftmapeGlBPGw48L/p6YwaTr3bdDe246PfirZuf78UN3J5UF5l4hewPsEJg4Mupj9RfNTMuufbfBPHqYEVycODDbXHG41GTCrbpBiAIYUGZqSeBDrGZWGJ/d8ZYMDwFKuywDZoJvemqBE8lk7qKxeNpgo65OzCIeYautmKmVtfEtXI0dsH2KEM6vHRRkJ6bJRolKvQinR7j4IoyoLRbHx9FrE3Kuab06f0ZLipf5HjqRQs/CSm9r8xNOdMsBlmyX7xbrE1aLyDBho8/xJq1VEAmgI52z/3NtEg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(18002099003)(22082099003)(6133799003)(10067099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DDIWtlrB7LOpnHqtMskDhbWOUNaKBCzVH0V5vTWh7MFCWKMPDnUJ0YvhdKVi?=
 =?us-ascii?Q?XYInw5qy+u9QM8KQWG6JMhYL9+P2KhwabNBPdMkFZQ8YpCXBrwP1RZcsB2Zw?=
 =?us-ascii?Q?IWe2ivPb9NkgsBhAks1BWOVprXEuNgLQxQCJjSxc12kkvdc6pjWx5mrzi6DN?=
 =?us-ascii?Q?dnqKSvcaVohs6ifSt9HPaIgGDBpK474C3qST45UA+BsBKraHE2mPO6dVzRXU?=
 =?us-ascii?Q?zbhMnkD75qxgwAti/qpOHGDo2cZmA7JpW9Y1d0RUJdmtNvkcGHDZN3KYC3+F?=
 =?us-ascii?Q?YzzRhN2iOYwHLWyWR8crXcsdLFACMBy2xWECv5k6bF1ysBVJBYJpqBWqrVt3?=
 =?us-ascii?Q?iTfx0SCbILvionOPUFdM1Mxx5daemmu4rD+HNk1yu29bUB4k0uy9GYGLZ3SB?=
 =?us-ascii?Q?UAAdxmmKcHURrm3mtwfg4NGsPYXy0s4CSdRGlRkZXqdr5Evt6vtQzB20HGTA?=
 =?us-ascii?Q?tEJkMkRUWLPfJqU763wlcNaTiaOOKM25LMd/CGsAvA4mdjV1CRbkypNTnIdz?=
 =?us-ascii?Q?78FVn3oAIvWTNckmoHEgdugN3CTl/RNrLTL8eBqC3xtKEv8gCb7TOnhBZaKa?=
 =?us-ascii?Q?F2Z0CKPRvwGNUB26THmB32XAIFawONnTHC753YaAk9u0hL+VFLISkkihekIk?=
 =?us-ascii?Q?2uEvSet0TWNG7qdDtJjW2vsfb3POCKqk4/UEJMRwsCP9aQf8E3+Mi/mvVOVH?=
 =?us-ascii?Q?q63hJZC/Cn4/j3C2ZDRRLIHOURCSafhjRodSjLf6sY5gMrefQJj6WSK2y5c9?=
 =?us-ascii?Q?0NAoe6SzUeGluBg2sGj79JFcqsmN3+HBIWI3dJhSLE5vHu6jKplkP+lHMqsU?=
 =?us-ascii?Q?JcJCNzQzxhr7q63wFYwv5f9ydxeWmSCYpv7jXmH1simeE7h7lmyYLFPkP6z0?=
 =?us-ascii?Q?FIk3AlIR1SmYum6MaP84Gt7kAq75FjnkimIkulKP70ltKkjwO/svASjk/82S?=
 =?us-ascii?Q?ah1Tn3VpxVzlJDLa8FPB0+BvywzS7TXIA5PGMTtBYN7ODyViCtypb48jGmOE?=
 =?us-ascii?Q?ofhssnYci3ps9TS5+RZR0wdt2/JfrziEhanXN5jlve8PnS3JpSAQXpSPxhAy?=
 =?us-ascii?Q?kYdfakZ1i0Ov+obrcFOmigTg1380JUWqpZlLEqlZlJXBPRNTOdUGBv4SZPBD?=
 =?us-ascii?Q?DLmEqKrzK33WRZpYwPp60eOD7NBR7xW+qOMfmZolqrFG76GVAKmqb1zQZuyw?=
 =?us-ascii?Q?XK1Y2wwhIyjIgr84xmnFZhYrxiRFHJ1t1lPl1LZzUKfA5QPMaywtWORpFA+J?=
 =?us-ascii?Q?kjdZYzgHW6Lx+/hR1puPwiZ4U/qlhmwJVz437HWQ3VPY3okYJvgm3jjlSGF9?=
 =?us-ascii?Q?i+9PISboSIypNb2KqbEE61EMTHgw3Ogk80vyTT3p4ouz+0Z1gsHxwR99A+ek?=
 =?us-ascii?Q?l28a1UHAdEXNbYPwGwFflXAuDQYWbc4N8FMEsDYb3bw2aXegg4dyh39tGein?=
 =?us-ascii?Q?fWLpu+voIZwnLctmGwZqSj4GBc9H7tmsZ1PwNfbjZbWFjp9kWrqsK1hXCaDQ?=
 =?us-ascii?Q?3EU+a8/kZ4wAMJnS6HQfw+xMf6KXO6UyZVyrTCmIX/HkiTzNA2OIalRN5wvV?=
 =?us-ascii?Q?phcPuIGrHBVByuT3DC6ruPFg8nh0B1MyCMU/54/it6UfNC7PLvqg9J+8lQjO?=
 =?us-ascii?Q?+Ydc2v7mlkaq+kb+ZM7YvP/hc8QXRBRsU7WzyADMgCBvHBn7BVhHrmfhNEti?=
 =?us-ascii?Q?SHkSe2PDSdZVuyLJeXW9R1XfHSZ0lMDPAKqSKK14L/zQSH7jm3FF4qSSSpzD?=
 =?us-ascii?Q?WKKelISUDQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: R+UgGB6H7fKqaSZShE3C9T6Rd8k8MFDmDuAa/R4IYnlGubLyT9OfrmB8yqQz6iNQXZ/4mCnK2Ud3Wtq+6BsiHDigNtpcmbrBSoC4n/tZSwsbZNH9oO3ggI66AwYCavwoyFAKSrsIPF9/6sx3vkC+Qp1xL4gblv3fxEuXJSA3NoNXJD6l8YG5UdhMTblm0DbZUmamVdsK5SLa5n/bRjYnTjiO8y3fu9o4W/ABoRJ/DweiT9ZP42dfgAWgrvGUsm8TunC5FP8xAbP3aaXISSuBHCJnKh4lt9OBQLce9PnbDewz+1JmLHHD027OzFwL7KP6D8yV8XSmF++ksH3cWrpiNw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e3f15df-b719-493c-4b5a-08dee82d6bb4
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 20:11:31.5167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QYzV1eyPhyEjLFooZBdaTGYuOrOFEYOKqyqyAxj0qi+OR8+ebH1aj/c0+Tqu20wjhjvFdYFyBsBTTbHNz9qx+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6988
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C29FBA0014
X-Stat-Signature: kwuy7ehre91ez8zs5mz5i4kbi9dgqqmj
X-Rspam-User: 
X-HE-Tag: 1784751104-583273
X-HE-Meta: U2FsdGVkX1/yWH/GzEk6YBTjDgruRLH6QvZpcbhwDPpnIPd7REKmvIQCrxseRiDfayhwxSkjZDBUQtzcA687YrtoH/LY/2jn/wQqCIzMlqTLzp0cp45S//82mrMxlkCFBOOBAssMTiTDYhLNYGlUaPAmvWda+TE0BnQFQWC3mOEBEb0VAY7Zne+Y3LEuIfCKzAHz/tyiaQQ6bhC98I9fnSFhSqbGUJ0HMbE9zzszCU8UktyA2PnVkIbFHxfVXBUZKo/ONcSEZmbD/aOOsr5J9VU3SkQVpnGW8iBwOy/+mJfvinXiY9ALDDgctaxmZh8safKqHbjakAqegRpQSt8VE87IIJT5zuYjXpjG0qZDv77SHYdh6GbfaZF1Gy/S+xzeHQyY95mpt3r4vhbzM26W/J6pbTycKgFRQXxT72tZ9CHYasTneMUV1SIE06RIYlCdV6OM9CTDaBx8PHylH6yCSHTSiZgw2SeyMCo4/KknGqk5hI2IkDCl1YOOO913OL9St5/eg1R64KrTbSAvqcV7WCDYGSMmdvM0rzAmkAZAb7VGF/QZzItURB8/VTFKWwU+ZBZgTOll3nmGWw2TUTcLMQdducReICwfbSg56rfUedoE+brr7KG1ODtP1Wqs+StWDxqwz18PUJrUA0xYTG2WdEvO9qxQ5kwgxcCcE1EfItiQPxkniALueZlMC/FayB+S/THBEAIyeaoqTx0+rHIqM+d2wJbhhKt+0INvUJfXQLwGBQftmtpj9DQnUS1WPZMXxaW2MwSG2LmF65s2AN4qZWqa4xtgIjV7J2pYKA8Gg+eG+5W+Qh8/GdnWytem7feRkGxwM9007AONCUM5JHslRs3TBlw7CSAn/E82QD0tNV06pBVMcm2tGkIwVMh+LG3JdJTbdBJhUmRAwXB7r0pubbxH2yWifpnFbMTvIZYTJZZzLuLbaHk+++Q2hH7uFjTJkAaYZPuXDOF3XyqSGAL
 0oR4VtJp
 rp8CkY15cb2AasVmACS0nejEafuJYHDqDvjdMLuH0DuI603ToxICRFqqx8tUl3fZPyt7P/NgE2LzIYD89HHx3ZZ2DF/gdq4RERZB+XAEYNwPrUnuMhikh+X+OSk7xLE6KBAv4rcbw08Xxlyx/ClWiFYYm4Lny+nPvk8EmzWK35qVUFjSYODLErwtE2pZrVpfvgOd/KXALZBW2KyI1KohD8in3aDHurw+WCgI6qh92C+HECGlBR9arkHV2qdbBK6hUb5UTeK7IBsPhUVUH7HwZxo5LEek259nIq2kWFoDkmtUBZpWA9YhByOuRqAcd0Gih9Lp1puZsWvD5LmLH2FVaQYCe6Yjg8xOmrGg8LW/RrOW/mgvO4hMTtkZG35SiRiubHr4IYOg9h5TspmbtPaHtSMpnmL0UJNPkbTSsNxuzCiGLSq12lOBadB0hbELcf7P2UcAD8Ha4/zIdXGM6U3FX/dJdBlNSdH72rqo5WnQEbejLGBcdBt1DkOI4M3HbPCfsoMkuuvgd9Bs1RmXyTqDf+puONw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 11:43:50AM +0200, Christoph Hellwig wrote:
> On Tue, Jul 21, 2026 at 10:47:22AM -0700, Matthew Brost wrote:
> > Add a new generic helper, shmem_backup_folio(), that copies the pages
> > of an arbitrary source folio into a range of a shmem-backed file,
> > optionally issuing writeback for each destination folio. It is
> > extracted from drivers/gpu/drm/ttm's existing shmem-backup loop so
> > that other subsystems (starting with TTM in a follow-up patch) can
> > share the same implementation.
> 
> Hmm, what is the difference to just doing a ITER_BVEC write with a bvec
> containing the folio for this the pure write to shmem part of this?

Thanks for the pointer here. I'm somewhat ignorant of filesystem-related
details.

There is slightly less GFP control since kernel reserves can't be dipped
into for the forward process, but perhaps that doesn't matter. There are
also slightly different locking chains (more on that below).

> 
> You'd probably want a kernel_write_iter helper wrapping
> __kernel_write_iter for the writecount, but otherwise this sounds
> like a normal write.
> 

I tried writing a `kernel_write_iter()` wrapper around
__kernel_write_iter() that performs file_start_write()/file_end_write(),
as suggested by the comment above __kernel_write_iter(), but lockdep
[1] isn't happy. 

We have a hard requirement in DRM to shrink under dma-resv locks which
creates the circle:

pipe->mutex -> mmap_lock -> dma_resv -> sb_writers -> pipe->mutex

If I simply export __kernel_write_iter(), bypassing
file_start_write()/file_end_write() and therefore bypassing sb_writers,
this seems to work.

I think this is safe for shmem files, but it's difficult to say with
100% certainty given my lack of filesystem knowledge, or whether
exposing a dangerous low-level bypass function for files would be
acceptable.

> We'd want something for the writeback part, preferably a purely
> range based API to be generic.

I found filemap_fdatawrite_range for this part.

Matt

[1] Lockdep splat:

[  105.374023] ======================================================
[  105.375386] WARNING: possible circular locking dependency detected
[  105.375396] 7.2.0-rc4-xe-01637-g40a493568fe3 #1290 Not tainted
[  105.375406] ------------------------------------------------------
[  105.375416] cat/3121 is trying to acquire lock:
[  105.375425] ffff888105677460 (&pipe->mutex){+.+.}-{3:3}, at: iter_file_splice_write+0xb9/0x550
[  105.375444]
               but task is already holding lock:
[  105.375453] ffff888112889420 (sb_writers#5){.+.+}-{0:0}, at: __do_splice+0xc4/0x180
[  105.375468]
               which lock already depends on the new lock.

[  105.375480]
               the existing dependency chain (in reverse order) is:
[  105.375492]
               -> #3 (sb_writers#5){.+.+}-{0:0}:
[  105.375503]        kernel_write_iter+0xaa/0x270
[  105.375513]        ttm_backup_backup_folio+0x95/0x130 [ttm]
[  105.375529]        ttm_pool_backup+0x376/0x560 [ttm]
[  105.375541]        ttm_tt_backup+0x32/0x60 [ttm]
[  105.375552]        ttm_bo_shrink+0x76/0x140 [ttm]
[  105.375564]        xe_bo_shrink+0x19e/0x290 [xe]
[  105.375642]        __xe_shrinker_walk+0xfb/0x310 [xe]
[  105.375803]        xe_shrinker_walk+0x36/0xc0 [xe]
[  105.375885]        xe_shrinker_scan+0x110/0x1e0 [xe]
[  105.376067]        do_shrink_slab+0x151/0x6c0
[  105.376076]        shrink_slab+0x140/0x8b0
[  105.376083]        drop_slab+0x3e/0x90
[  105.376092]        drop_caches_sysctl_handler+0x74/0xc0
[  105.376102]        proc_sys_call_handler+0x16c/0x230
[  105.376112]        vfs_write+0x3ae/0x560
[  105.376119]        ksys_write+0x66/0xe0
[  105.376127]        do_syscall_64+0xca/0x540
[  105.376136]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  105.376146]
               -> #2 (reservation_ww_class_mutex){+.+.}-{3:3}:
[  105.376159]        __ww_mutex_lock.constprop.0+0xca/0x1960
[  105.376170]        ww_mutex_lock_interruptible+0x26/0x90
[  105.376180]        xe_gem_object_mmap+0x1d/0x120 [xe]
[  105.376241]        drm_gem_mmap_obj+0x6c/0x190 [drm]
[  105.376417]        drm_gem_mmap+0x44/0xb0 [drm]
[  105.376446]        __mmap_region+0x8d0/0x10b0
[  105.376453]        mmap_region+0x157/0x180
[  105.376459]        do_mmap+0x4fb/0x660
[  105.376467]        vm_mmap_pgoff+0xae/0x190
[  105.376473]        ksys_mmap_pgoff+0x15e/0x200
[  105.376480]        do_syscall_64+0xca/0x540
[  105.376486]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  105.376494]
               -> #1 (&mm->mmap_lock){++++}-{3:3}:
[  105.376503]        __might_fault+0x4a/0x70
[  105.376509]        _copy_from_iter+0x4a/0x740
[  105.376517]        copy_page_from_iter+0x7a/0x100
[  105.376524]        anon_pipe_write+0x30f/0x7e0
[  105.376531]        vfs_write+0x43c/0x560
[  105.376537]        ksys_write+0xbc/0xe0
[  105.376543]        do_syscall_64+0xca/0x540
[  105.376549]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  105.376556]
               -> #0 (&pipe->mutex){+.+.}-{3:3}:
[  105.376565]        __lock_acquire+0x13c1/0x2400
[  105.376573]        lock_acquire+0xcb/0x310
[  105.376822]        __mutex_lock+0x9d/0x10f0
[  105.377067]        iter_file_splice_write+0xb9/0x550
[  105.377311]        do_splice+0x360/0x9f0
[  105.377551]        __do_splice+0xc4/0x180
[  105.377786]        __x64_sys_splice+0x89/0x110
[  105.378022]        do_syscall_64+0xca/0x540
[  105.378255]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  105.378500]
               other info that might help us debug this:

[  105.379182] Chain exists of:
                 &pipe->mutex --> reservation_ww_class_mutex --> sb_writers#5

[  105.379856]  Possible unsafe locking scenario:

[  105.380297]        CPU0                    CPU1
[  105.380517]        ----                    ----
[  105.380736]   rlock(sb_writers#5);
[  105.380954]                                lock(reservation_ww_class_mutex);
[  105.381174]                                lock(sb_writers#5);
[  105.381393]   lock(&pipe->mutex);
[  105.381609]
                *** DEADLOCK ***

[  105.382240] 1 lock held by cat/3121:
[  105.382452]  #0: ffff888112889420 (sb_writers#5){.+.+}-{0:0}, at: __do_splice+0xc4/0x180
[  105.382675]
               stack backtrace:
[  105.383108] CPU: 10 UID: 0 PID: 3121 Comm: cat Not tainted 7.2.0-rc4-xe-01637-g40a493568fe3 #1290 PREEMPT(full)
[  105.383110] Hardware name: Intel Corporation Raptor Lake Client Platform/RPL-S ADP-S DDR5 UDIMM CRB, BIOS RPLSFWI1.R00.5045.A00.2401260733 01/26/2024
[  105.383111] Call Trace:
[  105.383111]  <TASK>
[  105.383112]  dump_stack_lvl+0x82/0xd0
[  105.383115]  print_circular_bug+0x2d2/0x400
[  105.383116]  check_noncircular+0x12d/0x150
[  105.383117]  ? kernel_text_address+0x5b/0xc0
[  105.383121]  __lock_acquire+0x13c1/0x2400
[  105.383123]  lock_acquire+0xcb/0x310
[  105.383124]  ? iter_file_splice_write+0xb9/0x550
[  105.383126]  __mutex_lock+0x9d/0x10f0
[  105.383128]  ? iter_file_splice_write+0xb9/0x550
[  105.383128]  ? _raw_spin_unlock_irqrestore+0x41/0x70
[  105.383130]  ? iter_file_splice_write+0xb9/0x550
[  105.383131]  ? __kmalloc_noprof+0x3e0/0x5b0
[  105.383133]  ? iter_file_splice_write+0xa3/0x550
[  105.383134]  ? iter_file_splice_write+0xb9/0x550
[  105.383135]  iter_file_splice_write+0xb9/0x550
[  105.383138]  do_splice+0x360/0x9f0
[  105.383139]  __do_splice+0xc4/0x180
[  105.383141]  __x64_sys_splice+0x89/0x110
[  105.383142]  do_syscall_64+0xca/0x540
[  105.383144]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  105.383145] RIP: 0033:0x5601751088ae
[  105.383146] Code: 55 48 89 e5 53 49 89 f0 8b 3f 31 db 48 ba 01 00 00 00 00 00 00 00 4d 85 c0 74 3e b8 13 01 00 00 31 f6 45 31 d2 45 31 c9 0f 05 <48> 3d 01 f0 ff ff 0f 9d c1 48 85 c0 40 0f 98 c6 40 84 f1 75 05 49
[  105.383147] RSP: 002b:00007ffdccdc35f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
[  105.383148] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00005601751088ae
[  105.383149] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000009
[  105.383150] RBP: 00007ffdccdc3600 R08: 000000000000013e R09: 0000000000000000
[  105.383150] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000a
[  105.383151] R13: 00007ffdccdd36c0 R14: 00000000001a02ef R15: 00007ffdccdd36d0

