Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38168D3B7DE
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 12:26:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 659956B0005; Mon,  8 Dec 2025 07:26:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E35A6B0007; Mon,  8 Dec 2025 07:26:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45C746B0008; Mon,  8 Dec 2025 07:26:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC9D6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 07:26:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5FD713C07F
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 12:26:01 +0000 (UTC)
X-FDA: 84196225722.14.0E7DAA9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf24.hostedemail.com (Postfix) with ESMTP id 54D10180013
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 12:25:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UgWnuHuH;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765196758; a=rsa-sha256;
	cv=pass;
	b=dGvuDSyhn4MqyRBo9EY73eHeJD8aaSSVkC6LjGrvxN7C1HWyS/9rc5YH4qhdZKTNQqhDuC
	Xp2iDPdXWWIeYBIQT1dWTqE6FboCm2x26/fBMsl/OyOEBPPvFq+/vC3T9uwY2CmRyKyo7G
	NP0cFv5DHKM7WCmZ3YVVVs7JebHaZ38=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UgWnuHuH;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765196758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/RX9Nsoewfv+8LUm7TN78mq2aC6CQE9uVMB2hJhv6g=;
	b=oiiYPRPclcqYAlBmIW1sJYrQTXh3aBEfaTkWif/o7GjfS/alHrH07C6QKZDnKiJlJPDwd2
	WlLG9g+NOTqCdZpF3siMBYk8X6LXP5ZKPPGZbVbvap/nKj0hOdjq8t1XBoxS+7oBvZjozg
	JJ1NLWDYfE08xtWXFdP8r1Vfv8CgyUA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765196757; x=1796732757;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Q/RX9Nsoewfv+8LUm7TN78mq2aC6CQE9uVMB2hJhv6g=;
  b=UgWnuHuHTLlG5AhbXGh6IsJnl5vfExpA8v1rtDCKx0qdIy96YV7MzBME
   uPIHvnnhnGS1fjn49+IqcItWX1xMzRzQB0vcTAwaEHU0MhfPLikjvPMym
   zlhht/ENeJCautg0Bnqv21OIkH5JYNGH7TO1CWvrrM6h/tfbdDnE6Kdr1
   iFkz1XzS9MEi5DJ2wOM/sCTABAKZlOmWQvKTeybrnmZSTkSzA/AxFqDx0
   01OLs3d+XedbHAh04LKVSAuOxkx18BFZh6VUibBMDGuUbdV5Aq1lSCwaN
   LkRPpdp6+L9h81RokX3lYqUlQrdzQQ4XO05xVJCg0Qjl8bEt+8WQaNzkj
   g==;
