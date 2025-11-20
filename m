Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4960CF64A4
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 02:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E9FD6B0029; Wed, 19 Nov 2025 21:41:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299656B0031; Wed, 19 Nov 2025 21:41:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 113916B0088; Wed, 19 Nov 2025 21:41:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E86646B0029
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:41:31 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86430C06BC
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:41:31 +0000 (UTC)
X-FDA: 84129434382.18.0B6F834
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf10.hostedemail.com (Postfix) with ESMTP id EAE20C0009
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:41:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iXaB8I2p;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf10.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763606488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CKKjKnPs5R/AouFF/YGOUV8Sk++yg5mcHCJTojXoGKk=;
	b=TInTM1wInF9WsljDCi70JIDwX5Ng6ZiR5uAerbzI5P924xLMo+ZGoZeJ+rXzTOnQrIpghA
	R8pDtXZacdxskrVGjaih29jZUBTw9Pi98UXxHj9rgCVTK6JcCilXLRFTuAt6jHLy5ufLLQ
	rHt1B+2poYKXTakv/Pfb7mcb46/HLuI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763606488; a=rsa-sha256;
	cv=fail;
	b=jKUgG6E9Yhm1COCuNl7QQAOaj8hxEfCqAyc0L9/ZSIxUCJgTnIvhkjiX+vArzo/EHVJssM
	Wi9Z0qI3k32vYmshu2O5RAcQZhRSJ1kKX5ldloPhfPjhvMyu769uTwpEClo/4cYHXTRk6v
	OtH5AKt7M7Vj6jKRs/jnEGwznRrSnkQ=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iXaB8I2p;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf10.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763606487; x=1795142487;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=+Hu02h6gj3Jm1pwQ5JhftFRFey+v4VriUxoqB2LfI6k=;
  b=iXaB8I2pcC/u7oloE/LDpthnR4AbgN3cu2cjnArrS9siHTKb7LwR0j9H
   oFZ7zOWOty2a8wKdQCVtQJqloCMidrUCCKbNw05QL3rs//QQEyb91T2my
   omFF00wJ3wQF+TPAVXs5PTtvc3RSSInQ6B/MroAyWq0ux3FMXt9fvtq06
   Lzy/aU6QfYqw3Dv0jn0YpKH5NIalsXWUN5QZBmfIjGM/VryEx7kkCy3/Q
   wynjqy7ILb8pjT0cUU8OLUccWjDYatiUpT3mdBHw5zuIkt+f6C670PH80
   +c7sIw00NCHepf1FwtYcnUqe6BOAs/ZffY53OAuCZ2OajJEdoYmYbSIDq
   A==;
X-CSE-ConnectionGUID: 6JVKzK18TrSCeLW9RfjaHw==
X-CSE-MsgGUID: zCfTWoltRRKoFLSsGk7P0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="53237512"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="53237512"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 18:41:21 -0800
X-CSE-ConnectionGUID: oOTrpHDaR4G1l7QHqO+boQ==
X-CSE-MsgGUID: 4I/h9XzYQK2F4gEQvOP+dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="214597098"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 18:41:21 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 18:41:20 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 19 Nov 2025 18:41:20 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.30) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 18:41:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zOEPXK/NQyxLCACBOS0u/saQrvV/McE7vhe4AGADsCLUfedvjEhJehea6vFSSTUAEYl/SAJ9NlHWJUyQolu4BnZ21TMUFtMeLkQx2XieVtpbYM4rtkVcAOl1q0GPIUU9uBVL1lQpK4NYok4FKAxNu7KLQgntpvoR9MEP0erDT/LSOYeIbuu3XL/Zo/rgQTNoHQ0Xatn7qGZPL+rh0h0/mWhiQILHyfiwCzMzLS35FJvYttqjngpaha9HIp7aFIF28j7KfbUCPsGCzCMImA4caRftUosUYUoEWpWlKNUqnKMS5WlDosTi5ysUchPOeFLGeU9gzKzGEBYIPtM3YuRb7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CKKjKnPs5R/AouFF/YGOUV8Sk++yg5mcHCJTojXoGKk=;
 b=KLd+nKBvN4H6PGgbgKObIowkYcAFjSvtNfs8Q6IXvLC9M6TqOUyt2idzhyTk0XO7eNDywc7kwr27gToUZS0S80mC37v4ZzVE/665BdAkWZ6ZA8XpYgRSeRQGS6cTrPjSmXiJDf2SeeWaWnvp2UvsROKUygvCHq9h9uKJCLAmlCBp/NQkMTNODyt/dzbUr8Dh3Q6o+Zm1pYPxIR3pofO09ZZ+2V9cOiqaTINl9KXkHP6JzwjY8cKKrKEfi44/7U1I+utItxbnxgL3mXoXVe2L7ChMUW42aGfIxQgbh39/FoHS7GmOquNjQZeLKzSwuJrS0OCyjsZJ7nq2a6dOA4BtkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SA0PR11MB7157.namprd11.prod.outlook.com (2603:10b6:806:24b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 02:41:01 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%3]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 02:41:01 +0000
Date: Wed, 19 Nov 2025 18:40:57 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Balbir Singh <balbirs@nvidia.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
	<dri-devel@lists.freedesktop.org>, <linux-mm@kvack.org>, David Hildenbrand
	<david@redhat.com>, Zi Yan <ziy@nvidia.com>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, "Oscar
 Salvador" <osalvador@suse.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lyude Paul <lyude@redhat.com>, Danilo Krummrich
	<dakr@kernel.org>, David Airlie <airlied@gmail.com>, Simona Vetter
	<simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>, Mika
 =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>, Francois Dugast
	<francois.dugast@intel.com>
Subject: Re: [v7 00/16] mm: support device-private THP
Message-ID: <aR5/uUFboeeSwN0z@lstrano-desk.jf.intel.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
 <20251008201740.d9507f4807a73058d4da23a8@linux-foundation.org>
 <a5992f11-5841-4bbf-b190-b5df41b68b0c@nvidia.com>
 <aOePfeoDuRW+prFq@lstrano-desk.jf.intel.com>
 <20251111154326.bc48466a6962fbbffd8ebdd0@linux-foundation.org>
 <7a0f2704-80b5-4cbd-8f3b-ac03692eefd3@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7a0f2704-80b5-4cbd-8f3b-ac03692eefd3@nvidia.com>
X-ClientProxiedBy: SJ0PR03CA0117.namprd03.prod.outlook.com
 (2603:10b6:a03:333::32) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SA0PR11MB7157:EE_
X-MS-Office365-Filtering-Correlation-Id: 565ca6e2-5ee1-4582-7ed9-08de27de3dd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZkV4MDR0eEFBR2lpWm9BQ0lLU3JIQU5FZHNHK1ZtTkhsejJQMnNpUWo4ZEVy?=
 =?utf-8?B?SnM0TGRUb1BqcDNNNklTZXRuYjYxZWh4SUZnYzh2TDZZcDNsbklac2FqRXBI?=
 =?utf-8?B?dWRLMDhyakwyTmJYbC9sYzFta2xuTURwaDRYYUhQMGxFM2pLRFBhNGRDbGli?=
 =?utf-8?B?bGRvcHZkaU5DM093ZzcrVWlVWlAvWEkvMFIwUWVoV1F2SC9mRkN1emM3ZVFo?=
 =?utf-8?B?RWxCZ3hmYUlWMUZCMFV4ZlFXYWlQS0hhWkx1UlpIYkpaUEpJdlh4TVZPYlh6?=
 =?utf-8?B?MHkzZXpRc1FYbElEaWtSTXBKUUtUNzVhYWM1QlE5c24xdExndFlFS0ZBemRT?=
 =?utf-8?B?Yi9yakVHRXNmaTVGbFFXRHMwNGJWWjRjSEo4L1VCSVJ5aDBkS2pFdUNDN0lJ?=
 =?utf-8?B?KzRvd01xNWtKdFFOT3l6RkRGdm93Y2VPdjlNZkw1dDlhbEJhTG8vNlNCL3RW?=
 =?utf-8?B?aWZZeEJEN0M5YW1KWkhEelJ2bHhNUWwvajNGRTBWenY4UC9MdDZpeDVBUHln?=
 =?utf-8?B?UGZFeTRSSXRzU0t2OElxdGZUM05DN3R5YlA4a3p5SzJaL2pVTXlOVXZkRlpV?=
 =?utf-8?B?VWFxU1Q1Qm5mNEFHc3l1KzN6ZCszNlpPWlJxUFJHZE5ZRWwrZlpYaG1pZ3J1?=
 =?utf-8?B?VThjdzROWm5Ec1lVelFEZThUbEdnNE04WkVjQmZqZzJqaTZsNmRLcm9weGxo?=
 =?utf-8?B?ZjQvUkRLQVV3eEVhWnExWWtTem5iWGk2T0dIUERIZ3c4MnNwZGJzRGd6YkJT?=
 =?utf-8?B?cXMwMzNKNFd5QTlUcDZta1JBWjQrYlNzazJoeVlhTkNSSldSa291QWpVVnAy?=
 =?utf-8?B?cE9sRFloVlFFSnB0bEgwVXlqYjREaFd6cVoyZnhVOGExV2xCRlZ3eisxRDBx?=
 =?utf-8?B?b2NROGo3K3ZncWRjNWJsWUNpR2YrWWZMbktpeUx6aWtDNGZGTndJeG1ncjFZ?=
 =?utf-8?B?MXVGQUlhL213d1FEeXVQRGl0Uko2ZGRNbWFUMDJCbHNZSDQxR3ArV0FnK0Fu?=
 =?utf-8?B?TEF3Qyt1UU52bGJPZGpKa1lGNXUrMlRXQ1lsbS9HOU5iM1IzR0tycDViYVE3?=
 =?utf-8?B?NmlwSU1zNVZCdzdZWUFJYVJka2dlWE9ZZWN6bTIzaDkwakR4NjRRY1NGVFRP?=
 =?utf-8?B?TW5iOWF0ZXB4Z1FNTW5hcUNaV25PWE9uUm51UnRHS1VFaDFxUHZIYXZSNnFX?=
 =?utf-8?B?S0RFTERqanN0cUs4UVU5b2IrdThuZis4RVRXL2NjTzZjR1hSQVBtaUlEcUty?=
 =?utf-8?B?RjMvVFhHcUh0SHgrMWlpekQ5NWNyYnU2R0hnMmFqQ2VmUFpEdlBRSVowSUY5?=
 =?utf-8?B?aFpyOUFWRC9scHlNV1lQUGs5ZzdISVNkbHB5bTM2QVYxYnBEbWFoajZsMVJl?=
 =?utf-8?B?cjJzS2RtSFFGNVlUSU5ndkxHajZRZUg5OE53eVlxaytyTlA3ckNjdUl4bkNk?=
 =?utf-8?B?SkU0Z3NrWlR0SmVTNTBhWHI5bU5MY2pRSGExekNWRmJXODg4dmYrWStUK1pK?=
 =?utf-8?B?SlMwVjM1WGdyT2ZtV0tjZUJHQmZsb1NZdnd6NXFTbG9MNW9xUU1KbVFLbjl5?=
 =?utf-8?B?NWdYVllVQzFiQXh2c1lKOXBZVWxFR29TV0I0eGVMQkxoSnRZUnJJS25zdnFY?=
 =?utf-8?B?RWZBZ05rV01TTSt5VmV3dm9GYUxGZ3N5bDM4ODJocHdqcWNOTXNmK2hGRDhE?=
 =?utf-8?B?WkMzcXB3LzhVZWtRVmd5eUxlV3pyRnp1UzVHdFpHbE5TeWZLOGpjOWhJYnFM?=
 =?utf-8?B?WG5oT1I1L3BpRXZtWjAxNnRXaE9pQk1VSFRTVHBQb0VCbG9uKzROb29YV294?=
 =?utf-8?B?TzROWGlUQnpoS1Y1NjIyMVhYSGNtNE5tTXNBbXV6MlJzcXdWSVVtK0MvbURs?=
 =?utf-8?B?S3VCWml4Vis2bVY5Vm5HM25uS3B0ejRDQ00xc2pBUk54NUNkMnhYdmFRTVFV?=
 =?utf-8?B?aUsrRW1RRnVaR2xXQ1p3Tms0TG9hcjhHV2xtZ2EwKzZkTnJJR0FpYWRnY1o2?=
 =?utf-8?B?TzlsTlJLSVNBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWZWRTFVem1oL0kyQ3ZTYmI2L056VlkvVnIrZDJlbVdQWWxkVmNvb2VtV3Yy?=
 =?utf-8?B?VHZrWjFkTkVSTk9SV2oxRkJmeTFuNlFIbFhEK29wejFoMkVEM1p5M08zZGww?=
 =?utf-8?B?OEdHNzZqQWxMVkE4dGFtbnQ1Y3pMOVE3SUZJMUU0SUFCNkhZWXkvSmJhTDNY?=
 =?utf-8?B?VWwzWW5YNzVqSzFPdm1QaEh0b01QRmMweUk5dXRzLzZ6Z1QxcTJYUEpQdlBh?=
 =?utf-8?B?bk5UdWw4bVl0N0RhYlRWeVVOdUxERFpndTVZVmRkb3ZPckxGbEpxYUh5UDg5?=
 =?utf-8?B?My9ZUXVlN2ZjbnNJakJmTGxCK0x4STVaRXYrdG1CUHFTS3dNcWZDSmNTY1Rr?=
 =?utf-8?B?b1djYS9uNituM2MvdWIzVWpFdzVnZ3g4dDI5RWZPRm8xT2ptc1ZZZHYvYXRB?=
 =?utf-8?B?MExWL0pXM2V1YW42Nm93TENBc1c4dVJTc3F5NEcxVmROZWp0U1RFTlV6S09K?=
 =?utf-8?B?WWhEOUREZTdpWFRaelRMUC9sengwS2hGdElDQ1VNUjliWEtQVXdCUEdUVytT?=
 =?utf-8?B?NEVyK2thVEFhRzdsUXRKVGV1aEEvbFV0cW45M3ZzR1E3NFRuc2d4eFczWDdp?=
 =?utf-8?B?c1p2Z04xUmQvSHh1dEhnMUlVQWlJaUZNZmlFcmIvS0F4MXB3U253d2xsb0ZS?=
 =?utf-8?B?eUNNRVQySnduemVaa09wVE4rQ0NkTG1IQnVuSHNnYzRZODlKcGdlRUZCeEVH?=
 =?utf-8?B?aDRCUnM3KzdWNGZ5MC9WdDhQTWxMNTJNL2RDN3p0MExnbkZZbVRrcnJkVWNT?=
 =?utf-8?B?eWExY1YzZGphdnJIb1pwaWd3RFYwYXVMaUo4b0pTZ3g1ZnM2MzIrNVpaaEc1?=
 =?utf-8?B?MSs2d0szZDNnaCtoMHNrNHJpQ25GUVhGT1phYkwzQXlzcW56OC9WdUorS3Yv?=
 =?utf-8?B?VHRscFVMTG1XQllJc0RvRmp0N1pQYWhPVENCNXpBekdsVjNpZzRkeFNDcmZo?=
 =?utf-8?B?SHpGN2c3WDMwZ3B6YWVnM2hseS90c1Fac1ZiMENXTFptVkJlMEZrdlNkYmx4?=
 =?utf-8?B?WldOejRraXgvcTRjakRzZ2pUMzRPcmRZNVAvWVZEcExRY2xTUXZVZHQvL2to?=
 =?utf-8?B?T0dOMlUya1BPT2dqdFpYWC9aVGkxZXZHZXdaajJWRTRuemFuMUNmWks3OU9C?=
 =?utf-8?B?eU4wWUIrQXZFUHdMU2pEMU9MdGpIazZiM1gyZkQ5MjEvTXljUkhQTUlaVFV3?=
 =?utf-8?B?TUR0TFNad0dUbitiQ2ZzUEIvUU5hNlNnYjAyQ2NpTkxCeVgya3lkelkxajlK?=
 =?utf-8?B?a29lcGtRd0xHWXlqNW9ia05CK0l4bFNMekYxMjBNWUl2THRKUkNtVTVTcWFN?=
 =?utf-8?B?K2FrWlBBREw1NVZkRVdCRUljU1d4M1VYQ1lJakMzZE5kQnQ0QUoxOVJqclFs?=
 =?utf-8?B?K0Z1K2Q5eExxL0Y2L2dmMnF0VE5xOU5oQUFlaDVPUEtacjJJTTFwTVNmcmZo?=
 =?utf-8?B?TE53aGVobFRZWXRWaUduWm5ybGZXSTZJQjJmWDlwZjBuUzRpT3hIbFUwUWxM?=
 =?utf-8?B?WU42Tjdxd3dqS2l6dTExQXdwZFQ4VENLNENyazRCUVp4OS9STDEvbFdkMFJT?=
 =?utf-8?B?U25Rc3lRM3p6M2puUDliekJzclNJN05lZkhxN3NvNWNMcWlmR2pFTTdOQjJ3?=
 =?utf-8?B?aEc5TUVuUXZUNFdPUjlHcEF6TkhzYWVCb2ZsMTdtR0JDK3lzaG9oN3hQbFFF?=
 =?utf-8?B?NWhJZzlqcjFjQ0QzV3RWVE5WMFF0QXlGTWZhMDFuSFYvUzVITUJRZ2V1K1Rl?=
 =?utf-8?B?ZlVhL2hmNTRCR0FWemc2SkdCbEFRWFhacWdaUXc3a1FCQUVORTJyMytndlRI?=
 =?utf-8?B?R251V3hkWHV1Y1ErUGx0U0d2VUF2dDRuc0J4RHQvbFBOeCtHdElrQXVKMERv?=
 =?utf-8?B?bzE0STQwcXZFbFZJeTVDQjBkaGluVFZjU0pZdkRIR3dzK04yY1BHcHliYzYw?=
 =?utf-8?B?VzVQUjk0Q2pHcGdFbGE3T01JZDZTUGlKdGJ1Wnc2bWJoaGVTdFJxclhwVjBE?=
 =?utf-8?B?MUdNK201WDlHMHNTZ01FWTRkcjJDUEZDVzFNZHdzVlZRUVRDY2RnbURIME94?=
 =?utf-8?B?a055S1lqL2F0MllRVlRLdGxRM3BZMlNRNEEyNHpiRmpuVmI4bFBkZjZzenFL?=
 =?utf-8?B?c21SV0FObHFRbzJ1dTY1NWQvT1FsbVo4OWFUdERnZjJWeHZycjJtNlhZdUVp?=
 =?utf-8?B?N2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 565ca6e2-5ee1-4582-7ed9-08de27de3dd0
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 02:41:00.9595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F0DmYMhx+VTkco9n+vWJ5QXCXBfYdXEBkzfoPxdUute1APRRzFOrtF7Dm7uMLvFtgLa0KT8lYyDlKj9NVSN3gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB7157
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EAE20C0009
X-Stat-Signature: urknr5b7pn3x6dchbg5cqbmqb34qmzm4
X-Rspam-User: 
X-HE-Tag: 1763606486-97267
X-HE-Meta: U2FsdGVkX1+1S3/eitFupq2VEVXqvdC1zV076Mxr7i5v5848mt029E8mDleEYvKna33Rat59s+LNoBpHb9Vax+vqFu/13P4x1Z3EQQEkq1EZqwKrNA3LFnuP+veMRy/mr8a5k/8Pm5qLDvway5hZw0EL9essHe9PW0IHNyqbq/uKpm+HLSmdiBwUe29/ZhdbprAH8i1was/ccJW8SeNi76eDIZl/V10gB/rd9dpOiXCJ9X63AiJszifDth8YSbwSkFUToL9DqX591XwSr6sU3i/m0Njw7+UmTI8q+q9TAkAG+mvalla5SHOeMZ7B+RqA7mcwOP4URnL5wj22kUGippeQfCtWrAXtlOMfejlfrZNdH87qLzK8Nx1JMo9eh0GGWM2L/ZnIy06AENJbXpwzobMI5djr+RsAJn8IX5jmOXg+WoUV9Yg+go6zKvDrVNyHIlMIVb2pmqLS3CkCr6qT7b2ZP9JUoWcRwB2IrSZkKfokky6k0eknNWy1VyY27i2rz9tsTQ4auIDdsotdG8s+KDwDecQ3o2zY6mXfh5EBlDc/v6MFfiULsjrIn8L79CIm47NbV9hX02dAWFe8OXSGV1Tv7qf5nASzTQ7+zsIK78ViM+OedcQK9km5hu3rYNbawbbuS6/Z8X7ZHwKbMFC8YqWCAbEnl8rEkXeVwpmoX08O1rMcs8ybB+TvUL62kQEsfLHnI6D5bYeSRiLIH0JzU3LbzlBzljgeJzhXx6n5DSpzAxgmQHawxqhFpBLRlR5V/XYNzG5YgZmcLLoq9ATn7EWrTIz5zOMvZ2UHCZU8G7wprllUksIOgFcsrKJIhtD3xixLh+4wpHmtXr0PbiLyDIdgNCKK/6kYjWhO89C5x0goHLkXFuhgaTE1UcwudvgqdXwPUMtrmDQ2tWWhEG7mAI9IpO2DzB0INnnnBhs+xS26gWLDXTSZ5m1OACMQvaWC3ifzFPKRj02eLQMyIWi
 WwPL17S9
 CX8nD4WQxSHOWeocQC/F4ZWX6AL5JsFRwYD/FGDRGkMdp5DKJoJEnvJ/bMDT2IEWKg2vj77lUcFcMLK3686StPY+ENnFGySq6cCjg+Q+9W7imaBXueX8Yw0qZOdLV1HSI1OGUoNAawivJn3Lc5H4yOetEvljr2rzUIS86xy+HYoj1wXEbnVgTR1uaH13zllbM1Rnzrm2ubxAsTGs2EFlQFOLNfl5lbjJHe/I5EeGsc+T/Lzk3oRS3FJLmDpyKXMye9Sea9MjXEYgetI9WbNJdnxzsQDMNmnmtuTgiWj5Pay7PkUCDMyiF9BBKyAuH9GfDly7bButvVZBYmBWycx3/Dy7IEQY+DfDo+ncbTBauFLf4nsZXNa995SFDiAW6XAPOGKyNggmh/PErfklRYsl/1OQotyOqhHICngm+l4jHsasOpsUH6+3znXiEBrcQCNG9PXAcZ5lwPECvA2TWceoMZSktjhirQoMBWM7VA38zaY5LhR+KbFcXLZN8kQBL/fMhRNPofQZ3KqUfTBkoBWv/O1e1MlO3zwI7MBNRPEi7aw18+BFcvLxibt5ZK63HKce98YRBL1SkUjqLdkXIh0FOP/TBvBPq3x6W1TSnNvLk9gq8+hZuB7AolHVHj/J0YZNuMCqagPgh1i2KhZSjhu4jRO9DvvDaG0xkmds/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 10:52:43AM +1100, Balbir Singh wrote:
> On 11/12/25 10:43, Andrew Morton wrote:
> > On Thu, 9 Oct 2025 03:33:33 -0700 Matthew Brost <matthew.brost@intel.com> wrote:
> > 
> >>>>> This patch series introduces support for Transparent Huge Page
> >>>>> (THP) migration in zone device-private memory. The implementation enables
> >>>>> efficient migration of large folios between system memory and
> >>>>> device-private memory
> >>>>
> >>>> Lots of chatter for the v6 series, but none for v7.  I hope that's a
> >>>> good sign.
> >>>>
> >>>
> >>> I hope so too, I've tried to address the comments in v6.
> >>>
> >>
> >> Circling back to this series, we will itegrate and test this version.
> > 
> > How'd it go?
> > 

My apologies for the delay—I got distracted by other tasks in Xe (my
driver) and was out for a bit. Unfortunately, this series breaks
something in the existing core MM code for the Xe SVM implementation. I
have an extensive test case that hammers on SVM, which fully passes
prior to applying this series, but fails randomly with the series
applied (to drm-tip-rc6) due to the below kernel lockup.

I've tried to trace where the migration PTE gets installed but not
removed or isolate a test case which causes this failure but no luck so
far. I'll keep digging as I have time.

Beyond that, if I enable Xe SVM + THP, it seems to mostly work (though
the same issue as above eventually occurs), but I do need two additional
core MM patches—one is new code required for Xe, and the other could be
considered a bug fix. Those patches can included when Xe merges SVM THP
support but we need at least not break Xe SVM before this series merges.

Stack trace:

INFO: task kworker/u65:2:1642 blocked for more than 30
seconds.
[  212.624286]       Tainted: G S      W           6.18.0-rc6-xe+ #1719
[  212.630561] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  212.638285] task:kworker/u65:2   state:D stack:0     pid:1642
tgid:1642  ppid:2      task_flags:0x4208060 flags:0x00080000
[  212.638288] Workqueue: xe_page_fault_work_queue
xe_pagefault_queue_work [xe]
[  212.638323] Call Trace:
[  212.638324]  <TASK>
[  212.638325]  __schedule+0x4b0/0x990
[  212.638330]  schedule+0x22/0xd0
[  212.638331]  io_schedule+0x41/0x60
[  212.638333]  migration_entry_wait_on_locked+0x1d8/0x2d0
[  212.638336]  ? __pfx_wake_page_function+0x10/0x10
[  212.638339]  migration_entry_wait+0xd2/0xe0
[  212.638341]  hmm_vma_walk_pmd+0x7c9/0x8d0
[  212.638343]  walk_pgd_range+0x51d/0xa40
[  212.638345]  __walk_page_range+0x75/0x1e0
[  212.638347]  walk_page_range_mm+0x138/0x1f0
[  212.638349]  hmm_range_fault+0x59/0xa0
[  212.638351]  drm_gpusvm_get_pages+0x194/0x7b0 [drm_gpusvm_helper]
[  212.638354]  drm_gpusvm_range_get_pages+0x2d/0x40 [drm_gpusvm_helper]
[  212.638355]  __xe_svm_handle_pagefault+0x259/0x900 [xe]
[  212.638375]  ? update_load_avg+0x7f/0x6c0
[  212.638377]  ? update_curr+0x13d/0x170
[  212.638379]  xe_svm_handle_pagefault+0x37/0x90 [xe]
[  212.638396]  xe_pagefault_queue_work+0x2da/0x3c0 [xe]
[  212.638420]  process_one_work+0x16e/0x2e0
[  212.638422]  worker_thread+0x284/0x410
[  212.638423]  ? __pfx_worker_thread+0x10/0x10
[  212.638425]  kthread+0xec/0x210
[  212.638427]  ? __pfx_kthread+0x10/0x10
[  212.638428]  ? __pfx_kthread+0x10/0x10
[  212.638430]  ret_from_fork+0xbd/0x100
[  212.638433]  ? __pfx_kthread+0x10/0x10
[  212.638434]  ret_from_fork_asm+0x1a/0x30
[  212.638436]  </TASK>

