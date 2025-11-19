Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1FD6CF2562
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 00:02:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24EC66B0092; Tue, 18 Nov 2025 19:02:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225476B0098; Tue, 18 Nov 2025 19:02:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F2FE6B0092; Tue, 18 Nov 2025 19:02:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F1D236B0092
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:02:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 89DD7140161
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 00:02:11 +0000 (UTC)
X-FDA: 84125404062.14.5EAF87A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf07.hostedemail.com (Postfix) with ESMTP id 92C4040014
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 00:02:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KL05h1PN;
	spf=pass (imf07.hostedemail.com: domain of kevin.tian@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=kevin.tian@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763510527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ip170kNN9ZrWGT522gwS+mpQ9sknuDvUDUnQsxpbSxY=;
	b=TKZOpauHv/SDXz4XziEEqRQAyNJHAZUEoLuTlJkATJx5ujiSy5gTWneJQHhpLS9y0gZq1B
	JrD9MO3SxII1nXfOCNba6cA8aUuRHPJBXzM05Dg0/xFEf8KXw0mU8suLrkbXCaxIReJjMZ
	4ECW5sf4LLsculkAmGCf6jh+quqv3Q8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763510527; a=rsa-sha256;
	cv=pass;
	b=XkdwKjnrNmT1l08gv6fdP38TSUbn/WMtfo3mngxkFU8lZhe0JH2enbhCivVHrLB7DDpmnV
	5KyqBFg1uRIKNk734dm89fTb3pDiI2XagqTq/HgLaUg7n8VRdz6eGO4p9B5MsymRiFbKLv
	STL+ZBqFd4lQ1mnA7kvBMO+alB5su2U=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KL05h1PN;
	spf=pass (imf07.hostedemail.com: domain of kevin.tian@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=kevin.tian@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763510527; x=1795046527;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ip170kNN9ZrWGT522gwS+mpQ9sknuDvUDUnQsxpbSxY=;
  b=KL05h1PNsyS1C7x4Gz5uNeHEAToGL82W/jwShjbVh5RWQgeMSp61EyVZ
   Ge95injh5IYnzbyR7FkGzNFNdIuTubHTMPX2WCZESDafAB58bgNgKDfzp
   qZWdl83wqjAhUSBIYM80DobnNHimEwDJC0IkC84XpCLt1rMf2ZdkJHtHX
   tjmBD/pJwB28WcJB7kJ2M2Q09p51Zubrc6C6OX0LfO1aRMOCVEcXl3ZIq
   yqbO5aU8leeWiG/Ga42LGuUFXqBqizW10CJ4dZUJHfz8fIjmMLx3R8ZfJ
   UCeM9MtcDvbV3QIH3WDyRlpMkswYaz0glDZwZu1gQl2ftvvS4BEeWxGYP
   Q==;
X-CSE-ConnectionGUID: wEjELzKLQyq9bMjzr10iZQ==
X-CSE-MsgGUID: H5+TIt6kRX+H7zRgdu14AA==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="69162106"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="69162106"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 16:02:06 -0800
X-CSE-ConnectionGUID: nOEIotLsSw2n9aYKviX51w==
X-CSE-MsgGUID: UTubz14iSZKWqLXHFShD/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="190173647"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 16:02:05 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 16:02:05 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 16:02:05 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.71)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 16:02:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ur6xjk/1XmkrArbNa1bAMbM5xQfnZRJJdPcF1AhbURSOiVSKVzP1K61JQNf/7304PxcSIWGd8bVWpkfEGb4fVSUIflXheM4xaK5OAcPWX9GA815UYwgglYkM5QO/RwD3dFOoI7lie90niQ0BuE8kZXTxOMHWuEdtIShhiHS3oC9VZ8VvXIPXlzXYkmXYbooON9fOIadnHfA078AUZp6PcS1UvBCIMyN/pOYloKS8eLjNRDupAkakWFXr1RtktOjqQ3tI5FBSKLtd+Ojv7MchXKskpHjfYsKGDg4IKVn8THdM3tXpnc3KoSs09Vl86MIkzeFq0aKMXUZM8kQCJYwBLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ip170kNN9ZrWGT522gwS+mpQ9sknuDvUDUnQsxpbSxY=;
 b=YIGekOwbtkqCCfykb6p0Qo93Pyn8HpwZg+oyW3X2zuTUzZT1tLoDkHAAHRo53l4gjC8YWwqUSODHgB4gb/XtO5zKj9eiDJTia/y6HCdsG7CVso0vrhd57ZcTFrooOlYe0mhPjfuRdWMd9yOGJ/apjVxWfni6/EsMr85X7UfI1TW/z6ZQWZRzuHRUVxz6qL7d7Jc30bomUumBaDJe51FePtqfscbFY14CfzcYLxUenUSqLGixKFrKqPwHq9ECwJSf0XarO1IUZgR6ySZVaiole+ds1SlkShOLYWmrv82BVyiOJ7FK2IcAitWcZWtpez9xEevhXnV4doJDCuzkCYIsbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB5959.namprd11.prod.outlook.com (2603:10b6:510:1e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 00:02:02 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 00:02:02 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Keith Busch <kbusch@kernel.org>
CC: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>, "Robin
 Murphy" <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon
	<will@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
	=?iso-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>, Kees Cook
	<kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, "Ankit
 Agrawal" <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, "Shameer
 Kolothum" <skolothumtho@nvidia.com>, Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-media@vger.kernel.org"
	<linux-media@vger.kernel.org>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>, "linaro-mm-sig@lists.linaro.org"
	<linaro-mm-sig@lists.linaro.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-hardening@vger.kernel.org"
	<linux-hardening@vger.kernel.org>, Alex Mastro <amastro@fb.com>, Nicolin Chen
	<nicolinc@nvidia.com>
Subject: RE: [PATCH v8 09/11] vfio/pci: Enable peer-to-peer DMA transactions
 by default
Thread-Topic: [PATCH v8 09/11] vfio/pci: Enable peer-to-peer DMA transactions
 by default
Thread-Index: AQHcUvHIktoMrvUl+keVP/eL057qqrT4D0PwgADb7wCAAD5E0A==
Date: Wed, 19 Nov 2025 00:02:02 +0000
Message-ID: <BN9PR11MB52768D54FF42AB11C49202C98CD7A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-9-fd9aa5df478f@nvidia.com>
 <BN9PR11MB52767F78317AF3AB94A5B7D38CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aRzUpmUkDy-qN5c1@kbusch-mbp>
In-Reply-To: <aRzUpmUkDy-qN5c1@kbusch-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB5959:EE_
x-ms-office365-filtering-correlation-id: 6fd54202-3187-45c2-3838-08de26fede61
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700021;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?r5w7DSRc5AJzs+j+siLw/hFD3oikHPcMUvtoLp6ZKH44Gh5cQEArQZRR6L?=
 =?iso-8859-1?Q?Et1EL1Hj23fpMaN9Puv12BOECxatn4gw9G2lNX4fQ7PfZAkx23E3yMkgJE?=
 =?iso-8859-1?Q?tle0A7gJ9IQt398Bpf2tFkqCUbjTT6QLG7XKP0JWGAvYG0QA53ENWOXoNi?=
 =?iso-8859-1?Q?db/+FO2DOD7PC0qYOhQtSfS0AnLTiRPY0yRFX/NsKbse8aEqnycsDnU9Tx?=
 =?iso-8859-1?Q?ditViUk1piHU4e3w77wG4EzyfggG631w0/n10RajDWPgqRChRkF81f1OdF?=
 =?iso-8859-1?Q?MF7c8eDNkN3z6XbbnhKfMASAAIGctgSQBHZ+b8qtlrfuhhTh4aIgDNPzaV?=
 =?iso-8859-1?Q?Xkq4ODlo0e2YxBmCZdVRQuaqVPqMWtphYnef3QeknbclZ/BvbuBXzoxKqe?=
 =?iso-8859-1?Q?QJ7F18R6fsGEf2geu/ftxA8iMg/YS4mxmaw9ZjhPRtxyq0T2YkHT52kl/D?=
 =?iso-8859-1?Q?kvHSsoQtLEbIspUqD0U4F4png8GTeQ5SnLBjfWSL1GTrEfaJO09r969k9c?=
 =?iso-8859-1?Q?qxP1HjHPGgg3GgbtHVp1Up3dtUONzwmPOqWGJ8asT87hGU0VdByd/23C7S?=
 =?iso-8859-1?Q?THVj5miqCBpcoc+Z5JpflUCRDjASSU2cdqwERksEvPnYxbcL3V2Rbe46Yz?=
 =?iso-8859-1?Q?QbFIfuX2noCivJyl4OS3EA41pS5zvjQsZtWaYW41U8HVUEtiGbhpUXZpSN?=
 =?iso-8859-1?Q?Vo1/jL0YlHRbbc5kStG1Ix50Lh6afBakLG2dTzMHvcz6sxQPMHiSf90N2I?=
 =?iso-8859-1?Q?KOL90SwLmJC2ZnzdvoCmxwU0nmBPI7uSMKopj2cy9dYRrxg8EiFQcgEyPH?=
 =?iso-8859-1?Q?wjEtoFjgsy2C+OhkKheZMGRNDKjWsYNuyFrF1VWockQoZW1tSkLzy/XCsE?=
 =?iso-8859-1?Q?35iH1pAdEy8gtD+OQFKTWk+VOOjXJfiYTRTyBoKwlacZrtvPszEfwJPZx8?=
 =?iso-8859-1?Q?uHSfbRpW0fMBgW/uy+LlmT0xA67jqAZwM6qHDFXHqRR349+8yYnllWQstG?=
 =?iso-8859-1?Q?0RuB3C4cQPBuKKv7Ha12MNpAm/3VYd80fbJKUtw+VRtnOIJVpht9MN2XBq?=
 =?iso-8859-1?Q?8z+MDbfbQ9w7hpS1fphp2Mpil+m0x/JM01LRaYzPvZ80NEHQ//ntKvtz8V?=
 =?iso-8859-1?Q?0+OfqM0CoxJFL/jx3Kj2er9jr5oYyguQzwGmxfPI70mBamJV8IRkhdyxu9?=
 =?iso-8859-1?Q?xhLBbz2p5wqRSlXDqawUXdfrzgz+KRnf7VZPf2rB/XTF+S+dL05uGPbDVL?=
 =?iso-8859-1?Q?ibClpywMF2iRO++gs9YJtp/Wti35CoBFVwIKoLwHdVQmys2+E+/ckhFx0l?=
 =?iso-8859-1?Q?opKqR40MdggG9/VO7Yx6YhCS8lKyVQQ0EoCscMyq40fOSrcDNLtKLqKJob?=
 =?iso-8859-1?Q?wvE8eSRBYyO8pWZZ/mEayOOmi5Z3AbIwyKNBLIdXGl1lYJOshGIZJr2fqU?=
 =?iso-8859-1?Q?HJx3XnNyF10katgDE7QLGVCapunmKzOo5J39ZwtzfbDpTWfT6/fCzrA/Fq?=
 =?iso-8859-1?Q?Ds99anpEStwGKUU1NXJM0x5z+VZeRgU9kZiAwRPOUdbogZ3P+bb0McJfzV?=
 =?iso-8859-1?Q?OBhAliFDkSOMJqozhXVDV2t/HCyW?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?oY+B1aiukEWZ+s3u9kpAkIXJ+8RE+7LX803t2nNjWwNoTDKoAw4Yf2AChN?=
 =?iso-8859-1?Q?cRc1QXhH7zBqp4ePv1Prc/j9BsAjSfGQYfsQCK+R8tdDbKeEPGnaTtEHh6?=
 =?iso-8859-1?Q?FeD45dUPgyA806KWI5kTMtOlVPaJmrb310BYssce7irIj7x7BpkIDb/tcM?=
 =?iso-8859-1?Q?z4ZP6cVu9ml4kjUJo93mIi4nx6yEyiA2RjgRJIqp21FY89PATzCwa71dOy?=
 =?iso-8859-1?Q?c1z0miGOjrxmAFYVbzgZ5MMUn+MBFkhP/ocuN1s45wlizM/sS0/pFGA6j5?=
 =?iso-8859-1?Q?0nnoJHfltRqgStEAunKN6dcQRlH/CLWOdl+T04XXS6vNSxep7gsk6BZGe5?=
 =?iso-8859-1?Q?7YGO0xHI07uDO0An2kqTZBMf7kduw2Mnbi1C3qPSY7m5q3w1lcOKiacZEo?=
 =?iso-8859-1?Q?uoW3gI9ZpHwk+DUg+AjMALewtYpdllv52qgUpO489gxTHUb3Se9sfufznQ?=
 =?iso-8859-1?Q?5tArXPXt0ge7gcNQEKRhSA0zIpiKiDX3X9r2wR5ryDzzITexkKdBjS2ow0?=
 =?iso-8859-1?Q?7TCDaEshyKFR1dI9zF/PlU9r4WneGAYlXvwbKq60CBAUSdAaMonbTP4A8e?=
 =?iso-8859-1?Q?xzltoSHbjJBRYvbeSCpWOS980WeqUh7iPuT/ZpnglMZVXYTKRu8sT8azjN?=
 =?iso-8859-1?Q?3bfpTAccdN4SHM7xQYyE5RU4wzE9xQ057Jpe7iWrcKX/B8J0g97jGHo3yk?=
 =?iso-8859-1?Q?UdmwseCqJzGqtWsmcv6jI7m8L9hW29E+6mSZS3kfeSegaWCCrjKJ4A8iri?=
 =?iso-8859-1?Q?jAjjsp6xoCruTMsXqdv4KbWvj/RzGajeoetwODGTHToaaK1/5NSOhocl61?=
 =?iso-8859-1?Q?IQaGB9AxKJlBLYTfNnlO0B3O4/ZJy1hWiRX/vI7w6plBlPnedYWg2J+2hZ?=
 =?iso-8859-1?Q?p8xo7zyVkxcOK7jPFbLvjDZQfGEpOd2XxcleBQ0J+jtOIN5YU9mz4CZ+qP?=
 =?iso-8859-1?Q?+3NfYcd445K8Mc791WfDRCcg/MXZSt5jb3NQxazHdJ30fL1pxdGfCaZFiA?=
 =?iso-8859-1?Q?aPNOTTOaWVe1exvDNgDrJgP12YhIAVTiW0zvRtU+IyOXNMakEzkqut2z8T?=
 =?iso-8859-1?Q?296dJjU/t2hGm8BDNjuWyVcr+cALH+U5tGEAsbahcRLH9Sga0UlMGVAJuc?=
 =?iso-8859-1?Q?7/bk08SJllWvJM/mCcwPobBJOyHp3GvMxY0meUa1aHYmr3jDPXKF+864td?=
 =?iso-8859-1?Q?AnppevSpMX0ThBS7Z2kCvUklDnC4xSqJW8YlMJliJCsp2m1HemIPQeiK1k?=
 =?iso-8859-1?Q?N12R3yrH2Q/isR0P/wGOE5Eut7ioM6b8veJx83bR2gxtaKBN5qhPqhnjZL?=
 =?iso-8859-1?Q?ww5aG0XsQeLtRgzm3dorwuty4n74GrAFuyryE8QgsD+2ZAC1iwgQyBi9ff?=
 =?iso-8859-1?Q?Z7EKQo4ec6iXgW8KsJgFJ9p9vv5cp6QkPFCteI/+XRW18HAUrY0NLdDNsn?=
 =?iso-8859-1?Q?HUEBXmgMrZckgF3+qYuNvrj/Xy9pL6khiWS4ujTyPpsyR8NevJIWSlZPzC?=
 =?iso-8859-1?Q?f5md+dRTkGB38hyr9nOquP+eCLJrFLip7ql9DAQFPh/ujayxzq22/lksNp?=
 =?iso-8859-1?Q?8t1EmpO9J9twtvTKZAVKQ1VPcuU1Fm+UI6//ouO79Qg2C2AJCB+b9fUxmc?=
 =?iso-8859-1?Q?RG98R4lBXtViGnT+PmQJl/yUihdEachZnc?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd54202-3187-45c2-3838-08de26fede61
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2025 00:02:02.7482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ar66e2sG9qLA0rnELQFzW5BypWG18lVCDMZERV1UV9p+HYv4XhWoYd1n6EvcQy6+P14uHL1hka62ctQm5a4lgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5959
X-OriginatorOrg: intel.com
X-Stat-Signature: 9zikqu3bgxmrmmuaz5hyxw41wtrnzypp
X-Rspam-User: 
X-Rspamd-Queue-Id: 92C4040014
X-Rspamd-Server: rspam01
X-HE-Tag: 1763510527-265421
X-HE-Meta: U2FsdGVkX1+l6tRKBgwr4a1O7h1ANVZiiwq/NoHUxTN3vDqTEkfGegSKpLeYZppRpyWRSp19//D5ZEj1ex9pU1W9iWh3XgdQZxfwqUwGNX3/a6UY/MRzXyEckdUe5L6WOGwioYpdZGXOE2JrWdrLR01pC7bb26nWo0MGN3GBXbzXgezlgFU9nyu5AEKGc/Du3tJ17Tsaq8iAYNU6d2LW1SR82CWD+9ajnEDHJblncvI9Ch+iMKgGQ4aq9vmv6XwA7Yyk54J80ym1IH1YXV+OfjHeNprm9AnHObRKb/R3YT8VOg3/vhKv41YSteWtaorceRdB6XAv7Gd0lxNRliQ6fLPlxhE5FKrERY5S+FkFL4TfwqI/P3VtBF+sXfob0VfpcaxznCSsk1iyXsstsbi/y3WdQ3I4DOm66D8hVvpDoMzfDOYj+CUOVOVIyWqZsovUi0yZM2QJkbhl4UanevaN6u9IfEV+NqCDGOkcpWkj/q3enldh3gDk9SnbfsvQX4SkqLir3MAQDqw847ayVbcwcoMr+1MNkaVXCQKcF6gykdQ3O+n/UrdA3cErPGGyGEsmC8a7e9miG2enLikTUo/y9yvtLbfw9uYQkg3frLOL/mphhTI79QGJK9D+h5qwfhMd5eaCTI+LO68OF68iclBsRQCW0lU/Cx/bTVN3aJ8WIeu1cD7vKL8C02yXAxnortgU8mxcmlxIXBUENUkNh2IMYXBbs6tMtqt3jKHKXJMZNHtL85TsbSCIZMVpRmDOa5JmexkBXK9SUpKzYZgy7s9nk9kTQ8cZZ5ZeSNG/E7hSt9keZ3dR8BopUOV5BKWoyrNE3tOWRadA0TiUmoqS7sI7yYHcu+zpbotUrElnBOkjEnYoOgjWBDSGJINDN538R9oRsotbLTOv28FC8k+a67VcDY9egSXPqY75WXVXthLmqbWnow2AEExTvjyBrDkZ9dKlvaaPf75b7lmY9KdlELA
 96oDgU5f
 XPoKTVYgpGZIIE88HQhwwttyOh8xHE1IEy0vvl9j7eRHC/XX4OqFOdS0vXk9Go6spOWOa60KqBWdRp/MpCzS3vQQ4pk7gDihvo1dn6Bfx5U2WbeaUUY+DTwx/zZEfIFH9rOjCwV8xzHc+oTb+XvaMmulgUXBXZSNAhOPiJ6g0eoJ29z3kwJ9SlsHOPI6qWIgvV79OLXVuh7XQYOWMtKXayRbGFMHl5o7FlADP4oH+yiZVhFwMPWrCe7Ecof37yHqqtrumaah/2ntGFfc3xf7y6y6+GTmTfSRoUMo0YUon5hglSklJGJIXxBgcGexxCiM87pKPw5UmXFz9DPHIsd4eL+m0XRXOvfbUAtbSY915+pTUxO+5rx2UFU3ihELpEIiGLVBuqJIJm3SDEbSINdvpQCPs7vTNmogJoRI08ePZo1nlgu2Xpv5kODq5v8TCLWJa+2xzi2UWQvLuKIw+AMsBcLuJwV1m/UjhEfI6Vq3AEFCMkG7hWWDq5Z9TbtppVGpFatP5f7bItAThGrk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From: Keith Busch <kbusch@kernel.org>
> Sent: Wednesday, November 19, 2025 4:19 AM
>=20
> On Tue, Nov 18, 2025 at 07:18:36AM +0000, Tian, Kevin wrote:
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Sent: Tuesday, November 11, 2025 5:58 PM
> > >
> > > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > not required with only your own s-o-b
>=20
> That's automatically appended when the sender and signer don't match.
> It's not uncommon for developers to send from a kernel.org email but
> sign off with a corporate account, or the other way around.

Good to know.

