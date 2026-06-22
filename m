Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16816CDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 07:38:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E10736B0088; Mon, 22 Jun 2026 03:38:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC28B6B008A; Mon, 22 Jun 2026 03:38:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C898A6B008C; Mon, 22 Jun 2026 03:38:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 913126B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:38:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DF2E88E414
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 07:38:11 +0000 (UTC)
X-FDA: 84906745182.01.A048F34
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8E98240004
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 07:38:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Xs/G/eEC";
	spf=pass (imf12.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1782113888;
	b=4MFdkGK6NIgYDyhvh8a2L1vzIQKbxBVZryf/3oEbHJDW5XBymBShD3eOfpEsGWsfIHBzLu
	8OlQe2r20fMZ1M0GQBaLw87ePJ/IGoIjYh5mVbY39e0t8+3vJ0qROd0w+FUSkaJVO+dbV2
	yIDKJqhr4sXBu44z3M7MDbR7iWgHaF0=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Xs/G/eEC";
	spf=pass (imf12.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782113888;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+R5DcmKuxoIDxv7Il5so+Pv29UG5Oc785P2ER4773iE=;
	b=AYsV2wYQy28wg4xBTe3oU/FXZLPQMcv1/jmMcvCoAVBn9hfk/y6IIWoxg2TR+dYB0CpU1K
	F/k/2ArE7iRMAcAzLIrlMbSXokrs9IQvG4maatreq101tzmnMrW2RVI7KDrmQWqmWW//sR
	+anOa55YjxB14XP7PF4LpGQF9AO9ltc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782113888; x=1813649888;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=qFbbKFYoc55/JlPQ4j6/1v4h+UPhgns5zQvtovB3iQg=;
  b=Xs/G/eECNkRyb9kkkydV7sCxOVsObywnaRkiJoqdCL5m7rKCxrlC9B6h
   bmAa7kHNtKSuFt9am9k+jk51JLxoFDgK8uJjvYLdh/IT/kvkDhxK26cCl
   xwbpbhYcfgg3npqLuxqYS5CK+DumJtc/CB67/O8GMjxDLYx5o+pQX+98b
   TJZ+rhtjk95TGYXq30jTl0jCCagfhlyEaS9or8+eumrDDYJhkR8LNAMbI
   SNucSt5Tsf8+cbOuxLgyv49sY9gHn1q0z/wtaCwWmLC6TOrZrCNa6HlNI
   Qel4qxA7zlHoiSL9wREsVnBqvZxNxdQwMA+MnEgAdSx6rC8lotqTJ2fwB
   Q==;
X-CSE-ConnectionGUID: V5Xbx2r8Th+lHIRFiIFaDA==
X-CSE-MsgGUID: Vps2escuT0qRAY/26xYkLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11824"; a="108382836"
X-IronPort-AV: E=Sophos;i="6.24,218,1774335600"; 
   d="scan'208";a="108382836"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 00:38:05 -0700
X-CSE-ConnectionGUID: 1nqvL/UoQt2YcbLSNGg30Q==
X-CSE-MsgGUID: CT9dGpeFR62sdAu4REB5LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,218,1774335600"; 
   d="scan'208";a="246225385"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 00:38:03 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 22 Jun 2026 00:38:02 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 22 Jun 2026 00:38:02 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.57) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 22 Jun 2026 00:38:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vM/RYdgr4IeZpGJz2IVAaCsrJ9eVXXBawnwIkFVu+0dx/+JT/Cf2aaTGltuehDH1OicagVRL+5LZVP7a4uh2gLjxgO+IbBwglNEjGzyaepJuCr1WphJyugjN0tvMBdtBa4Z3zleHvV9v2TdknPZy+GEyqqX5XGazWAfX90dSrsk+9fQrT655qKqXnmt2+Dnjh3IPlmaSgJPRC/IK8NXpDgBgbW+yQWQBSW1MWIXgqr08RekCyQ8T5OC9EoL++haWTeKA3xh8KrPobjHS2vRAFGiFH5fmrjcxzkivxPdliRwlfiGllXy4WWseiApjmwonAJ332+7Yjpdjo7zsrvNmbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+R5DcmKuxoIDxv7Il5so+Pv29UG5Oc785P2ER4773iE=;
 b=I2a7vyc3JaUhDVQYxLMnOsLCI8rAsIl5uZlm2qIOkAcuyayAV4Ir9/9vc/P0lkhxKbax7EShnD8vhQ8Ps8xVqkNdx5vYEV1AzVwZ2sT3tjfqOHottO6/BKC8BmiFgbephVCFHKEDJI8N7jFrrTe95kbs13wTDOtMtqrdI3KogDNtwf5kflZmyOfuPLMKvQCXabVkTd9OF4A12EtwIqz/PudViXRvZsluUUOtsk3oq0qoEPcZOnffoT/+pvE6mFq6a4X1BGXra3v0+aT/ubsd27ZtMU1LdjRO6s/txGsR98fqrxT2Lksk+A6ff2ApXVJNxR1AS+hkz/5B+ihhOl7prw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7472.namprd11.prod.outlook.com (2603:10b6:510:28c::12)
 by SJ2PR11MB7517.namprd11.prod.outlook.com (2603:10b6:a03:4cb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.21; Mon, 22 Jun
 2026 07:37:58 +0000
Received: from PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475]) by PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475%5]) with mapi id 15.21.0139.018; Mon, 22 Jun 2026
 07:37:58 +0000
