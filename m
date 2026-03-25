Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5636C103A9A8
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 11:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C37B6B008C; Wed, 25 Mar 2026 07:05:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79A9D6B0092; Wed, 25 Mar 2026 07:05:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661F86B0093; Wed, 25 Mar 2026 07:05:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 54AAF6B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:05:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1CF8E140865
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:05:13 +0000 (UTC)
X-FDA: 84584303706.23.5764565
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf16.hostedemail.com (Postfix) with ESMTP id D5FE1180009
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:05:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nJ4nAh+w;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf16.hostedemail.com: domain of yi.l.liu@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=yi.l.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774436709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hl9itglNZ+nwpXlM/1VmBFLcC/GeV+/1K+p6m/gQmsc=;
	b=SBG6NtSAHuLfVfmVhGvz6JCIj832/k0qYgS7vQZObMKPSnqhH6giIVuiFVVl3+3YfrvSFF
	oI15S2Uhc9FidbJBBTDBV9euhVOKno8F8nUgGvNGxVwA4qu8Jdj/wTrqn1XJhb7ZZ0ZY7R
	HjjWFqPcswbrmi2tZC97cKXULh0mjzw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774436709; a=rsa-sha256;
	cv=fail;
	b=lCTdI/kj/fp3tQOQAPUdTG2IN3pTBt7gELq6S515JGlVcvoCWNSqaqqzbdxCgmiLcEQiaG
	HwHkhp/pXghFGGHaiX3TOjTemGAhsOA4HnUN4IGmMABuFdBQTZsmqMM90tV0AXsy2wRgP0
	9lVDppYCfUEVmLZL/rNhiH8sj0Z34z4=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nJ4nAh+w;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf16.hostedemail.com: domain of yi.l.liu@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=yi.l.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774436709; x=1805972709;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=imt1cext6K6DQzJd2pEeH3Aud1tLo+yB5vwLDlmv91c=;
  b=nJ4nAh+w30wHfex8hDTpIIWNTNBeT8A3lY720JJtTn+hhdwygYEgHyKH
   2BtaILomjveE7F9zxUsUlMUe69Wmm58IrLq73D8QCdc+eh4crD01oom0x
   y3qSp5CK0Z6KTYn0LlXLiPPgOHATSeYXZWTZbAXT60zupWTgEudQnsqV8
   kHTaIUe565zhkB1SzdxkSrIz39Qrf34mCyqLMtCOKt2WwYWTu/QbtAZ8l
   pSMHmcNK1fMMHQFpiJiZUmUzXu+q4uQBjmtL7AAkxHXz98lgnRrOC8vAi
   0VbGA6Mu3wL/7lu55of2gAne5pNIrhtNXx7j7Mp4LWjUb5wcLW6HXWw1p
   Q==;
X-CSE-ConnectionGUID: RqgOPg3YTImKP9I3wQRZDw==
X-CSE-MsgGUID: M96SUEXmQKySQ3evkljJiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="78068189"
X-IronPort-AV: E=Sophos;i="6.23,140,1770624000"; 
   d="scan'208";a="78068189"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2026 04:05:06 -0700
