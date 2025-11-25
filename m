Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46BF7D0E6EC
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 15:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ADE96B000C; Tue, 25 Nov 2025 10:11:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 885A36B0023; Tue, 25 Nov 2025 10:11:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726926B0024; Tue, 25 Nov 2025 10:11:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5D8706B000C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:11:15 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C762C1394EB
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 15:11:14 +0000 (UTC)
X-FDA: 84149467668.16.6D5FC72
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf06.hostedemail.com (Postfix) with ESMTP id B56AC18000F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 15:11:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VjE2xpHj;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf06.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764083471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lVMagNg8E5QkgljvpitNzoT9iRLhdXnBkC9VI0Fxf3s=;
	b=1rq2HNx5nfZy+r2v8Xn2f4vVbdNVK9xbaK2nA/wcInUkwVgy4s9qTuIYIrxVvde724Z6ZW
	Hn+EP5PgWEaQIaL0aPwLzagLI38TmzYuXq+i4JJHq66BoKMhF7qRq8Y519nLDxd9CmeYVh
	cE5rommpjWHc6xx0WuDkzoKJFSiLk08=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VjE2xpHj;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf06.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764083471; a=rsa-sha256;
	cv=fail;
	b=mHHqSUhDVSipCCqLieaaPQ5ty2Rc97GS8xlSV+RPAWyHm5wgFOmJ08HEl4Qp/ILE5xymqs
	r+/jcXpZDhaVKTVWnVeSvvpnNtn3MLMDlvaZFpKMx6dHx0RFSwU3rk1Oi/pA5IiKfSTp6R
	Mev0OmDNhrmeVXmNTP+iqLJJey0wqYo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764083469; x=1795619469;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=0MXbj2nSR3RHbwA1l/ZqSDw/o3llH33L8r2u37V/O1g=;
  b=VjE2xpHjw3MQbpKSE6x0njZkbUI5lOfN3wk7uMqvWE93DgjS22hWX6BJ
   wb7/bZjtsOMlD1wfrG3/8FzEh7MOwtqRBF6UhKp8nMQsfnnMw5n413gRJ
   dmwb+br7pSzmviKG5cYueUhi8zE6Pzju69CCQyHZ0GUVvo/4Ja67f1HFz
   8F7ne2WigVfrzTcdcw5U1UtWsMkCvsus4s1TYKsVzGC9GQ70LVaHl3q/T
   7xBfUQIVmQf8F7i3ysEUXJqwykARylATjAzItS+LDxSmyeYEetURLDW0L
   yNcwi36H1K6i9UknkgAjkbwXGCNvoERLnzi1sAlUMtYfWmntVJDFeKHXz
   A==;
X-CSE-ConnectionGUID: hhRbB5hCQPOJHCo7K7HZ8w==
X-CSE-MsgGUID: G2JU4J7nSzisCYv96JvWpg==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="69965573"
X-IronPort-AV: E=Sophos;i="6.20,225,1758610800"; 
   d="scan'208";a="69965573"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 07:11:08 -0800
