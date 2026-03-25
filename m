Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E65DA109C02F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 593566B008C; Wed, 25 Mar 2026 10:51:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56B486B0092; Wed, 25 Mar 2026 10:51:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459C26B0093; Wed, 25 Mar 2026 10:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3377E6B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:51:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2D4113BECE
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:51:16 +0000 (UTC)
X-FDA: 84584873352.10.E2B8F10
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9C6F6180009
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:51:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=H3O4owVp;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of yi.l.liu@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=yi.l.liu@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774450273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6Vnj2pUknbesnjE//mYIh4xBElXiTpkwVva95swmlOQ=;
	b=yRpF9PQ6v70lWvHWGtBlltFp5drq7qUAFAlAhzOBazAWuzA0plz2FBvmnYHg3sTP+6RXVY
	2IpBr3XfHG5ZRHZNURhjSuadCq2czWnSYL23n/WFkbkEyGEGrGBq/bX4IVl1x+WIcDR0yU
	PFsy3+zat0Qy4xlWCvsnTKQQeChf1Qc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774450273; a=rsa-sha256;
	cv=fail;
	b=8FxmBSGwi/RaTCJJLRh1S3q24pk6pMFq73O6jQtK6bHevgrOUqJCmNp/T6O3h0tU6L8ywU
	8+5EYFoCtHmo6x3Jr+wATDegFWh0jig+AQVYe3Sxj8sjIcAynlO94jtPCl76ZtFgbBCQUc
	YqdRAYRDDBog9vYwN/UpdChDO2BAhTc=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=H3O4owVp;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of yi.l.liu@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=yi.l.liu@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774450272; x=1805986272;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=DRB8d1zqD9Kbtp/4yvYAJ1tpSD0pUknTYdUe9vG42y8=;
  b=H3O4owVpA+BS3YBzXxqaC3j29wiRgORcnjGh5ZLeetzx9mi5whtJZSPR
   zDZ97c/2epBerAuoiCmrpZ+XnSXSEzhHmkSlKMa90jA7j9qNK5Z3sXdY9
   DaMRXqkjeFISr1Ajer0+rxac3XUinzkRwf5xOgNa82miPRi6CL1/BuYQn
   k0scjHsNr6ZAvCk2D1aoWmzWbu869XSO0k0Drj+cl2elB+4Y2zh/mLmlK
   xQYhw7x3KEYMt8dMH+4iLHHL4aCiOvRpeUxeRFIqf8EV8dxI1JAyJ6mBj
   3Hz8RNO6RvnF4BY7HBVSMp0/SXY4Idgk9SiywBjIgvnhyS0AjZ9VG5Yyq
   A==;
X-CSE-ConnectionGUID: i0+rIAzbSeKZwYNzE9M8Pw==
X-CSE-MsgGUID: 8t8nLM1CTci3VM6Gxy9/xg==
X-IronPort-AV: E=McAfee;i="6800,10657,11740"; a="75204408"
X-IronPort-AV: E=Sophos;i="6.23,140,1770624000"; 
   d="scan'208";a="75204408"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2026 07:51:11 -0700
