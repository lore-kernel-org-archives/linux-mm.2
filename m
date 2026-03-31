Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52CBD109B467
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 13:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 939366B0092; Tue, 31 Mar 2026 09:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EA066B0095; Tue, 31 Mar 2026 09:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B2026B0096; Tue, 31 Mar 2026 09:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 634446B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:37:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CA14138C7B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:37:19 +0000 (UTC)
X-FDA: 84606459798.22.8272A99
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9B1051C000F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:37:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G01Op3Me;
	spf=pass (imf18.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774964235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=5Wup2agZZ61Z37W4JVnKSIj3OJeQzXwHSPWqR1OUN6w=;
	b=72W9lZlJPr/1vtC2jnN5zwzGpol0TOvm94BlPB/UYpzKYbeSIBU843qdyFMicTnFtDfIc+
	8uIQLHOvw+LdRP5UX+066Ozp3CW6JRLeIZqdF4w0WABJdICHeTn/ekXHZpF3Q4XtDp8cpe
	pZx8iHKO32I6tJ2PWvAxmvmMkP/6Hv0=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G01Op3Me;
	spf=pass (imf18.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774964235; a=rsa-sha256;
	cv=fail;
	b=b0EVTN47EQnFWiXbZjUYk1VdKWu7cIk30o/y4YxJq96M/32a9Z0liE3TZUyqoZGiBtfsrO
	aAN9VLaOrLK2WKh0rSeR9LL2VMVXU27PHkpaJngUgTD7v2WieyYsVsAaxCNVdMLYrHWEcE
	tKuID39wqWYHbTGBPNt1queerHfhjjU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774964235; x=1806500235;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=z05ZHtk87tiE2IlzI8G09Nq25iFDWPZ4YRofEm8WgAA=;
  b=G01Op3Me8koVXS44pqoQGwAV+90VAryrP+9OsYyansJ5y+l7jHAu0Kib
   ddxUzwPYreyZTBLPZQ2B1cfEUL7QJtF0t6saOzlpvHPVN7JqLsu08vXDD
   KLY3EfDKelOyZC42pqryff9fDGe04BneSDHbk145q/RxzLK/LTypTSIru
   C8PVZlI6lGMSh4Km9TzEFY2xI5E7Vco3Ls7//3XLxYEbKkEbychQ95OGj
   mtHDtM2xuMN66zKhf63/kMZ3HATyg9xSG6wcn8qpBNzwrGhLFaAZHM7x4
   EyF4Qji/+gDEijvOVgIZviytaDJqA4Vx+KThmMZr7nnlHHUnhtQXnxpMh
   Q==;
X-CSE-ConnectionGUID: wclJaFXoSBmR/KKv0albLQ==
X-CSE-MsgGUID: iVsfbNhzTGC8JT0SQc+xag==
X-IronPort-AV: E=McAfee;i="6800,10657,11745"; a="63528561"
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="63528561"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 06:37:13 -0700
X-CSE-ConnectionGUID: D8Y8xYYHT8yhorlzTZSaBg==
X-CSE-MsgGUID: NiEJYfxoTOaBO6YNnLSVnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="221969115"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 06:37:13 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 06:37:12 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 31 Mar 2026 06:37:12 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.50) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 06:37:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=feWxhZ7RdmXztBGVEGShAZ+yFD8sjxDuHL8Z+uHq6Yd0jrn2RZ6IhwJVtHDl9ZKl/bcb564eAxO6ZFOctkfx+5hOemWale4okC7UU4t59DSX7/ORK+cFt6LRLlY2sblwORr1cIDdSZ2sFaxYtSO43DGIhjdM1rZLrnclGe6SlCTAminSVRVgdGIxyhuOak1bofHU72qZem3zg0edOSPyg3EXFlVOouLMxQfJpKunYM+KA857BA/QnsrF/W1Dz031zYZb56tLnl6tSWQvBpxv5NRlkyA3SQ4TQLQE4iTzqY7SEU8rH/hklbtFi0uJJDdDwZKepQc3H5GOX5wNIAOdlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Wup2agZZ61Z37W4JVnKSIj3OJeQzXwHSPWqR1OUN6w=;
 b=TZE0ghtK7YUeTURpprvruTLkgBLR9lFSaY6XlZLDgI68FI+a8uE/B/1vPhvljAGj+nrjiKNIc/9M7zdYRQDTdUU645yUeA4Hqk+bcewOe3u4bHH85irXYNvtCfwEX4ZyBzm1pgbV++Qkr/JqYYa1I0D5/TyWkuKg1NTjXiq+OEz0STYTOvBPoLkKqsG1s3k1TvRy8rgNqy/9hmJ2c/BqESFjfbPHJh9g9ok5wXIdf6sO4StuQSfJVFysIgilIy8gmXelTohRIGAanCvn/IEeH6D7qMxTUg2NygcaGH5JzbPez7z/b4wD9hLWXEmOpEG8YFRghCP6tATU62B9Eei4ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by PH8PR11MB9722.namprd11.prod.outlook.com (2603:10b6:510:3a5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 13:37:11 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9769.006; Tue, 31 Mar 2026
 13:37:10 +0000
Date: Tue, 31 Mar 2026 21:37:04 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
	<linux-modules@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu
	<petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen
	<samitolvanen@google.com>, Dmitry Antipov <dmantipov@yandex.ru>,
	<oliver.sang@intel.com>
Subject: Re: [RFC PATCH] modules: extend {kstrdup,kfree}_const() to handle
 per-module .rodata
Message-ID: <202603312130.f9ed8d89-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327132247.861984-1-dmantipov@yandex.ru>
X-ClientProxiedBy: TPYP295CA0019.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:a::14) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|PH8PR11MB9722:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fea70f2-3a81-4aa6-491d-08de8f2a9c42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: VD2vlJlCi6yCdbH0ThkESJeeA4lyy61Jd6iQhC/L+pyKeeTburcO7ioF4ue72bfu5Zc2895dzTpuyU72tXDmvoBLweYyFpjASSfmllu8hq0PcoT++AujZcaAPVwI/S8T8CCoBRezauYI7DXuvFcmmAkp8GRsCiSeULxiQWkQB+ARpLBLDO9VIEjSfz0JA59akzEvp2p4gzyVDDc2/1wIMNx+75Pun4+jfZnZeOaPJN1U1Tmx6Q60K3qzvLkvA7Vf2uPqKWW7yy/RIhmv9rdSq99m1z+TrexOflYNbf3z4k3+jUATFTZMjdS90w1oW88Gf6g/r4EmQWgJwMOzkcjJ2UYqly7C/sle0Pu9AX9DVswW5q8id6zvnzW0q1y/x39rjWw3ZO8M3/txrKhtwqUg3L9zfAU5MPS1M8Yqn8S3yzCPWRwa5V4m8pN7h2lPZ6EGSjYSjdRGQ9fLVUTNJehn9YQg6VnNGnARnEx7+9XMeIdw3hiCOjN87dcaDfls7Bgu9cjWoM2AxGIf8fKM9DNWiIOAv4Fx8gry3AJFrfnq8RN1YofaY3zpPgBj9gVuQq+3kNjdxUfMwevd+unUCqcLZlTe3GRBJwZmGb1HD69DyUeHNHcUJ6otryDb0pcNhVzReQwfLtNwpCvBz5ddaKfH86+bL4SzxoBQxML75nMY1QMubTkdnRtRpWzElsHnyhtpEA9gFA2yrhzIPNzMwOmj5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NxbccNslyUAi8mEwtYUTpLVp1vB1exIl+r5IqRr4irZ69G20kERYfGuDAQYT?=
 =?us-ascii?Q?quQk7HCx0urtUJAxQomd3OxeGDjgeeZ6dJsnvc4hBe0lZLAx4TEUyHo9t0bI?=
 =?us-ascii?Q?IvJILc8vUX7LBWdZQCBQ8SAGUJ/g9DXhlQf1O5xAnnL9ciWUY2D041C0BtQk?=
 =?us-ascii?Q?HTh+9BV7PLSWE5YJVMQigZvxZ06VrqC+VH8mEkO3mHY11fLLK3J3Z5Oi84Rm?=
 =?us-ascii?Q?1jCJJHAG0udzX7QeIM0r7FiAs+gC8Kk+fnJgSY0NXM6nJ07IZIhAFbSWzaun?=
 =?us-ascii?Q?HailvXKGrHEJkrj7v6CVTKg0xibX4dywzbq5r1+cFmLxwOd2fnUt9SqUiwqt?=
 =?us-ascii?Q?6CsDrhsKxlqqmloQsDArLpnTJjGEep77sY8f3o0GqNDCgA9fyr7En8iDgw6j?=
 =?us-ascii?Q?R0U0MxxAByWKKnf9TdcOh/9zI1raf+DrERny6I5QX/EShWFyqqa70zK7nCxE?=
 =?us-ascii?Q?+VqQZFseIny3ijHtefxI/lji0drF88JIBuSkYw9z4NK5OQwyvk718GWQMEx/?=
 =?us-ascii?Q?Pt4UwWC1zjryyr7We9kS23kerPhACVEwZUa7UpxdDxBMzh4Q7N9VVG/QZGKN?=
 =?us-ascii?Q?Vn+biuXbfkxAGBfjqxbZw6Bmjxm+r3nj4X8AJIuXxhzc6/ET7IiJJ0RbO1xp?=
 =?us-ascii?Q?0E6Fw8mRAUl30Qy+7kw0XDacKzt6GU0QigF7EI9PSq3eplQvLtWCxIqCU3oo?=
 =?us-ascii?Q?2hngKPxR+7nWwSCuXlBwlJsrLvbTa3m6aKFgYEpthg3eLJaCrbT+jKL/SCzt?=
 =?us-ascii?Q?AmVArOG5SM4I2M77qB2szpQhu+hQu9sKkrD3NqiKQwwmZbnsMq3AHnOToETz?=
 =?us-ascii?Q?SI91UDYUIHJLbqlHizkW2CacSj1iD0RTyYoNW8YPsxEYU/nbZkyZY54OJqoH?=
 =?us-ascii?Q?nZaoBSm7hjMaGnWe8ctBbGftMRv0F8dADGlFho9tTbYiiIWjWWJIvnBUYiEZ?=
 =?us-ascii?Q?y64y9rJwqxbww2F0025NDjhZj0D3UMGiLL+P3ujgN+LaNsSYJPtE7qhfzwRp?=
 =?us-ascii?Q?Qt2/QJX3N8tn3jWixgWINFWIZa3RiZ/vZpjzItISTNdChw6P5Hg3zREJDlLU?=
 =?us-ascii?Q?fkF9Vl8p7v1mLP+SHJ4TVuCGRsSEemN1fQnlgO8TNo8PpLoBoegPgyM2yTp7?=
 =?us-ascii?Q?9syRER3CEU0EAju09+XMFkqKM55oBoSPrbEGKrHNIuTTV1BAgZqrNZDztCLa?=
 =?us-ascii?Q?2w6Vvq+fAwUyBTYeob7lJso+U0ztXIq+wevKJKdlALh1b9eIoQEHHUf7CmZr?=
 =?us-ascii?Q?lJmxpJLgxes/ge7qK0X6icF8QIzc2BKtWmzItfvouIGjai1sDO1D61lS+EJm?=
 =?us-ascii?Q?rDLYQT6mOi5ADJPSSMAbbyzyQmHyZ/bV2fWI5JbdILwhIbNep7lCHyVeEzKs?=
 =?us-ascii?Q?1RWs49NKJ4Bz2FKdBpfKZiFBks+QzMeLQiCjBxbWUKugGzy8XNsnSFrZYrIs?=
 =?us-ascii?Q?pVmtmBHPxbY9iKcfZEfykPBf1BVS5SNGy7X+LgPQrIjPwz2GFJfs2elvSCtW?=
 =?us-ascii?Q?6oxdjV+dEdYCDROML/lrLf3+6gFsI/e6DjxXAC/w0Gj5T5etqvarBH8gYl8G?=
 =?us-ascii?Q?xijJGqY7Ig2AZ9pO5/tugQYypHDoCS2x3677AllwuEZw+RVd2MaoE4YmToB/?=
 =?us-ascii?Q?vFomOOvuUjZnsP3OgQOmspmZ8IS8gS/pF1tCf4v1norF9V5qpYp69OgIt61t?=
 =?us-ascii?Q?86U2UOqVbVr6reTpgCVzcEoni7mAcJ6nRTDyCfxDSUHC1bq3f4jW8+CasErC?=
 =?us-ascii?Q?Du6yKxniZw=3D=3D?=
X-Exchange-RoutingPolicyChecked: wViZ0YFSKdBJUQ7FMrnIRP/yWGouTGfWrLRQV4zhLfHO9xSMaD+46XMLoS4iux5EKu36dcM3hfX6HXq2UqZN+BKADvYKuGMPt/yYzQYYapy1WZz7w1vvOLJQbKzSobhkzkG8xghCjxARRYZrN3UAc6RlHV7yO4/9ez96cLjxaUDym8PYAt0Gd8XMn0zEhwk9muJiRfmTAilNBO2W3rcc08S3bGEmlQye3DjWjuhhA77IXb9+DehpEdXkIW4dvBgImxsIVNfwPS/8yzxubHO7Sl9mXbBzpn7BTIXdUfzbwa1X/fWOaBx0FvmozxkEZWKlrQO262UcvrksGuqQ1kLGgA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fea70f2-3a81-4aa6-491d-08de8f2a9c42
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 13:37:10.8588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Wd5kFn5bBOJ1IAR8oLWTD6wg/ogAd0blMEpH0SX1uknKhWw8PJtk5rWCObQ854bcOP0Dp9VTtln4koMdVHg5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB9722
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Stat-Signature: jsk4p37jzbwk477j375uzgmk6wx6rfcd
X-Rspamd-Queue-Id: 9B1051C000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1774964234-371660
X-HE-Meta: U2FsdGVkX1/jiAmn0uuI/BLBaclVGWOq53E8D2daXenMSuw7GmzEvpGi2pkU/hLi/fcZ/5vwgrLguOIHXAxu7Len2fGRWowOnCgbpKAe/zZ2hl+iQB6/aNFy6r37PvnD082L8jbwZKaBF9EP0HWhP9AW6UD8Lk8z5i4Dxc3TldOAbtu4ZKeV+qb8OU6XPzOzWxkMncXd9cOe5j0gLLW/cLUX6fmo2DBli+/9AkKp4nyyTtLVM143RW2L3Hugze2PFxcTCANXE+OihsEp15N9eWCvcgGNRkGSZ1shiKIwAqt52wShveMcA2oTS55adeWcrRWyTAk4svQHeVlq4y5CJ7UYgSwG/aGM8CHiiWAzItNGMG+969dHyBVlBLRQxo4PFXDCu3nVuaNNtchUiy1ByOnHP9/NZ36EMAA/xA15AOPfh+uvvJ63DiprMgLdQsfnwNu+tyriTtapTBvEOcTNCiIJyqy54O3tuWAHKJWzQszcMxoxxPoqcrZYeZfkRAcH8qGz2p1h9uWXx3ouZHe58EuHwcn41pLRvpwcbglVhK9QKtdfpSjknNjCg/YuVA2JssKDoUnbmWGwXwFTkqGFmKC5xYZ32vle+fTYy4pPA0CdcxqfpQXF+MJmRb7AaPndPt/i3A95w+P2jmp/yTFqxQrzwvVVxD48qkCYGsw0iXzA8JHrWCm8M5qR+zb9tXeJ/ioB90Cp/4YI/PsbyM2UP8ZL/8VeSvNFzCh3roszNbGvfjmO7GOc308JB1qvHeMUJyjgdaTOYaCfFcUvfo5a2HS2R93v0hTG5uu0RY+DzWgWWJRpvXp85OKZCEq1udPVaVW90IUvYVQIDDKt9IN9xFsH3bK6fYgLSkEIa1fthUXBgPcVvPQ9/hsaIw0mS0n3wlqxHZsiRsJkfqA9EKPrzVLsF0QwiDjoMkD0LTcDvNu6VZrvQEl5oLSVg2NDR3EMzs0L1oS0QTjKrvXA1kc
 Sul9VMAx
 0PFr5WoZgIn7Hp5Qf62esUBPLpLgb2tnkiZXzz36Mlts77au+KZUsN6OIFTDtxHIN8BJ5Bx+mXO41EBb7cd2fd4RiW1BecD6nWh61iUMY8u00Gik9sstvR3dPd4WbVgIdQzl3uiKqRItAw0fAOuPNYM7IaABUK5wWhd1li/SYPYKf+kQI0CFZpqUVhAgBYIr+eAohPZrQdEBTDoO1UeGHHUnldG99GKFE0OuwPPwOHJGa5Lbrl8MptmmT6hsqPTl7km0wvy1ceS4ItAKpokRszYDpWmasgL60SURFrMBKbWr3nbUwSdkWQBwntbo1O3d8FeEoIkPorV7yKyrOIwRBeaLRZYngj25pLLYP9pk2lVywoOJwqJqhyxdZYo2nElV+yGdiis1mLZLN5EEvHktjzKJ8hKzGLPbyT3dKb8HSo7SHO29xwgGUPYRwdTTvcuEjmDJGrJ4pe072IXgIqw7wmRZp6VrnKpzeyHF1xyFwuGIcMPYWk1Q8gJQJC+/RG98+UqkHvcUMx58cuoGi38Mm4jI3w47hzgrL2Peo9ufTJui2PBN0wSr+053RmF1hX2cVhHv3lxrRrSpG9n77tHEu85orniaoyclKrVbOAdEBPT1McU03HZFefcv+8xITz6uJcDj0NR9OWXe7GpYdohdkcfqRZVYSZP8gdiqG3H44IM9VivPSuNusJ48XGY6uK73WB4141ZSTa66EU2mP93oM1O/aEypBKvAdAFa9pIIxrWIXRxr5b4d5WEegeI5khyYDHmkrOUtDWuPNAxzheBZ/Oj7g8STdnH4vHEBe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "kernel_BUG_at_arch/x86/mm/physaddr.c" on:

commit: 0803ad97505a632fc3d0cddd6659617deb0ff34b ("[RFC PATCH] modules: extend {kstrdup,kfree}_const() to handle per-module .rodata")
url: https://github.com/intel-lab-lkp/linux/commits/Dmitry-Antipov/modules-extend-kstrdup-kfree-_const-to-handle-per-module-rodata/20260329-123400
base: https://git.kernel.org/cgit/linux/kernel/git/akpm/mm.git mm-everything
patch link: https://lore.kernel.org/all/20260327132247.861984-1-dmantipov@yandex.ru/
patch subject: [RFC PATCH] modules: extend {kstrdup,kfree}_const() to handle per-module .rodata

in testcase: boot

config: i386-randconfig-002-20260331
compiler: gcc-14
test machine: qemu-system-i386 -enable-kvm -cpu SandyBridge -smp 2 -m 4G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202603312130.f9ed8d89-lkp@intel.com



[   17.209008][    C0] ------------[ cut here ]------------
[   17.209572][    C0] kernel BUG at arch/x86/mm/physaddr.c:66!
[   17.210058][    C0] Oops: invalid opcode: 0000 [#1]
[   17.210470][    C0] CPU: 0 UID: 0 PID: 13 Comm: ksoftirqd/0 Not tainted 7.0.0-rc5-00667-g0803ad97505a #1 PREEMPT(full)  4fef6f10f7892f9689059524fd4d050b8163a9be
[   17.211614][    C0] EIP: __phys_addr (arch/x86/mm/physaddr.c:66 (discriminator 3))
[   17.211995][    C0] Code: e5 56 53 85 c0 78 09 0f 0b b8 ec a1 e6 81 eb 21 80 3d f8 e9 4d 82 00 89 c3 8d b0 00 00 00 80 74 15 e8 cf c5 19 00 84 c0 74 0c <0f> 0b b8 e0 a1 e6 81 e8 77 3e fb ff a1 30 14 d3 82 85 c0 74 2a 89
All code
========
   0:	e5 56                	in     $0x56,%eax
   2:	53                   	push   %rbx
   3:	85 c0                	test   %eax,%eax
   5:	78 09                	js     0x10
   7:	0f 0b                	ud2
   9:	b8 ec a1 e6 81       	mov    $0x81e6a1ec,%eax
   e:	eb 21                	jmp    0x31
  10:	80 3d f8 e9 4d 82 00 	cmpb   $0x0,-0x7db21608(%rip)        # 0xffffffff824dea0f
  17:	89 c3                	mov    %eax,%ebx
  19:	8d b0 00 00 00 80    	lea    -0x80000000(%rax),%esi
  1f:	74 15                	je     0x36
  21:	e8 cf c5 19 00       	call   0x19c5f5
  26:	84 c0                	test   %al,%al
  28:	74 0c                	je     0x36
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	b8 e0 a1 e6 81       	mov    $0x81e6a1e0,%eax
  31:	e8 77 3e fb ff       	call   0xfffffffffffb3ead
  36:	a1 30 14 d3 82 85 c0 	movabs 0x2a74c08582d31430,%eax
  3d:	74 2a 
  3f:	89                   	.byte 0x89

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	b8 e0 a1 e6 81       	mov    $0x81e6a1e0,%eax
   7:	e8 77 3e fb ff       	call   0xfffffffffffb3e83
   c:	a1 30 14 d3 82 85 c0 	movabs 0x2a74c08582d31430,%eax
  13:	74 2a 
  15:	89                   	.byte 0x89
[   17.214426][    C0] EAX: f7e9f401 EBX: f7e9f4ac ECX: fffff000 EDX: ff5fe000
[   17.215476][    C0] ESI: 77e9f4ac EDI: 00000000 EBP: 80b0be68 ESP: 80b0be60
[   17.216539][    C0] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 EFLAGS: 00010202
[   17.217741][    C0] CR0: 80050033 CR2: 7fbf9dd8 CR3: 032cd000 CR4: 000406b0
[   17.218849][    C0] Call Trace:
[   17.219371][    C0]  kfree (mm/slub.c:6474 (discriminator 1))
[   17.220011][    C0]  ? rcu_read_unlock (include/linux/rcupdate.h:884)
[   17.220786][    C0]  kfree_const (mm/util.c:49)
[   17.221549][    C0]  kernfs_free_rcu (fs/kernfs/dir.c:550)
[   17.222201][    C0]  ? lock_is_held (arch/x86/events/intel/core.c:4034)
[   17.222920][    C0]  rcu_do_batch+0x329/0x6a8
[   17.223812][    C0]  rcu_core (kernel/rcu/tree.c:2871)
[   17.224493][    C0]  rcu_core_si (kernel/rcu/tree.c:2887)
[   17.225255][    C0]  handle_softirqs (arch/x86/include/asm/atomic.h:23 include/linux/atomic/atomic-arch-fallback.h:457 include/linux/jump_label.h:262 include/trace/events/irq.h:142 kernel/softirq.c:623)
[   17.226002][    C0]  run_ksoftirqd (kernel/softirq.c:479 kernel/softirq.c:1064 kernel/softirq.c:1055)
[   17.226737][    C0]  smpboot_thread_fn (kernel/smpboot.c:160)
[   17.227510][    C0]  ? sort_range (kernel/smpboot.c:103)
[   17.228198][    C0]  kthread (kernel/kthread.c:438)
[   17.228839][    C0]  ? sort_range (kernel/smpboot.c:103)
[   17.229601][    C0]  ? kthread_affine_node (kernel/kthread.c:381)
[   17.230400][    C0]  ret_from_fork (arch/x86/kernel/process.c:164)
[   17.231112][    C0]  ? kthread_affine_node (kernel/kthread.c:381)
[   17.231971][    C0]  ret_from_fork_asm (arch/x86/entry/entry_32.S:737)
[   17.232755][    C0]  entry_INT80_32 (arch/x86/entry/entry_32.S:942)
[   17.233621][    C0] Modules linked in: usbtest(+) serio_raw evdev parport_pc parport qemu_fw_cfg button
[   17.235190][    C0] ---[ end trace 0000000000000000 ]---
[   17.236068][    C0] EIP: __phys_addr (arch/x86/mm/physaddr.c:66 (discriminator 3))
[   17.236831][    C0] Code: e5 56 53 85 c0 78 09 0f 0b b8 ec a1 e6 81 eb 21 80 3d f8 e9 4d 82 00 89 c3 8d b0 00 00 00 80 74 15 e8 cf c5 19 00 84 c0 74 0c <0f> 0b b8 e0 a1 e6 81 e8 77 3e fb ff a1 30 14 d3 82 85 c0 74 2a 89
All code
========
   0:	e5 56                	in     $0x56,%eax
   2:	53                   	push   %rbx
   3:	85 c0                	test   %eax,%eax
   5:	78 09                	js     0x10
   7:	0f 0b                	ud2
   9:	b8 ec a1 e6 81       	mov    $0x81e6a1ec,%eax
   e:	eb 21                	jmp    0x31
  10:	80 3d f8 e9 4d 82 00 	cmpb   $0x0,-0x7db21608(%rip)        # 0xffffffff824dea0f
  17:	89 c3                	mov    %eax,%ebx
  19:	8d b0 00 00 00 80    	lea    -0x80000000(%rax),%esi
  1f:	74 15                	je     0x36
  21:	e8 cf c5 19 00       	call   0x19c5f5
  26:	84 c0                	test   %al,%al
  28:	74 0c                	je     0x36
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	b8 e0 a1 e6 81       	mov    $0x81e6a1e0,%eax
  31:	e8 77 3e fb ff       	call   0xfffffffffffb3ead
  36:	a1 30 14 d3 82 85 c0 	movabs 0x2a74c08582d31430,%eax
  3d:	74 2a 
  3f:	89                   	.byte 0x89

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	b8 e0 a1 e6 81       	mov    $0x81e6a1e0,%eax
   7:	e8 77 3e fb ff       	call   0xfffffffffffb3e83
   c:	a1 30 14 d3 82 85 c0 	movabs 0x2a74c08582d31430,%eax
  13:	74 2a 
  15:	89                   	.byte 0x89


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260331/202603312130.f9ed8d89-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


