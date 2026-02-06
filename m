Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34763EB28F1
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 08:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 706CD6B0088; Fri,  6 Feb 2026 03:43:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E59F6B0089; Fri,  6 Feb 2026 03:43:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AF6C6B0092; Fri,  6 Feb 2026 03:43:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46BDD6B0088
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:43:37 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CFB151B2D15
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:43:36 +0000 (UTC)
X-FDA: 84413393232.23.3FD12D3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf05.hostedemail.com (Postfix) with ESMTP id BC24510000A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:43:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="S1/SUiZf";
	spf=pass (imf05.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770367413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6oAlpAWDlNCHbkMAitTQlwJGdYJsN4U1kxNn70cxJHY=;
	b=JVt119T3WxndRBlYYXW4LEbBEdCCxOxjzfIrD3dk1oE+DV1y898Tn5K7DZebZOPwNSJrg/
	niWZSKRg3n94hiqwJVzGSiSozIBbm1sYK5KESKCCCLXGrmmX475NFS4FLE9Vmp3mr5Vxhu
	f+DJ5QKdUdnclbsKdxaXzLiDUfX9RuY=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="S1/SUiZf";
	spf=pass (imf05.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770367413; a=rsa-sha256;
	cv=fail;
	b=itlg8nyc5mdJhno5yc1eCUOPi1CW6g9I9PlSUfFYbk3OWYiNlFa/1kshqHTWXqf/AIM8KE
	uVTg06D5q5wFB3l/BRl1T1SDtcqc2hXdgDuLoUjbQZ7/v2mNis/SPcZKgsYDH9EERY/3P1
	jZZb8jSXCWuK/EAWib1zz9U0OuLHq0g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770367412; x=1801903412;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=46Fw145lxawUS23RVi0igb2p1m5OZv7zIu04sJKYEkY=;
  b=S1/SUiZf2K2qXoSO0noc1sWCfix3rMM7UXYDvql4ZY+Hl8RcNqZ2Jr+w
   1JMGtmiTCWtq345kzVIeGHJJLURcNz3Q2ypPeehGKrLn3EvUFsGJz3/en
   84mJBWBzPNpJDQxLwMhm7YY0dhtY2jJR2961K7u0gco2d7hix9AU5AsPn
   yONWkHBMhyTw4dUGdPApsrLMjzLOLhUdeDPv12vJHDeHI4CAgBwMUt4wT
   b3czIIUl2J0eV5ZZhyKk4ZhmIc1tn8k0IFuZshyKFqrgMrf/CGEwMrx+y
   nlbKYzkg5A2NJaPlzYvv8OalGS3XR7b0AW+H9hlEy2diHw8SZdhW5pkHP
   g==;
X-CSE-ConnectionGUID: eJIxwl+dT/CwALvzOct5Jw==
X-CSE-MsgGUID: RqcuLAsESaWjAwrZH6XAkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="88997454"
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="88997454"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 00:43:31 -0800
X-CSE-ConnectionGUID: fxmMQ2cAToGN9EsNc0vXag==
X-CSE-MsgGUID: 9UkkPZQmQfybdVNOGzWz2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="210176564"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 00:43:31 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 00:43:30 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 6 Feb 2026 00:43:30 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.48) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 00:43:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JcXLysm9AtbAK2+/UZk8Qhjw36LcfMuBsWTKtW6P1oMi1h4USb5ySWYkdEMPV4K+EBAee55Ddhc/8SVyUFyeNvWL3P2rBSZlWpcFNtBKpx8H2xEe6LaaXwTtfWPuS1uVhpajl7eAJ8b0yJ3usj07tywT2xIl04WXB5Mg11jNrnKVBfviTmpftZK309EUoR53bVsF46PDN/DdTDQ23TWH5xbpc6fp6/pzfn35hNTFtk+3m3VVGiTOQyuYr4V9I+DS4XQ6pr7zZ12CkCEWuj6XEk25t5AMe6tWgX7qeDsG1KEnS4mfvmOgGs+XHZRYg79GhwF3/VVJ/hVzMI0XlWKCGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pWvzNuoJ7ATFL6jNAxZSC1o9fESXEOFn3VWCZu3zXKM=;
 b=QDT9OcD6R06hisR6i19IBzXcPjQYZD8NRc68p0P9/YLkoXBtDSA7HTDFg82+4kJyOSQ/TsF+zF1SQc6zO7FCfU+F4HE9TzFV4+4Sfwl3e4hM+yUMhWvbLGeI0lMtLlArt4NtTq3KJNow2BzpFiZBCW1BUCHcQB/NQvznwaAxp6+kAE6GRxC9EQjNqshp1bVAlsRuBe+crRfPZeX9QhEpOVrbuRMHJ96gQz535CtssepsZDKLsr74yciWGFp+45PZifaDd2BRXi1g72WwoGVh3eR6BSrDUetHrwJ7b+x3fSzMzR0iP8QVjt6IztBY8i+Lox6IrtuaK3WbtlG5pdRhYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH8PR11MB6803.namprd11.prod.outlook.com (2603:10b6:510:1cb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13; Fri, 6 Feb
 2026 08:43:28 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::e4de:b1d:5557:7257]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::e4de:b1d:5557:7257%5]) with mapi id 15.20.9587.010; Fri, 6 Feb 2026
 08:43:28 +0000
