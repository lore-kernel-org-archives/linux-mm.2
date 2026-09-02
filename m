Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADD1BC61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 412166B0088; Wed,  2 Sep 2026 01:02:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BC8B6B008A; Wed,  2 Sep 2026 01:02:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 284606B008C; Wed,  2 Sep 2026 01:02:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECF876B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:02:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5D909160707
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:02:47 +0000 (UTC)
X-FDA: 85167627174.04.7419C13
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf09.hostedemail.com (Postfix) with ESMTP id EB507140005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:02:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=a1RXcWWX;
	spf=pass (imf09.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788325363;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLT+OC6O7OEI0MaSNteyEsZxCv6Rs1G0lCMvJGv70Q4=;
	b=oVlVjwQrbDFC9EW9hyuDQmLJHehap+/LQMuXygKn0TS+VKS9HVrVCKYKRgFSTDWG/GPULg
	PWzpQItR4TkXQdi1NkGDeN28VdFlACd5PaciHisMVIf2ZfOimZPSLvOsNCBorwVENO8r5G
	IQWqcEZp2QlIf6R3vKK+IPE3J08lWHY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1788325364;
	b=qaslX+y97cZVhYtbj9rFJpekFULscHlHtTlt5dtAsji8401NtX3owg4FYCRDySkwVAu3pv
	sMJiexmV2kZZ2a/okdMaYYWCqeJ/Otf1Fa55ftIw/8/351s4cKYLOaoEOLkOrCwh0shp1z
	dwI+hyysBtu7T8Ck76CE2rQvpjAUhIQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=a1RXcWWX;
	spf=pass (imf09.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788325363; x=1819861363;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=+7Ps+AkfjKjPSiuZcdB+xHbjPDwtQNKX1sgLRnGClFA=;
  b=a1RXcWWXdjGt7A631kE3hJuLzyA/jU8wwA9N9k+ObMJ5g3dA1yUpsMF8
   psa/vjtKVI7AjZaBLRmibgBjWiQPb+oeR1l1TpiNflX3ERgibridhgnyq
   HGXGl2E6ohN8HJXYO8Uc/VtvR7OzqMkZUeq7GhVdkhi1/oqdK454tV23s
   86h68n2KEqVYNRx0erc49YFmh7Hbl9HcxXXywHYqh4MpNScsXwJ42/BnZ
   WHWtoIJDFXZ7IbTSx21Af04BBEPrSktL8FXlC+yot/zoeoLz42haxYERp
   qVuNhbuf7gn+RktURLkbTK7JqmttakZU/L8v9s/Q2LOMPnPkmP1zARlCg
   w==;
X-CSE-ConnectionGUID: f1if9C+ZQHW9uiV8uJwUZw==
X-CSE-MsgGUID: neZNJoNrTaKagl8Me1CzxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11893"; a="87910523"
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="87910523"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 22:02:41 -0700
X-CSE-ConnectionGUID: 4f8xpXeuToOWX9ZSsumLrQ==
X-CSE-MsgGUID: yasajWk3SwavLrxXr+aXCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,257,1779174000"; 
   d="scan'208";a="265008856"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 22:02:40 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 1 Sep 2026 22:02:39 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 1 Sep 2026 22:02:39 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.7) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 1 Sep 2026 22:02:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JKRNau5o6y8DEGB3xTWqbYw6rgIKRcLFh4O7Eus8PdlRi2E6y447BYQkbExkzVAti511od2fxe6tW7UFr9LOfGPezcNls2Iz5Yq3+XHpHLDsXOvsuWNJQb4MAxY2AD7YjhuJkKqpayHH+6YCHOCzuRIeVYGFfNDPGAkQc/JEYExsNWFpTcwt8o7yNY5VHRgRpk1hiyrTdzHBz7nyIk1cQgzbHzd7ppYTMXo35amVk+7IGfu192kKcm/e/fJglKuWFuMTn9OI3VoOe9Ecg8U6ZRMZqFWCHcFQbAKVp82zDidSS6PJGQf/kq98ljVeUbp1rELM7dJXStwKxcMLmxPC1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLT+OC6O7OEI0MaSNteyEsZxCv6Rs1G0lCMvJGv70Q4=;
 b=gMqu8teqy2rFdL/WbDx7ZrrZ1oNfu/bkOcwLNWCQm4Jk5fLgO8lCqYd2ikJyNtusNnho+z0sqbkh6Rjqjbiz7iqVUkLxwMkoNANq3AEa0+A45Jzv3WciJh7M7vouShjKMDUD5hFEnmF7brZry8TJM7i+yzH5mA5fhT63ZP+w8zDKxrls3sxrKlXVaovRmAPwyJiamqsVJErSFqnP2Dl+6725K9hCeJV5vwFqZWcmOaGlqvRQ5dVCQbRCIY4jNj45JHa3hTgOGAHu+ZMmsLj+d5xvw+H07Qwki/hfTUbO9+Fd5ctfgzwjYstneJ64hkmHfxGKfeuh+GONKJ9A8aXdDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DSVPR11MB9579.namprd11.prod.outlook.com (2603:10b6:8:383::17)
 by DS7PR11MB9498.namprd11.prod.outlook.com (2603:10b6:8:261::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 05:02:36 +0000
Received: from DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d]) by DSVPR11MB9579.namprd11.prod.outlook.com
 ([fe80::ab5f:5d0f:fb90:9d%3]) with mapi id 15.21.0382.007; Wed, 2 Sep 2026
 05:02:35 +0000
