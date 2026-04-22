Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63D27F9B5F5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 09:29:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA3B6B0093; Wed, 22 Apr 2026 05:29:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6AC96B0095; Wed, 22 Apr 2026 05:29:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B59F86B0096; Wed, 22 Apr 2026 05:29:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A430F6B0093
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 05:29:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7133CE68CA
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 09:29:02 +0000 (UTC)
X-FDA: 84685667724.16.9648FB2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf28.hostedemail.com (Postfix) with ESMTP id 092B3C000B
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 09:28:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SAXLS0a8;
	spf=pass (imf28.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776850138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7b83AXvYn2YXGDbMPSPmSmdze0amh7xDbZ68YoN+KE8=;
	b=u3IvT1UaeEv5/1Q2vf+B2D9Ph2B7aLvt2Ih+rraamAcjVgvsKDOr7KaabSTYLd79MFQf5N
	iGFZQf1bC0QlQFjDmLJz/S1r5dFvKkfJsCHwHDwNJ02OF8yfyJZN0ghN/i0YhIsnilstdW
	F2MmYYvA8NocHviyzwPk9Ch7RmH5Pjg=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SAXLS0a8;
	spf=pass (imf28.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776850138; a=rsa-sha256;
	cv=fail;
	b=2L+63/oUYuzWeVar6pBI1hQGZsGplKbfGDdvggo1aTg09m8nkkIE5uWxJ4vUfoFm+hw7lJ
	tjDmkZUk3EPAN/A6dJocKSl8Xr155dktK+KxeB+YIKU7g7x7mHl6TRDt5+KH8YSF+lIf9f
	jVUEzl8FxfJV1XCt+soXNT9ZmVCRyfA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776850138; x=1808386138;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N8IElkeHZb+X2c2PSkgXwnZhDK1B7PZ9lKTZrtrwRFQ=;
  b=SAXLS0a8C6tXs92rp0eJepvIIIg2o0WemiWkfCsOMFkfrxWxa0QxTl7n
   JIBvEK0c8ge7GkJxs2jLnQgggAC5knR+nP+F86pNydbD32JjQOpWGyrFj
   bzAej8W5aTfNVoZ9Vd5BglDahIgTn2pBqlEyn4F5LOZH7qrsMF/rCmrCc
   yrnpTAJWWQkED07SUSvkTZJIIvQuVZpavSxRzgSG7X1hnmj/Zf7P6a70M
   QbY7C4SGGQNW+DXa9083IWS1Ld8MzQ3PQ4b7icKrLxvK4OufpgIez0csI
   vLAUYah8VlseUQZcsr81C4DxQ9XMKxlurK8M1XAjwpDKlouqyOk5e3F6C
   w==;
X-CSE-ConnectionGUID: ii7IuBHBR5u0Ac7rVPQXJQ==
X-CSE-MsgGUID: N0I52+UhRFyjQ/A98XtJnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11763"; a="80385875"
X-IronPort-AV: E=Sophos;i="6.23,192,1770624000"; 
   d="scan'208";a="80385875"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 02:28:56 -0700
X-CSE-ConnectionGUID: ewtTQL0zRkekK2Mvzipcxw==
X-CSE-MsgGUID: qVqOtcOpSXmH0VQCrkbONA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,192,1770624000"; 
   d="scan'208";a="227971904"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 02:28:56 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 02:28:55 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 22 Apr 2026 02:28:55 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.11) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 02:28:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FDsydhs9FvPt7abezrBUcM5noYJLMtqkx5HB7PL+Ig7IVp7ZrnlCz0ctcYBLYhZSIRqWyNf19lh+N6MqME0znZRYLVUrvE4UtW6Ht7XeU0knwaFa0VnD1ktNRc4hFx6qv8LLEv3914lTIkI6gWSSJNMsorGRiZmPQCrmQNpsvUr0ENSQE42k9vW4P0cM/fjKRtn1ZaeJkYtY/m8RxWYoJMcCabP6DRdeSJTLNpIBlsnUfRq3uVWMrq5gg3JLuKs9JP9ygFmD0LBIjJBjpV5AJtz3kjtTULGQrUN9QHUj5S4xCznuMPmjJZC99MxViZHrAe+8xYzbEgkIB9yuEljSpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7b83AXvYn2YXGDbMPSPmSmdze0amh7xDbZ68YoN+KE8=;
 b=gPQxgSngtu9CRSV8Ffl+G1drTHDfCNS6Ws0XOoA3DTyKa7+6QZXFISGDDNr5gU0LLFKIMDwjTmW1/Fh/pjhtV7NfaZ53O36IoBW7choE4NXi7rPDjSP9/fj3GoWJeWd4mHXgF3ItP6N+0Ti5KCRusdxX+cOeOJulw6xIL6IodQT3GC/rtiirghgSPC0yF5qa5Nf2qetCoZe9XAXLZs4pzjhartIeQvaoKnzTeAe8Iuk50YD9QYHda/zDaD7nPMDp1DkWmL5Z10k+2QyLk4Z3cZSyd8s+iL6LCkZfaTuI/j2FJws4sI9qwHcy+f+YbjFK4iJC100dl1ZipiSvZlJTzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by SJ2PR11MB8298.namprd11.prod.outlook.com (2603:10b6:a03:545::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Wed, 22 Apr
 2026 09:28:52 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%6]) with mapi id 15.20.9846.019; Wed, 22 Apr 2026
 09:28:52 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: Wei Yang <richard.weiyang@gmail.com>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Hu, Yong" <yong.hu@intel.com>, "Zou, Nanhai" <nanhai.zou@intel.com>, "Tim
 Chen" <tim.c.chen@linux.intel.com>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
	"Chen, Yu C" <yu.c.chen@intel.com>, "Deng, Pan" <pan.deng@intel.com>, "Li,
 Tianyou" <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 1/2] mm: move overlap memory map init check to
 memmap_init()
