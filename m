Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA64CC8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 06:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C6B88E0124; Wed, 27 Aug 2025 02:32:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076A98E0105; Wed, 27 Aug 2025 02:32:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E59998E0124; Wed, 27 Aug 2025 02:32:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4AAD8E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:32:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A405C0493
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:32:42 +0000 (UTC)
X-FDA: 83821568964.17.866CD84
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf09.hostedemail.com (Postfix) with ESMTP id C1612140008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:32:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eMJaHTnU;
	spf=pass (imf09.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756276359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=md4Zu2pKRhBj+Df5oAQixcenLMue87gqPC0fAxlwTgo=;
	b=O3Ir0RphfoShdp2RceC0zVzQxtYC3ZbcJ/x1X7C4gLB9wKsRqQvZXHxbUumJOWx65nEYeX
	BKGasWY9pml8oQ+XXP9ZUC1WkgKk0Slcsq2Jtpv6cYZaLaAr3qSTX5zXfCapO9eCiQCC9F
	/JcSoC0ll2XiaP8nXr+t6r18uGgbF4E=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eMJaHTnU;
	spf=pass (imf09.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756276359; a=rsa-sha256;
	cv=fail;
	b=HIEDuZlrlr7nWjK1Hys6mvbQhTEXu8JHfWFF5Vz+stq3L/SCANEoUN1oZ64QsfyQAP1lX6
	1tO9SjNxqF1VJGvEcWisEiaCB+KoF4O8R0pJ7J59VcICw4IJXzC+4iWLdtJxr+vu26grXD
	a091U2ydMoKavFyWHcv1YJsvcdU/wHA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756276359; x=1787812359;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=gf6nfaoYQ/1aEU0LJZu7kOF4pXya3xfbP9ladAofKfw=;
  b=eMJaHTnUaqG0weZm0TYXrNIcOoQtzAPEhGZq/XJVrh6ZoIr2LoGjbN8G
   B0ZRubME1JEt13XB9+E26jkGoOxke9ebB/KQ+iJrUwahBqbKeflvyz5Xp
   hFea1A+fhVL+LRUuNStSDVX8LnSkMMGj2lY9/s5Cw3TCUaEp0wAeVUAGK
   psJiNfvARWHPpNcQCHmu5ibDtE04+4NKUAp/QluISWMGIgBS7g1fVyvpP
   Ih2dLC4EZiAZ1XMCqm5ATJJoVc8sOYPT3SGntBsgGRy5FoX/E1vWgDDGr
   efaqppwlqkXFrwUs9YOmqZhqPMmzXLkV+wjIQgRsRKTbAWyRTY2HKaNb/
   Q==;
X-CSE-ConnectionGUID: mxldlzPOSti3/Iq8XMyN8g==
X-CSE-MsgGUID: AykX6InjQKOgq6WFg2st5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11534"; a="75974945"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="75974945"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 23:32:37 -0700
X-CSE-ConnectionGUID: benPBfa0QkOgr2TNfz8oLw==
X-CSE-MsgGUID: HAKb8XdVQpGxk/YFs8vRMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="170594765"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 23:32:35 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 26 Aug 2025 23:32:34 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 26 Aug 2025 23:32:34 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.80)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 26 Aug 2025 23:32:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sU3FqpbvtZub8OGzxGEQmGeZIyPa/0EpvVIf4uOPr1UoNymc1lL907jfUXFFV1tD8k9g+AWTxB/SHmzxpgaW13rq38rN+fQWwVFSRipm2Kyhl0jKBf8nktLZ8V0q88os7jkicqPOkVUE9LKuCflLfmo5mTT2LcI6WXTwPlLrdCuMCRedvTkqXdDnmt5n6BVP8i0rDKGIA8Np4GSr9+enpbjyy1jU93o0jCUjVXCoJqdLvGWLQCFv0qd8EYaX+SnETKTwftnechDOFniSsD4IYmTq+Blu0lzTGN4v0PCn7LTN/eMDLe4BffCNnROEw3y+wLq2YKXgAmoSOUF2tWn10Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5bNF5dx3RmdgfNaG2ASrvlwWqqGPLoVDDv9PYknDX8=;
 b=oSOICX5MXUd03T+Ls8ZQ4r+1vWGYEvEv+9OYz3lyKTYFkU1kwNiXHFtFzXrCry24GHxIuPIfJX0Lzdv+wd91/pb+HFxBecw/qYzhLE/A7d2myIUDl8bVX1x1nMkw9FJD+gzVmE+odEX3/kMvuiXK8UeF2P1FFHpHHrWqPnJOpTQMzWS1jrc4lkJP7N7Kix/VMjYXlpkXmJja7rctU6tlKWdW4GmufZqxWiUb5CNkAV2rRTjFTqkvFwG5fLJwPEWhI2/uH6PV3Jv/x2asBRztbWIffAt9D7QRiCeqGRCZAWrltHhNV0ynNip0i1tLvLXr4o8Lex8Pl63ooNQW/OJRPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3934.namprd11.prod.outlook.com (2603:10b6:208:152::20)
 by SA0PR11MB4527.namprd11.prod.outlook.com (2603:10b6:806:72::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Wed, 27 Aug
 2025 06:32:32 +0000
Received: from MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2]) by MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2%6]) with mapi id 15.20.9052.019; Wed, 27 Aug 2025
 06:32:32 +0000
