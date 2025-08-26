Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76D7ACA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 04:42:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1EFD8E0098; Tue, 26 Aug 2025 00:42:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF6DE8E0090; Tue, 26 Aug 2025 00:42:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BED08E0098; Tue, 26 Aug 2025 00:42:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84FC28E0090
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:42:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D0CB59F92
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:42:15 +0000 (UTC)
X-FDA: 83817661830.01.1C34D04
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8161D80007
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:42:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="XvJNJ/1m";
	spf=pass (imf02.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756183331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J02x/HgCuwtrJ+zb2sjSynU9LTCKaXxVKoRNG4Kd7rY=;
	b=3CiJt9ZjlgtXqWuEgwWr+bU57PML+FhEPQmy9AGO4GUfIvsr3ObFndErPQnRq2Woagg58s
	3XxBP9oCp5Um6TKbFkkNcZ1Mq3c6PIia7gJN7pmuwe9OyFLuvinjWTs335AV515ZQ1gyus
	ZGjCFFYo66lahAr1/VdXx+/GX/BEFcI=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="XvJNJ/1m";
	spf=pass (imf02.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756183331; a=rsa-sha256;
	cv=pass;
	b=zQGrE3hSBHOWSdsRPYdEIsvTrmmjw6xoEICZvVtCyDFBWL7fc7cqbbmCWciSCWIoKxTptj
	jkRmGhTuMfjris0loR1nExy3C8Y8QW3ljBUgzZ7fUKV7d4dtAld6nTQKPKgUTgMuIvXqg4
	vzXfPSn7V9Q0rfxV/fo92CC6FukiUrw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756183332; x=1787719332;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cVntlBN9vvajU/WLhBRUBE2G7KbKJq9PexZX9qP+EAg=;
  b=XvJNJ/1mOektEG1h+Y81Rjr3vIEsV54l0pobDgNc0fnq7fBCv57cftj+
   7j4ZHpu5lQN46yximXpNoj+iFQUqX4LzV1xhHbetE6Y7lWk8mJfpBDW9R
   Hs5i0R9zw1m59RkpBMNLiRPMnMTWVADaPda6ajT3iNXeZh7DNQ4VDXGf0
   FlcZ8ooMLQV6IfEteECSCxM3+2bdi247HQ7OhZfhtJPWNPv6mat5DM3B/
   J8lTlnxpgoax9h2uPSGIY6VKufkGe1aTUQVYJcmnxMYZs5eCJiysaBMDI
   w1hQLsHNfXVXmkH1uGU6O9HXjA7DwHfAB5kZN82VW1g/phN2NYNEUXQ1A
   Q==;
X-CSE-ConnectionGUID: x08Y6Wi2R/65XVpUaFXrtA==
X-CSE-MsgGUID: ln96kdloS4uRazOTZQrD1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="57608536"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="57608536"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 21:42:10 -0700
X-CSE-ConnectionGUID: H1ououUZTaakZcq3QCzB1w==
X-CSE-MsgGUID: JOwiUvcTRf6YdrEkR9Otyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="206632233"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 21:42:09 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 21:42:09 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 25 Aug 2025 21:42:09 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.65)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 25 Aug 2025 21:42:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IxB1yYvOcREjJJ1D19yPNygV2KD7ynY21RskF0Wys7ZvP4WySreuWQo0exjw6Q8ihDtV3BcSTPuA4Dv8sA/B1AYWqzRSKyhLUqsZDzMtQH8/aMFw/MDPpmhWB0n4c0kbMFKPGaFQMldYcnQ6wgDux4cEabi+ARLAyIrDFHd1K90mF7MIBKoEe0q7Djgz3iICrX4IPw1UBDFekjtj0/CDhMDHCbeq6KuRTP4eBJ0zsvRv7F3K97sWFMOxliAZHqY4nILR+OD6rx22w87r5GS61IlzL5sBF6i1ZLrBrnuxVr/fNuZmZsJaUSRn0RcNrGemDe0fnTap6eqVOacs4cOJJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J02x/HgCuwtrJ+zb2sjSynU9LTCKaXxVKoRNG4Kd7rY=;
 b=F58LZ+j9sKdKj2XJAvvznMGJ3MSWXiaq5n69bwMWYkVxoQNf+PXYGfCbvlvBoDqSdE/ggy84UDCStgrdmgIWEsd5WFajY7tvelh81DPo8fT16FpzKTrssDLnLZsUJkQbW5J2WRVyfH7oq7pMe1nY6OiYDCyeb9nbrXTsRqpMYpLjv96ochEMSJPWHEZ8VfB+KDJ8XwKHDdUudmfApoFQjrqytHVnH/NhIfNuav8E6Og63r8XuKr7MDmsl0bMkUiwB78pfUtDkriDWDuchVy92tq8MmdykAsqUk6OsMRru9v0WEitf3VfdEy21LX/oZnC5gh+9MGXjsvt6lyTpgfpBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by SJ0PR11MB5769.namprd11.prod.outlook.com (2603:10b6:a03:420::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.15; Tue, 26 Aug
 2025 04:42:06 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 04:42:06 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Nhat Pham <nphamcs@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "yosry.ahmed@linux.dev"
	<yosry.ahmed@linux.dev>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "senozhatsky@chromium.org"
	<senozhatsky@chromium.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Thread-Topic: [PATCH v11 00/24] zswap compression batching with optimized
 iaa_crypto driver
Thread-Index: AQHcAp3n35LtSdVMgUSnKQGImY3Y0LRZeWoAgAnL+YCAC+jI8IAD0bOAgADL1oCAAHxNAIAAJ5EggAALHICAAAZtEA==
Date: Tue, 26 Aug 2025 04:42:06 +0000
Message-ID: <PH7PR11MB81210C3555CBD57EE10DCD61C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <CAKEwX=Pj30Zymib2fEoDW9UyD1vAwxRKO3p28RPtK9DZWAdv8w@mail.gmail.com>
 <aJ7FSUdvxtZyiHBq@gondor.apana.org.au>
 <PH7PR11MB812143269E98B00ED4E5BE4DC93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <aKv28XTvAITuq-p8@gondor.apana.org.au>
 <PH7PR11MB812163C97D4C533F0302FA20C93EA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <aK0KNAmQh_JVgnML@gondor.apana.org.au>
 <PH7PR11MB8121473792ACC3AD50D5F129C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <aK00t9ld3YOWJo1I@gondor.apana.org.au>
In-Reply-To: <aK00t9ld3YOWJo1I@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|SJ0PR11MB5769:EE_
x-ms-office365-filtering-correlation-id: b0b73dd4-6f8c-4346-671a-08dde45ae8f1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?6r5AX9kSCPY5T/BSuMQ9KNtNTnE/TFTrnWIanDjJVekRDP85LwXbR9AxEXWk?=
 =?us-ascii?Q?YXugMf9cIO74Zz4O8U3PmlB0WeK+CBA1A0NqPE8+pOa7TvOivn4mPhisnsWC?=
 =?us-ascii?Q?amdo+QYNhwhlqwqIKcsuUAZBce94dlRIiB4M1Uan/iyywphmVOvokWIY9dNk?=
 =?us-ascii?Q?LcuZd5t9NtwQO7CKpEPEaSWoCgrNSWRkNRTlM7h9oM2oaGkRmU9jM43ORKFU?=
 =?us-ascii?Q?lEhngsXF9BaFADsw8vjXUBz9dmE4LHKN4Am84lhvhCWzfuEGqnKPp44XGZI/?=
 =?us-ascii?Q?AFIrfqqnauaR+wKfK2M1LtNsWMa3GEXNOk6+M5kZByMO5Kj3VggrtyKY32sG?=
 =?us-ascii?Q?BniJn9ZvL1NADK+6zMOZwjsOhhRhFWYkeKMoUtosjFD9IQE7QF0Jrs+QzAC6?=
 =?us-ascii?Q?dgF7ZfAQEZGrVCIZwTIlOF4afksQT/oVI8IXmIRmdr7WRrqP+9Yf/XMOSf9w?=
 =?us-ascii?Q?BIPObHp+EkLw7JzFas2Fc/JIji3jGuBRIdytDab1rAAcfb3jDAixjz89ePFl?=
 =?us-ascii?Q?zogxPC/IOez6aE/ccgzCmEeZXzPjNfulo4m2LbEwjDBSg6KyzYoCVgrukFJ0?=
 =?us-ascii?Q?HeNdB7cM+oWhxxy+ajIOq6C1PSvxLH6MuefDV7h5B/b5t82LGnKFQyg24rOh?=
 =?us-ascii?Q?D5qZJN4iQgLNBeylfEE9h3k63rvLmYEBa5E93rPn3SuplCX4QVrWSQhqFCEq?=
 =?us-ascii?Q?oIbsVS+f7D9waMaqdRGc/SY9x1SCkrk+o3VApC/cdbCKDZzVLF709p8KBA7o?=
 =?us-ascii?Q?rlnXJUjY2q7wx9ln/l2nHgRUDtYylIctiWxAMDWhoF6ElXMhlhfQv/Z0BhlX?=
 =?us-ascii?Q?rx15CdmnY6hI7a9vPWGz5FgP1PxtZdaC/ubGBgvQyLp0tA9K6jHLgq/hhrDP?=
 =?us-ascii?Q?jHsRfPcsd9kZqDYVH2WVV1WwL0ABqtFXU6VK/tDkr2WJIzwVM1mZqXCoVYUP?=
 =?us-ascii?Q?+wpYzvPfNvkM7nFozQYRBBjBf7o37P32azo65YOhtKLJYTjtjLltxpgrv2EX?=
 =?us-ascii?Q?d6+9CYexlOLlBPnnsPwj5pBpV4C5NzrBY2DcAVHW8krOfVFxPIdJP4Kr5UgS?=
 =?us-ascii?Q?0vnX6nE/xLl6bm8FcjNZVReDzSeF18/kQZd6B7741U0ceYk+v7c0uRIorUPo?=
 =?us-ascii?Q?c3iK+fMMvCB/okIkCRlWxmHvPmuZKBx5l2p9fg8TV9zsqJT3B+TytXvDz+Xu?=
 =?us-ascii?Q?QG5yvm1VMyKYSEL80r5sosrY8B2QGIyl1KpnOeckbjPZPwzSd1qolz2z1V69?=
 =?us-ascii?Q?gODWLuKEq1F/OaylVqp4r0pkosYcJVjP4uhs80j4UrxoM9VVejW8bb0Hq8s9?=
 =?us-ascii?Q?4GBRVZktTL4ZUBh7kN6X0BNzCf35Vu77SUnpfzT+K0S3zrL55/+DZOP63WSp?=
 =?us-ascii?Q?frsuPjT15HmwlPSA3naUpGgB6lnvARazQb7zQHxJ8TB72mURu6GQ+t3TiJ1q?=
 =?us-ascii?Q?SMWNgu6dqpQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IVLA8Mdz+sxs/2TZXh4OvyvBgJpviBOc3QKB1ke5joPioLW4QLTUqkkvq+yO?=
 =?us-ascii?Q?fHZuUYP1IiJyQj7TDejWLtp6Yb0mhiWcOAD88+63C2DfGlepHQNL2KTCJRu5?=
 =?us-ascii?Q?3G+sT5rM+/Zx7dy4xwqf8V4pVxKIqDW+63VMHV42Z95GQl6aPNVx7/HdLpoT?=
 =?us-ascii?Q?pBVvY4QxRt6lmX0K90x9rnotqn67dCPw259GAGhCHS8TOykjnb2cOZuicDy3?=
 =?us-ascii?Q?I762mBwNmv7/2WnN7w05to7PbUHQf5hf7dnkvOAANgjk0lf/Rn1mRYZ7VR5T?=
 =?us-ascii?Q?x4CiFutpRtMqQs7BX+usqI11cnl1YrztICWlP4Q1U8tVppo4S03mriHTejDN?=
 =?us-ascii?Q?CXzSPlQiVoqHO0GmC0OSL6QF517HIhN5F39QgW+j2jNEmYkZ/LJuoDO79tC6?=
 =?us-ascii?Q?T9r6ft4Lvuxhh1483e0/9QFEUN96gtX272VgzjdK9b+JuufTqz5aTKAYYNJ+?=
 =?us-ascii?Q?t/tDcpfaroDlj156ktPPRkWPNU/kY9eEGz6nCBlo9oHzvkqQbjytWHe4WVkw?=
 =?us-ascii?Q?5IlasO+49kE/2JK7Ly3+1b/aIcVpETD9xQ7Hdjg/EcoijNOJfkMF6MHyCXst?=
 =?us-ascii?Q?fCQtmvTXfkXE0I3098wEbDF+Ftr9o6dZHXqmESqp8qg5rscd3eEXKO7ggHAe?=
 =?us-ascii?Q?tsLrvvmFf9R3HCD+Ai8vPkCzSl+Vh3A/Md06OHj2hRtQ66/v3l1TFIt3d+P9?=
 =?us-ascii?Q?tcfm9iJoAFjrpIblgbdnlZiD7w4ObGlpIi297MZPcMjmOLy4MwvZjInNg5Ym?=
 =?us-ascii?Q?bugShzc+yQJvPkCDD1VXg+o+OzKkQBU3uJbYCRgIVBbJ26k4DQalqsit1aY7?=
 =?us-ascii?Q?ywP/7e2LN7k8Xlhk24fwOjT+jAYLUOAiR4FoxbSIEbigziTgsSUSQ2P4p1sg?=
 =?us-ascii?Q?poW4krZLykT4UG9fTbFgZKRhhAmbhnyhB0hQwY4yk1jpnIGjg9mIoOpQG7l/?=
 =?us-ascii?Q?nMlMfbUgrG/esuz03f0Y86FtZQlzr1SICdBLJXRPNTwymQ2NNkDHH1pcJDJ9?=
 =?us-ascii?Q?0QD8vkgtnfiXaUnyB5qpAQUivcwxMG8NTKbUBPjpvId2VMcmuryMlI7V4QGh?=
 =?us-ascii?Q?tGg3r9wnE8X0Q1lW7QpxCVOGKMJ0U7kjid1iTnVKeGmoGRUM0Jrh8QRE1YW/?=
 =?us-ascii?Q?LiMKZ0/wD9mvmz9StO48l/oX0LDSocAOfkLJCV20FpaGu1YHjcJubOagU4Hp?=
 =?us-ascii?Q?AuJeI6N5vFZXpSnAjt7XjE7RhkjytXF5QdkB9qyzlbby6Yd8BZH+7/Y9QM/U?=
 =?us-ascii?Q?U4C+kKZrKVQ1dLUnOD2YcIntGN3BSwQhaBuncxP/1rBZC5ASlZgdXOKZ6z+W?=
 =?us-ascii?Q?4eoi9Mei/GQWweEYmx8+Aw2isEKYn7jPPpJjSeyYFo9wu+CA3Mhqq0uIkWvJ?=
 =?us-ascii?Q?LQboeHq/Sr8OP+uNJ6GE/nmNGbGhYISHJKa+NzVlckleLH56nzVq0zxQgPfJ?=
 =?us-ascii?Q?4S11jKOjYtj1q3RFi/q3EbBiUv4MOghXtyeNl/AtJJyvEs5+2fJPVdzhPVCz?=
 =?us-ascii?Q?VFEqTHQGaa7gOsBliiil72f6/8JVDyfnVtDU9cbRbjjblIe2cBTj48AzyaU8?=
 =?us-ascii?Q?oxr3nNsQjJ5oMxYWRO2AH09ulamrOAjTwHCgQHg7slacpIWQ0/D8W9w9LnEG?=
 =?us-ascii?Q?Qg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0b73dd4-6f8c-4346-671a-08dde45ae8f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2025 04:42:06.2655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5348XVOYqEIVBRLi0JwkqjVJVFDv+lxHEphgYSvVABPwvv5oRiz3wJzZ8KmBVvkFzhqaDuXWgyMJDr2SHbWshf0ZH7LD9DtXVYVWlaiuZTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5769
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 8161D80007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 9hsua117xx8uisjbd4pzdixmpz95dutp
X-HE-Tag: 1756183331-891473
X-HE-Meta: U2FsdGVkX1+1UpoBAl7ZvjFiLRewJO/OuhlhjMpcgq6+liQwSF0zHcp8P7iKVZ9QnZXUlca3PyvpIcF+Ub5ZOl+BMJ+SbC2PIyr8ldNR0C+bSbHj8k3BPa8hHLJbXqVK5BvpF7WROAq41Zzxw51omS2GX1fRFU8x7cPPdvNsMdTthOoxo2DM2LROPxesGTB0d9/0114mNCwXemrQST+Q2PA/72QLsIW+B2DmVcDRz84y6v/VC+CW9CSWmmy1i5Zh3ilZdsCwhBarLm4ccXsx+UbBa4F5Z2hLyHcs5Nzwjinrwf2v/scWLWyv/qlcz/dLlEWFPkCaFYAzHXAf0LUr1jqXbw5yQMm2eNutb1ea5+CI+YyYclO4QCL+opUCWVxPloiRJQAWZAw9GxQ40K2L2EfNxTCykRniyr1ixSgvvyWkFyUskyW4Q/EJQNUgGqckCG3WUEYNauFD2LMb8ZzGhU5pki+L+5fRLprFlQJ42OHailBLhXp9aiT9RUTgAC8TzgdNJKpXkLskORcHLrn23j7+tNWySe7Sd2cU5DwL+SRUKekAO+tny84M3ioHFxBu/8utO6T1ElAX23euSG2Je5kbUuour1OgzHu2QMdYT0qTpOizbVTX+vN7x2ijLc54Fakw67W1WF7pbMnt7T1VMe3E7We3gwwzjztJERfq2wkwZqD81/97JQm8iupRdy/aRChQIzPjORalcaC4y0689ebvaN0Hql7ubxVroySNU4m63kiH8PxJQh7TA/rlfkX7GBns1RSfv0VHafjseE4dEsqCh7Es+yvqgUkzCQ37xTg7/fo64gsvVTgq+oqvMIWIdLFuUgMG7XvDy0qcSIN8br4mS9veXNRJOAx8j+00GRUIz8wWBanZk0sknslPxOGCt1xtDfKdmjtCHR8HhP6ylWD8qYQvSlRAvd/9hWK69r0QfWvRkv6YNrarIHKw35xBZZINtDWXDmlGl/gZ7RW
 hvLGuJVu
 RKV4ZCskldqn9XeeLc5kMUFgvBqnhlm7Y3f55gOmBpxaL3U1O58+ZTz11z3ykj67xATugMzaZJIVdHj2G+nJ2g2n4vxsic2TBJENMzRdYHf/gd9aDwdWbiYiVcB+ZICNT/Wf4nvhxgSOYx+DKL1AmdnJMMuuZ8nqDE64hf1YiwSVBOkprpa+tx5GFnjusKajogrQecE9wmhY3tr2nPTAeVm865UXns+O9RHNUUnS6IE9Xe6S5baGXDdEIPzI8dpVJ/PEF77n5/X+M4b9vF+sc+uOI2rP8qdojOXNcs3HOJaupkHwXWiWN5pLARjZ69uDnwX6tWUc6bXLtrAaXEPEKqCd2sIkMZFDVZ8KEtw+HvwHjSKUurJfF7VlYhdjAf9eOO5PXM3p745i5haeiYtkYBCkZjqlOQ2nbjjbwYcEY2Pwq6m1RwtRc36oJ0dY34Gb6q+1M5t/TgR+7DB5yjIPJdUaiZT57GuntjWRDmm+P3M2CCX6rTgtGR4iD5NEzcF0yJnczxv1OfZ2I/bn9sq8SVHUuzzgOw8NYS77yoXvZv3dAtSrzyElaPcOrCAmGj9WBTTOt9U97EPiuCUBhVPlkgzi//lVG+1WWT7lhY5TxWfoKWiImGR0L2yTX5x8wa6hWoY4gvxrvg5Y4US/fLcflZRajc8lBxhf19Mv5/wLv28uo6By6BbxvOUhSoNPmS7a4d539L3Sj9U6NmaQU28SQgVrK/aYmgb54D3mNXMvO5J7XFfDzM4MuThZ0dMRS+TrwDi9oiPsR8IJYri1929jjMwhAhv+8K/y35ZOPifokDZmpVTXYonhzlYXMnWuV49ZImYePuiI1AG0EJJ4QiV0sCWifmJC86sSTaDAtzr2SdbRu+h83GjADQO6IYe2ynWWvl2P0QrTZ9P7qLimwBgEKx+yoByiHOL1fKftDZnEi3KpdXhm33MO2g0YqkHiosoefyg4/2jVa3o9Ra2wIzAmqOi1Ju3ni
 9nzb6/0y
 ntHlsOCUWhYwB+oreIbShcK+BslJwRdgtcvIPYSQYM8ZHGjjEv5z21CWu5ilsTfeQ0P0/oW43gm2jieiPjBxfsjne7gl4GimnnoElAvR0xT9859H6fZFJMSCG7sx/a47j5BtI7MDxv6JJET8WCY6rJgITb16op9dSYSrgUE95Vk4VTm9qvkoY8PLFUWcDRC1GmV/EoxoSB0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Monday, August 25, 2025 9:15 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: Nhat Pham <nphamcs@gmail.com>; linux-kernel@vger.kernel.org; linux-
> mm@kvack.org; hannes@cmpxchg.org; yosry.ahmed@linux.dev;
> chengming.zhou@linux.dev; usamaarif642@gmail.com;
> ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; linux-crypto@vger.kernel.org;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>=
;
> Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v11 00/24] zswap compression batching with optimized
> iaa_crypto driver
>=20
> On Tue, Aug 26, 2025 at 04:09:45AM +0000, Sridhar, Kanchana P wrote:
> >
> > Thanks Herbert. Just want to make sure I understand this. Are you
> > referring to replacing sg_set_page() for the input with sg_set_folio()?
> > We have to pass in a scatterlist for the acomp_req->src..
>=20
> I'm talking about acomp_request_set_src_folio.  You can pass just
> a portion of a folio by specifying an offset and a length.
>=20
> >         for (i =3D 0; i < nr_pages; i +=3D nr_comps) {
> >                 for_each_sg(acomp_ctx->sg_inputs->sgl, sg, nr_comps, k)
> >                         sg_set_folio(sg, folio, PAGE_SIZE, (start + k +=
 i) * PAGE_SIZE);
> >
> >                 /*
> >                  * We need PAGE_SIZE * 2 here since there maybe over-
> compression case,
> >                  * and hardware-accelerators may won't check the dst bu=
ffer size,
> so
> >                  * giving the dst buffer with enough length to avoid bu=
ffer overflow.
> >                  */
> >                 for_each_sg(acomp_ctx->sg_outputs->sgl, sg, nr_comps, k=
)
> >                         sg_set_buf(sg, acomp_ctx->buffers[k], PAGE_SIZE=
 * 2);
> >
> >                 acomp_request_set_params(acomp_ctx->req,
> >                                          acomp_ctx->sg_inputs->sgl,
> >                                          acomp_ctx->sg_outputs->sgl,
> >                                          nr_comps * PAGE_SIZE,
> >                                          nr_comps * PAGE_SIZE);
>=20
> I meant something more like:
>=20
> 		acomp_request_set_src_folio(req, folio, start_offset,
> 					    nr_comps * PAGE_SIZE);
> 		acomp_request_set_dst_sg(req, acomp_ctx_sg_outputs->sgl,
> 					 nr_comps * PAGE_SIZE);
> 		acomp_request_set_unit_size(req, PAGE_SIZE);

Ok, I get it now :) Thanks. I will try this out, and pending any issues
that may arise from testing, I might be all set for putting together v12.

Thanks again Herbert, I appreciate it.

Best regards,
Kanchana

>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

