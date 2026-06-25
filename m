Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C819CDE005
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 01:51:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AC276B0096; Wed, 24 Jun 2026 21:51:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45D276B009B; Wed, 24 Jun 2026 21:51:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34BD06B009D; Wed, 24 Jun 2026 21:51:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE1E96B0096
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:51:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6FC0C167547
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:51:24 +0000 (UTC)
X-FDA: 84916757688.18.2B41E3F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf31.hostedemail.com (Postfix) with ESMTP id 41D4D2000A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:51:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="dFlfRoD/";
	spf=pass (imf31.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1782352281;
	b=C8krmGvGhHVDVW1Kytu14I4U7bsSpqG3j93/2VfXLP2kV3ktV55pJSNJ6he0k2AywaEmZ1
	hNzTxdASAB4S7q8htKcomRw6MJCARtpU3FTYUUoPAw3IsA/oMTyKhibClXDvLxLJTlY2cA
	+LhQzevQAYZEEy/QQQmL22pwnimEBSU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782352281;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gpqZ7AB4PddwUfgiSvXzYuwNvPjiNpm1Ysu2T/OYD2c=;
	b=4tmeaMNjf66AUzzHd+jqGNwlrGICCCeW6AmHpY4MySrafmAx7i5h/UL4oiYf5TeVfVRdPD
	5T4iHVlSbUte92dsSnTZZnCKOUH7F1WJl0T4NCTzEwPSu/b2A+9W3Fuwn/zPs6lzqDyvDF
	D1Kh/ZVyHrVh4pZ7CfVNLaHLwPuw9Ew=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="dFlfRoD/";
	spf=pass (imf31.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782352280; x=1813888280;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=C6XVTJIElHpX+QIGCrdJpKCuNojy/oGKyvEu/s4PFVU=;
  b=dFlfRoD/gWipGf6KBCNMgi8i47vCnuuGNQOnwvwcdAJhLEPeuP+u+lx5
   w/pEfxKrHdCbrqAEt1FLLJMp77Bv7FCBxlWonfSSgiEbVpF5JhVbVCPcY
   C9rfnSIRa348uiZOss/2lsfvefcTtXPwhKUxRGlW8PF0BKpko175h88yp
   J+VYTakQi7tRUVHvslrLTBy+S4SUP+i5KlaU3uApcDDiuPhgRmsathWh0
   2CDZf+tDF9B8BLz1D8a+0HeIxzG+RN8ddcUeBb8/ATK7kE2lkpJWw8Jwk
   9vEY5gxMe18eVxte44yw5wFTCE+S6Z08cGusneE7VOjL17eucEdZQ/ivV
   A==;
X-CSE-ConnectionGUID: WDebJghbTCS3pJ4c0jwpmA==
X-CSE-MsgGUID: GX/ZeOB3Suefvwv6KJyi0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11827"; a="93725086"
X-IronPort-AV: E=Sophos;i="6.24,223,1774335600"; 
   d="scan'208";a="93725086"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 18:51:19 -0700
X-CSE-ConnectionGUID: xb94SW6qRfKVT6UkgtGKGg==
X-CSE-MsgGUID: vyio9+qGQJqjF0Wl36Jifg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,223,1774335600"; 
   d="scan'208";a="255034145"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 18:51:18 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 24 Jun 2026 18:51:17 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 24 Jun 2026 18:51:17 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.8) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 24 Jun 2026 18:51:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uHkAioOCye0cirRm05e2c+IvyIhRMauMWbz8kQmZDq8GkyJy1H2aanz1cgkMQ01vVwOVb4wc+X1nyf78ZCG4cbip6prraIBa0TQuLRkHa5ztbPCQ6YzAPZ3lLhXpVK0uCEvNsqn1JeNZWF9eYLxPb903H0CVGB9d2gTmxxssuIepKdTa6L2pY0fksZU3VAFgq0aT0TLfW1zqv7NVXKDhwRTJ/BxqyAty95wYelMvFN7XVWU0ZeS69guRRAoOqaST8r3SZc8a0mDRQN2F1ALzkjGeZt11jNGlPidsRu/SY5rsfP6w5ugYXO++UI66EqIbZHDRh+KcihAr+WR532OYFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gpqZ7AB4PddwUfgiSvXzYuwNvPjiNpm1Ysu2T/OYD2c=;
 b=vZ3ewn1VB8YTmUulGeMU3O1lkeyAb1OkKx1DfotgDxHc3un+CojbTJ7AlI/IXPjAGUtQlbjtmoieqMKJiwfUvOvw4m4o3ZhNiO2idIDdmRFFqa9x4ZbzWn+8HGnWpqbNl2CoCX+wOXHFu+4/yn1T25VfMfjIUkLcdV2M3F4Z6Uz3C68N+aMlfD5xZyVEs8c/fcLkPPQP1FzdsFTCDt8jynGw1dANxilPwBiTAv4g/3ZA9/2Wyw/rBD8c5oV+4VwV+YvtDsuk1MjMkBDx2QkLd+44XapE43nhqcwjklLTCD9/E1sIzjr/YG0faKK5hdm2J5VNZDrFA7G6RvNPyxt/ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN7PR11MB7468.namprd11.prod.outlook.com (2603:10b6:806:329::21)
 by DM4PR11MB5293.namprd11.prod.outlook.com (2603:10b6:5:390::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.13; Thu, 25 Jun
 2026 01:51:14 +0000
Received: from SN7PR11MB7468.namprd11.prod.outlook.com
 ([fe80::c17a:b7fa:6361:dbee]) by SN7PR11MB7468.namprd11.prod.outlook.com
 ([fe80::c17a:b7fa:6361:dbee%7]) with mapi id 15.21.0139.018; Thu, 25 Jun 2026
 01:51:14 +0000
Date: Thu, 25 Jun 2026 09:51:01 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Ackerley Tng <ackerleytng@google.com>, <aik@amd.com>,
	<andrew.jones@linux.dev>, <binbin.wu@linux.intel.com>, <brauner@kernel.org>,
	<chao.p.peng@linux.intel.com>, <david@kernel.org>, <jmattson@google.com>,
	<jthoughton@google.com>, <michael.roth@amd.com>, <oupton@kernel.org>,
	<pankaj.gupta@amd.com>, <qperret@google.com>, <rick.p.edgecombe@intel.com>,
	<rientjes@google.com>, <shivankg@amd.com>, <steven.price@arm.com>,
	<tabba@google.com>, <willy@infradead.org>, <wyihan@google.com>,
	<forkloop@google.com>, <pratyush@kernel.org>, <suzuki.poulose@arm.com>,
	<aneesh.kumar@kernel.org>, <liam@infradead.org>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
	<mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, Axel Rasmussen
	<axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
	<weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, Qi Zheng
	<qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau
	<kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe
	<jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-coco@lists.linux.dev>
Subject: Re: [PATCH v8 24/46] KVM: guest_memfd: Make in-place conversion the
 default
Message-ID: <ajyJhZcgfYFtGfS2@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-24-9d2959357853@google.com>
 <aji/2svhcc84rn5w@yzhao56-desk.sh.intel.com>
 <CAEvNRgHYTFnHbsLLgMTCSitmnp1_j9Pomikm9qmpGTh1w8YE5Q@mail.gmail.com>
 <ajx5Vrz9ma--hrGH@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ajx5Vrz9ma--hrGH@google.com>
X-ClientProxiedBy: KUZPR01CA0025.apcprd01.prod.exchangelabs.com
 (2603:1096:d10:26::6) To DS0PR11MB7457.namprd11.prod.outlook.com
 (2603:10b6:8:140::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7468:EE_|DM4PR11MB5293:EE_
X-MS-Office365-Filtering-Correlation-Id: 691001c7-a1dc-48fb-ff1c-08ded25c3cbc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 3P/8TwxqHtqh/YIyX3wbjw4VAp7tPQn+GPWGyn6jlbJnVFqKsDQ+4v9Z1f6OcPcKiTWjOk5ntnfZ1vcheEXT1kX122oaPdbwVyCqCVP10KrwZSNKXwfNgFkzPKplnsNjPN2ib+KkdjtMZHLey5MbyX9uDbuVluMpnOzmkS4DmUOYXjUQbXUNuDh/+ZzhSdNu3Daxu7TLrhPiE87Paovrwwix3J+40Ijj+zEqAtHIqZNVeWwnJm6LKVWUezNZOsZekF3jXMT11HAAD1bPdFlQ/qPVP4SHloKx1lDFuCtUsWKZUeR4U0pISNgGdje9QPo8LUikkoFa0oXXugMCW5Q0BRd75V0vZzI5xXOFnUsyUqQka3LOZO5SDtaY6j2x36uxXl5bI8/AHWwdr/UW7SdYTNEuVWMUeW50z+C1UrdDGl3Sy0fil29dTDwinXb8W5y1/WFAQ4T+UsOh1anMZ3YoiULQSWbyUmJiPTQtrc0Uo6gEvvWHv5zatWB9uMXHiqVmoIKW9+TNBYDLfG5E9bT/ZhoWrsYmtp1BDI4d3Cw4LTHZL1gBod9TdM1hqDBKDYkqEFhYTXTCUoi9wpdvydArG7mItA6jEmkawYUBByGdXa/ys4N4GP2GdqOYvV8pjSGWlGZscc5327MwnnL+VY+mkD5UYd1tGCWbfL9iMI/axFY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7468.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pb4uAPpBfkDox81EsdlqZ/HaWIxTJBisWdg50pqqr3i8qa1fbmDUVrw3C/+h?=
 =?us-ascii?Q?NTvRsEVnaN/RXupCZOx11+3JElw6gzlfK9qeVuZGBTZuzOf9AZnXFCmPs+Bq?=
 =?us-ascii?Q?4a+Q5E35b1rs89APj4wpEbpF/96R0BaLHCAHlf3/ZNA+uswZ0X02Hx4HOBg4?=
 =?us-ascii?Q?Ow+BK++X/nO/CS9cPW5ZTxj+bCYXttdQNkrK0ErEscF3i1GlaVz+vYGjAxaA?=
 =?us-ascii?Q?cPlvhtoMf7O43SxxqjkwR+wNPNmCe0q+D7rQyFqak5BDc0BiPGarLIdw2yHv?=
 =?us-ascii?Q?nAVvvmT5rTvVL53sNFacANQ1IOUJt5aR0phTW4Rprznz8qUC6AuSSd5hrcfN?=
 =?us-ascii?Q?hMxFQHtevyA8mmdjY/sCUphpAfV9yZfpkzgWOR+da2sUcOsoU9yd13iJv4l3?=
 =?us-ascii?Q?tk9RdbqDArWJJ3E29oUzWN8lFVml/cNIcy24sMpytEbxV0hmhd/2UfJ8EG7Z?=
 =?us-ascii?Q?v4NCQyINfQYmfe/qht3HfVUkcbM9ZjA2dMdMT6dSv8Cx9FQlCWFUT5P0IXoT?=
 =?us-ascii?Q?Du455NB20heD6b37xUV9i9+1PkfjXZBcfbDyRpHyuGSWC2O+m5Y5iyvaazI9?=
 =?us-ascii?Q?7xirikYsOA12JMDTBOz8AKdfeMA/MGTY0EgzXGbyLdOtRJ8psQtfPdOWirhW?=
 =?us-ascii?Q?hofVkse0DfS4VcL0aKPEqp5Hu5Ry1DEqqHBtnw/kEJrLPMDr9/gXS/p04Dw+?=
 =?us-ascii?Q?TC9AVJjSulzlDjJElzad53/z0KJTFHWg45qU1wY4s2x0emARxe0Ub45h7cER?=
 =?us-ascii?Q?0w8cgyovKX1l2PdUKC/XOOZZ2jBpNTv0hOELs53xKZaK6JcUtD/XZU1GYSvU?=
 =?us-ascii?Q?tcyDxAvys4ZDzmHH/1cq9th+FKPUN/a83Z1MX9I06mho4W0iDew28U8EI7Ue?=
 =?us-ascii?Q?P6naedlpJSytJk3qxI+aIclDjrsPOpNw9UfidLMXTd0vTRZt5zvgKfX4Cc+s?=
 =?us-ascii?Q?BdT++RZeq4u1h7mqLZLewmldtxqheE0iv11TIClyB7WRwb2auD7cRVyOfhhl?=
 =?us-ascii?Q?ze6EVoimmGiaYDHAyxokmUsyzAg2eeR4xBQStCDqWfDEBsdTWEcORLzV4ROP?=
 =?us-ascii?Q?4USncsml04nXadLh30DlOKzQmkM75wTyMxr/c5Qbc7NvwptjzDwizqs/q+dr?=
 =?us-ascii?Q?Psg3Yfd+mn4mWiA1zhPK0k3WEmh6eFYpB569zVyN8GRXL/A7hJfECKz0Bdsg?=
 =?us-ascii?Q?/xINkroDmIU84zomYek2EuALVAIq6TL/WbL9KOi2VT3F3axXv89QoCXKqVXd?=
 =?us-ascii?Q?cTUG7uuQkbXxoNbkHQtjO/uiKyeEXFsHJLJzo+ftroKWCkFzUIXJ3rujQTtl?=
 =?us-ascii?Q?XORoFcZA6KoYCCJxYZi4GMoQYC2uatk43m7X74papXeysZuc9Ob1CullW7TA?=
 =?us-ascii?Q?BjdpM/rd0VEbGBE59Sgq1hPHsT1HVLpLxQRY9mwbmXmRXN2UGOaHwBxwyZr4?=
 =?us-ascii?Q?5x4qPno4rwPmQxRK/yiiLPebtreReai4e9nSsPocCk49sX48CrTCWFsGssQT?=
 =?us-ascii?Q?No2+o9xYvjYmeej7V+LuJ2B8Zesz8lacfxB8sm+uNxPtFMR7wgz29sF/h30d?=
 =?us-ascii?Q?taIDUaYEod6oKV0vJePRx3lMrKAH9zezzdFvu4Oce3+yD0fMpzLBZYKLnLjc?=
 =?us-ascii?Q?cc9kUHKfqjCZcEQD91tcMkN4NRD5rrCKCsHvXg4sdObPzyAwxEG+si8VPaZw?=
 =?us-ascii?Q?kY63IYkqHNwGuQCzO6uVrPx7o7Qs/848BLv5gsJjurR29pDO1sDi1dLIZ2VT?=
 =?us-ascii?Q?OTk8beXL8Q=3D=3D?=
X-Exchange-RoutingPolicyChecked: K3JI1c250hZVPM4jt2viKbnlvHnvC3MpVmQKWLG12KGBKpUbaJQJqvGsQTHUeh0ZpAOCh8l00yqnvlja9XdL7+hmE2+e/jgm7/1lFwPIdSuY1x4cVmE0JWPLY3auR4bdQaC71YTMUbhjpC1HlYc5DZ/YATcZCV0wNe8LbgjdQ0oI/CJVP9eoZZUFKTWCu3va/BA2+gR+INLTfWsil01Z4vDDZj8FdoHK2OmY/sWnO6uKG95fz1wv9u36a7epmvXSrpxfePuULhG+JsvUcYq6Wvdwl74DcDhAQjE2JfnXYEW8JzOG/SJK65X7/Py2zc6K7gedjESZMOQHDB9MUUWu/g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 691001c7-a1dc-48fb-ff1c-08ded25c3cbc
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7457.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 01:51:13.9997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ULT79I2hHVsbbzdlft9l+lnbu42yyBUQ9mzWVNug492V5EN6/ASJFJneGvDwak7lyHgvI/E/zUWYin96cFlx0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5293
X-OriginatorOrg: intel.com
X-Stat-Signature: 35poqm38efd3s1n8oeou188nkdabeo9x
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 41D4D2000A
X-HE-Tag: 1782352280-637809
X-HE-Meta: U2FsdGVkX19k+pqG7/rTTYqMqjrua18npTWbiRJhY5ufX541VKBi8HTEFKWVPI05rBMb1xX4HDzccbCGLRHXV3HX4qbZ2DiWx12FfGfTILLxzmKYdYVl1r3UQruujpOKl0DsWia4dsUykyF69ADDhVEMBZ26rs86ZP6yCQm7YK4WI8jeIRSv9EMsgBFSn9LHDSep1sELJIxablb325JmHbT0ZT2Rvk9eeuikVRsBPsiUEtEsC/aPd8qDliuMqLxkdSp+LhyT4Hf3mGVEF2zSMUnhvWa9IVjIblmazS0tG8tySFPoPUD3HQKfAi8KTmbqdQgQX4TPVpLtOtBD9xzpJk2nur17TYtnhwcDPe7pQLGEus5hEuCrDKcOsHzDk4CN3K70JNnGW4MCs8jnyIzoPa8vQ6785C7Ebvh4B+d5vlpzxZxilqks+hYSzkn1RYIpfI2UOprrvkyELVPPPW8F9mf2I/kJk03WHhjoI7XB46KQOtVAbypFlpdI19VmTPqWht7BajpYSNN3DMPklhxuXQnY4+/wH5dNUMdASEq+PoGeA6Zgg2Oh/NeNYsm0TSXQPg7HK7khOJbq8peoTVBu61CctOXNzrLIj9rqPYdn9U/EInnkV3LcOAP6YOOTanUnuuZqzA+jHP6nv9qTxUaCtq4WGStxmmwMLbmMivk+nbxS6tPIBsylxZ6Pd5cAYXx2JzfiQkkAfPy2zuQXiYN8qfALur3uLmEEsoiC1Y7SSPprt0FIeOTVBq2PWKxcg7tYAqIG5go6PsU/kzOga3egNF4iPWqviYKeTj8nrnkmuxWFPa5s2QIDE0lkjCSnxcGBi3BjV/BCamD8e76ft13uJqeptUKeSiWcEdK3HoNU5ZaaCxTPp/ghhXF07DqlLhMpUWx1rlpT3CAk1+CFSpxtZzPCHaNvQdgLPs/gw2KOXQXN3ispHUVSQE4q4Xs6DVoq9mgMhJpxTFzlD8EQc1e
 lWyNqU/W
 4Nkrdzi8rZF5BOZWInSeZ3cZtGz2hcL8eR1vu9cDOlDtKCYi5D3WmwwFI/wfcanBQ58XRi+lIOZq35R2sMLOazEPbnIl4gjKRvHWcySAXw8xsWC1+KQI+LKj9Op/EM2I0XpsINYU6/JY88SS69hDc6nMd/71gAWsh8NMK3VBCPxxxbanPEEdPKOKX5wkfrESxerLY5R/Yq1aUEJ9mV+ZmnmBp5LyawmWc3aAeMhhLt6sQziH/sYj6AvKuh+LU64Wky32yGuZVTZwKr+FsYKS2Ow1eWgiyWbHlx28ScBApBdRehFfDAYW4Lboo145PxeLTgy8Li5upbBruxth0RAX1qFzjOr4wHtxQAIsf/vl1kJSmpyr+4mmgUl6wBMg5BpSOgcoNAovHa6hRXL1n1KE5V2vDo9PRr/KEsfTgJ9Sa7YfrCjvv/lskQMEOcgDcU2Sya2kYEGYyXBIdhAuLALuw7PM5y0Y7Q5xz9UbhpNEc3kskVnxHZ+zGC+TkuUDuyVPOnvG74U3PCs9JKlNg64WeVEpnw8SuC0K2BFEko4opq9K9WTAdtYDzAJxdJlykkdrNlMSdqg6xc7cYi9s+DSaPjSNXTPVt2LnhJS2PEcrDrETAnMCo3cLuSLHZadlyq68gqQh9OXdzIWyxafTlIlh8tDQ8R1YVZ79lE+Yz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 05:41:58PM -0700, Sean Christopherson wrote:
> On Wed, Jun 24, 2026, Ackerley Tng wrote:
> > Yan Zhao <yan.y.zhao@intel.com> writes:
> > > With gmem_in_place_conversion=true, userspace can create guest_memfd without the
> > > MMAP flag. In such cases, shared memory is allocated from different backends.
> > > This means this module parameter only enables per-gmem memory attribute and does
> > > not guarantee that gmem in-place conversion will actually occur.
> 
> KVM module params are pretty much always about what KVM supports, not what is
> guaranteed to happen.
> 
>   - enable_mmio_caching doesn't guarantee there will actually be MMIO SPTEs,
>     because maybe the guest never accesses emulated MMIO.
>   - enable_pmu doesn't guarantee VMs will get a PMU, because userspace may elect
>     not to advertise one.
>   - and so on and so forth...
> 
> Yes, there's a small mental jump to get from "KVM supports in-place conversion"
> to "I need to set memory attributes on the guest_memfd instance, not the VM",
> but I don't see that as a big hurdle, certainly not in the long term.  And once
> the VMM code is written, I really do think most people are going to care about
> whether or not KVM supports in-place conversion, not where PRIVATE is tracked.
Sorry, I just saw this mail after posting my reply in [1].

I'm ok with gmem_in_place_conversion=true just means KVM supports in-place
conversion, while we can still create VMs with shared memory not from gmem.

Though it still feels a bit odd to require TDX huge pages to depend on
gmem_in_place_conversion=true when shared memory is not currently allocated from
gmem, it should become more natural over time once gmem supports in-place
conversions for huge page.

[1] https://lore.kernel.org/all/ajyCn0PnFtQK+Nka@yzhao56-desk.sh.intel.com


> > > To avoid confusion, could we rename this module parameter to something more
> > > accurate, such as gmem_memory_attribute?
> > 
> > I asked Sean about this after getting some fixes off list. Sean said
> > gmem_in_place_conversion is named for a host admin to use, and something
> > like gmem_memory_attributes is too much implementation details for the
> > admin.
> > 
> > Sean, would you reconsider since Yan also asked? If the admin compiled
> > the kernel knowing what CONFIG_KVM_VM_MEMORY_ATTRIBUTES means, then the
> > admin would also be able to use a param like gmem_memory_attributes?
> 
> No, because it's not all memory attributes, it's very specifically the PRIVATE
> attribute that will get moved to guest_memfd.  I don't want to pick a name that
> will become stale and confusing when RWX attributes come along.  The RWX bits
> will be per-VM, while PRIVATE will be per-guest_memfd.

