Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79920D277C4
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 23:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C688D6B0005; Fri,  9 Jan 2026 18:15:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1EED6B0089; Fri,  9 Jan 2026 18:15:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA25C6B008A; Fri,  9 Jan 2026 18:15:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 978A46B0005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 18:15:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 14652D15E7
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:15:59 +0000 (UTC)
X-FDA: 84313985238.27.3A9A3BC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf08.hostedemail.com (Postfix) with ESMTP id D1E6C160003
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:15:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FDVgSSpe;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf08.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768000555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ACtcIHe8mbC83z+hk4E0VIMT2Z3zpiYi4NKopqFJxc=;
	b=6jRxsafQQJxKC3hhq/pSX6QhwABv9KcBMFxv485saKjq+UYQmfTBrW8oRJ5Jpo+WGUT2OU
	TPquUcz1SKRHmZsQPlNdhEUBpUvCBoKSJQu/IbRgfHPImvrE4eS9TYe4aitm5FcJ7AeLcn
	T1usT8onz975oxTg4lBSr+R+4oZOeDk=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FDVgSSpe;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf08.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768000555; a=rsa-sha256;
	cv=fail;
	b=rWtekoSTOjRJ/wBfPAfLq5oI7OV8ocnN8aKnymmgTCDaWwwRM0DFj+OJg78n1SBPfdL/Kg
	/XgmnLX4qDZQeYhjFP2j1fVP9BBXHEhWmFDk/OqQdrERaC8/GARJEeCyIcjbhkZG5m3bvW
	gwqt0WCwUBwy0GyKTDFoiCEW428V7Q0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768000555; x=1799536555;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=J+iMj+OlwjqmMckD4ATr6X+UvgxhzAC3730+f60MtcA=;
  b=FDVgSSpeFFkGTr0JT5CWKIQDdaIPWFG0gGwn1v1/qbFheVm2uGVbvieU
   zVEqh6bNRf1AkKp7UJo9rpEiLGYJFa+W3ltoo/j94xZYXb4vbdoZoAvCm
   se2Cc0CQY1hMxbpbusvfINm9lwqO0x+ylxwfwhyRJ2MZaa6z2MdZNtyoL
   I+f+UPLb16YNMhZMPosHsuaArfxSJPSPa5YG384FKDBJVznupd7qwLPj9
   dsczHw/pzY6CmIEdKkx0UZcaP5pZOtFERcQPW663LHNr+YJulEC7wHPM2
   EgWcC2DnDXibfbz0APO1RqdVeA6UvLGcoka3+I7W69Y5JzxyeFaqHvfGB
   w==;
X-CSE-ConnectionGUID: FCpw6lnSSJel344OAg0YMg==
X-CSE-MsgGUID: aj1XdBXEQiKLdSzyduTfkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="86802254"
X-IronPort-AV: E=Sophos;i="6.21,215,1763452800"; 
   d="scan'208";a="86802254"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 15:15:54 -0800
X-CSE-ConnectionGUID: M/SjZXaDSuC/ZPgbYyzrag==
X-CSE-MsgGUID: xONNpD+xT4mS4iSy+lcaqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,215,1763452800"; 
   d="scan'208";a="241088243"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 15:15:51 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 15:15:50 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 9 Jan 2026 15:15:50 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.37) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 15:15:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bY1seUkRkU6V+Y3N/i/yJEoXiKP5UltZvstE4VoMyj0O/QV7qQYsUmbsniLP3he9KtS16VjeyoDkfwSMvD2VachHJg0N8M1GPmI3XfNrbQmX8UC5++pzoii1qojaAF2yAaZgLVVK04zdbejpGOlEv4Zi+WICjJdknJbZjBI31y8lSRaBJM6OugI4EaF7oxinMBYag4LqWjCQWwH7bg+z9crGdFMgiwHzyGH/BAcxN6GcFNbi8yiqIcAcKmTeeww1+eBZXsppubgbmPZeHmwKmCtV99X8OLPov5PSEjutZlXwXK5h8bqfu+dLFYZsdKIrjR3vUIcd8iSTgB5Ne8624Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ACtcIHe8mbC83z+hk4E0VIMT2Z3zpiYi4NKopqFJxc=;
 b=jrd1E/05rmhVIwm3uWc/IXcvP4cVPi36B6kQStok4iebXZKaigruNtuQTSNQ/huQiM/qRzJxbGFc+Z2KEfhBmcpGN9cRmbAutziQafjTxF2YUyfHXLFFgVNfnnhydh9jquRItpILW351l7zD/qMtmsAN4ShL0WK/gpaoVnDu2JImeotrkdAyI0UkWM8l6jlP/ShsBVS70LmQoCPcLFFrvzho7bQRwkrj5Jg0m4UaGv5ArOFOj8X9bOLFY4W3jUjyuXP499bp99tfv4EbgmP5UcFllE0sFAX856OJRCACw61lG4/4mQbNpyz/tmeRTOKnLmrMzcLHlvXA/T5hx+wlvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SN7PR11MB6751.namprd11.prod.outlook.com (2603:10b6:806:265::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 23:15:47 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9456.015; Fri, 9 Jan 2026
 23:15:47 +0000
Date: Fri, 9 Jan 2026 15:15:44 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Balbir Singh <balbirs@nvidia.com>
CC: Zi Yan <ziy@nvidia.com>, Mika =?iso-8859-1?Q?Penttil=E4?=
	<mpenttil@redhat.com>, Francois Dugast <francois.dugast@intel.com>,
	<intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	"Alistair Popple" <apopple@nvidia.com>, David Hildenbrand <david@kernel.org>,
	"Oscar Salvador" <osalvador@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/7] mm: Split device-private and coherent folios
 before freeing