X-CSE-ConnectionGUID: pkMUIt/0T5asq22IB3B4Cg==
X-CSE-MsgGUID: bzVqZsIDRaSYrwP68f09fw==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="77458272"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="77458272"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 04:25:56 -0800
X-CSE-ConnectionGUID: cOdw1OcYSYyupLFWB/3L1w==
X-CSE-MsgGUID: H96vMNs9Sli1rW8P8T0Zvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="200394217"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 04:25:56 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 04:25:55 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 8 Dec 2025 04:25:55 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.18) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 04:25:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nVPd0LhWWdHK+UgZhtejJ27LRaG4bzFExYST3msDwIXkrenmfPshVdlWtGzB9YtmovyxM1uwugnpd7vR01b87+J9N9LawKdMudHQRvRZIzcO0A2LQ8V9oBH1I5nKRDcR9TyygBw6y6rRb6FyiAfNzeSw9TtxDZakFegS7TeiDYxs1fEybhlqQSHd4YNIjq5R4c07+Aw8Z2CgDulfwWwlWTCcO0sDdyGfHPXi0MV7kVlnqbOy5izm+xzcv6kszbuDTKRQnLV/l5CKsyA91jDeCePImEiSgEgvi/6ChLXDRu0sr8SHOjwEoLutmxzqvaF1NkoCFDgVzUMV/j2xCXLTpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q/RX9Nsoewfv+8LUm7TN78mq2aC6CQE9uVMB2hJhv6g=;
 b=gjz9elKnH29JwteaBXvV7TpeEoJd1yaWZ8LGQA0puHoibH2pcopnFgwFUE+chn7ZVK4bO0sTZjSGfot4gP17vW2gYfR71jHdNndMHaF38AKYm7By46x5Ke8gKFftaHX4ul3yBG6akQZSTGKmA/igyGPQRufLaEy88SKY/j9AcKhkfEsn38YrDDmSMCHJ2ATJ/z9IGCgyuSlVPS8rAKCXZmzavzevqkVO7ijwQqIGXL1Mmr2/FccSsL53fCihwnRHJ2MYitNa5AnqIeKzfHZj3UTdY9rIjouijL5XJ+Z5vbeSFhkTMguZL09IGf/h8xkpzkQkvpyxTxkJP/WodjLXeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8768.namprd11.prod.outlook.com (2603:10b6:408:211::19)
 by CY8PR11MB7107.namprd11.prod.outlook.com (2603:10b6:930:51::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 12:25:52 +0000
Received: from LV3PR11MB8768.namprd11.prod.outlook.com
 ([fe80::154a:b33e:71c0:2308]) by LV3PR11MB8768.namprd11.prod.outlook.com
 ([fe80::154a:b33e:71c0:2308%6]) with mapi id 15.20.9388.013; Mon, 8 Dec 2025
 12:25:52 +0000
From: "Kumar, Kaushlendra" <kaushlendra.kumar@intel.com>
To: Harry Yoo <harry.yoo@oracle.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "vbabka@suse.cz" <vbabka@suse.cz>
Subject: RE: [PATCH] tools/mm/slabinfo: Fix trace disabling logic
Thread-Topic: [PATCH] tools/mm/slabinfo: Fix trace disabling logic
Thread-Index: AQHcaCVCZFcoi+nP6kKzF97HniIvqrUXquQQ
Date: Mon, 8 Dec 2025 12:25:52 +0000
Message-ID: <LV3PR11MB8768E870DF71EC1D14E5AA44F5A2A@LV3PR11MB8768.namprd11.prod.outlook.com>
References: <20251208084255.2689901-1-kaushlendra.kumar@intel.com>
 <aTaajTO9QY4eSLR1@hyeyoo>
In-Reply-To: <aTaajTO9QY4eSLR1@hyeyoo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR11MB8768:EE_|CY8PR11MB7107:EE_
x-ms-office365-filtering-correlation-id: b7fd9b12-f35d-499e-008a-08de3654edc1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|10070799003|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?irEqXfBiSkuwoMcaMR0adaPSlyupVkmyLOZKrYm9tYRzZzYNxv2ljnkls7I3?=
 =?us-ascii?Q?c0KPDZSQGtf1CFfumTEvbzrX/X8r8v8OcRPiR3k+M1pUnahzbNMlr2rpDaK3?=
 =?us-ascii?Q?y9mb7c2DzuL8I/4oi9xE9sLl5lecqWHfZEPT2c7wf+6YmrzmgRKSEwJD6e2s?=
 =?us-ascii?Q?wRaXhlXus4Xopt5ZhzU8fDb+XKurs6TcfZ4BjassqtQ19T8NsPJjyMKck+Yb?=
 =?us-ascii?Q?IWHf7Xa8rWRMSjGQdDYoDK7X/Kj9Mg+MCW1G6ZSxiPDpLjczxE6Jb1/1uXA5?=
 =?us-ascii?Q?LhYJignbaBFDgViMgWZa8eL/lQQdQjt3Xv86TyhLeM5pE+u2q26E+c4UIneO?=
 =?us-ascii?Q?+tkpxx9Jx9gmy54ACaskORkwq6DJqX51gSX9otTfULzdZEd81FkEZTZREeQI?=
 =?us-ascii?Q?ofXafQs2r699SizC7kn65+xI9OPfRLhbb2sM8WVOAc8T0U1Zgin9tijSrMEn?=
 =?us-ascii?Q?gitn2KojxObTPgu7hJ5s2lNg7yOfe3Dj0CA8RDg0LvSALcSrga1isx6E/YxW?=
 =?us-ascii?Q?4acdCc9txz1TIKYMv54sp4XEdHvwtmsSQmDsd+viOnO2jNOQ8Z2HqUdBIc2o?=
 =?us-ascii?Q?Bxz12k75MnyQompbmjLi569PleVxABElYYbbYyVXze17CTWpowgyZYmQ18JW?=
 =?us-ascii?Q?HdFYzGv1AoKsKvvfOgEVnYXtzx9RIS28QaNV5l15hBC+95YNeFUcTIjCOBW9?=
 =?us-ascii?Q?fX1Gysnp050JDofVk/kt7C2SKMDDx4IMAJgrhfHueFW1NEKh318H5VzeGG4I?=
 =?us-ascii?Q?wgZ2yxMoz5Mv5YWKpd+0nzYJSuk7snhplZXr52026yH/h7vaALI3J04f4YDE?=
 =?us-ascii?Q?PDRzLUpsu9eOtxTEZwbSGTflx05FwtmcEFngZxESiNkUEDDf28rq/3P8earB?=
 =?us-ascii?Q?pLZHu6rlw5AwG/gw/Um5hBWBlmWMfl9iE/f/C6RLzVE3DupIX/L9mw6BSt1v?=
 =?us-ascii?Q?2p2xA7kywmsr26hja9go4+wyAls0IANyAeSdbWbDW2bY8SCkN7zjsXjiePVZ?=
 =?us-ascii?Q?yAl02+gvPfuxgt2hqwR84NveTFY8Ef6NILrCKFC+2NygFE/NE7/LJBwXRCVJ?=
 =?us-ascii?Q?fsceC98JKAwZbL9s5RHJer0XR0rYS2X8igi5sBlLU5qDIF2zpAO+vBgE7CU/?=
 =?us-ascii?Q?cLOMn2MekN0Z5x9OaEkQm81YyNqznFH0kcoQwxCefkuhllijM85w3NbceTTF?=
 =?us-ascii?Q?rFEq8mR/btVIS3cA6vVxdURHj6qzkNhfcp0I+HCrVIStlSHKoZg+Cp5PsAMu?=
 =?us-ascii?Q?dR+LUivdSMVfdqypoaKEt3JDpE4lwt1Smz0IGHyH63XmoCkCGNymC19YdD/S?=
 =?us-ascii?Q?QKPf/9M+3rQ1f4pNvPJMXJ+K35aF2FeNkhOuDQKSidW1IerxVCLqYuUbyrX2?=
 =?us-ascii?Q?f4YfJC5P+S9M2jJ6ZS542n1EDLhSisbjEZ7FtasP5FpJlFLTZPsnZevNs0et?=
 =?us-ascii?Q?cKKJKWirvEN3K6G19VojZ6UxVBLwGr3aoSl7wfrPOyNJY421cE1kOZ6mYJz3?=
 =?us-ascii?Q?8xsPTUtCrYcKz1g/GP8tJ91KPGhHFC2LyVxU?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8768.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(10070799003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pEt3sKT2X5uY3/OVyIV/o0jS5X3vtjHe0NTpJlT5POANS+CSz3pk8zJvt2cK?=
 =?us-ascii?Q?ri3ofX5CHTx42nz2e8JyVeIMim8ed85uZdRAYQFX5Z/vKC6oPWS13+x1JQOj?=
 =?us-ascii?Q?W95IrUKNOLt/1CDNDc0vVfKDl+8q8QNJ0syi9umcNVCnQa3DG/9MaVmrsVsz?=
 =?us-ascii?Q?aUXGxXPO4kXe1aNQfIvQk14VrE+kzRf3fAwD9REKe6kPu70nrgKPcnjnXpPQ?=
 =?us-ascii?Q?4Z+xJdW5AfkzGTebjlV0ZSYDazrnx5sJdGy22y2KPqq+0woovkA3S0O9miVX?=
 =?us-ascii?Q?VJcISqNsdXpMh3t9sbKCDYVnxym8r+nR8yX4AIq4mHvh9gE3iXJQTE5RRnu4?=
 =?us-ascii?Q?tgdUptY7H4XMSu9AzANhXJ7XmujI8u2tNxXOuHepGts6GslMtNYY3GU5L6Iw?=
 =?us-ascii?Q?3jtlyw3JhAWuVRm5ez/ih+22H8kYYZ+QMj64GxQFLRpO0sFOe1E9NYAv2uYG?=
 =?us-ascii?Q?jMgAjdHWV591NLPmQe5QCq7dSW1YtfBaumovNEa1rN/LL8gK3xn9uJnhh2iN?=
 =?us-ascii?Q?jWZxAAstZnxu4tjCerPexjpsgOxPnjECmoW3bqXZHlJ3oBMMp4BatSfFftGp?=
 =?us-ascii?Q?nQFwQfqkfmrWvYzKLQ8u4Q+MB7hI+XT4F1vOJ8HDSr3FpiOCCaslcgab6Eko?=
 =?us-ascii?Q?N3Ren7L6w2Fk1/24GT5tTAK8zlVpoZm4ad4oQknYqtquQ0oXkafxTBMW8aMz?=
 =?us-ascii?Q?cuCfQgaPAu0n7DPLHo7mVdAPjFUfEW7X83dl5VHYMqDIgmvD20VMV6pcOXNI?=
 =?us-ascii?Q?0UUBgHz0fEMMb2YbOJmF1pn/0VcW58+tCHv7bZFFdRXI6E9z4ZUHWIXbbKvE?=
 =?us-ascii?Q?7qsoZos4uXCR0MDx1e8nSAj416QB7LXR3YR9DEogTLlpHnyiIQbMR0T0+/yG?=
 =?us-ascii?Q?PIoOgRniWihVePN6a1b/PfAoqs5wxQly3HbjrzQ859CFn5iOgr8rqArYLUWD?=
 =?us-ascii?Q?tVaGNbAtgae9c0i2Vx8adtxgXj/Ryigl5K4SMpC8kK2x/EcSIDNP0dIePl2+?=
 =?us-ascii?Q?7JsFKxjaJI+0XF2FxScpQQkcboAtmSMSAASuRwUc8+756s+ezIYc5Uqd08i9?=
 =?us-ascii?Q?spKBSs3BrbKGsuIcG6ZP3oXvLWbmpPbyLdqpzcCn8m8KBOKgdfeXOuI4l5i1?=
 =?us-ascii?Q?SWsXuddg0jTjSXotZsPA7N84F+IE5tyZ31qI9xtst6JY3txKcrd/B6hwnxpV?=
 =?us-ascii?Q?zeyyE7fD2NwxbEhZ3AK6Qv92TJ82UrNCIptVj9XIYJjTgt6Ba7cGwHNW6RwK?=
 =?us-ascii?Q?/iTXU4O5Zm87dhSEGkkm/pWG/MdYB+HtyTmhwHnFL1k3GKWoeIrvX76V2aq3?=
 =?us-ascii?Q?seINppKjp8FrqrBrtFxi3AN9IFvkqNrbLv60a+UQyl4G3F0bDfsbJ0026NIj?=
 =?us-ascii?Q?59I0qecGbvSMMCDIBHN4bRx2L4HAT6na+ZLHx1L/SxrdtAD1605T+8HbiIMh?=
 =?us-ascii?Q?w+CeSvZXXe/aHx5CBGkOohO74o2xwcUQ0GyFUyQZeC1gIoPAE/Wnv4pR46GE?=
 =?us-ascii?Q?KOLONz+SudOU51GqvSDgzn0thdk2EYRdy05K2PaQr46DOTmq0bFZZVpdQP4k?=
 =?us-ascii?Q?xQ3oHH22I4NeDbdeDwb5odWdCmJxUFeoePV50/lXdAptG3hzHKZWgFYJZa9v?=
 =?us-ascii?Q?99rojXzF9fQoEMXta/lWaPFu933DxqaJdtvYiSITKBGu5C9Mw7FB+zJmejxG?=
 =?us-ascii?Q?8amN0g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8768.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7fd9b12-f35d-499e-008a-08de3654edc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2025 12:25:52.6761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /MbQHCa7MZupGn1KOomqFff/ecFDQpcidm7ykQpB4EZqWEZ90umu2qRxIdPgJj+VdTPCzMTqNLGf/sfHq99RXyWwtaxzGby1RKSokE5PttE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7107
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 54D10180013
X-Rspamd-Server: rspam10
X-Stat-Signature: wh7wqz6wacqqutjdhwzu61sek5x71t4b
X-HE-Tag: 1765196757-91607
X-HE-Meta: U2FsdGVkX1+1hNV8CcKZw/ScnMbnGshbgZ6YlP6W1NSJh6FZh9SFwqaKr8CMAF0XHTQScBhSwxWpdmkbeU/5sHvXV0f6/6SYIcuHDBhyRv6Q1IuPWVYXg3i4B21XQI8yQDEWgRPN/Ny33C2JZIg/tbx3std33ThHUprN3JyY8cV/HlIx2Pjy/VIIT8wAvnbBEmpjh5Wpi9ocJcres5H/WAn43RxZd2sEsVmDsfaz97G1kwciHJ+vPIxi3Mj8fFrTldSmlwK+7WmUXvtIfDIWyGtSyu20yrEdjrV5wEkSRJz8e4UujQY5RhlQHa8h31O65262El9/yAMcpdFsNaDehGg45C+7pQbHphr6AAC+A+dq0os6FrUwyCSXs3j88+ZPszeKZnD+DeTNNn/zvCxRtRjGH5DBe2+OzPT3An1ffmSzcJAnE+YHBLu8tpJQ9Zh9PK+qhsub1xksR/r7XhWJLlDGcDyxiDD+85P25+iFwk2MMrvIGKG8zOOqE15DJlmNvIa9S/zMmx2358zJwGUJ70FoM2zw3S6FTnFQsT5lQKeAYCy53ahj5DoOHzva1aTPXKnPdGdUuc6qaTIj4BPkYPujMJIieWMJ5W8h74nyjzQ1Bl0+/DHyAJ4URvYgYCO4lBPv8l73u+v4cqkiWvvSiOoWnobbLR56iEI6pWY85oKXF6kQ7IBAebtHl+t4gp6EvIP9BjZvOL5BuUIqdKyDWOBnBFzE5IQozktpxtypskWpVHfHERbjaaFmka/kbfA3uFrhjQ+X9J/QkCBiOzykIUj6lhUNy95zVj+WGVKBAxEVKZBC3TT7CyQI5iRnMG5jeS7tJF3/gTHjkT9rblg+PCsfS1lzSg0qxt1l+1K9d6v8thVkgPKfRFMtv4cAcdV/OIyh9asBGQ00vJPAF5t5fB7cv1fIAsyI3SwkfnM1g9A/SZL4ZB4AZ5WisLC7YuoENxthmR0KzuxaAENEnfq
 5q3mfDr2
 i4fI2j9joyeqmy0dco0q40hgEyeEMdnnNWJCiyizqJOVasfiaPcO5a/tef4W3z4FtsuAo2Kjgmg00P27k9ibJlRJN5BZ+dGOzEp5BkPSbNUs6ZwREGle7hrs5A+lLcwEL3x59+y/xs5SRpIjHQCgwoOJ9UjpEvyapWt7n8IMhMM6stlTzI/ECSN/9diuyRNcCwr+TyI/G5BprfT88FXxvTygaYNLaai7tFQJDLeQG4z9lqB+uj6I5WKIOMHAd9iaF2l4JXtNETf4wHu7wcKSA3L5oTyH32gBvxFNLeT7A5yeVh+a4nhVL5xMPE6E+CEDcVR9A7NtD4jY8K55oavbiD8/yKD70aKX7kkPgogL/dBv6eGyqduxJCU1vPTr0T9OGs9Q05hG2i/d+GCVADGmgabAaSyb0CmgoKR/4h+1J0wQ0NWsZsCxR1+cJ2UZxha5d7iI7+bqYr9S10RhJWpIfHzfYDasEW3boDx6cl4mK44NcXAuuEDudri5RQSj3Iw2Jkyktx3ZHrGilPSh5OX7iSzknZvw887LYQ4e4hOVOPR5kG5Zvn1bm2Utahab8t2xG4lU4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 08, 2025, Harry Hyeonggon Yoo wrote:
> On Mon, Dec 08, 2025 at 02:12:55PM +0530, Kaushlendra Kumar wrote:
>> When tracing is disabled (!tracing) but the slab has tracing enabled=20
>> (s->trace), the code should disable tracing by writing 0, not enable=20
>> it by writing 1. Fix the inverted logic to correctly turn off tracing.
>>
>> Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
>> ---
>=20
> After commit 060807f841ac9 ("mm, slub: make remaining slub_debug related=
=20
> attributes read-only"), enabling or disabling debug option at runtime is=
=20
> not supported anymore. slabinfo's -d and -dA flags are not supposed work=
=20
> on recent kernels.
>=20
> As it turns out enabling or disabling debug features at runtime is not a=
=20
> good idea anyway, could you please working on dropping the feature instea=
d?

Thanks for the context. You're right-fixing inverted logic in code=20
that's been non-functional since 060807f841ac9 doesn't add value.

I'll submit a cleanup series removing the obsolete=20
runtime debug functionality:
- Remove -d/-dA options and related usage text
- Drop slab_debug() and set_obj() for debug attributes


-Kaushlendra

