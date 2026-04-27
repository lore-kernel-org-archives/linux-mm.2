Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25312FF885D
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 00:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A5786B0005; Sun, 26 Apr 2026 20:31:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0560B6B0088; Sun, 26 Apr 2026 20:31:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E392C6B008A; Sun, 26 Apr 2026 20:31:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB8786B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:31:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 60B828BFF6
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 00:31:45 +0000 (UTC)
X-FDA: 84702457770.23.FE81027
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf06.hostedemail.com (Postfix) with ESMTP id 874F5180002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 00:31:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fzYj5TdA;
	spf=pass (imf06.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777249901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdZZDlQO7EEE5gNmddVnhz6nq9ApBOqk/WAhmklKK4A=;
	b=S1Jd3RC8ZCEBguqoCAzH6MUPG0+uiL4uBpXmQUQW6v/x4mux3MgM/HZQKvwVZ5qg4GEVFk
	WykWJfMInuycB5KZe5XL6aoCkQ3jsCGjelk+JpFma/g2u86jWuIoXuoFsRubdIYHzaFn2O
	lfYQ4qQRLfF1Q6EDYP01d9gteLCiUxo=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fzYj5TdA;
	spf=pass (imf06.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777249901; a=rsa-sha256;
	cv=fail;
	b=SfB6yyFeta4Z6ckgpHY+PbudHq2iXGLEs0+KqweI+uyWgefhiPibELivXlt1j4FVJBW08i
	D4boUGmzQBjk6cyuNwupTxefK928Jud1j8F7ss1/1FqXN795aJC+kOBO3oLaCuELBIN+oR
	o5fDxNbFEzOhGv8SZMCtN25zQ+h/pS0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777249901; x=1808785901;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5zh8VtWHSts6Cbb8MtKW6I92aGzrU1RGd8YdC+sh+bc=;
  b=fzYj5TdASB1XYFlpBD//acjMoNiuG2zG8yfsJVMORmVSD0boBJwyU2zF
   VnsOisfKVGKO187PLSRhoUvu1YVqOBIk7cvH7Rzgv7J/Jx7JLwLy9wqdK
   GXFIC1OoNi1AckO9vx6+BrKTN0j0vaX3oK+I5nIOD2Sj1kprv2AmX1Mcc
   y4WIwLmxENPQ7pdTU0CnGx96WI6vMK3CTL/uLdJRbedH8PMMj9s4D9QAC
   cQoWmQHlpUEwsVQRM9TcxQyVR/vI07zV/1SJ44oC8++zzBnLPYrew3N/G
   lD44QV0JqTNb7Cu8h1BthqUPThBNR2d9EEFo+O/xR564e2ve9VjT1TU/M
   A==;
X-CSE-ConnectionGUID: Qwx/BsHzQpyQBq2UpLTCzg==
X-CSE-MsgGUID: FkKw5FTfTZKbM5jUfHW85Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11768"; a="78154052"
X-IronPort-AV: E=Sophos;i="6.23,201,1770624000"; 
   d="scan'208";a="78154052"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2026 17:31:39 -0700
X-CSE-ConnectionGUID: qWlntJ2bTBue+Y1z+XwQJQ==
X-CSE-MsgGUID: Dv43Sd2nRpCmAITkk82FYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,201,1770624000"; 
   d="scan'208";a="263883885"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2026 17:31:39 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 26 Apr 2026 17:31:37 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sun, 26 Apr 2026 17:31:37 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.22) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 26 Apr 2026 17:31:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I+abwBPJL5vDcmxtvCJegHxidq4pZhkpz5on1okTekE+06uo2H7Uh37nSrLeP0JJpiiHNTuqBOMu5j1aa9AK7+pcPgLan/wgVyo7DMNzHoEHxAOoPFa1O0q1w0tE6PdXz4MdPnrXBP58aXy+kzVniyJU493GKC8fk13FOAv0xmTI1CY8jwTw9FIsM2opeNvZAR82gdaspu9MG8NB3+xughuHW/EW849MLhV3CsJdixYDIlzJiaR3YvLUgPGDZKR6IPddSTBMpsL2rZbEczOp/3ObPa0H3drxkkHxxgmFBra14ZcCd36p1QZ6fC+N9QMGNbtFQv9Ylw0SPaELkxsmeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kdZZDlQO7EEE5gNmddVnhz6nq9ApBOqk/WAhmklKK4A=;
 b=eJlQx1+OfhRu/EaGuiSFRIdzhWZbZ5mmyx38r4gpxIGb/GvKZEFhbaZtpCg6msRlwvKxCQZLmsK1Kap9vkF/0qHShKDA4jvplRf+uU3mfGlMZkg+3/7N7RkD34st9eTiSi64s+/zdb+lBzEvrWvLQ2/rzHHZbHGIik0hyfiq5gBOtrm7/RiuICLi3KDMC/sRkvmUH9BpzZCpbEh+LOfwYAC5kK2PAabpnovYP2Ce8KQkpnMqrQeTKUNbblMz9Di1+FQD2ibuJ7i07CSx6QsVgHSKX42AKkipX10YKIGPQLLHnj4yYJhN9XMZcE+OoySMO02jEOhqur/Ae48TmUj9ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by CH3PR11MB7769.namprd11.prod.outlook.com (2603:10b6:610:123::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.12; Mon, 27 Apr
 2026 00:31:27 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%6]) with mapi id 15.20.9870.013; Mon, 27 Apr 2026
 00:31:27 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: Mike Rapoport <rppt@kernel.org>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>, "Zou, Nanhai"
	<nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, "Zhuo, Qiuxu"
	<qiuxu.zhuo@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>, "Deng, Pan"
	<pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 1/2] mm: move overlap memory map init check to
 memmap_init()
