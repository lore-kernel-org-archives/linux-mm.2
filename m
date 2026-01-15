Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0394CD46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:16:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58AFB6B00FF; Thu, 15 Jan 2026 15:16:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 563086B0101; Thu, 15 Jan 2026 15:16:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4375A6B0102; Thu, 15 Jan 2026 15:16:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2E9896B00FF
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:16:19 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E10A4160492
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:16:18 +0000 (UTC)
X-FDA: 84335305236.16.87BA8E2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf28.hostedemail.com (Postfix) with ESMTP id CE745C000E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:16:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d+17kLIa;
	spf=pass (imf28.hostedemail.com: domain of dan.j.williams@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768508175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A3+vynWq5ThQdrHRvXieAW4BW2lZRkJ9/5yntZEx+1Y=;
	b=p5HsbTG+8wZyhva6tw5uvEbNwkNDB3+keX7lHQBYspDvSaXxUn68lA3yRUuCYvwijzMzRr
	htmu6Sawqjkzfy2gSRlKqDvEvTKvzQNFtzRK8rtHOV+amIO0PqHvkKHMAp+Lz5fwHAbPf3
	kRokmaYjocRJYiMru4krqUG0gs6Jg/M=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d+17kLIa;
	spf=pass (imf28.hostedemail.com: domain of dan.j.williams@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768508175; a=rsa-sha256;
	cv=fail;
	b=4T7uWrZ8kql2NaOs3W4kHgjZau/toeka+W2QKQhW3MSw4CKG10+I9hLdndMZvQRKoMlWSU
	mZEVSUBhYIbG+qsdySNwKzSMBeZ8FN88+wyLYxdpy/NR5eCGwhkJaSQAkTHOJY936Jnt5n
	ts09Z4M6HQjKhLCW7lXX4PCa/mQk+ns=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768508175; x=1800044175;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=X5fzIhhfTBdjCDGEbDzUF8P4lPPqpFtV+VUmpIVp0VY=;
  b=d+17kLIacDGnZiJF334NoBNrm6Weqgaco/Ed/GUmG+XbRcGUBZYhEUo3
   GB3daa/X+HUH1qCDrQq/zxwScyos+SDm4PYT76Y4zVhpS9DxCFpVQ4zhj
   49WaTC1YfzXgQIRZgaoxIe+tdileiFfvn+LH4/mhi5YInEfxF8hEscDnK
   m4W5r/KIZ7GMqjFScZwmYFgHR5sO5S9OudjYPj9lNd/88TtlKGuXmdo17
   dkocoYRd6Mhqowvs6FC8PbXiK25QiF8XAqVmwSaEt2uH9JZDIZFf0FTcy
   rWODqJ8aQNwLihnb2jVaVFS0BRWeFufIk1LgJZ1Ci+MjXe+RrqwYX+mOn
   g==;
X-CSE-ConnectionGUID: bNTSSBOKR9uth0x93vKkRQ==
X-CSE-MsgGUID: bQzo4i21T4OeJxW9Vw6OWA==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="80467118"
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="80467118"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 12:16:13 -0800
X-CSE-ConnectionGUID: FQQXpE+nTe+K1El3fI3FWA==
X-CSE-MsgGUID: qQxTng+1TaadUZsHwFUxZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="209186503"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 12:16:13 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 12:16:12 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 15 Jan 2026 12:16:11 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.40) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 12:16:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hl0TX+kW1wkv6MUkR4B/mAjRwr1BvmBbjpZ1idceV6UhAt2k+14ZTsOgGll48t4I+ppViXNfI3kmQR1HI2TC+D20yHXT6EgRhJuh1DXnI6WYJO0izxxCM7kekYSZ2DB9spycO3f+4bbvdcOT3IVg2xOkAC+qFKgqwQbgPGd9W+RVTWiISDOq/+b3NIivwW+k53vLTJfpAvamOW/ifw2wAorC4ZZRIV5C6IIf9R1ppH/zAE8hlH+rcE5j+RFZmBE+x0WO/Vm7zNViS11egNfVYcjeLYItLbN+vd5TjCOW4OLRQrYY2xNn/0kQdiOnXS9Z1e+jM4dk73WfufrWiPAXqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A3+vynWq5ThQdrHRvXieAW4BW2lZRkJ9/5yntZEx+1Y=;
 b=Bv+0TDDfLgT3twHpZ362DQJOs2/QWZxEpfhQAToO1cVPYzqG0bZVGLsCR6rQWdkhSCqmXm4Hq+uHBHX0pwQxpruDsntbpwUJGTR/DMOWefvXinj4QteJ2Fgvmu9f17c1QwjBhr4zR5od8Kv3JqS0A+FBcOvFP8rC9CKX+t6GKZ32q4i4KxSvUlJifKvhnBtUHqhjY86eJIMxG8+WFtiJ+4D7A8LiGz4mt53oWLtE7zKcH1aTDMeGWdYAA/D6+H1otgMb98aTTcYLfnoeN3/3fuF+a2+rgvai4h6QKjHVJbzNf5EOS1G/VKTdJaa6M+hFJ1kRj4VdLRsCtka4+ocqoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MW3PR11MB4732.namprd11.prod.outlook.com (2603:10b6:303:2c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 20:16:09 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9499.005; Thu, 15 Jan 2026
 20:16:09 +0000
From: <dan.j.williams@intel.com>
Date: Thu, 15 Jan 2026 12:16:06 -0800
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Jonathan Cameron
	<jonathan.cameron@huawei.com>
CC: Li Zhe <lizhe.67@bytedance.com>, <akpm@linux-foundation.org>,
	<ankur.a.arora@oracle.com>, <fvdl@google.com>, <joao.m.martins@oracle.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <mhocko@suse.com>,
	<mjguzik@gmail.com>, <muchun.song@linux.dev>, <osalvador@suse.de>,
	<raghavendra.kt@amd.com>, <linux-cxl@vger.kernel.org>, Davidlohr Bueso
	<dave@stgolabs.net>, Gregory Price <gourry@gourry.net>, Dan Williams
	<dan.j.williams@intel.com>, <zhanjie9@hisilicon.com>,
	<wangzhou1@hisilicon.com>
Message-ID: <69694b06835e_34d2a100b3@dwillia2-mobl4.notmuch>
In-Reply-To: <23513e86-0769-4f3f-b90b-22273343a03c@kernel.org>
References: <9daa39e6-9653-45cc-8c00-abf5f3bae974@kernel.org>
 <20260115093641.44404-1-lizhe.67@bytedance.com>
 <83798495-915b-4a5d-9638-f5b3de913b71@kernel.org>
 <20260115115739.00007cf6@huawei.com>
 <23513e86-0769-4f3f-b90b-22273343a03c@kernel.org>
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0058.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::33) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MW3PR11MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: af3ea222-2abf-45f6-f615-08de5472ec07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?REZTenJ3bjh2bHFWOUppY2ltMUx5NUNCZDBVSU9hdDlWY1QwczF6NE93eE9O?=
 =?utf-8?B?ZE9Mcy90clM5RTRDVHdVNWdSRG5RbHFEQ0pqekdkbE14cW44b3EwTXNySzNH?=
 =?utf-8?B?WFFuelZyTTE0dEQvZ0FieFFKSis3dnAweCs3VUlCTHF1SGViZGUyZS8zK3Z4?=
 =?utf-8?B?RDhqNU5iUTZJbGFJVHdlRVRqTFZmZHl3RHFnaGQ3dEZlSU5FNFc0aHFZRHJ6?=
 =?utf-8?B?V1lwT3diNDNzNlVmNFhqSDliZ0dTSDZiTmFNU21Fb0E0Z2xVZlRvblBnajNo?=
 =?utf-8?B?OGsyVlIxQnNHa0xFWTJMTUY0cWdVZlpXY05ENlduRUpGL3pSNVU3U2thMXlt?=
 =?utf-8?B?ajRmQ25LbTR4SHFhRFdkUWdmdzJiYUVnMkN0Q2l5S1NPUENoNVd0c1lmQktR?=
 =?utf-8?B?QUwrQU5VV1BzT0tsNVZrY3h6SzhoTnhXQTVvMTBMZXA0ODkzSjluZHozeWdw?=
 =?utf-8?B?RnJBZFhmM0lwblFxVlRNRC9uVzlvNEVsT056TitON21hRDJhM2V0MUlIa2kw?=
 =?utf-8?B?U1d2djByRGg0YmlRZ3NBUllLMUxqRW9nZXJzdmxnMGE1ZzZ0UUk2bmtFM0RE?=
 =?utf-8?B?aWd3NmZhK01SVlB2c1RyM3dSdEx0SnBFY0NMbE1xL1hhZE9qS3VUcml6UVhl?=
 =?utf-8?B?UFkvbWpFWEVDMUVDZGI0U2NYaUcrczdCVisrUkFXd3E3b2docU1waFdLSXRI?=
 =?utf-8?B?MGJraEd4YkFZbXdTN2xTYkpTdVNTK0lTMVJrQTU0NXNwelAycFRsaUZ2Ukpw?=
 =?utf-8?B?dFFlS2QrbVYwQVp1U01aSEJWUVdLOTk2TXc0QStiU0N4WGZTOFkyZVpybFVv?=
 =?utf-8?B?L1hCYmpYSG80VUZ4M3N0OUx5bmsrcFNPcUMxQnA0Mi8yVXNxcXc5ZGlYclQ4?=
 =?utf-8?B?VWxDRE9RRFREb21SaUMyVnh2ZHVRcnYxajUzdG13WlhrUHdpN29rVFlaTHdl?=
 =?utf-8?B?YnRlbnFBbkh6ZVQyamM3bWNJOXZKZXBOZjBKdFRtbFd6cUFrQ09kam84RWNy?=
 =?utf-8?B?ZGF6T1FLQUVZZ3NJQ2Nvc0FKRXFGZG1xM0VWZHpqTlJjVmdWUnZ1bi91QUtF?=
 =?utf-8?B?OEdjWFQwUDltbHFaczkrQ1JCREdlSFFZdXEvRmMyUnlGaGlCV25UaW44N1ov?=
 =?utf-8?B?QVFEREJVSzkxeXNSK1VSMzJ4WlJUeW16SmZvb3AyTVlIUWcrbXo2eWJXR3Jo?=
 =?utf-8?B?VFM2REFjNlpCYnl6MlBpVng1Y3Z2eUR3ODRMZCs4UmlUZThzTEpPRnpGU0hl?=
 =?utf-8?B?a2Nvc0hxYnRLZllqOVFTMHdmc2w2bEZDMFRDVFM1R1J6RzYwaUV1WHRqSUF5?=
 =?utf-8?B?REFNR3dvTU5rbUlxbFpqNDhJNnNMM2FhK3hoYlp1aTd5SmU5MDBjVTg5WVZy?=
 =?utf-8?B?a2tpODhxN0tFR1RGaERJWDMvcVBhK2ltblE0YzgyY1RmcmQrTk5RRlYvb1hp?=
 =?utf-8?B?cnBlcmZXV2YxTktUZEx0d3RLV0grNCtLN0JTM2hPa2pXdGhGNm5ReTFuL282?=
 =?utf-8?B?d2NZb2FOdENwVVVmQW5saS9LZzlocEY1ZWgwQ0lJVVpJQml4KzJKSWpucXV5?=
 =?utf-8?B?eXFKNDFUemZBS2w4Y2lQek1uanMvekJKTHgrcjJ2cnJLTjNBUzJmRHRpT2FX?=
 =?utf-8?B?K3k4c0wwUG95dkd3YU9HWURPcmpndk93TjkzNWVldURTZVFnbVozR1I0T0Iw?=
 =?utf-8?B?NVJEOXUxbG9yVFpJTGdMUHB5ekZQNnQwUnpsZlh5VENRTFRHVGliMjB6Y1ha?=
 =?utf-8?B?cWg5anRYK3dnUWw4MVlYclhwVVNvdzRtU3l6cUs2QXFkREhhdjZuUXhnWHpj?=
 =?utf-8?B?bEY2VjVYUnRtcWVXb2hrTUZoSkI3VjE4OG1JVXpjZEJvdXFQaUx4by9ta3R5?=
 =?utf-8?B?SlkrYWFvcGJtbXpGRi9nblM4YjRIQVNaUUJVZFl2cHFVdGt5UDl5WlkvTXIz?=
 =?utf-8?B?M2RqcmFjRnp5WUZFbUNWNm90YThSVFRibVZlS0RVL09aQmZqUlBpbGkvMVZW?=
 =?utf-8?B?bFg5UDlGYzI1QWxScXc2N2kxckg5cTM2N3VCL0wwYUE1TDhtbXJaUlk5MDBu?=
 =?utf-8?B?dDNsVElyUldJMXpMN2tSUkZoQ2ozSStNbkhpS3RVbDRxaFA0MkVSRmwyQ000?=
 =?utf-8?Q?LRDo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MG9pV2tvRXd2YlNOdjBjMnU5RlBNbkN1VEN5NVlIUHZQZXdGU0FvRkJyUnJo?=
 =?utf-8?B?TTgzbGR3cFl5UXBBVmhNUlptNEc0VEFsS1krTzROM1d1VEpUQVd5OVVaR1Jp?=
 =?utf-8?B?ckZPbWVHbUVzQmVkeVplekZ0WWJpN1lFT2pNT2Zobyt4V0VRd3QxZEFPbzl0?=
 =?utf-8?B?cGRTdmI2cmhKZE1EVERIR1B3aThNMVZuMkk2djBjampMUXUyd2x4K1dZREFv?=
 =?utf-8?B?NWYycHpZRmZKcVlUVis3YTJRdDI1WlBLRkR6cUoyRStsRkxhMkZSUW43NVUx?=
 =?utf-8?B?M3ZIOWx0TnkyNGx4YWd5ZlM0ay81RGtJK2xuWkU3WDFIL1h6MWlrdW1UTXNs?=
 =?utf-8?B?ZkF4Q0o2NWNzZ0duMzM4RTBXdWJUNlBuWUxwdDdaS1VuSG9qaER6V2M4RmJJ?=
 =?utf-8?B?ekxmUmlJR2JWei9NVmJMNWN1ZjhHS3B3U1gzbGh3VDRZWGxvY085bWV1eDVr?=
 =?utf-8?B?aEpXTVRIQlVSRTJ5SEdjL0lyUi9KU2ZLblg3dldFVWVhRllHdmdaK0xhMU5i?=
 =?utf-8?B?N0dBOUM4UVVycFVSZnBCdWRkY1dCTTd6bmhIUjFQNFlSMCtsTDVtcC9aZjRX?=
 =?utf-8?B?WXZsOWhIdkYxUExkSDRlRmhCRFVCbzlNTDFLWDZodEJ6TkVQWW4wbDA0VHFs?=
 =?utf-8?B?bXdHWW5EdTM3VDZaL0RBdnJBWk1xZWRPK2NVcHdYaGJaQTlPZWpER2swTU9B?=
 =?utf-8?B?Z2xBa05hRTlHbDZGbE14YTRFTllBQlZKVnE5SFNpcER1bTFWNDJFOUx3RzMz?=
 =?utf-8?B?Q1JKWmU3a3FaY1pBMVpDVW1uZ0E4QXROUjJsQzEzcDB4K0EzYklFZFQrSU03?=
 =?utf-8?B?aVhGTmgwS05rTGx1ZkduWmVLTGJ2UTVIS3pNTklabzhSRW4zODZHMURuSkhk?=
 =?utf-8?B?NVdDRjZTbUtSVDV3dzRzbGJpd0sxcTJMeUhHNXNsUjlnRytpNDNGRUd1VTE1?=
 =?utf-8?B?bThWS1VwKzJpWlRDa3F4S0dQUkhPTnRPYnJiUkdhUDI5d0I5c3p0Si80MHlh?=
 =?utf-8?B?akswd2ZSUk53aXBaaTFZSndIWDBXTFdIbnYxaGZOY3FuY2tmTmYvUkx2S0I5?=
 =?utf-8?B?d2lLQ1NOVmZxdGJjc2NoMU4yTHlIMGxObkp6MVlrNUxyMWEwUDJrTGd1Y0pF?=
 =?utf-8?B?dG9sanV3SEVxT1pmVWxZM1M4R1VFQmw3SmpoMk1OWUwwUW4vWHZ3eG5wQVhM?=
 =?utf-8?B?L2FwQ0JISXZpTUlvMXNiV3NBclN5azZhNmFuL21RdXBHVGhyZ0hDY0R5bDdt?=
 =?utf-8?B?eDRHZXZwbGVzTkdYNnZUY2h1d1B6NDBDRHkwTFNucU5NK2d5eHRDWmtCdmdm?=
 =?utf-8?B?UFNUNkt6OFFjNXE4WHFvb3UxY24xalpPVy9UOUlucmJjMkdKWnZnOEVrMUNn?=
 =?utf-8?B?OGhiNjg5U1FvR205Rms3OG9WNDVuV0EzV2RtSlpNdFhJUmF6ZnU5WWlWV1lI?=
 =?utf-8?B?b1NlRXM5eDUyaFhhczlPbm5YMXFTeFlDV0RlQW1JOEhWSDA1eU51QWZOVE1F?=
 =?utf-8?B?UTdSWSs1VWRXMDhSbzh4eHVzKzZ6aUYxeERRNEVQRzRkcmpJTW9WcmxYZHZ0?=
 =?utf-8?B?elB5U05zRmV1dGhUa1hucUFoSHE3ZGV0elZvQm9zaTFDVW91RWxRZDgwN3p1?=
 =?utf-8?B?Q3pOKzlBQVFnMjA2UmpoelNGYlNGU1NHTkFpeENDdkt2ak15NU12cCsxTnlZ?=
 =?utf-8?B?YlRQMUl3K01OajV1NmZTd3N4QUFmUGJya2lCRkQxMTFiR3FhaDdJRmd0QzE2?=
 =?utf-8?B?OHV5TEZkQzBabkltaU8weVJ1dXZZVFJaeHVyMVNkUHlzbFFSSExQOUdnSVpv?=
 =?utf-8?B?OXNoYU5JNlhZaCs1NzgrNHVjcis3QjhrMHRNemtwcm1ja2JYZmg4ejdBK0ND?=
 =?utf-8?B?S3Uvc1BOUlczaUcvV0drYUFSQmYyQVVDNlpDenQxLzg5RUNaQ29lbFhia1J4?=
 =?utf-8?B?MkM2SmNEWEdkWjZ0MjlobjUwaGFiUERMMHNIbXVqaW5wNGVLTFk1TXBqdHJ3?=
 =?utf-8?B?SnVoaGlvT2tsajk5SlRBM0VtY1FVMWpBVW0wOFBLVTVtd0dBU3E3OExnZERx?=
 =?utf-8?B?YjFUT29PSjg1M1BKaE56QlJ0c2xiZ2VmT2Vwd0daYTFMR0NKNDRwT0x2YUM3?=
 =?utf-8?B?UkV5bFF5WUkrT0hEOU50aVAraytRbGx5VThGbFBRTDlzOXZmWERYeEVlTG5E?=
 =?utf-8?B?cHhVa25KQzJBaWxaME43ZVgyTndtNHVmVEp1YVVVcTdPUDhEK2pCbmFYTi94?=
 =?utf-8?B?SDdKcHBtNnIxZisyQ2M1TTR4Snh0L0tTUEx5UWRvRjZSR1J6Qk9SUUhSeS96?=
 =?utf-8?B?S1llT2RoWlNzeVNOeFhFNG14QXNYTVc0ZStVbUtNaTQwOUpYclBLS0svc01I?=
 =?utf-8?Q?0MCjCSutf+tfzYQE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: af3ea222-2abf-45f6-f615-08de5472ec07
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 20:16:09.7155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NaDdyiYdzldkjNpWH8JTrHFt6wEyu05+o2yhihlOG9wSAm5UrKKeOWN6oaPK9l4jA21gN5XQam48x8Q9UYeQnKtxS8HJO3b15E8tdvcH9sI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4732
X-OriginatorOrg: intel.com
X-Stat-Signature: 5uz5z7o6wb6bjq15wpgmyncrnn7416a7
X-Rspam-User: 
X-Rspamd-Queue-Id: CE745C000E
X-Rspamd-Server: rspam08
X-HE-Tag: 1768508174-733706
X-HE-Meta: U2FsdGVkX1+A4SafqWxJnitbF/Y1/D26CgKa5hsNjgz7Ge+SqyCJ5kO0KN+377/SUWWAcd2RTlIs4dT78bZwxBZX2y9XhIGNcgAGX9Sdaw80EIK+bRWmHYIuUSL0+7EllojnvQM4Uz8KCqtPVEErc7zwLx0mHHWFy1BLOX/qEPWbDyJyMBP3nnQRjqQsYA15SPtxSbvepyy7trqnmuLgqIycCZQEzTRTJdOVefLzgGH88YNtQsVk46T9+arnnS2ZoksxfVqAnJqvvYqzEzOXcIM07HX8DMHIiw7w/BAuJfxzp9d3MNWAXykf8zBEq5ItWqS0htWXVaJLzeaoox2u9Eak18A297JvMQnom3cVU4SJCXxRmvpFgoDlh+jN9R7GCIPdepfViUQ4qQeyFSuw8b5VD9oWICpq12SOHqas2abQtqUOrYveo1sRw358wQzjmOPChi9armvUdECiQxElv37pob5Jlz0/TWeIPlPa7BA4OfIn6z7phjsFwOcKtZZvt0lSXk341pWO7hkrqtkRM6zPT5tVfaBp7fe3QlOpw8GZ5Fgi0PBC/4Q9xkiSlaJ/sTlilUcMrENFEy7ncbSOsmaT5dCwo22Qz08LuPvfQvRhrnR3lI+senAgEgBIs+z69i1DhAAbY5aB3RYMOj1Wrc3/H9bJm3DtYPghf4OenXHvJbeeerCuWuznYkAZCcbKsEkwVaW9BmEGv55bYi+EStF83KRwXXti6ymNv7heqQN98pe/mvaf2V8+OstSTYC1o9LYX2LnbmH8PyVwR9cc2cKa0FHlMw+yOfA9YG+LP7nipzmqp/nqaZeibJDjd+2d2zblpz5zT1Lf/crsfLCe4klzPjK/J31l7bnwW5FTqHwYoYF3+GbFRZlYvSuxo06OlydY60eFGuVtBxFSImEFKJujwQTVerGlXD2DohZ48OBt0lqLgdrVaN28Y2kKE2yxdYlcTU5f+NhGRGKXqPB
 vL9IM+T+
 wlKEhZFgl0SrorITpJ5LmtBIUkG5s3w/eJ/jvov5Xh2CI/OBjSPL8XB48C6ikRQTf18ypUnPkJFd84dGXmpBJyzxZ9FF1tf26Q+AnXvWUg/d758V4vBdxKF+ABDNOP1n4+BASauuhL4gouWdxeGkA6LBVmZN32y7FNnFGC+W++v6Uyf193/Zs4CujZMD/Qinwq/r1zM5+MhB9vZAUTEjwiQvRyBnyfGpl7vmhQ7UGQ/3T3wN1FnLSnTlOrNSYXAiutVBLz+kBLLm0EILgct22OPJ6mThcp1TcYWgRHvpg3kGSDAgfNnX0XPHLYs94McvfQdhdogFf5iukOIBtJHZO82YRU6e5ElxWK8ZKKWnhvNzNhAEijADWkYUEz1qwM8tUKgck/0oyXNkCrTF03Hmdaxo7X9HHnCdXBGoGlCT3LNriYSCIWFbraaQ0CA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Hildenbrand (Red Hat) wrote:
[..]
> > Give me a list of 1Gig pages and this stuff becomes much more efficient
> > than anything the CPU can do.
> 
> Right, and ideally we'd implement any such mechanisms in a way that more 
> parts of the kernel can benefit, and not just an unloved in-memory 
> file-system that most people just want to get rid of as soon as we can :)

CPUs have tended to eat the value of simple DMA offload operations like
copy/zero over time.

In the case of this patch there is no async-offload benefit because
userspace is already charged with spawning more threads if it wants more
parallelism.

For sync-offload one engine may be able to beat a single CPU, but now
you have created bandwidth contention problems with a component that is
less responsive to the scheduler.

Call me skeptical.

Signed, someone with async_tx and dmaengine battle scars.