Date: Mon, 22 Jun 2026 14:57:22 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: <ackerleytng@google.com>
CC: <aik@amd.com>, <andrew.jones@linux.dev>, <binbin.wu@linux.intel.com>,
	<brauner@kernel.org>, <chao.p.peng@linux.intel.com>, <david@kernel.org>,
	<jmattson@google.com>, <jthoughton@google.com>, <michael.roth@amd.com>,
	<oupton@kernel.org>, <pankaj.gupta@amd.com>, <qperret@google.com>,
	<rick.p.edgecombe@intel.com>, <rientjes@google.com>, <shivankg@amd.com>,
	<steven.price@arm.com>, <tabba@google.com>, <willy@infradead.org>,
	<wyihan@google.com>, <forkloop@google.com>, <pratyush@kernel.org>,
	<suzuki.poulose@arm.com>, <aneesh.kumar@kernel.org>, <liam@infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt
	<rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, Jonathan Corbet
	<corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan
	<shuah@kernel.org>, "Vishal Annapurve" <vannapurve@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song
	<kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
	<nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, Axel Rasmussen
	<axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
	<weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, Qi Zheng
	<qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau
	<kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe
	<jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-coco@lists.linux.dev>
Subject: Re: [PATCH v8 23/46] KVM: TDX: Make source page optional for
 KVM_TDX_INIT_MEM_REGION
