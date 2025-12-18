Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03167D68BD0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 03:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E64A6B0089; Wed, 17 Dec 2025 22:04:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BA896B008A; Wed, 17 Dec 2025 22:04:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4931B6B008C; Wed, 17 Dec 2025 22:04:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 346CB6B0089
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:04:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BFC4960E68
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:04:37 +0000 (UTC)
X-FDA: 84231098994.22.FF16EA6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf21.hostedemail.com (Postfix) with ESMTP id B88D61C0010
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:04:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Ztq/Ai+l";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766027074; a=rsa-sha256;
	cv=pass;
	b=GXU2kX+m0i2teLKGI/E/guUDC22z3GTY/JOip4P2mOKLxH2vPaw8Sk3Evsmjg8ayp616k/
	Rthiq649LQkg95azejJgFD07Pzme2eIt6mcR1nopnK8ppWkGaEuippwpodP50zIQELwsZS
	hccyiNI0JxWz5VT7HMM5HQjw1lwqmQg=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Ztq/Ai+l";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766027074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v40PkKajrUAuKjPQu1CHBMdwYSnj1GhixkxsVpzmWpU=;
	b=sZo0iJXtOkHGJN/25RKgsgeJxk0yKpao/8VBR2w9So5iVIT3VSXGyD/BeVvMbSeZf8LXlR
	ItHR4Z9E6C+DyzZCf8zDvHlWyKiAqnWHMfFqnEM8EdHPEihF5yXdMEmf1ZQ6gP6OeIUrmw
	5TwjQ0pynpRsLpTF3FDCtADD4Xh5m00=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766027074; x=1797563074;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=81OgxHfiXqilppRrCrH8QllNI0azmXN4ED6s2ziNJhc=;
  b=Ztq/Ai+lP1EHxP2OunBS3oxAWHwijOilO3Q2XVB9R2hI/6Akw7KSvg2m
   s/eYuruKTyjCCFY2XWjVUdXlLM07TXgYzAq+bJ17WASlAadxrKS5ocMI3
   lI96iS2CozUAJ41VotseCO/04CKRyaI2zJRDDbHs3DMtr3+2A7DzqI5hV
   AAy5Dnhti6KsUmDyfbdu3NVxnIF91pyx4RB3FWvhvrhcRRXUdZneylFg5
   XKgJmC45SvYWu8VGWtHpxV/GF7uVHLQ5wPB4scLqhfyelm9EtSUwFeLSp
   6KEhY9+FC7KIuXKxN48WYowqbB9Udy2jGvBtEyUHSGAHnh9VXnoEbc6a7
   Q==;
