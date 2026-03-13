Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C771A107BCEA
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 22:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75D746B0088; Fri, 13 Mar 2026 18:31:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7354C6B0089; Fri, 13 Mar 2026 18:31:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF216B008A; Fri, 13 Mar 2026 18:31:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 432ED6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 18:31:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD9511C385
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 22:31:38 +0000 (UTC)
X-FDA: 84542487876.02.B155F65
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3EFF820006
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 22:31:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=b2QKxpJj;
	spf=pass (imf03.hostedemail.com: domain of sohil.mehta@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=sohil.mehta@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773441095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nFrZC3OLzpGBPIi5FQ6C+hpfwws7bZ0ZBKtg3lQ5G+M=;
	b=GwvjLdkyUNEDCMN2HqPUzj7rum8u9QMRz4wgP2rSLMFzhk3iX20AOZLYufRCsgZ7wZNBfM
	+YF3O11bzVf8hjveYoj8GeCkH0Oik8x2/cE6tUkktxTOnHCZtkezC3cTJnVKNRS34cjZkC
	ADE6OZNBWuNCxIoRQ0+6s2j/vhS4dQo=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=b2QKxpJj;
	spf=pass (imf03.hostedemail.com: domain of sohil.mehta@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=sohil.mehta@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773441095; a=rsa-sha256;
	cv=fail;
	b=rpQUu3+oztD7FUF1ndH67SZWKrAlleo75wqvqY/2m3XQ6h1hYHMCto1JmhkpQ/xQfhfBbR
	sr8TdNIJrJkwWx1/BDJv5shhfYS9RYygCTioUVdWvLxLBavci2y9DldQouyTC4+5F5f0UI
	D1Ioto7vIDgiIOA3fRPeGI8Tn1Vu67o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773441093; x=1804977093;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QNMkGneWKuw+Yl5rurHQkqDb8degErdG1Zz7ls6Ok3A=;
  b=b2QKxpJjf8W3iDQDC/2Ls3iXz5FB0+MquTgZHnPHRUzYK48GMzgdjvAN
   Td1UbmM3dM0ETbCsOW0toWZbuW2HsN+Cf4XGDYuI/HN8Vn40FpqUv3V0x
   RDZ2jgomBIDrUzhda2xgdVitoei9AzbkCXQFm5H/+XIo5qEoBkyvUoSgX
   mLOPBUoKeM98r7BlNP5niFjjWIfhVKAGHjkVXEmkqW8SYavKV+KnfmMDN
   PA7QNHkp4knekHfw2sFTotXurM0Rj2Wai0ydj11D/p0jXKo6bPtknfugt
   +tZzNXoJVoRwfE5jPezNaUK6LcwBHdmEmM4+kv76EeR33RDQ0Iz7OtJRO
   g==;
X-CSE-ConnectionGUID: 66rKxweWT3qg2nwkw3nxMQ==
X-CSE-MsgGUID: IVAte6/4RymNjvK3c10BbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11728"; a="74447269"
X-IronPort-AV: E=Sophos;i="6.23,118,1770624000"; 
   d="scan'208";a="74447269"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 15:31:31 -0700
X-CSE-ConnectionGUID: U/Vpve/4Sa6NxBN8RCA+jQ==
X-CSE-MsgGUID: WrwF0WM5QEe8bnEWHc1R9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,118,1770624000"; 
   d="scan'208";a="246420588"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 15:31:31 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 13 Mar 2026 15:31:30 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 13 Mar 2026 15:31:30 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.6) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 13 Mar 2026 15:31:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=quSpz4P3HYaCeqWJIcmnSmdDd9GXEuMRgOiOha1tu2+dNsD5A9bAKHpEpLUzjocBKleLc5nIC9NsZVomDyVpIj4QklaMRTOFKL0leJEOmdqwNyIR825mrYETDeNvxzWS6nV/kHfhWedHV17z++gcUTmESpK8Q5256qn0qniYYG5AdJ6lgrBICMhffUTULUxh3+phMV7/nxohlOhmHx4Tl6NCJVSll5q/Ii9jXpsOlUGBFuWe4LA0z9Nh8SDeZCldbbAlqNsfrvXdyvAVPwvTmDT2R0LK7nBaX3AVELxryI8hAXksnW8UYzYmoVfh8EJYfNL+t3Ii9QucThdtSU4XGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nFrZC3OLzpGBPIi5FQ6C+hpfwws7bZ0ZBKtg3lQ5G+M=;
 b=ZSfbls443nWdZx3iPELeBzck8L0Ap9QU4HQ0p/HD2KH4//6DENsZooofFR2OokUJJvpoLd8ZgQ6AP8X+Dk0XZ1XG6Fg7i6JJg7OAzLjGYKIXuiV6utZmuY+44F9ZTQUHL7POiteBBVtCxVlfpuZKqjEJVzoJolT1JBZ4Dzg3v+99K+XWikB5cM63DB0BBgd0iQ0UfrlqiDRpYfduiXA54F/nZyM83o1LxYzrDo+M54AeqR25csmvPg6C8GzMvja5akk4qoSD/CUMnXie1FpmEDn5WrTNxGReQdiBLAFLoSNK53tba+EW6AbZupy8coGTlJTED0dsYNfVk4/q7wsZYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH8PR11MB7989.namprd11.prod.outlook.com (2603:10b6:510:258::13)
 by PH0PR11MB7521.namprd11.prod.outlook.com (2603:10b6:510:283::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.10; Fri, 13 Mar
 2026 22:31:27 +0000
Received: from PH8PR11MB7989.namprd11.prod.outlook.com
 ([fe80::dc36:253a:2554:e475]) by PH8PR11MB7989.namprd11.prod.outlook.com
 ([fe80::dc36:253a:2554:e475%3]) with mapi id 15.20.9723.004; Fri, 13 Mar 2026
 22:31:27 +0000
Message-ID: <322f6f2f-840e-462f-96b0-b603b9c88582@intel.com>
Date: Fri, 13 Mar 2026 15:31:25 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/4] mm: huge_memory: refactor enabled_store() with
 change_enabled()
To: Breno Leitao <leitao@debian.org>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Lorenzo
 Stoakes" <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
	<dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, "Brendan
 Jackman" <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, "Mike
 Rapoport" <rppt@kernel.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<usamaarif642@gmail.com>, <kas@kernel.org>, <kernel-team@meta.com>, "Lorenzo
 Stoakes (Oracle)" <ljs@kernel.org>, Wei Yang <richard.weiyang@gmail.com>,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>
References: <20260311-thp_logs-v6-0-421e30d881e0@debian.org>
 <20260311-thp_logs-v6-3-421e30d881e0@debian.org>
Content-Language: en-US
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <20260311-thp_logs-v6-3-421e30d881e0@debian.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0171.namprd03.prod.outlook.com
 (2603:10b6:a03:338::26) To PH8PR11MB7989.namprd11.prod.outlook.com
 (2603:10b6:510:258::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB7989:EE_|PH0PR11MB7521:EE_
X-MS-Office365-Filtering-Correlation-Id: c59242bd-664a-4ace-7a8b-08de81504400
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: ZKG9kNk0GrP/YEzJGjB4NiYjPdo9h1CsrfzTwS6k9K+QPcSHzELA1G2RR4HS1+zZSIy+3V7JZWphCHvce6tvyNjoFEAoZE/Ye45tTkaWqEH7Ps0xNWqe5YMzTA2fDQgFW2hcajAHMed6GGBcrfCpwYmoHV8HuBCgDzQd7ZI6DWZNzOOCT5lE4+HDzIIZpNRQnL4EVckpRqRrxkBNBF6grfSymwLDEZnrEI3I51Ha7gohiaN3DjYfw3ZKh+1E6kvqTwi7Bs/huWkQYvenySIxKHHzPhj8J/XphGlTxe8Lx9i+sr5WEu3H2lsTYmTZhEPSJR369MA6xt9ymmnBgbJRucq8h0b5ePUs68+xBf265KrmddpT4MS1Q2mDYTetSj3umEjajV9D72g44r8lp0jzBXRpt6B2+uZ8zwGGeezo/XB2arF/uM3tiCIZXgPnEpFJzJkYB9xo8XwOWUoV93urA46kKHR57M3tL+vwx1YxUvia1nFYx/E9OP8UCSISNUo8mU9BCOXalR84Bx2BRYl0CuUnxt5znIdLC+YbTLce7Ixw77MK5B21Lt3+LFSrlnx8E4JQwBuv2CMB/liPOrkLYk2//fizQOqp82gpf0iJD/I/NW4g/3Lz0+oqQwA8ZupfpYGz58m2QyUrdto33gMJYPhfvfpKGzmKkaDmG9/uhkEHsh8T9532EUkG8H1e0KtrI/UK4k8djJIYjNZAVQEbet9hO2YODxB7RqGqJpLVXi8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB7989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkJZcndaSG5EbGFCMHVKaUZ3aENQSnpjdElUcWZUWnRqVXcvVHlKVTBEZy9H?=
 =?utf-8?B?V0FRSFI0am4zZGF6K09KTE9LRDkxaGFDYllnR3hyVTFyTW02T3pwZ25pbWl2?=
 =?utf-8?B?Y3dXWHlZU0s4cGpMT2tsRFM5dmNzamoyRk5TZmxxV3EzZUUxZG9rc0d6SWlx?=
 =?utf-8?B?dXpxcDVjUEZSdVBOQ1AxRk0xY3lZU0MrWVVGZVNoR1RqT2E1RjU1YlhacjBp?=
 =?utf-8?B?Wm55ZmJzMFBzRVBSV3lLdk9IL281dk5IU3B5V2xDNTMxMlh0QnhubDNCR09j?=
 =?utf-8?B?c2hYRlBOSk8rZTh4c2tCclEya2Jya1NobnY0cS9Kb2g0M0Fpak5LbllQZHM5?=
 =?utf-8?B?RTluVHFpKzl0Q2RsTklja0wzZHZwbDNsZStyekxsVDVoS3BGNktkMkQyY2RQ?=
 =?utf-8?B?Snk4UmZ6Y0JkVXR1UWhQRk5GbFJlMVV1VVBTSVdjNys4dWV1RTlHMkQ4NmtF?=
 =?utf-8?B?ZWV3RHZublFIUGRJMWpOdlBCL0crQm1Rb09HNlVoSW4rUUdrM3JMYUFTbXo4?=
 =?utf-8?B?ZzJMdlN4RmtrUWQyVkJkaDJ0Ukt3cmZVWlMxZXlmQ1oxVzZkNHpQK1NtRk1t?=
 =?utf-8?B?ZVRqNGNwajEyNmpLNnpqbUNITnd2NVdFbzZpUHFHMXNqc1JmOTRmMGhlTkxa?=
 =?utf-8?B?Zmt3MGpucjgraXZnWGxVQm5SZXhrWFhpRDBPMG9jSWs0VEFDUjZWNnBQMGFG?=
 =?utf-8?B?T1IwUzVQZ2xKOUp0NDRITU9ZRmlRVnFEYWc5RXJzNXJsZDlrRU42MDQxUURG?=
 =?utf-8?B?V0hwaE41OVRZRno3ZzArL2MvOUw2b1FEV2Jyc0hsM3JTU1VvdCsyWnhscTB3?=
 =?utf-8?B?OHJLUnFURWMrc3RsQms5ZnFyOFA1cmhEM21wcXlDKzRnUHFzUDVXbU5OMU9V?=
 =?utf-8?B?aFpsaW94emtmZVdmUlFJNGxmMUhqR0kvbURlTzV2MjN3V0lSeVd3SXNuYmhE?=
 =?utf-8?B?SkFLYWtUdlJDTFhpdFlFTStVQy9BZTJWZ2VTcGRBVW5LWFZvNWV1NUd0ZjVP?=
 =?utf-8?B?VkF3TVhDZjlJRTRmd3E0MGs5UnAxVE40eDRoK2M4S2cyWjBXMW9ST3A2Q0J4?=
 =?utf-8?B?aytZRDRkcWxGMk1OdkZ1TGJ5blQrVzMyVXRRRXd5eVNWOVFVS01yKzkrWWRV?=
 =?utf-8?B?Q3ZjL2t6VVY4bkJSSzJVcTF3Z0tLRkhtQTFRY3lJVzd3U2NYNjgrR3RyM0tS?=
 =?utf-8?B?V0ZwMTdZTUs1VFM3L3V4YzVqUXZIa3JiSjNCZXpPUDdTRzlDZ0lCbmFUWE4w?=
 =?utf-8?B?MTJlb0NUMXhoS1RJRnRTSndveGxqTWF6YlBEZDc1MHE0eGoydnYxSXpRdXQy?=
 =?utf-8?B?aDMxc2tUd21jOTA1Z0tQVFI1d1ZLamJLS2xXajIrVEJqSU5VdkR4b2hDOWgx?=
 =?utf-8?B?VW43WlFScCtib1ZUVzhXMmZ6c0VWdjlITThVUDVtNnlvc2lvWGp2YnpndGZa?=
 =?utf-8?B?Wml2S3NVNG9iSzl1MVNuV2x3L3hqQkpzd0VRUzFyN2ZHUGMrSjZCL1dnRWRW?=
 =?utf-8?B?bm9YbWJveTlGcUtGMHNkWGp3V2c0N0kvaHBERFpTVEZITEdsaTQ5Qk1SMHRC?=
 =?utf-8?B?UDFxbkJDZXltVVptUWdzVGhlV0ZBL0FZUlV3RkhNTVMyTkkvQ1BuSmZ6Q0U3?=
 =?utf-8?B?TXJKcjkzdGJlMU9xWjFQNU9SVnpIOTd5OEhINjh4UGNqK3g3bFFDKzR2NGlM?=
 =?utf-8?B?amc5eFlsbHp1L3gxaVJuTENXd25CNjlCUzVobU5DVlFRWkhSQ0dhcWNSZnM3?=
 =?utf-8?B?SGpRa3JrZXQ2djZ1QVFZdWt3dWVDSEszOW41SVJjc3RvZndUL1Z1T1E5QkR1?=
 =?utf-8?B?N3lvOWZsNFY5VU5SQzlzOGRCemJuY202VnM5enYrS1pXQmF5VnlwdnlLY0pO?=
 =?utf-8?B?Tk91dkRDWnB2MTd4TWpEVDdTWEpJc1l3S3ZRRGUyNitTZ0FSbWRQeHlUb2N2?=
 =?utf-8?B?ZjdHZlg3WHB5VXN5QzdNdklJOTdlSmV0OElXTUNTcjM2aFNsUUNsK3haN1Rx?=
 =?utf-8?B?THAwcWlZSjRtQWtacEN5UmlWbXpqMUF2dEhSQmZjd0tSWVJCbUtQRUZpT2Y3?=
 =?utf-8?B?end5UENqS09yNkZ2MVlxalF6M1p4Y0tUMExDVHM4UHF5Snp4N0NSQjNtS2hG?=
 =?utf-8?B?S1NLakFzUmp2TnBSNlBZaXhDVVdnSlRGUWxsRndiTDJaRkNPOThwcDVDYzdX?=
 =?utf-8?B?U092aDdpVUc5NUZTeGthRnM1dGtaTFMxMVF1aEVLRVlVYnVyUUR4TEt1RXV1?=
 =?utf-8?B?RWRTMWwxanhMaTdkZ1drdElMblNmazVWTlExdWl0bjBqQW1ERXQ4aHpzMWhC?=
 =?utf-8?B?MXV5c1RtVUdrT01vdUdrSXRETFRlMm9OU1QyTGFUNkJQcE52VTlYQT09?=
X-Exchange-RoutingPolicyChecked: a+LCik09ApSgu4dlBjmmuBa9wI7D9dL/qCcFN615XP182L8zmY99Y7InHuysnoBbhG+b9RjYw1nUd4+J87v1z3T/8O8TAQqH4oOcf9rxAbN5jDJbU8/x97V/MMBwQxtGBwgX9am8p1fiT5gRV7E5ip/IUUFDw4GJAlJdvfOUABHayTDavPwiKXs2mQwfuCANHAYXYriSzbWOYAsX316DQ2iV49y/lDz/FOWr5wEInEv+16nWG0AVT2ldoBJ5pthMBgdb9fGVWvQzaNs5BeCI3HVZ26rKgfnbriPN6Ctk78sxIMLBWPhYRV64/F61TPYvaPjm0aaPuoNzTXj8seCT9w==
X-MS-Exchange-CrossTenant-Network-Message-Id: c59242bd-664a-4ace-7a8b-08de81504400
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB7989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 22:31:27.3659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hCTobIF/qeFvTBCw7xPOAtpa497/LdH8i5Sd+5cxLqXKlUHiRFXRIDdFsrJclm9cLqDvAGXm8rU6ROtNxmqJ9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7521
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 3EFF820006
X-Rspamd-Server: rspam07
X-Stat-Signature: c4iwdkesm5oxkoduuqtjmob3mh77tko5
X-Rspam-User: 
X-HE-Tag: 1773441092-742086
X-HE-Meta: U2FsdGVkX18ZzP53r3XOw6gmqhDyX2EAM5RBamAkiIIBZUr+nMS73Qd+i4yfWsYhBzVX+mO/fzcbA+zcoS3cS8B2fIanK7IkFqdBjCiwoGQ0FaflG+vw0E9dj3mEmxrx5T4mVoZ/gswrO17DPAJPcF+uW8dUJSv0+eYaXnfg0Pf1ik1A7ZyIeTxSlwaZ/LTHfCghHFcM2a+8ObpqzLn7jDcasP3f3QQF3966+EY6fiJF/dJh20m6d3K+T9o0nUjgCf5o5kTeoUWiuZpo4LKqB/RKEK/9oaCYdsxG8HU52KpY/iU+E1G1xvbyapd9ccBs4Jl0l0eRmI/BKTJLyRr+B6uIBw9RDJan2ujfM8ijPiz/lioaikotPGaw1JrKeX3hjifXH0SIg6Qaxgyo+9pGqJpN71wjQyx8ygcBzWZloh8F8kBjwCMfTDKeK2MH2BP9VHES3wPNAF82/vOem8hi4GPMatdNMKi5i77gHhzlJixod+CF4yn3TKi6+cPMI17KGZEjLYewlGNADQIwx+ZIUQGr/FvzM9sOW+q2WKzSc/w9G6H079SJO5wZBjvz3NFmKOIbbTIDHZ3jKwyIBrC3BlFyylJ3iiAkYC7EOBFn3myb8qUjNweszOHqyX1TQtMvk573DfCjgnCAz/p9YIkQJr5Z+Zu0EBKU6osKD3QHH1YcUIfCuUt+emxGg3dS3d5qX0Wg0oShQ+KvMtKMRdy5UuaUBiPvhi1QNKhVesMtpXw2X3K5jGVGucKEuzxaEBaK8zfE6ypsIUDRpaEkko1bg/RLXMqn5S90OVSIq3+k/vTYuQGMK72IP7XWcVJ372D3IxqU8greDYh/zYACH5vSP7kE2gE5f6MNiHFPTVeOaKQj1QEAP/SC24MaOaypi+2LFigHB60P+LBtaJCsvTDua3LtkXSWjkFDCOe1ypwcwLu5Zf5O0n1UZV4TEPFm5tKBU5mGx/UvVH98Bz6igVm
 CpZnBzHG
 Q5qn9XAobz+aEnps9kgSlXWFnnyBL1/EweC3al3xZi+1x6ov1gNPy7N700/fOUPD5yKBxRdSyxrxGr0A947GFuNKZhe989eVGhnsE6flp2N/pRwo+wz9qtGmV4LPmwsahNfz3KZHGWHc6JJIZhGXd06g1sDsQgV6okHB5r+HwkkdyGQJBLLQm2mR/OAuhLIF3bi61lDKIOHaajM1X34S4fMW3ifyDpCZrU2s5YnSI01OKSORHjSWWy37YvVXcWx54SxhIBX+7iSqvAjlYKL0maLJrWuI11LmaqT3/LWNmUkaXu2hAjKoBR3UeNH+PnqhScs8EOAnIO4BytMqoDKa+wnFe7SJuWqnBjQSMnEpnUHYZuoVpT59d04hvjPdQvR+VvABXEMIqY+r4z6zbpOJGCUhfVCIqpqrDC8exW6y74CWlUnjzHTJY3tsxeLT5c0/j3ejnUWx8ibPwUoN3u+SWjlEoBro4NrfKG/ibS8ibYBBhaxixJuDHhslHyD7iLapd+WD+B/ARraDhCZQGO6KciepALOzKFcSJTExaSyEhSI7HcLEgtTahl63uaMSKCkMlm+Qm5ejD0yFe+rSnWBSJHUCoJ40PNYgsONWiTUjl4qgAlx1oyIB5Y3T0lA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On 3/11/2026 3:17 AM, Breno Leitao wrote:

> +static bool set_global_enabled_mode(enum global_enabled_mode mode)
> +{
> +	static const unsigned long thp_flags[] = {
> +		TRANSPARENT_HUGEPAGE_FLAG,
> +		TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
> +	};
> +	enum global_enabled_mode m;
> +	bool changed = false;
> +
> +	for (m = 0; m < ARRAY_SIZE(thp_flags); m++) {
> +		if (m == mode)
> +			changed |= !__test_and_set_bit(thp_flags[m],
> +						       &transparent_hugepage_flags);
> +		else
> +			changed |= __test_and_clear_bit(thp_flags[m],
> +							&transparent_hugepage_flags);

I am not a mm expert and typically do not follow the mm list. Is there
an issue with the usage of non-atomic variants here? The commit message
says this uses the same pattern as set_anon_enabled_mode().

However, set_anon_enabled_mode() has a spinlock=>huge_anon_orders_lock
protecting the access. But, transparent_hugepage_flags seems to be
unprotected in that regard.

IIUC, David's suggestion to use the lockless version was also based on
the use of a lock in that context.
https://lore.kernel.org/all/4f2abf42-983f-4cc2-92f5-c81827e7b7e2@kernel.org/

Note: We ran into this issue while experimenting with an AI review agent
internally. The patch was selected at random from the mailing list. I
analyzed the issue independently and came to the same conclusion. I
apologize if this is a false alarm.


> +	}
> +
> +	return changed;
> +}
> +

