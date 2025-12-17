Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A188D64074
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 05:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCCC16B0005; Wed, 17 Dec 2025 00:27:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7A5F6B0089; Wed, 17 Dec 2025 00:27:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFA346B008A; Wed, 17 Dec 2025 00:27:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 97C536B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 00:27:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2D31F5B782
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 05:27:34 +0000 (UTC)
X-FDA: 84227830428.21.58ED8DF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf17.hostedemail.com (Postfix) with ESMTP id CF0CD4000D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 05:27:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LOfs3dx1;
	spf=pass (imf17.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765949250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UiD3f143pdGkliWJs4UtBTImqbU5I3Md6+WrL26Ua8Q=;
	b=5f6kBvo8S7ITLLVUyk6fZ9D9fGYkZT/zp873378K+pmCHetFNk2fZPip3zGkeytm1EyD+9
	NEAAPbAWsAbIhZ63P69Bw7ZHInIuHEua6S499B3wx42+++ppwqqXApTJieS2hKL120yFgA
	B+da9UubYhLK/NK4owQ9X6mjWFSude4=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LOfs3dx1;
	spf=pass (imf17.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765949250; a=rsa-sha256;
	cv=fail;
	b=CWB20C9+l2gK0xDgBK32btkXcwiy2WgW42JMPtrBoREJQa9eoGdJ1YqoYoEjYpzneb32eh
	YV2yW3ENn158r7naI4YLijaMgGOCu6EXJEMTDXPQpMqqh1/u6wsyk7bXmK/cCA6k5pKDNj
	UPA/CkGGoLZUJywKtTfxCqpKuO6E/6s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765949250; x=1797485250;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=aPzvnFcnFrASudo8J13XPms9D0876yPKbKGLh7pcdiw=;
  b=LOfs3dx1avqdMbqzvCJmNJd+leIjblLdWKpy9xGQz3tZJY8bEg+OdY8K
   Fq3c27JsBE21SBgJkzfcNkmGXZLbp5qH5RvYj0Z5PNPTnabfKP0l7UhT0
   8fgSKK6br+0ZnyJ1+5g0JtkeLI/Is9T4ZiPxJ5N6ANhQq48js7BwNTpYF
   O+3ip2ajfMbf8MAsA2ROA57yVuxPkxsbebm4vVi3B9keWFzZGHUe1cnBo
   w/6MeZpas32Fn9POOu46xghguw2Rnfn6eByTY9Hmempru8lF+No7HIlvS
   pJzFa+0z+hc7LHqKjdxKDVZfwEFqOLJSEZFtJOo5yzpDdzEvEXt5qDNJg
   Q==;
X-CSE-ConnectionGUID: oYGaia4SS6Kx9pCspizZRw==
X-CSE-MsgGUID: uWGOCp1DQDCSvyqSVGZTLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="78187480"
X-IronPort-AV: E=Sophos;i="6.21,155,1763452800"; 
   d="scan'208";a="78187480"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 21:27:28 -0800
X-CSE-ConnectionGUID: 93DP1UwLQ0uHmg34ynT87A==
X-CSE-MsgGUID: x67VGrWwQ4i45sM27O9WXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,155,1763452800"; 
   d="scan'208";a="197491275"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 21:27:28 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 21:27:27 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 16 Dec 2025 21:27:27 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.44) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 16 Dec 2025 21:27:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wIq9pJyvaIAZoAPXuJ/HEU3R7HflV8jjgfKQ1ViU4RDP1RnaIr5T2MezvF2jJidxg9Q06v8KZgk3k3KWlrVBQ0wBwI3Oc67+YHcTq7/to+q32BCh8Vd5QM1KeZBUOyCll6gPQ9ikE5+2CvLy5qLu59CB02nvbxVq9EPwhR82ZbkFZyE1Ej6H0xKZ2SoW76aXKmqWXhA0iJFmvjcJ7AHP12cidf4/Pq5XpMwA+u92tAxj9KIl4qAfwaftIau0pBBq1mKTcD8VSM07zOzgI7NpGubpp8wmc0cUhOdzMJ3cx38+62NHzfmYkwgNjJ8rWOIZomzhF7tif5xGAhujwXDDPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D0KOmHbNf2Xzj9ReOsPnAHDrMPnh9QnsHL65SIbkigg=;
 b=Ld+1H+MkHABr+XPC/7JPZRwOiqe27TFHQ2eDJXXBJ5pYXU5T/uqR+apM6CFnlPtAm9YcxErvgHoASubzhg/k/KdYk8XdHoO2EEJtjIrncPLEGgkXlzqF/oNehULjimtqQUESar0D7ZcfS2nLkCE0js5dOG+cRPK0VonAGD8RT/U1xImb9Vpkw6b+rvZlAysUYVB34K+fl6hHltSBDh+atjesnD/+I5kVH4Qz3MXy5z+SVYFQfqaYjNwmT4Cz4Fl9TKp/NWdKw+RQUuT0gZ+7xTnxmjK3apijaVttUgPt54aRbaQYPZ4YZEdE0iYx8jDmMxUCdMSNrOTW4Wnfvrld4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH8PR11MB6949.namprd11.prod.outlook.com (2603:10b6:510:227::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 05:27:24 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 05:27:23 +0000
Date: Wed, 17 Dec 2025 13:27:13 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Uladzislau Rezki <urezki@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <bhe@redhat.com>, Alexander Potapenko <glider@google.com>, "Andrey
 Ryabinin" <ryabinin.a.a@gmail.com>, Marco Elver <elver@google.com>, "Michal
 Hocko" <mhocko@kernel.org>, <linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: Re: [linus:master] [mm/vmalloc]  9c47753167:
 stress-ng.bigheap.realloc_calls_per_sec 21.3% regression
Message-ID: <aUI/MZ8sGDt8toOC@xsang-OptiPlex-9020>
References: <202512121138.986f6a6b-lkp@intel.com>
 <aT_8woTbtklin3Bh@milan>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aT_8woTbtklin3Bh@milan>
X-ClientProxiedBy: TP0P295CA0014.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:2::11) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH8PR11MB6949:EE_
X-MS-Office365-Filtering-Correlation-Id: da926439-4967-49f1-9378-08de3d2cf51b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?QlrpLNVKYrxXtbs+VWHBzOQ1NuCnKi1Qup7FoR7LzKJamqLu/Ex3+gQhUo?=
 =?iso-8859-1?Q?0lwqqdWcnYIEY7/0JzqYRV3xUZiEcviyLoP97zcU1UK0gpNf+XzDqF/ZbT?=
 =?iso-8859-1?Q?5Lm0+LslgF7y5aC5zg/8iSpmB/WRXGvI090BtL78vI2P+bvc5sMO7s+5HM?=
 =?iso-8859-1?Q?HesJmnswsa5AHJnXjHdN4LYb2UEoGfQIn+Gq5ROuGyhyiFL0BJDkYd/inq?=
 =?iso-8859-1?Q?WXRVi019yOV3yOUOkKFh5CMZA71RCf1I+4nW6ZDC4PkalbVhsSp0fFmtsJ?=
 =?iso-8859-1?Q?QcaTRzF5UzBXxPD6cigT1nUDAbwmxhgke4+mZJFoV9f+0mWE0d4HrnZGXU?=
 =?iso-8859-1?Q?R1rWCXQ/2yF8MiLyw+FiLpMnyMkW+5WNDiP+/7mRHrIXPgHiGgFg97X04G?=
 =?iso-8859-1?Q?Luzl/adGtSU9ouWrYw/hckXGrfHp/Bzk57+JrKdFUxq1BV12SxdgOQ6QGv?=
 =?iso-8859-1?Q?j2G0p1GLU0Wd/vzh4OYGd0pAsS3RjED0iPG57wEtTl88lrjU0Tq/07B+MU?=
 =?iso-8859-1?Q?uYO1PmNQvrJxB780162guSAlUkh7cjfXI9qmasIgbHY/nTiDZZR5my/4a0?=
 =?iso-8859-1?Q?rwMdWxyWg2hi/3ijOSNO5MN4Hq1Tnd7bjl/XJa+qOZFpolcBcYPtI3LAHd?=
 =?iso-8859-1?Q?miPEFdyWTez+E9wfa0f1s0YY4INm66jT1SVZ/rNQQTc4glePr1uIDCjBec?=
 =?iso-8859-1?Q?Wqkw1DHFx7iJPuqsgMfLBUDtI1YiJcWdySv11qpi2wjEy4hkWerpLMOvVa?=
 =?iso-8859-1?Q?SizQ8/5uOTVHEShRQVSGQ2fs1k2mPtqkQxuiXpJDRGBPfmuyODSkkvC28l?=
 =?iso-8859-1?Q?uX9Fk7RFErEoEt/nO7MFL4nbJQTSWHd+1aNnImuQ3gRrYkOiNn5FdXUk8K?=
 =?iso-8859-1?Q?AuxkKyFA0gbECkhsdz6wOu1OvKkZMirG5CbHALKQ2U0OCf46Bk+5jNhm1i?=
 =?iso-8859-1?Q?z0ZdrM8LKU4jIW6fogNcP4Ap30iXo/uu44NSXLRCp82xhKnjdrC3ox4gmo?=
 =?iso-8859-1?Q?Iafx7mgtdp2oF74ZfuFAPIGJzYatxhkjNZxq+uYZh8CMdbaJU3hZbYZA0m?=
 =?iso-8859-1?Q?o4KToEKdSNleyGW4d1vLI0mr+PLenwvAKYxLgtuTbvRzI0maaOjlCd7Wkv?=
 =?iso-8859-1?Q?UVDR7mdRqOHXM5RSsuc67AgtsvjVeXrjaqim/YUqKCT+E4MLc+CxfNCLcg?=
 =?iso-8859-1?Q?4W7mpoz6+JrIZtTsCzYEUINUjD69zbl9pQIsfUSSE04v0TVsl0OoREwRsQ?=
 =?iso-8859-1?Q?750qB7HcEIKVrzS9YJ2j9MxUSbkb+a9oMvzHHRZ6qT3tldNWhDkLW4Wqlf?=
 =?iso-8859-1?Q?z5+Is6K7dUspvqeKIj9dQej7Rl/HYQRpo0DMsNbXRPDVdz/aT4DrkGlUD6?=
 =?iso-8859-1?Q?EkHIRqszlnm+MH7kE0fTKXUH5eBIRgwIeNRLltuInvOskL1hblyE+hkmd+?=
 =?iso-8859-1?Q?BrPJuTePcOFKbUffj+Wq4S/FVBS8W10eGtG2RHlebVrrDqiJMsOqNvU0Ht?=
 =?iso-8859-1?Q?/oA+hjP+KsqIYN154edfQFRi6/fY/1nFNQJ0sb0KOa5A=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?cBYM1+s0YQTruxY0PCfFB+3Q5IsBpMJWuQQCAAHl53xcRjTWw1gillCTk+?=
 =?iso-8859-1?Q?6VylRf2KrcfGJo1EtoTCQQJb3up6kQ1NuF3E837BSRrUy8UxZCaluyhvWd?=
 =?iso-8859-1?Q?+VHRGnWyovC375cBDJhuNKsD+TCVPxz7Pf95JhdMpveIkbENXVcPESrxnW?=
 =?iso-8859-1?Q?UdIvDIvwUMMN8lk2hQx3CnTGiR5+BLsevgFV53Y65ZtR7Klc+mlaV+nIoN?=
 =?iso-8859-1?Q?UrE593a9X5tCdIw1nsvxc5+OhFDJYLHf6LiHPoe0Hn7STR4ZTeuymCFaZ/?=
 =?iso-8859-1?Q?bVEvIzoDrQmqWFP8DeZV5Jv9Rvcak6G7JaXJKyFN0TPRMlQ5my2QRiVyNK?=
 =?iso-8859-1?Q?0VnplVU/ptu1U6NiMztLNjk19/v4xGn7lpJiVpxU8MMyOixoubIffFg/FJ?=
 =?iso-8859-1?Q?zeBJNVm8TcWW0ye6KHNM9PUIolIHLXWVvYiXKR1dOSAOw7De4ohc3QGIoo?=
 =?iso-8859-1?Q?d0fGgGQtKjApyJphJHXFLJ1NjEOgUx2JK0wRVhlv42jPtLfjP4m4YOTC7f?=
 =?iso-8859-1?Q?tfkDU/Tfb/D8fybfThk6voNW7w5JJGqNM34Kpl4npr/u0UK5PYb98v1unx?=
 =?iso-8859-1?Q?3JFGAcoPA8Vow56rAW0dYGQPFW9acOfE74TyNfgJ6Efqph/uXlOiFiE1aP?=
 =?iso-8859-1?Q?lNfnlX8pAX/1eI76AZcBk9J3BPJbNCM+PVvaPDSgdgePRy3hzxOwVfs1Zn?=
 =?iso-8859-1?Q?Px8XK9zJ7n4TURJQmpFWSepcsqWnsC5YWJTXWhpn1m9UxVk1p3WFVlg1kR?=
 =?iso-8859-1?Q?v5WhcFs93A3AZi1RV30dzgSMdFH5VmdO04sGup+htPn3Wd/HtGf8W10WW8?=
 =?iso-8859-1?Q?nrIdLfrE22369cPgyXLVfVV4PIXRnzfHhx2ZOK+g/0S2203mw7zBthOnoq?=
 =?iso-8859-1?Q?uffxAKTtL859oZ0Gu8j2aKzHn6EIsWONQLIUaU82oD8e5B64Ew723j14Ys?=
 =?iso-8859-1?Q?2xIBukSGfHhxAqqh1lf4XkmJkfVd0sw2IfX1cyqRd7l8p2b/UPPDKQlJ+Z?=
 =?iso-8859-1?Q?xrnFbV4/9EIzd/8iBntXsJrWSE6UDdArKvowghAVYQoPMX2ISxjw5BgWLf?=
 =?iso-8859-1?Q?2L9gjYFlUvgqZN/KBQvfZfKMOEFOCdWY6itzq1tFr42eVf/13MLWUmHdAR?=
 =?iso-8859-1?Q?WFIkbygX7WR5f0f/LJhBLUy/Rbg5T1TZOjs9l3BrDjFymHZ0elDcOaDhZE?=
 =?iso-8859-1?Q?307AabwRflf0fdGkCsA+cvEcW4ePLEG4kVHumc8gmQadNxfQwiXfViSX0a?=
 =?iso-8859-1?Q?iDRhd2SwZ3x/Z/8DAKOtfnyuZ04joaj7+8sOVrRGXdELhwxJ3D9sJ0jU5z?=
 =?iso-8859-1?Q?hVQDlw3lmHiwIppyk5DMXHuMdAPtj4jaNM+wMgBOdKR4F++K+iDHHpnRzN?=
 =?iso-8859-1?Q?P6BtAsW2CfLy/o920U5Rh1yfmgIvdh0vRL0GZG5CiEPkCMVtZSowdKeKGa?=
 =?iso-8859-1?Q?QkL1Y7DHDDKxqelc17O2rbD6iLhus5xiCTi+tuZar0l3fOEfggXd2wemUU?=
 =?iso-8859-1?Q?omDCxeA9ZQzbCOJ/yb+W5QhcrrzrGCiAIcC6c8yMNW4CHIT7xp1n2dK2Nb?=
 =?iso-8859-1?Q?N/cSK1+DuauJqu00kmBEJ6BsdHqY/U6vh0ddbVzqz2PFVHnM5Jme2AHvmv?=
 =?iso-8859-1?Q?oJB8WZ1WBkJl39VAbVxtpBgRPyDioOq7jlfFKT9Dwp1z8wMBeclwwwow?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da926439-4967-49f1-9378-08de3d2cf51b
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 05:27:23.6542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wr1mfWNopD333+F3aAGUc2oTRs4oDBlryKSCa8IdU62eWklVz7Jmea2iOeHcbA+kQxMKruvpeCAIDwdLmMPbig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6949
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CF0CD4000D
X-Stat-Signature: i9iftw8ypmq9y7eipn6akh1imkxcynuq
X-HE-Tag: 1765949249-720282
X-HE-Meta: U2FsdGVkX18ZzeinrK3fT89ARo5QzuX5LTah71kmAcTHUP/5dk6iNiJhxQ/AQeNid6HN1u6ivyW9j41tkG0wQpcJ8d0ORBNA9FpaqdkpLkNnx5LLU8wmiPILa7XcEfRL4qY8oueQNyESTcnVBlWF04xfo6jBWKJzETYxFdpxURSJAZw4hozMcerRIbG7jh/SZbYz16MpdYXXe923VYskIFDtvOl916ZGehQOPaBj2cJBbNeUfSvwHbYhkdWRHk7nFlE9HlxbtXON7CtPDEn68SOn3NdkdyRoeK5ryFsF0uPpW4clMFWVfVs9eXAJpxjVAfsKjobqYSkYZKvmtDH7mCJ1kzic0mtQ6Qqg7eJMhkFlR/SSQzRsqoqy7lFxJYdYThL4cZXL8RsKgzZD0llOxqcLODzv1EnJLcwPNM2IAORfa1Y7eeVF2XdQ36/F0TswaZxhvPSZt8RVUowXz0hpr8GcLO8yZgnF465OJDUsWIVki3gOxp8rdXUW4BGroe85Hc16krsuhQkKcmoFiKjd36y27S1mMqPl3lr+q9dlhzxY7pEgeW3EvxHL2V9LKwV4XYcOBTFcmANaPeUE0bq1f9Nz2mf2YhrgQ8hjS/icCDK+F6bZM8+c6r/HgqR++sqs33lTBdh9/gpGXYNus3/22BOx+4tGcL2LFeuOn6m5LE/M9/8pEzAuqpOKks0Paz8+xILJzfFmsliKgkszADwjlmosURrCOmTvotcU9Gil/zvAthYxvXr7boCSJpSYtc32cv6I2UMLmt2PH8CcT6R4+PaVlO+KEO+HreyPJuHczKT8xZx1sKRGfodk74bqF763R5dhVwlnQVBldhZKOGAhYPJhP5hVmvOfoH8Iaw7W/httpA1iNC6JmM0bV+G1HhnQxFCUQJywvp8c1rpil/kYmEtbXdwpmxvJU37E0DUjgpqJRJEOeRWRKAGELSX34rQGAOQvBiPRKjwAEpC90vt
 lOnhL7Pq
 UkBVvT+LVHLGPctIZMRSrWgci2U9NKr68A8bidMdUv/pASDW5sqVnF02EldKJFc+EKdq8RnQP+IhnjtrBs1sMZ48xjv8qZQUJgh8oE1dnl/Pe5yD/RzJP3CPZGUHfGgdtZFAKvpGkm6e738eRStHXi87/piwDEO5RO8lumVbNBf/7zt/6D1D6CWU5wcbvkeSpDbRji923RsygqJfuBpMLKsuqikuTNIpA/a6KEtMkEmgFQJ8TqDTLR2W/jYIGvlLSChgrvbCOJXJXUmMp2dBED3LW0PrHDs6InLYJYwVK5hL1jDVZPVlYxSmwKA4Ljf5Te8lBX1AMlG//YgwIo5Tsm3KTEIIg6pAb8S0JRVk/xfGRx58sEVi7GQYD4JeyJTOLklLORUKvpErOL08gWE7t+FrYpzr8JZ7LIyuVOuVdgppCj5vB9de7ECVLB9QyGF39Cxw9iUgEeX9SDPCxNdsF1QJeoUPAmSGegHqz4yMDlJIEQioFPjcPxuHp65oDY+8uxRluICOfnbYwpjRLeZy8inwdq5r2o9RT4r3hT3U9V8bTZm1X5mLFA84wypAhEIeqi+oDe7dddPW884P2df4UmwMI2z5Su/bdIueYOZVJ6OM/34XnVNeDcuYjgFX7eJx88H/2VmduTd/ur9nique/yutPUUgK9kgjR8dKWVCT8xT+KgLsDbLJj9PoL7YyaXgs3qiHlHWil4XqYps=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hi, Uladzislau Rezki,

On Mon, Dec 15, 2025 at 01:19:14PM +0100, Uladzislau Rezki wrote:
> On Fri, Dec 12, 2025 at 11:27:27AM +0800, kernel test robot wrote:
> > 
> > 
> > Hello,
> > 
> > kernel test robot noticed a 21.3% regression of stress-ng.bigheap.realloc_calls_per_sec on:
> > 
> > 
> > commit: 9c47753167a6a585d0305663c6912f042e131c2d ("mm/vmalloc: defer freeing partly initialized vm_struct")
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > 
> > [still regression on linus/master      c9b47175e9131118e6f221cc8fb81397d62e7c91]
> > [still regression on linux-next/master 008d3547aae5bc86fac3eda317489169c3fda112]
> > 
> > testcase: stress-ng
> > config: x86_64-rhel-9.4
> > compiler: gcc-14
> > test machine: 256 threads 2 sockets Intel(R) Xeon(R) 6767P  CPU @ 2.4GHz (Granite Rapids) with 256G memory
> > parameters:
> > 
> > 	nr_threads: 100%
> > 	testtime: 60s
> > 	test: bigheap
> > 	cpufreq_governor: performance
> > 
> > 
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > | Closes: https://lore.kernel.org/oe-lkp/202512121138.986f6a6b-lkp@intel.com
> > 
> > 

[...]

> > 
> Could you please test below patch and confirm if it solves regression:

we directly apply the patch upon 9c47753167, so our test branch looks like below

* f7991e8a0136cb <---- below patch from you
* 9c47753167a6a5 mm/vmalloc: defer freeing partly initialized vm_struct
* 86e968d8ca6dc8 mm/vmalloc: support non-blocking GFP flags in alloc_vmap_area()

but found it has little performance impacts

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-gnr-2sp3/bigheap/stress-ng/60s

86e968d8ca6dc823 9c47753167a6a585d0305663c69 f7991e8a0136cb0fdf35f11e28a
---------------- --------------------------- ---------------------------
         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \
  48320196           -10.9%   43072080           -10.8%   43116499        stress-ng.bigheap.ops
    785159            -9.8%     708390            -9.7%     708644        stress-ng.bigheap.ops_per_sec
    879805           -21.3%     692805           -20.7%     697312        stress-ng.bigheap.realloc_calls_per_sec

the full comparison is as below [1]

if this patch depends on other patches, i.e. need another base to apply, please
let us know. thanks

> 
> <snip>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index ecbac900c35f..118de1a8348c 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3746,6 +3746,15 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  	return nr_allocated;
>  }
>  
> +static void
> +__vm_area_cleanup(struct vm_struct *area)
> +{
> +	if (area->pages)
> +		vfree(area->addr);
> +	else
> +		free_vm_area(area);
> +}
> +
>  static LLIST_HEAD(pending_vm_area_cleanup);
>  static void cleanup_vm_area_work(struct work_struct *work)
>  {
> @@ -3756,12 +3765,8 @@ static void cleanup_vm_area_work(struct work_struct *work)
>  	if (!head)
>  		return;
>  
> -	llist_for_each_entry_safe(area, tmp, head, llnode) {
> -		if (!area->pages)
> -			free_vm_area(area);
> -		else
> -			vfree(area->addr);
> -	}
> +	llist_for_each_entry_safe(area, tmp, head, llnode)
> +		__vm_area_cleanup(area);
>  }
>  
>  /*
> @@ -3769,8 +3774,11 @@ static void cleanup_vm_area_work(struct work_struct *work)
>   * of partially initialized vm_struct in error paths.
>   */
>  static DECLARE_WORK(cleanup_vm_area, cleanup_vm_area_work);
> -static void defer_vm_area_cleanup(struct vm_struct *area)
> +static void vm_area_cleanup(struct vm_struct *area, bool can_block)
>  {
> +	if (can_block)
> +		return __vm_area_cleanup(area);
> +
>  	if (llist_add(&area->llnode, &pending_vm_area_cleanup))
>  		schedule_work(&cleanup_vm_area);
>  }
> @@ -3915,7 +3923,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  	return area->addr;
>  
>  fail:
> -	defer_vm_area_cleanup(area);
> +	vm_area_cleanup(area, gfpflags_allow_blocking(gfp_mask));
>  	return NULL;
>  }
> <snip>
> 
> 
> --
> Uladzislau Rezki


