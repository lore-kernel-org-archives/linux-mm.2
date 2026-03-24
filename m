Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BDEAF54AA3
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE966B0088; Tue, 24 Mar 2026 09:00:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68E7B6B0089; Tue, 24 Mar 2026 09:00:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5304D6B008A; Tue, 24 Mar 2026 09:00:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37E666B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:00:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B113613D00C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:00:44 +0000 (UTC)
X-FDA: 84580966008.07.53F4064
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf30.hostedemail.com (Postfix) with ESMTP id F28BE8001D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:00:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AtfzCOzA;
	spf=pass (imf30.hostedemail.com: domain of yi.l.liu@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=yi.l.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AtfzCOzA;
	spf=pass (imf30.hostedemail.com: domain of yi.l.liu@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=yi.l.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774357241; a=rsa-sha256;
	cv=fail;
	b=6/Nxkia1uL74qFC/0GfexrFXiLz4A8S+iear/FKNniQMF2JXMbEhUPKSabc6moGAbaNDoV
	JZPSGR0ju4nAcvip7lfZtGytD17NDukWJ0HVoj1WdJSekCN70SJ6vm22uN7t5Ij0doT/IB
	bMEkqU/gxPUN4exSo1p+d6fvIc3XZho=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774357241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lQb5/k2yAcAiTjLQqw1nDGYOF21B0VAWjdslZDQnW/E=;
	b=c6Yts6vSotCo/rOoURoFjNTsyI3uBFnlhPnFSyzRDe/hMSY3D0iM0exZAvcdDbpja33OnC
	v2Xs/Rcrh738wVseU6ll/H9wgaBXNZ1RisoP9ME/sd4oqi6RcRerEi5Jb1usb7uWifzQ9O
	Rf2p6WBtaIyD7QciIQENcwL/H0hvRgw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774357241; x=1805893241;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1NIuZwS7+XsnmRAO1U4RjJz/GD+VVRyOdIhR90P5Rac=;
  b=AtfzCOzAKhOL/h+KDdilOeAbdNPZ/DmAZO7CDG/fc/MWCI6s+4ZNgi28
   Oi5LxN7dgO//QKDPtqpGuLBEYlI9ErgnAEw2X0icDbf+OUf9tt1THhBZJ
   IinaQi9Jdl+sIy8kbAo5Ne2h308hpDBa/Md/Oon7uykTuzfftauS/Ck6c
   QAetWUGUluGl3P8Vg9Rgnrt95mt/70sgGLdN2OzBIYmBkKnN1WOE9fsdP
   qBXHiQBsnqIvbTCUOnIDDMXgMlw7klh9WKuq8QCtyQrCVasxqT5rP0VTF
   vrzRPtO/d93KzmFFQRts4R8ZoNmO7/82VvD2rDpuEmEKQas0mWL7tgxVO
   w==;
X-CSE-ConnectionGUID: wny966dgRaOjuOJJFb25hQ==
X-CSE-MsgGUID: X77l7QinTZ2bTV+FbV2Pxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="75276711"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="75276711"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 06:00:40 -0700
X-CSE-ConnectionGUID: 1tJ2fIG4Ty2tIKLEyC/zPA==
X-CSE-MsgGUID: tmXuJcDvTTKbznx6MGvNiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="254825825"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 06:00:37 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 06:00:36 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 24 Mar 2026 06:00:36 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.37) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 06:00:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TQt+QuiSZUu72AC+eDCq/hfYoSNUGncCANCoOu2V7m2E+Z8U1T7Gc2gsLyw47ZvbjIDduhvEem0OrYYZSNHQ7C9JMDh0l+p/rL3SS5YTJgOVGpQ0rKTRexS1bVSrFKhWBD5bV3PZ4FzJvZfQXh9wOOebQ7B+r15FdGPx86Yfeuf63xWMhByaAe86qrFOkz8OFKA/wsv3LamNEZQjyq7XTVO4HON0/pEF72XdIi7V/vSmAHtbRKdAjVLKsClCCuoH2qiG0s1Ga/cUASB+iTyhB02fKrbhge2GuzGG1RdGSzlkmpPt6MMu5GjU/zinz/0ueQyECb15ai7c7wrDyJKoGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQb5/k2yAcAiTjLQqw1nDGYOF21B0VAWjdslZDQnW/E=;
 b=NA+/m3apfhExdWULvIJ9jHrA5Q7ecnM03WR8i3+0CvClcEFr8YSe+FXJcsshYn0keQUyk7VtET8MIGdyKOD2wOdQ8JCMEQXfuTzcBzSchNTwDgsEnzgou3rIbLTI6ZIa9obAQ7ORrDAuScXCwlr3bKOF2EjKfQMBOqClhbY7etDpWvDaoq0ON3TeTfk/gha3qhuESAjKkbF+WnR80UVyD/FjqHBAvc4U2rdX0i6CgA5p79eqZIYXH3TvLORLHnCeLpTNNaQBcJxT1ohBWgkydEtZ4opVt3JQ1JFNZHtgCkOjA7/SWEf7rmleoZR6ZZM60afQTNiRpPkT+5xTDafRXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV8PR11MB8509.namprd11.prod.outlook.com (2603:10b6:408:1e6::15)
 by DS4PPF0084F97E3.namprd11.prod.outlook.com (2603:10b6:f:fc02::4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.12; Tue, 24 Mar
 2026 13:00:32 +0000
Received: from LV8PR11MB8509.namprd11.prod.outlook.com
 ([fe80::f5bd:4dde:4f2f:20b7]) by LV8PR11MB8509.namprd11.prod.outlook.com
 ([fe80::f5bd:4dde:4f2f:20b7%5]) with mapi id 15.20.9745.019; Tue, 24 Mar 2026
 13:00:32 +0000
Message-ID: <0d2eedec-01c1-41c9-bc74-0133ae6ebb04@intel.com>
Date: Tue, 24 Mar 2026 21:07:51 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/24] vfio/pci: Register a file handler with Live
 Update Orchestrator
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
 <20260323235817.1960573-7-dmatlack@google.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20260323235817.1960573-7-dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0120.apcprd02.prod.outlook.com
 (2603:1096:4:92::36) To LV8PR11MB8509.namprd11.prod.outlook.com
 (2603:10b6:408:1e6::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR11MB8509:EE_|DS4PPF0084F97E3:EE_
X-MS-Office365-Filtering-Correlation-Id: d6a03c00-8aad-49a0-86c2-08de89a55513
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|42112799006|366016|7053199007|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: sCCsOZWQ0El4QOQKnWX8NjpH9sQQE7erDVFOf+mf9+ycCe2kVZ2CDZ8YbeOZiDYFAqZI6zcg4CmTqHtKQ5IYcKrvYjSxfiR54oG+CBdzkq9lOqD68SPIkqpTFBZYHRlz1jHM+34Qw07AZKwZtBkM8TXwdFBAgYF0kmb7BWEf9rcQplNowPqoUmam1JFqXntbU1s7R55NCpL9BmDABGbvmC5iT8rsUX1TSv7zHHuli1MD5Bsfd/MtYZgeLj1zOo0X7Td9jA28y2W0pzzLAi/2lYJzOWcPwoT5tPElo3/pu2KKCfKoAY9KULzOwWmXYGZoOV3xF2EAiLuLE/gjSkjKWw9uvj5PAFHTsFoviMrcd7vErfAoFyXKosYDc/2LHkAnPDs7oYV7YaX+OuIAQLWupw72PCiYB/Rp9Gu6ysFooQPFeYtg9Q04DKMsuTlX7+Gy/NKmqqyLcfZpfUFH29vfy2FYTU+rWVV20rENJ/8lAwtK6P/1vWDW63VN/QxTdhSkQa3tXcJe6s9+kMD3j4qmKhV/SwHH0QTrscbkV+qhbiwTTJuN7iYFAIZgfZn8qX8Sc4QeRevFHvqEI69XVA9WNpj7PcNq1s33NBhlYFSWvWTnfmOe4FqziJ5gCZJGMW+Y9C10KThAhOUTmmjdt/jsy8hD0OMVf3aYDnN0ODCFA/MjzRR6/6Tf0SzvBVlkAThU65HUWXrMYBNdb/CZvyf1jTX0/NKUNy/X3TUcZ2bqnUo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR11MB8509.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(42112799006)(366016)(7053199007)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eGRLZ3BkUGxjK2xvb0pOeUczbDZna2JvZ0VxZUpSZE0xbVByVzNZNWhza0lX?=
 =?utf-8?B?bEFsTkVQdDJmeE1oNEpabU5xOXdiUFRJZGN5MjFnSEs0TUxZWTRCK3VzZGM3?=
 =?utf-8?B?L2JzaXdidW81NHFFbmxNbG1GbE5meU9KejdzZjZyMXNmMWZUbU1xWlVtVm5C?=
 =?utf-8?B?R3pJOEFCN1plVFRlVkpSaGNXVjVXNEdDdXdhK2dINXJVY1ZqRnZLSTZGMnJE?=
 =?utf-8?B?dUpvTWwzVTdQVTJna3VING1rL3FiSGE3NkJORGU1a0EzWlM0SGxLa29kZEN0?=
 =?utf-8?B?b1BaZVNBV25WcUxsY29WMkpqcWRjNTFDSTVabGowTW80OGp4QnVCTllTNUFH?=
 =?utf-8?B?NGRERG1IUUpmRkZTNjM0TFdoMnk5QStCam5YSy9JTU5wQkJCSmJ1Z3k5SUNt?=
 =?utf-8?B?VnVmK3ozNGRqUEZhd3p4YW1PVzNPS2pRbENONS90MVRqSEVBUHZFQys4M0dG?=
 =?utf-8?B?ZE9hQ2tZNEhZaDY1cU9rVXEwQ0l6REVRK0ZzUDZzeUorMmcwaGJYWHdHbWYr?=
 =?utf-8?B?VWljNWoyTFZQNlhINnEwamJZRU9tRVhrbVpnRnhxVGcxVWppYWtBRitVMTNv?=
 =?utf-8?B?V2kvNU5XVEIwbnBGbitpS3FYVEhMeDlicytRNitMc1J5VWlSUkZlekRRVmhu?=
 =?utf-8?B?NUV4VzBoNDdyTUlyME5BODZTK1Qwdm5CRUU2dzNBb3liRkpNelJVdEovNTRs?=
 =?utf-8?B?VHR2UDlHOGlTTTN6ZVhRMllvKytiM1RlY09Dd0UxZTZjQnBEblpscVV0b0RK?=
 =?utf-8?B?WEJEVTF5WTVWUEVOVUZPVStwbWQrbGZMdFlQaHp0OFpCc2p1bXpVdGtjTENa?=
 =?utf-8?B?YUdiQ1NqZHJCTnozRExGSS9lZmNJcUFhNldZbDQ1alU4R2VDdDZKQ2dLRHFl?=
 =?utf-8?B?UEw3R2c3WW5CZmhuc1RHU0Z2WVo2TWhDa0lCcDN0ZEZGb2tjdFgyL2M0OEg1?=
 =?utf-8?B?WmRWeTBTQ0J1dERBWmxESmRIUW10THZnaXppNE5aOTVSVHZZb2E1T3Bwc2lS?=
 =?utf-8?B?cmhNemt6cjFTNXZvaWs0cjNYeEt2MEYrVEgyOTJCQjlOaXB0b2ZrUVYvRUZm?=
 =?utf-8?B?UXpuMVNsL3pPVTdXRWEyWlJNZHJYZDlGTTZxK1AzOWJjR2lZTnVJT2RLMkhj?=
 =?utf-8?B?RFFhUWgvd0pyakRKTkZCLzNRNGJjOW9RU0pKOTk2Mjk1Q2tKY3l3SlphbGEx?=
 =?utf-8?B?WGovSklYdytROGRCdGd2M0h3S2FSLytPZzhvNW1DMXNkbWpJSFRiLzA4eUNY?=
 =?utf-8?B?cEFvSFFkUGFCYm9FMVdtbHhoNG5RQ2lSblN6czdndU5aTEE5TUJWWnkyelFy?=
 =?utf-8?B?aTh5aDF4QlJPb0MzdHY3aFUwdWEydUtUUVh2dmNINWJ2VGhzZFEzQlhLZUU2?=
 =?utf-8?B?UTlCY3RGMUg3UFU4bHA5R1Y0Nk5rVU9JNXVjRjJDZTJCZ2JLUlpXS3AvSjBZ?=
 =?utf-8?B?eTZtaXBvVEozalUyZ2lYL0ZWMTA2YWJHRE9qcnR3d3lIVlNoOXR2dDVBUTY2?=
 =?utf-8?B?dDZZUVdXODQvU1lJbHppeXI5RXdLbVlNSTIycDFENndKcG1EbS8zMG00RW45?=
 =?utf-8?B?K3I4elpGVmZUa2R4dW83eThzOWNtNjVvOTNpK3pOUUxyZGYvWEdoVHN6ZHFZ?=
 =?utf-8?B?NVhBZVQ0RGhtSWNISEtOZGNFd2RiSlkxcFlVeXA0dllsOVFOby9NREFqQmVz?=
 =?utf-8?B?bkJhTXREYm5DdVpjY3hIc29FRXFnVEZSYkpiQzkrcnNEVDFza29OTjNJNkJu?=
 =?utf-8?B?V2pra2NIdWt2MVJ4dWpKVkpLVnQ0STZXK2pNdGNLNHVZbWpQaXZvVW5GeGxL?=
 =?utf-8?B?YzgrR3hBWTR4UkphZUY4bEREcE9vSE1tblJ4dm9wS3JmSmlxVnoyS3NCVUQv?=
 =?utf-8?B?YWxCWVNsZnJUb3lNYktleGNnN1FMaFhmZkNUdWl3ZGxMUTRsSE5tZFFiZUR3?=
 =?utf-8?B?eEVhMTA5T2xrRU94SFNuUVRrSXczVnpnQjkvSUJtMzlMOVhLYnVDMU5lTXdQ?=
 =?utf-8?B?MkFtWW9aTXJqSE1oTjNCamVRZGIrWHc3VVN0TzBHL2dsMjFTTVZUN2l4TmI0?=
 =?utf-8?B?UGdKd2JqaGE4TWhhQi8rUzRnZHMvRGdhN0Q1S3B6aHlUUmFsUEMxaTgrUlFC?=
 =?utf-8?B?ZmcvNE0wS0tNWGl2T3ZRSEhwQ2VhWHUzbVZaOHhJK3pXcHl4aDdHZE5TL0ZS?=
 =?utf-8?B?cENLdm9YajMwcklDWlpsNml6NDJ6aGJTek1OODE4cHpUVWZiL3dpSUlKajMx?=
 =?utf-8?B?aG8rdnpJS3YrbXdTQS9rSzlBYXl5TGpEMFpNcTZUWDZ4bHAvcFFaenk2NXVq?=
 =?utf-8?B?ektmdSsxN0piZ0gxWkFCUmJNSWF0bGJWNzlRblVyY1lOeTJpRm9WQT09?=
X-Exchange-RoutingPolicyChecked: Wbub0UgMGOwAOTwf/tPmpMGQ4lb2kW3yYuzaFuUh+ihNXeRMDor+82WYiqbh4Xviq98666a1R97c7a+aQPsSacm7+f4v1vjbpl3fhHtneIhYfLlmRqDL9IZCAGAKMBtpzN226Kb0y3tAPy16n8J5lCWKF2kI9gh+9mYx38GJ318GQVtI7YsftQMi+eA5ym6Tc4VHQdAroDdViacrCTAKOTUcI81NYbifz3zs55X5y04s1NxOsf4ZXMo0erb4OgH+VTM5jwoN5yDLzregslYx6oqi0Q0zt3etpp2Vb52CYiF0R/fQIDX9Uf6kh38oONaI+UAH11GXyjlWnGbafmKT2Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: d6a03c00-8aad-49a0-86c2-08de89a55513
X-MS-Exchange-CrossTenant-AuthSource: LV8PR11MB8509.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 13:00:32.4642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9RzObcPxkyJCT1pSD+vdRXdUQ1APzSJa3NCXNyQVVFFZuk7z6btrlrRy/JTs6y8rdDKxg9ZANErs+zrfKNMlJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF0084F97E3
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F28BE8001D
X-Stat-Signature: wr4qogzk6xdf3hoyh17dcfbxqj9k61q7
X-Rspam-User: 
X-HE-Tag: 1774357240-255182
X-HE-Meta: U2FsdGVkX19Cla6B5Wmwfctgs4s2CuVMjUqhr5nndJ3CeU8yf1Ap6wLmC3fbwgrAz3UfLGRuiXwOphp3z6FxbtGfa4/AoVkKJAMEq1O/AmcS+fgdw5iVVx0+KtG/oRCbR1K1dXCxKJ4FRLeE6u4HDUom1IGNz7n9BpvQ6mh2qwLnwJhaD9+BZjaV8ZXU8q9mA26+0WksvyW1Pb7U36sQtLPkyNYiovVY2TUbdQAwIB2acQAwGlFmZyP1tP6EXcrAXGTVX99bzVf24g9KvMKdTnM5bwUs/g7Ng/SZ6pb3ktDEk+iU7srATHrfejjKspa3zDWMUxrG/m68uyuDvYGcd+z2PYN8dreD4akwuHA3wk5Iw9ZxoOoVNdLzWVaZEdlINm8rYLU6bnab/4N5hvSNpzRYxTC0H7nUO7SANvSJKm6LkFO53H+GyKT0zND7kva5A9eRi3wkfzUBIeP3j6/dTJ11OEbVJydvb8FwKoH3xYxoQp2/YeDVK44w5CrAvpib5h/8smOvBt/TslSkSN3VLybOvmRsPPIQiyr4970dKPXkapRg61pZTh8ZcRFBRWUvzkXsjRcsMJlyys1EnQyUYuREjaI6KQs3+rlVFJ/yS5PW+3fHLwgE0hLKY5fCDb3fyqhm5PIdtXMsMrcnyIUZVOFF+BhFHSPytJfI553KUjC4AJeaFmy2t0bo9g9uePayLzZpY4pxWfHuBkg4LmXq8Mu+w0XfgIbxj67ALrhx/gnsOydgH7R3zOrWqdAY1/cO7dNfRxRpVcrsHcw5az+cA7zC0jUfSmA7vGDCpBL7CB2WGjshs6+tmuuIUBjAS8stg/XhGTWw9ub2CQheWkG035Td39oPF6dzJNNlk8e7Rh7BQNFEfRMIPOaXlDMJHaraHYrclC5xv70Bwmub2gb/xC4yromp82hURgGat8Yz7G7vf6F0u2WTQgSRUgUtrSvhkAwZp1ysbS6eAj0kQQJ
 mQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/24/26 07:57, David Matlack wrote:
> From: Vipin Sharma <vipinsh@google.com>
> 
> Register a live update file handler for vfio-pci device files. Add stub
> implementations of all required callbacks so that registration does not
> fail (i.e. to avoid breaking git-bisect).
> 
> This file handler will be extended in subsequent commits to enable a
> device bound to vfio-pci to run without interruption while the host is
> going through a kexec Live Update.
> 
> Put this support behind a new Kconfig VFIO_PCI_LIVEUPDATE that is marked
> experimental and default-disabled until more of the device preservation
> support has landed in the kernel.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Co-developed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   MAINTAINERS                            |  1 +
>   drivers/vfio/pci/Kconfig               | 11 ++++
>   drivers/vfio/pci/Makefile              |  1 +
>   drivers/vfio/pci/vfio_pci.c            | 12 ++++-
>   drivers/vfio/pci/vfio_pci_liveupdate.c | 69 ++++++++++++++++++++++++++
>   drivers/vfio/pci/vfio_pci_priv.h       | 14 ++++++
>   include/linux/kho/abi/vfio_pci.h       | 28 +++++++++++
>   7 files changed, 135 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/vfio/pci/vfio_pci_liveupdate.c
>   create mode 100644 include/linux/kho/abi/vfio_pci.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 96ea84948d76..a16a7ecc67a4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -27685,6 +27685,7 @@ F:	Documentation/ABI/testing/debugfs-vfio
>   F:	Documentation/ABI/testing/sysfs-devices-vfio-dev
>   F:	Documentation/driver-api/vfio.rst
>   F:	drivers/vfio/
> +F:	include/linux/kho/abi/vfio_pci.h
>   F:	include/linux/vfio.h
>   F:	include/linux/vfio_pci_core.h
>   F:	include/uapi/linux/vfio.h
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 1e82b44bda1a..8f087f7b58c3 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -58,6 +58,17 @@ config VFIO_PCI_ZDEV_KVM
>   config VFIO_PCI_DMABUF
>   	def_bool y if VFIO_PCI_CORE && PCI_P2PDMA && DMA_SHARED_BUFFER
>   
> +config VFIO_PCI_LIVEUPDATE
> +	bool "VFIO PCI support for Live Update (EXPERIMENTAL)"
> +	depends on VFIO_PCI && PCI_LIVEUPDATE
> +	help
> +	  Support for preserving devices bound to vfio-pci across a Live
> +	  Update. This option should only be enabled by developers working on
> +	  implementing this support. Once enough support has landed in the
> +	  kernel, this option will no longer be marked EXPERIMENTAL.
> +
> +	  If you don't know what to do here, say N.
> +
>   source "drivers/vfio/pci/mlx5/Kconfig"
>   
>   source "drivers/vfio/pci/hisilicon/Kconfig"
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index e0a0757dd1d2..f462df61edb9 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -7,6 +7,7 @@ obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
>   
>   vfio-pci-y := vfio_pci.o
>   vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
> +vfio-pci-$(CONFIG_VFIO_PCI_LIVEUPDATE) += vfio_pci_liveupdate.o
>   obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
>   
>   obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 0c771064c0b8..41dcbe4ace67 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -170,6 +170,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	ret = vfio_pci_core_register_device(vdev);
>   	if (ret)
>   		goto out_put_vdev;
> +

a meaningless line here.

>   	return 0;
>   
>   out_put_vdev:
> @@ -264,10 +265,14 @@ static int __init vfio_pci_init(void)
>   
>   	vfio_pci_core_set_params(nointxmask, is_disable_vga, disable_idle_d3);
>   
> +	ret = vfio_pci_liveupdate_init();
> +	if (ret)
> +		return ret;
> +
>   	/* Register and scan for devices */
>   	ret = pci_register_driver(&vfio_pci_driver);
>   	if (ret)
> -		return ret;
> +		goto err_liveupdate_cleanup;
>   
>   	vfio_pci_fill_ids();
>   
> @@ -275,12 +280,17 @@ static int __init vfio_pci_init(void)
>   		pr_warn("device denylist disabled.\n");
>   
>   	return 0;
> +
> +err_liveupdate_cleanup:
> +	vfio_pci_liveupdate_cleanup();
> +	return ret;
>   }
>   module_init(vfio_pci_init);
>   
>   static void __exit vfio_pci_cleanup(void)
>   {
>   	pci_unregister_driver(&vfio_pci_driver);
> +	vfio_pci_liveupdate_cleanup();
>   }
>   module_exit(vfio_pci_cleanup);
>   
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> new file mode 100644
> index 000000000000..5ea5af46b159
> --- /dev/null
> +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> @@ -0,0 +1,69 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * Copyright (c) 2026, Google LLC.
> + * Vipin Sharma <vipinsh@google.com>
> + * David Matlack <dmatlack@google.com>
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/kho/abi/vfio_pci.h>
> +#include <linux/liveupdate.h>
> +#include <linux/errno.h>
> +
> +#include "vfio_pci_priv.h"
> +
> +static bool vfio_pci_liveupdate_can_preserve(struct liveupdate_file_handler *handler,
> +					     struct file *file)
> +{
> +	return false;
> +}
> +
> +static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
> +{
> +}
> +
> +static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
> +{
> +}
> +
> +static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
> +	.can_preserve = vfio_pci_liveupdate_can_preserve,
> +	.preserve = vfio_pci_liveupdate_preserve,
> +	.unpreserve = vfio_pci_liveupdate_unpreserve,
> +	.retrieve = vfio_pci_liveupdate_retrieve,
> +	.finish = vfio_pci_liveupdate_finish,
> +	.owner = THIS_MODULE,
> +};
> +
> +static struct liveupdate_file_handler vfio_pci_liveupdate_fh = {
> +	.ops = &vfio_pci_liveupdate_file_ops,
> +	.compatible = VFIO_PCI_LUO_FH_COMPATIBLE,
> +};
> +
> +int __init vfio_pci_liveupdate_init(void)
> +{
> +	int ret;
> +
> +	ret = liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> +	if (ret && ret != -EOPNOTSUPP)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +void vfio_pci_liveupdate_cleanup(void)
> +{
> +       liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
> +}
> diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
> index 27ac280f00b9..cbf46e09da30 100644
> --- a/drivers/vfio/pci/vfio_pci_priv.h
> +++ b/drivers/vfio/pci/vfio_pci_priv.h
> @@ -133,4 +133,18 @@ static inline void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev,
>   }
>   #endif
>   
> +#ifdef CONFIG_VFIO_PCI_LIVEUPDATE
> +int __init vfio_pci_liveupdate_init(void);
> +void vfio_pci_liveupdate_cleanup(void);
> +#else
> +static inline int vfio_pci_liveupdate_init(void)
> +{
> +	return 0;
> +}
> +
> +static inline void vfio_pci_liveupdate_cleanup(void)
> +{
> +}
> +#endif /* CONFIG_VFIO_PCI_LIVEUPDATE */
> +
>   #endif
> diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
> new file mode 100644
> index 000000000000..e2412b455e61
> --- /dev/null
> +++ b/include/linux/kho/abi/vfio_pci.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/*
> + * Copyright (c) 2025, Google LLC.

would be nice to update 2025 to 2026 now. :)

Regards,
Yi Liu