X-CSE-ConnectionGUID: L0GF283BQCqqoe4wXVvy7A==
X-CSE-MsgGUID: 2dDmLeX0QXWiKYO4Jm4zng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,140,1770624000"; 
   d="scan'208";a="226290739"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2026 04:05:05 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 25 Mar 2026 04:05:05 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 25 Mar 2026 04:05:05 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.41) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 25 Mar 2026 04:05:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U/eblCu7j517SS751y0ndM4ICUnOC2mfEwodF/GP1X2+ttZ/mDyaTUr4AgT+XizzPY9KMwzUnb667CL3tvCGihFtJeSQ09nZdlk5hOcY8SRiFf2kPAYluNl77fFhfXiaGdQ8xOxFot+rQStSy8bhDa7cZ2G6Rt4uNKPbK8VH1tcCEQFFxklqLvSmiwKsWIrsjKMjSBm3NfU3CejCXPN2Dch8ev150+6NW54VUV1huXDzJBRx2TGXoLcMqXfJCtyvtIiP75PKl5OO1z+Qz3ytOt3eY/kBxIUL/CniY25bzXiAvwtpm6yXcT+2DegX8eMbLf+wF87elsLBV90ve+LUHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hl9itglNZ+nwpXlM/1VmBFLcC/GeV+/1K+p6m/gQmsc=;
 b=NYa1qzog2TyUpmhF3Sn0sLd+CKoPP7i0M1X3LljJZni+frf4XQof0A8Izf9FQmxP3KnT4FNsxFDsyMwksmzuih0Gp7R/Hp9iC0yA6uXCvykYJFUyazTlCwNZYLL9g+IQH/z3xsyV/eyyw/PAGBOqozlB9+ltadiNifuNwMI5dmkxVQpX/J8C9goNP4chPGOj6JFjGc4SBT64f2cwLCCpaKov6OB/imOO5/Vlq2UlhKM95sI/o7oMwBvjvf3MzDjySMeeRVIwXBHoOqupHB6phSWykgVFy82IVxJIjrHIX4opc6EAiraNAaR3IXNbhhTm3D0rWUdkVCwN04kLvzZPMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV8PR11MB8509.namprd11.prod.outlook.com (2603:10b6:408:1e6::15)
 by CYXPR11MB8692.namprd11.prod.outlook.com (2603:10b6:930:e4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Wed, 25 Mar
 2026 11:05:00 +0000
Received: from LV8PR11MB8509.namprd11.prod.outlook.com
 ([fe80::f5bd:4dde:4f2f:20b7]) by LV8PR11MB8509.namprd11.prod.outlook.com
 ([fe80::f5bd:4dde:4f2f:20b7%5]) with mapi id 15.20.9745.019; Wed, 25 Mar 2026
 11:04:59 +0000
Message-ID: <b16f93af-1ec6-43f5-b4d0-b1d390e3c23c@intel.com>
Date: Wed, 25 Mar 2026 19:12:33 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/24] PCI: Require Live Update preserved devices are
 in singleton iommu_groups
