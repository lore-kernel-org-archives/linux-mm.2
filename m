Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3D13C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 15:04:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82B146B0834; Sun, 16 Aug 2026 11:04:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DBFC6B0835; Sun, 16 Aug 2026 11:04:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A4816B0836; Sun, 16 Aug 2026 11:04:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DF756B0834
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 11:04:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C5AEC1405A2
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 15:04:31 +0000 (UTC)
X-FDA: 85107453942.15.ADB086E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf30.hostedemail.com (Postfix) with ESMTP id 941158000C
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 15:04:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GNdN23rD;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf30.hostedemail.com: domain of himal.prasad.ghimiray@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=himal.prasad.ghimiray@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786892668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MgoiTqLSmuPuQaSwT8viA9jFigFV26MHK13gzYRgYdI=;
	b=Qsesg0T2IVC7LLiXKkUm7LtP8QVwQtbRG034teyBWXDdHpREYVCPnelXyL2Ykw/sUT9iMk
	blMktm0ib016+uyEY4gGPgcxt13fCtkZJpDvq02y58WSITBX7S/uXQfbQ/1PCLmnqHj8pd
	jD8/A9dPKvbuenX3S4w3AigRh3YiZwY=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GNdN23rD;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf30.hostedemail.com: domain of himal.prasad.ghimiray@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=himal.prasad.ghimiray@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1786892668;
	b=XnVlSU+m1PNYoTXu2B4KvOyzHCYV+FmmGxKQG69P3tMw/8Q0zK4clhqmWX5gSLDPeld3VF
	QvvP4fl8RtFEXn3j2S6R/jJj74g024M5xJlVDnAJZEwaE6V1TC+gKx0IycsPhnMiwXz9Dv
	Ptntwh24u2HWkr+Ill4FzCO9G7aB6fQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786892667; x=1818428667;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wMF1CVn10o8VhdSBV++w0DB3yMAtKPrNZCNDiQx4ooM=;
  b=GNdN23rDLKrsmIywmbVOOoB2B0r8CpzDXI/wvH4iSv9kWqoqtsXK3wnS
   4Ko8lQdvDb3cPSDTzM62jX6yC0hl+0dgrl+jHYLVAXyVtA3zEsyjEMe5p
   0rBzmj9ErOaQa8Oq8yUqKgUG1mpdxCP0I3FH3biKqZlqy4/467gPKamg1
   ypi2LddaxHv4sCoGsU/qX3kXkJl3j3wB+jd30xw80P4bEpKAcCsGPj6T3
   EXUK+RG1H/3L6rnrdc0sxwEFv4y/yX/OLBmMcT11pw7DkbkMTeyH31wG/
   qELKNjJ9tesRKuvWMvgda3i3odQ7KfbY/zfnGvBZ8rz0s0eKzlSlack3K
   Q==;
X-CSE-ConnectionGUID: sS0pmkGfSpyadOsFmsicJQ==
X-CSE-MsgGUID: zfxgPLKwRVy6vSISP7y9Ng==
X-IronPort-AV: E=McAfee;i="6800,10657,11877"; a="112932061"
X-IronPort-AV: E=Sophos;i="6.25,227,1779174000"; 
   d="scan'208";a="112932061"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2026 08:04:25 -0700