Message-ID: <ajjc0hw8PjGw69e9@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-23-9d2959357853@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260618-gmem-inplace-conversion-v8-23-9d2959357853@google.com>
X-ClientProxiedBy: SG2PR04CA0201.apcprd04.prod.outlook.com
 (2603:1096:4:187::23) To PH0PR11MB7472.namprd11.prod.outlook.com
 (2603:10b6:510:28c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7472:EE_|SJ2PR11MB7517:EE_
X-MS-Office365-Filtering-Correlation-Id: 1edd8e00-8b60-467d-622f-08ded0312e62
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|4143699003|11063799006|5023799004|18002099003|22082099003|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info: cSofb2tVfFLjdWxoevQZc9NB7PY7l2nP+YZbPtUs0kMmLXmP76y9n8hJZbRQ+YyMENwgIIPSAVy0ihVL7tlic6n1Dso7Y6cDDFH/U0GCpU5NnQf40qNnDaHdp6oAPNYOcbamTI77apQ0v8Vh8COlMqSTS4jNBWaxf3j0g7vWiTmZ00n/CcmQGVhc50jkx/4z2cQHUE1eyeTdhLvYxfjjQpIPKO/J5FzWx3Exwkmpjk5wlS5k31seBJjm/0nsFDL3iI1WOE5vWOeTs56QWphnQ1k1WvJrDn1Hdj22Therz9e3iko0CU/m3IADULzXLYmCf9buDtYIJ2l85k3IyRQ0YvQyLSKRKchzCAEYbu/d4BhfLh9NUG2oYI5E/YS0PC5WF7VDNimeghNlMj0ULNU8UBWzLGhACCicfCDNy/JmN27KqpU0w8VKr7uUdvtbEeY8/6Brta1QSjzYhWQKbBiAnZchxuYHuUd/AC8wuD3SwOckZKGde9BdJEX8oYkbW5r7GNl7I4TWfORyYvtYgjEkTCpfLulkJ4sMEBcL76ggN+h6ygpheDif4HGhbxgR7NhVEHtQn0NZsK40GL1dWBcT0oEfLJDwzZK3ygaRj/A9UWjOIojdSZXTHM8is7maSNkUnsgzChBOWT6XLI+Pf9EvAHD1yxXUTgYgnEhBANQCg1A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(4143699003)(11063799006)(5023799004)(18002099003)(22082099003)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BI3y40ILs0kx4ArG6HbGl8ZdR6B7ASQKhFYGauY8m5VKuPGKny6LQsiTeZR4?=
 =?us-ascii?Q?Ee/Ulq5k4pYIK2y6q5B47cYedPYMuiuSfVdrut4nZQxQ/rmJ+OvzuT6eJm6T?=
 =?us-ascii?Q?y1aM/yaU2hyw2ioRI0HvIR/luy4pRtJSY+PIaFFzG0Q7JXiS9bdodLxwn8QU?=
 =?us-ascii?Q?Mbdg5pMbEiuPzlBrBd4KkE6tBHZdNoGC/NitdpRJoGNx4VSqJfkkV80Vf2U2?=
 =?us-ascii?Q?O7tj+q90ZjWvLwQE+jtLobH9fkv+7EFX0OunjguyFoY31ouT8gtmDtMx1mOA?=
 =?us-ascii?Q?5gKv3E6+mNFQXyS6tStvzeFjigzSRpMdz09yRzuEkrnD2IfwuqID1jW0vQOm?=
 =?us-ascii?Q?6Z74T8JjAB8YWDvwm3ObZyIi1R3nbPeI5Lo2CCNUdqK7mlXoEYlxKL53vKHI?=
 =?us-ascii?Q?2lFNr5vFw2JarcecLv1da6oR3M5zj05i64zvhXnxUvpytkU9rcsGC+2u2lCr?=
 =?us-ascii?Q?QpBhNmU/q5hEo5KEf65bJLCNNk9S9dMtRZxukuf8YUL0owGTJBJmM7FLmQOq?=
 =?us-ascii?Q?itFqYIb2oZp+7nGBJl8VJittNYhLCcNggYSzrl9QNW3kaoqcQ1pjTyDxEoOo?=
 =?us-ascii?Q?bKmfxTkh1pjCsfILqzr1gFBr5Ev4XGnIrt52H2BPndSWqsXC8xnFBaHZKi3n?=
 =?us-ascii?Q?ibndo/88iFTOUW6p+E89Uzr+tPCCPhAKWABfMo2rCLnJ46WKupLv8yITxtGq?=
 =?us-ascii?Q?s/avkbP2DhIT6EUBnK6LjqhgwYF/hbNR8c12r8wYsO67qBFxchTziWkhKQX9?=
 =?us-ascii?Q?brLAhLYKnqQOHwM59v13CXpTILisPBfh4q2YIrkNWPuPewvC6EB4UjMmXsZf?=
 =?us-ascii?Q?aRrsFnL13zBDw4TZEyiIUccVEr1H5pIHD8UM49k6xp6H0f0nUHrnW4LbI974?=
 =?us-ascii?Q?PMsMGuhy7rfO6yW0I/v8/2WbNHE89B24aLe7zb+5/+eJx2LYRKWfPS7u8qyt?=
 =?us-ascii?Q?6kvFkPm10mL1Tt9YgVxjpPoMaPP5wCTchhwYuko2kazZtzi6mM0MUlVE9SdM?=
 =?us-ascii?Q?TBe1MniNVgSawh9co3LO0vp0i/pLb2cZVrx7bcsL7PfCZrEz+hSt0ob60sOB?=
 =?us-ascii?Q?7xaLHn6wIGv36KgH1h7o5uvjNPoRmDF/pPjaiwt0OuiHDKoLgpdmvHDD6WwQ?=
 =?us-ascii?Q?UrnBTf8whsJSMmRlzYiS1uBoemUuYXwhnrCKF8AtOyMQKJKsYe1s4ZwG2Vth?=
 =?us-ascii?Q?9lOjjztwF4NKjhk4+qySiTMVtRHdRzJx564Anb9zq47237Gjor8K+V9+dHx+?=
 =?us-ascii?Q?78XpWKEwgpn+7kJS5/KZEFno4OXgEa1Tf2Beoc7HWHd7G+Di7R1KQnzjrYAV?=
 =?us-ascii?Q?B4bm4wjLScSHrRvNvvKI3QEFZvqQ9ZUSz11gFlalEMto/ljYRUbQBzvHvMX8?=
 =?us-ascii?Q?b7gBd8yseUujBVxhw6aq4TOV00CiXu+GcTnml+1NWz4LmdldD2OS5UlMT4q6?=
 =?us-ascii?Q?PaGHWejCUAm6IcommyUHs9aIxQCcEhN4MADJmR5bOWBP6xF7cO552W6HFd+d?=
 =?us-ascii?Q?6gd46wIF+jZD5STmStQh4d6wxkvk++52Xff3QLpJhozya1ePY+Tt6GPjKSv4?=
 =?us-ascii?Q?rnmqSkjIbKC/ZTX03ZUVIUpQr/YnOYX8IX53JkN/xwlqrV90HN2DXjzhF3+n?=
 =?us-ascii?Q?llwADQlLf6rI2lAkSDXPAfGyEql0MytBntndIRchJ4+nFFG5tyEt3Ca/lWg9?=
 =?us-ascii?Q?zCYv1fBqIDiUTJFaBsucKfa5Idlman5rXeugRo/tZpikzPpoEzScQwC+cIDh?=
 =?us-ascii?Q?5O+oGZIoLg=3D=3D?=
X-Exchange-RoutingPolicyChecked: NaJ/T5h6gLN/sordW5v3UiIgBt6wZdgQkbYzqFO/5ghlTHe2vXFF/STn7ETCdViUSme+J6RLkTqn9SvwMRd7uOi0PotH3b3yTCJ4MFEwWNhFL1SwotNw94k0ObQp0xgz9qOPo0XmsPOfy22z/vHuqrpVjphS4TKykMRIxRbdObu+jiRfQUOSz8fDz8RruhVeL9ExSCsNpJJ5j5kW9aX0pvlTUHzcNwEiNAJaWB+7ckaEu4HJPeWfnhoXAKMHUD9YfB2KuMfyksh6yb/wqidTxvWcWEbWRvFJj9YccRXJVvNG3XswUwVFjMeb8JhuP4vKVAfyP0Qy4O+BPRIsXHTs8w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1edd8e00-8b60-467d-622f-08ded0312e62
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2026 07:37:58.5541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bfp+VBsA+gZ7g/MW3Xsdtbig4jKpFxG7LHqS07gEsB9AlhnY5zhiRp6h0JuX4Xh3dGovTeOyqonWaj1L9sHPkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7517
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8E98240004
X-Stat-Signature: 1kbah5fshm6uk5a6bsg9ggei9zujsf6o
X-HE-Tag: 1782113887-318668
X-HE-Meta: U2FsdGVkX1+Bm+wKbteFRxTQ8YxL9Tnfq5sAsYaYZzxvU1q6xDIyyHrwKbfgY5LIf3JP/+AZ1rsYlwewAyP/nKXdEPz1EO1JDO63m70zAjzNqbUv1Oc3sf1oOJgXYWcsmRL0KlH4CljQcm1A9JQWkUNAMRWXscsd5NbolsrFg/UrI+jzk/uIANswoU0wHfg6DuDTfZLWJlpgaVybiltmtoJhCgpKrXnwNljhToWGg+uVDin6EaCWsZu/2lKIa9bgntsC302GQP0ik0WG7dcfVHgRLsGChn8NIYjbMppQp0b1XbOjYVvcBc6x3lMY7hw5hNIV6VEr6AnxS4dz4GSaUKr9q+KS5dLz9SZpR3q4uOJzUz4aXIV8dLkYvOXTM6lomOFjHXf2ansMDYMB9PRxQAiSbdub77t+1JVk+evaWvodibVrm4bVEw82Bp6+UkNesDuy7z7fAOHomccktF2w6UxLFU7nGTglH3kSbn8Lh7qu0K9nZEREOLMlSsuLwW2dnM1tYGPgB1jg4vGAxU3dHHqjTOLXrP8TTcYNP14XUmTCaX1vuS0E6avQdhBLTo3a5X4pNKIv1uoV2d7VfyNmBB91PS6m7ULOXFSVNa6savH6itYfM23uEq3YPtCL+pK9RWboVkSVWn0ZyPEOZSGbuQOGDAGeb7D3yGoutyXQZ7Sj9zwdzaKrehgX1/VnCQBQiyBQ1MpvnCSD8RjDhUHslhsTgt/E4hFWHVYYTy8TdZq7hM9PQBOO4oDFo+REtQryetnqr7Q5sYZeFcXllM2G1lpB/NeEZM/8/X7oZKSR64pR5e+m2VK9pExb/Gy7v/A4j3Hhpl1faSRT0tX3lGpYp5HbCC3vwV0lFsqgQmuyzv/0YDlcp6Th3C/PhZvUp+bM2t50fX8gxEGPewKqnqO7pwGEssNZXRTfypoZtcCT6P6B7ZoGsnyb5FMdypCNdwOPVPhcvsxbHXg80DzrNYn
 6/6C9u9w
 4qkR9EbkdENgs/oZ+MCX8jnTYAdTMpkYPF6ahhRGWKeWk+Cj6Fqn+T1YDn7Z5CeC4SPo9t6pOEkHNeqCa84+jFDFLZvK/cj1KoaHHCqw3uEZ/TrjwxYxNskjKt0Oshidgrod8rCbv/BAlAobBBL72A2h2zpFpay6071lMUDmkFAbvi7y1ap4mJzuOTtvxG1krnicpeJxEhlsJXR5eymn9Yd+X2JEqMac/CSNB4aTXR4FFUqBwZWrtKwed37PmLKzZ8bTGT0hPWM8ZxS3CEC8B04Yc3GwNPGT96APvdrIvzGs5p/+k2mNIzvvo8UD9mcvp4Lgi1a4i1rqyPNAX3o3dOlvv3slw/igtlMkBVkeSpsJaparr54TeNhdbgTsAcjZCVKkdi/ZHbyvlX9O9YttMbETDDKizREMd2maz22ung7tResePEUYbDo50BFZcrCdl4DU8WRFY95o4bv/aEctdcfDzytD1BzteA8ANQpTO3fYpSznzdtVq25OnQRIxjv6sNDGU71tLSItofdwZEpyb984oSRfSs1D6bA8fmC02xG+qlNE2GYvH03bhabJ/CZ/+95YwPmvgsqSnEVR40t6hmxOAXGxEXlLkKScLm0TGdTTPPih3tq7hgrPSO3Vq0xsBCGPuZ3CGCbT+Z8Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 05:32:00PM -0700, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Update tdx_gmem_post_populate() to handle cases where a source page is
> not explicitly provided. Instead of returning -EOPNOTSUPP when src_page
> is NULL, default to using the page associated with the destination PFN.
> 
> This change allows for in-place memory conversion where the data is
> already present in the target PFN, ensuring the TDX module has a valid
> source page reference for the TDH.MEM.PAGE.ADD operation.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  Documentation/virt/kvm/x86/intel-tdx.rst |  4 ++++
>  arch/x86/kvm/vmx/tdx.c                   | 11 ++++++++---
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
> index 6a222e9d09541..74357fe87f9ec 100644
> --- a/Documentation/virt/kvm/x86/intel-tdx.rst
> +++ b/Documentation/virt/kvm/x86/intel-tdx.rst
> @@ -158,6 +158,10 @@ KVM_TDX_INIT_MEM_REGION
>  Initialize @nr_pages TDX guest private memory starting from @gpa with userspace
>  provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.
>  
> +If guest_memfd in-place conversion is enabled, pass NULL for @source_addr to
> +initialize the memory region using memory contents already populated in
> +guest_memfd memory.
> +
>  Note, before calling this sub command, memory attribute of the range
>  [gpa, gpa + nr_pages] needs to be private.  Userspace can use
>  KVM_SET_MEMORY_ATTRIBUTES to set the attribute.
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index ffe9d0db58c59..56d10333c61a7 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3198,8 +3198,12 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
>  		return -EIO;
>  
> -	if (!src_page)
> -		return -EOPNOTSUPP;
> +	if (!src_page) {
> +		if (!gmem_in_place_conversion)
When userspace turns on gmem_in_place_conversion while creating guest_memfd
without the MMAP flag, the absence of src_page should still be treated as an
error.

Additionally, to properly enable in-place copying for the TDX initial memory
region, userspace must not only specify source_addr to NULL, but also follow
a specific sequence (where steps 1/2/3/7 are required only for in-place copy):
1. create guest_memfd with MMAP flag
2. mmap the guest_memfd.
3. convert the initial memory range to shared.
4. copy initial content to the source page.
5. convert the initial memory range to private
6. invoke ioctl KVM_TDX_INIT_MEM_REGION.
7. do not unmap the source backend.

So, would it be reasonable to introduce a dedicated flag that allows userspace
to explicitly opt into the in-place copy functionality? e.g.,

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 1585ec804066..d047a6efc728 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -1043,6 +1043,9 @@ struct kvm_tdx_init_vm {
 };

 #define KVM_TDX_MEASURE_MEMORY_REGION   _BITULL(0)
+#define KVM_TDX_IN_PLACE_COPY_INITIAL_MEMORY_REGION _BITULL(1)
+#define KVM_TDX_INIT_MEM_VALID_FLAGS (KVM_TDX_MEASURE_MEMORY_REGION | \
+                                     KVM_TDX_IN_PLACE_COPY_INITIAL_MEMORY_REGION)

 struct kvm_tdx_init_mem_region {
        __u64 source_addr;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 56d10333c61a..6072b38ceb37 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3190,6 +3190,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
                                  struct page *src_page, void *_arg)
 {
        struct tdx_gmem_post_populate_arg *arg = _arg;
+       bool in_place_copy = arg->flags & KVM_TDX_IN_PLACE_COPY_INITIAL_MEMORY_REGION;
        struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
        u64 err, entry, level_state;
        gpa_t gpa = gfn_to_gpa(gfn);
@@ -3199,7 +3200,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
                return -EIO;

        if (!src_page) {
-               if (!gmem_in_place_conversion)
+               if (!in_place_copy)
                        return -EOPNOTSUPP;

                src_page = pfn_to_page(pfn);
@@ -3245,7 +3246,7 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
        if (kvm_tdx->state == TD_STATE_RUNNABLE)
                return -EINVAL;

-       if (cmd->flags & ~KVM_TDX_MEASURE_MEMORY_REGION)
+       if (cmd->flags & ~KVM_TDX_INIT_MEM_VALID_FLAGS)
                return -EINVAL;

> +			return -EOPNOTSUPP;
> +
> +		src_page = pfn_to_page(pfn);
> +	}
>  
>  	kvm_tdx->page_add_src = src_page;
>  	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
> @@ -3278,7 +3282,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
>  			break;
>  		}
>  
> -		region.source_addr += PAGE_SIZE;
> +		if (region.source_addr)
> +			region.source_addr += PAGE_SIZE;
>  		region.gpa += PAGE_SIZE;
>  		region.nr_pages--;
>  
> 
> -- 
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
> 
> 