Thread-Topic: [PATCH v4 1/2] mm: move overlap memory map init check to
 memmap_init()
Thread-Index: AQHc0Y4h66ZJRC45aEeUdFXXLFyV9bXvgSgAgAKVMVA=
Date: Mon, 27 Apr 2026 00:31:27 +0000
Message-ID: <MW4PR11MB69365F293A5CDFEAA3087AB0A3362@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260421125508.2317429-1-yuan1.liu@intel.com>
 <20260421125508.2317429-2-yuan1.liu@intel.com> <aeyC9i2TziSzY8_Z@kernel.org>
In-Reply-To: <aeyC9i2TziSzY8_Z@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|CH3PR11MB7769:EE_
x-ms-office365-filtering-correlation-id: 291f1113-7068-4d9a-0025-08dea3f45201
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|56012099003|18002099003;
x-microsoft-antispam-message-info: NVTBh0JGsEon7ZGUaVQ4RLvHjdF5C3LQJvLpAz0/+4VWGfYYhAJDQ69elkpXimpU5G3El6aTJwHh/You+tdG9tIUkZbqIkQx850hq+mOuCBeAETmTy1wkP3zuNrCrFJ25SVlSBdF2CIhYeTcoZqNdr4BVzz7BTZ4EL+Dp5F0fmivU6yPpIylHPWwCE65IFKYsPXCAy8eEws2UBPJIisULlz7Z/njRXCihEK0uCGLM+SbEhIpups0/GzwZFPs5SH7LlrcTsuUnMDdLaFD7UBJgmnZ3FhwmEXrbe7gIM53mbHAHaroO04aOT0g5vaig7rYaadQTY/3FJVQW8L74LIOj3iPQPdO6zUde7dDPuI5eOcsvI3mT6Pj7tXDV2Zch5dqEtqAb+ERv+9whUxZzRP6EH64RkreBgOsNFrMAAHGV++133SqiEMMRQ7aDKCpVRo/mjY8DwfGWKvJisljiQd2Wb6M3qYWSqWWqpG+COWqNTXiL0gVhNKW5xAOjanU5tlpabI67pP0jEhy3qIVF8rrMuxuYgGoS1qaVCexonvXqOt7evvgY9AIhAOBsukjL4NbF+cd8ATY4gzuEVyTN+EdtZxevGVx2mdWcSKHcWRzCQOo+RlYBYv6RDFs9E4sUzTFi1Yjl2vkRQo/TgMfv8TqDMC+bN8FxYaf1cEHSCB0H1wqo1Tw+Vn7/AylXXLrPFOqpuTEcAYnGiupmm0+r7ibuqA4OQiYVOm58iXKRo3pm5XRZvwlUZ11IHyRk+nyH5MPN9DHZQWpvGf96m8MVSjMPhAO4gWRYVNSjNSs+Yo3ulM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?J9hL+E8JDGU00goyf76Xil/i7q9cYDzcbs96qPftyYjLS4A2+t2cGOjBXiWS?=
 =?us-ascii?Q?79IE07bSYTkM9435QFNoLesbbX0ZzndwC5ktsNOptfUCGtd9+EBMxH2WWYOv?=
 =?us-ascii?Q?a2xH4E2yRbfNlQ5PTUbmBOCMWuaT3TbX4TNjCGqP0pg2uRol6JtNtT6GU+IW?=
 =?us-ascii?Q?0xTgzmcabut6IlarKhoX+rArEpwH/+jz09B0OeJsNuThPfU9JfkbB6ohTHV8?=
 =?us-ascii?Q?NQqWJFyME9zM19eyhXF5NRojdvfCqO9yY1UIjjl3gDHGRAIuowMZLyI7MRix?=
 =?us-ascii?Q?ZwlMy6DWAqz2VE2os3Rki58L3SBNJJ1axP9XZ1/55sR4ILnXG51GDnKF/O1X?=
 =?us-ascii?Q?zG9MR+LoJn7B+GIWwSgeNh6NL3qwHfKWWxDvWtsSNYAUsB65kUMNjufhlbVy?=
 =?us-ascii?Q?mBSSk1FwCIbKjfR5PEoUnpn8EeZ4pOOdOcJEmu7rX2sgB28Bzgm5MscTwf8M?=
 =?us-ascii?Q?sFIAtbOzKO/VtBmGT8k7aipIZ3zK8+qmUPw7z7jFYcRbTJPVR7SIAmFMyV22?=
 =?us-ascii?Q?J5s5B7K3juwskSkNkW4+70autMaVp9a++QnVXdhuVDpHk1v0hQ4nfqOF+IpJ?=
 =?us-ascii?Q?QycDwMS7mtyLOdjivg2G9gQdlC4wrk8jqN7/P9lFV8xmFiMZ9fyqmLFYFIsn?=
 =?us-ascii?Q?Jj1r4Gv2p0YebTM9YiB+iSaQk+hcaE4TBWcVsvI9utdYAQkI3D68sMxK3zrq?=
 =?us-ascii?Q?jQtS/LYDJ746zwZbJtDADHp4OT6SMEjxVX4KpBSNUfpstaqPzxwDCPuWYD2o?=
 =?us-ascii?Q?x12vlHadxXn/zmlx/A4W6X+/U3EEmB6lF09UG5DJW38eaaeAf310AkigrC8b?=
 =?us-ascii?Q?qA51r5JU5Xu9TSmFZdIDZuh02YsFC2D0WOzyFUOoEzDwdxg1imK9kwKzZrlZ?=
 =?us-ascii?Q?ebBitTaS1EDZiJTbgN6lUl0Dyr53KAjRIYlL03NTKv7JGGXZs3mEmbj1J3id?=
 =?us-ascii?Q?idqrPkNwjitXI8rVBXQTBRoOwX2IULwT3jf8M5XkcsKtyJvy3rEGIstWsZA+?=
 =?us-ascii?Q?iHwS2GMm5/7Z4b1sQrG9ivF3WLwK8sF3jAEM3lhbZp+drYFIkgY3/LSLxSYx?=
 =?us-ascii?Q?EXQV6jOOQwfEgFITxiM0sQ4ulWMB/w6u4DZ+XvWdXP/EjsMFYD/Y3B3aid9P?=
 =?us-ascii?Q?HYGZ+mXvcxSRBmUS6t88lTmRF4TWr5kjIyRY9O9L4DS+mvZONbkfOXgb7rii?=
 =?us-ascii?Q?3klls1V2q+HpYW6iC0RI249W+mXdmC48qfYtRAbeVGvp8CtjEZTwX4MgIuKM?=
 =?us-ascii?Q?O/LJElIDuo9LADtoz5q+N/WrRdijqxxMK+OONIUo2fSEHt+FXQXEt/l2Jw3d?=
 =?us-ascii?Q?DOz4N1Um4kXDLIRDQ1hhK1bBNvE3/bZ4f8Fu6CVgKPYoYH14bEOV+yRy4ory?=
 =?us-ascii?Q?3DzWfbBeldzM9YsKsrpOrK1+JJFFPVR/sgKNG0xHqMfBRaS6aAs43YFa/O1o?=
 =?us-ascii?Q?59dd4HhFd3XnIs45/bK7rP5DuDhuwHRmn8RSl65Q35N8JnXVJDPlnRNA953p?=
 =?us-ascii?Q?/AfN9b8bToLN8Y0R5zRLSPGFXonvtopZoKv6RQwMKkzERSVZnbQ4BiB5voDr?=
 =?us-ascii?Q?sJl0rPeHUkO0z2pjnkw2UenN86UChJOkaK7Ozc/rVq2sgt0yitXx+ojLOvN3?=
 =?us-ascii?Q?0usY4dIIq200v2N19eQvZ0ChXo+LElE7PlmbFVjgVre3n/4SYAZS9PVqTYxV?=
 =?us-ascii?Q?g3ZmjRwo+Y4uRF7feD9ogZuf9aGx3Ll41nFe4S55WbYUdN6F?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: kqv5fSrqXMo95PO3TOaD4hLgZH4A5Y8/NYdlRzDylMyVGgl/EmqA13AfbADae+IXAxPgN6rzmPuu9+3IYJVnkHzqVrO8kPWLn+AtwNOq26wk+UXKR/HPVkXPSq9jJ3imO0fRw5NvX+zjzlcqMZcM8Jn2FrE7JYcYYr9tiCNIkT0XqtGfzwwEpcGspl36QpEl7rxBE1DoCHmSvUXLqHo9qimRK5HSJua70eor8gmkqAPoe35aupmUlvr1XZFzJLV3Q9H2QcFnMIAN1YDqpJ/YTZhrtaSicmDPpOhHDAwPy2i13BV9OyErg+YFSMSPYN/7pkQXf5lnUSojh2LOGMgEPg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 291f1113-7068-4d9a-0025-08dea3f45201
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2026 00:31:27.5998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lDUHVJAVifAKrBXn0YTXZrUp6wn35qxVTAfTyPz0RfQj8aBrgm/OzfuDtXc7ySoXHFFNu/UDetbrQyfCxqYEkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7769
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 874F5180002
X-Rspamd-Server: rspam06
X-Stat-Signature: 95hga1gjfaqa6fq53cfoq3w5f6syr57p
X-HE-Tag: 1777249900-938916
X-HE-Meta: U2FsdGVkX19bGl1CTuHdGRTqI6bRieQ3+ggt4+BsdlY0kj5g84FAYuJCodZFd+JKA4G59G1ZmJKd3NyW5GGd0k5FOQJekyVH/mvfQRrsr7dRGZfM1OYJvOqAlOvbP8IDks1CIhbzocvcuFGUz6xfGtdnPzy/yz5C1NjQQLI0FzODZP4Ysh5pEMW5AWOHwcK9mDZ1iySxvznf7/wcqT49hx8PTEN5Q/s2C+Zlz3lQ0gc7gLJjDTp0QLjL80XFPD43A6gia4mMyEbw5HrRSeQPwRhYYs1T4zWkxKzXa60OoEv9t4fyyLA6sSZqJl2qZyFytVVbVDqvlr9hY0AI10t08b/OL8M1QVnjERYzWl0tN4EZBxCXO0nzMwrX5TTa0Hxie8Wirvbo6NNmirgzRdHP9bbu2H/eIYPONrEsN615nTB/QdYFkraAJCASaBnNjxw/azi03mCmdCxpC02NmNpWq9Ls/IZIZLl8YMp9KvbJpPsS0p0UO/TJmDiofGI0iT5WlZf16w9c3Vrw8w+NqOwDU50/ep9b9upDAAfI10rSnG7QY6n29kI0UdsLmQ2Hspn75DaU7SW4UNk4X1hDxWvI/Pkp1l0oxQALvX56/b4QIuMVyd4JhO9P3TEqtLJZfZuIOpVBBJ1TNy8YWtw2CiQHvTJu2posfv2plM8NCWszPm6M66spoGZLJ7YONG2jUAB1/XndlKeOv+/l7mdE+PtNYNFAzMZprnWRSVwJWjpSjC2xb7WjJAe/eGqiSeMJqC4H5t/74oxwCrKsUD6VJnAsji5JVaUqHdbJK/x4RPFNYi/UXQeFtL/6lOAF+/YQaH+6F1RzpvpNKLzo1BYaIjokyAm0Urp3zGOqIaw5XD+B7Db+cuai0V8BKJFTC7WJ3IUFsKfxI0VHWzx5KwoBzsLKGl8R22XiZJJmthGXJ01fqa1pjmwju9KibBmzRyrp6X+hiZdSDt8780vcRdr96Q9
 uBgpyAMt
 zNiU7rXTO6fIm4fVb06BBSTH+ZlQPx6rvFndD1wP5hmIWuiQ304k5Ephd0EdAe1l0dNgQJmzyHT1zIWTU7o4qXh60guXhdIS2xZoAhxncIrq3fUtzElo3FN9Z3ewq0wy4WtGc07COfryhkAnxWQjvjdCg1y7fMWkI79g1OPWhVmFi02lAR/Ye//29n0+8ShtqjSh182+PRDukhpUx+7yEZJ2llRg9Ts7Ek9WlDaIHoLTskm6m9v7Bcmxm4SLTEhJZbMwcRtdT1fzqAd00Wj7oGqVDZpWl80IZzHQ048p+7hR5bV5EeTGXEWExwvuKuYQ7EcWAI4vnsZzKovMzCXtApN0sg2K8Dhc2mS+ooIZ7hODJEjdp87YGrhg8bc8+wJNRLPtBe1rks/jCgt6IZZQ8XxtDkMYgIvVWqSZsGjSKmJehd9CYWbAwAbo7YmtSWUK3ZsIprJ9PkKGNADqQWdBiPSfseQgDO8ez3Zpt2HXRhQR3ZN/F4g4kK6f5ZOEfn+RaHg/7M3mq83e/qL2TMO464KI33ZqIud/GIqNVn7X9ozu7DjeAQSDWUw76LS9AB2tcfJeYwh4PFL6uPijGSo9eGlWc71xyMHacewmz+TcIx7ONGaHZTrBVQuACxXZSlTBVUvLJFS0F2ldHgh8n2kPrFVr0551IiyU92wiI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Subject: Re: [PATCH v4 1/2] mm: move overlap memory map init check to
