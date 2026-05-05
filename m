Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7376CD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 18:01:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A7CC6B00A2; Tue,  5 May 2026 14:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F756B00A5; Tue,  5 May 2026 14:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246F26B00A6; Tue,  5 May 2026 14:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1218F6B00A2
	for <linux-mm@kvack.org>; Tue,  5 May 2026 14:01:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1887A0588
	for <linux-mm@kvack.org>; Tue,  5 May 2026 18:01:35 +0000 (UTC)
X-FDA: 84734133750.10.F2532C8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf06.hostedemail.com (Postfix) with ESMTP id 13299180010
	for <linux-mm@kvack.org>; Tue,  5 May 2026 18:01:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HPVjqohY;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778004092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f29UzgsWLFXpbX1nxzpe4lTTFqELS3+sSBHlsjqOCyg=;
	b=Ui/si3zcXvBljb/9G0BSy8fwpk5an3XP0yKI+W4EtGceM7/fKFIwc5Khw6IxhXF7Afwtgd
	ZGU0GSwtJiWvTxjMLug8/+qPEk6yvmJL++wdSaM9lFc5Y+z7AeWxJ+rLaWi93hBSs5EOOo
	I1kKr/flAQnJTMa+INdAdAYBPxQUGNo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778004092; a=rsa-sha256;
	cv=fail;
	b=54gX+PFqV5ff6ecpQov7Z6ESKoJGbILMCQHD3dlGxE/lvHCso0Q5qAla2jAKm0u4k5IphB
	RqVtybBnFghwDGwtDT1UerDyqBqlN9z08bVM9ho58npzaQYpxpT/GAe5Y0WTR2CM92LPOs
	zEogQLoywosjWp5cH8wk7+8UmzmHFdw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HPVjqohY;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778004091; x=1809540091;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=vfFPXlXmlBvtx0t8BHRc4LhjcctynVoztjvrMrAwLRc=;
  b=HPVjqohY60RVoy/I5/hqWUOV9cHArlpJPbElzjGOxd3zWLd49lf/PJrd
   y9nUxAi4oMqVPA/6clgWx9oihNtOcnAZaP08XAXvQ2saBB1UIOMfpm6d5
   W9s6UNRwVg5Ga1PqPQCuIP5ivTCGnkaQdy0cClzV84Nt2PgTgq1s6mcDs
   vwwS/4z1UnbdCqVquFl2UKpTOaGjr20uor8wphBm6A+4jemAIyNqbxr+J
   y5K9aQlx2J7pCRzaDBBdRELOmnLnwc6YW/3lqjuP+v4UO6VWiy/CkOBcr
   abFckcM7w9Njn5JBtgOn8dI8c20T/xYXCHWfxOOGAeLQ5cHpLGRqICdSH
   Q==;
X-CSE-ConnectionGUID: p+ljLEM1QPmbXAR0r29hPw==
X-CSE-MsgGUID: AHvhGEsCToG+fCrYs30nnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11777"; a="78984013"
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="78984013"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 11:01:28 -0700
X-CSE-ConnectionGUID: su1qaolORVi1Z0UhqIACoQ==
X-CSE-MsgGUID: XCj3B8hFSWKyJ5fL+LfFuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="235003281"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 11:01:27 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 5 May 2026 11:01:27 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 5 May 2026 11:01:27 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.49) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 5 May 2026 11:01:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U9A3I9GNMM1HgbZzR+hX29elRR1mFBrHaVfgFXP0+9HqI9ZI4uGUzBn0zm5ShqvebWPFB55A79pavf0D+uJLZdTunJWlgfFtsBjqQRgV4BvvBz7ddziC+X3Zj5aR7lyessM0mqXrix16P2EVkwqiK5mQa3pxEdlngEbJBdrPGWI1PjNs0aZF7qG0X3/Pu1KnLJZQaXJGCiuY5D+V9K91yfo4IKLOwXmIwSL7+m0KGab2+U1BSzcihxnmSS8gIzoDyAw9pvKrBjNI00MzVytLg7/pkur5/+bCNnA3+Lt4P8fTRtuMAiwn0Ob4IAlkl8EqfrwAXQqyp3pfTTwgLf4zag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f29UzgsWLFXpbX1nxzpe4lTTFqELS3+sSBHlsjqOCyg=;
 b=XS0kTYkGtLiJ0/FwD0IejEUaPxFolq4+m3CavoWUHert4oXw/yYxC0Qjmz4Ie+mIF/zIOddZV1FOVPYpPBE7Q0tI+zn4GUL3v2ZtRq8qpm7pCcfKggDT+etFO7PWHQTdpUzyAYFdtvTIxwmt1xAjEIkwvXTV/Y876anOEHEZ0ZJqc+r9bMed5gOTS33lc+v91jZC+5p6ewBvlUFaVq6w4KqiA3DkFZq2pC3EdXCLfGNdcfvjoI6zEb5Uk3UrBTGW30qBOLtR+KiXB5YG5dn4qH5qbI70g37wCwm64uAvXlJW9CeJxBQDa5uqD4es+TUH3U4k6RRW+vd/X/WUuxaFaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by LV8PR11MB8486.namprd11.prod.outlook.com (2603:10b6:408:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 18:01:16 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%7]) with mapi id 15.20.9870.023; Tue, 5 May 2026
 18:01:16 +0000