Date: Wed, 27 Aug 2025 08:32:15 +0200
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: Samuel Holland <samuel.holland@sifive.com>
CC: <x86@kernel.org>, <linux-doc@vger.kernel.org>, <linux-mm@kvack.org>,
	<llvm@lists.linux.dev>, <linux-kbuild@vger.kernel.org>,
	<kasan-dev@googlegroups.com>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <sohil.mehta@intel.com>,
	<baohua@kernel.org>, <david@redhat.com>, <kbingham@kernel.org>,
	<weixugc@google.com>, <Liam.Howlett@oracle.com>,
	<alexandre.chartre@oracle.com>, <kas@kernel.org>, <mark.rutland@arm.com>,
	<trintaeoitogc@gmail.com>, <axelrasmussen@google.com>, <yuanchu@google.com>,
	<joey.gouly@arm.com>, <samitolvanen@google.com>, <joel.granados@kernel.org>,
	<graf@amazon.com>, <vincenzo.frascino@arm.com>, <kees@kernel.org>,
	<ardb@kernel.org>, <thiago.bauermann@linaro.org>, <glider@google.com>,
	<thuth@redhat.com>, <kuan-ying.lee@canonical.com>,
	<pasha.tatashin@soleen.com>, <nick.desaulniers+lkml@gmail.com>,
	<vbabka@suse.cz>, <kaleshsingh@google.com>, <justinstitt@google.com>,
	<catalin.marinas@arm.com>, <alexander.shishkin@linux.intel.com>,
	<dave.hansen@linux.intel.com>, <corbet@lwn.net>, <xin@zytor.com>,
	<dvyukov@google.com>, <tglx@linutronix.de>, <scott@os.amperecomputing.com>,
	<jason.andryuk@amd.com>, <morbo@google.com>, <nathan@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <mingo@redhat.com>, <brgerst@gmail.com>,
	<kristina.martsenko@arm.com>, <bigeasy@linutronix.de>, <luto@kernel.org>,
	<jgross@suse.com>, <jpoimboe@kernel.org>, <urezki@gmail.com>,
	<mhocko@suse.com>, <ada.coupriediaz@arm.com>, <hpa@zytor.com>,
	<leitao@debian.org>, <peterz@infradead.org>, <wangkefeng.wang@huawei.com>,
	<surenb@google.com>, <ziy@nvidia.com>, <smostafa@google.com>,
	<ryabinin.a.a@gmail.com>, <ubizjak@gmail.com>, <jbohac@suse.cz>,
	<broonie@kernel.org>, <akpm@linux-foundation.org>,
	<guoweikang.kernel@gmail.com>, <rppt@kernel.org>, <pcc@google.com>,
	<jan.kiszka@siemens.com>, <nicolas.schier@linux.dev>, <will@kernel.org>,
	<andreyknvl@gmail.com>, <jhubbard@nvidia.com>, <bp@alien8.de>
Subject: Re: [PATCH v5 10/19] x86: LAM compatible non-canonical definition
Message-ID: <lcjxrakk556uveux3jxfkvikw2av2gwod22hxrt73zonh4663t@qn5u7xwbcr2f>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <c1902b7c161632681dac51bc04ab748853e616d0.1756151769.git.maciej.wieczor-retman@intel.com>
 <9ae927d3-0a66-4354-910f-155ff9ba3e0f@sifive.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9ae927d3-0a66-4354-910f-155ff9ba3e0f@sifive.com>
