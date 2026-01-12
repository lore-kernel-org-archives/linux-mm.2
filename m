Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F771D25030
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 02:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AC6C6B0088; Sun, 11 Jan 2026 21:37:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75A1D6B0089; Sun, 11 Jan 2026 21:37:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AF2D6B008A; Sun, 11 Jan 2026 21:37:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 44F9D6B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 21:37:18 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C350F1A1737
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 02:37:17 +0000 (UTC)
X-FDA: 84321750114.14.A672326
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2F12240008
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 02:37:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Mc3l17lO;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf12.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768185434; a=rsa-sha256;
	cv=fail;
	b=mXHD+Om4ZCBQ2nt6maBJEyo8LzAGsLuVBDMHZox7Zj3xYiNuNUPsi/NoUg9EEatdJIcKxU
	ZWGjknaDzATptanbMqHBpWOZU+lUNCHCTgTzaAqdwWtJDZSGjd5IbAVv5Vbh2WmjuEOJbQ
	zeUAVCzDkYXVQb0zIENMS+hKaUqTMbk=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Mc3l17lO;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf12.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768185434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gg0N6IcsjCsfmKfb7WKLUDYCAUhfCjb+KcwCtwlswOY=;
	b=AJGKRdqtlkT61qjHVH6xZAWbBP731LcYi8ZUnFRoot7InIh6XmJjgU403tnrzNUdqruQ9r
	MPRYed55cTCzIwbd+2ZDgufBqdP3Gbo79iSQGLStKHUG6fdApaQbTj+j+8Zzz3FiZiF1mc
	p7oxnZEaOMhqoFniydRcD1CaEl1GOpI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768185433; x=1799721433;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=vAcORCx41GCC4hjL7izSm04/sEYzHj8nNJaPjF0M2Q0=;
  b=Mc3l17lOy5H/uFQfCbcHjYYYVai+1e9Os5pAh5GK68C7YBafUpaIfFyv
   tVBpCpEGIpi5WROKn28XaUhWxy53A7JRyVPvqR22g3TmI/V0fB2ohmWjH
   DDjRhW2dxVLSR9EunxyayhT9dCr3biN3JHaBAbDcOFFrS2yqU/uiSQUyZ
   2QSmzReuMyqhtKG8HvB0JqQj7+KdDHjX9QqDQ31fmjVmRMkQjG0aqd8h0
   8Hv+a9nFcQr8X1eWEvwt/nLIgqbv+fHhnCP1HE1XL4RIOSI840HUe6TBo
   a7RQffXZaBfzl6lbb1a05nGyK3thq2MX87gu461Tqc7wqtmGRffxPZoj6
   g==;
