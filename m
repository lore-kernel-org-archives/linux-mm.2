Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3035FCCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:11:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 913078E011A; Tue, 14 Oct 2025 09:11:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C3E08E0112; Tue, 14 Oct 2025 09:11:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73D808E011A; Tue, 14 Oct 2025 09:11:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B91A8E0112
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:11:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1B03CC085F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:11:31 +0000 (UTC)
X-FDA: 83996756382.07.6325704
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf22.hostedemail.com (Postfix) with ESMTP id C37CAC0019
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:11:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UwSZmaz9;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf22.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760447488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ucIeTqC2MbY5O/6QjTpTpyU532cBqijbFuQ9gevZm9w=;
	b=RwriO0ImbAhEgirdBI/xFQ1lR7DJEMjwB1Yvf1enIoKd4LOqNq+foY6aNQ6WR5yylKSMee
	vC+IzcMHM4wN07PKj3jn+6WzeWyCU34Y6yosMBfpvlBSVtpjd0Ws7kY1CRouMeC0rc50Rl
	9RPZy8d5Y9drRa9I5sRMY8HBWTdrk2c=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760447488; a=rsa-sha256;
	cv=fail;
	b=cbmY3ryWADq0HqkJyS7WNJ0EjAsOJqp8i51P46PnWvaIla3rk7je0aQfN4wnKhqRFd18wP
	VW9EJrNvH3xkJ1Q6lYys5wxT7fzvQ256pb6DSRJCZ3rc/nTBGIOqncl3rHT4sjpdqo2P96
	WxePBSRV91WWw9uwBnWmUznUeVijIzg=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UwSZmaz9;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf22.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760447486; x=1791983486;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QlsAmrJ7vDYTGKzZvSAr+guQby8UOm3cM79VJ1VmCww=;
  b=UwSZmaz9weiZu3yokPkK/jP0BaW4uqUh60OoOYSMNR+UzeNDab/ErHLz
   gHAp6O6chn5uvNxmuYeuW/KW6jaTt4yZJbF7Pkwb09Jd+47qFjI+FAk4o
   Kp42grEyqb1O/MkZGrTTcfOtU0L+eOJNDub0Hh2vvhCXUwCG81Bf6IKwG
   mMJq0q/+ax7V1visTY8KVw0Xgi8l11kghDUiye/f4Y7UYRGdcMwiiqmor
   fJWJFA2Y2muACEZ+8l8clqxxdmSdN2yO4U4SQPGHCKAAUgSjsr+0pYd16
   JiRfjdMPKy74AtSifJZUmKgiFZkYD1ZVxDSxyc+tuatV1UYG8+9HbfME8
   w==;
