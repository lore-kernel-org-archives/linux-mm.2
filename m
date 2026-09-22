Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9832C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 21:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEF826B0088; Tue, 22 Sep 2026 17:23:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA07E6B008A; Tue, 22 Sep 2026 17:23:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40C66B008C; Tue, 22 Sep 2026 17:23:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80FF16B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:23:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E18F01C3243
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 21:23:48 +0000 (UTC)
X-FDA: 85242675336.23.EC22E0E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.6])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4847DC000C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 21:23:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LHgtG8S5;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ehab.ababneh@intel.com designates 192.198.163.6 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790112225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N/C6kRPziJcXsm0NdOa6SrcMkM14+78Qk82X2Ljp7tk=;
	b=KgG5dAYZm3y17w9RFiI8snnNN40l/+k0AmJUiz9TwxWGH9foISRoCqogOXBc3w8xqnPUYT
	13zkHdVqXNRoGJ+vnruBapzmQFRQbzFJ3XzADBkR9eh+bGF9U5FnOfBqTvico296XTdaIm
	TJys+vAHJJc7SCCAo4dc1j+5ieLYSVg=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LHgtG8S5;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ehab.ababneh@intel.com designates 192.198.163.6 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790112225;
	b=dVV8rboZtgENjhKlIpWytnejUEHvvaTcNQpDQEhlDuFsO1jTMxjy/xcrphmraQJm3yYKuY
	k/YLuhi6lmTsB64q/HsPz2a/I8fUXMi2KVvLUvOdewbZI3rgK5NIAO9hFrBfOIf5HGEMkM
	mwdNl8NjjpDhso/n+M97Fn0Cqd7WSsU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790112224; x=1821648224;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N/C6kRPziJcXsm0NdOa6SrcMkM14+78Qk82X2Ljp7tk=;
  b=LHgtG8S5YUPsTTkMJ2Zn3M+7EqU6A2wDYOFtBKbnrLryRcrI+H8uoWdv
   rbUjzO8w6sP7ncWpxMpXjlAnEolH71X2cN3Wn9t9SgAtpcUbNf5mOnlZl
   id4p0j5o7JKcFmJqlPzaNLF1vdZ9ugiE88FwuHAGH6wN17YBBi9MVNhqz
   Um2TjA5UJTYQEDR9fe+apSGFkFSGfbV+pa7UIX2NnI5ruvahhcHKW14f/
   QxsFkxLcIGFR8U81ZOdnT4kzVpyRVIWdP4J0W/QgJqxDysdO9LhSMjB/m
   FsHVrSQ5tJmSbhkj84vPdWwr7ibsvtG25qLqm7Rv3+F6B8Cp8mqjyVzBj
   g==;
X-CSE-ConnectionGUID: FKqyqgdXRVCUdnYN2vov8Q==
X-CSE-MsgGUID: qI5jTrIXSOaLtMv8c+onQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="1255920"
X-IronPort-AV: E=Sophos;i="6.27,117,1787036400"; 
   d="scan'208";a="1255920"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa116.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 14:23:42 -0700