Date: Tue, 5 May 2026 11:01:13 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>
CC: Alistair Popple <apopple@nvidia.com>, <linux-mm@kvack.org>,
	<dri-devel@lists.freedesktop.org>, <intel-xe@lists.freedesktop.org>,
	<linux-kernel@vger.kernel.org>, David Hildenbrand <david@kernel.org>, "Jason
 Gunthorpe" <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, Balbir
 Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>, Andrew Morton
	<akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v9 0/5] Migrate on fault for device pages
Message-ID: <afowaUffi0JrnADf@gsse-cloud1.jf.intel.com>
References: <20260505051658.2219537-1-mpenttil@redhat.com>
 <afmXIq8VY_vs1GPo@nvdebian.thelocal>
 <ecd81b6b-62ef-4dab-a93e-e65598d64841@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <ecd81b6b-62ef-4dab-a93e-e65598d64841@redhat.com>
X-ClientProxiedBy: SJ0P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::20) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|LV8PR11MB8486:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e261d5d-e3ab-4d5a-055a-08deaad04d72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: XHj+T6VKWSBKVkQB0tOnU4MxI3dQl4yAVwZLTKuJj7Rp5AyZKKXfrOxy8v28+LBtUM3Q13Aj3Mt2IzYvRIAM8lphIXKO2mdJYWmXhGb6zu/9ymzPisymcMtLgMen35KIS4zXet0W6q1SgWot0LpzZ24FwW5nWTfFuHWCREhzg13GMsv/HB/PfCOCkjsyqbOiuX8rgX4m8mYAnpHsWB2bHFMkl7S8nci83FkR2Fl5lLVfrqp2RjzZVyd3WGDos0s/xj8xZZONnlFRz6vZNpnp6324k4RPUgNz6i9nMNSOPDXv+bL3OaQLX/ZakXNcScsuG9jQ3IeB6pUu5cExjWO010SLoihO4IicyGUNne6XJm449jIdVPv3p6ygOsqaKnqNx8Mo3LCsc/TZyPfBbqnbegpVLM/55ciaRCRcRnxy3VWzQPuPyvAEcQ4u8dm/9GyoPpzQLO/XaLD/97fQyWET6JmIs1LgHUgqFiLMCSQt8qKh1PsfGU4smwkPEzAZ0Ljmv1gENdEBmPSrM8whkGiktuxQh71gerMGhMAv59rRx+hBvIlJYCKiFHVfPjdC9rQLZgWb0sIL7YF7Ocvy5fJP8HfY5iUKqoJbCanTV2fmyXT/c76NtP4ha/yXiAB51JZUViPtP6jcVUtNM2p17KwrAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZXhqbnNiRGt6T3hpNDd0Z1oxTUlyaGZRUHhPeGhFVGNLWG4xRVNhVmt6SmpF?=
 =?utf-8?B?VGFGY1FZZFVXcVEzV0krdlc4cnd4UlgzUitVRFJXa1JiaExYY3FDOFByd2d4?=
 =?utf-8?B?amFRR0NheE1LS1RjVFI3bTdMZWd3RG1Tc0tJQjluM3hJdmQvQUY3MWJGZXhr?=
 =?utf-8?B?RVZDY0RzdjdZaWwwOGUzUkR0MGtVajlsaE13TUhWeXB4VmhvanM5S0dCYVVi?=
 =?utf-8?B?YjVKTCthQWJqR3VrNVE2UzZHUHp2b1hkdGk3N2wzcUtLUzg0MXlNN0k1N2J1?=
 =?utf-8?B?Y0djd2VBWmcrV1M4V2VBK1RqMDV2MVRkakVNYktoMEdENGdvWFJmYzYzcW1S?=
 =?utf-8?B?cXF1ak5rajZnOW9SZUxhNkhBa2c3SERVRWdIa2c1TUlzT3V1bEtVdW5tVzk2?=
 =?utf-8?B?eUV5NnN3UnZsRitmWUliZElPTG04dFBYakxHQXNhWmc0TTFpUG55U3hSUHk2?=
 =?utf-8?B?UFV1M0Mzdm5IOUpQUWhYWG1nc1Z3TmoySC9CMi9mT25xTzJDUENVeUM2VXlV?=
 =?utf-8?B?THc1ZjQ1TGp6d0ZLUHdmZm05WEJ2Ym04bDBZc3BVTW5EMnZjdDhlcEhYMkNE?=
 =?utf-8?B?RDVWOVhrbDZ2c0RwMnlHdWREcTArMk5ONUhhRU12cTVQL0ZDOTBYSTVtV2xT?=
 =?utf-8?B?UEtOMitveTZQMDNGeWNoMCtoWU1PWlY5MU9XcnJNNTk3eHdmSHdNOEhDMlRn?=
 =?utf-8?B?eDRvSFVZZHgrWlN5UEVnci9nb0FGTHlHU2FXLzZBbXAzN1hzTnE3a2NvL1lw?=
 =?utf-8?B?MHcvNitXdkt0ckRXS1BzNzZPUGdFV1hNN0k1Tkt5VzQ4bEdzR29NQmRDb01v?=
 =?utf-8?B?RVpMNmtyUGhSVTBnZU5xalhzeXBnRms2dDBsc0JaNVk4cGk1MW9BNytsSkk3?=
 =?utf-8?B?N2JQUXNwT2pjWkpieDlEZEsxbDhBY3BDdENQSlBrWmFDcWJBeXU2OGExeWxs?=
 =?utf-8?B?a1RrcUJ4YmlIVXlhT2Q3Rlo0MWlNa0VOWUg1ODNuaVdXRytkdXJFZ1J6UTNs?=
 =?utf-8?B?SFB4M1FuYUlKb1kzcjJhZ3lWRlA5aysvMHdReXA2bnBRbTdzcm4waWZEUXhB?=
 =?utf-8?B?S3kxMURWZlQwaWtqM003Mmlpd2lkS05PbWFnaTl2RzVOV1BBQW1WYWtESEZ4?=
 =?utf-8?B?a0hUU0Z1d1VpNGdYaXkySDF5WU11WmdVRmVPRERMUS9YaG1zSGZwMUNYc0ht?=
 =?utf-8?B?M3RMQVU3amtFMTBlUmFoaXZNRDVmUGVlb3NucFNhcWRDU1YrUU1zVWM1MmVl?=
 =?utf-8?B?YmRaUUFCSmQ2ME53enBxMkxsY3BqK2t5TndpT2xoTU5QSXhKbGUrMUJwTVhB?=
 =?utf-8?B?YUlPM2NERmtwbHRlRmMrTnQyb05FaDlTdXlKRUJ1NzQxSkpWVHRRZkhHQi9p?=
 =?utf-8?B?MUo2SjlXc1h0a0JnZzRGSUZlQis3MCtiWHczam1OOGJWU1BFc1NkdU96MWM2?=
 =?utf-8?B?cHhjWG1pN043M3Zoc0ZBUGpNNW00aCtXRGNNYjZNSmcxbHVVSmYwbUdGR2tn?=
 =?utf-8?B?aVdvWWtDckE5Y3hSajVzakdWYmFVak5zbzJsTzlrVmQ0VTlURlh2cmRlVity?=
 =?utf-8?B?aU5IME1vT2d3NnNkemllSG0vWWMzVVp1WmRFem9yZlgrZlJmV2E4c0NGbUhu?=
 =?utf-8?B?TlBhQ2w0QmNkZ0IwN2VNbldLU0hBK0J1YWVGWmRNbXJOMXc1VEoxQWlmK09h?=
 =?utf-8?B?TUhoOVI3OEU1cEprbE82N3VDdll5Z2dodTdaWVBUajNYOU4yRXFwb25Cay9h?=
 =?utf-8?B?ZGV0RFUyTDNyUndiOXhGRUdXSEFZRnZQa0Fma3N3V1UyUlBnNnlFUXVzNkJB?=
 =?utf-8?B?ZHYxc0Q5cEsvUFNvWWhGWkhNRmREY3BONHZTNnlHZ1hBakhwUWszNEs3Zk03?=
 =?utf-8?B?eVBCUzFLRWM2ODFvM3pDM0krL3FIb2x2L0c1RUorKzMzNFRDZExyUmVtVmYz?=
 =?utf-8?B?ZkVJaUdqbEsxN2tiWVluM2dRckJyQWxHTzN1dzkwdjVrdGVjZDBRblp0VkE4?=
 =?utf-8?B?cUlleUw2ZWZZK2Y3NTE4R1phRzE5ZWhSSTg3b0RmenBmYzZoa2paOFlQR2Fk?=
 =?utf-8?B?YVVFVHZ2cGFrZlcybFpMb2FpM3pMdThsYTVkUEcxRnpoZkE4WldwL3VTbzFn?=
 =?utf-8?B?RWdjbnY3QzRDMmlxbjI0eHppRGNHck5BcXRBSjNOS1pVS2RQVXJod2FhcnBl?=
 =?utf-8?B?bW5FME1rbGhQVHFncGh1ampBK084bEp5UTFieHhvM3RZMHdoU1FXaUtlTzN0?=
 =?utf-8?B?ZnNyN1NuaHhadjJsTm56WGdYV1lyM3JRZzAzRm5ralA5NldxUmF2TjdpVXZP?=
 =?utf-8?B?TmFzdmoycjdmL3g4VkVSblV2RitURitqaUJCUzJnbDB4YWVNQnc5Z0JKck9o?=
 =?utf-8?Q?oF3GIuH9F8O7Xh0Y=3D?=
