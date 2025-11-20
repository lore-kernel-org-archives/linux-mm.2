Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BCE4CF856D
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A758E6B0088; Thu, 20 Nov 2025 04:14:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF756B0089; Thu, 20 Nov 2025 04:14:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A05D6B008A; Thu, 20 Nov 2025 04:14:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77CBE6B0088
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:14:42 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B0FD1A07EB
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:14:42 +0000 (UTC)
X-FDA: 84130425204.22.BD71BD9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf17.hostedemail.com (Postfix) with ESMTP id 806C340008
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:14:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DT7Yo2ZU;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf17.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763630078; a=rsa-sha256;
	cv=fail;
	b=SsbZytYurioJZSzIS2xjs/ygT+9f7uzfXZXDYQwJC6phDk34c2AAMSXghXtGkFnjAN4EcV
	YIU1xCgDBk8d/ctuFYW7XHJl6RXnHzze213CNXRgVSLfq+PMtquIsszYZf1RchSqdrIjEM
	kXdattY3cehMQr79OfAIMO9XQkQEPow=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DT7Yo2ZU;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf17.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763630078;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HJOSrKbZU52Is7111s2LHl1ZmmO+0rey5Onm+ZIJOK8=;
	b=dAKjHyfi7aZHdzZIpz8s/f3rSc2mBUaHqWuhMV4Kb3Ctb18aFuX+ka2LVEW4CFeenH34W9
	wGfzDpytD/ueyD3K63zJHpXvt1NDOvSoiNPdL96pGa1o4C1v5cPqBPQtWPrhyfy2A5z+tB
	jpPKutG2J2BLolqx76abRtsi1nSMMR4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763630078; x=1795166078;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=kFKUy9AcbcwOpHwlssbZWtA6ZyTVS28ginS/xLMA9hA=;
  b=DT7Yo2ZUW+I+4ERsbkoNC/e0sgIjL79+DSNLUnwnGROgMvE9rXAbh4om
   j0d5LdMwZJZIDNw3JT1S5Fyr9f/KPdV6WwgDSJ50xZBA50+eekbw7Ggnm
   fgPnc3kWG4A233YCyC0ot29gKGSs6A1PQGb+Rtq3JPSn97NsCspvNeEen
   RMfjD6lJOXAWuQXO0ijFouNvKrLehPj1DTW/nrz/yd+hHcvBE1rg55DIH
   zVTwIPkrTTaKfpUP84CZHitCO9+enJMqj3FGUc9WXwmX7/4WY7yN3/wQv
   IxFLJLFiubP6bAMtLj6vWASZqk+MBifvKAkbruRNDnQ1LmXPW1hNquW1l
   A==;