> memmap_init()
>=20
> Hi,
>=20
> On Tue, Apr 21, 2026 at 08:55:07AM -0400, Yuan Liu wrote:
> > Move the overlap memmap init check from memmap_init_range() into
> > memmap_init().
> >
> > When mirrored kernelcore is enabled, avoid memory map initialization
> > for overlap regions. There are two cases that may overlap: a mirror
> > memory region assigned to movable zone, or a non-mirror memory region
> > assigned to a non-movable zone but falling within the movable zone
> > range.
> >
> > Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> > ---
> >  mm/mm_init.c | 37 +++++++++++++------------------------
> >  1 file changed, 13 insertions(+), 24 deletions(-)
> >
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index df34797691bd..2b5233060504 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -797,28 +797,6 @@ void __meminit reserve_bootmem_region(phys_addr_t
> start,
> >  	}
> >  }
> >
> > -/* If zone is ZONE_MOVABLE but memory is mirrored, it is an overlapped
> init */
> > -static bool __meminit
> > -overlap_memmap_init(unsigned long zone, unsigned long *pfn)
> > -{
> > -	static struct memblock_region *r;
> > -
> > -	if (mirrored_kernelcore && zone =3D=3D ZONE_MOVABLE) {
> > -		if (!r || *pfn >=3D memblock_region_memory_end_pfn(r)) {
> > -			for_each_mem_region(r) {
> > -				if (*pfn < memblock_region_memory_end_pfn(r))
> > -					break;
> > -			}
> > -		}
> > -		if (*pfn >=3D memblock_region_memory_base_pfn(r) &&
> > -		    memblock_is_mirror(r)) {
> > -			*pfn =3D memblock_region_memory_end_pfn(r);
> > -			return true;
> > -		}
> > -	}
> > -	return false;
> > -}
> > -
> >  /*
> >   * Only struct pages that correspond to ranges defined by
> memblock.memory
> >   * are zeroed and initialized by going through __init_single_page()
> during
> > @@ -905,8 +883,6 @@ void __meminit memmap_init_range(unsigned long size=
,
> int nid, unsigned long zone
> >  		 * function.  They do not exist on hotplugged memory.
> >  		 */
> >  		if (context =3D=3D MEMINIT_EARLY) {
> > -			if (overlap_memmap_init(zone, &pfn))
> > -				continue;
> >  			if (defer_init(nid, pfn, zone_end_pfn)) {
> >  				deferred_struct_pages =3D true;
> >  				break;
> > @@ -971,6 +947,7 @@ static void __init memmap_init(void)
> >
> >  	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
> {
> >  		struct pglist_data *node =3D NODE_DATA(nid);
> > +		struct memblock_region *r =3D &memblock.memory.regions[i];
>=20
> Please move this declaration above struct pglist_data, let's keep reverse
> xmas tree where possible.

Sure, I will refine this next version.

> >
> >  		for (j =3D 0; j < MAX_NR_ZONES; j++) {
> >  			struct zone *zone =3D node->node_zones + j;
> > @@ -978,6 +955,18 @@ static void __init memmap_init(void)
> >  			if (!populated_zone(zone))
> >  				continue;
> >
> > +			if (mirrored_kernelcore) {
> > +				const bool is_mirror =3D memblock_is_mirror(r);
> > +				const bool is_movable_zone =3D (j =3D=3D ZONE_MOVABLE);
> > +
> > +				if (is_mirror && is_movable_zone)
> > +					continue;
> > +
> > +				if (!is_mirror && !is_movable_zone &&
> > +				    start_pfn >=3D zone_movable_pfn[nid])
> > +					continue;
> > +			}
> > +
>=20
> I think this:
>=20
> 			if (mirrored_kernelcore && j =3D=3D ZONE_MOVABLE &&
> 			    memblock_is_mirror(r))
> 				continue;
>=20
> would be enough to remove overlap_memmap_init() and keep the existing
> logic.
>=20
> I wouldn't deal the theoretical cases Wei mentioned in this thread for
> now and prefer to keep the things simple.
> The assumptions that mirrored memory spans a contiguous range below some
> limit and that mirrored memory is not removable existed for years and I
> don't see why we should change the logic now and complicate the code for
> exotic theoretical memory layouts.

Hi Mike

Thank you for your comments.=20
I will update the next version based on your suggestions.
=20
> >  			memmap_init_zone_range(zone, start_pfn, end_pfn,
> >  					       &hole_pfn);
> >  			zone_id =3D j;
> > --
> > 2.47.3
> >
>=20
> --
> Sincerely yours,
> Mike.