X-CSE-ConnectionGUID: 5H00D99yR7q7q+/m/PBwQA==
X-CSE-MsgGUID: kyttJCNMTaa9M34h842Hyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,117,1787036400"; 
   d="scan'208";a="272798133"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 14:23:42 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 22 Sep 2026 14:23:42 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 22 Sep 2026 14:23:42 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.64) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 22 Sep 2026 14:23:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fo2s/YO2IKcFtHwcq1hKMjV3oz2R0kIMPFpOqUNUl2iTg/1YK1Lr5hNDfmQBhYwik5eESrKlwTy2gGmEeAnLysYrf81i/rgQAhy7nFBtm1pyVRVV4I0btVH0qgvpCYCraDEojaypOk0QTWudS8s3ubWoi7Qhjv6PseE4cvx+eMQp0pS96keuEypdHHZtr+NB4Cql7y/AFZETSbCzO2DBRlKPYGHcGOW087PISCaobzGTvDBlXbtim8kYM2CS11anVoLSmE4yD/4g/sHMcFLAEZqRxWSusj/owIPxdSD98/uWX7wfecC+VyURD4IueQw5o8zhLaaRxO5JGtPynupdIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N/C6kRPziJcXsm0NdOa6SrcMkM14+78Qk82X2Ljp7tk=;
 b=hdIoG0EGhaJH37Gaur0Tkx/GlBYD0+NDwsaLrtBwliz2Ewu0iZ/ZGtoqgauMCYEVZOcBsaUwn9kntBgjgRLR7rS+NWyzW8OvWa3Xqk1zkoE9Gex4KMPImquUmaUQw40ZOsxmVxeE2vekun24crDzu+6AzbwpKQB4GSaExibGRoKd8NOuKQyCxxoPtFMmmc4ZwBifF1gU6vLdvim35VmeuhDJXT6++hEAn0S2uuhJSn6JJinzgemWU7ecHHa53L/And+p78fS4ntKRQeegNcARbRjbx59JrQ2qd9maRJx4jRvBTSi9MYKaUFn9B3fBLGI601F/nPT5MHCAT/YfcxDBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6105.namprd11.prod.outlook.com (2603:10b6:a03:48c::21)
 by PH7PR11MB7450.namprd11.prod.outlook.com (2603:10b6:510:27e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Tue, 22 Sep
 2026 21:23:37 +0000
Received: from SJ1PR11MB6105.namprd11.prod.outlook.com
 ([fe80::28d9:5273:4572:320d]) by SJ1PR11MB6105.namprd11.prod.outlook.com
 ([fe80::28d9:5273:4572:320d%5]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 21:23:37 +0000
From: "Ababneh, Ehab" <ehab.ababneh@intel.com>
To: Zi Yan <ziy@nvidia.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Buddy Lumpkin <buddy.lumpkin@oracle.com>, Andrew Morton
	<akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, Qi Zheng
	<qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Barry Song
	<baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>
Subject: RE: [RFC PATCH 0/3] mm/vmscan: adaptive multi-threaded kswapd for
 NUMA-aware reclaim
Thread-Topic: [RFC PATCH 0/3] mm/vmscan: adaptive multi-threaded kswapd for
 NUMA-aware reclaim
Thread-Index: AQHdQAFFhkBvlAlqKUOVsJtCxlm1AbbbMLmA
Date: Tue, 22 Sep 2026 21:23:37 +0000
Message-ID: <SJ1PR11MB6105E073723CFEEE8C8EDBF48C832@SJ1PR11MB6105.namprd11.prod.outlook.com>
References: <20260908221059.14777-1-ehab.ababneh@intel.com>
 <DLAFA5J0PEF4.147CJ8RMCNAFY@nvidia.com>
In-Reply-To: <DLAFA5J0PEF4.147CJ8RMCNAFY@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6105:EE_|PH7PR11MB7450:EE_
x-ms-office365-filtering-correlation-id: b5202241-b13d-429a-0ada-08df18efc403
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|23010399003|376014|38070700021|10067099003|6133799003|56012099006|11063799006|18002099003|22082099003|4143699003;
x-microsoft-antispam-message-info: Hfuy7SZJCNq+cvESVAS4VW8M0qCRe0G6NCIrtwK1qLdwlafiWVSbFWrgJryxYPCjflbJMPGTNOmd/njY1qnJYqo/d30mtgzZN66ipbCkJinBfHRnFgqIe0ts49C58NujVQqwxpFh5/uZG1jqo+hnRuVXsMqPUXhhvQ1T4E99xhdSQ4zl1WZ8mmH+U8Yx5TMhltLDIge2EOx7rjJ41yRmJ1nSNzZFkaibfzZTFIWbokyo+wwUFcgtwYlbKn/bGBo66A7hfbV4/HgaR+amktXnYU8HjmYmkfN2xjyMRJQic1Eo+X/BHBzk03gmP+ZaUIno/edJa9WhhMqkalKjJsdNn21odJ9fMHHBOToCvHtDNsA/j/RiWT9tcIpbhQLviKIksfmyA4ULNbSvQClGdAPHULIvOuySQ4bAlAcKjtNgzdtiq9KjuEn36E4cUopxaostoDiTbq+k6va1mmueh9P20KU46peSNeZNymQ/KAvK0dx0z+mtPF4wQE5VBFpohD/ehYfIpVwdJ6VTaTvBW0JIGOnaFJM+zGeBZKQpJuyqNrxdYYx7Wb/7WCqeF6ucbiWaIwGGk0wBglDCJw623k/CW6zvCkRJxgQkp78rcHgOtSkSZ+wdRp8+jndnHoaw7E6w8z8DeYRILUoWaDUrHcgDBaHtUfIgoaOmgaM5NzkymxcXTsKYArRq7uhKYiblCg6S9b0tqKn7KUC2ctz2IkEnyzrds82piYDCF3JcPrE/taU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(23010399003)(376014)(38070700021)(10067099003)(6133799003)(56012099006)(11063799006)(18002099003)(22082099003)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UTFnMnkvdVV0ZGJKRXdKL1lBRlFqb2o2OGtWQ0F6RlNYbGUwa1I3Z0VTRHYz?=
 =?utf-8?B?aDhWVzNQY00wWFBuS0hmYk1lQWV3YkUvL01heHBnMStSRDBRMnlJTEV5bW5H?=
 =?utf-8?B?TU45WDgxTEk0TVRHZTJMTDJydnhJdU43c1RnN2IxT2grMTc5dGQyOVFLWnZ0?=
 =?utf-8?B?UGUxMEVIVE5JZThaMGNZSE5Bbktya3JoaWhVQStGSFJWNTVFWlVsNmNZRFFY?=
 =?utf-8?B?aExyU1o1cnBDOEduMlVmVG95enMwaDJaUk1tSjBWUjRLTEgzSCtJdFY3RU81?=
 =?utf-8?B?d1pkd3dwQ0lFbVJHM2RmenlWOG5kM05RRHRESG1Tbm1yWUdXUDJEY0dVdWx5?=
 =?utf-8?B?VG1yR1A4RkNYMmtNdzNManNkbFBZUGpwT1UzaGFhQUpITGZZUFlmcExLWStt?=
 =?utf-8?B?dElTQ05HSW8wcm5weVFwcFRGVERIRnl4cjZ2RVY0YmF5Q0xuUjFKNlVCSHNw?=
 =?utf-8?B?ZWx0cGE0UU9sZXdVWDlZaUNvRWxTSnd6Z1FwSFdpNlgrWUZxMWlTcndXeXhh?=
 =?utf-8?B?ZDJKTGExWUxXSUNDN1N4dFFtZ2hXN1JGdTFMTGFnQjVBS09vT3l4UzZZS3Fy?=
 =?utf-8?B?NTQ0VC9Ea01hYTlvOEd2a3lDZGhmdWhycWlRcmJaVHp1VFNVSW54cUJPYksz?=
 =?utf-8?B?STBwY29iVnNMbE1hSEdIWTg5cHZ2TDZwSDFhOTJ1M2Rsb2J2MWVjTkhZREVP?=
 =?utf-8?B?STI5ZENzRmUzMXdpQVFROUpiR2tVU2J6Q1BvVDhESkhVdFlXbDZLMGJTQXdB?=
 =?utf-8?B?d3d6UnZCTURLRWlnZWZVN0pqeWZ6Rzl6Z2s2OXE0TjBKVGNjOGVMRGlZRHE1?=
 =?utf-8?B?OE9vUStSS1VEVjBIKzNBRlpBanJZNmlRQkliamR5alBHMkU4bGVEYWEzcWhV?=
 =?utf-8?B?SnF2eWxrRWxCN0dYaytyTExPMzBLMTFiT2h5bEZsRS9TMzdqR0VUUEJrR0F5?=
 =?utf-8?B?ejdIS1dwTzRrZ2Vnb2FVellBMFNpUkFKNXdGVDlIalN2SnJtWFp1ZmFJeXV3?=
 =?utf-8?B?WW50bklLYXBsYXYrMWlLN1N1bkErZ0RVcHp6eFlEc0dmZHplZHhYZXh1R2RV?=
 =?utf-8?B?M0tEc0dCM0ZwbkxjREZlWDhlY0IrbHc1WXA3WTJDcHNUU3NhN240WWtUcnJr?=
 =?utf-8?B?d3lNQXBENzNqQ0owNDR2cDdPYTdvQ0kvZ1BreUx3NkVTd3R2SHNVaE5ZcTNw?=
 =?utf-8?B?cTYxQS9IVEx2UUN3SzRqdXNRN0NucjFzTStZTDVaZHlIajhIaHg2RzJBNndR?=
 =?utf-8?B?UExWd1A0Tjd5a0hONnpXWTVSTTVTVGpiMHNMUER2Ym9ON2ZqOUN6ajZqRlR4?=
 =?utf-8?B?bmZZNmtYbkU0RnpVWXlqK3prdkhYWTVuWWp3YlhNOEc4YzBQSHdNNWM0ZUpI?=
 =?utf-8?B?MGRNRkJJZ1RDQlU2eGhoZ3hLaGVCUkl2MVY1dThWYjhxd25NbjdZWUxFTmN1?=
 =?utf-8?B?VHNpRWszYVRTZU1POTI5Uk1ZUnZuTDh2ZUhyTWNlU0tmMWplOHRwRFM2VGVJ?=
 =?utf-8?B?ckl5bmxTcUYzN3FuVEdtVmI1WmtUeklCSVU0T3YrTk41N0Rsaml4MVcyUjVX?=
 =?utf-8?B?NXNYZWg4bE5NbUdENWZRampQRkFJU1BkT3FsMmRzV0ZLRUliRTdNRThWQmhq?=
 =?utf-8?B?Z0o3QnNKVjZtMTNmekFQVmgzMHVCNDBLTVhKWVRVenlMbVhhQkxYRzkwYk1i?=
 =?utf-8?B?Rm1wcDY2RmhJaDM5RGZSdnpRZWhwbksrREsrbkV5Yy9UZnU1S3ZvaGZJSXp4?=
 =?utf-8?B?UVJmc3d1SmZkRXJLRjFoM1FKK0hReGMzQnEzY29mZEtWZEJmU3F4UWdLOWZF?=
 =?utf-8?B?dXU5ckYyVFlZUS8wUzdaVk5xN2h1N21qZGl6N0p0Vm5TTWo4eHF4cU84bElJ?=
 =?utf-8?B?UUZLQ0NaSnFrS2dzU2thV0lpbWNHcGZLZmdObFA0ZzlrSTdzblJpVmVlRXM1?=
 =?utf-8?B?YkUxdTdWMW1TRklIRnVBT2pmeC83ZWxBYXhsK1REeXZWT2JBQTI4c0dUN2Y3?=
 =?utf-8?B?L01UOEUxQW1RMWpNNWR2WmV5YktmSlBBdUJNTG1hcG9hUGdJSmZ4cmJQeEh4?=
 =?utf-8?B?Rk5NOXNlZEt5ekFXSGZxU0ZXakNVdDlTa01Ud3pOcUlSNTBQYVZta2ZlZTRr?=
 =?utf-8?B?Nm1heHA1enNjV2gxcFppc0xyeGFLbmFFZEtBTjZUak5GU0I0anV5a09rTVpj?=
 =?utf-8?B?TGlCU1d3ZHE0SmQxM0pSNXlGU3ZoR1BPdzdpTnI4MjRjNGFPd1JQbDM2Y1Uw?=
 =?utf-8?B?MmEzb3pBbjI3alRydnU5d2Z6Z3N2M2lPUVB0TFhHTGd2MWl4UlVyQlZKeENj?=
 =?utf-8?Q?Wu5iSBy1KiskMPdUkP?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: CcfgjK4KlrfR0xCnvrQ/UaE+2PDkop7/JuQHS/e9xi/f52GKQEEcTIsPWtio6sRd02yq3hjH7LG9I9ioTce7YpMifJ9hIaTjEacKGBLosJIWlanjO9mnbH5zDe6U+6gAYUYeEy9plGKp7ovwLsCbgWou30KV5QL0bd6a+i1Cr9ThZVnNNuGVadpBr1eMz2CEEArTnMnPmuJ7Ta51MYa2xGl3nJu4LQOL0kn6yLBpLZzmnDfvuiIWI02NQd5bUcmZqW5WPmIdeO7nsSxTbam1FU7B2Ntwn87RULpjIvfQDZGJ14sWzQQTkjKCCDjfz4xQ2s0iNqyl/DSRc5qYoU50pw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5202241-b13d-429a-0ada-08df18efc403
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2026 21:23:37.4640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZdYDE5mYi1HNWlXGhdOzcXYDk5mYmJVLEH0QxqHqmr0qo66dVCF15I/ETqAP20TUneEe6umbr05Je8+PfABXxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7450
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Stat-Signature: r9tnmec75p8mftpczfrfrj7ryquj57cp
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4847DC000C
X-HE-Tag: 1790112224-212601
X-HE-Meta: U2FsdGVkX18K+kyic12aVU8JD5bax/w5TqU0Mnh7Cx46OUTIopNWsyP/Yib2qw1XAqcMSa2w6q6utbM83qbOHMbrCgXteBZObvItDNrxtgifRfjeNMqXzIaKJ12ABfn3XR9ZpOtdPW/X+QxLhj+Fb55MObLekSgI2zJeJG8pLOcHh0d8icgUgXS1btLsazgeypXxEkGUAi1AL2lMFWtkDABW9cM60Udziiuka1YryaAVFCX4iH7zv7MBjZn8YjwvY8oB+wA7HGI3xRo+dWZV0RhZ/FdcHAEEatA4HDdmDmuKv+qGqui8xNK5KpgT5yGKqNlEC56htmBgriMthzyLoz0gJkgjHqerQLFzMcritnq1YgFoerdyrAgwb4FPrpdFnsl9GBKP9OO/fZ5tO/eL9Wyn+01w3STnmuUXZHHtqBm2snY0unuRExmikx9dxFiymKSGQ14DNw10jum3G77REp5WJlimIAsbaniXJN5a4aFCDABJhi13J+HKG2RC7Lj5/6At+g4ow6BLgI3n9LfAQIoZ+a+1iLVkbl6vC7ujBEtitq2t5K4cisYLkQy91SrHsFi8Y8e+lU2YosAXyyxu5QTYlkpHtShP8vrcKD+rN+tn2975ZTe2Bye6PlWJDogQe8+LJqT2sOrYhA3N5fKJQoJM1Yt51VE8a8zQX+5nX0T6ntfiCa5kIdVFclYwGDJ5Ch9EbfXysoK82Wf1ZL77sxbNj+6DXbT0INuxxji7d99JKCRI/tpbAd/RctFJeqF7zUdeJsQL383iF5niCUMn2d1slI/nZlBM9iGR7bTH5Wztl9nKMWF/AGHdU1TwncfeAOPqEpdRlFsjuBSK4cdbtV8LUmwkn025so61xrA5YY+jrZz4QsgPtRiPfZaPTdqR1vtdEuyAFJNV59PG6zKrgCLRYcumqEo5H89f7K0sKyPTDAvrIye9su4G+hUr70OaDmJYNhOpsMeR0wY9Vya
 qyh0ysBG
 nsPLGQCW56uM/kDIDDUvVosQrlFRDT3Jxl2Tl5fkvvSBECVlBmagGfVZMTQIdQQeaznjrFjo98lbEjJ4IFpvUDlRGf9wDRv9z+RyRrjQeaIr8ObVXBDXe3T/bjsF9soWYpDxs4C14oSNKLslDtqFiG7tW/EHQP5buytXCuWf05Z4qufnK+Zf7gr3KREAqnOEKLcVcka3veJV8dNUtHv6YMeIgEsjkSY1jaQz0ciRmqHGd/2yTSSgm6TyAyD0JZlelL0jk6Ne4e+6CkNCzQ5rHtd5qcFPiISA/9pnaU7gSuZTABFN5MTeNlV947BPAOZNnyPy9HzW5zShgOtrcM0VEFKiycY3+dX6i6CbBNkLOG8rLv6kYh0Ak3zX7QNjHahPzvOkcxXN3ozJMJ5meOYexmcPSYdsF4EKRn1skMEa3kb3lIilcGoTc7Dduh0nyvPmMogIh5Q3t0bizzOoogMM44px4cqKH9gJ4ev3VFnpTunEx67wWSAVW/XWpDOduT2i0FbNfh/FRs/clkfdQ+I8RAmWS4HSNIdED5BlpUWW3ztZBXr7+aCwRMKLzGG466KfaImy2nVQFmG+UGdrpT9R4RNhMipc83eqvmaZc13m9u72FKkMnBPH9pLP7h/+s7TURHczD37eEOxLPn2gs1zNsTfkdqylCoVYR276qG5TzmXKOrBgVpsl8BdoiBN4k2aYIW65LhECljWNZ7pSLmMItYtsQ4ruVEEqxDink4J4UuA+fNII9zoV9oxLgFNasABn+Pf3ZrdxfnNX+dGl2JRCNWpiGPS8aeUa7E8qevisV8NabjNmGWgK+h4xxVIqQuWkpaZDuuMnTs6G/a1iZFTG+wmAKlKdbZCyBm5gc6B7K+oqino46thYHb1SF73tK6es/cCjVBFQ5EgbuE8atFR7dWT90uU31GokGkdQfHkm1HtxNhwS6rG/RYJmHlIIGdBOmP41d0KBwPW5NWVbwnHSCB+psbPzz
 8OHNgGuO
 0afkwQyaSSooJ4diOwlJEI8g7mJKiWNOPE6n70BHlB4FS0u2mIMK0IkRKPVQxOuss5hGFvF0aEw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogWmkgWWFuIDx6aXlAbnZp
ZGlhLmNvbT4NCj4gU2VudDogVHVlc2RheSwgU2VwdGVtYmVyIDgsIDIwMjYgNzoxNiBQTQ0KPiBU
bzogQWJhYm5laCwgRWhhYiA8ZWhhYi5hYmFibmVoQGludGVsLmNvbT47IGxpbnV4LW1tQGt2YWNr
Lm9yZzsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IEJ1ZGR5IEx1bXBr
aW4gPGJ1ZGR5Lmx1bXBraW5Ab3JhY2xlLmNvbT47IEFuZHJldyBNb3J0b24NCj4gPGFrcG1AbGlu
dXgtZm91bmRhdGlvbi5vcmc+OyBLYWlydWkgU29uZyA8a2Fzb25nQHRlbmNlbnQuY29tPjsgUWkg
WmhlbmcNCj4gPHFpLnpoZW5nQGxpbnV4LmRldj47IFNoYWtlZWwgQnV0dCA8c2hha2VlbC5idXR0
QGxpbnV4LmRldj47IEJhcnJ5IFNvbmcNCj4gPGJhb2h1YUBrZXJuZWwub3JnPjsgQXhlbCBSYXNt
dXNzZW4gPGF4ZWxyYXNtdXNzZW5AZ29vZ2xlLmNvbT47DQo+IFl1YW5jaHUgWGllIDx5dWFuY2h1
QGdvb2dsZS5jb20+OyBXZWkgWHUgPHdlaXh1Z2NAZ29vZ2xlLmNvbT47IERhdmlkDQo+IEhpbGRl
bmJyYW5kIDxkYXZpZEBrZXJuZWwub3JnPjsgTG9yZW56byBTdG9ha2VzIDxsanNAa2VybmVsLm9y
Zz47IExpYW0gUi4NCj4gSG93bGV0dCA8bGlhbUBpbmZyYWRlYWQub3JnPjsgVmxhc3RpbWlsIEJh
YmthIDx2YmFia2FAa2VybmVsLm9yZz47IE1pa2UNCj4gUmFwb3BvcnQgPHJwcHRAa2VybmVsLm9y
Zz47IFN1cmVuIEJhZ2hkYXNhcnlhbiA8c3VyZW5iQGdvb2dsZS5jb20+Ow0KPiBNaWNoYWwgSG9j
a28gPG1ob2Nrb0BzdXNlLmNvbT47IEJyZW5kYW4gSmFja21hbg0KPiA8amFja21hbmJAZ29vZ2xl
LmNvbT47IEpvaGFubmVzIFdlaW5lciA8aGFubmVzQGNtcHhjaGcub3JnPg0KPiBTdWJqZWN0OiBS
ZTogW1JGQyBQQVRDSCAwLzNdIG1tL3Ztc2NhbjogYWRhcHRpdmUgbXVsdGktdGhyZWFkZWQga3N3
YXBkDQo+IGZvciBOVU1BLWF3YXJlIHJlY2xhaW0NCj4gDQo+IE9uIFR1ZSBTZXAgOCwgMjAyNiBh
dCA2OjEwIFBNIEVEVCwgRWhhYiBBYmFibmVoIHdyb3RlOg0KPiA+IFRoaXMgc2VyaWVzIHJldml2
ZXMgQnVkZHkgTHVtcGtpbidzIGVhcmxpZXIgbXVsdGkta3N3YXBkIHByb3Bvc2FsOg0KPiA+IGh0
dHBzOi8vbGttbC5pdS5lZHUvaHlwZXJtYWlsL2xpbnV4L2tlcm5lbC8xODA0LjAvMDAzNDIuaHRt
bA0KPiArb3RoZXJzDQo+IA0KPiBQbGVhc2UgQ2MgZXZlcnlvbmUgaW4gdGhlIGNvdmVyIGxldHRl
ciwgc28gcGVvcGxlIGNhbiBrbm93IHRoZSBtb3RpdmF0aW9uIG9mDQo+IHRoZSBwYXRjaHNldC4N
Cj4gDQo+ID4NCj4gPiBUaGUgbW90aXZhdGlvbiBpcyBzdHJvbmdlciBub3cgdGhhbiB3aGVuIHRo
ZSBwYXRjaCB3YXMgZmlyc3QgZGlzY3Vzc2VkLg0KPiA+IE1hbnkgY3VycmVudCBzeXN0ZW1zIGhh
dmUgaHVuZHJlZHMgb2YgY29yZXMgcGVyIE5VTUEgbm9kZSwgbm90IHRoZQ0KPiA+IHNpbmdsZS1k
aWdpdCBvciBsb3ctdGVucyBjb3JlIGNvdW50cyB0aGF0IHdlcmUgbW9yZSBjb21tb24gYXQgdGhl
IHRpbWUuDQo+ID4gV2hlbiByZWNsYWltIGRvZXMgbm90IGtlZXAgdXAsIGRpcmVjdCByZWNsYWlt
IGNhbiBzdGlsbCBwdXNoDQo+ID4gYWxsb2NhdGlvbiBsYXRlbmN5IGludG8gYXBwbGljYXRpb24g
cGF0aHMgYW5kIGxlYXZlIHN1YnN0YW50aWFsIENQVQ0KPiA+IGNhcGFjaXR5IHdhaXRpbmcgZm9y
IG1lbW9yeSB0byBiZSBmcmVlZC4NCj4gPg0KPiA+IFRoaXMgcGF0Y2hzZXQgYWRkcyBhZGFwdGl2
ZSBtdWx0aS10aHJlYWRlZCBrc3dhcGQuIFRoZSB3YWtldXAgcG9saWN5DQo+ID4gdXNlcyBub2Rl
IGxvYWQgdG8gZGVjaWRlIGhvdyBtYW55IGtzd2FwZCB3b3JrZXJzIHRvIHJ1biwgc28gcmVjbGFp
bQ0KPiA+IGNhbiBzY2FsZSB3aGVuIGl0IGhlbHBzIGFuZCBzdGF5IGNvbnNlcnZhdGl2ZSBvbiBh
bHJlYWR5IGJ1c3kgbm9kZXMuDQo+ID4NCj4gPiBTZXJpZXMgc3VtbWFyeToNCj4gPg0KPiA+IDEu
IEFsbG93IG11bHRpcGxlIGtzd2FwZCB0aHJlYWRzIHBlciBub2RlIGFuZCBhZGQgY29udHJvbCBw
bHVtYmluZy4NCj4gPiAyLiBXYWtlIGFuIGFwcHJvcHJpYXRlIG51bWJlciBvZiBrc3dhcGQgdGhy
ZWFkcyBmcm9tIHBlci1ub2RlDQo+ID4gICAgcnVubmFibGUgbG9hZC4NCj4gPg0KPiA+IENvbmNl
cm5zIGZyb20gdGhlIG9yaWdpbmFsIGRpc2N1c3Npb24gYW5kIGhvdyB0aGlzIHNlcmllcyBhZGRy
ZXNzZXMNCj4gPiBzb21lIG9mIHRoZW06DQo+ID4NCj4gPiAtIENvbmNlcm46IERpcmVjdCByZWNs
YWltIGlzIGludGVuZGVkIHRvIHNsb3cgYSBtZW1vcnktaG9nZ2luZyB0aHJlYWQuDQo+ID4gICBS
ZXNwb25zZTogVGhhdCBjYW4gYmUgYWNjZXB0YWJsZSBvbiBsb3dlci1jb3JlIHN5c3RlbXMuIE9u
IGhpZ2gtY29yZQ0KPiA+ICAgc3lzdGVtcywgaWRsaW5nIG1hbnkgY29yZXMgd2hpbGUgcmVjbGFp
bSBjYXRjaGVzIHVwIGNhbiBjb3N0IG1vcmUgdGhhbg0KPiA+ICAgYWxsb3dpbmcgcmVjbGFpbSBw
YXJhbGxlbGlzbSB0byBzY2FsZS4gSXQgY2FuIGFsc28gYmxvY2sgaGlnaGVyLXByaW9yaXR5DQo+
ID4gICB0YXNrcyBpbiBkaXJlY3QgcmVjbGFpbSB3aGlsZSB0aGV5IHBlcmZvcm0gcmVjbGFpbSB3
b3JrIG9uIGJlaGFsZiBvZg0KPiA+ICAgbG93ZXItcHJpb3JpdHkgbWVtb3J5LWhvZ2dpbmcgdGFz
a3MuDQo+ID4NCj4gPiAtIENvbmNlcm46IE1vcmUga3N3YXBkIHRocmVhZHMgbWF5IGhpZGUgZGVl
cGVyIHJlY2xhaW0gaXNzdWVzLg0KPiA+ICAgUmVzcG9uc2U6IFRoaXMgc2VyaWVzIGlzIGFkZGl0
aXZlIHRvIG9uZ29pbmcgcmVjbGFpbSBpbXByb3ZlbWVudHMuIEluDQo+ID4gICBvdXIgdGVzdGlu
ZywgbXVsdGktdGhyZWFkZWQga3N3YXBkIHdhcyBhYmxlIHRvIGltcHJvdmUgcGVyZm9ybWFuY2Ug
b24NCj4gPiAgIHRvcCBvZiB3aGF0IG11bHRpLWdlbiBMUlUgYWxyZWFkeSBwcm92aWRlcy4NCj4g
Pg0KPiA+IC0gQ29uY2VybjogRXhpc3Rpbmcga25vYnMgKHN1Y2ggYXMgc3dhcHBpbmVzcyBhbmQg
d2F0ZXJtYXJrcykgc2hvdWxkIGJlDQo+ID4gICBwcmVmZXJyZWQuDQo+ID4gICBSZXNwb25zZTog
SW4gb3VyIHRlc3RpbmcsIHRob3NlIGtub2JzIGFsb25lIGRpZCBub3QgcmVsaWFibHkgaGl0DQo+
ID4gICBwZXJmb3JtYW5jZSB0YXJnZXRzIGFuZCBjb3VsZCBpbmNyZWFzZSBDUFUgY29zdCBmb3Ig
dGhlIHNhbWUgd29ya2xvYWQNCj4gPiAgIG9iamVjdGl2ZS4NCj4gPg0KPiA+IC0gQ29uY2Vybjog
TmVlZCBldmlkZW5jZSBmcm9tIHJlYWwgd29ya2xvYWRzLg0KPiA+ICAgUmVzcG9uc2U6IFRoaXMg
Y292ZXIgbGV0dGVyIGluY2x1ZGVzIENhc3NhbmRyYSByZXN1bHRzIHNob3dpbmcgaGlnaGVyDQo+
ID4gICB0aHJvdWdocHV0IGFuZCBsb3dlciByZXNwb25zZSBsYXRlbmN5Lg0KPiA+DQo+ID4gLSBD
b25jZXJuOiBNb3JlIHJlY2xhaW0gdGhyZWFkcyBtYXkgaW5jcmVhc2UgcHJlc3N1cmUgb24gd2Vs
bC1iZWhhdmVkDQo+ID4gICB0YXNrcy4NCj4gPiAgIFJlc3BvbnNlOiBBZGFwdGl2ZSB3YWtldXAg
YWRkcmVzc2VzIHRoaXMgYnkgY2hvb3NpbmcgdGhyZWFkIGNvdW50IGZyb20NCj4gPiAgIG5vZGUg
bG9hZC4NCj4gPg0KPiA+IC0gQ29uY2VybjogQWRkaXRpb25hbCBjb25maWd1cmF0aW9uIGNhbiBp
bmNyZWFzZSBvcGVyYXRpb25hbCBjb21wbGV4aXR5Lg0KPiA+ICAgUmVzcG9uc2U6IFRoZSB1c2Vy
LWZhY2luZyBpbnRlcmZhY2UgaXMgaW50ZW50aW9uYWxseSBtaW5pbWFsOg0KPiA+ICAgbWF4X2tz
d2FwZHNfcGVyX25vZGUuDQo+ID4NCj4gPiAtIENvbmNlcm46IExvY2sgY29udGVudGlvbiBtYXkg
c2VyaWFsaXplIHdvcmtlcnMuDQo+ID4gICBSZXNwb25zZTogVGhlIENhc3NhbmRyYSBydW5zIGJl
bG93IHN0aWxsIHNob3cgbmV0IGdhaW5zLCBpbmRpY2F0aW5nDQo+ID4gICBjb250ZW50aW9uIGRp
ZCBub3QgZXJhc2UgdGhlIGJlbmVmaXQgZm9yIHRoaXMgd29ya2xvYWQuIFRoZSB3YWtldXAgcGF0
aA0KPiA+ICAgbm93IHVzZXMgd2FrZV91cF9ucigpIGFnYWluc3QgdGhlIGV4aXN0aW5nIGtzd2Fw
ZF93YWl0IHF1ZXVlLCBhdm9pZGluZw0KPiA+ICAgcGdkYXQtPmtzd2FwZF9sb2NrIChhIHNsZWVw
aW5nIG11dGV4KSBlbnRpcmVseSBvbiB0aGUgYWxsb2NhdGlvbiBob3QNCj4gPiAgIHBhdGguDQo+
ID4NCj4gPiBSZWFsLXdvcmxkIHdvcmtsb2FkIHJlc3VsdHMgKENhc3NhbmRyYSk6DQo+ID4NCj4g
PiBUZXN0cyB3ZXJlIHBlcmZvcm1lZCBvbiA3LjAuMC1yYzEuDQo+ID4NCj4gPiAtIG1heF9rc3dh
cGRzX3Blcl9ub2RlPTENCj4gPiAgIC0gdGhyb3VnaHB1dCBzYW1wbGU6IDE3MTE0Ng0KPiA+ICAg
LSByZWZlcmVuY2UgbGF0ZW5jeSB2YWx1ZTogNi4zNzUNCj4gPiAgIC0gb3AgcmF0ZXM6IDQzMjU2
LCA0MjczMSwgNDIzNDEsIDQyODE4IG9wcy9zDQo+ID4gICAtIHA5OSBsYXRlbmN5OiA2LjMsIDYu
NCwgNi40LCA2LjQgbXMNCj4gPg0KPiA+IC0gbWF4X2tzd2FwZHNfcGVyX25vZGU9OA0KPiA+ICAg
LSB0aHJvdWdocHV0IHNhbXBsZTogMTgzNjM5DQo+ID4gICAtIHJlZmVyZW5jZSBsYXRlbmN5IHZh
bHVlOiA2LjANCj4gPiAgIC0gb3AgcmF0ZXM6IDQ1NzkxLCA0NTI1MywgNDY1MzQsIDQ2MDYxIG9w
cy9zDQo+ID4gICAtIHA5OSBsYXRlbmN5OiA2LjAsIDYuMSwgNS45LCA2LjAgbXMNCj4gPg0KPiA+
IE9ic2VydmVkIGltcHJvdmVtZW50IGluIHRoZXNlIHJ1bnMgd2FzIGFib3V0ICs3LjMlIHRocm91
Z2hwdXQgYW5kDQo+ID4gYWJvdXQgLTUuOSUgcmVzcG9uc2UgbGF0ZW5jeSwgd2hpY2ggc2hvd3Mg
cHJhY3RpY2FsIGJlbmVmaXQgZm9yDQo+ID4gcHJvZHVjdGlvbi1zdHlsZSBkYXRhYmFzZSB3b3Jr
bG9hZHMuDQo+IA0KPiBCdXQgdGhlIHJlc3VsdCBzdWdnZXN0ZWQgd2Ugc2hvdWxkIG5vdCBoYXZl
IG11bHRpLXRocmVhZGVkIGtzd2FwZCwgYmVjYXVzZQ0KPiA3IGV4dHJhIHRocmVhZHMgZ2l2ZSBv
bmx5IDcuMyUgdGhyb3VnaHB1dC4gVGhhdCBpcyBub3QgYSBnb29kIHVzZSBvZiBDUFUNCj4gY29y
ZXMuIEkgc3VzcGVjdCB0aGVzZSB0aHJlYWRzIGFyZSBjb21wZXRpbmcgZm9yIExSVSBsb2Nrcy4N
Cj4gV2UgbWlnaHQgd2FudCB0byBwYXJ0aXRpb24gZWFjaCBMUlUgbGlzdCBpbnRvIE4gZmlyc3Qs
IGJlZm9yZSBOIGtzd2FwZHMgY2FuDQo+IHdvcmsgdHJ1ZWx5IGluIHBhcmFsbGVsLg0KPiANCg0K
VGhhbmtzIGZvciB0aGUgZmVlZGJhY2suIEkgYWdyZWUgdGhhdCBzY2FsaW5nIGJleW9uZCBhIHNt
YWxsIG51bWJlciBvZg0Kd29ya2VycyBuZWVkcyBtb3JlIGludmVzdGlnYXRpb24uDQoNClRoZSBw
dXJwb3NlIG9mIHRoaXMgd29yayBpcyB0byBtYWtlIHRoZSBtYXhpbXVtIG51bWJlciBvZiBrc3dh
cGQgdGhyZWFkcw0KY29uZmlndXJhYmxlIHJhdGhlciB0aGFuIGhhcmQtY29kaW5nIG9uZSB0aHJl
YWQgcGVyIG5vZGUuIFRoZSB1c2VmdWwNCm51bWJlciBpcyB3b3JrbG9hZC0gYW5kIGhhcmR3YXJl
LWRlcGVuZGVudCwgYnV0IHRoZSBoYXJkLWNvZGVkIHZhbHVlIG9mDQpvbmUgaXMgdGhlIGxlYXN0
IGZhdm9yYWJsZSB2YWx1ZSBpbiBhbGwgb2Ygb3VyIHRlc3RzLiBUaGUgYWRhcHRpdmUgd2FrZXVw
DQpwb2xpY3kgb25seSB3YWtlcyB3b3JrZXJzIHdoZW4gdGhlIG5vZGUgaGFzIGlkbGUgQ1BVIGNh
cGFjaXR5LiBUaGVyZWZvcmUsDQppdCBkb2VzIG5vdCBmb3JjZSBhZGRpdGlvbmFsIHJlY2xhaW0g
d29yayBvbnRvIGFscmVhZHkgYnVzeSBDUFVzLg0KDQpJbXByb3ZpbmcgUDk5IGxhdGVuY3kgdW5k
ZXIgbWVtb3J5IHByZXNzdXJlIGlzIGRpZmZpY3VsdCwgc28gZXZlbiBhIHNtYWxsDQppbXByb3Zl
bWVudCBjYW4gYmUgdmFsdWFibGUuIFRoZXNlIHJlc3VsdHMgYWxzbyBzaG93IHRoYXQgYSB2YWx1
ZSBncmVhdGVyDQp0aGFuIG9uZSBjYW4gYmUgYmVuZWZpY2lhbCBmb3IgYSBnaXZlbiB3b3JrbG9h
ZC4gSW4gdGhlIGxhdGVzdCB0ZXN0LA0KaW5jcmVhc2luZyBmcm9tIG9uZSB0byBmb3VyIHRocmVh
ZHMgaW1wcm92ZWQgdGhyb3VnaHB1dCBmcm9tIDE5NSwxNjkgdG8NCjIyOSw5NzYgb3AvcyAoKzE3
LjglKSBhbmQgcmVkdWNlZCBtZWFuIFA5OSBsYXRlbmN5IGZyb20gNi4zMDAgbXMgdG8NCjUuOTc1
IG1zICgtNS4yJSkuDQoNCkdvaW5nIGZyb20gZm91ciB0byBlaWdodCB0aHJlYWRzIGFkZGVkIG9u
bHkgMC44JSB0aHJvdWdocHV0IGFuZCByZWdyZXNzZWQNClA5OSBsYXRlbmN5LiBUaGlzIHN1Z2dl
c3RzIHRoYXQgZm91ciB0aHJlYWRzIGFyZSBiZW5lZmljaWFsIGZvciB0aGlzDQp3b3JrbG9hZCwg
d2hpbGUgaGlnaGVyIGNvdW50cyBuZWVkIGZ1cnRoZXIgaW52ZXN0aWdhdGlvbi4NCg0KPiA+DQo+
ID4gSW4gb3VyIHJ1bnMsIHBlcmZvcm1hbmNlIG51bWJlcnMgd2VyZSBlc3NlbnRpYWxseSB1bmNo
YW5nZWQgd2l0aCBhbmQNCj4gPiB3aXRob3V0IHRoZSBhZGFwdGl2ZSBtdWx0aS10aHJlYWRlZCBr
c3dhcGQgd2FrZXVwIHBvbGljeS4gSW4gYm90aA0KPiA+IGNhc2VzLCB0aGV5IG91dHBlcmZvcm1l
ZCB0aGUgc2luZ2xlLWtzd2FwZC10aHJlYWQgYmFzZWxpbmUuIFRoaXMNCj4gPiBpbmRpY2F0ZXMg
dGhlIGFkYXB0aXZlIG1ldGhvZCBwcmVzZXJ2ZWQgdGhlIG11bHRpLXRocmVhZGVkIHBlcmZvcm1h
bmNlDQo+IGltcHJvdmVtZW50Lg0KPiA+DQo+ID4gQWRkZW5kdW06IGFsdGVybmF0aXZlIGFwcHJv
YWNoZXMgZXZhbHVhdGVkDQo+ID4NCj4gPiAtIFBTSSBwZXIgTlVNQSBub2RlLg0KPiA+ICAgSSBw
cm90b3R5cGVkIFBTSS1iYXNlZCBub2RlIHByZXNzdXJlIHJhbmdlcyB0byBkcml2ZSB3YWtldXAg
Y291bnQuDQo+ID4gICBUaGlzIGJlY2FtZSBjdW1iZXJzb21lIGJlY2F1c2Ugcm9idXN0IFBTSS10
by10aHJlYWQgbWFwcGluZ3Mgd2VyZQ0KPiBub3QNCj4gPiAgIHN0cmFpZ2h0Zm9yd2FyZCBhY3Jv
c3Mgd29ya2xvYWQgdHlwZXMuDQo+ID4NCj4gPiAtIENQVSBtYXNrIHNuYXBzaG90IHBvbGljeS4N
Cj4gPiAgIEkgYWxzbyB0ZXN0ZWQgYSBzaW1wbGUgQ1BVIG1hc2sgc25hcHNob3QgYXBwcm9hY2gu
DQo+ID4gICBXaGlsZSBmdW5jdGlvbmFsLCBpdCByZWZsZWN0cyBhIG1vbWVudC1pbi10aW1lIHZp
ZXcgYW5kIGRvZXMgbm90IGNhcHR1cmUNCj4gPiAgIHByZXNzdXJlIHRyZW5kcyBvdmVyIGEgYnJv
YWRlciBzYW1wbGluZyB3aW5kb3cuDQo+ID4NCj4gPiBCdWRkeSBMdW1wa2luICgxKToNCj4gPiAg
IHZtc2NhbjogU3VwcG9ydCBtdWx0aXBsZSBrc3dhcGQgdGhyZWFkcyBwZXIgbm9kZQ0KPiA+DQo+
ID4gRWhhYiBBYmFibmVoICgyKToNCj4gPiAgIG1tL3Ztc2NhbjogaGFuZGxlIHJhY2luZyBtYXhf
c2VxIGFkdmFuY2VtZW50DQo+ID4gICBtbS92bXNjYW46IG1ha2Uga3N3YXBkIHdha2V1cHMgTlVN
QSBsb2FkLWF3YXJlDQo+ID4NCj4gPiAgaW5jbHVkZS9saW51eC9tbXpvbmUuaCAgICAgICAgfCAg
IDUgKy0NCj4gPiAgaW5jbHVkZS90cmFjZS9ldmVudHMvdm1zY2FuLmggfCAgMjggKysrDQo+ID4g
IG1tL2NvbXBhY3Rpb24uYyAgICAgICAgICAgICAgIHwgICA4ICstDQo+ID4gIG1tL2ludGVybmFs
LmggICAgICAgICAgICAgICAgIHwgICAzICsNCj4gPiAgbW0vcGFnZV9hbGxvYy5jICAgICAgICAg
ICAgICAgfCAgMjYgKysrDQo+ID4gIG1tL3Ztc2Nhbi5jICAgICAgICAgICAgICAgICAgIHwgNDE5
DQo+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLQ0KPiA+ICA2IGZp
bGVzIGNoYW5nZWQsIDQ2NSBpbnNlcnRpb25zKCspLCAyNCBkZWxldGlvbnMoLSkNCj4gDQo+IA0K
PiANCj4gDQo+IC0tDQo+IEJlc3QgUmVnYXJkcywNCj4gWWFuLCBaaQ0KDQo=