Thread-Topic: [PATCH v4 1/2] mm: move overlap memory map init check to
 memmap_init()
Thread-Index: AQHc0Y4h66ZJRC45aEeUdFXXLFyV9bXqRsUAgAAl0ACAAFy7IA==
Date: Wed, 22 Apr 2026 09:28:52 +0000
Message-ID: <MW4PR11MB6936682EB5EF1993DE7BDAEEA32D2@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260421125508.2317429-1-yuan1.liu@intel.com>
 <20260421125508.2317429-2-yuan1.liu@intel.com>
 <20260422011126.thu67icgj5qfbecj@master>
 <20260422032646.vtkdoliudlxgtpv3@master>
In-Reply-To: <20260422032646.vtkdoliudlxgtpv3@master>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|SJ2PR11MB8298:EE_
x-ms-office365-filtering-correlation-id: 66105994-d4e2-41ea-3906-08dea051914c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|18002099003|56012099003;
x-microsoft-antispam-message-info: pH5/1CwLz9l95S9zFt+7wYu/e/aYUFER98jqaxZYokZOoQJHjYNaZfpCge3USCwdpV/enOT5Uw80KwwVug7JNRMlYTiPiiKqtMdwsg7XGQWtVtQsXVJhYphwB9F3Y8IyQ3Gvq9yKU0zIqbjgyonOwangxTEfCLTnR7KcORpaXjlPsch5jH71grAzly9htBLSxbzF5YAJF53bQ9rqe9IMdbGWOjIVAgZMCjqZHlQBNJFDeJajwgefmRglPX6kJwSpKXJd6/HzUMhqLHH7eqAK84VG7i78JRViCiF14eVfK/wkdku87Jvd3NaTfenjCOjEklAV8ravahfQdhgmGBsxsuAUEYY039eFZexi8TeNfZzu94vOW0iPp50aXP8BFNqfXRKfc0MWpHrD0stlDvU/uDdGk5lF7jHnr4JNYc2CEDfJKkMZ8EOMhY5SW+3n6esXz4yBQGyFqLmLk8WOnKKyOMI9aEJtWMTw7IVBuIGG+ZAaWaTj7wDhGCBs4o5uxApQRVfHGxK8fb3ZkxwKfhJTdKM1xqYCF6lVcIHjNCiZmSmbE0HvoB9gSkK5LQdl9rXXs5Zwf5okLLnM4wdn3WcMPG9w9qxzIta0Xwwo/YW6QTg4b23D88lkZ4qZM+klbu/3GbaNDbSTzTqSN7u5iqYY2ZlFSy9HdS6cnpK1S6KUJvcSd7Z1NIIVKQYgh9TTEGMmvbxkNYx7LbiqR/5xKuMEIuwMqPsjFyT5Ts+LFYjHawXchfIvf/E4MskW18WdLTUUPUWVYSXQUSLX21zN0JLMXNTZuLKi6dahBngn721uyEI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ll40cSm5RwgsNR6QktscfMoFkBpTYLaWAXzVLXXcAjZPtbf9LzRPCUij8Gx0?=
 =?us-ascii?Q?iTI1gek+Ew2p4r9mfWGd+eXNSxjMWGUlrB0jToR+A5s5TVZ/vYt7PisGhEIJ?=
 =?us-ascii?Q?g7Jw5xHAh+OHidxTiww6xyGbp8ksWPXQvF0GopUo/KMf4VE6UW1oxEhV52Y6?=
 =?us-ascii?Q?HSDsXMJCrWfAY5gePiuh67twsk9vfiN58mmLB+442ALsUbGWCt0/flnD6wEB?=
 =?us-ascii?Q?lH9YSIndIP1KIN2cjWNwqh9GltgTByKeT2iRRyLELaxIQqpXzA87xkBXkGRx?=
 =?us-ascii?Q?C98xbgy9Zxw/SkaSlCaO84CV6q0kjLcqMbyczLU6RMluk3triEdluC1A4rYv?=
 =?us-ascii?Q?B6V2nAwIT8wXT15dmhbmb52QvE/q2yUFmRamF79Qqk+ZjCyy3eF+p96IbJLa?=
 =?us-ascii?Q?BiBy9ufV69ViIQRaSIsRMmMu4ycravpIX5+LA9Z3LJRVGvck/j2xb2Xvl1at?=
 =?us-ascii?Q?eRekqLxofkJyJExvK63mObNRNujpSpXRAm2n3Hu15t+iUF6TkcsIAc6oLfGD?=
 =?us-ascii?Q?1E0XThHgCZDrTQEg3QMkIryhd0cfE71POcj0wwVTp6OEbvFC1647M2FPspMG?=
 =?us-ascii?Q?VHJyBkavM7+J+GJaDZBP4q4XPIsJblsvT2x9kY9OaS/xw7BDzrQM1srillJl?=
 =?us-ascii?Q?JxuRdCyONLDXIMikourH6sJngPz5KW7w/Uvn05nf4j2t5dgfZA4FNBi5lYmJ?=
 =?us-ascii?Q?52V7XrfwOJyB/YU1ZI7cZUkitcLj+D/WC/JlPzWP8Hg2gT9CGKOyig1Qdaia?=
 =?us-ascii?Q?/oCjIVj6uBS6z888luV9RAsCbFFrYfOM6nTxcHM72kt2MQSXjX6ECeBqDOJ9?=
 =?us-ascii?Q?tcZ1KCT8oru2b+4NZVuI+huwpVoBpGmA5H7b3S6b0kwDjshpzWdGB7WuGTVZ?=
 =?us-ascii?Q?WwTk+OxHC1QlX2P8jCz1XCcIzO20SSpU82vyOKwiokefIFRhwNT19hIy/gBx?=
 =?us-ascii?Q?/RLKASXXpKM42TytMqX1Bj0kqZqjuAtndBsZTh3kQaK0xFc+7KZF7iUXB0kp?=
 =?us-ascii?Q?TFDdAHIgiXjXkBxp+3aYMbY2q59+Ukuu0ek73cEnzIhSzGSJ9UGiqz+0ER/8?=
 =?us-ascii?Q?c3o5dsZp+R15CwPe0cbgPmkisXjWfDRExjIp4aTwzXXYDvEH0ay4zEHEWmZ4?=
 =?us-ascii?Q?l4vWgzJYmh0WM7dc6n8J8ncwqw8Psuf3grlmm/rbIRYd3BBlW0HohnJVBfSq?=
 =?us-ascii?Q?1XrtVoZ6PVE/LFw8bWyTCQL2UnZH6IM5ZVzNkft44Pu9fFQEiOhegKDnuh5q?=
 =?us-ascii?Q?LTX71G5QDq6bJUPCBGqBj0IHuEXZpysuR+xvGQq8o+Xaaxb+rAZM9e6KE8RP?=
 =?us-ascii?Q?OXILZcthMtNrHFgHNMyCNp8clqA/R9C6ExSDthqNXb+m+Yyqu6j1fOWM+58z?=
 =?us-ascii?Q?qOrv9k7DVAy83bzV5p4J+Vsy/J5T2/CI8FTAyQ0Gdc+T7C/ayAYPTKdTqc8+?=
 =?us-ascii?Q?aRtkpm9kGnUJYI8uARTnaaJ6uaMfMQswpBT7Iw4WtGMMcygshgoES7iQ55DY?=
 =?us-ascii?Q?TgDGsdZ4fpQCqwQJgPCZUgVea7YQ+m3WQ5U78lFLXmtBjNx0AUxKZfoOX3kP?=
 =?us-ascii?Q?/Lxzt48iKUWY0jR/5gDIIZORVxR+BnDa467Gn+Q49K46j7fyJgwRHhPhtYWH?=
 =?us-ascii?Q?9KGHpnbU4V4dPq6U9CwlGMGNkrwuTUFs441Tb+q4tLyTYqauR4kYzAntA9aq?=
 =?us-ascii?Q?msmczBI5da5XQFsfY3+Q4iEZhe4RNx2a+QKIq9Y7Ypbja06TPVknec6qcCM0?=
 =?us-ascii?Q?W7D78IDNew=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Kf0VX0XNsUjHTBy1hzPP9hmIiMSvAMKt/uxxoFi0JfTWLIvLbCBAMO6csm9R64h6wu0OMFocuzebWhH8D3AaYOIlnOE0gmeI3Pyd3dPU9zKomJuqbRtXYHlrKcNpqPfLx0JQk/YKb1NrybLUCel0VqCzNZBc4OJrbEk/iKy2woqrGrsft4OlDy21pPfNb7vZq4M7xBY/tQDkP7EeX3rrdBdEvNgsb7v2EUoHwqnTaTLkGjMgYCQYoI3AB+5IXoxeD2wrVSH85jaVHJukF/0XFllABFb5T2F/btieCIJkqrMmsEgTP1d+RRugK6lcxAveuGpK/xPQ+ttsCECqCB3pZw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66105994-d4e2-41ea-3906-08dea051914c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2026 09:28:52.3158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zaB2E3SVdTyqSpkhixbDzZiu+APJuNZku790XB/mLrO6FzKou/++j27Ley8T3vj9jLXB7KP56XBeHwqtHXnw+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8298
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 092B3C000B
X-Stat-Signature: yrpbec5awdd9auszncemr67ictxz6od7
X-Rspam-User: 
X-HE-Tag: 1776850137-452120
X-HE-Meta: U2FsdGVkX19qL4a1yTNcW/5ovQh/xtyCuxas2H9uNGEL2vtjL2ItDHCAnnFxDmNQklaCzDOfSYrx4PUuHLQV8Icbwfam5E5o05/4qgkbGmC7rIj9nFzwXf8Zfk1a37P8H1YCT4pTSUZCBLyXoPtLREnUOwsgUtrY6y6XWjFM1hIcaKtnsL++VV80yb9drIy4oKyozs4X5koK+O7DibNtgEC0ezpP+NyikYy/xWEZZlFM3TsaBPFKvfQEInCswNcPDFYKlzmDsuFIWGG31TIiUZRf1Or9r6Yd0vWZlelAjmnrpyeydfAKVMIlqGrTxmXTBvc6tjUlsRInyS+6XIb+D192aShT9Wc2gAp4W57ClrzjE0KrfUpTHXvlFfl2pZrUR5tN+sgiXFsYh7WLl0tWXtcWtX6kIGVYJp64ABwTpRmRwaEzeFioYKlPFOCCXVuBDKoPqk8BnZh0hWBfjp+OSicfnggrpH0T15UtOzRka/HBnzgucBs13Lvmi3zDsg9Vq8UH90uyBtgz1vRyW3vI7JwGAoI83ppJuFL1AUNAvwlDTmuq4NJ6yrQLzkNz/llNHeLMYssp+rz9N78DeA7R5n8FpZqSC2RJxpcHLLpo6/sN2M8LcUz6CNzDlgwtiulB9oWQbPxP7utYGs2nnoo34g/fJoOziGNHe3sYKlyAmAQK5l3QtLMiCg/BRbm1CTEKHH3ZvZMAwWH54Olg9Ha1H0JV9kcHhaUiae+cTie/JjEPk637Sm2np77BRqMvmSADy2T7o9lqEeZdz92Txrlc3Ky/CtHIGpVUR3Fnhu4jl9JVE1tze8/nwtIiHRngjzog+0PHt7sU1NmA4lUL9f8vJgwuQPUnUMhF1yUhSOTOSqXWpJ0m+4ytqZw/XzUVkVHOhi2X8s8K74FevbaWAvd0Kr0hoTlQ8L4DDxeJoFfpBgil1brGlyN85IbyJ3NBLG2qRNjQYikp8mZgjIpRsA2
 6QGx4ISz
 aq40h6ctJKtHiq/WPv3gTUDC80oiPZBeTL3gQw2rZM6GdYJ5Y2z2UCRCUqAC6Az8gOr5CztWEAvWI/Jc5h9iPMv/vTRpgbhNVnlL6cgWXMrlD2QBjCvo3RCLj9oK7vgn6umeHpQzPze80tKUkN8i3i2AXbg4uMeCxOHYGttH/TIdb+0q0FeqN49bl2NC8UI1vaP/WvwKpPvBVFlAOFh9kgSHQAhsg5bawZt/3wmYyD2vvj6/gvfaQSvMLXq+paAWb7oLVIzvWe2Iu31JKoxggDslJjwNJ34hL1jnvsSM7EbkXVjGVs22l/8siowTCWaRixmGZyz5m5ZjXa4hbdPDO2iZNjMxEoenuQPlHN8BsCOx7TkR3jn07B/VoKIB+CIyN6QkTyTtB0fzik9Tc8YWUL0taqO18JtmPFpbbAjmnTE6fi/ayAjuHKrGhtMiVQuAqWFDHvsc8FUETV4na2wlxofzf+OYMHYu+P3/I8+yRPZSYaNmsMYxGi8Azsf7Gs4kPSeRhwv2nLNeiAmn5CrzFEpljjpLWxJnhPIh0ssNNydmLYvTHt5TFm7qH8topPc1p2lyYpPcGjVfZb8GZBziFD2tNkzFnDIfS/Sl+ASkrfbGB4U/u7s0HpICa8G1dRcEHBWisxISSRXygH6IFx6tuAFg3GT9bw4u57JADjU+O33XcK9dx+6ajfcpl5EQGMHsCQd5e7zeE3l5NGjzG7eg7nUBGPhSLxrRfLnhZHWjFD5OC3N6AqM7RdM2whPOzh8o5LbCMODKhy4M+OB/EkDbMAOACl85FFF7zNLK3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -----Original Message-----