Message-ID: <aWGMIAKMn1Azi67y@lstrano-desk.jf.intel.com>
References: <D9ED5F01-E758-4A89-87F2-ABFF5197231D@nvidia.com>
 <aWFSGc7MIUqVsilw@lstrano-desk.jf.intel.com>
 <12A9DCBB-0B59-4D63-9BA8-9F99570AFA80@nvidia.com>
 <aWFe9S2DGwfD2smO@lstrano-desk.jf.intel.com>
 <B8B15539-F97A-4D6B-BF58-FC75397C429F@nvidia.com>
 <4485ba83-a8c7-478f-953f-78d66e84d730@nvidia.com>
 <18E78790-4996-4151-821B-8A1D784A3F7D@nvidia.com>
 <5c9f17ce-7174-4e74-92d7-8249f309f756@nvidia.com>
 <DB92CD30-1C6A-4533-83C8-BE7091F706A9@nvidia.com>
 <ead4661f-5162-40e8-a821-647c05745de0@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ead4661f-5162-40e8-a821-647c05745de0@nvidia.com>
X-ClientProxiedBy: SJ0PR03CA0067.namprd03.prod.outlook.com
 (2603:10b6:a03:331::12) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SN7PR11MB6751:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e8c359c-795d-4c41-108f-08de4fd505ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RERUc3QwSllscUplaXF6U1g3MFU0TWRLVGk1Z05Vb3NJZ0tucmVtV2M5bW1r?=
 =?utf-8?B?c2h1RGhZQlUxL0UrbTAwMHp1K01vTmJLZDdzK3Q5ZGk5TGNUQ1p2enFaNXZk?=
 =?utf-8?B?U1Y4dHNKVmFLOS83TnRpalAzQnJLSGorN3ZiYXc5U1ZUTnoxK2J3TUw2Q2xG?=
 =?utf-8?B?MURTM1lWRWpUd3I2Nk5ndU1nTmtWdmdCRTFBOUZqZ1dsZDM0TVpjVElNNzZQ?=
 =?utf-8?B?OHV5UTd0Q0Z6Vzc4cHM3QUN5TnlUT1VHQ1VpK3N0TFVUQ2ViWGZmMk1wY3Ex?=
 =?utf-8?B?R0txeUN3TjgxaGRHRExpMk1LTGVXSjYwNWZwc0dNUCtrcHNuWUN3amNHSnJx?=
 =?utf-8?B?NU9IRXB3S0RoK3UrdTFtd3dLVDlTcHIvZkpVVXJRaGxnNHJKZjV1RTVoNXlT?=
 =?utf-8?B?bVBzUjBFbDZzU1ppWFJ0aUNmWFd6OGo1djR2R2U0dElNSElTcUVBS0llQlpp?=
 =?utf-8?B?Nms1V09oM1NOL2o5UzBLRFdvem5NVUo5cy9ObTdhZTVSQzdoSUhPRG9VcjRw?=
 =?utf-8?B?djBaOUhwOWZCeUQ3SE9XWlFwZzFRQnp3ZHYrUFV0cElCdXh1a2JweHRycDhT?=
 =?utf-8?B?QXE3bm5nMTFuWVlHbVYxK2haYkZSWFNnSlUxa2tDN29RWVVKN1p2WkJ4QnFJ?=
 =?utf-8?B?N1ByMmt5NVd3S1JMRUpEb25xVG8zV3E3bWY2RndDbkU3NVRhNXNqR3FJZ0Ft?=
 =?utf-8?B?LzlzZEJ5VE56RnpIL1JUeGprVHU4OTlyV1p3YlQwMVI5Q2RyUmFhSzIzdExp?=
 =?utf-8?B?T256TGFjQVJZb1FlTWZoMDFTM3NneWRMV0h3R2ExcVFuci9vb3MrUDBieHJ1?=
 =?utf-8?B?ODZSQnJpcGVnU0ZTNzRxYU9aMDZNZFk1N0FDaEs5K001UHQ4ZmRRZnlLSkk1?=
 =?utf-8?B?bG91Z1JlYVBaREhQNTZSZGZHaFNkdlBUd0JpenBOUlZuekVtblYxb1U2RFY2?=
 =?utf-8?B?VXUzNkJnQ1FPcG9BdWQ4VU1oSkduanlrdGJ0a0dPRUM4K1BIYVVvM0UzOUNZ?=
 =?utf-8?B?NHllUFNmZDlqYXFFMGwrM3d2S1VWVEpQdlVtbHdwWTcwVlRnQjY3bGlxRkhV?=
 =?utf-8?B?VjBZODVTQnZUVW1UcmFqZzdRU2JlTnk5QmZCK1psZzZlYmVhOUJBb3F2aHlS?=
 =?utf-8?B?UmVKQjRZbG1CSXdmMEEwa05NQkNjMys3YWRsZm90MDZBalVESnovVDJTSzBa?=
 =?utf-8?B?ekYrVVRHeGtycHBTMEsrdnZoaUp4QnlmdzJKdWFRdExQUHlEY1ZMQW12YWlk?=
 =?utf-8?B?cHZBd2lmZnpFdUQzT0pBYXJObHdlQkRYektmejVMdHdjcXMyNHVWUWt4dS8z?=
 =?utf-8?B?NlVqdHFRUW0xSzFpYlJxWTFhY00zQ3FGcXZObzIzbk1GUDROQVZjL0ZhendU?=
 =?utf-8?B?UU8zU3ArZGVJd2NwNndrY003WmdyOWFrTXIreStFNEllWTlYNDRtSFFhNHZI?=
 =?utf-8?B?ZHFFR041dG90a0VIblhPajZmaFZVVnBtR2tYcGRpYWhGWFA2QUl3QVFMK2NS?=
 =?utf-8?B?d1prcjd0bGc2L3hPWEpNVUVUSEZEUFRraGttd0pSREQwWEZiV2ZBVHkyMVNq?=
 =?utf-8?B?ZFZkZUpQQjh5b0YvOWFVNFVVT3dTdHVzRGtRTzFOYlRaY1JteUVzeEU4cWtl?=
 =?utf-8?B?WGw4MG83TVoxR3B5anZqZ3o4VnFhZnhaTUQwZGFNZnZuSDR4bTZHMUcwZXFo?=
 =?utf-8?B?Zll6K1BPalN3ZFRwNHlnTlNDUXlJUzR1bndwVWU5eEdGMU9nbk1zeWtZcndW?=
 =?utf-8?B?cC9wT2lTck5PMzhKNC9FOG0vTVZObHE5cGh4R0dvNHhzaXdXN0xLbHF2Nk42?=
 =?utf-8?B?a2NRelZHS2QyQkU5cDlvaFNxOFliYTRhZG9UMWhqRDZaR0xGNWhoMXM3Ukp0?=
 =?utf-8?B?VUVlazR2S3R0TVFPSkU1VUxPMjNzcWh2MUwwMzlwOVJRVXI2ZDZPU1FMQ1R4?=
 =?utf-8?B?bVNhZDl3UEp4NVFFUW42N0tjSlVWQUJpbmJmNGFRWTBQQmFUaHlHMGFsN3I4?=
 =?utf-8?B?L01SR3NzdmVRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vm5ZSnRKTmVIS25hZmdlcGdWNGFyL095RERObW5NdXU0dzNPaFRoRlFBOC9K?=
 =?utf-8?B?UENtcGQyelZuZm9ReW1CTzhXdytIQTdtVWZlbjRCb3d0akZnNjZBdDdaZHZI?=
 =?utf-8?B?OC9GN3ZLdldlWTg5NXE0eWFzcnltd0piQklXc2dFU0Zma2FBS0xwbTNBY2FK?=
 =?utf-8?B?Tk91Z1lwcmVMc2Y1Mjh6UGR4UFpKR1Q0SmUvcnNuQ3BhbXptY0huZTNSWG9w?=
 =?utf-8?B?NjdhbWRmZ3FKbGR3QmluZzhXZklTYnIrWWdwSVBWUVI5b3RXSG9sdm9WTU1y?=
 =?utf-8?B?ajdOSHFGcHg3MVFHTWhNVGhXWDEvV0ZTZWJOandrcTZsbUxROUVSbDluRzh2?=
 =?utf-8?B?VElBMmVFbTc3Rmwyb1hmK0FNNDFocDBmWlVFbCtpQzRGN1N6QXlqbGNzcXRn?=
 =?utf-8?B?RWJQeTROQWhNYkRFT3pWdElCTW5LcUlRZU8reGl3Ylk0QkNhM21GWHZCMldv?=
 =?utf-8?B?Mk1iUVZzRER6YVhMb3NRQmhzSHlBeGFpYVNJSzE4N0R4bkJ2MXZOblB1ZUNi?=
 =?utf-8?B?NFp5ek1RNCs3emtpYWlJbFRWUitvL3liNC8zSzAyQnZPcGxPQWJCc0FHK1Iw?=
 =?utf-8?B?RGxoM3N0d1R4bTIxVUhaL2toTnFtSE5Ldm10blB6SEF5Rk5HOEM4MktHYk1q?=
 =?utf-8?B?K08rWldlbjdRaHNFTUxVYjBCRmhCODdtQ3dpZEUyQ1NQN081N1VtdGs0c0dB?=
 =?utf-8?B?T29RMFVWRVFxLzJxdTVWSHIydjF6TURzMGxOME5VYSs2YkxtRVBOMWw5bmRj?=
 =?utf-8?B?QXVRbWU4MU9ieU1wOGptaEF1STlkOVRFODZkNmIzTC9LZGNmZ0JVYmFybnZV?=
 =?utf-8?B?WVBtV0xDOHJ5dGRISXJaTVAyY2d3dEtkMTBKd0dpb282QzhFWGpZUGxVLzlx?=
 =?utf-8?B?UzRvenRZVkhjMzJiN0hrRTkzNmpZR2hzR2x3S2YyUTRwUkZYOUFPdlNMUkZz?=
 =?utf-8?B?Q1RWR2l5bTV1QnJnT0NjaGlsd0E4Y1ZPZlJKS0ZLbHI5SHMxUTBpK1RJNmFS?=
 =?utf-8?B?NHJGZStyZFNWY3NNRXAvcVV5VDA5cElTNEVjYmN2MVMwRklKeHZWUnVJS1pv?=
 =?utf-8?B?WVlKTGptVVdaZUxrWTYrWHRwM1JZTEorR3lOdGxNeUk3Vk1kem9sQmVqVjZn?=
 =?utf-8?B?QUNtZ0RVRmNFS3Q5TzRIK1g2VjFnTGpQMW5mTkRCMC9iSHNmN1l6eVJHNEgy?=
 =?utf-8?B?UkpqRG95R05TOTA4TUVsQ0ZqYkF1d2V0NlhvRzZuK0FLczRJMFY4YXlCZHlW?=
 =?utf-8?B?M1VvK3pqRVlodWlDcVNsTzM1NzZJeDdYekZWaTJWQTlJZ2NwR3VWRHpQK2I4?=
 =?utf-8?B?dCt3VkFua0FkS3JxeTM1cXArcE5NRHhhMXhBdHAwanZkNFI4WkxZNzJLWXpB?=
 =?utf-8?B?WVVVWDlTL3l5K24rQ29WK0ZBcXFqR1l1cTU3ZmgxbnJIaWZNaUZNMXFFUWM4?=
 =?utf-8?B?QjlJZTNabFp0aVZVNlcwTXl0R04yYWxjWVhkR09MTTIzWE1Rbnc5Y2V6YlVx?=
 =?utf-8?B?UEo2RTZCL0lESVFmR1NTem5NakxSNmw3clJSOEdZVXBHdGR5QzJEUGpZTjVk?=
 =?utf-8?B?OFU0dWlOL3NJZmRHeW12RFRkTDlvUUdKdEtMNU9IbG1HeFJYMWpLZXF2RTB6?=
 =?utf-8?B?N1RKV3MyTHR5dEt4V0lpL2xuT2NIbDdQcmFEbHBRYW1sZ2VPMmthbFgvZVht?=
 =?utf-8?B?WDVCbHFmMVNIQmlyc1YyOTZ2bDhBWTBJdVlsKzhCbGU0Q2F0dmZwVml5M3pO?=
 =?utf-8?B?WjgyTEZLeWhXU2NhUDJHMWwxRTl2Smh0WHNZUDRCZzhXYitNVlZRa1kxekha?=
 =?utf-8?B?ZmhRZmJEQzZuZVl5NytMS05JU3oyRWFFRzRTZWNLNkxmaFBFZU1YTkUzcFZF?=
 =?utf-8?B?aEl1RnlPNWZsUC95NHp4dGJMVm9rYzZ4UmE0MlpSb0JlQitadUp6TFdiNlBK?=
 =?utf-8?B?TjZCZ1hhTVFQc3RFOXBBWlZIZ055U1h5T3AzT2Y0Y1EvV3JZMWtTZjI3dEJI?=
 =?utf-8?B?dTEvbmRsdHo3d0tENFVyS3VpQ0k4aXdaMG5oOGh6Y2gyNUVUVERKSW82ckFu?=
 =?utf-8?B?aXpmTVhNWWlXeElPOEpVRkFIaTRYdHF3WHRMenAxWWhjS0RnaDFWNG5MNFZj?=
 =?utf-8?B?UENTU3dnRndpdi9kQ1hUZjZ6RVNQZUE4MUdwdVZwUU9PSlBJdEQ3UW9Pc0pC?=
 =?utf-8?B?OU1JUUFkOFlhaEFWbDFzOEdFVGFvbDc1SWE1emhNWmRrMDdBRWU4b1orNzdZ?=
 =?utf-8?B?RGZoMFg5WlI4WHVwV1ZjdUFwOWtxckZiRWhuMU1QZmtTV3NlZHJmdHhSSmho?=
 =?utf-8?B?QWRQcUlWMFNxdHlGN2k2MUEybHc0TFpjNW9IdVNucm5NazN0cDdPVUh0dWhs?=
 =?utf-8?Q?ZM6lggFWPfYiYhls=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e8c359c-795d-4c41-108f-08de4fd505ae
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 23:15:47.6680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BUc8RzyhR0FOf+RF+3wfBiD1mwy6nOE5kyWoChjJtI/o3u0PWogeI2tNV2MQJQlBDDX/8l5qpIMw3QaGiT9/Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6751
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Stat-Signature: t8p7yxw81qp91o1ro7adzmsgf7gficke
X-Rspamd-Queue-Id: D1E6C160003
X-Rspamd-Server: rspam04
X-HE-Tag: 1768000554-420643
X-HE-Meta: U2FsdGVkX1892fZgQNIx+OfWQNM6XL5YVrlfCfxREUGOBY5ZoyBAzMxUs6518WkzsOtQ8+rc0Q42LTjxHt7Pt2Iy+Lnz5OogQ+Ih8nn8mrlFRXvcnaOtHdnGZUuIOMxDTunRH+sA5EuAs+BGS8v+iLdfayj6Zs6eOw0R+jPfEwkLV3sWBM3hHHSrUvOq2wr5woCLmtu2yo7pGohT7O6yWroHIpCmUl8upfkv9aRzIc6zb8abj8PIjYw7FTbvqibeWo3Ss+Rj8IMt0Z1diiKXUzzvudT0+9Hw0k0cLpiB3l81aQisFYEr7eLhWhKBmqAE8tLh09QJCzbGTzi7G6OlNRYlETqo6Tlh9O+rNmcb87LaT7/RsFLulhp3yJRG0u9hrDG7TlW4zVSOY85kvCAev+ug6bwZXvHXDvIZRGG4OUcCAONyUTnuDkAHdegT9lNwh/c7psQ62pQsD0AcEOx6+wv29oANhmGXjfvJnfG8HZ1KQbKa0VbMuA0Bv/WPykhxzWnhAYEb8B4q19AaoY4ZsLMQi57IBOeTaK9MgHmDJ4nlTwLKQjQZz+KcD4JDpbZUgwRTCAF+dF49B3vWQOv0rJd2KiXvNZPZSrbwpkSUBzKL/kOzWy/Z93z+7Ts/XWkNLqTbTTmjQnIlbKovVHv+gm9nPVofxdiuV5bw9ZOVr7aO5nDVtqzRKPn7uWqEjXVah96zCDV3Iu2PZdy0zN/oi71YYGWPUvQBiOKTgD8geflfyLG+SxXq2S+m0tbi/hnr3rXqhKiqh0xHY++QhahWSW08upTDfHEn2D3B6z2UpQhXPOZP1RckGf9p7a+mC7NDakBUEPnKgrfJRMu3LrSL68FSqE9rvtzRoVuXj4Nwbhq7YyBipEFj87Je8E4wMeFgQ6hmXWolV9xCEf68CmwPsHaoQ4J0f4EKGDipCTtIV8N4nLyXgY46XXOSHYmO59C4qcdj9UB+e+tStAfC+Lw
 esxvl86z
 xmj3IFEc9aCnLbSxNkS0DSRYcMtgsKZA1b8xd5iYMIfjXKDZBlOO1KkeP5ymoNmIwuJrUXj2YP/fTxTM0Oc9TQlqm9SiGmWydgqDfpZytn8r84o0L/Kb2Hn9XgAPpMh+od+iK9QzPy58+cxo5HtpvMnmAhB4sB85adqgyZ2qswa4skZ7xfcMaUzWBR9h3baUChu4Qh3qRoTDFze8LzxUqtRkMmh1pUmwcknW8FUhPywTdBjndWWK9SNB4G0OrVYeygO5MtEyxMQJlzzO+G/7Hf8rI4R7YMsQN0LyGtFlnMugjeFbbPB1HFY3Djytbthg6IKqlGAIaJWZhdrKzO0u3B3Y73fEI2D9Wt9DBsncqrn6XaVLB5ptTeE6avKz/ZDPkQwuv1bhZ7FZSyf5QEiL/P0qJPb2f03WgzxFUu//AM7h4499qmeRINcKtyag1ulq9zNUpj0H1SAgWudrTW+WUTDjQjQFHBDAKBM0bWWXoZh3y9iQD+ucKDVy7MZRoO4M/a+LCrZ5gqI1B0yfEUl6O6UVuCx/Sze3Sy/ikNy1VV0xzL5+PE+lzmCNHv7/06vs301qcIKuRXYEqqMIO7VjXft9q8rNcA7nQ9M/zW6SIgkZIDrbiAoOdjfMrxYgX4dYNVMypIOpAmvdk1aJXiH6a91yUyF1nVnftgHNxGXyTGZJvmVCybvMmY8nfXa4qU75Kmy4l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 10, 2026 at 09:36:04AM +1100, Balbir Singh wrote:
> On 1/10/26 08:14, Zi Yan wrote:
> > On 9 Jan 2026, at 17:11, Balbir Singh wrote:
> > 
> >> On 1/10/26 07:43, Zi Yan wrote:
> >>> On 9 Jan 2026, at 16:34, Balbir Singh wrote:
> >>>
> >>>> On 1/10/26 06:15, Zi Yan wrote:
> >>>>> On 9 Jan 2026, at 15:03, Matthew Brost wrote:
> >>>>>
> >>>>>> On Fri, Jan 09, 2026 at 02:23:49PM -0500, Zi Yan wrote:
> >>>>>>> On 9 Jan 2026, at 14:08, Matthew Brost wrote:
> >>>>>>>
> >>>>>>>> On Fri, Jan 09, 2026 at 01:53:33PM -0500, Zi Yan wrote:
> >>>>>>>>> On 9 Jan 2026, at 13:26, Matthew Brost wrote:
> >>>>>>>>>
> >>>>>>>>>> On Fri, Jan 09, 2026 at 12:28:22PM -0500, Zi Yan wrote:
> >>>>>>>>>>> On 9 Jan 2026, at 6:09, Mika Penttilä wrote:
> >>>>>>>>>>>
> >>>>>>>>>>>> Hi,
> >>>>>>>>>>>>
> >>>>>>>>>>>> On 1/9/26 10:54, Francois Dugast wrote:
> >>>>>>>>>>>>
> >>>>>>>>>>>>> From: Matthew Brost <matthew.brost@intel.com>
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> Split device-private and coherent folios into individual pages before
> >>>>>>>>>>>>> freeing so that any order folio can be formed upon the next use of the
> >>>>>>>>>>>>> pages.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> Cc: Balbir Singh <balbirs@nvidia.com>
> >>>>>>>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
> >>>>>>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
> >>>>>>>>>>>>> Cc: David Hildenbrand <david@kernel.org>
> >>>>>>>>>>>>> Cc: Oscar Salvador <osalvador@suse.de>
> >>>>>>>>>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
> >>>>>>>>>>>>> Cc: linux-mm@kvack.org
> >>>>>>>>>>>>> Cc: linux-cxl@vger.kernel.org
> >>>>>>>>>>>>> Cc: linux-kernel@vger.kernel.org
> >>>>>>>>>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> >>>>>>>>>>>>> Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> >>>>>>>>>>>>> ---
> >>>>>>>>>>>>>  mm/memremap.c | 2 ++
> >>>>>>>>>>>>>  1 file changed, 2 insertions(+)
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> diff --git a/mm/memremap.c b/mm/memremap.c
> >>>>>>>>>>>>> index 63c6ab4fdf08..7289cdd6862f 100644
> >>>>>>>>>>>>> --- a/mm/memremap.c
> >>>>>>>>>>>>> +++ b/mm/memremap.c
> >>>>>>>>>>>>> @@ -453,6 +453,8 @@ void free_zone_device_folio(struct folio *folio)
> >>>>>>>>>>>>>  	case MEMORY_DEVICE_COHERENT:
> >>>>>>>>>>>>>  		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
> >>>>>>>>>>>>>  			break;
> >>>>>>>>>>>>> +
> >>>>>>>>>>>>> +		folio_split_unref(folio);
> >>>>>>>>>>>>>  		pgmap->ops->folio_free(folio);
> >>>>>>>>>>>>>  		percpu_ref_put_many(&folio->pgmap->ref, nr);
> >>>>>>>>>>>>>  		break;
> >>>>>>>>>>>>
> >>>>>>>>>>>> This breaks folio_free implementations like nouveau_dmem_folio_free
> >>>>>>>>>>>> which checks the folio order and act upon that.
> >>>>>>>>>>>> Maybe add an order parameter to folio_free or let the driver handle the split?
> >>>>>>>>>>
> >>>>>>>>>> 'let the driver handle the split?' - I had consisder this as an option.
> >>>>>>>>>>
> >>>>>>>>>>>
> >>>>>>>>>>> Passing an order parameter might be better to avoid exposing core MM internals
> >>>>>>>>>>> by asking drivers to undo compound pages.
> >>>>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>> It looks like Nouveau tracks free folios and free pages—something Xe’s
> >>>>>>>>>> device memory allocator (DRM Buddy) cannot do. I guess this answers my
> >>>>>>>>>> earlier question of how Nouveau avoids hitting the same bug as Xe / GPU
> >>>>>>>>>> SVM with respect to reusing folios. It appears Nouveau prefers not to
> >>>>>>>>>> split the folio, so I’m leaning toward moving this call into the
> >>>>>>>>>> driver’s folio_free function.
> >>>>>>>>>
> >>>>>>>>> No, that creates asymmetric page handling and is error prone.
> >>>>>>>>>
> >>>>>>>>
> >>>>>>>> I agree it is asymmetric and symmetric is likely better.
> >>>>>>>>
> >>>>>>>>> In addition, looking at nouveau’s implementation in
> >>>>>>>>> nouveau_dmem_page_alloc_locked(), it gets a folio from drm->dmem->free_folios,
> >>>>>>>>> which is never split, and passes it to zone_device_folio_init(). This
> >>>>>>>>> is wrong, since if the folio is large, it will go through prep_compound_page()
> >>>>>>>>> again. The bug has not manifested because there is only order-9 large folios.
> >>>>>>>>> Once mTHP support is added, how is nouveau going to allocate a order-4 folio
> >>>>>>>>> from a free order-9 folio? Maintain a per-order free folio list and
> >>>>>>>>> reimplement a buddy allocator? Nevertheless, nouveau’s implementation
> >>>>>>>>
> >>>>>>>> The way Nouveau handles memory allocations here looks wrong to me—it
> >>>>>>>> should probably use DRM Buddy and convert a block buddy to pages rather
> >>>>>>>> than tracking a free folio list and free page list. But this is not my
> >>>>>>>> driver.
> >>>>>>>>
> >>>>>>>>> is wrong by calling prep_compound_page() on a folio (already compound page).
> >>>>>>>>>
> >>>>>>>>
> >>>>>>>> I don’t disagree that this implementation is questionable.
> >>>>>>>>
> >>>>>>>> So what’s the suggestion here—add folio order to folio_free just to
> >>>>>>>> accommodate Nouveau’s rather odd memory allocation algorithm? That
> >>>>>>>> doesn’t seem right to me either.
> >>>>>>>
> >>>>>>> Splitting the folio in free_zone_device_folio() and passing folio order
> >>>>>>> to folio_free() make sense to me, since after the split, the folio passed
> >>>>>>
> >>>>>> If this is concensous / direction - I can do this but a tree wide
> >>>>>> change.
> >>>>>>
> >>>>>> I do have another question for everyone here - do we think this spliting
> >>>>>> implementation should be considered a Fixes so this can go into 6.19?
> >>>>>
> >>>>> IMHO, this should be a fix, since it is wrong to call prep_compound_page()
> >>>>> on a large folio. IIUC this seems to only affect nouveau now, I will let
> >>>>> them to decide.
> >>>>>
> >>>>
> >>>> Agreed, free_zone_device_folio() needs to split the folio on put.
> >>>>
> >>>>
> >>>>>>
> >>>>>>> to folio_free() contains no order information, but just the used-to-be
> >>>>>>> head page and the remaining 511 pages are free. How does Intel Xe driver
> >>>>>>> handle it without knowing folio order?
> >>>>>>>
> >>>>>>
> >>>>>> It’s a bit convoluted, but folio/page->zone_device_data points to a
> >>>>>> reference-counted object in GPU SVM. When the object’s reference count
> >>>>>> drops to zero, we callback into the driver layer to release the memory.
> >>>>>> In Xe, this is a TTM BO that resolves to a DRM Buddy allocation, which
> >>>>>> is then released. If it’s not clear, our original allocation size
> >>>>>> determines the granularity at which we free the backing store.
> >>>>>>
> >>>>>>> Do we really need the order info in ->folio_free() if the folio is split
> >>>>>>> in free_zone_device_folio()? free_zone_device_folio() should just call
> >>>>>>> ->folio_free() 2^order times to free individual page.
> >>>>>>>
> >>>>>>
> >>>>>> No. If it’s a higher-order folio—let’s say a 2MB folio—we have one
> >>>>>> reference to our GPU SVM object, so we can free the backing in a single
> >>>>>> ->folio_free call.
> >>>>>>
> >>>>>> Now, if that folio gets split at some point into 4KB pages, then we’d
> >>>>>> have 512 references to this object set up in the ->folio_split calls.
> >>>>>> We’d then expect 512 ->folio_free() calls. Same case here: if, for
> >>>>>> whatever reason, we can’t create a 2MB device page during a 2MB
> >>>>>> migration and need to create 512 4KB pages so we'd have 512 references
> >>>>>> to our GPU SVM object.
> >>>>>
> >>>>
> >>>> I still don't follow why the folio_order does not capture the order of the folio.
> >>>> If the folio is split, we should now have 512 split folios for THP
> >>>
> >>> folio_order() should return 0 after the folio is split.
> >>>
> >>> In terms of the number of after-split folios, it is 512 for current code base
> >>> since THP is only 2MB in zone devices, but not future proof if mTHP support
> >>> is added. It also causes confusion in core MM, where folio can have
> >>> all kinds of orders.
> >>>
> >>>
> >>
> >> I see that folio_split_unref() to see that there is no driver
> >> callback during the split. Patch 3 controls the order of
> >>
> >> +		folio_split_unref(folio);
> >>  		pgmap->ops->folio_free(folio);
> >>
> >> @Matthew, is there a reason to do the split prior to free? pgmap->ops->folio_free(folio)
> >> shouldn't impact the folio itself, the backing memory can be freed and then the
> >> folio split?
> > 
> > Quote Matthew from [1]:
> > 
> > ... this step must be done before calling folio_free and include a barrier,