X-CSE-ConnectionGUID: btMJq9JgS8Gj6dayz5f6Mw==
X-CSE-MsgGUID: m3HtEYDOQXyW3M1FSb9IoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,140,1770624000"; 
   d="scan'208";a="221382287"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2026 07:51:10 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 25 Mar 2026 07:51:09 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 25 Mar 2026 07:51:09 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.53) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 25 Mar 2026 07:51:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z3+wC5C+fkc7ZuOMQp7AEQv7O2fQ77TLVsU8VdIiSD5uFy6kOEI4yI87AtvB5bTsTaKrSeHOpeULKiW0cYcOxq2Ek4ynVZpZZcu7cf+8vugPfhVZKumqh3ATy0yzmNhki8l7xkMKh3kaHit1qUDvxp84ptuNtxySg7g1zYOWJweIh3De4ktceACCzQoUg8Tfz9EjC0aCi4iAcp731YH1lSgZMw4Zjv5dY39BWV572PsTBl7guKVFAZlao3A1jfnK2imQV8OyjszdV52pokNlEM1Rh74DsfBUV0qMelx6dAnyNwQ3xFXc/RegdiNDHpuTNT3SWoWAMyUh5sVWookzfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Vnj2pUknbesnjE//mYIh4xBElXiTpkwVva95swmlOQ=;
 b=NWEZ5XlXDL79J1b57Jr4NBIABBNnjnmHivAp9jNgvqLffF/3wmDXdlu1EtRCMRQQVWnLk1FKNE0eGt4giy87sC7LguYIysv+wpFapMchNNvY6xWC2X0RfJx641tZ41y4qv+H63EWMXmIUqT/x1vJCwBClqY2MFc57MX5eBXImd1PubJ+AczUScBfAnyG1vI6p0AZVuuA7sBRLpTssmFc7xXeYG0dja7I67IiEtDnQPFXsOzhY1oQeR/B7FxwD6NsfQDo6KGIBgiwtwPM57FkgTNyEB/STQrqNFO+TDLmGgqdyKQIGbd39PT1vmRc9rGrFGmFR3A2jtwCVriT2JOlMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV8PR11MB8509.namprd11.prod.outlook.com (2603:10b6:408:1e6::15)
 by PH3PPFC067E5C7D.namprd11.prod.outlook.com (2603:10b6:518:1::d48) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Wed, 25 Mar
 2026 14:51:00 +0000
Received: from LV8PR11MB8509.namprd11.prod.outlook.com
 ([fe80::f5bd:4dde:4f2f:20b7]) by LV8PR11MB8509.namprd11.prod.outlook.com
 ([fe80::f5bd:4dde:4f2f:20b7%5]) with mapi id 15.20.9745.019; Wed, 25 Mar 2026
 14:51:00 +0000
From: "Liu, Yi L" <yi.l.liu@intel.com>
To: David Matlack <dmatlack@google.com>
CC: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Adithya Jayachandran <ajayachandra@nvidia.com>, "Graf, Alexander"
	<graf@amazon.com>, Alex Mastro <amastro@fb.com>, Andrew Morton
	<akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann
	<arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, Borislav Petkov
	<bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, David Rientjes <rientjes@google.com>, Feng Tang
	<feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, "Jonathan
 Corbet" <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Kees Cook
	<kees@kernel.org>, "Tian, Kevin" <kevin.tian@intel.com>,
	"kexec@lists.infradead.org" <kexec@lists.infradead.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Leon Romanovsky
	<leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, Li RongQing <lirongqing@baidu.com>, Lukas Wunner
	<lukas@wunner.de>, Elver Marco <elver@google.com>, "Winiarski, Michal"
	<michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, Parav Pandit
	<parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, "Paul E.
 McKenney" <paulmck@kernel.org>, Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>, Randy Dunlap
	<rdunlap@infradead.org>, "Vivi, Rodrigo" <rodrigo.vivi@intel.com>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, Shuah
 Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>,
	"Kasireddy, Vivek" <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>,
	Yanjun Zhu <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v3 03/24] PCI: Require Live Update preserved devices are
 in singleton iommu_groups
Thread-Topic: [PATCH v3 03/24] PCI: Require Live Update preserved devices are
 in singleton iommu_groups