> From: Wei Yang <richard.weiyang@gmail.com>
> Sent: Wednesday, April 22, 2026 11:27 AM
> To: Wei Yang <richard.weiyang@gmail.com>
> Cc: Liu, Yuan1 <yuan1.liu@intel.com>; David Hildenbrand
> <david@kernel.org>; Oscar Salvador <osalvador@suse.de>; Mike Rapoport
> <rppt@kernel.org>; linux-mm@kvack.org; Hu, Yong <yong.hu@intel.com>; Zou,
> Nanhai <nanhai.zou@intel.com>; Tim Chen <tim.c.chen@linux.intel.com>;
> Zhuo, Qiuxu <qiuxu.zhuo@intel.com>; Chen, Yu C <yu.c.chen@intel.com>;
> Deng, Pan <pan.deng@intel.com>; Li, Tianyou <tianyou.li@intel.com>; Chen
> Zhang <zhangchen.kidd@jd.com>; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v4 1/2] mm: move overlap memory map init check to
> memmap_init()
>=20
> On Wed, Apr 22, 2026 at 01:11:26AM +0000, Wei Yang wrote:
> >On Tue, Apr 21, 2026 at 08:55:07AM -0400, Yuan Liu wrote:
> >>Move the overlap memmap init check from memmap_init_range() into
> >>memmap_init().
> >>
> >>When mirrored kernelcore is enabled, avoid memory map initialization
> >>for overlap regions. There are two cases that may overlap: a mirror
> >>memory region assigned to movable zone, or a non-mirror memory region
> >>assigned to a non-movable zone but falling within the movable zone
> >>range.
> >>
> >>Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> >>---
> >> mm/mm_init.c | 37 +++++++++++++------------------------
> >> 1 file changed, 13 insertions(+), 24 deletions(-)
> >>
> >>diff --git a/mm/mm_init.c b/mm/mm_init.c
> >>index df34797691bd..2b5233060504 100644
> >>--- a/mm/mm_init.c
> >>+++ b/mm/mm_init.c
> >>@@ -797,28 +797,6 @@ void __meminit reserve_bootmem_region(phys_addr_t
> start,
> >> 	}
> >> }
> >>
> >>-/* If zone is ZONE_MOVABLE but memory is mirrored, it is an overlapped
> init */
> >>-static bool __meminit
> >>-overlap_memmap_init(unsigned long zone, unsigned long *pfn)
> >>-{
> >>-	static struct memblock_region *r;
> >>-
> >>-	if (mirrored_kernelcore && zone =3D=3D ZONE_MOVABLE) {
> >>-		if (!r || *pfn >=3D memblock_region_memory_end_pfn(r)) {
> >>-			for_each_mem_region(r) {
> >>-				if (*pfn < memblock_region_memory_end_pfn(r))
> >>-					break;
> >>-			}
> >>-		}
> >>-		if (*pfn >=3D memblock_region_memory_base_pfn(r) &&
> >>-		    memblock_is_mirror(r)) {
> >>-			*pfn =3D memblock_region_memory_end_pfn(r);
> >>-			return true;
> >>-		}
> >>-	}
> >>-	return false;
> >>-}
> >>-
> >> /*
> >>  * Only struct pages that correspond to ranges defined by
> memblock.memory
> >>  * are zeroed and initialized by going through __init_single_page()
> during
> >>@@ -905,8 +883,6 @@ void __meminit memmap_init_range(unsigned long size=
,
> int nid, unsigned long zone
> >> 		 * function.  They do not exist on hotplugged memory.
> >> 		 */
> >> 		if (context =3D=3D MEMINIT_EARLY) {
> >>-			if (overlap_memmap_init(zone, &pfn))
> >>-				continue;
> >> 			if (defer_init(nid, pfn, zone_end_pfn)) {
> >> 				deferred_struct_pages =3D true;
> >> 				break;
> >>@@ -971,6 +947,7 @@ static void __init memmap_init(void)
> >>
> >> 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
> {
> >> 		struct pglist_data *node =3D NODE_DATA(nid);
> >>+		struct memblock_region *r =3D &memblock.memory.regions[i];
> >>
> >> 		for (j =3D 0; j < MAX_NR_ZONES; j++) {
> >> 			struct zone *zone =3D node->node_zones + j;
> >>@@ -978,6 +955,18 @@ static void __init memmap_init(void)
> >> 			if (!populated_zone(zone))
> >> 				continue;
> >>
> >>+			if (mirrored_kernelcore) {
> >>+				const bool is_mirror =3D memblock_is_mirror(r);
> >>+				const bool is_movable_zone =3D (j =3D=3D ZONE_MOVABLE);
> >>+
> >>+				if (is_mirror && is_movable_zone)
> >>+					continue;
> >>+
> >>+				if (!is_mirror && !is_movable_zone &&
> >>+				    start_pfn >=3D zone_movable_pfn[nid])
> >>+					continue;
> >
> >IIUC, when mirrored_kernelcore is set but !memblock_has_mirror() or
> >is_kdump_kernel(), zone_movable_pfn[nid] is kept to be 0.
> >
> >This means it will skip all memory regions.
> >
>=20
> Did some tests. When mirrored_kernelcore && !memblock_has_mirror(), which
> means there is no is_mirror memblock. This will leave
> zone_movable_pfn[nid] 0.
>=20
> So for all memory regions, the above logic will skip them.
>=20
> Adjust the code as below, my local test could pass and kernel bootup as
> expected.
>=20
> From 6351ac79a17edbfd830510fba2959ddc47b17258 Mon Sep 17 00:00:00 2001
> From: Wei Yang <richard.weiyang@gmail.com>
> Date: Wed, 22 Apr 2026 09:13:24 +0800
> Subject: [PATCH] skip overlap region higher level
>=20
> ---
>  mm/mm_init.c | 29 ++++++++++++++++++++++-------
>  1 file changed, 22 insertions(+), 7 deletions(-)
>=20
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 79f93f2a90cf..7a85ba58e87f 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -916,8 +916,8 @@ void __meminit memmap_init_range(unsigned long size,
> int nid, unsigned long zone
>  		 * function.  They do not exist on hotplugged memory.
>  		 */
>  		if (context =3D=3D MEMINIT_EARLY) {
> -			if (overlap_memmap_init(zone, &pfn))
> -				continue;
> +			// if (overlap_memmap_init(zone, &pfn))
> +			// 	continue;
>  			if (defer_init(nid, pfn, zone_end_pfn)) {
>  				deferred_struct_pages =3D true;
>  				break;
> @@ -974,6 +974,17 @@ static void __init memmap_init_zone_range(struct zon=
e
> *zone,
>  	*hole_pfn =3D end_pfn;
>  }
>=20
> +static bool __init region_overlapped(struct memblock_region *rgn,
> unsigned long zone_type)
> +{
> +	if (zone_type =3D=3D ZONE_MOVABLE && memblock_is_mirror(rgn))
> +		return true;
> +
> +	if (zone_type =3D=3D ZONE_NORMAL && !memblock_is_mirror(rgn))
> +		return true;
> +
> +	return false;
> +}
> +
>  static void __init memmap_init(void)
>  {
>  	unsigned long start_pfn, end_pfn;
> @@ -985,10 +996,15 @@ static void __init memmap_init(void)
>=20
>  		for (j =3D 0; j < MAX_NR_ZONES; j++) {
>  			struct zone *zone =3D node->node_zones + j;
> +			struct memblock_region *r =3D &memblock.memory.regions[i];
>=20
>  			if (!populated_zone(zone))
>  				continue;
>=20
> +			if (mirrored_kernelcore && zone_movable_pfn[nid] &&
> +			    region_overlapped(r, j))
> +				continue;
> +
>  			memmap_init_zone_range(zone, start_pfn, end_pfn,
>  					       &hole_pfn);
>  			zone_id =3D j;
> @@ -1257,13 +1273,12 @@ static unsigned long __init
> zone_absent_pages_in_node(int nid,
>  			end_pfn =3D clamp(memblock_region_memory_end_pfn(r),
>  					zone_start_pfn, zone_end_pfn);
>=20
> -			if (zone_type =3D=3D ZONE_MOVABLE &&
> -			    memblock_is_mirror(r))
> -				nr_absent +=3D end_pfn - start_pfn;
> +			if (start_pfn =3D=3D end_pfn)
> +				continue;
>=20
> -			if (zone_type =3D=3D ZONE_NORMAL &&
> -			    !memblock_is_mirror(r))
> +			if (region_overlapped(r, zone_type))
>  				nr_absent +=3D end_pfn - start_pfn;
> +
>  		}
>  	}

Hi Wei Yang

I ran some tests based on this patch and didn't observe any issues.=20
Thanks for the patch.

> Want to confirm, the logic in zone_absent_pages_in_node() only handle
> ZONE_NORMAL and ZONE_MOVABLE. So the assumption is ZONE_MOVABLE only coul=
d
> overlap with ZONE_NORMAL?

I think memory below 4GB does not include mirrored memory and 4GB is also=20
the upper boundary of DMA32, ZONE_MOVABLE may only overlap with ZONE_NORMAL

This is just my understanding, so it would be good to get a clearer confirm=
ation
from David and Mike.

void __init arch_zone_limits_init(unsigned long *max_zone_pfns) {
...
    /* 4GB broken PCI/AGP hardware bus master zone */
    #define MAX_DMA32_PFN (1UL << (32 - PAGE_SHIFT))
...
}
static void __init find_zone_movable_pfns_for_nodes(void) {
...
    if (usable_startpfn < PHYS_PFN(SZ_4G)) {
        mem_below_4gb_not_mirrored =3D true;
	  continue;
    }
...
}

> When kernelcore=3D[nn]M is used, the "highest" populated zone is picked u=
p
> to be
> ZONE_MOVABLE, as indicated by find_usable_zone_for_movable(). So looks it
> is
> possible to choose ZONE_DMA32 as ZONE_MOVABLE.
>=20
> For kernelcore=3Dmirror, we want to eliminate the complexity?
>
> --
> Wei Yang
> Help you, Help me

