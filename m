Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 662BBD41D4C
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 14:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86D7F6B0006; Thu, 11 Dec 2025 09:42:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81E266B0007; Thu, 11 Dec 2025 09:42:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BF196B0008; Thu, 11 Dec 2025 09:42:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5520A6B0006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:42:53 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1EF401A01FA
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 14:42:53 +0000 (UTC)
X-FDA: 84207457026.16.4F9C101
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf23.hostedemail.com (Postfix) with ESMTP id A8D4D140013
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 14:42:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MXcQL6wR;
	spf=pass (imf23.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765464169; a=rsa-sha256;
	cv=fail;
	b=2xAL7dkhvNtOEoFIty/5Xl1cHQEMjQAjJmop0dAkynOAWmO6hufoZdUsOPq1Bhs3rP5Wso
	wY9Y6jgk6zZPI7nFClGyQ60On2yrfz2gFigh4e+bUtGyT/1esw7+/JEE49X8xDJszFw4qu
	V2TujAAfjrdMaC155tOjhR0rj9bivWQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765464169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CDSL1BrnIEVvGfBLgr+PGyNqKpeEgDlAERNUAl9gNso=;
	b=HR9pPYVUqQTtprhm9bv+eJJd/rrlqDJQrUHaq6TjZ5hcYIuEJyZBnP19W7v+mMPLE+Fpeb
	4vCOVXXNuM9Vrnxb5qMyZ48sWz8gm0U9V7o+EDS6EbBisx3VHytIYCTUHQxnGLqd1yXjan
	/ijZ9ODux0+Sczty8C0TtRl6EBeq+HA=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MXcQL6wR;
	spf=pass (imf23.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765464168; x=1797000168;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=dJsv57NzYJPtAfaPgeMj+MJxoMwKaOJbHl/WpB7atDk=;
  b=MXcQL6wR7smnSD7WkuloZIcwq9xRnNHuFt9Nm3A/kS4V1Jvo+Vz4Cs7X
   ecTckklIgFPJYUCkDqnHn4gWmegFGxA621pAQXqMfXCzah/DahNx9+14d
   q6300X4xMnt5P2n7A5jnEJo0pzllCwc4hhHnOqRqRpl7BCF2C3L49M8bK
   x5nhbKwi0eFfYlQHdBmvzBu1lg8n1ZGaWQy+nR28DQGwrowCdIOqOWG5o
   oe+NQCEmsy4GHzYsdCPGBIty2cQAh2mYksgm9X6bdt5ArmO5X7lYS5+pU
   HV+wE+GLy4Z6Crp/b4SUk7q3gKQ0u221eANRALmZfyQEC+A+cVSQhCvCX
   Q==;
X-CSE-ConnectionGUID: yZZ1N1mwTdKa145Io6qK4w==
X-CSE-MsgGUID: 1OLo03IsS1yk17ybAkDD5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="67486235"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="67486235"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 06:42:47 -0800
X-CSE-ConnectionGUID: JoETAlVdQlqUgSShmXUTmg==
X-CSE-MsgGUID: 2clzRUVSTmeXMjIwTMwsXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="196584555"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 06:42:47 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 06:42:45 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 11 Dec 2025 06:42:45 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.1) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 06:42:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K0mmtrKIj58Tvbsb+qi3fzILsPZ0yhEDX049Ew+BnbTdi7jpcFr/QXatvPwRukeIcM+Hi1iQlOCc440pt/czuJin9neeS24ao2gIA43DxEtF8lwtDBOg9yJrsYGFLI+EyGUyw6NKXcWaHquQMCBO2My5FNHCc0oxeP1wU2DyXZ4CsvdjpX+Egw81L/2djKS29P1D3A8c2ZlrCAyTeeJATeJ2VGz5i6TDFcC1jBkWnTRDnEkCzhGthY/fCz4g01FVFhsyEkYVh1Q8Wy00TRRNFunMOYlmwiZQPSeQcWbFjg+y59PWWrOfRq8sOzwN2tK4h6ndm2aazIU9cZMqBr7tZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDSL1BrnIEVvGfBLgr+PGyNqKpeEgDlAERNUAl9gNso=;
 b=v2uyRRYmyt0Rs3mrDVHG622ErtzWSiimEXALi9sHZTWydOkHUREC4z0V/bjElCMWzFJCN3g7rwRd6f9S6S9o18cbfey6zuvV0Xpl7Fcrd/5/sUU9I2eNxssH0EIbCr9TVjde0BMxmQZ3/sjkTMcYS9tWgBtqXLn5t2w8IxlTdREfV3SmFPRrcOzq5ezpQPC7dZJPGGlVfpfLvdTvQ+2UdiLeO3pTL34yubBCv0DuMG7IvP/JXv33LPwhcKlrkmlcYontYvpcHR2h4sGhlMlvI1QRsJOm+fkvpMduzId3H9/SAAP/4Zeu4QQmcFqX/XqXTR982loi+BJTW5cQGvtmNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SJ2PR11MB7425.namprd11.prod.outlook.com (2603:10b6:a03:4c0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Thu, 11 Dec
 2025 14:42:42 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9412.005; Thu, 11 Dec 2025
 14:42:42 +0000
Date: Thu, 11 Dec 2025 22:42:33 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Ma Ke <make24@iscas.ac.cn>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Mika
 =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [linus:master] [mm/hmm/test]  fe9d31fd1a:
 WARNING:at_drivers/base/core.c:#device_release
Message-ID: <202512112128.e5e07e77-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: TP0P295CA0031.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::12) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SJ2PR11MB7425:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f7fbb2d-3335-4c7c-f9c7-08de38c38a64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?dmkD8ED9dqX5y5FtaqrYFMbyvclWfqTbLqhAaXXAQH0MS5B9nIRjA2JdlyND?=
 =?us-ascii?Q?OmISuxSGk6VNumU+Sf1aEWI1kTPeAnTZ8RDQXWjZnANqwqMKwu4L/2utEayd?=
 =?us-ascii?Q?0OgVS3Sa9zPdqKmQfgSwlM7nu458Nodol0qQqMh2wamV9SclsFaQIOSPdMwe?=
 =?us-ascii?Q?Y1ZeImK/gOudY3u1CyFuIJkinZLo3fmdJBBxshoPYt8qDqvVsl6e0EAKYhLE?=
 =?us-ascii?Q?wEjw+Ux+Zn1eB7vgnxopCQrR41mHlTrdxu8UFvaKRap72TF81SJWdEvm/o05?=
 =?us-ascii?Q?k0+LzLInSBsgoG/pzxxrr26X+J6eRJZomPtlk6LLLQ8jLQhdHhQSJ5hdwiEH?=
 =?us-ascii?Q?I6jPgZ5DMFPGJcBbrIxf2Ts2BnXCeKUHfi6j5loB5h7ac9q7uZuBqGS6CPuo?=
 =?us-ascii?Q?Fkoh2HIIVaD87LobePFp611uHIMScoV4EzgP6F1lOiGckWNcK17PxnEv0RoB?=
 =?us-ascii?Q?JrDm0CUB0RQmafjbnDlzFB2iV9M4+QDI84hMOxudku+MgRQmtxzBMba3P6k2?=
 =?us-ascii?Q?fJrDVq330z1p4dbneuVLJ5KMgbFmSaUtyARcvBEZyEm3E5hFm2QlZTb5w770?=
 =?us-ascii?Q?L6AZefJLL0u4lpknsmCBc9V0SANQLjBjdzQ62nGDSpDZ4ejXvTzFlpvCj3Y7?=
 =?us-ascii?Q?k1h5pebyj6sDe8VeYudBAWdeqp3N0wUocyZpICXnBZlfY7yiQo41FOiyUZ0l?=
 =?us-ascii?Q?Y34p3PLTZwjumYgVOxTu0T+VZ/T2KBgr+23qiaPNoFzAhKLv1I5ioOtvArQL?=
 =?us-ascii?Q?YxwggMq7NXkV0svyhCVuqTD5JYG1cFz6m6VJruFQyP/AO4ABCPDxHlje+lFK?=
 =?us-ascii?Q?e7L/qVDsvC3ltTv3ljhkiwC8bJ/qjm19Dj7TH/QWmf8lASFFQz5HQ8yiNTJY?=
 =?us-ascii?Q?qCRCEh0FSd8WGnHWokllaxbLjj+EH7RSRazJWXc3mA/iEpslxyYyYD/Y9jdY?=
 =?us-ascii?Q?vAt1ksdgomG0E5z1E7oD0YdJ0Pm90xPxGe1BFm4alq5hFBAt6CtFpInPtDCA?=
 =?us-ascii?Q?BolPQOB75JJeI5tbCjOSdNzKdWx1QuuiIeY/hU7DxJ41z76TrCud5KrhU1wx?=
 =?us-ascii?Q?RhFCvlHPOOr56jYck4+vKdEfKIvgGFNrS4eLG5I5jOfp4YY+2FrIroNk9/NY?=
 =?us-ascii?Q?YHadXfxJaItB2raxBYblE9BOGt9MRRZx0sgy/dHEUzN9A5wBowzaRsM89+QO?=
 =?us-ascii?Q?U9cwSv4gL5kSFsF4tx1skj+7aedDDCve+ggftM8+7+WV6puIU7bedffDONmO?=
 =?us-ascii?Q?4WjeQxOoyp4mvYWq44v2Ms0auU081fpyIPzwPGNkTF1+6b9IKslUqnrIRkZc?=
 =?us-ascii?Q?lVHH7OhwYGpoF026iH9JLNs+xJs7p9obmxWgfE+3B5FCtguwtX+EwQbjH9Va?=
 =?us-ascii?Q?lSLEFn99f4BCbDcrJtOf2T9aZ+kAuN9o8HPBpaAZPj8GaBw6LtOnq2NaUFat?=
 =?us-ascii?Q?81smwDOVLX/rZf3XWxsSpbbeviARRA+WDd96sPuvSjdWPD3NP7lrOA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?psJWlvjLPRZC7l3ngIDVahHI+qIcAluLJp6pHfZv/FR2bRz1W5CpsPWGQDY9?=
 =?us-ascii?Q?gyfxHhsIR2sDL+s1iEVH+4vnIYYyt7VGCeF5Z6UnyuIKmFVnD5NK1hTnuAAq?=
 =?us-ascii?Q?68gQ2KMjtjW/euf6IOxdAU3vLAyfPl5rRnDdm49cwOwAYiTvOBgkWoR1eAYv?=
 =?us-ascii?Q?x3azp8E3JP/ItZMyymP9Y+tXAxH7jHp9DsiX1gzOyC5tGDfhsSbq5criiHW5?=
 =?us-ascii?Q?7DWhBqAIBOOR2Pq2vxb2NZYI2q3zbroFTLOZNEnV7QWQYgeOeGaGVwNMyVcJ?=
 =?us-ascii?Q?aYGzBPfmDldgINC4Q6QbBe+3+UrPIH/4uADdbD5Ib7lCNH1+ZLymcVu2XVmN?=
 =?us-ascii?Q?zfMHWY3BQpa09nnDHao5C1GUtWs46sW49ZQWyI774ZiAjjFupMyLP4iya8kK?=
 =?us-ascii?Q?LwMhhymyT9a9jSRTD2dvJrABHl5fJiZUO+iK/Nvz0tpEFk9K9MUzLOcVu36u?=
 =?us-ascii?Q?7o3Pr4y3YQvyQ3ANsGbKxpYkOSEF5PGew/Tv3/od5Xvlaur8xoPKgoBmwy4e?=
 =?us-ascii?Q?PWE84dn1FeZjJXuBqJDI8t71l0KogW4gDs7JTZ8/sVfDzgP1gpawwPhRvA3N?=
 =?us-ascii?Q?yUEoZM9lv/hlZI3dk05+AJ9acnvkUFmYGnjod75FpvQL/XgM1no2ULVsBKuY?=
 =?us-ascii?Q?s/Pr8uqXXUTdNv9TCvOIdhSHJfrjdoSLm9BTrldtTi9IUQ1IiZAntuT9AB+Q?=
 =?us-ascii?Q?HFDrMkpoWwfylDrPhk11p5DtV6stSehomkzTUH4FBttCjfGoKhdxDy/HLQHA?=
 =?us-ascii?Q?6kSzT70K9URfuly1b9zPPB71gbgmPRluxVLot6dpx13JwNIG14/82LCg/vwO?=
 =?us-ascii?Q?9d8pcV76GQGF4i8MI1bnBfcZ1/uV7WHyNjDNaeNaNCvLo16ZNZBQfDxRUQYh?=
 =?us-ascii?Q?2haNqbDrcxutyNjwkkkYpy5XQ9wQmMu4tfJvtZqfxC2DhN1CvkzXKKTWPW/0?=
 =?us-ascii?Q?gmVtZ+NSzN6q5Pln8LraVth0G57EZ/jELCFFlX0ZKEXyvvW0b7YEboAtss+b?=
 =?us-ascii?Q?MgA/zJYRAtVllbVGrCWdGS1aKZ5lytlz91zkXKafvRHMm4PvxgDU3kbV/4xx?=
 =?us-ascii?Q?m2TVccCE9kTbyEYTPndeVd5mDfWKzwxfFXdzgmzyc2sEaxY4e1zAQxEDGpGF?=
 =?us-ascii?Q?qGvZVUmWYbSkJlr7Furi4PqAH/OukfdDNbeqMnOwnN8KSz5devAwPydkZsco?=
 =?us-ascii?Q?1QkRQ56r2692O7SbssiU/PRrz6JMHTf1ROxU7bZDiTEmJHeRWTW9V16VwvRI?=
 =?us-ascii?Q?J5jvsE/tvVmdTM/6SUEa2jaR8J06dyWiGDQeYziw/5oDRi5uFCkOXUx1ggde?=
 =?us-ascii?Q?0I8nvfaI7C7ai9Wdf50rgvILVciaYflr6QZbz8EWRPKzRll1OLInias2held?=
 =?us-ascii?Q?PGCfSPYiGUmxtVVFwtfVnPBsg1pZ0cj5yF5QRKeeqB3Ln4qOMhlhjv07+cvo?=
 =?us-ascii?Q?Q/mg8T3THqgnunIdB7S2ThQqcfxgpr3GDmtK3Ysi+wIqdWqvwqnVY1nXs1o0?=
 =?us-ascii?Q?L6EY7TSCSbpEJr3w6XbNn1QvDCUqpduJMNt3vvom4FEK4G8GSZbVN8g/Wjg9?=
 =?us-ascii?Q?PL09MCTeq5xNmST9Q1/Gl1UCat4PZeGoHEENoBSYVQuvWcld4CBzmujIdEAv?=
 =?us-ascii?Q?nQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f7fbb2d-3335-4c7c-f9c7-08de38c38a64
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2025 14:42:42.6200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wii7Apb38YPlQxmdLxuGV6n54KQCJi3TMkg192MrK7jCxu/9Qshla9ltxPL7NL3qG6NwnIvTOD6h07+qzyFD/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7425
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: A8D4D140013
X-Stat-Signature: xur647gtj8yqup7o3f3ndiq83ndcr4xm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765464168-936824
X-HE-Meta: U2FsdGVkX18AidJAoFXTr62o2sxSknpP1wGWkqTsjxpanAAbfL1LaCRHMZn9geJeYeWHZFLqFi2x5M44U6GWkp5NoC2oEl8mk9K8cYhn6y6RaUErlT5/DAhJXekG37t4yKM3yD+JTK22eV9bECVoUcxyeQm3ig83yd9vZPBQWYnNxllsw5v/l9Y2ILo4zH1/XnUGgmZu8SS8OP6N9ERWU4+nqIhTXsbvl3+7pVb5CQywwzPKY7NOKmWvZfy5ruVnMMQ1DxDYYeApRw5lYzBOg79abpO+CyW/EXO4N+/N7BtC/IwmXzwfXlqWD4pIWrHuNw4FknU0Tfl17/Gren1ThN2eYvIxrfEstJFUSWyvDw+Q0QA8sPpwsIaI4GYH4d9FkA3Dhg+aoWCLgBNQmfPDp0Cu7UD3Lfz6sbFYYxwoRtSp7cABVsgouuDclzegq7sgL6v10ex7aBnwJi0EvwEPYad4fiwApzqwQ2/IyS3B7im8AfRQkd9zJEa3rtCavwag9InO2JhpWrwO0urikVNakm3ef/eLWf8xecggIsobIWAQtLZuPi28bw4BLKPUB80aA+aggzFqf45r3rZ8CGtBdkoxWdRZ+P9JGquuXvQ1rXHnE+BJDqMg+3OfPKXdcf4QiJnRE3miUaxCm7YTXZUucJF+Z37Cm105NPSuJ0i3EleB/8aExs+wsnyeXcbg/xjbjXIksusOSxRia+/PXrw/XIbrfDv7+Iqntk73Xu0GcwSRAqYOczdyBsQhJyg0FW4u97C6Azi0lgheAKfIcp8teaCYNbIJG9RSEV5Ux83sbwmGGmQXQUvdt8Y00iGXDAa/WbXgIY/o+0I6f2uawvQ97fb6y6obFjWe6yvayiXMHdN7DU5Te4p3m5lz4jyCgOFAzSniEjd4PjBSXx3WKvI+z8NyTMU0+lNglR4nHR4ckXaL+bLvEPrKm2XQuQPYoVxWsfUtvW5AahYxf085IGC
 0/nBJk7k
 10JaMbLY1DUqu6qZrHGidnZOzF+TD2uX/xi8Jy3lDIcRVfFs4P1pI2nfsVBJROqTNB5czgWTP3nzFby7xe0IAfTf+wCYcAk4945rIkaCxIZ0Vz7cV02lkePX5L+oGWhbJOt3Ou/GN/Sq2FxGgfzHyJMJo8FWU4U6FmOn5Xlnqx1hcUFs1+9NbBwWW36+Tn0Q9YjberFl4UcNToAPAPwk/G4QLKNczwq3MNs3l8Lu2KW7ei6AG9GpzRwUEAV7/m8IXflX/jF4RUOktoTS8DRcf9yl26bimy18VKDqFVw9n0K6gtk93FssNBsc6dLmu01l87dxztecTtR63D7egMBpkaB17CxzgTzJ39cQHwgdM78w0WzK7HSH4sLIDm5YzlWEVrjOebtBv3YI0njda5CfCAaQZZ7xbCB5bcWNcPod7ns4tx5QuYXd8h+hN0MpO9natmwuqeFBd2PmwLajg85Di3RgF/NUHf+lhzHZgU57QtL7yZm6fWIfgChsNbRc9bsKz2i+jmIxcZcCV18bhixIUHeJGMAchaxjK14kazoPWMgyaarqG14ASzQzlqMHlw2oWCt6IUTKH9BvHMQUkhcfM2fMzdLA93LDt6oJNK6Qexye8QMwMrZiQPm9fE2iDi2UTQt4LQM7yOOjTLC0Sl9GpNyuCKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "WARNING:at_drivers/base/core.c:#device_release" =
on:

commit: fe9d31fd1ab6cb53e45d9d6b0bb7a62d8365fe2b ("mm/hmm/test: fix error h=
andling in dmirror_device_init")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[test failed on linus/master      9d588a1140b9ae211581a7a154d0b806d8cd8238]
[test failed on linux-next/master c75caf76ed86bbc15a72808f48f8df1608a0886c]

in testcase: kernel-selftests
version: kernel-selftests-x86_64-67a454e6b1c6-1_20251207
with following parameters:

	group: mm
	sc_nr_hugepages: 2



config: x86_64-rhel-9.4-kselftests
compiler: gcc-14
test machine: 36 threads 1 sockets Intel(R) Core(TM) i9-9980XE CPU @ 3.00GH=
z (Skylake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new versio=
n of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202512112128.e5e07e77-lkp@intel.co=
m


kern  :warn  : [  317.654165] [  T37035] ------------[ cut here ]----------=
--
kern  :err   : [  317.654650] [  T37035] Device 'hmm_dmirror0' does not hav=
e a release() function, it is broken and must be fixed. See Documentation/c=
ore-api/kobject.rst.
user  :notice: [  317.655347] [    T618] # # # hmm-tests.c:511:anon_write_p=
rot:Expected ptr[i] (946234217) =3D=3D 0 (0)

kern  :warn  : [  317.655778] [  T37035] WARNING: CPU: 0 PID: 37035 at driv=
ers/base/core.c:2567 device_release (drivers/base/core.c:2567 (discriminato=
r 2))
kern  :warn  : [  317.657485] [  T37035] Modules linked in: test_hmm(-) net=
console intel_rapl_msr intel_rapl_common intel_uncore_frequency intel_uncor=
e_frequency_common btrfs blake2b_generic xor zstd_compress raid6_pq skx_eda=
c_common nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp sd_mod corete=
mp sg ghash_clmulni_intel snd_hda_codec_alc882 snd_hda_codec_atihdmi rapl s=
nd_hda_codec_realtek_lib intel_cstate snd_hda_codec_generic snd_hda_codec_h=
dmi amdgpu amdxcp drm_panel_backlight_quirks gpu_sched drm_buddy drm_ttm_he=
lper snd_soc_avs ttm drm_exec drm_suballoc_helper snd_soc_hda_codec snd_hda=
_intel snd_hda_ext_core drm_display_helper cec snd_hda_codec drm_client_lib=
 snd_soc_core snd_hda_core drm_kms_helper snd_intel_dspcfg snd_intel_sdw_ac=
pi snd_compress ahci video snd_hwdep wmi_bmof mxm_wmi intel_wmi_thunderbolt=
 snd_pcm crc16 intel_uncore nvme libahci snd_timer wdat_wdt pcspkr snd i2c_=
i801 mei_me nvme_core libata ioatdma i2c_smbus soundcore mei dca wmi binfmt=
_misc fuse drm nfnetlink sch_fq_codel
user  :notice: [  317.657659] [    T618] # # # hmm-tests.c:511:anon_write_p=
rot:Expected ptr[i] (1601004915) =3D=3D 0 (0)
kern  :warn  : [  317.664626] [  T37035] CPU: 0 UID: 0 PID: 37035 Comm: mod=
probe Tainted: G S      W           6.18.0-rc5-00287-gfe9d31fd1ab6 #1 PREEM=
PT(voluntary)
kern  :warn  : [  317.664633] [  T37035] Tainted: [S]=3DCPU_OUT_OF_SPEC, [W=
]=3DWARN

kern  :warn  : [  317.665386] [  T37035] Hardware name: Gigabyte Technology=
 Co., Ltd. X299 UD4 Pro/X299 UD4 Pro-CF, BIOS F8a 04/27/2021
kern  :warn  : [  317.665388] [  T37035] RIP: 0010:device_release (drivers/=
base/core.c:2567 (discriminator 2))
user  :notice: [  317.667615] [    T618] # # # hmm-tests.c:511:anon_write_p=
rot:Expected ptr[i] (1835365481) =3D=3D 0 (0)
kern  :warn  : [  317.668021] [  T37035] Code: 48 8d 7b 50 48 89 fa 48 c1 e=
a 03 80 3c 02 00 0f 85 88 00 00 00 48 8b 73 50 48 85 f6 74 13 48 c7 c7 80 4=
4 6e 84 e8 27 22 72 fe <0f> 0b e9 0b ff ff ff 48 b8 00 00 00 00 00 fc ff df=
 48 89 da 48 c1
All code
=3D=3D=3D=3D=3D=3D=3D=3D
   0:	48 8d 7b 50          	lea    0x50(%rbx),%rdi
   4:	48 89 fa             	mov    %rdi,%rdx
   7:	48 c1 ea 03          	shr    $0x3,%rdx
   b:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   f:	0f 85 88 00 00 00    	jne    0x9d
  15:	48 8b 73 50          	mov    0x50(%rbx),%rsi
  19:	48 85 f6             	test   %rsi,%rsi
  1c:	74 13                	je     0x31
  1e:	48 c7 c7 80 44 6e 84 	mov    $0xffffffff846e4480,%rdi
  25:	e8 27 22 72 fe       	call   0xfffffffffe722251
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	e9 0b ff ff ff       	jmp    0xffffffffffffff3c
  31:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  38:	fc ff df=20
  3b:	48 89 da             	mov    %rbx,%rdx
  3e:	48                   	rex.W
  3f:	c1                   	.byte 0xc1

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
   0:	0f 0b                	ud2
   2:	e9 0b ff ff ff       	jmp    0xffffffffffffff12
   7:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
   e:	fc ff df=20
  11:	48 89 da             	mov    %rbx,%rdx
  14:	48                   	rex.W
  15:	c1                   	.byte 0xc1
kern  :warn  : [  317.668026] [  T37035] RSP: 0018:ffffc90002e2fb80 EFLAGS:=
 00010286


kern  :warn  : [  317.669216] [  T37035] RAX: 0000000000000000 RBX: fffffff=
fc4416c30 RCX: ffffffff81a5aee3
user  :notice: [  317.672000] [    T618] # # # hmm-tests.c:511:anon_write_p=
rot:Expected ptr[i] (1313157699) =3D=3D 0 (0)
kern  :warn  : [  317.672376] [  T37035] RDX: 0000000000000000 RSI: 0000000=
000000008 RDI: ffff88873aa31680

kern  :warn  : [  317.673101] [  T37035] RBP: ffff8881dc954c00 R08: 0000000=
000000001 R09: fffff520005c5f2a
kern  :warn  : [  317.673104] [  T37035] R10: ffffc90002e2f957 R11: 205d353=
330373354 R12: 0000000000000000
user  :notice: [  317.674900] [    T618] # # # hmm-tests.c:511:anon_write_p=
rot:Expected ptr[i] (858873683) =3D=3D 0 (0)
kern  :warn  : [  317.675266] [  T37035] R13: 0000000000000000 R14: ffff888=
257da0000 R15: 0000000000000000
kern  :warn  : [  317.675269] [  T37035] FS:  00007fa66ff48640(0000) GS:fff=
f8887b351f000(0000) knlGS:0000000000000000

kern  :warn  : [  317.676656] [  T37035] CS:  0010 DS: 0000 ES: 0000 CR0: 0=
000000080050033
kern  :warn  : [  317.678396] [  T37035] CR2: 00007fff1a350b00 CR3: 0000000=
893dfe003 CR4: 00000000003706f0
user  :notice: [  317.678579] [    T618] # # # hmm-tests.c:511:anon_write_p=
rot:Expected ptr[i] (1601004915) =3D=3D 0 (0)
kern  :warn  : [  317.679054] [  T37035] Call Trace:
kern  :warn  : [  317.679056] [  T37035]  <TASK>

kern  :warn  : [  317.679793] [  T37035]  kobject_cleanup (lib/kobject.c:69=
3)
kern  :warn  : [  317.680963] [  T37035] hmm_dmirror_exit (lib/test_hmm.c:1=
90) test_hmm
user  :notice: [  317.681254] [    T618] # # # hmm-tests.c:511:anon_write_p=
rot:Expected ptr[i] (1835365481) =3D=3D 0 (0)
kern  :warn  : [  317.681422] [  T37035]  __do_sys_delete_module+0x2fc/0x50=
0

kern  :warn  : [  317.682158] [  T37035]  ? __pfx___do_sys_delete_module+0x=
10/0x10
kern  :warn  : [  317.683446] [  T37035]  ? do_syscall_64 (include/linux/ir=
q-entry-common.h:257 include/linux/entry-common.h:212 arch/x86/entry/syscal=
l_64.c:100)
user  :notice: [  317.683833] [    T618] # # # hmm-tests.c:511:anon_write_p=
rot:Expected ptr[i] (1887007839) =3D=3D 0 (0)
kern  :warn  : [  317.683846] [  T37035]  ? do_syscall_64 (arch/x86/entry/s=
yscall_64.c:113)

kern  :warn  : [  317.684567] [  T37035]  ? do_sys_openat2 (fs/open.c:1422)
kern  :warn  : [  317.685597] [  T37035]  ? do_sys_openat2 (fs/open.c:1422)
kern  :warn  : [  317.686009] [  T37035]  ? do_syscall_64 (arch/x86/include=
/asm/irqflags.h:42 arch/x86/include/asm/irqflags.h:119 include/linux/entry-=
common.h:124 arch/x86/entry/syscall_64.c:90)
user  :notice: [  317.686129] [    T618] # # # hmm-tests.c:511:anon_write_p=
rot:Expected ptr[i] (827344229) =3D=3D 0 (0)
kern  :warn  : [  317.686389] [  T37035]  do_syscall_64 (arch/x86/entry/sys=
call_64.c:63 (discriminator 1) arch/x86/entry/syscall_64.c:94 (discriminato=
r 1))

kern  :warn  : [  317.687120] [  T37035]  ? fput_close_sync (fs/file_table.=
c:571)
kern  :warn  : [  317.688153] [  T37035]  ? fput_close_sync (fs/file_table.=
c:571)
kern  :warn  : [  317.688565] [  T37035]  ? ksys_read (fs/read_write.c:715)
user  :notice: [  317.688677] [    T618] # # # hmm-tests.c:511:anon_write_p=
rot:Expected ptr[i] (1953063476) =3D=3D 0 (0)
kern  :warn  : [  317.688916] [  T37035]  ? __pfx_ksys_read (fs/read_write.=
c:705)

kern  :warn  : [  317.689651] [  T37035]  ? __pfx___x64_sys_openat (fs/open=
.c:1463)
kern  :warn  : [  317.690749] [  T37035]  ? trace_hardirqs_on_prepare (incl=
ude/trace/events/preemptirq.h:40 (discriminator 2) kernel/trace/trace_preem=
ptirq.c:62 (discriminator 2) kernel/trace/trace_preemptirq.c:59 (discrimina=
tor 2))
user  :notice: [  317.691227] [    T618] # # # hmm-tests.c:511:anon_write_p=
rot:Expected ptr[i] (1601200493) =3D=3D 0 (0)
kern  :warn  : [  317.691231] [  T37035]  ? do_syscall_64 (include/linux/ir=
q-entry-common.h:257 include/linux/entry-common.h:212 arch/x86/entry/syscal=
l_64.c:100)

kern  :warn  : [  317.691953] [  T37035]  ? trace_hardirqs_on_prepare (incl=
ude/trace/events/preemptirq.h:40 (discriminator 2) kernel/trace/trace_preem=
ptirq.c:62 (discriminator 2) kernel/trace/trace_preemptirq.c:59 (discrimina=
tor 2))
kern  :warn  : [  317.691957] [  T37035]  ? do_syscall_64 (arch/x86/entry/s=
yscall_64.c:113)
kern  :warn  : [  317.693460] [  T37035]  ? trace_hardirqs_on_prepare (incl=
ude/trace/events/preemptirq.h:40 (discriminator 2) kernel/trace/trace_preem=
ptirq.c:62 (discriminator 2) kernel/trace/trace_preemptirq.c:59 (discrimina=
tor 2))
user  :notice: [  317.693514] [    T618] # # # hmm-tests.c:511:anon_write_p=
rot:Expected ptr[i] (1953718895) =3D=3D 0 (0)
kern  :warn  : [  317.693924] [  T37035]  ? do_syscall_64 (arch/x86/entry/s=
yscall_64.c:113)

kern  :warn  : [  317.694652] [  T37035]  ? rcu_read_unlock (include/linux/=
rcupdate.h:895 (discriminator 1))
kern  :warn  : [  317.695684] [  T37035]  ? lock_release (include/trace/eve=
nts/lock.h:69 (discriminator 2) kernel/locking/lockdep.c:5879 (discriminato=
r 2))
kern  :warn  : [  317.696080] [  T37035]  ? handle_mm_fault (mm/memory.c:64=
13 mm/memory.c:6566)
user  :notice: [  317.696189] [    T618] # # # hmm-tests.c:511:anon_write_p=
rot:Expected ptr[i] (7037793) =3D=3D 0 (0)
kern  :warn  : [  317.696481] [  T37035]  ? __put_unused_fd (arch/x86/inclu=
de/asm/bitops.h:222 arch/x86/include/asm/bitops.h:233 include/asm-generic/b=
itops/instrumented-non-atomic.h:142 fs/file.c:346 fs/file.c:629)

kern  :warn  : [  317.697199] [  T37035]  ? exc_page_fault (arch/x86/includ=
e/asm/irqflags.h:26 arch/x86/include/asm/irqflags.h:109 arch/x86/include/as=
m/irqflags.h:151 arch/x86/mm/fault.c:1484 arch/x86/mm/fault.c:1532)
kern  :warn  : [  317.698247] [  T37035]  ? lock_release (include/trace/eve=
nts/lock.h:69 (discriminator 2) kernel/locking/lockdep.c:5879 (discriminato=
r 2))
kern  :warn  : [  317.698638] [  T37035]  ? do_user_addr_fault (arch/x86/in=
clude/asm/atomic.h:93 (discriminator 4) include/linux/atomic/atomic-arch-fa=
llback.h:949 (discriminator 4) include/linux/atomic/atomic-instrumented.h:4=
01 (discriminator 4) include/linux/refcount.h:389 (discriminator 4) include=
/linux/refcount.h:432 (discriminator 4) include/linux/mmap_lock.h:143 (disc=
riminator 4) include/linux/mmap_lock.h:182 (discriminator 4) arch/x86/mm/fa=
ult.c:1338 (discriminator 4))
user  :notice: [  317.698763] [    T618] # # # hmm-tests.c:511:anon_write_p=
rot:Expected ptr[i] (825383519) =3D=3D 0 (0)
kern  :warn  : [  317.699066] [  T37035]  ? irqentry_exit_to_user_mode (inc=
lude/linux/irq-entry-common.h:257 kernel/entry/common.c:75)

kern  :warn  : [  317.699783] [  T37035]  ? trace_hardirqs_on_prepare (incl=
ude/trace/events/preemptirq.h:40 (discriminator 2) kernel/trace/trace_preem=
ptirq.c:62 (discriminator 2) kernel/trace/trace_preemptirq.c:59 (discrimina=
tor 2))
kern  :warn  : [  317.701011] [  T37035]  entry_SYSCALL_64_after_hwframe (a=
rch/x86/entry/entry_64.S:130)
user  :notice: [  317.701460] [    T618] # # # hmm-tests.c:511:anon_write_p=
rot:Expected ptr[i] (1601070439) =3D=3D 0 (0)
kern  :warn  : [  317.701488] [  T37035] RIP: 0033:0x7fa670144417

kern  :warn  : [  317.702225] [  T37035] Code: 73 01 c3 48 8b 0d e1 59 0d 0=
0 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 0=
0 b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b1 59 0d 00 f7=
 d8 64 89 01 48
All code
=3D=3D=3D=3D=3D=3D=3D=3D
   0:	73 01                	jae    0x3
   2:	c3                   	ret
   3:	48 8b 0d e1 59 0d 00 	mov    0xd59e1(%rip),%rcx        # 0xd59eb
   a:	f7 d8                	neg    %eax
   c:	64 89 01             	mov    %eax,%fs:(%rcx)
   f:	48 83 c8 ff          	or     $0xffffffffffffffff,%rax
  13:	c3                   	ret
  14:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  1b:	00 00 00=20
  1e:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  23:	b8 b0 00 00 00       	mov    $0xb0,%eax
  28:	0f 05                	syscall
  2a:*	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax		<-- trapping =
instruction
  30:	73 01                	jae    0x33
  32:	c3                   	ret
  33:	48 8b 0d b1 59 0d 00 	mov    0xd59b1(%rip),%rcx        # 0xd59eb
  3a:	f7 d8                	neg    %eax
  3c:	64 89 01             	mov    %eax,%fs:(%rcx)
  3f:	48                   	rex.W

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
   0:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax
   6:	73 01                	jae    0x9
   8:	c3                   	ret
   9:	48 8b 0d b1 59 0d 00 	mov    0xd59b1(%rip),%rcx        # 0xd59c1
  10:	f7 d8                	neg    %eax
  12:	64 89 01             	mov    %eax,%fs:(%rcx)
  15:	48                   	rex.W


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251211/202512112128.e5e07e77-lkp@=
intel.com



--=20
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


