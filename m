Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19DD5EA852F
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 00:11:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A7466B0005; Sun,  8 Mar 2026 20:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05E5F6B0089; Sun,  8 Mar 2026 20:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAC9C6B008A; Sun,  8 Mar 2026 20:11:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5A7B6B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 20:11:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B39FF1B9254
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 00:11:41 +0000 (UTC)
X-FDA: 84524596002.07.A68CC4A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf27.hostedemail.com (Postfix) with ESMTP id 304954000B
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 00:11:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=B64nBcrA;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773015098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xyETtK++X+JP0bRIw8YjjCUuNsV294Ra3PWxrUcFsfE=;
	b=cwMlWrCsHndPl3UT34w/lBZ9V95plCzRQ5MO45Z5Foh+fq4T3uOQrPKxM5m/0ynEMPz9Mp
	G/wHBW9p5OAh0RQPrSgP2NzFL4TbW65daLcDwdu287mEHc+HBVFjWmDlQcTWYhO6AzwxJG
	oHjdpXPHyr0rd3HhpDS1dY/kwAFkloU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773015098; a=rsa-sha256;
	cv=fail;
	b=1TOZ+NMZRU1ehWv1V5L52SZk2DrKZ6HCqQfrTnAhMvsXOD1vLVxDqeJ3e0iB44aaK25gVr
	A/keECHni2XEIX7quG6Psrr2TQTCpjTzc2FjdPkHGWfwyolrf32k3YHpG/QRrkyMgE74uN
	YtqxUEVvt5F0plTybjdK3OL9zJEROTs=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=B64nBcrA;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773015097; x=1804551097;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=CBCv8cfnu/QXgjehmz4v25pOTBgRTz+pVq1o6sMl9BA=;
  b=B64nBcrAaT5K9IIllHDBmfKCg0P19CezfnMTWA5iVUTj42XvPpQXEYal
   HHhH5gUgpey83aTlnSIXSMEMKTBoXYiW3qrjvkCUIyhEIf6a4VCd0TyXU
   YSZaOQuRhzlHwtT+qihu1BwneOlwK5hMIQhoUQX31EH28FKE3MwmQdLGX
   SWy8UxgXJSJOU3FPoP4GU/hZbxZvdIvnpzjSiydVgPptEi9bm38OY24yT
   CmfSwpFRQYJ+0dbLFeYWvi2uc+BVx+3nZIIAZaaqBG3sBCywR6Jz1ZGaq
   cK+nli0cRg6Jen6XWCwf4TIkQnnDMIs2qPw9SiWo7aoVJS3b8RwmT3C6C
   g==;
X-CSE-ConnectionGUID: zbrxdQhJRA21UMzgl1t0dA==
X-CSE-MsgGUID: 7/i5S8SRQP+UNt/jgkFLvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11723"; a="73910185"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="73910185"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2026 17:11:34 -0700
X-CSE-ConnectionGUID: hNuvy9tmRqmHQ1Mz/6SS6w==
X-CSE-MsgGUID: GYD+x2h8RgGlFxQyW3P55w==
X-ExtLoop1: 1
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2026 17:11:33 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 8 Mar 2026 17:11:32 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sun, 8 Mar 2026 17:11:32 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.14) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 8 Mar 2026 17:11:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kz7dGVL39OXVFGO+RIFO3mDOy7ZY6o6Ix9HecY5HIWvqEQQZO9pI0E6OZzT3/kW/MuS3SXhma9I5AFQVANOQUvZKjGWcwrlO/vfRF0rcT1dUYDH3gb+p8Y1I5xXxIn7BRcuuCvuCe52rDdjslSicXkM31JR5OVb51Ut1mAXYaReKMIFI8VhCjvrFBEmJZWu2Dg4cVPOPAWT7ouPwMAVf14jgJJfX4fsrha5U6LhKkn/4yQpqZDlM6mZb3Q3RxhkVkACLOsiFVRfflGLKU/jZndsMrdHeMR9X2/aaVroVa+Oqpvs9IIcXgS5zxVk7tAshBVb6vgg3SdMpVh8prtsfXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2qkA/FdLp15llfu5K/m7Je9ukRdFjA62yITMLbyyPFs=;
 b=taPllMYmenZBAUykoi1fuJvfldvAtu0Tg4dnkEmcWat2s1mKZRHAJHInxvJhAjYBzZIVEdP0OZ85UfhliCyrQs9wQCp88OmefjTWDLL+4NiJZE06CGHUyJLpiRnuyhVtQuoSlbS4Eve9VKrK+x5EJDKhZjaEQtZkdLAw/Z+WJJV4qxR8la44kpaxDHZ5xSuE4Z/P0QakxfxMWxZbKs6NeoESCq0LJ35ERtYy6F9PwO+rXo43avCR2g4ZoygwuyFqcgZZ5LmdyW0X7ay/z4rq2/Yb10UQa41VCtz4CgJv0MigMv4SD86loSqYygMqMrPlg9meqgBlDK86RMQgW8r56w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7710.namprd11.prod.outlook.com (2603:10b6:510:298::9)
 by IA0PR11MB8335.namprd11.prod.outlook.com (2603:10b6:208:493::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.8; Mon, 9 Mar
 2026 00:11:29 +0000
Received: from PH0PR11MB7710.namprd11.prod.outlook.com
 ([fe80::dc6:ac78:d884:137b]) by PH0PR11MB7710.namprd11.prod.outlook.com
 ([fe80::dc6:ac78:d884:137b%5]) with mapi id 15.20.9700.009; Mon, 9 Mar 2026
 00:11:29 +0000
Date: Mon, 9 Mar 2026 08:11:21 +0800
From: kernel test robot <lkp@intel.com>
To: Anthony Yznaga <anthony.yznaga@oracle.com>
CC: <oe-kbuild-all@lists.linux.dev>, David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List
	<linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 286/330] include/dup.h:354:25: error: stray '\302'
 in program
