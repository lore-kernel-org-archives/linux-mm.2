Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D840CC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C216D6B00AE; Wed,  1 Jul 2026 02:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9076B00AF; Wed,  1 Jul 2026 02:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC1166B00B0; Wed,  1 Jul 2026 02:21:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 79B8D6B00AE
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:21:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7BE8C1688
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:21:45 +0000 (UTC)
X-FDA: 84939211770.20.D0C9177
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf27.hostedemail.com (Postfix) with ESMTP id EE38B40008
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:21:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LvEk3lC5;
	spf=pass (imf27.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1782886902;
	b=zN8smV8JFYdUqhfb4ow8uTlnaiN7MZ5DN25ryIvSK/HzeTrcgPBxh8FvmBd80UrddamjGW
	5GFjYgE0vt0ip+3/VwWWLa2b8uUtHPedFZryJvWDTlxMLGp9YW4TUgueT5+rQvDaPjD6U1
	eQtm1M6iK+iB3iOmWyB+X285GovNM/I=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782886902;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yTC+9gNE+FmiaFqMdLbsdgatWXyJwBKNSZDjnjS+5+4=;
	b=FcWIweGEMKxT91EeBi8DSFhCl2/zMs5PV6DdD/RenH2amL1k9311LEE6Yy1Pleb5n704DQ
	2T4DK0AI+O+jMaaO7DsPRW+Izt5dbwjV0N4kGBzPLzv9NrjeclWStT08tNaDopovcGAuh2
	04QhmhfvOQzs3ePAeM0v3qlo+Vzf/mI=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LvEk3lC5;
	spf=pass (imf27.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782886901; x=1814422901;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=0v6/A9exmoiLbAUZFuPt7tSPf9Sc/HgDu6SYRfco4bQ=;
  b=LvEk3lC5v65tSe2oMDWkZ1jE8kLCEgj54boywiKRkrjFeyWGmkW9a+yr
   U+qXo62u+zZHqcNTOEjkSd5+XeLb9WQLMzkpHeF8trevXfoitjq3MWuaM
   ojzpWm67q3qdzW2ErLmSyT7EELO9pDWoEnW+3JZH19C6U+GR4m1z3t+oB
   Y1EHwipB2uLdS6isTLdnuAzxUhHIhfW7xKJEbk1Y1/wEKlP0RGHD+NWkj
   ZflCR+E+kE7wGtmN1uiopMR4BI3Rgv3gXnOum/LrWmJgbFdFreaeeEv0+
   ynDF91q9J0ldKzqyf+nNe1MbOzDG2CFUiqfkm59sVvk3I8zcOoemX7pp+
   w==;
X-CSE-ConnectionGUID: 1CRBFW/HS/2Vy0p1EsExYw==
X-CSE-MsgGUID: AEWeHjW9Rc62kamRfPrHfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="101152952"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="101152952"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 23:21:39 -0700
X-CSE-ConnectionGUID: w2oJwlgrR8iLFTPwFHILqA==
X-CSE-MsgGUID: BGz0T9ePTauVR6V4ruR7Tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="246123222"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 23:21:39 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 30 Jun 2026 23:21:38 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 30 Jun 2026 23:21:38 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.66) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 30 Jun 2026 23:21:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E8StSzEVoOrUnbBO31oFtSQyYEJpgRgpCMjVwNn86i+9G+lxq2hkpKnjgVeVMUSaFgw8Qm/xmFTO6PLAa65zg0YTTsNS8G0jprTrarsvMp77hSZbP3fkhRJ2M9AsI4X/Q6nZCZbQ74ANPG01I6/sdWj5IbT17FDHM9C1z5bMQOEA9SfwmOl5++TTFyILP1g86ZB7Hc3HA410DBqcwBiHPrsXK9iD/vAR3ECQAqCNm55h6X1AGJwmqNQtJkdOH16RJjn5PIij1ysZuesQrndPl1CRTMbiSMbSpn2TgA2UQUPJtI7XCCmTQV2nfcZ9wSIFR3vAvJ9qU4ioz6+t++9Aeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yTC+9gNE+FmiaFqMdLbsdgatWXyJwBKNSZDjnjS+5+4=;
 b=nxcVDHBj+tUaAJ70fGfncXoHIxhjmfhYtAC9cmiM4YAI8+zzTIFpic3ZHrLWTle2w3y80144UB139zHSM+p3REitBpKOO9LgSOwU6fubi2nBXNp+F014gLqxHMkaWwwJBbg2qm9nQh167fDULNHPYwP2W6tKYSpWN54fkXHlIODzD5cfEJkL7sMOMC1r/0hAMDvnD0cLfjuBSjsWZw62mz4h5S1KAA4tR919dKlsfAM4Dksrc/TZJlPDAArpgekGfAo1ePlSXpaXiz+/JADvyiKQ/tu031h7STSPOqT25slAHC89JtnUZ02rXtHN1gZOkgjYgrSlnVF8SVSKY5uxBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7472.namprd11.prod.outlook.com (2603:10b6:510:28c::12)
 by PH7PR11MB8569.namprd11.prod.outlook.com (2603:10b6:510:304::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 1 Jul 2026
 06:21:28 +0000
Received: from PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475]) by PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475%5]) with mapi id 15.21.0181.008; Wed, 1 Jul 2026
 06:21:23 +0000