X-CSE-ConnectionGUID: lBnoSNykRhK0Twe9rkFpHQ==
X-CSE-MsgGUID: xmcgiDaDRk+wmuXt9lNT5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="69561327"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="69561327"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 01:14:37 -0800
X-CSE-ConnectionGUID: HT5+6X/bR0yY3aNi9aBQMg==
X-CSE-MsgGUID: FtWS+lFoR1KKzd3P5wxuBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="196276818"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 01:14:37 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 01:14:36 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 01:14:36 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.32) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 01:14:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lMkzQROIV+o/EKbSKrua4/pO0TErsi9tpKqR+tyiRUfOUV+z+aSH/wBLmmwxxaV+ommuZJxlwbpfLLHrbRK6z9FX2zgeEKkKXshWC/fWYqktL4PptDvVD+Smi2WwdNokw+pdCdcYSNBsU7wEa699UedcSgbM/Cei0VOTmCVcFvj3ODdlXOYAam5mM/rBVkmSlqmM4lPcDqfUP2Cj9g2YakktgdBqvR4pg3pBTsmx2CxPIEHrjYUM6kOTwJ+2Tc8ukuXu4XR4UperGBI217qWCuZfms9EvazPv2J2VtVKSL4wfRpP+ZwM1HwxJEd8ItbfEXitAh+NpmQEXOrmmv0sFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HJOSrKbZU52Is7111s2LHl1ZmmO+0rey5Onm+ZIJOK8=;
 b=Roq05HCViZXPu5KSSW9TYDSz713Up9xy+SeRZF9Ata1AxukajiSCGbrlJer6DgolbMz9XECfmaZ6D/0FhZ9Xv5nYy4egz5RFaRGqfiaAXjuCYzxbuowd1Iu5t21FOlIqd3KUOdjZwiVB18j/lU9qIvFsWUtCXtMz8EhJhDWiJ0drgTnSJs2KBQTFlmW8T3q/MSNeQYssCnzBa6bkPJR4KkVDdPE/bNtRVQU1d2AaqZl3s0QpztAsdoBWzyzgrDvqGTHCt0jfIa6u4CzQI6uJCMx9wLao2yhAU1gZyMXvp5iDYLwKeDT8XhhoRIZfOcI0sInXDCFZVp/OFcGgwcd83A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB8551.namprd11.prod.outlook.com (2603:10b6:510:30d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 09:14:34 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 09:14:34 +0000
Date: Thu, 20 Nov 2025 17:12:55 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH 1/3] KVM: guest_memfd: Remove preparation tracking
Message-ID: <aR7blxIx6tKD2xiQ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-2-michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251113230759.1562024-2-michael.roth@amd.com>
X-ClientProxiedBy: SGXP274CA0008.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::20)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB8551:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c54593c-45ad-4498-825e-08de281538af
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/M8MaoT+C1SliPhdOf1B7E9HAEQWfPpTrFW93xjfRW1er87FBDH5mZe2Pqap?=
 =?us-ascii?Q?VbXxcs/em1Ngn/lmz5kkKEUPlgm7zarv/5eQH6onprIAuDTYq3TRrcffkCKh?=
 =?us-ascii?Q?C7kA9KX5ULm38r0K1ja7RzJnEfVkgCfxYH5+53Uf8giGJQ3AL/IIXXkvmeBK?=
 =?us-ascii?Q?kY7WZ4oLeZ9jt0WeB2kd11Us8OXpaW9CnyyHNS6PgOR4EIifk9mhJOt+7tMe?=
 =?us-ascii?Q?nrfK4DRkNuFIC2kTjp8leRV7BKRdcvhYxKRQ9b6YQWDTekDH4Q1D6u7OjS3Q?=
 =?us-ascii?Q?gFi68p3lW2xPSHw5ROJM1j/lENaaTuVfFEHzxOyJOzFDYGqVZ0rtUunAOj7i?=
 =?us-ascii?Q?y6lLv1jEKA+SMF27JeXoqMbcIVG+dmZaJdEfvbvv/L0XoXZGd/w5ewyT4anv?=
 =?us-ascii?Q?9UZYOK3YLGRjcDCpCcGcmTGdbkttP5jt9NjyUarjjKnvZpT3gmyHdSl6Hf/W?=
 =?us-ascii?Q?wME7uQll4PY6lNGkMte5x6iA5MqAfF6Bq47ml8E/YA/0c8LPAO+MquIHvPal?=
 =?us-ascii?Q?bx9vnG0ep7tzNeL/4LUm3K4kxj61K82jcHas89pvZaLSa6VTlmccHoHF8o1S?=
 =?us-ascii?Q?kPCd84un3Jp0mccuWPPz0AVrgdS5W7ysmB8YCQ9j6D2FTYH4ujs/1RKtBGue?=
 =?us-ascii?Q?6eJup5P1HH2KTOC3qSLva5rClQNehAZDG6Hj7NnNo/M8eUF2OyBhliI5eU0r?=
 =?us-ascii?Q?WaOT2yolLjh2eC3L8+j3p4DxLfUr4VsULcJqn7em/KDGMSddp7vfVqipAryy?=
 =?us-ascii?Q?bZq6MEY+AvnmMWv4kI27UaCl7LDOgP4YICcIjt7PUOV9/eotJuRFhf5KPZtq?=
 =?us-ascii?Q?w3dIejarc620b2hBsQV201Nty4tpjXFKBi3VjS5Pkh/6IVjpSLTgn+KxjstV?=
 =?us-ascii?Q?1DMaXEo8vUb6C1ab5pflAXSS8zRsEx8XRrzp/IGo6rMd6OR2RP+mxnkIrohu?=
 =?us-ascii?Q?42ekuliRNMOmFYHiteROUQQrahrGfMsbHlNaFf52vjh0+tkOTRXonhPonV/C?=
 =?us-ascii?Q?JDKFocrl97/ZZW4eDJsOLT9ffWFjCHhgEByDSzq2nxOpCgM7nRcL3hRJ3Mf1?=
 =?us-ascii?Q?dHwz1mmToTVy74ZQfJB1+oqbR7B0/YIqRuKH9nZ/q9IChuydY+6CVJlVrIeH?=
 =?us-ascii?Q?HwvNxeRC5ApGvgzWICJcC11Rq4De1Oj0u4zCMzmCmjr/HvoxQgak98g/7Afj?=
 =?us-ascii?Q?QfeW0lK6xFcKoWPQJSjfzbR9V21gnqaJlzoczNj/Vp6EK/Dr3r5BJCeiuO/3?=
 =?us-ascii?Q?QAdLJiWfbCeEEXrExymFxhbQl0bxBbt7Y2UBHdbzGCmQNxGhmcFvjc1yrVTS?=
 =?us-ascii?Q?I7lmgt2Q7Hbd6YJomV5NkS9zSvSArsxPyxrTeMdlvYq0KqdFFHy4qpsiN/MQ?=
 =?us-ascii?Q?X5/6dwr8pCkLQu+pgaDUABscFpF3/OjVAQcy4GBF1m7xyayqkcPx2yJrEM5m?=
 =?us-ascii?Q?HSmjbR1jNCfzJcd4dnUQh2YsbenHo8zhK04R7piKH9uyiA8acmSxPg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PtQvNgM8z0aHk4MS1ST1babH91C0pf7poCWZtCuvr/QhHJumr/zMfYOreeyr?=
 =?us-ascii?Q?nUOWt3YxygKZACqIDP0bElMM/E+uhsrE3OYlIcZC5vXchpiNJaojuBaHCrmA?=
 =?us-ascii?Q?7r5DNl1ZEo5r9e0MFTAuNbn/SJbQ1b/fMyiX/1a37QTdn/69I71YlxNZmuMC?=
 =?us-ascii?Q?1GAsuWkl4qjqTYadO1BzzE7TkpbFGjT+dtEB0VAEicNiGGgycL2H4eL/3CP/?=
 =?us-ascii?Q?vo1gVLMKnaQqP71jtMsvkp9dSYyWNIeztXKzxmaXC5U/hxyZ/LbwGr1KKczI?=
 =?us-ascii?Q?vzbvZvE3K9IXFuePYsbnoqXTG+irFp4F7FpQMGPC6G2d2OBdElvYL9URVeZz?=
 =?us-ascii?Q?jZQv+gZa0d/o0LokpwYW57WAnL0N7loSTw0OHjvwM8TIOpyBUBGdRUMZOJgv?=
 =?us-ascii?Q?/LlXhC8GkI0nNyh/rFGrNWJjWKcOSVXr49gmyC6HbOSSHOb4NzP6ty9y9LfR?=
 =?us-ascii?Q?+KUkSLXkO/1ONlE+COCAEwT9uIicsAnNhYjIUlKOrY1jYz8VL5GvRkIWX6V1?=
 =?us-ascii?Q?vTo2aESCceANvb8fdfXdtD9/P8kjTAMD2B9MxSXdXrI74zrrAI9X2A0y4pQ7?=
 =?us-ascii?Q?hGZlBGDNtFyk5v+Gbmbfbn9nYhJx1Ooen2q6DLwGTOjq0t5pW4hOgGGs4LHb?=
 =?us-ascii?Q?UXxOpKHrgzD/gp7mzYdy9JHnq1WwU8Gi7w8IY/Y6LRF1FeWlrk3CIisCvSyU?=
 =?us-ascii?Q?0JtutLs5W3aj4O5Tj1hVMPvkUf4+opoJVzHxvC9dubR5OxPbJTuY+fV8AHmy?=
 =?us-ascii?Q?kkNFh3DgR2SJM2WrlZc8MDIf2lOGu9hiCg+dIo02qvVM7Eoyypu4yVghrDlC?=
 =?us-ascii?Q?GXfpxDyFbdPxunEapFcantJdXT1Vdr+hsVb8COsTv0zP/vT6VrLpuuAWnLRe?=
 =?us-ascii?Q?FLkB37yQW1eVz059IQLjHKBulvTl5IwC7K2AAKDYcNfNZb1NIYW1J0vAg9Ma?=
 =?us-ascii?Q?yUOP6NID7MojSPBJozqdLw/uhPMFSAi8B+8GwQVg4T/GN2LhilV9Bg4BrF3t?=
 =?us-ascii?Q?F/LOHDhTfFSk1fH03P1fiBZMdzs0ZVPsaKiOzgFv0A8nNClYPFot2K/cbQ7t?=
 =?us-ascii?Q?bO9HU7doxpUXRdP2+Xqk/i8ZbIFEVbVazkpK0UQ1UPnkx7Oac/XX9TjsK5a4?=
 =?us-ascii?Q?etyn0bMtpKM3gjJw10QeqBX1B7+75/Dmrpoet+BqtIcqUqiFvDFab2FZ5F5/?=
 =?us-ascii?Q?Qh/8QYuh1zsP4zbdbaLEp9P0VFjW5FT8jffSbeqZGhVGkj4ZkOzEoaMIbz8+?=
 =?us-ascii?Q?aApgr4qWl1vJNq5u9rNmsGtq34fnEVbMNqyfpVtFFCjeKu2v6sHtGiq0798t?=
 =?us-ascii?Q?xvZ6MHmg92f0esUHZacpTKLk6Shi86DW9ywODq/tFp026pHlMIzcFjsBnaRP?=
 =?us-ascii?Q?aqOpLKG0MLRc3EifUL3X7otrRynbOaXOJRnXL8ctw5eh/SsyFoauLeazB8S6?=
 =?us-ascii?Q?B3w/gZhjF697spkphNt1StlhTvENgCkPQBaNRbzqKbPvF6JmA7iM5A0f18WC?=
 =?us-ascii?Q?oD0+UIn+gmzatsbh03MEsfFYFpDHZLLJ9HnA2rcNSMzSzql9mnBSdPmyeMxF?=
 =?us-ascii?Q?83kkT90mPIroHTBHM6acY1O8P6XgwD2ZHgp2nRIy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c54593c-45ad-4498-825e-08de281538af
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 09:14:34.5541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VRf+DoPXS0ZbBIsLI4ieQfezCdJzS7dRZoX/h/F+Rp3Z9wV0SJhFuxvtXr/3JbzWeAfVdYI5bMbtV9tUQoDzcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8551
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 806C340008
X-Stat-Signature: 7oy5f3xnhg3437xyrpa4rp57uam8jy3h
X-HE-Tag: 1763630078-818319
X-HE-Meta: U2FsdGVkX1/Gst6lFu6xPkPZoDemKXZOlnoZjhTF9mkiMQmzzgWpOXtXIfxpGTI8Q1GVuZV7BuwY/YFliKK6bovoZxt0YtjZ+t3eNCYEoy60lLSidzOaq3RF33Ix8vOqTIS5MECxah20ONIyUNQ7rf8U8x/gWGLoi3yujJqNqCiBhN53MnQsBBo8ODmqnsWHrdgFQebAVzKR5ZMRHJbPmDR5I3d06m443HslT1MmV/GBqlNAGFbI/ssKxVs2iTtAdSNu7bBVN8uf2Z77eydNfV42tnwPTjql2wCg3njtDtmxvQag9Z/8vtyO8TYBpZtKKjx6ogFYZokiGCmHFPN29L28jSPXZPzcO+KLu8e5OZ4OAKaEBemQRRKife23/2y8/TGQOVRjTPqfTW0dNssnHgmxd0qGkmTiQOwm8pIizFWksNvfObbYH/hE1XKdWk3oZ96vcSalMyUdlVdl2kMljH/i2SujPKHyX+zG+KF+uVDPk8MCeuD47iRRllkLM1CSx2hol/nJ+HijDBd2RbYhfWHG0iWWGYpWyKKDfeT7Sp1qtspaLgy/J1DYB8m3sqJwgDfXRNtx3SVz8rm4iF+iP9VfNShM9ueVHjGZqTI5S4nGctuYnjAHfi1rVxyXTLJdA+Kmsbu1UjW85TDnz6pNnAgnGIBrBM259lPMixvFhrX4bHfRT3r19Hiew7ilp4yilD+3G5xI98aYvPI0RzkaqJ6WhsZ6Q+xrCW7AGlMnpofU8Dfp4ruTMCqdSJ/TNn0TTUbVTAcFP4OGYwUFcbFYvL5eorGqyYBIqKpsyL2KnY+z3lumCptEuxE+aMaL/TDGqtfIx0eiC6g6ONk7IWyvNZ1deBsLdXdLJTZmZic9/DWf6wsNvHpBO/2Y4bYXLvsYKWIR1k0cc9LB3NR6SrQdmcIKRJm/64WiW6jEZ92btLYQZGhqAVyUqjRT1EEeBls+nLDppJSDbb1cMaPOI2m
 Q7QERZ81
 F441fWlm1S6wUmiRprirSoGJrz8PirgMGBM7VqnjE3DxSet+xelZp8hAlX0N9E8q6YUzeG2VTVMWjZvN/71L+eeS/du7oLBhr5AaLnVdpppZXAyld78BMdSK+D5VWkACGIYZ9wQ8qBI692lpPhgkUD6wHWIHMceGSwMl78fGPSUhBovQzesdB0e0EMAUcH41Cczc5XjOdmA99EjmlYT4Q9jeKZvcVixoc9hgvk9dH/TvRla2GH3/o0gEIJaytHaJpPrLmcJeCe8tH8vJAi50RlYwOFUciwJTZHgATQMZxyqtHJhdLVXA07l746ibu5SpI0tKYQ0rte89zx5z5Hi0B4zgf0ZStlJszK21kjduu/HeJHo1xxX7FIyJ5nTCa8wRux5xD2cAYLh5yBzhwUxTSIwX1cOcCT2j0+FY1PNaq2Cpez80e+QM5YkNkqvzCaEwylUBiod4q0Ke3iWH9TxgVzgMNeLuQPPjCOVJlXLAN4ay0rvKUs11jBBhHRwF2xyHnU1pP60hWUekfGJcte5MGnurah1arn3IZ26GlP5+eH3WXcwgRRHGiXK7gg7W4xkLgGutp+EkS9vDpVs78yLP5x2rG8d6/3HJ+pauyNBLMeun9YKawbo2aLf1uSHrXepxmMlbs5kKIyfM0rJkQIwxr1KkyY+h/O28HO2nD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 05:07:57PM -0600, Michael Roth wrote:
