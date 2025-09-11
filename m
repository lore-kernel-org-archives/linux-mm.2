Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12BCCCAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 22:07:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0D48E0008; Thu, 11 Sep 2025 18:07:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 671568E0001; Thu, 11 Sep 2025 18:07:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EACE8E0008; Thu, 11 Sep 2025 18:07:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 352218E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 18:07:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D1E811DEFD1
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:07:37 +0000 (UTC)
X-FDA: 83878356954.25.E0D8084
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4816F8000E
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:07:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Pl32/Vgs";
	spf=pass (imf30.hostedemail.com: domain of reinette.chatre@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=reinette.chatre@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757628454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Yb5jZGdD0sSS+5D1aGT7DsEJz3AB9mw/RY9EV+oKqU=;
	b=Fqg07p9S3xRsChv9Y4Sk2aD3G8z2pAuYUaysZTQQQ6KpuJ3IuAWa77fHt1BUQ1P9PNceD3
	y4KVJjblOt5p1MOW2vRpfLXwO51/n0wrjgWVhxguzpkETS7HaJ83a1cXkBLFB0TqNAY6tD
	rZVDMEc4of9R1z/KaPAVo0Y52ehtEsM=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Pl32/Vgs";
	spf=pass (imf30.hostedemail.com: domain of reinette.chatre@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=reinette.chatre@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757628454; a=rsa-sha256;
	cv=fail;
	b=zh3luv2U7TUzuI1opCGqrSYOjARY0bynA6qAEwG97YOz/g5SNzz10efwEN8U+H+Q13dFz7
	deTfF3qrcAOTIaY2LWqjBBfQ9tf2rnQZHaTjKKN1ZwmGhPUKvLECudw0cVFOYLWaaCON7a
	YLS6SZ++eQHn6oJDTgvsluQNtbqLAaE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757628455; x=1789164455;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/0jbTR5no0OX5GVvppW5xzir+Y05qrAhgk/zorEwNO4=;
  b=Pl32/Vgs1Yv/t4LpcUzliZ8HekHAK53eDO6Xik27pXP9lN5ThOOvE7kY
   7p3VCmGLmRyZrQsS8O/mKVuM0fw0sWush5MzU/plMs4TOTVY1P8kNZGZe
   PTc0C+JCcoNthppSW7hWeYxLWt7B6feR1H2f1CzXKx4ARnhUdmKi6leQr
   yYLOgQJE8ytBzpf4nv/8sI49FTYJqaPRS2hb7rJojUGmrlP1N5pUPfHal
   cgGPkbkQHT8GOV5c/WwmhMjT+ITbXC3gXqHD2fvY8GD21ZwJmaWUQ4vUt
   Op0mXKKFOPwfyMy5zBroAYjGODzYsMW3icZFhsSNE+jOnGDPoOEy46kpS
   A==;
X-CSE-ConnectionGUID: 9kjWHrpVQ12NWqipIWtChw==
X-CSE-MsgGUID: aLrDxRRPQ5uRApeY3FpFDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11550"; a="71349774"
X-IronPort-AV: E=Sophos;i="6.18,258,1751266800"; 
   d="scan'208";a="71349774"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 15:07:33 -0700
X-CSE-ConnectionGUID: fxqupNegR/CqAnoDOWiuoA==
X-CSE-MsgGUID: 3hMBsVIaRWWKRDkUUGglng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,258,1751266800"; 
   d="scan'208";a="173710304"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 15:07:30 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Sep 2025 15:07:29 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 11 Sep 2025 15:07:29 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.64) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 11 Sep 2025 15:07:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rqDNgKe8mBHicsje7i1Z+3vUa+N0iv+fkR96LCZNnfuBoJLgZ5EEUwoM6UR2XY1LvxqloiceHAf4sAe/cSPMxlufqyWX3ovoGImcv/QrRPCIfOts3KBA9BSQZAQlPCfkpXfuWPbsFbZNkDqUR5e+/LEAksj8n9i8XUaE6YZsy8pndyZ1gW2zmJOcME40rHbwKLPQaBkmXI2nS6mgBm8iuXBYFIMDSNrjRI+3fWoo65iC0FNY/FKm5rC9qaM+uOBnCEDLK5MSX6OmZGpIzZwrAqnsSaZGCQcaBfWLO0bTWsz9anYTjAhH4sfN0OJB3SuYB7GC6V0fOTdP74UGMw26Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Yb5jZGdD0sSS+5D1aGT7DsEJz3AB9mw/RY9EV+oKqU=;
 b=jkSAEq98XNF45dpVyqG/x4x1EnOhZ/imo6pAR83pY2mMqGr73T9aGK/U5sakWd4k9pz9K5b/uU5pvNU5fB+G1AvR0blLoZBkR2PEFA9vav3OfnQ4RWgPFCK3yP0L3kjbluc9lDq+668sRrHSJAaPQVuoMFFTvaPQwITJCcN0cbHVQDhQz0MenniiWmhBZvHEypGvFZGgKv+Kv4Wg45xHxFpWRLG5QVagQJFxkfve/1VqLVQLom72b8iYn1OnMyvugbQLJIB2Riu8CtBZBLobZlwygnJZLmsyLYa647f9WIjvEb6IK/fX9RoWk4XkOndf1LWx3JNKpIrx/czPxejDMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA2PR11MB5035.namprd11.prod.outlook.com (2603:10b6:806:116::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 22:07:26 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 22:07:26 +0000
Message-ID: <dce30be7-90d3-4a6a-9b26-44d76c3190a0@intel.com>
Date: Thu, 11 Sep 2025 15:07:21 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/16] mm: add ability to take further action in
 vm_area_desc
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton
	<akpm@linux-foundation.org>
CC: Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
	Guo Ren <guoren@kernel.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger
	<borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, "David S .
 Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, "Arnd
 Bergmann" <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Nicolas Pitre
	<nico@fluxnic.net>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
	<osalvador@suse.de>, David Hildenbrand <david@redhat.com>, Konstantin Komarov
	<almaz.alexandrovich@paragon-software.com>, Baoquan He <bhe@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>, Tony Luck
	<tony.luck@intel.com>, Dave Martin <Dave.Martin@arm.com>, James Morse
	<james.morse@arm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, Jan Kara <jack@suse.cz>, "Liam R . Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Uladzislau Rezki <urezki@gmail.com>, "Dmitry
 Vyukov" <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, "Jann
 Horn" <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-csky@vger.kernel.org>,
	<linux-mips@vger.kernel.org>, <linux-s390@vger.kernel.org>,
	<sparclinux@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <linux-mm@kvack.org>, <ntfs3@lists.linux.dev>,
	<kexec@lists.infradead.org>, <kasan-dev@googlegroups.com>, Jason Gunthorpe
	<jgg@nvidia.com>
References: <cover.1757534913.git.lorenzo.stoakes@oracle.com>
 <d85cc08dd7c5f0a4d5a3c5a5a1b75556461392a1.1757534913.git.lorenzo.stoakes@oracle.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <d85cc08dd7c5f0a4d5a3c5a5a1b75556461392a1.1757534913.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:303:2b::21) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA2PR11MB5035:EE_