[1]
=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-gnr-2sp3/bigheap/stress-ng/60s

86e968d8ca6dc823 9c47753167a6a585d0305663c69 f7991e8a0136cb0fdf35f11e28a
---------------- --------------------------- ---------------------------
         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \
     33.90            -3.6%      32.67            -3.4%      32.73        turbostat.RAMWatt
      3165            -2.0%       3101            +4.2%       3297        vmstat.system.cs
    336633 ± 17%      -7.8%     310279 ± 29%     -59.1%     137568 ± 48%  sched_debug.cpu.avg_idle.min
   1278595 ±  7%     -10.4%    1145748 ±  2%      -5.5%    1208901 ±  8%  sched_debug.cpu.max_idle_balance_cost.max
 3.885e+08           -10.9%  3.463e+08           -10.8%  3.465e+08        numa-numastat.node0.local_node
 3.886e+08           -10.8%  3.466e+08           -10.8%  3.467e+08        numa-numastat.node0.numa_hit
 3.881e+08           -10.9%   3.46e+08           -10.7%  3.468e+08        numa-numastat.node1.local_node
 3.883e+08           -10.9%  3.461e+08           -10.7%  3.469e+08        numa-numastat.node1.numa_hit
     72314 ± 23%     +15.6%      83599 ± 34%     +40.1%     101308 ± 14%  numa-meminfo.node0.KReclaimable
    209109 ±  5%     -14.1%     179718 ±  6%     -11.8%     184353 ±  5%  numa-meminfo.node0.PageTables
     72314 ± 23%     +15.6%      83599 ± 34%     +40.1%     101308 ± 14%  numa-meminfo.node0.SReclaimable
    100786 ± 14%      -9.0%      91704 ± 31%     -26.8%      73823 ± 20%  numa-meminfo.node1.KReclaimable
    100786 ± 14%      -9.0%      91704 ± 31%     -26.8%      73823 ± 20%  numa-meminfo.node1.SReclaimable
     18075 ± 23%     +15.6%      20900 ± 34%     +40.1%      25327 ± 14%  numa-vmstat.node0.nr_slab_reclaimable
 3.886e+08           -10.8%  3.466e+08           -10.8%  3.467e+08        numa-vmstat.node0.numa_hit
 3.885e+08           -10.9%  3.463e+08           -10.8%  3.465e+08        numa-vmstat.node0.numa_local
     25179 ± 14%      -9.0%      22913 ± 31%     -26.7%      18451 ± 20%  numa-vmstat.node1.nr_slab_reclaimable
 3.883e+08           -10.9%  3.461e+08           -10.7%  3.469e+08        numa-vmstat.node1.numa_hit
 3.881e+08           -10.9%   3.46e+08           -10.7%  3.468e+08        numa-vmstat.node1.numa_local
  48320196           -10.9%   43072080           -10.8%   43116499        stress-ng.bigheap.ops
    785159            -9.8%     708390            -9.7%     708644        stress-ng.bigheap.ops_per_sec
    879805           -21.3%     692805           -20.7%     697312        stress-ng.bigheap.realloc_calls_per_sec
     72414            -3.3%      70043            -2.7%      70486 ±  2%  stress-ng.time.involuntary_context_switches
 7.735e+08           -10.9%  6.895e+08           -10.8%  6.902e+08        stress-ng.time.minor_page_faults
     15385            -1.0%      15224            -1.0%      15233        stress-ng.time.system_time
    236.00           -10.5%     211.19 ±  2%     -10.5%     211.25 ±  2%  stress-ng.time.user_time
     61.74            -1.0%      61.14            -0.9%      61.16        time.elapsed_time
     61.74            -1.0%      61.14            -0.9%      61.16        time.elapsed_time.max
     72414            -3.3%      70043            -2.7%      70486 ±  2%  time.involuntary_context_switches
 7.735e+08           -10.9%  6.895e+08           -10.8%  6.902e+08        time.minor_page_faults
     15385            -1.0%      15224            -1.0%      15233        time.system_time
    236.00           -10.5%     211.19 ±  2%     -10.5%     211.25 ±  2%  time.user_time
      2033 ±  3%     -18.3%       1662 ±  5%     -16.1%       1705 ±  8%  time.voluntary_context_switches
      0.32 ±  4%     +95.1%       0.63 ± 12%    +111.1%       0.68 ± 31%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     16.96 ± 41%   +5031.1%     870.26 ± 40%   +4560.8%     790.50 ± 51%  perf-sched.sch_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.32 ±  4%     +95.1%       0.63 ± 12%    +111.1%       0.68 ± 31%  perf-sched.total_sch_delay.average.ms
     16.96 ± 41%   +5031.1%     870.26 ± 40%   +4560.8%     790.50 ± 51%  perf-sched.total_sch_delay.max.ms
      4750 ±  4%     -12.2%       4169 ±  4%     -10.2%       4267 ±  8%  perf-sched.total_wait_and_delay.max.ms
      4750 ±  4%     -12.2%       4169 ±  4%     -10.2%       4266 ±  8%  perf-sched.total_wait_time.max.ms
      4750 ±  4%     -12.2%       4169 ±  4%     -10.2%       4267 ±  8%  perf-sched.wait_and_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      4750 ±  4%     -12.2%       4169 ±  4%     -10.2%       4266 ±  8%  perf-sched.wait_time.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
  29568942            -2.9%   28712561            -3.3%   28599966 ±  2%  proc-vmstat.nr_active_anon
  28797015            -2.8%   27991137            -3.2%   27872472 ±  2%  proc-vmstat.nr_anon_pages
     99294            -3.7%      95669            -3.5%      95835        proc-vmstat.nr_page_table_pages
  29568950            -2.9%   28712562            -3.3%   28599954 ±  2%  proc-vmstat.nr_zone_active_anon
  7.77e+08           -10.9%  6.927e+08           -10.7%  6.936e+08        proc-vmstat.numa_hit
 7.766e+08           -10.9%  6.923e+08           -10.7%  6.933e+08        proc-vmstat.numa_local
 7.785e+08           -10.8%  6.941e+08           -10.8%  6.948e+08        proc-vmstat.pgalloc_normal
 7.739e+08           -10.8%  6.899e+08           -10.8%  6.906e+08        proc-vmstat.pgfault
 7.756e+08           -10.6%  6.931e+08           -10.6%  6.931e+08        proc-vmstat.pgfree
      7.68            -3.8%       7.39            -3.1%       7.44        perf-stat.i.MPKI
 2.811e+10            -4.9%  2.672e+10            -4.7%  2.678e+10        perf-stat.i.branch-instructions
      0.06            -0.0        0.05            -0.0        0.05        perf-stat.i.branch-miss-rate%
  15424402           -14.3%   13220241           -14.9%   13127907 ±  2%  perf-stat.i.branch-misses
     80.75            -2.3       78.42            -1.9       78.86        perf-stat.i.cache-miss-rate%
 1.037e+09           -11.0%  9.233e+08           -10.3%  9.306e+08        perf-stat.i.cache-misses
 1.217e+09           -10.6%  1.088e+09           -10.1%  1.094e+09        perf-stat.i.cache-references
      2817 ±  2%      -2.8%       2739            +3.4%       2914        perf-stat.i.context-switches
      7.16            +5.1%       7.53            +5.0%       7.52        perf-stat.i.cpi
      1846 ±  5%     +30.6%       2410 ±  5%     +30.1%       2402 ±  4%  perf-stat.i.cycles-between-cache-misses
 1.298e+11            -5.9%  1.222e+11            -5.6%  1.225e+11        perf-stat.i.instructions
      0.14            -5.2%       0.13            -5.1%       0.13        perf-stat.i.ipc
    103.98            -9.7%      93.94            -9.1%      94.48        perf-stat.i.metric.K/sec
  13534286           -11.0%   12040965           -10.3%   12135552        perf-stat.i.minor-faults
  13534286           -11.0%   12040965           -10.3%   12135553        perf-stat.i.page-faults
      7.64            -5.3%       7.23            -5.1%       7.25        perf-stat.overall.MPKI
      0.05            -0.0        0.05            -0.0        0.05        perf-stat.overall.branch-miss-rate%
      7.20            +5.3%       7.58            +5.3%       7.58        perf-stat.overall.cpi
    942.28           +11.2%       1047           +10.9%       1044        perf-stat.overall.cycles-between-cache-misses
      0.14            -5.0%       0.13            -5.0%       0.13        perf-stat.overall.ipc
 2.678e+10            -4.1%  2.569e+10            -4.1%  2.569e+10        perf-stat.ps.branch-instructions
  14559650           -13.3%   12627015           -13.9%   12531491        perf-stat.ps.branch-misses
 9.434e+08           -10.0%  8.491e+08            -9.8%  8.514e+08        perf-stat.ps.cache-misses
 1.112e+09            -9.5%  1.006e+09            -9.4%  1.007e+09        perf-stat.ps.cache-references
      2663            -1.3%       2629            +4.1%       2772        perf-stat.ps.context-switches
 1.235e+11            -4.9%  1.174e+11            -4.9%  1.174e+11        perf-stat.ps.instructions
  12270397           -10.0%   11048367            -9.8%   11072654        perf-stat.ps.minor-faults
  12270398           -10.0%   11048367            -9.8%   11072655        perf-stat.ps.page-faults
 7.755e+12            -5.9%    7.3e+12            -6.0%  7.287e+12        perf-stat.total.instructions
     42.85            -5.2       37.62            -5.8       37.03 ±  2%  perf-profile.calltrace.cycles-pp.__munmap
     42.85            -5.2       37.62            -5.8       37.03 ±  2%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     42.85            -5.2       37.62            -5.8       37.03 ±  2%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
     42.85            -5.2       37.62            -5.8       37.03 ±  2%  perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     42.85            -5.2       37.62            -5.8       37.03 ±  2%  perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     42.85            -5.2       37.62            -5.8       37.03 ±  2%  perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
     42.85            -5.2       37.62            -5.8       37.03 ±  2%  perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
     42.85            -5.2       37.62            -5.8       37.03 ±  2%  perf-profile.calltrace.cycles-pp.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
     42.85            -5.2       37.62            -5.8       37.03 ±  2%  perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
     41.78 ±  2%      -5.1       36.70            -5.4       36.41 ±  3%  perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
     41.78 ±  2%      -5.1       36.70            -5.4       36.41 ±  3%  perf-profile.calltrace.cycles-pp.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
     41.78 ±  2%      -5.1       36.70            -5.4       36.41 ±  3%  perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas
     41.78 ±  2%      -5.1       36.70            -5.4       36.41 ±  3%  perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes
     41.51 ±  2%      -5.1       36.45            -5.3       36.17 ±  3%  perf-profile.calltrace.cycles-pp.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range.zap_pmd_range
     41.51 ±  2%      -5.1       36.45            -5.3       36.18 ±  3%  perf-profile.calltrace.cycles-pp.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range.zap_pmd_range.unmap_page_range
     41.51 ±  2%      -5.1       36.45            -5.3       36.18 ±  3%  perf-profile.calltrace.cycles-pp.tlb_flush_mmu.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas
     41.65            -5.1       36.60            -5.7       35.97 ±  3%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs.free_pages_and_swap_cache
     41.63            -5.1       36.58            -5.7       35.95 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs
     41.65            -5.1       36.60            -5.7       35.97 ±  2%  perf-profile.calltrace.cycles-pp.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages
     41.46 ±  2%      -5.0       36.41            -5.3       36.13 ±  3%  perf-profile.calltrace.cycles-pp.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range
     40.84 ±  2%      -4.9       35.90            -5.2       35.62 ±  3%  perf-profile.calltrace.cycles-pp.__page_cache_release.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_flush_mmu
      3.89 ±  4%      -2.4        1.53 ±  8%      -2.4        1.44 ±  7%  perf-profile.calltrace.cycles-pp.si_meminfo.do_sysinfo.__do_sys_sysinfo.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.84 ±  4%      -2.4        1.49 ±  8%      -2.4        1.40 ±  8%  perf-profile.calltrace.cycles-pp.nr_blockdev_pages.si_meminfo.do_sysinfo.__do_sys_sysinfo.do_syscall_64
      3.82 ±  4%      -2.3        1.47 ±  9%      -2.4        1.39 ±  8%  perf-profile.calltrace.cycles-pp._raw_spin_lock.nr_blockdev_pages.si_meminfo.do_sysinfo.__do_sys_sysinfo
      3.74 ±  4%      -2.3        1.43 ±  9%      -2.4        1.34 ±  8%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.nr_blockdev_pages.si_meminfo.do_sysinfo
      3.10 ±  2%      -0.6        2.45 ±  2%      -0.6        2.49 ±  2%  perf-profile.calltrace.cycles-pp.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      1.90            -0.4        1.52            -0.4        1.54        perf-profile.calltrace.cycles-pp.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      1.84            -0.4        1.48            -0.4        1.49        perf-profile.calltrace.cycles-pp.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page.__handle_mm_fault
      1.80            -0.4        1.44            -0.4        1.45        perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page
      1.70            -0.4        1.36            -0.3        1.37        perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio
      1.43 ±  6%      -0.3        1.12 ±  2%      -0.3        1.12 ±  3%  perf-profile.calltrace.cycles-pp.__pte_offset_map_lock.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      1.26 ±  4%      -0.3        0.98 ±  2%      -0.3        0.98 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock.__pte_offset_map_lock.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      1.21            -0.3        0.95            -0.3        0.96        perf-profile.calltrace.cycles-pp.prep_new_page.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof
      1.16 ±  8%      -0.3        0.90 ±  5%      -0.2        0.91 ±  6%  perf-profile.calltrace.cycles-pp.__mem_cgroup_charge.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      1.17            -0.3        0.92            -0.2        0.93        perf-profile.calltrace.cycles-pp.clear_page_erms.prep_new_page.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol
     44.15 ±  2%      +7.5       51.61 ±  2%      +8.4       52.53        perf-profile.calltrace.cycles-pp.do_sysinfo.__do_sys_sysinfo.do_syscall_64.entry_SYSCALL_64_after_hwframe.sysinfo
     44.32 ±  2%      +7.5       51.79 ±  2%      +8.4       52.72        perf-profile.calltrace.cycles-pp.sysinfo
     44.30 ±  2%      +7.5       51.77 ±  2%      +8.4       52.69        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.sysinfo
     44.30 ±  2%      +7.5       51.77 ±  2%      +8.4       52.70        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.sysinfo
     44.28 ±  2%      +7.5       51.75 ±  2%      +8.4       52.68        perf-profile.calltrace.cycles-pp.__do_sys_sysinfo.do_syscall_64.entry_SYSCALL_64_after_hwframe.sysinfo
     40.25 ±  2%      +9.8       50.06 ±  2%     +10.8       51.07        perf-profile.calltrace.cycles-pp.si_swapinfo.do_sysinfo.__do_sys_sysinfo.do_syscall_64.entry_SYSCALL_64_after_hwframe
     40.24 ±  2%      +9.8       50.06 ±  2%     +10.8       51.06        perf-profile.calltrace.cycles-pp._raw_spin_lock.si_swapinfo.do_sysinfo.__do_sys_sysinfo.do_syscall_64
     40.08 ±  2%      +9.8       49.92 ±  2%     +10.8       50.92        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.si_swapinfo.do_sysinfo.__do_sys_sysinfo
     44.76 ±  2%      -6.0       38.80 ±  4%      -6.9       37.87 ±  2%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     44.44 ±  2%      -5.9       38.56 ±  4%      -6.8       37.63 ±  2%  perf-profile.children.cycles-pp.folio_lruvec_lock_irqsave
     42.85            -5.2       37.62            -5.8       37.03 ±  2%  perf-profile.children.cycles-pp.__vm_munmap
     42.85            -5.2       37.62            -5.8       37.03 ±  2%  perf-profile.children.cycles-pp.__x64_sys_munmap
     42.88            -5.2       37.65            -5.8       37.06 ±  2%  perf-profile.children.cycles-pp.do_vmi_align_munmap
     42.88            -5.2       37.65            -5.8       37.06 ±  2%  perf-profile.children.cycles-pp.vms_clear_ptes
     42.88            -5.2       37.65            -5.8       37.06 ±  2%  perf-profile.children.cycles-pp.vms_complete_munmap_vmas
     42.85            -5.2       37.62            -5.8       37.03 ±  2%  perf-profile.children.cycles-pp.__munmap
     42.86            -5.2       37.64            -5.8       37.05 ±  2%  perf-profile.children.cycles-pp.do_vmi_munmap
     42.62            -5.2       37.40            -5.8       36.82 ±  2%  perf-profile.children.cycles-pp.folios_put_refs
     42.60            -5.2       37.40            -5.8       36.81 ±  2%  perf-profile.children.cycles-pp.__tlb_batch_free_encoded_pages
     42.60            -5.2       37.40            -5.8       36.81 ±  2%  perf-profile.children.cycles-pp.free_pages_and_swap_cache
     41.93            -5.1       36.84            -5.7       36.25 ±  2%  perf-profile.children.cycles-pp.__page_cache_release
     41.80 ±  2%      -5.1       36.72            -5.4       36.43 ±  3%  perf-profile.children.cycles-pp.unmap_page_range
     41.80 ±  2%      -5.1       36.72            -5.4       36.43 ±  3%  perf-profile.children.cycles-pp.unmap_vmas
     41.80 ±  2%      -5.1       36.72            -5.4       36.43 ±  3%  perf-profile.children.cycles-pp.zap_pmd_range
     41.80 ±  2%      -5.1       36.72            -5.4       36.43 ±  3%  perf-profile.children.cycles-pp.zap_pte_range
     41.51 ±  2%      -5.1       36.45            -5.3       36.18 ±  3%  perf-profile.children.cycles-pp.tlb_flush_mmu
      3.89 ±  4%      -2.4        1.53 ±  8%      -2.4        1.44 ±  7%  perf-profile.children.cycles-pp.si_meminfo
      3.84 ±  4%      -2.4        1.49 ±  8%      -2.4        1.40 ±  8%  perf-profile.children.cycles-pp.nr_blockdev_pages
      3.11 ±  2%      -0.6        2.46 ±  2%      -0.6        2.50 ±  2%  perf-profile.children.cycles-pp.alloc_anon_folio
      1.90            -0.4        1.52            -0.4        1.54        perf-profile.children.cycles-pp.vma_alloc_folio_noprof
      1.89            -0.4        1.52            -0.4        1.54        perf-profile.children.cycles-pp.alloc_pages_mpol
      1.84            -0.4        1.48            -0.3        1.50        perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      1.73            -0.3        1.39            -0.3        1.40        perf-profile.children.cycles-pp.get_page_from_freelist
      0.56 ± 72%      -0.3        0.22 ±108%      -0.3        0.28 ± 99%  perf-profile.children.cycles-pp.get_mem_cgroup_from_mm
      1.45 ±  6%      -0.3        1.14 ±  3%      -0.3        1.14 ±  3%  perf-profile.children.cycles-pp.__pte_offset_map_lock
      1.22            -0.3        0.96            -0.3        0.97        perf-profile.children.cycles-pp.prep_new_page
      1.16 ±  7%      -0.3        0.90 ±  5%      -0.2        0.92 ±  6%  perf-profile.children.cycles-pp.__mem_cgroup_charge
      1.19            -0.3        0.93            -0.2        0.94        perf-profile.children.cycles-pp.clear_page_erms
      0.26 ±  8%      -0.1        0.16 ±  3%      -0.1        0.16 ±  5%  perf-profile.children.cycles-pp.handle_internal_command
      0.26 ±  8%      -0.1        0.16 ±  3%      -0.1        0.16 ±  5%  perf-profile.children.cycles-pp.main
      0.26 ±  8%      -0.1        0.16 ±  3%      -0.1        0.16 ±  5%  perf-profile.children.cycles-pp.run_builtin
      0.44 ± 10%      -0.1        0.35 ±  6%      -0.1        0.35 ±  6%  perf-profile.children.cycles-pp.free_unref_folios
      0.25 ±  9%      -0.1        0.16 ±  3%      -0.1        0.16 ±  6%  perf-profile.children.cycles-pp.record__mmap_read_evlist
      0.40 ± 11%      -0.1        0.31 ±  6%      -0.1        0.32 ±  6%  perf-profile.children.cycles-pp.free_frozen_page_commit
      0.24 ±  8%      -0.1        0.16 ±  4%      -0.1        0.16 ±  5%  perf-profile.children.cycles-pp.perf_mmap__push
      0.38 ± 13%      -0.1        0.30 ±  7%      -0.1        0.30 ±  7%  perf-profile.children.cycles-pp.free_pcppages_bulk
      0.55            -0.1        0.48            -0.1        0.48        perf-profile.children.cycles-pp.sync_regs
      0.48 ±  4%      -0.1        0.42 ±  2%      -0.1        0.41 ±  4%  perf-profile.children.cycles-pp.native_irq_return_iret
      0.37 ±  4%      -0.1        0.31 ±  3%      -0.0        0.32 ±  5%  perf-profile.children.cycles-pp.rmqueue
      0.35 ±  4%      -0.1        0.30 ±  3%      -0.0        0.30 ±  5%  perf-profile.children.cycles-pp.rmqueue_pcplist
      0.19 ±  6%      -0.0        0.14 ±  3%      -0.1        0.13 ±  4%  perf-profile.children.cycles-pp.record__pushfn
      0.18 ±  7%      -0.0        0.13 ±  2%      -0.0        0.13 ±  5%  perf-profile.children.cycles-pp.ksys_write
      0.17 ±  5%      -0.0        0.13 ±  3%      -0.0        0.12 ±  5%  perf-profile.children.cycles-pp.vfs_write
      0.31            -0.0        0.27            -0.0        0.27        perf-profile.children.cycles-pp.lru_add
      0.28 ±  5%      -0.0        0.24 ±  3%      -0.0        0.25 ±  6%  perf-profile.children.cycles-pp.__rmqueue_pcplist
      0.16 ±  5%      -0.0        0.12 ±  3%      -0.0        0.12 ±  5%  perf-profile.children.cycles-pp.shmem_file_write_iter
      0.24 ±  6%      -0.0        0.20 ±  5%      -0.0        0.21 ±  7%  perf-profile.children.cycles-pp.rmqueue_bulk
      0.16 ±  4%      -0.0        0.12 ±  3%      -0.0        0.12 ±  5%  perf-profile.children.cycles-pp.generic_perform_write
      0.24 ±  2%      -0.0        0.20            -0.0        0.20 ±  2%  perf-profile.children.cycles-pp.lru_gen_add_folio
      0.21            -0.0        0.18            -0.0        0.18 ±  3%  perf-profile.children.cycles-pp.lru_gen_del_folio
      0.25 ±  2%      -0.0        0.22            -0.0        0.22 ±  3%  perf-profile.children.cycles-pp.zap_present_ptes
      0.14 ±  2%      -0.0        0.12 ±  3%      -0.0        0.12 ±  4%  perf-profile.children.cycles-pp.lock_vma_under_rcu
      0.14 ±  3%      -0.0        0.12 ±  4%      -0.0        0.12 ±  3%  perf-profile.children.cycles-pp.__mod_node_page_state
      0.13            -0.0        0.12 ±  4%      -0.0        0.12        perf-profile.children.cycles-pp.__perf_sw_event
      0.06 ±  7%      -0.0        0.05            -0.0        0.05        perf-profile.children.cycles-pp.___pte_offset_map
      0.09 ±  5%      -0.0        0.08            -0.0        0.08        perf-profile.children.cycles-pp.__mem_cgroup_uncharge_folios
      0.08 ±  6%      -0.0        0.06 ±  6%      -0.0        0.06        perf-profile.children.cycles-pp.vma_merge_extend
      0.11 ±  3%      -0.0        0.10            -0.0        0.10 ±  4%  perf-profile.children.cycles-pp.__free_one_page
      0.07            -0.0        0.06            -0.0        0.06        perf-profile.children.cycles-pp.error_entry
      0.06            -0.0        0.05            -0.0        0.05 ±  6%  perf-profile.children.cycles-pp.__mod_zone_page_state
      0.11            -0.0        0.10            -0.0        0.10        perf-profile.children.cycles-pp.___perf_sw_event
      0.10 ±  4%      +0.0        0.11 ±  4%      +0.0        0.11 ±  5%  perf-profile.children.cycles-pp.sched_tick
      0.21 ±  3%      +0.0        0.24 ±  5%      +0.0        0.23 ±  6%  perf-profile.children.cycles-pp.update_process_times
      0.22 ±  3%      +0.0        0.26 ±  7%      +0.0        0.24 ±  7%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.30 ±  4%      +0.0        0.34 ±  6%      +0.0        0.33 ±  3%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.29 ±  4%      +0.0        0.33 ±  6%      +0.0        0.32 ±  3%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.39 ±  2%      +0.0        0.43 ±  2%      +0.0        0.43        perf-profile.children.cycles-pp.mremap
      0.31 ±  4%      +0.0        0.36 ±  5%      +0.0        0.34 ±  3%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.34 ±  3%      +0.0        0.39 ±  5%      +0.0        0.38 ±  3%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.28 ±  3%      +0.1        0.34 ±  2%      +0.1        0.34        perf-profile.children.cycles-pp.__do_sys_mremap
      0.28 ±  2%      +0.1        0.34 ±  3%      +0.1        0.34        perf-profile.children.cycles-pp.do_mremap
      0.11 ±  4%      +0.1        0.17 ±  2%      +0.1        0.16 ±  3%  perf-profile.children.cycles-pp.expand_vma
      0.00            +0.1        0.08            +0.1        0.08        perf-profile.children.cycles-pp.__vm_enough_memory
      0.00            +0.1        0.09 ±  5%      +0.1        0.09 ±  3%  perf-profile.children.cycles-pp.vrm_calc_charge
      0.04 ±141%      +0.1        0.13 ± 16%      +0.1        0.11 ± 30%  perf-profile.children.cycles-pp.add_callchain_ip
      0.04 ±142%      +0.1        0.14 ± 17%      +0.1        0.11 ± 29%  perf-profile.children.cycles-pp.thread__resolve_callchain_sample
      0.04 ±142%      +0.1        0.17 ± 15%      +0.1        0.15 ± 30%  perf-profile.children.cycles-pp.__thread__resolve_callchain
      0.04 ±142%      +0.1        0.18 ± 15%      +0.1        0.15 ± 29%  perf-profile.children.cycles-pp.sample__for_each_callchain_node
      0.05 ±141%      +0.1        0.18 ± 14%      +0.1        0.15 ± 30%  perf-profile.children.cycles-pp.build_id__mark_dso_hit
      0.05 ±141%      +0.1        0.19 ± 14%      +0.1        0.16 ± 28%  perf-profile.children.cycles-pp.perf_session__deliver_event
      0.05 ±141%      +0.1        0.20 ± 14%      +0.1        0.17 ± 28%  perf-profile.children.cycles-pp.__ordered_events__flush
      0.05 ±141%      +0.1        0.20 ± 33%      +0.1        0.18 ± 35%  perf-profile.children.cycles-pp.perf_session__process_events
      0.05 ±141%      +0.1        0.20 ± 33%      +0.1        0.18 ± 35%  perf-profile.children.cycles-pp.record__finish_output
     88.59            +1.5       90.13            +1.5       90.13        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     45.34 ±  2%      +7.2       52.54 ±  2%      +8.1       53.46        perf-profile.children.cycles-pp._raw_spin_lock
     44.15 ±  2%      +7.5       51.61 ±  2%      +8.4       52.53        perf-profile.children.cycles-pp.do_sysinfo
     44.33 ±  2%      +7.5       51.80 ±  2%      +8.4       52.72        perf-profile.children.cycles-pp.sysinfo
     44.28 ±  2%      +7.5       51.75 ±  2%      +8.4       52.68        perf-profile.children.cycles-pp.__do_sys_sysinfo
     40.25 ±  2%      +9.8       50.07 ±  2%     +10.8       51.07        perf-profile.children.cycles-pp.si_swapinfo
      0.55 ± 74%      -0.3        0.22 ±107%      -0.3        0.28 ± 99%  perf-profile.self.cycles-pp.get_mem_cgroup_from_mm
      1.50 ±  4%      -0.3        1.17            -0.3        1.17        perf-profile.self.cycles-pp._raw_spin_lock
      1.18            -0.3        0.92            -0.2        0.93        perf-profile.self.cycles-pp.clear_page_erms
      2.01            -0.2        1.86 ±  3%      -0.1        1.88 ±  2%  perf-profile.self.cycles-pp.stress_bigheap_child
      0.55            -0.1        0.48            -0.1        0.48        perf-profile.self.cycles-pp.sync_regs
      0.48 ±  4%      -0.1        0.42 ±  2%      -0.1        0.41 ±  4%  perf-profile.self.cycles-pp.native_irq_return_iret
      0.14 ±  3%      -0.0        0.12 ±  4%      -0.0        0.11 ±  3%  perf-profile.self.cycles-pp.get_page_from_freelist
      0.14 ±  8%      -0.0        0.12 ±  3%      -0.0        0.13 ±  3%  perf-profile.self.cycles-pp.do_anonymous_page
      0.14 ±  2%      -0.0        0.12 ±  3%      -0.0        0.12 ±  3%  perf-profile.self.cycles-pp.rmqueue_bulk
      0.14            -0.0        0.12            -0.0        0.12 ±  2%  perf-profile.self.cycles-pp.lru_gen_del_folio
      0.11 ±  3%      -0.0        0.09 ±  4%      -0.0        0.10 ±  7%  perf-profile.self.cycles-pp.__handle_mm_fault
      0.15 ±  2%      -0.0        0.13            -0.0        0.13 ±  2%  perf-profile.self.cycles-pp.lru_gen_add_folio
      0.12 ±  3%      -0.0        0.10 ±  3%      -0.0        0.10        perf-profile.self.cycles-pp.zap_present_ptes
      0.12 ±  4%      -0.0        0.11            -0.0        0.11 ±  3%  perf-profile.self.cycles-pp.__mod_node_page_state
      0.07 ±  6%      -0.0        0.06            -0.0        0.06 ±  6%  perf-profile.self.cycles-pp.lock_vma_under_rcu
      0.10            -0.0        0.09 ±  4%      -0.0        0.09 ±  4%  perf-profile.self.cycles-pp.__free_one_page
      0.11 ±  3%      -0.0        0.10            -0.0        0.10 ±  3%  perf-profile.self.cycles-pp.folios_put_refs
      0.07            -0.0        0.06            -0.0        0.06        perf-profile.self.cycles-pp.___perf_sw_event
      0.07            -0.0        0.06            -0.0        0.06        perf-profile.self.cycles-pp.do_user_addr_fault
      0.07            -0.0        0.06            -0.0        0.06        perf-profile.self.cycles-pp.lru_add
      0.07            -0.0        0.06            -0.0        0.06 ±  5%  perf-profile.self.cycles-pp.mas_walk
      0.08            -0.0        0.07            -0.0        0.07        perf-profile.self.cycles-pp.__alloc_frozen_pages_noprof
      0.06            -0.0        0.05            -0.0        0.05        perf-profile.self.cycles-pp.handle_mm_fault
      0.06            -0.0        0.05            -0.0        0.05        perf-profile.self.cycles-pp.page_counter_uncharge
      0.13 ±  3%      +0.0        0.14 ±  3%      +0.0        0.14 ±  2%  perf-profile.self.cycles-pp._copy_to_user
      0.00            +0.1        0.08            +0.1        0.08        perf-profile.self.cycles-pp.__vm_enough_memory
     88.36            +1.5       89.85            +1.5       89.86        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath



