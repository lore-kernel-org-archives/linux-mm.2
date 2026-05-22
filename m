Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFDC0CD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 07:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 516236B0096; Fri, 22 May 2026 03:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C63C6B0098; Fri, 22 May 2026 03:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38CFF6B0099; Fri, 22 May 2026 03:43:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 25FD36B0096
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:43:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB792A09B5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:43:52 +0000 (UTC)
X-FDA: 84794266704.24.7D59621
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf06.hostedemail.com (Postfix) with ESMTP id A333C180004
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:43:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GM9Q6umz;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf06.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779435829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxbwKlAj/35n345AsCoQt5nPZwamyoK9yOfDsIFyqHA=;
	b=8cFtQQYaxgqEZuHiCeJde5ySpdgpn44KR9aTgz6EWcjAZJV3SX+KL1V2fEshEY3hl2x3ZP
	1YsGfN0zBSgZJm6XojcmcguKOaut8r7DJgtBl+aOwXeeeU1N8IOh2+9ly5cFIIFLhll25v
	YZ1OMCpTQ4fH7/rIw/mmtnYaZg6R5YE=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GM9Q6umz;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf06.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779435829; a=rsa-sha256;
	cv=fail;
	b=V4rsWE7zHN2+IOEQh3z+n3kigOEMLQGjcsljxD/cEet0+vZ6d+RJ7Rxi5YObNtQ7fFXflf
	vdWSARgH6T5o/qDG328t25Gx2oK2tS/hL6kYocq/NHiEa2V7xMx/KlC4TJTCyBskQhR/bO
	mL/hlpWsYndETSiSEq5/yEu9Jixqr3s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779435828; x=1810971828;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=femMq5fztIUHn/LdGNxrYqLZNItSRD5b3Cnu1/IdOdg=;
  b=GM9Q6umzbzbaNwlT4BbiQRg7C4k5M858f56IX9Ug5A1KkeXUfyYdHShd
   WYJD6PFU//qEBNrSfGAsQIFvwZNdZYSU0bIHdB9rlmEp4yB+uSEIRPp/4
   3BfQ0SvmacJMT5vmdWdkxU7HUYoJVuIbGg4c3dVtsa5a/TX3Yh5W8m4hn
   e9PaLUJDYHOlEPXpgb8Iy866zgSu2Ap73Q1wzaaWQs+VJbmFvFZWhk44w
   l3+Sp/Xf2N3eMk9UeUdzzG5lc6DZn5+sVaaCYF65mxZiNmwB1k6xDO70V
   wz/zrs6j0wC/0iZcpSOppqqdYJkJ+A6243HkBp0yTwG71zgJ2JaP9q2Kg
   g==;
X-CSE-ConnectionGUID: hyT9Z52UQmCDehfPLNFQdQ==
X-CSE-MsgGUID: 7DTC7cALT1KERgN1xRGDNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11793"; a="80346273"
X-IronPort-AV: E=Sophos;i="6.24,161,1774335600"; 
   d="scan'208";a="80346273"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2026 00:43:44 -0700
X-CSE-ConnectionGUID: UcOaUxvZSUygpxDANnQRiA==
X-CSE-MsgGUID: 7BwxbJCxTYqzP7AAImuF3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,161,1774335600"; 
   d="scan'208";a="240717782"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2026 00:43:44 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 22 May 2026 00:43:43 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 22 May 2026 00:43:43 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.3) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 22 May 2026 00:43:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KU1y8vZIkEKd0/LEHIPZS9/X1z5hy0yX0MVNthJBdwPnIqt7xsRN2hREU447Ftr+BiUCQUvbz6rKJyYkZ0/vO7IjkBrOuFlHx7ABozVcPqKHZiy3cE86CLQQaRmsozP4evfxVnYaVdW1WLp9sLHQkZn7RVX0gdJzGMUe1/Usyw/EMtBMf9BxyXo/YwAGYMwIROCUYm1EgJQeXBhXroTQ6ZrUubWCwcrgtt9wmiMgiSzgncR9Hgp+ScCFSE3mzL2SP27B4egOBdtaolgTnX5o88EUccmfv70/CE5UzFfVc3YLwwIOrAPov4am+3LrjnzQXkcuopydyS2YLd1PLSa3Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kxbwKlAj/35n345AsCoQt5nPZwamyoK9yOfDsIFyqHA=;
 b=jrsYxODlZCF3LPCLcfriTpWCj78sjuruzXso4/wLmnLclSBF/fykCnvN91FpEfECDjwj55KW/yr3LMGmJE7Ri6WBODwK7ObMNl0SQJMex40J2ykbA/exZB6j22M6NUJHWCmKGJ5h/tAGlzHWQCWgarl+VZCmVXhIQ/LdeyD/Crc59aATAcjlkM0DmjRsxsxdrbpo+4u8ErdyT6km+6qsvJlWm7nrE7wAg9vfMBMLd+70AdCfxCM6G7WtLL31T/2nb0Pb6djznw2358pyjw2AYwcw+np1IjkjD3cAbEze9/XJGS6H7PRBrqExbKhu+cnRaPMcTrfTGBiZyvAExj2qNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by CO1PR11MB4850.namprd11.prod.outlook.com (2603:10b6:303:9c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Fri, 22 May
 2026 07:43:39 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%6]) with mapi id 15.21.0048.013; Fri, 22 May 2026
 07:43:38 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: Wei Yang <richard.weiyang@gmail.com>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Hu, Yong" <yong.hu@intel.com>, "Zou, Nanhai" <nanhai.zou@intel.com>, "Tim
 Chen" <tim.c.chen@linux.intel.com>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
	"Chen, Yu C" <yu.c.chen@intel.com>, "Deng, Pan" <pan.deng@intel.com>, "Li,
 Tianyou" <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>, "Zeng,
 Jason" <jason.zeng@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 1/5] mm: move mirrored memory overlap checking to the
 outer loop
Thread-Topic: [PATCH v5 1/5] mm: move mirrored memory overlap checking to the
 outer loop
Thread-Index: AQHc6DwJDfX3zlWKz0C/zOkb6gw/RLYX1JeAgAHOQPA=
Date: Fri, 22 May 2026 07:43:38 +0000
Message-ID: <MW4PR11MB6936A4383B3EC638A4B24ED1A30F2@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260520093457.3719960-1-yuan1.liu@intel.com>
 <20260520093457.3719960-2-yuan1.liu@intel.com>
 <20260521033303.7jg66h4sxwi4l3cm@master>