> @@ -797,19 +782,25 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  {
>  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
>  	struct folio *folio;
> -	bool is_prepared = false;
>  	int r = 0;
>  
>  	CLASS(gmem_get_file, file)(slot);
>  	if (!file)
>  		return -EFAULT;
>  
> -	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
> +	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
>  	if (IS_ERR(folio))
>  		return PTR_ERR(folio);
>  
> -	if (!is_prepared)
> -		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> +	if (!folio_test_uptodate(folio)) {
> +		unsigned long i, nr_pages = folio_nr_pages(folio);
> +
> +		for (i = 0; i < nr_pages; i++)
> +			clear_highpage(folio_page(folio, i));
> +		folio_mark_uptodate(folio);
Here, the entire folio is cleared only when the folio is not marked uptodate.
Then, please check my questions at the bottom

> +	}
> +
> +	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>  
>  	folio_unlock(folio);
>  
> @@ -852,7 +843,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  		struct folio *folio;
>  		gfn_t gfn = start_gfn + i;
>  		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> -		bool is_prepared = false;
>  		kvm_pfn_t pfn;
>  
>  		if (signal_pending(current)) {
> @@ -860,19 +850,12 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  			break;
>  		}
>  
> -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> +		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
>  		if (IS_ERR(folio)) {
>  			ret = PTR_ERR(folio);
>  			break;
>  		}
>  
> -		if (is_prepared) {
> -			folio_unlock(folio);
> -			folio_put(folio);
> -			ret = -EEXIST;
> -			break;
> -		}
> -
>  		folio_unlock(folio);
>  		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
>  			(npages - i) < (1 << max_order));
TDX could hit this warning easily when npages == 1, max_order == 9.

> @@ -889,7 +872,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  		p = src ? src + i * PAGE_SIZE : NULL;
>  		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
>  		if (!ret)
> -			kvm_gmem_mark_prepared(folio);
> +			folio_mark_uptodate(folio);
As also asked in [1], why is the entire folio marked as uptodate here? Why does
kvm_gmem_get_pfn() clear all pages of a huge folio when the folio isn't marked
uptodate?

It's possible (at least for TDX) that a huge folio is only partially populated
by kvm_gmem_populate(). Then kvm_gmem_get_pfn() faults in another part of the
huge folio. For example, in TDX, GFN 0x81f belongs to the init memory region,
while GFN 0x820 is faulted after TD is running. However, these two GFNs can
belong to the same folio of order 9.

Note: the current code should not impact TDX. I'm just asking out of curiosity:)

[1] https://lore.kernel.org/all/aQ3uj4BZL6uFQzrD@yzhao56-desk.sh.intel.com/

 

