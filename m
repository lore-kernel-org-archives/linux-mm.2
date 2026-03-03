Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E9B4EDEBFA
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 23:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01BB76B0089; Tue,  3 Mar 2026 18:04:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31B36B008A; Tue,  3 Mar 2026 18:04:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0A276B008C; Tue,  3 Mar 2026 18:04:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCB906B0089
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 18:04:26 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 336C11B6A69
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:04:26 +0000 (UTC)
X-FDA: 84506282532.09.0671DF9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8F1A314000A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:04:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="LD/fvRzQ";
	spf=pass (imf26.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772579062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sho/S4s91NN85q7AoLqq5NDkYDVfRN4Spw/TQk5MdXk=;
	b=kQUlnscmVwxZ7VKI6r3jMEg5nmqtqnDnLfrqyhNOWWVjy9u29FGhwbuIgnsisJeLwSB4Gz
	QpEu6k+mpixbE7eLT5PZUp1z9HfAQ6SKmfz7p86p0xFWhLMcE4/W7aLSDUgIPGiX62C1vL
	87u/K+ZT4xk0T7DFBUgsp3OMJVi9d2U=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772579062; a=rsa-sha256;
	cv=fail;
	b=Dfj1CC7V2H8I/daukwjiuIiO05bxjqsYj8oGpjPO/qXD8YF1Cj4EdekdzW5KvEg84lpS9E
	7oeaP2VW0ytmINRYPFCjqcUVH+0i/tNRoKQeIYgMnUSFMqJ/ZBdfAPf+yhAN6qlwX6HgXy
	y9ZbHAY5oG9thq44OrrpT1n4pRw0d84=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="LD/fvRzQ";
	spf=pass (imf26.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772579058; x=1804115058;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=AtPEvmDgSBRmdq+PFHBKWJ9nzLOy4xn7/MVfJMwVqgg=;
  b=LD/fvRzQdWRzXmZw/G2JO/70GqevfSZxabHRBw9xFmR+xB6deYCsV9I6
   e/vbjdibygkPj2OczNH+oivEjbKPLXTsrZL2f7aICHIYZhr7y2MB1/ajE
   2KvBxXkUy/KXc7/1P1iRgtOXLnl96NSZhnXDTgWZyBagt8B+nMDeNTLSw
   JBcFmU8YXlXrt/NCBawAquIJ9fWnIqE6XezdYDKiHUWGu4KJwUuSTzacq
   rrWUIHV99g0N2yuiUvi/UlCAc4mfwXX59jjEuyw7vSmb0/SCASBzslxf6
   zjExxRwNsUgd0szDmOgEkY18n6sXc1bc5LUKZIOt0b/GhWhyRUjsIc+Rc
   w==;
X-CSE-ConnectionGUID: 2K4iVJA/QtK0QiWDsqVk9A==
X-CSE-MsgGUID: j1znDLg1R16lj5RxSAEttQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="73596403"
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="73596403"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 15:04:15 -0800
X-CSE-ConnectionGUID: SuV9v2EXSJ60RxQQCh9kLQ==
X-CSE-MsgGUID: RraTQ4lLTy+S8R2Wu2PNlQ==
X-ExtLoop1: 1
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 15:04:14 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 3 Mar 2026 15:04:14 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 3 Mar 2026 15:04:14 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.12) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 3 Mar 2026 15:04:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WmdBHvASAy5MFDhq6TYZYKZU8dQfoZX4QK6HEeQ4I8MhkDnQMq2jYNiw831+RclWkxcvYL6lujA0ayLc0CB/ypWA+sVMNRGqy0tM/I5l3Frgb9wNN9EwKkhkTXVMTM44VkU5yw/AktRnHvJ1GnzQDvFigIK0XIeyFETbuYey/cBxJbF41HG1nb7Waq1e5xXimLWMqf0EDI+Wl8JMR/xiMZk4TpPbH4uTBU/83tqnzefuBXIrvP7dXJ00gk9ajQw37FFtbrj3LEfmezTUJhwaGo58ZvN7XvedGPbgx8QU9lnC8p7kM7Kk/drIo6BjQF8KIK3mpAawxSFzlvACEbwXxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YBkdVvq8ctvWBfdLR8zh8bqxdhnR4f79oMd4lmorL88=;
 b=MPl2jKmduUY4XIm7npuWe6I+lY9rBONcl6ccbO6BRsGcNvg4vcUvCP/JSnArkab5j2snBm9BzEnbH+ACtSx5CCiykMn1M7m4bnyzAabO+V84JhPgAEQBfxGje6Wzb3N+yF0Ko9tuz9SScZdpnKQ/ZIYhqm6ezG1Sqcpf/OfDGaiJDxtDgkhosaeCQleLh+kZKiH0jSmkICtDSqkns+nOpWNXv4s4K9auTZPsa6ip7HQlYsD6RIjJVK+GKhTnAUle4Tly2rSXkq9lZ/YvNOF9z6m+2UW/qy4mRv92oaBqfPEoGzHZz3caBQsExxq/3nDQ5LEUCC5KxQqkUxGRQGXihQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SA1PR11MB8544.namprd11.prod.outlook.com (2603:10b6:806:3a3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 23:04:09 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 23:04:09 +0000
Date: Tue, 3 Mar 2026 15:04:07 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
CC: <intel-xe@lists.freedesktop.org>, Christian =?iso-8859-1?Q?K=F6nig?=
	<christian.koenig@amd.com>, <dri-devel@lists.freedesktop.org>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>, "Simona
 Vetter" <simona.vetter@ffwll.ch>, Dave Airlie <airlied@gmail.com>, "Alistair
 Popple" <apopple@nvidia.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] drm/xe/userptr: Defer Waiting for TLB
 invalidation to the second pass if possible
Message-ID: <aado50/FJE+D0H51@lstrano-desk.jf.intel.com>
References: <20260303133409.11609-1-thomas.hellstrom@linux.intel.com>
 <20260303133409.11609-5-thomas.hellstrom@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260303133409.11609-5-thomas.hellstrom@linux.intel.com>
X-ClientProxiedBy: BY3PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:a03:217::18) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SA1PR11MB8544:EE_
X-MS-Office365-Filtering-Correlation-Id: 105ba5b0-cfdc-44b3-b175-08de79792d82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: NsHK8XQYzoY0P/XLZkXbBYxNSo0jLTL1nlGwpCsUHbeOeJrROITNs1/VnixnfF10od+NcbRt6hvZEZjrMf8WLWKzIvmaaf1oqaK/zNSywY5lN2mHSwwyrrdZenGSAKJo86RVt1CLw1YPmfUEbVtHCddo9QDSsefQmBsNL9UBC9u5yEYD4S5ngM8Opldt/e41OGmhroB6J9lukk2RAAwBGCa6Z39fJarvdLxlA5NW0NOA660THu9HyBq3DoiTL0t8LAIE3ylecFUPCXRfuRxnu9Q1sfNuUjSSzWZOglBCJulQSyACoGGGd9UVL7tpEK6+mdSQtpreJWnuOP5mszUlFNyddyc4fDNmvfC9ArZpgmaIKSYyysMjvkeTlkEsexyCYQhdJYnKkG7q4aXEz8W/y9kpigVlS1x6l6MXuthzrGk5QKW/knDvbV1/bbP9WPy6Xc2TQvXQhFUoaoD8RFVEt0kBAHmLMLN0o/gfAJ3/TMqDYaneV7/IaB5igyNFQSGzR/8XFO8VINSo9NaaXVsNpesL3Wzg5Gx4tDIlyWAwJJMhvegjRd9MaM064MI1mCwOwgVGCEswM6rOFWLkCZy+6vx4KIJVLxBa1L6sc3nWycQ/UfYnvDY58yYKx11OFKYnWjM0q9BR7DFgs1sBPfC2aDT+U46CpTsF0czW+87QhjpAS+qsVEcMzzuemwpgCfJLimphBVF3bHnNdHhFUtiUw0ORngseOHOP05PVQhZxizg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?VItHHU2eKlgP9EYCr7MDb4vl9ZSKjHzGVWVvHAM2vHYTjLNTSSlCgtCBge?=
 =?iso-8859-1?Q?qOCXXC5qi9SwrtpdOhlLQfglD/PK/ZKZWSG0rV6s5bYbS+6tMyN5lfkpx2?=
 =?iso-8859-1?Q?RmoJ1N8UjEerpehYmxKylU3FpPUEpSlPzXR4PLMgS+PueApd6DdA8mzkR3?=
 =?iso-8859-1?Q?4/OBBiZ4F2fyzGYfJge8TYQhh1z1DGLFqw4rMKHAwelqbc5al6S85Ce/Gs?=
 =?iso-8859-1?Q?29yIeUovW+5/JDiYA+r2cRQ/R+J4fp2OgS1BO/17pzI3ChNSr9Hy3L6+Pc?=
 =?iso-8859-1?Q?9eLrwGBjhog9RqK5ExPbNdR9pSyjk9IlwEZWNZBwX7NvuoERto+6yCcR2Q?=
 =?iso-8859-1?Q?1VBpyZN5Vl6MPs+HYoPvrZ7S3cM/JxYKBKKBRTjVQbNr2f6ztRQ97aPynS?=
 =?iso-8859-1?Q?z4Q5Tyd6q+cLBaFyTjHuLscXauzFBaFL9P7YBlAY3VIzgSFcJ9+KJAClQZ?=
 =?iso-8859-1?Q?rfAm+WtypoNw+8NsKiKKFNJOuvlvQWIKOuR12NXJwEakIW1vByv60pWcHq?=
 =?iso-8859-1?Q?dN0c17Sz8PFaGpqQ8NHNMhRhkEvgGtGCF1sz2PAFKwx5GnPWtKa4d5dHa1?=
 =?iso-8859-1?Q?LHgmIkYIcrZo1DOT/I8XCf7qpd584QQl12sQi8ilTwpl9GjHV9VyHBFVFc?=
 =?iso-8859-1?Q?/SHcsJZEWfiMtK6nDiPIuCxfFgi5oSbCvTZuQXLGArILkz76dcJW9960kf?=
 =?iso-8859-1?Q?aVlLQf+bH10BwP2wAFf/SllSPG6kjD/jgNT0Unq0jSqSZioz4XkOOxPHvR?=
 =?iso-8859-1?Q?hFIvvhv6pnWuuJmlkKESeaOAV7qtYrFK106vWYVxb4X8dEN/5/boOGBQSg?=
 =?iso-8859-1?Q?jfa1GiJmUPzrZteg5XCSVP0CdbZvP+E0AFMhKnSgOI9yWoRPDCY0uAezFA?=
 =?iso-8859-1?Q?LzWxlgHfFv9N0uOAFnKbQz+064FUan/xLkBmlhnzZE0RdciC85bbQd4cm3?=
 =?iso-8859-1?Q?OtQXduJUoTyhXF0TfKnkQlmHVB5IxLHW6mWJXW/8v1jlpKm/Hye+L3iX28?=
 =?iso-8859-1?Q?zM/vZ4xjjN+uwNWpRHSW8X4QyQsHxvYpfYBzEZM0Iq4B5S1GLLroU5513N?=
 =?iso-8859-1?Q?ESfK39ZUMx8WEPW3OEm3qMHtJL2TBbjogOP+MAuV9NbiesL039bcbH1hXw?=
 =?iso-8859-1?Q?elHp3iKm8tW8xXNOkBxJvIqwp6kpe7GmlJCospp6mfKejG8jQvEjiX2Zy8?=
 =?iso-8859-1?Q?TUy3xmd09zqg2gwS2f+bwUSn7+CVEnDq5YSlHdCzljfOgT4Wci1jRqchXe?=
 =?iso-8859-1?Q?f889eIoKKJuK8+qo5KdvV+FY0q9eHgJSqXRMfOV0bKHYZO3ewO8IiM4nvL?=
 =?iso-8859-1?Q?dMAjSJfDIKt5lNdBT/fjwBajCeOlhDtq18L5Nd/xTMrL0ltT9bHLzwt6tx?=
 =?iso-8859-1?Q?nW/fAJkwX37y07VGbNPFxnNqWblCMviCpmIAnDxUXyMjVzcTLOx9QWTJPe?=
 =?iso-8859-1?Q?VYUSsI0nt0r7i5jm8Ad8pKyy75cXe66cmcjn/heRvQx3osztn7mPJy/nxn?=
 =?iso-8859-1?Q?F9Ltzv7iERcW9GI+G3tTmspyo2wPd8TZ5aL4o12IhE3/MTIafCL+cBZkA+?=
 =?iso-8859-1?Q?1ShI8PcCWzYvN7F2niZT+1rUdDxEXA22+H2MjHP/OiGIj471S2tbpgNp3p?=
 =?iso-8859-1?Q?yMqKsatnFBZNTk6IPaZyS0ysstHc2BLq02s13nlfzqWpMQYHb1FJqOr6Hr?=
 =?iso-8859-1?Q?e+FjjeSlXwVp4oL7k+5kIy2am9AQV8G9Tkz6RGIB4TeDYHFrFsIvL3nxUu?=
 =?iso-8859-1?Q?ggvb86+GCXtITpH63gjbE/pwmdioNZvI4urA7OJuJmpIo4pJm42zz5xDQN?=
 =?iso-8859-1?Q?cM+gbE1zmniGHPimbhwnn+zaH73OvTA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 105ba5b0-cfdc-44b3-b175-08de79792d82
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 23:04:09.6097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gCj6hH3Iqi+9nrBVkeoufYWULDyI/0Qh+ExiyR+gQ/+6eY2Sj5BQLf4I2yoxMkjGyY222auwAt6dDL50gAvfig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8544
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8F1A314000A
X-Stat-Signature: g645nsbp87eajd13bw4d16cqi1yggj6k
X-Rspam-User: 
X-HE-Tag: 1772579057-318656
X-HE-Meta: U2FsdGVkX19Yhg283xwdVdlrKw6cPSw4xBOZksS725QOQ7BU4BlGt6Bartrh7bnLp/PtrXe+cpcAmEJvrju37X+sCEzrJgiZiDnU3sCohq2Bkdhxso/d2TLounRUS66inzs7mybsoAK3wJVaruvsWpAM2SKYbMd2KLXYN5jELwbOh/dsYv7P+0dMDmipi8XgowzH9dC6nFm+RKyId17+MpOjgVLc3S5+iofFV33886dSL9Hgj4vdeA3a+rivGnDs3bROJWKjkmKJ2B2Lhps5+cpToJwBfsfNoaGRpw64Rdwo9YHh1wXlQ60aWY4h03tOsKVBBUSBC9mmSbtJoe1B1R+HsCGtPazP10ZZwxgNXtv/CKWbBYh/SBeA4bG9UwtScLo4Bq9ppHyyZSCxe0+tR0pITV9xB/kBYKgcpxFt+vuYObGgFb1SMqBMvUK7Ao533zLB3ocqtOeE3kDsllwgoPKRu1wiXi7gdrEOXPQ8xrmKhs5oPpSvIxgLDqLW7NTgJ+NbacE6T4LSBbaC5ed9wPNvFYAqrvFKL/0YZIQf0PpAvcQiKa8PsXxAXru+LSZX/o+msW+Ii1tuTaCdQ1RZKd0LBA3qrEq97yIozz2Pr+SQq7p7f/d6ruJSpA+kncDgk2h8yTfolz0jS56slr9Ohdc/dwo4HMg/6aBo63CfYZsJKoN00t/1sjG9hZ6SyyfBU+XdFzh7Vgq3jkhKco37pEvVPKOwmylvSzB0NpomdYMY5Ewwm/r7yh2hkH7RBcgmn1bC/bZHcqNQ3DO6YH/tPsulp/3qJZaSeeTa3jN2ly+KrrJQmhdz9JeZv8JEp2CEGILPaDl/0bSrF60ZDKPJUsK1o0ImLYVyJ10caB0DLaz4a1nExQO5r2oRcc33nnUO2D9k5Mw+lKDXYA1zvM9GhpGqSNyUw5ZKNKjmnGwLmkYoqUsJDrZuub2yXsWtYWgrGhxJvYawHOoPrnYliwv
 PJ1W8X23
 0wTgfuZINn9UhSEf+HADk0jekFCZEZfE/PbnLEaeEtej34qMZAx1ZWZ3GUWh8ijAZeKw2fm45O8VKepsxatm4wnqo7BASk6GMYuaN6AkQci2DSkrkyMyYH2B81ghGXxINE5tbbcL589adZYVln1e4JzWaF/iPwrQ3u78DfS+O3rACER8ILhXEgo+mFp6EpHdWNJcoeQvZqWV3OZ60sGOXXNCVn/WSqhdb57ddJvC7h0QYbo5WTri+2OnUm6VCAuT9E9vt8Hj2tRnoa57pHcBOHr91KotXtqdsBwmmfTi+wX01KXkpYXIK20LXlCXH0+WMnX7Q6U+RPSFAJXsFpKcgCHDCrwgyi9lixBtqWTk6f4Q/npvZ1iKGVuYF2pW90vaE2pPW9WQL/mAHoZQh3f0INf5vPRSuuv1BFgvV72CWTDR/DKJpDXTHZ0npuSqbNtKd5N0NyEyhacYU06dN8wBdw4BVgxYfz2BNjBfLwy4wCm/1su8rbwwzms1BG4I+/7SRsfLt395GaOxKRfmJ51qL6oqr4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 02:34:09PM +0100, Thomas Hellström wrote:
> Now that the two-pass notifier flow uses xe_vma_userptr_do_inval() for
> the fence-wait + TLB-invalidate work, extend it to support a further
> deferred TLB wait:
> 
> - xe_vma_userptr_do_inval(): when the embedded finish handle is free,
>   submit the TLB invalidation asynchronously (xe_vm_invalidate_vma_submit)
>   and return &userptr->finish so the mmu_notifier core schedules a third
>   pass.  When the handle is occupied by a concurrent invalidation, fall
>   back to the synchronous xe_vm_invalidate_vma() path.
> 
> - xe_vma_userptr_complete_tlb_inval(): new helper called from
>   invalidate_finish when tlb_inval_submitted is set.  Waits for the
>   previously submitted batch and unmaps the gpusvm pages.
> 
> xe_vma_userptr_invalidate_finish() dispatches between the two helpers
> via tlb_inval_submitted, making the three possible flows explicit:
> 
>   pass1 (fences pending)  -> invalidate_finish -> do_inval (sync TLB)
>   pass1 (fences done)     -> do_inval -> invalidate_finish
>                           -> complete_tlb_inval (deferred TLB)
>   pass1 (finish occupied) -> do_inval (sync TLB, inline)
> 
> In multi-GPU scenarios this allows TLB flushes to be submitted on all
> GPUs in one pass before any of them are waited on.
> 
> Also adds xe_vm_invalidate_vma_submit() which submits the TLB range
> invalidation without blocking, populating a xe_tlb_inval_batch that
> the caller waits on separately.
> 
> v3:
> - Add locking asserts and notifier state asserts (Matt Brost)
> - Update the locking documentation of the notifier
>   state members (Matt Brost)
> - Remove unrelated code formatting changes (Matt Brost)
> 
> Assisted-by: GitHub Copilot:claude-sonnet-4.6
> Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>

Reviewed-by: Matthew Brost <matthew.brost@intel.com>

> ---
>  drivers/gpu/drm/xe/xe_userptr.c | 63 ++++++++++++++++++++++++++++-----
>  drivers/gpu/drm/xe/xe_userptr.h | 17 +++++++++
>  drivers/gpu/drm/xe/xe_vm.c      | 38 +++++++++++++++-----
>  drivers/gpu/drm/xe/xe_vm.h      |  2 ++
>  4 files changed, 104 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/gpu/drm/xe/xe_userptr.c b/drivers/gpu/drm/xe/xe_userptr.c
> index 37032b8125a6..6761005c0b90 100644
> --- a/drivers/gpu/drm/xe/xe_userptr.c
> +++ b/drivers/gpu/drm/xe/xe_userptr.c
> @@ -8,6 +8,7 @@
>  
>  #include <linux/mm.h>
>  
> +#include "xe_tlb_inval.h"
>  #include "xe_trace_bo.h"
>  
>  static void xe_userptr_assert_in_notifier(struct xe_vm *vm)
> @@ -81,8 +82,8 @@ int xe_vma_userptr_pin_pages(struct xe_userptr_vma *uvma)
>  				    &ctx);
>  }
>  
> -static void xe_vma_userptr_do_inval(struct xe_vm *vm, struct xe_userptr_vma *uvma,
> -				    bool is_deferred)
> +static struct mmu_interval_notifier_finish *
> +xe_vma_userptr_do_inval(struct xe_vm *vm, struct xe_userptr_vma *uvma, bool is_deferred)
>  {
>  	struct xe_userptr *userptr = &uvma->userptr;
>  	struct xe_vma *vma = &uvma->vma;
> @@ -93,6 +94,8 @@ static void xe_vma_userptr_do_inval(struct xe_vm *vm, struct xe_userptr_vma *uvm
>  	long err;
>  
>  	xe_userptr_assert_in_notifier(vm);
> +	if (is_deferred)
> +		xe_assert(vm->xe, userptr->finish_inuse && !userptr->tlb_inval_submitted);
>  
>  	err = dma_resv_wait_timeout(xe_vm_resv(vm),
>  				    DMA_RESV_USAGE_BOOKKEEP,
> @@ -100,6 +103,19 @@ static void xe_vma_userptr_do_inval(struct xe_vm *vm, struct xe_userptr_vma *uvm
>  	XE_WARN_ON(err <= 0);
>  
>  	if (xe_vm_in_fault_mode(vm) && userptr->initial_bind) {
> +		if (!userptr->finish_inuse) {
> +			/*
> +			 * Defer the TLB wait to an extra pass so the caller
> +			 * can pipeline TLB flushes across GPUs before waiting
> +			 * on any of them.
> +			 */
> +			xe_assert(vm->xe, !userptr->tlb_inval_submitted);
> +			userptr->finish_inuse = true;
> +			userptr->tlb_inval_submitted = true;
> +			err = xe_vm_invalidate_vma_submit(vma, &userptr->inval_batch);
> +			XE_WARN_ON(err);
> +			return &userptr->finish;
> +		}
>  		err = xe_vm_invalidate_vma(vma);
>  		XE_WARN_ON(err);
>  	}
> @@ -108,6 +124,28 @@ static void xe_vma_userptr_do_inval(struct xe_vm *vm, struct xe_userptr_vma *uvm
>  		userptr->finish_inuse = false;
>  	drm_gpusvm_unmap_pages(&vm->svm.gpusvm, &uvma->userptr.pages,
>  			       xe_vma_size(vma) >> PAGE_SHIFT, &ctx);
> +	return NULL;
> +}
> +
> +static void
> +xe_vma_userptr_complete_tlb_inval(struct xe_vm *vm, struct xe_userptr_vma *uvma)
> +{
> +	struct xe_userptr *userptr = &uvma->userptr;
> +	struct xe_vma *vma = &uvma->vma;
> +	struct drm_gpusvm_ctx ctx = {
> +		.in_notifier = true,
> +		.read_only = xe_vma_read_only(vma),
> +	};
> +
> +	xe_userptr_assert_in_notifier(vm);
> +	xe_assert(vm->xe, userptr->finish_inuse);
> +	xe_assert(vm->xe, userptr->tlb_inval_submitted);
> +
> +	xe_tlb_inval_batch_wait(&userptr->inval_batch);
> +	userptr->tlb_inval_submitted = false;
> +	userptr->finish_inuse = false;
> +	drm_gpusvm_unmap_pages(&vm->svm.gpusvm, &uvma->userptr.pages,
> +			       xe_vma_size(vma) >> PAGE_SHIFT, &ctx);
>  }
>  
>  static struct mmu_interval_notifier_finish *
> @@ -153,11 +191,10 @@ xe_vma_userptr_invalidate_pass1(struct xe_vm *vm, struct xe_userptr_vma *uvma)
>  	 * If it's already in use, or all fences are already signaled,
>  	 * proceed directly to invalidation without deferring.
>  	 */
> -	if (signaled || userptr->finish_inuse) {
> -		xe_vma_userptr_do_inval(vm, uvma, false);
> -		return NULL;
> -	}
> +	if (signaled || userptr->finish_inuse)
> +		return xe_vma_userptr_do_inval(vm, uvma, false);
>  
> +	/* Defer: the notifier core will call invalidate_finish once done. */
>  	userptr->finish_inuse = true;
>  
>  	return &userptr->finish;
> @@ -205,7 +242,15 @@ static void xe_vma_userptr_invalidate_finish(struct mmu_interval_notifier_finish
>  		xe_vma_start(vma), xe_vma_size(vma));
>  
>  	down_write(&vm->svm.gpusvm.notifier_lock);
> -	xe_vma_userptr_do_inval(vm, uvma, true);
> +	/*
> +	 * If a TLB invalidation was previously submitted (deferred from the
> +	 * synchronous pass1 fallback), wait for it and unmap pages.
> +	 * Otherwise, fences have now completed: invalidate the TLB and unmap.
> +	 */
> +	if (uvma->userptr.tlb_inval_submitted)
> +		xe_vma_userptr_complete_tlb_inval(vm, uvma);
> +	else
> +		xe_vma_userptr_do_inval(vm, uvma, true);
>  	up_write(&vm->svm.gpusvm.notifier_lock);
>  	trace_xe_vma_userptr_invalidate_complete(vma);
>  }
> @@ -243,7 +288,9 @@ void xe_vma_userptr_force_invalidate(struct xe_userptr_vma *uvma)
>  
>  	finish = xe_vma_userptr_invalidate_pass1(vm, uvma);
>  	if (finish)
> -		xe_vma_userptr_do_inval(vm, uvma, true);
> +		finish = xe_vma_userptr_do_inval(vm, uvma, true);
> +	if (finish)
> +		xe_vma_userptr_complete_tlb_inval(vm, uvma);
>  }
>  #endif
>  
> diff --git a/drivers/gpu/drm/xe/xe_userptr.h b/drivers/gpu/drm/xe/xe_userptr.h
> index e1830c2f5fd2..2a3cd1b5efbb 100644
> --- a/drivers/gpu/drm/xe/xe_userptr.h
> +++ b/drivers/gpu/drm/xe/xe_userptr.h
> @@ -14,6 +14,8 @@
>  
>  #include <drm/drm_gpusvm.h>
>  
> +#include "xe_tlb_inval_types.h"
> +
>  struct xe_vm;
>  struct xe_vma;
>  struct xe_userptr_vma;
> @@ -63,12 +65,27 @@ struct xe_userptr {
>  	 * alternatively by the same lock in read mode *and* the vm resv held.
>  	 */
>  	struct mmu_interval_notifier_finish finish;
> +	/**
> +	 * @inval_batch: TLB invalidation batch for deferred completion.
> +	 * Stores an in-flight TLB invalidation submitted during a two-pass
> +	 * notifier so the wait can be deferred to a subsequent pass, allowing
> +	 * multiple GPUs to be signalled before any of them are waited on.
> +	 * Protected using the same locking as @finish.
> +	 */
> +	struct xe_tlb_inval_batch inval_batch;
>  	/**
>  	 * @finish_inuse: Whether @finish is currently in use by an in-progress
>  	 * two-pass invalidation.
>  	 * Protected using the same locking as @finish.
>  	 */
>  	bool finish_inuse;
> +	/**
> +	 * @tlb_inval_submitted: Whether a TLB invalidation has been submitted
> +	 * via @inval_batch and is pending completion.  When set, the next pass
> +	 * must call xe_tlb_inval_batch_wait() before reusing @inval_batch.
> +	 * Protected using the same locking as @finish.
> +	 */
> +	bool tlb_inval_submitted;
>  	/**
>  	 * @initial_bind: user pointer has been bound at least once.
>  	 * write: vm->svm.gpusvm.notifier_lock in read mode and vm->resv held.
> diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
> index a3c2e8cefec7..fdad9329dfb4 100644
> --- a/drivers/gpu/drm/xe/xe_vm.c
> +++ b/drivers/gpu/drm/xe/xe_vm.c
> @@ -3967,20 +3967,23 @@ void xe_vm_unlock(struct xe_vm *vm)
>  }
>  
>  /**
> - * xe_vm_invalidate_vma - invalidate GPU mappings for VMA without a lock
> + * xe_vm_invalidate_vma_submit - Submit a job to invalidate GPU mappings for
> + * VMA.
>   * @vma: VMA to invalidate
> + * @batch: TLB invalidation batch to populate; caller must later call
> + *         xe_tlb_inval_batch_wait() on it to wait for completion
>   *
>   * Walks a list of page tables leaves which it memset the entries owned by this
> - * VMA to zero, invalidates the TLBs, and block until TLBs invalidation is
> - * complete.
> + * VMA to zero, invalidates the TLBs, but doesn't block waiting for TLB flush
> + * to complete, but instead populates @batch which can be waited on using
> + * xe_tlb_inval_batch_wait().
>   *
>   * Returns 0 for success, negative error code otherwise.
>   */
> -int xe_vm_invalidate_vma(struct xe_vma *vma)
> +int xe_vm_invalidate_vma_submit(struct xe_vma *vma, struct xe_tlb_inval_batch *batch)
>  {
>  	struct xe_device *xe = xe_vma_vm(vma)->xe;
>  	struct xe_vm *vm = xe_vma_vm(vma);
> -	struct xe_tlb_inval_batch batch;
>  	struct xe_tile *tile;
>  	u8 tile_mask = 0;
>  	int ret = 0;
> @@ -4023,14 +4026,33 @@ int xe_vm_invalidate_vma(struct xe_vma *vma)
>  
>  	ret = xe_tlb_inval_range_tilemask_submit(xe, xe_vma_vm(vma)->usm.asid,
>  						 xe_vma_start(vma), xe_vma_end(vma),
> -						 tile_mask, &batch);
> +						 tile_mask, batch);
>  
>  	/* WRITE_ONCE pairs with READ_ONCE in xe_vm_has_valid_gpu_mapping() */
>  	WRITE_ONCE(vma->tile_invalidated, vma->tile_mask);
> +	return ret;
> +}
> +
> +/**
> + * xe_vm_invalidate_vma - invalidate GPU mappings for VMA without a lock
> + * @vma: VMA to invalidate
> + *
> + * Walks a list of page tables leaves which it memset the entries owned by this
> + * VMA to zero, invalidates the TLBs, and block until TLBs invalidation is
> + * complete.
> + *
> + * Returns 0 for success, negative error code otherwise.
> + */
> +int xe_vm_invalidate_vma(struct xe_vma *vma)
> +{
> +	struct xe_tlb_inval_batch batch;
> +	int ret;
>  
> -	if (!ret)
> -		xe_tlb_inval_batch_wait(&batch);
> +	ret = xe_vm_invalidate_vma_submit(vma, &batch);
> +	if (ret)
> +		return ret;
>  
> +	xe_tlb_inval_batch_wait(&batch);
>  	return ret;
>  }
>  
> diff --git a/drivers/gpu/drm/xe/xe_vm.h b/drivers/gpu/drm/xe/xe_vm.h
> index 62f4b6fec0bc..0bc7ed23eeae 100644
> --- a/drivers/gpu/drm/xe/xe_vm.h
> +++ b/drivers/gpu/drm/xe/xe_vm.h
> @@ -242,6 +242,8 @@ struct dma_fence *xe_vm_range_unbind(struct xe_vm *vm,
>  
>  int xe_vm_invalidate_vma(struct xe_vma *vma);
>  
> +int xe_vm_invalidate_vma_submit(struct xe_vma *vma, struct xe_tlb_inval_batch *batch);
> +
>  int xe_vm_validate_protected(struct xe_vm *vm);
>  
>  static inline void xe_vm_queue_rebind_worker(struct xe_vm *vm)
> -- 
> 2.53.0
> 