X-Exchange-RoutingPolicyChecked: wh5OoCS9cPvcTuwnzp8kOYFMNBFKd6EGLVpFJl/p6W1/PrNi1JAZ+2bwDB3raVz49OMKdLppIVyaT3APtfbMafpE6rqmHnWSKEuV+/vrg5yq+ge1f+DJ+WX5n0SVvtEdnTeO5uJEozntPdqGsOStNKsOIUFp00yfIZVv1HLvK4OncRMisxroHCqlM1NNAfGuvQlqhmFL26sEE0lVWXzKBZ1z2bOiQxqhYBtUvkOMSwk6+u8N/9WhYp75+I8/XJy10qJXPFs/D7PRL5GOV0SraliF8V0YTC2tQDNO7z3mZUs9fvVgY1LBYPgl2Z/C4+KvAkeV+V9uS/MbkWpwJA8ptA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e261d5d-e3ab-4d5a-055a-08deaad04d72
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 18:01:16.4181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1JzoxTCKojZnyeIjqnmcziKvuQus9B4JMitFB7lklsJQnyEQ6KXkRp/VEUKRYHpPHBi09xHiWTk/1lLgA76VzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8486
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 13299180010
X-Rspamd-Server: rspam04
X-Stat-Signature: uc4wq19wuwu5fp1bg5b5mwyz855atjbw
X-HE-Tag: 1778004090-832354
X-HE-Meta: U2FsdGVkX1/zqkqq9GeK8FkP6KKMQEi05xIzMfqGEBu7lwyTfEXE0GIErMcxI3TuUzKfgMOygSMbljCkZh+bWLEuOdMj6moK4Z+lq42DnGgU8M/QuxqDeUijE5zoDZ9G5IpG0w7HJMa0Cwey7AE1mDILmb5eLBAIgIkiY34Ncj8rwG+GGluvGWFk/oNlu98UtLTQ7uVV2QP8hA17GFxM7N/l/wMs2N4hXfDHIbsjSwKL6tv8oYEHaBs0Jx7Of07zO/A6pbanB+yp1uHz9ni8y0DH8WkP6dOrcBGN7Zd3g1RNIT6FzpEFvS+c4x2qzvh1Tv2ix0znP6XdPghIKmXyReqlVPVx0CzWHNXsDgxMvz+Lwtk5IGAvtO08DGKH3Ubj0P3SSyEMpuexCEsNyhdcUU4DMr9+bxM12/o+4jW4InSVm9ofBN2BPO/QpQ4T6C2L6vco/FOW4mZpR6AwjdEQ5TUvJjn6Kbmk/jfhCXsDD5D7qY5m5z58D7ne/B5MJCn6qQP+YQSydh6g90hKox/fahcpjTgu8KucAhqWONwXpOhx0PAOHiT1dWw3bzMheogO37lpskBT1Gj5HsblYhQtqYF3t1MV3ivJGmhnHA3KnV8nfxxHqBsTt+fK83lSOH8qJIALl7Wq8n7PK3+/dholYLBEX/98PX90vFdN5ohEAjR8tWneMATCIZ9PtS4/3scp1SSSvRCj9zuECOkZY8duCT48926Q/ULIJ9NZ4efa+v9l1Xs1tp9HPM+YKCxhS0wtckogIzizf9T7nr/wntkALWVbMWDvx4cEzAkVmd1830d1CrVCPR2KpAt1xCoCL8ZD50FxxBLiaudSProg4pZ/Ny2ARB7s/o9jikKJ28APHn+rBAxIB1f06wLQPaCeR07kEaJqVmoztmgDemK+3xKzg6PW7dqoWOSlql1z2RKs7iqhrXa3Kpdq+loW/K/ulavawEL8ejeMiD+f8lPMw+p
 evMyKRUC
 oqDNyDpNwxK+NMTNIMysUgMYrTIQAMT7+zEPvn5tmXgAn9jsezC/7TaLvxqueOY7QbkGLiw9I9c/0XMSciYen3AjkY1942PrZ620PS8cfBQHiyjZeijPGWsUVgyV2c39IYDi8/+pE+4fGHig8LxrFHRXSaGiZyW5p9tjnccrkmK8wUE9kse3bUN65+7JiYjU5ZQ4wA1hfY6F2Tov6WqctnG9/vCEKGCVFD8kPIgLOlYlQNKd9SKT3q8ZsIDSpg/xrmKkLmTWjZcvIlv/Ek8aUnjR5iExYO/GsC35l56P9bml8AHCxyMh2HGcHPggU0Dwn/ZomCNDSNSI+3IcrDVXTLLTToYw9WRrfP2NEQa1bKBtiIh4bsmmdSBrRcrRLmdGZ+FDviB3J964vGVW5EyeOW7wrNrpORZ0VQ9sRLhBGrs8ob6+mnQ4m8UFVSokaKvxt0xvFIDMXzkrOdF+LBgiXRI9yDQ/dDQemAIvTlej9V0PshZVF/PRwk7H21RbnjJQhplsueb2b6RsYPBGDcD6+fJTM0nhQvK8DDm8gTPwFCxI6y1uN+avl6uLU5WZn2Y6ekz5L/uOfxIS/icZeu3JtJevPF3582TsLyl0R/fJNrXndOl01XV8ioh/oYIgn3Dz0r83UrVQ6g7cLKTVbEGs0Gcp2N7mQVNsqNJ34nfAP8oSujezFdJrrkF69olvsHHiRT4qOXJGeFbczx9gSfT5HS6phA0ddZapwV2Zj387UWRoGZ1w/6ByZujPt8Dq56Xt3Eec/Zzl3KaV6f3185Y50mpcgmFm82HjJVuerFxA1cnr7bW4WMMisXZb6kR+UgMZj95SkeWv1cT98hFz4xpYVHduTc39mb/GEqxRmnhCCySiAIzBbXTTzAyo1fvy6EwNCOK++NYTT1VD3gJJoPJAE/ZzDkRMay9KA2drs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 05, 2026 at 10:18:14AM +0300, Mika Penttil=C3=A4 wrote:
>=20
> On 5/5/26 10:09, Alistair Popple wrote:
>=20
> > Thanks for doing this work Mika. I've been meaning to take a look at th=
is series
> > for a while. I'm currently at LSFMM but will try and take a look this w=
eek or
> > next as it sounds quite useful.
> >
> >  - Alistair
>=20
> Thanks Alistair and no problem, appreciate your insights whenever you hav=
e time.
>=20

It looks like this series is breaking Intel's CI [1]. Looks like
something in RCU is blowing up:

<4> [212.361418] ------------[ cut here ]------------
<4> [212.361431] Voluntary context switch within RCU read-side critical sec=
tion!
<4> [212.361432] WARNING: kernel/rcu/tree_plugin.h:332 at rcu_note_context_=
switch+0x82/0x780, CPU#11: kworker/u65:5/2352
<4> [212.361440] Modules linked in: snd_hda_codec_intelhdmi snd_hda_codec_h=
dmi mei_lb mei_gsc_proxy mtd_intel_dg mei_gsc xe drm_gpuvm drm_gpusvm_helpe=
r drm_buddy gpu_sched drm_ttm_helper ttm drm_suballoc_helper drm_exec drm_d=
isplay_helper cec rc_core drm_kunit_helpers i2c_algo_bit kunit overlay inte=
l_rapl_msr intel_rapl_common intel_uncore_frequency intel_uncore_frequency_=
common intel_tcc_cooling x86_pkg_temp_thermal intel_powerclamp hid_generic =
coretemp eeepc_wmi cmdlinepart asus_wmi binfmt_misc sparse_keymap spi_nor m=
ei_hdcp mei_pxp mtd wmi_bmof kvm_intel kvm irqbypass aesni_intel gf128mul r=
8169 usbhid rapl hid intel_cstate realtek snd_hda_intel phy_package snd_int=
el_dspcfg intel_pmc_core snd_hda_codec idma64 nls_iso8859_1 pmt_telemetry s=
nd_hda_core video snd_hwdep pmt_discovery snd_pcm i2c_i801 pinctrl_alderlak=
e pmt_class snd_timer i2c_mux intel_pmc_ssram_telemetry acpi_tad acpi_pad m=
ei_me snd i2c_smbus spi_intel_pci soundcore mei spi_intel wmi intel_vsec dm=
_multipath msr nvme_fabrics fuse efi_pstore nfnetlink autofs4
<4> [212.361711] CPU: 11 UID: 0 PID: 2352 Comm: kworker/u65:5 Tainted: G S =
  U              7.1.0-rc2-lgci-xe-xe-pw-165953v1-debug+ #1 PREEMPT(lazy)=20