X-CSE-ConnectionGUID: M33YmcpXQKC+TCE83pc8dg==
X-CSE-MsgGUID: ygr7i+oWQxa19HOmzSmDUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,227,1779174000"; 
   d="scan'208";a="268535707"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2026 08:04:25 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 16 Aug 2026 08:04:24 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Sun, 16 Aug 2026 08:04:24 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.55) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 16 Aug 2026 08:04:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UF/VyoyODSmaIrWEskqI4ipqdHl8y69hm9q1TjoQdlGXoB9YXuLMXkjMPO/5poZppZTxWWsPNbqIn13P6dCNn9T3zipNVov+xc8gHGmA/CLDHxrGmfTtU9x5YvFeFgZm804lMsJ2nBBPX9DsBiJeRO25An7OANBM1utnEH4L5PlUqhZLDrY+ZvDAUuhGSSHK1DDpDaUoQcem0p7FBD/sxdocz5qKorNQ7HugZkgfkdbIcfm3hfJ7hX1GVyscTffzUnCnlwehAczOQ6KaKJ64EEcef6z3ReLr4f1PugOl16YaRBKcVc+sR9yGxTebvGfZzbsWce/Im7Ia57tvIiy5mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MgoiTqLSmuPuQaSwT8viA9jFigFV26MHK13gzYRgYdI=;
 b=juW26+ZnvtTk6Xq0BkaFb4vUGnqwbKlH+ytu95Af67d2dAzwyEHM4bQyrZqngWRvKEtNfAhNAYqRY2+TX+WqaUtxkPinvG//FezdwQRGQYQEzrx7LK7CX4GghJiLPHEc6cNJ/swz0eNZWjWKxU3qKAD6ra5AVqvLrZSwa47BtWCsXcNMNV04lm1SfD8CTcdrHHREwoLmenrWjAyAxFHZuCdgQwnIu1/O4gXLVamIFH4Sf044JfB2HoUTm3HWVXYg3E80x0OtWS2nmhdIQ2/886cEmHhChppbX4PG+s40Yttk90Vsp7ch9qa+obPZzaaLIL5cL9di3GH1e+cRayHz8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS4PPF691668CDD.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::2a) by DM3PPF74831EF4B.namprd11.prod.outlook.com
 (2603:10b6:f:fc00::f2e) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Sun, 16 Aug
 2026 15:04:21 +0000
Received: from DS4PPF691668CDD.namprd11.prod.outlook.com
 ([fe80::5a5c:9c7a:cd1d:d687]) by DS4PPF691668CDD.namprd11.prod.outlook.com
 ([fe80::5a5c:9c7a:cd1d:d687%6]) with mapi id 15.21.0315.016; Sun, 16 Aug 2026
 15:04:21 +0000
Message-ID: <9e986d7c-d561-4a63-8b14-6380ac289db5@intel.com>
Date: Sun, 16 Aug 2026 20:34:06 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] drm/pagemap: dma-unmap pages before handling
 migration errors
To: Matthew Brost <matthew.brost@intel.com>, <intel-xe@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
CC: Sashiko <sashiko-bot@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, "Balbir
 Singh" <balbirs@nvidia.com>, Maarten Lankhorst
	<maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>, =?UTF-8?Q?Thomas_Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Francois Dugast
	<francois.dugast@intel.com>, <stable@vger.kernel.org>
References: <20260805231041.3791771-1-matthew.brost@intel.com>
 <20260805231041.3791771-5-matthew.brost@intel.com>