Date: Wed, 2 Sep 2026 13:01:55 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: <ackerleytng@google.com>
CC: <aik@amd.com>, <andrew.jones@linux.dev>, <binbin.wu@linux.intel.com>,
	<brauner@kernel.org>, <chao.p.peng@linux.intel.com>, <david@kernel.org>,
	<jmattson@google.com>, <jthoughton@google.com>, <michael.roth@amd.com>,
	<oupton@kernel.org>, <pankaj.gupta@amd.com>, <qperret@google.com>,
	<rick.p.edgecombe@intel.com>, <rientjes@google.com>, <shivankg@amd.com>,
	<steven.price@arm.com>, <willy@infradead.org>, <wyihan@google.com>,
	<forkloop@google.com>, <pratyush@kernel.org>, <suzuki.poulose@arm.com>,
	<aneesh.kumar@kernel.org>, <liam@infradead.org>, Paolo Bonzini
	<pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, "Thomas
 Gleixner" <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, "Vishal
 Annapurve" <vannapurve@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song
	<kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
	<nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, Axel Rasmussen
	<axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
	<weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, Qi Zheng
	<qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau
	<kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe
	<jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
	<peterx@redhat.com>, <tarunsahu@google.com>, Randy Dunlap
	<rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka
	<vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren Baghdasaryan"
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, Fuad Tabba
	<fuad.tabba@linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-coco@lists.linux.dev>
Subject: Re: [PATCH v12 12/45] KVM: guest_memfd: Always fault from
 guest_memfd if in-place conversion is enabled
Message-ID: <apetw3aqXSawLBt0@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
 <20260830-gmem-inplace-conversion-v12-12-85e5fd25252a@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260830-gmem-inplace-conversion-v12-12-85e5fd25252a@google.com>