In-Reply-To: <20260521033303.7jg66h4sxwi4l3cm@master>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|CO1PR11MB4850:EE_
x-ms-office365-filtering-correlation-id: aa7d477b-b473-4e53-f224-08deb7d5d690
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|18002099003|56012099003|22082099003|11063799006|6133799003|4143699003;
x-microsoft-antispam-message-info: h2ubenU4hsHwUpCU2pCe0cvQZriiD7eIWUqeuOKPvqGDdQfz8HOLZAZTsKJ14zO4YcX6cpzweKCk/iKRsXR0BLkOyyRAcIw6XxkaK4lfi9axUyGDGzun+9pqP4KMY7g4acglfgrkGGMQOh0eabtg5bmJpBDcRosOIfn6Vluz+dOxGSHQBwCBTKMtnavqbzYoQPcjLU4j3yAQJx/6kRi7tqR7OBm3pu4FPq2gfe78pcB1uvCAYL9+kNzRgNQV6msI2vyvwymypPVZitlimIkrzRXZNogo/IhvQPI6KAB5e8RpQgS+oF3eaNXrkq7FRNlBG6YhrpEVp7QybLsxGa+QheMl9xcgicL7LmdqhjOrz/1IIQTmaiAbgdBdehL4rI+1D4zAGgXjfm0rXhdGmswJE3zzi/yB2yExGN37+yXnVy888br4Lqg+Y52ZIP/GOxasWo8vvkXYDaIHunTTFl3auPJ/nLA4rUcWn3qaWPIP6EoNAwp2T26O9StCes40aHAsTqcu8vqQxtMo6uDnSRMpYjmuZ5HoPhRtdSbFeMBOpM5Tf+TIvspGq0z2b33gaVN2/x4T8h/HkrhLuMw9GRg1Bl8BaVWRFum1INR7fckDFTrKuf9FUJwwWK1+7vxmm3DNMrjC9yd30NOm4LOaE4J3+gVILgYXfh13GLR+qehrtDiNlMQqusQnTklrtuYaGMO8RRSerzG4oDSdNnmFZDh70U4nAl+edW3X2ODDtuN4AxKr7a591Omm8yAonp1zvS9u
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(18002099003)(56012099003)(22082099003)(11063799006)(6133799003)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?94wtBeb3KuD8mvfMIERSPjZAwpxKaSWSJUHGJkPjo3RWSFPIYdPpYFlGsvxL?=
 =?us-ascii?Q?eyfEElG1v+M2PcSvYBFjdjRsyfBL7NrhPEAaQsYbXMziMb7dBQ6/eMK4efZP?=
 =?us-ascii?Q?3TFHrHoA69EWSYrmuze57Pjr/8BbIJGngN560TLevrjUFH9n8mykOGpvUacD?=
 =?us-ascii?Q?olmpHefzfXGfj1tv42jebYHQq9zDUDdqt9T3YVvv47CPqQtOWtarQr1kcdAt?=
 =?us-ascii?Q?QtJ+omAKMS21ly4SwP+VfS2ENsNgJOxI2Y2ZebszbTZiWjAIGiqCzYy7F1RF?=
 =?us-ascii?Q?iG7w7n39aJkt8S4S2yJko6sgK1vewDiMzy+aSUWV+hQGFhgz52wMcbejfCFO?=
 =?us-ascii?Q?FV/0nMlY7SJRDUod/TiRN01riJ0PnTG4gh+fZN/lqO5teciw0+wbNejNaZ9o?=
 =?us-ascii?Q?/LSl1DR86m/sbY13rJmt4L9kJ1k9PMTGJuCSxcZUowO3PrkA5WZ/Vvwc4ts8?=
 =?us-ascii?Q?ylr4NfnYV94Cs5lUbB1qdRyickLZuekJ0a6kfBcs0WkrqzX3039W+q3kfXhj?=
 =?us-ascii?Q?tyVtjCqGSL8H55AWoKkWm0uRaxwVhJqzvw18AOJ7fTRr0pXyq4QYBEvHibnl?=
 =?us-ascii?Q?ImLpxd3nOSCQbk2iZ5LXLg2onWG4VE9hr8ufPoRE5SJPOShcwXnOk8usVTrf?=
 =?us-ascii?Q?VbTaXvOM2HykS6tVIgydhAP8ICL8JzZC2Gwd8kyo5abNeIaz0q6iL34IyM4y?=
 =?us-ascii?Q?YdXVgu2cfpajnUpc0MZXmlzs6pK+YfeE4zaKXZFlzBf1t2KElIeku5aX5mYz?=
 =?us-ascii?Q?oioBOBi6BlBIMWGEn+8h/SQKRCBvZOIaY9dqCOHEqIo11xJ0ahYSQkLlfbSl?=
 =?us-ascii?Q?V4PkducnI+3h0PdxjxsEOXj7m4srJ/2xoN1qj0ixu3t01duqmNLNHnI4r10a?=
 =?us-ascii?Q?6UJTu/JgqbNVhhS5CXMuaF83gO5JLq8Yz4iPM2QKdVeBJLBbhK64Eh8Jaz6N?=
 =?us-ascii?Q?PFqSDrjFcCGE2vOL28KHoW1zy1MKQeCrqbn/mDAHGdfGodsHgRbgj4uVvVfp?=
 =?us-ascii?Q?nx/EQFGFCJRcYCdLL2BeDUPSQ8r18k3tGpw4dApFVgjcSaZGll1j+G1Rbw1X?=
 =?us-ascii?Q?ViWpktpcL8nEGN1TBoKeSlB8E6In8tQk6iERL/l3XPTXy5UQkFh4HCGm7Fo/?=
 =?us-ascii?Q?40jVtYCCOuuKSRbtBC1Pp1iDFOnmk9OrAkXw6F3DWPAZiga7rewSSrzvKK5x?=
 =?us-ascii?Q?/A2qVvigfcuFIaOqBMAUPkNPgBjOQPfgyl6niL9bL2ga3QvTLvexrOFFGsbj?=
 =?us-ascii?Q?ytYibmksaPYOg+6iyRzpmNlULDELyHR7fcNWYyG/iGpKqgx+9/bxon6ksNsk?=
 =?us-ascii?Q?z8c7WAnHumegaY7QOcASVlcwyJmgOq10JVJCDhZ7YmcOqdPS9KfQJRv2v4RH?=
 =?us-ascii?Q?0DKo/szjkCB990Z5SBkUp9VLogCrk1qcGnH01RMEodvXpltSbHtYp6BFR5Rm?=
 =?us-ascii?Q?8ZLsR3LxtnNOF+kbfIPW4J+vhGGeHoTjL9EKIsZFjNN2BMGxzdrGjADDyz2d?=
 =?us-ascii?Q?CiGCp9MzvMyfO/mNzqcYVVMcFC/A3lEDLRmvRxfqIcepQAc26FDsktraH7Pm?=
 =?us-ascii?Q?IGHkD8wybPkRck/RgGjUje1RjaSjjv9qDfXYjXSJz9xZ19jlw6rFLkZvtvnP?=
 =?us-ascii?Q?6kb+0U01NcXj9J+StUucX+H6ITdZPFFkzWh9kP+5cj3Qojy539HhOjp9ELNv?=
 =?us-ascii?Q?EXOnz8eIZ+lxExGWzywW2aOOd+JKEn9BZ1TmvpPmqkmbrppO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: EK9WXUhd08DOIXVrQnhecryqd7CtHWkt4i6J5qekQvB23tfWhGjeEyI4Xe3EfeK3ko0xwnXpg+Drj6y6CXsKmo5j47UH8mHr8RKFliilCjEn7lNx5BnbJ8kMgnN9lwgqgHO8nNeQaLn+r4FS6scVtnv7ivUi/QDHwkCCdhkerLt7tR1G7qvzxz3X63rqnpmfzfLRJjFbxvaTELGXFcapgcsZtztYxiNP/eK+dR8Pnbw0BB2G957Zu+y9TbvRg6+VEGF+LnKM86+OUX8HjNamzc/bCMQDk3jE+tXqVb1fxOCYR161eHkfKb4JvISxO7VcKxWT4X/GHXOIwB1yJQPOzQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa7d477b-b473-4e53-f224-08deb7d5d690
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2026 07:43:38.8534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 94N8Rygf+BDzTtWqbEheYd4m6OHu7uIljTsXX/KDCHrsrG1YEPJjcWDwMJ2HoWGi4WTMh5ZssyUKPGovQ4D5HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4850
X-OriginatorOrg: intel.com
X-Stat-Signature: mgidcjeppio8msj89td64utb4a3yqz94
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A333C180004
X-Rspam-User: 
X-HE-Tag: 1779435827-582294
X-HE-Meta: U2FsdGVkX19maEcd8MTWTrG82edPQ6vgoCaw7xqkEKfrT2mnY98yElfH0DKOHkK2FJdOANv6rt7Iqg4VMbyyIoztUAwGp3jlHBhNxV62BjPgqzCaiNQQ0y8PpVJAODcQv6rl+4SdVzEYxlXnN0HRprkm5pCexID3dPZ78sP8jZ2D+NCRzzze+zCkJz9eLP1rs5SKkpg/Buv1/pZrhxpS+zWt78zMKypSaXi1z/xpnK1UIbITf4lO1m6gFzFDlSdpP+jbkg8BHhf+sqS3Fq/qkKyOScDXnwYr6TnlvaWx0GogaOol9CgP3wSkz9vy1HeOvf9CEtKtX23wLuag6q3bQ4AA+7UcqtONLUQEdAPV9YIYaYEHxK2ZvHx1XqsTCFWPbMiuXYkAbF1g2+2B1jZmUfGwXs3iR6bdWBFB3tBLk+CEcP1SYEfaLBVHw4IFvA9jqmh6cp2v4Sqr4cI3E39kyrLAvXRkEbtfwfizSxuj5qoUPaiEm5LJsqCGDQ9BGvx5/j98r+sd3Vmwbc/MPT/T9Ejx7pT3ny3A+4e5C8s/+DIFRnS65N+BVzTgvjbjqSRmpik6X1nE9zv2/ewmdaBTSUGgfN68J8mL/GalhstQtd5nHuvLYfjxVSRjANS3g1tPd1KUUA3yKaBi7uWpnYRa8NQWU/J1Tc9/OOBh3TM/3HS9nB3phG4/V8qbtlhuURyYKY/VSQoAmac1/Fg0YLu+sjrUSAwAzm37eNDw2TGLXbruucjIQ9AXjoGNbtcivA6yjGpdwqdAMxi3j9Mhphwufd7mIkyIwvZWe98Bf7UyiBvXFTpAoA2gU0KwVSiBUftI2ulJm4DoQNMQ1hkCZIkyXx6yYFFujLbc/Xfv9HHFe/CICoZFOieW2n5JiRGo4wS5M2DUKyPFmwl3NTh62UXIBTZ0ioUzXKQF5hcf5d9LLPdx7zCMGZ0p7IJSuWSlLUPjbjzcCDLkRqj3M5kPICH
 9JQdEURD
 mY2hnq3wrkZevbxpVolBWEMDzWpomtr+vi50OdFGBFDAb/SuOB8bsViJg8ubB2L4W/FSd7WzORGf5HMal18k9WRL2vUFFti5upOEX5LKGSJwqPbyGCXFQrvK1hgGKRLX2xUp283KHi6bMj11pwfmWuScEhBJbqPd7QeHLHe8oL0I24wy9re8ggjIRx2Mpuac/ea0ASOXCBz1ahLgHkZmysG7VrsvK/cag6jn+3v7E9zZb+Va9lmCgBj7CgtkD+sMUL1EqDFdrkqRzaUUV3CGFLYKBhErbum0djhEPeLFlyuD8tYR+8HPl5qq4PHTHvTPtKDrZes6M5HglVnOj8Lm2nUkCCUuNbuduRfaCGWtKi2sDX3TIqHSLQcozFBNqsfs4HTFUWk1fuWGIG/Ka7OHiAZJ9OpfQxX6TkzKdBQWX28DEsj0tZgdtCHPiUmrW92wM7KYdY0AkOGP+Sj5wJNPtQr/OgDMtN0C0qw99n4vDK5Gp7G5XjMOTOzYfJYIIgOu2uiNvXJ/3Wmibmfv/MP/wWYNl0EMzbJtCwK74hU4eFFqIUwjvvsCHmGaEVHP7u4Ufb4B260c6gg3edFr+2Hmpcp5Q97G3dwq6Um7NmbE701XiwXkrjeo9NvskbqgIdqdf5yzt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Subject: Re: [PATCH v5 1/5] mm: move mirrored memory overlap checking to