Content-Language: en-US
From: "Ghimiray, Himal Prasad" <himal.prasad.ghimiray@intel.com>
In-Reply-To: <20260805231041.3791771-5-matthew.brost@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0P287CA0003.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:d9::20) To DS4PPF691668CDD.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::2a)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF691668CDD:EE_|DM3PPF74831EF4B:EE_
X-MS-Office365-Filtering-Correlation-Id: 64f7cbc1-a7b4-4ca7-e471-08defba7a6ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|23010399003|376014|366016|1800799024|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: sycKyIegXa5EzPuP5Fa3RYet4m/dm1KzieNSqZtt2WP8UHW8BaoXF5+XuT1cRIKB2nDKR6IN3upf90UrpMXI1TQLJEoE8cS66icy7xZFtN96TLHZJjbJQ28qm3XDOg9GgzIQXkwkUo46HxcbB5LU2jFqqN8rmxrkfZ2zNhdFWZhjZ32mfGfkYvmVZ0ghaLFU2xyVgdfZ4sNFk3LyjT8wznq6VrBzOJaqgJvcFyjypzfkBWGt1W3Y6t5zxNJmKSfhw0R7OGX4VO74PWVUoX8PqI98XLLlYVoUhmYKruKaX3736y1ywC1qnN+L7OrqlbPU0t0ThEsW4Euu9DzwgMtg/yjdZLBvsbID+t9+rPB+FEcvfriykdkNN6ws4niG4xgiVARGZvyM6MjEBw0ZrHvXywqCwecmID7egmc+QBQERaQi8h2z6EUzu+9KEQWfgLEWgT5NbxlFuxrFk6eVPQEKMlMvAN4/hiXD+Qc6EmFs15R9BHFoJUVbP2y8IX8SsFhjAnvr86KIet872EnlbPNRxPsl51Rq9IxHzlbvxErr8skGOgsSnDsbBOskJXEj/pG+xArpqrz/SM6UASBs6gYKw34t3CFUl8Z6DBI7NgfADdVGwm/Uf7gcZJkoyFMDhk6utm8h1y2LrjpCPD91KBMWgY8QgHZBjMaZvndiVhgkYdc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF691668CDD.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(366016)(1800799024)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODFObDduVkV6UWphSUQvejN1c00zQmo5UldQclpoOGhpSDk3U2lYTGdHR2tF?=
 =?utf-8?B?RzBTbW5JQThmRW5rWm4waFJYenRaTkhmUXhVb25vYm1kd082RWVmSkYvLzNF?=
 =?utf-8?B?SFBYOSs1QzhleEVxazltakRvVGE1S2lGUkh0VlhmbUJva2tlZmEwNlJtMkw2?=
 =?utf-8?B?aTRUTk1HM2ZLTHk0QS9rSTlQOWFncHMvQkxLSHgvQ1RyWHZPMDA2SlVLRlR5?=
 =?utf-8?B?ZFdORHd0czN2NW1NWmFrZG1ONmxPWWRnemg2RTlqbUZJUFAyQVhFaVV6dmJD?=
 =?utf-8?B?cDVaVnVkTGIzUExpZkxzYWlSOVVYYmVQZ2JoVzRMZ2lGZ1IxL0lsZnVwZTZS?=
 =?utf-8?B?Ui9Td0RodzZuQjlrei9jdGZlc241YVBvU1pZcDZ5OUZURlYyM0tGd3lrRzRk?=
 =?utf-8?B?eUp6cmI2RFZqNldVTjVkRUd4d016TDltbzRPeFdVa1FWa2pHcnVZZXhRR2Np?=
 =?utf-8?B?K2hvbGNnNERWQW93ckNUSGgzak1CcW0yeVk2MFlLdEduTUR1Z0drak1iYnlk?=
 =?utf-8?B?RlpGYzJxSUNDa0c2cjlEMEZPY2RTRXlRdnNEcWFocGFKVjBJd3lqL3Uxcjdw?=
 =?utf-8?B?NU8zckorYlgrVHhEakMvL0ZMaEc5bTVEeWQ2V0ZGM1RtQmpteFJnd3ZSVlZ6?=
 =?utf-8?B?WjlQT0JqNmVqblFiUTZOd0o5WjRXSGEvdENDYmVCVHM1WHJjcFVhN1RURDZQ?=
 =?utf-8?B?Zm13R0NJa25mYjFBa3cxUWJ6ZkRNLzVnLzZ4bThRdkZLZzlZcjhQZ1loQjYw?=
 =?utf-8?B?YXVNbVpEVmVNZSsrZGREM3h6ZlJyMEZPc0RHNzNVa2hkRkVWdmM3SzRNbXpT?=
 =?utf-8?B?OVZPYTNLSXBQRm0za3RrUG9peW5WeHVmSUo5aFF4TFhJaUxySkFuZ2dicDhY?=
 =?utf-8?B?ZURpUW5lNnJKczRVQ3Z6U21RVWx5aUw3M2t2R1RVMjFERm5mc3p0YXFFeWpQ?=
 =?utf-8?B?ajZHT204a213SStCVXFEc2l6cm9US3hqWDVKWnZBQ1NqTlg1bVFSUlJhR2o2?=
 =?utf-8?B?WjErZll6Z3ZYaEhBMmV1QjVFQk91NU1TOXorM1BsREVTemVRT1VuLzZYU0tj?=
 =?utf-8?B?MzM3T2gyNVhEOFRrUXJmUUk5NksvM29JaVdUVCtYajVYckhNWklKS3dGQVgy?=
 =?utf-8?B?Mlhpa1JqUDZQL0tXRXMrcWp6NmxmS3NrZlhSS2pnSkVHdXI2T0RUaVU0YmlE?=
 =?utf-8?B?MnFuemVjNTdwQ0lYTy96MmQ3dURxRWJTL1pGbHJobGxMOHlXTjNwMFVEaURS?=
 =?utf-8?B?eTJ0SVlxZ2dPblBFcmFMeUlETXVSMHZjZGloV3ZaUzNkRUp2dEpSRUNFM2lk?=
 =?utf-8?B?bGYweEx3aVI4UnhEV3NtU3J4SzhhU1ZvcTI5Nkp1amFmS0hZNThDM25Fb3ps?=
 =?utf-8?B?cFY0RTRuTHFvbEh6RlhrcUNIU0c1UUpUWjhOVWNYU1l3T0JsWHlGem83RjNT?=
 =?utf-8?B?Wm9iN2loRVYzMzAzRzU2eE5zWktKbmVGYS91ZUIzZEJWbWxnYkVLNFNiY3Q3?=
 =?utf-8?B?RTlHRWNXOHRUNGhyMHRRTzJONGw0MmZldGpEZmJndFErMDI0K0xIZ01CTlRZ?=
 =?utf-8?B?WlBwT0tmM01iYUFndlA1b25IUUV6Q1RETW5DVWgyZmNvTkdScFNmdklidHV1?=
 =?utf-8?B?NnppZmV0RlJhVWp6OFJkT2VRWTRhRExjMHVmMUVDMEpiTHE1TnBHanVlOXg0?=
 =?utf-8?B?OFlCSWlGZjhraFV5S2hEcVdaaG5UKzN1YnZxem4xL0w1RUpiYTYxclNnSHZy?=
 =?utf-8?B?MjM2MTRZMlk0RmtvV1o0clhUUDV1Y0FZMERpeE1HRkM4ZWM0SElCUDdRY1hn?=
 =?utf-8?B?NjUwTVRlR2pyVVUrencvcE1iMXpmbExVcVFEU0lXNXFVUTAwQzhLNnYvQm02?=
 =?utf-8?B?RFFHb2gxbGZFRzdobUUwWURoQlBJMkhiL2I0c1VUV290cXlhb3BoeWF0bFRZ?=
 =?utf-8?B?dlFRQ05kQnphM0xqbldHbktKNExUMkwvbVdacnI3SzVMYWNWNTNGSHBHNGov?=
 =?utf-8?B?anlhUUE2ZEdLNllSb0ptRERObnpWUGNFSzdRWlFVUVJzaDBPOTdzVUpNaVQ2?=
 =?utf-8?B?YnlMcmpRYVk0Q0k2UXNncWdmZ25aZXk3ZlRUQ0tyVVZ4Wlh4NkpZclo2WVVE?=
 =?utf-8?B?K3h0VXJTTUJJRUFLaExiMGM4eUpNb1ovOTZJMzJyTitwNkpnQWJIbkhULy9R?=
 =?utf-8?B?dHpTaFd2TnQ1S3VWSFhyRXVqN28xL1RRNDd3NjQyb296amUxVFZXT2h2Z0Jj?=
 =?utf-8?B?dmJXdm9yRit4MHZhbjBTb1JwT2tlSUUvWmtSVmZPby9GaFE2K3lXREZsMmln?=
 =?utf-8?B?WUNaZ1M1WURFc1VwQWhtaWZCQVRpaTdDTlFkbVNJdDArL1hUWXlTNFBGcWZG?=
 =?utf-8?Q?f+NxFgWIiSnSDxwE=3D?=
X-Exchange-RoutingPolicyChecked: hvwsUJwkNmjyYqQhHJ2gg77pl0BE3wHxu5l9Nc3TCeDfJ2VEHckV0p5rnkc91g/z52UJb9qWeNP4387c5xKYCl3rv1GgYKFPgQBYRpS/rKA1LgY8eNooWQrdJqLKECSDLGwKGLe9li1Sd6k4h29RiJQTeTaxnsFwxN7228rXefJkqrizVScGtqxnds1l1G/7m0Va70kJyMfWQqxkcwUUbyCVwUMBWZvftte08wGpgsAz9rldgN0ha3DqhT1dUPfpnVH0Y6BdAVWLijpXE5lbWhbqqMmeg3NdFIv8CkODw3wNzauubu7JqWov4/5L7qrTSK56gikF4OM/YcNxtz/Iow==
X-MS-Exchange-CrossTenant-Network-Message-Id: 64f7cbc1-a7b4-4ca7-e471-08defba7a6ce
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF691668CDD.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2026 15:04:21.1783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +JctoxGkPP5Ef/oEaAqk04xcm51j18W2ptTwCjEyVMLiORdeEmMgePDD7gF4OjZHaQOXWC0smdMn174o9tXi+O92ntQmkUlEDYIoOO0KqwA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF74831EF4B
X-OriginatorOrg: intel.com
X-Stat-Signature: kmqy83awtosmzk1amja7iwg3wcn8cxo6
X-Rspamd-Queue-Id: 941158000C
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786892667-25136
X-HE-Meta: U2FsdGVkX1/8mElvttSLKGDDu1ciflcZXEwnl9DsUsi3hvzAR+Ogkw6JPqsWhyVYfQV1p4tIp5Lpn+syl4twYMeS9nwjH9Ykn46W/7mNHs4K3+u8g/faOftBeji0ean0XuPIjoAbLI6+Sogai52p/O+cSQTxALqs8oUFt/qGq2ACeWCga9XXrlawPE0C75eFU+tPqsvuMOrzbv2RG6U8GyXx9zzWX1FbfrW2oW3/uSCP2xQgFT/e6zaFInVcm+NcXsQDuRybw5nLHECVT00/MMBBA05Yu5wKgRKH8KAlFSHeN4aJlu2XkGLZg5EELHGw8LCK0gLxuDSN07ATSvERPSi8NaFMnjRwPVvPgPgMyQGyC6PIU92BQJGwdeIpzkbm9JlvA6uWpnPByuhlZ9qA/ZnW+vtVOlM0DW1Uh7KnGjaLJC5sQ3n1zdJh7WpX7RIv7LZ9cZglPMEwBIlCIRlmcNRPRxOop8XjhlkHIxG7yXtfanrGlSgEQ1q0KyxoDZQP9kkkjemCxkmzY0HUiQLRVHGNKT+fMZPwcA/FptfZ7nKnhcQ1I6psngaD6XAf+B/S1JyQsOePE/oWMxD/1891kSRq7CVMtDsOw51MxofssW0g5S6weus0AZYfFhxjIlrRO/iYlqbgjcOSNSnUgEHzW91A8/zCA6vgWixNg/TSiDBnmB0JHS/awouyO9M8we0wZ7Bx7vX696LkZeH3WMCBAsR/5e6M35g2XOV/6VrhKADenRXai4LrOzvSihtNm+6ylfXOprkDZTVAjnNWUkmCnQW+2yG0rhDFxCljxG96BNUGHGcEUYysDHcilxw9ulLYdxYGYYntSJFND7dAfMewJBzF0zSgTMxAsZFfCXSRQGwNIr6u5NsagMOOXqsROVHUumsN7oC+4orv8KCyz+4va78AthtbkfUEESmQwquVHCAsqfPYw95TDOfHogZZuPHn4nZ4EDI9xILsImN+AFL
 GoeKMSL1
 UwvHin99Y4q3de9YH1BkVANnINnTrqdgSjDQZDssltRvMxlGj1P3MW+y8hWXrnEoIRqPU37+LECWrn9Gdkmv5/+IAueDjGQzvV4j070qoJ2xQxlEQ4jZUMf/sirV00Ya/OMfMm1/8NeG4/EyybhIp1HLfSz2ii2phEnwacpejfaqpfhnP14NaSJNtViOmigP704+U/mszr5jspGWt6v7nA+h94srnA/HJte1mXlHlebO/xXg4WxvWtwT39KceU7fO4UDYYxQH8HTMY1D2Kzwz0n8tbmgG13Lt9gkqwabxXZxqzD9KSi6Qr/jD6LU6KaxzwMvHeSN7nZAr73FKUKeck1iAOI/RHGsbOe1YQ9sRJDMo9f16lYgFny1oBeEn5L153D5462GK97t15k86q2+dzmcxrJwOxsplaIyNproDJpGvquOf1P4s0KBWRORuVXAl2eokKW84KgJ7C/2hyEALPTP9Z1PAkU6HN5zNZKSN0j5U8f8tMxTHjtE/s/gZZnysr/uykBQQk+HXN5aMtj7s0r645uShJkK7VW8tsiYFhGPl2CvTQkFU34wA9RKGGU47nkDqqOPbhThATrg+NkI99MYWBPqRYgK6EopD0ZbDbtt53bqzBSjAqlkehKEtu5zdq2GdW9lDOjSTkuguMpLllBzfgt3N2dgOHB9RywfIQE1ot6FPYV3JFnRhGIYNJ53GV158st0OnpQolsmPyTZ0YAAHFK1H0dXfW5AvbEoa49ZuAL7rTkX/hxkvbz48e3uK/Lbju0vhAJDyQOPqusvYzvp7ZSbxE27Gh5VC6PD022++frHpZcIHW1qiEJqNInow4JMrscyk5KBu9lbEbWa/CtuPDe174r3htVxXu/VoQj6hAs381th2dniCIiVm3mtV2oe1RE4fYiobvqbMmOGKOLv8QHkXFyqrkFxWCqNouhaV3mpwWi4Uz1mvv3rkfKJvRocJ4dHYTQdZuWwiD+Vn2oCcRjlR
 Jp89Odqq
 g6pup4FMJ8x9G1QI1hp4POdbXmDfc/bf1njU6nFEuImTqyTZm5l2J0rIx/dYIjNVi62jwL/p0hhIYmSnkvtI47th9uKZYKPXYQ6EZTPKumzuw/SuhRGRiS4E+0EdlDdSmukEpvdVvGg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06-08-2026 04:40, Matthew Brost wrote:
> drm_pagemap_migrate_unmap_pages() relies on the pages array to determine
> which pages require DMA unmapping. However,
> drm_pagemap_migration_unlock_put_pages() clears the array as part of its
> cleanup, leaving drm_pagemap_migrate_unmap_pages() with no valid page
> information if it is called afterward.
> 
> Call drm_pagemap_migrate_unmap_pages() before
> drm_pagemap_migration_unlock_put_pages() so the pages array remains
> valid during DMA unmapping.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Fixes: f86ad0ed620c ("drm/gpusvm, drm/pagemap: Move migration functionality to drm_pagemap")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Nico Pache <nico.pache@linux.dev>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Usama Arif <usama.arif@linux.dev>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> ---
>   drivers/gpu/drm/drm_pagemap.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
> index 892b325fa99b..aef1fcea663d 100644
> --- a/drivers/gpu/drm/drm_pagemap.c
> +++ b/drivers/gpu/drm/drm_pagemap.c
> @@ -1175,12 +1175,12 @@ int drm_pagemap_evict_to_ram(struct drm_pagemap_devmem *devmem_allocation)
>   		goto err_finalize;
>   
>   err_finalize:
> +	drm_pagemap_migrate_unmap_pages(devmem_allocation->dev, pagemap_addr, dst, npages,
> +					DMA_FROM_DEVICE, &state);
>   	if (err)
>   		drm_pagemap_migration_unlock_put_pages(npages, dst);
>   	migrate_device_pages(src, dst, npages);
>   	migrate_device_finalize(src, dst, npages);
> -	drm_pagemap_migrate_unmap_pages(devmem_allocation->dev, pagemap_addr, dst, npages,
> -					DMA_FROM_DEVICE, &state);
>   
>   err_free:
>   	kvfree(buf);
> @@ -1305,14 +1305,14 @@ static int __drm_pagemap_migrate_to_ram(struct vm_area_struct *vas,
>   		goto err_finalize;
>   
>   err_finalize:
> -	if (err)
> -		drm_pagemap_migration_unlock_put_pages(npages, migrate.dst);
> -	migrate_vma_pages(&migrate);
> -	migrate_vma_finalize(&migrate);
>   	if (dev)
>   		drm_pagemap_migrate_unmap_pages(dev, pagemap_addr, migrate.dst,
>   						npages, DMA_FROM_DEVICE,
>   						&state);
> +	if (err)
> +		drm_pagemap_migration_unlock_put_pages(npages, migrate.dst);
> +	migrate_vma_pages(&migrate);
> +	migrate_vma_finalize(&migrate);

LGTM
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>

>   err_free:
>   	kvfree(buf);
>   err_out:


