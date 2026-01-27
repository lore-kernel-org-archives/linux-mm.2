Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB476D25946
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 06:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39A4F6B0088; Tue, 27 Jan 2026 01:06:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 351D96B0089; Tue, 27 Jan 2026 01:06:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FC056B008A; Tue, 27 Jan 2026 01:06:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8E16B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 01:06:47 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D33B13C03D
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 06:06:46 +0000 (UTC)
X-FDA: 84376710012.13.337B39D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf26.hostedemail.com (Postfix) with ESMTP id EF7F7140006
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 06:06:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XTxn8vwj;
	spf=pass (imf26.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769494003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=L6rXKgC2ZNXj1MehXXBR2aAbB2qVxkOp7MNUwFWg6Ks=;
	b=3bN6tVpdQmNjeyCHuF9XJznmCe0+VSDNv4+ljcofyHY/FVIbNW4G7Umcf75fGKbeHv+Jg2
	MRkCWCvXeYlYyFHAQYhsv5jNogdAO2rgkwY9EC4b3tTUiCKRXXPcmGzULbLJZk/YQ87EWa
	xc0jc7DW14uhcH5tgzNy42xSm2BEDXA=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XTxn8vwj;
	spf=pass (imf26.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769494003; a=rsa-sha256;
	cv=fail;
	b=N0VR0RDm64BdCe3nK5trqOcTSwde2t/FzTgN7M10w2sflGAFhtn7G108+s2ApGMQgamxRE
	lz3snKx6BYZR3e+SIadKYrjSuSc1JSzyf6l51Pea2tbod6VGrv1Jq/RSFTI9mwiU+z6rsl
	lNpqSCWOOzyUZuCSBZSvz236J29pd/I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769494003; x=1801030003;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=oU7YOHuk17MG/26NTcN0JFJetFy0tfmSMj+kKbiI0Jo=;
  b=XTxn8vwjUXlr2uSd8xSwFXuFAybVg6L+9JVbICrawy65WWGByV697O6e
   zusyfcPk9oVhBmy/DLMNirXnONdh2qVM0+gG1h8qFL4Wx/oZ1AUa1IWUj
   kI65lnncuLZHZyf+jq7ZKwlkhOpwhvd5SiV8m1YkV6kJESykZuLlc4IsO
   zWWwFCqU8z8urpzgkd4iglTaVSVyriNPp1IRRHnLu/W2dEijqSt2gpHo9
   e0y9bz2DOpf9FiNNgcmvRMfQ6mnNxEByllYb9oql8x9eBJ+h00+b25Ug/
   UxMSNJcoujEUjD5JMZPXjhNpn036CcOjFFcTYBS9s/Imqlebcp6WNQgPI
   g==;
X-CSE-ConnectionGUID: aoU4Rh7gQ4+5g6Mhevz2tg==
X-CSE-MsgGUID: jYYBaNrqQlmVuUljZzR9Yg==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="88095697"
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="88095697"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 22:06:41 -0800
X-CSE-ConnectionGUID: IXPGp636QkKPbgMuBWsvSA==
X-CSE-MsgGUID: XVUTWlv1SS2a50h3kF2yWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="207904142"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 22:06:40 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 22:06:39 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 26 Jan 2026 22:06:39 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.60) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 22:06:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UR+K59pICrCJ43+225nvQcdcqPI4rDqfJN8kFkDlBWtVQ2uXJK3fsDWcOuqcRrW0Y5IvdKcDOhQFi5/uinUecedn3OcGWTpOKhuhQgTplo/j9azSSwlP/PJjx4OvoMb6d27Eh4kvKRUm6Jc1pprT8HsDtqhF1J8aac7OSP2DGHvVaybaS5vVmkd5uDYTja2cKJDAYhYEvE4ugHZMJhGszx1AdJvDsJeG/qKTi+V2RQd+u3kPY/MK1iYJ0D3P4udSpYz5R7tEiWLvYvblnBGvnzopdkWfYtVH5lTePMn6NIEq6INLSSGKZMznI3FPKiWJJ7EHq0xP6NRdEWeLJQb51g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L6rXKgC2ZNXj1MehXXBR2aAbB2qVxkOp7MNUwFWg6Ks=;
 b=tQZygLGX7jhuyBObANi6iHgY5rgDMYCyjeshWOV4WeII6ZRcNa34AbvSpsaY6QUZNkOYPTtzJOwLhyOAoKT6T/PiZfJV37Zfe/JqZ//R4fHUokNT3w4Z3CAm2L3arfFJaArp/ULCXhpezO6sONEN87f0TaSBThs0HQQ+QMjVoAHVN3ZQjzchnzp2Jih11X1PThQ+4ICuwqSUijUZVKoxmRRRdHQ/htkmHvvfyP9kVLUBpoji7iNrffG8JHkSSs6lqfdO3lV9TEK5RGLDRoZALJ5o3PHwLBM7truQcZvwhZLCaenrXsRf/AV4gMqxiavGvZU4ff9OgU9s+8AH7230IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SA3PR11MB9509.namprd11.prod.outlook.com (2603:10b6:806:47e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 27 Jan
 2026 06:06:37 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9542.010; Tue, 27 Jan 2026
 06:06:37 +0000
Date: Tue, 27 Jan 2026 14:06:21 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Qiliang Yuan <realwujing@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Qiliang Yuan
	<yuanql9@chinatelecom.cn>, <linux-mm@kvack.org>, <vbabka@suse.cz>,
	<akpm@linux-foundation.org>, <david@kernel.org>, <edumazet@google.com>,
	<hannes@cmpxchg.org>, <jackmanb@google.com>, <jis1@chinatelecom.cn>,
	<lance.yang@linux.dev>, <linux-kernel@vger.kernel.org>,
	<liyi1@chinatelecom.cn>, <mhocko@suse.com>, <netdev@vger.kernel.org>,
	<realwujing@gmail.com>, <rppt@kernel.org>, <sunshx@chinatelecom.cn>,
	<surenb@google.com>, <wangh13@chinatelecom.cn>, <weixugc@google.com>,
	<willy@infradead.org>, <zhangjn11@chinatelecom.cn>,
	<zhangzq20@chinatelecom.cn>, <ziy@nvidia.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH v7] mm/page_alloc: boost watermarks on atomic allocation
 failure