Message-ID: <aa4QKbYOvGmDEqVG@rli9-mobl>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0157.apcprd04.prod.outlook.com (2603:1096:4::19)
 To PH0PR11MB7710.namprd11.prod.outlook.com (2603:10b6:510:298::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7710:EE_|IA0PR11MB8335:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c228e94-2145-4253-a0c2-08de7d706926
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: +h7PEZ3OCFlV1wf38DPSL5DuRY6eC+KMvrdtsr/XepCBQ2f+5/qs/QFqQa7vXm84NOPP0xPPHlsjJHekXwsy7hXNz+P6LH+YL/iQx3KMNeoleg2X+Th5bahziYdEbRvGIhjlcnP6yLhx8sIXmPq6071PtNkFXgCfkGcI1qcxy6tbEfy8/BdRKxk32q9XzDyUE4OMHl+S7Hl8MxhuTc/iD0gxh0UQ8EctwUeKbQo+jbVXykD6VHyCNVexLRV1So8sTPDtstzf2XUDLqmfzP3Iqq5GV6OKW2/QDTraF8LDTQ4seegAClIjhEDhY3E1nqmnBtYNPd76zu6oAYnzbA4oAmT6lc5iXxAy6MbsxN8rspkokW35lFaNPu4C7ov6LD4rGQf0xmoz3LDOi2WK5fbGDUcab41z57/WMaUmjFFt6z8JNEClsZo2ctaMCGKMmRCqasyLLckKlIsmyQXkSBQeuAhSj14H+B9Lryn+CS4WTe4hq0ArRrPw2ou+v8psm7VOG1LjsuAa3nz5n0gbLhQtIXy1QlgvoLL3P9oBeYF9PHQ/Hj5qdHHIqebMsYkXeLFzM8n7tCzfM1dUQ8MpHyuN3f0Oz1oDvQ3SIioOKam0ayeiKwKddhz31I1q4zKsf6lbDb8Tz2JOKyhqHI/58Kaf7AuDNQfVZE5I7LbWffOQZ+QBE24w1TEKg6R0iqQRVo7Z2uJw765UmfBcfwOHYIFsSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7710.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?MWkjvTTB0g4YwSrm6cJrsVD5vyKaGkcfjrpOEPXY1q9flQ3EAdK+ffsoL5?=
 =?iso-8859-1?Q?cOy37Npx48KJdr9geytW3y4wZ9fgoOcbb6gWi6Q3OhwzHUi1ofUj+kYRXC?=
 =?iso-8859-1?Q?+gwjp2xITkG7qb5IC7jHJ9yw8KyZ6o2uHZIWBHPmAPpTEljorh5kcVDtYk?=
 =?iso-8859-1?Q?8D4pEyumvlJhU4zz5N9Uq/7P+DHwsYhuc9QEIMHr+mrkJ0rMiywJonCtSx?=
 =?iso-8859-1?Q?ePqOzz9DWAdrfE03kngiJFpf4CRxPNDKqRwUQZ4BKa355eOwbMlgBBq2kj?=
 =?iso-8859-1?Q?LGKMTGeWOl3xATUoIgcd+2e5MYceXTCch0FPWdu/xP7Fm2tLZrgbdWIVzg?=
 =?iso-8859-1?Q?PuZrB5xgsyVtFG8h9+5nIdoHim/ulM1Wdy7MWSrdtopPnU6JRrdurLWEWU?=
 =?iso-8859-1?Q?IP0At4bbduMgkb2wZJiO2p1TYDDUsArUJTdnaSir1bHxRovjDscBXzcly0?=
 =?iso-8859-1?Q?LPKiOa9jP1KYzkFU5Zfi6fmuFeQSUsbrwAWXQ8hjFOJfAjvKKEpsK2TQmv?=
 =?iso-8859-1?Q?7c3ofV+67RCw64Pa3Q/SHBK+pDYCkku+sW3IH2DyMKlv/TXLvDstZ1moek?=
 =?iso-8859-1?Q?Z5U+juMMGtlM+F6jxymCi05FazyEJw1P8MQX2MeRMM6VnJQpzd9w/rTCi7?=
 =?iso-8859-1?Q?NYVda7z/0WQLDBxYxvP540nhi0iYp8WzFVT+h1HJWNHrCWFuD0T1H/c9Rg?=
 =?iso-8859-1?Q?c6LygidNRGK2EvlM6/a2mqupzxU1RVDEXJFMoVRiQYYjS5NaYaCC+XY3cT?=
 =?iso-8859-1?Q?nmlXQk0JBQEqDxJ2uiKqg0HP7c54pCgbg+psxvJ15sNhC23ogk25SnfcG/?=
 =?iso-8859-1?Q?RPrb0gPoVxbP7k4VsxzIvjbR8ASAtD1i8DR4zkXsh59LmpYS77HzDwOQbj?=
 =?iso-8859-1?Q?aVdZpGyP3Z0YM4qZxSkAvBhvPlsUxYPgfl8ulOvPB+XWuZ7OXom6EdPvFQ?=
 =?iso-8859-1?Q?wdGwojmOZE7P1gPqdIqtQew1KkXkhmKA/EsJvIicqTXdzV2xkvyosACLMB?=
 =?iso-8859-1?Q?3dNr+DtcEyTQhcs22Oi/Ndmt4cj+cLEfzL7KqlBzhGMmSm2LLmQTm9QFyS?=
 =?iso-8859-1?Q?eR9UInHAN9Dc7X5JzvXPks1NSDPTMM5ZK8vC9pwf7M9f1Shpfr/quR8MWB?=
 =?iso-8859-1?Q?nO7QjXpRJ3nwQradXf7hWFaqx6ZFl6UShgN4rrrhNaDqYQTwI9UEOW8Tlt?=
 =?iso-8859-1?Q?qJMc2LteyDpluTMHGZFVYSuk8WP5t/nAVdOhy65A4Vt/Vqz1N46QCQ+NPB?=
 =?iso-8859-1?Q?7iaaIcGxjpn6S3hu37kroTlwbI72Kkwvr37nb8XnD1i/MlWPn4g6BhDyT6?=
 =?iso-8859-1?Q?6/LuQmj4RaNBNtslUTK4zcxaB95HDBNJBMeTvX+rvHuFf6E4fWQlQ2TKug?=
 =?iso-8859-1?Q?0Cf/9eCq7CIkguc5pL/K/zd0h6au18Lx28/TLtmXnUAd8/lJQFBXAAmDCJ?=
 =?iso-8859-1?Q?n9F+ojiHPSzuqW9Ivhvp0y/H9D8KHw/a8+FYgtJ9HqZ+hV+z7qX1jRvr0u?=
 =?iso-8859-1?Q?MeSy/vY8jlCXEzGYD3hJLDvkRDxs3A0PuWQS4fHfNhEj5Uyr8R/nTqXFX6?=
 =?iso-8859-1?Q?KT5ms791bqnpAVJJMpooJNMZhFgyl9mWocG+EPJ63uI+cn+zFtAGOtvpnL?=
 =?iso-8859-1?Q?WXcg44FGICdlxoumKqOSCyo6nWd7OcdBueOp8eTS8K+C1LHmXN17k6ppDs?=
 =?iso-8859-1?Q?a+cpDFqzcSjeIXBX7s5dKiR3CliFbcaGc5Yxl9jasGwdj+QfGXW4UpqNZd?=
 =?iso-8859-1?Q?pRyf7gVqd9kG6OCFjQ5mqJk7tbnGD5h7ShzVAe+ymJ4F559g15r76LEBnc?=
 =?iso-8859-1?Q?Cj6e3vWFcw=3D=3D?=
X-Exchange-RoutingPolicyChecked: Qx76z1wDzL4Vpr05JwnLQOOKbOLc7ja17ZRpQW/fKm6YUxI5KHYFhc1piUFSHdlG7roBejt88XQbkh/+2vjXuRQlUCrgvLMavayuLU4bgZv5SXX+aulj0HN1fgqHvJtFRn141+MGbqxGMRBopBVrckTBDgXI5mHzW58ik1ebZhyT1kuqGbpDq48ZQAx8Dqc2+jndwS8tPZFMM1j5uSaRngtS4n9mo8zt2i9EHwii2MmHvDT7qaEakcXhqp8eWEGP/dGcC98PVbiylfNLVuqMZv5q1FEbVIV19ePRlq1CcMNxFaNq+bAy3uLe9kqlJWttY8n9YiqoVkOGa8x9JlvDdQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c228e94-2145-4253-a0c2-08de7d706926
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7710.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 00:11:29.0647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3B+UuJ3HY9jEAhAZy2mqtDalMUUdpzfCL0PAz+tpZTUbgJn48q7km9gFBiQ+E70xftavc73KSAw+pawSJOfRxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8335
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 304954000B
X-Stat-Signature: km8pciy1y8cay1imsdoot3sa356t6q17
X-HE-Tag: 1773015096-541694
X-HE-Meta: U2FsdGVkX18nGLc0+32uIj3qKlPoJ/AXb0KMPCCmYz8ZF/uhPMz3PB+In2zwcIlT2gjB32KAfqeibE/GXxk7c4glXPTZTfG6VzvFlXe8tvxmHRNOKiMt8a2v/U73kn2rdOHSLsgqBHnoC9OHdNv6zAANDXDN9NYmhLRQ2w0s1Zm7n3WYB5h1+HxJZd+gtm852YxF/Mqp+pck7UILoj5Nj9Za1Yjrif/hcbNw6wJES7H1YF9R8AKC7GD54nZweVtx71s4XamVsyEMSFdeRsfpYH3JIBW4zApTqe7mPdFWTD1xJ8aBlU2GR/89IfC964DGfwdxyd4KJuP6ocyoKgPbIC7qu7kTl9AcA3hzmPEjVf1r30SUh6tYcWpg3WonMw+2bcvsSvoJJdD9kUWsMKLWDz0acMVj0yRvUKKeB75B0y2fEOCIFV837CzIB88B+mppqKQ1FPu01a7wnos9yrKmRQtytfVGFnDzkQnU7J7lG/K2oo078zGo2gwqEKh/Cbwi9pzTNkoLGbGKyWV0E0BivONFk4E4HshOREEg0nYaWLvp+Tpdzsrp0y1+XKSCzDWjv5RqokA/bsyLtSH2UZ5mpjbYLHwnBGnKUOL1ItITX3q0Vu4f9IExv6rku1LxbalKZ7FjbQRfDinGskpwZKYp1EfR691BNE0rthpBEDDbR4geED8UVmcwlt5VcF3K7G3/fRMo47+nOXQcpleJuECI5cwgcvXYXh91pWT/K+7MrK1FPvUE0Y8Bx9yXGqUWx9QC2DfmwG62IwU7bQNFya47Lci9r59p50k9kLh2hrg76BC8Pu4PD2v/E/ijmu3PK7DL/DML9Hdgbdel16/XDec8aX3OvENeHClrG6DwenJM4wKDjX+H/9rl9KYvpKdz5jlb6R+qQiR2k/2wfjNXIMHYuEZUcaymBMjZr/BDq+/lIpjOj6tO113PL2tV41yLrkBXdMQw3gpOGF/1uiaBXt4
 UHMvRvQY
 WBH1Th97MBa/PsUkVmrcqOPfogI7gpQ+uydGllbdBMV3QFZnNpWLI+8dEpLsHUz/jfW/RdQD2OSrIbE/fSj0SbDFXnR9K50mSYVF61ZSPPHyN2H0P8y/rQgQpTuASKgile2qfRHs3SWGLUEePFyK8GiGx9Wif+dJVeutzqIlispYWciTVyLcx/bBgDn4ckL3g8H/TIc1FF3PgZfG5b9f7Izw0wFVc+b6maQuCcxdqOQCSmdJlQfIMchwu/aU+Dcfi+ZILeg2oBY64BjbJf5GPaxC1WjAye99uYrKIi6HPPGXCodieGsmk5XHwU46DWa4VrKtQPqURsvCnQaVrhYjfoFfOhCXOQOG+9OvjvLStBMq23RsXA/0j9ijO1+RdnKSuZXCK0ZCkQX5KMZIiQdEHi+bP/zT2tlVg+iNAiSphusrt4SrVgYXNovs3M/pUBX5dvWFSuAEd5UhxmBwYN6iozltkyDmWLTU4c4I/JPSEl+WYVV0oaxXWP5gMaKmg4cl83ega3ea+v+rv6opD89zi2agD1ugoz9o6S65reCw9ttCf8Z5wfYgTvSz7mhf/eWxU2EqFg0Iof7r0NM9MSWnOOSpUd+PmpF9pORzQe4UzIY5W4SCOkjI6PhhNqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   167400fd4c51f9e5ea8fc9d33c89c938799be4be
commit: 84cd8de2b92a1ccf493c43da8b31bb983d320ca7 [286/330] mm-prevent-droppable-mappings-from-being-locked-fix
config: x86_64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260309/202603090023.npem8cfw-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260309/202603090023.npem8cfw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/r/202603090023.npem8cfw-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from vma_internal.h:55,
                    from shared.h:11,
                    from main.c:3:
>> include/dup.h:354:9: warning: ISO C99 requires whitespace after the macro name
     354 | #define VM_NO_MLOCK_MASK       (VM_SPECIAL | VM_DROPPABLE)
         |         ^~~~~~~~~~~~~~~~
   ../../../mm/vma.c: In function '__mmap_complete':
>> include/dup.h:354:25: error: stray '\302' in program
     354 | #define VM_NO_MLOCK_MASK<U+00A0> <U+00A0> <U+00A0> <U+00A0>(VM_SPECIAL | VM_DROPPABLE)
         |                         ^~~~~~~~
   ../../../mm/vma.c:2592:33: note: in expansion of macro 'VM_NO_MLOCK_MASK'
    2592 |                 if ((vm_flags & VM_NO_MLOCK_MASK) || vma_is_dax(vma) ||
         |                                 ^~~~~~~~~~~~~~~~
   include/dup.h:354:27: error: stray '\302' in program
     354 | #define VM_NO_MLOCK_MASK<U+00A0> <U+00A0> <U+00A0> <U+00A0>(VM_SPECIAL | VM_DROPPABLE)
         |                                  ^~~~~~~~
   ../../../mm/vma.c:2592:33: note: in expansion of macro 'VM_NO_MLOCK_MASK'
    2592 |                 if ((vm_flags & VM_NO_MLOCK_MASK) || vma_is_dax(vma) ||
         |                                 ^~~~~~~~~~~~~~~~
   include/dup.h:354:29: error: stray '\302' in program
     354 | #define VM_NO_MLOCK_MASK<U+00A0> <U+00A0> <U+00A0> <U+00A0>(VM_SPECIAL | VM_DROPPABLE)
         |                                           ^~~~~~~~
   ../../../mm/vma.c:2592:33: note: in expansion of macro 'VM_NO_MLOCK_MASK'
    2592 |                 if ((vm_flags & VM_NO_MLOCK_MASK) || vma_is_dax(vma) ||
         |                                 ^~~~~~~~~~~~~~~~
   include/dup.h:354:31: error: stray '\302' in program
     354 | #define VM_NO_MLOCK_MASK<U+00A0> <U+00A0> <U+00A0> <U+00A0>(VM_SPECIAL | VM_DROPPABLE)
         |                                                    ^~~~~~~~
   ../../../mm/vma.c:2592:33: note: in expansion of macro 'VM_NO_MLOCK_MASK'
    2592 |                 if ((vm_flags & VM_NO_MLOCK_MASK) || vma_is_dax(vma) ||
         |                                 ^~~~~~~~~~~~~~~~
--
   In file included from vma_internal.h:55,
                    from shared.h:11,
                    from shared.c:3:
>> include/dup.h:354:9: warning: ISO C99 requires whitespace after the macro name
     354 | #define VM_NO_MLOCK_MASK       (VM_SPECIAL | VM_DROPPABLE)
         |         ^~~~~~~~~~~~~~~~

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