<4> [212.361715] Tainted: [S]=3DCPU_OUT_OF_SPEC, [U]=3DUSER
<4> [212.361716] Hardware name: ASUS System Product Name/PRIME Z790-P WIFI,=
 BIOS 0812 02/24/2023
<4> [212.361718] Workqueue: xe_page_fault_work_queue xe_pagefault_queue_wor=
k [xe]
<4> [212.361833] RIP: 0010:rcu_note_context_switch+0x82/0x780
<4> [212.361838] Code: 45 85 c0 74 0f 65 8b 05 24 84 ab 02 85 c0 0f 84 8d 0=
1 00 00 45 84 ed 75 16 8b 83 bc 08 00 00 85 c0 7e 0c 48 8d 3d de ad 4d 02 <=
67> 48 0f b9 3a 8b 83 bc 08 00 00 85 c0 7e 0d 80 bb c0 08 00 00 00
<4> [212.361840] RSP: 0018:ffffc9000186f4a0 EFLAGS: 00010002
<4> [212.361843] RAX: 0000000000000001 RBX: ffff88810a3a8040 RCX: 000000000=
0000000
<4> [212.361845] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8=
39bcea0
<4> [212.361846] RBP: ffffc9000186f4e8 R08: 0000000000000001 R09: 000000000=
0000000
<4> [212.361848] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88885=
f1b6a00
<4> [212.361849] R13: 0000000000000000 R14: ffffffff83248312 R15: ffffc9000=
186f630
<4> [212.361851] FS:  0000000000000000(0000) GS:ffff8888db203000(0000) knlG=
S:0000000000000000
<4> [212.361853] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4> [212.361854] CR2: 00007fe433b2f088 CR3: 000000000344a000 CR4: 000000000=
0f52ef0
<4> [212.361856] PKRU: 55555554
<4> [212.361858] Call Trace:
<4> [212.361859]  <TASK>
<4> [212.361862]  ? lock_is_held_type+0xa3/0x130
<4> [212.361868]  __schedule+0x103/0x1f70
<4> [212.361870]  ? lock_acquire+0xc4/0x300
<4> [212.361874]  ? find_held_lock+0x31/0x90
<4> [212.361877]  ? schedule+0x10e/0x180
<4> [212.361880]  ? lock_release+0xd0/0x2b0
<4> [212.361885]  schedule+0x3a/0x180
<4> [212.361888]  io_schedule+0x4c/0x80
<4> [212.361890]  ? softleaf_entry_wait_on_locked+0x147/0x2b0
<4> [212.361894]  softleaf_entry_wait_on_locked+0x24f/0x2b0
<4> [212.361899]  ? __pfx_wake_page_function+0x10/0x10
<4> [212.361904]  migration_entry_wait+0xff/0x190
<4> [212.361909]  hmm_vma_handle_pte+0x440/0x790
<4> [212.361914]  hmm_vma_walk_pmd+0x5c8/0x1360
<4> [212.361918]  ? xe_pagefault_queue_work+0x1a9/0x520 [xe]
<4> [212.362015]  walk_pgd_range+0x57f/0xd70
<4> [212.362017]  ? lock_is_held_type+0xa3/0x130
<4> [212.362028]  __walk_page_range+0x8e/0x290
<4> [212.362034]  walk_page_range_mm_unsafe+0x19e/0x270
<4> [212.362036]  ? trace_hardirqs_on+0x22/0xf0
<4> [212.362043]  walk_page_range+0x2a/0x40
<4> [212.362045]  hmm_range_fault+0x94/0x190
<4> [212.362053]  drm_gpusvm_get_pages+0x269/0xa30 [drm_gpusvm_helper]
<4> [212.362067]  drm_gpusvm_range_get_pages+0x2e/0x50 [drm_gpusvm_helper]
<4> [212.362071]  __xe_svm_handle_pagefault+0x3e0/0xef0 [xe]
<4> [212.362181]  ? __lock_acquire+0x43e/0x2790
<4> [212.362188]  ? lock_is_held_type+0xa3/0x130
<4> [212.362193]  ? lock_is_held_type+0xa3/0x130
<4> [212.362197]  ? xe_vm_find_overlapping_vma+0x57/0x1e0 [xe]
<4> [212.362304]  xe_svm_handle_pagefault+0x3d/0xb0 [xe]
<4> [212.362412]  xe_pagefault_queue_work+0x1a9/0x520 [xe]
<4> [212.362509]  process_one_work+0x239/0x740
<4> [212.362518]  worker_thread+0x200/0x3f0
<4> [212.362521]  ? __pfx_worker_thread+0x10/0x10
<4> [212.362524]  kthread+0x10d/0x150
<4> [212.362527]  ? __pfx_kthread+0x10/0x10
<4> [212.362530]  ret_from_fork+0x3bd/0x470
<4> [212.362533]  ? __pfx_kthread+0x10/0x10
<4> [212.362536]  ret_from_fork_asm+0x1a/0x30
<4> [212.362546]  </TASK>
<4> [212.362547] irq event stamp: 2057044