X-MS-Office365-Filtering-Correlation-Id: 104ed724-b80f-487b-4edc-08ddf17f97a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eDM4VnBna1g3SjJRb00wdjJNN3haRzlDaHhNc1VEMUhZNWZOb0IxRERDM09K?=
 =?utf-8?B?NVlVRnVlNXlzYTZsUnBoZzFkRUszSTdRRWNKaFQyK0h3QUdjblZNUlcvNEZl?=
 =?utf-8?B?UFZYZ3g1WTVIWkNuNjFiN05sWHVhUWNQNTI3UUxxbUViUWlXRUdTdHJRNlZh?=
 =?utf-8?B?aW9ybE1RYTlEZGVKa3dyQjJPUVJVajFUeGdzK202a2o3SWt5NFZaR3drS2x6?=
 =?utf-8?B?c0JsSTBTNzA1a21SZFdrYzNWdFk3NDFiUWovVVgxTjRHRkh5WU5ubkxKbXNv?=
 =?utf-8?B?aWIzTFg0bWVqRFVzSmRpQTNKdVI5UlJoTVBwcWxlQk10TVVHRUFNTituUzR4?=
 =?utf-8?B?N2dFZ1VQOVFVWVN6amdVYllnVHFFU1RFUS9lN0dyQmxOenR1UW02THhPNnV3?=
 =?utf-8?B?SmxBWjFDbHhtMmk5aG51SCtZYzFvOVhYd3JlUnJFQkk1LzRiSVJpZmtDeDJQ?=
 =?utf-8?B?NGlLSzdUbDMvYkxNR3RBbXE2ZmU2c1U2U0U4Tk4rWW1nSkk5RzZPWjBiUjlJ?=
 =?utf-8?B?UnBGYkRKWXdRbEErOUZ2QVE0U2sza1BZZzdScVpaV0NocUw1b3BzOUN5TEJa?=
 =?utf-8?B?K0cwWkFDZWRRRVVUdlVIb3VnY2Fzc0liWDVlck02dWJNWHdnamlRbnBySm5P?=
 =?utf-8?B?dE01YlloUXBOM2xYa20yVytxUUR6REhmY2ZkQkg3bXdIZFc4RTdDNE10UGZk?=
 =?utf-8?B?S0RabHI5L2djN3R2ZFB4RmF6VEVkMlBsa2gyK3F0czhUaGNiVDlpNnpKUW9n?=
 =?utf-8?B?Z0lYdUNsOHEzVTZMVGZ2U2NtUHdybWlZTzRDMEtSY1U3UUZnQW4vemhFVnJO?=
 =?utf-8?B?NzJOcGxOODVUc2dZTGxZdUhOOS8xaXRqK2pSMXFMOU9ZdlEyc3dkdVBwZjdO?=
 =?utf-8?B?VnZLK2h1WVBUZWlOYU5BMlgrVUQrYis0dXRNQmpzNE80czdVRUszLytOcDV3?=
 =?utf-8?B?UFdTQm9UL0JsbTZIay9vdEhvc3FTaXhSb1BINUpYQmxxL0dHLzl2eEU4WjNa?=
 =?utf-8?B?em05ZWJaL3A0T3NGNHhhZnNMZWhlTTZYbzVKRE4xSStvT3N0RTY0NU9HMFNE?=
 =?utf-8?B?NW1MUXM4MDVvM0FIMjd2YUt5ZWtVRFd4aVQ3bWJkTyswYXNjRk0zZHV3b1hB?=
 =?utf-8?B?UlF1YzZPbjFmZFo4N29kN2UzMDVCcGZoY0FUQ204WnBTNkg0RE1zR0libk0r?=
 =?utf-8?B?NXdyb3FkbkdUYk50aGYvU0ZJK3FpRkVsMlZETEhGUE5HUEw5K0JsS3dVSmpp?=
 =?utf-8?B?TnJ4cTdTbDZ3T01EQUI4cEpWeFVTYWtzOE1aUlFJMGpSOE9iV1pEdnZCSDl0?=
 =?utf-8?B?M1dtNXJWVUJwcU9CUUpabXNEK3VSbWJ3T3ZzbnIzQ3JIbDY0alR1S3lLeWsv?=
 =?utf-8?B?ZWhkdis1QUhMRTZPbi9KMWxkNXNmcFVXWUNEWFQxNzk2Y1ZZUXR4UExCbEls?=
 =?utf-8?B?WVQ2ZGJnRERDaVdtaG9LbGxJaXZjSkppQ3VlUnZzZnlickRVQVRyUEJyS01M?=
 =?utf-8?B?UVNVcnhKaUlNOTUyYllLZnFSNmRMOU5kMU1Iem5XVmNDakhPbm8rbDIxazJF?=
 =?utf-8?B?T0N6M3kzK2FFVzFxKyt5OGFOUjlKNUJXaFRJcXlGS0lGeGN1Slc2dHF2anJF?=
 =?utf-8?B?b0VwWEpZUnlUUDNXNjBUS094WTUzUE5aM3FmUUFtNllzZ1p6YjBXUHBBMkQv?=
 =?utf-8?B?RkhOSHlMSkdVMVQ0RzdmZzhJUFgxellQRGFSTll0NHRaTm1IS3pPYjROK1Rs?=
 =?utf-8?B?ZTRIRktwMDhDV1ROUlNlUDEyZzhObFEwak1XeFdGUDlNZVhJTUtEaDBUUGgw?=
 =?utf-8?B?QWI3S1FRbE5PQy9LNFVsOWpvU3pqMk9iRXd3aWxobS96VXViQjNhZkRzVHBF?=
 =?utf-8?B?UWE4SGJMcVBjbGtsTitRVTBmZTdJUmRLWEQxUHI1VWIxcEtHUzB4V1E3WHNz?=
 =?utf-8?Q?EKmVJ1TaePc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGVUZWYxa1pQYTZpeElDYmU5aVVFdC9uT3JwT3ZadnpIc0RZWm1hZUwxZ2I5?=
 =?utf-8?B?TndzaG1pQ2d0WTJCOTd5VlpzdEI1aXhJaU9yV3dPdUhwcDNIelRWd2ZqVmZt?=
 =?utf-8?B?bW9DRFNmL1drR2lBWms0c1BTdHlwYTdTdnBQVDZNbm82eUxuRjFyR2wxbWl4?=
 =?utf-8?B?ZitYTHhCOFFNWlVWMWFnUlpFZXJsSloyWnVvN3d5TXczY0hFZy9nL1hybEww?=
 =?utf-8?B?T09UcmwwTUM3bVE3MFZYZnRCNEx5dmgrbTVvMHZiTlhoK1BNb3llYVdnYS9B?=
 =?utf-8?B?Q0dydDN6QTRKelZwMDkvTEdJWW1YbnBpdGh2SUttNGZJeWdZbVRQcWI3Qm1h?=
 =?utf-8?B?bEJyWjFmNHh6VHU1R0l2QmNjMUJGQjg3S1R1aEV5MzNxd1IrS29Rd1JGMFhT?=
 =?utf-8?B?cmVlS0xqZndzbWxzSDBtSk1BanJBOUppY2oyWGpjR2F4SWNjZk5RZjBYaXBp?=
 =?utf-8?B?dXNzZGxFN3liamZSOEhzNkh2eElDOGJDRUJJYW1TV3V1TEVsWkgxSHRLWjdW?=
 =?utf-8?B?YjhhcGhReGZ4ZXlkMGwzZ0J5a1l5WDF6WmxHSzFCeWFqUUFQbU9RTzdHQXdV?=
 =?utf-8?B?cmJCSXVTUGlYZ29IQ21rTUJTbHFQREt1WGpHZUEvQzEwVHRtKzRHdkhVVG84?=
 =?utf-8?B?MjZZWTI1bmdCUFNpOWpZM1A5cHFTYktUcUNJa3J5Ni9BODh6bkliZDBodEsw?=
 =?utf-8?B?SnZPSGRRSVgvQVM0V0FaYzgrMWVtakJ2VFU2WFNkUExuRXRSQmFIdmc1VFdL?=
 =?utf-8?B?MENJdC8xQllRNFZkMHhiaXlEVTd1U3F3R2ZXeFFFbyt5OUIyUDBsekZObDdx?=
 =?utf-8?B?UWhYSUw0cGdmWGk3NTFJbnkrSXcrb0hsOG5VUmsxbFVGNTAxNnZnZEZIVWJk?=
 =?utf-8?B?TktFT2FUZnFKSC9OemhSV1cwQmlpeWJsb0dBbExnVy9OR3VGWktsbE5GWUM4?=
 =?utf-8?B?Q2M2dGtFWGZTLzIyZXduaHdsRGlKZGl2WGpTdEVuNDlGNk1RaGZCUFVPcDg0?=
 =?utf-8?B?YjJQbW9TWVFkVnVJdHFnNUNRL1pBWFoyWHJmOWZ0dXNsQm1nSnhFOGZIK2tz?=
 =?utf-8?B?TUlpdDQ3Qmc0M25IZXpxZ0toejh4MDMxSXE0bktBcEZ6bDBnUXFaMS9POEE3?=
 =?utf-8?B?bXgwTkZVYlJYUFI1Yzk4bHRjNktreGUzTHhWcllQQ1g4Q3hBVU53V05jRnE5?=
 =?utf-8?B?VFRXbVZPZTY2VlFsa1g3d3ZnYVpJQWE4SHhEY0ZxWTNzSmwvK3kvMndVVXJH?=
 =?utf-8?B?NEgyQ1dWYWlXU0gxOVQwYmhPNmRaWXdmQ3NWaUNlbEN2MnpsNTdQYStVckxX?=
 =?utf-8?B?bHdudU5lTlhyVDhsQm5VTkduNEE2VHVNUkp2SkpDQk9QZThiYzg5UHZNM2tk?=
 =?utf-8?B?RGpXMzdxT0doR2V6ZW05cHRNUVVrdzdwdDVjUWFWRytva2hyMjNxUlk2R3dh?=
 =?utf-8?B?ODlydXVLSmlVVmIxU01iSXZXaXcxK3MvZnJtb3ZaQWRHMWIrTnpJdys3UE5m?=
 =?utf-8?B?UGtIVmZqN0E3QVF4YlpZeFpKNzVWcFFWNDhuMlJ5UmFPR1ovbUxYNEpveUlR?=
 =?utf-8?B?eGphS1A0WGFVSUxoQVJCTEE0MEordENyM0oyUTBLK2hIMm55bEN4WTc3WW5G?=
 =?utf-8?B?VS94b3NoMWkzNlpNd2RNSzRkQWNDVVFVTnBHUHVjbDJlaFdITW1jeWJySVpo?=
 =?utf-8?B?TXcrbTFWa3Y3UVJTOW9XODBSTzExazFUOGZzaFBnQUtIVTcraFc1Sys3K3VH?=
 =?utf-8?B?cWc1WEVlcSs1eE55azdzTnBXYmJxZlRsZFZXaGU3aEY0aHg5aE5BUTZndnFB?=
 =?utf-8?B?VUpOeU1TMVBOTEVGcXJKNk5NRzMza1BpQWJmYnlXazVQNjBqOFdTWUJqTWl5?=
 =?utf-8?B?dHJmZ1YxMXc4d2I0WlphSWxzU0c1RVdnRDFkNzE2RSs5Y0VjTlV1ZFdMRmRU?=
 =?utf-8?B?QUR2SFZ1NkpLWlFzSVNhQThCL0Q1S1Nhdzd1REd6bUVHNHVId1FESWRUdk1F?=
 =?utf-8?B?VGQvYnR3SXdJRkRHWTR3VXpJYktFTkRHSUl0TE4wcm5qWTBET1owOEFLOXMz?=
 =?utf-8?B?MGxQaWkzd0lNOXI1WG9vNU91OFZLdHZ1V1RVR1dNUzUzWXVkV0xlSm5pQjVl?=
 =?utf-8?B?WXI4dHVOSXdRN25rNHBLZ3g3ayt6SXkxZytpOXRxdU5pNzJya0pTTmoxSC9T?=
 =?utf-8?B?VFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 104ed724-b80f-487b-4edc-08ddf17f97a2
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 22:07:26.5698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MBxoLnLomYseB9mjG3m6U94rsNPsKwzmOs4mn79Mk++qLduFtEp+EQJ789YL7nPnhG10yna7KpqGmrq2df+lNJ2pl05FoIG9mVAKX7d+d28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5035
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4816F8000E
X-Stat-Signature: 1ncgdj71in5yntr1amnn8ptqupudxk4c
X-HE-Tag: 1757628454-176640
X-HE-Meta: U2FsdGVkX19Y9MPjQor3en2KUkQciCmAeQcKkG5q7e+eT9pqTiFFYG8wwd8b/uuZvo81tD416MP1Tu1xgpX2XQJfRGlFI6y8HYRsXH0NDRNax1u0/uSR7TbF9Qv8UToXxv8UI7syIkEiUnJ6e3MlAaW2iG7Lln549+8nk+mgQ7gM4hpw07KqtUtDewvG1CEq7VLq8zGxtHc3iDMZWFi+KRr8ro5msg2i/0Y3zBR67isoxV1W+pUO2hGBVpB3qd7CGwdwXuJHzwJtVjLl5l4MM33cqHmsrxtzOqtaikamKxDrqFA6ozWC4W3krNSnN4BESEvX6CqzxO8dT6zekpnKZqbty3IAJTIJmUnjbsdF19AVS3dxNZnRLneIW9ct2Sp2uYgsD7AErI7ZUyTKrSIBBre3taOEu3Aau+IFOD4n9PL8uWmFRIuET+oDb1OWKmcx26Jreou+E7yLPATJuQjedKJKFZhVYJRYCI9dj+WlYGyxQ50/h5B6Vs3zSCJd7kfy3qGnwkMAUoDqMWrRrTPFllaGgbw85mN73AHBVGpt+JjgoqfTb6gfDVp98DUOcpjhrHw+v2OLBk2cpAorBQ1Pdbud8gVUFpmyZGK3rbH1CaFGm+23Jc3hze4nzWq8ouYgS8CQc5ppbw1pBMbcPaIp4gaubeEDX5zGNjcyUd6Pj+IYBH5RyJhQozRDPPYGtnoR6P7nDNOknuWea1rapM/HwL4PjY43ejZe0JJMBXJQSabjtnhoE3AjdaVfRE3jpM6THHc+WsUiWBwiAcmeECToTbfYqD7RjPxQQZRgSUmE+2xiyoq1f8NNthU9379x3yZWeOlnL/JEghzoPV11ZV/emvoIicxTvee0pEMH6G8aSCPqWoBe3Ppepig7jI8LNJxCW3VMjvAGVKQBx55CsGJLADQCTp3Nv44oVMTjCTJuCtRX6CoQhkB9ivaudVXnlF1WwHUVtCJAwONhFBCo3ef
 eoXOceE7
 zc0nU+8WR+/MVLa0tSw9xPcRvaFpMScsckYlU++PIujom2yaiVUOBWclbhwbN+rNHuRh4H56+xlvRjQblQGWVIJRdHBdXanpFX9F6verXQy3NLHfWaGlfwp4Fbkly06DBa51xi1pESdybpmhHJkYyPHeb7JbSiik+nVFzMxxPppmy5JwQQjZuPFFql1MNzlOV61/3ynpZRLn+gHLDGz5swS80tDOl+F98N4gZE2lyZraWyDVnjBt5ZSFUlupfyX0dZ8xehlWoMRaI9TMuV/8TvQiYj+ObKfBzgNFGIqzk5+hGEbe3yltctx7aRbpnIDc9wXmCiuLnZ64oPQ9Oo0zR1Ovr963m24NCUEH3F9efLJxpJXtEgmPjP8lgAcj1hLZu5opgVIoNBD2Gyi4sYK4teFpCN6nVJe63kIhFbGzjHjltUq7BpwLL5oy/YnODcFK++57GB0GJBMjn/9YAZ4dGcapM3S6rcV++UbAUCPSWheStFtVGU58fgGDBEtt7L8xpkhps+k4ogkAuZHFztSmS0e+39MFTUoARfmYc/QKjdMqJs/r/KMPjCvyfsselKtJaa2Q4sDU4VqOW8fur41PWyymuop13wrV4y8LyF1pMFQ4SbwEiFHq5pLWKNd8iuEK2Gg9nHIy29PVgsjE7nvCYnhpvobnn+deMzPrz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