Actually, I think it’s fine without a barrier—I confused myself a bit
there. But yes, it must be split before releasing the memory back to the
pool from which it can be reallocated.

> > as the page can be immediately reallocated.
> > 
> > [1] https://lore.kernel.org/all/aV8TuK5255NXd2PS@lstrano-desk.jf.intel.com/
> > 
> 
> Thanks, I am not a TTM/BO expert
> 
> So that leaves us with
> 
> 1. Pass the order to folio_free()
> 2. Consider calling folio_free() callback for each split folio during folio_split_unref(),
>    but that means the driver needs to consolidate all the relevant information
> 
> #1 works, but the information there is stale, in the sense that we are passing in the
> old order information, the order is useful for the driver to know the size of it's
> backing allocation

#1 is my preference here. We don’t need this information in GPU SVM for
Xe, but Nouveau does, and I see a straightforward change in Nouveau.

In this case, “order” means the folio plus the number of pages being
released, with each individual page in an initialized state (i.e., not
compound and with a proper pgmap value, they look the pages output from
memremap_pages, etc...).

I think this interface actually makes sense now that I’ve written it
down. My next revision will implement this along with the renaming
suggestions for s/folio_split_unref/free_zone_device_folio_prepare
agreed upon in patch #1. I’ll also likely mark the relevant core MM
patches wirh fixes tags in my next revision so 6.19 has the correct
folio-splitting behavior - it would be a bit odd to have kernel floating
around with different behavior here.

Let me know if anyone has objections before I move forward with this.

Matt

> #2 should work too, but it means PMD_ORDER frees as opposed to 1
> 
> Balbir