To: David Matlack <dmatlack@google.com>
CC: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf
	<graf@amazon.com>, Alex Mastro <amastro@fb.com>, Andrew Morton
	<akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann
	<arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, "Borislav Petkov (AMD)"
	<bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, David Rientjes <rientjes@google.com>, Feng Tang
	<feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, "Jonathan
 Corbet" <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Kees Cook
	<kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	<kexec@lists.infradead.org>, <kvm@vger.kernel.org>, Leon Romanovsky
	<leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-pci@vger.kernel.org>, Li RongQing <lirongqing@baidu.com>, Lukas Wunner
	<lukas@wunner.de>, Marco Elver <elver@google.com>,
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, Mike Rapoport
	<rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, "Paul E. McKenney" <paulmck@kernel.org>, "Pawan
 Gupta" <pawan.kumar.gupta@linux.intel.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>,
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
References: <20260323235817.1960573-1-dmatlack@google.com>
 <20260323235817.1960573-4-dmatlack@google.com>
 <376910fa-4232-4e58-bf87-0504202866a5@intel.com>
 <acLRICLAP5Ccqt9I@google.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <acLRICLAP5Ccqt9I@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TPYP295CA0039.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:7::10) To LV8PR11MB8509.namprd11.prod.outlook.com
 (2603:10b6:408:1e6::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR11MB8509:EE_|CYXPR11MB8692:EE_
X-MS-Office365-Filtering-Correlation-Id: 1eea5afa-622a-41f7-4db4-08de8a5e5af2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|42112799006|56012099003|18002099003|22082099003|7053199007;
X-Microsoft-Antispam-Message-Info: /d0iJsSksAYxtFQoMvHtlNfaJNRB+ZOtc5m2BoiySyTzmk/Use6dcCeOzVym+xX9TBJS9O1wv1IQK57M55tRyQrmvwJAI599cw2IoISEZUPnaam1Xi3ff1JcIq9dTElFw+H9ylce8/kmAua8xRPmb9S7QMSjp2OZ6f5PxFzZQI4Ou9IcB4kcgYwKBELV+/iM7ahpmyHO7T1QiPPGpTaY+sfgh+hz3OTeEvMpCnDMtQx4ChSpgGLvIVSE3FdOolTWB1e+B4S5qTMSVEo/0zI26bJ3rFn5di57dOyNbeOllPHJye67CY1oBWAAjfBHZpT/7H0Leeqix4GNWOB1DjhN9efnKHDPCYqbdPPtfEMqVgjxSLakHkRhbw8Rq5CTnE1kO/ROT3AbCZVfPtGFNp2h84ha+NzjdryESVKeXWueHJGQsiiIt7IVOn21sGO/3zrMR2CfT9WqEjyogA0Ny44lrSPDrAEzqXBh4sPM23AdYuZEJEqbH3wuJGv45WxRNlA3L5inFkn1AeoHNANk7NyCKThfqPL8PfDSOU9ZwhAYjfdgM/YXGtLIHFjbaemwuVufdWZj+gU9dPgL6gUIkOCq4slpt7G6+3dItWwm0apBn8K13eJUKcf7xTkMb3pnxo8KVtIH3vbZX/4+M1HGKp2QRrQJWkGUuiL6SOJPQ6Cn4FkKCHzipvKZo6bE7KcdUuZYktm6o9GUlwXhwr6Kr/Sflw6YQ6987dfZ6mo2JeAOn20=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR11MB8509.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(42112799006)(56012099003)(18002099003)(22082099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkExK0FyNVd0UUpiSDhqcFFleG5LVXNOSHBHWHhMbGxFTXJVNTJlSThMVHdy?=
 =?utf-8?B?Y0RuN2JXUTQvcnp1KzdqWHRHeTlrdjJxNDdKcUVVL2xLNnRaMVZaWXk2M0pH?=
 =?utf-8?B?UXpocE9WbVhzYlY3ZGtPRkFSZ3ZJWGVJNXV6VnBYY1RRdWFIRksvWFViTExR?=
 =?utf-8?B?ODBmSlZoNHdCVVorcW5MRmlScURQbHd0bWQ0K0lCeTNOcUhSTElKdlZUWGNo?=
 =?utf-8?B?RWRYeFJ4aG0wQ1RTNERrVEdONEVHNTRvcUlUaEhxTlQ1b1VkWmtabnZXaGY0?=
 =?utf-8?B?WUtRZkdDUzNXVTVSOTZPZWIxaE15Z3BmeWhvQUFyb09VUEhmaC90K3NDZEZs?=
 =?utf-8?B?Y2tCRWJXam1nZGczTDE5TERJZCtEdW9vWUloRWE5UGY5c000WWpVallVQ1Z2?=
 =?utf-8?B?WW1kVFJJZ1krVThqV2ROVTVWVzB6MjVzOGxUeWRrU04vOFdjQWoySExialph?=
 =?utf-8?B?ME1qNC9IU3RSMVFMK291QWQweVA1emZoWlRPVFV6K2grNzREaGRmMWh0bExO?=
 =?utf-8?B?Vm9NendoWlAwVW4yc0h0VzQrQ1VPNmZEeURUcUplWmtCb1NJRWNrdFNhSUJv?=
 =?utf-8?B?aGh6Um5xK3dSanJGQzExT0drbVF1YkVuR0FjeDE3MHl4QXRSZkN2Sk90eXcr?=
 =?utf-8?B?Wld3bDBESHY0SGVxTUU0Z1prbFl0OC9mK1dwUlFMMEkxd1Jhb1RvYTFKVVJ0?=
 =?utf-8?B?WGh1QUw1dEtoSXJ2NGMzQnBzU3krdENhWWl0VUJQd2tMa3l0a2lvaWw3LzVG?=
 =?utf-8?B?YlU5b2hBNVlRNGZSRjcxcFd0MjVwMSsrYlZBRHpJUFVObmtnOVRsN091Z1hC?=
 =?utf-8?B?VzZ4d001QnVvcC9NTXBicDU3OTBWWlBtZXVRQkpUaEZZV204Z3BRZFl5Z2tD?=
 =?utf-8?B?d29qYjBDL1hWcDZINUFjZkFPSDlIR1NMUmVDaWhaMEJNK3I0TUJ5VkY2UlAy?=
 =?utf-8?B?YmhKbzlwSWE0RWY1Nm05Q2YvdmRVRk91SzFhOFFyMXFPZVNxek5yZmpPOWZR?=
 =?utf-8?B?eVdXSEJ3K3Z2NDlISVR4QXBsbTNRdmdjRTR4c0tjNlVqVzVEQ1RKdG1jbHFO?=
 =?utf-8?B?NWk3b2FIZlN4ekhScmxuN2tiSnQrWFFzcGs5MkFoaXh2WUxRNFdZN1ZKYytD?=
 =?utf-8?B?NXM5VE95T2FJSWY4S0hRM0F3Qjk3cHgrNjdXTmo2ZDlhY1ZkdThrb2lWWVNu?=
 =?utf-8?B?TFhvSTNDUjFxNi9YOWFpaU1LTm53eThmOCt2ZllZQ21pdnhuVkFaYlRma2h1?=
 =?utf-8?B?QWRFbEFkQmE4ZDYzWkpsWmVDTGN0VS9vMDlPei9FNW5xc2hpYnY1bzRHRGRO?=
 =?utf-8?B?MldzN1ZDNHo2UER1ZTNLZE5NWms3RUcyNEd0OEFqcEh5a0FIMU9zK1g4ZEsz?=
 =?utf-8?B?OW9yalhxWWNHT0xxZUx4K3BXaGoxSURsTWxxc1ZucGhlVXRkM29uWlNwU2Nl?=
 =?utf-8?B?K041ZS9BRlFzZ2tVV3R1eFFMUEh6RW42ZFZRZkVTMWpCTGZtay9uWlNRYTU0?=
 =?utf-8?B?L2NTZFoxenpMVXhLaXFLd3l1TExuUythUWZsWVlna205bDlLT0Q5ZlhacGhU?=
 =?utf-8?B?SXkrWDJIV253Q1VTblM3aUQzMDZldzR3TjNOYXRaN3NYNWdBS1lUbkRxd05C?=
 =?utf-8?B?LzZ0WFAxYmYxclBER0F4SDVXQ0VSaHhxd21INTlEa3hXVWZiaXh1cGlWanJl?=
 =?utf-8?B?d3I3dUhGTlJXOEwzaW1uSU05cnRZTlZDQmZBRVd4VXFvenJQRWI5eThvOU11?=
 =?utf-8?B?MVFtY0ZkZXNOWWc5NWRSSmh4ZlpLN2pwZ2pxNVVCeXltVUVZUFZwU2tjcFBB?=
 =?utf-8?B?NXdRNml3Mi80UG9BL1Y4a21MM2trWXliclppUXVMbm1ITDlEQk5oMjdOemN3?=
 =?utf-8?B?MEQzTjFVeUNLa0dJTG5FenlVM3lxWHV1RXh1NVE0RVNjVWE4cnB1MGVqM21y?=
 =?utf-8?B?cHZGaXpTcHh4UzRVZ2J2Wm5QR1ZkVTNUTnFIOXFFRUUvUWJJd3RaN1R4OXp3?=
 =?utf-8?B?OXpvN2NQLzBpWjhPT3BhK0Q5eHpEaXpab3JManFvMWErWjBYWjFyNTdoVkto?=
 =?utf-8?B?aWJYV0F2NW9qeDJPZ1pXNHRRcEovQzVvZTZFQlZ2eWc3UUFTYW5HMktHMlpy?=
 =?utf-8?B?M3lwa01PWU1HZW50Z3VsUTdxdENTcjNMYWVIT3E3M1hWSnh1WkN6NU1Ienlz?=
 =?utf-8?B?blhNWWowSXhvenNERXVDQnlFTm40Snp5ckJLSFlMS0NNdU9zcHFxbmRTM05x?=
 =?utf-8?B?ZXZGdTVDV1M1RHRHdWtocmtJUUZqcy8vN25SR0JNa2dnSUpBWUFsQzYxZE1z?=
 =?utf-8?B?SWJGbjFyQkR6UkdMeWNCVThOa09IRTJEbzY5UERISk9VclJSdjg4UT09?=
X-Exchange-RoutingPolicyChecked: sNKlx6rhcHKpg7sjOD4CpGtXFqoK/vwD2M3CXk65NCqyZ+5J+pXP6yBuvxFMM6rD6DCbisGZIZNxoKvD8RT7ECS1qgMsJTVoHtKJrRpGf4On/7WhcwyAUBM3YFpJNR2A/FEpNZbhZxJtKj1x8E6zlDiXPzxXOh/SgM+FiAFi81vfyjoZUSsSFmmBvwCMVfedl8zFuzaYWC54rw6IEjKgsp5cFfjJa9GLHaK3iOM/jSRqm5JuA2rDqFFtSwn+Yzsji2F8rUwVKrvG4HpWCis86Mw5Mi99mIZhl8gbpmDLFj7r8N2+XJindo2ih9t9PIOG58Xw5j8YjEGklKPKYwDxTw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eea5afa-622a-41f7-4db4-08de8a5e5af2
X-MS-Exchange-CrossTenant-AuthSource: LV8PR11MB8509.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 11:04:59.3841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x0vLyzZ1FzeWOshkikZFV5Ob1X7FcB4EmxN+PU/0Wn1vHHDISeSxKPhvKcE6IXS7fNJE1aPJmdkzkPAz+HjXHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8692
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Stat-Signature: g9zs7qiizgdaa78m73zb9nfnryhdtics
X-Rspamd-Queue-Id: D5FE1180009
X-Rspam-User: 
X-HE-Tag: 1774436708-108570
X-HE-Meta: U2FsdGVkX1956vO4MGi7sLrThizXK6v+iCSLkMrNnmY0B3MA3pT9D/ujNExC6N7bh/dBhWtWgYzMy6ke9ipVAtodzlw3+r8l3H+09hnKpEiXNoS7rREBAeNPjQQnVIHInUO2x256DX3YA2kXj3d/ZSii4PWH2eVhLUJ3lMMP4ID6RRRRzKz7irynANkXPYE0UFvW5uCDr1kfMKKcpP7phBUX2jKAFCLqBALPiMksoBStH+UTUZvfS1xRCYOPzFTrXUw3h65M58lcoes0M2U/lGiFT/ncnNUdAMcn5gTh8XWuk9x9Jys97xl/6BCUEs3XfJEuiwrYlBAO2z+gO902cOnyKd+jcvtHG0VRcVCvRHcNUodj0fqIgaDp+DkUigbTt15cXQ2jAL34CMY3k7klOy9mcesU9wkRrKvQNdfOXOyPm6s6e1GrJmUXoXmf14Yi2jCagkKO+tY/4pUFdYchGzz8Cruhp5dgcWOTQMBQJFgYzRSg3spZZFv3Tvh48OOBpQDNEgLj1f99hpdr3/5Y+h0IH+55prpnn0aBdzmFbcbRy0qsblYI43mrRjYB7Wwg6n0/dqWxnzk0R2sb+wQTwTovHv+W9MFduJvZk60jObJ1sQJl7TU52t1VfRKrtuB0DCkl95yKYkyj2OC6sXkXbaLUsbkKb9qtGAohm42UR/YH6tKloUFHPwBLDgiK/om42dgTYn0F4FkTXlRYtBgbkvsYG2xnwVe7FZ8LCvNqJjgm/kTZOWqQ2fXlnydlrONgdRBUPURKuoyfBt9i3fR+KDLtlCsCAV8I4VbhVED09aHxfb988HslE8ROmOf5D1dnk7raNJd9J26Y/c/oJw7QuJUH9Zczk86OEVnSZFtr5zEhJNQ3yTecb6b7XdAxxq8+S/84PNzdqUVEfNFlapSkNv4mVQynLTOz46vhOpuRpOyiinq8xMgXTmh+R0TLFPJhjkYMIUsZmW854MfzYcx
 HKXuo2Ty
 qSg17S0jeGCWEg3aQgScccJ17lTuuLSVA4Jf6FOzmXXy6Jb9dN8cybPmaFNgz7GGH7GHUsamJaGgLxXk6JC0/fBDkIG+c0z9rOtWn83dGVaaaB68paGr60GvwS1ayqYwVFfM4/TRvGKklha2mWndQT0jJ1tvTcl1CdmRGGrOZC7GmjzpjdMitKk14myo0EChvjUNVlAoTukZdIiJzvHZktRCYfdfd5rbnLCMzwpMv4fyCnxB16wn7DZelwNJHWF0LqhU9ciyi4DsctqY+JGLWXz+yq8uEGWmcSHA5gk5G1FiNDXBgc2kS1pjAtqweaP/zBDZw6KvAU9e0JbVovt4Q0PoXnCqqs6qvjWGwLkPLxqB8Eg2o9zxYoXJBWyRufgSc+Vwy8R7c8PiQPfSXwy9pk26ZGA9N6H+k2eY/CEDZ4QJ8ZApqTXJxXpNpviWamtqHFUuxbsn4kJGqrjshU3I/cCH+Ocwv2j4JgNIIJ7QugG30fFuMy3n45pAf395QzyJKnM5qi5MI9We2TY63jBSUIAO+LgaDlDSSt3NCr3/kFWcmUt1SLkiho1tTRyL2BvNKX5aXdZayDPuTNCq2CCxlXm5T9jsMvYQQuYPL1q0srZQIvGv6cRuI+d7k8GoONjIgxfqSj8dJnxSE3/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/25/26 02:00, David Matlack wrote:
> On 2026-03-24 09:07 PM, Yi Liu wrote:
>> On 3/24/26 07:57, David Matlack wrote:
>>> Require that Live Update preserved devices are in singleton iommu_groups
>>> during preservation (outgoing kernel) and retrieval (incoming kernel).
>>>
>>> PCI devices preserved across Live Update will be allowed to perform
>>> memory transactions throughout the Live Update. Thus IOMMU groups for
>>> preserved devices must remain fixed. Since all current use cases for
>>> Live Update are for PCI devices in singleton iommu_groups, require that
>>> as a starting point. This avoids the complexity of needing to enforce
>>> arbitrary iommu_group topologies while still allowing all current use
>>> cases.
>>>
>>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>>> Signed-off-by: David Matlack <dmatlack@google.com>
>>> ---
>>>    drivers/pci/liveupdate.c | 34 +++++++++++++++++++++++++++++++++-
>>>    1 file changed, 33 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
>>> index bec7b3500057..a3dbe06650ff 100644
>>> --- a/drivers/pci/liveupdate.c
>>> +++ b/drivers/pci/liveupdate.c
>>> @@ -75,6 +75,8 @@
>>>     *
>>>     *  * The device must not be a Physical Function (PF).
>>>     *
>>> + *  * The device must be the only device in its IOMMU group.
>>> + *
>>>     * Preservation Behavior
>>>     * =====================
>>>     *
>>> @@ -105,6 +107,7 @@
>>>    #include <linux/bsearch.h>
>>>    #include <linux/io.h>
>>> +#include <linux/iommu.h>
>>>    #include <linux/kexec_handover.h>
>>>    #include <linux/kho/abi/pci.h>
>>>    #include <linux/liveupdate.h>
>>> @@ -222,6 +225,31 @@ static void pci_ser_delete(struct pci_ser *ser, struct pci_dev *dev)
>>>    	ser->nr_devices--;
>>>    }
>>> +static int count_devices(struct device *dev, void *__nr_devices)
>>> +{
>>> +	(*(int *)__nr_devices)++;
>>> +	return 0;
>>> +}
>>> +
>>
>> there was a related discussion on the singleton group check. have you
>> considered the device_group_immutable_singleton() in below link?
>>
>> https://lore.kernel.org/linux-iommu/20220421052121.3464100-4-baolu.lu@linux.intel.com/
> 
> Thanks for the link.
> 
> Based on the discussion in the follow-up threads, I think the only check
> in that function that is needed on top of what is in this patch to
> ensure group immutability is this one:
> 
> 	/*
> 	 * The device could be considered to be fully isolated if
> 	 * all devices on the path from the device to the host-PCI
> 	 * bridge are protected from peer-to-peer DMA by ACS.
> 	 */
> 	if (!pci_acs_path_enabled(pdev, NULL, REQ_ACS_FLAGS))
> 		return false;
> 
> However, this would restrict Live Update support to only device
> topologies that have these flags enabled. I am not yet sure if this
> would be overly restrictive for the scenarios we care about supporting.

yes. It's a bit different from that thread in which not only require
singleton group but also need to be immutable.

> An alternative way to ensure immutability would be to block adding
> devices at probe time. i.e. Fail pci_device_group() if the device being
> added has liveupdate_incoming=True, or if the group already contains a
> device with liveupdate_{incoming,outgoing}=True. We would still need the
> check in pci_liveupdate_preserve() to pretect against setting
> liveupdate_outgoing=True on a device in a multi-device group.

this looks good to me. But you'll disallow hotplug-in during liveupdate.
not sure about if any decision w.r.t. hotplug. is it acceptable?

BTW. A question not specific to this patch. If failure happens after
executing kexec, is there any chance to fallback to the prior kernel?

Regards,
Yi Liu