X-ClientProxiedBy: TPYP295CA0017.TWNP295.PROD.OUTLOOK.COM (2603:1096:7d0:a::9)
 To DSVPR11MB9579.namprd11.prod.outlook.com (2603:10b6:8:383::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DSVPR11MB9579:EE_|DS7PR11MB9498:EE_
X-MS-Office365-Filtering-Correlation-Id: f2c6f38b-486f-4d9e-1a86-08df08af6763
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|6133799003|11063799006|10067099003|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: +dle5YB7BGC+xmdB2YVJW838MsH70bD+p1gdt6SR0g43LtCS7Y7m+YpRfeYGkKJVbVTj1krc5hAKExcY9JiUZNjSTsAnvnL5QM4f8bTWBHIZnFQT+AOV5FZAs/NJrcTJii8hhl/Z0GG2hYsujTaYHaK+uUr/C/ui8eu4vhLE0OOF+2NSigbFJUigNzyv1/O5jQLQMdAtek9/B5QIoVnsKnOVbKV+JYPPoyBWAwiJeVoa/9jFf1oJBJkNSNV96JyrMo2vSj+z8x4nqtq9/iI4J0M2/mWxO/2bs46QPo58GYLQrSj3zT/HpreiDGiEVt4Rv7TEseXRGqazn4lFjU27RtEdkJuY0R2P+6ZqVP74k5N7re+ALgLEU3PGfR7tH0TekLUurf+aTHF1zP/Y84eto5TSzPivzWTMDesqQxCcQNH9IrrpdEkwT3LOn8aGqfW8M1ZteLYYDC4XatEEC9zO0AtG6nzfdptHJRh5ancsQMBM+NckJ6Zo55MxDl/o3r3U6Zh0n7gi5DdN89IjEdO/tivuwrCqaXlvA/9DAyBY/XxB3gQxaz+IBP5HmNkJ28CCwV1ZtRAcI0o1xcWHyaT9MsD9j//8SVi686sF4zsaI2w1ZoeqB5XgOmHcXDkuxDl2G2jERzJCGpk9BUTpjO1lniDqvFd9bAySwB1QCJcPAlE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DSVPR11MB9579.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(6133799003)(11063799006)(10067099003)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2k5cBkytVDmNgrx2TnWuHcN2P5RxIE9Hk5GxOtpcuCA0H/Utr9eoPYVJYuqT?=
 =?us-ascii?Q?wZIxHb6x+SbTEhqYhnsfzdap7v0YzngP3whV9/Px9POIpeYVpWzJsz3SfPDN?=
 =?us-ascii?Q?49KmrHGnZgrs0PkCYw92QY4SkYtR0KVqC6JvUZGeXGQoctn4prso6Sy8Ljin?=
 =?us-ascii?Q?E9ZcqGi1EkvhDFVZJrYHGYuekt63WDH6VqNJxyME1ZieWOAU8+Vqnp2hReLY?=
 =?us-ascii?Q?XcmyxoNdHzizMbdAaG9VlvJQUpcHgRiP/I1rsD/oIpXdnqjBodFN7CZYJQ/q?=
 =?us-ascii?Q?oql1ljxPxTP0M19q8/Xttl0FrY+3N09ZbnM74YNERuDEdCVWYFAcK5AwGw9H?=
 =?us-ascii?Q?U3O2h88UAb5EfaGbkAZ0iqumWDue3dvhOhYNe+MN3FpvMFb+e/KVKQaWjjNe?=
 =?us-ascii?Q?qIpnIoD452euVnZfoeAm95xJZ/CNpyD7yPV6BfJkCxuPFw5TN8ZdX+3lwhU8?=
 =?us-ascii?Q?Q2J4CC2Qe3zgLD1mZ5X/zAcamOm+Civv1o5MicU/NwPKqb4KY9CnkF/hEssC?=
 =?us-ascii?Q?HgzR9FfTDFDx/lffM0ZfJiXnl12X0iqEZT8K2FiwyrODc0EQQg8n/oUWSibq?=
 =?us-ascii?Q?cDBJGfUgesrmzhFHaklP2L0vV2X7mtZKM0olj8ixqUEUBHi0SQdXidJHUb8R?=
 =?us-ascii?Q?vInhJ+dEDapjdeIQQO7nWkwhhwTnn5B3Es5vtVq+0eiGUZ6KdSWws9oEcBX6?=
 =?us-ascii?Q?9/9RmZGvcP89lVqN5NVWy6GwqY2q3kYPT45FNwUa7+Nxke8gTELLi0Rhug5b?=
 =?us-ascii?Q?JNpDGkAlId+LzevKv6A9lrnVsHxFfx4TYMGtcKorMi8eP3NKl4Zv15ab+k1e?=
 =?us-ascii?Q?U09wmPPvBjuM6N2/pEpSP8ivupGM832jTXaBSn4GuwnJPSTIFdC5sDGNnKZd?=
 =?us-ascii?Q?HE/rYvAjYJQT5VdHCS6iqOWVLpNnu/yGwartvvNlL7aQ5Z5ld2fz01R4m6VO?=
 =?us-ascii?Q?d7Sm7g4Aj5f/BhGtAG/gz1bCtQJ2wYWcLFEZRYYsrxPGngdNKVpNBs4meiFA?=
 =?us-ascii?Q?XJFCR+MSy+91L7YjM5I/6QPZjl+CN99eEZ2MS+vXpPVRfGQ9n9A5IfJVfEcP?=
 =?us-ascii?Q?MvMQpFhoo4tpLwSeVt9npLG9cTh3WpZpQBnjJHzl6+i8bmMpHjVgC5xBQ0ig?=
 =?us-ascii?Q?DfqII1g0/miREkySFuCaBj+7+kPWkjMWuLGKF3P5FUSGrXUZNisZWVBgEPJM?=
 =?us-ascii?Q?0RW8IrZRxuHaK9T1bfeXGxjq/Zp/F8rHUi7priLAlNBEedImko+Tr5BDL+WG?=
 =?us-ascii?Q?hVebIhlMrNikD2YE343K7e2xcONX9IDtS7uQEvBYd6WGWL8gr/vrR9JB3NEK?=
 =?us-ascii?Q?Wz9Pl/f/Sq//yUwKRpA7v6T6WqVU5IslI7iw27nIIlJjHXF1UVU79Kt0nOrK?=
 =?us-ascii?Q?mGHJzldhu0LdZmwNyFn8cd0mhm9Vn/+GEA3LcNzPBYVJgck+32gaIhP8sCS2?=
 =?us-ascii?Q?xr4dqp32j57v+3kE6qv+lHtpk4maaimUDBEISKEBuelA8pcltB0nxG9fgxcR?=
 =?us-ascii?Q?T/+HNXd2fQuIuIUNHRtLaB4p/honRqpcPIp2vyhARqw3XIYagwUwwDYOrdrS?=
 =?us-ascii?Q?qomk0Pi33MSbl/G/5gIyw7WnXCW7o8a8gzT/4VSx9GMwtemH+8IeCkacbEoL?=
 =?us-ascii?Q?ieUFqgq1e3BCkU4C4XvXuG/gVO3qULgzL7nLWDX+v0ijFeAOFGIg8yj2dDZh?=
 =?us-ascii?Q?O1Q27NAZNFADU403arPijTKW96HZLSujzA0eDo1B53yviGXfw0EjoJz0p+VJ?=
 =?us-ascii?Q?yoqP78u7kw=3D=3D?=
X-Exchange-RoutingPolicyChecked: QoJnTdhmh+OB8BvFGCqpGIWV4Ea4yMzYUrK3P7Y/WCJdCQh77EVasslTO2g/6FpkKPclNUCu2j+GRqOY4rhH4qjhN1ogauvp97dACcIQ7imuKhfEe6KkhBQ8RpfbjLhBIPSHY78OeM527gBlal5ZCxhBqt2jUgGl5zAzoVBdlV13u7CIP6UCV5wrQJdIB69ALFFQNQKJQYUQTbkzQNIkD/lzQhGbDXdvOnrmnIlka5q/Tt6Dp+iFWfyl10RhPh0+PSWJ33Yk3r3ZdRiCzgaf1R+Bhqrbaeo1xVH+rPkqqeht1BUg+yQoGDYUYwNa5AEBWxSYupUWhH+3MTDSFHadqA==
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c6f38b-486f-4d9e-1a86-08df08af6763
X-MS-Exchange-CrossTenant-AuthSource: DSVPR11MB9579.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 05:02:35.8429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mKK6uLFcNPiXuN0Z1zxpNcaxQC+c9Kyz8nz/w/xQnKe5X9zJ9qFSrbO8RbntWPcqeY9i0jxRXQ/xwOh5q/UEDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB9498
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EB507140005
X-Stat-Signature: 7f7t36adtjzsx1keneh619fg7zykez6f
X-HE-Tag: 1788325362-413462
X-HE-Meta: U2FsdGVkX19KHyuf7QeLOZ2Y3UEtiu/o3ueya+fdkhNrixHdk4/MwtQRGTFgoyy5MX9Ql6T0A8SjD2g5mY1FhG2A0TDNguNtDEszmMdpdgGWRimeWKj0Wt0RzHaSuJ80RfYgiNHD+JWXbjxHZ2uvveiP4WJ9tJV55gPogrXM+j/Sz69gLRUVcySoFvkA7CZgA1Y7rD3IcsBXnPsx6Zcj75leG6QRCarxmA60tWXaIc5szMSCgxsWe9Cly+sMmvCqxVUEh1+FB4B1E6NIY35oLiZp2VIq6G+/1GOW4e6zvkg7znt3pUDxVwDebqejBQmnpdrArCW8toOzG42H4lZQK3Bgpt+F8OuxXbd3aCnxmhPbNJC0nglRwMyITfRfcrpqpMD3pkEYEyqeLT8cVrEUrnECAh8jySIKiNnEwZ5GwN1iO/LdduXm30TLyrBaJPuxA23/h9Bv+ob8vD0veYYJnhYsKdFbb1yumFx44sg4ocTMnIM6J76cRA3fv4AjdBz81ArjH5EZHxsurM+zuhkc8t0uk902yrgNb97k9nqpQfztrLZ52kbSWSBv9kG/mqgSqy8/2y0vzo6K/3U35ps3XyIWL4bPs6mulVsxmkFgrebvaEGMV/hWGobPK9Zd64CQeqgDPyH1hvtxrNf9MfX7NaOFsgO/d37lpA+KvPH+X/RRw6nJ4MNnXbWVLc3eF6pJV8gezRRcBi4fdO4KRqgNh1lef5DubuC0d3dUH6Xa4g0fx4gDJKU6MVZwOrMmoJHLQ5Ii/2CtBHPhA62ZX3kYJQJDvSd5G/yPoryTgS0hOMnO2wOH+a48JP2TYzXETgMkinuz+eE1LXTzp0WRw0lxcN+6NwLmhVH8WJCBN/VSzHPyowZpsijVSYBfOtseAv6Znvl0wNu7aw8FyUYpH2haJN5n+FdtuqnL2DqllQoWW9k+V+APkFItPfaAASdGBeWAz1OMTsFXQajZNz2VXbp
 /hlpY01y
 ZUyXWjsYw0iPqMLmF9IX7Apr+keveAu69Z9vfvJV6LWkKgbSkVSEZ5Of271lgpjKwxqgCH1hpG51BocBMvaeC059uFXAnazQZY0O/XvrPJrGnlrrOGCyC0lTpsWyAt4AcxzH2J7nsIsn6GWND8b6azOv1h2uhjkuFY9US3g+y5yEJa2CAJJ2+7DkSW6DWP226xSZ9usSdefzfxbjvSqWUGSbZFFp7YU6gM99X9TvoUzP9Yxbftd044qhBJhqoL85CMxXLNabmwmvZEjKMVpXmOxPxWL/NS2Rm6PTCGpHGO+cx5OjWYwvVg8Zwoyqn4t5+g7VPWSEtm0fDF8DRABky4a76Y2/rYPS4X5k4mqxK29jZJbj028tc4KlK8ovJWT999FJoIjj+UQa3Jv4BGhxYB3hOsNOatoWWZImwCcvFsjFhHbGYMa6Gcjm2HTNUxSec1SINGT8UcqdazolVAzb+2u0eOEHB5/BM6aTH88BnOkWkHtlz9tOVR6HnmHeTGTlCdmbkY5pcX/gYJTcesv4ryMvjbpxzlcfTAfKdBvhob1WZtPhDzjVroINTndRVf16TD1jQpVAKoFVmoxi83TNgW/0Z5DGclUAXHvjzi9L0eUdtUsszHuuyHSFWH29BdG0bukTitNd07IC5UQ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 05:25:13PM -0700, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> If a guest_memfd memslot is created but the guest_memfd does not have the
> GUEST_MEMFD_FLAG_MMAP set, KVM still fulfils guest faults by looking up the
> memslot's userspace_addr.
> 
> Set KVM_MEMSLOT_GMEM_ONLY if in-place conversion is enabled so that the
> guest_memfd's memory will be used for both shared and private memory. With
> in-place conversion, guest_memfd will be the only backing memory for the
> memslot.
> 
> No validation is performed to require userspace_addr to be a mapping from
> the associated guest_memfd because even after validation, userspace is free
> to remap something else at the provided userspace_addr.
> 
> userspace_addr will still be used by functions like kvm_read_guest(), and
> if userspace_addr does not match up with the corresponding memory in the
> memslot's guest_memfd (whether userspace_addr points to the wrong offset or
> some non-guest_memfd memory, etc), that is a user error.
> 
> Requiring both shared and private memory to come from the only associated
> guest_memfd simplifies invalidation in stage 2 page tables. On a PUNCH_HOLE
> operation on a guest_memfd, the invalidation is now guaranteed to be
> invalidating only memory mapped from the given guest_memfd.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 22 ++++++++++++++--------
>  virt/kvm/guest_memfd.c         |  2 +-
>  2 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 90a29424c54c8..668886f50024d 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6381,10 +6381,16 @@ mapping for userspace_addr is not required to be valid/populated at the time of
>  KVM_SET_USER_MEMORY_REGION2, e.g. shared memory can be lazily mapped/allocated
>  on-demand.
>  
> -When mapping a gfn into the guest, KVM selects shared vs. private, i.e consumes
> -userspace_addr vs. guest_memfd, based on the state in guest_memfd, which is the
> -sole authority on private vs. shared memory.  See :ref:`KVM_CREATE_GUEST_MEMFD`
> -to find out more about the creation-time shared/private status.
> +When mapping a gfn into the guest, guest faults are always serviced from
> +guest_memfd regardless of whether memory is shared or private.  KVM determines
> +shared vs. private based on the state in guest_memfd, which is the sole
> +authority on private vs. shared memory.  See :ref:`KVM_CREATE_GUEST_MEMFD` to
> +find out more about the creation-time shared/private status.
> +
> +userspace_addr is expected to be the mmap()-ed address corresponding to the
> +right offset within the guest_memfd. Any mismatch between userspace_addr and
> +guest_memfd is not validated and is a user error. userspace_addr is only used
> +for host-side guest accesses such as kvm_read_guest().
>  
>  If in-place conversion is disabled, KVM selects shared vs. private, i.e consumes
>  userspace_addr vs. guest_memfd, based on the gfn's KVM_MEMORY_ATTRIBUTE_PRIVATE
> @@ -6490,10 +6496,10 @@ specified via KVM_CREATE_GUEST_MEMFD.  Currently defined flags:
>                                 page tables. Private memory cannot.
>    ============================ ================================================
>  
> -When the KVM MMU performs a PFN lookup to service a guest fault and the backing
> -guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
> -consumed from guest_memfd, regardless of whether it is a shared or a private
> -fault.
> +When the KVM MMU performs a PFN lookup to service a guest fault, the fault will
> +always be consumed from guest_memfd, regardless of whether it is a shared or a
> +private fault (unless in-place conversion is disabled and the backing
> +guest_memfd does not have the GUEST_MEMFD_FLAG_MMAP flag set).
>  
>  See KVM_SET_USER_MEMORY_REGION2 for additional details.
>  
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 0afe1468d2d9d..e41802944756b 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -746,7 +746,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	 */
>  	WRITE_ONCE(slot->gmem.file, file);
>  	slot->gmem.pgoff = start;
> -	if (kvm_gmem_supports_mmap(inode))
> +	if (gmem_in_place_conversion || kvm_gmem_supports_mmap(inode))
>  		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
I like this change, which actually enforces in-place conversion -- when
gmem_in_place_conversion is true, if userspace sets slot->userspace_addr to a
different backend, the host and guest will no longer be able to access the same
backend.

However, since gmem_in_place_conversion is globally and statically specified, it
essentially disables the coexistence of VMs using out-of-place conversions when
gmem_in_place_conversion is true. Previously, VMs using out-of-place conversions
could still boot successfully as long as they switched to using per-gmem memory
attributes. Is this change intended?

On a separate note, is kvm_gmem_supports_mmap() still a necessary requirement
for setting KVM_MEMSLOT_GMEM_ONLY? When gmem_in_place_conversion is false, if
userspace mmap()s the gmem but sets slot->userspace_addr to a different backend,
should the KVM_MEMSLOT_GMEM_ONLY flag still be set?

>  
>  	xa_store_range(&f->bindings, start, end - 1, slot, GFP_KERNEL);
> 
> -- 
> 2.55.0.897.gb25b4bd76c-goog
> 
> 