On 9/10/25 1:22 PM, Lorenzo Stoakes wrote:

...

> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 4a441f78340d..ae6c7a0a18a7 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -770,6 +770,64 @@ struct pfnmap_track_ctx {
>  };
>  #endif
>  
> +/* What action should be taken after an .mmap_prepare call is complete? */
> +enum mmap_action_type {
> +	MMAP_NOTHING,		 /* Mapping is complete, no further action. */
> +	MMAP_REMAP_PFN,		 /* Remap PFN range based on desc->remap. */
> +	MMAP_INSERT_MIXED,	 /* Mixed map based on desc->mixedmap. */
> +	MMAP_INSERT_MIXED_PAGES, /* Mixed map based on desc->mixedmap_pages. */
> +	MMAP_CUSTOM_ACTION,	 /* User-provided hook. */
> +};
> +
> +struct mmap_action {
> +	union {
> +		/* Remap range. */
> +		struct {
> +			unsigned long addr;
> +			unsigned long pfn;
> +			unsigned long size;
> +			pgprot_t pgprot;
> +		} remap;
> +		/* Insert mixed map. */
> +		struct {
> +			unsigned long addr;
> +			unsigned long pfn;
> +			unsigned long num_pages;
> +		} mixedmap;
> +		/* Insert specific mixed map pages. */
> +		struct {
> +			unsigned long addr;
> +			struct page **pages;
> +			unsigned long num_pages;
> +			/* kfree pages on completion? */
> +			bool kfree_pages :1;
> +		} mixedmap_pages;
> +		struct {
> +			int (*action_hook)(struct vm_area_struct *vma);
> +		} custom;
> +	};
> +	enum mmap_action_type type;
> +
> +	/*
> +	 * If specified, this hook is invoked after the selected action has been
> +	 * successfully completed. Not that the VMA write lock still held.

A typo that may trip tired eyes: Not -> Note ? (perhaps also "is still held"?)
(also in the duplicate changes to tools/testing/vma/vma_internal.h)

> +	 *
> +	 * The absolute minimum ought to be done here.
> +	 *
> +	 * Returns 0 on success, or an error code.
> +	 */
> +	int (*success_hook)(struct vm_area_struct *vma);
> +
> +	/*
> +	 * If specified, this hook is invoked when an error occurred when
> +	 * attempting the selection action.
> +	 *
> +	 * The hook can return an error code in order to filter the error, but
> +	 * it is not valid to clear the error here.
> +	 */
> +	int (*error_hook)(int err);
> +};

Reinette