Message-ID: <202601271341.5d24a59f-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260123064231.250767-1-realwujing@gmail.com>
X-ClientProxiedBy: SI2PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:4:194::17) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SA3PR11MB9509:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d7a6ca6-e254-4246-2624-08de5d6a3ae1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?liFRSBfLlgKGwxeOMY9pPQHvIu9pSavcCMDWEyCvBDCjuwBPOWoZ0gOyNxZd?=
 =?us-ascii?Q?VJgynNAJVxkGJTmc9i/GtSEvMi0R5BCeVVDa+Lc5CBeJXzQRF5M/SbXl1uH/?=
 =?us-ascii?Q?51Rb3p2r7UrqH0FvMIqwVBAUagO5RnC+ixb7Gwq8hr3YdMrF8ervSOtOBgiP?=
 =?us-ascii?Q?zL0fiCXeyrXfJpbt/StZhZRI2jFELv9K8FcZ81pKl62zbf9d4ger9mMlg0lj?=
 =?us-ascii?Q?m2YM7ZRGEXJmlfCE/AdjBh40qkJvv4HouDqnxP6I6tcCdWkyIozvbjMkout8?=
 =?us-ascii?Q?vtoJkGGbBDLYIlX5Atj++Qvixu4Sq98FsYr7ePUr4xQarFh34YD3DpndZYcq?=
 =?us-ascii?Q?JyHqnhEBOmdfXGd9dk+A0Jlk082WXtY8q8f2V8Pe1ywyb1uz5KZl+1DWnBT6?=
 =?us-ascii?Q?49CNT38BEMseucllsZ8RlgsYykGue48wOJ+tjCPGitrUWpK1oHnEmWSsqPtr?=
 =?us-ascii?Q?9Y+mR93pIJCmKSu6smECoGn/bCMGkfpp7AlHx5chUrt71aSEAf69XLLN9Wnh?=
 =?us-ascii?Q?PnqCaGeZJ7lQDwxnM3TDRIqtk+WcxWE+/53qntFrnFsXSZMXRGqRGmTMRTVe?=
 =?us-ascii?Q?eMcv49Vy5iV2nxWcF/LOlUX7sCEmVg5lANmNmJPe2sg+BN+mSMnf1KdXCOpk?=
 =?us-ascii?Q?qHwC7bO3rDmDWwcZHYU2y4ePiiiFaRaeQ2D8BFSjIKEZ8wJ80zzj6ED4wTq9?=
 =?us-ascii?Q?0UBiC0BjNcCmLjixM45T6XXyuOjFDwVQvZJfsAMLCCQkfPqvRctXB4yUKh/u?=
 =?us-ascii?Q?31h1sPLZrxUmml+0D/9OhWMveH8dhg1PUahYgckOyktFH/WzlW6UBZ6Q05tA?=
 =?us-ascii?Q?IDsaXyDh4BqRRQdf2VyilqcXCcbVfHMHcAUXDDwMxwx+k9+TJ1H14e0KIeZz?=
 =?us-ascii?Q?BWyQhB+EB0inZEfVv5CdkvFQPCPiskrF9sghecmbDQtYPBaHcIj0lyXObtMS?=
 =?us-ascii?Q?a+AnYs0Vi2f6qVHan3ZrAErdZk9Cb69i1FV8B9ArPRGJo8W0krVHi4nwPo8C?=
 =?us-ascii?Q?fnOTHJZvywsOKditKuY/ucfo15brCnHx9qq2P/7GaM0vQ4MvuxX+fwNZH+EG?=
 =?us-ascii?Q?oQQ3iAeG9tifOxK3Bx+E9QGdyrQYaVXJPdg/dDDWarYDMuuz4jMyOwy1Io+Y?=
 =?us-ascii?Q?Itqs/72N3IY+lzjTvDAiMYZZLsQnrB6Sfus+Qq3JGS8HV/E915OarZOXCgNN?=
 =?us-ascii?Q?jnXw2Nbg+ZPZ7nkaOL6QQee0AtY2XRVX5hRro4EDjd+ViAc8Sv7vWzGy3+Qq?=
 =?us-ascii?Q?2+it8aNpk6cbVAbr5keiziCuRSlx6+5Qb7EbxIQ8MGA+//ED1M5agaCbRw4q?=
 =?us-ascii?Q?YgXOa3kuRdvqtj5RNjNCkiZDmMl3KjddDaGks+KnZiMvEUaqEHdJ9EeLsSwG?=
 =?us-ascii?Q?TLa+qin8lYt2ksfO5OcaM4eNWLhd7hb7+aIxQ2/ILfLmYlQ91o/8Zz/dMd2m?=
 =?us-ascii?Q?RkbUDCkL8rvjIfkb3to3QSbr+Jpq4FdWPK+b31jKOIce6KLBnHEtgWfkKiaj?=
 =?us-ascii?Q?+qLF2kNuWTRo5U2CFUHw5OP4V/dozS2EX0AYOLcJ2e4gGYRIUXJBBtdFUpo5?=
 =?us-ascii?Q?RpAXdctGXfO69jXr/Emss2OiYrXLn8lbMknAsMAs?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+8Ovq0hnqlFQTOLr38AmHxecV6LI9ilhUoghX73/U++28OPVVtJ7gRQ0FTir?=
 =?us-ascii?Q?F97qTvmAsHW4Yu/ULVHZGoczolLTdWVd/tymIRaVnbEyA92uJS2FxmJngpoP?=
 =?us-ascii?Q?8+uQIU9cXZcCraXg/82bN/Ba8dJKoRRw8Y27zbwrzcBhABnq3BeiAsCRm6Ur?=
 =?us-ascii?Q?051HhHHJs80IVS+yqDCNiFJqfgUndRdhwvE3NzibaGYdePAftCSCqYJt6LZd?=
 =?us-ascii?Q?suC7JlIUi+y1AF0E4o0HL4B4JUTUAtNs5X1oMLOFipYG57dzLPwXrI4vNLDy?=
 =?us-ascii?Q?JHc7uDgGttspCy9ef5gdRJDqRZhYZx98JQvT82qB1ZDssEimb5Hmtw7tD4ex?=
 =?us-ascii?Q?d+dR7xU7Jt6ALiA90YMgmZJr4BsnMFPgX3M2toLuMmS2xpjc+nLTetNumAzx?=
 =?us-ascii?Q?LTudND3n1WvzC9O3OpU7ATr0uLWL1d4S48I3Jv6TVChDB3quSxQjOzXFoiHK?=
 =?us-ascii?Q?57EGwccKt6zDK1dWpKtm/hDcHcaH7sfCwe4Wqvm6ZmggXu/DykrnWKe1JlhX?=
 =?us-ascii?Q?pDSljCCoo98QEQni/SwE4gSLHUtcGP+ccXGSku1gikbAVGc3Q7t0+sA6I3Ve?=
 =?us-ascii?Q?3/nkB2p47WjuktAP/aTW4laL0zWCKhCcQ+TyZ6duxj9xZdObT+Ndd+ljxMgI?=
 =?us-ascii?Q?Iv01vBrw/5ylJBlgAA9KPglx4RUepC2tn2fxWwG4QW0OM6A42NfByIH0TjZ2?=
 =?us-ascii?Q?+Iape8iu3av7yX92CXJ5iNeLvI8MZNpjW3f6uAx5yB1OtL8MjfZZ/u4igptO?=
 =?us-ascii?Q?QNMl1HK5qCsfsES7sDNO0IYMbF2u1i0UqqHoQlJ3tEa1lS6yTEtJRm0RO8IB?=
 =?us-ascii?Q?WpH3p3RluzaDtV0Gahwto53rYp0VtmZQdPVz+FIHgQ75PR4qI1lKd6Y/Icff?=
 =?us-ascii?Q?HliiODRZwcL3dXF/P20K4xyq8vfiuxMNntTF7hKanG5sgNoxEUjU/bx2sAbW?=
 =?us-ascii?Q?l71hF8yT79HmsShA21mzdKMtM1SlKNp/MPXcXzxMisAkKgCrl1pkMPbfNDzY?=
 =?us-ascii?Q?7ZkoKSGdQyv0Vrcqu3xu3WIjQGQdYIQZRwI+ySsQkFi6rfLBF9F349qVJAQo?=
 =?us-ascii?Q?YvUqiwnCAmHJfkfdoXCK0G2LQ7BsnrdBFTT29KYAftEs+NdpG3fhaFqCEZmi?=
 =?us-ascii?Q?RAb3+X+pwXJtSYFqIqFsmpsBQBePgd234OsPSqNOw9qomGobM1fr6Gaw0jHS?=
 =?us-ascii?Q?vRHJopk/pMdlMaDP/xq/+pyF5sL2tqWfqgXfqEuGYSe9fWld+SEyNE+lAPG/?=
 =?us-ascii?Q?lX2spZwBDuKaewZOPbUmiG8FLrHMX+ofFbm2t8tobsQhuaGKOsJI2JRYyDLZ?=
 =?us-ascii?Q?oIrNIgSUpCIKQ6Plyftc5o9ViW5WcI+zdntG1f0/JL1X99tc6PG9uuc0CbFa?=
 =?us-ascii?Q?YYL/p2uD+JTph4IPKhNSEOA8NVfDU7T/rJrAshvmjAtJUJ132/00eypPgrsP?=
 =?us-ascii?Q?BLMTGnwYaOEvcLhJ1ImQCxQYUmnriEUgJXcZHFylAh0zSFEIqNBpCoIYvShL?=
 =?us-ascii?Q?KD/ckm2Ko0zGuGJ8kxMe3krIyAi1x2iPEC6AJJpysq6ntUEqAJJ6SAXPZH/G?=
 =?us-ascii?Q?WDEPThpDQWydRyAD23+sRTBiR2zqJ18Vg6a2IAC+uoirNV+N3Zlal5ywqrQC?=
 =?us-ascii?Q?pO9oviO/06UaMW17OhNDmUivuwGdyS3SbIpPp7Cj6TWblwkB5BmaWsWsNHF+?=
 =?us-ascii?Q?p1fRe64eZ8myyw9vNRLoBaoC81OIAQpTqinfsgCxOT98DbN6W/UyHBZCyj5c?=
 =?us-ascii?Q?f+c7js1vHQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d7a6ca6-e254-4246-2624-08de5d6a3ae1
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 06:06:37.0249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8y5PG+gEjaiO1/QWXu0eb9qVZQR4VM+bZrOoYoVwO1KJOdAqMGh9iIVuuB1nonjqOoEsTSw2EkfV+WeqYaNdDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9509
X-OriginatorOrg: intel.com
X-Stat-Signature: na713g5cwc6wkbqfyuypnydmcxcwaoqh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EF7F7140006
X-HE-Tag: 1769494002-350015
X-HE-Meta: U2FsdGVkX1+wE+kLZi8PUn4NEa+dJ1DJivt+HHwSEyiJDJfvqIW271yq/OuEJEQBUWIjnvUMHHKIqOyPSxDyC4EhU4cyYHw7ZVwixWIHHSeHd0Xo1bpk5gCHC+Hp9zAwswJkLqVwXdjcTd9HBsgYl0CB8ixmC9DERWcNeALoS7LboKEDu2Af6N8a2Kte1b2e+jCUOOpWOAAayBh8uNwN0IsuLTmj3rDhPDTdNTpKXc9EZREztJHV9U5mdVw3GF0sppQEc2RU2886vTtzQaIJA7+5fU/YBfb8MgV1EQui1SL0ryddsDntx6HKUPYcEukx7E1y4LwuGpf0Zb5kXrD6f6k9Vsqnae8cDLJIeryWct+YXyORo2C2vjHz+I9XCDkc2Rp/FLLhjXDdhsCRQc+RFhgtC2UEaKqK0qvT9Wjrua6PUv9LZgVS1Y5Oof9qrJrkN5cLMCal5SR0MmUR7v+LyCf4oTC/YsqvCZH4MOw8xl0kKP+FUMrqJkONmdB36G3UDrUTVxXXOMKpOuWBrov53kNmk1/x8LhVSH9AdcgwuuhjI73LP0WVeRGoUA0zQpBqgydhPMSk+Nr4mcmRHjVPDr7PBhiKGXtAw8h25u/8G0nHJJm0yCcPrZUejm/ndxsaAjuOs/XFC07jgt1A0KFRpl93uc7aHIXQzkvVXxW9AjqBe9eZDig4HUjQcrHq9PNZoQlFMvPDRgRpYQ+iszy2+ro4buZYFkLnyVAWchEHMwCMfDiHTEuuxmdIgbaG/B+w/YluMZsc4NkyR3pXACfI+12bEY3QlxfA/92dZpwcKulXo83Ga0PwQXQpRd+P1SeIqiroZjbnHVEPQUOK11MONhsUiDJbyWPft/rNp5RtffVzbYfGxmKRdFw40ByifSCd2/LInXr77QoZI8M4v0Kbil9wN2HYIEL7a3O8tw3XYIbTEQbbdq5Zyp0hcQJqamDV+YeaAprklTrHSNMgKCz
 Lk7IoLvr
 dOLx1yUVDHqQZ5DoFpoK4QcEqMI0EJKNNA9isOdDuCGSG/wMiOb1PRWuyQunHiBLlMrszr6iEtn9f6MI29xUGJFJziTPzn6RLM3ATtirYveZfB+PW+zHis5E3wwlaE1ISRCstbXJfRwuvTXkX4YA5Nl/Z/6FmOyqmJPKEalaU/o34oq++hIzpM3qQMPElZmzRMtEhHSi0dpLVdG2xsO7T0NbIq8I4PJ5ScoC9zhKHB4bg8HaFbAkhG1mb914AJH24UhztRcmnl3qzFVBpUMzRr0hVq/sT9w+YedSmVu9QyoS5WS3a8+BMi2DnuMqTTSc0vWi1F0/TY5PQtuRTnsIYi0Z/GPIVb1fer05VKXgD8gHrmvKbD+zjTwATlxXGt6pszZBE9w3NAbgaRgoIgeOURq1dpgrEY+J0eUKAeyaf2rnuxsMnaJkmL/ZJ0Zkd3/wznd2l/fgf17dIR19D3cOaiCxcAiJRZCfxiw3k43Ai3xKIvf3XvbXkgRBmi2/U8BtQK56+vwPXrDwoNex7dWZ1ZeFtP/yEPReV+o8GYg0BegX0r6dn8ClybsiR0ogERfPXDtPYN97E079+E3uvee20gStq1b/SkgfuOXNm5Ly6xmNNznqECO8dMe/4mKJjwMLLA+mQcN+wKiYYKEZfnCB10shCGlrWKGJzK56F4AnpgC89NTc57UkS3CjeYLRyARcZL8h5QDNpnQhqRO0fUhTsYQbqgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "WARNING:inconsistent_lock_state" on:

