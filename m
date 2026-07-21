Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 868CCC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 06:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5527F6B0092; Tue, 21 Jul 2026 02:07:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52A366B0093; Tue, 21 Jul 2026 02:07:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F1C86B0095; Tue, 21 Jul 2026 02:07:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10AB76B0092
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:07:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8810B1203C4
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:07:12 +0000 (UTC)
X-FDA: 85011751104.26.2F4AF97
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf29.hostedemail.com (Postfix) with ESMTP id 58A1E120002
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:07:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=b1p0lkZj;
	spf=pass (imf29.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784614029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y2nagFUkBvdHM2YgcbGWIdC/AX2NTShYHGbwV0hgEjE=;
	b=7Ql71TAB3duJ5CVLfWULBKJ9u1vzblzl7c5uWTZKOTkuhJt65k2C/Rm1rhQb4kkHAGe3mO
	D5qNFv5X+IWCE9mY+GvU4haI1yvZkZoT1EpB9DqRIZay7Z9/mOWdWEskV/xl3h7LDfKfas
	R0mogyqeaIEmSZiLPOiSOnto697jYC0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1784614029;
	b=8A4LXVZCQ48UPVovDYVIE+vW41hTCfssmSB2bdJKsiMTJQC+fpVRvsKRGGDjZDf/2Yu+uB
	nS0nrjRnhHSUaWjxnZn+oKQePnURlW30yoEJzwP4Q0ihaNmOMogxt69WGQ5AkQ/vfsYg49
	jD3Oy18o8K0X8DHVt/e/XOxWnyQrVLw=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=b1p0lkZj;
	spf=pass (imf29.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784614028; x=1816150028;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=jN/KuUJ38PXgF7TPlqAU0COe7sJI9foz2w5hIkS+PtI=;
  b=b1p0lkZj4MdJiA0GPnKx8ede+1OABmAucf0h9hopqBapBo88FufAY26l
   5tHK7CrhE/b6HFwbT9atZri5LKaJl/LFxxYXfNW4oM4iKYpckPCHWlyk0
   mpCfp1yUK6bx+eW6bMvKlfNQBx7XeZRf6iCDhp3rE7Co5XrNqxCIM0lwu
   QlWmf3cEDP0R9T0ZKjvBu1ryN2aNZGSJPzTfwCwXRhZzMfiw1ssjosqwd
   wXkNgBEVuX6yR0u/k0s/VJbD0FYLuoBGE8MNAM3TaDJM0h8jdKj1Pize/
   olVLEDZ2OkUhDhGtUxZRC0/DGBuiIBk6JfWBw/4hN6j3ccjetSlgqQjMV
   Q==;
X-CSE-ConnectionGUID: jV/bsBT4Tv+hU098c6tj5g==
X-CSE-MsgGUID: 71Z6F6ylS0mXrkN70/xoOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11852"; a="89025909"
X-IronPort-AV: E=Sophos;i="6.25,176,1779174000"; 
   d="scan'208";a="89025909"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2026 23:07:07 -0700
X-CSE-ConnectionGUID: ZtYvcs9oRweKlViaxLSMJg==
X-CSE-MsgGUID: cLh26sZiQySwBrtZwJdt6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,176,1779174000"; 
   d="scan'208";a="257100616"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2026 23:07:05 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 20 Jul 2026 23:07:02 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Mon, 20 Jul 2026 23:07:02 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.30) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 20 Jul 2026 23:07:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g/7Qf+ueMRRe/hVQYnEC9DDjrMtfTUZVFJPWwrAtZb5uQ8PyRIRG4Hqdl/nU4CrhpdW0ghOmtoluy5LhkR80vQMc+1pG4VVj+e4g8rZkEC7teoa3ydoLgPTLDRLwy/fG9GVBikahFdXT/lBW9a7LaFwDEMlRg1EpoROEwNY4FR5vioV+IWLI7XGpYaDp2uJyBTXODjVBoVIxo0CY9fiY9DH2j0ByCtzrEHbm4kCtWPd1PO+R+QP62gByvZtHLCVgi4GJUWglE3xZ6QWo++F/hv4drbqh9yRbNqKfjof3TvRwlR1idmZPgKH8jnncOtnui1+yPeRsZqBkdXRkqom2BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y2nagFUkBvdHM2YgcbGWIdC/AX2NTShYHGbwV0hgEjE=;
 b=xKADWcTZp1/Grwk2tS67G200mEp934mDI/VQn1N0Zn5nzgbvG/6QOXzhLSlIBtazTd0dO41IamP4XbgsPJ7/zNa0ZiBwvATubMxYl+wJ4M4CNvTSBzMzremyAmPz55lJ95+lD34jc/TdYqaKG4qLV31QF6aAzhaq9xsKf25JmPZSrLTAcyHHvz4IjBR+DpVD9jacOG1H9pi6ogA48FdrQb91U5CE7+J0xytugO7d51buzAc3Egp2JX+X1YwdKBv1Xc7AU1XuFts4XG+ExvyemyrtOYd/q6r64yCwZSGXYTUHVdYdfD92RYiT6KpCfOVXxJh0/GhUSkihND6h44Fe9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SA3PR11MB9463.namprd11.prod.outlook.com (2603:10b6:806:45e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Tue, 21 Jul
 2026 06:06:59 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.21.0245.009; Tue, 21 Jul 2026
 06:06:59 +0000
Date: Mon, 20 Jul 2026 23:06:56 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Christoph Hellwig <hch@lst.de>
CC: Mark Brown <broonie@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, Linux Next Mailing List
	<linux-next@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, <linux-mm@kvack.org>
Subject: Re: linux-next: manual merge of the mm-unstable tree with the
 drm-misc-fixes tree
Message-ID: <al8MgHCXZ5KtPXmy@gsse-cloud1.jf.intel.com>
References: <al4jGBGNG_QACaNL@sirena.org.uk>
 <20260720144141.GA16699@lst.de>
 <al6aCizqqilqQGZ4@gsse-cloud1.jf.intel.com>
 <20260721045416.GA6737@lst.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260721045416.GA6737@lst.de>
X-ClientProxiedBy: MW4PR04CA0188.namprd04.prod.outlook.com
 (2603:10b6:303:86::13) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SA3PR11MB9463:EE_
X-MS-Office365-Filtering-Correlation-Id: 212c0121-2bfe-40b9-37f8-08dee6ee467b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|6133799003|56012099006|11063799006|10067099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: R0mnZH/gu/nHqwuWhdGTH3BF6rVC27AQzEeUUfQrMMrpbeVxoBRnonHPoWjMwxr3r5jIPEr48Km2b8h+dpYu2RAXi8sI6NL/11IuSc9dsLApMslO/tixNiLQeH6YBv44SZXtLYLmu53t5mIt3i+Z7HN2AOv1eLxRFGtMYhKpXPfIlNvr+6r2H8T9E9uiGugCv60wZJ0PL1cR5czyTUbJEsCXNPEl3dVZXfNQTqNuS0Tlq+dJraBZF6v2rrr9+8E/77G87C4JajS7LQjP1l4uP8MBXzW8sb8Y6LTDPIE1l4qLPN6zMFL1SwyU3pIx2JH6pVkoCgYLcppQYzFAIJ7Au2yXqZ+3FzN9ScL7wovFWWWdK9eHohJPR1aI+2B9/J4SOTFymx9lrLT0wYgZcAaXJGodCubHQeU/mPE3uXx1tzCSYHfr/RlQsasoRJ/cLOef9Q8HrMWl6VXvV02EPkHl8Or6NfbYelioVhZo8cKqQLlWPgNdRoazC9hmBSDPSwbNG0t1JA1OZYxVxb2SF8jZwi68X8CLHZJgf3y6m13Prq/joCjztuVWHZyHWeaJQVRTXIDNHiRIYfkrMWsQiWaS5uB+D417YXEsUD4taf0/URT/aiVot1+YuVrPhSJk4y57ejn79+1+5ozMu4zBMDvXdXtqLYllCivEQhLQ91syknQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(6133799003)(56012099006)(11063799006)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r1H08qHutpDAS80+S+Wv9IWGK8hoMyAZ4a4kc/BoJzDSeOVo65v05zkcQsrs?=
 =?us-ascii?Q?Bl8AxGL4VLqmiCXJx50YTFTGBNc7WDcEfcgYbgorKcn5G8P3nRaYe0EloodI?=
 =?us-ascii?Q?47ouCZorK5KAqjY9+/L//0U0kJRoig++6m6Vv8n+Hg0epvcQeYA/0ipUeOyi?=
 =?us-ascii?Q?kORJ09htbpY22DGVHqlHSeJEWV6lshTaLX/wjZ4LqYdAe8pAm4Z6vSfyLTmF?=
 =?us-ascii?Q?L6TW5xz6CPNZzl8WrM4DFbpCpbw037Bx7sPz1Xa6rMI63iSss8i0t2hKfXRh?=
 =?us-ascii?Q?9Ru45hSex6095QurV786kXTYmBitsM2tzc62YyWWn8M8PhLLBmrrMQZizZE4?=
 =?us-ascii?Q?4Jt6Ewr6DrLV1A0JQzesSnq3rSRXn4RPhQZmVFqt+nTWwsdEgluagmAjfjM7?=
 =?us-ascii?Q?ukJMWbIaVLaf+mdqkloCXiqpuoxPsQO1Xzv1wTKUlWZdSeAsizoOd2KL+w+/?=
 =?us-ascii?Q?p3I7wjizqUQO6P2T21653brXY0SHQLnjCed01L3ElDSdyqJv78RH+SydcBlu?=
 =?us-ascii?Q?Pmx2clo9Zcs+/n/43Zft7HR0EQBXzz792UM4Gu9EvCO0yOoROY01VyLXL9r3?=
 =?us-ascii?Q?M8ibZ0FDGLerSO2i5T2Ec3Ts0ayCqdaH2TK4/w2excEmg69fFkf4wbVp3kof?=
 =?us-ascii?Q?TOJK1QdDi9jXWY1ndc9ojt3+MmrJmbYw7rAuIC8Uk51kGv2ndkqNs3C4QDVJ?=
 =?us-ascii?Q?TgT3ED7rr6Ob2IuUjVmfrVisH/VdLPKF5UzQndYcvNSS3KGwBGGNq3jv2eYS?=
 =?us-ascii?Q?zGA6AzehaJLe20ZTeWfAl1JHAPBsh3V6UZh9DNA55U3qVvixucl9opz8zGxs?=
 =?us-ascii?Q?gRCqdp8+thgxwSgka+sHH83KLgEPs4CtHIlHc79bqAEvmrbgsfdnlYVrLXPD?=
 =?us-ascii?Q?mv9FeuNL+CRfpHqTph9aaqU3FIZCsSkbrHs7K41JyFkucsQwIAV5F11xHUKQ?=
 =?us-ascii?Q?DwU7+hHJZd6bPVqBSA1NfS8L/HB+Pt2WxnD/pxGSdKYXu4lSw6mDJYczL1BS?=
 =?us-ascii?Q?jHoqNuyKhIN9Im3B20Dj/DiLrBigjcCHmYIXi3cFtgm4aTkJkJqE2W0XSFHY?=
 =?us-ascii?Q?ebSiMYuchRlZFf0F4t+C78geVhLlMKm/1+8wxsNcvX8H80Q3ZulJhMCrettp?=
 =?us-ascii?Q?LRbaWm46GhCqJE3xjT9F3n7Sze5TSrkBPFEaHiximPs9kMwPWPXarGpNodc+?=
 =?us-ascii?Q?PHG1AC05B3QxiC9Du1l5Mj1Tp8rFeY9VS1hNYuAl1wq5/IZf5tNestGdwThe?=
 =?us-ascii?Q?gIrVBhXNdcoIiM63zPDW6WhnMbG5UdXNbj4vWcUJfiJRRCnHu9UXqaw+Id5A?=
 =?us-ascii?Q?HtsiHP7fjZW51bJoIGJJa2cMlpMF+ddgu/Th2oLIDh7Q6d9mIxfQcUjMjLrn?=
 =?us-ascii?Q?YO97Jbf8Hgq0YSAJjGJbvmO9JduC9mTLE6+jH/yGzFlqIhwdjfbYZZSFFloC?=
 =?us-ascii?Q?HsnzaO9ct0aoW+FYKSmSDuFidAtkL51qi8ZcuVS+JAkDJHImLs6RxQjZxUW2?=
 =?us-ascii?Q?rXv/LtrvWEfX4itEmSiyrbaBL+7fp65cnGSI0e5roXWEzUcRkt6sZmV/n92e?=
 =?us-ascii?Q?ie2mDDBmQO94ejoYSEr/TqV1fjjVKVSdHMAv1K99yjQUWHtpfwVhk1LPQZ2H?=
 =?us-ascii?Q?SGdLjFrPLrZwgQgPmJ54XsIx5e/DAnzgV/vwKVxCvlMIJEAU7baLQ5wN2w/y?=
 =?us-ascii?Q?JLQCuoeWUJo57vVEQ6kQCiB4c8JF/ZZipHBbtI8/52NBe0HadFWUtnmcNsTG?=
 =?us-ascii?Q?bp/ydaElx0szkPu7C9xXZDnq6r7Ph30=3D?=
X-Exchange-RoutingPolicyChecked: Ry7JVxpSMdW5+L1NZU9BZoHp1DpubF2c8NdFdft+SL7oBkiG6isGT/0yyyHTP2jJHX3j6vlS7FhxH6YhLy/q2gprcd2Alxu4O2srFIp2H8U6InD2XzGd66821L9vLYoEwr1MzRo3eLSZwEB9PAiIRGfyP3sf1mfUHlTObP4NXnK5vp0fEOoxVJTRxG/Zarm80YjMkFsU0MiQiLsQ8sezxFYgSTe8NkZBzL9A14MPruhCaKXZij3qKIcc05S04hB3v4Ri5lEiQcTYEFcnPy6kkLevG8bsKB+S+IMHhugew38HbY+WAubWeli9TshSJf1CfQ/6btRTX+bI7uI4TW5gKg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 212c0121-2bfe-40b9-37f8-08dee6ee467b
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 06:06:59.3949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DuiiAnNualTSrin5YQ52byq5oeC6365+a3DfxaFlt03WSBxR47uva0tLWKJP30klkaFioxErOy1ZheXDV7wB4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9463
X-OriginatorOrg: intel.com
X-Stat-Signature: hp8h3rmf18ur59imezcx14cbas5khi8a
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 58A1E120002
X-HE-Tag: 1784614028-643801
X-HE-Meta: U2FsdGVkX18nXQgAxuFO8th5WCWf+JHPCg1gJWGHN1hlohyGOzsZHRLn9Gv10jb2tCj/9EiEmCi2MeFwe7alhGmoy90MpAHgZyUyzTK8+YnPqidXFVfHcq37KyN8/ponC1hxToqE103hCf3Vmaliv7RdP9KAoplEPTu24DLkgiY0asEDQjKQm1+Sp2xj5nmwd0grOo4pS0zdunnXRidBGVp/wBRybehm6Z//FfvyIkoKeB5shDroUGyRrlAd4VOoWT8pIRnrPMT4ENj8b5d/1ZEG1ef8Y8PuBXgEj8tOiOlzHlqFPGVH40kzxgYSIFfnytKRqfMgGdqYFMjMG3uXMr8wOtKhCiKiw1GxJP+i3jCQWSPmCtlnWz7k+PNXxFpB7vZ4vy7tyyJgmS1KpQDj5k2nwo16v2MzD80qlJY6SNcVf2vyKaV49jcC4ACJoP/lNBSX7O4M8s4o3j/EtIogBMa4MEtiXPmGqlZRDlGhasby6KSJjZiKu0nhlyqAx5yzdg5g7X1574qzOlnegECNPWuaDynmfAtUv2j6lcFcRe1007EHBk2Nhj5dR+++3U5QAgtq+Ka/ME/7uzNxRaJ5J0EAG5zDybDqB/AuGfVtgCg2p0mzx3Qmg4ALAG9WoUKYmsEFzOHBZ4M5M9WMH4ELVMTwnkUQwAE5qu9lqx7jUqP4ntQTmTs9uptAEsi9OB+xoxfrE1is0yo82jPRtsshuKHm+e8DyDMYwMJun55t/7/81Kf8ZO4zwQTX+uxAHRRORbmDK1S4yvavkUs0noP6yiJYqrElypKXrtLl+lzonm/GTOh4R3KNgSv+5Q/raDvcVsSoW7kwwMBGKsNT/0TBvb7O2vf9EW2DJoxbSxLOklsCxubFgKpxFV5tFAiRdy3HQdSANEL7evL0cDUbqFHnzLFrOW+hE2dZ7ZNi9KVz6g+ZaE2McN3F6yDqnxn4hY4ljL46TOLd+4x9tRw3+Gh
 qX3DBr9A
 1Bwihn22ukUgHmSH3+3ystL6bc8lHuXprBybMsSqIllgfkxzeJO3/Ce4XOcwY4uPRcJyRnVzwRR3qIbcchQd5HwhLypscL3a91k+3u6a/xE2+uAFRmCbIIMv93qPHwWQ7JwE9tIgNW1FxkdAYOe8rdnLOVIZYx5XbyLG1HX6ltgcKhOCkUB1Gt66qQ5H+Wsc0+wWGfiGmKOCGlXjnXKM2iFRo2sypciykIBYMTR3vO/QSWa7KI43fk6EMcWiNTxLk7m7wURVa9f+2HMhBNyT4LMSlTAOy78sh/tQ4qUQjpMDRNDdGPLPwW+hriQfWBZfEseuA2jiKtS9iMaJmpQf3/PrteItzWymR793uJkhK4ENdMIrUFw39NuZd/J+57SeGEjljOT+I0RHYM045fDM/gz+C+c2LZ7IO3luM0GGOFjPfzXTgts+vl5bukBsWm1BZYNQPFY2fMJK0ICheSp4sJdDX14no9BaiIbAN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 06:54:16AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 20, 2026 at 02:58:34PM -0700, Matthew Brost wrote:
> > Do you have a suggestion of what parts to move over to shmem.c?
> > 
> > Pretty much all of this?
> 
> That's my first guess.  Basically when using a shmem folio to store
> data we should have the code dealing with it contained in the shmem
> code except for well-defined APIs.
>

After quickly typing something - I'm landing on basically everything in
shmem.c.

> > I can take a look at this in a follow up?
> 
> That would be great.

Will share something shortly.

Matt