Date: Wed, 1 Jul 2026 14:21:04 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Ackerley Tng <ackerleytng@google.com>, "aik@amd.com" <aik@amd.com>,
	"andrew.jones@linux.dev" <andrew.jones@linux.dev>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "brauner@kernel.org"
	<brauner@kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "david@kernel.org" <david@kernel.org>,
	"jmattson@google.com" <jmattson@google.com>, "jthoughton@google.com"
	<jthoughton@google.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"oupton@kernel.org" <oupton@kernel.org>, "pankaj.gupta@amd.com"
	<pankaj.gupta@amd.com>, "qperret@google.com" <qperret@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "rientjes@google.com"
	<rientjes@google.com>, "shivankg@amd.com" <shivankg@amd.com>,
	"steven.price@arm.com" <steven.price@arm.com>, "tabba@google.com"
	<tabba@google.com>, "willy@infradead.org" <willy@infradead.org>,
	"wyihan@google.com" <wyihan@google.com>, "forkloop@google.com"
	<forkloop@google.com>, "pratyush@kernel.org" <pratyush@kernel.org>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "aneesh.kumar@kernel.org"
	<aneesh.kumar@kernel.org>, "liam@infradead.org" <liam@infradead.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, "Annapurve,
 Vishal" <vannapurve@google.com>, Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi
	<shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Barry Song
	<baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>, Youngjun Park
	<youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Baoquan He
	<baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka
	<vbabka@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>
Subject: Re: [PATCH v8 23/46] KVM: TDX: Make source page optional for
 KVM_TDX_INIT_MEM_REGION
Message-ID: <akSx0Bx1RKe9DCXw@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <ajxasFBzp_9KnQLq@google.com>
 <CAEvNRgG1nHipzw4=eBgwhvyXi8xYo7FQD_sy9Ax6FDf7YDu3Og@mail.gmail.com>
 <ajyRg3BwGu5dCfOn@yzhao56-desk.sh.intel.com>
 <CAEvNRgH5KOHoemnC9QOn_oK97=KeAH1XuX3ps36-pJ0Fn0aBHQ@mail.gmail.com>
 <aj3TGLGWT1kMFIVH@yzhao56-desk.sh.intel.com>
 <CAEvNRgHb6WmOha6Pct_Tn8Ucuov95L=fj5=2R9gcHfx=b2V_+A@mail.gmail.com>
 <akI9m02jgKAdi4gX@yzhao56-desk.sh.intel.com>
 <akMPZePBdwQlD74H@google.com>
 <akMoFqj/8Af2i/Al@yzhao56-desk.sh.intel.com>
 <akPEKslqAhygyjhg@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <akPEKslqAhygyjhg@google.com>
