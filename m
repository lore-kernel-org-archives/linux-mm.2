Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5969EC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C3E36B0088; Mon,  3 Aug 2026 15:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2745D6B008A; Mon,  3 Aug 2026 15:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13D366B0092; Mon,  3 Aug 2026 15:03:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBC686B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:02:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B4F9407EA
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:02:59 +0000 (UTC)
X-FDA: 85060880478.21.E9AC7BA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf15.hostedemail.com (Postfix) with ESMTP id 731BDA000B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:02:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="EZvamB/5";
	spf=pass (imf15.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785783776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FABqGcd19g3sQ6bdlkBO6/KYkry8UMKrcK89JHOCe8E=;
	b=4BLJa8lLkXSG96WAF/huMsvHDx0JIEvrfwQAqOdocl4mPoZCOBPgC4/J8w45QqenA+seaj
	DGJQvwyOoHIplr8VDeiAAH2qTPzpVYFsD2OLg3cqnq7g5nCt9zItjHs4v1QLPFCNMxq8O5
	MoI3LVHE0/9g4xS8UN2lEYeftRew4Hk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785783776;
	b=dBWBUrE0I2YMwgmgMW2gD9mcpdABtHE7uZkfmuqdiuFhZx7qCxGHmbtBBNRbmDsEp9WtiE
	bSMo8PXnneelFb/pjJE+vggIlQtvviyv0SNUGs2k14qJ4/ldmUqD5QcxSbv7uK3y+cLAu6
	c5EVvf9OrN8/bLLdDPZslTkXB0G2JBs=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="EZvamB/5";
	spf=pass (imf15.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785783776; x=1817319776;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=xo+lFiBSa1kaDsnqXZRErC+4WCQiBFD/qrlniKKszlM=;
  b=EZvamB/5fFksnvCDxvG926zcG1+YuucOhDGsgTz30HQveTvFWPoOZ1ak
   rf0J+CmN5KESyZmGmnA1/iR39zfRp0uFj1EzDGLbAdpKGOta+cg8w4FWm
   WnL/bMT0RxvbW0cXlnO14/BhVVPs9VMyR1j/f0rramk0YYeZTl2IUMMk3
   /wNqKZW30xcmkSuhm70v8iCSkDjpUBMNMJ3Q/zqg2dgG404LN1ZT4YOez
   5ozDhaAtnbvfl4ftv7yZxOniB3q/ORVE+d82Ck+HMx5h7Fz9zpB5Ah0kf
   okrCR3xMkQ8S6SVx1VBU+jktPNARy8e0bECzUhXfdkYJLkYJM+GoVfdlU
   A==;
X-CSE-ConnectionGUID: pZ1CTgFpQTCn6Ucktu+NDA==
X-CSE-MsgGUID: rSmskZc7SJSbc6Cyx0dTxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="86449768"
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="86449768"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 12:02:54 -0700
X-CSE-ConnectionGUID: jbi5HCpVT1iU5l3h4Var7Q==
X-CSE-MsgGUID: qVjI38tSSW6VS4XrWUkJlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="265560687"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 12:02:54 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 12:02:53 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 3 Aug 2026 12:02:53 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.33) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 3 Aug 2026 12:02:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YkiC0trphD2aHXOQ/jMPYgOVrlvCbTDO5oxoNQohw840UqWTQiGZc778x6uBHFEU/4CRwn7wISh8a4XyWQSWFSzNdgHy5y2zU3VM1N9wdr2Di/eWd5N3LySnMVON0x9mIbkSaxgLDQYEuRWdAVinb14gQ6W1NVnQlBRB0T6f8PTur4w9un9P/Cr8u9aQNZbtVnU5UbAbd/AosfG9OJ6KPlHWMhVl1Q2/QYVAW/aTJ4YrRs32M+e0tQsdNqnf2gS3ETJB2Eru47S7jsX26mLk95OmBvlN4KXS7JPUI5H+6y3g7TnjCwAHNFLFx3CFETFQKGOXDwS4pYAb7dCfkucODQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JD1GdiENOeVn6OsWqxB+Fz++2gtaL61sOnA8kv+LihA=;
 b=wzK54vBjc82RYrsA4f2RtEnNagh9wkg9cVhYjXZkIpw1t3rqv6oVYRWhOdec0UhmRazwY9mUgWpH4I2GloR4O++p9Ar1heaVPTC5mXxUZOYlvda3x9d1KpDW4DCQ7exx+vpFNerWmh/EAe1kVcdIdkRXxlvsSgbp/q9xfy3kqo8ZNCoqfv9p0hstqce+0fHejspv5v7x4hoT8rODoTyvYkqL2t9xMVLIm/M3zqHVuC2WOA2PAziYC7Qp9TJ6UxpAjc2Wq7DUQnGHG0qDkxlvEpBjZxnYaprxopHifwLq8cgMqHZtxTJzeX1u1D6xA14t5Xyfa4xWY5+ZDG6L7T5XAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by PH7PR11MB6353.namprd11.prod.outlook.com (2603:10b6:510:1ff::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 19:02:43 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.21.0270.016; Mon, 3 Aug 2026
 19:02:43 +0000
Date: Mon, 3 Aug 2026 12:02:40 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
CC: Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>,
	"Mark Brown" <broonie@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, <linux-mm@kvack.org>, Huang Rui
	<ray.huang@amd.com>, <dri-devel@lists.freedesktop.org>
Subject: Re: linux-next: manual merge of the mm-unstable tree with the
 drm-misc-fixes tree
Message-ID: <anDl0LRIy/Yg1Mfl@gsse-cloud1.jf.intel.com>
References: <al4jGBGNG_QACaNL@sirena.org.uk>
 <20260720144141.GA16699@lst.de>
 <al40qCMTxhEP3Kx8@casper.infradead.org>
 <al6cVnNv2TuhuiV3@gsse-cloud1.jf.intel.com>
 <al+kiyFVgrulSneA@gsse-cloud1.jf.intel.com>
 <c9f42173-4ad8-4818-890b-7b0a47c6c6c4@amd.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c9f42173-4ad8-4818-890b-7b0a47c6c6c4@amd.com>
X-ClientProxiedBy: MW4PR04CA0355.namprd04.prod.outlook.com
 (2603:10b6:303:8a::30) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|PH7PR11MB6353:EE_
X-MS-Office365-Filtering-Correlation-Id: 86cd3670-0c12-4047-0bc6-08def191cc53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|10067099003|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: N0i+6sFCmh04jFVn3HtAANQD25VrnsjsRCC7yAV3aLjI4YJ/WkBzm526dG8Lv/Ek46gB09EnvM6UGnqlYp1/Lbbz18B0RQdHYG15inVVeNUL3RHmnlZ6vLWgZKOPkopPr/Tos0CgO1znW1GCZNSxarVqVtZPueJcXRV1lwrUQBbiaEnIcdG5F+9ZUyUgURGw4fSxog0ug0IAX0lmfXeAUFlBeZ94+FOakUKCiWTg4CEvOX/ASeC6ry7crlHFe7tzbKf//umtsPN5Utypqv2twuTfxY27rBSX99SP/jpAxhIqOuQyJbQ5W/9EIZ0E+F88+SU+U6NIRp7eA79E6WdDDWRPCaw+BLpn3ckfb8gz5zu2fpxvd7iaIweA0iD7WU4EJOeMjlBRz4TyaWP+L38fPKIluSRQiJCKaCZ3cJTOSuHOsUzOLJp9zeM1MQmS1UTrP+Td8i6OJAO9lj6/6HQKtmuvKyzaY1GjkZmAUffE+DlYFiHUQNV1lAczgPJ8ibxoj0jpte63gBEIbfPT1M9ssE6sqjgb5RwPobPtuMrKXLvpeVRPu3Brszp+JmyPP5q+qZDzVbDi0z1DDw3viDL36a28BSKBJ7OA06nWZLcrRaZftC7I8k82pIJAJERid/FrM664x//p77nEh4iKdY7Gof2m24D5ESm7yAvksLK+7lc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(10067099003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?8Vn4tYPqmIgYPPKGujldpfEPlSJVErr1uVlcyW7Rrm/gnwjiXUgME13uFY?=
 =?iso-8859-1?Q?hZMQzCrCvnRSNJ54YHMT9qentdsE8c+uZFtRPE2+5+vYLvUlcBbWKlbR/m?=
 =?iso-8859-1?Q?KXFYAQezTsvKRT8eGsUPPXkt/GF5FUJjSq/eMouBMjmCKbFKddqLR9iewQ?=
 =?iso-8859-1?Q?w8Irt0RdyRBGpZjwlVQWAGXWgTmrao1ZJ/LB1+0zRVAtEwkpuzp2WWHU6V?=
 =?iso-8859-1?Q?+4SRvemSXsNDoFkW/wxgsHBF17qFnrEoVW97ry0rnNWMw+O/XvWZh5YiXj?=
 =?iso-8859-1?Q?THHoszuW6JQA8GoSSMiBCb4PnPJsgrF7Z59Z7wSI5i+pxfLBCmupaKwEAQ?=
 =?iso-8859-1?Q?DIJiZ3DHn/y7I2QMeOcQ9JYRS1x+7f4cX7lAfieWdqfkG9LvKrflpvFv3R?=
 =?iso-8859-1?Q?MGQAfCCYdzA86xOg6hRJhkLY5HhWp2WnQxF9tZeTCCvgQCKE6mDbOnz766?=
 =?iso-8859-1?Q?1Qmqhj6z2V/KeW2w5OLkQvMG/gzYJ2UIABUPFEf1mjryBYXZ5RHuW2Kja0?=
 =?iso-8859-1?Q?JFMU/3i/NxCj0v+9YlFta5ySnO6p7J9NMjCizndtHiweXKYrzH3j85ocLo?=
 =?iso-8859-1?Q?Hk97dNBTNcAdx5nvvwzkJJaeG2ypKPYLUBzPQhXZpXquzADnkpiMPg+CkQ?=
 =?iso-8859-1?Q?nsiYE09qbSs5ody+nJEdxASx5T+dRdC8JUY5FRBD6h2pxx+6tJODjNK6mu?=
 =?iso-8859-1?Q?3g6i8Q6ITVe3O/dLVv8f2JimRNnoEKqIRxo/o25F+xq1eOkUmshiFrNj5K?=
 =?iso-8859-1?Q?On9c3OPM0ji5W/2Z+HR6zdxa/oz332oCiJkzik5WHEydF0/Wa8k1OGm2V+?=
 =?iso-8859-1?Q?Jd2Bwxfitp5ZkTfbp0j+TE/WRQR+PpI7Xt5PlA7G4MeOm7GlLFJePG+Kgg?=
 =?iso-8859-1?Q?/NlWF/H/s4nk3GmHYGwzVPtId8hHOxgOe6NE4EoCvczD9fXCc3EYOf9oR1?=
 =?iso-8859-1?Q?Y9xRWMxG2lfFUOwxNZplfEg3ln3D3y5tSre1MVtNY+VRLrvlnUFasZlfsM?=
 =?iso-8859-1?Q?6noqs96vM2xc9L+BQ0v8Fdgn4NKY/E8BisrVz1I99ewBYvXwZpyde+4QVH?=
 =?iso-8859-1?Q?NxC7wz7ptOIC4pxqAd/fhy6suoCzSveTW5fVrerJ69XLqL4v3unUGhuLDW?=
 =?iso-8859-1?Q?Xn/RbnCHwA5ddMUfmBcLipVx6EtWBeJFfFFe34foTB+RK/3ZYVUnifJbeX?=
 =?iso-8859-1?Q?5Ulj8ED4O9dBgcHOUt0/UOYJUJQaYh2Xn2hdxSAXMy0/W4RzuxBV1dcsP3?=
 =?iso-8859-1?Q?xR8YMiPqjvM0PDoTwsLajCAp934mDjNqZ8HwjqPh26ofAFil4qAyswdURj?=
 =?iso-8859-1?Q?/56i2WVqSowcrHdrtrpMS6XJaIskZiOyXnBI92LIiWPeyECawGWDm1Rv01?=
 =?iso-8859-1?Q?cnfDBkHKwXDh7L1RqrAvWH5yEaE3kJ6v9YuY6RzwR2sKZg0UW+ufk415eP?=
 =?iso-8859-1?Q?mLCtn5pi6YD4BS3boldeiOwD0f/gwQ4+WyJifhbKgVxBSOr3cFvBmdmwXJ?=
 =?iso-8859-1?Q?1BkPUPlMK0HGkSQFCJpxVTr+QVh48GFVsVPNcviJMU+A32A7qCXrrq6LGG?=
 =?iso-8859-1?Q?cFxRYQpJjzXamiTriSqIBAo5sfN1kSuqpIHYRr1i4ny0PnHrYXbRmRnTnP?=
 =?iso-8859-1?Q?ySIIhu9r+Ul/GHBuFYkHYwNLpUYn6kV5IWtE8cVBF3vIwZqpe8bIFDCd6i?=
 =?iso-8859-1?Q?GekiYofLdwL0e52himpK0hJXdvNRtbhkIrodaoN4mtX5uktz3Q+7lZGluT?=
 =?iso-8859-1?Q?i5WXbIE98VIxQPmHb7oqV9skifoEyzIox1y+mpYJZqpMyzM5omDJIAVf+0?=
 =?iso-8859-1?Q?r4n/UDgGag=3D=3D?=
X-Exchange-RoutingPolicyChecked: Qh+eJy9Kcg6Au97gm+/WNp/RNIfkIa9tZZEOIcetETq37aHefMSL/9MIQm2emr7WdRKYwFMc0narHrRw9fUL7kSU8ZKGdKxoBAejmMo5VL2hxNnBBauHSQWdsIo/4PA+007YBh65MwG9A1meDrvnfpUo+WXSPEO0RJSUT1BxhqA3ZFYBPp9cEbhzJo0S1dvNoSLR8uPMHBRu3hYPhTs9o1W3k3i4M7y8cFBn0LRJCMI7UQxto/mVGOMfG+aCaVuBqn0QAMCZDoKeGAiA9wPJglk560cloFJFKuODmfyigz0OuB3CK9rOtM+CA8lAyICeZFA/wLqDFwpw/CGN8e/hPQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 86cd3670-0c12-4047-0bc6-08def191cc53
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 19:02:43.5128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nV4/4WwshaU4vOBm4bo2ZYo+MSB0ECiwhv/1YDAjf/r9HfAXMShtldsBX9DHMmRfQovCa3HYWKdsSqr/LSF7eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6353
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 731BDA000B
X-Stat-Signature: t1kfxokwakb6ghi8jp5dmbc43keuf7sa
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785783775-607896
X-HE-Meta: U2FsdGVkX182v4Q5mfPJ5pFwaVJNpPkxgTxnkrnsmJuad0f2r2oGOBZzBxzn9LzvKaK/Rn7xJBvuTYLXDD+wMlcYsRqM5GIJ62xd65TrMsLCcqI9n/+8T6DreypatFi2g0XuMHvA8SWt/CK8NbCBZQrCOv82moE6/7kkO4+XcNo68/SRQiLenijcyU0HWM2VTaz2wkDNVBZhzg2RL9eyowgsqcN4M1UT7dJ4Pl8atRc+87w/PgjeKPC+IDIVmZIfoX33QAHKq2XJMCIM7RJ7tVlrk/wPonFKf9+05+MX/q9qAw3cDFWn2k/VD8xI7bIp7dxK2WowP5fUdSpGil2qdZZ+4vFjPn5wX8bBGrH4/r+OjgVC2r8Ivq0wxVLYDj7srxxtth/SNekiOL56hsJXAIlU1nPzQwCJ8Y/2gscma5ehF2bNDILOpmVXIvxCVQg4RJeaPSOGUxoU8Fgt8T2AKLwcIKzhJdSUEIslp80YjcNdeEabMhXXurIO3rF1n+UqxLq7/57RM6fZsKiFKQru+qnMvxW4WbC0EdYJV4QKHSWn1ze0cAZ8r3OXz9F9ss73SLGMHFTg083/sjFgYSEYInh1ZyIddYmxL4rVYveWC91RxzjUn/cDrcN/XMK0bd5xLlq1J8Z5ii1h5oQq3YPqKjEgojjZCQISo+9nhlQ0FySgQYfNoNu4bFtXEKg2aSkU4NB+p3V6xtZDU4KKTNB/u0oRZa2Td29CfgigXmxmDYzcyWZ3pEw1aAOwcyBsUwUCwofXIvO2q6mKPRFPaAlh4scz4w9QHbQc1+qIaiAZ/2Xq1Pjs7wTS0v7CeBCdh/+NNkbMGAfRE/q/TgCHCspoyjkRkDCWI8x28sMch3zODaefNu3Jg/pZOn/3U/9BlvOXB9y0imQKs32cn6LYSs5klutQ/6ees8VhARo2Otf4LDR3KKG4mK7EvBfNWtQlZ1TFMwvVf670Lwirn6o3F0+
 11jC/bhy
 lHsXdu0Gluxwf8eRTShyG9h3KFeHPYn0w2TZ8XFefeQBcHS/XIPgXHISSMY8vBBTihULAYZjbPR70VuNgEYqv1Nq5NNYl8ZUT4PLDYpq7eNXfD7xKe59jrUcHbpmr3ZITQ5KUXtl8zkFQc9ILgtSXBlxgmEbzw1rlVD9UqvEPgcNDpIDWiFkUETxATs6er68zzKheizu1psodC1Hht/YiI8v+AaIUqUrH7e+A256P5sIMFeTuGVYymLPiXjm8qZrlA0fhWHCJi0Zkjf6Y9Du+K8W2cXk51BKdlxIHiokAANSf8gNjurd2S9I/56zW8FT+VPp2+k2nWoxXr6cf3Kf4ECMUE3eg+6FtYrymddGXDzeDlZxKBjajCfabbd+kz3qtMQp2k14YidgZQJzNqsqDF9LYhSWT1lQEoYI3LAq+jKNb7uULvjMe82NtTfCitaoFaHrqK4lFzDRXlCHMh7Xd/mhP+51U905OP9EXNf2gwvMASszTDj5mDxiK+Ih4lu+RGQTh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 02:55:45PM +0200, Christian König wrote:
> On 7/21/26 18:55, Matthew Brost wrote:
> > On Mon, Jul 20, 2026 at 03:08:22PM -0700, Matthew Brost wrote:
> >> On Mon, Jul 20, 2026 at 03:46:00PM +0100, Matthew Wilcox wrote:
> >>> On Mon, Jul 20, 2026 at 04:41:41PM +0200, Christoph Hellwig wrote:
> >>>>>   /**
> >>>>>  - * ttm_backup_backup_page() - Backup a page
> >>>>>  + * ttm_backup_backup_folio() - Backup a folio
> >>>>>    * @backup: The struct backup pointer to use.
> >>>>>  - * @page: The page to back up.
> >>>>>  - * @writeback: Whether to perform immediate writeback of the page.
> >>>>>  + * @folio: The folio to back up.
> >>>>>  + * @order: The allocation order of @folio.  Since TTM allocates higher-order
> >>>>>  + *         pages without __GFP_COMP, folio_nr_pages(@folio) would always
> >>>>>  + *         return 1; the caller must pass the true order explicitly.
> >>>
> >>> Wait, what?  This is just broken.  TTM should change to allocate using
> >>> GFP_COMP.  Why can't graphics people ask questions before writing stupid
> >>> patches?
> >>>
> >>
> >> To be honest, I have no idea why TTM doesn't set GFP_COMP. This
> >> predates my work in graphics by nearly a decade.
> 
> Oh, that is a rather long (and sad) story.
> 
> TTM (or GFX HW in general) has the requirement that a page once allocated as huge page must stay a huge page as long as it exists, in other words a page split is not possible.
> 

Right, but I'd take it a step further: pages must remain resident (for
3D workloads) while DMA fences are attached to them (via the BO's
dma_resv).

That's why the pages are neither on the LRU nor rmappable. In other
words, everything is fully managed by TTM and the driver on the graphics
side.

> This is not a problem per see because in theory there should never be a page split required for such allocations because we map everything into userspace using VM_PFNMAP and vmf_insert_pfn_prot(), so the special bit is set we don't have any direct I/O, swapping.....
> 

Yes.

> >>
> >> I found the following comment in TTM, which was added in this patch:
> >> `git format-patch -1 bf9eee249ac20`
> >>
> >> As far as I can tell, setting GFP_COMP would make things a lot easier in
> >> a number of places.
> >>
> >> Christian, who maintains TTM, is out for a couple of weeks, but this is
> >> something we should probably take a closer look at.
> >>
> > 
> > I have looked into this a bit, changing TTM over to allocations with
> > GFP_COMP seems pretty straight forward. I have local patches that are
> > working with my driver (Xe), will post something shortly.
> 
> Well it should work in TTM. The issue was (is?) that we had multiple other components in the kernel who got that completely wrong.
> 

:(

> Especially KVM tried to grab a page reference from walking the page tables, ignoring the special bit in the PTE and then just incrementing the page reference from 0->1 and then later doing a put_page() into the middle of a huge page allocation.
> 

This does sound like a problem and a bit more clear than the comment in
the existing code.

> Long story short that already resulted in multiple CVEs.
> 
> So yeah in theory we could use GFP_COMP here, but we need to make sure that this doesn't break anywhere else.
> 

I haven't tested KVM or audited the entire kernel, so it's entirely
possible that my attempt to use GFP_COMP broke something. :(

It's probably worth investigating if this is still an issue. If it is,
we should at least update the comment in TTM to clearly explain what the
problem is.

Matt

> Regards,
> Christian.
> 
> > 
> > Matt
> > 
> >> Sorry for sending a stupid patch.
> >>
> >> Matt
> 