X-CSE-ConnectionGUID: giobdt9WTRmKUtTZ68BstA==
X-CSE-MsgGUID: xL7rlV8VQUuNvAjGUTtiTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,225,1758610800"; 
   d="scan'208";a="197593149"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 07:11:07 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 25 Nov 2025 07:11:07 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 25 Nov 2025 07:11:07 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.0) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 25 Nov 2025 07:11:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uCqhPw6pmfvkwxpOSO816ZN/uFtyv5VYiDXDnTsiVA5lgncgCzLDf9nD66T7msYy2/E2tnGt+CT7XDDwnbvHSlC70xyI7LKgSKzKo+p9j8blecK1pl3eU6JYmJcDR1RruXrDOgNBzsGso7UpliscH4q+waCt84p0gIuc8J//p1zI9hXWD+TKeQ+wJ1gjMni2lfH3x+Ja9vgtBd+E+QMMjCyFZQZzQgH1JtHJ09maHyUJnKCtbgjTgCq0UaUkjcPrDgie2eAWMzCvGoviG0o1LMT4BHVVo0wsvvfrCmfHROeI4LDTuPZgKYrfhe8qadwKKBzI2k+mDYBvUgzR5SMk7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3GqoqJk/mGkDoUhK1g8JLndzyzgrEeCjUk7KERvmt6c=;
 b=YLwYNWux89ZLXzE1wVZKESK1f2yXomxRLAD6GBDMv6sQNB7lmb6gqfLXs99biaJqBZs/YNAOJQh5jhNoE9lUyIDEjBk5bmDg3hNSU6NOdf1yAqmhuq8ao34YbRRpkUX2yXMgkg4SoORNGt5h9lEr5pzyhmxRmd5ITtnoxZOGqWxyZ7etKjdCBaMGwP/aN06rC8iCdAkEjwtjS2bu3j+/41jBFEXm32GxoSgfDQbfbvWLUKycw/l8xBTQ2Zplbd/ckzYTTPBaYEOH+iCbAYf1+9YS10g15cWcYr4bglchJecjz7u/cUp71oMRM+MqWHDVMv4xuHLxFd7vbK7Iex6b2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by IA1PR11MB7728.namprd11.prod.outlook.com (2603:10b6:208:3f0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Tue, 25 Nov
 2025 15:10:58 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9366.009; Tue, 25 Nov 2025
 15:10:58 +0000
Date: Tue, 25 Nov 2025 23:10:48 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, Chris Mason <clm@fb.com>, Johannes Weiner
	<hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, "Michal
 Hocko" <mhocko@suse.com>, SeongJae Park <sj@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Zi Yan <ziy@nvidia.com>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [linux-next:master] [mm/page_alloc]  91e6912966:
 will-it-scale.per_process_ops 9.6% regression
Message-ID: <202511252236.31d04f3e-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TP0P295CA0004.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:2::14) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|IA1PR11MB7728:EE_
X-MS-Office365-Filtering-Correlation-Id: b870a631-c589-42ab-c360-08de2c34d660
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?vUmVJU6j1t/o3Q71MOxc46qWa8gFBQmyFmUwnuoVqHgNbXV2n2Kpmq+ulr?=
 =?iso-8859-1?Q?ZxmpOKF+pIvveYG3l16YIcz3WsIB58SYe6a+keaCjaZCgN0GaPDzJ8R1jP?=
 =?iso-8859-1?Q?fRZc3kiGVyfBzXHaURPBwXq/WF2TYng4D7sSrQh++eV++bb0V0Ls+N6CGo?=
 =?iso-8859-1?Q?C7ZMFBiRPsDFUpuZs2F8smX+UrPXmq4Ns/DQshcEjMTbNinxA5vXNyfnny?=
 =?iso-8859-1?Q?9d2nj1/shI5sXpnkVP2iKcNt+qwhBMbkvL15f4r2EDQYlBjq9QosbcKNy/?=
 =?iso-8859-1?Q?ceojwLf+UNSgYstaOLYfbzTXFFWL0ggeOHlbno9IvzPGkSTCuYVoMfONAA?=
 =?iso-8859-1?Q?LGGlCyTcQSH5ypvZatwlRXPm9X4FlRznGxWcpR/o7PF0woQFdUn9RXUNdU?=
 =?iso-8859-1?Q?hRT6yocCKADYawDt8OwztudXceQlnIGCyosCNaPOZ3ejfruL99rYNQ2G0h?=
 =?iso-8859-1?Q?xZx0SR+Yda3E3E+v+LszS70h37l8ym1eS9fFV+Q95Nm1nQr7UQqFhVObxg?=
 =?iso-8859-1?Q?gV6CJIb/kpihQNnwlmDBmGsJGyWfqnxK9zDSluIXUvIwd0PVBPm+Fd1pw/?=
 =?iso-8859-1?Q?CJVeWinl38wnR4YE2on43B4k3ia/x/UPhEXVwXteSOIIudg679b6ZzUYSs?=
 =?iso-8859-1?Q?sFNdONBnfVpNVLYKL/mOLv52uPv2C1S5wWsnxg70/jEsgwM+4r7buWoHWa?=
 =?iso-8859-1?Q?JWDtAPmtU7Yh4Mi66BC2flDt9CFtc8rUKk/RjJWR619RaP+AINYvIvdAse?=
 =?iso-8859-1?Q?Tn7BHU4xrWr/n6FgrzklKB9jRQ7avVcRwMI7lrlJG8dRedAPEEPgI4t7ui?=
 =?iso-8859-1?Q?87nKLyERDUDStIKA6BvjgXG+kApm62/lSMLcvuY7IxwhrHblchW7jj7T8y?=
 =?iso-8859-1?Q?zlohGFpl6QP8yibpg1TJ1FY+OOft4WQbCUbAJKTgBFBssRh+He81RZ7eoK?=
 =?iso-8859-1?Q?fUXgYoRGYT/G9pDp5FDf6ybQBy0rUgmHP51oVEB2RiIVrtKnw09/bTlDrS?=
 =?iso-8859-1?Q?30ZL9ctx/EI+ardFcsrSuP5LOEjemrMk9XGm2cqE6FE2fcdDSo3FtasUDG?=
 =?iso-8859-1?Q?tfDmDBMMzE34KxQ5itE0vXBfezB3oWu9FL9+sLAv08D7NVz6f2dcqggm9j?=
 =?iso-8859-1?Q?YMYnNjYpVxs5PahM0IhMyzIUjITLf1kb7D54jiClWxrcrPHPNtuWfApDfP?=
 =?iso-8859-1?Q?+I3lLpLLMGVw1f0/L1xP3cz3+E/QDezRvY+U2TBHsLVCFKY5POF4XdOCcE?=
 =?iso-8859-1?Q?9AGpnsu79lArQ2fUPtSDejegKdNCKQTu5SNlv7ca5Di/ziACxMB8AlLbUq?=
 =?iso-8859-1?Q?k3DAQKcG/DOgwpHU/m70VpvRlu0Xa2SJDyxHqml0vBn4SRzzmcIlCZzfn4?=
 =?iso-8859-1?Q?6Zu+z9XDPnYqx+WSmZ7mWFqwXy7uuk7VN3HStfrf9hiyJG/NtPazwa3Pfn?=
 =?iso-8859-1?Q?Ub+z/m7JGlZuGwV3pPl7eESUmEheGC82ib9MDdA1RgYuSLueAFTBb/K+uK?=
 =?iso-8859-1?Q?+valJx70k7wI1H71kiG4wcXDlWoo11xzGe5VvKpgXWzw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?QWlYp9Ru9GlZ4y3xibADicu6pih6LvfOd1Koe45hD1DWo/DU5pAakujkDg?=
 =?iso-8859-1?Q?1G1vQ2wuvmzB+rjqkKEzK2M10zQNV4qm8TLBbGuYP5mNgBleYHyfTufH8u?=
 =?iso-8859-1?Q?WJLs5Q9KaPvuAg45MekgntkVpEMACFNUR/YdO4yKHUGdSfXMkZQlTy98De?=
 =?iso-8859-1?Q?t5QAK4NT1tJvEqprTTTdrd35MnhluR/b4rE1we7bUH9NxUgr3DHArpB9pC?=
 =?iso-8859-1?Q?5Ae/thkW4BYtRSx311/3pKlWNIuqD5MAq7AU+6T8cCgHB5vCDHh238YjnO?=
 =?iso-8859-1?Q?ilagO4OlHa0KgaDnJGW99ogibQf2Sr9sOSklxwWaVOhXOslKCJQP0pstgN?=
 =?iso-8859-1?Q?kwt4ugA1I20i7eOrGDBwAxraBxVfWTB0X8Ma5PUTYtVY4Pr+YuMN3i1F3q?=
 =?iso-8859-1?Q?WeC7JWtApla4Rrn6BAUVXW0clOMkwQbBMZHB3cHZlzbzXxx3gFyN/3KR5M?=
 =?iso-8859-1?Q?bRx6aLyrCr9jIcZN0AbtlqBDZ4jdQH5fptKWaD4yXk8ORY5PX0pthHNJDd?=
 =?iso-8859-1?Q?mt9Uhdf64rl3qlH7tVNP6T1yHsqjS4A0jizLwFX8a6f8+DisnwBfxarnK0?=
 =?iso-8859-1?Q?ouW3VHD/KesliUGtn2jhslWjbRe3RD3781T53OhBxDVE/I8I+w8Azmwb9P?=
 =?iso-8859-1?Q?bHSfe+0Lhby0t6RtMarMtDp6XthHCpRLsM19KYcUtzg4+aAjMVDxbcCaXQ?=
 =?iso-8859-1?Q?CXNXAFoNvd76k9YAiG+RjB1GhvL2FoCikI3J14/wZVXUrARnpwMj0Pn0uw?=
 =?iso-8859-1?Q?MpIboT0nJwLu4W1pmAQaQlqXODfRWs3WEM54e8SGCgTe7vFyTHAWDUZLry?=
 =?iso-8859-1?Q?0kJsvO+qqyyqEXvU0YZNqxA33QzDJJp4e4FgJhLsGJxv9XNPW8f06c7JQJ?=
 =?iso-8859-1?Q?AHns39L1N40s80HD/76J4Bk8+z0WoaidfGJpP6WyDBmk71C9aAc0xDSRZc?=
 =?iso-8859-1?Q?qUkpiuU76R7oyqoCTjx0nTd5sn9gqL1D4/3otBiSy8eYrqY4f7PdPExnQC?=
 =?iso-8859-1?Q?d9N0usp6g6RGHmIsBwxseNDL4TmYe5FTFQm4OVrWfL1k1cWAb5ovK369uV?=
 =?iso-8859-1?Q?rqyAzmzq9qvlurRKrcot6QsBZYkx1IqIqul8tqigVWbkJUtIn2Yf4iErRk?=
 =?iso-8859-1?Q?E5OqS/cbrHMFz2PwzFWvAGRbXJFOmncEOaOJkAUCHI0w6NCb1QKFOBSTUJ?=
 =?iso-8859-1?Q?P0tmUEAVHK2j3uQ7nOdnBzLbk7/effIdDXrc0c7E1ICsQpNAZXAa48NHPl?=
 =?iso-8859-1?Q?dKNpIL0dVUeeJx5WuTWQeef2YK3iuYn9C//9pmoNM092H4eDYgFeo/tq1s?=
 =?iso-8859-1?Q?aP86srh0zpa8dDEqUPIdvreyPhbWCL0ivlnLlb+sn+gm6Cwi0QglZcZLMP?=
 =?iso-8859-1?Q?POw097qigHZLjksdHqEWEg1+ejjC/woz/S4k7byiQtUJ1WFYiPofQd4qK7?=
 =?iso-8859-1?Q?VjgOV+bvX8+malAJYB3KmeP7X8VzWrVwWVWDmpRjgmqIQzxbd+8UDiZGIN?=
 =?iso-8859-1?Q?47aOyp2t/C2cD6f9L4+/PYN/uDZlk0JGov/aGzMXdSvsP+gtkytzgxUEyc?=
 =?iso-8859-1?Q?xmfEEumrdSFcKPkSVapVyiVwKAZRmg819KQMF3spu1YGyW7wxsIXEGfxCb?=
 =?iso-8859-1?Q?4I9akuGChoI/ru8MPjwxLXGFiR0owp/gGc6SUv1qBAVOpEufDk14+opQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b870a631-c589-42ab-c360-08de2c34d660
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 15:10:58.3670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t95YjZOMlKxyN6qU6B/MUkydzAacEuI6uMTRdXYokqybooRN9aawPK2n8fLmSxEIASUuHUay0FqEXnLsE1IqNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7728
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B56AC18000F
X-Stat-Signature: 51u6ytyj1rgpqyqgryz1gr53iqrp6nix
X-Rspam-User: 
X-HE-Tag: 1764083469-637198
X-HE-Meta: U2FsdGVkX18Fkv2deZ4OhojV0pdQ/RSEFKrqmHSGTZlPLqKsK6odRf9LhsPzKRYYm5TXeRPP5RQc6Qb8t1tcG4/mEzzQu/VKJO3oysXPNy9p7FaPHi2zAUWWLMT4XbLQ08UG3cASFeNy+ER9wIlFktrwpqUyopSfyY5F5Hv6JEgH9vgP2sd8OWyj2yWHO20TqFKJVGut/p4XtzPUvLn5TK+gBmhxYWqgXGngp1AaY57kLCMqaesLD47CtrcaflKsGE63NQiJQ9LZw7VxNHk3pHmulDJS+Rzuh2WqdNiNPEiL7eIWVSrhUkPnX94uuAqrd2Q5IDUkjGv5x+vS+kRwxSNW+nI0bEuMDzoMMR5mNMYtC6uEz2A0eti7RAp1SMHobYKgm1wXIExol1uFJD+KeXqyWzrBTeNc9bUEZbRHcyCzlg3aX25hLdt6Cxk32os6AkbdumZ3uyrcz6fJahF6jKROixJQpixLjg8JvjgdJVuvUdNojL+4Tz278a1GfmWleVO6FvT+G0xowL6iVSnhxg8EZoIr9e90y64YuTME0SDhyxPAWRijy22gHx18RZWJrb6sY8Lc5omViA+UgkX+JZO7nfNcJpaOUuBpzK6ZiB1++Nexn3msbOMPLeKuOm8RgIqetTrA5FyLDWS0pvX4DduGhfsjvrdzYN9N2+N1UuI5fRwHnwNX9QO8+VqIx6yoXaedDp5goWXoSTnaVLDOos1rUtfutIioa1nu/QXIdPuB7drOVTCuNmzcVq2iBAbELaTT0rrkASiZDD1xtuDMnRtO/2Zkfo45g8LMK0ZPwt+4QISMWwU/ULyGwRhqYrUo3pKPH93y3psNnFxv3LR93kqN+zVRtlbqrs84UMVhaZ4ZTzsp+ffjnapJanhlTaWNj07hDK4myM21Qrx+VckMQ84dQU2ROJS0RtfyDhQsuntohh2IA9YnVI/e8cfGsFt9AfFsBByDMyjITil5Zuf
 ZYc2LCvo
 phHjUcqprLthWltMPsqphmrHDWZKdg57dznXcNE2WOc0bV0GxzSHU/zn5P6dDafLf59nPXWp0jSUrq+4BLATQa1pjkUknRXh6MHCSWfMQ/heYSresZ+GM1kc5KaoxZLQIqR4jR5pG9QFNAy3VUM3u2mZVh6dpA73Ma8YnWCfK3jm5XMcie8th9CUskTLpRKKsztlhiU4fLWOOrwRQQVxjazBrh1kSMYhwL9sZ8lzNjkUpKEb54csNSO5HK2Vg6kIFvvYTgZk6+JZrTbNeqxaA9s2+7pxnNyap1n7ruXhINV/7gc+STycCksVPqkiR11DJewZHqqZsaDNdH0Jn8GcuUhnvAQIfKbGxhAiCBJ0tjmuihw7j0GHWmM0jcZ/plfLOxtsI3F+zwlDNv8oThoHBnzCTwL1Jz/66Pl/YWFeaS9qjagjzINK4c6KWtTSciDVeWoDkqourazLty84x0dUhP3LnBqikMOlgTpy7od3nR8P+i1dO7VtS96w+CJEOHgxWN/YDSTbOZO38HGnnjzyrgpqBIM6nuXIGanvqmbWjIuzOHrhz9yhRSNNnllM5bSpM6HuKVq6m1gYAHYZ3whqOO1ZOKTcO81Z6NWayR7Oh/iD5mF/kqe4Nxn/rn9qBD1AgSIezSWReIoWGpX/NbN4pW5mOfsR725Mo5vi/p4pFbFOVv/FXFQpxBsVj8JpkzmHEP+Udx9uw/RqfTFxw8i+iwDmJmqM+SFKQ3P94N2oqCKnDSF8fEVny4k7r/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 9.6% regression of will-it-scale.per_process_ops on:


commit: 91e691296646e68d4116b8303aa11d6de0376aef ("mm/page_alloc: batch page freeing in free_frozen_page_commit")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[still regression on linux-next/master d724c6f85e80a23ed46b7ebc6e38b527c09d64f5]

testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory
parameters:

	nr_task: 100%
	mode: process
	test: malloc1
	cpufreq_governor: performance




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202511252236.31d04f3e-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251125/202511252236.31d04f3e-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp2/malloc1/will-it-scale

commit: 
  fc4b909c36 ("mm/page_alloc: batch page freeing in decay_pcp_high")
  91e6912966 ("mm/page_alloc: batch page freeing in free_frozen_page_commit")

fc4b909c368f3a7b 91e691296646e68d4116b8303aa 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    206433 ±  6%     -32.7%     138892 ± 15%  cpuidle..usage
 6.544e+09            -9.9%  5.898e+09        numa-numastat.node1.local_node
 6.545e+09            -9.9%  5.899e+09        numa-numastat.node1.numa_hit
   2459941 ± 50%     +58.5%    3898240 ± 45%  numa-meminfo.node1.FilePages
    507990 ± 13%     +30.0%     660169 ±  4%  numa-meminfo.node1.Mapped
   1833312           +16.6%    2137608 ±  2%  numa-meminfo.node1.Shmem
  18243104 ±  3%     -11.5%   16149534 ±  2%  sched_debug.cfs_rq:/.avg_vruntime.min
  18243191 ±  3%     -11.5%   16149615 ±  2%  sched_debug.cfs_rq:/.min_vruntime.min
      1002 ±  6%     -19.4%     808.30 ±  9%  sched_debug.cpu.clock_task.stddev
  65929642           +15.7%   76305261        turbostat.IRQ
    458.61            -2.0%     449.23        turbostat.PkgWatt
     41.81            -5.6%      39.47        turbostat.RAMWatt
  14583208            -9.6%   13187893        will-it-scale.192.processes
     75953            -9.6%      68686        will-it-scale.per_process_ops
  14583208            -9.6%   13187893        will-it-scale.workload
   2697962           +13.6%    3064667        meminfo.Active
   2697938           +13.6%    3064643        meminfo.Active(anon)
    573629 ± 10%     +23.3%     707368 ±  4%  meminfo.Mapped
   1842533           +18.7%    2187453 ±  2%  meminfo.Shmem
      0.23            -0.0        0.20        mpstat.cpu.all.irq%
     16.16           +15.3       31.45        mpstat.cpu.all.soft%
     80.30           -14.8       65.55        mpstat.cpu.all.sys%
      2.69            -0.5        2.21        mpstat.cpu.all.usr%
    615011 ± 50%     +58.5%     974734 ± 45%  numa-vmstat.node1.nr_file_pages
    126884 ± 14%     +30.2%     165141 ±  5%  numa-vmstat.node1.nr_mapped
    458354           +16.6%     534576 ±  2%  numa-vmstat.node1.nr_shmem
 6.545e+09            -9.9%  5.899e+09        numa-vmstat.node1.numa_hit
 6.544e+09            -9.9%  5.898e+09        numa-vmstat.node1.numa_local
      4208 ±  4%     +60.8%       6766 ±  4%  perf-c2c.DRAM.local
      1534 ±  8%     +69.4%       2598 ±  7%  perf-c2c.DRAM.remote
     29689 ±  4%     +48.1%      43973 ±  5%  perf-c2c.HITM.local
    554.50 ±  9%     +94.5%       1078 ±  3%  perf-c2c.HITM.remote
     30244 ±  4%     +49.0%      45051 ±  4%  perf-c2c.HITM.total
      4.64 ±  5%     +24.4%       5.78 ±  9%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    186.08 ± 15%    +164.0%     491.26 ± 74%  perf-sched.sch_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      4.64 ±  5%     +24.4%       5.78 ±  9%  perf-sched.total_sch_delay.average.ms
    186.08 ± 15%    +164.0%     491.26 ± 74%  perf-sched.total_sch_delay.max.ms
     92.26 ±  4%      -9.9%      83.10 ±  5%  perf-sched.total_wait_and_delay.average.ms
      4890 ±  2%     -12.6%       4273 ± 13%  perf-sched.total_wait_and_delay.max.ms
     87.62 ±  5%     -11.7%      77.33 ±  5%  perf-sched.total_wait_time.average.ms
      4888 ±  2%     -12.6%       4273 ± 13%  perf-sched.total_wait_time.max.ms
     92.26 ±  4%      -9.9%      83.10 ±  5%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      4890 ±  2%     -12.6%       4273 ± 13%  perf-sched.wait_and_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     87.62 ±  5%     -11.7%      77.33 ±  5%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      4888 ±  2%     -12.6%       4273 ± 13%  perf-sched.wait_time.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    674557           +13.6%     766573        proc-vmstat.nr_active_anon
    214716            +2.5%     220167        proc-vmstat.nr_anon_pages
   1374221            +6.3%    1460788        proc-vmstat.nr_file_pages
     36131            -1.0%      35765        proc-vmstat.nr_kernel_stack
    143405 ± 11%     +23.5%     177053 ±  4%  proc-vmstat.nr_mapped
    460675           +18.8%     547242 ±  2%  proc-vmstat.nr_shmem
    414554            -3.5%     399875        proc-vmstat.nr_slab_unreclaimable
    674557           +13.6%     766573        proc-vmstat.nr_zone_active_anon
 1.322e+10            -9.5%  1.197e+10        proc-vmstat.numa_hit
 1.321e+10            -9.5%  1.196e+10        proc-vmstat.numa_local
  1.33e+10            -9.4%  1.205e+10        proc-vmstat.pgalloc_normal
 4.392e+09            -9.5%  3.975e+09        proc-vmstat.pgfault
 1.329e+10            -9.4%  1.204e+10        proc-vmstat.pgfree
      3.66            -2.1%       3.58        perf-stat.i.MPKI
 8.586e+10            -8.2%  7.884e+10        perf-stat.i.branch-instructions
  90110201            -7.9%   82960676        perf-stat.i.branch-misses
 1.488e+09           -10.1%  1.337e+09        perf-stat.i.cache-misses
 1.734e+09            -9.8%  1.564e+09        perf-stat.i.cache-references
      8256            +6.5%       8791        perf-stat.i.context-switches
      1.50            +9.3%       1.64        perf-stat.i.cpi
    411.41           +11.7%     459.35        perf-stat.i.cycles-between-cache-misses
  4.07e+11            -8.3%  3.734e+11        perf-stat.i.instructions
      0.67            -8.4%       0.61        perf-stat.i.ipc
    150.37            -9.8%     135.62        perf-stat.i.metric.K/sec
  14460151            -9.6%   13065829        perf-stat.i.minor-faults
  14460151            -9.6%   13065829        perf-stat.i.page-faults
      3.66            -2.0%       3.58        perf-stat.overall.MPKI
      1.50            +9.3%       1.64        perf-stat.overall.cpi
    411.27           +11.5%     458.65        perf-stat.overall.cycles-between-cache-misses
      0.67            -8.5%       0.61        perf-stat.overall.ipc
   8456676            +1.7%    8598204        perf-stat.overall.path-length
 8.542e+10            -8.4%  7.824e+10        perf-stat.ps.branch-instructions
  89606265            -8.2%   82288752        perf-stat.ps.branch-misses
  1.48e+09           -10.3%  1.327e+09        perf-stat.ps.cache-misses
 1.725e+09           -10.0%  1.552e+09        perf-stat.ps.cache-references
      8215            +6.0%       8711        perf-stat.ps.context-switches
 4.049e+11            -8.5%  3.706e+11        perf-stat.ps.instructions
  14380750            -9.8%   12967064        perf-stat.ps.minor-faults
  14380750            -9.8%   12967064        perf-stat.ps.page-faults
 1.233e+14            -8.1%  1.134e+14        perf-stat.total.instructions
     11.94 ±  5%      -5.1        6.84 ±  8%  perf-profile.calltrace.cycles-pp.rmqueue_pcplist.rmqueue.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol
     11.55 ±  5%      -4.9        6.63 ±  8%  perf-profile.calltrace.cycles-pp.__rmqueue_pcplist.rmqueue_pcplist.rmqueue.get_page_from_freelist.__alloc_frozen_pages_noprof
     10.34 ±  6%      -4.4        5.94 ±  9%  perf-profile.calltrace.cycles-pp.rmqueue_bulk.__rmqueue_pcplist.rmqueue_pcplist.rmqueue.get_page_from_freelist
     11.11 ±  5%      -4.2        6.94 ±  8%  perf-profile.calltrace.cycles-pp.rmqueue.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof
     33.44            -3.9       29.56        perf-profile.calltrace.cycles-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     33.01            -3.9       29.15        perf-profile.calltrace.cycles-pp.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
     33.62            -3.8       29.77        perf-profile.calltrace.cycles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     34.50            -3.8       30.67        perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault
     34.44            -3.8       30.63        perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     34.75            -3.8       30.94        perf-profile.calltrace.cycles-pp.asm_exc_page_fault
     36.73            -3.5       33.26        perf-profile.calltrace.cycles-pp.__munmap
     35.97            -3.5       32.51        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     35.98            -3.5       32.52        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     35.72            -3.4       32.28        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
     35.55            -3.4       32.11        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
     36.15            -3.4       32.72        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
     36.12            -3.4       32.69        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     31.06            -3.3       27.72        perf-profile.calltrace.cycles-pp.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
     31.80            -3.3       28.50        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      4.44 ±  6%      -3.0        1.47 ± 15%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.rmqueue_bulk.__rmqueue_pcplist
      4.44 ±  6%      -3.0        1.47 ± 15%  perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.rmqueue_bulk
      4.45 ±  6%      -3.0        1.48 ± 15%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.rmqueue_bulk.__rmqueue_pcplist.rmqueue_pcplist.rmqueue
      4.45 ±  6%      -3.0        1.48 ± 15%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.rmqueue_bulk.__rmqueue_pcplist.rmqueue_pcplist
      5.06 ±  5%      -2.7        2.33 ±  9%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      5.06 ±  5%      -2.7        2.33 ±  9%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
     13.06 ±  2%      -2.6       10.41 ±  3%  perf-profile.calltrace.cycles-pp.__pte_alloc.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
     12.43 ±  2%      -2.6        9.83 ±  3%  perf-profile.calltrace.cycles-pp.pte_alloc_one.__pte_alloc.do_anonymous_page.__handle_mm_fault.handle_mm_fault
     12.31 ±  2%      -2.6        9.72 ±  3%  perf-profile.calltrace.cycles-pp.alloc_pages_noprof.pte_alloc_one.__pte_alloc.do_anonymous_page.__handle_mm_fault
     12.25 ±  2%      -2.6        9.66 ±  3%  perf-profile.calltrace.cycles-pp.alloc_pages_mpol.alloc_pages_noprof.pte_alloc_one.__pte_alloc.do_anonymous_page
     12.20 ±  2%      -2.6        9.62 ±  3%  perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.pte_alloc_one.__pte_alloc
     11.18 ±  3%      -2.5        8.70 ±  3%  perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.pte_alloc_one
      7.36 ±  4%      -2.2        5.18 ±  5%  perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      7.31 ±  4%      -2.2        5.13 ±  5%  perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas
      7.23 ±  4%      -2.2        5.05 ±  5%  perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.vms_clear_ptes
      8.20 ±  4%      -2.2        6.04 ±  4%  perf-profile.calltrace.cycles-pp.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      6.12 ±  5%      -2.1        4.01 ±  6%  perf-profile.calltrace.cycles-pp.tlb_remove_table.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables
      5.97 ±  5%      -2.1        3.88 ±  7%  perf-profile.calltrace.cycles-pp.get_free_pages_noprof.tlb_remove_table.free_pud_range.free_p4d_range.free_pgd_range
      5.96 ±  5%      -2.1        3.87 ±  7%  perf-profile.calltrace.cycles-pp.alloc_pages_noprof.get_free_pages_noprof.tlb_remove_table.free_pud_range.free_p4d_range
      5.92 ±  5%      -2.1        3.83 ±  7%  perf-profile.calltrace.cycles-pp.alloc_pages_mpol.alloc_pages_noprof.get_free_pages_noprof.tlb_remove_table.free_pud_range
      5.86 ±  5%      -2.1        3.78 ±  7%  perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.get_free_pages_noprof.tlb_remove_table
      5.78 ±  5%      -2.1        3.71 ±  7%  perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.get_free_pages_noprof
     17.78            -1.0       16.76        perf-profile.calltrace.cycles-pp.tlb_finish_mmu.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      9.21            -0.8        8.37        perf-profile.calltrace.cycles-pp.flush_tlb_func.flush_tlb_mm_range.tlb_finish_mmu.vms_clear_ptes.vms_complete_munmap_vmas
      9.03            -0.8        8.22        perf-profile.calltrace.cycles-pp.native_flush_tlb_one_user.flush_tlb_func.flush_tlb_mm_range.tlb_finish_mmu.vms_clear_ptes
      9.98            -0.6        9.36 ±  2%  perf-profile.calltrace.cycles-pp.flush_tlb_mm_range.tlb_finish_mmu.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      9.57            -0.6        9.02 ±  3%  perf-profile.calltrace.cycles-pp.__mmap
      0.96 ±  5%      -0.5        0.43 ± 44%  perf-profile.calltrace.cycles-pp.rmqueue.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof
      2.46 ±  2%      -0.5        1.96        perf-profile.calltrace.cycles-pp.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      8.38 ±  2%      -0.5        7.87 ±  3%  perf-profile.calltrace.cycles-pp.do_mmap.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
      8.90 ±  2%      -0.5        8.40 ±  3%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__mmap
      8.86 ±  2%      -0.5        8.37 ±  3%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
      6.25            -0.5        5.77 ±  3%  perf-profile.calltrace.cycles-pp.clear_page_erms.prep_new_page.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol
      8.68 ±  2%      -0.5        8.20 ±  3%  perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
      2.11 ±  2%      -0.5        1.64        perf-profile.calltrace.cycles-pp.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page.__handle_mm_fault
      2.14 ±  2%      -0.5        1.67        perf-profile.calltrace.cycles-pp.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      2.08 ±  2%      -0.5        1.60        perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page
      2.02 ±  2%      -0.5        1.55        perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio
      5.43            -0.4        4.99 ±  3%  perf-profile.calltrace.cycles-pp.prep_new_page.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof
      5.19 ±  2%      -0.4        4.77 ±  5%  perf-profile.calltrace.cycles-pp.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff.do_syscall_64
      7.35 ±  2%      -0.4        6.93 ±  3%  perf-profile.calltrace.cycles-pp.__mmap_region.do_mmap.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.54 ±  3%      -0.3        2.27 ±  6%  perf-profile.calltrace.cycles-pp.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      2.27 ±  3%      -0.2        2.04 ±  6%  perf-profile.calltrace.cycles-pp.mas_alloc_nodes.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
      2.61            -0.2        2.42 ±  3%  perf-profile.calltrace.cycles-pp.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      4.94            -0.2        4.79        perf-profile.calltrace.cycles-pp.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      2.93            -0.1        2.78        perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes
      4.82            -0.1        4.67        perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      0.72 ±  7%      -0.1        0.59 ±  7%  perf-profile.calltrace.cycles-pp.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      4.65            -0.1        4.52        perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas
      0.80            -0.1        0.70 ±  2%  perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.__get_unmapped_area.do_mmap.vm_mmap_pgoff.do_syscall_64
      0.90            -0.1        0.80 ±  2%  perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.37            -0.1        1.28 ±  2%  perf-profile.calltrace.cycles-pp.__vmf_anon_prepare.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      1.19            -0.1        1.11        perf-profile.calltrace.cycles-pp.__anon_vma_prepare.__vmf_anon_prepare.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      0.65            -0.1        0.58 ±  3%  perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      0.64            -0.1        0.58 ±  2%  perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.__get_unmapped_area.do_mmap
      0.74            -0.1        0.68        perf-profile.calltrace.cycles-pp.__cond_resched.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes
      0.62            -0.0        0.57 ±  2%  perf-profile.calltrace.cycles-pp.pmd_install.__pte_alloc.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      0.88            -0.0        0.84 ±  2%  perf-profile.calltrace.cycles-pp.prep_new_page.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof
      0.79            -0.0        0.75        perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff.do_syscall_64
      0.62            -0.0        0.59        perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff
      0.92            +0.1        0.99 ±  2%  perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      0.62 ±  5%      +0.2        0.86 ±  7%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.flush_tlb_mm_range.tlb_finish_mmu
      0.62 ±  5%      +0.2        0.86 ±  7%  perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.flush_tlb_mm_range
      0.64 ±  5%      +0.2        0.88 ±  6%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.flush_tlb_mm_range.tlb_finish_mmu.vms_clear_ptes.vms_complete_munmap_vmas
      0.64 ±  5%      +0.2        0.88 ±  6%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.flush_tlb_mm_range.tlb_finish_mmu.vms_clear_ptes
      0.26 ±100%      +0.5        0.74 ±  6%  perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
      0.00            +0.7        0.73 ±  9%  perf-profile.calltrace.cycles-pp.__put_partials.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
      1.42 ±  3%      +0.8        2.25 ±  2%  perf-profile.calltrace.cycles-pp.tlb_remove_table_rcu.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      0.97 ±  4%      +0.9        1.92 ±  3%  perf-profile.calltrace.cycles-pp.__free_frozen_pages.tlb_remove_table_rcu.rcu_do_batch.rcu_core.handle_softirqs
      0.71 ±  6%      +1.0        1.66 ±  4%  perf-profile.calltrace.cycles-pp.free_pcppages_bulk.free_frozen_page_commit.__free_frozen_pages.tlb_remove_table_rcu.rcu_do_batch
      0.67 ±  6%      +1.0        1.62 ±  4%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.free_pcppages_bulk.free_frozen_page_commit.__free_frozen_pages.tlb_remove_table_rcu
      0.79 ±  5%      +1.0        1.76 ±  3%  perf-profile.calltrace.cycles-pp.free_frozen_page_commit.__free_frozen_pages.tlb_remove_table_rcu.rcu_do_batch.rcu_core
      0.76 ±  5%      +1.1        1.87 ±  5%  perf-profile.calltrace.cycles-pp.free_pcppages_bulk.free_frozen_page_commit.__free_frozen_pages.rcu_do_batch.rcu_core
      0.89 ±  4%      +1.1        2.00 ±  5%  perf-profile.calltrace.cycles-pp.__free_frozen_pages.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      0.72 ±  5%      +1.1        1.83 ±  5%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.free_pcppages_bulk.free_frozen_page_commit.__free_frozen_pages.rcu_do_batch
      0.82 ±  5%      +1.1        1.93 ±  5%  perf-profile.calltrace.cycles-pp.free_frozen_page_commit.__free_frozen_pages.rcu_do_batch.rcu_core.handle_softirqs
     13.28 ±  3%      +6.3       19.56 ±  3%  perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
     12.10 ±  3%      +6.6       18.66 ±  3%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.free_pcppages_bulk.free_frozen_page_commit.__free_frozen_pages.__kmem_cache_free_bulk
     12.37 ±  3%      +6.6       18.94 ±  3%  perf-profile.calltrace.cycles-pp.free_pcppages_bulk.free_frozen_page_commit.__free_frozen_pages.__kmem_cache_free_bulk.rcu_free_sheaf
     12.37 ±  3%      +6.6       18.97 ±  3%  perf-profile.calltrace.cycles-pp.free_frozen_page_commit.__free_frozen_pages.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch
     12.38 ±  3%      +6.6       18.98 ±  3%  perf-profile.calltrace.cycles-pp.__free_frozen_pages.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
     13.17 ±  2%      +6.9       20.12 ±  3%  perf-profile.calltrace.cycles-pp.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs
     17.40 ±  2%      +7.9       25.28 ±  2%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
     17.40 ±  2%      +7.9       25.28 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
     17.40 ±  2%      +7.9       25.28 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
     16.74 ±  2%      +8.0       24.71 ±  2%  perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
     16.74 ±  2%      +8.0       24.71 ±  2%  perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     16.74 ±  2%      +8.0       24.71 ±  2%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
     16.74 ±  2%      +8.0       24.71 ±  2%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
     16.76 ±  2%      +8.0       24.73 ±  2%  perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     13.48 ±  3%      +9.1       22.58 ±  3%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.free_pcppages_bulk.free_frozen_page_commit.__free_frozen_pages
     20.60 ±  3%      -5.3       15.32 ±  3%  perf-profile.children.cycles-pp.alloc_pages_mpol
     20.46 ±  3%      -5.3       15.19 ±  3%  perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
     19.30 ±  3%      -5.2       14.15 ±  4%  perf-profile.children.cycles-pp.get_page_from_freelist
     12.26 ±  5%      -4.8        7.50 ±  7%  perf-profile.children.cycles-pp.rmqueue_pcplist
     12.38 ±  5%      -4.7        7.63 ±  7%  perf-profile.children.cycles-pp.rmqueue
     18.27 ±  3%      -4.7       13.60 ±  4%  perf-profile.children.cycles-pp.alloc_pages_noprof
     11.86 ±  5%      -4.7        7.19 ±  8%  perf-profile.children.cycles-pp.__rmqueue_pcplist
     10.64 ±  6%      -4.2        6.42 ±  9%  perf-profile.children.cycles-pp.rmqueue_bulk
     45.25            -3.9       41.32        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     45.18            -3.9       41.26        perf-profile.children.cycles-pp.do_syscall_64
     33.45            -3.9       29.57        perf-profile.children.cycles-pp.__handle_mm_fault
     33.02            -3.9       29.15        perf-profile.children.cycles-pp.do_anonymous_page
     33.62            -3.9       29.77        perf-profile.children.cycles-pp.handle_mm_fault
     34.50            -3.8       30.68        perf-profile.children.cycles-pp.exc_page_fault
     34.45            -3.8       30.63        perf-profile.children.cycles-pp.do_user_addr_fault
     34.98            -3.8       31.16        perf-profile.children.cycles-pp.asm_exc_page_fault
     36.87            -3.5       33.39        perf-profile.children.cycles-pp.__munmap
     35.98            -3.5       32.52        perf-profile.children.cycles-pp.__x64_sys_munmap
     35.97            -3.5       32.52        perf-profile.children.cycles-pp.__vm_munmap
      5.54 ±  5%      -3.4        2.09 ±  9%  perf-profile.children.cycles-pp.free_one_page
     35.73            -3.4       32.28        perf-profile.children.cycles-pp.do_vmi_munmap
     35.55            -3.4       32.12        perf-profile.children.cycles-pp.do_vmi_align_munmap
     31.07            -3.3       27.73        perf-profile.children.cycles-pp.vms_clear_ptes
     31.81            -3.3       28.51        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
     13.07 ±  2%      -2.6       10.42 ±  3%  perf-profile.children.cycles-pp.__pte_alloc
     12.43 ±  2%      -2.6        9.83 ±  3%  perf-profile.children.cycles-pp.pte_alloc_one
      7.37 ±  4%      -2.2        5.18 ±  5%  perf-profile.children.cycles-pp.free_pgd_range
      7.23 ±  4%      -2.2        5.06 ±  5%  perf-profile.children.cycles-pp.free_pud_range
      7.31 ±  4%      -2.2        5.13 ±  5%  perf-profile.children.cycles-pp.free_p4d_range
      8.21 ±  4%      -2.2        6.06 ±  4%  perf-profile.children.cycles-pp.free_pgtables
      6.13 ±  5%      -2.1        4.01 ±  6%  perf-profile.children.cycles-pp.tlb_remove_table
      5.97 ±  5%      -2.1        3.88 ±  7%  perf-profile.children.cycles-pp.get_free_pages_noprof
      9.77 ±  2%      -1.9        7.82 ±  2%  perf-profile.children.cycles-pp.__irq_exit_rcu
      9.95 ±  2%      -1.9        8.01 ±  2%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      9.97 ±  2%      -1.9        8.03 ±  2%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
     17.79            -1.0       16.76        perf-profile.children.cycles-pp.tlb_finish_mmu
      4.65 ±  3%      -0.9        3.73 ±  4%  perf-profile.children.cycles-pp.tlb_remove_table_rcu
      9.21            -0.8        8.37        perf-profile.children.cycles-pp.flush_tlb_func
      9.04            -0.8        8.23        perf-profile.children.cycles-pp.native_flush_tlb_one_user
      9.99            -0.6        9.37 ±  2%  perf-profile.children.cycles-pp.flush_tlb_mm_range
      9.69            -0.6        9.13 ±  3%  perf-profile.children.cycles-pp.__mmap
      2.46 ±  2%      -0.5        1.96        perf-profile.children.cycles-pp.alloc_anon_folio
      8.39 ±  2%      -0.5        7.88 ±  3%  perf-profile.children.cycles-pp.do_mmap
      6.33            -0.5        5.84 ±  3%  perf-profile.children.cycles-pp.prep_new_page
      8.69            -0.5        8.20 ±  3%  perf-profile.children.cycles-pp.vm_mmap_pgoff
      6.26            -0.5        5.78 ±  3%  perf-profile.children.cycles-pp.clear_page_erms
      2.15 ±  2%      -0.5        1.68        perf-profile.children.cycles-pp.vma_alloc_folio_noprof
      5.20 ±  2%      -0.4        4.78 ±  5%  perf-profile.children.cycles-pp.__mmap_new_vma
      7.37 ±  2%      -0.4        6.96 ±  3%  perf-profile.children.cycles-pp.__mmap_region
      3.21 ±  3%      -0.3        2.90 ±  5%  perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
      2.55 ±  3%      -0.3        2.28 ±  6%  perf-profile.children.cycles-pp.mas_preallocate
      2.51 ±  3%      -0.3        2.24 ±  6%  perf-profile.children.cycles-pp.mas_alloc_nodes
      0.87 ±  4%      -0.2        0.70 ±  4%  perf-profile.children.cycles-pp.rcu_cblist_dequeue
      0.64 ±  4%      -0.2        0.48 ±  4%  perf-profile.children.cycles-pp.___free_pages
      4.94            -0.2        4.79        perf-profile.children.cycles-pp.unmap_vmas
      2.94            -0.1        2.80        perf-profile.children.cycles-pp.zap_pte_range
      4.82            -0.1        4.68        perf-profile.children.cycles-pp.unmap_page_range
      0.73 ±  8%      -0.1        0.59 ±  7%  perf-profile.children.cycles-pp.___slab_alloc
      4.70            -0.1        4.57        perf-profile.children.cycles-pp.zap_pmd_range
      0.81            -0.1        0.71 ±  2%  perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      1.37            -0.1        1.28 ±  2%  perf-profile.children.cycles-pp.__vmf_anon_prepare
      0.90            -0.1        0.81 ±  2%  perf-profile.children.cycles-pp.__get_unmapped_area
      0.33 ±  2%      -0.1        0.24 ±  3%  perf-profile.children.cycles-pp.mas_wr_store_type
      1.20            -0.1        1.11        perf-profile.children.cycles-pp.__anon_vma_prepare
      0.29 ±  9%      -0.1        0.21 ±  7%  perf-profile.children.cycles-pp.allocate_slab
      0.43 ±  5%      -0.1        0.35 ±  2%  perf-profile.children.cycles-pp._raw_spin_trylock
      0.15 ± 13%      -0.1        0.08 ± 22%  perf-profile.children.cycles-pp.refresh_cpu_vm_stats
      0.15 ± 13%      -0.1        0.08 ± 22%  perf-profile.children.cycles-pp.vmstat_update
      0.65            -0.1        0.58 ±  3%  perf-profile.children.cycles-pp.vm_unmapped_area
      0.65            -0.1        0.58 ±  2%  perf-profile.children.cycles-pp.unmapped_area_topdown
      0.97            -0.1        0.90        perf-profile.children.cycles-pp.__cond_resched
      0.51 ±  3%      -0.1        0.45 ±  4%  perf-profile.children.cycles-pp.__kfree_rcu_sheaf
      0.86 ±  2%      -0.1        0.81 ±  4%  perf-profile.children.cycles-pp.kvfree_call_rcu
      0.47 ±  2%      -0.1        0.41 ±  3%  perf-profile.children.cycles-pp.vm_area_alloc
      0.10 ± 11%      -0.1        0.05 ± 46%  perf-profile.children.cycles-pp.folio_alloc_mpol_noprof
      0.10 ± 11%      -0.1        0.05 ± 46%  perf-profile.children.cycles-pp.shmem_alloc_folio
      0.26 ±  6%      -0.1        0.20 ±  3%  perf-profile.children.cycles-pp.free_unref_folios
      0.12 ± 17%      -0.1        0.07 ± 25%  perf-profile.children.cycles-pp.decay_pcp_high
      0.52            -0.0        0.48 ±  2%  perf-profile.children.cycles-pp.find_mergeable_anon_vma
      0.13 ± 10%      -0.0        0.08 ± 10%  perf-profile.children.cycles-pp.shmem_get_folio_gfp
      0.13 ± 10%      -0.0        0.08 ± 10%  perf-profile.children.cycles-pp.shmem_write_begin
      0.12 ± 10%      -0.0        0.08 ±  8%  perf-profile.children.cycles-pp.shmem_alloc_and_add_folio
      0.50            -0.0        0.45 ±  2%  perf-profile.children.cycles-pp.native_irq_return_iret
      0.62            -0.0        0.57 ±  2%  perf-profile.children.cycles-pp.pmd_install
      0.32 ±  2%      -0.0        0.28 ±  7%  perf-profile.children.cycles-pp.barn_get_empty_sheaf
      0.18 ±  9%      -0.0        0.14 ±  9%  perf-profile.children.cycles-pp.handle_internal_command
      0.18 ±  9%      -0.0        0.14 ±  9%  perf-profile.children.cycles-pp.main
      0.18 ±  9%      -0.0        0.14 ±  9%  perf-profile.children.cycles-pp.run_builtin
      0.49            -0.0        0.44        perf-profile.children.cycles-pp.entry_SYSCALL_64
      0.16 ±  9%      -0.0        0.12 ±  8%  perf-profile.children.cycles-pp.generic_perform_write
      0.47 ±  2%      -0.0        0.43 ±  3%  perf-profile.children.cycles-pp.page_counter_uncharge
      0.17 ±  9%      -0.0        0.13 ±  7%  perf-profile.children.cycles-pp.perf_mmap__push
      0.80            -0.0        0.76        perf-profile.children.cycles-pp.perf_event_mmap
      0.16 ±  9%      -0.0        0.12 ± 10%  perf-profile.children.cycles-pp.shmem_file_write_iter
      0.16 ±  9%      -0.0        0.12 ± 10%  perf-profile.children.cycles-pp.vfs_write
      0.17 ±  9%      -0.0        0.13 ±  9%  perf-profile.children.cycles-pp.record__mmap_read_evlist
      0.16 ±  8%      -0.0        0.12 ± 11%  perf-profile.children.cycles-pp.record__pushfn
      0.36            -0.0        0.32 ±  2%  perf-profile.children.cycles-pp.mas_prev_slot
      0.16 ±  9%      -0.0        0.12 ± 11%  perf-profile.children.cycles-pp.ksys_write
      0.40            -0.0        0.36 ±  2%  perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.63            -0.0        0.60        perf-profile.children.cycles-pp.perf_event_mmap_event
      0.44            -0.0        0.41 ±  2%  perf-profile.children.cycles-pp.__mem_cgroup_uncharge_folios
      0.31            -0.0        0.28 ±  5%  perf-profile.children.cycles-pp.mas_empty_area_rev
      0.39            -0.0        0.36 ±  3%  perf-profile.children.cycles-pp.uncharge_batch
      0.48 ±  2%      -0.0        0.44 ±  2%  perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      0.24 ±  2%      -0.0        0.21 ±  2%  perf-profile.children.cycles-pp.mas_rev_awalk
      0.38 ±  2%      -0.0        0.35 ±  3%  perf-profile.children.cycles-pp.perf_iterate_sb
      0.06            -0.0        0.03 ± 70%  perf-profile.children.cycles-pp.__vm_enough_memory
      0.24 ±  2%      -0.0        0.22 ±  3%  perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
      0.36 ±  2%      -0.0        0.34 ±  2%  perf-profile.children.cycles-pp.lock_vma_under_rcu
      0.28 ±  2%      -0.0        0.26 ±  3%  perf-profile.children.cycles-pp.zap_present_ptes
      0.23 ±  2%      -0.0        0.21 ±  2%  perf-profile.children.cycles-pp.__call_rcu_common
      0.30            -0.0        0.28 ±  4%  perf-profile.children.cycles-pp.mas_leaf_max_gap
      0.22 ±  2%      -0.0        0.20 ±  3%  perf-profile.children.cycles-pp.sync_regs
      0.18 ±  2%      -0.0        0.16 ±  2%  perf-profile.children.cycles-pp.error_entry
      0.09 ±  5%      -0.0        0.07 ±  7%  perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.32            -0.0        0.31 ±  4%  perf-profile.children.cycles-pp.mas_update_gap
      0.16 ±  3%      -0.0        0.14 ±  4%  perf-profile.children.cycles-pp.mod_node_page_state
      0.20            -0.0        0.18 ±  2%  perf-profile.children.cycles-pp.lru_gen_del_folio
      0.14 ±  3%      -0.0        0.12 ±  3%  perf-profile.children.cycles-pp.__memcg_kmem_uncharge_page
      0.14 ±  4%      -0.0        0.12 ±  5%  perf-profile.children.cycles-pp.folio_remove_rmap_ptes
      0.14 ±  3%      -0.0        0.13 ±  6%  perf-profile.children.cycles-pp.barn_replace_empty_sheaf
      0.14 ±  3%      -0.0        0.13 ±  3%  perf-profile.children.cycles-pp.charge_memcg
      0.12 ±  6%      -0.0        0.10 ±  8%  perf-profile.children.cycles-pp.may_expand_vm
      0.29 ±  2%      -0.0        0.27        perf-profile.children.cycles-pp.lru_add
      0.12 ±  4%      -0.0        0.10 ±  3%  perf-profile.children.cycles-pp.mas_prev
      0.06            +0.0        0.08 ±  6%  perf-profile.children.cycles-pp.security_mmap_file
      0.28 ±  2%      +0.0        0.30        perf-profile.children.cycles-pp.__free_one_page
      0.10 ±  3%      +0.0        0.14 ±  2%  perf-profile.children.cycles-pp.security_vm_enough_memory_mm
      0.72 ±  2%      +0.0        0.76 ±  2%  perf-profile.children.cycles-pp.mas_find
      0.05            +0.0        0.09 ±  5%  perf-profile.children.cycles-pp.vm_area_free
      0.11 ±  3%      +0.0        0.15 ± 12%  perf-profile.children.cycles-pp.irqentry_exit_to_user_mode
      0.02 ±141%      +0.0        0.06        perf-profile.children.cycles-pp.mas_wr_store_entry
      0.94            +0.1        1.01 ±  2%  perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      0.11 ±  4%      +0.1        0.18 ±  5%  perf-profile.children.cycles-pp.kfree
      0.00            +0.1        0.07 ±  5%  perf-profile.children.cycles-pp.vm_get_page_prot
      0.00            +0.1        0.08 ± 22%  perf-profile.children.cycles-pp.exit_to_user_mode_loop
      0.00            +0.1        0.12 ± 32%  perf-profile.children.cycles-pp.arch_do_signal_or_restart
      0.00            +0.2        0.15 ± 34%  perf-profile.children.cycles-pp.__local_bh_enable_ip
      0.00            +0.2        0.15 ± 34%  perf-profile.children.cycles-pp.do_softirq
      0.78 ±  6%      +0.3        1.11 ± 10%  perf-profile.children.cycles-pp.__put_partials
     49.02            +4.3       53.32 ±  2%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     48.84            +4.3       53.15 ±  2%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     26.52            +6.2       32.67 ±  2%  perf-profile.children.cycles-pp.rcu_core
     26.51            +6.2       32.66 ±  2%  perf-profile.children.cycles-pp.rcu_do_batch
     26.52            +6.2       32.68 ±  2%  perf-profile.children.cycles-pp.handle_softirqs
     16.55 ±  2%      +7.8       24.38 ±  3%  perf-profile.children.cycles-pp.rcu_free_sheaf
     16.26 ±  2%      +7.9       24.12 ±  3%  perf-profile.children.cycles-pp.__kmem_cache_free_bulk
     17.41 ±  2%      +7.9       25.28 ±  2%  perf-profile.children.cycles-pp.ret_from_fork
     17.41 ±  2%      +7.9       25.28 ±  2%  perf-profile.children.cycles-pp.ret_from_fork_asm
     17.40 ±  2%      +7.9       25.28 ±  2%  perf-profile.children.cycles-pp.kthread
     16.74 ±  2%      +8.0       24.71 ±  2%  perf-profile.children.cycles-pp.run_ksoftirqd
     16.76 ±  2%      +8.0       24.73 ±  2%  perf-profile.children.cycles-pp.smpboot_thread_fn
     17.17 ±  2%      +9.9       27.02 ±  2%  perf-profile.children.cycles-pp.free_pcppages_bulk
     17.73           +10.0       27.69 ±  2%  perf-profile.children.cycles-pp.__free_frozen_pages
     17.47 ±  2%     +10.0       27.45 ±  2%  perf-profile.children.cycles-pp.free_frozen_page_commit
      9.03            -0.8        8.22        perf-profile.self.cycles-pp.native_flush_tlb_one_user
      5.91            -0.6        5.30 ±  3%  perf-profile.self.cycles-pp.clear_page_erms
      0.79 ±  6%      -0.2        0.60 ±  5%  perf-profile.self.cycles-pp.__rmqueue_pcplist
      2.21            -0.2        2.04        perf-profile.self.cycles-pp.zap_pte_range
      0.87 ±  4%      -0.2        0.70 ±  5%  perf-profile.self.cycles-pp.rcu_cblist_dequeue
      0.64 ±  5%      -0.2        0.48 ±  4%  perf-profile.self.cycles-pp.___free_pages
      0.48 ±  7%      -0.1        0.35 ±  6%  perf-profile.self.cycles-pp.tlb_remove_table_rcu
      0.61            -0.1        0.51 ±  2%  perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      1.94            -0.1        1.85 ±  4%  perf-profile.self.cycles-pp.__pi_memcpy
      1.04            -0.1        0.95 ±  2%  perf-profile.self.cycles-pp.free_pud_range
      0.31            -0.1        0.22 ±  2%  perf-profile.self.cycles-pp.mas_wr_store_type
      0.62            -0.1        0.55        perf-profile.self.cycles-pp.__cond_resched
      0.49            -0.1        0.44 ±  2%  perf-profile.self.cycles-pp.pmd_install
      0.25 ±  5%      -0.1        0.20 ±  2%  perf-profile.self.cycles-pp.__alloc_frozen_pages_noprof
      0.57            -0.1        0.52        perf-profile.self.cycles-pp.mas_wr_node_store
      0.13            -0.1        0.08        perf-profile.self.cycles-pp.tlb_finish_mmu
      0.33            -0.0        0.29 ±  2%  perf-profile.self.cycles-pp.mas_prev_slot
      0.49            -0.0        0.45 ±  2%  perf-profile.self.cycles-pp.native_irq_return_iret
      0.44            -0.0        0.40 ±  3%  perf-profile.self.cycles-pp.page_counter_uncharge
      0.40            -0.0        0.36 ±  2%  perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.14 ±  2%      -0.0        0.10 ±  4%  perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
      0.31 ±  2%      -0.0        0.28 ±  3%  perf-profile.self.cycles-pp.perf_iterate_sb
      0.18 ±  2%      -0.0        0.15 ±  5%  perf-profile.self.cycles-pp.free_pcppages_bulk
      0.28 ±  2%      -0.0        0.25 ±  4%  perf-profile.self.cycles-pp.mas_leaf_max_gap
      0.11 ±  4%      -0.0        0.08 ±  4%  perf-profile.self.cycles-pp.may_expand_vm
      0.33 ±  2%      -0.0        0.30        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.16 ±  5%      -0.0        0.13 ±  5%  perf-profile.self.cycles-pp.__lruvec_stat_mod_folio
      0.24 ±  2%      -0.0        0.22 ±  3%  perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
      0.32            -0.0        0.30        perf-profile.self.cycles-pp._raw_spin_trylock
      0.26 ±  2%      -0.0        0.23 ±  3%  perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.23 ±  3%      -0.0        0.20 ±  2%  perf-profile.self.cycles-pp.__kfree_rcu_sheaf
      0.28 ±  2%      -0.0        0.25 ±  4%  perf-profile.self.cycles-pp.kvfree_call_rcu
      0.16            -0.0        0.14 ±  5%  perf-profile.self.cycles-pp.unlink_anon_vmas
      0.17            -0.0        0.15 ±  3%  perf-profile.self.cycles-pp.flush_tlb_func
      0.09 ±  5%      -0.0        0.06 ±  7%  perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.15 ±  2%      -0.0        0.13 ±  2%  perf-profile.self.cycles-pp.__call_rcu_common
      0.16 ±  2%      -0.0        0.14 ±  2%  perf-profile.self.cycles-pp.mas_preallocate
      0.22 ±  2%      -0.0        0.20 ±  3%  perf-profile.self.cycles-pp.sync_regs
      0.15 ±  2%      -0.0        0.13 ±  3%  perf-profile.self.cycles-pp.tlb_remove_table
      0.15 ±  3%      -0.0        0.13 ±  5%  perf-profile.self.cycles-pp.mod_node_page_state
      0.22 ±  2%      -0.0        0.20 ±  2%  perf-profile.self.cycles-pp.rcu_all_qs
      0.13 ±  2%      -0.0        0.11 ±  3%  perf-profile.self.cycles-pp.mas_rev_awalk
      0.14            -0.0        0.12 ±  3%  perf-profile.self.cycles-pp.vm_area_alloc
      0.18 ±  2%      -0.0        0.16 ±  3%  perf-profile.self.cycles-pp.up_write
      0.11 ±  3%      -0.0        0.09        perf-profile.self.cycles-pp.flush_tlb_mm_range
      0.18 ±  2%      -0.0        0.16 ±  4%  perf-profile.self.cycles-pp.__munmap
      0.12 ±  3%      -0.0        0.10        perf-profile.self.cycles-pp.barn_get_empty_sheaf
      0.17 ±  2%      -0.0        0.15 ±  2%  perf-profile.self.cycles-pp.find_mergeable_anon_vma
      0.15            -0.0        0.13 ±  3%  perf-profile.self.cycles-pp.error_entry
      0.12 ±  4%      -0.0        0.10 ±  3%  perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.19            -0.0        0.18 ±  4%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.19 ±  2%      -0.0        0.17 ±  2%  perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.23            -0.0        0.22 ±  2%  perf-profile.self.cycles-pp.mas_next_slot
      0.16            -0.0        0.14 ±  3%  perf-profile.self.cycles-pp.mas_store_prealloc
      0.09 ±  4%      -0.0        0.07 ±  6%  perf-profile.self.cycles-pp.do_mmap
      0.15 ±  3%      -0.0        0.14 ±  2%  perf-profile.self.cycles-pp.lock_vma_under_rcu
      0.18 ±  2%      -0.0        0.17 ±  3%  perf-profile.self.cycles-pp.unmapped_area_topdown
      0.20            -0.0        0.19 ±  2%  perf-profile.self.cycles-pp.up_read
      0.10            -0.0        0.09 ±  5%  perf-profile.self.cycles-pp.free_unref_folios
      0.18 ±  2%      -0.0        0.16 ±  2%  perf-profile.self.cycles-pp.__mmap
      0.16            -0.0        0.15 ±  3%  perf-profile.self.cycles-pp.lru_gen_del_folio
      0.10 ±  4%      -0.0        0.09        perf-profile.self.cycles-pp.__pte_offset_map_lock
      0.17            -0.0        0.16 ±  2%  perf-profile.self.cycles-pp.__vma_start_write
      0.14            -0.0        0.13 ±  2%  perf-profile.self.cycles-pp.asm_exc_page_fault
      0.09 ±  4%      -0.0        0.08        perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      0.11 ±  3%      -0.0        0.10        perf-profile.self.cycles-pp.down_write_killable
      0.15 ±  2%      -0.0        0.14        perf-profile.self.cycles-pp.__vm_munmap
      0.06            -0.0        0.05        perf-profile.self.cycles-pp.__folio_batch_add_and_move
      0.06            -0.0        0.05        perf-profile.self.cycles-pp.__mmap_new_vma
      0.06            -0.0        0.05        perf-profile.self.cycles-pp.mas_prev
      0.11            -0.0        0.10        perf-profile.self.cycles-pp.do_user_addr_fault
      0.17            +0.0        0.18 ±  2%  perf-profile.self.cycles-pp.mas_find
      0.55 ±  2%      +0.0        0.59        perf-profile.self.cycles-pp.get_page_from_freelist
      0.94            +0.0        0.97        perf-profile.self.cycles-pp.zap_pmd_range
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.kfree
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.mas_wr_store_entry
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.security_vm_enough_memory_mm
      0.00            +0.1        0.05 ±  8%  perf-profile.self.cycles-pp.vm_area_free
      0.00            +0.1        0.06 ±  7%  perf-profile.self.cycles-pp.vm_get_page_prot
      0.38            +0.1        0.44 ±  2%  perf-profile.self.cycles-pp.mas_store_gfp
     48.84            +4.3       53.15 ±  2%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