I=E2=80=99ll be out this Thursday for five weeks, but assuming you can sort=
 this
part out, I=E2=80=99m fine with the series moving forward. I=E2=80=99ve loo=
ked at this
several times, and it seems sane enough to me.

On our list we also have the Sashiko setup [2], which I=E2=80=99ve found to=
 be
incredibly helpful for series that do deep MM work. I=E2=80=99m not sure wh=
y
Sashiko is saying this series didn=E2=80=99t apply, since it applied cleanl=
y to
our CI branches. If you can get Sashiko to run on it, that might be
helpful as well.

Matt

[1] https://intel-gfx-ci.01.org/tree/intel-xe/xe-pw-165953v1/shard-bmg-4/ig=
t@xe_exec_system_allocator@process-many-stride-mmap-race-nomemset.html
[2] https://sashiko.dev/#/patchset/20260505051658.2219537-1-mpenttil%40redh=
at.com

> --Mika
>=20
> >
> > On 2026-05-05 at 15:16 +1000, mpenttil@redhat.com wrote...
> >> From: Mika Penttil=C3=A4 <mpenttil@redhat.com>
> >>
> >> Currently, the way device page faulting and migration works
> >> is not optimal, if you want to do both fault handling and
> >> migration at once.
> >>
> >> Being able to migrate not present pages (or pages mapped with incorrec=
t
> >> permissions, eg. COW) to the GPU requires doing either of the
> >> following sequences:
> >>
> >> 1. hmm_range_fault() - fault in non-present pages with correct permiss=
ions, etc.
> >> 2. migrate_vma_*() - migrate the pages
> >>
> >> Or:
> >>
> >> 1. migrate_vma_*() - migrate present pages
> >> 2. If non-present pages detected by migrate_vma_*():
> >>    a) call hmm_range_fault() to fault pages in
> >>    b) call migrate_vma_*() again to migrate now present pages
> >>
> >> The problem with the first sequence is that you always have to do two
> >> page walks even when most of the time the pages are present or zero pa=
ge
> >> mappings so the common case takes a performance hit.
> >>
> >> The second sequence is better for the common case, but far worse if
> >> pages aren't present because now you have to walk the page tables thre=
e
> >> times (once to find the page is not present, once so hmm_range_fault()
> >> can find a non-present page to fault in and once again to setup the
> >> migration). It is also tricky to code correctly. One page table walk
> >> could costs over 1000 cpu cycles on X86-64, which is a significant hit=
.
> >>
> >> We should be able to walk the page table once, faulting
> >> pages in as required and replacing them with migration entries if
> >> requested.
> >>
> >> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
> >> which tells to prepare for migration also during fault handling.
> >> Also, for the migrate_vma_setup() call paths, a flag, MIGRATE_VMA_FAUL=
T,
> >> is added to tell to add fault handling to migrate.
> >>
> >> One extra benefit of migrating with hmm_range_fault() path
> >> is the migrate_vma.vma gets populated, so no need to
> >> retrieve that separataly.
> >>
> >> Tested in X86-64 VM with HMM test device, passing the selftests.
> >> For performance, the migrate throughput tests from the selftests
> >> show similar numbers (within error margin) as unmodified kernel.
> >> Tested also rebased on the
> >> "Remove device private pages from physical address space" series:
> >> https://lore.kernel.org/linux-mm/20260130111050.53670-1-jniethe@nvidia=
.com/
> >> plus a small patch to adjust with no problems.
> >>
> >> Changes v8-v9
> >>   - rebase on drm-tip
> >>   - fixed uaf around  migrate_vma_split_folio() usage
> >>   - added missing pmd unlock
> >>
> >> Changes v7-v8
> >>   - rebase on 7.0
> >>   - fixed subject in two patches
> >>   - enhanced commit messages
> >>   - squashed patch 6 into patch 4 to fix kernel test robot warning
> >>   - readded dropped Cc block from cover letter
> >>   - fixed white space
> >>
> >> Changes v6-v7
> >>   - rebase on 7.0.0-rc6
> >>   - added documentation and comments
> >>   - denote to be migrated zero page as HMM_PFN_MIGRATE alone
> >>   - got rid of HMM_PFN_INOUT_FLAGS movement in patch 2
> >>   - picked up Acked-By from David for patch 1
> >>  =20
> >> Changes v5-v6
> >>   - rebase on 7.0.0-rc4
> >>   - use range based TLB flushing while unmapping ptes
> >>   - gate migration behind HMM_PFN_REQ_MIGRATE for fault and
> >>     migrate paths
> >>   - always infer migration flags from migrate->flags only
> >>
> >> Changes v4-v5
> >>   - rebase on 6.19
> >>   - fixed David's email address
> >>   - fixed link issue without CONFIG_TRANSPARENT_HUGEPAGE
> >>   - refactored into smaller commits
> >>   - added more comments to code
> >>
> >> Changes v3-v4:
> >>   - rebase on 6.19-rc8
> >>   - fixed issues found by kernel test robot with random configs
> >>   - fixed typos
> >>
> >> Changes v2-v3:
> >>   - rebase on 6.19-rc7
> >>   - fixed issues found by kernel test robot
> >>   - fixed smatch issues reported by Dan Carpenter <dan.carpenter@linar=
o.org>
> >>   - fixes to lock handling (pmd/pte) on errors
> >>   - added assertions for pmd/pte lock states
> >>   - other issues discovered by Matthew, thanks!
> >>
> >> Changes v1-v2:
> >>   - rebase on 6.19-rc6
> >>   - fixed issues found by kernel test robot
> >>   - fixed locking (pmd/ptl) to cover handle_ and prepare_ regions
> >>     parts if migrating
> >>   - other issues discovered by Matthew, thanks!
> >>
> >> Changes RFC-v1:
> >>   - rebase on 6.19-rc5
> >>   - adjust for the device THP
> >>   - changes from feedback
> >>
> >> Revisions:
> >>   - RFC https://lore.kernel.org/linux-mm/20250814072045.3637192-1-mpen=
ttil@redhat.com/
> >>   - v1: https://lore.kernel.org/all/20260114091923.3950465-1-mpenttil@=
redhat.com/
> >>   - v2: https://lore.kernel.org/all/20260119112502.645059-1-mpenttil@r=
edhat.com/
> >>   - v3: https://lore.kernel.org/all/20260126111939.1332983-2-mpenttil@=
redhat.com/
> >>   - v4: https://lore.kernel.org/all/20260202112622.2104213-1-mpenttil@=
redhat.com/
> >>   - v5: https://lore.kernel.org/linux-mm/20260211081301.2940672-1-mpen=
ttil@redhat.com/
> >>   - v6: https://lore.kernel.org/linux-mm/20260316062407.3354636-1-mpen=
ttil@redhat.com/
> >>   - v7: https://lore.kernel.org/linux-mm/20260330115611.347988-1-mpent=
til@redhat.com/
> >>   - v8: https://lore.kernel.org/linux-mm/20260414041226.1539439-1-mpen=
ttil@redhat.com/
> >>
> >> Cc: David Hildenbrand <david@kernel.org>
> >> Cc: Jason Gunthorpe <jgg@nvidia.com>
> >> Cc: Leon Romanovsky <leonro@nvidia.com>
> >> Cc: Alistair Popple <apopple@nvidia.com>
> >> Cc: Balbir Singh <balbirs@nvidia.com>
> >> Cc: Zi Yan <ziy@nvidia.com>
> >> Cc: Matthew Brost <matthew.brost@intel.com>
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> >> Cc: Vlastimil Babka <vbabka@suse.cz>
> >> Cc: Mike Rapoport <rppt@kernel.org>
> >> Cc: Suren Baghdasaryan <surenb@google.com>
> >> Cc: Michal Hocko <mhocko@suse.com>
> >>
> >> Mika Penttil=C3=A4 (5):
> >>   mm/Kconfig: changes for migrate on fault for device pages
> >>   mm: Add helper to convert HMM pfn to migrate pfn
> >>   mm/hmm: do the plumbing for HMM to participate in migration
> >>   mm: setup device page migration in HMM pagewalk
> >>   lib/test_hmm:: add a new testcase for the migrate on fault
> >>
> >>  include/linux/hmm.h                    |  19 +-
> >>  include/linux/migrate.h                |  26 +-
> >>  lib/test_hmm.c                         | 101 ++-
> >>  lib/test_hmm_uapi.h                    |  19 +-
> >>  mm/Kconfig                             |   2 +
> >>  mm/hmm.c                               | 835 +++++++++++++++++++++++-=
-
> >>  mm/migrate_device.c                    | 583 +++--------------
> >>  tools/testing/selftests/mm/hmm-tests.c |  54 ++
> >>  8 files changed, 1066 insertions(+), 573 deletions(-)
> >>
> >> drm-tip
> >> base-commit: 94d56a898a2db27f841b17f6966a81ba502fe63c
> >> --=20
> >> 2.50.0
> >>
>=20