X-ClientProxiedBy: SG2P153CA0043.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::12)
 To DS0PR11MB7457.namprd11.prod.outlook.com (2603:10b6:8:140::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7472:EE_|PH7PR11MB8569:EE_
X-MS-Office365-Filtering-Correlation-Id: ea5feda6-d454-4ae1-af2d-08ded738f781
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|7416014|22082099003|18002099003|56012099006|6133799003|11063799006|5023799004|4143699003;
X-Microsoft-Antispam-Message-Info: TIBhdt14i1KOIsWl1r83x4gNKRMLEPAcrrPShwfFmwZpkZU05q83rcchMc0uj+aawyDrjf+JBD2hsjiR4w/8iMH4+HGaR8l5BM6TC8D2smhw8dv1wKBq+ifZRXxEXYhXjbx5VJE1EuHoN6WAxKslVxMOxZBmBqwLLB0K7jdmPoJ3mlGo+R7maLlf2SvVuZLfVT08u+T9BNvYsotHdSwkJeaTMrX4K3U7Ofu78CMX2YC4vbjWUPsJMftaGshouyNnKxFJMeShy2t0/wfbaaIunUgc/GjUjFVChNFFIa3JpKYkhOMBkKNaghD+FvqBaOL5gU7Ci2OcSd2+P0frxf11ikv6bsEKrYPpFq49pPCI+aGmxdmlJkY7sCCgLJx83IiyStTz445hKRx1v+ifdIjlHMO2ApcVJTfATV6Eqt4IqqqKpP2kiVLttF+N2sDSIL2Bse6XqfAJ+1sfTKVJpbpZ15SpoF5nMQGs33mpLJVlh3PBRRcY7SM/MuNrSCqaiE6+t9unAbb4LW/Lc3ke7xUmKdd1Wirp5AiWOfOxxMCZNGdkZPa8sS8QQoBPer0Ze91223v3bibVtKLQAGw8worp5UO68iU/ILSXOrfI+F5NdybFpPoTfMDH+YbbMYrT01MLw2yVvndbD6zATp3KYLElVU/20ekbRf+H9ZYMCEbqMRM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(7416014)(22082099003)(18002099003)(56012099006)(6133799003)(11063799006)(5023799004)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EP06XLeT0M1WdJ7dCuR+pZ61FhdZEu+e1wF39e7zHQ0q7N4wBS8U5BifYTGr?=
 =?us-ascii?Q?14dWcU6CNLtggzCOQC5VAwZk12Yn5QXV2Xt568l4r1JaXkTLnDzQUFmKGnqU?=
 =?us-ascii?Q?c9Xy+rNsuc5hbwAZSDC7mo3dz6Ck866lGBMvn/5la5ZuButra3XyoktMUNFQ?=
 =?us-ascii?Q?keN4YCyQJzGUY03LVwwGEC8JpSh2o+uKvZxSRlDGAvVFd1FgfUHaBLeIv3JG?=
 =?us-ascii?Q?8zfqFlhEhjJAq7+6A6xI/FTdEL3ZA56SIeEMz6bNlzZJtP3k9HUj6YRoZMSE?=
 =?us-ascii?Q?Gk7s6q0tax9Hhd4O7Jn8MEmCeJIG7arYcYQzHiOzFfjvvE8uojInFnJHhWWr?=
 =?us-ascii?Q?wTxUW2ldQtwrzzdkHrR8V2Qe40WPCpfRnxs5hVbAfT5umruurzd+jOxaTPy6?=
 =?us-ascii?Q?+jAMOk9MxEF4Ve/nYy7+trGlg8iMQMQRzDuHonD+cuTOMuk1MRtI8Gz77lBI?=
 =?us-ascii?Q?nI6h2JgEAibUTFoD2OuZ6VCoI5Q0vnF7OOQnDSbGtDY/e5mWIJzbjONKKKiS?=
 =?us-ascii?Q?UWGxmg1sNoO7+DYQdZu3Soiw8H9JLgK7b5kLZXzKiDyfPUKLGOrj5tcNOAvh?=
 =?us-ascii?Q?fFqGL3iM2OzJHMTr8Am3hTulbHZHnmu6Df+uftHKQbRsOoa1IDcfyvUqyl8q?=
 =?us-ascii?Q?BoBkYyYAZ1z9Eh6/949cNy38ae765Eml767TFGtsthLvIHUKdZYTo7CmYtoQ?=
 =?us-ascii?Q?Z+oWHZh0T0O8xgMQ9jzvFiDIhET2m8mmBJfYY5DqmoqmjaKKGXJ9PxK9RX0f?=
 =?us-ascii?Q?Yr6pegkw2WgGz0Q76XqkR603fodPYAq8784nJdaGLgsB/TvGE7TLEzpfUjn+?=
 =?us-ascii?Q?6lWXjE/BYA2J9J+8RQT5QmK/PkgzkOLrUimB/twAjohTZ+fYq2iBQ5UcpEjt?=
 =?us-ascii?Q?YWLY547DCD0xL5zE2dqfjSfFQCLOwbftUsrwBv14nLNHPHW3kSu291GNgRLi?=
 =?us-ascii?Q?oHzyxP1LxW9YI9diRMECLw290IVRcKNyqKplQpQ4EYi4QFtYNNW2jtJjdwz/?=
 =?us-ascii?Q?SLYDWbU6clbE9gIW/ZjAs28lKi5ZRjch/g5PrVeGgqyEbQgsRw8RlK535cCV?=
 =?us-ascii?Q?PiuuFG9EulrexWZhUKzYJNzTKLW7HAYMY71JEHy/tk3M8MFGg2yENDCS9apG?=
 =?us-ascii?Q?wz78zRi9snp4O3jwk2hiQ9eSX08ib7tXN0wbbE9P3gGt8KD6dGTTBxRvU3t9?=
 =?us-ascii?Q?KSZ3AUCGjQkAUXeIBD9WorUXaaNIsDeEw8eLVWgojEY6izx1uEvD87QOjLkP?=
 =?us-ascii?Q?93B2aqqmyh3VU6Y3eLneG/MbX47+bAo7utaxYTVhot5okE7+Za8yt24P4Wqb?=
 =?us-ascii?Q?m1TNMlrXrWvoYIjWt2YIR6o2jkdZ3GHFBf49fCYFbZaxlZ+Crp8u5r+MSEK7?=
 =?us-ascii?Q?Kf4fy2ivtuIR1usmDMiuw/AuQDPCQyLXd3LMFsf5x75oPAwY2674MEZdqeI+?=
 =?us-ascii?Q?d6NJXrNwRGkzM7dUS0tMJDLjrhLYANow3XnFp5pNMmNi3iOKR8Upk5xOQ81m?=
 =?us-ascii?Q?uYXfXedxHfilSV0oPn42DNcFqzPWpDyg6ylf07IIahVP6PYnDpXjMDYQAF6M?=
 =?us-ascii?Q?3ZPxS62q9byfJW33jikSgZ+puKzK5YXWoq44dUaG36fNp/1kcsvPLl4eVjWj?=
 =?us-ascii?Q?5CJa6GZnEcWbjJJJHsPKAMphwfI0bX2M+DdEPbT5SCL6G06WdAVQyTa1Yg87?=
 =?us-ascii?Q?uOrZ+h+UiMQv6kLRIUexpQSIkLp34sgvHspMwJFy67hU0nQQNa/X/X0qRrQj?=
 =?us-ascii?Q?OJB4LzkwQA=3D=3D?=
X-Exchange-RoutingPolicyChecked: IjKNy7rMZWmyxCtsy4MDpNw7wXRPcigoGAyzpwQ5KTUkDP75KacsndnXERkpvRLT0wFMLLmBr4rSFdb8E3oCTsyb+MXSh98kK/mV0FAG5xocIRHHXdldeoatyeKs3sWVjR057OhWUMl+IwNa4BgFQr+F83pRzvN4sVNvcffWLOBiwicE0lekOAfMmL78Nzy2fI3CElhfRr28j23ZI+bx9OMqZHWWStJFC3unrFmX6P68YAJSkS5AG2rhqyKO1pArlh18kBrHyCmXk0drF/IOeFVjQ/0t8c+kAz6jba4vkuvk8z6VD8tk4Pxy8VER2fcp3MBF4fk/Ky7SnSkd6/2dEA==
X-MS-Exchange-CrossTenant-Network-Message-Id: ea5feda6-d454-4ae1-af2d-08ded738f781
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7457.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 06:21:22.1480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u7A8QecHbWXhR+HeFhZ9l5w1gE/S24jhTMRXPdW4OGNPDR688kVObMlKg+IpoWvl2jsv0x7OW7vcbMzE5icpHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8569
X-OriginatorOrg: intel.com
X-Stat-Signature: mdjcmcxy6179jhbjspuxh5i9n7aoa7tt
X-Rspam-User: 
X-Rspamd-Queue-Id: EE38B40008
X-Rspamd-Server: rspam02
X-HE-Tag: 1782886900-257098
X-HE-Meta: U2FsdGVkX1+OjS1B/C5lN6UAsbKwIGU413jfuGdqJXKqUufF+yFaeA5KMGCJRp8Zrt+vpbyVjAJGDXwV27oj0bbkvjbgnaDnauNlkf6aibVqyXwJZRFfxXseq1XtMsHv5vAvCUEY4xbnrl9qJGASjkgijqJdMsUBiiMpNK0cHNLxYoSgphNqXXSOh1ZROngibZqB0IMtL0ln0v/ZWHseNs35xiBdR6zbR5uOydg3+t3ObImjWSpoMrqCJYRx39iU4wAatijltF+6Gv4WPckmG4X6mfAWhyA+shNbKT7Nvfkjo3UbkwyI+hFPiLLCpAE2Yn/l7Ta4p4ucKG3NftByILQSjuUnbjsN2mP8V8vS0oq0tMHIocofpIpxTEVNopvQQnVkx+YNoWA0r44uo0ec0Wllka/qYYO0jvpscLV8sGyoRgP7cTjXDxyqeNldGbKkPPj4RbHzMXjb14LKr3Md7vzP5TAbvQWd0zrSQNAHj3FQv+hcOasHMHgeflKPkRQiMa9wXEEmJuCfS8H5F8jzuxx+jzWlbCjozOCNaoRBAljgzzvSiOvVdtjeyMjrapalvDX2IwnPWon8zRL6ZeoJAvoBT8F2qBFb7lQbh91tKf1j2jp3ozJGxnzTZmsKkO+EQ9MEvrrNZKlFk75H5P+0ISt6ib108JrHGBMZb4+/Or+Xnns+r9h81XrUPeMw6L45gDK9cxJGLd/WBy0aBJ5RE+Jkfejh4c+JTVF5uIudNMT7XbQMn4yMR5GvDVbtYoG5inznaoKK2dTQEjPPBHnGrOXhde22445yIOAoCnYjPe6CFtZtVv7gVLcvmaL4wzjTnbIBHsu86UuaRJ1ROMpQHOb0XmWDUQ6p/RGEz70mqkHVsysWb6uoogfVm59ediE4NYDoY7YL5llLPT8lyzqy6ZdCw1gK7x1Eyps9kMNNUfFqGBz1ShXTfMVyj8XMr9FCpuzWaufnFTDC91QRyfC
 Zdq3wXkh
 3nIYecwTE4U3KEXiCLDoXQygE1k3rNtZe5wR0t3oLIUM1Bt9Xbf4EhMggcI0H5VjyBuHzXzRhTaFj3g0Arh9Qf5K1FqDLNJuprBMX6+5Rr7k0GJ3gjEc/qky6tpZkThBYbHhFOIqtHmmkA2yKCKeaj/KGFu1p6ntB6toxdb4DVJlirZgAsocdv0xA2dYNUQqaI0qbRNciyJxnpXBl0pmW85fnAqPRUvT1o/Q9NIyfoyFmhU/dcDSeYJO9Xh6tZSSf10y0h8+ZKo4AakYqTzBc1Q7uxsEE5oJxyBLYE/yn1nQe5gPU9iKl9ZwneWS1bBjP1+EoJ4z6MMfGsFjtnWvHJOyEsy4D/rD6uuJLrriTpcqAIFAx9HXiu+wSncvsHzmZe9Pq01Ln21tbX2sJldu5uyUp3tRiZ8/5OhOm7zQNaTNvRj7vdDKhnFeRQR25MWagv+WnXwgmZctXaNgg5/PVzKCvw8ckmHzNdNm6zKO/YS4fk6KQyoyRu+9QXfAlr79+hMFRawhzSZ7HEy+Vh765EtR7dZtw9kKqcO+8LGJBvI3ZAwZs4qUasU/X74BdtT6uWCZa6CNnvt7u5PBP3Tl+axl/x1pttvPmAIh5kR+pak2jnc1I4kJ9oax/fFPckMt5tczHHSC1/o3hugIzYAEUFc1DoTZhaF5NGooiKDA15p93jEawqKa6DPV4Aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 09:27:06PM +0800, Sean Christopherson wrote:
> On Tue, Jun 30, 2026, Yan Zhao wrote:
> > On Tue, Jun 30, 2026 at 08:35:49AM +0800, Sean Christopherson wrote:
> > > Gah, I thought I had sent this out this morning, long before Ackerley's response.
> > > But I got distracted by a meeting and forgot to get back to this... *sigh*
> > > 
> > > Sending what I already wrote, even though there's a lot of overlap with Ackerley's
> > > mail.
> > > 
> > > On Mon, Jun 29, 2026, Yan Zhao wrote:
> > > > On Fri, Jun 26, 2026 at 08:28:32AM -0700, Ackerley Tng wrote:
> > > > > Yan Zhao <yan.y.zhao@intel.com> writes:
> > > > > > But if a user configures 0 uaddr as valid, writes to it, and then passes 0 as
> > > > > > source_addr(not from gmem), I'm not sure if it's good for the kernel to silently
> > > > > > treat 0 uaddr as an identifier for in-place copy from the private PFN in gmem.
> > > > > >
> > > > > 
> > > > > I'd say the original uAPI perhaps just didn't document 0 as an
> > > > > unsupported uaddr. Given that commit 2a62345b3052 already merged, uAPI
> > > > > was perhaps accidentally changed and no customer complained, I think we
> > > > > can move forward with 0 as an invalid src_address? I wouldn't think
> > > > > anyone relies on 0 intentionally being a valid address.
> > > > > 
> > > > > I could document that, if it helps?
> > > > What about just documenting that 0 is an unsupported uaddr which will be
> > > > re-purposed as an indicator to use the target pfn as the source, regardless of
> > > > whether gmem_in_place_conversion is true? i.e.,
> > > > 
> > > > if (!src_page) 
> > > > 	src_page = pfn_to_page(pfn);
> > > 
> > > Because KVM can't generally use the target page as the source without in-place
> > > conversion, it's not supported today, and out-of-place conversion is being
> > > deprecated.
> > By "out-of-place conversion", do you mean using per-VM memory attribute
> > conversion?
> 
> Yep, I couldn't come up with a better description.
> 
> > > > I don't get why the two scenarios should be treated differently:
> > > > 1. gmem_in_place_conversion==true, shared memory is not from gmem 
> > > > 2. gmem_in_place_conversion==false, shared memory is not from gmem
> > > > 
> > > > In both case, a 0 uaddr could be mapped to a valid page not from gmem.
> > > 
> > > That's immaterial.  KVM's ABI (that we're solidifying) is that an address of '0'
> > > for the source means NULL.  The fact that userspace could have a valid mapping
> > > at virtual address '0' is irrelevant.
> > So, I'm wondering if we can document that 0 uaddr could always mean using target
> > PFN.
> 
> I would document it as saying "no source page", and then state that a source page
> is required if in-place conversion isn't enabled/supported/allowed.
Ok.

> > i.e., for both scenarios 1 and 2, al long as 0 uaddr is specified, we always
> > use target PFN as source for in-place add.
> > 
> > > Again, just because something is technically possible doesn't mean it needs to
> > > be supported by every piece of KVM's uAPI.
> > > 
> > > > So why not update the uAPI to handle both cases consistently? :)
> > > 
> > > Because retroactively adding support for out-of-place conversion is pointless
> > > (requires a userspace update for a feature that's being deprecated), KVM can't
> > > generally support using the source for out-of-place conversion (it's effectively
> > > an obscure zero-page optimization), and IMO rejecting the out-of-place conversion
> > > scenario is valuable for KVM developers, e.g. to help newcomers understand what
> > > exactly is and isn't possible.
> > Ok. You mean per-VM memory attribute is deprecating, and source page from !gmem
> > backend is also deprecating, so we don't want to change uAPI for scenarios under
> > gmem_in_place_conversion==false. Right?
> 
> Right.
> 
> > 
> > > Side topic, isn't TDX broken if target page has already been added to the TD?
> > > IIUC, kvm_tdp_mmu_map_private_pfn() will be a glorified nop due to the page
> > > already having a valid S-EPT mapping, and so KVM will incorrectly allow a double
> > Not sure if my understand out-of-place conversion correctly.
> > Given target PFNs and GFNs are not duplicated, what would cause double add? :)
> 
> I was working through what would happen if userspace did KVM_TDX_INIT_MEM_REGION
> on the same target page multiple times.
Oh. To have KVM_TDX_INIT_MEM_REGION on the same target page multiple times, the
user needs to invoke KVM_TDX_INIT_MEM_REGION on the same GPA multiple times.
In that case, yes, kvm_tdp_mmu_map_private_pfn() will return -EIO.

> > 
> > > add.  Ahhh, no, because KVM will return RET_PF_SPURIOUS and
> > > kvm_tdp_mmu_map_private_pfn() will then return -EIO.
> > My asking was if we could document uaddr always means using target PFN, since
> > TDX's in-place add does not rely on gmem in-place conversion.
> 
> Yeah, I was on a tangent, ignore everything from "Side topic" on.
> 

