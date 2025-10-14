Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 281CCCCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F7518E013C; Tue, 14 Oct 2025 10:51:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CED38E010A; Tue, 14 Oct 2025 10:51:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BE278E013C; Tue, 14 Oct 2025 10:51:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C13D8E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:51:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1627C098C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:51:21 +0000 (UTC)
X-FDA: 83997007962.18.1ED2D9B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8FA4E140005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:51:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RCd+VMym;
	spf=pass (imf23.hostedemail.com: domain of qiuxu.zhuo@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=qiuxu.zhuo@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760453478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TVF77gELQjKW+COe7fzRdX1e81IxDE6HoT+7Sdj0CDo=;
	b=Lik3/1gE2fcGmglwWgt2gFRRZvnzEkxnoKti+MHx3K9shiUObK7fLIoMmbFPdVWmAx7J05
	2axjlgjLsLAwZCwXu7up6LC/wGAdgbvzsZ7F6eBLW6DimX+KtBaSZIo0UOX4BLTG+cwWrf
	IWGHRO2grCV6AZcndUrlGHg1daPmrNY=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RCd+VMym;
	spf=pass (imf23.hostedemail.com: domain of qiuxu.zhuo@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=qiuxu.zhuo@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760453478; a=rsa-sha256;
	cv=pass;
	b=MunnprRqUVJg8fyU8XRhvQkQzrm99Q7oTZspinJShtIiSe8L05ywMUujB9BML9amHlwxbx
	FLEDv5ZlKv+WPcBRDGeg9mVkxmWRL0HE3qKOgD/OGhYqyRAsUA4KdZKJSJ62A2gf0fBxch
	6kvcyugPl+gdd//TJKl4KnscP4CCdDA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760453478; x=1791989478;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TVF77gELQjKW+COe7fzRdX1e81IxDE6HoT+7Sdj0CDo=;
  b=RCd+VMym/y6Rv09b2oo8HBCEKWHu1XNTSi3hAdzkj6ltC0G1SteaizB1
   vsDs76hgPHzXVGLD6+vk25Lrl+C2KtOdqoriaMgtqET7OUBDzkCTceq2D
   4IWrbQYNvc/6isBIgQ8z5JKBEyPIHdRLPEVw+bZS+6SO7StmReC+zbRAb
   eH/z94hcPxVoLqXjAd7Ka/DMQt9jgcZqPV3BDUqxlt+6pIvUlCmr27AJM
   Gd8FkfU/kwcCoTeXB4Kzy5YBy+00tbYxqn37RTD5QHPPKaog2d5qHJFeM
   tc+BK2zUobZefC7QbCE7hV7HCkG9cM5y+50AytclKcrhjInvlcyNJeZq1
   w==;
X-CSE-ConnectionGUID: aDLR/udDTOS982lHRuXjcg==
X-CSE-MsgGUID: Z8RMGcuPTm6GXOTU4/aOmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="66472003"
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="66472003"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 07:51:16 -0700
X-CSE-ConnectionGUID: rvALi+xnTPe4dLGTc1SM+g==
X-CSE-MsgGUID: 0bl8RMG4QseDUQq6DeZoXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="181850861"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 07:51:15 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 07:51:15 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 07:51:15 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.16) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 07:51:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ob/eWc8aw8JjYuBHjq36MZAcnLtf8NsITDcR9ros3+dhdbnn/wgDWq4PKeE7UMvm6GgwIpxffgDenmQo83JG5l7lvhYwptjpgu4ZOoGzaJj0z2PD1MGGWoZy+Cy+SSIbNkHe42dUe9iFUkAL+leXSbrJ0yxuTsYTKOGpsvtoGT+TJCfV3RSUzpC6VbFhghCJLNPWR7Ex/9gN0T8K5gpcuJbix/BcFz5bb/IwPVaiHU/nc/anFc+M2bOUNIU7RMM1ub3NA3BV/ZnuZ8k7QxDoes9cdF3pz+rvYbInhRKgBE6E4k2bZGxufonAHrSbm7gSdpK6Dq0WLveYF+zr9jXBqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TVF77gELQjKW+COe7fzRdX1e81IxDE6HoT+7Sdj0CDo=;
 b=v2ejkZO6uAzOHUPz+K2Xk33x02NoQRgcHa+Jl/vukNngP8pudLGvy1QaqRV2G4S3OKoW6QCNZmIY4cMtwLMq1BYRWo3/34OTKcgcTIjiUEdBJVNQyrlNY5M01buiM/5yGe0YPDWyXqIT1mZioOolquGFG89sx2qnCC/s1ehamy67rjXV7XKwQVmxo/at/hG7RIICqn0cZfuRTDaQgkPYbttAFetY6z8BGZjds2MpU3Vt3jMoUBz7JZfVawRAxgujNbTj26wkxAE82gozDZeOLOSeou9mih7QXVe6eGEavyhVUKBi0TMp/wDbHK91gdrfTCyaTwitW7PZC9WabzA0mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY8PR11MB7134.namprd11.prod.outlook.com (2603:10b6:930:62::17)
 by MW4PR11MB5872.namprd11.prod.outlook.com (2603:10b6:303:169::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 14:51:12 +0000
Received: from CY8PR11MB7134.namprd11.prod.outlook.com
 ([fe80::5670:5b2e:6ecb:dcaf]) by CY8PR11MB7134.namprd11.prod.outlook.com
 ([fe80::5670:5b2e:6ecb:dcaf%4]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 14:51:12 +0000
From: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>
To: David Hildenbrand <david@redhat.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
	"Luck, Tony" <tony.luck@intel.com>
CC: "ziy@nvidia.com" <ziy@nvidia.com>, "baolin.wang@linux.alibaba.com"
	<baolin.wang@linux.alibaba.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "npache@redhat.com" <npache@redhat.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com"
	<dev.jain@arm.com>, "baohua@kernel.org" <baohua@kernel.org>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "jiaqiyan@google.com" <jiaqiyan@google.com>,
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "richard.weiyang@gmail.com"
	<richard.weiyang@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 1/1] mm: prevent poison consumption when splitting THP
Thread-Topic: [PATCH v3 1/1] mm: prevent poison consumption when splitting THP
Thread-Index: AQHcPRXkR3T0FdGBREK+E3TDlsALwbTBs9UAgAACkIA=
Date: Tue, 14 Oct 2025 14:51:12 +0000
Message-ID: <CY8PR11MB7134373BFEC3E3F66D7BA39C89EBA@CY8PR11MB7134.namprd11.prod.outlook.com>
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
 <20251014141935.1878315-1-qiuxu.zhuo@intel.com>
 <83d15ab9-55bf-4cd8-8b3c-007253dfc175@redhat.com>
In-Reply-To: <83d15ab9-55bf-4cd8-8b3c-007253dfc175@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR11MB7134:EE_|MW4PR11MB5872:EE_
x-ms-office365-filtering-correlation-id: 14fd4ddb-8471-410e-bb5d-08de0b311e76
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?M2NqelRob01kK3FUTXl3MWxSWHZ1VjVZSmhlL3hqN2dYcWl2R045ekxqczFp?=
 =?utf-8?B?R3FPamtRc3RiTWp4dVlmakk1VDRGZUg5STQxdXVxbi93ZTRzYzVDOXlTUE10?=
 =?utf-8?B?V2UrRTZPSmRYTzRUQ3BVaEE4aWpWd1RoN1NJcW5yRGk5SFFLMWVXTmpQZGEr?=
 =?utf-8?B?MDNqNVNoemNGY2JtYkVLMHAvUDJWYS84bFlHaDZjK0pWODdnclhNWEFLTUVI?=
 =?utf-8?B?U1ZXMFlKNC9rbmF2eDlFS0NqdEFZbXZPNzA1alFCQlFISlU2SVpkNUhYSVFk?=
 =?utf-8?B?TVorNnFubTA0QWFKVVdqdmR0Q3pBclVDMmt2MHA4Q29lR291SEVRV0FDZCts?=
 =?utf-8?B?a1EyYlVJenZ6YS8zQTIzdHByUnpCYXc4RCt2N3hRUFoyTE53VTJGdFppaStT?=
 =?utf-8?B?VnJHNkIzVDVrOW9IdS9jVGFZbHM4N0Y2OVYwcldNajBmbEg5WVdhY0JuTTIx?=
 =?utf-8?B?aGd1K1paa25QK1BLWi9ycVhyaFJuM2JxNndDSXpkbGVTTWtrMUdZaWp2bXFr?=
 =?utf-8?B?UkgxdU5WZHdqSHFaVjlMSjlIN29lK0JrS3I1RnhwVEpZdnFGazQvbFRqQjBH?=
 =?utf-8?B?dXRFZUpyWERIM3FJeTBLRExyd0V1alNmcHgwZHNTcUI3VlBCSXBqREhRZjNu?=
 =?utf-8?B?ajZJN0Zld2RtVTJTT3dyVVIvTDhSUGMxenY2Z29oZUVONEhLclo3VXZtMW1M?=
 =?utf-8?B?NFp6bEJadkoyVlY3eVM2TTNCL1J4UURSckVVMUg2eEt5ZE5ITmFrVGE1TmxD?=
 =?utf-8?B?L01SMytuTEMyaG41K3ZHaUp2SzZPd0p4ZytqaVJZN0VFUUVFWTZpK0l2V1h6?=
 =?utf-8?B?Qmh2dXNjWHViSEsrNE9zVUZ2WXRXZW5wTFh6RmRKVE1JWVRUd1VXVjNZSFFp?=
 =?utf-8?B?ZXlvMGJRNjhsZVhKc3MrOFlhOVhhRGh3SzgyU1ltRk1FUy9UVkJGKzlmM1V5?=
 =?utf-8?B?eVJRekxyWFlmWFRObFJIemQ5b1drcEFhUmFKQ0VZUGd5Z0VXeURTeWNUazlJ?=
 =?utf-8?B?RzJVdnQwdHdzdDdFaVBhMWQwVHdjTmhWREErZjU1dnVaRDM1SGdhbC84MjFG?=
 =?utf-8?B?eWVRL2R4cUZiMFM0VGk4eEpGSGpEUi9xNklRT1VuUFoxYllwUGdPZGhYVlVN?=
 =?utf-8?B?MG5ERFZWSW1UMEZ3SG1KdStPNFVEL1BiVjlMK24vRkVFdzVEWWVLbkx2TnBo?=
 =?utf-8?B?ckxiVFU1RFF0YTdDNUUyVm9acE5aSVhhcUs0ZXFxRjMzZGRZYWNFM0Vwa2Iv?=
 =?utf-8?B?RmRGM2VKVUtCdFFSVG5rMzhYdGtSMDNuZldpZlFyUVdjNFYyYzNWWU0rbHA1?=
 =?utf-8?B?QVB3aXltNlBIV0M3b1cyKzlFVi9UMmpuYnBoQlFKdTNoWDN4dmFXSlBpcVNh?=
 =?utf-8?B?eG1KMTFNY01ZeE8rTnY2YUpCVEpIcGhHWXVSck1BOGRkZVd3YVVIa3U3cmpT?=
 =?utf-8?B?UXExTXhpUkdnb3FoV0taU3o3TDJmNHRRT0JIdlZFdnBiaW15N2I3aXB2MmZN?=
 =?utf-8?B?Qkh5RFBGenBJUWdQUktWemt2ODVTeHZTTmJMcHl5RDNWZVJva2k3YmZyQTdp?=
 =?utf-8?B?aytlVXNNRGFZc1U5WFZ1VUZqUmw0bGRBeUR6bktkdXRvb2d3ZGt6UkRBOUVU?=
 =?utf-8?B?L0ZtaTFmMlg1alRXUmMveEI3WWhPbWpCMXdNNnJJVGlUOG5ZTW9XZUZsVUFT?=
 =?utf-8?B?REFlRzVpSForOHZ3bmJJQkUvb1Jua2NOZjJTSDFYaUltWEhkTklpT3B2ejky?=
 =?utf-8?B?a1dZSEp3bDNDM0xMTVZDaWtvS0Vud09COS90SEdWbTFDdmZITlh2QmpwcFFV?=
 =?utf-8?B?Q05CTWx6VDlkLzJOcHAzZE40Z1RpdTNHV0wyanJPay9aOGV6Y3pPLzF3M1FI?=
 =?utf-8?B?MHAwZUplNkZvcERZSkVIak4yd1ZMRDA4VTdBV1ZyejFabjh3S0Z0cHFuWE8z?=
 =?utf-8?B?ODh3OWJlUjArMGY3T2VkS2cwZWduc2lxQlJSVWk1bUNqbEtRa0hydHZxRDhW?=
 =?utf-8?B?OUFwMkRXeXBIVGhJancrRTd0WkdIeU1vMkNka3Nzam9HRXhLNVMybCtQVjF4?=
 =?utf-8?Q?0oV80G?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB7134.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjdmUzliaW44UFlFeDZrRkxtYnhyV1pzRmhXSnVGYlRMekltUmVHRmZoNWNh?=
 =?utf-8?B?Qk16OHhQQmoyUVpoT21KUU0wMUdCQlhDWFZKRWhzdW5GQW1lQ1NIeVhvM2k4?=
 =?utf-8?B?RC8zazJNRVZQMG90UUIrRFpmSm1saTlGd3dTem85OHdLQmlNdi9abXpSb24w?=
 =?utf-8?B?QXNhY09UT2NCanM4amZCcUUxMVRTd2lIbk5FWUd3WXpoYmtidHkxQmxxVnpS?=
 =?utf-8?B?a0lJWlVDN0d3MithTjJSZVd4YzlpUjNhRkF4VHlsQWttZ0RDYTl0YkxqeDVm?=
 =?utf-8?B?UVBkZUZUYXV4VFJJN1RvKzc4OEIxVDBuWTFWM2dodUVJdlQ3djJHZ09tNllw?=
 =?utf-8?B?SkdQRlFreEpiaVJKRkc0SzlGOTVNd0tGREpFTlBQY3crNVNQa20wVnlmdFpN?=
 =?utf-8?B?a0h3S21pMWlSNjM5UFppdFhEQXF1OUtET2tYaXJIbWVFOFRxMXJhdWZremdm?=
 =?utf-8?B?S2h2eWtVeE5KaWJoUWhKeEZDOXVqMS9XU2Vqbi9VcUZncmQ5MFdDcHUrY09j?=
 =?utf-8?B?WjJUM3JJeVp6K2VMZ1ljdnZwVlYzWEZrNmcydWR3UlBDZE4xUkRSSWhQS0h5?=
 =?utf-8?B?YnAwZjFkS3hIZVR5cjFCN2hNMzJQQlJlaGo3R0RPSVZ3RmtVbTNzOVQ2L3BH?=
 =?utf-8?B?NFV6ZVhsY1gvdXZWeEk5VVFEdXBnZ20xQ0pJTThkc1cyMW8wTm9nVnE3ZDNo?=
 =?utf-8?B?WjdUZm1Dc2VPbGdjcTRPZDhQTDV0U2RYUUJmYmlvRkd6bFZWZGxnZ0dBMWdC?=
 =?utf-8?B?am5YNE1xbk1ic0JyZXNvUnV4ZHJIaEJMaGJPUk40dkZVS0M4Y2Y4cWErd2U5?=
 =?utf-8?B?TEFlRStxb0h2dGVGOTBIb2h4T1dmQUtoMmlwZ3BPMXFsNThXODRVaFdJWW5j?=
 =?utf-8?B?SmZ4a00wcnd3SEhvbUxEbVRKZzJvalNYSURmMUhtSUdia0cyYWVQZ0NQeTlx?=
 =?utf-8?B?RzFMUGdUQ09aSVlzSmwrcXZrUGZiSmltWjVET1k2RHByVVgrSitGMUs5eEhx?=
 =?utf-8?B?S0I3anpKODdlYXE1ZVRIc1UzYm5yVkUyVkRVdlVCL0xhUDYwWGlIUWJUb0p1?=
 =?utf-8?B?L2dZeXBwdU1DUWFmWld4eE9tZ1RVaElHNHJTdE1DdHF4b2VjVC90enh1OE1M?=
 =?utf-8?B?QWNENFUvNUxnUUZ5V0Vrbk5vbUdXaUJxQnJsMlVLTjZtdUFmdHU1Sy9haURx?=
 =?utf-8?B?c0ZrSlNIa21hS2RxZXptQTdGcVlrQ0g2VzdMM1RqSmQ2MXo1TW9tK3ltUWsw?=
 =?utf-8?B?SjV5TVQ0dThvZ0JWV2pJU01lRzc5dStuTEh0NDNLMGhJaDZQakcvVFhGNnVr?=
 =?utf-8?B?eHd1RWxmT3RFS3VjbG9TbzdyLytkOTVHeGRidDR4MkdyMG4vdjdkcis5dGMy?=
 =?utf-8?B?UEpPMFBrMzVRci9UWGZ6U0l1WVBWSXNHYlBtby9KQVl1eEsvczZGWnNycFdJ?=
 =?utf-8?B?UXk3bVBqbi9Ed2d6SXBneHRjTFduS1lnKzlLdEVubDFUNE41ekFLR1IwZ2Jm?=
 =?utf-8?B?LzVFbzhkckp0Nk90WHlRU0xBZjlySzN5clNNYnVlSVFpM3BRNUZaMVVocTds?=
 =?utf-8?B?eGU0VnkrRmZNQWZKN0JqRThSb0JDVXJyUU5yek8vd2RJSGxONUtydkdjdzRs?=
 =?utf-8?B?Si9kZGF2dkFobXNaZWRhTXJPM3lmcGlLV2VnNCszZjBRcFI5NzExd2R4bUs1?=
 =?utf-8?B?L1RjVnpZUW1VUHI2ZE10OE0xdGhZTk9YYXdNa1I2NkZOc1JNY0xxRXNKL21J?=
 =?utf-8?B?YmtFWmUreG9uc2tZSGVVOTZxVjB5cGR6NE01TnUxUFJnU1NMNS9VZm8xdElN?=
 =?utf-8?B?QTZKWm5DTGpNNTdSUmxCTTFWU1VyQUE0b2tMVnhWeVhPN2wrT2IyRGsxd1U5?=
 =?utf-8?B?M3B1REpWakl2QVZWdjcrRVJLRVpJc3FQMXRORlU2RHBGNnYrTmtNMnFvajl5?=
 =?utf-8?B?RVpQU2d6N1I5ZFptMGs5Q1VrWDJxVWk2Ulp2bGFYWUYvKzBWc3Rqdldubkx0?=
 =?utf-8?B?NXJJMTdHNzBkQ1Nka0ZJSHQ4QnRkM081ajZ6SUU1MUJXTGRwT3huZVFhRWsv?=
 =?utf-8?B?VjI4UExlejFSYVh5dHZLaTNtUDNtaHlqQWw0WThFOXdzU2MvQkRIVXcwQlY5?=
 =?utf-8?Q?dPvDuvM1bRV18Q0FxkTJfnwYr?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7134.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14fd4ddb-8471-410e-bb5d-08de0b311e76
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 14:51:12.5430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tZz3bFvqdbzzDUacFt2Ji6NiUWM0Cr76LeJPPbsMtyOlNvoqd5mMJns+VG/r3pTKUEkkduecdGvtypnLXzmXxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5872
X-OriginatorOrg: intel.com
X-Stat-Signature: ksd58osx3cdr6ihxn775j9rd43xefumq
X-Rspamd-Queue-Id: 8FA4E140005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760453477-159888
X-HE-Meta: U2FsdGVkX19lwNbhl/Fc0RsCXTJ3fzf1E4YlC7nLdNzFoHTXQs8r4diEYzK6FE9r/JLrG3IjUaHV885dPNCPQoncJjobJC8sgCI+xZ16o2q9OervZl2QyEyuvkTj5yIPPJlu6t9NmhCyiaPIlyOlOnv0J2K4B7utG/6a1efq3S+bUjUUaAtLBtonXoLeGwiDnqhMuJjRfbJr7LxA7h4cYQ2S0MoSXH3LQJF3MUzuWl7xvDE7nvusuOSS5dSG/Z3ypCxUBroxfd461IWnlljgq0++cFQerS3Awy5TPytYfPJinCFpED6+Fg1bc/KUytRq2vt/cQ+UQTLdi2wfCDN/4DsmcNAzpeW4at/mct9RMs3poHIC+fPwRL/IABLzOeY4jNkKW+JGcmXET/QHdWgqjaP59tEDCM3Xk0t4IC64IO/C45YvjeGjgH2Qbvu6jhLXZ5AINpm8Fa8Yl8ywjCDowdeuKrCjp8dXwuC1CWD62wOMKXO1eltGPy0A0TKzS3JounDc5LLMPwq8U9GBHXc+ho5fPCbYy+u9HN749XyDJ0MlblUxZdgMVgwquagyuvQwNzV/Nzr7+B2hUnXJHSSk655C/lCY1iBbHhfh6K1UBDscTIqZhvqMYXH7DySZkdaF6Mi+e5UO1wWi5MKdt6xRy02Y15nJrVuxKGGR7n+0rrVZLLXc6vHQNfRxspNgRPPf2/q5qfsgDUH7o1TeIroWaj+YfSAOxbfdBdDRk9xFU6GtK+rd1MhV/zwyffvUXVMwJn78qRqbznEYPX2S28Akx5I2IbGUWOrdsZ4Sm4MFFqjzVPOvLGDvKvC4cVfeVpc1UH4vSOSkhqKjPg8qNGbS8UQVW50skDES4GR8Pyb2qk50uf2M9sZ+1liVxWRCGTBiWSrgo49ZrfBSsKDsmcPM3IrU2FxXPPl/RyfqzvtBUzwCifrVIK8tv3gwJdvSs79wTWLm/yDjPsXw3t5mA1G
 1uoVsTwC
 JpE4YvcCOsfB3oqqHVXQcFbuFo2QsiLd8hlbmhJHk5HR5Dq+fcHjpv3j1z3HVmbe78c9DWWClo5Rf8rO2AJy9gKjZ1CkMi5L1L2N24EjHNbT6o5cgiS6qeR6mcU++dkwXcHnsv/wxKX2GpOcoksQCvF70vih6wKc0xrtNZxETGE3Sz4yd2A1zDCzShTaCUakl53smpqgMWdbPNCZe14vpfo2fjFbXLMK9VJwP71xjjQWgbrr9+7EY/xCnYcRCJoxUUjeSZl6gu4fOyI6H+HxL5qH7wvVJpOXXKQHzKtZd+W8WSpKyxIEsFw3Ec9aLfAc0kDqtRNa2AhuCo6+3S1q+3tK/qkXMO+0CxYNW0IExdLSpNpM1frezgs5cnIUHZRoDSVqNRQOJHHybv02GQEHqlYGNLVR8Iohllk7ptD5zw4LcFy3BW5X5pyIPDWHkNrLMAHp14HaYh3BdErbNPNSnyNLMYLutLsG9rUbyioeZVR+NOepnE5/+SGszrJTBS1kPNioPyW8wvfHqiUnYnSJ9t4dhv8HK7wXPYbU1lljMgeHeeq4a+e0XnKI80ZkIXRq2dPVkO9A7jPCJw/yV1WesJxG45zqyAHVyXTQxUDw+1qkiKZ7576sbds5pSumoK2oFwBE90U9u/GhEcq5rzdOHLoaq5Ba8raAqAMUhCGsXiw5MdPc4hfF8w9g/gg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgRGF2aWQsDQoNCj4gRnJvbTogRGF2aWQgSGlsZGVuYnJhbmQgPGRhdmlkQHJlZGhhdC5jb20+
DQo+IFsuLi5dDQo+ID4gWyBDcmVkaXRzIHRvIEFuZHJldyBaYWJvcm93c2tpIDxhbmRyZXcuemFi
b3Jvd3NraUBpbnRlbC5jb20+IGZvciBoaXMNCj4gPiAgICBvcmlnaW5hbCBmaXggdGhhdCBwcmV2
ZW50cyBwYXNzaW5nIHRoZSBSTVBfVVNFX1NIQVJFRF9aRVJPUEFHRSBmbGFnDQo+ID4gICAgdG8g
cmVtYXBfcGFnZSgpIGluIFN0ZXBbM10gaWYgdGhlIFRIUCBoYXMgdGhlIGhhc19od3BvaXNvbmVk
IGZsYWcgc2V0LA0KPiA+ICAgIGF2b2lkaW5nIGFjY2VzcyB0byB0aGUgZW50aXJlIFRIUCBmb3Ig
emVyby1wYWdlIGlkZW50aWZpY2F0aW9uLiBdDQo+IA0KPiBUd28gc21hbGxlciB0aGluZ3M6DQo+
IA0KPiAoYSkgU3ViLXBhZ2UgaXMgdGhlIHdyb25nIHRlcm1pbm9sb2d5LiBXZSBzaW1wbHkgY2Fs
bCBpdCAicGFnZSBpbiBhIFRIUCIuIFNvDQo+IGNvbnNpZGVyIGNoYW5naW5nIG11bHRpcGxlIG9j
Y3VycmVuY2UgYWJvdmUuDQo+IA0KPiAoYikgWW91IHNob3VsZCBwcm9iYWJseSB0cmltIHRoZSBj
cmVkaXRzIHRvIHNvbWV0aGluZyBzaW1wbGUgbGlrZQ0KPiANCj4gCSJUaGFua3MgdG8gQW5kcmV3
IFphYm9yb3dza2kgZm9yIGhpcyBpbml0aWFsIHdvcmsgb24gZml4aW5nDQo+ICAgICAgICAgICB0
aGlzIGlzc3VlLiINCj4gDQo+IHJlbW92aW5nIHRoZSBicmFja2V0cy4gSWYgeW91IHdhbnQsIHlv
dSBjb3VsZCB0aGVuIGxpbmsgdG8gb25lIG9mIHRoZQ0KPiBzdWJtaXNzaW9ucyBmcm9tIGhpbS4g
VGhlIGRldGFpbHMgaG93IGhlIHdvdWxkIGhhdmUgZml4ZWQgaXQgYXJlIG5vdCByZWFsbHkNCj4g
cmVsZXZhbnQgdG8gYmUgaGFkIGluIHRoaXMgcGF0Y2guDQo+DQoNClRoYW5rcyBmb3IgdGhlIGd1
aWRhbmNlLiANCkknbGwgY3JlYXRlIGEgdjQgaW5jb3Jwb3JhdGluZyB0aGVzZSBzdWdnZXN0aW9u
cy4NCg0KPiBMR1RNLCB0aGFua3MNCj4gDQo+IEFja2VkLWJ5OiBEYXZpZCBIaWxkZW5icmFuZCA8
ZGF2aWRAcmVkaGF0LmNvbT4NCg0KVGhhbmtzIGZvciB5b3VyIHJldmlldy4NCg0KLSBRaXV4dQ0K