commit: 4f0cbecbc533f56605274f6211e31907ed792bdf ("[PATCH v7] mm/page_alloc: boost watermarks on atomic allocation failure")
url: https://github.com/intel-lab-lkp/linux/commits/Qiliang-Yuan/mm-page_alloc-boost-watermarks-on-atomic-allocation-failure/20260123-144418
base: v6.19-rc6
patch link: https://lore.kernel.org/all/20260123064231.250767-1-realwujing@gmail.com/
patch subject: [PATCH v7] mm/page_alloc: boost watermarks on atomic allocation failure

in testcase: trinity
version: trinity-i386-abe9de86-1_20230429
with following parameters:

	runtime: 600s



config: x86_64-randconfig-075-20251114
compiler: gcc-14
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202601271341.5d24a59f-lkp@intel.com



[  151.153230][ T1379] WARNING: inconsistent lock state
[  151.153836][ T1379] 6.19.0-rc6-00001-g4f0cbecbc533 #1 Not tainted
[  151.154605][ T1379] --------------------------------
[  151.155192][ T1379] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
[  151.155825][ T1379] trinity-c0/1379 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  151.156424][ T1379] ffffffff8865d9e8 (&zone->lock){+.?.}-{3:3}, at: __alloc_pages_slowpath+0x1265/0x1b00
[  151.157399][ T1379] {IN-SOFTIRQ-W} state was registered at:
[  151.158029][ T1379]   __lock_acquire (kernel/locking/lockdep.c:5191 (discriminator 1))
[  151.158629][ T1379]   lock_acquire (include/trace/events/lock.h:24 (discriminator 15) include/trace/events/lock.h:24 (discriminator 15) kernel/locking/lockdep.c:5831 (discriminator 15))
[  151.159221][ T1379]   lock_acquire (kernel/locking/lockdep.c:5833)
[  151.159670][ T1379]   _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:111 kernel/locking/spinlock.c:162)
[  151.160180][ T1379]   rmqueue_bulk (mm/page_alloc.c:2592 (discriminator 1))
[  151.160637][ T1379]   __rmqueue_pcplist (mm/page_alloc.c:3374 (discriminator 3))
[  151.161132][ T1379]   rmqueue+0x1b3c/0x3400
[  151.161630][ T1379]   get_page_from_freelist (mm/page_alloc.c:3982)
[  151.162294][ T1379]   __alloc_frozen_pages_noprof (mm/page_alloc.c:5282)
[  151.163006][ T1379]   allocate_slab (mm/slub.c:3079 mm/slub.c:3248)
[  151.163482][ T1379]   ___slab_alloc (mm/slub.c:3302 mm/slub.c:4656)
[  151.163962][ T1379]   __slab_alloc+0x30/0x80
[  151.164464][ T1379]   __kmalloc_noprof (mm/slub.c:4855 mm/slub.c:5251 mm/slub.c:5656 mm/slub.c:5669)
[  151.164954][ T1379]   alloc_ep_req (drivers/usb/gadget/u_f.c:22 (discriminator 4))
[  151.165425][ T1379]   source_sink_start_ep (drivers/usb/gadget/function/f_sourcesink.c:292 drivers/usb/gadget/function/f_sourcesink.c:608)
[  151.166375][ T1379]   enable_source_sink (drivers/usb/gadget/function/f_sourcesink.c:662)
[  151.167006][ T1379]   sourcesink_set_alt (drivers/usb/gadget/function/f_sourcesink.c:744)
[  151.167515][ T1379]   set_config+0x323/0xb00
[  151.168019][ T1379]   composite_setup (include/linux/spinlock.h:391 drivers/usb/gadget/composite.c:1901)
[  151.168548][ T1379]   dummy_timer (include/linux/spinlock.h:351 drivers/usb/gadget/udc/dummy_hcd.c:1929)
[  151.169019][ T1379]   __hrtimer_run_queues (kernel/time/hrtimer.c:1777 kernel/time/hrtimer.c:1841)
[  151.169550][ T1379]   hrtimer_run_softirq (kernel/time/hrtimer.c:1860)
[  151.170198][ T1379]   handle_softirqs (arch/x86/include/asm/jump_label.h:37 include/trace/events/irq.h:142 kernel/softirq.c:623)
[  151.170817][ T1379]   __irq_exit_rcu (kernel/softirq.c:657 kernel/softirq.c:496 kernel/softirq.c:723)
[  151.171325][ T1379]   irq_exit_rcu (kernel/softirq.c:741 (discriminator 38))
[  151.171780][ T1379]   sysvec_call_function_single (arch/x86/kernel/smp.c:266 (discriminator 35) arch/x86/kernel/smp.c:266 (discriminator 35))
[  151.172366][ T1379]   asm_sysvec_call_function_single (arch/x86/include/asm/idtentry.h:704)
[  151.172952][ T1379]   pv_native_safe_halt (arch/x86/kernel/paravirt.c:82)
[  151.173449][ T1379]   arch_cpu_idle (arch/x86/kernel/process.c:805)
[  151.173991][ T1379]   default_idle_call (include/linux/cpuidle.h:143 (discriminator 1) kernel/sched/idle.c:123 (discriminator 1))
[  151.174997][ T1379]   cpuidle_idle_call (kernel/sched/idle.c:192)
[  151.175913][ T1379]   do_idle (kernel/sched/idle.c:332)
[  151.176666][ T1379]   cpu_startup_entry (kernel/sched/idle.c:429)
[  151.177536][ T1379]   rest_init (init/main.c:757)
[  151.178357][ T1379]   start_kernel (init/main.c:1206)
[  151.179249][ T1379]   x86_64_start_reservations (arch/x86/kernel/head64.c:310)
[  151.180213][ T1379]   x86_64_start_kernel (??:?)
[  151.181119][ T1379]   common_startup_64 (arch/x86/kernel/head_64.S:419)
[  151.181992][ T1379] irq event stamp: 16437333
[  151.182773][ T1379] hardirqs last  enabled at (16437333): _raw_spin_unlock_irq (arch/x86/include/asm/irqflags.h:42 arch/x86/include/asm/irqflags.h:119 include/linux/spinlock_api_smp.h:159 kernel/locking/spinlock.c:202)
[  151.184399][ T1379] hardirqs last disabled at (16437332): _raw_spin_lock_irq (include/linux/spinlock_api_smp.h:117 (discriminator 1) kernel/locking/spinlock.c:170 (discriminator 1))
[  151.186068][ T1379] softirqs last  enabled at (16422642): handle_softirqs (kernel/softirq.c:469 (discriminator 2) kernel/softirq.c:650 (discriminator 2))
[  151.187758][ T1379] softirqs last disabled at (16422637): __irq_exit_rcu (kernel/softirq.c:657 kernel/softirq.c:496 kernel/softirq.c:723)
[  151.189383][ T1379]
[  151.189383][ T1379] other info that might help us debug this:
[  151.190809][ T1379]  Possible unsafe locking scenario:
[  151.190809][ T1379]
[  151.192092][ T1379]        CPU0
[  151.192740][ T1379]        ----
[  151.193401][ T1379]   lock(&zone->lock);
[  151.194192][ T1379]   <Interrupt>
[  151.194940][ T1379]     lock(&zone->lock);
[  151.195734][ T1379]
[  151.195734][ T1379]  *** DEADLOCK ***
[  151.195734][ T1379]
[  151.197223][ T1379] 2 locks held by trinity-c0/1379:
[  151.198134][ T1379]  #0: ffff8881001b2400 (sb_writers#5){.+.+}-{0:0}, at: ksys_fallocate (include/linux/file.h:62 (discriminator 1) include/linux/file.h:83 (discriminator 1) fs/open.c:358 (discriminator 1))
[  151.199767][ T1379]  #1: ffff8881373cd0d0 (&sb->s_type->i_mutex_key#12){+.+.}-{4:4}, at: shmem_fallocate (mm/shmem.c:3688)
[  151.201543][ T1379]
[  151.201543][ T1379] stack backtrace:
[  151.202709][ T1379] CPU: 0 UID: 65534 PID: 1379 Comm: trinity-c0 Not tainted 6.19.0-rc6-00001-g4f0cbecbc533 #1 PREEMPT  5190a26909b47a16cbbcf00ba20dd51a77658a62
[  151.202723][ T1379] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  151.202735][ T1379] Call Trace:
[  151.202739][ T1379]  <TASK>
[  151.202743][ T1379]  dump_stack_lvl (lib/dump_stack.c:122)
[  151.202760][ T1379]  dump_stack (lib/dump_stack.c:130)
[  151.202766][ T1379]  print_usage_bug+0x25d/0x380
[  151.202775][ T1379]  mark_lock_irq (kernel/locking/lockdep.c:4268)
[  151.202782][ T1379]  ? save_trace (kernel/locking/lockdep.c:557 (discriminator 1) kernel/locking/lockdep.c:594 (discriminator 1))
[  151.202792][ T1379]  mark_lock (kernel/locking/lockdep.c:4753)
[  151.202798][ T1379]  mark_usage (kernel/locking/lockdep.c:4666 (discriminator 1))
[  151.202803][ T1379]  __lock_acquire (kernel/locking/lockdep.c:5191 (discriminator 1))
[  151.202809][ T1379]  ? mark_held_locks (kernel/locking/lockdep.c:4325 (discriminator 1))
[  151.202815][ T1379]  lock_acquire (include/trace/events/lock.h:24 (discriminator 15) include/trace/events/lock.h:24 (discriminator 15) kernel/locking/lockdep.c:5831 (discriminator 15))
[  151.202820][ T1379]  ? __alloc_pages_slowpath+0x1265/0x1b00
[  151.202832][ T1379]  ? get_page_from_freelist (mm/page_alloc.c:3733 (discriminator 1) mm/page_alloc.c:3936 (discriminator 1))
[  151.202838][ T1379]  ? wakeup_kswapd (arch/x86/include/asm/atomic64_64.h:15 include/linux/atomic/atomic-arch-fallback.h:2583 include/linux/atomic/atomic-long.h:38 include/linux/atomic/atomic-instrumented.h:3189 include/linux/mmzone.h:1106 include/linux/mmzone.h:1600 mm/vmscan.c:7378)
[  151.202848][ T1379]  lock_acquire (kernel/locking/lockdep.c:5833)
[  151.202853][ T1379]  ? __alloc_pages_slowpath+0x1265/0x1b00
[  151.202861][ T1379]  _raw_spin_lock (include/linux/spinlock_api_smp.h:134 kernel/locking/spinlock.c:154)
[  151.202869][ T1379]  ? __alloc_pages_slowpath+0x1265/0x1b00
[  151.202876][ T1379]  __alloc_pages_slowpath+0x1265/0x1b00
[  151.202887][ T1379]  ? warn_alloc (mm/page_alloc.c:4731)
[  151.202896][ T1379]  ? get_page_from_freelist (mm/page_alloc.c:3733 (discriminator 1) mm/page_alloc.c:3936 (discriminator 1))
[  151.202902][ T1379]  ? lock_is_held_type (kernel/locking/lockdep.c:5601 (discriminator 1) kernel/locking/lockdep.c:5940 (discriminator 1))
[  151.202913][ T1379]  __alloc_frozen_pages_noprof (mm/page_alloc.c:5295)
[  151.202920][ T1379]  ? __alloc_pages_slowpath+0x1b00/0x1b00
[  151.202929][ T1379]  ? filemap_get_entry (mm/filemap.c:1888)
[  151.202936][ T1379]  ? __folio_lock_or_retry (mm/filemap.c:1888)
[  151.202944][ T1379]  __folio_alloc_noprof (mm/page_alloc.c:5316 mm/page_alloc.c:5326)
[  151.202951][ T1379]  shmem_alloc_and_add_folio+0xfc/0x3c0
[  151.202961][ T1379]  shmem_get_folio_gfp+0x388/0xd80
[  151.202970][ T1379]  shmem_fallocate (mm/shmem.c:3780)
[  151.202980][ T1379]  ? shmem_get_link (mm/shmem.c:3675)
[  151.202987][ T1379]  ? find_held_lock (kernel/locking/lockdep.c:5350 (discriminator 1))
[  151.202998][ T1379]  ? __lock_acquire (kernel/locking/lockdep.c:5237 (discriminator 1))
[  151.203003][ T1379]  ? find_held_lock (kernel/locking/lockdep.c:5350 (discriminator 1))
[  151.203013][ T1379]  ? lock_acquire (include/trace/events/lock.h:24 (discriminator 15) include/trace/events/lock.h:24 (discriminator 15) kernel/locking/lockdep.c:5831 (discriminator 15))
[  151.203018][ T1379]  ? ksys_fallocate (include/linux/file.h:62 (discriminator 1) include/linux/file.h:83 (discriminator 1) fs/open.c:358 (discriminator 1))
[  151.203030][ T1379]  ? lock_is_held_type (kernel/locking/lockdep.c:5601 (discriminator 1) kernel/locking/lockdep.c:5940 (discriminator 1))
[  151.203039][ T1379]  vfs_fallocate (fs/open.c:339 (discriminator 1))
[  151.203047][ T1379]  ksys_fallocate (include/linux/file.h:62 (discriminator 1) include/linux/file.h:83 (discriminator 1) fs/open.c:358 (discriminator 1))
[  151.203055][ T1379]  __ia32_sys_ia32_fallocate (arch/x86/kernel/sys_ia32.c:119)
[  151.203065][ T1379]  ? __do_fast_syscall_32 (arch/x86/include/asm/irqflags.h:42 arch/x86/include/asm/irqflags.h:119 arch/x86/entry/syscall_32.c:280)
[  151.203074][ T1379]  ia32_sys_call (arch/x86/entry/syscall_32.c:50)
[  151.203079][ T1379]  __do_fast_syscall_32 (arch/x86/entry/syscall_32.c:83 (discriminator 1) arch/x86/entry/syscall_32.c:307 (discriminator 1))
[  151.203088][ T1379]  do_fast_syscall_32 (arch/x86/entry/syscall_32.c:332 (discriminator 1))
[  151.203096][ T1379]  do_SYSENTER_32 (arch/x86/entry/syscall_32.c:371)
[  151.203103][ T1379]  entry_SYSENTER_compat_after_hwframe (arch/x86/entry/entry_64_compat.S:127)
[  151.203111][ T1379] RIP: 0023:0xf7ed9589
[  151.203118][ T1379] Code: 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 2e 8d b4 26 00 00 00 00 8d b4 26 00 00 00
All code
========
   0:	03 74 d8 01          	add    0x1(%rax,%rbx,8),%esi
	...
  20:	00 51 52             	add    %dl,0x52(%rcx)
  23:	55                   	push   %rbp
  24:	89 e5                	mov    %esp,%ebp
  26:*	0f 34                	sysenter		<-- trapping instruction
  28:	cd 80                	int    $0x80
  2a:	5d                   	pop    %rbp
  2b:	5a                   	pop    %rdx
  2c:	59                   	pop    %rcx
  2d:	c3                   	ret
  2e:	90                   	nop
  2f:	90                   	nop
  30:	90                   	nop
  31:	90                   	nop
  32:	2e 8d b4 26 00 00 00 	cs lea 0x0(%rsi,%riz,1),%esi
  39:	00 
  3a:	8d                   	.byte 0x8d
  3b:	b4 26                	mov    $0x26,%ah
  3d:	00 00                	add    %al,(%rax)
	...

Code starting with the faulting instruction
===========================================
   0:	5d                   	pop    %rbp
   1:	5a                   	pop    %rdx
   2:	59                   	pop    %rcx
   3:	c3                   	ret
   4:	90                   	nop
   5:	90                   	nop
   6:	90                   	nop
   7:	90                   	nop
   8:	2e 8d b4 26 00 00 00 	cs lea 0x0(%rsi,%riz,1),%esi
   f:	00 
  10:	8d                   	.byte 0x8d
  11:	b4 26                	mov    $0x26,%ah
  13:	00 00                	add    %al,(%rax)


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260127/202601271341.5d24a59f-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