X-CSE-ConnectionGUID: 11l1mmd2SYedgs1fobNiew==
X-CSE-MsgGUID: mrOPYiJaT3a/4ZdXtRmAog==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="65228137"
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="65228137"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 06:11:25 -0700
X-CSE-ConnectionGUID: zslZxQoxRrWST5Pbbqmq+Q==
X-CSE-MsgGUID: +UXQWOuKT3WxSp5BC6PVBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="182341103"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 06:11:25 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 06:11:25 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 06:11:25 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.9) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 06:11:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sDqtpFJ0YScTVL5/AUH0+p6H38raAgTgj2pSS8Ye6YqHxKlzn71dlqhzAvRO46NmaqaxH2AMGuMxkZ8068xaY/6EtfvgQYmIuJkJc2umi8HWiaFZF4A6ZD6buy4MtLGOnnRumoXHp+f4pkAilf8dZZvUDGZ+9CvysOxkvQedl7JVPBmmtInUPieDBPF/VSsLVBoAF+JweC/qMeqmmNEMH90b3ONNk/GntmfHTxeuE4OcQpAzeLGyhCXa/wjgjndFoSDAxQyoqQhPjcTZT9z2gbOmJz2ThuCiA7Lp2zBSFWFgfECy5554cnnKbH6BHhL1/wo3t98RZob58tLumVyA7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ucIeTqC2MbY5O/6QjTpTpyU532cBqijbFuQ9gevZm9w=;
 b=G9ux0APKES9eU+m7KWSc8C3GiSRglqfLpdE45+Q4aC6p3c7oLM4D+AvcJVHz7GTAUclBtCLecyZC2sM7YcwGPL8m8qTGBWFdMgHXx8Vn2oGHqhbCKRbmkKARHHI6Eek9MILoKBre09Z3bkoX82YZHDHI/xz2I/gzJIcTJDbXkJHZQf2I4xWmEdZuvZB4Y/jED1B2PD/4CosFLhjbdhOpNh/rMrCq2ez9ZXzYuOPuLtv6IHvmqghvkgq76oZbw6A/fo8ajeQhcLSuOWsQ3jbDceqaJObY3AOs3EHXYso6XMU2sMqIVuq6/Hva706biT/8yjoAF+3wKfseM1qxQOmJFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DS7PR11MB5965.namprd11.prod.outlook.com (2603:10b6:8:70::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Tue, 14 Oct
 2025 13:11:22 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 13:11:22 +0000
Date: Tue, 14 Oct 2025 21:11:12 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: Alexei Starovoitov <ast@kernel.org>, <oe-lkp@lists.linux.dev>,
	<lkp@intel.com>, <linux-kernel@vger.kernel.org>, Harry Yoo
	<harry.yoo@oracle.com>, <kasan-dev@googlegroups.com>,
	<cgroups@vger.kernel.org>, <linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: Re: [linus:master] [slab] af92793e52:
 BUG_kmalloc-#(Not_tainted):Freepointer_corrupt
Message-ID: <aO5L8EG3nkFeBmM7@xsang-OptiPlex-9020>
References: <202510101652.7921fdc6-lkp@intel.com>
 <692b6230-db0c-4369-85f0-539aa1c072bb@suse.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <692b6230-db0c-4369-85f0-539aa1c072bb@suse.cz>
X-ClientProxiedBy: SI2PR02CA0020.apcprd02.prod.outlook.com
 (2603:1096:4:195::7) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DS7PR11MB5965:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b9ee6f0-a16b-4505-ee3d-08de0b232bd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?WdqJQepTPCbzGLHyn2KT32h/RK0AFOgptDOZGugIhgP924GXVsamZ9bGrAIM?=
 =?us-ascii?Q?+VVLBf4+VYM5KNw3Gf9LSlXD8N5xO9L65WkvCHOWQnfGFZ4CoTTpAc4uBkNE?=
 =?us-ascii?Q?O4xsz2lSrSjJoaBz702WgyAoDmI8Dx0p7BQSWnRyf55Fr64IklzIVnLx8Pfq?=
 =?us-ascii?Q?SpZWSpFoNhliVO7u/AhBBBxwpguBbATQ5u8o8O/53DH4vTp+3erVpZ1YvXD4?=
 =?us-ascii?Q?2rLWYUG7L6zzCFKyxdW02mzTJmCYfshHpg0wRkrHHyEHO/7pjX1H+E7us+Og?=
 =?us-ascii?Q?cCg5VFPFfGRaJFN7xJwe/Kq0Wyu38SYoZG3Z/0BhmQraXOwKZDQd0Pe6KUiX?=
 =?us-ascii?Q?KO3EmRC9IkKtK1weTozTdJg85+QRUyaHf5Bg1/OfxLW6rshB/wn8K9e6Dp6v?=
 =?us-ascii?Q?z513/acu78Klfytn88rQiMLPoOCknCjnz0k0mtxAOv/b6XXqMGOAbFxfVOHD?=
 =?us-ascii?Q?DAcFS1RDudlAWUYZSnVt9/MqejAR4M35qy6J7fKFXHgnFGulyBDpbjGIwqR2?=
 =?us-ascii?Q?/bh3+6YGko9fGg5tTn+ZXlHF/EKsGl+8bQgW2VmzHs4/W2XrGDXJlmb2NdI4?=
 =?us-ascii?Q?mc7mmmDHNhDOC1YaFMlTyVEsmeQbJCjDwf13XwU+bNRIbBHiQKma2W0b6Wr4?=
 =?us-ascii?Q?9QXwhH54jhQISphUmoKLktCdwoh41qF4ejxGwnNl/qjoLbqyeA+X0jxXqUiv?=
 =?us-ascii?Q?tce2Eb3fWAl1cHCyKR+UZ5COmSNkxf3Ml/pXKEZ/acizl2GFkb3jx/S7/yl1?=
 =?us-ascii?Q?9ei/ELPadHPO+440bvycZ0VuuLfhyU2W5kou1d0JEgHesRvPR/tXWaMDAZ9l?=
 =?us-ascii?Q?sz3x4pd1cUjn+chjBlh4cZ/CcsJnXC/d2NR/2N2DCd1YHNYUZJ54y+/oAeNT?=
 =?us-ascii?Q?zvKXjHG+xaEPfspx7j4ZUp3I11j4lRnYp+O19zki3bgvdYxs2VlHUV/AdI3e?=
 =?us-ascii?Q?ONetN5J/83P2VowVB8nqHk75sLGKP6t5j23hO5h/wTqjQFK9jB+0UTOJhpe8?=
 =?us-ascii?Q?zm1IvqYQ5eslMw7GQV8jGXuaQjxW3EknkFf0wYUY/hJVcE94GrBPyaN66Ydu?=
 =?us-ascii?Q?banAcDT1DqciJ/Etsg42dRsisiR9IOfLYTvcdG2jl33N9cDkP2z3e4rveAyK?=
 =?us-ascii?Q?pxjxtwT/sp8q3kAL+azh4pIaYNJ1R+X5gA/RRwrPILhjg311eAat4fUKefD6?=
 =?us-ascii?Q?xP4QMh2QsVPkiURL21is4QQ2FruU10j7bkASK1CnJITODoZNaiPI+QXPUpe8?=
 =?us-ascii?Q?NC4sPol1eqeBo4ddq2uPTYE0pj4yU49wDm3cFi5Vnd8zpEC1bJ5124xFwg0v?=
 =?us-ascii?Q?g/zPZOiKWO3NDT/hGPdjKBSyLSPu4J1xAKnyz5Uv/eYD590ZoIWv3tKHm5nG?=
 =?us-ascii?Q?JNfY8M2lz1hnuo8s2wvyoOPmTdYw2gExb1Zhg46bNz8YlAwU67NFUXESTTdH?=
 =?us-ascii?Q?LfiVksEdONqspg8tm+RKydYx8n2gORQR4oxBD/7uIzPhhMlitoZKIw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WmNAkwDZGpCyfped950N6B/7bFCaWe134A0/rGgDvD/WvssRXjT0G8cPFvYV?=
 =?us-ascii?Q?YvRpFHaoclzPDX/zsVzHFMcdlflUHEK3vqfspaBO+pDr16o2MpbOGxk/55Yv?=
 =?us-ascii?Q?lNGBYZaPZGee4kTsU573Up48USe6JsiXzzqI6TX5dn233HgjTOf4hVA4ZNwA?=
 =?us-ascii?Q?H0Wpw0lajhE/rBdtqOH+S5QIZB3X9yApSeIcCMeaOdNVkgAjQoNEScg64IiM?=
 =?us-ascii?Q?GBvGZCitBfFQeexFzcQnPzZqz5sdNJkBlq1PB9q409ZT3H6W3SvYVI6d05vI?=
 =?us-ascii?Q?TqMUh+wIJdgACoKp68kuhkDGXrhW1PxGauVjaWV/7YvoAbvNgGmf/eEKOVbD?=
 =?us-ascii?Q?i5K1ODvYPfsP126naePh5ZO/TZS9nSyIq2MQabd76x8IrBer8BOj9SYzoFPe?=
 =?us-ascii?Q?xIvdCCRs2zoAhF05dtt+YL3C2YLDGUgDReDmMN1L1LuW0p3qupqYhUDJQItV?=
 =?us-ascii?Q?1v193o8U2Zx/pY9KeKMuXM+t7idcqg/Jqg77Ldu4YU4peqRTpDu4JCTycVym?=
 =?us-ascii?Q?SoMUGm5DlSvlV2ONlMDhqN0pGWQJqyYijD7OC7oQ4SOqyhmvuTjB1JwDcc/5?=
 =?us-ascii?Q?362l19/pEo/S5NaYujvlPashlcPZzC3hAKIn4i6OlBeZ7pqRQN+DWYKYHZ/y?=
 =?us-ascii?Q?d1FNlTTc4KaXYjnxNCsP2Yh4O35TQw+P9bcEr7BtO0LNAf5DvNelGQzvVr5V?=
 =?us-ascii?Q?aNWj0itxk3HYXVr7SsCViC6qHGFxq6UR8A4l5PtYXGOdJIDNenlDoYenOtGP?=
 =?us-ascii?Q?M/yFX+zsN/+qQ75J8nU2iuhOhpr8w1SRR9rh3Qk6FzOQN2ogjX1RXdodEE+Z?=
 =?us-ascii?Q?t9Z8i+0B02x/KEiY5GpSekiu0QrTpge++g8LaNGBmPMNheTiMrPBYlFnDLXB?=
 =?us-ascii?Q?K+a+PKWWGkRd5la1NG0tKsTIaGtMyhwlsp+0SPMBZgxQZ/ONOiCJy6VRkWb6?=
 =?us-ascii?Q?VhYkU2mqm846qM6/WjiBPFgQPD69y+Mr9OjAgRclGQdDzVshW1kv1jsojMkb?=
 =?us-ascii?Q?PLgjLLfKfWX7Wev6+WywWxW/7gcONEpGgQj16L4Ip3nOsjVzX7NiDZM2by1M?=
 =?us-ascii?Q?VE5jG/FwpM8LXkyy6haoE+AeiAAOltFGUCQkOmlNVX0TUS+lt2YIoXk/vPBE?=
 =?us-ascii?Q?h22Tw+N4nIx7sT7bKX+hBF73Nt6v7Fku7uNUXbP9aP/0KSq8eEj2FbA64cLR?=
 =?us-ascii?Q?8TLwGlFCY/eoaiSt+rvzaGtvxdrFN5nFAKaPuQkNg707AFS4teAtE+Lkpi4l?=
 =?us-ascii?Q?to7dzZRXKICTH6i0tZbZSAQGy6WFmpT+5WA1vRxZPZz4JxYeDHO9LdCHbOf+?=
 =?us-ascii?Q?IydNT2ftI7meFGqDUyb2RbnccMXf7MmTCmjh0TXEYhz1ctvzIw8VgwXOt9HS?=
 =?us-ascii?Q?d8ztVX249wvS/WjCvmmvjoQPgEE6z7Gv8nJjn1D8NM6xj6Wl5Sb4m0Qmzj40?=
 =?us-ascii?Q?5RMxc/DjFrEmY33yekbz9zRoDleucR+5dvAYTPvd5CNynU9Bpu/hDetQsepZ?=
 =?us-ascii?Q?bZuKFtxW+BJcAdpUZ5n0/meUvsDsjpp0NdCF2bcH/raiOpYkHBpH7b5i7+LT?=
 =?us-ascii?Q?DeiW8FLlTtFfD6mQ3MFT991GcNWOquAtBF7td2xI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b9ee6f0-a16b-4505-ee3d-08de0b232bd1
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 13:11:22.1872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: out+vybm50QtTqvRruAE2OuQXtRnUHAwteOx+kJI39HJ+LV3siUWKYIzGozx9nY62P7agmpelVeBPP/QDSp+aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5965
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam05
X-Stat-Signature: ic5c3gyr34nmo4q7hkfjc4w96ezxcwts
X-Rspam-User: 
X-Rspamd-Queue-Id: C37CAC0019
X-HE-Tag: 1760447486-165053
X-HE-Meta: U2FsdGVkX1/6kgOPeX2hh1ATXR0Mzc2+yMYmqhztyOPDRmu6Up+O87+/UKBwSBy/16/hJPNFMcba+/VTP1itPLloGllF/DM6SSdubjn/GmcWhesXPOaU8ZcvmsSNbA64EkGC97/MakQYF5IWYT6GWZf0hr6P/0GtW2X+9h9pQgdDnDgdwsSBI7OpmizYmLtFfXbWeyZFVZ46o80qHMnb3UW7AZrojbqEX3itv5PAAlt/4dfGdWi29HWY+Wyzw3DEgE/7N3J6/hAyZW2eXPZqxxTRaaSGWVBuBcI8xlvoVsmj6nXu+CoDKs2yGoozTaX/nCPXCOFiPkeWqLtTCQM+wPcpdW1QYo/hD3sKHsP/us1uDeznkvKOcGHjgENWOuZP54qWiPpW+Rzq6Wa6S5EwsXVHaoT50Tr7d8e7FP7DWI1PnxDY7zfHBlRqGDNnEoA5bzoJfGVY6uMWhlnAc2bQWhSu7w6OG6c2gIlABJoX+oGMHGn+LwPSuQDkZEG8/6bQLX6PEUocyh2axNO9lyzr8E3UiF85/xR0nJhnfM+i6KwPLbuTdd9ithdL2hemjKXdBgbXv91a67wdFHXvJhscrcOtAYTKDChma3xM2aoPFUlQFzkYR5dWgxFXn0AzTmQJ5hMf4tElvkfbGhZgVTs95aWZjy84T6nhR8XQJ/M6+XgGL1l8ntERKPpkc5eWmIce7ESYgGvsM3Gm7K3PIw4mApHpi3dehcsbwoTbzccltXsYJu8jPnhCK6NLAmBTDj91S+WzO2UDLoqBjL3bfcFiwBvar9DS9+KiP8IHQ9Eyw2fB0VonnYUeOFsril+thDi18E511FqxG84Y0s9ncoUG+EHDaA0AOohe5sJ7opQ66+J9lKjWb/PmhasO/2o7L2r60N4vp9wSGvm1FVlYan8SJzZefjkWm2izRchXDEHv+st8glVKg5UyY3Svv2V1l0UUgTli43mXA67X/MhB4rE
 yNcQzKyJ
 yJckcuv5oIUIUQXkhBrQxo8RhIVgtUHbOzoPLIgSBAXFiZL9UtDwHM9SVEYcfSxVmen8SOoMaLCWCEZY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hi, Vlastimil Babka,

On Mon, Oct 13, 2025 at 04:58:28PM +0200, Vlastimil Babka wrote:
> On 10/10/25 10:39, kernel test robot wrote:
> > 
> > 
> > Hello,
> > 
> > kernel test robot noticed "BUG_kmalloc-#(Not_tainted):Freepointer_corrupt" on:
> > 
> > commit: af92793e52c3a99b828ed4bdd277fd3e11c18d08 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > 
> > [test failed on      linus/master ec714e371f22f716a04e6ecb2a24988c92b26911]
> > [test failed on linux-next/master 0b2f041c47acb45db82b4e847af6e17eb66cd32d]
> > [test failed on        fix commit 83d59d81b20c09c256099d1c15d7da21969581bd]
> > 
> > in testcase: trinity
> > version: trinity-i386-abe9de86-1_20230429
> > with following parameters:
> > 
> > 	runtime: 300s
> > 	group: group-01
> > 	nr_groups: 5
> > 
> > 
> > 
> > config: i386-randconfig-012-20251004
> > compiler: gcc-14
> > test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> > 
> > (please refer to attached dmesg/kmsg for entire log/backtrace)
> > 
> > 
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > | Closes: https://lore.kernel.org/oe-lkp/202510101652.7921fdc6-lkp@intel.com
> 
> Does this fix it?

yes, this fixed the issue we reported. thanks

Tested-by: kernel test robot <oliver.sang@intel.com>

> ----8<----
> From 5f467c4e630a7a8e5ba024d31065413bddf22cec Mon Sep 17 00:00:00 2001
> From: Vlastimil Babka <vbabka@suse.cz>
> Date: Mon, 13 Oct 2025 16:56:28 +0200
> Subject: [PATCH] slab: fix clearing freelist in free_deferred_objects()
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index f9f7f3942074..080d27fe253f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6377,15 +6377,16 @@ static void free_deferred_objects(struct irq_work *work)
>  		slab = virt_to_slab(x);
>  		s = slab->slab_cache;
>  
> +
> +		/* Point 'x' back to the beginning of allocated object */
> +		x -= s->offset;
>  		/*
>  		 * We used freepointer in 'x' to link 'x' into df->objects.
>  		 * Clear it to NULL to avoid false positive detection
>  		 * of "Freepointer corruption".
>  		 */
> -		*(void **)x = NULL;
> +		set_freepointer(s, x, NULL);
>  
> -		/* Point 'x' back to the beginning of allocated object */
> -		x -= s->offset;
>  		__slab_free(s, slab, x, x, 1, _THIS_IP_);
>  	}
>  
> -- 
> 2.51.0
> 
> 

