Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF039C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 06:59:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84A426B03A2; Mon, 17 Aug 2026 02:59:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D3B46B03A3; Mon, 17 Aug 2026 02:59:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64EA36B03A4; Mon, 17 Aug 2026 02:59:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 228466B03A2
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:59:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F2C31206DE
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:59:26 +0000 (UTC)
X-FDA: 85109860332.07.83C5E72
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3E4B518000D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:59:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BmA27cAR;
	spf=pass (imf24.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1786949963;
	b=Mnj8h6JPo1GvkBxaGO+/+sUjdC3J17I+9i8oq7iVGy7xRqgRTQ9buw5L1gzqDrOy2Akjlu
	0h7FpqIdTd0EMstC77mzpR7nEM3IafMcyTEn1NWSi4veidHkzgtDCNnPMoJDSnQCdk70u5
	OsOMXwn7WGZCih49cJLi57+DncPue1Q=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BmA27cAR;
	spf=pass (imf24.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786949963;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j81AKbjKxOQgsz8D1wpi/1DxGB0JCFhrpNv3kGwz4Ck=;
	b=VFZwEJmaAvcsRyE03urpsxtWbCYpQIGOmEeva/PF2QblzbLxgP8QiFuVMCgHJFtaSiGPS6
	25znLIhYQBZhML/Uk2ET4lVrwQnEtCp7uFQY2vQfK4GYsQR1BiC6VdRGebnR2y0gmic7X2
	Wf/NB/mrLSv0Ck5Ly070O5SE0jhtI4A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786949962; x=1818485962;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=EJK6l3LISuPjUqenE/xtSeSNJZQAUckq3mX3fp73uvU=;
  b=BmA27cARKLhXvdfS6weuuP9d6Yq5B+IRLh2DWftow1aTisvgbmQKItVX
   HRxuofYEkIK3up1TKabnXtDKfSEeEPFV1pMCbCH9JEFhF70UdOI67CDAv
   p3how4KE//dlwiNwAKJj5b3ePh8zjeT0K1UR9UmhpuDfe11UnQYLJ/RHm
   Ng8+yHljeQkKEI5nVHHHdegj+dXOMHw00wGcEzt8kcCgJygC05z0a3Q4s
   ZTzpUm+CisLu9CetLIGCdVSDHqZ3H6K1PZxe0seB3FV47XJZlr9Cf6YyO
   UM/uQ5grWn6AUPcB8J795UBTn+h8tbeyBhnCuBTNXjEYQfJs02lIgewIp
   Q==;
X-CSE-ConnectionGUID: l4tz+a8/Rl+/LUUWqPmxlA==
X-CSE-MsgGUID: M4Dx59FwTQ2NZpUWbu14qA==
X-IronPort-AV: E=McAfee;i="6800,10657,11877"; a="86538540"
X-IronPort-AV: E=Sophos;i="6.25,228,1779174000"; 
   d="scan'208";a="86538540"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2026 23:59:21 -0700
X-CSE-ConnectionGUID: HlKbHmYtQ46/RK06fAVz2g==
X-CSE-MsgGUID: rSKv2tZqREum4nBtnYQIgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,228,1779174000"; 
   d="scan'208";a="261551020"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2026 23:59:20 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 16 Aug 2026 23:59:20 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Sun, 16 Aug 2026 23:59:20 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.33) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 16 Aug 2026 23:59:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JTzKx6iBZIct0JiLat6WuW/WnjPVl0qoubv/Tt+6Sr5xxu+blrlUbUXKl7aO9lB1JqxDmUsjEmZ8Y0MDnj4HWy5how0y5P2DusMyJipUO2kv+ZzMsMDvWVoLhSaqvHK3Oj98v9jPh4Da4d10SmsOzFYLLwG99dGeR3q9Bim0RyFYNT8n+nT2stfwjYapijELrO9y91ipMSqmBUAdkQsnpZGmPvVfGCV4affCk6jZro3vj6vMcxlGNKWDOOagDo5XC6Q9Q/e+uZAckwTlZHuzaCcZPof7Inz81U+ib+zqkozSxj3DVdF+mMfwmTw2w4Nx1dn9y9yquYhf7Ayc5PhdAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j81AKbjKxOQgsz8D1wpi/1DxGB0JCFhrpNv3kGwz4Ck=;
 b=DIORTrp64ivpYgLW7uSgrQLYR0ynN3XwyrAzcOgh1SbtUSGEvO6SjfDu1fOxlrkrV/nJ37gAyx6AVApa95Dh/lwd2FV/KXFPeotK71ycwwlcaHnseNo4KxeUn2RupZaNVonF7cTdgr8CxcT3w2/LntNkOXcOTfpt8+n3bgOIMSszqnUiMoMrxIA+32Axlzdr9JNkWtTWW0Yl0BPA+1IhPne0s5i3jukdr2NtM+qLqsRrCLcAm6d04XsS9jhKcgXDJXrwESAgsCSoL3GqpW7yPDZHqlkvbYVlVRVK94cRI6sXfOoc5LPEPpp1aRJRNBJI5zPQbFudBJhlOXFv06XtoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LVUPR11MB9589.namprd11.prod.outlook.com (2603:10b6:408:3a4::10)
 by IA1PR11MB8222.namprd11.prod.outlook.com (2603:10b6:208:44e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 06:59:16 +0000
Received: from LVUPR11MB9589.namprd11.prod.outlook.com
 ([fe80::6158:db0b:38aa:9c5a]) by LVUPR11MB9589.namprd11.prod.outlook.com
 ([fe80::6158:db0b:38aa:9c5a%4]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 06:59:15 +0000
Date: Mon, 17 Aug 2026 14:18:01 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "david@kernel.org" <david@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "steven.price@arm.com"
	<steven.price@arm.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"forkloop@google.com" <forkloop@google.com>, "tabba@google.com"
	<tabba@google.com>, "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "Vishal
 Annapurve" <vannapurve@google.com>, "willy@infradead.org"
	<willy@infradead.org>, "tglx@kernel.org" <tglx@kernel.org>,
	"wyihan@google.com" <wyihan@google.com>, "pratyush@kernel.org"
	<pratyush@kernel.org>, "aik@amd.com" <aik@amd.com>, "jmattson@google.com"
	<jmattson@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"rientjes@google.com" <rientjes@google.com>, "andrew.jones@linux.dev"
	<andrew.jones@linux.dev>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "chrisl@kernel.org" <chrisl@kernel.org>,
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
	"mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
	"oupton@kernel.org" <oupton@kernel.org>, "mhiramat@kernel.org"
	<mhiramat@kernel.org>, "baohua@kernel.org" <baohua@kernel.org>,
	"tarunsahu@google.com" <tarunsahu@google.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jthoughton@google.com"
	<jthoughton@google.com>, "yuanchu@google.com" <yuanchu@google.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "shikemeng@huaweicloud.com"
	<shikemeng@huaweicloud.com>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "shivankg@amd.com"
	<shivankg@amd.com>, "shuah@kernel.org" <shuah@kernel.org>,
	"youngjun.park@lge.com" <youngjun.park@lge.com>, "kasong@tencent.com"
	<kasong@tencent.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "vbabka@kernel.org"
	<vbabka@kernel.org>, "weixugc@google.com" <weixugc@google.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"qperret@google.com" <qperret@google.com>, "brauner@kernel.org"
	<brauner@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "baoquan.he@linux.dev"
	<baoquan.he@linux.dev>, "corbet@lwn.net" <corbet@lwn.net>,
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "liam@infradead.org"
	<liam@infradead.org>, "axelrasmussen@google.com" <axelrasmussen@google.com>,
	"kas@kernel.org" <kas@kernel.org>, "qi.zheng@linux.dev" <qi.zheng@linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
Message-ID: <aoKnmW9St5zCoTD3@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <anj2bPrGqzZgZWMF@yzhao56-desk.sh.intel.com>
 <CAEvNRgFzRj_=GVy8T4P8ehhQjYomYxkngzwtKBF0iEL0Cv6fuQ@mail.gmail.com>
 <anp1I64K0KeyQuyo@yzhao56-desk.sh.intel.com>
 <CAEvNRgFWcndQKJE_q+ZATFZEMYd=6uRLygozLvg7L77bPX0cEQ@mail.gmail.com>
 <anqqKH6kuwpvuwp9@yzhao56-desk.sh.intel.com>
 <CAEvNRgGWDY_fxbyBM-5sMdYMevMe0HzVP9kbC1cCGLE_dV=_Gw@mail.gmail.com>
 <a71d4fccdffd1f6a12332ddd18fa812542ea2118.camel@intel.com>
 <CAEvNRgHxda6XK_XqWaqqVnA7oW=Fhp_C5gF4vNcL+-HfwfXMqQ@mail.gmail.com>
 <0c80b9b0e13e3ab2cbe4f9eaf4a02ebba25a7001.camel@intel.com>
 <an5RJYTwlYeym--O@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <an5RJYTwlYeym--O@google.com>
X-ClientProxiedBy: TPYP295CA0041.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:7::19) To SAVPR11MB9573.namprd11.prod.outlook.com
 (2603:10b6:806:4e6::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LVUPR11MB9589:EE_|IA1PR11MB8222:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dc017c1-126e-46e5-1d47-08defc2d0c52
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|6133799003|4143699003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: EagehFdTKHrpjzdW8Prlw6OjtW2EzBHgXa9y4XVmJE+nmpNXAd4Iop9AAfkpeknsCNORPhDZqoPSLoWQrZNLxIcZST760OTojig0nCZICUeGmQkE0SvSEYZUwVmlHBbcY14blWVS+LoWrxscupCYeQwU4wf52gnTLYplLRLEo1H7iHz9w/qbalZIZTsIKlqyDuJITqh+QrD0A4U+fZTlbH+1g0qUT9EK1uZJsdu7/xH996G8NrFY3zTBCuJbcwMjWQChLOeT6ao8HNR8G0JVsY6FcJHqcCOc4Kxx9KccLM3AEupX1hM8P6F0LNnbpgtLj1Pyk2bMgzamZDI5H6S5TGoxCrHECLWsoIO+rWWIbgFqMVVDRZ8TwnrmLfbyP4BsPPlMs3HvC2rVqnCpXX0A31AAMcbjLc2y7VVwwWAz00/mBz+AGSbgJ5JlllZ2hevEqqIKHPf6TkuuOzELZskRifgAI7BqKlSUpWHwmygHsMVBa65dXxJ/TkzRoOIyZhVNBcEPHB8fe5aPeO3DtUSvLrnZJvB+8I9yf7Mq8KR3a5ugwnYI2UxVR7uh6whOCP9lMewTFTb9+6RwGMPs6Q40Id3rOB/N8LiUznsrr80gsDyjsJ4WFo+hQMW6/3X863526j/XSKLvC40nSt6Z4J+v4Zb3vGhMdyeB/XmjCWMDE78=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LVUPR11MB9589.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(6133799003)(4143699003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qmGD08XbntfYp4ZwdFpmzf8QrOUKLl7IDbRBs8EcdSj/kHQZDNnigaFVk0Tc?=
 =?us-ascii?Q?6Ao1Wxvw6iTxvAh8Sd3/VNR9QrmnVc/8s7jWJn0DU9Jmw0+Ps3vJFXSvzXEd?=
 =?us-ascii?Q?18mqvop0aNjNpfU/67jF2Zr5u4g9dciYKwz7hp1NBNekV6b/+OAYb+/pXvjm?=
 =?us-ascii?Q?iB7wHSBamk2S0yKXSqtykTzMKtFP5rUx1Cip4OGW1wYA6z+xx4WqZhx0aXT4?=
 =?us-ascii?Q?b3j9J0uF0FreEv9os1BiMFa12yoWZmDsR9G33krKLeqhfxObAGaGOb1zR2e+?=
 =?us-ascii?Q?7lt1Kk1UnME3RpbGUQUwTa0ds0GS5zp1UYleK9UdBv1bEFnSr6FvAqxRUJo7?=
 =?us-ascii?Q?sc3vqDUyrgu8V/pDuxqkfalOWecedWwfcZW7ZQLAlIGJlZS6Hi+gt1V3DBc6?=
 =?us-ascii?Q?mFyOuzehaaD/3FX6UYCGcD97Fxnk9QrtB1YqoObvjI1x97NUIBhxDSbgf/F+?=
 =?us-ascii?Q?dOOHrhjpzo3P1dovdV35xIdothBhNZIq0OcjEPb0Ie0iDDZ0zIF2aY9FKi6q?=
 =?us-ascii?Q?r1p4rTcYZiP1X7FJBAGqgoM2/rjy3emoCOX6Vk1afkn7E6BxPHdOxazIVK0M?=
 =?us-ascii?Q?T5rhgybb3vRI+NQ1fQnUl2sugpp/ckS4B+jj9JfMe8gDaLTNe5ni1JEhYIDh?=
 =?us-ascii?Q?39SxnVu4lumz1K6sJmEMhUPAwss2IbdsqQblx/XAu7fve2SKG2+4RKdRv0Pw?=
 =?us-ascii?Q?IR1rBm/EtqpcfjqYJ6AtelH7QavoSOkV3MucSr15ncqPCinBJjpdYspii1B4?=
 =?us-ascii?Q?FPKPh3Vs3Ns+yLQN6g3ohR/h6dMJTZ5VHeoLymHIXQluuWg3yLtraD8NuCD4?=
 =?us-ascii?Q?e67XXJ7pniiZ2bD+LkGpabfUssq032Y85H/wUMHieI+wCdicVJKlHmEjWSrf?=
 =?us-ascii?Q?uoVUCh7uLh5g6Uw5ZkI4mrxe7lD4WjT7Zh0bhqEl74P+JOs/VyyO6kSaWC+c?=
 =?us-ascii?Q?+46ikGApXEbyEYVpjJR897jPELbxd5OmvZ8SnAb/9URIshVBBQNxRaYZKR2T?=
 =?us-ascii?Q?OLy5+Ds3bwSSNYlaxyZ4jit3WRQ+jPGohBQA0DA+Pqx6JP8Ppn+99CrrD9u5?=
 =?us-ascii?Q?UjsxQ185vVWAgnoU5LbvKu/TqkRUwJiJ93AuitHBtIvSVzd3/0vckI0rIxq4?=
 =?us-ascii?Q?zupQQ4fkc40ezbZUcC4eL2gnh8SsiYzvBC8L0mKqdcR807cwLFNkIbeL/YlX?=
 =?us-ascii?Q?Le0jByw9VRcZjWuSQFkFl4WhfJdWlDtKk67debMPv2TSuD0uYqRHPXf6h9IJ?=
 =?us-ascii?Q?7O82nWXoLHU4QnYPh0ackDR5KbaKW7Ved1WriqJmWF6NImpLFM80Mr0ct+C1?=
 =?us-ascii?Q?kyP/EDLITYOqwsYHLucJfDOekCWc4CIJNVFWkFUE6ppe7Ce38FPdQGTg5TUI?=
 =?us-ascii?Q?/FF4pBLK1eaNWsr0ejMRFFX6VAVdA0Sw1wNN5fGR277KVVl6GwLZRzYUSRNc?=
 =?us-ascii?Q?uQ5MzBaSc+SMNxILg7JcQq025aurgJeNN5mNZ2WAXfHXE11w6gBZvl3dA6zN?=
 =?us-ascii?Q?6lU5MAnlOTKtoq9SS8+lWawgJDPqGf1RmOyqRgs45C+bTZyFYSuH85oEmwLi?=
 =?us-ascii?Q?2ox2Ty3dR8euZJXHSrPevGGB9ssJ47cogN+h93uABIN69+CLhQ6Ynx64Acqm?=
 =?us-ascii?Q?00lNgkhxgPPjGFL+5ULWOdfWT+2dT8ITahWULeennyJ7qrUvQYdtgXIySLDx?=
 =?us-ascii?Q?PPTh6OA22xI67FMKIAR4jAMGPjdca2jxv2Z1QyB1/REqNJrmsfOj7ms8D9EB?=
 =?us-ascii?Q?s459QFUoQg=3D=3D?=
X-Exchange-RoutingPolicyChecked: OZ1HE3Z+dQbIuNaUWhzWAad85V5/hKbUVzq5+/UWYA46UioJbCI+/BPgQ4Aq6jj2K6M8PjuoF7rcF+zGDykK8DreeeQ7MbG9w+GCsnitkOoDOmKZqdET7y3etv6CIErZMoJArOge+aBNdKhvdGnEDbefYDTaAW2mqak2f+WW2TkoPty/o/f6pY1x2z5sQi71uIbimQSRBDILnm0qNd+Q2rpdz2Lq/F4dHRRUpffxwMjE3X7oFcDsQns4/T8KSQ0KlK/AQhwKh1ImHVwF8Z48LOv02pZzSDqJulTViTyLu/i64d/cCjnW5EAhumCFDwTSflvJ4LcliYlFG99c1Hl2Tw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dc017c1-126e-46e5-1d47-08defc2d0c52
X-MS-Exchange-CrossTenant-AuthSource: SAVPR11MB9573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 06:59:15.2592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GddBuUVefBXLwpDhHDHGJKvlSFeY0bW0rnzILqsCsOhcRdfu2uof7XhJfftHKP/krFoT8GZCxg69LCMoDm4S4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8222
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 3E4B518000D
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: eddmmk5hket1uxigjpwe1womsyrxe7oe
X-HE-Tag: 1786949962-727639
X-HE-Meta: U2FsdGVkX18SnXnQff7yuJHcPg6A3QgtVRRSzFRQlDXou862G5wsD2V97iSE0q9uayJMgUapYRTVnlRaDRpHpg7wobbDD6HroJbMWUToOKkfT6I4S5CFRAI9j7ks1SJDy+Ily6R6MnajBnbSS23Wt25FCBt66HaxE7KNRpX7GInVgfhWuooxbuEOvBf/ajgdEsH9QP+gdnfAyZbMIrFOOOWUgWtnYGYRjzjoWeqMRVO8/aqDODe4CLFdxFbPX4syW6k/ezts8DQ2Vtt36cpL0fCe6nai4Ym0/8w2hDoEmZBQLzk7nQKnGM/Adl7KedDDHetyUIqKvs0RVU71A5PfBsJRKmaT8mwZQ0Aj3Mapc6z6BKSncM0P1bxHHwYePMex9/4aNlJRwDUd5hO7H1TxMHfhv8fLmmILN2N6EidKSTBlRkQgLMhQD8QjDADdkF81sPy9fNHQoOsIceAKRw3Lnp6x1AVUW45fQsgWkI4qbnb26TfaoTgB/C1flASuNDm750fSLR5EwYzAI5lLC6oHM+ccG0GeVcgKH5nrFuCDerV/6BAI1WEULGPLueYlz2Qr4Q8BiYPBF1p/5ZVXs4pb6l8qSaYxSZS5Mqna88IKSSRdzJK1WB0P04oAa92/sACMxF2HTqlJNye9ynJo4GXy13qXzpRBJ72Y3joCe77O0UVppu01IIxTcS6Oe8UcVp6Ff6vFbHu0Yw+rYpFzu7KkVbJZaAzqYLTTtciED2Y0gTjbaiq7qiZekvT+znn7myxBOkNo6V1+jt9Tz/DUv7WAAzfDkRcwPk5GBengj0Gv0Fe8ZquzpLwk1+5xphKi7Yp8VV81zI8i501pkvuNsGYRQ45kDEWVBQ9j2HdpFhxbooO89IAu+DvX78N2MaI4vyMHIRpb3ya+cVW5SvUhUbpiN6MdNO5DlPKrdpCsTAC15/j+CV7tmVC1SAxD+891sVJcj0MW3Gtr1m4r4eRo0px
 Lvk6q7wD
 BSrnJ52fOjKJznEE8nwbbaPCNa88wNX7GtkDxUctSEQIeIqhUlzUkBrsrwjqwEUQUasr6lapBk/XQytcaInf+sSMEq1Q9ISHkEMUT41cIY94s3/k5Qwn1WAqd2IWCvcTIN0B8iNcYgG7FTWRB23rjZ2rAZ3OzAVnuJ2ggrwxLE9FfH/SQMCNoeBOPZmWspSMda4I1FDWB5IV027hOf3XPJUdn0Hh3JDEVfudWP40dGQMproRpQiPiqhygAJ+Nm6TLDfhTQKvS46tnQ1M70J5wlfKbhmmGTD3o9p+/M+COklYwx8B7oWPw1XYgS/w6m8x/NsEOdWcJd0yFw2jDoKU1NfjuS+LXVGKFA6/mmHHL0YBz/TFOPdvO/Dz2dCOkJjJPCL6C5MB7u80a7jo1Wr1smZ6ms7BM7ql0TkyGYhmYiVQ3BAltcugaFqHc+/NOyKUIcmXsaMmQ1o2SKxKEXl/tMhS7e8Md1IximS/vU0Gv5o6d4B3vPoSXtvPTCH7l61DDL0IE+accc9E1ml/Ix4w+Q/KWJ/8Dkuc8DgyBodm2XPpEeVHDG5PMwW2kzxy5qly/1gEHfF1ojWr3w02/1E4B8Xh0lU0sqrX6XSFUV5e6op74tESz/YcRxCBHg5a1eJXQl7GfxzSDEkWu6Qck8yZimIrfADkvrNYpLKp0RjvIfTxfiWYtmvGHKzsNyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 04:20:05PM -0700, Sean Christopherson wrote:
> On Thu, Aug 13, 2026, Rick P Edgecombe wrote:
> > On Thu, 2026-08-13 at 11:51 -0700, Ackerley Tng wrote:
> > > "Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:
> > > 
> > > > On Tue, 2026-08-11 at 10:35 -0700, Ackerley Tng wrote:
> > > > > > > Would like to see what Sean thinks of this. Either way, is it okay to
> > > > > > > follow up after conversions lands?
> > > > > > Let's see what Sean thinks of this :)
> > > > > > I raised this because the issue was encountered by one TDX's stress
> > > > > > selftest.
> > > > > 
> > > > > Which stress selftest is this? I can try running this on my side too.
> > > > 
> > > > We have some selftests that are built on the basic TDX selftests. One just
> > > > hammers the MMU stuff with a bunch of zaps and also weird stuff from the guest.
> > > > It was eventually too much work to try to keep the internal enhancements rebased
> > > 
> > > Would like all the comments we can get on TDX selftests v14 [1]!
> > 
> > I think we had a few. Let me try to round up some more folks.
> > 
> > > 
> > > > nicely so we actually just run an old branch's TDX selftests against newer
> > > > kernels. So the branch is a bit of a pile, and not really suitable for sharing.
> > > > We plan to clean it and upstream it when the path clears. So it would really
> > > > help to get those basic ones upstream. We remain happy to help, so please let us
> > > > know.
> > > 
> > > I guess at this point I'm hoping y'all and Sean are okay that this
> > > conversions series merges, and we let this stress test failure be
> > > handled later. I'll be around to fix things :)
> > > 
> > > I'd say the line of sight to fixing this would be when the KVM MMU only
> > > gets PFNs (and no pages at all) from guest_memfd.
> > 
> > Hmm, I think we shouldn't upstream a uABI that we don't have line of sight to
> > making robust. So it would be good to settle this thread at least.
> 
> This isn't uABI.  You're talking about hitting a race condition between one task
Hmm. Perhaps it is not a uABI issue, since users are allowed to retry. However,
it is hard to convince me that it makes sense to require users to retry a
private-to-shared conversion before a GFN has ever been mapped, given that a
retry is not required when the GFN is currently in use by the guest.

> converting a page and another faulting in the same page.  An NMI, SMI, or IRQ at
> just the right/wrong time, especially on a preemptible kernel, could lead to the
> same test failures, even if KVM drops the refcount "immediately".
Could you elaborate on how an NMI, SMI, or IRQ at just the right/wrong time
could lead to the same test failures?

Do you mean they can cause a fault to be retried? Our test failure is an EAGAIN
returned from a private-to-shared conversion before the page has even been
mapped as private.

> That said, I am 100% in favor of not handing the caller a struct page.  Now that
> the TDX APIs no longer require one, it's more than feasible.  But, we absolutely
> shouldn't just nullify the pointer, we should drop the param entirely.  Not just
> because it's cleaner, but because it also forces an audit of the callers to see
> if they subtly require a refcount (spoiler alert).
Yeah, I also considered dropping the param entirely and was terrified by the
lines of changes :)

If you are in favor of not handing the caller a struct page, the following
changes should also be required on top of your change.

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8ef16ccf26ce..d5aa197d2cbf 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1613,7 +1613,6 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
 	unsigned long mmu_seq;
-	struct page *page;
 	struct kvm *kvm = s2fd->vcpu->kvm;
 	void *memcache = NULL;
 	kvm_pfn_t pfn;
@@ -1681,7 +1680,6 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	}
 
 out_unlock:
-	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
 	kvm_fault_unlock(kvm);
 
 	if ((prot & KVM_PGTABLE_PROT_W) && !ret)
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index c982a6454fc9..43523bb17621 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1360,7 +1360,7 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 	bool write_fault, writable;
 	unsigned long mmu_seq;
 	struct vncr_tlb *vt;
-	struct page *page;
+	struct page *page = NULL;
 	u64 va, pfn, gfn;
 	int ret;
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3d3eb8387cd0..c5ba2c8cad74 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4017,7 +4017,6 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	struct kvm *kvm = vcpu->kvm;
 	gfn_t gfn = gpa_to_gfn(gpa);
 	unsigned long mmu_seq;
-	struct page *page;
 	kvm_pfn_t pfn;
 
 	lockdep_assert_held(&svm->sev_es.snp_vmsa_mutex);
@@ -4077,8 +4076,6 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	else
 		svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
 	read_unlock(&kvm->mmu_lock);
-
-	kvm_release_page_clean(page);
 }
 
 /*
 
> The lone holdout at this point is sev_handle_rmp_fault(), which could end up
> PSMASH-ing a PFN that has since been freed by KVM.  Assuming holding mmu_lock
> while doing RMP operations is ok, something like the below?  Completely untested.
Tested successfully after applying the above fix and the typo correction.

@@ -5073,7 +5070,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	if (rmp_level == PG_LEVEL_4K)
 		goto out;
 
-	scoped_guard(read_lock)(&kvm->mmu_lock) {
+	scoped_guard(read_lock, &kvm->mmu_lock) {
 		if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn))
 			goto out;
 

> As for in-place conversion, this is not a blocker.
Sorry. I didn't intend to block in-place conversion.
I encountered this issue during testing, so reported it.

