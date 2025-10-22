Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 720EDCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 15:01:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FC0D8E0013; Wed, 22 Oct 2025 11:01:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D3228E0010; Wed, 22 Oct 2025 11:01:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89AAB8E0013; Wed, 22 Oct 2025 11:01:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 797D78E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:01:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 27D411A0899
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:01:50 +0000 (UTC)
X-FDA: 84026064780.14.B61A29D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf06.hostedemail.com (Postfix) with ESMTP id DF67D18000C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:01:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=E+YpB+wa;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf06.hostedemail.com: domain of ira.weiny@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=ira.weiny@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761145306; a=rsa-sha256;
	cv=fail;
	b=5gmTgA4gCGrUguAIcD4bNTyRE9eIU/+EirMPWuF0Ylr8EXxMH+hI32tX0wg2MjfpUyoB+U
	fdwY3XUaZcUR7mmQwYndYy11m6WNuDgrm5MgRdq5QMxdjUhQ3BLSbsyGBtbDM2wr6P7h1w
	yzxqlZZtXqzlWMI7OsHW5OMzYiRFeOQ=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=E+YpB+wa;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf06.hostedemail.com: domain of ira.weiny@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=ira.weiny@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761145306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYEqg2Wv5EZ9JNUp7vig0HhYdBOuCJKK4Gho9ptdyXU=;
	b=e6hVHTPDkc6UDIVaY0ElUWQlRvPz1bId2bUyuqWzGJe8XPPtwIgjsyCwjtF+HV0HmIqLI7
	qiDCrQDXElBseJR2FxG1Dn069kBTAv31wdwJLz93Pt7gOWlcqNK23zxJmCFmV5560JVbJj
	RIYGKWV9+m+R9Zm7yR1z9LkRMucNQBs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761145306; x=1792681306;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=jF00L81K1SJ+FYz6CRePmWFEfnGgtNIDdHe83iUpoXI=;
  b=E+YpB+wa5s+Bj+qaUj4Zge2lxSX8F7ex1OcIX8XQ8NdbAIGeBbFhwpgK
   +POAvgyHc/iolKzaYxbkwRN7UXspFtemsYiYIPZ7KrhFXVf/TDGRLUGyV
   Th5huy1XMA+mRpyzZTq8N/wlue1aAgiuKRwo9axYxxOmazdLHE7n+cMQR
   Rxo2eoND2V/qBaxL85tnyW7qMm4KATqhNtoQCd5oANrs9pWgcx59kvYCg
   TZn6a3I3kVFDrNX+2hdzmCtcIXJpSIjKIul+SLuIeYyWKj3M46JquNYPP
   DSrbCEEHA+AY0D4LmmaHgBZenbuOnpLTducxJRNIK6cAXv86eOwZvc3q3
   A==;
X-CSE-ConnectionGUID: +JFuv/IKRr2MhfPOr6XV3A==
X-CSE-MsgGUID: iU3uJEhCRo6nFKqiulS0fw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="85919950"
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="85919950"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 08:01:44 -0700
X-CSE-ConnectionGUID: JF+coCS1QqiXw/5ZEqpNRw==
X-CSE-MsgGUID: sb5GJbxYRCamye1fHopXDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="184377482"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 08:01:41 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 08:01:41 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 22 Oct 2025 08:01:41 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.37)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 22 Oct 2025 08:01:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cxaldX7uJpoaGqC5urtF8eaJ9oaywEPzAWwnDbkLx203ndY/Mq86XjgOwkIoeLRtvA8iQGte3b+m6E80jPxyyIMsn7flzKy2ydOkWppYcFXjUqolTHd7sB3tJ5oLOU31Gq9gkuWZZWRNKF1lBGBOo/AiPQeku6bQjntb+EmSnUWOhJCeE1M3UvHCxZLka1y16ifKu/tkMrA6bTqp/eBwasknxQ05AOE2kP/LKNFD8C5bSBynVB8iPxrCOZ3nP3+A8Y/inlXg8UR1thu3Eh33ucOM640VriF2jQLv4B4FCAzSir5ZCfNkMXBRO0NeGP4c62+G+brxFBeXoRkb8Y72jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MYEqg2Wv5EZ9JNUp7vig0HhYdBOuCJKK4Gho9ptdyXU=;
 b=dFLIo9gNXY24PNQ+c6fJJM4kLVruTs1TkhO1nDEkZO44NRYpVe6y94BP9xzw8I6yxsfq5edL8aKMaIldfu676Ij+JWPQC9uB5h6duV7jPsl2R140FhyKAbU8EU5IJdyrgZ1r4r1exv314DDW/w49Ku02mahysqJgMWBc1JKAE0+ADQzVU3EC5N7y0pN14D4WgatmFHJI/nDWI7Sv/asx0YJKLzeRX2xCa8uaEnAFXP6DjF++OgKkckFSsGq1z9PNJzri5/rD05tGW6/jAt+zMzKixc45mPBlkDt/GQ5kF9sEEE1ZSt6pnQuqRZ2uhCSTfoVufGfZi4yQ3iQm+QawrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by SJ2PR11MB7647.namprd11.prod.outlook.com
 (2603:10b6:a03:4c3::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 15:01:36 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c%8]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 15:01:36 +0000
Date: Wed, 22 Oct 2025 10:03:48 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Shuai Xue <xueshuai@linux.alibaba.com>, "Luck, Tony"
	<tony.luck@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"ankita@nvidia.com" <ankita@nvidia.com>, "aniketa@nvidia.com"
	<aniketa@nvidia.com>, "Sethi, Vikram" <vsethi@nvidia.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "mochs@nvidia.com" <mochs@nvidia.com>,
	"skolothumtho@nvidia.com" <skolothumtho@nvidia.com>, "linmiaohe@huawei.com"
	<linmiaohe@huawei.com>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com"
	<david@redhat.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "bp@alien8.de" <bp@alien8.de>,
	"rafael@kernel.org" <rafael@kernel.org>, "guohanjun@huawei.com"
	<guohanjun@huawei.com>, "mchehab@kernel.org" <mchehab@kernel.org>,
	"lenb@kernel.org" <lenb@kernel.org>, "Tian, Kevin" <kevin.tian@intel.com>,
	"alex@shazbot.org" <alex@shazbot.org>
CC: "cjia@nvidia.com" <cjia@nvidia.com>, "kwankhede@nvidia.com"
	<kwankhede@nvidia.com>, "targupta@nvidia.com" <targupta@nvidia.com>,
	"zhiw@nvidia.com" <zhiw@nvidia.com>, "dnigam@nvidia.com" <dnigam@nvidia.com>,
	"kjaju@nvidia.com" <kjaju@nvidia.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"Smita.KoralahalliChannabasappa@amd.com"
	<Smita.KoralahalliChannabasappa@amd.com>, "u.kleine-koenig@baylibre.com"
	<u.kleine-koenig@baylibre.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] mm: Change ghes code to allow poison of
 non-struct pfn
Message-ID: <68f8f254b53dc_17217e10069@iweiny-mobl.notmuch>
References: <20251021102327.199099-1-ankita@nvidia.com>
 <20251021102327.199099-3-ankita@nvidia.com>
 <68f7bf2d6d591_1668f310061@iweiny-mobl.notmuch>
 <SJ1PR11MB6083BF0885BC19E715C1A96EFCF2A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <81b1f1c6-4308-41bb-9f65-f158d30f27bd@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81b1f1c6-4308-41bb-9f65-f158d30f27bd@linux.alibaba.com>
