Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F10DBD41C38
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 13:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 399BE6B0006; Thu, 11 Dec 2025 08:54:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34AAF6B0007; Thu, 11 Dec 2025 08:54:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 212006B0008; Thu, 11 Dec 2025 08:54:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E1386B0006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:54:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D242138C11
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 13:54:06 +0000 (UTC)
X-FDA: 84207334092.27.5F5C188
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf05.hostedemail.com (Postfix) with ESMTP id B4B47100002
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 13:54:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BSmpxiv5;
	spf=pass (imf05.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765461243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XW6ln2xKmzVeP6Y9sgLjHhcC7p7/Zaf150tsrNMiVvI=;
	b=LzosJlbh0U/oJfvbSxAue/RDFmo2eexTX3EXjVQWesXe9Nzxv6NNThck+yReRQo5OoFcs8
	+L5Di+TToIkJgbRhVJJhqD/IIj8OEIPBpcXsF667EfeqMKoBbaVUcLz/XvXjKjt6IM3SBy
	lpwzTHzEgbhYQ3BKjY0nawK7BXwB2Y0=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BSmpxiv5;
	spf=pass (imf05.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765461243; a=rsa-sha256;
	cv=fail;
	b=ehAs2q5JCW32o8dI8EgDnBzcd5sEnZjMrIEQQWvugSFsjFDsJzM91JoCmwRQXeVV9fNF+S
	hCJj2fj43npPsATIPFWrCRIUMn+eoHqN+2YSJ+oqyaEtofQHs+tcy00BCwr7yqf8BC5m/X
	s/t8FmVEnhfDOYYLlBZNFUo6ebCYiFc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765461243; x=1796997243;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yuawUYo3HwxclnlhpjUhslNcSstEaD/ZV3GJ18R7jf4=;
  b=BSmpxiv5LCRkgSD+oliDhQsnn2sILujWWs/56RR8J0LGSMTchEcI4WkP
   nJ+FL0DJxR9FKRovwD2eyMr11ITPMR2hCBbJnaZvoLjZP/+B45psC2b/d
   T2ZBU4bsCtsMJ5jUai/0bL/X1F3027kvTVU9fcOncUtDKLffVotU7l0+/
   RpE3H8vyzEfUQRYvhei1ENgXqChKBhC2jLR/smRpaPKkHVlHJXM2Kt/7I
   0eODU1lkTX9IlaAeAXoUMyi7VcwW3RWixXFl6deqUZKqdre6mipd8imtM
   T0rZjf5/dRtZmK3j+1GY1q2ZBN9XfM/eNcFNIfmnmCreaeWJ+4/TlSVsk
   w==;
X-CSE-ConnectionGUID: +ko7GiNPQ+WNPyH4K8N48g==
X-CSE-MsgGUID: 4nI3aYA0SpqhZENx0wiwgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="67328549"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="67328549"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 05:54:01 -0800
X-CSE-ConnectionGUID: ZfOfFIJcTBqICNVzIYus+A==
X-CSE-MsgGUID: 7XwRtM7QQDqSx4JGmSxz7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="201272900"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 05:54:00 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 05:53:59 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 11 Dec 2025 05:53:59 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.8) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 05:53:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dkhna/H8qEVnKL+tiuBqmz44wXrbxmJN+GTvlQDZckSbt2510NzgjnRzdsQmx4KiiDj4PlB7V9upcDKj8EuMCU/GDFZEXzsK9+XWCtM9zm+KH7dLXY3kH9qXU4SkzE2JROxcskaeSBtEw4DzObxnZFnNGa33Hh4EbHkYnfyTK7IaQZJekEzhwMO/k88R0XSE6f+xtJlsFoDqutSgbmZiThaHc3C4V+vvS9xQyJRp8IiYWkxQL8GEyXHT5sJDdAw40DcpSLNotJxuu7zYwgbqGU+J/QcE+1gGONRbjgCRkVuPIYw3Pj94gtH0eX42CWQM7IJJjvX0F15HP1uBsdUL3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XW6ln2xKmzVeP6Y9sgLjHhcC7p7/Zaf150tsrNMiVvI=;
 b=pvMJEThtqoV4H07O+ABaga5ZXujzEWfXeA6OwKbvgA2hPJQYh61WV60R2N8QCUnfAyS9cAUj3L+FbHp84QM+xkElPVMLFu38GGN6XA95cJxBrM3cVVKYSQUEhclG2A6Mv2DlAYZWcgqWe9wj6Cd9KPBfhORCvOzDarMgJaBS13iXn7sK5Y6l1Co9FzKqfSrVwTfabFjdnxLxYbwVN/4gd46mai0YcsfC/1GgVKRqfCdUMfX4F+YpN6GNr2ph2t6gZLaYXYOX+gBhKtiLVn6RX6O4Jv6B9VoWm3yXmLyNhDl2mbgLfwJJCh6vknLaaBEsi9BbQ4rmup+dh+EzN/9fHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by MN6PR11MB8104.namprd11.prod.outlook.com (2603:10b6:208:46c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Thu, 11 Dec
 2025 13:53:50 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9412.005; Thu, 11 Dec 2025
 13:53:50 +0000
Date: Thu, 11 Dec 2025 21:53:40 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Uladzislau Rezki <urezki@gmail.com>
CC: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	<oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: Re: [linus:master] [mm/vmalloc]  a061578043:
 BUG:spinlock_trylock_failure_on_UP_on_CPU
Message-ID: <aTrM5M+SyXsxJ2wQ@xsang-OptiPlex-9020>
References: <202512101320.e2f2dd6f-lkp@intel.com>
 <aToCq6XBybxAFopN@fedora>
 <aTqYZ7hearly5H6c@pc636>
 <aTrJtyGbvO/Wt5nf@xsang-OptiPlex-9020>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aTrJtyGbvO/Wt5nf@xsang-OptiPlex-9020>
X-ClientProxiedBy: KU2P306CA0056.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3d::14) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|MN6PR11MB8104:EE_
X-MS-Office365-Filtering-Correlation-Id: 85e51195-acae-46c1-dc76-08de38bcb6dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?UhlF6t0nVt5HFaHrdBeKyGK1JaJdCgXYNC7AQaZNTTr9L+KY/T5dINTyemfL?=
 =?us-ascii?Q?5UcY5PzvKcT3nhz7Z20GMkIwWlqUOlfbRFTLfgdtskHJqVo6jXtzRk0D5mqw?=
 =?us-ascii?Q?4cHlctEw4OEN24dq05yI44Ji0msH8RZBSP/VvARl1bMShrUwM/Ee9iiUO/v2?=
 =?us-ascii?Q?/+uxkv9wzrvWbZ4DzyG2Z9kxaOm7goWnu5eArXBW0n6sMYBcue0i9KJ0a6Gn?=
 =?us-ascii?Q?/fD9tEVFo5N7murSRdJ9btEfrsMDhHarSK2HUBk+qNqJ8TYhVY+oVMlw47ev?=
 =?us-ascii?Q?7thKDH975Uy3/cuekNjAIczSH7k96ai/eZTihvcM1PLRygTsTJ7B6SJzonR+?=
 =?us-ascii?Q?DZptD76orQI5/mE7TJxgc/I4PYupGNV4nZiHbRrHu5XcupWldrZAJpSI6IpF?=
 =?us-ascii?Q?RsEHVwP0xn5sBY1lcAgFpHbxBfvzgiDwmh5xGuzp00UZec2xoy/Vf3ynYMsn?=
 =?us-ascii?Q?PqWOysfUzUpE0vcHeg3rdtLWK6Ht35uoxSsHWnMJKPshIUzffRx6u3zc+y1S?=
 =?us-ascii?Q?VlDbfXjMOA4cyv5s/YH7qYRPn2VHOF7Cf0U1Ktd0A5mWSx7QHj+AAURFK12H?=
 =?us-ascii?Q?TSC88rFpf99e8mvTD7TRvuGV/2ifs6mv6OVEaTNPakpIsPipLSY36NRGU91s?=
 =?us-ascii?Q?Qt46+C4jnv+WlzisEfmokTE6L5SGiyOlhqfnCiywG6g5oeeX42Y3FP/fR5Xd?=
 =?us-ascii?Q?U6TJoU+T+8s7OzNQXAbrd1FwMfjAmX9UL0rwOhM/IA7Scg3imi3spShTdlNI?=
 =?us-ascii?Q?sigUq5ZkWF/7UCCukyiBzNGi0LL0w/MIbKGRt87XKxGRobVxlIl3ysvZAtKl?=
 =?us-ascii?Q?NtxigrUkCbfkc1UTKa3ubHg5/n9sYFSfPxU/Pm3C5Oa+Z+pR25XNMXtbaUmV?=
 =?us-ascii?Q?yqkyo8n/rTBaRUPvaoQ+VdEr80zn6R5u7WksDeCUrGXl90rkgZcQC2YnwXrs?=
 =?us-ascii?Q?nt2AkYxuEQlb92OMyDpFgtDJKyLlWG0jWdO5Vt2SHB/uH9QLMSTnF4Gx0DWu?=
 =?us-ascii?Q?KQj9J8B1MZRnNXOSvERTWyNqxDwOnRNu6UpFDcEVJZSRtJOOirGE0GEzEm2M?=
 =?us-ascii?Q?KHR6EXYIvmgf22TfRGcQEbJ43YsAk8WPVs1I46rNJDIkhEkoVpBXZUKR44ed?=
 =?us-ascii?Q?LITHDWdo7fI0w+LIle0EVgj8De8NqkNbz1/LN8PJqqkLOcTlVSfbEBBgEBzL?=
 =?us-ascii?Q?KT942dSFHptFdG7rPaEiN7qPJ5HbAl0FJdPSZG0X9k0/oQdRXdqoHIrXs5zC?=
 =?us-ascii?Q?kSvDVCwfTu5VpO8Ks5q17ciTdk+UovwSqxB/iUgZoS9hUBMOgTTIdKB4DnbN?=
 =?us-ascii?Q?qJpCZ1ggzojYYwmgVKT66PRKN/eHrp5YxGusT2Sihwt6Pxw6ZC8PCxHaCRjx?=
 =?us-ascii?Q?T3biyTglckLD/B9Rn+AK0MNYbh65QAddgGZjpdjDmIHGK5J423b+oTkIhP3j?=
 =?us-ascii?Q?CeKcZ7Rawyy14Dlr3hXMsdjNuPbOrqIHtoPp8cjb+W0RNTc0ucHgnA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O97cTJ3M8kSq6NC90TzDvz0JOTdSAG4blrhb8MBGtu+O9e6zhbgtJ0JeoVut?=
 =?us-ascii?Q?flM2uP/RIc+ui4thL/IopFf4duo+o04xprT8Zcv5birA2BiZ6RrL08hkwbSa?=
 =?us-ascii?Q?fsXO4ssOtJczc3IZCQwcuMePRKoy2J+12lLcNw77z+wKZ1GNqQelL6DcMlMG?=
 =?us-ascii?Q?251iMmmnOX5ugCflC1WVwyovgd40msFgSXUJ2an1mNA6Tbn2acbbgDC2yrGJ?=
 =?us-ascii?Q?/yCcJusiLeAO0KolBh5XINe1vr/+4Ch5LzZKKhDemiR9WrYkqb3nwNbxujSg?=
 =?us-ascii?Q?1CppiHstkOfzfF80PuTRGGy/retL67Qu5INnVyHca5U5MKKX0JckyVW7vzlu?=
 =?us-ascii?Q?VOF8kbwNJETmQdHD3iRc9uekCbLadIg7/2uIKI2TEEE/0iD4y7YwrPHboOgM?=
 =?us-ascii?Q?XeANOLFahdCnnkHxlwLoihmH3ETFdyh6C9LfK5YebmfE7u3wOmSuUIEdPau2?=
 =?us-ascii?Q?NDiD5Kvcbtwtgg9+lkxjsMR4SBGkvIKnS6TLnC1B3AvztHrYOYUB5g1Ofnla?=
 =?us-ascii?Q?CWQIQhrhTFXVRLRbfjKWWv6Ec9V/1ULMCmeDJiOO74pG38i7xuuNlJ4qBk+M?=
 =?us-ascii?Q?azX6i24qMFlN3YbnVtAansv8JXnBghcBgY/EhB24m0Bu6LByFW/hR7fjJN4K?=
 =?us-ascii?Q?ylch52JuyyYREeFeTKp3E5NRSyIf2Gwex067eAwfQQQvp35bM8Li3XlYSczZ?=
 =?us-ascii?Q?B4OSZez2hv7yUZyqhk6ebO20rb+QFKVAJN1ihgPosHdngTaA5VEV6mWtf+DM?=
 =?us-ascii?Q?nJNTjWWxHaoXM5Hj8CszBXgET9t1J8w4u24U1V3FBvuGwvHhl7a/cNT32qIt?=
 =?us-ascii?Q?tI+ugluFQYy4iIipDScH5CU6S+KmOJLKWeh7yi1qhWfaST4yh+ZjLx/BK02J?=
 =?us-ascii?Q?aNLTtDMxct0wnVCHXg2LH7JTPSGH1ZTEydZGCQm7i991sPJlKNa9BSoU9Ap1?=
 =?us-ascii?Q?FHpZM1vlZlJm5GF8e0NV8JYdT7WMWoYdh8gTTTJ2WI0WC8miceizeehzx6lQ?=
 =?us-ascii?Q?N4Qmo24Kt9YNDfU9RTsp6wnSo9g+LQVaSW/Er1bJR2MxkDv2M1+EO8ZgKqJf?=
 =?us-ascii?Q?48ufWyvPA+PC9CFY3y4w/NgbKg0Rn+DtlGhs9Ds4KzApxthI78lDztRVmkug?=
 =?us-ascii?Q?rdsAg1VrXi2SAN14K6MF+tc6eze1Di79xQzxmMxn2kTAAm6k7tWiCNtAY2nm?=
 =?us-ascii?Q?JD7f1gBSWX+OiFzpf+zuczAy65QHuYfwgasi6g3UzzqZsUzvi5S34vSDbYJE?=
 =?us-ascii?Q?ryKUYVTVdlrYQfOJZxFNFnH5TdY+MsGn1NTzTmdOfVtqc9rUgCWevlWaASux?=
 =?us-ascii?Q?pHyL2KyVh9q4B76kfUwDA/KDsb6S0/MZjkIJQcGYkGjv7R+x+QZ2xDZdmnrk?=
 =?us-ascii?Q?dePy15LtUEz6PFzYvOX/TS49zhGkEeq5ADs3Po60h63Jkwh9yNCElQGiwzCa?=
 =?us-ascii?Q?OKUy9mVA/U2bPkFjKGmvzn3sIxuUITA1Jk7erKnioUiDYYkj2hdHtP8n0Bcl?=
 =?us-ascii?Q?cRJm8Xmiz2/WEZxKchGyGIsnBT54Hsq+IvCTpXRx2g9TJDVrA1Jt0BdDjJg6?=
 =?us-ascii?Q?pOgdAD1T4DZf9XW+MSNnx7nVkXCiyg5+qSBbebRo1rgVmd65C6xTGDMxxpAF?=
 =?us-ascii?Q?LQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 85e51195-acae-46c1-dc76-08de38bcb6dc
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2025 13:53:50.7043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rqtOXE4/Ob1POY3XmaO2TLxbgyWJ/jXk82BWStGPn/3DZIkGOYgIm+J2CbzoicjbM957FMNHVvSWv8QafeYxJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8104
X-OriginatorOrg: intel.com
X-Stat-Signature: 96wit3ptmyuc67y85duy49kr1rga7jh4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B4B47100002
X-HE-Tag: 1765461242-76735
X-HE-Meta: U2FsdGVkX19Td07Q8M8//EkANyJD4GbLzmG8gExToyFcWK5BldAbRvrKVwxqzstBmk4yh7RbF3qshL+WxHhMYIOY2DtFTjuLHNQ6GBKZTFZUZFmcD/kh4UNGRtG8sAI9/FgnbeQhDyciC4JvA+KxUASpP4FukDrhKWpKBfd0vVtCDSPUp7tGnYbCIT5xMiEEgqyyZnLUMRGWxTIfuriCU2PvXUTJgdxdRpcX87IPpAhwKrrzREiQ4lRKivHOErUcLcGlyktgj/KeJAtLHpfgonSc4/NCTcOkKUkRUiz7XG+mnv80hJmhyWIze9Z9cl8M/JWQrLNjstRzLLIsW0d+GhtMAkPlTxCQs2JqDLAlEgTWMvwks+Jgmlr3aLsbA2hDd0P/evFwRHCCwnLuot8B1rFuTwqIgSpEcxCFNzs5GkaOPop6xAUbj/nL3+1QiGbcsr6/Z1YUd4w0Y0jQ+YaxVTPAfbeDeKUzGrbUqg1Z9Yacni0NeCjXeBnC0Tx2PiCetBfNozMvSf+0OcRSMF0LVimVWYUlqYtemAgfmnd06US6L0HzKdyEm4QF0ttlo45fzip5GknLkD0yo3dwJedjRWgVVYk6kXGu2VMldoXSppsG22DLbpV75BBY8KpgxeG89UkW9zomrSHa2cuGVMU9kn5CsiYfjyhJKoDAM/JjvMZIwpDQjYy65UU4QU3CutoWY2RTuYJ0cPoklOSVdrlO5KXTPwYVO94YWwVtueDm4B+bp2LyKW5V4vUCJUBopjIJZhQ5VJp/5ftouIVUGemtlx303Za7fxE7r+DW1Vcpt6YadgNovuBmvun14/FDVIHAJ0r7rUbBSb1g292mxTgw80aUTb5DiKE70QXu38LGoQ2cn4FOup+e4t8GEfoWYIAC2vOeKeu7lt6QEK0xECHHSkQVL+cFM9G5Qu1tJEGLZefKawHnx0dNesr6HqEqImonf64KqxabNAibn8pT7AP
 A1ssWXq8
 wMJbA7d29RabNqPFgMds/DcJGMFEAp44iDnJINlmG63CgY7p5cIHhrf3WGpkOtp+kHohjB0bw44Rf6ESPiXDqLP4Y1KSpZtXZFi3qwQ17aeL+kTL0SdwGR6+zI2UqswA7oEvElIL2ZyC9rQ/JGP8i4DYRf/lqru0fsDLQVaEQA519rl0Hg7lyUwU+erPCGFmepK5wJCcEyzSWxOfMQi+7gVp4PinKn0rUPs9NdB44p8VPAcKX3HH2vwRbx65jMO0G8eO8dflufP+6k9KcxfRYWNfu7cPst06TSd4Sr69N9wwphN7fT1+AumL7IHlZ8n2mFyR2tt15pgrrwoVUWvoshjhay37qoQT+TDlNpHQDzhs/UI+adw6kFZQbq1xjTYvJJmvkun+Kp6Nspq3pSfelpDQlbg0vxfi+GT+PuG4kAllqB0zEu/Qsn84wtRZ52ehVl3WPBpMJvWRdF8RijpNm0h6ZtK/6/NetOKmKGWMvxD1k+9JwyVF0tdarSbaP3vOi5szsl2HMQgP3HWyxxj6ULG0Gfr2w1f7bqypkKarBWkmRywrrYVLSTwSg6Ia9JrNcZcSQS4mPHTsg6BA5PDBwYWoOezV+6O9ttJp9WBi1/xAzICvLbNC95FuyvjRS4Tru2LbBklpZa7BOGkk4obfANjKOCEC4Lb1PB+tgqNh7I/F47LlGgD2pLb7PEUyMVyJzOcXsm4MMPkV6pev/nhimkTKGe5aC4KyVvM4h0bko/pLK4ow=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Sorry for wrong reply. I should reply Vishal Moola who wrote the patch.


On Thu, Dec 11, 2025 at 09:40:07PM +0800, Oliver Sang wrote:
> hi, Uladzislau Rezki,
> 
> On Thu, Dec 11, 2025 at 11:09:43AM +0100, Uladzislau Rezki wrote:
> > On Wed, Dec 10, 2025 at 03:30:51PM -0800, Vishal Moola (Oracle) wrote:
> > > On Wed, Dec 10, 2025 at 02:10:28PM +0800, kernel test robot wrote:
> > > > 
> > > > 
> > > > Hello,
> > > > 
> > > > kernel test robot noticed "BUG:spinlock_trylock_failure_on_UP_on_CPU" on:
> > > > 
> > > > commit: a0615780439938e8e61343f1f92a4c54a71dc6a5 ("mm/vmalloc: request large order pages from buddy allocator")
> > > > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > > > 
> > > > [test failed on linus/master      cb015814f8b6eebcbb8e46e111d108892c5e6821]
> > > > [test failed on linux-next/master c75caf76ed86bbc15a72808f48f8df1608a0886c]
> > > > 
> > > > in testcase: trinity
> > > > version: 
> > > > with following parameters:
> > > > 
> > > > 	runtime: 300s
> > > > 	group: group-03
> > > > 	nr_groups: 5
> > > > 
> > > > 
> > > > 
> > > > config: x86_64-randconfig-011-20251207
> > > > compiler: clang-20
> > > > test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G
> > > > 
> > > > (please refer to attached dmesg/kmsg for entire log/backtrace)
> > > > 
> > > > 
> > > > the issue show randomly (~50%) in tests.
> > > > 
> > > > 645a3c4243473d5c a0615780439938e8e61343f1f92
> > > > ---------------- ---------------------------
> > > >        fail:runs  %reproduction    fail:runs
> > > >            |             |             |
> > > >            :60         50%           29:60   dmesg.BUG:spinlock_trylock_failure_on_UP_on_CPU
> > > >            :60         50%           29:60   dmesg.RIP:_raw_spin_unlock_irqrestore
> > > > 
> > > > 
> > > > 
> > > > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > > > the same patch/commit), kindly add following tags
> > > > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > > > | Closes: https://lore.kernel.org/oe-lkp/202512101320.e2f2dd6f-lkp@intel.com
> > > > 
> > > > 
> > > > [ 1046.632156][    C0] BUG: spinlock trylock failure on UP on CPU#0, kcompactd0/28
> > > > [ 1046.633368][    C0]  lock: 0xffff888807e35ef0, .magic: dead4ead, .owner: kcompactd0/28, .owner_cpu: 0
> > > > [ 1046.634872][    C0] CPU: 0 UID: 0 PID: 28 Comm: kcompactd0 Not tainted 6.18.0-rc5-00127-ga06157804399 #1 PREEMPT  8cc09ef94dcec767faa911515ce9e609c45db470
> > > > [ 1046.637019][    C0] Call Trace:
> > > > [ 1046.637563][    C0]  <IRQ>
> > > > [ 1046.638038][    C0]  __dump_stack (lib/dump_stack.c:95)
> > > > [ 1046.638781][    C0]  dump_stack_lvl (lib/dump_stack.c:123)
> > > > [ 1046.639512][    C0]  dump_stack (lib/dump_stack.c:130)
> > > > [ 1046.640168][    C0]  spin_dump (kernel/locking/spinlock_debug.c:71)
> > > > [ 1046.640853][    C0]  do_raw_spin_trylock (kernel/locking/spinlock_debug.c:?)
> > > > [ 1046.641678][    C0]  _raw_spin_trylock (include/linux/spinlock_api_smp.h:89 kernel/locking/spinlock.c:138)
> > > > [ 1046.642473][    C0]  __free_frozen_pages (mm/page_alloc.c:2973)
> > > > [ 1046.643279][    C0]  ___free_pages (mm/page_alloc.c:5295)
> > > > [ 1046.643956][    C0]  __free_pages (mm/page_alloc.c:5334)
> > > > [ 1046.644624][    C0]  tlb_remove_table_rcu (include/linux/mm.h:? include/linux/mm.h:3122 include/asm-generic/tlb.h:220 mm/mmu_gather.c:227 mm/mmu_gather.c:290)
> > > > [ 1046.645520][    C0]  ? __cfi_tlb_remove_table_rcu (mm/mmu_gather.c:289)
> > > > [ 1046.646384][    C0]  ? rcu_core (kernel/rcu/tree.c:?)
> > > > [ 1046.647092][    C0]  rcu_core (include/linux/rcupdate.h:341 kernel/rcu/tree.c:2607 kernel/rcu/tree.c:2861)
> > > > [ 1046.647774][    C0]  rcu_core_si (kernel/rcu/tree.c:2879)
> > > > [ 1046.648439][    C0]  handle_softirqs (arch/x86/include/asm/jump_label.h:36 include/trace/events/irq.h:142 kernel/softirq.c:623)
> > > > [ 1046.649202][    C0]  __irq_exit_rcu (arch/x86/include/asm/jump_label.h:36 kernel/softirq.c:725)
> > > > [ 1046.649919][    C0]  irq_exit_rcu (kernel/softirq.c:741)
> > > > [ 1046.650593][    C0]  sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1052)
> > > > [ 1046.651520][    C0]  </IRQ>
> > > > [ 1046.651984][    C0]  <TASK>
> > > > [ 1046.652466][    C0]  asm_sysvec_apic_timer_interrupt (arch/x86/include/asm/idtentry.h:697)
> > > > [ 1046.653389][    C0] RIP: 0010:_raw_spin_unlock_irqrestore (arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:194)
> > > > [ 1046.654391][    C0] Code: 00 44 89 f6 c1 ee 09 48 c7 c7 e0 f2 7e 86 31 d2 31 c9 e8 e8 dd 80 fd 4d 85 f6 74 05 e8 de e5 fd ff 0f ba e3 09 73 01 fb 31 f6 <ff> 0d 2f dc 6f 01 0f 95 c3 40 0f 94 c6 48 c7 c7 10 f3 7e 86 31 d2
> > > > All code
> > > > ========
> > > >    0:	00 44 89 f6          	add    %al,-0xa(%rcx,%rcx,4)
> > > >    4:	c1 ee 09             	shr    $0x9,%esi
> > > >    7:	48 c7 c7 e0 f2 7e 86 	mov    $0xffffffff867ef2e0,%rdi
> > > >    e:	31 d2                	xor    %edx,%edx
> > > >   10:	31 c9                	xor    %ecx,%ecx
> > > >   12:	e8 e8 dd 80 fd       	call   0xfffffffffd80ddff
> > > >   17:	4d 85 f6             	test   %r14,%r14
> > > >   1a:	74 05                	je     0x21
> > > >   1c:	e8 de e5 fd ff       	call   0xfffffffffffde5ff
> > > >   21:	0f ba e3 09          	bt     $0x9,%ebx
> > > >   25:	73 01                	jae    0x28
> > > >   27:	fb                   	sti
> > > >   28:	31 f6                	xor    %esi,%esi
> > > >   2a:*	ff 0d 2f dc 6f 01    	decl   0x16fdc2f(%rip)        # 0x16fdc5f		<-- trapping instruction
> > > >   30:	0f 95 c3             	setne  %bl
> > > >   33:	40 0f 94 c6          	sete   %sil
> > > >   37:	48 c7 c7 10 f3 7e 86 	mov    $0xffffffff867ef310,%rdi
> > > >   3e:	31 d2                	xor    %edx,%edx
> > > > 
> > > > Code starting with the faulting instruction
> > > > ===========================================
> > > >    0:	ff 0d 2f dc 6f 01    	decl   0x16fdc2f(%rip)        # 0x16fdc35
> > > >    6:	0f 95 c3             	setne  %bl
> > > >    9:	40 0f 94 c6          	sete   %sil
> > > >    d:	48 c7 c7 10 f3 7e 86 	mov    $0xffffffff867ef310,%rdi
> > > >   14:	31 d2                	xor    %edx,%edx
> > > > [ 1046.657511][    C0] RSP: 0000:ffffc900001cfb50 EFLAGS: 00000246
> > > > [ 1046.658482][    C0] RAX: 0000000000000000 RBX: 0000000000000206 RCX: 0000000000000000
> > > > [ 1046.659740][    C0] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > > > [ 1046.660979][    C0] RBP: ffffc900001cfb68 R08: 0000000000000000 R09: 0000000000000000
> > > > [ 1046.662239][    C0] R10: 0000000000000000 R11: 0000000000000000 R12: ffff888807e35f50
> > > > [ 1046.663505][    C0] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> > > > [ 1046.664741][    C0]  free_pcppages_bulk (mm/page_alloc.c:1494)
> > > > [ 1046.665618][    C0]  drain_pages_zone (include/linux/spinlock.h:391 mm/page_alloc.c:2632)
> > > > [ 1046.666374][    C0]  __drain_all_pages (mm/page_alloc.c:2731)
> > > > [ 1046.667171][    C0]  drain_all_pages (mm/page_alloc.c:2747)
> > > > [ 1046.667908][    C0]  kcompactd (mm/compaction.c:3115)
> > > > [ 1046.668625][    C0]  kthread (kernel/kthread.c:465)
> > > > [ 1046.669299][    C0]  ? __cfi_kcompactd (mm/compaction.c:3166)
> > > > [ 1046.670046][    C0]  ? __cfi_kthread (kernel/kthread.c:412)
> > > > [ 1046.670764][    C0]  ret_from_fork (arch/x86/kernel/process.c:164)
> > > > [ 1046.671483][    C0]  ? __cfi_kthread (kernel/kthread.c:412)
> > > > [ 1046.672174][    C0]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
> > > > [ 1046.672936][    C0]  </TASK>
> > > > 
> > > > 
> > > > 
> > > > The kernel config and materials to reproduce are available at:
> > > > https://download.01.org/0day-ci/archive/20251210/202512101320.e2f2dd6f-lkp@intel.com
> > > > 
> > > 
> > > Hmmm. This looks like a race condition tied to reclaim. I'm assuming
> > > we fail to allocate a page and kick off kswapd. Then when we fall back
> > > to the bulk allocator which tries to remove a pcp page at the same time as
> > > kswapd tries to reclaim it. Maybe?
> > > 
> > > Does something like this fix it?
> 
> below patch is failed to applied upon a061578043.
> 
> since before reporting, we also tested on latest mainline tip at that time:
> [test failed on linus/master      cb015814f8b6eebcbb8e46e111d108892c5e6821]
> which still can reproduce the issue, we applied below patch upon this commit.
> 
> 
> we found the issue still exists, though the rate seems drop, we only reproduced
> the issue 4 times out of 100 runs.
> 
> one dmesg attached FYI.
> 
> 
> [  448.229620][    C0] BUG: spinlock trylock failure on UP on CPU#0, kcompactd0/28
> [  448.230037][    C0]  lock: 0xffff888807e75f08, .magic: dead4ead, .owner: kcompactd0/28, .owner_cpu: 0
> [  448.230474][    C0] CPU: 0 UID: 0 PID: 28 Comm: kcompactd0 Not tainted 6.18.0-12693-g5c827f68ce27 #1 PREEMPT  b3721ff206516c93c37a896ae4d3df039c2d04c2
> [  448.231106][    C0] Call Trace:
> [  448.231264][    C0]  <IRQ>
> [  448.231403][    C0]  __dump_stack+0x19/0x40
> [  448.231627][    C0]  dump_stack_lvl+0x36/0xb8
> [  448.231842][    C0]  dump_stack+0x10/0x38
> [  448.232101][    C0]  spin_dump+0x11c/0x1c0
> [  448.232404][    C0]  do_raw_spin_trylock+0xe4/0x138
> [  448.232758][    C0]  _raw_spin_trylock+0x1a/0xb8
> [  448.233104][    C0]  __free_frozen_pages+0x750/0xa80
> [  448.233456][    C0]  ___free_pages+0x67/0x140
> [  448.233765][    C0]  __free_pages+0x10/0x38
> [  448.234066][    C0]  __tlb_remove_table+0x16a/0x200
> [  448.234412][    C0]  tlb_remove_table_rcu+0x77/0xf8
> [  448.234771][    C0]  ? __cfi_tlb_remove_table_rcu+0x8/0x8
> [  448.235153][    C0]  ? rcu_core+0x8af/0x1740
> [  448.235456][    C0]  rcu_core+0xa25/0x1740
> [  448.235751][    C0]  rcu_core_si+0xe/0x38
> [  448.236038][    C0]  handle_softirqs+0x1db/0x700
> [  448.236371][    C0]  __irq_exit_rcu+0x44/0xc0
> [  448.236678][    C0]  irq_exit_rcu+0xe/0x38
> [  448.236968][    C0]  sysvec_apic_timer_interrupt+0x78/0xb8
> [  448.237382][    C0]  </IRQ>
> [  448.237588][    C0]  <TASK>
> [  448.237798][    C0]  asm_sysvec_apic_timer_interrupt+0x1b/0x40
> [  448.238214][    C0] RIP: 0010:_raw_spin_unlock_irqrestore+0x6b/0xb8
> [  448.238575][    C0] Code: 00 44 89 f6 c1 ee 09 48 c7 c7 60 91 80 86 31 d2 31 c9 e8 e8 b4 86 fd 4d 85 f6 74 05 e8 9e e9 fd ff 0f ba e3 09 73 01 fb 31 f6 <ff> 0d ef b8 75 01 0f 95 c3 40 0f 94 c6 48 c7 c7 90 91 80 86 31 d2
> [  448.239787][    C0] RSP: 0000:ffffc900001cfb48 EFLAGS: 00000246
> [  448.240187][    C0] RAX: 0000000000000000 RBX: 0000000000000206 RCX: 0000000000000000
> [  448.240700][    C0] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [  448.241230][    C0] RBP: ffffc900001cfb60 R08: 0000000000000000 R09: 0000000000000000
> [  448.241758][    C0] R10: 0000000000000000 R11: 0000000000000000 R12: ffff888807e75fc8
> [  448.242289][    C0] R13: 0000000000000006 R14: 0000000000000000 R15: ffffea000cee6410
> [  448.242840][    C0]  ? _raw_spin_unlock_irqrestore+0x58/0xb8
> [  448.243241][    C0]  free_pcppages_bulk+0x4a2/0x500
> [  448.243591][    C0]  drain_pages_zone+0xa5/0x140
> [  448.243936][    C0]  __drain_all_pages+0x1ab/0x240
> [  448.244277][    C0]  drain_all_pages+0x10/0x38
> [  448.244587][    C0]  kcompactd+0x61f/0xaf8
> [  448.244900][    C0]  kthread+0x586/0x678
> [  448.245183][    C0]  ? __cfi_kcompactd+0x8/0x8
> [  448.245504][    C0]  ? __cfi_kthread+0x8/0x8
> [  448.245815][    C0]  ret_from_fork+0x24a/0x478
> [  448.246138][    C0]  ? __cfi_kthread+0x8/0x8
> [  448.246453][    C0]  ret_from_fork_asm+0x11/0x40
> [  448.246795][    C0]  </TASK>
> [  693.283069][  T328] hwclock: can't open '/dev/misc/rtc': No such file or directory
> LKP: ttyS0: 289: LKP: tbox cant kexec and rebooting forcely
> [  701.346273][  T289] sysrq: Emergency Sync
> [  701.346778][   T10] Emergency Sync complete
> [  701.347270][  T289] sysrq: Resetting
> 
> 
> > > 
> > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > index ecbac900c35f..0d1480723ddc 100644
> > > --- a/mm/vmalloc.c
> > > +++ b/mm/vmalloc.c
> > > @@ -3634,7 +3634,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
> > >  	struct page *page;
> > >  	int i;
> > >  	unsigned int large_order = ilog2(nr_remaining);
> > > -	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_DIRECT_RECLAIM;
> > > +	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_RECLAIM;
> > >  
> > >  	large_order = min(max_attempt_order, large_order);
> > >
> > Some thoughts.
> > 
> > That trace is not easy to follow. As for this change, probably it
> > is worth to go with anyway. Because, if we are under a low memory
> > condition, it is quite common for Android devices, we do not want
> > to kick frequently kswapd without good reason. We have a fallback
> > to single page allocator.
> > 
> > --
> > Uladzislau Rezki



