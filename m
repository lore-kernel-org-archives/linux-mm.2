Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C02C1F54AAA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:01:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35D056B0089; Tue, 24 Mar 2026 09:01:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30D186B008A; Tue, 24 Mar 2026 09:01:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AE426B008C; Tue, 24 Mar 2026 09:01:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 06EA56B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:01:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A759CBF746
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:01:21 +0000 (UTC)
X-FDA: 84580967562.30.927CD9A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf28.hostedemail.com (Postfix) with ESMTP id B0880C002B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:01:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ODAbmsh3;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf28.hostedemail.com: domain of yi.l.liu@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=yi.l.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774357278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uUc7T9IvzEnt3lJQjzEcbi3IvSTA8KS3jmb2FNvIU5w=;
	b=XzSvjjkEotGTELviTz0EoUySqJHyRIMVdXlbJUiMSt1lSl8rlUnSmbm9mP5/QWX3WfzBpA
	9EDVIXIjpWVXHLvHLm96ckiPhINLbnFIyUW/wjuNLzJT/7s4YNZdfobGn97l09FU1EHE6V
	in5wrRbn+XRDUqUvPUlrOtMRRYqodzM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774357278; a=rsa-sha256;
	cv=fail;
	b=p8vWA7SkCWcwzBzT5zFte1dLRm0NK/PNNTLedTddaUysPm0Xjw5eLcjyvCsR8KUqlbfTqc
	GwJsTt+7DuH0gD5gjhrg2nxi7OXvW1m1FvOZli+EmIzQIjumquFJ5DtJPxQ7Bhh4dlgZYn
	yYE87EIilgRdirEB6WbTXzvrfo5ZS2g=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ODAbmsh3;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf28.hostedemail.com: domain of yi.l.liu@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=yi.l.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774357278; x=1805893278;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bKdadfi32n36/vCY7AHFLIobsBhJMsmb9DfifoYfdlo=;
  b=ODAbmsh3Md/QS/83aXyosykV9dx52uDTlseduZpsNci74Je3cQj0VqbN
   dQNz6z4AtG1T4GtWck6CVrTspdemUxHZHPRei9kguLTQjaT0QNMbbfYlq
   iFfF0dXoRAzK04Em9C6TsQ0VUbPxccvomSve7pg+b+6z67vL6cqfrWIYn
   UWmRO1UYLusd365n9xkQ2HYAJ8X1M3saIFd7jxeVKjrTW6sA8uuLv8M0V
   eMzr2WKuiJadbk+nEvadRMJsgM5mI6fG8T87yV9trJU4Ldhk7WGQv/NsA
   3vz7LWl/aPbqSUIauy9ldmOZkvXXEIR1q5LBGUNPZyezDL7zwROdy2LOY
   A==;
X-CSE-ConnectionGUID: gHRf/IGPTXC9lxGTGbjImA==
X-CSE-MsgGUID: Ln65hJmBQ1Kls166v2bA4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="75276818"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="75276818"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 06:01:16 -0700
X-CSE-ConnectionGUID: 2Gq0kzPcTvCMdsRSxqJcCA==
X-CSE-MsgGUID: XJ5zyzc8TNi5kBjf3h1Rbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="254826173"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 06:01:15 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 06:01:14 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 24 Mar 2026 06:01:14 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.0) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 06:01:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MR0Z0DCpsnfld1Jr3iMP6fExClCee9GQzPUJxLHkvk/fFf2BDiTkUjm4NPUaGGiqKVBqF7Y2Bf5npuheukm6IzWyJgnFkXpRu32A29baaSUs9G9UAtXdVWgZpmmuumJpLBYyrHEXwNfZCun3nRae8ZRurb8yjuvawaSxVJ4gKhPWbP32qGe42Nnk6HRUgkXOngL+u6GE6U6YLH9BE/Qb9BveU2yGvUkdekQQWXIbpor72KD7oJJiJxtfrxq46c29YVTnIsotoTrFKwLQcfcmf08X3xOogeH+uZrDZ9IgZDWHeFAejewc5pWk1/gU8bob7fnSsdaDlJDvql5jtm91+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uUc7T9IvzEnt3lJQjzEcbi3IvSTA8KS3jmb2FNvIU5w=;
 b=IkTCqx216AU9mve1aCneMuWQ+poXNhKjbpZsX4w5xo7Pv82eIRfVVSxrGT7AFKgpbZv8URW9W45ymo9iclNbWsquPJvkVHoJngUeCvAdCcroYdhhDNC7p4fxZIfLn21vEQk2J010k06I2yVTNRdZA0O5fLBxC9FyTkW5ckYDz1ENFRXuRAqfJIZBjjlksHZZH1UM2C44GFMKp5yOkrIXB3ieJsnNm0+NdvDgOQpi1uiRLcdUg0f+elb/wZUUlnjnU0COeFf4sePIhfBZyypcZmYfdqZzM0/J+SuHeVNSszmy5Hy6gmq52JK3kEEfh1CelkqsDpXyfmQ8BaIq4N/JIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV8PR11MB8509.namprd11.prod.outlook.com (2603:10b6:408:1e6::15)
 by DS4PPF0084F97E3.namprd11.prod.outlook.com (2603:10b6:f:fc02::4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.12; Tue, 24 Mar
 2026 13:01:06 +0000
Received: from LV8PR11MB8509.namprd11.prod.outlook.com
 ([fe80::f5bd:4dde:4f2f:20b7]) by LV8PR11MB8509.namprd11.prod.outlook.com
 ([fe80::f5bd:4dde:4f2f:20b7%5]) with mapi id 15.20.9745.019; Tue, 24 Mar 2026
 13:01:06 +0000
Message-ID: <815947ee-2603-47f0-9b03-f523601eae86@intel.com>
Date: Tue, 24 Mar 2026 21:08:36 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/24] vfio/pci: Retrieve preserved device files after
 Live Update
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>
CC: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf
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
 <20260323235817.1960573-9-dmatlack@google.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20260323235817.1960573-9-dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0109.apcprd02.prod.outlook.com
 (2603:1096:4:92::25) To LV8PR11MB8509.namprd11.prod.outlook.com
 (2603:10b6:408:1e6::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR11MB8509:EE_|DS4PPF0084F97E3:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c9e3d63-fb9c-414a-d8f4-08de89a56907
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|42112799006|366016|7053199007|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: P/asUU4QAeo7cHHpKRsu19z2H6t4DmdDW4QapagtKDfcN27CPD+oNM62CWGDWrIdN7JjxdfDpA/ELoyEuov+e6Clk6dmL6JfNT4ibcrlBkfPKlTGdjpj+sDHaBsrMXpWopLeCw3H6NZH24hRwhBT9maPqgz//jEw7WSqjiGkwclACw5oDF9eGZpxNTXzaOz2AdpTo7Niaw83JB3U/LTVV7GjnZZ9my/CB3r7XRN2PLYRk/kUACT5hKw5tjV1rhY/pMNRcin2MTLSgIjvBvffEwkhWY5mo9lf818tU3vwxu9u44HgQ6he0SYzsTto37aLOgi84U6LzZV8NFEn9j+mI1/hGMALNoFE3JSltNPEhPoMZfwsLvwFRFIG4cBiM2APJlFhZ3pgD22gcb/1q9nghkNfNWNBnUaDpC8LUKft07/BeY9LEjyPzPmCAF4QLObMjvAcG0r4QMH8JGmu1HdUjwwVR8NTYcNxRtdghJvy0FXmjP73ZeN61bxbDnhywOTmZ4GT/NQSKVlzxHWEWicS13bcmUhErQ+e+zSHo2F4xUKwllDXiU0XAs5EaVaFO1/QT3QfKmhDB9Va0Ki2aZvd5InKmJCndC3ecgJgU7IaUc/ZBam0ICqTBbfB569UbLbodRrFG89oAxCRZRiLsNcIB3xIYrKzt5yNqbU0Kwem2duecUviN3fP9oBSv3lHorNtrECNQ1BbKnQh+LSdQ3F320UKHAUN95BE4R9gbyFoA3Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR11MB8509.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(42112799006)(366016)(7053199007)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VU42czZhaGxvSHdkcUJjVkZaT0lnZWsyTWVmK3hBb2JTRUFGdEgzTmZhcERY?=
 =?utf-8?B?ejB1K0NPU0g3cnNJNEtRN1F4SDdpelR5Zm5Kd0hHK1dZbVRVUkV4RURFUzBz?=
 =?utf-8?B?OHkydno3dUp2L1RrcXowc1N5RVRvbkM4dTJkRERuTXpGMXdtQmhmN3E2dnZD?=
 =?utf-8?B?YkUzOUxPMStrY29IMnhqWm9oVnZ5WkRaWlAxdVBhc01FRHZuNVhiSjFlTlk4?=
 =?utf-8?B?SFgyZy8yZUl3U093TTdwVVMzWXExL05HaWkwOG5ReVE2T05ETXNuN0Nqazdu?=
 =?utf-8?B?SXZxckR1OXRMbXFuNlk1cjlmZjhSeGNRUStlMzhXckR2VUlsVDdRMmpVcWdV?=
 =?utf-8?B?Ni9hQjFzL0IwRFlsaDh4dkJDN05JL0N1aU50NVphc0dPR09oSjJHQW9GTlow?=
 =?utf-8?B?VW5lM0Z2VTdmK2dmRnBKSDcxbVZtbHB3bXZ4NWVVRkphaVM4SXRaUWxwNWxY?=
 =?utf-8?B?VUZXS0tXR3dRSmtIU3hJMEJPRUxodU82b2kyVXhqMFpDcEY1dXQ1bEorNERq?=
 =?utf-8?B?RHJzREtaclpkRkViSUFkdWx1MzNaby9jVFRXQTRBZ0pOZWlLN2pxeUdxWnQr?=
 =?utf-8?B?RDZuaHZOR3p5ZUNoWTgydXBVb3BscnVLdUZtZytPeit4Z1FOc0VkMWZRSHpD?=
 =?utf-8?B?Qk1sWGxuWFBVaWFCYUxqUjJzMEVYNkUvQnpsQjBxQjF6VnR3Rm5hRjFubWxO?=
 =?utf-8?B?YTB6aDRCRkcyRW51SWZoSHhXNmZ2eVFDa0RCSmNGSzl3VmFSdG5DNkhSUXpj?=
 =?utf-8?B?L0Jib3JtVkpOUzE4bWJCbHVNbmNXeEJHQ0tpRkRXQ0hPSzkyYktCaExlazY5?=
 =?utf-8?B?Wmsrd0tJZDV5U0JzWTdMQUxHUU0rUXhqZHhXMzdOR29HYUtCR203YTlBNTBL?=
 =?utf-8?B?L0U5aGNLbldrTXZoR0YzakNPUzlPSzVVQzFPa1g3aFd2UktGMW1rMHViU3NV?=
 =?utf-8?B?aXZwTGd5ekUyWHN2OFBjeGdxbkZVcXNoMHZJSFd3REJUU05qK2kvSDYvWmpG?=
 =?utf-8?B?UGY0Q2RCZUVPT2RmY3F4dEt4c1JpUGN1Z1Jjc0kzOXpWZThFbUlWT0hOQ3Ni?=
 =?utf-8?B?RUZmSCs3MFE4WVl4M2NSNTZwQVVvblg5Wlh2Vk1idzB5VVFaZTJYWWdHUnB2?=
 =?utf-8?B?TlJVWmxHT0M0U1VXTlcwOEhZSHhIWVVsV0lwc3R5S1ZzY01MV0V0ZGNkUkNM?=
 =?utf-8?B?ZkY0VTJ6T25ya3E0NzVsME1meEQ4NEN6emtuZ3Q3bHdtTjdOQXBhdytWeFZm?=
 =?utf-8?B?UjFrNWxoMEQ1VmJLY3lrM21oNkdXc2w0VGF5NlJrNTJUNHFURVR4b0NmZ1Nq?=
 =?utf-8?B?TnVFZzFpLzQ4blJwLzlQeHArUjJFcTRTbFhCdjlxNVduT25Ca1dBN2dxWUZS?=
 =?utf-8?B?aXJPV3V1cmQ3eG83WDZZbExnQWZEUkxIZzhCemE4TnJnT1JmeDB4cVI1K1Ft?=
 =?utf-8?B?RTAwZ1AzRjMxNGpFQ09NSmVqNG9pL2ZkdHQxQW9oTzBRN3FaNHM5OVdIRWI1?=
 =?utf-8?B?TUhLbHp3Z3QwZ2hUY0U5YzV5dzFrM0dOMktFY1FLMlVhcmtuekcxMVZxNFhC?=
 =?utf-8?B?TmtUakRUQjRqU1FLWUkrR2xlT2QvZWx4WnlRWGV0SmwrMFlGc2RYUzZzNHZw?=
 =?utf-8?B?b0Q0MjRwd2hEZTJIL0t0QWwvazBYbjdzdnBSTXkwSUZCK3I1bytSNnJhOGNw?=
 =?utf-8?B?ZW05OUFMOGtLc3hVWWNmWVVkcjF6WStuYkV1Z3ZiOTViZ2NKUFZ2NjJYQmF2?=
 =?utf-8?B?UnFLTzFHV0w2T2g0NGZ5empBTmhueXJoVGM3eDBHNFU3L09iZnRUczFDRnlW?=
 =?utf-8?B?QWRQaXJoT1dNUTF0THNTcXY5aWNOYnROdHdzcWZyeXV2Q0NOU0RFOWVSQmRs?=
 =?utf-8?B?OWxDQ1ZHL1Vwb1IvSFFQbHJvYkEyZi9FcmIwNjhCb0xnazRXL3pqb0E0cW92?=
 =?utf-8?B?WUxUd2NCZ0ZCWFlCMk9Ia3NrbTFsbEJGMkU1ZzNwSDRoaElUS0w1T2xaQjhQ?=
 =?utf-8?B?Wnh1YlNqMWdZbEE5UG11V0MzRHkzR3Q1Yk1zWER3UTI1b2prL2xqUWFwZ0ty?=
 =?utf-8?B?eDdXVzJIa2RZVUFaV3FJeEtWYU9tRlZmRHFTTEVBMmY1eTdTeFhUcVcyd29Q?=
 =?utf-8?B?UjJnRVBUckt1WGtIN3h4MUNBcTVwa0FZRVBDaEdWbUwxeCtZQXg4eXB1UE1F?=
 =?utf-8?B?ejE1U1ZjdmFlSm5pMVM1K2xoU1JNWUZPbERZVlE0N05Vdi9EV0hCWjRxcHFC?=
 =?utf-8?B?SWZFa2owOXA1eUxZc2c4dE1kcUJLdXpBRjU3eWlURUV2eWlGQysvVWp3TG5u?=
 =?utf-8?B?bVJEVUtmV29wZWRpWSthWHgwSFZDSzRMb0RTUFhQYUFjd3dxUks1UT09?=
X-Exchange-RoutingPolicyChecked: QmyQ8F1sDMWg/zuE8MRl1l1rEFH1GGX0JRSvjmjlpbYHJwNotyvTn3LIoarzBk6c6tWg0qG91dySbM8mh3wxcIp/sE8/lj0ASeVybl5FRU1VNj7F5IBVIo4gNDyMUUhupTrzOdivRrj9XmpZL6wTZPqHqMV84+avu49FFtBUrXsxj0l06hOSyoJ38fU6Ky212Z3ZZ2cKScHTLZltSBvEZzqLvK4JBgrdLLeLAAql1j7ouGrTaFqSvO3Im3BDA3mDXVwIRQupOXbo+WsIBj/viLvybdKpM/EGjWVvdUH0Nw0w9IOSNFY58Q7SloSSmj6RreSkfW3yiHceyQauqe0XlQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c9e3d63-fb9c-414a-d8f4-08de89a56907
X-MS-Exchange-CrossTenant-AuthSource: LV8PR11MB8509.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 13:01:06.1825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3mu/fsnaAYZLCGCHhw9CtDfFW7DJiyNq826Qmwos6doccQos/9/yuCioD5d4r903G/w1Kedh3YrEo3F8R+g0nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF0084F97E3
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Stat-Signature: qkihyjr3arwwdpz4ckyuyg7a1nowaowm
X-Rspamd-Queue-Id: B0880C002B
X-Rspam-User: 
X-HE-Tag: 1774357277-370913
X-HE-Meta: U2FsdGVkX18w7HCI9o8YsyztxCCtaeC8wpNTsy+2WJG+IXn5lvoeJCu/Nyk5iZuaSDv0p9jeFJbgF/+LcIeOzK1Th6VPaobS+Dj2roYsu7G1WxqGrTH8DNlaZrGbVVAjRqrCRufYhodlDcVW/Ozv+KEgZsk+k/Kv0rRCk+8jAj2BQy7+kwi2UHkggu7TY4PIyVwE06Xi1msrozcBOjeNjo5NeLo/+cTsCWU8peXAaAxvkt0u4XPHc0nmBWnxbFC2vAWM7MTdOel+cE4vAhXhi2r/qQT5jTPOZKMXUjn/gqGyRCbkn5ZYXpT51a/Q0+WfGygAszNQ3tfYoGQEby8CySdSSO4sVUk42/+RwiLskHxIOwwIurWN8oL/eDDg6cR9HRuEDdKHN7hIeXggosDnriDtSbDQPogormagwXr5Sdr4EWTnYHu0zX5rGviuqhTLGl9If36sYjjMk1K4oBUmtg5reylj7q7iNNeCW5mq2xWBRM/LExcJyNTf5F+md6CWFlaR3iBiulo29q64aw6xSFiEuK14xMfAbRwwh/4CaN1SVv1A2Z1K2UMKvidFPWQkgEVsbbIkcgW1+3tCECWXs+HjnE4DbmAarRi3WQBVXdvXAWdjcw+AGDRMNU2mfreIAVL91Xl9E258kUKybYRU9+YRqxSRnBF02AWBP/lruD7Dx/qSbUFZy4HNPDGlN4ENllCQzY7kqzuEgi6lX1slHJ84IHiQRjNm6+f6XNZ9IGXiKbsbX43ofzjIM8McepUNaWVfr6pwAZpHkqldMMa/DGsVoW7I6+gO85wBjBv0Uu6cK77MjCqaWEgRwtGGCobDRexdzRwi4giuUmJhvx9Yhs6/N9guToc24IckfOeSbvXzW06ec1RI4v/cdaK+U2e4PkbOcfRBKOeV+wZUVVb3+DXb8jE+8RzGS2S4N29YgwsTOZsj8JbYMfebAMYlhSVPqqWhv04+U/z9MuzbMMz
 02bkd3jo
 FcC1wPxE+EIweS7dIOnhutwmx/qg963mfMrmSoujewca8/FEfOC/QOXybtsZYH7vGrtiKvZ8vU6xG1pUzPz0yDMgMBcHUTYezXOv2RQ5M9GsGbcZ3QLt+v7enav0MtFbXUmZ6pwWUb8wuQUBpBWMWirwYu3c0Jo5jWF08nQda6TG3PDONczlApy9Pqag71nqtFuagn2I71scuDq7L4fBfNuOnPLJ4LThsHMh3NojY5u4sqEUdD+h4b+1BKrJ9iO+LnLukTpA9q442SqfADuxagL2VFAWONZTS5AxPwbC62yeLTVVFxAtdTEiqGlRczkS8kFCl/qpJg1g6wpRrW56D1UebOefqMCjsJ1FOg9Fb0x2u0xuFu9zY1K4FDwMpXFDxZpwu5TZbfP0c6aIcoU+rGKk0ou8zMjHfwYWPuPuuRlvx3FW/tGlnV9oSKtqhGD/Tax+2wvHiJ5budlir3hBOUBqyICN9IDSvURO2Dbe4yN02Fz06jciUAuvbjLQU93YJPjROeffIvi8ULC7sLD+XvRAg9DvrzJ23q2MW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/24/26 07:58, David Matlack wrote:
> From: Vipin Sharma <vipinsh@google.com>
> 
> Enable userspace to retrieve preserved VFIO device files from VFIO after
> a Live Update by implementing the retrieve() and finish() file handler
> callbacks.
> 
> Use an anonymous inode when creating the file, since the retrieved
> device file is not opened through any particular cdev inode, and the
> cdev inode does not matter in practice.

do we have a list of struct file fields that do not matter?

> 
> For now the retrieved file is functionally equivalent a opening the
> corresponding VFIO cdev file. Subsequent commits will leverage the
> preserved state associated with the retrieved file to preserve bits of
> the device across Live Update.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Co-developed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   drivers/vfio/device_cdev.c             | 59 ++++++++++++++++++++++----
>   drivers/vfio/pci/vfio_pci_liveupdate.c | 52 ++++++++++++++++++++++-
>   drivers/vfio/vfio_main.c               | 13 ++++++
>   include/linux/vfio.h                   | 11 +++++
>   4 files changed, 124 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index 8ceca24ac136..edf322315a41 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -2,6 +2,7 @@
>   /*
>    * Copyright (c) 2023 Intel Corporation.
>    */
> +#include <linux/anon_inodes.h>
>   #include <linux/vfio.h>
>   #include <linux/iommufd.h>
>   
> @@ -16,15 +17,10 @@ void vfio_init_device_cdev(struct vfio_device *device)
>   	device->cdev.owner = THIS_MODULE;
>   }
>   
> -/*
> - * device access via the fd opened by this function is blocked until
> - * .open_device() is called successfully during BIND_IOMMUFD.
> - */
> -int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
> +static int vfio_device_cdev_open(struct vfio_device *device, struct file **filep)
>   {
> -	struct vfio_device *device = container_of(inode->i_cdev,
> -						  struct vfio_device, cdev);
>   	struct vfio_device_file *df;
> +	struct file *file = *filep;
>   	int ret;
>   
>   	/* Paired with the put in vfio_device_fops_release() */
> @@ -37,22 +33,67 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
>   		goto err_put_registration;
>   	}
>   
> -	filep->private_data = df;
> +	/*
> +	 * Simulate opening the character device using an anonymous inode. The
> +	 * returned file has the same properties as a cdev file (e.g. operations
> +	 * are blocked until BIND_IOMMUFD is called).
> +	 */
> +	if (!file) {
> +		file = anon_inode_getfile_fmode("[vfio-device-liveupdate]",
> +						&vfio_device_fops, NULL,
> +						O_RDWR, FMODE_PREAD | FMODE_PWRITE);
> +
> +		if (IS_ERR(file)) {
> +			ret = PTR_ERR(file);
> +			goto err_free_device_file;
> +		}
> +
> +		*filep = file;
> +	}
> +
> +	file->private_data = df;
>   
>   	/*
>   	 * Use the pseudo fs inode on the device to link all mmaps
>   	 * to the same address space, allowing us to unmap all vmas
>   	 * associated to this device using unmap_mapping_range().
>   	 */
> -	filep->f_mapping = device->inode->i_mapping;
> +	file->f_mapping = device->inode->i_mapping;
>
>   	return 0;
>   
> +err_free_device_file:
> +	kvfree(df);

any reason to use kvfree()?

Regards,
Yi Liu