X-ClientProxiedBy: SJ0PR03CA0380.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::25) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|SJ2PR11MB7647:EE_
X-MS-Office365-Filtering-Correlation-Id: acb54449-f3d1-4206-0266-08de117be549
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U0JZakhlVVA0SXFvUTc2aFp3MXJXV1ErVC9QNjdTc2Zwd2RBSVJoQ0FLMFVy?=
 =?utf-8?B?NmpSaVZBZjlqUXBMdWI2TktlS2VXaktmT2J4dW1UME5DVC8vR1RFaHRIK2pS?=
 =?utf-8?B?VVAwUVo3Qnd1cVk5a0lxNVdHSWczN0Rhb0s4eHprWm9CVi9HRVgxK0V1OUxD?=
 =?utf-8?B?TDdYTVU1UUQyZ3ozeVZjUzlJWjZxZXdlMWR3OThBd0YzQlRySm1GQ05RT1JP?=
 =?utf-8?B?akVXV2J5aVJlZHVFMUZjSE9rclMxaU9wM3B0cHRQbkNJNWdVZWRyM3J1Mm5x?=
 =?utf-8?B?YXZnVWRSRjdJYktONmJUZG9mcC9uZzBvUVk2WWwrRGNLWmxzUVhQU3R6WndU?=
 =?utf-8?B?ZkJKblhWK0R1N3FOQlBQOHJBWDdFbUVZVERrcS9FeTBPQ2loYjNnMEd1VWJm?=
 =?utf-8?B?VVBlUXVUdnBubGFDcUNCY3NoN3dWT1FxeGVoTlFrN01EdVpQOVJHOUFxOXli?=
 =?utf-8?B?R3hYNE1nVmlpdkN5dGkzYy84NWU4dTdlOU9WOExxTmkrRTdHMHRUQzM4OE91?=
 =?utf-8?B?bmhvYVRLQ3l1UVN5VDREM0tsZXNKZ3hmaXhvUTRuQUVxVitDZXpWcjFHT3NE?=
 =?utf-8?B?MU9vWExWbkdzWmNpRFZ0YTQ1anFxZGF5TWVURG1yRXFGU015Nm5qNXVwNVVL?=
 =?utf-8?B?Q0FrNGgwYnRyUkJhemJYaUgxMFJncWJkUlcvc0lOQXhYVkUyTFFxOEZzUElt?=
 =?utf-8?B?emZVWEtKd0hKL0ptKzhPU2RQZHRZWjIzY2JjeGxQODllRUtlOG9BdEdpM2lL?=
 =?utf-8?B?Y2VLZkppeU9YVUZkbWp0b0xWbm5rWTlKOTJVcHhualc3RWJHL3NibVRjb2c2?=
 =?utf-8?B?cTZlY1d6YzRGN2d6dDREVTJqajZFNzQ5L3ZmMnhjSGRYVnB2SHlub1pKc25F?=
 =?utf-8?B?V25rUS9PSE50cHJ5VFIyejZrdHhIeWJNcjRmVFlYRk1SN3grWE4xVXNKUHBo?=
 =?utf-8?B?QkN6U2FmZTEzdVFrT3g4TDd5YlNJME4wNGUydU1DcldsdHNZYTBja25RWU9R?=
 =?utf-8?B?K1k4K1pnZkZ1bHo5LzRJQ0pWOGk4SVQya0ZPZ2dNbHZTRkdScXNyNjBaY0hq?=
 =?utf-8?B?cGdSY2swSy9rek5WTHArQ0JCT2NFWk5ycmlkSjQzQ21kYS9iTDFsd3dPNXhU?=
 =?utf-8?B?NG52bzFlTmVjVGhMWldxcjJRY1VqazBkVlNKVkdlMzc0TWVDajQ4ZGkzZ1Bt?=
 =?utf-8?B?RThvUHY0eFlLUjQxQWF0K3p2QlJvRnh0SVMxdERPMm1YdVVEL1NKZmM2aUxu?=
 =?utf-8?B?d2JndllkRFJUQTBkdGZBNG1ZYzAxMFBKRHNseXRRVjBNZWM5cW15S1FJSWJl?=
 =?utf-8?B?SUhSU2RPZzFOL2xvQkFSRFpNVGJBRlJKUG96d1VPSk5vb1p2VGpXaEVpeTI5?=
 =?utf-8?B?L2FoVkYvUVF4aVNKUzNQWWVLRmV4Snc0ZXZCWFlFZE1OOGhzR3hQWlNtbUJQ?=
 =?utf-8?B?RUY5UnZBZ0xQVkVLQzNpTEtoc2hHOWtidlF5WkY2U0FIeXErZ0RWdi9LUVhM?=
 =?utf-8?B?d3BUTU52M0RBaHRCZktzd2RTSklYbEJiM0VTSUpDSGZSMHVaUnBtTHZOY05t?=
 =?utf-8?B?cEZMUGVHTmluQjdzSmNXYytlcHRLOXlmeElFSVM4VXlWelR6cjUvbCtqVS96?=
 =?utf-8?B?U1lTMHl4R1F3WVBNTE5jV0NXeWVKakdVTnpyV0hBR3hCUXJvL2NRZk50dHds?=
 =?utf-8?B?aVIxZlgrclBGUnZEcG1KZllPd3dXazEzNTZkbjNOM3VjREo3cVA0ejhqVWN2?=
 =?utf-8?B?MXViS0pEMDNhbExmQU1ab1lVNHF5M2FicUlPNTU3RUpkU0lnUDJCRVYwbFBK?=
 =?utf-8?B?UTRxT1o0aGt0RzUwNkljWHV0cXBxUURWVXdnZ2VwODZXYW9WMXZnUWpaZUNL?=
 =?utf-8?B?aEFLMCtOSU1CVnUyQmlQYzZIUmZzR0Q2NHV1clovWXgrdmg3YUUyd0srOS9M?=
 =?utf-8?B?VDZCMzZLZy9JcmZNOHdKM0Z6OTNzaTJKR3h0VitWZzlWMm9oVlFJYkJLRzk1?=
 =?utf-8?Q?QfKpbAPfHkqAl4WdC45BcVlfCPsS8I=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2pYWXE1c3RLZEdnTWdrSzJ3Y3A3bnZpZ24weXR4YTVkSUFZNG5JZVNxZ0w4?=
 =?utf-8?B?eHdCODdYejRmT09DNnVObDdIM05yYjk4TnlFR3RPVTVSY2V0T1ZZZWlnVzVa?=
 =?utf-8?B?V1R6d1l3YytnZ2RqV01abWNoZlNYanZNK3ZKRXV3T1VRZHBoTWw3cGlIdXpE?=
 =?utf-8?B?WE54a3Yrb0E4eVVhQTNPSDRUK0U2YlVGSlU2ZWd6dEs0OWVsU0ZwZzBKYVBj?=
 =?utf-8?B?Qjc0U01jK2E2VnNyN2ZONHdTOG5IOUlmZHJhU1BscitvRHN5RFdQT0JMaUFx?=
 =?utf-8?B?bks1YTNuL3Ftb3BTTENaemZGcmRIMUpJL25yaHlqeThuL20zcjlheHl4WkJY?=
 =?utf-8?B?UFdnelppbHJsNnk4WngzQUcwM3k4elhMTThraFVFMjB5UjM2Q1lrN1BqVENm?=
 =?utf-8?B?eGw4cUIzbFRTTDVlZW1TbHd1dXhJeDl4NnkxWkx1elFRaXNyTXJDRG1qWk1N?=
 =?utf-8?B?MndqOEk0RlRrTmo0UjVKaVNFT3pvQnVwMGNab090UG1Fb0tPeTRrRlV3RDRh?=
 =?utf-8?B?TWF0cmU4dHVkODRzS0JCM05iVGdUNXpvM3dXM1VabitkN2s2VjNrTjlpanM0?=
 =?utf-8?B?YzhyN0doRFczV2xDWlAxMmdZazN4RlNHbGhDeFdsemFWcEcxTUhHL0xQUStu?=
 =?utf-8?B?RUN6MUdmM2JqdWp2WjFJTEJRUDVkMU9xZjB4eE01SU5jV2NWV0RHVnYzY1Ax?=
 =?utf-8?B?ZzZsSXIvQW5rUU50QnVkQmswUTNDUUJET3plQ3dOckNHa1VGZnhNVEIwOFIz?=
 =?utf-8?B?TDJhMHgreXhGNHl4cStpaGk0T2JMUlRGNSs0a1VUNFg4by96WnQxT3F6UHRE?=
 =?utf-8?B?SmVING94WExZTXVocmt6cEVGUjQyV0JXL28xMHBWdGVUeEpiMlM0QWdCRkFO?=
 =?utf-8?B?eE4wbFpWbHovQ0RicjdpMUVYajZOZ08xNTVUMmFidlcvQ2FiZWNxMDI0eFB5?=
 =?utf-8?B?WXIvWkRYTWtmZEI5bHA5dFg2T0tmaURHOTFkdTk1RlRoOGxYRkhYMDFNcEx3?=
 =?utf-8?B?YkpIRFBla0lWQW1IRU9IU1QydU5WM0RDZkYrdzl6TEdoMDZwOFV5N0phVlAy?=
 =?utf-8?B?WUl6MXZZMnlkZGQ0eWdBMjArM3kxT2doWHE3d21FYWJyOFR4QmVSeVgzbmcy?=
 =?utf-8?B?MEE1eWFRNm1mV1cyeTEyTjBDQjk0YWZWcFh0eDBpNzkrRFByQ1N5eVc3YjdM?=
 =?utf-8?B?Z3lmY2pJdGEzQUdHRzV0cEZvRzFSdFZMRHZXQU9wVGE5NW9kWTdFMk4rTU9C?=
 =?utf-8?B?dC85dzQ5dHQvZEVLdUo2Nk9IUTdvQXc3UG5ZR3IrZm1jTERaTVFVODBYK1Rv?=
 =?utf-8?B?dytqNlNRZVBCcjI2U3pKcTNyUVYwSER6SndKc1M2eG54V0tXZEhlVS9LbWIv?=
 =?utf-8?B?ZUY2S1dmaithdDY4SFBLM3lkNWdDTGY2dm16ZHNLcTNuRExKcHNTS3NiWUJm?=
 =?utf-8?B?Q2locXptTHcvZG44dXVORFVZMnROeXFDVlZtV3dEL3RScXBwdkRtR1FKREor?=
 =?utf-8?B?MmpDdUxScjlhZ01laGNuVGZIWVZPTXByby95Qlh0MDdya05WdnViVk9PTDV2?=
 =?utf-8?B?c0ZsZTd4TTJWclpSWXVUSkhyMVhNNDc3aWI3NFRhRXM5clFGVUI5Z01LaDdH?=
 =?utf-8?B?aFdiRUJxd3k4ZHNFeGtqZHVEQUVtNHprYmFqbzZ6T2JVTk1ZVFJKMXZrcHZh?=
 =?utf-8?B?WTExb1hlaVFBVzBqNzVTZFMrdG5JeDlrd05QN0lPUXlIWWI1WTlGVkp4WnZ5?=
 =?utf-8?B?V1JscDM5UG83TmNhcFZrSnZYQjRHUzNGQy9mNmFEcUlFeTVBUC9SVm5lV2du?=
 =?utf-8?B?dlhEQkpMTUpIUTBnSlhaSmpFUGY5anMwUitvOEtTSW5kbzkzTjIzY05qaDV6?=
 =?utf-8?B?NG5TS3hWSDhIT3B0ZjFZaGRXR01DTzdJaEhFaWJGanBveVF0ZU5oNmx6bWpk?=
 =?utf-8?B?V3owZldWZ1paWmwyV2piK0RSUHlISUwvY1VldWhPZktPWWEzeTFVWFlIZlV4?=
 =?utf-8?B?WVlKYjJmamxZeWZURkk4UHpLci9Ma3RrYXlmNVhBR1EzNTdscjdOa3o0dTZq?=
 =?utf-8?B?dXZSeWg4VlhuQ2VqaDZ6T0xuTWd3eDRpWjRiTkF0OHhvVjFyU3BnYkQwYWJs?=
 =?utf-8?Q?boka/+XchOhQm83uu9B0IhWvr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: acb54449-f3d1-4206-0266-08de117be549
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 15:01:36.2457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IjesaeycTuNySXMtiomSCXnaO1J7LHDm3MtcjSnBIiFaVxByUm/8OepeOtqP0pEvHMP087AX0hkQBqQ95fO0bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7647
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Stat-Signature: 8upz95rumxgr348wiot3jsye5rpkaf99
X-Rspamd-Queue-Id: DF67D18000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1761145305-833369
X-HE-Meta: U2FsdGVkX1/p7uhVA1XKtpY8ioNZbKch6QkNxvq5NXY8zmV721IwGgXYYZ9P4UIttKu8m4KUHM2efDTKHzY50r8/IeaOmuV1Ur8avAt8Ld8ggn/oCe5Z+ihAsKfs2NOD4t5xvsrf+GgkbYAKSU8vM9Kk61WoeGclghgClIjSbRk/8wLVDap4OOogWUN4hPr6wFzfWJ2BLIFRrEezuq3DvBB/Yp4qzbxFsgH+RHAzcGNoo2HLGb4CWxG9kelDwqA3o+AWkdnywjruu9+G8x5nupoSNIIeSz1fEEVvVKWWF+TMYj+bHdlaQq7lBz9F550lMRtSoaNOFERT2nKptkjstQxAYDw3WUBdV4RkweVgRQYb0D7EK8uaByNKveh2MN0PCtUxWkmSFUVES/U80v72waa2a5WiILszT82ES+wm4vdn22/weIxR/tqof/8H+VGjeXH8gSL3o5Brn05dQqtOvSHSxQQEmueqUuUdLx9SoyuJF9L3lHOCUu3YwFLcr/kwO3NIU8rfK+ryNwjySDlUJi7V8nczZUvioJKk0OdGl49cr4dkMDD8hG1l7id3bF7BNjgpDsbXl6/6H4HjD3AAPhXslz4kmv3+OA52c2/F8raWy3r89EurYHkLIVIk1cyUkCQLACDzq0UNrj1XUVy420A2s4YpZsVd/T8XtWvnO7vJw01heiwQudLpYlWt4XT2wGbTcjT5fwJAoreF3bXQE33zHCEdYMdGk12krOl7HmqABsfHNAitzcWWHo1QW1aRKzh6VSpe2aVE3B28nGMQCfXsFwnqzvCg1MJHuFBKDgnd85JyUu0IwWcxprMNJHASEUBztiUdzZN9NT6Je1H56vA4wtlNE0YHTKv0GDTcBHmZgnL5Ab7Kdenti9g5pB4bD4zJlFf/lKtO94k9csMt70/Z2vHLO4hFi4ryJ7f8EnUC0AKb7kmWQ4SHu/PMkhVqMcEfFszZuTVQB7OK4aJ
 ZFaoyvnK
 hA6FKgWgROPuMHnr8y9Pa3q/d36AIAFmFbzbGEI813IeaEW2cmWmQ0GNOKUdCE/y0s92vbajX1bRyQMxagMp2ATaL2FDQmVksWSpB7PLcjXTfPgztf6fdUl3effOWB9FyFXjPyQNAjyEebBlj4O1d6bEpXlSOIs9KYLd0/CWN23mrjYHzMbhux7mdtiEFRDKDiBSeoFdMI8MSRJMYEpw4xV6GIs5wdhj83T8vkxKURwpMlYq/iSil6SZmKosFwjSHe56oq7A6elm14hLv4RBPvzXu938xW/VPGOqhRF6B0QtY2Rh/xbqIy0bHHi7E4ojpTY1wGP5pok2YPMshSXKhPg+uUQjN0wLTOubDViNGIFFIDouY2tYdOfi6dc0J96nu4WjgUe5WVpr4DWqcDpTT1s69BbxIoYdwCKh7rlJnRh6J9+p1xC4YFr8sd9b8QpFnP6XVdgncC3tqwkgYuEIx5F75IgRNvWa9d25QMNnqKHvw00JxaR7BBO822Vi6wuirpwjvtR99UPIV4akXKjXrPgaoca1ovHZ4Cfv1OY20zVa2TK3f1jag+M8SLw1olD5TECKYa+24qGdqjf0vvWVPgq6RzT8CxIwJez3XfTYCn6VoZRjTU7TMjfS5lQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shuai Xue wrote:
> 
> 
> 在 2025/10/22 01:19, Luck, Tony 写道:
> >>>      pfn = PHYS_PFN(physical_addr);
> >>> -   if (!pfn_valid(pfn) && !arch_is_platform_page(physical_addr)) {
> >>
> >> Tony,
> >>
> >> I'm not an SGX expert but does this break SGX by removing
> >> arch_is_platform_page()?
> >>
> >> See:
> >>
> >> 40e0e7843e23 ("x86/sgx: Add infrastructure to identify SGX EPC pages")
> >> Cc: Tony Luck <tony.luck@intel.com>
> >>
> > Ira,
> > 
> > I think this deletion makes the GHES code always call memory_failure()
> > instead of bailing out here on "bad" page frame numbers.
> > 
> > That centralizes the checks for different types of memory into
> > memory_failure().
> > 
> > -Tony
> 
> Hi, Tony, Ankit and Ira,
> 
> Finally, we're seeing other use cases that need to handle errors for
> non-struct page PFNs :)
> 
> IMHO, non-struct page PFNs are common in production environments.
> Besides NVIDIA Grace GPU device memory, we also use reserved DRAM memory
> managed by a separate VMEM allocator.

Can you elaborate on this more?

Ira

>
> This VMEM allocator is designed
> for virtual machine memory allocation, significantly reducing kernel
> memory management overhead by minimizing page table maintenance.
> 
> To enable hardware error isolation for these memory pages, we've already
> removed this sanity check internally. This change makes memory_failure()
> the central point for handling all memory types, which is a much cleaner
> architecture.
> 
> Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
> 
> Thanks.
> Shuai