Thread-Index: AQHcvGbLhACgv/fpyUGZl+i4j6P07Q==
Date: Wed, 25 Mar 2026 14:51:00 +0000
Message-ID: <4F9426C5-68B7-47DC-9DC3-2F420FC71F63@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR11MB8509:EE_|PH3PPFC067E5C7D:EE_
x-ms-office365-filtering-correlation-id: f150e614-2ec1-49ee-51fd-08de8a7dee0b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021|56012099003|18002099003;
x-microsoft-antispam-message-info: XJNdGkHTxM0//hqXP9MAEdg7k8Zg3NKUwQvfnfZff1K4M+aCuW3sI64KiAvvsNBlLKLCVJXOd5Y8/4Vx5GiIYFEZr8hvqBLbAEG07XJW68+G3X+ATQEd1tVj+suraub9HR5tOLWdnhyXGj/K32kaDMX5ivLOeVNqF+DzBk/LrJxCYiFgT46GflG7HAaR4MEIcIKnXNBhYBMfzXU+Zw4Nspy2mFxMo3M7Zv2W9D2DGbl/olgnmTuIanFMnP3HfCzXtKQ/Kd2eEGKvEb48K4mAs+oQ8k1mjQ+ibo6EbqTIntx11CbyD93WHiagZuaupSoRw1IuFuPlbNnQ4Q/WB9UqL8Xve9l2deEWA9vOiedD2I6A/FQ8tTVAskXRmw2MbUfAQg6RpvPcJeqy9GbC9nmnxhnIhqsaZ9Nc4JOaaUD8yFyZXDRCO6pfGIajezVq0YGP+o/fAIGzuLwyMvM4zFln05cABGHeBecU5VdPUadxy2WmNEzTAlMLgW7F82wvRiHZMzIU8tEHLORb+J+bWofPQIKFKmC3y7JxFKIugFmMmfvB+Z+tg6XxMb6JPXsrbmOTs5K8qu13KEO8feRu9HInXU6Tk/cIqN5x0Pw5sCrkkADj8GrzBpQlrHXUcff1V4ALIiKq9Yej0/H0p6b6VeBJcGgbRo6sf76+KZFr/AsGA7laJTPvlxwOlyQdDQENpwq4oUeHM7BFEXaA0IeeYs2eqyuNhMluR3sqzAPaPSVPOL2djKM2JO3cCu9RiCUohnJ4dqgGHh1CWASnzf8QTY88ifTEr8/SL/kcD7pTNNGvvYc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR11MB8509.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021)(56012099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?b7h2wDIQpUl/kdhHA7Ejri7wTxEZRa5zMv9BYJXQv21oICASlEFxoMinoHUM?=
 =?us-ascii?Q?ZjVk8wd51kIb5Wn4vuMqg58d/9zayLdCBYzeS5CwoY8wKGGYHXndOgU0yEsI?=
 =?us-ascii?Q?NfUe3Z39kkpYpZyA1sIzzyRnFOMKuMdNOXeug6dIWVjye4FF9q1enRTpP04u?=
 =?us-ascii?Q?80Hqkw3IvwJlcybp4A3S/KYWJkwBnuflnDfV0Hc3F6jpJSvZMaAi0kXC5XA5?=
 =?us-ascii?Q?EOEhUcbF8w1PZcUug55jyYw0nJtBZL2bEPuzwwRiKGRVxcTyOT7ArrzgHPOb?=
 =?us-ascii?Q?SMV0xYoFEleMsRjsjzIfgnveEIwIwP6p1buY8c27pHj9YG7xEaenhy2yME1d?=
 =?us-ascii?Q?MIW4o29dPixbAjVNMMxdWoIJTGjcJAq28aLFEHG78jtjcOlA5cDEJiOI9uon?=
 =?us-ascii?Q?5atyAub5YUK51jLlF/rDXzEJhKBHHNEHo3SXph9dYFmt3lCIJuPZ9N8yaMc2?=
 =?us-ascii?Q?4Ao5POGsvmzeJqSAxSDnp0iJembpQ1lj0NcsnDSeeQ1UmCDcp5N/sdn2dCem?=
 =?us-ascii?Q?scX0RbcXA7tl7kqRliqjNsxIcKJRSIsjD1NwyfGFQ3dCWo9yABagSM/1Stxa?=
 =?us-ascii?Q?Hq2a2n7Os6rxOsX5HcOd03KZSVLW0NWIGrQd8XcoU/CUQyz5ahNEWbI4KEjf?=
 =?us-ascii?Q?oXOLg9F7t4ph5a0lSirVokaeM0TmySqgyBolzm/cR8ySU0NFf1Dqmx0oMiJ9?=
 =?us-ascii?Q?Mf191XNZehW98shyE/AtajfGopSJt9qUuQu6hhmbjL3rKtlbBghyf5Bqz72x?=
 =?us-ascii?Q?eQdwJEglAqV9FQrWm+/ish10aEGlWVsp1LlOJPbRhAn4fmCPG8uKMITUzjYU?=
 =?us-ascii?Q?TDfQH6kHBECxvuUF0Kuw064wKCkmNZzUuBFeeXRTe2x/aO8shbg0Iinyt8S0?=
 =?us-ascii?Q?lBOfsq8YLsBJ2GW0MY5SlYfMhv7H4PekMgKeuJh5hbwiyvb2kYuw5/ytx/0/?=
 =?us-ascii?Q?6f+0YWilGG7xosq8StgQ8TmsodyX7Qy25qsdaqoJK95Vxg1JslvFHOo6TZau?=
 =?us-ascii?Q?JHr1Mg9LGZBSzLAt+qLrRc066OXhdF799xj/0zmF93iMDMale4+9m3WqsRVr?=
 =?us-ascii?Q?4xHfTpIHYdqnzjzZ78eYRFlzNAD50oFr2+XETTlj5nxJGufoqifiJg3Omnlp?=
 =?us-ascii?Q?hiOCplh+InGukyKTKSYev/k9hM+zbXZDyOuK6dC2EqrcbY4VNWQXf//EGzKb?=
 =?us-ascii?Q?LuHKOFya81RC7ofUw3SdJaVjjhD+B8a7hHDDCJfWPKqKsteyIexrNW39x8xv?=
 =?us-ascii?Q?Oa7Z1Ya8/YrTIwzEoO6fYPr93P4scjxa5juMPTYiUl3uQydHDTTnioAeytFC?=
 =?us-ascii?Q?FjALSJgt8Bgtv5oMrPy0ajJXch7dY9cmyMhTwy0VYrdGdxMG4RRiz21BB78g?=
 =?us-ascii?Q?ZGrExEZRLZ7hG39sYgtrCvaaKfRWxLU6ArbWa/pur8eikrvWk2wa4KGzcnIW?=
 =?us-ascii?Q?bUs5FxLmA6P1Jt5dP+dJRecI0YNG6Qm6NxdMRNCRykH/ZKW9nrbHmUplM6Mf?=
 =?us-ascii?Q?fhJ3AmxbaYjSTPEOYKIa4S2tRsJr5m//iTpZv4mP9+IcrEg6N8JmIlxqvG+l?=
 =?us-ascii?Q?axsuiaDgFT96mumQXzA+mTn2oOsrIxrtD3FPrElp0m4yZxeXbsktix7DI9Qn?=
 =?us-ascii?Q?f4KSBs2XsPj8YqxVUheJdfSqcc29AKvNiIZrgGnli2VrFafpl+qomBWamGsO?=
 =?us-ascii?Q?WA36MOLlEntM6GXWnNID/KFX2wKF7Ds2k3b/BqHoPf5OG6Y5XzgRuFpfX1Wb?=
 =?us-ascii?Q?2O0edsUamg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FD75F3C252782E4ABDCD7E248240E47A@intel.onmicrosoft.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Mj2ewsnGq9q5TYqZWzXwypSXlAExiylQQqoLS+f8LAsMQ40/90BIyWU4bQGpgGK54uTvVCGJMUgvtDQ9bN8JpRO50prmwTEJ3ewWYuQCp7FuB7QwGHFVOw8yRrqNiwELn46uK86TU5lKloSxdjUI5Q1Tpd32apvZGEun2Dkz1JJU1lijKSIYbKiRHtDhTsijQ69SYq4zDWWb+YQ6PIMvddcEJRrGdR4Ct7/tma2WovEenYIDhMInSEjmeIF3xfUD7XuHthiNv5ScbGKhf4LjBI2RQGl7nU/D619xZgbczt8thtWqTgmPiDuePI/UtSY8/Cxoqobi8EDefhJ0ix8nQw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR11MB8509.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f150e614-2ec1-49ee-51fd-08de8a7dee0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2026 14:51:00.2233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e92cDs9nADvIS5GLBVRpkWtxd9kyRJvSPecXdahYMDxTYvTHaBTLC+SefP6yJ0jKHQywJFzz+MrtTK/pZExzQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFC067E5C7D
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 9C6F6180009
X-Stat-Signature: 3tdzykqyz1t1ppy13rbwk54ahjsnmz6f
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774450272-922141
X-HE-Meta: U2FsdGVkX1/6pYo9/IAJRzEMOA7zBYidadhxI8x18wIislgzOj7zbdCKdI+lj6iHvhfYTot9IJOIXm6Q3JFM2cNEwq0mH+1D7Tx/HogjDCXU7XxXht8gf2UORLCqOcVNF3LgkgwgoGqp7qgx/CieF/Fn/hyhrtj2gDegxhjg+qJHTfeFK77qUvfoc2+W5B/jrkqXWMmvWfs/CEIgJdu8E9WZSu2Zj7d+z+ZglpV7hhF5ZeqvbAisB9WPqJ51X9EenzX8pCnfCjEJg+VBFZeRms/WJn9EB+CGTd1Ik8hjjBzJOWc+kbZ9tZ7Y4p7jv1uOvz1a2p25/GoA36h3N0eqxv4zeMBk88wEp1EnvaLVwkhNhnOQ1tlJ1fzN7MOEX1mCHXG27FuwKYLGtuiVoWwmongHbrn9wEqD31gN/tUeOAiGAloMLK1YniHBpElq96ajxuenj0gvSQlaa9SoRu9L7PpWZbestH9APBDLgbOC8KWLo9ZwzF1A0i5Mght9Hs1o2SwE01mekoOMkzWYtFmKtb4QSJRWmxPgj4nrIKLqgfA8tzczRUSEz+m8NmgeHDYpQvvgUc33ngTvfRuusBzxtbhtQVHGDWYRCd+2r1tQgQez9zQvwPN/2jF5RzC87Bh3zX15dSlmD5GsJ108/kNKzpwPtHBJpROaujrxZ0U6AoQ/YzbQw/SqKEbAwcLkjfHBZcaN8JPl1k98ub0XXRagEc7sFbVABZZFSkWmoEBKL5e9Jxxhz/fcouE/AQl7DyapgqP5UGpY0ZYJm7YijCvlpzko7Dc0hNCmb8DaAKjYwd30taVIfBr+MV/oPMkz4D8sARjUcgU1qLYO0Cl5sfhQz/QWz0TKI8m5DAdX6cqU6c1/8fD1T/3Xw0AyqLXt5B/G6PsTc9FpwOoDr5Kr9N1+mq0hafQJ4yWe5kNWpQMFPiWRs8t2Mw54wtImBay5nJEschME9MtwgQsZT4naIWa
 aHtxJKiW
 5bY8qGeXsmcVHlvF8JffGqjf7u7GlFmO9INtMWSISJoA/pEyZVWZvni8k0rREFZY0BZrK93677QNKLbMwmHVzOAqbAYvWc9UZZy/I6z827Znbuh21DpxKnwJ+uCvNtVziFPWuI0DC91N8tiTr5xL6ppPLh6Q2YOP6+Zpn46SSS5f6udfT0sJ52o8OqauH55P5dm2FSjXeMeg79fl0MBmAn7NeYAegSw8lQhoSSSMyImz3cKq8KDYvLLwh5MnrHaJ9t5J6282tZH8aN1XJnk1UHFXeYBLpztlZ7Agknq1JiWCShPbBm7dR63YPd0UNGdG2DIZj6Pt3HO6ncMdZP53vXkJCKZaLdcbplWy735y+uRSNY1Lv1UPsK8GvqMv6Te+0Iq+lKWtudDLa6T9RayMUf1bKUl1OgOxN0ncKWfHmg2rlFWu0Aj2EFKakLI3L0+9aaI1+OMydX+sZwESnR81jCEGpSOZ+8fWEEwk5KnHc2ZaMCOOSrZjSnYIozIO26skGt6yzKDZIOsnKxKWcu5dHkWUslPlZ7rJw1CsJxY3Mr0zTLmesI/ThYJDc2xDgkUaidDzRoVZsxkvL/GJqQUd2TgCXqilfO1nSJh+0n6JcdkfeNGJiEgK7AiadKvRsMdjF0TcySGxiZo8HQMCanmdLMRjkU/ojoPvTL2eH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/25/26 02:00, David Matlack wrote:
> On 2026-03-24 09:07 PM, Yi Liu wrote:
>> On 3/24/26 07:57, David Matlack wrote:
>>> Require that Live Update preserved devices are in singleton iommu_group=
s
>>> during preservation (outgoing kernel) and retrieval (incoming kernel).
>>> PCI devices preserved across Live Update will be allowed to perform
>>> memory transactions throughout the Live Update. Thus IOMMU groups for
>>> preserved devices must remain fixed. Since all current use cases for
>>> Live Update are for PCI devices in singleton iommu_groups, require that
>>> as a starting point. This avoids the complexity of needing to enforce
>>> arbitrary iommu_group topologies while still allowing all current use
>>> cases.
>>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>>> Signed-off-by: David Matlack <dmatlack@google.com>
>>> ---
>>>  drivers/pci/liveupdate.c | 34 +++++++++++++++++++++++++++++++++-
>>>  1 file changed, 33 insertions(+), 1 deletion(-)
>>> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
>>> index bec7b3500057..a3dbe06650ff 100644
>>> --- a/drivers/pci/liveupdate.c
>>> +++ b/drivers/pci/liveupdate.c
>>> @@ -75,6 +75,8 @@
>>>   *
>>>   *  * The device must not be a Physical Function (PF).
>>>   *
>>> + *  * The device must be the only device in its IOMMU group.
>>> + *
>>>   * Preservation Behavior
>>>   * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>   *
>>> @@ -105,6 +107,7 @@
>>>  #include <linux/bsearch.h>
>>>  #include <linux/io.h>
>>> +#include <linux/iommu.h>
>>>  #include <linux/kexec_handover.h>
>>>  #include <linux/kho/abi/pci.h>
>>>  #include <linux/liveupdate.h>
>>> @@ -222,6 +225,31 @@ static void pci_ser_delete(struct pci_ser *ser, st=
ruct pci_dev *dev)
>>>      ser->nr_devices--;
>>>  }
>>> +static int count_devices(struct device *dev, void *__nr_devices)
>>> +{
>>> +    (*(int *)__nr_devices)++;
>>> +    return 0;
>>> +}
>>> +
>> there was a related discussion on the singleton group check. have you
>> considered the device_group_immutable_singleton() in below link?
>> https://lore.kernel.org/linux-iommu/20220421052121.3464100-4-baolu.lu@li=
nux.intel.com/
> Thanks for the link.
> Based on the discussion in the follow-up threads, I think the only check
> in that function that is needed on top of what is in this patch to
> ensure group immutability is this one:
>   /*
>    * The device could be considered to be fully isolated if
>    * all devices on the path from the device to the host-PCI
>    * bridge are protected from peer-to-peer DMA by ACS.
>    */
>   if (!pci_acs_path_enabled(pdev, NULL, REQ_ACS_FLAGS))
>       return false;
> However, this would restrict Live Update support to only device
> topologies that have these flags enabled. I am not yet sure if this
> would be overly restrictive for the scenarios we care about supporting.

yes. It's a bit different from that thread in which not only require
singleton group but also need to be immutable.

> An alternative way to ensure immutability would be to block adding
> devices at probe time. i.e. Fail pci_device_group() if the device being
> added has liveupdate_incoming=3DTrue, or if the group already contains a
> device with liveupdate_{incoming,outgoing}=3DTrue. We would still need th=
e
> check in pci_liveupdate_preserve() to pretect against setting
> liveupdate_outgoing=3DTrue on a device in a multi-device group.

this looks good to me. But you'll disallow hotplug-in during liveupdate.
not sure about if any decision w.r.t. hotplug. is it acceptable?

BTW. A question not specific to this patch. If failure happens after
executing kexec, is there any chance to fallback to the prior kernel?

Regards,
Yi Liu