X-CSE-ConnectionGUID: TOK3MSZFQCiazSmbhBppPQ==
X-CSE-MsgGUID: nro9UCBKSlCd4dG+vU99tw==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="90635428"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="90635428"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 19:04:33 -0800
X-CSE-ConnectionGUID: TBoXZcbpRuGZ7cA0Afmp/A==
X-CSE-MsgGUID: qUh6v1URSyiZ04nX70MEpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="197726990"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 19:04:33 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 17 Dec 2025 19:04:31 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 17 Dec 2025 19:04:31 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.14) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 17 Dec 2025 19:04:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oK1BJpvz0mMjuRvjqvjYokvAROfyWs9oEXp3lE9rVFlyX2ouhpzMJ96pvGm7DacJ9ylrFXFrzQS7ubAowSCPED2b2otckB1T4EKWBof3QTGabMOH9TrYAWnqbncPgf2r1sOPn13tOECNOimS5ysZ+H4k+NTdFnuKJmu6V/Uzl9HS70NcB8WFFzOQSY4nHomXE5DJxZG9I/mlRqiceVBlWsWwfP5CDRRjPisth5bTaJSOuxP9OQ/y5tNR/QgT2inPsgTqX5tdAlcIbAgxs/vurU+PLrmGKABb/GEnXT27euBtuGdyLLYWRb33q0k+wGYXoPhhTsdHfQFnVGsj1Lt5Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v40PkKajrUAuKjPQu1CHBMdwYSnj1GhixkxsVpzmWpU=;
 b=RerUidUC314Mv6ckgow85mG2TqrbKP3KL97B55PBUrYgOB5tFxa8NVPodYyfGbe4Q5Hn0TeB/iuwNUsQ+iiC8jf3gaXLOK8z8vt95xmwOMreQXRljUruIZHbB9Ovzgq+zAOKuRdzGnjByg5qDERmYudAwFv8/SO/TukgdGvKGb1Ly32AeU2mIagwT4II+O46Gk3Qg8pmdKh+5v6Zr3JFUo2C4ehbTYyYJnvDiV0TQjKXCZHQqvwzEVpQaH1LL72GGWuTWAwg0T8aMKUgjujuKHUrA3OjnPTrSxYsWfyOYY1YfE6IFmpRfReL59sXtncuf+x9ULoQghjD3VS/be383g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8768.namprd11.prod.outlook.com (2603:10b6:408:211::19)
 by PH8PR11MB8106.namprd11.prod.outlook.com (2603:10b6:510:255::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Thu, 18 Dec
 2025 03:04:29 +0000
Received: from LV3PR11MB8768.namprd11.prod.outlook.com
 ([fe80::154a:b33e:71c0:2308]) by LV3PR11MB8768.namprd11.prod.outlook.com
 ([fe80::154a:b33e:71c0:2308%6]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 03:04:29 +0000
From: "Kumar, Kaushlendra" <kaushlendra.kumar@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH] tools/mm/thp_swap_allocator_test: Fix small folio
 alignment
Thread-Topic: [PATCH] tools/mm/thp_swap_allocator_test: Fix small folio
 alignment
Thread-Index: AQHcbjx72Xt8Ic0toUmhtfNm87qmMLUmt8TQ
Date: Thu, 18 Dec 2025 03:04:29 +0000
Message-ID: <LV3PR11MB8768A0924C9336D1B32FD079F5A8A@LV3PR11MB8768.namprd11.prod.outlook.com>
References: <20251209031745.2723120-1-kaushlendra.kumar@intel.com>
 <20251215193123.1cd0bee80853599220a82ef1@linux-foundation.org>
In-Reply-To: <20251215193123.1cd0bee80853599220a82ef1@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR11MB8768:EE_|PH8PR11MB8106:EE_
x-ms-office365-filtering-correlation-id: fa11de4a-fd1d-4f34-3bc1-08de3de228fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?XCTdK8HUP91XcMSZZJOsXvmMaizFNo3kImMpcRDyZFE1wO5jnEqg43NzSQ0U?=
 =?us-ascii?Q?9Ynap+XM9GPVqyruJeYKPoSfNXdTorqcCK8fR94JnNHmOp9i+5L5yxCUvJwr?=
 =?us-ascii?Q?8tUAozkExejV0dvIwpviJbpcH9dsFd4XpElyYp9okt8EnMToX/dhzAvY7jrI?=
 =?us-ascii?Q?jVsRjmBI/eN6l22Dn258KG8eSV8p0Yvc1mtXVdblzg78rpjjC/lh+5SZuZsm?=
 =?us-ascii?Q?iuIlIgeyZuk+jC1rhTYkWWY85Z0ORZq9sklQHMXW5paa49xe6CYDtpeytkcG?=
 =?us-ascii?Q?Dnp+EW773QfBu4m8Wd+ClU0+/vJ+BwYsKU6huj6NZYwreWJ+Rs2uhaIO9RNZ?=
 =?us-ascii?Q?D8jSSMBhEbgmQnKUe2cv0U2S5k0oOQAYqHVX6pGqOVa8MuQGE8IEFnp5+liO?=
 =?us-ascii?Q?MMYgT+wTbHI55VCv26RAxxbrZ43RAv0JRwQMnjxAawv/gwf8z9UpnyTRdV5G?=
 =?us-ascii?Q?lfk5YelVZTZ6VP24ff0g7XsqW+QtMRd0bkaNFCAUcvZhN2f5VOWXSNYARR+w?=
 =?us-ascii?Q?Te6nHFB34VD3utO2w8iaZsrGUTwB6NYcoAAwW7QRrunPfKAbDOMWU/XClml0?=
 =?us-ascii?Q?EvLvkekeqqoo6jvOpcV2mOH2kFuYe2WoA+J1ztdIRiSNQoI4BrS74n+AI1AM?=
 =?us-ascii?Q?T2ccvBSQsAJzDLBT3b3lY3vfow0/Psbw3OVJv3cNeD3pJQPd3uLKJcpYOFzX?=
 =?us-ascii?Q?jExxD0OphEA0of4d9jKGJqz7QknbIw7c/SWEjDK7Nee5gONiupoYkaFFRRxN?=
 =?us-ascii?Q?g/4+N7U2C09BfEYYa2TnU/NckqBjXPGI9TCBoMU3HyDxDcD2ilNGjeNMGLSH?=
 =?us-ascii?Q?QPw7t3t48gP6PYEVGQiJTKN14PBR0SaA9+1NGnEakCqK/y4C1KT0fy4Ke0QZ?=
 =?us-ascii?Q?5bss3yTnzeLx0l0vO4a9lmEtQ8z05qC5Lek/1BeTM1zxMdhn53DytCGzEk/q?=
 =?us-ascii?Q?lA21Aqb1aMTdWSNPAJGxfEYA6nPG2F+vvJEhl1PAvO/qqzkK+VR2yLR1JKaj?=
 =?us-ascii?Q?Qk+MrkC9hwy5Effcu99jY45/IlBSTnwtiyx1cns79UrrZOhI6Pz6hY6Kszxp?=
 =?us-ascii?Q?jO6whVoICmGMnQ/91ItP6CUfdhPbO2Ea6G1NF4cnN6LyRTTMQjfIGtoJEd26?=
 =?us-ascii?Q?yXRFA8ThuxiOge54yMXvliJBr2OWbmnO17iVsaBKPRPwcsqAn6QdV7qGhfN5?=
 =?us-ascii?Q?5povr7b3ncnn1fMf69pUG6AhamJ3QzXQV7JKWkkN5eL6uqX1NLVTSv05BRrL?=
 =?us-ascii?Q?8gyO5ihx4F4BgeP9OrXYiv1Emehl7TzK9fil4EwvmGJMDKkFd3xrzjSvxusk?=
 =?us-ascii?Q?Yngc4FmAl/TiSBZDQp3NVq7E25eYQ9EiGp1suDvDOE+sb325hnCJWB5XqgAE?=
 =?us-ascii?Q?0vnptkRDF2kkNOVMksHnZYUnYvtgu0IWSuyiG1MnHH5PcHchAQ8QVqdNDGPX?=
 =?us-ascii?Q?QXwqn1NFuukTOoXCNX1PnqGYaLvrCLIj/qIvBxw8Co5buLuACmTalbIIN4pO?=
 =?us-ascii?Q?zMj7gCES93+zjN79yhqY76hdpm6cQpBCMeQh?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8768.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WcvaQlG6U1BhNO1YaTG5oj0wjEjEPZOfVmKk2T8/LY8EaVVWa0pVHBFme/EO?=
 =?us-ascii?Q?gmiTwR4OMmv23Y9THnXBx/g/iIamYTWLamFK9xOYJA3MQ3zQ79OqiWX1hCPQ?=
 =?us-ascii?Q?eMLo3129uJfNHTKMEzFSM4e53EDKDJHq7iR9vHXV9OTLXICD4g8mk6WE3dit?=
 =?us-ascii?Q?1bpllPNUl1Z5kkA+ogKV2ITeBx6c6vuzRSGRy7879vdBZlCirUJHZEubQ7xJ?=
 =?us-ascii?Q?68IVSDlt7MzJt6N/4A48w6dMDnGvw/TfDrH9zSSEopqsvoCQuCwUVpd+B+9B?=
 =?us-ascii?Q?RC8HvgUSlYVVhyBVqRqRBNbVYeN+IhGbGCPMySm++aG/9/rccL8TL8+XqQ3p?=
 =?us-ascii?Q?WSRRzRW21xgXMMKi2wlsrmPP+TpgjHzV8rXKqWmnSdlwtr2G+rM+f/3RrYI5?=
 =?us-ascii?Q?MQd/hT7SCNcMviAWLVWA2QExl5XDi8KoPx2+NkiTcUs4GBMZ+3ZZr5FgiIqs?=
 =?us-ascii?Q?+lJ1Xk0RGMkcE+WHfCNo686IHRr9MCQ+qW5DnrvIouG+kubBhkZM7soA/ap/?=
 =?us-ascii?Q?dgCyAIT1+ocVlWmbxJWjDTf9IHEAoO9MbAxDePjx1H4LJ/ubq41qteRBb4mC?=
 =?us-ascii?Q?WFEkMbct5zRS4odRF96cycOv7n0nEpsWThr4BZz+Jltxs5q006I6Ku/aFXhW?=
 =?us-ascii?Q?vPGRSjQNpv5oaAQCakEk145+YfIMr0/OzpXthOaiZ3cz+ECEIkZqrAlDNB/O?=
 =?us-ascii?Q?hwwaCYER+kNzega87+YAU18OFb4i69wRzwAyHLw7fzn56F9foSOCLx+bewAf?=
 =?us-ascii?Q?duAncbmuQedWfvmYyQwcrNqKdIFTwXh5Y3l3gtslYDypvFIk8aebqo8T7RCk?=
 =?us-ascii?Q?NOknXFp8J0mnFI4J3MGL5i/R3K9Y8goSvu+iUoQQkUIxNa6vI0/crw9nV3Il?=
 =?us-ascii?Q?r+fD+3seYP77VsGoABNHwYfkGkjESc5oO47Q48oxaXVSvybyAmRmzPhgzhgD?=
 =?us-ascii?Q?clTu7UEAGBa3ObV8FWL14jtMVZdgiYN4tq2qaQXWtnO1oW5IDQAWaBal8mPu?=
 =?us-ascii?Q?DqelK3VXgWHAtER2N67YTQKA3PpvZC43kJhwnATeZI5xviM0yiDMUUY2a3g/?=
 =?us-ascii?Q?bHs16pUmjWNKUtcxf0Mu6m7XaJdnaOIalar7VIEgLF6UzOefcDsWUbSscDfo?=
 =?us-ascii?Q?AK+X0mX6bxOmRGgim58Bpg94zqHZBUkFK4yvXW9ImWkiG9b9qfw9PwyYGGu/?=
 =?us-ascii?Q?FUrQGu5hJpY+/85cooWiX5qTnMpbE+t2bD1naOyjHi+Uq4b2TvazNkJNCfVE?=
 =?us-ascii?Q?62w2NNwFXKXpltZwk8Z7VkvDZiBZZN6EhfygZ/oZQTFTDDJgkhtthhh5WzQu?=
 =?us-ascii?Q?RlY1lu8qEq/R5PTmV6vApy6LqvEZE5knurlOOhUyEwZ2mqvQNesi+G+40GjF?=
 =?us-ascii?Q?f63TfjscFlARopy7b/BPcVi2NKPKx8kNOkxqppIGCo68DDSQK2gf5Vz4TfiF?=
 =?us-ascii?Q?4QkJSEjiLknTFJIeaghRF1/wxW9v752oHeCI7dA36XsLU8vVoL5r6AytNPUY?=
 =?us-ascii?Q?u5cJCTMMs6fBoJZVB5T3mO9ZzcmQOf/bR1fL29Wipwh8XzUUkzICQP4C9taG?=
 =?us-ascii?Q?uptKkzB1WOZ80g3pJOrAVLDb/Vk+wjzrhuxe1wgVexwROGXrjQjLTJl5dgsV?=
 =?us-ascii?Q?2A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8768.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa11de4a-fd1d-4f34-3bc1-08de3de228fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2025 03:04:29.2356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1+NS2fSQ7I/BDpR/APOUXQmwaA+lDckXycBZ1Ah846HW6dkvWIXgH5iE+gaDPHigZ87jne7+UpZYqEXgv6s6jOLn7VEqBFPAN46wOZoyLAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8106
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B88D61C0010
X-Stat-Signature: qymc5ftw46nenqmnuo894i5ze36g77cq
X-Rspam-User: 
X-HE-Tag: 1766027073-819533
X-HE-Meta: U2FsdGVkX1+dYcTyv9LdTlQulTvRr6p7/XL5hvF8jxikjgJRYqul3Fj8Gh6CFtOJ8Bac1cc9vzCVrFZhWz67PInI4hez6EyP6OM9qzF34nhXFsJJdkOmuY2tocd9lJQqwuqb7yasjID9Euc4nKW03mmRASVcyhzpssE0xiPqQS3KogpbR3P27C1rQoG/y1avGsP/vO4AceTMwHitbhbWD/KtuLMarsxP1xogmVWVIasi+n9JnXNXS3JBWSD6vJQvK0PidLu25Cu1RGfEup9+eg1jDY9illk/dYe6lejB5Tba8qgbm4wi4W10h8lGJGN2bUqfOqEQ6fzyhCIHjkedeQmAQTfKZsbt9O/8Z4LItr/BeNrhk0XEUe41TxnwM2Widg8C0kDG+cbkoImUig72prbndrgj+N4RVqbgpmTu9x1W8o4tBP9zVkft0P5xujs3JzKphpksfbA65svMVv2HwtzCNNBMtCpksr28Gl5xmL8WmNO5er+mUiEcOVwN3Uht6KfsxlJLSpmdsnLVvFlAk9GngOTM1r+EWrvIaPImHoppPPSpZgxGfAH8Ut9rBdVJvYDJpsrPypXucQoybvHa0R7fMl6U2VUxuLOBK8nSpZIOKwThZciAGjG8cCPJuUCAA1eKSaG/QhzKAP3QSvvCdsTyrDyN3BvFq0kj6r9qV9UaqZ9YZbxzZzp+Va+IKEZ+C1Je7iJCxMKsJh9rqrefpGNTYy47pqUWiHuNGmvb4pi+tfQP1RJ0kBd8pWiAmAZnBMD86kaho64bdMeisFF+SJFYHEOvi4BBMH0hzWsApz5Ony1zEwgGLo36TWmdwt1jgNH/f4VFaPGTZTRYOYls8t0JS8aUdXM0jQO8nJnm/3qRBypfmU6sMHe19iHBNRnPo4qSZWQAWa+7apG4cXzF1vtfDQ9miGLMLPTj+xYYAMT/Vhx7g9thJaEVpRQ2UsukXXGPApS02pOoWDNYRlx
 icCqSrC5
 sozDbCSHk15XLOHIT5hjp4IqQ6UcIQYehuqngybNoiG5XCefIDGU+WuydWbj3Sd64HmUwdr26c6eeQ27+9bRUWYWiBx/IpWWHaCVfmV326/G/03SlivmXUB7j80aStFH9cFrdAmYm91DlqE7ppP5gGhCR3sNA17FvG9ms726AN8L1R89ctgBOdtWpeUaNNaSMUw4L1LKNhFRDttnWaoi8ucmeSlVJlqC8c1axvhhOcb0eeKWwJDvPw4lWNpdfQGgbBl/BFlxpPZSxqnVC4DOL82mido/ICOmJXYxQewzJAjis396M8Dfopk3HyfgIoRdL4VQZhNTKjlVt6wfkNLunuKM/JmM6/F1T//1mf2NjJtgi70uAWx99Rkdt1TPsrbG/RZBdE5vxPdeUGupEvwD5zIB6g1NG+9u1Z9bWklThTDO9CeU0GrhtdMnU3OFeoWLUSpzATd6ah5iIz5/D6RGDCb6QUf4iHxbtudwoJH9nK5uq0UiYOPalMJCdJ9kxuF0a4Kw1udFPiI6Raskt1keSaEb8LQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 9 Dec 2025, Andrew Morton wrote:
> On Tue,  9 Dec 2025 08:47:45 +0530 Kaushlendra Kumar wrote:
>> Use ALIGNMENT_SMALLFOLIO instead of ALIGNMENT_MTHP when allocating=20
>> small folios to ensure correct memory alignment for the test case.
>>=20
>> ...
>>
>> --- a/tools/mm/thp_swap_allocator_test.c
>> +++ b/tools/mm/thp_swap_allocator_test.c
>> @@ -142,7 +142,7 @@ int main(int argc, char *argv[])
>>  	}
>> =20
>>  	if (use_small_folio) {
>> -		mem2 =3D aligned_alloc_mem(MEMSIZE_SMALLFOLIO, ALIGNMENT_MTHP);
>> +		mem2 =3D aligned_alloc_mem(MEMSIZE_SMALLFOLIO, ALIGNMENT_SMALLFOLIO);
>>  		if (mem2 =3D=3D NULL) {
>>  			fprintf(stderr, "Failed to allocate small folios memory\n");
>>  			free(mem1);
>
> What are the worst-case userspace visible runtime effects of this change?

Before: test allocates small folios with 64KB alignment (ALIGNMENT_MTHP) wh=
en=20
only 4KB alignment (ALIGNMENT_SMALLFOLIO) is needed. This wastes address sp=
ace=20
and may cause allocation failures on systems with fragmented memory.
Worst-case impact: this only affects thp_swap_allocator_test tool behavior.

-Kaushlendra

