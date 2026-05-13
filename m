Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CA9ACD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 14:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E2BD6B0005; Wed, 13 May 2026 10:20:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BAF86B0098; Wed, 13 May 2026 10:20:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 882F26B009B; Wed, 13 May 2026 10:20:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 748AC6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:20:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 039121C01A6
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:20:23 +0000 (UTC)
X-FDA: 84762606768.06.126AEF8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf28.hostedemail.com (Postfix) with ESMTP id BAB56C0012
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:20:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BMfoslug;
	spf=pass (imf28.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778682020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RbgceHN+Eh6K+RH11xoYbqobQRp4W/1+7THRuXI72ZI=;
	b=dSXh1DPM3/atXPGRTdslvH1W5DcnxskEeuunjlw8GbM4hafGkkozprIzQxX+CJMdjoSINa
	lb7196kES9KL5hWVKhu6QZdfKQ95YpMzYnZ8tImWQtnuo+F3utuDwsc2UJtD9LR+VhSq1F
	JXxYl4iULQs2HJaTsTBFYumLpgwVPxI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BMfoslug;
	spf=pass (imf28.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778682020; a=rsa-sha256;
	cv=fail;
	b=RMsBMbgtnKP/sj/nWoRlJBeM5thoyilwf1LLbiGlSJ5V+02I5DRhQj1L9yrYqQhKCFxqTB
	poqTU3MsIGl5gz8bUIcrGZuanAjYKQyPSf3wOmgSeD+RwwJKME900qKVN6ZziLgupvbtiB
	OY4w99h9zVSWXzZETVZhaqTSWAakTG0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778682020; x=1810218020;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=NOB8pR/cvT35ZYAIz93OYtR6MsqVet6W3hU7KD8IxCg=;
  b=BMfoslug9boA4wgXQNMMCGa/iM4eygHinXNQIOIinLZRWXor8MSkIBLO
   awoBKz74qV8j4SsdKNz9rq2nKGe1g7J+L6lgd2hpZbKw9dlLwHgoHGv04
   /pG8p22jU1PNHerPGMkgoM+1tYAjZJ/g/y5j//x9cCuKqC71zFeAqMxHy
   ljzWpNoYEe59iLw6KyP/Dd5nKTIQ7UbRW9VGciLFyIt4Iqv39Lq/KYav3
   QuQ/AkN8YmgLLcue44Utw/nXPFwe8/cijHIsmc3vmge9YyguIkn3qd3qb
   JA1v+1eK5DiyWWdBaZaiOXAzGdt+h07pBvsTKa8LkP2YgfXlQSrFWa7OS
   Q==;
X-CSE-ConnectionGUID: WZw9Oyz4Rii7K2keF8tAJA==
X-CSE-MsgGUID: ckTgrwZHQBS2KEDc1RWZUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="83483624"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="83483624"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 07:20:18 -0700
X-CSE-ConnectionGUID: QaeLRm4mQVqCkRIuiasFLw==
X-CSE-MsgGUID: jwUM619qRHGSTpGM4CfaNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="237117236"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 07:20:17 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 13 May 2026 07:20:16 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 13 May 2026 07:20:16 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.41) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 13 May 2026 07:20:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VhFHmQyEN6isYFAMdAdabBOPdZFdFze9ejJzCyWVXjVoWi8UkdfEco09TsdEBxCSm6gbPhPEXdinCkhPuS7iq6C3gEqDw/ss26onZa0BdKqopiqGaKSqtuwdikg+4PwTV4xn7diaSeZNGzO/ZBpfWTuueBDSXme+0n6kuw5bWSOIsNBCe0DRxz4p6i1UqS7pcjVJZFwgqHzjfnPT0U9lgAN6Yp+mrw8Wcn1OlZVoqN8lXwJjP1+Gtf3JRhLDAcUrCx7mC1BuhPFzRByHuFNRN8Ffg4hBrv4mQvsOnubFvreNIo12lIg/OZSgiyj4o8pmayQ874x9DtahCpywJb9nLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SVJnfRyRjdxadg8m8HpBmQEsyYT2lbHXufkq0Min5lA=;
 b=iDdyw3cz1LsvQWYU9PC4BNSgvCrQlzVS+85spN0k9MKVS9lc6z55dHasJ0xW8KoxaS+kUc/saYp1ym7uGaGA5VoLCFGVFQWH9PTQEbp9Y8xLtgDk5QzM+IXb8GuMKnaFKhug+FaIb2xk3pvjIuGKkbUXi+bwC5KnIpsy62xY3KysNK/S+egDP+c1QlBetAfg7HDqb/JOzzTLU0dhU5k8nXb7aSJ5AsbaWzfnWbngrsUOfWLFV2FNXrxMv7NqpZscAzU9nfW1ZChqJNgoBM1LrelmNTFh+b6cEKJDQABbXhn2kpQNGOI/hL5n6cEFOXPct6wsBlOXSTqq8PZrN4+pYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by PH8PR11MB6853.namprd11.prod.outlook.com (2603:10b6:510:22e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Wed, 13 May
 2026 14:20:08 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9891.019; Wed, 13 May 2026
 14:20:08 +0000
Date: Wed, 13 May 2026 22:19:58 +0800
From: kernel test robot <oliver.sang@intel.com>
To: JP Kobryn <jp.kobryn@linux.dev>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, Axel
 Rasmussen <axelrasmussen@google.com>, Baoquan He <bhe@redhat.com>, Barry Song
	<baohua@kernel.org>, Chris Li <chrisl@kernel.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi
	<shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Rik van Riel
	<riel@surriel.com>, Wei Xu <weixugc@google.com>, Yuanchu Xie
	<yuanchu@google.com>, <linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [mm/lruvec]  56fbec5d69:
 will-it-scale.per_process_ops 37.6% improvement
Message-ID: <202605131640.bac25289-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: TP0P295CA0035.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::17) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|PH8PR11MB6853:EE_
X-MS-Office365-Filtering-Correlation-Id: c288fc44-b29b-4ece-baff-08deb0fabbbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|11063799003|3023799003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: dbv/wlHfjgLqWT1fDZ7MYAvFxWxMyMe0eEp+pmAhZlHtx0BOzTcXMwvNCvMCP5TRlxET8PGgnK762Xj1ShvYRKlsgUjGB0RqE4ejV3PUU6VpsD+BvB45QY0JRaHEbIaTDy3ss4b8KqlZlX1TNTZXJS1Gls7YKaHKAPvZSjYkoeR7ASf/vf8VZuqpLCEX8FtiDuBa73nUX4kwn104WYlujixDMuc35sesXacQbrkk2sZSG3RX4l03f3l8bGBd+LC5523TSTJjQEoWbsr2Tf1eOqz5QO19NLOBxqX8iE7woeypbY3fA689m3maHPpUciuRgw6TCwNHxCJQO0PVWdYrBpDaFbTZ1uoFSRECFBfOUcXO9Q/TIWZV2WQwGYN32lR81jA0jFtiVEa8RjCSPXy8MxcGVoIwQBQTtQPyCs4mR/tKmFa2+pNprzpoK2lDGBTnx+/CpZajxXmKvnlEJOBdG2RABYo21aWpujvg3U1pm0/s6XJhnWJVzDkTZ4BKBmZT97zvMBMhiw8E49WxfYAxB7bZO6s22OKUHAyyaRNQHP6GWiC9XHa2JXQWNcbyxsJsVGY9eYrmc0+WOVgUGtE1hbksvC+zUFVSlI0gN+WrmxEkm6y+ae9MjgE3nc2PV+vl3fohccUakiJzohAtClmZyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(11063799003)(3023799003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?h3+ZUv5YGjs19/6gu4T0qUWZRrNVrwwg7o9tZvpKEcE92k7m41LGkNymKL?=
 =?iso-8859-1?Q?F9JGtlPhj9NSZ2d4Eco3qY2kT3IrjdBpTQZIn6AJnrie/z/9k5LVaYcV+1?=
 =?iso-8859-1?Q?v9dV58iK1MOLa7Hw5WpwbCmFZpgMwOmtZaO69eNGOyNzYVJyMTB9s1zzAQ?=
 =?iso-8859-1?Q?R0Y8cQAF4Xfjl+g39pMf9Jj5oq1h9V+zSdYoEoLYmrsCItc6h/9/UQr/zu?=
 =?iso-8859-1?Q?qeOb8NHdls8WtQTz9e2Ly60VzuFt1bZkNDldah6qscmglKgBdGtbSfInbq?=
 =?iso-8859-1?Q?TGAYKXc9mmt6eOlDB3XXybpTuLSBCfIAReAzEEpMmwLnpchdP62lcJf8We?=
 =?iso-8859-1?Q?TyITUSdshnYJhG6yIMkZWdaTJOtpJwNEV6fhVwmCp/gmpkpsvX0hGDy5yT?=
 =?iso-8859-1?Q?BZe8zxFPQwWdHE5GlrS0xBsvH2wLQLCf3i0PrTNVzYOIilbZtcZMyMmdNP?=
 =?iso-8859-1?Q?0n3iHLzXNzB47vjQLBfdjk8FEvOMfG70bF60kU+dTAZm6fi+bcByu0KyO+?=
 =?iso-8859-1?Q?BX/Y5ggm4wpPMF/QbzLi7PiG6n+0VZAMBDEe5zq5qu9a0YjCAGgHoeUvVV?=
 =?iso-8859-1?Q?Ohfs6mybLswqKOgCystfRwoHnL8ul+xOa7ml4T2vicHSLiKSKQXhKAampp?=
 =?iso-8859-1?Q?naXtahOSR8ATgWv1+hKit1OjHWbTIOtx1vISZMKq2VLqPoWeOFI47161Tx?=
 =?iso-8859-1?Q?2ZRJf44KAnNjtSoN9oHbWgKXgbqv8daJV+Ke0ihf4FWFwGBmFA3Lx6829g?=
 =?iso-8859-1?Q?Ql+TP+sYGEAZOT5RIkFDTv7h/vM3ptrCWVxPaUTFK3ILWlLS4djdwTpefC?=
 =?iso-8859-1?Q?+ExfcMmpUfbk+apWMK0tVC4HaYNNc0YCQjGAgopqLsujt1KyX9cjUWTnaC?=
 =?iso-8859-1?Q?v7p5QgTEpzm5CKO7dF+KfAqkNCsY5bJo4fOIWOvgrVolU9DmhszcJ3AeEi?=
 =?iso-8859-1?Q?4uwzjPa17s7BgwhVc8AFJiS8CzCiWypmoM0SkjtqKR7IhfoTcxAzYPgCzf?=
 =?iso-8859-1?Q?NWsT2LH++8sCxOpuLM3ImF1mXkDsMpQNXhsRNjtkAim7iMeBouUjHsAIRo?=
 =?iso-8859-1?Q?y6Xz0CuIg9olmmktyVREZbvRa3nhrRZl7bWsiLQwnbxuF3nKXWcUZiGN/j?=
 =?iso-8859-1?Q?n7zdemsSlhu55SCN7sKpNBIERXzQD+8AzAlLZdeD+aRMB8/ZLKBhsPebQB?=
 =?iso-8859-1?Q?U2wgIyVkp1VKUkS0flatF5yH68xra7T0yCeoZfWDL733XGy/VQU5/julg5?=
 =?iso-8859-1?Q?lBvALmd3sWIc4WpvldAGQPAzzIsAmcD9JTLmQxaZ6bEKm4rX3OVKHRsesS?=
 =?iso-8859-1?Q?r9kDfYdPWVzMid2RKJcUz8O1yzHWNCesyqTcdtZGX9iZrcACXHocRiyLH1?=
 =?iso-8859-1?Q?6AFSkPhXIe9UY+1+/u+HTTVsBvBeMZ70eWTotLJ7Hz4YbGa3N6/nPSGV/6?=
 =?iso-8859-1?Q?jdAf3xOlo+awxnLXoI5CQ33hEcBGg0kBV741L6cxZHeg7/urFFzdx48Y+1?=
 =?iso-8859-1?Q?V0RJLpzHcfFsPBIAGNlzAcjTKaJ+4bsn8J51nRiGR8Hw9AsPT2+jsXTjjt?=
 =?iso-8859-1?Q?1mf73UUncuEYBqlmfGqYY9TJjxhHmSi6uuiKQSzOTXOEgN8Gku8cmIDfFJ?=
 =?iso-8859-1?Q?lh1vy/GXhOomMoheyDWNA40vIM1ZLQITmSWGHc2RrX9EK69tD1smT62NpD?=
 =?iso-8859-1?Q?ra6HRko8FLm6Uv5yTffP8kZEJrnmgg2KNRRiylhMV4dJH66hKbdHEV+yoK?=
 =?iso-8859-1?Q?KhuMXR3wWsICSllLN3xMRjroyucxMgqSyzz+m9HtHjZPt7MDExN1NPIZEd?=
 =?iso-8859-1?Q?KbJkfFFiNw=3D=3D?=
X-Exchange-RoutingPolicyChecked: Yqnfek+uPXXp+LnVnag0EIZmBohXARnFcVHFrout8uHNHSzMcIbeIlDs5x+ArVF22ElStzPmusgSTvcKzlUH2+9AEaLgiQJRbge92YfNBUaiYqnqlWcGglzAuE7VPvpKCXgIXsVGKmpKzEOm1dlW93hOtv+qKQptex+mzs0q1jTPY1dOBDl+3QwPucC/zJbwzHSJrThWdtdl23pbK+I3H/CMOzptQLXv5pf1OQGl7JPiBvpZGgl1sMzvhjpOgeQXB2NxwMikxhqJzwJuZbIMKeIBW/FYzAQKwX1mwR/1UPzBXD9yfwtDILG+7m4yK/pFqz8i8leY5reOgXVm/xb3uA==
X-MS-Exchange-CrossTenant-Network-Message-Id: c288fc44-b29b-4ece-baff-08deb0fabbbe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 14:20:08.3966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MxBDbMcqKHvtLIJJqoTXBw9dmqPD+WkKA8j2kZYShz7kMW4/hcfWGQnlTTW7ldXqRwEsdnhLlz2vKoQnSxsCDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6853
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BAB56C0012
X-Stat-Signature: t4e93dc38u3fojrm1khyh1roqywssn1q
X-HE-Tag: 1778682019-994304
X-HE-Meta: U2FsdGVkX1/YJ3AbMVBYWJuhOfh0ljpWemi42MA5VfUxWib6mj///JQ1RSm426lDQ7Uq8q10Bc4pnT2Llwyx7nJtOz5vb8R8iGOLRE+G24T8fsxOluVN/NH81vPnenICe7m65At51QnG7KMGxE1xMWInjetrZrPIx9DiA1u7i3sAr3BN+3qScKYogu3xqRuHqKG8OHermLvv2AUMsCPiwfRd80w8WZzXITusyvGxJ1e3+XiaXGXmMw6A3ylpQ6yCBRSNnfDcr4y3MA1snZtWIFSbd+b9n+c89gqnUIqPgEU4yoamSwknNj6SBD3fwHE5cwO+b736KaMvphvi9vVd5Z55P9w2VYnHwtLDRF2JnVTpe5qps8o/M4KzLWr+nb0AZRFwHFe9PTLI24eA/2LWKNxbBtJfaMURc8FFInnqZhok+Oad+pOiDd/tMldQf+ironbjDQI/r9EVaHeU8R7kh6+2mtGV4IvuOX70XKzI8g4xIlbcXxJTrDvYpl2fqZQegbYrwYzC+xjo9Omys6fbDEZxd81spkBWVNN6r+ZceMEUq2IisjM28j5DpXEP7nIv6mGMzXnfUtb9ePw/hZTCY0iwfC/T5xZ4LS395KfC72QJeAKXU3ropuA0AeChmyZL3UBCJl2cilCWFHlQf9LvLmw4tDuJpzVr4OefY1tNjnmzb3rKhmcDhhgZcCWzVr7a51P8eW69f5cyWbgOU3E7UmvugioXtpgfzJkCmq7hf00CbuY+057UkzHdFshs7V5bDxwvWY33RjVQUD4jrUGbtzsKJAL8/2GQ67lMNMQeN8FLncu3OcWfGnN3AjUBhShqs3OV/z7eZJFCTXwElqINSgwPSTPoybwe7pJUeqqseEvqll/Wi75/GO+eGRfbPEhwYsmyT7/YOfbEkwyVuhW/huSkA7ms0CnEey6DM4/29wFgoxPWVNkIiSxrCFruD1VpVw2csQEedKoinBgqnDy
 T5Aw5RDM
 kXf+LnML2dAuw92QZX7l+wGBTK2xj9CWtoOVo9/VH9floUE1++PRsyJZK9TNMWqsgsyXF27+fvDkpYmaBuGqSL9N23DJJa0LHEdbHxfLyykhk91xZjqa429xDE8PmTZTIVwKNRvIAFvYvlEQ1qmrRudCsefJUIhINQNIB5P8L+PKgAT8aFDyJ+MQJ/3X+XBAg2+nxd2qN/NNbJFOwGcEpJlM5Ht/HXK4D6egDiF88PBsOInhvZWGMiInPm+U3hyRtC1kvM25zQ9Q5Y44c+/AqcaEePC8M51Sy0yj4s7QhOEkSBBXmba5hKLU+sBiPrdtnAG7+rWVDwhox/KKx8LMMCvg7Tz33O5zlKkwu12GGLWTylovpQRpb/FZFDdJc5GQSQ4GyZk8BmeWkmkwG216u+vtOloKgW8qk48eR4WqXEIDQp4b3OJ/8swx21x15lFCWnbm2YmWNU2wjMvdOsWBzZBCzIvofTl4gaA/j+zLuOAmZ52oIptw0hLuiX3bdpTewGdc8wvRXtim3m+xj+7xKZqdhErLBZKkiHmMkot0cyODDxufK2qwr3C8na9HQ6WHG7i9orGb7hbRaWFFzNxGzS0Njc1h45GnTMtnmSL3I3oMibbybvTXnudZkWMDsNLE3TNPV+wJ3TwKmiIw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 37.6% improvement of will-it-scale.per_process_ops on:


commit: 56fbec5d697430095533a43a2703949ddf17cbe4 ("mm/lruvec: preemptively free dead folios during lru_add drain")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master


testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory
parameters:

	nr_task: 100%
	mode: process
	test: malloc1
	cpufreq_governor: performance



Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260513/202605131640.bac25289-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp2/malloc1/will-it-scale

commit: 
  675a94be83 ("mm, page_alloc: reintroduce page allocation stall warning")
  56fbec5d69 ("mm/lruvec: preemptively free dead folios during lru_add drain")

675a94be830eaeb2 56fbec5d697430095533a43a270 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  16439933           +37.6%   22616391        will-it-scale.192.processes
     85624           +37.6%     117793        will-it-scale.per_process_ops
  16439933           +37.6%   22616391        will-it-scale.workload
   6321938            +9.9%    6950250 ±  3%  vmstat.memory.cache
     25313 ± 43%     +71.7%      43470        vmstat.system.cs
    267793 ±  2%      +6.4%     285009        vmstat.system.in
      0.18            +0.1        0.31        mpstat.cpu.all.irq%
     11.38 ± 25%      -7.6        3.81        mpstat.cpu.all.soft%
     85.25 ±  3%      +6.2       91.45        mpstat.cpu.all.sys%
      2.54 ±  3%      +1.3        3.80        mpstat.cpu.all.usr%
    544304 ± 11%     -28.2%     390855 ± 20%  numa-meminfo.node0.SUnreclaim
   2799180 ±  5%     +22.9%    3441198 ±  8%  numa-meminfo.node1.Active
   2799180 ±  5%     +22.9%    3441198 ±  8%  numa-meminfo.node1.Active(anon)
   2207014 ±  6%     +30.7%    2883668 ±  8%  numa-meminfo.node1.Shmem
 7.476e+09           +37.3%  1.027e+10        numa-numastat.node0.local_node
  7.48e+09           +37.3%  1.027e+10        numa-numastat.node0.numa_hit
 7.407e+09           +37.6%  1.019e+10        numa-numastat.node1.local_node
 7.408e+09           +37.6%  1.019e+10        numa-numastat.node1.numa_hit
      2162 ± 17%     +57.1%       3396 ± 15%  perf-c2c.DRAM.remote
     54563 ±  4%     -28.2%      39188 ± 10%  perf-c2c.HITM.local
    329.83 ±  5%    +141.7%     797.17 ± 13%  perf-c2c.HITM.remote
     54892 ±  4%     -27.2%      39985 ± 10%  perf-c2c.HITM.total
      0.73           +30.7%       0.95        turbostat.IPC
   9389175            +6.3%    9983637        turbostat.NMI
    472.11            +5.3%     497.04        turbostat.PkgWatt
     44.57           +12.8%      50.25        turbostat.RAMWatt
   3297545           +19.7%    3945770 ±  5%  meminfo.Active
   3297545           +19.7%    3945770 ±  5%  meminfo.Active(anon)
   6176940           +10.2%    6804674 ±  3%  meminfo.Cached
    800177 ±  4%     +13.1%     904617 ±  7%  meminfo.Mapped
   2402261 ±  2%     +26.1%    3029996 ±  6%  meminfo.Shmem
      0.77 ± 25%     -56.7%       0.33 ±  2%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     43.05 ± 34%     -65.3%      14.94 ± 10%  perf-sched.sch_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.77 ± 25%     -56.7%       0.33 ±  2%  perf-sched.total_sch_delay.average.ms
     43.05 ± 34%     -65.3%      14.94 ± 10%  perf-sched.total_sch_delay.max.ms
    156368 ± 45%     +54.5%     241624 ±  2%  perf-sched.total_wait_and_delay.count.ms
    156368 ± 45%     +54.5%     241624 ±  2%  perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
  29559501            +4.4%   30869402        numa-vmstat.node0.nr_free_pages_blocks
    136369 ± 11%     -28.3%      97708 ± 20%  numa-vmstat.node0.nr_slab_unreclaimable
  7.48e+09           +37.3%  1.027e+10        numa-vmstat.node0.numa_hit
 7.476e+09           +37.3%  1.027e+10        numa-vmstat.node0.numa_local
    699772 ±  5%     +22.9%     859942 ±  8%  numa-vmstat.node1.nr_active_anon
    551734 ±  6%     +30.6%     720547 ±  8%  numa-vmstat.node1.nr_shmem
    699772 ±  5%     +22.9%     859942 ±  8%  numa-vmstat.node1.nr_zone_active_anon
 7.408e+09           +37.6%  1.019e+10        numa-vmstat.node1.numa_hit
 7.407e+09           +37.6%  1.019e+10        numa-vmstat.node1.numa_local
    824515           +19.6%     986475 ±  5%  proc-vmstat.nr_active_anon
    224720            +2.3%     229871        proc-vmstat.nr_anon_pages
   1544361           +10.2%    1701200 ±  3%  proc-vmstat.nr_file_pages
  58025682            +3.7%   60199843        proc-vmstat.nr_free_pages_blocks
    200233 ±  4%     +13.0%     226196 ±  7%  proc-vmstat.nr_mapped
    600690 ±  2%     +26.1%     757530 ±  6%  proc-vmstat.nr_shmem
     35531            +1.0%      35879        proc-vmstat.nr_slab_reclaimable
    824515           +19.6%     986475 ±  5%  proc-vmstat.nr_zone_active_anon
 1.489e+10           +37.5%  2.046e+10        proc-vmstat.numa_hit
 1.488e+10           +37.4%  2.046e+10        proc-vmstat.numa_local
 1.492e+10           +37.0%  2.044e+10        proc-vmstat.pgalloc_normal
 4.952e+09           +37.6%  6.812e+09        proc-vmstat.pgfault
 1.492e+10           +37.0%  2.044e+10        proc-vmstat.pgfree
  17276975 ±  5%     -19.3%   13942668 ±  5%  sched_debug.cfs_rq:/.avg_vruntime.min
    613485 ± 14%     +54.6%     948443 ±  5%  sched_debug.cfs_rq:/.avg_vruntime.stddev
      0.29 ± 10%     +12.2%       0.32 ±  3%  sched_debug.cfs_rq:/.h_nr_queued.stddev
   6283308 ± 18%     +25.1%    7861786 ±  5%  sched_debug.cfs_rq:/.left_deadline.stddev
   6283245 ± 18%     +25.1%    7861720 ±  5%  sched_debug.cfs_rq:/.left_vruntime.stddev
     17.42 ± 64%    +119.9%      38.31 ±  4%  sched_debug.cfs_rq:/.load_avg.min
      0.25 ± 13%     +14.3%       0.29 ±  4%  sched_debug.cfs_rq:/.nr_queued.stddev
   6283246 ± 18%     +25.1%    7861720 ±  5%  sched_debug.cfs_rq:/.right_vruntime.stddev
-4.283e+11          +154.9% -1.092e+12        sched_debug.cfs_rq:/.sum_w_vruntime.min
      6906 ± 44%    +195.6%      20415 ± 19%  sched_debug.cfs_rq:/.sum_weight.avg
     58627 ± 34%    +118.4%     128053 ± 11%  sched_debug.cfs_rq:/.sum_weight.stddev
    670.25 ±  8%     -19.1%     542.11 ± 19%  sched_debug.cfs_rq:/.util_avg.min
     48.95 ±  7%     +18.2%      57.85 ± 12%  sched_debug.cfs_rq:/.util_avg.stddev
  17276970 ±  5%     -19.3%   13942657 ±  5%  sched_debug.cfs_rq:/.zero_vruntime.min
    613484 ± 14%     +54.6%     948442 ±  5%  sched_debug.cfs_rq:/.zero_vruntime.stddev
    225.94 ± 43%     -67.9%      72.56 ± 32%  sched_debug.cpu.curr->pid.min
      0.30 ±  9%     +13.3%       0.34 ±  3%  sched_debug.cpu.nr_running.stddev
     23423 ± 42%     +53.2%      35885        sched_debug.cpu.nr_switches.avg
      0.00 ± 28%     +90.0%       0.00 ± 11%  sched_debug.rt_rq:.rt_nr_running.avg
      0.28 ± 28%     +90.0%       0.53 ± 11%  sched_debug.rt_rq:.rt_nr_running.max
      0.02 ± 28%     +90.0%       0.04 ± 11%  sched_debug.rt_rq:.rt_nr_running.stddev
 9.266e+10           +30.6%   1.21e+11        perf-stat.i.branch-instructions
      0.09            -0.0        0.09        perf-stat.i.branch-miss-rate%
  79095808           +27.0%  1.005e+08        perf-stat.i.branch-misses
 1.641e+09           +31.6%   2.16e+09        perf-stat.i.cache-misses
 1.962e+09           +29.2%  2.534e+09        perf-stat.i.cache-references
     25508 ± 43%     +71.4%      43722        perf-stat.i.context-switches
      1.37           -23.6%       1.05        perf-stat.i.cpi
    372.27           -24.3%     281.74        perf-stat.i.cycles-between-cache-misses
  4.46e+11           +30.2%  5.809e+11        perf-stat.i.instructions
      0.73           +30.7%       0.96        perf-stat.i.ipc
      0.06 ± 20%    +239.2%       0.21 ± 14%  perf-stat.i.major-faults
    170.47           +37.5%     234.44        perf-stat.i.metric.K/sec
  16374682           +37.5%   22519001        perf-stat.i.minor-faults
  16374682           +37.5%   22519001        perf-stat.i.page-faults
      0.09            -0.0        0.08        perf-stat.overall.branch-miss-rate%
      1.37           -23.5%       1.05        perf-stat.overall.cpi
    372.05           -24.3%     281.83        perf-stat.overall.cycles-between-cache-misses
      0.73           +30.7%       0.95        perf-stat.overall.ipc
   8187560            -5.4%    7744442        perf-stat.overall.path-length
  9.23e+10           +30.6%  1.205e+11        perf-stat.ps.branch-instructions
  78701203           +27.3%  1.002e+08        perf-stat.ps.branch-misses
 1.636e+09           +31.5%  2.152e+09        perf-stat.ps.cache-misses
 1.955e+09           +29.1%  2.524e+09        perf-stat.ps.cache-references
     25291 ± 43%     +71.9%      43486        perf-stat.ps.context-switches
 4.443e+11           +30.2%  5.786e+11        perf-stat.ps.instructions
      0.06 ± 19%    +233.3%       0.20 ± 13%  perf-stat.ps.major-faults
  16313632           +37.6%   22453988        perf-stat.ps.minor-faults
  16313632           +37.6%   22453989        perf-stat.ps.page-faults
 1.346e+14           +30.1%  1.752e+14        perf-stat.total.instructions
     24.40 ±  2%     -23.4        0.97 ±  3%  perf-profile.calltrace.cycles-pp.folio_batch_move_lru.__folio_batch_add_and_move.map_anon_folio_pte_nopf.do_anonymous_page.__handle_mm_fault
     24.47 ±  2%     -23.4        1.07 ±  3%  perf-profile.calltrace.cycles-pp.__folio_batch_add_and_move.map_anon_folio_pte_nopf.do_anonymous_page.__handle_mm_fault.handle_mm_fault
     25.06           -23.2        1.89 ±  2%  perf-profile.calltrace.cycles-pp.map_anon_folio_pte_nopf.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
     21.70 ±  5%     -21.7        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs
     39.08 ±  2%     -13.1       25.97        perf-profile.calltrace.cycles-pp.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
     39.55 ±  2%     -12.9       26.61        perf-profile.calltrace.cycles-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     39.98 ±  2%     -12.9       27.11        perf-profile.calltrace.cycles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     40.80 ±  2%     -12.6       28.16        perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
     40.88 ±  2%     -12.6       28.26        perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault
     12.56           -12.6        0.00        perf-profile.calltrace.cycles-pp.folios_put_refs.folio_batch_move_lru.__folio_batch_add_and_move.map_anon_folio_pte_nopf.do_anonymous_page
     41.08 ±  2%     -12.5       28.54        perf-profile.calltrace.cycles-pp.asm_exc_page_fault
     11.88 ±  2%     -11.3        0.61 ±  6%  perf-profile.calltrace.cycles-pp.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu.unmap_region
     11.92 ±  2%     -11.3        0.67 ±  5%  perf-profile.calltrace.cycles-pp.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu.unmap_region.vms_complete_munmap_vmas
     11.94 ±  2%     -11.2        0.69 ±  5%  perf-profile.calltrace.cycles-pp.__tlb_batch_free_encoded_pages.tlb_finish_mmu.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
     11.15 ±  4%     -11.2        0.00        perf-profile.calltrace.cycles-pp.__page_cache_release.folios_put_refs.folio_batch_move_lru.__folio_batch_add_and_move.map_anon_folio_pte_nopf
     10.92 ±  4%     -10.9        0.00        perf-profile.calltrace.cycles-pp.__page_cache_release.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu
     10.89 ±  5%     -10.9        0.00        perf-profile.calltrace.cycles-pp.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs.folio_batch_move_lru.__folio_batch_add_and_move
     10.89 ±  5%     -10.9        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs.folio_batch_move_lru
     10.88 ±  4%     -10.9        0.00        perf-profile.calltrace.cycles-pp.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages
     10.85 ±  4%     -10.9        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs.free_pages_and_swap_cache
     10.64 ±  4%     -10.6        0.00        perf-profile.calltrace.cycles-pp.folio_lruvec_lock_irqsave.folio_batch_move_lru.__folio_batch_add_and_move.map_anon_folio_pte_nopf.do_anonymous_page
     10.63 ±  4%     -10.6        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.folio_batch_move_lru.__folio_batch_add_and_move.map_anon_folio_pte_nopf
     10.61 ±  4%     -10.6        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.folio_batch_move_lru.__folio_batch_add_and_move
     24.16            -6.8       17.32        perf-profile.calltrace.cycles-pp.tlb_finish_mmu.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
     33.56            -2.1       31.49        perf-profile.calltrace.cycles-pp.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
     34.44            -1.8       32.59        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      0.52 ±  2%      +0.0        0.55        perf-profile.calltrace.cycles-pp.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.__get_unmapped_area
      0.97 ±  2%      +0.2        1.13        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.__get_unmapped_area.do_mmap
      0.99 ±  2%      +0.2        1.15        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      1.19 ±  2%      +0.2        1.36        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.__get_unmapped_area.do_mmap.vm_mmap_pgoff.do_syscall_64
      1.33 ±  2%      +0.2        1.52        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.57 ±  6%      +0.2        0.78 ±  2%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.__anon_vma_prepare.__vmf_anon_prepare.do_anonymous_page.__handle_mm_fault
      0.94 ±  3%      +0.3        1.25        perf-profile.calltrace.cycles-pp.unlink_anon_vmas.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      0.85 ±  2%      +0.3        1.16        perf-profile.calltrace.cycles-pp.find_mergeable_anon_vma.__anon_vma_prepare.__vmf_anon_prepare.do_anonymous_page.__handle_mm_fault
      1.26 ±  2%      +0.3        1.58        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      1.49 ± 10%      +0.3        1.82 ±  4%  perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      1.73 ±  9%      +0.4        2.12 ±  4%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.97 ±  2%      +0.4        1.36        perf-profile.calltrace.cycles-pp.post_alloc_hook.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof
      1.41 ±  8%      +0.4        1.83 ±  4%  perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma.__mmap_region
      0.86 ±  4%      +0.4        1.30 ±  5%  perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region.do_mmap
      1.59 ±  8%      +0.5        2.08 ±  3%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
      1.35 ±  6%      +0.5        1.85        perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio
      1.09 ±  3%      +0.5        1.60 ±  4%  perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_complete.__mmap_region.do_mmap.vm_mmap_pgoff
      1.41 ±  6%      +0.5        1.93        perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page
      1.14 ±  3%      +0.5        1.67 ±  3%  perf-profile.calltrace.cycles-pp.__mmap_complete.__mmap_region.do_mmap.vm_mmap_pgoff.do_syscall_64
      1.45 ±  5%      +0.5        1.99        perf-profile.calltrace.cycles-pp.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page.__handle_mm_fault
      0.00            +0.5        0.54 ±  2%  perf-profile.calltrace.cycles-pp.lock_vma_under_rcu.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      1.49 ±  5%      +0.6        2.04        perf-profile.calltrace.cycles-pp.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      0.00            +0.6        0.60 ±  2%  perf-profile.calltrace.cycles-pp.__free_frozen_pages.tlb_remove_table_rcu.rcu_do_batch.rcu_core.handle_softirqs
      0.00            +0.6        0.61        perf-profile.calltrace.cycles-pp.mas_update_gap.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.00            +0.6        0.62        perf-profile.calltrace.cycles-pp.zap_present_ptes.zap_pte_range.zap_pmd_range.__zap_vma_range.unmap_vmas
      0.00            +0.6        0.62        perf-profile.calltrace.cycles-pp.mas_update_gap.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      1.90 ±  7%      +0.7        2.58 ±  2%  perf-profile.calltrace.cycles-pp.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      0.00            +0.7        0.69 ±  4%  perf-profile.calltrace.cycles-pp.__mem_cgroup_charge.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      1.75 ±  4%      +0.7        2.44        perf-profile.calltrace.cycles-pp.__anon_vma_prepare.__vmf_anon_prepare.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      0.00            +0.7        0.69        perf-profile.calltrace.cycles-pp.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      0.27 ±100%      +0.7        0.98 ±  7%  perf-profile.calltrace.cycles-pp.perf_iterate_sb.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region
      0.00            +0.7        0.72 ±  2%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      0.00            +0.8        0.78 ±  2%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      1.96 ±  4%      +0.8        2.74        perf-profile.calltrace.cycles-pp.__vmf_anon_prepare.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      1.95 ±  5%      +0.8        2.78        perf-profile.calltrace.cycles-pp.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.00            +0.8        0.83 ±  5%  perf-profile.calltrace.cycles-pp.try_charge_memcg.__memcg_kmem_charge_page.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof
      1.84 ±  9%      +1.0        2.82        perf-profile.calltrace.cycles-pp.tlb_remove_table.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables
      1.07 ± 16%      +1.1        2.18        perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.get_free_pages_noprof
      1.21 ± 15%      +1.2        2.37        perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.get_free_pages_noprof.tlb_remove_table
      1.33 ± 14%      +1.2        2.52        perf-profile.calltrace.cycles-pp.alloc_pages_mpol.alloc_pages_noprof.get_free_pages_noprof.tlb_remove_table.free_pud_range
      1.40 ± 13%      +1.2        2.60        perf-profile.calltrace.cycles-pp.get_free_pages_noprof.tlb_remove_table.free_pud_range.free_p4d_range.free_pgd_range
      1.39 ± 13%      +1.2        2.60        perf-profile.calltrace.cycles-pp.alloc_pages_noprof.get_free_pages_noprof.tlb_remove_table.free_pud_range.free_p4d_range
      0.32 ±100%      +1.3        1.64 ±  2%  perf-profile.calltrace.cycles-pp.___free_pages.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      1.38 ±  8%      +1.5        2.87        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      1.35 ±  8%      +1.5        2.85        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
     40.40 ±  2%      +1.5       41.93        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
      3.51 ±  2%      +1.6        5.09        perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.__zap_vma_range.unmap_vmas.unmap_region
     40.58 ±  2%      +1.6       42.18        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.73 ± 76%      +1.6        2.33        perf-profile.calltrace.cycles-pp.rcu_cblist_dequeue.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      1.74 ±  4%      +1.6        3.34        perf-profile.calltrace.cycles-pp.__memcg_kmem_charge_page.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.pte_alloc_one
      0.84 ± 54%      +1.7        2.51        perf-profile.calltrace.cycles-pp.tlb_remove_table_rcu.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
     40.86 ±  2%      +1.7       42.56        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     40.86 ±  2%      +1.7       42.56        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      1.46 ± 14%      +1.7        3.18 ±  2%  perf-profile.calltrace.cycles-pp.__rmqueue_pcplist.rmqueue.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol
     40.98 ±  2%      +1.7       42.72        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     41.02 ±  2%      +1.8       42.79        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
      1.80 ± 14%      +2.0        3.79        perf-profile.calltrace.cycles-pp.rmqueue.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof
     41.71 ±  2%      +2.0       43.75        perf-profile.calltrace.cycles-pp.__munmap
      4.72 ±  2%      +2.1        6.77        perf-profile.calltrace.cycles-pp.zap_pmd_range.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas
      3.23 ±  5%      +2.2        5.41        perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas
      4.82 ±  2%      +2.2        7.00        perf-profile.calltrace.cycles-pp.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      3.11 ±  6%      +2.2        5.30        perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.unmap_region
      3.30 ±  6%      +2.2        5.49        perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      4.89 ±  2%      +2.2        7.10        perf-profile.calltrace.cycles-pp.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      2.29 ±  7%      +2.3        4.57        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
      2.35 ±  7%      +2.4        4.71        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      2.56 ±  6%      +2.4        4.98        perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      4.34 ±  5%      +2.5        6.85        perf-profile.calltrace.cycles-pp.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      4.46 ±  7%      +2.9        7.37        perf-profile.calltrace.cycles-pp.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      5.04 ±  6%      +3.4        8.40        perf-profile.calltrace.cycles-pp.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff.do_syscall_64
      4.33 ± 52%      +4.1        8.47        perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
      4.34 ± 52%      +4.2        8.49        perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
      4.34 ± 52%      +4.2        8.50        perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
      4.34 ± 52%      +4.2        8.50        perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      4.37 ± 52%      +4.2        8.53        perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
      4.37 ± 52%      +4.2        8.53        perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
      4.37 ± 52%      +4.2        8.53        perf-profile.calltrace.cycles-pp.ret_from_fork_asm
      4.36 ± 52%      +4.2        8.52        perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     10.99            +4.3       15.29        perf-profile.calltrace.cycles-pp.native_flush_tlb_one_user.flush_tlb_func.flush_tlb_mm_range.tlb_finish_mmu.unmap_region
     11.84 ±  2%      +4.3       16.17        perf-profile.calltrace.cycles-pp.flush_tlb_mm_range.tlb_finish_mmu.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
     11.24            +4.4       15.61        perf-profile.calltrace.cycles-pp.flush_tlb_func.flush_tlb_mm_range.tlb_finish_mmu.unmap_region.vms_complete_munmap_vmas
      8.32 ±  4%      +4.8       13.08        perf-profile.calltrace.cycles-pp.__mmap_region.do_mmap.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      9.90 ±  4%      +5.0       14.92        perf-profile.calltrace.cycles-pp.do_mmap.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     10.18 ±  4%      +5.2       15.34        perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     10.32 ±  4%      +5.2       15.54        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     10.36 ±  4%      +5.2       15.60        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__mmap
      6.44 ±  4%      +5.6       12.00        perf-profile.calltrace.cycles-pp.post_alloc_hook.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof
     11.22 ±  4%      +5.6       16.84        perf-profile.calltrace.cycles-pp.__mmap
      7.50 ±  6%      +6.5       14.02        perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.pte_alloc_one
      9.37 ±  5%      +8.2       17.56        perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.pte_alloc_one.__pte_alloc
      9.44 ±  5%      +8.2       17.65        perf-profile.calltrace.cycles-pp.alloc_pages_mpol.alloc_pages_noprof.pte_alloc_one.__pte_alloc.do_anonymous_page
      9.48 ±  5%      +8.2       17.71        perf-profile.calltrace.cycles-pp.alloc_pages_noprof.pte_alloc_one.__pte_alloc.do_anonymous_page.__handle_mm_fault
      9.74 ±  5%      +8.3       18.05        perf-profile.calltrace.cycles-pp.pte_alloc_one.__pte_alloc.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      9.90 ±  5%      +8.4       18.30        perf-profile.calltrace.cycles-pp.__pte_alloc.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
     35.94 ±  4%     -33.1        2.81 ±  2%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     35.51 ±  4%     -33.1        2.44 ±  2%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     32.43 ±  4%     -32.3        0.13        perf-profile.children.cycles-pp.folio_lruvec_lock_irqsave
     24.45 ±  2%     -23.8        0.65 ±  5%  perf-profile.children.cycles-pp.folios_put_refs
     24.42 ±  2%     -23.4        0.97 ±  3%  perf-profile.children.cycles-pp.folio_batch_move_lru
     24.48 ±  2%     -23.4        1.07 ±  3%  perf-profile.children.cycles-pp.__folio_batch_add_and_move
     25.06           -23.2        1.89 ±  2%  perf-profile.children.cycles-pp.map_anon_folio_pte_nopf
     22.07 ±  4%     -22.0        0.12 ±  3%  perf-profile.children.cycles-pp.__page_cache_release
     39.08 ±  2%     -13.1       25.98        perf-profile.children.cycles-pp.do_anonymous_page
     39.57 ±  2%     -12.9       26.62        perf-profile.children.cycles-pp.__handle_mm_fault
     39.99 ±  2%     -12.9       27.12        perf-profile.children.cycles-pp.handle_mm_fault
     40.81 ±  2%     -12.6       28.16        perf-profile.children.cycles-pp.do_user_addr_fault
     40.88 ±  2%     -12.6       28.26        perf-profile.children.cycles-pp.exc_page_fault
     41.42 ±  2%     -12.4       29.02        perf-profile.children.cycles-pp.asm_exc_page_fault
     11.93 ±  2%     -11.3        0.67 ±  5%  perf-profile.children.cycles-pp.free_pages_and_swap_cache
     11.94 ±  2%     -11.2        0.69 ±  5%  perf-profile.children.cycles-pp.__tlb_batch_free_encoded_pages
     24.19            -6.8       17.35        perf-profile.children.cycles-pp.tlb_finish_mmu
      3.64 ± 68%      -2.6        1.08        perf-profile.children.cycles-pp.__irq_exit_rcu
      3.83 ± 64%      -2.4        1.42        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      2.21 ± 61%      -2.1        0.08 ± 14%  perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
     33.56            -2.1       31.49        perf-profile.children.cycles-pp.unmap_region
      2.82 ± 10%      -2.0        0.80 ±  6%  perf-profile.children.cycles-pp.__kmem_cache_free_bulk
      3.20 ±  9%      -1.9        1.26 ±  4%  perf-profile.children.cycles-pp.rcu_free_sheaf
     34.46            -1.8       32.61        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      2.28 ± 10%      -1.2        1.10        perf-profile.children.cycles-pp.__slab_free
      1.27 ± 22%      -0.8        0.51 ± 12%  perf-profile.children.cycles-pp.free_frozen_page_commit
      1.68 ± 17%      -0.6        1.08 ±  6%  perf-profile.children.cycles-pp.__free_frozen_pages
      0.37 ±  2%      -0.3        0.08        perf-profile.children.cycles-pp.lru_add
      0.25 ±  2%      -0.2        0.08 ±  6%  perf-profile.children.cycles-pp.lru_gen_add_folio
      0.16 ± 21%      -0.1        0.09 ± 14%  perf-profile.children.cycles-pp.free_one_page
      0.08 ±  6%      -0.0        0.05 ±  7%  perf-profile.children.cycles-pp.kfree
      0.07 ±  9%      -0.0        0.05 ±  8%  perf-profile.children.cycles-pp.handle_internal_command
      0.07 ±  9%      -0.0        0.05 ±  8%  perf-profile.children.cycles-pp.main
      0.07 ±  9%      -0.0        0.05 ±  8%  perf-profile.children.cycles-pp.run_builtin
      0.07            -0.0        0.06 ±  6%  perf-profile.children.cycles-pp.uncharge_folio
      0.15 ±  4%      +0.0        0.16 ±  3%  perf-profile.children.cycles-pp.mod_node_page_state
      0.06 ±  8%      +0.0        0.07        perf-profile.children.cycles-pp.__pte_offset_map
      0.05 ±  7%      +0.0        0.07        perf-profile.children.cycles-pp.mas_prev_range
      0.10            +0.0        0.12        perf-profile.children.cycles-pp.policy_nodemask
      0.05            +0.0        0.07        perf-profile.children.cycles-pp.testcase
      0.05 ±  8%      +0.0        0.07 ±  6%  perf-profile.children.cycles-pp.x64_sys_call
      0.07 ±  7%      +0.0        0.09        perf-profile.children.cycles-pp.static_key_count
      0.08 ±  6%      +0.0        0.10 ±  3%  perf-profile.children.cycles-pp.folio_mark_accessed
      0.06 ±  7%      +0.0        0.09        perf-profile.children.cycles-pp.mas_prev_setup
      0.06 ±  7%      +0.0        0.09        perf-profile.children.cycles-pp.can_vma_merge_right
      0.07 ±  5%      +0.0        0.10 ±  5%  perf-profile.children.cycles-pp.cfree
      0.36 ±  3%      +0.0        0.39        perf-profile.children.cycles-pp.mas_rev_awalk
      0.05 ±  8%      +0.0        0.08 ±  4%  perf-profile.children.cycles-pp.vm_get_page_prot
      0.07 ±  5%      +0.0        0.10        perf-profile.children.cycles-pp.down_read_trylock
      0.08 ±  6%      +0.0        0.10 ±  7%  perf-profile.children.cycles-pp.security_mmap_addr
      0.08 ±  5%      +0.0        0.12 ±  4%  perf-profile.children.cycles-pp.folio_add_lru
      0.06 ±  7%      +0.0        0.10 ±  6%  perf-profile.children.cycles-pp.sched_tick
      0.02 ± 99%      +0.0        0.06        perf-profile.children.cycles-pp.prandom_u32_state
      0.52 ±  3%      +0.0        0.56        perf-profile.children.cycles-pp.mas_empty_area_rev
      0.02 ± 99%      +0.0        0.06 ±  6%  perf-profile.children.cycles-pp.perf_exclude_event
      0.09 ±  4%      +0.0        0.13        perf-profile.children.cycles-pp.__account_obj_stock
      0.08 ±  4%      +0.0        0.12        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.14 ±  3%      +0.0        0.18 ±  2%  perf-profile.children.cycles-pp.may_expand_vm
      0.09            +0.0        0.13        perf-profile.children.cycles-pp.__irqentry_text_end
      0.10            +0.0        0.14        perf-profile.children.cycles-pp.tlb_gather_mmu
      0.07 ±  5%      +0.0        0.11 ±  6%  perf-profile.children.cycles-pp.memcg_state_val_in_pages
      0.04 ± 71%      +0.0        0.08 ±  7%  perf-profile.children.cycles-pp.vma_wants_writenotify
      0.13 ±  3%      +0.0        0.17 ±  2%  perf-profile.children.cycles-pp.mas_prev
      0.22 ±  7%      +0.0        0.26        perf-profile.children.cycles-pp.free_unref_folios
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.trylock_stock
      0.32 ±  2%      +0.1        0.37        perf-profile.children.cycles-pp.mas_next_slot
      0.08 ±  4%      +0.1        0.13 ±  2%  perf-profile.children.cycles-pp.rcu_segcblist_enqueue
      0.09            +0.1        0.14 ±  3%  perf-profile.children.cycles-pp.mas_wr_walk_descend
      0.14 ±  3%      +0.1        0.20 ±  2%  perf-profile.children.cycles-pp.pmd_install
      0.00            +0.1        0.06 ±  8%  perf-profile.children.cycles-pp.get_jiffies_update
      0.00            +0.1        0.06 ±  8%  perf-profile.children.cycles-pp.task_tick_fair
      0.12 ±  4%      +0.1        0.18 ±  3%  perf-profile.children.cycles-pp.downgrade_write
      0.00            +0.1        0.06 ±  6%  perf-profile.children.cycles-pp.tmigr_requires_handle_remote
      0.11 ±  5%      +0.1        0.17 ±  7%  perf-profile.children.cycles-pp.drain_stock
      0.19 ±  4%      +0.1        0.25        perf-profile.children.cycles-pp.__vma_start_exclude_readers
      0.32 ±  4%      +0.1        0.38        perf-profile.children.cycles-pp.__put_anon_vma
      0.00            +0.1        0.06 ±  7%  perf-profile.children.cycles-pp.folio_add_lru_vma
      0.14 ±  3%      +0.1        0.21        perf-profile.children.cycles-pp.down_write_killable
      0.17 ± 10%      +0.1        0.24 ± 10%  perf-profile.children.cycles-pp.get_mem_cgroup_from_mm
      0.00            +0.1        0.07 ±  7%  perf-profile.children.cycles-pp._raw_spin_unlock
      0.00            +0.1        0.07 ±  7%  perf-profile.children.cycles-pp.vma_is_shared_writable
      0.14 ±  5%      +0.1        0.20 ±  6%  perf-profile.children.cycles-pp.refill_stock
      0.02 ±141%      +0.1        0.08 ±  5%  perf-profile.children.cycles-pp.mas_next_range
      0.19            +0.1        0.26 ±  3%  perf-profile.children.cycles-pp.security_vm_enough_memory_mm
      0.28 ±  4%      +0.1        0.35 ±  2%  perf-profile.children.cycles-pp.__call_rcu_common
      0.21            +0.1        0.29        perf-profile.children.cycles-pp.error_entry
      0.10            +0.1        0.18 ±  3%  perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.44 ±  4%      +0.1        0.53 ±  3%  perf-profile.children.cycles-pp.__mod_memcg_lruvec_state
      0.12 ±  5%      +0.1        0.21 ±  4%  perf-profile.children.cycles-pp.update_process_times
      0.29 ±  4%      +0.1        0.38        perf-profile.children.cycles-pp.__vma_start_write
      0.19 ±  3%      +0.1        0.28 ±  5%  perf-profile.children.cycles-pp.__memcg_kmem_uncharge_page
      0.20 ±  8%      +0.1        0.29 ±  6%  perf-profile.children.cycles-pp.down_write
      0.05 ±  7%      +0.1        0.14 ±  5%  perf-profile.children.cycles-pp.perf_event_mmap_output
      0.25 ±  4%      +0.1        0.34 ±  2%  perf-profile.children.cycles-pp.__folio_mod_stat
      0.34 ±  7%      +0.1        0.43 ±  2%  perf-profile.children.cycles-pp.___perf_sw_event
      0.25 ±  2%      +0.1        0.35        perf-profile.children.cycles-pp.vma_merge_new_range
      0.07 ±  8%      +0.1        0.16 ±  3%  perf-profile.children.cycles-pp.mmap_region
      0.13 ±  3%      +0.1        0.23 ±  2%  perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.09 ±  8%      +0.1        0.18 ± 13%  perf-profile.children.cycles-pp.vma_set_page_prot
      0.27 ±  6%      +0.1        0.37        perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
      0.14 ±  4%      +0.1        0.24 ±  5%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.36 ±  3%      +0.1        0.46 ±  2%  perf-profile.children.cycles-pp.anon_vma_compatible
      0.00            +0.1        0.10 ±  4%  perf-profile.children.cycles-pp.ksm_vma_flags
      0.28            +0.1        0.38        perf-profile.children.cycles-pp.mas_wr_store_type
      0.44 ±  2%      +0.1        0.54        perf-profile.children.cycles-pp.mas_prev_slot
      0.42 ±  6%      +0.1        0.53 ±  2%  perf-profile.children.cycles-pp.__perf_sw_event
      0.15 ±  4%      +0.1        0.26 ±  5%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.27            +0.1        0.38        perf-profile.children.cycles-pp.sync_regs
      0.25 ±  3%      +0.1        0.36        perf-profile.children.cycles-pp.up_write
      0.26            +0.1        0.37        perf-profile.children.cycles-pp.up_read
      0.36 ±  3%      +0.1        0.49        perf-profile.children.cycles-pp.folio_add_new_anon_rmap
      0.41 ±  3%      +0.1        0.54 ±  2%  perf-profile.children.cycles-pp.lock_vma_under_rcu
      0.24 ±  3%      +0.1        0.37 ±  2%  perf-profile.children.cycles-pp.folio_remove_rmap_ptes
      0.18 ±  2%      +0.1        0.32        perf-profile.children.cycles-pp.hrtimer_interrupt
      0.19            +0.1        0.33        perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.41 ±  2%      +0.2        0.56        perf-profile.children.cycles-pp._raw_spin_lock
      0.41 ±  2%      +0.2        0.56        perf-profile.children.cycles-pp.pte_offset_map_lock
      0.99 ±  2%      +0.2        1.15        perf-profile.children.cycles-pp.vm_unmapped_area
      0.98 ±  2%      +0.2        1.14        perf-profile.children.cycles-pp.unmapped_area_topdown
      0.40 ±  3%      +0.2        0.57 ±  3%  perf-profile.children.cycles-pp._raw_spin_trylock
      1.19 ±  2%      +0.2        1.36        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      0.19 ±  5%      +0.2        0.36 ±  7%  perf-profile.children.cycles-pp.page_counter_try_charge
      1.35 ±  2%      +0.2        1.52        perf-profile.children.cycles-pp.__get_unmapped_area
      0.49            +0.2        0.68        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.24 ±  5%      +0.2        0.44 ±  4%  perf-profile.children.cycles-pp.charge_memcg
      0.54 ±  5%      +0.2        0.76 ±  9%  perf-profile.children.cycles-pp.__mem_cgroup_uncharge_folios
      0.60            +0.2        0.83        perf-profile.children.cycles-pp.native_irq_return_iret
      0.47 ±  6%      +0.2        0.70 ± 10%  perf-profile.children.cycles-pp.uncharge_batch
      0.47 ±  2%      +0.2        0.70        perf-profile.children.cycles-pp.vm_area_alloc
      0.40 ±  2%      +0.2        0.64        perf-profile.children.cycles-pp.zap_present_ptes
      0.54 ±  7%      +0.2        0.78        perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.68 ±  2%      +0.3        0.93        perf-profile.children.cycles-pp.mas_walk
      0.33 ± 14%      +0.3        0.58 ± 10%  perf-profile.children.cycles-pp.__mod_memcg_state
      0.61 ±  4%      +0.3        0.87        perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      0.77            +0.3        1.03        perf-profile.children.cycles-pp.mas_find
      0.43 ±  4%      +0.3        0.69 ±  4%  perf-profile.children.cycles-pp.__mem_cgroup_charge
      0.57 ±  5%      +0.3        0.86 ±  9%  perf-profile.children.cycles-pp.page_counter_uncharge
      0.20 ±  2%      +0.3        0.50        perf-profile.children.cycles-pp.barn_put_full_sheaf
      0.91 ±  5%      +0.3        1.21        perf-profile.children.cycles-pp.kmem_cache_free
      0.60            +0.3        0.90        perf-profile.children.cycles-pp.entry_SYSCALL_64
      0.94 ±  3%      +0.3        1.26        perf-profile.children.cycles-pp.unlink_anon_vmas
      0.86 ±  2%      +0.3        1.17        perf-profile.children.cycles-pp.find_mergeable_anon_vma
      0.81 ±  4%      +0.3        1.14 ±  2%  perf-profile.children.cycles-pp.lruvec_stat_mod_folio
      1.26 ±  2%      +0.3        1.60        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      2.63 ± 10%      +0.4        2.99        perf-profile.children.cycles-pp.__refill_objects_node
      0.20 ±  7%      +0.4        0.57        perf-profile.children.cycles-pp.barn_replace_empty_sheaf
      0.19 ± 11%      +0.4        0.58        perf-profile.children.cycles-pp.barn_get_empty_sheaf
      0.92 ±  3%      +0.4        1.35 ±  5%  perf-profile.children.cycles-pp.perf_event_mmap_event
      0.44 ±  6%      +0.5        0.92        perf-profile.children.cycles-pp.__kfree_rcu_sheaf
      0.52 ±  7%      +0.5        1.00 ±  7%  perf-profile.children.cycles-pp.perf_iterate_sb
      1.11 ±  3%      +0.5        1.60 ±  4%  perf-profile.children.cycles-pp.perf_event_mmap
      1.14 ±  3%      +0.5        1.67 ±  3%  perf-profile.children.cycles-pp.__mmap_complete
      1.49 ±  5%      +0.5        2.04        perf-profile.children.cycles-pp.vma_alloc_folio_noprof
      0.59 ±  8%      +0.6        1.18 ±  4%  perf-profile.children.cycles-pp.try_charge_memcg
      1.90 ±  7%      +0.7        2.60 ±  2%  perf-profile.children.cycles-pp.mas_preallocate
      1.75 ±  4%      +0.7        2.44        perf-profile.children.cycles-pp.__anon_vma_prepare
      2.95 ±  9%      +0.7        3.66        perf-profile.children.cycles-pp.__pcs_replace_empty_main
      0.80 ±  4%      +0.7        1.51        perf-profile.children.cycles-pp.kvfree_call_rcu
      0.49 ± 12%      +0.7        1.24        perf-profile.children.cycles-pp.mas_update_gap
      1.96 ±  4%      +0.8        2.75        perf-profile.children.cycles-pp.__vmf_anon_prepare
      1.95 ±  5%      +0.8        2.78        perf-profile.children.cycles-pp.alloc_anon_folio
      1.85 ±  9%      +1.0        2.82        perf-profile.children.cycles-pp.tlb_remove_table
      0.88 ±  6%      +1.0        1.88 ±  2%  perf-profile.children.cycles-pp.___free_pages
      1.46            +1.1        2.54        perf-profile.children.cycles-pp.rcu_cblist_dequeue
      1.76 ± 12%      +1.1        2.86        perf-profile.children.cycles-pp.tlb_remove_table_rcu
      1.40 ± 13%      +1.2        2.61        perf-profile.children.cycles-pp.get_free_pages_noprof
      4.20 ±  7%      +1.3        5.46        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
     40.40 ±  2%      +1.5       41.94        perf-profile.children.cycles-pp.do_vmi_align_munmap
      7.93 ±  5%      +1.6        9.49        perf-profile.children.cycles-pp.rcu_do_batch
      7.95 ±  5%      +1.6        9.52        perf-profile.children.cycles-pp.rcu_core
      7.98 ±  5%      +1.6        9.56        perf-profile.children.cycles-pp.handle_softirqs
      3.53 ±  2%      +1.6        5.13        perf-profile.children.cycles-pp.zap_pte_range
     40.59 ±  2%      +1.6       42.18        perf-profile.children.cycles-pp.do_vmi_munmap
      1.74 ±  4%      +1.6        3.35        perf-profile.children.cycles-pp.__memcg_kmem_charge_page
     40.86 ±  2%      +1.7       42.56        perf-profile.children.cycles-pp.__vm_munmap
     40.86 ±  2%      +1.7       42.56        perf-profile.children.cycles-pp.__x64_sys_munmap
      1.56 ± 13%      +1.8        3.30 ±  2%  perf-profile.children.cycles-pp.__rmqueue_pcplist
      4.73 ±  2%      +2.1        6.79        perf-profile.children.cycles-pp.zap_pmd_range
      2.04 ± 13%      +2.1        4.10        perf-profile.children.cycles-pp.rmqueue
     41.89 ±  2%      +2.1       43.99        perf-profile.children.cycles-pp.__munmap
      3.24 ±  6%      +2.2        5.41        perf-profile.children.cycles-pp.free_p4d_range
      4.83 ±  2%      +2.2        7.01        perf-profile.children.cycles-pp.__zap_vma_range
      3.32 ±  5%      +2.2        5.50        perf-profile.children.cycles-pp.free_pgd_range
      3.12 ±  6%      +2.2        5.31        perf-profile.children.cycles-pp.free_pud_range
      4.89 ±  2%      +2.2        7.10        perf-profile.children.cycles-pp.unmap_vmas
      2.56 ±  6%      +2.4        4.99        perf-profile.children.cycles-pp.mas_store_prealloc
      4.36 ±  5%      +2.5        6.86        perf-profile.children.cycles-pp.free_pgtables
      4.80 ±  7%      +2.9        7.74        perf-profile.children.cycles-pp.mas_store_gfp
      2.74 ±  8%      +3.0        5.73        perf-profile.children.cycles-pp.__pi_memcpy
      5.05 ±  6%      +3.4        8.41        perf-profile.children.cycles-pp.__mmap_new_vma
      4.34 ± 52%      +4.2        8.50        perf-profile.children.cycles-pp.run_ksoftirqd
      4.37 ± 52%      +4.2        8.53        perf-profile.children.cycles-pp.kthread
      4.37 ± 52%      +4.2        8.53        perf-profile.children.cycles-pp.ret_from_fork
      4.37 ± 52%      +4.2        8.53        perf-profile.children.cycles-pp.ret_from_fork_asm
      4.36 ± 52%      +4.2        8.52        perf-profile.children.cycles-pp.smpboot_thread_fn
     11.00            +4.3       15.30        perf-profile.children.cycles-pp.native_flush_tlb_one_user
     11.86 ±  2%      +4.3       16.17        perf-profile.children.cycles-pp.flush_tlb_mm_range
     11.26            +4.4       15.62        perf-profile.children.cycles-pp.flush_tlb_func
      4.71 ±  7%      +4.7        9.41        perf-profile.children.cycles-pp.mas_wr_node_store
      8.36 ±  4%      +4.8       13.14        perf-profile.children.cycles-pp.__mmap_region
      9.90 ±  4%      +5.0       14.93        perf-profile.children.cycles-pp.do_mmap
     10.18 ±  4%      +5.2       15.35        perf-profile.children.cycles-pp.vm_mmap_pgoff
     11.36 ±  4%      +5.7       17.04        perf-profile.children.cycles-pp.__mmap
      7.42 ±  3%      +6.0       13.40        perf-profile.children.cycles-pp.post_alloc_hook
     51.39 ±  2%      +7.0       58.34        perf-profile.children.cycles-pp.do_syscall_64
     51.46 ±  2%      +7.0       58.46        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      9.93 ±  7%      +8.1       18.07        perf-profile.children.cycles-pp.get_page_from_freelist
      9.74 ±  5%      +8.3       18.06        perf-profile.children.cycles-pp.pte_alloc_one
      9.90 ±  5%      +8.4       18.30        perf-profile.children.cycles-pp.__pte_alloc
     10.88 ±  6%      +9.4       20.31        perf-profile.children.cycles-pp.alloc_pages_noprof
     12.00 ±  6%      +9.9       21.87        perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
     12.23 ±  6%      +9.9       22.16        perf-profile.children.cycles-pp.alloc_pages_mpol
     35.51 ±  4%     -33.1        2.44 ±  2%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.44 ±  3%      -0.2        0.21 ±  9%  perf-profile.self.cycles-pp.tlb_remove_table
      0.28            -0.1        0.17        perf-profile.self.cycles-pp.folios_put_refs
      0.18 ±  3%      -0.1        0.07        perf-profile.self.cycles-pp.lru_gen_add_folio
      0.44 ±  9%      -0.1        0.37        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.25            -0.1        0.20        perf-profile.self.cycles-pp.perf_event_mmap_event
      0.06            -0.0        0.02 ± 99%  perf-profile.self.cycles-pp.kfree
      0.06 ±  6%      -0.0        0.04 ± 44%  perf-profile.self.cycles-pp.__kmem_cache_free_bulk
      0.06            -0.0        0.05        perf-profile.self.cycles-pp.uncharge_folio
      0.08 ±  4%      +0.0        0.10 ±  5%  perf-profile.self.cycles-pp.__perf_sw_event
      0.23            +0.0        0.25 ±  4%  perf-profile.self.cycles-pp.flush_tlb_mm_range
      0.17 ±  5%      +0.0        0.19        perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
      0.10 ±  3%      +0.0        0.12 ±  5%  perf-profile.self.cycles-pp.handle_mm_fault
      0.05            +0.0        0.07        perf-profile.self.cycles-pp.__pte_offset_map
      0.05            +0.0        0.07        perf-profile.self.cycles-pp.testcase
      0.06            +0.0        0.08        perf-profile.self.cycles-pp.mas_prev_setup
      0.07            +0.0        0.09        perf-profile.self.cycles-pp.policy_nodemask
      0.06            +0.0        0.08 ±  4%  perf-profile.self.cycles-pp.do_anonymous_page
      0.07 ±  5%      +0.0        0.09        perf-profile.self.cycles-pp.rcu_free_sheaf
      0.06 ±  6%      +0.0        0.08 ±  5%  perf-profile.self.cycles-pp.static_key_count
      0.08            +0.0        0.10 ±  4%  perf-profile.self.cycles-pp.folio_remove_rmap_ptes
      0.06            +0.0        0.08 ±  5%  perf-profile.self.cycles-pp.can_vma_merge_right
      0.06 ±  7%      +0.0        0.09        perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.06            +0.0        0.09 ±  5%  perf-profile.self.cycles-pp.exc_page_fault
      0.19 ±  3%      +0.0        0.22 ±  3%  perf-profile.self.cycles-pp.__call_rcu_common
      0.08 ±  5%      +0.0        0.11 ±  4%  perf-profile.self.cycles-pp.rcu_do_batch
      0.07            +0.0        0.10 ±  3%  perf-profile.self.cycles-pp.pmd_install
      0.10            +0.0        0.13        perf-profile.self.cycles-pp.__vma_start_write
      0.08 ±  6%      +0.0        0.10 ±  4%  perf-profile.self.cycles-pp.__mmap_new_vma
      0.07            +0.0        0.10        perf-profile.self.cycles-pp.__folio_batch_add_and_move
      0.07            +0.0        0.10        perf-profile.self.cycles-pp.down_read_trylock
      0.07            +0.0        0.10        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.07            +0.0        0.10        perf-profile.self.cycles-pp.folio_mark_accessed
      0.07            +0.0        0.10        perf-profile.self.cycles-pp.mas_prev
      0.09 ±  4%      +0.0        0.12        perf-profile.self.cycles-pp.__account_obj_stock
      0.13 ±  3%      +0.0        0.16 ±  3%  perf-profile.self.cycles-pp.alloc_pages_mpol
      0.10            +0.0        0.13 ±  3%  perf-profile.self.cycles-pp.tlb_gather_mmu
      0.09 ±  4%      +0.0        0.12 ±  7%  perf-profile.self.cycles-pp.security_vm_enough_memory_mm
      0.09 ±  5%      +0.0        0.13 ±  2%  perf-profile.self.cycles-pp.folio_batch_move_lru
      0.35            +0.0        0.38        perf-profile.self.cycles-pp.mas_rev_awalk
      0.11 ±  3%      +0.0        0.15        perf-profile.self.cycles-pp.__free_frozen_pages
      0.13 ±  2%      +0.0        0.17 ±  2%  perf-profile.self.cycles-pp.may_expand_vm
      0.09 ±  5%      +0.0        0.13 ±  2%  perf-profile.self.cycles-pp.alloc_pages_noprof
      0.09            +0.0        0.13        perf-profile.self.cycles-pp.__irqentry_text_end
      0.11 ±  3%      +0.0        0.15 ±  2%  perf-profile.self.cycles-pp.folio_add_new_anon_rmap
      0.11 ±  3%      +0.0        0.15 ±  2%  perf-profile.self.cycles-pp.free_unref_folios
      0.11            +0.0        0.15 ±  2%  perf-profile.self.cycles-pp.do_user_addr_fault
      0.10 ±  3%      +0.0        0.14 ±  4%  perf-profile.self.cycles-pp.map_anon_folio_pte_nopf
      0.18            +0.0        0.22 ±  2%  perf-profile.self.cycles-pp.mas_wr_store_type
      0.08 ±  5%      +0.0        0.13        perf-profile.self.cycles-pp.pte_offset_map_lock
      0.02 ± 99%      +0.0        0.07 ±  5%  perf-profile.self.cycles-pp.vm_get_page_prot
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.__refill_obj_stock
      0.00            +0.1        0.05        perf-profile.self.cycles-pp._raw_spin_unlock
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.security_mmap_addr
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.unmap_region
      0.08 ±  4%      +0.1        0.13 ±  2%  perf-profile.self.cycles-pp.rcu_segcblist_enqueue
      0.08 ±  5%      +0.1        0.14        perf-profile.self.cycles-pp.mas_wr_walk_descend
      0.00            +0.1        0.06 ±  8%  perf-profile.self.cycles-pp.get_jiffies_update
      0.00            +0.1        0.06 ±  8%  perf-profile.self.cycles-pp.prandom_u32_state
      0.00            +0.1        0.06 ±  6%  perf-profile.self.cycles-pp.free_pages_and_swap_cache
      0.17 ±  5%      +0.1        0.23        perf-profile.self.cycles-pp.__vma_start_exclude_readers
      0.12            +0.1        0.18 ±  2%  perf-profile.self.cycles-pp.downgrade_write
      0.30            +0.1        0.36        perf-profile.self.cycles-pp.mas_next_slot
      0.00            +0.1        0.06        perf-profile.self.cycles-pp.barn_put_full_sheaf
      0.00            +0.1        0.06        perf-profile.self.cycles-pp.mas_prev_range
      0.00            +0.1        0.06 ±  9%  perf-profile.self.cycles-pp.perf_exclude_event
      0.16            +0.1        0.22        perf-profile.self.cycles-pp.vma_merge_new_range
      0.00            +0.1        0.06        perf-profile.self.cycles-pp.x64_sys_call
      0.14            +0.1        0.20        perf-profile.self.cycles-pp.down_write_killable
      0.18 ±  2%      +0.1        0.24        perf-profile.self.cycles-pp.error_entry
      0.24            +0.1        0.30        perf-profile.self.cycles-pp.flush_tlb_func
      0.19            +0.1        0.25        perf-profile.self.cycles-pp.lock_vma_under_rcu
      0.00            +0.1        0.06 ±  7%  perf-profile.self.cycles-pp.folio_add_lru_vma
      0.00            +0.1        0.06 ±  7%  perf-profile.self.cycles-pp.mas_next_range
      0.12            +0.1        0.18 ±  2%  perf-profile.self.cycles-pp.do_syscall_64
      0.17 ± 11%      +0.1        0.23 ± 11%  perf-profile.self.cycles-pp.get_mem_cgroup_from_mm
      0.36            +0.1        0.42 ±  2%  perf-profile.self.cycles-pp.kmem_cache_free
      0.00            +0.1        0.06 ±  7%  perf-profile.self.cycles-pp.vma_is_shared_writable
      0.20 ±  2%      +0.1        0.26        perf-profile.self.cycles-pp.perf_event_mmap
      0.00            +0.1        0.07 ± 11%  perf-profile.self.cycles-pp.__anon_vma_prepare
      0.16 ±  2%      +0.1        0.23        perf-profile.self.cycles-pp.vm_area_alloc
      0.15 ±  3%      +0.1        0.22 ±  2%  perf-profile.self.cycles-pp.tlb_finish_mmu
      0.27 ±  9%      +0.1        0.34 ±  4%  perf-profile.self.cycles-pp.___perf_sw_event
      0.18 ±  2%      +0.1        0.25        perf-profile.self.cycles-pp.__vm_munmap
      0.27            +0.1        0.34        perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      0.18            +0.1        0.25        perf-profile.self.cycles-pp.find_mergeable_anon_vma
      0.07            +0.1        0.14 ±  3%  perf-profile.self.cycles-pp.vm_mmap_pgoff
      0.00            +0.1        0.08 ± 22%  perf-profile.self.cycles-pp.vma_set_page_prot
      0.20 ±  2%      +0.1        0.27        perf-profile.self.cycles-pp.mas_store_prealloc
      0.10            +0.1        0.18 ±  2%  perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.21            +0.1        0.29        perf-profile.self.cycles-pp.__mmap
      0.04 ± 45%      +0.1        0.12 ±  8%  perf-profile.self.cycles-pp.perf_event_mmap_output
      0.12 ±  4%      +0.1        0.20 ±  2%  perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.37 ±  5%      +0.1        0.46 ±  4%  perf-profile.self.cycles-pp.__mod_memcg_lruvec_state
      0.17            +0.1        0.26        perf-profile.self.cycles-pp.unlink_anon_vmas
      0.07 ±  5%      +0.1        0.16 ±  3%  perf-profile.self.cycles-pp.mmap_region
      0.20 ±  6%      +0.1        0.28 ±  5%  perf-profile.self.cycles-pp.down_write
      0.23 ±  3%      +0.1        0.32 ±  2%  perf-profile.self.cycles-pp.__kfree_rcu_sheaf
      0.14            +0.1        0.23 ±  2%  perf-profile.self.cycles-pp.zap_present_ptes
      0.00            +0.1        0.10 ±  5%  perf-profile.self.cycles-pp.ksm_vma_flags
      0.20 ±  2%      +0.1        0.29        perf-profile.self.cycles-pp.mas_find
      0.25            +0.1        0.34        perf-profile.self.cycles-pp.asm_exc_page_fault
      0.27 ±  6%      +0.1        0.37        perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
      0.23 ±  2%      +0.1        0.33 ±  2%  perf-profile.self.cycles-pp.unmapped_area_topdown
      0.22 ±  2%      +0.1        0.32        perf-profile.self.cycles-pp.__munmap
      0.06 ±  9%      +0.1        0.16        perf-profile.self.cycles-pp.barn_get_empty_sheaf
      0.27            +0.1        0.38        perf-profile.self.cycles-pp.sync_regs
      0.24            +0.1        0.35        perf-profile.self.cycles-pp.up_write
      0.34 ±  2%      +0.1        0.45 ±  2%  perf-profile.self.cycles-pp.anon_vma_compatible
      0.42            +0.1        0.53        perf-profile.self.cycles-pp.mas_prev_slot
      0.25            +0.1        0.36        perf-profile.self.cycles-pp.up_read
      0.06 ±  6%      +0.1        0.18        perf-profile.self.cycles-pp.barn_replace_empty_sheaf
      0.09 ±  5%      +0.1        0.22        perf-profile.self.cycles-pp.__zap_vma_range
      0.32 ±  3%      +0.1        0.45 ±  2%  perf-profile.self.cycles-pp.__alloc_frozen_pages_noprof
      0.20            +0.1        0.34 ±  2%  perf-profile.self.cycles-pp.mas_preallocate
      0.23 ±  2%      +0.1        0.37        perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.31 ±  4%      +0.1        0.45 ±  6%  perf-profile.self.cycles-pp.lruvec_stat_mod_folio
      0.41            +0.1        0.55        perf-profile.self.cycles-pp.__handle_mm_fault
      0.40            +0.1        0.54        perf-profile.self.cycles-pp._raw_spin_lock
      0.49            +0.2        0.66        perf-profile.self.cycles-pp.mas_store_gfp
      0.38 ±  2%      +0.2        0.56 ±  3%  perf-profile.self.cycles-pp._raw_spin_trylock
      0.18 ±  3%      +0.2        0.36 ±  7%  perf-profile.self.cycles-pp.page_counter_try_charge
      0.48            +0.2        0.67        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.21 ± 23%      +0.2        0.40        perf-profile.self.cycles-pp.rmqueue
      0.32            +0.2        0.52        perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.42 ±  6%      +0.2        0.63 ±  2%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.27 ± 16%      +0.2        0.49 ± 13%  perf-profile.self.cycles-pp.__mod_memcg_state
      0.60            +0.2        0.83        perf-profile.self.cycles-pp.native_irq_return_iret
      0.52            +0.2        0.75        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.34 ±  2%      +0.2        0.58        perf-profile.self.cycles-pp.kvfree_call_rcu
      0.65            +0.2        0.90        perf-profile.self.cycles-pp.mas_walk
      0.56 ±  6%      +0.3        0.84 ±  9%  perf-profile.self.cycles-pp.page_counter_uncharge
      0.62 ±  4%      +0.3        0.91 ±  2%  perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      0.74            +0.3        1.06        perf-profile.self.cycles-pp.mas_wr_node_store
      0.96            +0.3        1.30        perf-profile.self.cycles-pp.__mmap_region
      0.40 ± 10%      +0.4        0.80 ±  6%  perf-profile.self.cycles-pp.try_charge_memcg
      0.43 ±  7%      +0.4        0.84 ±  7%  perf-profile.self.cycles-pp.perf_iterate_sb
      1.18            +0.5        1.65        perf-profile.self.cycles-pp.zap_pmd_range
      0.48 ± 10%      +0.7        1.22        perf-profile.self.cycles-pp.mas_update_gap
      1.00 ±  8%      +1.0        1.96 ±  6%  perf-profile.self.cycles-pp.__memcg_kmem_charge_page
      0.79 ± 11%      +1.0        1.76 ±  2%  perf-profile.self.cycles-pp.tlb_remove_table_rcu
      0.88 ±  6%      +1.0        1.88 ±  2%  perf-profile.self.cycles-pp.___free_pages
      1.45            +1.1        2.54        perf-profile.self.cycles-pp.rcu_cblist_dequeue
      2.68            +1.2        3.87        perf-profile.self.cycles-pp.zap_pte_range
      1.23            +1.2        2.45        perf-profile.self.cycles-pp.free_pud_range
      1.26 ± 16%      +1.9        3.14 ±  2%  perf-profile.self.cycles-pp.__rmqueue_pcplist
      2.60 ±  6%      +2.9        5.52        perf-profile.self.cycles-pp.__pi_memcpy
     10.99            +4.3       15.29        perf-profile.self.cycles-pp.native_flush_tlb_one_user
      7.24 ±  2%      +6.0       13.22        perf-profile.self.cycles-pp.post_alloc_hook




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