Date: Fri, 6 Feb 2026 16:43:15 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
	<jackmanb@google.com>, David Hildenbrand <david@kernel.org>, David Rientjes
	<rientjes@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Liam Howlett <liam.howlett@oracle.com>, "Lorenzo
 Stoakes" <lorenzo.stoakes@oracle.com>, Mike Rapoport <rppt@kernel.org>,
	"Pedro Falcato" <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>, <linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [mm/page_alloc]  6698721815:
 vm-scalability.throughput 16.9% improvement
Message-ID: <202602061659.a17e1110-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SI2PR01CA0035.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::13) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH8PR11MB6803:EE_
X-MS-Office365-Filtering-Correlation-Id: 976b5334-4c18-4637-13e9-08de655bcbf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?TJKbgZntt78utWsJj/BM+pZPUbzS+4SXr+XER9+ZKx1PXcgf017O8zquVN?=
 =?iso-8859-1?Q?t+4LAoF7d5EWhDlyawnYZqNlWPOhrZo5oTHbQP5Wf9sysXlsoMX0XGrX4L?=
 =?iso-8859-1?Q?BBpNftQZ8X+jkao/GBCGXDe5xOYKt/wBuoweztYwQqb+6lTBCdqo5u9yJw?=
 =?iso-8859-1?Q?GffLlkwty8WdcgMfQjx78gdzY0nUGcQOnSHTEGnmZRZXtngiJhsCw4r88C?=
 =?iso-8859-1?Q?hqpi6sW7E5JVL9tI0GrXriVhq8xL6k10FKSYKWfKyCsv/y2blszIPAJCdc?=
 =?iso-8859-1?Q?wmIy/eqpEM116VrLT0SPSC9kU0qHErd8cUv9FjqzihlwIHlfr5TOZUdH9C?=
 =?iso-8859-1?Q?BOORPKFamIgMRXC0P8qxWyvg4cT+hToixfvZhnKeWbzVM8MLpK+kZN6qor?=
 =?iso-8859-1?Q?eb1TEepnXKxUdb7Xhq2SXUUXFIhTAsVT9pjRD/KH7R27wMt4QPuRTLBG+w?=
 =?iso-8859-1?Q?/sZF6TpfQW7XZEf97JIN4K+6ZcMOXZ1hC2aIKza5gfMePoYCCHiNcKBQrw?=
 =?iso-8859-1?Q?WwfxKpBp8hnd8aTdstS/dsQFBrnAkzpp9lkNIYX69cWuza8HNk7AEu2nw0?=
 =?iso-8859-1?Q?2OSSbHM1KtvVnoUMBAzCuRdX3eXpohEnSOeiKXXCsVKMU+YvrMd8/vNcpq?=
 =?iso-8859-1?Q?FFRwfSVCnPAGKYN1YkZzEVF6iNArpsd2HzK/28aTxC++NsHE5GJw8gDnfn?=
 =?iso-8859-1?Q?shT81saQDmfrVnsoUuVsakwPxmW6h8Rt7ilqbZBQxEDN7e5tD3hFyUvx69?=
 =?iso-8859-1?Q?6s5GC9g5rgaOT5jfk2AJpolgOe81ORC/SxBxUCv2wIpjyeFVq9mtgFNB8h?=
 =?iso-8859-1?Q?r+RBBi68k5j8Hln/cQnTR98Suc3lbtvxuj49ucn1H9qCwXh8diRoVCTe4F?=
 =?iso-8859-1?Q?ZyZYh4qlFOh47F7bqG8j3Qr5w1K6qlJGYjLpP3s/fu+p2d4ZKV4ERdo+2R?=
 =?iso-8859-1?Q?dQxihi9Ss+mCqCfCF8b+q8U+E6cZ0ekyPEJUMeBvH/Rka88U+FbKiNlIx5?=
 =?iso-8859-1?Q?AgvIRlbIRW9LgEX8YwOo/WbcTCP776eEPJzBlpQx+Y325J0JO0eF00Keik?=
 =?iso-8859-1?Q?N5wvhuGxVPxrY1x7vtON8sEYd5sqXUYn8CT49KVS1NpnRApv+aY27ChV4c?=
 =?iso-8859-1?Q?aIi8EHQO7KkT0eXO7HNXBzwsyGmStxW7FtOj3WXCEArZB08s0vf3ygOMuy?=
 =?iso-8859-1?Q?Nq+2Irw9XnJK+P/R5V4M0fW2Tf20sdtnRxNRVt8Z4yVPjorXccwXY4IpcX?=
 =?iso-8859-1?Q?WARBzuSurqSGMbbGAsohxvmD+AQEXE7OnMWF5y7FsGxPUcavBEUSTI/Aa/?=
 =?iso-8859-1?Q?mvTJ27qf12g4TLeUycM5u/H+Fswo9bKDjeJcv3zp1A1YTI31hKvE1Dybfb?=
 =?iso-8859-1?Q?BIMcPxC+Du/slUyD8aFaToghJ02WlHNQimbymsPvx5Bximshv/85NFkr4j?=
 =?iso-8859-1?Q?0Uq5sFmQx1tCftYEVZXN2ChYNWuUJa/qNgn+Iru1/CDtVMy4+vYo1tkJut?=
 =?iso-8859-1?Q?pTKIPyRqetDpXM2+5EpLokAWIEVoBjxaL5h7fzkjBfOTIfLSwZXSkc5d7X?=
 =?iso-8859-1?Q?zQ/j3qsPdJF9HTxI0gXNhxl6h8ndTvoS23xgG+D63wyP0Gum9cBWVFau0f?=
 =?iso-8859-1?Q?u8ktkNlLET2g4HMNO+VS+O/I7BA71tZajb?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?LZYHOjjD/OEF3SM5mbDHHHR/7RKxFHbi+hEv3i4SCxba6X7ZBMNAWD0kN6?=
 =?iso-8859-1?Q?JBTisJcp+ZoBsoAN74i9NZC+WqcPzT1f8bfT89r35gjTtM7LTEd6lifzNJ?=
 =?iso-8859-1?Q?JcPBFpdu7iK3xqvh/bgEfnCEJrJaC7O02ECsmZ0Rs1m5+QylGoQGOyEHYq?=
 =?iso-8859-1?Q?rtm+Kjj+Rdp/DIXDg4D+7HoYpDjwH5Ae7g7XKvfrm+zI+85HnyAhXAwbFH?=
 =?iso-8859-1?Q?NW/tbFaWAzTzC8Xcq86uMghVZu9JxnvQmxQS+cBYWG+8IvbqrmGTndHd7b?=
 =?iso-8859-1?Q?8HlYJUANJ9y8F1xKq2knOiCoHl3MxTTRb6bjlhmlmANotWUQV8dWsVmqUC?=
 =?iso-8859-1?Q?XbMEq0htc5MPJEfCRTWJoHedQQLzW789ba1b/0IPup58GPaLKvqzZlzs3p?=
 =?iso-8859-1?Q?teYp+cdD8xh0p48iXZkPtyXqHk58HDEghdrscUUZ8DS8GFSxnyHRa+LgYu?=
 =?iso-8859-1?Q?zALaza1mqmIqId3LexX0O8TbCu1G9WSJ6wfk0qmo6pOcZqBXqJPDdpgxFs?=
 =?iso-8859-1?Q?Nd64Jgkk1nRlrB+sOY0VChwdc15gflh8tWBysqdIiaWhVUTWzGEs7CKCr6?=
 =?iso-8859-1?Q?U816Jv4YlaPSgIdubHHaC5LiDYOsXzF4C6a0YNNOyBq/9y40n/UOkGXsHj?=
 =?iso-8859-1?Q?rdIdS82I9/P5NhdOzaBX1YLmuBzndulHC6QGhSnXGh2J/dEUAOoZcAiLeJ?=
 =?iso-8859-1?Q?7a3Z63O4U5jffbRU824qc4l1sg+eyKcJHMWei4Z7Ug7gaaPo+8/ey6HYUc?=
 =?iso-8859-1?Q?3R5axVlRLicF33qXYwwsuwIxiSXGYV6mJNxOw8oX2uYmUFCUZS92IsnYbn?=
 =?iso-8859-1?Q?sE7Rt+WGSUfa5NSgX0pY2eFXkWl/LiEv571SwPJhV9ghwSVUFqd4/AZ+zL?=
 =?iso-8859-1?Q?6Nr1ti/7pXWWxGHwc/9O3F25lSNZ4ZhzqMV9jnnQrtBnHcGntE/IKiG9dF?=
 =?iso-8859-1?Q?pOY4808TEjCbyiY+4roMgAGch1IJvZlVW3g9wICjmxyfKhOJQJnMHbZ3vw?=
 =?iso-8859-1?Q?MP8MepOQhuo9iyNJOUryh7uo2LK3V/zVQuqgps2qYxMScB/6FeozNGfExT?=
 =?iso-8859-1?Q?Hcmb5GgjH/S6u2tavkyWPO6tUBQcOWCqrH0dQx0NEtk+ej9XXWswOW2E28?=
 =?iso-8859-1?Q?ZHexrnt1TXdV/DSijlrvTB1yw4Yf4n5QkoEq6AdXnoT7pEdzZ5eNgmRuYC?=
 =?iso-8859-1?Q?A6EVqERvSn0u4M3ViEPi9yFt0iEi1Gp+WKQA4VUyHcIVs25w4fWjqosq8Q?=
 =?iso-8859-1?Q?UUFU0lH3ycGTogI5SEv50RTArPX+UJCllmM+oeb0DhzNHu1jRjUWsrJ16g?=
 =?iso-8859-1?Q?HkHNZD2BRg4UtSuxqbkrngH2tHEaEUJI7Vuvvx/MAp1UIk06K6j27Gbisi?=
 =?iso-8859-1?Q?Rqm3ulSB/ChKPzZpXLtdqN0qRg+q3ZvK2LXe5RZrUft06llu7UA1A0RI4O?=
 =?iso-8859-1?Q?vnl/rBVg3Ihfghicw2EmtLdgx4zpK2GaW1xyH7CPkaYoDUsnNvELB4ktNx?=
 =?iso-8859-1?Q?6k7LQPFKyBW207JFnytbOss0BOd0D2L5KLqkuUO9ODJ7M/cgfoDeDTGZVK?=
 =?iso-8859-1?Q?SkGZg9nHgQdW7Gb/LHdYHF0A09murwjKAxYI+Ise7nxLi846RGRhFpATuR?=
 =?iso-8859-1?Q?SMBke+bf8392F4x1i25jue8lTmUOzoieL2wHXkW/TpnBGUTe1uw+H6hpH/?=
 =?iso-8859-1?Q?K56gYKGGGRJBfge3rlGM1aDmdcMLSdBfrBLo4j8YwbatMm6cIK7YLlOKYs?=
 =?iso-8859-1?Q?U9zkG1CoWLr66jC+N6Sx3Tgm7Ni6BYy+a/4LCiHJzsUQKSbRyTuS1r/pGM?=
 =?iso-8859-1?Q?ZQPrxknekg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 976b5334-4c18-4637-13e9-08de655bcbf8
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 08:43:28.3793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VF3w9pDDWV0mJrJHqdSlhp75QHtAaQAXpyDcenslJ8m2wN68hBxKIZfAA8aEQTKod4XIjWldsSZ9xqk8V5olPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6803
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BC24510000A
X-Stat-Signature: jpkbyurnrn1yq9bbch57rk1fun4xmpqx
X-Rspam-User: 
X-HE-Tag: 1770367412-48208
X-HE-Meta: U2FsdGVkX19hUBEiaB+yhdMnG2zDXGsHj1N+WC5SpQJ376aZrLKDgqYWn8HoBbJEKNdhHJi3g93NuSQAndKYgk2sTmAPD50kqW1kS3vgXMl2ZCsIxGWTDbIYio+Ex8YcWhDoBTA7JfCIfzAgMQcYfaUJGfaU9ZWx5tjpfIbO9IiRTRgVjbTG118KzR6vJh5uUJ81hFIUzJPZWBYoWhh8UeZa/SVRcoWvKnuXg9SEkMVQZK0lvpyqVUKsoqViSu2X3wvpYVy8pmy9bz0S+nskr8dDt4OpePI+FLOXnDHhuZDNm33mCH58T2Q0hCFdoD9J7O1x+GrbasGw7Gof6T366dbR21aMPUTwn3uVV/rXqyh2vyaB5PH30WMdPxiFkADKZ/YUeRxcK5fdMA7ufMFe61VnpiP95GynRJU91FOLXFXOELUz5KqHSxb7Ued5wtgb1vHWjqYoEDmQuXGmbz/a00UBP2rRPbbd1W0NrThJiSqjKYAGcu7/O4+O8DnFAa75txp2R2earNC2cUa1pPb4/rZb1ADaNTCF9cIRiaRCkdRxKu6wmGH1YLfpuhmz+9qtv9SzvBDMnbIpsPzKXdL5I8AC/yIpu2ssguolS27QizrcwCN5uV6RVmDCvmgp6SQFrtPjPIyrbEiprvJz/3iOiTOqWJ5JozO764PRsLFb0K7zFGS3o2agi3UQ5JTnGDC3fuI+9X7TR0dK89UQwwRvW53eoToJ196K/RFeN2JBlzze2JH+k7bZ57wA6YCzsa+nzCorx+iSAZFRTnAv/2r71AhM1mrWj5Lon9z1QV5PD/mcjhFjTZppandtCJlg2nH0JnRPn/n2Shu98wC48SPQ6+syDqe4TTTIAzIa9jzpaz2oRVXyWodWK9MpqiqepqiEruxgHnmigc1EJAF9Xx9VCjm1Ygq6rbPrqZst72el0lQ9pIF97p/LzXjAGMQkd2FuJw5Ika/P0vw8JDe7N5w
 +9XcOB4m
 qMiW3DhU0KfvKFO373V8q5yKgmZre2wSkt1qp4Okz0BpJj7XpLiY32E6yfQxxWiluMNLkZknwAR1OqagfRY3LuFV4KBy58Pgw6g16rfJXh7LPedAg08k9/u/dPK1O9WDh35+aRPzBnWGHFZy5CsHedpjQOuJSsmqXzL8sZxv8bhYOKSirBN5udGXslhQuMAiC8ZVLWSSDh1NSnI+unb59co2dDdSo6wRALQeQcY84Cj5jr/8pdcRuhCQX7c5uHvAHXxPOj4VpGSKgM5zdSsirQyKM7zrBwsFpqpT6i6Fs81hq74K3F+rRsF8o1U7Oy95U0FHmOYmy2anTNbE4mfuiSxwxJaFsBTGFBoTg40Fgz/K1bTC/6aInPeXwxBWIHYZfvxYUpsw0FhtHy3nIYuVEqjXBQdhUKk1qvr05L6a2CZPTXjBdFAbc+GOS5hD7AQzt7Dhi2FBZ879uIRXY14xdywa6G7qnJFdv4KVSjZ3gJtSGeT6sWtGGjH0y9oUbcwFaMdS75P5FaKytj0a5QVKvrtBjWJsBIBmo0WFfLHotOhHyX+Xqsu91+NW8uNPEgwPN2n9EEJQnAwEQpWfiWGK7l1BDjOYJZVjJ8GXzwQQY+c+FCoS2lmtx+a3PJdVXl5yalKlUo4F1cAteor4hxFES9WEn340xXOycevIPetmM4eHZO8hRvsqAehGhiKpUWFXVKn9Lelmfm/VVIOo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 16.9% improvement of vm-scalability.throughput on:


commit: 66987218154918a6341a3e3eeeee58110a69e0bb ("mm/page_alloc: ignore the exact initial compaction result")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master


testcase: vm-scalability
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 256 threads 4 sockets INTEL(R) XEON(R) PLATINUM 8592+ (Emerald Rapids) with 256G memory
parameters:

	runtime: 300s
	test: lru-file-readonce
	cpufreq_governor: performance


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260206/202602061659.a17e1110-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/rootfs/runtime/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/debian-13-x86_64-20250902.cgz/300s/lkp-emr-2sp1/lru-file-readonce/vm-scalability

commit: 
  d17f02417a ("mm/rmap: separate out fork-only logic on anon_vma_clone()")
  6698721815 ("mm/page_alloc: ignore the exact initial compaction result")

d17f02417a337de0 66987218154918a6341a3e3eeee 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      2.07 ±201%    +213.6%       6.50 ± 96%  vmstat.memory.buff
     30.09 ±  3%      +2.8       32.89 ±  3%  mpstat.cpu.all.idle%
      0.15 ±  3%      +0.0        0.16 ±  3%  mpstat.cpu.all.irq%
      1.10            +0.1        1.21        mpstat.cpu.all.usr%
     29.13 ±  4%      +2.7       31.84 ±  2%  turbostat.C6%
  10961264           -12.1%    9635977        turbostat.IRQ
     39.55            +6.9%      42.27        turbostat.RAMWatt
    881807 ± 13%     -19.1%     713350 ±  4%  numa-meminfo.node0.KReclaimable
    881807 ± 13%     -19.1%     713350 ±  4%  numa-meminfo.node0.SReclaimable
   1055803 ± 11%     -15.9%     888061 ±  4%  numa-meminfo.node0.Slab
    702201 ±  7%     +18.8%     833965 ± 11%  numa-meminfo.node2.KReclaimable
    702201 ±  7%     +18.8%     833965 ± 11%  numa-meminfo.node2.SReclaimable
    837079 ±  6%     +16.2%     973054 ± 10%  numa-meminfo.node2.Slab
    426746 ±  2%     +17.3%     500442 ±  2%  vm-scalability.median
      1166 ± 28%   +1053.6        2219 ± 15%  vm-scalability.stddev%
  1.11e+08 ±  2%     +16.9%  1.297e+08        vm-scalability.throughput
     54.43           -10.4%      48.78        vm-scalability.time.elapsed_time
     54.43           -10.4%      48.78        vm-scalability.time.elapsed_time.max
    103326 ±  4%     -15.5%      87260 ±  3%  vm-scalability.time.involuntary_context_switches
     17909            -3.9%      17205        vm-scalability.time.percent_of_cpu_this_job_got
      9605 ±  2%     -14.1%       8252        vm-scalability.time.system_time
      1.17 ± 24%      -0.6        0.58 ± 82%  perf-profile.calltrace.cycles-pp.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.17 ± 24%      -0.6        0.58 ± 82%  perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.97 ± 37%      -0.6        0.40 ± 57%  perf-profile.children.cycles-pp.rcu_pending
      0.03 ±223%      +0.2        0.24 ± 33%  perf-profile.children.cycles-pp.__get_user_pages
      0.03 ±223%      +0.2        0.24 ± 33%  perf-profile.children.cycles-pp.get_user_pages_remote
      0.27 ± 52%      +0.2        0.50 ± 20%  perf-profile.children.cycles-pp.load_elf_interp
      0.08 ±101%      +0.2        0.33 ± 46%  perf-profile.children.cycles-pp.get_arg_page
      0.59 ± 37%      -0.4        0.21 ±102%  perf-profile.self.cycles-pp.__percpu_counter_sum
      0.03 ±223%      +0.2        0.21 ± 30%  perf-profile.self.cycles-pp.sched_setaffinity
      7.31 ±  2%     +19.9%       8.77 ±  4%  perf-stat.i.MPKI
     58.30            +2.2       60.49        perf-stat.i.cache-miss-rate%
 7.426e+08           +17.5%  8.722e+08        perf-stat.i.cache-misses
 1.228e+09           +12.0%  1.376e+09        perf-stat.i.cache-references
    580.71 ±  7%     -16.7%     483.74 ±  3%  perf-stat.i.cycles-between-cache-misses
      7.41           +18.3%       8.76 ±  5%  perf-stat.overall.MPKI
     60.61            +3.0       63.61        perf-stat.overall.cache-miss-rate%
    704.31           -17.1%     583.78        perf-stat.overall.cycles-between-cache-misses
      1296 ±  2%     -11.5%       1147 ±  5%  perf-stat.overall.path-length
 7.497e+08           +16.2%  8.715e+08        perf-stat.ps.cache-misses
 1.237e+09           +10.8%   1.37e+09        perf-stat.ps.cache-references
 5.281e+11 ±  2%      -3.7%  5.086e+11        perf-stat.ps.cpu-cycles
 5.569e+12 ±  2%     -11.5%  4.928e+12 ±  5%  perf-stat.total.instructions
   3008740 ±  2%     +33.6%    4020245 ±  3%  proc-vmstat.allocstall_movable
    482140 ± 81%     +81.6%     875667 ± 51%  proc-vmstat.compact_stall
    313239 ± 60%    +108.2%     652063 ± 45%  proc-vmstat.compact_success
      8065            -2.8%       7836        proc-vmstat.nr_page_table_pages
  39936876 ±  2%     -59.1%   16330199        proc-vmstat.numa_foreign
  95893347           -76.7%   22371986        proc-vmstat.numa_hit
  95488037           -77.0%   21972039        proc-vmstat.numa_local
  39916786 ±  2%     -59.1%   16315472        proc-vmstat.numa_miss
  40314192 ±  2%     -58.5%   16714902        proc-vmstat.numa_other
    687855            -2.2%     672475        proc-vmstat.pgfault
     37269            -2.4%      36389        proc-vmstat.pgreuse
 7.849e+08            -8.8%  7.158e+08 ±  3%  proc-vmstat.pgscan_direct
 2.277e+08 ±  5%     +29.8%  2.956e+08 ±  9%  proc-vmstat.pgscan_kswapd
 7.849e+08            -8.8%  7.158e+08 ±  3%  proc-vmstat.pgsteal_direct
 2.277e+08 ±  5%     +29.8%  2.956e+08 ±  9%  proc-vmstat.pgsteal_kswapd
  23897099           -77.3%    5427738 ±  5%  numa-numastat.node0.local_node
   9808674 ±  3%     -65.9%    3340632 ±  3%  numa-numastat.node0.numa_foreign
  23996306           -76.9%    5539552 ±  4%  numa-numastat.node0.numa_hit
   9935480 ±  3%     -48.6%    5104083 ±  2%  numa-numastat.node0.numa_miss
  10033238 ±  3%     -48.0%    5215298 ±  3%  numa-numastat.node0.other_node
  23818598 ±  2%     -77.6%    5336433 ±  3%  numa-numastat.node1.local_node
  10422599 ±  4%     -60.6%    4107508 ±  5%  numa-numastat.node1.numa_foreign
  23903690 ±  2%     -77.3%    5425282 ±  3%  numa-numastat.node1.numa_hit
   9568102 ±  3%     -62.3%    3606134 ±  2%  numa-numastat.node1.numa_miss
   9650828 ±  3%     -61.7%    3694897 ±  2%  numa-numastat.node1.other_node
  23244424           -76.6%    5433322 ±  3%  numa-numastat.node2.local_node
  10157128 ±  2%     -58.5%    4212315 ±  3%  numa-numastat.node2.numa_foreign
  23367486           -76.3%    5531118 ±  3%  numa-numastat.node2.numa_hit
   9655573 ±  4%     -59.5%    3909187 ±  3%  numa-numastat.node2.numa_miss
   9778660 ±  4%     -59.0%    4007790 ±  2%  numa-numastat.node2.other_node
  24517225 ±  2%     -76.5%    5765127 ±  3%  numa-numastat.node3.local_node
   9548474 ±  4%     -51.1%    4669743 ±  4%  numa-numastat.node3.numa_foreign
  24615123 ±  2%     -76.2%    5866615 ±  3%  numa-numastat.node3.numa_hit
  10757630 ±  2%     -65.6%    3696067 ±  3%  numa-numastat.node3.numa_miss
  10851465           -65.0%    3796917 ±  2%  numa-numastat.node3.other_node
   1363284 ±  6%     +12.5%    1533491 ±  7%  numa-vmstat.node0.nr_free_pages_blocks
    219953 ± 13%     -19.0%     178205 ±  4%  numa-vmstat.node0.nr_slab_reclaimable
   9808674 ±  3%     -65.9%    3340632 ±  3%  numa-vmstat.node0.numa_foreign
  23996706           -76.9%    5539212 ±  4%  numa-vmstat.node0.numa_hit
  23897500           -77.3%    5427399 ±  5%  numa-vmstat.node0.numa_local
   9935480 ±  3%     -48.6%    5104083 ±  2%  numa-vmstat.node0.numa_miss
  10033238 ±  3%     -48.0%    5215298 ±  3%  numa-vmstat.node0.numa_other
   1470383 ± 20%     -82.6%     255546 ± 73%  numa-vmstat.node0.workingset_nodereclaim
  10422599 ±  4%     -60.6%    4107508 ±  5%  numa-vmstat.node1.numa_foreign
  23903980 ±  2%     -77.3%    5425155 ±  3%  numa-vmstat.node1.numa_hit
  23818888 ±  2%     -77.6%    5336306 ±  3%  numa-vmstat.node1.numa_local
   9568102 ±  3%     -62.3%    3606134 ±  2%  numa-vmstat.node1.numa_miss
   9650828 ±  3%     -61.7%    3694897 ±  2%  numa-vmstat.node1.numa_other
   1342994 ±  6%     +14.2%    1533478 ±  9%  numa-vmstat.node2.nr_free_pages_blocks
    175084 ±  7%     +19.0%     208437 ± 10%  numa-vmstat.node2.nr_slab_reclaimable
  10157128 ±  2%     -58.5%    4212315 ±  3%  numa-vmstat.node2.numa_foreign
  23367487           -76.3%    5530880 ±  3%  numa-vmstat.node2.numa_hit
  23244424           -76.6%    5433084 ±  3%  numa-vmstat.node2.numa_local
   9655573 ±  4%     -59.5%    3909187 ±  3%  numa-vmstat.node2.numa_miss
   9778660 ±  4%     -59.0%    4007790 ±  2%  numa-vmstat.node2.numa_other
   9548474 ±  4%     -51.1%    4669743 ±  4%  numa-vmstat.node3.numa_foreign
  24615201 ±  2%     -76.2%    5866947 ±  3%  numa-vmstat.node3.numa_hit
  24517303 ±  2%     -76.5%    5765459 ±  3%  numa-vmstat.node3.numa_local
  10757630 ±  2%     -65.6%    3696067 ±  3%  numa-vmstat.node3.numa_miss
  10851465           -65.0%    3796917 ±  2%  numa-vmstat.node3.numa_other




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


