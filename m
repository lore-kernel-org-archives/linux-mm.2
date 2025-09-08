Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9399FCA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 20:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED1D38E0007; Mon,  8 Sep 2025 16:01:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B3C8E0001; Mon,  8 Sep 2025 16:01:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC488E0007; Mon,  8 Sep 2025 16:01:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7E6C8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:01:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8228B1A02AD
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:01:27 +0000 (UTC)
X-FDA: 83867152614.02.3A27BE5
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf22.hostedemail.com (Postfix) with ESMTP id E2CCAC0015
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:01:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hT7wU9QY;
	spf=pass (imf22.hostedemail.com: domain of tony.luck@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=tony.luck@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757361684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SGjKslgxrQZ3QxpMaWr8DVzdemcT854ww0FyF610ZoU=;
	b=khQPKTUcSyNbhxx6TkrpCQNYIh6YeAbLlP/gZYx3GHPPCUHB3LSObACZ2l5B8B0071znOh
	o8QqOm2IoNbud7vEDxy2Hj1E2bUrMzeGehyNeQ5RDMr6wAiknlNYHLu6W/x3VWKi7AN4xh
	Oo93SPmvG4JnLtwtDraL8a8XxNCH3Yw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hT7wU9QY;
	spf=pass (imf22.hostedemail.com: domain of tony.luck@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=tony.luck@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757361684; a=rsa-sha256;
	cv=fail;
	b=wTprSUFM0SBctTDReCpTbjz3eZhizAcOUqLZSzgK6PKhM0Q89JS5Lf5qmXF8t/GbJVOHME
	+nlFBFChwCpzNSVFoNRYqpQZ3ISFkFza3xc7G983U1+SET+1vJKm6xOeC/i0aMgKcgfSWg
	HduzlWBFzr6LV1wFlh1cIiQYaF4V0wo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757361684; x=1788897684;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=G0yGY5l+SRgXeU8SJ6byZFQwvl2jmA2rlMhpaMyDNYc=;
  b=hT7wU9QY/B++gtUJvkbwIz8pR/JzGWsMWGDBV9YOOoa30ngm3HvzuMLe
   42ASRfmFtXFp8skiFac2MqU5ZUGmWW8ufI3wae43bEUg0U+bpp8xThIPM
   OWefpHd1QeTXexxH6uisrbA16m3sDTTEDfNdVXsjVIllU1PQZEYsWxqP6
   cRnTbKlTkOYovC7sa0KrU5AT+D9I9ZEcylDPQOco1rVHXa+yKt41C3lN2
   HZqR17Sp7QNuZM0buPPe2R9cMfmebAsd2r2Sqw+OhIEAsdeseWuhWzffi
   pFaDk5Xjb+4IIngMGC3kwFzGiB/V1zEgvxa0UkdoRWoYHSAZdpyjgbChg
   A==;
X-CSE-ConnectionGUID: 5317ynCFRSGqjpd1WQct5A==
X-CSE-MsgGUID: KCk4T2z4SqycZ8PmBARsbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="58673978"
X-IronPort-AV: E=Sophos;i="6.18,249,1751266800"; 
   d="scan'208";a="58673978"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 13:01:22 -0700
X-CSE-ConnectionGUID: WParP5dJQp++/8301TQ+pQ==
X-CSE-MsgGUID: ixND+f/vTvGxMXpdJz4mCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,249,1751266800"; 
   d="scan'208";a="172463891"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 13:01:22 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 8 Sep 2025 13:01:21 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 8 Sep 2025 13:01:20 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.76)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 8 Sep 2025 13:01:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fm5S8nT7Po/Lik18PoGtSgqLiJFai9N1Sq5gO8/LXCabhYBzQj981n7F4fj3pL/YNZbIAe3t1c7o1jSJakgupchNdGXn74KDLw5MY+IziurkWkeomwsE8fWU6JY/+pJ0rjv8jYkhrnCPmG4KyZluQpouL6k3ao0yyy2YA2LQhju8AvGgs+FvH5Upr449P9Alv4N7xdj3Qs7Do7w4Ly1GLATJL+7fC4XJvCJImnf/vsICmwPO+O6TBBCsJ92JyaWrfpgrWhf6kYhoSzEwhHJgNCvTEKmlkMl0v0oFeNVXpwQamYw6ooVKh0B4WSxeTorfGuBHqOtOdGmyoF/B71RqBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SGjKslgxrQZ3QxpMaWr8DVzdemcT854ww0FyF610ZoU=;
 b=XRTj/EnBxrMd0Ew46NqyGpfrMJcurYR6qVNblmbWQiyxk4GTDMJiG8JslaV1fTC5DgjvK0hl6Qex6mOi2TRvuebWgzo+KooVsBgZ3bKGWbKX7fLPMfQP3b26nHMS7H+whlHg3fGdhpyk5pt/1SUoUD8HRql0u+CKIDpGtHnwhSumQHyyrQlqIAqLB7dNs2sT1RUIell32/LSQrs9aawTkIwJBt3C+TVQlr/LtejEUle6eTROOmr2L0FhWVXDn0/sqUMZs3c7UAyPIPZw0nyjQREGUGqtTdUpKTC3W/vPNEnuEzWXrP0h5QnbCm7s35yw5SxEmseaUSFlm9NlixwiSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by LV3PR11MB8484.namprd11.prod.outlook.com (2603:10b6:408:1b4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 20:01:12 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 20:01:11 +0000
Date: Mon, 8 Sep 2025 13:01:10 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Kyle Meyer <kyle.meyer@hpe.com>
CC: Jiaqi Yan <jiaqiyan@google.com>, <jane.chu@oracle.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	<surenb@google.com>, "Anderson, Russ" <russ.anderson@hpe.com>,
	<rppt@kernel.org>, <osalvador@suse.de>, <nao.horiguchi@gmail.com>,
	<mhocko@suse.com>, <lorenzo.stoakes@oracle.com>, <linmiaohe@huawei.com>,
	<david@redhat.com>, <bp@alien8.de>, <akpm@linux-foundation.org>,
	<linux-mm@kvack.org>, <vbabka@suse.cz>, <linux-acpi@vger.kernel.org>, "Shawn
 Fan" <shawn.fan@intel.com>
Subject: Re: PATCH v3 ACPI: APEI: GHES: Don't offline huge pages just because
 BIOS asked
Message-ID: <aL82BsIJht3HIIS3@agluck-desk3>
References: <20250904155720.22149-1-tony.luck@intel.com>
 <brfqzhbipg35twgv22vnnotbv3t3grwh2dxugvtbgqduuhsvst@f7exibz7i7tk>
 <aLsHh70jI6BGHjaN@agluck-desk3>
 <bwu744g3qzbzylxvfgt7v4tnf2k2eosqbkg7alm6u5roa7j3bn@gmut2l5227kw>
 <aLspJ5Tpqp4qRDk2@agluck-desk3>
 <cf05bc8e-fc79-49e4-a90a-47e661b4ae69@oracle.com>
 <CACw3F538k+dshTs1_rxbpYoRdFyX3tLYzfaWj-_d7Lq5Dd2Jsg@mail.gmail.com>
 <aL8rIgSImDh7Nj7E@hpe.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aL8rIgSImDh7Nj7E@hpe.com>
X-ClientProxiedBy: SJ0PR13CA0043.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::18) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|LV3PR11MB8484:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bf9d322-51f8-4c6b-e2bf-08ddef127573
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?C5+gqivvB2gyBccC0te3EGF302SG9xOv68QuFCsnnh607tWKAj1dFFxI/1Fv?=
 =?us-ascii?Q?CrKuwCdT8TALfWhdf/hc92TsyXL53q3noRCVG26PrGhYbEpOLm2+1h1hu8yY?=
 =?us-ascii?Q?JQis9ZHktwN4h3+bd/25S/kgHfnyGw+ZN53I708aK0IUbU6J4jIxVr8IDWMa?=
 =?us-ascii?Q?wRT7fxdjx9HWttG7bALxOC557CCK/ihTZZPCjaLkI9zW2US2qGKMiLn66NRI?=
 =?us-ascii?Q?Ws0pXasJ7QmV1x2wUQHDjN5R3rikCbGayIIeqD/Ggx6wxKbBxAHS5mGPnPHL?=
 =?us-ascii?Q?rVFUqgAGDFvpkTSOKHcd7qw3wafWPhfe9wm6FmUcPBN6V8IpJgAUAWq3gzaJ?=
 =?us-ascii?Q?B0OLEqn6ZpiPxmV41VTd2eXYWMmXtDFgdIvwGxqjz8pNKM1lIoS5O5yHHJy/?=
 =?us-ascii?Q?W37HpbRAYtvMTYvRDHFSZ/9dcpu3e1diR8NSLV+emg0liloxbTlTre71ei3P?=
 =?us-ascii?Q?V5oWhXpoPwSFhI5av+0IMZLLL+KtUb/bcRu534lDJhQHV/UQ/D7rfMcK4+Cs?=
 =?us-ascii?Q?G+Mrs65hyycIHJjZAQ6OXJZHQsEd8uz0IcGkxNORC2i4SuQfn1SjfPIiMQih?=
 =?us-ascii?Q?wOfUSDZuFH0XS5x7pJw4EnKlit1GOiVvzue+EymCTf1YmLOAJHcDDmiqAlbI?=
 =?us-ascii?Q?ybGqivgHtWmkLPbgqbCvaiGXgM5M16+o6umojQ5iWrC86WhDuBS0d5usLzCa?=
 =?us-ascii?Q?m2QRItyjxksSuGSGUoO7p4lv1a4yRLztMoMbNLYMBEPaV2mGsU13hbJMwEFc?=
 =?us-ascii?Q?u52u298a8WIysclsD2gUczTqTujSTp+pvpDcOmRzUfJYvmGG8iEKlkOyR51X?=
 =?us-ascii?Q?s5/fDPQ2FYjsppPg16uY1ZFgty+hd9BO2AibL/f6hUTvmDGWrHm0Tpw4qJOK?=
 =?us-ascii?Q?+WP4BLxjwu5LgKM5hbQX3eDr0SkoAW2gJMk8ICMnukZFpmyZ5KiwkX2tZdpD?=
 =?us-ascii?Q?R6gXdtLe1vwwaEJ8w8Xm8pWyLoQqPiUkdql5T1UGBUJsq24C9/Vwo/vK60EF?=
 =?us-ascii?Q?82zryQsrda++InK+wbN2zpXhXN6QFO00xk/0GdEesvuuKXw+PU1eEsWE1c3p?=
 =?us-ascii?Q?A8vPIIH+OTQV6gK2Nr/iEekR6IupCgb076AYvDm6oE09T2MfDAPa+Gsoak9R?=
 =?us-ascii?Q?ZJOhAPhzMw9vFr+cZsUpi54EMNlVQymti1gvznVjYu8R2C0nn3ffmxMsUaT6?=
 =?us-ascii?Q?czPTkypvPrOecBZgVHsNalz68Y1Gc+Yy+zp/MSqq+LLjBA3GP418m6C9Wpcn?=
 =?us-ascii?Q?Qry7XleI0ViptipTDNdOfve86rRXtDcWEwc2zOOb6IvEz8FixuCezEBYtvkX?=
 =?us-ascii?Q?wzISKIrMgxEAVp8MdYaPTvW3MioYmrlxms8QqHpHim6t046VjwQScnY6PK3w?=
 =?us-ascii?Q?TKziuiJxaPFQl0CdnZWutdnf94G515Wb2ZKBYzD58pubGi94AbIliDknOXg/?=
 =?us-ascii?Q?Q48qee68/7o=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?49qXM7njywUKPUqnAxfwlYRi4my1A/8RuKTzgOAMeevoHhC4ZIw5ytvj6FlE?=
 =?us-ascii?Q?irRMjE6vdwwSlN0bKBtdR9qoMoxA1nSxaAYxqn0EMa4wXFHRsIvNDoj4+KrX?=
 =?us-ascii?Q?wkaBcZybaS+j7fWiQWbhrNfemRFm31NxdQDtF8SQaJdLGrzMAqaCURuxkhZD?=
 =?us-ascii?Q?0UmPTIthNyAE0YpJCN3jwsPydgI4yfSORIIMgIrAJZL8HkMsF3DqiWdHF5mo?=
 =?us-ascii?Q?696+czekpJ/GrbK/AL0u0t2qotYORv8iZCDJ8Jegub9deSvo0gP2/1p2CBd0?=
 =?us-ascii?Q?dErpdSQFkOffmC1d0dD5a2tnfjjvR/3SqkZ3nNt5wxNg3eqsMpvQbZzmv/Dg?=
 =?us-ascii?Q?J8g2Q7xndTghosY86QCqM54UPJdhKIAJ9f5feqMAwWkO4z8mQCQ+F/wMGi4S?=
 =?us-ascii?Q?7N8dgDzQtB8hxSGDNJeH6cFJcCmODsEBd5HA7+f3Qt8EToKM9Vv4FW1wBztM?=
 =?us-ascii?Q?Jsq3ijYh73ZVhU9ALX7HW2R9ddcobTy5UaDmboFtYIj0sLF9QPVYyRDoW0sN?=
 =?us-ascii?Q?GGbIusHpSXH+5ZHn7oapfJe8TtjdFEMk+UJ/a6jBV6udMTJ20/YcBdZTXXvo?=
 =?us-ascii?Q?q48jU6JTQrMtQ/IUsayU3KgyRTscBw2kfoiMrC4ljuLtDBc/5BeGPihPAQIx?=
 =?us-ascii?Q?ZZPxkOC+qJxQU8+XIEWDzkr22VBjSWow2h9Aa3/ADWslGZ3pNlLMG7wRlfVb?=
 =?us-ascii?Q?u/7dW/IzfnWZVYbHOMxmkNoUQnpwFFQPl9KZPiEbO6e60EyzJgGlOfJTDpPL?=
 =?us-ascii?Q?s0Nk6SeBX3j3UfDmrUSD2aC/DVPWIpnCK8DuyDFCSwbC3++oCoXhnIThwSg/?=
 =?us-ascii?Q?JjfYbYE25FE9wAFAcf+FHnsio1nxii8iEx64XfcY3n9RsE+o3vwFAnrh1Fnv?=
 =?us-ascii?Q?SiU2udEju4F1K/2Gd6w2l883WITyU1OfSKkRLZly2cml5jfcPgBva9KcUavh?=
 =?us-ascii?Q?EREGPOskTcm889qoSvUY1QR4WA4h8tPft7+2sNz7SYlWF7VMy+xz9S84XfuQ?=
 =?us-ascii?Q?Leeoi8hw4sekozacQqjUCQpQL3TTjfnBS0EsL7dEX+ykwWKIkRWTkQ9D8KwN?=
 =?us-ascii?Q?3sbXi0YKpDcsUzc5Hs3evpRfARBAakEaAdONNHoLbRDbfqn51CjdLtw/SmkR?=
 =?us-ascii?Q?ZK14ts7xXTN6tvyJsulhltHGQ7gR9Xeb+Ap+OlsoGFck+yF+y5FOYrPseT7M?=
 =?us-ascii?Q?1vSdNEhZn4gbHtLE0TxX01/5wtVWbkDi3FDbxdNKOpaBjmmpnlu54UcLsDSN?=
 =?us-ascii?Q?JSFMyD0CwTifgydEgZbvNK+gZzuPdRKGFjtl3hEdKqQpYlTAJI8ctmsjYkBl?=
 =?us-ascii?Q?9C1iPD9WpNtV+wJudVc0YiPZtIUfjhFUlCERle6ZpPaJcNnDNGICIO1mHPTS?=
 =?us-ascii?Q?KELmMmV8OuTZhNdixqzvUyOBA+p3QdZNI+9QZ96xFbWdyku9kgNOMvBF1FUF?=
 =?us-ascii?Q?NacYWFUGz9/1D1+n8K4OPUXfCAQ6ZgQ6mEi6j5fbKJb+alsXoYsPDaVs6jmu?=
 =?us-ascii?Q?HVShKwitVSttCUmjvwASQUMdQhdJJn1dmM58eyGEvv/XE4rkuyG9gA+TPceQ?=
 =?us-ascii?Q?yuAZJT1Ifj2fpHaITHPbtR7MRQd8No1sKvyaMa1E?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bf9d322-51f8-4c6b-e2bf-08ddef127573
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 20:01:11.7879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DzqbC0joiAsnYhfUsuvqPLDxv2LAbNPSKlUUApV7pedXBZXLPqk9fOSai4G7vmMbXQ8uMFuoghiD9P8skuD0QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8484
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: E2CCAC0015
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 899z588ydi7rwkiakzotcbshkrc9yugx
X-HE-Tag: 1757361683-150381
X-HE-Meta: U2FsdGVkX1+s5YeBEZLn8IZKDFEc3e2lYs48rM1uZXWMrSadEHPCTowYrJfDILzBtGNOvBYzl2SSwo4+tnGD2crLEO6/n7pZ+NemsVt41VVpxAvg/xnxTyiekfwZSpz63pjhAybeDhKO/11HTUogjozQuYcLbhC01GwhPw8zdhDYbsYw8z98Qb9EGaNwfdSpvHRORB68Ek0gS9gO2iB4frp/78014ceZxXdODsDmHB6G5QGHfM1DmJj6Wli3+RqZ4hZsb/2dQrvwLlwBNSp2334qWhDjrD1TfFTFfzD4qgucZNzYekPLaVYHMDo8lqypClPDxNHslj13kDIFt5lWZZfo+cBJ7fwbt+PrlOy9wkZ3jiv7fEulCfgltROAE8GKBMfBOd33fzC1ySZLDe1EQNGOzs5p4gMtOA3bpR9Lg63RrlYe51ujKAxiqU8FYfkz/pXjoSXXx78D+oBoWDBa0LkWzSYX/1Vfl8p8sbJ9YzMvrl8SQoYEMpZkl9mdO12t6eW5j8eC0D7KUdCOpmS6EJxX4HvG9XH5DG3g/I8YpkfaW9vniLd0Ur4XniSA2qaMMBRMGMWbymNgC3G6ivVP6ZvHwcp29j0E0YyAivja3Vpn5DhB2Vk6/LCIu3M4mK4gJCwh7zb5+Ue8bpAYN1kx2uwFn1PNi4vri8xDGGHyUiJqTkmBGc8pGzquMILeSSBHrlRpm3s+y4lWk1DnFZY4aQgt47UE3LNZJKdyAsggSXHzMGtjw4YMOmEfZyo3PXO76xd1qZdg+ovgtgguNMOJ0KLzOrClmx1Xi8DK8pzaFZlm2Jyyr53xRqPhkFhiHtAss23KQupQZh0uOYfcVvzduPEot5AaOZjzBLn7Y9KQoKGW79ExO0XXsBNVGkk6BDx0IISFsAuWxpxdlm3y2HR0Yz/Q5CTlZw61L0kOGYX8teiavI0ojHUcIgecK9WxD5644T2gMnDHHlUOcCbXWKJ
 ykzSX+5Q
 i8Y78Za1H6OOjj00L9Ys2NlcxA70DctkLUUCK8TI6kn0BUgcgOr1PNxVDfTDcvOr/BPU0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 02:14:42PM -0500, Kyle Meyer wrote:
> Optionally, a 3rd setting could be added to /proc/sys/vm/enable_soft_offline:
> 
> 0: Soft offline is disabled.
> 1: Soft offline is enabled for normal pages (skip hugepages).
> 2: Soft offline is enabled for normal pages and hugepages.

Seems like a solid plan.

Needs an update to Documentation/admin-guide/sysctl/vm.rst
to match the new functionality and describe the reason that
users might want to avoid taking huge pages offline.

Also this line in existing text:

- On ARM, the request to soft offline pages from GHES driver.

should read:

- On ARM and X86, the request to soft offline pages from GHES driver.

> 
> Maybe something like...
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index fc30ca4804bf..efa535d405a8 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -64,11 +64,17 @@
>  #include "internal.h"
>  #include "ras/ras_event.h"
>  
> +enum soft_offline {
> +	SOFT_OFFLINE_DISABLED = 0,
> +	SOFT_OFFLINE_ENABLED_SKIP_HUGEPAGES,
> +	SOFT_OFFLINE_ENABLED
> +};
> +
>  static int sysctl_memory_failure_early_kill __read_mostly;
>  
>  static int sysctl_memory_failure_recovery __read_mostly = 1;
> -static int sysctl_enable_soft_offline __read_mostly = 1;
> +static int sysctl_enable_soft_offline __read_mostly = SOFT_OFFLINE_SKIP_HUGEPAGES;

This is changing the default behavior (which allowed offline
of huge pages). I'm in favor of the change. But you should call it
out explicitly in the commit message when you write up a patch.

>  
>  atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
>  
> @@ -150,7 +156,7 @@ static const struct ctl_table memory_failure_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec_minmax,
>  		.extra1		= SYSCTL_ZERO,
> -		.extra2		= SYSCTL_ONE,
> +		.extra2		= SYSCTL_TWO,
>  	}
>  };
>  
> @@ -2799,12 +2805,20 @@ int soft_offline_page(unsigned long pfn, int flags)
>  		return -EIO;
>  	}
>  
> -	if (!sysctl_enable_soft_offline) {
> -		pr_info_once("disabled by /proc/sys/vm/enable_soft_offline\n");
> +	if (sysctl_enable_soft_offline == SOFT_OFFLINE_DISABLED) {
> +		pr_info("disabled by /proc/sys/vm/enable_soft_offline\n");
>  		put_ref_page(pfn, flags);
>  		return -EOPNOTSUPP;
>  	}
>  
> +	if (sysctl_enable_soft_offline == SOFT_OFFLINE_ENABLED_SKIP_HUGEPAGES) {
> +		if (folio_test_hugetlb(pfn_folio(pfn))) {
> +			pr_info("disabled by /proc/sys/vm/enable_soft_offline\n");
> +			put_ref_page(pfn, flags);
> +			return -EOPNOTSUPP;
> +		}
> +	}
> +
>  	mutex_lock(&mf_mutex);
>  
>  	if (PageHWPoison(page)) {
> 
> > > I don't know, the patch itself is fine, it's the issue that it has
> > > exposed that is more concerning.
> 
> Thanks,
> Kyle Meyer

-Tony