X-CSE-ConnectionGUID: IkiabvSMQqSwDtg7oo/RaA==
X-CSE-MsgGUID: BMCw/6UJQ2KkQHWPAv8A5g==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="68465755"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="68465755"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 18:37:11 -0800
X-CSE-ConnectionGUID: +pogJ5dnTvKaKLkFLCnh9g==
X-CSE-MsgGUID: 8YYjf9aETTaOV690KkULnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="203599996"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 18:37:11 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 11 Jan 2026 18:37:10 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sun, 11 Jan 2026 18:37:10 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.44) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 11 Jan 2026 18:37:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iFE6ypkhDGDtusyHGgufn83yZJVwZdBnNfel7aCuPj6kQeIG8WEdro+4/B2cc8d6l8Crl36o4KbTbrBJo6n52MxTLwaHoK+Wmp6eYt4kNTKKj41jtaUlCuHbMm2lgb/gsbb2HjhX+3czB9u/T2s4x8eAZ3q4SrIp7EepTCbdlpFLFBJV1ZU+ZahwyDMOzurRwKCMn36fmcYxk6j1LnY6nwEhvxyVkn+nepDR+dtyGIc29TFvE+52S2xqC8LVe3Ll/5Q4bXz6Z3b+iz3YqOe7wJG6PkacMUagK///tSMgH9Gkrg6oqpFsJp53/CjaZIjPEzSxFtBpMNNMlWW2v3Mv4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gg0N6IcsjCsfmKfb7WKLUDYCAUhfCjb+KcwCtwlswOY=;
 b=ZdAslXC6eQUvlwUwMJNwiAHeaThQpKBhF5VNH9wriQNpzty2w5Ro6dNIxqIQZY3hDM9ZB1p7U2S1gfSVlq2bY40+0tpIIdc4fQ0zahbGoGr089SlLMg+1TVBXCtbqtF8MeOw1CPjWz9f3ww9DqQ00IXxLTicVoueeJxoQZihn4xGJ850g/W3i7tn1gBmLTm1/Xq6kL2ZkGfHCNq3bistR4r6Tr3iba9MgNObrFzYsKjc9i2giu5+CYo+OKaoy0Eovs4nkVmmvSF6N58A7ABPWkhmUmukCeex9nzfKeCE2ahjBwoV3f3QSEFzPdQQGFoBA1LNMMHXzbB2z3FjmA2oDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SA1PR11MB8426.namprd11.prod.outlook.com (2603:10b6:806:38d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 02:37:08 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9456.015; Mon, 12 Jan 2026
 02:37:08 +0000
Date: Sun, 11 Jan 2026 18:37:06 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Balbir Singh <balbirs@nvidia.com>
CC: Francois Dugast <francois.dugast@intel.com>,
	<intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, Zi Yan
	<ziy@nvidia.com>, David Hildenbrand <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "Lorenzo
 Stoakes" <lorenzo.stoakes@oracle.com>, "Liam R . Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Alistair Popple <apopple@nvidia.com>,
	<linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/7] mm/zone_device: Add
 free_zone_device_folio_prepare() helper
Message-ID: <aWReUk5uDf4hw/Q4@lstrano-desk.jf.intel.com>
References: <20260111205820.830410-1-francois.dugast@intel.com>
 <20260111205820.830410-3-francois.dugast@intel.com>
 <706ba3a6-5be2-46d7-9e7d-d613f2e061cc@nvidia.com>
 <aWRLeoUJAYAWbLD3@lstrano-desk.jf.intel.com>
 <dd60d292-a267-4ccd-842a-36525b707bde@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dd60d292-a267-4ccd-842a-36525b707bde@nvidia.com>
X-ClientProxiedBy: BYAPR08CA0043.namprd08.prod.outlook.com
 (2603:10b6:a03:117::20) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SA1PR11MB8426:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e051395-fad6-4367-0574-08de51837b7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b3JBM29sWUQ5dFhId0ViZFQrcGxEQkMrL3p1U0lNZFk1NnRhTStuQVFuSERY?=
 =?utf-8?B?VDQyeGhIdTBkRERTMGh4YUMwcGFXcmx6UW53U3NITVNrNGRCQ0JNYWxoT2ph?=
 =?utf-8?B?VTR4ckM2SzAzd2MwZFFhUVoyOVF3UmRuR2dRRXo4V2g3NDM5Q0drNWpSSXJM?=
 =?utf-8?B?d3pvcUxyOGdmVkdOZ09TVmsrbmI5M2ZrdXplRFNaRklObEZtYzRqVWpCWHp5?=
 =?utf-8?B?OHNXdXZtWmhYK2Yyc25EaVlkZXNYY2xteFdWYU0xbFA4bTBMZjRuZmM5L3FE?=
 =?utf-8?B?YUl2N0w1Wm5nU1h1b0NnSzB6TDdjOFV4VU1lV1E2WUpRREg1U3JadGFlQnl5?=
 =?utf-8?B?a2hCL25CZlFxMWNIdHd1RWVLeE5hZnJyblZwQzlVWHV0OTUvWDlhaU1YbEpI?=
 =?utf-8?B?Yk5VNmRuc2VoRDdyRk9nSWNTMTFqZGRnR3JhbUNxTkpidUVhaG5VNkE1aCtl?=
 =?utf-8?B?VXl0dkFZMTA3Mkk1VWxhcHVIM3A2MlR0eUlRcFh5Q0t4YU1LSzIwMTYwWWlJ?=
 =?utf-8?B?YkRyS2g2dXRzbllXT3EzN1ZGYVZibWh3NC8yZU9QM2t6SURqa2VnaytHWjJQ?=
 =?utf-8?B?dW1mN21UbFNhS2luN28vVDZPVWp4WHJhUFpzVndpOGhjTTFRVGt1ejM5WmJL?=
 =?utf-8?B?STl0ZzJwVEpPUzR4aHhqN2c1QmtEYmxuTEI0cjF3NUk2eElXTCtxZE0wUXZi?=
 =?utf-8?B?Z2FlQzM2bURheU9tTllMRU1wOVdMRFhHa2VsSE5Ick5RK21KWGFqTUhrSkVv?=
 =?utf-8?B?R2pNRnNSTXdaWTNrZHdjdEw5dTFXYzJGUThWVlFvSnNoSWZ6cVNMTDBSMklO?=
 =?utf-8?B?djNaM0liVUlwblgyQ1h2OGNOMWVzMUh6eXg0YzJDd0lFbHo2d1hxQkpkVGRB?=
 =?utf-8?B?V3VLbzJIMzducGpOS2svRkxxYnd4M053QWNtOFlMcW9ISmh2dnRMWFpzRzFh?=
 =?utf-8?B?YXprTWJ2d210UkhtZHFISWlRTDk3Ty8yUWM0NWE0NnBrc2pyazBQZ3J2RUtI?=
 =?utf-8?B?a2xkMjVESWQ5WVlsNGx2czNoZThaRGtROUhsd2NyeWptTjZ5VUNzSzBFV3F3?=
 =?utf-8?B?YUZqTEpPUlQveitlVlFCLzdPalRraWFoT2tKTDVKNHRZMUZ0R2ZoeGgzRzlp?=
 =?utf-8?B?cmI4UFZ5d2tNZ1dhbGlFRHlFYnNNQVdwK1BlMTJCTmtXd0pYRHVaVTRWdDdH?=
 =?utf-8?B?ODU0RlA3N2ZYbVU0dFI4S1dCSTZTSVRPUzNkMzJMc3FUMjdEckdZRkM2a0dO?=
 =?utf-8?B?eE1VYnUwRCtLWUdqaTl6MzllcUFTSGtqWE1LS2ozdTU2S25lT29RN1J3RUZQ?=
 =?utf-8?B?OFFrQitsODZQVXdxcjNGWUFvYjdLamd2Z25MWXJybE1DZ3IvWGI1QlhnQnhC?=
 =?utf-8?B?Y3pDS3dPQUZLK25mdEhDTjFLak9kWS9BSDBlaE1ZTDBnZWU3MXlEelZCWW8r?=
 =?utf-8?B?azQ2ZldVVzFHdFA4RVNtQVpJcTVDSm83Q082VXZaeExBS04rSHJHMmd2c0hu?=
 =?utf-8?B?SG02YndWMXRheFVMdURQVEM3QXlycnV6MU05N3VLKzVpdFpNRWJCME1QSlh3?=
 =?utf-8?B?SWVtTVYvWUFiS2ZrWnFFR2xvS1RMMkI1c0dVa2g3U1JidEtkUVZoRDBWQWtD?=
 =?utf-8?B?THFRWVNOZ3VndlJKK0FOWUtza3hYWHgreDBQcXNxRTJkcTE5SS9QL2xmYTRy?=
 =?utf-8?B?V3lCY2tnZ2h6eFdheFZIWmNmWE94NTJZT2xYL0ZEMXpDNnUzb0wxb2JPb0FG?=
 =?utf-8?B?ZktLOUNxbHZrcFV3UFZDMklITHVmVUFZZE5HVHU4aDgwNStoQ3BVYjlQUjhQ?=
 =?utf-8?B?SlJQWHFoTGRkSTVBN3hnTE9aSXNXNUFUT1U1ODJCbi9nVGROQ3AySWpsalZ6?=
 =?utf-8?B?ZTd5UzNJMXZ0YVo0VDJ0TVAxWHU1OGtBU09IekRxZVJSUHc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzFZNmZRMjZTQTlJTWtJQTkzSlZ1YlFNQlRYVUMwVTBYeitRMjhYTk9QVzdC?=
 =?utf-8?B?ais4VmdCTUdaNnpUcE01UmNyVWN1WCtzUS82aGRNck1KaVBuamY1M0tQZWdW?=
 =?utf-8?B?NlRlRTZ1V3dPZWFmVmtWYWZ4NGpvTDFpM1RiUlMvRVdtM3JtSW5HR3hpRzVw?=
 =?utf-8?B?am9ZZ2VUaGxleXZTTS9qcERuVUw4eHRvMkg5Nmh2elRSaGRWdE82a3BIZVNX?=
 =?utf-8?B?L1VPdW9CZUFOQmx0UUYvbUNRMEVId3puNm8xc2thdXJZNVFQZy9sS2hqbmFC?=
 =?utf-8?B?VGdFVG5Pb0ZZSjhJdVpEK2dKbnViem11eEtiWW9Yd0pyRmJjMVYvTGprSHgv?=
 =?utf-8?B?MWpvMzc1L1I2YW8xaEU4M2xJQTVYamdaYURtRFdGNG9XOTZJOUkvZkJUTm1x?=
 =?utf-8?B?MGdUN2FqL1dwbHlTRHV0RHVnWloxSjJuYXhrOXk1RUZpSWp5dDhkaHBWbUlP?=
 =?utf-8?B?dWhWak5uQ2MvTm82MU5BV1JidWVtQjVxTldmSUU2MENOOU96NTRXV1YwbHZt?=
 =?utf-8?B?eGRESlpNbnk2V0NuNHduNEErU3BZMWp6ZkFGRHJqZFVQK2lPVW81TWh3T0lz?=
 =?utf-8?B?NHRBTnVBaVJsMzBpS1c1MktkeGR3ZlcrS3h6ZHloSEtCb296R01rNnczOVVM?=
 =?utf-8?B?V2hIaG1pNW9MdUU5Vmtoek11NE44MXRQUWtoTmMvb3p1cEdIL0RNSE1yWi9B?=
 =?utf-8?B?S3U4bjluZ001cnQzRUJKaC8zVHRZYmY0cFpXZ1gyZFhrdWgwWXd6R1ZnRGdE?=
 =?utf-8?B?TWh4ZzM1Zmh3TlBzWVU3dVVNV2Fmd3I2T1VsRmJMQTdocXArWXJRY2NFQnR5?=
 =?utf-8?B?dUdlWnZ2Qkk2RGlURFdQL3d0YlR4MWFkck10aWFJbURWNVJKaFNaWmNkUm9U?=
 =?utf-8?B?cHZTd3IxMHZ0UHFwamlES1dXVUlKcnFBeURiMEcwSk0rOXQ2bDQ5SGlPU2R0?=
 =?utf-8?B?SnZ1ZFY3MnUyM0xwakR4TDdwaDh6NS8wWC9OZ1JUdUdza2RYTlh2cklvZjVG?=
 =?utf-8?B?TjR0bjhvSWlCSitONHZhbW9sRWM1UlNCcDIwN01IVktWdk9PYktwUEZ3aU5t?=
 =?utf-8?B?Q2xFQXU4OGdFQWp5OVh2a2JJbm1ObXFja0pEVnZBcWJYaHlVeWRhd2hEaUxv?=
 =?utf-8?B?WHA0WERZU3ZOV0MzRFBVN0RSaUtMMk1XS0lBMGVXaVpIc1hoTVBZZlM3QWgz?=
 =?utf-8?B?djJiRlBSVFFzdTBsMHBjWFNSOFNSQUpGRHV1Rks4S0Niei9TYWlmUXpyWHpl?=
 =?utf-8?B?bG9DVGx6UGh6ZGdLMVJIYnhzZ1BFaU5wamRpRFFtbFgxeFN4azBXaXlQVWlk?=
 =?utf-8?B?SzVtdUlyRFBraE8xSDdmYkNGRlBOMGRRUCtTSG45WkZnTHBLZ1JrUXVVRHU5?=
 =?utf-8?B?MnByZnJ2VnJwREdkTDVVVThUbUFvam5maEpIMTkwZ1FqTXlISlZpb1EvTkRo?=
 =?utf-8?B?cGM4T2tvYTdoSDFFZXFXV1RWd1NCWHY5Q0lMK0pGd0FKV05ER1BnWDYvU01n?=
 =?utf-8?B?eUxsb3VrSCtLL1ZvUHZMNE81MjZhdDUwWkF4dERTdVZ4Qm8vNVlYSFBJZVFx?=
 =?utf-8?B?QkhEczJwb0dweDl6Ri9saE5ZY2FqUGVQTHQ1T3AvaW14cGwrQ0oycGh2cUl4?=
 =?utf-8?B?eVRpTDVqY1FWYnFWaG9uRzA3MU9wc1J2amFSTjNxSHZQUFR5eW9MS0hiOXVF?=
 =?utf-8?B?RFBsaHN2b1BRYm5tZHRCT09VRkF2RVQyTUppb28zWStVUXBwTURFT05ZOHk2?=
 =?utf-8?B?TDRvcDZZYmppcTRyYUtFeWpqTlMrK0w1SFpsenYwM01QanVqNnh0OTdXeWZV?=
 =?utf-8?B?c1RJMHFodzJXcFVza1JvUEtaSTJVWlJXWENLTGwvcVZOYVBDbjBtQXZqN0Fl?=
 =?utf-8?B?Q0FYNDNPQ2tZR0RidVVJVHhmUURrWnlWa2dWK1ZnWkNRWUVRZFRPUnlKdnor?=
 =?utf-8?B?YURianFXdXNYUit6dUMzVzJ3UW56OTQ3c2x4K3VJSzNnbU5RSEUwWW5ZMGRr?=
 =?utf-8?B?TXhyZC9MUUpudzRFOHRwb1VBUDZDanU2RXg0bmtWUW9xMXEvTkpON0s0WEVp?=
 =?utf-8?B?aG5RbDNubDRoRjBWWFZBb1JQMUFHRXhFZTYwZ1pXTEh5cTdkZE5FQTVTK0NF?=
 =?utf-8?B?UEw3S1hmNnpxR3U3bTV1ejFnUkNBYjFwL0RyWFMwaWx4eEMveEtDWlN1dXk5?=
 =?utf-8?B?VmxQaEt1TlFiR3huN0NtRk4wTnFaSVVSb0J3WCtseGRKeHdrUVgvRkhvNy9L?=
 =?utf-8?B?cXJQaFZsQzFScDhOcE1aUjFwTHJxdnFlaVVvdkxBTjRpK3M2MXBLeUVsbTVH?=
 =?utf-8?B?SW5YUVRrQVFRZXExa2xtYUhON2lZbUh0YmZkdjJKS21POXJlSmcvWGkzYk9G?=
 =?utf-8?Q?2tupTx5obKkh/wAg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e051395-fad6-4367-0574-08de51837b7d
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 02:37:08.9140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CvqalWEmoQPnhOVcRZ5A0wTwO6tBW7ywKKPcLxZrBH3xjpe5i5omRszjl1/gUkLXhWgvNFEog+3z6VFPNCeGYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8426
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 2F12240008
X-Rspamd-Server: rspam06
X-Stat-Signature: nq4xaqpwmrd33d835zb7b658rzihcfnw
X-Rspam-User: 
X-HE-Tag: 1768185432-291915
X-HE-Meta: U2FsdGVkX19KV1Fpchul5XV5mol0spIVwS0Pu+RB1zm3/p2XApJMiXQgAzFwv6rLiiseMPH+1nzUpbav5UuooSrOLE9hiCcpTuDJsQTadEQteup0u9IvCFwmhK6jOyi5SaP3MwJNsZUW+nzqDX+1xeKtMTj6z35ehLZ+UF1vof1bE5NKg0T5dUKzdOS3GiDEYhpxC+GqMr1jF06hZhVLljk6/SMYDR04wDExAn8VebKTx31GbyB+JCu86fSpxlP8nLZsAyzrPpgwKRNW4UH+iT779iJKShVqjTkho3qxllCc6Q5w12Pd1f2MpovO8VKl4FMS/ETZG9Dkxw/Fu+n177BMfpMQz+9JWKpnssZUUSBGrGTQyPkXINS02LkmlYc6BGRsLDeRUK+rIWSj7Z+xw72KGS2LjeGR9ApkGIaZnLScxNUUc5tAmizPEWVjwhyPeuIvtEad3py1+5f6V+LeM1KRlAuDSxTaCk7cWTEBkDWshPpHEZ+ZeRPMXZTJaEOcc5sQD3C5DxKIeccHGnY6esgiLb/k5bt872ZXjIyniiceNg4ufPUrrCw/QmUwfcI4/+leysWgu8Z7LpK10df2KFJw9/8WAknVFTZYjAsz3hDEx7SBQvplw1bU5EipoaqZIIHsPq8ATk4pqBYzMBKs74C05uv1w3IO6TvoYrkLbp2a4Ha71N03DpEwkO7zx6FkJoMBWv7NdG8+InxNnkqQbP4BigO/CHpMP9F2TN6kHWdQBhir4dhd69lBw8qubstynmLYO7+barAtJEjEs8lBqky4cQaX8H+tXvMWDo/v1PJnz5M9t3SJ0uuGYNgZ5Dt9LxFS7ds5YMO3LxN+06ThV4Jr8IYoItoW1vbfegGL+uBspG0UTGzn4zRQ/pKIZd2vQ56TzrtO8m41NbhSc+UVeXEbR78vZZYZ2Qn6uWm45BXtrhVllajUJZDZ7vfBwOfsUXRrLYRpyi5lMXI2LJI
 zv0c3CKu
 dDCoypk/2+M463fr6HD+FLOSlOkkC64Rik12cVyOW74yupwnpA2th9b0hsAIg4PIgVFXwyy79lcqSuL2bErU7g3RIJZWX6zkcel9Oov22bLY4DxllK/ccl5T/8Ot/2w3uUUpq0IsfgHhd6h+IbB8gBxM2cMzoa/7bDifIEwZR4GAiZHkG1Q9FgJamcVW2/xKTzLMQurdSCGFA0s0l34P9NQsGZcsV+RjXVARABsC+RfNVg+2W1oBSw9+VdrhjXcaD5QsaQ8pJqSIzv8pEuuGf/xz3IWu47cFAx3KBCwCj+i8jK9WNfk/AFqk1xpZoD2tdq4WBwEhwdHRggB6/4KAf9GPbe0SRqlw/YsnvQet4/Y8mW1ROkWQ016JAPn2ElQ1PWegv2blmicb8rXJQV8iTjP96aCG40drlOo5WUymQk4CCyGcsG+U2YTtsTSuyk2WlRbZm23nkqAiJREB71bmYzSKSKyHddcM+2NfMP2EUe3Dd5PhfapdB4f/gtzsrWd/TKZxQ/7tZbXagQjTihvoQdAPMoAaPJfn7wxe6y1knN0bFiYLQwoP39CDoET5zBruvlf1/RPFqOukYJ2bHBsK38/+AaUxolV7oqKr+eVSfo2job1Q8V2mAWgQCtqH4fZqzk/CeVZLJRfJmwcpR/eZ9UqubJw6dx/f6fsV7zMiWisY2mdkL8iBqcBHZSltBsuWHyE+ni5xJb0u95JHq7n7mk4x5Zv30m35FRGM501/4m0elzN2JE+YFP+rTiA2/U5E/sOfUxh1jnOLzgNDsmKIvte32giw8mnTMdvwoS69PTKVIL6cKyslupvvaAtZ6uxfM4QN6CZcSXyFiRT34JhsttFMagc42ECx0T4IGukmvgKELCmv3qgXpUni6Fs7EIYqcLrmea5UddicE1xLy7sgTUUGeBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 01:15:12PM +1100, Balbir Singh wrote:
> On 1/12/26 11:16, Matthew Brost wrote:
> > On Mon, Jan 12, 2026 at 11:44:15AM +1100, Balbir Singh wrote:
> >> On 1/12/26 06:55, Francois Dugast wrote:
> >>> From: Matthew Brost <matthew.brost@intel.com>
> >>>
> >>> Add free_zone_device_folio_prepare(), a helper that restores large
> >>> ZONE_DEVICE folios to a sane, initial state before freeing them.
> >>>
> >>> Compound ZONE_DEVICE folios overwrite per-page state (e.g. pgmap and
> >>> compound metadata). Before returning such pages to the device pgmap
> >>> allocator, each constituent page must be reset to a standalone
> >>> ZONE_DEVICE folio with a valid pgmap and no compound state.
> >>>
> >>> Use this helper prior to folio_free() for device-private and
> >>> device-coherent folios to ensure consistent device page state for
> >>> subsequent allocations.
> >>>
> >>> Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
> >>> Cc: Zi Yan <ziy@nvidia.com>
> >>> Cc: David Hildenbrand <david@kernel.org>
> >>> Cc: Oscar Salvador <osalvador@suse.de>
> >>> Cc: Andrew Morton <akpm@linux-foundation.org>
> >>> Cc: Balbir Singh <balbirs@nvidia.com>
> >>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >>> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> >>> Cc: Vlastimil Babka <vbabka@suse.cz>
> >>> Cc: Mike Rapoport <rppt@kernel.org>
> >>> Cc: Suren Baghdasaryan <surenb@google.com>
> >>> Cc: Michal Hocko <mhocko@suse.com>
> >>> Cc: Alistair Popple <apopple@nvidia.com>
> >>> Cc: linux-mm@kvack.org
> >>> Cc: linux-cxl@vger.kernel.org
> >>> Cc: linux-kernel@vger.kernel.org
> >>> Suggested-by: Alistair Popple <apopple@nvidia.com>
> >>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> >>> Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> >>> ---
> >>>  include/linux/memremap.h |  1 +
> >>>  mm/memremap.c            | 55 ++++++++++++++++++++++++++++++++++++++++
> >>>  2 files changed, 56 insertions(+)
> >>>
> >>> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> >>> index 97fcffeb1c1e..88e1d4707296 100644
> >>> --- a/include/linux/memremap.h
> >>> +++ b/include/linux/memremap.h
> >>> @@ -230,6 +230,7 @@ static inline bool is_fsdax_page(const struct page *page)
> >>>  
> >>>  #ifdef CONFIG_ZONE_DEVICE
> >>>  void zone_device_page_init(struct page *page, unsigned int order);
> >>> +void free_zone_device_folio_prepare(struct folio *folio);
> >>>  void *memremap_pages(struct dev_pagemap *pgmap, int nid);
> >>>  void memunmap_pages(struct dev_pagemap *pgmap);
> >>>  void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
> >>> diff --git a/mm/memremap.c b/mm/memremap.c
> >>> index 39dc4bd190d0..375a61e18858 100644
> >>> --- a/mm/memremap.c
> >>> +++ b/mm/memremap.c
> >>> @@ -413,6 +413,60 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn)
> >>>  }
> >>>  EXPORT_SYMBOL_GPL(get_dev_pagemap);
> >>>  
> >>> +/**
> >>> + * free_zone_device_folio_prepare() - Prepare a ZONE_DEVICE folio for freeing.
> >>> + * @folio: ZONE_DEVICE folio to prepare for release.
> >>> + *
> >>> + * ZONE_DEVICE pages/folios (e.g., device-private memory or fsdax-backed pages)
> >>> + * can be compound. When freeing a compound ZONE_DEVICE folio, the tail pages
> >>> + * must be restored to a sane ZONE_DEVICE state before they are released.
> >>> + *
> >>> + * This helper:
> >>> + *   - Clears @folio->mapping and, for compound folios, clears each page's
> >>> + *     compound-head state (ClearPageHead()/clear_compound_head()).
> >>> + *   - Resets the compound order metadata (folio_reset_order()) and then
> >>> + *     initializes each constituent page as a standalone ZONE_DEVICE folio:
> >>> + *       * clears ->mapping
> >>> + *       * restores ->pgmap (prep_compound_page() overwrites it)
> >>> + *       * clears ->share (only relevant for fsdax; unused for device-private)
> >>> + *
> >>> + * If @folio is order-0, only the mapping is cleared and no further work is
> >>> + * required.
> >>> + */
> >>> +void free_zone_device_folio_prepare(struct folio *folio)
> >>> +{
> >>> +	struct dev_pagemap *pgmap = page_pgmap(&folio->page);
> >>> +	int order, i;
> >>> +
> >>> +	VM_WARN_ON_FOLIO(!folio_is_zone_device(folio), folio);
> >>> +
> >>> +	folio->mapping = NULL;
> >>> +	order = folio_order(folio);
> >>> +	if (!order)
> >>> +		return;
> >>> +
> >>> +	folio_reset_order(folio);
> >>> +
> >>> +	for (i = 0; i < (1UL << order); i++) {
> >>> +		struct page *page = folio_page(folio, i);
> >>> +		struct folio *new_folio = (struct folio *)page;
> >>> +
> >>> +		ClearPageHead(page);
> >>> +		clear_compound_head(page);
> >>> +
> >>> +		new_folio->mapping = NULL;
> >>> +		/*
> >>> +		 * Reset pgmap which was over-written by
> >>> +		 * prep_compound_page().
> >>> +		 */
> >>> +		new_folio->pgmap = pgmap;
> >>> +		new_folio->share = 0;	/* fsdax only, unused for device private */
> >>> +		VM_WARN_ON_FOLIO(folio_ref_count(new_folio), new_folio);
> >>> +		VM_WARN_ON_FOLIO(!folio_is_zone_device(new_folio), new_folio);
> >>
> >> Does calling the free_folio() callback on new_folio solve the issue you are facing, or is
> >> that PMD_ORDER more frees than we'd like?
> >>
> > 
> > No, calling free_folio() more often doesn’t solve anything—in fact, that
> > would make my implementation explode. I explained this in detail here [1]
> > to Zi.
> > 
> > To recap [1], my memory allocator has no visibility into individual
> > pages or folios; it is DRM Buddy layered on top of TTM BO. This design
> > allows VRAM to be allocated or evicted for both traditional GPU
> > allocations (GEMs) and SVM allocations.
> > 
> 
> I assume it is still backed by pages that are ref counted? I suspect you'd

Yes.

> need to convert one reference count to PMD_ORDER reference counts to make
> this change work, or are the references not at page granularity? 
> 
> I followed the code through drm_zdd_pagemap_put() and zdd->refcount seemed
> like a per folio refcount
> 

The refcount is incremented by 1 for each call to
folio_set_zone_device_data. If we have a 2MB device folio backing a
2MB allocation, the refcount is 1. If we have 512 4KB device pages
backing a 2MB allocation, the refcount is 512. The refcount matches the
number of folio_free calls we expect to receive for the size of the
backing allocation. Right now, in Xe, we allocate either 4k, 64k or 2M
but thia all configurable via a table driver side (Xe) in GPU SVM (drm
common layer).

Matt

> > Now, to recap the actual issue: if device folios are not split upon free
> > and are later reallocated with a different order in
> > zone_device_page_init, the implementation breaks. This problem is not
> > specific to Xe—Nouveau happens to always allocate at the same order, so
> > it works by coincidence. Reallocating at a different order is valid
> > behavior and must be supported.
> > 
> 
> Agreed
> 
> > Matt
> > 
> > [1] https://patchwork.freedesktop.org/patch/697710/?series=159119&rev=3#comment_1282413
> > 
> >>> +	}
> >>> +}
> >>> +EXPORT_SYMBOL_GPL(free_zone_device_folio_prepare);
> >>> +
> >>>  void free_zone_device_folio(struct folio *folio)
> >>>  {
> >>>  	struct dev_pagemap *pgmap = folio->pgmap;
> >>> @@ -454,6 +508,7 @@ void free_zone_device_folio(struct folio *folio)
> >>>  	case MEMORY_DEVICE_COHERENT:
> >>>  		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
> >>>  			break;
> >>> +		free_zone_device_folio_prepare(folio);
> >>>  		pgmap->ops->folio_free(folio, order);
> >>>  		percpu_ref_put_many(&folio->pgmap->ref, nr);
> >>>  		break;
> >>
> >> Balbir
> 

