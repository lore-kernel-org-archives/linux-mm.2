Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B5E8C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 05:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFC116B008C; Fri, 25 Jul 2025 01:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86356B0092; Fri, 25 Jul 2025 01:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF326B0093; Fri, 25 Jul 2025 01:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 98C256B008C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 01:35:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B2FB805FE
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 05:35:21 +0000 (UTC)
X-FDA: 83701674042.14.D379C1A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf19.hostedemail.com (Postfix) with ESMTP id 80D801A0005
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 05:35:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LPdx4nUS;
	spf=pass (imf19.hostedemail.com: domain of vivek.kasireddy@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=vivek.kasireddy@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753421717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6p8xnh5uPIVEHYCep2fbZkINgQ1Sn0UjMAN1emoIDSU=;
	b=UOK3agfGe37JZy+qmGXd3drUZUcvBoMdvi7zB+fuEKDmbuNyPFbzW8Dhji48BLQtWD6uIr
	1Tu6lxVhx/TlSgCKgsEAKCIP4UyrymyrfT8ta9cZtvRPmRA82hRRpy7KupGXwvpIERLuNy
	AkrN0uPBfFEfKv9yZd65Z4iDFNHRdMY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753421717; a=rsa-sha256;
	cv=pass;
	b=oJk928gMLwvsKtWP2WA1Ru4np05WvAtf5YaSiPjmGS/uWuMsxYTCCwQIK8KFkNxFNufvC8
	cq/Zr2Sz1atliaVNhUenFpxPMcXLQkeKeoM9k4ld6wsrh+BKDfbrnmDbEYWLS8e+CK8aY/
	a5KsJI8IA7d/8B3s1xENluImR9Ri5Io=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LPdx4nUS;
	spf=pass (imf19.hostedemail.com: domain of vivek.kasireddy@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=vivek.kasireddy@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753421717; x=1784957717;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+ykA1GinmkeX9aOrZt0lxJZmMZ/crmGw3BtfXC2U8+g=;
  b=LPdx4nUShoiMTQFgC40xQy8vtBTdzTjGQudkXX32caijAiAloJKNZXt6
   678nrm4AFXZBVlsT4qsu6JO8BLyDlO6nfQiuVoO/AE0a+o3nStjj6+9Eo
   AjDDZjZ/L0/QMbeiPr65Qy/N4btIj6a+KbbG4AHZJXYj/o1VbwYWXuwg0
   oWtrXg81TRkgGHqE8zSiqChrTnCVoaBkigmQ4Caw/nAKfGU+LPnV9o+Nz
   qI4ch5H2ma6HV7Qd30Gq7UFT2PSgMw0KMe9FRd46cQazbMcrhbwnSaxVN
   tU9AZyI/eWcqniOXoVaC6RHXBciDHYaCREWQYICZE9T58jPE/iMCYCzW+
   w==;
X-CSE-ConnectionGUID: 4+aQkjGARt6m3HdPgPHq6w==
X-CSE-MsgGUID: rIoURjtvT9a3mbuGwkrejg==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="67103886"
X-IronPort-AV: E=Sophos;i="6.16,338,1744095600"; 
   d="scan'208";a="67103886"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 22:35:14 -0700
X-CSE-ConnectionGUID: NxPhb5t0S7CKlOFCQQZzmg==
X-CSE-MsgGUID: BtKlH1fcSCapNwi6WZwIIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,338,1744095600"; 
   d="scan'208";a="159893247"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 22:35:14 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 22:35:11 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 24 Jul 2025 22:35:11 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.43)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 22:35:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CDUogXIhtZuBt9X873ynjAehD5U77T01uD3bfMBOQMnY7vosShPJsLqhrBBE+9U5wKtrxZa/tHpOF+cLlq3b3bWVsNTyGgJVPxs+1VF6eimvY1MVRP4CWA1dCfrnezCb6qH+rE0kI+sQQkT8m3BxBxqgtNbzDTbATmyNhl9Vsp0LJXCtkHQDFudQTtaHY/gUlB9nyB86SJTd34XslHW62FfzPSt47QSjbONxaTtUkP2SLqhpoFvwg+xKmwXSJ2VukaQU9sxKlfMEFglcVAlD8Yv54BK2eHDl5A0m+qvO+Shejx/n401VMxwc9H/kXwkorAh9K9+klwB+amT+RkPJ9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6p8xnh5uPIVEHYCep2fbZkINgQ1Sn0UjMAN1emoIDSU=;
 b=l/VRu33yELQmNZA5aSoMtS7m3wMFtbU1TqTXTFF+xitwFYDBGK2j4wheaddOCE5hMrkvunEHVTVTA1X6T+CLaL2PxyMBlB7oXsLKRbasywVQypVkM/GevCROR8UNFzuloO2fJLYO+Uz4HfeIOIOiDAaoLJ1QehEQl+GlyQlLtucxGumXeODORRsQaelW4lOJGL47LT8bf4XpN7r+inqn5VzXVvadwYdm/kwqs0MAp8pACkTdkNIwR+Wg6LwQf1Z/SjBWlyP7QbpMVYs7006cOId3+6OZSKJ5EXBtyvFMKAb7FjtcuHEaBAUkpGq/o4vBWOrHnGSPqK6PWeZSgcIkig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA0PR11MB7185.namprd11.prod.outlook.com (2603:10b6:208:432::20)
 by LV8PR11MB8608.namprd11.prod.outlook.com (2603:10b6:408:1f0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.28; Fri, 25 Jul
 2025 05:34:40 +0000
Received: from IA0PR11MB7185.namprd11.prod.outlook.com
 ([fe80::dd3b:ce77:841a:722b]) by IA0PR11MB7185.namprd11.prod.outlook.com
 ([fe80::dd3b:ce77:841a:722b%3]) with mapi id 15.20.8943.029; Fri, 25 Jul 2025
 05:34:40 +0000
From: "Kasireddy, Vivek" <vivek.kasireddy@intel.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Alex Williamson <alex.williamson@redhat.com>, Christoph Hellwig
	<hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>, Andrew Morton
	<akpm@linux-foundation.org>, Bjorn Helgaas <bhelgaas@google.com>,
	=?iso-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, Jens Axboe
	<axboe@kernel.dk>, =?iso-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, Logan Gunthorpe <logang@deltatee.com>, "Marek
 Szyprowski" <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>, Will Deacon <will@kernel.org>
Subject: RE: [PATCH 10/10] vfio/pci: Add dma-buf export support for MMIO
 regions
Thread-Topic: [PATCH 10/10] vfio/pci: Add dma-buf export support for MMIO
 regions
Thread-Index: AQHb+9IaqW2aYf5a0kKT+xAFJGMHyLRAkYIggAAy9YCAALri8A==
Date: Fri, 25 Jul 2025 05:34:40 +0000
Message-ID: <IA0PR11MB71855A080F43E4D657A70311F859A@IA0PR11MB7185.namprd11.prod.outlook.com>
References: <cover.1753274085.git.leonro@nvidia.com>
 <aea452cc27ca9e5169f7279d7b524190c39e7260.1753274085.git.leonro@nvidia.com>
 <IA0PR11MB7185E487736B8B4CD70600DEF85EA@IA0PR11MB7185.namprd11.prod.outlook.com>
 <20250724054443.GP402218@unreal>
In-Reply-To: <20250724054443.GP402218@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA0PR11MB7185:EE_|LV8PR11MB8608:EE_
x-ms-office365-filtering-correlation-id: 72a76a66-36f7-4b7c-edc1-08ddcb3cf3dd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?2V/V0TtdzhZqSO9vdhz+N3JCc40ok7U6BbBdsI8Zq3xGxRO9rKsOMdIRnO?=
 =?iso-8859-1?Q?pRGkSoWCPLWV2SHobXgZV11+CymM1MXgM6MOA/O7lZnlHVVIvPSNjUMKtR?=
 =?iso-8859-1?Q?/4ss0H/629Vgf4g0GsDvHaoedNI1FR70hdiVm8LqhDp1XM8wMhMJ1MjzXX?=
 =?iso-8859-1?Q?morzlcOQdLd1sOxQsgvPvTos7z5gzzI3oEKOK5c2JOs97tZ+4tS20GVYKW?=
 =?iso-8859-1?Q?8VH2KapZFd8MlRgO31MZrD7ve+d1qW+wKdE3tNPWOwkGP8xZjJ2uWu13py?=
 =?iso-8859-1?Q?CfVQa6nnfEbo/ElzuO60jz6v9s8pMM8RN3yddsWnZZWG4x6RoOPzuo7lxb?=
 =?iso-8859-1?Q?S6eMa1tIv7+du+WDLvc5uaIt/WuvQe3DrvN5MR+Wjzk2fl+gtqk0+w9gDl?=
 =?iso-8859-1?Q?SisBNf4/oYrDbUfwPaQj/NocxA69NKOR34h/m6TAa8NOr3Va2A3T1d6++q?=
 =?iso-8859-1?Q?THHS0+vWeCyoIMZizonpCck6oLKmfrlX9jUdrcIxfgQVJbaQC4DaIorjdy?=
 =?iso-8859-1?Q?qmXQ5FCQVtfdQEGZl87CVlkiveavEB+xshnXuZUW8kst5PA+u+8EUYeV6+?=
 =?iso-8859-1?Q?jafCr0gNz5yE1BMxenJ40GdmjLoHNL7hu2f/t3pnw40V6VIQVXXmhLZaAa?=
 =?iso-8859-1?Q?y2evN5I2R8v0jHuiOKaKh7wYjmctzPUmuvQzfS6rSz8ZhMkoS8N+lBRU2Q?=
 =?iso-8859-1?Q?qu2THonbKNXSzBifPaC/dTZDNNmXQJpIOzvpuHzvIwnui0yYUoEg8Gqg/r?=
 =?iso-8859-1?Q?6jnQTjanHI0hUrs0+somAmT1TWZ1bFFPFn6YeKnWyIzgxJlEC4KAdYApn1?=
 =?iso-8859-1?Q?y7UeTmD6/4bx5zsvJ+/rJQ3jbic0XMfsetRpWLBt8dmfWhbliyzFTMyzh9?=
 =?iso-8859-1?Q?Fhv+M2n0nghZF9MISzsuA6lUMXXxG56fBvrvJXEH5ZVwiE0ddp7/DSOeuP?=
 =?iso-8859-1?Q?GFP12oZcQqlHo91BC5E2HdfangJ8l+ZNpEAhxJJ6vULjmXkVZodCNk6hFR?=
 =?iso-8859-1?Q?mWJScbfI4n+QitkGgSRgqvmCVT8Otj4oYFNyJ0KY3dbhRPFyExA79Rkq6/?=
 =?iso-8859-1?Q?UySPqP1liaVsFse/tfnlgsjxhncX6n4n3XsCvY9/rODyzO6RJeUcpxOnDn?=
 =?iso-8859-1?Q?76jGuy1lHl3EkL8GirWkX6W+EuWg+SqZ/x9wDcDMp/oHpdKj3INXgR3U+f?=
 =?iso-8859-1?Q?f5NIud5VoFmHhTgLh1wyuCOoaAUr3Kg0mwNYUDw8NAM8u+Ebfz1AyZKVHD?=
 =?iso-8859-1?Q?JDjVfzgJM9VbFBOXV4+h0RFPf9te4eu5Dlam2JTL8tZnviNyQs/fMInOl4?=
 =?iso-8859-1?Q?6IAf2OMzbN4dEysj59EcORSWKXtXyfLA6j1ZsdZmG7V4Nv2iu31mP21R0B?=
 =?iso-8859-1?Q?psbrEQds59W8W5h77QKH337+L0dGQSRqZadVcjNkSEKaqC0c+gV9/fFJuC?=
 =?iso-8859-1?Q?HfaCZhzS9LuJUXig51aIyWnf9vNoLUr9tZdDFna/H68kUu2QM5ntvXEXBd?=
 =?iso-8859-1?Q?4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB7185.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?jXk/jJ9sXof40pxEqcnaU7MfH0OX7V3yc9p/K8I9Wc4x5LEo8YD00HcYPJ?=
 =?iso-8859-1?Q?79wxK2KbzH842ZywrcEOSgojMxTbLz7kR4F0sy1ZapKe757Op152+0AIRf?=
 =?iso-8859-1?Q?WeXuTEpNODJIDv50NbRvmRwpno3EWf558ebIFkihncoOFDXk19ZjHR4RqT?=
 =?iso-8859-1?Q?NFHe5DJ9x2gyDsdgAKb5x1KmW5GXabscg4AjBQtsBisJvrovhmKW4MyXzt?=
 =?iso-8859-1?Q?mGL6a79sS1zU3Uyg5hNEdWzvsPoIOvqbokE9+0I5ldbZ/toRR738Qi5fgr?=
 =?iso-8859-1?Q?uzrTKil9IiAoDhziv/U0SqPWn9HZPGLIf5pQN9bIzDnXF1OwIedjcByhN4?=
 =?iso-8859-1?Q?a9wljgitQuKV/2fUcC16DlEZuZ8jtqHk54Xzfa2c9jy31Q8HUne9g2Wl2i?=
 =?iso-8859-1?Q?A7Qb3TA9PASW2kfAEEW1VWxS0WD2Fj2oFprHIijl1wbO8b7RmqaCvnijL2?=
 =?iso-8859-1?Q?Tl2PBAFbACxBs9hXZyP9s3DzL+bD+lKY88Znlz3BCAk7coLwzijUwiaIRL?=
 =?iso-8859-1?Q?t3lySr7RdRc6iNkRIcgucMgIw20j8Ezw1v90wcmgZVOhqquWU6CbjnJfse?=
 =?iso-8859-1?Q?hy5iCE6W3rtZQLMb33SjOGrgjfAQOfZ1D2a9hwtTsq5UfA8vsw5ZnYq4AM?=
 =?iso-8859-1?Q?blmkLmLQWdaxCB82tJPmCLl/57Lt67u9U7PXu/BmukqnjL7ChTijwJ8xkw?=
 =?iso-8859-1?Q?xBOhn97jWpuRjoLmYhaLRzW72plLxoEMDtuyen8HZy160aEUJcTr/aBK3C?=
 =?iso-8859-1?Q?01tUSWQrnQRhsAsYJREHgflzKTVntEhcSadBAlDVGLPOfeN0aYP5fV2OxN?=
 =?iso-8859-1?Q?biugPOpMv9J1VtnZfqVOIlg3IzY1qw5S+fDCo/oR2K0AYPYpLt7zdqPqTN?=
 =?iso-8859-1?Q?89Rj6f7yiUbjxHL6lDtblt9O8rumqn0xdWVP0AptA3VqUqs1KTBOs1JFql?=
 =?iso-8859-1?Q?OtSZSl3XFF1yEB0EB9v2ONs5V3HdjLEAciEUzgnoqimDnp0JVVAkQIyUlY?=
 =?iso-8859-1?Q?u/Y2PBbxfNz87Pv9OW4c7h1bAJNPCproda8KhgqxIgRyHxN99uI7Ce1Ptz?=
 =?iso-8859-1?Q?GFYqpalz4iKbrcKBbQN9VF/PO/5cIjC5OGbtE2K8CZZV2B8ei5lo4FhrKe?=
 =?iso-8859-1?Q?uKOMjS7PzZOLS/WpYnfdQtJ/a2qw5BQxOOMHtBCi7z9z5rI3NDEqPyLOKk?=
 =?iso-8859-1?Q?gbkhk8H9iyxdCEa9nowcvMmoiV8gMT2LyOgybxWsMfdjMHTmPPphtsxRlR?=
 =?iso-8859-1?Q?M1gsaym8L+BPPoFWigqJ3YXSvw0KoVCGsEDpJIN72popq+ux5prrvb8xpN?=
 =?iso-8859-1?Q?Ay4UwM7eVWrU/5tbcSENt+KVC6+jJ5fgsfKEurOa4aDRPwxAotGXC2zimH?=
 =?iso-8859-1?Q?zaMEYDRnK/COFQpPreYbVIiP5A/3iO4jOE7jdhi5K9Uvpj3HSLzK38vmeA?=
 =?iso-8859-1?Q?+55s5lOs3+pshCNEiz8MPvQI74c1Hoy/a2OUkGgpA6VDXZ6f45hCSr9Nxc?=
 =?iso-8859-1?Q?tTVxNHgRKi0wo5ebE475Hc7xAlhXnNvwPq4rCOtN+IK5kwnNEKAdu2NXG7?=
 =?iso-8859-1?Q?pnwUWC7eXJBmufzFvjln3g2CUSR6b7rjlg+sS/rQuHWLKWrkouEoUFQxN1?=
 =?iso-8859-1?Q?RQIdHAFwt2wqd7sLX/fgvkR0leITbEx3hn?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB7185.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72a76a66-36f7-4b7c-edc1-08ddcb3cf3dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2025 05:34:40.6229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vBwOjp45moms5qpvVve6kATdWSQPSuOZxuwWfyj9NGCekgTDWY7piXkkn4Ufl2Re4IB6641yf39VU0lnWOsRH4aoUxIfdaJgIPfG7aUpVu4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8608
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 80D801A0005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: isjhjpn4wpwsr4ogtbtfy656bdgtpjj4
X-HE-Tag: 1753421717-64614
X-HE-Meta: U2FsdGVkX1/A9BFDT18hpN6LufoulpJYQUuIPg3QVP8qLII3hT2q85bxx5J7SPCq0TeCMr7OweVPnT5Z976FuDFd6TFg0gnKCO2Pg5Y4LsjJWRvseNx5ODvPzCMAtQyI7hzhNZMuU/4aasXdF7mlu8EaPZMA3Bkz+1n03U8j48Yk+zFhnHoEmuJLD/YyhINMu8jCDjCqyjnMxnSXg0D81EiW59cA7cvBsEMYzQLsy6jv4wnarxjmBIIFFTvitMyp1DZAQif01XwWxPAXVuGn5jhLahUYft0c5aO8z24ffca6yBBZ+vG9YSINpDuJILyUlWKQYydE4ZoMK7z7YeZSsee0TiXHsSfWSEdmcUoq23rK5Wq/Ry9f/sF2/AEByKTnck3sOV6i08lHh+nCwKHQcBxGlHlSz7h1mZTrwBVu+BB0F1A2CsRzc0gyrPSzwd3CeJMkVeiWSKVRLcrqj62qrLf9pMKoCMnH2bjwXj96Mnw8FYEkE9KI9D3jkPJe5GC0syuiA0KNevs1/FgETQXy5Xde8VeZAQJgiG6ql4UnoTcegnvFWFXFlUTncMHbxoPSiVN6Q3gyAD4TBtn5nDYMsOgPna9NfW13XR1gP/S4RRDFNP4bA5npBvMN77uoswoNZXezhESn8cA9g68rB6h5FlscPZGhVTI1rmNqKEo5JmbKFmGNcTz7Vnp82TnkU1iYs5LMtg3Mz4ry196tPyqPVJeHj6Mu/wmhsXIbanK+nPgEpTGHD4Kd6IJAVhTlY+UvvWjoPzWULlkZIJ1SBPAc1i2K5ekW2wnn7pWmQVGmNxHszfo6ykhN5D50Q9uZPHqFRPgoKtECPJV1wBmuLSk40MPyoWe9gZXdRr5aye3J80y3nyXX+jzur+3AOd0yd8jKMIf3Feui0NjEMCbYrEAX0bRj0d6Jn+ESV3GzKuIeYfX/wkegfQoCeeJZKppyhdcDdx3Ne66kZYYukuFR3kQ
 Nw93bOcI
 3i6Sdbs0Hx1XPdZs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Leon,

> Subject: Re: [PATCH 10/10] vfio/pci: Add dma-buf export support for MMIO
> regions
>=20
> > >
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > >
> > > Add support for exporting PCI device MMIO regions through dma-buf,
> > > enabling safe sharing of non-struct page memory with controlled
> > > lifetime management. This allows RDMA and other subsystems to
> import
> > > dma-buf FDs and build them into memory regions for PCI P2P
> operations.
> > >
> > > The implementation provides a revocable attachment mechanism using
> > > dma-buf move operations. MMIO regions are normally pinned as BARs
> > > don't change physical addresses, but access is revoked when the VFIO
> > > device is closed or a PCI reset is issued. This ensures kernel
> > > self-defense against potentially hostile userspace.
> > >
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---
> > >  drivers/vfio/pci/Kconfig           |  20 ++
> > >  drivers/vfio/pci/Makefile          |   2 +
> > >  drivers/vfio/pci/vfio_pci_config.c |  22 +-
> > >  drivers/vfio/pci/vfio_pci_core.c   |  25 ++-
> > >  drivers/vfio/pci/vfio_pci_dmabuf.c | 321
> +++++++++++++++++++++++++++++
> > >  drivers/vfio/pci/vfio_pci_priv.h   |  23 +++
> > >  include/linux/dma-buf.h            |   1 +
> > >  include/linux/vfio_pci_core.h      |   3 +
> > >  include/uapi/linux/vfio.h          |  19 ++
> > >  9 files changed, 431 insertions(+), 5 deletions(-)
> > >  create mode 100644 drivers/vfio/pci/vfio_pci_dmabuf.c
>=20
> <...>
>=20
> > > +static int validate_dmabuf_input(struct vfio_pci_core_device *vdev,
> > > +				 struct vfio_device_feature_dma_buf
> *dma_buf)
> > > +{
> > > +	struct pci_dev *pdev =3D vdev->pdev;
> > > +	u32 bar =3D dma_buf->region_index;
> > > +	u64 offset =3D dma_buf->offset;
> > > +	u64 len =3D dma_buf->length;
> > > +	resource_size_t bar_size;
> > > +	u64 sum;
> > > +
> > > +	/*
> > > +	 * For PCI the region_index is the BAR number like  everything else=
.
> > > +	 */
> > > +	if (bar >=3D VFIO_PCI_ROM_REGION_INDEX)
> > > +		return -ENODEV;
>=20
> <...>
>=20
> > > +/**
> > > + * Upon VFIO_DEVICE_FEATURE_GET create a dma_buf fd for the
> > > + * regions selected.
> > > + *
> > > + * open_flags are the typical flags passed to open(2), eg O_RDWR,
> > > O_CLOEXEC,
> > > + * etc. offset/length specify a slice of the region to create the dm=
abuf
> from.
> > > + * nr_ranges is the total number of (P2P DMA) ranges that comprise t=
he
> > > dmabuf.
> > Any particular reason why you dropped the option (nr_ranges) of creatin=
g
> a
> > single dmabuf from multiple ranges of an MMIO region?
>=20
> I did it for two reasons. First, I wanted to simplify the code in order
> to speed-up discussion over the patchset itself. Second, I failed to
> find justification for need of multiple ranges, as the number of BARs
> are limited by VFIO_PCI_ROM_REGION_INDEX (6) and same functionality
> can be achieved by multiple calls to DMABUF import.
I don't think the same functionality can be achieved by multiple calls to
dmabuf import. AFAIU, a dmabuf (as of today) is backed by a SGL that can
have multiple entries because it represents a scattered buffer (multiple
non-contiguous entries in System RAM or an MMIO region). But in this
patch you are constraining it such that only one entry associated with a
buffer would be included, which effectively means that we cannot create
a dmabuf to represent scattered buffers (located in a single MMIO region
such as VRAM or other device memory) anymore.=20

>=20
> >
> > Restricting the dmabuf to a single range (or having to create multiple
> dmabufs
> > to represent multiple regions/ranges associated with a single scattered
> buffer)
> > would be very limiting and may not work in all cases. For instance, in =
my
> use-case,
> > I am trying to share a large (4k mode) framebuffer (FB) located in GPU'=
s
> VRAM
> > between two (p2p compatible) GPU devices. And, this would probably not
> work
> > given that allocating a large contiguous FB (nr_ranges =3D 1) in VRAM m=
ay
> not be
> > feasible when there is memory pressure.
>=20
> Can you please help me and point to the place in the code where this can
> fail?
> I'm probably missing something basic as there are no large allocations
> in the current patchset.
Sorry, I was not very clear. What I meant is that it is not prudent to assu=
me that
there will only be one range associated with an MMIO region which we need t=
o
consider while creating a dmabuf. And, I was pointing out my use-case as an
example where vfio-pci needs to create a dmabuf for a large buffer (FB) tha=
t
would likely be scattered (and not contiguous) in an MMIO region (such as V=
RAM).

Let me further explain with my use-case. Here is a link to my Qemu-based te=
st:
https://gitlab.freedesktop.org/Vivek/qemu/-/commit/b2bdb16d9cfaf55384c95b1f=
060f175ad1c89e95#81dc845f0babf39649c4e086e173375614111b4a_29_46

While exhaustively testing this case, I noticed that the Guest VM (GPU driv=
er)
would occasionally create the buffer (represented by virtio_gpu_simple_reso=
urce,
for which we need to create a dmabuf) in such a way that there are multiple
entries (indicated by res->iov_cnt) that need to be included. This is the m=
ain
reason why I added support for nr_ranges > 1 to this patch/feature.

Furthermore, creating multiple dmabufs to represent each range of the same
buffer, like you suggest IIUC is suboptimal and does not align with how dma=
buf
works currently.

>=20
> >
> > Furthermore, since you are adding a new UAPI with this patch/feature, a=
s
> you know,
> > we cannot go back and tweak it (to add support for nr_ranges > 1) shoul=
d
> there
> > be a need in the future, but you can always use nr_ranges =3D 1 anytime=
.
> Therefore,
> > I think it makes sense to be flexible in terms of the number of ranges =
to
> include
> > while creating a dmabuf instead of restricting ourselves to one range.
>=20
> I'm not a big fan of over-engineering. Let's first understand if this
> case is needed.
As explained above with my use-case, having support for nr_ranges > 1 is no=
t
just nice to have but absolutely necessary. Otherwise, this feature would b=
e
constrained to creating dmabufs for contiguous buffers (nr_ranges =3D 1) on=
ly,
which would limit its effectiveness as most GPU buffers are rarely contiguo=
us.

Thanks,
Vivek

>=20
> Thanks
>=20
> >
> > Thanks,
> > Vivek
> >
> > > + *
> > > + * Return: The fd number on success, -1 and errno is set on failure.
> > > + */
> > > +#define VFIO_DEVICE_FEATURE_DMA_BUF 11
> > > +
> > > +struct vfio_device_feature_dma_buf {
> > > +	__u32	region_index;
> > > +	__u32	open_flags;
> > > +	__u64	offset;
> > > +	__u64	length;
> > > +};
> > > +
> > >  /* -------- API for Type1 VFIO IOMMU -------- */
> > >
> > >  /**
> > > --
> > > 2.50.1
> >

