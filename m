Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB87CC982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 02:09:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 957806B008C; Thu, 17 Sep 2026 22:09:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F7B6B0093; Thu, 17 Sep 2026 22:09:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FCE76B0095; Thu, 17 Sep 2026 22:09:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47C656B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:09:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B62DD140522
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:09:15 +0000 (UTC)
X-FDA: 85225250670.26.BACC8FA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1C5ED4000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:09:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hLWI9ufb;
	spf=pass (imf11.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789697352;
	b=rMqa00f44nfb7c8+IFOQfaRmLq8sF0B+rpeP2s1HD2+J2Daj9BVFkPu8jZ18fyDva9Lch0
	ZJ5Be/vrC7kQEU9bdExZF225QzGFlQt8WDiQXiGsvHDb9qrjAim4xWaaMgMEH1g9IQ/kOu
	0hs9Mv1sz9yRfeDPn2K9JpuHbWmqUqE=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hLWI9ufb;
	spf=pass (imf11.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789697352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZutcnQRcbGji00Y80v0hltNQDtdmfq8xMYPh++SyJt0=;
	b=EoV5n8e9NPau45fIhlxFoCekCOA9mNXTMEVMrZo2mxghS8n65W0bqecWWMDIeMSCmcL3MG
	vc+xIvrO6uQkxFIasA3OpncAB02PgI+mpqtziPiThNWshSbA+Zd6kuySEw9Xs5kAnVEEdc
	xy4g13PekFV6t9pWIvOn7K5Ysk3VDto=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789697351; x=1821233351;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qnvkS8Ugc0luFo5MOh2q1ftbdhCpwaflfNvppMGx3tI=;
  b=hLWI9ufbTdx0FMIMU0MrrzQ9qYwt/jBkqpvogLzqzyTk3fkcv3t3RiKU
   gJFc9zL/KrZ1OOTBVNnkt8GRjRMfL9lnN+kjXvCYH/0rK8z/l3b9XFdeq
   qaOveuFWOU+6UM/gp9S0sc7fX3RR56iu5GxBTqk8UsAtlSJqO59DIiA2G
   QCxRi8n9Y42Qle4yhPlccQ5kR/ZBpW/0/IG0Y5JKF//HKr/8rbXTAwheE
   9GVi/YOb4v/oMN1IDf62lRcy/4fhVy38Vsp/kB/gZVRATYeT21TaGqZey
   paeTdBxdaGqirPtyMQMW97ftyVssT8cKQdIL/3WVYYf8k8RJna7agDFt2
   A==;
X-CSE-ConnectionGUID: of0Xn2mWT1elIv73q8CREg==
X-CSE-MsgGUID: cz7EWeodSF+FDPAEDGf8ew==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="77740858"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="77740858"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 19:09:10 -0700
X-CSE-ConnectionGUID: +tG+w7iuTgSbIAvKROLCTA==
X-CSE-MsgGUID: JU/yBUzNQXGSHAbfb1aZAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="269849925"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 19:09:10 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 17 Sep 2026 19:09:09 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 17 Sep 2026 19:09:09 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.66) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 17 Sep 2026 19:09:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PX6o63l+v8pTn/QHRL3gMZ1zVUQkfKgR1271A7S+VTVYatXaN7bNWzClrsqcgVgLnuScGUOP9JgAKOEEZNx232KV00uUpsKSFM1VVRGQ+K7g1bP0JjpRMeGMtSS7uOwjN0g2NRAzf1kx/QMF+GFNVNmGlFFk/3igRWQa0LScZ0xSGsJ5OKl1HWcDFydPOvMbA5CQLuH7Dxnd2TMZY9QZ/o2kp80lv0Ad5CVJou6m5Igi6MIGVX+h6vFgyUD6Qu5GHdl9nPCGXxXth3ZaxByGiDpaQHnV8x0Oe6nFDlvcu4uTPfqIhxTXMsYa+tOAQcm71XNA2mSD5XgTQJxhcu7cog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZutcnQRcbGji00Y80v0hltNQDtdmfq8xMYPh++SyJt0=;
 b=E67c4gbTXwoExRp19+Jk0XeAlbEYRMMy4eq0zo4rIArzxGHHrJc06kpervcNpTx7WrXntikqWdk7QPgAD0HzubV+bpDUdWWdtELTEjwXydFX2JaBZxbFqScOrCSR1qF8f7yz0NuyALthCCSK+cssYIG0RMyvw77O9T6uFkA34f72rZ6sy7jTiQ3PczleNMnPv8PpghoD5sdXxD44YABGwdi0rGFol0n77+iL6bn66bXYegd598XtaVz2A0qfq2xmc5Lm5ooylQB56vUpAjOYmlNPXVqU1rXWdx+fyQHF3xJA3KqjAZxmDiv/T/k6NVqu/zO4tnBrXk9eUZRjvIgAew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6932.namprd11.prod.outlook.com (2603:10b6:510:207::5)
 by MW5PR11MB5858.namprd11.prod.outlook.com (2603:10b6:303:193::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Fri, 18 Sep
 2026 02:09:00 +0000
Received: from PH7PR11MB6932.namprd11.prod.outlook.com
 ([fe80::cca2:8c49:b4b1:761e]) by PH7PR11MB6932.namprd11.prod.outlook.com
 ([fe80::cca2:8c49:b4b1:761e%4]) with mapi id 15.21.0406.007; Fri, 18 Sep 2026
 02:09:00 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: Mike Rapoport <rppt@kernel.org>, "David Hildenbrand (Arm)"
	<david@kernel.org>
CC: Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "Zou, Nanhai"
	<nanhai.zou@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>, "Zeng, Jason"
	<jason.zeng@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>, "Deng, Pan"
	<pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v9 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Topic: [PATCH v9 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Index: AQHdRBpeQYFQ9mVeMEqHN/qStzhaGbbPJ8IAgACbaoCAADzrgIADnGTQ
Date: Fri, 18 Sep 2026 02:08:59 +0000
Message-ID: <PH7PR11MB69324C2F3079B23F8E20C489A3872@PH7PR11MB6932.namprd11.prod.outlook.com>
References: <20260914072929.1883794-1-yuan1.liu@intel.com>
 <20260914072929.1883794-3-yuan1.liu@intel.com> <aqjfyGeQaL4g2EcA@kernel.org>
 <209de483-a9a5-4d98-bda4-7998e8fdc7da@kernel.org>
 <aqmVQeETYhbsl79A@kernel.org>
In-Reply-To: <aqmVQeETYhbsl79A@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB6932:EE_|MW5PR11MB5858:EE_
x-ms-office365-filtering-correlation-id: c4128576-9a6d-4174-ad08-08df1529cdae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|38070700021|56012099006|4143699003|10067099003|22082099003|11063799006|18002099003;
x-microsoft-antispam-message-info: izOwHtDl05G8ouss2rEr7Tw614cGO8MvNu+Gmn3uSglxpMjxpLqyMz9wD7HkUa0eXXCUPZVNJR75IJUUdVfxoI1bHyQtdbm7+TlzEz5YrFBp3EmSNeHd+k7pRqyNXmIfru8t6FplFvfjaCPQm1wYLy8TAs7sm7i3oIoFSgyBuSFJRT8Zswml2MtutAN/FN70SdmBktkZOy9O5Pb4sy2fp0Kg6nff3wkkiq9zxs4koJ7TzrDaDZzfubWVryuDl4Nd/2oHLVCQPH3GzPYNEgFjCR+LCCEIzm0nPA8m7zW2EMIcwtFmm6pABJVSBHFDb6wvhrR/tWMp/R0m9TWW2/23xMK/pUglmG7iMArDyOrk7Z4euEIJUK/QwkUw0IkR13gCq+DvFKW9H5p8kH8xvV63SQA9mAlUYdBP1ojmwLlpXmMjATK/kQoKnd+BrijAhgwmGSNmtfTJ8zWTBGUJFqICUPEiFlY4kkSHJyiu5Y5MAuaTvuzp1LMgRFcSKnZ5f56YymxreMx33anVX1aQNYHMrQDJCtZU1Tl+L87pgt2Epe99SRgWy2Hh3CQt6bNau7dtn6axTWjORo6XpM+OrkEiNl0clygD52SmKmCIwoHczQVNt99PaKWZUpq8qbcaf8x4YN1KPIXR4aK9plsH8wxVLi6zpP0lsVKrVi3fwG/XgDen4e0UrhzNvlO6s611GaPPgkbvEuxUpVbsoWPkviqWM4Qjd06b7YWNmfIQVfyhWQc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6932.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(38070700021)(56012099006)(4143699003)(10067099003)(22082099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?570ale8Qrk3mmd4Cx5ZoCWpNwj/akkCF7b63WE3ANVqsxhmLbYEIakLhkL3G?=
 =?us-ascii?Q?Cc4N9Mnlx3DOVKykDH1iOn1unk6YXaSMi8WtNKZWpR4M0HMqC5WAyuYgcYjb?=
 =?us-ascii?Q?dcpx6hT58UpNUR2FDtrxnPI/BENDPsNyAj+dyg+6DFXRby1OwMluz2nybg0T?=
 =?us-ascii?Q?6RoIzo9MfW0syDsbo1/tUxl7obOGPlhqt7ZssMeezc4RWOUsLUSmHjD/QNSr?=
 =?us-ascii?Q?XmcdkMjaAmExhozZBsMgKj5DHnk5QrFDuzy3So7nCgGU69ja4kOeFSWSJp69?=
 =?us-ascii?Q?qWWMSE0LzoUUMbyUlm5B6dsb7rE4IC1miDTYVPaqPXnaXrCu+Lg5NmOCSZVW?=
 =?us-ascii?Q?5ky3xgmy6OYPe8lYXipJUn1eIkluy7pMb6b2cWkNlPmQREZH+DWPpP2mZh+v?=
 =?us-ascii?Q?3uFELlUCd2lCggMwRA3JKkN/PikxCdziryVB60rCNSIv15pVTNsCKPMDnc7R?=
 =?us-ascii?Q?0ni65B8Yfn7GiekZjB8vPtLLleFSLobKOcdVQjbpHo+5NkGRU9km36zugBZD?=
 =?us-ascii?Q?xpYYVEV6q69Ma7BLVGD51oFDTk43vsOLxV2m81qH2xjEmr1VN74u2ZvkjJcO?=
 =?us-ascii?Q?epwAKvcTDfAt9yJy8QR2Bkr8cUKfBS+m6x3KS+oSCQxayJYIoMyir0mKAvKI?=
 =?us-ascii?Q?zoFsdT+IMHtQHvghcQOxMDTUogbTYotFKZzitSf3jbUBcB7lT30Xlmumg+h7?=
 =?us-ascii?Q?4Q3IdMGb7eRxvrDUp9xk5QjI37JlmzeLjEuTqfS/FlooXwabZJiqdi+Zje3j?=
 =?us-ascii?Q?aLLoVZ5Pcyz3OJJ4lxmF7UmAeQeeN1leiONpXOo/x4P1OrSQbcOM+iun2E9Z?=
 =?us-ascii?Q?RPlyJUTYwraj7VNR8RNFLZUn1akKOr+o46AaG0hHvGbkNjuzI2YUqxK/E7+S?=
 =?us-ascii?Q?L2C3Z7iSnFbLLWgQlDSWXorIT9HCQxn0XXCW+3xa3OKxuHQN6BzY3BafqNvk?=
 =?us-ascii?Q?ySDHx28Fdglu1fJKF/vRRZPzFiR/VOb+U+IrhAsOIHsbWP4VQgEbFi3BISpF?=
 =?us-ascii?Q?ewtABgCq3gmTNRZ7SXxIT0qBoXAztOeFQblS/K729rMAILor/ibxx15aTCc4?=
 =?us-ascii?Q?QsLhi9x0SY8iYuqBqrhgTsCebx954qN0NwHPLajIbRObJHvWNiakSLHEZolT?=
 =?us-ascii?Q?bOI9oUmiQjgHV8DyaeyVoGmwDqTawU3za9LpnQhEcE1cpgc6zbttvnH3MiY+?=
 =?us-ascii?Q?oayE+jzjIHBT5L9rlrW0ac1mog4GGR7fIm5rg80xUtPCuElsblmkcRAQ9tMP?=
 =?us-ascii?Q?WBksCWPYgSebX6bF5jnuX6RyS6cJetGDpd72QrwSu6pFjJfMEw1ARSANGfOg?=
 =?us-ascii?Q?6Mjbj9sN/Xym/0v5gQ3pdqrLJk3FVlgDfkV8E4ANGf5aPhuIwk0on8ZvU3L6?=
 =?us-ascii?Q?+Hve5lt6zDP7qLPIv5NJEWGsatwEeWokkERkQl+L11rc3CXOgUJ8syS4inC4?=
 =?us-ascii?Q?FcG4Akx5AGBarIzk1OejPbFnQDBQPq7AJRx/Ru99YfnZvTmH7iSG+vNBlIp8?=
 =?us-ascii?Q?uXfQ9YlzI8Wv55QUtKPFB0rVRaQpY+y3KNe+q4PBWSzh1iS/pEN9I/yVe70x?=
 =?us-ascii?Q?WaIi8RbQcUnBoRwuID/ovlDe3D4pGVe8m7R7KEfsaZ/UE6liNSsf96Dp38Ep?=
 =?us-ascii?Q?ZiD3uZj6BH3RGlpzv9Rpu1Bvn8MSKFqgGKUyDan494+XoqEkJnRUnbiCq7Y7?=
 =?us-ascii?Q?Vx1NGKMqJkKKjus3MQ3z5iax6deb4nIUcK9s4dp4NDMVLxDI?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: w7LngQVMSe5zj/QGo4eXUdTVNbRgI3qlNA6oQrMk/kehhK7vuJHuhTdseyhXW/+ANMnwMKmxgsZyJIInsb4oaMrE8GNMKHSOrYvQ9qt+IQL9BpYn/0zd2c81ZZJ7ti7h/HHN+hHEgkRynhWcwr1p45dWeST1PyIda1x/y0TVtnjL9Fcc90G8xmYNpXq00f5nwWwzlAb3o/2EcnBpOxH5mfJ5beFdnlmFp+nAoYR11r1iIUdE/iOhdSsrh9wtm6xaIEYMoyupCnlD5axL9wcU9RGXktDVeuGnVlcREXJwXZ1dfKWDuCEKyAppufEtPryW7Z5qfHFnfoMJah4oMaQMGw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6932.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4128576-9a6d-4174-ad08-08df1529cdae
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2026 02:08:59.7990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SedKKSttTYlzZY0ATTQChkIGzpCVNYHjNihCkqLuYPaAmeAFLvku3X4oxvapXTF8u0gTS4RTBs/2P+QMUv26Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5858
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1C5ED4000A
X-Rspam-User: 
X-Stat-Signature: 66uyp9f3ay6wk1ptcjfqdjajr9hhe4a6
X-HE-Tag: 1789697350-543429
X-HE-Meta: U2FsdGVkX18rBN3tK4RGBs+Bi7CEplh+lW0HblpTjmhz3qr3JjLQHwbrIDNaLWuUm7I/cAyDIcoeDznYtGslDtib9yovKTIV4U/XO4t9YR2k9ZQl7nhS5D/vKG6gmADo2Ye1efnPsF88pJ+24huARP4FUVHNgj1bhpIRXBxXad/xGdsw3Rkl3CHLxE6FLOU0OwzAsMOoI1Gug3Iw/yWU33AfMOMrQfIGQ/MuQnT0ZhvZ5RTAUtO7d52gQGlqwm+pWgldBhQGfogp7gpyI+FWbZkFr4dWhiRILqqVY/hQ6GFkf9ajvSHHO9c9S9XKhEaiNU9p/zt25SyWgM4UOf3ihPR5LThlHcr//FGWszl/8xUfMyoXsEBvJ+27URwQm/LHwk2yYGpJcf2GHXQ3qLTmycCpdkyF2GfZP+SORSidzmzrZnLsRp0WhwNYMAmz4W7Vc+gFXRFSut2avsSnuCD7Vq3fcV+NpDtPKO86SfWuJ8hQW7belZBIVN9JtFJKdKajzZj2dg6XlsQ3nZwiB28juK2msSNT58f1iN3pyjgOq2QfEPKXghPP6p+sS6K+CmzKUkTkD0K7c3flcMz3/EZipNcP8k9RFyVgEsCJMnO+QJOR9qX/X1k790/qq+n6EIINigz9xOe1P2Cw8Hrcz17Nn+Iw6X03ubak38hv0xp2hke7xfdloR95jEMRz90+6E4gjFI3N4woTJnbpgR1uhl8H11Dj0Ku5XEyfVdIzY4Uw8aWjSwaoF/veDAVIRWXBqXlVS6HBM6WocMi6KREudhr9DhbnRG7is+rJKqaPKn0s6+uD22Ejyzf/JFPCq3lyEUPPW9Y2GP99T1XTlaOoHsoqjiwWwV2omzJPLUOW5NlHIbQ8L/KptJ5ObTJY2Y/ORqeWt42JiJZfM3QI9sol+s69WM4ee/pQ9NUN1QYlXcUL3xxEUn+KPtdAfJDsrJbQgEEHSThTjRWuuwEBJxavAh
 50+S3enL
 1J96TnbpwrLoN3nGBRN8GhTXszlrV2rwdzZcM+BncMzaRnGt6t1QDjiVGVuLYse71oiWYY2eoEbVtm8SDmrAfYizqnySMHKqlsiHaao8L03yAnsZZ2m5wwCKdV2wt7S1qs/y6pvHqU+E9GKErs+GJL9aRU0y0Uy7/i6tyLwIs5ZnxkX6htIlP48oO87AZNVvD0aCPx4hnYoXAQCjH/9sS4kQ5WijGMoBwqTVmiew0GKZck6fREhz6cdRmPUouvL/V7vN/aUa+nA+6lEdVGQ1bGeCa/IvJCAJS7QgURzLLpep/YRHEPVlCoad3LomUTug3j+J2QxlPxkIcP3rL9MCEbgAOWNnfR4vdY99fiPH++0sCBK4WqBRfaOvY/RRaBaPa6lEbicQGpoIDZbhPAjNtW/Qt/i25CxNbKddr+HMZOco9T52iFEINhygWZjtoGAoWDQOJy3vaG5sVcOJ9GoXUfCCwmNtGWOxjqYh2scbL3XX84RTjSiK1VtpxMVJG1S5zAYrIprBo7EGlvbjJXenx/NJ47lNQX/sogE+O3z7MsSLLjO5RQTC1cO0+ccbV+iWIkksmyj9ZKLkGoTUBat0/OzIRvo7cwSwgJkERvGjge5DWC2jqv1f2hqf9cxm8/7CDSLaJTTxJlRXEwy6a5s49YWWBinmEyTcyfECswLth5F1axMgWuz8v5hNIgQKHINcMRV9Rl/uw8ktJJZ7KAZMQ9BK1XbRXd9zT2NhQMxrly0u1qss1xyz586hGKsOcxlyrLyIy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -----Original Message-----
> From: Mike Rapoport <rppt@kernel.org>
> Sent: Wednesday, September 16, 2026 2:58 AM
> To: David Hildenbrand (Arm) <david@kernel.org>
> Cc: Liu, Yuan1 <yuan1.liu@intel.com>; Oscar Salvador <osalvador@suse.de>;
> Wei Yang <richard.weiyang@gmail.com>; linux-mm@kvack.org; Zou, Nanhai
> <nanhai.zou@intel.com>; Chen Zhang <zhangchen.kidd@jd.com>; Zeng, Jason
> <jason.zeng@intel.com>; Chen, Yu C <yu.c.chen@intel.com>; Deng, Pan
> <pan.deng@intel.com>; Li, Tianyou <tianyou.li@intel.com>; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH v9 2/2] mm/memory_hotplug: optimize zone contiguous
> check when changing pfn range
>=20
> On Tue, Sep 15, 2026 at 05:20:07PM +0200, David Hildenbrand (Arm) wrote:
> > On 9/15/26 08:03, Mike Rapoport wrote:
> > > Hi,
> > >
> > > On Mon, Sep 14, 2026 at 03:29:29AM -0400, Yuan Liu wrote:
> > >> When move_pfn_range_to_zone() or remove_pfn_range_from_zone() update=
s
> a
> > >> zone, set_zone_contiguous() rescans the entire zone pageblock-by-
> pageblock
> > >> to rebuild zone->contiguous. For large zones this is a significant
> cost
> > >> during memory hotplug and hot-unplug.
> > >>
> > >> diff --git a/mm/mm_init.c b/mm/mm_init.c
> > >> index 1533aebafb68..d40a8ff23370 100644
> > >> --- a/mm/mm_init.c
> > >> +++ b/mm/mm_init.c
> > >> @@ -817,22 +817,39 @@ void __meminit init_deferred_page(unsigned lon=
g
> pfn, int nid)
> > >>   *   zone/node above the hole except for the trailing pages in the
> last
> > >>   *   section that will be appended to the zone/node below.
> > >>   */
> > >> -static void __init init_unavailable_range(unsigned long spfn,
> > >> -					  unsigned long epfn,
> > >> -					  int zone, int node)
> > >> +static unsigned long __init init_unavailable_range(unsigned long
> spfn,
> > >> +						   unsigned long epfn,
> > >> +						   int zone, int node)
> > >>  {
> > >> +	unsigned long next_chunk_pfn __maybe_unused =3D spfn;
> > >>  	unsigned long pfn;
> > >> -	u64 pgcnt =3D 0;
> > >> +	u64 online_pgcnt =3D 0, pgcnt =3D 0;
> > >> +	bool is_online =3D true;
> > >>
> > >>  	for_each_valid_pfn(pfn, spfn, epfn) {
> > >>  		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
> > >>  		__SetPageReserved(pfn_to_page(pfn));
> > >>  		pgcnt++;
> > >> +
> > >> +		/*
> > >> +		 * With vmemmap, at this stage all pages in an early
> section
> > >> +		 * have a valid memmap and are marked as online.
> However, only
> > >> +		 * subsections in the subsection map are actually
> online.
> > >> +		 */
> > >
> > > I'm having trouble parsing this comment. Shouldn't is say that some
> > > subsections in a section can be offline because of holes?
> >
> >
> > Maybe extending that a bit we could do
> >
> > "With CONFIG_SPARSEMEM_VMEMMAP, early sections have a valid memmap for
> all PFNs
> > and the sections are marked online. However, we might have offline
> subsections
> > in such early sections, indicated by the subsection map. While we must
> > initialize the entire valid memmap, account only the online pages
> according to
> > the subsection map as online (see pfn_to_online_page())."
>=20
> init_unavailable_range() already has large comment on top, adding
> something
> like that there makes perfect sense to me :)
>=20
> How about a bit different version:
>=20
>  * The function counts pages that should be added to
>  * zone->pages_with_online_memmap.
>  * With CONFIG_SPARSEMEM_VMEMMAP there could be offline subsections even
> though
>  * the entire memory map is valid and all the early sections are online.
>  * Count only pages in online subsections (see pfn_to_online_page()).

Hi David

Should I prepare and send a new version based on Mike's latest suggested ch=
anges?

Best Regards,
Liu, Yuan

> > --
> > Cheers,
> >
> > David
>=20
> --
> Sincerely yours,
> Mike.