X-ClientProxiedBy: DB7PR03CA0078.eurprd03.prod.outlook.com
 (2603:10a6:10:72::19) To MN2PR11MB3934.namprd11.prod.outlook.com
 (2603:10b6:208:152::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3934:EE_|SA0PR11MB4527:EE_
X-MS-Office365-Filtering-Correlation-Id: ec3d7472-de56-4051-6639-08dde5338091
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?mdnUHrR7WaVokT/tgmZpy5v3gFtEVvbj/l2tESe1SR20pcUPcClMz7t4Ek?=
 =?iso-8859-1?Q?sh2nN4M4fRvupGN1MZcCDeyH0gP7oYKXGJjb5vI/Q3f5+ZBujzlPbElGZ+?=
 =?iso-8859-1?Q?kTydNpV3nwdT6Msl83TvdWsKEVb+PdFP2x31DWbBvKTvUf0Gy8t2eLMptD?=
 =?iso-8859-1?Q?Anlv6kgqht7kcPOln3fibFrdNaEQWocxisK9eEYadBmJPdx6pxGZGKhSXa?=
 =?iso-8859-1?Q?CDbcYxAtpOA7R3dQi6e8TGXM8i/IBUOCCmBkx7GNIn5PjFsvNh+kjczsev?=
 =?iso-8859-1?Q?Z1jcEh2yshNDQOCaWzd5jiY8EZkuAZ78H3Fu8RxKRV9X3HZljZPzVzYeaO?=
 =?iso-8859-1?Q?ffBJ8P9v0Vf7tA/Mld0IGOljRBS54CsyNg/OLaDW2cQ+KYXLxJ5hGiyhSr?=
 =?iso-8859-1?Q?6X2d7DfTjR6Or6ekeApDXh/yB1d84ASqX00ZDNq6ITqjSzAMy2Bycwsi05?=
 =?iso-8859-1?Q?yD8Da4fzlTLF1UW2ErfixqcrAjqFTyNpj4vK8pskz44I3uWzELCwxcxVwJ?=
 =?iso-8859-1?Q?m4uNz1SUWDkPef4//ZXJt9X1KmuVc0liBwcT3W96pjy9r1tqU8T6/HUhFW?=
 =?iso-8859-1?Q?eQJL8sGd0gGPcN6TMgmoIcBpiPRt4uIq8ilnYI0u1Rn+eBp4iPUED1GTZT?=
 =?iso-8859-1?Q?YqjmgQBq8o8YtMS29MafF0RbCrrfc2b5jC2l2Pe4FBpGhxmRVzNJR3nSIx?=
 =?iso-8859-1?Q?DBg86ZB61LfTzwwiUQPgTLCG2wHHuWg2tXRyEEqsaMu/4uvpUrEjoVsrOA?=
 =?iso-8859-1?Q?+7SlF9r397kvqh6SbLCq+V/SRfm3zOAmaKKJKOoanjHnf8qNWrBClu2/Zp?=
 =?iso-8859-1?Q?if8PctjD77tppFFeiKLcFVOAgyrEHlmlLT0YtwMOkoeqQkyONWHe/W2agp?=
 =?iso-8859-1?Q?dTmMCtLcSxfJ4YZSt4+kQ54tW2Mc3apWXsUYzKbfocFMBQ/n4AMDWXL/u0?=
 =?iso-8859-1?Q?AQ0oqPU3jfBXh58cW/kYpxYJ+xYoTTFTlvBJKRwFMtanZG+udcEIIkP3F0?=
 =?iso-8859-1?Q?7GXKoi/03eNZPYXYLTJLmG55LW1NjsZaKbVX0j6Xi7o5C3o9aJldhSuAQR?=
 =?iso-8859-1?Q?a38ZMdZwq3RJqhbM58ITVg3wffv3pB584ZVxzUnlXtnptPI0mDIThHa0zI?=
 =?iso-8859-1?Q?lU/316QkNEbBtMWlh2h5kY30T6W1dJhrRkLiObRtFE6oAAQ0vUjnE1ovNq?=
 =?iso-8859-1?Q?uqCdDDqYRpSKdyT66ZSwKcbge4fiMbFIz/VPBD1lLOmN2kcSfSdoluBKSc?=
 =?iso-8859-1?Q?AyXTOwmDQp0Qw4SjRzGAWwEJCxH1AX8MUoDz+m9tj/wAbdOayTusKfrJN9?=
 =?iso-8859-1?Q?3sT/l3bsfqVZ8Nj5s+pCoWLq5D/ad2YwhpX0Xs9RuxN1FqbgwzQBzGzNe1?=
 =?iso-8859-1?Q?vpgGdWLB5kswfbzD25+HGX+Zlnw/fPaMLBzuBlDQseAs7Oh/Boc5kBNwPJ?=
 =?iso-8859-1?Q?u+x3SMbq0UbW0t+hcz/PhIwl/Agg/L2x6+558A=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3934.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?vKzNuGA6bgUoMvQ+qU8cG72Xu1ZTyeDeA2IejFGmsOFJpKRuPGf22YJNK4?=
 =?iso-8859-1?Q?/dfmC1okrBaSKJ+rb8hEgAwVrAiMJDyqj0lt4/bKXAE1+9B21MIdgnmO79?=
 =?iso-8859-1?Q?R8MxqiDRu5iNogiQ6dzC15rCC5fY0p2CuB7sa5y44Jh8GM7OOXfbwNVejs?=
 =?iso-8859-1?Q?EmhgaTfRwDS4QJT4H3YRgTFR3er2XxcAVGxrIYj5acACgvLVPbYCBSKHAi?=
 =?iso-8859-1?Q?3OOSzSzBjiyzX7Tn6hO+bdLEJUCNdkVo1oGfBmTzNFId6lF3hzImSgBd3X?=
 =?iso-8859-1?Q?NCHRTqigBgfEmi+CebDHicC3j77/mr5/PrU6haFb/wOHSzOVI+MpPh80ZJ?=
 =?iso-8859-1?Q?VUmezbphBkrT8vWTLCqaJPZlvVFpx2uK4fmlsV0BNysmHEiOGXycpKoIdd?=
 =?iso-8859-1?Q?5QQb7d4ykRnNDvBbSBfP+Nv7UVAKsPZC0IR37A1HwRpgUiEykmuJHWFrDv?=
 =?iso-8859-1?Q?Mtc3xfSYQ+2nectKTuQd+EN1HTIWff97rCtPUpMX1oBWVGbQBh42whAD+R?=
 =?iso-8859-1?Q?27m5Lc+vHP88Bpc+bMiqf4gBjIoXnzGLoMju0D5lP80zyD/S3fFWs24G/Q?=
 =?iso-8859-1?Q?8PrZnaYQsu9KMrL9jOJC4qEWncLrI1Wdi7VEp8+mA76T6wFqjHYRK42CfJ?=
 =?iso-8859-1?Q?zJkmvhPzfsz9srhnx0YMSq9lXybpkOj3gwziNh30L9EEUEK0+5Fx/Rib1n?=
 =?iso-8859-1?Q?W+yKGioRVB5eCtdPPBEM3yMRNmlYfxQ3z1fsvsaL2Zb0n6cyzKhJgWAs1c?=
 =?iso-8859-1?Q?otP2euXzToTx2hyJaaYi5h9bxMzwReoRQlUBuchr7+8xF7waG1ZZ7SoA2Y?=
 =?iso-8859-1?Q?kaxBrXYbN6U5UtVITHGLrD7jnfr7zE/On5AlPBzcmKooEa0YPoJ4AKelYy?=
 =?iso-8859-1?Q?CGV450OPHelOBaIThZyYN0mcEK6JcwD6LsSOMqfMI3myAlFZ8a+qtPplNQ?=
 =?iso-8859-1?Q?BP9yZh2Nx5kehYuFUylQX5iI3NHP9zW0JBV8CsDoEZErZoFsvLsBVq1GOF?=
 =?iso-8859-1?Q?7LXMiYhc5J30jGX1AtiojsNwug0TpxYPlRKxAacRIKL2y7HA58OXgm57Zs?=
 =?iso-8859-1?Q?bwVvkR05THh7J0SbGRzjmv83IlVouKfheytEpmsxO4/A2hchkHAv8vQdL+?=
 =?iso-8859-1?Q?RGMMK7EBqgIg7nR/9cDkZUbubs5JLfbneWmr6OkwQbSi0pf9Ua0egowcaY?=
 =?iso-8859-1?Q?ZDDUswSivis4JhqMqViJuiLat6D52/xiKWhbkdihFumRq953ESTM+4ZMAw?=
 =?iso-8859-1?Q?B1dxPCbbkLlfkPfy1c8bEXDO0pVraBlhuVdMWfQdgytTdiN121b+EPgV4F?=
 =?iso-8859-1?Q?MC+vYkOrvO+zVIUb/YAGPXWIqu52wWeeQZY8ezwTua0OGJcgt3NefurPwz?=
 =?iso-8859-1?Q?o1iBAET67JbfIMat4T2o7UniYtfPzjUaYJFoGGeC9m4ye0/QPYI6zUuQHV?=
 =?iso-8859-1?Q?pIbmuHPBZiOV6Q5leswdepQbMbSWTQdYgWp8TJQCLs6BJjLmyIZiyz2DHT?=
 =?iso-8859-1?Q?ix0d3RYidDodHaKIpIAA4fhMr4/UKkO8+qrPtFq+QjCCCaMf7oMmY7OmeB?=
 =?iso-8859-1?Q?BDEaGazF7HiuUWBbzdirfVpDmTbXOtNv3fAqYSa/veW5AspC7lNfayGpFg?=
 =?iso-8859-1?Q?Idqs6pVwaV9UrCXpFXeZKLUX7gl9PM0Q3nTHgPIzTDAF5MfCMka9QJExgU?=
 =?iso-8859-1?Q?176oyEzR05/ONhK2sO0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ec3d7472-de56-4051-6639-08dde5338091
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3934.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 06:32:32.1467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1iVsCWgIlEbEoG1EjAFOr/B8XcLvS1CWr45ilcmmdkusVctN9+6Yf9KlSA7KuiQ1+f37ifqgFAVyi4T+hKYp/ZumBA2Sc02U335na+wwUA0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4527
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: C1612140008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: bkopewyfkendmdm6r9qopp69z3itqpxi
X-HE-Tag: 1756276358-947599
X-HE-Meta: U2FsdGVkX1/wEx29/fKS5hhqHucFfSVOU+C20zBxM/v0kKm471BNb7KmOUNArn7KWb03J7ARG9vivbNzXKrSWgyihc2zx3V8ryAjqN54FiIYBN6oOUJmr4krQPV+k256LUD125F2G0hYQ1MpX0s3opyHOKm18xYLOT6xVc9aGQYoUbYVOcZDqE+lQJ7Yl56j4RBScbhtbg2JevgwmvBd+M3j9gfoUbpWIAZmH4Z6eR/LExyLR4XbyfUdnoRqGIC9iDupglHpIQYOXCU75ScRCu3/bB8i2JzHfVXKm2oavatiAKC+DPxT2uZz2rys0/2CoTFSNUmuy3xa0JUOho03o919DdtzDqk1UO9E4CchNLv5UOOrcHs4qTGrj93SKpCfz+NWMWnZKx+5NyY01iFnQVfWmkVk5GDA/eVf3KX54Ort/CY8Ok5lKSfPvR3RlM/IQqztA3qtsZbosYH+Jar+NKHfA7JIQOUT/XX5b2GQ/pS7jYwmgmIdpPgKsCsP9739xy+OsGX2ZvFmxPxlb8gCcejTgbe/jNojFn9yOr3uVW/C91DIUjrS88AWtLgY3Wq3QOme0xCiENOWbZBhQ9AudgLGeU7VRsu10lH5Oh3IgSssSDNJwxpv4wxIljGY2shF89kyAM3kY3cYYIX7EAMnoi/todq6Yb3mijeq+Tu2OqWl3pbMXfioNgY95Xdsp7aceesgEBesyp62E4JKpDC1L3vdsauQYTkMZSk3EihunQVA0mQQJpB9RgItN8KyVavAmXOE0yfhxvaZiMUAaBCgsmyjA7i3ccv8GxIxNeqr5BQALeMTdpbe4WXy6ftz2ABxK6WP4+QJjxwvEr66HvBt5xwUizZv1/gLcv2IjmnkFHQKBZR/jPvzjTXcRl5jPYY3qddP8rL90gG9Oji5m8fn3uCihHpJdEnGW2VadyVntbh3+v8op7HbKnk8xKySTXQEru15S/Op8I1I6nhqsCK
 L/vrSm0x
 mct+d9WJhCp8hTo2aUxr1bUHetKesppuniKl8rqOtZHWKL7QWU4Fi5CXiKj7aYoH5OZ4oxkMy3dSHYIvVaLpTLgzzCnTfWvQ9bhpcGiFzI5bzn9KziWflTRdUhiC5W+S0eT/EsYc5ZaiFIwtbknDBNp7565uyk9wSKIiwwSY2NhRvScrG9AW+wfNwn80xOycALGPQbxxpeZIhXxmYU7HPvZWS+lZ7meOXaiXvymshQ+6mETSkpvD/i61wKq48H4a8pEHLD0hltyc+gyYBJMId78a8UbQQc+0UYg8VblM4KBF8XWRngTWzLS8KmzN19nWvmvFtrSbRSPyyTv10mB43l4LwRAk8BpnuPSYp5WfqVjDj597LePdJo8CAZKyFU3xHXGVn7VueQYYzdn54KMOkxezpSxysaRqiZ1bzqCgLWZ8n4NkmqCqtspfvpkc0hg1PwdOdXGT6/S+ZFZa4FOc9cE/LBCmT9rF9RroiYUPDZNnl7I151zzou/05r0sgXI5uumffZBuHjpHCEyxi47JvzrA+fUnvmrr70miFBLwFvHieu5CuI2oWR8dWDcijoDlp+4G/DrW8mfrkxECzCPcjAex7zmcuiKzKc/P6CfqMCoNPGU3H/KUG/EF0mZtZwcBKmIUprKmeCneJmF2Bxn+/kNez1eiWpsR0SEt+AS3aA/HE64rCdNXa91M2hQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-08-25 at 15:59:46 -0500, Samuel Holland wrote:
>Hi Maciej,
>
>On 2025-08-25 3:24 PM, Maciej Wieczor-Retman wrote:
>> For an address to be canonical it has to have its top bits equal to each
>> other. The number of bits depends on the paging level and whether
>> they're supposed to be ones or zeroes depends on whether the address
>> points to kernel or user space.
>> 
>> With Linear Address Masking (LAM) enabled, the definition of linear
>> address canonicality is modified. Not all of the previously required
>> bits need to be equal, only the first and last from the previously equal
>> bitmask. So for example a 5-level paging kernel address needs to have
>> bits [63] and [56] set.
>> 
>> Add separate __canonical_address() implementation for
>> CONFIG_KASAN_SW_TAGS since it's the only thing right now that enables
>> LAM for kernel addresses (LAM_SUP bit in CR4).
>> 
>> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>> ---
>> Changelog v4:
>> - Add patch to the series.
>> 
>>  arch/x86/include/asm/page.h | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>> 
>> diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
>> index bcf5cad3da36..a83f23a71f35 100644
>> --- a/arch/x86/include/asm/page.h
>> +++ b/arch/x86/include/asm/page.h
>> @@ -82,10 +82,20 @@ static __always_inline void *pfn_to_kaddr(unsigned long pfn)
>>  	return __va(pfn << PAGE_SHIFT);
>>  }
>>  
>> +/*
>> + * CONFIG_KASAN_SW_TAGS requires LAM which changes the canonicality checks.
>> + */
>> +#ifdef CONFIG_KASAN_SW_TAGS
>> +static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
>> +{
>> +	return (vaddr | BIT_ULL(63) | BIT_ULL(vaddr_bits - 1));
>> +}
>> +#else
>>  static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
>>  {
>>  	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
>>  }
>> +#endif
>
>These two implementations have different semantics. The new function works only
>on kernel addresses, whereas the existing one works on user addresses as well.
>It looks like at least KVM's use of __is_canonical_address() expects the
>function to work with user addresses.

Thanks for noticing that, I'll think of a way to make it work for user addresses
too :)

>
>Regards,
>Samuel
>
>>  
>>  static __always_inline u64 __is_canonical_address(u64 vaddr, u8 vaddr_bits)
>>  {
>

-- 
Kind regards
Maciej Wieczór-Retman