Matt 

> > Balbir, what's the status here?  It's been a month and this series
> > still has a "needs a new version" feeling to it.  If so, very soon
> > please.
> > 
> 
> I don't think this needs a new revision, I've been testing frequently
> at my end to see if I can catch any regressions. I have a patch update for
> mm-migrate_device-add-thp-splitting-during-migration.patch, it can be applied
> on top or I can send a new version of the patch. I was waiting
> on any feedback before I sent the patch out, but I'll do it now.
> 
> > TODOs which I have noted are
> > 
> > https://lkml.kernel.org/r/aOePfeoDuRW+prFq@lstrano-desk.jf.intel.com
> 
> This was a clarification on the HMM patch mentioned in the changelog
> 
> > https://lkml.kernel.org/r/CABzRoyZZ8QLF5PSeDCVxgcnQmF9kFQ3RZdNq0Deik3o9OrK+BQ@mail.gmail.com
> 
> That's a minor comment on not using a temporary declaration, I don't think we need it, let me know if you feel strongly
> 
> > https://lkml.kernel.org/r/D2A4B724-E5EF-46D3-9D3F-EBAD9B22371E@nvidia.com
> 
> I have a patch for this, which I posted, I can do an update and resend it if required (the one mentioned above)
> 
> > https://lkml.kernel.org/r/62073ca1-5bb6-49e8-b8d4-447c5e0e582e@
> > 
> 
> I can't seem to open this
> 
> > plus a general re-read of the
> > mm-migrate_device-add-thp-splitting-during-migration.patch review
> > discussion.
> > 
> That's the patch I have
> 
> Thanks for following up
> Balbir