> the outer loop
>=20
> On Wed, May 20, 2026 at 05:34:53AM -0400, Yuan Liu wrote:
> >Move the overlap memmap initialization check from memmap_init_range()
> >to memmap_init(), and replace the per-PFN check with a memblock-based
> >check.
>=20
> The description is a little simple.
>=20
> Even I know the purpose, I feel confused at the first glance.

Thanks for the review.=20
I will try to rephrase it and provide a clearer description in the next ver=
sion.
=20
> >
> >Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> >Reviewed-by: Jason Zeng <jason.zeng@intel.com>
> >Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> >---
> > mm/mm_init.c | 29 +++++------------------------
> > 1 file changed, 5 insertions(+), 24 deletions(-)
> >
> >diff --git a/mm/mm_init.c b/mm/mm_init.c
> >index f9f8e1af921c..24e103a402b0 100644
> >--- a/mm/mm_init.c
> >+++ b/mm/mm_init.c
> >@@ -783,28 +783,6 @@ void __meminit init_deferred_page(unsigned long pfn=
,
> int nid)
> > 	__init_deferred_page(pfn, nid);
> > }
> >
> >-/* If zone is ZONE_MOVABLE but memory is mirrored, it is an overlapped
> init */
> >-static bool __meminit
> >-overlap_memmap_init(unsigned long zone, unsigned long *pfn)
> >-{
> >-	static struct memblock_region *r __meminitdata;
> >-
> >-	if (mirrored_kernelcore && zone =3D=3D ZONE_MOVABLE) {
> >-		if (!r || *pfn >=3D memblock_region_memory_end_pfn(r)) {
> >-			for_each_mem_region(r) {
> >-				if (*pfn < memblock_region_memory_end_pfn(r))
> >-					break;
> >-			}
> >-		}
> >-		if (*pfn >=3D memblock_region_memory_base_pfn(r) &&
> >-		    memblock_is_mirror(r)) {
> >-			*pfn =3D memblock_region_memory_end_pfn(r);
> >-			return true;
> >-		}
> >-	}
> >-	return false;
> >-}
> >-
> > /*
> >  * Only struct pages that correspond to ranges defined by
> memblock.memory
> >  * are zeroed and initialized by going through __init_single_page()
> during
> >@@ -891,8 +869,6 @@ void __meminit memmap_init_range(unsigned long size,
> int nid, unsigned long zone
> > 		 * function.  They do not exist on hotplugged memory.
> > 		 */
> > 		if (context =3D=3D MEMINIT_EARLY) {
> >-			if (overlap_memmap_init(zone, &pfn))
> >-				continue;
> > 			if (defer_init(nid, pfn, zone_end_pfn)) {
> > 				deferred_struct_pages =3D true;
> > 				break;
> >@@ -956,6 +932,7 @@ static void __init memmap_init(void)
> > 	int i, j, zone_id =3D 0, nid;
> >
> > 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
> {
> >+		struct memblock_region *r =3D &memblock.memory.regions[i];
> > 		struct pglist_data *node =3D NODE_DATA(nid);
> >
> > 		for (j =3D 0; j < MAX_NR_ZONES; j++) {
> >@@ -964,6 +941,10 @@ static void __init memmap_init(void)
> > 			if (!populated_zone(zone))
> > 				continue;
> >
> >+			if (mirrored_kernelcore && j =3D=3D ZONE_MOVABLE &&
> >+			    memblock_is_mirror(r))
> >+				continue;
> >+
>=20
> So you have figured out the memory layout of mirror memory?
>=20
> Would you mind elaborate?

I have a Xeon server, collected mirror memory layout information as below b=
y using follow changes:

int __init_memblock memblock_mark_mirror(phys_addr_t base, phys_addr_t size=
)
 {
-       if (!mirrored_kernelcore)
+       int ret;
+       phys_addr_t end =3D base + size - 1;
+
+       pr_info("memblock_mark_mirror: base=3D%pa, size=3D%pa, mirrored_ker=
nelcore=3D%d\n",
+               &base, &size, mirrored_kernelcore);
+
+       if (!mirrored_kernelcore) {
+               pr_info("memblock_mark_mirror: mirrored_kernelcore not enab=
led, skipping\n");
                return 0;
+       }

        system_has_some_mirror =3D true;

-       return memblock_setclr_flag(&memblock.memory, base, size, 1, MEMBLO=
CK_MIRROR);
+       ret =3D memblock_setclr_flag(&memblock.memory, base, size, 1, MEMBL=
OCK_MIRROR);
+       pr_info("memblock_mark_mirror: marked [%pa-%pa] as MIRROR, ret=3D%d=
\n",
+               &base, &end, ret);
+       return ret;
 }

Here is the detailed layout information:

Case 1: efibootmgr -m t -M 0
Enable mirror memory below 4GB, and no mirror memory above 4G

=3D=3D=3D zoneinfo summary =3D=3D=3D
node   zone       start_pfn    end_pfn      start_addr         end_addr   =
=20
------ ---------- ------------ ------------ ------------------ ------------=
-
0      DMA        0x1          0xfff        0x1000             0xffffff
0      DMA32      0x1000       0xfffff      0x1000000          0xffffffff
0      Normal     0x100000     0x7fbffff    0x100000000        0x7fbfffffff
0      Movable    0x140000     0x7fbffff    0x140000000        0x7fbfffffff
1      Normal     0x7fc0000    0xff7ffff    0x7fc0000000       0xff7fffffff
1      Movable    0x8000000    0xff7ffff    0x8000000000       0xff7fffffff

node  start                end                  size              flags    =
  mirror   pfn_range
----  -------------------- -------------------- ------------ --------------=
- -------- ------------------=20
0     0x0000000000001000   0x000000000009dfff   0x000000000009d000 0x2     =
   yes      0x1-0x9e
0     0x000000000009f000   0x000000000009ffff   0x0000000000001000 0x2     =
   yes      0x9f-0xa0
0     0x0000000000100000   0x0000000066416fff   0x0000000066317000 0x2     =
   yes      0x100-0x66417
0     0x00000000777ff000   0x00000000777fffff   0x0000000000001000 0x2     =
   yes      0x777ff-0x77800
0     0x0000000100000000   0x000000013fffffff   0x0000000040000000 0x2     =
   yes      0x100000-0x140000
0     0x0000000140000000   0x0000007fbfffffff   0x0000007e80000000 0x0     =
   no       0x140000-0x7fc0000
1     0x0000007fc0000000   0x0000007fffffffff   0x0000000040000000 0x2     =
   yes      0x7fc0000-0x8000000
1     0x0000008000000000   0x000000ff7fffffff   0x0000007f80000000 0x0     =
   no       0x8000000-0xff80000

Case 2: efibootmgr -m t -M 25
Enable mirror memory below 4GB, and put 25% percentage memory to mirror abo=
ve 4GB

=3D=3D=3D zoneinfo summary =3D=3D=3D
node   zone       start_pfn    end_pfn      start_addr         end_addr
------ ---------- ------------ ------------ ------------------ -----------
0      DMA        0x1          0xfff        0x1000             0xffffff
0      DMA32      0x1000       0xfffff      0x1000000          0xffffffff
0      Normal     0x100000     0x603ffff    0x100000000        0x603fffffff
0      Movable    0x20c0000    0x603ffff    0x20c0000000       0x603fffffff
1      Normal     0x6040000    0xc03ffff    0x6040000000       0xc03fffffff
1      Movable    0x8040000    0xc03ffff    0x8040000000       0xc03fffffff

node  start                end                  size              flags    =
  mirror   pfn_range
----  -------------------- -------------------- ------------ ---------- ---=
----- ------------------
0     0x0000000000001000   0x000000000009dfff   0x000000000009d000 0x2     =
   yes      0x1-0x9e
0     0x000000000009f000   0x000000000009ffff   0x0000000000001000 0x2     =
   yes      0x9f-0xa0
0     0x0000000000100000   0x0000000066416fff   0x0000000066317000 0x2     =
   yes      0x100-0x66417
0     0x00000000777ff000   0x00000000777fffff   0x0000000000001000 0x2     =
   yes      0x777ff-0x77800
0     0x0000000100000000   0x00000020bfffffff   0x0000001fc0000000 0x2     =
   yes      0x100000-0x20c0000
0     0x00000020c0000000   0x000000603fffffff   0x0000003f80000000 0x0     =
   no       0x20c0000-0x6040000
1     0x0000006040000000   0x000000803fffffff   0x0000002000000000 0x2     =
   yes      0x6040000-0x8040000
1     0x0000008040000000   0x000000c03fffffff   0x0000004000000000 0x0     =
   no       0x8040000-0xc040000

Case 3: efibootmgr -m f -M 25
Disable mirror memory below 4GB, and put 25% percentage memory to mirror ab=
ove 4GB

=3D=3D=3D zoneinfo summary =3D=3D=3D
node   zone       start_pfn    end_pfn      start_addr         end_addr
------ ---------- ------------ ------------ ------------------ ------------
0      DMA        0x1          0xfff        0x1000             0xffffff
0      DMA32      0x1000       0xfffff      0x1000000          0xffffffff
0      Normal     0x100000     0x60bffff    0x100000000        0x60bfffffff
0      Movable    0x20c0000    0x60bffff    0x20c0000000       0x60bfffffff
1      Normal     0x60c0000    0xc0bffff    0x60c0000000       0xc0bfffffff
1      Movable    0x80c0000    0xc0bffff    0x80c0000000       0xc0bfffffff

node  start                end                  size              flags    =
  mirror   pfn_range
----  -------------------- -------------------- ------------ ---------- ---=
----- ------------------
0     0x0000000000001000   0x000000000009dfff   0x000000000009d000 0x0     =
   no       0x1-0x9e
0     0x000000000009f000   0x000000000009ffff   0x0000000000001000 0x0     =
   no       0x9f-0xa0
0     0x0000000000100000   0x0000000066416fff   0x0000000066317000 0x0     =
   no       0x100-0x66417
0     0x00000000777ff000   0x00000000777fffff   0x0000000000001000 0x0     =
   no       0x777ff-0x77800
0     0x0000000100000000   0x00000020bfffffff   0x0000001fc0000000 0x2     =
   yes      0x100000-0x20c0000
0     0x00000020c0000000   0x00000060bfffffff   0x0000004000000000 0x0     =
   no       0x20c0000-0x60c0000
1     0x00000060c0000000   0x00000080bfffffff   0x0000002000000000 0x2     =
   yes      0x60c0000-0x80c0000
1     0x00000080c0000000   0x000000c0bfffffff   0x0000004000000000 0x0     =
   no       0x80c0000-0xc0c0000

> > 			memmap_init_zone_range(zone, start_pfn, end_pfn,
> > 					       &hole_pfn);
> > 			zone_id =3D j;
> >--
> >2.47.3
>=20
> --
> Wei Yang
> Help you, Help me

